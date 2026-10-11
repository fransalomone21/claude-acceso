#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""f7b_hilos.py -- (127) QUE ESTA HACIENDO EL EE en la traba de la pausa (sesiones/PREDICCIONES-127.md, T1-T5).

    python herramientas/f7b_hilos.py <dir>     # con el fork abierto (despues de f7b_pausa.py); escribe <dir>/hilos.json

Solo lectura. Por el DebugServer del fork (depurador.py, puerto 21512): N muestras del PC con el EE corriendo, la
lista de hilos del EE, y la pila con el EE pausado por el depurador (se lo vuelve a soltar). Por PINE: la bandera
'pendiente' de la ranura 6 del cargador (*(0x0040F4C4)+0x8B8) y si la region 0x01F28800-0x01FF0000 sigue en cero.
Clasifica cada PC: 'nucleo' (>= 0x80000000), 'vblank' (adentro de FUN_00271480, la espera del vblank) o 'juego'.
"""
import argparse
import json
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from depurador import Depurador  # noqa: E402
from pine import Pine  # noqa: E402

CARGADOR = 0x0040F4C4
RANURA6_PEND = 6 * 0x140 + 0x138           # = 0x8B8, docs/16 (127) (a)
ESPERA_VBLANK = (0x00271480, 0x00271558)    # FUN_00271480 (hasta FUN_00271558)
REGION = (0x01F28800, 0x01FF0000)           # docs/16 (127) (b): fuera de todo monton, en cero en 17 volcados


def clase_pc(pc):
    if pc >= 0x80000000:
        return "nucleo"
    if ESPERA_VBLANK[0] <= pc < ESPERA_VBLANK[1]:
        return "vblank"
    return "juego"


def _int(v):
    return v if isinstance(v, int) else int(str(v), 16)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("dir", type=Path)
    ap.add_argument("--n", type=int, default=8, help="muestras del PC")
    a = ap.parse_args()
    a.dir.mkdir(parents=True, exist_ok=True)
    res = {"muestras": []}
    with Depurador() as d:
        st = d.estado()
        res["estado_inicial"] = st
        if st.get("paused"):
            d.continuar()
            time.sleep(0.5)
        for _ in range(a.n):
            pc = _int(d.estado()["pc"])
            res["muestras"].append({"pc": hex(pc), "clase": clase_pc(pc)})
            time.sleep(0.37)
        res["hilos"] = d.hilos()
        pc_p = _int(d.pausar())
        res["pausa_pc"] = {"pc": hex(pc_p), "clase": clase_pc(pc_p)}
        try:
            res["pila"] = d.pila(24)
        finally:
            d.continuar()
    with Pine() as p:
        ld = p.leer32(CARGADOR)
        res["ranura6_pendiente"] = p.leer8(ld + RANURA6_PEND)
        bloque = p.leer_bloque(REGION[0], REGION[1] - REGION[0])
        nz = [i for i in range(0, len(bloque), 0x800) if any(bloque[i:i + 0x800])]
        res["region_cero"] = not nz
        res["region_no_cero"] = [hex(REGION[0] + i) for i in nz[:16]]
    pcs = [int(m["pc"], 16) for m in res["muestras"] if m["clase"] == "juego"]
    res["rango_juego"] = hex(max(pcs) - min(pcs)) if pcs else None
    res["clases"] = {c: sum(1 for m in res["muestras"] if m["clase"] == c) for c in ("juego", "nucleo", "vblank")}
    (a.dir / "hilos.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({k: res[k] for k in ("clases", "rango_juego", "pausa_pc", "ranura6_pendiente", "region_cero")},
                     ensure_ascii=False))
    for h in res["hilos"]:
        print("hilo", json.dumps(h, ensure_ascii=False)[:300])
    for f in res.get("pila", [])[:12]:
        print("marco", json.dumps(f, ensure_ascii=False)[:200])
    return 0


if __name__ == "__main__":
    sys.exit(main())
