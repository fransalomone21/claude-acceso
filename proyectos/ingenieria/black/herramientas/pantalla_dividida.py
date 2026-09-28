"""pantalla_dividida.py -- riesgo B1 de COOP-B (bitacora (84)): DOS VISTAS EN EL MISMO CUADRO.

Lo que se leyo (bitacora (84), en frio y en vivo) y esta herramienta pone a prueba:

  - La escena la dibuja FUN_001297E0(juego), llamada por los tres modos de juego
    (0x001056C0, 0x00106550, 0x00106D70) ANTES del HUD y del volteo del cuadro.
  - La camara de la escena es la 1 del gestor de render (R+0xD400, R = *(0x0040F4C0));
    su RwCamera esta en *(R+0xD400+0x58) y dibuja en el SUB-RASTER de su +0x60
    (ancho +0xC, nOffsetX +0x1C). Cambiar ancho/offset mueve y achica la escena (P18).
  - La camara lee su vista de (R+0xD400)+0x68 = gestor de camara (0x0040F4BC)+0x700:
    +0x00 FOV (grados), +0x10 cuaternion, +0x20 posicion del ojo. FUN_001AE998(R, 1)
    y FUN_001B0948(R+0xD400) la pasan a la RwCamera. La pasada de sombras (FUN_001C9110)
    la vuelve a poner desde gestor+0x700 a mitad del cuadro: por eso se reescribe EL
    CONTENIDO de gestor+0x700, no el puntero.

El gancho (STUB): cada `jal FUN_001297E0` de los tres modos pasa por aca. Si DATOS+0x80
es 0, llama una vez (igual que el juego). Si es 1: mitad izquierda con la vista de J,
mitad derecha con la de J2 (cuaternion y ojo en DATOS+0x40/+0x50, que por ahora escribe
Python: `vista2`), y deja todo como estaba.

Uso (desde black/):
  python herramientas/pantalla_dividida.py poner        # en PAUSA: stub + datos + 3 ganchos
  python herramientas/pantalla_dividida.py vista2 <s>   # prende la division y mantiene la vista de J2 s segundos
  python herramientas/pantalla_dividida.py apagar       # division en 0 (el gancho queda, inofensivo)
  python herramientas/pantalla_dividida.py quitar       # en PAUSA: vuelve los 3 jal originales
  python herramientas/pantalla_dividida.py ritmo <s>    # cuantas veces por segundo se dibuja la escena
  python herramientas/pantalla_dividida.py cuat         # control: el cuaternion de J calculado vs el del juego
  python herramientas/pantalla_dividida.py fuente-stub 1 [--prender]  # (88b) la vista de J2 la calcula el stub
  python herramientas/pantalla_dividida.py comparar <s> # (88b) control: stub (DATOS+0x60) contra la formula

Memoria: STUB 0x0046FA00..0x0046FBEC, DATOS 0x0046FC00..0x0046FC98 (dentro del .bss en
cero 0x0046DC00..0x00472000, sin usar desde que la ranura propia no hizo falta (82)).
"""
from __future__ import annotations

import argparse
import json
import math
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from mips import ensamblar  # noqa: E402

SITIOS = (0x001056DC, 0x0010656C, 0x00106D8C)
ORIGINAL = 0x0C04A5F8            # jal 0x001297E0 (medido en vivo en los tres)
STUB = 0x0046F800          # (88e) era 0x0046FA00: con la vista de J2 y la guarda ya no entraba antes de DATOS
DATOS = 0x0046FC00
G_CAMARA = 0x0040F4BC
G_RENDER = 0x0040F4C0
J2 = 0x0046CDF0
MEDIO, ENTERO = 320, 640
SINF, COSF = 0x0029DC18, 0x0029DA28   # newlib/fdlibm del ELF, argumento en $f12, resultado en $f0 (88b)


def _fpu(op: str, *r: int) -> str:
    """Las pocas instrucciones de FPU que hacen falta (mips.py no las ensambla), como .word."""
    if op == "lwc1":            # ft, off, base
        w = 0xC4000000 | r[2] << 21 | r[0] << 16 | (r[1] & 0xFFFF)
    elif op == "swc1":
        w = 0xE4000000 | r[2] << 21 | r[0] << 16 | (r[1] & 0xFFFF)
    elif op == "mtc1":          # rt, fs
        w = 0x44800000 | r[0] << 16 | r[1] << 11
    elif op == "mul.s":         # fd, fs, ft
        w = 0x46000002 | r[2] << 16 | r[1] << 11 | r[0] << 6
    elif op == "neg.s":         # fd, fs
        w = 0x46000007 | r[1] << 11 | r[0] << 6
    else:
        raise ValueError(op)
    return ".word 0x%08x" % w


T0, T1, T2, S1, SP = 8, 9, 10, 17, 29
MEDIO_GRADO = struct.unpack("<I", struct.pack("<f", math.pi / 360))[0]   # yaw (grados) -> medio angulo (rad)
# (88b) la vista de J2 calculada EN EL STUB, sin Python, con sinf/cosf del ELF. (88d) con cabeceo:
# q = q_yaw * q_cabeceo = (cy*sp, sy*cp, -sy*sp, cy*cp), medios angulos (medido sobre J contra gestor+0x710:
# error <= 0,002 con yaw 60 y 180 y cabeceo -25/+30). yaw = *(J2+0x32C)+8; el cabeceo REAL de J2 es
# -(mira+0xC), porque el mod lo guarda negado (88c). Ojo J2+0x100 (w = 1). Queda en DATOS+0x60/+0x70; si
# DATOS+0x94 != 0 se copia a +0x40/+0x50, que es lo que lee la pasada 2. Medios angulos en la pila
# (sp+0x50/+0x54); senos y cosenos en DATOS+0x20..+0x2C (sy, cy, sp, cp) entre llamadas.
VISTA_J2 = [
    "lui t0, 0x47", "lw t1, -0x2ee4(t0)", "beq t1, zero, NOJ2", "nop",   # *(J2+0x32C): la mira de J2
    _fpu("lwc1", 12, 8, T1), _fpu("lwc1", 2, 0xC, T1),
    "lui t2, 0x%x" % (MEDIO_GRADO >> 16), "ori t2, t2, 0x%x" % (MEDIO_GRADO & 0xFFFF),
    _fpu("mtc1", T2, 1), _fpu("mul.s", 12, 12, 1), _fpu("swc1", 12, 0x50, SP),
    _fpu("mul.s", 2, 2, 1), _fpu("neg.s", 2, 2), _fpu("swc1", 2, 0x54, SP),
    "jal 0x%x" % SINF, "nop", _fpu("swc1", 0, -0x3e0, S1),             # +0x20 = sy
    _fpu("lwc1", 12, 0x50, SP),
    "jal 0x%x" % COSF, "nop", _fpu("swc1", 0, -0x3dc, S1),             # +0x24 = cy
    _fpu("lwc1", 12, 0x54, SP),
    "jal 0x%x" % SINF, "nop", _fpu("swc1", 0, -0x3d8, S1),             # +0x28 = sp
    _fpu("lwc1", 12, 0x54, SP),
    "jal 0x%x" % COSF, "nop", _fpu("swc1", 0, -0x3d4, S1),             # +0x2C = cp
    _fpu("lwc1", 4, -0x3e0, S1), _fpu("lwc1", 5, -0x3dc, S1),
    _fpu("lwc1", 6, -0x3d8, S1), _fpu("lwc1", 7, -0x3d4, S1),
    _fpu("mul.s", 8, 5, 6), _fpu("swc1", 8, -0x3a0, S1),               # +0x60 x = cy*sp
    _fpu("mul.s", 8, 4, 7), _fpu("swc1", 8, -0x39c, S1),               # +0x64 y = sy*cp
    _fpu("mul.s", 8, 4, 6), _fpu("neg.s", 8, 8), _fpu("swc1", 8, -0x398, S1),   # +0x68 z = -sy*sp
    _fpu("mul.s", 8, 5, 7), _fpu("swc1", 8, -0x394, S1),               # +0x6C w = cy*cp
    "lui t0, 0x47", "lq t1, -0x3110(t0)", "sq t1, -0x390(s1)",         # +0x70 = ojo (J2+0x100)
    "lui t1, 0x3f80", "sw t1, -0x384(s1)",
    "lw t0, -0x36c(s1)", "beq t0, zero, NOJ2", "nop",                  # +0x94: la fuente es el stub
    "lq t1, -0x3a0(s1)", "sq t1, -0x3c0(s1)", "lq t1, -0x390(s1)", "sq t1, -0x3b0(s1)",
    "NOJ2:",
]

FUENTE = [
    "addiu sp, sp, -96", "sd ra, 0(sp)", "sq s0, 16(sp)", "sq s1, 32(sp)", "sq s2, 48(sp)",
    "or s0, a0, zero", "lui s1, 0x47",
    "lw t0, -0x378(s1)", "addiu t0, t0, 1", "sw t0, -0x378(s1)",        # contador de llamadas
    "lw t0, -0x380(s1)", "beq t0, zero, SOLO", "nop",
    # (88e) solo con J2 corriendo: FASE (0x0046D790) = 2 y ESTADO (0x0046D784) = 3 de coop_mod.py
    "lw t0, -0x2870(s1)", "addiu t1, zero, 2", "bne t0, t1, SOLO", "nop",
    "lw t0, -0x287c(s1)", "addiu t1, zero, 3", "bne t0, t1, SOLO", "nop",
    "VISTA_J2",
    # (88e) el sub-raster de la camara de escena, leido aca y no escrito por Python (DATOS+0x84 queda sin uso)
    "lui t0, 0x41", "lw t0, -0xb40(t0)", "ori t1, zero, 0xd400", "addu t0, t0, t1",
    "lw t0, 0x58(t0)", "lw s2, 0x60(t0)", "lw t1, -0x374(s1)", "sw t1, 0xc(s2)", "sh zero, 0x1c(s2)",
    # (89) LA PROPORCION: vw.x = tan(FOV/2)*(R+0xD470) y vw.y = vw.x/(R+0xD474) (FUN_0027B2F0, (84)); con
    # las dos a x0,5 la mitad tiene la mitad del campo horizontal y el MISMO vertical: no se aplasta.
    # Se guardan en DATOS+0x30/+0x34, se dividen si DATOS+0x38 != 0, SYNC, y se restauran antes del SYNC final.
    # (93v) PROPORCION PROPIA: en lugar de GUARDAR lo que hay en R+0xD470/74, se TOMA de DATOS+0x30/+0x34
    # (4/3 y 16/9, constantes que pone el pnach) y se escribe en la camara. Mismas 4 palabras, nada se corre.
    # Asi el mod es el UNICO que escribe esas dos palabras: el parche comunitario «Widescreen 16:9» las
    # reescribia en cada cuadro desde el emulador y pisaba la mitad entre las dos pasadas (el parpadeo, (93t)).
    "lui t0, 0x41", "lw t0, -0xb40(t0)", "ori t1, zero, 0xd400", "addu t0, t0, t1",
    "PROPORCION",
    "lw t2, -0x3c8(s1)", "beq t2, zero, SINPROP", "nop",
    "lui t2, 0x3f00", _fpu("mtc1", T2, 1),
    _fpu("lwc1", 4, 0x70, T0), _fpu("mul.s", 4, 4, 1), _fpu("swc1", 4, 0x70, T0),
    _fpu("lwc1", 5, 0x74, T0), _fpu("mul.s", 5, 5, 1), _fpu("swc1", 5, 0x74, T0),
    "SYNC",
    "SINPROP:",
    "addiu t2, zero, 1", "sw t2, -0x3c4(s1)",                          # (89b) DATOS+0x3C: en pasada dividida
    "jal 0x1297e0", "or a0, s0, zero",                                  # pasada 1: J, izquierda
    "lui t0, 0x41", "lw t0, -0xb44(t0)",
    "lq t1, 0x710(t0)", "sq t1, -0x400(s1)", "lq t1, 0x720(t0)", "sq t1, -0x3f0(s1)",
    "lq t1, -0x3c0(s1)", "sq t1, 0x710(t0)", "lq t1, -0x3b0(s1)", "sq t1, 0x720(t0)",
    "SYNC",
    "lw t1, -0x374(s1)", "sh t1, 0x1c(s2)",
    "jal 0x1297e0", "or a0, s0, zero",                                  # pasada 2: J2, derecha
    "lui t0, 0x41", "lw t0, -0xb44(t0)",
    "lq t1, -0x400(s1)", "sq t1, 0x710(t0)", "lq t1, -0x3f0(s1)", "sq t1, 0x720(t0)",
    "lui t0, 0x41", "lw t0, -0xb40(t0)", "ori t1, zero, 0xd400", "addu t0, t0, t1",   # (89) proporcion
    "lw t2, -0x3d0(s1)", "sw t2, 0x70(t0)", "lw t2, -0x3cc(s1)", "sw t2, 0x74(t0)",
    # (89c) el raster entero ANTES del SYNC final: si no, el tinte de abajo se dibuja con el viewport de la
    # mitad derecha (banda amarilla desde x = 320, visto por el pnach)
    "lw t1, -0x370(s1)", "sw t1, 0xc(s2)", "sh zero, 0x1c(s2)",
    "SYNC",
    # (89b) el tinte de pantalla completa, UNA vez y con el raster entero (el filtro lo salteo en las pasadas)
    # (90) ...y esa llamada era la BANDA AMARILLA de la mitad derecha: sin ella sale limpia, al reponerla vuelve
    # (capturas-90, con control). Queda en nop -- el tinte de dano/fundido no se dibuja con la pantalla partida.
    # Mismas palabras que antes, a proposito: nada se corre de lugar.
    "sw zero, -0x3c4(s1)",
    "lui t0, 0x41", "lw a0, -0xb40(t0)", "ori t1, zero, 0xd290", "nop", "addu a0, a0, t1",
    "b FIN", "nop",
    "SOLO:", "jal 0x1297e0", "or a0, s0, zero",
    "FIN:", "ld ra, 0(sp)", "lq s0, 16(sp)", "lq s1, 32(sp)", "lq s2, 48(sp)",
    "jr ra", "addiu sp, sp, 96",
]
# (93v) la proporcion de la camara de escena: con PROPORCION_PROPIA el stub la toma de DATOS+0x30/+0x34
# (4/3 y 16/9, lo que ponia el parche comunitario) en lugar de guardar lo que encuentra. Sin eso (False) es
# el stub de (89) tal cual, que depende de que nadie mas escriba R+0xD470/74 durante el cuadro.
ASPECTO_X, ASPECTO_Y = 0x3FAAAAAB, 0x3FE38E39
PROPORCION_PROPIA = True
PROPORCION_GUARDAR = ["lw t2, 0x70(t0)", "sw t2, -0x3d0(s1)", "lw t2, 0x74(t0)", "sw t2, -0x3cc(s1)"]
PROPORCION_TOMAR = ["lw t2, -0x3d0(s1)", "sw t2, 0x70(t0)", "lw t2, -0x3cc(s1)", "sw t2, 0x74(t0)"]
SYNC = ["lui t0, 0x41", "lw a0, -0xb40(t0)", "jal 0x1ae998", "addiu a1, zero, 1",
        "lui t0, 0x41", "lw a0, -0xb40(t0)", "ori t1, zero, 0xd400", "jal 0x1b0948", "addu a0, a0, t1"]


# (89b) EL FILTRO del tinte a pantalla completa FUN_001B0AC8(R+0xD290), cuyo jal esta en 0x00129AD0 dentro de
# FUN_001297E0: durante las pasadas divididas (DATOS+0x3C != 0) vuelve sin dibujar; si no, salta a la original
# con a0 intacto. Sin esto cada mitad recibe el efecto entero (el "fantasma" amarillo con el HUD adentro).
FILTRO = 0x0046FB00
SITIO_FILTRO = 0x00129AD0
FILTRO_FUENTE = ["lui t0, 0x47", "lw t0, -0x3c4(t0)", "bne t0, zero, 0x%x" % (FILTRO + 0x18), "nop",
                 "j 0x1b0ac8", "nop", "jr ra", "nop"]


def codigo_filtro() -> list[int]:
    return [ensamblar(t, FILTRO + 4 * i) for i, t in enumerate(FILTRO_FUENTE)]


def codigo() -> list[int]:
    lineas = []
    prop = PROPORCION_TOMAR if PROPORCION_PROPIA else PROPORCION_GUARDAR
    for t in FUENTE:
        lineas.extend(SYNC if t == "SYNC" else VISTA_J2 if t == "VISTA_J2" else prop if t == "PROPORCION" else [t])
    etiquetas, instr = {}, []
    for t in lineas:
        if t.endswith(":"):
            etiquetas[t[:-1]] = STUB + 4 * len(instr)
        else:
            instr.append(t)
    out = []
    for i, t in enumerate(instr):
        if t.startswith(".word"):
            out.append(int(t.split()[1], 16))
            continue
        for k, v in etiquetas.items():
            t = t.replace(k, hex(v))
        out.append(ensamblar(t, STUB + 4 * i))
    assert STUB + 4 * len(out) <= FILTRO
    return out


def cuat_de_matriz(m: list[list[float]]) -> list[float]:
    """Filas de RW (right, up, at) -> cuaternion (x, y, z, w) con la convencion de la vista
    del gestor (R = M transpuesta; verificado con `cuat` contra gestor+0x710)."""
    r = [[m[j][i] for j in range(3)] for i in range(3)]
    t = r[0][0] + r[1][1] + r[2][2]
    if t > 0:
        s = math.sqrt(t + 1.0) * 2
        q = [(r[2][1] - r[1][2]) / s, (r[0][2] - r[2][0]) / s, (r[1][0] - r[0][1]) / s, 0.25 * s]
    elif r[0][0] > r[1][1] and r[0][0] > r[2][2]:
        s = math.sqrt(1.0 + r[0][0] - r[1][1] - r[2][2]) * 2
        q = [0.25 * s, (r[0][1] + r[1][0]) / s, (r[0][2] + r[2][0]) / s, (r[2][1] - r[1][2]) / s]
    elif r[1][1] > r[2][2]:
        s = math.sqrt(1.0 + r[1][1] - r[0][0] - r[2][2]) * 2
        q = [(r[0][1] + r[1][0]) / s, 0.25 * s, (r[1][2] + r[2][1]) / s, (r[0][2] - r[2][0]) / s]
    else:
        s = math.sqrt(1.0 + r[2][2] - r[0][0] - r[1][1]) * 2
        q = [(r[0][2] + r[2][0]) / s, (r[1][2] + r[2][1]) / s, 0.25 * s, (r[1][0] - r[0][1]) / s]
    return q


def floats(p: Pine, d: int, n: int) -> list[float]:
    return list(struct.unpack("<%df" % n, p.leer_bloque(d, 4 * n)))


def vista_de(p: Pine, jug: int) -> tuple[list[float], list[float]]:
    m = [floats(p, jug + 0xD0 + 0x10 * k, 3) for k in range(3)]
    ojo = floats(p, jug + 0x100, 3)
    return cuat_de_matriz(m), ojo


def raster(p: Pine) -> int:
    return p.leer32(p.leer32(p.leer32(G_RENDER) + 0xD400 + 0x58) + 0x60)


def cmd_poner(_a) -> int:
    with Pine() as p:
        for s in SITIOS:
            w = p.leer32(s)
            if w not in (ORIGINAL, ensamblar("jal 0x%x" % STUB, s)):
                print(json.dumps({"error": "sitio inesperado", "sitio": hex(s), "palabra": hex(w)}))
                return 1
        p.escribir_bloque(DATOS, bytes(0x98))
        p.escribir32(DATOS + 0x84, raster(p))
        p.escribir32(DATOS + 0x8C, MEDIO)
        p.escribir32(DATOS + 0x90, ENTERO)
        p.escribir32(DATOS + 0x30, ASPECTO_X)   # (93v) la proporcion propia
        p.escribir32(DATOS + 0x34, ASPECTO_Y)
        c = codigo()
        p.escribir_bloque(STUB, struct.pack("<%dI" % len(c), *c))
        f = codigo_filtro()
        p.escribir_bloque(FILTRO, struct.pack("<%dI" % len(f), *f))
        p.escribir32(SITIO_FILTRO, ensamblar("jal 0x%x" % FILTRO, SITIO_FILTRO))
        for s in SITIOS:
            p.escribir32(s, ensamblar("jal 0x%x" % STUB, s))
        print(json.dumps({"stub": hex(STUB), "instrucciones": len(c), "fin": hex(STUB + 4 * len(c)),
                          "raster": hex(p.leer32(DATOS + 0x84))}))
    return 0


def cmd_quitar(_a) -> int:
    with Pine() as p:
        p.escribir32(DATOS + 0x80, 0)
        for s in SITIOS:
            p.escribir32(s, ORIGINAL)
        p.escribir32(SITIO_FILTRO, ensamblar("jal 0x1b0ac8", SITIO_FILTRO))
        print(json.dumps({"sitios": [hex(p.leer32(s)) for s in SITIOS], "filtro": hex(p.leer32(SITIO_FILTRO))}))
    return 0


def cmd_apagar(_a) -> int:
    with Pine() as p:
        p.escribir32(DATOS + 0x80, 0)
    return 0


def cmd_vista2(a) -> int:
    with Pine() as p:
        fin = time.time() + a.segundos
        n = 0
        while True:
            if a.fuente == "igual-J":          # control positivo: la misma vista que J
                g = p.leer32(G_CAMARA)
                q, ojo = floats(p, g + 0x710, 4), floats(p, g + 0x720, 3)
            elif a.fuente == "mira":           # yaw de la mira de J2 (grados), sin cabeceo
                y = math.radians(p.leer_f32(p.leer32(J2 + 0x32C) + 8))
                q, ojo = [0.0, math.sin(y / 2), 0.0, math.cos(y / 2)], floats(p, J2 + 0x100, 3)
            else:                              # la matriz +0xD0 de J2
                q, ojo = vista_de(p, J2)
            p.escribir_bloque(DATOS + 0x40, struct.pack("<4f4f", *q, *ojo, 1.0))
            if n == 0:
                p.escribir32(DATOS + 0x80, 1)
            n += 1
            if time.time() >= fin:
                break
            time.sleep(0.01)
        if not a.dejar:
            p.escribir32(DATOS + 0x80, 0)
        print(json.dumps({"actualizaciones": n, "cuat_J2": [round(x, 3) for x in q],
                          "ojo_J2": [round(x, 3) for x in ojo], "dividida_sigue": bool(a.dejar)}))
    return 0


def cmd_ritmo(a) -> int:
    with Pine() as p:
        c0 = p.leer32(DATOS + 0x88); t0 = time.time()
        time.sleep(a.segundos)
        c1 = p.leer32(DATOS + 0x88); t1 = time.time()
        print(json.dumps({"llamadas_por_s": round((c1 - c0) / (t1 - t0), 2),
                          "dividida": p.leer32(DATOS + 0x80)}))
    return 0


def cmd_cuat(_a) -> int:
    with Pine() as p:
        j = p.leer32(G_JUEGO := 0x0040F4D0) + 0x30
        q, ojo = vista_de(p, j)
        g = p.leer32(G_CAMARA)
        print(json.dumps({"calculado": [round(x, 4) for x in q], "juego": [round(x, 4) for x in floats(p, g + 0x710, 4)],
                          "ojo": [round(x, 3) for x in ojo], "ojo_juego": [round(x, 3) for x in floats(p, g + 0x720, 3)]}))
    return 0


def cmd_fuente_stub(a) -> int:
    """(88b) DATOS+0x94: 1 = la vista de J2 la calcula el stub; 0 = la escribe Python (vista2)."""
    with Pine() as p:
        p.escribir32(DATOS + 0x94, a.valor)
        if a.prender:
            p.escribir32(DATOS + 0x80, 1)
        print(json.dumps({"fuente_stub": p.leer32(DATOS + 0x94), "dividida": p.leer32(DATOS + 0x80)}))
    return 0


def cmd_comparar(a) -> int:
    """(88b) control numerico: lo que el stub dejo en DATOS+0x60/+0x70 contra la formula de Python."""
    with Pine() as p:
        peor, n = 0.0, 0
        fin = time.time() + a.segundos
        while True:
            m = p.leer32(J2 + 0x32C)
            y, c = math.radians(p.leer_f32(m + 8)) / 2, -math.radians(p.leer_f32(m + 0xC)) / 2   # (88d)
            sy, cy, sp, cp = math.sin(y), math.cos(y), math.sin(c), math.cos(c)
            py = [cy * sp, sy * cp, -sy * sp, cy * cp] + floats(p, J2 + 0x100, 3) + [1.0]
            st = floats(p, DATOS + 0x60, 8)
            peor, n = max(peor, max(abs(u - v) for u, v in zip(py, st))), n + 1
            if time.time() >= fin:
                break
            time.sleep(0.05)
        print(json.dumps({"muestras": n, "peor_diferencia": peor, "stub": [round(x, 4) for x in st],
                          "python": [round(x, 4) for x in py], "llamadas": p.leer32(DATOS + 0x88)}))
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("poner"); sub.add_parser("quitar"); sub.add_parser("apagar"); sub.add_parser("cuat")
    f = sub.add_parser("fuente-stub"); f.add_argument("valor", type=int, choices=(0, 1))
    f.add_argument("--prender", action="store_true")
    c = sub.add_parser("comparar"); c.add_argument("segundos", type=float)
    v = sub.add_parser("vista2"); v.add_argument("segundos", type=float); v.add_argument("--dejar", action="store_true")
    v.add_argument("--fuente", choices=("mira", "matriz", "igual-J"), default="mira")
    r = sub.add_parser("ritmo"); r.add_argument("segundos", type=float)
    a = ap.parse_args()
    return {"poner": cmd_poner, "quitar": cmd_quitar, "apagar": cmd_apagar, "vista2": cmd_vista2,
            "ritmo": cmd_ritmo, "cuat": cmd_cuat, "fuente-stub": cmd_fuente_stub, "comparar": cmd_comparar}[a.cmd](a)


if __name__ == "__main__":
    sys.exit(main())
