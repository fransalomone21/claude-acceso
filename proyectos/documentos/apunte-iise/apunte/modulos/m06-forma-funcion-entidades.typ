#import "../plantilla.typ": *

#modulo(
  "Forma y función: identificar el sistema y sus entidades",
  [Distinguir #t[forma] de #t[función] con la regla sustantivo/verbo;
   descomponer la función en proceso y operando; aplicar el #t[pensamiento
   holístico] y el enfoque para encontrar entidades; y crear #t[abstracción]
   sin perder lo importante — las Tareas 1 y 2 del pensamiento de sistema.],
  clave: "forma-funcion-entidades",
)

#lectura[
  Clase 2, diapositivas 39 a 69.
]

== Tarea 1 — Forma y función

#definicion("forma")[
  Lo que un sistema *ES*: su encarnación física o informativa, que existe o
  tiene el potencial de existir. Tiene figura, configuración, disposición,
  _layout_. Durante un período de tiempo es estática y perseverante (aunque
  se pueda alterar, crear o destruir). La forma es lo que se *construye*: el
  creador del sistema la escribe, pinta, compone o fabrica. #diapo(2, 40)
]

#definicion("función")[
  Lo que un sistema *HACE*: las actividades, operaciones y transformaciones
  que causan, crean o contribuyen al desempeño. La función *no es* forma, pero
  *requiere* un instrumento de forma para ejecutarse. Es más abstracta que la
  forma, y por tratarse de transiciones, más difícil de diagramar.
  #diapo(2, 42)
]

#clave[
  *Regla corta: forma = sustantivo; función = verbo.* La cátedra usa cuatro
  ejemplos corrientes para fijar la distinción, elegidos a propósito para
  cubrir lo construido, lo evolucionado, lo informativo, lo mecánico y lo
  natural: un amplificador operacional, un equipo de diseño (Team X), el
  sistema circulatorio y el sistema solar #diapo(2, 40).
]

#figure(
  image("../figuras/c02-p041.png", width: 95%),
  caption: [Los cuatro ejemplos, juntos y a propósito: dos construidos por humanos (uno técnico y uno social), uno evolucionado y uno natural. Verlos en la misma lámina es el argumento de que #t[forma] y #t[función] no son vocabulario de ingeniería electrónica, sino una distinción que se aplica a cualquier cosa que se pueda mirar como sistema #diapo(2, 41).],
)

#figure(
  table(
    columns: (1.1fr, 1.3fr, 1.6fr),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Sistema*], [*Forma*], [*Función* (proceso — operando)]),
    [Circuito amplificador], [Resistencias + amplificador operacional], [Amplificación — señal de salida],
    [Equipo de diseño (Team X)], [El equipo (las personas)], [Desarrollo — diseño],
    [Sistema circulatorio humano], [Corazón, pulmones, venas, arterias, capilares], [Suministro — oxígeno],
    [Sistema solar], [El Sol, los planetas], [Mantener — flujo solar constante],
  ),
  caption: [Tabla 2 de la cátedra: forma y función de los cuatro sistemas de ejemplo, con la función ya separada en proceso y operando #diapo(2, 45).],
)

#cuidado[
  *La función principal de los sistemas evolucionados es más difícil de
  discernir* que la de los construidos, y con frecuencia queda sujeta a
  interpretación #diapo(2, 48). Del sistema circulatorio se puede decir que
  la función es "suministrar oxígeno a las células" — pero también "absorber
  CO₂" o, más generalmente, "mantener en equilibrio la química del gas de las
  células" #diapo(2, 44). Del sistema solar hay *docenas* de formulaciones
  igualmente válidas #diapo(2, 46). El problema no es que estos sistemas no
  tengan función: es que tienen demasiadas, porque nadie los diseñó con una
  intención declarada a la que se le pueda preguntar.
]

=== Proceso y operando

#definicion("proceso")[
  La parte de la función que es *pura acción o transformación*: la parte que
  *cambia el estado* del operando. #diapo(2, 42)
]

#definicion("operando")[
  El objeto cuyo estado cambia mediante el proceso. Puede haber más de un
  operando por proceso — el voltaje de entrada de un amplificador es un
  operando además de la señal de salida amplificada. #diapo(2, 43)
]

#deduccion("por qué Chomsky aparece en un apunte de sistemas")[
  Porque la estructura instrumento–proceso–operando coincide con la
  estructura profunda que Chomsky propuso para el lenguaje natural humano:
  un sustantivo que hace de instrumento de la acción (forma), un verbo que
  describe la acción (proceso), y un sustantivo que es el objeto de la acción
  (operando) #diapo(2, 47). La cátedra lo cita como evidencia de que ese
  patrón *sustantivo–verbo–sustantivo* podría ser fundamental para la forma en
  que el cerebro humano entiende cualquier sistema — no es una analogía
  decorativa, es el mismo argumento que sostiene la regla corta
  "forma = sustantivo; función = verbo".
]

#posta[
  Si el parcial pide forma y función de un sistema concreto: primero
  identificar el *instrumento* (qué es), después separar la función en
  *proceso* (el verbo, la transformación) y *operando* (el sustantivo que
  cambia de estado). "El corazón bombea sangre" ya trae los tres: corazón
  (forma), bombea (proceso), sangre (operando).
]

== Tarea 2 — Entidades, límite y contexto

Un sistema en sí puede tratarse como una única entidad con forma y función.
La Tarea 2 pregunta cómo ese sistema se *descompone* en entidades, cada una
con su propia forma y función #diapo(2, 49). El sistema queda rodeado por un
#t[límite del sistema] que lo separa de su *contexto*.

#figure(
  table(
    columns: (1fr, 1.3fr, 1.6fr),
    align: (left, left, left),
    stroke: 0.5pt + c-guia,
    inset: 6pt,
    table.header([*Sistema*], [*Forma de la entidad*], [*Función de la entidad*]),
    [Circuito amplificador], [Resistencia 1 / Resistencia 2], [Establecer ganancia],
    [], [Amplificador operacional], [Amplificar voltaje],
    [Equipo de diseño], [Amelia / Juan / José], [Interpretar requerimientos / desarrollo de conceptos / evaluar y aprobar diseño],
    [Sistema circulatorio], [Pulmones / corazón], [Intercambio de gases con órganos / bombear sangre],
  ),
  caption: [Tabla 2.3 de la cátedra (recortada): la descomposición de cada sistema en sus entidades, con la forma y función de cada una #diapo(2, 50).],
)

Leer la tabla de derecha a izquierda —juntar entidades en la forma del
sistema— es *agregación*; leer de izquierda a derecha —romper el sistema en
partes— es *descomposición*. Lo mismo en el dominio funcional: partir la
función en componentes es *zooming*; combinar las funciones de las entidades
para producir la función del sistema es encontrar lo #t[emergente]
#diapo(2, 52).

=== Los cinco problemas del pensador de sistemas

Definir entidades y límites es desafiante en la práctica, y la cátedra lo
resume en cinco problemas concretos #diapo(2, 54):

+ Definir la descomposición inicial en entidades.
+ Identificar las entidades potenciales, usando el *pensamiento holístico*.
+ Bajar a las entidades consiguientes usando el *enfoque*.
+ Crear *abstracciones* para las entidades.
+ Definir los límites del sistema y separarlo del contexto.

Las cuatro secciones que siguen desarrollan cada uno.

=== Pensamiento holístico

#definicion("pensamiento holístico (holismo)")[
  El holismo sostiene que *todas las cosas existen y actúan como conjuntos, no
  sólo como la suma de sus partes* — su sentido es el *opuesto al
  reduccionismo*. Pensar holísticamente es pensar deliberadamente sobre el
  todo: identificar *todas* las entidades y problemas que podrían ser
  importantes para el sistema. #diapo(2, 57)
]

El pensamiento holístico pone problemas e incógnitas "en el radar": hay
*conocidos desconocidos* (sabemos que existen, falta información) y
*desconocidos desconocidos* (no sabemos que existen, no podemos evaluar su
importancia) #diapo(2, 58). El objetivo es identificar la mayor cantidad
posible de incógnitas para poder ponderar su importancia potencial.

=== Enfoque: reducir a lo manejable

El pensamiento holístico produce, típicamente, *demasiadas* entidades para
que un equipo las piense a la vez #diapo(2, 61). El *enfoque* es el
movimiento complementario: filtrar ese conjunto amplio para quedarse con lo
importante *en este momento*.

#clave[
  *El holismo abre; el enfoque cierra.* En la Tarea 2 se usan los dos, en ese
  orden. El límite práctico viene de un dato de psicología cognitiva que la
  cátedra cita explícitamente: el cerebro humano razona con solvencia sobre
  *7 ± 2 elementos a la vez* #diapo(2, 62) — la referencia es Miller (1956),
  _The Magical Number Seven_ #diapo(2, 90). Método: (1) listar entidades
  potencialmente importantes, (2) elegir hasta 7 para enfocarse en un momento
  dado, (3) cambiar el conjunto si las circunstancias cambian.
]

#deduccion("por qué reducir entidades vale más de lo que parece")[
  Porque las relaciones entre entidades escalan como $N^2$. En el ejemplo del
  Team X, reducir de siete entidades a cinco —agrupando a dos personas bajo
  "Marketing" y a otras dos bajo "planificación de manufactura y cadena de
  suministro"— parece una simplificación menor, pero reduce las relaciones
  posibles de 49 a 25 #diapo(2, 66). Es la misma razón por la que la
  #t[tabla N²] del próximo módulo crece tan rápido con cada entidad nueva.
]

=== Crear abstracciones

#definicion("abstracción")[
  La expresión de la cualidad sin el objeto completo: una representación que
  *conserva lo intrínseco y oculta el detalle innecesario* #diapo(2, 63).
]

En el Team X, una persona fisiológica y psicológicamente compleja se resume
en "un miembro del equipo que crea conceptos"; en el sistema circulatorio, el
corazón —un órgano complejo— se resume en "una bomba"; en el sistema solar,
toda la masa, ecosistema y población de la Tierra se resumen en "una esfera"
#diapo(2, 64).

#cuidado[
  Cuatro pautas para crear abstracciones útiles, y cada una tiene su forma de
  fallar #diapo(2, 65):
  - Destacar la información importante en la superficie, ocultar el resto —
    abstraer un amplificador operacional como "fuente de calor" es
    técnicamente correcto pero *inútil*: esconde justo el rol que importa.
  - Permitir representar las relaciones apropiadas.
  - Elegirse en el nivel correcto de descomposición o agregación — demasiado
    detalle sobre los componentes de un amplificador puede no hacer falta
    para entender su rol en el circuito.
  - Crear el *número mínimo* de abstracciones que representen efectivamente
    el sistema en cuestión.

  Las abstracciones *no son únicas*: cuál es la correcta depende de la
  pregunta o problema en cuestión, y normalmente no se pueden hacer
  abstracciones universales #diapo(2, 66).
]

=== Definir el límite del sistema

#definicion("límite del sistema")[
  Lo que delimita qué está dentro y qué está fuera del sistema; *separa el
  sistema de su contexto* — lo que lo rodea pero es relevante. #diapo(2, 67)
]

Trazarlo importa porque ayuda a concentrarse en un conjunto manejable de
entidades y da claridad de alcance y responsabilidades. Los criterios que la
cátedra enumera para trazarlo #diapo(2, 67):

- Incluir las entidades que hace falta analizar (comprensión) y las
  necesarias para diseñar, implementar y operar (entrega de valor).
- Respetar límites formales: leyes, contratos, normas.
- Considerar tradiciones o convenciones vigentes.
- Cumplir definiciones de interfaz y estándares — por ejemplo, con
  proveedores.

#posta[
  Cuando una relación *cruza* el límite, define una *interfaz externa* entre
  el sistema y el contexto #diapo(2, 68) — el tema que abre el módulo
  siguiente, junto con las relaciones internas.
]

== Resumen de la Tarea 2

#clave[
  Todo sistema está compuesto por entidades, que a su vez pueden ser
  sistemas. La dificultad para definir esa composición varía: *fácil* en
  sistemas con entidades distintas (una flota, una manada), *media* en
  sistemas modulares (relaciones densas adentro de cada módulo, débiles
  entre módulos) y *difícil* en sistemas integrales, altamente
  interconectados, que no se pueden dividir sin perder la función
  #diapo(2, 55) #diapo(2, 56). El pensamiento holístico ayuda a encontrar
  entidades relevantes — pero por sí solo produce demasiadas para un análisis
  útil; de ahí que haga falta el enfoque.
]
