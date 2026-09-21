#!/usr/bin/env python
"""Extrae el material de las 7 clases de IISE desde los PDF de la catedra.

Por que existe: las 7 clases son 590 diapositivas y ~360k caracteres. Leerlas
desde el PDF en cada sesion es la operacion mas cara del proyecto; hacerla UNA
vez y dejar el .txt en el repo es el mismo movimiento que ya se pago en
fisica-espacial con GUIA-ENUNCIADOS.md.

Que produce:
  fuentes/clases/clase-N.txt   una entrada [pNN] por diapositiva, con el titulo
                               (el span de fuente mas grande) y el texto
  fuentes/clases/titulos.md    el indice de las 590 diapositivas por titulo
  fuentes/figuras/cNN-pMMM.png las diapositivas que son puro diagrama

Los PDF NO se commitean (viven en Drive); el .txt SI. Ver .gitignore.

ASCII en los mensajes a proposito: la consola de Windows lee cp1252.
"""
import argparse
import pathlib
import re
import sys

import pymupdf

AQUI = pathlib.Path(__file__).resolve().parent
PDFS = AQUI / "fuentes" / "pdf"
SALIDA = AQUI / "fuentes" / "clases"
FIGURAS = AQUI / "fuentes" / "figuras"

# Una diapositiva con menos de este texto es, casi siempre, una figura: el
# contenido esta en el diagrama y el .txt solo no alcanza para escribir sobre
# ella. Medido sobre las 7 clases: 177 de 590 caen abajo de 150.
UMBRAL_FIGURA = 150


def numero_de_clase(nombre):
    """El numero de clase que trae el nombre del archivo."""
    m = re.search(r"clase\s*(\d+)", nombre, re.IGNORECASE)
    if not m:
        raise ValueError("no se puede sacar el numero de clase de " + repr(nombre))
    return int(m.group(1))


def titulo_de_pagina(pagina):
    """El span de fuente mas grande de la pagina: el titulo de la diapositiva."""
    mejor, tam = "", 0.0
    for bloque in pagina.get_text("dict")["blocks"]:
        for linea in bloque.get("lines", []):
            for span in linea["spans"]:
                texto = span["text"].strip()
                if texto and len(texto) > 3 and span["size"] > tam:
                    tam, mejor = span["size"], texto
    return mejor


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--figuras", action="store_true",
                    help="ademas exporta a PNG las diapositivas que son puro diagrama")
    ap.add_argument("--pagina", action="append", default=[], metavar="cN:pM",
                    help="renderiza UNA diapositiva puntual a fuentes/figuras/, "
                         "aunque tenga texto y el umbral la deje afuera. Se puede "
                         "repetir: --pagina 4:105 --pagina 5:62")
    args = ap.parse_args()

    # El umbral de UMBRAL_FIGURA descubre las diapositivas que son PURO
    # diagrama, y esa es su virtud: no hay que saber cuales son. Pero deja
    # afuera justo las mas didacticas -- las que tienen un diagrama Y sus
    # rotulos--, que superan el umbral por el texto de los rotulos. Esas se
    # piden por numero, y por eso este camino es aparte y no un umbral mas
    # laxo: uno se descubre solo, el otro se elige mirando.
    if args.pagina:
        FIGURAS.mkdir(parents=True, exist_ok=True)
        pedidas = {}
        for spec in args.pagina:
            c, p = spec.split(":")
            pedidas.setdefault(int(c), []).append(int(p))
        for pdf in sorted(PDFS.glob("*.pdf"), key=lambda p: numero_de_clase(p.name)):
            n = numero_de_clase(pdf.name)
            if n not in pedidas:
                continue
            doc = pymupdf.open(pdf)
            for p in pedidas[n]:
                if p < 1 or p > doc.page_count:
                    print("  [ROJO] clase %d no tiene diapositiva %d (son %d)"
                          % (n, p, doc.page_count))
                    continue
                png = FIGURAS / ("c%02d-p%03d.png" % (n, p))
                doc[p - 1].get_pixmap(dpi=110).save(png)
                print("  [OK]   clase %d, diapositiva %d -> %s" % (n, p, png.name))
        return 0

    pdfs = sorted(PDFS.glob("*.pdf"), key=lambda p: numero_de_clase(p.name))
    if not pdfs:
        print("[ROJO] no hay PDF en " + str(PDFS))
        print("       bajalos con:  .\\bajar-clases.ps1")
        return 1

    SALIDA.mkdir(parents=True, exist_ok=True)
    if args.figuras:
        FIGURAS.mkdir(parents=True, exist_ok=True)

    indice = ["# Las diapositivas de IISE, por titulo",
              "",
              "Lo genera `extraer-clases.py`: no se edita a mano.",
              "Sirve para ubicar UNA diapositiva sin abrir el .txt entero.",
              ""]
    tot_pag = 0
    tot_fig = 0

    for pdf in pdfs:
        n = numero_de_clase(pdf.name)
        doc = pymupdf.open(pdf)
        lineas = ["# IISE clase " + str(n) + " -- " + str(doc.page_count) + " diapositivas",
                  "# fuente: " + pdf.name,
                  "# Lo genera extraer-clases.py. El numero [pNN] es la pagina REAL del PDF.",
                  ""]
        indice.append("## Clase " + str(n) + " (" + str(doc.page_count) + " diapositivas)")
        indice.append("")

        for i, pagina in enumerate(doc, start=1):
            texto = pagina.get_text().strip()
            titulo = titulo_de_pagina(pagina)
            marca = "  [FIGURA]" if len(texto) < UMBRAL_FIGURA else ""
            lineas.append("[p" + str(i) + "] " + titulo + marca)
            lineas.append(texto if texto else "(sin texto)")
            lineas.append("")
            indice.append("- [p" + str(i) + "] " + titulo + marca)

            if args.figuras and len(texto) < UMBRAL_FIGURA:
                png = FIGURAS / ("c%02d-p%03d.png" % (n, i))
                pagina.get_pixmap(dpi=110).save(png)
                tot_fig += 1

        indice.append("")
        destino = SALIDA / ("clase-" + str(n) + ".txt")
        destino.write_text("\n".join(lineas), encoding="utf-8")
        tot_pag += doc.page_count
        print("  [OK]   clase %d: %3d diapositivas -> %s" % (n, doc.page_count, destino.name))

    (SALIDA / "titulos.md").write_text("\n".join(indice), encoding="utf-8")
    print("  [OK]   titulos.md: " + str(tot_pag) + " diapositivas indexadas")
    if args.figuras:
        print("  [OK]   " + str(tot_fig) + " diapositivas-figura exportadas a fuentes/figuras/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
