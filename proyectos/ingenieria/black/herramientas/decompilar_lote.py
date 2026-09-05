#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""L2 — la cadena del cargador de Unit_NN.bin, en UNA sola apertura de Ghidra.

Uso:  python _l2_cargador.py <salida.txt> 0x0012E728 0x0012E8B8 ...

Escribe a un archivo porque la consola de Windows come acentos.
"""
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent
sys.path.insert(0, str(AQUI))
import decompilar as D  # noqa: E402

SALIDA = Path(sys.argv[1])
DIRS = [int(a, 16) for a in sys.argv[2:]]


def main():
    ctx, prog = D.abrir()
    out = []
    w = out.append
    try:
        dec = D.decompilador(prog)
        fm = prog.getFunctionManager()
        rm = prog.getReferenceManager()

        for addr in DIRS:
            w("=" * 74)
            w(f"0x{addr:08X}")
            w("=" * 74)
            f, c = D.decompilar_en(prog, dec, addr)
            if f is None:
                w("  (SIN FUNCION contenedora -- no hay codigo definido ahi)")
                w("")
                continue
            ent = f.getEntryPoint().getOffset()
            w(f"FUNCION {f.getName()}  entry=0x{ent:08X}  "
              f"cuerpo={f.getBody().getNumAddresses()} bytes")
            w("")
            w(c)
            w("")
            refs = list(rm.getReferencesTo(f.getEntryPoint()))
            w(f"--- REFERENCIAS a {f.getName()} ({len(refs)}) ---")
            for r in refs:
                d0 = r.getFromAddress()
                g = fm.getFunctionContaining(d0)
                nom = g.getName() if g else "-"
                e = f"0x{g.getEntryPoint().getOffset():08X}" if g else "-"
                w(f"    0x{d0.getOffset():08X}  {r.getReferenceType()}  {nom} {e}")
            w("")
            w(f"--- LLAMA A ---")
            for cf in f.getCalledFunctions(None):
                w(f"    {cf.getName()}  entry=0x{cf.getEntryPoint().getOffset():08X}")
            w("")
    finally:
        ctx.__exit__(None, None, None)
        SALIDA.write_text("\n".join(out), encoding="utf-8")
        print(f"escrito: {SALIDA}  ({len(out)} lineas)")


if __name__ == "__main__":
    main()
