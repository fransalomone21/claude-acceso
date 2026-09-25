"""medir-estilo.py -- cuanto falta para que el apunte entero tenga el mismo estilo.

Mide, modulo por modulo, las tres cosas que la fase de "la pasada por los 21
modulos" (PDP, fase 11) tiene que dejar en cero:

  1. secciones (`== ...`) que no nombran ningun libro   (regla propia 4 bis)
  2. modulos sin ningun `#posta`                         (regla propia 3)
  3. modulos sin ningun `#aparte`                        (regla propia 8)

Nacio el 2026-09-25 como un sondeo de una linea, cuando Fran pidio que todo
el apunte dijera de donde sale cada tema y tuviera el tono nuevo: medir antes
de la pasada es lo que permite saber cuando termina. No es un verificador de
bloqueo -- sale con 0 siempre --: es el tablero de avance de la fase. La fase
cierra cuando imprime PENDIENTE: 0.

    python medir-estilo.py
"""
import glob
import io
import os
import re
import sys

LIBROS = re.compile(r"S&Z|Sears|Beer|Curtis|Bate|Roederer")
AQUI = os.path.dirname(os.path.abspath(__file__))


def medir(ruta):
    s = io.open(ruta, encoding="utf-8").read()
    secciones = re.split(r"\n== ", s)[1:]
    sin_fuente = []
    for sec in secciones:
        titulo = sec.split("\n")[0].strip()
        if titulo.startswith("Lo que se usa"):
            continue
        if not LIBROS.search(sec):
            sin_fuente.append(titulo)
    return sin_fuente, s.count("#posta"), s.count("#aparte")


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    pendiente = 0
    for ruta in sorted(glob.glob(os.path.join(AQUI, "apunte", "modulos", "m*.typ"))):
        nombre = os.path.basename(ruta)[:-4]
        sin_fuente, postas, apartes = medir(ruta)
        faltas = len(sin_fuente) + (postas == 0) + (apartes == 0)
        pendiente += faltas
        marca = "ok " if faltas == 0 else "-- "
        print("%s%-26s secciones sin libro %d  posta %d  aparte %d"
              % (marca, nombre, len(sin_fuente), postas, apartes))
        for t in sin_fuente:
            print("       sin libro: %s" % t)
    print("\nPENDIENTE: %d" % pendiente)
    return 0


if __name__ == "__main__":
    sys.exit(main())
