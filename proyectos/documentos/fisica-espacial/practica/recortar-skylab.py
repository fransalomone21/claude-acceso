"""Recorta del paper del Skylab (Chubb y Seltzer 1971, NASA TN D-6068, de la
cátedra) las capturas que usa la sección del Skylab de resumen-cmg.typ.

Salen a practica/recortes/ (ignorado por git: es material de la cátedra).
Los recortes de texto se ubican buscando su texto en la capa OCR del PDF;
las figuras, con coordenadas en puntos medidas sobre la página.

    python practica/recortar-skylab.py ["ruta al CMG Skylab.pdf"]
"""
import pathlib
import sys

import pymupdf

PDF = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else
                   r"C:\Users\frans\Desktop\01 - UNSAM\Fisica Espacial\Material catedra\2026-11-10 CMG\CMG Skylab.pdf")
OUT = pathlib.Path(__file__).parent / "recortes"


def por_texto(doc, pag, desde, hasta, nombre, ancho=245, izq=22):
    p = doc[pag]
    a = p.search_for(desde)
    b = p.search_for(hasta)
    if not a or not b:
        sys.exit(f"ROJO: no encuentro {desde!r} / {hasta!r} en la pág. {pag + 1}")
    x0 = a[0].x0 - izq
    clip = pymupdf.Rect(x0, a[0].y0 - 1, x0 + ancho, b[0].y1 + 1)
    p.get_pixmap(dpi=200, clip=clip).save(OUT / f"skylab-{nombre}.png")


def por_rect(doc, pag, rect, nombre):
    doc[pag].get_pixmap(dpi=200, clip=pymupdf.Rect(*rect)).save(OUT / f"skylab-{nombre}.png")


def main():
    if not PDF.exists():
        sys.exit(f"ROJO: falta el paper en {PDF}")
    OUT.mkdir(exist_ok=True)
    d = pymupdf.open(PDF)
    # pág. 3 del paper = índice 8 del PDF
    por_texto(d, 8, "The CMG control system of the rack", "thruster exhaust", "por-que", ancho=262, izq=4)
    por_texto(d, 8, "TABLE II", "CMG Z", "tabla2")
    # pág. 4: la Tabla III y la Figura 2
    por_rect(d, 9, (300, 135, 556, 275), "tabla3")
    por_rect(d, 9, (78, 373, 505, 668), "fig2")
    # pág. 5: figuras 3 y 4 (antiparalelo y ley de distribución)
    por_rect(d, 10, (286, 66, 570, 472), "fig3-4")
    # pág. 6: figura 5 y la desaturación con el gradiente de noche
    por_rect(d, 11, (46, 30, 288, 524), "fig5")
    por_texto(d, 11, "(2) The saturation effects", "lation during the daylight", "desat", ancho=268, izq=30)
    print("ok:", sorted(f.name for f in OUT.glob("skylab-*.png")))


main()
