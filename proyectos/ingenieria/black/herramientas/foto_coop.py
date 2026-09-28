"""Foto de SOLO LECTURA del coop en un emulador abierto (el de Fran incluido): no escribe nada.

    python herramientas/foto_coop.py [salida.json]

Junta en una sola conexion PINE lo que hace falta para leer un video de Fran sin tocar su partida:
la ranura 3 (armada, contadores, a quien apunta cada +0x330 y de quien es cada ranura), las armas
de J y J2 (arreglo, la de la mano, el indice +0x2C3) y el titere. Nacio en (96) para el video
20260928-145814: J2 mostraba la recarga de J y la escopeta que junto J.
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
import clon_jugador as cj  # noqa: E402
import coop_mod as cm  # noqa: E402
from armas_j2 import armas  # noqa: E402

PERS = 0x0040F50C


def foto(p):
    pers = p.leer32(PERS)
    r0 = pers + 0x470 if pers else 0
    j330, j2330 = p.leer32(cj.J + 0x330), p.leer32(cj.J2 + 0x330)
    return {
        "r3": {"armada": p.leer32(cm.R3_ARMADA), "cargas": p.leer32(cm.R3_CARGAS),
               "reapuntes": p.leer32(cm.R3_REAPUNTES), "desvios": p.leer32(cm.R3_DESVIOS),
               "bajas": p.leer32(cm.R3_BAJAS), "molde": hex(p.leer32(cm.R3_MOLDE))},
        "pers": hex(pers), "r0": hex(r0),
        "J_330": hex(j330), "J2_330": hex(j2330), "R3": hex(cm.R3),
        # el primer campo de la ranura es su duenio (93q: *(pers+0x470) debe ser J)
        "duenio_de_J_330": hex(p.leer32(j330)) if j330 else None,
        "duenio_de_J2_330": hex(p.leer32(j2330)) if j2330 else None,
        "duenio_r0": hex(p.leer32(r0)) if r0 else None,
        "duenio_R3": hex(p.leer32(cm.R3)),
        "J": hex(cj.J), "J2": hex(cj.J2),
        "titere_act": hex(p.leer32(cm.TITERE_ACT)),
        "armas_J": armas(p, cj.J), "armas_J2": armas(p, cj.J2),
    }


def main():
    with Pine() as p:
        f = foto(p)
    s = json.dumps(f, indent=1)
    print(s)
    if len(sys.argv) > 1:
        Path(sys.argv[1]).write_text(s, encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
