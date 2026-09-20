#import "../plantilla.typ": *

#modulo(
  "Ciencia, tecnología e ingeniería, y por qué la carrera se llama CDIO",
  [Distinguir las tres actividades sin confundirlas y explicar cómo se
   relacionan; describir la actividad del ingeniero como satisfacción de
   necesidades de un cliente; y contar qué desbalance concreto vino a corregir
   la iniciativa CDIO, con sus cuatro categorías de competencias.],
  clave: "cti",
)

#lectura[
  Clase 1, diapositivas 7 a 15. Las fuentes que la cátedra cita ahí son
  Dettmer (_Ciencia, tecnología e ingeniería_) y Jaramillo Patiño (_Formación
  en diseño de ingeniería y la iniciativa CDIO_).
]

== Tres actividades, no tres sinónimos

La primera distinción de la materia es también la que más se dice mal en el
lenguaje corriente, donde «ciencia» y «tecnología» se usan casi como una sola
palabra. La cátedra las separa desde la diapositiva 14 de la primera clase, y
las separa por su *fin*: cada una es una actividad de la racionalidad humana
definida por lo que busca, y las tres tienen igual importancia.

#definicion("ciencia, tecnología e ingeniería")[
  *Ciencia:* sistemas teóricos de explicación de dominios fenoménicos.
  Justificaciones. Carácter *descriptivo*. #linebreak()
  *Tecnología:* control de procesos, control de la acción. Actividad orientada
  al *control* de procesos. #linebreak()
  *Ingeniería:* reglas exitosas de transformación. Actividad orientada a
  *crear* productos, sistemas y procesos. #diapo(1, 14)
]

Las tres están relacionadas fuerte e íntimamente, *pero son independientes
entre sí*. Ésa es la parte que se responde mal: la relación no es que una sea
la aplicación de la otra.

#posta[
  La ciencia *explica*, la tecnología *controla*, la ingeniería *crea*. Si la
  pregunta es «¿qué hace?», el verbo ya contesta cuál de las tres es.
]

=== Cómo se relacionan, que es la segunda mitad de la pregunta

Son niveles distintos de fundamentalidad. La ciencia puede existir sin
tecnología ni ingeniería —la astronomía antigua es ciencia sin ninguna de las
otras dos—, pero no hay tecnología ni ingeniería sin ciencia detrás. Y la
relación no va en un solo sentido: la ingeniería avanzada produce tecnología
que habilita ciencia que antes no se podía hacer. Un telescopio espacial es
ingeniería que abre un dominio fenoménico nuevo.

#deduccion("por qué la cátedra insiste con esto")[
  Porque la materia entera es sobre *crear*, no sobre explicar. Cuando más
  adelante aparezca que «el diseño es un acto puro de la mente caracterizado
  por la creatividad» #diapo(1, 14), eso sólo tiene sentido si antes quedó
  claro que la ingeniería no es ciencia aplicada: tiene un fin propio.
]

== La actividad del ingeniero

La cátedra la describe como una cadena corta, y conviene aprenderla como
cadena porque cada eslabón es un tema de la materia #diapo(1, 15):

+ Hay un *cliente* y hay *interesados* con necesidades de un producto o de un
  sistema.
+ Esas necesidades se satisfacen a través de un #t[proyecto], que permite
  alcanzar metas u objetivos exitosamente.
+ Todo eso es una *cultura de satisfacción de necesidades*: del cliente o del
  mercado, de los requerimientos de un producto, de un artefacto, de un
  sistema.

#clave[
  El punto de partida no es una idea técnica: es una *necesidad*. La materia se
  organiza alrededor de esa inversión —primero el problema del cliente, después
  la solución— y es la misma inversión que hace la #t[ingeniería de sistemas]
  cuando define las necesidades del cliente *temprano* en el ciclo de
  desarrollo.
]

La cita que la cátedra elige para cerrar esto vale por su incomodidad: «la
ingeniería se encuentra más cercana en naturaleza y semejanza a las ciencias de
la cultura que de las ciencias naturales» #diapo(1, 15). Un sistema espacial no
fracasa sólo por física: fracasa por necesidades mal entendidas, por
organizaciones, por comunicación.

== CDIO: qué desbalance vino a corregir

#definicion("CDIO")[
  Las cuatro fases del desarrollo de nuevos productos: *Concebir, Diseñar,
  Implementar y Operar*. #diapo(1, 7)
]

Lo que se pregunta no es la sigla —eso se sabe en diez segundos— sino *de dónde
salió*. Y salió de un problema medido, no de una moda pedagógica.

=== La historia, en cuatro pasos

#figure(
  table(
    columns: (0.55fr, 2fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Momento*], [*Qué pasó*]),
    [Posguerra],
    [La mayoría de los profesores de ingeniería de las universidades norteamericanas *venían de la industria*, y llevaron a sus clases las necesidades prácticas.],
    [Con el tiempo],
    [Las universidades se centraron cada vez más en la *investigación básica*, y los aspectos científicos se impusieron en los planes de estudio.],
    [El resultado],
    [La ingeniería se convirtió en *la enseñanza de las ciencias de la ingeniería*. Se descuidó el trabajo de las capacidades personales e interpersonales.],
    [La corrección],
    [CDIO acentúa esas capacidades *sin disminuir* el aprendizaje de las competencias específicas de la disciplina.],
  ),
  caption: [Cómo se abrió el vacío entre lo que la industria necesitaba y lo que la universidad enseñaba #diapo(1, 8).],
)

#cuidado[
  La última fila es la que se olvida al responder. CDIO *no* propone enseñar
  menos ciencia: propone agregar lo que faltaba. Contestar que «CDIO reemplaza
  las ciencias de la ingeniería por la práctica» invierte el sentido de la
  iniciativa.
]

=== La transformación cultural, en dos columnas

La diapositiva 10 lo pone como un antes y un después, y es probablemente la
forma más compacta de recordarlo:

#figure(
  table(
    columns: (1fr, 1fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Hasta ahora*], [*Lo deseado (esta carrera)*]),
    [Ciencias de la ingeniería], [*Hacer* ingeniería],
    [Contexto de I+D],           [Contexto de *producto*],
    [Reduccionista],             [Integrante],
    [Individual],                [Equipo],
  ),
  caption: [La transformación cultural que propone CDIO #diapo(1, 10).],
)

La segunda fila reaparece en toda la materia: *contexto de producto* es lo que
obliga a pensar en operaciones, costos, retiro y usuarios, y no sólo en que el
artefacto funcione.

=== Las cuatro categorías de competencias

Todos los centros adscriptos al programa CDIO incorporan obligatoriamente estas
cuatro en sus planes de estudio #diapo(1, 11):

+ Conocimiento técnico y razonamiento.
+ Competencias y atributos personales y profesionales.
+ Competencias interpersonales: trabajo en equipo y comunicación.
+ Concebir, diseñar, implementar y operar sistemas *en el contexto de la
  empresa y la sociedad*.

#clave[
  Notá que sólo la primera es «lo técnico». Las otras tres son exactamente lo
  que el diagnóstico decía que se había descuidado — las competencias y la
  estructura del plan de estudios son la misma decisión vista de los dos lados.
]

=== Cómo se aplica en esta carrera

La progresión no es caprichosa: cada año cubre más fases de CDIO, para que el
alumno llegue al final del recorrido habiendo pasado por las cuatro
#diapo(1, 12).

#figure(
  table(
    columns: (0.8fr, 2fr, 0.7fr),
    align: (left, left, center),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Materia*], [*Foco del contenido*], [*Fases CDIO*]),
    [IISE (esta materia)],
    [Curso de introducción. Necesidades del cliente; actividades básicas de creación y diseño.],
    [C, algo de D],
    [Proyecto Integrador 1],
    [Habilidades creativas y disciplina del diseño.],
    [C, algo de D, I, O],
    [Proyecto Integrador 2],
    [Diseño y fabricación, con prototipos de grupo.],
    [C, D, algo de I y O],
    [Proyecto Integrador 3],
    [Gestión de proyecto interdisciplinario.],
    [C, D, I, algo de O],
    [Proyecto Integrador 4],
    [Diseño y análisis de ingeniería.],
    [C, D, I, O],
  ),
  caption: [La secuencia CDIO a lo largo de la carrera. Esta materia es el primer escalón: concebir.],
)

#posta[
  Esta materia es la *C* de CDIO. Por eso se pasa tanto tiempo en necesidades,
  alcance, requerimientos y arquitectura, y casi nada en construir: lo que se
  está aprendiendo es a decidir *qué* construir antes de construirlo.
]
