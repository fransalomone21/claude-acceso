"""verificar-hoja.py -- renglones de la hoja de formulas que se salen de su columna.

Typst NO parte una ecuacion en bloque: si no entra en la columna, se pisa con
la de al lado y compila en verde. Esto lo mide sobre el PDF.

Mide por RENGLON (bbox de la linea entera de PyMuPDF), no por trozo de texto:
un trozo que ya empieza del otro lado del borde no "cruza" nada, y la primera
version de este chequeo, que miraba trozos, dio verde con un renglon que se
pasaba 45 pt (2026-10-01). La columna de cada renglon es la de su borde
izquierdo. Tolerancia 1,5 pt.

Los margenes y el gutter tienen que coincidir con los de hoja-formulas.typ.

    python verificar-hoja.py salida/hoja-formulas-parcial.pdf:1 salida/hoja-formulas.pdf:2

El ':N' opcional exige exactamente N paginas: la compaginacion es a mano
(cada tema entero en su columna), y si un tema crece y no entra, Typst lo
manda a otra columna y la hoja del parcial pasa a tener dos carillas sin
dar ningun error.

Sale con 1 si hay algun renglon afuera, si una hoja no tiene las paginas
pedidas, o si un PDF no tiene renglones (control: un PDF vacio daria verde
por no medir nada).
"""
import sys

import pymupdf

CM = 28.3465
MARGEN_X = 0.8 * CM   # hoja-formulas.typ: margin x 0.8cm
GUTTER = 11.0         # hoja-formulas.typ: columns gutter 11pt
COLUMNAS = 3


def desbordes(pdf):
    d = pymupdf.open(pdf)
    afuera, renglones = [], 0
    for pn, p in enumerate(d):
        colw = (p.rect.width - 2 * MARGEN_X - (COLUMNAS - 1) * GUTTER) / COLUMNAS
        inicios = [MARGEN_X + k * (colw + GUTTER) for k in range(COLUMNAS)]
        for b in p.get_text("dict")["blocks"]:
            for l in b.get("lines", []):
                renglones += 1
                x0, y0, x1, _ = l["bbox"]
                k = max(i for i in range(COLUMNAS) if x0 >= inicios[i] - 3 or i == 0)
                borde = inicios[k] + colw
                if x1 > borde + 1.5:
                    texto = "".join(s["text"] for s in l["spans"])[:30]
                    afuera.append((pn + 1, k + 1, round(y0), round(x1 - borde, 1), texto))
    return len(d), renglones, afuera


def main():
    rojo = False
    for arg in sys.argv[1:]:
        f, pedidas = arg, None
        base, _, sufijo = arg.rpartition(":")
        if base and sufijo.isdigit():          # 'C:\...' no se confunde: 'C' no es un numero
            f, pedidas = base, int(sufijo)
        n, renglones, afuera = desbordes(f)
        print("%s: %d pag, %d renglones, %d fuera de su columna" % (f, n, renglones, len(afuera)))
        for o in afuera:
            print("   pag %d col %d y=%d  +%.1f pt  %s" % o)
        if pedidas is not None and n != pedidas:
            print("   [ROJO] tiene %d pagina(s) y tiene que tener %d" % (n, pedidas))
            rojo = True
        if afuera or renglones == 0:
            rojo = True
    sys.exit(1 if rojo else 0)


if __name__ == "__main__":
    main()
