#import "../plantilla.typ": *

#modulo("Sistemas trifásicos y el transformador visto desde la fuente", [
  Escribir las tres tensiones de una red trifásica como fasores, pasar de fase a línea en
  estrella y en triángulo sin confundir el $sqrt(3)$ ni los $30 degree$, resolver una
  carga equilibrada con un circuito equivalente de una sola fase y calcular su potencia.
  Y mirar un transformador desde el lado de la fuente: qué impedancia «ve» el primario
  cuando en el secundario hay una carga, cómo se usa eso para adaptar, y cómo se pasa una
  impedancia real de su forma serie a la paralelo y al revés.
])

La red de tu casa es de $220$ V, y eso es *la mitad de la historia*. Lo que llega a la
cuadra son tres cables vivos y un neutro, y entre dos vivos cualesquiera hay $380$ V. Tu
casa está colgada de uno de los tres vivos y del neutro; la del vecino, quizás de otro.
Esa red —la de casi toda la energía eléctrica del mundo— se llama *trifásica*, y tiene una
lógica propia que con los fasores del Módulo 11 se resuelve en una página. La segunda
mitad del módulo vuelve al transformador, que el Módulo 10 presentó como dos bobinas
acopladas, para hacerle la pregunta que importa en un circuito: qué le hace a la fuente
que tiene conectada.

Las fuentes son el *Nilsson*: el capítulo 11 («Circuitos trifásicos equilibrados», p. 520)
para los trifásicos y los §9.10 y 9.11 para el transformador y la impedancia reflejada.

#atencion[
  *En este módulo los fasores van en valor eficaz*, no en pico como en el resto del
  apunte (ver la equivalencia en el bloque de convenciones, apartado E). No es un
  capricho: en potencia todo el mundo —las chapitas, las facturas, el Nilsson en su
  capítulo 11— habla en eficaz, y «380 V» es un valor eficaz. Las potencias, entonces, van
  *sin* el factor $1\/2$ del Módulo 11: $P = V I cos theta$ con $V$ e $I$ eficaces.
]

== Tres tensiones desfasadas 120°

Un generador trifásico son tres bobinados iguales, montados a $120 degree$ uno del otro
alrededor del mismo eje. Al girar el rotor cada uno genera una senoidal de la misma
amplitud y la misma frecuencia, y cada una llega a su pico un tercio de vuelta después que
la anterior.

#definicion("Tensiones de fase, secuencia positiva")[
  Con $V_f$ el valor eficaz de cada una (la *tensión de fase*, la que hay entre un vivo y
  el neutro):
  $ overline(V)_(a n) = V_f angle 0 degree quad quad
    overline(V)_(b n) = V_f angle ang("−120°") quad quad
    overline(V)_(c n) = V_f angle 120 degree $ <ec-fases>
  El orden $a$, $b$, $c$ en que pasan por el pico es la *secuencia*; la de arriba es la
  *positiva* (o $a b c$). La negativa ($a c b$) es la misma con $b$ y $c$ cambiadas, y
  existe: es lo que hace girar al revés un motor trifásico al que se le cruzaron dos
  cables.
]

Las tres sumadas dan *cero*: tres flechas iguales a $120 degree$ se cierran en un triángulo.
Esa propiedad, que parece de adorno, es la que hace barata a la trifásica (abajo).

#circuito([Las tres tensiones de fase y una de línea, como fasores])[
#graf-trifasico-fasores()
#pie-figura[La tensión de línea $overline(V)_(a b)$ es la resta de dos de fase. Sumarle
  $-overline(V)_(b n)$ a $overline(V)_(a n)$ da una flecha $sqrt(3)$ veces más larga y
  adelantada $30 degree$. Con $V_f = 220$ V, $sqrt(3) dot 220 = 381 approx 380$ V: los dos
  números de la red son el mismo, visto desde dos pares de cables.]
]

== Estrella y triángulo

Las tres cargas de una red trifásica se pueden conectar de dos maneras. En *estrella* (Y)
cada carga va de un vivo a un punto común, que puede ir al neutro: cada carga ve la
tensión de *fase*. En *triángulo* (Δ) cada carga va entre dos vivos: cada carga ve la
tensión de *línea*. Son las mismas dos formas del Módulo 7, «Transformación
triángulo-estrella», ahora con fuentes.

#definicion("Fase y línea")[
  - *Tensión de línea* $V_L$: entre dos vivos. *Corriente de línea* $I_L$: la que circula
    por un vivo.
  - *Tensión de fase* $V_f$ y *corriente de fase* $I_f$: las de *cada carga*.
  Con secuencia positiva:
  #figure(
    table(
      columns: (1.2fr, 2.3fr, 2.3fr),
      align: (left, left, left),
      table.header([], [*Estrella*], [*Triángulo*]),
      [Tensión], [$V_L = sqrt(3) thin V_f$, adelantada $30 degree$], [$V_L = V_f$],
      [Corriente], [$I_L = I_f$], [$I_L = sqrt(3) thin I_f$, atrasada $30 degree$],
    ),
    caption: [Lo que hay que saber de memoria (Nilsson §11.2 a §11.5)],
  )
]

La fila de la estrella se deduce de la figura de arriba:
$overline(V)_(a b) = overline(V)_(a n) - overline(V)_(b n)$, y la suma de dos flechas
iguales separadas $60 degree$ (porque se resta la de $-120 degree$) mide $2 V_f cos 30 degree =
sqrt(3) thin V_f$. La del triángulo es la misma cuenta con corrientes: la corriente de línea
$overline(I)_a$ es lo que llega por un vivo al vértice del triángulo, y por la LKC en ese
vértice vale $overline(I)_(a b) - overline(I)_(c a)$, la resta de dos corrientes de fase.

#clave[
  *Si la carga es equilibrada, una sola fase alcanza.* Con las tres impedancias iguales,
  las tres corrientes son iguales en módulo y desfasadas $120 degree$, y la corriente de
  neutro es su suma: cero. El neutro no lleva nada y se puede sacar. Se resuelve *una*
  fase —la $a$, con $overline(V)_(a n)$ y una impedancia— como un circuito del Módulo 11, y
  las otras dos son la misma respuesta corrida $plus.minus 120 degree$. Si la carga está en
  triángulo, primero se pasa a estrella con $Z_Y = Z_Delta \/ 3$ (Módulo 7, con tres ramas
  iguales).
]

== La potencia trifásica

Cada carga consume lo que dice el Módulo 11, y la potencia total es tres veces la de una
fase. Escrita con lo que se mide en los cables (tensión y corriente de línea), queda igual
en estrella y en triángulo (Nilsson §11.5, p. 536):

$ P = 3 thin V_f I_f cos theta = sqrt(3) thin V_L I_L cos theta quad quad
  Q = sqrt(3) thin V_L I_L sin theta quad quad
  S = sqrt(3) thin V_L I_L $ <ec-pot-trifasica>

#atencion[
  *El $theta$ es el ángulo de la impedancia de la carga*, o sea el desfasaje entre la
  tensión y la corriente *de una misma fase*. No es el ángulo entre $V_L$ e $I_L$, que está
  corrido $30 degree$ más. Es el error clásico de la fórmula: usar la tensión de línea con
  el ángulo de la línea. Si el resultado no coincide con $3 I_f^2 R$, el ángulo está mal.
]

#clave[
  *Por qué el mundo es trifásico.* En una red monofásica la potencia instantánea late al
  doble de la frecuencia de la red: cien veces por segundo pasa por un máximo y por un
  mínimo (Módulo 11). En una trifásica equilibrada, los tres latidos están desfasados y
  *suman una constante*: un motor trifásico recibe un empuje parejo y no vibra. Y para
  llevar la misma potencia hace falta menos cobre: tres cables (sin neutro, si la carga
  está equilibrada) en lugar de los seis de tres redes monofásicas.
]

#ejercicio("La misma carga en estrella y en triángulo, en la red de 380 V")[
  Tres impedancias iguales $Z = 8 + j 6 Omega$ ($10 angle 36,87 degree Omega$, factor de potencia
  $0,8$ inductivo) se conectan a la red de $3 times 380$ V, $50$ Hz, primero en estrella y
  después en triángulo. Se piden las corrientes y las potencias en los dos casos.

  *1. En estrella*, por fase. La tensión de fase es $V_f = 380\/sqrt(3) = 219,4$ V, y la
  corriente:
  $ overline(I)_a = (overline(V)_(a n))/(Z) = (219,4 angle 0 degree)/(10 angle 36,87 degree)
    = 21,94 angle ang("−36,87°") thin "A" $
  En estrella la de línea es la de fase: $I_L = 21,94$ A.

  *2. La potencia*, con @ec-pot-trifasica:
  $P = sqrt(3) dot 380 dot 21,94 dot 0,8 = 11 552$ W; $Q = sqrt(3) dot 380 dot 21,94 dot 0,6 =
  8664$ VAr; $S = 14 440$ VA.

  *3. Segundo camino: $I^2 R$ fase por fase.* Las tres corrientes valen $21,94$ A y cada una
  pasa por $8 Omega$: $P = 3 dot 21,94^2 dot 8 = 11 552$ W. Y por la reactancia,
  $Q = 3 dot 21,94^2 dot 6 = 8664$ VAr. Las tres corrientes complejas sumadas dan cero: el
  neutro no lleva nada.

  *4. En triángulo.* Cada carga ve ahora la tensión de *línea*: $I_f = 380\/10 = 38,0$ A, y
  en cada vivo $I_L = sqrt(3) dot 38 = 65,82$ A, atrasada $30 degree$ respecto de la
  corriente de fase. La potencia: $P = sqrt(3) dot 380 dot 65,82 dot 0,8 = 34 656$ W, y por
  el otro camino $3 dot 38^2 dot 8 = 34 656$ W.

  *5. Leer el resultado.* Las mismas tres impedancias consumen *el triple* en triángulo
  ($34 656 \/ 11 552 = 3$), porque cada una ve $sqrt(3)$ veces más tensión y la potencia va
  con el cuadrado. Es el principio del arranque estrella-triángulo de los motores grandes:
  se arranca en estrella, con un tercio de la corriente, y se pasa a triángulo cuando ya
  giran. Todos los números, y las tres fases complejas una por una, en `fase3-cuentas.py`,
  ejercicio 18.1.
]

== El transformador ideal, visto desde la fuente

El Módulo 10 («Cuando dos bobinas se acoplan: la inductancia mutua») dejó dos bobinas que
comparten el flujo. Si el acople es perfecto, el núcleo no pierde nada y no hace falta
corriente para magnetizarlo, queda el *transformador ideal*, que se describe con dos
relaciones y un número:

#definicion("Transformador ideal")[
  Con $N_1$ y $N_2$ las espiras del primario y del secundario, y la *relación de
  transformación* $a = N_1 \/ N_2$:
  $ overline(V)_1 / overline(V)_2 = a quad quad quad overline(I)_1 / overline(I)_2 = 1/a $ <ec-trafo-ideal>
  con las tensiones referidas a los puntos y las corrientes entrando por el punto del
  primario y saliendo por el del secundario. La primera dice que el flujo común induce
  la misma tensión por espira; la segunda, que lo que entra sale: $V_1 I_1 = V_2 I_2$.
]

Si en el secundario hay una impedancia $Z_L$, entonces $overline(V)_2 = Z_L overline(I)_2$,
y lo que mide la fuente en los bornes del primario es

$ Z_"in" = overline(V)_1/overline(I)_1 = (a overline(V)_2)/(overline(I)_2 \/ a)
  = a^2 thin Z_L $ <ec-reflejada>

#clave[
  *La impedancia se refleja con el cuadrado de la relación.* Las tensiones pasan
  multiplicadas por $a$, las corrientes divididas por $a$, y las impedancias —que son su
  cociente— multiplicadas por $a^2$. Un transformador es, para la fuente, un *cambiador de
  impedancias*: un parlante de $8 Omega$ detrás de un $10:1$ se ve como $800 Omega$. Y vale
  para cualquier cosa que haya en el secundario, también para la resistencia del propio
  bobinado: se la pasa al primario multiplicándola por $a^2$ y el transformador
  desaparece del dibujo.
]

#circuito([Un amplificador que alimenta un parlante a través de un transformador])[
#fig-trafo-adaptacion()
#pie-figura[A la izquierda de la línea punteada, la fuente no sabe que hay un
  transformador: ve una resistencia $a^2 R_L$. Eligiendo $a$ se elige qué resistencia ve.]
]

=== Para qué sirve: adaptar

El Módulo 9 («Máxima transferencia de potencia») dijo que una fuente entrega la máxima
potencia cuando la carga es igual a su resistencia de Thévenin. Casi nunca lo es —un
amplificador a válvulas tiene cientos de ohm de salida y un parlante, ocho—, pero con un
transformador se *hace* que lo sea: se elige $a$ tal que $a^2 R_L = R_"th"$.

=== Las formas serie y paralelo de una impedancia

Un transformador real tiene pérdidas: la resistencia de los bobinados y las reactancias de
dispersión, que se modelan *en serie*, y las pérdidas del núcleo y la corriente para
magnetizarlo, que se modelan *en paralelo*. Reflejando todo al primario con @ec-reflejada
quedan los dos equivalentes que se miden en el laboratorio: el serie con el ensayo de
cortocircuito y el paralelo con el de vacío. Para mover una impedancia de una forma a la
otra a una frecuencia dada:

$ R_p = (R_s^2 + X_s^2)/R_s quad quad quad X_p = (R_s^2 + X_s^2)/X_s $ <ec-serie-paralelo>

Sale de igualar admitancias: $1\/(R_s + j X_s) = 1\/R_p + 1\/(j X_p)$. Y el factor de mérito
no cambia de una forma a la otra: $Q = X_s \/ R_s = R_p \/ X_p$. Con $Q$ alto,
$R_p approx Q^2 R_s$ y $X_p approx X_s$: una resistencia serie chica se ve, en paralelo,
como una enorme (Nilsson §9.10 y 9.11 para el transformador).

#ejercicio("Adaptar un parlante, y una bobina real en sus dos formas")[
  Un amplificador tiene un equivalente de Thévenin de $V_"th" = 10$ V eficaces y
  $R_"th" = 800 Omega$. Hay que alimentar un parlante de $R_L = 8 Omega$.

  *1. Conectado directo.* $I = 10\/(800 + 8) = 12,4$ mA y
  $P = 8 dot 0,0124^2 = 1,23$ mW. Casi toda la potencia se queda en la resistencia interna.

  *2. Con transformador.* Para adaptar, $a^2 dot 8 = 800$, o sea $a = 10$: un $10:1$. La
  fuente ve $800 Omega$ y entrega la máxima potencia posible,
  $P = V_"th"^2 \/(4 R_"th") = 100\/3200 = 31,25$ mW, que en un transformador ideal llega
  entera al parlante. Son $31,25\/1,23 = 25,5$ veces más.

  *3. Segundo camino: las ecuaciones del transformador, sin la fórmula de la reflejada.*
  Cuatro incógnitas ($I_1$, $V_1$, $V_2$, $I_2$) y cuatro ecuaciones: la malla del
  primario $10 = 800 I_1 + V_1$, las dos de @ec-trafo-ideal ($V_1 = 10 V_2$, $I_2 = 10 I_1$)
  y la carga ($V_2 = 8 I_2$). Resueltas como sistema dan $V_2 = 0,5$ V e $I_2 = 62,5$ mA, o
  sea $P = 0,5^2\/8 = 31,25$ mW; y $V_1 \/ I_1 = 800 Omega$, la impedancia reflejada
  (`fase3-cuentas.py`, ejercicio 18.2).

  *4. La bobina del primario, en sus dos formas.* A $50$ Hz el bobinado tiene
  $R_s = 10 Omega$ y $X_s = 100 Omega$ en serie. Con @ec-serie-paralelo:
  $R_p = (100 + 10 000)\/10 = 1010 Omega$ y $X_p = 10 100\/100 = 101 Omega$. Control: el $Q$
  da $100\/10 = 10$ en serie y $1010\/101 = 10$ en paralelo; y la admitancia
  $1\/(10 + j 100)$ tiene parte real $1\/1010$ e imaginaria $-1\/101$: lo mismo.
]

#clave[
  *Lo que une las dos mitades del módulo*: el transformador es la pieza que hace posible
  la red trifásica —se genera en media tensión, se transporta en alta y se distribuye en
  $380\/220$ V gracias a él— y la impedancia reflejada es la cuenta que dice qué ve el
  generador detrás de toda esa cadena. Un transformador de distribución de la cuadra son
  tres transformadores, uno por fase, y cada uno se resuelve con la primera mitad de esta
  sección.
]
