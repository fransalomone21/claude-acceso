#import "../plantilla.typ": *

#modulo("Respuesta en frecuencia, diagramas de Bode y filtrado", [
  Escribir la función de transferencia de un circuito, manejar el decibel sin dudar,
  trazar a mano el diagrama de Bode de módulo y de fase por asíntotas, diseñar y leer los
  filtros RC pasa bajos y pasa altos, y entender —vía Fourier— por qué una onda cuadrada
  se deforma al pasar por un filtro y qué significa eso en el osciloscopio.
])

El Módulo 11 resuelve el circuito a *una* frecuencia. La pregunta de ingeniería casi nunca
es esa: es *qué le pasa al circuito cuando la frecuencia cambia*. Un amplificador de audio
tiene que responder igual de 20 Hz a 20 kHz; una fuente tiene que dejar pasar la continua
y matar los 100 Hz del rizado; una radio tiene que quedarse con una emisora y rechazar
todas las demás. Todo eso es *respuesta en frecuencia*.

== La función de transferencia

#definicion("Función de transferencia")[
  Es el cociente entre el fasor de salida y el fasor de entrada, como función de la
  frecuencia:
  $ overline(H)(j omega) = (overline(V)_"sal")/(overline(V)_"ent")
    = |H(omega)| angle phi(omega) $
  Es un número complejo *para cada* $omega$. Su módulo dice cuánto amplifica o atenúa el
  circuito a esa frecuencia; su argumento, cuánto desfasa. Las dos curvas —módulo y fase
  contra frecuencia— son la respuesta en frecuencia del circuito.

  *No depende del convenio de fasores.* $overline(H)$ es un cociente entre dos fasores,
  así que el $sqrt(2)$ que separa el valor de pico del eficaz se cancela arriba y abajo:
  el módulo, la fase, los decibeles, la frecuencia de corte y el ancho de banda dan
  exactamente lo mismo se haya escrito el circuito en pico —como en la Parte II— o en
  eficaz —como en la Parte I—. Todo este módulo se lee igual en las dos escalas; lo
  único que hay que respetar es no mezclarlas dentro de la misma cuenta.
]

Como $overline(H)$ sale de resolver el circuito con impedancias, siempre resulta un
cociente de polinomios en $j omega$. Las raíces del numerador se llaman *ceros* (donde la
transferencia se anula) y las del denominador, *polos* (donde se dispararía). Polos y ceros
son toda la información: dan las dos curvas sin necesidad de calcular punto por punto.

== El decibel

#definicion("Decibel")[
  Es una medida *logarítmica* de una relación entre dos potencias:
  $ A_"dB" = 10 log_10 (P_2/P_1) $
  Como en una misma resistencia $P prop V^2$, para tensiones o corrientes el factor es 20:
  $ A_"dB" = 20 log_10 (V_2/V_1) $
  El decibel *no* es una unidad: es un cociente. "10 dB" no significa nada por sí solo si
  no se dice respecto de qué.
]

#clave[
  Se usa por tres razones, todas prácticas: convierte productos en sumas (etapas en
  cascada se *suman* en dB), comprime rangos enormes en números manejables (de 1 a un
  millón son 0 a 120 dB), y se parece a cómo percibe el oído.
]

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    align: center,
    table.header([*dB*], [$-20$], [$-6$], [$-3$], [$0$], [$+6$], [$+20$]),
    [Relación de tensión], [0,1], [0,50], [0,707], [1], [2], [10],
    [Relación de potencia], [0,01], [0,25], [0,50], [1], [4], [100],
  ),
  caption: [Los valores de decibel que hay que saber de memoria],
)

#atencion[
  Los $-3$ dB son el número más usado de toda la electrónica y conviene entender *por qué*:
  $20 log_10 (1\/sqrt(2)) = -3,01$ dB, y $1\/sqrt(2)$ en tensión es *la mitad en potencia*.
  Por eso al punto de $-3$ dB se lo llama "frecuencia de media potencia", y por eso define
  el límite del ancho de banda: es donde el circuito ya entrega la mitad de lo que puede.
]

== Filtro pasa bajos RC

#circuito([Pasa bajos y pasa altos: el mismo circuito, otra salida])[
#fig-pasabajos-pasaaltos()
#pie-figura[Con la salida sobre $C$: a $f arrow.r 0$ el capacitor es un abierto
  y $overline(V)_s = overline(V)_e$; a $f arrow.r infinity$ es un corto y
  $overline(V)_s = 0$. Con la salida sobre $R$ pasa exactamente al revés.]
]

Es un divisor de tensión con impedancias. La salida se toma sobre el capacitor:

$ overline(H) = (overline(Z)_C)/(R + overline(Z)_C)
  = (1\/(j omega C))/(R + 1\/(j omega C))
  = 1/(1 + j omega R C) $ <ec-pb>

Definiendo la *frecuencia de corte* como aquella en que la parte real y la imaginaria del
denominador se igualan:

$ omega_c = 1/(R C) quad quad arrow.r quad quad f_c = 1/(2 pi R C) $ <ec-fc-rc>

la transferencia queda en la forma canónica, y de ella salen módulo y fase:

$ overline(H) = 1/(1 + j (omega\/omega_c)) quad arrow.r quad
  |H| = 1/sqrt(1 + (omega\/omega_c)^2), quad
  phi = - arctan(omega/omega_c) $ <ec-pb-modfase>

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    table.header([*Frecuencia*], [$|H|$], [*en dB*], [*fase*], [*Comportamiento*]),
    [$omega << omega_c$], [$approx 1$], [0 dB], [$approx 0 degree$], [pasa entera],
    [$omega = omega_c \/ 10$], [0,995], [$-0,04$ dB], [$-5,7 degree$], [pasa casi entera],
    [$omega = omega_c$], [0,707], [$-3$ dB], [$-45 degree$], [media potencia],
    [$omega = 10 omega_c$], [0,0995], [$-20$ dB], [$-84,3 degree$], [atenuada 10 veces],
    [$omega >> omega_c$], [$approx omega_c\/omega$], [$-20$ dB/déc], [$-90 degree$], [se apaga],
  ),
  caption: [Comportamiento del pasa bajos de primer orden],
)

#clave[
  Por encima de $omega_c$, cada vez que la frecuencia se multiplica por diez la salida se
  divide por diez: *la pendiente asintótica de un polo simple es $-20$ dB por década*
  (equivalentemente, $-6$ dB por octava). Ese número no depende de $R$ ni de $C$ ni de
  nada: es la firma de un polo de primer orden, y saberlo es lo que permite dibujar Bode
  sin calcular.
]

== Filtro pasa altos RC

El mismo circuito con la salida sobre el resistor:

$ overline(H) = R/(R + 1\/(j omega C)) = (j omega R C)/(1 + j omega R C)
  = (j (omega\/omega_c))/(1 + j (omega\/omega_c)) $ <ec-pa>

con la misma $omega_c = 1\/R C$. Ahora $|H| arrow.r 0$ en continua y $arrow.r 1$ en alta
frecuencia; la pendiente asintótica por debajo del corte es $+20$ dB/década y la fase va de
$+90 degree$ a $0 degree$.

#laboratorio[
  El pasa altos RC es el *capacitor de acoplamiento* que aparece en todo amplificador:
  bloquea la continua del punto de reposo y deja pasar la señal. Elegir su valor es elegir
  $f_c$ muy por debajo de la frecuencia más baja de interés. Para audio ($20$ Hz) con una
  entrada de 10 k$Omega$: $C > 1\/(2 pi dot 20 dot 10^4) approx 0,8 mu F$; se pone 1 o
  2,2 µF y se está tranquilo.
]

== Diagramas de Bode

#definicion("Diagrama de Bode")[
  Dos gráficos con la frecuencia en escala *logarítmica*:
  - *Módulo*: $20 log_10 |H|$ en dB, en el eje vertical.
  - *Fase*: $phi$ en grados, en el eje vertical.

  La gracia es que, con esos ejes, los factores se vuelven sumas y *las curvas se
  aproximan muy bien con rectas* (asíntotas). Se dibujan las rectas, se corrigen tres
  puntos, y queda.
]

=== Las asíntotas de cada factor

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Factor*], [*Módulo*], [*Fase*]),
    [Constante $K$], [recta horizontal en $20 log_10 K$], [$0 degree$ (o $180 degree$ si $K<0$)],
    [Polo en el origen, $1\/(j omega)$], [recta de $-20$ dB/déc que pasa por 0 dB en $omega = 1$],
      [$-90 degree$ constante],
    [Cero en el origen, $j omega$], [$+20$ dB/déc], [$+90 degree$ constante],
    [Polo simple, $1\/(1 + j omega\/omega_p)$],
      [0 dB hasta $omega_p$, después $-20$ dB/déc], [de $0 degree$ a $-90 degree$],
    [Cero simple, $1 + j omega\/omega_z$],
      [0 dB hasta $omega_z$, después $+20$ dB/déc], [de $0 degree$ a $+90 degree$],
  ),
  caption: [Aporte asintótico de cada factor al diagrama de Bode],
)

#clave[
  *Las tres correcciones que hay que recordar.* En el módulo, la asíntota se equivoca
  exactamente $3$ dB en la frecuencia de quiebre (y menos de $1$ dB a una octava de
  distancia). En la fase, el cambio no es abrupto: se reparte a lo largo de *dos décadas*,
  desde $omega_p\/10$ hasta $10 omega_p$, pasando por $-45 degree$ justo en $omega_p$. La
  pendiente de esa rampa es $-45 degree$ por década.
]

=== El método, en cuatro pasos

+ Llevar $overline(H)$ a la forma canónica: producto de factores del tipo $K$,
  $(j omega)^(plus.minus 1)$ y $(1 + j omega\/omega_k)^(plus.minus 1)$.
+ Marcar en el eje logarítmico todas las frecuencias de quiebre (los $omega_k$).
+ Empezar por la izquierda con la asíntota de baja frecuencia y avanzar: en cada quiebre,
  *sumar* $-20$ dB/déc si es polo y $+20$ dB/déc si es cero.
+ Corregir $3$ dB en cada quiebre y dibujar la curva suave.

#circuito([Bode asintótico del amplificador del Ejercicio 12.1])[
#graf-bode-amplificador()
#pie-figura[Las asíntotas quiebran en $omega_(p 1) = 10^2$ y
  $omega_(p 2) = 10^5$ rad/s. La curva exacta va $3$ dB por debajo de la
  asíntota en cada quiebre: ésa es la corrección del cuarto paso del método.]
]

#ejercicio("Bode de un amplificador acoplado por capacitor")[
  Un amplificador tiene
  $ overline(H)(j omega) = 200 dot (j omega\/100)/((1 + j omega\/100)(1 + j omega\/10^5)) $

  *1. Identificar los factores.* Hay una constante $K = 200$, un cero en el origen
  (escalado), un polo en $omega_(p 1) = 100$ rad/s y otro en $omega_(p 2) = 10^5$ rad/s.

  *2. Zona de baja frecuencia* ($omega << 100$): el denominador vale 1, así que
  $|H| approx 200 dot omega\/100 = 2 omega$: una recta de $+20$ dB/década. En
  $omega = 1$ rad/s vale $20 log_10 2 = 6$ dB.

  *3. Banda de paso* ($100 << omega << 10^5$): el cero y el primer polo se cancelan
  ($j omega\/100$ arriba y abajo), y el segundo polo todavía no actúa:
  $ |H| approx 200 quad arrow.r quad 20 log_10 200 = 46 "dB" $
  Es la *ganancia de banda media*, y es plana: exactamente lo que se le pide a un
  amplificador de audio.

  *4. Zona de alta frecuencia* ($omega >> 10^5$): entra el segundo polo y la curva cae a
  $-20$ dB/década.

  *5. Los puntos de $-3$ dB.* En $omega_(p 1) = 100$ rad/s y en $omega_(p 2) = 10^5$ rad/s
  la respuesta vale $46 - 3 = 43$ dB. Entre esas dos frecuencias está el ancho de banda:
  $ f_"inf" = (100)/(2 pi) = 15,9 "Hz" quad quad
    f_"sup" = (10^5)/(2 pi) = 15,9 "kHz" $

  *6. Leer el resultado.* De 15,9 Hz a 15,9 kHz: es *exactamente* la banda de audio. El
  polo de abajo lo pone el capacitor de acoplamiento; el de arriba, las capacidades
  parásitas del transistor. Diseñar el amplificador es correr esos dos polos hacia afuera
  hasta que la banda plana cubra lo que hace falta.

  *7. La fase.* Arranca en $+90 degree$ (por el cero en el origen), baja a $0 degree$ en la
  banda de paso —el primer polo cancela el aporte del cero— y termina en $-90 degree$
  arriba de $10^5$ rad/s. En banda media la señal sale *en fase*: también eso es lo que se
  le pide a un amplificador.
]

== Filtros pasa banda y elimina banda

Poniendo en cascada un pasa altos y un pasa bajos con $f_(c 1) << f_(c 2)$ queda un *pasa
banda* de banda ancha. Con un RLC se obtiene uno *sintonizado*, y ahí valen las fórmulas
de resonancia del Módulo 11:

$ f_0 = 1/(2 pi sqrt(L C)) quad quad "BW" = f_0/Q quad quad
  f_(1,2) approx f_0 plus.minus "BW"/2 quad ("si" Q >> 1) $ <ec-pasabanda>

#atencion[
  Poner dos etapas RC en cascada *no* duplica la pendiente en el punto de corte sin más:
  cada etapa *carga* a la anterior y le corre la frecuencia de corte. Dos pasa bajos
  idénticos de $f_c$ en cascada directa dan una respuesta cuya caída a $-3$ dB ocurre a
  $0,64 f_c$, no a $f_c$. Para que las etapas no se carguen entre sí hay que separarlas con
  un *seguidor* —un amplificador operacional de ganancia 1, Módulo 13—, y ese es
  justamente uno de los motivos por los que existen los filtros activos.
]

== Señales poliarmónicas: por qué esto importa

Todo lo anterior se dedujo para una señal senoidal. Las señales reales no lo son. El
puente entre ambas cosas es el teorema de Fourier.

#definicion("Serie de Fourier")[
  Toda señal periódica de período $T$ y frecuencia $f = 1\/T$, razonablemente bien
  comportada, se puede escribir como una suma de senoidales cuyas frecuencias son
  *múltiplos enteros* de $f$:
  $ v(t) = V_0 + sum_(n=1)^infinity V_n cos(2 pi n f t + phi_n) $
  $V_0$ es el valor medio (la componente continua), $n = 1$ es la *fundamental* y
  $n >= 2$ son los *armónicos*.
]

Para la onda cuadrada simétrica de amplitud $V$, el desarrollo tiene solo armónicos
impares y sus amplitudes caen como $1\/n$:

$ v_"cuad" (t) = (4 V)/pi [sin omega t + 1/3 sin 3 omega t + 1/5 sin 5 omega t + dots] $ <ec-cuadrada>

#clave[
  Y acá se cierra todo el círculo. Como el circuito es *lineal*, vale superposición
  (Módulo 9): se puede calcular la respuesta a *cada armónico por separado* —con la
  impedancia recalculada en su propia frecuencia, porque $overline(H)$ depende de
  $omega$— y sumar las respuestas en el tiempo. El filtro no "deforma" la señal por
  capricho: le atenúa y le desfasa cada armónico de manera distinta, y la suma ya no da la
  misma forma.
]

#ejercicio("Por qué la cuadrada sale redondeada del pasa bajos")[
  Un pasa bajos RC con $R = 1 "k"Omega$ y $C = 100$ nF recibe una onda cuadrada de 500 Hz
  y 5 V de amplitud.

  *1. Frecuencia de corte del filtro.*
  $ f_c = 1/(2 pi dot 10^3 dot 100 dot 10^(-9)) = 1592 "Hz" $

  *2. Qué hay en la cuadrada de 500 Hz.* Por la @ec-cuadrada, armónicos impares en 500,
  1500, 2500, 3500 Hz… con amplitudes relativas $1$, $1\/3$, $1\/5$, $1\/7$…

  *3. Qué le hace el filtro a cada uno*, con la @ec-pb-modfase:

  #table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    table.header([$n$], [$f$ [Hz]], [amplitud relativa], [$|H|$], [amplitud a la salida]),
    [1], [500],  [1,000], [0,954], [0,954],
    [3], [1500], [0,333], [0,728], [0,243],
    [5], [2500], [0,200], [0,537], [0,107],
    [7], [3500], [0,143], [0,414], [0,059],
  )

  *4. Leer la tabla.* La fundamental pasa casi intacta; el séptimo armónico queda en un
  tercio de lo que era. Como los flancos verticales de una cuadrada están hechos
  *justamente* de armónicos altos, al recortarlos los flancos se redondean: en pantalla
  aparece la exponencial del Módulo 10.

  *5. Los dos lenguajes son el mismo.* En el tiempo se dice "el capacitor tarda $tau = R C$
  en cargarse"; en la frecuencia se dice "el filtro atenúa por encima de
  $f_c = 1\/(2 pi R C)$". Son la misma frase:
  $ tau = R C = 100 mu s quad quad f_c = 1/(2 pi tau) = 1592 "Hz" $
  Un circuito rápido tiene $tau$ chico *y* ancho de banda grande, y las dos cosas están
  atadas por esa igualdad. De hecho, para un pasa bajos de primer orden, el tiempo de
  subida del 10 % al 90 % vale $t_r = 2,2 tau approx 0,35 \/ f_c$, que es la fórmula que
  traen impresa los osciloscopios.
]

#tp("Con los TP N.º 4 y 5 — I Cuatrimestre")[
  El TP N.º 4 pide identificar los parámetros de las señales periódicas y el TP N.º 5,
  configurarlas y medirlas con el generador y el osciloscopio. Este módulo es lo que hay
  detrás: la *frecuencia* de una señal no es un dato administrativo, es la variable de la
  que depende todo lo que el circuito le hace.

  Un agregado que se puede hacer en el laboratorio con el mismo instrumental del TP N.º 5,
  sin componentes nuevos más que un resistor y un capacitor: armar el pasa bajos, excitarlo
  con el generador en senoidal, y medir $V_"sal"\/V_"ent"$ a 100 Hz, 300 Hz, 1 kHz, 3 kHz y
  10 kHz. Graficar en papel semilogarítmico. Sale el Bode de la @ec-pb-modfase medido a
  mano, y la $f_c$ leída del gráfico permite despejar $C$ y compararla con el valor
  impreso en el componente.
]
