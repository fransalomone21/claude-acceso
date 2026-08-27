#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
experimento.py — banco de pruebas A/B sobre el juego corriendo.

POR QUÉ EXISTE
    Las tres mediciones de la noche del 2026-08-17 fallaron por el
    instrumento, no por el análisis:

      1. **La muerte truncó la ventana.** Se midió 60 s de "jugador bajo
         fuego"; el jugador murió al segundo 55 y los últimos 5 s midieron una
         pantalla de derrota. Peor: la condición B entera midió esa pantalla.
      2. **La condición inicial no era repetible.** "Ponete cerca de dos
         tiradores" no vuelve a ser el mismo estado nunca. Sin el mismo punto
         de partida, A y B no son comparables.
      3. **n = 10.** Con diez impactos por condición, cualquier diferencia
         entra en el ruido.

    Los tres tienen arreglo mecánico, y este archivo es ese arreglo.

CÓMO LOS ARREGLA

    1. **Vida inflada durante la medición.** La vida acá no es la vida: es un
       CONTADOR DE IMPACTOS. Se le escribe un valor enorme antes de cada
       ventana, así nada la corta y además desaparece el ruido de la
       regeneración, que no sube lo que ya está por encima del máximo.

    2. **Savestate como condición inicial.** Cada ventana arranca cargando el
       MISMO savestate. Es la única forma de que dos condiciones compartan
       posición, enemigos, munición y cobertura. PCSX2 carga de forma
       asíncrona, así que se espera a que una dirección conocida dé el valor
       esperado antes de medir — no se duerme un rato y se cruzan los dedos.

    3. **Alternancia A/B/A/B con repeticiones.** Alternar controla la deriva
       (enemigos que mueren, munición que se acaba); repetir baja el ruido.
       Nunca A,A,A luego B,B,B: si algo se degrada con el tiempo, eso lo lee
       como efecto del tratamiento.

    Y una cuarta, que no es de medición sino de honestidad:

    4. **La predicción se escribe ANTES de correr.** `--predigo` deja anotado
       en el informe qué se esperaba. Una hipótesis que se formula después de
       ver el resultado siempre acierta.

LO QUE ESTO NO ARREGLA
    Que el efecto medido sea del campo que uno cree. Esto compara dos
    condiciones; que la diferencia se deba a `Time Between Bullets` y no a otra
    cosa que ese mismo campo toque es interpretación, y necesita un
    experimento distinto para descartarla.

CLI
    python herramientas/experimento.py campo-arma --slot 4 --offset 0x20 \\
        --factor 0.2 --repeticiones 3 --segundos 40 \\
        --predigo "mas impactos por minuto si +0x20 es tiempo entre balas"
"""

from __future__ import annotations

import argparse
import json
import statistics
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402

VIDA_JUGADOR = 0x005A8DA8
TABLA_ARMAS = 0x01842220        # se VERIFICA antes de usarse, no se supone
PASO_ARMA = 0x1E0
N_ARMAS = 17
BLOQUE_IA = 0xC0
BLOQUE_JUGADOR = 0x90
VIDA_INFLADA = 1.0e6


def verificar_tabla(p: Pine, tabla: int) -> None:
    """Precondición: el registro 2 tiene que ser el Magnum (Range 1000, Power 500).

    Una dirección de heap que "casi siempre" está bien es exactamente la que
    un día no está y hace escribir 34 floats en cualquier lado."""
    r = tabla + 2 * PASO_ARMA + BLOQUE_JUGADOR
    rango = p.leer_f32(r + 0x14)
    power = p.leer_f32(r + 0x18)
    if abs(rango - 1000.0) > 1 or abs(power - 500.0) > 1:
        raise SystemExit(
            "  ABORTA: en 0x%08X no está la tabla de armas.\n"
            "  El registro 2 debería ser el Magnum (Range 1000 / Power 500) y "
            "da %g / %g.\n"
            "  Buscala con: python herramientas/armas.py listar <volcado>"
            % (tabla, rango, power))


def leer_campo(p: Pine, tabla: int, offset: int, bloque: int) -> list[float]:
    return [p.leer_f32(tabla + i * PASO_ARMA + bloque + offset)
            for i in range(N_ARMAS)]


def escribir_campo(p: Pine, tabla: int, offset: int, bloque: int,
                   valores: list[float]) -> None:
    for i, v in enumerate(valores):
        p.escribir_f32(tabla + i * PASO_ARMA + bloque + offset, v)


def cargar_y_esperar(p: Pine, slot: int, tope: float = 25.0) -> float:
    """Carga el savestate y espera a que el juego vuelva de verdad.

    'Volvió' = la vida del jugador es un número de partida (>0 y finito). No se
    duerme un tiempo fijo: en una máquina cargada eso mide otra cosa.

    El techo es 1e9 y no 1e5 a propósito: **el savestate de trabajo se guarda
    con la vida ya inflada**, que es mejor que inflarla después de cargar
    —arranca con el colchón puesto desde el frame cero— y haría fallar un
    chequeo que exigiera un número de partida normal."""
    p.cargar_estado(slot)
    t0 = time.time()
    while time.time() - t0 < tope:
        time.sleep(0.4)
        try:
            v = p.leer_f32(VIDA_JUGADOR)
        except Exception:
            continue
        if 0.0 < v < 1e9:
            time.sleep(0.6)          # que termine de asentarse
            return v
    raise SystemExit("  el savestate %d no terminó de cargar en %gs" % (slot, tope))


def medir(p: Pine, segundos: float, hz: float) -> list[tuple[float, float]]:
    """Serie (t, vida). Se infla la vida al empezar: acá es un contador."""
    p.escribir_f32(VIDA_JUGADOR, VIDA_INFLADA)
    serie = []
    t0 = time.time()
    paso = 1.0 / hz
    siguiente = t0
    while True:
        ahora = time.time()
        if ahora - t0 >= segundos:
            break
        if ahora < siguiente:
            time.sleep(min(paso / 4, siguiente - ahora))
            continue
        siguiente += paso
        try:
            serie.append((ahora - t0, p.leer_f32(VIDA_JUGADOR)))
        except Exception:
            pass
    return serie


def impactos(serie: list[tuple[float, float]], minimo: float = 0.5) -> list[tuple[float, float]]:
    """(t, tamaño) de cada bajada. Las subidas son regeneración y se ignoran."""
    out = []
    for k in range(1, len(serie)):
        d = serie[k - 1][1] - serie[k][1]
        if d >= minimo:
            out.append((serie[k][0], d))
    return out


def resumen(golpes: list[tuple[float, float]], segundos: float,
            corte_rafaga: float = 0.6) -> dict:
    """Estadística separando ráfagas de pausas.

    **Los impactos por minuto NO sirven para medir cadencia**, y la razón la
    dio Fran mirando la pantalla: los enemigos disparan, se cubren y recargan.
    O sea que el volumen total de fuego lo gobierna ese ciclo de cobertura, no
    el tiempo entre balas. Medir el total y no ver diferencia no falsifica
    nada; mide otra cosa.

    Lo que sí mide la cadencia es el hueco DENTRO de una ráfaga. Se parten los
    intervalos en dos poblaciones por un corte, y se informan separadas:

      - huecos cortos  (< corte)  -> tiempo entre balas de la misma ráfaga
      - huecos largos  (>= corte) -> cubrirse, recargar, reposicionarse

    Si `+0x20` es 'Time Between Bullets', al bajarlo tiene que encogerse la
    mediana de los CORTOS, y los largos deberían quedar donde estaban."""
    tam = [g for _, g in golpes]
    ts = [t for t, _ in golpes]
    huecos = [ts[i + 1] - ts[i] for i in range(len(ts) - 1)]
    cortos = [h for h in huecos if h < corte_rafaga]
    largos = [h for h in huecos if h >= corte_rafaga]
    return {
        "impactos": len(golpes),
        "por_minuto": round(len(golpes) * 60.0 / segundos, 2),
        "dano_total": round(sum(tam), 2),
        "dano_mediano": round(statistics.median(tam), 3) if tam else 0,
        "rafagas": len(largos) + 1 if golpes else 0,
        "impactos_por_rafaga": round(len(golpes) / (len(largos) + 1), 2) if golpes else 0,
        "intra_rafaga_n": len(cortos),
        "intra_rafaga_ms": round(statistics.median(cortos) * 1000, 1) if cortos else None,
        "entre_rafagas_ms": round(statistics.median(largos) * 1000, 1) if largos else None,
    }


def cmd_campo_arma(args) -> int:
    salida = Path(args.salida)
    salida.parent.mkdir(parents=True, exist_ok=True)

    with Pine() as p:
        verificar_tabla(p, args.tabla)
        bloque = {"ia": BLOQUE_IA, "jugador": BLOQUE_JUGADOR}[args.bloque]
        originales = leer_campo(p, args.tabla, args.offset, bloque)
        tratados = [v * args.factor for v in originales]

        print("\n  EXPERIMENTO: campo +0x%02X del bloque %s" % (args.offset, args.bloque))
        print("  predicción registrada ANTES de correr:")
        print("    %s" % (args.predigo or "(ninguna — el resultado no va a poder sorprender a nadie)"))
        print("  control    : %s" % " ".join("%g" % v for v in originales[:8]))
        print("  tratamiento: %s  (x%g)" % (" ".join("%g" % v for v in tratados[:8]), args.factor))
        print("  %d repeticiones de %gs por condición, alternando A/B\n"
              % (args.repeticiones, args.segundos))

        rondas = []
        try:
            for r in range(args.repeticiones):
                for etiqueta, valores in (("A_control", originales),
                                          ("B_tratamiento", tratados)):
                    vida0 = cargar_y_esperar(p, args.slot)
                    escribir_campo(p, args.tabla, args.offset, bloque, valores)
                    serie = medir(p, args.segundos, args.hz)
                    g = impactos(serie)
                    res = resumen(g, args.segundos)
                    res.update({"ronda": r, "condicion": etiqueta,
                                "vida_al_cargar": round(vida0, 2),
                                "muestras": len(serie)})
                    rondas.append(res)
                    print("    r%d %-14s impactos %-4d  intra-ráfaga %s ms (n=%d)"
                          "   entre ráfagas %s ms   daño med %s"
                          % (r, etiqueta, res["impactos"],
                             res["intra_rafaga_ms"], res["intra_rafaga_n"],
                             res["entre_rafagas_ms"], res["dano_mediano"]))
        finally:
            # Pase lo que pase, la máquina no queda modificada.
            escribir_campo(p, args.tabla, args.offset, bloque, originales)
            print("\n  campo restaurado a los valores originales")

    def agregado(cond, clave):
        xs = [r[clave] for r in rondas
              if r["condicion"] == cond and r.get(clave) is not None]
        return (round(statistics.mean(xs), 2) if xs else None,
                round(statistics.pstdev(xs), 2) if len(xs) > 1 else None)

    print("\n  " + "-" * 66)
    for clave, etiqueta, sentido in (
            ("intra_rafaga_ms", "hueco DENTRO de la ráfaga (ms)", "la cadencia"),
            ("entre_rafagas_ms", "hueco ENTRE ráfagas (ms)", "cubrirse y recargar"),
            ("por_minuto", "impactos por minuto", "volumen total"),
            ("impactos_por_rafaga", "impactos por ráfaga", "largo de la ráfaga")):
        a_m, a_s = agregado("A_control", clave)
        b_m, b_s = agregado("B_tratamiento", clave)
        linea = ("  %-32s control %-9s (±%-6s) tratamiento %-9s (±%s)"
                 % (etiqueta, a_m, a_s, b_m, b_s))
        if a_m and b_m:
            linea += "   x%.2f" % (b_m / a_m)
        print(linea)
        if (a_m and b_m and a_s is not None and b_s is not None
                and (a_s + b_s) > 0):
            sep = abs(b_m - a_m) / (a_s + b_s)
            print("      separación entre medias: %.1f dispersiones — %s   [%s]"
                  % (sep,
                     "supera el ruido" if sep >= 2 else "NO supera el ruido",
                     sentido))

    informe = {
        "campo": "+0x%02X" % args.offset, "bloque": args.bloque,
        "factor": args.factor, "slot": args.slot,
        "segundos_por_ventana": args.segundos,
        "prediccion": args.predigo,
        "valores_control": originales, "valores_tratamiento": tratados,
        "rondas": rondas,
    }
    salida.write_text(json.dumps(informe, indent=1, ensure_ascii=False),
                      encoding="utf-8")
    print("  informe: %s" % salida)
    return 0


def _entero(t: str) -> int:
    return int(t, 0)


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Banco de experimentos A/B sobre el juego corriendo",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="Necesita PCSX2 con PINE y un savestate DENTRO de un nivel, "
               "con enemigos disparando.")
    sub = p.add_subparsers(dest="cmd", required=True)

    c = sub.add_parser("campo-arma",
                       help="efecto de un campo de la tabla de armas sobre "
                            "el fuego que recibe el jugador")
    c.add_argument("--slot", type=int, required=True,
                   help="savestate con el jugador bajo fuego: la condición inicial")
    c.add_argument("--offset", type=_entero, required=True,
                   help="offset dentro del bloque (0x18 Power, 0x20 candidato "
                        "a segundos entre balas)")
    c.add_argument("--factor", type=float, required=True)
    c.add_argument("--bloque", choices=["ia", "jugador"], default="ia")
    c.add_argument("--repeticiones", type=int, default=3)
    c.add_argument("--segundos", type=float, default=40.0)
    c.add_argument("--hz", type=float, default=30.0)
    c.add_argument("--tabla", type=_entero, default=TABLA_ARMAS)
    c.add_argument("--predigo", help="qué esperás que pase. Se guarda en el informe.")
    c.add_argument("--salida", default="volcados/experimento.json")
    c.set_defaults(func=cmd_campo_arma)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
