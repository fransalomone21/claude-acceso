"""Parte un ISO de PS2 en el formato USBExtreme (ul.cfg) que lee OPL desde USB.

Sirve para ISOs de mas de 4 GiB en un pendrive FAT32.
Uso: python iso_a_ul.py <iso> <raiz_del_usb> <ID tipo SLUS_219.78> "<nombre, max 32>" [--dvd|--cd] [--probar]

Formato (USBUtil / OPL supportbase):
  ul.cfg: registros de 64 bytes
    0x00 32  nombre
    0x20 15  "ul." + ID (11) + \0
    0x2F 1   cantidad de partes
    0x30 1   medio: 0x14 DVD, 0x12 CD
    0x31 4   0
    0x35 1   0x08
    0x36 10  0
  partes: ul.<CRC32 del nombre, hex mayusc>.<ID>.<00..>, 1 GiB cada una.
  El CRC es el de USBUtil (USBA_crc32 en OPL), no el de zlib.
"""
import os, sys, struct

PARTE = 1 << 30


def usba_crc32(nombre: str) -> int:
    """Reproduce USBA_crc32 de OPL con aritmetica de int de 32 bits con signo."""
    def s32(x):
        x &= 0xFFFFFFFF
        return x - (1 << 32) if x & 0x80000000 else x

    tabla = [0] * 256
    crc = 0
    for t in range(256):
        crc = s32(t << 24)
        for _ in range(8):
            if crc < 0:
                crc = s32(crc << 1)
            else:
                crc = s32((crc << 1) ^ 0x04C11DB7)
        tabla[255 - t] = crc
    datos = nombre.encode('ascii') + b'\0'
    for b in datos:
        crc = s32(tabla[b ^ ((crc >> 24) & 0xFF)] ^ ((crc << 8) & 0xFFFFFF00))
    return crc & 0xFFFFFFFF


def registro(nombre, gid, partes, medio):
    r = bytearray(64)
    n = nombre.encode('ascii')[:32]
    r[0:len(n)] = n
    img = ('ul.' + gid).encode('ascii')
    r[0x20:0x20 + len(img)] = img
    r[0x2F] = partes
    r[0x30] = medio
    r[0x35] = 0x08
    return bytes(r)


def main():
    a = sys.argv[1:]
    probar = '--probar' in a
    medio = 0x12 if '--cd' in a else 0x14
    a = [x for x in a if not x.startswith('--')]
    iso, raiz, gid, nombre = a
    assert len(gid) == 11, 'el ID va como SLUS_219.78'
    assert len(nombre.encode('ascii')) <= 32
    tam = os.path.getsize(iso)
    partes = (tam + PARTE - 1) // PARTE
    crc = usba_crc32(nombre)
    base = f'ul.{crc:08X}.{gid}'
    print(f'{nombre}: {tam} bytes, {partes} partes, {base}.NN')
    if probar:
        return
    cfg = os.path.join(raiz, 'ul.cfg')
    viejo = open(cfg, 'rb').read() if os.path.exists(cfg) else b''
    for i in range(0, len(viejo), 64):
        if viejo[i + 0x23:i + 0x2E] == gid.encode():
            sys.exit(f'{gid} ya esta en ul.cfg')
    with open(iso, 'rb') as src:
        for p in range(partes):
            dst = os.path.join(raiz, f'{base}.{p:02d}')
            with open(dst, 'wb') as out:
                restante = PARTE
                while restante:
                    buf = src.read(min(restante, 8 << 20))
                    if not buf:
                        break
                    out.write(buf); restante -= len(buf)
            print('  ', os.path.basename(dst), os.path.getsize(dst))
    with open(cfg, 'ab') as f:
        f.write(registro(nombre, gid, partes, medio))
    print('ul.cfg OK')


if __name__ == '__main__':
    main()
