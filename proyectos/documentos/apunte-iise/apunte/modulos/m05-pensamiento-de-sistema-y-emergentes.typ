#import "../plantilla.typ": *

#modulo(
  "Pensamiento de sistema, la definición de sistema, y lo emergente",
  [Distinguir pensamiento *sistémico* de pensamiento *sistemático*; aplicar la
   «prueba del ladrillo» para decidir si algo es un sistema; enumerar las
   cuatro Tareas del pensamiento de sistema; y definir #t[emergente] con sus
   cuatro tipos, que es la idea que sostiene toda la unidad.],
  clave: "pensamiento-sistema-emergentes",
)

#lectura[
  Clase 2, diapositivas 23 a 38.
]

== Pensamiento sistémico, no sistemático

#cuidado[
  *No es lo mismo.* Pensamiento sistémico es pensar en una pregunta, una
  circunstancia o un problema *explícitamente como un sistema* — un conjunto
  de entidades interrelacionadas. *No* es pensar sistemáticamente (es decir,
  de manera ordenada y metódica) #diapo(2, 24). Las dos palabras se parecen y
  la cátedra las separa a propósito en la misma diapositiva.
]

Cuatro tareas ayudan a pensar de manera sistémica, y son el esqueleto del
resto de la unidad #diapo(2, 26):

#definicion("las cuatro Tareas del pensamiento de sistema")[
  + *Identificar* el sistema, su forma y su función, y *crear el concepto*
    del sistema — usando el holismo, para *concebir y reducir la ambigüedad*.
  + *Identificar las entidades* del sistema, sus forma y función, y los
    *límites y contexto* del sistema.
  + *Identificar las relaciones* entre las entidades en el sistema y en el
    límite, así como su forma y función.
  + *Identificar las propiedades emergentes* del sistema según la función de
    las entidades y sus interacciones funcionales.
]

Este módulo desarrolla la Tarea 0 —la definición de sistema y de lo
emergente, el terreno común de las cuatro—; los módulos siguientes desarrollan
las Tareas 1 a 4 una por una.

== Qué es un sistema, otra vez, y la prueba por el negativo

Ya se definió #t[sistema] en la unidad 1; acá la cátedra la retoma con la
prueba que permite *descartar* algo como sistema, que es la forma en que se
pregunta con más frecuencia.

#definicion("sistema — la prueba del ladrillo")[
  Un sistema es un conjunto de entidades y sus relaciones, cuya funcionalidad
  es *mayor que la suma* de las entidades individuales #diapo(2, 27). La
  definición tiene dos partes: (1) hay entidades que interactúan o están
  interrelacionadas, y (2) cuando interactúan, aparece una función *mayor que,
  o distinta de*, las funciones de las entidades individuales #diapo(2, 28).
]

#cuidado[
  *Un ladrillo no es un sistema*, porque en un nivel macroscópico es uniforme
  en su consistencia y *no contiene entidades* #diapo(2, 28). Pero un *muro*
  de ladrillos sí es un sistema: contiene entidades (los ladrillos y el
  mortero) y relaciones (comparten carga, tienen una geometría) #diapo(2, 29).
  Y si un conjunto de entidades *no tiene relaciones* entre sí —una persona en
  Ucrania y una bolsa de arroz en Asia— tampoco constituye un sistema.
]

#posta[
  La prueba corta: ¿hay entidades? ¿esas entidades interactúan? Si las dos
  respuestas son sí, hay sistema. Casi cualquier conjunto de entidades puede
  interpretarse como sistema, y por eso la palabra se usa tan comúnmente
  #diapo(2, 29) — el trabajo de esta unidad es dar precisión a algo que en el
  lenguaje cotidiano es vago.
]

=== Sistema no es lo mismo que producto

Dos ideas que se confunden: un *producto* es algo que es, o tiene el
potencial de ser, *intercambiado*. Por eso algunos productos no son sistemas
(el arroz) y algunos sistemas no son productos (el sistema solar), pero la
mayoría de lo que se construye es las dos cosas a la vez, y de ahí que las
palabras se mezclen en el uso común #diapo(2, 30).

== Lo emergente: la magia y el poder de los sistemas

#definicion("emergente (emergencia)")[
  Lo que aparece, se materializa o emerge *cuando un sistema funciona*: se
  produce cuando la función de las entidades y su interacción funcional se
  combinan. Es la funcionalidad del todo que *ninguna entidad tiene por
  separado* #diapo(2, 31).
]

#clave[
  Comprender lo #t[emergente] es *la meta y el arte* del pensamiento sistémico
  #diapo(2, 31). Lo primero que emerge, de la manera más obvia y crucial, es
  la *función*: lo que hace un sistema — sus acciones, resultados (_outcomes_)
  o salidas (_outputs_) #diapo(2, 31).
]

Además de la función emerge su *desempeño* (qué tan bien la ejecuta) y otros
atributos — confiabilidad, mantenibilidad, operabilidad, seguridad,
robustez —, que en inglés se agrupan como las *"ilities"* y que, a diferencia
de la función y el desempeño, tienden a manifestar su valor *a lo largo del
ciclo de vida* del sistema, no de inmediato #diapo(2, 36).

=== Los cuatro tipos de emergente

La función emergente puede ser anticipada o no, y deseable o no — y las
cuatro combinaciones importan porque cada una se gestiona distinto:

#figure(
  table(
    columns: (0.9fr, 1.4fr, 1.4fr),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([], [*Deseable*], [*No deseable*]),
    [*Anticipado*], [La función primaria buscada — los autos transportan personas.], [La falla prevista, con su mitigación planeada — los autos queman hidrocarburos.],
    [*No anticipado*], [La sinergia que aparece sola — los autos crean un sentido de libertad personal.], [La que cuesta el sistema — los autos matan personas.],
  ),
  caption: [Tabla 2.1 de la cátedra: los cuatro tipos de función emergente #diapo(2, 32).],
)

#cuidado[
  La celda que más rinde en un parcial es la de *no anticipado y no
  deseable* — es la que produce las fallas de sistema que se desarrollan en la
  Tarea 4 (módulo siguiente). No alcanza con diseñar la función anticipada
  deseable: el pensamiento sistémico existe para anticipar también lo que cae
  en las otras tres celdas.
]

=== El principio de lo emergente

#definicion("principio de lo emergente")[
  «Un sistema no es la suma de sus partes, sino el producto de las
  interacciones de esas partes» — Russell Ackoff. «El todo es más que la suma
  de las partes» — Aristóteles, _Metafísica_. #diapo(2, 35)
]

De ahí se derivan cuatro consecuencias que la cátedra enumera juntas
#diapo(2, 35):

- La *interacción* de las entidades conduce a la emergencia; es lo que puede
  dar valor agregado a un sistema.
- Como consecuencia de lo que emerge, el cambio se propaga de manera
  *impredecible*.
- Es difícil predecir cómo un cambio en una entidad influirá en las
  propiedades emergentes.
- El *éxito* del sistema ocurre cuando emergen las propiedades anticipadas; la
  *falla*, cuando no aparecen las anticipadas o aparecen las no anticipadas
  no deseadas.

#deduccion("por qué el huracán Katrina es el ejemplo natural")[
  Porque lo emergente no es exclusivo de los sistemas *construidos*: un
  huracán es un sistema natural —aire, presión, temperatura del agua,
  rotación terrestre, interactuando— cuya devastación en Nueva Orleans fue en
  sí misma una propiedad emergente del sistema, no de ninguna de sus partes
  por separado #diapo(2, 37). El ejemplo separa "emergente" de "diseñado
  intencionalmente": lo primero es la categoría amplia, lo segundo es apenas
  el caso en que el sistema es construido por humanos.
]

== En resumen

#posta[
  Cinco frases que resumen el módulo, y valen como respuesta corta a "¿qué es
  el pensamiento sistémico?" #diapo(2, 38):

  - Un sistema es un conjunto de entidades y sus relaciones, cuya
    funcionalidad es mayor que la suma de las entidades individuales.
  - Casi cualquier cosa puede considerarse un sistema, porque casi todo
    contiene entidades y relaciones.
  - La emergencia ocurre cuando la funcionalidad del sistema es mayor que la
    suma de las funcionalidades de las entidades consideradas por separado.
  - Comprender lo emergente es la meta y el arte del pensamiento sistémico.
  - La función, el desempeño y las "bilidades" surgen a medida que operan los
    sistemas — y están estrechamente ligados al beneficio y al valor, igual
    que la *ausencia* de emergencias no deseadas.
]
