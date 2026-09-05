#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
unit.py -- lee `Levels/Level_NN/Unit_NN.bin` con el layout LEIDO AL CARGADOR.

QUE CAMBIA ESTO
    Hasta el 2026-09-05 la geometria de BLACK estaba "sin resolver" y dos vias
    de ataque POR LOS DATOS ya habian muerto por su propio control negativo
    (frecuencia de VIFcodes; caminata de DMAtags). Ver
    kb/formatos-iso.json#geometria_sin_resolver.

    Esto no entra por los datos: entra por el CODIGO. El layout de abajo no se
    dedujo mirando bytes, se leyo en la rutina del ELF que consume el archivo.
    Por eso no hay que adivinar donde empieza nada.

LA CADENA, DESDE LA CADENA DE TEXTO HASTA EL PARSER
    "Levels\\Level_%02u\\Unit_%02d.bin"  esta en 0x003F4508.
    Su unico xref de codigo es el par lui/addiu de 0x0012D72C+0x0012D73C,
    dentro de FUN_0012d5a8 -- la maquina de estados que carga UNA unidad.
    En su estado 2 arma la ruta con sprintf y pide el archivo:

        FUN_001093c0(streamer, ruta, 8, id, CALLBACK, param, 1, 0x40000)
                                             ^^^^^^^^ = FUN_0012e728

    FUN_0012e728 hace lo que hace TODO callback de carga de este juego:

        buf = FUN_001092f8()        // el buffer recien leido (campo +0x11C)
        PARSER(buf)                 // <-- relocaliza el header
        FUN_00108540(mgr, tipo, buf, id)   // lo registra como recurso

    y su PARSER es FUN_0012eae8: recorre el header campo por campo y convierte
    cada u32 de offset-en-archivo a puntero absoluto sumandole la base. Ese
    recorrido ES el layout, y es lo que esta tabulado abajo.

    La misma forma vale para los otros cinco archivos de nivel, y eso es lo
    que da el control positivo: para StUnit el parser es FUN_002886d0, y el
    formato de StUnit YA estaba resuelto por otra via (herramientas/stunit.py).

EL LAYOUT DEL HEADER (de FUN_0012eae8, 0x0012EAE8)
    Todo campo listado es un u32 con un offset RELATIVO AL ARCHIVO. Los
    marcados "siempre" el cargador los suma sin chequear que sean != 0.

        +0x04   seccion, pasa por FUN_00335f20
        +0x08   siempre. FUN_0027e760 (malla: reloca +0x20/+0x24, cuenta u16 +0x28)
        +0x0C   siempre. struct cuyos campos [0] y [1] se relocan CONTRA SI MISMO
        +0x10   seccion, FUN_00335f20
        +0x14   seccion, FUN_00335f20
        +0x18   seccion, FUN_00335f20
        +0x1C   array de count(+0x90) registros de 0x30 -> FUN_00383978.
                Cada registro tiene un id64 en +0x20: FUN_00127738 lo copia
                como primer campo del objeto de 0xF0 que crea en runtime.
        +0x20   siempre. LISTA tipo 1 -> cada elemento a FUN_001af930
        +0x24   siempre. LISTA tipo 0 -> cada elemento a FUN_0028eed8
        +0x28   siempre. LISTA tipo 2 -> cada elemento reloca sus +0x08/+0x0C
        +0x2C   array, cuenta u16 en +0x92
        +0x30   siempre. FUN_00288bc8
        +0x34   array, cuenta u8 en +0x94
        +0x38   FUN_0012eeb8
        +0x3C   FUN_0012eec8
        +0x40   sub-struct: +0x04 count, +0x08 array de 0x20 -> FUN_00383878,
                +0x10 +0x14 +0x50 punteros, FUN_001c64e8(+0x20)
        +0x90   u16  cuenta del array de +0x1C
        +0x92   u16  cuenta del array de +0x2C
        +0x94   u8   cuenta del array de +0x34

LA LISTA (FUN_00272aa8) -- el mismo directorio que usan .DB, LevelDat y StLevel
        lista+0x08  i32  count
        lista+0x0C  i32  offset al array, RELATIVO A LA LISTA
        array[i], 0x10 bytes:
            +0x00  u64  id64 del nombre (id64.py lo decodifica)
            +0x08  i32  offset al recurso, RELATIVO A LA LISTA (no al registro)

QUE HAY EN CADA LISTA, MEDIDO
    tipo 1 = LOS MODELOS CON NOMBRE. En LEVEL_01/UNIT_01 son 367, y los
    nombres se leen: CO01TRUCK, CO01GUARDHUT, CO01FENCE, CO01AMMOBOX,
    CO01WOODBOX, CO01TREE_P_L... o sea los props del nivel.
    tipo 0 = 81 bloques con id NUMERICO (1..81), no nombres.
    tipo 2 = vacia en la unidad medida.

EL HEADER DE UN MODELO (de FUN_001af930, 0x001AF930)
        +0x00  4 floats  (esfera/caja envolvente)
        +0x10  u64       id64
        +0x1C  ptr  array de count(+0x24) registros de 0x30 -> FUN_001c64e8
        +0x20  ptr  array de count(+0x24) i16, indices dentro de +0x38
        +0x2C  f32  +0x30 f32  +0x34 f32   distancias de LOD (30 / 60 / 100)
        +0x38  ptr   +0x40 ptr   +0x64 ptr
        +0x48  ptr  array de count(+0x68, u8) registros de 0xD0.
                    Cada uno reloca sus +0xC0, +0xC4 y +0xC8, y el +0xC0 pasa
                    por FUN_0027e760. El bloque de +0xC0 empieza con una caja
                    envolvente (min xyz, max xyz) -- no es VIF crudo.
        +0x4C  ptr  array de count(+0x50) punteros
        +0x54  ptr   +0x58 ptr
        +0x60  ptr  array de count(+0x5C) punteros

LO QUE SIGUE SIN RESOLVER, Y NO SE DISFRAZA
    Este modulo resuelve el CONTENEDOR y llega hasta el header del modelo.
    NO decodifica todavia los vertices: el grueso de un modelo vive entre su
    +0x58 y su +0x48, y ese bloque no esta desarmado. Lo que cambia es que
    ahora se llega ahi por punteros del propio cargador, no adivinando.

USO
    python herramientas/unit.py niveles
    python herramientas/unit.py header  "D:\\LEVELS\\LEVEL_01\\UNIT_01.BIN"
    python herramientas/unit.py modelos "D:\\LEVELS\\LEVEL_01\\UNIT_01.BIN"
    python herramientas/unit.py modelo  "D:\\LEVELS\\LEVEL_01\\UNIT_01.BIN" CO01TRUCK
    python herramientas/unit.py autotest
"""
from __future__ import annotations

import argparse
import glob
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import id64  # noqa: E402

ISO = "D:\\"          # el ISO original montado; ver kb/ubicaciones.json
PATRON = os.path.join(ISO, "LEVELS", "LEVEL_*", "UNIT_*.BIN")

# (offset, siempre) -- "siempre" = el cargador lo suma SIN chequear que sea !=0
RELOC = [
    (0x04, False), (0x08, True), (0x0C, True), (0x10, False),
    (0x14, False), (0x18, False), (0x1C, False), (0x20, True),
    (0x24, True), (0x28, True), (0x2C, False), (0x30, True),
    (0x34, False), (0x38, False), (0x3C, False), (0x40, False),
]
CONTEOS = [(0x90, "H", "array de 0x30 de +0x1C"),
           (0x92, "H", "array de +0x2C"),
           (0x94, "B", "array de +0x34")]
LISTAS = {0x24: "tipo 0", 0x20: "tipo 1 (modelos)", 0x28: "tipo 2"}
REG_0X1C = 0x30       # tamano de registro del array de +0x1C (FUN_0012eae8)
REG_LISTA = 0x10      # tamano de registro del array de una lista (FUN_00272aa8)


class Unidad:
    def __init__(self, ruta: str):
        self.ruta = ruta
        with open(ruta, "rb") as f:
            self.d = f.read()
        self.tam = len(self.d)

    def u32(self, o): return struct.unpack_from("<I", self.d, o)[0]
    def i32(self, o): return struct.unpack_from("<i", self.d, o)[0]
    def u16(self, o): return struct.unpack_from("<H", self.d, o)[0]
    def u64(self, o): return struct.unpack_from("<Q", self.d, o)[0]
    def f32(self, o): return struct.unpack_from("<f", self.d, o)[0]

    def cuenta(self, off):
        """Un conteo del header, leido con el ancho que declara CONTEOS. Pasa
        por aca y no por u16() directo para que el ancho sea LOAD-BEARING: si
        alguien lo cambia, el autotest se tiene que enterar."""
        f = next(f for o, f, _ in CONTEOS if o == off)
        return struct.unpack_from("<" + f, self.d, off)[0]

    # ---- el chequeo que decide si el layout cierra -----------------------
    def problemas(self) -> list[str]:
        p = []
        for off, siempre in RELOC:
            v = self.u32(off)
            if v == 0:
                if siempre:
                    p.append(f"+0x{off:02X} es obligatorio y vale 0")
                continue
            if not (0 < v < self.tam):
                p.append(f"+0x{off:02X} = 0x{v:X} cae fuera del archivo")
        # El array de +0x1C tiene que TERMINAR EXACTAMENTE donde arranca la
        # lista de +0x24. Eso ata tres cosas independientes -- el offset, la
        # cuenta y el tamano de registro (0x30) -- en vez de solo pedir que
        # entre en el archivo, que casi cualquier numero chico cumple.
        # Medido: se cumple en las 42 unidades del ISO.
        a, n = self.u32(0x1C), self.cuenta(0x90)
        if a:
            fin = a + n * REG_0X1C
            if fin > self.tam:
                p.append(f"el array de +0x1C ({n} x 0x{REG_0X1C:X}) se pasa del archivo")
            elif fin != self.u32(0x24):
                p.append(f"el array de +0x1C termina en 0x{fin:X} y la lista "
                         f"de +0x24 arranca en 0x{self.u32(0x24):X}: no pegan")
        # y cada lista tiene que ser una lista coherente
        for off in LISTAS:
            v = self.u32(off)
            if not (0 < v < self.tam - 0x10):
                p.append(f"la lista de +0x{off:02X} no apunta adentro")
                continue
            try:
                n = self.i32(v + 8)
                arr = v + self.i32(v + 0xC)
            except struct.error:
                p.append(f"la lista de +0x{off:02X} no se puede leer")
                continue
            if n < 0 or not (0 <= arr <= self.tam) or arr + n * REG_LISTA > self.tam:
                p.append(f"la lista de +0x{off:02X}: count={n} array=0x{arr:X} incoherente")
        return p

    # ---- listas ----------------------------------------------------------
    def lista(self, campo: int):
        """[(id64, nombre, ptr_absoluto)] de la lista declarada en `campo`."""
        L = self.u32(campo)
        n = self.i32(L + 8)
        arr = L + self.i32(L + 0xC)
        out = []
        for i in range(n):
            e = arr + i * REG_LISTA
            v = self.u64(e)
            out.append((v, id64.decodificar(v).strip(), L + self.i32(e + 8)))
        return out

    def modelos(self):
        return self.lista(0x20)

    def modelo(self, p: int) -> dict:
        m = {"dir": p,
             "envolvente": [self.f32(p + k) for k in (0, 4, 8, 0xC)],
             "id64": id64.decodificar(self.u64(p + 0x10)).strip(),
             "n_0x30": self.i32(p + 0x24),
             "lod": [self.f32(p + k) for k in (0x2C, 0x30, 0x34)],
             "n_submallas": self.d[p + 0x68],
             "n_0x50": self.i32(p + 0x50),
             "n_0x5C": self.i32(p + 0x5C)}
        for c in (0x1C, 0x20, 0x38, 0x40, 0x48, 0x4C, 0x54, 0x58, 0x60, 0x64):
            v = self.i32(p + c)
            m[f"+0x{c:02X}"] = (p + v) if v else 0
        return m


def unidades():
    return sorted(glob.glob(PATRON))


# --------------------------------------------------------------------------


def cmd_niveles(a):
    us = unidades()
    for r in us:
        u = Unidad(r)
        p = u.problemas()
        print(f"  [{'OK   ' if not p else 'FALLA'}] {r:<34} {u.tam:>10,}  "
              f"modelos={len(u.modelos()):<4} objetos(+0x90)={u.u16(0x90)}"
              + ("" if not p else "   " + "; ".join(p)))
    print(f"\n  {len(us)} unidades")
    return 0


def cmd_header(a):
    u = Unidad(a.ruta)
    print(f"{a.ruta}   ({u.tam:,} bytes)")
    for off, _ in RELOC:
        v = u.u32(off)
        nota = LISTAS.get(off, "")
        estado = "cero " if v == 0 else ("ok   " if 0 < v < u.tam else "FUERA")
        print(f"   +0x{off:02X}  0x{v:08X}  {estado}  {nota}")
    for off, f, que in CONTEOS:
        v = struct.unpack_from("<" + f, u.d, off)[0]
        print(f"   +0x{off:02X}  {v:6d}      {que}")
    p = u.problemas()
    print("\n  layout: " + ("CIERRA" if not p else "NO cierra -> " + "; ".join(p)))
    return 0


def cmd_modelos(a):
    u = Unidad(a.ruta)
    ms = u.modelos()
    for i, (_, nom, p) in enumerate(ms):
        sig = ms[i + 1][2] if i + 1 < len(ms) else None
        tam = f"{sig - p:>9,}" if sig else "        ?"
        print(f"  [{i:4}] {nom:<14} 0x{p:07X}  {tam}")
    print(f"\n  {len(ms)} modelos")
    return 0


def cmd_modelo(a):
    u = Unidad(a.ruta)
    for _, nom, p in u.modelos():
        if nom.upper() == a.nombre.upper():
            m = u.modelo(p)
            print(f"{nom}  @0x{p:07X}")
            for k, v in m.items():
                print(f"   {k:<12} {v if not isinstance(v, int) or k in ('n_0x30','n_submallas','n_0x50','n_0x5C') else hex(v)}")
            return 0
    print(f"no esta: {a.nombre}")
    return 1


def cmd_autotest(a):
    """Positivos: TODAS las unidades del ISO. Negativos: el mismo layout sobre
    archivos que seguro no son unidades. Sin la segunda mitad esto no
    discrimina nada -- es la leccion de las dos vias muertas."""
    ok = True
    us = unidades()
    fallan = [r for r in us if Unidad(r).problemas()]
    print(f"  positivos : {len(us) - len(fallan)}/{len(us)} unidades cierran")
    for r in fallan:
        print(f"     FALLA {r}: {Unidad(r).problemas()}")
    ok &= not fallan and len(us) > 0

    negativos = [os.path.join(ISO, *p) for p in (
        ("LEVELS", "LEVEL_01", "LEVELDAT.BIN"),
        ("LEVELS", "LEVEL_01", "LEVEL.AWD"),
        ("LEVELS", "LEVEL_01", "COLLIDE.AWD"),
        ("LEVELS", "LEVEL_01", "AMBIENCE.BKS"),
        ("GLOBDATA.BIN",),
        ("SLUS_213.76",),
    )] + sorted(glob.glob(os.path.join(ISO, "*", "*.M2V")))[:2]
    pasan = []
    for r in negativos:
        if not os.path.exists(r):
            continue
        p = Unidad(r).problemas()
        print(f"  negativo  : {'PASA (mal)' if not p else 'cae, bien'}  "
              f"{os.path.basename(r):<16} ({len(p)} problemas)")
        if not p:
            pasan.append(r)
    ok &= not pasan

    # control cruzado: los modelos tienen que tener nombre legible.
    # Va en try porque si el layout NO cierra esto revienta con struct.error, y
    # un autotest que muere con traceback en vez de decir ROJO no sirve de
    # alarma: lo encontro el saboteador 3 (apuntar los positivos a los .AWD).
    try:
        u = Unidad(us[0])
        ms = u.modelos()
        legibles = sum(1 for _, n, _ in ms
                       if n and all(32 <= ord(c) < 127 for c in n))
        print(f"  cruzado   : {legibles}/{len(ms)} nombres de modelo legibles en "
              f"{os.path.basename(us[0])}")
        ok &= legibles == len(ms) and len(ms) > 0
    except (struct.error, IndexError, IsADirectoryError, OSError) as e:
        print(f"  cruzado   : NO SE PUDO LEER -> {type(e).__name__}: {e}")
        ok = False

    print("\n  " + ("AUTOTEST OK" if ok else "AUTOTEST EN ROJO"))
    return 0 if ok else 1


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("niveles").set_defaults(f=cmd_niveles)
    for nombre, f in (("header", cmd_header), ("modelos", cmd_modelos)):
        p = sub.add_parser(nombre); p.add_argument("ruta"); p.set_defaults(f=f)
    p = sub.add_parser("modelo")
    p.add_argument("ruta"); p.add_argument("nombre"); p.set_defaults(f=cmd_modelo)
    sub.add_parser("autotest").set_defaults(f=cmd_autotest)
    a = ap.parse_args(argv)
    return a.f(a)


if __name__ == "__main__":
    sys.exit(main())
