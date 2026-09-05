#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
pack_union.py -- junta varios packs de texturas en uno solo, sin duplicar bytes.

POR QUE
    En el disco hay TRES packs de BLACK y ninguno cubre lo que cubren los tres:

        2022 (el original)   7729 claves   ~1,3 GB   resolucion mas baja
        huekage              2644 claves   ~1,2 GB   resolucion media
        hd-reimagined        1243 claves   ~4,5 GB   la mas alta

    y hoy esta instalado SOLO huekage. Medido sobre la escena del savestate 03,
    que es la unica con volcados completos:

        huekage solo ................ 34 / 120  =  28,3 %
        2022 solo ................... 88 / 120  =  73,3 %
        UNION de los tres ........... 90 / 120  =  75,0 %

    O sea que el pack instalado cubre menos de la mitad que el que reemplazo.

EL CRUCE ESTA VALIDADO, no es aritmetica de papel
    El mismo metodo que predice esos numeros predice **88** para el pack de
    2022, y el proyecto MIDIO 88 por el camino de los volcados (120 texturas
    con el pack apagado, 33 sin cubrir con el pack activo, 120-33 = 87... y 88
    contando la que aparece en las dos). Predicho = medido: el metodo sirve.

LA CLAVE, Y LA TRAMPA QUE HAY QUE CONOCER
    El nombre de un reemplazo es `<TEX0hash>-<CLUThash>-<bits>`, pero:

    1. Los hashes vienen SIN ceros a la izquierda. `42c25ed76508f7b` tiene 15
       digitos y es el mismo hash que `042c25ed76508f7b`.
    2. El campo de bits del pack de 2022 tiene SIEMPRE el bit 14 (0x4000)
       puesto -- los 7729, sin excepcion -- y los volcados del PCSX2 de hoy
       NUNCA lo tienen: 0 de 261, en cuatro tandas distintas. Es una diferencia
       de VERSION DE FORMATO, no un flag por textura.

    Y sin embargo el pack de 2022 CARGA. La unica explicacion que sobrevive:
    **PCSX2 enmascara el bit tambien al indexar el nombre del ARCHIVO**, no
    solo al generar el volcado. Se descarto la alternativa (que la corrida
    hubiera usado una copia renombrada) mirando las tres carpetas derivadas
    del pack de 2022: las tres tienen el bit puesto en el 100 % de sus
    archivos.

    Por eso la clave canonica de este modulo normaliza LAS DOS COSAS: ceros a
    la izquierda y bit 14.

NO DUPLICA BYTES
    La union se arma con ENLACES DUROS cuando el destino esta en la misma
    unidad que el origen. Los tres packs suman ~7 GB; la union no agrega nada.
    Si la unidad es distinta, copia y avisa.

NO TOCA NADA DE LO INSTALADO
    Escribe en una carpeta NUEVA. `replacements/` no se toca: instalarlo es un
    paso aparte y explicito.

USO
    python herramientas/pack_union.py medir
    python herramientas/pack_union.py construir --salida replacements-union
    python herramientas/pack_union.py autotest
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from collections import Counter

BASE = os.path.expandvars(r"%USERPROFILE%\Documents\PCSX2\textures\SLUS-21376")

# Orden de PRIORIDAD: el primero que tenga una clave gana. De mayor a menor
# resolucion, que es lo que se quiere de un pack "con lo mejor de todos".
PACKS = [
    ("hd-reimagined", os.path.join("packs-descargados", "hd-reimagined")),
    ("huekage",       os.path.join("packs-descargados", "huekage")),
    ("2022",          "replacements-sin-mips-2026-09-04"),
]

# escena de referencia: los volcados del savestate 03
ESCENA_TODA = "dumps-B-pack-off"          # con el pack APAGADO: todas
ESCENA_SIN_CUBRIR = "dumps-A2-pack-activo"  # con el pack ACTIVO: las que faltaron

RE_NORMAL = re.compile(r'^([0-9a-f]{1,16})(?:-([0-9a-f]{1,16}))?-([0-9a-f]{8})$', re.I)
RE_REGION = re.compile(r'^([0-9a-f]{1,16})-r(\d+)x(\d+)-([0-9a-f]{8})$', re.I)
EXT = (".dds", ".png")


def clave(nombre):
    """Clave canonica: hashes con ceros a la izquierda y SIN el bit 14."""
    n = os.path.splitext(nombre)[0].lower()
    m = RE_REGION.match(n)
    if m:
        return ("R", m.group(1).zfill(16), m.group(2), m.group(3),
                int(m.group(4), 16) & ~0x4000)
    m = RE_NORMAL.match(n)
    if m:
        return ("N", m.group(1).zfill(16), (m.group(2) or "").zfill(16),
                int(m.group(3), 16) & ~0x4000)
    return None


def nombre_canonico(k, ext):
    """El nombre que el PCSX2 de hoy genera: sin bit 14."""
    if k[0] == "R":
        return f"{k[1]}-r{k[2]}x{k[3]}-{k[4]:08x}{ext}"
    if k[2] == "0" * 16:
        return f"{k[1]}-{k[3]:08x}{ext}"
    return f"{k[1]}-{k[2]}-{k[3]:08x}{ext}"


def escanear(dirs):
    """{clave: (ruta, extension)} de una carpeta."""
    out, raros = {}, []
    for root, _, fs in os.walk(dirs):
        for f in fs:
            if not f.lower().endswith(EXT):
                continue
            k = clave(f)
            if k is None:
                raros.append(f)
                continue
            out.setdefault(k, (os.path.join(root, f), os.path.splitext(f)[1].lower()))
    return out, raros


def _cargar(base):
    packs = []
    for nombre, sub in PACKS:
        d = os.path.join(base, sub)
        if not os.path.isdir(d):
            print(f"  (falta) {nombre}: {d}")
            continue
        m, raros = escanear(d)
        packs.append((nombre, d, m, raros))
    return packs


def cmd_medir(args):
    packs = _cargar(args.base)
    print(f"{'pack':<16} {'claves':>7} {'sin parsear':>12}")
    for nombre, d, m, raros in packs:
        print(f"{nombre:<16} {len(m):>7} {len(raros):>12}")

    union = {}
    origen = Counter()
    for nombre, d, m, raros in packs:
        for k, v in m.items():
            if k not in union:
                union[k] = (nombre, v)
                origen[nombre] += 1
    print(f"\nUNION: {len(union)} claves")
    for nombre, _, _, _ in packs:
        print(f"   aporta {nombre:<16} {origen[nombre]:>6}")

    esc_d = os.path.join(args.base, ESCENA_TODA)
    sin_d = os.path.join(args.base, ESCENA_SIN_CUBRIR)
    if not os.path.isdir(esc_d):
        print("\n(sin volcados de referencia: no se puede estimar cobertura)")
        return
    escena, _ = escanear(esc_d)
    escena = set(escena)
    print(f"\nCOBERTURA sobre la escena de referencia ({len(escena)} texturas):")
    for nombre, d, m, raros in packs:
        c = len(escena & set(m))
        print(f"   {nombre:<16} {c:>4} / {len(escena)}   {c/len(escena)*100:5.1f} %")
    c = len(escena & set(union))
    print(f"   {'UNION':<16} {c:>4} / {len(escena)}   {c/len(escena)*100:5.1f} %")

    if os.path.isdir(sin_d):
        sc, _ = escanear(sin_d)
        medido = len(escena - set(sc))
        p2022 = [x for x in packs if x[0] == "2022"]
        if p2022:
            pred = len(escena & set(p2022[0][2]))
            print(f"\nCONTROL DEL METODO: para el pack de 2022 el cruce predice {pred}"
                  f" y el proyecto MIDIO {medido} por volcados.")
            print(f"   {'COINCIDE' if abs(pred-medido) <= 1 else 'NO COINCIDE -- el cruce no sirve'}")


def cmd_construir(args):
    packs = _cargar(args.base)
    salida = args.salida if os.path.isabs(args.salida) else os.path.join(args.base, args.salida)
    if os.path.exists(salida) and os.listdir(salida):
        raise SystemExit(f"{salida} ya existe y no esta vacia. Borrala o usa otro nombre.")
    os.makedirs(salida, exist_ok=True)

    union = {}
    for nombre, d, m, raros in packs:
        for k, v in m.items():
            union.setdefault(k, (nombre, v))

    mismo = os.path.splitdrive(salida)[0].lower() == os.path.splitdrive(packs[0][1])[0].lower()
    print(f"destino: {salida}")
    print(f"{'enlaces duros (no duplica bytes)' if mismo else 'COPIA (unidad distinta: va a ocupar de verdad)'}")
    origen = Counter()
    enlazados = copiados = 0
    for k, (nombre, (ruta, ext)) in union.items():
        dst = os.path.join(salida, nombre_canonico(k, ext))
        if os.path.exists(dst):
            continue
        hecho = False
        if mismo:
            try:
                os.link(ruta, dst)
                hecho = True
                enlazados += 1
            except OSError:
                hecho = False
        if not hecho:
            import shutil
            shutil.copy2(ruta, dst)
            copiados += 1
        origen[nombre] += 1

    print(f"\n{len(union)} archivos: {enlazados} enlazados, {copiados} copiados")
    for nombre, _, _, _ in packs:
        print(f"   de {nombre:<16} {origen[nombre]:>6}")

    # VERIFICA POR EFECTO: se relee el destino del disco y se compara la clave
    hechos, raros = escanear(salida)
    print(f"\nVERIFICACION (releyendo la carpeta creada):")
    print(f"   claves en el destino : {len(hechos)}   (se esperaban {len(union)})")
    print(f"   sin parsear          : {len(raros)}")
    faltan = set(union) - set(hechos)
    if faltan or raros:
        print(f"   FALLA: faltan {len(faltan)} claves")
        return 1
    b = sum(os.path.getsize(os.path.join(salida, f)) for f in os.listdir(salida))
    print(f"   tamano logico        : {b/1073741824:.2f} GB"
          f"{' (compartido por enlaces duros: no ocupa de nuevo)' if enlazados else ''}")
    print(f"\nPARA INSTALARLO (con PCSX2 CERRADO), moviendo lo que hay hoy:")
    print(f"   move \"{os.path.join(args.base,'replacements')}\" \"{os.path.join(args.base,'replacements-huekage-guardado')}\"")
    print(f"   move \"{salida}\" \"{os.path.join(args.base,'replacements')}\"")
    return 0


def cmd_autotest(args):
    ok = True

    def chequeo(nombre, obtenido, esperado):
        nonlocal ok
        bien = obtenido == esperado
        ok = ok and bien
        print(f"  [{'OK ' if bien else 'MAL'}] {nombre}: {obtenido}"
              f"{'' if bien else f'  (se esperaba {esperado})'}")

    print("LA CLAVE CANONICA -- lo que tiene que unificar")
    chequeo("ceros a la izquierda en el CLUT",
            clave("11e6d8baf2c7d19a-42c25ed76508f7b-00001554.dds"),
            clave("11e6d8baf2c7d19a-042c25ed76508f7b-00001554.dds"))
    chequeo("bit 14 (la convencion vieja contra la nueva)",
            clave("139cb4939fbb1fe4-700464e5700276c-00005994.dds"),
            clave("139cb4939fbb1fe4-700464e5700276c-00001994.dds"))
    chequeo("dds y png son la MISMA clave",
            clave("100bc79f62267158-2428fc0d6625fe4f-00002213.png"),
            clave("100bc79f62267158-2428fc0d6625fe4f-00002213.dds"))
    chequeo("el formato de region parsea",
            clave("1a42174adcae5c71-r640x448-00402a81.dds") is not None, True)
    chequeo("nombre sin CLUT parsea", clave("1013f65a2caedd73-00001980.dds") is not None, True)

    print("\nSABOTAJES -- tiene que decir que NO")
    for n in ("cualquiercosa.dds", "1234.dds", "-.dds",
              "11e6d8baf2c7d19a-42c25ed76508f7b-zzzz1554.dds"):
        r = clave(n)
        bien = r is None
        ok = ok and bien
        print(f"  [{'OK ' if bien else 'MAL'}] rechaza {n!r}: {r}")

    print("\nY NO tiene que unificar de mas:")
    d = clave("139cb4939fbb1fe4-700464e5700276c-00001994.dds")
    e = clave("139cb4939fbb1fe4-700464e5700276c-00001995.dds")
    chequeo("dos bits distintos que NO son el 14 siguen distintos", d != e, True)

    print("\nEL NOMBRE CANONICO vuelve a la convencion del PCSX2 de hoy")
    chequeo("sale sin el bit 14",
            nombre_canonico(clave("139cb4939fbb1fe4-700464e5700276c-00005994.dds"), ".dds"),
            "139cb4939fbb1fe4-0700464e5700276c-00001994.dds")

    print("\n" + ("TODO OK" if ok else "HAY FALLAS"))
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser(description="Junta packs de texturas en uno solo")
    ap.add_argument("--base", default=BASE)
    sub = ap.add_subparsers(dest="cmd", required=True)
    a = sub.add_parser("medir", help="claves, solape y cobertura estimada")
    a.set_defaults(f=cmd_medir)
    b = sub.add_parser("construir", help="arma la union en una carpeta NUEVA")
    b.add_argument("--salida", default="replacements-union")
    b.set_defaults(f=cmd_construir)
    c = sub.add_parser("autotest", help="la clave canonica, con sabotajes")
    c.set_defaults(f=cmd_autotest)
    args = ap.parse_args()
    sys.exit(args.f(args) or 0)


if __name__ == "__main__":
    main()
