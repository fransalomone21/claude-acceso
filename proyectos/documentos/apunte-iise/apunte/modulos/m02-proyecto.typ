#import "../plantilla.typ": *

#modulo(
  "Proyecto, triángulo de hierro, y las tres actividades que se confunden",
  [Definir *proyecto* con sus cinco cláusulas; explicar por qué el triángulo es
   «de hierro» sólo bajo una condición; distinguir investigación de desarrollo;
   y separar dirección de proyecto, ingeniería de sistemas y arquitectura de
   sistema — que son tres cosas distintas y se preguntan juntas.],
  clave: "proyecto",
)

#lectura[
  Clase 1, diapositivas 16 a 21. La fuente de la cátedra para todo este tramo
  es el curso ESD.36 _System Project Management_ del MIT.
]

== Qué es un proyecto

#definicion("proyecto")[
  Un #t[proyecto] es un conjunto de *tareas relacionadas unas con otras*, que
  tienen un *objetivo común*, para ser completadas dentro de ciertas
  *especificaciones* (desempeño), que tienen *definida una fecha de inicio y
  una de terminación* (planificación), que tienen *fondos limitados* (costos) y
  que *consumen recursos*. #diapo(1, 16)
]

La definición viene con los tres ejes adentro, y conviene verlo porque es lo
que hace que el triángulo de hierro no sea un agregado posterior sino la misma
definición dibujada:

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*La cláusula de la definición*], [*El eje que le corresponde*]),
    [dentro de ciertas especificaciones], [*desempeño* (_performance_)],
    [fecha de inicio y de terminación],   [*planificación* (_schedule_)],
    [fondos limitados],                   [*costos* (_cost_)],
  ),
  caption: [Las tres cláusulas restrictivas de la definición de proyecto son los tres vértices del triángulo.],
)

#cuidado[
  Un conjunto de tareas *sin* objetivo común no es un proyecto; una actividad
  permanente *sin* fecha de terminación tampoco. Las cláusulas no son adorno de
  la definición: son lo que la hace discriminar.
]

== El triángulo de hierro

#definicion("triángulo de hierro")[
  La representación de los tres ejes que el jefe de proyecto balancea
  —*desempeño*, *planificación* y *costos*— con el *riesgo* del proyecto en el
  centro. Es un triángulo *de hierro* si los tres están restringidos.
  #diapo(1, 17)
]

#align(center)[
  #fig-triangulo-hierro()
]
#align(center)[
  #text(size: 9pt, fill: c-libro)[Figura — El triángulo de hierro, con el riesgo en el centro #diapo(1, 17).]
]

#v(6pt)

#cuidado[
  *La cláusula condicional es la respuesta.* «¿Es un triángulo de hierro?» es
  literalmente la pregunta con la que la cátedra titula la diapositiva, y la
  respuesta es: *lo es si los tres están restringidos*. Recién ahí no se puede
  mejorar uno sin empeorar otro. Si sobra plata, o la fecha es flexible, hay
  triángulo pero no es de hierro. Describir «los tres ejes de un proyecto» sin
  esa condición describe cualquier proyecto.
]

La autoridad máxima del proyecto —el *jefe de proyecto*— es quien balancea esas
tres variables, *dirigiendo y controlando el riesgo* #diapo(1, 18). El riesgo
está en el centro porque no es un cuarto eje: es lo que aparece cuando se
aprieta cualquiera de los tres.

#posta[
  Barato, rápido, bueno: elegí dos. El triángulo de hierro es esa frase dicha
  con el vocabulario de la materia, y con el agregado de que lo que se paga por
  forzar los tres a la vez se llama *riesgo*.
]

== Investigación no es desarrollo

Una distinción corta que la cátedra hace para acotar de qué se ocupa la
materia, y que se pregunta porque separa dos mundos con métodos distintos
#diapo(1, 20):

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([], [*Investigación y desarrollo de tecnología*], [*Desarrollo de producto o sistema*]),
    [Métodos],       [no estructurados],    [estructurados],
    [Planificación], [difícil de planificar], [generalmente planeados],
    [Resultado],     [no predecible],       [predecible],
  ),
  caption: [Las dos mitades de «I+D», y por qué no se gestionan igual.],
)

#clave[
  *El foco de esta materia es el desarrollo de producto o sistema*, la columna
  de la derecha. Eso es lo que justifica que todo lo que viene después —fases,
  compuertas de control, requerimientos, verificación— suponga un proceso
  planificable. Aplicarle el mismo aparato a la investigación es un error de
  encuadre, no de ejecución.
]

== Las tres actividades que se confunden

Ésta es la diapositiva más densa de la clase 1 y la que más rinde tenerla
ordenada, porque las tres palabras aparecen juntas todo el tiempo y nombran
cosas distintas #diapo(1, 21).

#figure(
  table(
    // Fracciones explícitas, NO `auto`: con `auto` la tercera columna (que
    // tiene el texto más largo) se come el ancho y la segunda queda en una
    // letra por renglón. Pasó, se vio en la página compilada, y es
    // exactamente lo que la regla propia 4 existe para atrapar.
    columns: (0.9fr, 1.5fr, 1.4fr),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Actividad*], [*De qué se trata*], [*Herramientas típicas*]),
    [*Dirección de proyecto*],
    [Tareas de *gestión* para la mejor utilización de los recursos en los procesos de ingeniería de sistemas, para implementar el conjunto de objetivos.],
    [CPM, DSM, dinámica de sistemas],
    [*Ingeniería de sistemas*],
    [Procesos y herramientas que habilitan la implementación exitosa de la arquitectura: *entender y diseñar* el sistema.],
    [Tabla N², QFD, selección de conceptos, análisis y verificación de requerimientos, diagramas de flujo funcional, diseño robusto],
    [*Arquitectura de sistema*],
    [El «ADN» de los artefactos propiamente dichos: *cómo está organizado* el producto.],
    [Concepto, forma, función, descomposición],
  ),
  caption: [Las tres actividades, con las herramientas que las distinguen. La arquitectura de sistema es una *función* de la ingeniería de sistemas.],
)

#clave[
  La relación entre las tres, en una línea: la *arquitectura de sistema* es una
  función de la *ingeniería de sistemas*, y la *dirección de proyecto* es lo
  que administra los recursos para que esa ingeniería ocurra. No son tres
  niveles jerárquicos de mando: son tres preguntas distintas — *cómo se
  organiza el producto*, *cómo se diseña el sistema*, *cómo se usan los
  recursos*.
]

#cuidado[
  *El ingeniero de sistemas es un especialista, no un generalista* — la frase
  está textual en la diapositiva #diapo(1, 21), y es la misma corrección que
  aparece cuando se pregunta por el #t[arquitecto de sistemas]. Su
  especialidad es el todo: interpretar las partes y su suma como algo distinto
  de la suma. Los *ingenieros especialistas* del otro tipo —civiles, mecánicos,
  estructuralistas, mecatrónicos, eléctricos, electrónicos, térmicos— son los
  que aportan cada disciplina.
]

#deduccion("por qué la cátedra cita tres cursos distintos del MIT")[
  Porque en el MIT son tres materias separadas: ESD.36 para dirección de
  proyecto, ESD.33 para ingeniería de sistemas y ESD.34 para arquitectura de
  sistema. Esa separación institucional es evidencia de que la distinción no es
  una sutileza de vocabulario: son tres cuerpos de conocimiento con
  herramientas propias.
]

== Cómo se ve un proyecto de punta a punta

La diapositiva 19 muestra el ciclo de la *dirección de proyecto de sistema*, y
vale tenerlo como mapa mental de lo que se va a desarmar en el resto de la
materia. Arranca cuando *la empresa ya eligió qué producto o sistema va a
desarrollar*, y de ahí sigue: preparación del proyecto, planificación,
adaptación, monitoreo, control, aprendizaje, y proyecto terminado — que
alimenta al próximo proyecto.

#clave[
  Dos cosas del ciclo que después vuelven. La primera: la decisión de *qué* se
  desarrolla es anterior al ciclo, no parte de él — por eso la materia dedica
  unidades enteras a necesidades y alcance. La segunda: el *aprendizaje del
  proyecto* alimenta al próximo, que es exactamente la intención del #t[PDP]
  cuando captura «la sabiduría de los esfuerzos de desarrollo anteriores».
]
