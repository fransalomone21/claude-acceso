#import "../plantilla.typ": *

#modulo("Fuentes de alimentación lineales", [
  Reconocer cada etapa de una fuente y qué le hace a la señal, deducir y calcular el
  rizado de un filtro capacitivo, elegir el capacitor para un ripple dado, y diseñar una
  etapa reguladora con diodo zener verificando corrientes y potencias.
])

== Anatomía de una fuente lineal

La red entrega 220 V eficaces de alterna a 50 Hz. Un circuito electrónico necesita, por
ejemplo, 5 V de continua estables. Entre una cosa y la otra hay cuatro etapas, y cada una
resuelve *un solo* problema.

#circuito([Diagrama en bloques de una fuente de alimentación lineal])[
#fig-bloques-fuente()
]

+ *Transformador*: baja el valor pico de 311 V a algo manejable, y aísla galvánicamente el
  circuito de la red. Módulo 3.
+ *Rectificador*: convierte la alterna en una señal de un solo signo. Módulo 4.
+ *Filtro*: rellena los valles entre pulsos y deja una continua con un rizado pequeño.
+ *Regulador*: fija la salida en un valor exacto, independiente de la carga y del rizado
  que quedó.

#atencion[
  Las etapas 1 y 2 trabajan con la *red*. Al armar la fuente en el protoboard, el
  primario del transformador y sus conexiones son *220 V que matan*. Se conecta con el
  transformador desenchufado, se revisa, se aleja la mano, y recién ahí se enchufa. Nunca
  se toca el primario con la fuente energizada.
]

== El filtro capacitivo

Después del rectificador la señal tiene el signo correcto, pero cae a cero entre pulso y
pulso. Un capacitor en paralelo con la carga resuelve eso funcionando como un *reservorio*:
se carga hasta el pico cuando el rectificador entrega, y alimenta a la carga con esa
energía mientras el rectificador no entrega nada.

#circuito([Filtro capacitivo a la salida del rectificador])[
#fig-filtro-capacitivo()
#v(6pt)
#graf-rizado()
]

=== Deducción del rizado

Mientras el capacitor alimenta solo a la carga, se descarga. La corriente en un capacitor
vale

$ i = C (dif v)/(dif t) $

Como la descarga entre pulsos es una porción muy chica de la exponencial, se la aproxima
por una *recta*, lo que permite pasar de derivadas a incrementos:

$ I_"cc" = C (Delta V_r)/(Delta t) $

Falta saber cuánto dura esa descarga. El capacitor se recarga *una vez por cada pulso del
rectificador*, así que $Delta t = 1\/f_r$, donde $f_r$ es la frecuencia del ripple.
Reemplazando y despejando:

$ Delta V_r = I_"cc" / (f_r dot C) $ <ec-ripple>

Y de la misma expresión sale el capacitor necesario para un rizado deseado:

$ C = I_"cc" / (f_r dot Delta V_r) $ <ec-capacitor>

Como la tensión oscila entre $V_p$ y $V_p - Delta V_r$, el valor continuo de salida es el
promedio:

$ V_"cc" = V_p - (Delta V_r) / 2 $ <ec-vcc-filtro>

Y el rizado relativo, que es la cifra de mérito de la fuente:

$ r% = (Delta V_r) / V_"cc" dot 100 $ <ec-ripple-pct>

#clave[
  En la @ec-ripple, $f_r$ *no es la frecuencia de la red*: es la frecuencia con que el
  rectificador entrega pulsos. Vale *50 Hz en media onda* y *100 Hz en onda completa*
  (punto medio o puente). Ahí está la ventaja decisiva del puente: al duplicarse $f_r$, el
  rizado se reduce a la mitad con el mismo capacitor — o alcanza *un capacitor la mitad de
  grande* para el mismo rizado. Es el error más frecuente del módulo: usar 50 Hz en un
  puente.
]

#laboratorio[
  Los capacitores de filtro son *electrolíticos* y tienen *polaridad*: la banda con el
  signo menos va al negativo. Conectado al revés, un electrolítico se calienta y explota,
  literalmente. También tienen una tensión máxima impresa: para un pico de 17 V, se usa
  uno de 25 V o 35 V, nunca de 16 V.
]

#ejercicio("Rizado de un puente y de una media onda, comparados")[
  Entrada de 12 V#sub[ef], carga $R_L = 1$ k$Omega$, capacitor de filtro $C = 100 mu$F.
  Calcular la salida y el rizado con un puente de Graetz, y compararlo con media onda.
  (Es el corazón del TP N.º 7, partes 1 y 2.)

  *— Puente de Graetz —*

  *1. Valor pico, descontando los dos diodos del puente*:
  $ V_p = 12 dot sqrt(2) = 17 "V" quad arrow.r.double quad V_p' = 17 - 1,4 = 15,6 "V" $

  *2. Corriente continua de carga* (primera aproximación, $V_"cc" approx V_p'$):
  $ I_"cc" = V_p'/R_L = (15,6 "V")/(1000 Omega) = 15,6 "mA" $

  *3. Frecuencia del ripple*: puente $arrow.r$ $f_r = 2 dot 50 = 100$ Hz.

  *4. Rizado*, con la @ec-ripple:
  $ Delta V_r = I_"cc"/(f_r dot C) = (15,6 dot 10^(-3))/(100 dot 100 dot 10^(-6))
    = (15,6 dot 10^(-3))/(10^(-2)) = 1,56 "V" $

  *5. Tensión continua de salida*, con la @ec-vcc-filtro:
  $ V_"cc" = 15,6 - (1,56)/2 = 14,8 "V" $

  *6. Rizado porcentual*: $r% = 1,56\/14,8 dot 100 = 10,5%$.

  *— Media onda, mismo circuito —*

  Un solo diodo: $V_p' = 17 - 0,7 = 16,3$ V, y $f_r = 50$ Hz.
  $ I_"cc" = (16,3 "V")/(1000 Omega) = 16,3 "mA" quad arrow.r.double quad
    Delta V_r = (16,3 dot 10^(-3))/(50 dot 100 dot 10^(-6)) = 3,26 "V" $
  $ V_"cc" = 16,3 - 1,63 = 14,7 "V" quad arrow.r.double quad r% = 22,2% $

  *Conclusión*: con *el mismo capacitor y la misma carga*, el puente tiene *la mitad del
  rizado* que la media onda (10,5 % contra 22,2 %). No es por los diodos: es porque
  recarga el capacitor el doble de veces por segundo. Comparar con el Ejercicio 4.2, donde
  la misma media onda *sin capacitor* daba 5,2 V: el filtro subió la salida de 5,2 V a
  14,7 V. El capacitor no solo alisa, también *eleva* la tensión continua, porque la lleva
  del valor medio al valor de pico.
]

#ejercicio("Elegir el capacitor para un rizado dado")[
  Se quiere una fuente con puente de Graetz de 15 V y 500 mA, con un rizado *menor al 5 %*.
  ¿Qué capacitor hace falta?

  *1. Rizado admisible en volts*, de la @ec-ripple-pct:
  $ Delta V_r = (5%)/100 dot 15 "V" = 0,75 "V" $

  *2. Capacitor necesario*, con la @ec-capacitor ($f_r = 100$ Hz por ser puente):
  $ C = I_"cc"/(f_r dot Delta V_r) = (0,5 "A")/(100 "Hz" dot 0,75 "V")
    = (0,5)/(75) = 6,67 dot 10^(-3) "F" = "6667 µF" $

  *3. Valor comercial*: se elige el inmediato superior de la serie, *6800 µF*, o
  directamente *10 000 µF* si hay lugar. Nunca uno menor: el rizado quedaría por encima
  del pedido.

  *4. Tensión del capacitor*: el pico es de unos 16,5 V, así que se usa uno de *25 V*
  como mínimo.

  *Observación de diseño*: si la misma fuente fuera de media onda, con $f_r = 50$ Hz haría
  falta *el doble*: 13 300 µF. Los capacitores electrolíticos grandes son caros,
  voluminosos y de vida limitada. Ese es el argumento económico que decide el puente.
]

=== Sin carga y con carga: por qué el tester marca de más

La consigna del TP N.º 7 pide medir la salida continua *sin carga y con carga*, en las
tres partes. No es una repetición: son dos números distintos, y la diferencia entre ellos
es exactamente el rizado.

Sin carga, $I_"cc" = 0$. La @ec-ripple da entonces $Delta V_r = 0$: el capacitor se carga
al pico y *nadie lo descarga*, así que se queda ahí. La salida es el valor de pico limpio,
y en el osciloscopio se ve una recta.

$ V_"cc(sin carga)" = V_p' quad quad quad V_"cc(con carga)" = V_p' - (Delta V_r)/2 $

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([Fuente con $C = 100 mu$F], [Sin carga], [Con $R_L = 1$ k$Omega$], [Diferencia]),
    [Media onda ($V_p' = 16,3$ V)], [16,3 V], [14,7 V], [1,6 V],
    [Puente ($V_p' = 15,6$ V)],     [15,6 V], [14,8 V], [0,8 V],
  ),
  caption: [Lo mismo medido de las dos maneras. La diferencia es $Delta V_r \/ 2$],
)

#atencion[
  *Un transformador de «12 V» no entrega 12 V en vacío.* Ese número es su tensión de
  secundario *a plena carga*: sin carga, la caída interna desaparece y el secundario da
  entre 10 y 15 % más — 13 o 14 V eficaces son normales en un transformador chico. Con
  13,5 V eficaces el pico sube a 19,1 V y toda la tabla de arriba se corre un volt y
  medio para arriba. *Antes de dar por mala una medición, se mide el secundario con el
  tester*: casi todas las diferencias grandes entre lo calculado y lo medido salen de
  ahí, y no del filtro.
]

#clave[
  Las dos mediciones juntas dicen algo que ninguna dice sola: una fuente *siempre* se ve
  mejor en vacío. Sin carga no hay rizado, la tensión es la máxima posible y el
  osciloscopio muestra una línea perfecta. Toda la ingeniería de una fuente —el tamaño
  del capacitor, la topología, el regulador— existe para el caso *con* carga. Medir sólo
  en vacío es medir la fuente en la única condición en la que no hace falta.
]

== La fuente doble (simétrica)

Un amplificador operacional, un amplificador de audio o un puente H no necesitan *una*
tensión continua: necesitan *dos*, una positiva y una negativa, medidas contra una masa
común. Eso es una fuente doble, y es la parte 3 del TP N.º 7.

#circuito([Fuente doble: puente sobre el secundario completo, masa en el punto medio])[
#fig-fuente-doble()
#pie-figura[El puente rectifica los 24 V eficaces del secundario *completo*. El
  punto medio no se conecta al puente: se toma como *masa*, y parte la salida en dos
  mitades iguales. «$+V$» y «$-V$» no son dos fuentes distintas — son los dos
  extremos de la misma salida, nombrados respecto del punto del medio.]
]

#atencion[
  *No confundirla con el rectificador de punto medio del Módulo 4.* Aquel usa *dos*
  diodos, el punto medio es el retorno de la carga y la salida es *una sola* rama. Éste
  usa *cuatro*, el punto medio no toca el puente y la salida son *dos* ramas de signo
  opuesto. Mismo transformador, circuitos distintos y resultados distintos.
]

=== Qué tensión da cada rama

Conviene seguir un semiciclo a la vez, con el punto medio $M$ como referencia. Llamemos
$V_p$ al pico de *media* bobina (la de $A$ a $M$, o la de $M$ a $B$).

- *Semiciclo en que $A$ es positivo*: el nodo $+V$ es el cátodo común de $D_1$ y $D_2$, y
  se va con el más alto de los dos extremos, que es $A$: queda en $V_p - 0,7$ V. El nodo
  $-V$ es el ánodo común de $D_3$ y $D_4$, y se va con el más bajo, que es $B$: queda en
  $-(V_p - 0,7)$ V.
- *Semiciclo en que $B$ es positivo*: pasa exactamente lo mismo con los papeles
  cambiados — $+V$ se va con $B$ por $D_2$, y $-V$ con $A$ por $D_3$.

$ V_(p+) = V_p - 0,7 "V" quad quad quad V_(p-) = -(V_p - 0,7 "V") $ <ec-fuente-doble>

#clave[
  *Cada rama pierde UN diodo, no dos.* Es el resultado que sorprende: el circuito tiene
  un puente de cuatro diodos, y en un puente común la salida pierde 1,4 V. Acá los dos
  diodos que conducen en cada semiciclo no están en serie con *una* carga: están uno en
  cada rama. La salida total $+V$ a $-V$ sí pierde los 1,4 V —$2(V_p - 0,7) = 2V_p -
  1,4$—, pero como el punto medio la parte al medio, a cada mitad le toca una sola caída.
  Verificación cruzada: $2 V_p$ es el pico del secundario completo, y $2 V_p - 1,4$ es lo
  que un puente le saca. Cierra.

  Y también: cada rama se recarga *dos veces por ciclo*, así que $f_r = 100$ Hz, igual
  que en el puente.
]

#ejercicio("Fuente doble de ±15 V con transformador de punto medio")[
  Transformador con punto medio de $12 V_"ef"$ *en cada bobina*, cuatro diodos 1N4007 en
  puente, $C_1 = C_2 = 100 mu$F y una carga de 1 k$Omega$ en cada rama. Calcular las dos
  tensiones de salida, la corriente de cada rama y el rizado. (Es la parte 3 del TP
  N.º 7.)

  *1. Pico de media bobina*:
  $ V_p = 12 dot sqrt(2) = 16,97 approx 17 "V" $

  *2. Pico de cada rama*, con la @ec-fuente-doble:
  $ V_(p+) = 17 - 0,7 = 16,3 "V" quad quad quad V_(p-) = -16,3 "V" $

  *3. Corriente de cada rama* (primera aproximación, $V_"cc" approx V_p'$):
  $ I_(L 1) = I_(L 2) = (16,3 "V")/(1000 Omega) = 16,3 "mA" $

  *4. Rizado de cada rama*, con la @ec-ripple y $f_r = 100$ Hz:
  $ Delta V_r = I_"cc"/(f_r dot C) = (16,3 dot 10^(-3))/(100 dot 100 dot 10^(-6)) = 1,63 "V" $

  *5. Tensión continua de cada salida*, con la @ec-vcc-filtro:
  $ V_(+) = 16,3 - (1,63)/2 = +15,5 "V" quad quad quad V_(-) = -15,5 "V" $

  *6. Rizado porcentual*: $r% = 1,63\/15,5 dot 100 = 10,5%$ en cada rama.

  *7. Corriente por el punto medio.* Por el nodo $M$ entra $I_(L 2)$ y sale $I_(L 1)$:
  $ I_M = I_(L 1) - I_(L 2) = 0 $
  Con las dos cargas iguales el punto medio *no conduce nada*. Sólo lleva corriente
  cuando las ramas están desbalanceadas, y entonces lleva la diferencia.

  *Comparación con el puente simple del Ejercicio 5.1*, que con los mismos $12 V_"ef"$ y
  el mismo capacitor daba 14,8 V: acá cada rama da *15,5 V*, casi un volt más. La
  diferencia son los 0,7 V del segundo diodo que esta topología no paga. La fuente doble
  no sólo da dos tensiones: da *más* tensión por rama que el puente común sobre la misma
  bobina.
]

== El regulador con diodo zener

Después del filtro la tensión todavía tiene rizado, y además *cambia cuando cambia la
carga*. El regulador resuelve las dos cosas.

#definicion("Diodo zener")[
  Un zener es un diodo diseñado para trabajar *en polarización inversa*, en su zona de
  ruptura. En esa zona mantiene entre sus bornes una tensión prácticamente constante — la
  *tensión de zener* $V_Z$ — aunque la corriente que lo atraviesa varíe mucho. Se lo
  fabrica con valores normalizados: 3,3 V; 4,7 V; 5,1 V; 6,2 V; 9,1 V; 12 V…
]

#circuito([Curva característica del zener: el codo inverso es su zona de trabajo])[
#graf-curva-zener()
#pie-figura[Pasado el vértice, la tensión queda clavada en $V_Z$ aunque la corriente
  cambie muchísimo: eso es lo que regula. Hay que quedarse entre $I_(Z "mín")$ —por
  debajo la regulación se pierde— e $I_(Z "máx")$ —por encima se quema.]
]

#circuito([Regulador paralelo con diodo zener])[
#fig-regulador-zener()
#pie-figura[$I_S = I_Z + I_L$. El zener va con el cátodo hacia arriba: trabaja
  en polarización inversa.]
]

El zener va *en paralelo* con la carga, y una resistencia $R_S$ *en serie* limita la
corriente total. El mecanismo de regulación es el reparto: si la carga pide más corriente,
el zener cede parte de la suya; si la carga pide menos, el zener absorbe el sobrante. La
suma se mantiene, y con ella la tensión.

Las tres ecuaciones del circuito son:

$ I_S = I_Z + I_L quad quad quad
  I_L = V_Z / R_L quad quad quad
  R_S = (V_"in" - V_Z) / I_S $ <ec-zener>

=== Criterio de diseño

$R_S$ tiene que cumplir dos condiciones simultáneas, y hay que verificar las dos:

+ *En el peor caso de mínima*, con $V_"in"$ en su valor más bajo (el valle del ripple) y
  la carga consumiendo el máximo, tiene que sobrar corriente para que el zener siga
  regulando: $I_Z >= I_(Z "mín")$, típicamente 5 mA. Esto fija el *valor máximo* de $R_S$.
+ *En el peor caso de máxima*, con $V_"in"$ en su valor más alto y *sin carga*, toda la
  corriente pasa por el zener. Hay que verificar que no supere su potencia:
  $P_Z = V_Z dot I_Z <= P_(Z "máx")$.

$ R_(S "máx") = (V_("in mín") - V_Z) / (I_(Z "mín") + I_(L "máx")) $ <ec-rs>

#atencion[
  Si $R_S$ es *demasiado grande*, en el peor caso no queda corriente para el zener, el
  zener sale de la zona de ruptura y *la regulación desaparece*: la salida cae y sigue el
  ripple. Si $R_S$ es *demasiado chica*, en vacío el zener recibe toda la corriente y *se
  quema*. Las dos verificaciones son obligatorias; hacer solo una es el error típico.
]

=== Cuánto rizado queda después del zener

La consigna del TP N.º 8 pide *evaluar la reducción del rizado*. «Baja mucho» no es una
evaluación: es una impresión. El número sale de una sola idea — para la componente
*alterna* que queda arriba de la continua, el zener no es una tensión fija, es una
*resistencia chica*.

#definicion("Resistencia dinámica del zener")[
  $r_z$ es la pendiente de la curva del zener en su zona de trabajo: cuánto se mueve
  $V_Z$ por cada miliampere que cambia $I_Z$. Es lo que hace que la curva no sea
  perfectamente vertical. El datasheet la da como $Z_(Z T)$ a una corriente de prueba: el
  1N4733 declara *7 $Omega$ a 49 mA*, y crece al bajar la corriente — cerca de los 10 mA
  en que trabaja este circuito, ronda los *30 a 40 $Omega$*.
]

Para el rizado, entonces, $R_S$ y $r_z$ forman un divisor de tensión común y corriente:

$ (Delta V_"sal")/(Delta V_"ent") = (r_z parallel R_L)/(R_S + (r_z parallel R_L)) approx r_z/(R_S + r_z) $ <ec-rechazo-zener>

La aproximación vale porque $r_z$ es dos órdenes de magnitud más chica que $R_L$: el
paralelo lo fija el zener casi solo, y *la carga casi no interviene*. Con los valores del
ejercicio que sigue ($R_S = 820 Omega$, $Delta V_"ent" = 1,56$ V):

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center, center, center),
    table.header([$r_z$ supuesta], [$Delta V_"sal"$ esperado], [Reducción]),
    [7 $Omega$ (dato de tabla, a 49 mA)],  [13 mV],  [× 120],
    [35 $Omega$ (estimada a 10 mA)],       [62 mV],  [× 25],
  ),
  caption: [Rizado que queda después del zener, según la $r_z$ que se le suponga],
) <tab-rizado-zener>

#clave[
  *La predicción que hay que ir a refutar al laboratorio*: el rizado tiene que bajar
  entre *25 y 120 veces*, o sea de 1,56 V a algo entre 13 y 62 mV. Si se mide una
  reducción mucho menor —digamos, de sólo diez veces— la explicación casi segura no es
  que $r_z$ sea grande, sino que *el zener se está apagando en el valle del rizado*:
  $I_Z$ cae por debajo del mínimo, el zener deja de regular durante una parte del ciclo y
  la salida sigue a la entrada. Se confirma bajando $R_S$ y viendo si el rizado baja.
]

#atencion[
  Ese rizado *no se ve* con el osciloscopio en acoplamiento CC y 1 V/div: 60 mV sobre
  5,1 V es un espesor de línea. Se mide con *acoplamiento CA* y bajando a 20 o 50
  mV/div, que es lo que corre la continua fuera de la pantalla y deja sólo la ondulación.
  Es el mismo procedimiento de la sección «El osciloscopio» del Módulo 2, y es la única
  forma de que el punto 3 del TP dé un número en vez de «se ve plano».
]

#ejercicio("Fuente regulada con zener 1N4733")[
  Diseñar la etapa reguladora del TP N.º 8: salida de 5,1 V con zener *1N4733*
  ($V_Z = 5,1$ V, $P_(Z "máx") = 1$ W), carga $R_L = 1$ k$Omega$, alimentada por la fuente
  sin regular del *Ejercicio 5.1*, el puente de Graetz ($V_"cc" = 14,8$ V con
  $Delta V_r = 1,56$ V) — no la del 5.3, que es la fuente doble.

  *1. Corriente de carga*:
  $ I_L = V_Z/R_L = (5,1 "V")/(1000 Omega) = 5,1 "mA" $

  *2. Peor caso de entrada mínima* — el valle del ripple:
  $ V_("in mín") = V_"cc" - (Delta V_r)/2 = 14,8 - 0,78 = 14,0 "V" $

  *3. Máxima $R_S$ admisible*, con la @ec-rs y $I_(Z "mín") = 5$ mA:
  $ R_(S "máx") = (14,0 - 5,1)/((5 + 5,1) dot 10^(-3)) = (8,9)/(10,1 dot 10^(-3)) = 881 Omega $

  *4. Valor comercial adoptado*: $R_S = 820 Omega$ (el valor E24 inmediato inferior;
  tomar uno mayor violaría la condición).

  *5. Verificación en el peor caso de máxima* — cresta del ripple y carga desconectada:
  $ V_("in máx") = V_"cc" + (Delta V_r)/2 = 15,6 "V" $
  $ I_(Z "máx") = (V_("in máx") - V_Z)/R_S = (15,6 - 5,1)/(820) = 12,8 "mA" $
  $ P_Z = V_Z dot I_(Z "máx") = 5,1 "V" dot 12,8 "mA" = 65 "mW" $
  Contra 1 W admisible: *sobra muchísimo*. El zener está seguro.

  *6. Potencia disipada en $R_S$*:
  $ P_(R_S) = (V_("in máx") - V_Z)^2/R_S = (10,5)^2/820 = 134 "mW" $
  Una resistencia de 1/4 W (250 mW) alcanza, pero queda al 54 % de su límite y se va a
  calentar. *Se elige una de 1/2 W*, que trabaja holgada.

  *7. Verificación de la condición mínima, ya con el valor adoptado*:
  $ I_S = (14,0 - 5,1)/820 = 10,9 "mA" quad arrow.r.double quad
    I_Z = I_S - I_L = 10,9 - 5,1 = 5,8 "mA" $
  Es mayor que los 5 mA mínimos: *el zener regula durante todo el ciclo*, incluso en el
  valle del ripple. Diseño verificado en ambos extremos.

  *Resultado esperado en el laboratorio*: en el punto 2 (antes del zener) el osciloscopio
  debe mostrar 14,8 V con 1,56 V#sub[pp] de rizado; en el punto 3 (después del zener),
  5,1 V con un rizado de *entre 13 y 62 mV* según la @tab-rizado-zener. Esa reducción
  —de 25 a 120 veces— es la demostración de que la etapa regula, y es un número que se
  puede comparar contra lo medido.
]

== Lo que se mide, y cómo

Los tres prácticos del cuatrimestre piden lo mismo tres veces: *medir la continua con el
tester, el rizado con el osciloscopio, y capturar las formas de onda*. Los cálculos de
este módulo dicen qué número tiene que salir; esta sección dice cómo sacarlo sin arruinar
la medición ni el instrumento.

=== El rizado se mide en alterna

El tester en continua promedia: sobre una salida de 14,8 V con 1,56 V de rizado marca
14,8 V y nada más. El rizado *no es un valor medio*, es lo que varía, y para verlo hay
que sacar la continua del medio.

+ Osciloscopio en *acoplamiento CA*. El capacitor de entrada bloquea la continua y la
  traza se centra sola en cero.
+ Bajar el *Volts/Div* hasta que la ondulación ocupe media pantalla. Para 1,5 V de
  rizado: 0,5 V/div. Para los milivolts de después del zener: 20 o 50 mV/div.
+ *Tiempo/Div* para ver dos o tres ciclos: con $f_r = 100$ Hz el período es de 10 ms, así
  que 2 ms/div muestra dos ciclos.
+ Se lee *pico a pico*, contando divisiones de la cresta al valle. Ése es el
  $Delta V_r$ que los cálculos predicen — la fórmula da directamente el valor pico a
  pico, no la amplitud.

#laboratorio[
  El rizado de una fuente con filtro no es senoidal: es un *diente de sierra*, con la
  recarga rápida del capacitor y la descarga lenta por la carga. Si en la pantalla se ve
  una senoidal, lo más probable es que el capacitor no esté conectado, o que esté
  conectado al revés y en camino de explotar.
]

=== La masa del osciloscopio está conectada a tierra

Es el punto donde el TP N.º 7 se pone peligroso, y la consigna no lo menciona.

#atencion[
  *El cocodrilo de la punta del osciloscopio no es un cable cualquiera: está unido al
  tercer pin del enchufe, o sea a tierra.* Todo lo que se toque con él queda puesto a
  tierra. De ahí salen las dos reglas del banco:

  - *Nunca se conecta la punta al primario del transformador*, ni a nada del lado de los
    220 V. Poner a tierra un lado de la red produce un cortocircuito o deja la carcasa
    del instrumento a 220 V.
  - En la *fuente doble*, todos los cocodrilos van al *punto medio* y a ningún otro lado.
    Con dos canales, uno en $+V$ y otro en $-V$, el segundo cocodrilo en $-V$
    *cortocircuita $-V$ contra la masa* —porque los dos cocodrilos son el mismo nodo,
    tierra— y quema $D_3$, $D_4$ o el capacitor. Las dos ramas se miran con los dos
    canales y *un solo* punto de masa.
]

El secundario del transformador está aislado de la red, así que poner a tierra el punto
medio no tiene ningún problema: es justamente lo que lo vuelve la referencia. La
aislación galvánica del Módulo 3 no es un detalle de catálogo — es lo que hace que esta
medición se pueda hacer.

=== Qué capturar, y de qué sirve

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([Señal], [Cómo], [Qué tiene que mostrar]),
    [Entrada de alterna (secundario)], [CA, 5 V/div, 5 ms/div],
    [Senoidal limpia de 50 Hz. Su pico dividido $sqrt(2)$ es el $V_"ef"$ real, que casi
     nunca es el de la chapita.],
    [Salida rectificada *sin* filtro], [CC, 5 V/div, 5 ms/div],
    [Media onda: un lomo cada 20 ms. Puente: dos lomos cada 20 ms, pegados y sin llegar a
     cero. Es la prueba visual de que $f_r$ se duplicó.],
    [Salida *con* filtro], [CC para la continua, después CA para el rizado],
    [En CC, una recta con una ondulación apenas visible arriba. En CA, el diente de
     sierra a escala. Las dos capturas son la misma señal: una da $V_"cc"$ y la otra
     $Delta V_r$.],
    [Salida regulada (TP N.º 8)], [CA, 20 mV/div],
    [Lo que queda del diente de sierra después del zener, entre 13 y 62 mV según la
     @tab-rizado-zener.],
  ),
  caption: [Las cuatro capturas que piden los TP N.º 7 y 8, y qué prueba cada una],
)

#clave[
  Cada captura existe para *contestar una pregunta*, no para llenar el informe. La de sin
  filtro prueba que el rectificador rectifica; la de con filtro, cuánto alisa el
  capacitor; la de después del zener, cuánto regula el zener. Una captura sin la pregunta
  al lado es una foto de una pantalla.
]

== Reguladores integrados

En la práctica moderna el zener se reemplaza por un *regulador integrado de tres patas*:
la familia *78xx* para tensiones positivas (7805 = 5 V, 7812 = 12 V) y la *79xx* para
negativas. Internamente contienen un zener de referencia, un amplificador de error y un
transistor de paso, y agregan protección contra cortocircuito y contra sobretemperatura.

Se conectan con la entrada al filtro, la salida a la carga, la pata del medio a masa, y un
capacitor cerámico de 100 nF a cada lado. Requieren unos 2 V de diferencia entre entrada y
salida para funcionar. La fuente doble del TP N.º 7, parte 3, con un 7812 y un 7912, es la
forma industrial del mismo problema.

#tp("TP N.º 7 y 8 — II Cuatrimestre")[
  - *TP 7, parte 1 (media onda)*: Ejercicio 4.2 para el cálculo sin filtro, y el Ejercicio
    5.1 para el rizado con 100 µF. Las mediciones *sin carga y con carga* que pide la
    consigna están en «Sin carga y con carga».
  - *TP 7, parte 2 (puente)*: Ejercicio 5.1, primera mitad. La comparación medida contra
    calculada debe dar diferencias de menos del 10 %; si da más, revisar la tensión real
    del secundario con el tester, que casi nunca es exactamente 12 V. La corriente que la
    consigna pide *por cada diodo* es la mitad de la media total: en un puente cada diodo
    conduce un semiciclo de cada dos.
  - *TP 7, parte 3 (fuente doble con punto medio)*: es la sección «La fuente doble
    (simétrica)» y el Ejercicio 5.3. Ojo con el circuito: la consigna pide *cuatro*
    diodos sobre el secundario completo con el punto medio como masa, que no es el
    rectificador de punto medio de dos diodos del Módulo 4.
  - *TP 8 (regulador zener)*: es el Ejercicio 5.4 completo. Prestar atención a la consigna
    «verificar que la corriente mínima de mantenimiento se cumpla *en todo momento*»: eso
    significa verificar en el valle del rizado, no en el valor medio. Y la «reducción del
    *ripple*» que pide evaluar es la @tab-rizado-zener: un número, no una impresión.
  - *Las capturas de osciloscopio de los dos TP* están en «Lo que se mide, y cómo», con
    la advertencia de la masa a tierra, que la consigna no menciona y en la fuente doble
    quema diodos.
]
