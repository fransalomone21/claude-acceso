#!/usr/bin/env python3
"""jugador2.py -- el prototipo del COOP: un segundo jugador construido por el juego (bitacora (78), P6).

Usa el gancho de la sonda 6 (0x00129574, una vez por cuadro) con un stub que,
ademas de llamar al controlador del jugador 0, maneja un ESTADO en 0x0046D784:
  1 -> llama FUN_00129090(juego, -577) cada cuadro hasta que devuelve 1. OJO (79): -577 construye en
       0x0046D1F0, ENCIMA de este stub y del envoltorio; no usar el estado 1 (P6/P6b colgaron por eso)
  2 -> FUN_0012a158(juego, J2): lo engancha a la lista del mundo y a la grilla
  3 -> cada cuadro: controlador de J2 (FUN_0013bac8) y su update (vtable +0xC),
       y suma 1 al contador 0x0046D780
El bloque se prepara antes como COPIA del jugador 0 (vtables y autopunteros
reubicados, clon_jugador.poner) porque el constructor de C++ de jugadores[]
corre una sola vez, para N = 1.

    python herramientas/jugador2.py listar
    python herramientas/jugador2.py poner          # molde + stub + gancho, estado 0
    python herramientas/jugador2.py estado <n>     # escribe el estado (1 = construir)
    python herramientas/jugador2.py mirar 10       # registra estado, contador y posiciones
    python herramientas/jugador2.py atar           # (82) controlador de colision para J2: sin esto no camina
    python herramientas/jugador2.py quitar         # devuelve la palabra original del gancho
"""

import argparse
import json
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
from mips import ensamblar  # noqa: E402
import clon_jugador as cj  # noqa: E402
import gancho as g  # noqa: E402

STUB = 0x0046D800
ESTADO = 0x0046D784
CONTADOR = 0x0046D780
SWC1_F12 = 0xE7AC0018   # swc1 f12, 0x18(sp)  (mips.py no ensambla FPU)
LWC1_F12 = 0xC7AC0018   # lwc1 f12, 0x18(sp)

PROGRAMA = """
addiu sp, sp, -0x30
sd ra, 0(sp)
sd s0, 8(sp)
.word SWC1
jal 0x13bac8
nop
lui s0, 0x47
lw t0, -0x287c(s0)
addiu t1, zero, 1
beq t0, t1, @CONSTRUIR
nop
addiu t1, zero, 2
beq t0, t1, @ENLAZAR
nop
addiu t1, zero, 3
beq t0, t1, @CORRER
nop
beq zero, zero, @SALIR
nop
CONSTRUIR:
lw t1, -0x2878(s0)
addiu t1, t1, 1
sw t1, -0x2878(s0)
lui t0, 0x41
lw a0, -0xb30(t0)
addiu a1, zero, -577
jal 0x129090
nop
lw t1, -0x2874(s0)
addiu t1, t1, 1
sw t1, -0x2874(s0)
beq v0, zero, @SALIR
nop
addiu t1, zero, 2
sw t1, -0x287c(s0)
beq zero, zero, @SALIR
nop
ENLAZAR:
lui t0, 0x41
lw a0, -0xb30(t0)
lui a1, 0x47
addiu a1, a1, -0x3210
jal 0x12a158
nop
addiu t1, zero, 3
sw t1, -0x287c(s0)
beq zero, zero, @SALIR
nop
CORRER:
lui a0, 0x47
addiu a0, a0, -0x3210
.word LWC1
jal 0x13bac8
nop
lui a0, 0x47
addiu a0, a0, -0x3210
lw t0, 0x10(a0)
lh t1, 8(t0)
lw t2, 0xc(t0)
addu a0, a0, t1
.word LWC1
jalr t2
nop
lw t1, -0x2880(s0)
addiu t1, t1, 1
sw t1, -0x2880(s0)
SALIR:
ld s0, 8(sp)
ld ra, 0(sp)
jr ra
addiu sp, sp, 0x30
"""


# --- P7: construir a J2 DURANTE la carga (bitacora (79)) ---------------------
# El cargador (FUN_00128480, estado 0x12) hace `jal 0x129090` en 0x00128EA4 con
# a0 = juego (hueco de retardo) y a1 = indice. El envoltorio llama la original;
# cuando devuelve 1 (jugador 0 hecho) pasa a la fase 1 y le devuelve 0 al
# cargador, que lo vuelve a llamar el cuadro siguiente; en la fase 1 llama
# FUN_00129090 replicada por partes con J2 = 0x0046CDF0 (el indice -577 da 0x0046D1F0, encima del
# envoltorio: la causa de P6-P9), y recien ahi devuelve 1. Alrededor del registro fisico (FUN_0016e660)
# J2+0xC4 = TIPO_REG: el pool de cuerpos del tipo 2 (jugador) tiene cuenta 1; el del tipo 1, 16 libres.
SITIO_CARGA = 0x00128EA4
ORIGINAL_CARGA = 0x0C04A424    # jal 0x00129090 (medido en vivo)
ENVOLTORIO = 0x0046DA00
FASE = 0x0046D790              # 0 jugador 0, 1 construyendo J2, 2 hecho
LLAMADAS_J2 = 0x0046D794
LLAMADAS_J0 = 0x0046D79C
ARMAS2 = 0x0046DBC0            # arreglo de armas propio de J2 (J+0x2A0 es de arranque)
# migas del camino de J2 (FUN_00129090 replicada por partes, P10):
MIGA_A = 0x0046D7A0            # volvio FUN_0012bd98 (punto de aparicion)
MIGA_B = 0x0046D798            # volvio FUN_00139c68 (el constructor)
MIGA_V0 = 0x0046D7A4           # lo que devolvio el constructor
MIGA_C = 0x0046D7A8            # volvio FUN_0016e660 (el registro)

ENVOLTORIO_PROG = """
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
lw t0, -0x2870(s1)
bne t0, zero, @SALIR
nop
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
lui t2, 0x41
lw t3, -0xaf4(t2)
sw t3, -0x2850(s1)
lw t4, -0x284c(s1)
beq t4, zero, @SINCOPIA
nop
sw t4, -0xaf4(t2)
SINCOPIA:
lui a0, 0x47
jal 0x139c68
addiu a0, a0, -0x3210
lw t4, -0x284c(s1)
beq t4, zero, @SINREST
nop
lui t2, 0x41
lw t3, -0x2850(s1)
sw t3, -0xaf4(t2)
SINREST:
lw t1, -0x2868(s1)
addiu t1, t1, 1
sw t1, -0x2868(s1)
sw v0, -0x285c(s1)
beq v0, zero, @SALIR
nop
lui a1, 0x47
addiu a1, a1, -0x3210
addiu t1, zero, TIPO_REG
sw t1, 0xc4(a1)
lui t0, 0x41
jal 0x16e660
lw a0, -0xb2c(t0)
lui a1, 0x47
addiu a1, a1, -0x3210
addiu t1, zero, 2
sw t1, 0xc4(a1)
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


# --- P15 (bitacora (82)): el controlador de colision de J2 --------------------
# El mover (FUN_00132D98) le entrega el desplazamiento al controlador de J+0xB4. A los
# `cuenta` = 1 jugadores de juego+0x30 se lo ata FUN_0012BE80 con FUN_0025C210; a J2, nadie
# (J2+0xB4 = 0 y no camina). `atar` reescribe, EN PAUSA, el estado 1 del stub por cuadro (el
# viejo CONSTRUIR, que no se usa) para que llame FUN_0025C210(*(0x0040F4CC), J2) una vez y
# vuelva al estado 3. Medido: J2 camina 8,14 m en 2 s a 4,5 m/s, con colision.
ATAR_PROG = """CONSTRUIR:
lw t1, -0x2878(s0)
addiu t1, t1, 1
sw t1, -0x2878(s0)
lui t0, 0x41
lw a0, -0xb34(t0)
lui a1, 0x47
addiu a1, a1, -0x3210
jal 0x25c210
nop
lw t1, -0x2874(s0)
addiu t1, t1, 1
sw t1, -0x2874(s0)
addiu t1, zero, 3
sw t1, -0x287c(s0)
beq zero, zero, @SALIR
nop
ENLAZAR:"""


def programa_atar():
    i, k = PROGRAMA.index("CONSTRUIR:"), PROGRAMA.index("ENLAZAR:")
    return PROGRAMA[:i] + ATAR_PROG + PROGRAMA[k + len("ENLAZAR:"):]


def atar(p):
    """Ata a J2 un controlador de colision (P15). Devuelve el dict de lo medido."""
    import subprocess
    dep = str(Path(__file__).resolve().parent / "depurador.py")
    if p.leer32(cj.J2 + 0xB4):
        return {"ya_atado": hex(p.leer32(cj.J2 + 0xB4))}
    nuevo = ensamblar_programa(programa_atar())
    cambios = [(pc, w) for pc, w, _ in nuevo if p.leer32(pc) != w]
    subprocess.run([sys.executable, dep, "pausar"], capture_output=True)
    for pc, w in cambios:
        p.escribir32(pc, w)
    ok = all(p.leer32(pc) == w for pc, w, _ in nuevo)
    subprocess.run([sys.executable, dep, "continuar"], capture_output=True)
    if not ok:
        return {"error": "el programa no quedo escrito"}
    p.escribir32(ESTADO, 1)
    t0 = time.time()
    while p.leer32(ESTADO) != 3 and time.time() - t0 < 5:
        time.sleep(0.05)
    ctrl = p.leer32(cj.J2 + 0xB4)
    return {"palabras": len(cambios), "estado": p.leer32(ESTADO), "J2_B4": hex(ctrl),
            "ctrl_30": hex(p.leer32(ctrl + 0x30)) if ctrl else None}


# --- N4 (bitacora (80)): ranura de personaje propia para J2 ------------------
# El sistema de personajes (*(0x0040F50C), 0x970 B) tiene DOS ranuras de 0x240 en
# +0x470, y son las dos ARMAS del unico jugador: el indice sale de J+0x2C3, que es
# el arma en la mano. J2 hereda +0x2C3 = 0 del molde y por eso apunta a la ranura
# de J0; como FUN_001a6be0 arranca leyendo *(ranura) -- el DUENO --, todo lo que
# calcula "para J2" es sobre J0, y J2 no se desplaza (bitacora (80), N3).
#
# La copia NO es un bloque: cada ranura tiene un COMPANERO de 0x9D0 B que vive
# AFUERA del objeto, en ranura+0x54, alojado por FUN_001a4ff0. Copiar solo los
# 0x970 deja las ranuras de la copia escribiendo en el estado de animacion de J0.
SISTEMA_PTR = 0x0040F50C
TAM_SISTEMA = 0x970
TAM_COMPANERO = 0x9D0
RANURA_0 = 0x470
PASO_RANURA = 0x240
COPIA_DESTINO = 0x0046DC00     # .bss en cero hasta 0x00472000 (0x4400 B); esto pide 0x22B0
GUARDA_SIS = 0x0046D7B0        # el envoltorio guarda aca el sistema original
COPIA_SIS = 0x0046D7B4         # ...y lee de aca la direccion de la copia (la escribe el host)


def plan_copia(leer32, leer_bloque, destino=COPIA_DESTINO, dueno=None):
    """Las escrituras que hacen falta para darle a J2 un sistema de personajes propio.

    NO escribe nada: devuelve (bloques, parches, mapa). Todas las reubicaciones
    se MIDEN sobre la memoria que da `leer32`/`leer_bloque` -- nunca se toman de
    una lista escrita a mano, porque la lista de un volcado no es la de la
    sesion que corre (los companeros viven en el monton y se mueven).
    """
    sis = leer32(SISTEMA_PTR)
    if not (0x00100000 <= sis < 0x02000000):
        raise ValueError("*(0x0040F50C) = %#010x no parece un objeto del EE" % sis)
    cuerpo = bytearray(leer_bloque(sis, TAM_SISTEMA))

    def alinear(x):
        return (x + 0xF) & ~0xF

    copia = alinear(destino)
    comps, comp_dest = [], []
    d = alinear(copia + TAM_SISTEMA)
    for k in (0, 1):
        c = leer32(sis + RANURA_0 + k * PASO_RANURA + 0x54)
        comps.append(c)
        comp_dest.append(d)
        d = alinear(d + TAM_COMPANERO)
    fin = d

    mapa = dict(sistema=sis, copia=copia, companeros=comps, companeros_copia=comp_dest,
                fin=fin, bytes=fin - copia)

    # --- el sistema: autopunteros medidos, +0x54 a los companeros nuevos, +0xB8 = 0
    reub = []
    for o in range(0, TAM_SISTEMA, 4):
        v = struct.unpack_from("<I", cuerpo, o)[0]
        if sis <= v < sis + TAM_SISTEMA:
            struct.pack_into("<I", cuerpo, o, copia + (v - sis))
            reub.append(("autopuntero", o, v, copia + (v - sis)))
    for k in (0, 1):
        r = RANURA_0 + k * PASO_RANURA
        struct.pack_into("<I", cuerpo, r + 0x54, comp_dest[k])
        reub.append(("companero", r + 0x54, comps[k], comp_dest[k]))
        # +0xB8 = 0: sin la bandera de atada, FUN_001a51c8 no llama a FUN_001a5ee8,
        # que soltaria el companero de J0 (medido: +0x58 = 0, asi que no liberaria
        # memoria, pero igual correria FUN_001a7450 sobre lo de J0).
        cuerpo[r + 0xB8] = 0
        reub.append(("B8=0", r + 0xB8, None, 0))
        if dueno is not None:
            # el molde 0x1C solo APUNTA: la init hace J+0x330 = global + k*0x240 + 0x470
            # y no ata. Sin esto, la ranura de la copia sigue con J0 de dueno.
            struct.pack_into("<I", cuerpo, r, dueno)
            reub.append(("dueno", r, None, dueno))

    bloques = [(copia, bytes(cuerpo), "sistema de personajes")]
    for k in (0, 1):
        cb = bytearray(leer_bloque(comps[k], TAM_COMPANERO))
        for o in range(0, TAM_COMPANERO, 4):
            v = struct.unpack_from("<I", cb, o)[0]
            if comps[k] <= v < comps[k] + TAM_COMPANERO:
                struct.pack_into("<I", cb, o, comp_dest[k] + (v - comps[k]))
                reub.append(("comp%d autopuntero" % k, o, v, comp_dest[k] + (v - comps[k])))
            elif sis <= v < sis + TAM_SISTEMA:
                struct.pack_into("<I", cb, o, copia + (v - sis))
                reub.append(("comp%d -> sistema" % k, o, v, copia + (v - sis)))
        bloques.append((comp_dest[k], bytes(cb), "companero de la ranura %d" % k))
    return bloques, reub, mapa


def ensamblar_programa(fuente=PROGRAMA, base=STUB, fin=0x0046D9F0):
    lineas = [l.strip() for l in fuente.strip().splitlines() if l.strip()]
    etiquetas, instr = {}, []
    for l in lineas:
        if l.endswith(":"):
            etiquetas[l[:-1]] = base + 4 * len(instr)
        else:
            instr.append(l)
    out = []
    for i, t in enumerate(instr):
        pc = base + 4 * i
        if t.startswith(".word"):
            out.append((pc, SWC1_F12 if "SWC1" in t else LWC1_F12, t))
            continue
        for k, v in etiquetas.items():
            t = t.replace("@" + k, "0x%x" % v)
        out.append((pc, ensamblar(t, pc), t))
    assert 0x0046D7A0 <= base and base + 4 * len(out) <= fin
    return out


def informar_copia(bloques, reub, mapa, seco):
    print("sistema  %#010x -> copia %#010x  (%#x B en total, hasta %#010x)"
          % (mapa["sistema"], mapa["copia"], mapa["bytes"], mapa["fin"]))
    for k in (0, 1):
        print("companero %d  %#010x -> %#010x" % (k, mapa["companeros"][k], mapa["companeros_copia"][k]))
    print("%d reubicaciones medidas en vivo:" % len(reub))
    for que, off, de, a_ in reub:
        print("   %-22s +%#06x  %s -> %#010x" % (que, off, ("%#010x" % de) if de else "     --   ", a_))
    for dir_, datos, nombre in bloques:
        print("%s escribir %#x B en %#010x (%s)" % ("[SECO]" if seco else "      ", len(datos), dir_, nombre))
    return mapa


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("listar")
    pn = sub.add_parser("poner")
    pn.add_argument("--desde", type=lambda s: int(s, 0), default=2,
                    help="estado inicial del constructor en J2+0x8A4 (0x37 cuelga: P6)")
    cp = sub.add_parser("carga-poner", help="P7: molde + gancho por cuadro (estado 0) + envoltorio del cargador")
    cp.add_argument("--desde", type=lambda s: int(s, 0), default=0x1C)
    cp.add_argument("--tipo-registro", type=int, default=1, help="J2+0xC4 durante FUN_0016e660 (2 = P10, cuelga)")
    cp.add_argument("--copia-ranura", action="store_true",
                    help="el envoltorio cambia *(0x0040F50C) a la copia alrededor del constructor "
                         "(hay que haber corrido `ranura-copiar` antes)")
    rc = sub.add_parser("ranura-copiar",
                        help="N4 (80): copia el sistema de personajes y sus DOS companeros a memoria "
                             "libre, reubicando los punteros que mide EN VIVO, y pone +0xB8 = 0")
    rc.add_argument("--destino", type=lambda s: int(s, 0), default=COPIA_DESTINO)
    rc.add_argument("--dueno-a-mano", action="store_true",
                    help="tambien pone J2 de dueno de las dos ranuras de la copia (para el molde 0x1C, "
                         "que solo apunta y no ata)")
    rc.add_argument("--seco", action="store_true", help="no escribe: imprime lo que escribiria")
    rc.add_argument("--volcado", help="medir desde un eeMemory.bin en vez de PINE (implica --seco)")
    sub.add_parser("control2", help="copias de control de J2 -> 0x00585A0C, su +0xC -> falso 2, y J2+0x32C -> mira humana")
    sub.add_parser("atar", help="P15 (82): ata a J2 un controlador de colision (FUN_0025C210); sin esto no camina")
    sub.add_parser("autopsia", help="P8: ranuras de personaje, cargador de modelos y J2 (sin codigo)")
    sub.add_parser("quitar")
    e = sub.add_parser("estado")
    e.add_argument("n", type=int)
    m = sub.add_parser("mirar")
    m.add_argument("segundos", type=float)
    a = ap.parse_args()
    prog = ensamblar_programa()

    if a.cmd == "ranura-copiar" and a.volcado:
        d = Path(a.volcado).read_bytes()
        bl, reub, mapa = plan_copia(lambda x: struct.unpack_from("<I", d, x)[0],
                                    lambda x, n: d[x:x + n], a.destino,
                                    cj.J2 if a.dueno_a_mano else None)
        informar_copia(bl, reub, mapa, seco=True)
        return 0
    envol = ensamblar_programa(ENVOLTORIO_PROG.replace("TIPO_REG", str(getattr(a, "tipo_registro", 1))),
                               ENVOLTORIO, ARMAS2)
    if a.cmd == "listar":
        for pc, w, t in prog + envol:
            print("0x%08X  %08X  %s" % (pc, w, t))
        return 0
    with Pine() as p:
        if a.cmd in ("poner", "carga-poner"):
            if p.leer32(g.SITIO) != g.ORIGINAL:
                print("el gancho ya esta puesto o el sitio cambio: %08X" % p.leer32(g.SITIO))
                return 1
            if a.cmd == "carga-poner" and p.leer32(SITIO_CARGA) != ORIGINAL_CARGA:
                print("el sitio del cargador cambio: %08X" % p.leer32(SITIO_CARGA))
                return 1
            # molde: copia de J con autopunteros reubicados (clon_jugador), sin enganchar
            blk = bytearray(p.leer_bloque(cj.J, cj.TAM))
            for off, dest in cj.AUTOPUNTEROS.items():
                struct.pack_into("<I", blk, off, cj.J2 + dest)
            struct.pack_into("<I", blk, 0xB0, 0)
            # +0x8A4 = 0x37 es "terminado" y tambien "empezar": desde ahi el constructor
            # recarga el modelo (FUN_0016c3b8) y en juego eso cuelga el hilo (P6).
            struct.pack_into("<I", blk, 0x8A4, a.desde)
            if a.cmd == "carga-poner":
                # el constructor escribe **(J+0x2A0): con el de J, le pisaria las armas
                struct.pack_into("<I", blk, 0x2A0, ARMAS2)
                p.escribir_bloque(ARMAS2, bytes(0x20))
            p.escribir_bloque(cj.J2, bytes(blk))
            for pc, w, _ in prog:
                p.escribir32(pc, w)
            for dir_ in (ESTADO, CONTADOR, 0x0046D788, 0x0046D78C, FASE, LLAMADAS_J2, LLAMADAS_J0, MIGA_A, MIGA_B, MIGA_V0, MIGA_C):
                p.escribir32(dir_, 0)
            if a.cmd == "carga-poner" and not a.copia_ranura:
                p.escribir32(COPIA_SIS, 0)   # el envoltorio no toca el global
            p.escribir32(g.SITIO, ensamblar("jal 0x%x" % STUB, g.SITIO))
            if a.cmd == "carga-poner":
                for pc, w, _ in envol:
                    p.escribir32(pc, w)
                p.escribir32(SITIO_CARGA, ensamblar("jal 0x%x" % ENVOLTORIO, SITIO_CARGA))
        elif a.cmd == "ranura-copiar":
            bl, reub, mapa = plan_copia(p.leer32, p.leer_bloque, a.destino,
                                        cj.J2 if a.dueno_a_mano else None)
            if not a.seco:
                for dir_, datos, _ in bl:
                    p.escribir_bloque(dir_, datos)
                # el envoltorio lee de aca la direccion de la copia; 0 = no cambiar el global
                p.escribir32(COPIA_SIS, mapa["copia"])
                p.escribir32(GUARDA_SIS, 0)
            informar_copia(bl, reub, mapa, a.seco)
            return 0
        elif a.cmd == "autopsia":
            pers = p.leer32(0x0040F50C)            # sistema de personajes: 2 ranuras de 0x240 en +0x470
            mod = p.leer32(0x0040F540)             # cargador de modelos: byte 0 = bufer, +0x80 -> estado en +0x1C
            jg = p.leer32(cj.JUEGO_PTR)
            d = {"ranuras": [{"dir": hex(pers + 0x470 + k * 0x240), "dueno": hex(p.leer32(pers + 0x470 + k * 0x240)),
                              "B8": p.leer8(pers + 0x470 + k * 0x240 + 0xB8)} for k in (0, 1)],
                 "J_330": hex(p.leer32(cj.J + 0x330)), "J2_330": hex(p.leer32(cj.J2 + 0x330)),
                 "modelos_bufer": p.leer8(mod), "modelos_estado": p.leer32(p.leer32(mod + 0x80) + 0x1C),
                 "cargador": p.leer32(jg + 0x5AA0), "fase": p.leer32(FASE), "llam_J2": p.leer32(LLAMADAS_J2),
                 "J2_8A4": p.leer32(cj.J2 + 0x8A4), "J2_4E0": hex(p.leer32(cj.J2 + 0x4E0)),
                 "miga_A_aparicion": p.leer32(MIGA_A), "miga_B_constructor": p.leer32(MIGA_B),
                 "miga_v0": p.leer32(MIGA_V0), "miga_C_registro": p.leer32(MIGA_C),
                 "J_34C": hex(p.leer32(cj.J + 0x34C)), "J2_34C": hex(p.leer32(cj.J2 + 0x34C)),
                 "J2_34C_dueno": hex(p.leer32(p.leer32(cj.J2 + 0x34C) + 0x20)) if p.leer32(cj.J2 + 0x34C) else None,
                 "J2_c4": p.leer32(cj.J2 + 0xC4), "J2_arma": hex(p.leer32(cj.J2 + 0x2A4))}
            print(json.dumps(d, ensure_ascii=False))
            return 0
        elif a.cmd == "control2":
            f2 = bytearray(p.leer_bloque(cj.MANDO2_REAL, 0xF0))
            for o in range(0x8C, 0xCC, 4):
                f2[o:o + 4] = b"\0\0\0\0"
            f2[0x0E:0x2A + 28] = bytes(0x2A + 28 - 0x0E)
            p.escribir_bloque(cj.FALSO2, bytes(f2))
            p.escribir32(cj.CTRL2 + 0xC, cj.FALSO2)
            for off in cj.COPIAS_CONTROL:
                p.escribir32(cj.J2 + off, cj.CTRL2)
            # la init deja activo el controlador +0x7D0 (sin mando); a J0 algo posterior le
            # pone la mira humana +0x4F0, a J2 nadie (P11). Con esto el mando 2 lo gira (P12).
            p.escribir32(cj.J2 + 0x32C, cj.J2 + 0x4F0)
        elif a.cmd == "atar":
            print(json.dumps(atar(p), ensure_ascii=False))
            return 0
        elif a.cmd == "quitar":
            p.escribir32(g.SITIO, g.ORIGINAL)
            if p.leer32(SITIO_CARGA) != ORIGINAL_CARGA:
                p.escribir32(SITIO_CARGA, ORIGINAL_CARGA)
        elif a.cmd == "estado":
            p.escribir32(ESTADO, a.n)
        elif a.cmd == "mirar":
            ult, t0 = None, time.time()
            while time.time() - t0 < a.segundos:
                try:
                    jg = p.leer32(cj.JUEGO_PTR)
                    d = {"cargador": p.leer32(jg + 0x5AA0), "fase": p.leer32(FASE),
                         "llam_J0": p.leer32(LLAMADAS_J0), "llam_J2": p.leer32(LLAMADAS_J2),
                         "estado": p.leer32(ESTADO), "cuadros_J2": p.leer32(CONTADOR),
                     "llamadas": p.leer32(0x0046D788), "retornos": p.leer32(0x0046D78C),
                         "J2_8A4": p.leer32(cj.J2 + 0x8A4), "J_pos": cj.pos(p, cj.J), "J2_pos": cj.pos(p, cj.J2),
                         "J2_c4": p.leer32(cj.J2 + 0xC4), "J2_arma": hex(p.leer32(cj.J2 + 0x2A4)),
                         "J2_ctrl": hex(p.leer32(cj.J2 + 0x588))}
                except Exception as ex:
                    d = {"error": str(ex)}
                if d != ult:
                    print("%5.1f s %s" % (time.time() - t0, json.dumps(d, ensure_ascii=False)))
                    ult = d
                time.sleep(0.25)
            return 0
        print(json.dumps({"sitio": "%08X" % p.leer32(g.SITIO), "estado": p.leer32(ESTADO)}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
