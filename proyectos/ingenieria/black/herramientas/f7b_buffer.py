#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""f7b_buffer.py -- (126) F7b: el DOBLE BUFER de recursos del arma en la mano (`*(0x0040F540)` = 0x005BFC00) con dos
jugadores. Predicciones: sesiones/PREDICCIONES-126.md, escritas antes de correrlo.

    python herramientas/f7b_buffer.py            # sobre el fork YA ABIERTO en City Streets (lo deja un banco)

El mecanismo (probable, en frio): +0 el indice del actual, +0x08/+0x40 los dos buferes de 0x38 B (+0x08 cue, +0x0C
cue alterno, +0x14 modelo, +0x18 agregados), +0x7C el actual, +0x80 el otro. Un cambio de arma carga la nueva en EL
OTRO y libera lo que tenia (FUN_00143C80 / FUN_00143FD8), y alterna (FUN_00144078). Con dos jugadores: si X cambia dos
veces seguidas, la segunda carga va al bufer del arma que Y tiene en la mano.

La secuencia que lo destapa (y que el banco de (125) no armaba): precondicion J con {pistola, X} y J2 con {pistola,
SPAS}, X distinta de la SPAS, los dos en la pistola -> J2 a la SPAS -> J a X (control: un solo cambio de J) -> J a la
pistola (el 2.o seguido de J). En cada paso: el doble bufer, el soporte de cada uno (soporte2_banco.soporte), si el
modelo de cada uno es el +0x14 de algun bufer (residente), la clave del arma en la mano, el contador de J2 y una foto
cortada en mitades. Salida: volcados/arma/f7b-<fecha-hora>/ (resumen.json + fotos).
"""
import json
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import arma_pieza_banco as ab  # noqa: E402
import armas_j2  # noqa: E402
import clon_jugador as cj  # noqa: E402
import coop_mod as cm  # noqa: E402
import hud_doble as hd  # noqa: E402
import mando_j2 as m2  # noqa: E402
import sondas_coop as sc  # noqa: E402
import soporte2_banco as sb  # noqa: E402
from pine import Pine  # noqa: E402

GLOBAL_BUF = 0x0040F540
PASO_BUF, BUF0 = 0x38, 0x08


def _u64(p, a):
    return p.leer32(a) | (p.leer32(a + 4) << 32)


def _clave(p, arma):
    k = p.leer32(arma + 0xE8) if arma else 0
    return hex(_u64(p, k)) if k else None


def buferes(p):
    s = p.leer32(GLOBAL_BUF)
    bs = [{"W": hex(s + BUF0 + i * PASO_BUF), "cue": hex(p.leer32(s + BUF0 + i * PASO_BUF + 8)),
           "modelo": hex(p.leer32(s + BUF0 + i * PASO_BUF + 0x14))} for i in range(2)]
    return {"singleton": hex(s), "indice": p.leer8(s), "actual": hex(p.leer32(s + 0x7C)),
            "otro": hex(p.leer32(s + 0x80)), "buferes": bs}


def estado(p):
    b = buferes(p)
    sop = sb.soporte(p)
    modelos = {x["modelo"] for x in b["buferes"]}
    d = {"buf": b, "cuadros_J2": p.leer32(cm.CONTADOR)}
    for nom, P in (("J", cj.J), ("J2", cj.J2)):
        a = armas_j2.armas(p, P)
        mano = int(a["mano"], 16)
        d[nom] = {"indice": a["indice_2C3"], "clave": _clave(p, mano), "modelo": sop[nom]["modelo"],
                  "residente": sop[nom]["modelo"] in modelos,
                  "en_bufer": [i for i, x in enumerate(b["buferes"]) if x["modelo"] == sop[nom]["modelo"]],
                  "copia_ok": [r["copia_ok"] for r in sop[nom]["registros"]],
                  "armas": [_clave(p, int(x, 16)) for x in a["armas"] if x != "0x0"]}
    return d


def dar_segunda_a_j(p, claves_j2):
    """J junta un arma del piso que NO sea ninguna de las de J2 (la receta de S1, (111))."""
    intentos = []
    _, libres = ab._armas_del_piso(p)
    for r in libres[:5]:
        intentos.append(ab._juntar(p, r["i"], "J"))
        armas = [_clave(p, int(x, 16)) for x in armas_j2.armas(p, cj.J)["armas"] if x != "0x0"]
        if len(armas) >= 2 and not set(armas[1:]) & set(claves_j2):
            break
    return intentos


def por_j2():
    """(126) la precondicion alternativa (J no junta: 3 de 3, como en (123)): J2, en la pistola, la cambia por una
    tercera arma X del piso -> J2 {X, SPAS}, J {pistola}. Despues, cambios seguidos de J2 (C1, C2): cada uno carga en el
    bufer que no es el ultimo cargado, que es el de la pistola de J."""
    dir_ = ab.SAL / time.strftime("f7b-porj2-%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    hd.FOTOS.clear()
    res = {"dir": str(dir_)}
    with Pine() as p:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:
            sc.falso_poner(p)
        m2.poner(p)
        e = estado(p)
    pistola = e["J"]["clave"]
    if e["J2"]["clave"] != pistola:
        res["J2_a_pistola"] = ab.cambiar(m2.boton, cj.J2, ab.ARMA_A)
    with Pine() as p:
        antes = estado(p)
        res["antes"] = antes
        res["juntar"] = []
        _, libres = ab._armas_del_piso(p)
        for r in libres[:4]:
            res["juntar"].append(ab._juntar(p, r["i"], "J2"))
            time.sleep(1.5)
            armas = set(estado(p)["J2"]["armas"])
            if armas - set(antes["J2"]["armas"]):
                break
    time.sleep(2.0)
    with Pine() as p:
        res["base"] = estado(p)
    b = res["base"]
    res["C0"] = (b["J"]["clave"] == pistola and b["J"]["residente"] and len(b["J2"]["armas"]) >= 2
                 and pistola not in b["J2"]["armas"])
    hd.captura(dir_, "base.png")
    if not res["C0"]:
        res["ROJO"] = "no se construyo la precondicion C0 (J2 {X, SPAS}, J en la pistola residente)"
    else:
        for nombre in ("j2_a", "j2_b"):
            res[nombre + "_pulso"] = ab.cambiar(m2.boton, cj.J2, ab.ARMA_A)
            if not res[nombre + "_pulso"]["ocurrio"]:
                res.setdefault("ROJO_PASOS", []).append(nombre)
            time.sleep(1.0)
            with Pine() as p:
                res[nombre] = estado(p)
            hd.captura(dir_, nombre.replace("_", "-") + ".png")
    return cerrar(res, dir_, ("antes", "base", "j2_a", "j2_b"))


def cerrar(res, dir_, pasos):
    with Pine() as p:
        m2.quitar(p)
    vistos = [(n, res[n]["cuadros_J2"]) for n in pasos if n in res]
    if any(y == x for (_, x), (_, y) in zip(vistos, vistos[1:])):
        res["ROJO_MUERTO"] = "el contador de J2 no subio entre pasos: el juego estaba colgado"
    res["fotos"] = dict(hd.FOTOS)
    res["mitades"] = {n: ab._mitades(dir_, n) for n in res["fotos"]}
    if hd.fotos_invalidas(hd.FOTOS):
        res["FOTOS_INVALIDAS"] = "falta una foto o hay dos identicas"
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({k: res.get(k) for k in ("dir", "B0", "C0", "ROJO", "ROJO_PASOS", "ROJO_MUERTO",
                                              "FOTOS_INVALIDAS")}, ensure_ascii=False))
    for n in pasos:
        if n in res:
            x = res[n]
            print(n, "buf", x["buf"]["indice"], [(y["modelo"]) for y in x["buf"]["buferes"]],
                  "| J", x["J"]["clave"], x["J"]["modelo"], x["J"]["en_bufer"],
                  "| J2", x["J2"]["clave"], x["J2"]["modelo"], x["J2"]["en_bufer"], x["J2"]["armas"],
                  "| c", x["cuadros_J2"])
    return 0


def main():
    if "--por-j2" in sys.argv[1:]:
        return por_j2()
    dir_ = ab.SAL / time.strftime("f7b-%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    hd.FOTOS.clear()
    res = {"dir": str(dir_)}
    with Pine() as p:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:
            sc.falso_poner(p)
        m2.poner(p)
        e = estado(p)
        if len(e["J2"]["armas"]) < 2:
            res["preparar_J2"] = ab.preparar(p, intentar_j=False)
            e = estado(p)
        res["dar_a_J"] = dar_segunda_a_j(p, e["J2"]["armas"])
    # los dos en la PISTOLA (la que tienen en comun): indice 0 de J2, y J en la arma cuya clave es la de la pistola
    with Pine() as p:
        e = estado(p)
    pistola = e["J2"]["armas"][0]
    if e["J2"]["indice"] != 0:
        res["J2_a_pistola"] = ab.cambiar(m2.boton, cj.J2, ab.ARMA_A)
    with Pine() as p:
        e = estado(p)
    if e["J"]["clave"] != pistola:
        res["J_a_pistola"] = ab.cambiar(sc.poner_boton, cj.J, ab.ARMA_A)
    with Pine() as p:
        res["base"] = estado(p)
    b = res["base"]
    res["B0"] = (len(b["J"]["armas"]) >= 2 and len(b["J2"]["armas"]) >= 2 and b["J"]["clave"] == pistola
                 and b["J2"]["clave"] == pistola and not set(b["J"]["armas"]) - {pistola} & set(b["J2"]["armas"]))
    hd.captura(dir_, "base.png")
    if not res["B0"]:
        res["ROJO"] = "no se construyo la precondicion B0: la corrida no discrimina nada"
    else:
        for nombre, poner, P in (("j2_spas", m2.boton, cj.J2), ("j_x", sc.poner_boton, cj.J),
                                 ("j_pistola", sc.poner_boton, cj.J)):
            res[nombre + "_pulso"] = ab.cambiar(poner, P, ab.ARMA_A)
            if not res[nombre + "_pulso"]["ocurrio"]:
                res.setdefault("ROJO_PASOS", []).append(nombre)
            time.sleep(1.0)
            with Pine() as p:
                res[nombre] = estado(p)
            hd.captura(dir_, nombre.replace("_", "-") + ".png")
    with Pine() as p:
        m2.quitar(p)
    vistos = [(n, res[n]["cuadros_J2"]) for n in ("base", "j2_spas", "j_x", "j_pistola") if n in res]
    if any(y == x for (_, x), (_, y) in zip(vistos, vistos[1:])):
        res["ROJO_MUERTO"] = "el contador de J2 no subio entre pasos: el juego estaba colgado"
    res["fotos"] = dict(hd.FOTOS)
    res["mitades"] = {n: ab._mitades(dir_, n) for n in res["fotos"]}
    if hd.fotos_invalidas(hd.FOTOS):
        res["FOTOS_INVALIDAS"] = "falta una foto o hay dos identicas"
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({k: res.get(k) for k in ("dir", "B0", "ROJO", "ROJO_PASOS", "ROJO_MUERTO", "FOTOS_INVALIDAS")},
                     ensure_ascii=False))
    for n in ("base", "j2_spas", "j_x", "j_pistola"):
        if n in res:
            x = res[n]
            print(n, "buf", x["buf"]["indice"], [(y["modelo"]) for y in x["buf"]["buferes"]],
                  "| J", x["J"]["clave"], x["J"]["modelo"], x["J"]["en_bufer"],
                  "| J2", x["J2"]["clave"], x["J2"]["modelo"], x["J2"]["en_bufer"], "| c", x["cuadros_J2"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
