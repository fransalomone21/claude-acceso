#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
prueba_vista_j2.py -- (96) los errores del video 20260928-145814, con su control en la misma corrida.

E1: ¿el arma en primera persona de J se dibuja en la mitad de J2? Con el bloque instalado con
    `coop_mod.py instalar --sin-ocultar-j`, el dato C (0x0046FBEC) queda fuera del pnach y se alterna por
    PINE: C = 0 (control, como hasta (95)) y C = J (el arreglo). J recarga con el mando falso de J y se
    captura la pantalla a 0,5 y 1,0 s. Prediccion: con C = J la mitad de J2 muestra la pistola quieta de J2.
E2: con C = J, J2 dispara 1 s y recarga: capturas a 0,4 / 0,8 / 1,2 s y la serie estado/cargador.
E3: ¿la vista de J2 sube sola al disparar seguido? Cabeceo de la mira (+0x4F0+0xC) cada 0,1 s mientras
    dispara 3 s sin tocar la mira; control: J lo mismo.

    python herramientas/prueba_vista_j2.py          # lanza el fork; se niega con el PCSX2 de Fran abierto
Salida: volcados/campana/vista-j2.json y capturas vj2-*.png en la misma carpeta.
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
import ocultar_pasada as oc  # noqa: E402
import sondas_coop as sc  # noqa: E402

J, J2 = cm.cj.J, cm.cj.J2


def cabeceo(p, P):
    return round(p.leer_f32(P + 0x4F0 + 0xC), 3)


def boton_j(p, nombre, apretado):
    sc.poner_boton(p, sc.BOTONES[nombre], apretado)


def boton_j2(p, nombre, apretado):
    m2.boton(p, m2.NOMBRES[nombre], apretado)


def serie_cabeceo(p, P, apretar, segundos=3.0):
    out, t0 = [], time.time()
    apretar(p, "disparar", True)
    while time.time() - t0 < segundos:
        out.append([round(time.time() - t0, 2), cabeceo(p, P)])
        time.sleep(0.1)
    apretar(p, "disparar", False)
    t1 = time.time()
    while time.time() - t1 < 2.0:            # y la recuperacion despues de soltar
        out.append([round(time.time() - t0, 2), cabeceo(p, P)])
        time.sleep(0.1)
    return out


def e1(p, res, modo, valor, k):
    p.escribir32(oc.C, valor)
    time.sleep(0.5)
    c0 = p.leer32(oc.CNT2)
    boton_j(p, "disparar", True); time.sleep(0.6); boton_j(p, "disparar", False)
    time.sleep(0.8)
    boton_j(p, "recargar", True); time.sleep(0.2); boton_j(p, "recargar", False)
    time.sleep(0.3); cc.cap("vj2-e1-%s-%d-a.png" % (modo, k))
    time.sleep(0.5); cc.cap("vj2-e1-%s-%d-b.png" % (modo, k))
    time.sleep(2.0)
    res.setdefault("e1", []).append({"modo": modo, "C": hex(p.leer32(oc.C)), "ocultos_p2": p.leer32(oc.CNT2) - c0,
                                     "estado_arma_J": sc.observables_arma(p)["estado_arma_D8"]})


def main() -> int:
    tolerar_salida_pobre()
    if cc.pcsx2_de_fran_abierto():
        print("el PCSX2 de Fran esta abierto: no"); return 1
    res = {"fecha": time.strftime("%Y-%m-%d %H:%M")}
    if not cc.lanzar():
        print("el fork no quedo vivo"); return 1
    niv = cc.probar_nivel(0)
    res["nivel"] = {k: niv.get(k) for k in ("nombre", "armado_s", "r3", "cuelga_o_no_arma")}
    if niv.get("cuelga_o_no_arma"):
        print(json.dumps(res, ensure_ascii=False)); cc.matar_fork(); return 1
    time.sleep(2)
    with Pine() as p:
        res["C_inicial"] = hex(p.leer32(oc.C))
        sc.falso_poner(p)
        res["poner_j2"] = m2.poner(p)
        time.sleep(0.5)
        # E1: control, arreglo, control, arreglo (alternado: que el orden no explique la diferencia)
        for k, (modo, v) in enumerate([("control", 0), ("arreglo", J), ("control", 0), ("arreglo", J)]):
            e1(p, res, modo, v, k)
        # E2 (con el arreglo)
        p.escribir32(oc.C, J)
        boton_j2(p, "disparar", True); time.sleep(1.0); boton_j2(p, "disparar", False)
        time.sleep(0.8)
        antes = m2.estado(p)
        boton_j2(p, "recargar", True); time.sleep(0.2); boton_j2(p, "recargar", False)
        serie, t0 = [], time.time()
        for n, t in enumerate((0.4, 0.8, 1.2)):
            while time.time() - t0 < t:
                e = m2.estado(p); serie.append([round(time.time() - t0, 2), e["estado_D8"], e["cargador"]])
                time.sleep(0.05)
            cc.cap("vj2-e2-%d.png" % n)
        time.sleep(1.5)
        res["e2"] = {"antes": antes, "serie": serie, "despues": m2.estado(p)}
        # E3: J2 y J disparan 3 s sin tocar la mira (J2 primero, despues el control)
        res["e3_J2"] = serie_cabeceo(p, J2, boton_j2)
        time.sleep(1.0)
        res["e3_J"] = serie_cabeceo(p, J, boton_j)
        cc.cap("vj2-e3-fin.png")
        res["quitar_j2"] = m2.quitar(p)
        sc.falso_quitar(p)
    cc.SAL.mkdir(parents=True, exist_ok=True)
    (cc.SAL / "vista-j2.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps(res, ensure_ascii=False))
    cc.matar_fork()
    return 0


if __name__ == "__main__":
    sys.exit(main())
