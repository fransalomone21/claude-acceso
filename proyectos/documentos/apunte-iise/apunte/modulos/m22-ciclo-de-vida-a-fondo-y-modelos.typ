#import "../plantilla.typ": *

#modulo(
  "El ciclo de vida a fondo: Pre-Fase A, baseline, y los modelos de desarrollo",
  [Explicar qué produce concretamente la Pre-Fase A y qué revisión la
   cierra; definir baseline como sustantivo y como verbo; y comparar cinco
   modelos de ciclo de vida —cascada, Vee, prototipado rápido, espiral y
   ágil— para saber cuándo conviene cada uno.],
  clave: "ciclo-de-vida-a-fondo-y-modelos",
)

#lectura[
  Clase 6, diapositivas 79 a 91 y 141 a 155.
]

== Pre-Fase A, a fondo

La unidad 5 ya dio las siete fases del #t[ciclo de vida de NASA]. Esta
sección desarrolla la primera de ellas.

#definicion("baseline")[
  Sustantivo y verbo a la vez. Como sustantivo, un conjunto *acordado* de
  requerimientos, diseños o documentos (datos de ingeniería) con control de
  cambios formal. Como verbo, el proceso de establecer ese conjunto. *Cada
  revisión técnica crea un baseline nuevo* del sistema.
]

#clave[
  Un baseline es lo que permite que un equipo entero trabaje con la
  confianza de que todos están usando los mismos requerimientos, diseños,
  restricciones, hipótesis, interfaces y recursos alojados. Sin baselines,
  "la versión con la que estoy trabajando" es una pregunta distinta para
  cada persona del equipo.
]

#ejemplo("qué produce la Pre-Fase A, en concreto", nivel: "a-fondo")[
  El propósito de la Pre-Fase A (Estudio de Concepto) es producir un
  *amplio espectro* de ideas y alternativas para la misión, del cual se
  selecciona el proyecto. Sus actividades: definir necesidades, metas y
  objetivos de la misión; estudiar un rango amplio de conceptos que
  contribuyan a esos objetivos; redactar borradores de requerimientos de
  nivel proyecto y del ConOps; y evaluar preliminarmente las tecnologías
  clave y los riesgos asociados. Cierra mostrando que *al menos un concepto*
  es técnicamente factible dentro de las restricciones de presupuesto y
  planificación — y con la *Mission Concept Review* (MCR), la primera
  revisión técnica externa, que confirma el baseline inicial para la Fase A.
]

#posta[
  El James Webb Space Telescope es el ejemplo de la cátedra para "evaluar
  tecnologías clave desde la Pre-Fase A": un espejo nunca antes construido
  para volar exigió comparar tecnologías distintas e invertir en ensayos
  intensivos para madurar la innovación *antes* de comprometerse a un
  diseño — exactamente lo que la Pre-Fase A existe para hacer.
]

#deduccion("un estudio de concepto real: la exploración de Titán")[
  La cátedra usa una misión hipotética a Titán —con orbitador, _lander_,
  plataforma aérea y hasta un *submarino* para navegar sus mares de
  metano— como ejemplo de qué tan abierto puede ser el "amplio espectro de
  alternativas" de una Pre-Fase A real: varios métodos de exploración
  compitiendo, cada uno con su propio perfil de riesgo tecnológico, todavía
  sin comprometerse a ninguno. No es un caso ya construido, como el Saturno
  V o el Shuttle: es, precisamente, una Pre-Fase A en curso.
]

== Comparación de modelos de ciclo de vida

#posta[
  Hasta acá, "ciclo de vida" significó casi siempre el de NASA. Esta sección
  muestra que NASA es *un* modelo entre varios, y que otras industrias —y
  otras metodologías de desarrollo— organizan el mismo problema distinto.
]

#figure(
  image("../figuras/c06-p085.png", width: 92%),
  caption: [Seis modelos de ciclo de vida lado a lado —ISO 15288, integrador comercial típico, fabricante comercial típico, DoD, NASA y DoE— con sus fases y sus baselines marcados (diapositiva 85).],
)

#clave[
  Todos comparten la misma forma de fondo: un tramo de *estudio y
  definición*, un tramo de *implementación*, y un tramo de *operación* — la
  cátedra ya lo mostró como el #t[CDIO] de la unidad 1. Lo que cambia entre
  industrias es *dónde* ponen los puntos de decisión y *cómo* llaman a cada
  baseline, no la lógica de fondo.
]

=== Modelo cascada

#definicion("modelo cascada")[
  El modelo de desarrollo secuencial "clásico": el flujo se mueve de una
  fase a la siguiente *sólo cuando la anterior está completa y congelada*,
  sin retorno. La variante "modificada" agrega retroalimentación entre
  fases — lo que rompe el principio de fases congeladas de la versión
  clásica.
]

#cuidado[
  La cátedra cita un argumento real de la literatura: *"nunca hubo tal cosa
  como el enfoque cascada (y nunca la hubo)"* — el modelo "clásico", sin
  retroalimentación, casi nunca se usa tal cual en la práctica. Sirve sobre
  todo como *línea de base* contra la que se comparan y contrastan los
  demás modelos, no como receta a seguir literalmente.
]

=== Modelo Vee

#definicion("modelo Vee")[
  Un modelo secuencial de ciclo de vida que resume el concepto de
  verificación y validación a lo largo de todo el desarrollo: mantiene la
  dimensión de tiempo de izquierda a derecha, pero algunas iteraciones se
  capturan como movimientos en un eje vertical. No hay una única definición
  formal, pero la filosofía de fondo es siempre la misma.
]

#clave[
  Esto es, en abstracto, lo que la unidad 5 ya mostró en concreto con el
  #t[diagrama en V] de tres perspectivas. El modelo Vee es la *familia*; el
  diagrama en V del ciclo de vida de NASA es *un miembro* de esa familia,
  con nombres y perspectivas propias.
]

=== Prototipado rápido

Divide un proyecto en partes chicas y las desarrolla de forma iterativa,
usando prototipos —en vez de, o además de, especificaciones de diseño— para
ajustar los requerimientos según lo que se va aprendiendo. Nació en el
desarrollo de interfaces de usuario de software, y hoy está en línea con la
filosofía ágil.

=== Desarrollo en espiral

#definicion("desarrollo en espiral")[
  Un modelo de creación de prototipos *cíclico* que desarrolla la
  definición e implementación del sistema en pasos incrementales,
  disminuyendo el riesgo en cada ciclo. Cada ciclo incluye una revisión que
  garantiza el compromiso de los interesados con la solución en evolución.
]

#figure(
  image("../figuras/c06-p148.png", width: 78%),
  caption: [El modelo espiral de Boehm: cada vuelta agrega un análisis de riesgo, un prototipo más maduro y una revisión, antes de seguir a la siguiente vuelta (diapositiva 148).],
)

#posta[
  La lectura de la espiral es literal: cuanto más lejos del centro, más
  *costo acumulado* y más *madurez* del prototipo. La distancia recorrida en
  cada vuelta no es constante porque el riesgo tampoco lo es — hay vueltas
  que maduran rápido y vueltas que exigen mucho análisis antes de animarse a
  seguir.
]

=== Desarrollo ágil

#definicion("desarrollo ágil (Agile)")[
  Un método que divide un conjunto de objetivos en pasos incrementales
  pequeños, priorizados por el cliente, con planificación mínima,
  entregando en cada paso un sistema o subsistema de trabajo. Se caracteriza
  por equipos multifuncionales trabajando en ráfagas cortas ("*sprints*").
  Incluye metodologías como Programación Extrema (XP), Scrum, DSDM y
  modelado ágil.
]

#cuidado[
  *Combinar modelos no es lo mismo que confundirlos.* Un entorno ágil puede
  funcionar dentro de un marco de gestión de programa más amplio, y un
  proyecto ágil puede correr en paralelo con uno secuencial dentro del mismo
  programa — pero mezclar los dos *sin cuidado* arriesga contaminación
  cruzada entre entornos que necesitan reglas distintas. Tampoco conviene
  forzar un enfoque iterativo en una organización estable de mercados y
  ciclos largos si no encaja con su cultura: la selección del modelo de
  ciclo de vida es, en sí misma, una decisión de ingeniería de sistemas.
]

#deduccion("el eje que separa a los cinco modelos")[
  Cascada prioriza el control y la planificación exhaustiva por sobre la
  velocidad; ágil prioriza la entrega incremental rápida por sobre la
  planificación exhaustiva — son, literalmente, polos opuestos del mismo
  eje. El modelo Vee y el espiral están en el medio: seriales como cascada,
  pero con verificación continua (Vee) o con reducción de riesgo explícita
  por vuelta (espiral). El prototipado rápido comparte con ágil el énfasis
  en el desarrollo por sobre la especificación previa. Ningún modelo es
  "mejor" en abstracto: cada uno calza con un perfil distinto de
  incertidumbre y de tolerancia al riesgo del proyecto.
]
