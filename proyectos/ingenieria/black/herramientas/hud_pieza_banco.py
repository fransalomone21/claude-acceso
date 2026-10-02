"""hud_pieza_banco.py -- (115) el banco de la pieza 1 de la C, de punta a punta, en el fork (sesiones/PREDICCIONES-115.md).

    python herramientas/hud_pieza_banco.py pieza      # instalar (con la pieza), lanzar, carga 1 + medir, carga 2 + medir
    python herramientas/hud_pieza_banco.py control    # instalar --sin-hud, lanzar, carga 1 + medir

Deja el fork abierto en el ultimo nivel (J1 en el mando falso: campana_coop.entregar_a_fran() antes de que juegue
Fran). El pnach queda como lo dejo el ultimo modo: el acceso de Fran (JUGAR-BLACK.ps1) lo reinstala sin la pieza.
Salida: volcados/hud/banco-<modo>-<fecha-hora>.json (y las carpetas de hud_pieza.py).
"""
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402


def medir(etiqueta):
    r = subprocess.run([sys.executable, str(H / "hud_pieza.py"), etiqueta], capture_output=True, text=True,
                       encoding="utf-8", errors="replace", timeout=120)
    try:
        return json.loads(r.stdout.strip().splitlines()[-1])
    except Exception:  # noqa: BLE001
        return {"error": (r.stdout + r.stderr)[-600:]}


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("pieza", "control"):
        print(__doc__)
        return 0
    modo = sys.argv[1]
    if cc.pcsx2_de_fran_abierto():
        print(json.dumps({"error": "el PCSX2 de Fran esta abierto: comparte PINE con el fork"}))
        return 1
    res = {"modo": modo}
    # (115) desde que la pieza quedo prendida por defecto, el control es `--sin-hud`
    r = subprocess.run([sys.executable, str(H / "coop_mod.py"), "instalar"] + (["--sin-hud"] if modo == "control" else []),
                       capture_output=True, text=True)
    res["instalar"] = r.stdout.strip()[-400:]
    res["vivo"] = cc.lanzar()
    if not res["vivo"]:
        print(json.dumps(res))
        return 1
    res["carga1"] = cc.probar_nivel(0)
    if not res["carga1"].get("cuelga_o_no_arma"):
        res["medida1"] = medir("%s-carga1" % modo)
    if modo == "pieza" and not res["carga1"].get("cuelga_o_no_arma"):
        res["carga2"] = cc.probar_nivel(0)
        if not res["carga2"].get("cuelga_o_no_arma"):
            res["medida2"] = medir("%s-carga2" % modo)
    sal = H.parent / "volcados" / "hud" / time.strftime("banco-%s-%%Y%%m%%d-%%H%%M%%S.json" % modo)
    sal.write_text(json.dumps(res, indent=1), encoding="utf-8")
    print(json.dumps({"salida": str(sal)}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
