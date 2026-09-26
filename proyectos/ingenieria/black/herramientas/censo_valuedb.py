"""Sondeo en frio: cuantos parametros registra la ValueDB (FUN_0027B950).

Cuenta los jal al registrador y resuelve a2 (el nombre) por lui/addiu
previos. Control positivo: los cuatro nombres de la mira
(Analogue Control Power, etc.) tienen que aparecer.
"""
import struct, collections, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

ELF = ubicaciones.cargar()["rutas"]["elf_copia"]["ruta"]
OFF = 0xFF000
elf = open(ELF, "rb").read()

def u32(a):
    return struct.unpack_from("<I", elf, a - OFF)[0]

def cstr(a):
    o = a - OFF
    if o < 0 or o >= len(elf):
        return None
    e = elf.find(b"\0", o)
    s = elf[o:e]
    if s and len(s) < 90 and all(32 <= c < 127 for c in s):
        return s.decode("ascii")
    return None

def sitios(tgt):
    enc = 0x0C000000 | (tgt >> 2)
    return [i + OFF for i in range(0, len(elf) - 4, 4)
            if struct.unpack_from("<I", elf, i)[0] == enc]

def reg_val(sitio, reg):
    hi = None
    val = None
    for a in range(sitio - 4 * 16, sitio + 8, 4):
        w = u32(a)
        op, rs, rt, imm = w >> 26, (w >> 21) & 31, (w >> 16) & 31, w & 0xFFFF
        simm = imm - 0x10000 if imm & 0x8000 else imm
        if op == 0x0F and rt == reg:
            hi = imm << 16
        elif op == 0x09 and rt == reg and rs == reg and hi is not None:
            val = (hi + simm) & 0xFFFFFFFF
    return val

tgt = int(sys.argv[1], 16) if len(sys.argv) > 1 else 0x0027B950
ss = sitios(tgt)
print(f"jal a {tgt:#010x}: {len(ss)} sitios")
res = []
for s in ss:
    n = None
    for r in (6, 5, 7, 4):
        v = reg_val(s, r)
        if v:
            n = cstr(v)
            if n:
                res.append((s, r, n))
                break
    else:
        res.append((s, None, None))
con = [x for x in res if x[2]]
print(f"con nombre resuelto: {len(con)}")
print("control positivo (mira):",
      [n for _, _, n in con if "Analogue" in n or "Hold" in n or "Catch" in n])
out = sys.argv[2] if len(sys.argv) > 2 else None
if out:
    with open(out, "w", encoding="utf-8") as f:
        for s, r, n in res:
            f.write(f"{s:#010x}\t{r}\t{n}\n")
    print("escrito:", out)
