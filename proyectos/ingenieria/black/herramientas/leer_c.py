#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""leer_c.py — leer el decompilado de E2 SIN abrir Ghidra (sin JVM: instantáneo).

    python herramientas/leer_c.py 0x0026A460            # C + quién la llama + a quién llama
    python herramientas/leer_c.py 0x0026A460 --sin-c    # sólo el vecindario
    python herramientas/leer_c.py 0x0026A460 --arriba 3 # cadena de llamadores, 3 niveles

Lee `$BLACK_DATOS/decompilado/` (privado), que escribe decompilar_todo.py.
Acepta cualquier dirección dentro de la función.
"""
import argparse
import bisect
import json
import os
import re
from pathlib import Path

DEC = Path(os.environ.get("BLACK_DATOS", "/home/user/black-datos")) / "decompilado"


def cargar():
    g = json.loads((DEC / "grafo.json").read_text(encoding="utf-8"))
    return g, sorted(int(k, 16) for k in g)


def entrada(g, ents, a):
    i = bisect.bisect_right(ents, a) - 1
    return f"0x{ents[i]:08X}"


def cuerpo(e):
    a = int(e, 16)
    s = (DEC / f"0x{a >> 16:04X}.c").read_text(encoding="utf-8")
    m = re.search(rf"/\* ==== {e} .*?\*/\n", s)
    if not m:
        return "(sin decompilado)"
    j = s.find("/* ==== 0x", m.end())
    return s[m.end(): j if j > 0 else None]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dir")
    ap.add_argument("--sin-c", action="store_true")
    ap.add_argument("--arriba", type=int, default=1)
    a = ap.parse_args()
    g, ents = cargar()
    e = entrada(g, ents, int(a.dir, 16))
    n = g[e]
    print(f"== {e} {n['nombre']}")
    nivel = [e]
    for k in range(a.arriba):
        sig = []
        for x in nivel:
            por = g[x]["llamada_por"]
            d = g[x]["datos"]
            print(f"  {'  ' * k}{x} <- " + (" ".join(por) or "-") + (f"  [desde datos: {' '.join(d)}]" if d else ""))
            sig += por
        nivel = sorted(set(sig))
        if not nivel:
            break
    print(f"  llama a: {' '.join(n['llama']) or '-'}")
    if not a.sin_c:
        print(cuerpo(e))


if __name__ == "__main__":
    main()
