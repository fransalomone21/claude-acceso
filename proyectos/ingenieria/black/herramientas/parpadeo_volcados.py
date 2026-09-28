"""(93r) Volcados de RAM para el frio del PARPADEO (la mitad de J2 alterna entre dos puntos de vista cuando J2
dispara, (93p)). Sin la ranura 3: el parpadeo esta igual con y sin ella.

City Streets por el pnach; 1 volcado con J2 quieto y 4 con J2 disparando, cada uno EN PAUSA y con su captura de
pantalla tomada en la misma pausa (la captura dice en que fase del parpadeo quedo cada volcado).
Salida: volcados/ee-parpadeo-quieto.bin, ee-parpadeo-fuego-{0..3}.bin (32 MB, direccion = offset) y
volcados/campana/parpadeo-{quieto,fuego-k}.png. Van a black-datos con windows/subir-datos-nube.ps1.
  python herramientas/parpadeo_volcados.py
"""
import json, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import ranura3 as r3  # noqa: E402
from aislar93 import boton2, DISPARAR, municion  # noqa: E402
from pine import Pine  # noqa: E402

VOL = H.parent / "volcados"


def volcar(nombre, J):
    r3.dep("pausar")
    time.sleep(0.3)
    cc.cap("parpadeo-%s.png" % nombre)
    with Pine() as p:
        datos = p.leer_bloque(0, 0x2000000)
        info = {"J2": municion(p, r3.J2), "J": municion(p, J)}
    (VOL / ("ee-parpadeo-%s.bin" % nombre)).write_bytes(datos)
    r3.dep("continuar")
    return info


def main():
    res = {}
    J = r3.arrancar()
    with Pine() as p:
        r3.rellenar(p, r3.J2)
    time.sleep(1)
    res["quieto"] = volcar("quieto", J)
    time.sleep(1)
    for k in range(4):
        with Pine() as p:
            r3.rellenar(p, r3.J2)
            boton2(p, DISPARAR, True)
        time.sleep(0.4 + 0.13 * k)
        res["fuego-%d" % k] = volcar("fuego-%d" % k, J)
        with Pine() as p:
            boton2(p, DISPARAR, False)
        time.sleep(0.5)
    r = cc.run("selector_depuracion.py", "vivo")
    res["vivo"] = r is not None and '"vivo": true' in r.stdout
    (cc.SAL / "parpadeo-volcados.json").write_text(json.dumps(res, indent=1))
    print(json.dumps(res))
    cc.matar_fork()


if __name__ == "__main__":
    main()
