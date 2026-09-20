#import "../plantilla.typ": *

#modulo(
  "Escribir buenos requerimientos: SMART, reglas, checklist y rationale",
  [Aplicar la sigla SMART para juzgar un requerimiento; usar el formato
   "QUIÉN deberá QUÉ" y el checklist de nueve preguntas para depurarlo;
   escribir la rationale que lo justifica; y aplicar la verificación y la
   validación de requerimientos con sus preguntas y técnicas concretas.],
  clave: "escribir-buenos-requerimientos",
)

#lectura[
  Clase 6, diapositivas 68 a 78.
]

== Los buenos requerimientos son SMART

#definicion("requerimiento SMART")[
  La sigla que resume las cinco cualidades de un buen requerimiento:
  *Específico* (un solo aspecto, en términos de la necesidad —qué y cuán
  bien—, no de la solución), *Medible* (desempeño cuantificable y
  verificable), *Alcanzable* (técnica y económicamente), *Relevante*
  (apropiado para el nivel que se está especificando) y *Trazable* (fluye
  claramente desde un requerimiento padre).
]

#cuidado[
  *Alcanzable no es lo mismo que barato.* El ejemplo de la cátedra: el James
  Webb Space Telescope especificó tempranamente un requerimiento de
  apertura que resultó *técnicamente inalcanzable* dado el mecanismo de
  despliegue elegido — el requerimiento no falló por costo, falló por una
  característica técnica del diseño.
]

#posta[
  *Relevante* también tiene su propio error típico: un requerimiento sobre
  las celdas solares no debería especificarse al nivel de todo el
  *spacecraft* (sistema) si en realidad pertenece al subsistema de potencia.
  Poner un requerimiento en el nivel equivocado de la
  #t[jerarquía del sistema] es tan grave como no escribirlo.
]

== Reglas para una buena escritura

Cada requerimiento tiene tres características *mandatorias*: necesidad,
verificabilidad y ser alcanzable (técnica, económica y temporalmente). Más
allá de eso, cada requerimiento debe expresar *un solo* pensamiento, ser
conciso, positivo, gramaticalmente correcto, entendible de una sola manera
—no ambiguo—, y usar terminología consistente para el sistema y sus partes.

La regla de *trazable* se apoya directo en la
#t[familia de requerimientos (padres, hijos, huérfanos)] del módulo
anterior: un requerimiento sin padre es huérfano, y un huérfano es
justamente lo que la regla de trazabilidad detecta.

El formato recomendado es *"QUIÉN deberá QUÉ"*, en voz activa: *el sistema
deberá operar a...*, *el software deberá adquirir...*, *la estructura
deberá soportar...* La cátedra distingue tres verbos según el tipo de
enunciado: *deberá* para lo obligatorio, *es/hace* para un hecho o
declaración de propósito, y *debería* para una meta o provisión opcional —
la misma semántica shall/will/should de la unidad 5, ahora con el patrón de
redacción explícito.

== El checklist de nueve preguntas

#figure(
  table(
    columns: (1.6fr, 2.6fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    [*Pregunta*], [*Qué evita*],
    [¿Libre de términos ambiguos?], ["según sea apropiado", "y/o", "pero no limitado a"],
    [¿Libre de pronombres indefinidos?], ["este", "estos" sin antecedente claro],
    [¿Libre de términos inverificables?], ["flexible", "amigable", "robusto", "liviano", "adecuado" y otros "-ables"],
    [¿Libre de implementación?], [enunciar el *cómo* en vez del *qué* — la solución en vez del problema],
    [¿Es necesario?], [preguntar "¿por qué hace falta?" para encontrar el requerimiento verdadero],
    [¿Libre de descripciones de operaciones?], [confundir una necesidad del producto con una actividad sobre el producto],
    [¿Libre de TBD?], [dejar algo *sin ningún valor* en vez de estimarlo con un TBR justificado],
  ),
  caption: [El checklist de nueve preguntas para depurar un requerimiento ya escrito (diapositiva 73).],
)

#definicion("TBD / TBC / TBR")[
  Tres marcas para lo indefinido en un requerimiento temprano: *TBD* (*To Be
  Determined/Defined*) — todavía no determinado; *TBC* (*To Be Confirmed*)
  — pendiente de confirmar; *TBR* (*To Be Resolved*) — un valor *estimado*,
  con su rationale, a resolver.
]

#clave[
  Cuanto más tarde se resuelve un TBD, más caro sale — es el mismo argumento
  del costo de cambiar tarde que ya apareció con el rover marciano de la
  unidad 4. La cátedra prefiere explícitamente un *TBR con estimación y
  rationale* por sobre un TBD vacío: un valor estimado y justificado se
  puede empezar a diseñar contra él; un vacío no.
]

== La rationale: por qué existe un requerimiento

#definicion("rationale (de un requerimiento)")[
  La justificación que acompaña a un requerimiento: por qué se necesita,
  qué hipótesis se hicieron, y qué esfuerzo de diseño lo originó. Captura la
  motivación para que el requerimiento se pueda mantener y entender con el
  tiempo.
]

#ejemplo("la altura de un camión, con su porqué", nivel: "a-fondo")[
  *Requerimiento:* "El camión de transporte no tendrá una altura mayor a
  14 pies (4,26 m)." *Rationale:* el 99% de las autopistas interestatales de
  EE.UU. tiene 14 pies o más de espacio libre — con la hipótesis de que el
  camión va a usar principalmente esas autopistas en sus recorridos largos.
]

#deduccion("qué protege la rationale, en un ejemplo espacial")[
  Un requerimiento de la arquitectura *Constellation* obligaba a proveer
  comunicación y rastreo desde antes del lanzamiento hasta la recuperación,
  en *todas* las fases de la misión. La rationale aclara algo que el
  requerimiento por sí solo no dice: los activos terrestres alcanzan
  mientras hay línea de vista con la Tierra, pero *no* durante el alunizaje,
  el ascenso lunar ni las operaciones en el lado oculto de la Luna o los
  polos — para eso hace falta infraestructura adicional (un relay lunar). Y
  aclara además algo igual de importante: *este requerimiento no implica
  cobertura continua* — eso lo van a especificar los requerimientos de
  nivel más bajo. Sin la rationale, alguien podría diseñar de más (cobertura
  continua real) o de menos (ignorar el lado oculto de la Luna).
]

== Verificación y validación, en la práctica

Las definiciones de #t[verificación (de requerimientos)] y
#t[validación (de requerimientos)] ya están en la unidad 5. Acá la cátedra
agrega el *cómo*:

#clave[
  El plan de verificación preliminar no es más que elegir, para cada
  requerimiento, *qué técnica* lo va a verificar: *ensayo* (test),
  *demostración*, *análisis* o *inspección*. Pensarlo temprano confirma que
  el requerimiento es en verdad verificable, define el plan de verificación
  del sistema, e identifica qué facilidades hacen falta para los ensayos de
  subsistema y de sistema.
]

#clave[
  La #t[validación (de requerimientos)] de la unidad 5, en la práctica,
  contesta tres preguntas concretas: *¿Tenemos el problema correcto?
  ¿Nuestros requerimientos capturan ese problema? ¿Son SMART?* La realizan
  expertos en la materia, la organización que construye el sistema y el
  cliente autorizado — no el mismo equipo que escribió los requerimientos.
]

#cuidado[
  La validación tiene un *momento* en el ciclo de vida: usualmente se hace
  *antes* de la revisión de requerimientos de sistema (SRR). Validar después
  de esa revisión es validar un baseline que ya se dio por bueno — el
  momento de la validación importa tanto como su contenido.
]

== Resumen del módulo

#posta[
  SMART juzga un requerimiento ya escrito; el checklist de nueve preguntas
  lo depura línea por línea; la rationale explica por qué existe; y la
  verificación (¿el sistema lo cumple?) y la validación (¿el conjunto de
  requerimientos era el problema correcto?) son las dos preguntas finales,
  hechas en el momento correcto del ciclo de vida — antes del SRR, no
  después.
]
