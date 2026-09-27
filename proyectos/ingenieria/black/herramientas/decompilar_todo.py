#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
decompilar_todo.py — E2 del plan del ELF (docs/14): TODO el ejecutable a C.

Abre el proyecto de Ghidra una vez y decompila cada función, en paralelo
(un DecompInterface por hilo; JPype suelta el GIL durante la llamada a Java).
Escribe en el repo PRIVADO, nunca en claude-acceso (es código derivado del
juego):

    $BLACK_DATOS/decompilado/0x0010.c ... 0x003B.c   un archivo por 64 KB
    $BLACK_DATOS/decompilado/indice.json              función -> singletons

El índice sale de las REFERENCIAS de Ghidra a cada global de
`censo_subsistemas.SINGLETONS`, no del texto del C. Así se puede comparar con
`censo_subsistemas.py`, que cuenta lo mismo por patrón de instrucciones: dos
caminos independientes (regla del proyecto: un número se cree cuando lo dan
dos caminos).

USO
    export BLACK_DATOS=/home/user/black-datos
    python herramientas/decompilar_todo.py              # todo (~10.000 funciones)
    python herramientas/decompilar_todo.py --solo-indice
    python herramientas/decompilar_todo.py --comparar   # contra censo_subsistemas
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import threading
import time
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import decompilar as D  # noqa: E402
from censo_subsistemas import SINGLETONS  # noqa: E402

import sys as _sys
_sys.path.insert(0, str(Path(__file__).resolve().parent))
from ubicaciones import carpeta_black_datos as _carpeta_black_datos  # noqa: E402
DATOS = _carpeta_black_datos()
SALIDA = DATOS / "decompilado"


def indice(prog) -> dict:
    """singleton -> funciones que tienen alguna referencia a su global."""
    fm = prog.getFunctionManager()
    rm = prog.getReferenceManager()
    por_global = {}
    for g, tam, nota in SINGLETONS:
        fs, sit = set(), set()
        for r in rm.getReferencesTo(D.a_dir(prog, g)):
            sit.add(f"0x{r.getFromAddress().getOffset():08X}")
            f = fm.getFunctionContaining(r.getFromAddress())
            fs.add(f"0x{f.getEntryPoint().getOffset():08X}" if f else "-")
        por_global[f"0x{g:08X}"] = {"tam": tam, "constructor": nota,
                                   "sitios": sorted(sit), "funciones": sorted(fs)}
    por_funcion = defaultdict(list)
    for g, d in por_global.items():
        for f in d["funciones"]:
            por_funcion[f].append(g)
    return {"por_singleton": por_global, "por_funcion": dict(sorted(por_funcion.items()))}


def grafo(prog) -> dict:
    """función -> {nombre, llama: [...], llamada_por: [...], datos: [...]}.
    `datos` son las referencias desde datos (vtables, tablas de handlers)."""
    fm = prog.getFunctionManager()
    rm = prog.getReferenceManager()
    g = {}
    for f in fm.getFunctions(True):
        e = f"0x{f.getEntryPoint().getOffset():08X}"
        llama = sorted({f"0x{c.getEntryPoint().getOffset():08X}" for c in f.getCalledFunctions(None)})
        por, datos = set(), set()
        for r in rm.getReferencesTo(f.getEntryPoint()):
            h = fm.getFunctionContaining(r.getFromAddress())
            if h is not None:
                por.add(f"0x{h.getEntryPoint().getOffset():08X}")
            else:
                datos.add(f"0x{r.getFromAddress().getOffset():08X}")
        g[e] = {"nombre": str(f.getName()), "llama": llama,
                "llamada_por": sorted(por), "datos": sorted(datos)}
    return g


def decompilar_todo(prog, hilos: int, segundos: int):
    from ghidra.util.task import ConsoleTaskMonitor
    fm = prog.getFunctionManager()
    funcs = [f for f in fm.getFunctions(True) if not f.isThunk() and not f.isExternal()]
    print(f"  {len(funcs)} funciones a decompilar con {hilos} hilos", flush=True)
    resultados = {}
    fallas = []
    lock = threading.Lock()
    siguiente = [0]
    t0 = time.time()

    def trabajador():
        dec = D.decompilador(prog)
        mon = ConsoleTaskMonitor()
        while True:
            with lock:
                i = siguiente[0]
                siguiente[0] += 1
            if i >= len(funcs):
                break
            f = funcs[i]
            ent = f.getEntryPoint().getOffset()
            res = dec.decompileFunction(f, segundos, mon)
            if res.decompileCompleted():
                c = str(res.getDecompiledFunction().getC()).replace("\r\n", "\n")
            else:
                c = f"// FALLO: {res.getErrorMessage()}\n"
                with lock:
                    fallas.append(ent)
            with lock:
                resultados[ent] = (str(f.getName()), c)
                if len(resultados) % 500 == 0:
                    print(f"    {len(resultados)} / {len(funcs)}  ({time.time() - t0:.0f} s)", flush=True)
        dec.dispose()

    ts = [threading.Thread(target=trabajador) for _ in range(hilos)]
    for t in ts:
        t.start()
    for t in ts:
        t.join()

    por_bloque = defaultdict(list)
    for ent in sorted(resultados):
        por_bloque[ent >> 16].append(ent)
    SALIDA.mkdir(parents=True, exist_ok=True)
    for bloque, ents in por_bloque.items():
        partes = []
        for e in ents:
            nombre, c = resultados[e]
            partes.append(f"/* ==== 0x{e:08X} {nombre} ==== */\n{c}")
        (SALIDA / f"0x{bloque:04X}.c").write_text("\n".join(partes), encoding="utf-8")
    print(f"  escritas {len(resultados)} funciones en {len(por_bloque)} archivos; "
          f"{len(fallas)} fallas; {time.time() - t0:.0f} s")
    return len(resultados), fallas


def comparar(idx: dict) -> int:
    """Control: los SITIOS de censo_subsistemas tienen que estar entre las
    referencias de Ghidra. La cuenta de funciones no sirve para comparar:
    censo busca el `lui` sólo 40 bytes atrás (es cota inferior por diseño) y
    parte funciones por el `addiu sp`, que no es el mismo corte que Ghidra."""
    import struct
    import ubicaciones
    from censo_subsistemas import OFF, sitios_por_global
    elf = open(ubicaciones.cargar()["rutas"]["elf_copia"]["ruta"], "rb").read()
    w = lambda a: struct.unpack_from("<I", elf, a - OFF)[0]  # noqa: E731
    censo = sitios_por_global(w)
    faltan_total = extra_total = cubiertos = 0
    print(f"  {'global':<12}{'censo':>7}{'ghidra':>8}{'faltan':>8}")
    for g, d in idx["por_singleton"].items():
        c = {f"0x{a:08X}" for a in censo.get(int(g, 16), [])}
        gh = set(d["sitios"])
        faltan = sorted(c - gh)
        faltan_total += len(faltan)
        cubiertos += len(c & gh)
        extra_total += len(gh - c)
        print(f"  {g:<12}{len(c):>7}{len(gh):>8}{len(faltan):>8}  {' '.join(faltan[:4])}")
    total = cubiertos + faltan_total
    print(f"  sitios de censo cubiertos por Ghidra: {cubiertos}/{total}; "
          f"Ghidra ve {extra_total} sitios más")
    ok = faltan_total <= total // 100
    print("  control E2 (censo ⊆ Ghidra, tolerancia 1 %):", "OK" if ok else "FALLA")
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--hilos", type=int, default=4)
    ap.add_argument("--segundos", type=int, default=90)
    ap.add_argument("--solo-indice", action="store_true")
    ap.add_argument("--comparar", action="store_true")
    ap.add_argument("--grafo", action="store_true", help="sólo rehacer grafo.json")
    a = ap.parse_args()
    ctx, prog = D.abrir()
    try:
        SALIDA.mkdir(parents=True, exist_ok=True)
        if not a.comparar:
            (SALIDA / "grafo.json").write_text(json.dumps(grafo(prog), indent=0), encoding="utf-8")
            print("  grafo.json escrito")
        if a.grafo:
            return 0
        idx = indice(prog)
        if not a.solo_indice and not a.comparar:
            n, fallas = decompilar_todo(prog, a.hilos, a.segundos)
            idx["funciones_decompiladas"] = n
            idx["fallas"] = [f"0x{x:08X}" for x in sorted(fallas)]
        if not a.comparar:
            (SALIDA / "indice.json").write_text(json.dumps(idx, indent=1), encoding="utf-8")
        return comparar(idx)
    finally:
        ctx.__exit__(None, None, None)


if __name__ == "__main__":
    sys.exit(main())
