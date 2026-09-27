#!/usr/bin/env python3
"""selector_depuracion.py -- el selector de niveles de depuracion, por PINE (bitacora (78)).

El "entrar" del front-end (FUN_00104210), en su estado 7, abre el MENU TIPO 1
(FUN_00205d40) en vez del front-end de Flash si el byte 0x0040D986 vale 0.
Este script pide el modo front-end escribiendo los mismos campos que
FUN_001034b0, maneja el selector con el mando falso y lee su estado.

    python herramientas/selector_depuracion.py estado
    python herramientas/selector_depuracion.py pedir-frontend --bandera 0 --segundos 15
    python herramientas/selector_depuracion.py elegir 11 0      # Gun Street, unidad 1
    python herramientas/selector_depuracion.py aceptar
    python herramientas/selector_depuracion.py vivo              # control positivo: el eje gira la vista

Las direcciones salen del decompilado (bitacora (78)); el grado es PROBABLE
hasta que la corrida las confirme con control.
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

SESION_PTR = 0x0040F0E0
MENU_PTR = 0x0040F524        # singleton de menus: +4 tipo, +0xC objeto del tipo 1
FLASH_PTR = 0x0040F544       # +0x3948 fundido (f32), +0x394C
BANDERA_FE = 0x0040D986      # 0 = selector de depuracion
FE = 0x20220                 # modo front-end (offset en la sesion)
JUEGO = 0x20F78              # modo juego
BOT_COLUMNA, BOT_MAS, BOT_MENOS, BOT_ACEPTAR = 4, 7, 6, 8


def estado(p: Pine) -> dict:
    s = p.leer32(SESION_PTR)
    menu = p.leer32(MENU_PTR)
    m1 = p.leer32(menu + 0xC) if menu else 0
    fl = p.leer32(FLASH_PTR)

    def modo(v):
        return hex(v - s) if v else "0"
    d = {
        "modo_actual": modo(p.leer32(s + 0x21070)),
        "modo_pedido": modo(p.leer32(s + 0x21074)),
        "transicion_21084": p.leer32(s + 0x21084),
        "fe_estado": p.leer32(s + FE),
        "fe_48": p.leer32(s + FE + 0x48),
        "bandera_D986": p.leer8(BANDERA_FE),
        "menu_tipo": p.leer32(menu + 4) if menu else None,
        "sel_estado_CC": p.leer32(m1 + 0xCC) if m1 else None,
        "sel_columna_C8": p.leer8(m1 + 0xC8) if m1 else None,
        "sel_nivel_C9": p.leer8(m1 + 0xC9, con_signo=True) if m1 else None,
        "sel_unidad_CA": p.leer8(m1 + 0xCA, con_signo=True) if m1 else None,
        "nivel_2020C": p.leer8(s + 0x2020C), "unidad_2020D": p.leer8(s + 0x2020D),
        "cuenta_20208": p.leer32(s + 0x20208),
        "fundido": round(p.leer_f32(fl + 0x3948), 3) if fl else None,
        "ctrl1_C": hex(p.leer32(sc.CTRL1 + 0xC)),
    }
    return d


def pedir_modo(p: Pine, off: int) -> None:
    """Los campos que escribe FUN_001034b0 (sin la parte de Flash)."""
    s = p.leer32(SESION_PTR)
    fl = p.leer32(FLASH_PTR)
    p.escribir32(s + 0x21074, s + off)
    p.escribir8(s + 0x210CB, 1)
    p.escribir8(s + 0x210C8, 0)
    p.escribir8(fl + 0x394C, 1)
    p.escribir_f32(fl + 0x3948, 1.0)
    p.escribir32(s + 0x21084, 2)


def pulsar(p: Pine, i: int, campo: int, m1: int, tope: float = 1.5) -> None:
    """Aprieta i hasta que el campo del selector cambie (el falso deja el flanco
    sostenido: sin esto, un toque avanza varias posiciones)."""
    antes = p.leer8(m1 + campo)
    sc.poner_boton(p, i, True)
    t0 = time.time()
    while time.time() - t0 < tope and p.leer8(m1 + campo) == antes:
        time.sleep(0.005)
    sc.poner_boton(p, i, False)
    time.sleep(0.15)


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("estado")
    sub.add_parser("vivo")
    pf = sub.add_parser("pedir-frontend")
    pf.add_argument("--bandera", type=int, choices=(0, 1), required=True)
    pf.add_argument("--segundos", type=float, default=15)
    el = sub.add_parser("elegir")
    el.add_argument("nivel", type=int, help="indice en la tabla (0..11)")
    el.add_argument("unidad", type=int, help="indice de unidad (0 = Unit 1)")
    sub.add_parser("aceptar")
    a = ap.parse_args()
    with Pine() as p:
        if a.cmd == "estado":
            print(json.dumps(estado(p), ensure_ascii=False))
        elif a.cmd == "vivo":
            if p.leer32(sc.CTRL1 + 0xC) != sc.FALSO:
                sc.falso_poner(p)
            y0 = p.leer_f32(sc.MIRA)
            p.escribir_f32(sc.FALSO + sc.EJES["yaw_der"], 0.8)
            time.sleep(0.5)
            p.escribir_f32(sc.FALSO + sc.EJES["yaw_der"], 0.0)
            y1 = p.leer_f32(sc.MIRA)
            print(json.dumps({"yaw_antes": y0, "yaw_despues": y1, "vivo": abs(y1 - y0) > 1.0}))
        elif a.cmd == "pedir-frontend":
            p.escribir8(BANDERA_FE, a.bandera)
            s = p.leer32(SESION_PTR)
            p.escribir32(s + FE + 0x48, 0)
            pedir_modo(p, FE)
            ult = None
            t0 = time.time()
            while time.time() - t0 < a.segundos:
                # El estado 5 del "entrar" recarga el Flash y repone la bandera
                # en 1 (medido, bitacora (78)): se reescribe en los estados 6 y 7,
                # antes de que el 7 la lea.
                if a.bandera == 0 and p.leer32(s + FE) in (6, 7) \
                        and p.leer32(s + 0x21074) == s + FE:
                    p.escribir8(BANDERA_FE, 0)
                try:
                    e = estado(p)
                except Exception as ex:  # PINE puede no responder durante la carga
                    e = {"error": str(ex)}
                if e != ult:
                    print("%5.1f s %s" % (time.time() - t0, json.dumps(e, ensure_ascii=False)))
                    ult = e
                time.sleep(0.25)
        elif a.cmd in ("elegir", "aceptar"):
            if p.leer32(sc.CTRL1 + 0xC) != sc.FALSO:
                sc.falso_poner(p)
            for i in range(16):
                sc.poner_boton(p, i, False)
            m1 = p.leer32(p.leer32(MENU_PTR) + 0xC)
            if a.cmd == "elegir":
                for col, campo, meta in ((1, 0xC9, a.nivel), (0, 0xCA, a.unidad)):
                    for _ in range(4):
                        if p.leer8(m1 + 0xC8) == col:
                            break
                        pulsar(p, BOT_COLUMNA, 0xC8, m1)
                    for _ in range(30):
                        v = p.leer8(m1 + campo, con_signo=True)
                        if v == meta:
                            break
                        pulsar(p, BOT_MAS if v < meta else BOT_MENOS, campo, m1)
            else:
                sc.poner_boton(p, BOT_ACEPTAR, True)
                time.sleep(0.3)
                sc.poner_boton(p, BOT_ACEPTAR, False)
            print(json.dumps(estado(p), ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
