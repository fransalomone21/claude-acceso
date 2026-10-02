"""seguir_carga.py -- (110) aprieta un boton (opcional) y registra 1/s el estado del mod coop durante N s, con
capturas cada 10 s. Sirve para todo lo que recarga el mundo: reiniciar mision, continuar desde el punto de
control, cambio de unidad. La pregunta es siempre la misma: ¿J2 se da de baja y se vuelve a armar, o queda
colgado / fantasma?

    python herramientas/seguir_carga.py <segundos> [--boton i] [--etiqueta x]
Salida: volcados/ciclo/<etiqueta>-<hora>/ (capturas + registro.json).
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import coop_mod as cm  # noqa: E402
import sondas_coop as sc  # noqa: E402


def captura(dir_, nombre):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                    str(H / "capturar-pantalla.ps1"), "-Salida", str(dir_ / nombre)], capture_output=True)


def main():
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("segundos", type=float)
    ap.add_argument("--boton", type=int)
    ap.add_argument("--etiqueta", default="carga")
    a = ap.parse_args()
    dir_ = H.parent / "volcados" / "ciclo" / ("%s-%s" % (a.etiqueta, time.strftime("%H%M%S")))
    dir_.mkdir(parents=True, exist_ok=True)
    serie, ult = [], None
    with Pine() as p:
        if a.boton is not None:
            sc.poner_boton(p, a.boton, True)
            time.sleep(0.15)
            sc.poner_boton(p, a.boton, False)
        t0 = time.time()
        while time.time() - t0 < a.segundos:
            t = round(time.time() - t0, 1)
            try:
                e = cm.leer_estado(p)
                e = {k: e[k] for k in ("fase", "estado", "desarmes", "moldes", "atadas", "cuadros_J2", "titeres",
                                        "J2_B4", "J2_pos", "J_pos")}
            except Exception as ex:  # noqa: BLE001
                e = {"error": str(ex)[:80]}
            e["t"] = t
            serie.append(e)
            clave = {k: v for k, v in e.items() if k in ("fase", "estado", "desarmes", "moldes", "atadas", "error")}
            if clave != ult:
                print(json.dumps(e, ensure_ascii=False), flush=True)
                ult = clave
            if int(t) % 10 == 0:
                captura(dir_, "t%03d.png" % int(t))
            time.sleep(1.0)
        print("final", json.dumps(serie[-1], ensure_ascii=False))
    (dir_ / "registro.json").write_text(json.dumps(serie, ensure_ascii=False), encoding="utf-8")
    print(dir_)


if __name__ == "__main__":
    main()
