#import "../plantilla.typ": *

#modulo("Elementos, convenciones y leyes de Kirchhoff", [
  Nombrar sin ambigüedad las partes de un circuito (nodo, rama, malla, lazo), aplicar
  la convención de signos pasiva, escribir las ecuaciones de Kirchhoff de corrientes y
  de tensiones sabiendo *de dónde salen* y *cuántas son independientes*, y reducir una
  red resistiva con asociaciones, divisores y la transformación triángulo-estrella.
])

Los seis módulos anteriores resolvieron circuitos concretos: un shunt, un rectificador,
una fuente, una llave a transistor. En cada uno se usó, sin nombrarla, la misma
herramienta: plantear que las corrientes que entran a un punto son las que salen, y que
las tensiones alrededor de una vuelta cierran en cero. Este módulo abre esa caja. A
partir de acá el objeto de estudio ya no es *un* circuito sino el *método* para resolver
cualquiera, que es exactamente lo que la materia Teoría de Circuitos formaliza.

== El modelo: parámetros concentrados

Un circuito real es un objeto tridimensional lleno de campos eléctricos y magnéticos.
Resolverlo con las ecuaciones de Maxwell es posible y es inútil: para casi todo lo que
importa alcanza un modelo mucho más barato.

#definicion("Circuito de parámetros concentrados")[
  Un circuito de parámetros concentrados es un modelo en el que toda la física ocurre
  *dentro* de elementos de dos o más terminales, conectados por cables ideales que no
  tienen resistencia, ni capacidad, ni inductancia, y en los que la corriente es la misma
  en todo su largo. Toda la resistencia está en los resistores, todo el campo eléctrico
  almacenado está en los capacitores, todo el campo magnético en los inductores.
]

El modelo vale mientras el circuito sea *eléctricamente chico*: mientras su dimensión
física $ell$ sea mucho menor que la longitud de onda $lambda = c\/f$ de la señal más
rápida que circula por él. A 50 Hz, $lambda approx 6000$ km: un tablero de 2 m es
absolutamente chico. A 1 GHz, $lambda = 30$ cm y una pista de 5 cm ya *no* es un cable:
es una línea de transmisión y hay que tratarla como tal.

#clave[
  Todo lo que sigue —Kirchhoff, mallas, nodos, Thévenin, fasores— es válido *bajo la
  hipótesis de parámetros concentrados*. No es una ley de la naturaleza: es una
  aproximación excelente y con fecha de vencimiento. Cuando la frecuencia sube lo
  suficiente, se cae.
]

== Las cuatro magnitudes y la convención de signos

La *carga* $q$ se mide en coulomb. La *corriente* es su flujo:

$ i(t) = (dif q)/(dif t) quad [A = C/s] $ <ec-corriente>

La *tensión* entre dos puntos es el trabajo por unidad de carga que hace falta para
llevar una carga de uno al otro:

$ v(t) = (dif w)/(dif q) quad [V = J/C] $ <ec-tension>

De las dos sale la *potencia*, que es la magnitud que realmente dice qué está pasando:

$ p(t) = (dif w)/(dif t) = (dif w)/(dif q) dot (dif q)/(dif t) = v(t) dot i(t) $ <ec-potencia>

Y la energía es su integral: $w = integral p dif t$.

=== La convención pasiva

Un signo mal puesto arruina el resultado más que un error de cuentas, porque no se nota.
La disciplina que lo evita es una sola y no se negocia.

#definicion("Convención de signos pasiva")[
  Se dibuja la flecha de corriente *entrando por el terminal marcado* $+$ de la tensión.
  Con esa elección, $p = v i$ es la potencia *absorbida* por el elemento.

  - Si al resolver da $p > 0$, el elemento *consume* (se calienta, almacena, trabaja).
  - Si da $p < 0$, el elemento *entrega* energía al resto del circuito.

  Si la corriente se dibuja entrando por el $-$ (convención activa), entonces $p = v i$
  es la potencia *entregada*, y hay que decirlo explícitamente. Mezclar las dos en el
  mismo circuito es la fuente número uno de errores de signo.
]

#atencion[
  Las polaridades y los sentidos que uno dibuja son *supuestos*, no verdades. Se eligen
  antes de resolver y se respetan hasta el final. Si la respuesta da negativa, no hay
  nada que corregir: significa que la corriente real va al revés de la flecha dibujada.
  Volver atrás a "arreglar" el dibujo y recalcular es la forma más rápida de equivocarse.
]

Una consecuencia global que sirve de control: como la energía se conserva, en cualquier
circuito la suma de las potencias absorbidas por *todos* los elementos vale cero.

$ sum_(k=1)^b p_k = 0 $ <ec-tellegen>

Es el *teorema de Tellegen*, y es el mejor chequeo final que existe: si las potencias no
cierran en cero, hay un error en algún lado, aunque las tensiones "parezcan" razonables.

== Los elementos

=== Resistor

$ v = R i quad arrow.l.r.double quad i = G v, quad G = 1/R quad ["S" = "siemens"] $ <ec-ohm>

La potencia que absorbe es siempre positiva, y por eso el resistor es un elemento
*pasivo* y *disipativo*: la energía que recibe se va como calor y no vuelve.

$ p = v i = i^2 R = v^2/R >= 0 $ <ec-pot-r>

=== Fuentes independientes

Una *fuente de tensión ideal* impone $v$ entre sus bornes, cualquiera sea la corriente
que le pidan. Una *fuente de corriente ideal* impone $i$ por su rama, cualquiera sea la
tensión que aparezca sobre ella. Las dos son idealizaciones: la primera no existe porque
implicaría potencia infinita en cortocircuito, la segunda tampoco porque implicaría
tensión infinita en circuito abierto.

#atencion[
  Dos reglas que se violan seguido y hacen que el circuito no tenga solución:
  *dos fuentes de tensión distintas nunca pueden ponerse en paralelo* (contradicen la
  LKT), y *dos fuentes de corriente distintas nunca pueden ponerse en serie*
  (contradicen la LKC). Si un planteo lleva a eso, el error está en el planteo.
]

=== Fuentes controladas

Son el elemento que no aparece en la escuela y aparece en toda la universidad: una
fuente cuyo valor *depende* de una tensión o de una corriente medida en otra parte del
mismo circuito. Son el modelo lineal de todo dispositivo activo — el transistor del
Módulo 6 se modela así.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, left),
    table.header([*Nombre*], [*Sigla*], [*Ley*], [*Constante*]),
    [Fuente de tensión controlada por tensión],   [VCVS], [$v = mu v_x$],     [$mu$ adimensional (ganancia)],
    [Fuente de tensión controlada por corriente], [CCVS], [$v = r_m i_x$],    [$r_m$ en ohm (transresistencia)],
    [Fuente de corriente controlada por tensión], [VCCS], [$i = g_m v_x$],    [$g_m$ en siemens (transconductancia)],
    [Fuente de corriente controlada por corriente],[CCCS], [$i = beta i_x$],  [$beta$ adimensional (ganancia)],
  ),
  caption: [Los cuatro tipos de fuente controlada],
)

#clave[
  Una fuente controlada *no* es una fuente independiente: no se "apaga" al aplicar
  superposición ni al calcular una resistencia equivalente de Thévenin. Esa es la
  diferencia que más se cobra en los parciales, y se retoma en el Módulo 9.
]

== El vocabulario topológico

Antes de contar ecuaciones hay que poder contar nodos y mallas sin dudar. Las
definiciones parecen obvias hasta que un circuito tiene diez ramas.

#definicion("Nodo, rama, lazo, malla")[
  *Rama*: un elemento de dos terminales, con su corriente y su tensión.
  *Nodo*: un punto de unión de dos o más ramas. Todo lo que está unido por cable ideal es
  *un solo nodo*, por más que en el dibujo se vea como varios puntos separados.
  *Nodo esencial*: nodo donde concurren *tres o más* ramas.
  *Lazo*: cualquier camino cerrado que no pase dos veces por el mismo nodo.
  *Malla*: un lazo que no contiene ningún otro lazo adentro. Solo tiene sentido en
  circuitos *planares* (los que pueden dibujarse en un plano sin que dos ramas se
  crucen).
]

#circuito([El mismo circuito, con los nodos y las mallas marcados])[
```
         R1        (a)        R3
    ┌───[///]───────●───────[///]───┐
    │               │               │
    │               │               │
   (+)             [ ]             (↑)
   ( V1 )          [ ] R2          ( I1 )      ← malla 1: V1-R1-R2
   (-)             [ ]             (↓)         ← malla 2: R2-R3-I1
    │               │               │
    └───────────────●───────────────┘
                   (b)
                (referencia)

    Nodos esenciales : (a) y (b)              → n = 2
    Ramas esenciales : V1+R1, R2, R3+I1       → b = 3
    Mallas           : 2
    Un lazo que NO es malla: V1-R1-R3-I1 (rodea a R2)
```
]

#atencion[
  El error clásico es contar como dos nodos distintos los dos extremos de un cable, o
  no ver que el borne de abajo de tres elementos dibujados en distintos lugares es *el
  mismo* nodo. Truco de laboratorio y de papel: recorrer el dibujo con el dedo y pintar
  de un color cada trozo de cobre continuo. Cada color es un nodo, sin excepción.
]

== Primera ley de Kirchhoff: las corrientes

#definicion("LKC — Ley de Kirchhoff de las corrientes")[
  La suma algebraica de las corrientes que entran a un nodo es cero en todo instante:
  $ sum_(k) i_k (t) = 0 $
  Con el criterio habitual: *lo que entra positivo, lo que sale negativo* (o al revés,
  pero uno solo y para todo el circuito).
]

=== De dónde sale

No es un postulado: es la conservación de la carga. Un nodo es un punto de cable ideal;
no tiene volumen donde acumular carga y no tiene capacidad respecto de nada. Si en un
intervalo $dif t$ entrara más carga de la que sale, la carga neta del nodo sería

$ dif q_"nodo" = (sum_"entra" i - sum_"sale" i) dif t != 0 $

y el nodo se cargaría. Una carga acumulada crea un campo eléctrico que crece sin límite,
lo que exigiría energía infinita. Como eso no pasa, $dif q_"nodo" = 0$ para todo $dif t$,
y de ahí la ley.

#clave[
  La LKC no vale solo para un nodo: vale para *cualquier superficie cerrada* que uno
  dibuje alrededor de un pedazo del circuito. Toda la corriente que atraviesa la
  superficie hacia adentro es igual a la que la atraviesa hacia afuera. Esta versión
  ampliada es la que permite el *supernodo* del Módulo 8, y también es la que explica por
  qué la corriente que sale del primario de una fuente vuelve entera por el neutro.
]

== Segunda ley de Kirchhoff: las tensiones

#definicion("LKT — Ley de Kirchhoff de las tensiones")[
  La suma algebraica de las tensiones a lo largo de cualquier lazo cerrado es cero en
  todo instante:
  $ sum_(k) v_k (t) = 0 $
  Se recorre el lazo en un sentido elegido y se anota cada tensión con el signo del
  terminal *por el que se entra* al elemento.
]

=== De dónde sale

La tensión es trabajo por unidad de carga. Recorrer un lazo y volver al punto de partida
significa llevar una carga de prueba desde un punto hasta ese mismo punto: el trabajo
neto tiene que ser cero, porque si no la carga habría ganado energía dando vueltas y se
tendría una máquina de movimiento perpetuo.

En términos de campo: bajo la hipótesis de parámetros concentrados no hay flujo magnético
variable *fuera* de los inductores, así que el campo eléctrico en el resto del circuito
es conservativo y su circulación a lo largo de un camino cerrado es nula:
$integral.cont arrow(E) dot dif arrow(l) = 0$.

#atencion[
  Esa hipótesis se cae cuando hay un campo magnético variable atravesando el lazo que uno
  dibujó. En un laboratorio de alterna, un lazo grande de cables cerca de un
  transformador *sí* tiene una fem inducida y la LKT "falla" — en realidad no falla, hay
  una fuente que no se dibujó. Regla práctica: cables de ida y vuelta juntos y trenzados,
  lazos chicos.
]

== Cuántas ecuaciones hacen falta

Esta es la pregunta que ordena todo el resto de la materia. Un circuito con $b$ ramas
tiene $2b$ incógnitas: una tensión y una corriente por rama. Las relaciones
constitutivas de los elementos ($v = R i$, etc.) aportan $b$ ecuaciones, así que quedan
$b$ incógnitas por determinar y hacen falta $b$ ecuaciones de Kirchhoff.

#clave[
  En una red con $n$ nodos y $b$ ramas:
  - Las ecuaciones de LKC independientes son $n - 1$. La del último nodo es combinación
    lineal de las otras y no aporta nada nuevo (sumar todas las LKC da $0 = 0$: cada
    corriente aparece dos veces con signos opuestos).
  - Las ecuaciones de LKT independientes son $b - n + 1$, y una forma segura de elegirlas
    es tomar *una por cada malla* del circuito planar.
  - Total: $(n-1) + (b-n+1) = b$. Justo las que hacen falta, ni una más.
]

En el circuito de la Figura 1: $n = 2$, $b = 3$ $arrow.r.double$ 1 ecuación de LKC y 2 de
LKT. Tres ecuaciones, tres corrientes de rama.

Este conteo es también el criterio para elegir método en el Módulo 8: el análisis de
nodos plantea $n-1$ ecuaciones y el de mallas plantea $b-n+1$. Conviene el que dé el
número más chico.

== Asociaciones y divisores

=== Serie

Elementos en serie comparten *la misma corriente*. Por LKT, $v = v_1 + v_2 + dots$, y con
$v_k = R_k i$:

$ R_"eq" = sum_k R_k $ <ec-serie-r>

=== Paralelo

Elementos en paralelo comparten *la misma tensión*. Por LKC, $i = i_1 + i_2 + dots$, y con
$i_k = v\/R_k$:

$ 1/R_"eq" = sum_k 1/R_k quad arrow.r.double quad G_"eq" = sum_k G_k $ <ec-par-r>

Para dos resistores, el caso que más se usa:

$ R_"eq" = (R_1 R_2)/(R_1 + R_2) $ <ec-par-dos>

=== Divisor de tensión

Dos resistores en serie alimentados con $V$. La corriente es única, $i = V\/(R_1+R_2)$, y
la tensión sobre $R_2$ es $v_2 = R_2 i$:

$ v_2 = V dot R_2/(R_1 + R_2) $ <ec-divisor-v>

=== Divisor de corriente

Dos resistores en paralelo con corriente total $I$. La tensión es única,
$v = I dot (R_1 R_2)\/(R_1+R_2)$, y $i_1 = v\/R_1$:

$ i_1 = I dot R_2/(R_1 + R_2) $ <ec-divisor-i>

#atencion[
  Los dos divisores se parecen y por eso se confunden. En el de *tensión* va arriba la
  resistencia sobre la que se mide; en el de *corriente* va arriba *la otra*. Control
  mental de un segundo: la corriente se va por donde hay menos resistencia, así que si
  $R_1$ es chica tiene que llevarse casi toda la corriente — y en la @ec-divisor-i, con
  $R_1$ chica, el factor tiende a 1. Correcto.
]

#ejercicio("El divisor de tensión cargado: por qué se cae")[
  Un divisor con $R_1 = R_2 = 10 "k"Omega$ alimentado con 12 V entrega, en vacío,
  $ v_2 = 12 "V" dot (10)/(10+10) = 6 "V" $
  Se le conecta una carga $R_L = 1 "k"Omega$. Ahora $R_2$ está en paralelo con $R_L$:
  $ R_(2 parallel L) = (10 dot 1)/(10 + 1) "k"Omega = 0,909 "k"Omega $
  $ v_2 = 12 "V" dot (0,909)/(10 + 0,909) = 1,00 "V" $

  *Conclusión*: la salida se derrumbó de 6 V a 1,0 V. Un divisor solo entrega la tensión
  calculada si lo que cuelga de él tiene una resistencia *mucho mayor* que $R_2$ — regla
  práctica, diez veces o más. Es exactamente el mismo fenómeno que el *efecto de carga*
  del voltímetro del Módulo 1, y es la razón por la que una fuente de alimentación no se
  hace con un divisor sino con el regulador del Módulo 5.
]

== Transformación triángulo-estrella

Hay redes que no son ni serie ni paralelo. El caso testigo es el *puente*: cinco
resistores en los que ningún par comparte exclusivamente corriente ni tensión. La
transformación $Delta$–Y las destraba.

#circuito([Las dos redes de tres terminales, equivalentes vistas desde afuera])[
```
        TRIANGULO (Δ)                        ESTRELLA (Y)

            (a)                                  (a)
            ╱ ╲                                   │
       Rc  ╱   ╲  Rb                              [ ] R1
          ╱     ╲                                  │
        (b)─────(c)                               (n)
            Ra                              R2 [ ]   [ ] R3
                                               │       │
                                              (b)     (c)
```
]

La equivalencia se impone pidiendo que la resistencia medida entre cada par de
terminales sea la misma en las dos redes, con el tercero al aire. Eso da tres ecuaciones
con tres incógnitas, y al resolverlas:

$ R_1 = (R_b R_c)/(R_a + R_b + R_c), quad
  R_2 = (R_a R_c)/(R_a + R_b + R_c), quad
  R_3 = (R_a R_b)/(R_a + R_b + R_c) $ <ec-delta-y>

$ R_a = (R_1 R_2 + R_2 R_3 + R_3 R_1)/R_1, quad
  R_b = (R_1 R_2 + R_2 R_3 + R_3 R_1)/R_2, quad
  R_c = (R_1 R_2 + R_2 R_3 + R_3 R_1)/R_3 $ <ec-y-delta>

#clave[
  Para memorizarlas sin memorizar: en $Delta arrow.r Y$, *cada resistencia de la estrella
  es el producto de las dos del triángulo que tocan su terminal, dividido la suma de las
  tres*. En $Y arrow.r Delta$, *cada resistencia del triángulo es la suma de los tres
  productos de a pares, dividida la de la estrella que le queda opuesta*.
  Caso particular útil: si las tres son iguales, $R_Delta = 3 R_Y$.
]

== Resolver solo con Kirchhoff (y por qué no alcanza)

#ejercicio("Un circuito de dos mallas, por el método largo")[
  Sea $V_1 = 12$ V, $V_2 = 6$ V, $R_1 = 2 Omega$, $R_2 = 4 Omega$, $R_3 = 6 Omega$, con
  $R_2$ en la rama del medio, compartida por las dos mallas.

  *1. Contar.* Nodos esenciales $n = 2$, ramas esenciales $b = 3$. Hacen falta
  $n - 1 = 1$ ecuación de LKC y $b - n + 1 = 2$ de LKT.

  *2. LKC en el nodo (a)*, con $i_1$ e $i_3$ entrando e $i_2$ saliendo:
  $ i_1 + i_3 - i_2 = 0 $

  *3. LKT en la malla izquierda* (sentido horario, arrancando en la fuente):
  $ -V_1 + R_1 i_1 + R_2 i_2 = 0 quad arrow.r quad 2 i_1 + 4 i_2 = 12 $

  *4. LKT en la malla derecha*:
  $ -V_2 + R_3 i_3 + R_2 i_2 = 0 quad arrow.r quad 6 i_3 + 4 i_2 = 6 $

  *5. Resolver.* Sustituyendo $i_2 = i_1 + i_3$:
  $ 2 i_1 + 4(i_1 + i_3) = 12 quad arrow.r quad 6 i_1 + 4 i_3 = 12 $
  $ 6 i_3 + 4(i_1 + i_3) = 6 quad arrow.r quad 4 i_1 + 10 i_3 = 6 $

  De la primera, $i_1 = (12 - 4 i_3)\/6 = 2 - (2 i_3)/(3)$. Reemplazando:
  $ 4(2 - (2 i_3)/(3)) + 10 i_3 = 6 quad arrow.r quad 8 - (8 i_3)/(3) + 10 i_3 = 6 $
  $ (22 i_3)/(3) = -2 quad arrow.r quad i_3 = -0,273 "A" $

  Y entonces $i_1 = 2 - (2 dot (-0,273))\/3 = 2,18$ A, $i_2 = 1,91$ A.

  *6. Leer el signo.* $i_3$ dio negativa: la fuente $V_2$ *no* entrega corriente, la
  recibe. En una batería real, eso es cargarse.

  *7. Control por Tellegen* (@ec-tellegen):
  $ p_(V 1) = -12 dot 2,18 = -26,2 "W" quad ("entrega") $
  $ p_(V 2) = -6 dot (-0,273) = +1,6 "W" quad ("absorbe") $
  $ p_(R 1) = 2,18^2 dot 2 = 9,5 "W", quad p_(R 2) = "1,91"^2 dot 4 = 14,6 "W", quad
    p_(R 3) = "0,273"^2 dot 6 = 0,4 "W" $
  Suma: $-26,2 + 1,6 + 9,5 + 14,6 + 0,4 approx 0$ (la diferencia es redondeo). Cierra.

  *Moraleja*: tres ecuaciones y tres incógnitas para un circuito de dos mallas. Con seis
  ramas serían seis ecuaciones. El Módulo 8 hace exactamente lo mismo con *dos*
  ecuaciones, y con una regla para escribirlas sin pensar.
]

#tp("Con los TP N.º 2 y 3 — I Cuatrimestre")[
  Los prácticos de multímetro en serie y en paralelo son, sin decirlo, LKC y LKT medidas
  con instrumento. Al conectar el amperímetro *en serie* se está usando que la corriente
  de una rama es única; al conectar el voltímetro *en paralelo* se está usando que la
  tensión de un lazo cierra en cero. Y el error de carga que aparece en las dos medidas
  es el Ejercicio 7.1: el instrumento es una resistencia más que se agrega al circuito y
  lo cambia.
]
