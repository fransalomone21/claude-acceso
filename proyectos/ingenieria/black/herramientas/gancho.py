#!/usr/bin/env python3
"""gancho.py -- codigo nuevo por PINE: un gancho por cuadro (sonda 6 del COOP, bitacora (78)).

Desvia el `jal FUN_0013bac8` de 0x00129574 (dentro de FUN_00129360, el update
del mundo, una vez por cuadro) a un stub en memoria libre que llama a la
funcion original y suma 1 a un contador. Es la base del prototipo: el mismo
stub es el lugar donde se construye y actualiza al jugador 2.

    python herramientas/gancho.py poner
    python herramientas/gancho.py contar 2      # cuanto sube el contador en 2 s
    python herramientas/gancho.py quitar
"""

import argparse
import json
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
from mips import ensamblar  # noqa: E402

SITIO = 0x00129574
ORIGINAL = 0x0C04EEB2          # jal 0x0013BAC8 (medido en vivo y en el volcado)
STUB = 0x0046D700              # .bss en cero (probable libre)
CONTADOR = 0x0046D780

FUENTE = [
    "addiu sp, sp, -0x20",
    "sd ra, 0(sp)",
    "jal 0x13bac8",
    "nop",
    "lui t0, 0x47",
    "lw t1, -0x2880(t0)",       # 0x0046D780 = 0x00470000 - 0x2880
    "addiu t1, t1, 1",
    "sw t1, -0x2880(t0)",
    "ld ra, 0(sp)",
    "jr ra",
    "addiu sp, sp, 0x20",
]


def codigo():
    return [ensamblar(t, STUB + 4 * i) for i, t in enumerate(FUENTE)]


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("poner")
    sub.add_parser("quitar")
    sub.add_parser("listar")
    c = sub.add_parser("contar")
    c.add_argument("segundos", type=float)
    a = ap.parse_args()
    if a.cmd == "listar":
        for i, (t, w) in enumerate(zip(FUENTE, codigo())):
            print("0x%08X  %08X  %s" % (STUB + 4 * i, w, t))
        return 0
    with Pine() as p:
        if a.cmd == "poner":
            actual = p.leer32(SITIO)
            if actual != ORIGINAL:
                print("el sitio no tiene la palabra original: %08X" % actual)
                return 1
            for i, w in enumerate(codigo()):
                p.escribir32(STUB + 4 * i, w)
            p.escribir32(CONTADOR, 0)
            p.escribir32(SITIO, ensamblar("jal 0x%x" % STUB, SITIO))
        elif a.cmd == "quitar":
            p.escribir32(SITIO, ORIGINAL)
        elif a.cmd == "contar":
            c0 = p.leer32(CONTADOR)
            time.sleep(a.segundos)
            c1 = p.leer32(CONTADOR)
            print(json.dumps({"contador_antes": c0, "contador_despues": c1,
                              "por_segundo": round((c1 - c0) / a.segundos, 1)}))
            return 0
        print(json.dumps({"sitio": "%08X" % p.leer32(SITIO), "stub0": "%08X" % p.leer32(STUB),
                          "contador": p.leer32(CONTADOR)}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
