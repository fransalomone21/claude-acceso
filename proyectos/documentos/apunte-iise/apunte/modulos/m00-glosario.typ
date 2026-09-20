#import "../plantilla.typ": *

#modulo(
  "El léxico controlado",
  [Definir con la palabra de la cátedra cada término de las unidades 1 a 3, y
   —lo que de verdad se corrige— *distinguirlo del término con el que se
   confunde*. Al terminar, deberías poder contestar «qué es X» sin usar
   ninguna palabra que la cátedra no use, y explicar en una línea por qué X no
   es Y.],
  clave: "glosario",
)

#lectura[
  Este módulo destila las clases 1, 2 y 3 completas (186 diapositivas). Cada
  entrada cita su diapositiva; si una definición no cierra, esa cita es el
  camino más corto de vuelta al original.
]

Un término se define acá *una vez* y después se usa siempre igual. No se varía
«para que no quede repetitivo»: en esta materia dos palabras distintas son dos
conceptos distintos.

Cada entrada tiene la misma forma. La *definición* es la canónica, la que va en
el parcial. La *cita* dice de qué clase y de qué diapositiva salió. Y la línea
*no confundir con* dice cuál es el término vecino y en qué se distingue — es la
línea que más rinde, porque el error que la cátedra marca no es no saber el
término, es usarlo por otro.

== Las dos decisiones de vocabulario, antes que nada

No son preferencias de estilo: están contadas sobre las siete clases de la
materia. Donde la cátedra usa una palabra de manera abrumadora, el apunte usa
ésa y nada más.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header(
      [*Se dice*], [*No se dice*], [*Conteo en las 7 clases*],
    ),
    [requerimiento], [requisito],    [742 contra 8], // lexico-ok: es la tabla que declara el par
    [interesado],    [stakeholder],  [38 contra 5],  // lexico-ok: es la tabla que declara el par
    [diapositiva],   [slide, lámina], [decisión del apunte],
  ),
  caption: [El léxico de la cátedra, medido. La tercera fila es una convención propia del apunte, no de la cátedra.],
)

#posta[
  Si dudás entre dos palabras, usá la que aparece en la tabla de la izquierda.
  No hay caso en el que «requisito» sume algo que «requerimiento» no diga, y sí // lexico-ok: nombra la palabra que NO se usa
  hay corrector que lo note.
]

== Unidad 1 — qué es esto

=== sistema

#definicion("sistema")[
  Una combinación de elementos que interactúan, organizados para alcanzar un
  propósito establecido; un conjunto de entidades y sus relaciones, cuya
  funcionalidad es mayor que la suma de las entidades individuales.
  #diapo(1, 25) #diapo(2, 28)
]

*La prueba por el negativo*, que es la que se pregunta: un ladrillo *no* es un
sistema, porque es uniforme en su consistencia y no contiene entidades
#diapo(2, 28). Si no hay entidades que interactúen, no hay sistema.

#cuidado[
  *No confundir con un agregado.* Un montón de piezas sin relaciones
  funcionales entre ellas no es un sistema: no hay nada que emerja. La palabra
  que falta en esa definición equivocada es *interactúan*.
]

=== entidad (o elemento)

#definicion("entidad")[
  Los constituyentes del sistema: aquello en lo que el sistema se descompone y
  que mantiene relaciones con los demás. #diapo(2, 43)
]

*No confundir con* «parte» en el sentido de la jerarquía de NASA
(sistema #sym.arrow segmento #sym.arrow elemento #sym.arrow subsistema
#sym.arrow ensamble #sym.arrow subensamble #sym.arrow parte), donde *parte* es
el nivel más bajo y concreto. #t[entidad] es relativo al nivel que se esté
mirando: lo que es entidad para un nivel es sistema completo para el de abajo.

=== forma

#definicion("forma")[
  Lo que un sistema *es*: su encarnación física o informativa, que existe o
  tiene el potencial de existir. Tiene figura, configuración, disposición,
  _layout_. Durante un período de tiempo es estática y perseverante.
  #diapo(2, 40)
]

=== función

#definicion("función")[
  Lo que un sistema *hace*: las actividades, operaciones y transformaciones que
  causan, crean o contribuyen al desempeño. #diapo(2, 43)
]

#cuidado[
  *Forma y función se preguntan juntas, sobre un mismo ejemplo.* La regla corta
  para no cruzarlas: *forma = sustantivo; función = verbo*. El sistema
  digestivo tiene forma (los órganos) y función (digerir y asimilar los
  alimentos). Contestar «su función es el estómago» es el error típico.
]

=== proceso

#definicion("proceso")[
  La parte de la #t[función] que es pura acción o transformación, y por lo
  tanto la parte que *cambia el estado del* #t[operando]. #diapo(2, 43)
]

*No confundir con* #t[función], que es más amplia: la función incluye el
proceso *y* el operando sobre el que actúa. «Digerir» es el proceso; «digerir
alimentos» es la función.

=== operando

#definicion("operando")[
  El objeto que se transforma, o cuyo estado cambia. #diapo(2, 43)
]

=== proyecto

#definicion("proyecto")[
  Un conjunto de tareas relacionadas entre sí, con un objetivo común, que se
  completan dentro de ciertas especificaciones (*desempeño*), tienen fecha de
  inicio y de terminación (*planificación*) y fondos limitados (*costos*), y
  consumen recursos. #diapo(1, 16)
]

=== triángulo de hierro

#definicion("triángulo de hierro")[
  La representación de los tres ejes que el jefe de proyecto balancea
  —*desempeño* (_performance_), *planificación* (_schedule_) y *costos*— con el
  *riesgo* del proyecto en el centro. Es un triángulo _de hierro_ *si los tres
  están restringidos*. #diapo(1, 17)
]

#cuidado[
  *La cláusula que se pierde.* No es «los tres ejes de un proyecto»: es la
  condición de que *los tres estén restringidos a la vez*, porque recién ahí no
  se puede mejorar uno sin empeorar otro. Sin esa cláusula la respuesta
  describe cualquier proyecto, y no el triángulo de hierro.
]

=== ciencia · tecnología · ingeniería

#definicion("ciencia, tecnología e ingeniería")[
  *Ciencia:* sistemas teóricos de explicación de dominios fenoménicos;
  justificaciones; carácter descriptivo. #linebreak()
  *Tecnología:* control de procesos, control de la acción; actividad orientada
  al control de procesos. #linebreak()
  *Ingeniería:* reglas exitosas de transformación; actividad orientada a crear
  productos, sistemas y procesos. #diapo(1, 14)
]

*La relación, que es la segunda mitad de la pregunta:* son niveles distintos de
fundamentalidad, no sinónimos, y son actividades independientes entre sí aunque
estén fuertemente relacionadas. La ciencia *puede* existir sin tecnología ni
ingeniería; sin ciencia no hay tecnología ni ingeniería. Y hay realimentación:
la ingeniería avanzada produce tecnología que habilita nueva ciencia. Se
desarrolla en #M("cti").

=== ingeniería de sistemas

#definicion("ingeniería de sistemas (INCOSE)")[
  Un enfoque interdisciplinario y unos medios para permitir la realización de
  sistemas exitosos. Se focaliza en definir las necesidades del cliente y la
  funcionalidad requerida temprano en el ciclo de desarrollo, documentar los
  requerimientos, y proceder con la síntesis del diseño y la validación del
  sistema, considerando el problema *en su completitud*: operaciones, costos y
  planificación, desempeño, entrenamiento y soporte, ensayos, manufactura y fin
  de ciclo. #diapo(1, 27)
]

#cuidado[
  *No confundir con dirección de proyecto*, que son las tareas de *gestión*
  para la mejor utilización de los recursos #diapo(1, 21). La ingeniería de
  sistemas decide *qué sistema* y *cómo se descompone*; la dirección de
  proyecto administra *recursos, plazos y costos* para lograrlo. Se separan las
  tres en #M("proyecto").
]

=== CDIO

#definicion("CDIO")[
  Las cuatro fases del desarrollo de nuevos productos: *Concebir, Diseñar,
  Implementar, Operar*. #diapo(1, 7)
]

*Los antecedentes, que es lo que se pregunta:* proyectos fallidos y
semifallidos que despreciaron el *contexto del producto* y valoraron de más el
reduccionismo y la especialización. El desbalance del perfil del ingeniero
—exceso de ciencias de la ingeniería, déficit de práctica y de habilidades
interpersonales— producía pérdidas de tiempo y económicas. CDIO es la
corrección de ese desbalance. Se desarrolla en #M("cti").

== Unidad 2 — pensamiento de sistema y arquitectura

=== arquitectura de sistema

#definicion("arquitectura de sistema")[
  Una descripción abstracta de las #t[entidad]es de un sistema y de las
  relaciones entre esas entidades; el mapeo de la #t[función] a la #t[forma] a
  través del #t[concepto]; la asignación de la función física o informativa
  (#t[proceso]) a los elementos de la forma (objetos), y la definición de las
  interfaces estructurales entre esos objetos.
]

*Qué hace buena a una arquitectura* —la segunda mitad de la pregunta—: es fácil
de integrar, admite una evolución sostenida en el tiempo antes de quedar
obsoleta, es *lo menos ambigua posible* y tiene una descomposición óptima.
*Puede ser compleja; no puede ser confusa.*

*No confundir con* *diseño*. La arquitectura decide *qué entidades hay y cómo
se relacionan*; el diseño resuelve *cómo se construye cada una*.

=== concepto

#definicion("concepto")[
  Lo que relaciona la #t[función] con la #t[forma]. Es el puente: sin concepto
  no hay mapeo de una a la otra.
]

*El peso que tiene:* un buen concepto no garantiza el éxito del sistema, pero
*una mala elección del concepto casi con seguridad lo condena al fracaso*.

=== emergente (emergencia)

#definicion("emergente")[
  Lo que aparece, se materializa o emerge *cuando un sistema funciona*: se
  produce cuando la #t[función] de las entidades y su interacción funcional se
  combinan. Es la funcionalidad del todo que ninguna entidad tiene por
  separado.
]

*Depende de la estructura, no sólo de las piezas.* Con las mismas entidades y
otro patrón de conexión emerge otra cosa: el mismo resistor y el mismo
capacitor dan un filtro pasabajos o uno pasaaltos según cómo se conecten.

*Los cuatro tipos*, que es como se pregunta:

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([], [*Deseable*], [*No deseable*]),
    [*Anticipado*], [la función que se buscaba], [la falla prevista, con su mitigación planeada],
    [*No anticipado*], [la sinergia que aparece sola], [la que cuesta el sistema],
  ),
  caption: [Los cuatro tipos de emergente. El cuadrante de abajo a la derecha es el que justifica todo el método.],
)

*Los tres métodos para predecirlos:* *modelado* (modelos aproximados o
teóricos: físicos, matemáticos, simulaciones), *experiencia* (relacionar el
sistema y sus partes con sistemas pasados que comparten función, forma o
contexto) y *experimentación* (someter un prototipo o una versión temprana a
ensayos, para verificar requerimientos y detectar malfuncionamientos).

=== pensamiento holístico (holismo)

#definicion("pensamiento holístico")[
  El holismo sostiene que todas las cosas existen y actúan como conjuntos, y no
  sólo como la suma de sus partes; su sentido es el *opuesto al reduccionismo*.
  Pensar holísticamente es pensar deliberadamente sobre el todo: identificar
  *todas* las entidades y problemas que podrían ser importantes para el
  sistema. #diapo(2, 56)
]

*No confundir con* *enfoque*, que es el movimiento contrario y complementario:
reducir todo lo que generó el pensamiento holístico a la lista corta de lo que
es verdaderamente importante. *El holismo abre; el enfoque cierra.* Se usan los
dos, y en ese orden.

=== abstracción

#definicion("abstracción")[
  La expresión de la cualidad sin el objeto completo: una representación que
  conserva lo intrínseco y oculta el detalle innecesario.
]

=== límite del sistema

#definicion("límite del sistema")[
  Lo que delimita qué está dentro y qué está fuera del sistema; separa el
  sistema de su contexto. #diapo(2, 49)
]

=== relaciones formales y relaciones funcionales

#definicion("relaciones formales y funcionales")[
  Las *formales* son las que existen o podrían existir: la *estructura*. Las
  *funcionales* son las que *hacen algo* — implican operaciones, transferencias
  o intercambios entre las entidades: la *interacción*.
]

#cuidado[
  Dos entidades pueden estar formalmente conectadas y *no intercambiar nada*.
  Por eso la #t[tabla N²] tiene una versión para las #t[relaciones formales] y
  otra para las #t[relaciones funcionales], y no una sola.
]

=== las cuatro Tareas del pensamiento de sistema

#clave[
  + *Identificar* la #t[forma], las #t[entidad]es y la #t[función], y *crear el*
    #t[concepto] del sistema. Se usa el #t[pensamiento holístico]; es el momento
    de concebir y de reducir la #t[ambigüedad].
  + *Definir los límites* del sistema y separarlo del contexto.
  + *Reconocer las entidades*, sus #t[relaciones funcionales] y
    #t[relaciones formales], y las interfaces.
  + *Prever los* #t[emergente]s y el régimen de operación del sistema.
]

Se piensa todo como sistemas, subsistemas y suprasistemas.

=== tabla N² (diagrama N²)

#definicion("tabla N²")[
  Un artefacto de interfaces: los componentes o funciones del sistema se
  colocan *en la diagonal* de una matriz cuadrada de $N times N$, y las celdas
  representan las interfaces. *Las salidas van en las filas (horizontal); las
  entradas, en las columnas (vertical).* Donde la celda está en blanco, *no hay
  interfaz* entre esos dos.
]

*Lo que se pierde si no se dice:* existe en versión de tabla y en versión de
diagrama, y hay una para las #t[relaciones formales] y otra para las
#t[relaciones funcionales]. Un lazo de realimentación es un flujo bidireccional entre dos funciones,
y se ve como dos celdas simétricas ocupadas.

== Unidad 3 — el rol del arquitecto

=== rol del arquitecto

#definicion("rol del arquitecto")[
  *Resolver la* #t[ambigüedad], *enfocar la creatividad y simplificar la
  complejidad.* Los tres se centran en la *información*: identificar la
  información necesaria, coherente e importante reduciendo la ambigüedad;
  *agregar* información nueva a través de la creatividad; y *gestionar la
  explosión* de información hasta la arquitectura final.
]

=== arquitecto de sistemas

#definicion("arquitecto de sistemas")[
  El *especialista* en reducir la #t[ambigüedad] y elaborar el #t[concepto] del
  sistema, y en emplear su creatividad para obtener la mejor
  #t[arquitectura de sistema].
]

#cuidado[
  *No es «el ingeniero que sabe un poco de todo»: esa respuesta se corrige.* No
  es un generalista — es un *especialista* en una disciplina concreta:
  interpretar las partes y su suma como algo distinto del todo #diapo(1, 21).
]

=== ambigüedad

#definicion("ambigüedad")[
  En la práctica común, una combinación de información confusa, incertidumbre,
  información faltante, información conflictiva e información incorrecta.
  Contiene incógnitas conocidas e incógnitas desconocidas, además de
  suposiciones en conflicto y falsas.
]

*Sus dos ideas base:* *incertidumbre* (no se conoce el resultado de un evento)
y *confusión* (un mismo evento admite múltiples interpretaciones).

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Tipo de información*], [*Qué pasa*]),
    [desconocida],  [la información no está determinada o no está disponible],
    [conflictiva],  [dos o más piezas ofrecen indicaciones opuestas],
    [falsa],        [las entradas presentadas son incorrectas],
  ),
  caption: [Los tres tipos de información que producen ambigüedad.],
)

*Dónde es más aguda:* en la interfaz con las #t[influencias ascendentes], y la
razón es de una línea — *nadie diseña los procesos ascendentes*.

=== influencias ascendentes y descendentes

#definicion("influencias ascendentes y descendentes")[
  Las *ascendentes* son lo que le llega al #t[arquitecto de sistemas] desde
  antes de que se involucre: problemas, oportunidades, necesidades, estrategia,
  regulaciones. Las *descendentes*, lo que el sistema produce hacia abajo y
  hacia adelante. *Nadie diseña las ascendentes*, y por eso son la fuente
  principal de #t[ambigüedad].
]

=== entregables del arquitecto

#definicion("entregables del arquitecto")[
  El *resultado final, no el procedimiento por el cual se logra el estado.*
  Incluyen: un conjunto de objetivos claros, completos, consistentes y
  alcanzables; un #t[concepto] del sistema y de las funcionalidades de los
  subsistemas; una buena descomposición *de al menos dos niveles de
  profundidad*; una definición clara de las interfaces internas y externas;
  conceptos de operaciones; y una noción de costos, cronogramas y de las
  #t[influencias ascendentes].
]

#cuidado[
  *Ésta es la pregunta que más se corrige.* «Los entregables son muy diferentes
  de las tareas en que son el resultado final, no el procedimiento» — está
  textual en la clase. Responder enumerando *tareas* es el error que la cátedra
  marca. Y la descomposición lleva el número: *al menos dos niveles*, no «una
  buena descomposición».
]

=== PDP — proceso de desarrollo de producto

#definicion("PDP")[
  El *marco empresarial* que captura la metodología de desarrollo de productos
  —terminología, fases, hitos, cronogramas, listas de tareas y *resultados*—
  con la intención de capturar la sabiduría de los esfuerzos de desarrollo
  anteriores.
]

#cuidado[
  La marca en rojo del corrector, textual: *«resultados de procesos #sym.eq.not
  tareas»*. El PDP no es una lista de tareas: es el marco que las organiza y
  que define *qué resultado* produce cada fase. Definirlo como «una lista de
  tareas, cronogramas e hitos» es la respuesta que se corrige.
]

*Sus cuatro fases genéricas:* *concepción* (determinar qué se construirá, según
las necesidades del mercado y la tecnología disponible), *diseño* (la
representación del objeto de información que define qué se va a implementar),
*implementación* (convertir el diseño en realidad: código, fabricación,
integración) y *operaciones* (operar el sistema para entregar valor; terminan
en el *retiro*).

=== compuerta de control (control gate)

#definicion("compuerta de control")[
  El punto de decisión que habilita el *cambio de fase*.
]

*No confundir con* las *revisiones técnicas* (PDR, CDR, SRR…), que son los
eventos donde se evalúa, ni con los *KDP* de NASA, que son los puntos de
decisión del ciclo de vida.

=== principio de ambigüedad

#definicion("principio de ambigüedad")[
  «La fase inicial de un diseño de sistema se caracteriza por una gran
  #t[ambigüedad]. El #t[arquitecto de sistemas] debe resolver esta ambigüedad
  para producir —y actualizar continuamente— los objetivos del equipo del
  arquitecto.»
]

=== las preguntas W canónicas

#clave[
  Los siete atributos del producto o sistema: *por qué* (necesidad u
  oportunidad), *qué* (metas y desempeño), *cómo* (función e interacción),
  *dónde* (forma y estructura), *cuándo* (comportamiento y dinámica), *quién*
  (operador y usuario) y *cuánto* (costo y gasto).
]

#v(8pt)

#posta[
  Las unidades 4 a 7 todavía no están en este glosario: entran a medida que se
  escriben sus módulos, para que ningún término aparezca acá antes de estar
  verificado contra su clase. Lo que falta: sistema de sistemas, niveles de
  sistema, la familia del *requerimiento*, márgenes, las siete palabras del
  alcance, verificación y validación, interfaces e ICD/IDD, los modelos de
  ciclo de vida y los métodos de creación de arquitecturas.
]
