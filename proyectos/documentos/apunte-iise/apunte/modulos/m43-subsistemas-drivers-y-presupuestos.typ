#import "../plantilla.typ": *

#modulo(
  "Subsistemas, drivers y presupuestos: el satélite como compromiso",
  [Distinguir un requerimiento de una especificación; nombrar los
   subsistemas de un _spacecraft_ con sus funciones y sus otros nombres;
   leer la tabla de _drivers_ del sistema (qué limita a cada uno y qué
   limita él); explicar el dilema costo-riesgo-desempeño; comparar las
   fases de ESA, NASA y DoD; y armar los presupuestos con que se sigue cada
   recurso.],
  clave: "subsistemas-drivers-y-presupuestos",
)

#lectura[
  Clase 11 B, diapositivas 24 a 36. Las láminas 25 a 36 están en inglés;
  las traducciones son del apunte.
]

== Requerimiento no es especificación

#figure(
  table(
    columns: (1fr, 1fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    inset: 5pt,
    table.header([*Requerimientos: qué tiene que hacer*], [*Especificaciones: cómo está hecho*]),
    [las funciones que debe realizar], [de qué está hecha la forma: materiales, dimensiones totales],
    [cuán bien debe realizarlas], [esquemáticos, planos],
    [el grado de automatización (las operaciones)], [la interfaz de usuario],
    [la compatibilidad con otros artefactos], [],
    [_«que entre un plato grande», «1200 W para calentar rápido una comida», «modos para arroz, pizza, carne congelada»_], [_«exterior de acero inoxidable», «24″ × 14″ × 19″», «30 kg», «garantía de un año»_],
  ),
  caption: [Requerimientos contra especificaciones, con lo que parece un microondas #diapo("11 B", 24).],
)

#definicion("especificación")[
  La descripción de *cómo está construido* el sistema y cómo trabaja:
  materiales, dimensiones, esquemáticos y planos, interfaz de usuario
  #diapo("11 B", 24).
]

#clave[
  El requerimiento lo escribe el que *necesita*; la especificación, el que
  *construye*. Es la regla de «libre de implementación» del checklist de la
  unidad 6, vista desde el otro lado: si un requerimiento dice «de acero
  inoxidable», se coló una especificación. Y al revés: la hoja de datos de
  un proveedor es una especificación, y para saber si sirve hay que
  compararla con *tus* requerimientos. La clase 12 lo hace con un tanque
  (módulo #M("fase-d-a-fondo")).
]

== Los subsistemas de un _spacecraft_

#figure(
  table(
    columns: (1.25fr, 2.6fr, 1.6fr),
    align: (left, left, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header([*Subsistema*], [*Funciones principales*], [*Otros nombres*]),
    [Propulsión], [empuje para ajustar la órbita y la actitud, y para gestionar el momento angular], [RCS],
    [Determinación y control de actitud (ADCS)], [determinar y controlar la actitud y la posición orbital; apuntar el satélite y sus apéndices], [ACS, GN&C, sistema de control],
    [Comunicaciones], [comunicarse con tierra y con otros satélites; el seguimiento (_tracking_)], [TT&C],
    [Comando y manejo de datos (C&DH)], [procesar y distribuir comandos; procesar, almacenar y formatear datos], [CDS, computadora del satélite],
    [Térmico], [mantener los equipos dentro de sus rangos de temperatura], [ECS],
    [Potencia], [generar, almacenar, regular y distribuir la potencia eléctrica], [EPS],
    [Estructuras y mecanismos], [la estructura de soporte, el adaptador al lanzador y las partes móviles], [subsistema estructural],
  ),
  caption: [Las definiciones de los subsistemas #diapo("11 B", 25).],
)

#notacion[
  Un mismo subsistema tiene tres o cuatro nombres según el libro, la
  agencia o la empresa: el control de actitud aparece como ADCS, ACS, AOCS
  (en los SAC del módulo #M("ait-de-un-subsistema")) o GN&C. No son cosas
  distintas, y la tabla está justamente para no perderse. En el trabajo
  práctico: elegí un nombre por subsistema y usalo siempre igual.
]

El satélite se parte primero en dos: la #t[carga útil], que es la razón
de la misión (antenas y transpondedor en uno de comunicaciones, un
radiómetro de muy alta resolución en uno meteorológico, un escáner
multiespectral en uno de recursos terrestres), y la *plataforma* o _bus_,
que la sostiene: control de actitud (sensores, actuadores de torque,
almacenamiento de momento angular), propulsión (inyección y corrección de
órbita), control térmico (recubrimientos, aislación, control activo),
potencia (celdas solares, baterías, electrónica de control), estructura
(estructura principal, mecanismos de despliegue) y telemetría y comando
(codificador, decodificador) #diapo("11 B", 26). La jerarquía lo resume en
dos niveles: _spacecraft_ → carga útil y _bus_ → los siete subsistemas
#diapo("11 B", 31). El ejemplo dibujado es la Magellan, la misión de NASA
y JPL que mapeó Venus con radar entre 1989 y 1994 #diapo("11 B", 27).

== Los _drivers_ del sistema

#definicion("drivers del sistema")[
  Los parámetros que más condicionan el diseño de un _spacecraft_, cada uno
  con *lo que lo limita* y *lo que él limita* #diapo("11 B", 28)
  #diapo("11 B", 29).
]

#figure(
  table(
    columns: (1fr, 1.6fr, 2.1fr),
    align: (left, left, left),
    stroke: 0.4pt + luma(180),
    inset: 4pt,
    table.header([*Driver*], [*Lo limita*], [*Él limita*]),
    [Tamaño], [la cofia o la bodega; el peso disponible; la resistencia aerodinámica], [el tamaño de la carga útil (sobre todo el diámetro de antena o la apertura)],
    [Peso en órbita], [la altitud, la inclinación, el lanzador], [el peso de la carga útil y la supervivencia; define en gran parte el diseño y el costo de fabricación],
    [Potencia], [el tamaño y el peso (el control es secundario)], [el diseño de la carga útil y del _bus_, la sensibilidad del sistema, la vida en órbita],
    [Tasa de datos], [el almacenamiento, el procesamiento, el tamaño de antena, los límites de los sistemas existentes], [la información que llega al usuario; puede pedir procesamiento a bordo],
    [Comunicaciones], [la cobertura; las estaciones terrenas o satélites de retransmisión disponibles], [la cobertura, la oportunidad y la capacidad de comandar],
    [Apuntamiento], [el costo, el peso], [la resolución, la geolocalización, la precisión del sistema; empuja el costo],
    [Cantidad de satélites], [el costo], [la frecuencia de cobertura y el solapamiento],
    [Altitud], [el desempeño del lanzador, el peso], [el desempeño, la supervivencia, la cobertura, las comunicaciones],
    [Cobertura (geometría y tiempo)], [la órbita, el _scheduling_, el campo de visión y el tiempo de observación], [la frecuencia y continuidad de los datos; las maniobras],
    [_Scheduling_], [la línea de tiempo y las operaciones, la toma de decisiones, las comunicaciones], [la cobertura, la respuesta, la utilidad de la misión],
    [Operaciones], [el costo, las comunicaciones], [suele ser el mayor costo y la mayor fuente de errores; empuja la autonomía (y puede salvar misiones «perdidas»)],
  ),
  caption: [Los _drivers_ del sistema #diapo("11 B", 28) #diapo("11 B", 29).],
)

#deduccion("por qué la tabla tiene dos columnas de límites")[
  Cada _driver_ está en el medio de una cadena: el lanzador limita el peso,
  y el peso limita la carga útil. Leída por filas, la tabla es una lista;
  leída como cadena, es el mapa de qué decisión arrastra a cuál. Elegir una
  órbita más alta (altitud) mejora la cobertura, pero pide más lanzador o
  menos peso, y menos peso es menos carga útil. Es el mismo tejido de
  dependencias que la tabla N² de la unidad 7 muestra entre subsistemas,
  dibujado entre parámetros. Para el trabajo práctico, esta tabla es la
  lista de preguntas que te va a hacer el revisor sobre la física del
  satélite.
]

== La batalla de los subsistemas, y el dilema del ingeniero

Todos los subsistemas tienen que diseñarse para trabajar *juntos* y cumplir
los requerimientos, y diseñar un buen satélite es, casi siempre, encontrar
buenos compromisos entre ellos. La lámina deja la «pregunta del millón»: ¿hay
un proceso que ayude a lograr un buen diseño? #diapo("11 B", 30). Es la
pregunta a la que la materia entera responde que sí: la ingeniería de
sistemas.

#clave[
  *El dilema del ingeniero de sistemas* #diapo("11 B", 32). En cada
  solución costo-efectiva:
  - para bajar el costo a riesgo constante, hay que bajar el desempeño;
  - para bajar el riesgo a costo constante, hay que bajar el desempeño;
  - para bajar el costo a desempeño constante, hay que aceptar más riesgo;
  - para bajar el riesgo a desempeño constante, hay que aceptar más costo.

  Y el calendario suele ser un recurso crítico, correlacionado con el costo.
  La lámina lo cierra en una fórmula: *riesgo = f(costo, calendario,
  desempeño)*.
]

#posta[
  Es el triángulo de hierro del módulo #M("proyecto") con el riesgo en el
  centro, como lo dibujó la cátedra desde la clase 1, ahora escrito como
  función: no se puede tocar un vértice sin pagar en otro. El que pide «más
  barato, igual de bueno y sin riesgo» no está pidiendo un satélite: está
  pidiendo un milagro.
]

== Tres agencias, tres ciclos

#figure(
  table(
    columns: (0.7fr, 3.4fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header([*Agencia*], [*Fases*]),
    [ESA], [0: análisis de misión e identificación de necesidades · A: factibilidad · B: definición preliminar · C: definición de detalle · D: producción y calificación en tierra · E: utilización · F: disposición final],
    [NASA], [Pre-A: estudios avanzados · A: análisis preliminar · B: definición · C: diseño · D: desarrollo · E: operaciones],
    [DoD], [Pre-hito 0 · 0: exploración de conceptos · I: demostración y validación · II: desarrollo de ingeniería y manufactura · III: producción y despliegue · operaciones y soporte],
  ),
  caption: [Las fases y revisiones de un programa mayor en tres organizaciones #diapo("11 B", 33).],
)

#cuidado[
  La fila de NASA de esa lámina usa nombres viejos de las fases («análisis
  preliminar», «definición», «diseño», «desarrollo»). Los que pide la
  cátedra son los del ciclo de vida del módulo
  #M("ciclo-de-vida-y-diagrama-en-v"): Fase A, desarrollo de concepto y
  tecnología; B, diseño preliminar; C, diseño final y fabricación; D, AIT y
  lanzamiento; E, operaciones y sostenimiento; F, cierre. Y ESA tiene una
  *Fase 0* antes de la A, que NASA llama Pre-Fase A. Las letras se parecen;
  el contenido de cada letra, no siempre.
]

El modelo V de integración #diapo("11 B", 34) es el #t[diagrama en V] de la
unidad 5 en otra versión: baja de la arquitectura regional, el estudio de
factibilidad y el concepto de operaciones a los requerimientos, el diseño de
alto nivel y el de detalle; abajo, el desarrollo y la instalación; y sube
por los ensayos de unidad, la verificación de subsistemas y de sistema y la
validación, hasta la operación, los cambios y el retiro. Cada caja de la
izquierda se conecta con la de enfrente por un *plan*: el de validación del
sistema, el de verificación del sistema, el de verificación de subsistemas,
el de ensayo de unidad.

== Los presupuestos: la ingeniería se hace con números

#definicion("presupuestos de recursos técnicos (budgets)")[
  Los resúmenes de los parámetros característicos de un _spacecraft_,
  agrupados por subsistema; son la herramienta para los _trade-offs_ y para
  seguir los recursos #diapo("11 B", 35).
]

Los típicos en astronáutica #diapo("11 B", 35): *masa* (seca y húmeda, por
subsistema); *potencia* (la generada, y la necesaria según las condiciones
de iluminación y las fases de la misión); *errores de apuntamiento*
(determinación de actitud y de posición); *cobertura* (cobertura, tiempo
medio de respuesta, hueco promedio en el tiempo, enlace y tasa de datos); y
*costo* (de desarrollo, de lanzamiento, de operación). La lámina lo remata
con la primera ley de Akin: *«la ingeniería se hace con números; un análisis
sin números es, en el mejor de los casos, una opinión»*.

#figure(
  table(
    columns: (1fr, 1.4fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header([*Recurso*], [*Cómo se sigue*]),
    [volumen, interferencias], [modelos CAD 3D],
    [masa], [presupuesto de masa (planilla)],
    [potencia], [presupuesto de potencia (planilla)],
    [interfaces físicas], [diagramas esquemáticos],
    [propelente], [presupuesto de Δv],
    [costo], [presupuesto de recursos],
    [cómputo], [presupuesto de CPU],
    [geometría orbital], [gráficos de trayectoria],
    [confiabilidad], [análisis probabilístico],
  ),
  caption: [Uno o más recursos limitados restringen el diseño, y seguirlos es una herramienta para integrarlo: cada recurso con su método #diapo("11 B", 36).],
)

#posta[
  Para el trabajo práctico: un MCR no lleva el diseño de detalle, pero
  cualquier revisor va a preguntar por la masa, la potencia y el enlace. Un
  presupuesto chico, con márgenes declarados como los de la unidad 5, vale
  más que tres párrafos diciendo que «el satélite es liviano». Y los
  presupuestos tienen que hablar *del mismo* diseño: si la potencia supone
  un panel que la masa no cuenta, el revisor lo encuentra.
]
