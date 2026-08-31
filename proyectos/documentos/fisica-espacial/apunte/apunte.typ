// =====================================================================
//  Apunte de Física Espacial — UNSAM, Ing. en Sistemas Espaciales
//  Compilar:   typst compile apunte.typ apunte.pdf
//  Vista viva: typst watch apunte.typ apunte.pdf
//
//  Los `include` comentados son los módulos que todavía no se escribieron.
//  Están escritos con su nombre de archivo definitivo a propósito: así el
//  plan del PDP §5 y este archivo no pueden divergir sin que se vea.
// =====================================================================

#import "plantilla.typ": *

#show: apunte.with(
  titulo: "Física Espacial",
  subtitulo: "Apunte general de la materia — de los teoremas de conservación a la mecánica orbital y el cuerpo rígido",
  institucion: "UNSAM — Ingeniería en Sistemas Espaciales",
  catedra: "Cátedra Feder–Valenti",
  ciclo: "Ciclo lectivo 2026",
)

// ---------------------------------------------------------------------
#parte(1, "Herramientas", [
  Un solo módulo, y es el que sostiene a los otros catorce. La materia entera se
  escribe con vectores, y dos de sus tres teoremas de conservación sólo son
  manejables en coordenadas polares — donde los versores giran con la partícula y
  la derivada de un vector tiene un término que en cartesianas no existe.

  Si algo de acá queda flojo, no se nota en este módulo: se nota tres partes más
  adelante, cuando la aceleración de una órbita no cierre y no se sepa por qué.
])

#include "modulos/m1-vectores.typ"

// ---------------------------------------------------------------------
// #parte(2, "Los teoremas de conservación", [...])
// #include "modulos/m2-cantidad-movimiento.typ"
// #include "modulos/m3-centro-de-masa.typ"
// #include "modulos/m4-cohete.typ"
// #include "modulos/m5-trabajo-energia.typ"

// ---------------------------------------------------------------------
// #parte(3, "Gravitación y mecánica orbital", [...])
// #include "modulos/m6-gravitacion.typ"
// #include "modulos/m7-momento-angular.typ"
// #include "modulos/m8-dos-cuerpos.typ"
// #include "modulos/m9-orbita-conicas.typ"
// #include "modulos/m10-kepler.typ"
// #include "modulos/m11-maniobras.typ"

// ---------------------------------------------------------------------
// #parte(4, "Cuerpo rígido", [...])
// #include "modulos/m12-cinematica-cr.typ"
// #include "modulos/m13-inercia.typ"
// #include "modulos/m14-euler-giroscopo.typ"
// #include "modulos/m15-peonza.typ"

// ---------------------------------------------------------------------
// #include "modulos/anexos.typ"
