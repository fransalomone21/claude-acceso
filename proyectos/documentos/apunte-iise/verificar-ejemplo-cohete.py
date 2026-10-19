#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verificar-ejemplo-cohete.py -- el medidor del ejemplo del cohete de agua de M17 (fase 10, DA-068).

La puerta de la cascada hace leer M17 cada vez que se escriben requerimientos,
y el metodo copia la forma de los ejemplares. El ejemplo del cohete estuvo con
numeros de desempeno en el L0 (10 Hz, 200 ms, 250 +- 10 m), contra la tabla de
niveles del mismo modulo (L1 = cuan bien, en numeros). Este script mide, sobre
el fuente del ejemplo:

  (a) NINGUN L0 LLEVA UN NUMERO, fuera de las marcas de TBD/TBR.
  (b) CADA L0 TRAZA A UNA NECESIDAD O RESTRICCION QUE ESTA EN LA TABLA (N-nn, R-nn).
  (c) CADA L1 TRAZA A UN L0 QUE ESTA EN LA TABLA.
  (d) LA PROSA DEL EJEMPLO NOMBRA SOLO IDs QUE EXISTEN.
  (e) HAY FILAS L0 Y L1: si cambia la forma de los IDs y no ve ninguna, es
      rojo. Un medidor que no encuentra nada que medir no da verde.

Sale con 1 si algo esta en rojo y con 2 si no encuentra el ejemplo (REVENTO):
las dos salidas tempranas fallan cerradas.

Uso:
    python verificar-ejemplo-cohete.py              # sobre el modulo real
    python verificar-ejemplo-cohete.py --sabotaje   # rompe cada chequeo y exige SU rojo;
                                                    # sale 0 = todos los sabotajes detectados
"""

import argparse
import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

AQUI = Path(__file__).resolve().parent
M17 = AQUI / "apunte" / "modulos" / "m17-familia-de-requerimientos-y-trazabilidad.typ"
FILA = re.compile(r"^(\s*)\[([A-Z]+-[-A-Z0-9.]*)\], \[([^\]]*)\], \[(.*)\],\s*$", re.M)
MARCA = re.compile(r"\\\[(TBD|TBR)[^\]]*\\\]")
CADENA = "*Una cadena completa"


def ejemplo(texto: str) -> str:
    a = texto.find('#ejemplo("el cohete de agua')
    b = texto.find("#cuidado[", a)
    if a < 0 or b < 0:
        return ""
    return texto[a:b]


def medir(ej: str) -> list:
    """Lista de rojos, cada uno con su marca (a)..(e). Vacia = verde."""
    rojos = []
    filas = [(m.group(2), m.group(3), m.group(4)) for m in FILA.finditer(ej)]
    padres = set(re.findall(r"^\s*\[((?:N|R)-\d\d)\], \[", ej, flags=re.M))
    l0 = [f for f in filas if f[0].startswith("REQ-L0-")]
    l1 = [f for f in filas if f[0].startswith("REQ-L1-")]
    if not l0 or not l1:
        rojos.append("(e) no hay filas REQ-L0-/REQ-L1- (L0=%d, L1=%d)" % (len(l0), len(l1)))
    for ident, padre, texto in l0:
        if re.search(r"\d", MARCA.sub("", texto)):
            rojos.append("(a) L0 con numero: %s -- %s" % (ident, texto))
        for p in [p.strip() for p in padre.split(",")]:
            if p not in padres:
                rojos.append("(b) %s traza a %s, que no esta en la tabla" % (ident, p))
    ids_l0 = {f[0] for f in l0}
    for ident, padre, _ in l1:
        if padre not in ids_l0:
            rojos.append("(c) %s traza a %s, que no esta en la tabla" % (ident, padre))
    i = ej.find(CADENA)
    prosa = ej[i:] if i >= 0 else ""
    for ident in sorted(set(re.findall(r"REQ-L[01]-\d(?:\.\d)?", prosa))):
        if ident not in ids_l0 | {f[0] for f in l1}:
            rojos.append("(d) la prosa nombra %s, que no esta en ninguna tabla" % ident)
    return rojos


def primera_fila(ej: str, prefijo: str):
    for m in FILA.finditer(ej):
        if m.group(2).startswith(prefijo):
            return m
    return None


def sabotajes(ej: str) -> list:
    """(nombre, marca que tiene que saltar, texto saboteado; None si el sabotaje no encontro donde aplicarse).
    Cada mutacion se deriva del archivo, no de un literal suyo: si el ejemplo cambia, el sabotaje lo sigue."""
    out = []
    m0 = primera_fila(ej, "REQ-L0-")
    m1 = primera_fila(ej, "REQ-L1-")
    i = ej.find(CADENA)
    # la forma vieja: el cuan bien metido en el tope
    out.append(("L0 con numero de desempeno", "(a)",
                ej[:m0.start(4)] + m0.group(4).rstrip(".") + ", a no menos de 10 Hz." + ej[m0.end(4):] if m0 else None))
    out.append(("L0 con padre inexistente", "(b)", ej[:m0.start(3)] + "N-99" + ej[m0.end(3):] if m0 else None))
    out.append(("L1 con padre inexistente", "(c)", ej[:m1.start(3)] + "REQ-L0-9" + ej[m1.end(3):] if m1 else None))
    out.append(("la prosa nombra un ID inexistente", "(d)",
                ej[:i + len(CADENA)] + " REQ-L1-9.9" + ej[i + len(CADENA):] if i >= 0 else None))
    out.append(("los IDs con la forma vieja (REQ-00)", "(e)", re.sub(r"REQ-L([01])-", r"REQ-\1", ej)))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sabotaje", action="store_true")
    a = ap.parse_args()
    ej = ejemplo(M17.read_text(encoding="utf-8")) if M17.exists() else ""
    if not ej:
        print("REVENTO: no encuentro el ejemplo del cohete en %s" % M17)
        return 2
    rojos = medir(ej)
    if not a.sabotaje:
        for r in rojos:
            print("[ROJO] " + r)
        print("EJEMPLO DEL COHETE EN VERDE." if not rojos else "EJEMPLO DEL COHETE EN ROJO (%d)." % len(rojos))
        return 1 if rojos else 0
    mal = 0
    print("%s  CONTROL: el modulo real da verde%s" % ("ok " if not rojos else "MAL", "" if not rojos else " -- " + rojos[0]))
    mal += bool(rojos)
    for nombre, marca, texto in sabotajes(ej):
        if texto is None or texto == ej:
            print("MAL  %s: el sabotaje no llego (no encontro donde aplicarse)" % nombre)
            mal += 1
            continue
        salto = [r for r in medir(texto) if r.startswith(marca)]
        print("%s  %s -> %s" % ("ok " if salto else "MAL", nombre, salto[0] if salto else "VERDE: no lo vio"))
        mal += not salto
    print("SABOTAJES DETECTADOS." if not mal else "SABOTAJE CON FALLAS (%d)." % mal)
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
