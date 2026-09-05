#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
probar-unit.py -- rompe el autotest de unit.py y exige verlo en ROJO.

POR QUE EXISTE
    `unit.py autotest` dice OK. Un chequeo que nunca dijo otra cosa esta SIN
    VERIFICAR (regla 3 del perfil): puede estar midiendo la precondicion en
    vez del efecto, o directamente no discriminar. Aca se le provoca el fallo
    a proposito, tres veces y por vias distintas, y se exige el rojo.

    Ya pago: el sabotaje 3 hizo que el autotest muriera con `struct.error` en
    vez de reportar rojo. Un autotest que revienta con traceback no es una
    alarma, es un cuelgue. Se arreglo, y el sabotaje quedo para que no vuelva.

    Cada sabotaje va seguido de un CONTROL POSITIVO: si el verde no vuelve
    despues de restaurar, el sabotaje ensucio algo y el rojo no prueba nada.

    python herramientas/probar-unit.py
"""
from __future__ import annotations

import contextlib
import io
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import unit  # noqa: E402


def correr() -> tuple[int, str]:
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        try:
            rc = unit.main(["autotest"])
        except Exception as e:                      # noqa: BLE001
            return 2, f"REVENTO: {type(e).__name__}: {e}"
    linea = [l for l in buf.getvalue().splitlines() if "AUTOTEST" in l]
    return rc, (linea[0].strip() if linea else "sin veredicto")


def sabotaje(nombre, aplicar, restaurar) -> bool:
    aplicar()
    rc, txt = correr()
    restaurar()
    rojo = rc == 1
    print(f"  [{'OK  ' if rojo else 'MAL '}] {nombre:<44} rc={rc}  {txt}")
    if rc == 2:
        print("         (revento en vez de reportar: eso NO es una alarma)")
    rc2, txt2 = correr()
    if rc2 != 0:
        print(f"  [MAL ] el control positivo NO vuelve a verde: {txt2}")
        return False
    return rojo


def main() -> int:
    print("PROBAR unit.py -- el autotest tiene que poder ponerse en rojo\n")
    rc, txt = correr()
    print(f"  [{'OK  ' if rc == 0 else 'MAL '}] control positivo inicial"
          f"{'':<21} rc={rc}  {txt}")
    if rc != 0:
        print("\n  el autotest ya esta en rojo: arreglar eso antes de sabotear")
        return 1

    bien = True

    orig = list(unit.RELOC)
    bien &= sabotaje(
        "1) todo el layout corrido +4 bytes",
        lambda: setattr(unit, "RELOC", [(o + 4, s) for o, s in orig]),
        lambda: setattr(unit, "RELOC", orig))

    origL = dict(unit.LISTAS)
    bien &= sabotaje(
        "2) declarar +0x2C como si fuera una lista",
        lambda: setattr(unit, "LISTAS", {0x2C: "falsa"}),
        lambda: setattr(unit, "LISTAS", origL))

    origP = unit.PATRON
    bien &= sabotaje(
        "3) apuntar los positivos a los .AWD",
        lambda: setattr(unit, "PATRON",
                        os.path.join(unit.ISO, "LEVELS", "LEVEL_*", "*.AWD")),
        lambda: setattr(unit, "PATRON", origP))

    origR = unit.REG_0X1C
    bien &= sabotaje(
        "4) el registro de +0x1C mide 0x40 en vez de 0x30",
        lambda: setattr(unit, "REG_0X1C", 0x40),
        lambda: setattr(unit, "REG_0X1C", origR))

    origL2 = unit.REG_LISTA
    bien &= sabotaje(
        "5) el registro de una lista mide 0x20 en vez de 0x10",
        lambda: setattr(unit, "REG_LISTA", 0x20),
        lambda: setattr(unit, "REG_LISTA", origL2))

    print()
    print("  LO QUE ESTE SABOTEADOR NO PUEDE PROBAR, Y CONVIENE SABERLO:")
    print("    el ancho de +0x90 (u16) NO se distingue de u8 con los datos del")
    print("    ISO: el maximo en las 42 unidades es 109 y el byte de +0x91 es")
    print("    cero en todas. Que sea u16 sale del codigo -- FUN_0012eae8 lo")
    print("    lee con `*(ushort *)` -- no de una medicion. El de +0x92 SI se")
    print("    mide: llega a 889 y 14 unidades tienen el byte alto distinto de")
    print("    cero.")

    print("\n  " + ("TODOS LOS SABOTAJES DIERON ROJO" if bien
                    else "HAY SABOTAJES QUE NO SE DETECTAN -- el autotest esta ciego"))
    return 0 if bien else 1


if __name__ == "__main__":
    sys.exit(main())
