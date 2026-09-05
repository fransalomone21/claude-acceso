#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
probar-modelo.py -- rompe el autotest de modelo.py y exige verlo en ROJO.

POR QUE EXISTE
    `modelo.py autotest` dice OK sobre 630379 vertices. Un chequeo que nunca
    dijo otra cosa esta SIN VERIFICAR (regla 3 del perfil). Y aca hay un
    motivo extra para desconfiar: la prueba principal es de CONTENCION -- que
    los vertices caigan ADENTRO de la caja del archivo -- y una prueba de
    contencion es facil de pasar por accidente. Un decodificador que devuelva
    todo cerca de cero pasa la contencion sin decodificar nada.

    Por eso el sabotaje 5 existe: encoge la escala en vez de agrandarla. Si el
    autotest solo mirara contencion, ese sabotaje pasaria en verde.

    Cada sabotaje va seguido de un CONTROL POSITIVO: si el verde no vuelve
    despues de restaurar, el sabotaje ensucio algo y el rojo no prueba nada.

    python herramientas/probar-modelo.py     (tarda ~2 min: barre el ISO 3
                                              veces por sabotaje)
"""
from __future__ import annotations

import contextlib
import io
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import modelo  # noqa: E402
import unit  # noqa: E402


def correr() -> tuple[int, str]:
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        try:
            rc = modelo.main(["autotest"])
        except Exception as e:                      # noqa: BLE001
            return 2, f"REVENTO: {type(e).__name__}: {e}"
    linea = [l for l in buf.getvalue().splitlines() if "AUTOTEST" in l]
    return rc, (linea[0].strip() if linea else "sin veredicto")


def sabotaje(nombre, aplicar, restaurar) -> bool:
    aplicar()
    rc, txt = correr()
    restaurar()
    rojo = rc == 1
    print(f"  [{'OK  ' if rojo else 'MAL '}] {nombre:<48} rc={rc}  {txt}")
    if rc == 2:
        print("         (revento en vez de reportar: eso NO es una alarma)")
    rc2, txt2 = correr()
    if rc2 != 0:
        print(f"  [MAL ] el control positivo NO vuelve a verde: {txt2}")
        return False
    return rojo


def main() -> int:
    print("PROBAR modelo.py -- el autotest tiene que poder ponerse en rojo\n")
    rc, txt = correr()
    print(f"  [{'OK  ' if rc == 0 else 'MAL '}] control positivo inicial"
          f"{'':<25} rc={rc}  {txt}")
    if rc != 0:
        print("\n  el autotest ya esta en rojo: arreglar eso antes de sabotear")
        return 1

    bien = True

    o = modelo.REG_VERTICE
    bien &= sabotaje(
        "1) el vertice mide 8 bytes en vez de 6",
        lambda: setattr(modelo, "REG_VERTICE", 8),
        lambda: setattr(modelo, "REG_VERTICE", o))

    o2 = modelo.REG_HOJA
    bien &= sabotaje(
        "2) la hoja mide 0x14 en vez de 0x10",
        lambda: setattr(modelo, "REG_HOJA", 0x14),
        lambda: setattr(modelo, "REG_HOJA", o2))

    o3 = modelo.SESGO
    bien &= sabotaje(
        "3) ignorar el byte de sesgo por eje",
        lambda: setattr(modelo, "SESGO", False),
        lambda: setattr(modelo, "SESGO", o3))

    o4 = modelo.MEDIO
    bien &= sabotaje(
        "4) el medio quantum vale 40 en vez de 0.5",
        lambda: setattr(modelo, "MEDIO", 40.0),
        lambda: setattr(modelo, "MEDIO", o4))

    o5 = modelo.QUANTUM
    bien &= sabotaje(
        "5) la escala es 100 veces mas CHICA (todo cerca de cero)",
        lambda: setattr(modelo, "QUANTUM", o5 / 100.0),
        lambda: setattr(modelo, "QUANTUM", o5))

    o6 = unit.PATRON
    bien &= sabotaje(
        "6) apuntar los positivos a los .AWD",
        lambda: setattr(unit, "PATRON",
                        os.path.join(unit.ISO, "LEVELS", "LEVEL_*", "*.AWD")),
        lambda: setattr(unit, "PATRON", o6))

    print()
    print("  LO QUE ESTE SABOTEADOR NO PUEDE PROBAR, Y CONVIENE SABERLO:")
    print("    - Que el orden de los ejes sea X, Y, Z y no otra permutacion.")
    print("      Las cajas del archivo se comparan eje por eje contra los")
    print("      mismos campos, asi que una permutacion consistente pasaria")
    print("      las tres pruebas. Lo unico que lo ata hoy es que las cajas")
    print("      salen con proporciones de camion y no de camion acostado.")
    print("    - Que los 4 indices de una cara sean un quad y no dos aristas")
    print("      o un tristrip: la contencion no mira las caras.")
    print("    - Que el u32 de la cara sea un id de superficie. Vale 0x0A en")
    print("      todo lo mirado y nadie lo confronto con nada.")

    print("\n  " + ("TODOS LOS SABOTAJES DIERON ROJO" if bien
                    else "HAY SABOTAJES QUE NO SE DETECTAN -- el autotest esta ciego"))
    return 0 if bien else 1


if __name__ == "__main__":
    sys.exit(main())
