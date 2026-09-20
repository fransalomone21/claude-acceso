#import "../plantilla.typ": *

#modulo(
  "La ambigüedad, y por qué nadie diseña el proceso ascendente",
  [Distinguir borrosidad de incertidumbre; clasificar información
   desconocida, conflictiva y falsa con el ejemplo (X, Y, Z); enunciar el
   #t[principio de ambigüedad]; y explicar por qué las #t[influencias
   ascendentes y descendentes] son la fuente principal de ambigüedad del
   arquitecto.],
  clave: "la-ambiguedad",
)

#lectura[
  Clase 3, diapositivas 4 y 9 a 15.
]

== Por qué "la parte delantera difusa" es difícil

Zhang y Doll acuñaron el término *"la parte delantera difusa"* (_fuzzy front
end_) para las actividades tempranas de desarrollo: son desafiantes porque
los objetivos no están claros — puede ser porque el cliente no puede
articular lo que quiere, porque el cliente final no está definido, o porque
la tecnología subyacente todavía no está madura #diapo(3, 9).

#clave[
  El liderazgo de la empresa —no sólo el arquitecto— es quien moldea ese
  contexto amorfo en un plan ejecutable. Lo que hace especialmente desafiante
  la tarea del *arquitecto* es que queda *entre* la estrategia de la empresa
  y la definición del producto: tiene que hablar los dos idiomas con
  competencia #diapo(3, 9).
]

== Dos ideas, no una: borrosidad e incertidumbre

Hablando estrictamente, la #t[ambigüedad] se compone de dos ideas. En el uso
común se le suman información incorrecta, faltante o conflictiva
#diapo(3, 9).

#definicion("borrosidad")[
  Ocurre cuando un evento o estado está sujeto a *múltiples
  interpretaciones*. Un color puede ser borroso: si es azul o púrpura se
  interpreta distinto según quién lo mire. La falta de claridad es
  *rampante* en las declaraciones de necesidades de un cliente — pedir un
  acabado "suave" o "buen" rendimiento de combustible — y está influida por
  el *contexto*: qué es "buen rendimiento" depende de dónde esté el cliente.
  #diapo(3, 9) #diapo(3, 10)
]

#definicion("incertidumbre")[
  Ocurre cuando el resultado de un evento *no está claro o es objeto de
  duda*. El resultado de tirar una moneda es incierto: se pueden articular
  claramente los estados posibles, pero no se sabe cuál va a ocurrir. Una
  nueva tecnología puede o no estar lista a tiempo para un producto.
  #diapo(3, 10)
]

#cuidado[
  La distinción que se pregunta: la borrosidad es sobre *cómo se interpreta*
  algo que ya se conoce (¿este color es azul o púrpura?); la incertidumbre es
  sobre *qué va a pasar* con algo cuyos estados posibles ya se conocen (¿va a
  estar lista la tecnología?). Las dos son ambigüedad, pero apuntan a
  preguntas distintas.
]

== Información desconocida, conflictiva y falsa

Para complicar más las cosas, hay tres fenómenos relacionados. La cátedra los
ilustra con la notación (X, Y, Z), donde X, Y, Z son las entradas
*verdaderas* al sistema #diapo(3, 10):

#figure(
  table(
    columns: (1fr, 2.2fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Tipo*], [*Qué pasa, con el ejemplo de la notación*]),
    [*Desconocida* — (X, \_\_, Z)], [La información no está determinada o no está disponible. Un *conocido desconocido*: sabés que falta (no sabés si tu competidor lanzará un producto). Un *desconocido desconocido*, más peligroso: ni siquiera sabés que falta (un competidor nuevo que ni considerabas).],
    [*Conflictiva* — (X, D, Z) y (X, B, Z)], [Dos o más piezas de información ofrecen indicaciones opuestas — el problema está *sobre-determinado*. Una fuente dice que habrá una regulación nueva; otra dice que no.],
    [*Falsa* — (F, Y, Z)], [Se presentan entradas *incorrectas*. Creés que tenés toda la información, pero una parte está mal — un proveedor que en teoría cumple una fecha, y en los hechos nunca tuvo plan de cumplirla.],
  ),
  caption: [Los tres fenómenos que complican la ambigüedad, con la notación (X, Y, Z) de entradas verdaderas #diapo(3, 11).],
)

#posta[
  Ejercicio de reconocimiento, tal como lo plantea la cátedra #diapo(3, 12):
  "¿será niño o niña?" es incierto y borroso; "producto de alta calidad y
  bajo costo" es conflictivo, borroso y desconocido a la vez; "cada cuarto
  año es bisiesto" es directamente *falso*; "una cubierta suave para el
  teléfono" es borroso; "cumplir los objetivos trimestrales" es desconocido y
  conflictivo. Ninguna frase agota un solo tipo — identificar *cuáles*
  aplican, y por qué, es la forma en que se pregunta.
]

== Dónde vive la ambigüedad: las influencias ascendentes

La ambigüedad está presente casi siempre en las *influencias ascendentes*,
segmentadas por función corporativa: estrategia (¿cuánto riesgo asume la
empresa?), marketing (¿se ajusta al posicionamiento planeado?), clientes
(¿qué quieren, y va a cambiar?), fabricación (¿va a estar lista?),
operaciones (¿qué fallas debe tolerar?), I+D (¿la tecnología es infusible?),
regulaciones y estándares (¿cuáles aplican, y van a cambiar?)
#diapo(3, 12) #diapo(3, 13). Para cada una, la información que le llega al
arquitecto puede ser borrosa, incierta, faltante, conflictiva o falsa.

#definicion("principio de ambigüedad")[
  La fase inicial de un diseño de sistema se caracteriza por una gran
  ambigüedad. El arquitecto debe resolver esta ambigüedad para producir —y
  actualizar continuamente— los objetivos del equipo del arquitecto.
  #diapo(3, 14)
]

#cuidado[
  Cinco consecuencias del principio, y son las que se preguntan sueltas
  #diapo(3, 14):
  - El desarrollo es posible *sólo con la aceptación* de la incertidumbre.
  - *Nadie diseña ni controla* de manera rigurosa el proceso previo a la
    arquitectura — no hay que esperar ausencia de ambigüedad: habrá insumos
    incompletos, superpuestos y en conflicto.
  - La incertidumbre *puede crear oportunidades*; no siempre es mala.
  - La ambigüedad contiene incógnitas conocidas y desconocidas, además de
    suposiciones en conflicto y falsas.
  - La ambigüedad es especialmente evidente en la interfaz con las
    influencias ascendentes, *porque nadie diseña los procesos ascendentes*.
]

== Las influencias ascendentes y descendentes

#definicion("influencias ascendentes y descendentes")[
  Las #t[influencias ascendentes] son lo que llega al arquitecto desde antes
  de que se involucre: problemas, oportunidades, necesidades, estrategia,
  regulaciones. Las #t[influencias descendentes] son lo que el sistema
  produce hacia abajo y hacia adelante. *Nadie diseña las ascendentes*, y por
  eso son la fuente principal de ambigüedad. #diapo(3, 15)
]

#deduccion("por qué el arquitecto no puede esperar a que las influencias ascendentes se aclaren solas")[
  Es tentador pensar que las influencias ascendentes —estrategia
  corporativa, marketing, la junta, el cliente, el gobierno— *tienen* el
  conocimiento que reduciría la ambigüedad, o la responsabilidad de comentar
  los primeros borradores del arquitecto. La cátedra es explícita: eso es un
  error. Las influencias ascendentes simplemente *ocurren*, a menudo
  incompletas, superpuestas o en conflicto entre sí #diapo(3, 15). El
  arquitecto tiene que *participar* en ellas y eliminar la ambigüedad por su
  cuenta, sabiendo quién tiene el control de cada una y cómo comprometerse
  con ella — no esperar que alguien se la resuelva de antemano.
]

#posta[
  En algunos casos la ambigüedad se reduce con análisis; en otros, se elige
  imponer una restricción para hacer el problema manejable; y a veces hace
  falta una *suposición* para poder seguir trabajando — siempre marcándola
  bien, para verificarla después #diapo(3, 13). Eliminar, reducir y resolver
  la ambigüedad en la interfaz con el proceso ascendente es, en una frase, la
  función principal del arquitecto.
]
