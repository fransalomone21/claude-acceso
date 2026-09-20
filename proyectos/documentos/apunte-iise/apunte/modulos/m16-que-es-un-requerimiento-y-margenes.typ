#import "../plantilla.typ": *

#modulo(
  "Qué es un requerimiento, buenos y malos ejemplos, y los márgenes a fondo",
  [Definir requerimiento y explicar su organización jerárquica; distinguir un
   requerimiento bien escrito de uno mal escrito con dos casos reales; y
   desarrollar la gestión de márgenes —qué son, quién los controla y cuánto
   se reserva en cada revisión— completando la promesa que dejó abierta el
   margen del Saturno V.],
  clave: "que-es-un-requerimiento-y-margenes",
)

#lectura[
  Clase 5, diapositivas 10 a 22.
]

== Qué es un requerimiento

#definicion("requerimiento")[
  Una declaración que describe una función necesaria o una característica
  del sistema que se va a Concebir, Diseñar, Implementar y Operar, e impacta
  en su *performance*, *planificación*, *costos* y otras características
  —el riesgo incluido.
]

#clave[
  Los requerimientos se organizan *jerárquicamente*: los de alto nivel dicen
  *qué* debe alcanzarse, no *cómo* alcanzarlo, y se especifican en cada
  nivel de la #t[jerarquía del sistema] hasta llegar al hardware y software
  de cada componente y parte.
]

#cuidado[
  *Muchos sobrecostos vienen de demasiada ambición o de falta de
  requerimientos* — los dos extremos fallan. Pedir de más sin presupuesto
  para sostenerlo y no especificar lo suficiente son la misma falla de
  fondo: no haber usado los requerimientos para fijar correctamente qué se
  va a hacer, que es, letra por letra, el #t[CDIO] aplicado a esta unidad.
]

== Un requerimiento pobre: el Mars Climate Orbiter

#deduccion("cómo una confusión de unidades destruyó una misión")[
  El Mars Climate Orbiter (MCO), lanzado por NASA en diciembre de 1998, se
  desintegró al insertarse en órbita marciana en septiembre de 1999. La
  causa: el contrato entre NASA y Lockheed Martin especificaba una interfaz
  de software (*SIS*), pero ese requerimiento *nunca se verificó
  posteriormente ni se implementó como estaba escrito*. El software de
  Tierra enviaba comandos en unidades inglesas (libras-fuerza por segundo)
  cuando el sistema esperaba unidades métricas (newton-segundo).
]

#posta[
  El MCO no falló por un error de física: falló porque un requerimiento de
  interfaz quedó *escrito* pero no quedó *verificado*. Es el mismo argumento
  del Hubble en la unidad 4 —cada parte puede estar bien hecha y el sistema
  fallar igual— aplicado ahora, específicamente, a un requerimiento de
  interfaz sin verificar.
]

== Un buen requerimiento: el DC-3

#ejemplo("requerimientos simples y medibles del DC-3", nivel: "a-fondo")[
  El Douglas DC-3, uno de los aviones de pasajeros más influyentes de la
  historia (voló por primera vez en 1935 y *todavía está en vuelo*), nació
  de un pedido de propuesta de *tres páginas* y una maratón telefónica entre
  Smith y Douglas. Sus requerimientos clave de alto nivel:

  - Rango: 1.080 millas.
  - Velocidad de crucero: 150 mph.
  - Velocidad de aterrizaje: no más de 65 mph.
  - Pasajeros: 20 a 30, según configuración.
  - Dos motores.
  - Robusto y económico.
]

#clave[
  Seis líneas, todas *medibles o verificables*, contra un documento de tres
  páginas. El contraste con el MCO no es casualidad: un buen requerimiento
  se puede verificar sin ambigüedad, y el DC-3 lo prueba con seis
  renglones.
]

== Estándares de requerimientos

La cátedra remite a tres fuentes para escribir y gestionar requerimientos:
el *NASA Systems Engineering Handbook* (secciones 4.2, 6.2 y los apéndices C
y D), el *INCOSE Systems Engineering Handbook* (grupo de trabajo de
requerimientos) y la norma *ISO/IEC 15288* (sección 6.4.1, definición de
requerimientos de los interesados).

== Descomposición, alojamiento y validación

#clave[
  Los requerimientos se descomponen en una estructura jerárquica que
  arranca en los de alto nivel (misión) y baja a requerimientos funcionales
  y de performance, *alojados* a través del sistema en sus elementos y
  subsistemas. En cada nivel de descomposición, el conjunto total de
  requerimientos derivados se *valida contra las expectativas* del nivel
  padre inmediato superior — no contra el requerimiento de misión
  directamente, sino contra el que lo alojó un nivel arriba.
]

== La gestión de márgenes, a fondo

#definicion("margen (de requerimientos)")[
  Una *reserva no alojada* a ningún subsistema en particular —de masa,
  tamaño, memoria, potencia— que existe por la incertidumbre del diseño
  temprano, y que *controlan la ingeniería de sistemas y la dirección de
  proyecto*, no cada subsistema por separado.
]

#deduccion("por qué el margen no se reparte entre los subsistemas")[
  Si el margen se repartiera de entrada entre los subsistemas, cada uno lo
  gastaría como si fuera presupuesto propio, y no quedaría nada el día que
  *un* subsistema —no necesariamente el que lo tenía reservado— lo
  necesite. Por eso el margen se mantiene como una reserva *centralizada*: la
  ingeniería de sistemas decide a quién se le asigna cuando hace falta, no
  cada equipo por su cuenta.
]

El crecimiento de masa es el ejemplo que da la cátedra, y está medido: casi
todos los proyectos y programas de desarrollo de vehículos experimentan un
crecimiento de masa de entre *10% y 60%*, según cuán novedoso es el
proyecto.

#figure(
  table(
    columns: (1.3fr, 1fr),
    align: (left, center),
    stroke: 0.4pt + luma(180),
    [*Hito*], [*Margen de masa*],
    [Se establece en el SRR], [+30%],
    [Antes del PDR], [20%],
    [Antes del CDR], [10%],
    [Antes del IOC], [5%],
  ),
  caption: [Guías típicas de margen de masa: se va consumiendo a medida que el diseño madura y la incertidumbre baja (diapositiva 17).],
)

#posta[
  El margen no es un colchón que se guarda entero hasta el final: se
  *consume a propósito*, en la misma proporción en que el diseño deja de
  ser incierto. Del 30% al 5% no es una promesa incumplida — es la curva
  esperada.
]

#deduccion("la misma reserva que ya salvó una misión")[
  Esto es exactamente el margen del *quinto motor* que el equipo de Von
  Braun agregó al Saturno V (unidad 4): un margen que en el papel *no hacía
  falta* con cuatro motores, reservado sin asignarlo a ningún subsistema
  puntual, y que terminó absorbiendo el crecimiento de masa de las misiones
  Apollo sucesivas. La unidad 4 mostró el caso; esta sección muestra la
  regla general detrás.
]

== Definición de los requerimientos técnicos: el flujo

La cátedra resume el proceso completo con un diagrama de flujo: desde las
*expectativas básicas de los interesados* y el *concepto de operación*, se
define la funcionalidad esperada en términos técnicos, se redactan los
requerimientos con sentencias "shall" aceptables, y se definen las
mediciones de desempeño para cada una — hasta llegar a una base de
*requerimientos técnicos validados*, con su propia medición de desempeño
técnico como retroalimentación continua.

#clave[
  El primer paso para construir una base sólida de buenos requerimientos es
  *definir el alcance del proyecto* — la cátedra cita a Platón: *"el
  principio es la parte más importante del trabajo"*. El resto de esta
  unidad desarrolla primero la familia completa de requerimientos, y cierra
  con el alcance mismo.
]
