#import "../plantilla.typ": *

#modulo("Laplace: el circuito en el dominio de s, polos y ceros", [
  Pasar un circuito con capacitores y bobinas al dominio de $s$ —condiciones iniciales
  incluidas—, resolverlo con álgebra de continua, volver al tiempo por fracciones
  parciales y controlar el resultado con el valor inicial y el final. Escribir una
  función de transferencia en forma de polos y ceros, ubicarla en el plano $s$ y leer de
  ahí, sin hacer una sola cuenta más, si el circuito oscila, cuánto tarda en apagarse y
  cuánto vale su $Q$. Y ver qué cambia en un RLC serie según de dónde se tome la salida.
])

El Módulo 10 resolvió el RLC escribiendo la ecuación diferencial, adivinando la forma de
la solución y peleando con dos constantes. Funciona, pero cada circuito nuevo es una
pelea nueva, y con una excitación que no sea un escalón la pelea se pone fea. El Módulo
11 encontró un atajo para la alterna —los fasores—, pero ese atajo sólo vale *en régimen
permanente*: el transitorio lo tira a la basura. Este módulo junta las dos cosas. La
transformada de Laplace hace con el transitorio lo mismo que el fasor hace con la
alterna: cambia derivadas por multiplicaciones, y la ecuación diferencial por álgebra.
Y encima mete las condiciones iniciales solas, sin pedir permiso.

La fuente de todo el módulo es el *Nilsson* (Nilsson y Riedel, *Circuitos eléctricos*),
que es el libro que la cátedra pone primero: el capítulo 12 para la transformada y el 13
para su uso en circuitos. Las páginas que se citan son las de la edición que usa la
materia.

== La transformada, en lo que hace falta

#definicion("Transformada de Laplace")[
  A una función del tiempo $f(t)$, definida para $t >= 0$, se le asocia una función de
  una variable compleja $s$:
  $ F(s) = cal(L){f(t)} = integral_(0^-)^(infinity) f(t) thin e^(-s t) dif t $ <ec-laplace>
  La $s$ se escribe $s = sigma + j omega$: tiene una parte real $sigma$, que mide cuán
  rápido algo crece o se apaga, y una imaginaria $omega$, que mide cuán rápido oscila. Es
  la generalización de la $j omega$ del Módulo 11, que es el caso particular $sigma = 0$:
  una oscilación que ni crece ni se apaga.
]

La integral arranca en $0^-$, un instante *antes* de que pase nada (antes de que se cierre
la llave), y no es un capricho de notación: así la condición inicial que entra a la
cuenta es la que el circuito tenía *antes* de conmutar, que es la que uno conoce. Para
$t < 0$ la función no le importa a la transformada; por eso las respuestas se escriben
con un $u(t)$, el escalón unitario, que vale $0$ antes de $t = 0$ y $1$ después.

Nadie calcula esa integral en un parcial. Se usan cuatro pares y dos propiedades, que
alcanzan para todo circuito de este curso:

#figure(
  table(
    columns: (1.5fr, 1.7fr, 2.3fr),
    align: (left, center, left),
    table.header([*En el tiempo*], [*En $s$*], [*Qué es en un circuito*]),
    [$delta(t)$, el impulso], [$1$], [un golpe de duración cero (Nilsson §12.3, p. 568)],
    [$u(t)$, el escalón], [$1\/s$], [una fuente de continua que se conecta en $t = 0$],
    [$e^(-a t) u(t)$], [$1\/(s + a)$], [un modo que se apaga con constante de tiempo $1\/a$],
    [$e^(-alpha t) cos(omega_d t) u(t)$], [$(s + alpha)\/((s + alpha)^2 + omega_d^2)$], [una oscilación amortiguada],
    [$dif f\/dif t$], [$s F(s) - f(0^-)$], [derivar es multiplicar por $s$… y restar lo que había],
    [$integral_(0^-)^t f(tau) dif tau$], [$F(s)\/s$], [integrar es dividir por $s$],
  ),
  caption: [Lo que hay que saber de memoria. Nilsson, Tabla 12.1 (§12.4) y Tabla 12.2 (§12.5)],
)

#clave[
  *La fila de la derivada es todo el truco.* La bobina es $v = L thin dif i\/dif t$ y el
  capacitor $i = C thin dif v\/dif t$: los dos son derivadas. Pasados a $s$ quedan
  multiplicaciones —que es álgebra— *más un término con el valor inicial*, que es lo que
  hace que la condición inicial no haya que agregarla a mano al final, como en el Módulo
  10: entra sola desde el principio.
]

== Los elementos en el dominio de s

Se transforma la relación $v$–$i$ de cada elemento y se lee el resultado como un
circuito. Con la bobina: $v = L thin dif i\/dif t$ pasa a $V = s L thin I - L thin i_L (0^-)$.
Eso es una *impedancia* $s L$ en serie con una *fuente de tensión* que vale
$L thin i_L (0^-)$: la energía que la bobina traía guardada, disfrazada de fuente. Lo
mismo con el capacitor: $V = I\/(s C) + v_C (0^-)\/s$, una impedancia $1\/(s C)$ en serie con
una fuente $v_C (0^-)\/s$, que es un escalón del tamaño de la tensión que tenía.

#figure(
  table(
    columns: (1.1fr, 1fr, 2.9fr),
    align: (left, center, left),
    table.header([*Elemento*], [*Impedancia*], [*Fuente de condición inicial, en serie*]),
    [Resistencia $R$], [$R$], [no tiene: no guarda energía],
    [Bobina $L$], [$s L$], [$L thin i_L (0^-)$, con el $+$ del lado por donde *sale* $i_L$],
    [Capacitor $C$], [$1\/(s C)$], [$v_C (0^-)\/s$, con la misma polaridad que tenía $v_C$],
  ),
  caption: [Los tres elementos en $s$ (Nilsson §13.1, p. 608). Las versiones con la fuente de corriente en paralelo son equivalentes: se usa la que deje menos ecuaciones],
)

Con eso el circuito en $s$ se resuelve *exactamente* como uno de continua: nodos, mallas,
divisores, Thévenin, todo el Módulo 8 y el 9 sin cambiar una coma, con impedancias que
dependen de $s$ en lugar de números. Las impedancias son las del Módulo 11 con $j omega$
reemplazado por $s$: $Z_L = s L$, $Z_C = 1\/(s C)$.

#atencion[
  *El signo de la fuente de condición inicial es el error número uno.* No se memoriza:
  se deduce de la fila de la derivada, y se controla con el valor inicial (más abajo). Si
  el resultado dice que la tensión de un capacitor salta en $t = 0$, la fuente está al
  revés. El capacitor no salta; la bobina tampoco, en su corriente. Eso ya lo dijo el
  Módulo 10 y Laplace no lo deroga.
]

== Volver al tiempo: fracciones parciales

Resolver el circuito en $s$ da una respuesta como cociente de dos polinomios:
$F(s) = N(s)\/D(s)$. Para volver al tiempo se la parte en sumandos que estén en la tabla.

Las raíces del denominador $D(s)$ se llaman *polos*, y se escriben $p_1, p_2, dots$ Si son
reales y distintas, $F(s)$ se parte así:
$ F(s) = K_1/(s - p_1) + K_2/(s - p_2) + dots quad "con" quad
  K_i = [(s - p_i) F(s)]_(s = p_i) $ <ec-residuos>
y cada sumando vuelve al tiempo con la tercera fila de la tabla: $K\/(s - p) arrow.r
K e^(p t) u(t)$. El número $K_i$ se llama *residuo* del polo $p_i$, y la receta para
sacarlo es la de @ec-residuos: tapar con el dedo el factor $(s - p_i)$ y reemplazar $s$ por
$p_i$ en lo que queda. Si los polos son complejos conjugados, se agrupan de a dos y
vuelven como la cuarta fila: una oscilación amortiguada (Nilsson §12.7, p. 582).

#clave[
  *El control que no se negocia: valor inicial y valor final* (Nilsson §12.9, p. 593).
  $ f(0^+) = lim_(s -> infinity) s F(s) quad quad quad f(infinity) = lim_(s -> 0) s F(s) $ <ec-vi-vf>
  El segundo vale sólo si todos los polos de $s F(s)$ están a la izquierda del eje
  imaginario, o sea si el circuito se calma. Los dos se calculan en una línea y se
  comparan con lo que dice la física: lo que no salta, lo que queda en régimen. Si no
  coinciden, el error está antes de las fracciones parciales, y se busca ahí.
]

#ejercicio("Un RLC serie que se conecta a una batería")[
  Un RLC serie con $R = 6 Omega$, $L = 1$ H y $C = 0,125$ F, descargado y sin corriente, se
  conecta en $t = 0$ a una batería de $12$ V. Se pide la corriente $i(t)$ y la tensión del
  capacitor $v_C (t)$.

  *1. Condiciones iniciales.* Descargado y sin corriente: $v_C (0^-) = 0$ e
  $i_L (0^-) = 0$. No hay fuentes de condición inicial: el circuito en $s$ es la fuente
  $12\/s$ en serie con $6$, $s$ y $8\/s$ (porque $1\/(s C) = 1\/(0,125 s) = 8\/s$).

  *2. Resolverlo como si fuera de continua.* Una sola malla: la corriente es la tensión
  sobre la impedancia total.
  $ I(s) = (12\/s)/(6 + s + 8\/s) = 12/(s^2 + 6 s + 8) = 12/((s + 2)(s + 4)) $
  Los polos son $p_1 = -2$ y $p_2 = -4$ rad/s: reales y distintos, así que el circuito es
  sobreamortiguado (con el lenguaje del Módulo 10, $alpha = 3$ y $omega_0 = sqrt(8) = 2,83$
  rad/s, y $alpha > omega_0$).

  *3. Fracciones parciales*, con @ec-residuos:
  $ K_1 = [12/(s + 4)]_(s = -2) = 6 quad quad K_2 = [12/(s + 2)]_(s = -4) = -6 $
  $ i(t) = 6 thin (e^(-2 t) - e^(-4 t)) thin u(t) "A" $

  *4. La tensión del capacitor*, que es la corriente por $1\/(s C)$:
  $ V_C (s) = 8/s dot 12/((s + 2)(s + 4)) = 96/(s (s + 2)(s + 4)) $
  Tres polos, tres residuos: en $0$ vale $96\/8 = 12$; en $-2$, $96\/((-2)(2)) = -24$; en
  $-4$, $96\/((-4)(-2)) = 12$.
  $ v_C (t) = (12 - 24 thin e^(-2 t) + 12 thin e^(-4 t)) thin u(t) "V" $

  *5. Control por valor inicial y final*, con @ec-vi-vf. Para la corriente,
  $s I(s) = 12 s\/(s^2 + 6 s + 8) arrow.r 0$ cuando $s arrow.r infinity$: $i(0^+) = 0$,
  como tiene que ser, porque la bobina no deja saltar su corriente. Para el capacitor,
  $s V_C (s) = 96\/((s + 2)(s + 4)) arrow.r 12$ cuando $s arrow.r 0$: termina cargado a
  los $12$ V de la batería. Y $v_C (0^+) = 12 - 24 + 12 = 0$: arranca descargado.

  *6. Segundo camino: la ecuación diferencial integrada numéricamente*, sin Laplace. Las
  dos ecuaciones de estado, $L thin dif i\/dif t = 12 - R i - v_C$ y
  $C thin dif v_C\/dif t = i$, integradas paso a paso desde $(0; 0)$, dan los mismos
  valores que las fórmulas en $t = 0,1$; $0,35$; $1$ y $2$ s, con diferencias por debajo
  de una parte en mil (`fase3-cuentas.py`, ejercicio 16.1).

  *7. Un dato que se lee de la fórmula.* La corriente sube y vuelve a cero —la batería
  termina cargando un capacitor, que en continua es un abierto—, así que tiene un
  máximo. Derivando: $-2 e^(-2 t) + 4 e^(-4 t) = 0 arrow.r e^(-2 t) = 1\/2$, o sea
  $t = ln 2 \/ 2 = 0,347$ s, donde $i = 6 (1\/2 - 1\/4) = 1,5$ A. La integración numérica
  pone el pico en el mismo lugar.
]

== La función de transferencia y la forma zpk

Cuando el circuito arranca *descansado* —todas las condiciones iniciales en cero— la
salida en $s$ es la entrada en $s$ multiplicada por algo que depende sólo del circuito:

#definicion("Función de transferencia")[
  $ H(s) = Y(s)/X(s) quad "con condiciones iniciales nulas" $ <ec-hs>
  donde $X(s)$ es la transformada de la entrada (la fuente) e $Y(s)$ la de la salida (la
  tensión o corriente que se elige mirar). Es la $overline(H)(j omega)$ del Módulo 12 con
  $j omega$ reemplazado por $s$; al revés, la del Módulo 12 es ésta evaluada sobre el eje
  imaginario, $s = j omega$ (Nilsson §13.4).
]

Como en el Módulo 12, $H(s)$ es un cociente de polinomios. Factorizados los dos queda la
*forma zpk* —por *zeros, poles, gain*: ceros, polos y ganancia—:

$ H(s) = K ((s - z_1)(s - z_2) dots) / ((s - p_1)(s - p_2) dots) $ <ec-zpk>

Los $z_i$ son los *ceros*, las frecuencias complejas donde la transferencia se anula; los
$p_i$ son los *polos*, donde se dispara; y $K$ es una ganancia, un número. Con eso se
tiene todo: dos circuitos con los mismos polos, los mismos ceros y la misma $K$ son,
desde afuera, el mismo circuito.

#clave[
  *Los polos de $H(s)$ son las frecuencias naturales del circuito.* Son las raíces de la
  ecuación característica del Módulo 10, y no es casualidad: la parte natural de la
  respuesta está hecha de un $e^(p t)$ por cada polo, se excite como se excite. La
  entrada elige *cuánto* de cada modo aparece; los polos dicen *cuáles* modos hay. Por
  eso se dice que los polos son del circuito y no de la fuente (Nilsson §13.5).
]

=== El plano s: dónde cae un polo dice cómo se porta

Un polo es un número complejo, $p = sigma + j omega$, así que se puede marcar como un
punto en un plano: la parte real en el eje horizontal y la imaginaria en el vertical. Ese
es el *plano $s$*, y la posición de cada polo se traduce directo a una forma de onda.

- *Sobre el eje real negativo* ($p = -a$): el modo es $e^(-a t)$, una exponencial que se
  apaga sin oscilar, con constante de tiempo $tau = 1\/a$. Cuanto más a la izquierda,
  más rápido se apaga.
- *Un par complejo conjugado* ($p = -alpha plus.minus j omega_d$): el modo es
  $e^(-alpha t) cos(omega_d t)$, una oscilación de pulsación $omega_d$ que se apaga con
  constante $1\/alpha$. La parte real manda en el apagado; la imaginaria, en la oscilación.
- *A la derecha del eje imaginario*: el modo crece sin techo. En un circuito pasivo no
  pasa nunca —no hay de dónde sacar la energía—; en uno con operacionales y
  realimentación positiva, sí, y se llama oscilador (o desastre, según la intención).

Para el par de polos de un circuito de segundo orden hay una geometría que vale la pena
aprenderse, porque convierte el plano $s$ en una regla de cálculo. El denominador es el
del Módulo 10, $s^2 + 2 alpha s + omega_0^2$, donde $alpha$ es el coeficiente de
amortiguamiento, $omega_0$ la pulsación natural y $zeta = alpha\/omega_0$ el factor de
amortiguamiento. Si $zeta < 1$, los polos son

$ p_(1,2) = -alpha plus.minus j omega_d = -zeta omega_0 plus.minus j omega_0 sqrt(1 - zeta^2) $ <ec-polos-2do>

y de ahí salen tres cosas que se *ven*:

#figure(
  table(
    columns: (1.5fr, 1.5fr, 3fr),
    align: (left, center, left),
    table.header([*Lo que se mira*], [*Vale*], [*Qué dice*]),
    [la distancia al origen], [$|p| = omega_0$], [la pulsación natural: los polos de igual $omega_0$ están sobre una circunferencia],
    [el ángulo $theta$ con el eje real negativo], [$cos theta = zeta$], [el amortiguamiento: $theta = 0$ es crítico, $theta = 90 degree$ es oscilar para siempre],
    [la altura], [$omega_d$], [la pulsación a la que oscila de verdad (la del osciloscopio)],
    [la parte real], [$-alpha = -zeta omega_0$], [lo rápido que se apaga: $1\/alpha$ es la constante de la envolvente],
  ),
  caption: [La geometría de un par de polos. Con $Q = 1\/(2 zeta)$ (Módulo 10, «Circuitos de segundo orden») la tabla da también el $Q$: un polo cerca del eje imaginario es un $Q$ alto],
)

#circuito([Dónde caen los polos de un RLC serie según su $zeta$])[
#graf-polos-plano-s()
#pie-figura[Con $omega_0$ fijo, al bajar $R$ los polos viajan sobre la circunferencia de
  radio $omega_0$ hacia el eje imaginario: $zeta$ baja, el ángulo $theta$ crece y el
  circuito oscila más y se apaga más despacio. Con $zeta = 1$ chocan en $-omega_0$; con
  $zeta > 1$ se separan sobre el eje real, uno hacia el origen y el otro lejos.]
]

#atencion[
  *«Polo lejos del eje» no es «polo que no importa».* Con $zeta = 2$ uno de los dos polos
  queda en $-3,73 thin omega_0$ y el otro en $-0,27 thin omega_0$: el lejano se apaga
  catorce veces más rápido y en la práctica la respuesta la manda el cercano, que se
  llama *polo dominante*. Pero eso es una aproximación que se dice en voz alta, no una
  regla que permite tachar polos sin avisar.
]

#ejercicio("Polos, zeta y Q de un RLC serie, leídos del plano s")[
  Un RLC serie con $R = 100 Omega$, $L = 10$ mH y $C = "1 µF"$, con la salida sobre el
  capacitor. Se pide la forma zpk de $H(s) = V_C (s)\/V_i (s)$, la ubicación de los polos,
  $zeta$, $Q$ y el sobrepico de la respuesta al escalón.

  *1. La transferencia, por divisor de tensión* entre $R + s L$ y $1\/(s C)$:
  $ H(s) = (1\/(s C))/(R + s L + 1\/(s C)) = (1\/(L C))/(s^2 + (R\/L) s + 1\/(L C)) $
  Con los números: $1\/(L C) = 10^8$ y $R\/L = 10^4$.

  *2. Los parámetros del Módulo 10.* $omega_0 = 1\/sqrt(L C) = 10 000$ rad/s;
  $alpha = R\/(2 L) = 5000$ s⁻¹; $zeta = alpha\/omega_0 = 0,50$ y
  $Q = 1\/(2 zeta) = 1,00$.

  *3. Los polos*, con @ec-polos-2do:
  $omega_d = omega_0 sqrt(1 - zeta^2) = 10 000 dot sqrt("0,75") = 8660$ rad/s, así que
  $ H(s) = 10^8 / ((s + 5000 - j 8660)(s + 5000 + j 8660)) $
  Es la forma zpk: $K = 10^8$, ningún cero finito y un par de polos complejos. El ángulo
  con el eje real negativo es $theta = arccos 0,5 = 60 degree$: el polo rojo de la figura
  de arriba.

  *4. Segundo camino: las raíces del polinomio*, sin pasar por $zeta$. Resolviendo
  $s^2 + 10^4 s + 10^8 = 0$ con la fórmula de la cuadrática:
  $s = (-10^4 plus.minus sqrt(10^8 - 4 dot 10^8))\/2 = -5000 plus.minus j thin 8660$. Lo
  mismo, y además $|p| = sqrt(5000^2 + 8660^2) = 10 000 = omega_0$ y
  $cos theta = 5000\/10 000 = zeta$: la geometría de la tabla, comprobada.

  *5. El sobrepico*, con la fórmula del Módulo 10 que depende sólo de $zeta$:
  $"SP" = e^(-pi zeta\/sqrt(1 - zeta^2)) = e^(-1,814) = 0,163$, o sea un $16,3 thin %$. La
  respuesta al escalón simulada numéricamente sube hasta $1,163$ veces el valor final
  (`fase3-cuentas.py`, ejercicio 16.2): tercer camino, mismo número.
]

== El RLC serie según de dónde se tome la salida

Hasta acá la salida era el capacitor. Pero el mismo RLC serie, con la misma fuente, tiene
tres tensiones para mirar —sobre $R$, sobre $L$ y sobre $C$—, y cada una es un filtro
distinto. Es la pregunta que el programa de la materia pide explícitamente, y la
respuesta es corta: *el denominador no cambia, los ceros sí*.

Las tres transferencias son divisores de tensión con la misma impedancia total
$R + s L + 1\/(s C)$. Multiplicando arriba y abajo por $s\/L$ para que el denominador quede
mónico (con el coeficiente de $s^2$ igual a uno):

$ H_R (s) = ((R\/L) s)/(D(s)) quad quad
  H_L (s) = (s^2)/(D(s)) quad quad
  H_C (s) = (1\/(L C))/(D(s)) $ <ec-tres-salidas>

$ "con" quad D(s) = s^2 + (R\/L) s + 1\/(L C) = s^2 + (omega_0\/Q) s + omega_0^2 $

Los *polos* son los mismos en las tres —son del circuito, no de dónde se mire—. Lo que
cambia son los *ceros*, y con ellos qué hace el filtro:

- *Salida en $C$*: ningún cero finito. En continua el capacitor es un abierto y se lleva
  toda la tensión ($H_C (0) = 1$); en alta frecuencia es un corto y no se lleva nada. Es un
  *pasa bajos* de segundo orden.
- *Salida en $R$*: un cero en el origen. En continua no circula corriente (el capacitor
  la corta) y en alta tampoco (la bobina la corta): sólo pasa lo que está cerca de
  $omega_0$. Es un *pasa banda*, y en $omega_0$ vale exactamente $1$: la bobina y el
  capacitor se cancelan y toda la tensión queda sobre $R$.
- *Salida en $L$*: un cero doble en el origen. Es el espejo del capacitor: un *pasa
  altos* de segundo orden.

#circuito([El mismo RLC serie ($Q = 5$) con la salida tomada en cada uno de los tres elementos])[
#graf-rlc-tres-salidas()
#pie-figura[En $omega_0$ el pasa banda vale 0 dB y los otros dos valen $Q$ (14 dB): la
  tensión sobre $L$ y sobre $C$ es cinco veces la de la fuente, y en contrafase entre
  ellas, por eso se cancelan en la malla. Lejos de $omega_0$, el pasa bajos y el pasa altos
  caen a 40 dB por década, el doble que un RC: son de segundo orden.]
]

#clave[
  *La sobretensión de resonancia no es un detalle de examen.* Con $Q = 5$ y una fuente
  de $10$ V, sobre el capacitor hay $50$ V en $omega_0$. Es lo que hace que un circuito
  sintonizado de radio funcione… y lo que hace que un capacitor de 25 V elegido «porque
  la fuente es de 10 V» explote en el banco. El Módulo 11 lo vio desde la resonancia; acá
  aparece solo, como el valor de $|H_C (j omega_0)|$.
]

Un detalle fino, que el programa pide con la palabra «según»: el pico de $|H_C|$ *no* cae
exactamente en $omega_0$, sino un poco antes, y el de $|H_L|$ un poco después. Derivando
$|H_C (j omega)|^2$ e igualando a cero sale

$ omega_"pico" = omega_0 sqrt(1 - 1/(2 Q^2)) quad quad
  |H_C|_"máx" = Q / sqrt(1 - 1\/(4 Q^2)) $ <ec-pico-hc>

y existe sólo si $Q > 1\/sqrt(2)$; con menos, el pasa bajos no tiene pico y cae desde
continua. Para el de la bobina, $omega_"pico" = omega_0 \/ sqrt(1 - 1\/(2 Q^2))$, con el
mismo valor máximo. Con $Q$ grande las tres curvas tienen su extremo prácticamente en
$omega_0$, y por eso en el Módulo 11 se podía hablar de «la» resonancia sin aclarar.

#ejercicio("Las tres salidas de un RLC serie con Q = 5")[
  El RLC del ejercicio anterior con $R = 20 Omega$ en lugar de $100$: $L = 10$ mH,
  $C = "1 µF"$. Se pide $Q$, el valor de las tres transferencias en $omega_0$, dónde está
  el pico de $|H_C|$ y cuánto vale, y el ancho de banda del pasa banda.

  *1. Los parámetros.* $omega_0 = 10 000$ rad/s no cambió (no depende de $R$).
  $Q = omega_0 L\/R = 100\/20 = 5,00$.

  *2. Las tres en $omega_0$*, reemplazando $s = j omega_0$ en @ec-tres-salidas: el
  denominador queda $D(j omega_0) = -omega_0^2 + j omega_0^2\/Q + omega_0^2 = j omega_0^2\/Q$,
  y entonces
  $ |H_R (j omega_0)| = (omega_0^2\/Q)/(omega_0^2\/Q) = 1 quad quad
    |H_L (j omega_0)| = |H_C (j omega_0)| = (omega_0^2)/(omega_0^2\/Q) = Q = 5 $

  *3. El pico del pasa bajos*, con @ec-pico-hc:
  $omega_"pico" = 10 000 sqrt(1 - 1\/50) = 9899$ rad/s (unos $1576$ Hz), y
  $|H_C|_"máx" = 5\/sqrt(1 - 1\/100) = 5,025$. El de la bobina, en
  $10 000\/sqrt("0,98") = 10 102$ rad/s, con el mismo $5,025$.

  *4. El ancho de banda del pasa banda.* En rad/s es el coeficiente de $s$ del
  denominador: $"BW" = R\/L = omega_0\/Q = 2000$ rad/s (el Módulo 12, en «Filtros pasa banda y elimina
  banda», lo escribe en hertz).

  *5. Segundo camino: barrido numérico.* Las tres transferencias evaluadas en dos
  millones de frecuencias entre $5000$ y $15 000$ rad/s ponen el máximo de $|H_C|$ en
  $9899$ rad/s con valor $5,025$, el de $|H_L|$ en $10 102$, las tres en $omega_0$ en $1$, $5$
  y $5$, y los puntos de $-3$ dB del pasa banda separados $2000$ rad/s
  (`fase3-cuentas.py`, ejercicio 16.3). La fórmula y la fuerza bruta coinciden.
]

#clave[
  *Qué información física hay adentro de $H(s)$* —la pregunta que la cátedra le hizo a
  la exposición del Grupo 1—, contestada con este módulo: los polos dicen cómo se mueve
  el circuito cuando nadie lo empuja (cuánto tarda en calmarse, si oscila y a qué
  ritmo); los ceros dicen qué frecuencias no llegan a la salida que se eligió; y
  $H(j omega)$, que es $H(s)$ caminando por el eje imaginario, es el Bode del Módulo 12.
  Un mismo circuito tiene polos únicos y tantas $H$ como salidas se le quieran mirar.
]
