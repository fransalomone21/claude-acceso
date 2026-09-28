#!/usr/bin/env python3
"""parpadeo_escala.py -- (93t) clasifica la mitad de J2 de cada captura en vista A (bien) o B (comprimida).

La vista B del parpadeo es la vista A COMPRIMIDA A LA MITAD EN HORIZONTAL (misma escala vertical): la pasada 2
se dibujo con la proporcion entera de R+0xD470/74 en lugar de la mitad (89). Esta herramienta no mira a ojo:
para cada captura busca la escala horizontal (0,35..1,25) y vertical (0,9..1,1) que mejor superpone su mitad
derecha sobre la de una captura de referencia (J2 quieto, vista A), por correlacion en la ventana central.
Escala ~1,0 -> A; escala ~0,5 -> B. Sirve si J2 no se mueve entre capturas (J2 quieto disparando).

    python herramientas/parpadeo_escala.py REF.png CAP1.png CAP2.png ...   # capturas enteras (J | J2)
    python herramientas/parpadeo_escala.py --autotest                        # control con las capturas de (93r)

Salida: una linea JSON por captura {captura, escala_x, escala_y, correlacion, vista} y el total de B.
El autotest usa volcados/campana/parpadeo-mitadJ2.png (5 mitades de J2 de 384 px: quieto, fuego-0..3; la B es
fuego-1, (93r)) y exige quieto->quieto = A, fuego-1 = B y el resto A: sin eso, el clasificador no vale.
"""
import argparse
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image

RAIZ = Path(__file__).resolve().parent.parent
HUD = 0.2   # fraccion de arriba que se descarta (el HUD no se comprime: esta dibujado aparte)


def correlacion(src, dst, sx, sy):
    h, w = src.shape
    nw, nh = int(round(w * sx)), int(round(h * sy))
    sc = np.asarray(Image.fromarray(src).resize((nw, nh), Image.BILINEAR), dtype=float)
    cw, ch = min(w, nw), min(h, nh)
    a = sc[(nh - ch) // 2:(nh - ch) // 2 + ch, (nw - cw) // 2:(nw - cw) // 2 + cw]
    d = dst[(h - ch) // 2:(h - ch) // 2 + ch, (w - cw) // 2:(w - cw) // 2 + cw]
    a, d = a - a.mean(), d - d.mean()
    den = np.sqrt((a * a).sum() * (d * d).sum())
    return float((a * d).sum() / den) if den else 0.0


def ajustar(ref, cap):
    """(escala_x, escala_y, correlacion) que mejor lleva la referencia a la captura."""
    mejor = (1.0, 1.0, -1.0)
    for sx in np.arange(0.35, 1.3, 0.05):
        for sy in (0.9, 1.0, 1.1):
            c = correlacion(ref, cap, sx, sy)
            if c > mejor[2]:
                mejor = (round(float(sx), 2), sy, round(c, 3))
    return mejor


def vista(sx):
    return "B" if sx <= 0.65 else "A" if sx >= 0.85 else "?"


def mitad_derecha(ruta):
    im = Image.open(ruta).convert("L")
    w, h = im.size
    return np.asarray(im.crop((w // 2, int(h * HUD), w, h)), dtype=float)


def autotest():
    im = Image.open(RAIZ / "volcados" / "campana" / "parpadeo-mitadJ2.png").convert("L")
    w, h = im.size
    pan = [np.asarray(im.crop((k * 384, int(h * HUD), k * 384 + 384, h)), dtype=float) for k in range(w // 384)]
    nombres = ["quieto", "fuego-0", "fuego-1", "fuego-2", "fuego-3"][:len(pan)]
    esperado = {"fuego-1": "B"}
    ok = True
    for n, p in zip(nombres, pan):
        sx, sy, c = ajustar(pan[0], p)
        v, e = vista(sx), esperado.get(n, "A")
        ok &= v == e
        print(json.dumps({"captura": n, "escala_x": sx, "escala_y": sy, "correlacion": c, "vista": v, "esperado": e}))
    print("autotest:", "BIEN" if ok else "MAL")
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("ref", nargs="?")
    ap.add_argument("capturas", nargs="*")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    if not a.ref or not a.capturas:
        ap.error("hacen falta REF y al menos una captura")
    ref, n_b = mitad_derecha(a.ref), 0
    for c in a.capturas:
        sx, sy, co = ajustar(ref, mitad_derecha(c))
        n_b += vista(sx) == "B"
        print(json.dumps({"captura": c, "escala_x": sx, "escala_y": sy, "correlacion": co, "vista": vista(sx)}))
    print(json.dumps({"capturas": len(a.capturas), "B": n_b}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
