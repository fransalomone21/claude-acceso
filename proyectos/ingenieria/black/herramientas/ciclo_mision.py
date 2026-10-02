"""ciclo_mision.py -- (110) el ciclo de la mision con el coop: morir, «MISSION FAILED» y volver a jugar.

Pregunta macro: el desarme de (87) se engancha a la SALIDA del nivel por el selector; ¿el reinicio de mision
(o «continuar» desde el punto de control) pasa por ahi? Si no, J2 queda dado de alta en un mundo que se rearma y
lo esperable es un cuelgue o un J2 fantasma.

    python herramientas/ciclo_mision.py [--opcion restart|continue] [--espera 90]
Pasos (una conexion PINE; capturas aparte):
  1. foto del estado del mod (FASE, ESTADO, DESARMES, MOLDES, ATADAS, contador de J2);
  2. hace nacer un enemigo a ~3 m de J y le baja la vida a J a 1 en cada vuelta hasta que muere (J+0x38C = 2);
  3. espera el menu, captura, elige la opcion (abajo = indice 5, acepta = 8; medido en (78) para menus) y acepta;
  4. registra 1/s el estado del mod y si el EE corre (contador del gancho) durante --espera s, con capturas.
Salida: volcados/ciclo/<fecha-hora>/ (capturas + registro.json).
"""
import argparse
import json
import math
import struct
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import clon_jugador as cj  # noqa: E402
import coop_mod as cm  # noqa: E402
import sondas_spawn as ss  # noqa: E402
import sondas_coop as sc  # noqa: E402

J, J2 = cj.J, cj.J2


def f32(p, d):
    return struct.unpack("<f", struct.pack("<I", p.leer32(d)))[0]


def posa(p, b):
    return [round(f32(p, b + 0xA0 + 4 * k), 2) for k in range(3)]


def captura(dir_, nombre):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                    str(H / "capturar-pantalla.ps1"), "-Salida", str(dir_ / nombre)], capture_output=True)


def estado(p):
    e = cm.leer_estado(p)
    return {k: e[k] for k in ("fase", "estado", "desarmes", "moldes", "atadas", "cuadros_J2")} | {
        "vJ": round(f32(p, J + 0x2F8), 1), "estJ": p.leer32(J + 0x38C), "vJ2": round(f32(p, J2 + 0x2F8), 1),
        "J2_B4": e["J2_B4"], "gancho": p.leer32(0x0046F7F0) if False else None}


def boton(p, i):
    sc.poner_boton(p, i, True)
    time.sleep(0.15)
    sc.poner_boton(p, i, False)
    time.sleep(0.4)


def main():
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--opcion", choices=("restart", "continue"), default="restart")
    ap.add_argument("--espera", type=float, default=90.0)
    a = ap.parse_args()
    dir_ = H.parent / "volcados" / "ciclo" / time.strftime("%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    reg = {"opcion": a.opcion, "serie": []}
    with Pine() as p:
        reg["antes"] = estado(p)
        if p.leer32(sc.CTRL1 + 0xC) != sc.FALSO:
            sc.falso_poner(p)
        # 2. un enemigo a 3 m de J, en la direccion de J2 (piso que J2 camino) y J con vida 1
        jp, j2p = posa(p, J), posa(p, J2)
        dx, dz = j2p[0] - jp[0], j2p[2] - jp[2]
        n = math.hypot(dx, dz) or 1.0
        for l, k, sp in ss.spawners(p):
            s = ss.leer_spawner(p, sp)
            if s["activo"] == 0 and s["restantes"] != 0 and s["b2A"] and s["b2B"] and s["actor"] == "0x00000000":
                break
        else:
            raise SystemExit("ningun spawner candidato")
        punto = p.leer32(p.leer32(sp + 0x18) + 4)
        for q, v in enumerate([jp[0] + 3 * dx / n, jp[1], jp[2] + 3 * dz / n]):
            p.escribir_f32(punto + 0x10 + 4 * q, v)
        p.escribir8(sp + 0x28, 1)
        t0 = time.time()
        while time.time() - t0 < 40 and p.leer32(J + 0x38C) != 2:
            if f32(p, J + 0x2F8) > 1.0:
                p.escribir_f32(J + 0x2F8, 1.0)
            time.sleep(0.1)
        reg["muerte_s"] = round(time.time() - t0, 1) if p.leer32(J + 0x38C) == 2 else None
        reg["al_morir"] = estado(p)
        if reg["muerte_s"] is None:
            print(json.dumps(reg, ensure_ascii=False))
            raise SystemExit("J no murio en 40 s")
        time.sleep(7)
        captura(dir_, "menu.png")
        if a.opcion == "restart":
            boton(p, 5)      # abajo: de CONTINUE a RESTART (si ya estaba ahi, el menu no da la vuelta: medido en la foto)
        captura(dir_, "menu-elegido.png")
        boton(p, 8)
        t1 = time.time()
        while time.time() - t1 < a.espera:
            try:
                e = estado(p)
            except Exception as ex:  # noqa: BLE001
                e = {"error": str(ex)}
            e["t"] = round(time.time() - t1, 1)
            reg["serie"].append(e)
            if int(e["t"]) % 15 == 0:
                captura(dir_, "despues-%02d.png" % int(e["t"]))
            time.sleep(1.0)
    (dir_ / "registro.json").write_text(json.dumps(reg, ensure_ascii=False), encoding="utf-8")
    for e in reg["serie"][::5]:
        print(json.dumps(e, ensure_ascii=False))
    print(dir_)


if __name__ == "__main__":
    main()
