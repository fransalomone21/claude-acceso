#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
completar_funciones.py — el código que el análisis automático de Ghidra no ve.

POR QUÉ (bitácora (67))
    Después del análisis, el 95,2 % del `.text` estaba dentro de funciones y
    quedaban 304 huecos de 64 B o más (89 KB) con 170 prólogos
    `addiu sp,sp,-X` adentro. Se detectó porque `censo_subsistemas.py` encontraba
    sitios que cargan un singleton en direcciones donde Ghidra NO TENÍA
    instrucción. Es código que sólo se llama por puntero (vtables, tablas de
    handlers), y el decompilado masivo (E2) lo estaba salteando entero.

QUÉ HACE
    Candidatas a entrada de función, siempre dentro de un hueco (ninguna
    función la contiene):
      a) palabras de las secciones de datos que apuntan al `.text` (vtables);
      b) prólogos `addiu sp,sp,-X`.
    Filtro para no partir funciones (los casos de un switch no resuelto
    también se apuntan desde datos): la palabra anterior tiene que ser el
    cierre de otra función — el delay slot de un `jr ra` o relleno `nop`.
    Crea las funciones, re-analiza, guarda, y repite hasta que no aparezca
    ninguna nueva.

USO
    python herramientas/completar_funciones.py --medir     # sólo cobertura
    python herramientas/completar_funciones.py             # crea y guarda
Después: `decompilar.py info` (control positivo) y `decompilar_todo.py`.
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import decompilar as D  # noqa: E402

TEXT = (0x00100000, 0x00396F48)
DATOS = [(".data", 0x003BC380, 0x003F215C), (".rodata", 0x003F2280, 0x0040C7A8),
         (".sdata", 0x0040D980, 0x0040E580)]
JR_RA = 0x03E00008


def u32(prog, a: int) -> int:
    return prog.getMemory().getInt(D.a_dir(prog, a)) & 0xFFFFFFFF


def cobertura(prog):
    fm = prog.getFunctionManager()
    dentro = 0
    huecos, cur = [], None
    for a in range(*TEXT, 4):
        if fm.getFunctionContaining(D.a_dir(prog, a)):
            dentro += 1
            if cur:
                huecos.append(tuple(cur))
                cur = None
        else:
            cur = [cur[0] if cur else a, a]
    if cur:
        huecos.append(tuple(cur))
    return dentro, (TEXT[1] - TEXT[0]) // 4, huecos


def cierra_funcion(prog, t: int) -> bool:
    """¿La palabra anterior a t es el final de otra función?"""
    if t - 8 < TEXT[0]:
        return False
    antes = u32(prog, t - 4)
    return antes == 0 or u32(prog, t - 8) == JR_RA


def candidatas(prog, huecos):
    en_hueco = set()
    for a, b in huecos:
        en_hueco.update(range(a, b + 4, 4))
    c = {}
    for nom, a0, a1 in DATOS:
        for a in range(a0, a1, 4):
            v = u32(prog, a)
            if v in en_hueco and cierra_funcion(prog, v) and u32(prog, v) != 0:
                c.setdefault(v, f"puntero en {nom} 0x{a:08X}")
    for t in sorted(en_hueco):
        w = u32(prog, t)
        if w >> 16 == 0x27BD and w & 0x8000 and cierra_funcion(prog, t):
            c.setdefault(t, "prólogo addiu sp")
    return c


def crear(prog, c: dict) -> int:
    import pyghidra
    from ghidra.app.cmd.disassemble import DisassembleCommand
    from ghidra.app.cmd.function import CreateFunctionCmd
    from ghidra.util.task import ConsoleTaskMonitor
    mon = ConsoleTaskMonitor()
    fm = prog.getFunctionManager()
    hechas = 0
    with pyghidra.transaction(prog, "completar_funciones"):
        for t in sorted(c):
            ad = D.a_dir(prog, t)
            if fm.getFunctionContaining(ad):
                continue
            DisassembleCommand(ad, None, True).applyTo(prog, mon)
            if CreateFunctionCmd(ad).applyTo(prog, mon):
                hechas += 1
    return hechas


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--medir", action="store_true")
    ap.add_argument("--rondas", type=int, default=4)
    a = ap.parse_args()
    ctx, prog = D.abrir()          # arranca la JVM: recién ahí existe `ghidra`
    import pyghidra
    from ghidra.util.task import ConsoleTaskMonitor
    try:
        for ronda in range(a.rondas):
            dentro, tot, huecos = cobertura(prog)
            n_f = prog.getFunctionManager().getFunctionCount()
            print(f"  ronda {ronda}: {n_f} funciones; .text en funciones {100 * dentro / tot:.2f} %; "
                  f"huecos >= 64 B: {sum(1 for x, y in huecos if y - x + 4 >= 64)}", flush=True)
            if a.medir:
                break
            c = candidatas(prog, huecos)
            por_tipo = {}
            for v in c.values():
                k = v.split(" 0x")[0]
                por_tipo[k] = por_tipo.get(k, 0) + 1
            print(f"    candidatas: {len(c)} {por_tipo}", flush=True)
            h = crear(prog, c)
            print(f"    funciones creadas: {h}; re-analizando...", flush=True)
            if h == 0:
                break
            pyghidra.analyze(prog)
        if not a.medir:
            prog.save("completar_funciones", ConsoleTaskMonitor())
            print("  guardado")
    finally:
        ctx.__exit__(None, None, None)


if __name__ == "__main__":
    main()
