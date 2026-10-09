#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""f7_soporte.py -- (124) la sonda de F7 (el arma de J2 se dibuja en la mitad de J) sobre el SOPORTE DEL MODELO de
primera persona. Predicciones: sesiones/PREDICCIONES-124.md; el mecanismo, en frio: docs/16 seccion (124).

    python herramientas/f7_soporte.py            # instala el pnach por defecto (sin la 2b), lanza el fork, City Streets

LA HIPOTESIS: J y J2 dibujan con el MISMO soporte (`P+0x328`, cuyo +0 es el modelo) y los MISMOS buffers de registros
de submallas (`P+0x354`, `P+0x358`): J2 es una copia del molde de J y hereda los punteros. El que cambia de arma
ultimo le pone al soporte el modelo de SU arma (`FUN_0013C868` -> `FUN_00138338`) y le copia los registros
(`FUN_00136B50`); despues cada uno lo dibuja con su pose y su mapa de huesos.

LA INTERVENCION (en pausa, solo datos): lo mismo que hace el juego al cambiar de arma, con el modelo de la PISTOLA
(leido en `base`) -> el de la SPAS (leido en `j2_cambio`) -> otra vez la pistola. ON -> OFF -> ON, cada paso con foto.

EL SEAM EN RAM (se lee siempre): los punteros del soporte de J y de J2, el modelo, `M+0x08` (`pers+0x8F8`) muestreado
cinco veces -- (124) predice que NO sigue al que cambio de arma --, y el contador de cuadros de J2, que tiene que subir
entre pasos (si no, el juego esta colgado: ROJO_MUERTO, leccion de (123)).

La precondicion la construye arma_pieza_banco.py (`preparar(..., intentar_j=False)`: J2 junta una 2.a arma).
Deja el fork abierto con el soporte en la PISTOLA (el ultimo paso). Salida: volcados/arma/f7-soporte-<fecha-hora>/.
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
import coop_sub3 as cs  # noqa: E402
import hud_doble as hd  # noqa: E402
import mando_j2 as m2  # noqa: E402
import s1_juntar as s1  # noqa: E402
import sondas_coop as sc  # noqa: E402
from pine import Pine  # noqa: E402

SOPORTE, BUF_A, BUF_B, RANURA = 0x328, 0x354, 0x358, 0x330
# FUN_00136B50: memcpy(*(P+0x354), *(mod+0x38), *(mod+0x3C)); memcpy(*(P+0x358), *(mod+0x40), *(mod+0x44))
COPIAS = ((BUF_A, 0x38, 0x3C), (BUF_B, 0x40, 0x44))
M_BLOQUE, M_MODO = 0x8F0 + 0x08, 0x8F0 + 0x20
LARGO_MAX = 0x1000                 # un registro de submallas mas largo que esto es un puntero mal leido: no se copia


def soporte(p):
    pers = p.leer32(cs.PERS_GLOBAL)
    d = {}
    for nom, P in (("J", cj.J), ("J2", cj.J2)):
        h = p.leer32(P + SOPORTE)
        d[nom] = {"soporte": hex(h), "modelo": hex(p.leer32(h)) if h else None,
                  "buf_354": hex(p.leer32(P + BUF_A)), "buf_358": hex(p.leer32(P + BUF_B)),
                  "ranura": hex(p.leer32(P + RANURA))}
    d["comparten"] = all(d["J"][k] == d["J2"][k] for k in ("soporte", "buf_354", "buf_358"))
    m8 = []
    for _ in range(5):
        m8.append(hex(p.leer32(pers + M_BLOQUE)))
        time.sleep(0.07)
    d["M+0x08"] = m8
    d["M+0x20"] = p.leer32(pers + M_MODO)
    rj = p.leer32(cj.J + RANURA)
    d["bloque_ranura_J"] = hex(p.leer32(rj + 0xAC)) if rj else None
    d["bloque_R3"] = hex(p.leer32(cm.R3 + 0xAC))
    d["indices"] = [p.leer8(cj.J + 0x2C3), p.leer8(cj.J2 + 0x2C3)]
    d["cuadros_J2"] = p.leer32(cm.CONTADOR)
    return d


def poner_modelo(p, modelo):
    """Lo que el juego hace al cambiar de arma, con `modelo`, sobre el soporte de J (que es el de J2 si R1 vale):
    el modelo en el soporte y los dos memcpy de FUN_00136B50. Verifica cada copia leyendola de vuelta."""
    h = p.leer32(cj.J + SOPORTE)
    antes = p.leer32(h)
    copias = []
    for dst_off, src_off, len_off in COPIAS:
        dst, src, n = p.leer32(cj.J + dst_off), p.leer32(modelo + src_off), p.leer32(modelo + len_off)
        if not (0 < n <= LARGO_MAX) or not src or not dst:
            return {"ROJO": "registro raro: dst %#x src %#x n %#x -- no se escribe nada" % (dst, src, n)}
        copias.append((dst, src, n))
    p.escribir32(h, modelo)
    res = {"soporte": hex(h), "modelo_antes": hex(antes), "modelo": hex(modelo), "copias": []}
    for dst, src, n in copias:
        datos = p.leer_bloque(src, n)
        p.escribir_bloque(dst, datos)
        res["copias"].append({"dst": hex(dst), "src": hex(src), "n": n, "ok": p.leer_bloque(dst, n) == datos})
    return res


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--espera", type=float, default=1.5, help="segundos corriendo despues de cada escritura")
    a = ap.parse_args()
    if cc.pcsx2_de_fran_abierto():
        print(json.dumps({"error": "el PCSX2 de Fran esta abierto: comparte PINE con el fork"}))
        return 1
    dir_ = ab.SAL / time.strftime("f7-soporte-%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    res = {"nivel": cc.NOMBRES[ab.NIVEL], "dir": str(dir_)}
    r = subprocess.run([sys.executable, str(H / "coop_mod.py"), "instalar", "--sin-sub3"],
                       capture_output=True, text=True)
    res["instalar"] = r.stdout.strip()[-300:]
    res["vivo"] = cc.lanzar()
    if not res["vivo"]:
        print(json.dumps(res))
        return 1
    c = cc.probar_nivel(ab.NIVEL)
    res["carga"] = {k: c.get(k) for k in ("armado_s", "juego_s", "cuelga_o_no_arma", "vivo_despues")}
    hd.FOTOS.clear()
    with Pine() as p:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:
            sc.falso_poner(p)
        m2.poner(p)
        res["preparar"] = ab.preparar(p, intentar_j=False)
    res["igualar"] = ab.igualar_indices()
    with Pine() as p:
        res["base"] = soporte(p)
    hd.captura(dir_, "base.png")
    if not res["preparar"]["listo"]:
        res["ROJO"] = "J2 no llego a dos armas: no hay cambio de arma y la corrida no discrimina"
    res["j2_cambio_pulso"] = ab.cambiar(m2.boton, cj.J2, ab.ARMA_A)
    with Pine() as p:
        res["j2_cambio"] = soporte(p)
    hd.captura(dir_, "j2-cambio.png")
    pistola = int(res["base"]["J"]["modelo"], 16)
    spas = int(res["j2_cambio"]["J"]["modelo"], 16)
    if pistola == spas:
        res["ROJO_R2"] = "el modelo del soporte no cambio con el cambio de arma de J2: no hay que conmutar"
    elif res["j2_cambio_pulso"]["ocurrio"]:
        for nombre, mod in (("b-pistola", pistola), ("c-spas", spas), ("d-pistola", pistola)):
            s1.dep("pausar")
            with Pine() as p:
                res[nombre + "_escrito"] = poner_modelo(p, mod)
            s1.dep("continuar")
            if "ROJO" in res[nombre + "_escrito"]:
                break
            time.sleep(a.espera)
            with Pine() as p:
                res[nombre] = soporte(p)
            hd.captura(dir_, nombre + ".png")
    with Pine() as p:
        m2.quitar(p)
    vistos = [(n, res[n]["cuadros_J2"]) for n in ("base", "j2_cambio", "b-pistola", "c-spas", "d-pistola")
              if n in res]
    res["vida_entre_pasos"] = vistos
    clavados = [b for (_, x), (b, y) in zip(vistos, vistos[1:]) if y == x]
    if clavados:
        res["ROJO_MUERTO"] = "el contador de cuadros de J2 no subio hasta %s: juego colgado" % clavados[0]
    res["fotos"] = dict(hd.FOTOS)
    res["mitades"] = {n: ab._mitades(dir_, n) for n in res["fotos"]}
    if hd.fotos_invalidas(hd.FOTOS):
        res["FOTOS_INVALIDAS"] = "falta una foto o hay dos identicas (cuadro viejo): no se concluye nada de la imagen"
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({k: res.get(k) for k in ("dir", "ROJO", "ROJO_R2", "ROJO_MUERTO", "FOTOS_INVALIDAS",
                                              "vida_entre_pasos")}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
