#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""f7b_pausa.py -- (126) la PAUSA y el doble bufer de recursos de arma (F7b). Predicciones P0-P3 de
sesiones/PREDICCIONES-126.md, escritas antes de correrlo.

    python herramientas/f7b_pausa.py          # lanza el fork con el pnach instalado (no lo toca), City Streets

En frio (probable): el menu de pausa (FUN_0020AEA0) vacia el bufer «otro» (FUN_00143908 con clave 0 -> estado 9) y
carga ahi PseMenu.bin; con dos jugadores, el «otro» puede ser el arma en la mano del companero.
Secuencia, con estado (f7b_buffer.estado) y foto en cada paso:
  control: los dos en la pistola -> J pausa (Start, boton 8 del mando falso de J) -> despausa (CONTINUE, boton 0);
  prueba : J2 a la SPAS -> J pausa -> despausa.
Salida: volcados/arma/f7b-pausa-<fecha-hora>/ (resumen.json + fotos cortadas en mitades).
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import arma_pieza_banco as ab  # noqa: E402
import campana_coop as cc  # noqa: E402
import clon_jugador as cj  # noqa: E402
import f7b_buffer as fb  # noqa: E402
import hud_doble as hd  # noqa: E402
import mando_j2 as m2  # noqa: E402
import sondas_coop as sc  # noqa: E402
from pine import Pine  # noqa: E402

START = 8          # bitacora (77): Start = 8 en el mando procesado
CONFIRMAR = 0      # (126) medido: en el menu de pausa (CONTINUE elegido) confirma el 0; un 2.o Start no lo cierra


def _pulsar(i):
    with Pine() as p:
        sc.poner_boton(p, i, True)
        time.sleep(0.2)
        sc.poner_boton(p, i, False)


def paso(res, dir_, nombre):
    with Pine() as p:
        res[nombre] = fb.estado(p)
    hd.captura(dir_, nombre.replace("_", "-") + ".png")


def pausar_y_volver(res, dir_, pref):
    _pulsar(START)
    time.sleep(2.5)
    paso(res, dir_, pref + "_en_pausa")
    _pulsar(CONFIRMAR)
    time.sleep(2.5)
    paso(res, dir_, pref + "_despues")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--sin-soporte2", action="store_true",
                    help="(126) instala el pnach SIN la pieza 2d antes de lanzar (el control de la traba de la pausa)")
    ap.add_argument("--espera", type=float, default=1.0, help="segundos entre el cambio de J2 y la pausa")
    a = ap.parse_args()
    if cc.pcsx2_de_fran_abierto():
        print(json.dumps({"error": "el PCSX2 de Fran esta abierto: comparte PINE con el fork"}))
        return 1
    dir_ = ab.SAL / time.strftime("f7b-pausa-%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    hd.FOTOS.clear()
    res = {"dir": str(dir_), "sin_soporte2": a.sin_soporte2, "espera": a.espera}
    r = subprocess.run([sys.executable, str(H / "coop_mod.py"), "instalar"]
                       + (["--sin-soporte2"] if a.sin_soporte2 else []), capture_output=True, text=True)
    res["instalar"] = r.stdout.strip()[-300:]
    res["vivo"] = cc.lanzar()
    if not res["vivo"]:
        print(json.dumps(res))
        return 1
    c = cc.probar_nivel(ab.NIVEL)
    res["carga"] = {k: c.get(k) for k in ("armado_s", "juego_s", "cuelga_o_no_arma", "vivo_despues")}
    with Pine() as p:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:
            sc.falso_poner(p)
        m2.poner(p)
        res["preparar"] = ab.preparar(p, intentar_j=False)
    res["igualar"] = ab.igualar_indices()
    paso(res, dir_, "base")
    pausar_y_volver(res, dir_, "control")
    res["j2_spas_pulso"] = ab.cambiar(m2.boton, cj.J2, ab.ARMA_A)
    time.sleep(a.espera)
    paso(res, dir_, "j2_spas")
    pausar_y_volver(res, dir_, "prueba")
    pasos = ("base", "control_en_pausa", "control_despues", "j2_spas", "prueba_en_pausa", "prueba_despues")
    res["P0"] = res["control_despues"]["J"]["residente"] and res["control_despues"]["J2"]["residente"]
    res["P2_J_no_residente"] = not res["prueba_despues"]["J"]["residente"]
    if not res["preparar"]["listo"] or not res["j2_spas_pulso"]["ocurrio"]:
        res["ROJO"] = "no se construyo la precondicion (J2 con la SPAS en la mano): no se concluye nada"
    return fb.cerrar(res, dir_, pasos)


if __name__ == "__main__":
    sys.exit(main())
