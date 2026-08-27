#!/usr/bin/env bash
# acceso.sh - kit de diagnostico, limpieza y optimizacion para Samsung Galaxy vía ADB.
# Uso:  ./acceso.sh <comando> [opciones]
set -uo pipefail
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$RAIZ/lib/comun.sh"

ayuda() {
cat <<'TXT'

  ACCESO - optimizacion de Samsung Galaxy por ADB

  DIAGNOSTICO (no modifican nada)
    diagnostico            Radiografia completa: hardware, Android, bateria,
                           almacenamiento, RAM, apps y ajustes clave.
    seguridad              Auditoria antimalware: origen de las apps, accesibilidad,
                           administradores, permisos peligrosos, proxy y VPN.
    bateria                Quien consume, wakelocks, alarmas y apps sin restringir.
    bateria reset          Pone los contadores a cero para medir un periodo limpio.
    bateria informe        Genera el bugreport para Battery Historian.
    limpieza               Muestra que basura hay, sin borrar.

  ACCION (piden confirmacion explicita)
    limpieza ejecutar      Vacia cachés, miniaturas y temporales. No toca tus archivos.
    debloat                Simula: lista el bloatware presente en tu equipo.
    debloat aplicar        Elimina el nivel 1 (seguro). Reversible.
    debloat opcional       Revisa el nivel 2 preguntando app por app.
    optimizar              Muestra los ajustes de rendimiento propuestos.
    optimizar aplicar      Aplica animaciones, escaneos pasivos y recompilacion.
    optimizar revertir     Vuelve todo a los valores de fabrica.
    restringir <paquete>   Corta el segundo plano de una app concreta.

  DESHACER
    restaurar              Reinstala TODO lo que quito el debloat.
    restaurar <paquete>    Reinstala un paquete puntual.

  ATAJOS
    todo                   Corre los cuatro diagnosticos seguidos.

  Antes de empezar leé:  docs/ajustes-manuales.md  y  docs/para-vos.md

TXT
}

CMD="${1:-ayuda}"; shift || true

case "$CMD" in
  diagnostico|diag)  bash "$RAIZ/modulos/diagnostico.sh" "$@" ;;
  seguridad|sec)     bash "$RAIZ/modulos/seguridad.sh"   "$@" ;;
  bateria|bat)       bash "$RAIZ/modulos/bateria.sh"     "$@" ;;
  limpieza|clean)    bash "$RAIZ/modulos/limpieza.sh"    "$@" ;;
  debloat)           bash "$RAIZ/modulos/debloat.sh"     "$@" ;;
  optimizar|opt)     bash "$RAIZ/modulos/optimizar.sh"   "$@" ;;
  restringir)        bash "$RAIZ/modulos/restringir.sh"  "$@" ;;
  restaurar)         bash "$RAIZ/modulos/restaurar.sh"   "$@" ;;
  todo)
    bash "$RAIZ/modulos/diagnostico.sh"
    bash "$RAIZ/modulos/seguridad.sh"
    bash "$RAIZ/modulos/bateria.sh"
    bash "$RAIZ/modulos/limpieza.sh"
    titulo "DIAGNOSTICO COMPLETO TERMINADO"
    info "Todos los informes quedaron en la carpeta informes/"
    ;;
  ayuda|-h|--help|help) ayuda ;;
  *) alerta "Comando desconocido: $CMD"; ayuda; exit 1 ;;
esac
