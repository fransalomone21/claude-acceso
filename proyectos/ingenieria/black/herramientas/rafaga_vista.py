#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rafaga_vista.py -- (96) en que mitad se dibuja la recarga de cada jugador. Rafaga de capturas (una cada ~0,25 s)
mientras recarga J2 y mientras recarga J, con el dato C del filtro (0x0046FBEC) en 0 (control) y en J (arreglo),
todo en la misma corrida. Requiere el bloque instalado con `coop_mod.py instalar --sin-ocultar-j`.

    python herramientas/rafaga_vista.py
Salida: volcados/campana/rv-<quien>-<modo>-<n>.png y rafaga-vista.json (hojas: rv-hoja-<quien>-<modo>.png).
"""
from __future__ import annotations

import json
import subprocess
import sys
import time
from pathlib import Path

from PIL import Image, ImageDraw

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import mando_j2 as m2  # noqa: E402
import ocultar_pasada as oc  # noqa: E402
import sondas_coop as sc  # noqa: E402

J, J2 = cm.cj.J, cm.cj.J2
N = 10


def hoja(nombres, salida):
    ims = []
    for k, n in enumerate(nombres):
        im = Image.open(cc.SAL / n).convert("RGB").resize((480, 270))
        ImageDraw.Draw(im).text((4, 4), "%d" % k, fill=(255, 255, 0))
        ims.append(im)
    M = Image.new("RGB", (480 * 5, 270 * ((len(ims) + 4) // 5)))
    for k, im in enumerate(ims):
        M.paste(im, ((k % 5) * 480, (k // 5) * 270))
    M.save(cc.SAL / salida)


def rafaga(p, quien, modo, c):
    """Graba 5 s con ffmpeg (ddagrab, 30 cuadros/s) mientras el jugador dispara y recarga, y saca 20 cuadros
    (8 por segundo) desde que se aprieta recargar: la recarga dura ~1,7 s."""
    p.escribir32(oc.C, c)
    apretar = (lambda i, v: m2.boton(p, m2.NOMBRES[i], v)) if quien == "J2" else \
              (lambda i, v: sc.poner_boton(p, sc.BOTONES[i], v))
    mp4 = cc.SAL / ("rv-%s-%s.mp4" % (quien, modo))
    ff = subprocess.Popen(["ffmpeg", "-y", "-hide_banner", "-loglevel", "error", "-f", "lavfi", "-i",
                           "ddagrab=framerate=30", "-t", "5", "-vf", "hwdownload,format=bgra,scale=1280:-2,format=yuv420p",
                           "-c:v", "libx264", "-preset", "veryfast", "-crf", "20", str(mp4)])
    t0 = time.time()
    time.sleep(0.5)
    if modo == "e3":
        t_rec, paso = time.time() - t0, 0.25
        apretar("disparar", True); time.sleep(3.0); apretar("disparar", False)
    else:
        paso = 1 / 8.0
        apretar("disparar", True); time.sleep(0.6); apretar("disparar", False); time.sleep(0.6)
        t_rec = time.time() - t0
        apretar("recargar", True); time.sleep(0.15); apretar("recargar", False)
    ff.wait(timeout=30)
    nombres = []
    for n in range(20):
        nom = "rv-%s-%s-%02d.png" % (quien, modo, n)
        subprocess.run(["ffmpeg", "-y", "-hide_banner", "-loglevel", "error", "-ss", "%.3f" % (t_rec + n * paso),
                        "-i", str(mp4), "-frames:v", "1", str(cc.SAL / nom)])
        nombres.append(nom)
    hoja(nombres, "rv-hoja-%s-%s.png" % (quien, modo))
    time.sleep(1.5)
    return {"t_recargar_s": round(t_rec, 2)}


def main() -> int:
    tolerar_salida_pobre()
    if cc.pcsx2_de_fran_abierto():
        print("el PCSX2 de Fran esta abierto: no"); return 1
    if not cc.lanzar():
        print("el fork no quedo vivo"); return 1
    niv = cc.probar_nivel(0)
    if niv.get("cuelga_o_no_arma"):
        cc.matar_fork(); return 1
    time.sleep(2)
    res = {"fecha": time.strftime("%Y-%m-%d %H:%M"), "tiempos": {}}
    with Pine() as p:
        sc.falso_poner(p)
        m2.poner(p)
        corridas = [("J2", "control", 0), ("J2", "arreglo", J), ("J", "control", 0), ("J", "arreglo", J)]
        if "--e3" in sys.argv:          # E3: disparo seguido 3 s, J2 y su control J
            corridas = [("J2", "e3", 0), ("J", "e3", 0)]
        for quien, modo, c in corridas:
            t0 = time.time()
            res["tiempos"]["%s-%s-rec" % (quien, modo)] = rafaga(p, quien, modo, c)
            res["tiempos"]["%s-%s" % (quien, modo)] = round(time.time() - t0, 1)
        m2.quitar(p); sc.falso_quitar(p)
    (cc.SAL / "rafaga-vista.json").write_text(json.dumps(res, indent=1), encoding="utf-8")
    print(json.dumps(res))
    cc.matar_fork()
    return 0


if __name__ == "__main__":
    sys.exit(main())
