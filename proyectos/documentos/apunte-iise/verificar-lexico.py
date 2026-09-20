#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verificar-lexico.py -- el medidor de la regla propia 1 del apunte de IISE.

En esta materia dos palabras distintas son dos conceptos distintos, y el
parcial se corrige asi. El lexico no es estilo: es contenido. Este script
mide tres cosas sobre los modulos del apunte, contra `fuentes/glosario.md`:

  (a) TERMINO SIN DEFINIR -- ningun termino marcado `#t[...]` en un modulo
      puede usarse sin tener su entrada en el glosario.
  (b) PAR PROHIBIDO -- la catedra dice `requerimiento` (742 apariciones) y
      no `requisito` (8); `interesado` (38) y no `stakeholder` (5). Medido
      sobre las 7 clases el 2026-09-20. El apunte se escribe como se
      corrige.
  (c) DOBLE DEFINICION -- ningun termino puede tener dos entradas en el
      glosario. Dos definiciones del mismo termino divergen, y la que se
      lea primero gana por azar.

Sale con codigo 1 si algo esta en rojo. Su saboteador es
`probar-verificar-lexico.py`, que lo rompe a proposito y exige ver el rojo:
un verificador que nunca fallo esta sin verificar.

Uso:
    python verificar-lexico.py                  # sobre el arbol real
    python verificar-lexico.py --raiz <dir>     # sobre una copia (saboteador)
    python verificar-lexico.py --listar         # imprime el lexico y sale

LA EXCEPCION SE DECLARA, NO SE CALLA. Una linea que legitimamente nombra
una palabra prohibida -- la tabla del modulo 0 que dice justamente cual NO
se usa -- lleva el marcador `// lexico-ok` en la MISMA linea. Sin marcador
no pasa; con marcador queda escrito quien decidio la excepcion y donde.
"""

import argparse
import re
import sys
import unicodedata
from pathlib import Path

# La consola de Windows es cp1252 y este archivo habla con acentos. Sin
# esto, imprimir un termino acentuado revienta con UnicodeEncodeError y el
# medidor se cae por la salida, no por lo que mide. Ya pagado en
# buscar-definicion.py.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

AQUI = Path(__file__).resolve().parent

# Los pares medidos sobre las 7 clases. Se dice / no se dice / el conteo que
# lo decidio. El conteo viaja con el par a proposito: el dia que alguien
# quiera discutir el par, la evidencia esta al lado y no en un chat perdido.
PARES_PROHIBIDOS = [
    ("requisito", "requerimiento", "742 contra 8"),
    ("requisitos", "requerimientos", "742 contra 8"),
    ("stakeholder", "interesado", "38 contra 5"),
    ("stakeholders", "interesados", "38 contra 5"),
]

MARCADOR_EXCEPCION = "lexico-ok"


def plano(texto):
    """Minusculas y sin acentos: `Ambiguedad` y `ambiguedad` son el mismo
    termino, y el glosario no puede depender de como se tipeo."""
    sin = unicodedata.normalize("NFD", texto.lower())
    return "".join(c for c in sin if unicodedata.category(c) != "Mn").strip()


def alias_de_titulo(titulo):
    """Los alias que aporta un encabezado `### ` del glosario.

    Una entrada puede definir mas de un termino, y el apunte los marca por
    separado:
        `### entidad (o elemento)`              -> entidad, elemento
        `### ciencia - tecnologia - ingenieria` -> los tres, y el conjunto
        `### tabla N2 (diagrama N2)`            -> los dos
        `### PDP -- proceso de desarrollo...`   -> la sigla y el nombre largo
        `### influencias ascendentes y descendentes`
                                                -> cada una por separado
    La regla: vale el titulo completo, vale lo de afuera del parentesis,
    vale lo de adentro (sin el "o " inicial), vale cada trozo separado por
    el punto medio o por la raya, y vale cada mitad de un titulo unido por
    "y"/"e" -- arrastrando el sustantivo comun cuando la segunda mitad es
    solo el adjetivo ("relaciones formales y funcionales" -> tambien
    "relaciones funcionales"). Todo normalizado con plano().
    """
    alias = {plano(titulo)}
    afuera = re.sub(r"\(.*?\)", " ", titulo)
    alias.add(plano(afuera))
    for dentro in re.findall(r"\((.*?)\)", titulo):
        dentro = re.sub(r"^\s*o\s+", "", dentro)
        alias.add(plano(dentro))
    # Separadores de "la misma entrada, otro nombre": punto medio y raya.
    trozos = re.split(r"[·•]|\s[—–-]{1,2}\s", afuera)
    for trozo in trozos:
        alias.add(plano(trozo))
    # "A y B": las dos mitades valen por separado. Si la segunda es solo un
    # adjetivo, hereda el sustantivo de la primera -- si no, "relaciones
    # formales y funcionales" dejaria "funcionales" suelto, que no es un
    # termino.
    for trozo in list(trozos):
        partes = re.split(r"\s+[ye]\s+", trozo)
        if len(partes) < 2:
            continue
        cabeza = partes[0].split()
        for parte in partes:
            alias.add(plano(parte))
            if len(parte.split()) == 1 and len(cabeza) > 1:
                alias.add(plano(cabeza[0] + " " + parte))
    return {a for a in alias if a}


def leer_glosario(ruta):
    """Devuelve (alias -> titulo canonico, lista de titulos en orden)."""
    if not ruta.exists():
        print("[FAIL] no existe el glosario: %s" % ruta)
        sys.exit(1)
    titulos = []
    for linea in ruta.read_text(encoding="utf-8").splitlines():
        if linea.startswith("### "):
            titulos.append(linea[4:].strip())
    lexico = {}
    for titulo in titulos:
        for a in alias_de_titulo(titulo):
            lexico.setdefault(a, titulo)
    return lexico, titulos


def modulos_de(raiz):
    """Los .typ del apunte. Se ordenan para que el reporte sea estable:
    una salida que cambia de orden entre corridas no se puede diffear."""
    dirs = [raiz / "apunte" / "modulos", raiz / "apunte" / "anexos"]
    archivos = []
    for d in dirs:
        if d.is_dir():
            archivos.extend(sorted(d.glob("*.typ")))
    return archivos


def sin_comentarios(linea):
    """El texto de la linea hasta el `//`. Un comentario de Typst no sale
    impreso, asi que no puede hacer fallar un chequeo de lo que se lee."""
    corte = linea.find("//")
    return linea if corte < 0 else linea[:corte]


def chequear_terminos(archivos, lexico):
    """(a) todo `#t[...]` tiene entrada en el glosario."""
    fallos = []
    patron = re.compile(r"#t\[([^\]\[]*)\]")
    for arch in archivos:
        for i, linea in enumerate(arch.read_text(encoding="utf-8").splitlines(), 1):
            for crudo in patron.findall(sin_comentarios(linea)):
                # Se limpia el marcado de Typst que pueda venir adentro
                # (`*negrita*`, `_cursiva_`) y la puntuacion del final.
                termino = re.sub(r"[*_#]", "", crudo).strip(" .,;:")
                if not termino:
                    continue
                if plano(termino) not in lexico:
                    fallos.append((arch, i, termino))
    return fallos


def chequear_pares(archivos):
    """(b) ninguna palabra prohibida, salvo excepcion declarada."""
    fallos = []
    patrones = [
        (re.compile(r"\b%s\b" % mal, re.IGNORECASE), mal, bien, conteo)
        for mal, bien, conteo in PARES_PROHIBIDOS
    ]
    for arch in archivos:
        for i, linea in enumerate(arch.read_text(encoding="utf-8").splitlines(), 1):
            if MARCADOR_EXCEPCION in linea:
                continue
            texto = sin_comentarios(linea)
            for patron, mal, bien, conteo in patrones:
                if patron.search(texto):
                    fallos.append((arch, i, mal, bien, conteo))
    return fallos


def chequear_duplicados(titulos):
    """(c) ningun termino definido dos veces en el glosario."""
    vistos = {}
    fallos = []
    for titulo in titulos:
        clave = plano(titulo)
        if clave in vistos:
            fallos.append((titulo, vistos[clave]))
        else:
            vistos[clave] = titulo
    return fallos


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--raiz", default=str(AQUI),
                    help="raiz del proyecto (el saboteador le pasa una copia)")
    ap.add_argument("--listar", action="store_true",
                    help="imprime el lexico controlado y sale")
    args = ap.parse_args()

    raiz = Path(args.raiz).resolve()
    lexico, titulos = leer_glosario(raiz / "fuentes" / "glosario.md")

    if args.listar:
        for titulo in titulos:
            print(titulo)
        return 0

    archivos = modulos_de(raiz)

    print("VERIFICADOR DE LEXICO -- apunte de IISE")
    print("  glosario : %d terminos, %d alias" % (len(titulos), len(lexico)))
    print("  modulos  : %d archivo(s) .typ" % len(archivos))
    print("")

    rojo = 0

    dup = chequear_duplicados(titulos)
    if dup:
        rojo += len(dup)
        print("[FAIL] (c) termino definido DOS VECES en el glosario:")
        for titulo, antes in dup:
            print("       '%s' ya estaba como '%s'" % (titulo, antes))
    else:
        print("[OK  ] (c) ningun termino tiene dos definiciones")

    if not archivos:
        # No es verde ni rojo: es que todavia no hay nada que medir. Decirlo
        # asi evita el verde vacio, que es la falla silenciosa de todo
        # verificador -- da OK porque no miro nada.
        print("[----] (a) y (b) sin medir: todavia no hay modulos escritos")
        print("")
        print("SIN MODULOS QUE MEDIR. El glosario si se midio.")
        # Sale en 1 aunque no haya nada roto, y eso es deliberado: dos de los
        # tres chequeos no corrieron. Un verificador que devuelve 0 porque no
        # miro nada es la falla silenciosa que este archivo existe para no
        # tener. "No medi" no es "esta bien".
        return 1

    sin_definir = chequear_terminos(archivos, lexico)
    if sin_definir:
        rojo += len(sin_definir)
        print("[FAIL] (a) termino marcado #t[] que NO esta en el glosario:")
        for arch, i, termino in sin_definir:
            print("       %s:%d  '%s'" % (arch.name, i, termino))
    else:
        print("[OK  ] (a) todo termino marcado tiene su entrada en el glosario")

    pares = chequear_pares(archivos)
    if pares:
        rojo += len(pares)
        print("[FAIL] (b) palabra prohibida por el lexico de la catedra:")
        for arch, i, mal, bien, conteo in pares:
            print("       %s:%d  '%s' -> va '%s'  (medido: %s)"
                  % (arch.name, i, mal, bien, conteo))
        print("       Si la aparicion es legitima, declarar la excepcion")
        print("       con el marcador '%s' en esa misma linea." % MARCADOR_EXCEPCION)
    else:
        print("[OK  ] (b) ninguna palabra del par prohibido")

    print("")
    if rojo:
        print("LEXICO EN ROJO: %d problema(s). No se cierra el modulo asi." % rojo)
        return 1
    print("LEXICO EN VERDE.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
