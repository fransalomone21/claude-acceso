#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""coop_sonido.py -- COOP-C pieza 2a: el disparo de J2 SUENA (F4 de docs/17; docs/16 «El sonido audible, (117)»).

(117), EN FRIO, EL DESTINO NUEVO: SONJ2 toca el CUE del disparo, FUN_001F0678(*(V+0x1BE0)), que es lo que suena de
verdad (en (116) se lo habia leido como «pista de animacion»; es un cue de sonido de 2 voces: FUN_001D60B8 ->
FUN_00283E78). Leido en el C y en las instrucciones (0x001D6FC0 jal 0x001F0678 / delay lw a0, 0x1BE0(s0)) y su estado
en los 16 volcados (herramientas/cue_disparo.py: cue en una sub-ranura de V, 2 voces vivas). SIN PROBAR EN VIVO:
sigue APAGADA (coop_mod.CON_SONIDO = False) hasta medir la prediccion de docs/16 con la pantalla libre.

(116), REFUTADO EN VIVO, el destino viejo: FUN_001D7020 (la guarda V+0x1C44 = 0, volumen 0 en 15 de 16 volcados). Lo
de abajo de ese diseno que sigue en pie es el desvio del envoltorio 4.

Diseno a nivel instruccion. Arma el codigo en frio, lo lista desensamblado con capstone y verifica
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
que hace SOLO la parte del medio de la original: FUN_001F0678(*(V+0x1BE0)), el cue del disparo (si el puntero es 0,
vuelve). No toca el conjunto del arma (FUN_001D6E78), ni FUN_001D7020, ni V+0x1C28 (el reloj del ultimo disparo, que
anima la vista de J): el estado de la vista sigue siendo de J. Limites aceptados (v1): suena con el cue del arma de J
(igual si tienen la misma arma), las 2 voces de V son de los dos (un disparo puede cortar la cola del otro) y
«en la cabeza» como el de J (N5).

Entrada: a0 = V (el envoltorio salta antes de tocar a0), ra = el que llamo a FUN_001D6F90. FUN_001D6F90 y
FUN_001F0678 son void: el `move v0, zero` del envoltorio queda en el delay slot. Usa t9; a0 se escribe UNA vez, en el
delay slot del `j 0x001F0678` (a0 = el cue).
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jugador2 as j2  # noqa: E402
from mips import desensamblar  # noqa: E402

BASE, FIN = 0x0046EE00, 0x0046EE40     # reserva «sonido de J2 (codigo)» de coop-plan-b (docs/14)
SONIDO = 0x001F0678                    # (117) FUN_001F0678(cue): el cue del disparo, lo que se oye
CUE = 0x1BE0                           # V+0x1BE0: el cue actual (una sub-ranura de V; cue_disparo.py)
DISPARO_V = 0x001D6F90                 # FUN_001D6F90(V): el disparo sobre la vista (envoltorio 4 del aislador)

FUENTE = """
SONJ2:
lw t9, 0x%x(a0)
beq t9, zero, @NOSUENA
nop
j 0x%x
move a0, t9
NOSUENA:
jr ra
nop
""" % (CUE, SONIDO)


def programa():
    return j2.ensamblar_programa(FUENTE, BASE, FIN)


ENTRADA = BASE   # SONJ2 es la primera instruccion

# lo que el diseno copia de la original sin pisarlo: la llamada al cue (0x001D6FC0, argumento en el delay slot)
APOYO = {0x001D6FC0: "jal 0x001F0678", 0x001D6FC4: "lw a0, 7136(s0)",
         0x001D6F9C: "daddu s0, a0, zero"}   # s0 = V desde la entrada: SONJ2 llega con a0 = V y lee V+0x1BE0


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
                errores.append(f"{pc:#x} {t}: j/jal a {dest:#x}, no es FUN_001F0678")
        if op == 3:
            errores.append(f"{pc:#x} {t}: jal (pisaria ra: SONJ2 vuelve al que llamo a FUN_001D6F90)")
        # a0 es V hasta el salto: solo el delay slot del `j FUN_001F0678` puede escribirlo, y con el cue (t9)
        escribe_a0 = ((op in (0x08, 0x09, 0x0D, 0x0F, 0x23, 0x24) and ((w >> 16) & 31) == 4)
                      or (op == 0 and ((w >> 11) & 31) == 4))
        anterior = next((x for x in prog if x[0] == pc - 4), None)
        en_delay = anterior is not None and anterior[1] >> 26 == 2
        if escribe_a0 and not (en_delay and op == 0 and (w & 0x3F) in (0x21, 0x2D)
                               and (w >> 21) & 31 == 25 and (w >> 16) & 31 == 0):
            errores.append(f"{pc:#x} {t}: escribe a0 (V) fuera del delay slot del salto, o con otra cosa que el cue")
    if not any(op_lw == 0x23 and rs == 4 and rt == 25 and imm == CUE
               for op_lw, rs, rt, imm in ((w >> 26, (w >> 21) & 31, (w >> 16) & 31, w & 0xFFFF) for _, w, _ in prog)):
        errores.append("SONJ2 no lee el cue de V+0x%X con `lw t9, 0x%X(a0)`" % (CUE, CUE))
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
