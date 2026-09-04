#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mipmaps_debug_color.py -- pack de DIAGNOSTICO: cada nivel de mip, un color plano.

POR QUE EXISTE (ver docs/09-remaster-visual.md S7.6 y S7.7)
    El pack con mip chain real quedo verificado por BYTES (8225/8225) y por
    PIXEL, y aun asi el sintoma volvio en pantalla. La verificacion estatica
    del archivo se agoto: puede decir que el archivo esta bien construido,
    NUNCA que PCSX2 lo esta leyendo ni QUE NIVEL elige. Este pack contesta
    justo eso, y por efecto: se mira la pantalla y el COLOR dice el nivel.

    Es la tecnica clasica de debug de mipmaps, y separa de un saque las tres
    hipotesis que quedaron abiertas:
      - superficie con su textura NORMAL  -> se esta usando el nivel 0
      - superficie de un COLOR PLANO      -> se usa ese nivel; el chain SE LEE
      - superficie borrosa y SIN color    -> el chain NO se lee (los niveles
                                             salen del original de PS2)

QUE HACE
    Copia el nivel 0 BYTE A BYTE del original (asi la escena sigue siendo
    reconocible y el HUD no se rompe) y reemplaza cada nivel siguiente por un
    color plano inconfundible contra la paleta gris/marron de BLACK.

    El header se parchea igual que en regenerar_mipmaps.py -- mismos 3 campos,
    misma formula de cantidad de niveles -- para que la UNICA diferencia con
    el pack real sea el CONTENIDO de los niveles, no su estructura. Si este
    pack muestra colores, el pack real se esta leyendo igual de bien.

USO
    python mipmaps_debug_color.py <origen> <destino> [-n N]

SIEMPRE escribe a una carpeta DISTINTA. Instalar es un paso aparte, a mano.
"""
from __future__ import annotations

import argparse
import io
import os
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

from PIL import Image  # noqa: E402

from regenerar_mipmaps import (  # noqa: E402
    DDSCAPS_COMPLEX,
    DDSCAPS_MIPMAP,
    DDSD_MIPMAPCOUNT,
    HEADER_SIZE,
    OFF_CAPS,
    OFF_FLAGS,
    OFF_MIPMAPCOUNT,
    comprimir_dxt5,
    leer_header,
    niveles_totales,
)

# Nivel -> color. El 0 nunca se pinta: son los bytes originales intactos.
# Elegidos por maxima separacion contra los grises/marrones del juego, y
# entre si, para que se distingan aun en una captura comprimida.
COLORES = {
    1: (255, 0, 255),    # magenta
    2: (0, 255, 0),      # verde
    3: (0, 255, 255),    # cyan
    4: (255, 0, 0),      # rojo
    5: (0, 0, 255),      # azul
    6: (255, 255, 0),    # amarillo
}
COLOR_RESTO = (255, 128, 0)  # naranja, para nivel 7 en adelante

# (ancho, alto, color) -> bytes DXT5 ya comprimidos. Un color plano comprime
# igual siempre, asi que se calcula una vez por tamano y se reusa: es lo que
# hace que el pack entero salga en minutos y no en horas.
_cache: dict[tuple[int, int, tuple[int, int, int]], bytes] = {}


def bloque_color(w: int, h: int, color: tuple[int, int, int]) -> bytes:
    clave = (w, h, color)
    if clave not in _cache:
        im = Image.new("RGBA", (w, h), color + (255,))
        _cache[clave] = comprimir_dxt5(im)
    return _cache[clave]


def generar_debug(ruta_entrada: Path, ruta_salida: Path) -> tuple[bool, str]:
    original = ruta_entrada.read_bytes()
    info = leer_header(original)
    if info is None:
        return False, "no es un DDS valido"

    w, h = info["width"], info["height"]
    total = niveles_totales(w, h)
    extra = total - 1
    if extra <= 0:
        return False, "omitido: base ya es 1x1"

    # El origen puede ser el pack YA con mip chain: en ese caso el nivel 0 son
    # los primeros dwPitchOrLinearSize bytes y el resto se descarta. Se calcula
    # el tamano del nivel 0 por bloques en vez de confiar en el header.
    tam_base = max((w + 3) // 4, 1) * max((h + 3) // 4, 1) * 16
    base_bytes = original[HEADER_SIZE:HEADER_SIZE + tam_base]
    if len(base_bytes) < tam_base:
        return False, "archivo corto: nivel 0 incompleto"

    nuevo_header = bytearray(original[:HEADER_SIZE])
    struct.pack_into("<I", nuevo_header, OFF_FLAGS, info["flags"] | DDSD_MIPMAPCOUNT)
    struct.pack_into("<I", nuevo_header, OFF_MIPMAPCOUNT, extra)
    struct.pack_into("<I", nuevo_header, OFF_CAPS, info["caps"] | DDSCAPS_COMPLEX | DDSCAPS_MIPMAP)

    piezas = [bytes(nuevo_header), base_bytes]
    for nivel in range(1, total):
        tw = max(w >> nivel, 1)
        th = max(h >> nivel, 1)
        piezas.append(bloque_color(tw, th, COLORES.get(nivel, COLOR_RESTO)))

    ruta_salida.parent.mkdir(parents=True, exist_ok=True)
    ruta_salida.write_bytes(b"".join(piezas))
    return True, "%d niveles de color (base %dx%d)" % (extra, w, h)


def main():
    salida.tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description="Pack de diagnostico: un color plano por nivel de mip.")
    ap.add_argument("origen")
    ap.add_argument("destino")
    ap.add_argument("-n", type=int, default=0, help="procesar solo N archivos (0 = todos)")
    args = ap.parse_args()

    origen, destino = Path(args.origen), Path(args.destino)
    archivos = sorted(origen.glob("*.dds"))
    if args.n:
        archivos = archivos[: args.n]

    print("LEYENDA nivel -> color")
    print("  0: textura NORMAL (bytes originales, sin tocar)")
    for n, c in COLORES.items():
        print("  %d: RGB%s" % (n, c))
    print("  7+: RGB%s" % (COLOR_RESTO,))
    print("\nprocesando %d archivo(s)\n  de : %s\n  a  : %s" % (len(archivos), origen, destino))

    t0 = time.time()
    ok = omitidos = fallidos = 0
    for i, f in enumerate(archivos):
        exito, msg = generar_debug(f, destino / f.name)
        if exito:
            ok += 1
        elif msg.startswith("omitido"):
            omitidos += 1
        else:
            fallidos += 1
            print("  FALLO %s: %s" % (f.name, msg))
        if (i + 1) % 1000 == 0:
            print("  ... %d/%d  (%.0f s)" % (i + 1, len(archivos), time.time() - t0))

    print("listo en %.0f s: %d generados, %d omitidos, %d fallidos" % (
        time.time() - t0, ok, omitidos, fallidos))
    print("tamanos distintos cacheados: %d" % len(_cache))


if __name__ == "__main__":
    main()
