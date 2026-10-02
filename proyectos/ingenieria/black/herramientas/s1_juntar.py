"""s1_juntar.py -- (111) sonda del concepto S1 de docs/16 (clase B, juntar): candidato compartido, consumidor por jugador.

Prediccion (docs/16, «Sonda del concepto» de juntar): J parado sobre un arma que no tiene y J2 a mas de 20 m; J2
mantiene «agarrar» -> J2 levanta el arma que esta bajo J (su arreglo de armas cambia) y J no cambia.
Control (en la misma corrida): J lejos de toda arma (pickups+0x5848 = 0) y J2 mantiene «agarrar»: nada cambia.

    python herramientas/s1_juntar.py listar              # los recogibles: tipo (+0x140), banderas (+0x152), posicion (+0xA0)
    python herramientas/s1_juntar.py probar <i> [--control]
probar: (en pausa) pone a J sobre el recogible i (J+0xA0, como el teletransporte de (111)), espera, lee el candidato
pickups+0x5848, y J2 mantiene «agarrar» 1,2 s con su mando falso; mide las armas de J y J2 antes y despues.
--control: el que va encima del recogible es J2 (J se queda donde esta): el candidato tiene que dar 0 y nada cambia.
"""
import argparse
import json
import math
import struct
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import clon_jugador as cj  # noqa: E402
import armas_j2  # noqa: E402
import teletransporte  # noqa: E402

G_PICKUPS, PASO, N = 0x0040F4E4, 0x160, 64
TIPOS = {0: "botiquin", 1: "municion", 2: "ARMA", 4: "mision"}
AGARRAR = 1   # (93y) b1 = agarrar


def f32(p, d):
    return struct.unpack("<f", struct.pack("<I", p.leer32(d)))[0]


def pos(p, b):
    return [f32(p, b + 0xA0 + 4 * k) for k in range(3)]


def recogibles(p):
    base = p.leer32(G_PICKUPS)
    out = []
    for i in range(N):
        o = base + i * PASO
        ban = p.leer8(o + 0x152)
        out.append({"i": i, "dir": o, "tipo": p.leer32(o + 0x140), "ban": ban, "pos": pos(p, o)})
    return base, out


def dep(a):
    subprocess.run([sys.executable, str(H / "depurador.py"), a], capture_output=True)


def boton_j2(p, v):
    ctrl = p.leer32(cj.J2 + 0x588)
    fuente = p.leer32(ctrl + 0xC)
    if fuente != cj.FALSO2:
        f2 = bytearray(p.leer_bloque(fuente, 0xF0))
        for o in range(0x8C, 0xCC, 4):
            f2[o:o + 4] = bytes(4)
        f2[0x0E:0x2A + 28] = bytes(0x2A + 28 - 0x0E)
        p.escribir_bloque(cj.FALSO2, bytes(f2))
        p.escribir32(ctrl + 0xC, cj.FALSO2)
    p.escribir8(cj.FALSO2 + 0x0E + AGARRAR, 0)
    p.escribir8(cj.FALSO2 + 0x2A + AGARRAR, 1 if v else 0)
    p.escribir_f32(cj.FALSO2 + 0x4C + 4 * AGARRAR, 1.0 if v else 0.0)


def cmd_listar(_a):
    with Pine() as p:
        base, rs = recogibles(p)
        j, j2 = pos(p, cj.J), pos(p, cj.J2)
    print(json.dumps({"base": hex(base), "J": [round(x, 1) for x in j], "J2": [round(x, 1) for x in j2]}))
    for r in rs:
        if r["ban"] == 0 and r["tipo"] == 0:
            continue
        print("%2d %-9s ban %#04x pos %s  dJ %.1f dJ2 %.1f" % (r["i"], TIPOS.get(r["tipo"], r["tipo"]), r["ban"],
              [round(x, 1) for x in r["pos"]], math.dist(r["pos"], j), math.dist(r["pos"], j2)))
    return 0


def cmd_probar(a):
    with Pine() as p:
        base, rs = recogibles(p)
        r = rs[a.i]
        j, j2 = pos(p, cj.J), pos(p, cj.J2)
        destino = list(r["pos"])
        quien = cj.J2 if a.control else cj.J   # control: J2 parado sobre el arma y J donde esta
        antes = {"J": armas_j2.armas(p, cj.J), "J2": armas_j2.armas(p, cj.J2)}
        dep("pausar")
        teletransporte.teletransportar(p, quien, destino)   # los tres lugares de la posicion (111)
        dep("continuar")
        time.sleep(0.6)
        cand = [p.leer32(base + 0x5848) for _ in range(5)]
        boton_j2(p, True)
        time.sleep(1.2)
        boton_j2(p, False)
        time.sleep(0.8)
        despues = {"J": armas_j2.armas(p, cj.J), "J2": armas_j2.armas(p, cj.J2)}
        r2 = recogibles(p)[1][a.i]
        jf, j2f = pos(p, cj.J), pos(p, cj.J2)
        res = {"i": a.i, "tipo": TIPOS.get(r["tipo"], r["tipo"]), "control": a.control,
               "destino": [round(x, 2) for x in destino], "J_final": [round(x, 2) for x in jf],
               "J2_final": [round(x, 2) for x in j2f], "J_a_recogible_m": round(math.dist(jf, r["pos"]), 1),
               "J2_a_recogible_m": round(math.dist(j2f, r["pos"]), 1),
               "candidato": [hex(c) for c in cand], "recogible": hex(r["dir"]),
               "ban_antes": hex(r["ban"]), "ban_despues": hex(r2["ban"]),
               "armas_antes": antes, "armas_despues": despues,
               "cambio_J2": antes["J2"] != despues["J2"], "cambio_J": antes["J"] != despues["J"]}
    print(json.dumps(res, ensure_ascii=False))
    return 0


def main():
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("listar")
    pr = sub.add_parser("probar")
    pr.add_argument("i", type=int)
    pr.add_argument("--control", action="store_true")
    a = ap.parse_args()
    return {"listar": cmd_listar, "probar": cmd_probar}[a.cmd](a)


if __name__ == "__main__":
    sys.exit(main())
