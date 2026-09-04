#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
puente_hash_mipmap.py -- le da al pack los nombres que PCSX2 pide cuando el
mipmapping por hardware esta activado.

EL PROBLEMA (docs/09-remaster-visual.md S7.7, causa raiz confirmada)
    GSTextureCache::HashCacheKey::Create hashea el nivel base y, SI hay lod,
    tambien todos los niveles de mip del juego:

        HashTextureLevel(TEX0, ...);          // el base, siempre
        if (lod) for (i=1..nmips) HashTextureLevel(MIP_TEX0, ...);
        ret.TEX0Hash = FinishBlockHash(hash_st);

    O sea que la MISMA textura tiene DOS TEX0Hash: uno sin mipmapping (el que
    trae el pack, volcado en 2022) y otro con mipmapping. Al poner
    hw_mipmap = true, PCSX2 pide el segundo, no lo encuentra, y dibuja el
    original de PS2. Medido: 37 texturas sin reemplazo con mipmap on contra
    5 con mipmap off, misma escena.

LA CLAVE QUE HACE EL MAPEO DETERMINISTA
    En ese mismo Create, el CLUTHash NO depende de lod:

        ret.CLUTHash = clut ? PaletteKeyHash{}({clut, psm.pal}) : 0;

    Asi que entre los dos nombres de una misma textura, el CLUTHash y los bits
    de TEX0 son IDENTICOS y lo unico que cambia es el TEX0Hash. Eso alcanza
    para emparejar sin comparar imagenes. Se verifico ademas por contenido
    (emparejar_dump_pack.py): los pares coinciden.

QUE HACE
    Por cada textura volcada con mipmap activado, busca en el pack la que
    tiene el mismo (CLUTHash, TEX0 bits enmascarado) y escribe una COPIA con
    el nombre nuevo. No borra ni modifica nada del pack: solo agrega nombres.

    El bit 0x4000 de TEX0 (unused0, "was TCC") se enmascara siempre: el pack
    de 2022 lo trae puesto y PCSX2 hoy lo ignora via RemoveUnusedBits().

USO
    python puente_hash_mipmap.py <dumps> <pack> <destino> [--aplicar]

    Sin --aplicar solo informa que haria. El destino es una carpeta aparte:
    instalarla en el pack es un paso a mano, aparte.
"""
from __future__ import annotations

import argparse
import hashlib
import os
import re
import shutil
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import salida  # noqa: E402

# El indice (CLUTHash, TEX0 bits) deja 1 o 2 candidatos; cuando quedan 2 -- dos
# texturas distintas que comparten paleta y tamano -- se desempata por IMAGEN,
# que es lo unico que no cambia entre los dos nombres de una misma textura.
import io  # noqa: E402

from PIL import Image  # noqa: E402

from emparejar_dump_pack import distancia, firma, nivel_chico_como_dds  # noqa: E402

BIT_INUTIL = 0x4000
RX = re.compile(r"^([0-9a-f]+)-([0-9a-f]+)-([0-9a-f]{8})$", re.I)
RX_SIN_CLUT = re.compile(r"^([0-9a-f]+)-([0-9a-f]{8})$", re.I)


def partes(nombre: str):
    """-> (tex0hash, cluthash|None, tex0bits enmascarado) o None si no parsea."""
    tallo = re.sub(r"-mip\d+$", "", Path(nombre).stem)
    m = RX.match(tallo)
    if m:
        return m.group(1).lower(), m.group(2).lower(), int(m.group(3), 16) & ~BIT_INUTIL
    m = RX_SIN_CLUT.match(tallo)
    if m:
        return m.group(1).lower(), None, int(m.group(2), 16) & ~BIT_INUTIL
    return None


def main():
    salida.tolerar_salida_pobre()
    ap = argparse.ArgumentParser()
    ap.add_argument("dumps")
    ap.add_argument("pack")
    ap.add_argument("destino")
    ap.add_argument("--aplicar", action="store_true", help="escribir de verdad las copias")
    ap.add_argument("--umbral", type=float, default=0.90,
                    help="distancia maxima de imagen para aceptar un desempate")
    ap.add_argument("--margen", type=float, default=0.08,
                    help="cuanto tiene que ganarle el mejor al segundo para no ser empate")
    args = ap.parse_args()

    pack_dir, dest = Path(args.pack), Path(args.destino)

    # indice del pack por (cluthash, tex0bits): es lo que NO cambia entre los
    # dos nombres de una misma textura
    idx = defaultdict(list)
    total_pack = 0
    for f in pack_dir.glob("*.dds"):
        p = partes(f.name)
        if p is None:
            continue
        total_pack += 1
        idx[(p[1], p[2])].append(f)
    print("pack   : %d archivos indexados, %d claves (cluthash, tex0bits)" % (total_pack, len(idx)))

    dumps = sorted(Path(args.dumps).glob("*.png"))
    print("dumps  : %d" % len(dumps))
    print()

    hechos = ambiguos = sin_par = no_parsea = ya_estaba = desempatados = duplicados = 0
    plan = []
    for f in dumps:
        p = partes(f.name)
        if p is None:
            no_parsea += 1
            print("  sin parsear : %s" % f.name)
            continue
        tex0hash_nuevo, cluthash, tex0bits = p
        cands = idx.get((cluthash, tex0bits), [])
        if not cands:
            sin_par += 1
            print("  SIN PAR     : %s" % f.name)
            continue
        if len(cands) > 1 and len({hashlib.sha1(c.read_bytes()).digest() for c in cands}) == 1:
            # Los candidatos son el MISMO archivo con distinto nombre: el pack
            # trae variantes de CLUT que comparten los bytes. Medido: 18 de los
            # 19 casos ambiguos de la escena del savestate 03. Elegir cualquiera
            # da el mismo resultado, asi que no hay nada que desempatar.
            duplicados += 1
            origen = cands[0]
        elif len(cands) > 1:
            # desempate por imagen: el dump es la textura de PS2, el candidato
            # su version HD; la estructura sobrevive al upscale aunque el
            # brillo y el contraste no (por eso la firma va normalizada)
            try:
                fd = firma(Image.open(f))
            except Exception:  # noqa: BLE001
                ambiguos += 1
                print("  AMBIGUO (%d), no se pudo leer el dump: %s" % (len(cands), f.name))
                continue
            puntajes = []
            for c in cands:
                r = nivel_chico_como_dds(c.read_bytes())
                if r is None:
                    continue
                try:
                    puntajes.append((distancia(fd, firma(Image.open(io.BytesIO(r[0])))), c))
                except Exception:  # noqa: BLE001
                    pass
            puntajes.sort(key=lambda t: t[0])
            if len(puntajes) < 2 or puntajes[0][0] > args.umbral:
                ambiguos += 1
                print("  AMBIGUO (%d): %s%s" % (
                    len(cands), f.name,
                    "  mejor dist %.3f > umbral" % puntajes[0][0] if puntajes else ""))
                continue
            if puntajes[1][0] - puntajes[0][0] < args.margen:
                ambiguos += 1
                print("  AMBIGUO (%d): %s  empate %.3f vs %.3f" % (
                    len(cands), f.name, puntajes[0][0], puntajes[1][0]))
                continue
            desempatados += 1
            origen = puntajes[0][1]
        else:
            origen = cands[0]
        # el nombre nuevo conserva TODO menos el TEX0Hash, y respeta la
        # convencion de bits del pack (el 0x4000 puesto, como los demas)
        vieja = partes(origen.name)
        nuevo = "%s-%s-%08x%s" % (
            tex0hash_nuevo,
            cluthash if cluthash else "",
            (vieja[2] | BIT_INUTIL),
            origen.suffix)
        nuevo = nuevo.replace("--", "-")
        if (dest / nuevo).exists() or (pack_dir / nuevo).exists():
            ya_estaba += 1
            continue
        plan.append((origen, nuevo))
        hechos += 1

    print()
    print("emparejadas   : %d  (%d por desempate de imagen, %d por candidatos identicos)" % (hechos, desempatados, duplicados))
    print("ya existentes : %d" % ya_estaba)
    print("ambiguas      : %d" % ambiguos)
    print("sin par       : %d" % sin_par)
    print("sin parsear   : %d" % no_parsea)

    if not args.aplicar:
        print("\n(seco: no se escribio nada. Volver a correr con --aplicar)")
        for o, n in plan[:5]:
            print("   %s\n     -> %s" % (o.name, n))
        return

    dest.mkdir(parents=True, exist_ok=True)
    for o, n in plan:
        shutil.copy2(o, dest / n)
    print("\nescritas %d copias en %s" % (len(plan), dest))


if __name__ == "__main__":
    main()
