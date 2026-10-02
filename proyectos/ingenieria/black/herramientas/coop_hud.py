#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""coop_hud.py -- COOP-C pieza 1: el HUD doble EN EL STUB (H1-H4 de docs/16, «HUD separado»; PDP §4, Fase C).

Diseno a nivel instruccion (C1, bitacora (115)). Arma el codigo en frio, lo lista desensamblado con capstone y
verifica los sitios contra el ELF. Se instala desde coop_mod.py con `--con-hud` (apagado por defecto hasta que la
pieza pase su prueba: prediccion, control y dos cargas; despues sus filas pasan de coop-plan-b a coop-rangos).

    python herramientas/coop_hud.py listado      # el codigo, desensamblado, y los ganchos con lo que pisan
    python herramientas/coop_hud.py verificar    # sale 1 si algo no cierra (capstone, reserva, saltos, ELF, floats)

DOS SITIOS + ONCE PALABRAS (ningun sitio nuevo: los de coop-plan-b (112)):
  H1/H2  0x00128F5C  jal FUN_001F2790(hud, cuenta)    -> jal CARGAH: FUN_001F2790(hud, 2) (cuenta de paneles 2, no
                     toca rectangulos) y los rectangulos de los dos paneles en x / 0,75, ANTES de la activacion que el
                     juego hace en 0x00128F64 (FUN_001F2340, una sola por carga: el mod no activa nada).
  H4     0x001F25DC  jal FUN_001F1608(panel, dt)      -> jal PANELH, el lazo de actualizacion por cuadro de los paneles
                     (FUN_001F25A8; dt en f12, que el delay slot repone y PANELH no toca). Con cuenta de paneles 2:
           panel 0 -> la original; despues H3 (si el tipo del panel 1 no es el del 0: FUN_001F1B98(panel 1, tipo 0)) y
                      H2 (escala x del marco raiz *(panel+0x54)+8 = 0,75 en los dos, cada cuadro: la activacion la
                      repone en ancho/640 y FUN_00276458 la lee por cuadro, (113)).
           panel 1 -> con FASE = 2 (J2 armado): el juego CONMUTADO (P2): cabecera sombra <- juego, *(0x0040F4D0) =
                      J2 - 0x30, la original, y se restaura. Sin FASE 2, la original (el panel 1 muestra a J).
           otro, o cuenta != 2 -> la original (j, sin marco).
  H4     11 x `li rX, 2240` -> `li rX, 0` (el indice del jugador en el HUD: todos los elementos leen jugadores[0], que
                     con el juego conmutado es J2).

Cabecera sombra (censo_ab.py --conmutables sobre las 17 actualizaciones, (112)): +0x1C, +0x20, +0x5AAC, +0x5AB0,
+0x5AEC, +0x5CA0, +0x8F0, +0x910; y +0x28 (C1): el elemento 5 pausa con FUN_0027F818(juego), que conmutado
escribiria juego'+0x28 -- copiado adentro y descartado afuera = la pausa la maneja solo el panel de J1 (Fran, docs/18).
Sus destinos (juego' + o) estan en las reservas de coop-plan-b; cero en los 16 volcados (C1, medido).

Por que una sola activacion: FUN_001F2340, si ya activo (+0x238 = 0x1C), desactiva SOLO el panel 0 (el lazo de
0x001F23A8 corre una vez) y vuelve a enlistar los 15 elementos del panel 1 en su lista (+0xA0) sin sacarlos
(FUN_001F2740 los pone a la cabeza): la lista queda en ciclo y FUN_001F1608 no vuelve -- el «mundo congelado» de (113)
(`probable`, en frio, C y las instrucciones). El desarme (FUN_00129DE8 -> FUN_001F26C0) desactiva los `cuenta`
paneles y pone +0x238 = 0x38: la carga siguiente arranca con las listas vacias (prediccion: dos cargas sin colgar).

Solo usa t0-t9, a0, a1 y la pila: FUN_001F25A8 guarda s0-s2 y f20, y repone a0 de s0 en cada vuelta.
Etiquetas: ninguna puede ser prefijo de otra (ensamblar_programa reemplaza texto).
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jugador2 as j2  # noqa: E402
from mips import desensamblar, ensamblar  # noqa: E402

BASE, FIN = 0x0046EA80, 0x0046ED00     # reserva «HUD de J2 (codigo)» de coop-plan-b (docs/14)
FASE = 0x0046D790                      # coop_mod: FASE 2 = J2 armado
J2 = 0x0046CDF0
ESCALA = 0.75                          # (113) V2b; Fran: «el HUD del juego a 3/4 en cada mitad» (docs/18)
IZQ, DER = (30.0, 22.0, 290.0, 458.0), (350.0, 22.0, 610.0, 458.0)   # mitades de (30,22)-(610,458), el de cuenta 1
SOMBRA = (0x1C, 0x20, 0x28, 0x5AAC, 0x5AB0, 0x5AEC, 0x5CA0, 0x8F0, 0x910)
PASOS = (0x001F7C4C, 0x001F936C, 0x001FB45C, 0x001FB620, 0x001FBACC, 0x001FBDB4, 0x001FBFD4,
         0x001FD2BC, 0x001FD444, 0x001FD534, 0x001FD64C)
REG_PASO = ("a1", "v1", "v1", "v1", "v0", "s5", "a0", "a1", "a1", "v1", "a1")
SITIO_CARGA, SITIO_PANEL = 0x00128F5C, 0x001F25DC


def f32(v):
    return struct.unpack("<I", struct.pack("<f", v))[0]


def rectangulos():
    """[(desplazamiento en el HUD, float)] -- panel 0 en +0x78, panel 1 en +0x120; x / ESCALA."""
    r = []
    for base, rect in ((0x78, IZQ), (0x120, DER)):
        for i, v in enumerate(rect):
            r.append((base + 4 * i, v / ESCALA if i % 2 == 0 else v))
    return r


def cargar_t0(w):
    hi, lo = w >> 16, w & 0xFFFF
    return ["lui t0, 0x%x" % hi] + (["ori t0, t0, 0x%x" % lo] if lo else [])


def fuente():
    carga = ["CARGAH:", "addiu sp, sp, -0x10", "sd ra, 0(sp)", "sw a0, 8(sp)",
             "jal 0x1f2790", "addiu a1, zero, 2",           # cuenta de paneles 2: FUN_001F2790 no toca rectangulos
             "lw a0, 8(sp)"]
    previo = None
    for off, v in sorted(rectangulos(), key=lambda x: (f32(x[1]), x[0])):
        if f32(v) != previo:
            carga += cargar_t0(f32(v))
            previo = f32(v)
        carga.append("sw t0, 0x%x(a0)" % off)
    carga += ["ld ra, 0(sp)", "jr ra", "addiu sp, sp, 0x10"]

    panel = ["PANELH:", "lui t9, 0x41", "lw t0, -0xae8(t9)",           # t0 = hud = *(0x0040F518)
             "lb t1, 0x23c(t0)", "addiu t2, zero, 2", "bne t1, t2, @DIRH", "nop",
             "beq a0, t0, @CEROH", "nop",
             "addiu t1, t0, 0xa8", "bne a0, t1, @DIRH", "nop",
             # panel 1: conmutado si J2 esta armado
             "lui t8, 0x47", "lw t1, -0x2870(t8)", "bne t1, t2, @DIRH", "nop",
             "addiu sp, sp, -0x20", "sd ra, 0(sp)",
             "lw t3, -0xb30(t9)", "sw t3, 8(sp)",                          # juego = *(0x0040F4D0), guardado
             "addiu t4, t8, -0x%x" % (0x00470000 - (J2 - 0x30))]          # juego' = J2 - 0x30
    for o in SOMBRA:
        panel += ["lw t5, 0x%x(t3)" % o, "sw t5, 0x%x(t4)" % o]
    panel += ["sw t4, -0xb30(t9)",                                         # conmutar
              "jal 0x1f1608", "nop",
              "lui t9, 0x41", "lw t3, 8(sp)", "sw t3, -0xb30(t9)",         # restaurar
              "ld ra, 0(sp)", "jr ra", "addiu sp, sp, 0x20",
              # panel 0: la original, despues H3 y la escala de H2
              "CEROH:", "addiu sp, sp, -0x20", "sd ra, 0(sp)",
              "jal 0x1f1608", "nop",
              "lui t9, 0x41", "lw a0, -0xae8(t9)",
              "lw a1, 0x8c(a0)", "lw t1, 0x134(a0)",                       # tipo del panel 0 y del 1 (+0xA8+0x8C)
              "beq a1, t1, @ESCH", "nop",
              "jal 0x1f1b98", "addiu a0, a0, 0xa8",
              "lui t9, 0x41", "lw a0, -0xae8(t9)",
              "ESCH:"] + cargar_t0(f32(ESCALA)) + [
              "lw t2, 0x54(a0)", "beq t2, zero, @UNOH", "nop", "sw t0, 8(t2)",
              "UNOH:", "lw t2, 0xfc(a0)", "beq t2, zero, @FINH", "nop", "sw t0, 8(t2)",
              "FINH:", "ld ra, 0(sp)", "jr ra", "addiu sp, sp, 0x20",
              "DIRH:", "j 0x1f1608", "nop"]
    return "\n".join(carga + panel)


def etiquetas(src=None):
    pos, n = {}, 0
    for l in (src or fuente()).splitlines():
        if l.endswith(":"):
            pos[l[:-1]] = BASE + 4 * n
        else:
            n += 1
    return pos


def programa():
    return j2.ensamblar_programa(fuente(), BASE, FIN)


def ganchos():
    e = etiquetas()
    g = [(SITIO_CARGA, ensamblar("jal 0x%x" % e["CARGAH"], SITIO_CARGA), "HUD H1/H2: jal CARGAH (era jal 0x1f2790)"),
         (SITIO_PANEL, ensamblar("jal 0x%x" % e["PANELH"], SITIO_PANEL), "HUD H3/H4: jal PANELH (era jal 0x1f1608)")]
    for k, (pc, r) in enumerate(zip(PASOS, REG_PASO)):
        g.append((pc, ensamblar("addiu %s, zero, 0" % r, pc), "HUD H4 paso 0 (%d): li %s, 0 (era 2240)" % (k + 1, r)))
    return g


ORIGINAL = {SITIO_CARGA: "jal 0x001F2790", SITIO_PANEL: "jal 0x001F1608"}
ORIGINAL.update({pc: "li %s, 2240" % r for pc, r in zip(PASOS, REG_PASO)})
# lo que el diseno usa sin pisarlo: el delay slot de cada jal y el orden de la carga (activar DESPUES de CARGAH)
APOYO = {0x00128F60: "lb a1, 520(v1)", 0x00128F64: "jal 0x001F2340", 0x00128F68: "lw a0, -2792(s0)",
         0x001F25E0: "cop1 0x4600A306"}


def capstone_des(pc, w):
    # MIPS64, como desensamblar.py: el R5900 usa sd/ld (coop_ia.py, en MIPS32, no los decodifica)
    from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS64, Cs
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
    r = list(md.disasm(struct.pack("<I", w), pc))
    return f"{r[0].mnemonic} {r[0].op_str}" if r else "(capstone no lo decodifica)"


LISTADO = Path(__file__).resolve().parent.parent / "docs" / "listados" / "C1-coop-hud.txt"


def lineas_listado():
    prog = programa()
    out = [f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}" for pc, w, t in prog]
    return prog, out


def verificar(mostrar=False, escribir=False) -> int:
    errores = problemas(mostrar, escribir)
    for e in errores:
        print("ROJO:", e)
    print(f"coop_hud: {len(programa())} palabras en [{BASE:#x}, {FIN:#x}), {len(ganchos())} ganchos, "
          f"{len(errores)} problema(s)")
    return 1 if errores else 0


def problemas(mostrar=False, escribir=False) -> list:
    """La lista de rojos (la usa tambien coop_diseno.py, regla 8)."""
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
        if op in (4, 5):                                   # beq/bne: dentro del codigo
            off = struct.unpack("<h", struct.pack("<H", w & 0xFFFF))[0]
            dest = pc + 4 + 4 * off
            if not (BASE <= dest < prog[-1][0] + 4):
                errores.append(f"{pc:#x} {t}: salta a {dest:#x}, fuera del codigo")
        if op in (2, 3):                                   # j/jal: solo a las funciones del juego que el diseno nombra
            dest = (pc & 0xF0000000) | ((w & 0x03FFFFFF) << 2)
            if dest not in (0x001F2790, 0x001F1608, 0x001F1B98):
                errores.append(f"{pc:#x} {t}: j/jal a {dest:#x}, no es una de las tres del diseno")
    # los floats que escribe CARGAH son los del PDP §4 (40, 22, 386,7, 458) y (466,7, 22, 813,3, 458)
    pdp = {0x78: 40.0, 0x7C: 22.0, 0x80: 386.6667, 0x84: 458.0, 0x120: 466.6667, 0x124: 22.0, 0x128: 813.3333,
           0x12C: 458.0}
    for off, v in rectangulos():
        if abs(v - pdp[off]) > 1e-3:
            errores.append("rectangulo +%#x = %.4f, el PDP dice %.4f" % (off, v, pdp[off]))
    # la sombra cae en las reservas del plan (juego' + o)
    jp = J2 - 0x30
    reservas = ((0x0046CDDC, 0x0046CDEC), (0x0046D6B0, 0x0046D6D4), (0x0047286C, 0x00472874),
                (0x004728AC, 0x004728B0), (0x00472A60, 0x00472A64))
    for o in SOMBRA:
        if not any(a <= jp + o and jp + o + 4 <= b for a, b in reservas):
            errores.append("sombra +%#x -> %#x fuera de las reservas" % (o, jp + o))
    if mostrar:
        print("\nganchos:")
    for pc, w, t in ganchos():
        real = " ".join(desensamblar(palabra_elf(pc), pc).split())
        if real.lower() != ORIGINAL[pc].lower():
            errores.append(f"gancho {pc:#x}: el ELF tiene '{real}', se esperaba '{ORIGINAL[pc]}'")
        if mostrar:
            print(f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}  [pisa: {real}]")
    for pc, esp in APOYO.items():
        real = " ".join(desensamblar(palabra_elf(pc), pc).split())
        if real.lower() != esp.lower():
            errores.append(f"apoyo {pc:#x}: el ELF tiene '{real}', el diseno supone '{esp}'")
    if escribir:
        LISTADO.write_text("\n".join(lineas) + "\n", encoding="utf-8")
    elif not LISTADO.exists():
        errores.append("falta docs/listados/C1-coop-hud.txt (`coop_hud.py listado` lo escribe)")
    else:
        g = [l.rstrip() for l in LISTADO.read_text(encoding="utf-8-sig").splitlines()]
        if g != [l.rstrip() for l in lineas]:
            errores.append("docs/listados/C1-coop-hud.txt no coincide con el codigo: regenerarlo con `coop_hud.py listado`")
    return errores


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["listado", "verificar"])
    a = ap.parse_args()
    return verificar(mostrar=a.cmd == "listado", escribir=a.cmd == "listado")


if __name__ == "__main__":
    sys.exit(main())
