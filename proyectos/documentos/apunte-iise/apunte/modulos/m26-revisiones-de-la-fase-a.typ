#import "../plantilla.typ": *

#modulo(
  "Las dos revisiones técnicas de la Fase A: SRR y MDR",
  [Explicar qué gestión de riesgo y recursos corre durante toda la Fase A; y
   distinguir con precisión qué evalúa la Revisión de Requerimientos de
   Sistema (SRR) de qué evalúa la Revisión de Diseño de Misión (MDR),
   incluyendo qué le pasa a las acciones abiertas de una revisión cuando
   llega la siguiente.],
  clave: "revisiones-de-la-fase-a",
)

#lectura[
  Clase 7, diapositivas 31 y 33 a 45.
]

== Gestión de riesgo y de recursos, durante toda la fase

#clave[
  La Fase A no es sólo técnica: la ingeniería de sistemas gestiona en
  paralelo todos los procesos de riesgo, los roles y responsabilidades del
  equipo, y los recursos —masa, potencia, costos y planificación— para que
  el desarrollo se mantenga dentro de lo comprometido. Las herramientas de
  gestión se ponen en funcionamiento *en esta fase*, no después: llegar a
  la Fase B sin ellas deja a la Fase B gestionando riesgo con datos
  incompletos.
]

#posta[
  También es la fase donde se identifican las alternativas de subsistema
  que compiten entre sí —por ejemplo, dos o tres arquitecturas de
  propulsión posibles— y se elige la que mejor combina requerimientos,
  costos, planificación y desempeño. La pregunta que resume la fase entera:
  *¿cuál de estas propuestas encuentra los requerimientos de costo,
  desempeño y plazo de entrega de la mejor manera?*
]

== SRR: la primera revisión técnica

#definicion("SRR — Revisión de Requerimientos de Sistema")[
  La primera de las dos revisiones técnicas primarias de la Fase A, a cargo
  de un equipo técnico *externo*. Confirma que los requerimientos de alto
  nivel están claramente definidos y ajustados a los objetivos de los
  interesados, que fluyeron correctamente hacia abajo; que las interfaces
  internas y externas están definidas; que los riesgos del desarrollo están
  identificados con un plan para abordarlos; y que existe un Plan de
  Gestión de la Ingeniería de Sistemas y un plan *inicial* de Verificación y
  Validación. Establece el #t[baseline] de los Requerimientos de Sistema.
]

#cuidado[
  *El plan de V&V que exige la SRR es inicial, no definitivo* — tiene que
  ser preciso "requerimiento por requerimiento" recién más adelante. Pedirle
  a la SRR un plan de V&V completo es exigirle a la primera revisión el
  nivel de detalle de la segunda.
]

== MDR: la segunda revisión técnica

#definicion("MDR — Revisión de Diseño de Misión")[
  La segunda revisión técnica primaria de la Fase A, posterior a la SRR.
  Evalúa si el concepto *baseline* —ya más maduro y con más detalle— es
  razonable, alcanzable y completo; si es consistente con los recursos
  disponibles (masa, potencia) y con costos y planificación; si los riesgos
  mayores están identificados con estrategias de mitigación; y si los
  planes de maduración tecnológica están en curso para terminar en la Fase
  B. Establece el #t[baseline] *Funcional*.
]

#cuidado[
  La diapositiva que resume el ciclo de vida del proyecto llama a esta
  misma revisión *System Definition Review* (SDR/MDR) — la cátedra usa las
  dos siglas para la misma revisión, sin distinguirlas. No es un error del
  apunte: es una inconsistencia real de la fuente, y vale saberla para no
  sorprenderse si el material de estudio la nombra de las dos formas.
]

#figure(
  table(
    columns: (1.3fr, 2.7fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    [*Revisión*], [*Qué confirma, y qué baseline deja*],
    [SRR], [Requerimientos de alto nivel definidos y trazables; interfaces internas/externas definidas; riesgos identificados con plan; V&V inicial. → *Baseline de Requerimientos de Sistema*.],
    [MDR], [Concepto baseline razonable, alcanzable y completo; consistente con recursos y programa; riesgos mayores con mitigación; tecnologías madurando a tiempo para la Fase B. → *Baseline Funcional*.],
  ),
  caption: [Las dos revisiones técnicas primarias de la Fase A, una al lado de la otra (diapositivas 41, 44 y 45).],
)

== Las acciones abiertas no se pierden entre revisiones

#deduccion("por qué cada revisión mira hacia atrás antes de mirar hacia adelante")[
  Después de la SRR, el equipo revisor asigna *acciones* (_action items_) a
  los diseñadores. En la MDR, antes de evaluar lo nuevo, el equipo revisa
  primero si esas acciones de la revisión anterior están *cerradas*. La
  MDR, a su vez, asigna sus propias acciones, que se revisan en la
  siguiente instancia. Ninguna revisión evalúa el sistema en el vacío:
  cada una hereda la deuda pendiente de la anterior.
]

#posta[
  Esto es la misma lógica del #t[baseline] aplicada al *proceso* de
  revisión, no sólo al producto: un baseline sin control de cambios no
  sirve de nada, y una revisión sin seguimiento de sus propias acciones
  tampoco. "Cerrar una acción" es, literalmente, actualizar el baseline del
  propio proceso de revisión.
]
