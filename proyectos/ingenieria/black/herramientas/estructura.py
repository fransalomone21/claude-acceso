#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
estructura.py — mapear una clase de entidad campo por campo, cruzando dos
fuentes independientes que por separado no alcanzan.

EL PROBLEMA
    Volcar un objeto y mirar bytes dice qué VALORES hay, no qué SIGNIFICAN.
    Desensamblar dice quién toca cada offset, pero no qué guarda. Las dos
    juntas sí: si el offset `+0x2F8` lo lee un `lwc1` del método #8 y además
    vale `100.0` en los enemigos vivos y `0.0` en los muertos, es la vida, y
    no hace falta adivinar.

LAS DOS FUENTES

    1. ESTADÍSTICA ENTRE INSTANCIAS.
       Un pool trae decenas de objetos de la misma clase. Para cada offset:
         - constante en todas  -> configuración de la clase, o padding
         - varía               -> estado por instancia
         - siempre cero        -> sin usar en este momento, o reservado
       Con 32 enemigos, un campo que vale lo mismo en los 32 y otro que vale
       algo distinto en cada uno se separan solos.

    2. CÓMO LO ACCEDE EL CÓDIGO **DE ESA CLASE**.
       No se barre el `.text` entero —eso mezcla el offset 0x10 de esta clase
       con el 0x10 de otras cincuenta—: se desensamblan **los métodos de su
       propia vtable**, que están en `vtable + 0x0C + 8n`. El opcode delata el
       tipo mejor que cualquier heurística sobre los bytes:

         lwc1 / swc1   -> f32, sin discusión
         lbu / sb      -> byte, probable bandera
         lh  / sh      -> u16
         lw  / sw      -> u32 o puntero
         lq  / sq      -> vector de 128 bits (el R5900 los usa para posiciones)

       Se descartan los accesos con base `$sp` y `$gp`: son pila y globales,
       no campos del objeto.

LÍMITE, DICHO ANTES DE QUE ALGUIEN SE ENTUSIASME
    Esto produce CANDIDATOS con tipo y con evidencia de uso. No confirma nada.
    Un campo se confirma escribiéndole y viendo el efecto. Lo que la
    herramienta da es la lista corta y ordenada de a cuáles vale la pena
    escribirles.

CLI
    python herramientas/estructura.py mapear <volcado> --vtable 0x003DCA78 --paso 0x3C0
    python herramientas/estructura.py mapear <volcado> --vtable 0x003DC5F8 --paso 0x8B0
    python herramientas/estructura.py mapear <volcado> --vtable 0x003DCA78 --paso 0x3C0 \\
        --json kb/campos-enemigo.json --todo
"""

from __future__ import annotations

import argparse
import json
import struct
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402

OFF_VTABLE = 0x10          # el puntero de clase vive en objeto+0x10, no en +0x00
VT_PRIMER_METODO = 0x0C    # kb/estructuras.json#vtable_entidad
VT_PASO = 8

RAM_INI, RAM_FIN = 0x00080000, 0x02000000
TEXT_INI, TEXT_FIN = 0x00100000, 0x00400000

# Accesos a memoria con offset(base). El valor es (nombre, ancho, es_fpu).
OPS = {
    0x20: ("lb", 1, False), 0x24: ("lbu", 1, False), 0x28: ("sb", 1, False),
    0x21: ("lh", 2, False), 0x25: ("lhu", 2, False), 0x29: ("sh", 2, False),
    0x23: ("lw", 4, False), 0x27: ("lwu", 4, False), 0x2B: ("sw", 4, False),
    0x37: ("ld", 8, False), 0x3F: ("sd", 8, False),
    0x31: ("lwc1", 4, True), 0x39: ("swc1", 4, True),
    0x1E: ("lq", 16, False), 0x1F: ("sq", 16, False),
}
REG_SP, REG_GP = 29, 28


def u32(d: bytes, a: int) -> int:
    return int.from_bytes(d[a:a + 4], "little") if 0 <= a + 4 <= len(d) else 0


def f32(d: bytes, a: int) -> float:
    return struct.unpack_from("<f", d, a)[0]


def es_puntero(v: int) -> bool:
    return RAM_INI <= v < RAM_FIN and v % 4 == 0


def es_funcion(v: int) -> bool:
    return TEXT_INI <= v < TEXT_FIN and v % 4 == 0


def f32_plausible(v: int) -> bool:
    """¿El u32 leído como f32 da un número que un juego usaría?"""
    exp = (v >> 23) & 0xFF
    if exp in (0, 0xFF):
        return False
    x = abs(struct.unpack("<f", struct.pack("<I", v))[0])
    return 1e-6 <= x <= 1e9


# ------------------------------------------------------- las dos fuentes ----

def instancias(d: bytes, vtable: int, desde: int = 0x00200000) -> list[int]:
    """Bases de los objetos cuyo +0x10 apunta a esta vtable."""
    pat = struct.pack("<I", vtable)
    bases, i = [], desde
    while True:
        i = d.find(pat, i)
        if i < 0:
            break
        if i % 4 == 0 and i - OFF_VTABLE >= 0:
            bases.append(i - OFF_VTABLE)
        i += 4
    return bases


def metodos(d: bytes, vtable: int, cuantos: int = 48) -> list[int]:
    """Direcciones de los métodos virtuales de la clase, en orden de ranura."""
    out = []
    for n in range(cuantos):
        v = u32(d, vtable + VT_PRIMER_METODO + n * VT_PASO)
        out.append(v if es_funcion(v) else 0)
    return out


def accesos_de_metodo(d: bytes, inicio: int, tope: int = 1200) -> list[tuple]:
    """[(offset, nombre_op, es_fpu)] de un método, hasta su `jr $ra`.

    Sin tabla de símbolos no hay límites de función, así que se corta en el
    primer `jr $ra` (más su ranura de retardo) o a las `tope` instrucciones.
    Cortar de más pierde campos; cortar de menos mete los de la función de al
    lado. `tope` alto y corte por `jr $ra` es el compromiso razonable."""
    out = []
    a = inicio
    for _ in range(tope):
        w = u32(d, a)
        op = w >> 26
        rs = (w >> 21) & 0x1F
        imm = w & 0xFFFF
        if imm & 0x8000:
            imm -= 0x10000
        if op in OPS and rs not in (REG_SP, REG_GP) and imm >= 0:
            nombre, _ancho, fpu = OPS[op]
            out.append((imm, nombre, fpu))
        # jr $ra = 000000 rs=31 ..... 001000
        if w == 0x03E00008:
            break
        a += 4
    return out


# ----------------------------------------------------------- el informe -----

def clasificar(valores: list[int], vtable: int) -> tuple[str, str]:
    """(tipo probable, nota) para un offset, mirando todas las instancias."""
    unicos = sorted(set(valores))
    if unicos == [0]:
        return "cero", "cero en todas"
    if all(v == vtable for v in valores):
        return "ptr_clase", "el puntero de clase"

    n_ptr = sum(1 for v in valores if es_puntero(v))
    n_f32 = sum(1 for v in valores if f32_plausible(v))
    n_chico = sum(1 for v in valores if v < 0x10000)
    n = len(valores)
    no_cero = [v for v in valores if v != 0]

    if no_cero and n_ptr >= max(1, len(no_cero) * 0.8):
        tipo = "ptr"
    elif no_cero and n_f32 >= max(1, len(no_cero) * 0.8):
        tipo = "f32"
    elif n_chico == n:
        tipo = "int_chico"
    else:
        tipo = "u32"

    if len(unicos) == 1:
        nota = "CONSTANTE en %d/%d" % (n, n)
    else:
        nota = "%d valores distintos" % len(unicos)
    return tipo, nota


def muestra(valores: list[int], tipo: str, cuantos: int = 4) -> str:
    vistos = [v for v, _ in Counter(valores).most_common(cuantos)]
    if tipo == "f32":
        def fmt(v):
            x = struct.unpack("<f", struct.pack("<I", v))[0]
            if v == 0x7F7FFFFF:
                return "FLT_MAX"
            return ("%g" % x)
        return " ".join(fmt(v) for v in vistos)
    return " ".join("0x%08X" % v for v in vistos)


def cmd_mapear(args) -> int:
    d = Path(args.volcado).read_bytes()
    print("\n  volcado : %s  (%s MB)" % (args.volcado, len(d) // (1 << 20)))
    print("  vtable  : 0x%08X   paso: 0x%X" % (args.vtable, args.paso))

    bases = instancias(d, args.vtable)
    if args.base is not None:
        bases = [args.base]
    if not bases:
        print("  no hay ni un objeto de esa clase en este volcado.")
        print("  ¿El volcado es de adentro de un nivel? ¿Arranca en la "
              "dirección 0?")
        return 1
    print("  objetos : %d   primero 0x%08X" % (len(bases), bases[0]))
    if len(bases) > 1:
        pasos = {bases[i + 1] - bases[i] for i in range(len(bases) - 1)}
        if len(pasos) == 1:
            print("  contiguos, paso 0x%X -> pool preasignado" % pasos.pop())

    ms = metodos(d, args.vtable)
    vivos = [(n, a) for n, a in enumerate(ms) if a]
    print("  métodos virtuales con código: %d" % len(vivos))

    # offset -> {(ranura, op)} y el conjunto de ops
    tocado: dict[int, set] = {}
    for n, a in vivos:
        for off, nombre, fpu in accesos_de_metodo(d, a):
            if 0 <= off < args.paso:
                tocado.setdefault(off, set()).add((n, nombre))

    filas = []
    for off in range(0, args.paso, 4):
        valores = [u32(d, b + off) for b in bases if b + off + 4 <= len(d)]
        if not valores:
            continue
        tipo, nota = clasificar(valores, args.vtable)
        accesos = tocado.get(off, set())
        # los accesos de byte y media palabra caen en offsets no múltiplos de 4
        for extra in (off + 1, off + 2, off + 3):
            accesos = accesos | tocado.get(extra, set())
        if not args.todo and tipo == "cero" and not accesos:
            continue
        filas.append({"offset": off, "tipo": tipo, "nota": nota,
                      "accesos": sorted(accesos),
                      "muestra": muestra(valores, tipo)})

    fpu = {o for o, s in tocado.items() if any(n in ("lwc1", "swc1") for _, n in s)}
    for f in filas:
        if f["offset"] in fpu and f["tipo"] in ("u32", "int_chico"):
            f["tipo"] = "f32"          # el opcode manda sobre la heurística
            f["muestra"] = muestra([u32(d, b + f["offset"]) for b in bases], "f32")

    print("\n  %-8s %-10s %-22s %-26s %s"
          % ("offset", "tipo", "constancia", "valores más comunes", "quién lo toca"))
    for f in filas:
        acc = ", ".join("m%d:%s" % (n, op) for n, op in f["accesos"][:4])
        if len(f["accesos"]) > 4:
            acc += " +%d" % (len(f["accesos"]) - 4)
        print("  +0x%-5X %-10s %-22s %-26s %s"
              % (f["offset"], f["tipo"], f["nota"], f["muestra"][:26], acc))

    print("\n  %d offsets con algo; %d los toca el código de la clase"
          % (len(filas), sum(1 for f in filas if f["accesos"])))
    print("  Esto es una lista de CANDIDATOS. Un campo se confirma "
          "escribiéndole y viendo el efecto.")

    if args.json:
        destino = Path(args.json)
        destino.parent.mkdir(parents=True, exist_ok=True)
        destino.write_text(json.dumps({
            "volcado": args.volcado,
            "vtable": "0x%08X" % args.vtable,
            "paso": "0x%X" % args.paso,
            "instancias": len(bases),
            "metodos_con_codigo": len(vivos),
            "campos": filas,
        }, indent=1, ensure_ascii=False), encoding="utf-8")
        print("  escrito: %s" % destino)
    return 0


def _cargar(ruta: str) -> dict:
    return json.loads(Path(ruta).read_text(encoding="utf-8"))


def cmd_grupos(args) -> int:
    """Campos contiguos del mismo tipo: ahí hay un vector o una matriz.

    Un `f32` suelto es un parámetro; tres seguidos son una posición; dieciséis
    seguidos con la cuarta columna repetida son una RwMatrix de RenderWare, que
    es exactamente lo que un motor de Criterion pondría adentro de una entidad.
    Detectarlos por forma ahorra mirar cientos de offsets de a uno."""
    m = _cargar(args.json)
    campos = {c["offset"]: c for c in m["campos"]}
    paso = int(m["paso"], 16) if isinstance(m["paso"], str) else m["paso"]

    corridas, actual = [], []
    for off in range(0, paso, 4):
        c = campos.get(off)
        if c and c["tipo"] == "f32":
            actual.append(c)
        else:
            if len(actual) >= args.minimo:
                corridas.append(actual)
            actual = []
    if len(actual) >= args.minimo:
        corridas.append(actual)

    print("\n  corridas de f32 contiguos en %s" % args.json)
    print("  (>= %d campos; 3 = posicion/vector, 12 o 16 = matriz)\n" % args.minimo)
    for c in corridas:
        ini, largo = c[0]["offset"], len(c)
        etiqueta = {3: "vec3", 4: "vec4", 12: "matriz 3x4", 16: "matriz 4x4"}.get(
            largo, "%d floats" % largo)
        print("  +0x%-5X .. +0x%-5X  %-12s  %s"
              % (ini, ini + largo * 4 - 4, etiqueta,
                 " | ".join(x["muestra"].split()[1] if len(x["muestra"].split()) > 1
                            else x["muestra"] for x in c[:4])))
    print("\n  %d corridas" % len(corridas))
    return 0


def cmd_comparar(args) -> int:
    """Qué comparten dos clases, offset por offset.

    Dos clases hermanas heredan de la misma base, y la base ocupa los primeros
    N bytes de las dos. Si el offset +0x2F8 es `f32` y lo toca el método #8 en
    las dos, es un campo de la base y no una coincidencia. El primer tramo
    largo donde dejan de coincidir marca dónde termina lo heredado."""
    a, b = _cargar(args.a), _cargar(args.b)
    ca = {c["offset"]: c for c in a["campos"]}
    cb = {c["offset"]: c for c in b["campos"]}
    tope = min(int(a["paso"], 16), int(b["paso"], 16))

    iguales, distintos, solo_a, solo_b = [], [], [], []
    for off in range(0, tope, 4):
        x, y = ca.get(off), cb.get(off)
        vx = x and x["tipo"] != "cero"
        vy = y and y["tipo"] != "cero"
        if vx and vy:
            (iguales if x["tipo"] == y["tipo"] else distintos).append(off)
        elif vx:
            solo_a.append(off)
        elif vy:
            solo_b.append(off)

    print("\n  A: %s   vtable %s   paso %s" % (args.a, a["vtable"], a["paso"]))
    print("  B: %s   vtable %s   paso %s" % (args.b, b["vtable"], b["paso"]))
    print("\n  offsets con dato en las dos y MISMO tipo : %d" % len(iguales))
    print("  con dato en las dos y tipo distinto      : %d" % len(distintos))
    print("  sólo en A: %d    sólo en B: %d" % (len(solo_a), len(solo_b)))

    # el tramo compartido más largo, sin cortes de más de `hueco` bytes
    mejor = actual = None
    for off in iguales:
        if actual and off - actual[1] <= args.hueco:
            actual = (actual[0], off)
        else:
            if actual and (mejor is None or actual[1] - actual[0] > mejor[1] - mejor[0]):
                mejor = actual
            actual = (off, off)
    if actual and (mejor is None or actual[1] - actual[0] > mejor[1] - mejor[0]):
        mejor = actual
    if mejor:
        print("\n  tramo compartido más largo: +0x%X .. +0x%X  (0x%X bytes)"
              % (mejor[0], mejor[1], mejor[1] - mejor[0] + 4))
        print("  -> candidato al tamaño de la clase BASE de la que las dos heredan")

    print("\n  campos compartidos que además toca el código de las DOS clases:")
    print("  %-8s %-10s %-24s %s" % ("offset", "tipo", "en A lo tocan", "en B"))
    n = 0
    for off in iguales:
        x, y = ca[off], cb[off]
        if not x["accesos"] or not y["accesos"]:
            continue
        n += 1
        if n > args.max:
            continue
        fa = ", ".join("m%d:%s" % (m_, o) for m_, o in x["accesos"][:3])
        fb = ", ".join("m%d:%s" % (m_, o) for m_, o in y["accesos"][:3])
        print("  +0x%-5X %-10s %-24s %s" % (off, x["tipo"], fa[:24], fb[:24]))
    print("\n  total con accesos en las dos: %d" % n)
    return 0


def _entero(t: str) -> int:
    return int(t, 0)


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Mapear los campos de una clase de entidad",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="El volcado tiene que arrancar en la dirección 0. "
               "Ver el aviso de `pine.py volcar`.")
    sub = p.add_subparsers(dest="cmd", required=True)

    m = sub.add_parser("mapear", help="tabla de campos de la clase")
    m.add_argument("volcado")
    m.add_argument("--vtable", type=_entero, required=True)
    m.add_argument("--paso", type=_entero, required=True,
                   help="tamaño de una instancia")
    m.add_argument("--base", type=_entero, default=None,
                   help="analizar UNA instancia concreta en vez del pool")
    m.add_argument("--todo", action="store_true",
                   help="mostrar también los offsets en cero y sin accesos")
    m.add_argument("--json", help="volcar el mapa a un JSON")
    m.set_defaults(func=cmd_mapear)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
