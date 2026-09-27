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
    Con FASE 2 la carga siguiente vuelve a armar el molde (jugador2.py no lo hacia).
  POR CUADRO (sitio 0x00129574, jal 0x0013BAC8), con FASE 2:
    ESTADO 0: espera 30 cuadros; despues CONTROL2 (J2+0x588/+0x6D0/+0x7C8 = CTRL2 =
              *(J+0x588) + 0x16C, J2+0x32C = J2+0x4F0) y ENLAZAR FUN_0012a158(juego, J2)
    ESTADO 1: ATAR FUN_0025C210(*(0x0040F4CC), J2)
    ESTADO 3: controlador y update de J2 cada cuadro (lo de jugador2.py)

Las MANOS de la prueba (no son del mod): `manos` clona el mando 2 en el falso 2, apunta
CTRL2+0xC ahi y empuja el eje adelante. Es lo que haria un humano con el mando 2.

    python herramientas/coop_mod.py listar
    python herramientas/coop_mod.py poner       # EN PAUSA: pone a cero datos y J2, escribe codigo y ganchos
    python herramientas/coop_mod.py mirar 40    # registra fase, estado, moldes, atadas, J2
    python herramientas/coop_mod.py manos 2 [--control]
    python herramientas/coop_mod.py toml        # escribe mods/coop.toml (el pnach lo compila)
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

# datos: .bss en cero al arrancar; NINGUNO va en el pnach
CONTADOR, ESTADO, FASE = 0x0046D780, 0x0046D784, 0x0046D790
LLAM_J2, LLAM_J0 = 0x0046D794, 0x0046D79C
MIGA_A, MIGA_B, MIGA_V0, MIGA_C = 0x0046D7A0, 0x0046D798, 0x0046D7A4, 0x0046D7A8
ESPERA, MOLDES, ATADAS = 0x0046D7B8, 0x0046D7C0, 0x0046D7C4
DATOS = (CONTADOR, ESTADO, FASE, LLAM_J2, LLAM_J0, MIGA_A, MIGA_B, MIGA_V0, MIGA_C, ESPERA, MOLDES, ATADAS)
CUADROS_ESPERA = 30

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
addiu t1, t1, 0x16c
addiu a1, s0, -0x3210
sw t1, 0x588(a1)
sw t1, 0x6d0(a1)
sw t1, 0x7c8(a1)
addiu t2, a1, 0x4f0
sw t2, 0x32c(a1)
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
lw t1, -0x2880(s0)
addiu t1, t1, 1
sw t1, -0x2880(s0)
SALIR:
ld s0, 8(sp)
ld ra, 0(sp)
jr ra
addiu sp, sp, 0x30
"""


def programas():
    """[(nombre, [(pc, palabra, texto)])] -- lo unico que va en el pnach, junto con los ganchos."""
    env = j2.ensamblar_programa(ENVOLTORIO_MOD, j2.ENVOLTORIO, j2.ARMAS2)
    pc = j2.ensamblar_programa(POR_CUADRO_MOD.replace("ESPERA_N", str(CUADROS_ESPERA)), j2.STUB, 0x0046D9F0)
    ganchos = [(g.SITIO, ensamblar("jal 0x%x" % j2.STUB, g.SITIO), "gancho por cuadro: jal stub (era jal 0x13bac8)"),
               (j2.SITIO_CARGA, ensamblar("jal 0x%x" % j2.ENVOLTORIO, j2.SITIO_CARGA),
                "gancho del cargador: jal envoltorio (era jal 0x129090)")]
    return [("envoltorio", env), ("por cuadro", pc), ("ganchos", ganchos)]


def depurador(accion):
    dep = str(Path(__file__).resolve().parent / "depurador.py")
    return subprocess.run([sys.executable, dep, accion], capture_output=True, text=True)


def cmd_listar(_a):
    for nombre, prog in programas():
        print("== %s: %d palabras, %#010x..%#010x" % (nombre, len(prog), prog[0][0], prog[-1][0] + 4))
        for pc, w, t in prog:
            print("0x%08X  %08X  %s" % (pc, w, t))
    return 0


def cmd_poner(_a):
    progs = programas()
    with Pine() as p:
        if p.leer32(g.SITIO) != g.ORIGINAL or p.leer32(j2.SITIO_CARGA) != j2.ORIGINAL_CARGA:
            print(json.dumps({"error": "un gancho ya esta puesto o el sitio cambio",
                              "por_cuadro": hex(p.leer32(g.SITIO)), "cargador": hex(p.leer32(j2.SITIO_CARGA))}))
            return 1
        depurador("pausar")
        # lo que el arranque deja en cero: J2, sus armas y los datos del mod
        p.escribir_bloque(cj.J2, bytes(cj.TAM))
        p.escribir_bloque(j2.ARMAS2, bytes(0x20))
        for d in DATOS:
            p.escribir32(d, 0)
        for nombre, prog in progs[:2]:
            for pc, w, _ in prog:
                p.escribir32(pc, w)
        for pc, w, _ in progs[2][1]:
            p.escribir32(pc, w)
        ok = all(p.leer32(pc) == w for _, prog in progs for pc, w, _ in prog)
        depurador("continuar")
        print(json.dumps({"palabras": sum(len(x[1]) for x in progs), "escrito": ok}))
    return 0 if ok else 1


def leer_estado(p):
    jg = p.leer32(cj.JUEGO_PTR)
    return {"cargador": p.leer32(jg + 0x5AA0), "fase": p.leer32(FASE), "moldes": p.leer32(MOLDES),
            "llam_J0": p.leer32(LLAM_J0), "llam_J2": p.leer32(LLAM_J2), "estado": p.leer32(ESTADO),
            "espera": p.leer32(ESPERA), "atadas": p.leer32(ATADAS), "cuadros_J2": p.leer32(CONTADOR),
            "J2_8A4": hex(p.leer32(cj.J2 + 0x8A4)), "J2_B4": hex(p.leer32(cj.J2 + 0xB4)),
            "J2_588": hex(p.leer32(cj.J2 + 0x588)), "J2_32C": hex(p.leer32(cj.J2 + 0x32C)),
            "J_pos": [round(x, 2) for x in cj.pos(p, cj.J)], "J2_pos": [round(x, 2) for x in cj.pos(p, cj.J2)]}


def cmd_mirar(a):
    with Pine() as p:
        ult, t0 = None, time.time()
        while time.time() - t0 < a.segundos:
            try:
                d = leer_estado(p)
                clave = {k: v for k, v in d.items() if k not in ("cuadros_J2", "espera", "J_pos", "J2_pos")}
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
        if not ctrl2:
            print(json.dumps({"error": "J2+0x588 = 0: el mod todavia no preparo el control2"}))
            return 1
        fuente = p.leer32(ctrl2 + 0xC)
        if fuente != cj.FALSO2:
            f2 = bytearray(p.leer_bloque(fuente, 0xF0))
            for o in range(0x8C, 0xCC, 4):
                f2[o:o + 4] = b"\0\0\0\0"
            f2[0x0E:0x2A + 28] = bytes(0x2A + 28 - 0x0E)
            p.escribir_bloque(cj.FALSO2, bytes(f2))
            p.escribir32(ctrl2 + 0xC, cj.FALSO2)
        antes = cj.pos(p, cj.J2)
        p.escribir_f32(cj.FALSO2 + 0x8C, 0.0 if a.control else 0.8)
        time.sleep(a.segundos)
        p.escribir_f32(cj.FALSO2 + 0x8C, 0.0)
        despues = cj.pos(p, cj.J2)
        print(json.dumps({"ctrl2": hex(ctrl2), "fuente_original": hex(fuente), "control": a.control,
                          "J2_antes": [round(x, 2) for x in antes], "J2_despues": [round(x, 2) for x in despues],
                          "metros": round(math.dist(antes, despues), 2)}))
    return 0


def cmd_quitar(_a):
    with Pine() as p:
        p.escribir32(g.SITIO, g.ORIGINAL)
        p.escribir32(j2.SITIO_CARGA, j2.ORIGINAL_CARGA)
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


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    for c in ("listar", "poner", "quitar", "toml"):
        sub.add_parser(c)
    m = sub.add_parser("mirar"); m.add_argument("segundos", type=float)
    h = sub.add_parser("manos"); h.add_argument("segundos", type=float); h.add_argument("--control", action="store_true")
    a = ap.parse_args()
    return {"listar": cmd_listar, "poner": cmd_poner, "mirar": cmd_mirar, "manos": cmd_manos,
            "quitar": cmd_quitar, "toml": cmd_toml}[a.cmd](a)


if __name__ == "__main__":
    sys.exit(main())
