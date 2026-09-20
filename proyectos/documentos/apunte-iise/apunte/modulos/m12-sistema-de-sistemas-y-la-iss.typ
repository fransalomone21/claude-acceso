#import "../plantilla.typ": *

#modulo(
  "Sistema de sistemas, con la ISS como caso real",
  [Definir #t[sistema de sistemas (SoS)] con sus ocho características;
   distinguirlo de un sistema simplemente grande; y recorrer la Estación
   Espacial Internacional como el ejemplo real de un SoS, con sus seis
   centros de control y sus seis naves de transporte.],
  clave: "sistema-de-sistemas-y-la-iss",
)

#lectura[
  Clase 4, diapositivas 19 a 40.
]

== Qué es un sistema de sistemas

#definicion("sistema de sistemas (SoS)")[
  Un problema interdisciplinario de *gran escala* que involucra sistemas
  múltiples, heterogéneos y distribuidos. #diapo(4, 20)
]

#cuidado[
  Las ocho características que la cátedra enumera, citando el INCOSE SE
  Handbook, y que son la forma en que se pregunta #diapo(4, 20):
  - Elementos del sistema que operan *independientemente*.
  - Elementos con *diferentes ciclos de vida* — no se diseñan, construyen ni
    se retiran juntos.
  - Los requerimientos iniciales son *probablemente ambiguos*.
  - La *complejidad* es el factor más importante.
  - La *gestión* (management) puede *oscurecer* la ingeniería.
  - *Límites difusos* causan confusión.
  - La ingeniería de un SoS *nunca termina*.
]

#clave[
  Lo que distingue a un #t[sistema de sistemas] no es el tamaño: es que sus
  elementos *ya eran sistemas completos y operativos por su cuenta*, con
  dueños, presupuestos y ciclos de vida propios, *antes* de juntarse. Un
  satélite grande con muchos subsistemas complejos no es, por eso solo, un
  SoS — lo sería si esos subsistemas fueran, cada uno, operados
  independientemente por organizaciones distintas.
]

== El ejemplo real: la Estación Espacial Internacional

La ISS creció en complejidad a partir de cuatro estaciones espaciales
anteriores #diapo(4, 22) #diapo(4, 23), y lo que se ve del vehículo en
órbita es *sólo una parte* del sistema completo — hay todo un sistema de
sistemas detrás #diapo(4, 25).

=== Seis centros de control, en cuatro continentes

#figure(
  table(
    columns: (1.6fr, 1fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Centro de control*], [*Dónde*]),
    [Payload Operations Control Center], [Alabama, EE. UU.],
    [Space Network Operations Center], [White Sands, Nuevo México, EE. UU.],
    [Mission Control Center Houston], [Texas, EE. UU.],
    [Space X Mission Control Center], [Florida, EE. UU.],
    [Columbus Control Center], [Alemania],
    [Mission Control Center Moscú], [Rusia],
    [Kibo Control Center], [Japón],
  ),
  caption: [Los centros de control que operan la ISS en conjunto, uno por agencia o función #diapo(4, 26).],
)

#deduccion("por qué esto es un SoS y no simplemente un satélite grande")[
  Cada uno de estos centros pertenece a una organización *distinta*, con su
  propio ciclo de operación, su propio personal y su propio presupuesto —
  ninguno le reporta jerárquicamente a los otros. Coordinarlos para que la
  estación opere como una unidad es exactamente el problema que un SoS
  plantea: *miles de personas* de organizaciones independientes tienen que
  hablar el mismo idioma técnico #diapo(4, 40). Un satélite con muchos
  subsistemas complejos pero *un solo dueño y un solo centro de control* no
  presenta este problema — por eso el tamaño solo no alcanza como criterio.
]

=== Seis naves para transportar gente y carga

Además del segmento de control hay un sistema de transporte —de tripulación
y de carga— que también es heterogéneo y distribuido: la *Soyuz* rusa (y su
versión de carga, *Progress*), la *Dragon* de SpaceX, la *Cygnus* de
Orbital, la *ATV* europea y la *HTV* japonesa #diapo(4, 27) #diapo(4, 36).
Cada una la opera una organización distinta, con su propio ciclo de
desarrollo — la Dragon, por ejemplo, se sumó años después de que el resto
del sistema ya estuviera operando, sin que eso implicara rediseñar el resto.

#posta[
  Ahí está, otra vez, la característica de "elementos con diferentes ciclos
  de vida" del SoS: la ISS no esperó a que las seis naves de transporte
  estuvieran listas a la vez para empezar a operar, y sigue operando
  mientras alguna de ellas se retira o se suma.
]

A esto se agrega un sistema de comunicaciones completo — satélites que bajan
datos a Tierra y enlazan a la tripulación con las estaciones de control
#diapo(4, 39).

== Por qué esto exige procesos estandarizados

#clave[
  Coordinar facilidades desplegadas alrededor del mundo, con miles de
  personas trabajando en ellas, es donde el ingeniero de sistemas cumple su
  papel central. Hace falta *madurar herramientas*, *estandarizar procesos*
  y que todos *hablen el mismo idioma técnico* — los mismos términos,
  entendidos igual por cualquiera #diapo(4, 40).
]

Ese es, en una frase, el motivo de que exista un modelo formal de procesos
de ingeniería de sistemas — el tema de los dos módulos siguientes: primero
cómo se recorre ese proceso en dos ejemplos completos (Space Shuttle y un
rover marciano), y después el modelo formal de NASA con sus 17 actividades.
