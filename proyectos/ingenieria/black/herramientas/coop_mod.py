#!/usr/bin/env python3
"""coop_mod.py -- B3 de COOP-B (bitacora (86)): el mod SIN PINE. Todo lo que el prototipo
hacia desde Python pasa a los stubs, para que un pnach alcance.

La diferencia con jugador2.py es UNA: ninguna palabra de DATOS se escribe desde afuera.
Un pnach solo puede escribir constantes, y `continuo` las reescribe cada cuadro -- asi
que el codigo va en el pnach y los datos nacen del .bss en cero:

  ENVOLTORIO (sitio del cargador 0x00128EA4, jal 0x00129090):
    J hecho (la original devuelve 1)  ->  ARMA EL MOLDE: copia J (juego+0x30, 0x8C0 B)
    sobre J2 con lq/sq, reubica los 7 autopunteros, +0xB0 = 0, +0x8A4 = 0x1C,
    +0x2A0 = ARMAS2 (en cero), ESTADO = ESPERA = 0, FASE = 1, y le devuelve 0 al cargador.
    FASE 1  ->  aparicion + constructor + registro de J2 (lo de jugador2.py), FASE = 2.
              (93c) APARTAR: FUN_0012BD98 le da a J2 la aparicion DE J; si J2 nacio con la misma x
              que J, se corre 1 m en x (+0xA0, +0x100, +0x190). Encimados, los dos controladores de
              colision cuelgan el mundo de colision (FUN_0033DD98) en los niveles con cartel
              (Wilderness, Town): medido con control (apartar93.py).
    Con FASE 2 la carga siguiente vuelve a armar el molde (jugador2.py no lo hacia).
  POR CUADRO (sitio 0x00129574, jal 0x0013BAC8), con FASE 2:
    ESTADO 0: espera 30 cuadros; despues CONTROL2 (J2+0x588/+0x6D0/+0x7C8 = CTRL2 = el control
              del puerto que J NO usa: 0x005858A0 (puerto 1) o +0x16C (puerto 2) -- (90c): el juego
              le da a J el puerto que apreto Start, y "J + 0x16C" caia en un 3.er control vacio;
              J2+0x32C = J2+0x4F0), EL CABECEO (88c: cabeceo de la mira
              guardado negado y su +0xF1 "invertir Y" dado vuelta) y ENLAZAR FUN_0012a158(juego, J2)
    ESTADO 1: ATAR FUN_0025C210(*(0x0040F4CC), J2)
    ESTADO 3: controlador y update de J2 cada cuadro (lo de jugador2.py) y EL TITERE (88): la
              matriz de J2 (+0x70..+0xAF) al aliado 1 del pool, si es aliado (+0x3A4 = 0)
  DESARME (sitio 0x00129E38, jal 0x0012BFC8 -- la baja de los jugadores al salir del nivel), (87):
    la original, y con FASE 2 lo mismo para J2: ESTADO 3 -> FUN_0025C2C8 (suelta el controlador
    de colision); ESTADO >= 1 -> FUN_0012A280 (lo saca de la lista del nivel). FASE = ESTADO = 0.
    Sin esto la SEGUNDA carga cae en FUN_0033DD98 (TLB Miss 0x2000000): el controlador de J2
    quedaba en el mundo de colision. `poner --sin-baja` es el control.

Las MANOS de la prueba (no son del mod): `manos` clona el mando 2 en el falso 2, apunta
CTRL2+0xC ahi y empuja el eje adelante. Es lo que haria un humano con el mando 2.

    python herramientas/coop_mod.py listar
    python herramientas/coop_mod.py poner       # EN PAUSA: pone a cero datos y J2, escribe codigo y ganchos
    python herramientas/coop_mod.py mirar 40    # registra fase, estado, moldes, atadas, J2
    python herramientas/coop_mod.py manos 2 [--control]
    python herramientas/coop_mod.py toml        # escribe mods/coop.toml (fuente para pnach.py)
    python herramientas/coop_mod.py instalar    # el bloque, APAGADO, en el pnach de parches de PCSX2
    python herramientas/coop_mod.py activar     # Enable = ... en los ajustes del juego (desactivar lo saca)
    python herramientas/coop_mod.py quitar
"""
import argparse
import json
import math
import struct
import subprocess
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
from mips import ensamblar  # noqa: E402
import clon_jugador as cj  # noqa: E402
import gancho as g  # noqa: E402
import jugador2 as j2  # noqa: E402
import pantalla_dividida as pd  # noqa: E402
import ocultar_pasada as oc  # noqa: E402

# datos: .bss en cero al arrancar; NINGUNO va en el pnach
CONTADOR, ESTADO, FASE = 0x0046D780, 0x0046D784, 0x0046D790
LLAM_J2, LLAM_J0 = 0x0046D794, 0x0046D79C
MIGA_A, MIGA_B, MIGA_V0, MIGA_C = 0x0046D7A0, 0x0046D798, 0x0046D7A4, 0x0046D7A8
ESPERA, MOLDES, ATADAS, DESARMES = 0x0046D7B8, 0x0046D7C0, 0x0046D7C4, 0x0046D7C8
TITERES = 0x0046D7CC           # (88) cuadros en que el stub copio la matriz de J2 al aliado 1
RECARGA = 0x0046D7D0           # (92) cuadros que el arma de J2 lleva en estado 4/5 (recargando)
DATOS = (CONTADOR, ESTADO, FASE, LLAM_J2, LLAM_J0, MIGA_A, MIGA_B, MIGA_V0, MIGA_C, ESPERA, MOLDES, ATADAS,
         DESARMES, TITERES, RECARGA)
CUADROS_ESPERA = 30

# (87) B3.3 -- la BAJA de J2 al salir del nivel. El desarme del juego es FUN_00129de8, estado
# 0x1d: `jal FUN_0012bfc8(juego)`, que para i < cuenta (= 1) suelta el controlador de colision
# (FUN_0025c2c8: FUN_0025c798 libera la entrada del pool de 0x00585C00 y la saca del mundo de
# colision con FUN_0032cde0) y saca al jugador de la lista del nivel (FUN_0012a280: juego+0x5CA4,
# siguiente en +0xB0, y juego+0x4920). Es el espejo exacto de FUN_0012be80 (atar + enlazar).
# A J2 nadie se lo hacia. El envoltorio del desarme llama a la original y despues lo mismo para J2.
SITIO_DESARME = 0x00129E38     # jal 0x12bfc8 (delay: move a0, s3 = juego)
DESARME = 0x0046DD00           # .bss en cero (0x0046DC00..0x00472000 libre, (82))

DESARME_MOD = """
addiu sp, sp, -0x30
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 0x10(sp)
move s0, a0
jal 0x12bfc8
nop
lui s1, 0x47
lw t0, -0x2870(s1)
addiu t1, zero, 2
bne t0, t1, @SALIR
nop
lw t0, -0x287c(s1)
addiu t1, zero, 3
bne t0, t1, @LISTA
nop
lui t0, 0x41
lw a0, -0xb34(t0)
jal 0x25c2c8
addiu a1, s1, -0x3210
LISTA:
lw t0, -0x287c(s1)
beq t0, zero, @FIN
nop
move a0, s0
jal 0x12a280
addiu a1, s1, -0x3210
FIN:
sw zero, -0x287c(s1)
sw zero, -0x2870(s1)
lw t1, -0x2838(s1)
addiu t1, t1, 1
sw t1, -0x2838(s1)
SALIR:
ld s1, 0x10(sp)
ld s0, 8(sp)
ld ra, 0(sp)
jr ra
addiu sp, sp, 0x30
"""

ENVOLTORIO_MOD = """
addiu sp, sp, -0x30
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 0x10(sp)
move s0, a0
lui s1, 0x47
lw t0, -0x2870(s1)
addiu t1, zero, 1
beq t0, t1, @J2
nop
lw t1, -0x2864(s1)
addiu t1, t1, 1
sw t1, -0x2864(s1)
jal 0x129090
nop
beq v0, zero, @SALIR
nop
sw zero, -0x287c(s1)
sw zero, -0x2848(s1)
addiu t0, s0, 0x30
addiu t1, s1, -0x3210
addiu t2, zero, 0x8c
COPIA:
lq t3, 0(t0)
sq t3, 0(t1)
addiu t0, t0, 0x10
addiu t2, t2, -1
bne t2, zero, @COPIA
addiu t1, t1, 0x10
addiu t1, s1, -0x3210
sw t1, 0x54(t1)
sw t1, 0x29c(t1)
sw t1, 0x56c(t1)
sw t1, 0x69c(t1)
sw t1, 0x7ac(t1)
sw t1, 0x84c(t1)
addiu t2, t1, 0x4f0
sw t2, 0x32c(t1)
sw zero, 0xb0(t1)
addiu t2, zero, 0x1c
sw t2, 0x8a4(t1)
addiu t2, s1, -0x2440
sw t2, 0x2a0(t1)
sq zero, 0(t2)
sq zero, 0x10(t2)
lw t2, -0x2840(s1)
addiu t2, t2, 1
sw t2, -0x2840(s1)
addiu t1, zero, 1
sw t1, -0x2870(s1)
move v0, zero
beq zero, zero, @SALIR
nop
J2:
lw t1, -0x286c(s1)
addiu t1, t1, 1
sw t1, -0x286c(s1)
move a0, s0
jal 0x12bd98
lw a1, 0x5ab0(s0)
lw t1, -0x2860(s1)
addiu t1, t1, 1
sw t1, -0x2860(s1)
lw t0, 0x10(v0)
lw t0, 4(t0)
addiu a1, t0, 0x20
lui a0, 0x47
jal 0x139c68
addiu a0, a0, -0x3210
lw t1, -0x2868(s1)
addiu t1, t1, 1
sw t1, -0x2868(s1)
sw v0, -0x285c(s1)
beq v0, zero, @SALIR
nop
lui a1, 0x47
addiu a1, a1, -0x3210
addiu t1, zero, 1
sw t1, 0xc4(a1)
lui t0, 0x41
jal 0x16e660
lw a0, -0xb2c(t0)
lui a1, 0x47
addiu a1, a1, -0x3210
addiu t1, zero, 2
sw t1, 0xc4(a1)
lw t0, 0x100(a1)
lw t1, 0x130(s0)
bne t0, t1, @NOAPARTAR
lui t0, 0x3f80
.word 0x44880800
.word 0xC4A000A0
.word 0x46010000
.word 0xE4A000A0
.word 0xC4A00100
.word 0x46010000
.word 0xE4A00100
.word 0xC4A00190
.word 0x46010000
.word 0xE4A00190
NOAPARTAR:
lw t1, -0x2858(s1)
addiu t1, t1, 1
sw t1, -0x2858(s1)
addiu t1, zero, 2
sw t1, -0x2870(s1)
addiu v0, zero, 1
SALIR:
ld s1, 0x10(sp)
ld s0, 8(sp)
ld ra, 0(sp)
jr ra
addiu sp, sp, 0x30
"""

POR_CUADRO_MOD = """
addiu sp, sp, -0x30
sd ra, 0(sp)
sd s0, 8(sp)
.word SWC1
jal 0x13bac8
nop
lui s0, 0x47
lw t0, -0x2870(s0)
addiu t1, zero, 2
bne t0, t1, @SALIR
nop
lw t0, -0x287c(s0)
addiu t1, zero, 3
beq t0, t1, @CORRER
nop
addiu t1, zero, 1
beq t0, t1, @ATAR
nop
lw t1, -0x2848(s0)
addiu t1, t1, 1
sw t1, -0x2848(s0)
slti t2, t1, ESPERA_N
bne t2, zero, @SALIR
nop
lui t0, 0x41
lw t0, -0xb30(t0)
lw t1, 0x5b8(t0)
lui t2, 0x58
ori t2, t2, 0x58a0
beq t1, t2, @OTRO_PUERTO
addiu t1, t2, 0x16c
move t1, t2
OTRO_PUERTO:
addiu a1, s0, -0x3210
sw t1, 0x588(a1)
sw t1, 0x6d0(a1)
sw t1, 0x7c8(a1)
addiu t2, a1, 0x4f0
sw t2, 0x32c(a1)
CABECEO_BLOQUE
jal 0x12a158
move a0, t0
addiu t1, zero, 1
beq zero, zero, @SALIR
sw t1, -0x287c(s0)
ATAR:
lui t0, 0x41
lw a0, -0xb34(t0)
jal 0x25c210
addiu a1, s0, -0x3210
lw t1, -0x283c(s0)
addiu t1, t1, 1
sw t1, -0x283c(s0)
addiu t1, zero, 3
beq zero, zero, @SALIR
sw t1, -0x287c(s0)
CORRER:
addiu t1, zero, 1
sw t1, -0x210c(s0)
addiu a0, s0, -0x3210
.word LWC1
jal 0x13bac8
nop
addiu a0, s0, -0x3210
lw t0, 0x10(a0)
lh t1, 8(t0)
lw t2, 0xc(t0)
addu a0, a0, t1
.word LWC1
jalr t2
nop
sw zero, -0x210c(s0)
lw t1, -0x2880(s0)
addiu t1, t1, 1
sw t1, -0x2880(s0)
RECARGA_BLOQUE
TITERE_BLOQUE
SALIR:
ld s0, 8(sp)
ld ra, 0(sp)
jr ra
addiu sp, sp, 0x30
"""


# (88) B2b en el stub: EL TITERE. Lo que titere.py hacia por PINE (85): cada cuadro, despues del
# update de J2, copiar su matriz (J2+0x70..+0xAF, 16 palabras) al aliado 1 del pool de actores
# (*(0x0040F514) + 0x90 + 0x3C0). Con lw/sw y no lq/sq: la alineacion del pool no esta medida y
# sq con direccion desalineada escribe en OTRO lado sin avisar (el EE ignora los 4 bits bajos).
# Guardas: pool no nulo, entrada de tipo (+0x328) no nula y bando (+0x3A4) = 0 -- un nivel cuyo
# actor 1 sea enemigo o este vacio no se toca.
TITERE_MOD = """
jal ELEGIR_N
nop
beq v0, zero, @SALIR
nop
addiu t2, s0, -0x31a0
addiu t1, v0, 0x70
addiu t3, zero, 16
COPIAT:
lw t4, 0(t2)
sw t4, 0(t1)
addiu t2, t2, 4
addiu t3, t3, -1
bne t3, zero, @COPIAT
addiu t1, t1, 4
.word 0xc44000a0
lui t4, 0x3e9a
.word 0x448c0800
.word 0x46010000
.word 0xe44000a0
lw t1, -0x2834(s0)
addiu t1, t1, 1
sw t1, -0x2834(s0)
"""
# (93h) EL TITERE POR NIVEL. El aliado 1 fijo servia en 4 de 8 niveles: el censo del pool (censo_titere.py)
# mostro que +0x38C = 4 es un bloque SIN ALTA (sin controlador de colision en +0xB4, no se dibuja) y que el
# aliado vivo no siempre es el 1 (Town: el 0; el 1 es enemigo). ELEGIR recorre los 16 primeros actores del
# pool y devuelve (y deja en TITERE_ACT) el primero con tipo != 0, bando 0, +0x38C = 0 y +0xB4 != 0; 0 si no
# hay. Hoja: solo t0..t3 y v0. El filtro de ocultar_pasada lee TITERE_ACT.
# (93i) Despues de copiar, la x del titere (+0xA0) se corre +0,3 m (lwc1/mtc1/add.s/swc1 como .word): un
# soldado con controlador de colision puesto EXACTAMENTE sobre J2 cuelga el EE en FUN_0033DD98 (cuenta
# basura), igual que J2 encima de J en (93c).
ELEGIR = 0x0046DE00            # .bss en cero (libre 0x0046DE00..0x0046F800, docs/14)
TITERE_ACT = 0x0046DEF0        # dato: el titere elegido en el ultimo cuadro (0 = ninguno). No va en el pnach
ELEGIR_MOD = """
lui t0, 0x41
lw t0, -0xaec(t0)
beq t0, zero, @EL_NADA
addiu t1, t0, 0x90
addiu t3, zero, 16
EL_BUCLE:
lw t2, 0x328(t1)
beq t2, zero, @EL_SIG
nop
lw t2, 0x3a4(t1)
bne t2, zero, @EL_SIG
nop
lw t2, 0x38c(t1)
bne t2, zero, @EL_SIG
nop
lw t2, 0xb4(t1)
bne t2, zero, @EL_FIN
nop
EL_SIG:
addiu t3, t3, -1
bne t3, zero, @EL_BUCLE
addiu t1, t1, 0x3c0
EL_NADA:
move t1, zero
EL_FIN:
lui t0, 0x47
sw t1, -0x2110(t0)
jr ra
move v0, t1
"""
SIN_TITERE = False   # `poner --sin-titere`: el control de (88) (el aliado no se escribe)

# (92) LA RECARGA DE J2. Para el jugador (+0xC4 = 2) FUN_00156dc0 pone el arma en estado 4 (5: de a un
# cartucho) y NO llena el cargador: lo llena FUN_00158ae0 cuando la animacion de la vista en primera
# persona manda el evento 0xB12FC567E6600000, y esa vista es una sola y es de J. J2 nunca lo recibe:
# medido en su partida, estado 4 y cargador 0 durante horas. El arreglo hace lo que el juego hace con
# un PNJ (FUN_00156dc0, rama +0xC4 != 2): tras RECARGA_N cuadros en 4/5, estado 0 y FUN_00156d60(arma)
# (el llenado del juego, que descuenta la reserva de J2). `poner --sin-recarga` es el control.
RECARGA_MOD = """
addiu t0, s0, -0x3210
lw t0, 0x2a4(t0)
beq t0, zero, @REC_FIN
nop
lw t1, 0xd8(t0)
addiu t1, t1, -4
sltiu t1, t1, 2
beq t1, zero, @REC_CERO
lw t1, -0x2830(s0)
addiu t1, t1, 1
slti t2, t1, RECARGA_N
bne t2, zero, @REC_FIN
sw t1, -0x2830(s0)
sw zero, 0xd8(t0)
jal 0x156d60
move a0, t0
REC_CERO:
sw zero, -0x2830(s0)
REC_FIN:
"""
RECARGA_N = 90
SIN_RECARGA = False

# (88c) EL CABECEO DE J2. La matriz +0xD0 del jugador tiene la misma convencion para J y J2 (medido);
# J acierta por otro camino y J2 dispara por ella, con el cabeceo al reves. Negar mira+0xC alrededor del
# update de J2 en el stub NO llega a +0xD0 (medido: se arma en otro lado). Lo que hace (85)
# --pitch-invertido, pero en el mod: UNA vez, al preparar el control2, el cabeceo de la mira de J2
# (t2 = J2+0x4F0) se guarda NEGADO (bit 31 de +0xC) y se invierte su bandera "invertir Y" (+0xF1, la
# que lee FUN_0013F618), para que el mando 2 lo siga moviendo para el mismo lado.
CABECEO_MOD = """
lbu t3, 0xf1(t2)
xori t3, t3, 1
sb t3, 0xf1(t2)
lw t3, 0xc(t2)
lui t4, 0x8000
xor t3, t3, t4
sw t3, 0xc(t2)
"""
SIN_CABECEO = False  # `poner --sin-cabeceo`: el control de (88c)
ALIADO = 1


# (93l) LA VISTA EN PRIMERA PERSONA ES UNA SOLA ((91), (93j)): el objeto *(*(0x0040F510)+0xCBD8)+0xC, y el codigo
# de armas le cambia el estado a cualquier jugador (+0xC4 = 2). Visto en pantalla (93k): cuando J2 recarga, las
# DOS mitades hacen la recarga. El aislamiento: el por cuadro prende AISLAR_BANDERA mientras actualiza a J2, y la
# entrada de las 5 funciones que cambian la vista salta a un envoltorio que, con la bandera prendida, vuelve sin
# hacer nada (v0 = 0); si no, ejecuta las dos instrucciones que desplazo el gancho y sigue en la original + 8.
# Las consultas (FUN_001D74C8, FUN_001D7278) no se tocan. `instalar --sin-aislar` es el control.
AISLAR_BANDERA = 0x0046DEF4    # dato, no va en el pnach
AISLAR = 0x0046DF00            # 5 envoltorios de 15 palabras
AISLAR_CUENTAS = 0x0046E040    # por envoltorio k: +8k pasadas (bandera apagada), +8k+4 salteadas. No va en el pnach
EVENTO_FP = 0x001E80C0         # (93m) el callback de eventos de animacion -> vista FP (palabras 27BDFFE0 7FB00010)
AISLAR_EVENTO = 0x0046E070     # su envoltorio, 16 palabras
FP_ENTRADAS = [                # (funcion, sus dos primeras palabras en el ELF)
    (0x001D6E78, 0x27BDFF80, 0x7FB10060),   # conjunto de animaciones del arma (cambiar de arma)
    (0x001D7360, 0x27BDFFF0, 0x0080182D),
    (0x001D7500, 0x27BDFF10, 0x7FB000E0),
    (0x001D73D8, 0x27BDFFE0, 0x7FB00010),   # la llama el llenado del cargador (FUN_00158AE0)
    (0x001D6F90, 0x27BDFFE0, 0x7FB00010),   # 4 caminos del disparo/arma
]
SIN_AISLAR = False


def aislar():
    """[(pc, palabra, texto)] de los envoltorios, y los ganchos de entrada."""
    prog, ganchos = [], []
    for k, (f, w0, w1) in enumerate(FP_ENTRADAS):
        base = AISLAR + 0x3C * k
        pasa, saltea = AISLAR_CUENTAS + 8 * k - 0x470000, AISLAR_CUENTAS + 8 * k + 4 - 0x470000
        fuente = """
lui t9, 0x47
lw t8, -0x210c(t9)
bne t8, zero, @SK%d
lw t8, %d(t9)
addiu t8, t8, 1
sw t8, %d(t9)
.word 0x%08x
.word 0x%08x
j 0x%x
nop
SK%d:
lw t8, %d(t9)
addiu t8, t8, 1
sw t8, %d(t9)
jr ra
move v0, zero
""" % (k, pasa, pasa, w0, w1, f + 8, k, saltea, saltea)
        prog += j2.ensamblar_programa(fuente, base, base + 0x3C)
        ganchos += [(f, ensamblar("j 0x%x" % base, f), "gancho vista FP: j aislar %d (93l)" % k),
                    (f + 4, 0, "gancho vista FP: nop (93l)")]
    # (93m) LA FUGA DE LA RECARGA: la animacion del CUERPO de J2 emite eventos que el juego manda al callback
    # *(0x0040F50C)+0x964 = FUN_001E80C0(evento, &jugador), que con el arma de ESE jugador dispara la
    # animacion en la vista unica. Envoltorio: si *a1 == J2, vuelve sin hacer nada. Cuentas en +0x28/+0x2C.
    pasa, saltea = AISLAR_CUENTAS + 0x28 - 0x470000, AISLAR_CUENTAS + 0x2C - 0x470000
    fuente = """
lui t9, 0x47
lw t8, 0(a1)
addiu t7, t9, -0x3210
beq t8, t7, @SKE
lw t8, %d(t9)
addiu t8, t8, 1
sw t8, %d(t9)
.word 0x27bdffe0
.word 0x7fb00010
j 0x%x
nop
SKE:
lw t8, %d(t9)
addiu t8, t8, 1
sw t8, %d(t9)
jr ra
nop
""" % (pasa, pasa, EVENTO_FP + 8, saltea, saltea)
    prog += j2.ensamblar_programa(fuente, AISLAR_EVENTO, AISLAR_EVENTO + 0x40)
    ganchos += [(EVENTO_FP, ensamblar("j 0x%x" % AISLAR_EVENTO, EVENTO_FP), "gancho evento FP: j filtro J2 (93m)"),
                (EVENTO_FP + 4, 0, "gancho evento FP: nop (93m)")]
    return prog, ganchos


def aliado(p):
    """(93h) el titere que eligio el stub en el ultimo cuadro; si todavia no eligio, el aliado 1 de antes."""
    t = p.leer32(TITERE_ACT)
    if t:
        return t
    act = p.leer32(0x0040F514)
    return act + 0x90 + ALIADO * 0x3C0 if act else 0


def programas():
    """[(nombre, [(pc, palabra, texto)])] -- lo unico que va en el pnach, junto con los ganchos."""
    env = j2.ensamblar_programa(ENVOLTORIO_MOD, j2.ENVOLTORIO, j2.ARMAS2)
    fuente = POR_CUADRO_MOD.replace("ESPERA_N", str(CUADROS_ESPERA))
    fuente = fuente.replace("RECARGA_BLOQUE", "" if SIN_RECARGA else
                            RECARGA_MOD.replace("RECARGA_N", str(RECARGA_N)))
    fuente = fuente.replace("TITERE_BLOQUE", "" if SIN_TITERE else
                            TITERE_MOD.replace("ELEGIR_N", "0x%x" % ELEGIR))
    fuente = fuente.replace("CABECEO_BLOQUE", "" if SIN_CABECEO else CABECEO_MOD)
    pc = j2.ensamblar_programa(fuente, j2.STUB, 0x0046D9F0)
    des = j2.ensamblar_programa(DESARME_MOD, DESARME, 0x0046DE00)
    # (88e) la pantalla dividida en el mismo bloque: el stub de pantalla_dividida.py (raster leido en vivo,
    # solo con J2 corriendo, la vista de J2 calculada por el stub) y sus constantes. El pnach las reescribe
    # cada cuadro, asi que son constantes de verdad: division prendida, mitad 320, entero 640, fuente = stub.
    pant = [(pd.STUB + 4 * i, w, "pantalla dividida %d" % i) for i, w in enumerate(pd.codigo())]
    pant_datos = [(pd.DATOS + 0x80, 1, "division prendida"), (pd.DATOS + 0x8C, pd.MEDIO, "ancho de la mitad"),
                  (pd.DATOS + 0x90, pd.ENTERO, "ancho entero"), (pd.DATOS + 0x94, 1, "la vista de J2 la calcula el stub"),
                  (pd.DATOS + 0x38, 1, "proporcion de la mitad (89)")]
    ganchos = [(g.SITIO, ensamblar("jal 0x%x" % j2.STUB, g.SITIO), "gancho por cuadro: jal stub (era jal 0x13bac8)"),
               (j2.SITIO_CARGA, ensamblar("jal 0x%x" % j2.ENVOLTORIO, j2.SITIO_CARGA),
                "gancho del cargador: jal envoltorio (era jal 0x129090)")]
    if not SIN_BAJA:
        ganchos.append((SITIO_DESARME, ensamblar("jal 0x%x" % DESARME, SITIO_DESARME),
                        "gancho del desarme: jal baja (era jal 0x12bfc8)"))
    progs = [("envoltorio", env), ("por cuadro", pc), ("desarme", des)]
    if not SIN_TITERE:
        progs.append(("elegir titere", j2.ensamblar_programa(ELEGIR_MOD, ELEGIR, TITERE_ACT)))
    if not SIN_PANTALLA:
        filtro = [(pd.FILTRO + 4 * i, w, t) for i, (w, t) in enumerate(zip(pd.codigo_filtro(), pd.FILTRO_FUENTE))]
        progs += [("pantalla", pant), ("pantalla datos", pant_datos), ("filtro del tinte", filtro)]
        ganchos += [(s, ensamblar("jal 0x%x" % pd.STUB, s), "gancho de la escena: jal pantalla (era jal 0x1297e0)")
                    for s in pd.SITIOS]
        ganchos.append((pd.SITIO_FILTRO, ensamblar("jal 0x%x" % pd.FILTRO, pd.SITIO_FILTRO),
                        "gancho del tinte: jal filtro (era jal 0x1b0ac8) (89b)"))
        if not SIN_OCULTAR:
            # (93) visibilidad por pasada: J2 no se dibuja en la vista de J, ni el titere en la de J2
            ocu = [(oc.OCULTAR + 4 * i, w, "ocultar por pasada %d" % i) for i, w in enumerate(oc.codigo())]
            progs += [("ocultar por pasada", ocu),
                      ("ocultar datos", [(oc.A, oc.J2, "pasada 1: no dibujar a J2"),
                                         (oc.B, 1, "pasada 2: no dibujar al titere")])]
            ganchos += [(a, w, "gancho del dibujo de la escena: callback ocultar (era 0x1297a0) (93)")
                        for a, w in oc.ganchos()]
    if not SIN_AISLAR:
        ais, gan = aislar()
        progs.append(("aislar vista FP", [x for x in ais if x[0] < AISLAR_CUENTAS]))
        progs.append(("aislar evento FP", [x for x in ais if x[0] >= AISLAR_EVENTO]))
        ganchos += gan
    return progs + [("ganchos", ganchos)]


SIN_OCULTAR = False  # `poner --sin-ocultar`: el control de (93)


SIN_PANTALLA = False  # `poner --sin-pantalla`: el mod sin la pantalla dividida (como hasta (88d))


SIN_BAJA = False   # `poner --sin-baja`: el control de B3.3 (la baja de J2 no se engancha)
ORIGINAL_DESARME = ensamblar("jal 0x12bfc8", SITIO_DESARME)


def depurador(accion):
    dep = str(Path(__file__).resolve().parent / "depurador.py")
    return subprocess.run([sys.executable, dep, accion], capture_output=True, text=True)


def cmd_listar(_a):
    for nombre, prog in programas():
        print("== %s: %d palabras, %#010x..%#010x" % (nombre, len(prog), prog[0][0], prog[-1][0] + 4))
        for pc, w, t in prog:
            print("0x%08X  %08X  %s" % (pc, w, t))
    return 0


def cmd_poner(a):
    global SIN_BAJA, SIN_TITERE, SIN_CABECEO, SIN_PANTALLA, SIN_RECARGA, SIN_OCULTAR
    SIN_OCULTAR = a.sin_ocultar
    SIN_BAJA, SIN_TITERE, SIN_CABECEO = a.sin_baja, a.sin_titere, a.sin_cabeceo
    SIN_RECARGA = a.sin_recarga
    SIN_PANTALLA = a.sin_pantalla
    progs = programas()
    with Pine() as p:
        if (p.leer32(g.SITIO) != g.ORIGINAL or p.leer32(j2.SITIO_CARGA) != j2.ORIGINAL_CARGA
                or p.leer32(SITIO_DESARME) != ORIGINAL_DESARME
                or any(p.leer32(s) != pd.ORIGINAL for s in pd.SITIOS)
                or p.leer32(pd.SITIO_FILTRO) != ensamblar("jal 0x1b0ac8", pd.SITIO_FILTRO)
                or p.leer32(oc.GANCHO_LUI) != ensamblar(oc.ORIG_LUI, oc.GANCHO_LUI)):
            print(json.dumps({"error": "un gancho ya esta puesto o el sitio cambio",
                              "por_cuadro": hex(p.leer32(g.SITIO)), "cargador": hex(p.leer32(j2.SITIO_CARGA)),
                              "desarme": hex(p.leer32(SITIO_DESARME))}))
            return 1
        depurador("pausar")
        # lo que el arranque deja en cero: J2, sus armas y los datos del mod
        p.escribir_bloque(cj.J2, bytes(cj.TAM))
        p.escribir_bloque(j2.ARMAS2, bytes(0x20))
        for d in DATOS:
            p.escribir32(d, 0)
        p.escribir_bloque(pd.DATOS, bytes(0x98))
        for nombre, prog in progs[:-1]:
            for pc, w, _ in prog:
                p.escribir32(pc, w)
        for pc, w, _ in progs[-1][1]:
            p.escribir32(pc, w)
        ok = all(p.leer32(pc) == w for _, prog in progs for pc, w, _ in prog)
        depurador("continuar")
        print(json.dumps({"palabras": sum(len(x[1]) for x in progs), "escrito": ok, "baja": not SIN_BAJA,
                          "titere": not SIN_TITERE}))
    return 0 if ok else 1


def leer_estado(p):
    jg = p.leer32(cj.JUEGO_PTR)
    return {"cargador": p.leer32(jg + 0x5AA0), "fase": p.leer32(FASE), "moldes": p.leer32(MOLDES),
            "llam_J0": p.leer32(LLAM_J0), "llam_J2": p.leer32(LLAM_J2), "estado": p.leer32(ESTADO),
            "espera": p.leer32(ESPERA), "atadas": p.leer32(ATADAS), "desarmes": p.leer32(DESARMES),
            "cuadros_J2": p.leer32(CONTADOR), "titeres": p.leer32(TITERES),
            "J2_8A4": hex(p.leer32(cj.J2 + 0x8A4)), "J2_B4": hex(p.leer32(cj.J2 + 0xB4)),
            "J2_588": hex(p.leer32(cj.J2 + 0x588)), "J2_32C": hex(p.leer32(cj.J2 + 0x32C)),
            "J_pos": [round(x, 2) for x in cj.pos(p, cj.J)], "J2_pos": [round(x, 2) for x in cj.pos(p, cj.J2)],
            "A1_pos": [round(x, 2) for x in cj.pos(p, aliado(p))] if aliado(p) else None}


def cmd_mirar(a):
    with Pine() as p:
        ult, t0 = None, time.time()
        while time.time() - t0 < a.segundos:
            try:
                d = leer_estado(p)
                clave = {k: v for k, v in d.items() if k not in ("cuadros_J2", "titeres", "espera", "J_pos", "J2_pos", "A1_pos")}
            except Exception as ex:  # noqa: BLE001
                d = clave = {"error": str(ex)}
            if clave != ult:
                print("%5.1f s %s" % (time.time() - t0, json.dumps(d, ensure_ascii=False)))
                ult = clave
            time.sleep(0.25)
        print("final  %s" % json.dumps(leer_estado(p), ensure_ascii=False))
    return 0


def cmd_manos(a):
    """Las manos de la prueba: clonar el mando 2 en el falso 2 y empujar el eje adelante."""
    with Pine() as p:
        ctrl2 = p.leer32(cj.J2 + 0x588)
        # (86) J2 recien copiado tiene el control DE J: sin este freno, `manos` le
        # redirigia a J el mando al falso 2 (paso en la segunda carga)
        if not ctrl2 or ctrl2 == p.leer32(p.leer32(cj.JUEGO_PTR) + 0x30 + 0x588):
            print(json.dumps({"error": "el mod todavia no preparo el control2 (J2+0x588 = %#x)" % ctrl2}))
            return 1
        fuente = p.leer32(ctrl2 + 0xC)
        if fuente != cj.FALSO2:
            f2 = bytearray(p.leer_bloque(fuente, 0xF0))
            for o in range(0x8C, 0xCC, 4):
                f2[o:o + 4] = b"\0\0\0\0"
            f2[0x0E:0x2A + 28] = bytes(0x2A + 28 - 0x0E)
            p.escribir_bloque(cj.FALSO2, bytes(f2))
            p.escribir32(ctrl2 + 0xC, cj.FALSO2)
        al = aliado(p)
        antes, a_antes, t_antes = cj.pos(p, cj.J2), cj.pos(p, al), p.leer32(TITERES)
        p.escribir_f32(cj.FALSO2 + 0x8C, 0.0 if a.control else 0.8)
        t0, dmax = time.time(), 0.0
        while time.time() - t0 < a.segundos:
            dmax = max(dmax, math.dist(cj.pos(p, cj.J2), cj.pos(p, al)))
            time.sleep(0.05)
        p.escribir_f32(cj.FALSO2 + 0x8C, 0.0)
        time.sleep(0.3)
        despues, a_despues = cj.pos(p, cj.J2), cj.pos(p, al)
        print(json.dumps({"ctrl2": hex(ctrl2), "fuente_original": hex(fuente), "control": a.control,
                          "J2_antes": [round(x, 2) for x in antes], "J2_despues": [round(x, 2) for x in despues],
                          "metros": round(math.dist(antes, despues), 2),
                          "aliado": hex(al), "aliado_metros": round(math.dist(a_antes, a_despues), 2),
                          "aliado_J2_final_m": round(math.dist(despues, a_despues), 3),
                          "aliado_J2_max_m": round(dmax, 3), "titeres": p.leer32(TITERES) - t_antes}))
    return 0


def cmd_quitar(_a):
    with Pine() as p:
        p.escribir32(g.SITIO, g.ORIGINAL)
        p.escribir32(j2.SITIO_CARGA, j2.ORIGINAL_CARGA)
        p.escribir32(SITIO_DESARME, ORIGINAL_DESARME)
        for s in pd.SITIOS:
            p.escribir32(s, pd.ORIGINAL)
        p.escribir32(pd.SITIO_FILTRO, ensamblar("jal 0x1b0ac8", pd.SITIO_FILTRO))
        # (93) el lui/addiu del callback van juntos: a medias, la escena salta a cualquier lado
        depurador("pausar")
        p.escribir32(oc.GANCHO_LUI, ensamblar(oc.ORIG_LUI, oc.GANCHO_LUI))
        p.escribir32(oc.GANCHO_ADDIU, ensamblar(oc.ORIG_ADDIU, oc.GANCHO_ADDIU))
        depurador("continuar")
    return 0


def cmd_toml(_a):
    raiz = Path(__file__).resolve().parent.parent
    lineas = ['# GENERADO por herramientas/coop_mod.py toml -- no editar a mano: la fuente son los',
              '# programas de coop_mod.py (bitacora (86)). Solo CODIGO: los datos nacen del .bss en cero.',
              'nombre = "COOP -- jugador 2 (B3)"', 'autor = "proyecto BLACK"',
              'descripcion = "J2 construido en la carga, mando 2, enlazado y atado; sin PINE"',
              'habilitado = false', 'cuando = "continuo"', '']
    for nombre, prog in programas():
        for pc, w, t in prog:
            lineas += ["[[parche]]", "direccion = 0x%08X" % pc, 'tipo = "u32"', "valor = 0x%08X" % w,
                       'nota = "%s: %s"' % (nombre, t.replace('"', "'")), ""]
    ruta = raiz / "mods" / "coop.toml"
    ruta.write_text("\n".join(lineas), encoding="utf-8", newline="\n")
    print(json.dumps({"toml": str(ruta), "parches": sum(len(x[1]) for x in programas())}))
    return 0


# --- la entrega: un bloque con nombre en el pnach de PARCHES de PCSX2 ----------------
# Fran juega con Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach (bloques con nombre) y
# prende cada uno con `Enable = <nombre>` en gamesettings\SLUS-21376_5C891FF1.ini [Patches].
# `instalar` pone (o reemplaza) el bloque APAGADO; `activar`/`desactivar` tocan solo esa linea.
# Lo mide el emulog: "Enabled patch: <nombre>" al arrancar el juego.
PCSX2 = Path.home() / "Documents" / "PCSX2"
PARCHES = PCSX2 / "patches" / "SLUS-21376_5C891FF1.pnach"
AJUSTES = PCSX2 / "gamesettings" / "SLUS-21376_5C891FF1.ini"
NOMBRE_BLOQUE = "COOP - jugador 2 (B3)"


def bloque_pnach():
    lineas = ["[%s]" % NOMBRE_BLOQUE, "author=proyecto BLACK",
              "description=J2 construido en la carga, mando 2, enlazado y atado; sin PINE (bitacora (86))",
              "// GENERADO por herramientas/coop_mod.py -- solo CODIGO: los datos nacen del .bss en cero"]
    for nombre, prog in programas():
        for pc, w, t in prog:
            lineas.append("// %s: %s" % (nombre, t))
            lineas.append("patch=1,EE,%08X,word,%08X" % (pc, w))
    return "\n".join(lineas) + "\n"


def _sin_bloque(texto):
    """El pnach sin el bloque del coop (desde su encabezado hasta el encabezado siguiente)."""
    out, dentro = [], False
    for l in texto.splitlines(keepends=True):
        if l.startswith("["):
            dentro = l.strip() == "[%s]" % NOMBRE_BLOQUE
        if not dentro:
            out.append(l)
    return "".join(out)


def _respaldo(ruta):
    r = ruta.with_name(ruta.name + ".bak-" + time.strftime("%Y%m%d-%H%M%S"))
    r.write_bytes(ruta.read_bytes())
    return r


def cmd_instalar(_a):
    global SIN_AISLAR
    SIN_AISLAR = getattr(_a, "sin_aislar", False)
    viejo = PARCHES.read_bytes().decode("utf-8")
    base = _sin_bloque(viejo).rstrip("\r\n")
    nl = "\r\n" if "\r\n" in viejo else "\n"
    nuevo = base + nl + nl + bloque_pnach().replace("\n", nl)
    if nuevo == viejo:
        print(json.dumps({"pnach": str(PARCHES), "cambio": False}))
        return 0
    r = _respaldo(PARCHES)
    PARCHES.write_bytes(nuevo.encode("utf-8"))
    print(json.dumps({"pnach": str(PARCHES), "respaldo": r.name, "palabras": sum(len(x[1]) for x in programas()),
                      "ajuste_intacto": "Enable = %s" % NOMBRE_BLOQUE not in AJUSTES.read_text(encoding="utf-8")}))
    return 0


def _ajustes(activar):
    t = AJUSTES.read_bytes().decode("utf-8")
    nl = "\r\n" if "\r\n" in t else "\n"
    linea = "Enable = %s" % NOMBRE_BLOQUE
    ls = [l for l in t.split(nl) if l.strip() != linea]
    if activar:
        i = ls.index("[Patches]")
        ls.insert(i + 1, linea)
    nuevo = nl.join(ls)
    if nuevo != t:
        _respaldo(AJUSTES)
        AJUSTES.write_bytes(nuevo.encode("utf-8"))
    print(json.dumps({"ajustes": str(AJUSTES), "activo": linea in nuevo.split(nl), "cambio": nuevo != t}))
    return 0


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    for c in ("listar", "quitar", "toml", "activar", "desactivar"):
        sub.add_parser(c)
    ins = sub.add_parser("instalar"); ins.add_argument("--sin-aislar", action="store_true")
    po = sub.add_parser("poner"); po.add_argument("--sin-baja", action="store_true")
    po.add_argument("--sin-titere", action="store_true")
    po.add_argument("--sin-recarga", action="store_true")
    po.add_argument("--sin-ocultar", action="store_true")
    po.add_argument("--sin-cabeceo", action="store_true")
    po.add_argument("--sin-pantalla", action="store_true")
    m = sub.add_parser("mirar"); m.add_argument("segundos", type=float)
    h = sub.add_parser("manos"); h.add_argument("segundos", type=float); h.add_argument("--control", action="store_true")
    a = ap.parse_args()
    return {"listar": cmd_listar, "poner": cmd_poner, "mirar": cmd_mirar, "manos": cmd_manos,
            "quitar": cmd_quitar, "toml": cmd_toml, "instalar": cmd_instalar,
            "activar": lambda _a: _ajustes(True), "desactivar": lambda _a: _ajustes(False)}[a.cmd](a)


if __name__ == "__main__":
    sys.exit(main())
