#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ubicaciones.py — dónde vive cada archivo del proyecto que NO está en el repo.

POR QUÉ EXISTE
    El 2026-08-21 se perdieron dos turnos por rutas: `ESTADO_ACTUAL.md` decía
    que el proyecto de Ghidra estaba en `~\\ghidra-proyectos2\\BLACK` (no
    existe; el real es `~\\herramientas\\ghidra-proyectos2`), y encima
    `Test-Path` dio False sobre la carpeta de los ISOs — que sí existía —
    porque los corchetes de `Black [NTSC]` son wildcard en PowerShell si no
    se pasa `-LiteralPath`.

    Las dos fallas tienen la misma forma: una ruta escrita en prosa, en un
    documento, que nadie mide. `inventario.py` contesta "qué instrumental hay
    en esta máquina"; esto contesta la otra mitad, "DÓNDE está cada cosa", y
    lo hace midiendo.

    Las rutas viven en `kb/ubicaciones.json`, en un solo lugar. Ningún
    documento ni script debería repetirlas: se piden con `ruta <clave>`.

CLI
    python herramientas/ubicaciones.py                 # verificar todo
    python herramientas/ubicaciones.py --json out.json
    python herramientas/ubicaciones.py ruta iso_original
    python herramientas/ubicaciones.py listar

CÓDIGO DE SALIDA
    0 si todo lo `critico` está; 1 si falta algo crítico o no coincide el
    tamaño. Pensado para encadenar: si esto da 1, no arranques el experimento.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402

RAIZ = Path(__file__).resolve().parent.parent
KB = RAIZ / "kb" / "ubicaciones.json"


def cargar() -> dict:
    if not KB.exists():
        raise SystemExit(f"no existe {KB}")
    with open(KB, encoding="utf-8") as fh:
        return json.load(fh)


def revisar_una(clave: str, ficha: dict) -> dict:
    """Mide UNA ruta. os.path, no PowerShell: los corchetes no son wildcard."""
    ruta = ficha["ruta"]
    tipo = ficha.get("tipo", "archivo")
    existe = os.path.exists(ruta)

    forma_ok = True
    tam_real = None
    detalle = ""

    if existe:
        if tipo == "carpeta":
            forma_ok = os.path.isdir(ruta)
            if not forma_ok:
                detalle = "existe pero es un archivo, no una carpeta"
            else:
                try:
                    tam_real = len(os.listdir(ruta))
                    detalle = f"{tam_real} entradas"
                except OSError as exc:
                    forma_ok = False
                    detalle = f"no se puede listar: {exc}"
        else:
            forma_ok = os.path.isfile(ruta)
            if not forma_ok:
                detalle = "existe pero es una carpeta, no un archivo"
            else:
                tam_real = os.path.getsize(ruta)
                esperado = ficha.get("tam")
                if esperado is not None and tam_real != esperado:
                    forma_ok = False
                    detalle = f"tamaño {tam_real} != esperado {esperado}"
                else:
                    detalle = f"{tam_real} B"

    return {
        "clave": clave,
        "ruta": ruta,
        "tipo": tipo,
        "critico": bool(ficha.get("critico")),
        "que_es": ficha.get("que_es", ""),
        "ok": existe and forma_ok,
        "existe": existe,
        "detalle": detalle,
        "tam_real": tam_real,
    }


def revisar(datos: dict) -> list[dict]:
    return [revisar_una(k, v) for k, v in datos["rutas"].items()]


def main(argv=None) -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(
        description="dónde vive cada archivo del proyecto, medido de verdad",
        epilog=f"fuente: {KB}",
    )
    sub = ap.add_subparsers(dest="cmd")
    sub.add_parser("verificar", help="medir todas las rutas (por defecto)")
    p_ruta = sub.add_parser("ruta", help="imprimir UNA ruta, para usar en scripts")
    p_ruta.add_argument("clave")
    p_ruta.add_argument("--sin-verificar", action="store_true",
                        help="imprimirla aunque no exista")
    sub.add_parser("listar", help="las claves disponibles")
    ap.add_argument("--json", metavar="ARCHIVO", help="volcar el resultado a JSON")
    args = ap.parse_args(argv)

    datos = cargar()

    if args.cmd == "listar":
        for k, v in datos["rutas"].items():
            print(f"{k:24s} {v.get('que_es','')}")
        return 0

    if args.cmd == "ruta":
        ficha = datos["rutas"].get(args.clave)
        if ficha is None:
            print(f"no conozco la clave {args.clave!r}. "
                  f"Probá: python herramientas/ubicaciones.py listar", file=sys.stderr)
            return 2
        r = revisar_una(args.clave, ficha)
        if not r["ok"] and not args.sin_verificar:
            print(f"la ruta de {args.clave!r} NO verifica: {r['ruta']} "
                  f"({r['detalle'] or 'no existe'})", file=sys.stderr)
            return 1
        print(r["ruta"])
        return 0

    filas = revisar(datos)

    print(f"UBICACIONES DEL PROYECTO — fuente: kb/ubicaciones.json\n")
    for r in filas:
        marca = "OK   " if r["ok"] else ("ROTO " if r["existe"] else "FALTA")
        crit = "*" if r["critico"] else " "
        print(f"{marca}{crit} {r['clave']:22s} {r['detalle']}")
        print(f"        {r['ruta']}")
        if not r["ok"]:
            print(f"        -> {r['que_es']}")

    print("\nmontajes (se miden con Get-DiskImage, no se suponen por letra):")
    for k, v in datos.get("montajes", {}).items():
        if not k.startswith("_"):
            print(f"  {k}  {v}")

    faltan = [r for r in filas if not r["ok"]]
    criticos = [r for r in faltan if r["critico"]]
    print(f"\n{len(filas) - len(faltan)}/{len(filas)} verifican."
          f"  Críticos rotos: {len(criticos)}")
    if criticos:
        print("  " + ", ".join(r["clave"] for r in criticos))
        print("\nSi una ruta se movió, se corrige en kb/ubicaciones.json — "
              "en UN solo lugar — y no en los documentos.")

    if args.json:
        with open(args.json, "w", encoding="utf-8") as fh:
            json.dump({"rutas": filas, "montajes": datos.get("montajes", {})},
                      fh, indent=2, ensure_ascii=False)
        print(f"\nJSON -> {args.json}")

    return 1 if criticos else 0


if __name__ == "__main__":
    raise SystemExit(main())
