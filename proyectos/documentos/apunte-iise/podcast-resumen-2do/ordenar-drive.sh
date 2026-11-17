#!/usr/bin/env bash
# Ordena el Drive privado de IISE (Fran, 2026-11-17: «ordená los podcast subidos con nombres según
# los temas y en carpetas»). Movimientos del lado del servidor (moveto): no se re-sube nada.
set -u
R=(rclone --config "$HOME/.config/rclone/rclone.conf")
B="drive-personal:01 - UNSAM - Ing. en Sistemas Espaciales/SOLO FRAN - no se comparte con nadie/IISE"
P="$B/2do parcial"
LARGO="$P/3 - Podcast largo, modulo por modulo (con el apunte)"
mover() { "${R[@]}" moveto "$1" "$2" 2>&1 | grep -v NOTICE; }

mover "$B/Resumen 2do parcial/Resumen 2do parcial IISE (clases 7 a 13).pdf" \
      "$P/1 - Resumen para estudiar (PDF)/Resumen 2do parcial IISE - clases 7 a 13.pdf"

V="$B/Podcast 2do parcial/Podcast IISE 2do parcial"
mover "$V - COMPLETO.m4a" "$LARGO/00 - Completo (1 h 52 min).m4a"
i=0
while IFS= read -r t; do
  i=$((i+1)); n=$(printf "%02d" $i)
  mover "$V - parte $n.m4a" "$LARGO/$n - $t.m4a"
done <<'LISTA'
Crear arquitecturas y Fase A (mod 25-26)
Interfaces de la Fase A, SRR, MDR y N2 (mod 26-28)
Plan de trabajo, WBS, camino critico y estimaciones (mod 29-30)
El LDCM y los lanzadores (mod 31-32)
Diagrama funcional y plantilla de requerimientos (mod 33-34)
Fase B, PDR y madurez tecnologica TRL-IRL-SRL (mod 35-36)
Fase C, CDR, SIR y forma-funcion (mod 37-38)
PDR del ROV y gestion del riesgo (mod 39-40)
Verificacion y validacion del producto, modelos y ensayos (mod 41-42)
Ensayos de un subsistema, drivers y presupuestos (mod 43-44)
Fase D, ORR, FRR e interfaces canonicas (mod 45-46)
Riesgo, FRR por dentro y Fase E (mod 47)
LISTA
"${R[@]}" rmdir "$B/Podcast 2do parcial" 2>&1 | grep -v NOTICE
"${R[@]}" rmdir "$B/Resumen 2do parcial" 2>&1 | grep -v NOTICE
"${R[@]}" lsf -R "$P" 2>&1 | grep -v NOTICE
