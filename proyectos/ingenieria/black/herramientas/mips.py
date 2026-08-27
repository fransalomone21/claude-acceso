#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mips.py — ensamblador y desensamblador mínimo de MIPS R5900 (el EE de la PS2).

PARA QUÉ
    Muchas modificaciones no se hacen tocando un dato, se hacen tocando el
    código. Ejemplos reales:
      · "vida infinita"  -> anular (nop) la instrucción que guarda la vida nueva
      · "vida máxima X"  -> cambiar el inmediato de un `addiu v0, zero, 100`
      · "daño x0.5"      -> insertar un shift antes de la resta
    Para eso hay que leer y escribir opcodes a mano. Este módulo cubre el
    subconjunto de instrucciones que aparece en ese tipo de parches.

    NO pretende reemplazar a Ghidra. Ghidra entiende el programa; esto
    codifica y decodifica instrucciones sueltas con precisión.

CLI
    python3 mips.py des 0x00101234 0x24020064      # desensambla una palabra
    python3 mips.py des-bloque volcado.bin --base 0x100000 -n 40
    python3 mips.py ens "addiu v0, zero, 500"      # -> palabra hexadecimal
    python3 mips.py nop                            # -> 0x00000000
"""

from __future__ import annotations

import argparse
import re
import struct
import sys

REGISTROS = [
    "zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
    "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
    "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
    "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra",
]
NUM_REG = {n: i for i, n in enumerate(REGISTROS)}
NUM_REG.update({f"r{i}": i for i in range(32)})
NUM_REG["s8"] = 30  # fp también se llama s8

# opcode principal (bits 31..26) -> (mnemónico, formato)
#   I = rt, rs, imm      IB = rs, rt, offset (branch)     J = target
#   M = rt, offset(rs)   (memoria)
OPCODES_I = {
    0x04: ("beq", "IB"), 0x05: ("bne", "IB"),
    0x06: ("blez", "IZ"), 0x07: ("bgtz", "IZ"),
    0x08: ("addi", "I"), 0x09: ("addiu", "I"),
    0x0A: ("slti", "I"), 0x0B: ("sltiu", "I"),
    0x0C: ("andi", "IU"), 0x0D: ("ori", "IU"), 0x0E: ("xori", "IU"),
    0x0F: ("lui", "IL"),
    0x14: ("beql", "IB"), 0x15: ("bnel", "IB"),
    0x16: ("blezl", "IZ"), 0x17: ("bgtzl", "IZ"),
    0x19: ("daddiu", "I"),
    0x20: ("lb", "M"), 0x21: ("lh", "M"), 0x23: ("lw", "M"),
    0x24: ("lbu", "M"), 0x25: ("lhu", "M"), 0x27: ("lwu", "M"),
    0x28: ("sb", "M"), 0x29: ("sh", "M"), 0x2B: ("sw", "M"),
    0x37: ("ld", "M"), 0x3F: ("sd", "M"),
    0x31: ("lwc1", "M"), 0x39: ("swc1", "M"),
    0x1E: ("lq", "M"), 0x1F: ("sq", "M"),
}
OPCODES_J = {0x02: "j", 0x03: "jal"}

# función (bits 5..0) cuando opcode == 0 -> (mnemónico, formato)
#   R = rd, rs, rt     RS = rd, rt, sa    JR = rs     RD = rd     MD = rs, rt
FUNCIONES_R = {
    0x00: ("sll", "RS"), 0x02: ("srl", "RS"), 0x03: ("sra", "RS"),
    0x04: ("sllv", "RV"), 0x06: ("srlv", "RV"), 0x07: ("srav", "RV"),
    0x08: ("jr", "JR"), 0x09: ("jalr", "JALR"),
    0x0C: ("syscall", "N"), 0x0D: ("break", "N"),
    0x10: ("mfhi", "RD"), 0x11: ("mthi", "JR"),
    0x12: ("mflo", "RD"), 0x13: ("mtlo", "JR"),
    0x18: ("mult", "R"), 0x19: ("multu", "R"),
    0x1A: ("div", "MD"), 0x1B: ("divu", "MD"),
    0x20: ("add", "R"), 0x21: ("addu", "R"),
    0x22: ("sub", "R"), 0x23: ("subu", "R"),
    0x24: ("and", "R"), 0x25: ("or", "R"),
    0x26: ("xor", "R"), 0x27: ("nor", "R"),
    0x2A: ("slt", "R"), 0x2B: ("sltu", "R"),
    0x2D: ("daddu", "R"), 0x2F: ("dsubu", "R"),
    0x38: ("dsll", "RS"), 0x3A: ("dsrl", "RS"), 0x3B: ("dsra", "RS"),
}
# rt (bits 20..16) cuando opcode == 1 (REGIMM)
REGIMM = {0x00: "bltz", 0x01: "bgez", 0x10: "bltzal", 0x11: "bgezal",
          0x02: "bltzl", 0x03: "bgezl"}

NOP = 0x0000_0000


def _r(n: int) -> str:
    return REGISTROS[n]


def _s16(v: int) -> int:
    return v - 0x10000 if v & 0x8000 else v


def desensamblar(palabra: int, direccion: int = 0) -> str:
    """Una palabra de 32 bits -> texto. Devuelve '.word 0x...' si no la conoce."""
    palabra &= 0xFFFF_FFFF
    if palabra == NOP:
        return "nop"

    op = (palabra >> 26) & 0x3F
    rs = (palabra >> 21) & 0x1F
    rt = (palabra >> 16) & 0x1F
    rd = (palabra >> 11) & 0x1F
    sa = (palabra >> 6) & 0x1F
    fn = palabra & 0x3F
    imm = palabra & 0xFFFF
    simm = _s16(imm)

    if op == 0x00:
        if fn not in FUNCIONES_R:
            return f".word 0x{palabra:08X}"
        nombre, fmt = FUNCIONES_R[fn]
        if nombre == "or" and rt == 0:
            return f"move {_r(rd)}, {_r(rs)}"
        if nombre == "addu" and rt == 0:
            return f"move {_r(rd)}, {_r(rs)}"
        return {
            "R": lambda: f"{nombre} {_r(rd)}, {_r(rs)}, {_r(rt)}",
            "RS": lambda: f"{nombre} {_r(rd)}, {_r(rt)}, {sa}",
            "RV": lambda: f"{nombre} {_r(rd)}, {_r(rt)}, {_r(rs)}",
            "JR": lambda: f"{nombre} {_r(rs)}",
            "JALR": lambda: (f"jalr {_r(rs)}" if rd == 31 else f"jalr {_r(rd)}, {_r(rs)}"),
            "RD": lambda: f"{nombre} {_r(rd)}",
            "MD": lambda: f"{nombre} {_r(rs)}, {_r(rt)}",
            "N": lambda: nombre,
        }[fmt]()

    if op == 0x01:
        nombre = REGIMM.get(rt, f"regimm_{rt:02X}")
        return f"{nombre} {_r(rs)}, 0x{direccion + 4 + simm * 4:08X}"

    if op in OPCODES_J:
        destino = (direccion & 0xF000_0000) | ((palabra & 0x03FF_FFFF) << 2)
        return f"{OPCODES_J[op]} 0x{destino:08X}"

    if op == 0x11:  # COP1 (FPU): lo dejamos crudo, no es lo que parcheamos
        return f"cop1 0x{palabra:08X}"

    if op in OPCODES_I:
        nombre, fmt = OPCODES_I[op]
        if nombre == "beq" and rs == 0 and rt == 0:
            return f"b 0x{direccion + 4 + simm * 4:08X}"
        if nombre == "addiu" and rs == 0:
            return f"li {_r(rt)}, {simm}"
        return {
            "I": lambda: f"{nombre} {_r(rt)}, {_r(rs)}, {simm}",
            "IU": lambda: f"{nombre} {_r(rt)}, {_r(rs)}, 0x{imm:X}",
            "IL": lambda: f"{nombre} {_r(rt)}, 0x{imm:X}",
            "IB": lambda: f"{nombre} {_r(rs)}, {_r(rt)}, 0x{direccion + 4 + simm * 4:08X}",
            "IZ": lambda: f"{nombre} {_r(rs)}, 0x{direccion + 4 + simm * 4:08X}",
            "M": lambda: f"{nombre} {_r(rt)}, {simm}({_r(rs)})",
        }[fmt]()

    return f".word 0x{palabra:08X}"


# --- ensamblador --------------------------------------------------------------
class MipsError(ValueError):
    pass


def _reg(texto: str) -> int:
    t = texto.strip().lstrip("$").lower()
    if t not in NUM_REG:
        raise MipsError(f"registro desconocido: {texto}")
    return NUM_REG[t]


def _imm(texto: str) -> int:
    return int(texto.strip(), 0)


_RE_MEM = re.compile(r"^\s*(-?[\w.]+)\s*\(\s*\$?(\w+)\s*\)\s*$")

_INV_I = {n: (op, f) for op, (n, f) in OPCODES_I.items()}
_INV_R = {n: (fn, f) for fn, (n, f) in FUNCIONES_R.items()}


def ensamblar(texto: str, direccion: int = 0) -> int:
    """Una línea de assembly -> palabra de 32 bits."""
    texto = texto.split("#")[0].split(";")[0].strip()
    if not texto:
        raise MipsError("línea vacía")
    partes = texto.replace(",", " ").split()
    mnem = partes[0].lower()
    ops = partes[1:]

    if mnem == "nop":
        return NOP
    if mnem == "move" and len(ops) == 2:  # move rd, rs  ==  addu rd, rs, zero
        return (0 << 26) | (_reg(ops[1]) << 21) | (0 << 16) | (_reg(ops[0]) << 11) | 0x21
    if mnem == "li" and len(ops) == 2:
        v = _imm(ops[1])
        if not (-0x8000 <= v <= 0xFFFF):
            raise MipsError(
                f"li {v} no entra en 16 bits. Usá dos instrucciones: "
                f"lui + ori (mirá `python3 mips.py li32`)"
            )
        return (0x09 << 26) | (0 << 21) | (_reg(ops[0]) << 16) | (v & 0xFFFF)
    if mnem == "b" and len(ops) == 1:  # b destino == beq zero, zero, destino
        off = (_imm(ops[0]) - direccion - 4) // 4
        return (0x04 << 26) | (off & 0xFFFF)

    if mnem in _INV_R:
        fn, fmt = _INV_R[mnem]
        rs = rt = rd = sa = 0
        if fmt == "R":
            rd, rs, rt = _reg(ops[0]), _reg(ops[1]), _reg(ops[2])
        elif fmt == "RS":
            rd, rt, sa = _reg(ops[0]), _reg(ops[1]), _imm(ops[2]) & 0x1F
        elif fmt == "RV":
            rd, rt, rs = _reg(ops[0]), _reg(ops[1]), _reg(ops[2])
        elif fmt == "JR":
            rs = _reg(ops[0])
        elif fmt == "JALR":
            if len(ops) == 1:
                rs, rd = _reg(ops[0]), 31
            else:
                rd, rs = _reg(ops[0]), _reg(ops[1])
        elif fmt == "RD":
            rd = _reg(ops[0])
        elif fmt == "MD":
            rs, rt = _reg(ops[0]), _reg(ops[1])
        elif fmt == "N":
            pass
        return (rs << 21) | (rt << 16) | (rd << 11) | (sa << 6) | fn

    if mnem in _INV_I:
        op, fmt = _INV_I[mnem]
        if fmt in ("I", "IU"):
            rt, rs, imm = _reg(ops[0]), _reg(ops[1]), _imm(ops[2])
        elif fmt == "IL":
            rt, rs, imm = _reg(ops[0]), 0, _imm(ops[1])
        elif fmt == "IB":
            rs, rt = _reg(ops[0]), _reg(ops[1])
            imm = (_imm(ops[2]) - direccion - 4) // 4
        elif fmt == "IZ":
            rs, rt = _reg(ops[0]), 0
            imm = (_imm(ops[1]) - direccion - 4) // 4
        elif fmt == "M":
            m = _RE_MEM.match(" ".join(ops[1:]))
            if not m:
                raise MipsError(f"esperaba desplazamiento(registro) en: {texto}")
            rt, imm, rs = _reg(ops[0]), _imm(m.group(1)), _reg(m.group(2))
        else:
            raise MipsError(f"formato no soportado para {mnem}")
        return (op << 26) | (rs << 21) | (rt << 16) | (imm & 0xFFFF)

    if mnem in ("j", "jal"):
        op = 0x02 if mnem == "j" else 0x03
        destino = _imm(ops[0])
        if destino & 0xF000_0000 != direccion & 0xF000_0000:
            raise MipsError(
                f"{mnem} no puede saltar de 0x{direccion:08X} a 0x{destino:08X}: "
                "cambia la región de 256 MB. Usá lui/ori + jr."
            )
        return (op << 26) | ((destino >> 2) & 0x03FF_FFFF)

    raise MipsError(f"no sé ensamblar '{mnem}'")


def li32(registro: str, valor: int) -> list[tuple[str, int]]:
    """Carga un inmediato de 32 bits: siempre son dos instrucciones."""
    alto = (valor >> 16) & 0xFFFF
    bajo = valor & 0xFFFF
    if bajo & 0x8000:  # ori no extiende signo, pero addiu sí; usamos ori
        pass
    salida = [(f"lui {registro}, 0x{alto:X}", ensamblar(f"lui {registro}, 0x{alto:X}"))]
    if bajo:
        salida.append(
            (f"ori {registro}, {registro}, 0x{bajo:X}",
             ensamblar(f"ori {registro}, {registro}, 0x{bajo:X}"))
        )
    return salida


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Ensamblador/desensamblador R5900")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_d = sub.add_parser("des", help="desensambla una palabra")
    p_d.add_argument("direccion", type=lambda t: int(t, 0))
    p_d.add_argument("palabra", type=lambda t: int(t, 0))

    p_db = sub.add_parser("des-bloque", help="desensambla un archivo binario")
    p_db.add_argument("archivo")
    p_db.add_argument("--base", type=lambda t: int(t, 0), default=0)
    p_db.add_argument("--offset", type=lambda t: int(t, 0), default=0)
    p_db.add_argument("-n", type=int, default=32)

    p_e = sub.add_parser("ens", help="ensambla una instrucción")
    p_e.add_argument("texto")
    p_e.add_argument("--direccion", type=lambda t: int(t, 0), default=0)

    p_l = sub.add_parser("li32", help="secuencia lui/ori para un valor de 32 bits")
    p_l.add_argument("registro")
    p_l.add_argument("valor", type=lambda t: int(t, 0))

    sub.add_parser("nop", help="la palabra de un nop")

    args = ap.parse_args(argv)
    try:
        if args.cmd == "des":
            print(f"0x{args.direccion:08X}  {args.palabra:08X}  "
                  f"{desensamblar(args.palabra, args.direccion)}")
        elif args.cmd == "des-bloque":
            with open(args.archivo, "rb") as f:
                f.seek(args.offset)
                datos = f.read(args.n * 4)
            for i in range(0, len(datos) - 3, 4):
                d = args.base + args.offset + i
                w = struct.unpack_from("<I", datos, i)[0]
                print(f"0x{d:08X}  {w:08X}  {desensamblar(w, d)}")
        elif args.cmd == "ens":
            w = ensamblar(args.texto, args.direccion)
            print(f"0x{w:08X}   ; {desensamblar(w, args.direccion)}")
        elif args.cmd == "li32":
            for texto, w in li32(args.registro, args.valor):
                print(f"0x{w:08X}   ; {texto}")
        elif args.cmd == "nop":
            print("0x00000000")
    except MipsError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
