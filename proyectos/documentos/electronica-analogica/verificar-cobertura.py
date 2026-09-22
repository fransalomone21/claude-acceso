#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verificar-cobertura.py -- mide si el apunte cubre la guia de TP de la catedra.

`verificar.py` mide que el apunte COMPILE Y SE VEA BIEN. Esto es otra cosa:
mide que DIGA LO QUE TENIA QUE DECIR. Un apunte impecable que no contesta el
punto 3 del TP N.º 6 pasa los cinco chequeos de verificar.py sin una sola
queja, y esa es exactamente la falla silenciosa de la naturaleza `documentos`.

Mide el mapeo de `fuentes/consignas-tp.md` en cuatro cosas:

  (a) CONSIGNA HUERFANA -- ninguna fila puede quedar con la celda "Donde se
      responde" vacia. Deny-by-default: una consigna no esta cubierta por
      estar el tema en el apunte, esta cubierta por estar declarada.
  (b) MODULO INEXISTENTE -- el `MN` de cada ancla tiene que resolver a un
      `apunte/modulos/mN-*.typ` que exista.
  (c) SECCION INEXISTENTE -- el `§Titulo` tiene que ser el titulo EXACTO de
      una seccion (`== ` o `=== `) de ese modulo.
  (d) CONTEO DECLARADO -- el texto declara "N consignas, N mapeadas, N
      diferida(s)": si lo escrito y lo contado no coinciden, rojo. Un numero
      a mano diverge.

POR QUE LA SECCION Y NO SOLO EL MODULO. Se puede escribir "M04" de memoria y
suena plausible. Exigir el titulo exacto es lo que obliga a haber abierto el
modulo, y es lo unico que un script puede medir. En el apunte de IISE, que
estreno esta idea, las 11 anclas escritas de memoria dieron 11 rojos.

LA EXCEPCION EXPLICITA. Una celda puede decir `PENDIENTE — <motivo>`: es una
consigna que el apunte no cubre A PROPOSITO. El script las cuenta y las nombra
aparte, y exige que tengan motivo escrito. Es la misma forma que
`.claude/datos-permitidos.json` del repo: lo legitimo se declara, no se calla.

LO QUE NO PUEDE MEDIR: que la seccion REALMENTE conteste la consigna. Eso se
lee. Atrapa el ancla rota, el modulo cruzado y la seccion renombrada.

Sale con codigo 1 si algo esta en rojo. Su saboteador es
`probar-verificar-cobertura.py`, que lo rompe a proposito y exige ver el rojo:
un verificador que nunca fallo esta sin verificar.

Uso:
    python verificar-cobertura.py               # sobre el arbol real
    python verificar-cobertura.py --raiz <dir>  # sobre una copia (saboteador)
"""

import argparse
import re
import sys
from pathlib import Path

# La consola de Windows es cp1252 y este archivo habla con acentos.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

AQUI = Path(__file__).resolve().parent

# Una fila del banco: | 12 | ...consigna... | ...anclas... |
FILA = re.compile(r"^\|\s*(\d+)\s*\|(.+?)\|(.+?)\|\s*$")
# Un ancla: M4 §Curva característica   (corta en ' · ' o en el fin de celda)
ANCLA = re.compile(r"\bM(\d{1,2})\s*§\s*([^·|]+)")
# La excepcion declarada, con su motivo obligatorio
PENDIENTE = re.compile(r"PENDIENTE\s*[—-]\s*(.+?)\s*$")
# La linea que declara el total, para el chequeo (d)
DECLARADO = re.compile(
    r"\*\*(\d+)\s+consignas,\s+(\d+)\s+mapeadas,\s+(\d+)\s+diferida")


def secciones_del_modulo(path):
    """Los titulos de seccion de un modulo Typst: `== X` y `=== X`."""
    titulos = set()
    for linea in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^={2,3}\s+(.+?)\s*$", linea)
        if m:
            titulos.add(m.group(1))
    return titulos


def modulos_por_clave(raiz):
    """{'4': Path(.../m4-diodos.typ), '15': Path(...), ...}"""
    mapa = {}
    for path in sorted((raiz / "apunte" / "modulos").glob("m*.typ")):
        m = re.match(r"^m(\d{1,2})-", path.name)
        if m:
            mapa[str(int(m.group(1)))] = path
    return mapa


def leer_consignas(banco):
    """[(numero, consigna, [(clave, seccion), ...], motivo_pendiente), ...]"""
    consignas = []
    for linea in banco.read_text(encoding="utf-8").splitlines():
        fila = FILA.match(linea)
        if not fila:
            continue
        num, consigna, celda = fila.groups()
        if not num.isdigit():
            continue
        # la fila de encabezado no matchea porque su primera celda no es un numero
        anclas = [(str(int(c)), s.strip()) for c, s in ANCLA.findall(celda)]
        pend = PENDIENTE.search(celda.strip())
        motivo = pend.group(1).strip() if pend else None
        consignas.append((num, consigna.strip(), anclas, motivo))
    return consignas


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raiz", default=str(AQUI),
                    help="raiz del proyecto (el saboteador pasa una copia)")
    args = ap.parse_args()
    raiz = Path(args.raiz).resolve()

    banco = raiz / "fuentes" / "consignas-tp.md"
    if not banco.exists():
        print("[FAIL] no existe %s" % banco)
        return 1

    modulos = modulos_por_clave(raiz)
    if not modulos:
        print("[FAIL] no hay modulos en %s" % (raiz / "apunte" / "modulos"))
        return 1

    consignas = leer_consignas(banco)
    if not consignas:
        print("[FAIL] el banco no tiene ninguna fila de consigna")
        return 1
    rojo = 0

    # (a) consignas huerfanas -- ni ancla ni excepcion declarada
    huerfanas = [(n, c) for n, c, a, m in consignas if not a and not m]
    diferidas = [(n, c, m) for n, c, a, m in consignas if not a and m]
    if huerfanas:
        rojo += len(huerfanas)
        print("[FAIL] (a) consigna huerfana -- sin seccion que la responda "
              "y sin excepcion declarada:")
        for n, c in huerfanas:
            print("       %s . %s" % (n, c[:70]))
    else:
        print("[OK  ] (a) las %d consignas tienen ancla o excepcion declarada"
              % len(consignas))

    # (b) y (c) las anclas resuelven
    rotas = []
    total_anclas = 0
    cache = {}
    for n, c, anclas, _ in consignas:
        for clave, seccion in anclas:
            total_anclas += 1
            path = modulos.get(clave)
            if path is None:
                rotas.append((n, clave, seccion, "no existe el modulo M%s" % clave))
                continue
            if clave not in cache:
                cache[clave] = secciones_del_modulo(path)
            if seccion not in cache[clave]:
                rotas.append((n, clave, seccion, "%s no tiene la seccion" % path.name))

    malos_modulo = [r for r in rotas if r[3].startswith("no existe")]
    malas_seccion = [r for r in rotas if not r[3].startswith("no existe")]

    if malos_modulo:
        rojo += len(malos_modulo)
        print("[FAIL] (b) ancla a un modulo que no existe:")
        for n, clave, seccion, por in malos_modulo:
            print("       %s  ->  M%s §%s  (%s)" % (n, clave, seccion, por))
    else:
        print("[OK  ] (b) los modulos de las %d anclas existen" % total_anclas)

    if malas_seccion:
        rojo += len(malas_seccion)
        print("[FAIL] (c) ancla a una seccion que no existe en ese modulo:")
        for n, clave, seccion, por in malas_seccion:
            print("       %s  ->  M%s §%s  (%s)" % (n, clave, seccion, por))
        print("       El titulo va EXACTO, como esta en el `== ` del .typ.")
    else:
        print("[OK  ] (c) las %d anclas resuelven a una seccion real" % total_anclas)

    # (d) el conteo declarado contra el contado
    texto = banco.read_text(encoding="utf-8")
    m = DECLARADO.search(texto)
    if not m:
        rojo += 1
        print("[FAIL] (d) el banco no declara su conteo "
              "('N consignas, N mapeadas, N diferida(s)')")
    else:
        dicho = (int(m.group(1)), int(m.group(2)), int(m.group(3)))
        medido = (len(consignas),
                  len(consignas) - len(huerfanas) - len(diferidas),
                  len(diferidas))
        if dicho != medido:
            rojo += 1
            print("[FAIL] (d) el conteo declarado no es el medido: "
                  "dice %d/%d/%d, hay %d/%d/%d" % (dicho + medido))
        else:
            print("[OK  ] (d) el conteo declarado (%d/%d/%d) es el medido" % dicho)

    if diferidas:
        print("")
        print("       %d consigna(s) diferida(s) a proposito, con su motivo:"
              % len(diferidas))
        for n, c, motivo in diferidas:
            print("       %s . %s" % (n, c[:60]))
            print("           -> %s" % motivo[:90])

    print("")
    if rojo:
        print("COBERTURA EN ROJO: %d problema(s)." % rojo)
        return 1
    print("COBERTURA EN VERDE: %d consignas, %d anclas, ninguna huerfana."
          % (len(consignas), total_anclas))
    return 0


if __name__ == "__main__":
    sys.exit(main())
