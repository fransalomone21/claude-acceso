#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
firmas.py — reconocimiento de cabeceras sobre familias de archivos del ISO.

QUÉ CONTESTA
    "¿Los 141 `.WDD` empiezan todos igual?" — y si empiezan igual, en qué
    bytes. Es la pregunta que hay que hacer ANTES de abrir uno en un editor
    hexadecimal, porque contesta sobre la familia entera y no sobre la muestra
    que uno eligió sin querer.

CÓMO BUSCA, Y POR QUÉ ASÍ
    Por **posición de byte**, no por u32. Un u32 leído en little-endian mezcla
    los cuatro bytes y esconde justo lo que importa: que el byte 1 sea `0x02`
    en 141 archivos de 141 se ve enseguida mirando columnas, y se pierde
    mirando enteros. Es la misma lección que "buscar por firma estructural, no
    por ventana de bytes crudos" (ver `05-iso.md`).

    Para cada extensión y cada posición de los primeros N bytes, informa:
      - si el byte es CONSTANTE en toda la familia (y cuál es);
      - si varía, cuántos valores distintos toma.

    Un tramo constante es una firma. Un tramo con dos o tres valores es un
    campo de tipo. Un tramo con un valor por archivo es un hash, un tamaño o
    un offset.

TAMBIÉN
    Prueba si el archivo es un RenderWare binary stream plano: cabecera de
    chunk de 12 bytes (tipo u32, tamaño u32, versión u32) con
    `tamaño == tamaño_del_archivo - 12`. BLACK corre sobre RenderWare, así que
    era la primera hipótesis a matar.

CLI
    python herramientas/firmas.py D:/ --ext WDD DB BKS SSH SLB BIN
    python herramientas/firmas.py D:/ --ext WDD --bytes 32 --ejemplos 5
"""

from __future__ import annotations

import argparse
import collections
import glob
import os
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402

# Los tipos de chunk de RenderWare que aparecerían en un juego de PS2.
RW_CHUNKS = {
    0x01: "Struct", 0x02: "String", 0x03: "Extension", 0x06: "Texture",
    0x07: "Material", 0x08: "MaterialList", 0x0E: "FrameList",
    0x0F: "Geometry", 0x10: "Clump/DFF", 0x11: "Light", 0x14: "Atomic",
    0x15: "TextureNative", 0x16: "TextureDictionary", 0x1A: "GeometryList",
    0x1B: "Animation", 0x1C: "RightToRender", 0x23: "UVAnimDict",
    0x24: "Rights",
}


def imprimible(b: int) -> str:
    return chr(b) if 0x20 <= b <= 0x7E else "."


def es_rw_stream(cab: bytes, tam_archivo: int) -> tuple[bool, str]:
    """¿Los primeros 12 bytes son una cabecera de chunk de RenderWare válida?"""
    if len(cab) < 12:
        return False, ""
    tipo, tam, _ver = struct.unpack("<III", cab[:12])
    if tipo in RW_CHUNKS and tam == tam_archivo - 12:
        return True, RW_CHUNKS[tipo]
    return False, ""


def analizar(raiz: str, ext: str, n_bytes: int) -> dict | None:
    archivos = sorted(glob.glob(os.path.join(raiz, "**", f"*.{ext}"), recursive=True))
    if not archivos:
        return None

    cabeceras, tamanos, rw = [], [], 0
    for f in archivos:
        try:
            tam = os.path.getsize(f)
            with open(f, "rb") as fh:
                cab = fh.read(n_bytes)
        except OSError:
            continue
        if len(cab) < n_bytes:
            cab = cab.ljust(n_bytes, b"\x00")
        cabeceras.append((f, cab))
        tamanos.append(tam)
        if es_rw_stream(cab, tam)[0]:
            rw += 1

    columnas = []
    for i in range(n_bytes):
        vistos = collections.Counter(c[i] for _, c in cabeceras)
        columnas.append(vistos)

    return {"ext": ext, "archivos": archivos, "cabeceras": cabeceras,
            "tamanos": tamanos, "columnas": columnas, "rw": rw}


def informar(r: dict, ejemplos: int) -> None:
    n = len(r["cabeceras"])
    print(f"\n=== .{r['ext']}   {n} archivos ===")
    tam_unicos = sorted(set(r["tamanos"]))
    if len(tam_unicos) <= 4:
        print(f"  tamaños: {', '.join(f'{t:,} B' for t in tam_unicos)}"
              f"   <- fijos, sospechoso de búfer de tamaño fijo")
    else:
        print(f"  tamaños: {min(r['tamanos']):,} .. {max(r['tamanos']):,} B"
              f"  ({len(tam_unicos)} distintos)")
    print(f"  ¿RenderWare binary stream plano?: {r['rw']}/{n}")

    print("  pos : constante | valores distintos")
    firma = []
    for i, vistos in enumerate(r["columnas"]):
        if len(vistos) == 1:
            v = next(iter(vistos))
            firma.append(v)
            print(f"   {i:>2} :   0x{v:02X} '{imprimible(v)}'   CONSTANTE en {n}/{n}")
        else:
            firma.append(None)
            comunes = ", ".join(f"0x{v:02X}(x{c})" for v, c in vistos.most_common(3))
            print(f"   {i:>2} :     --      {len(vistos):>3} valores   {comunes}")

    fijos = [i for i, v in enumerate(firma) if v is not None]
    if fijos:
        txt = "".join(imprimible(firma[i]) if firma[i] is not None else "?"
                      for i in range(len(firma)))
        print(f"  FIRMA (posiciones fijas {fijos}): '{txt}'")

    for f, cab in r["cabeceras"][:ejemplos]:
        hexa = " ".join(f"{b:02X}" for b in cab[:16])
        print(f"    {os.path.basename(f):<18} {os.path.getsize(f):>10,} B  {hexa}")


def main(argv=None) -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(
        description="Firmas de cabecera por familia de archivos del ISO",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="Se busca por POSICIÓN DE BYTE. Un u32 en little-endian esconde "
               "la constante que uno está buscando.")
    ap.add_argument("raiz", help="raíz del ISO montado, p. ej. D:/")
    ap.add_argument("--ext", nargs="+", required=True, help="extensiones a mirar")
    ap.add_argument("--bytes", type=int, default=16, help="cuántos bytes de cabecera")
    ap.add_argument("--ejemplos", type=int, default=3, help="cuántos archivos mostrar")
    args = ap.parse_args(argv)

    hubo = False
    for ext in args.ext:
        r = analizar(args.raiz, ext.lstrip("."), args.bytes)
        if r is None:
            print(f"\n=== .{ext} === sin archivos bajo {args.raiz}")
            continue
        hubo = True
        informar(r, args.ejemplos)
    return 0 if hubo else 1


if __name__ == "__main__":
    raise SystemExit(main())
