#!/usr/bin/env bash
# Radiografia completa del telefono. Solo lectura: no modifica absolutamente nada.
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

INFORME="$DIR_INFORMES/diagnostico-$(sello).txt"
exec > >(tee "$INFORME") 2>&1

titulo "IDENTIDAD DEL EQUIPO"
printf '  Modelo comercial : %s\n' "$(prop ro.product.model)"
printf '  Nombre interno   : %s\n' "$(prop ro.product.device)"
printf '  Fabricante       : %s\n' "$(prop ro.product.manufacturer)"
printf '  Android          : %s (API %s)\n' "$(prop ro.build.version.release)" "$(prop ro.build.version.sdk)"
printf '  One UI           : %s\n' "$(prop ro.build.version.oneui)"
printf '  Compilacion      : %s\n' "$(prop ro.build.display.id)"
printf '  Parche seguridad : %s\n' "$(prop ro.build.version.security_patch)"
printf '  Procesador       : %s\n' "$(prop ro.board.platform)"
printf '  Region/operador  : %s / %s\n' "$(prop ro.csc.country_code)" "$(prop ro.csc.sales_code)"

PARCHE="$(prop ro.build.version.security_patch)"
# date -d es de GNU; en macOS hay que usar date -j -f. Si ninguno anda, se omite.
epoca_parche() {
  date -d "$1" +%s 2>/dev/null || date -j -f '%Y-%m-%d' "$1" +%s 2>/dev/null
}
if [ -n "$PARCHE" ]; then
  EP="$(epoca_parche "$PARCHE")"
  if [ -z "$EP" ]; then
    info "Parche de seguridad: $PARCHE (no pude calcular la antiguedad en este sistema)."
    edad=-1
  else
    edad=$(( ( $(date +%s) - EP ) / 86400 ))
  fi
  if [ "$edad" -lt 0 ]; then
    :
  elif [ "$edad" -gt 180 ] 2>/dev/null; then
    alerta "El parche de seguridad tiene $edad dias. Estas expuesto a fallos ya publicados."
  elif [ "$edad" -gt 90 ] 2>/dev/null; then
    aviso "El parche de seguridad tiene $edad dias. Convendria actualizar."
  else
    ok "Parche de seguridad al dia ($edad dias)."
  fi
fi

titulo "INTEGRIDAD DEL SISTEMA"
KNOX="$(prop ro.boot.warranty_bit)"; VERIF="$(prop ro.boot.verifiedbootstate)"
FLASH="$(prop ro.boot.flash.locked)"
[ "$KNOX" = "1" ] && alerta "Knox quemado (warranty_bit=1): el equipo fue rooteado o le flashearon firmware." \
                 || ok "Knox intacto: firmware de fabrica."
[ "$VERIF" = "green" ] && ok "Arranque verificado (verifiedbootstate=green)." \
                       || aviso "Arranque verificado en estado '${VERIF:-desconocido}'."
[ "$FLASH" = "1" ] && ok "Bootloader bloqueado." || aviso "Bootloader NO bloqueado (flash.locked=${FLASH:-?})."
if sh_adb 'which su' | grep -q su; then
  alerta "Se detecto binario 'su': el telefono tiene root. Amplia mucho la superficie de ataque."
else
  ok "Sin binario 'su' visible (sin root evidente)."
fi

titulo "BATERIA"
sh_adb dumpsys battery | sed 's/^/  /'
sub "Salud y ciclos"
for ruta in /sys/class/power_supply/battery/cycle_count \
            /sys/class/power_supply/battery/battery_cycle \
            /sys/class/power_supply/battery/charge_full \
            /sys/class/power_supply/battery/charge_full_design; do
  val="$(sh_adb "cat $ruta")"
  [ -n "$val" ] && printf '  %-52s %s\n' "$(basename "$ruta")" "$val"
done
ASOC="$(sh_adb "dumpsys battery | grep -i -m1 'asoc\|maximum capacity'")"
[ -n "$ASOC" ] && printf '  %s\n' "$ASOC"
info "Si no aparece la salud aca, marcá *#9900# en el telefono, corré 'dumpstate' y buscá mSavedBatteryAsoc."

titulo "ALMACENAMIENTO"
sh_adb df -h /data /storage/emulated 2>/dev/null | sed 's/^/  /'
sub "Lo que mas ocupa dentro de la memoria interna"
sh_adb 'du -sm /sdcard/* 2>/dev/null | sort -rn | head -20' | sed 's/^/  /'

titulo "MEMORIA RAM"
sh_adb 'cat /proc/meminfo | head -5' | sed 's/^/  /'
sub "Las 12 apps que mas RAM ocupan ahora mismo"
sh_adb 'dumpsys meminfo | sed -n "/Total PSS by process/,/^$/p" | head -15' | sed 's/^/  /'

titulo "APLICACIONES INSTALADAS"
TOT="$(sh_adb 'pm list packages --user 0' | wc -l | tr -d ' ')"
TER="$(sh_adb 'pm list packages -3 --user 0' | wc -l | tr -d ' ')"
SIS="$(sh_adb 'pm list packages -s --user 0' | wc -l | tr -d ' ')"
DES="$(sh_adb 'pm list packages -d --user 0' | wc -l | tr -d ' ')"
printf '  Total activas      : %s\n' "$TOT"
printf '  De terceros        : %s\n' "$TER"
printf '  Del sistema        : %s\n' "$SIS"
printf '  Deshabilitadas     : %s\n' "$DES"

sub "Bloatware detectado en tu equipo (nivel 1, seguro de quitar)"
n=0
while read -r pkg; do
  [ -z "$pkg" ] && continue
  if paquete_existe "$pkg"; then printf '  %s\n' "$pkg"; n=$((n+1)); fi
done < <(leer_lista "$DIR_DATOS/nivel1-seguro.txt")
printf '\n  Encontrados: %s paquetes de nivel 1 que podes eliminar.\n' "$n"

titulo "AJUSTES QUE AFECTAN RENDIMIENTO Y BATERIA"
for k in window_animation_scale transition_animation_scale animator_duration_scale; do
  printf '  %-32s %s\n' "$k" "$(sh_adb settings get global "$k")"
done
printf '  %-32s %s\n' "adaptive_battery" "$(sh_adb settings get global adaptive_battery_management_enabled)"
printf '  %-32s %s\n' "low_power (ahorro energia)" "$(sh_adb settings get global low_power)"
printf '  %-32s %s\n' "wifi_scan_always_enabled" "$(sh_adb settings get global wifi_scan_always_enabled)"
printf '  %-32s %s\n' "ble_scan_always_enabled" "$(sh_adb settings get global ble_scan_always_enabled)"
printf '  %-32s %s\n' "brillo automatico" "$(sh_adb settings get system screen_brightness_mode)"
printf '  %-32s %s\n' "tiempo de pantalla (ms)" "$(sh_adb settings get system screen_off_timeout)"
printf '  %-32s %s\n' "resolucion pantalla" "$(sh_adb wm size)"
printf '  %-32s %s\n' "densidad" "$(sh_adb wm density)"

titulo "RESUMEN"
info "Informe completo guardado en: informes/$(basename "$INFORME")"
info "Siguiente paso sugerido:  ./acceso.sh seguridad"
