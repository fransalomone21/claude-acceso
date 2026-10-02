#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""coop_sonido.py -- COOP-C pieza 2a: el disparo de J2 SUENA (F4 de docs/17; docs/16 «La pieza 2 a nivel instruccion»).

REFUTADA EN VIVO (116, sesiones/PREDICCIONES-116.md): SONJ2 corre (90 de 90 disparos de J2 llegan), pero
FUN_001D7020 NO es el sonido audible del disparo: con J disparando su azar (V+0x2A0) no avanza, V+0x1C44 = 0 y el
volumen V+0x1C48 = 0 en 15 de 16 volcados. Queda APAGADA (coop_mod.CON_SONIDO = False). Se conserva el desvio del
envoltorio 4 (y la regla 9) porque el proximo destino del sonido cuelga del mismo lugar; lo de abajo es el diseno probado.

Diseno a nivel instruccion (bitacora (116)). Arma el codigo en frio, lo lista desensamblado con capstone y verifica
contra el ELF en lo que se apoya. Lo instala coop_mod.py (prendido por defecto cuando la pieza pase su prueba;
`--sin-sonido` es el control: el aislador vuelve a callar el disparo de J2, la S4 de (111)).

    python herramientas/coop_sonido.py listado      # el codigo, desensamblado, y en lo que se apoya
    python herramientas/coop_sonido.py verificar    # sale 1 si algo no cierra (capstone, reserva, saltos, ELF)

POR QUE NO `V2` (116, en frio): `V` se carga POR NIVEL con una maquina de pasos asincronica (FUN_001D65F8: el banco
«Level.awd», las muestras del disparo, las pistas de las 6 sub-ranuras) que maneja el objeto X+0x44 con SU COPIA del
puntero (FUN_001E8120 copia la tabla del contexto en +0x170..+0x1A8: V en +0x178), y la descarga (FUN_001D6CB8) la
maneja otro con su copia. Una V2 pide un segundo banco por nivel, su carga y su descarga propias y difundir los
cambios de las tres maquinas de estado: es la parte cara, y para el SONIDO no hace falta.

EL DISENO: el aislador de (93l) ya intercepta FUN_001D6F90(V) (el disparo sobre la vista) mientras se actualiza J2
(envoltorio 4 de coop_mod.FP_ENTRADAS) y vuelve sin hacer nada. Con esta pieza, ese camino salteado salta a SONJ2,
que hace SOLO la ultima parte de la original: si *(*(X+0x24)+0x1E54) == 0 (la misma guarda que 0x001D6FC8..E4),
FUN_001D7020(V): alterna las dos muestras del disparo (V+0x1C0C/+0x1C10) y las crea en el emisor de V (V+0x40).
No toca la pista de animacion (FUN_001F0678), ni el conjunto del arma (FUN_001D6E78), ni V+0x1C28: el estado de la
vista sigue siendo de J. Limites aceptados: suena «en la cabeza» como el de J (N5) y con las muestras de J (las
carga el nivel, no el arma); si el emisor tiene una sola voz, un disparo puede cortar al otro (a medir).

Entrada: a0 = V (el envoltorio salta antes de tocar a0), ra = el que llamo a FUN_001D6F90. FUN_001D6F90 y
FUN_001D7020 son void: el `move v0, zero` del envoltorio queda en el delay slot. Solo usa t8, t9 y a0 sin tocar.
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jugador2 as j2  # noqa: E402
from mips import desensamblar  # noqa: E402

BASE, FIN = 0x0046EE00, 0x0046EE40     # reserva «sonido de J2 (codigo)» de coop-plan-b (docs/14)
SONIDO = 0x001D7020                    # FUN_001D7020(V): el sonido del disparo del jugador
DISPARO_V = 0x001D6F90                 # FUN_001D6F90(V): el disparo sobre la vista (envoltorio 4 del aislador)

FUENTE = """
SONJ2:
lui t9, 0x41
ori t8, zero, 0x8000
lw t9, -0xaf0(t9)
addu t9, t9, t8
lw t9, 0x4bd8(t9)
lw t9, 0x24(t9)
lbu t9, 0x1e54(t9)
bne t9, zero, @NOSUENA
nop
j 0x%x
nop
NOSUENA:
jr ra
nop
""" % SONIDO


def programa():
    return j2.ensamblar_programa(FUENTE, BASE, FIN)


ENTRADA = BASE   # SONJ2 es la primera instruccion

# lo que el diseno copia de la original sin pisarlo: la guarda y la llamada (0x001D6FC8..0x001D6FEC)
APOYO = {0x001D6FC8: "lui v1, 0x41", 0x001D6FCC: "ori a0, zero, 0x8000", 0x001D6FD0: "lw v0, -2800(v1)",
         0x001D6FD4: "addu v0, v0, a0", 0x001D6FD8: "lw v1, 19416(v0)", 0x001D6FDC: "lw a0, 36(v1)",
         0x001D6FE0: "lbu v0, 7764(a0)", 0x001D6FEC: "jal 0x001D7020", 0x001D6FF0: "daddu a0, s0, zero",
         0x001D6F9C: "daddu s0, a0, zero"}   # a0 = V en la entrada y en la llamada: SONJ2 llega con a0 = V


def capstone_des(pc, w):
    from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS64, Cs
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
    r = list(md.disasm(struct.pack("<I", w), pc))
    return f"{r[0].mnemonic} {r[0].op_str}" if r else "(capstone no lo decodifica)"


LISTADO = Path(__file__).resolve().parent.parent / "docs" / "listados" / "C2-coop-sonido.txt"


def lineas_listado():
    prog = programa()
    return prog, [f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}" for pc, w, t in prog]


def problemas(mostrar=False, escribir=False) -> list:
    """La lista de rojos (la usa tambien coop_diseno.py, regla 9)."""
    from perfil_singleton import palabra_elf
    errores = []
    prog, lineas = lineas_listado()
    if prog[-1][0] + 4 > FIN:
        errores.append("el codigo pasa de la reserva [%#x, %#x)" % (BASE, FIN))
    for (pc, w, t), l in zip(prog, lineas):
        if mostrar:
            print(l)
        if capstone_des(pc, w).startswith("(capstone"):
            errores.append(f"{pc:#x} {t}: capstone no lo decodifica")
        op = w >> 26
        if op in (4, 5):
            off = struct.unpack("<h", struct.pack("<H", w & 0xFFFF))[0]
            dest = pc + 4 + 4 * off
            if not (BASE <= dest < prog[-1][0] + 4):
                errores.append(f"{pc:#x} {t}: salta a {dest:#x}, fuera del codigo")
        if op in (2, 3):
            dest = (pc & 0xF0000000) | ((w & 0x03FFFFFF) << 2)
            if dest != SONIDO:
                errores.append(f"{pc:#x} {t}: j/jal a {dest:#x}, no es FUN_001D7020")
        if op == 3:
            errores.append(f"{pc:#x} {t}: jal (pisaria ra: SONJ2 vuelve al que llamo a FUN_001D6F90)")
        # a0 es V: nada puede escribirlo
        if op in (0x08, 0x09, 0x0D, 0x0F, 0x23, 0x24) and ((w >> 16) & 31) == 4:
            errores.append(f"{pc:#x} {t}: escribe a0 (V)")
    if mostrar:
        print("\napoyo (la original, sin pisar):")
    for pc, esp in APOYO.items():
        real = " ".join(desensamblar(palabra_elf(pc), pc).split())
        if real.lower() != esp.lower():
            errores.append(f"apoyo {pc:#x}: el ELF tiene '{real}', el diseno supone '{esp}'")
        if mostrar:
            print(f"{pc:08X}  {real}")
    if escribir:
        LISTADO.write_text("\n".join(lineas) + "\n", encoding="utf-8")
    elif not LISTADO.exists():
        errores.append("falta docs/listados/C2-coop-sonido.txt (`coop_sonido.py listado` lo escribe)")
    else:
        g = [l.rstrip() for l in LISTADO.read_text(encoding="utf-8-sig").splitlines()]
        if g != [l.rstrip() for l in lineas]:
            errores.append("docs/listados/C2-coop-sonido.txt no coincide con el codigo: regenerarlo con "
                           "`coop_sonido.py listado`")
    return errores


def verificar(mostrar=False, escribir=False) -> int:
    errores = problemas(mostrar, escribir)
    for e in errores:
        print("ROJO:", e)
    print(f"coop_sonido: {len(programa())} palabras en [{BASE:#x}, {FIN:#x}), {len(errores)} problema(s)")
    return 1 if errores else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["listado", "verificar"])
    a = ap.parse_args()
    return verificar(mostrar=a.cmd == "listado", escribir=a.cmd == "listado")


if __name__ == "__main__":
    sys.exit(main())
