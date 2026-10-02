"""teletransporte.py -- (111) mover a un jugador (J o J2) a un punto, de forma que se sostenga y camine desde ahi.

La posicion vive en TRES lugares (medido en City Streets, bitacora (111)):
  1. jugador+0xA0 (fila 3 de la matriz +0x70; la lee todo el juego);
  2. el objeto de fisica del controlador de colision: e0c+0x40, con e0c = *(*(ctrl+0x34)+0xC), ctrl = jugador+0xB4;
  3. el cuerpo: *(e0c+0x58)+0x10 (2,8 cm mas abajo que +0xA0).
El callback del controlador (FUN_0025D110 -> FUN_00387FC0 -> FUN_00125F88) rearma la matriz del jugador desde el
cuerpo en cada cuadro en que el controlador esta activo: escribir solo +0xA0 se sostiene con el controlador quieto
(Town) y se pisa en el mismo cuadro si esta activo (City Streets, con el titere encima). Se escribe EN PAUSA.

    python herramientas/teletransporte.py J2 <x> <y> <z>
    python herramientas/teletransporte.py J2 --junto-a-J [--dx 1.5] [--dz 0]
"""
import argparse
import json
import struct
import subprocess
import sys
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
import clon_jugador as cj  # noqa: E402


def f32(p, d):
    return struct.unpack("<f", struct.pack("<I", p.leer32(d)))[0]


def pos(p, base):
    return [f32(p, base + 0xA0 + 4 * k) for k in range(3)]


def lugares(p, base):
    """Las tres direcciones de la posicion (o None si el jugador no tiene controlador atado)."""
    ctrl = p.leer32(base + 0xB4)
    if not ctrl:
        return None
    e0c = p.leer32(p.leer32(ctrl + 0x34) + 0xC)
    return {"jugador": base + 0xA0, "fisica": e0c + 0x40, "cuerpo": p.leer32(e0c + 0x58) + 0x10}


def teletransportar(p, base, destino):
    """Escribe los tres lugares. El llamador pausa y continua el EE (depurador.py)."""
    lu = lugares(p, base)
    dy = f32(p, lu["cuerpo"] + 4) - f32(p, base + 0xA4) if lu else 0.0
    for k, v in enumerate(destino):
        p.escribir_f32(base + 0xA0 + 4 * k, v)
        if lu:
            p.escribir_f32(lu["fisica"] + 4 * k, v)
            p.escribir_f32(lu["cuerpo"] + 4 * k, v + (dy if k == 1 else 0.0))
    return lu


def dep(accion):
    subprocess.run([sys.executable, str(H / "depurador.py"), accion], capture_output=True)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("quien", choices=("J", "J2"))
    ap.add_argument("xyz", nargs="*", type=float)
    ap.add_argument("--junto-a-J", dest="junto", action="store_true")
    ap.add_argument("--dx", type=float, default=1.5)
    ap.add_argument("--dz", type=float, default=0.0)
    a = ap.parse_args()
    base = cj.J if a.quien == "J" else cj.J2
    with Pine() as p:
        if a.junto:
            j = pos(p, cj.J)
            destino = [j[0] + a.dx, j[1], j[2] + a.dz]
        elif len(a.xyz) == 3:
            destino = a.xyz
        else:
            raise SystemExit("hace falta <x> <y> <z> o --junto-a-J")
        antes = pos(p, base)
        dep("pausar")
        lu = teletransportar(p, base, destino)
        dep("continuar")
        print(json.dumps({"quien": a.quien, "antes": [round(x, 2) for x in antes],
                          "destino": [round(x, 2) for x in destino],
                          "lugares": {k: hex(v) for k, v in lu.items()} if lu else None}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
