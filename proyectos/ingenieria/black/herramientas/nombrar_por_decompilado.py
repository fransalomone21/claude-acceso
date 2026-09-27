#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
nombrar_por_decompilado.py — E5/E6 de docs/14: qué es cada singleton, por lo
que dice el código que lo usa. Sin Ghidra: lee el decompilado de E2.

Por cada singleton de `censo_subsistemas.SINGLETONS`, sobre las funciones que
lo referencian (`indice.json`, referencias de Ghidra):
  - las cadenas que esas funciones usan (literales y `s_..._XXXXXXXX`),
    ponderadas por RAREZA: una cadena que aparece en funciones de muchos
    singletons no dice nada de ninguno (es el ruido que ya documentó
    nombrar_subsistemas.py con la función compartida);
  - las otras singletons que tocan las mismas funciones (con quién convive).

Es EVIDENCIA PARA UNA HIPÓTESIS (K2), no un nombre confirmado.

    python herramientas/nombrar_por_decompilado.py 0x0040F510 0x0040F4C0
    python herramientas/nombrar_por_decompilado.py --todos
"""
import argparse
import collections
import json
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from censo_subsistemas import SINGLETONS  # noqa: E402
from leer_c import cuerpo  # noqa: E402

DEC = Path(os.environ.get("BLACK_DATOS", "/home/user/black-datos")) / "decompilado"
LIT = re.compile(r'"((?:[^"\\]|\\.){4,80})"')
SLAB = re.compile(r"\bs_([A-Za-z0-9_]{4,60})_[0-9a-f]{8}\b")


HEX = re.compile(r"\b(?:0x|DAT_|PTR_[A-Za-z0-9_]*?_|s_[A-Za-z0-9_]*?_)00?([34][0-9a-f]{5})\b")
_ELF = None


def texto_en(va: int):
    """La cadena C del ELF en esa dirección virtual, si la hay."""
    global _ELF
    if _ELF is None:
        import struct
        e = open(Path(os.environ.get("BLACK_DATOS", "/home/user/black-datos")) / "SLUS_213.76", "rb").read()
        off, n = struct.unpack_from("<I", e, 0x1C)[0], struct.unpack_from("<H", e, 0x2C)[0]
        segs = [struct.unpack_from("<6I", e, off + 32 * k) for k in range(n)]
        _ELF = (e, [(va_, o, fs) for t, o, va_, pa, fs, ms in segs if t == 1])
    e, segs = _ELF
    for va_, o, fs in segs:
        if va_ <= va < va_ + fs:
            i = o + va - va_
            j = e.find(b"\0", i, i + 81)
            if j > i + 3:
                t = e[i:j]
                if all(32 <= b < 127 for b in t):
                    return t.decode()
    return None


def cadenas(c: str) -> set:
    out = set(m.group(1) for m in LIT.finditer(c))
    out |= set(m.group(1) for m in SLAB.finditer(c))
    for m in HEX.finditer(c):
        va = int(m.group(1), 16)
        if 0x003BC380 <= va < 0x0040E580:
            t = texto_en(va)
            if t:
                out.add(t)
    return {x for x in out if re.search(r"[A-Za-z]{3}", x)}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("globales", nargs="*")
    ap.add_argument("--todos", action="store_true")
    ap.add_argument("--n", type=int, default=25)
    a = ap.parse_args()
    idx = json.loads((DEC / "indice.json").read_text(encoding="utf-8"))["por_singleton"]
    # cadenas de cada función, y en cuántos singletons aparece cada cadena
    por_func = {}
    for g, d in idx.items():
        for f in d["funciones"]:
            if f != "-" and f not in por_func:
                por_func[f] = cadenas(cuerpo(f))
    cad_en = collections.defaultdict(set)
    for g, d in idx.items():
        for f in d["funciones"]:
            for c in por_func.get(f, ()):
                cad_en[c].add(g)
    objetivos = [f"0x{g:08X}" for g, _, _ in SINGLETONS] if a.todos else \
        [f"0x{int(x, 16):08X}" for x in a.globales]
    for g in objetivos:
        d = idx[g]
        fs = [f for f in d["funciones"] if f != "-"]
        cuenta = collections.Counter()
        for f in fs:
            for c in por_func.get(f, ()):
                cuenta[c] += 1
        puntaje = sorted(cuenta.items(), key=lambda kv: (-kv[1] / len(cad_en[kv[0]]), kv[0]))
        vecinos = collections.Counter()
        for f in fs:
            for h, e in idx.items():
                if h != g and f in e["funciones"]:
                    vecinos[h] += 1
        print(f"== {g}  ({d['tam']} B, {len(fs)} funciones, {d['constructor'] or 'sin constructor'})")
        print("   cadenas propias (funciones que la usan / singletons donde aparece):")
        for c, n in puntaje[: a.n]:
            print(f"     {n:>3}/{len(cad_en[c]):<2} {c}")
        print("   convive con: " + ", ".join(f"{h} ({n})" for h, n in vecinos.most_common(6)))


if __name__ == "__main__":
    main()
