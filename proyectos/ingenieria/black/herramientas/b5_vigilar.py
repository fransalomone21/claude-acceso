#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
b5_vigilar.py -- sonda 1 de B5 (93u): que es ctrl+0x100 y que pasa cuando muere un jugador.

Vigila, cada ~30 ms, en J y en J2: vida (+0x2F8), ctrl+0x100 (= +0x5F0, el que decide en FUN_0013ffa0 si
la muerte es 'del jugador' o 'de un personaje'), +0x8B2 (muerte en curso), +0x38C (estado); y el global de
muerte *(0x0040F0E0)+0x21098 / +0x2109C. Imprime solo los cambios, con la hora.

    python herramientas/b5_vigilar.py 60                    # 60 s, sin tocar nada (el control)
    python herramientas/b5_vigilar.py 60 --vida-J 40        # arranca bajandole la vida a J a 40 (un tiro = 26)
Salida: una linea por cambio y un JSON final; tambien a volcados/campana/b5-<hora>.json.
"""
import json
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import clon_jugador as cj  # noqa: E402

GLOBAL = 0x0040F0E0


def foto(p):
    g = p.leer32(GLOBAL)
    d = {"muerte_21098": p.leer32(g + 0x21098), "muerte_2109C": p.leer32(g + 0x2109C)}
    for nom, P in (("J", cj.J), ("J2", cj.J2)):
        d[nom] = {"vida": round(struct.unpack("<f", struct.pack("<I", p.leer32(P + 0x2F8)))[0], 1),
                  "c100": p.leer32(P + 0x5F0), "c100f": round(struct.unpack("<f", struct.pack("<I", p.leer32(P + 0x5F0)))[0], 3),
                  "m8B2": p.leer8(P + 0x8B2), "e38C": p.leer32(P + 0x38C)}
    return d


def main():
    tolerar_salida_pobre()
    seg = float(sys.argv[1]) if len(sys.argv) > 1 else 30
    vida_j = float(sys.argv[sys.argv.index("--vida-J") + 1]) if "--vida-J" in sys.argv else None
    enemigo = int(sys.argv[sys.argv.index("--enemigo") + 1]) if "--enemigo" in sys.argv else None
    serie = []
    with Pine() as p:    # UNA conexion: el spawn va por esta misma (PINE no atiende a dos)
        if vida_j is not None:
            p.escribir_f32(cj.J + 0x2F8, vida_j)
        if enemigo is not None:   # sondas_spawn (83): el punto del spawner L12[i] a 6 m delante de J, y activarlo
            import math
            import sondas_spawn as ss
            sp = ss.buscar(p, enemigo, 12)
            punto = p.leer32(p.leer32(sp + 0x18) + 4)
            j = ss.jugador(p)
            fx, fz = ss.adelante_xz(p)
            n = math.hypot(fx, fz) or 1.0
            for k, v in enumerate([j[0] + 6 * fx / n, j[1], j[2] + 6 * fz / n]):
                p.escribir_f32(punto + 0x10 + 4 * k, v)
            p.escribir8(sp + 0x28, 1)
            print(json.dumps({"enemigo": enemigo, "spawner": hex(sp), "punto": ss.pos(p, punto + 0x10)}), flush=True)
        t0, ult = time.time(), None
        mantener = "--mantener" in sys.argv   # (95) la vida se regenera ~30/s: se la vuelve a bajar cada vuelta
        while time.time() - t0 < seg:
            try:
                if mantener and vida_j is not None and p.leer8(cj.J + 0x8B2) == 0:
                    v = struct.unpack("<f", struct.pack("<I", p.leer32(cj.J + 0x2F8)))[0]
                    if v > vida_j:
                        p.escribir_f32(cj.J + 0x2F8, vida_j)
                d = foto(p)
            except Exception as ex:  # noqa: BLE001
                d = {"error": str(ex)}
            if d != ult:
                fila = {"t": round(time.time() - t0, 2), **d}
                serie.append(fila)
                print(json.dumps(fila), flush=True)
                ult = d
            time.sleep(0.03)
    sal = Path(__file__).resolve().parent.parent / "volcados" / "campana" / ("b5-%s.json" % time.strftime("%H%M%S"))
    sal.write_text(json.dumps(serie, indent=1))
    print(json.dumps({"cambios": len(serie), "archivo": str(sal)}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
