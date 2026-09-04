#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
emparejar_dump_pack.py -- encuentra, POR CONTENIDO, el archivo del pack que
corresponde a una textura volcada, aunque el hash del nombre no coincida.

POR QUE EXISTE (docs/09-remaster-visual.md S7.7)
    Con hw_mipmap activado PCSX2 hashea el nivel base MAS todos los niveles de
    mip del juego, asi que la MISMA textura tiene un hash distinto que el que
    trae el pack de 2022 (volcado sin mipmapping). El reemplazo existe y no se
    encuentra. Cruzar por NOMBRE no puede detectarlo -- por definicion los
    nombres diferen. Esto cruza por IMAGEN, que es lo unico que no cambia.

    Sirve para dos cosas: probar que la textura perdida SI esta en el pack
    (cierra el diagnostico), y producir el mapeo hash-viejo -> hash-nuevo que
    haria falta para arreglar el pack renombrando.

COMO
    Firma = miniatura 8x8 normalizada (se le resta la media y se divide por el
    desvio, por canal). La normalizacion importa: el pack es un upscale por IA
    del original de PS2 y puede haber corrido brillo y contraste, pero no la
    ESTRUCTURA. Se compara por distancia L1 sobre la firma normalizada.

    Del pack NO se decodifica la textura entera: se le saca un nivel de mip ya
    embebido, chiquito, armando un DDS minimo en memoria con ese nivel como
    base. Un 16x16 se decodifica al instante y un 1024x1024 no.

USO
    python emparejar_dump_pack.py <carpeta_dumps> <carpeta_pack> [--umbral 0.9]
"""
from __future__ import annotations

import argparse
import io
import math
import os
import struct
import sys
import time
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

from PIL import Image  # noqa: E402

HEADER_SIZE = 128
OFF_FLAGS, OFF_HEIGHT, OFF_WIDTH, OFF_MIPMAPCOUNT, OFF_CAPS = 8, 12, 16, 28, 108
DDSD_MIPMAPCOUNT = 0x00020000
LADO = 8  # lado de la miniatura de firma


def tam_nivel(w: int, h: int) -> int:
    return max((w + 3) // 4, 1) * max((h + 3) // 4, 1) * 16


def nivel_chico_como_dds(datos: bytes):
    """Devuelve un DDS de un solo nivel, tomando el mip mas chico que sea >= LADO.

    Evita decodificar 1024x1024 cuando alcanza con un 16x16 ya embebido."""
    (flags,) = struct.unpack_from("<I", datos, OFF_FLAGS)
    h, w = struct.unpack_from("<II", datos, OFF_HEIGHT)
    (mipcount,) = struct.unpack_from("<I", datos, OFF_MIPMAPCOUNT)
    if not (flags & DDSD_MIPMAPCOUNT):
        mipcount = 0

    pos, mejor = HEADER_SIZE, None
    for nivel in range(0, mipcount + 1):
        tw = max(w >> nivel, 1)
        th = max(h >> nivel, 1)
        t = tam_nivel(tw, th)
        if pos + t > len(datos):
            break
        if min(tw, th) >= LADO:
            mejor = (tw, th, pos, t)  # se queda con el ultimo que cumple: el mas chico
        pos += t
    if mejor is None:
        return None

    tw, th, off, t = mejor
    cab = bytearray(datos[:HEADER_SIZE])
    struct.pack_into("<I", cab, OFF_HEIGHT, th)
    struct.pack_into("<I", cab, OFF_WIDTH, tw)
    struct.pack_into("<I", cab, OFF_FLAGS, flags & ~DDSD_MIPMAPCOUNT)
    struct.pack_into("<I", cab, OFF_MIPMAPCOUNT, 0)
    struct.pack_into("<I", cab, OFF_CAPS, 0x1000)
    return bytes(cab) + datos[off:off + t], (w, h)


def firma(im: Image.Image):
    im = im.convert("RGB").resize((LADO, LADO), Image.Resampling.BOX)
    px = list(im.getdata())
    canales = []
    for c in range(3):
        v = [p[c] for p in px]
        m = sum(v) / len(v)
        d = math.sqrt(sum((x - m) ** 2 for x in v) / len(v)) or 1.0
        canales.append([(x - m) / d for x in v])
    return canales


def distancia(a, b) -> float:
    return sum(abs(x - y) for ca, cb in zip(a, b) for x, y in zip(ca, cb)) / (3 * LADO * LADO)


def main():
    salida.tolerar_salida_pobre()
    ap = argparse.ArgumentParser()
    ap.add_argument("dumps")
    ap.add_argument("pack")
    ap.add_argument("--umbral", type=float, default=0.90,
                    help="distancia maxima para aceptar un par (menor = mas estricto)")
    ap.add_argument("--escala", type=int, default=4, help="factor de upscale del pack")
    args = ap.parse_args()

    dumps = sorted(Path(args.dumps).glob("*.png"))
    print("dumps a emparejar: %d" % len(dumps))

    # que tamanos de pack hacen falta, para no decodificar el pack entero
    buscados = set()
    info_dump = []
    for f in dumps:
        im = Image.open(f)
        w, h = im.size
        objetivo = (w * args.escala, h * args.escala)
        buscados.add(objetivo)
        info_dump.append((f, im, objetivo))
    print("tamanos de pack necesarios: %s" % sorted(buscados))

    t0 = time.time()
    porTam = defaultdict(list)
    leidos = saltados = 0
    for f in Path(args.pack).glob("*.dds"):
        cab = f.open("rb").read(32)
        if len(cab) < 32:
            continue
        hh, ww = struct.unpack_from("<II", cab, OFF_HEIGHT)
        if (ww, hh) not in buscados:
            saltados += 1
            continue
        datos = f.read_bytes()
        r = nivel_chico_como_dds(datos)
        if r is None:
            continue
        mini, _ = r
        try:
            porTam[(ww, hh)].append((f.name, firma(Image.open(io.BytesIO(mini)))))
            leidos += 1
        except Exception as e:  # noqa: BLE001
            print("  no se pudo leer %s: %s" % (f.name, e))
    print("pack: %d firmas calculadas, %d saltados por tamano  (%.0f s)\n" % (
        leidos, saltados, time.time() - t0))

    hallados = 0
    print("%-46s %-46s %s" % ("volcada (hash NUEVO, con mips)", "pack (hash VIEJO, solo base)", "dist"))
    print("-" * 104)
    for f, im, objetivo in info_dump:
        cands = porTam.get(objetivo, [])
        if not cands:
            print("%-46s %-46s  (sin candidatos de %dx%d)" % (f.name[:46], "-", objetivo[0], objetivo[1]))
            continue
        fd = firma(im)
        mejor_n, mejor_d = None, 1e9
        for nombre, fp in cands:
            d = distancia(fd, fp)
            if d < mejor_d:
                mejor_d, mejor_n = d, nombre
        if mejor_d <= args.umbral:
            hallados += 1
            print("%-46s %-46s %.3f" % (f.name[:46], mejor_n[:46], mejor_d))
        else:
            print("%-46s %-46s %.3f  (por encima del umbral)" % (f.name[:46], mejor_n[:46], mejor_d))

    print()
    print("EMPAREJADAS: %d de %d volcadas encontraron su par en el pack." % (hallados, len(dumps)))
    print("Cada par es la MISMA textura con dos hashes distintos: la de la izquierda")
    print("es la que PCSX2 pide con hw_mipmap activado, y no existe en el pack.")


if __name__ == "__main__":
    main()
