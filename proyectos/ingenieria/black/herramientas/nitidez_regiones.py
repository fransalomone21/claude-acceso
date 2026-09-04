#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
nitidez_regiones.py -- mide nitidez por region en capturas pareadas.

POR QUE EXISTE
    "Se ve borrosa" es un juicio del ojo y no se puede comparar entre
    sesiones ni contra un estado anterior. Esto lo convierte en un numero
    por region, para poder decir CUANTO y DONDE -- y sobre todo para
    distinguir "solo la barrera perdio detalle" de "la escena entera lo
    perdio", que son diagnosticos distintos y llevan a arreglos distintos.

METRICA
    Varianza del laplaciano sobre luminancia (el estandar de deteccion de
    desenfoque). Sube con el detalle de alta frecuencia: mas alto = mas
    nitido. Es comparable SOLO entre capturas del mismo encuadre, que es
    justo el caso de un A/B pareado.

USO
    python nitidez_regiones.py <base.png> <comparar.png> [mas.png ...]
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

from PIL import Image  # noqa: E402

# Regiones en coordenadas RELATIVAS (0..1) para no atarse a la resolucion de
# captura, que depende del upscale y del tamano de ventana.
REGIONES = {
    "barrera (centro, el sintoma)": (0.20, 0.38, 0.55, 0.85),
    "auto derecho (fondo)":         (0.49, 0.06, 0.76, 0.26),
    "auto izquierdo (fondo)":       (0.20, 0.05, 0.36, 0.18),
    "caja izquierda (cerca)":       (0.00, 0.30, 0.12, 0.95),
    "pared derecha (media dist.)":  (0.79, 0.17, 0.99, 0.29),
    "poste derecho (cerca)":        (0.885, 0.28, 0.96, 0.60),
}


def laplaciano_var(im: Image.Image) -> float:
    """Varianza del laplaciano 3x3, a mano: evita depender de numpy/scipy."""
    g = im.convert("L")
    w, h = g.size
    px = g.load()
    vals = []
    for y in range(1, h - 1):
        for x in range(1, w - 1):
            v = (px[x, y - 1] + px[x, y + 1] + px[x - 1, y] + px[x + 1, y]
                 - 4 * px[x, y])
            vals.append(v)
    if not vals:
        return 0.0
    n = len(vals)
    media = sum(vals) / n
    return sum((v - media) ** 2 for v in vals) / n


def main():
    salida.tolerar_salida_pobre()
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    rutas = [Path(a) for a in sys.argv[1:]]
    ims = []
    for r in rutas:
        im = Image.open(r)
        ims.append((r.name, im))
        print("%-42s %dx%d" % (r.name, im.width, im.height))
    print()

    base_nombre = ims[0][0]
    print("%-30s %12s %s" % ("region", base_nombre[:12], "  ".join(
        "%14s" % n[:14] for n, _ in ims[1:])))
    print("-" * (30 + 12 + 16 * (len(ims) - 1)))

    for nombre, (x0, y0, x1, y1) in REGIONES.items():
        fila = []
        base_val = None
        for i, (n, im) in enumerate(ims):
            caja = (int(x0 * im.width), int(y0 * im.height),
                    int(x1 * im.width), int(y1 * im.height))
            # Se reduce a un ancho fijo para que el numero no dependa del
            # tamano de la region ni de la resolucion de la captura.
            rec = im.crop(caja)
            escala = 320 / max(rec.width, 1)
            if escala < 1:
                rec = rec.resize((320, max(int(rec.height * escala), 1)), Image.Resampling.LANCZOS)
            v = laplaciano_var(rec)
            if i == 0:
                base_val = v
                fila.append("%12.1f" % v)
            else:
                delta = (v / base_val - 1) * 100 if base_val else 0
                fila.append("%14s" % ("%.1f (%+.0f%%)" % (v, delta)))
        print("%-30s %s" % (nombre[:30], "".join(fila)))


if __name__ == "__main__":
    main()
