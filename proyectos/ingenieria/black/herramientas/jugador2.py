#!/usr/bin/env python3
"""jugador2.py -- el prototipo del COOP: un segundo jugador construido por el juego (bitacora (78), P6).

Usa el gancho de la sonda 6 (0x00129574, una vez por cuadro) con un stub que,
ademas de llamar al controlador del jugador 0, maneja un ESTADO en 0x0046D784:
  1 -> llama FUN_00129090(juego, -577) cada cuadro hasta que devuelve 1: el
       constructor del juego (FUN_00139c68) sobre juego+0x30-577*0x8C0 = 0x0046CDF0
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
# FUN_00129090(juego, -577) hasta que devuelve 1, y recien ahi devuelve 1.
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
lui a0, 0x47
jal 0x139c68
addiu a0, a0, -0x3210
lw t1, -0x2868(s1)
addiu t1, t1, 1
sw t1, -0x2868(s1)
sw v0, -0x285c(s1)
beq v0, zero, @SALIR
nop
lui t0, 0x41
lw a0, -0xb2c(t0)
lui a1, 0x47
jal 0x16e660
addiu a1, a1, -0x3210
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


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("listar")
    pn = sub.add_parser("poner")
    pn.add_argument("--desde", type=lambda s: int(s, 0), default=2,
                    help="estado inicial del constructor en J2+0x8A4 (0x37 cuelga: P6)")
    cp = sub.add_parser("carga-poner", help="P7: molde + gancho por cuadro (estado 0) + envoltorio del cargador")
    cp.add_argument("--desde", type=lambda s: int(s, 0), default=2)
    sub.add_parser("control2", help="copias de control de J2 -> 0x00585A0C, y su +0xC -> falso 2")
    sub.add_parser("autopsia", help="P8: ranuras de personaje, cargador de modelos y J2 (sin codigo)")
    sub.add_parser("quitar")
    e = sub.add_parser("estado")
    e.add_argument("n", type=int)
    m = sub.add_parser("mirar")
    m.add_argument("segundos", type=float)
    a = ap.parse_args()
    prog = ensamblar_programa()
    envol = ensamblar_programa(ENVOLTORIO_PROG, ENVOLTORIO, ARMAS2)
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
            p.escribir32(g.SITIO, ensamblar("jal 0x%x" % STUB, g.SITIO))
            if a.cmd == "carga-poner":
                for pc, w, _ in envol:
                    p.escribir32(pc, w)
                p.escribir32(SITIO_CARGA, ensamblar("jal 0x%x" % ENVOLTORIO, SITIO_CARGA))
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
                 "miga_v0": p.leer32(MIGA_V0), "miga_C_registro": p.leer32(MIGA_C)}
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
