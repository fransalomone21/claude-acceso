#import "../plantilla.typ": *

#modulo(
  "Gestión del riesgo técnico",
  [Definir el riesgo con sus tres componentes y escribir un riesgo como un
   enunciado; ubicar un riesgo en sus categorías y en las capas del modelo
   de riesgo; recorrer el ciclo de gestión (identificar, analizar,
   planificar, seguir, controlar); calificar un riesgo en la matriz de
   probabilidad e impacto de NASA y en la tabla de severidad por frecuencia
   del ROV sin confundir sus escalas; y explicar por qué la seguridad es
   una propiedad emergente del sistema. Es la última pieza de la sección 5
   del trabajo práctico final.],
  clave: "gestion-del-riesgo",
)

#lectura[
  Clase 10, diapositivas 48 a 50 y 60 a 71.
]

== Qué es el riesgo

El riesgo ya apareció en todo el apunte —en el centro del triángulo de
hierro, en cada revisión, en la matriz de funciones de cada fase—, pero
recién la clase 10 lo define. Es el proceso número 13 del motor de la
ingeniería de sistemas de NASA (módulo #M("el-motor-de-la-is-nasa")): la
*gestión del riesgo técnico*, uno de los procesos de gestión técnica
#diapo(10, 60).

#definicion("riesgo")[
  La combinación de la *probabilidad* de que un programa o proyecto
  experimente un evento no deseado y de la *consecuencia* —impacto o
  severidad— de ese evento #diapo(10, 61). Es una medida de las
  incertidumbres de lograr las metas de desempeño técnico dentro de las
  restricciones de costo y planificación, y tiene *tres componentes*: la
  *causa raíz futura*, la *probabilidad* de que ocurra y la *consecuencia*
  de que ocurra #diapo(10, 62).
]

El evento no deseado puede ser *técnico* o *programático*: sobrecostos,
atrasos, accidentes, problemas de salud, actividades maliciosas, impacto
ambiental, o no alcanzar los objetivos técnicos o científicos
#diapo(10, 61). Y puede venir de cualquier aspecto del esfuerzo técnico:
amenazas, la madurez de la tecnología (el TRL), la capacidad de los
proveedores, la madurez del diseño #diapo(10, 62).

#deduccion("cómo se escribe un riesgo, a partir de sus tres componentes")[
  Si un riesgo tiene una causa, una probabilidad y una consecuencia, el
  enunciado que lo describe tiene que nombrar las tres. «Riesgo: las
  baterías» no es un riesgo: es un tema. «*Si* la temperatura de la
  batería en eclipse baja de su límite (causa), *entonces* el satélite
  pierde potencia en la fase de ciencia (consecuencia); probabilidad 3,
  impacto 2» sí lo es: se puede calificar, se le puede asignar un dueño y
  se le puede escribir una acción. El manual de NASA pide lo mismo con
  otras palabras: «enunciados de riesgo claros» para entrar al sistema de
  gestión. La forma «si… entonces…» es del apunte, no de la lámina.
]

== Categorías y capas

#figure(
  placement: auto,
  image("../figuras/c10-p064.png", width: 62%),
  caption: [Las categorías del riesgo: técnico, de costo y de planificación en las puntas, el programático en el centro, y en las flechas cómo se contagian entre sí (diapositiva 64).],
)

La cátedra dibuja las categorías como un triángulo #diapo(10, 64):
*riesgo técnico*, *de costo* y *de planificación* en las puntas, y el
*programático* en el centro. Lo que enseña está en las flechas: los
*problemas técnicos* empujan al costo y a la planificación; los *fondos
limitados* y los *calendarios comprimidos* empujan al riesgo técnico; los
*presupuestos impuestos* y los *calendarios exigidos* vienen del lado
programático; y los *atrasos* conectan costo con planificación. Un riesgo
casi nunca se queda en su categoría.

#posta[
  Es el triángulo de hierro del módulo #M("proyecto") visto desde el
  riesgo: si los tres lados están restringidos, cualquier problema en uno
  se transforma en un problema en los otros dos. Por eso la cátedra puso
  el riesgo *en el centro* del triángulo desde la clase 1.
]

#figure(
  placement: auto,
  image("../figuras/c10-p063.png", width: 70%),
  caption: [Las capas del modelo de riesgo para una misión a Marte: de los riesgos técnicos del proyecto, sobre los que se tiene mucha influencia, a los naturales, sobre los que no se tiene ninguna (diapositiva 63).],
)

Las *capas del modelo de riesgo*, con una misión a Marte de ejemplo
#diapo(10, 63), ordenan los riesgos por cuánta influencia tiene el
proyecto sobre ellos: en el centro, los *técnicos y del proyecto*
(madurez de la tecnología de los _airbags_, desempeño de los motores del
_rover_, errores de software), donde la influencia es alta; después, los
de la *industria* (desempeño del contratista, estabilidad del
presupuesto); los del *país* (estabilidad política, el ciclo de cuatro
años, las prioridades presupuestarias); los del *mercado*; y afuera de
todo, los *naturales* —radiación cósmica, micrometeoritos, la
incertidumbre en la densidad de la atmósfera de Marte—, sobre los que la
influencia es nula.

#deduccion("qué se hace con un riesgo sobre el que no se tiene influencia")[
  Sobre la radiación cósmica no se puede bajar la *probabilidad*: va a
  estar. Lo único que se puede bajar es la *consecuencia*, diseñando para
  tolerarla (blindaje, componentes resistentes, redundancia). Sobre un
  riesgo técnico del centro, en cambio, se puede actuar sobre los dos:
  madurar la tecnología baja la probabilidad de que falle. La capa en la
  que cae un riesgo dice *sobre cuál de sus dos números* se puede trabajar.
]

== El ciclo de gestión

#definicion("gestión del riesgo técnico")[
  La disciplina sistemática de toma de decisiones informada por el riesgo
  que, de manera *proactiva*, identifica, analiza, planifica, sigue,
  controla, comunica, documenta y gestiona el riesgo para aumentar la
  probabilidad de alcanzar las metas del proyecto #diapo(10, 61).
]

#figure(
  placement: auto,
  image("../figuras/c10-p066.png", width: 62%),
  caption: [El marco de la gestión de riesgo: cinco pasos en ciclo, con la comunicación y los documentos en el centro (diapositiva 66).],
)

El ciclo tiene cinco pasos #diapo(10, 65) #diapo(10, 66), con la
*comunicación y los documentos* en el centro de todos:

+ *identificar*: anticipar qué puede andar mal;
+ *analizar*: decidir qué es importante;
+ *planificar*: preparar las acciones;
+ *seguir*: seguir las acciones;
+ *controlar*: corregir las desviaciones.

Para identificar y evaluar #diapo(10, 67): una *lluvia de ideas* de
riesgos, cada uno con su probabilidad y su impacto si ocurre; agruparlos
en categorías, con una regla práctica de limitar la lista (la lámina
dice «_Limit \@ N20_»: _probable_, unos veinte riesgos);
calificarlos con opinión *y* datos; e *involucrar a todos los
interesados*.

#cuidado[
  La palabra que más pesa en la definición es *proactiva*. Gestionar el
  riesgo no es reaccionar cuando el problema aparece —eso es gestionar
  *problemas*—, es actuar sobre algo que todavía no pasó. Un riesgo que se
  materializó deja de ser un riesgo y pasa a ser un problema, con otro
  tratamiento. Y es un *ciclo*: se vuelve a identificar en cada fase,
  porque el diseño nuevo trae riesgos nuevos (la matriz de funciones lo
  muestra: la lista de técnicas de análisis de riesgo crece fase a fase).
]

== La matriz de riesgo de NASA

La cátedra da el «diagrama de riesgo» de NASA con dos atributos, cada uno
en cinco niveles #diapo(10, 68):

#figure(
  table(
    columns: (0.5fr, 1.2fr, 3fr),
    align: (center, left, left),
    stroke: 0.4pt + luma(180),
    [*Nivel*], [*Probabilidad*], [*Criterio*],
    [1], [Casi certeza], [todo apunta a que se convierte en un problema],
    [2], [Muy probable], [alta posibilidad de que se convierta en un problema],
    [3], [Probable (50/50)], [hay una posibilidad de que se convierta en un problema],
    [4], [Poco probable], [un riesgo así puede convertirse en problema de vez en cuando],
    [5], [Improbable], [no hay mucha chance de que se convierta en un problema],
  ),
  caption: [El atributo probabilidad del diagrama de riesgo de NASA (diapositiva 68).],
)

#figure(
  table(
    columns: (0.5fr, 1.1fr, 1.9fr, 1.2fr, 1.5fr),
    align: (center, left, left, left, left),
    stroke: 0.4pt + luma(180),
    [*Nivel*], [*Impacto*], [*Criterio técnico*], [*Criterio de costo*], [*Criterio de planificación*],
    [1], [Catastrófico], [no se puede controlar el vehículo o no se puede realizar la misión], [más de 10 millones de dólares], [corrimiento en los eventos de nivel I],
    [2], [Crítico], [pérdida de la misión, pero el activo es recuperable con el tiempo], [entre 5 y 10 millones], [corrimiento en los eventos de nivel II],
    [3], [Moderado], [misión degradada por debajo del valor nominal especificado], [entre 1 y 5 millones], [corrimiento en los eventos de nivel III],
    [4], [Marginal], [márgenes de desempeño de la misión reducidos], [entre 100 mil y 1 millón], [más de un mes perdido en la planificación],
    [5], [Despreciable], [mínimo o sin impacto], [mínimo o sin impacto], [—],
  ),
  caption: [El atributo impacto, con sus tres criterios (diapositiva 68).],
)

#deduccion("cómo se arma la matriz con estas dos tablas")[
  Cada riesgo recibe un nivel de probabilidad y uno de impacto, y se ubica
  en una grilla de 5 × 5. *En esta escala el 1 es el peor en los dos
  ejes*: la esquina (1, 1) —casi certeza y catastrófico— es la zona roja;
  la (5, 5) —improbable y despreciable—, la verde. Fijate que el impacto se
  evalúa con *tres criterios a la vez* —técnico, costo, planificación— y
  manda el peor: un riesgo que no afecta la técnica pero cuesta 7 millones
  es «crítico». Los montos son los de un proyecto de NASA; para el trabajo
  práctico se escalan al tamaño de tu misión, *declarando* la escala.
]

=== El ejemplo del ROV, con la escala dada vuelta

El análisis de riesgos del ROV #diapo(10, 49) usa otra convención: cada
riesgo tiene una *severidad* y una *frecuencia*, y el *riesgo total* es su
producto, con números *más altos para lo peor*:

#figure(
  table(
    columns: (0.8fr, 1.8fr, 1fr, 1fr, 1fr),
    align: (center, left, center, center, center),
    stroke: 0.4pt + luma(180),
    [*Ref.*], [*Riesgo*], [*Severidad*], [*Frecuencia*], [*Total*],
    [X1], [Filtración], [9], [2], [18],
    [X2], [Pérdida del vehículo], [3], [4], [12],
    [X3], [Baterías agotadas], [1], [4], [4],
    [X4], [Mala telemetría], [7], [3], [*21*],
    [X5], [Enredo del cable], [4], [2], [8],
    [X6], [Sobrecalentamiento], [2], [1], [2],
    [X7], [Falla mecánica], [1], [6], [6],
  ),
  caption: [Los riesgos del ROV: el total es severidad × frecuencia (diapositiva 49).],
)

#cuidado[
  *Las dos escalas van al revés.* En la de NASA de la diapositiva 68, el
  nivel 1 es el peor; en la del ROV de la diapositiva 49, el número alto es
  el peor y el producto ordena los riesgos (la mala telemetría, con 21,
  encabeza la lista). Ninguna está mal; lo que está mal es mezclarlas, o
  no decir cuál se usa. En el trabajo práctico: elegí una, escribí su
  escala con los criterios de cada nivel *antes* de la tabla, y usala
  igual para todos los riesgos.
]

#posta[
  Mirá el X2 del ROV: «pérdida del vehículo» con severidad 3, mientras que
  una filtración tiene 9. Raro: perder el vehículo debería ser lo peor.
  Puede que el equipo haya pensado en un vehículo atado al cable, que no se
  pierde del todo; puede que sea un error. Lo que enseña es que una tabla
  de riesgos se *lee* con el mismo ojo crítico que una de requerimientos:
  cada número necesita su porqué, y un revisor va a preguntar justo por el
  que no cierra.
]

== La seguridad como propiedad emergente

La clase cierra con una mirada distinta, que viene de la teoría de
sistemas y no de la de confiabilidad #diapo(10, 69) #diapo(10, 70):

- *la seguridad es una propiedad emergente del sistema*: los accidentes
  surgen de *interacciones* entre los componentes —humanos, físicos,
  sociales— que violan las restricciones de comportamiento seguro;
- las pérdidas son el resultado de *procesos complejos*, no de simples
  cadenas de eventos de falla;
- la mayoría de los accidentes mayores surgen de una *migración lenta de
  todo el sistema hacia un estado de alto riesgo*.

Es el enfoque de Nancy Leveson (MIT), con su modelo de causalidad de
accidentes STAMP y la técnica de análisis de peligros STPA, ya usados en
el espacio, la aviación, la medicina, la defensa y otros sectores
#diapo(10, 70). La última lámina ubica las actividades de seguridad sobre el
diagrama en V: identificación de peligros y evaluación del riesgo en la
rama que baja, análisis de seguridad que confirman las propiedades
logradas en la que sube #diapo(10, 71).

#deduccion("por qué esto es ingeniería de sistemas y no sólo confiabilidad")[
  La confiabilidad clásica pregunta *qué componente puede fallar* y con
  qué probabilidad. El enfoque de sistemas agrega lo que esa pregunta no
  ve: accidentes en los que *ningún componente falla* y el problema está en
  cómo interactúan. Es la #t[emergente (emergencia)] del módulo
  #M("pensamiento-sistema-emergentes") del lado malo: si el valor de un
  sistema emerge de sus interacciones, sus accidentes también. El NOAA-N′
  del módulo #M("el-diagrama-funcional") es un ejemplo de manual: ningún
  componente falló; fallaron dos procedimientos entre dos equipos.
]
