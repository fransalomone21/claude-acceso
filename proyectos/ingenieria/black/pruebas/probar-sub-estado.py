#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-sub-estado.py -- el saboteador de sub_estado.py (118).

    python pruebas/probar-sub-estado.py

Rompe UNA cosa a la vez y exige que el autotest se ponga en ROJO; despues corre el control
positivo (todo sano) y exige VERDE. Distingue tres resultados, no dos: verde, rojo y REVENTO
(una excepcion no es un rojo). Los sabotajes apuntan a los HALLAZGOS concretos, no a la regla
entera:

  1. el global de `pers` movido           -> sin pers no hay subs: tiene que dar rojo
  2. el paso entre subs cambiado          -> los subs dejan de caer donde estan: rojo
  3. el offset de la cuadrupla cambiado   -> el 4/4 adentro de la arena se cae: rojo
  4. el offset de la GUARDA cambiado      -> deja de discriminar vivo de colgado: rojo
  5. la reserva del sub3 corrida a codigo -> no esta en cero: rojo
  6. nada roto                            -> control positivo: verde

El 4 es el que importa: si la guarda no discrimina, la regla del dueno de plantilla escribe
cuatro palabras sobre un puntero colgado. Ver `docs/16`, "La guarda de plantilla viva, (118)".
"""
import io
import os
import sys
import contextlib

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "herramientas"))
os.chdir(RAIZ)

import sub_estado as S  # noqa: E402

import glob  # noqa: E402

RUTAS = sorted(glob.glob(os.path.join(RAIZ, "volcados", "ee-*.bin")))

SABOTAJES = [
    ("pers movido 4 B", "PERS_GLOBAL", S.PERS_GLOBAL + 4),
    ("paso entre subs 0x70", "SUB_PASO", 0x70),
    ("cuadrupla en +0x40", "CUAD", (0x40, 0x44, 0x48, 0x4C)),
    ("guarda en +0x20", "VIVA_OFF", 0x20),
    ("reserva de datos sobre codigo vivo", "RES_SUB3_DAT", (0x00100000, 0x00100040)),
]


def correr():
    """Devuelve ('verde'|'rojo'|'revento', texto)."""
    buf = io.StringIO()
    try:
        with contextlib.redirect_stdout(buf):
            cod = S.autotest(RUTAS)
    except Exception as e:  # noqa: BLE001
        return "revento", f"{type(e).__name__}: {e}"
    return ("verde" if cod == 0 else "rojo"), buf.getvalue().strip().splitlines()[-1]


def main():
    fallos = []
    print(f"{len(RUTAS)} volcados")
    for nombre, attr, valor in SABOTAJES:
        viejo = getattr(S, attr)
        setattr(S, attr, valor)
        res, detalle = correr()
        setattr(S, attr, viejo)
        bien = res == "rojo"
        print(f"  [{'OK ' if bien else 'MAL'}] sabotaje: {nombre:<34} -> {res}  ({detalle})")
        if not bien:
            fallos.append(f"{nombre}: esperaba rojo, dio {res} ({detalle})")
    res, detalle = correr()
    bien = res == "verde"
    print(f"  [{'OK ' if bien else 'MAL'}] control positivo: nada roto        -> {res}  ({detalle})")
    if not bien:
        fallos.append(f"control positivo: esperaba verde, dio {res} ({detalle})")
    print()
    if fallos:
        print(f"PROBAR-SUB-ESTADO: {len(fallos)} FALLO(S)")
        for f in fallos:
            print("   -", f)
        return 1
    print(f"PROBAR-SUB-ESTADO: {len(SABOTAJES)} sabotajes en rojo y el control positivo en verde")
    return 0


if __name__ == "__main__":
    sys.exit(main())
