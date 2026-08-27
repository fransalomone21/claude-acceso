#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
kynapse.py — reconstruir la jerarquía de clases del middleware de IA, con
nombres reales, sin adivinar un solo offset.

DE DÓNDE SALE
    BLACK usa **Kynapse** (Kynogon) como IA, y Kynapse trae su propio sistema
    de reflexión: cada clase tiene un objeto `CMetaClass` estático que se
    registra una sola vez, con su nombre mangleado y un puntero a la metaclase
    de su padre. El accesor tiene siempre la misma forma:

        if (DAT_0049aad8 == 0) {                     // aún sin inicializar
            FUN_00389f90();                          // fuerza al padre
            FUN_00370168(0x49aad8,                   // la metaclase de ESTA clase
                         0x405310,                   // "Q24Kaim15CEntityMaxSpeed"
                         0x49aa58);                  // la metaclase del PADRE
        }
        return 0x49aad8;

    O sea que el binario contiene, escrito, el árbol de clases completo. No
    hace falta inferirlo: hay que leerlo.

POR QUÉ IMPORTA MÁS QUE MAPEAR OFFSETS A MANO
    Las clases se llaman `CEntityVisualAcuteness`, `CEntityHearingAcuteness`,
    `CEntityMaxSpeed`, `CEntityTeamSide`, `CShooterAgent`… Son **los tunables
    con los que la IA percibe y decide**, con su nombre puesto por quien los
    escribió. Cada metaclase vive en una dirección FIJA de `.bss`, así que
    sirve de ancla para encontrar en RAM los objetos de esa clase.

CÓMO LOS LEE
    Se busca cada `jal` al registrador y se simulan las instrucciones previas
    para reconstruir `$a0`, `$a1` y `$a2`. Se simula de verdad —`lui`, `addiu`,
    `ori`, `move`— porque en MIPS una constante de 32 bits no está en ninguna
    instrucción sola. **Y se incluye la ranura de retardo**: la instrucción
    que sigue al `jal` se ejecuta ANTES del salto, y muy seguido es justo la
    que carga el tercer argumento.

CLI
    python herramientas/kynapse.py clases <ELF> --base 0xFF000
    python herramientas/kynapse.py clases <ELF> --base 0xFF000 --json kb/kynapse.json
    python herramientas/kynapse.py arbol kb/kynapse.json
"""

from __future__ import annotations

import argparse
import json
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402

REGISTRADOR = 0x00370168      # FUN_00370168(metaclase, nombre, padre)
VENTANA = 40                  # instrucciones hacia atrás que se simulan

LUI, ADDIU, ORI, ADDI = 0x0F, 0x09, 0x0D, 0x08
ESPECIAL = 0x00
ADDU, OR_, DADDU = 0x21, 0x25, 0x2D
A0, A1, A2 = 4, 5, 6


def _s16(v: int) -> int:
    return v - 0x10000 if v & 0x8000 else v


def cadena_en(d: bytes, base: int, direccion: int, tope: int = 96) -> str | None:
    o = direccion - base
    if not (0 <= o < len(d)):
        return None
    fin = d.find(b"\x00", o, o + tope)
    if fin < 0:
        return None
    s = d[o:fin]
    if len(s) < 3 or not all(0x20 <= b <= 0x7E for b in s):
        return None
    return s.decode("ascii")


def desmanglear(s: str) -> str:
    """`Q24Kaim15CEntityMaxSpeed` -> `Kaim::CEntityMaxSpeed`.

    Sólo el subconjunto de g++ 2.x que aparece acá: nombres calificados `Q<n>`
    y longitudes en decimal. Lo que no encaje se devuelve tal cual, que es
    mejor que devolver algo inventado."""
    i = 0
    partes = []
    n_comp = 1
    if s.startswith("Q") and len(s) > 1 and s[1].isdigit():
        n_comp = int(s[1])
        i = 2
    for _ in range(n_comp):
        j = i
        while j < len(s) and s[j].isdigit():
            j += 1
        if j == i:
            return s
        largo = int(s[i:j])
        partes.append(s[j:j + largo])
        i = j + largo
    resto = s[i:]
    salida = "::".join(partes)
    return salida + ("<" + resto + ">" if resto else "")


def simular(pal, i_llamada: int, base: int) -> dict[int, int]:
    """Valor de los registros enteros al entrar a la llamada de `i_llamada`.

    Se arranca `VENTANA` instrucciones antes y se avanza. Se incluye
    `i_llamada + 1`: la ranura de retardo se ejecuta antes del salto."""
    reg: dict[int, int] = {}
    ini = max(0, i_llamada - VENTANA)
    for k in list(range(ini, i_llamada)) + [i_llamada + 1]:
        if k >= len(pal):
            break
        w = int(pal[k])
        op, rs, rt = w >> 26, (w >> 21) & 0x1F, (w >> 16) & 0x1F
        imm = w & 0xFFFF
        if op == LUI:
            reg[rt] = (imm << 16) & 0xFFFFFFFF
        elif op in (ADDIU, ADDI):
            if rs == 0:
                reg[rt] = _s16(imm) & 0xFFFFFFFF
            elif rs in reg:
                reg[rt] = (reg[rs] + _s16(imm)) & 0xFFFFFFFF
            else:
                reg.pop(rt, None)
        elif op == ORI:
            if rs == 0:
                reg[rt] = imm
            elif rs in reg:
                reg[rt] = reg[rs] | imm
            else:
                reg.pop(rt, None)
        elif op == ESPECIAL and (w & 0x3F) in (ADDU, OR_, DADDU):
            rd = (w >> 11) & 0x1F
            fuente = rs if rt == 0 else (rt if rs == 0 else None)
            if fuente is not None and fuente in reg:
                reg[rd] = reg[fuente]
            else:
                reg.pop(rd, None)
        elif op == ESPECIAL:
            reg.pop((w >> 11) & 0x1F, None)
        elif op in (0x23, 0x24, 0x25, 0x27, 0x37, 0x0C, 0x0E, 0x0A, 0x0B):
            reg.pop(rt, None)          # cargas y demás: el destino se ensucia
    return reg


def cmd_clases(args) -> int:
    d = Path(args.elf).read_bytes()
    n = len(d) // 4
    pal = struct.unpack("<%dI" % n, d[: n * 4])
    base = args.base

    objetivo = (args.registrador >> 2) & 0x03FFFFFF
    sitios = [i for i in range(n)
              if (int(pal[i]) >> 26) == 0x03
              and (int(pal[i]) & 0x03FFFFFF) == objetivo]
    print("\n  ELF: %s   base 0x%X" % (args.elf, base))
    print("  registrador 0x%08X   llamadas encontradas: %d"
          % (args.registrador, len(sitios)))

    clases = []
    sin_nombre = 0
    for i in sitios:
        reg = simular(pal, i, base)
        meta, nom, padre = reg.get(A0), reg.get(A1), reg.get(A2)
        texto = cadena_en(d, base, nom) if nom else None
        if texto is None:
            sin_nombre += 1
            continue
        clases.append({
            "nombre": desmanglear(texto),
            "mangleado": texto,
            "metaclase": "0x%08X" % meta if meta else None,
            "padre": "0x%08X" % padre if padre else None,
            "sitio": "0x%08X" % (i * 4 + base),
        })

    print("  clases con nombre resuelto: %d   sin resolver: %d"
          % (len(clases), sin_nombre))

    por_meta = {c["metaclase"]: c["nombre"] for c in clases if c["metaclase"]}
    for c in clases:
        c["padre_nombre"] = por_meta.get(c["padre"])

    huerfanos = sum(1 for c in clases if c["padre"] and not c["padre_nombre"])
    print("  con padre identificado: %d   con padre desconocido: %d"
          % (sum(1 for c in clases if c["padre_nombre"]), huerfanos))

    if args.json:
        destino = Path(args.json)
        destino.parent.mkdir(parents=True, exist_ok=True)
        destino.write_text(json.dumps(
            {"elf": args.elf, "registrador": "0x%08X" % args.registrador,
             "clases": sorted(clases, key=lambda c: c["nombre"])},
            indent=1, ensure_ascii=False), encoding="utf-8")
        print("  escrito: %s" % destino)

    for c in sorted(clases, key=lambda c: c["nombre"])[: args.max]:
        print("    %-46s meta %s  padre %s"
              % (c["nombre"][:46], c["metaclase"], c["padre_nombre"] or c["padre"]))
    if len(clases) > args.max:
        print("    ... y %d más (--max o --json)" % (len(clases) - args.max))
    return 0


def cmd_arbol(args) -> int:
    datos = json.loads(Path(args.json).read_text(encoding="utf-8"))
    clases = datos["clases"]
    hijos: dict[str | None, list[dict]] = {}
    for c in clases:
        hijos.setdefault(c.get("padre_nombre"), []).append(c)

    def bajar(nombre: str | None, nivel: int) -> None:
        for c in sorted(hijos.get(nombre, []), key=lambda x: x["nombre"]):
            print("  %s%-40s %s" % ("   " * nivel, c["nombre"][:40],
                                    c["metaclase"]))
            bajar(c["nombre"], nivel + 1)

    print("\n  jerarquía de clases de Kynapse (%d clases)\n" % len(clases))
    bajar(None, 0)
    return 0


def cmd_instancias(args) -> int:
    """El puente entre el NOMBRE y el DATO.

    Cada metaclase vive en una dirección fija de `.bss`. Un objeto de esa
    clase la referencia —igual que el puntero de vtable en `objeto+0x10` de
    las entidades del juego—, así que buscar esa dirección como palabra
    alineada en un volcado enumera los objetos vivos de la clase.

    Lo que se informa es CUÁNTOS hay y DÓNDE. Qué campo de cada objeto es el
    valor útil sigue siendo trabajo de `estructura.py` y de escribirle para ver
    el efecto; esto acota la búsqueda de 32 MB a un puñado de direcciones."""
    datos = json.loads(Path(args.json).read_text(encoding="utf-8"))
    d = Path(args.volcado).read_bytes()

    clases = datos["clases"]
    if args.filtro:
        clases = [c for c in clases if args.filtro.lower() in c["nombre"].lower()]
    if not clases:
        print("  ninguna clase coincide con %r" % args.filtro)
        return 1

    print("\n  volcado: %s  (%s MB)" % (args.volcado, len(d) // (1 << 20)))
    print("  clases miradas: %d\n" % len(clases))
    print("  %-42s %-12s %s" % ("clase", "metaclase", "referencias en RAM"))

    con_refs = []
    for c in clases:
        if not c["metaclase"]:
            continue
        meta = int(c["metaclase"], 16)
        pat = struct.pack("<I", meta)
        sitios, i = [], 0
        while len(sitios) < args.tope:
            i = d.find(pat, i)
            if i < 0:
                break
            if i % 4 == 0:
                sitios.append(i)
            i += 4
        # el propio objeto de metaclase y su vecindario en .bss no cuentan:
        # lo que interesa son las referencias desde el HEAP.
        heap = [s for s in sitios if s >= args.desde]
        print("  %-42s %-12s %d  (heap: %d)  %s"
              % (c["nombre"][:42], c["metaclase"], len(sitios), len(heap),
                 " ".join("0x%08X" % s for s in heap[:3])))
        if heap:
            con_refs.append((c["nombre"], heap))

    print("\n  clases con al menos una referencia desde el heap: %d/%d"
          % (len(con_refs), len(clases)))
    if not con_refs:
        print("  Ninguna. O el volcado no es de adentro de un nivel, o los")
        print("  objetos no guardan la metaclase en un campo directo: en ese")
        print("  caso el ancla hay que buscarla en la vtable, no en el objeto.")
    return 0


def _entero(t: str) -> int:
    return int(t, 0)


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="La jerarquía de clases de la IA, leída del binario",
        formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)

    c = sub.add_parser("clases", help="extraer nombre, metaclase y padre")
    c.add_argument("elf")
    c.add_argument("--base", type=_entero, default=0xFF000,
                   help="dirección EE del primer byte (0xFF000 para el ELF)")
    c.add_argument("--registrador", type=_entero, default=REGISTRADOR)
    c.add_argument("--json")
    c.add_argument("--max", type=int, default=30)
    c.set_defaults(func=cmd_clases)

    a = sub.add_parser("arbol", help="imprimir el árbol de herencia")
    a.add_argument("json")
    a.set_defaults(func=cmd_arbol)

    i = sub.add_parser("instancias",
                       help="qué objetos de la RAM referencian cada metaclase")
    i.add_argument("json")
    i.add_argument("volcado", help="volcado de la RAM del EE, desde la dirección 0")
    i.add_argument("--filtro", help="sólo las clases cuyo nombre contenga esto")
    i.add_argument("--desde", type=_entero, default=0x00500000,
                   help="a partir de qué dirección cuenta como heap")
    i.add_argument("--tope", type=int, default=64,
                   help="cuántas referencias buscar por clase")
    i.set_defaults(func=cmd_instancias)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
