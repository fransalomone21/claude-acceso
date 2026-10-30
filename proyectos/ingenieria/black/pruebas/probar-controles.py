#!/usr/bin/env python3
"""probar-controles.py -- (131) el saboteador del chequeo de entorno de controles.py.

    python pruebas/probar-controles.py

Rojo buscado: un modulo requerido que no existe tiene que dar ENTORNO (codigo 2) SIN correr ningun control.
Control positivo: con un modulo que si existe ("json"), el chequeo pasa y corre el control falso. Cada caso dice
que llego (la salida), no solo su veredicto. No usa argparse a proposito: no toma argumentos.
"""
import contextlib
import importlib.util
import io
import sys
from pathlib import Path

ruta = Path(__file__).resolve().parent / "controles.py"
spec = importlib.util.spec_from_file_location("controles", ruta)
controles = importlib.util.module_from_spec(spec)
spec.loader.exec_module(controles)

MARCA = "CTRL" + "-FALSO-EJECUTADO"  # no puede aparecer en el aviso de ENTORNO ("no se corrio...")
CONTROL_FALSO = [("control falso", ["-c", "print('CTRL' + '-FALSO-EJECUTADO')"])]
INEXISTENTE = "modulo" + "_que_no_existe_131"  # armado por partes: nunca aparece literal en el canal


def correr(requeridos):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        rc = controles.main(CONTROL_FALSO, requeridos=requeridos, instalar=False)
    return rc, buf.getvalue()


malos = 0
rc, salida = correr([INEXISTENTE])
ok = rc == 2 and "ENTORNO" in salida and INEXISTENTE in salida and MARCA not in salida
malos += not ok
print("%-4s sabotaje: falta un modulo -> rc=%d | %s" % ("ok" if ok else "MAL", rc, salida.strip()[:110]))

rc, salida = correr(["json"])
ok = rc == 0 and MARCA in salida and "ENTORNO" not in salida
malos += not ok
print("%-4s control positivo: modulo presente -> rc=%d | %s" % ("ok" if ok else "MAL", rc, salida.strip()[-60:]))

print("probar-controles: %s" % ("TODO BIEN" if not malos else "%d MAL" % malos))
sys.exit(1 if malos else 0)
