#!/usr/bin/env bash
# cascada.sh -- la entrada a un proyecto donde no hay PowerShell (la nube). T7 de arquitectura-se, §3 punto 4.
#
# Misma sintaxis que cascada.ps1, para que la puerta (.claude/hooks/cascada_puerta.py) registre la declaracion
# igual en los dos lados -- la registra el HOOK leyendo esta linea de comando, no este script:
#   bash .claude/cascada.sh <proyecto> -Necesidad a,b      declara y lista lo que la puerta exige leer, con rangos
#   bash .claude/cascada.sh <proyecto> -Excepcion "motivo"  la salida explicita de la puerta, registrada
#   bash .claude/cascada.sh <proyecto> -Mencion "motivo"    el pedido NOMBRA el proyecto sin pedirlo (T14b)
#   bash .claude/cascada.sh -Ingenieria "que es"            T19: ingenieria de sistemas sin proyecto; imprime el tronco
#   bash .claude/cascada.sh -Suelta "que es"                T19: pregunta suelta y especifica, sin tronco
#   bash .claude/cascada.sh <proyecto> -Necesidad a,b -Tema t   T19, pieza C: el tema, si el proyecto tiene mapa
#
# Solo envuelve 'cascada_puerta.py --exige': los niveles, el ESTADO junto al enrutador y el AL DIA de git los sigue
# dando cascada.ps1 en la PC (declarado: en la nube se lee lo que la puerta exige, que es lo que la puerta mide).
# Sin acentos en la salida, igual que cascada.ps1.
set -u
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
PY="$(command -v python || command -v python3)" || { echo "  [ROJO] no hay python ni python3: la puerta no puede correr"; exit 1; }
USO='  uso: bash .claude/cascada.sh <proyecto> -Necesidad a,b | <proyecto> -Excepcion "motivo" | -Ingenieria "que es" | -Suelta "que es"'

proy="${1:-}"
case "$proy" in
  -*) proy="" ;;                     # T19: la clase del pedido va sin proyecto
  "") echo "$USO"; exit 1 ;;
  *) shift ;;
esac
nec="" ; exc="" ; men="" ; ing="" ; sue="" ; tem=""
while [ $# -gt 0 ]; do
  case "$1" in
    -Necesidad|--necesidad) nec="${2:-}"; shift 2 || shift ;;
    -Tema|--tema) tem="${2:-}"; shift 2 || shift ;;
    -Excepcion|--excepcion) exc="${2:-}"; shift 2 || shift ;;
    -Mencion|--mencion) men="${2:-}"; shift 2 || shift ;;
    -Ingenieria|--ingenieria) ing="${2:-}"; shift 2 || shift ;;
    -Suelta|--suelta) sue="${2:-}"; shift 2 || shift ;;
    *) echo "  argumento desconocido: $1"; echo "$USO"; exit 1 ;;
  esac
done

if [ -n "$sue" ]; then
  echo "  CLASE DEL PEDIDO: suelta -- '$sue'. Sin proyecto y sin tronco (T19)."
  exit 0
fi
if [ -n "$ing" ]; then
  echo "  CLASE DEL PEDIDO: ingenieria de sistemas -- '$ing'. Sin proyecto, CON el tronco (T19)."
  "$PY" "$RAIZ/.claude/hooks/cascada_puerta.py" --tronco
  # T19, pieza D (L2-USO-02): las propuestas del lazo de uso de la clase ingenieria (las decide Fran)
  [ -f "$RAIZ/uso-lecturas.py" ] && "$PY" "$RAIZ/uso-lecturas.py" proponer --clase ingenieria
  exit 0
fi
[ -n "$proy" ] || { echo "$USO"; exit 1; }
if [ -n "$men" ]; then
  echo "  MENCION de $proy registrada: '$men'. Libera lo que cae FUERA de sus carpetas; para trabajar EN el proyecto, -Necesidad."
  exit 0
fi
if [ -n "$exc" ]; then
  echo "  EXCEPCION a la puerta para $proy: '$exc'. Pasa en esta sesion y queda registrada."
  exit 0
fi
set -- --exige "$proy"
[ -n "$nec" ] && set -- "$@" --necesidad "$nec"
[ -n "$tem" ] && set -- "$@" --tema "$tem"
"$PY" "$RAIZ/.claude/hooks/cascada_puerta.py" "$@"
rc=$?
# T19, pieza D (L2-USO-02): las propuestas del lazo de uso de la clase del proyecto; el codigo sigue siendo el de la puerta
[ -f "$RAIZ/uso-lecturas.py" ] && "$PY" "$RAIZ/uso-lecturas.py" proponer --proyecto "$proy"
exit $rc
