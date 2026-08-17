#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
parche_iso.py — mod PERMANENTE: editar un archivo ADENTRO del ISO, en el lugar.

POR QUÉ IN-PLACE Y NO RECONSTRUIR
    Un `.pnach` vive en la memoria del emulador y se pierde al cerrarlo. Un
    mod permanente hay que meterlo en el ISO. Hay dos caminos:

      A. reconstruir el ISO (mkps2iso) desde los archivos extraídos;
      B. editar los bytes del archivo DONDE YA ESTÁN, sin mover nada.

    Reconstruir reasigna el LBA de los 585 archivos. La tarea 6.1 verificó que
    BLACK **no** lleva LBAs horneados —resuelve por nombre contra la TOC, vía
    `GTFSCDVD.IRX`— así que A no está cerrado. Pero A cambia el layout entero
    del disco por un cambio de 4 bytes, y B no cambia **nada** más que esos 4
    bytes: mismo tamaño de archivo, mismo LBA, misma TOC, mismo CRC del ELF (y
    por lo tanto los mismos savestates siguen sirviendo).

    Para editar valores que no cambian de tamaño, B es estrictamente mejor.
    A queda para cuando haya que agregar, quitar o agrandar un archivo.

CÓMO SE UBICA UN BYTE ADENTRO DEL ISO
    offset_en_el_iso = LBA_del_archivo * 2048 + offset_dentro_del_archivo

    El LBA sale de la TOC de ISO9660, que lee `pycdlib` del `.iso` directo:
    no hace falta montarlo. Los archivos de ISO9660 son **contiguos**, así que
    un offset interno se traduce con una suma y nada más.

LA SEGURIDAD NO ES UNA ADVERTENCIA, ES EL DISEÑO
    El ISO original se abre SIEMPRE en modo lectura y nunca se pasa como
    destino. Los tres pasos están separados a propósito —`preparar`, `armas`,
    `verificar`— para que no exista una sola invocación capaz de escribirle al
    original por un argumento mal puesto.

    Además `armas` chequea el valor que va a pisar ANTES de escribir: si en el
    offset esperado no hay un Power plausible, aborta y muestra los bytes. Un
    parche que escribe a ciegas en la posición equivocada rompe el ISO de
    forma silenciosa y se descubre tres niveles después.

CLI
    python herramientas/parche_iso.py donde     <iso> /GLOBDATA.BIN
    python herramientas/parche_iso.py leer      <iso>
    python herramientas/parche_iso.py preparar  --original <iso> --salida <copia>
    python herramientas/parche_iso.py armas     --iso <copia> --power 300 --bloque ambos
    python herramientas/parche_iso.py verificar --original <iso> --parcheado <copia>
"""

from __future__ import annotations

import argparse
import os
import shutil
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lbas import SECTOR, enumerar_iso  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402

# --- la tabla de armas, de kb/estructuras.json#arma --------------------------
GLOBDATA = "/GLOBDATA.BIN;1"
TABLA = 0x00130E20          # offset dentro de GLOBDATA.BIN
N_REGISTROS = 17
PASO = 0x1E0
BLOQUE_JUGADOR = 0x90
BLOQUE_IA = 0xC0
OFF_RANGE = 0x14
OFF_POWER = 0x18
OFF_FALLOFF = 0x1C
OFF_CODIGO = 0x1C0

# Un Power creíble. Fuera de este rango, el offset está mal y hay que parar.
POWER_MIN, POWER_MAX = 0.1, 20000.0


def buscar_archivo(entradas: list[dict], ruta: str) -> dict:
    ruta_n = ruta.upper()
    for e in entradas:
        if e["ruta"].upper() == ruta_n or e["ruta"].upper() == ruta_n + ";1":
            return e
    disponibles = [e["ruta"] for e in entradas if "GLOBDATA" in e["ruta"].upper()]
    raise SystemExit("  no está %s en el ISO. Parecidos: %s" % (ruta, disponibles))


def leer_registros(fh, base_iso: int) -> list[dict]:
    """Los 17 registros, leídos del ISO abierto en `fh`."""
    regs = []
    for i in range(N_REGISTROS):
        off = base_iso + TABLA + i * PASO
        fh.seek(off)
        crudo = fh.read(PASO)
        def f32(o):
            return struct.unpack_from("<f", crudo, o)[0]
        codigo = crudo[OFF_CODIGO:OFF_CODIGO + 4]
        legible = "".join(chr(b) if 0x20 <= b <= 0x7E else "." for b in codigo)
        regs.append({
            "i": i,
            "offset_iso": off,
            "offset_archivo": TABLA + i * PASO,
            "jugador": (f32(BLOQUE_JUGADOR + OFF_RANGE),
                        f32(BLOQUE_JUGADOR + OFF_POWER),
                        f32(BLOQUE_JUGADOR + OFF_FALLOFF)),
            "ia": (f32(BLOQUE_IA + OFF_RANGE),
                   f32(BLOQUE_IA + OFF_POWER),
                   f32(BLOQUE_IA + OFF_FALLOFF)),
            "codigo": legible,
        })
    return regs


def imprimir_registros(regs: list[dict]) -> None:
    print("\n   #  offset ISO    offset arch  código |  Jugador R/P/F        |  IA R/P/F")
    for r in regs:
        print("  %2d  0x%010X  0x%08X  %-6s | %8.4g %8.4g %5.3g | %8.4g %8.4g %5.3g"
              % (r["i"], r["offset_iso"], r["offset_archivo"], r["codigo"],
                 r["jugador"][0], r["jugador"][1], r["jugador"][2],
                 r["ia"][0], r["ia"][1], r["ia"][2]))


# ---------------------------------------------------------------- comandos ---

def cmd_donde(args) -> int:
    entradas, _ = enumerar_iso(args.iso)
    e = buscar_archivo(entradas, args.ruta)
    print("\n  %s" % e["ruta"])
    print("    LBA           : %d" % e["lba"])
    print("    tamaño        : %d bytes (%d sectores)" % (e["tam"], e["sectores"]))
    print("    offset en ISO : 0x%X  (LBA * %d)" % (e["lba"] * SECTOR, SECTOR))
    print("    último byte   : 0x%X" % (e["lba"] * SECTOR + e["tam"] - 1))
    return 0


def cmd_leer(args) -> int:
    entradas, _ = enumerar_iso(args.iso)
    e = buscar_archivo(entradas, GLOBDATA)
    base = e["lba"] * SECTOR
    print("\n  ISO : %s" % args.iso)
    print("  %s  LBA %d  -> la tabla arranca en el byte 0x%X del ISO"
          % (e["ruta"], e["lba"], base + TABLA))
    with open(args.iso, "rb") as fh:
        imprimir_registros(leer_registros(fh, base))
    return 0


def cmd_preparar(args) -> int:
    orig = Path(args.original).resolve()
    dest = Path(args.salida).resolve()
    if orig == dest:
        raise SystemExit("  el destino no puede ser el original. Ese es el punto.")
    if dest.exists() and not args.rehacer:
        print("  ya existe %s (%s bytes). Usá --rehacer para volver a copiarlo."
              % (dest, f"{dest.stat().st_size:,}"))
        return 0
    tam = orig.stat().st_size
    libre = shutil.disk_usage(dest.parent).free
    print("\n  copiando %s -> %s" % (orig, dest))
    print("  %s bytes   (libre en destino: %.1f GB)"
          % (f"{tam:,}", libre / 1024 ** 3))
    if libre < tam * 1.05:
        raise SystemExit("  no hay lugar suficiente.")
    shutil.copyfile(orig, dest)
    nuevo = dest.stat().st_size
    print("  copiado. tamaño destino: %s bytes  %s"
          % (f"{nuevo:,}", "OK" if nuevo == tam else "¡DISTINTO AL ORIGINAL!"))
    return 0 if nuevo == tam else 1


def cmd_armas(args) -> int:
    iso = Path(args.iso)
    if not iso.exists():
        raise SystemExit("  no existe %s. Corré `preparar` primero." % iso)
    entradas, _ = enumerar_iso(str(iso))
    e = buscar_archivo(entradas, GLOBDATA)
    base = e["lba"] * SECTOR

    cuales = range(N_REGISTROS) if args.indices is None else args.indices
    bloques = {"jugador": [BLOQUE_JUGADOR], "ia": [BLOQUE_IA],
               "ambos": [BLOQUE_JUGADOR, BLOQUE_IA]}[args.bloque]

    with open(iso, "rb") as fh:
        antes = leer_registros(fh, base)
    print("\n  ANTES:")
    imprimir_registros([antes[i] for i in cuales])

    # --- precondición: lo que hay ahí tiene que PARECER un Power -------------
    objetivos = []
    for i in cuales:
        for b in bloques:
            off = base + TABLA + i * PASO + b + OFF_POWER
            with open(iso, "rb") as fh:
                fh.seek(off)
                actual = struct.unpack("<f", fh.read(4))[0]
            if not (POWER_MIN <= actual <= POWER_MAX):
                raise SystemExit(
                    "  ABORTA: en 0x%X hay %r, que no es un Power plausible.\n"
                    "  El offset está mal o este no es el archivo esperado."
                    % (off, actual))
            objetivos.append((off, actual, i, b))

    print("\n  se van a escribir %d campos Power = %s" % (len(objetivos), args.power))
    if args.simular:
        for off, actual, i, b in objetivos:
            print("    [simulado] 0x%010X  reg %2d  %-8s  %g -> %g"
                  % (off, i, "jugador" if b == BLOQUE_JUGADOR else "ia",
                     actual, args.power))
        return 0

    nuevo = struct.pack("<f", args.power)
    with open(iso, "r+b") as fh:
        for off, actual, i, b in objetivos:
            fh.seek(off)
            fh.write(nuevo)
        fh.flush()
        os.fsync(fh.fileno())

    # --- releer: no se confía en que la escritura haya salido ----------------
    malos = 0
    with open(iso, "rb") as fh:
        for off, actual, i, b in objetivos:
            fh.seek(off)
            leido = struct.unpack("<f", fh.read(4))[0]
            if abs(leido - args.power) > 1e-3:
                malos += 1
                print("    NO QUEDÓ: 0x%X vale %r" % (off, leido))
        despues = leer_registros(fh, base)

    print("\n  DESPUÉS:")
    imprimir_registros([despues[i] for i in cuales])
    print("\n  campos escritos y releídos OK: %d/%d"
          % (len(objetivos) - malos, len(objetivos)))
    return 1 if malos else 0


def cmd_verificar(args) -> int:
    a, b = Path(args.original), Path(args.parcheado)
    if a.stat().st_size != b.stat().st_size:
        print("  LOS TAMAÑOS DIFIEREN: %d vs %d. Eso solo ya invalida el "
              "parche in-place." % (a.stat().st_size, b.stat().st_size))
        return 1
    entradas, _ = enumerar_iso(str(a))
    # {sector: ruta} para poder decir a qué archivo pertenece cada diferencia
    print("\n  comparando byte a byte  (%s bytes)" % f"{a.stat().st_size:,}")

    rangos: list[tuple[int, int]] = []
    trozo = 8 << 20
    pos = 0
    with open(a, "rb") as fa, open(b, "rb") as fb:
        while True:
            xa = fa.read(trozo)
            xb = fb.read(trozo)
            if not xa:
                break
            if xa != xb:
                for i in range(len(xa)):
                    if xa[i] != xb[i]:
                        g = pos + i
                        if rangos and g == rangos[-1][1] + 1:
                            rangos[-1] = (rangos[-1][0], g)
                        else:
                            rangos.append((g, g))
            pos += len(xa)

    print("  rangos de bytes distintos: %d" % len(rangos))
    if not rangos:
        print("  Los dos ISO son idénticos: el parche no se aplicó.")
        return 1

    def duenio(off: int) -> str:
        sec = off // SECTOR
        for e in entradas:
            if e["lba"] <= sec < e["lba"] + e["sectores"]:
                return "%s + 0x%X" % (e["ruta"], off - e["lba"] * SECTOR)
        return "FUERA DE TODO ARCHIVO (metadatos del ISO / relleno)"

    fuera = 0
    for ini, fin in rangos[: args.max]:
        d = duenio(ini)
        if "FUERA" in d:
            fuera += 1
        print("    0x%010X..0x%010X  (%d B)  %s" % (ini, fin, fin - ini + 1, d))
    if len(rangos) > args.max:
        print("    ... y %d rangos más" % (len(rangos) - args.max))

    duenios = {duenio(i).split(" + ")[0] for i, _ in rangos}
    print("\n  archivos tocados: %s" % ", ".join(sorted(duenios)))
    primer_lba = min(e["lba"] for e in entradas)
    metadatos = [r for r in rangos if r[0] // SECTOR < primer_lba]
    print("  diferencias en la zona de metadatos/TOC (sector < %d): %d"
          % (primer_lba, len(metadatos)))
    if metadatos:
        print("  MAL: el parche tocó la TOC. Un parche in-place no debe hacerlo.")
        return 1
    print("  BIEN: la TOC y el layout quedaron intactos; sólo cambió el "
          "contenido de %d archivo(s)." % len(duenios))
    return 0


def _lista_indices(t: str) -> list[int]:
    return [int(x) for x in t.replace(" ", "").split(",") if x != ""]


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Editar un archivo adentro del ISO sin reconstruirlo",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="El original se abre SIEMPRE en lectura. Los pasos están "
               "separados para que ninguna invocación sola pueda pisarlo.")
    sub = p.add_subparsers(dest="cmd", required=True)

    p_d = sub.add_parser("donde", help="LBA y offset de un archivo del ISO")
    p_d.add_argument("iso")
    p_d.add_argument("ruta", help="ruta adentro del ISO, p. ej. /GLOBDATA.BIN")
    p_d.set_defaults(func=cmd_donde)

    p_l = sub.add_parser("leer", help="los 17 registros de armas, desde el ISO")
    p_l.add_argument("iso")
    p_l.set_defaults(func=cmd_leer)

    p_p = sub.add_parser("preparar", help="copiar el ISO original a una copia")
    p_p.add_argument("--original", required=True)
    p_p.add_argument("--salida", required=True)
    p_p.add_argument("--rehacer", action="store_true",
                     help="volver a copiar aunque el destino ya exista")
    p_p.set_defaults(func=cmd_preparar)

    p_a = sub.add_parser("armas", help="escribir Power en la tabla de armas")
    p_a.add_argument("--iso", required=True, help="LA COPIA, nunca el original")
    p_a.add_argument("--power", type=float, required=True)
    p_a.add_argument("--bloque", choices=["jugador", "ia", "ambos"],
                     default="ambos")
    p_a.add_argument("--indices", type=_lista_indices, default=None,
                     help="qué registros tocar, p. ej. 0,4,10 (default: los 17)")
    p_a.add_argument("--simular", action="store_true",
                     help="mostrar qué se escribiría, sin escribir")
    p_a.set_defaults(func=cmd_armas)

    p_v = sub.add_parser("verificar", help="diff byte a byte de los dos ISO")
    p_v.add_argument("--original", required=True)
    p_v.add_argument("--parcheado", required=True)
    p_v.add_argument("--max", type=int, default=40)
    p_v.set_defaults(func=cmd_verificar)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
