#import "../plantilla.typ": *

#modulo(
  "El riesgo otra vez, la FRR y la Fase E",
  [Distinguir un riesgo de un problema; usar la tormenta de arena de Marte
   y el accidente del SpaceShipTwo para repasar las capas del riesgo y la
   seguridad como propiedad emergente; enumerar los criterios de entrada y
   de éxito de la FRR; leer la curva de complejidad, creatividad y
   ambigüedad del ciclo; y cerrar el ciclo con la Fase E.],
  clave: "riesgo-frr-y-fase-e",
)

#lectura[
  Clase 13, diapositivas 17 a 43.
]

== El riesgo, otra vez: lo que agrega la clase 13

La segunda parte de la clase repite casi entera la gestión del riesgo de
la clase 10 #diapo(13, 17) a #diapo(13, 32): el riesgo como proceso 13 del
motor de NASA, su definición con tres componentes, las capas del modelo con
la misión a Marte, las categorías en el triángulo de hierro, el ciclo de
cinco pasos y el diagrama de riesgo de NASA con el 1 como peor. Todo eso
está en el módulo #M("gestion-del-riesgo") y no se repite acá. Lo nuevo es
una distinción y dos casos.

#definicion("problema (riesgo materializado)")[
  Un evento que *está ocurriendo ahora*, que no es incierto y que hay que
  tratar de inmediato. Un *riesgo*, en cambio, es un evento futuro, un
  problema potencial, con un nivel de incertidumbre: más de 0 % y menos de
  100 % de chance de ocurrir #diapo(13, 21).
]

#clave[
  *Los riesgos son problemas anticipados; un problema es un riesgo que
  ocurrió; y los problemas pueden crear riesgos nuevos* #diapo(13, 22). El
  ejemplo de la lámina: que la entrega de partes clase «S» (las de calidad
  espacial) sea dudosa en la planificación es un *riesgo*; que las partes no
  hayan llegado es un *problema*; y ese problema trae riesgos nuevos:
  cambios de diseño, más ensayos, corrimientos del calendario, costos de
  _screening_.
]

#cuidado[
  Un riesgo con 100 % de probabilidad ya no es un riesgo: es un problema, y
  no va a la matriz de riesgos sino al plan de acción de hoy. Y uno con 0 %
  no existe. Si en el trabajo práctico aparece un «riesgo» que en realidad
  ya está pasando —un integrante que no puede asistir, un dato que no
  conseguimos—, se trata como problema.
]

=== Un riesgo natural, en vivo: la tormenta de Marte

La capa de afuera del modelo de riesgo son los riesgos *naturales*, como
las tormentas de arena de Marte. La cátedra trae el caso de junio de 2018
#diapo(13, 24) #diapo(13, 25) #diapo(13, 26) #diapo(13, 27): una tormenta
con vientos de 100 km/h que cubría un cuarto del planeta dejó el cielo
«completamente negro» sobre el Opportunity, que llevaba quince años en
Marte —había sido diseñado para 90 días—. Al detectar la falta de energía,
el rover entró en hibernación: apagó todo menos el reloj de la misión, que
lo iba a despertar cuando volviera el Sol. La preocupación era la
temperatura: por debajo de −40 °C la electrónica podía dañarse, y con todo
apagado, calefactor incluido, el rover dependía del ambiente. El
Curiosity, en cambio, no tenía problema: su energía es nuclear.

#deduccion("dos rovers, la misma tormenta, dos consecuencias")[
  Es el caso exacto de la deducción del módulo #M("gestion-del-riesgo")
  sobre los riesgos sin influencia: sobre la tormenta no se puede bajar la
  *probabilidad*; sólo se puede bajar la *consecuencia* desde el diseño. Los
  dos rovers enfrentaron la misma tormenta. El que dependía del Sol quedó a
  merced de ella; el de fuente nuclear siguió trabajando. La decisión de la
  fuente de energía, tomada años antes, fue la mitigación.
]

#cuidado[
  _Lo que la lámina no cuenta:_ la clase cierra el caso con una foto
  titulada «Opportunity sigue vivo» #diapo(13, 27), que es lo que se sabía
  en junio de 2018. El rover no volvió a comunicarse, y NASA dio la misión
  por terminada en febrero de 2019. Si te preguntan cómo terminó la
  historia, terminó así.
]

=== La seguridad, otra vez: el SpaceShipTwo

La lámina sobre la seguridad como propiedad emergente vuelve
#diapo(13, 34), ahora con un caso: el accidente del SpaceShipTwo de Virgin
Galactic. Una investigación de nueve meses de la NTSB (la junta de
seguridad del transporte de EE. UU.) encontró que el copiloto destrabó
demasiado pronto el sistema de frenado, y que el accidente lo causaron el
*error humano y procedimientos de seguridad inadecuados* #diapo(13, 33).

#posta[
  Ningún componente falló: el sistema de frenado hizo exactamente lo que se
  le pidió, en el momento equivocado. El accidente está en la interacción
  entre una persona, un procedimiento y un mecanismo. Es la seguridad como
  propiedad emergente del módulo #M("gestion-del-riesgo") con nombre y
  apellido: *el error humano es el síntoma*; lo que faltaba era un
  procedimiento —o un diseño— que no dejara cometerlo.
]

== La FRR, por dentro

La FRR ya está definida en el módulo #M("fase-d-a-fondo"). La clase 13 la
cuenta como *el último evento antes del lanzamiento*, con tres preguntas:
¿pasamos todas las actividades de V&V con éxito?, ¿hay algún _waiver_ que
no se otorgó?, ¿cuáles son los riesgos residuales? Y después: empezar la
cuenta regresiva #diapo(13, 37).

#figure(
  table(
    columns: (0.3fr, 2.4fr, 0.3fr, 2.4fr),
    align: (center, left, center, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header(table.cell(colspan: 2)[*Criterios de entrada*], table.cell(colspan: 2)[*Criterios de éxito*]),
    [1], [recibir la certificación de que las operaciones de vuelo pueden proceder con riesgo aceptable], [1], [el vehículo está listo para volar],
    [2], [los elementos del sistema y su soporte confirmaron que están configurados y listos para volar], [2], [el _hardware_ se considera aceptablemente seguro para el vuelo: cumple los criterios de riesgo aceptable establecidos, o documentados como aceptables por el _manager_ y la DGA],
    [3], [las interfaces son compatibles y funcionan como se esperaba], [3], [el _software_ de tierra y de vuelo está listo para soportar el vuelo y sus operaciones],
    [4], [el estado del sistema soporta la decisión de lanzar, en un *Go / No Go*], [4], [las interfaces están comprobadas y cumplen su funcionalidad],
    [5], [las fallas y anomalías de vuelos anteriores están resueltas y sus resultados incorporados a los productos operacionales], [5], [los ítems abiertos y los _waivers_ se examinaron y se encontraron aceptables],
    [6], [el sistema está configurado para el vuelo], [6], [los factores ambientales del vuelo y de la recuperación están dentro de las restricciones],
    [], [], [7], [todos los ítems de riesgo de la misión y de seguridad están atendidos («alojados», dice la lámina)],
  ),
  caption: [Los criterios de la FRR #diapo(13, 38).],
)

#clave[
  Fijate que *riesgo aceptable* aparece al principio y al final: la FRR no
  pide riesgo cero, pide riesgo *conocido y aceptado* por quien tiene la
  autoridad. Es el mismo criterio de la CDR («con margen adecuado y riesgo
  aceptable», módulo #M("fase-c-a-fondo")), en el último escalón. Y la
  matriz de funciones clave, que la clase vuelve a mostrar, ubica la FRR
  entre las revisiones de la Fase D #diapo(13, 36).
]

== Dos maneras de mirar el fracaso

#figure(
  placement: auto,
  image("../figuras/c13-p040.png", width: 66%),
  caption: [A lo largo del ciclo (concebir, diseñar, implementar, operar), la *complejidad* del sistema sube, mientras la *creatividad* posible y la *ambigüedad* caen #diapo(13, 40).],
)

La curva #diapo(13, 40) junta tres ideas de la materia en un solo dibujo:
la ambigüedad de la unidad 3 se resuelve al principio, la creatividad
también se juega al principio —después, el diseño ya está atado por todo lo
decidido—, y la complejidad crece hasta la operación. Es el costo de
cambiar tarde de la unidad 4 visto desde otro ángulo: lo que se puede
cambiar barato es justo lo que todavía no está definido.

La clase cierra con una lámina para pensar #diapo(13, 41), que pone dos
frases una al lado de la otra. Gene Kranz, director de vuelo de Gemini,
Apollo y el Shuttle: «_failure is not an option_». Elon Musk, de SpaceX:
«_failure is an option here; if things are not failing, you are not
innovating enough_». Y unas notas: SpaceX *aprende por experiencia* en vez
de intentar anticipar todas las interacciones del sistema; es difícil
construir una cultura de ingeniería creativa y de alto desempeño; y es
*muy fácil arruinar la creatividad con demasiada organización, reglas y
procesos*. La lámina dice que SpaceX logra un buen equilibrio entre
creatividad e ingeniería de sistemas, por agilidad y costo.

#posta[
  La cátedra no elige: deja las dos frases para pensar. Las dos tienen
  razón en su lugar. Con astronautas a bordo, en la FRR, el fracaso no es
  una opción. En un prototipo que existe para aprender, fallar barato y
  temprano es la forma más rápida de encontrar lo que nadie anticipó. La
  ingeniería de sistemas no está en contra de fallar: está en contra de
  fallar *tarde*, cuando cuesta mil veces más.
]

La clase también nombra al _Ingenuity_, el helicóptero que voló en Marte
con el Perseverance, y deja dos enlaces sobre él #diapo(13, 39).

== La Fase E: operar

#definicion("Fase E (operaciones y sostenimiento)")[
  La fase de operaciones normales: el desempeño en operaciones *nominales*
  y de *contingencia* para preservar la salud del _spacecraft_ y asegurar la
  captura de los datos —de ciencia u otros— durante toda la vida operativa
  de la misión, sean cinco años o dos, según lo planificado y aprobado por
  el proyecto, y con el presupuesto aprobado para sostener las actividades
  #diapo(13, 42).
]

#notacion[
  La lámina de la Fase E la titula «Operaciones y Mantenimiento»
  #diapo(13, 42); el ciclo de vida de NASA, «Operaciones y Sostenimiento»
  #diapo(12, 3). Es la misma fase. Ojo con no confundirla con la Fase F, el
  cierre, que es otra (módulo #M("ciclo-de-vida-y-diagrama-en-v")).
]

La última lámina de contenidos es un diagrama de las actividades del
ingeniero de sistemas #diapo(13, 43), y es una V: baja identificando las
necesidades del cliente, especificando los requerimientos del sistema,
evaluando arquitecturas y tecnologías alternativas, eligiendo las
específicas y asignando requerimientos e interfaces a la arquitectura; en
el medio, evaluar la confiabilidad (_dependability_); y sube integrando las
soluciones tecnológicas y los componentes, verificando el sistema como un
todo y validándolo, hasta entregarlo a la ingeniería de abajo.

#posta[
  La materia termina con una V, la misma que la unidad 5 dibujó para el
  ciclo de vida. Allá era un dibujo; ahora cada caja tiene un módulo atrás. Si algo de este apunte tiene que
  quedar, es eso: la ingeniería de sistemas no es ninguna de las cajas, es
  la flecha que las conecta.
]
