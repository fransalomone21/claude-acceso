#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cue_disparo.py -- (117) el estado del SONIDO del disparo en los volcados, en frio.

    python herramientas/cue_disparo.py            # tabla por volcado
    python herramientas/cue_disparo.py --autotest # control positivo y negativo

El disparo `FUN_001D6F90(V)` toca `FUN_001F0678(*(V+0x1BE0))`: eso NO es una pista de animacion
(lo que decia (116)) sino un CUE de sonido con N voces (`cue+0x5C` arreglo de 0xC B, `cue+0x60` cuantas;
`FUN_001D6178` elige una libre o roba la mas vieja, `FUN_001D60B8` la toca con `FUN_00283E78`, la misma
llamada que `FUN_001D7020`). Esto lee, ANTES de fabricar, de lo que depende ese camino:
  - V = 0x00657180 en los 16 volcados ((116)); el autotest exige su forma (voces en V+0x284) y que V+0x40 no la tenga
  - *(V+0x1BE0) el cue actual, *(V+0x1BE4) el guardado, *(V+0x1BE8) el alternativo (FUN_001D73D8)
  - cue+0x5C / +0x60 las voces, cue+0x41C la bandera que saltea la historia, cue+0x1D0 la historia
  - V+0x1C44 / +0x1C48 (la guarda y el volumen de FUN_001D7020: el control, que (116) midio en 0)
Sin numpy. Salida: una linea por volcado.
"""
import glob
import os
import struct
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
V = 0x00657180  # medido en (116) en los 16 volcados; se vuelve a chequear abajo por su forma


def u32(m, a):
    if a < 0 or a + 4 > len(m):
        return None
    return struct.unpack_from("<I", m, a)[0]


def f32(m, a):
    return struct.unpack_from("<f", m, a)[0]


def en_ram(p):
    return p is not None and 0x00100000 <= p < 0x02000000


def leer(ruta):
    m = open(ruta, "rb").read()
    fila = {"volcado": os.path.basename(ruta)}
    cue, sav, alt = u32(m, V + 0x1BE0), u32(m, V + 0x1BE4), u32(m, V + 0x1BE8)
    fila.update(cue=cue, guardado=sav, alt=alt, g1c44=m[V + 0x1C44], vol1c48=f32(m, V + 0x1C48))
    if en_ram(cue):
        fila.update(voces=u32(m, cue + 0x60), arr=u32(m, cue + 0x5C), b41c=m[cue + 0x41C],
                    hist=u32(m, cue + 0x1D0), f74=f32(m, cue + 0x74), f78=f32(m, cue + 0x78),
                    f7c=f32(m, cue + 0x7C))
        arr, n = fila["arr"], fila["voces"] or 0
        # cada voz: +0 objeto de voz (lo que FUN_002842E8 pregunta si suena), +8 sello de tiempo
        voces = []
        if en_ram(arr) and 0 < n <= 16:
            for i in range(n):
                voces.append((u32(m, arr + i * 0xC), u32(m, arr + i * 0xC + 8)))
        fila["lista"] = voces
        fila["arr_es_V284"] = arr == V + 0x284
    return fila


def main():
    rutas = sorted(glob.glob(os.path.join(RAIZ, "volcados", "ee-*.bin")))
    if "--autotest" in sys.argv:
        return autotest(rutas)
    print(f"V = 0x{V:08X}; {len(rutas)} volcados")
    for r in rutas:
        f = leer(r)
        cab = (f"{f['volcado']:<26} cue={f['cue']:#010x} guard={f['guardado']:#010x} alt={f['alt']:#010x} "
               f"1C44={f['g1c44']} vol1C48={f['vol1c48']:.2f}")
        if "voces" in f:
            cab += (f" | voces={f['voces']} arr={'V+0x284' if f['arr_es_V284'] else hex(f['arr'] or 0)}"
                    f" 41C={f['b41c']} hist={f['hist']} 74/78/7C={f['f74']:.2f}/{f['f78']:.2f}/{f['f7c']:.2f}"
                    f" vivas={sum(1 for o, _ in f['lista'] if en_ram(o))}")
        else:
            cab += " | cue fuera de RAM"
        print(cab)
    return 0


def autotest(rutas):
    """Control positivo: V+0x1BE0 tiene que ser un puntero a RAM en algun volcado de juego (el disparo de J
    suena siempre). Control negativo: el mismo lector sobre V corrido 0x40 no puede dar la misma forma
    (cue en RAM con 1..16 voces y su arreglo en V+0x284)."""
    global V
    buenos = [leer(r) for r in rutas]
    pos = sum(1 for f in buenos if f.get("arr_es_V284"))
    Vok = V
    V = Vok + 0x40
    malos = sum(1 for r in rutas if leer(r).get("arr_es_V284"))
    V = Vok
    print(f"positivo: {pos}/{len(rutas)} con el arreglo de voces en V+0x284 | negativo (V+0x40): {malos}")
    ok = pos > 0 and malos == 0
    print("AUTOTEST", "OK" if ok else "FALLA")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
