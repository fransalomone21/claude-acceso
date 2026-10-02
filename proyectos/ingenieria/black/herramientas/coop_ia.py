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


BASE2, FIN2 = 0x0046F000, 0x0046F100   # (110) reserva «IA: percepcion de J2» de coop-plan-b (docs/14)


def fuente2():
    """(110) PERC2, en lugar de `jal FUN_00184DE0` (la percepcion de un enemigo, 0x00184DB8).
    Medido en vivo: VER2/VIS2 no alcanzaban, porque (1) `FUN_0018FB88` solo anota un blanco cuyo bit de id este en la
    mascara de percepcion `agente+0x71C`, que `FUN_00184DE0` llena recorriendo las 4 ranuras del escuadron
    (`*(0x0040F4D4)+0x22864`, aliados 0-2 y J en la 3: J2 no esta), y (2) «ver» y «visibles» son nodos del arbol de
    comportamiento de BUSCAR: un enemigo que ya pelea con J no los corre. Entonces:
      antes:   escuadron+0x74 (la 5.a palabra, 0 en los 7 volcados) = J2 si FASE = 2, si no 0; y el lazo de la
               percepcion va hasta 5 (0x00185184: slti 4 -> 5). Las ranuras 0-2 NO se tocan: el juego rellena las
               vacias con aliados del guion al cambiar de unidad (FUN_00173028).
      despues: si FASE = 2, el enemigo percibe a J2, esta EN COMBATE (amenaza actual +0x270 != -1) y todavia no
               conoce a J2 -> FUN_001897e8(agente+0x150, id de J2, 0), lo mismo que hace «ver». (Primero se pidio
               «ya conoce a J»: medido en perc2-1, un enemigo que peleaba con el titere no anotaba a J2.)
               Sin combate, J2 entra como J: por «ver» (VER2), ahora que la percepcion lo ve."""
    return "\n".join([
        "PERC2:", "addiu sp, sp, -0x20", "sw ra, 0(sp)", "sw a0, 4(sp)",
        "lui t9, 0x47", "lw t8, -0x2870(t9)", "addiu t7, zero, 2",
        "lui t6, 0x41", "lw t6, -0xb2c(t6)", "lui t5, 0x2", "addu t6, t6, t5",
        "bne t8, t7, @PNOJ", "move t4, zero", "addiu t4, t9, -0x3210",
        "PNOJ:", "sw t4, 0x2874(t6)",
        "jal 0x184de0", "nop",
        "lui t9, 0x47", "lw t8, -0x2870(t9)", "addiu t7, zero, 2", "bne t8, t7, @PFIN", "nop",
        "addiu t1, t9, -0x3210", "lw a1, 0x380(t1)", "addiu t3, zero, 1", "sllv t3, t3, a1",
        "lw a0, 4(sp)", "lw t0, 0(a0)",
        "lw t1, 0x71c(t0)", "and t1, t1, t3", "beq t1, zero, @PFIN", "nop",
        "lw t2, 0x270(t0)", "addiu t4, zero, -1", "beq t2, t4, @PFIN", "nop",
        "lw t1, 0x274(t0)", "and t2, t1, t3", "bne t2, zero, @PFIN", "nop",
        "addiu a0, t0, 0x150", "jal 0x1897e8", "move a2, zero",
        "PFIN:", "lw ra, 0(sp)", "jr ra", "addiu sp, sp, 0x20"])


def programa2():
    return j2.ensamblar_programa(fuente2(), BASE2, FIN2)


def etiquetas(src, base=None):
    base = BASE if base is None else base
    pos, n = {}, 0
    for l in src.splitlines():
        if l.endswith(":"):
            pos[l[:-1]] = base + 4 * n
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
            (0x00184908, 0, "IA hostil: nop (era addiu v0,v0,0x30)"),
            (0x00184DB8, ensamblar("jal 0x%x" % BASE2, 0x00184DB8), "IA percepcion: jal PERC2 (era jal 0x184de0) (110)"),
            (0x00185184, ensamblar("slti v0, s3, 5", 0x00185184), "IA percepcion: el lazo del escuadron hasta 5 (era slti 4) (110)")]


ORIGINAL = {0x0018FC4C: "jal 0x0018FB88", 0x0019098C: "jal 0x001908A0", 0x0018A8BC: "jal 0x00189740",
            0x00184904: "lw v0, -2864(v1)", 0x00184908: "addiu v0, v0, 48",
            0x00184DB8: "jal 0x00184DE0", 0x00185184: "slti v0, s3, 4"}


def capstone_des(pc, w):
    from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS32, Cs
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS32 + CS_MODE_LITTLE_ENDIAN)
    r = list(md.disasm(struct.pack("<I", w), pc))
    return f"{r[0].mnemonic} {r[0].op_str}" if r else "(capstone no lo decodifica)"


def verificar(mostrar=False) -> int:
    from perfil_singleton import palabra_elf
    errores = []
    lineas = []
    for prog, base, fin in ((programa(), BASE, FIN), (programa2(), BASE2, FIN2)):   # (110) dos programas
        if prog[-1][0] + 4 > fin:
            errores.append(f"el codigo de {base:#x} pasa de la reserva")
        for pc, w, t in prog:
            c = capstone_des(pc, w)
            lineas.append(f"{pc:08X}  {w:08X}  {c:34s} ; {t}")
            if mostrar:
                print(lineas[-1])
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
                if not (base <= dest < prog[-1][0] + 4):
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
    # (109) el listado guardado es lo que se revisa en los documentos: si el codigo cambia y el
    # listado no, se revisaria un programa que ya no existe (REVISAR-98-108, B16)
    guardado = Path(__file__).resolve().parent.parent / "docs" / "listados" / "107-coop-ia.txt"
    if guardado.exists():
        g = [l.rstrip() for l in guardado.read_text(encoding="utf-8-sig").splitlines()][:len(lineas)]
        if g != [l.rstrip() for l in lineas]:
            n = next((i for i, (x, y) in enumerate(zip(g, lineas)) if x != y.rstrip()), min(len(g), len(lineas)))
            errores.append(f"docs/listados/107-coop-ia.txt no coincide con el codigo (primera diferencia en la linea {n + 1}):"
                           " regenerarlo con `coop_ia.py listado`")
    else:
        errores.append("falta docs/listados/107-coop-ia.txt")
    for e in errores:
        print("ROJO:", e)
    print(f"coop_ia: {len(programa()) + len(programa2())} palabras en [{BASE:#x}, {FIN:#x}) y [{BASE2:#x}, {FIN2:#x}),"
          f" {len(errores)} problema(s)")
    return 1 if errores else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["listado", "verificar"])
    a = ap.parse_args()
    return verificar(mostrar=a.cmd == "listado")


if __name__ == "__main__":
    sys.exit(main())
