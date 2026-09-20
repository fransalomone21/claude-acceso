#import "../plantilla.typ": *

#modulo(
  "Relaciones, la tabla N², y predecir lo emergente",
  [Distinguir #t[relaciones formales y relaciones funcionales]; leer y
   construir una #t[tabla N²]; enumerar los tres métodos para predecir lo
   emergente; y reconocer una falla de sistema en un caso real — el
   aterrizaje del A320 en Varsovia — cerrando así las cuatro Tareas del
   pensamiento de sistema.],
  clave: "relaciones-n2-emergentes",
)

#lectura[
  Clase 2, diapositivas 70 a 90.
]

== Tarea 3 — Relaciones entre entidades

#definicion("relaciones formales y relaciones funcionales")[
  Las #t[relaciones funcionales] son relaciones entre entidades que *hacen
  algo*: implican operaciones, transferencias o intercambios — se las llama
  también *interacciones*, para enfatizar su naturaleza dinámica. Las
  #t[relaciones formales] son relaciones que *existen o podrían existir* de
  manera estable durante un período de tiempo — a menudo una conexión o
  relación geométrica; se las llama también *estructura*. #diapo(2, 70)
]

#clave[
  *La relación formal es, en general, el instrumento de la relación
  funcional.* El corazón no puede intercambiar sangre con el pulmón sin una
  conexión; los miembros de un equipo no pueden compartir resultados sin
  estar cerca o tener un enlace de información #diapo(2, 70). Y porque la
  #t[emergente] ocurre en el dominio funcional, son las interacciones
  *funcionales* las de importancia primordial — las formales importan
  *principalmente* porque las habilitan #diapo(2, 73).
]

#cuidado[
  *Dos entidades pueden estar formalmente conectadas y no intercambiar nada.*
  Es exactamente lo que hace falta distinguir con dos representaciones
  separadas —una tabla o diagrama para lo formal, otra para lo funcional— en
  vez de una sola.
]

Estas relaciones se representan de dos formas equivalentes: un *diagrama de
relaciones* (más fácil de visualizar) o una *tabla N-cuadrada* (más detalle,
no se congestiona con muchos nodos) #diapo(2, 71) #diapo(2, 73). En el
diagrama, las relaciones formales van como flechas delgadas de dos puntas;
las funcionales, como flechas más anchas, de una o dos cabezas según la
interacción sea uni o bidireccional #diapo(2, 71).

== La tabla N²

#definicion("tabla N² (diagrama N²)")[
  Un artefacto de interfaces: los componentes o funciones del sistema se
  colocan *en la diagonal* de una matriz de N×N, y las celdas fuera de la
  diagonal representan las interfaces entre cada par. Existe *una tabla para
  las relaciones formales y otra para las funcionales*. #diapo(2, 73)
]

#deduccion("cómo se lee la tabla N² del circuito amplificador")[
  La cátedra construye las dos tablas —formal y funcional— para el mismo
  circuito amplificador de los módulos anteriores (Resistencia 1, Resistencia
  2, amplificador operacional, entrada, salida), y vale reproducirlas enteras
  porque son el ejemplo textual más trabajado de la unidad #diapo(2, 73):

  #figure(
    table(
      columns: (1.1fr, 1fr, 1fr, 1.2fr, 1fr, 1fr),
      align: (left, left, left, left, left, left),
      stroke: 0.5pt + c-guia,
      inset: 6pt,
      table.header([*Relaciones formales*], [*Resist. 1*], [*Resist. 2*], [*Amp. operac.*], [*Entrada*], [*Salida*]),
      [*Resistencia 1*], [], [conectada en $V_-$], [conectada en $V_-$], [conectada en la entrada], [],
      [*Resistencia 2*], [conectada en $V_-$], [], [conectada en $V_-$ y en la salida], [], [conectada en la salida],
      [*Amp. operacional*], [conectado en $V_-$], [conectado en $V_-$ y en la salida], [], [], [conectado en la salida],
      [*Entrada*], [conectada en la entrada], [], [], [], [],
      [*Salida*], [], [conectada en la salida], [conectada en la salida], [], [],
    ),
    caption: [Tabla 2.5 de la cátedra — relaciones formales del circuito amplificador. Celda en blanco: no hay interfaz entre esas dos entidades.],
  )

  #v(4pt)

  #figure(
    table(
      columns: (1.1fr, 1fr, 1fr, 1.2fr, 1fr, 1fr),
      align: (left, left, left, left, left, left),
      stroke: 0.5pt + c-guia,
      inset: 6pt,
      table.header([*Relaciones funcionales*], [*Resist. 1*], [*Resist. 2*], [*Amp. operac.*], [*Entrada*], [*Salida*]),
      [*Resistencia 1*], [], [intercambia corriente en $V_-$], [intercambia corriente en $V_-$], [intercambia corriente en la entrada], [],
      [*Resistencia 2*], [intercambia corriente en $V_-$], [], [intercambia corriente en $V_-$ y en la salida], [], [intercambia corriente en la salida],
      [*Amp. operacional*], [intercambia corriente en $V_-$], [intercambia corriente en $V_-$ y en la salida], [], [], [intercambia corriente en la salida],
      [*Entrada*], [intercambia corriente en la entrada], [], [], [], [],
      [*Salida*], [], [intercambia corriente en la salida], [intercambia corriente en la salida], [], [],
    ),
    caption: [Tabla equivalente de relaciones funcionales: mismas celdas ocupadas que la formal, pero describiendo el intercambio, no la conexión.],
  )

  Nótese que las dos tablas tienen *las mismas celdas ocupadas* — es el caso
  típico en un circuito, donde toda conexión formal habilita un intercambio
  funcional. No es la regla general: puede haber conexión sin intercambio.
]

#posta[
  Para leer o armar una N²: las *salidas* de cada entidad van en su *fila*
  (horizontal), las *entradas* en su *columna* (vertical). Un lazo de
  realimentación —dos funciones que se influyen mutuamente— se ve como *dos
  celdas simétricas* ocupadas, una a cada lado de la diagonal.
]

=== Interfaces externas

Cuando una relación —formal o funcional— cruza el #t[límite del sistema],
define una *interfaz externa* entre el sistema y su contexto #diapo(2, 76).
En la tabla N², estas aparecen como cualquier relación fuera de la porción de
la tabla reservada al sistema; en el diagrama, como flechas que cruzan la
línea del límite y quedan marcadas. Es casi imposible definir un sistema que
no tenga *ninguna* interfaz externa #diapo(2, 76).

#clave[
  Resumen de la Tarea 3 #diapo(2, 77): toda relación entre entidades es
  formal (estructura) o funcional (interacción); algunas entidades tienen
  además relaciones con el contexto, a través de interfaces externas; y las
  dos se representan igual de bien con un diagrama de relaciones o con una
  tabla N².
]

== Tarea 4 — Predecir lo emergente

La emergencia es *la magia* de un sistema: surge cuando la función de las
entidades y sus interacciones funcionales se combinan #diapo(2, 78). En el
dominio de la *forma*, nada emerge — la masa del sistema A+B es sólo la masa
de A más la de B, y esa suma es lineal. En el dominio *funcional*, la
combinación de A y B es mucho más interesante y no tiene nada de lineal
#diapo(2, 78).

=== Fallas del sistema

#cuidado[
  Una falla de sistema ocurre en dos formas: (1) la emergencia *deseada
  anticipada* no ocurre, o (2) ocurre una emergencia *no anticipada y no
  deseada* #diapo(2, 79). Dos ejemplos de la cátedra:
  - *Sistema circulatorio:* una obstrucción parcial produce un aumento de
    presión arterial — una emergencia no deseada.
  - *Equipo X:* requerimientos bien desarrollados pero *mal comunicados*
    hacen que el diseño no cumpla los objetivos — la emergencia deseada
    simplemente no aparece.

  La clave que conecta los dos: *un sistema puede "funcionar" en cada una de
  sus partes y aun así fallar en su comportamiento emergente.*
]

#deduccion("el A320 de Varsovia: una falla que funcionó exactamente como se diseñó")[
  Un Airbus A320 aterrizó en Varsovia con viento cruzado y el ala del viento
  en alto. En la pista resbaladiza, los frenos no fueron efectivos, y el
  piloto intentó el inversor de empuje — que no se desplegó. La razón: por
  seguridad, el software estaba diseñado para no desplegar el inversor hasta
  que el avión "aterrizara", señalado por el peso comprimiendo *ambos*
  conjuntos del tren de aterrizaje. Pero con un ala baja, el tren de un lado
  no estaba comprimido #diapo(2, 81). *Todo funcionó exactamente como se
  planeó ese día* — y el resultado fue, de todos modos, una falla del
  sistema: una emergencia no anticipada y no deseada. Es el caso que mejor
  ilustra por qué no alcanza con verificar que cada parte cumpla su
  especificación: la falla vivía en la *interacción* entre el criterio de
  seguridad del software y una condición de viento que ese criterio no
  contemplaba.
]

=== Los tres métodos para predecir lo emergente

#definicion("los tres métodos para predecir lo emergente")[
  + *Por precedente* (experiencia): basarse en soluciones idénticas o muy
    similares ya probadas — el Team X funcionó bien porque la experiencia
    previa sugería que ese grupo trabajaría bien junto.
  + *Por experimentación*: combinar entidades y relaciones propuestas para
    observar qué surge — desde retoques chicos hasta prototipos
    estructurados.
  + *Por modelado*: representar las funciones de las entidades y su
    interacción para anticipar el comportamiento global — miles de millones
    de compuertas lógicas se fabrican con propiedades emergentes correctas
    porque el transistor, su elemento fundamental, se modela de manera
    simple; un amplificador operacional se modela con álgebra y las leyes de
    Kirchhoff.
  #diapo(2, 82) #diapo(2, 83)
]

#cuidado[
  *La pregunta que no tiene atajo:* ¿qué hacer para predecir la emergencia de
  un sistema *sin precedentes*, donde no se puede experimentar ni modelar de
  manera confiable? La cátedra es explícita: en esa situación, la proyección
  sobre la emergencia depende *en última instancia del juicio humano*,
  informado parcialmente por precedentes de sistemas similares (no
  idénticos) y por modelos o experimentos incompletos #diapo(2, 83).
]

=== Lo emergente depende de la estructura, no sólo de las piezas

#clave[
  Con las *mismas* entidades y otro patrón de conexión, emerge otra cosa —
  la Figura 2.13 de la cátedra lo muestra con tres pares #diapo(2, 84)
  #diapo(2, 86):
  - Un resistor y un capacitor dan un filtro *pasabajos* si el resistor va
    entre entrada y salida y el capacitor a tierra; *pasaaltos* si se
    invierte la posición de los dos componentes.
  - Una barra y un fulcro *aumentan la fuerza* si el fulcro está cerca del
    extremo lejano al operador; pierden esa propiedad si el fulcro se acerca
    al operador.
  - Un `IF` y una asignación `a = 100`: si el `IF` va primero, la asignación
    es *condicional*; si la asignación va primero, se ejecuta *siempre*.

  Las relaciones formales —el patrón de conexión, la posición del fulcro, la
  secuencia de instrucciones— son las que guían qué interacción funcional
  específica ocurre, y por lo tanto qué emerge.
]

== Resumen de la unidad

#figure(
  table(
    columns: (1.4fr, 1.6fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Característica esencial de un sistema*], [*Tarea del pensamiento de sistema*]),
    [Tiene forma y función; la forma es el instrumento de la función.], [Identificar el sistema, su forma y su función.],
    [Compuesto de entidades, cada una con su propia forma y función.], [Identificar las entidades, su forma y función, y el límite y contexto del sistema.],
    [Las entidades están vinculadas por relaciones formales y funcionales; algunas cruzan el límite hacia el contexto.], [Identificar las relaciones entre las entidades, en el sistema y en el límite.],
    [La función y otras características emergen cuando las entidades interactúan, guiadas por la forma de sus relaciones.], [Identificar las propiedades emergentes según la función de las entidades y sus interacciones.],
  ),
  caption: [Tabla 2.6 de la cátedra: las cuatro características esenciales de un sistema, alineadas con la Tarea que las trabaja #diapo(2, 88).],
)

#posta[
  El pensamiento sistémico sirve para *informar el juicio* en la toma de
  decisiones: identificar y ponderar opciones, preguntar qué tensiones son
  evidentes en el sistema, qué alternativas las resuelven, y cómo va a
  reaccionar la solución elegida ante cambios futuros #diapo(2, 89). *Sintetizar*
  un sistema a partir de estas cuatro Tareas es, precisamente, el dominio de
  la #t[arquitectura de sistema] — el tema con el que abrió esta unidad y el
  que retoma la unidad 3, con el rol del arquitecto.
]
