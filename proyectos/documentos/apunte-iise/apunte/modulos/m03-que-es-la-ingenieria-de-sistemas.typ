#import "../plantilla.typ": *

#modulo(
  "Qué es la ingeniería de sistemas, y de dónde salió",
  [Dar la definición de INCOSE completa y las dos complementarias de la
   cátedra; enumerar los seis pasos del enfoque; enunciar el principio de los
   niveles (N+1 / N / $N-1$); y contar la historia —Nike, Atlas, SAGE,
   Apollo— sabiendo *qué aportó cada uno*, que es como se pregunta.],
  clave: "que-es-is",
)

#lectura[
  Clase 1, diapositivas 22 a 41. Las definiciones salen del _INCOSE Systems
  Engineering Handbook_ v3.2; la parte histórica, del curso ESD.33 del MIT.
]

== La disciplina y por qué apareció

#clave[
  La ingeniería de sistemas es *el arte de la gestión de la complejidad*
  #diapo(1, 22). No emergió como disciplina profesional distinta por evolución
  natural de la ingeniería: emergió *en respuesta directa* a la complejidad
  creciente de los proyectos de nuevo desarrollo. Es una respuesta a un
  problema, y ese problema tiene fecha.
]

Esa frase ordena todo el módulo. Cada programa histórico que viene más abajo es
un momento donde la complejidad superó lo que un ingeniero —o una empresa—
podía sostener, y la respuesta fue método.

== Las definiciones

La cátedra da tres, y no son redundantes: cada una contesta una pregunta
distinta. Conviene tener clarísima la de INCOSE, que es la canónica, y usar las
otras dos para completar.

#definicion("ingeniería de sistemas — la de INCOSE, la canónica")[
  Un *enfoque interdisciplinario* y unos *medios* para permitir la realización
  de sistemas exitosos. Se focaliza en definir las *necesidades del cliente* y
  la funcionalidad requerida *temprano* en el ciclo de desarrollo del proyecto,
  *documentar los requerimientos*, y luego proceder con la *síntesis del
  diseño* y la *validación del sistema*, considerando el problema *en su
  completitud*: operaciones, costos y planificación, desempeño, entrenamiento y
  soporte, ensayos, manufactura y eliminación o fin de ciclo. #diapo(1, 27)
]

Y el cierre de esa diapositiva, que es la mitad que se olvida: la ingeniería de
sistemas considera *ambas* necesidades del cliente —*la del negocio y la
técnica*— con la meta de suministrar un producto de calidad.

#figure(
  table(
    columns: (1.7fr, 1fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*La otra definición*], [*Qué agrega*]),
    [Una *disciplina* que se concentra en el diseño y la aplicación del *todo* como distinto de las partes. Involucra un problema en su completitud y su totalidad, teniendo en cuenta todas las facetas, todas las variables y las relaciones sociales y los aspectos técnicos. #diapo(1, 26)],
    [El *todo como distinto de las partes* — que es el puente hacia el pensamiento sistémico y los emergentes de la unidad 2.],
    [Un *proceso iterativo de arriba hacia abajo* de síntesis, desarrollo y operación de sistemas del mundo real, que satisfacen de manera cercana a lo óptima todo el rango de requerimientos. #diapo(1, 26)],
    [El *sentido de la marcha* (de arriba hacia abajo) y que es *iterativo*: no se hace una vez y se archiva.],
  ),
  caption: [Las dos definiciones complementarias. Cada una agrega una palabra que a la de INCOSE no se le ve a primera vista.],
)

#posta[
  Si tenés que contestar en tres líneas: *enfoque interdisciplinario para
  realizar sistemas exitosos, que define temprano las necesidades del cliente,
  documenta los requerimientos y sintetiza y valida el diseño mirando el
  problema completo.* Las palabras que no pueden faltar son
  *interdisciplinario*, *temprano*, *requerimientos*, *validación* y
  *completitud*.
]

=== Los seis pasos del enfoque

La diapositiva 23 desarma el enfoque en pasos, y es la respuesta natural a
«¿cómo se hace ingeniería de sistemas?» #diapo(1, 23):

+ *Identificación y cuantificación* de las metas del sistema.
+ *Creación de alternativas* de conceptos y de diseño de sistema.
+ Evaluación del *desempeño* de las alternativas de diseño.
+ *Selección e implementación* del mejor diseño.
+ *Verificar* que el diseño esté apropiadamente construido e integrado.
+ *Evaluar cuán bien* el sistema alcanza las metas.

#clave[
  Los pasos 5 y 6 son distintos a propósito, y esa diferencia es la
  *verificación* contra la *validación*: el 5 pregunta *¿se construyó bien?* y
  el 6 pregunta *¿se construyó lo correcto?* Se desarrolla en la unidad 5.
]

El enfoque es *iterativo*, con sucesivos incrementos en la resolución del
_baseline_ del sistema —que contiene requerimientos, detalles de diseño, planes
de verificación y estimaciones de costo y desempeño #diapo(1, 23). Cada vuelta
no cambia de tema: aumenta la resolución del mismo.

== Qué es un sistema, y el principio de los niveles

#definicion("sistema")[
  Una combinación de interacción de elementos organizados para alcanzar un
  *propósito establecido*. Un conjunto de elementos integrados o ensamblados
  que realizan objetivos definidos; esos elementos incluyen productos
  (_hardware_, _software_, _firmware_), procesos, personas, información,
  técnicas, facilidades, servicios y otros elementos de soporte. #diapo(1, 25)
]

#cuidado[
  La segunda mitad de la definición es la que se saltea, y es la que más
  distingue a esta materia de una de diseño de artefactos: *las personas y los
  procesos son elementos del sistema*, igual que el hardware. Un sistema
  espacial que se define sólo por su hardware está mal definido.
]

Y de ahí sale el principio que la cátedra pone solo, en una diapositiva
completa, porque se usa todo el tiempo:

#definicion("el principio de los niveles")[
  Cada sistema opera como un *elemento de un sistema más grande* y a su vez
  *está compuesto de sistemas más chicos*. #diapo(1, 29)
]

#align(center)[
  #fig-niveles()
]
#align(center)[
  #text(size: 9pt, fill: c-libro)[Figura — Sistema N+1, N y $N-1$: el mismo objeto es sistema, subsistema o suprasistema según desde dónde se lo mire #diapo(1, 29).]
]

#v(6pt)

#clave[
  *«Sistema» no es una propiedad del objeto: es una posición relativa al nivel
  que se eligió mirar.* El mismo propulsor es el *sistema* para quien lo
  diseña, un *subsistema* para quien integra el satélite y parte del *contexto*
  para quien opera la constelación. Por eso #t[entidad] se define como relativa
  al nivel, y por eso lo primero que hace el pensamiento de sistema es *definir
  el* #t[límite del sistema].
]

=== Qué integra un sistema

La cátedra insiste en la misma tríada desde dos diapositivas distintas
#diapo(1, 30) #diapo(1, 31): un sistema es un compuesto integrado de *gente*,
*productos* y *procesos*, puestos juntos para satisfacer las *necesidades y
objetivos establecidos* de un cliente.

En un proyecto espacial concreto eso se ve así: personas especializadas en
distintas disciplinas —subsistema térmico, estructuras, potencia, control de
actitud— que piensan el sistema como un producto de hardware y software; y lo
que hace falta desarrollar *con esas personas* es un concepto de ingeniería de
sistemas que las junte #diapo(1, 31).

== INCOSE

#definicion("INCOSE")[
  El _International Council on Systems Engineering_: una organización sin fines
  de lucro fundada para *desarrollar y diseminar los principios
  interdisciplinarios y las prácticas* que habilitan la realización de sistemas
  exitosos. #linebreak()
  *Misión:* compartir, promover y avanzar la mejor ingeniería de sistemas a
  través del mundo, para beneficio de la humanidad y el planeta.
  *Visión:* ser la autoridad mundial en ingeniería de sistemas. #diapo(1, 24)
]

Su _Systems Engineering Handbook_ es la fuente de la definición canónica de
arriba, y vuelve como referencia en toda la materia.

== De dónde salió: la historia, y qué aportó cada programa

Hay dos afirmaciones que parecen contradecirse y no lo hacen, así que conviene
decirlas juntas #diapo(1, 32):

/ Se hace ingeniería de sistemas desde la antigüedad: las grandes obras tenían
  procesos complejos que había que comunicar, y eran demasiado grandes para que
  una o dos personas las dirigieran; con proyectos así hay que *estandarizar
  procesos y herramientas*.
/ Pero la formalización es de 1940, en Estados Unidos: empezó durante y después
  de la Segunda Guerra, principalmente en el programa de misiles *Nike*, y la
  formalización definitiva —puesta en documentos y estándares— se concretó con
  el proyecto *Apollo*, en la NASA.

#clave[
  La distinción que se pregunta es *práctica* contra *formalización*. La
  práctica es antiquísima; lo que tiene fecha y lugar es haberla puesto por
  escrito como disciplina. Contestar «la ingeniería de sistemas nació en 1940»
  a secas pierde la mitad de la respuesta.
]

=== Las grandes obras de la antigüedad

Los ejemplos que la cátedra enumera, con sus fechas #diapo(1, 33):

#figure(
  table(
    columns: (1fr, auto),
    align: (left, right),
    stroke: 0.5pt + c-guia,
    inset: 6pt,
    table.header([*Obra*], [*Cuándo*]),
    [Sistema de distribución de agua en la Mesopotamia], [4000 a.C.],
    [Sistema de irrigación en Egipto (pirámides)],        [3300 a.C.],
    [Sistema urbano de Atenas, Grecia],                   [400 a.C.],
    [Sistema de rutas romano],                            [300 a.C.],
    [Sistema de distribución de agua romano],             [300 a.C.],
    [Transporte de agua en el canal del Erie],            [siglo XIX],
    [Sistema telefónico de Estados Unidos],               [1877],
    [Sistema de distribución de energía eléctrica de Estados Unidos], [1880],
  ),
  caption: [Ingeniería de sistemas antes de que se llamara así. Todas comparten lo mismo: escala que excede a una persona, y necesidad de estandarizar.],
)

=== Las referencias modernas, y el aporte de cada una

Ésta es la parte que conviene memorizar como *programa #sym.arrow aporte*, no
como lista de nombres.

#figure(
  table(
    columns: (0.75fr, 0.45fr, 2fr),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Programa*], [*Cuándo*], [*Qué aportó*]),
    [Defensa aérea británica],
    [1937],
    [El *equipo multidisciplinario* formado para analizar el sistema de defensa aéreo: la primera vez que el objeto de estudio es el sistema, no el artefacto.],
    [*Nike* (Bell Labs, US Army)],
    [1939–1945],
    [*El término «ingeniería de sistemas» empieza a usarse acá.* La necesidad era defenderse de aviones a reacción con misiles tierra-aire: alta velocidad y precisión, muchas tecnologías juntas. La respuesta fue *poner a todos juntos y coordinados* en un equipo de ingeniería de sistemas.],
    [*Atlas* (Ramo-Wooldridge)],
    [1954–1964],
    [La ingeniería de sistemas queda *firmemente establecida como enfoque de gestión del proyecto*, y aparece la identificación *temprana* de los desafíos clave — el problema de la reentrada.],
    [*SAGE* (MIT)],
    [1951–1980],
    [*Primer proyecto que usó computadoras* para procesar información y controlar procesos. Los ingenieros jugaron un rol de *gestión* clave. Inspiró la creación de ARPANET.],
    [*Apollo* (NASA)],
    [años 60],
    [*La formalización definitiva*: la NASA documenta plenamente la disciplina y produce los manuales de ingeniería de sistemas que se siguen usando.],
  ),
  caption: [Los cinco hitos, y qué pieza del método aportó cada uno.],
)

#clave[
  *El Atlas es el argumento de escala, y los números son la respuesta.* El
  programa del primer misil balístico intercontinental involucró *18.000
  científicos e ingenieros, 17 contratistas, 200 subcontratistas y 200.000
  proveedores*, coordinados por Ramo-Wooldridge #diapo(1, 36). Ninguna
  organización sostiene eso por buena voluntad: hace falta un método, y ése es
  el punto de toda la historia.
]

#deduccion("por qué el Apollo es el que cierra la historia")[
  Porque el proyecto era *un conjunto de sistemas y capacidades distintos que
  debían trabajar juntos*, con proveedores repartidos por todo Estados Unidos
  #diapo(1, 40). No alcanzaba con que cada equipo hiciera bien lo suyo: hacía
  falta que todos usaran el *mismo* vocabulario, las mismas fases y los mismos
  entregables. Escribir la disciplina dejó de ser una mejora y pasó a ser la
  condición para que el programa funcionara — que es, en una línea, la razón de
  ser de esta materia.
]

#posta[
  Si te preguntan «¿por qué existe la ingeniería de sistemas?», la respuesta
  corta es: porque a partir de cierta escala, la complejidad deja de poder
  manejarse con talento individual y hay que manejarla con método. Nike puso el
  nombre, Atlas puso la escala, SAGE puso las computadoras y el rol de gestión,
  y Apollo lo puso por escrito.
]
