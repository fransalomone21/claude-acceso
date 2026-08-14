#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
inspeccionar.py — mira una región de memoria como lo que probablemente sea:
enteros, flotantes, punteros o texto.

POR QUÉ
    Cuando ya tenés UNA dirección buena (la vida, digamos), lo que sigue no es
    buscar más: es mirar alrededor. Los campos de un mismo objeto viven
    pegados. `vida_max` casi siempre está a menos de 0x40 bytes de `vida`.
    Este comando vuelca el entorno y marca lo que parece puntero, lo que
    parece flotante razonable y lo que parece texto, para que el mapeo de la
    estructura sea leer y no adivinar.

COMANDOS
    volcar     ver una región interpretada campo por campo
    comparar   dos volcados de la misma región -> qué cambió (así se identifica
               qué campo es qué: hacé algo en el juego entre uno y otro)
    seguir     recorrer una cadena de punteros (base -> +off -> +off ...)

EJEMPLOS
    # el entorno de una dirección conocida, en vivo
    python3 inspeccionar.py volcar 0x2038A0 --antes 0x40 --largo 0x100

    # ¿qué campos se movieron cuando disparé?
    python3 inspeccionar.py comparar 0x203880 --largo 0x100 --guardar a.bin
    #   (disparás en el juego)
    python3 inspeccionar.py comparar 0x203880 --largo 0x100 --contra a.bin

    # desde un savestate en vez de en vivo
    python3 inspeccionar.py volcar 0x2038A0 --desde ~/.config/PCSX2/sstates/x.p2s
"""

from __future__ import annotations

import argparse
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import estado as mod_estado  # noqa: E402

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Una dirección plausible dentro de la RAM del juego.
PTR_MIN = 0x0010_0000
PTR_MAX = 0x0200_0000


class InspeccionError(RuntimeError):
    pass


def obtener(direccion: int, largo: int, desde: str | None) -> bytes:
    """Lee una región, en vivo por PINE o desde un savestate."""
    if desde:
        ram = mod_estado.leer_ee(desde)
        if direccion + largo > len(ram):
            raise InspeccionError(
                f"0x{direccion + largo:08X} se pasa de los {len(ram)} bytes del savestate"
            )
        return ram[direccion : direccion + largo]
    from pine import Pine
    with Pine() as p:
        return p.leer_bloque(direccion, largo)


def _es_puntero(v: int) -> bool:
    return PTR_MIN <= v < PTR_MAX and v % 4 == 0


def _float_razonable(f: float) -> bool:
    """Descarta los flotantes absurdos que en realidad son otra cosa."""
    if f != f or f in (float("inf"), float("-inf")):
        return False
    a = abs(f)
    return a == 0.0 or 1e-4 < a < 1e7


def _ascii(b: bytes) -> str:
    return "".join(chr(c) if 32 <= c < 127 else "." for c in b)


def interpretar(direccion: int, datos: bytes, resaltar: set[int] | None = None) -> None:
    resaltar = resaltar or set()
    print(f"{'dirección':<12} {'off':>6}  {'hex':>8}  {'u32':>12} {'i32':>12} "
          f"{'f32':>14}  {'ascii':<8} pistas")
    print("-" * 96)
    for i in range(0, len(datos) - 3, 4):
        d = direccion + i
        crudo = datos[i : i + 4]
        u = struct.unpack("<I", crudo)[0]
        s = struct.unpack("<i", crudo)[0]
        f = struct.unpack("<f", crudo)[0]

        pistas = []
        if _es_puntero(u):
            pistas.append("PUNTERO?")
        if _float_razonable(f) and u not in (0,) and not (0 < u < 0x10000):
            pistas.append("float?")
        if all(32 <= c < 127 for c in crudo):
            pistas.append("texto?")
        if 0 < u <= 10000:
            pistas.append("contador/salud?")
        if u in (0x3F800000,):
            pistas.append("=1.0f")

        f_txt = f"{f:14.5g}" if _float_razonable(f) else " " * 14
        marca = ">>" if i in resaltar else "  "
        print(f"{marca}0x{d:08X} {i:+6d}  {u:08X}  {u:12d} {s:12d} {f_txt}  "
              f"{_ascii(crudo):<8} {' '.join(pistas)}")


def cmd_volcar(args) -> int:
    inicio = args.direccion - args.antes
    if inicio < 0:
        inicio = 0
    datos = obtener(inicio, args.largo, args.desde)
    print(f"región 0x{inicio:08X} .. 0x{inicio + args.largo:08X}"
          f"   (ancla: 0x{args.direccion:08X})\n")
    interpretar(inicio, datos, resaltar={args.direccion - inicio})
    if args.guardar:
        with open(args.guardar, "wb") as f:
            f.write(datos)
        print(f"\nguardado -> {args.guardar}")
    return 0


def cmd_comparar(args) -> int:
    datos = obtener(args.direccion, args.largo, args.desde)
    if args.guardar:
        with open(args.guardar, "wb") as f:
            f.write(datos)
        print(f"instantánea guardada -> {args.guardar}")
        print("Ahora hacé lo que quieras observar en el juego y corré el mismo "
              "comando con --contra en vez de --guardar.")
        return 0

    if not args.contra:
        raise InspeccionError("usá --guardar para la primera toma y --contra para la segunda")
    with open(args.contra, "rb") as f:
        previo = f.read()
    if len(previo) != len(datos):
        raise InspeccionError(
            f"la instantánea guardada mide {len(previo)} bytes y esta {len(datos)}"
        )

    cambios = []
    for i in range(0, len(datos) - 3, 4):
        a = struct.unpack_from("<I", previo, i)[0]
        b = struct.unpack_from("<I", datos, i)[0]
        if a != b:
            cambios.append((i, a, b))

    if not cambios:
        print("no cambió nada en la región")
        return 0

    print(f"{len(cambios)} campo(s) cambiaron en 0x{args.direccion:08X}"
          f"..0x{args.direccion + args.largo:08X}\n")
    print(f"{'dirección':<12} {'off':>6}  {'antes':>12} -> {'ahora':>12}  {'Δ':>12}  pistas")
    print("-" * 84)
    for i, a, b in cambios:
        d = args.direccion + i
        sa = struct.unpack("<i", struct.pack("<I", a))[0]
        sb = struct.unpack("<i", struct.pack("<I", b))[0]
        fa = struct.unpack("<f", struct.pack("<I", a))[0]
        fb = struct.unpack("<f", struct.pack("<I", b))[0]
        pistas = []
        if _es_puntero(a) and _es_puntero(b):
            pistas.append("PUNTERO")
        elif _float_razonable(fa) and _float_razonable(fb):
            pistas.append(f"float {fa:g} -> {fb:g}")
        print(f"0x{d:08X} {i:+6d}  {sa:12d} -> {sb:12d}  {sb - sa:+12d}  {' '.join(pistas)}")
    return 0


def cmd_seguir(args) -> int:
    """Recorre base -> [base]+off1 -> [..]+off2 ... como hace un puntero de Cheat Engine."""
    from pine import Pine
    with Pine() as p:
        actual = args.base
        print(f"base            0x{actual:08X}")
        for n, off in enumerate(args.offset, 1):
            leido = p.leer32(actual)
            if not _es_puntero(leido):
                print(f"  paso {n}: [0x{actual:08X}] = 0x{leido:08X}  "
                      "<- NO parece un puntero válido; la cadena se corta acá")
                return 1
            actual = leido + off
            print(f"  paso {n}: [.] = 0x{leido:08X}  +0x{off:X}  ->  0x{actual:08X}")
        print(f"\nfinal           0x{actual:08X}")
        print(f"  valor u32     {p.leer32(actual)}")
        print(f"  valor f32     {p.leer_f32(actual)}")
    return 0


def _entero(t: str) -> int:
    return int(t, 0)


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Inspector de estructuras en memoria del EE")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_v = sub.add_parser("volcar")
    p_v.add_argument("direccion", type=_entero)
    p_v.add_argument("--antes", type=_entero, default=0x20,
                     help="cuántos bytes mostrar ANTES de la dirección")
    p_v.add_argument("--largo", type=_entero, default=0x100)
    p_v.add_argument("--desde", help="savestate .p2s en vez de leer en vivo")
    p_v.add_argument("--guardar")
    p_v.set_defaults(func=cmd_volcar)

    p_c = sub.add_parser("comparar")
    p_c.add_argument("direccion", type=_entero)
    p_c.add_argument("--largo", type=_entero, default=0x100)
    p_c.add_argument("--desde")
    p_c.add_argument("--guardar")
    p_c.add_argument("--contra")
    p_c.set_defaults(func=cmd_comparar)

    p_s = sub.add_parser("seguir")
    p_s.add_argument("base", type=_entero)
    p_s.add_argument("offset", type=_entero, nargs="+")
    p_s.set_defaults(func=cmd_seguir)

    args = ap.parse_args(argv)
    try:
        return args.func(args)
    except (InspeccionError, mod_estado.EstadoError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
