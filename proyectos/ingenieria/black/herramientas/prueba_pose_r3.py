#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
prueba_pose_r3.py -- (96) ¿que pose dibuja la mitad de J2? En el fork, J2 recarga en RAM (cargador 10 -> 15) y
en su mitad el arma NO se mueve (E2); en el video de Fran la mitad de J2 repetia la recarga de J (E1).

Mide en RAM, con capturas en los mismos momentos. Por muestra (~60 ms): las 0x9D0 B del compañero (+0x54) de la
ranura de J (*(J+0x330)) y de la de J2 (*(J2+0x330) = R3). Fases: base 1,5 s (nadie aprieta nada), J2 dispara y
recarga, J dispara y recarga. Cuenta las palabras que cambian en cada fase FUERA de las que cambian en la base.
Prediccion (escrita antes): si la pose de J2 no se anima, el compañero de R3 cambia ~0 en la fase de J2; si la
mitad de J2 comparte la pose de J, los dos compañeros son el mismo puntero o el de R3 cambia en la fase de J.

    python herramientas/prueba_pose_r3.py       # lanza el fork; se niega con el PCSX2 de Fran abierto
Salida: volcados/campana/pose-r3.json y capturas pr3-*.png.
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

J, J2 = cm.cj.J, cm.cj.J2


def palabras(b):
    return [int.from_bytes(b[i:i + 4], "little") for i in range(0, len(b), 4)]


def fase(p, zonas, segundos, acciones, capt=None):
    """acciones: [(t, funcion)] en segundos desde el inicio de la fase; capt: [(t, nombre)]."""
    serie, t0, hechas, capts = [], time.time(), set(), set()
    while time.time() - t0 < segundos:
        t = time.time() - t0
        for k, (ta, f) in enumerate(acciones):
            if k not in hechas and t >= ta:
                f(); hechas.add(k)
        for k, (tc, n) in enumerate(capt or []):
            if k not in capts and t >= tc:
                cc.cap(n); capts.add(k)
        serie.append({z: palabras(p.leer_bloque(d, 0x9D0)) for z, d in zonas.items()})
    return serie


def cambiadas(serie, z):
    base = serie[0][z]
    return {i for m in serie for i, w in enumerate(m[z]) if w != base[i]}


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
        sc.falso_poner(p)
        m2.poner(p)
        rj, rj2 = p.leer32(J + 0x330), p.leer32(J2 + 0x330)
        cj_, cj2 = p.leer32(rj + 0x54), p.leer32(rj2 + 0x54)
        res["ranuras"] = {"J_330": hex(rj), "J2_330": hex(rj2), "comp_J": hex(cj_), "comp_J2": hex(cj2),
                          "misma_ranura": rj == rj2, "mismo_comp": cj_ == cj2}
        zonas = {"comp_J": cj_, "comp_J2": cj2}
        b = lambda i, v: (lambda: m2.boton(p, m2.NOMBRES[i], v))       # noqa: E731
        a = lambda i, v: (lambda: sc.poner_boton(p, sc.BOTONES[i], v))  # noqa: E731
        base = fase(p, zonas, 1.5, [])
        f2 = fase(p, zonas, 4.0, [(0.0, b("disparar", True)), (1.0, b("disparar", False)),
                                  (1.5, b("recargar", True)), (1.7, b("recargar", False))],
                  [(2.0, "pr3-j2-recarga-a.png"), (2.5, "pr3-j2-recarga-b.png")])
        e2 = m2.estado(p)
        f1 = fase(p, zonas, 4.0, [(0.0, a("disparar", True)), (1.0, a("disparar", False)),
                                  (1.5, a("recargar", True)), (1.7, a("recargar", False))],
                  [(2.0, "pr3-j-recarga-a.png"), (2.5, "pr3-j-recarga-b.png")])
        ruido = {z: cambiadas(base, z) for z in zonas}
        res["muestras"] = {"base": len(base), "J2": len(f2), "J": len(f1)}
        res["cambian_fuera_de_la_base"] = {
            fn: {z: len(cambiadas(s, z) - ruido[z]) for z in zonas} for fn, s in (("fase_J2", f2), ("fase_J", f1))}
        res["ruido_base"] = {z: len(v) for z, v in ruido.items()}
        res["J2_tras_recargar"] = e2
        m2.quitar(p); sc.falso_quitar(p)
    cc.SAL.mkdir(parents=True, exist_ok=True)
    (cc.SAL / "pose-r3.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps(res, ensure_ascii=False))
    cc.matar_fork()
    return 0


if __name__ == "__main__":
    sys.exit(main())
