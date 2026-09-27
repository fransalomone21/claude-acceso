#!/usr/bin/env python3
"""clon_jugador.py -- un segundo bloque de jugador por PINE, sin constructor (bitacora (78), P4).

Copia el bloque del jugador 0 (0x8C0 B) a memoria libre, reubica sus
autopunteros, le da el mando 2 (con un mando falso propio) y lo engancha a la
lista del mundo (juego+0x5CA4) con +0xC4 = 0, para que la pasada que llama el
metodo +0xC de cada entidad lo actualice. Es la prueba barata de "que hace
falta para que un bloque fuera de jugadores[] se mueva"; el camino completo
(el constructor del juego, FUN_00139c68) necesita codigo nuevo (sonda 6).

    python herramientas/clon_jugador.py poner [--sin-enganche]
    python herramientas/clon_jugador.py enganchar
    python herramientas/clon_jugador.py empujar adelante 0.8 1.0
    python herramientas/clon_jugador.py estado
    python herramientas/clon_jugador.py quitar          # lo saca de la lista
"""

import argparse
import json
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import sondas_coop as sc  # noqa: E402

J = sc.JUGADOR                # 0x005A8AB0
TAM = 0x8C0
J2 = 0x0046CDF0               # .bss en cero (probable libre). NO es juego+0x30-577*0x8C0: eso da 0x0046D1F0 (bitacora (79))
AUTOPUNTEROS = {0x54: 0, 0x29C: 0, 0x56C: 0, 0x69C: 0, 0x7AC: 0, 0x84C: 0, 0x32C: 0x4F0}
COPIAS_CONTROL = (0x588, 0x6D0, 0x7C8)
CTRL2 = 0x00585A0C
MANDO2_REAL = 0x005857B0
FALSO2 = 0x00472100
JUEGO_PTR = 0x0040F4D0


def pos(p: Pine, base: int):
    return tuple(round(p.leer_f32(base + 0x100 + 4 * i), 3) for i in range(3))


def lista(p: Pine, jg: int, tope: int = 20):
    e, r = p.leer32(jg + 0x5CA4), []
    while e and len(r) < tope:
        r.append(e)
        e = p.leer32(e + 0xB0)
    return r


def estado(p: Pine) -> dict:
    jg = p.leer32(JUEGO_PTR)
    l = lista(p, jg)
    return {"J_pos": pos(p, J), "J2_pos": pos(p, J2), "J_yaw": round(p.leer_f32(sc.MIRA), 2),
            "J2_yaw": round(p.leer_f32(J2 + 0x4F0), 2), "J2_c4": p.leer32(J2 + 0xC4),
            "cabeza": hex(l[0]) if l else "0", "J2_en_lista": J2 in l,
            "ctrl2_C": hex(p.leer32(CTRL2 + 0xC)), "juego_5aa0": p.leer32(jg + 0x5AA0)}


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    po = sub.add_parser("poner")
    po.add_argument("--sin-enganche", action="store_true")
    sub.add_parser("enganchar")
    sub.add_parser("estado")
    sub.add_parser("quitar")
    em = sub.add_parser("empujar")
    em.add_argument("eje", choices=sorted(sc.EJES))
    em.add_argument("valor", type=float)
    em.add_argument("segundos", type=float)
    a = ap.parse_args()
    with Pine() as p:
        jg = p.leer32(JUEGO_PTR)
        if a.cmd == "poner":
            blk = bytearray(p.leer_bloque(J, TAM))
            for off, dest in AUTOPUNTEROS.items():
                struct.pack_into("<I", blk, off, J2 + dest)
            for off in COPIAS_CONTROL:
                struct.pack_into("<I", blk, off, CTRL2)
            struct.pack_into("<I", blk, 0xC4, 0)
            struct.pack_into("<I", blk, 0xB0, 0)
            p.escribir_bloque(J2, bytes(blk))
            f2 = bytearray(p.leer_bloque(MANDO2_REAL, 0xF0))
            for o in range(0x8C, 0xCC, 4):
                f2[o:o + 4] = b"\0\0\0\0"
            f2[0x0E:0x2A + 28] = bytes(0x2A + 28 - 0x0E)   # botones: anterior y actual en 0
            p.escribir_bloque(FALSO2, bytes(f2))
            p.escribir32(CTRL2 + 0xC, FALSO2)
            if not a.sin_enganche:
                p.escribir32(J2 + 0xB0, p.leer32(jg + 0x5CA4))
                p.escribir32(jg + 0x5CA4, J2)
        elif a.cmd == "enganchar":
            if J2 not in lista(p, jg, 1000):
                p.escribir32(J2 + 0xB0, p.leer32(jg + 0x5CA4))
                p.escribir32(jg + 0x5CA4, J2)
        elif a.cmd == "quitar":
            if p.leer32(jg + 0x5CA4) == J2:
                p.escribir32(jg + 0x5CA4, p.leer32(J2 + 0xB0))
            p.escribir32(CTRL2 + 0xC, MANDO2_REAL)
        elif a.cmd == "empujar":
            antes = estado(p)
            p.escribir_f32(FALSO2 + sc.EJES[a.eje], a.valor)
            muestras = []
            t0 = time.time()
            while time.time() - t0 < a.segundos:
                time.sleep(0.25)
                muestras.append((pos(p, J2), pos(p, J)))
            p.escribir_f32(FALSO2 + sc.EJES[a.eje], 0.0)
            print(json.dumps({"antes": antes, "durante_J2_J": muestras}, ensure_ascii=False))
            return 0
        print(json.dumps(estado(p), ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
