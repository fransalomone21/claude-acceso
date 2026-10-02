"""hud_doble.py -- (112) prender a mano el HUD de DOS jugadores que el juego ya trae construido (B9, sonda del concepto).

En frio (bitacora (112), docs/16 «HUD separado»): el arranque arma dos paneles en *(0x0040F518) (0xA8 cada uno, con
sus 15 elementos y su lista 2D); la carga prende `cuenta` = 1. La sonda, con el nivel ya cargado:
  1. EN PAUSA: rectangulo del panel 0 (+0x78..+0x84) en la mitad izquierda, el del panel 1 (+0x120..+0x12C) en la
     derecha, y la cuenta de paneles (hud+0x23C, byte) en 2;
  2. llama FUN_001F2340(hud) (activa los paneles con su rectangulo) y FUN_001F1B98(panel, tipo) para los dos, con el
     tipo que tenia el panel 0 (llamar_una_vez.py: un sitio por cuadro que el coop no usa);
  3. foto; despues deshace (cuenta 1, rectangulo entero, activar otra vez, tipo) y otra foto.
El control son las fotos antes y despues. Todavia SIN H4: los dos paneles leen a J.

    python herramientas/hud_doble.py              # antes, doble, despues
    python herramientas/hud_doble.py --sin-deshacer
    python herramientas/hud_doble.py --pasos0     # ademas: las 11 constantes `li rX, 2240` en 0 (H4a), foto, y vuelta
    python herramientas/hud_doble.py --escala 0.75  # (113) V2: escala del marco raiz sola, y con el rectangulo / s
                                                    #   (la 2.a parte reactiva con cuenta 2: congela el mundo)
    python herramientas/hud_doble.py --escala-una 0.75  # (113) V2b: rectangulos / s antes de la UNICA activacion
Salida: volcados/hud/doble-<fecha-hora>/{antes,doble,despues}.png y resumen.json
"""
import hashlib
import json
import struct
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from llamar_una_vez import EnPausa  # noqa: E402

HUD_PTR = 0x0040F518
ACTIVAR, TIPO = 0x001F2340, 0x001F1B98
ENTERO = (30.0, 22.0, 610.0, 458.0)          # el que pone FUN_001F2790 con cuenta 1 (0x001F2790, leido)
IZQ, DER = (30.0, 22.0, 290.0, 458.0), (350.0, 22.0, 610.0, 458.0)
SAL = H.parent / "volcados" / "hud"
# (112) las 11 constantes `li rX, 2240` del indice del jugador en el HUD (docs/14, coop-plan-b «HUD H4 paso 0»)
PASOS = (0x001F7C4C, 0x001F936C, 0x001FB45C, 0x001FB620, 0x001FBACC, 0x001FBDB4, 0x001FBFD4,
         0x001FD2BC, 0x001FD444, 0x001FD534, 0x001FD64C)


FOTOS = {}


def captura(dir_, nombre):
    # (112) primero capturar-pantalla.ps1 (toma el foco: cuadro fresco); si se niega porque hay otra ventana adelante,
    # capturar-ventana.ps1 (PrintWindow, sin foco) -- que con la ventana TAPADA devuelve un cuadro VIEJO (medido: tres
    # capturas a 1,5 s con el md5 identico). Por eso cada foto guarda su md5 y main() marca las repetidas.
    f = dir_ / nombre
    for ps in ("capturar-pantalla.ps1", "capturar-ventana.ps1"):
        subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                        str(H / ps), "-Salida", str(f)], capture_output=True)
        if f.exists():
            FOTOS[nombre] = {"con": ps, "md5": hashlib.md5(f.read_bytes()).hexdigest()[:12]}
            return
    FOTOS[nombre] = None


def fotos_invalidas(fotos):
    md5s = [v["md5"] for v in fotos.values() if v]
    return len(md5s) != len(fotos) or len(set(md5s)) != len(md5s)


def llamar(f, a0, a1=0):
    r = subprocess.run([sys.executable, str(H / "llamar_una_vez.py"), "%x" % f, "%x" % a0, "%x" % a1],
                       capture_output=True, text=True)
    try:
        return json.loads(r.stdout.strip().splitlines()[-1])
    except Exception:
        return {"error": (r.stdout + r.stderr)[-400:]}


def f32(p, a):
    return struct.unpack("<f", struct.pack("<I", p.leer32(a)))[0]


def rect(p, a, r):
    for i, v in enumerate(r):
        p.escribir32(a + 4 * i, struct.unpack("<I", struct.pack("<f", v))[0])


def cuenta(p, hud, n):
    w = p.leer32(hud + 0x23C)
    p.escribir32(hud + 0x23C, (w & 0xFFFFFF00) | n)


def estado(p, hud):
    return {"cuenta": p.leer32(hud + 0x23C) & 0xFF,
            "tipo0": p.leer32(hud + 0x8C), "tipo1": p.leer32(hud + 0xA8 + 0x8C),
            "rect0": [round(f32(p, hud + 0x78 + 4 * i), 1) for i in range(4)],
            "rect1": [round(f32(p, hud + 0x120 + 4 * i), 1) for i in range(4)],
            "lista0": p.leer32(hud + 0xA0), "lista1": p.leer32(hud + 0xA8 + 0xA0)}


def main():
    if any(x in ("-h", "--help") for x in sys.argv[1:]):
        print(__doc__)
        return 0
    deshacer = "--sin-deshacer" not in sys.argv
    dir_ = SAL / time.strftime("doble-%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    res = {}
    with Pine() as p:
        hud = p.leer32(HUD_PTR)
        res["hud"] = hex(hud)
        res["antes"] = estado(p, hud)
        tipo = res["antes"]["tipo0"]
        captura(dir_, "antes.png")
        # (113) V2b: con --escala-una S los rectangulos van ya divididos por S (en x) y la escala se escribe despues de
        # la UNICA activacion: la segunda activacion con cuenta 2 en la misma carga congela el mundo (2 de 2, probable)
        s1 = float(sys.argv[sys.argv.index("--escala-una") + 1]) if "--escala-una" in sys.argv else 1.0
        with EnPausa():
            rect(p, hud + 0x78, tuple(v / s1 if i % 2 == 0 else v for i, v in enumerate(IZQ)))
            rect(p, hud + 0x120, tuple(v / s1 if i % 2 == 0 else v for i, v in enumerate(DER)))
            cuenta(p, hud, 2)
    res["activar"] = llamar(ACTIVAR, hud)
    res["tipo_p0"] = llamar(TIPO, hud, tipo)
    res["tipo_p1"] = llamar(TIPO, hud + 0xA8, tipo)
    time.sleep(1.0)
    with Pine() as p:
        res["doble"] = estado(p, hud)
    captura(dir_, "doble.png")
    if "--pasos0" in sys.argv:
        with Pine() as p:
            orig = {s: p.leer32(s) for s in PASOS}
            res["pasos_originales"] = {hex(s): hex(w) for s, w in orig.items()}
            if any((w & 0xFFE0FFFF) != 0x240008C0 for w in orig.values()):
                res["pasos_error"] = "algun sitio no tiene li rX, 2240"
            else:
                with EnPausa():
                    for s, w in orig.items():
                        p.escribir32(s, w & 0xFFFF0000)        # li rX, 0
                time.sleep(1.0)
                captura(dir_, "pasos0.png")
                with EnPausa():
                    for s, w in orig.items():
                        p.escribir32(s, w)
                res["pasos_devueltos"] = all(p.leer32(s) == w for s, w in orig.items())
                time.sleep(1.0)
                captura(dir_, "pasos-vuelta.png")
    if s1 != 1.0:
        with Pine() as p:
            raices = [p.leer32(hud + 0x54), p.leer32(hud + 0xA8 + 0x54)]
            orig_esc = [p.leer32(r + 8) for r in raices]
            res["escala_una"] = {"s": s1, "raices": [hex(r) for r in raices], "originales": [hex(w) for w in orig_esc]}
            with EnPausa():
                for r in raices:
                    rect(p, r + 8, (s1,))
        time.sleep(1.0)
        captura(dir_, "escala.png")
        with Pine() as p:
            with EnPausa():
                for r, w in zip(raices, orig_esc):
                    p.escribir32(r + 8, w)
    if "--escala" in sys.argv:
        # (113) V2, sesiones/PREDICCIONES-113.md: la escala x del marco raiz (*(panel+0x54)+8) se lee por cuadro y se
        # compone en posiciones Y tamanos (FUN_00276290). V2a: solo la escala (control del modelo: todo se corre a x=0);
        # V2b: escala + rectangulos / s, activar y tipos (que reponen +8) y la escala otra vez.
        s = float(sys.argv[sys.argv.index("--escala") + 1])
        with Pine() as p:
            raices = [p.leer32(hud + 0x54), p.leer32(hud + 0xA8 + 0x54)]
            orig_esc = [p.leer32(r + 8) for r in raices]
            res["escala"] = {"s": s, "raices": [hex(r) for r in raices], "originales": [hex(w) for w in orig_esc]}
            with EnPausa():
                for r in raices:
                    rect(p, r + 8, (s,))
        time.sleep(1.0)
        captura(dir_, "escala.png")
        with Pine() as p:
            with EnPausa():
                rect(p, hud + 0x78, tuple(v / s if i % 2 == 0 else v for i, v in enumerate(IZQ)))
                rect(p, hud + 0x120, tuple(v / s if i % 2 == 0 else v for i, v in enumerate(DER)))
        res["escala"]["re_activar"] = llamar(ACTIVAR, hud)
        res["escala"]["re_tipo0"] = llamar(TIPO, hud, tipo)
        res["escala"]["re_tipo1"] = llamar(TIPO, hud + 0xA8, tipo)
        with Pine() as p:
            with EnPausa():
                for r in raices:
                    rect(p, r + 8, (s,))
            res["escala"]["estado"] = estado(p, hud)
        time.sleep(1.0)
        captura(dir_, "escala-rect.png")
        with Pine() as p:
            with EnPausa():
                for r, w in zip(raices, orig_esc):
                    p.escribir32(r + 8, w)
    if deshacer:
        with Pine() as p:
            with EnPausa():
                rect(p, hud + 0x78, ENTERO)
                cuenta(p, hud, 1)
        res["re_activar"] = llamar(ACTIVAR, hud)
        res["re_tipo"] = llamar(TIPO, hud, tipo)
        time.sleep(1.0)
        with Pine() as p:
            res["despues"] = estado(p, hud)
        captura(dir_, "despues.png")
    res["fotos"] = FOTOS
    if fotos_invalidas(FOTOS):
        res["FOTOS_INVALIDAS"] = "falta una foto o hay dos identicas (cuadro viejo): no se concluye nada de la imagen"
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1), encoding="utf-8")
    print(json.dumps({"dir": str(dir_), **res}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
