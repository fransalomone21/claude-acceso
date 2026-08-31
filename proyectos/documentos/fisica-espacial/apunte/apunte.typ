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
#parte(2, "Los teoremas de conservación", [
  Tres teoremas, y los tres son la misma idea: cuando una simetría del problema
  hace que algo no pueda cambiar, ese algo sirve para resolverlo sin integrar la
  ecuación de movimiento. Acá van dos —cantidad de movimiento y energía—; el
  tercero, el del momento angular, espera al módulo 7 porque no se entiende del
  todo hasta tener la gravitación delante.

  El orden no es caprichoso. La conservación de $bold(P)$ da el centro de masa;
  el centro de masa da el sistema en el que un choque se ve simétrico y en el
  que un cohete se piensa sin marearse; y el cohete es el primer sistema de masa
  variable de la carrera. La energía cierra la parte, y con ella queda armada la
  máquina —el diagrama de energía— que en la Parte III se aplica al potencial
  eficaz y decide, sin resolver ninguna ecuación diferencial, si una órbita es
  ligada o abierta.
])

#include "modulos/m2-cantidad-movimiento.typ"
#include "modulos/m3-centro-de-masa.typ"
#include "modulos/m4-cohete.typ"
#include "modulos/m5-trabajo-energia.typ"

// ---------------------------------------------------------------------
#parte(3, "Gravitación y mecánica orbital", [
  La materia entera apunta acá. Las herramientas ya están: los versores que
  giran del módulo 1, la conservación de $bold(P)$ que dio el centro de masa,
  y sobre todo el diagrama de energía del módulo 5, que contesta preguntas
  sobre un movimiento sin resolver su ecuación.

  El orden de los seis módulos sigue el de las preguntas, no el de los libros.
  Primero la fuerza y su energía potencial, que ya alcanzan para las órbitas
  circulares y para saber si un cuerpo escapa o no. Después el momento angular,
  que es lo que hace que una órbita sea plana y que la segunda ley de Kepler
  sea una identidad. Recién entonces el problema de dos cuerpos —dónde está de
  verdad el centro— y la ecuación de la órbita, donde las cónicas dejan de ser
  un nombre y pasan a ser la solución. Kepler queda como consecuencia, y las
  maniobras como aplicación.
])

#include "modulos/m6-gravitacion.typ"
#include "modulos/m7-momento-angular.typ"
#include "modulos/m8-dos-cuerpos.typ"
#include "modulos/m9-orbita-conicas.typ"
#include "modulos/m10-kepler.typ"
#include "modulos/m11-maniobras.typ"

// ---------------------------------------------------------------------
#parte(4, "Cuerpo rígido", [
  Hasta acá todo cuerpo fue un punto. Alcanzó para una órbita entera, y deja
  de alcanzar apenas la pregunta cambia de *dónde está* un satélite a *hacia
  dónde apunta*: una antena, una cámara, un panel solar y un motor apuntan a
  algún lado, y ese lado hay que controlarlo.

  Los cuatro módulos van en el orden en que se necesitan las piezas. Primero
  la cinemática —cómo se describe la rotación, y sobre todo cómo se deriva un
  vector cuando el sistema desde el que se mira está girando—, que es la
  herramienta de la que dependen los otros tres. Después el momento de
  inercia, que en tres dimensiones deja de ser un número y pasa a ser un
  tensor, con la consecuencia que ordena toda la parte: el momento angular y
  la velocidad angular *no son paralelos*. Con esas dos cosas salen las
  ecuaciones de Euler y el giróscopo, y al final el movimiento libre de un
  cuerpo simétrico —la peonza—, que es el de cualquier satélite estabilizado
  por rotación al que se le apagó el último motor.
])

#include "modulos/m12-cinematica-cr.typ"
#include "modulos/m13-inercia.typ"
#include "modulos/m14-euler-giroscopo.typ"
// #include "modulos/m15-peonza.typ"

// ---------------------------------------------------------------------
// #include "modulos/anexos.typ"
