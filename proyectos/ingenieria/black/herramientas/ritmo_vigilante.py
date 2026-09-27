#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ritmo_vigilante.py -- cuantas veces POR CUADRO se toca una direccion, y desde donde.

`--accion log` no cuenta nada en este PCSX2 (stub vacio, bitacora de agosto:
"hay que usar --accion break"). Esto usa break: pone el vigilante, espera la
pausa, anota PC y ciclos del EE, continua, y repite N veces. El ritmo sale de
los CICLOS entre disparos, no del reloj de pared: 294.912 MHz / fps ciclos por
cuadro (a 30 fps, 9.830.400).

    python herramientas/ritmo_vigilante.py 0x0043F790 --tipo write -n 8
    python herramientas/ritmo_vigilante.py 0x004CA2F0 --tipo read  -n 8

Siempre quita el vigilante y deja el emulador corriendo al salir. Si en
--espera segundos no dispara, lo dice: eso es un cero MEDIDO con break, que
si vale (a diferencia del de log).
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from depurador import Depurador  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402

RELOJ_EE = 294_912_000


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("direccion")
    ap.add_argument("--tipo", default="write", choices=["write", "read", "readwrite", "onchange"])
    ap.add_argument("-n", type=int, default=8)
    ap.add_argument("--espera", type=float, default=8.0)
    ap.add_argument("--fps", type=float, default=30.0)
    ap.add_argument("--ra", action="store_true", help="en cada disparo, leer ra, a0 y a1")
    a = ap.parse_args()
    dirv = int(a.direccion, 0)
    por_cuadro = RELOJ_EE / a.fps
    hits = []
    with Depurador() as d:
        # Con el juego corriendo, set_memcheck tiro abajo el emulador
        # (2026-09-27). Se pone en pausa y se continua despues.
        if not d.estado().get("paused"):
            d.pausar()
            d.esperar_pausa(segundos=5)
        d.poner_vigilante(dirv, tipo=a.tipo, accion="break", descripcion="ritmo")
        d.continuar()
        try:
            for _ in range(a.n):
                e = d.esperar_pausa(segundos=a.espera)
                if not e:
                    break
                pc = int(str(e.get("pc", "0")), 0) if not isinstance(e.get("pc"), int) else e["pc"]
                cyc = int(e.get("cycles", 0))
                if a.ra:   # el llamador: un getter hoja no dice quien lo pidio (bitacora (79))
                    extra = {r: d.evaluar(r) for r in ("ra", "a0", "a1")}
                    print("  pc 0x%08X  %s" % (pc, " ".join("%s=%s" % (k, v.get("value", v) if isinstance(v, dict) else v)
                                                          for k, v in extra.items())))
                hits.append((pc, cyc))
                d.continuar()
        finally:
            d.quitar_vigilante(dirv)
            try:
                if d.estado().get("paused"):
                    d.continuar()
            except Exception:
                pass
    if not hits:
        print("0 disparos en %.0f s con break: nadie hace %s en 0x%08X" % (a.espera, a.tipo, dirv))
        return 0
    print("%d disparos (%s en 0x%08X)" % (len(hits), a.tipo, dirv))
    prev = None
    for pc, cyc in hits:
        dc = "" if prev is None else "%+12d ciclos = %.2f cuadros" % (cyc - prev, (cyc - prev) / por_cuadro)
        print("  pc 0x%08X  ciclos %d  %s" % (pc, cyc, dc))
        prev = cyc
    return 0


if __name__ == "__main__":
    sys.exit(main())
