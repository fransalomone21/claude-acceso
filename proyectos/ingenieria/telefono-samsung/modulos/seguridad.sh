#!/usr/bin/env bash
# Auditoria antimalware y de privacidad. Solo lectura: no modifica nada.
#
# Busca las senales que usa realmente el malware Android moderno:
# instalacion fuera de Play Store, abuso del servicio de Accesibilidad,
# administrador de dispositivo, superposicion de ventanas y lectura de SMS.
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

INFORME="$DIR_INFORMES/seguridad-$(sello).txt"
exec > >(tee "$INFORME") 2>&1

SOSPECHAS=0

titulo "1. ORIGEN DE LAS APLICACIONES"
info "El malware casi nunca llega por Play Store. Lo instalado desde el navegador,"
info "WhatsApp o un APK suelto es lo primero que hay que mirar."
echo
FUERA=0
while read -r linea; do
  # formato:  package:com.foo  installer=com.android.vending
  pkg="${linea#package:}"; pkg="${pkg%%[[:space:]]*}"
  [ -z "$pkg" ] && continue
  inst="${linea##*installer=}"; inst="${inst%%[[:space:]]*}"
  case "$inst" in
    com.android.vending|com.google.android.packageinstaller) continue ;;
    com.sec.android.app.samsungapps|com.samsung.android.*) continue ;;
  esac
  case "$inst" in
    null|"")            alerta "$pkg  -> sin instalador registrado (APK suelto / adb)"; FUERA=$((FUERA+1)) ;;
    com.android.chrome|com.android.browser|com.sec.android.app.sbrowser)
                        alerta "$pkg  -> instalada desde el NAVEGADOR"; FUERA=$((FUERA+1)) ;;
    com.whatsapp|org.telegram.messenger)
                        alerta "$pkg  -> instalada desde una app de MENSAJERIA"; FUERA=$((FUERA+1)) ;;
    *)                  aviso  "$pkg  -> instalador: $inst"; FUERA=$((FUERA+1)) ;;
  esac
done < <(sh_adb 'pm list packages -3 -i --user 0')
[ "$FUERA" -eq 0 ] && ok "Todas las apps de terceros vienen de tiendas oficiales." \
                   || { aviso "$FUERA app(s) fuera de tienda oficial. Revisá una por una."; SOSPECHAS=$((SOSPECHAS+FUERA)); }

titulo "2. SERVICIOS DE ACCESIBILIDAD ACTIVOS"
info "Accesibilidad permite LEER TODA la pantalla y TOCAR por vos. Es el permiso"
info "que usan los troyanos bancarios. Aca solo deberian estar apps que reconozcas."
echo
ACC="$(sh_adb settings get secure enabled_accessibility_services)"
if [ -z "$ACC" ] || [ "$ACC" = "null" ]; then
  ok "Ningun servicio de accesibilidad activo."
else
  echo "$ACC" | tr ':' '\n' | while read -r s; do
    [ -z "$s" ] && continue
    alerta "$s"
  done
  aviso "Verificá cada uno. Si no sabes que es, apagalo en:"
  info "Ajustes > Accesibilidad > Apps instaladas."
  SOSPECHAS=$((SOSPECHAS+1))
fi

titulo "3. ADMINISTRADORES DE DISPOSITIVO"
info "Un administrador puede bloquear o borrar el telefono, y no se desinstala"
info "hasta que le saques ese rol. El ransomware y el stalkerware lo piden siempre."
echo
ADMINS="$(sh_adb 'dumpsys device_policy | grep -i "^  Admin\|admin=ComponentInfo"')"
if [ -z "$ADMINS" ]; then
  ok "Sin administradores de dispositivo registrados."
else
  echo "$ADMINS" | sed 's/^/  /'
  aviso "Revisalos en Ajustes > Seguridad y privacidad > Mas ajustes > Apps de administracion."
  SOSPECHAS=$((SOSPECHAS+1))
fi

titulo "4. LECTORES DE NOTIFICACIONES"
info "Quien lee tus notificaciones lee los codigos de verificacion (2FA) de tu banco."
echo
NOT="$(sh_adb settings get secure enabled_notification_listeners)"
if [ -z "$NOT" ] || [ "$NOT" = "null" ]; then
  ok "Ninguna app leyendo notificaciones."
else
  echo "$NOT" | tr ':' '\n' | sed '/^$/d;s/^/  /'
  aviso "Ajustes > Notificaciones > Ajustes avanzados > Acceso a notificaciones."
fi

titulo "5. APPS QUE PUEDEN INSTALAR OTRAS APPS"
info "El dropper instala el payload real. Solo tu navegador deberia tener esto."
echo
INS="$(sh_adb 'cmd appops query-op REQUEST_INSTALL_PACKAGES allow' | sed '/^$/d')"
if [ -z "$INS" ]; then ok "Ninguna app con permiso para instalar paquetes."
else echo "$INS" | sed 's/^/  /'; aviso "Quitá el permiso a todo lo que no sea tu navegador."; fi

titulo "6. APPS QUE DIBUJAN ENCIMA DE OTRAS"
info "La superposicion permite montar una pantalla falsa de login sobre tu app real."
echo
OVL="$(sh_adb 'cmd appops query-op SYSTEM_ALERT_WINDOW allow' | sed '/^$/d')"
if [ -z "$OVL" ]; then ok "Ninguna app con superposicion."
else echo "$OVL" | sed 's/^/  /'; info "Normal en: burbujas de chat, grabadores de pantalla, gestos."; fi

titulo "7. PERMISOS SENSIBLES CONCEDIDOS A APPS DE TERCEROS"
for permiso in android.permission.READ_SMS android.permission.RECEIVE_SMS \
               android.permission.RECORD_AUDIO android.permission.CAMERA \
               android.permission.ACCESS_FINE_LOCATION android.permission.READ_CONTACTS \
               android.permission.READ_CALL_LOG; do
  sub "${permiso##*.}"
  encontrado=0
  while read -r pkg; do
    pkg="${pkg#package:}"; [ -z "$pkg" ] && continue
    if sh_adb "dumpsys package $pkg" | grep -q "$permiso: granted=true"; then
      printf '    %s\n' "$pkg"; encontrado=1
    fi
  done < <(sh_adb 'pm list packages -3 --user 0')
  [ "$encontrado" -eq 0 ] && printf '    (ninguna)\n'
done

titulo "8. RED: proxy, VPN y DNS"
PROXY="$(sh_adb settings get global http_proxy)"
if [ -z "$PROXY" ] || [ "$PROXY" = "null" ] || [ "$PROXY" = ":0" ]; then
  ok "Sin proxy HTTP global configurado."
else
  alerta "PROXY GLOBAL ACTIVO: $PROXY  <-- todo tu trafico pasa por ahi. Muy sospechoso."
  SOSPECHAS=$((SOSPECHAS+1))
fi
printf '  DNS privado : %s (%s)\n' \
  "$(sh_adb settings get global private_dns_mode)" "$(sh_adb settings get global private_dns_specifier)"
VPN="$(sh_adb 'dumpsys connectivity | grep -i -m3 "VPN"')"
[ -n "$VPN" ] && { echo "$VPN" | sed 's/^/  /'; info "Si no configuraste una VPN, averiguá quien la puso."; }

titulo "9. AJUSTES DE SEGURIDAD DEL SISTEMA"
DESC="$(sh_adb settings get global install_non_market_apps)"
[ "$DESC" = "1" ] && aviso "Origenes desconocidos habilitado globalmente." || ok "Origenes desconocidos no habilitado a nivel global."
ADBW="$(sh_adb settings get global adb_wifi_enabled)"
[ "$ADBW" = "1" ] && { alerta "Depuracion inalambrica ACTIVA. Apagala al terminar: es una puerta abierta en tu red."; SOSPECHAS=$((SOSPECHAS+1)); } \
                  || ok "Depuracion inalambrica apagada."
if paquete_existe com.samsung.android.rampart; then
  ok "Auto Blocker presente. Activalo: Ajustes > Seguridad y privacidad > Auto Blocker."
else
  aviso "No detecto Auto Blocker (necesita One UI 6.1+)."
fi
sub "Estado de Google Play Protect"
sh_adb 'dumpsys package com.google.android.gms | grep -i -m2 "verifier\|harmful"' | sed 's/^/  /'
info "Verificalo a mano: Play Store > tu foto > Play Protect > Analizar."

titulo "VEREDICTO"
if [ "$SOSPECHAS" -eq 0 ]; then
  ok "No aparecio ningun indicador fuerte de compromiso."
  info "Igual pasá un escaner (ver docs/para-vos.md) para confirmar."
else
  alerta "Hay $SOSPECHAS punto(s) que merecen que los mires con detalle (arriba en rojo)."
fi
info "Informe guardado en: informes/$(basename "$INFORME")"
