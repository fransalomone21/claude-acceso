"""Fase 8c: como llega el codigo al jugador. En frio, sobre el ELF.

1. Sitios que cargan el global del contenedor 0x0040F4D0 (lui 0x41 + lw/addiu -0xB30).
2. Sitios con el inmediato 0x8C0 (el paso del array de jugadores): si el
   codigo indexa jugadores por numero, aparece aca.
3. Funciones que contienen cada sitio (por el prologo 'addiu sp,sp,-N' anterior,
   aproximado: sirve para contar funciones distintas, no para nombrarlas).

Control positivo: FUN_00382778 (el constructor del array) tiene que salir en 2.
"""
import collections
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

OFF = 0xFF000
TEXT = (0x00100000, 0x003BC380)
elf = open(ubicaciones.cargar()["rutas"]["elf_copia"]["ruta"], "rb").read()


def w(a):
    return struct.unpack_from("<I", elf, a - OFF)[0]


def funcion(a):
    for b in range(a, max(TEXT[0], a - 0x4000), -4):
        x = w(b)
        if x >> 16 == 0x27BD and x & 0x8000:  # addiu sp,sp,-N
            return b
    return None


glob, inm = [], []
for a in range(TEXT[0], TEXT[1], 4):
    x = w(a)
    op, rs, rt, imm = x >> 26, (x >> 21) & 31, (x >> 16) & 31, x & 0xFFFF
    if op in (0x23, 0x09) and imm == 0xF4D0:
        # buscar el lui 0x41 del mismo registro base en las 8 anteriores
        for b in range(a - 4, a - 36, -4):
            y = w(b)
            if y >> 26 == 0x0F and (y >> 16) & 31 == rs and y & 0xFFFF == 0x41:
                glob.append(a)
                break
    if op == 0x09 and imm == 0x08C0:
        inm.append(a)

fg = collections.Counter(funcion(a) for a in glob)
fi = collections.Counter(funcion(a) for a in inm)
print(f"cargas de 0x0040F4D0: {len(glob)} sitios en {len(fg)} funciones")
print(f"addiu con 0x8C0     : {len(inm)} sitios en {len(fi)} funciones")
for f, n in sorted(fi.items(), key=lambda t: t[0] or 0):
    print(f"   {f:#010x}  {n}" if f else f"   ?  {n}")
ctrl = any(f == 0x00382778 for f in fi)
print("control positivo (FUN_00382778 entre las de 0x8C0):", "OK" if ctrl else "FALLA")
