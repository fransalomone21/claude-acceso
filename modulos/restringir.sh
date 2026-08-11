#!/usr/bin/env bash
# Pone una app en la maxima restriccion de segundo plano sin desinstalarla.
#
#   ./acceso.sh restringir com.ejemplo.app
#   ./acceso.sh restringir --liberar com.ejemplo.app
#
# Equivale a "Restringido" en Ajustes > Bateria, pero se puede aplicar tambien a
# apps del sistema que One UI no deja restringir desde la interfaz.
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

LIBERAR=0
if [ "${1:-}" = "--liberar" ]; then LIBERAR=1; shift; fi
PKG="${1:-}"

if [ -z "$PKG" ]; then
  alerta "Falta el nombre del paquete."
  info "Uso:  ./acceso.sh restringir <paquete>"
  info "      ./acceso.sh restringir --liberar <paquete>"
  info "Para ver candidatos, corré primero:  ./acceso.sh bateria"
  exit 1
fi

if ! paquete_existe "$PKG"; then
  alerta "El paquete '$PKG' no esta instalado para el usuario 0."
  exit 1
fi

if [ "$LIBERAR" -eq 1 ]; then
  titulo "LIBERANDO $PKG"
  sh_adb "cmd appops set $PKG RUN_ANY_IN_BACKGROUND allow" >/dev/null && ok "puede correr en segundo plano"
  sh_adb "am set-standby-bucket $PKG active"                >/dev/null && ok "bucket = active"
  sh_adb "dumpsys deviceidle whitelist +$PKG"               >/dev/null && ok "exenta de Doze"
  exit 0
fi

titulo "RESTRINGIENDO $PKG"
aviso "La app va a dejar de recibir notificaciones en tiempo real."
aviso "No hagas esto con WhatsApp, tu app de mensajeria, el despertador ni tu banco."
if ! confirmar "Restringir '$PKG' al maximo en segundo plano?"; then
  aviso "Cancelado."; exit 0
fi

sh_adb "cmd appops set $PKG RUN_ANY_IN_BACKGROUND ignore" >/dev/null && ok "sin ejecucion en segundo plano"
sh_adb "am set-standby-bucket $PKG restricted"            >/dev/null && ok "bucket = restricted"
sh_adb "dumpsys deviceidle whitelist -$PKG"               >/dev/null && ok "sujeta a Doze"

sub "Estado final"
printf '  bucket: %s\n' "$(sh_adb "am get-standby-bucket $PKG")"
info "Para deshacerlo:  ./acceso.sh restringir --liberar $PKG"
