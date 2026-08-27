#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
armas.py — la tabla de armas de BLACK: leerla y tocarle el daño.

PARA QUÉ
    Cada arma del juego tiene un registro de 0x1E0 bytes con DOS bloques de
    parámetros de 0x30: uno para cuando la usa el jugador (+0x90) y otro para
    cuando la usa la IA (+0xC0). Son los `PlayerParams` / `AIParams` del
    esquema que el propio ejecutable trae escrito en 0x00400858.

    Dentro de cada bloque:
        +0x14  Range     f32
        +0x18  Power     f32   <-- el daño
        +0x1C  falloff   f32   fracción mínima, 0..1

    La rutina 0x0015B118 calcula:  daño = Power * (falloff + (1-falloff)*t)
    con t = arg/Range. Con falloff = 1 el daño es CONSTANTE e igual a Power,
    que es el caso de casi todas las armas.

DÓNDE ESTÁ
    NO está en el ejecutable ni en BSS: se carga por stage desde
    `Levels\\Level_NN\\Stg_NNNN\\Guns.bin` al HEAP, así que la dirección
    CAMBIA entre niveles y entre partidas. Por eso esta herramienta la BUSCA
    por firma en vez de tener la dirección hardcodeada. En la sesión donde se
    descubrió estaba en 0x01842220..0x01844020 (17 registros).

    El callejón que hay que no volver a recorrer: los cinco 26.0 de
    0x0042C3AC..0x0042D56C son BSS y NO son la tabla — escribirles no cambia
    ningún daño y encima ensucia el HUD (esa zona la referencia el arreglo
    de 0x006CF4E0).

CÓMO SE CONSIGUE EL VOLCADO
    python3 herramientas/pine.py volcar 0x0 0x2000000 volcados/ee-vivo.bin
    (tarda ~3 s con el juego corriendo)

COMANDOS
    listar     encuentra la tabla en un volcado y la imprime
    escribir   pone un Power en TODOS los registros (en vivo, por PINE)
    restaurar  vuelve a los valores guardados por `escribir`

EJEMPLO
    python3 herramientas/pine.py volcar 0x0 0x2000000 volcados/ee-vivo.bin
    python3 herramientas/armas.py listar volcados/ee-vivo.bin
    python3 herramientas/armas.py escribir volcados/ee-vivo.bin 300 --guardar /tmp/p.json
    # ... disparar, mirar el efecto ...
    python3 herramientas/armas.py restaurar /tmp/p.json
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

PASO = 0x1E0          # tamaño de un registro de arma
BLOQUES = (0x90, 0xC0)  # PlayerParams, AIParams
OFF_RANGE, OFF_POWER, OFF_FALLOFF = 0x14, 0x18, 0x1C
OFF_CODIGO = 0x1C0    # código de 3 letras (ASR, SMG, PST, RPG, HVY...)

# Rango del heap donde vive la data de nivel. Acotado a propósito: buscar en
# los 32 MB enteros da falsos positivos de geometría.
HEAP_INI, HEAP_FIN = 0x00800000, 0x02000000


def _f32(d, a):
    return struct.unpack_from("<f", d, a)[0]


def _u32(d, a):
    return int.from_bytes(d[a:a + 4], "little")


def _texto(d, a, n=8):
    fin = d.find(b"\x00", a, a + n)
    crudo = d[a:(fin if fin != -1 else a + n)]
    return "".join(c if 32 <= ord(c) < 127 else "." for c in
                   crudo.decode("latin-1"))


def _registro_valido(d, b):
    """Los dos bloques tienen que tener forma de parámetros de daño."""
    if b < 0 or b + PASO >= len(d):
        return False
    for blo in BLOQUES:
        rango = _f32(d, b + blo + OFF_RANGE)
        power = _f32(d, b + blo + OFF_POWER)
        fall = _f32(d, b + blo + OFF_FALLOFF)
        # NaN se detecta solo: x != x
        if rango != rango or power != power or fall != fall:
            return False
        # Los mínimos NO son cosméticos: sin ellos pasa cualquier basura
        # binaria interpretada como float diminuto (1e-43) y la búsqueda
        # devuelve 400 "registros" de geometría. Un arma con alcance menor a
        # un metro o daño menor a 0.1 no existe.
        if not (1.0 <= rango <= 20000.0):
            return False
        if not (0.1 <= power <= 20000.0):
            return False
        if not (fall == 0.0 or 0.001 <= fall <= 1.0):
            return False
    return True


def buscar_tabla(d):
    """Devuelve la lista de bases de registro, o [] si no la encuentra.

    Estrategia: barrer el heap de a 0x10 buscando una CORRIDA de al menos
    `minimo` registros consecutivos válidos separados por PASO. Un registro
    suelto puede ser casualidad; ocho seguidos no.
    """
    minimo = 8
    a = HEAP_INI
    mejor = []
    while a < HEAP_FIN - PASO * minimo:
        if _registro_valido(d, a):
            n = 1
            while _registro_valido(d, a + n * PASO):
                n += 1
            if n >= minimo:
                # estirar hacia atrás por si empezamos en el medio
                ini = a
                while _registro_valido(d, ini - PASO) and ini - PASO > HEAP_INI:
                    ini -= PASO
                    n += 1
                corrida = [ini + i * PASO for i in range(n)]
                if len(corrida) > len(mejor):
                    mejor = corrida
                a = ini + n * PASO
                continue
        a += 0x10
    return mejor


def campos_power(bases):
    """Direcciones absolutas de todos los campos Power de la tabla."""
    return [b + blo + OFF_POWER for b in bases for blo in BLOQUES]


def cmd_listar(args):
    d = Path(args.volcado).read_bytes()
    bases = buscar_tabla(d)
    if not bases:
        print("\n  No se encontró la tabla en %s." % args.volcado)
        print("  ¿El volcado es de una partida DENTRO de un nivel? La tabla")
        print("  se carga por stage; en el menú no está.")
        return 1

    print("\n  tabla de armas: 0x%08X .. 0x%08X   %d registros de 0x%X"
          % (bases[0], bases[-1], len(bases), PASO))
    print("\n   #  base        código  |   Player: Range   Power   fall"
          "  |   AI: Range   Power   fall")
    for i, b in enumerate(bases):
        p, a = b + BLOQUES[0], b + BLOQUES[1]
        print("  %2d  0x%08X  %-6s  |  %10.4g %7.4g %6.3g  |"
              "  %8.4g %7.4g %6.3g"
              % (i, b, _texto(d, b + OFF_CODIGO, 6),
                 _f32(d, p + OFF_RANGE), _f32(d, p + OFF_POWER),
                 _f32(d, p + OFF_FALLOFF),
                 _f32(d, a + OFF_RANGE), _f32(d, a + OFF_POWER),
                 _f32(d, a + OFF_FALLOFF)))
    print("\n  Power está en base+0x%X+0x%X (jugador) y base+0x%X+0x%X (IA)."
          % (BLOQUES[0], OFF_POWER, BLOQUES[1], OFF_POWER))
    return 0


def _pine(*argv):
    r = subprocess.run([sys.executable, str(AQUI / "pine.py"), *argv],
                       capture_output=True, text=True)
    return r.stdout.strip()


def cmd_escribir(args):
    d = Path(args.volcado).read_bytes()
    bases = buscar_tabla(d)
    if not bases:
        print("\n  No se encontró la tabla. Nada que escribir.")
        return 1

    campos = campos_power(bases)
    originales = {"0x%08X" % a: _f32(d, a) for a in campos}
    Path(args.guardar).write_text(json.dumps(originales, indent=1))
    print("\n  %d campos Power originales -> %s" % (len(campos), args.guardar))

    ok = mal = 0
    for a in campos:
        _pine("escribir", "0x%08X" % a, str(args.valor), "--tipo", "f32")
        leido = _pine("leer", "0x%08X" % a, "--tipo", "f32")
        if _coincide(leido, args.valor):
            ok += 1
        else:
            mal += 1
            print("  DISCREPANCIA 0x%08X: esperaba %s, leyó %r"
                  % (a, args.valor, leido))
    print("  escritos %d/%d   discrepancias: %d" % (ok, len(campos), mal))
    print("\n  Para volver: python3 herramientas/armas.py restaurar %s"
          % args.guardar)
    return 0 if mal == 0 else 1


def _coincide(leido, esperado):
    try:
        return abs(float(leido.split()[0]) - float(esperado)) < 1e-3
    except (ValueError, IndexError):
        return False


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
        description="La tabla de armas de BLACK",
        epilog="La tabla vive en el HEAP y se mueve: siempre se busca por "
               "firma sobre un volcado fresco.")
    sub = p.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("listar", help="encuentra la tabla e imprime las armas")
    a.add_argument("volcado")
    a.set_defaults(func=cmd_listar)

    b = sub.add_parser("escribir",
                       help="pone un Power en todos los registros (por PINE)")
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
