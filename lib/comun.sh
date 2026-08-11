#!/usr/bin/env bash
# Funciones compartidas por todos los modulos.
# Se espera que este archivo sea "sourceado", no ejecutado.

set -uo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR_INFORMES="$RAIZ/informes"
DIR_DATOS="$RAIZ/datos"
ARCHIVO_RESTAURAR="$DIR_INFORMES/paquetes-eliminados.txt"

mkdir -p "$DIR_INFORMES"

if [ -t 1 ] && [ -z "${SIN_COLOR:-}" ]; then
  C_ROJO=$'\033[31m'; C_VERDE=$'\033[32m'; C_AMAR=$'\033[33m'
  C_AZUL=$'\033[36m'; C_NEG=$'\033[1m';   C_FIN=$'\033[0m'
else
  C_ROJO=''; C_VERDE=''; C_AMAR=''; C_AZUL=''; C_NEG=''; C_FIN=''
fi

titulo()  { printf '\n%s=== %s ===%s\n' "$C_NEG$C_AZUL" "$*" "$C_FIN"; }
sub()     { printf '\n%s-- %s --%s\n' "$C_NEG" "$*" "$C_FIN"; }
ok()      { printf '%s  OK%s  %s\n' "$C_VERDE" "$C_FIN" "$*"; }
aviso()   { printf '%s  !!%s  %s\n' "$C_AMAR" "$C_FIN" "$*"; }
alerta()  { printf '%s  XX%s  %s\n' "$C_ROJO" "$C_FIN" "$*"; }
info()    { printf '      %s\n' "$*"; }

# --- ADB ----------------------------------------------------------------

adb_bin() {
  if [ -n "${ADB:-}" ]; then echo "$ADB"; return; fi
  if command -v adb >/dev/null 2>&1; then echo adb; return; fi
  echo ""
}

ADB_CMD="$(adb_bin)"

# El </dev/null es obligatorio: 'adb shell' lee stdin, y sin esto se come la
# entrada de cualquier bucle 'while read' que llame a adb en su interior.
sh_adb() { "$ADB_CMD" shell "$@" </dev/null 2>/dev/null | tr -d '\r'; }

exigir_adb() {
  if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
    alerta "Necesitas Bash 4 o superior (tenes ${BASH_VERSION:-desconocida})."
    info "En macOS:  brew install bash  y despues corré los scripts con 'bash ./acceso.sh ...'"
    exit 1
  fi

  if [ -z "$ADB_CMD" ]; then
    alerta "No encuentro 'adb' en el PATH."
    info "Instalalo con los SDK Platform Tools de Google:"
    info "  https://developer.android.com/tools/releases/platform-tools"
    info "O exporta la ruta:  export ADB=/ruta/a/adb"
    exit 1
  fi

  if [ "$("$ADB_CMD" devices | grep -c 'device$')" -gt 1 ]; then
    alerta "Hay mas de un dispositivo conectado. Elegí uno con:  export ANDROID_SERIAL=<serial>"
    "$ADB_CMD" devices
    exit 1
  fi

  local estado
  estado="$("$ADB_CMD" get-state 2>&1 | tr -d '\r')"

  case "$estado" in
    device) : ;;
    unauthorized)
      alerta "El telefono esta conectado pero NO autorizado."
      info "Mira la pantalla del celular y aceptá 'Permitir depuracion por USB'."
      info "Marcá 'Permitir siempre desde esta computadora'."
      exit 1
      ;;
    *)
      alerta "No hay ningun dispositivo conectado (estado: ${estado:-desconocido})."
      info "1. Ajustes > Informacion del telefono > Informacion de software"
      info "   > tocá 'Numero de compilacion' 7 veces."
      info "2. Ajustes > Opciones de desarrollador > Depuracion por USB: ON"
      info "3. Conectá el cable y elegí 'Transferencia de archivos' en el celular."
      exit 1
      ;;
  esac

}

prop() { sh_adb getprop "$1"; }

# Devuelve 0 si el paquete esta instalado para el usuario 0.
paquete_existe() {
  sh_adb pm list packages --user 0 2>/dev/null | grep -qx "package:$1"
}

# Lee una lista de paquetes: ignora comentarios (#) y lineas vacias.
leer_lista() {
  local archivo="$1"
  [ -f "$archivo" ] || return 0
  sed -e 's/#.*//' -e 's/[[:space:]]//g' "$archivo" | grep -v '^$'
}

# Confirmacion explicita para acciones que modifican el telefono.
confirmar() {
  local mensaje="$1"
  if [ -n "${SIN_PREGUNTAR:-}" ]; then return 0; fi
  printf '\n%s%s%s\n' "$C_AMAR$C_NEG" "$mensaje" "$C_FIN"
  printf 'Escribí exactamente CONFIRMO para continuar: '
  local r; read -r r
  [ "$r" = "CONFIRMO" ]
}

# Guarda salida en informes/ y tambien la muestra.
capturar() {
  local nombre="$1"; shift
  local destino="$DIR_INFORMES/$nombre"
  "$@" | tee "$destino"
  info "Guardado en informes/$nombre"
}

sello() { date +%Y%m%d-%H%M%S; }
