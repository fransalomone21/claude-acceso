"""Ponerle nombre a cada subsistema de nivel 1 por las CADENAS que usa su codigo.

Uso: python herramientas/nombrar_subsistemas.py subsistemas.json salida.txt

Para cada global de censo_subsistemas.py: toma las funciones que lo cargan,
recorre su cuerpo (hasta el proximo prologo) y junta las cadenas C que
arman con lui+addiu (o lui+ori). Es una PISTA para nombrar, no una prueba:
una funcion que toca tres subsistemas presta sus cadenas a los tres.
"""
import collections
import json
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

OFF = 0xFF000
TEXT = (0x00100000, 0x003BC380)
GP = 0x004157F0
elf = open(ubicaciones.cargar()["rutas"]["elf_copia"]["ruta"], "rb").read()


def w(a):
    return struct.unpack_from("<I", elf, a - OFF)[0]


def cadena(a):
    o = a - OFF
    if not (0 <= o < len(elf)):
        return None
    e = elf.find(b"\0", o, o + 120)
    s = elf[o:e] if e != -1 else b""
    if len(s) >= 4 and all(32 <= c < 127 for c in s) and sum(c > 64 for c in s) >= 3:
        return s.decode("ascii")
    return None


def es_prologo(y):
    return y >> 16 == 0x27BD and y & 0x8000


def funciones_de(glob):
    lo, gpo = glob & 0xFFFF, (glob - GP) & 0xFFFF
    fs = set()
    for a in range(TEXT[0], TEXT[1], 4):
        x = w(a)
        op, rs, imm = x >> 26, (x >> 21) & 31, x & 0xFFFF
        if op not in (0x23, 0x2B, 0x09):
            continue
        ok = (rs == 28 and imm == gpo) or (imm == lo and any(
            w(b) >> 26 == 0x0F and (w(b) >> 16) & 31 == rs and w(b) & 0xFFFF == 0x41
            for b in range(a - 4, a - 40, -4)))
        if ok:
            b = a
            while b > TEXT[0] and not es_prologo(w(b)):
                b -= 4
            fs.add(b)
    return fs


def cadenas_de(f):
    hi = {}
    out = []
    a = f + 4
    while a < TEXT[1] and not es_prologo(w(a)) and a < f + 0x3000:
        x = w(a)
        op, rs, rt, imm = x >> 26, (x >> 21) & 31, (x >> 16) & 31, x & 0xFFFF
        if op == 0x0F:
            hi[rt] = imm << 16
        elif op in (0x09, 0x0D) and rs in hi:
            v = (hi[rs] + ((imm - 0x10000) if (op == 0x09 and imm & 0x8000) else imm)) & 0xFFFFFFFF
            s = cadena(v)
            if s:
                out.append(s)
        a += 4
    return out


def main():
    filas = json.load(open(sys.argv[1], encoding="utf-8"))
    with open(sys.argv[2], "w", encoding="utf-8") as fo:
        for f in filas:
            g = int(f["global"], 16)
            cs = collections.Counter()
            for fn in funciones_de(g):
                cs.update(set(cadenas_de(fn)))
            fo.write(f"== {f['global']}  {f['tam']} B  {f['funciones']} funciones\n")
            for s, n in cs.most_common(14):
                fo.write(f"   {n:>3}  {s[:90]}\n")
    print("listo:", sys.argv[2])


if __name__ == "__main__":
    main()
