#!/usr/bin/env python
"""Mide si los numeros de diapositiva que trae NotebookLM apuntan a la pagina real.

POR QUE EXISTE. El 2026-09-20 NotebookLM devolvio el inventario de figuras con
una marca [pN] por entrada. Un sondeo a mano sobre la clase 1 mostro que ese N
NO es la pagina del PDF: 'Criterios de Aprobacion' salia como [p2] y esta en la
p4; la portada del NASA SEH salia como [p14] y esta cerca de la p34. El
corrimiento tampoco es constante (+2, +7, +14, +20), asi que no se arregla con
un offset. Citar esos numeros en el apunte seria mandar al lector a la
diapositiva equivocada, y nada lo avisaria: es la falla silenciosa de la
naturaleza 'documentos'.

QUE HACE. Para cada entrada [pN] del inventario busca su texto distintivo en el
PDF real y reporta en que pagina esta de verdad. Escribe el inventario
reanclado, y marca [SIN ANCLA] lo que no se puede ubicar por texto (las fotos
sin rotulo, que son las que menos texto tienen y mas dependen de la figura).

Entrada : fuentes/externo/notebooklm-figuras.md
Salida  : fuentes/externo/notebooklm-figuras-reanclado.md

ASCII en los mensajes a proposito: la consola de Windows lee cp1252.
"""
import pathlib
import re
import sys

import pymupdf

AQUI = pathlib.Path(__file__).resolve().parent
PDFS = AQUI / "fuentes" / "pdf"
ENTRADA = AQUI / "fuentes" / "externo" / "notebooklm-figuras.md"
SALIDA = AQUI / "fuentes" / "externo" / "notebooklm-figuras-reanclado.md"

# Palabras demasiado comunes para anclar nada.
RUIDO = set("""de la el los las un una y o en con por para del al que se es son
como su sus este esta estos estas sobre entre desde hasta muestra imagen
fotografia diagrama esquema tabla grafico foto tipo dice concepto vista parte
izquierda derecha superior inferior base texto titulo""".split())


def numero_de_clase(nombre):
    m = re.search(r"clase\s*(\d+)", nombre, re.IGNORECASE)
    return int(m.group(1)) if m else None


def cargar_paginas():
    """{numero de clase: [texto normalizado de cada pagina]}"""
    paginas = {}
    for pdf in PDFS.glob("*.pdf"):
        n = numero_de_clase(pdf.name)
        doc = pymupdf.open(pdf)
        paginas[n] = [p.get_text().lower() for p in doc]
    return paginas


def anclas(dice):
    """Los tokens distintivos de una descripcion: los que sirven para buscar."""
    crudos = re.findall(r"[A-Za-zÀ-ÿ0-9][\w\-\.]{3,}", dice)
    vistos, salida = set(), []
    for t in crudos:
        b = t.lower().strip(".")
        if b in RUIDO or b in vistos or len(b) < 4:
            continue
        vistos.add(b)
        salida.append(b)
    return salida


def ubicar(tokens, textos):
    """La pagina que mas tokens contiene, y cuantos. (None, 0) si no hay nada."""
    if not tokens:
        return None, 0
    mejor, puntos = None, 0
    for i, texto in enumerate(textos, start=1):
        p = sum(1 for t in tokens if t in texto)
        if p > puntos:
            mejor, puntos = i, p
    return mejor, puntos


def main():
    if not ENTRADA.exists():
        print("[ROJO] falta " + str(ENTRADA))
        return 1

    paginas = cargar_paginas()
    lineas = ENTRADA.read_text(encoding="utf-8").split("\n")

    salida = []
    clase = None
    coinciden = movidas = sin_ancla = total = 0
    entrada_actual = None

    for linea in lineas:
        m_clase = re.search(r"Clase\s*(\d+)\s*:", linea)
        if m_clase:
            clase = int(m_clase.group(1))
            salida.append(linea)
            continue

        m_entrada = re.match(r"\s*\[p(\d+)\]\s*TIPO:\s*(.*)", linea)
        if m_entrada and clase in paginas:
            entrada_actual = {"n": int(m_entrada.group(1)), "tipo": m_entrada.group(2),
                              "clase": clase, "linea": linea}
            salida.append(None)          # se completa cuando llegue el DICE
            continue

        m_dice = re.match(r"\s*DICE:\s*(.*)", linea)
        if m_dice and entrada_actual:
            total += 1
            real, puntos = ubicar(anclas(m_dice.group(1)), paginas[entrada_actual["clase"]])
            declarada = entrada_actual["n"]
            # El grado de evidencia se anota y no se sube (regla 1 del perfil).
            # Anclar POR TEXTO una diapositiva que es PURA FIGURA es circular:
            # justo las que menos texto tienen son las que peor se ubican. Se
            # comprobo el 2026-09-20 con el diagrama de criterios de aprobacion
            # de la clase 1, que cayo en p8 cuando esta en p4: el detalle esta
            # dentro de la imagen y el matcheo se fue a otra pagina que hablaba
            # de parciales. Por eso ninguna marca dice 'confirmado'.
            if puntos < 2:
                marca = "[SIN ANCLA -- no se puede ubicar por texto]"
                sin_ancla += 1
                real = declarada
            elif real == declarada:
                marca = "[ancla PROBABLE, y coincide con NotebookLM]"
                coinciden += 1
            else:
                marca = "[ancla PROBABLE; NotebookLM decia p%d]" % declarada
                movidas += 1
            hueco = salida.index(None)
            salida[hueco] = "[p%d] TIPO: %s  %s" % (real, entrada_actual["tipo"], marca)
            entrada_actual = None

        salida.append(linea)

    SALIDA.write_text("\n".join(x for x in salida if x is not None), encoding="utf-8")

    print("  entradas del inventario : %d" % total)
    print("  el numero ya era correcto: %d" % coinciden)
    print("  reancladas a otra pagina : %d" % movidas)
    print("  sin ancla de texto       : %d" % sin_ancla)
    print("  -> " + str(SALIDA.name))
    print("")
    print("  NINGUNA de estas anclas es 'confirmado': todas son PROBABLES.")
    print("  Anclar por texto lo que es pura figura es circular. El ancla se")
    print("  confirma mirando el PNG en fuentes/figuras/ al escribir el modulo,")
    print("  y recien ahi el numero entra al apunte.")
    if total and coinciden * 2 < total:
        print("")
        print("  [ATENCION] solo %d de %d numeros de NotebookLM coincidieron." % (coinciden, total))
        print("             Sus [pN] no se citan nunca tal cual.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
