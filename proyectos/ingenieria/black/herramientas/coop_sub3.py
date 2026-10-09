#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""coop_sub3.py -- COOP-C pieza 2b: J2 con su PROPIO sub del aparejo (F7 de docs/17; docs/16 «sub3: la receta leida»
y «La guarda de plantilla viva, (118)»).

    python herramientas/coop_sub3.py listado      # el codigo, desensamblado, y los ganchos con lo que pisan
    python herramientas/coop_sub3.py verificar    # sale 1 si algo no cierra (capstone, reserva, saltos, ELF, guarda)

EL PROBLEMA (116, en frio): el sub del arma (`pers+0x398 + i*0x6C`, `pers` = `*(0x0040F50C)`) lo rearma
`FUN_001AC960` -> `FUN_001A8168` con el arma que el jugador tiene en la mano. Con el coop, J2 usa el sub de J: el
MODELO del arma se cuela entre mitades (F7, visto en (96)). Un sub propio para J2 lo arregla, pero destapa un peligro
que el juego original no tiene: `FUN_001A8168` instancia la PLANTILLA del arma dentro de la arena del sub y guarda
los punteros EN LA PLANTILLA (`FUN_00342A80`: plantilla +0x20/+0x24/+0x28/+0x2C, sin condicion). La plantilla es un
recurso del nivel COMPARTIDO por cualquiera que tenga esa arma, y J y J2 arrancan con la misma pistola: el ultimo que
arma se queda con la plantilla y el otro lee la instancia ajena.

LA REGLA DEL DUENO DE PLANTILLA, con la GUARDA de (118). Despues de armar un sub `S` con la plantilla `Bn` (la vieja
era `Bo`): (1) guardar la cuadrupla de `Bn` como la de `S`; (2) si otro sub `T` de los tres tiene `T+8` = `Bo`,
`Bo` != `Bn` Y `Bo` PASA LA GUARDA DE PLANTILLA VIVA, reescribirle a `Bo` la cuadrupla guardada de `T`.

POR QUE LA GUARDA ES OBLIGATORIA (118, medido en los 16 volcados con `herramientas/sub_estado.py`): el sub que NO
esta en la mano deja `sub+8` COLGADO -- apunta a memoria que el nivel reciclo -- en 14 de 16 volcados. Es inocuo en el
juego original porque `FUN_001A8168` rearma `sub+8` y la cuadrupla antes de que la ranura se use; pero la regla, sin
la guarda, le habria escrito CUATRO PALABRAS encima a memoria ajena, en el caso NORMAL del juego. La guarda es
`*(p+0x1C) == p+0x4C` (un puntero relativo a si misma, invariante por construccion que el ruido no cumple de
casualidad): discrimina 16/16 contra 0/14. Tres instrucciones. Si no pasa, NO SE ESCRIBE NADA.

LOS CUATRO SITIOS (docs/16, la tabla). Uno solo es gancho propio; los otros tres ya son del mod y reciben un bloque:
  0x001ACA2C  `jal 0x1A8168` (delay `move a0, s0`)  -> `jal SUBH`: elige el sub (sub3 si `s7` = J2, armado una vez
              por arranque con `FUN_001A80F8`), llama la original y aplica la regla. Deja `s0` = el sub elegido, que
              es lo que usa el resto de `FUN_001AC960` (0x001ACA34..0x001ACA68).
  0x001ACA84  envoltorio de la carga de R3 (coop_mod.R3_ENVOLTORIO_MOD): `a2` = sub3 en vez de `sub_i`.
  0x001295A8  por cuadro de R3 (coop_mod.R3_POR_CUADRO_MOD): el sub con el que se carga/compara es sub3, PERO
              solo si `SUB3_IDX` (que arma lo armo) coincide con `*(J2+0x2C3)` -- si no, el bloque no toca `a2`
              (122: sin ese termino `a2` es constante y el codigo por cuadro no puede volver a enterarse de que
              J2 cambio de arma; ver docs/16 «Lo que la lectura en frio de (122) dejo»).
  0x00129E38  desarme (coop_mod.DESARME_MOD): `SUB3_MOLDE` = 0 y la cuadrupla de sub3 invalidada.
Los tres bloques se exportan como texto (`ENVOLTORIO_BLOQUE`, `POR_CUADRO_BLOQUE`, `DESARME_BLOQUE`) y los inserta
coop_mod.py, como ya hace con `R3_BAJA_BLOQUE`: no hay ganchos nuevos sobre sitios que el mod ya toma.

LA REGLA CORRE PARA LOS DOS JUGADORES, no solo para J2 (precision escrita en docs/16 antes de este archivo): el
peligro es simetrico -- si J cambia de arma, la plantilla que compartia con J2 queda apuntando a la arena de J, que
el arma nueva ya piso. Por eso SUBH se ejecuta siempre y lo unico que depende de `s7` es QUE sub se arma.

TAMANOS DERIVADOS DEL CODIGO, NO LITERALES (la leccion de (117)): el paso del sub (0x6C), la arena (0x4650) y el
mapa de huesos (0xB0) se leen del ELF en `verificar`, y si el ELF dice otra cosa sale ROJO.

Registros en 0x001ACA2C, leidos del desensamblado: `s2` = pers, `s0` = `a0` = sub_i, `a1` = la plantilla nueva,
`a2` = la tabla, `a3` = `*(pers+0x940)`, `s5` = i, `s7` = el jugador. SUBH solo usa t0-t9, a0-a3 y la pila, y escribe
`s0` a proposito (FUN_001A8168 preserva s0-s7, asi que el valor sobrevive a la llamada).
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jugador2 as j2  # noqa: E402
from mips import desensamblar, ensamblar  # noqa: E402

# --- memoria: reservas «sub3 (codigo)» y «sub3 (datos)» de coop-plan-b (docs/14) ---
# (119) la reserva vieja [0x0046ED00, 0x0046EE00) era de 64 palabras y el codigo con la guarda mide 98: se corrio el
# principio a 0x0046EC20 (el hueco libre entre el final del HUD doble, 0x0046EC14, y la reserva vieja), 120 palabras.
# El cambio se escribio en docs/16 y en coop-plan-b ANTES de tocar el stub, como manda la Fase C.
BASE, FIN = 0x0046EC20, 0x0046EE00          # codigo (120 palabras)
DATOS, DATOS_FIN = 0x0046EF00, 0x0046F000   # datos (en cero en los 16 volcados, sub_estado.py)

PASO_SUB = 0x6C                 # 0x001ACA14 `addiu v0, zero, 0x6c` -- derivado, verificado contra el ELF
SUBS_OFF = 0x398                # pers+0x398 + i*PASO_SUB
N_SUBS = 3                      # sub0, sub1 y sub3: los que pueden compartir plantilla con el coop

SUB3 = DATOS                            # 0x0046EF00, la estructura de 0x6C B
SUB3_ARMADA = SUB3 + PASO_SUB           # 0x0046EF6C -- 1 = construido en este arranque (como R3_ARMADA)
SUB3_MOLDE = SUB3_ARMADA + 4            # 0x0046EF70 -- MOLDES cuando se armo en este nivel
SUB3_ESCRIB = SUB3_ARMADA + 8           # 0x0046EF74 -- veces que la regla reescribio una cuadrupla
SUB3_SALTOS = SUB3_ARMADA + 0xC         # 0x0046EF78 -- veces que la guarda SALTO (P3d de PREDICCIONES-118)
SUB3_IDX = SUB3_ARMADA + 0x10           # 0x0046EF7C -- (122) QUE ARMA armo el sub3 (el indice +0x2C3 de J2)
CUAD = 0x0046EF80                       # 3 cuadruplas de 0x10 B: sub0, sub1, sub3

PERS_GLOBAL = 0x0040F50C        # *(esto) = pers
ARMAR_SUB = 0x001A80F8          # FUN_001A80F8(sub): aloja el mapa de huesos (+0x30) y la arena (+4)
ARMA_SUB = 0x001A8168           # FUN_001A8168(sub, plantilla, tabla, a3): instancia la plantilla en la arena
SITIO = 0x001ACA2C              # el unico gancho propio de la pieza
VIVA_OFF, VIVA_REL = 0x1C, 0x4C  # la guarda de plantilla viva: *(p+0x1C) == p+0x4C
# (123) EL PUNTERO DE TABLA VIRTUAL del sub. Lo pone el constructor de `pers` (FUN_00382D60, `sw v0, 0x5C(v1)` en
# 0x00382DC0) y NO FUN_001A80F8; sin el, FUN_001A51C8 hace la llamada virtual `(*(sub+0x5C))[+0x14]` con +0x5C = 0,
# salta a la direccion 0 y el juego cae en «Syscall: undefined» al juntar J2 un arma (docs/16, seccion (123)).
VPTR_SUB, VPTR_OFF = 0x003E0180, 0x5C   # verificados contra el ELF en APOYO (las cuatro del constructor)

J2 = 0x0046CDF0                 # coop_mod.J2
MOLDES = 0x0046D7C0             # coop_mod.MOLDES


def _o(d):
    """El desplazamiento con signo de una direccion del mod respecto de `lui rX, 0x47`."""
    v = d - 0x00470000
    assert -0x8000 <= v < 0x8000, "%#x no entra en 16 bits con signo" % d
    return v


FUENTE = """
SUBH:
addiu sp, sp, -0x40
sd ra, 0(sp)
sw a1, 0x10(sp)
sw a2, 0x14(sp)
sw a3, 0x18(sp)
lui t0, 0x47
addiu t1, t0, %(J2)d
bne s7, t1, @DEST3
move t4, a0
lw t2, %(ARMADA)d(t0)
bne t2, zero, @ARMA3
addiu t4, t0, %(SUB3)d
jal 0x%(ARMAR)x
move a0, t4
lui t0, 0x47
addiu t4, t0, %(SUB3)d
lui t2, 0x%(VPTR_HI)x
addiu t2, t2, 0x%(VPTR_LO)x
sw t2, 0x%(VPTR_OFF)x(t4)
addiu t2, zero, 1
sw t2, %(ARMADA)d(t0)
ARMA3:
lw t2, %(MOLDES)d(t0)
sw t2, %(MOLDE3)d(t0)
sw s5, %(IDX)d(t0)
DEST3:
sw t4, 0x1c(sp)
lw t5, 8(t4)
sw t5, 0x20(sp)
lw a1, 0x10(sp)
lw a2, 0x14(sp)
lw a3, 0x18(sp)
jal 0x%(ARMA)x
move a0, t4
lw t4, 0x1c(sp)
move s0, t4
lui t0, 0x47
lw t6, 8(t4)
addiu t1, t0, %(SUB3)d
addiu t9, zero, 2
beq t4, t1, @IDX3
nop
move t9, s5
IDX3:
sll t2, t9, 4
addiu t3, t0, %(CUAD)d
addu t3, t3, t2
lw t2, 0x20(t6)
sw t2, 0(t3)
lw t2, 0x24(t6)
sw t2, 4(t3)
lw t2, 0x28(t6)
sw t2, 8(t3)
lw t2, 0x2c(t6)
sw t2, 0xc(t3)
lw t5, 0x20(sp)
beq t5, zero, @FIN3
nop
beq t5, t6, @FIN3
nop
lw t2, 0x%(VIVA)x(t5)
addiu t3, t5, 0x%(REL)x
bne t2, t3, @NOVIVA
nop
addiu t2, s2, 0x%(SUBS)x
sw t2, 0x28(sp)
addiu t2, t2, 0x%(PASO)x
sw t2, 0x2c(sp)
addiu t2, t0, %(SUB3)d
sw t2, 0x30(sp)
move t7, zero
LAZO3:
sll t2, t7, 2
addu t2, t2, sp
lw t8, 0x28(t2)
beq t8, t4, @SIG3
nop
lw t2, 8(t8)
bne t2, t5, @SIG3
nop
sll t2, t7, 4
addiu t3, t0, %(CUAD)d
addu t3, t3, t2
lw t2, 0(t3)
sw t2, 0x20(t5)
lw t2, 4(t3)
sw t2, 0x24(t5)
lw t2, 8(t3)
sw t2, 0x28(t5)
lw t2, 0xc(t3)
sw t2, 0x2c(t5)
lw t2, %(ESCRIB)d(t0)
addiu t2, t2, 1
sw t2, %(ESCRIB)d(t0)
SIG3:
addiu t7, t7, 1
addiu t2, zero, %(N)d
bne t7, t2, @LAZO3
nop
beq zero, zero, @FIN3
nop
NOVIVA:
lw t2, %(SALTOS)d(t0)
addiu t2, t2, 1
sw t2, %(SALTOS)d(t0)
FIN3:
ld ra, 0(sp)
jr ra
addiu sp, sp, 0x40
""" % {"J2": _o(J2), "ARMADA": _o(SUB3_ARMADA), "SUB3": _o(SUB3), "ARMAR": ARMAR_SUB, "MOLDES": _o(MOLDES),
       "MOLDE3": _o(SUB3_MOLDE), "ARMA": ARMA_SUB, "CUAD": _o(CUAD), "VIVA": VIVA_OFF, "REL": VIVA_REL,
       "SUBS": SUBS_OFF, "PASO": PASO_SUB, "ESCRIB": _o(SUB3_ESCRIB), "SALTOS": _o(SUB3_SALTOS), "N": N_SUBS,
       "IDX": _o(SUB3_IDX), "VPTR_HI": VPTR_SUB >> 16, "VPTR_LO": VPTR_SUB & 0xFFFF, "VPTR_OFF": VPTR_OFF}
assert VPTR_SUB & 0x8000 == 0, "la mitad baja de VPTR_SUB tiene signo: el par lui/addiu daria otra direccion"


# --- los tres bloques que coop_mod.py inserta en el codigo que ya tiene (no son ganchos nuevos) ---

# En R3_ENVOLTORIO_MOD, justo antes del `jal 0x1a51c8 / move a0, t5` que carga R3: a2 = sub3 si esta armado en este
# nivel. Usa t3 (libre ahi) y no toca s2, que guarda el sub_i original para la recarga de r_i de mas abajo.
ENVOLTORIO_BLOQUE = """
lw t3, %(ARMADA)d(t0)
beq t3, zero, @SUB3NO1
nop
lw t3, %(MOLDE3)d(t0)
lw t4, %(MOLDES)d(t0)
bne t3, t4, @SUB3NO1
nop
addiu a2, t0, %(SUB3)d
SUB3NO1:
""" % {"ARMADA": _o(SUB3_ARMADA), "MOLDE3": _o(SUB3_MOLDE), "MOLDES": _o(MOLDES), "SUB3": _o(SUB3)}

# En R3_POR_CUADRO_MOD, despues de `addiu a2, a2, 0x398` (a2 = sub_i): si sub3 esta armado en este nivel Y CON EL
# ARMA QUE J2 TIENE EN LA MANO, a2 = sub3. La comparacion `+0x50 != a2` de mas abajo queda midiendo contra sub3.
#
# (122) EL TERCER TERMINO NO ES COSMETICO. Sin el, `a2` pasa a ser la CONSTANTE sub3 para todo `i`, y el camino
# rapido (`bne t5, a2` con t5 = R3+0x50) se cumple siempre en cuanto R3 queda cargada con sub3: el codigo por
# cuadro PIERDE la unica senal que tenia de que J2 cambio de arma (antes `a2` = pers+0x398+i*0x6C, que depende
# de `i`) y R3 se queda con el modelo viejo para siempre. `t2` ya trae `lb t2, 0x2c3(a1)` = el indice de J2, asi
# que la condicion no cuesta una lectura nueva. Si no coincide, el bloque NO toca `a2` y el camino por cuadro
# queda exactamente como antes de la pieza -- el estado con el que la campana dio 8 de 8.
POR_CUADRO_BLOQUE = """
lui t9, 0x47
lw t8, %(ARMADA)d(t9)
beq t8, zero, @SUB3NO2
nop
lw t8, %(MOLDE3)d(t9)
lw t6, %(MOLDES)d(t9)
bne t8, t6, @SUB3NO2
nop
lw t8, %(IDX)d(t9)
bne t8, t2, @SUB3NO2
nop
addiu a2, t9, %(SUB3)d
SUB3NO2:
""" % {"ARMADA": _o(SUB3_ARMADA), "MOLDE3": _o(SUB3_MOLDE), "MOLDES": _o(MOLDES), "SUB3": _o(SUB3),
       "IDX": _o(SUB3_IDX)}

# En DESARME_MOD, junto a R3_BAJA_BLOQUE: la memoria del sub3 es por ARRANQUE (como R3), asi que no se desarma el
# sub -- se invalida lo que es por NIVEL: el molde (para que la carga siguiente lo vuelva a armar) y su cuadrupla
# guardada (que apunta a una arena de un nivel que ya no esta).
DESARME_BLOQUE = """
lui t2, 0x47
sw zero, %(MOLDE3)d(t2)
sw zero, %(IDX)d(t2)
sw zero, %(CUAD3)d(t2)
sw zero, %(CUAD3b)d(t2)
sw zero, %(CUAD3c)d(t2)
sw zero, %(CUAD3d)d(t2)
""" % {"MOLDE3": _o(SUB3_MOLDE), "IDX": _o(SUB3_IDX), "CUAD3": _o(CUAD + 0x20), "CUAD3b": _o(CUAD + 0x24),
       "CUAD3c": _o(CUAD + 0x28), "CUAD3d": _o(CUAD + 0x2C)}


def programa():
    return j2.ensamblar_programa(FUENTE, BASE, FIN)


ENTRADA = BASE   # SUBH es la primera instruccion

ORIGINAL = {SITIO: "jal 0x001A8168"}
# lo que el diseno usa sin pisarlo, y de donde DERIVA los tamanos (si el ELF cambia, rojo)
APOYO = {0x001ACA14: "li v0, 108",               # el paso del sub: PASO_SUB
         0x001ACA24: "addiu s3, v0, 920",        # s3 = i*0x6C + 0x398  -> SUBS_OFF
         0x001ACA28: "addu s0, s2, s3",          # s0 = sub_i, s2 = pers
         0x001ACA30: "daddu a0, s0, zero",       # el delay slot que el gancho conserva: a0 = sub_i
         0x001ACA80: "daddu a1, s7, zero",       # s7 = el jugador (lo que SUBH compara contra J2)
         0x001A8148: "li a0, 18000",             # la arena que aloja FUN_001A80F8
         0x001A8140: "li a0, 176",               # el mapa de huesos
         0x001A81B0: "sw a1, 8(s5)",             # FUN_001A8168 escribe sub+8 = la plantilla
         0x001A81DC: "jal 0x00342A80",           # ... y de ahi sale la cuadrupla de la plantilla
         # (123) el constructor de `pers` le pone a cada sub su puntero de tabla: VPTR_SUB en +VPTR_OFF
         0x00382DA8: "lui v0, 0x%X" % (VPTR_SUB >> 16),
         0x00382DAC: "addiu v1, s3, %d" % SUBS_OFF,
         0x00382DB0: "addiu v0, v0, %d" % (VPTR_SUB & 0xFFFF),
         0x00382DC0: "sw v0, %d(v1)" % VPTR_OFF}


def ganchos():
    return [(SITIO, ensamblar("jal 0x%x" % ENTRADA, SITIO),
             "sub3: jal SUBH (era jal 0x1a8168); el delay `move a0, s0` queda")]


def capstone_des(pc, w):
    # MIPS64, como desensamblar.py: el R5900 usa sd/ld (en MIPS32 capstone no los decodifica)
    from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS64, Cs
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
    r = list(md.disasm(struct.pack("<I", w), pc))
    return f"{r[0].mnemonic} {r[0].op_str}" if r else "(capstone no lo decodifica)"


LISTADO = Path(__file__).resolve().parent.parent / "docs" / "listados" / "C2-coop-sub3.txt"


def lineas_listado():
    prog = programa()
    return prog, [f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}" for pc, w, t in prog]


def problemas(mostrar=False, escribir=False) -> list:
    """La lista de rojos (la usa tambien coop_diseno.py, regla 10)."""
    from perfil_singleton import palabra_elf
    errores = []
    prog, lineas = lineas_listado()
    if prog[-1][0] + 4 > FIN:
        errores.append("el codigo (%d palabras) pasa de la reserva [%#x, %#x)"
                       % (len(prog), BASE, FIN))
    # los datos entran en su reserva y no se pisan entre si (SUB3_IDX cae en el hueco de (122))
    if not (DATOS <= SUB3 and CUAD + N_SUBS * 0x10 <= DATOS_FIN):
        errores.append("los datos no entran en [%#x, %#x)" % (DATOS, DATOS_FIN))
    palabras_dato = [("SUB3_ARMADA", SUB3_ARMADA), ("SUB3_MOLDE", SUB3_MOLDE), ("SUB3_ESCRIB", SUB3_ESCRIB),
                     ("SUB3_SALTOS", SUB3_SALTOS), ("SUB3_IDX", SUB3_IDX)]
    for nombre, d in palabras_dato:
        if not (SUB3 + PASO_SUB <= d < CUAD):
            errores.append("%s (%#x) no cae entre el fin del sub (%#x) y CUAD (%#x)"
                           % (nombre, d, SUB3 + PASO_SUB, CUAD))
    if len({d for _, d in palabras_dato}) != len(palabras_dato):
        errores.append("dos palabras de dato del sub3 comparten direccion: %s"
                       % ", ".join("%s=%#x" % x for x in palabras_dato))
    for (pc, w, t), l in zip(prog, lineas):
        if mostrar:
            print(l)
        if capstone_des(pc, w).startswith("(capstone"):
            errores.append(f"{pc:#x} {t}: capstone no lo decodifica")
        op = w >> 26
        if op in (4, 5):                                   # beq/bne: dentro del codigo
            off = struct.unpack("<h", struct.pack("<H", w & 0xFFFF))[0]
            dest = pc + 4 + 4 * off
            if not (BASE <= dest < prog[-1][0] + 4):
                errores.append(f"{pc:#x} {t}: salta a {dest:#x}, fuera del codigo")
        if op in (2, 3):                                   # j/jal: solo a las dos del diseno
            dest = (pc & 0xF0000000) | ((w & 0x03FFFFFF) << 2)
            if dest not in (ARMAR_SUB, ARMA_SUB):
                errores.append(f"{pc:#x} {t}: j/jal a {dest:#x}, no es FUN_001A80F8 ni FUN_001A8168")
    # la guarda de plantilla viva TIENE que estar: es lo que (118) agrego y sin ella el mod corrompe memoria ajena
    pal = [w for _, w, _ in prog]
    # (120) la TERNA, no los inmediatos sueltos: el chequeo viejo miraba «algun lw con inmediato 0x1C» y en este
    # mismo programa hay un `lw t4, 0x1c(sp)` de la PILA que lo cumplia siempre -- o sea que sacar la guarda dejaba
    # el chequeo en VERDE, y lo delato su propio sabotaje. Ahora: `lw rX, 0x1C(rB)` y `addiu rY, rB, 0x4C` sobre el
    # mismo rB, y un bne/beq que compare rX con rY.
    def _rs(w):
        return (w >> 21) & 0x1F

    def _rt(w):
        return (w >> 16) & 0x1F

    cargas = {(_rs(w), _rt(w)) for w in pal if (w >> 26) == 0x23 and (w & 0xFFFF) == VIVA_OFF}
    relat = {(_rs(w), _rt(w)) for w in pal if (w >> 26) == 9 and (w & 0xFFFF) == VIVA_REL}
    ramas = {frozenset((_rs(w), _rt(w))) for w in pal if (w >> 26) in (4, 5)}
    tiene_terna = any(frozenset((x, y)) in ramas
                      for b1, x in cargas for b2, y in relat if b1 == b2)
    if not tiene_terna:
        errores.append("falta la guarda de plantilla viva (`lw rX, %#x(rB)` + `addiu rY, rB, %#x` sobre el mismo rB, "
                       "comparados con bne/beq): sin ella la regla escribe sobre un puntero colgado en el caso "
                       "NORMAL del juego (118, 14 de 16 volcados)" % (VIVA_OFF, VIVA_REL))
    # (123) el puntero de tabla virtual del sub3, por RELACION (la leccion de (120)): un `sw rX, VPTR_OFF(rB)` con rX
    # armado por `lui rX, hi` + `addiu rX, rX, lo` y rB el registro que tiene SUB3 (`addiu rB, rT, _o(SUB3)`), DESPUES
    # del `jal FUN_001A80F8`. Un `sw ... 0x5c(...)` suelto, o la constante armada en otro registro, no alcanza.
    jal_armar = [i for i, w in enumerate(pal) if (w >> 26) == 3 and ((w & 0x03FFFFFF) << 2) == ARMAR_SUB]
    luis = {_rt(w) for w in pal if (w >> 26) == 0x0F and (w & 0xFFFF) == VPTR_SUB >> 16}
    addius = {_rt(w) for w in pal if (w >> 26) == 9 and _rs(w) == _rt(w) and (w & 0xFFFF) == VPTR_SUB & 0xFFFF}
    regs_sub3 = {_rt(w) for w in pal if (w >> 26) == 9 and (w & 0xFFFF) == _o(SUB3) & 0xFFFF}
    sw_vptr = [i for i, w in enumerate(pal) if (w >> 26) == 0x2B and (w & 0xFFFF) == VPTR_OFF
               and _rt(w) in (luis & addius) and _rs(w) in regs_sub3]
    if not (jal_armar and any(i > jal_armar[0] for i in sw_vptr)):
        errores.append("SUBH no le pone al sub3 su puntero de tabla virtual (`sw rX, %#x(rSUB3)` con rX = %#x, despues "
                       "de `jal FUN_001A80F8`): sin el, FUN_001A51C8 salta a la direccion 0 al cargar R3 con una "
                       "plantilla y el juego cae en «Syscall: undefined» (123)" % (VPTR_OFF, VPTR_SUB))
    # los tres bloques que coop_mod inserta
    for nombre, src in (("envoltorio", ENVOLTORIO_BLOQUE), ("por cuadro", POR_CUADRO_BLOQUE),
                        ("desarme", DESARME_BLOQUE)):
        try:
            j2.ensamblar_programa(src, BASE, FIN)
        except Exception as e:                              # noqa: BLE001
            errores.append("el bloque '%s' no ensambla: %s" % (nombre, e))
    if mostrar:
        print("\nganchos:")
    for pc, w, t in ganchos():
        real = " ".join(desensamblar(palabra_elf(pc), pc).split())
        if real.lower() != ORIGINAL[pc].lower():
            errores.append(f"gancho {pc:#x}: el ELF tiene '{real}', se esperaba '{ORIGINAL[pc]}'")
        if mostrar:
            print(f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}  [pisa: {real}]")
    if mostrar:
        print("\napoyo (de donde salen los tamanos, sin pisarlo):")
    for pc, esp in APOYO.items():
        real = " ".join(desensamblar(palabra_elf(pc), pc).split())
        if real.lower() != esp.lower():
            errores.append(f"apoyo {pc:#x}: el ELF tiene '{real}', el diseno supone '{esp}'")
        if mostrar:
            print(f"{pc:08X}  {real}")
    if escribir:
        LISTADO.parent.mkdir(parents=True, exist_ok=True)
        LISTADO.write_text("\n".join(lineas) + "\n", encoding="utf-8")
    elif not LISTADO.exists():
        errores.append("falta docs/listados/C2-coop-sub3.txt (`coop_sub3.py listado` lo escribe)")
    else:
        g = [l.rstrip() for l in LISTADO.read_text(encoding="utf-8-sig").splitlines()]
        if g != [l.rstrip() for l in lineas]:
            errores.append("docs/listados/C2-coop-sub3.txt no coincide con el codigo: regenerarlo con "
                           "`coop_sub3.py listado`")
    return errores


def verificar(mostrar=False, escribir=False) -> int:
    errores = problemas(mostrar, escribir)
    for e in errores:
        print("ROJO:", e)
    print(f"coop_sub3: {len(programa())} palabras en [{BASE:#x}, {FIN:#x}), {len(ganchos())} gancho(s), "
          f"{len(errores)} problema(s)")
    return 1 if errores else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["listado", "verificar"])
    a = ap.parse_args()
    return verificar(mostrar=a.cmd == "listado", escribir=a.cmd == "listado")


if __name__ == "__main__":
    sys.exit(main())
