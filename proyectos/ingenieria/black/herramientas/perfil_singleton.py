#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
perfil_singleton.py — E6 de docs/14: qué hace el código con un singleton, cuando
las cadenas no dicen nada (E5 mostró que el motor casi no usa texto).

Sin Ghidra: lee el decompilado de E2 (`$BLACK_DATOS/decompilado/`). Por cada
global `0x0040Fxxx` junta cuatro señales:

  1. ALOJAMIENTO: en qué función se escribe el puntero, con qué tamaño
     (`FUN_00107cf8(n)`) y cuál es la primera llamada que lo recibe (su init).
  2. MÉTODOS: las funciones que lo reciben como PRIMER argumento, con cuántos
     sitios cada una. Es lo más parecido a la interfaz de la clase.
  3. CAMPOS: los desplazamientos que se leen/escriben directo sobre el global.
  4. LAZOS: desde qué raíces del programa se llega a cada método, por el grafo
     de llamadas. Las raíces son las entradas de las vtables de los cuatro
     modos de la sesión (bitácora (71)) más la carga (`FUN_00102930`), el
     arranque (`FUN_001020C0`) y el update del juego por cuadro
     (`FUN_00129360`, que cuelga de `main` y NO pasa por las vtables: sin esta
     raíz, la mitad de los updates salían «sin lazo»; bitácora (73)). Un método que sólo cuelga de la carga es
     inicialización; uno que cuelga del método 2 de un modo de juego corre
     por cuadro.

Es EVIDENCIA PARA UNA HIPÓTESIS (K2), no un nombre confirmado.

    python herramientas/perfil_singleton.py 0x0040F4C8
    python herramientas/perfil_singleton.py 0x0040F4C8 --c     # + el C de cada método
"""
import argparse
import collections
import json
import os
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from leer_c import cuerpo  # noqa: E402

import sys as _sys
_sys.path.insert(0, str(Path(__file__).resolve().parent))
from ubicaciones import carpeta_black_datos as _carpeta_black_datos  # noqa: E402
BD = _carpeta_black_datos()
DEC = BD / "decompilado"

# vtables de los modos (bitácora (71)); cada entrada son 8 B en GCC 2.9x
MODOS = {"FE": 0x003DB5E8, "B": 0x003DB590, "A": 0x003DB4E0, "vacio": 0x003DB538}
FIJAS = {"arranque": 0x001020C0, "carga": 0x00102930, "juego.cuadro": 0x00129360}


def palabra_elf(va):
    e = palabra_elf.e = getattr(palabra_elf, "e", None) or (BD / "SLUS_213.76").read_bytes()
    off, n = struct.unpack_from("<I", e, 0x1C)[0], struct.unpack_from("<H", e, 0x2C)[0]
    for k in range(n):
        t, o, v, pa, fs, ms = struct.unpack_from("<6I", e, off + 32 * k)
        if t == 1 and v <= va < v + fs:
            return struct.unpack_from("<I", e, o + va - v)[0]
    return None


def raices():
    r = {k: f"0x{v:08X}" for k, v in FIJAS.items()}
    for m, vt in MODOS.items():
        for i in range(1, 6):
            f = palabra_elf(vt + 8 * i + 4)
            if f and 0x00100000 <= f < 0x00397000:
                r[f"{m}.{i}"] = f"0x{f:08X}"
    return r


def descendientes(g, raiz, tope=4000):
    vis, pila = {raiz}, [raiz]
    while pila and len(vis) < tope:
        x = pila.pop()
        for y in g.get(x, {}).get("llama", []):
            if y not in vis:
                vis.add(y)
                pila.append(y)
    return vis


def todo_c():
    for p in sorted(DEC.glob("0x*.c")):
        s = p.read_text(encoding="utf-8")
        for m in re.finditer(r"/\* ==== (0x[0-9A-F]{8}) .*?\*/\n", s):
            j = s.find("/* ==== 0x", m.end())
            yield m.group(1), s[m.end(): j if j > 0 else None]


def perfil(glob, g, idx, alcance, fuentes, ver_c=False):
    dat = f"DAT_{int(glob, 16):08x}"
    fns = idx["por_singleton"].get(glob.upper().replace("0X", "0x"), {}).get("funciones", [])
    metodos, campos, aloja = collections.Counter(), collections.Counter(), []
    for f in fns:
        c = fuentes.get(f, "")
        for m in re.finditer(rf"\b{dat} = (?:\(\w+\))?FUN_([0-9a-f]{{8}})\((0x[0-9a-f]+|\d+)\)", c):
            ini = re.search(rf"FUN_([0-9a-f]{{8}})\({dat}\)", c[m.end():])
            aloja.append((f, m.group(1), int(m.group(2), 0), ini.group(1) if ini else "-"))
        # tmp = FUN_00107cf8(n); ... DAT = (cast)tmp  |  DAT = FUN_ctor(tmp)
        for m in re.finditer(r"\b(\w+) = FUN_(00107cf8|00107d20)\((0x[0-9a-f]+|\d+)\);", c):
            q = re.search(rf"\b{dat} = (?:\(\w+\))?(?:FUN_([0-9a-f]{{8}})\()?{m.group(1)}\b", c[m.end(): m.end() + 300])
            if q:
                aloja.append((f, m.group(2), int(m.group(3), 0), q.group(1) or "-"))
        for m in re.finditer(rf"FUN_([0-9a-f]{{8}})\({dat}\b", c):
            metodos[f"0x{m.group(1).upper()}"] += 1
        alias = set(re.findall(rf"(\w+) = (?:\(int\))?{dat};", c))
        for m in re.finditer(r"\((\w+) \+ (0x[0-9a-f]+)\)", c):
            if m.group(1) == dat or m.group(1) in alias:
                campos[int(m.group(2), 16)] += 1
        for a in alias:
            for m in re.finditer(rf"FUN_([0-9a-f]{{8}})\({a}\b", c):
                metodos[f"0x{m.group(1).upper()}"] += 1
    print(f"== {glob}  ({len(fns)} funciones lo nombran)")
    for f, al, n, ini in aloja:
        print(f"   alojado en {f}: FUN_{al}({n:#x} = {n} B), init FUN_{ini}")
    print("   campos directos: " + (" ".join(f"+{o:#x}x{n}" for o, n in sorted(campos.items())) or "-"))
    print("   métodos (primer argumento):")
    for m, n in metodos.most_common():
        e = g.get(m, {})
        lazos = sorted(k for k, d in alcance.items() if m in d)
        otros = sorted(set(idx["por_funcion"].get(m, [])) - {glob})
        print(f"     {m} x{n}  llamada por {len(e.get('llamada_por', []))}, llama a {len(e.get('llama', []))}"
              f"  lazos: {','.join(lazos) or '-'}  toca: {' '.join(otros[:6]) or '-'}")
        if ver_c:
            print("\n".join("        " + x for x in cuerpo(m).strip().splitlines()[:60]))
    quien = sorted(set(k for f in fns for k, d in alcance.items() if f in d))
    print(f"   las funciones que lo nombran cuelgan de: {', '.join(quien) or '-'}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("globales", nargs="+")
    ap.add_argument("--c", action="store_true", help="imprime el C de cada método")
    a = ap.parse_args()
    g = json.loads((DEC / "grafo.json").read_text(encoding="utf-8"))
    idx = json.loads((DEC / "indice.json").read_text(encoding="utf-8"))
    alcance = {k: descendientes(g, v) for k, v in raices().items()}
    fuentes = dict(todo_c())
    for x in a.globales:
        perfil(f"0x{int(x, 16):08X}", g, idx, alcance, fuentes, a.c)


if __name__ == "__main__":
    main()
