#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
id64.py -- el codec de nombres de 64 bits de BLACK.

BLACK no guarda los nombres de sus recursos como texto: los empaqueta en un
u64. Hasta el 2026-08-21 ese ID se daba por opaco. No lo es: es base-40 de
ancho fijo, 12 caracteres, y tiene ida y vuelta.

DE DONDE SALE (no es adivinado, es portado)
    FUN_00272488 (0x00272488) DECODIFICA: hace 12 vueltas tomando el resto
    de dividir por 0x28 (=40) con FUN_00290AC0 y dividiendo por 40 con
    FUN_002904F0, y escribe los caracteres DE ATRAS HACIA ADELANTE (el
    indice va de 0xB a 0). El terminador va en +0xC.
    FUN_00272610 (0x00272610) CODIFICA.

    El alfabeto sale de la cadena de if/else de esa misma funcion:
        0        -> ' '   (relleno a la derecha)
        1        -> '-'
        2        -> '/'
        3..12    -> c + 0x2D  =  '0'..'9'
        13..38   -> c + 0x34  =  'A'..'Z'
        39       -> '_'
    No hay minusculas: los nombres se guardan en mayusculas.

POR QUE IMPORTA
    Con esto se leen los nombres de recurso del juego sin correr nada, y se
    pueden ESCRIBIR nombres nuevos en vez de sustituir bytes a ciegas.

CUIDADO AL BUSCAR IDs EN UN ARCHIVO
    El codec es TOTAL: todo u64 decodifica a 12 caracteres, asi que casi
    cualquier basura da un "nombre" de 12 letras. Sobre STLEVEL.BIN, filtrar
    solo por alfabeto valido da 79.048 nombres distintos: ruido puro.
    Lo que separa la senal es el RELLENO: un nombre real es mas corto que 12
    y queda con espacios a la derecha. Con >=2 espacios de relleno, los
    79.048 bajan a 88 y todos son nombres de verdad. Por eso --min-relleno
    existe y por eso su default no es 0.
"""

from __future__ import annotations

import argparse
import re
import struct
import sys

# El alfabeto, en el mismo orden que la cadena de if/else de FUN_00272488.
TABLA = [" ", "-", "/"]
TABLA += [chr(c + 0x2D) for c in range(3, 13)]    # '0'..'9'
TABLA += [chr(c + 0x34) for c in range(13, 39)]   # 'A'..'Z'
TABLA += ["_"]
INVERSA = {ch: i for i, ch in enumerate(TABLA)}

ANCHO = 12
BASE = 40


def decodificar(n: int) -> str:
    """u64 -> los 12 caracteres crudos, sin recortar el relleno."""
    salida = [" "] * ANCHO
    for i in range(ANCHO - 1, -1, -1):      # de atras hacia adelante, como el original
        salida[i] = TABLA[n % BASE]
        n //= BASE
    return "".join(salida)


def codificar(texto: str) -> int:
    """texto -> u64. Rellena con espacios a la derecha hasta 12."""
    texto = texto.upper().ljust(ANCHO)[:ANCHO]
    malos = sorted({c for c in texto if c not in INVERSA})
    if malos:
        raise ValueError("caracteres fuera del alfabeto base-40: %r" % malos)
    n = 0
    for ch in texto:
        n = n * BASE + INVERSA[ch]
    return n


def buscar(datos: bytes, min_relleno: int = 2, paso: int = 4):
    """Barre un buffer por u64 que decodifiquen a un identificador plausible.

    Devuelve [(offset, id64, nombre)]. Ver la nota de arriba sobre por que
    el filtro de relleno no es opcional en la practica.
    """
    patron = re.compile(r"^[A-Z][A-Z0-9_]*" + " " * min_relleno + "$")
    encontrados = []
    for off in range(0, len(datos) - 8, paso):
        n = struct.unpack_from("<Q", datos, off)[0]
        if n == 0:
            continue
        texto = decodificar(n)
        if patron.match(texto):
            encontrados.append((off, n, texto.rstrip()))
    return encontrados


# --- autotest -------------------------------------------------------------
# Los casos NO son inventados: son ids leidos de volcados/stlevel-l00.bin en
# la tabla de camaras (seccion 0x261300), que decodificaron a nombres con
# sentido y EN ORDEN ALFABETICO -- un orden que ningun codec equivocado
# produce por casualidad.
CASOS = [
    (0x594C3AA90B52FD16, "CAM_BLOWDOOR"),
    (0x594C3BB618C63E00, "CAM_INTRO"),
    (0x594C3D38D5EBA000, "CAM_START"),
    (0x5FA80578F9C81700, "DEATHCAM01"),
    (0x68AE713DCEBB57AB, "E_BLACKHD_M0"),
    (0xA79C744648E00000, "PSTL0"),
]


def autotest() -> int:
    fallos = 0
    for id64, esperado in CASOS:
        obtenido = decodificar(id64).rstrip()
        if obtenido != esperado:
            print("FALLA decodificar 0x%016X -> %r, se esperaba %r"
                  % (id64, obtenido, esperado))
            fallos += 1
    for _, nombre in CASOS:
        ida = codificar(nombre)
        vuelta = decodificar(ida).rstrip()
        if vuelta != nombre:
            print("FALLA ida y vuelta %r -> 0x%016X -> %r" % (nombre, ida, vuelta))
            fallos += 1
    # El de 12 caracteres es el caso borde: no le sobra relleno.
    if len(CASOS[4][1]) != ANCHO:
        print("FALLA el caso borde de 12 caracteres ya no mide 12")
        fallos += 1
    print("autotest: %d caso(s), %d falla(s)" % (len(CASOS) * 2 + 1, fallos))
    return 1 if fallos else 0


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__.splitlines()[1],
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)

    d = sub.add_parser("decodificar", help="u64 -> nombre")
    d.add_argument("id64", help="el ID, en hex (0x...) o decimal")

    c = sub.add_parser("codificar", help="nombre -> u64")
    c.add_argument("nombre")

    b = sub.add_parser("buscar", help="barrer un archivo por IDs validos")
    b.add_argument("archivo")
    b.add_argument("--min-relleno", type=int, default=2,
                   help="espacios de relleno exigidos a la derecha (default 2). "
                        "Con 0 el resultado es ruido: leer el encabezado.")
    b.add_argument("--base", default="0",
                   help="direccion de carga, para imprimir offsets absolutos")

    sub.add_parser("autotest", help="probar el codec contra casos conocidos")

    a = p.parse_args()

    if a.cmd == "autotest":
        return autotest()

    if a.cmd == "decodificar":
        n = int(a.id64, 0)
        print("0x%016X -> %r" % (n, decodificar(n).rstrip()))
        return 0

    if a.cmd == "codificar":
        try:
            n = codificar(a.nombre)
        except ValueError as e:
            print("error: %s" % e)
            return 1
        print("%r -> 0x%016X" % (a.nombre.upper(), n))
        return 0

    if a.cmd == "buscar":
        datos = open(a.archivo, "rb").read()
        base = int(a.base, 0)
        hallados = buscar(datos, a.min_relleno)
        print("%d ID(s) con relleno >= %d en %s"
              % (len(hallados), a.min_relleno, a.archivo))
        for off, n, nombre in hallados:
            print("  0x%08X  0x%016X  %s" % (base + off, n, nombre))
        return 0

    return 1


if __name__ == "__main__":
    sys.exit(main())
