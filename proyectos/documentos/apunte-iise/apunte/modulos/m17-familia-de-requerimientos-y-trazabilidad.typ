#import "../plantilla.typ": *

#modulo(
  "La familia de los requerimientos: semántica, tipos y trazabilidad",
  [Distinguir un requerimiento ("shall") de un hecho ("will") y de una meta
   de diseño ("should"); reconocer los seis tipos de requerimientos con el
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

De ese alcance salen los tipos de requerimientos que la cátedra distingue, y
los ilustra todos con el mismo ejemplo — el control de vector de empuje (TVC)
del Ares I — para que la diferencia esté en la *categoría* y no en el sistema:

#definicion("tipos de requerimientos")[
  *Funcionales* — qué función debe cumplirse. *De performance o desempeño*
  — el grado de esa funcionalidad. *De restricción* — no negociables en
  costo, programación o desempeño. A éstos se suman los *de interfaz* —
  cómo un ítem se conecta con otro—, los *ambientales* — las cargas que el
  diseño debe soportar— y una sexta categoría abierta, *otros*: factor
  humano, confiabilidad, seguridad. #diapo(5, 60)
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
    [Otros], [Factor humano, confiabilidad, seguridad: la categoría abierta, que la cátedra deja nombrada sin ejemplo propio.],
  ),
  caption: [Los seis tipos de requerimientos, con el mismo sistema (TVC) en los cinco primeros ejemplos #diapo(5, 60).],
)

#cuidado[
  La sexta fila es la que se olvida al enumerar, porque la diapositiva la
  escribe al pie y sin ejemplo — pero *está*, y una respuesta que liste cinco
  categorías está incompleta. Vale como regla de estudio: cuando una lámina
  cierra con un «etc.», ese «etc.» es parte de la lista.
]

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

== Los niveles de los requerimientos: L0, L1, L2…

El ejemplo del radar ya mostró la escalera entera. Esta sección la pone en
limpio: qué quiere decir cada número, cómo se reconoce el nivel de un
requerimiento suelto, y cómo se ve la misma escalera en un proyecto chico —el
cohete de agua— y en el manual de NASA.

#definicion("nivel de un requerimiento (L0, L1, L2…)")[
  El escalón de la #t[jerarquía del sistema] sobre el que habla el
  requerimiento. El número *crece hacia abajo*: L0 es el tope (la misión) y
  cada requerimiento de nivel $n$ es *hijo* de uno de nivel $n - 1$, del que
  sale y al que tiene que poder seguirse por #t[trazabilidad]
  #diapo(5, 38).
]

#figure(
  table(
    columns: (0.7fr, 1.3fr, 5fr),
    align: (center, left, left),
    inset: 5pt,
    table.header([*Nivel*], [*Habla de*], [*Qué contesta*]),
    [—], [la necesidad], [Qué quiere el cliente, en su idioma. *Todavía no es un requerimiento*: no se puede verificar tal como está escrita.],
    [L0], [la misión], [Qué tiene que *lograr* la misión. Es el tope y lo fija quien encarga el proyecto.],
    [L1], [el sistema], [Qué tiene que *hacer* el sistema completo y *cuán bien*, en números verificables.],
    [L2], [el segmento], [Qué le toca a cada gran bloque: segmento de vuelo, de tierra, de lanzamiento.],
    [L3], [el elemento], [Qué le toca a cada vehículo o módulo dentro del segmento (el Módulo Lunar).],
    [L4], [el subsistema], [Qué le toca a cada función del elemento: potencia, térmico, acople.],
    [L5], [el componente], [Qué tiene que cumplir cada equipo que se compra o se fabrica (el radar).],
    [L6], [la parte], [Qué tiene que cumplir cada pieza (el motor de la antena).],
  ),
  caption: [La escalera de niveles con los nombres de la cátedra #diapo(5, 38). Los ejemplos entre paréntesis son los del radar de acople del Apollo.],
)

#clave[
  El nivel lo decide *de qué caja de la jerarquía habla* el requerimiento, no
  cuán detallado está escrito. Es la «R» de SMART, *relevante*: un
  requerimiento sobre las celdas solares no va a nivel de sistema
  (_spacecraft_) sino al del subsistema que las contiene #diapo(6, 70). Y un
  requerimiento sin padre en el nivel de arriba es un *huérfano*: hay que
  evaluar si hace falta #diapo(6, 70).
]

=== Asignados y derivados: las dos maneras de nacer de un hijo

El manual de NASA distingue dos orígenes para los requerimientos de un nivel
de abajo. No es vocabulario de la cátedra: sale del _NASA Systems Engineering
Handbook_ (SP-2016-6105 Rev2, §4.2.1.2, figura 4.2-3 y glosario), y se agrega
porque explica *por qué* un hijo puede decir cosas que su padre no dice.

/ Asignado (_allocated_): el valor del padre se *reparte* entre los hijos.
  Los 40.823 kg del segmento de vuelo Apollo (L2) se dividen entre los módulos
  (L3): ningún módulo inventa su masa, la recibe.
/ Derivado (_derived_): el hijo *aparece* por una restricción, por algo
  implícito que el nivel de arriba no dijo, o por la arquitectura y el diseño
  que se eligieron. El padre no lo contiene; lo contiene la decisión de diseño.

#figure(
  table(
    columns: (1fr),
    align: center,
    inset: 3pt,
    stroke: none,
    [Autoridad de la misión], [↓],
    [Objetivos de la misión], [↓],
    [Requerimientos de la misión], [↓],
    [Requerimientos funcionales del sistema], [↓],
    [Requerimientos de performance del sistema], [↓],
    [Requerimientos funcionales y de performance de los subsistemas A, B, C…], [↓],
    [cada uno con sus requerimientos *asignados* y *derivados*],
  ),
  caption: [La bajada de requerimientos según NASA (_The Flowdown of Requirements_, SP-2016-6105 Rev2, figura 4.2-3, p. 57). A los costados del eje el manual pone lo que entra en cada escalón sin ser un requerimiento padre: costo, cronograma, restricciones institucionales, supuestos y normas de diseño.],
)

#ejemplo("tres requerimientos reales del manual de NASA", nivel: "a-fondo")[
  La figura 4.2-2 del mismo manual (p. 56) muestra de dónde viene cada
  requerimiento y quién es su dueño, con un ejemplo por clase:

  - *Programático, impuesto por el programa:* «al menos un elemento mayor
    deberá ser provisto por la comunidad internacional». No dice nada técnico
    y aun así condiciona la arquitectura entera.
  - *Técnico, que baja del programa al proyecto:* «la nave deberá proveer
    capacidad de reingreso directo a la Tierra a 11.500 m/s o más». Nace
    arriba y se reparte hacia abajo: protección térmica, estructura,
    trayectoria.
  - *Técnico, impuesto por la autoridad técnica:* «el sistema deberá tener un
    factor de seguridad de 1,4». No sale de la misión sino de las normas de
    NASA, y rige igual para todos los proyectos.

  Los tres tienen *un solo «deberá»* (_shall_) por oración, que es la regla
  que el mismo manual fija en §4.2.1.2.3.
]

#notacion[
  Los números de nivel son *relativos al tope del proyecto*, no absolutos. En
  la escalera de la cátedra L0 es la misión y L1 el sistema #diapo(5, 38).
  En los documentos de proyectos de NASA es común que «Level 1» nombre a los
  requerimientos que el programa (la Dirección de Misión) le *impone* al
  proyecto, y que el proyecto numere desde ahí para abajo. Y en un proyecto
  chico, como el cohete de agua de abajo, el tope queda mucho más cerca de la
  electrónica. Lo que no cambia en ningún caso es la regla: *cada hijo traza
  a un padre del nivel de arriba*.
]

#ejemplo("el cohete de agua: necesidades, L0 y L1", nivel: "a-fondo")[
  El TP: una computadora de vuelo (ESP32-C3 con un sensor de presión BMP280)
  que reconoce sola las fases del vuelo de un cohete de agua y dispara dos
  paracaídas — el de frenado en el apogeo y el principal a 250 m en el
  descenso. *Misión:* crear un demostrador tecnológico que opere como
  computadora de vuelo del cohete. Lo que sigue es la versión del TP
  *después* de la corrección del docente (los errores de las anteriores van
  justo abajo), con los padres ordenados contra esta tabla de necesidades.

  *Necesidades* — en el idioma del cliente, todavía sin números verificables —
  y la *restricción* que pone el cliente, que no sale de ningún _trade_ y no
  se discute:

  #table(
    columns: (1fr, 7fr),
    inset: 4pt,
    [N-01], [Detectar las fases del vuelo: tierra, ascenso, apogeo, descenso y aterrizaje.],
    [N-02], [Activar en el apogeo un paracaídas de frenado.],
    [N-03], [Activar el paracaídas principal a los 250 m durante el descenso.],
    [N-04], [Recuperar el cohete, para que pueda volver a volar después del aterrizaje.],
    [R-01], [_Restricción:_ el sistema va dentro de la estructura del cohete que el cliente ya tiene.],
  )

  *Nivel 0* — qué tiene que lograr el sistema, *sin un solo número*: el «cuán
  bien» es trabajo del L1. Cada uno traza a una necesidad o a la restricción:

  #table(
    columns: (1.4fr, 1.3fr, 6fr),
    inset: 4pt,
    table.header([*ID*], [*Padre*], [*Requerimiento*]),
    [REQ-L0-1], [R-01], [El sistema deberá alojarse dentro de la estructura del cohete provista por el cliente.],
    [REQ-L0-2], [N-01], [El sistema deberá detectar las fases del vuelo.],
    [REQ-L0-3], [N-02, N-03], [El sistema deberá comandar el despliegue de los paracaídas.],
    [REQ-L0-4], [N-04], [El sistema deberá ser recuperable \[TBR: qué cuenta como recuperable\].],
  )

  *Nivel 1* — qué tiene que hacer el sistema para cada logro y cuán bien, en
  números verificables. Lo que todavía no se sabe no se inventa: va como
  \[TBD\] o \[TBR\], a la vista. Cada uno traza a un L0:

  #table(
    columns: (1.5fr, 1.4fr, 6fr),
    inset: 4pt,
    table.header([*ID*], [*Padre*], [*Requerimiento*]),
    [REQ-L1-1.1], [REQ-L0-1], [El sistema deberá ocupar un volumen máximo de \[TBD\] mm × \[TBD\] mm × \[TBD\] mm.],
    [REQ-L1-1.2], [REQ-L0-1], [El sistema deberá tener una masa máxima de \[TBD\] g.],
    [REQ-L1-2.1], [REQ-L0-2], [El sistema deberá identificar el inicio del vuelo.],
    [REQ-L1-2.2], [REQ-L0-2], [El sistema deberá identificar la fase de ascenso.],
    [REQ-L1-2.3], [REQ-L0-2], [El sistema deberá identificar el apogeo.],
    [REQ-L1-2.4], [REQ-L0-2], [El sistema deberá identificar la fase de descenso.],
    [REQ-L1-2.5], [REQ-L0-2], [El sistema deberá identificar el aterrizaje.],
    [REQ-L1-3.1], [REQ-L0-3], [El sistema deberá generar la orden de despliegue del paracaídas de frenado dentro de los \[TBD\] s posteriores a la detección del apogeo.],
    [REQ-L1-3.2], [REQ-L0-3], [El sistema deberá generar la orden de despliegue del paracaídas principal al descender a 250 m ± \[TBD\] m de altitud sobre la referencia de lanzamiento.],
    [REQ-L1-4.1], [REQ-L0-4], [\[TBR\] — falta definir el criterio de recuperabilidad.],
  )

  *Una cadena completa, leída de abajo hacia arriba:* #box[REQ-L1-3.2] (250~m ±
  \[TBD\]~m) existe porque #box[REQ-L0-3] pide comandar los paracaídas, y #box[REQ-L0-3]
  existe porque N-03 pide abrir el principal a los 250~m. Fijate por dónde
  viaja el número: lo dice el cliente en la necesidad, *salta* el L0 —que
  sólo dice qué se logra— y reaparece en el L1, ya con su tolerancia y
  verificable. Si alguien pregunta «¿por qué 250~m?», la respuesta está
  arriba de todo: lo pidió el cliente. Y #box[REQ-L1-4.1] muestra el otro lado: si
  el padre todavía no se puede verificar, el hijo lo dice con un TBR en vez
  de inventar un número.

  *Asignados y derivados, en el mismo TP:* los cinco hijos de #box[REQ-L0-2] son
  *asignados*: «detectar las fases del vuelo» se reparte en cinco pedazos
  —del inicio del vuelo al aterrizaje—, uno por hijo, y ninguno agrega nada
  que el padre no contuviera. Lo mismo #box[REQ-L1-3.1]
  y #box[REQ-L1-3.2], que se reparten los dos paracaídas de #box[REQ-L0-3]. La masa
  máxima de #box[REQ-L1-1.2], en cambio, es *derivada*: #box[REQ-L0-1] sólo pide que el
  sistema quepa en el cohete y no dice nada del peso; aparece porque un
  sistema pesado le cambia el vuelo al cohete, que es justo lo implícito que
  el nivel de arriba no dijo.
]

#cuidado[
  Tres errores que el TP tuvo en sus primeras versiones, y que son los
  típicos de armar niveles:

  - *Números de desempeño en el L0.* El tope pedía «a no menos de 10 Hz»,
    «dentro de los 200 ms de confirmado el apogeo» y «250 ± 10 m». Eso es el
    *cuán bien*, y el cuán bien es L1. El docente lo corrigió: el L0 quedó en
    lo que se logra —«deberá detectar las fases del vuelo»— y los números
    bajaron a L1, aunque sea como \[TBD\].
  - *Un mismo nombre para un requerimiento y para un nivel.* Los padres se
    llamaban REQ-L1 a REQ-L5 bajo el título «Requerimientos L0», y los hijos
    REQ-L1-01: «REQ-L1» nombraba a la vez un requerimiento suelto y una
    familia entera. El identificador tiene que decir el nivel sin ambigüedad:
    la versión corregida usa REQ-L0-n para el tope y REQ-L1-n.m para sus
    hijos, donde el n dice quién es el padre.
  - *Un hijo que contradice a su hermano.* Un L1 pedía 150 muestras/s, otro
    promediaba 15:1 y un tercero exigía 15 altitudes/s: 150 / 15 = 10, que es
    menos que 15. Cada uno parecía razonable solo; la contradicción se ve
    recién al poner juntos los hijos del mismo padre — que es para lo que
    sirve escribir la trazabilidad.
]

#posta[
  Para ubicar un requerimiento en la escalera, preguntate *de qué caja
  habla*: si habla de lo que tiene que lograr la misión, es L0; si habla del
  sistema entero, L1; si nombra un segmento, un módulo, un subsistema o una
  pieza, bajá tantos escalones como haga falta. Y todo requerimiento tiene
  que poder contestar «¿por qué?» señalando a su padre.
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
