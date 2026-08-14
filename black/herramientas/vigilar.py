#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
vigilar.py — muestrea direcciones en vivo por PINE y analiza cómo cambian
en el tiempo.

PARA QUÉ
    Hay preguntas que un valor suelto no contesta y una serie temporal sí:
      · ¿la vida se regenera? ¿cada cuánto? ¿de a cuánto?
      · ¿el daño de un arma es fijo o tiene dispersión?
      · ¿este contador es el de enemigos vivos o el de enemigos totales?
    Este comando graba la serie y después la lee: detecta los escalones,
    mide el intervalo entre ellos y te dice el tamaño del salto.

USO
    # grabar 30 segundos a 20 Hz mientras jugás
    python3 vigilar.py grabar --dir 0x2038A0:vida --dir 0x2038A4:vida_max \\
        --hz 20 --segundos 30 --salida ../volcados/regen.csv

    # analizar los escalones de una columna
    python3 vigilar.py analizar ../volcados/regen.csv --columna vida

    # o directo desde el mapa de memoria del proyecto
    python3 vigilar.py grabar --de-kb vida_jugador --segundos 30
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import statistics
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pine import Pine, PineError  # noqa: E402

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KB = os.path.join(RAIZ, "kb")

ANCHOS = {"u8": 1, "u16": 2, "u32": 4, "u64": 8,
          "i8": 1, "i16": 2, "i32": 4, "i64": 8, "f32": 4}


class VigilarError(RuntimeError):
    pass


def parsear_objetivo(texto: str) -> dict:
    """'0x2038A0:vida:u32' -> {direccion, nombre, tipo}. tipo por defecto u32."""
    partes = texto.split(":")
    if not partes[0]:
        raise VigilarError(f"objetivo inválido: {texto}")
    direccion = int(partes[0], 0)
    nombre = partes[1] if len(partes) > 1 and partes[1] else f"0x{direccion:08X}"
    tipo = partes[2] if len(partes) > 2 else "u32"
    if tipo not in ANCHOS:
        raise VigilarError(f"tipo desconocido: {tipo}")
    return {"direccion": direccion, "nombre": nombre, "tipo": tipo}


def objetivos_de_kb(ids: list[str]) -> list[dict]:
    ruta = os.path.join(KB, "mapa-memoria.json")
    if not os.path.exists(ruta):
        raise VigilarError(f"no existe {ruta}")
    with open(ruta) as f:
        mapa = json.load(f)
    por_id = {e["id"]: e for e in mapa.get("entradas", [])}
    salida = []
    for i in ids:
        if i not in por_id:
            raise VigilarError(
                f"'{i}' no está en kb/mapa-memoria.json. "
                f"Conocidos: {', '.join(por_id) or '(ninguno todavía)'}"
            )
        e = por_id[i]
        if e.get("direccion") is None:
            raise VigilarError(f"'{i}' todavía no tiene dirección asignada")
        salida.append(
            {"direccion": int(str(e["direccion"]), 0),
             "nombre": e["id"], "tipo": e.get("tipo", "u32")}
        )
    return salida


def grabar(objetivos: list[dict], hz: float, segundos: float, salida: str) -> str:
    periodo = 1.0 / hz
    os.makedirs(os.path.dirname(os.path.abspath(salida)) or ".", exist_ok=True)
    columnas = ["t"] + [o["nombre"] for o in objetivos]
    n = 0
    t0 = time.perf_counter()

    with Pine() as p, open(salida, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(columnas)
        print(f"grabando {len(objetivos)} dirección(es) a {hz} Hz durante {segundos}s…")
        print("(Ctrl-C corta y guarda lo que haya)")
        try:
            while (t := time.perf_counter() - t0) < segundos:
                fila = [f"{t:.4f}"]
                for o in objetivos:
                    if o["tipo"] == "f32":
                        fila.append(p.leer_f32(o["direccion"]))
                    else:
                        fila.append(
                            p.leer(o["direccion"], ANCHOS[o["tipo"]],
                                   con_signo=o["tipo"][0] == "i")
                        )
                w.writerow(fila)
                n += 1
                siguiente = t0 + n * periodo
                resto = siguiente - time.perf_counter()
                if resto > 0:
                    time.sleep(resto)
        except KeyboardInterrupt:
            print("\ncortado a mano")
    print(f"{n} muestras -> {salida}")
    return salida


def analizar(ruta: str, columna: str | None, tolerancia: float) -> None:
    with open(ruta) as f:
        filas = list(csv.DictReader(f))
    if not filas:
        raise VigilarError("el CSV está vacío")
    columnas = [c for c in filas[0] if c != "t"]
    objetivo = columna or columnas[0]
    if objetivo not in columnas:
        raise VigilarError(f"columna '{objetivo}' no está. Hay: {', '.join(columnas)}")

    ts = [float(r["t"]) for r in filas]
    vs = [float(r[objetivo]) for r in filas]

    print(f"columna     : {objetivo}")
    print(f"muestras    : {len(vs)}  en {ts[-1] - ts[0]:.2f}s "
          f"({len(vs) / max(ts[-1] - ts[0], 1e-9):.1f} Hz efectivos)")
    print(f"rango       : {min(vs):g} .. {max(vs):g}")

    # Escalones: puntos donde el valor cambia respecto de la muestra anterior.
    escalones = []
    for i in range(1, len(vs)):
        d = vs[i] - vs[i - 1]
        if abs(d) > tolerancia:
            escalones.append((ts[i], d))

    if not escalones:
        print("\nno hubo cambios: el valor quedó quieto en toda la grabación")
        return

    subidas = [(t, d) for t, d in escalones if d > 0]
    bajadas = [(t, d) for t, d in escalones if d < 0]
    print(f"\ncambios     : {len(escalones)}  ({len(subidas)} subidas, {len(bajadas)} bajadas)")

    for etiqueta, grupo in (("SUBIDAS", subidas), ("BAJADAS", bajadas)):
        if not grupo:
            continue
        deltas = [abs(d) for _, d in grupo]
        print(f"\n  {etiqueta}")
        print(f"    tamaño del salto : min {min(deltas):g}  mediana "
              f"{statistics.median(deltas):g}  max {max(deltas):g}")
        if len(set(round(d, 6) for d in deltas)) == 1:
            print(f"    -> salto CONSTANTE de {deltas[0]:g}")
        if len(grupo) >= 3:
            intervalos = [grupo[i][0] - grupo[i - 1][0] for i in range(1, len(grupo))]
            med = statistics.median(intervalos)
            disp = statistics.pstdev(intervalos) if len(intervalos) > 1 else 0.0
            print(f"    intervalo        : mediana {med * 1000:.0f} ms  "
                  f"(±{disp * 1000:.0f} ms)")
            if med > 0 and disp / med < 0.25:
                print(f"    -> ritmo REGULAR: ~{1 / med:.2f} veces por segundo")
                if len(set(round(d, 6) for d in deltas)) == 1:
                    print(f"    -> tasa efectiva: {deltas[0] / med:.2f} unidades/segundo")
        print("    primeros:", ", ".join(f"t={t:.2f}s Δ{d:+g}" for t, d in grupo[:5]))


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Muestreo temporal de memoria por PINE")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_g = sub.add_parser("grabar", help="graba una serie temporal a CSV")
    p_g.add_argument("--dir", action="append", default=[],
                     metavar="DIRECCION[:nombre[:tipo]]",
                     help="dirección a vigilar; repetible")
    p_g.add_argument("--de-kb", action="append", default=[], metavar="ID",
                     help="id de kb/mapa-memoria.json; repetible")
    p_g.add_argument("--hz", type=float, default=20.0)
    p_g.add_argument("--segundos", type=float, default=30.0)
    p_g.add_argument("--salida", default=None)

    p_a = sub.add_parser("analizar", help="detecta escalones, ritmo y tasa")
    p_a.add_argument("csv")
    p_a.add_argument("--columna")
    p_a.add_argument("--tolerancia", type=float, default=0.0)

    args = ap.parse_args(argv)
    try:
        if args.cmd == "grabar":
            objetivos = [parsear_objetivo(t) for t in args.dir]
            objetivos += objetivos_de_kb(args.de_kb)
            if not objetivos:
                raise VigilarError("no diste ninguna dirección (--dir o --de-kb)")
            salida = args.salida or os.path.join(
                RAIZ, "volcados", f"vigilancia-{int(time.time())}.csv"
            )
            grabar(objetivos, args.hz, args.segundos, salida)
        else:
            analizar(args.csv, args.columna, args.tolerancia)
    except (VigilarError, PineError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
