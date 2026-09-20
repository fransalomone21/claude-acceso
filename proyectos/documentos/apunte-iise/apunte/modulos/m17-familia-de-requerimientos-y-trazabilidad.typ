#import "../plantilla.typ": *

#modulo(
  "La familia de los requerimientos: semántica, tipos y trazabilidad",
  [Distinguir un requerimiento ("shall") de un hecho ("will") y de una meta
   de diseño ("should"); reconocer los cinco tipos de requerimientos con el
   ejemplo del TVC; y seguir un requerimiento a través de seis niveles de
   trazabilidad con el radar de acople del Apollo.],
  clave: "familia-de-requerimientos-y-trazabilidad",
)

#lectura[
  Clase 5, diapositivas 23 a 48.
]

== Qué más es un requerimiento

Además de la definición del módulo anterior, la cátedra agrega tres
maneras de mirar a un requerimiento: una *declaración de contratación*, un
documento que define un *espacio de problema*, y un *medio* que se usa para
comunicarse entre quien pide el sistema y quien lo construye.

== La semántica: shall, will, should

#definicion("semántica de los requerimientos (shall / will / should)")[
  Tres verbos con tres funciones distintas en la redacción técnica:
  *"shall" / "deberá"* redacta un requerimiento en sí (*el sistema pesará
  no más de...*); *"will"* redacta una declaración de *hecho*, que suele
  preceder a uno o más requerimientos dentro de un escenario inicial; y
  *"should" / "debería"* redacta una *meta* de diseño, cuantificable pero
  no exigible como un requerimiento.
]

#cuidado[
  Confundir estos tres verbos es confundir *qué se le puede exigir* al
  sistema. Una meta ("debería") no se verifica de la misma manera que un
  requerimiento ("deberá"): fallar una meta no es, por definición, fallar el
  contrato.
]

Emparentado con esto está el *Statement of Work* (SOW): un documento de
gestión de proyecto con la descripción narrativa del trabajo requerido,
actividades, entregables y cronogramas, que suele acompañar a un contrato
de servicio maestro o a un RFP (*Request For Proposal*).

== El ejemplo largo: el Programa Apollo

#ejemplo("de la necesidad al requerimiento funcional, en el Apollo", nivel: "a-fondo")[
  *Necesidad:* contener la amenaza soviética. *Meta:* demostrar la
  superioridad tecnológica de Estados Unidos en el espacio. *Objetivo:*
  hacer un movimiento decisivo en el área espacial. *Misión:* mandar
  humanos a la Luna y retornarlos de manera segura antes de que termine la
  década. *Hipótesis:* todas las necesidades tecnológicas son alcanzables.
  *Restricciones:* hacerlo dentro de la década, con componentes de
  fabricación estadounidense. *Autoridad y responsabilidad:* la NASA es
  responsable de llevar a cabo la misión.
]

#clave[
  Este recorrido —necesidad, meta, objetivo, misión, hipótesis,
  restricciones, autoridad— es el mismo conjunto de *elementos del alcance*
  que se define con precisión al cierre de esta unidad. Acá se ve aplicado a
  un caso; ahí se define cada pieza por separado.
]

De ese alcance salen los tres tipos de requerimientos que la cátedra
distingue con el mismo ejemplo:

#definicion("tipos de requerimientos")[
  *Funcionales* — qué función debe cumplirse. *De performance o desempeño*
  — el grado de esa funcionalidad. *De restricción* — no negociables en
  costo, programación o desempeño. A éstos se suman los *de interfaz* —
  cómo un ítem se conecta con otro— y los *ambientales* — las cargas que el
  diseño debe soportar.
]

#figure(
  table(
    columns: (1.6fr, 2.6fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    [*Tipo*], [*Ejemplo (Thrust Vector Controller, TVC)*],
    [Funcional], [El TVC proveerá control del vehículo en los ejes *pitch* y *yaw*.],
    [Performance / desempeño], [El TVC gimbalará el motor hasta un máximo de 9° ±0,1°.],
    [Restricción], [El TVC no pesará más de 50 kg.],
    [Interfaz], [El TVC interfaceará con el J-2X según el documento de control de interfaces.],
    [Ambiental], [El TVC soportará las cargas vibroacústicas y de shock definidas para Ares I.],
  ),
  caption: [Los cinco tipos de requerimientos, con el mismo sistema (TVC) en los cinco ejemplos (diapositiva 60).],
)

== Requerimiento funcional del Apollo: comunicación

El sistema de radio VHF del Módulo de Comando debía tener comunicación en
los dos sentidos con tres destinos: *(1)* la Tierra, durante las fases
cercanas y con las fuerzas de recuperación en el amerizaje; *(2)* un
astronauta fuera del Módulo de Comando; *(3)* el Módulo Lunar, cuando ambos
están en línea visual.

#clave[
  Cada uno de esos tres destinos exige mirar las *interfaces* entre sistemas
  y confirmar que van a funcionar correctamente — son requerimientos de
  interfaz, que aseguran que cada pieza trabaja acompañada. En todos los
  niveles de la #t[jerarquía del sistema] hay interfaces de algún tipo.
]

El requerimiento de restricción que acompaña a éste: el sistema de radio VHF
debía operar en la región de 250 MHz regulada (alojada) por el gobierno para
comunicación espacial — una restricción por regulación, no por diseño.

== Trazabilidad: seis niveles, un solo objetivo

#definicion("trazabilidad")[
  La propiedad de un requerimiento de bajo nivel de poder seguirse *hacia
  arriba*, hasta el requerimiento de alto nivel del que proviene.
]

#ejemplo("seis niveles de trazabilidad, con el radar de acople del Apollo", nivel: "a-fondo")[
  - *Nivel 0 — misión:* realizar un alunizaje con humanos antes de 1970.
  - *Nivel 1 — sistema:* retornar 45 kg de roca y suelo lunar sin contaminarlos.
  - *Nivel 2 — segmento:* el segmento de vuelo Apollo no superará los 40.823 kg en la inyección a la órbita de transferencia.
  - *Nivel 3 — elemento (Módulo Lunar):* operará 45 horas cerca de la superficie lunar, soportando hasta 93,3 °C durante la luz solar.
  - *Nivel 4 — subsistema (docking):* el Módulo Lunar permitirá un acoplamiento simple y no asistido con el Módulo de Comando en órbita lunar.
  - *Nivel 5 — componente (radar de acople):* trackeará el Módulo de Comando desde 5 pies hasta 400 millas náuticas, con ±1% de precisión.
  - *Nivel 6 — parte:* los motores que mueven la antena del radar la desplazarán a 7°/segundo en todo su rango.
]

#deduccion("por qué la trazabilidad hacia arriba es la que importa")[
  Sin trazabilidad, adquirir cierta clase de radio para el Apollo sería una
  decisión de componente *aislada*. Con ella, cada nivel —hasta el motor que
  mueve la antena a 7°/segundo— sigue estando *fijado por el sistema* y
  responde, en última instancia, a los objetivos que definió la misión. La
  #t[jerarquía del sistema] de la unidad 4 es la estructura; la
  trazabilidad es la propiedad que la recorre de abajo hacia arriba.
]

== Interfaces: la unión Módulo de Comando – Módulo Lunar

#figure(
  image("../figuras/c05-p035.png", width: 78%),
  caption: [El sistema de acoplamiento (docking) real del Programa Apollo — la interfaz física entre el Módulo de Comando/Servicio y el Módulo Lunar.],
)

El Módulo de Comando y el Módulo Lunar debían acoplarse desde múltiples
puntos durante la misión, con ventanas ópticas que permitieran el encuentro
y el acople usando medios visuales.

#posta[
  Construir cada módulo *por separado* no muestra la verdadera dimensión de
  lo que pasa al integrarlos — por eso los requerimientos de interfaz tienen
  que estar definidos lo más temprano posible. Acá aparece, con nombre, la
  distinción *activa / pasiva*:
]

#clave[
  El Módulo Lunar es la interfaz *pasiva*; el Módulo de Comando/Servicio es
  la interfaz *activa* — responsable de enclavar, asegurar la continuidad
  estructural y presurizar la unión una vez acoplados. El equipo que
  construye la parte pasiva no tiene, por diseño, la preocupación de
  interfaz que sí tiene el equipo de la parte activa.
]
