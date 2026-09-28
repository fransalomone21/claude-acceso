#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
lectores_global.py — todos los accesos del ELF a un global, por opcodes crudos.

PARA QUÉ
    Antes de cambiar un puntero global "sólo un rato" (el truco del envoltorio:
    poner *(GLOBAL) = copia alrededor de una llamada y restaurarlo después) hay
    que saber QUIÉNES lo leen y CUÁNDO. Si alguien lo lee por cuadro y deriva de
    él una dirección que tiene que seguir siendo válida, el truco no alcanza.

    El decompilado de Ghidra NO es una fuente suficiente para eso: escribe
    `DAT_0040f50c` donde reconoció el patrón, y ya se comió uno en este
    proyecto (`0x001ABFB8`, que en el C sale como un parámetro). Esto lee las
    INSTRUCCIONES.

CÓMO
    Un acceso a 0xAAAABBBB por `lui`+`lw` tiene siempre el mismo desplazamiento
    de 16 bits. Así que:
      1. cota superior: toda instrucción de memoria (o `addiu`) con ese
         desplazamiento exacto — no se puede escapar ninguna;
      2. para cada candidata, se busca hacia atrás quién definió su registro
         base, siguiendo los `move`; si no sale de `lui <alto>`, se descarta.
    Las dos mitades juntas dan una lista COMPLETA y sin falsos positivos, y el
    descarte se imprime para que se pueda auditar.

CLI
    python herramientas/lectores_global.py 0x0040F50C
    python herramientas/lectores_global.py 0x0040F50C --json salida.json
    python herramientas/lectores_global.py 0x0040F50C --cuadro 0x00129360
        # además marca qué accesores alcanza esa raíz en el grafo de llamadas

CÓDIGO DE SALIDA
    0 siempre (es un informe). El que mide es `prueba_herramientas.py`.
"""
from __future__ import annotations

import argparse
import bisect
import json
import struct
import sys
from collections import deque
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from ubicaciones import carpeta_black_datos  # noqa: E402

OFF_ARCHIVO = 0xFF000  # vaddr - offset, un solo PT_LOAD (ver desensamblar.py)

REG = ["zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
       "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
       "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
       "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra"]

# opcode principal -> (mnemónico, 0 = lee, 1 = escribe, 2 = toma la dirección)
MEM = {
    0x1E: ("lq", 0), 0x1F: ("sq", 1), 0x20: ("lb", 0), 0x21: ("lh", 0),
    0x22: ("lwl", 0), 0x23: ("lw", 0), 0x24: ("lbu", 0), 0x25: ("lhu", 0),
    0x26: ("lwr", 0), 0x27: ("lwu", 0), 0x28: ("sb", 1), 0x29: ("sh", 1),
    0x2A: ("swl", 1), 0x2B: ("sw", 1), 0x2E: ("swr", 1), 0x37: ("ld", 0),
    0x3F: ("sd", 1), 0x31: ("lwc1", 0), 0x39: ("swc1", 1),
    # (109) en el R5900 lqc2 es 0x36 (capstone lo muestra como `bbit032`); hasta (108) decía 0x33,
    # que es `pref`, y así no se veía ninguna lectura vectorial (p. ej. la posición J+0xA0 por lqc2)
    0x36: ("lqc2", 0), 0x3E: ("sqc2", 1), 0x09: ("addiu", 2),
}
# opcodes tipo-I cuyo destino es rt (para detectar que el base se redefinió);
# lqc2 no va: su rt es un registro del VU0, no uno entero
DEST_RT = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x18, 0x19, 0x1A,
           0x1B, 0x1E, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x37}


def s16(x: int) -> int:
    return x - 0x10000 if x & 0x8000 else x


class Elf:
    def __init__(self, ruta):
        ruta = Path(ruta)
        self.d = ruta.read_bytes()
        if self.d[:4] != b"\x7fELF":
            raise SystemExit(f"{ruta} no es un ELF")
        e_phoff, = struct.unpack_from("<I", self.d, 0x1C)
        e_phentsize, e_phnum = struct.unpack_from("<HH", self.d, 0x2A)
        self.cargas = []
        for i in range(e_phnum):
            o = e_phoff + i * e_phentsize
            tipo, off, vaddr, _pa, filesz, _ms, _fl, _al = struct.unpack_from("<8I", self.d, o)
            if tipo == 1 and filesz:
                self.cargas.append((vaddr, vaddr + filesz, off))

    def palabra(self, a: int) -> int:
        for lo, hi, off in self.cargas:
            if lo <= a < hi - 3:
                return struct.unpack_from("<I", self.d, off + a - lo)[0]
        raise KeyError(hex(a))

    def rango(self):
        lo = min(c[0] for c in self.cargas)
        hi = max(c[1] for c in self.cargas)
        return lo & ~3, hi & ~3


def cargar_grafo():
    p = carpeta_black_datos() / "decompilado" / "grafo.json"
    g = json.loads(p.read_text(encoding="utf-8"))
    return g, sorted(int(k, 16) for k in g)


def accesos(elf: Elf, objetivo: int, ents: list[int]):
    """(confirmados, descartados) — ver el docstring: cota superior + base."""
    alto, bajo = objetivo >> 16, objetivo & 0xFFFF
    if bajo & 0x8000:
        alto += 1
    desp = s16(bajo)
    lo, hi = elf.rango()

    def func_de(a):
        i = bisect.bisect_right(ents, a) - 1
        return f"0x{ents[i]:08X}" if i >= 0 else "?"

    def ini_de(a):
        i = bisect.bisect_right(ents, a) - 1
        return ents[i] if i >= 0 else lo

    candidatas = []
    a = lo
    while a + 4 <= hi:
        try:
            i = elf.palabra(a)
        except KeyError:
            a += 4
            continue
        if (i >> 26) in MEM and s16(i & 0xFFFF) == desp:
            candidatas.append(a)
        a += 4

    conf, desc = [], []
    for c in candidatas:
        i = elf.palabra(c)
        op, rs, rt = i >> 26, (i >> 21) & 31, (i >> 16) & 31
        buscado, b, tope, fuente = rs, c - 4, ini_de(c), None
        while b >= tope:
            j = elf.palabra(b)
            jop, jrd, jrt, jrs = j >> 26, (j >> 11) & 31, (j >> 16) & 31, (j >> 21) & 31
            if jop == 0x0F and jrt == buscado:            # lui <buscado>, alto
                fuente = (b, j & 0xFFFF)
                break
            # `move rd, rs` = addu/or rd, rs, zero: seguir la copia
            if jop == 0x00 and jrd == buscado and (j & 0x3F) in (0x21, 0x25, 0x2D) \
               and ((j >> 16) & 31) == 0:
                buscado = jrs
                b -= 4
                continue
            if (jop == 0x00 and jrd == buscado) or (jop in DEST_RT and jrt == buscado):
                fuente = (b, None)
                break
            b -= 4
        m, tipo = MEM[op]
        if fuente and fuente[1] == alto:
            conf.append(dict(dir=c, tipo=tipo, ins=m, rt=REG[rt], base=REG[rs],
                             lui=fuente[0], fn=func_de(c)))
        else:
            desc.append(dict(dir=c, ins=m, base=REG[rs],
                             fuente=(f"0x{fuente[0]:08X}" if fuente else None)))
    return conf, desc


def alcanzables(g, raices):
    vis, dist, q = set(), {}, deque()
    for r in raices:
        k = "0x%08X" % int(r, 16)
        if k in g:
            vis.add(k); dist[k] = 0; q.append(k)
    while q:
        f = q.popleft()
        for h in g[f].get("llama", []):
            k = "0x%08X" % int(h, 16)
            if k in g and k not in vis:
                vis.add(k); dist[k] = dist[f] + 1; q.append(k)
    return dist


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    ap.add_argument("global_", metavar="GLOBAL", help="dirección, p. ej. 0x0040F50C")
    ap.add_argument("--cuadro", action="append", default=[],
                    help="raíz por cuadro; marca qué accesores alcanza (repetible)")
    ap.add_argument("--json", help="escribir el informe a un archivo")
    a = ap.parse_args(argv)

    objetivo = int(a.global_, 16)
    g, ents = cargar_grafo()
    elf = Elf(carpeta_black_datos() / "SLUS_213.76")
    conf, desc = accesos(elf, objetivo, ents)

    dist = alcanzables(g, a.cuadro) if a.cuadro else {}
    porfn = {}
    for h in conf:
        porfn.setdefault(h["fn"], []).append(h)
    escrituras = [h for h in conf if h["tipo"] == 1]

    print(f"=== {objetivo:#010x}: {len(conf)} accesos en {len(porfn)} funciones "
          f"({len(desc)} candidatas descartadas) ===")
    print("ESCRITURAS del puntero: " +
          (", ".join(f"{h['dir']:#010x} en {h['fn']}" for h in escrituras) or "ninguna"))
    for fn in sorted(porfn):
        marca = f"  [por cuadro, d{dist[fn]}]" if fn in dist else ""
        print(f"\n{fn}  ({len(porfn[fn])}){marca}")
        for h in porfn[fn]:
            t = {0: "lee", 1: "ESCRIBE", 2: "direccion"}[h["tipo"]]
            print(f"   {h['dir']:#010x}  {t:9s} {h['ins']:5s} {h['rt']:4s} <- ({h['base']})"
                  f"   [lui @ {h['lui']:#010x}]")
    for d in desc:
        print(f"\ndescartada: {d['dir']:#010x} {d['ins']} (${d['base']}) "
              f"definido en {d['fuente']}, no por lui")
    if a.json:
        Path(a.json).write_text(json.dumps(
            dict(objetivo=objetivo, accesos=conf, descartados=desc,
                 por_cuadro={k: v for k, v in dist.items() if k in porfn}),
            indent=1), encoding="utf-8")
        print(f"\n-> {a.json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
