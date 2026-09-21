#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verificar-cobertura.py -- el medidor de la fase 3 del apunte de IISE.

La fase 3 es la VALIDACION del apunte (żsirve para rendir?), distinta de la
verificacion (żdice lo que tenia que decir y compila bien?). Su criterio de
salida: cada pregunta de los parcialitos 1, 2 y 3 mapeada a un modulo que la
responde, ninguna huerfana.

Este script mide ese mapeo sobre `fuentes/parcialitos.md`, en cuatro cosas:

  (a) PREGUNTA HUERFANA -- ninguna fila de una tabla de parcialito puede
      quedar sin al menos un ancla en la columna "Donde se responde".
  (b) MODULO INEXISTENTE -- el `MNN` de cada ancla tiene que resolver a un
      archivo `apunte/modulos/mNN-*.typ` que exista.
  (c) SECCION INEXISTENTE -- el `§Titulo` tiene que ser el titulo EXACTO de
      una seccion (`== ` o `=== `) de ese modulo.
  (d) CONTEO DECLARADO -- el texto declara "16 preguntas": si el numero
      escrito y el contado no coinciden, rojo. Un numero a mano diverge.

POR QUE LA SECCION Y NO SOLO EL MODULO. El mapeo anterior era a nivel modulo
y estaba MAL EN 9 DE LAS 16 PREGUNTAS sin que nada avisara: se puede escribir
"M04" de memoria y suena plausible. Exigir el titulo exacto de la seccion es
lo que obliga a haber abierto el modulo, y es lo unico que un script puede
medir. El (c) es el chequeo que hace que los otros tres valgan algo.

LO QUE ESTE MEDIDOR NO PUEDE MEDIR, y por eso se dice aca: que la seccion
REALMENTE conteste la pregunta. Eso se lee. El script atrapa el ancla rota,
el modulo cruzado y la numeracion corrida -- que es la clase de error que ya
se cometio -- pero un ancla que resuelve a una seccion irrelevante le pasa
por al lado.

Sale con codigo 1 si algo esta en rojo. Su saboteador es
`probar-verificar-cobertura.py`, que lo rompe a proposito y exige ver el
rojo: un verificador que nunca fallo esta sin verificar.

Uso:
    python verificar-cobertura.py               # sobre el arbol real
    python verificar-cobertura.py --raiz <dir>  # sobre una copia (saboteador)
"""

import argparse
import re
import sys
from pathlib import Path

# La consola de Windows es cp1252 y este archivo habla con acentos. Ya
# pagado en verificar-lexico.py.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

AQUI = Path(__file__).resolve().parent

# Una fila de tabla de parcialito: | 3 | ...pregunta... | ...anclas... |
FILA = re.compile(r"^\|\s*(\d+)\s*\|(.+?)\|(.+?)\|\s*$")
# Un ancla: M07 §La tabla N²   (corta en el separador ' · ' o el fin de celda)
ANCLA = re.compile(r"\bM(\d{2})\s*§\s*([^·|]+)")
# El encabezado de cada parcialito en el .md
PARCIALITO = re.compile(r"^##\s+Parcialito\s+(\d+)")
# La linea que declara el total, para el chequeo (d)
DECLARADO = re.compile(r"\*\*(\d+)\s+preguntas,\s+(\d+)\s+mapeadas")


def secciones_del_modulo(path):
    """Los titulos de seccion de un modulo Typst: `== X` y `=== X`."""
    titulos = set()
    for linea in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^={2,3}\s+(.+?)\s*$", linea)
        if m:
            titulos.add(m.group(1))
    return titulos


def modulos_por_clave(raiz):
    """{'07': Path(.../m07-relaciones-n2-emergentes.typ), ...}"""
    mapa = {}
    for path in sorted((raiz / "apunte" / "modulos").glob("m*.typ")):
        m = re.match(r"^m(\d{2})-", path.name)
        if m:
            mapa[m.group(1)] = path
    return mapa


def leer_preguntas(banco):
    """[(parcialito, numero, pregunta, [(clave, seccion), ...]), ...]"""
    preguntas = []
    actual = None
    for linea in banco.read_text(encoding="utf-8").splitlines():
        cab = PARCIALITO.match(linea)
        if cab:
            actual = cab.group(1)
            continue
        if actual is None:
            continue
        fila = FILA.match(linea)
        if not fila:
            continue
        num, pregunta, celda = fila.groups()
        anclas = [(c, s.strip()) for c, s in ANCLA.findall(celda)]
        preguntas.append((actual, num, pregunta.strip(), anclas))
    return preguntas


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raiz", default=str(AQUI),
                    help="raiz del proyecto (el saboteador pasa una copia)")
    args = ap.parse_args()
    raiz = Path(args.raiz).resolve()

    banco = raiz / "fuentes" / "parcialitos.md"
    if not banco.exists():
        print("[FAIL] no existe %s" % banco)
        return 1

    modulos = modulos_por_clave(raiz)
    if not modulos:
        print("[FAIL] no hay modulos en %s" % (raiz / "apunte" / "modulos"))
        return 1

    preguntas = leer_preguntas(banco)
    rojo = 0

    # (a) preguntas huerfanas
    huerfanas = [(p, n, q) for p, n, q, a in preguntas if not a]
    if huerfanas:
        rojo += len(huerfanas)
        print("[FAIL] (a) pregunta huerfana -- sin ningun modulo que la responda:")
        for p, n, q in huerfanas:
            print("       P%s . %s  %s" % (p, n, q[:70]))
    else:
        print("[OK  ] (a) las %d preguntas tienen al menos un ancla" % len(preguntas))

    # (b) y (c) las anclas resuelven
    rotas = []
    total_anclas = 0
    cache = {}
    for p, n, q, anclas in preguntas:
        for clave, seccion in anclas:
            total_anclas += 1
            path = modulos.get(clave)
            if path is None:
                rotas.append((p, n, clave, seccion, "no existe el modulo M%s" % clave))
                continue
            if clave not in cache:
                cache[clave] = secciones_del_modulo(path)
            if seccion not in cache[clave]:
                rotas.append((p, n, clave, seccion,
                              "%s no tiene la seccion" % path.name))

    malos_modulo = [r for r in rotas if r[4].startswith("no existe")]
    malas_seccion = [r for r in rotas if not r[4].startswith("no existe")]

    if malos_modulo:
        rojo += len(malos_modulo)
        print("[FAIL] (b) ancla a un modulo que no existe:")
        for p, n, clave, seccion, por in malos_modulo:
            print("       P%s . %s  ->  M%s §%s  (%s)" % (p, n, clave, seccion, por))
    else:
        print("[OK  ] (b) los modulos de las %d anclas existen" % total_anclas)

    if malas_seccion:
        rojo += len(malas_seccion)
        print("[FAIL] (c) ancla a una seccion que no existe en ese modulo:")
        for p, n, clave, seccion, por in malas_seccion:
            print("       P%s . %s  ->  M%s §%s  (%s)" % (p, n, clave, seccion, por))
        print("       El titulo va EXACTO, como esta en el `== ` del .typ.")
    else:
        print("[OK  ] (c) las %d anclas resuelven a una seccion real" % total_anclas)

    # (d) el conteo declarado contra el contado
    texto = banco.read_text(encoding="utf-8")
    m = DECLARADO.search(texto)
    if not m:
        rojo += 1
        print("[FAIL] (d) el banco no declara su conteo ('N preguntas, N mapeadas')")
    else:
        dicho_total, dicho_map = int(m.group(1)), int(m.group(2))
        mapeadas = len(preguntas) - len(huerfanas)
        if dicho_total != len(preguntas) or dicho_map != mapeadas:
            rojo += 1
            print("[FAIL] (d) el conteo declarado no es el medido: dice %d/%d, "
                  "hay %d/%d" % (dicho_total, dicho_map, len(preguntas), mapeadas))
        else:
            print("[OK  ] (d) el conteo declarado (%d/%d) es el medido"
                  % (dicho_total, dicho_map))

    print("")
    if rojo:
        print("COBERTURA EN ROJO: %d problema(s). La fase 3 no cierra asi." % rojo)
        return 1
    print("COBERTURA EN VERDE: %d preguntas, %d anclas, ninguna huerfana."
          % (len(preguntas), total_anclas))
    return 0


if __name__ == "__main__":
    sys.exit(main())
