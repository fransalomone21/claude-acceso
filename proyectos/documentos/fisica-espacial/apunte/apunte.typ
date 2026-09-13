// =====================================================================
//  Apunte de Física Espacial — UNSAM, Ing. en Sistemas Espaciales
//  Compilar:   typst compile apunte.typ apunte.pdf
//  Vista viva: typst watch apunte.typ apunte.pdf
//
//  ESTE ARCHIVO ES EL ÚNICO LUGAR DONDE VIVE EL ORDEN DE LOS MÓDULOS.
//  La prosa no escribe números de módulo: escribe `#M("clave")`, y el
//  número sale de acá. Mover un `#include` reordena el apunte entero sin
//  tocar una sola línea de texto, y una clave que no existe NO compila.
//  (Antes de 2026-09-13 había 355 números escritos a mano, que ningún
//  compilador podía ver.)
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
  Dos módulos, y son los que sostienen a los otros dieciocho. La materia entera
  se escribe con vectores, y dos de sus tres teoremas de conservación sólo son
  manejables en coordenadas polares — donde los versores giran con la partícula
  y la derivada de un vector tiene un término que en cartesianas no existe.

  El segundo módulo contesta la pregunta que el resto del apunte da por
  contestada sin decirlo: *desde dónde se está mirando*. Ahí van las tres leyes
  de Newton escritas, la definición de marco inercial, la transformación de
  Galileo —que es lo que autoriza a elegir el marco cómodo en cada problema— y
  las dos correcciones que hay que pagar cuando el marco elegido no es
  inercial: la de uno que acelera y la de uno que gira.

  Si algo de acá queda flojo, no se nota en esta parte: se nota tres partes más
  adelante, cuando la aceleración de una órbita no cierre y no se sepa por qué.
])

#include "modulos/m01-vectores.typ"
#include "modulos/m02-marcos.typ"

// ---------------------------------------------------------------------
#parte(2, "Los teoremas de conservación", [
  Tres teoremas, y los tres son la misma idea: cuando una simetría del problema
  hace que algo no pueda cambiar, ese algo sirve para resolverlo sin integrar la
  ecuación de movimiento. Acá van dos —cantidad de movimiento y energía—; el
  tercero, el del momento angular, espera a la Parte III porque no se entiende
  del todo hasta tener la gravitación delante.

  El orden no es caprichoso. La conservación de $bold(P)$ da el centro de masa;
  el centro de masa da el sistema en el que un choque se ve simétrico y en el
  que un cohete se piensa sin marearse —y que sea un sistema legítimo es la
  transformación de Galileo de la Parte I, no una licencia—; y el cohete es el
  primer sistema de masa variable de la carrera. La energía cierra la parte, y
  con ella queda armada la máquina —el diagrama de energía— que en la Parte III
  se aplica al potencial eficaz y decide, sin resolver ninguna ecuación
  diferencial, si una órbita es ligada o abierta.
])

#include "modulos/m03-cantidad-movimiento.typ"
#include "modulos/m04-centro-de-masa.typ"
#include "modulos/m05-cohete.typ"
#include "modulos/m06-trabajo-energia.typ"

// ---------------------------------------------------------------------
#parte(3, "Gravitación y mecánica orbital", [
  La materia entera apunta acá. Las herramientas ya están: los versores que
  giran de la Parte I, la definición de marco inercial que dice por qué «clavar
  el origen en la Tierra» no es gratis, la conservación de $bold(P)$ que dio el
  centro de masa, y sobre todo el diagrama de energía, que contesta preguntas
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

#include "modulos/m07-gravitacion.typ"
#include "modulos/m08-momento-angular.typ"
#include "modulos/m09-dos-cuerpos.typ"
#include "modulos/m10-orbita-conicas.typ"
#include "modulos/m11-kepler.typ"
#include "modulos/m12-maniobras.typ"

// ---------------------------------------------------------------------
#parte(4, "De la cónica al viaje real", [
  Esta parte continúa la anterior sin cambiar de objeto: el cuerpo sigue siendo
  un punto y la herramienta sigue siendo la cónica. Lo que cambia es cuánto se
  le pide. La Parte III resuelve *una* órbita alrededor de *un* cuerpo; acá se
  pregunta qué pasa cuando la órbita no se cierra, cuando hay más de un cuerpo
  atrayendo, y cuando el resultado tiene que entrar en una computadora.

  Los cuatro módulos siguen el orden de la pregunta que cada uno contesta.
  Primero la hipérbola, que es la trayectoria de la que no se vuelve y la forma
  de toda salida y toda llegada a un planeta. Después la esfera de influencia y
  las órbitas parcheadas, que son la licencia para resolver un viaje
  interplanetario como una sucesión de problemas de dos cuerpos —y lo que le
  faltaba al Hohmann de la Parte III para ser una misión y no una cuenta—.
  Después el marco perifocal y los coeficientes de Lagrange, que es cómo se
  escribe una órbita en vectores para dársela a una máquina. Y al final el
  problema restringido de tres cuerpos y los puntos de Lagrange, que es lo que
  aparece cuando la aproximación de dos cuerpos ya no alcanza — y donde se
  cobran, enteras, las dos fuerzas de inercia del módulo de marcos.
])

#include "modulos/m13-hiperbola.typ"
#include "modulos/m14-esfera-influencia.typ"
#include "modulos/m15-perifocal-lagrange.typ"
#include "modulos/m16-tres-cuerpos.typ"

// ---------------------------------------------------------------------
#parte(5, "Cuerpo rígido", [
  Hasta acá todo cuerpo fue un punto. Alcanzó para un viaje interplanetario
  entero, y deja de alcanzar apenas la pregunta cambia de *dónde está* un
  satélite a *hacia dónde apunta*: una antena, una cámara, un panel solar y un
  motor apuntan a algún lado, y ese lado hay que controlarlo. Por eso esta
  parte va última: no es que use lo anterior —casi no lo usa—, es que recién
  tiene sentido preguntarse hacia dónde apunta algo cuando ya se sabe dónde
  está.

  Los cuatro módulos van en el orden en que se necesitan las piezas. Primero la
  cinemática —cómo se describe la rotación, y sobre todo cómo se deriva un
  vector cuando el sistema desde el que se mira está girando, que es el caso
  general del que la Parte I dedujo la mitad—, y de esa herramienta dependen
  los otros tres. Después el momento de inercia, que en tres dimensiones deja
  de ser un número y pasa a ser un tensor, con la consecuencia que ordena toda
  la parte: el momento angular y la velocidad angular *no son paralelos*. Con
  esas dos cosas salen las ecuaciones de Euler y el giróscopo, y al final el
  movimiento libre de un cuerpo simétrico —la peonza—, que es el de cualquier
  satélite estabilizado por rotación al que se le apagó el último motor.
])

#include "modulos/m17-cinematica-cr.typ"
#include "modulos/m18-inercia.typ"
#include "modulos/m19-euler-giroscopo.typ"
#include "modulos/m20-peonza.typ"

// ---------------------------------------------------------------------
// #include "modulos/anexos.typ"
