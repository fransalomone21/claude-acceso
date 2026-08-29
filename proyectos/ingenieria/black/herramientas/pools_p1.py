#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Mide los POOLS DE HANDLES de P1 en un volcado de EE (fase 7e, paso 3b).

QUE MIDE
    El dispatcher FUN_0015ef48 no crea el objeto del modulo: saca
    handles[contador++] del array que le toca al tipo. Los 18 arrays cuelgan de
    P1 = piVar4 + 0x40. Esta herramienta ubica P1 en el volcado y contrasta la
    OCUPACION de cada pool contra la prediccion que sale del stream de modulos
    (cuantas instancias de cada tipo hay en LEVEL_00).

    Son 18 predicciones simultaneas de UNA sola medicion, y tres de ellas son
    CEROS: el control negativo.

COMO UBICA P1 -- y por que NO es un barrido
    Barrer los 32 MB buscando el tag 0x1C da miles de falsos: el tag es un
    parametro malo. Se entra por la CADENA DE INDIRECCIONES desde un dato ya
    confirmado. FUN_0012dab8 llama:

        FUN_0015ef48(piVar4+0x10, *(u32*)(piVar4[4]+4), piVar4[1], ...)

    o sea param_2 == *(u32*)(piVar4[4] + 4), y param_2 es el descriptor del
    stream, YA MEDIDO en 0x01092800. Entonces:

        1. buscar el valor 0x01092800  -> una direccion A con *(A) == desc
        2. Q = A - 4  es candidato a piVar4[4]
        3. buscar el valor Q           -> una direccion B == piVar4 + 0x10
        4. piVar4 = B - 0x10, y *piVar4 == 0x1C queda como CONTROL, no como
           criterio de busqueda.

    El paso 1 da 193 hits, pero el unico que sobrevive al paso 3 con el control
    del tag es Q = 0x01053000, que es la direccion de carga de STUNIT01.BIN
    confirmada por otra via. La cadena discrimina; el tag solo, no.

Uso:
    python herramientas/pools_p1.py localizar
    python herramientas/pools_p1.py pools
    python herramientas/pools_p1.py autotest
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from array import array

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(AQUI)
VOLCADO = os.path.join(RAIZ, "volcados", "ee-e4.bin")

DESCRIPTOR = 0x01092800   # {count=857, array=0x0109F590}, medido el 2026-08-23
TAG_CARGADOR = 0x1C       # *piVar4, tag del slot del cargador doble-buffereado
OFF_P1 = 0x40             # P1 = piVar4 + 0x40
LO, HI = 0x00080000, 0x02000000   # rango de puntero valido en RAM del EE

# Los 18 offsets de P1 que usan los casos del dispatcher. Doble control: son
# los mismos que recorre el bloque del 0x35. (casos_dispatcher.py arrays)
OFFSETS = [0x00, 0x08, 0x10, 0x14, 0x18, 0x1C, 0x20, 0x24, 0x28,
           0x2C, 0x30, 0x34, 0x38, 0x3C, 0x40, 0x44, 0x48, 0x4C]

# LA PREDICCION -- escrita ANTES de medir, en sesiones/HANDOFF.md seccion 4.
# Sale del stream de modulos: instancias de cada tipo agrupadas por destino.
PREDICHO = {
    0x1C: 131, 0x3C: 118, 0x24: 73, 0x08: 60, 0x10: 57, 0x18: 33,
    0x14: 21, 0x30: 20, 0x34: 14, 0x4C: 6, 0x2C: 5, 0x28: 5,
    0x48: 4, 0x44: 3, 0x20: 2,
    0x00: 0, 0x38: 0, 0x40: 0,   # <- el control negativo
}
CONTADOR = {
    0x1C: "c_s5", 0x3C: "c_s7", 0x24: "c_fp", 0x08: "sp+408", 0x10: "sp+412",
    0x18: "sp+416", 0x14: "sp+420", 0x30: "sp+432", 0x34: "sp+440",
    0x4C: "sp+464", 0x2C: "sp+428", 0x28: "indice fijo 0", 0x48: "sp+460",
    0x44: "sp+456", 0x20: "sp+424", 0x00: "sp+452", 0x38: "sp+444",
    0x40: "sp+448",
}


def cargar(ruta=VOLCADO):
    with open(ruta, "rb") as f:
        d = f.read()
    w = array("I")
    w.frombytes(d[: (len(d) // 4) * 4])
    return w


def leer(w, a):
    return w[a // 4]


def localizar(w, desc=DESCRIPTOR, tag=TAG_CARGADOR, exigir_tag=True):
    """Devuelve [(piVar4, Q, tag_leido)] por la cadena de indirecciones."""
    n = len(w)
    hits_desc = [i * 4 for i, v in enumerate(w) if v == desc]
    ques = sorted({a - 4 for a in hits_desc if a >= 4})
    setq = set(ques)
    out = []
    for i, v in enumerate(w):
        if v not in setq:
            continue
        b = i * 4
        p4 = b - 0x10
        if p4 < 0:
            continue
        t = w[p4 // 4]
        if exigir_tag and t != tag:
            continue
        out.append((p4, v, t))
    return out, len(hits_desc)


def capacidades(punteros):
    """Capacidad de cada pool por CONTIGUIDAD: los arrays estan pegados y en
    orden ascendente, asi que el largo de uno es donde empieza el siguiente.
    El ultimo no tiene sucesor y queda en None."""
    vivos = sorted({p for p in punteros.values() if p})
    cap = {}
    for off, p in punteros.items():
        if not p:
            cap[off] = None
            continue
        k = vivos.index(p)
        cap[off] = (vivos[k + 1] - p) // 4 if k + 1 < len(vivos) else None
    return cap


def ocupacion(w, ptr, cap, lo=LO, hi=HI):
    """Handles no nulos al inicio del array, hasta el primer hueco."""
    if not ptr:
        return 0, 0
    tope = cap if cap else 512
    n = 0
    for k in range(tope):
        a = ptr + k * 4
        if a // 4 >= len(w):
            break
        v = w[a // 4]
        if not (lo <= v < hi):
            break
        n += 1
    # validos en TODO el array, por si hay huecos en el medio
    tot = 0
    for k in range(tope):
        a = ptr + k * 4
        if a // 4 >= len(w):
            break
        v = w[a // 4]
        if lo <= v < hi:
            tot += 1
    return n, tot


def medir(w, p4):
    p1 = p4 + OFF_P1
    punteros = {off: leer(w, p1 + off) for off in OFFSETS}
    punteros = {o: (p if LO <= p < HI else 0) for o, p in punteros.items()}
    cap = capacidades(punteros)
    filas = []
    for off in OFFSETS:
        p = punteros[off]
        pref, tot = ocupacion(w, p, cap[off])
        filas.append({
            "offset": off, "ptr": p, "capacidad": cap[off],
            "ocupados": pref, "validos_total": tot,
            "predicho": PREDICHO[off], "contador": CONTADOR[off],
        })
    return p1, filas


def cmd_localizar(a):
    w = cargar(a.volcado)
    hits, n_desc = localizar(w)
    print("hits del descriptor 0x%08X : %d" % (DESCRIPTOR, n_desc))
    print("candidatos que pasan el control *piVar4 == 0x%X : %d" % (TAG_CARGADOR, len(hits)))
    for p4, q, t in hits:
        print("  piVar4 = 0x%08X   piVar4[4] = 0x%08X   tag = 0x%X   P1 = 0x%08X"
              % (p4, q, t, p4 + OFF_P1))
    return 0 if len(hits) == 1 else 1


def cmd_pools(a):
    w = cargar(a.volcado)
    hits, _ = localizar(w)
    if len(hits) != 1:
        print("ERROR: %d candidatos, se esperaba 1" % len(hits))
        return 1
    p4 = hits[0][0]
    p1, filas = medir(w, p4)
    print("piVar4 = 0x%08X    P1 = 0x%08X    volcado = %s"
          % (p4, p1, os.path.basename(a.volcado)))
    print()
    print("  P1+off   puntero     cap   ocup   valid   PREDICHO   contador")
    print("  " + "-" * 68)
    ok = falla = 0
    for f in sorted(filas, key=lambda x: -x["predicho"]):
        marca = "OK " if f["ocupados"] == f["predicho"] else "!! "
        if f["ocupados"] == f["predicho"]:
            ok += 1
        else:
            falla += 1
        cap = "%4d" % f["capacidad"] if f["capacidad"] is not None else "   ?"
        print("  %s+0x%02X  0x%08X  %s  %5d  %5d   %8d   %s"
              % (marca, f["offset"], f["ptr"], cap, f["ocupados"],
                 f["validos_total"], f["predicho"], f["contador"]))
    print()
    print("  aciertos: %d/18   fallas: %d" % (ok, falla))
    tp = sum(f["predicho"] for f in filas)
    to = sum(f["ocupados"] for f in filas)
    print("  total predicho: %d   total ocupado: %d" % (tp, to))
    if a.json:
        with open(a.json, "w", encoding="utf-8") as fh:
            json.dump({"piVar4": p4, "P1": p1, "filas": filas}, fh, indent=1)
        print("  json -> %s" % a.json)
    return 0


def autotest(volcado=VOLCADO):
    w = cargar(volcado)
    fallos = 0
    print("== casos ==")

    hits, n_desc = localizar(w)
    ok = len(hits) == 1 and hits[0][0] == 0x005AD410
    print("  %s la cadena da UN solo piVar4 = 0x005AD410 (de %d hits del descriptor)"
          % ("OK  " if ok else "MAL ", n_desc))
    fallos += not ok

    p4 = 0x005AD410
    ok = leer(w, p4) == TAG_CARGADOR
    print("  %s control: *piVar4 == 0x1C" % ("OK  " if ok else "MAL "))
    fallos += not ok

    ok = leer(w, p4 + 0x10) == 0x01053000
    print("  %s piVar4[4] == 0x01053000, la carga de STUNIT01.BIN (otra via)"
          % ("OK  " if ok else "MAL "))
    fallos += not ok

    otro = (p4 - 0x4990) + 0x5210
    ok = otro - p4 == 0x880
    print("  %s el otro slot del doble buffer cae a +0x880 (0x%08X)"
          % ("OK  " if ok else "MAL ", otro))
    fallos += not ok

    _, filas = medir(w, p4)
    ceros = [f for f in filas if f["predicho"] == 0]
    ok = len(ceros) == 3
    print("  %s el control negativo son 3 offsets (0x00, 0x38, 0x40)"
          % ("OK  " if ok else "MAL "))
    fallos += not ok

    print("== sabotaje: el autotest tiene que ponerse en rojo ==")

    h2, _ = localizar(w, desc=DESCRIPTOR + 0x10)
    ok = len(h2) != 1
    print("  %s (a) descriptor corrido 0x10 -> deja de dar 1 candidato (da %d)"
          % ("OK  " if ok else "MAL ", len(h2)))
    fallos += not ok

    h3, _ = localizar(w, tag=0x1D)
    ok = len(h3) == 0
    print("  %s (b) tag equivocado (0x1D) -> 0 candidatos (da %d)"
          % ("OK  " if ok else "MAL ", len(h3)))
    fallos += not ok

    h4, _ = localizar(w, exigir_tag=False)
    ok = len(h4) > 1
    print("  %s (c) sin el control del tag -> %d candidatos, o sea el tag DISCRIMINA"
          % ("OK  " if ok else "MAL ", len(h4)))
    fallos += not ok

    _, mal = medir(w, p4 + 4)
    coinc = sum(1 for f in mal if f["ocupados"] == f["predicho"])
    ok = coinc < 18
    print("  %s (d) P1 corrido 4 B -> las predicciones dejan de dar (%d/18)"
          % ("OK  " if ok else "MAL ", coinc))
    fallos += not ok

    print()
    if fallos:
        print("AUTOTEST EN ROJO: %d fallos" % fallos)
    else:
        print("AUTOTEST OK: 5 casos y 4 sabotajes detectados")
    return 1 if fallos else 0


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--volcado", default=VOLCADO)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("localizar")
    p = sub.add_parser("pools")
    p.add_argument("--json", default=None)
    sub.add_parser("autotest")
    a = ap.parse_args()
    if a.cmd == "localizar":
        return cmd_localizar(a)
    if a.cmd == "pools":
        return cmd_pools(a)
    return autotest(a.volcado)


if __name__ == "__main__":
    sys.exit(main())
