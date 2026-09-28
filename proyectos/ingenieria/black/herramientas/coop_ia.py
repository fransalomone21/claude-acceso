#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""coop_ia.py -- (107) la IA de COOP-B: los enemigos atacan a los dos (decision de Fran, (106)).

Diseno: docs/16 «Clase B, la IA» + «Decisiones de Fran». NO SE INSTALA desde aca: arma el codigo en frio,
lo lista desensamblado con capstone y verifica los sitios contra el ELF. Pasa a coop_mod.py (y su fila de
coop-plan-b a coop-rangos) cuando la notebook lo pruebe.

    python herramientas/coop_ia.py listado      # el codigo, desensamblado, y los ganchos con lo que pisan
    python herramientas/coop_ia.py verificar    # sale 1 si algo no cierra (capstone, rango, ELF)

CUATRO SITIOS (P1 del diseno):
  VER       0x0018FC4C  jal FUN_0018FB88(agente, J)   -> VER2: lo llama con J y, con FASE = 2, con J2
  VISIBLES  0x0019098C  jal FUN_001908A0(agente, J)   -> VIS2: idem
  DEFECTO   0x0018A8BC  jal FUN_00189740(lista, J, 1) -> DEF2: con a1 = el mas cercano de J y J2 al agente
  HOSTIL    0x00184904  lw v0,-0xB30(v1); addiu v0,v0,0x30 (v0 = J, despues sw v0,0xC(s1))
                        -> jal HOST2; nop: v0 = el mas cercano de J y J2 al agente
CERCA(t0 = personaje) -> v0: J, o J2 si FASE = 2 y J2 esta mas cerca (distancia al cuadrado, +0xA0).
Etiquetas: ninguna puede ser prefijo de otra (ensamblar_programa reemplaza texto).
Solo usa t0-t2, t9 y f0-f5 (caller-saved): HOSTIL corre dentro de FUN_001848C0, que guarda f20 y s0/s1.
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jugador2 as j2  # noqa: E402
from mips import desensamblar, ensamblar  # noqa: E402

FASE = 0x0046D790          # coop_mod: FASE 2 = J2 armado
BASE, FIN = 0x0046E600, 0x0046E780   # reserva «IA: los dos (codigo)» de coop-plan-b (docs/14)

# FPU del R5900 (mips.py no la ensambla): codificacion estandar MIPS I, precision simple.
F = {"add.s": 0, "sub.s": 1, "mul.s": 2}
REG = {"t0": 8, "t1": 9, "v0": 2}


def fpu(t):
    """'lwc1 f1, 0xa4(t0)' | 'sub.s f3, f3, f0' | 'c.lt.s f5, f3' -> '.word 0x...'."""
    op, resto = t.split(None, 1)
    a = [x.strip() for x in resto.split(",")]
    if op == "lwc1":
        ft = int(a[0][1:]); off, base = a[1].rstrip(")").split("(")
        w = (0x31 << 26) | (REG[base] << 21) | (ft << 16) | (int(off, 0) & 0xFFFF)
    elif op in F:
        fd, fs, ft = (int(x[1:]) for x in a)
        w = 0x46000000 | (ft << 16) | (fs << 11) | (fd << 6) | F[op]
    elif op == "c.lt.s":
        fs, ft = (int(x[1:]) for x in a)
        w = 0x46000034 | (ft << 16) | (fs << 11)
    else:
        raise ValueError(t)
    return ".word 0x%08x" % w


def distancia(base_reg, fd):
    """f<fd> = |personaje(f0,f1,f2) - base_reg+0xA0|^2, usando f4."""
    return [f"lwc1 f{fd}, 0xa0({base_reg})", f"sub.s f{fd}, f{fd}, f0", f"mul.s f{fd}, f{fd}, f{fd}",
            f"lwc1 f4, 0xa4({base_reg})", "sub.s f4, f4, f1", "mul.s f4, f4, f4", f"add.s f{fd}, f{fd}, f4",
            f"lwc1 f4, 0xa8({base_reg})", "sub.s f4, f4, f2", "mul.s f4, f4, f4", f"add.s f{fd}, f{fd}, f4"]


def fuente():
    cerca = ["CERCA:", "lui t9, 0x41", "lw v0, -0xb30(t9)", "addiu v0, v0, 0x30",
             "lui t9, 0x47", "lw t1, -0x2870(t9)", "addiu t2, zero, 2", "bne t1, t2, @CFIN", "nop",
             "lwc1 f0, 0xa0(t0)", "lwc1 f1, 0xa4(t0)", "lwc1 f2, 0xa8(t0)"]
    cerca += distancia("v0", 3)
    cerca += ["addiu t1, t9, -0x3210"] + distancia("t1", 5)
    cerca += ["c.lt.s f5, f3", "nop",              # como el juego (0x00184988): una nop entre c.lt.s y bc1f
              ".word 0x45000002",                    # bc1f +2: si J2 NO esta mas cerca, a CFIN
              "nop", "move v0, t1", "CFIN:", "jr ra", "nop"]
    dos_veces = []
    for nombre, f in (("VER2", 0x0018FB88), ("VIS2", 0x001908A0)):
        dos_veces += [f"{nombre}:", "addiu sp, sp, -0x20", "sw ra, 0(sp)", "sw a0, 4(sp)",
                      "jal 0x%x" % f, "nop",
                      "lui t9, 0x47", "lw t8, -0x2870(t9)", "addiu t7, zero, 2", f"bne t8, t7, @FIN{nombre[:3]}", "nop",
                      "lw a0, 4(sp)", "jal 0x%x" % f, "addiu a1, t9, -0x3210",
                      f"FIN{nombre[:3]}:", "lw ra, 0(sp)", "jr ra", "addiu sp, sp, 0x20"]
    defecto = ["DEF2:", "addiu sp, sp, -0x20", "sw ra, 0(sp)", "sw a0, 4(sp)", "sw a2, 8(sp)",
               "lw t0, 0x130(a0)", "jal @CERCA", "lw t0, 0x7c(t0)",
               "move a1, v0", "lw a0, 4(sp)", "lw a2, 8(sp)", "lw ra, 0(sp)",
               "j 0x189740", "addiu sp, sp, 0x20"]
    hostil = ["HOST2:", "addiu sp, sp, -0x10", "sw ra, 0(sp)", "lw t0, 0(s1)",
              "jal @CERCA", "lw t0, 0x7c(t0)", "lw ra, 0(sp)", "jr ra", "addiu sp, sp, 0x10"]
    lineas = []
    for l in cerca + dos_veces + defecto + hostil:
        op = l.split()[0]
        lineas.append(fpu(l) if op in ("lwc1", "c.lt.s") or op in F else l)
    return "\n".join(lineas)


def etiquetas(src):
    pos, n = {}, 0
    for l in src.splitlines():
        if l.endswith(":"):
            pos[l[:-1]] = BASE + 4 * n
        else:
            n += 1
    return pos


def programa():
    return j2.ensamblar_programa(fuente(), BASE, FIN)


def ganchos():
    e = etiquetas(fuente())
    return [(0x0018FC4C, ensamblar("jal 0x%x" % e["VER2"], 0x0018FC4C), "IA ver: jal VER2 (era jal 0x18fb88)"),
            (0x0019098C, ensamblar("jal 0x%x" % e["VIS2"], 0x0019098C), "IA visibles: jal VIS2 (era jal 0x1908a0)"),
            (0x0018A8BC, ensamblar("jal 0x%x" % e["DEF2"], 0x0018A8BC), "IA defecto: jal DEF2 (era jal 0x189740)"),
            (0x00184904, ensamblar("jal 0x%x" % e["HOST2"], 0x00184904), "IA hostil: jal HOST2 (era lw v0,-0xB30(v1))"),
            (0x00184908, 0, "IA hostil: nop (era addiu v0,v0,0x30)")]


ORIGINAL = {0x0018FC4C: "jal 0x0018FB88", 0x0019098C: "jal 0x001908A0", 0x0018A8BC: "jal 0x00189740",
            0x00184904: "lw v0, -2864(v1)", 0x00184908: "addiu v0, v0, 48"}


def capstone_des(pc, w):
    from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS32, Cs
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS32 + CS_MODE_LITTLE_ENDIAN)
    r = list(md.disasm(struct.pack("<I", w), pc))
    return f"{r[0].mnemonic} {r[0].op_str}" if r else "(capstone no lo decodifica)"


def verificar(mostrar=False) -> int:
    from perfil_singleton import palabra_elf
    errores = []
    prog = programa()
    if prog[-1][0] + 4 > FIN:
        errores.append("el codigo pasa de la reserva")
    for pc, w, t in prog:
        c = capstone_des(pc, w)
        if mostrar:
            print(f"{pc:08X}  {w:08X}  {c:34s} ; {t}")
        if c.startswith("(capstone"):
            errores.append(f"{pc:#x} {t}: capstone no lo decodifica")
        if t.startswith(".word") and t.split()[1].lower() != "0x%08x" % w:
            errores.append(f"{pc:#x}: palabra literal cambiada")
    # saltos condicionales: dentro del codigo (en (107) un choque de etiquetas, @VER2 dentro de @VER2F,
    # mandaba un bne a 0x466A4C)
    for pc, w, t in prog:
        op = w >> 26
        if op in (4, 5) or (w >> 16) in (0x4500, 0x4501):
            off = struct.unpack("<h", struct.pack("<H", w & 0xFFFF))[0]
            dest = pc + 4 + 4 * off
            if not (BASE <= dest < prog[-1][0] + 4):
                errores.append(f"{pc:#x} {t}: salta a {dest:#x}, fuera del codigo")
    # FPU: la codificacion propia tiene que decir lo mismo que las del juego
    for pc, esperado in ((0x00184988, "c.olt.s $f0, $f20"), (0x00184990, "bc1f 0x1849a8")):
        c = capstone_des(pc, palabra_elf(pc))
        if c != esperado:
            errores.append(f"control FPU {pc:#x}: capstone dice '{c}', se esperaba '{esperado}'")
    if fpu("c.lt.s f0, f20") != ".word 0x46140034":
        errores.append("la codificacion propia de c.lt.s no reproduce la del juego (0x46140034)")
    if mostrar:
        print("\nganchos:")
    for pc, w, t in ganchos():
        real = desensamblar(palabra_elf(pc), pc)
        if " ".join(real.split()) != ORIGINAL[pc]:
            errores.append(f"gancho {pc:#x}: el ELF tiene '{real}', se esperaba '{ORIGINAL[pc]}'")
        if mostrar:
            print(f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}  [pisa: {real}]")
    for e in errores:
        print("ROJO:", e)
    print(f"coop_ia: {len(prog)} palabras en [{BASE:#x}, {prog[-1][0] + 4:#x}), {len(errores)} problema(s)")
    return 1 if errores else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["listado", "verificar"])
    a = ap.parse_args()
    return verificar(mostrar=a.cmd == "listado")


if __name__ == "__main__":
    sys.exit(main())
