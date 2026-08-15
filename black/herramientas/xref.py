#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
xref.py — referencias cruzadas sobre un volcado de la RAM del EE.

PARA QUÉ
    Una vez que sabés DÓNDE vive un dato, falta saber QUIÉN lo toca. El
    camino obvio es un breakpoint de escritura en el debugger; este módulo
    hace la parte que se puede hacer en frío, sobre un volcado ya guardado:
    sin PCSX2 abierto, sin pausar el juego y sin riesgo de crashear nada.

    Contesta cuatro preguntas, en el orden en que conviene hacerlas:

      absoluto  ¿hay código que arme esta dirección literalmente?
                (lui+addiu / lui+ori / la dirección como palabra suelta)
                Si da CERO, el dato no es un global: se llega por puntero.

      punteros  ¿qué direcciones cercanas y por debajo aparecen como valor
                en memoria? Son candidatas a ser la BASE del objeto, y la
                distancia hasta el dato es el offset del campo.

      stores    ¿qué instrucciones guardan en <base + offset>? Con --fpu
                filtra por las que tienen una resta o suma flotante cerca,
                que es la forma de una rutina de daño o de curación.

      mapa      ¿dónde vive el código y dónde los datos? Histograma de las
                páginas que el código direcciona, más densidad de opcodes
                válidos por página.

CÓMO SE CONSIGUE EL VOLCADO
    python herramientas/estado.py ultimo
    python herramientas/estado.py extraer "<ruta.p2s>" volcados/ee.bin
    (o `pine.py volcar` si querés un rango en vivo)

LÍMITE
    Esto encuentra CANDIDATOS y descarta hipótesis; no confirma nada. Un
    `swc1` que guarda en +0x28 con un `sub.s` al lado es una buena apuesta,
    no una rutina de daño confirmada. Confirmar sigue siendo ver el efecto.

CLI
    python xref.py absoluto 0x005A8DA8 volcados/ee.bin
    python xref.py punteros 0x005A8DA8 volcados/ee.bin --ventana 0x800
    python xref.py stores   0x28       volcados/ee.bin --fpu
    python xref.py mapa                volcados/ee.bin
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from mips import desensamblar  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402

try:
    import numpy as _np
except ImportError:  # numpy es opcional en todo el proyecto
    _np = None

# opcodes de carga/guardado que llevan offset(base)
OPS_STORE = {0x28: "sb", 0x29: "sh", 0x2B: "sw", 0x3F: "sd",
             0x39: "swc1", 0x1F: "sq"}
OPS_LOAD = {0x20: "lb", 0x21: "lh", 0x23: "lw", 0x24: "lbu",
            0x25: "lhu", 0x27: "lwu", 0x37: "ld", 0x31: "lwc1", 0x1E: "lq"}
OPS_MEM = {**OPS_STORE, **OPS_LOAD}

LUI = 0x0F
ADDIU = 0x09
ORI = 0x0D


def cargar(ruta: str, base: int) -> tuple[bytes, "object"]:
    """Devuelve (bytes, vector de palabras). El vector es numpy si está."""
    datos = Path(ruta).read_bytes()
    if len(datos) % 4:
        datos = datos[: len(datos) - (len(datos) % 4)]
    if _np is not None:
        palabras = _np.frombuffer(datos, dtype="<u4")
    else:
        palabras = struct.unpack("<%dI" % (len(datos) // 4), datos)
    print("  volcado: %s  (%s MB, base 0x%08X)"
          % (ruta, len(datos) // (1024 * 1024), base))
    return datos, palabras


def _dec(w: int) -> tuple[int, int, int, int]:
    """(opcode, rs, rt, inmediato sin signo)"""
    return w >> 26, (w >> 21) & 0x1F, (w >> 16) & 0x1F, w & 0xFFFF


def _s16(v: int) -> int:
    return v - 0x10000 if v & 0x8000 else v


def _indices(palabras, prueba) -> list[int]:
    """Índices de palabra que cumplen `prueba(w)`."""
    return [i for i, w in enumerate(palabras) if prueba(int(w))]


def cmd_absoluto(args) -> int:
    _, palabras = cargar(args.volcado, args.base)
    A = args.direccion
    lo = A & 0xFFFF
    hi_ori = A >> 16                       # lui+ori: el bajo va sin signo
    hi_addiu = (A + 0x8000) >> 16          # lui+addiu: el bajo va con signo
    n = len(palabras)

    print("\n  buscando 0x%08X" % A)
    print("    lui+ori   -> lui _,0x%04X  +  ori _,_,0x%04X" % (hi_ori, lo))
    print("    lui+addiu -> lui _,0x%04X  +  addiu _,_,%d" % (hi_addiu, _s16(lo)))
    print("    memoria   -> lui _,0x%04X  +  <ld/st> _,%d(_)" % (hi_addiu, _s16(lo)))

    luis = {}
    for i in range(n):
        w = int(palabras[i])
        op, rs, rt, imm = _dec(w)
        if op == LUI and rs == 0 and imm in (hi_ori, hi_addiu):
            luis.setdefault(imm, []).append((i, rt))

    total = sum(len(v) for v in luis.values())
    print("\n  instrucciones 'lui' a esas páginas: %d" % total)

    hallazgos = []
    for imm, sitios in luis.items():
        for i, reg in sitios:
            for j in range(i + 1, min(i + 1 + args.radio, n)):
                w2 = int(palabras[j])
                op2, rs2, rt2, imm2 = _dec(w2)
                if rs2 != reg:
                    continue
                casa = ((op2 == ORI and imm == hi_ori and imm2 == lo)
                        or (op2 == ADDIU and imm == hi_addiu and imm2 == lo)
                        or (op2 in OPS_MEM and imm == hi_addiu and imm2 == lo))
                if casa:
                    hallazgos.append((i * 4 + args.base, j * 4 + args.base, w2))
                    break
                if op2 == LUI and rt2 == reg:
                    break  # el registro se pisó: se corta la cadena

    print("  pares completos que arman la dirección: %d" % len(hallazgos))
    for a_lui, a_par, w2 in hallazgos[: args.max]:
        print("    0x%08X  lui ... -> 0x%08X  %s"
              % (a_lui, a_par, desensamblar(w2, a_par)))

    literales = [i * 4 + args.base for i in range(n) if int(palabras[i]) == A]
    print("\n  la dirección como palabra suelta en memoria: %d" % len(literales))
    for a in literales[: args.max]:
        print("    0x%08X" % a)

    if not hallazgos and not literales:
        print("\n  NADA. El dato no se direcciona por absoluto ni figura como")
        print("  puntero directo. Casi seguro es un CAMPO de un objeto: probá")
        print("  'xref.py punteros' para encontrar la base.")
    return 0


def cmd_punteros(args) -> int:
    _, palabras = cargar(args.volcado, args.base)
    A = args.direccion
    piso = A - args.ventana
    cuenta: dict[int, list[int]] = {}
    for i, w in enumerate(palabras):
        w = int(w)
        if piso <= w <= A and w % 4 == 0:
            cuenta.setdefault(w, []).append(i * 4 + args.base)

    print("\n  candidatos a BASE del objeto que contiene 0x%08X" % A)
    print("  (valores en [0x%08X, 0x%08X] que aparecen como palabra)\n" % (piso, A))
    print("  %-12s %-6s %-9s %s" % ("base", "veces", "offset", "primeros tenedores"))
    orden = sorted(cuenta.items(), key=lambda kv: -len(kv[1]))
    for val, sitios in orden[: args.max]:
        print("  0x%08X   x%-5d +0x%03X    %s"
              % (val, len(sitios), A - val,
                 " ".join("0x%08X" % s for s in sitios[:4])))
    if not orden:
        print("  ninguno. Ampliá --ventana.")
    return 0


def cmd_stores(args) -> int:
    _, palabras = cargar(args.volcado, args.base)
    off = args.offset & 0xFFFF
    n = len(palabras)

    def es_cop1_s(w: int, func: int) -> bool:
        return (w >> 26) == 0x11 and ((w >> 21) & 0x1F) == 16 and (w & 0x3F) == func

    cand = []
    for i in range(n):
        w = int(palabras[i])
        op, rs, rt, imm = _dec(w)
        if imm == off and op in OPS_STORE:
            cand.append((i, op, rs, rt, w))

    por_op: dict[str, int] = {}
    for _, op, _, _, _ in cand:
        por_op[OPS_STORE[op]] = por_op.get(OPS_STORE[op], 0) + 1
    print("\n  stores con offset 0x%04X: %d  (%s)"
          % (off, len(cand),
             ", ".join("%s=%d" % kv for kv in sorted(por_op.items())) or "-"))

    if args.fpu:
        filtrados = []
        for i, op, rs, rt, w in cand:
            lo, hi = max(0, i - args.radio), min(n, i + args.radio + 1)
            subs = [j for j in range(lo, hi) if es_cop1_s(int(palabras[j]), 0x01)]
            adds = [j for j in range(lo, hi) if es_cop1_s(int(palabras[j]), 0x00)]
            if subs or adds:
                filtrados.append((i, op, rs, rt, w, subs, adds))
        print("  con sub.s/add.s a <=%d instrucciones: %d"
              % (args.radio, len(filtrados)))
        print()
        for i, op, rs, rt, w, subs, adds in filtrados[: args.max]:
            a = i * 4 + args.base
            print("    0x%08X  %-28s sub.s@%s  add.s@%s"
                  % (a, desensamblar(w, a),
                     ",".join("%+d" % (j - i) for j in subs) or "-",
                     ",".join("%+d" % (j - i) for j in adds) or "-"))
    else:
        print()
        for i, op, rs, rt, w in cand[: args.max]:
            a = i * 4 + args.base
            print("    0x%08X  %s" % (a, desensamblar(w, a)))
    return 0


def cmd_mapa(args) -> int:
    _, palabras = cargar(args.volcado, args.base)
    n = len(palabras)

    hist: dict[int, int] = {}
    for w in palabras:
        w = int(w)
        if (w >> 26) == LUI and ((w >> 21) & 0x1F) == 0:
            imm = w & 0xFFFF
            hist[imm] = hist.get(imm, 0) + 1

    print("\n  páginas más direccionadas por el código ('lui _,0xHHHH')")
    print("  las bajas (0x00xx) son punteros a RAM; las altas suelen ser")
    print("  constantes flotantes (0x3F80 = 1.0f) o máscaras.\n")
    for imm, c in sorted(hist.items(), key=lambda kv: -kv[1])[: args.max]:
        clase = "RAM" if imm < 0x0200 else "constante/máscara"
        print("    lui _,0x%04X  x%-6d  %s -> 0x%04X0000" % (imm, c, clase, imm))

    # El relleno a cero NO cuenta como instrucción: si se cuenta, media RAM
    # sin usar pasa por código y el mapa no sirve para nada. La densidad se
    # mide sobre las palabras no nulas, y una página que es casi toda ceros
    # se descarta antes de mirarla.
    print("\n  densidad de opcodes conocidos por página de 64 KB")
    print("  (sobre palabras no nulas; >=%d%% = código)\n" % args.umbral)
    pag = 0x10000 // 4
    OPS_CODIGO = set(OPS_MEM) | {LUI, ADDIU, ORI, 0x02, 0x03, 0x04, 0x05, 0x11}
    tramos = []
    for p in range(0, n, pag):
        bloque = palabras[p : p + pag]
        if len(bloque) < pag:
            break
        vivos = no_nulas = 0
        for w in bloque:
            w = int(w)
            if w == 0:
                continue
            no_nulas += 1
            op = w >> 26
            if op == 0 or op in OPS_CODIGO:
                vivos += 1
        if no_nulas < pag // 4:          # página casi vacía: no es código
            tramos.append((p * 4 + args.base, 0))
        else:
            tramos.append((p * 4 + args.base, vivos * 100 // no_nulas))

    inicio = None
    for dirp, pct in tramos:
        if pct >= args.umbral and inicio is None:
            inicio = dirp
        elif pct < args.umbral and inicio is not None:
            print("    código: 0x%08X - 0x%08X" % (inicio, dirp - 1))
            inicio = None
    if inicio is not None:
        print("    código: 0x%08X - 0x%08X" % (inicio, tramos[-1][0] + 0xFFFF))
    return 0


def _entero(t: str) -> int:
    return int(t, 0)


def main(argv=None) -> int:
    tolerar_salida_pobre()
    # Las opciones comunes se heredan por subcomando a propósito: si sólo
    # vivieran en el parser de arriba habría que escribirlas ANTES del
    # subcomando, que es exactamente el orden que nadie recuerda.
    comun = argparse.ArgumentParser(add_help=False)
    comun.add_argument("--base", type=_entero, default=0,
                       help="dirección EE del primer byte del volcado (default 0)")
    comun.add_argument("--max", type=int, default=25,
                       help="cuántos resultados listar")

    p = argparse.ArgumentParser(
        parents=[comun],
        description="Referencias cruzadas sobre un volcado de RAM del EE")
    sub = p.add_subparsers(dest="cmd", required=True)

    p_a = sub.add_parser("absoluto", parents=[comun],
                         help="¿hay código que arme esta dirección literal?")
    p_a.add_argument("direccion", type=_entero)
    p_a.add_argument("volcado")
    p_a.add_argument("--radio", type=int, default=8,
                     help="instrucciones a mirar tras el lui")
    p_a.set_defaults(func=cmd_absoluto)

    p_p = sub.add_parser("punteros", parents=[comun],
                         help="candidatos a base del objeto que contiene la dirección")
    p_p.add_argument("direccion", type=_entero)
    p_p.add_argument("volcado")
    p_p.add_argument("--ventana", type=_entero, default=0x800,
                     help="cuánto mirar por debajo de la dirección")
    p_p.set_defaults(func=cmd_punteros)

    p_s = sub.add_parser("stores", parents=[comun],
                         help="instrucciones que guardan en <base+offset>")
    p_s.add_argument("offset", type=_entero)
    p_s.add_argument("volcado")
    p_s.add_argument("--fpu", action="store_true",
                     help="sólo las que tienen sub.s/add.s cerca")
    p_s.add_argument("--radio", type=int, default=12,
                     help="ventana en instrucciones para --fpu")
    p_s.set_defaults(func=cmd_stores)

    p_m = sub.add_parser("mapa", parents=[comun],
                         help="dónde vive el código y dónde los datos")
    p_m.add_argument("volcado")
    p_m.add_argument("--umbral", type=int, default=88,
                     help="%% de opcodes conocidos para llamarlo código. "
                          "Es una heurística GRUESA: los datos comprimidos y "
                          "las mallas 3D pasan el filtro. Sirve para acotar "
                          "dónde buscar, no como mapa de secciones.")
    p_m.set_defaults(func=cmd_mapa)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
