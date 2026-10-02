"""hud_paginas.py -- (111) que elemento del HUD vive en cada pagina del motor de menus (receta del HUD, B9 / R5).

En frio (bitacora (111)): FUN_001F1660 no dibuja el HUD; en cada cuadro PRENDE las paginas 1, 2 y 6 del front-end
(FUN_0020BA98(*(0x0040F544), k, 1)) en la rama por defecto, y el motor de menus las dibuja. El argumento «visible»
esta en el delay slot de cada llamada: 0x001F1984 (pagina 1), 0x001F1994 (2), 0x001F19A4 (6), `addiu a2, zero, 1`.
La sonda cambia UNO por vez a `move a2, zero` (EN PAUSA: escribir codigo con el EE corriendo tiro el fork, (110)),
saca una foto, y lo restaura. El control es la foto sin tocar nada, antes y despues.

    python herramientas/hud_paginas.py            # control, 1, 2, 6, control
Salida: volcados/hud/<fecha-hora>/{control-antes,pagina-1,pagina-2,pagina-6,control-despues}.png y resumen.json
"""
import json
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from mips import ensamblar  # noqa: E402

SITIOS = {1: 0x001F1984, 2: 0x001F1994, 6: 0x001F19A4}
SAL = H.parent / "volcados" / "hud"


def dep(a):
    subprocess.run([sys.executable, str(H / "depurador.py"), a], capture_output=True)


def captura(dir_, nombre):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                    str(H / "capturar-pantalla.ps1"), "-Salida", str(dir_ / nombre)], capture_output=True)


def main():
    if len(sys.argv) > 1:
        print(__doc__)
        return 0
    original = {k: ensamblar("addiu a2, zero, 1", s) for k, s in SITIOS.items()}
    apagar = {k: ensamblar("move a2, zero", s) for k, s in SITIOS.items()}
    dir_ = SAL / time.strftime("%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    res = {"original": {k: hex(v) for k, v in original.items()}, "apagar": {k: hex(v) for k, v in apagar.items()}}
    with Pine() as p:
        leidos = {k: p.leer32(s) for k, s in SITIOS.items()}
        res["leidos"] = {k: hex(v) for k, v in leidos.items()}
        if leidos != original:
            print(json.dumps({"error": "los sitios no tienen la instruccion esperada", **res}))
            return 1
        captura(dir_, "control-antes.png")
        for k, s in SITIOS.items():
            dep("pausar"); p.escribir32(s, apagar[k]); dep("continuar")
            time.sleep(1.0)
            captura(dir_, "pagina-%d.png" % k)
            dep("pausar"); p.escribir32(s, original[k]); dep("continuar")
            time.sleep(1.0)
        res["restaurados"] = all(p.leer32(s) == original[k] for k, s in SITIOS.items())
        captura(dir_, "control-despues.png")
    (dir_ / "resumen.json").write_text(json.dumps(res, indent=1), encoding="utf-8")
    print(json.dumps({"dir": str(dir_), **res}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
