#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Encuentra y lee el STREAM DE MODULOS del nivel en un volcado de EE.

El stage se le pasa a FUN_0015ef48 como param_2 = {u32 count, u32 array}, y el
array son `count` registros de 0x10:

    +0x00  u32  tipo      (el case del switch de FUN_0015ef48)
    +0x04  u32  ptr       (blob de datos del modulo, tamano variable)
    +0x08  u64  id64      (nombre del modulo; herramientas/id64.py lo decodifica)

EL PARAMETRO QUE DISCRIMINA no es el rango del tipo -- eso da contadores
secuenciales de .data como falsos positivos. Es la MONOTONIA ESTRICTA del
puntero de +0x04: los blobs estan contiguos y ascendentes, y los contadores no.
Con el rango de tipos solo, el barrido daba 817 rachas; con la monotonia, 1.

Uso:
    python herramientas/stream_modulos.py autotest
    python herramientas/stream_modulos.py buscar
    python herramientas/stream_modulos.py resumen 0x01092800
    python herramientas/stream_modulos.py listar 0x01092800 --tipo 0x2D
"""
from __future__ import annotations

import argparse
import os
import struct
import sys
from array import array
from collections import Counter, defaultdict

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(AQUI)
VOLCADO = os.path.join(RAIZ, "volcados", "ee-e4.bin")
sys.path.insert(0, AQUI)
from id64 import decodificar  # noqa: E402

LO, HI = 0x00080000, 0x02000000
TIPO_MAX = 0x44
MIN_CNT, MAX_CNT = 8, 20000


def cargar(ruta=VOLCADO):
    with open(ruta, "rb") as f:
        d = f.read()
    w = array("I")
    w.frombytes(d[: (len(d) // 4) * 4])
    return d, w


def valida(w, cnt, ptr, lo=LO, hi=HI, tipo_max=TIPO_MAX, exigir_monotonia=True):
    """True si en `ptr` hay `cnt` registros con tipo valido y ptr ascendente."""
    n = len(w)
    b = ptr // 4
    if b + cnt * 4 + 4 > n:
        return False
    prev = -1
    for k in range(cnt):
        t = w[b + k * 4]
        p = w[b + k * 4 + 1]
        if t > tipo_max:
            return False
        if not (lo <= p < hi):
            return False
        if exigir_monotonia and p <= prev:
            return False
        prev = p
    return True


def buscar(w, **kw):
    """Todos los pares {count, array} que validan. Devuelve [(desc, cnt, ptr)]."""
    n = len(w)
    out = []
    for i in range(n - 1):
        cnt = w[i]
        if not (MIN_CNT <= cnt <= MAX_CNT):
            continue
        ptr = w[i + 1]
        if not (LO <= ptr < HI) or ptr % 4:
            continue
        if valida(w, cnt, ptr, **kw):
            out.append((i * 4, cnt, ptr))
    return out


def registros(d, desc):
    cnt, arr = struct.unpack_from("<II", d, desc)
    return cnt, arr, [struct.unpack_from("<IIQ", d, arr + k * 0x10) for k in range(cnt)]


def cmd_buscar(a):
    d, w = cargar(a.volcado)
    hits = buscar(w)
    print("streams encontrados: %d" % len(hits))
    for desc, cnt, ptr in hits:
        tipos = Counter(w[ptr // 4 + k * 4] for k in range(cnt))
        print("  descriptor %08X  {count=%d, array=%08X}  rango %08X-%08X  tipos=%d"
              % (desc, cnt, ptr, ptr, ptr + cnt * 0x10, len(tipos)))
    return 0


def cmd_resumen(a):
    d, w = cargar(a.volcado)
    cnt, arr, regs = registros(d, int(a.descriptor, 16))
    print("descriptor %s -> {count=%d, array=%08X}" % (a.descriptor, cnt, arr))
    ptrs = [p for _, p, _ in regs]
    print("blobs: %08X - %08X, ascendente=%s, tam min=%d max=%d"
          % (ptrs[0], ptrs[-1],
             all(ptrs[i] < ptrs[i + 1] for i in range(cnt - 1)),
             min(ptrs[i + 1] - ptrs[i] for i in range(cnt - 1)),
             max(ptrs[i + 1] - ptrs[i] for i in range(cnt - 1))))
    por = defaultdict(list)
    for t, p, pay in regs:
        por[t].append(pay)
    print()
    print("tipo   n    familias      muestra")
    for t in sorted(por):
        nombres = [decodificar(v) for v in por[t]]
        fam = sorted({"".join(c for c in n[:2] if c.isalpha()) for n in nombres})
        print("  %02X  %-4d  %-12s  %s"
              % (t, len(nombres), ",".join(f for f in fam if f),
                 "  ".join(n.strip() for n in nombres[:4])))
    return 0


def cmd_listar(a):
    d, w = cargar(a.volcado)
    cnt, arr, regs = registros(d, int(a.descriptor, 16))
    filtro = int(a.tipo, 16) if a.tipo else None
    for k, (t, p, pay) in enumerate(regs):
        if filtro is not None and t != filtro:
            continue
        print("#%-4d %08X  tipo=%02X  blob=%08X  %s"
              % (k, arr + k * 0x10, t, p, decodificar(pay).strip()))
    return 0


# --------------------------------------------------------------------------
# autotest -- probado ROMPIENDOLO (regla 3 del perfil)
# --------------------------------------------------------------------------
DESC_ANCLA = 0x01092800
CNT_ANCLA = 857
ARR_ANCLA = 0x0109F590
# El registro #36 es el primero de la racha de 0x2D que ya habia visto la
# sesion anterior, y su nombre decodifica a LW0001781.
ANCLA_REG = (36, 0x2D, "LW0001781")


def autotest(volcado=VOLCADO):
    fallas = 0
    d, w = cargar(volcado)

    print("== casos confirmados ==")
    cnt, arr, regs = registros(d, DESC_ANCLA)
    for etiqueta, obtenido, esperado in [
        ("count del descriptor", cnt, CNT_ANCLA),
        ("array del descriptor", arr, ARR_ANCLA),
        ("tipo del registro #36", regs[ANCLA_REG[0]][0], ANCLA_REG[1]),
        ("nombre del registro #36", decodificar(regs[ANCLA_REG[0]][2]).strip(),
         ANCLA_REG[2]),
    ]:
        ok = obtenido == esperado
        print("  %s  %-24s obtenido=%r esperado=%r"
              % ("OK " if ok else "MAL", etiqueta, obtenido, esperado))
        if not ok:
            fallas += 1

    # El largo derivado por monotonia tiene que coincidir con el count leido.
    # Son dos caminos independientes: eso es el control positivo del layout.
    j = ARR_ANCLA
    while True:
        _, p0, _ = struct.unpack_from("<IIQ", d, j)
        _, p1, _ = struct.unpack_from("<IIQ", d, j + 0x10)
        if not (LO <= p1 < HI and p0 < p1 and p1 - p0 < 0x4000):
            break
        j += 0x10
    largo = (j - ARR_ANCLA) // 0x10 + 1
    ok = largo == CNT_ANCLA
    print("  %s  %-24s obtenido=%d esperado=%d"
          % ("OK " if ok else "MAL", "largo por monotonia", largo, CNT_ANCLA))
    if not ok:
        fallas += 1

    print()
    print("== sabotaje: el autotest tiene que ponerse en rojo ==")

    # (a) sin monotonia, el criterio deja de discriminar y aparecen falsos
    hits_ok = buscar(w)
    hits_sin = buscar(w, exigir_monotonia=False)
    detecta_a = len(hits_sin) > len(hits_ok)
    print("  %s  (a) sin monotonia -> %d streams contra %d"
          % ("OK " if detecta_a else "MAL", len(hits_sin), len(hits_ok)))
    if not detecta_a:
        fallas += 1

    # (b) volcado corrido 4 bytes -> el descriptor deja de leerse donde va
    corrido = array("I")
    corrido.frombytes(b"\x00\x00\x00\x00" + w.tobytes()[:-4])
    cnt_b = struct.unpack_from("<I", b"\x00\x00\x00\x00" + d, DESC_ANCLA)[0]
    detecta_b = cnt_b != CNT_ANCLA
    print("  %s  (b) volcado corrido 4 bytes -> %s"
          % ("OK " if detecta_b else "MAL", "lo detecta" if detecta_b else "NO lo detecta"))
    if not detecta_b:
        fallas += 1

    print()
    if fallas:
        print("AUTOTEST EN ROJO: %d falla(s)" % fallas)
        return 1
    print("AUTOTEST OK: 5 casos confirmados y 2 sabotajes detectados")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--volcado", default=VOLCADO)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("autotest")
    sub.add_parser("buscar")
    p = sub.add_parser("resumen")
    p.add_argument("descriptor")
    p = sub.add_parser("listar")
    p.add_argument("descriptor")
    p.add_argument("--tipo")
    a = ap.parse_args()

    if a.cmd == "autotest":
        return autotest(a.volcado)
    if a.cmd == "buscar":
        return cmd_buscar(a)
    if a.cmd == "resumen":
        return cmd_resumen(a)
    return cmd_listar(a)


if __name__ == "__main__":
    sys.exit(main())
