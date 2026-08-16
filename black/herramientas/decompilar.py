#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
decompilar.py — hablarle a Ghidra desde Python, sin abrir la GUI.

`mips.py` y `capstone` desensamblan. Esto **decompila**: devuelve C, con
variables, control de flujo y llamadas resueltas. Es la diferencia entre leer
514 instrucciones y leer treinta líneas.

NO SE LLAMA `ghidra.py` A PROPÓSITO
    `pyghidra` importa el paquete Java `ghidra` desde Python. Un archivo
    nuestro llamado `ghidra.py` en `herramientas/` lo taparía, porque las
    herramientas se agregan a `sys.path`. Es la misma trampa que ya se pagó
    con `dis.py`.

MONTAJE (una vez por máquina)
    1. Ghidra 12.1.2:
       https://github.com/NationalSecurityAgency/ghidra/releases
       descomprimir en `~/herramientas/ghidra_12.1.2_PUBLIC`
    2. La extensión de PlayStation 2, con la versión que COINCIDA:
       https://github.com/chaoticgd/ghidra-emotionengine-reloaded/releases
       -> `ghidra_12.1.2_PUBLIC_..._ghidra-emotionengine-reloaded.zip`
       descomprimir en `<ghidra>/Ghidra/Extensions/`
       OJO: es `Ghidra/Extensions/`, NO `Extensions/Ghidra/`. La segunda
       existe, guarda los zips distribuibles, y Ghidra NO la carga. Ese error
       cuesta media hora y da un análisis que dice "succeeded" sobre basura.
    3. `pip install pyghidra`
    4. Importar y analizar, forzando el procesador:
       <ghidra>/support/analyzeHeadless.bat <proyectos> BLACK \\
           -import SLUS_213.76 -processor "r5900:LE:32:default"

EL PROCESADOR SE FUERZA, NO SE DEDUCE
    Sin `-processor`, Ghidra elige `MIPS:LE:64:64-32R6addr` — MIPS Release 6,
    otra ISA — y el análisis termina con "Analysis succeeded", UNA función en
    2,6 MB de código y cero decompilación. Verificalo siempre con
    `decompilar.py info`, que corre el control positivo.

EJEMPLOS
    python herramientas/decompilar.py info
    python herramientas/decompilar.py c 0x00142B90
    python herramientas/decompilar.py funciones --desde 0x00142000 --hasta 0x00143000
    python herramientas/decompilar.py xref 0x003BCE70
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402

GHIDRA = os.environ.get(
    "GHIDRA_INSTALL_DIR",
    str(Path.home() / "herramientas" / "ghidra_12.1.2_PUBLIC"))
PROYECTOS = os.environ.get(
    "BLACK_GHIDRA_PROYECTOS",
    str(Path.home() / "herramientas" / "ghidra-proyectos2"))
PROYECTO = os.environ.get("BLACK_GHIDRA_PROYECTO", "BLACK")
PROGRAMA = os.environ.get("BLACK_GHIDRA_PROGRAMA", "/SLUS_213.76")

# La rutina de daño por zona de impacto. Confirmada POR EFECTO en la Fase 4b:
# daño = factor_de_zona * 100.0, y la función IGNORA el $f12 que le llega.
# Si la decompilación de esto no muestra un 100.0, Ghidra está mal montado.
CONTROL = 0x00142B90


def abrir():
    """Devuelve (contexto, programa). El contexto hay que cerrarlo."""
    os.environ["GHIDRA_INSTALL_DIR"] = GHIDRA
    if not Path(GHIDRA).is_dir():
        raise SystemExit(f"no existe la instalación de Ghidra: {GHIDRA}\n"
                         "  ver el encabezado de este archivo")
    try:
        import pyghidra
    except ImportError:
        raise SystemExit("falta pyghidra: pip install pyghidra")
    pyghidra.start(verbose=False)
    proyecto = pyghidra.open_project(PROYECTOS, PROYECTO)
    ctx = pyghidra.program_context(proyecto, PROGRAMA)
    return ctx, ctx.__enter__()


def decompilador(prog):
    from ghidra.app.decompiler import DecompInterface
    d = DecompInterface()
    d.openProgram(prog)
    return d


def a_dir(prog, valor: int):
    return prog.getAddressFactory().getDefaultAddressSpace().getAddress(valor)


def decompilar_en(prog, dec, direccion: int, segundos: int = 180):
    from ghidra.util.task import ConsoleTaskMonitor
    addr = a_dir(prog, direccion)
    f = prog.getFunctionManager().getFunctionContaining(addr)
    if f is None:
        return None, None
    res = dec.decompileFunction(f, segundos, ConsoleTaskMonitor())
    if not res.decompileCompleted():
        return f, f"// FALLO: {res.getErrorMessage()}"
    # Ghidra devuelve CRLF; en Windows `print` vuelve a expandir el \n y sale
    # todo a doble espacio. Se normaliza acá, no en cada llamador.
    return f, str(res.getDecompiledFunction().getC()).replace("\r\n", "\n")


# --------------------------------------------------------------------------


def cmd_info(args) -> int:
    ctx, prog = abrir()
    try:
        fm = prog.getFunctionManager()
        n_func = fm.getFunctionCount()
        print(f"  programa   : {prog.getName()}")
        print(f"  lenguaje   : {prog.getLanguage().getLanguageID()}")
        print(f"  base       : 0x{prog.getImageBase().getOffset():08X}")
        print(f"  funciones  : {n_func}")
        print(f"  símbolos   : {prog.getSymbolTable().getNumSymbols()}")

        print("\n  bloques del ejecutable:")
        for b in prog.getMemory().getBlocks():
            nom = str(b.getName())
            if nom.startswith(".DVP") or not b.isInitialized():
                continue
            print(f"    {nom:<20} 0x{b.getStart().getOffset():08X}-"
                  f"0x{b.getEnd().getOffset():08X}")

        print(f"\n  === CONTROL POSITIVO sobre 0x{CONTROL:08X} ===")
        print("  Sabemos, por efecto en pantalla, que hace daño = zona * 100.0")
        if str(prog.getLanguage().getLanguageID()) != "r5900:LE:32:default":
            print("  [MAL] el lenguaje NO es r5900. Reimportá con -processor.")
            return 1
        if n_func <= 1:
            print("  [MAL] hay 1 función en todo el binario: no se analizó.")
            return 1
        dec = decompilador(prog)
        f, c = decompilar_en(prog, dec, CONTROL)
        if f is None:
            print("  [MAL] no hay función en esa dirección.")
            return 1
        ok = "100.0" in (c or "") or "100.00" in (c or "")
        print(f"  función    : {f.getName()} @ 0x{f.getEntryPoint().getOffset():08X}")
        print(f"  el 100.0 aparece en la decompilación: {'SI -> BIEN' if ok else 'NO -> SOSPECHAR'}")
        return 0 if ok else 1
    finally:
        ctx.__exit__(None, None, None)


def cmd_c(args) -> int:
    ctx, prog = abrir()
    try:
        dec = decompilador(prog)
        f, c = decompilar_en(prog, dec, args.direccion)
        if f is None:
            print(f"  no hay función que contenga 0x{args.direccion:08X}")
            return 1
        print(f"  // {f.getName()}  0x{f.getEntryPoint().getOffset():08X}"
              f"-0x{f.getBody().getMaxAddress().getOffset():08X}"
              f"  ({f.getBody().getNumAddresses()} bytes)")
        print(c)
        return 0
    finally:
        ctx.__exit__(None, None, None)


def cmd_funciones(args) -> int:
    ctx, prog = abrir()
    try:
        fm = prog.getFunctionManager()
        salida = []
        for f in fm.getFunctions(True):
            e = f.getEntryPoint().getOffset()
            if args.desde is not None and e < args.desde:
                continue
            if args.hasta is not None and e >= args.hasta:
                continue
            salida.append({
                "direccion": f"0x{e:08X}",
                "nombre": str(f.getName()),
                "bytes": int(f.getBody().getNumAddresses()),
            })
        print(f"  {len(salida)} funciones")
        for d in salida[:args.max]:
            print(f"    {d['direccion']}  {d['bytes']:>6}  {d['nombre']}")
        if args.json:
            Path(args.json).write_text(json.dumps(salida, indent=1), encoding="utf-8")
            print(f"  escrito: {args.json}  ({len(salida)} entradas)")
        return 0
    finally:
        ctx.__exit__(None, None, None)


def cmd_xref(args) -> int:
    ctx, prog = abrir()
    try:
        addr = a_dir(prog, args.direccion)
        fm = prog.getFunctionManager()
        refs = list(prog.getReferenceManager().getReferencesTo(addr))
        print(f"  {len(refs)} referencias a 0x{args.direccion:08X}")
        for r in refs[:args.max]:
            desde = r.getFromAddress()
            f = fm.getFunctionContaining(desde)
            print(f"    0x{desde.getOffset():08X}  {r.getReferenceType()}"
                  f"   {f.getName() if f else '-'}")
        return 0
    finally:
        ctx.__exit__(None, None, None)


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Decompilar el ELF de BLACK con Ghidra, desde Python",
        epilog=f"Ghidra: {GHIDRA}\nProyecto: {PROYECTOS}/{PROYECTO}{PROGRAMA}",
        formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--max", type=int, default=60, help="cuántos resultados listar")
    sub = p.add_subparsers(dest="cmd", required=True)

    i = sub.add_parser("info", help="estado del montaje + CONTROL POSITIVO")
    i.set_defaults(func=cmd_info)

    c = sub.add_parser("c", help="decompilar a C la función que contiene una dirección")
    c.add_argument("direccion", type=lambda s: int(s, 0))
    c.set_defaults(func=cmd_c)

    f = sub.add_parser("funciones", help="listar funciones")
    f.add_argument("--desde", type=lambda s: int(s, 0))
    f.add_argument("--hasta", type=lambda s: int(s, 0))
    f.add_argument("--json")
    f.set_defaults(func=cmd_funciones)

    x = sub.add_parser("xref", help="referencias a una dirección, con función contenedora")
    x.add_argument("direccion", type=lambda s: int(s, 0))
    x.set_defaults(func=cmd_xref)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
