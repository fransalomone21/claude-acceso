// =====================================================================
//  Apunte de Aplicaciones de Electronica Analogica — 4to Ano
//  Compilar:  typst compile apunte.typ apunte.pdf
//  Vista viva: typst watch apunte.typ apunte.pdf
//
//  Parte I  (modulos 1 a 6)  : el temario y los TP de la catedra.
//  Parte II (modulos 7 a 15) : fundamentos de analisis de circuitos, en el
//                              orden de Teoria de Circuitos (UNSAM).
// =====================================================================

#import "plantilla.typ": *

#show: apunte.with(
  titulo: "Aplicaciones de Electrónica Analógica",
  subtitulo: "Apunte teórico-práctico de la materia, con los fundamentos de análisis de circuitos",
  institucion: "E.E.S.T. N.º 1 «Eduardo Ader» — Vicente López",
  catedra: "4.º Año — Ciclo Superior Técnico",
  ciclo: "Ciclo lectivo 2026",
)

// ---------------------------------------------------------------------
// Va antes de las dos partes y SIN numero de modulo: son los acuerdos que
// rigen todo el documento, no un tema. Ver `seccion` en plantilla.typ.
#include "modulos/convenciones.typ"

// ---------------------------------------------------------------------
#parte(1, "La materia y sus trabajos prácticos", [
  Los seis módulos de esta parte siguen el temario de la cátedra y el orden de las guías
  de trabajos prácticos: cada uno cierra con el TP que lo pone a prueba en el
  laboratorio. Se estudian *dispositivos* —el instrumento, la señal, el transformador, el
  diodo, la fuente, el transistor— y en cada caso se deduce la fórmula antes de usarla.

  Los módulos 4, 5 y 6 cubren, además, el hueco del apunte oficial de la cátedra, cuyas
  secciones sobre el diodo, el relé y el transistor bipolar son títulos sin contenido.
])

#include "modulos/m1-mediciones.typ"
#include "modulos/m2-senales.typ"
#include "modulos/m3-transformadores.typ"
#include "modulos/m4-diodos.typ"
#include "modulos/m5-fuentes.typ"
#include "modulos/m6-transistores.typ"

// ---------------------------------------------------------------------
#parte(2, "Fundamentos de análisis de circuitos", [
  La Parte I estudia dispositivos; esta estudia el *método*: cómo se plantea y se resuelve
  una red cualquiera, sin importar qué tenga adentro. El orden es el de la materia
  *Teoría de Circuitos* de la Ingeniería Electrónica de la UNSAM —leyes de Kirchhoff y
  resolución sistemática, teoremas, régimen transitorio, fasores y régimen permanente
  senoidal, diagramas de Bode y filtrado, cuadripolos, y el amplificador operacional con
  todas sus configuraciones—, que es la continuación natural de esta materia. Cierra con
  el simulador, que es el banco de pruebas de todo lo anterior: el único módulo que no
  agrega teoría nueva y sirve para contrastar la de los ocho anteriores.

  No hace falta haber leído la Parte I para leer ésta, pero las dos se cruzan
  permanentemente: cada módulo cierra explicando qué tema de la Parte I era, sin nombre,
  un caso particular de lo que se acaba de deducir.
])

#include "modulos/m7-kirchhoff.typ"
#include "modulos/m8-nodos-mallas.typ"
#include "modulos/m9-teoremas.typ"
#include "modulos/m10-transitorios.typ"
#include "modulos/m11-fasores.typ"
#include "modulos/m12-bode.typ"
#include "modulos/m13-cuadripolos-ao.typ"
#include "modulos/m14-operacional.typ"
#include "modulos/m15-simulacion.typ"

// ---------------------------------------------------------------------
#include "modulos/anexos.typ"
