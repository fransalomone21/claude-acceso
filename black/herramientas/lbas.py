#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
lbas.py — ¿el juego lleva sectores del ISO escritos a mano?

QUÉ DECIDE
    Reconstruir un ISO de PS2 (mkps2iso) **reasigna el LBA de todos los
    archivos**, aunque no se toque un solo byte de contenido. Si el ejecutable
    —o cualquier archivo de datos— lleva LBAs horneados en vez de pedirle la
    dirección a la TOC de ISO9660, el ISO reconstruido arranca bien y falla
    tres niveles después, sin decir por qué.

    Esta herramienta contesta esa pregunta con evidencia y no con fe:
    saca la tabla real de LBAs del ISO y la busca adentro del binario.

CÓMO BUSCA — cinco codificaciones, porque una sola no alcanza
    Un LBA horneado puede estar de varias formas, y buscar sólo la primera es
    la manera de conseguir un falso negativo:

      1. u32 little-endian suelto      -> tabla de datos en .data/.rodata
      2. u32 big-endian suelto         -> barato de descartar, se hace igual
      3. el OFFSET EN BYTES (LBA*2048) como u32 LE
      4. par lui+ori / lui+addiu       -> inmediato de MIPS. **Un valor de 32
         bits NO existe como palabra contigua en el código**: se arma con dos
         instrucciones de 16 bits. Buscar u32 en .text no lo ve nunca.
      5. lo mismo, con el offset en bytes

    Se buscan además los LBA +-1 sector: hay tablas que guardan el sector del
    encabezado y otras el del primer dato.

LOS DOS CONTROLES — sin ellos el resultado no vale
    control POSITIVO (`--autoprueba`): mete en el conjunto de búsqueda un
        valor sacado del propio objetivo, en un offset conocido, y verifica
        que el barrido lo encuentre ahí. Se elige un valor DISTINTIVO (no
        cero, pocas apariciones): una aguja que aparece en todos lados no
        prueba nada. Si el control positivo falla, cualquier "no hay LBAs" es
        un bug del barrido y no un hallazgo.

    control NEGATIVO (señuelos): se busca **la misma cantidad** de valores
        inventados, del mismo rango numérico, en **las mismas cinco
        codificaciones**. Ese es el piso de ruido. Si los LBA reales aparecen
        tanto como los inventados, no hay señal: son coincidencias de un
        binario de 3 MB, no sectores.

        El rango importa: en BLACK los LBA van de 1.050.000 a 1.903.423, o sea
        0x100590..0x1D0B3F — que es **exactamente el rango de direcciones del
        .text del juego**. Cualquier puntero a código parece un LBA. Sin
        señuelos del mismo rango, ese confundido se lee como hallazgo.

QUÉ MIRA DESPUÉS DEL CONTEO
    Una tabla de LBAs no es un valor suelto: son valores **alineados a 4** y
    **contiguos**. Por eso se informa el reparto por alineación, la sección
    del ELF donde cae cada golpe, y la corrida más larga de golpes separados
    por 4 bytes. Treinta golpes desparramados y desalineados en .text son
    ruido; tres seguidos y alineados en .data son una tabla.

CLI
    python herramientas/lbas.py tabla  "C:/.../Black.iso" --json kb/lbas-iso.json
    python herramientas/lbas.py buscar "C:/.../Black.iso" C:/.../SLUS_213.76 \\
        --base 0xFF000 --autoprueba
    python herramientas/lbas.py buscar "C:/.../Black.iso" D:/ --profundo
"""

from __future__ import annotations

import argparse
import json
import os
import random
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402

try:
    import numpy as _np
except ImportError:
    _np = None

SECTOR = 2048

LUI = 0x0F
ADDIU = 0x09
ORI = 0x0D
# Los mismos opcodes de memoria que usa xref.py: un lui seguido de un load o
# un store con el bajo puesto también arma la constante completa.
OPS_MEM = {0x20, 0x21, 0x23, 0x24, 0x25, 0x27, 0x37, 0x31, 0x1E,
           0x28, 0x29, 0x2B, 0x3F, 0x39, 0x1F}

# Secciones del ELF de BLACK (decompilar.py info). Sirven para decir en qué
# vecindario cae cada golpe: en .text es ruido de instrucciones, en .data o
# .rodata podría ser una tabla de verdad.
SECCIONES = [
    (0x00100000, 0x00396F47, ".text"),
    (0x00396F50, 0x003BC32F, ".vutext"),
    (0x003BC380, 0x003F215B, ".data"),
    (0x003F2160, 0x003F221F, ".vudata"),
    (0x003F2280, 0x0040C7A7, ".rodata"),
    (0x0040C800, 0x0040D783, ".gcc_except_table"),
    (0x0040D800, 0x0040D903, ".lit4"),
    (0x0040D980, 0x0040E57F, ".sdata"),
]


def seccion_de(direccion: int) -> str:
    for lo, hi, nombre in SECCIONES:
        if lo <= direccion <= hi:
            return nombre
    return "?"


# ---------------------------------------------------------------- el ISO ----

def enumerar_iso(ruta_iso: str) -> tuple[list[dict], int]:
    """Todos los archivos del ISO con su LBA y su tamaño, leyendo el .iso
    directo: no hace falta montarlo."""
    try:
        import pycdlib
    except ImportError:
        print("  falta pycdlib:  py -m pip install pycdlib")
        raise SystemExit(2)

    iso = pycdlib.PyCdlib()
    iso.open(ruta_iso)
    salida: list[dict] = []

    def bajar(ruta: str) -> None:
        for hijo in iso.list_children(iso_path=ruta):
            if hijo is None or hijo.is_dot() or hijo.is_dotdot():
                continue
            nombre = hijo.file_identifier().decode("ascii", "replace")
            completa = (ruta.rstrip("/") + "/" + nombre) or "/"
            if hijo.is_dir():
                bajar(completa)
            else:
                salida.append({
                    "ruta": completa,
                    "lba": int(hijo.extent_location()),
                    "tam": int(hijo.get_data_length()),
                })

    bajar("/")
    pvd_sectores = int(iso.pvd.space_size)
    iso.close()
    salida.sort(key=lambda e: e["lba"])
    for e in salida:
        e["sectores"] = (e["tam"] + SECTOR - 1) // SECTOR
    return salida, pvd_sectores


# ------------------------------------------------------------- el barrido ----

def _palabras(datos: bytes, fase: int, endian: str):
    """Vista de u32 del buffer, arrancando en `fase` bytes."""
    cuerpo = datos[fase:]
    cuerpo = cuerpo[: len(cuerpo) - (len(cuerpo) % 4)]
    if not cuerpo:
        return None
    if _np is not None:
        return _np.frombuffer(cuerpo, dtype=("<u4" if endian == "le" else ">u4"))
    fmt = ("<%dI" if endian == "le" else ">%dI") % (len(cuerpo) // 4)
    return struct.unpack(fmt, cuerpo)


def buscar_literales(datos: bytes, valores: set[int],
                     endian: str = "le") -> dict[int, list[int]]:
    """{valor: [offsets de archivo]} para el valor como u32 suelto.

    Se recorren las cuatro fases de alineación. Una tabla de LBAs va a estar
    alineada a 4, pero un registro empaquetado adentro de un struct puede no
    estarlo, y ese es justo el caso que no hay que perderse."""
    hallado: dict[int, list[int]] = {}
    valores = {v for v in valores if 0 <= v <= 0xFFFFFFFF}
    if not valores:
        return hallado
    if _np is not None:
        orden = _np.array(sorted(valores), dtype="<u4")
    for fase in range(4):
        pal = _palabras(datos, fase, endian)
        if pal is None:
            continue
        if _np is not None:
            pos = _np.searchsorted(orden, pal)
            pos[pos >= len(orden)] = 0
            golpes = _np.nonzero(orden[pos] == pal)[0]
            for i in golpes.tolist():
                hallado.setdefault(int(pal[i]), []).append(fase + i * 4)
        else:
            for i, w in enumerate(pal):
                if w in valores:
                    hallado.setdefault(int(w), []).append(fase + i * 4)
    for v in hallado:
        hallado[v].sort()
    return hallado


def indexar_luis(datos: bytes) -> dict[int, list[tuple[int, int]]]:
    """{inmediato_alto: [(indice_de_palabra, registro_destino)]}.

    Se arma UNA sola vez y sirve para los miles de valores que se consultan
    después. Hacerlo por valor sería un barrido completo del .text por cada
    archivo del ISO."""
    pal = _palabras(datos, 0, "le")
    luis: dict[int, list[tuple[int, int]]] = {}
    if pal is None:
        return luis
    for i in range(len(pal)):
        w = int(pal[i])
        if (w >> 26) == LUI and ((w >> 21) & 0x1F) == 0:
            luis.setdefault(w & 0xFFFF, []).append((i, (w >> 16) & 0x1F))
    return luis


def buscar_inmediatos(datos: bytes, luis: dict, valores: set[int],
                      radio: int = 16) -> dict[int, list[tuple[int, int]]]:
    """{valor: [(offset del lui, offset del par)]} para el valor armado con
    dos instrucciones. El radio por defecto es 16 y no 8: el par que arma
    0x003BCE70 tiene nueve instrucciones en el medio (ver docs/05-iso.md)."""
    pal = _palabras(datos, 0, "le")
    if pal is None or not luis:
        return {}
    n = len(pal)
    hallado: dict[int, list[tuple[int, int]]] = {}
    for v in valores:
        if not (0 <= v <= 0xFFFFFFFF):
            continue
        lo = v & 0xFFFF
        hi_ori = v >> 16
        hi_addiu = (v + 0x8000) >> 16
        for hi, modo in ((hi_ori, "ori"), (hi_addiu, "addiu")):
            for i, reg in luis.get(hi, ()):
                for j in range(i + 1, min(i + 1 + radio, n)):
                    w2 = int(pal[j])
                    op2 = w2 >> 26
                    rs2 = (w2 >> 21) & 0x1F
                    rt2 = (w2 >> 16) & 0x1F
                    imm2 = w2 & 0xFFFF
                    if rs2 != reg:
                        if op2 == LUI and rt2 == reg:
                            break          # el registro se pisó
                        continue
                    casa = ((modo == "ori" and op2 == ORI and imm2 == lo)
                            or (modo == "addiu" and op2 == ADDIU and imm2 == lo)
                            or (modo == "addiu" and op2 in OPS_MEM and imm2 == lo))
                    if casa:
                        hallado.setdefault(v, []).append((i * 4, j * 4))
                        break
                    if op2 == LUI and rt2 == reg:
                        break
    return hallado


# ------------------------------------------------------------- controles ----

def elegir_aguja(datos: bytes, desde: int) -> tuple[int, int] | None:
    """Un valor DISTINTIVO del propio objetivo, para el control positivo.

    Una aguja que vale 0 aparece miles de veces y encontrarla no prueba que
    el barrido sirva: prueba que el archivo tiene ceros. Se busca el primer
    u32 alineado, no nulo, que aparezca pocas veces."""
    pal = _palabras(datos, 0, "le")
    if pal is None:
        return None
    n = len(pal)
    i0 = max(0, desde // 4)
    for i in range(i0, min(n, i0 + 65536)):
        v = int(pal[i])
        if v == 0 or v == 0xFFFFFFFF:
            continue
        sitios = buscar_literales(datos, {v}, "le").get(v, [])
        if 1 <= len(sitios) <= 8:
            return v, i * 4
    return None


def senuelos_de(lbas: set[int], cantidad: int, semilla: int) -> set[int]:
    """Valores inventados del mismo rango, disjuntos de los reales y de sus
    vecinos. Semilla fija: el control tiene que poder repetirse."""
    rnd = random.Random(semilla)
    lo, hi = min(lbas), max(lbas)
    prohibidos = set(lbas) | {l + 1 for l in lbas} | {l - 1 for l in lbas}
    s: set[int] = set()
    tope = cantidad * 40
    intentos = 0
    while len(s) < cantidad and intentos < tope:
        intentos += 1
        v = rnd.randrange(lo, hi + 1)
        if v not in prohibidos:
            s.add(v)
    return s


def corrida_maxima(offsets: list[int]) -> int:
    """Golpes alineados a 4 y separados por exactamente 4 bytes = tabla.
    Devuelve el largo de la corrida más larga."""
    alineados = sorted(o for o in offsets if o % 4 == 0)
    mejor = actual = 0
    anterior = None
    for o in alineados:
        actual = actual + 1 if anterior is not None and o - anterior == 4 else 1
        mejor = max(mejor, actual)
        anterior = o
    return mejor


# ---------------------------------------------------------------- comandos ---

def cmd_tabla(args) -> int:
    entradas, pvd = enumerar_iso(args.iso)
    print("\n  ISO: %s" % args.iso)
    print("  archivos: %d   sectores declarados en el PVD: %d (%.2f GB)"
          % (len(entradas), pvd, pvd * SECTOR / 1024 ** 3))
    print("\n  %-10s %-12s %-10s %s" % ("LBA", "offset", "tamaño", "ruta"))
    for e in entradas[: args.max]:
        print("  %-10d 0x%-10X %-10d %s"
              % (e["lba"], e["lba"] * SECTOR, e["tam"], e["ruta"]))
    if len(entradas) > args.max:
        print("  ... y %d más (--max)" % (len(entradas) - args.max))

    lbas = [e["lba"] for e in entradas]
    print("\n  rango de LBA: %d .. %d   (0x%X .. 0x%X)"
          % (min(lbas), max(lbas), min(lbas), max(lbas)))
    print("  primer sector con datos: %d  ->  los %d sectores de adelante"
          % (min(lbas), min(lbas)))
    print("  (%.2f GB) son relleno del disco, no archivos"
          % (min(lbas) * SECTOR / 1024 ** 3))

    if args.json:
        destino = Path(args.json)
        destino.parent.mkdir(parents=True, exist_ok=True)
        destino.write_text(json.dumps(
            {"iso": os.path.basename(args.iso), "sectores_pvd": pvd,
             "archivos": entradas}, indent=1, ensure_ascii=False),
            encoding="utf-8")
        print("  escrito: %s" % destino)
    return 0


def _objetivos(ruta: str) -> list[Path]:
    p = Path(ruta)
    if p.is_file():
        return [p]
    return sorted(x for x in p.rglob("*") if x.is_file())


def cmd_buscar(args) -> int:
    entradas, _ = enumerar_iso(args.iso)
    lbas = {e["lba"] for e in entradas}
    por_lba: dict[int, list[str]] = {}
    for e in entradas:
        por_lba.setdefault(e["lba"], []).append(e["ruta"])

    reales = set(lbas)
    if args.vecinos:
        for l in lbas:
            reales.add(l + 1)
            reales.add(l - 1)

    # EL PUNTO DEL CONTROL: misma cantidad, mismo rango, mismas codificaciones.
    senuelos = senuelos_de(lbas, len(reales), args.semilla)

    print("\n  ISO   : %s" % args.iso)
    print("  archivos: %d   LBA %d..%d  (0x%X..0x%X)"
          % (len(entradas), min(lbas), max(lbas), min(lbas), max(lbas)))
    print("  conjunto real    : %d valores (LBA%s)"
          % (len(reales), " y sus vecinos +-1" if args.vecinos else ""))
    print("  conjunto señuelo : %d valores inventados del mismo rango "
          "(semilla %d)" % (len(senuelos), args.semilla))

    objetivos = _objetivos(args.objetivo)
    if not args.profundo and len(objetivos) > 1:
        print("  %s es una carpeta: usá --profundo para barrerla entera"
              % args.objetivo)
        return 2
    print("  objetivos: %d archivo(s)" % len(objetivos))

    sospechosos = []
    for obj in objetivos:
        datos = obj.read_bytes()
        if len(datos) < 16:
            continue
        base = args.base

        luis = indexar_luis(datos) if args.inmediatos else {}

        # --- control positivo ------------------------------------------------
        control = None
        if args.autoprueba:
            aguja = elegir_aguja(datos, args.aguja_off)
            if aguja is None:
                control = ("sin aguja utilizable", False)
            else:
                v, off = aguja
                ok = off in buscar_literales(datos, {v}, "le").get(v, [])
                control = ("aguja 0x%08X en offset 0x%X (%d apariciones)"
                           % (v, off,
                              len(buscar_literales(datos, {v}, "le").get(v, []))),
                           ok)

        lit_r = buscar_literales(datos, reales, "le")
        lit_s = buscar_literales(datos, senuelos, "le")
        be_r = buscar_literales(datos, reales, "be")
        be_s = buscar_literales(datos, senuelos, "be")
        off_r = buscar_literales(datos, {v * SECTOR for v in reales}, "le")
        off_s = buscar_literales(datos, {v * SECTOR for v in senuelos}, "le")
        inm_r = buscar_inmediatos(datos, luis, reales, args.radio)
        inm_s = buscar_inmediatos(datos, luis, senuelos, args.radio)
        ino_r = buscar_inmediatos(datos, luis, {v * SECTOR for v in reales}, args.radio)
        ino_s = buscar_inmediatos(datos, luis, {v * SECTOR for v in senuelos}, args.radio)

        filas = [
            ("u32 LE", len(lit_r), len(lit_s)),
            ("u32 BE", len(be_r), len(be_s)),
            ("LBA*2048 LE", len(off_r), len(off_s)),
            ("inmediato lui+par", len(inm_r), len(inm_s)),
            ("inmediato del offset", len(ino_r), len(ino_s)),
        ]
        exceso = sum(max(0, r - s) for _, r, s in filas)
        if exceso == 0 and len(objetivos) > 1:
            continue
        if exceso > 0:
            sospechosos.append((obj, exceso))

        print("\n  === %s   (%s bytes) ===" % (obj, f"{len(datos):,}"))
        if control:
            print("    [control positivo] %s: %s"
                  % (control[0], "ENCONTRADA -> el barrido sirve"
                     if control[1] else "NO ENCONTRADA -> EL BARRIDO ESTÁ ROTO"))
        if args.inmediatos:
            print("    lui indexados: %d" % sum(len(v) for v in luis.values()))
        print("    %-22s %-12s %-12s" % ("codificación", "reales", "señuelos"))
        for etiqueta, r, s in filas:
            marca = "  <- por encima del ruido" if r > s else ""
            print("    %-22s %-12s %-12s%s"
                  % (etiqueta, "%d/%d" % (r, len(reales)),
                     "%d/%d" % (s, len(senuelos)), marca))

        # --- forma de los golpes: una tabla no está desparramada -------------
        todos = [o for sitios in lit_r.values() for o in sitios]
        if todos:
            alin = sum(1 for o in todos if o % 4 == 0)
            porsec: dict[str, int] = {}
            for o in todos:
                porsec[seccion_de(o + base)] = porsec.get(seccion_de(o + base), 0) + 1
            print("    forma de los %d golpes u32 LE:" % len(todos))
            print("      alineados a 4 : %d/%d" % (alin, len(todos)))
            print("      corrida más larga de golpes contiguos: %d"
                  % corrida_maxima(todos))
            print("      por sección   : %s"
                  % ", ".join("%s=%d" % kv for kv in sorted(porsec.items())))

        for v, sitios in sorted(lit_r.items())[: args.max]:
            quien = ", ".join(por_lba.get(v)
                              or por_lba.get(v - 1)
                              or por_lba.get(v + 1) or ["?"])[:52]
            d = sitios[0] + base
            print("      LBA %-9d x%-3d off 0x%06X  %-8s %s"
                  % (v, len(sitios), sitios[0],
                     seccion_de(d) if base else "", quien))
        for v, sitios in sorted(inm_r.items())[: args.max]:
            print("      LBA %-9d INMEDIATO en 0x%08X  -> %s"
                  % (v, sitios[0][0] + base,
                     ", ".join(por_lba.get(v, ["?"]))[:52]))

    print("\n  " + "-" * 68)
    if not sospechosos:
        print("  VEREDICTO: en ningún objetivo los LBA reales superan al piso")
        print("             de ruido de los señuelos. No hay evidencia de LBAs")
        print("             horneados.")
    else:
        print("  VEREDICTO: %d objetivo(s) con LBA reales por encima del ruido."
              % len(sospechosos))
        for obj, exceso in sorted(sospechosos, key=lambda t: -t[1])[:20]:
            print("      +%-5d %s" % (exceso, obj))
        print("  Mirar la FORMA de los golpes antes de concluir: si están")
        print("  desalineados, desparramados y en .text, siguen siendo ruido.")
    return 0


def _entero(t: str) -> int:
    return int(t, 0)


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="¿Hay sectores del ISO escritos a mano en el binario?",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="El veredicto se lee CONTRA EL PISO DE RUIDO de los señuelos, "
               "nunca en términos absolutos.")
    sub = p.add_subparsers(dest="cmd", required=True)

    p_t = sub.add_parser("tabla", help="LBA y tamaño de cada archivo del ISO")
    p_t.add_argument("iso")
    p_t.add_argument("--json", help="volcar la tabla a un JSON del kb/")
    p_t.add_argument("--max", type=int, default=30)
    p_t.set_defaults(func=cmd_tabla)

    p_b = sub.add_parser("buscar", help="buscar esos LBA adentro de un binario")
    p_b.add_argument("iso")
    p_b.add_argument("objetivo", help="archivo (el ELF) o carpeta con --profundo")
    p_b.add_argument("--base", type=_entero, default=0,
                     help="dirección EE del primer byte del objetivo "
                          "(0xFF000 para el ELF de BLACK)")
    p_b.add_argument("--profundo", action="store_true",
                     help="barrer una carpeta entera, archivo por archivo")
    p_b.add_argument("--semilla", type=int, default=20260816,
                     help="semilla de los señuelos; fija para poder repetir")
    p_b.add_argument("--vecinos", action="store_true", default=True,
                     help="buscar también LBA+-1")
    p_b.add_argument("--sin-vecinos", dest="vecinos", action="store_false")
    p_b.add_argument("--inmediatos", action="store_true", default=True,
                     help="buscar pares lui+ori/addiu (default: sí)")
    p_b.add_argument("--sin-inmediatos", dest="inmediatos", action="store_false")
    p_b.add_argument("--radio", type=int, default=16)
    p_b.add_argument("--autoprueba", action="store_true",
                     help="control positivo: plantar una aguja del propio objetivo")
    p_b.add_argument("--aguja-off", type=_entero, default=0x1000,
                     help="desde qué offset buscar la aguja del control positivo")
    p_b.add_argument("--max", type=int, default=40)
    p_b.set_defaults(func=cmd_buscar)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
