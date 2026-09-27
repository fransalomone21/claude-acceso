#!/usr/bin/env bash
# Prepara una sesion de Claude Code en la NUBE para trabajar BLACK en frio.
#   bash proyectos/ingenieria/black/herramientas/nube/preparar.sh
# Precondicion: el repo privado fransalomone21/black-datos agregado a la sesion
# (la sesion lo hace con add_repo y lo clona en /home/user/black-datos).
set -euo pipefail
D=/home/user/black-datos
[ -d "$D/.git" ] || { echo "FALTA $D: agregar black-datos a la sesion (add_repo) y clonarlo"; exit 1; }
( cd "$D" && awk '{print $1"  "$3}' MANIFIESTO.txt | sha256sum -c --quiet ) && echo "black-datos: SHA-256 OK"
pip install -q capstone numpy 2>&1 | grep -v WARNING || true
cd "$(dirname "$0")/../.."
export BLACK_DATOS=$D
python3 herramientas/censo_subsistemas.py $D/ee-e4.bin > /dev/null && echo "control positivo censo_subsistemas: OK"
python3 herramientas/censo_jugadores.py $D/ee-e4.bin $D/ee-03.bin $D/ee-nivel-mod0.bin > /dev/null && echo "control positivo censo_jugadores: OK"
python3 herramientas/programa.py verificar
echo "LISTO. En cada comando: export BLACK_DATOS=$D"
