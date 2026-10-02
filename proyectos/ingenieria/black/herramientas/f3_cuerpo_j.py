"""f3_cuerpo_j.py -- (111) sonda del concepto de F3 (J no tiene cuerpo en la mitad de J2), City Streets.

Diseno (docs/16, «Cuerpos: los dos con skin de aliado»): un cuerpo por jugador, como el titere que ya tiene J2 (el
aliado 1 copia la matriz de J2 en el stub, (88)). Para J, el aliado 0 (Tom) copiando la matriz de J.
Prediccion: J2 mirando a J ve un soldado parado donde esta J (la foto de la mitad derecha); control (--control):
mismo encuadre sin copiar, J sin cuerpo (como en (110)).
La copia la hace Python por PINE en un lazo (como titere.py de (85)), asi que puede temblar: la pregunta es SI se ve
un cuerpo en el lugar de J, no la calidad. La pasada 1 (la vista de J) no se filtra: J tiene el cuerpo encima.

    python herramientas/f3_cuerpo_j.py [--control] [--segundos 4]
Salida: volcados/f3/<fecha-hora>-<con|control>.png y una linea JSON.
"""
import argparse
import json
import math
import subprocess
import sys
import threading
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
import clon_jugador as cj  # noqa: E402
import inspeccion_coop as ic  # noqa: E402

G_ACTORES, PASO = 0x0040F514, 0x3C0
SAL = H.parent / "volcados" / "f3"


def captura(ruta):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                    str(H / "capturar-pantalla.ps1"), "-Salida", str(ruta)], capture_output=True)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--control", action="store_true")
    ap.add_argument("--segundos", type=float, default=4.0)
    ap.add_argument("--aliado", type=int, default=0)
    a = ap.parse_args()
    SAL.mkdir(parents=True, exist_ok=True)
    ruta = SAL / ("%s-%s.png" % (time.strftime("%Y%m%d-%H%M%S"), "control" if a.control else "con"))
    with Pine() as p:
        al = p.leer32(G_ACTORES) + 0x90 + a.aliado * PASO
        res = {"aliado": hex(al), "tipo": hex(p.leer32(al + 0x328)), "bando": p.leer32(al + 0x3A4),
               "titere_J2": hex(p.leer32(0x0046DEF0))}
        if al == p.leer32(0x0046DEF0):
            print(json.dumps({"error": "ese aliado es el titere de J2", **res}))
            return 1
        # (111) yaw (grados, mira+8) = atan2(dx, dz) del rumbo, medido con la caminata de J2 en City Streets;
        # girar_hacia (lazo sobre la matriz) dejo a J2 mirando a otro lado
        j, j2 = ic.pos(p, cj.J), ic.pos(p, cj.J2)
        yaw = math.degrees(math.atan2(j[0] - j2[0], j[2] - j2[2]))
        p.escribir_f32(ic.MIRA_YAW["J2"], yaw)
        res["yaw_J2"] = round(yaw, 1)
        time.sleep(0.5)
        t0, hilo, n = time.time(), None, 0
        while time.time() - t0 < a.segundos:
            if not a.control:
                p.escribir_bloque(al + 0x70, p.leer_bloque(cj.J + 0x70, 0x40))
                n += 1
            if hilo is None and time.time() - t0 > a.segundos / 2:
                hilo = threading.Thread(target=captura, args=(ruta,))
                hilo.start()
            time.sleep(0.005)
        hilo.join()
        res.update({"copias": n, "J": [round(x, 2) for x in ic.pos(p, cj.J)],
                    "aliado_pos": [round(x, 2) for x in ic.pos(p, al)],
                    "J2": [round(x, 2) for x in ic.pos(p, cj.J2)], "captura": str(ruta), "control": a.control})
    print(json.dumps(res))
    return 0


if __name__ == "__main__":
    sys.exit(main())
