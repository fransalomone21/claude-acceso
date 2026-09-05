#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
stunit.py -- lee el STREAM DE MODULOS de un nivel DIRECTO DEL ARCHIVO del ISO.

QUE CAMBIA ESTO
    Hasta el 2026-09-05 el stream de modulos de un nivel solo se podia leer
    sobre un VOLCADO DE MEMORIA: habia que abrir el emulador, jugar hasta
    cargar el nivel, volcar 32 MB y buscar el descriptor con una heuristica.
    Eso limitaba todo el trabajo de niveles a LEVEL_00, que es el unico nivel
    del que hay volcados.

    Este modulo lo lee en FRIO, de `Levels/Level_NN/Stg_NNNN/StUnitNN.bin`, sin
    emulador y para CUALQUIER nivel. Con eso, "cuantos enemigos hay en el
    nivel 5" pasa de ser una sesion de trabajo a ser un comando.

EL FORMATO, Y COMO SE DEDUJO
    La clave estaba en el header, que nadie habia mirado:

        +0x00  u32  3          magia / version
        +0x04  u32  off_desc   OFFSET DEL DESCRIPTOR dentro del archivo
        +0x08  u32  0x80       SEGUNDO OFFSET, no una alineacion (ver abajo)

    CORREGIDO EL 2026-09-05: el +0x08 estaba anotado aca como "alineacion".
    No lo es. El parser de StUnit en el ELF es FUN_002886d0 (0x002886D0) y
    trata +0x04 y +0x08 EXACTAMENTE IGUAL: a los dos les suma la base del
    archivo y despues los usa como punteros -- FUN_00287120(+0x04) y
    FUN_00288a38(+0x08). Que valga 0x80 es porque esa seccion arranca justo
    despues del header, no porque el campo sea de alineacion. Salio de usar
    StUnit como control positivo del metodo con el que se resolvio
    Unit_NN.bin (ver herramientas/unit.py): el control positivo devolvio una
    correccion ademas de una confirmacion.

    Y en el descriptor:

        off_desc + 0x00  u32  count
        off_desc + 0x04  u32  rel_array   <- RELATIVO AL DESCRIPTOR, no al archivo

    El array son `count` registros de 0x10, el layout que la fase 7e ya tenia
    medido contra memoria:

        +0x00  u32  tipo   (el case del switch de FUN_0015ef48)
        +0x04  i32  ptr    (blob de datos del modulo, offset CON SIGNO relativo
                            AL ARRAY -- no al descriptor. Siempre negativo,
                            porque los blobs estan entre el descriptor y el
                            array, o sea antes del array.)
        +0x08  u64  id64   (nombre del modulo; id64.py lo decodifica)

    CONTROL POSITIVO, y es exacto: para LEVEL_00 el header da off_desc =
    0x3F800, y 0x01053000 + 0x3F800 = 0x01092800, que es EXACTAMENTE la
    direccion del descriptor medida en RAM en la fase 7e. El count del archivo
    da 857, que es EXACTAMENTE el count medido. Y 0x3F800 + 0xCD90 = 0x4C590,
    o sea 0x01053000 + 0x4C590 = 0x0109F590, que es EXACTAMENTE la direccion
    del array medida. Tres numeros independientes, los tres al bit.

    Que los punteros sean relativos AL DESCRIPTOR y no al archivo es lo que
    hacia que un barrido ingenuo no encontrara nada: buscar rachas de
    registros con puntero monotono desde el offset 0 del archivo da CERO.

USO
    python herramientas/stunit.py niveles
    python herramientas/stunit.py resumen LEVEL_00
    python herramientas/stunit.py listar LEVEL_00 --tipo 0x0A
    python herramientas/stunit.py autotest
"""
from __future__ import annotations

import argparse
import glob
import os
import struct
import sys
from collections import Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ISO = "D:\\"          # el ISO original montado; ver kb/ubicaciones.json

# El unico nivel con volcados de memoria, y por eso el unico con control
# positivo directo. Los tres numeros salen de la fase 7e.
CONTROL = {
    "nivel": "LEVEL_00", "archivo": "STUNIT01.BIN",
    "base_carga": 0x01053000, "desc_mem": 0x01092800,
    "array_mem": 0x0109F590, "count": 857,
}


class Registro:
    __slots__ = ("indice", "tipo", "ptr", "id64", "off_blob", "largo_blob")

    def __init__(self, indice, tipo, ptr, id64):
        self.indice, self.tipo, self.ptr, self.id64 = indice, tipo, ptr, id64
        self.off_blob = None
        self.largo_blob = None


class Stream:
    def __init__(self, ruta):
        self.ruta = ruta
        self.datos = open(ruta, "rb").read()
        d = self.datos
        if len(d) < 12:
            raise ValueError(f"{ruta}: demasiado chico")
        self.magia, self.off_desc, self.alineacion = struct.unpack_from("<III", d, 0)
        if self.magia != 3:
            raise ValueError(f"{ruta}: magia {self.magia}, se esperaba 3")
        if self.off_desc + 8 > len(d):
            raise ValueError(f"{ruta}: descriptor fuera del archivo")
        self.count, rel = struct.unpack_from("<II", d, self.off_desc)
        self.off_array = self.off_desc + rel
        if self.off_array + 16 * self.count > len(d):
            raise ValueError(f"{ruta}: el array no entra ({self.count} registros)")
        self.registros = []
        for i in range(self.count):
            # el puntero es un i32: en LEVEL_00 el primero vale 0xFFFF3320, que
            # como unsigned da una direccion fuera del archivo y como signed da
            # -52448 -> 0x3F800 - 0xCCE0 = 0x32B20, que si cae adentro.
            t, p, lo, hi = struct.unpack_from("<IiII", d, self.off_array + i * 16)
            r = Registro(i, t, p, (hi << 32) | lo)
            o = self.off_array + p
            r.off_blob = o if 0 <= o < len(d) else None
            self.registros.append(r)
        # los blobs TESELAN la region entre el descriptor y el array, en orden
        # ascendente estricto: el largo de cada uno es la distancia al siguiente.
        # varios registros consecutivos pueden compartir el MISMO blob (p. ej.
        # los cuatro 0x1C de los indices 10-13 en LEVEL_00), asi que el largo
        # sale de la distancia al siguiente offset DISTINTO, no al siguiente
        # registro.
        offs = sorted({r.off_blob for r in self.registros if r.off_blob is not None})
        fin = {}
        for a, b in zip(offs, offs[1:]):
            fin[a] = b - a
        if offs:
            fin[offs[-1]] = max(0, self.off_array - offs[-1])
        for r in self.registros:
            if r.off_blob is not None:
                r.largo_blob = fin.get(r.off_blob)

    def coherente(self):
        """Los dos invariantes que la fase 7e midio contra memoria."""
        fallas = []
        # NO ESTRICTA: registros consecutivos comparten blob a proposito.
        prev = None
        for r in self.registros:
            if r.off_blob is None:
                fallas.append(f"registro {r.indice}: blob fuera del archivo")
                break
            if prev is not None and r.off_blob < prev:
                fallas.append(f"registro {r.indice}: offset de blob RETROCEDE")
                break
            prev = r.off_blob
        # EL INVARIANTE QUE ATRAPA UN ERROR DE BASE. La primera version de este
        # modulo usaba el DESCRIPTOR como base en vez del array, y los tres
        # chequeos que tenia -- count, direccion del descriptor, direccion del
        # array -- pasaban igual, porque un corrimiento constante no cambia
        # ninguno de los tres, y tampoco rompe la monotonia. Lo que si lo
        # delata es la RELACION entre los blobs y las otras dos estructuras:
        # los blobs teselan la region que va del descriptor al array, asi que
        # el primero tiene que caer DESPUES del descriptor y el ultimo tiene
        # que terminar EN el array.
        conblob = [r for r in self.registros if r.off_blob is not None]
        if conblob:
            primero = min(r.off_blob for r in conblob)
            if primero <= self.off_desc:
                fallas.append(f"el primer blob (0x{primero:X}) no cae despues del "
                              f"descriptor (0x{self.off_desc:X}): la base esta mal")
            ultimo = max(r.off_blob for r in conblob)
            if ultimo >= self.off_array:
                fallas.append(f"el ultimo blob (0x{ultimo:X}) invade el array "
                              f"(0x{self.off_array:X})")
        fuera = [r.indice for r in self.registros if r.tipo > 0x45]
        if fuera:
            fallas.append(f"{len(fuera)} registros con tipo fuera de la tabla de saltos (>0x45)")
        return fallas

    def histograma(self):
        return Counter(r.tipo for r in self.registros)


def niveles():
    """Todos los StUnit del ISO, por nivel y stage."""
    out = []
    for p in sorted(glob.glob(os.path.join(ISO, "LEVELS", "*", "STG_*", "STUNIT*.BIN"))):
        partes = p.replace("\\", "/").split("/")
        out.append((partes[-3], partes[-2], partes[-1], p))
    return out


def cmd_niveles(args):
    print(f"{'nivel':<10} {'stage':<10} {'archivo':<14} {'bytes':>9} {'modulos':>8}  tipos")
    for niv, stg, arch, p in niveles():
        try:
            s = Stream(p)
            n, t = s.count, len(s.histograma())
            estado = "" if not s.coherente() else "  <- INCOHERENTE"
        except Exception as e:
            n, t, estado = "-", "-", f"  <- {e}"
        print(f"{niv:<10} {stg:<10} {arch:<14} {os.path.getsize(p):>9} {n:>8}  {t}{estado}")


def _ruta(nivel, stage, archivo):
    p = os.path.join(ISO, "LEVELS", nivel, stage, archivo)
    if not os.path.exists(p):
        raise SystemExit(f"No existe: {p}")
    return p


def cmd_resumen(args):
    s = Stream(_ruta(args.nivel, args.stage, args.archivo))
    print(f"{s.ruta}   {len(s.datos)} B")
    print(f"  header      magia={s.magia} off_desc=0x{s.off_desc:X} alineacion=0x{s.alineacion:X}")
    print(f"  descriptor  count={s.count} array en 0x{s.off_array:X}")
    fallas = s.coherente()
    print(f"  coherencia  {'OK (punteros monotonos, tipos en rango)' if not fallas else fallas}")
    print()
    print("  tipo   instancias   bytes de blob")
    h = s.histograma()
    porTipo = {}
    for r in s.registros:
        porTipo.setdefault(r.tipo, 0)
        porTipo[r.tipo] += (r.largo_blob or 0)
    for t, n in sorted(h.items(), key=lambda kv: -kv[1]):
        print(f"   0x{t:02X}   {n:>10}   {porTipo[t]:>13}")
    print(f"\n  {s.count} modulos, {len(h)} tipos distintos")


def cmd_listar(args):
    import id64 as m_id64
    s = Stream(_ruta(args.nivel, args.stage, args.archivo))
    tipo = int(args.tipo, 0) if args.tipo else None
    n = 0
    print("  idx   tipo   off_blob   largo   id64                nombre")
    for r in s.registros:
        if tipo is not None and r.tipo != tipo:
            continue
        nom = ""
        try:
            nom = m_id64.decodificar(r.id64) or ""
        except Exception:
            nom = ""
        print(f"  {r.indice:>5}  0x{r.tipo:02X}   0x{(r.off_blob or 0):06X}  {(r.largo_blob or 0):>6}"
              f"   0x{r.id64:016X}  {nom}")
        n += 1
        if args.max and n >= args.max:
            print(f"  ... (cortado en {args.max}; --max 0 para todos)")
            break
    print(f"\n  {n} registros")


def cmd_autotest(args):
    """El control positivo es el nivel del que HAY mediciones en RAM, y los
    sabotajes son la mitad que hace que el control valga algo."""
    ok = True
    p = _ruta(CONTROL["nivel"], "STG_0001", CONTROL["archivo"])
    s = Stream(p)

    def chequeo(nombre, obtenido, esperado):
        nonlocal ok
        bien = obtenido == esperado
        ok = ok and bien
        print(f"  [{'OK ' if bien else 'MAL'}] {nombre}: {obtenido}"
              f"{'' if bien else f'  (se esperaba {esperado})'}")

    print("CONTROL POSITIVO -- contra lo medido en RAM en la fase 7e")
    chequeo("count del archivo", s.count, CONTROL["count"])
    chequeo("direccion del descriptor en RAM",
            hex(CONTROL["base_carga"] + s.off_desc), hex(CONTROL["desc_mem"]))
    chequeo("direccion del array en RAM",
            hex(CONTROL["base_carga"] + s.off_array), hex(CONTROL["array_mem"]))
    chequeo("punteros monotonos y tipos en rango", s.coherente(), [])

    print("\nSABOTAJES -- un chequeo que nunca dijo que no, no dice nada")
    import io
    d = bytearray(s.datos)
    casos = [
        ("magia rota", 0, b"\x09\x00\x00\x00"),
        ("offset del descriptor fuera del archivo", 4, struct.pack("<I", len(d) + 1)),
        ("count absurdo", s.off_desc, struct.pack("<I", 0x7FFFFFFF)),
    ]
    for nombre, off, parche in casos:
        d2 = bytearray(d)
        d2[off:off + len(parche)] = parche
        tmp = os.path.join(os.environ.get("TEMP", "."), "_stunit_sabotaje.bin")
        open(tmp, "wb").write(bytes(d2))
        try:
            Stream(tmp)
            print(f"  [MAL] {nombre}: NO se quejo")
            ok = False
        except Exception as e:
            print(f"  [OK ] {nombre}: rechazado ({str(e).split(': ',1)[-1]})")
        finally:
            try:
                os.remove(tmp)
            except OSError:
                pass

    print("\n" + ("TODO OK" if ok else "HAY FALLAS"))
    return 0 if ok else 1


def main():
    global ISO
    ap = argparse.ArgumentParser(description="Lee el stream de modulos de un nivel, del ISO")
    ap.add_argument("--iso", default=ISO, help="raiz del ISO montado (por defecto D:\\)")
    sub = ap.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("niveles", help="todos los StUnit del ISO, con su cuenta de modulos")
    a.set_defaults(f=cmd_niveles)

    for nombre, fn, ayuda in (("resumen", cmd_resumen, "histograma de tipos de un nivel"),
                              ("listar", cmd_listar, "los registros, opcionalmente de un tipo")):
        b = sub.add_parser(nombre, help=ayuda)
        b.add_argument("nivel")
        b.add_argument("--stage", default="STG_0001")
        b.add_argument("--archivo", default="STUNIT01.BIN")
        if nombre == "listar":
            b.add_argument("--tipo", default=None, help="por ejemplo 0x0A")
            b.add_argument("--max", type=int, default=40, help="0 = todos")
        b.set_defaults(f=fn)

    c = sub.add_parser("autotest", help="control positivo contra RAM + tres sabotajes")
    c.set_defaults(f=cmd_autotest)

    args = ap.parse_args()
    ISO = args.iso
    r = args.f(args)
    sys.exit(r or 0)


if __name__ == "__main__":
    main()
