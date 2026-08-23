#import "../plantilla.typ": *

#modulo("Teoremas de circuitos", [
  Usar la linealidad para no resolver de nuevo lo que ya está resuelto: descomponer un
  circuito por superposición, convertir fuentes de un tipo en el otro, y —sobre todo—
  reemplazar toda una red por su equivalente de Thévenin o de Norton, incluyendo el caso
  con fuentes controladas, que es el que se cobra en los parciales. Y saber cuándo
  conviene adaptar la carga y cuándo es exactamente lo que no hay que hacer.
])

Los métodos del Módulo 8 resuelven *todo* el circuito. Muchas veces no hace falta: se
quiere saber qué pasa en *una* rama, o qué pasa cuando la carga cambia. Resolver el
sistema completo cada vez que se cambia un resistor es un desperdicio. Los teoremas de
este módulo son atajos, y todos salen de la misma propiedad.

== Linealidad

#definicion("Circuito lineal")[
  Un circuito es lineal si todos sus elementos lo son: la relación entre la tensión y la
  corriente de cada uno es una recta que pasa por el origen ($v = R i$), una derivada
  ($i = C thin dif v \/ dif t$) o una integral. Un circuito lineal cumple:

  - *Homogeneidad*: si la excitación se multiplica por $k$, toda respuesta se multiplica
    por $k$.
  - *Aditividad*: la respuesta a la suma de dos excitaciones es la suma de las respuestas
    a cada una por separado.
]

#atencion[
  El diodo del Módulo 4 y el transistor del Módulo 6 *no* son lineales: su curva $i$–$v$
  es exponencial. Nada de este módulo se les aplica directamente. Lo que sí se hace —y es
  la base de toda la electrónica analógica— es *linealizarlos alrededor de un punto de
  trabajo*: para pequeñas variaciones alrededor del punto Q, el dispositivo se comporta
  como un modelo lineal de resistores y fuentes controladas, y ahí todo esto vuelve a
  valer. Por eso el Módulo 7 se tomó el trabajo de presentar las fuentes controladas.
]

== Superposición

#definicion("Teorema de superposición")[
  En un circuito lineal con varias fuentes independientes, la respuesta (tensión o
  corriente) en cualquier rama es la *suma algebraica* de las respuestas que produciría
  cada fuente independiente actuando sola, con todas las demás *anuladas*.

  Anular una fuente significa llevarla a cero:
  - Una *fuente de tensión* anulada es un *cortocircuito* ($v = 0$ para toda corriente).
  - Una *fuente de corriente* anulada es un *circuito abierto* ($i = 0$ para toda tensión).

  *Las fuentes controladas nunca se anulan*: no son excitaciones, son parte del
  comportamiento del circuito. Quedan siempre activas, en todos los subcircuitos.
]

#clave[
  Superposición casi nunca es el camino más corto para resolver un circuito completo:
  con $m$ fuentes hay que resolver $m$ circuitos. Su valor es otro, y es conceptual: es
  lo que permite separar la *continua* de la *alterna* en un amplificador (el punto de
  reposo por un lado, la señal por el otro), y es la justificación de todo lo que viene
  después en este módulo.
]

#ejercicio("Superposición, y por qué no vale para la potencia")[
  Circuito: una fuente de $V = 12$ V en serie con $R_1 = 4 Omega$ que llega al nodo $A$;
  desde $A$ a masa, $R_2 = 6 Omega$; y una fuente de corriente $I = 3$ A inyectando en $A$.

  *1. Con la fuente de tensión sola* (la de corriente, abierta). Queda un divisor:
  $ v_A' = 12 "V" dot (6)/(4+6) = 7,2 "V" $

  *2. Con la fuente de corriente sola* (la de tensión, en corto). Los dos resistores
  quedan en paralelo:
  $ R_1 parallel R_2 = (4 dot 6)/(4+6) = 2,4 Omega quad arrow.r quad
    v_A'' = 3 "A" dot 2,4 Omega = 7,2 "V" $

  *3. Sumar.*
  $ v_A = 7,2 + 7,2 = 14,4 "V" $

  *4. Verificar por nodos* (una sola ecuación):
  $ (v_A - 12)/(4) + v_A/6 = 3 quad arrow.r quad 3(v_A - 12) + 2 v_A = 36 quad arrow.r quad
    v_A = 14,4 "V" quad checkmark $

  *5. Ahora la trampa.* La potencia en $R_2$ vale
  $ p_2 = (v_A^2)/(R_2) = ("14,4"^2)/(6) = 34,6 "W" $
  Pero si uno "superpusiera" las potencias:
  $ p_2' + p_2'' = ("7,2"^2)/(6) + ("7,2"^2)/(6) = 8,64 + 8,64 = 17,3 "W" $
  La mitad. *La potencia no se superpone*, porque no es una función lineal de la
  excitación sino cuadrática: $(a+b)^2 != a^2 + b^2$. Superposición se aplica a tensiones
  y corrientes, se calculan esas, y *recién al final* se calcula la potencia.
]

== Transformación de fuentes

#circuito([Las dos fuentes reales, equivalentes vistas desde los bornes])[
#fig-fuentes-reales()
]

Las dos redes son indistinguibles *desde los bornes* $a$–$b$ si entregan la misma tensión
en vacío y la misma corriente en cortocircuito:

$ V_"vacío" = V_s = I_s R_p quad quad
  I_"corto" = V_s/R_s = I_s quad quad arrow.r.double quad R_s = R_p $ <ec-transf-fuentes>

#atencion[
  "Equivalente desde los bornes" no significa "igual". Lo que pasa *adentro* es distinto:
  con la carga desconectada, el modelo de tensión no disipa nada y el de corriente disipa
  $I_s^2 R_p$ permanentemente. Para calcular la potencia de la fuente real hay que usar el
  circuito real, no el equivalente.
]

Esta transformación, aplicada en cadena, resuelve sola muchos circuitos: convierte,
asocia en serie o paralelo, vuelve a convertir, y así hasta dejar una sola fuente y una
sola resistencia. Que es, precisamente, el equivalente de Thévenin.

== Teorema de Thévenin

#definicion("Teorema de Thévenin")[
  Toda red lineal de dos terminales, por complicada que sea, es equivalente —*vista desde
  esos dos terminales*— a una fuente de tensión $V_"th"$ en serie con una resistencia
  $R_"th"$, donde:

  - $V_"th"$ es la tensión que aparece entre los terminales *en vacío* (carga
    desconectada). También se la llama $V_"oc"$, de #emph[open circuit].
  - $R_"th"$ es la resistencia que se ve entre los terminales *con todas las fuentes
    independientes anuladas* (tensiones en corto, corrientes abiertas).

  El equivalente reproduce exactamente la relación $v$–$i$ de la red original en esos
  bornes, para *cualquier* carga que se le conecte, lineal o no.
]

=== Por qué es cierto

Sea $i$ la corriente que la red entrega a una carga cualquiera. Por superposición, esa
corriente tiene dos contribuciones: la de las fuentes internas de la red, y la de la
propia carga vista como excitación. Sustituyendo la carga por una fuente de corriente de
valor $i$ (teorema de sustitución, que es legítimo porque la rama queda igual):

$ v = underbrace(V_"oc", "fuentes internas, con" i = 0) - underbrace(R_"th" i, "carga sola, con las fuentes internas anuladas") $ <ec-thevenin>

Y esa es exactamente la ecuación de una fuente $V_"oc"$ en serie con $R_"th"$. La
linealidad es lo único que se usó; de ahí que el teorema valga *solo* en redes lineales.

=== Las tres formas de calcular $R_"th"$

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Método*], [*Cómo*], [*Cuándo*]),
    [Anular y reducir],
      [Fuentes independientes a cero, y se reduce la red por serie/paralelo/$Delta$–Y],
      [Solo si *no* hay fuentes controladas],
    [Vacío y cortocircuito],
      [$R_"th" = V_"oc" \/ I_"sc"$],
      [Siempre, salvo que $V_"oc" = 0$],
    [Fuente de prueba],
      [Anular las independientes, aplicar $v_t$ en los bornes, medir $i_t$,
       $R_"th" = v_t \/ i_t$],
      [Siempre. *Obligatorio* si hay fuentes controladas y $V_"oc" = 0$],
  ),
  caption: [Cómo obtener la resistencia de Thévenin],
)

#atencion[
  Con fuentes controladas, el primer método *da mal*. La fuente controlada no se anula,
  y por lo tanto sigue inyectando o absorbiendo corriente mientras se "mira" la red: la
  resistencia equivalente ya no es una combinación serie-paralelo de los resistores. El
  Ejercicio 9.3 muestra el error concreto. Peor aún, con fuentes controladas $R_"th"$
  puede dar *negativa*, lo que es perfectamente físico: significa que la red entrega
  energía y es la base de los osciladores.
]

#ejercicio("Thévenin de un puente de Wheatstone")[
  Puente alimentado con $V = 12$ V. Rama izquierda: $R_1 = 3 "k"Omega$ arriba,
  $R_3 = 6 "k"Omega$ abajo, con el nodo $a$ en el medio. Rama derecha: $R_2 = 6 "k"Omega$
  arriba, $R_4 = 3 "k"Omega$ abajo, con el nodo $b$ en el medio. Se quiere la corriente por
  una carga $R_L = 4 "k"Omega$ conectada en la diagonal $a$–$b$.

  *1. $V_"th"$: la diagonal en vacío.* Sin la carga, cada rama es un divisor independiente:
  $ v_a = 12 "V" dot (6)/(3+6) = 8 "V" quad quad v_b = 12 "V" dot (3)/(6+3) = 4 "V" $
  $ V_"th" = v_a - v_b = 4 "V" $

  *2. $R_"th"$: anular la fuente.* La fuente de 12 V pasa a ser un cortocircuito, con lo
  que el nodo de arriba y el de abajo quedan unidos. Entonces $R_1$ queda en paralelo con
  $R_3$, y $R_2$ en paralelo con $R_4$, y ambos paralelos quedan en serie vistos desde la
  diagonal:
  $ R_"th" = (R_1 parallel R_3) + (R_2 parallel R_4)
    = (3 dot 6)/(9) + (6 dot 3)/(9) = 2 + 2 = 4 "k"Omega $

  *3. Conectar la carga al equivalente*, que ahora es un circuito de una sola malla:
  $ i_L = (V_"th")/(R_"th" + R_L) = (4 "V")/(4 + 4 "k"Omega) = 0,5 "mA" $

  *4. Verificar por nodos* sobre el circuito original completo, con la carga puesta:
  $ 3 v_a - v_b = 16 quad quad 3 v_b - v_a = 8 quad arrow.r quad v_a = 7 "V", quad v_b = 5 "V" $
  $ i_L = (7 - 5)/(4 "k"Omega) = 0,5 "mA" quad checkmark $

  *5. Lo que se ganó.* Si ahora se cambia $R_L$, con Thévenin alcanza una división; por
  nodos hay que resolver el sistema de nuevo. Esa es toda la gracia del teorema: se paga
  una vez el análisis de la red fija, y después la carga se barre gratis. Es exactamente
  lo que hace falta para trazar la curva de un puente con un sensor variable —una galga,
  un termistor, un LDR— que es para lo que los puentes existen.
]

#ejercicio("Thévenin con fuente controlada: por qué hay que usar la fuente de prueba")[
  Red vista desde los bornes $a$–$b$ (con $b$ = masa): una fuente independiente de 20 V
  alimenta $R_1 = 4 Omega$ que llega al nodo $a$; desde $a$ a masa hay $R_2 = 2 Omega$; y una
  fuente de corriente controlada de valor $2 i_x$ inyecta en el nodo $a$, donde $i_x$ es
  la corriente que circula por $R_1$ hacia $a$.

  *1. $V_"th"$ (bornes en vacío).* LKC en $a$: entra $i_x$ por $R_1$ y $2 i_x$ por la
  fuente controlada; sale todo por $R_2$.
  $ 3 i_x = v_a/2 quad "con" quad i_x = (20 - v_a)/(4) $
  $ (3(20 - v_a))/(4) = v_a/2 quad arrow.r quad 3(20 - v_a) = 2 v_a quad arrow.r quad
    5 v_a = 60 $
  $ V_"th" = v_a = 12 "V" quad (i_x = 2 "A") $

  *2. $I_"sc"$ (bornes en corto).* Ahora $v_a = 0$, así que $R_2$ no lleva corriente y
  $i_x = 20\/4 = 5$ A. Todo lo que entra al nodo se va por el corto:
  $ I_"sc" = i_x + 2 i_x = 3 dot 5 = 15 "A" $
  $ R_"th" = (V_"oc")/(I_"sc") = (12)/(15) = 0,8 Omega $

  *3. Comprobación por fuente de prueba.* Se anula la fuente de 20 V (corto) y se aplica
  $v_t$ en $a$. Ahora $i_x = (0 - v_t)\/4 = -v_t\/4$. LKC en $a$:
  $ i_t + i_x + 2 i_x = v_t/2 quad arrow.r quad i_t - (3 v_t)/(4) = v_t/2 $
  $ i_t = v_t/2 + (3 v_t)/(4) = (5 v_t)/(4) quad arrow.r quad
    R_"th" = (v_t)/(i_t) = 4/5 = 0,8 Omega quad checkmark $

  *4. Y el método que da mal.* Si uno anulara las fuentes —incluida, por error, la
  controlada— y redujera:
  $ R_1 parallel R_2 = (4 dot 2)/(6) = 1,33 Omega quad quad #text(fill: c-rojo)[✗ incorrecto] $
  Casi el doble del valor real. La fuente controlada baja la resistencia de salida a
  $0,8 Omega$ porque *aporta* corriente cuando se le pide: se está comportando como un
  seguidor. Ese es, en una línea, el motivo por el que un amplificador operacional
  realimentado tiene una resistencia de salida de miliohms con transistores de decenas
  de ohms adentro.
]

== Teorema de Norton y la dualidad

#definicion("Teorema de Norton")[
  Toda red lineal de dos terminales es equivalente a una fuente de corriente $I_N$ en
  paralelo con una resistencia $R_N$, donde $I_N$ es la corriente de *cortocircuito*
  entre los terminales y $R_N = R_"th"$.
]

Thévenin y Norton son la misma información escrita de dos maneras, y se pasa de una a la
otra con la transformación de fuentes:

$ I_N = (V_"th")/(R_"th") quad quad V_"th" = I_N R_N quad quad R_N = R_"th" $ <ec-norton>

#clave[
  Cuál usar es una cuestión de comodidad. Thévenin es natural cuando la red se parece a
  una fuente de alimentación (baja resistencia interna, se piensa en tensión); Norton, en
  cuanto la red se parece a un colector de transistor o a un fotodiodo (alta resistencia
  interna, se piensa en corriente). También conviene Norton cuando lo que sigue es un
  nodo, porque entra directo en la ecuación nodal.
]

== Máxima transferencia de potencia

Con la carga $R_L$ conectada al equivalente de Thévenin, la potencia que recibe es

$ p_L = i^2 R_L = ((V_"th")/(R_"th" + R_L))^2 R_L
      = V_"th"^2 (R_L)/((R_"th" + R_L)^2) $ <ec-pl>

Para encontrar el máximo se deriva respecto de $R_L$ y se iguala a cero:

$ (dif p_L)/(dif R_L) = V_"th"^2
  ((R_"th" + R_L)^2 - R_L dot 2(R_"th" + R_L))/((R_"th" + R_L)^4)
  = V_"th"^2 (R_"th" - R_L)/((R_"th" + R_L)^3) $ <ec-dpl>

que se anula si y solo si

$ R_L = R_"th" $ <ec-max-pot>

y entonces la potencia entregada vale

$ p_(L,"máx") = (V_"th"^2)/(4 R_"th") $ <ec-pmax>

#clave[
  *Adaptar* la carga ($R_L = R_"th"$) maximiza la potencia entregada, pero el rendimiento
  en ese punto es
  $ eta = (p_L)/(p_"total") = (R_L)/(R_"th" + R_L) = 50% $
  La mitad de la energía se disipa *dentro* de la fuente. Eso es aceptable cuando lo que
  importa es extraer la máxima señal posible de un generador débil —una antena, un
  micrófono, un sensor— y es inadmisible en distribución de energía.
]

#atencion[
  Esta es la confusión más cara del tema. Una fuente de alimentación *no* se diseña
  adaptada: se diseña con $R_"th"$ lo más chica posible frente a la carga, para que la
  tensión no se caiga y para que el rendimiento sea alto. Si una fuente de 12 V con
  $R_"th" = 1 Omega$ alimentara una carga adaptada de $1 Omega$, entregaría 36 W a la
  carga *disipando otros 36 W adentro* y la salida caería a 6 V. Es justamente el
  problema que el regulador del Módulo 5 existe para evitar. Máxima potencia y máximo
  rendimiento son objetivos *distintos y opuestos*.
]

== Teorema de Millman

Caso particular útil: varias ramas en paralelo, cada una con una fuente de tensión
$V_k$ en serie con una resistencia $R_k$, todas entre los mismos dos nodos. Convirtiendo
cada rama a Norton, sumando las corrientes y volviendo a Thévenin:

$ V_"th" = (sum_k V_k G_k)/(sum_k G_k) = (sum_k V_k \/ R_k)/(sum_k 1\/R_k)
  quad quad R_"th" = 1/(sum_k G_k) $ <ec-millman>

Es literalmente la ecuación nodal de un solo nodo, despejada. Sirve para el caso concreto
de *fuentes en paralelo*: dos baterías distintas alimentando la misma carga, o el sumador
resistivo que reaparece en el Módulo 13 como sumador con amplificador operacional.

== Lo que estos teoremas explican de los módulos anteriores

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([*Lo que se vio antes*], [*Lo que es en realidad*]),
    [La *resistencia interna* de una pila y su caída al cargarla (Módulo 1)],
      [Es $R_"th"$ de la pila. La tensión de circuito abierto es $V_"th"$.],
    [El *efecto de carga* del voltímetro y del amperímetro (Módulo 1)],
      [El instrumento carga al equivalente de Thévenin del punto de medida. El error es
       $R_"th"\/(R_"th" + R_"instr")$.],
    [El *divisor cargado* que se derrumba (Ejercicio 7.1)],
      [$R_"th"$ del divisor es $R_1 parallel R_2$, y la carga tiene que ser mucho mayor.],
    [La *regulación* de una fuente (Módulo 5)],
      [Es la medida directa de $R_"th"$ de la fuente:
       $R_"th" = (V_"vacío" - V_"carga")\/I_"carga"$.],
    [El *zener* como regulador (Módulo 5)],
      [Un elemento cuya $R_"th"$ dinámica ($r_z$) es de pocos ohms, puesto en paralelo con
       la carga para dominar el equivalente.],
    [La adaptación del *parlante* de 8 $Omega$ o la antena de 50 $Omega$],
      [Máxima transferencia de potencia, @ec-max-pot.],
  ),
  caption: [Los teoremas, aplicados hacia atrás sobre la Parte I],
)

#tp("Con el TP N.º 8 y el Anexo 1 — guías de la cátedra")[
  *TP N.º 8 (fuente con regulador zener).* Medir la tensión de la fuente en vacío y con
  carga, y calcular la regulación, es medir el equivalente de Thévenin del aparato: la
  lectura en vacío es $V_"th"$ y la pendiente de la recta $V$ contra $I$ es $-R_"th"$.
  Levantar cuatro o cinco puntos con distintas cargas y ajustar la recta es la forma
  experimental del teorema, y sirve igual para una pila, un transformador o la salida de
  un amplificador.

  *Anexo 1 (PT100 en puente).* El circuito del anexo —20 V, dos ramas de 220 $Omega$, la
  PT100 de 100 $Omega$ con sus cables y la $R_3$ de 50 $Omega$— es un puente de Wheatstone,
  exactamente el del Ejercicio 9.2. Su equivalente de Thévenin visto desde la diagonal es
  lo que permite contestar, sin resolver todo el circuito de nuevo para cada temperatura,
  cuánto cambia la señal cuando la PT100 se calienta y cuánto error meten las
  resistencias de los cables.
]
