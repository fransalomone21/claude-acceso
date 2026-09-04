#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
detectar_nivel_mip.py -- lee una captura del pack de DEBUG y dice que niveles
de mip esta usando PCSX2, y donde.

POR QUE EXISTE
    El pack de mipmaps_debug_color.py pinta cada nivel de un color plano. Leer
    eso "mirando la pantalla" cuesta caro y es impreciso: el juego es oscuro y
    sepia, y un magenta puro sale por pantalla como un violeta apagado despues
    de la iluminacion y el blending. Esto lo cuenta por pixel y lo ubica.

COMO CLASIFICA
    No por igualdad exacta -- eso no sobrevive a la iluminacion del juego --
    sino por la FIRMA de canales: que canales dominan y cuales estan hundidos,
    con un margen relativo. Un pixel solo cuenta si su firma es inequivoca y
    tiene saturacion suficiente; todo lo demas cae en "sin color" (nivel 0 o
    superficie sin reemplazo), que es el caso por lejos mas comun y no
    interesa contar.

USO
    python detectar_nivel_mip.py <captura.png> [--mapa salida.png] [--min 30]
"""
from __future__ import annotations

import argparse
import os
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

from PIL import Image  # noqa: E402

# nivel -> (nombre, canales que deben DOMINAR, canales que deben estar HUNDIDOS)
FIRMAS = {
    1: ("magenta", ("r", "b"), ("g",)),
    2: ("verde",   ("g",),     ("r", "b")),
    3: ("cyan",    ("g", "b"), ("r",)),
    4: ("rojo",    ("r",),     ("g", "b")),
    5: ("azul",    ("b",),     ("r", "g")),
    6: ("amarillo", ("r", "g"), ("b",)),
    7: ("naranja", ("r",),     ("b",)),  # 7+, se distingue del rojo por g medio
}

# Colores para el mapa de salida: el mismo color puro del nivel.
COLOR_MAPA = {
    1: (255, 0, 255), 2: (0, 255, 0), 3: (0, 255, 255),
    4: (255, 0, 0), 5: (0, 0, 255), 6: (255, 255, 0), 7: (255, 128, 0),
}


def clasificar(r: int, g: int, b: int, margen: int, sat_min: int):
    mx, mn = max(r, g, b), min(r, g, b)
    if mx - mn < sat_min:
        return None  # gris: nivel 0 o sin reemplazo
    canales = {"r": r, "g": g, "b": b}
    for nivel, (_, dom, hund) in FIRMAS.items():
        if nivel == 7:
            continue  # el naranja se evalua aparte, es ambiguo con el rojo
        piso_dom = min(canales[c] for c in dom)
        techo_hund = max(canales[c] for c in hund)
        if piso_dom - techo_hund >= margen:
            # magenta vs "rojo con algo de azul": los dos dominantes tienen que
            # parecerse entre si, si no es otro color
            if len(dom) == 2:
                a, bb = (canales[c] for c in dom)
                if abs(a - bb) > max(a, bb) * 0.45:
                    continue
            return nivel
    # naranja: r domina, g intermedio, b hundido
    if r - b >= margen and g > b + margen * 0.4 and g < r * 0.85:
        return 7
    return None


def main():
    salida.tolerar_salida_pobre()
    ap = argparse.ArgumentParser()
    ap.add_argument("captura")
    ap.add_argument("--mapa", help="PNG donde marcar los pixeles clasificados")
    ap.add_argument("--margen", type=int, default=45, help="separacion minima entre dominante y hundido")
    ap.add_argument("--sat", type=int, default=40, help="saturacion minima (max-min de canales)")
    ap.add_argument("--min", type=int, default=25, help="no reportar niveles con menos pixeles que esto")
    args = ap.parse_args()

    im = Image.open(args.captura).convert("RGB")
    w, h = im.size
    px = im.load()
    cuentas = Counter()
    # bounding box y centroide por nivel, para poder decir DONDE
    caja = {}
    mapa = Image.new("RGB", (w, h), (20, 20, 20)) if args.mapa else None
    mpx = mapa.load() if mapa else None

    for y in range(h):
        for x in range(w):
            n = clasificar(*px[x, y], margen=args.margen, sat_min=args.sat)
            if n is None:
                continue
            cuentas[n] += 1
            if n in caja:
                x0, y0, x1, y1, sx, sy = caja[n]
                caja[n] = (min(x0, x), min(y0, y), max(x1, x), max(y1, y), sx + x, sy + y)
            else:
                caja[n] = (x, y, x, y, x, y)
            if mpx:
                mpx[x, y] = COLOR_MAPA[n]

    total = w * h
    print("captura: %s  (%dx%d = %d px)" % (Path(args.captura).name, w, h, total))
    print()
    print("%-6s %-9s %10s %7s   %-22s %s" % (
        "nivel", "color", "pixeles", "% img", "bounding box", "centroide"))
    print("-" * 82)
    hubo = False
    for n in sorted(cuentas):
        if cuentas[n] < args.min:
            continue
        hubo = True
        x0, y0, x1, y1, sx, sy = caja[n]
        c = cuentas[n]
        print("%-6s %-9s %10d %6.3f%%   %-22s (%d,%d)" % (
            n if n < 7 else "7+", FIRMAS[n][0], c, 100.0 * c / total,
            "x %d-%d  y %d-%d" % (x0, x1, y0, y1), sx // c, sy // c))
    if not hubo:
        print("  NINGUN nivel de color detectado -> todo lo visible usa nivel 0,")
        print("  o el mip chain no se esta leyendo.")
    print()
    clasificados = sum(cuentas.values())
    print("clasificados: %d px (%.3f%%)   sin color (nivel 0 / sin reemplazo): %.3f%%" % (
        clasificados, 100.0 * clasificados / total, 100.0 * (total - clasificados) / total))

    if mapa:
        mapa.save(args.mapa)
        print("mapa escrito en %s" % args.mapa)


if __name__ == "__main__":
    main()
