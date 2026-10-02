"""fabrica_cuerpo.py -- (113) V3, la sonda del concepto de los cuerpos SIN spawner (docs/16 «Cuerpos», F11/F3).

Copia los 0x48 primeros bytes de un spawner a memoria libre (0x0046F400, .bss fuera de coop-rangos, coop-plan-b y de
llamar_una_vez.py) y llama FUN_001746E0 sobre la COPIA: arma los 8 argumentos de la fabrica FUN_00178408 igual que el
juego y escribe el nacido en copia+0x24, no en el spawner. Mide el spawner original antes y despues, el nacido y los
pools. Prediccion: sesiones/PREDICCIONES-113.md (V3).

    python herramientas/fabrica_cuerpo.py <indice> [--lista 12]
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
import sondas_spawn as ss  # noqa: E402

COPIA, TAM = 0x0046F400, 0x48
LLAMAR_SP = 0x001746E0


def campos(p, sp):
    return {"+24": hex(p.leer32(sp + 0x24)), "+28": p.leer8(sp + 0x28), "+2C": p.leer32(sp + 0x2C, con_signo=True)}


def vivos(p):
    mgr = p.leer32(ss.G_ACTORES)
    return p.leer32(mgr + 0x79A0 + 8)   # cuenta de la lista viva (hipotesis de sondas_spawn: cuenta en +8)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("i", type=int)
    ap.add_argument("--lista", type=int, default=12)
    a = ap.parse_args()
    res = {}
    with Pine() as p:
        sp = ss.buscar(p, a.i, a.lista)
        res["spawner"] = hex(sp)
        res["antes"] = {"original": campos(p, sp), "pools": ss.pools(p), "vivos": vivos(p)}
        for k in range(0, TAM, 4):
            p.escribir32(COPIA + k, p.leer32(sp + k))
        p.escribir32(COPIA + 0x24, 0)
        res["copia_antes"] = campos(p, COPIA)
    r = subprocess.run([sys.executable, str(H / "llamar_una_vez.py"), "%x" % LLAMAR_SP, "%x" % COPIA, "0"],
                       capture_output=True, text=True)
    try:
        res["llamada"] = json.loads(r.stdout.strip().splitlines()[-1])
    except Exception:
        res["llamada"] = {"error": (r.stdout + r.stderr)[-400:]}
    time.sleep(1.0)
    with Pine() as p:
        nacido = p.leer32(COPIA + 0x24)
        res["despues"] = {"original": campos(p, sp), "copia": campos(p, COPIA), "pools": ss.pools(p),
                          "vivos": vivos(p)}
        if nacido:
            res["nacido"] = {"dir": hex(nacido), "vida": round(ss.f32(p, nacido + 0x2F8), 2),
                             "estado": p.leer32(nacido + 0x38C), "pos": ss.pos(p, nacido + 0xA0),
                             "punto_desc": ss.leer_spawner(p, sp)["punto"]}
        res["original_igual"] = res["antes"]["original"] == res["despues"]["original"]
    print(json.dumps(res))
    return 0


if __name__ == "__main__":
    sys.exit(main())
