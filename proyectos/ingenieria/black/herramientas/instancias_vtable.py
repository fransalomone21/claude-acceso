"""Que vtable contiene un metodo, y cuantos objetos vivos la usan.

Uso: python herramientas/instancias_vtable.py volcados/ee-e4.bin 0x0026C100 [campos...]

1. Busca en .data del ELF la palabra = direccion del metodo -> ranura de vtable.
   El inicio de la vtable se toma como la primera palabra anterior que no es
   un puntero a .text (aproximado; se imprime para mirarlo).
2. En el volcado, busca palabras = inicio de vtable (y, por las dudas, cada
   direccion entre inicio y la ranura): cada hallazgo es objeto+off_vptr.
3. Imprime para cada objeto los campos pedidos (offset relativo al vptr).
"""
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

OFF = 0xFF000
DATA = (0x003BC380, 0x003F2280)
TEXT = (0x00100000, 0x003BC380)


def main():
    dump = open(sys.argv[1], "rb").read()
    met = int(sys.argv[2], 16)
    campos = [int(c, 16) for c in sys.argv[3:]]
    elf = open(ubicaciones.cargar()["rutas"]["elf_copia"]["ruta"], "rb").read()
    w = lambda a: struct.unpack_from("<I", elf, a - OFF)[0]  # noqa: E731
    ranuras = [a for a in range(DATA[0], DATA[1], 4) if w(a) == met]
    print(f"metodo {met:#010x} en {len(ranuras)} ranuras de .data")
    for r in ranuras:
        # GCC 2.9x: entradas de 8 B {delta, puntero}; cabecera de 8 B. Metodo #8
        # del jugador en vtable+0x4C = 8 + 8*8 + 4 lo confirma.
        ini = r
        while TEXT[0] <= w(ini - 8) < TEXT[1]:
            ini -= 8
        ini -= 12  # cabecera + delta de la primera entrada
        print(f"  ranura {r:#010x}  -> vtable desde ~{ini:#010x} (metodo #{(r - ini - 12) // 8})")
        for cand in range(ini - 8, r + 4, 4):
            pat = struct.pack("<I", cand)
            hits, i = [], dump.find(pat)
            while i != -1:
                if i % 4 == 0 and not (DATA[0] <= i < DATA[1]):
                    hits.append(i)
                i = dump.find(pat, i + 1)
            if hits:
                print(f"    {cand:#010x} aparece {len(hits)} veces en el volcado")
                for h in hits[:12]:
                    vals = " ".join(f"+{c:#x}={struct.unpack_from('<I', dump, h + c)[0]:#x}"
                                    for c in campos if h + c + 4 <= len(dump))
                    print(f"      vptr en {h:#010x}  {vals}")


if __name__ == "__main__":
    main()
