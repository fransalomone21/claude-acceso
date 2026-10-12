#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""coop_pausa.py -- COOP-C, R4 de F7b: la PAUSA carga su menu en un MONTON PROPIO (el 22) y no toca el doble bufer de
armas (docs/16 (128); el porque, docs/16 (126)/(127) y N27 en sesiones/PREDICCIONES-128.md).

    python herramientas/coop_pausa.py listado      # el codigo, desensamblado, en lo que se apoya y lo derivado del ELF
    python herramientas/coop_pausa.py verificar    # sale 1 si algo no cierra (capstone, saltos, relaciones, ELF)

EL PROBLEMA: el menu de pausa (FUN_0020AEA0) vacia el bufer «otro» del doble bufer de armas (FUN_001438C8 -> estado 9)
y le lee PseMenu.bin encima (FUN_00143F90 -> FUN_001093C0 con el monton del «otro»). En un jugador el «otro» es el arma
que nadie dibuja; con dos jugadores y armas distintas es el arma en la mano del companero: con la 2d traba la pausa
(126) y con el pnach por defecto tira el juego al cambiar J2 de arma despues (N27, 2 de 2 con control, (128)).

EL DISENO (dos ganchos en FUN_0020AEA0, dos rutinas):
  R4A en 0x0020AEF4 (era `jal FUN_001438C8`): si la entrada 22 del gestor de montones esta ACTIVA (su byte +0, que pone
      FUN_00274E68), devuelve 1 sin vaciar nada. Si no, y no fallo antes: p = malloc(TAM + 0x7FF); con p,
      FUN_00107A08(entrada 22, alineado(p), -1, TAM) y devuelve 1; sin p, marca la falla y salta a FUN_001438C8 con su
      a0 (el camino original). La fuente de verdad es el `activo` del juego: si el juego se reinicia, vuelve a pedir.
  R4B en 0x0020AF84 (era `jal FUN_00143F90`): con la entrada 22 activa, FUN_001093C0(*(0x0040F4C4), a1, 6, 22, a2, a3,
      t0, 0x2000000) -- los registros exactos de FUN_00143F90, con el monton 22 en vez de *(otro+0). Si no, salta a
      FUN_00143F90 sin tocar nada.
La salida de la pausa (FUN_0020AFF8 -> FUN_001438E8) no se toca: solo resetea un «otro» en estado 9, y con R4 la pausa
no lo deja en 9. Los DATOS (p, falla, testigos) no van en el pnach: PCSX2 lo reescribe cada cuadro.
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jugador2 as j2  # noqa: E402
from mips import desensamblar, ensamblar  # noqa: E402

BASE, FIN = 0x0046F200, 0x0046F300          # reserva «pausa propia (codigo)» de coop-plan-b (docs/14)
DATOS, DATOS_FIN = 0x0046F1C0, 0x0046F1D0   # reserva «pausa propia (datos)»: en cero en los 16 volcados
P_CRUDO, FALLO, ALTAS, CARGAS = DATOS, DATOS + 4, DATOS + 8, DATOS + 0xC
BASE_DATOS = 0x00470000                      # t8: los datos se direccionan como t8 - k (16 bits con signo)

GESTOR = 0x0040F0F0                          # el gestor de montones (FUN_00125208(0x40f0f0), FUN_00107B18(0x40f0f0, ..))
MONTON = 22                                  # entrada sin inicializar y sin lector (docs/16 (127) (b), (128))
CARGADOR = 0x0040F4C4                        # *(0x0040F4C4): el cargador (lw a0, -0xb3c(v0) en FUN_00143F90)
PSEMENU = 215400                             # Export/FrontEnd/PseMenu.bin, medido en el ISO (127)
SECTOR = 0x800                               # el cargador reserva el archivo redondeado a 0x800 (FUN_00108F28)
TAM = 0x35800                                # el monton: lo que reserva el menu (0x35000) + un sector de margen
ALINEA = 0x800                               # como el bloque de montones del juego (+0x7FF & ~0x7FF, 0x0012.c)

MALLOC = 0x0035E7D8                          # FUN_0035E7D8(n): malloc con candado; devuelve 0 si no hay
ARMAR = 0x00107A08                           # FUN_00107A08(entrada, inicio, -1, tamanio): da de alta un monton
VACIAR_OTRO = 0x001438C8                     # FUN_001438C8(dbuf): el «otro» con clave 0 (estado 9)
CARGAR_MENU = 0x00143F90                     # FUN_00143F90(dbuf, ruta, cb, id, soltar): lo pide en el monton del «otro»
PEDIR = 0x001093C0                           # FUN_001093C0(cargador, ruta, ranura, monton, cb, id, soltar, banderas)
SITIO_A, SITIO_B = 0x0020AEF4, 0x0020AF84    # los dos jal de FUN_0020AEA0 (estado 1 de la pausa)

# lo que el diseno supone del ELF, texto exacto (perfil_singleton.palabra_elf + mips.desensamblar)
APOYO = {
    SITIO_A: "jal 0x001438C8", 0x0020AEF8: "lw a0, -2752(v0)",           # a0 = *(0x0040F540), el doble bufer
    0x0020AF78: "lui a2, 0x21", 0x0020AF7C: "addiu a2, a2, -21816",      # a2 = 0x0020AAC8, el callback del menu
    0x0020AF80: "li a3, 12", SITIO_B: "jal 0x00143F90", 0x0020AF88: "li t0, 1",
    # FUN_00143F90: como arma los argumentos de FUN_001093C0 (R4B los copia, con el monton 22)
    0x00143F94: "daddu t1, a3, zero", 0x00143FAC: "daddu t2, t0, zero", 0x00143FB4: "lw a3, 0(a0)",
    0x00143FB8: "daddu t0, a2, zero", 0x00143FBC: "lw a0, -2876(v0)", 0x00143FC0: "li a2, 6",
    0x00143FC4: "jal 0x001093C0", 0x00143FC8: "lui t3, 0x200",
    # FUN_00107A08 -> FUN_00274E68: el alta, y el byte `activo` en +0 (lo que R4A y R4B leen)
    0x00107A18: "sw a2, 28(v0)", 0x00107A20: "jal 0x00274E68", 0x00107A24: "sw v1, 32(v0)",
    0x00274E90: "li v0, 1", 0x00274E98: "sb v0, 0(s0)",
    # FUN_00107BC0 recorre los montones: cuantos y de que paso (de ahi sale la entrada 22)
    0x00107BF8: "slti v0, s1, 26", 0x00107C00: "addiu s0, s0, 36",
    # FUN_001438E8 (la salida de la pausa) solo resetea un «otro» en estado 9: con R4 no hace nada
    0x001438EC: "li v1, 9", 0x001438F8: "sw zero, 28(a0)",
}


def _real(pc):
    from perfil_singleton import palabra_elf
    return " ".join(desensamblar(palabra_elf(pc), pc).split())


def _imm(pc):
    from perfil_singleton import palabra_elf
    w = palabra_elf(pc) & 0xFFFF
    return w - 0x10000 if w & 0x8000 else w


def del_elf():
    """Lo que la pieza toma del ELF (no de una constante): cantidad y paso de los montones, ranura y banderas del pedido."""
    from perfil_singleton import palabra_elf
    return {"montones": _imm(0x00107BF8), "paso": _imm(0x00107C00), "ranura": _imm(0x00143FC0),
            "banderas": (palabra_elf(0x00143FC8) & 0xFFFF) << 16}


def entrada(monton=None):
    e = del_elf()
    return GESTOR + 4 + (MONTON if monton is None else monton) * e["paso"]


def _hilo(x):
    lo = x & 0xFFFF
    lo = lo - 0x10000 if lo & 0x8000 else lo
    return (x - lo) >> 16, lo


def fuente():
    ent = GESTOR + 4 + MONTON * 0x24
    he, le = _hilo(ent)
    hc, lc = _hilo(CARGADOR)
    pedido = TAM + ALINEA - 1
    o = lambda a: a - BASE_DATOS                                     # noqa: E731
    return f"""
R4A:
lui t9, 0x{he:x}
lbu v0, {le}(t9)
bne v0, zero, @LISTO
lui t8, 0x{BASE_DATOS >> 16:x}
lw v1, {o(FALLO)}(t8)
bne v1, zero, @VUELTA_A
nop
addiu sp, sp, -0x20
sd ra, 0(sp)
sw a0, 0x10(sp)
lui a0, 0x{pedido >> 16:x}
jal 0x{MALLOC:x}
ori a0, a0, 0x{pedido & 0xFFFF:x}
lui t8, 0x{BASE_DATOS >> 16:x}
bne v0, zero, @ALTA
sw v0, {o(P_CRUDO)}(t8)
addiu v1, zero, 1
sw v1, {o(FALLO)}(t8)
lw a0, 0x10(sp)
ld ra, 0(sp)
j 0x{VACIAR_OTRO:x}
addiu sp, sp, 0x20
ALTA:
lw v1, {o(ALTAS)}(t8)
addiu v1, v1, 1
sw v1, {o(ALTAS)}(t8)
addiu a1, v0, 0x{ALINEA - 1:x}
addiu at, zero, -0x{ALINEA:x}
and a1, a1, at
lui a0, 0x{he:x}
addiu a0, a0, {le}
addiu a2, zero, -1
lui a3, 0x{TAM >> 16:x}
jal 0x{ARMAR:x}
ori a3, a3, 0x{TAM & 0xFFFF:x}
ld ra, 0(sp)
addiu sp, sp, 0x20
LISTO:
jr ra
addiu v0, zero, 1
VUELTA_A:
j 0x{VACIAR_OTRO:x}
nop
R4B:
lui t9, 0x{he:x}
lbu v0, {le}(t9)
beq v0, zero, @VUELTA_B
lui t8, 0x{BASE_DATOS >> 16:x}
lw v1, {o(CARGAS)}(t8)
addiu v1, v1, 1
sw v1, {o(CARGAS)}(t8)
move t1, a3
move t2, t0
move t0, a2
addiu a3, zero, {MONTON}
addiu a2, zero, 6
lui t9, 0x{hc:x}
lw a0, {lc}(t9)
j 0x{PEDIR:x}
lui t3, 0x200
VUELTA_B:
j 0x{CARGAR_MENU:x}
nop
"""


def programa():
    return j2.ensamblar_programa(fuente(), BASE, FIN)


def entradas():
    """Las direcciones de R4A y R4B, de las etiquetas de la fuente (como las cuenta ensamblar_programa)."""
    n, pos = 0, {}
    for l in (x.strip() for x in fuente().strip().splitlines() if x.strip()):
        if l.endswith(":"):
            pos[l[:-1]] = BASE + 4 * n
        else:
            n += 1
    return pos["R4A"], pos["R4B"]


def ganchos():
    a, b = entradas()
    return [(SITIO_A, ensamblar("jal 0x%x" % a, SITIO_A),
             "pausa R4A: jal R4A (era jal 0x1438c8, vaciar el otro); el delay `lw a0` queda"),
            (SITIO_B, ensamblar("jal 0x%x" % b, SITIO_B),
             "pausa R4B: jal R4B (era jal 0x143f90, cargar el menu en el otro); el delay `li t0, 1` queda")]


def capstone_des(pc, w):
    from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS64, Cs
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
    r = list(md.disasm(struct.pack("<I", w), pc))
    return f"{r[0].mnemonic} {r[0].op_str}" if r else "(capstone no lo decodifica)"


# --- simulacion por CAMINOS del codigo propio: R4A y R4B tienen ramas, asi que cada escenario (entrada activa o no,
# malloc con o sin memoria, falla previa) se corre entero y se exige la RELACION de lo que sale (a quien salta, con que
# argumentos, que escribe). Un inmediato suelto no dice nada: (120) lo pago con la guarda del sub3.
REG = {n: i for i, n in enumerate("zero at v0 v1 a0 a1 a2 a3 t0 t1 t2 t3 t4 t5 t6 t7 s0 s1 s2 s3 s4 s5 s6 s7 "
                                     "t8 t9 k0 k1 gp sp fp ra".split())}
NOM = {i: n for n, i in REG.items()}
SP0, RET = 0x01000000, ("RET",)
GUARDADOS = ("s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "fp", "gp")
VOLATILES = ("at", "v1", "a0", "a1", "a2", "a3", "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9")


def _s16(x):
    return x - 0x10000 if x & 0x8000 else x


def simular(prog, inicio, regs, mem, malloc_da, pasos=200):
    """Corre desde `inicio` hasta que sale (jr, o j fuera del codigo propio). Devuelve (salida, eventos, regs, mem).
    salida = ('jr', destino) o ('j', destino); eventos: ('jal', destino, {reg: valor}), ('sw', dir, valor)."""
    code = {pc: w for pc, w, _ in prog}
    r = {REG[k]: v for k, v in regs.items()}
    r[0] = 0
    mem = dict(mem)
    ev = []

    def g(i):
        return 0 if i == 0 else r.get(i, ("ini", NOM[i]))

    def uno(pc):
        """Ejecuta una instruccion que no salta; devuelve None o un error."""
        w = code[pc]
        op, rs, rt, rd, fn, imm = w >> 26, (w >> 21) & 31, (w >> 16) & 31, (w >> 11) & 31, w & 63, w & 0xFFFF
        a, b = g(rs), g(rt)
        if w == 0:
            return None
        if op == 0x0F:
            r[rt] = imm << 16
        elif op == 0x09:
            r[rt] = (a + _s16(imm)) & 0xFFFFFFFF if isinstance(a, int) else ("?", pc)
        elif op == 0x0D:
            r[rt] = a | imm if isinstance(a, int) else ("?", pc)
        elif op == 0 and fn in (0x21, 0x2D, 0x25) and rt == 0:
            r[rd] = a
        elif op == 0 and fn == 0x24:
            r[rd] = a & b if isinstance(a, int) and isinstance(b, int) else ("?", pc)
        elif op in (0x24, 0x23, 0x37):                                    # lbu / lw / ld
            d = (a + _s16(imm)) & 0xFFFFFFFF if isinstance(a, int) else ("?", pc)
            ev.append(("ld", d, op))
            r[rt] = mem.get(d, ("*", d))
        elif op in (0x2B, 0x3F):                                          # sw / sd
            d = (a + _s16(imm)) & 0xFFFFFFFF if isinstance(a, int) else ("?", pc)
            mem[d] = b
            ev.append(("sw", d, b))
        else:
            return "%#x: instruccion que la simulacion no conoce (%08x)" % (pc, w)
        if rt == 0 or rd == 0:
            r[0] = 0
        return None

    pc = inicio
    for _ in range(pasos):
        if pc not in code:
            return ("error", "%#x fuera del codigo" % pc), ev, r, mem
        w = code[pc]
        op, rs, rt, fn = w >> 26, (w >> 21) & 31, (w >> 16) & 31, w & 63
        salto = op in (2, 3, 4, 5) or (op == 0 and fn == 8)
        if not salto:
            e = uno(pc)
            if e:
                return ("error", e), ev, r, mem
            pc += 4
            continue
        if op in (4, 5):
            a, b = g(rs), g(rt)
            if not (isinstance(a, int) and isinstance(b, int)):
                # un valor de memoria desconocida comparado contra cero: el escenario tiene que fijarlo
                return ("error", "%#x: la rama depende de %r / %r" % (pc, a, b)), ev, r, mem
            tomar = (a == b) if op == 4 else (a != b)
            destino = pc + 4 + 4 * _s16(w & 0xFFFF)
        elif op in (2, 3):
            destino = (pc & 0xF0000000) | ((w & 0x03FFFFFF) << 2)
        else:
            destino = g(rs)
        e = uno(pc + 4) if (pc + 4) in code else "delay fuera del codigo"
        if e:
            return ("error", e), ev, r, mem
        if op in (4, 5):
            pc = destino if tomar else pc + 8
        elif op == 3:                                                     # jal: llamada a una funcion del juego
            ev.append(("jal", destino, {NOM[i]: g(i) for i in range(1, 32)}))
            for n in VOLATILES:
                r[REG[n]] = ("basura", destino)
            r[REG["v0"]] = malloc_da if destino == MALLOC else ("basura", destino)
            r[REG["ra"]] = pc + 8
            pc += 8
        elif op == 2 and destino in code:
            pc = destino
        else:
            return (("j" if op == 2 else "jr"), destino), ev, r, mem
    return ("error", "no termina en %d pasos" % pasos), ev, r, mem


def _ini():
    regs = {n: ("ini", n) for n in REG if n != "zero"}
    regs.update({"sp": SP0, "ra": RET, "a0": ("DBUF",), "a1": ("RUTA",), "a2": ("CB",), "a3": ("ID",),
                 "t0": ("SOLTAR",)})
    return regs


def relaciones(prog) -> list:
    """Lo que la pieza tiene que cumplir en cada camino (cada rojo nombra lo que protege)."""
    errores = []
    e = del_elf()
    ent = entrada()
    a, b = entradas()
    tam_menu = -(-PSEMENU // SECTOR) * SECTOR
    P = 0x01F30010                                                        # un p sin alinear a proposito

    def mem(activo, fallo=0):
        return {ent: activo, FALLO: fallo, ALTAS: 5, CARGAS: 7, P_CRUDO: 0, CARGADOR: ("CARGADOR",)}

    def comunes(nombre, sal, ev, r):
        out = []
        if r.get(REG["sp"]) != SP0:
            out.append("%s: sale con sp = %r (la pila no queda como estaba)" % (nombre, r.get(REG["sp"])))
        if sal[0] in ("j", "jr") and r.get(REG["ra"]) != RET and not (sal[0] == "jr" and sal[1] == RET):
            out.append("%s: sale con ra = %r: el juego no vuelve a FUN_0020AEA0" % (nombre, r.get(REG["ra"])))
        if sal[0] == "jr" and sal[1] != RET:
            out.append("%s: `jr` a %r, no al que llamo" % (nombre, sal[1]))
        for n in GUARDADOS:
            if r.get(REG[n]) != ("ini", n):
                out.append("%s: pisa %s (la pausa vive de s0/s2/s3 despues de la llamada)" % (nombre, n))
        for x in ev:
            if x[0] == "sw" and not (DATOS <= x[1] < DATOS_FIN or (isinstance(x[1], int) and SP0 - 0x100 <= x[1] < SP0)):
                out.append("%s: escribe en %r, fuera de la reserva de datos y de su pila" % (nombre, x[1]))
        lecturas = [x[1] for x in ev if x[0] == "ld" and x[2] == 0x24]
        if lecturas != [ent]:
            out.append("%s: el byte que decide no es el `activo` de la entrada %d (%#x): lee %r"
                       % (nombre, MONTON, ent, lecturas))
        return out

    # R4A con la entrada activa: devuelve 1, sin llamar a nadie
    sal, ev, r, _ = simular(prog, a, _ini(), mem(1), None)
    errores += comunes("R4A activa", sal, ev, r)
    if sal != ("jr", RET) or r.get(REG["v0"]) != 1 or any(x[0] == "jal" for x in ev):
        errores.append("R4A con el monton 22 activo no devuelve 1 sin llamar a nadie (sale %r, v0 = %r)"
                       % (sal, r.get(REG["v0"])))
    # R4A sin entrada, malloc con memoria: el alta del monton con lo alineado, y devuelve 1
    sal, ev, r, m = simular(prog, a, _ini(), mem(0), P)
    errores += comunes("R4A alta", sal, ev, r)
    jals = [x for x in ev if x[0] == "jal"]
    if [x[1] for x in jals] != [MALLOC, ARMAR]:
        errores.append("R4A sin monton: no llama malloc y despues FUN_00107A08 (llama %s)"
                       % [hex(x[1]) for x in jals])
    else:
        pedido, alta = jals[0][2], jals[1][2]
        if pedido["a0"] != TAM + ALINEA - 1:
            errores.append("R4A pide %r a malloc, y alinear a %#x un monton de %#x pide %#x"
                           % (pedido["a0"], ALINEA, TAM, TAM + ALINEA - 1))
        esperado = {"a0": ent, "a1": (P + ALINEA - 1) & ~(ALINEA - 1), "a2": 0xFFFFFFFF, "a3": TAM}
        malos = {k: alta[k] for k in esperado if alta[k] != esperado[k]}
        if malos:
            errores.append("R4A da de alta el monton con %r (esperado %r): la entrada, el inicio alineado, -1 y el "
                           "tamanio" % (malos, {k: esperado[k] for k in malos}))
    if sal != ("jr", RET) or r.get(REG["v0"]) != 1:
        errores.append("R4A despues del alta no devuelve 1 al que llamo (sale %r, v0 = %r)" % (sal, r.get(REG["v0"])))
    if m.get(P_CRUDO) != P or m.get(ALTAS) != 6 or m.get(FALLO) != 0:
        errores.append("R4A no deja p crudo, la cuenta de altas +1 y la falla en 0 (p=%r altas=%r falla=%r)"
                       % (m.get(P_CRUDO), m.get(ALTAS), m.get(FALLO)))
    # R4A sin memoria: marca la falla y sigue por el camino original, con el a0 del juego
    for nombre, mm, md in (("R4A sin memoria", mem(0), 0), ("R4A fallo antes", mem(0, 1), None)):
        sal, ev, r, m = simular(prog, a, _ini(), mm, md)
        errores += comunes(nombre, sal, ev, r)
        if any(x[0] == "jal" and x[1] == ARMAR for x in ev):
            errores.append("%s: da de alta un monton sin memoria" % nombre)
        if nombre == "R4A fallo antes" and any(x[0] == "jal" for x in ev):
            errores.append("R4A con la falla marcada vuelve a pedir memoria en cada cuadro de la pausa")
        if sal != ("j", VACIAR_OTRO) or r.get(REG["a0"]) != ("DBUF",):
            errores.append("%s: no vuelve al camino original (j FUN_001438C8 con a0 = el doble bufer): sale %r, a0 = %r"
                           % (nombre, sal, r.get(REG["a0"])))
        if not m.get(FALLO):
            errores.append("%s: no deja marcada la falla (pediria memoria en cada cuadro)" % nombre)
    # R4B con la entrada activa: el pedido de FUN_00143F90, con el monton 22
    sal, ev, r, m = simular(prog, b, _ini(), mem(1), None)
    errores += comunes("R4B activa", sal, ev, r)
    esperado = {"a0": ("CARGADOR",), "a1": ("RUTA",), "a2": e["ranura"], "a3": MONTON, "t0": ("CB",), "t1": ("ID",),
                "t2": ("SOLTAR",), "t3": e["banderas"]}
    reg = {k: r.get(REG[k]) for k in esperado}
    if sal != ("j", PEDIR) or any(x[0] == "jal" for x in ev):
        errores.append("R4B activa no salta a FUN_001093C0 (sale %r)" % (sal,))
    malos = {k: reg[k] for k in esperado if reg[k] != esperado[k]}
    if malos:
        errores.append("R4B pide con %r; FUN_00143F90 (ELF) pide con %r: los mismos registros, con el monton %d"
                       % (malos, {k: esperado[k] for k in malos}, MONTON))
    if m.get(CARGAS) != 8:
        errores.append("R4B no suma su testigo de cargas")
    if isinstance(reg["a3"], int) and entrada(reg["a3"]) != ent:
        errores.append("R4B pide el monton %r y decide por la entrada %#x: no son el mismo" % (reg["a3"], ent))
    # R4B sin la entrada: FUN_00143F90 intacta
    sal, ev, r, m = simular(prog, b, _ini(), mem(0), None)
    errores += comunes("R4B sin monton", sal, ev, r)
    intacto = {"a0": ("DBUF",), "a1": ("RUTA",), "a2": ("CB",), "a3": ("ID",), "t0": ("SOLTAR",)}
    if sal != ("j", CARGAR_MENU) or any(r.get(REG[k]) != v for k, v in intacto.items()):
        errores.append("R4B sin monton no vuelve a FUN_00143F90 con los argumentos intactos (sale %r)" % (sal,))
    # lo derivado del ELF
    if not 0 <= MONTON < e["montones"]:
        errores.append("el monton %d no esta entre los %d que recorre FUN_00107BC0" % (MONTON, e["montones"]))
    if TAM < tam_menu:
        errores.append("el monton de %#x B es menor que lo que el cargador reserva para PseMenu.bin (%#x)"
                       % (TAM, tam_menu))
    if TAM % SECTOR or ALINEA & (ALINEA - 1):
        errores.append("tamanio %#x o alineacion %#x que no son multiplos de sector / potencia de 2" % (TAM, ALINEA))
    if not (DATOS <= P_CRUDO and CARGAS + 4 <= DATOS_FIN):
        errores.append("los datos de la pieza no entran en [%#x, %#x)" % (DATOS, DATOS_FIN))
    return errores


LISTADO = Path(__file__).resolve().parent.parent / "docs" / "listados" / "C2-coop-pausa.txt"


def lineas_listado():
    prog = programa()
    return prog, [f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}" for pc, w, t in prog]


def problemas(mostrar=False, escribir=False) -> list:
    """La lista de rojos (la usa tambien coop_diseno.py, regla 13)."""
    errores = []
    try:
        prog, lineas = lineas_listado()
    except AssertionError:
        return ["el codigo pasa de la reserva [%#x, %#x)" % (BASE, FIN)]
    permitidos = {MALLOC, ARMAR, VACIAR_OTRO, CARGAR_MENU, PEDIR}
    for (pc, w, t), l in zip(prog, lineas):
        if mostrar:
            print(l)
        if capstone_des(pc, w).startswith("(capstone"):
            errores.append(f"{pc:#x} {t}: capstone no lo decodifica")
        op = w >> 26
        if op in (4, 5):
            dest = pc + 4 + 4 * _s16(w & 0xFFFF)
            if not (BASE <= dest < prog[-1][0] + 4):
                errores.append(f"{pc:#x} {t}: salta a {dest:#x}, fuera del codigo")
        if op in (2, 3):
            dest = (pc & 0xF0000000) | ((w & 0x03FFFFFF) << 2)
            if dest not in permitidos and not (BASE <= dest < FIN):
                errores.append(f"{pc:#x} {t}: j/jal a {dest:#x}, que el diseno no nombra")
    errores += relaciones(prog)
    if mostrar:
        print("\napoyo (el ELF, sin pisar):")
    for pc, esp in APOYO.items():
        real = _real(pc)
        if real.lower() != esp.lower():
            errores.append(f"apoyo {pc:#x}: el ELF tiene '{real}', el diseno supone '{esp}'")
        if mostrar:
            print(f"{pc:08X}  {real}")
    if mostrar:
        print("\nderivado del ELF:", del_elf(), "| entrada %d = %#x | R4A %#x, R4B %#x" % ((MONTON, entrada()) + entradas()))
    if escribir:
        LISTADO.write_text("\n".join(lineas) + "\n", encoding="utf-8")
    elif not LISTADO.exists():
        errores.append("falta docs/listados/C2-coop-pausa.txt (`coop_pausa.py listado` lo escribe)")
    else:
        g = [x.rstrip() for x in LISTADO.read_text(encoding="utf-8-sig").splitlines()]
        if g != [x.rstrip() for x in lineas]:
            errores.append("docs/listados/C2-coop-pausa.txt no coincide con el codigo: regenerarlo con "
                           "`coop_pausa.py listado`")
    return errores


def verificar(mostrar=False, escribir=False) -> int:
    errores = problemas(mostrar, escribir)
    for e in errores:
        print("ROJO:", e)
    print(f"coop_pausa: {len(programa())} palabras en [{BASE:#x}, {FIN:#x}), {len(errores)} problema(s)")
    return 1 if errores else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["listado", "verificar"])
    a = ap.parse_args()
    return verificar(mostrar=a.cmd == "listado", escribir=a.cmd == "listado")


if __name__ == "__main__":
    sys.exit(main())
