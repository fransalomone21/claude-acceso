#import "../plantilla.typ": *

#modulo(
  "Forma, función e ingeniería inversa",
  [Explicar por qué la cátedra enseña con proyectos (CDIO y aprendizaje
   basado en proyectos); volver a separar forma de función con las dos
   pruebas de la forma y el caso de los dos puentes; recorrer la
   arquitectura al revés —de la forma a la función— con la ingeniería
   inversa del Akutan Zero; y ubicar el diseño conceptual dentro del lazo
   de procesos de diseño de NASA.],
  clave: "forma-funcion-e-ingenieria-inversa",
)

#lectura[
  Clase 10, diapositivas 3 a 21.
]

== Por qué la materia es un proyecto

La clase 10 empieza por explicar *cómo* se enseña la materia. La meta del
#t[CDIO] es darle al estudiante oportunidades de aplicar lo que sabe en
contexto, y el aprendizaje basado en proyectos lo complementa
#diapo(10, 3).

#definicion("aprendizaje basado en proyectos (PjBL)")[
  Forma de aprendizaje focalizada en la *formulación y el encare del
  problema* más que en su solución: centrada en el estudiante, que elige
  —dentro de un entorno— cómo y qué aprender; en grupos chicos y
  colaborativa; con los profesores como facilitadores, guías o _coaches_;
  con los proyectos como foco y como vehículo de habilidades de ingeniería
  auténticas; y con la información nueva adquirida por aprendizaje
  autodirigido #diapo(10, 3).
]

La cátedra ubica su propuesta entre dos extremos de organización del
currículum #diapo(10, 4): el «puro qué» —materias separadas, sin
proyectos— y el «puro cómo» —el modelo del aprendiz, todo proyecto y
nada de disciplina—. Lo que propone es la *mezcla*: disciplinas con
proyectos y habilidades que las cruzan.

#posta[
  Esto explica la materia entera: el ROV de las clases, el diagrama de
  bloques de la actividad, el trabajo práctico del MCR. La cátedra no te va
  a evaluar sólo si sabés qué es una PDR; te va a hacer *hacer* una. Y
  avisa, en la primera línea, qué mira: más la *formulación* del problema
  que la solución. Un trabajo práctico con un satélite brillante y una
  necesidad mal planteada va a salir peor que uno modesto con la cadena del
  alcance impecable.
]

== La forma, releída

La clase repasa la definición de #t[arquitectura de sistema] según
Crawley: materializa el #t[concepto] asignando la función (proceso más
operando) a los elementos de la #t[forma] y definiendo las relaciones y las
interfaces entre los objetos y con el contexto #diapo(10, 5). Y vuelve
sobre la forma con una relectura del libro #diapo(10, 6) #diapo(10, 7):

- *Es difícil separar la forma de la función*, porque hablamos de la forma
  con palabras de función. Describí un vaso de papel, un lápiz o un
  cuaderno sin usar «manija», «goma» o «anillado»: te queda un
  «semicírculo de cartón plano», un «cilindro de goma», un «espiral de
  metal».
- *Primera prueba de la forma: existe.* Se construye, se escribe, se
  compone, se fabrica o se ensambla. La forma es lo que el sistema *es*.
- *Segunda prueba: es instrumental en la ejecución de la función.* Hace
  falta algún instrumento que «lleve» la función; la forma es lo que
  eventualmente se opera para entregar función y valor.
- *La forma existe antes de que se ejecute la función*, e incluye las
  entidades de forma *y* las relaciones formales entre ellas —la
  estructura—.

La definición viene con una tabla de preguntas que vale como guía para
describir la forma de cualquier sistema #diapo(10, 7): ¿qué es el sistema?,
¿cuáles son sus elementos principales?, ¿cuál es su estructura formal?,
¿qué sistemas lo acompañan?, ¿cuáles son sus límites y sus interfaces?,
¿cuál es su contexto de uso? Los ejemplos son una casa de playa, cuya
forma se lee en el plano de planta, y una tarjeta de instrucciones de
emergencia de un avión, cuya estructura es la secuencia numerada de las
imágenes #diapo(10, 8) #diapo(10, 9) #diapo(10, 10).

=== Dos puentes que se parecen y no son el mismo

#figure(
  placement: auto,
  image("../figuras/c10-p011.png", width: 80%),
  caption: [Un puente colgante y uno atirantado: misma función externa, forma parecida, arquitectura distinta (diapositiva 11).],
)

El ejemplo que cierra el repaso #diapo(10, 11): un puente *colgante* y uno
*atirantado* tienen la misma función externa (transportar vehículos) y se
ven parecidos (dos torres, una calzada, cables). Pero su arquitectura es
distinta, porque *asignan la función a la forma de otra manera*: en el
atirantado la calzada (forma) trabaja a compresión (función); en el
colgante no, y los anclajes de los cables principales (forma) son los que
reaccionan su carga (función). Por eso el atirantado no puede cubrir una
luz tan larga como el colgante.

#clave[
  *La arquitectura no es la forma ni la función: es la asignación de una a
  la otra.* Dos sistemas con la misma función y una forma parecida pueden
  tener arquitecturas distintas, y esa diferencia es la que decide sus
  límites de desempeño. Es la idea del módulo
  #M("forma-funcion-entidades"), con un ejemplo en el que la diferencia se
  ve a simple vista recién cuando sabés dónde mirar.
]

== La ingeniería inversa: la arquitectura al revés

#figure(
  placement: auto,
  image("../figuras/c10-p012.png", width: 66%),
  caption: [Diseño conceptual e ingeniería inversa, el mismo ciclo recorrido en sentidos opuestos (diapositiva 12).],
)

#definicion("ingeniería inversa")[
  El camino inverso al diseño conceptual. Al *diseñar* se conocen las
  funciones y se crea la forma que las entrega (el concepto); en la
  *ingeniería inversa* se conoce la forma y se *infieren las funciones* y,
  eventualmente, los objetivos #diapo(10, 12).
]

La secuencia de cada uno #diapo(10, 13): al hacer arquitectura y diseño se
definen las funciones entregadas hacia afuera, se crea el concepto, se
descomponen las funciones y se definen los subsistemas. En la ingeniería
inversa se definen los subsistemas y las funciones internas, se *infiere*
el concepto y se *infieren* las funciones externas entregadas —o su
falta—. Las dos últimas etapas son las difíciles, *por la emergencia de
funciones*: una función emergente no está en ninguna pieza, así que
mirando las piezas una por una no aparece.

=== El Akutan Zero

#figure(
  placement: auto,
  image("../figuras/c10-p015.jpg", width: 66%),
  caption: [El Akutan Zero, inspeccionado por personal de la marina de los Estados Unidos en la isla Akutan, el 11 de julio de 1942 (diapositiva 15).],
)

El caso de la cátedra #diapo(10, 13) #diapo(10, 16): un caza japonés
Mitsubishi Zero que cayó en la isla Akutan, en 1942, y quedó casi
intacto: el primero que los Estados Unidos capturaban entero. Dos meses después de capturarlo, un piloto de
pruebas de la marina norteamericana hizo con él 24 vuelos, del 20 de
septiembre al 15 de octubre. Lo que encontró, según su informe:

- giraba a la izquierda mucho más fácilmente que a la derecha;
- su motor se apagaba con *aceleración negativa*, por su carburador de tipo
  flotador;
- los alerones se «congelaban» por encima de los 200 nudos: rolar a esa
  velocidad era lento y pedía mucha fuerza en la palanca.

De ahí salió la táctica para los pilotos propios, que hasta entonces
perdían todos los duelos de maniobra: entrar en un picado de potencia, con
aceleración negativa si se podía —para abrir distancia mientras el motor
del Zero se paraba— y, a unos 200 nudos, rolar fuerte justo antes de que el
piloto enemigo alineara la mira.

#deduccion("qué tiene de ingeniería de sistemas un avión de guerra")[
  Nadie le pidió a los ingenieros del Zero un caza que *se apagara con
  aceleración negativa* ni que *no pudiera rolar a alta velocidad*. Son
  funciones —en realidad, *falta* de funciones— que *emergieron* de la
  forma: de elegir un carburador de flotador, de unos alerones que a alta
  velocidad pedían más fuerza de la que un piloto tiene. No estaban en ninguna especificación, y por eso no las podía
  encontrar nadie leyendo los planos: se encontraron *operando la forma*,
  en vuelos de prueba. Es la ingeniería inversa entera en un caso: se
  conocía la forma, se infirieron las funciones externas —y su falta— y de
  ahí, un objetivo nuevo (cómo ganarle).
]

== El concepto, y diseño contra arquitectura

El repaso del #t[concepto] #diapo(10, 18): lo crea el arquitecto, tiene que
permitir materializar todas las funciones, establece el glosario o
vocabulario de las soluciones e implícitamente representa una tecnología.
Y la distinción entre diseño y arquitectura #diapo(10, 19), que el módulo
#M("crear-arquitecturas") ya desarrolló, con una formulación más
cuantitativa:

- la arquitectura selecciona el concepto, la descomposición y el mapeo de
  la forma a la función;
- la arquitectura establece el *vector de variables de diseño* y los
  parámetros de operación;
- el diseño selecciona los *valores* de ese vector: es el camino hacia la
  optimización.

#posta[
  Dicho con el ejemplo de los puentes: elegir «atirantado» en vez de
  «colgante» es arquitectura; elegir cuántos tirantes, de qué diámetro y a
  qué altura las torres, es diseño. Primero se elige *qué variables hay*;
  después, *cuánto vale cada una*. Optimizar el diámetro de los tirantes
  no te va a dar nunca la luz de un puente colgante.
]

== El lazo de los procesos de diseño de NASA

#figure(
  placement: auto,
  image("../figuras/c10-p021.png", width: 88%),
  caption: [Las interrelaciones entre los procesos de diseño de sistemas, de las autoridades de la misión al baseline elegido, con el lazo iterativo de trade studies en el medio (diapositiva 21, versión en castellano de la figura 4.0-1 del _NASA Systems Engineering Handbook_).],
)

La clase cierra el repaso con la figura del manual de NASA que encadena
los cuatro procesos de diseño del sistema #diapo(10, 20) #diapo(10, 21):
de las *autoridades de la misión* salen los objetivos y restricciones, los
objetivos operacionales y los criterios de éxito (las expectativas de los
interesados); de ahí, los *requerimientos de alto nivel*; de ahí, la
*descomposición lógica y funcional*; y en el centro, el *lazo de diseño
iterativo* de los _trade studies_, que va y vuelve entre la estructura de
desglose del producto, los requerimientos derivados y alojados y el
ConOps. Cada vuelta pregunta si el análisis funcional y de desempeño es
suficientemente profundo; si no, se baja un nivel. Cuando lo es, pregunta
*¿anda?, ¿es seguro y confiable?, ¿se puede lograr?*: si las tres dan sí,
sale el *baseline elegido*; si no, se vuelve a los requerimientos —se
re-baselinean— y otra vuelta.

#deduccion("dónde está el trabajo práctico en esta figura")[
  El MCR del trabajo práctico recorre la columna de la izquierda —autoridad,
  objetivos, restricciones, criterios de éxito, requerimientos de alto
  nivel— y entra apenas al lazo: un ConOps, una primera descomposición en
  subsistemas (el diagrama de bloques y el N²) y, como mucho, la
  comparación de dos o tres conceptos. Las tres preguntas de la salida
  —¿anda?, ¿es seguro?, ¿se puede lograr?— son las que un revisor externo
  le va a hacer a tu concepto, aunque todavía no haya diseño.
]
