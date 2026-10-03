#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""arma_pieza_banco.py -- (121) el banco de la pieza 2b de la C (el MODELO DE ARMA de J2: su sub propio del aparejo),
de punta a punta, en el fork. Predicciones P3a-P3e de sesiones/PREDICCIONES-118.md, escritas en (118).

    python herramientas/arma_pieza_banco.py pieza      # instalar --con-sub3, lanzar, City Streets carga 1 + carga 2
    python herramientas/arma_pieza_banco.py control    # instalar --sin-sub3, lanzar, carga 1 (el CONTROL)

Calcado de sonido_pieza_banco.py (116) y de hud_pieza_banco.py (115): mismo esqueleto (instalar -> lanzar -> carga ->
medir), mismo seam en RAM alrededor de cada escena, mismas fotos con md5 y FOTOS_INVALIDAS.

LA PRECONDICION SE CONSTRUYE, NO SE SUPONE (medido el 2026-10-03, (121), a costa de una corrida entera): en City
Streets cargado por el selector, J y J2 tienen UNA SOLA ARMA cada uno, asi que el boton de cambio no hace nada y la
corrida sale IGUAL en los cuatro pasos -- un banco que no mide su precondicion saca cuatro fotos de nada. La segunda
arma de J2 se consigue con la receta ya medida en (111): `s1_juntar.py` (J sobre un arma del piso, J2 mantiene
«agarrar»). Si no se logra, el banco sale en ROJO y NO se concluye nada de las fotos.

EL DISCRIMINADOR DE P3a ES LA FOTO, y el seam en RAM es el refuerzo (al reves que en la pieza 2a):
  - foto: con J2 en la 2.a arma, SIN la pieza las DOS mitades dibujan ESA arma aunque el HUD de J siga marcando la
    munición de la suya (medido hoy: 015\030 a la izquierda con el AK dibujado). CON la pieza, la mitad de J tiene
    que volver a dibujar el arma de J. Es F7, el blanco de la 2b.
  - `SUB3_ESCRIB` (0x0046EF74) y `SUB3_SALTOS` (0x0046EF78): las dos ramas de la regla del dueno de plantilla. Es lo
    que hace medible P3d -- la guarda de plantilla viva de (118) SALTA en vez de escribir sobre un puntero colgado.
  - `SUB3_MOLDE` (0x0046EF70) contra `MOLDES`: si en la carga 2 el sub3 esta en uso, el desarme corrio y lo rearmo
    (P3e); si el desarme no hubiera corrido, los bloques del envoltorio y del por-cuadro no lo tomarian.
  - `R3+0x50` y `ranura_de_J+0x50`: el sub de cada ranura. OJO, medido hoy: con indices de arma DISTINTOS las dos
    ranuras ya caen en subs distintos (sub_0 y sub_1) y aun asi las dos mitades dibujan el mismo modelo -- asi que
    este dato NO es el discriminador del modelo, es contexto. CON la pieza, la de J2 tiene que pasar a SUB3.
  - la guarda viva `*(p+0x1C) == p+0x4C` medida sobre la plantilla de cada sub, igual que sub_estado.py (118).

LA SECUENCIA DEL PELIGRO (P3b), por carga, con una foto y un estado en cada paso:
  base (los dos en el MISMO indice de arma: el banco lleva a J2 al 0 y lo anota) -> J2 cambia a su 2.a arma -> J2
  vuelve -> y, si se le consiguio una 2.a arma a J, J cambia y vuelve. Es el ciclo que destapa la pieza: el ultimo
  que arma se queda con la plantilla compartida.

Deja el fork abierto (J1 en el mando falso: campana_coop.entregar_a_fran() antes de que juegue Fran). El pnach queda
como lo dejo el ultimo modo.
Salida: volcados/arma/banco-<modo>-<fecha-hora>.json y volcados/arma/pieza-<etiqueta>-<fecha-hora>/*.png
(cada foto, ademas, cortada en sus dos mitades `-izq.png` / `-der.png` para mirar que modelo dibuja cada una).
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import armas_j2  # noqa: E402
import campana_coop as cc  # noqa: E402
import clon_jugador as cj  # noqa: E402
import coop_mod as cm  # noqa: E402
import coop_sub3 as cs  # noqa: E402
import hud_doble as hd  # noqa: E402
import mando_j2 as m2  # noqa: E402
import s1_juntar as s1  # noqa: E402
import sondas_coop as sc  # noqa: E402
import teletransporte  # noqa: E402
from pine import Pine  # noqa: E402

NIVEL = 0                      # City Streets: el arranque, donde J y J2 tienen la MISMA pistola
ARMA_A, ARMA_B = sc.BOTONES["arma_a"], sc.BOTONES["arma_b"]
SAL = H.parent / "volcados" / "arma"


def _viva(p, b):
    """La guarda de plantilla viva de (118): un puntero relativo a si misma. 0 / basura no la cumple."""
    try:
        return bool(b) and p.leer32(b + cs.VIVA_OFF) == (b + cs.VIVA_REL) & 0xFFFFFFFF
    except Exception:  # noqa: BLE001
        return None


def _arma(p, P):
    """El arma en la mano, su indice y CUANTAS armas tiene (la precondicion que (121) descubrio que faltaba medir:
    con una sola, el boton de cambio no hace nada y la corrida sale igual en todos los pasos)."""
    a = armas_j2.armas(p, P)
    return {"mano": a["mano"], "indice": a["indice_2C3"],
            "n_armas": sum(1 for x in a["armas"] if x != "0x0"), "armas": [x for x in a["armas"] if x != "0x0"]}


def _ranura(p, P, pers):
    """La ranura del aparejo de un jugador (J+0x330) y el SUB con el que dibuja (+0x50), nombrado."""
    r = p.leer32(P + 0x330)
    s = p.leer32(r + 0x50) if r else 0
    if s == cs.SUB3:
        quien = "sub3"
    elif pers and (s - pers - cs.SUBS_OFF) % cs.PASO_SUB == 0 and 0 <= (s - pers - cs.SUBS_OFF) < 8 * cs.PASO_SUB:
        quien = "sub_%d" % ((s - pers - cs.SUBS_OFF) // cs.PASO_SUB)
    else:
        quien = "otro"
    return {"ranura": hex(r), "sub": hex(s), "quien": quien, "plantilla": hex(p.leer32(s + 8)) if s else None}


def estado(p):
    pers = p.leer32(cs.PERS_GLOBAL)
    subs = []
    for i in range(2):                                   # sub0 y sub1: los del juego (el 3.ro es sub3)
        d = pers + cs.SUBS_OFF + i * cs.PASO_SUB if pers else 0
        b = p.leer32(d + 8) if d else 0
        subs.append({"sub": hex(d), "plantilla": hex(b), "viva": _viva(p, b)})
    b3 = p.leer32(cs.SUB3 + 8)
    subs.append({"sub": hex(cs.SUB3), "plantilla": hex(b3), "viva": _viva(p, b3)})
    instalados = [p.leer32(pc) == w for pc, w, _ in cs.ganchos()]
    moldes = p.leer32(cm.MOLDES)
    molde3 = p.leer32(cs.SUB3_MOLDE)
    return {"ganchos_sub3_en_ram": "%d de %d" % (sum(instalados), len(instalados)),
            "pers": hex(pers),
            "sub3": {"armada": p.leer32(cs.SUB3_ARMADA), "molde": hex(molde3), "moldes": hex(moldes),
                     "de_este_nivel": bool(molde3) and molde3 == moldes,
                     "escrib": p.leer32(cs.SUB3_ESCRIB), "saltos": p.leer32(cs.SUB3_SALTOS),
                     "cuadruplas": [[hex(p.leer32(cs.CUAD + 0x10 * i + 4 * j)) for j in range(4)]
                                    for i in range(cs.N_SUBS)]},
            "subs": subs,
            "ranura_J": _ranura(p, cj.J, pers), "ranura_J2": _ranura(p, cj.J2, pers),
            "arma_J": _arma(p, cj.J), "arma_J2": _arma(p, cj.J2),
            "r3": {"armada": p.leer32(cm.R3_ARMADA), "cargas": p.leer32(cm.R3_CARGAS),
                   "reapuntes": p.leer32(cm.R3_REAPUNTES), "desvios": p.leer32(cm.R3_DESVIOS),
                   "molde": hex(p.leer32(cm.R3_MOLDE))},
            "vida": [round(p.leer_f32(cj.J + 0x2F8), 1), round(p.leer_f32(cj.J2 + 0x2F8), 1)],
            "cuadros_J2": p.leer32(cm.CONTADOR)}


def _mitades(dir_, nombre):
    """Corta la foto por la mitad: izquierda = la vista de J, derecha = la de J2 (pantalla dividida vertical, (84)).
    El corte es a la mitad del ANCHO DE LA IMAGEN -- con la ventana maximizada coincide con el corte del juego."""
    f = dir_ / nombre
    if not f.exists():
        return None
    from PIL import Image
    im = Image.open(f)
    w, h = im.size
    im.crop((0, 0, w // 2, h)).save(f.with_name(f.stem + "-izq.png"))
    im.crop((w // 2, 0, w, h)).save(f.with_name(f.stem + "-der.png"))
    return [w, h]


def _apretar(poner, p, i, s=0.25):
    poner(p, i, True)
    time.sleep(s)
    poner(p, i, False)


def _armas_del_piso(p):
    """Los recogibles de tipo ARMA todavia disponibles (bandera 0x4, como la 29 de (111)), de mas cerca a mas lejos."""
    base, rs = s1.recogibles(p)
    j = s1.pos(p, cj.J)
    libres = [r for r in rs if r["tipo"] == 2 and r["ban"] == 0x4]
    libres.sort(key=lambda r: sum((a - b) ** 2 for a, b in zip(r["pos"], j)))
    return base, libres


def _juntar(p, i, quien):
    """La receta de S1 (111): J se teletransporta sobre el recogible i y `quien` ('J' o 'J2') mantiene «agarrar».
    El candidato es el arma que esta bajo J; el consumidor es el que aprieta el boton."""
    base, rs = s1.recogibles(p)
    r = rs[i]
    antes = _arma(p, cj.J2 if quien == "J2" else cj.J)
    s1.dep("pausar")
    teletransporte.teletransportar(p, cj.J, list(r["pos"]))
    s1.dep("continuar")
    time.sleep(0.8)
    cand = hex(p.leer32(base + 0x5848))
    if quien == "J2":
        s1.boton_j2(p, True)
        time.sleep(1.2)
        s1.boton_j2(p, False)
    else:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:
            sc.falso_poner(p)
        _apretar(sc.poner_boton, p, s1.AGARRAR, 1.2)
    time.sleep(0.8)
    despues = _arma(p, cj.J2 if quien == "J2" else cj.J)
    return {"recogible": i, "quien": quien, "candidato": cand, "ban_antes": hex(r["ban"]),
            "ban_despues": hex(s1.recogibles(p)[1][i]["ban"]), "antes": antes, "despues": despues,
            "sumo_arma": despues["n_armas"] > antes["n_armas"]}


def preparar(p):
    """Construye la precondicion de P3: J2 con DOS armas (y, si se puede, J tambien). Sin esto el experimento no
    discrimina nada -- medido en (121). Devuelve `listo` False si J2 no llego a dos, y el banco sale en ROJO."""
    _, libres = _armas_del_piso(p)
    res = {"armas_en_el_piso": [r["i"] for r in libres[:6]], "intentos": []}
    for r in libres[:3]:
        res["intentos"].append(_juntar(p, r["i"], "J2"))
        if res["intentos"][-1]["sumo_arma"]:
            break
    res["J2_listo"] = _arma(p, cj.J2)["n_armas"] >= 2
    if res["J2_listo"]:                                  # y un intento para J, que permite la mitad J del ciclo
        _, libres = _armas_del_piso(p)
        for r in libres[:2]:
            res["intentos"].append(_juntar(p, r["i"], "J"))
            if res["intentos"][-1]["sumo_arma"]:
                break
    res["J_listo"] = _arma(p, cj.J)["n_armas"] >= 2
    res["listo"] = res["J2_listo"]
    return res


def igualar_indices(p):
    """P3 arranca con los dos en la MISMA arma. Se compara el INDICE (+0x2C3), no el puntero: cada jugador tiene su
    propia INSTANCIA del arma de arranque, asi que dos punteros distintos pueden ser la misma arma (medido (121))."""
    pasos = []
    for _ in range(4):
        a, b = _arma(p, cj.J), _arma(p, cj.J2)
        pasos.append({"J": a, "J2": b})
        if a["indice"] == b["indice"]:
            return {"iguales": True, "pasos": pasos}
        _apretar(m2.boton, p, ARMA_A)
        time.sleep(1.2)
    return {"iguales": False, "pasos": pasos}


def medir(etiqueta):
    """Una carga: la secuencia del peligro paso a paso, con estado y foto en cada uno."""
    dir_ = SAL / time.strftime("pieza-%s-%%Y%%m%%d-%%H%%M%%S" % etiqueta)
    dir_.mkdir(parents=True, exist_ok=True)
    hd.FOTOS.clear()
    res = {"etiqueta": etiqueta, "dir": str(dir_)}
    with Pine() as p:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:    # el mando falso de J (el selector ya suele dejarlo puesto)
            sc.falso_poner(p)
        m2.poner(p)
        res["preparar"] = preparar(p)
        res["igualar"] = igualar_indices(p)
        res["base"] = estado(p)
    hd.captura(dir_, "base.png")
    if not res["preparar"]["listo"]:
        res["ROJO"] = ("J2 no llego a dos armas: el cambio de arma no puede ocurrir y la corrida NO discrimina. "
                       "No se concluye nada de las fotos ni de los testigos.")
    # el ciclo: J2 cambia y vuelve; y si J tambien consiguio una 2.a arma, J cambia y vuelve (el peligro es simetrico)
    pasos = [("j2_cambio", m2.boton, ARMA_B), ("j2_vuelve", m2.boton, ARMA_A)]
    if res["preparar"]["J_listo"]:
        pasos += [("j_cambio", sc.poner_boton, ARMA_B), ("j_vuelve", sc.poner_boton, ARMA_A)]
    for nombre, poner, boton in pasos:
        with Pine() as p:
            _apretar(poner, p, boton)
        time.sleep(1.5)
        with Pine() as p:
            res[nombre] = estado(p)
        hd.captura(dir_, nombre.replace("_", "-") + ".png")
    with Pine() as p:
        m2.quitar(p)
    res["fotos"] = dict(hd.FOTOS)
    res["mitades"] = {n: _mitades(dir_, n) for n in res["fotos"]}
    if hd.fotos_invalidas(hd.FOTOS):
        res["FOTOS_INVALIDAS"] = "falta una foto o hay dos identicas (cuadro viejo): no se concluye nada de la imagen"
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    return res


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("modo", choices=["pieza", "control"])
    a = ap.parse_args()
    modo = a.modo
    if cc.pcsx2_de_fran_abierto():
        print(json.dumps({"error": "el PCSX2 de Fran esta abierto: comparte PINE con el fork"}))
        return 1
    SAL.mkdir(parents=True, exist_ok=True)
    res = {"modo": modo, "nivel": cc.NOMBRES[NIVEL]}
    r = subprocess.run([sys.executable, str(H / "coop_mod.py"), "instalar",
                        "--con-sub3" if modo == "pieza" else "--sin-sub3"], capture_output=True, text=True)
    res["instalar"] = r.stdout.strip()[-400:]
    res["vivo"] = cc.lanzar()
    if not res["vivo"]:
        print(json.dumps(res))
        return 1
    for n in (1, 2) if modo == "pieza" else (1,):
        c = cc.probar_nivel(NIVEL)
        res["carga%d" % n] = {k: c.get(k) for k in ("armado_s", "juego_s", "cuelga_o_no_arma", "vivo_despues", "r3")}
        if c.get("cuelga_o_no_arma"):
            break
        res["medida%d" % n] = medir("%s-carga%d" % (modo, n))
        print(json.dumps({"carga": n, "medida": res["medida%d" % n]}, ensure_ascii=False), flush=True)
    sal = SAL / time.strftime("banco-%s-%%Y%%m%%d-%%H%%M%%S.json" % modo)
    sal.write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({"salida": str(sal)}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
