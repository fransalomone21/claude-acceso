#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
prueba_aislar_j2.py -- (96) por donde se cuela J2 a la vista de J. En el fork, cuando J2 vacia el cargador
disparando y recarga solo, la mitad de J muestra fogonazos y la recarga (video rv-J2-e3.mp4, cuadros 2, 6, 15-17);
con la recarga apretada a mano no pasa (rv-J2-control.mp4).

Mide los contadores del aislamiento (coop_mod.AISLAR_CUENTAS: por envoltorio k, +8k pasadas y +8k+4 salteadas;
+0x28/+0x2C el filtro de eventos) en tres ventanas: J2 dispara 0,6 s (sin vaciar), J2 recarga a mano, J2
dispara 3 s (vacia y recarga solo). Y de control, J disparando 3 s.
Prediccion (escrita antes): en la ventana de vaciar, algun envoltorio suma PASADAS que en las otras dos no; ese es
el camino de la fuga.

    python herramientas/prueba_aislar_j2.py
Salida: volcados/campana/aislar-j2.json
"""
from __future__ import annotations

import json
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import mando_j2 as m2  # noqa: E402
import sondas_coop as sc  # noqa: E402

NOMBRES = ["anims_arma", "d7360", "d7500", "llenado_cargador", "disparo", "eventos"]


def cuentas(p):
    return [p.leer32(cm.AISLAR_CUENTAS + 4 * i) for i in range(12)]


def ventana(p, nombre, acciones, segundos):
    c0, t0, hechas = cuentas(p), time.time(), set()
    e0 = m2.estado(p)
    while time.time() - t0 < segundos:
        t = time.time() - t0
        for k, (ta, f) in enumerate(acciones):
            if k not in hechas and t >= ta:
                f(); hechas.add(k)
        time.sleep(0.02)
    c1 = cuentas(p)
    d = [b - a for a, b in zip(c0, c1)]
    return {"ventana": nombre, "J2_antes": e0, "J2_despues": m2.estado(p),
            "delta": {NOMBRES[k]: {"pasa": d[2 * k], "saltea": d[2 * k + 1]} for k in range(6)}}


def main() -> int:
    tolerar_salida_pobre()
    if cc.pcsx2_de_fran_abierto():
        print("el PCSX2 de Fran esta abierto: no"); return 1
    if not cc.lanzar():
        print("el fork no quedo vivo"); return 1
    niv = cc.probar_nivel(0)
    if niv.get("cuelga_o_no_arma"):
        cc.matar_fork(); return 1
    time.sleep(2)
    res = {"fecha": time.strftime("%Y-%m-%d %H:%M"), "ventanas": []}
    with Pine() as p:
        sc.falso_poner(p)
        m2.poner(p)
        b2 = lambda i, v: (lambda: m2.boton(p, m2.NOMBRES[i], v))       # noqa: E731
        b1 = lambda i, v: (lambda: sc.poner_boton(p, sc.BOTONES[i], v))  # noqa: E731
        res["ventanas"].append(ventana(p, "quieto", [], 2.0))
        res["ventanas"].append(ventana(p, "J2 dispara 0,6 s", [(0, b2("disparar", True)), (0.6, b2("disparar", False))], 2.5))
        res["ventanas"].append(ventana(p, "J2 recarga a mano", [(0, b2("recargar", True)), (0.15, b2("recargar", False))], 3.0))
        res["ventanas"].append(ventana(p, "J2 vacia y recarga solo", [(0, b2("disparar", True)), (3.0, b2("disparar", False))], 5.5))
        res["ventanas"].append(ventana(p, "J dispara 3 s (control)", [(0, b1("disparar", True)), (3.0, b1("disparar", False))], 5.5))
        m2.quitar(p); sc.falso_quitar(p)
    (cc.SAL / "aislar-j2.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps(res, ensure_ascii=False))
    cc.matar_fork()
    return 0


if __name__ == "__main__":
    sys.exit(main())
