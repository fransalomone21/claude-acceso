#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
valuedb_aku.py — los VALORES de la ValueDB, en frío (bitácora (73)).

La ValueDB registra variables con nombre (`FUN_0027B950/780/880`: destino,
nombre, grupo, ruta del .cfg) pero el registrador guarda el destino, no el
número. El número sale de `Data/Andy.aku`, que la carga (estado 9 de
`FUN_00102930`) lee en el búfer del singleton `0x0040F54C` (12 KB) y enchufa
en la ranura 0 del registro (`sesión+4`, `FUN_0027c128` → `FUN_0027be98`).

Formato de ANDY.AKU (leído de `FUN_0027be98` y medido en los 3 volcados):
    +0x00 u32  2
    +0x04 u32  n = 0x52A (1322 valores)
    +0x0C u32  21 (archivos .cfg)
    +0x10 u32  desplazamiento de la tabla de archivos (0x2970)
    +0x14      n pares (f32 valor, u32 clave), ordenados por clave con signo
    +0x2970    21 pares (u32 1, u32 CRC de la ruta del .cfg)

La clave es `FUN_0027c278(nombre + grupo + "/" + ruta)` (armado en
`FUN_0027ba68`): un CRC-32 de tabla (`0x003C09F0`), valor inicial 0xFFFFFFFF,
SIN xor final y con corrimiento ARITMÉTICO (`(int)crc >> 8`).

    python herramientas/valuedb_aku.py            # los valores con nombre
    python herramientas/valuedb_aku.py --crudo    # también los sin nombre

Control positivo: las rutas de los .cfg del ELF tienen que caer en la tabla de
21, y los nombres registrados tienen que caer en la de 1322.
"""
import argparse
import glob
import itertools
import os
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from nombrar_por_decompilado import texto_en  # noqa: E402
from perfil_singleton import palabra_elf  # noqa: E402

BD = Path(os.environ.get("BLACK_DATOS", "/home/user/black-datos"))
BUF = 0x0040F54C
TABLA = [None]


def crc(s: str) -> int:
    if TABLA[0] is None:
        TABLA[0] = [palabra_elf(0x003C09F0 + 4 * i) for i in range(256)]
    t, c = TABLA[0], 0xFFFFFFFF
    for ch in s.encode("latin-1"):
        c = (((c - (1 << 32) if c & 0x80000000 else c) >> 8) ^ t[(ch ^ c) & 0xFF]) & 0xFFFFFFFF
    return c


def leer_aku(volcado: Path):
    m = volcado.read_bytes()
    p = struct.unpack_from("<I", m, BUF)[0] & 0x1FFFFFF
    _, n, _, nf, off = struct.unpack_from("<5I", m, p)
    pares = [struct.unpack_from("<fI", m, p + 0x14 + 8 * i) for i in range(n)]
    archivos = [struct.unpack_from("<II", m, p + off + 8 * i)[1] for i in range(nf)]
    return p, pares, archivos


def registros():
    """(nombre, grupo, ruta) de cada llamada a los registradores, del decompilado."""
    out = []
    for fn in sorted(glob.glob(str(BD / "decompilado" / "*.c"))):
        for mm in re.finditer(r"FUN_0027b(?:950|780|880)\(([^;]*?)\);", open(fn).read(), re.S):
            s = [texto_en(int(a, 16)) for a in re.findall(r"\b0x[34][0-9a-f]{5}\b", mm.group(1))]
            out.append([x for x in s if x and len(x) > 2])
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--volcado", default=str(BD / "ee-e4.bin"))
    ap.add_argument("--crudo", action="store_true")
    a = ap.parse_args()
    p, pares, archivos = leer_aku(Path(a.volcado))
    claves = {k: v for v, k in pares}
    elf = (BD / "SLUS_213.76").read_bytes()
    cfgs = sorted({x.decode() for x in re.findall(rb"[ -~]{4,90}\.(?:cfg|CFG)", elf)})
    ok_cfg = [c for c in cfgs if crc(c) in archivos]
    print(f"ANDY.AKU en 0x{p:08X}: {len(pares)} valores, {len(archivos)} archivos .cfg")
    print(f"control positivo, rutas .cfg del ELF en la tabla de archivos: {len(ok_cfg)} de {len(cfgs)}")
    for c in cfgs:
        print(f"   {'SI' if c in ok_cfg else '--'} {c}")
    nombrados = {}
    for r in registros():
        # la ruta no siempre queda como literal en la llamada: se prueban las 8 del ELF
        for n, g in itertools.permutations([x for x in r if not x.lower().endswith(".cfg")], 2):
            for c in cfgs:
                s = n + g
                k = crc(s + ("" if s.endswith("/") else "/") + c)
                if k in claves:
                    nombrados[k] = (c.split("/")[-1], g, n)
    print(f"control positivo, variables registradas con valor: {len(nombrados)}")
    for k, (c, g, n) in sorted(nombrados.items(), key=lambda x: x[1]):
        print(f"   {c:16} {g:18} {n:40} = {claves[k]:g}")
    if a.crudo:
        for v, k in pares:
            if k not in nombrados:
                print(f"   0x{k:08X} = {v:g}")
    return 0 if ok_cfg and nombrados else 1


if __name__ == "__main__":
    sys.exit(main())
