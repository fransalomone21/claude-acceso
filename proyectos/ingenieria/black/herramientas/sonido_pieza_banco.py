#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sonido_pieza_banco.py -- (116) el banco de la pieza 2a de la C (el disparo de J2 suena), de punta a punta, en el
fork (sesiones/PREDICCIONES-116.md).

    python herramientas/sonido_pieza_banco.py pieza      # instalar --con-sonido, lanzar, Town carga 1 + medir, carga 2 + medir
    python herramientas/sonido_pieza_banco.py control    # instalar --sin-sonido, lanzar, Town carga 1 + medir

Medir = inspeccion_coop.py quieto fuego-J2 fuego-J (audio WASAPI por escena) y, alrededor, la cuenta del envoltorio 4
del aislador (pasadas / salteadas: el seam en RAM que dice que el disparo de J2 llego al envoltorio). Town (nivel 2) es
el banco de la S4 de (111): sin tiroteo de fondo. Deja el fork abierto (J1 en el mando falso: campana_coop.
entregar_a_fran() antes de que juegue Fran); el pnach queda como lo dejo el ultimo modo.
Salida: volcados/inspeccion/banco-sonido-<modo>-<fecha-hora>.json (y las carpetas de inspeccion_coop.py).
"""
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
from pine import Pine  # noqa: E402

TOWN = 2
K = [f for f, _, _ in cm.FP_ENTRADAS].index(0x001D6F90)
PASADAS, SALTEADAS = cm.AISLAR_CUENTAS + 8 * K, cm.AISLAR_CUENTAS + 8 * K + 4


def cuentas():
    """El seam en RAM: las cuentas del envoltorio 4 y el generador al azar del sonido del disparo (V+0x2A0/+0x2A4),
    que SOLO avanza cuando corre FUN_001D7020(V) con V+0x1C44 != 0 (116, en frio). Independiente del microfono."""
    with Pine() as p:
        x = p.leer32(p.leer32(0x0040F510) + 0xCBD8)
        v = p.leer32(x + 0xC)
        return {"pasadas": p.leer32(PASADAS), "salteadas": p.leer32(SALTEADAS),
                "salida_env4": hex(p.leer32(cm.AISLAR + 0x3C * K + 13 * 4)),
                "V": hex(v), "azar": [hex(p.leer32(v + 0x2A0)), hex(p.leer32(v + 0x2A4))],
                # (117) el seam del sonido que se oye: el sello de las 2 voces de V (V+0x284, paso 0xC, sello en +8),
                # que escribe FUN_001D6178 cada vez que el cue *(V+0x1BE0) toca (cue_disparo.py)
                "cue": hex(p.leer32(v + 0x1BE0)), "sellos": [p.leer32(v + 0x284 + 8), p.leer32(v + 0x290 + 8)],
                "sonido_on_1C44": p.leer8(v + 0x1C44), "guarda_1E54": p.leer8(p.leer32(x + 0x24) + 0x1E54)}


def medir():
    """Cada escena por separado, con las cuentas alrededor: el azar tiene que quedar quieto en `quieto`, avanzar en
    `fuego-J` (control positivo: J suena) y, en `fuego-J2`, avanzar SOLO con la pieza."""
    res = {}
    for e in ("quieto", "fuego-J2", "fuego-J"):
        antes = cuentas()
        r = subprocess.run([sys.executable, str(H / "inspeccion_coop.py"), e], capture_output=True, text=True,
                           encoding="utf-8", errors="replace", timeout=120)
        despues = cuentas()
        lineas = [l for l in r.stdout.splitlines() if l.strip()]
        res[e] = {"antes": antes, "despues": despues, "azar_avanzo": antes["azar"] != despues["azar"],
                  "voces_tocaron": antes["sellos"] != despues["sellos"],
                  "salteadas": despues["salteadas"] - antes["salteadas"], "inspeccion": lineas[-2:],
                  "rc": r.returncode, "err": r.stderr[-300:] if r.returncode else ""}
    return res


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("pieza", "control"):
        print(__doc__)
        return 0
    modo = sys.argv[1]
    if cc.pcsx2_de_fran_abierto():
        print(json.dumps({"error": "el PCSX2 de Fran esta abierto: comparte PINE con el fork"}))
        return 1
    res = {"modo": modo}
    r = subprocess.run([sys.executable, str(H / "coop_mod.py"), "instalar",
                        "--con-sonido" if modo == "pieza" else "--sin-sonido"], capture_output=True, text=True)
    res["instalar"] = r.stdout.strip()[-400:]
    res["vivo"] = cc.lanzar()
    if not res["vivo"]:
        print(json.dumps(res))
        return 1
    for n in (1, 2) if modo == "pieza" else (1,):
        c = cc.probar_nivel(TOWN)
        res["carga%d" % n] = {k: c.get(k) for k in ("armado_s", "juego_s", "cuelga_o_no_arma", "vivo_despues")}
        if c.get("cuelga_o_no_arma"):
            break
        res["medida%d" % n] = medir()
        print(json.dumps({"carga": n, "medida": res["medida%d" % n]}, ensure_ascii=False), flush=True)
    sal = H.parent / "volcados" / "inspeccion" / time.strftime("banco-sonido-%s-%%Y%%m%%d-%%H%%M%%S.json" % modo)
    sal.parent.mkdir(parents=True, exist_ok=True)
    sal.write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({"salida": str(sal)}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
