#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
cruzar_dumps_pack.py -- cuantos de los volcados tienen reemplazo en el pack.

POR QUE EXISTE
    PCSX2 NO vuelca lo que ya tiene reemplazo, asi que con el pack activo la
    carpeta dumps/ es el COMPLEMENTO: lo que quedo sin reemplazar. Comparar
    ese complemento entre dos corridas que solo difieren en hw_mipmap mide,
    por efecto, cuantas texturas PIERDEN su reemplazo al activar el
    mipmapping.

EL BIT 14 -- la trampa que ya costo una sesion (2026-09-03)
    El pack es de 2022 y trae la convencion VIEJA del campo TEX0 del nombre:
    lleva puesto el bit 0x4000 (unused0, "was TCC"), que PCSX2 hoy ignora via
    RemoveUnusedBits(). Cruzar sin enmascararlo da 0% de coincidencia
    aunque todo coincida: 00005dd4 contra 00001dd4.

USO
    python cruzar_dumps_pack.py <carpeta_dumps> <carpeta_pack> [mas_dumps...]
"""
from __future__ import annotations

import os
import re
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

BIT_INUTIL = 0x4000
RX = re.compile(r"^([0-9a-f]+)-([0-9a-f]+|r\d+x\d+)-([0-9a-f]{8})$", re.I)


def clave(nombre: str):
    """Nombre de archivo -> clave comparable, con el bit 14 enmascarado."""
    tallo = Path(nombre).stem
    # los volcados de mip llevan sufijo -mipN; se ignora ese sufijo
    tallo = re.sub(r"-mip\d+$", "", tallo)
    m = RX.match(tallo)
    if not m:
        return None
    a, b, tex0 = m.group(1), m.group(2), int(m.group(3), 16)
    return (a.lower(), b.lower(), tex0 & ~BIT_INUTIL)


def cargar(carpeta: Path, patrones=("*.png", "*.dds")):
    claves, sin_parsear = set(), 0
    for pat in patrones:
        for f in carpeta.glob(pat):
            k = clave(f.name)
            if k is None:
                sin_parsear += 1
            else:
                claves.add(k)
    return claves, sin_parsear


def main():
    salida.tolerar_salida_pobre()
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    pack_dir = Path(sys.argv[2])
    pack, pack_raros = cargar(pack_dir, ("*.dds",))
    print("pack   : %s" % pack_dir)
    print("         %d claves%s" % (len(pack), "  (%d sin parsear)" % pack_raros if pack_raros else ""))
    print()

    carpetas = [Path(sys.argv[1])] + [Path(a) for a in sys.argv[3:]]
    for d in carpetas:
        if not d.exists():
            print("%-34s NO EXISTE" % d.name)
            continue
        dumps, raros = cargar(d, ("*.png",))
        en_pack = dumps & pack
        fuera = dumps - pack
        print("%s" % d.name)
        print("   volcadas        : %d%s" % (len(dumps), "  (%d sin parsear)" % raros if raros else ""))
        print("   CON reemplazo   : %d   <- deberia ser ~0: PCSX2 no vuelca lo que reemplaza" % len(en_pack))
        print("   SIN reemplazo   : %d" % len(fuera))
        if en_pack:
            for k in sorted(en_pack)[:5]:
                print("       ojo: %s-%s-%08x esta en el pack y aun asi se volco" % k)
        print()


if __name__ == "__main__":
    main()
