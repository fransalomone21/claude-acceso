// =====================================================================
//  Apunte de Introducción a la Ingeniería de Sistemas Espaciales
//  UNSAM — Ingeniería en Sistemas Espaciales
//
//  Compilar:   typst compile apunte.typ apunte.pdf
//  Vista viva: typst watch apunte.typ apunte.pdf
//
//  ESTE ARCHIVO ES EL ÚNICO LUGAR DONDE VIVE EL ORDEN DE LOS MÓDULOS.
//  La prosa no escribe números de módulo: escribe `#M("clave")`, y el
//  número sale de acá. Una clave que no existe NO compila — por eso los
//  `#include` de los módulos que todavía no están escritos NO se dejan
//  comentados con referencias vivas apuntándoles.
//
//  El índice completo de los 26 módulos está en PDP.md §8. Acá sólo está
//  lo que ya existe: el archivo es el estado, no el plan.
// =====================================================================

#import "plantilla.typ": *

#show: apunte.with(
  titulo: "Introducción a la Ingeniería de Sistemas Espaciales",
  subtitulo: "Apunte general de la materia — del vocabulario controlado a la arquitectura de un sistema espacial",
  institucion: "UNSAM — Ingeniería en Sistemas Espaciales",
  catedra: "Cátedra Yasielski",
  ciclo: "Ciclo lectivo 2026",
)

// ---------------------------------------------------------------------
#seccion("Cómo se lee este apunte", [
  Explica por qué el glosario está al principio y no al final, qué significa
  cada color de caja, y cómo se citan las diapositivas de la cátedra.
])

Esta materia se rinde sobre *distinciones léxicas*. No se pregunta cómo se
calcula algo: se pregunta *qué es* algo, *cuáles son sus tipos* y *cuáles son
sus entregables* — y se corrige por la palabra exacta. Un ejemplo real, y es la
marca en rojo de un parcialito corregido: definir el proceso de desarrollo de
producto como «una lista de tareas, cronogramas e hitos» está *mal*, porque un
entregable es un *resultado* y no el procedimiento que lleva a él. La diferencia
entre la respuesta correcta y la corregida son dos palabras.

De ahí salen las tres decisiones que le dan forma a este apunte.

/ El glosario es el módulo 0: no es un anexo. Un glosario al final se consulta
  cuando ya se entendió mal. Acá va adelante, se lee primero, y todo lo demás
  se apoya en él. Cada término se define *una sola vez* y después se usa
  siempre igual; cuando aparece marcado #t[así], es un término del glosario.

/ Cada definición dice de dónde salió: la cita #diapo(1, 17) manda a la
  diapositiva real del PDF de la cátedra, la del número que se ve arriba en el
  visor. No es un detalle de prolijidad: es lo que deja volver a la fuente
  cuando el apunte y la memoria no coinciden.

/ Se distingue lo confirmado de lo reconstruido: cuando la frase está textual
  en la diapositiva, va como definición. Cuando el apunte completó algo que la
  diapositiva decía a medias —con el manual de INCOSE o el de NASA— lo dice en
  una caja aparte, para que nadie estudie como palabra de la cátedra algo que
  la cátedra no dijo.

#v(6pt)

*Qué NO es este apunte.* No reemplaza a las clases: las destila. Cada módulo
empieza diciendo qué clase y qué diapositivas cubre, y la caja gris de arriba
de todo dice qué vas a poder contestar al terminarlo. El significado de cada
color de caja está en la portada.

#posta[
  Si tenés poco tiempo, leé el módulo 0 entero y después las cajas rojas de
  todos los demás. El módulo 0 es el vocabulario y las rojas son los errores
  que la cátedra efectivamente marcó en parcialitos corregidos.
]

// ---------------------------------------------------------------------
#parte(0, "El vocabulario", [
  Un solo módulo, y es el más importante del apunte.

  En una materia donde dos palabras distintas son dos conceptos distintos, el
  vocabulario no es la puerta de entrada al contenido: *es* el contenido. Acá
  está cada término controlado con su definición canónica, la diapositiva de la
  que salió, y —la línea que más rinde— *con qué se confunde y en qué se
  distingue*. El error que se castiga casi nunca es no saber un término: es
  usarlo por otro.

  Se lee entero una vez, al principio, y después se vuelve. Los módulos que
  siguen no repiten estas definiciones: las usan.
])

#include "modulos/m00-glosario.typ"

// ---------------------------------------------------------------------
#parte(1, "Qué es la ingeniería de sistemas", [
  Tres módulos para contestar de dónde viene esta materia y por qué existe
  como disciplina separada.

  El primero ubica a la ingeniería entre la ciencia y la tecnología —tres
  actividades distintas, no tres sinónimos— y explica por qué la carrera se
  organiza con la metodología CDIO, que es la corrección de un desbalance
  concreto en la enseñanza de la ingeniería.

  El segundo define *proyecto* y el triángulo de hierro, y separa tres cosas
  que se confunden todo el tiempo: dirección de proyecto, ingeniería de
  sistemas y arquitectura de sistema.

  El tercero define la ingeniería de sistemas y la cuenta desde donde
  apareció: los misiles Nike, el Atlas, el SAGE y, sobre todo, el Apollo —que
  es donde la NASA la puso por escrito. No es historia de adorno: cada uno de
  esos programas aportó una pieza del método que se usa hoy.
])

#include "modulos/m01-ciencia-tecnologia-ingenieria.typ"
#include "modulos/m02-proyecto.typ"
#include "modulos/m03-que-es-la-ingenieria-de-sistemas.typ"
