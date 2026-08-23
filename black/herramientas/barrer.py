#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
barrer.py -- barre el .text del EE buscando instrucciones por patron.

POR QUE EXISTE, Y POR QUE NO USA CAPSTONE
    capstone con CS_MODE_MIPS32 se DETIENE a las 2 instrucciones sobre el
    .text de BLACK: se traga el primer opcode propio del R5900 y aborta el
    desensamblado. Costo medido: una sesion entera de la fase 7c.
    La salida es no usar un desensamblador. Las instrucciones tipo-I de MIPS
    son campos fijos y alcanza con struct.unpack_from:

        op = (w >> 26) & 0x3F      rs = (w >> 21) & 0x1F
        rt = (w >> 16) & 0x1F      imm = w & 0xFFFF

    Con eso se buscan stores y loads por OFFSET, que es lo que sirve para
    contestar "quien escribe campo+0xNN".

EL PARAMETRO DE BUSQUEDA ES LO QUE DECIDE SI SIRVE
    Lo que cierra una fase es un parametro que DISCRIMINA, no un barrido con
    mas esfuerzo. Dos casos medidos de este mismo proyecto:
      - 7c: 'sw con offsets {4,8,C}' -> 339 candidatos, inutil.
            'addiu rX,rX,0x24' (el paso del pool) -> 32, y uno cerro la fase.
      - 7d: stores a +0xEC en 0x00155000-0x0015D200 -> 54 accesos y UN SOLO
            store. Ese store era la respuesta.
    Si un barrido devuelve decenas de candidatos, el problema es el
    parametro, no el barrido.

MAPEO DE DIRECCIONES
    El .text arranca en el offset de archivo 0x1000 y en la direccion
    0x00100000:   addr = 0x100000 + (off - 0x1000)

USO
    python herramientas/barrer.py off 0xEC                    # todo el .text
    python herramientas/barrer.py off 0xEC --desde 0x00155000 --hasta 0x0015D200
    python herramientas/barrer.py off 0xEC --solo store
    python herramientas/barrer.py imm 0x24 --op addiu
    python herramientas/barrer.py autotest
"""

from __future__ import annotations

import argparse
import struct
import sys

# .text del ELF: donde empieza en el archivo y en memoria.
TEXT_OFF = 0x1000
TEXT_ADDR = 0x00100000
TEXT_FIN = 0x00396F48  # exclusivo; sale de 'decompilar.py info'

STORES = {
    0x28: "sb", 0x29: "sh", 0x2A: "swl", 0x2B: "sw", 0x2C: "sdl",
    0x2D: "sdr", 0x2E: "swr", 0x38: "sc", 0x39: "swc1", 0x3D: "sdc1",
    0x3F: "sd", 0x1F: "sq",
}
LOADS = {
    0x20: "lb", 0x21: "lh", 0x22: "lwl", 0x23: "lw", 0x24: "lbu",
    0x25: "lhu", 0x26: "lwr", 0x27: "lwu", 0x37: "ld", 0x31: "lwc1",
    0x35: "ldc1", 0x1E: "lq",
}
# Tipo-I que no son memoria pero se buscan igual (el 'addiu rX,rX,0x24' de 7c).
ARITH = {
    0x08: "addi", 0x09: "addiu", 0x0A: "slti", 0x0B: "sltiu",
    0x0C: "andi", 0x0D: "ori", 0x0E: "xori", 0x0F: "lui",
}
REG = [
    "zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
    "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
    "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
    "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra",
]


def ruta_elf() -> str:
    """La ruta del ELF sale de kb/ubicaciones.json, no se escribe a mano."""
    import subprocess
    import os
    aqui = os.path.dirname(os.path.abspath(__file__))
    try:
        out = subprocess.run(
            [sys.executable, os.path.join(aqui, "ubicaciones.py"), "ruta", "elf_copia"],
            capture_output=True, text=True, timeout=60,
        )
        r = out.stdout.strip()
        if r and os.path.exists(r):
            return r
    except Exception:
        pass
    # Respaldo: la copia conocida. Si tampoco esta, que reviente con nombre.
    return r"C:\Users\frans\herramientas\SLUS_213.76"


def off_de(addr: int) -> int:
    return TEXT_OFF + (addr - TEXT_ADDR)


def decodificar(w: int):
    """Campos de una instruccion tipo-I. No decodifica tipo-R ni tipo-J."""
    return ((w >> 26) & 0x3F, (w >> 21) & 0x1F, (w >> 16) & 0x1F, w & 0xFFFF)


def barrer(data: bytes, desde: int, hasta: int, imm_buscado: int, familias):
    """Devuelve [(addr, mnemonico, rt, rs, familia)] de lo que matchea."""
    res = []
    a = desde
    while a < hasta:
        w = struct.unpack_from("<I", data, off_de(a))[0]
        op, rs, rt, imm = decodificar(w)
        if imm == imm_buscado:
            for nombre, tabla in familias:
                if op in tabla:
                    res.append((a, tabla[op], rt, rs, nombre))
        a += 4
    return res


def imprimir(res, imm, desde, hasta):
    print("rango 0x%08X-0x%08X  imm=0x%X  ->  %d resultados"
          % (desde, hasta, imm, len(res)))
    for a, mn, rt, rs, fam in res:
        if fam in ("store", "load"):
            print("  0x%08X  %-5s $%s, 0x%X($%s)   [%s]"
                  % (a, mn, REG[rt], imm, REG[rs], fam))
        else:
            print("  0x%08X  %-5s $%s, $%s, 0x%X   [%s]"
                  % (a, mn, REG[rt], REG[rs], imm, fam))
    if len(res) > 40:
        print()
        print("  OJO: %d candidatos es demasiado para decidir nada. El problema"
              % len(res))
        print("  es el PARAMETRO de busqueda, no el barrido. Buscar algo que")
        print("  discrimine: un paso de estructura, un offset raro, un inmediato")
        print("  que solo tenga sentido en este subsistema.")


def autotest() -> int:
    """
    Prueba el decodificador contra instrucciones YA CONFIRMADAS del proyecto,
    y despues se sabotea a si mismo para verificar que se pone en rojo.
    """
    data = open(ruta_elf(), "rb").read()
    fallos = 0

    # Casos confirmados en bitacora + kb. (direccion, mnemonico, rt, rs, imm)
    casos = [
        # 7d: la escritura del descriptor de arma. Bitacora (35).
        (0x00156318, "sw", "v0", "s0", 0xEC),
        # 7c: la escritura del bloque de IA, rama NPC. Bitacora (34).
        (0x00159014, "sw", "a0", "s1", 0x0C),
        # 7c: la misma escritura, rama jugador.
        (0x00158FF4, "sw", "s0", "s1", 0x0C),
        # 7c: el offset fijo +0x30 que elige el bloque de IA.
        (0x00159008, "addiu", "a0", "s0", 0x30),
    ]
    print("== casos confirmados ==")
    for addr, mn_esp, rt_esp, rs_esp, imm_esp in casos:
        w = struct.unpack_from("<I", data, off_de(addr))[0]
        op, rs, rt, imm = decodificar(w)
        mn = STORES.get(op) or LOADS.get(op) or ARITH.get(op) or "?op=0x%02X" % op
        ok = (mn == mn_esp and REG[rt] == rt_esp and REG[rs] == rs_esp and imm == imm_esp)
        print("  %s 0x%08X  %-5s $%s, 0x%X($%s)   esperado: %s $%s, 0x%X($%s)"
              % ("OK " if ok else "MAL", addr, mn, REG[rt], imm, REG[rs],
                 mn_esp, rt_esp, imm_esp, rs_esp))
        if not ok:
            fallos += 1

    # Regla 3 del perfil: una alarma que nunca dijo que no, no verifica nada.
    # Se rompe a proposito de dos formas distintas y tiene que dar MAL las dos.
    print()
    print("== sabotaje: el autotest tiene que ponerse en rojo ==")
    w = struct.unpack_from("<I", data, off_de(0x00156318))[0]

    # (a) campos corridos un bit: rt y rs salen mal.
    op_a, rs_a, rt_a, imm_a = ((w >> 25) & 0x3F, (w >> 20) & 0x1F,
                               (w >> 15) & 0x1F, w & 0xFFFF)
    detecta_a = not (STORES.get(op_a) == "sw" and REG[rt_a] == "v0" and REG[rs_a] == "s0")
    print("  %s (a) campos corridos un bit -> lo detecta" % ("OK " if detecta_a else "MAL"))
    if not detecta_a:
        fallos += 1

    # (b) mapeo de direcciones sin el ajuste de 0x1000: lee otra instruccion.
    w_b = struct.unpack_from("<I", data, 0x00156318 - TEXT_ADDR)[0]
    detecta_b = (w_b != w)
    print("  %s (b) mapeo addr->offset sin el 0x1000 -> lo detecta"
          % ("OK " if detecta_b else "MAL"))
    if not detecta_b:
        fallos += 1

    print()
    if fallos:
        print("AUTOTEST EN ROJO: %d fallos" % fallos)
        return 1
    print("AUTOTEST OK: 4 casos confirmados y 2 sabotajes detectados")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_off = sub.add_parser("off", help="buscar accesos a memoria con ese offset")
    p_off.add_argument("offset", help="offset del campo, ej 0xEC")
    p_off.add_argument("--desde", default=hex(TEXT_ADDR))
    p_off.add_argument("--hasta", default=hex(TEXT_FIN))
    p_off.add_argument("--solo", choices=["store", "load", "ambos"], default="ambos")

    p_imm = sub.add_parser("imm", help="buscar tipo-I aritmeticas con ese inmediato")
    p_imm.add_argument("inmediato", help="valor inmediato, ej 0x24")
    p_imm.add_argument("--desde", default=hex(TEXT_ADDR))
    p_imm.add_argument("--hasta", default=hex(TEXT_FIN))
    p_imm.add_argument("--op", default=None, help="filtrar por mnemonico, ej addiu")

    sub.add_parser("autotest", help="probar el decodificador, y romperlo a proposito")

    a = ap.parse_args()
    if a.cmd == "autotest":
        return autotest()

    data = open(ruta_elf(), "rb").read()
    desde, hasta = int(a.desde, 16), int(a.hasta, 16)
    if not (TEXT_ADDR <= desde < hasta <= TEXT_FIN):
        print("ERROR: el rango tiene que caer dentro del .text (0x%08X-0x%08X)"
              % (TEXT_ADDR, TEXT_FIN))
        return 1

    if a.cmd == "off":
        imm = int(a.offset, 16)
        fam = []
        if a.solo in ("store", "ambos"):
            fam.append(("store", STORES))
        if a.solo in ("load", "ambos"):
            fam.append(("load", LOADS))
        imprimir(barrer(data, desde, hasta, imm, fam), imm, desde, hasta)
    else:
        imm = int(a.inmediato, 16)
        tabla = ARITH if a.op is None else {k: v for k, v in ARITH.items() if v == a.op}
        if not tabla:
            print("ERROR: mnemonico desconocido: %s. Conocidos: %s"
                  % (a.op, ", ".join(sorted(set(ARITH.values())))))
            return 1
        imprimir(barrer(data, desde, hasta, imm, [("arith", tabla)]), imm, desde, hasta)
    return 0


if __name__ == "__main__":
    sys.exit(main())
