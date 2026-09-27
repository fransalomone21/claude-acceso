#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
traer_nix.py — instalar un paquete del caché binario de Nix SIN tener Nix.

POR QUÉ EXISTE
    En la nube, el proxy sólo deja `git clone` de GitHub: los *releases* (los
    .zip de Ghidra y de la extensión del EE) dan 403. `cache.nixos.org` sí
    responde, y nixpkgs compila `ghidra-bin` 12.1.2 — la misma versión que
    espera `decompilar.py`. Esto baja el paquete y TODA su clausura
    (glibc, libstdc++, el JDK) a `/nix/store/`, que es donde sus binarios
    esperan encontrarla, así que el decompilador nativo corre sin parchear.

VERIFICA
    Cada NAR se compara contra el `NarHash` firmado del narinfo (sha256 en la
    base32 de Nix). Si no coincide, se borra lo extraído y se corta.

USO
    python3 traer_nix.py hmccjb8iyf8qbdn8x8gvk2cl3zc1awgc      # ghidra-bin 12.1.2
    La ruta se saca de Hydra:
    https://hydra.nixos.org/job/nixpkgs/unstable/ghidra-bin.x86_64-linux/latest
"""
from __future__ import annotations

import hashlib
import os
import shutil
import stat
import sys
import urllib.request

import zstandard  # pip install zstandard

CACHE = "https://cache.nixos.org"
TIENDA = "/nix/store"
ALFA = "0123456789abcdfghijklmnpqrsvwxyz"


def nix32(h: bytes) -> str:
    n = (len(h) * 8 - 1) // 5 + 1
    out = []
    for i in range(n - 1, -1, -1):
        b = i * 5
        j, k = divmod(b, 8)
        c = h[j] >> k
        if j + 1 < len(h):
            c |= h[j + 1] << (8 - k)
        out.append(ALFA[c & 0x1F])
    return "".join(out)


def narinfo(hash_: str) -> dict:
    with urllib.request.urlopen(f"{CACHE}/{hash_}.narinfo", timeout=60) as r:
        txt = r.read().decode()
    d = {}
    for linea in txt.splitlines():
        if ": " in linea:
            k, v = linea.split(": ", 1)
            d[k] = v
    return d


class Lector:
    """Lee el NAR descomprimido y va acumulando el sha256."""

    def __init__(self, f):
        self.f, self.h = f, hashlib.sha256()

    def exacto(self, n: int) -> bytes:
        partes, falta = [], n
        while falta:
            b = self.f.read(min(falta, 1 << 20))
            if not b:
                raise EOFError("NAR truncado")
            partes.append(b)
            falta -= len(b)
        b = b"".join(partes)
        self.h.update(b)
        return b

    def entero(self) -> int:
        return int.from_bytes(self.exacto(8), "little")

    def cadena(self) -> bytes:
        n = self.entero()
        s = self.exacto(n)
        self.exacto((8 - n % 8) % 8)
        return s

    def a_archivo(self, ruta: str, ejecutable: bool):
        n = self.entero()
        with open(ruta, "wb") as out:
            falta = n
            while falta:
                b = self.f.read(min(falta, 1 << 20))
                if not b:
                    raise EOFError("NAR truncado")
                self.h.update(b)
                out.write(b)
                falta -= len(b)
        self.exacto((8 - n % 8) % 8)
        os.chmod(ruta, 0o555 if ejecutable else 0o444)

    def esperar(self, s: bytes):
        got = self.cadena()
        if got != s:
            raise ValueError(f"NAR mal formado: esperaba {s!r}, vino {got!r}")


def nodo(L: Lector, ruta: str):
    L.esperar(b"(")
    L.esperar(b"type")
    t = L.cadena()
    if t == b"regular":
        tag = L.cadena()
        ejec = False
        if tag == b"executable":
            L.esperar(b"")
            ejec = True
            tag = L.cadena()
        if tag != b"contents":
            raise ValueError(f"esperaba contents, vino {tag!r}")
        L.a_archivo(ruta, ejec)
        L.esperar(b")")
    elif t == b"symlink":
        L.esperar(b"target")
        os.symlink(L.cadena().decode(), ruta)
        L.esperar(b")")
    elif t == b"directory":
        os.mkdir(ruta)
        while True:
            tag = L.cadena()
            if tag == b")":
                break
            if tag != b"entry":
                raise ValueError(f"esperaba entry, vino {tag!r}")
            L.esperar(b"(")
            L.esperar(b"name")
            nombre = L.cadena().decode()
            L.esperar(b"node")
            nodo(L, os.path.join(ruta, nombre))
            L.esperar(b")")
        os.chmod(ruta, 0o555)
    else:
        raise ValueError(f"tipo desconocido {t!r}")


def borrar(ruta: str):
    for raiz, dirs, _ in os.walk(ruta):
        for d in dirs:
            p = os.path.join(raiz, d)
            if not os.path.islink(p):
                os.chmod(p, 0o755)
    os.chmod(ruta, 0o755)
    shutil.rmtree(ruta)


def traer(hash_: str, hechos: set):
    if hash_ in hechos:
        return
    hechos.add(hash_)
    info = narinfo(hash_)
    destino = info["StorePath"]
    for ref in info.get("References", "").split():
        h = ref.split("-", 1)[0]
        if h != hash_:
            traer(h, hechos)
    if os.path.lexists(destino):
        print(f"  ya está  {destino}")
        return
    print(f"  bajando  {destino}  ({int(info['FileSize']) / 1e6:.0f} MB)", flush=True)
    comp = info.get("Compression", "none")
    with urllib.request.urlopen(f"{CACHE}/{info['URL']}", timeout=600) as r:
        if comp == "zstd":
            f = zstandard.ZstdDecompressor().stream_reader(r)
        elif comp == "xz":
            import lzma
            f = lzma.LZMAFile(r)
        elif comp == "none":
            f = r
        else:
            raise SystemExit(f"compresión no soportada: {comp}")
        L = Lector(f)
        try:
            L.esperar(b"nix-archive-1")
            nodo(L, destino)
        except Exception:
            if os.path.lexists(destino):
                borrar(destino)
            raise
    esperado = info["NarHash"].split(":", 1)[1]
    obtenido = nix32(L.h.digest())
    if obtenido != esperado:
        borrar(destino)
        raise SystemExit(f"NarHash NO coincide en {destino}: {obtenido} != {esperado}")
    print(f"  NarHash OK")


def main():
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    os.makedirs(TIENDA, exist_ok=True)
    traer(sys.argv[1].split("-", 1)[0], set())


if __name__ == "__main__":
    main()
