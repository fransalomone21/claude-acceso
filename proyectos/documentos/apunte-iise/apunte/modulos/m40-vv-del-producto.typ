#import "../plantilla.typ": *

#modulo(
  "La verificación del producto: el proceso, la matriz y los métodos",
  [Distinguir la verificación y la validación del sistema de las de
   requerimientos, y decir cuándo ocurre cada una; recorrer el proceso de
   verificación y su planificación; armar una fila de la matriz de
   verificación con su criterio de éxito; y elegir el método —inspección,
   análisis, demostración o ensayo— leyendo cómo está escrito el
   requerimiento.],
  clave: "vv-del-producto",
)

#lectura[
  Clase 11 A, diapositivas 1 a 28. La clase 11 llegó en dos presentaciones
  (A y B); se cita cada una con su número de lámina.
]

== La rama que sube

La clase 11 abre con dos láminas que no son de V&V y que conviene no
saltear. La primera es Confucio: «me lo contaron y me olvidé; lo vi y lo
entendí; lo hice y lo aprendí» #diapo("11 A", 2). La segunda redefine el
sistema: *un compuesto integrado de gente, productos y procesos* que provee
una capacidad para satisfacer una necesidad o unos objetivos establecidos
#diapo("11 A", 3). La gente son especialistas de cada subsistema —térmico,
estructuras, potencia, control de actitud— que piensan el sistema como un
producto de _hardware_ y _software_; la ingeniería de sistemas los pone a
trabajar juntos con procesos hasta operar el producto #diapo("11 A", 4).

Después, el temario: procesos de V&V y ejemplos de AIT #diapo("11 A", 5).
Es la rama derecha del #t[diagrama en V]: hasta la clase 10 el apunte bajó
por la izquierda —necesidades, requerimientos, arquitectura, diseño—; ahora
sube, del componente verificado al sistema validado.

#posta[
  La unidad 5 ya definió la verificación y la validación *de
  requerimientos* (módulo #M("verificacion-validacion-y-alcance")) y la 6
  dijo cómo se practican (módulo #M("escribir-buenos-requerimientos")).
  Esta clase no las repite: les agrega el *producto* —el sistema ya
  construido— y el *cómo* se verifica de verdad, con papeles, modelos y
  ensayos.
]

== Verificar y validar, ahora sobre el producto

#figure(
  table(
    columns: (1fr, 1fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    inset: 5pt,
    table.header([*Verificación*], [*Validación*]),
    [¿Fue el producto final realizado *correctamente*?], [¿Fue *correcto* el producto final alcanzado?],
    [Durante el desarrollo.], [Durante o después de la integración.],
    [Comprueba si se cumplen los *requerimientos*.], [Comprueba si se cumplieron los *propósitos de los interesados*.],
    [Típicamente centrada en componentes y subsistemas.], [Típicamente en ambientes de misión, simulados o reales.],
  ),
  caption: [Las diferencias entre verificación y validación, como las pone la cátedra #diapo("11 A", 7).],
)

#definicion("verificación del sistema")[
  *Construir el sistema correctamente* (_building the system right_):
  asegurar que el sistema cumple con sus requerimientos de sistema y está
  conforme a su diseño #diapo("11 A", 12).
]

#definicion("validación del sistema")[
  *Construir el sistema correcto* (_building the right system_): asegurar
  que el sistema hace lo que se supone que tiene que hacer *en su
  ambiente*. Determina la completitud y la corrección del producto final, y
  asegura que va a satisfacer las necesidades reales de los interesados
  #diapo("11 A", 12).
]

#figure(
  placement: auto,
  image("../figuras/c11a-p008.png", width: 72%),
  caption: [Los dos lazos #diapo("11 A", 8). El de *validación* (rojo) sale del análisis de los interesados y vuelve preguntando si las funciones entregadas representan las metas; el de *verificación* (azul) va del conjunto de requerimientos —métrica más valor objetivo— a la solución de diseño, y vuelve preguntando si la meta entregada —métrica más valor entregado— está completa. Abajo, los métodos de verificación.],
)

#deduccion("dos palabras, cuatro preguntas")[
  Verificar y validar se aplican a dos objetos distintos, y cada cruce es
  una pregunta y un momento del ciclo de vida:

  - *validar los requerimientos*: ¿están bien definidos y son lo que
    queríamos? Antes del diseño y durante el diseño de detalle —sobre todo
    en la Fase B, menos en la C—, idealmente completa antes del #t[SRR]
    #diapo("11 A", 11);
  - *verificar los requerimientos*: ¿el sistema los cumple? Se hace en la
    Fase D, como parte del AIT, aunque se prepara desde que se escribe cada
    requerimiento #diapo("11 A", 13);
  - *verificar el sistema*: ¿está construido conforme a su diseño?
  - *validar el sistema*: ¿hace, en su ambiente, lo que los interesados
    necesitaban? Es la última, porque necesita el sistema integrado.

  Por eso la validación de los requerimientos va *temprano*: cuando llegue
  la hora de verificar, se van a verificar los requerimientos correctos. Un
  cambio de requerimientos tarde, en plena verificación y antes del
  lanzamiento, tiene un impacto muy negativo en costo y planificación
  #diapo("11 A", 11). Es el argumento del costo de cambiar tarde de la
  unidad 4, otra vez.
]

La matriz de funciones clave de la ingeniería de sistemas vuelve con la fila
de V&V resaltada #diapo("11 A", 9): *concepto* en la Pre-Fase A,
*inicial* en la A, *asignar métodos* en la B, *desarrollo de planes,
ensayos y procedimientos* en la C, y *completar y ejecutar* en la D. Es el
mismo cuadro del módulo #M("fase-a-a-fondo"), leído por una fila: la
verificación no empieza en la Fase D; en la D se *ejecuta*.

== El proceso de verificación

El proceso es una serie de actividades, con sus documentos, que apunta a
dos cosas distintas #diapo("11 A", 16):

- que el *diseño*, con los materiales y componentes elegidos y su
  manufactura, cumple los requerimientos funcionales y de desempeño de la
  misión: la #t[calificación] del diseño;
- que *cada unidad producida* a partir de esos datos de ingeniería es
  idéntica a la calificada, está libre de defectos de construcción y lista
  para usarse: la #t[aceptación].

El flujo, en siete pasos #diapo("11 A", 16): identificar y clasificar los
requerimientos a verificar; elegir los criterios de verificación —métodos,
niveles, etapas y modelos— para cada uno; planificar las actividades;
acordarlo con el cliente; identificar los documentos, las tareas y el
control de la verificación; cumplir ese control con evidencia del cierre de
cada tarea; y la revisión y aprobación final del cliente.

La *planificación* sincroniza los hitos y las restricciones del proyecto
con la lógica de la verificación, y para eso considera la filosofía de
modelos, la estrategia de verificación, el plan de ensamble, integración y
ensayos (#t[AIT / AIV]), el programa de análisis, revisiones de diseño e
inspecciones, y las herramientas de verificación #diapo("11 A", 17). El
detalle de los modelos y de los ensayos es el módulo siguiente.

#ejemplo("el árbol de documentos de un sistema de navegación inercial", nivel: "a-fondo")[
  De los requerimientos de sistema y subsistema y de la especificación de
  interfaces generales cuelgan, por un lado, las especificaciones de
  requerimientos de cada pieza —la computadora de navegación, el
  _software_, la unidad de medición inercial, el giróscopo de fibra óptica
  (IFOG), los acelerómetros, el GPS— y el control de interfaces; y por el
  otro, la verificación: el plan de verificación del subsistema, el plan de
  AIT, los ensayos, los procedimientos, la corrida de los procedimientos y
  el análisis de los datos #diapo("11 A", 15). Cada requerimiento que baja
  por la izquierda tiene su papel de verificación que sube por la derecha:
  es la V dibujada como árbol de documentos.
]

== La matriz de verificación

#definicion("matriz de verificación")[
  El resumen que vincula cada requerimiento con su estrategia de
  verificación. Lleva el requerimiento con su ID, los requerimientos de
  verificación asociados *con su criterio de éxito*, el método, el nivel en
  que se verifica (parte, componente, subensamble, ensamble, subsistema,
  sistema, vehículo), quién la realiza y dónde están los resultados
  #diapo("11 A", 18) #diapo("11 A", 19).
]

#ejemplo("una fila de la matriz, completa", nivel: "a-fondo")[
  - *Requerimiento:* R.302, «la frecuencia del modo natural del vehículo
    espacial será mayor que 35 Hz».
  - *Requerimiento de verificación:* la frecuencia del modo natural se
    verifica por ensayo, sondeando el modo natural en una mesa de
    vibración (_shaker_); *el ensayo es exitoso si la frecuencia medida del
    primer modo es mayor que 35 Hz*.
  - *Método:* ensayo. *Nivel:* vehículo.

  #diapo("11 A", 18)
]

#clave[
  La línea que hace verificable al requerimiento es el *criterio de éxito*:
  sin «mayor que 35 Hz medido en el primer modo», el ensayo se hace y
  nadie sabe si pasó. Es la «M» de SMART del módulo
  #M("escribir-buenos-requerimientos") puesta en una columna.
]

La matriz no se escribe al final. Una versión *preliminar* nace cuando se
escriben los requerimientos; cuando el diseño está completo, y antes de
empezar a verificar, se captura el conjunto de requerimientos de
verificación; y los requerimientos de verificación y sus planes se
establecen en la #t[CDR] #diapo("11 A", 13). Elegir métodos, niveles,
etapas y modelos es un compromiso entre *costo, tiempo, desempeño y
riesgo*; y la verificación se da por completa cuando cliente y contratista
acuerdan, sobre la evidencia documentada, que los requerimientos están
verificados #diapo("11 A", 19).

== Los cuatro métodos, y la frase que los delata

#definicion("métodos de verificación")[
  Los cuatro modos fundamentales de verificar un requerimiento:
  *inspección*, *análisis*, *demostración* y *ensayo* #diapo("11 A", 21). La
  cátedra suma la *revisión de diseño* como un método más
  #diapo("11 A", 28).
]

Cada lámina de método trae algo que vale oro para escribir requerimientos:
*la clase de frase que, en el requerimiento, anticipa cómo se va a
verificar*.

#figure(
  table(
    columns: (0.9fr, 2.4fr, 1.6fr),
    align: (left, left, left),
    stroke: 0.4pt + luma(180),
    inset: 5pt,
    table.header([*Método*], [*Qué es y cuándo se elige*], [*La frase que lo delata*]),
    [Inspección], [Examen visual de planos, datos, código o del ítem mismo, con control de calidad y sin equipos ni procedimientos de laboratorio. Atributos físicos directos: peso, color, marca.], [«tendrá al menos 24 pulgadas de longitud», «tendrá el logo de UNSAM», «será pintado de blanco»],
    [Análisis], [Técnicas analíticas aceptadas —estadística, modelos analógicos, similitud, simulación— cuando un ensayo no se puede hacer adecuadamente o no es rentable cubrir todas las condiciones.], [«será diseñado para», «será desarrollado para», «tendrá una probabilidad de»],
    [Demostración], [Operación, ajuste o reconfiguración del artículo, observada; sin instrumentación elaborada ni evaluación cuantitativa. Factores humanos, accesos, transportabilidad.], [«será accesible», «tendrá al menos una hora», «proveerá el siguiente _display_ en el modo XX»],
    [Ensayo], [Equipos, instrumentos o simulación en condiciones controladas para medir los parámetros del requerimiento, a cualquier nivel de ensamble.], [«proveerá 50 Hz», «será seteable entre 0 °C y 30 °C», «no será mayor que 10 micrones»],
  ),
  caption: [Los cuatro métodos #diapo("11 A", 22) #diapo("11 A", 23) #diapo("11 A", 24) #diapo("11 A", 25) #diapo("11 A", 26).],
)

#cuidado[
  El análisis *de los datos de un ensayo* es parte del ensayo, no el método
  «análisis» #diapo("11 A", 25). Si para verificar un requerimiento se mide
  en un _shaker_ y después se procesan los datos, el método es ensayo.
]

El ensayo es el *método preferido*, y se usa obligadamente cuando las
técnicas analíticas no dan resultados adecuados, cuando hay modos de falla
que pueden comprometer la seguridad del personal, el sistema de vuelo, la
carga útil o los objetivos de la misión, y en componentes asociados a
interfaces críticas #diapo("11 A", 26). La lámina lo dice con un chiste del
oficio —los tres mejores métodos de verificación son «ensayos, ensayos,
ensayos»— y con un lema: *«un ensayo vale la opinión de mil expertos»*
#diapo("11 A", 21). El manual de NASA lista más de treinta tipos de ensayo,
de aerodinámico a vibración #diapo("11 A", 27).

La *revisión de diseño* verifica por revisión de la documentación —planos,
descripciones técnicas, informes—, que no puede ser ambigua y tiene que
cumplir lo que pide cada revisión técnica; la cátedra lista las revisiones
del ciclo, del SCR a la FRR #diapo("11 A", 28).

#cuidado[
  En esa lámina, la _Flight Operation Review_ y la _Flight Readiness Review_
  aparecen con la misma sigla, FRR #diapo("11 A", 28). La FRR es la segunda,
  la de alistamiento para el vuelo (módulo #M("fase-d-a-fondo")).
]

#posta[
  Para el trabajo práctico, la columna «método de verificación» de cada
  requerimiento sale casi sola si mirás el verbo: si se mira, inspección;
  si se calcula o se simula, análisis; si se opera y se observa,
  demostración; si se mide, ensayo. Y si un requerimiento no encaja en
  ninguno, el problema no es la columna: es el requerimiento.
]
