#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mando_j2.py -- un mando FALSO para J2 (93y): apretar sus botones sin nadie en el mando 2.

Es el mismo truco de sondas_coop.py (77) para J, sobre el control de J2: el control guarda en +0xC el
puntero al mando procesado de su puerto; se lo cambia por una copia en memoria libre (FALSO2) y ahi se
escriben los botones. El juego lee la copia en vez del mando real.

    python herramientas/mando_j2.py poner                 # en pausa o en juego
    python herramientas/mando_j2.py boton melee 0.3       # aprieta 0,3 s y suelta; imprime el estado del arma
    python herramientas/mando_j2.py boton recargar 0.3 --mirar 8   # y sigue mirando 8 s el estado del arma
    python herramientas/mando_j2.py estado                # arma en la mano de J2, su estado y el cargador
    python herramientas/mando_j2.py quitar                # devuelve el puntero al mando real

El control de J2: *(J2+0x588) (medido en (90): J2+0x588/+0x6D0/+0x7C8 apuntan al mismo, el del puerto
que J NO usa). FALSO2 = clon_jugador.FALSO2 (0x00472100), el mismo de `coop_mod.py manos`.
Botones: los indices de sondas_coop.BOTONES (77) + 'melee' = 3 (hipotesis (93y): el b3 del video de Fran
con el circulo; (77) lo anoto como 'estado del arma 28/29').
"""
from __future__ import annotations

import argparse
import json
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import clon_jugador as cj  # noqa: E402
from sondas_coop import BOTONES  # noqa: E402

FALSO2 = cj.FALSO2            # el MISMO falso 2 que usa `coop_mod.py manos` (0x00472100): no hay dos
NOMBRES = dict(BOTONES, melee=3)


def control(p: Pine) -> int:
    return p.leer32(cj.J2 + 0x588)


def poner(p: Pine) -> dict:
    c = control(p)
    # (86) J2 recien copiado tiene el control DE J: sin este freno se le redirige a J el mando al falso
    if not c or c == p.leer32(p.leer32(cj.JUEGO_PTR) + 0x30 + 0x588):
        raise RuntimeError("el mod todavia no preparo el control de J2 (J2+0x588 = %#x)" % c)
    real = p.leer32(c + 0xC)
    if real == FALSO2:              # ya puesto (p. ej. por `coop_mod.py manos`): se sueltan los botones
        for i in range(28):
            boton(p, i, False)
        return {"control": hex(c), "ya_puesto": True}
    blk = bytearray(p.leer_bloque(real, 0xF0))
    for o in range(0x8C, 0xCC, 4):          # ejes en cero
        blk[o:o + 4] = b"\0\0\0\0"
    for i in range(28):                      # botones sueltos
        blk[0x0E + i] = 0; blk[0x2A + i] = 0
        blk[0x4C + 4 * i:0x50 + 4 * i] = b"\0\0\0\0"
    p.escribir_bloque(FALSO2, bytes(blk))
    p.escribir32(FALSO2 + 0xEC, real)        # se guarda el real al final del bloque, para quitar
    p.escribir32(c + 0xC, FALSO2)
    return {"control": hex(c), "real": hex(real)}


def quitar(p: Pine) -> dict:
    c = control(p)
    real = p.leer32(FALSO2 + 0xEC)
    if p.leer32(c + 0xC) == FALSO2 and real:
        p.escribir32(c + 0xC, real)
    return {"control": hex(c), "repuesto": hex(p.leer32(c + 0xC))}


def boton(p: Pine, i: int, apretado: bool) -> None:
    p.escribir8(FALSO2 + 0x0E + i, 0)
    p.escribir8(FALSO2 + 0x2A + i, 1 if apretado else 0)
    p.escribir_f32(FALSO2 + 0x4C + 4 * i, 1.0 if apretado else 0.0)


def estado(p: Pine) -> dict:
    arma = p.leer32(cj.J2 + 0x2A4)
    sub = p.leer32(arma + 0xF4) if arma else 0
    return {"arma": hex(arma), "estado_D8": p.leer32(arma + 0xD8) if arma else None,
            "cargador": struct.unpack("<H", p.leer_bloque(sub + 0x18, 2))[0] if sub else None,
            "J2_330": hex(p.leer32(cj.J2 + 0x330)), "falso": p.leer32(control(p) + 0xC) == FALSO2}


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("poner"); sub.add_parser("quitar"); sub.add_parser("estado")
    b = sub.add_parser("boton"); b.add_argument("nombre"); b.add_argument("segundos", type=float)
    b.add_argument("--mirar", type=float, default=3.0, help="segundos de estado del arma despues de soltar")
    x = ap.parse_args()
    with Pine() as p:
        if x.cmd == "poner":
            print(json.dumps(poner(p)))
        elif x.cmd == "quitar":
            print(json.dumps(quitar(p)))
        elif x.cmd == "estado":
            print(json.dumps(estado(p)))
        else:
            i = NOMBRES[x.nombre] if x.nombre in NOMBRES else int(x.nombre)
            serie, t0 = [], time.time()
            boton(p, i, True)
            fin_boton, fin = t0 + x.segundos, t0 + x.segundos + x.mirar
            soltado = False
            while time.time() < fin:
                if not soltado and time.time() >= fin_boton:
                    boton(p, i, False); soltado = True
                e = estado(p)
                if not serie or (e["estado_D8"], e["cargador"]) != (serie[-1][1], serie[-1][2]):
                    serie.append((round(time.time() - t0, 2), e["estado_D8"], e["cargador"]))
                time.sleep(0.03)
            if not soltado:
                boton(p, i, False)
            print(json.dumps({"boton": i, "cambios_estado_cargador": serie, "final": estado(p)}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
