"""(93c) EL ATASCO del cartel de nivel con el mod: Wilderness (indice 1) se queda en el cartel "TRENESK" con el
bloque puesto (sin el bloque arranca en 17,6 s). Lanza el fork con el bloque activo, carga el nivel desde el
slot 3 con el selector, espera 45 s y muestrea el PC, ra y la pila del EE en pausas cortas, mas el estado del mod.
Salida: volcados/campana/atasco93.json"""
import json, subprocess, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
from pine import Pine  # noqa: E402


def dep(*a):
    r = subprocess.run([sys.executable, str(H / "depurador.py"), *a], capture_output=True, text=True,
                       encoding="utf-8", errors="replace", timeout=60)
    return r.stdout.strip()


nivel = int(sys.argv[1]) if len(sys.argv) > 1 else 1
res = {"nivel": nivel, "muestras": []}
if not cc.lanzar():
    raise SystemExit("fork no vivo")
cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
cc.run("selector_depuracion.py", "elegir", str(nivel), "0")
cc.run("selector_depuracion.py", "aceptar")
time.sleep(45)
with Pine() as p:
    res["estado_mod"] = cm.leer_estado(p)
for i in range(12):
    dep("pausar")
    res["muestras"].append({"registros": dep("registros"), "pila": dep("pila") if i % 4 == 0 else None})
    dep("continuar")
    time.sleep(0.4)
cc.cap("atasco-n%d.png" % nivel)
(cc.SAL / "atasco93.json").write_text(json.dumps(res, indent=1, ensure_ascii=False))
print(json.dumps(res["estado_mod"]))
print("fin")
