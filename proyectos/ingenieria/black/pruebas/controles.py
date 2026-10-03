#!/usr/bin/env python3
"""controles.py -- (111) los controles del proyecto en UN comando, una linea por control, y sale 1 si alguno falla.

    python pruebas/controles.py

Existe porque las salidas largas invitan a encadenar `control | tail && git commit`, y en un pipe el codigo de
salida es el de `tail` (siempre 0): en (111) se commiteo con `programa.py verificar` en rojo. Aca cada control corre
solo, se mide SU codigo de salida y se muestra su ultima linea. No usa argparse a proposito: no toma argumentos.
"""
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
CONTROLES = [
    ("programa verificar", ["herramientas/programa.py", "verificar"]),
    ("coop_diseno verificar", ["herramientas/coop_diseno.py", "verificar"]),
    ("probar-coop-diseno", ["pruebas/probar-coop-diseno.py"]),
    ("coop_ia verificar", ["herramientas/coop_ia.py", "verificar"]),
    # (122) el autotest trae su control positivo (hay entradas de arma vivas en los volcados) y un control
    # NEGATIVO de poblacion (200 direcciones de RAM: ninguna puede pasar por arma viva). Se engancha el dia
    # que nace, que es lo que (120) aprendio con fase_activa: un autotest que no corre nadie no mide.
    ("armas_estado autotest", ["herramientas/armas_estado.py", "--autotest"]),
    ("prueba_herramientas", ["pruebas/prueba_herramientas.py"]),
]


def correr(args):
    r = subprocess.run([sys.executable] + args, cwd=RAIZ, capture_output=True, text=True, errors="replace")
    lineas = [l for l in (r.stdout + r.stderr).splitlines() if l.strip()]
    return r.returncode, (lineas[-1] if lineas else "(sin salida)")


def main(controles=CONTROLES) -> int:
    malos = 0
    for nombre, args in controles:
        rc, ultima = correr(args)
        malos += rc != 0
        print("%-4s %-24s rc=%d  %s" % ("ok" if rc == 0 else "MAL", nombre, rc, ultima[:110]))
    print("controles: %s" % ("TODO BIEN" if not malos else "%d MAL" % malos))
    return 1 if malos else 0


if __name__ == "__main__":
    sys.exit(main())
