#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tablas.py — buscar TABLAS en frío: en el ELF del ISO o en un volcado de RAM.

Las otras herramientas parten de un dato conocido y buscan quién lo toca.
Ésta va al revés: barre el binario entero buscando cosas con FORMA de tabla,
sin saber de antemano qué son. Sirve para el trabajo de reconocimiento —
"¿qué estructuras hay que todavía no miramos?" — no para confirmar nada.

    esquemas    racimos de cadenas contiguas = nombres de campo de un struct
    punteros    corridas de punteros a cadenas = tablas de nombres / enums
    flotantes   corridas de f32 plausibles     = tablas de parámetros
    vecinos     qué hay alrededor de una dirección: floats, punteros, texto

TODO LO QUE SALE DE ACÁ ES `hipotesis`. Una corrida de floats con forma de
tabla puede ser una tabla, o puede ser el residuo de otra cosa. Lo que la
convierte en un hallazgo es escribirle un valor y ver el efecto (regla 1 de
black/CLAUDE.md).

EL PARÁMETRO --base ES LO ÚNICO QUE HAY QUE ENTENDER
    Es la dirección EE del primer byte del archivo, para que la herramienta
    imprima direcciones y no offsets.

        ELF del ISO (SLUS_213.76)     --base 0xFF000   (verificado 6/6)
        volcado de RAM (pine volcar)  --base 0         (el default)

    Ver docs/05-iso.md.

EJEMPLOS
    python herramientas/tablas.py esquemas D:\\SLUS_213.76 --base 0xFF000
    python herramientas/tablas.py punteros D:\\SLUS_213.76 --base 0xFF000 --min 6
    python herramientas/tablas.py flotantes D:\\SLUS_213.76 --base 0xFF000 \\
        --desde 0x003BC330 --hasta 0x0040E580
    python herramientas/tablas.py vecinos D:\\SLUS_213.76 --base 0xFF000 0x003BCE70
"""

from __future__ import annotations

import argparse
import math
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402


# --------------------------------------------------------------------------
# utilidades


def leer(ruta: str) -> bytes:
    return Path(ruta).read_bytes()


def recorte(datos: bytes, base: int, desde: int | None, hasta: int | None):
    """Devuelve (offset_inicial, offset_final) acotados al rango pedido."""
    ini = 0 if desde is None else max(0, desde - base)
    fin = len(datos) if hasta is None else min(len(datos), hasta - base)
    if ini >= fin:
        raise SystemExit(f"rango vacío: 0x{ini:X}..0x{fin:X} dentro del archivo")
    return ini, fin


def cadena_en(datos: bytes, off: int, largo_max: int = 64) -> str | None:
    """Cadena ASCII terminada en NUL que empieza en `off`, o None."""
    if not (0 <= off < len(datos)):
        return None
    fin = datos.find(b"\x00", off, off + largo_max + 1)
    if fin < 0 or fin == off:
        return None
    trozo = datos[off:fin]
    if not all(0x20 <= c < 0x7F for c in trozo):
        return None
    return trozo.decode("ascii")


def float_plausible(v: float) -> bool:
    """Un f32 que puede ser un parámetro de juego y no basura reinterpretada."""
    if v == 0.0:
        return True
    if math.isnan(v) or math.isinf(v):
        return False
    a = abs(v)
    return 1e-4 <= a <= 1e7


def fmt_float(v: float) -> str:
    if v == int(v) and abs(v) < 1e9:
        return f"{int(v)}"
    return f"{v:.6g}"


# --------------------------------------------------------------------------
# esquemas: racimos de cadenas contiguas


RE_CADENA = re.compile(rb"[\x20-\x7e]{3,}\x00")


def parece_nombre_de_campo(t: str) -> bool:
    """Nombre de campo estilo ValueDB: 'Num Bullets In Clip', 'MaxYawSpeed'."""
    if not (4 <= len(t) <= 48):
        return False
    if any(c in t for c in "/\\%<>{}()[]:;=*#!?\"'"):
        return False
    palabras = t.split()
    if not palabras:
        return False
    if not t[0].isalpha():
        return False
    return all(p[0].isupper() or p[0].isdigit() for p in palabras)


def cmd_esquemas(args) -> int:
    datos = leer(args.archivo)
    ini, fin = recorte(datos, args.base, args.desde, args.hasta)

    cadenas = [(m.start(), m.group()[:-1].decode("ascii"))
               for m in RE_CADENA.finditer(datos, ini, fin)]
    if not cadenas:
        print("  no hay cadenas en el rango")
        return 0

    racimos, actual = [], [cadenas[0]]
    for off, txt in cadenas[1:]:
        fin_prev = actual[-1][0] + len(actual[-1][1]) + 1
        if off - fin_prev <= args.hueco:
            actual.append((off, txt))
        else:
            racimos.append(actual)
            actual = [(off, txt)]
    racimos.append(actual)

    cand = []
    for r in racimos:
        if len(r) < args.min:
            continue
        n = sum(1 for _, t in r if parece_nombre_de_campo(t))
        if n >= max(args.min, int(0.6 * len(r))):
            cand.append((n / len(r), r))
    cand.sort(key=lambda x: -len(x[1]))

    print(f"  {len(cadenas)} cadenas, {len(racimos)} racimos, "
          f"{len(cand)} candidatos a esquema (min {args.min})\n")
    for ratio, r in cand[:args.max]:
        a = r[0][0] + args.base
        b = r[-1][0] + len(r[-1][1]) + args.base
        print(f"  0x{a:08X}-0x{b:08X}  {len(r)} cadenas, {ratio:.0%} con forma de campo")
        print("      " + " | ".join(t for _, t in r))
        print()
    return 0


# --------------------------------------------------------------------------
# punteros: corridas de punteros a cadenas


def cmd_punteros(args) -> int:
    datos = leer(args.archivo)
    ini, fin = recorte(datos, args.base, args.desde, args.hasta)

    n = (fin - ini) // 4
    apunta = [None] * n          # texto al que apunta cada palabra, o None
    for k in range(n):
        v = struct.unpack_from("<I", datos, ini + 4 * k)[0]
        apunta[k] = cadena_en(datos, v - args.base) if v else None

    corridas, k = [], 0
    while k < n:
        if apunta[k] is None:
            k += 1
            continue
        j = k
        while j < n and apunta[j] is not None:
            j += 1
        if j - k >= args.min:
            corridas.append((k, j))
        k = j

    print(f"  {len(corridas)} corridas de >= {args.min} punteros a cadena\n")
    for k, j in corridas[:args.max]:
        a = ini + 4 * k + args.base
        print(f"  0x{a:08X}  {j - k} entradas")
        for i in range(k, j):
            print(f"      [{i - k:3d}] {apunta[i]}")
        print()
    return 0


# --------------------------------------------------------------------------
# flotantes: corridas de f32 plausibles


def cmd_flotantes(args) -> int:
    datos = leer(args.archivo)
    ini, fin = recorte(datos, args.base, args.desde, args.hasta)

    n = (fin - ini) // 4
    vals = [struct.unpack_from("<f", datos, ini + 4 * k)[0] for k in range(n)]
    ok = [float_plausible(v) for v in vals]

    corridas, k = [], 0
    while k < n:
        if not ok[k]:
            k += 1
            continue
        j = k
        while j < n and ok[j]:
            j += 1
        # una corrida de puros ceros no es una tabla, es relleno
        if j - k >= args.min and any(vals[i] != 0.0 for i in range(k, j)):
            corridas.append((k, j))
        k = j

    print(f"  {len(corridas)} corridas de >= {args.min} f32 plausibles\n")
    for k, j in corridas[:args.max]:
        a = ini + 4 * k + args.base
        muestra = ", ".join(fmt_float(v) for v in vals[k:min(j, k + 16)])
        cola = " ..." if j - k > 16 else ""
        print(f"  0x{a:08X}  {j - k} valores: {muestra}{cola}")
    return 0


# --------------------------------------------------------------------------
# vecinos: qué hay alrededor de una dirección


def cmd_vecinos(args) -> int:
    datos = leer(args.archivo)
    centro = args.direccion - args.base
    ini = max(0, centro - args.radio)
    fin = min(len(datos), centro + args.radio)

    for off in range(ini & ~3, fin, 4):
        v = struct.unpack_from("<I", datos, off)[0]
        f = struct.unpack_from("<f", datos, off)[0]
        marca = "  <--" if off == centro else ""
        notas = []
        s = cadena_en(datos, v - args.base)
        if s:
            notas.append(f'-> "{s}"')
        elif 0x00100000 <= v <= 0x02000000:
            notas.append("ptr?")
        if float_plausible(f) and f != 0.0:
            notas.append(f"f32 {fmt_float(f)}")
        txt = "".join(chr(c) if 0x20 <= c < 0x7F else "." for c in datos[off:off + 4])
        print(f"  0x{off + args.base:08X}  {v:08X}  |{txt}|  "
              f"{'  '.join(notas)}{marca}")
    return 0


# --------------------------------------------------------------------------


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Buscar tablas en frío sobre el ELF o un volcado de RAM",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="--base: dirección EE del primer byte del archivo. "
               "ELF del ISO = 0xFF000, volcado de RAM = 0.")
    p.add_argument("--base", type=lambda s: int(s, 0), default=0,
                   help="dirección EE del byte 0 del archivo (default 0)")
    p.add_argument("--desde", type=lambda s: int(s, 0), default=None,
                   help="acotar el barrido desde esta dirección EE")
    p.add_argument("--hasta", type=lambda s: int(s, 0), default=None,
                   help="acotar el barrido hasta esta dirección EE")
    p.add_argument("--max", type=int, default=40,
                   help="cuántos resultados listar (default 40)")
    sub = p.add_subparsers(dest="cmd", required=True)

    e = sub.add_parser("esquemas", help="racimos de cadenas = nombres de campo")
    e.add_argument("archivo")
    e.add_argument("--min", type=int, default=6, help="cadenas mínimas por racimo")
    e.add_argument("--hueco", type=int, default=8,
                   help="bytes máximos entre dos cadenas del mismo racimo")
    e.set_defaults(func=cmd_esquemas)

    q = sub.add_parser("punteros", help="corridas de punteros a cadena")
    q.add_argument("archivo")
    q.add_argument("--min", type=int, default=5, help="entradas mínimas")
    q.set_defaults(func=cmd_punteros)

    f = sub.add_parser("flotantes", help="corridas de f32 plausibles")
    f.add_argument("archivo")
    f.add_argument("--min", type=int, default=8, help="valores mínimos")
    f.set_defaults(func=cmd_flotantes)

    v = sub.add_parser("vecinos", help="volcar el entorno de una dirección")
    v.add_argument("archivo")
    v.add_argument("direccion", type=lambda s: int(s, 0))
    v.add_argument("--radio", type=lambda s: int(s, 0), default=0x40,
                   help="bytes a cada lado (default 0x40)")
    v.set_defaults(func=cmd_vecinos)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
