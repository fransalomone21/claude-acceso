#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
armas_j2.py -- (93y) que armas tiene J2 y cual tiene en la mano, al lado de J. Contesta por que el cambio de
arma (arma_b) no hace nada en J2: si su arreglo de armas tiene una sola.

    python herramientas/armas_j2.py            # sobre el emulador abierto (J2 armado)
    python herramientas/armas_j2.py --lanzar   # lanza el fork, carga City Streets y mira

El manejador de armas esta embebido en J+0x280 (93s): +0x2A0 el arreglo de armas (J2: ARMAS2 0x0046DBC0),
+0x2A4 la de la mano, +0x2C3 su indice.
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
import clon_jugador as cj  # noqa: E402


def armas(p, P):
    arr = p.leer32(P + 0x2A0)
    lista = [p.leer32(arr + 4 * i) for i in range(8)] if arr else []
    return {"arreglo": hex(arr), "armas": [hex(x) for x in lista], "mano": hex(p.leer32(P + 0x2A4)),
            "indice_2C3": p.leer8(P + 0x2C3), "reserva_280": [p.leer16(P + 0x280 + 2 * i) for i in range(4)],
            "estados": [p.leer32(x + 0xD8) if 0x100000 < x < 0x2000000 else None for x in lista]}


def main():
    if "--lanzar" in sys.argv:
        import campana_coop as cc
        if not cc.lanzar():
            print("el fork no quedo vivo"); return 1
        cc.probar_nivel(0)
    with Pine() as p:
        print(json.dumps({"J": armas(p, cj.J), "J2": armas(p, cj.J2)}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
