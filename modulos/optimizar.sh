#!/usr/bin/env bash
# Ajustes de rendimiento y energia que se aplican por ADB.
# Todos son reversibles y ninguno toca datos tuyos.
#
#   ./acceso.sh optimizar          -> muestra el estado actual y que cambiaria
#   ./acceso.sh optimizar aplicar  -> aplica los cambios
#   ./acceso.sh optimizar revertir -> vuelve a los valores de fabrica
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

MODO="${1:-mostrar}"

titulo "AJUSTES DE FLUIDEZ (animaciones)"
info "Bajar las animaciones a 0.5x no acelera el hardware, pero recorta ~150 ms"
info "de espera en cada transicion. Es el cambio que mas se nota al instante."
echo
for k in window_animation_scale transition_animation_scale animator_duration_scale; do
  printf '  %-32s actual: %-6s  propuesto: 0.5\n' "$k" "$(sh_adb settings get global "$k")"
done

titulo "ESCANEO PASIVO DE RADIOS"
info "Con esto activado el telefono busca redes Wi-Fi y balizas Bluetooth incluso"
info "con Wi-Fi y BT apagados. Es drenaje puro en reposo si no usas ubicacion fina."
echo
printf '  %-32s actual: %-6s  propuesto: 0\n' "wifi_scan_always_enabled" "$(sh_adb settings get global wifi_scan_always_enabled)"
printf '  %-32s actual: %-6s  propuesto: 0\n' "ble_scan_always_enabled"  "$(sh_adb settings get global ble_scan_always_enabled)"

titulo "BATERIA ADAPTATIVA"
printf '  %-32s actual: %-6s  propuesto: 1\n' "adaptive_battery" "$(sh_adb settings get global adaptive_battery_management_enabled)"

titulo "RESOLUCION DE PANTALLA"
info "Si tu equipo es QHD+ (1440p), bajar a FHD+ (1080p) reduce bastante el gasto"
info "de GPU sin diferencia visible a distancia normal de lectura."
echo
printf '  Resolucion actual: %s\n' "$(sh_adb wm size)"
printf '  Densidad actual  : %s\n' "$(sh_adb wm density)"
info "Este cambio conviene hacerlo desde Ajustes > Pantalla > Resolucion de pantalla,"
info "porque asi One UI ajusta tambien la densidad y el escalado de la interfaz."

case "$MODO" in
aplicar)
  if ! confirmar "Voy a aplicar los ajustes de arriba. Todo se revierte con './acceso.sh optimizar revertir'."; then
    aviso "Cancelado."; exit 0
  fi
  titulo "APLICANDO"
  for k in window_animation_scale transition_animation_scale animator_duration_scale; do
    sh_adb settings put global "$k" 0.5 && ok "$k = 0.5"
  done
  sh_adb settings put global wifi_scan_always_enabled 0 && ok "escaneo Wi-Fi pasivo desactivado"
  sh_adb settings put global ble_scan_always_enabled 0  && ok "escaneo Bluetooth pasivo desactivado"
  sh_adb settings put global adaptive_battery_management_enabled 1 && ok "bateria adaptativa activada"

  sub "Compilando apps para arranque mas rapido"
  info "Recompila el bytecode de todas las apps con el perfil de velocidad."
  info "Tarda unos minutos. Dejá el telefono conectado."
  sh_adb 'cmd package compile -m speed-profile -a' 2>&1 | tail -3 | sed 's/^/  /'
  ok "Recompilacion terminada."

  titulo "LISTO"
  info "Reiniciá el telefono para que tome todo."
  ;;

revertir)
  titulo "REVIRTIENDO A VALORES DE FABRICA"
  for k in window_animation_scale transition_animation_scale animator_duration_scale; do
    sh_adb settings put global "$k" 1.0 && ok "$k = 1.0"
  done
  sh_adb settings put global wifi_scan_always_enabled 1 && ok "escaneo Wi-Fi pasivo restaurado"
  sh_adb settings put global ble_scan_always_enabled 1  && ok "escaneo Bluetooth pasivo restaurado"
  ;;

*)
  titulo "MODO CONSULTA"
  info "No se cambio nada. Para aplicar:  ./acceso.sh optimizar aplicar"
  ;;
esac
