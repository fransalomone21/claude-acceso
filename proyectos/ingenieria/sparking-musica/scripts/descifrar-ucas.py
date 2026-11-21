"""Copia un contenedor IoStore de un mod (.utoc/.ucas) con los bloques DESCIFRADOS y la marca de cifrado sacada, para
que retoc lo pueda leer (retoc se cae con los .utoc viejos cifrados: el indice de directorios no esta alineado a 16).
No toca el original. uso: python descifrar-ucas.py <entrada.utoc> <salida_sin_extension>"""
import struct, sys
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

KEY = bytes.fromhex("b2407c45ea7c528738a94c0a25ea8f419de4377628eb30c0ae6a80dd9a9f3ef0")
src, dst = sys.argv[1], sys.argv[2]
t = bytearray(open(src, "rb").read())
u = bytearray(open(src[:-5] + ".ucas", "rb").read())
n = lambda o: struct.unpack_from("<I", t, o)[0]
hdr, entries, blocks = n(0x14), n(0x18), n(0x1C)
assert t[0x50] & 2, "no esta cifrado"
# tabla: ChunkIds (12 B) y OffsetAndLengths (10 B) por entrada, (hash map si version >= PerfectHash), despues bloques
version = t[16]
o = hdr + entries * 12 + entries * 10
if version >= 4:  # PerfectHash: seeds (4 B x seeds) + overflow
    seeds = n(0x54)
    o += seeds * 4
    if version >= 5:
        o += n(0x58) * 4
dec = Cipher(algorithms.AES(KEY), modes.ECB()).decryptor()
hechos = 0
for i in range(blocks):
    e = t[o + i * 12: o + i * 12 + 12]
    off = int.from_bytes(e[0:5], "little")
    csz = int.from_bytes(e[5:8], "little")
    al = (csz + 15) & ~15
    u[off:off + al] = Cipher(algorithms.AES(KEY), modes.ECB()).decryptor().update(bytes(u[off:off + al]))
    hechos += 1
t[0x50] &= ~2
open(dst + ".utoc", "wb").write(t)
open(dst + ".ucas", "wb").write(u)
print(f"version {version}, {entries} entradas, {hechos} bloques descifrados -> {dst}.utoc/.ucas")
