#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""n27_banco.py -- (128) N27: la caida con el pnach POR DEFECTO al cambiar J2 de arma despues de una pausa.
Predicciones N0-N4: sesiones/PREDICCIONES-128.md, escritas antes de correrlo.

    python herramientas/n27_banco.py --rama pausa        # J2 en la 2.a arma, J en la pistola -> J pausa y vuelve -> J2 a la pistola
    python herramientas/n27_banco.py --rama sin-pausa    # el control: la misma precondicion y la misma espera, SIN la pausa

Instala el pnach por defecto (coop_mod.py instalar, sin opciones), lanza el fork y carga City Streets. La precondicion
la construye y la MIDE: J2 junta una 2.a arma y se queda con ella en la mano (f7b_pausa.py la iguala a la de J, y por
eso no puede armar esta). ROJO_PRECONDICION si J2 no quedo con dos armas y la 2.a en la mano, o si J no quedo con la
pistola sola. En cada paso: el doble bufer con el ESTADO (+0x1C) y la CLAVE (+0x28) de cada bufer (FUN_00143908 mira
solo el «otro»), el cambio de arma de cada jugador (W = P+0x280: +0x38 estado, +0x3C demora, +0x43 indice, +0x45/+0x46
la bajada; W+0x1C tiene que ser P: es el control de que W esta bien), la ranura 6 del cargador y el contador de J2.
Despues del cambio, el contador cada 0,5 s durante 6 s: si no sube en la 2.a mitad, el juego se cayo, y ANTES de
cerrar nada se guardan GPR y CP0, la RAM alrededor del EPC y f7b_hilos.py (registros.json, hilos.json).
Deja el fork abierto (cerrarlo con campana_coop.matar_fork()). Salida: volcados/arma/n27-<rama>-<fecha-hora>/.
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
import coop_mod as cm  # noqa: E402
import f7b_buffer as fb  # noqa: E402
import f7b_pausa as fp  # noqa: E402
import hud_doble as hd  # noqa: E402
import mando_j2 as m2  # noqa: E402
import sondas_coop as sc  # noqa: E402
from depurador import Depurador  # noqa: E402
from pine import Pine  # noqa: E402

W_OFF = 0x280                  # coop_mod.py: W = J2+0x280 (W+0x43 = P+0x2C3, el indice del arma)
CARGADOR, RANURA6_PEND = 0x0040F4C4, 6 * 0x140 + 0x138
PALABRAS_DEFECTO = 1059


def _w(p, P):
    w = P + W_OFF
    return {"w_ok": p.leer32(w + 0x1C) == P, "estado": p.leer32(w + 0x38), "demora": round(p.leer_f32(w + 0x3C), 3),
            "indice": p.leer8(w + 0x43), "baja": [p.leer8(w + 0x45), p.leer8(w + 0x46)],
            "activo_c4": p.leer32(P + 0xC4)}


def _bufs(p):
    s = p.leer32(fb.GLOBAL_BUF)
    otro = p.leer32(s + 0x80)
    r = []
    for i in range(2):
        b = s + fb.BUF0 + i * fb.PASO_BUF
        r.append({"b": hex(b), "otro": b == otro, "estado": p.leer32(b + 0x1C), "clave": hex(fb._u64(p, b + 0x28)),
                  "recurso": hex(p.leer32(b + 4)), "modelo": hex(p.leer32(b + 0x14))})
    return r


def estado(p):
    d = fb.estado(p)
    d["W"] = {"J": _w(p, cj.J), "J2": _w(p, cj.J2)}
    d["bufs"] = _bufs(p)
    d["ranura6"] = p.leer8(p.leer32(CARGADOR) + RANURA6_PEND)
    return d


def paso(res, dir_, nombre):
    with Pine() as p:
        res[nombre] = estado(p)
    hd.captura(dir_, nombre.replace("_", "-") + ".png")


def serie(n=12, dt=0.5):
    xs = []
    for _ in range(n):
        with Pine() as p:
            xs.append(p.leer32(cm.CONTADOR))
        time.sleep(dt)
    return xs


def _regs(bloque):
    """{'GPR': {'regs': [{'name', 'value'}, ...]}} -> {nombre: valor}; si la forma es otra, se guarda cruda."""
    out = {}
    for cat, v in (bloque or {}).items():
        regs = v.get("regs") if isinstance(v, dict) else None
        if isinstance(regs, list):
            out.update({x.get("name"): x.get("value") for x in regs if isinstance(x, dict)})
    return out


def capturar_caida(dir_):
    cap = {}
    with Depurador() as d:
        cap["estado"] = d.estado()
        cap["muestras_pc"] = []
        for _ in range(6):
            cap["muestras_pc"].append(d.estado().get("pc"))
            time.sleep(0.3)
        for cat in (0, 1):
            try:
                cap["cat%d" % cat] = d.registros(cat)
            except Exception as ex:  # noqa: BLE001
                cap["cat%d" % cat] = "error: %s" % ex
        planos = _regs(cap.get("cat0") if isinstance(cap.get("cat0"), dict) else {})
        planos.update(_regs(cap.get("cat1") if isinstance(cap.get("cat1"), dict) else {}))
        cap["planos"] = planos
        epc = next((v for k, v in planos.items() if k and k.lower() == "epc"), None)
        cap["epc"] = epc
        if epc is not None:
            e = int(str(epc)[-8:], 16)
            try:
                cap["ram_epc"] = d.desensamblar(e - 0x20, 16)
            except Exception as ex:  # noqa: BLE001
                cap["ram_epc"] = "error: %s" % ex
        ra = planos.get("ra")
        if ra is not None:
            try:
                cap["ram_ra"] = d.desensamblar(int(str(ra)[-8:], 16) - 0x10, 8)
            except Exception as ex:  # noqa: BLE001
                cap["ram_ra"] = "error: %s" % ex
    (dir_ / "registros.json").write_text(json.dumps(cap, indent=1, ensure_ascii=False), encoding="utf-8")
    r = subprocess.run([sys.executable, str(H / "f7b_hilos.py"), str(dir_)], capture_output=True, text=True)
    return {"epc": cap.get("epc"), "cause": next((v for k, v in planos.items() if k and k.lower() == "cause"), None),
            "v1": planos.get("v1"), "ra": planos.get("ra"), "pc": cap["estado"].get("pc"),
            "pcs": sorted(set(map(str, cap["muestras_pc"]))), "hilos": r.stdout.strip()[:400]}


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--rama", choices=("pausa", "sin-pausa"), required=True)
    a = ap.parse_args()
    if cc.pcsx2_de_fran_abierto():
        print(json.dumps({"error": "el PCSX2 de Fran esta abierto: comparte PINE con el fork"}))
        return 1
    dir_ = ab.SAL / time.strftime("n27-%s-%%Y%%m%%d-%%H%%M%%S" % a.rama)
    dir_.mkdir(parents=True, exist_ok=True)
    hd.FOTOS.clear()
    res = {"dir": str(dir_), "rama": a.rama}
    r = subprocess.run([sys.executable, str(H / "coop_mod.py"), "instalar"], capture_output=True, text=True)
    try:
        inst = json.loads(r.stdout.strip().splitlines()[-1])
    except Exception:  # noqa: BLE001
        inst = {"crudo": r.stdout.strip()[-300:]}
    res["instalar"] = inst
    # «cambio» False = el pnach en disco es identico al que genera `instalar` sin opciones: es el por defecto
    defecto = inst.get("cambio") is False or (inst.get("palabras") == PALABRAS_DEFECTO and not inst.get("soporte2_j2"))
    if not defecto:
        res["ROJO"] = "el pnach no es el por defecto (%s palabras): N27 es del pnach por defecto" % inst.get("palabras")
        return _cerrar(res, dir_)
    res["vivo"] = cc.lanzar()
    if not res["vivo"]:
        res["ROJO"] = "el fork no arranco"
        return _cerrar(res, dir_)
    c = cc.probar_nivel(ab.NIVEL)
    res["carga"] = {k: c.get(k) for k in ("armado_s", "juego_s", "cuelga_o_no_arma", "vivo_despues")}
    with Pine() as p:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:
            sc.falso_poner(p)
        m2.poner(p)
        res["preparar"] = ab.preparar(p, intentar_j=False)
    time.sleep(1.0)
    paso(res, dir_, "base")
    b = res["base"]
    pistola = b["J"]["clave"]
    res["N0"] = (len(b["J"]["armas"]) == 1 and len(b["J2"]["armas"]) == 2 and b["J2"]["armas"][0] == pistola
                 and b["J2"]["clave"] not in (None, pistola) and b["W"]["J"]["w_ok"] and b["W"]["J2"]["w_ok"])
    if not res["N0"]:
        res["ROJO_PRECONDICION"] = "J2 no quedo con dos armas y la 2.a en la mano, o J no quedo con la pistola sola"
        return _cerrar(res, dir_)
    if a.rama == "pausa":
        fp._pulsar(fp.START)
        time.sleep(2.5)
        paso(res, dir_, "en_pausa")
        fp._pulsar(fp.CONFIRMAR)
        time.sleep(2.5)
        paso(res, dir_, "vuelta")
    else:
        time.sleep(2.7)
        paso(res, dir_, "en_pausa")
        time.sleep(2.7)
        paso(res, dir_, "vuelta")
    time.sleep(1.0)
    paso(res, dir_, "pre_cambio")
    res["cambio"] = ab.cambiar(m2.boton, cj.J2, ab.ARMA_A)
    res["serie"] = serie()
    xs = res["serie"]
    res["cayo"] = xs[-1] == xs[len(xs) // 2]
    if res["cayo"]:
        res["caida"] = capturar_caida(dir_)
    paso(res, dir_, "despues")
    return _cerrar(res, dir_)


def _cerrar(res, dir_):
    try:
        with Pine() as p:
            m2.quitar(p)
    except Exception as ex:  # noqa: BLE001
        res["quitar_mando"] = "error: %s" % ex
    res["fotos"] = dict(hd.FOTOS)
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({k: res.get(k) for k in ("dir", "rama", "ROJO", "ROJO_PRECONDICION", "N0", "cambio", "serie",
                                              "cayo", "caida")}, ensure_ascii=False))
    for n in ("base", "en_pausa", "vuelta", "pre_cambio", "despues"):
        if n in res:
            x = res[n]
            print(n, "| J2", x["J2"]["clave"], "W", x["W"]["J2"]["estado"], x["W"]["J2"]["indice"],
                  "| J W", x["W"]["J"]["estado"],
                  "| bufs", [(y["otro"], y["estado"], y["clave"][-8:], y["modelo"]) for y in x["bufs"]],
                  "| r6", x["ranura6"], "| c", x["cuadros_J2"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
