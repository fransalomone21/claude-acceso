#import "../plantilla.typ": *

#modulo(
  "Ingeniería concurrente y mecatrónica",
  [Distinguir los tres tipos de gestión del conocimiento en un proyecto
   espacial; explicar por qué la ingeniería concurrente reduce tiempo y
   costo con el ejemplo del Mustang P-51; y ubicar a la mecatrónica y a la
   robótica como subconjuntos de la ingeniería de sistemas espacial.],
  clave: "ingenieria-concurrente-y-mecatronica",
)

#lectura[
  Clase 6, diapositivas 111 a 140.
]

== Tres formas de gestionar el conocimiento de un proyecto

#definicion("ingeniería concurrente")[
  La gestión del conocimiento de un proyecto donde el problema se estudia
  *en conjunto*, con optimización universal y esfuerzo paralelo masivo.
]

#clave[
  La cátedra la contrasta con otras dos formas de organizar el mismo
  trabajo: el *diseño secuencial* —esfuerzo serial, con largos períodos de
  iteración entre disciplinas que no se hablan hasta que les toca el turno—
  y el *diseño centralizado* —una sola autoridad de diseño coordinando
  desde arriba. La ingeniería concurrente es la tercera vía: todas las
  disciplinas en la misma sala, al mismo tiempo, sobre el mismo modelo.
]

#deduccion("el Mustang P-51: la ingeniería concurrente antes de tener nombre")[
  El método nació durante la Segunda Guerra Mundial: North American
  Aviation diseñó el avión de combate P-51 Mustang en *102 días*, y del
  concepto a la producción completa tardó *nueve meses*. La técnica formal
  recién se generalizó en la década del 80, catalizada por la aparición del
  CAD — pero el principio (todas las disciplinas trabajando en paralelo
  sobre el mismo problema) ya estaba probado cuarenta años antes.
]

#posta[
  Hoy la ingeniería concurrente está difundida en automóviles (Ford, BMW,
  Volvo), diseño de aviones, construcción civil y, por supuesto, el área
  espacial. Casi todas las agencias espaciales grandes tienen su propia
  instalación dedicada: el *Team X* / *Project Design Center* de JPL
  (1996), el *IMDC* de Goddard, el *Concept Design Center* de Aerospace
  Corporation (1995), el *CDF* de ESTEC, y equivalentes en la ESA (19
  centros), JAXA, DLR, CNES y ASI.
]

#clave[
  Los beneficios medidos no son marginales: la cátedra reporta una
  reducción de *alrededor de 4 veces* en el tiempo de diseño y de
  *alrededor de 2 veces* en el costo estándar, además de menos errores de
  diseño —detectados antes, cuando corregirlos todavía es barato— y una
  mayor consistencia del diseño de misión completo.
]

== Mecatrónica y robótica

#definicion("mecatrónica")[
  La disciplina que integra mecánica, electrónica e informática/control en
  un mismo producto. Junto con la *robótica*, es un subconjunto de las
  temáticas de la ingeniería de sistemas espacial.
]

#posta[
  La cátedra da ejemplos de cada lado: la *mecatrónica* incluye desde un
  sistema de frenos antibloqueo (ABS) o un reproductor de CD hasta un
  vehículo submarino no tripulado; la *robótica* incluye rovers
  planetarios, robots caminantes, robots industriales, manipuladores
  teleoperados y vehículos controlados remotamente. La línea entre las dos
  no siempre es nítida — un rover planetario es, a la vez, mecatrónica y
  robótica.
]

#deduccion("el mismo diagrama en V, en otra industria")[
  El *Diagrama V&V Genérico* que usa la industria mecatrónica —análisis,
  diseño preliminar, diseño fino, integración, verificación, validación,
  repetido en los niveles de sistema, subsistema y realización de partes—
  es, otra vez, la misma estructura del #t[diagrama en V] de la unidad 5 y
  del #t[modelo Vee] de este módulo. La ingeniería de sistemas espacial no
  inventó el diagrama en V: lo comparte con cualquier disciplina que integre
  mecánica, electrónica y software bajo el mismo producto.
]

#clave[
  El *VEE Development Model* que usa específicamente la industria del
  software es, por la misma razón, un caso particular más: la variante de
  software del #t[diagrama en V] que la unidad 5 ya mostró con las siglas
  URD/SRD/ADD/DDD y los planes SVVP.
]

#posta[
  La recomendación de la cátedra es leer la guía estándar de diseño de
  productos mecatrónicos — no porque el apunte vaya a examinar mecatrónica
  en detalle, sino porque confirma algo importante: los principios de esta
  materia no son exclusivos del espacio. Son los mismos principios que
  cualquier producto que integre varias disciplinas técnicas tiene que
  resolver.
]
