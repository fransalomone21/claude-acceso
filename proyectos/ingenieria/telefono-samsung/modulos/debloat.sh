#!/usr/bin/env bash
# Elimina bloatware de forma REVERSIBLE.
#
# Usa 'pm uninstall -k --user 0': el paquete se quita para tu usuario pero el APK
# sigue en la particion del sistema. Se restaura entero con:  ./acceso.sh restaurar
# Un reinicio de fabrica tambien lo devuelve todo. No se pierde la garantia ni Knox.
#
#   ./acceso.sh debloat            -> muestra que haria, sin tocar nada
#   ./acceso.sh debloat aplicar    -> nivel 1 completo, previa confirmacion
#   ./acceso.sh debloat opcional   -> nivel 2, preguntando app por app
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

MODO="${1:-simular}"

mapfile -t PROHIBIDOS < <(leer_lista "$DIR_DATOS/NO-TOCAR.txt")

esta_prohibido() {
  local p="$1"
  for x in "${PROHIBIDOS[@]}"; do [ "$x" = "$p" ] && return 0; done
  return 1
}

quitar() {
  local pkg="$1"
  if esta_prohibido "$pkg"; then
    alerta "BLOQUEADO por la lista NO-TOCAR: $pkg"
    return 1
  fi
  if ! paquete_existe "$pkg"; then
    return 2
  fi
  local salida
  salida="$(sh_adb "pm uninstall -k --user 0 $pkg")"
  if echo "$salida" | grep -qi success; then
    echo "$pkg" >> "$ARCHIVO_RESTAURAR"
    ok "eliminado  $pkg"
    return 0
  else
    aviso "no se pudo  $pkg  ($salida)"
    return 1
  fi
}

# --- Nivel 1 --------------------------------------------------------------

titulo "NIVEL 1 - BLOATWARE SEGURO"
PRESENTES=()
while read -r pkg; do
  [ -z "$pkg" ] && continue
  esta_prohibido "$pkg" && continue
  paquete_existe "$pkg" && PRESENTES+=("$pkg")
done < <(leer_lista "$DIR_DATOS/nivel1-seguro.txt")

if [ "${#PRESENTES[@]}" -eq 0 ]; then
  ok "No queda nada del nivel 1 en tu equipo."
else
  info "Presentes en tu telefono (${#PRESENTES[@]}):"
  printf '    %s\n' "${PRESENTES[@]}"
fi

if [ "$MODO" = "simular" ]; then
  titulo "MODO SIMULACION"
  info "No se toco nada. Para eliminarlos:  ./acceso.sh debloat aplicar"
  info "Para revisar tambien el nivel 2:    ./acceso.sh debloat opcional"
  exit 0
fi

if [ "$MODO" = "aplicar" ] && [ "${#PRESENTES[@]}" -gt 0 ]; then
  if confirmar "Voy a eliminar ${#PRESENTES[@]} paquetes del nivel 1. Es reversible con './acceso.sh restaurar'."; then
    echo "# lote $(sello)" >> "$ARCHIVO_RESTAURAR"
    for p in "${PRESENTES[@]}"; do quitar "$p"; done
    titulo "LISTO"
    info "Registro de lo eliminado: informes/paquetes-eliminados.txt"
    info "Reiniciá el telefono para que se libere la memoria de esos servicios."
  else
    aviso "Cancelado."
  fi
fi

# --- Nivel 2 --------------------------------------------------------------

if [ "$MODO" = "opcional" ]; then
  titulo "NIVEL 2 - REVISION UNO POR UNO"
  info "Respondé 's' para eliminar, cualquier otra tecla para conservar."
  info "Ante la duda: conservalo. Siempre podes volver a correr esto."
  echo
  echo "# lote opcional $(sello)" >> "$ARCHIVO_RESTAURAR"
  while read -r pkg; do
    [ -z "$pkg" ] && continue
    esta_prohibido "$pkg" && continue
    paquete_existe "$pkg" || continue
    comentario="$(grep -m1 "^$pkg" "$DIR_DATOS/nivel2-opcional.txt" | sed 's/^[^#]*#\s*//')"
    printf '\n  %s%s%s\n' "$C_NEG" "$pkg" "$C_FIN"
    [ -n "$comentario" ] && printf '      %s\n' "$comentario"
    printf '      Eliminar? [s/N]: '
    read -r r </dev/tty
    case "$r" in
      s|S) quitar "$pkg" ;;
      *)   info "conservado" ;;
    esac
  done < <(leer_lista "$DIR_DATOS/nivel2-opcional.txt")
  titulo "LISTO"
  info "Reiniciá el telefono."
fi
