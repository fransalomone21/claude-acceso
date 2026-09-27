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
    python herramientas/sondas_coop.py boton disparar 1.0   # aprieta con el mando falso (77)
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


# Mando FALSO (bitacora (76)): el control virtual 1 lee el mando procesado por
# el puntero CTRL1+0xC. Apuntado a una copia que el gestor NO actualiza, lo que
# se escriba en sus ejes es la entrada del jugador. FALSO vive en un tramo de
# .bss en cero en los 3 volcados y en vivo: libre PROBABLE, no confirmado.
CTRL1 = 0x005858A0
MANDO1_REAL = 0x005856C0
FALSO = 0x00472000
EJES = {  # medidos con el yaw fijo, 0,8 durante 0,5 s
    "adelante": 0x8C, "atras": 0x90, "lateral_a": 0x94, "lateral_b": 0x98,
    "pitch_arriba": 0xA0, "yaw_izq": 0xA4, "yaw_der": 0xA8,
}


def falso_poner(p: Pine) -> None:
    blk = bytearray(p.leer_bloque(MANDO1_REAL, 0xF0))
    for o in range(0x8C, 0xCC, 4):
        blk[o:o + 4] = b"\0\0\0\0"
    p.escribir_bloque(FALSO, bytes(blk))
    p.escribir32(CTRL1 + 0xC, FALSO)


def falso_quitar(p: Pine) -> None:
    p.escribir32(CTRL1 + 0xC, MANDO1_REAL)


# BOTONES (bitacora (77)). El mando procesado tiene 28 entradas: +0x2A+i es el
# estado ACTUAL (u8), +0x0E+i el ANTERIOR y +0x4C+4i el valor (f32). Las
# acciones de flanco piden actual != 0 y anterior == 0; como el falso no lo
# actualiza nadie, un boton puesto asi queda "recien apretado" cada cuadro.
MIRA_OBJ = JUGADOR + 0x4F0    # = MIRA; su +0x98 es el control y +0x7C el jugador
BOTONES = {  # medidos en vivo con control (bitacora (77)); el resto, sin efecto visto
    "disparar": 12,      # mira+0x31; el cargador baja
    "recargar": 2,       # mira+0x34; cargador <- reserva. En menus, indice 2 (FUN_00124a70)
    "zoom": 11,          # mira+0x30
    "arma_a": 6, "arma_b": 7,   # cambian J+0x2A4 al otro slot
    "b3": 3,             # mira+0x3B; estado del arma 28/29 (sin identificar)
    "b10": 10,           # mira+0x35
    "b13": 13,           # mira+0x33
    "pausa": 8,          # abre el menu de pausa (el manejador del jugador deja de correr)
}


def poner_boton(p: Pine, i: int, apretado: bool) -> None:
    p.escribir8(FALSO + 0x0E + i, 0)
    p.escribir8(FALSO + 0x2A + i, 1 if apretado else 0)
    p.escribir_f32(FALSO + 0x4C + 4 * i, 1.0 if apretado else 0.0)


def observables_arma(p: Pine) -> dict:
    arma = p.leer32(JUGADOR + 0x2A4)
    sub = p.leer32(arma + 0xF4) if arma else 0
    reserva = p.leer_bloque(JUGADOR + 0x280, 8)
    return {
        "banderas_mira_30_3B": list(p.leer_bloque(MIRA_OBJ + 0x30, 0xC)),
        "arma": hex(arma),
        "estado_arma_D8": p.leer32(arma + 0xD8) if arma else None,
        "cargador": struct.unpack("<H", p.leer_bloque(sub + 0x18, 2))[0] if sub else None,
        "modo_fuego": p.leer8(sub + 0x20) if sub else None,
        "reserva": list(struct.unpack("<4H", reserva)),
    }


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    b = sub.add_parser("base")
    b.add_argument("--json", action="store_true")
    sub.add_parser("falso-poner", help="el jugador pasa a leer el mando falso (quieto)")
    sub.add_parser("falso-quitar", help="vuelve al mando real")
    e = sub.add_parser("eje", help="empuja un eje del mando falso un rato")
    e.add_argument("nombre", choices=sorted(EJES))
    e.add_argument("valor", type=float)
    e.add_argument("segundos", type=float)
    bt = sub.add_parser("boton", help="aprieta un boton del mando falso y registra el arma")
    bt.add_argument("indice", help="0..15, un nombre de BOTONES, o -1 (control: ninguno)")
    bt.add_argument("segundos", type=float)
    a = ap.parse_args()
    if a.cmd == "boton":
        a.indice = BOTONES[a.indice] if a.indice in BOTONES else int(a.indice)
        import time
        with Pine() as p:
            if p.leer32(CTRL1 + 0xC) != FALSO:
                falso_poner(p)
            for i in range(16):
                poner_boton(p, i, False)
            time.sleep(0.2)
            antes = observables_arma(p)
            if a.indice >= 0:
                poner_boton(p, a.indice, True)
            medio = []
            t0 = time.time()
            while time.time() - t0 < a.segundos:
                medio.append(observables_arma(p))
                time.sleep(0.1)
            if a.indice >= 0:
                poner_boton(p, a.indice, False)
            time.sleep(0.3)
            despues = observables_arma(p)
            print(json.dumps({"boton": a.indice, "antes": antes, "durante": medio,
                              "despues": despues}, ensure_ascii=False))
        return 0
    if a.cmd != "base":
        import time
        with Pine() as p:
            if a.cmd == "falso-poner":
                falso_poner(p)
            elif a.cmd == "falso-quitar":
                falso_quitar(p)
            else:
                if p.leer32(CTRL1 + 0xC) != FALSO:
                    falso_poner(p)
                p.escribir_f32(FALSO + EJES[a.nombre], a.valor)
                time.sleep(a.segundos)
                p.escribir_f32(FALSO + EJES[a.nombre], 0.0)
            print("ctrl1+0xC =", hex(p.leer32(CTRL1 + 0xC)))
        return 0
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
