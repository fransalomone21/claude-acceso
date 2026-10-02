#!/usr/bin/env bash
# cascada.sh -- la entrada a un proyecto donde no hay PowerShell (la nube). T7 de arquitectura-se, §3 punto 4.
#
# Misma sintaxis que cascada.ps1, para que la puerta (.claude/hooks/cascada_puerta.py) registre la declaracion
# igual en los dos lados -- la registra el HOOK leyendo esta linea de comando, no este script:
#   bash .claude/cascada.sh <proyecto> -Necesidad a,b      declara y lista lo que la puerta exige leer, con rangos
#   bash .claude/cascada.sh <proyecto> -Excepcion "motivo"  la salida explicita de la puerta, registrada
#
# Solo envuelve 'cascada_puerta.py --exige': los niveles, el ESTADO junto al enrutador y el AL DIA de git los sigue
# dando cascada.ps1 en la PC (declarado: en la nube se lee lo que la puerta exige, que es lo que la puerta mide).
# Sin acentos en la salida, igual que cascada.ps1.
set -u
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
PY="$(command -v python || command -v python3)" || { echo "  [ROJO] no hay python ni python3: la puerta no puede correr"; exit 1; }

proy="${1:-}"
[ -n "$proy" ] && shift || { echo "  uso: bash .claude/cascada.sh <proyecto> -Necesidad a,b | -Excepcion \"motivo\""; exit 1; }
nec="" ; exc=""
while [ $# -gt 0 ]; do
  case "$1" in
    -Necesidad|--necesidad) nec="${2:-}"; shift 2 || shift ;;
    -Excepcion|--excepcion) exc="${2:-}"; shift 2 || shift ;;
    *) echo "  argumento desconocido: $1 (uso: <proyecto> -Necesidad a,b | -Excepcion \"motivo\")"; exit 1 ;;
  esac
done

if [ -n "$exc" ]; then
  echo "  EXCEPCION a la puerta para $proy: '$exc'. Pasa en esta sesion y queda registrada."
  exit 0
fi
if [ -n "$nec" ]; then
  exec "$PY" "$RAIZ/.claude/hooks/cascada_puerta.py" --exige "$proy" --necesidad "$nec"
fi
exec "$PY" "$RAIZ/.claude/hooks/cascada_puerta.py" --exige "$proy"
