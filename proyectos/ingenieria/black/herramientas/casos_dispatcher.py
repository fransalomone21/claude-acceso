#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""casos_dispatcher.py -- de que subsistema es cada tipo de modulo del stage.

POR QUE EXISTE
    El eje "que globales toca el handler" da CERO: se midio, y el cierre
    transitivo del call graph de FUN_00175980 (tipo 0x2D) NO alcanza
    0x0040F4D4, que es la base del registro de fisica YA MEDIDA por otra via.
    El motivo es que el objeto de estado NO lo nombra el handler: lo materializa
    el DESPACHADOR y se lo pasa en a0. El handler recibe un puntero y no sabe de
    donde salio.

    O sea: el subsistema de cada tipo esta escrito en el SITIO DE LLAMADA, no en
    el callee. Esta herramienta lee ese sitio de llamada para los 69 casos.

COMO
    1. La tabla de saltos del switch esta en 0x003F4E90, 69 entradas (el tope
       sale de `sltiu v0,v1,69` en 0x0015F024). Se lee del ELF, no se supone.
    2. Cada caso se recorre en ORDEN DE EJECUCION, siguiendo los saltos
       incondicionales -- diez casos no tienen `jal` propio: saltan a una COLA
       VIRTUAL compartida (0x0015F968 / 0x0015F974) que hace `jalr` sobre la
       vtable del handle. Un recorrido por direcciones crecientes los pierde.
    3. En cada llamada se resuelve a0..a3,t0,t1 con un slice hacia atras sobre
       ese orden de ejecucion (la instruccion del delay slot corre ANTES).

LAS TRES COORDENADAS QUE SALEN, Y QUE DISCRIMINAN
    destino  : el objeto que recibe el modulo -- un array de handles P1+0xNN, o
               un global de .bss (*(0x0040F4D4) = fisica, ya medido).
    contador : que indice avanza. Dos tipos con el MISMO array y el MISMO
               contador son el mismo subsistema.
    accion   : handler directo FUN_xxxxxx, o metodo virtual vtable+0xNN.

EVIDENCIA
    Todo esto es LECTURA de instrucciones: nombra el subsistema, no lo confirma.
    Un tipo no se da por identificado hasta verificarlo POR EFECTO (regla de 7e).

USO
    python herramientas/casos_dispatcher.py mapa
    python herramientas/casos_dispatcher.py mapa --json kb/casos-dispatcher.json
    python herramientas/casos_dispatcher.py familias
    python herramientas/casos_dispatcher.py caso 0x2D
    python herramientas/casos_dispatcher.py tabla
    python herramientas/casos_dispatcher.py autotest
"""
from __future__ import annotations

import argparse
import json
import os
import struct
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(AQUI)

# --- mapeo del ELF. El .text arranca en archivo 0x1000 y en memoria 0x100000;
#     la imagen es contigua, asi que el mismo delta vale para .rodata. Lo
#     verifica el sabotaje (d) del autotest: con el delta corrido, las 69
#     entradas de la tabla dejan de caer adentro del dispatcher.
TEXT_OFF, TEXT_ADDR, TEXT_FIN = 0x1000, 0x00100000, 0x00396F48
FUN, FIN = 0x0015EF48, 0x0015FDC0        # FUN_0015ef48
TABLA, N_CASOS = 0x003F4E90, 69          # de `lui v0,0x3F; addiu v0,v0,20112` y `sltiu v0,v1,69`
SALIDA = (0x0015FBDC, 0x0015FBE0)        # bloque por defecto, y cola del bucle

REG = ["zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
       "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
       "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
       "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra"]
ARITH = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F}
LOADS = {0x1E, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x31, 0x35, 0x37}
# registros vivos al entrar a cualquier caso, del preambulo del bucle
SIMB = {"s3": "P1", "s6": "P2", "s1": "REG", "s4": "i", "s5": "c_s5",
        "fp": "c_fp", "s7": "c_s7", "sp": "sp", "zero": "0"}


def ruta_elf():
    """Sale de kb/ubicaciones.json, no se escribe a mano (igual que barrer.py)."""
    import subprocess
    try:
        out = subprocess.run([sys.executable, os.path.join(AQUI, "ubicaciones.py"),
                              "ruta", "elf_copia"],
                             capture_output=True, text=True, timeout=60)
        r = out.stdout.strip()
        if r and os.path.exists(r):
            return r
    except Exception:
        pass
    r = os.path.join(os.path.expanduser("~"), "herramientas", "SLUS_213.76")
    if not os.path.exists(r):
        raise SystemExit("no encuentro el ELF; corre herramientas/ubicaciones.py")
    return r


class Imagen(object):
    def __init__(self, ruta=None, text_off=TEXT_OFF, text_addr=TEXT_ADDR):
        self.datos = open(ruta or ruta_elf(), "rb").read()
        self.text_off, self.text_addr = text_off, text_addr

    def off(self, a):
        return self.text_off + (a - self.text_addr)

    def w(self, a):
        return struct.unpack_from("<I", self.datos, self.off(a))[0]


def s16(x):
    return x - 0x10000 if x & 0x8000 else x


def campos(w):
    return ((w >> 26) & 0x3F, (w >> 21) & 0x1F, (w >> 16) & 0x1F,
            (w >> 11) & 0x1F, (w >> 6) & 0x1F, w & 0x3F, w & 0xFFFF)


def escribe(w):
    """Registro que escribe la instruccion, o None."""
    op, rs, rt, rd, sa, fn, imm = campos(w)
    if w == 0:
        return None
    if op == 0:
        if fn in (0x08, 0x0C, 0x0D, 0x0F, 0x18, 0x19, 0x1A, 0x1B, 0x11, 0x13):
            return None                      # jr, syscall, break, sync, mult, div, mthi/mtlo
        return rd
    if op in ARITH or op in LOADS:
        return rt
    return None


def leer_tabla(img, tabla=TABLA, n=N_CASOS):
    return [struct.unpack_from("<I", img.datos, img.off(tabla + i * 4))[0]
            for i in range(n)]


# --------------------------------------------------------------------------
# recorrido del caso EN ORDEN DE EJECUCION
# --------------------------------------------------------------------------
def recorrer(img, ini, fin=FIN, salida=SALIDA):
    """(orden, llamadas). `orden` son direcciones en orden de EJECUCION, con el
    delay slot ANTES de su instruccion de control -- que es cuando corre a
    efectos de los argumentos. `llamadas` son (dir, destino|None, idx, reg)."""
    orden, llamadas, visto = [], [], set()
    a = ini
    while FUN <= a < fin and a not in visto:
        visto.add(a)
        w = img.w(a)
        op, rs, rt, rd, sa, fn, imm = campos(w)
        # jal / jalr: el delay slot corre antes de que el callee vea los args
        if op == 0x03 or (op == 0 and fn == 0x09):
            orden.append(a + 4)
            dst = ((a & 0xF0000000) | ((w & 0x03FFFFFF) << 2)) if op == 0x03 else None
            llamadas.append((a, dst, len(orden), rs if dst is None else None))
            a += 8
            continue
        # salto incondicional: beq zero,zero,T / j T -> el caso SIGUE en T
        inc = None
        if op == 0x04 and rs == 0 and rt == 0:
            inc = a + 4 + (s16(imm) << 2)
        elif op == 0x02:
            inc = (a & 0xF0000000) | ((w & 0x03FFFFFF) << 2)
        if inc is not None:
            orden.append(a + 4)
            if inc in salida:
                break
            a = inc
            continue
        orden.append(a)
        a += 4
    return orden, llamadas


def resolver(img, reg, hasta, orden, prof=0):
    """Valor simbolico de `reg` mirando orden[:hasta] hacia atras."""
    if prof > 6:
        return "?"
    for k in range(hasta - 1, -1, -1):
        a = orden[k]
        w = img.w(a)
        if escribe(w) != reg:
            continue
        op, rs, rt, rd, sa, fn, imm = campos(w)
        if op == 0x0F:
            return "0x%08X" % (imm << 16)
        if op in (0x08, 0x09):
            if rs == 0:
                return "%d" % s16(imm)
            b = resolver(img, rs, k, orden, prof + 1)
            if b.startswith("0x") and len(b) == 10:
                return "0x%08X" % ((int(b, 16) + s16(imm)) & 0xFFFFFFFF)
            return "%s%+d" % (b, s16(imm))
        if op == 0x0D and rs == 0:
            return "0x%04X" % imm
        if op in LOADS:
            b = resolver(img, rs, k, orden, prof + 1)
            if b.startswith("0x") and len(b) == 10:
                return "*(0x%08X)" % ((int(b, 16) + s16(imm)) & 0xFFFFFFFF)
            return "*(%s%+d)" % (b, s16(imm)) if s16(imm) else "*(%s)" % b
        if op == 0:
            if fn in (0x20, 0x21, 0x25, 0x2D) and rt == 0:
                return resolver(img, rs, k, orden, prof + 1)
            if fn in (0x20, 0x21, 0x2D):
                return "%s+%s" % (resolver(img, rs, k, orden, prof + 1),
                                  resolver(img, rt, k, orden, prof + 1))
            if fn == 0x00:
                return "%s<<%d" % (resolver(img, rt, k, orden, prof + 1), sa)
            return "%s(?)" % REG[rd]
        return "?"
    return SIMB.get(REG[reg], REG[reg])


ARGS = [(0, 4), (1, 5), (2, 6), (3, 7), (4, 8), (5, 9)]
NOM_ARG = ["a0", "a1", "a2", "a3", "t0", "t1"]


def analizar(img, tabla=None, fn_recorrer=None):
    """{tipo -> dict} con bloque, llamadas y argumentos resueltos."""
    tabla = tabla if tabla is not None else leer_tabla(img)
    rec = fn_recorrer or recorrer
    res = {}
    for tipo, ini in enumerate(tabla):
        if ini == SALIDA[0]:
            res[tipo] = {"bloque": None, "despachado": False, "llamadas": []}
            continue
        orden, llamadas = rec(img, ini)
        ll = []
        for a, dst, idx, rjalr in llamadas:
            args = {NOM_ARG[n]: resolver(img, r, idx, orden) for n, r in ARGS}
            if dst is None:
                args["_via"] = resolver(img, rjalr, idx, orden)
            ll.append({"sitio": "0x%08X" % a,
                       "handler": ("FUN_%08x" % dst) if dst else None,
                       "virtual": dst is None, "args": args})
        res[tipo] = {"bloque": "0x%08X" % ini, "despachado": True,
                     "instrucciones": len(orden), "llamadas": ll}
    return res


# --------------------------------------------------------------------------
# las tres coordenadas
# --------------------------------------------------------------------------
import re

RE_ARRAY = re.compile(r"^\*\((.+)<<2\+(.+)\)$")
RE_P1 = re.compile(r"^\*\(P1\+(\d+)\)$")
RE_ULT_OFF = re.compile(r"\+(\d+)\)$")


def coordenadas(ll):
    """(destino, contador, accion) legibles de una llamada.

    En las llamadas VIRTUALES a0 no es el objeto sino `handle + ajuste`: el
    handle esta en a3. Mirar a0 ahi hace que dos tipos del mismo array parezcan
    de arrays distintos, que es justo lo contrario de lo que la coordenada
    tiene que decir."""
    ref = ll["args"]["a3"] if ll["virtual"] else ll["args"]["a0"]
    dest, cont = ref, None
    m = RE_ARRAY.match(ref)
    if m:
        idx, base = m.group(1), m.group(2)
        mp = RE_P1.match(base)
        dest = ("P1+0x%02X" % int(mp.group(1))) if mp else base
        cont = idx[2:-1] if idx.startswith("*(") and idx.endswith(")") else idx
    if ll["virtual"]:
        via = ll["args"].get("_via", "?")
        m = RE_ULT_OFF.search(via)
        acc = ("vtable+0x%02X" % int(m.group(1))) if m else "virtual"
    else:
        acc = ll["handler"]
    return dest, cont, acc


def cmd_mapa(img, salida_json=None):
    res = analizar(img)
    filas = []
    print("%-5s %-10s %-18s %-10s %-26s %s"
          % ("tipo", "bloque", "destino (a0)", "contador", "accion", "args"))
    print("-" * 122)
    for tipo in range(N_CASOS):
        d = res[tipo]
        if not d["despachado"]:
            print("0x%02X  (no despachado -- cae en el bloque por defecto)" % tipo)
            continue
        for ll in d["llamadas"]:
            dest, cont, acc = coordenadas(ll)
            resto = " ".join("%s=%s" % (k, v) for k, v in ll["args"].items()
                             if k in ("a1", "a2", "a3") and v not in ("a1", "a2", "a3"))
            print("0x%02X  %-10s %-18s %-10s %-26s %s"
                  % (tipo, d["bloque"], dest, cont or "-", acc, resto))
            filas.append({"tipo": "0x%02X" % tipo, "bloque": d["bloque"],
                          "destino": dest, "contador": cont, "accion": acc,
                          "sitio": ll["sitio"], "args": ll["args"]})
    if salida_json:
        ruta = salida_json if os.path.isabs(salida_json) else os.path.join(RAIZ, salida_json)
        with open(ruta, "w", encoding="utf-8") as f:
            json.dump({"_que_es": "sitio de llamada de cada tipo en FUN_0015ef48",
                       "_evidencia": "LECTURA de instrucciones sobre SLUS_213.76",
                       "casos": filas}, f, indent=2, ensure_ascii=False)
        print("\nescrito: %s" % ruta)
    return 0


def cmd_familias(img):
    res = analizar(img)
    fam = {}
    for tipo in range(N_CASOS):
        if not res[tipo]["despachado"]:
            continue
        for ll in res[tipo]["llamadas"]:
            dest, cont, acc = coordenadas(ll)
            fam.setdefault((dest, cont), []).append("0x%02X" % tipo)
    print("FAMILIAS -- mismo destino y mismo contador = mismo subsistema")
    print("%-18s %-10s %3s  %s" % ("destino", "contador", "n", "tipos"))
    print("-" * 104)
    for (dest, cont), tipos in sorted(fam.items(), key=lambda x: (-len(set(x[1])), x[0][0])):
        u = sorted(set(tipos))
        print("%-18s %-10s %3d  %s" % (dest, cont or "-", len(u), " ".join(u)))
    return 0


RE_P1_ARG = re.compile(r"\*\(P1(?:\+(\d+))?\)")
CASO_CIERRE = 0x35   # su bloque llama UNA vez por array: es la segunda derivacion


def inventario_arrays(img, res=None):
    """(por_casos, por_el_0x35) -- los offsets de P1 que son arrays de handles,
    derivados por dos caminos independientes sobre el mismo dispatcher."""
    res = res if res is not None else analizar(img)
    d1, d2 = set(), set()
    for t in range(N_CASOS):
        if not res[t]["despachado"]:
            continue
        for ll in res[t]["llamadas"]:
            if t == CASO_CIERRE:
                for v in ll["args"].values():
                    for m in RE_P1_ARG.finditer(v):
                        d2.add(int(m.group(1) or 0))
            else:
                dest, cont, acc = coordenadas(ll)
                if dest.startswith("P1+0x"):
                    d1.add(int(dest[5:], 16))
                elif dest == "*(P1)":
                    d1.add(0)
    return d1, d2


def cmd_arrays(img):
    d1, d2 = inventario_arrays(img)
    print("ARRAYS DE HANDLES DE P1 -- dos derivaciones independientes")
    print("  1) offsets usados por los casos individuales : %2d  %s"
          % (len(d1), " ".join("0x%02X" % x for x in sorted(d1))))
    print("  2) offsets recorridos por el bloque del 0x%02X : %2d  %s"
          % (CASO_CIERRE, len(d2), " ".join("0x%02X" % x for x in sorted(d2))))
    print("  coinciden: %d de %d   solo en el 0x%02X: %s"
          % (len(d1 & d2), len(d1), CASO_CIERRE,
             " ".join("0x%02X" % x for x in sorted(d2 - d1)) or "-"))
    return 0


def cmd_caso(img, tipo):
    ini = leer_tabla(img)[tipo]
    if ini == SALIDA[0]:
        print("tipo 0x%02X: no despachado (cae en el bloque por defecto 0x%08X)"
              % (tipo, ini))
        return 0
    orden, llamadas = recorrer(img, ini)
    print("tipo 0x%02X  bloque 0x%08X  %d instrucciones (ORDEN DE EJECUCION)"
          % (tipo, ini, len(orden)))
    for a in orden:
        print("  %08X  %08X" % (a, img.w(a)))
    print()
    for a, dst, idx, rjalr in llamadas:
        print("  llamada en %08X -> %s"
              % (a, ("FUN_%08x" % dst) if dst else ("VIRTUAL por %s" % REG[rjalr])))
        for n, r in ARGS:
            print("     %s = %s" % (NOM_ARG[n], resolver(img, r, idx, orden)))
    return 0


# --------------------------------------------------------------------------
# autotest -- la alarma se prueba ROMPIENDOLA (regla 3 del perfil)
# --------------------------------------------------------------------------
def _recorrer_ciego(img, ini, fin=FIN, salida=SALIDA):
    """La version BUGGY que tuvo esta herramienta antes: recorre por
    direcciones crecientes y corta en el primer salto incondicional. Existe
    solo para el sabotaje (b)."""
    orden, llamadas = [], []
    a = ini
    while FUN <= a < fin:
        w = img.w(a)
        op, rs, rt, rd, sa, fn, imm = campos(w)
        if op == 0x03 or (op == 0 and fn == 0x09):
            orden.append(a + 4)
            dst = ((a & 0xF0000000) | ((w & 0x03FFFFFF) << 2)) if op == 0x03 else None
            llamadas.append((a, dst, len(orden), rs if dst is None else None))
            a += 8
            continue
        if op == 0x04 and rs == 0 and rt == 0:
            break
        orden.append(a)
        a += 4
    return orden, llamadas


def autotest():
    img = Imagen()
    fallas = 0
    res = analizar(img)

    print("== casos confirmados por otra via ==")

    # (1) el 0x2D tiene que dar la MISMA base del registro de fisica que se
    #     midio el 2026-08-28 desensamblando a mano: *(0x0040F4D4) + 0xA48
    ok = (res[0x2D]["llamadas"] and
          res[0x2D]["llamadas"][0]["handler"] == "FUN_00175980" and
          res[0x2D]["llamadas"][0]["args"]["a0"] == "*(0x0040F4D4)+2632")
    print("  %s  0x2D -> FUN_00175980(*(0x0040F4D4)+0xA48)   [bitacora (37)]"
          % ("OK " if ok else "MAL"))
    if not ok:
        fallas += 1
        print("       da: %s" % res[0x2D]["llamadas"])

    # (2) el 0x0A tiene que llamar a FUN_00138c40, que la kb da por confirmado
    hs = [l["handler"] for l in res[0x0A]["llamadas"]]
    ok = "FUN_00138c40" in hs
    print("  %s  0x0A -> FUN_00138c40   [kb: spawn de personaje, confirmado]"
          % ("OK " if ok else "MAL"))
    if not ok:
        fallas += 1
        print("       da: %s" % hs)

    # (3) los tipos 0x03..0x09 comparten bloque (fall-through) y handler
    bloques = {res[t]["bloque"] for t in range(0x03, 0x0A)}
    hs = {res[t]["llamadas"][0]["handler"] for t in range(0x03, 0x0A)}
    ok = len(bloques) == 1 and hs == {"FUN_00174430"}
    print("  %s  0x03-0x09 comparten bloque y llaman FUN_00174430   [kb]"
          % ("OK " if ok else "MAL"))
    if not ok:
        fallas += 1

    # (4) 0x01, 0x02 y 0x33 estan EN LOS DATOS pero NO se despachan
    ok = not any(res[t]["despachado"] for t in (0x01, 0x02, 0x33))
    print("  %s  0x01/0x02/0x33 no despachados   [kb: tipos_en_datos_sin_entrada]"
          % ("OK " if ok else "MAL"))
    if not ok:
        fallas += 1

    # (5) la cola virtual: 0x0B y 0x0C comparten array y contador, metodo NO
    d0b, c0b, a0b = coordenadas(res[0x0B]["llamadas"][0])
    d0c, c0c, a0c = coordenadas(res[0x0C]["llamadas"][0])
    ok = (d0b == d0c and c0b == c0c and a0b != a0c
          and res[0x0B]["llamadas"][0]["virtual"])
    print("  %s  0x0B y 0x0C: mismo array y contador, metodo virtual DISTINTO"
          % ("OK " if ok else "MAL"))
    if not ok:
        fallas += 1
        print("       0x0B: %s|%s|%s   0x0C: %s|%s|%s" % (d0b, c0b, a0b, d0c, c0c, a0c))

    # (6) DOBLE CONTROL del inventario de arrays: los offsets de P1 que usan los
    #     casos individuales tienen que ser exactamente los que recorre el 0x35,
    #     que llama una vez por array. Son dos lecturas independientes.
    d1, d2 = inventario_arrays(img, res)
    ok = bool(d1) and d1 <= d2
    print("  %s  inventario de arrays: %d por casos, %d por el 0x35, %d comunes"
          % ("OK " if ok else "MAL", len(d1), len(d2), len(d1 & d2)))
    if not ok:
        fallas += 1
        print("       solo en los casos: %s" % sorted(d1 - d2))

    print()
    print("== sabotaje: el autotest tiene que ponerse en rojo ==")

    # (a) tabla de saltos corrida una entrada
    t_mal = leer_tabla(img)[1:] + [SALIDA[0]]
    r_a = analizar(img, tabla=t_mal)
    det = not (r_a[0x2D]["llamadas"] and
               r_a[0x2D]["llamadas"][0]["handler"] == "FUN_00175980")
    print("  %s  (a) tabla de saltos corrida una entrada -> %s"
          % ("OK " if det else "MAL", "lo detecta" if det else "NO lo detecta"))
    if not det:
        fallas += 1

    # (b) recorrido que NO sigue los saltos incondicionales: es el bug que esta
    #     herramienta tuvo de verdad, y pierde los 10 casos de la cola virtual
    r_b = analizar(img, fn_recorrer=_recorrer_ciego)
    ciegos = [t for t in range(N_CASOS)
              if res[t]["despachado"] and res[t]["llamadas"] and not r_b[t]["llamadas"]]
    det = 0x0B in ciegos
    print("  %s  (b) recorrido que no sigue saltos -> %s (%d casos)"
          % ("OK " if det else "MAL",
             "pierde el 0x0B" if det else "NO lo detecta", len(ciegos)))
    if not det:
        fallas += 1

    # (c) slice sin el delay slot: el 0x2D pierde el +0xA48, que esta JUSTO ahi
    orden, llam = recorrer(img, leer_tabla(img)[0x2D])
    a, dst, idx, _ = llam[0]
    sin_delay = resolver(img, 4, idx - 1, orden)
    det = sin_delay != "*(0x0040F4D4)+2632"
    print("  %s  (c) slice sin el delay slot -> %s (%s)"
          % ("OK " if det else "MAL",
             "lo detecta" if det else "NO lo detecta", sin_delay))
    if not det:
        fallas += 1

    # (d) mapeo del ELF corrido 4 bytes -> la tabla deja de caer adentro
    t_d = leer_tabla(Imagen(text_off=TEXT_OFF + 4))
    det = not all(FUN <= x < FIN for x in t_d)
    print("  %s  (d) mapeo del ELF corrido 4 B -> %s"
          % ("OK " if det else "MAL", "lo detecta" if det else "NO lo detecta"))
    if not det:
        fallas += 1

    print()
    if fallas:
        print("AUTOTEST EN ROJO: %d falla(s)" % fallas)
        return 1
    print("AUTOTEST OK: 6 casos confirmados y 4 sabotajes detectados")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("mapa")
    p.add_argument("--json")
    sub.add_parser("familias")
    sub.add_parser("arrays")
    p = sub.add_parser("caso")
    p.add_argument("tipo")
    sub.add_parser("tabla")
    sub.add_parser("autotest")
    a = ap.parse_args()

    if a.cmd == "autotest":
        return autotest()
    img = Imagen()
    if a.cmd == "mapa":
        return cmd_mapa(img, a.json)
    if a.cmd == "familias":
        return cmd_familias(img)
    if a.cmd == "arrays":
        return cmd_arrays(img)
    if a.cmd == "caso":
        return cmd_caso(img, int(a.tipo, 16))
    for i, t in enumerate(leer_tabla(img)):
        print("  0x%02X -> 0x%08X%s" % (i, t, "   (default)" if t == SALIDA[0] else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
