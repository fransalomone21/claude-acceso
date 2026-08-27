#!/usr/bin/env bash
# Limpieza de basura real. Muestra todo primero; no borra nada sin confirmacion.
#
# Filosofia: NO borramos archivos tuyos. Solo cachés regenerables y residuos.
# Los archivos grandes se listan para que decidas vos.
source "$(dirname "${BASH_SOURCE[0]}")/../lib/comun.sh"
exigir_adb

MODO="${1:-analizar}"
INFORME="$DIR_INFORMES/limpieza-$(sello).txt"
exec > >(tee "$INFORME") 2>&1

titulo "ESPACIO DISPONIBLE"
sh_adb df -h /data 2>/dev/null | sed 's/^/  /'

titulo "QUE ESTA OCUPANDO LA MEMORIA INTERNA"
sh_adb 'du -sm /sdcard/* 2>/dev/null | sort -rn | head -25' | sed 's/^/  /'

titulo "CACHES DE APLICACIONES"
TOTAL_CACHE="$(sh_adb 'du -sm /data/data/*/cache 2>/dev/null | awk "{s+=\$1} END {print s}"')"
printf '  Cache total estimada: %s MB\n' "${TOTAL_CACHE:-no accesible sin root}"
sub "Las 15 apps con mas cache"
sh_adb 'du -sm /data/data/*/cache 2>/dev/null | sort -rn | head -15' | sed 's/^/  /'

titulo "RESIDUOS TIPICOS"
for d in /sdcard/Android/data/*/cache /sdcard/DCIM/.thumbnails /sdcard/.thumbnails \
         /sdcard/LOST.DIR /sdcard/Download /sdcard/bugreports /data/local/tmp; do
  tam="$(sh_adb "du -sm $d 2>/dev/null | tail -1 | cut -f1")"
  [ -n "$tam" ] && [ "$tam" != "0" ] && printf '  %-50s %s MB\n' "$d" "$tam"
done

titulo "WHATSAPP: casi siempre el mayor consumidor"
for d in "/sdcard/Android/media/com.whatsapp/WhatsApp/Media" \
         "/sdcard/WhatsApp/Media"; do
  if sh_adb "[ -d '$d' ] && echo si" | grep -q si; then
    sh_adb "du -sm '$d'/* 2>/dev/null | sort -rn" | sed 's/^/  /'
    sub "Bases de datos de respaldo (se regeneran solas)"
    sh_adb "du -sm '${d%/Media}/Databases' 2>/dev/null" | sed 's/^/  /'
  fi
done

titulo "ARCHIVOS SUELTOS DE MAS DE 100 MB"
sh_adb 'find /sdcard -type f -size +100M 2>/dev/null | head -40' | while read -r f; do
  [ -z "$f" ] && continue
  printf '  %-8s %s\n' "$(sh_adb "du -m '$f' 2>/dev/null | cut -f1") MB" "$f"
done

titulo "APKS VIEJOS TIRADOS EN EL TELEFONO"
info "Un APK guardado no sirve de nada y es el vector clasico de reinfeccion."
sh_adb 'find /sdcard -type f -name "*.apk" 2>/dev/null' | sed 's/^/  /' || true

titulo "APPS QUE NO USAS HACE MESES"
info "Ocupan espacio, corren en segundo plano y siguen recibiendo actualizaciones."
echo
while read -r pkg; do
  pkg="${pkg#package:}"; [ -z "$pkg" ] && continue
  b="$(sh_adb "am get-standby-bucket $pkg")"
  case "$b" in
    45|50|rare|restricted) printf '  %-52s (bucket: %s)\n' "$pkg" "$b" ;;
  esac
done < <(sh_adb 'pm list packages -3 --user 0')

if [ "$MODO" != "ejecutar" ]; then
  titulo "ESTO FUE SOLO UN ANALISIS"
  info "Para ejecutar la limpieza segura:  ./acceso.sh limpieza ejecutar"
  info "Se van a borrar UNICAMENTE cachés y miniaturas: todo se regenera solo."
  info "Nunca se tocan fotos, videos, documentos ni datos de apps."
  exit 0
fi

titulo "LIMPIEZA"
if ! confirmar "Voy a vaciar cachés de apps, miniaturas y /data/local/tmp. No se tocan tus archivos."; then
  aviso "Cancelado. No se borro nada."
  exit 0
fi

sub "Vaciando cachés via el gestor de paquetes"
sh_adb 'pm trim-caches 999G' >/dev/null && ok "Cachés liberadas."

sub "Miniaturas"
for d in /sdcard/DCIM/.thumbnails /sdcard/.thumbnails /sdcard/Pictures/.thumbnails; do
  sh_adb "rm -rf $d" >/dev/null 2>&1 && info "limpiado: $d"
done
ok "Miniaturas eliminadas (se regeneran al abrir la galeria)."

sub "Residuos temporales"
sh_adb 'rm -rf /data/local/tmp/* /sdcard/LOST.DIR /sdcard/bugreports' >/dev/null 2>&1
ok "Temporales eliminados."

sub "Cachés de apps de terceros, una por una"
while read -r pkg; do
  pkg="${pkg#package:}"; [ -z "$pkg" ] && continue
  sh_adb "pm clear --cache-only $pkg" >/dev/null 2>&1
done < <(sh_adb 'pm list packages -3 --user 0')
ok "Cachés de apps de terceros vaciadas."

titulo "RESULTADO"
sh_adb df -h /data 2>/dev/null | sed 's/^/  /'
info "Informe guardado en: informes/$(basename "$INFORME")"
