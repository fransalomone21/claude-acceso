#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
zonas.py — la tabla de ZONAS DE IMPACTO de BLACK: el daño de SALIDA del jugador.

PARA QUÉ
    El daño que el jugador le hace a un enemigo NO sale del `Power` de la tabla
    de armas (para eso está armas.py). Sale de una tabla por ZONA DE IMPACTO
    que cuelga del personaje de la víctima:

        daño = factor_de_zona * 100.0        (y a veces * 0.7)

    Eso se calcula en 0x00142B90, que IGNORA el daño que le llega en $f12 y
    devuelve el suyo en $f0. El llamador (0x0013434C, dentro del método #8 del
    enemigo) lo toma como daño efectivo y lo resta de la vida en +0x2F8.

    Por eso escribir 300 en los 34 campos `Power` de la tabla de armas no
    cambió NADA en el daño del jugador: nunca se leen para este camino.

FORMATO
    Registros de 0xC bytes, indexados por número de zona (0..23 observados):
        +0x00  f32   factor A   (se usa si [impacto+0x48] < 0)
        +0x04  f32   factor B   (si no)
        +0x08  ---   no se lee en este camino

    Perfil observado en el nivel 1 (multiplicar por 100 para el daño):
        1.02  -> 102   cabeza: mata de un tiro a un enemigo de 100
        0.51  ->  51
        0.34  ->  34
        0.255 -> 25.5  torso — el valor confirmado en la Fase 1
        0.11333 -> 11.33  extremidades

DÓNDE ESTÁ
    En el HEAP, y hay una tabla POR TIPO DE PERSONAJE: la dirección cambia
    entre niveles y entre partidas. Por eso se busca siguiendo la cadena de
    punteros desde el pool de enemigos, nunca hardcodeada:

        p    = [victima + 0x328]
        q    = [p + 0x3C]
        base = [q]
        registro = base + zona * 0xC

CÓMO SE CONSIGUE EL VOLCADO
    python3 herramientas/pine.py volcar 0x0 0x2000000 volcados/ee-vivo.bin

COMANDOS
    listar     encuentra las tablas en un volcado y las imprime
    escribir   pone un factor en todas las zonas (en vivo, por PINE)
    restaurar  vuelve a los valores guardados por `escribir`

EJEMPLO
    python3 herramientas/pine.py volcar 0x0 0x2000000 volcados/ee-vivo.bin
    python3 herramientas/zonas.py listar volcados/ee-vivo.bin
    python3 herramientas/zonas.py escribir volcados/ee-vivo.bin 3.0 --guardar volcados/zonas.json
    # ... disparar UNA bala al torso: tiene que morir de una ...
    python3 herramientas/zonas.py restaurar volcados/zonas.json
"""

import argparse
import json
import struct
import subprocess
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent
sys.path.insert(0, str(AQUI))
from salida import tolerar_salida_pobre  # noqa: E402

PASO_ZONA = 0xC        # tamaño de un registro de zona
N_ZONAS = 24           # zonas observadas; el juego indexa por byte con signo
OFF_A, OFF_B = 0x00, 0x04
ESCALA = 100.0         # el `lui $at,0x42C8` de 0x00142CA0

# Cadena desde la víctima hasta la tabla (ver 0x00134314-0x00134324 y 0x00142BF4)
OFF_COMPONENTE = 0x328
OFF_PERSONAJE = 0x3C

# Pool de enemigos confirmado en la Fase 3 (kb/estructuras.json#enemigo)
POOL_ENEMIGOS, PASO_ENEMIGO, N_ENEMIGOS = 0x0058FE90, 0x3C0, 32

RAM_INI, RAM_FIN = 0x00080000, 0x02000000


def _f32(d, a):
    return struct.unpack_from("<f", d, a)[0]


def _u32(d, a):
    return int.from_bytes(d[a:a + 4], "little")


def _en_ram(a):
    return RAM_INI <= a < RAM_FIN


def buscar_tablas(d):
    """{base: [indices de enemigos que la usan]} siguiendo la cadena real.

    Se descartan las tablas degeneradas (todo cero): son slots del pool que no
    tienen personaje cargado, y escribirles no prueba nada.
    """
    tablas = {}
    for i in range(N_ENEMIGOS):
        v = POOL_ENEMIGOS + i * PASO_ENEMIGO
        if v + 0x400 >= len(d):
            continue
        p = _u32(d, v + OFF_COMPONENTE)
        if not _en_ram(p):
            continue
        q = _u32(d, p + OFF_PERSONAJE)
        if not _en_ram(q):
            continue
        base = _u32(d, q)
        if not _en_ram(base) or base + N_ZONAS * PASO_ZONA >= len(d):
            continue
        tablas.setdefault(base, []).append(i)
    return {b: q for b, q in tablas.items() if _tiene_datos(d, b)}


def _tiene_datos(d, base):
    """Al menos una zona con un factor plausible: 0.01 <= f <= 100."""
    for z in range(N_ZONAS):
        for off in (OFF_A, OFF_B):
            f = _f32(d, base + z * PASO_ZONA + off)
            if f == f and 0.01 <= f <= 100.0:
                return True
    return False


def campos(d, bases):
    """Direcciones de los factores de zona que SON factores.

    Sólo las palabras cuyo valor actual es un factor plausible. Las zonas
    altas traen en +0x00 denormales de 1e-43 que no se comportan como
    factores: pisarlas sería escribir sobre algo que todavía no sabemos qué
    es, y no hace falta para el experimento.
    """
    dirs = []
    for b in bases:
        for z in range(N_ZONAS):
            for off in (OFF_A, OFF_B):
                a = b + z * PASO_ZONA + off
                f = _f32(d, a)
                if f == f and 0.01 <= f <= 100.0:
                    dirs.append(a)
    return dirs


def cmd_listar(args):
    d = Path(args.volcado).read_bytes()
    tablas = buscar_tablas(d)
    if not tablas:
        print("\n  No se encontró ninguna tabla de zonas en %s." % args.volcado)
        print("  ¿El volcado es de una partida DENTRO de un nivel, con")
        print("  enemigos cargados? La cadena arranca en el pool de enemigos.")
        return 1

    for base, quienes in tablas.items():
        print("\n  tabla de zonas 0x%08X   — la usan los enemigos %s"
              % (base, quienes))
        print("   zona   factor A    factor B   |   daño A    daño B")
        for z in range(N_ZONAS):
            a = base + z * PASO_ZONA
            fa, fb = _f32(d, a + OFF_A), _f32(d, a + OFF_B)
            # Los factores basura (denormales de 1e-43) se marcan en vez de
            # imprimirse como si fueran datos: ver lección 12.
            print("    %2d   %-10.5g  %-10.5g |  %8.4g  %8.4g%s"
                  % (z, fa, fb, fa * ESCALA, fb * ESCALA,
                     "   <- basura" if 0 < abs(fa) < 1e-6 else ""))
    print("\n  daño = factor * %g   (0x00142CA0). Un enemigo tiene 100 de vida."
          % ESCALA)
    return 0


def _pine(*argv):
    r = subprocess.run([sys.executable, str(AQUI / "pine.py"), *argv],
                       capture_output=True, text=True)
    return r.stdout.strip()


def _coincide(leido, esperado):
    try:
        return abs(float(leido.split()[0]) - float(esperado)) < 1e-3
    except (ValueError, IndexError):
        return False


def cmd_escribir(args):
    d = Path(args.volcado).read_bytes()
    tablas = buscar_tablas(d)
    if not tablas:
        print("\n  No se encontró ninguna tabla de zonas. Nada que escribir.")
        return 1

    dirs = campos(d, sorted(tablas))
    originales = {"0x%08X" % a: _f32(d, a) for a in dirs}
    Path(args.guardar).write_text(json.dumps(originales, indent=1))
    print("\n  %d factores originales -> %s" % (len(dirs), args.guardar))

    ok = mal = 0
    for a in dirs:
        _pine("escribir", "0x%08X" % a, str(args.valor), "--tipo", "f32")
        if _coincide(_pine("leer", "0x%08X" % a, "--tipo", "f32"), args.valor):
            ok += 1
        else:
            mal += 1
            print("  DISCREPANCIA 0x%08X" % a)
    print("  escritos %d/%d   discrepancias: %d" % (ok, len(dirs), mal))
    print("  daño esperado por impacto: %g" % (args.valor * ESCALA))
    print("\n  Para volver: python3 herramientas/zonas.py restaurar %s"
          % args.guardar)
    return 0 if mal == 0 else 1


def cmd_restaurar(args):
    originales = json.loads(Path(args.guardado).read_text())
    ok = mal = 0
    for a, v in originales.items():
        _pine("escribir", a, str(v), "--tipo", "f32")
        if _coincide(_pine("leer", a, "--tipo", "f32"), v):
            ok += 1
        else:
            mal += 1
            print("  DISCREPANCIA %s: no volvió a %s" % (a, v))
    print("  restaurados %d/%d   discrepancias: %d"
          % (ok, len(originales), mal))
    return 0 if mal == 0 else 1


def main():
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="La tabla de zonas de impacto de BLACK "
                    "(el daño de salida del jugador)",
        epilog="Las tablas viven en el HEAP y se mueven: siempre se buscan "
               "siguiendo la cadena de punteros sobre un volcado fresco.")
    sub = p.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("listar", help="encuentra las tablas y las imprime")
    a.add_argument("volcado")
    a.set_defaults(func=cmd_listar)

    b = sub.add_parser("escribir",
                       help="pone un factor en todas las zonas (por PINE)")
    b.add_argument("volcado")
    b.add_argument("valor", type=float)
    b.add_argument("--guardar", required=True,
                   help="archivo donde dejar los originales")
    b.set_defaults(func=cmd_escribir)

    c = sub.add_parser("restaurar", help="vuelve a los valores guardados")
    c.add_argument("guardado")
    c.set_defaults(func=cmd_restaurar)

    args = p.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
