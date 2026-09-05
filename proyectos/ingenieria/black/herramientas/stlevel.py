#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
stlevel.py -- el DIRECTORIO DE ARMAS de cada nivel, leido y escrito en frio.

QUE ABRE ESTO
    Cada nivel de BLACK trae en `Stg_0001/StLevel.bin` una lista corta de las
    armas que EXISTEN en ese nivel. Es un directorio de entradas de 0x28 bytes
    con el nombre en claro, y el header dice cuantas hay. Cambiar un nombre
    cambia el arma que aparece.

    Y lo que lo hace barato: cada nivel ya TRAE en su carpeta `FPGUNS` entre 16
    y 20 modelos de arma, pero solo habilita entre 4 y 11. O sea que hay armas
    que ya viajan en el disco, con su modelo y sus texturas, y que ese nivel no
    usa. Cambiar `bg1_pst` por `bg1_snr` en el nivel 1 no agrega un solo byte
    al ISO: el rifle de francotirador ya esta ahi.

EL FORMATO, MEDIDO
    StLevel.bin, header:
        +0x00  u32  10          version
        +0x04  u32  0x80        OFFSET del directorio de armas
        +0x08  u32  n           CUANTAS armas tiene el nivel
        +0x0C  u32  ?           sin identificar
        +0x10  u32  ?           cerca del tamano del archivo, sin confirmar

    Directorio, entradas de 0x28 -- RESUELTO ENTERO el 2026-09-05:
        +0x00  char[0x10]  nombre. Forma [NNNN_]bg1_XXX; NNNN es <nivel><stage>
        +0x10  u64         id64 del MODELO (BG1_AK1, BG1_ASR, ...)
        +0x18  i32         puntero al array de variantes ENEMIGAS
        +0x1C  i32         puntero al array de variantes de COMPANERO
        +0x20  u32         cuantas variantes enemigas
        +0x24  u32         cuantas variantes de companero

    LOS PUNTEROS SON RELATIVOS AL INICIO DE SU PROPIA ENTRADA, no al archivo
    ni al directorio. Como se supo: los punteros "basura" de los slots sin
    variantes bajan exactamente 0x28 por slot -- el paso de la entrada -- asi
    que sumandoles el offset de la ENTRADA dan todos el mismo centinela,
    0xFDC5FF80. Con esa misma base, los punteros de verdad caen todos
    alineados a 0x80 (0x200, 0x300, 0x400, 0x500, 0x680, 0x800, 0x900). Dos
    invariantes independientes que apuntan a la misma base.

    OJO CON EL 0x680: seis de los siete arrays caen alineados a 0x100 y es
    tentador escribir "alineados a 0x100" -- el autotest lo dijo en rojo a la
    primera. La alineacion real es 0x80. Ese uno solo que no encaja es tambien
    la razon por la que el PASO de los registros dentro de un array no esta
    confirmado: con dos elementos, el array del slot 3 va de 0x500 a 0x680 y
    el del slot 4 arranca ahi, lo que da 0xB0 en RAM pero no cierra a 0x100 en
    el archivo. El paso en el ARCHIVO queda como hipotesis.

    DE DONDE SALE LA SEMANTICA: de FUN_001e2d38 (0x001E2D38), decompilada.
    Recorre `param_2+0x08` entradas de paso 0x28 desde `param_2+0x04` -- que es
    EXACTAMENTE el header de StLevel.bin -- y por cada una recorre dos arrays
    de registros de 0xB0: `+0x18` con `+0x20` elementos, a los que les arma el
    nombre con "Enemy%d_%s", y `+0x1C` con `+0x24`, con "Team%d_%s". El `%s`
    sale de `FUN_001e3018(record+0x88)`, que resuelve contra la tabla de siete
    nombres de 0x003BD3F8: None, Low, Mid, High, Matt, Tom, Carrie.

    Y de cada registro registra `+0x94` en la ValueDB de sonido
    (`../Export/ValueDB/Sound/ps2/AIWeapon.cfg`). CONTROL: en el archivo, a
    +0x94 del primer registro hay exactamente floats de parametro --
    0.071, 1.0, 10.0, 100.0, 20.0, 0.6 -- y no ceros ni punteros.

    QUE SIGNIFICA. Este es el mapa de QUE ARMA USA CADA CLASE DE ENEMIGO en
    cada nivel, y cuantas variantes de cada una hay. En LEVEL_00: la pistola,
    la escopeta, la SMG, el RPG y la SM5 tienen UNA variante enemiga cada una,
    la AK1 tiene DOS, y el ASR no lo usa ningun enemigo -- lo usan los DOS
    companeros.

    El nombre SIN el prefijo `NNNN_` es el que tiene que existir como
    `Levels/Level_NN/FpGuns/BG1_XXX.wdd`. El prefijo es la instancia del nivel.

COMO SE LLEGO
    El kb ya tenia "Directorio de recursos de arma del stage, dentro de
    STLEVEL" en 0x01412480, medido en RAM. Restando la base de carga de
    STLEVEL.BIN (0x01412400, tambien del kb) da el offset 0x80 -- y ese 0x80
    esta LITERALMENTE en el header, en +0x04. El 7 de +0x08 es la cantidad, y
    coincide con las 7 entradas legibles antes del primer hueco.

USO
    python herramientas/stlevel.py catalogo
    python herramientas/stlevel.py armas LEVEL_00
    python herramientas/stlevel.py autotest
    python herramientas/stlevel.py cambiar --iso copia.iso --nivel LEVEL_00 \
        --slot 0 --arma bg1_snr
"""
from __future__ import annotations

import argparse
import glob
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

ISO_MONTADO = "D:\\"
PASO = 0x28
LARGO_NOMBRE = 0x20

# Control positivo: sale de kb/mapa-memoria.json, medido en RAM antes de que
# este modulo existiera.
CONTROL = {
    "nivel": "LEVEL_00",
    "base_carga": 0x01412400,
    "directorio_mem": 0x01412480,
    "n_armas": 7,
    "primera": "bg1_pst",
}


class StLevel:
    def __init__(self, ruta=None, datos=None):
        self.ruta = ruta
        self.datos = datos if datos is not None else open(ruta, "rb").read()
        d = self.datos
        if len(d) < 0x20:
            raise ValueError("demasiado chico")
        self.version, self.off_dir, self.n, self.c, self.tam = struct.unpack_from("<5I", d, 0)
        if self.version != 10:
            raise ValueError(f"version {self.version}, se esperaba 10")
        if self.off_dir + PASO * self.n > len(d):
            raise ValueError(f"el directorio no entra ({self.n} entradas en 0x{self.off_dir:X})")
        if self.n == 0 or self.n > 64:
            raise ValueError(f"cantidad de armas absurda: {self.n}")
        self.armas = []
        for i in range(self.n):
            o = self.off_dir + i * PASO
            crudo = d[o:o + LARGO_NOMBRE]
            nom = crudo.split(b"\0")[0].decode("latin1")
            a, b = struct.unpack_from("<II", d, o + LARGO_NOMBRE)
            self.armas.append({"slot": i, "offset": o, "nombre": nom, "f1": a, "f2": b})

    @staticmethod
    def modelo(nombre):
        """'0001_bg1_ak1' -> 'bg1_ak1'. El prefijo NNNN_ es la instancia."""
        p = nombre.split("_")
        if p and p[0].isdigit():
            return "_".join(p[1:])
        return nombre


def modelos_del_nivel(nivel, raiz=ISO_MONTADO):
    p = os.path.join(raiz, "LEVELS", nivel, "FPGUNS")
    if not os.path.isdir(p):
        return []
    return sorted(x[:-4].lower() for x in os.listdir(p) if x.upper().endswith(".WDD"))


def niveles(raiz=ISO_MONTADO):
    out = []
    for p in sorted(glob.glob(os.path.join(raiz, "LEVELS", "*", "STG_*", "STLEVEL.BIN"))):
        partes = p.replace("/", "\\").split("\\")
        out.append((partes[-3], partes[-2], p))
    return out


def cmd_catalogo(args):
    print(f"{'nivel':<10} {'usa':>3} {'trae':>4}  armas del nivel")
    faltantes = []
    for niv, stg, p in niveles(args.iso):
        s = StLevel(p)
        disp = modelos_del_nivel(niv, args.iso)
        nombres = [a["nombre"] for a in s.armas]
        for a in s.armas:
            m = StLevel.modelo(a["nombre"])
            if disp and m not in disp:
                faltantes.append((niv, a["nombre"], m))
        print(f"{niv:<10} {s.n:>3} {len(disp):>4}  {', '.join(nombres)}")
    print()
    print("SIN USAR EN CADA NIVEL -- ya viajan en el disco, cambiarlas no agrega nada:")
    for niv, stg, p in niveles(args.iso):
        s = StLevel(p)
        disp = set(modelos_del_nivel(niv, args.iso))
        usados = {StLevel.modelo(a["nombre"]) for a in s.armas}
        libres = sorted(disp - usados)
        print(f"  {niv:<10} {len(libres):>2}  {', '.join(libres)}")
    if faltantes:
        print("\nOJO -- entradas cuyo modelo NO esta en el FPGUNS del nivel:")
        for niv, nom, m in faltantes:
            print(f"  {niv}: {nom} -> falta {m}.wdd")


def cmd_armas(args):
    p = os.path.join(args.iso, "LEVELS", args.nivel, args.stage, "STLEVEL.BIN")
    if not os.path.exists(p):
        raise SystemExit(f"No existe: {p}")
    s = StLevel(p)
    disp = modelos_del_nivel(args.nivel, args.iso)
    print(f"{p}   {len(s.datos)} B")
    print(f"  header: version={s.version} directorio=0x{s.off_dir:X} n={s.n}")
    print()
    print("  slot  offset   nombre                modelo        +0x20  +0x24   en FPGUNS")
    for a in s.armas:
        m = StLevel.modelo(a["nombre"])
        print(f"  {a['slot']:>4}  0x{a['offset']:04X}   {a['nombre']:<20}  {m:<12}"
              f"  {a['f1']:>5}  {a['f2']:>5}   {'si' if m in disp else 'NO'}")
    usados = {StLevel.modelo(a["nombre"]) for a in s.armas}
    print(f"\n  el nivel TRAE {len(disp)} modelos y usa {len(usados)}.")
    print(f"  sin usar: {', '.join(sorted(set(disp) - usados))}")


AMENAZA = ["None", "Low", "Mid", "High", "Matt", "Tom", "Carrie"]


def cmd_enemigos(args):
    """Que arma usa cada clase de enemigo y de companero, por nivel."""
    p = os.path.join(args.iso, "LEVELS", args.nivel, args.stage, "STLEVEL.BIN")
    if not os.path.exists(p):
        raise SystemExit(f"No existe: {p}")
    s = StLevel(p)
    d = s.datos
    print(f"{args.nivel} / {args.stage}")
    print()
    print("  arma            enemigos  companeros   registros")
    tot_e = tot_t = 0
    for a in s.armas:
        o = a["offset"]
        pe, pt, ne, nt = struct.unpack_from("<4I", d, o + 0x18)
        tot_e += ne
        tot_t += nt
        dirs = []
        for ptr, cnt in ((pe, ne), (pt, nt)):
            for k in range(cnt):
                dirs.append(f"0x{(o + ptr + k * 0x100) & 0xFFFFFFFF:06X}")
        print(f"  {a['nombre']:<15} {ne:>8}  {nt:>10}   {' '.join(dirs)}")
    print()
    print(f"  {tot_e} variantes enemigas y {tot_t} de companero en este nivel.")
    print("  El puntero de un array vacio es un centinela: sumado al offset de")
    print("  su ENTRADA da siempre 0xFDC5FF80.")


def cmd_cambiar(args):
    """Escribe un nombre nuevo en el directorio, DENTRO DE UNA COPIA del ISO."""
    from lbas import SECTOR, enumerar_iso
    from parche_iso import buscar_archivo

    if not os.path.exists(args.iso):
        raise SystemExit(f"No existe: {args.iso}")
    if os.path.abspath(args.iso).lower().endswith("black.iso"):
        raise SystemExit("Ese es el ISO ORIGINAL. Hace una copia con "
                         "`parche_iso.py preparar` y trabaja sobre ella.")

    ruta_interna = f"/LEVELS/{args.nivel}/{args.stage}/STLEVEL.BIN"
    entradas, _ = enumerar_iso(args.iso)
    e = buscar_archivo(entradas, ruta_interna)
    base = e["lba"] * SECTOR

    with open(args.iso, "rb") as fh:
        fh.seek(base)
        datos = fh.read(0x400)
    s = StLevel(datos=datos + b"\0" * 0x400)
    if args.slot >= s.n:
        raise SystemExit(f"El nivel tiene {s.n} armas (slots 0..{s.n - 1}).")

    disp = modelos_del_nivel(args.nivel, ISO_MONTADO)
    nuevo_modelo = StLevel.modelo(args.arma)
    if disp and nuevo_modelo not in disp:
        raise SystemExit(
            f"'{nuevo_modelo}' NO esta en el FPGUNS de {args.nivel}.\n"
            f"  Hay: {', '.join(disp)}\n"
            f"  Poner un arma que el nivel no trae no la hace aparecer: el juego\n"
            f"  no la encuentra. Ver el mensaje 'AI gun model not found' del ELF.")
    b = args.arma.encode("latin1")
    if len(b) >= LARGO_NOMBRE:
        raise SystemExit(f"El nombre no entra en {LARGO_NOMBRE} bytes.")

    viejo = s.armas[args.slot]["nombre"]
    off_abs = base + s.armas[args.slot]["offset"]
    print(f"  ISO      : {args.iso}")
    print(f"  archivo  : {ruta_interna}  (LBA {e['lba']}, byte 0x{base:X})")
    print(f"  slot {args.slot}   : '{viejo}'  ->  '{args.arma}'")
    print(f"  byte     : 0x{off_abs:X}")
    if args.simular:
        print("\n  -Simular: no se escribio nada.")
        return

    with open(args.iso, "r+b") as fh:
        fh.seek(off_abs)
        fh.write(b + b"\0" * (LARGO_NOMBRE - len(b)))

    # VERIFICA POR EFECTO: se relee del ISO, no se confia en la escritura
    with open(args.iso, "rb") as fh:
        fh.seek(base)
        datos2 = fh.read(0x400)
    s2 = StLevel(datos=datos2 + b"\0" * 0x400)
    leido = s2.armas[args.slot]["nombre"]
    if leido != args.arma:
        raise SystemExit(f"FALLO: quedo '{leido}' y no '{args.arma}'.")
    otros = [(a["slot"], a["nombre"]) for a in s2.armas if a["slot"] != args.slot]
    esperados = [(a["slot"], a["nombre"]) for a in s.armas if a["slot"] != args.slot]
    if otros != esperados:
        raise SystemExit("FALLO: se movio algun OTRO slot. El ISO quedo sucio.")
    print(f"\n  OK -- releido del ISO: slot {args.slot} = '{leido}'")
    print(f"  control: los otros {len(otros)} slots quedaron identicos.")


def cmd_autotest(args):
    ok = True

    def chequeo(nombre, obtenido, esperado):
        nonlocal ok
        bien = obtenido == esperado
        ok = ok and bien
        print(f"  [{'OK ' if bien else 'MAL'}] {nombre}: {obtenido}"
              f"{'' if bien else f'  (se esperaba {esperado})'}")

    p = os.path.join(args.iso, "LEVELS", CONTROL["nivel"], "STG_0001", "STLEVEL.BIN")
    s = StLevel(p)
    print("CONTROL POSITIVO -- contra kb/mapa-memoria.json, medido en RAM")
    chequeo("cantidad de armas", s.n, CONTROL["n_armas"])
    chequeo("directorio en RAM", hex(CONTROL["base_carga"] + s.off_dir),
            hex(CONTROL["directorio_mem"]))
    chequeo("primera arma", s.armas[0]["nombre"], CONTROL["primera"])
    disp = modelos_del_nivel(CONTROL["nivel"], args.iso)
    faltan = [a["nombre"] for a in s.armas if StLevel.modelo(a["nombre"]) not in disp]
    chequeo("todos los modelos referenciados estan en FPGUNS", faltan, [])

    # EL INVARIANTE QUE FIJA LA BASE DE LOS PUNTEROS. Si la base fuera el
    # archivo o el directorio en vez de la entrada, los centinelas de los
    # arrays vacios NO darian todos el mismo valor.
    cent = set()
    alineados = True
    for a in s.armas:
        o = a["offset"]
        pe, pt, ne, nt = struct.unpack_from("<4I", s.datos, o + 0x18)
        for ptr, cnt in ((pe, ne), (pt, nt)):
            if cnt == 0:
                cent.add((o + ptr) & 0xFFFFFFFF)
            elif ((o + ptr) & 0x7F) != 0:
                alineados = False
    chequeo("los centinelas de los arrays vacios dan UN solo valor", len(cent), 1)
    chequeo("valor del centinela", hex(next(iter(cent))) if cent else None, "0xfdc5ff80")
    chequeo("los punteros reales caen alineados a 0x80", alineados, True)

    print("\nSABOTAJES -- un chequeo que nunca dijo que no, no dice nada")
    d = bytearray(s.datos[:0x400])
    casos = [
        ("version rota", 0, struct.pack("<I", 99)),
        ("directorio fuera del archivo", 4, struct.pack("<I", 0x7FFFFF00)),
        ("cantidad absurda", 8, struct.pack("<I", 5000)),
        ("cantidad cero", 8, struct.pack("<I", 0)),
    ]
    for nombre, off, parche in casos:
        d2 = bytearray(d)
        d2[off:off + len(parche)] = parche
        try:
            StLevel(datos=bytes(d2))
            print(f"  [MAL] {nombre}: NO se quejo")
            ok = False
        except Exception as ex:
            print(f"  [OK ] {nombre}: rechazado ({ex})")

    print("\n" + ("TODO OK" if ok else "HAY FALLAS"))
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser(description="Directorio de armas por nivel, del ISO")
    ap.add_argument("--iso", default=ISO_MONTADO,
                    help="raiz del ISO MONTADO para leer (por defecto D:\\)")
    sub = ap.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("catalogo", help="todos los niveles, con lo que usan y lo que traen")
    a.set_defaults(f=cmd_catalogo)

    b = sub.add_parser("armas", help="el directorio de un nivel, en detalle")
    b.add_argument("nivel")
    b.add_argument("--stage", default="STG_0001")
    b.set_defaults(f=cmd_armas)

    c = sub.add_parser("autotest", help="control positivo contra RAM + cuatro sabotajes")
    c.set_defaults(f=cmd_autotest)

    g = sub.add_parser("enemigos", help="que arma usa cada clase de enemigo y de companero")
    g.add_argument("nivel")
    g.add_argument("--stage", default="STG_0001")
    g.set_defaults(f=cmd_enemigos)

    e = sub.add_parser("cambiar", help="escribe un arma distinta EN UNA COPIA del ISO")
    e.add_argument("--iso", required=True, dest="iso", help="la COPIA .iso a modificar")
    e.add_argument("--nivel", required=True)
    e.add_argument("--stage", default="STG_0001")
    e.add_argument("--slot", type=int, required=True)
    e.add_argument("--arma", required=True, help="por ejemplo bg1_snr")
    e.add_argument("--simular", action="store_true", help="dice que haria y no escribe")
    e.set_defaults(f=cmd_cambiar)

    args = ap.parse_args()
    sys.exit(args.f(args) or 0)


if __name__ == "__main__":
    main()
