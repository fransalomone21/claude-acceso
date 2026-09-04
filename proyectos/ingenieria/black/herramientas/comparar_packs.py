#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
comparar_packs.py -- que aporta un pack de texturas que el nuestro no tenga.

POR QUE EXISTE (pruebas/remake-texturas-ia-2026-09-04.md)
    El nombre de archivo de un reemplazo es [TEX0Hash]-[CLUTHash]-[bits].ext, y
    el hash sale del contenido de la textura DEL JUEGO, no del pack. Por eso los
    nombres son directamente comparables entre packs distintos del mismo juego:
    saber cuanto suma un pack ajeno es una diferencia de conjuntos sobre nombres
    de archivo, y NO necesita correr el emulador ni mirar una sola imagen.

    Hay seis packs conocidos de BLACK y dos son de agosto de 2026. Ninguno de
    los seis declara su cobertura, asi que medirla es la unica forma de saber
    cual conviene.

DOS TRAMPAS QUE YA COSTARON TIEMPO EN ESTE PROYECTO
    1. EL BIT 14 (0x4000, "unused0 // was TCC"). El pack de 2022 trae la
       convencion vieja y lo lleva puesto; PCSX2 hoy lo ignora via
       RemoveUnusedBits(). Cruzar sin enmascararlo da 0% de coincidencia aunque
       todo coincida: 00005dd4 contra 00001dd4. Se enmascara siempre.
    2. LOS DUPLICADOS NO AVISAN. Si dos packs traen el mismo hash, PCSX2 usa
       emplace() y NO pisa: gana el primero que devuelva el enumerador del
       filesystem, en silencio y sin log. Por eso este script los REPORTA: hay
       que resolverlos a mano antes de juntar dos packs, no dejarlos conviviendo.

USO
    python comparar_packs.py <pack_nuestro> <pack_ajeno> [mas_packs...]
    python comparar_packs.py <pack_nuestro> <pack_ajeno> --listar-nuevas salida.txt

Acepta .dds y .png, y busca recursivamente -- igual que PCSX2, que escanea con
FILESYSTEM_FIND_RECURSIVE, asi que un pack en una subcarpeta cuenta igual.
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

BIT_INUTIL = 0x4000
RX = re.compile(r"^([0-9a-f]+)-([0-9a-f]+)-([0-9a-f]{8})$", re.I)
RX_SIN_CLUT = re.compile(r"^([0-9a-f]+)-([0-9a-f]{8})$", re.I)


def clave(nombre: str):
    """Nombre -> clave comparable entre packs, con el bit 14 enmascarado.

    Se le saca el sufijo -mipN y el -rWxH de region, que no cambian de que
    textura del juego se trata."""
    tallo = Path(nombre).stem
    tallo = re.sub(r"-mip\d+$", "", tallo)
    tallo = re.sub(r"-r\d+x\d+", "", tallo)
    m = RX.match(tallo)
    if m:
        return (m.group(1).lower(), m.group(2).lower(), int(m.group(3), 16) & ~BIT_INUTIL)
    m = RX_SIN_CLUT.match(tallo)
    if m:
        return (m.group(1).lower(), None, int(m.group(2), 16) & ~BIT_INUTIL)
    return None


def cargar(carpeta: Path):
    """-> (claves, archivos_por_clave, cuantos no parsearon)"""
    claves, porclave, raros = set(), {}, 0
    for ext in ("*.dds", "*.png"):
        for f in carpeta.rglob(ext):
            k = clave(f.name)
            if k is None:
                raros += 1
                continue
            claves.add(k)
            porclave.setdefault(k, []).append(f)
    return claves, porclave, raros


def main():
    salida.tolerar_salida_pobre()
    ap = argparse.ArgumentParser()
    ap.add_argument("nuestro", help="carpeta del pack de referencia")
    ap.add_argument("ajenos", nargs="+", help="carpeta(s) del pack a comparar")
    ap.add_argument("--listar-nuevas", help="archivo donde volcar las claves que SOLO tiene el ajeno")
    args = ap.parse_args()

    base = Path(args.nuestro)
    if not base.is_dir():
        print("no existe la carpeta: %s" % base)
        sys.exit(2)
    nuestras, nuestras_por, raros = cargar(base)
    print("REFERENCIA: %s" % base)
    print("   %d claves distintas%s" % (len(nuestras), "  (%d archivos sin parsear)" % raros if raros else ""))
    dup = {k: v for k, v in nuestras_por.items() if len(v) > 1}
    if dup:
        print("   OJO: %d claves con mas de un archivo dentro del propio pack" % len(dup))
    print()

    for a in args.ajenos:
        d = Path(a)
        if not d.is_dir():
            print("%-40s NO EXISTE" % a)
            continue
        suyas, _, raros_a = cargar(d)
        nuevas = suyas - nuestras
        compartidas = suyas & nuestras
        faltantes = nuestras - suyas

        print("PACK: %s" % d)
        print("   claves                   : %d%s" % (
            len(suyas), "  (%d sin parsear)" % raros_a if raros_a else ""))
        print("   YA las teniamos          : %d" % len(compartidas))
        print("   NUEVAS (lo que suma)     : %d   <- esto es lo que se gana" % len(nuevas))
        print("   que el nuestro tiene y el: %d" % len(faltantes))
        if suyas:
            print("   solapamiento             : %.1f%% de sus claves ya estaban" % (
                100.0 * len(compartidas) / len(suyas)))
        if compartidas:
            print("   ATENCION: esas %d compartidas son COLISIONES. PCSX2 no avisa cual gana" % len(compartidas))
            print("             (emplace no pisa): hay que elegir a mano antes de juntarlos.")
        print()

        if args.listar_nuevas and nuevas:
            with open(args.listar_nuevas, "w", encoding="utf-8") as f:
                f.write("# claves que SOLO tiene %s\n" % d)
                f.write("# formato: TEX0Hash CLUTHash TEX0bits(enmascarado)\n")
                for k in sorted(nuevas):
                    f.write("%s %s %08x\n" % (k[0], k[1] or "-", k[2]))
            print("   %d claves nuevas escritas en %s" % (len(nuevas), args.listar_nuevas))
            print()


if __name__ == "__main__":
    main()
