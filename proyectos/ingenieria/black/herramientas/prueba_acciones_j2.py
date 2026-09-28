#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
prueba_acciones_j2.py -- lo que Fran hacia con el mando 2, sin Fran (93y): J2 dispara, recarga y da un
culatazo con el mando falso de J2, y se mide el estado del arma cuadro a cuadro.

Pregunta: ¿la ranura 3 destraba el fin de la recarga y del culatazo de J2? Las dos acciones terminan con un
evento de la animacion de primera persona (92); con la ranura compartida, J2 no reproduce su animacion y el
evento no llega (recarga eterna, arreglada a la fuerza por RECARGA_MOD a los 90 cuadros; culatazo en bucle,
visto por Fran en (93y)).

    python herramientas/prueba_acciones_j2.py r3        # con el bloque instalado --con-r3
    python herramientas/prueba_acciones_j2.py control   # con el bloque instalado sin la ranura
Lanza el fork (campana_coop.lanzar: slot 3, City Streets), espera J2 armado, y corre:
  1) disparar 1,5 s (baja el cargador), 2) recargar 0,2 s y mirar 5 s, 3) melee 0,2 s y mirar 5 s.
Captura la pantalla en cada paso. Salida: volcados/campana/acciones-<modo>.json.
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


def serie(p, boton, segundos, mirar):
    i = m2.NOMBRES[boton]
    out, t0 = [], time.time()
    rec0 = p.leer32(cm.RECARGA)
    m2.boton(p, i, True)
    soltado = False
    while time.time() - t0 < segundos + mirar:
        if not soltado and time.time() - t0 >= segundos:
            m2.boton(p, i, False); soltado = True
        e = m2.estado(p)
        clave = (e["estado_D8"], e["cargador"])
        if not out or clave != tuple(out[-1][1:]):
            out.append([round(time.time() - t0, 2), *clave])
        time.sleep(0.02)
    return {"boton": boton, "cambios": out, "recarga_mod_cuadros": p.leer32(cm.RECARGA) - rec0,
            "final": m2.estado(p)}


def main() -> int:
    tolerar_salida_pobre()
    modo = sys.argv[1] if len(sys.argv) > 1 else "r3"
    if cc.pcsx2_de_fran_abierto():
        print("el PCSX2 de Fran esta abierto: no"); return 1
    res = {"modo": modo, "fecha": time.strftime("%Y-%m-%d %H:%M")}
    if not cc.lanzar():
        print("el fork no quedo vivo"); return 1
    # el slot 3 esta en un nivel cargado ANTES del mod: J2 recien existe despues de cargar uno (el selector de
    # depuracion, igual que la regresion; City Streets, que tiene aliado para el titere)
    niv = cc.probar_nivel(0)
    res["nivel"] = {k: niv.get(k) for k in ("nombre", "armado_s", "vivo_despues", "r3", "cuelga_o_no_arma")}
    if niv.get("cuelga_o_no_arma"):
        print(json.dumps(res, ensure_ascii=False)); cc.matar_fork(); return 1
    time.sleep(2)
    with Pine() as p:
        res["r3_antes"] = {"armada": p.leer32(cm.R3_ARMADA), "cargas": p.leer32(cm.R3_CARGAS),
                           "J2_330": hex(p.leer32(cm.cj.J2 + 0x330))}
        res["poner"] = m2.poner(p)
        time.sleep(0.5)
        res["inicio"] = m2.estado(p)
        cc.cap("acc-%s-0-inicio.png" % modo)
        res["disparar"] = serie(p, "disparar", 1.5, 1.0)
        cc.cap("acc-%s-1-disparo.png" % modo)
        res["recargar"] = serie(p, "recargar", 0.2, 5.0)
        cc.cap("acc-%s-2-recarga.png" % modo)
        res["melee"] = serie(p, "melee", 0.2, 5.0)
        cc.cap("acc-%s-3-melee.png" % modo)
        # 4) (93s) el cambio de arma de J2, dos veces: con la ranura, R3_DESVIOS/REAPUNTES suben, J2+0x330
        #    vuelve a R3 y el duenio de r0 (la ranura de J) sigue siendo J
        pers = p.leer32(0x0040F50C)
        cambios = []
        for k in range(2):
            antes = {"desvios": p.leer32(cm.R3_DESVIOS), "reapuntes": p.leer32(cm.R3_REAPUNTES),
                     "arma_J2": hex(p.leer32(cm.cj.J2 + 0x2A4))}
            s = serie(p, "arma_b", 0.2, 3.0)
            cambios.append({"antes": antes, "serie": s["cambios"],
                            "despues": {"desvios": p.leer32(cm.R3_DESVIOS), "reapuntes": p.leer32(cm.R3_REAPUNTES),
                                        "arma_J2": hex(p.leer32(cm.cj.J2 + 0x2A4)),
                                        "J2_330": hex(p.leer32(cm.cj.J2 + 0x330)),
                                        "duenio_r0": hex(p.leer32(pers + 0x470)),
                                        "duenio_R3": hex(p.leer32(cm.R3)),
                                        "arma_J": hex(p.leer32(cm.cj.J + 0x2A4)),
                                        "estado_arma_J": p.leer32(p.leer32(cm.cj.J + 0x2A4) + 0xD8)}})
            cc.cap("acc-%s-4-cambio%d.png" % (modo, k))
        res["cambio_arma"] = cambios
        res["quitar"] = m2.quitar(p)
        res["r3_despues"] = {"desvios": p.leer32(cm.R3_DESVIOS), "reapuntes": p.leer32(cm.R3_REAPUNTES),
                             "J2_330": hex(p.leer32(cm.cj.J2 + 0x330)), "duenio_R3": hex(p.leer32(cm.R3))}
    r = cc.run("selector_depuracion.py", "vivo")
    res["vivo_despues"] = r is not None and '"vivo": true' in r.stdout
    cc.SAL.mkdir(parents=True, exist_ok=True)
    (cc.SAL / ("acciones-%s.json" % modo)).write_text(json.dumps(res, indent=1, ensure_ascii=False))
    print(json.dumps(res, ensure_ascii=False))
    cc.matar_fork()
    return 0


if __name__ == "__main__":
    sys.exit(main())
