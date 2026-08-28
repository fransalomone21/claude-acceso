#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""registro_fisica.py -- CONTROL EN FRIO del registro que llena el tipo 0x2D.

QUE MIDE, Y POR QUE EXISTE
    El plan de 7e daba por sentado que el camino de exito del tipo 0x2D
    (`FUN_00175A00` -> `FUN_00175F10(param_1 + idx*0xC + 0x40, ...)`) llenaba
    un array de 256 entradas, y que rompiendo un nombre tenia que quedar en
    "255 de 256". Esto mide lo que el volcado TIENE, antes de intervenir.

    Es un characterization test: no verifica una hipotesis, la fija.

DE DONDE SALEN LAS CONSTANTES -- de instrucciones, no del decompilador
    Ghidra pierde argumentos en este binario (ya paso dos veces). Las tres
    constantes de abajo salen del sitio de llamada desensamblado a mano:

        0x0015F778  lw    v0, 4(s1)        ; v0 = blob del registro
        0x0015F780  lbu   v1, 0x1E(v0)     ; GUARDA
        0x0015F784  bne   v1, a0, ...      ; a0=1 -> solo pasa si blob[0x1E]==1
        0x0015F78C  lui   v1, 0x41
        0x0015F794  lw    a0, -2860(v1)    ; a0 = *(0x0040F4D4)
        0x0015F79C  jal   0x00175980
        0x0015F7A0  addiu a0, a0, 2632     ; delay slot -> a0 += 0xA48

    El objeto es entonces `*(0x0040F4D4) + 0xA48`, y su layout sale de las
    tres rutinas que lo recorren:

        +0x00  16 punteros           (FUN_00175BB0: `param_1+1` int*, tope 0xF)
        +0x40  0x30 ranuras de 0xC   (FUN_00175BF0 tope 0x2F; FUN_00175C30 <0x30)

        ranura:  +0x00 u8  ocupada (FUN_00175F10 escribe 1)
                 +0x01 u8  param_3
                 +0x04 u32 objeto
                 +0x08 u32 *(DAT_0040F4D0 + 0x20)

    SON 0x30 = 48 RANURAS, NO 256. El 256 es la cantidad de registros de tipo
    0x2D que tiene el stream de LEVEL_00, que es otra cosa.

Uso:
    python herramientas/registro_fisica.py medir
    python herramientas/registro_fisica.py todos
    python herramientas/registro_fisica.py autotest
"""
from __future__ import annotations

import argparse
import glob
import os
import struct
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(AQUI)
VOLCADO = os.path.join(RAIZ, "volcados", "ee-e4.bin")

GLOBAL_PTR = 0x0040F4D4   # lui 0x41 / lw -2860
DESPL      = 0xA48        # delay slot: addiu a0, a0, 2632
OFF_ARRAY  = 0x40
PASO       = 0xC
RANURAS    = 0x30         # 48 -- el tope que exigen FUN_00175BF0 y FUN_00175C30
GUARDA_OFF = 0x1E         # lbu v1, 0x1E(v0)
GUARDA_VAL = 1

DESC_STREAM = 0x01092800  # descriptor del stream de modulos de LEVEL_00
TIPO_2D     = 0x2D
LO, HI      = 0x00080000, 0x02000000

# lo medido el 2026-08-28 sobre los 9 volcados de 32 MB del repo
ESPERADO = {
    "objeto":    0x004CB1C8,
    "cabecera0": 0x006BD600,
    "paso_cab":  0x500,
    "regs_2d":   256,
    "pasan":     4,
    "ocupadas":  0,
}


def cargar(ruta=VOLCADO):
    with open(ruta, "rb") as f:
        return f.read()


def u32(d, a):
    return struct.unpack_from("<I", d, a)[0]


def objeto(d, gl=GLOBAL_PTR, despl=DESPL):
    """Direccion del registro: *(0x0040F4D4) + 0xA48."""
    return u32(d, gl) + despl


def cabecera(d, base):
    """Los 16 punteros de +0x00. Es el control de que la base esta bien."""
    return [u32(d, base + i * 4) for i in range(16)]


def cabecera_sana(punteros, paso=ESPERADO["paso_cab"]):
    """True si son 16 punteros a RAM con paso uniforme. No hay como acertarle
    a esto por casualidad: es la evidencia de que la base es la correcta."""
    if not all(LO <= p < HI for p in punteros):
        return False
    return all(b - a == paso for a, b in zip(punteros, punteros[1:]))


def ranuras(d, base):
    """Las 48 ranuras crudas: (ocupada, flag, objeto, extra)."""
    arr = base + OFF_ARRAY
    out = []
    for i in range(RANURAS):
        a = arr + i * PASO
        out.append((d[a], d[a + 1], u32(d, a + 4), u32(d, a + 8)))
    return out


def registros_2d(d, desc=DESC_STREAM):
    """(indice, blob) de cada registro de tipo 0x2D del stream."""
    cnt, arr = u32(d, desc), u32(d, desc + 4)
    return [(i, u32(d, arr + i * 0x10 + 4))
            for i in range(cnt) if u32(d, arr + i * 0x10) == TIPO_2D]


def pasan_guarda(d, regs):
    """Los que superan `lbu v1,0x1E(v0); bne v1,1`. Son los unicos que
    pueden llegar a ocupar una ranura."""
    return [(i, b) for i, b in regs if d[b + GUARDA_OFF] == GUARDA_VAL]


def medir(d, etiqueta=""):
    base = objeto(d)
    cab = cabecera(d, base)
    rs = ranuras(d, base)
    oc = [(i, r) for i, r in enumerate(rs) if r[0]]
    regs = registros_2d(d)
    pasan = pasan_guarda(d, regs)
    return {
        "etiqueta": etiqueta,
        "global": u32(d, GLOBAL_PTR),
        "objeto": base,
        "cabecera": cab,
        "cabecera_sana": cabecera_sana(cab),
        "ranuras": rs,
        "ocupadas": len(oc),
        "detalle_ocupadas": oc,
        "regs_2d": len(regs),
        "pasan": len(pasan),
        "detalle_pasan": pasan,
    }


def imprimir(m):
    print("  *(0x%08X)      = 0x%08X" % (GLOBAL_PTR, m["global"]))
    print("  objeto (+0x%X)     = 0x%08X" % (DESPL, m["objeto"]))
    print("  cabecera de 16 punteros: %s (paso uniforme 0x%X)"
          % ("SANA" if m["cabecera_sana"] else "NO SANA", ESPERADO["paso_cab"]))
    print("    [0]=0x%08X ... [15]=0x%08X" % (m["cabecera"][0], m["cabecera"][15]))
    print()
    print("  registros tipo 0x2D en el stream ....... %d" % m["regs_2d"])
    print("  de esos, pasan blob[0x%02X]==%d ......... %d"
          % (GUARDA_OFF, GUARDA_VAL, m["pasan"]))
    print("  RANURAS OCUPADAS ....................... %d de %d"
          % (m["ocupadas"], RANURAS))
    for i, r in m["detalle_ocupadas"]:
        print("      ranura %2d: ocupada=%02X flag=%02X obj=0x%08X extra=0x%08X"
              % (i, r[0], r[1], r[2], r[3]))


def cmd_medir(args):
    d = cargar(args.volcado)
    print("== registro de fisica/pathfinding -- %s ==" % os.path.basename(args.volcado))
    imprimir(medir(d, args.volcado))
    return 0


def cmd_todos(args):
    print("== la misma medicion sobre todos los volcados de 32 MB del repo ==")
    print()
    print("  %-22s %-12s %-12s %s" % ("volcado", "*0x40F4D4", "objeto", "ocupadas/48"))
    vistos = ocupados = 0
    for f in sorted(glob.glob(os.path.join(RAIZ, "volcados", "ee-*.bin"))):
        d = cargar(f)
        if len(d) < HI:
            continue
        m = medir(d, f)
        vistos += 1
        ocupados += m["ocupadas"]
        print("  %-22s 0x%08X   0x%08X   %2d%s"
              % (os.path.basename(f), m["global"], m["objeto"], m["ocupadas"],
                 "" if m["cabecera_sana"] else "   (CABECERA NO SANA)"))
    print()
    print("  %d volcados, %d ranuras ocupadas en total." % (vistos, ocupados))
    if not ocupados:
        print("  Ninguno mostro una ranura ocupada: el instrumento NO esta")
        print("  probado todavia contra un caso positivo REAL (solo sintetico).")
    return 0


def autotest(args=None):
    fallas = 0
    d = cargar(VOLCADO)
    m = medir(d, VOLCADO)

    print("== casos confirmados (ee-e4.bin) ==")
    for etiqueta, obtenido, esperado in [
        ("objeto del registro", m["objeto"], ESPERADO["objeto"]),
        ("cabecera[0]", m["cabecera"][0], ESPERADO["cabecera0"]),
        ("cabecera sana", m["cabecera_sana"], True),
        ("registros 0x2D", m["regs_2d"], ESPERADO["regs_2d"]),
        ("pasan la guarda", m["pasan"], ESPERADO["pasan"]),
        ("ranuras ocupadas", m["ocupadas"], ESPERADO["ocupadas"]),
    ]:
        ok = obtenido == esperado
        print("  %s  %-22s obtenido=%r esperado=%r"
              % ("OK " if ok else "MAL", etiqueta, obtenido, esperado))
        if not ok:
            fallas += 1

    print()
    print("== sabotaje: esto tiene que ponerse en rojo ==")

    # (a) EL SABOTAJE QUE IMPORTA. El contador solo dijo 0 en su vida; si no
    #     sabe decir otra cosa, el 0 no significa nada. Se ocupa una ranura a
    #     mano en una copia y se exige que la cuente.
    falso = bytearray(d)
    a = m["objeto"] + OFF_ARRAY + 7 * PASO
    falso[a] = 1
    falso[a + 1] = 2
    struct.pack_into("<II", falso, a + 4, 0x00DEAD00, 0x00BEEF00)
    n = medir(bytes(falso))["ocupadas"]
    det = n == 1
    print("  %s  (a) ranura 7 ocupada a mano -> cuenta %d (esperado 1)"
          % ("OK " if det else "MAL", n))
    if not det:
        fallas += 1

    # (b) global equivocado (0x0040F4D0, el DAT vecino que muestra Ghidra):
    #     la cabecera tiene que dejar de ser sana.
    base_b = objeto(d, gl=0x0040F4D0)
    det = not cabecera_sana(cabecera(d, base_b))
    print("  %s  (b) global 0x0040F4D0 -> base 0x%08X, cabecera %s"
          % ("OK " if det else "MAL", base_b,
             "NO sana" if det else "SANA (no lo detecta)"))
    if not det:
        fallas += 1

    # (c) desplazamiento equivocado (0xA40 en vez de 0xA48): idem.
    base_c = objeto(d, despl=0xA40)
    det = not cabecera_sana(cabecera(d, base_c))
    print("  %s  (c) desplazamiento 0xA40 -> base 0x%08X, cabecera %s"
          % ("OK " if det else "MAL", base_c,
             "NO sana" if det else "SANA (no lo detecta)"))
    if not det:
        fallas += 1

    # (d) sin la guarda blob[0x1E]==1 se contarian los 256, no 4.
    det = m["regs_2d"] != m["pasan"]
    print("  %s  (d) sin la guarda serian %d y no %d"
          % ("OK " if det else "MAL", m["regs_2d"], m["pasan"]))
    if not det:
        fallas += 1

    print()
    if fallas:
        print("AUTOTEST EN ROJO: %d falla(s)" % fallas)
        return 1
    print("AUTOTEST EN VERDE: 6 casos, 4 sabotajes.")
    return 0


def main():
    p = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = p.add_subparsers(dest="cmd", required=True)
    m = sub.add_parser("medir", help="el conteo sobre un volcado")
    m.add_argument("--volcado", default=VOLCADO)
    m.set_defaults(f=cmd_medir)
    t = sub.add_parser("todos", help="el conteo sobre todos los volcados del repo")
    t.set_defaults(f=cmd_todos)
    a = sub.add_parser("autotest", help="casos confirmados + sabotajes")
    a.set_defaults(f=autotest)
    args = p.parse_args()
    return args.f(args)


if __name__ == "__main__":
    sys.exit(main())
