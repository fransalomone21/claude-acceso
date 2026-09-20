#!/usr/bin/env python
"""Trae de las clases el contexto de un termino, con su diapositiva.

Por que existe: escribir el glosario necesita la definicion TEXTUAL de la
catedra, no la de un tercero, y las 7 clases juntas son ~90k tokens. Esto trae
solo los pedazos donde el termino aparece, con el numero de diapositiva REAL,
que es lo que despues se cita.

  python buscar-definicion.py "triangulo de hierro"
  python buscar-definicion.py emergente --clases 2 --ancho 500

Los acentos no importan: la busqueda los normaliza en los dos lados.
ASCII en los mensajes a proposito: la consola de Windows lee cp1252.
"""
import argparse
import pathlib
import re
import sys
import unicodedata

AQUI = pathlib.Path(__file__).resolve().parent
CLASES = AQUI / "fuentes" / "clases"

# La consola de Windows es cp1252 y las diapositivas traen vinetas (U+25CF),
# comillas tipograficas y flechas. Sin esto el script MUERE a mitad de la
# busqueda, con el agravante de que ya imprimio media salida: parece que
# termino y falta lo de abajo.
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except (AttributeError, ValueError):
    pass


def plano(s):
    """Minusculas y sin acentos, para que la busqueda no dependa de como se tipeo."""
    sin = unicodedata.normalize("NFD", s)
    return "".join(c for c in sin if unicodedata.category(c) != "Mn").lower()


def diapositiva_de(texto, pos):
    """El numero de diapositiva en que cae una posicion del archivo."""
    marcas = list(re.finditer(r"^\[p(\d+)\]", texto[:pos], re.MULTILINE))
    return int(marcas[-1].group(1)) if marcas else 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("termino")
    ap.add_argument("--clases", default="1,2,3,4,5,6,7",
                    help="cuales mirar, separadas por coma (default: todas)")
    ap.add_argument("--ancho", type=int, default=320,
                    help="caracteres de contexto alrededor de cada aparicion")
    args = ap.parse_args()

    aguja = plano(args.termino)
    total = 0

    for n in [int(x) for x in args.clases.split(",")]:
        archivo = CLASES / ("clase-%d.txt" % n)
        if not archivo.exists():
            continue
        texto = archivo.read_text(encoding="utf-8")
        pajar = plano(texto)

        posiciones = [m.start() for m in re.finditer(re.escape(aguja), pajar)]
        if not posiciones:
            continue

        print("=" * 60)
        print("CLASE %d -- %d aparicion(es)" % (n, len(posiciones)))
        vistas = set()
        for pos in posiciones:
            dia = diapositiva_de(texto, pos)
            if dia in vistas:      # una por diapositiva alcanza
                continue
            vistas.add(dia)
            total += 1
            ini = max(0, pos - args.ancho // 3)
            fin = min(len(texto), pos + args.ancho)
            print("")
            print("  [clase %d, diapositiva %d]" % (n, dia))
            print("  " + " ".join(texto[ini:fin].split()))

    print("")
    if total:
        print("%d diapositiva(s) con el termino. La cita va 'clase N, diapositiva M'." % total)
    else:
        print("Ninguna aparicion. Probar con una palabra mas corta o con otra raiz.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
