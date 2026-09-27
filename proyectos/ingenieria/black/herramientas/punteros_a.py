"""Quien guarda un puntero a una direccion: barre un volcado de 32 MB.

Uso: python herramientas/punteros_a.py volcados/ee-e4.bin 0x005A8A80 0x005A8AB0

Clasifica cada hallazgo por region del ELF (.data/.sdata/.bss = global
estatico; resto = heap). Para la fase 8c: si el jugador se alcanza por UN
global, un segundo jugador es otro puntero; si se alcanza por base fija
compilada en el codigo, es parchear cada sitio.
"""
import struct
import sys

REGIONES = [
    (0x003BC380, 0x003F2280, ".data"),
    (0x003F2280, 0x0040D800, ".rodata"),
    (0x0040D980, 0x0040EC80, ".sdata"),
    (0x0040EC80, 0x0049BFBC, ".bss"),
]


def region(a):
    for i, f, n in REGIONES:
        if i <= a < f:
            return n
    return "heap"


def main():
    ram = open(sys.argv[1], "rb").read()
    for obj in (int(x, 16) for x in sys.argv[2:]):
        pat = struct.pack("<I", obj)
        hits = []
        i = ram.find(pat)
        while i != -1:
            if i % 4 == 0:
                hits.append(i)
            i = ram.find(pat, i + 1)
        print(f"{obj:#010x}: {len(hits)} punteros")
        for h in hits[:40]:
            print(f"   {h:#010x}  {region(h)}")


if __name__ == "__main__":
    main()
