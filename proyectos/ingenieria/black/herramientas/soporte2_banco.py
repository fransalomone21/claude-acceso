#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""soporte2_banco.py -- (125) el banco de la pieza 2d de la C (J2 con SU soporte de modelo, sus buffers de registros
y sus accesorios; coop_soporte2.py), de punta a punta, en el fork. Predicciones: sesiones/PREDICCIONES-125.md,
escritas en frio ANTES de correrlo.

    python herramientas/soporte2_banco.py pieza      # instalar --con-soporte2, lanzar, City Streets carga 1 + carga 2
    python herramientas/soporte2_banco.py control    # instalar --sin-soporte2, lanzar, carga 1 (F7, la linea de base)

El esqueleto es el de arma_pieza_banco.py (121)/(123), sin copiarlo: usa su `medir()` -- la precondicion CONSTRUIDA
(J2 junta una 2.a arma), el cambio de arma APRETADO Y MEDIDO, la vida entre pasos (ROJO_MUERTO), las fotos con md5 y
cortadas en mitades -- y le agrega al estado de cada paso el SEAM DE LA PIEZA, que se lee siempre:
  - los tres campos de F7 de J y de J2 (`+0x328`, `+0x354`, `+0x358`): con la pieza, los de J2 en la memoria del mod
    (coop_soporte2.SOP / BUF_A / BUF_B) y los de J donde estaban; sin ella, iguales (lo de (124));
  - el modelo de cada soporte: con la pieza, el cambio de J2 mueve SOLO el de J2;
  - los registros: lo que hay en cada buffer contra lo que FUN_00136B50 copia del modelo de SU soporte;
  - los accesorios 5-7 de cada uno: el objeto, su duenio (+0) y su enganche (+8).
Deja el fork abierto (J1 en el mando falso: campana_coop.entregar_a_fran() antes de que juegue Fran). El pnach queda
como lo dejo el ultimo modo. Salida: volcados/arma/banco-soporte2-<modo>-<fecha-hora>.json y las carpetas de
`medir()` (volcados/arma/pieza-soporte2-<modo>-carga<n>-<fecha-hora>/).
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import arma_pieza_banco as ab  # noqa: E402
import campana_coop as cc  # noqa: E402
import clon_jugador as cj  # noqa: E402
import coop_soporte2 as cs2  # noqa: E402
import f7_soporte as f7  # noqa: E402

ESTADO_BANCO = ab.estado   # el estado del banco del arma (cuadros de J2, armas, ranuras, vida), sin tocar
REG_A = 0x1C               # (126) el largo de un registro del buffer de +0x354 (56 B = 2 registros, pistola y SPAS)


def soporte(p):
    """El seam de la pieza: los campos de F7, el modelo de cada soporte, los registros y los accesorios 5-7."""
    d = {}
    for nom, P in (("J", cj.J), ("J2", cj.J2)):
        h = p.leer32(P + f7.SOPORTE)
        mod = p.leer32(h) if h else 0
        regs = []
        for dst_off, src_off, len_off in f7.COPIAS:
            dst, src, n = p.leer32(P + dst_off), p.leer32(mod + src_off) if mod else 0, p.leer32(mod + len_off) if mod else 0
            ok = 0 < n <= f7.LARGO_MAX and bool(src) and bool(dst)
            a, b = (p.leer_bloque(dst, n), p.leer_bloque(src, n)) if ok else (b"", b"")
            dist = [i for i in range(0, len(a), 4) if a[i:i + 4] != b[i:i + 4]]
            # (126) medido en el control: el DIBUJO reescribe el buffer de +0x354 en cada pasada (FUN_00136BD0 le pasa
            # a FUN_001AF738 un puntero adentro de cada registro de 0x1C B): de la copia de FUN_00136B50 sobreviven
            # solo las dos primeras palabras de cada registro. El de +0x358 queda como copia exacta.
            intactas = [i for i in dist if dst_off == f7.BUF_B or i % REG_A < 8]
            regs.append({"dst": hex(dst), "n": n, "distintas": [hex(i) for i in dist],
                         "igual_al_modelo": ok and not dist,
                         "copia_ok": ok and not intactas})
        accs = []
        for k in range(cs2.ACC_PRIMERO, cs2.ACC_PRIMERO + cs2.N_ACC):
            a = p.leer32(P + 0x25C + 4 * k)
            accs.append({"acc": hex(a), "duenio": hex(p.leer32(a)) if a else None,
                         "enganche": hex(p.leer32(a + 8)) if a else None})
        d[nom] = {"soporte": hex(h), "modelo": hex(mod), "buf_354": hex(p.leer32(P + f7.BUF_A)),
                  "buf_358": hex(p.leer32(P + f7.BUF_B)), "registros": regs, "accesorios": accs}
    d["comparten"] = all(d["J"][k] == d["J2"][k] for k in ("soporte", "buf_354", "buf_358"))
    d["J2_propio"] = (d["J2"]["soporte"] == hex(cs2.SOP) and d["J2"]["buf_354"] == hex(cs2.BUF_A)
                      and d["J2"]["buf_358"] == hex(cs2.BUF_B)
                      and [x["acc"] for x in d["J2"]["accesorios"]] ==
                      [hex(cs2.ACC + k * cs2.PASO_ACC) for k in range(cs2.N_ACC)]
                      and all(x["duenio"] == hex(cj.J2) for x in d["J2"]["accesorios"]))
    return d


def estado(p):
    d = ESTADO_BANCO(p)
    d["soporte2"] = soporte(p)
    return d


def veredicto(m, modo):
    """Lo que se lee de una carga, contra PREDICCIONES-125 (R1-R3). La IMAGEN la mira la sesion en las mitades."""
    if "base" not in m or "j2_cambio" not in m:
        return {"incompleto": True}
    b, c = m["base"]["soporte2"], m["j2_cambio"]["soporte2"]
    v = {"R1_base": b["J2_propio"] if modo == "pieza" else b["comparten"],
         "R2_J_no_cambia": b["J"]["modelo"] == c["J"]["modelo"],
         "R2_J2_cambia": b["J2"]["modelo"] != c["J2"]["modelo"],
         # (126) R3 se lee con `copia_ok` (lo que el dibujo no reescribe); `igual_al_modelo` da falso aun sin el mod
         "R3_registros": all(r["copia_ok"] for s in (b, c) for P in ("J", "J2") for r in s[P]["registros"])}
    if "j2_vuelve" in m:
        v["R2_vuelve"] = m["j2_vuelve"]["soporte2"]["J2"]["modelo"] == b["J2"]["modelo"]
    return v


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("modo", choices=["pieza", "control"])
    ap.add_argument("--con-j", action="store_true",
                    help="intentar darle una 2.a arma a J tambien (123: los intentos lo dejaron sin arma dibujada)")
    a = ap.parse_args()
    if cc.pcsx2_de_fran_abierto():
        print(json.dumps({"error": "el PCSX2 de Fran esta abierto: comparte PINE con el fork"}))
        return 1
    ab.estado = estado            # medir() lee `estado` del modulo: asi cada paso trae ademas el seam de la pieza
    ab.SAL.mkdir(parents=True, exist_ok=True)
    res = {"modo": modo_txt(a.modo), "nivel": cc.NOMBRES[ab.NIVEL]}
    r = subprocess.run([sys.executable, str(H / "coop_mod.py"), "instalar", "--sin-sub3",
                        "--con-soporte2" if a.modo == "pieza" else "--sin-soporte2"], capture_output=True, text=True)
    res["instalar"] = r.stdout.strip()[-400:]
    res["vivo"] = cc.lanzar()
    if not res["vivo"]:
        print(json.dumps(res))
        return 1
    for n in (1, 2) if a.modo == "pieza" else (1,):
        c = cc.probar_nivel(ab.NIVEL)
        res["carga%d" % n] = {k: c.get(k) for k in ("armado_s", "juego_s", "cuelga_o_no_arma", "vivo_despues", "r3")}
        if c.get("cuelga_o_no_arma"):
            break
        m = ab.medir("soporte2-%s-carga%d" % (a.modo, n), a.con_j)
        res["medida%d" % n] = m
        res["veredicto%d" % n] = veredicto(m, a.modo)
        print(json.dumps({"carga": n, "veredicto": res["veredicto%d" % n],
                          **{k: m.get(k) for k in ("dir", "ROJO", "ROJO_PASOS", "ROJO_MUERTO", "FOTOS_INVALIDAS")}},
                         ensure_ascii=False), flush=True)
    sal = ab.SAL / time.strftime("banco-soporte2-%s-%%Y%%m%%d-%%H%%M%%S.json" % a.modo)
    sal.write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({"salida": str(sal)}))
    return 0


def modo_txt(modo):
    return "pieza (--con-soporte2)" if modo == "pieza" else "control (--sin-soporte2)"


if __name__ == "__main__":
    sys.exit(main())
