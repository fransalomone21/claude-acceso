#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
estado.py — lector de savestates de PCSX2 (.p2s).

Un savestate es un ZIP. Adentro, `eeMemory.bin` son los 32 MB de RAM del
Emotion Engine, crudos. El offset dentro de ese archivo ES la dirección EE
(el mapa principal arranca en 0x00000000), así que sirve directo para
escanear y para generar .pnach.

POR QUÉ IMPORTA
    Leer 32 MB por PINE serían decenas de viajes de red. Un savestate te da
    la foto completa y consistente de un saque. Toda la fase de "buscar la
    aguja" se hace acá, offline, y PINE queda para lo que es bueno: mirar y
    tocar unas pocas direcciones en vivo.

COMPRESIÓN
    PCSX2 moderno comprime los savestates con zstd por defecto. Python no lo
    lee nativamente. Opciones, de mejor a peor:
      1. Poner la compresión en "Uncompressed" (Settings > Advanced >
         Savestate Compression). Es lo que recomendamos para trabajar.
      2. `pip install zstandard` y este módulo lo destraba solo.
      3. Deflate64 NO sirve: Python no lo soporta.

CLI
    python3 estado.py info <archivo.p2s>
    python3 estado.py extraer <archivo.p2s> salida.bin
    python3 estado.py ultimo            # ubica el savestate más reciente
"""

from __future__ import annotations

import argparse
import glob
import os
import platform
import struct
import sys
import zipfile

NOMBRE_EE = "eeMemory.bin"
TAM_EE = 32 * 1024 * 1024  # 32 MB

# métodos de compresión ZIP
ZIP_ALMACENADO = 0
ZIP_DEFLATE = 8
ZIP_DEFLATE64 = 9
ZIP_ZSTD = 93


class EstadoError(RuntimeError):
    pass


def carpeta_savestates() -> str | None:
    """Dónde guarda PCSX2 los savestates en este sistema."""
    sistema = platform.system()
    candidatos = []
    if sistema == "Windows":
        docs = os.path.join(os.path.expanduser("~"), "Documents", "PCSX2", "sstates")
        candidatos.append(docs)
        appdata = os.environ.get("APPDATA")
        if appdata:
            candidatos.append(os.path.join(appdata, "PCSX2", "sstates"))
    elif sistema == "Darwin":
        candidatos.append(
            os.path.expanduser("~/Library/Application Support/PCSX2/sstates")
        )
    else:
        xdg = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
        candidatos.append(os.path.join(xdg, "PCSX2", "sstates"))
        candidatos.append(os.path.expanduser("~/.var/app/net.pcsx2.PCSX2/config/PCSX2/sstates"))
    for c in candidatos:
        if os.path.isdir(c):
            return c
    return None


def ultimo_savestate(carpeta: str | None = None, patron: str = "*.p2s") -> str:
    """El .p2s modificado más recientemente. Sirve sin importar cómo lo nombre PCSX2."""
    carpeta = carpeta or carpeta_savestates()
    if not carpeta:
        raise EstadoError(
            "No encontré la carpeta de savestates de PCSX2. Pasala a mano con --carpeta."
        )
    archivos = glob.glob(os.path.join(carpeta, patron))
    if not archivos:
        raise EstadoError(f"No hay savestates en {carpeta}")
    return max(archivos, key=os.path.getmtime)


def _descomprimir_entrada(zf: zipfile.ZipFile, info: zipfile.ZipInfo) -> bytes:
    """Lee una entrada aunque zipfile no soporte su método de compresión."""
    if info.compress_type in (ZIP_ALMACENADO, ZIP_DEFLATE):
        return zf.read(info)

    if info.compress_type == ZIP_ZSTD:
        try:
            import zstandard  # type: ignore
        except ImportError as e:
            raise EstadoError(
                "El savestate está comprimido con zstd y falta el módulo `zstandard`.\n"
                "Arreglalo de una de estas dos formas:\n"
                "  a) pip install zstandard\n"
                "  b) En PCSX2: Settings > Advanced > Savestate Compression = Uncompressed\n"
                "     (recomendado para ingeniería reversa: guarda y carga más rápido)"
            ) from e
        # Salteamos zipfile y leemos el stream crudo desde el offset de datos.
        with open(zf.filename, "rb") as f:  # type: ignore[arg-type]
            f.seek(info.header_offset)
            cab = f.read(30)
            if cab[:4] != b"PK\x03\x04":
                raise EstadoError("cabecera local de ZIP inválida")
            n_nombre, n_extra = struct.unpack("<HH", cab[26:30])
            f.seek(info.header_offset + 30 + n_nombre + n_extra)
            crudo = f.read(info.compress_size)
        return zstandard.ZstdDecompressor().decompress(
            crudo, max_output_size=max(info.file_size, TAM_EE)
        )

    if info.compress_type == ZIP_DEFLATE64:
        raise EstadoError(
            "El savestate usa Deflate64, que Python no puede leer.\n"
            "En PCSX2: Settings > Advanced > Savestate Compression = Uncompressed"
        )

    raise EstadoError(f"método de compresión ZIP desconocido: {info.compress_type}")


def listar(ruta: str) -> list[tuple[str, int, int]]:
    """(nombre, tamaño_real, método_de_compresión) de cada entrada del savestate."""
    with zipfile.ZipFile(ruta) as zf:
        return [(i.filename, i.file_size, i.compress_type) for i in zf.infolist()]


def leer_ee(ruta: str) -> bytes:
    """Los 32 MB de RAM del EE. offset dentro del buffer == dirección EE."""
    with zipfile.ZipFile(ruta) as zf:
        objetivo = None
        for info in zf.infolist():
            if os.path.basename(info.filename).lower() == NOMBRE_EE.lower():
                objetivo = info
                break
        if objetivo is None:
            nombres = ", ".join(i.filename for i in zf.infolist())
            raise EstadoError(
                f"No encontré {NOMBRE_EE} dentro de {ruta}. Entradas: {nombres}"
            )
        datos = _descomprimir_entrada(zf, objetivo)

    if len(datos) != TAM_EE:
        # No es fatal, pero conviene saberlo.
        print(
            f"aviso: eeMemory.bin mide {len(datos)} bytes (esperaba {TAM_EE})",
            file=sys.stderr,
        )
    return datos


def leer_ee_cacheado(ruta: str, cache_dir: str) -> str:
    """Extrae eeMemory.bin a `cache_dir` y devuelve la ruta. Reusa si ya está al día."""
    os.makedirs(cache_dir, exist_ok=True)
    base = os.path.splitext(os.path.basename(ruta))[0]
    destino = os.path.join(cache_dir, f"{base}.ee.bin")
    if os.path.exists(destino) and os.path.getmtime(destino) >= os.path.getmtime(ruta):
        return destino
    datos = leer_ee(ruta)
    with open(destino, "wb") as f:
        f.write(datos)
    return destino


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Lector de savestates de PCSX2")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_info = sub.add_parser("info", help="lista el contenido de un savestate")
    p_info.add_argument("archivo", nargs="?")

    p_ext = sub.add_parser("extraer", help="extrae eeMemory.bin")
    p_ext.add_argument("archivo", nargs="?")
    p_ext.add_argument("salida")

    p_ult = sub.add_parser("ultimo", help="ruta del savestate más reciente")
    p_ult.add_argument("--carpeta")

    args = ap.parse_args(argv)
    nombres_metodo = {0: "sin comprimir", 8: "deflate", 9: "deflate64", 93: "zstd"}

    try:
        if args.cmd == "ultimo":
            print(ultimo_savestate(args.carpeta))
            return 0

        ruta = args.archivo or ultimo_savestate()
        if args.cmd == "info":
            print(f"savestate: {ruta}")
            for nombre, tam, metodo in listar(ruta):
                print(f"  {nombre:28} {tam:>10,} B  {nombres_metodo.get(metodo, metodo)}")
        elif args.cmd == "extraer":
            datos = leer_ee(ruta)
            with open(args.salida, "wb") as f:
                f.write(datos)
            print(f"{len(datos):,} bytes -> {args.salida}")
    except EstadoError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
