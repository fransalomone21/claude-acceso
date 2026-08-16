#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
decompilar.py — hablarle a Ghidra desde Python, sin abrir la GUI.

`mips.py` y `capstone` desensamblan. Esto **decompila**: devuelve C, con
variables, control de flujo y llamadas resueltas. Es la diferencia entre leer
514 instrucciones y leer treinta líneas.

NO SE LLAMA `ghidra.py` A PROPÓSITO
    `pyghidra` importa el paquete Java `ghidra` desde Python. Un archivo
    nuestro llamado `ghidra.py` en `herramientas/` lo taparía, porque las
    herramientas se agregan a `sys.path`. Es la misma trampa que ya se pagó
    con `dis.py`.

MONTAJE (una vez por máquina)
    1. Ghidra 12.1.2:
       https://github.com/NationalSecurityAgency/ghidra/releases
       descomprimir en `~/herramientas/ghidra_12.1.2_PUBLIC`
    2. La extensión de PlayStation 2, con la versión que COINCIDA:
       https://github.com/chaoticgd/ghidra-emotionengine-reloaded/releases
       -> `ghidra_12.1.2_PUBLIC_..._ghidra-emotionengine-reloaded.zip`
       descomprimir en `<ghidra>/Ghidra/Extensions/`
       OJO: es `Ghidra/Extensions/`, NO `Extensions/Ghidra/`. La segunda
       existe, guarda los zips distribuibles, y Ghidra NO la carga. Ese error
       cuesta media hora y da un análisis que dice "succeeded" sobre basura.
    3. `pip install pyghidra`
    4. Importar y analizar, forzando el procesador:
       <ghidra>/support/analyzeHeadless.bat <proyectos> BLACK \\
           -import SLUS_213.76 -processor "r5900:LE:32:default"

EL PROCESADOR SE FUERZA, NO SE DEDUCE
    Sin `-processor`, Ghidra elige `MIPS:LE:64:64-32R6addr` — MIPS Release 6,
    otra ISA — y el análisis termina con "Analysis succeeded", UNA función en
    2,6 MB de código y cero decompilación. Verificalo siempre con
    `decompilar.py info`, que corre el control positivo.

SAVESTATES: LA RAM VIVA ADENTRO DEL DECOMPILADOR
    `decompilar.py estado` mete los 32 MB de un savestate de PCSX2 en el
    programa de Ghidra. Es lo que la extensión trae como script de GUI
    (`PCSX2SaveStateImporter.java`), pero sin GUI y con control positivo.

    Lo que destraba: el ELF estático tiene `.bss` en cero y el heap ni
    existe. Con el savestate cargado, el decompilador ve los valores reales
    de los 561 globales por `$gp`, y el heap entero (tabla de armas, tabla de
    zonas, pool de enemigos) queda navegable como un bloque más.

    NUNCA toca el programa limpio: copia `/SLUS_213.76` a
    `/SLUS_213.76_estado` y trabaja sobre la copia. El control positivo de
    `info` sigue corriendo contra el original.

EJEMPLOS
    python herramientas/decompilar.py info
    python herramientas/decompilar.py c 0x00142B90
    python herramientas/decompilar.py funciones --desde 0x00142000 --hasta 0x00143000
    python herramientas/decompilar.py xref 0x003BCE70
    python herramientas/decompilar.py estado --savestate ".../SLUS-21376 (5C891FF1).06.p2s"
    python herramientas/decompilar.py c 0x00142B90 --estado
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402

GHIDRA = os.environ.get(
    "GHIDRA_INSTALL_DIR",
    str(Path.home() / "herramientas" / "ghidra_12.1.2_PUBLIC"))
PROYECTOS = os.environ.get(
    "BLACK_GHIDRA_PROYECTOS",
    str(Path.home() / "herramientas" / "ghidra-proyectos2"))
PROYECTO = os.environ.get("BLACK_GHIDRA_PROYECTO", "BLACK")
PROGRAMA = os.environ.get("BLACK_GHIDRA_PROGRAMA", "/SLUS_213.76")
# La copia con la RAM viva encima. NUNCA se escribe sobre PROGRAMA.
PROGRAMA_ESTADO = os.environ.get("BLACK_GHIDRA_PROGRAMA_ESTADO", "/SLUS_213.76_estado")

# La rutina de daño por zona de impacto. Confirmada POR EFECTO en la Fase 4b:
# daño = factor_de_zona * 100.0, y la función IGNORA el $f12 que le llega.
# Si la decompilación de esto no muestra un 100.0, Ghidra está mal montado.
CONTROL = 0x00142B90

# El mapa principal del EE. Arriba de esto hay scratchpad, registros y demás,
# que no salen del eeMemory.bin de un savestate.
MAX_DIR_EE = 0x10000000

# Control positivo del cargador de savestates. Los dos hechos son de la Fase 2,
# confirmados POR EFECTO, y viven en el HEAP: si el savestate no se cargó, o se
# cargó corrido, estos dos no pueden dar bien por casualidad.
CTL_JUGADOR = 0x005A8AB0          # el objeto del jugador
CTL_CLASE_EN = 0x10               # el puntero de clase está en objeto+0x10
CTL_CLASE_JUGADOR = 0x003DC5F8    # y vale esto
CTL_VIDA = 0x005A8DA8             # jugador+0x2F8, f32


def abrir_proyecto():
    """El proyecto de Ghidra, abierto una sola vez por proceso."""
    global _PROYECTO
    if _PROYECTO is not None:
        return _PROYECTO
    os.environ["GHIDRA_INSTALL_DIR"] = GHIDRA
    if not Path(GHIDRA).is_dir():
        raise SystemExit(f"no existe la instalación de Ghidra: {GHIDRA}\n"
                         "  ver el encabezado de este archivo")
    try:
        import pyghidra
    except ImportError:
        raise SystemExit("falta pyghidra: pip install pyghidra")
    pyghidra.start(verbose=False)
    _PROYECTO = pyghidra.open_project(PROYECTOS, PROYECTO)
    return _PROYECTO


_PROYECTO = None


def abrir(programa: str | None = None):
    """Devuelve (contexto, programa). El contexto hay que cerrarlo."""
    import pyghidra
    proyecto = abrir_proyecto()
    ctx = pyghidra.program_context(proyecto, programa or PROGRAMA)
    return ctx, ctx.__enter__()


def cual_programa(args) -> str:
    """El programa que pidió la línea de comandos: el limpio o el del savestate."""
    return PROGRAMA_ESTADO if getattr(args, "estado", False) else PROGRAMA


def decompilador(prog):
    from ghidra.app.decompiler import DecompInterface
    d = DecompInterface()
    d.openProgram(prog)
    return d


def a_dir(prog, valor: int):
    return prog.getAddressFactory().getDefaultAddressSpace().getAddress(valor)


def decompilar_en(prog, dec, direccion: int, segundos: int = 180):
    from ghidra.util.task import ConsoleTaskMonitor
    addr = a_dir(prog, direccion)
    f = prog.getFunctionManager().getFunctionContaining(addr)
    if f is None:
        return None, None
    res = dec.decompileFunction(f, segundos, ConsoleTaskMonitor())
    if not res.decompileCompleted():
        return f, f"// FALLO: {res.getErrorMessage()}"
    # Ghidra devuelve CRLF; en Windows `print` vuelve a expandir el \n y sale
    # todo a doble espacio. Se normaliza acá, no en cada llamador.
    return f, str(res.getDecompiledFunction().getC()).replace("\r\n", "\n")


# --------------------------------------------------------------------------


def cmd_info(args) -> int:
    ctx, prog = abrir()
    try:
        fm = prog.getFunctionManager()
        n_func = fm.getFunctionCount()
        print(f"  programa   : {prog.getName()}")
        print(f"  lenguaje   : {prog.getLanguage().getLanguageID()}")
        print(f"  base       : 0x{prog.getImageBase().getOffset():08X}")
        print(f"  funciones  : {n_func}")
        print(f"  símbolos   : {prog.getSymbolTable().getNumSymbols()}")

        print("\n  bloques del ejecutable:")
        for b in prog.getMemory().getBlocks():
            nom = str(b.getName())
            if nom.startswith(".DVP") or not b.isInitialized():
                continue
            print(f"    {nom:<20} 0x{b.getStart().getOffset():08X}-"
                  f"0x{b.getEnd().getOffset():08X}")

        print(f"\n  === CONTROL POSITIVO sobre 0x{CONTROL:08X} ===")
        print("  Sabemos, por efecto en pantalla, que hace daño = zona * 100.0")
        if str(prog.getLanguage().getLanguageID()) != "r5900:LE:32:default":
            print("  [MAL] el lenguaje NO es r5900. Reimportá con -processor.")
            return 1
        if n_func <= 1:
            print("  [MAL] hay 1 función en todo el binario: no se analizó.")
            return 1
        dec = decompilador(prog)
        f, c = decompilar_en(prog, dec, CONTROL)
        if f is None:
            print("  [MAL] no hay función en esa dirección.")
            return 1
        ok = "100.0" in (c or "") or "100.00" in (c or "")
        print(f"  función    : {f.getName()} @ 0x{f.getEntryPoint().getOffset():08X}")
        print(f"  el 100.0 aparece en la decompilación: {'SI -> BIEN' if ok else 'NO -> SOSPECHAR'}")
        return 0 if ok else 1
    finally:
        ctx.__exit__(None, None, None)


def cmd_c(args) -> int:
    ctx, prog = abrir(cual_programa(args))
    try:
        dec = decompilador(prog)
        f, c = decompilar_en(prog, dec, args.direccion)
        if f is None:
            print(f"  no hay función que contenga 0x{args.direccion:08X}")
            return 1
        print(f"  // {f.getName()}  0x{f.getEntryPoint().getOffset():08X}"
              f"-0x{f.getBody().getMaxAddress().getOffset():08X}"
              f"  ({f.getBody().getNumAddresses()} bytes)")
        print(c)
        return 0
    finally:
        ctx.__exit__(None, None, None)


def cmd_funciones(args) -> int:
    ctx, prog = abrir(cual_programa(args))
    try:
        fm = prog.getFunctionManager()
        salida = []
        for f in fm.getFunctions(True):
            e = f.getEntryPoint().getOffset()
            if args.desde is not None and e < args.desde:
                continue
            if args.hasta is not None and e >= args.hasta:
                continue
            salida.append({
                "direccion": f"0x{e:08X}",
                "nombre": str(f.getName()),
                "bytes": int(f.getBody().getNumAddresses()),
            })
        print(f"  {len(salida)} funciones")
        for d in salida[:args.max]:
            print(f"    {d['direccion']}  {d['bytes']:>6}  {d['nombre']}")
        if args.json:
            Path(args.json).write_text(json.dumps(salida, indent=1), encoding="utf-8")
            print(f"  escrito: {args.json}  ({len(salida)} entradas)")
        return 0
    finally:
        ctx.__exit__(None, None, None)


def cmd_xref(args) -> int:
    ctx, prog = abrir(cual_programa(args))
    try:
        addr = a_dir(prog, args.direccion)
        fm = prog.getFunctionManager()
        refs = list(prog.getReferenceManager().getReferencesTo(addr))
        print(f"  {len(refs)} referencias a 0x{args.direccion:08X}")
        for r in refs[:args.max]:
            desde = r.getFromAddress()
            f = fm.getFunctionContaining(desde)
            print(f"    0x{desde.getOffset():08X}  {r.getReferenceType()}"
                  f"   {f.getName() if f else '-'}")
        return 0
    finally:
        ctx.__exit__(None, None, None)


# --------------------------------------------------------------------------
# La RAM viva adentro de Ghidra
# --------------------------------------------------------------------------


def _jbytes(datos: bytes):
    """bytes de Python -> byte[] de Java, sin copiar de a uno."""
    import jpype
    try:
        return jpype.JArray(jpype.JByte)(datos)
    except Exception:
        import numpy as np
        return jpype.JArray(jpype.JByte)(np.frombuffer(datos, dtype=np.int8))


def _copiar_programa(proyecto, monitor, rehacer: bool) -> str:
    """
    Deja `/SLUS_213.76_estado` listo como copia del programa limpio.

    Se copia a propósito: el savestate PISA `.data`, `.sdata` y `.bss` con los
    valores vivos, y el control positivo de `info` tiene que poder seguir
    corriendo contra el ELF tal como salió del ISO.
    """
    raiz = proyecto.getProjectData().getRootFolder()
    nom_orig = PROGRAMA.lstrip("/")
    nom_dest = PROGRAMA_ESTADO.lstrip("/")
    existente = raiz.getFile(nom_dest)
    if existente is not None and rehacer:
        existente.delete()
        existente = None
    if existente is not None:
        return "reusada"
    orig = raiz.getFile(nom_orig)
    if orig is None:
        raise SystemExit(f"no existe {PROGRAMA} en {PROYECTOS}/{PROYECTO}")
    # `createFile` NO tiene overload que tome un DomainFile: sus dos firmas son
    # (String, DomainObject, TaskMonitor) y (String, java.io.File, TaskMonitor).
    # Para duplicar un programa del proyecto va `copyTo`, que elige el nombre
    # solo, y después se renombra.
    nuevo = orig.copyTo(raiz, monitor)
    nuevo.setName(nom_dest)
    return "creada"


def _cargar_ee(prog, datos: bytes, monitor):
    """
    Mete los 32 MB del savestate en los bloques escribibles y crea `.other`
    con todo el resto de la RAM — que es donde vive el heap.

    Réplica de `PCSX2SaveStateImporter.java` de la extensión, con dos arreglos:
    sólo toca bloques del espacio de direcciones por defecto (el script de la
    extensión no filtra, y los pseudo-bloques del ELF arrancan todos en 0), y
    no escribe un bloque que se pase del final del buffer.
    """
    import jpype
    from java.io import ByteArrayInputStream

    mem = prog.getMemory()
    espacio = prog.getAddressFactory().getDefaultAddressSpace()
    n = len(datos)
    tocados, saltados = [], []
    tope = 0

    for b in list(mem.getBlocks()):
        ini = b.getStart()
        if ini.getAddressSpace() != espacio or b.isOverlay():
            continue
        fin = b.getEnd().getOffset()
        if fin > tope and fin < MAX_DIR_EE:
            tope = fin
        if not (b.isWrite() and not b.isExecute()):
            continue
        off = int(ini.getOffset())
        tam = int(b.getSize())
        if off + tam > n:
            saltados.append((str(b.getName()), off, tam))
            continue
        if not b.isInitialized():
            b = mem.convertToInitialized(b, jpype.JByte(0))
            b.setRead(True)
            b.setWrite(True)
        b.putBytes(b.getStart(), _jbytes(datos[off:off + tam]))
        tocados.append((str(b.getName()), off, tam))

    inicio_otro = tope + 1
    heap = 0
    if inicio_otro < n:
        resto = datos[inicio_otro:n]
        heap = len(resto)
        dir_otro = espacio.getAddress(inicio_otro)
        existente = mem.getBlock(".other")
        if existente is None:
            blk = mem.createInitializedBlock(
                ".other", dir_otro, ByteArrayInputStream(_jbytes(resto)),
                len(resto), monitor, False)
            blk.setRead(True)
            blk.setWrite(True)
        else:
            existente.putBytes(dir_otro, _jbytes(resto))
    return tocados, saltados, inicio_otro, heap


def _u32(prog, direccion: int) -> int:
    espacio = prog.getAddressFactory().getDefaultAddressSpace()
    return int(prog.getMemory().getInt(espacio.getAddress(direccion))) & 0xFFFFFFFF


def cmd_estado(args) -> int:
    import struct

    import estado as savestates  # el lector de .p2s del proyecto

    ruta = args.savestate or savestates.ultimo_savestate()
    print(f"  savestate  : {ruta}")
    try:
        datos = savestates.leer_ee(ruta)
    except savestates.EstadoError as e:
        print(f"  [MAL] {e}")
        return 1
    print(f"  eeMemory   : {len(datos):,} bytes")

    # El paquete Java `ghidra` no existe hasta que arranca la JVM, y quien la
    # arranca es abrir_proyecto(). El orden de estas dos líneas no es estético.
    proyecto = abrir_proyecto()
    from ghidra.util.task import ConsoleTaskMonitor
    monitor = ConsoleTaskMonitor()
    print(f"  copia      : {PROGRAMA_ESTADO} ({_copiar_programa(proyecto, monitor, args.rehacer)})")

    import pyghidra
    ctx = pyghidra.program_context(proyecto, PROGRAMA_ESTADO)
    prog = ctx.__enter__()
    try:
        with pyghidra.transaction(prog, "cargar savestate de PCSX2"):
            tocados, saltados, inicio_otro, heap = _cargar_ee(prog, datos, monitor)

        print(f"\n  bloques pisados con la RAM viva ({len(tocados)}):")
        for nom, off, tam in tocados:
            print(f"    {nom:<20} 0x{off:08X}  {tam:>10,} B")
        for nom, off, tam in saltados:
            print(f"    {nom:<20} 0x{off:08X}  {tam:>10,} B   SALTADO (fuera del buffer)")
        print(f"\n  .other (el heap)     0x{inicio_otro:08X}  {heap:>10,} B")

        print(f"\n  === CONTROL POSITIVO del cargador ===")
        print("  Dos hechos de la Fase 2, confirmados por efecto, que viven en el HEAP.")
        clase = _u32(prog, CTL_JUGADOR + CTL_CLASE_EN)
        crudo = _u32(prog, CTL_VIDA)
        vida = struct.unpack("<f", struct.pack("<I", crudo))[0]
        ok_clase = clase == CTL_CLASE_JUGADOR
        ok_vida = 0.0 < vida <= 1200.0
        print(f"  jugador+0x10 = 0x{clase:08X}  (esperado 0x{CTL_CLASE_JUGADOR:08X})"
              f"  -> {'SI -> BIEN' if ok_clase else 'NO -> SOSPECHAR'}")
        print(f"  vida 0x{CTL_VIDA:08X} = {vida:.2f}"
              f"  -> {'SI -> BIEN' if ok_vida else 'NO -> SOSPECHAR'}")

        if ok_clase and ok_vida:
            prog.getDomainFile().save(monitor)
            print(f"\n  guardado. Usalo con --estado:")
            print(f"    python herramientas/decompilar.py c 0x00142B90 --estado")
            return 0
        print("\n  NO se guardó: el control positivo no pasó.")
        return 1
    finally:
        ctx.__exit__(None, None, None)


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Decompilar el ELF de BLACK con Ghidra, desde Python",
        epilog=f"Ghidra: {GHIDRA}\nProyecto: {PROYECTOS}/{PROYECTO}{PROGRAMA}",
        formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--max", type=int, default=60, help="cuántos resultados listar")
    sub = p.add_subparsers(dest="cmd", required=True)

    i = sub.add_parser("info", help="estado del montaje + CONTROL POSITIVO")
    i.set_defaults(func=cmd_info)

    c = sub.add_parser("c", help="decompilar a C la función que contiene una dirección")
    c.add_argument("direccion", type=lambda s: int(s, 0))
    c.set_defaults(func=cmd_c)

    f = sub.add_parser("funciones", help="listar funciones")
    f.add_argument("--desde", type=lambda s: int(s, 0))
    f.add_argument("--hasta", type=lambda s: int(s, 0))
    f.add_argument("--json")
    f.set_defaults(func=cmd_funciones)

    x = sub.add_parser("xref", help="referencias a una dirección, con función contenedora")
    x.add_argument("direccion", type=lambda s: int(s, 0))
    x.set_defaults(func=cmd_xref)

    e = sub.add_parser(
        "estado",
        help="cargar un savestate de PCSX2 encima de una COPIA del programa")
    e.add_argument("--savestate", help="ruta al .p2s (default: el más reciente)")
    e.add_argument("--rehacer", action="store_true",
                   help="descartar la copia anterior y rehacerla desde el ELF limpio")
    e.set_defaults(func=cmd_estado)

    for sp in (c, f, x):
        sp.add_argument("--estado", action="store_true",
                        help="usar la copia con la RAM viva del savestate encima")

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
