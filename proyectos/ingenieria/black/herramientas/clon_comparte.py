#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""clon_comparte.py -- (124) que punteros COMPARTE J2 con J. J2 es una copia por bytes del objeto de J (el molde,
0x8C0 B en 0x0046CDF0): todo puntero que el mod no reubica apunta a LO MISMO que el de J, y eso es estado compartido.

    python herramientas/clon_comparte.py              # la lista, sobre los volcados del mod en volcados/
    python herramientas/clon_comparte.py --autotest   # los controles (sale 1 si alguno falla)

POR QUE EXISTE: F7 (el arma de J2 en la mitad de J) se persiguio de (96) a (123) por el puerto, el sub y el asignador
de aparejos, y la causa era un puntero heredado del molde (`+0x328`, el soporte de modelo; confirmado en (124)). Un
efecto que «comparten» J y J2 se empieza por ESTA lista, no por un subsistema.

Un campo entra si en TODOS los volcados con el mod: vale lo mismo en J y en J2, parece un puntero a la RAM del EE
(0x00100000-0x02000000) y no apunta adentro de J ni de J2 (esos son autopunteros que el mod reubica).
Controles (--autotest): `+0x328` (el soporte, compartido, medido en (124)) TIENE que salir; `+0x2A4` (el arma en la
mano, distinta, medida en (124)) NO. Y un control de poblacion: comparado contra un bloque de memoria que NO es copia
de J (el que sigue a J), la lista tiene que salir mas chica (si no, mide el vecindario y no la copia).
"""
import argparse
import glob
import os
import struct
import sys
from pathlib import Path

H = Path(__file__).resolve().parent
VOLCADOS = H.parent / "volcados"
CLASE = 0x003DC5F8          # J+0x10
J2 = 0x0046CDF0
TAM = 0x8C0
PERS_GLOBAL = 0x0040F50C
POS_COMPARTIDO, NEG_DISTINTO = 0x328, 0x2A4


def u32(m, a):
    return struct.unpack_from("<I", m, a)[0]


def jugadores(m):
    """(J, J2) del volcado, o None: J es el dueno de la ranura 0/1 de pers que no es J2 y tiene la clase."""
    if u32(m, J2 + 0x10) != CLASE:
        return None
    pers = u32(m, PERS_GLOBAL)
    if not (0 < pers < len(m)):
        return None
    for k in range(2):
        d = u32(m, pers + 0x470 + k * 0x240)
        if d and d != J2 and d < len(m) - TAM and u32(m, d + 0x10) == CLASE:
            return d, J2
    return None


def compartidos(m, J, otro):
    res = {}
    for off in range(0, TAM, 4):
        a, b = u32(m, J + off), u32(m, otro + off)
        if a != b or not (0x00100000 <= a < 0x02000000):
            continue
        if J <= a < J + TAM or otro <= a < otro + TAM:
            continue
        res[off] = a
    return res


def volcados():
    for r in sorted(glob.glob(str(VOLCADOS / "*.bin"))):
        if os.path.getsize(r) == 32 * 1024 * 1024:
            m = open(r, "rb").read()
            jj = jugadores(m)
            if jj:
                yield os.path.basename(r), m, jj


def lista():
    comunes, n, nombres = None, 0, []
    for nom, m, (J, J2_) in volcados():
        c = compartidos(m, J, J2_)
        comunes = set(c) if comunes is None else comunes & set(c)
        n += 1
        nombres.append(nom)
        ultimo = c
    return n, nombres, sorted(comunes or []), (ultimo if n else {})


def autotest():
    n, nombres, comunes, ultimo = lista()
    fallos = []
    if n == 0:
        print("REVENTO: no hay volcados con el mod en %s" % VOLCADOS)
        return 2
    if POS_COMPARTIDO not in comunes:
        fallos.append("control positivo: +0x%X no sale compartido" % POS_COMPARTIDO)
    if NEG_DISTINTO in comunes:
        fallos.append("control negativo: +0x%X sale compartido" % NEG_DISTINTO)
    # poblacion: el bloque que sigue a J, que no es copia de nadie
    nom, m, (J, J2_) = next(volcados())
    falso = J + TAM
    c_falso = compartidos(m, J, falso)
    if len(c_falso) >= len(compartidos(m, J, J2_)):
        fallos.append("control de poblacion: un objeto que NO es copia comparte tanto como J2 (%d >= %d)"
                      % (len(c_falso), len(compartidos(m, J, J2_))))
    print("clon_comparte autotest: %d volcados, %d campos compartidos en todos, %d problema(s)"
          % (n, len(comunes), len(fallos)))
    for f in fallos:
        print("  ROJO: " + f)
    return 1 if fallos else 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    n, nombres, comunes, ultimo = lista()
    print("%d volcados con el mod (%s)" % (n, ", ".join(nombres)))
    print("%d campos de J2 que apuntan a LO MISMO que los de J en todos ellos:" % len(comunes))
    for off in comunes:
        print("  +0x%03X  -> 0x%08X" % (off, ultimo[off]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
