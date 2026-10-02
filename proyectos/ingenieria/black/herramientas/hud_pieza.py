"""hud_pieza.py -- (115) COOP-C pieza 1: medir el HUD doble DEL STUB (coop_hud.py) en una carga, sin escribir nada
del HUD (solo los mandos falsos para disparar). Prediccion y criterio: sesiones/PREDICCIONES-115.md.

Con el fork en un nivel y J2 armado (campana_coop.lanzar() + probar_nivel(n)):
  1. estado: los 13 ganchos del HUD en RAM (instalado o control), cuenta de paneles, rectangulos, escala +8 de los dos
     marcos raiz, tipos de los dos paneles; vida y cargador de J y de J2;
  2. foto `base`;
  3. J dispara 0,6 s (mando falso 1, boton 12) -> cargadores y foto `disparo-J`;
  4. J2 dispara 0,6 s (mando falso 2) -> cargadores y foto `disparo-J2`;
  5. devuelve el mando de J2 al real (el de J lo devuelve campana_coop.entregar_a_fran()).
El discriminador esta en las fotos: el numero de la DERECHA cambia solo en el paso 4 y el de la izquierda solo en el 3.
Cada foto guarda su md5; dos iguales o una que falta marcan FOTOS_INVALIDAS (no se concluye nada de la imagen).

    python herramientas/hud_pieza.py <etiqueta>      # p. ej. carga1, carga2, control
Salida: volcados/hud/pieza-<etiqueta>-<fecha-hora>/{base,disparo-J,disparo-J2}.png y resumen.json
"""
import json
import struct
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
import clon_jugador as cj  # noqa: E402
import coop_hud  # noqa: E402
import coop_mod as cm  # noqa: E402
import hud_doble as hd  # noqa: E402
import mando_j2 as m2  # noqa: E402
import sondas_coop as sc  # noqa: E402

DISPARA = 12   # (77) sondas_coop.BOTONES: 12 dispara


def cargador(p, P):
    arma = p.leer32(P + 0x2A4)
    sub = p.leer32(arma + 0xF4) if arma else 0
    return struct.unpack("<H", p.leer_bloque(sub + 0x18, 2))[0] if sub else None


def estado(p):
    hud = p.leer32(hd.HUD_PTR)
    raices = [p.leer32(hud + 0x54), p.leer32(hud + 0xA8 + 0x54)]
    instalados = [p.leer32(pc) == w for pc, w, _ in coop_hud.ganchos()]
    return {"ganchos_hud_en_ram": "%d de %d" % (sum(instalados), len(instalados)),
            **hd.estado(p, hud),
            "escala_raices": [round(hd.f32(p, r + 8), 4) if r else None for r in raices],
            "fase": p.leer32(cm.FASE), "estado_j2": p.leer32(cm.ESTADO), "cuadros_J2": p.leer32(cm.CONTADOR),
            "vida": [round(p.leer_f32(cj.J + 0x2F8), 1), round(p.leer_f32(cj.J2 + 0x2F8), 1)],
            "cargador": [cargador(p, cj.J), cargador(p, cj.J2)],
            "juego": hex(p.leer32(0x0040F4D0))}


def main():
    if any(x in ("-h", "--help") for x in sys.argv[1:]) or len(sys.argv) < 2:
        print(__doc__)
        return 0
    dir_ = hd.SAL / time.strftime("pieza-%s-%%Y%%m%%d-%%H%%M%%S" % sys.argv[1])
    dir_.mkdir(parents=True, exist_ok=True)
    res = {"etiqueta": sys.argv[1]}
    with Pine() as p:
        res["base"] = estado(p)
    hd.captura(dir_, "base.png")
    with Pine() as p:
        if p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL:
            sc.falso_poner(p)
        sc.poner_boton(p, DISPARA, True)
    time.sleep(0.6)
    with Pine() as p:
        sc.poner_boton(p, DISPARA, False)
    time.sleep(1.0)
    with Pine() as p:
        res["disparo_J"] = estado(p)
    hd.captura(dir_, "disparo-J.png")
    try:
        with Pine() as p:
            m2.poner(p)
            m2.boton(p, DISPARA, True)
        time.sleep(0.6)
        with Pine() as p:
            m2.boton(p, DISPARA, False)
        time.sleep(1.0)
        with Pine() as p:
            res["disparo_J2"] = estado(p)
            m2.quitar(p)
    except Exception as ex:  # noqa: BLE001
        res["disparo_J2"] = {"error": str(ex)}
    hd.captura(dir_, "disparo-J2.png")
    res["fotos"] = hd.FOTOS
    if hd.fotos_invalidas(hd.FOTOS):
        res["FOTOS_INVALIDAS"] = "falta una foto o hay dos identicas (cuadro viejo): no se concluye nada de la imagen"
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1), encoding="utf-8")
    print(json.dumps({"dir": str(dir_), **res}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
