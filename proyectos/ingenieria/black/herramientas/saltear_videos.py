#!/usr/bin/env python3
"""saltear_videos.py -- (93w) Start saltea cualquier video del juego (bloque propio del pnach, para todos los accesos).

Lo que se leyo en frio (bitacora (93w)):
  - Hay UN reproductor de video: V = *(0x0040F0E0)+0x2026C (el menu, FE = +0x20220, lo tiene en +0x4C). Lo
    actualiza la del menu (FUN_001046b0) en 0x00104B80: `jal 0x109918` con a0 = V en el delay slot.
  - V+0x1A8 es su estado: 0x1C = reproduciendo, 0x1D = cortando, 0x37 = quieto. V+0x198 bit 0 = en bucle (el fondo
    del menu). V+0x1B9 = pedido de corte: en 0x1C, FUN_00109918 corta el video por EL MISMO camino que cuando se
    termina solo (0x1C -> 0x1D -> FUN_00109cf8 -> 0x37), y con 0x37 el menu avisa `FmvHasFinished`.
  - Los salteos que trae el juego (SkipIntroCredits = FUN_00103c28, StartMainMenuSkip = FUN_00103b38) vuelven sin
    hacer nada si las 4 ranuras de progreso de la partida (tabla 0x0048EFA8, categoria 0) estan en -1: sin haber
    completado un nivel, la intro no se saltea. Este mod no los toca: corta el video directamente.
  - Los mandos procesados: puerto 1 en 0x005856C0, puerto 2 en 0x005857B0; boton i actual en +0x2A+i, anterior en
    +0x0E+i; Start = 8 (bitacora (77)). El menu los lee igual (FUN_0026bc30).

El gancho (SALTEO, 0x0046F700): si V reproduce un video que NO es de bucle y Start acaba de apretarse en cualquiera
de los dos mandos (actual != 0 y anterior == 0), V+0x1B9 = 1. Siempre sigue a FUN_00109918 con a0 intacto.

    python herramientas/saltear_videos.py listar
    python herramientas/saltear_videos.py instalar     # el bloque en el pnach de parches de PCSX2 (APAGADO)
    python herramientas/saltear_videos.py activar      # Enable = ... en los ajustes del juego (desactivar lo saca)
"""
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from mips import ensamblar  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import jugador2 as j2  # noqa: E402

NOMBRE_BLOQUE = "Saltear videos con Start"
SITIO, ORIGINAL = 0x00104B80, ensamblar("jal 0x109918", 0x00104B80)
SALTEO = 0x0046F700            # codigo (libre: 0x0046E580..0x0046F800, docs/14)
SALTEOS = 0x0046F7F0           # dato: cuantos videos se cortaron. No va en el pnach
FUENTE = """
lw t0, 0x1a8(a0)
addiu t1, zero, 0x1c
bne t0, t1, @SEGUIR
lw t0, 0x198(a0)
andi t0, t0, 1
bne t0, zero, @SEGUIR
lui t2, 0x58
lbu t3, 0x56f2(t2)
lbu t4, 0x56d6(t2)
sltu t3, zero, t3
sltiu t4, t4, 1
and t5, t3, t4
lbu t3, 0x57e2(t2)
lbu t4, 0x57c6(t2)
sltu t3, zero, t3
sltiu t4, t4, 1
and t3, t3, t4
or t5, t5, t3
beq t5, zero, @SEGUIR
addiu t6, zero, 1
sb t6, 0x1b9(a0)
lui t7, 0x47
lw t8, -0x810(t7)
addiu t8, t8, 1
sw t8, -0x810(t7)
SEGUIR:
j 0x109918
nop
"""


def programa():
    """[(pc, palabra, texto)] del codigo y el gancho."""
    prog = j2.ensamblar_programa(FUENTE, SALTEO, SALTEOS)
    return prog + [(SITIO, ensamblar("jal 0x%x" % SALTEO, SITIO), "gancho: jal salteo (era jal 0x109918)")]


def bloque_pnach():
    lineas = ["[%s]" % NOMBRE_BLOQUE, "author=proyecto BLACK",
              "description=Start (cualquier mando) corta el video que se esta viendo; el fondo del menu no (bitacora (93w))",
              "// GENERADO por herramientas/saltear_videos.py"]
    for pc, w, t in programa():
        lineas.append("// %s" % t)
        lineas.append("patch=1,EE,%08X,word,%08X" % (pc, w))
    return "\n".join(lineas) + "\n"


def _cm():
    import coop_mod as cm   # las rutas del pnach y de los ajustes, y los respaldos: una sola fuente
    return cm


def _sin_bloque(texto):
    out, dentro = [], False
    for l in texto.splitlines(keepends=True):
        if l.startswith("["):
            dentro = l.strip() == "[%s]" % NOMBRE_BLOQUE
        if not dentro:
            out.append(l)
    return "".join(out)


def cmd_instalar(_a):
    cm = _cm()
    viejo = cm.PARCHES.read_bytes().decode("utf-8")
    nl = "\r\n" if "\r\n" in viejo else "\n"
    nuevo = _sin_bloque(viejo).rstrip("\r\n") + nl + nl + bloque_pnach().replace("\n", nl)
    if nuevo == viejo:
        print(json.dumps({"pnach": str(cm.PARCHES), "cambio": False}))
        return 0
    r = cm._respaldo(cm.PARCHES)
    cm.PARCHES.write_bytes(nuevo.encode("utf-8"))
    print(json.dumps({"pnach": str(cm.PARCHES), "respaldo": r.name, "palabras": len(programa())}))
    return 0


def _ajustes(activar):
    cm = _cm()
    t = cm.AJUSTES.read_bytes().decode("utf-8")
    nl = "\r\n" if "\r\n" in t else "\n"
    linea = "Enable = %s" % NOMBRE_BLOQUE
    ls = [l for l in t.split(nl) if l.strip() != linea]
    if activar:
        ls.insert(ls.index("[Patches]") + 1, linea)
    nuevo = nl.join(ls)
    if nuevo != t:
        cm._respaldo(cm.AJUSTES)
        cm.AJUSTES.write_bytes(nuevo.encode("utf-8"))
    print(json.dumps({"ajustes": str(cm.AJUSTES), "activo": linea in nuevo.split(nl), "cambio": nuevo != t}))
    return 0


def cmd_listar(_a):
    for pc, w, t in programa():
        print("0x%08X  %08X  %s" % (pc, w, t))
    return 0


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    for c in ("listar", "instalar", "activar", "desactivar"):
        sub.add_parser(c)
    a = ap.parse_args()
    return {"listar": cmd_listar, "instalar": cmd_instalar,
            "activar": lambda _a: _ajustes(True), "desactivar": lambda _a: _ajustes(False)}[a.cmd](a)


if __name__ == "__main__":
    sys.exit(main())
