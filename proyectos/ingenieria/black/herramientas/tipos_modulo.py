#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Nombra los tipos de modulo del stage por las CADENAS que referencia su handler.

De donde sale: el handler del tipo 0x2D (FUN_00175980) referencia 0x003F54A0,
que es 'Physics object %s tagged for Pathfinding collision...'. O sea que los
handlers traen cadenas de diagnostico que dicen QUE construyen. Barrer los 45
handlers a mano son 45 llamadas de 8 segundos: esto lo hace solo.

Uso:
    python herramientas/tipos_modulo.py autotest
    python herramientas/tipos_modulo.py cadenas 0x00175980
    python herramientas/tipos_modulo.py barrer [--salida archivo.json]

La cadena encontrada es EVIDENCIA DE LECTURA, no de efecto: nombra el handler,
no confirma el tipo. Un tipo no se da por identificado hasta verificarlo por
efecto (regla de la fase 7e).
"""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(AQUI)
VOLCADO = os.path.join(RAIZ, "volcados", "ee-e4.bin")
KB = os.path.join(RAIZ, "kb", "stage-modulos.json")
DECOMPILAR = os.path.join(AQUI, "decompilar.py")

# Secciones donde puede vivir una cadena. Salen de `decompilar.py info`.
SECCIONES = [
    (0x003BC380, 0x003F215B),   # .data
    (0x003F2280, 0x0040C7A7),   # .rodata
    (0x0040D980, 0x0040E57F),   # .sdata
]

RE_CONST = re.compile(r"0x([0-9a-fA-F]{5,8})\b")
MIN_LARGO = 4


def _cargar_volcado(ruta=VOLCADO):
    with open(ruta, "rb") as f:
        return f.read()


def en_seccion(a, secciones=SECCIONES):
    return any(lo <= a <= hi for lo, hi in secciones)


def leer_cadena(datos, a, min_largo=MIN_LARGO, max_largo=400):
    """Devuelve la cadena ASCII NUL-terminada en `a`, o None."""
    if a >= len(datos):
        return None
    fin = datos.find(b"\x00", a, a + max_largo)
    if fin < 0 or fin - a < min_largo:
        return None
    crudo = datos[a:fin]
    # Se aceptan \n y \t; nada mas fuera de ASCII imprimible.
    for c in crudo:
        if not (0x20 <= c < 0x7F or c in (0x09, 0x0A)):
            return None
    return crudo.decode("ascii")


def decompilar(direccion):
    r = subprocess.run(
        [sys.executable, DECOMPILAR, "c", "0x%08X" % direccion],
        capture_output=True, text=True)
    return r.stdout


def cadenas_de(direccion, datos=None, texto=None, re_const=RE_CONST,
               secciones=SECCIONES, min_largo=MIN_LARGO):
    """Cadenas referenciadas por la funcion. Los parametros sobran para el uso
    normal: existen para que el autotest pueda sabotearlos."""
    if datos is None:
        datos = _cargar_volcado()
    if texto is None:
        texto = decompilar(direccion)
    vistas = []
    for m in re_const.finditer(texto):
        a = int(m.group(1), 16)
        if not en_seccion(a, secciones):
            continue
        s = leer_cadena(datos, a, min_largo=min_largo)
        if s and (a, s) not in vistas:
            vistas.append((a, s))
    return vistas


# --------------------------------------------------------------------------
# autotest -- la alarma se prueba ROMPIENDOLA (regla 3 del perfil)
# --------------------------------------------------------------------------
CASO_ANCLA = (0x00175980, 0x003F54A0, "Physics object")


def autotest():
    fallas = 0
    datos = _cargar_volcado()
    dirn, addr_esp, frag_esp = CASO_ANCLA

    print("== caso confirmado ==")
    texto = decompilar(dirn)
    hits = cadenas_de(dirn, datos=datos, texto=texto)
    ok = any(a == addr_esp and frag_esp in s for a, s in hits)
    print("  %s  FUN_%08x -> %08X %r"
          % ("OK " if ok else "MAL", dirn, addr_esp, frag_esp))
    if not ok:
        fallas += 1
        for a, s in hits:
            print("       encontrado: %08X %r" % (a, s[:60]))

    print()
    print("== sabotaje: el autotest tiene que ponerse en rojo ==")

    # (a) volcado corrido un byte -> la cadena deja de empezar donde va
    corrido = b"\x00" + datos
    hits_a = cadenas_de(dirn, datos=corrido, texto=texto)
    detecta_a = not any(a == addr_esp and frag_esp in s for a, s in hits_a)
    print("  %s  (a) volcado corrido un byte -> %s"
          % ("OK " if detecta_a else "MAL", "lo detecta" if detecta_a else "NO lo detecta"))
    if not detecta_a:
        fallas += 1

    # (b) el regex de constantes exige 9+ digitos -> no matchea ninguna
    re_roto = re.compile(r"0x([0-9a-fA-F]{9,12})\b")
    hits_b = cadenas_de(dirn, datos=datos, texto=texto, re_const=re_roto)
    detecta_b = len(hits_b) == 0
    print("  %s  (b) regex de constantes roto -> %s"
          % ("OK " if detecta_b else "MAL", "lo detecta" if detecta_b else "NO lo detecta"))
    if not detecta_b:
        fallas += 1

    # (c) rango de secciones vacio -> nada cae adentro
    hits_c = cadenas_de(dirn, datos=datos, texto=texto, secciones=[(1, 2)])
    detecta_c = len(hits_c) == 0
    print("  %s  (c) rango de secciones vacio -> %s"
          % ("OK " if detecta_c else "MAL", "lo detecta" if detecta_c else "NO lo detecta"))
    if not detecta_c:
        fallas += 1

    print()
    if fallas:
        print("AUTOTEST EN ROJO: %d falla(s)" % fallas)
        return 1
    print("AUTOTEST OK: 1 caso confirmado y 3 sabotajes detectados")
    return 0


def barrer(salida=None):
    with open(KB, encoding="utf-8") as f:
        kb = json.load(f)
    datos = _cargar_volcado()

    handlers = {}
    for t in kb["tipos"]:
        for h in [t["handler"]] + t.get("handler_extra", []):
            if h:
                handlers.setdefault(h, []).append(t["tipo"])

    print("handlers distintos a barrer: %d" % len(handlers), file=sys.stderr)
    res = {}
    for i, (h, tipos) in enumerate(sorted(handlers.items()), 1):
        direccion = int(h.replace("FUN_", ""), 16)
        hits = cadenas_de(direccion, datos=datos)
        res[h] = {"tipos": tipos, "cadenas": [[("0x%08X" % a), s] for a, s in hits]}
        print("[%2d/%2d] %s (tipos %s): %d cadena(s)"
              % (i, len(handlers), h, ",".join(tipos), len(hits)), file=sys.stderr)
        for a, s in hits:
            print("          %08X %r" % (a, s[:90]), file=sys.stderr)

    texto = json.dumps(res, indent=2, ensure_ascii=False)
    if salida:
        with open(salida, "w", encoding="utf-8") as f:
            f.write(texto)
        print("escrito: %s" % salida, file=sys.stderr)
    else:
        print(texto)
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("autotest")
    p = sub.add_parser("cadenas")
    p.add_argument("direccion")
    p = sub.add_parser("barrer")
    p.add_argument("--salida")
    a = ap.parse_args()

    if a.cmd == "autotest":
        return autotest()
    if a.cmd == "cadenas":
        for addr, s in cadenas_de(int(a.direccion, 16)):
            print("%08X  %r" % (addr, s))
        return 0
    return barrer(a.salida)


if __name__ == "__main__":
    sys.exit(main())
