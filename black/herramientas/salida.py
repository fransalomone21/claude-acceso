#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
salida.py — que la consola no se lleve puesto un comando entero.

No es un comando: es una biblioteca que usan las otras herramientas.

EL PROBLEMA
    En Windows, cuando la salida se redirige (a un archivo, a un pipe, o a
    una herramienta que la captura), Python deja de hablarle a la consola y
    codifica con la página de códigos local — cp1252 acá. cp1252 no tiene
    'Δ' (U+0394), así que un print con un 'Δ' adentro muere con
    UnicodeEncodeError y se lleva puesto el comando entero, no sólo esa
    línea. Pasó dos veces: en `vigilar.py analizar` (imprimía todo el
    análisis y reventaba en 'primeros:') y en `inspeccionar.py comparar`
    (peor: el 'Δ' está en la cabecera, así que decía "3 campo(s) cambiaron"
    y moría antes de mostrar un solo campo).

POR QUÉ NO SE ARREGLA FORZANDO UTF-8
    Sería una línea: `sys.stdout.reconfigure(encoding="utf-8")`. Pero eso
    escribe bytes UTF-8 en consolas que están leyendo cp1252, y convierte
    'tamaño' en 'tamaÃ±o' justo en las máquinas donde hoy se ve bien. Se
    cambia el símbolo, no la codificación del flujo.
"""

from __future__ import annotations

import sys


def simbolo_delta(flujo=None) -> str:
    """'Δ' si la salida sabe escribirlo; 'd' si no.

    Se consulta en cada llamada, no una vez al importar: el flujo puede
    haberse redirigido después (las pruebas lo hacen).
    """
    flujo = flujo if flujo is not None else sys.stdout
    codificacion = getattr(flujo, "encoding", None) or "ascii"
    try:
        "Δ".encode(codificacion)
    except (UnicodeEncodeError, LookupError):
        return "d"
    return "Δ"


def tolerar_salida_pobre() -> None:
    """Que un carácter no representable degrade la salida, no que la corte.

    Red de seguridad para el resto del texto (ñ, ±, tildes): bajo una
    codificación aún más pobre que cp1252 —un `LC_ALL=C` en Linux deja
    stdout en ASCII— también reventarían. Con errors='replace' salen como
    '?' y el comando termina de imprimir. No se toca la codificación del
    flujo, por lo que dice el encabezado de este módulo.

    Va al principio de main(), no al importar: importar una herramienta no
    debería cambiarle la salida al programa que la importa.
    """
    for flujo in (sys.stdout, sys.stderr):
        try:
            flujo.reconfigure(errors="replace")
        except (AttributeError, ValueError, OSError):
            pass
