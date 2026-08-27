#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
volcar_vivo.py — vuelca un rango de la RAM del EE a un archivo, por DebugServer.

Por qué existe teniendo `pine.py volcar` y `estado.py extraer`:

    pine.py    lee de a 8 bytes por viaje de ida y vuelta. Para los 2.8 MB de
               la región de código son ~350 mil viajes: inservible.
    estado.py  necesita un savestate en disco, y el PCSX2 parcheado se declara
               versión "Unknown", así que no lee los savestates viejos ni los
               suyos son portables al oficial.
    este       usa `read_memory` del DebugServer, que trae hasta 64 KB por
               viaje: los mismos 2.8 MB salen en ~44 pedidos.

USO
    python volcar_vivo.py 0x00100000 0x003C0000 ../volcados/codigo.bin
"""

from __future__ import annotations

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from depurador import Depurador, DepuradorError  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402

# Tope que impone el C++ (DebugServer.cpp: `if (len > 65536) len = 65536`).
TROZO = 65536


def volcar(d: Depurador, desde: int, hasta: int, destino: str) -> int:
    total = hasta - desde
    escritos = 0
    with open(destino, "wb") as f:
        for base in range(desde, hasta, TROZO):
            largo = min(TROZO, hasta - base)
            f.write(d.leer(base, largo))
            escritos += largo
            pct = 100 * escritos // total
            print(f"\r  {escritos:>9}/{total} bytes ({pct:>3}%)", end="", flush=True)
    print()
    return escritos


def main(argv=None) -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(
        description="Vuelca un rango de la RAM del EE por DebugServer")
    ap.add_argument("desde", type=lambda s: int(s, 0))
    ap.add_argument("hasta", type=lambda s: int(s, 0))
    ap.add_argument("destino")
    ap.add_argument("--puerto", type=int, default=21512)
    args = ap.parse_args(argv)

    if args.hasta <= args.desde:
        print("error: 'hasta' tiene que ser mayor que 'desde'", file=sys.stderr)
        return 2

    try:
        with Depurador(puerto=args.puerto) as d:
            print(f"volcando 0x{args.desde:08X}-0x{args.hasta:08X} -> {args.destino}")
            n = volcar(d, args.desde, args.hasta, args.destino)
    except DepuradorError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    print(f"{n} bytes escritos en {args.destino}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
