#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
regenerar_mipmaps.py -- arma la mip chain de un pack de reemplazo DXT5 de PCSX2.

CONTEXTO (ver docs/09-remaster-visual.md S7.5 y sesiones/HANDOFF.md S9)
    El pack de 8225 .dds solo tiene el nivel 0 (base). La convencion de
    nombre "-mip%u" que el proyecto habia leido de los strings del .exe es
    SOLO para PNG (GSTextureReplacements.cpp::GetDumpFilename, hardcodeado a
    ".png"). Para DDS, PCSX2 lee los niveles de mip EMBEBIDOS en el MISMO
    archivo, secuencialmente, usando dwMipMapCount del header DDS estandar
    (confirmado leyendo GSTextureReplacementLoaders.cpp::DDSLoader /
    ParseDDSHeader / ReadDDSMipLevel del repo oficial PCSX2/pcsx2,
    2026-09-04). Generar archivos "-mip1.dds" sueltos no habria hecho nada:
    ese loader nunca los busca.

QUE HACE
    Para cada .dds de un solo nivel: decodifica el nivel base, genera los
    niveles mas chicos (log2(max(w,h))+1 niveles en total -- la formula
    exacta de GSTextureReplacements::CalcMipmapLevelsForReplacement), los
    comprime a DXT5 y los agrega DESPUES de los bytes originales del nivel
    base, que NUNCA se tocan ni se recomprimen. Solo se parchean 3 campos
    del header (dwFlags, dwMipMapCount, dwCaps); el resto queda byte a byte
    igual al original.

VERIFICADO por efecto contra bytes reales del pack, no supuesto (2026-09-04):
    header = 128 bytes (magic 4 + DDS_HEADER 124), sin extension DX10 para
    DXT5. Archivo de muestra: dwFlags=0x81007, dwCaps=0x1000,
    dwMipMapCount=0. dwPitchOrLinearSize YA es el tamano del nivel base y
    coincide exacto con el calculo por bloques (ancho/4 * alto/4 * 16B).
    Tamano de archivo = 128 + dwPitchOrLinearSize, sin relleno. Pillow 12.3
    escribe y decodifica DXT5 nativamente, incluso en tamanos no multiplo de
    4 (padding a bloque completo), probado con (1,1) (3,3) (2,1) (5,3).

USO
    python regenerar_mipmaps.py probar <origen> <destino> [-n 5]
    python regenerar_mipmaps.py generar <origen> <destino>
    python regenerar_mipmaps.py verificar <carpeta> [-n 5]

SIEMPRE escribe a una carpeta DISTINTA del origen. Nunca pisa el pack en
uso. Instalar el resultado en el pack real es un paso aparte, a mano.
"""
from __future__ import annotations

import argparse
import io
import math
import os
import struct
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

from PIL import Image  # noqa: E402

DDSD_MIPMAPCOUNT = 0x00020000
DDSCAPS_COMPLEX = 0x00000008
DDSCAPS_MIPMAP = 0x00400000

OFF_FLAGS = 8
OFF_HEIGHT = 12
OFF_WIDTH = 16
OFF_MIPMAPCOUNT = 28
OFF_CAPS = 108
HEADER_SIZE = 128


def leer_header(datos: bytes):
    if len(datos) < HEADER_SIZE or datos[:4] != b"DDS ":
        return None
    (flags,) = struct.unpack_from("<I", datos, OFF_FLAGS)
    height, width = struct.unpack_from("<II", datos, OFF_HEIGHT)
    (mipcount,) = struct.unpack_from("<I", datos, OFF_MIPMAPCOUNT)
    (caps,) = struct.unpack_from("<I", datos, OFF_CAPS)
    return dict(flags=flags, width=width, height=height, mipcount=mipcount, caps=caps)


def niveles_totales(width: int, height: int) -> int:
    """CalcMipmapLevelsForReplacement: log2(max(w,h)) + 1, incluye el base."""
    return int(math.log2(max(width, height))) + 1


def comprimir_dxt5(im: Image.Image) -> bytes:
    """RGBA -> bytes DXT5 puros, sin el header DDS de 128B que antepone Pillow."""
    buf = io.BytesIO()
    im.save(buf, format="DDS", pixel_format="DXT5")
    return buf.getvalue()[HEADER_SIZE:]


def generar_mip_chain(ruta_entrada: Path, ruta_salida: Path) -> tuple[bool, str]:
    original = ruta_entrada.read_bytes()
    info = leer_header(original)
    if info is None:
        return False, "no es un DDS valido"
    if info["flags"] & DDSD_MIPMAPCOUNT:
        return False, "omitido: ya tiene mipmaps"

    w, h = info["width"], info["height"]
    total = niveles_totales(w, h)
    extra = total - 1
    if extra <= 0:
        return False, "omitido: base ya es 1x1"

    base_bytes = original[HEADER_SIZE:]
    im_base = Image.open(io.BytesIO(original)).convert("RGBA")
    if im_base.size != (w, h):
        return False, "el header dice %dx%d pero Pillow decodifico %s" % (w, h, im_base.size)

    nuevo_header = bytearray(original[:HEADER_SIZE])
    struct.pack_into("<I", nuevo_header, OFF_FLAGS, info["flags"] | DDSD_MIPMAPCOUNT)
    struct.pack_into("<I", nuevo_header, OFF_MIPMAPCOUNT, extra)
    struct.pack_into("<I", nuevo_header, OFF_CAPS, info["caps"] | DDSCAPS_COMPLEX | DDSCAPS_MIPMAP)

    piezas = [bytes(nuevo_header), base_bytes]
    for nivel in range(1, total):
        tw = max(w >> nivel, 1)
        th = max(h >> nivel, 1)
        mini = im_base.resize((tw, th), Image.Resampling.BOX)
        piezas.append(comprimir_dxt5(mini))

    ruta_salida.parent.mkdir(parents=True, exist_ok=True)
    ruta_salida.write_bytes(b"".join(piezas))
    return True, "%d niveles agregados (base %dx%d -> %d total)" % (extra, w, h, total)


def verificar_archivo(ruta: Path) -> bool:
    """Reparsea un archivo generado EXACTAMENTE como PCSX2: por bytes, sin Pillow."""
    datos = ruta.read_bytes()
    info = leer_header(datos)
    if info is None:
        print("  %s: INVALIDO, no es DDS" % ruta.name)
        return False

    print("  %s: %dx%d, dwMipMapCount=%d, flag MIPMAP=%s, tamano=%d" % (
        ruta.name, info["width"], info["height"], info["mipcount"],
        bool(info["flags"] & DDSD_MIPMAPCOUNT), len(datos)))

    pos = HEADER_SIZE
    w, h = info["width"], info["height"]
    ok_todos = True
    for nivel in range(0, info["mipcount"] + 1):
        tw = w if nivel == 0 else max(w >> nivel, 1)
        th = h if nivel == 0 else max(h >> nivel, 1)
        bw = max((tw + 3) // 4, 1)
        bh = max((th + 3) // 4, 1)
        tam = bw * bh * 16
        disponible = len(datos) - pos
        ok = disponible >= tam
        print("    nivel %d: %4dx%-4d  %6d bytes  %s" % (
            nivel, tw, th, tam, "OK" if ok else "FALTAN %d bytes" % (tam - disponible)))
        if not ok:
            ok_todos = False
            break
        pos += tam

    sobrante = len(datos) - pos
    if sobrante:
        print("    ATENCION: %d bytes sobrantes al final (se esperaba 0)" % sobrante)
        ok_todos = False
    return ok_todos


def main():
    salida.tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description="Genera mip chains DDS/DXT5 para el pack de BLACK.")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_probar = sub.add_parser("probar", help="procesa N archivos de muestra a una carpeta aparte")
    p_probar.add_argument("origen")
    p_probar.add_argument("destino")
    p_probar.add_argument("-n", type=int, default=5)

    p_generar = sub.add_parser("generar", help="procesa TODO el pack a una carpeta aparte")
    p_generar.add_argument("origen")
    p_generar.add_argument("destino")

    p_verificar = sub.add_parser("verificar", help="reparsea archivos ya generados, como PCSX2")
    p_verificar.add_argument("carpeta")
    p_verificar.add_argument("-n", type=int, default=5)

    args = ap.parse_args()

    if args.cmd in ("probar", "generar"):
        origen = Path(args.origen)
        destino = Path(args.destino)
        archivos = sorted(origen.glob("*.dds"))
        if args.cmd == "probar":
            archivos = archivos[: args.n]
        print("procesando %d archivo(s) de %s -> %s" % (len(archivos), origen, destino))
        ok = omitidos = fallidos = 0
        for i, f in enumerate(archivos):
            exito, msg = generar_mip_chain(f, destino / f.name)
            if exito:
                ok += 1
                if args.cmd == "probar":
                    print("  %s: %s" % (f.name, msg))
            elif msg.startswith("omitido"):
                omitidos += 1
            else:
                fallidos += 1
                print("  FALLO %s: %s" % (f.name, msg))
            if (i + 1) % 500 == 0:
                print("  ... %d/%d" % (i + 1, len(archivos)))
        print("listo: %d generados, %d omitidos, %d fallidos" % (ok, omitidos, fallidos))

    elif args.cmd == "verificar":
        carpeta = Path(args.carpeta)
        archivos = sorted(carpeta.glob("*.dds"))[: args.n]
        todos_ok = True
        for f in archivos:
            if not verificar_archivo(f):
                todos_ok = False
        print("\nresultado: %s" % ("TODOS OK" if todos_ok else "HAY FALLOS -- ver arriba"))


if __name__ == "__main__":
    main()
