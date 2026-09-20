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

// ---------------------------------------------------------------------
#parte(2, "Pensamiento sistémico y arquitectura", [
  Cuatro módulos para pasar de "qué es un sistema" a "cómo se piensa un
  sistema" — el vocabulario más denso del apunte, porque es el que se usa
  en el resto de la materia.

  El primero define arquitectura de sistema y por qué las decisiones
  tempranas pesan tanto, con NPOESS como el caso de una mala decisión y
  Boeing 787 como el de una apuesta de alto riesgo bien pensada.

  El segundo desarrolla la Tarea 0 del pensamiento sistémico: qué es un
  sistema (con la prueba del ladrillo) y qué es lo emergente, con sus cuatro
  tipos.

  El tercero cubre las Tareas 1 y 2: forma y función con la regla
  sustantivo/verbo, y cómo encontrar las entidades de un sistema con
  holismo, enfoque y abstracción.

  El cuarto cierra con las Tareas 3 y 4: relaciones formales y funcionales,
  la tabla N² —con el ejemplo completo del circuito amplificador—, y los
  tres métodos para predecir lo emergente, con el aterrizaje del A320 en
  Varsovia como el caso de una falla que "funcionó como se diseñó".
])

#include "modulos/m04-arquitectura-de-sistemas.typ"
#include "modulos/m05-pensamiento-de-sistema-y-emergentes.typ"
#include "modulos/m06-forma-funcion-entidades.typ"
#include "modulos/m07-relaciones-n2-emergentes.typ"

// ---------------------------------------------------------------------
#parte(3, "El rol del arquitecto", [
  Tres módulos sobre lo que hace el arquitecto entre que le llega la
  ambigüedad ascendente y entrega sus resultados.

  El primero enuncia los tres roles —reducir ambigüedad, emplear
  creatividad, gestionar complejidad— y los entregables concretos que
  produce cada uno.

  El segundo abre la ambigüedad misma: borrosidad e incertidumbre no son lo
  mismo, y la información puede faltar, contradecirse o ser directamente
  falsa. Cierra con por qué nadie diseña las influencias ascendentes.

  El tercero compara cuatro procesos de desarrollo de producto reales —NASA,
  una fabricante de helicópteros, una de cámaras, Agile— para separar lo
  superficial de lo sustancial, y arma el PDP genérico de cuatro fases que
  resulta ser, letra por letra, el mismo CDIO de la unidad 1.
])

#include "modulos/m08-rol-del-arquitecto.typ"
#include "modulos/m09-la-ambiguedad.typ"
#include "modulos/m10-el-pdp.typ"

// ---------------------------------------------------------------------
#parte(4, "La necesidad de la Ingeniería de Sistemas", [
  Cuatro módulos que dejan el vocabulario de lado y muestran la disciplina
  en casos reales — de éxitos y de fracasos.

  El primero arranca con dos ejemplos: el margen extra del Saturno V, que
  hizo posible el Apollo, y la falla del espejo del Hubble, que muestra que
  cada disciplina puede trabajar bien y el sistema fallar igual.

  El segundo define sistema de sistemas (SoS) y recorre la Estación
  Espacial Internacional como el caso real: seis centros de control, seis
  naves de transporte, ninguno con el mismo dueño.

  El tercero recorre el proceso completo, de la necesidad a la operación,
  en dos ejemplos: el Space Shuttle (con catorce familias de conceptos
  propuestos antes de elegir uno) y un rover marciano nuevo.

  El cuarto cierra con dos fracasos —el puente de Tacoma, el satélite
  espía FIA— y con el modelo formal que existe para que no se repitan: el
  motor de la ingeniería de sistemas de NASA, con sus 17 actividades.
])

#include "modulos/m11-la-necesidad-de-la-is.typ"
#include "modulos/m12-sistema-de-sistemas-y-la-iss.typ"
#include "modulos/m13-el-proceso-de-punta-a-punta.typ"
#include "modulos/m14-el-motor-de-la-is-nasa.typ"

// ---------------------------------------------------------------------
#parte(5, "Ciclo de vida, requerimientos, márgenes y alcance", [
  Cuatro módulos que dejan el vocabulario más denso de requerimientos de
  toda la materia, y cumplen dos promesas que las unidades anteriores
  dejaron abiertas: desarrollar la verificación y validación a fondo, y
  desarrollar la gestión de márgenes.

  El primero recorre las siete fases del ciclo de vida de NASA y el
  diagrama en V, con sus tres perspectivas —cliente, ingeniería de
  sistemas, contratista— y la misma lógica aplicada al desarrollo de
  software.

  El segundo define qué es un requerimiento, contrasta un caso mal escrito
  (el Mars Climate Orbiter, perdido por una confusión de unidades) con uno
  bien escrito (el DC-3, en tres páginas), y desarrolla la gestión de
  márgenes que el margen del Saturno V dejó pendiente en la unidad 4.

  El tercero cubre la semántica shall/will/should, los cinco tipos de
  requerimientos con el ejemplo del TVC, y seis niveles de trazabilidad con
  el radar de acople del Apollo — cerrando con la interfaz física entre el
  Módulo de Comando y el Módulo Lunar.

  El cuarto desarrolla a fondo la diferencia entre verificar y validar, con
  la cámara de vacío térmico del Johnson Space Center como el caso de
  verificación ambiental, y cierra con los siete elementos del alcance y el
  Concepto de Operación, aplicados enteros al Crew Exploration Vehicle.
])

#include "modulos/m15-ciclo-de-vida-y-diagrama-en-v.typ"
#include "modulos/m16-que-es-un-requerimiento-y-margenes.typ"
#include "modulos/m17-familia-de-requerimientos-y-trazabilidad.typ"
#include "modulos/m18-verificacion-validacion-y-alcance.typ"
