#import "../plantilla.typ": *

#modulo("Señales periódicas e instrumental de laboratorio", [
  Escribir la expresión matemática de una señal a partir de su gráfico y viceversa,
  calcular $V_p$, $V_(p p)$, $V_"ef"$, $V_m$, $T$, $f$ y $omega$ para las tres formas de
  onda de uso corriente, y configurar el osciloscopio y el generador de funciones para
  medirlas realmente en el banco.
])

== Qué es una señal

Hasta acá las magnitudes tenían un valor y listo. Pero en electrónica la mayoría de las
magnitudes *cambian con el tiempo*, y entonces un solo número no alcanza para
describirlas.

#definicion("Señal")[
  Una *señal* es una función que contiene información sobre el estado o el comportamiento
  de un sistema físico. Se la representa matemáticamente como una función de una variable
  independiente, que en electrónica es casi siempre el tiempo: $s(t)$.
]

El tiempo es la variable independiente porque transcurre solo, sin que nada de lo que
pase en el circuito lo modifique. La magnitud que nos interesa — tensión, corriente — es
la variable dependiente.

=== Clasificación

Por cómo se comportan en el tiempo:

- *Periódicas*: repiten el juego completo de sus valores a intervalos regulares. La
  tensión de red, la salida de un generador de funciones.
- *Pseudoperiódicas*: mantienen la regularidad de la forma, pero la amplitud cambia. El
  eco, o una cuerda de guitarra pulsada: siempre la misma nota, cada vez más débil.
- *Aperiódicas*: irregulares en el tiempo, sin repetición.
- *Aleatorias*: sin regularidad alguna, sus valores dependen del azar. El caso típico es
  el *ruido*, eléctrico o acústico.

Y por el tipo de variable independiente, se dividen en *continuas en el tiempo*
(definidas para todo instante) y *discretas* (definidas solo en instantes determinados,
representadas por una secuencia de números). Este apunte trabaja con señales periódicas
continuas en el tiempo.

== Los parámetros de una señal periódica

#definicion("Período, ciclo y frecuencia")[
  *Período $T$*: el tiempo que debe transcurrir para abarcar un juego completo de
  valores. No hace falta empezar a contarlo desde un cruce por cero: se puede tomar desde
  cualquier instante, siempre que se termine en el punto equivalente del ciclo siguiente.
  Se mide en segundos. *Ciclo*: el juego completo de valores contenido en un período.
  *Frecuencia $f$*: la cantidad de ciclos por unidad de tiempo. Se mide en hertz
  $[upright("Hz")] = 1\/upright("s")$.
]

$ f = "cantidad de ciclos"/"tiempo transcurrido" = "un ciclo"/"un período" = 1/T $ <ec-frec>

De ahí la relación que más se usa en el laboratorio, junto con la *velocidad angular* o
*pulsación* $omega$, que mide lo mismo que la frecuencia pero en radianes por segundo:

$ omega = 2 pi f = (2 pi) / T $ <ec-omega>

=== Valores característicos

- *Valor pico* $V_p$: el máximo valor que toma la señal. También se lo anota $hat(V)$ o $A$.
- *Valor pico a pico* $V_(p p)$: la diferencia entre el máximo y el mínimo. En una señal
  simétrica respecto de cero, $V_(p p) = 2 V_p$. #text(fill: c-rojo)[Es el que se lee
  directo en el osciloscopio], contando divisiones de arriba a abajo de la onda.
- *Valor medio* $V_m$: el promedio de la señal a lo largo de un período.
- *Valor eficaz* $V_"ef"$ (o RMS): el valor cuadrático medio a lo largo de un período.
  #text(fill: c-rojo)[Es el que lee el multímetro en CA.]

== Valor medio y valor eficaz: qué significan de verdad

Estos dos parámetros no son definiciones caprichosas: cada uno responde una pregunta
física distinta.

#definicion("Valor medio")[
  Es el valor que debería tomar una señal *constante* para transportar, en el mismo
  sentido y en un tiempo igual a un período, *idéntica carga neta* que la señal
  periódica.
  $ V_m = 1/T integral_0^T v(t) dif t $
]

#definicion("Valor eficaz")[
  Es el valor que debería tener una señal *constante* para disipar, sobre el mismo
  resistor y en un tiempo igual a un período, *idéntica cantidad de energía* que la señal
  periódica.
  $ V_"ef" = sqrt(1/T integral_0^T v^2(t) dif t) $ <ec-vef-def>
  De ahí el nombre en inglés, *RMS*: raíz de la media de los cuadrados
  (#emph[root mean square]), que describe literalmente el orden de las operaciones.
]

#clave[
  El valor medio de una señal senoidal pura es *CERO*, y no hace falta integrar nada para
  verlo: hay exactamente tantos valores positivos como negativos, y al sumarlos se
  cancelan. El valor eficaz, en cambio, *nunca es cero*, porque antes de promediar se
  elevan los valores al cuadrado y los negativos desaparecen. Esto tiene una consecuencia
  práctica enorme: una senoidal no transporta carga neta, pero *sí disipa potencia*.
]

=== Deducción del valor eficaz de la senoidal

Partiendo de la @ec-vef-def con $v(t) = V_p sin(omega t)$:

$ V_"ef"^2 = 1/T integral_0^T V_p^2 sin^2(omega t) dif t $

Se usa la identidad $sin^2(x) = (1 - cos(2x))\/2$:

$ V_"ef"^2 = V_p^2/T integral_0^T (1 - cos(2 omega t))/2 dif t
= V_p^2/(2T) [integral_0^T dif t - integral_0^T cos(2 omega t) dif t] $

La segunda integral es *cero*: es un coseno integrado sobre dos períodos completos, con
tanta área positiva como negativa. Queda entonces:

$ V_"ef"^2 = V_p^2/(2T) dot T = V_p^2/2 quad arrow.r.double quad
  V_"ef" = V_p/sqrt(2) approx 0,707 dot V_p $ <ec-vef-seno>

#laboratorio[
  Este resultado explica los 220 V de red. Ese número es el valor *eficaz*; el valor pico
  es $V_p = 220 "V" dot sqrt(2) approx 311$ V, y de pico a pico son *622 V*. Un capacitor
  o un diodo conectado a la red tiene que soportar 311 V, no 220. Dimensionarlo para
  220 V es la forma más rápida de hacerlo explotar.
]

=== Las tres formas de onda

Repitiendo el mismo procedimiento para las otras dos formas de onda se llega a la tabla
que hay que tener memorizada. El *valor medio* se indica para la señal *rectificada*
(tomando el módulo), que es el caso con el que se trabaja en las fuentes del Módulo 5;
para las señales simétricas puras el valor medio siempre da cero.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([*Forma de onda*], [$V_"ef"$], [$V_m$ (rectificada)], [Factor de forma $V_"ef"\/V_m$]),
    [Senoidal],   [$V_p\/sqrt(2) = 0,707 V_p$], [$2V_p\/pi = 0,637 V_p$], [1,11],
    [Cuadrada],   [$V_p$],                      [$V_p$],                 [1,00],
    [Triangular], [$V_p\/sqrt(3) = 0,577 V_p$], [$V_p\/2 = 0,5 V_p$],    [1,15],
  ),
  caption: [Valores característicos de las tres señales periódicas de uso corriente],
)

#circuito([Las tres formas de onda y sus parámetros])[
```
   SENOIDAL                CUADRADA               TRIANGULAR
     ___                  ┌────┐    ┌────┐          /\      /\
    /   \       ▲ Vp      │    │    │    │   ▲Vp    /  \    /  \    ▲Vp
   /     \      │         │    │    │    │   │     /    \  /    \   │
  ──────────    ▼ 0    ───┤    ├────┤    ├── ▼0   ──────\/──────\/  ▼0
         \   /            │    │    │    │              \  /
          \_/             └────┘    └────┘               \/
  |<-- T -->|          |<--- T --->|                |<-- T -->|

  Vef = Vp/√2           Vef = Vp                    Vef = Vp/√3
```
]

#atencion[
  El *factor de forma* es la razón por la que un multímetro común miente. El tester mide
  el valor medio de la señal rectificada y lo multiplica por *1,11*, el factor de forma de
  la senoidal, para mostrar un valor eficaz. Con una senoidal acierta. Con una cuadrada
  (factor real 1,00) *sobreestima un 11 %*; con una triangular (factor real 1,15)
  *subestima*. Para medir bien cualquier forma de onda hace falta un multímetro
  *True RMS*, o directamente el osciloscopio.
]

== Expresión matemática de la señal senoidal

$ s(t) = V_p dot sin(2 pi f dot t + phi) $ <ec-seno>

donde $V_p$ es la amplitud o valor pico, $f$ la frecuencia en hertz, $t$ el tiempo y
$phi$ la *fase inicial* en radianes, que determina el desplazamiento de la señal en el
tiempo. Cuando $phi$ no aparece en la expresión, se interpreta que vale cero.

Como el argumento del seno está en radianes, hay que saber convertir:

$ phi["rad"] = phi[degree] dot pi/180degree quad quad quad phi[degree] = phi["rad"] dot 180degree/pi $ <ec-grados>

=== De la expresión al gráfico

Para graficar una senoidal no hace falta calcular punto por punto. La forma es siempre la
misma; lo único que cambia son $V_p$, $f$ y $phi$. El procedimiento es:

+ Identificar $V_p$, $f$ y $phi$ en la expresión.
+ Calcular el período $T = 1\/f$ y elegir la escala horizontal para que entren los ciclos
  que se quieran mostrar. Elegir la escala vertical a partir de $V_p$.
+ Marcar los puntos notables, que en una senoidal sin fase caen siempre en los mismos
  lugares del período:
  #align(center)[
    $s(t) = 0$ en $t = {0, T\/2, T}$ #h(20pt)
    $s(t) = V_p$ en $t = T\/4$ #h(20pt)
    $s(t) = -V_p$ en $t = 3T\/4$
  ]
+ Si hay fase inicial, calcular el corrimiento igualando el argumento a cero:
  $2 pi f t + phi = 0 arrow.r.double t = -phi\/(2 pi f)$. Un resultado negativo significa
  que la señal se corrió hacia el tiempo *negativo* (adelanto); uno positivo, hacia el
  positivo (atraso).
+ Unir los puntos respetando la forma senoidal.

=== Del gráfico a la expresión

Es el camino inverso y es el que suelen pedir las evaluaciones: se lee $V_p$ de los
máximos, $T$ del intervalo entre dos puntos equivalentes, $f = 1\/T$, y $phi$ del
corrimiento del primer cruce por cero ascendente, con $phi = -2 pi f t_0$.

#ejercicio("De la expresión al gráfico, con y sin fase")[
  Graficar $s_1(t) = 5 "V" dot sin(2 pi dot 100 "Hz" dot t)$, y después la misma señal
  con una fase inicial de $45degree$.

  *1. Parámetros*: $V_p = 5$ V, $f = 100$ Hz, $phi = 0$.

  *2. Período*:
  $ T = 1/f = 1/(100 "Hz") = 0,01 "s" = 10 "ms" $
  Para dos ciclos hay que dibujar al menos 20 ms en el eje horizontal.

  *3. Puntos notables*: ceros en 0; 5 y 10 ms. Máximo $+5$ V en $T\/4 = 2,5$ ms. Mínimo
  $-5$ V en $3T\/4 = 7,5$ ms.

  *4. Ahora con $phi = 45degree$.* Primero a radianes, con la @ec-grados:
  $ phi = 45degree dot pi/180degree = pi/4 "rad" $
  La expresión queda $s_2(t) = 5 "V" dot sin(2 pi dot 100 "Hz" dot t + pi\/4)$.

  *5. Corrimiento*, igualando el argumento a cero:
  $ 2 pi dot 100 "Hz" dot t + pi/4 = 0 quad arrow.r.double quad
    t = - (pi\/4)/(2 pi dot 100 "Hz") = -1,25 dot 10^(-3) "s" = -1,25 "ms" $

  *Conclusión*: el gráfico es idéntico al anterior, pero *desplazado 1,25 ms hacia el
  tiempo negativo*. A todos los puntos notables hay que restarles 1,25 ms: los ceros pasan
  a $-1,25$; 3,75 y 8,75 ms. Como $45degree$ es un octavo de vuelta, el corrimiento es un
  octavo del período: $10 "ms" \/ 8 = 1,25$ ms. Siempre conviene verificar así.
]

#ejercicio("Conversiones entre T, f y ω")[
  Completar, como pide el TP N.º 4:

  *a) Dato $f = 1$ kHz.*
  $ T = 1/f = 1/(1000 "Hz") = 1 "ms" quad quad
    omega = 2 pi f = 2 pi dot 1000 = 6283,2 " rad/s" $

  *b) Dato $T = 35$ ms.*
  $ f = 1/T = 1/(0,035 "s") = 28,57 "Hz" quad quad
    omega = (2 pi)/T = (2 pi)/(0,035) = 179,5 " rad/s" $

  *c) Dato $omega = 31 416$ 1/s.*
  $ f = omega/(2 pi) = (31 416)/(6,2832) = 5000 "Hz" = 5 "kHz" quad quad
    T = 1/f = "200 µs" $

  *Control de razonabilidad*: $omega$ siempre da un número unas 6,28 veces más grande que
  $f$. Si eso no se cumple, hay un error de cuentas.
]

== El osciloscopio

#definicion("Osciloscopio")[
  Instrumento que permite observar en una pantalla la *forma* con que varía la diferencia
  de potencial presente en su entrada. A diferencia del multímetro, que devuelve un solo
  número, el osciloscopio muestra la señal completa: forma de onda, valores máximo y
  mínimo, período y frecuencia, y cualquier comportamiento errático del equipo bajo prueba.
]

Los hay *analógicos* (procesan la señal en forma directa y la dibujan en un tubo de rayos
catódicos) y *digitales* (convierten la señal a números, la procesan y la muestran en una
pantalla LCD). Más allá de esa diferencia, los tres bloques centrales son los mismos.

=== Los tres bloques

#circuito([Diagrama en bloques del osciloscopio])[
```
              ┌─────────────────┐
   señal ──►  │  A. AMPLIFICADOR│──────────────┐
   (BNC)      │   / ATENUADOR   │              │      ┌──────────┐
              │     VERTICAL    │              ├─────►│ PANTALLA │
              │   (Volts/Div)   │              │      │  TRC/LCD │
              └────────┬────────┘              │      └──────────┘
                       │                       │
                       ▼                       │
              ┌─────────────────┐    ┌─────────┴───────┐
              │  C. DISPARO     │───►│ B. BASE DE TIEMPO│
              │    (TRIGGER)    │    │   (Time/Div)     │
              └─────────────────┘    └──────────────────┘
```
]

*A — Amplificador/atenuador vertical.* Adapta la señal de entrada al rango de la pantalla
y fija su posición en el eje Y. Contiene: la ficha *BNC* de entrada, el selector de escala
*Volts/Div*, la llave de *acoplamiento* y el ajuste de posición vertical.

#definicion("Acoplamiento de entrada: CC, CA y GND")[
  *CC (DC)*: entra la señal completa, incluida su componente continua. Es el modo por
  defecto. *CA (AC)*: un capacitor en serie *elimina la componente continua* y deja pasar
  solo la variación. Sirve para ver un ripple de 0,5 V montado sobre 15 V de continua, que
  en CC sería invisible. *GND*: desconecta la entrada y conecta el canal a masa, para
  marcar dónde está el cero en la pantalla.
]

*B — Base de tiempo (control de barrido).* Genera una señal *diente de sierra* que barre
la pantalla de izquierda a derecha. Junto con la deflexión vertical, es lo que dibuja la
onda. Su control es el selector *Time/Div*, y sobre él suele haber una perilla concéntrica
más chica que *saca de calibración* la base de tiempo.

*C — Disparo (trigger).* Sincroniza el barrido con la señal para que la imagen se vea
*quieta*. Permite elegir la fuente de disparo (canal 1, canal 2, externa), el nivel de
disparo y el modo automático.

#atencion[
  Las perillas concéntricas chicas de *Volts Variable* y de base de tiempo variable deben
  estar en su posición de *calibrado* (giradas a tope, con un clic) antes de medir. Si
  quedan fuera de calibración, las divisiones de la pantalla no valen lo que dice el
  selector y *todas las mediciones salen mal* sin ningún aviso. Lo mismo con la
  amplificación vertical X5/X10: apagada.
]

=== Procedimiento de medición

+ Probar la punta con la *salida de calibración* del propio osciloscopio, que entrega una
  cuadrada de 1 $V_(p p)$ y 1 kHz (verificar el valor en el panel del instrumento).
+ Poner Volts/Div acorde a la señal esperada, desactivar Volts Variable y la amplificación
  X5/X10.
+ Acoplamiento del canal en *CC*.
+ Fuente de disparo en el canal que se está usando, retención al mínimo, modo automático.
+ Ajustar el nivel de disparo hasta que la señal se detenga.
+ Ajustar Time/Div para ver *uno o dos ciclos* llenando la pantalla. Ni veinte ciclos
  apretados ni medio ciclo.

Una vez quieta la señal, se mide *contando divisiones*:

$ V_(p p) = "divisiones verticales" dot "Volts/Div" quad quad quad
  T = "divisiones horizontales" dot "Time/Div" $ <ec-osc>

y de ahí se obtiene todo lo demás: $V_p = V_(p p)\/2$, $f = 1\/T$, $V_"ef" = V_p\/sqrt(2)$.

=== Si no se ve nada

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([*Síntoma*], [*Qué revisar*]),
    [El haz desapareció de la pantalla],
    [Volts/Div demasiado chico: agrandarlo. O la componente continua es muy grande: pasar
     el canal a CA. O subir el brillo.],
    [La señal se corre constantemente de izquierda a derecha],
    [El disparo no engancha. Si la señal es chica, bajar Volts/Div. Ajustar el nivel de
     trigger a mano.],
    [Se ve una línea gruesa, o solo un pedazo del ciclo],
    [Time/Div mal elegido: ajustar la escala horizontal.],
    [Solo se ve una línea horizontal],
    [Canal en GND: pasarlo a CC o CA. Punta mal conectada. Volts/Div muy grande. Nivel de
     señal insuficiente.],
  ),
  caption: [Fallas típicas al intentar visualizar una señal],
)

== El generador de funciones de audio

Es la contraparte del osciloscopio: en vez de medir señales, las produce. Sus controles
son *forma de onda* (senoidal, cuadrada, triangular), *frecuencia* (perilla gruesa de
rango o multiplicador, más ajuste fino), *amplitud* y, en algunos modelos, *offset* de
continua.

#laboratorio[
  El generador entrega la señal que uno le pide *solo si la carga es alta*. Al conectarlo
  a una carga chica, la amplitud cae por su resistencia interna (típicamente 50 $Omega$).
  Por eso la amplitud *nunca se ajusta con el dial del generador*: se ajusta mirando el
  osciloscopio conectado en el circuito real.
]

#ejercicio("Configurar el generador y el osciloscopio a partir de datos indirectos")[
  Configurar una senoidal de $V_"ef" = 2,42$ V y $omega = 6280$ 1/s, e indicar qué escalas
  usar en el osciloscopio. (Es el punto 1c del TP N.º 5.)

  *1. Pasar de $omega$ a $f$ y $T$*, con la @ec-omega:
  $ f = omega/(2 pi) = (6280)/(6,2832) = 999,5 approx 1000 "Hz" $
  $ T = 1/f = 1 "ms" $

  *2. Pasar de $V_"ef"$ a lo que se ve en pantalla.* El osciloscopio no muestra valor
  eficaz: muestra pico a pico. Despejando de la @ec-vef-seno:
  $ V_p = V_"ef" dot sqrt(2) = 2,42 "V" dot 1,4142 = 3,42 "V" $
  $ V_(p p) = 2 dot V_p = 6,84 "V" $

  *3. Elegir las escalas* para que la onda ocupe bien la pantalla (8 divisiones
  verticales, 10 horizontales, típico):
  - *Volts/Div*: con 1 V/div, los 6,84 $V_(p p)$ ocupan 6,84 divisiones de las 8
    disponibles. Es la elección correcta. Con 2 V/div ocuparía 3,4 divisiones (se pierde
    resolución); con 0,5 V/div se saldría de la pantalla.
  - *Time/Div*: con 0,2 ms/div, un período de 1 ms ocupa 5 divisiones, y entran dos
    ciclos completos en las 10 divisiones. Es la elección correcta.

  *4. Verificación con el multímetro.* En *CA* el tester debe leer $approx 2,42$ V. En
  *CC* debe leer $approx 0$ V, porque el valor medio de una senoidal pura es cero. Que
  esas dos lecturas den lo esperado confirma que la señal está bien configurada y que no
  hay offset de continua.
]

== Filtro pasa bajos RC

Un capacitor se opone al paso de la corriente alterna con una *reactancia capacitiva*
que depende de la frecuencia:

$ X_C = 1/(2 pi f C) $ <ec-xc>

A baja frecuencia $X_C$ es enorme (el capacitor es casi un circuito abierto); a alta
frecuencia $X_C$ tiende a cero (el capacitor es casi un cortocircuito). Poniendo una R y
un C en divisor, esa dependencia se convierte en un filtro.

#circuito([Filtro pasa bajos RC])[
```
          R
   o───/\/\/\───┬───o
                │
  Vin          ═╪═ C      Vout
                │
   o────────────┴───o
```
]

Como es un divisor de tensión donde el elemento inferior es el capacitor:

$ V_"out" = V_"in" dot X_C/sqrt(R^2 + X_C^2) $ <ec-rc>

Y se define la *frecuencia de corte* $f_c$ como aquella en la que $X_C = R$. Igualando en
la @ec-xc:

$ 1/(2 pi f_c C) = R quad arrow.r.double quad f_c = 1/(2 pi R C) $ <ec-fc>

En $f_c$ la salida no es la mitad de la entrada sino
$V_"in"\/sqrt(2) = 0,707 V_"in"$ — es el famoso punto de $-3$ dB.

#ejercicio("Filtro RC de 1 kΩ y 1 µF a tres frecuencias")[
  Con $V_"in" = 1 V_(p p)$, calcular $V_"out"$ a 160 Hz, 1,6 kHz y 1,6 MHz.
  (Es el punto 4 del TP N.º 5.)

  *1. Frecuencia de corte*, con la @ec-fc:
  $ f_c = 1/(2 pi dot 1000 Omega dot 1 dot 10^(-6) "F") = 1/(6,283 dot 10^(-3)) = 159,2 "Hz" $

  *2. A $f = 160$ Hz* (prácticamente $f_c$):
  $ X_C = 1/(2 pi dot 160 dot 10^(-6)) = 995 Omega approx R $
  $ V_"out" = 1 V_(p p) dot 995/sqrt(1000^2 + 995^2) = 1 dot 995/1411 = 0,71 V_(p p) $

  *3. A $f = 1,6$ kHz* (diez veces $f_c$):
  $ X_C = 1/(2 pi dot 1600 dot 10^(-6)) = 99,5 Omega $
  $ V_"out" = 1 dot (99,5)/sqrt(1000^2 + "99,5"^2) = 1 dot (99,5)/(1005) = 0,099 V_(p p) $

  *4. A $f = 1,6$ MHz*:
  $ X_C = 0,0995 Omega quad arrow.r.double quad V_"out" approx 1 dot 0,0995/1000 = 0,1 "mV"_(p p) $

  *Conclusión*: por cada década de frecuencia por encima de $f_c$, la salida cae unas
  *diez veces*. A diez veces $f_c$ ya pasa apenas el 10 %; a diez mil veces, nada. Eso es
  exactamente lo que hace un filtro pasa bajos, y es el mismo principio con el que el
  capacitor de una fuente elimina el ripple en el Módulo 5.
]

#tp("TP N.º 4 y 5 — I Cuatrimestre")[
  - *TP 4 (Introducción al análisis de señales)*: el punto 1 se responde con la sección
    2.1; el punto 2 con 2.2; el punto 3 con "del gráfico a la expresión"; los puntos 4 a 7
    son el Ejercicio 2.2; el punto 8 es el Ejercicio 2.1.
  - *TP 5 (Manejo del osciloscopio)*: el punto 1 es el Ejercicio 2.3 — ojo con el inciso c,
    que da $V_"ef"$ y $omega$ en vez de $V_(p p)$ y $f$. El punto 4 es el Ejercicio 2.4.
  - Al medir con el tester la salida del generador, comparar CA y CC: es la verificación
    experimental de que el valor medio de una senoidal es cero.
]
