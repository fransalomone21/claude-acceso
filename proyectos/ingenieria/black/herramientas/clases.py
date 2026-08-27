#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
clases.py — encontrar clases de entidad y sus objetos en un volcado del EE.

PARA QUÉ
    BLACK es C++: cada entidad (jugador, enemigo, objeto destructible) es un
    objeto con puntero a su vtable. Si dos objetos comparten vtable, son de
    la misma clase. Eso convierte "encontrar los enemigos" —que por escaneo
    diferencial de valores no cerraba, porque el enemigo muere antes de que
    el filtro converja— en una búsqueda exacta y de una sola pasada.

    Y hay algo más fuerte todavía: el índice de un método virtual se conserva
    entre clases hermanas. En BLACK el método #8 (`vtable+0x4C`) es "recibir
    daño". Con eso, la rutina de daño de una clase nueva no se busca: se lee.

EL DETALLE QUE HAY QUE SABER
    **El puntero a la vtable NO está en el primer u32 del objeto.** En +0x00
    hay cero. Está en **+0x10**. Esa premisa equivocada costó dos sesiones:
    la ficha del jugador llegó a anotar "el primer u32 no parece un puntero a
    vtable", que era cierto e inútil, porque nadie miró +0x10.

    Layout de la vtable: tres palabras en cero, y después punteros a función
    cada 8 bytes desde +0x0C (los 4 bytes del medio son cero, probable offset
    de thunk). Así que el método n vive en 0x0C + 8*n.

CÓMO SE CONSIGUE EL VOLCADO
    python3 herramientas/estado.py extraer <savestate.p2s> volcados/ee.bin

    O en vivo, con PCSX2 corriendo:
    python3 herramientas/pine.py volcar 0x0 0x2000000 volcados/ee.bin

COMANDOS
    vtables    lista las vtables que hay en la región de datos
    objetos    enumera los objetos de una clase dada
    metodo     desensambla el método virtual n de una clase
    dano       censo: qué clases escriben en vida+0x2F8 (necesita capstone)

EJEMPLO — cómo se encontró la clase del enemigo
    python3 herramientas/clases.py dano volcados/ee-06.bin
    python3 herramientas/clases.py objetos volcados/ee-06.bin 0x003DCA78
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from salida import tolerar_salida_pobre  # noqa: E402

# Límites del ELF de BLACK NTSC-U (SLUS-21376, CRC 5C891FF1).
# Salen del único PT_LOAD: offset_archivo = vaddr - 0xFF000.
TEXT_INI, TEXT_FIN = 0x00100000, 0x00396F48
DATOS_INI, DATOS_FIN = 0x003BC330, 0x0040E580

OFF_VTABLE = 0x10       # dónde vive el puntero de clase DENTRO del objeto
OFF_METODO0 = 0x0C      # primer puntero a función DENTRO de la vtable
PASO_METODO = 8
METODO_DANO = 8         # "recibir daño" — vtable+0x4C
OFF_VIDA = 0x2F8
OFF_ESTADO = 0xC4


class ClasesError(RuntimeError):
    pass


def _u32(ee: bytes, a: int) -> int:
    if a < 0 or a + 4 > len(ee):
        raise ClasesError(f"dirección 0x{a:08X} fuera del volcado")
    return struct.unpack_from("<I", ee, a)[0]


def _f32(ee: bytes, a: int) -> float:
    return struct.unpack_from("<f", ee, a)[0]


def _es_funcion(v: int) -> bool:
    return TEXT_INI <= v < TEXT_FIN


def cargar(ruta: str) -> bytes:
    d = Path(ruta).read_bytes()
    if len(d) < 0x02000000:
        print(f"  ojo: el volcado tiene {len(d):,} bytes; se esperaban 32 MB de RAM del EE")
    return d


def metodos_de(ee: bytes, vtable: int, tope: int = 60) -> list[int]:
    """Punteros a función de una vtable, en orden. [] si no parece una."""
    try:
        if _u32(ee, vtable) or _u32(ee, vtable + 4) or _u32(ee, vtable + 8):
            return []
    except ClasesError:
        return []
    fns = []
    for k in range(tope):
        try:
            v = _u32(ee, vtable + OFF_METODO0 + PASO_METODO * k)
        except ClasesError:
            break
        if not _es_funcion(v):
            break
        fns.append(v)
    return fns


def buscar_vtables(ee: bytes, minimo: int = 6) -> list[tuple[int, list[int]]]:
    """Recorre la región de datos buscando el layout de vtable."""
    out = []
    a = DATOS_INI
    while a < DATOS_FIN:
        fns = metodos_de(ee, a)
        if len(fns) >= minimo:
            out.append((a, fns))
            a += OFF_METODO0 + PASO_METODO * len(fns)
        else:
            a += 4
    return out


def objetos_de(ee: bytes, vtable: int, desde: int = 0x00400000) -> list[int]:
    """Bases de todos los objetos cuyo +0x10 apunta a esta vtable."""
    pat = struct.pack("<I", vtable)
    bases, i = [], desde
    while True:
        i = ee.find(pat, i)
        if i < 0:
            break
        if i % 4 == 0:
            bases.append(i - OFF_VTABLE)
        i += 4
    return bases


def _capstone():
    try:
        from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS64, Cs
    except ImportError:
        raise ClasesError(
            "hace falta capstone:  pip install capstone\n"
            "mips.py no sirve acá: no decodifica instrucciones de FPU."
        )
    # MIPS64 + skipdata, NO MIPS32: el R5900 tiene instrucciones propias (sq/lq)
    # y en MIPS32 capstone se corta en la primera y devuelve CERO instrucciones
    # sin avisar. Un desensamblado vacío parece un resultado y es un bug.
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
    md.skipdata = True
    return md


def escribe_en(ee: bytes, fn: int, offset: int, tope: int = 800) -> int:
    """Cuántas veces la función guarda en <algo>+offset. Corta en `jr ra`."""
    if not _es_funcion(fn):
        return 0
    md = _capstone()
    aguja = f"0x{offset:x}("
    n = 0
    for ins in md.disasm(ee[fn:fn + 4 * tope], fn):
        if ins.mnemonic in ("sw", "swc1") and aguja in ins.op_str.replace(" ", ""):
            n += 1
        if ins.mnemonic == "jr" and "ra" in ins.op_str:
            break
    return n


def cmd_vtables(args) -> int:
    ee = cargar(args.volcado)
    vts = buscar_vtables(ee, args.minimo)
    print(f"  {len(vts)} vtables con >= {args.minimo} métodos en 0x{DATOS_INI:08X}-0x{DATOS_FIN:08X}")
    print()
    print(f"  {'vtable':<12} {'métodos':<9} {'objetos':<9} método #{METODO_DANO}")
    for vt, fns in vts[: args.max]:
        n = len(objetos_de(ee, vt))
        m = fns[METODO_DANO] if len(fns) > METODO_DANO else 0
        print(f"  0x{vt:08X}   {len(fns):<9} {n:<9} 0x{m:08X}")
    return 0


def cmd_objetos(args) -> int:
    ee = cargar(args.volcado)
    vt = int(args.vtable, 0)
    bases = objetos_de(ee, vt)
    print(f"  clase 0x{vt:08X}: {len(bases)} objetos")
    if not bases:
        print("  ninguno. ¿Seguro que es una vtable? Probá `clases.py vtables`.")
        return 1
    pasos = {bases[i + 1] - bases[i] for i in range(len(bases) - 1)}
    if len(pasos) == 1:
        print(f"  contiguos, paso 0x{pasos.pop():X} -> es un POOL preasignado")
    print()
    print(f"  {'base':<12} {'vida (+0x2F8)':<16} estado (+0xC4)")
    for b in bases[: args.max]:
        try:
            v = _f32(ee, b + OFF_VIDA)
            e = _u32(ee, b + OFF_ESTADO)
        except ClasesError:
            continue
        txt = "FLT_MAX" if v > 3.4e38 else f"{v:.2f}"
        print(f"  0x{b:08X}   {txt:<16} {e}")
    return 0


def cmd_metodo(args) -> int:
    ee = cargar(args.volcado)
    vt = int(args.vtable, 0)
    fns = metodos_de(ee, vt)
    if len(fns) <= args.n:
        print(f"  la vtable 0x{vt:08X} tiene {len(fns)} métodos; no hay #{args.n}")
        return 1
    fn = fns[args.n]
    print(f"  clase 0x{vt:08X}, método virtual #{args.n} (vtable+0x{OFF_METODO0 + PASO_METODO * args.n:X}) = 0x{fn:08X}")
    print()
    md = _capstone()
    for ins in md.disasm(ee[fn:fn + 4 * args.max], fn):
        marca = "   <== escribe la vida" if f"0x{OFF_VIDA:x}(" in ins.op_str.replace(" ", "") else ""
        print(f"  0x{ins.address:08X}  {ins.mnemonic:<10} {ins.op_str}{marca}")
        if ins.mnemonic == "jr" and "ra" in ins.op_str:
            break
    return 0


def cmd_dano(args) -> int:
    """El censo que resolvió la Fase 3: qué clases escriben en vida+0x2F8."""
    ee = cargar(args.volcado)
    vts = buscar_vtables(ee)
    print(f"  {len(vts)} vtables. Desensamblando el método #{METODO_DANO} de cada una...")
    print()
    hallados = []
    for vt, fns in vts:
        if len(fns) <= METODO_DANO:
            continue
        fn = fns[METODO_DANO]
        n = escribe_en(ee, fn, OFF_VIDA)
        if n:
            hallados.append((vt, fn, n))
    if not hallados:
        print("  ninguna clase escribe en vida+0x2F8. Revisá el volcado.")
        return 1
    print(f"  {'clase':<12} {'método #8':<12} {'stores':<8} objetos y vidas")
    for vt, fn, n in hallados:
        bases = objetos_de(ee, vt)
        vivos = [_f32(ee, b + OFF_VIDA) for b in bases if b + OFF_VIDA + 4 <= len(ee)]
        resumen = {}
        for v in vivos:
            k = "FLT_MAX" if v > 3.4e38 else round(v, 1)
            resumen[k] = resumen.get(k, 0) + 1
        print(f"  0x{vt:08X}   0x{fn:08X}    {n:<8} {len(bases)} obj  {resumen}")
    print()
    print("  Cada una de estas clases es una entidad que recibe daño.")
    print("  Los stores son los puntos de parche: uno es el daño normal y otro el clamp de muerte.")
    return 0


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Clases de entidad y sus objetos en un volcado del EE",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="El puntero de clase está en objeto+0x10, NO en +0x00.",
    )
    sub = p.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("vtables", help="lista las vtables de la región de datos")
    a.add_argument("volcado")
    a.add_argument("--minimo", type=int, default=6, help="métodos mínimos para considerarla vtable")
    a.add_argument("--max", type=int, default=60)
    a.set_defaults(func=cmd_vtables)

    b = sub.add_parser("objetos", help="enumera los objetos de una clase")
    b.add_argument("volcado")
    b.add_argument("vtable")
    b.add_argument("--max", type=int, default=64)
    b.set_defaults(func=cmd_objetos)

    c = sub.add_parser("metodo", help="desensambla el método virtual n de una clase")
    c.add_argument("volcado")
    c.add_argument("vtable")
    c.add_argument("n", type=int)
    c.add_argument("--max", type=int, default=200)
    c.set_defaults(func=cmd_metodo)

    d = sub.add_parser("dano", help="censo de clases que escriben en vida+0x2F8")
    d.add_argument("volcado")
    d.set_defaults(func=cmd_dano)

    args = p.parse_args(argv)
    try:
        return args.func(args)
    except ClasesError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
