#!/usr/bin/env bash
# Analisis de consumo de bateria. Solo lectura salvo el subcomando 'reset'.
#
#   ./acceso.sh bateria         -> analiza lo acumulado desde la ultima carga
#   ./acceso.sh bateria reset   -> pone el contador a cero para medir limpio
#   ./acceso.sh bateria informe -> genera el bugreport para Battery Historian
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

ACCION="${1:-analizar}"

case "$ACCION" in
reset)
  titulo "REINICIAR CONTADORES DE BATERIA"
  sh_adb dumpsys batterystats --reset >/dev/null
  sh_adb dumpsys batterystats --enable full-wake-history >/dev/null
  ok "Contadores a cero y registro detallado de wakelocks activado."
  info "Ahora desconectá el cable y usá el telefono normalmente 3 o 4 horas."
  info "Dejalo tambien un rato en reposo con la pantalla apagada."
  info "Despues volvé a conectarlo y corré:  ./acceso.sh bateria"
  aviso "El registro detallado se llena en pocas horas: no lo dejes activo por dias."
  exit 0
  ;;
informe)
  DEST="$DIR_INFORMES/bugreport-$(sello).zip"
  titulo "GENERANDO BUGREPORT (tarda 2-5 minutos)"
  "$ADB_CMD" bugreport "$DEST"
  ok "Guardado en $DEST"
  info "Subilo a Battery Historian para ver la linea de tiempo grafica:"
  info "  docker run -p 9999:9999 gcr.io/android-battery-historian/stable:3.0 --port 9999"
  info "  y abrí http://localhost:9999"
  exit 0
  ;;
esac

INFORME="$DIR_INFORMES/bateria-$(sello).txt"
exec > >(tee "$INFORME") 2>&1

titulo "ESTADO ACTUAL"
sh_adb dumpsys battery | sed 's/^/  /'

titulo "LAS APPS QUE MAS BATERIA CONSUMIERON"
info "Ordenado por consumo estimado desde la ultima carga completa."
echo
sh_adb 'dumpsys batterystats --charged' \
  | sed -n '/Estimated power use/,/^$/p' | head -30 | sed 's/^/  /'

titulo "WAKELOCKS: lo que impide que el telefono duerma"
info "Un wakelock mantiene despierta la CPU con la pantalla apagada. Es LA causa"
info "numero uno del drenaje nocturno. Mirá los que suman minutos u horas."
echo
sh_adb 'dumpsys batterystats' \
  | grep -iE 'wake_lock|partial wake' | grep -vE '^\s*$' | head -25 | sed 's/^/  /'

titulo "ALARMAS EN SEGUNDO PLANO"
info "Apps que despiertan el telefono en horario fijo. Muchas alarmas = drenaje."
echo
sh_adb 'dumpsys alarm' \
  | grep -E '^\s+[0-9]+ wakeups|Alarm Stats' -A1 | head -30 | sed 's/^/  /'

titulo "SENSOR DE RED Y PANTALLA"
sub "Tiempo de pantalla encendida"
sh_adb 'dumpsys batterystats | grep -m3 -iE "screen on|screen brightness"' | sed 's/^/  /'
sub "Actividad de radio movil"
sh_adb 'dumpsys batterystats | grep -m5 -iE "mobile radio|signal levels"' | sed 's/^/  /'

titulo "DOZE: modo de suspension profunda"
sh_adb 'dumpsys deviceidle | head -20' | sed 's/^/  /'
sub "Apps EXENTAS de la optimizacion de bateria"
info "Cada app de esta lista puede correr libre en segundo plano toda la noche."
info "Deberian estar solo: mensajeria, alarma y despertador."
echo
sh_adb 'dumpsys deviceidle whitelist' | grep -v '^system' | sed 's/^/  /' | head -40

titulo "APPS SIN RESTRICCION DE FONDO (standby bucket)"
info "'active' o 'working_set' = permiso amplio. 'restricted' = maxima restriccion."
echo
while read -r pkg; do
  pkg="${pkg#package:}"; [ -z "$pkg" ] && continue
  b="$(sh_adb "am get-standby-bucket $pkg")"
  case "$b" in
    10|active)      printf '  %-52s %s\n' "$pkg" "ACTIVE" ;;
    20|working_set) printf '  %-52s %s\n' "$pkg" "working_set" ;;
  esac
done < <(sh_adb 'pm list packages -3 --user 0')

titulo "QUE HACER CON ESTO"
info "1. Toda app de arriba que no necesites al instante -> restringila:"
info "     ./acceso.sh restringir <paquete>"
info "2. Sacá de la lista de exentas todo lo que no sea mensajeria o alarma:"
info "     Ajustes > Bateria > Limites de uso en segundo plano."
info "3. Los ajustes manuales que mas rinden estan en docs/ajustes-manuales.md"
info "Informe guardado en: informes/$(basename "$INFORME")"
