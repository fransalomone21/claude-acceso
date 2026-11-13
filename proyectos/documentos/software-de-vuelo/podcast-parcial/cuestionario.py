"""Arma el cuestionario multiple choice desde guion.md: cada pregunta con sus opciones, la respuesta y su porque.

Uso: python cuestionario.py   ->  cuestionario.typ, y compila cuestionario.pdf (typst)
La pregunta es el renglon con 'A, ... B, ... C, ... D, ...'; la respuesta, el primer renglon despues de su [PAUSA].
"""
import re
import subprocess
from pathlib import Path

AQUI = Path(__file__).parent
TEMAS = {2: "Confiabilidad y radiación", 3: "La OBC en la práctica", 4: "Arquitectura ARM",
         5: "C embebido y MISRA", 6: "CubeIDE, Wokwi y TP2", 7: "Periféricos e interfaces",
         8: "Funciones y punteros", 9: "RTOS y FreeRTOS", 10: "TP4 y TP5", 11: "Ronda rápida"}
OPC = re.compile(r"\bA,\s(.+?)\.\s+B,\s(.+?)\.\s+C,\s(.+?)\.\s+D,\s(.+?)\.?$")


def esc(t):
    return re.sub(r"([#*_`$<>@\\\[\]])", r"\\\1", t)


def preguntas():
    texto = (AQUI / "guion.md").read_text(encoding="utf-8").split("## Guion", 1)[1]
    out = []
    for k, bloque in enumerate(re.split(r"\n\s*\n", texto.strip()), 1):
        lineas = [re.sub(r"^(CARO|MARTIN):\s*", "", l.strip()) for l in bloque.splitlines() if l.strip()]
        for i, l in enumerate(lineas):
            m = OPC.search(l)
            if not m or i + 2 >= len(lineas) or not lineas[i + 1].startswith("[PAUSA"):
                continue
            enunciado = l[:m.start()].strip()
            enunciado = re.sub(r"^(Pregunta( express)?\.|Primera pregunta\.|Pregunta del bloque\.)\s*", "", enunciado)
            enunciado = re.sub(r"^(Uno|Dos|Tres|Cuatro|Cinco|Seis|Siete|Ocho|Nueve|Diez|Once|Doce|Trece|Y catorce, la última)\.\s*", "", enunciado)
            resp = lineas[i + 2]
            letra = re.search(r"\b(?:La\s)?([ABCD])\b", resp)
            out.append((k, enunciado, list(m.groups()), letra.group(1) if letra else "?", resp))
    return out


def main():
    qs = preguntas()
    partes = ['#set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm), numbering: "1")',
              '#set text(font: "Libertinus Serif", size: 10.5pt, lang: "es")',
              '#set par(justify: true)',
              '#let azul = rgb("#1f4e79")',
              '#align(center)[#text(17pt, weight: "bold", fill: azul)[Cuestionario multiple choice — Software de Vuelo (Leandro)] \\',
              f'  #text(10pt)[{len(qs)} preguntas por tema, con respuesta y porqué · 13/11/2026 · las mismas del podcast]]',
              '#v(4pt)', 'Tapá la caja gris y contestá. La justificación dice por qué las otras opciones son trampa.', '']
    tema_actual, n = None, 0
    for k, enun, ops, letra, resp in qs:
        if k != tema_actual:
            tema_actual = k
            partes.append(f'\n#v(6pt)\n#text(13pt, weight: "bold", fill: azul)[{esc(TEMAS.get(k, "Otros"))}]\n')
        n += 1
        items = " \\\n".join(f"*{l})* {esc(o)}" for l, o in zip("ABCD", ops))
        partes.append(
            f'#block(breakable: false, below: 8pt)[*{n}.* {esc(enun)} \\\n{items}\n'
            f'#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: {letra}.* {esc(resp)}]]')
    (AQUI / "cuestionario.typ").write_text("\n".join(partes), encoding="utf-8")
    subprocess.run(["typst", "compile", str(AQUI / "cuestionario.typ"), str(AQUI / "cuestionario.pdf")], check=True)
    print(f"{n} preguntas -> cuestionario.pdf")


if __name__ == "__main__":
    main()
