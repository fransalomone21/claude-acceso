# -*- coding: utf-8 -*-
u"""Verificador del apunte. Corre cuatro chequeos y devuelve 1 si alguno falla.

    python verificar.py

Los cuatro miran EFECTOS, no precondiciones:

  1. El apunte compila de verdad (no "existe apunte.typ").
  2. La galería compila de verdad.
  3. No quedó ningún circuito en ASCII adentro de un `#circuito(...)`.
  4. Toda figura definida en la biblioteca aparece en la galería. Una
     figura que no está en la galería no se mira nunca, y una figura que
     nadie mira se rompe sin que se entere nadie.

Para probar que la alarma anda —regla 3 del perfil— hay que romperla a
propósito: meter un error de sintaxis en un .typ, o definir una figura y
no agregarla a galeria.typ. Los dos casos tienen que dar rojo.
"""
from __future__ import print_function

import os
import re
import subprocess
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
BIBLIO = os.path.join(AQUI, "biblioteca")

fallas = []


def compila(entrada, nombre):
    salida = os.path.join(
        os.environ.get("TEMP", AQUI), "_verificar_" + os.path.basename(entrada) + ".pdf"
    )
    p = subprocess.Popen(
        ["typst", "compile", entrada, salida],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    out = p.communicate()[0].decode("utf-8", "replace")
    if p.returncode != 0:
        fallas.append(u"%s NO compila:\n%s" % (nombre, out.strip()[:1500]))
        return False
    print(u"  ok  %s compila" % nombre)
    if os.path.exists(salida):
        os.remove(salida)
    return True


def sin_ascii():
    malos = []
    carpeta = os.path.join(AQUI, "modulos")
    for f in sorted(os.listdir(carpeta)):
        if not f.endswith(".typ"):
            continue
        s = open(os.path.join(carpeta, f), encoding="utf-8").read()
        n = len(re.findall(r"#circuito\(\[[^\]]*\]\)\[\s*\n```", s))
        if n:
            malos.append(u"%s (%d)" % (f, n))
    if malos:
        fallas.append(u"quedan circuitos en ASCII en: " + u", ".join(malos))
    else:
        print(u"  ok  ningún circuito quedó en ASCII")


def todas_en_galeria():
    definidas = set()
    for f in ("circuitos.typ", "graficos.typ"):
        s = open(os.path.join(BIBLIO, f), encoding="utf-8").read()
        definidas |= set(re.findall(r"^#let ((?:fig|graf)-[a-z0-9-]+)\(\) =", s, re.M))
    galeria = open(os.path.join(BIBLIO, "galeria.typ"), encoding="utf-8").read()
    # En la galería cada figura aparece dos veces: como rótulo entre
    # comillas y como llamada. Se exigen las dos, así un rótulo que quedó
    # viejo tampoco pasa.
    encontradas = re.findall(r"((?:fig|graf)-[a-z0-9-]+)\(\)", galeria)
    usadas = set(n for n in encontradas if encontradas.count(n) >= 2)
    faltan = sorted(definidas - usadas)
    if faltan:
        fallas.append(
            u"estas figuras no están en galeria.typ y por lo tanto nadie las mira: "
            + u", ".join(faltan)
        )
    else:
        print(u"  ok  las %d figuras están en la galería" % len(definidas))


print(u"Verificando el apunte...")
compila(os.path.join(AQUI, "apunte.typ"), u"apunte.typ")
compila(os.path.join(BIBLIO, "galeria.typ"), u"galeria.typ")
sin_ascii()
todas_en_galeria()

if fallas:
    print(u"\nFALLA (%d):" % len(fallas))
    for f in fallas:
        print(u"  - " + f)
    sys.exit(1)

print(u"\nTodo en verde.")
sys.exit(0)
