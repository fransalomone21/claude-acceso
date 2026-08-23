# -*- coding: utf-8 -*-
u"""Verificador del apunte. Corre cinco chequeos y devuelve 1 si alguno falla.

    python verificar.py

Los cuatro miran EFECTOS, no precondiciones:

  1. El apunte compila de verdad (no "existe apunte.typ").
  2. La galería compila de verdad.
  3. No quedó ningún circuito en ASCII adentro de un `#circuito(...)`.
  4. Toda figura definida en la biblioteca aparece en la galería. Una
     figura que no está en la galería no se mira nunca, y una figura que
     nadie mira se rompe sin que se entere nadie.
  5. Ningún rótulo largo quedó adentro de un `plot.annotate`. Adentro de
     los ejes sólo entran marcas cortas: cetz-plot recorta la anotación
     contra el área del gráfico, así que un texto largo se corre solo y
     termina cruzando el eje o encimado con otro. Esta alarma habría
     agarrado sola los dos rótulos rotos de `graf-curva-diodo`.

Para probar que la alarma anda —regla 3 del perfil— hay que romperla a
propósito: meter un error de sintaxis en un .typ, o definir una figura y
no agregarla a galeria.typ. Los dos casos tienen que dar rojo.
"""
from __future__ import print_function

import io
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
    # En una sesión en la nube no hay binario `typst` en el PATH y además
    # packages.typst.org está bloqueado por el proxy de egreso. Ahí se usa el
    # módulo de Python y un caché de paquetes armado a mano, cuya ruta viene
    # en TYPST_PACKAGE_CACHE. En la máquina de escritorio no hace falta nada.
    cache = os.environ.get("TYPST_PACKAGE_CACHE")
    try:
        p = subprocess.Popen(
            ["typst", "compile", entrada, salida],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        out = p.communicate()[0].decode("utf-8", "replace")
        codigo = p.returncode
    except OSError:
        try:
            import typst as _typst
        except ImportError:
            fallas.append(
                u"no hay binario `typst` en el PATH ni el módulo `typst` de Python"
            )
            return False
        out, codigo = u"", 0
        kw = {"output": salida}
        if cache:
            kw["package_cache_path"] = cache
        try:
            _typst.compile(entrada, **kw)
        except Exception as e:
            out, codigo = u"%s" % e, 1
    if codigo != 0:
        fallas.append(u"%s NO compila:\n%s" % (nombre, out.strip()[:1500]))
        return False
    print(u"  ok  %s compila" % nombre)
    if os.path.exists(salida):
        os.remove(salida)
    return True


# Deuda declarada: los módulos de la Parte II todavía tienen sus circuitos en
# ASCII. Están enumerados uno por uno a propósito, con la cuenta exacta: así
# el chequeo sigue siendo rojo si aparece ASCII en cualquier OTRO módulo, o si
# en éstos aparece MÁS del que ya había. La lista tiene que llegar a vacía en
# la fase que vectorice la Parte II; un rojo permanente no lo mira nadie, pero
# una deuda sin enumerar tampoco se paga.
ASCII_PENDIENTE = {
    "m7-kirchhoff.typ": 2,
    "m8-nodos-mallas.typ": 5,
    "m9-teoremas.typ": 1,
    "m10-transitorios.typ": 1,
    "m11-fasores.typ": 2,
    "m12-bode.typ": 2,
    "m13-cuadripolos-ao.typ": 2,
}


def sin_ascii():
    malos = []
    deuda = []
    carpeta = os.path.join(AQUI, "modulos")
    for f in sorted(os.listdir(carpeta)):
        if not f.endswith(".typ"):
            continue
        s = io.open(os.path.join(carpeta, f), encoding="utf-8").read()
        n = len(re.findall(r"#circuito\(\[[^\]]*\]\)\[\s*\n```", s))
        if not n:
            continue
        permitido = ASCII_PENDIENTE.get(f, 0)
        if n > permitido:
            malos.append(u"%s (%d, se esperaban %d)" % (f, n, permitido))
        else:
            deuda.append(u"%s (%d)" % (f, n))
    if malos:
        fallas.append(
            u"apareció ASCII nuevo donde no estaba declarado: " + u", ".join(malos)
        )
    elif deuda:
        total = sum(int(d.rsplit("(", 1)[1][:-1]) for d in deuda)
        print(
            u"  ok  ningún circuito ASCII fuera de la deuda declarada "
            u"(%d pendientes en la Parte II)" % total
        )
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



LIMITE_ROTULO = 18


def rotulos_cortos_adentro():
    u"""Chequeo 5: `nota(` y `flecha-nota(` adentro de un `plot.annotate`
    no pueden llevar texto largo. El texto largo va con `rotulo-marco`,
    que dibuja FUERA del plot y no lo toca el recorte de cetz-plot."""
    ruta = os.path.join(BIBLIO, "graficos.typ")
    if not os.path.exists(ruta):
        fallas.append(u"no existe biblioteca/graficos.typ")
        return
    src = io.open(ruta, encoding="utf-8").read()

    largos = []
    for m in re.finditer(r"plot\.annotate\(", src):
        # Recortar el bloque del annotate contando paréntesis.
        i = m.end() - 1
        prof, j = 0, i
        while j < len(src):
            if src[j] == "(":
                prof += 1
            elif src[j] == ")":
                prof -= 1
                if prof == 0:
                    break
            j += 1
        bloque = src[i:j]
        linea0 = src[:i].count("\n") + 1

        for mm in re.finditer(r"(?<![-\w])(flecha-nota|nota)\(", bloque):
            # Contenido del rótulo: el argumento entre corchetes.
            resto = bloque[mm.end():]
            k = resto.find("[")
            if k < 0:
                continue
            prof2, t = 0, k
            while t < len(resto):
                if resto[t] == "[":
                    prof2 += 1
                elif resto[t] == "]":
                    prof2 -= 1
                    if prof2 == 0:
                        break
                t += 1
            crudo = resto[k + 1:t]
            # Lo que se cuenta es el texto visible: sin marcas de Typst.
            texto = re.sub(r"\$[^$]*\$", "x", crudo)      # una fórmula cuenta 1
            texto = re.sub(r"#?\w+\(([^()]*)\)", r"\1", texto)  # text(...)[...]
            texto = texto.replace("\\", " ").strip()
            if len(texto) > LIMITE_ROTULO:
                largos.append(
                    u"%s:%d  %s(...) con %d caracteres: %s"
                    % ("graficos.typ", linea0 + bloque[:mm.start()].count("\n"),
                       mm.group(1), len(texto), texto[:60])
                )

    if largos:
        fallas.append(
            u"rótulos de más de %d caracteres adentro de un plot.annotate "
            u"(van con rotulo-marco, fuera del plot):\n      " % LIMITE_ROTULO
            + u"\n      ".join(largos)
        )
    else:
        print(u"  ok  ningún rótulo largo adentro de los ejes")


print(u"Verificando el apunte...")
compila(os.path.join(AQUI, "apunte.typ"), u"apunte.typ")
compila(os.path.join(BIBLIO, "galeria.typ"), u"galeria.typ")
sin_ascii()
todas_en_galeria()
rotulos_cortos_adentro()

if fallas:
    print(u"\nFALLA (%d):" % len(fallas))
    for f in fallas:
        print(u"  - " + f)
    sys.exit(1)

print(u"\nTodo en verde.")
sys.exit(0)
