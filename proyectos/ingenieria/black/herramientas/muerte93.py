"""(93f) B5 -- la vida de J2 en 0, en vivo. Lanza el fork con el bloque del pnach (campana_coop.lanzar), carga
City Streets, espera el juego y: CONTROL = escribe en J2+0x2F8 la vida que ya tiene; PRUEBA = escribe 0.
En cada caso registra 8 s: vida de J y J2, FASE/ESTADO del mod, contador del por cuadro, +0x8A4 y +0xC4 de J2,
si la vista de J responde (vivo) y una captura. Prediccion (93f): escribir 0 no hace nada (la muerte se
decide en la funcion de dano, 0x00134654), o fin de mision, o cuelgue.
Salida: volcados/campana/muerte93.json"""
import json, subprocess, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from pine import Pine  # noqa: E402

VIDA = 0x2F8
res = {}
if not cc.lanzar():
    raise SystemExit("fork no vivo")
cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
cc.run("selector_depuracion.py", "elegir", "0", "0")
cc.run("selector_depuracion.py", "aceptar")
t0 = time.time()
while time.time() - t0 < 90:
    with Pine() as p:
        a = p.leer32(cm.CONTADOR)
    time.sleep(1.5)
    with Pine() as p:
        if p.leer32(cm.CONTADOR) - a > 5:
            break
time.sleep(5)


def mirar(tag, valor):
    serie = []
    with Pine() as p:
        jota = p.leer32(cj.JUEGO_PTR) + 0x30
        antes = p.leer_f32(cj.J2 + VIDA)
        p.escribir_f32(cj.J2 + VIDA, antes if valor is None else valor)
        for i in range(16):
            serie.append({"t": i / 2, "vida_J2": round(p.leer_f32(cj.J2 + VIDA), 2),
                          "vida_J": round(p.leer_f32(jota + VIDA), 2), "fase": p.leer32(cm.FASE),
                          "estado": p.leer32(cm.ESTADO), "cuadros_J2": p.leer32(cm.CONTADOR),
                          "J2_8A4": hex(p.leer32(cj.J2 + 0x8A4)), "J2_C4": p.leer32(cj.J2 + 0xC4)})
            time.sleep(0.5)
    cc.cap("muerte-%s.png" % tag)
    r = cc.run("selector_depuracion.py", "vivo")
    return {"vida_antes": antes, "serie": serie, "vivo": r is not None and '"vivo": true' in r.stdout}


res["control"] = mirar("control", None)
print("control", json.dumps({k: v for k, v in res["control"].items() if k != "serie"}), res["control"]["serie"][-1])
res["prueba"] = mirar("prueba", 0.0)
print("prueba", json.dumps({k: v for k, v in res["prueba"].items() if k != "serie"}), res["prueba"]["serie"][-1])
(cc.SAL / "muerte93.json").write_text(json.dumps(res, indent=1))
cc.matar_fork()
