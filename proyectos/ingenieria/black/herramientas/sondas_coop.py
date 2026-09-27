#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sondas_coop.py -- el lote de sondas de COOP-A por PINE (bitacora (76) en adelante).

Lee de una vez los observables de las sondas del lote de la notebook, para
tener la linea base y el antes/despues de cada escritura sin tipear
direcciones a mano. Las direcciones salen de kb/ y de la bitacora; aca
estan UNA vez.

    python herramientas/sondas_coop.py base          # imprime todos los observables
    python herramientas/sondas_coop.py base --json   # lo mismo, para guardar
"""
from __future__ import annotations

import argparse
import json
import math
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402

JUGADOR = 0x005A8AB0          # base confirmada (bitacora, 7e)
MANDO = JUGADOR + 0x418       # u8: numero de mando (sonda 1)
MATRIZ = JUGADOR + 0xD0       # 4x4 f32: cabeza del jugador (fila 3 = posicion)
MIRA = 0x005A8FA0             # objeto de mira: +0 yaw, +0xC pitch, en grados
CAMARA = 0x0058E780           # gestor de camara (obj de *(0x0040F4BC))
CAM_MATRIZ = CAMARA + 0x7A0   # copia de la matriz del jugador
CAM_VISTA = CAMARA + 0x7E1    # u8, sonda 3c
VU1_BLOQUE = 0x0043F790       # dentro de 0x0043F710, sonda 3b
VISTA_CHICA = 0x004CA2F0      # la vista 160 x 112, sonda 4
CUENTA = 0x004BC208           # cuenta de jugadores de la sesion, sonda 5a
BANDERA_F504 = 0x0040D9A3     # u8, camara desactivada de fabrica
GLOBAL_JUEGO = 0x0040F4D0
GLOBAL_DISPARADORES = 0x0040F4F4


def f32(b: bytes, o: int = 0) -> float:
    return struct.unpack_from("<f", b, o)[0]


def base(p: Pine) -> dict:
    m = p.leer_bloque(MATRIZ, 64)
    cm = p.leer_bloque(CAM_MATRIZ, 64)
    mira = p.leer_bloque(MIRA, 16)
    juego = p.leer32(GLOBAL_JUEGO)
    fila0 = (f32(m, 0), f32(m, 4), f32(m, 8))
    ang0 = math.degrees(math.atan2(fila0[2], fila0[0]))
    d = {
        "mando_jugador0": p.leer8(MANDO),
        "yaw_mira": f32(mira, 0),
        "pitch_mira": f32(mira, 12),
        "matriz_fila0": fila0,
        "matriz_fila0_angulo": ang0,
        "posicion": (f32(m, 48), f32(m, 52), f32(m, 56)),
        "cam_matriz_fila0": (f32(cm, 0), f32(cm, 4), f32(cm, 8)),
        "cam_vista_7E1": p.leer8(CAM_VISTA),
        "cuenta_jugadores": p.leer32(CUENTA),
        "bandera_F504": p.leer8(BANDERA_F504),
        "juego": hex(juego),
        "juego_posicion_1C0": (p.leer_f32(juego + 0x1C0), p.leer_f32(juego + 0x1C4),
                               p.leer_f32(juego + 0x1C8)) if juego else None,
    }
    return d


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    b = sub.add_parser("base")
    b.add_argument("--json", action="store_true")
    a = ap.parse_args()
    with Pine() as p:
        d = base(p)
    if a.json:
        print(json.dumps(d, ensure_ascii=False))
    else:
        for k, v in d.items():
            if isinstance(v, tuple):
                v = "(" + ", ".join("%.3f" % x for x in v) + ")"
            elif isinstance(v, float):
                v = "%.3f" % v
            print("%-22s %s" % (k, v))
    return 0


if __name__ == "__main__":
    sys.exit(main())
