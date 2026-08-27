#!/usr/bin/env bash
# Deshace todo lo que hizo el modulo debloat.
#
# 'cmd package install-existing' reinstala el APK que nunca se borro de la
# particion del sistema. Funciona sin root y sin reinicio de fabrica.
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

titulo "RESTAURAR PAQUETES ELIMINADOS"

if [ ! -s "$ARCHIVO_RESTAURAR" ]; then
  ok "No hay nada que restaurar: el registro esta vacio."
  info "Si eliminaste algo por otra via, pasá el paquete a mano:"
  info "  adb shell cmd package install-existing <nombre.del.paquete>"
  exit 0
fi

UNO="${1:-}"

if [ -n "$UNO" ]; then
  salida="$(sh_adb "cmd package install-existing $UNO")"
  if echo "$salida" | grep -qi 'installed'; then
    ok "restaurado  $UNO"
    grep -vx "$UNO" "$ARCHIVO_RESTAURAR" > "$ARCHIVO_RESTAURAR.tmp" && mv "$ARCHIVO_RESTAURAR.tmp" "$ARCHIVO_RESTAURAR"
  else
    alerta "no se pudo restaurar $UNO ($salida)"
    info "Si el APK ya no esta en el sistema, instalalo desde Play Store o Galaxy Store."
  fi
  exit 0
fi

mapfile -t LISTA < <(leer_lista "$ARCHIVO_RESTAURAR")
info "Hay ${#LISTA[@]} paquete(s) registrados como eliminados:"
printf '    %s\n' "${LISTA[@]}"

if ! confirmar "Voy a reinstalar los ${#LISTA[@]} paquetes de la lista."; then
  aviso "Cancelado."
  info "Para restaurar uno solo:  ./acceso.sh restaurar <nombre.del.paquete>"
  exit 0
fi

FALLOS=0
for pkg in "${LISTA[@]}"; do
  salida="$(sh_adb "cmd package install-existing $pkg")"
  if echo "$salida" | grep -qi 'installed'; then
    ok "restaurado  $pkg"
  else
    aviso "fallo       $pkg  ($salida)"
    FALLOS=$((FALLOS+1))
  fi
done

if [ "$FALLOS" -eq 0 ]; then
  : > "$ARCHIVO_RESTAURAR"
  titulo "TODO RESTAURADO"
  info "Reiniciá el telefono."
else
  titulo "RESTAURADO CON $FALLOS FALLO(S)"
  info "Los que fallaron suelen ser apps de terceros: reinstalalas desde Play Store."
fi
