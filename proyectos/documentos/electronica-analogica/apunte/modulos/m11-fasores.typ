#import "../plantilla.typ": *

#modulo("Fasores y régimen permanente senoidal", [
  Convertir un circuito de alterna en un circuito de continua con números complejos:
  escribir el fasor de cualquier senoidal, calcular impedancias, y reutilizar *sin cambios*
  todo lo aprendido en los módulos 7 a 9 —serie, paralelo, divisores, nodos, mallas,
  Thévenin, superposición—. Además: calcular potencia activa, reactiva y aparente,
  corregir el factor de potencia con un capacitor, y entender la resonancia y el factor
  de mérito $Q$.
])

El Módulo 10 mostró que con capacitores e inductores hay que resolver ecuaciones
diferenciales. Si eso hubiera que hacerlo cada vez, la ingeniería eléctrica sería
impracticable. La salida es una idea del siglo XIX —de Charles Steinmetz— y es una de las
más rentables de toda la disciplina: *en régimen permanente senoidal, la ecuación
diferencial se convierte en una ecuación algebraica con números complejos*.

== El punto de partida

Si un circuito lineal se excita con una senoidal de frecuencia $omega$ y se espera lo
suficiente (los $5 tau$ del Módulo 10), el transitorio se apaga y *todas* las tensiones y
corrientes del circuito son senoidales de *la misma frecuencia* $omega$. Solo pueden
diferir en dos cosas: la *amplitud* y la *fase*.

#clave[
  Esa es toda la observación. Como la frecuencia es un dato conocido y común a todo el
  circuito, no hace falta arrastrarla: alcanza con llevar la cuenta de amplitud y fase.
  Dos números por señal. Y dos números son exactamente lo que es un número complejo.
]

== El fasor

Se usa la identidad de Euler, $e^(j theta) = cos theta + j sin theta$, para escribir la
senoidal como la parte real de una exponencial compleja:

$ v(t) = V_m cos(omega t + phi) = "Re"{ V_m e^(j(omega t + phi)) }
       = "Re"{ underbrace(V_m e^(j phi), "el fasor") dot e^(j omega t) } $ <ec-euler>

#definicion("Fasor")[
  El *fasor* de una senoidal es el número complejo que guarda su amplitud y su fase:
  $ overline(V) = V_m e^(j phi) = V_m angle phi $
  El factor $e^(j omega t)$ se deja de escribir porque es común a todo el circuito y se
  cancela en todas las ecuaciones.

  *Convenio de este apunte*: el fasor va en *valor de pico*. Su módulo es la amplitud
  $V_m$ —lo que se lee en la pantalla del osciloscopio—, no el valor eficaz. Es el
  convenio de los cuatro libros de la cátedra de Teoría de Circuitos.

  La Parte I trabaja en eficaz, porque es lo que marca el multímetro en CA. La
  conversión entre las dos formas está publicada entera en la sección *Convenciones y
  notación*, al frente del apunte. En dos líneas: $V_"ef" = V_m \/ sqrt(2)$, las
  impedancias y las ganancias no cambian —son cocientes— y el precio del convenio es
  un factor $1\/2$ en las potencias, que aparece en la sección 11.4 y en ningún otro
  lado.
]

=== Por qué esto funciona

La propiedad que hace todo el trabajo es una sola: *derivar en el tiempo equivale a
multiplicar por $j omega$*.

$ (dif)/(dif t) [V_m e^(j(omega t + phi))] = j omega dot V_m e^(j(omega t + phi)) $ <ec-deriv-fasor>

Y por lo tanto integrar equivale a dividir por $j omega$. Con eso, cualquier ecuación
íntegro-diferencial del circuito se vuelve algebraica. El factor $j$ no es un artificio de
cálculo: multiplicar por $j = 1 angle 90 degree$ es *rotar 90 grados*, que es exactamente
lo que la derivada le hace a una senoidal.

== Impedancia

Aplicando la @ec-deriv-fasor a las tres relaciones constitutivas:

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, left),
    table.header([*Elemento*], [*Relación*], [*Impedancia* $overline(Z)$], [*Módulo*], [*Qué hace la fase*]),
    [Resistor], [$v = R i$], [$R$], [$R$], [nada: $v$ e $i$ en fase],
    [Inductor], [$v = L thin dif i\/dif t$], [$j omega L$], [$X_L = omega L$],
      [la tensión *adelanta* 90°],
    [Capacitor], [$i = C thin dif v\/dif t$], [$1\/(j omega C) = -j\/(omega C)$],
      [$X_C = 1\/(omega C)$], [la tensión *atrasa* 90°],
  ),
  caption: [Impedancia de los tres elementos pasivos],
)

#definicion("Impedancia y admitancia")[
  $ overline(Z) = (overline(V))/(overline(I)) = R + j X quad ["ohm"] quad quad
    overline(Y) = 1/(overline(Z)) = G + j B quad ["siemens"] $
  $R$ es la *resistencia*, $X$ la *reactancia*, $G$ la *conductancia* y $B$ la
  *susceptancia*. En forma polar, $overline(Z) = |Z| angle theta$ con
  $ |Z| = sqrt(R^2 + X^2) quad quad theta = arctan(X/R) $
  El ángulo $theta$ *es* el desfasaje entre la tensión y la corriente. Si $X > 0$ la carga
  es *inductiva* y la corriente atrasa; si $X < 0$ es *capacitiva* y la corriente adelanta.
]

#atencion[
  $overline(Y) = 1\/overline(Z)$ vale para el *complejo entero*, pero
  $G != 1\/R$ y $B != 1\/X$ salvo en los casos triviales. Racionalizando:
  $ overline(Y) = 1/(R + j X) = (R - j X)/(R^2 + X^2)
    quad arrow.r quad G = R/(R^2+X^2), quad B = (-X)/(R^2+X^2) $
  Invertir por separado es un error frecuente y siempre da mal.
]

=== La regla de oro del método

#clave[
  Con impedancias, *todas las herramientas de los módulos 7, 8 y 9 valen sin ninguna
  modificación*, cambiando $R$ por $overline(Z)$ y trabajando con números complejos:

  - LKC y LKT valen para los fasores.
  - Serie: $overline(Z)_"eq" = sum overline(Z)_k$. Paralelo:
    $1\/overline(Z)_"eq" = sum 1\/overline(Z)_k$.
  - Divisor de tensión y de corriente: idénticos.
  - Análisis nodal ($bold(Y) bold(V) = bold(I)$) y de mallas ($bold(Z) bold(I) = bold(V)$):
    idénticos, con matrices complejas.
  - Superposición, transformación de fuentes, Thévenin, Norton, Millman: idénticos.

  Esto es lo que justifica haber puesto tanto trabajo en la Parte II antes de llegar acá.
  No hay una teoría de alterna aparte: hay *la misma teoría*, con otro cuerpo numérico.
]

#atencion[
  La única condición es que *toda* el circuito trabaje a la misma frecuencia. Si hay
  fuentes de frecuencias distintas, no se pueden sumar sus fasores: hay que resolver un
  circuito por frecuencia —con la impedancia recalculada en cada una— y sumar las
  respuestas *en el tiempo*, por superposición. Eso es exactamente lo que hace falta para
  las señales poliarmónicas del Módulo 12.
]

#circuito([RLC serie en régimen permanente senoidal])[
#fig-rlc-serie()
]

#ejercicio("RLC serie: impedancia, corriente y el diagrama fasorial")[
  $R = 30 Omega$, $L = 60$ mH, $C = $ "50 µF", $omega = 1000$ rad/s, alimentado con
  $v(t) = 100 cos(1000 t)$ V. En valor de pico, que es el convenio de esta parte, eso es
  $overline(V) = 100 angle 0 degree$ V.

  *1. Reactancias.*
  $ X_L = omega L = 1000 dot 0,06 = 60 Omega quad quad
    X_C = 1/(omega C) = 1/(1000 dot 50 dot 10^(-6)) = 20 Omega $

  *2. Impedancia total* (los tres en serie, así que se suman):
  $ overline(Z) = 30 + j 60 - j 20 = 30 + j 40 Omega $
  $ |Z| = sqrt(30^2 + 40^2) = 50 Omega quad quad
    theta = arctan(40/30) = 53,13 degree $
  $ overline(Z) = 50 angle 53,13 degree thin Omega $
  Reactancia positiva: la carga es *inductiva*, la corriente atrasa 53,13°.

  *3. Corriente.*
  $ overline(I) = (overline(V))/(overline(Z)) = (100 angle 0 degree)/(50 angle 53,13 degree)
    = 2 angle ang("−53,13°") thin "A" $

  *4. Tensión sobre cada elemento.* En serie la corriente es común, así que cada tensión
  es $overline(I)$ por su impedancia:
  $ overline(V)_R = 2 dot 30 = 60 angle ang("−53,13°") thin "V" $
  $ overline(V)_L = 2 dot 60 angle 90 degree = 120 angle 36,87 degree thin "V" $
  $ overline(V)_C = 2 dot 20 angle ang("−90°") = 40 angle ang("−143,13°") thin "V" $

  *5. El resultado que sorprende.* $overline(V)_L = 120$ V es *mayor que los 100 V de la
  fuente*. No hay error ni violación de nada: $overline(V)_L$ y $overline(V)_C$ están en
  contrafase y se restan. Su suma vale $120 - 40 = 80$ V, y como esa suma es
  perpendicular a $overline(V)_R$:
  $ |overline(V)| = sqrt(60^2 + 80^2) = 100 "V" quad checkmark $
  *En alterna las tensiones se suman como vectores, no como números.* Un voltímetro
  puesto sobre el inductor de un circuito serie puede marcar más que la línea, y eso es
  correcto. Es la misma razón por la que en resonancia (sección 11.6) aparecen
  sobretensiones peligrosas.

  *6. Diagrama fasorial.* Tomando $overline(I)$ como referencia horizontal:
  $overline(V)_R$ va con ella, $overline(V)_L$ 90° adelantada, $overline(V)_C$ 90°
  atrasada, y $overline(V)$ cierra el polígono.

  *7. Las potencias, con el factor $1\/2$ del convenio* (sección 11.4):
  $ P = 1/2 V_m I_m cos theta = 1/2 dot 100 dot 2 dot 0,6 = 60 "W" $
  $ Q = 1/2 V_m I_m sin theta = 1/2 dot 100 dot 2 dot 0,8 = 80 "VAr" $
  $ S = 1/2 V_m I_m = 100 "VA" quad arrow.r quad sqrt(60^2 + 80^2) = 100 quad checkmark $

  *8. La verificación por el segundo camino.* Toda la potencia activa la disipa $R$, y
  la corriente eficaz vale $I_"ef" = 2 \/ sqrt(2) = 1,414$ A:
  $ P_R = I_"ef"^2 R = 1,414^2 dot 30 = 2 dot 30 = 60 "W" quad checkmark $
  $ Q = I_"ef"^2 (X_L - X_C) = 2 dot 40 = 80 "VAr" quad checkmark $
  Y por el tercer camino, en eficaz, con $V_"ef" = 70,71$ V:
  $ P = V_"ef" I_"ef" cos theta = 70,71 dot 1,414 dot 0,6 = 60 "W" quad checkmark $
  Los tres coinciden, que es exactamente lo que promete la tabla de equivalencia de la
  sección de convenciones.

  *9. Cómo se vería esto medido.* Todos los números de los pasos 1 a 6 están en *pico*.
  Un multímetro en CA sobre la fuente marcaría $100\/sqrt(2) = 70,7$ V, y sobre el
  inductor $120\/sqrt(2) = 84,9$ V. El osciloscopio, en cambio, mostraría 100 V y 120 V
  de amplitud. Los dos instrumentos tienen razón: la relación $120\/100$ es la misma en
  las dos escalas, y es lo único que el circuito determina.
]

#circuito([Diagrama fasorial del ejercicio, con $overline(I)$ como referencia])[
#graf-diagrama-fasorial()
#pie-figura[$overline(V)_L$ y $overline(V)_C$ están en contrafase: su suma vale
  $120 - 40 = 80$ V y queda perpendicular a $overline(V)_R$. Por eso
  $sqrt(60^2 + 80^2) = 100$ V, y por eso 120 V sobre el inductor conviven con
  100 V de fuente.]
]

== Potencia en alterna

La potencia instantánea de una carga con $v = V_m cos omega t$ e
$i = I_m cos(omega t - theta)$ vale, usando la identidad del producto de cosenos:

$ p(t) = v i = (V_m I_m)/2 [cos theta + cos(2 omega t - theta)] $ <ec-pot-inst>

Tiene *dos* partes, y esa es la clave de todo:

- un término *constante*, $(V_m I_m \/ 2) cos theta$, que es lo que realmente se
  consume — y ahí está a la vista, en la deducción misma, el factor $1\/2$ del convenio
  de pico: la potencia media es la mitad del producto de las dos amplitudes;
- un término que *oscila al doble de la frecuencia* con valor medio cero: energía que va
  y viene entre la fuente y los elementos reactivos sin consumirse jamás.

#definicion("Las tres potencias y el factor de potencia")[
  Con los fasores en valor de pico, $V_m$ e $I_m$ las dos amplitudes y $theta$ el ángulo
  de la impedancia:
  $ P = 1/2 V_m I_m cos theta quad ["W", "watt"] quad quad "potencia activa" $
  $ Q = 1/2 V_m I_m sin theta quad ["VAr"] quad quad "potencia reactiva" $
  $ S = 1/2 V_m I_m quad ["VA"] quad quad "potencia aparente" $
  $ overline(S) = 1/2 overline(V) thin overline(I)^* = P + j Q quad quad "potencia compleja" $ <ec-potencias>

  El $1\/2$ es el precio del convenio de pico y no aparece en ninguna otra fórmula del
  módulo. En valor *eficaz* las mismas cuatro se escriben sin él —$P = V_"ef" I_"ef"
  cos theta$, y así las demás— porque
  $V_"ef" I_"ef" = (V_m\/sqrt(2))(I_m\/sqrt(2)) = V_m I_m \/ 2$: es el mismo número
  escrito de dos maneras, no dos potencias distintas.

  El *factor de potencia*
  $ "f.d.p." = cos theta = P/S $
  no depende del convenio, porque es un cociente y el $1\/2$ se cancela. Se aclara
  siempre si es *en atraso* (carga inductiva, $Q > 0$) o *en adelanto* (capacitiva,
  $Q < 0$), porque el coseno no distingue el signo.
]

Como $P$, $Q$ y $S$ forman un triángulo rectángulo:

$ S = sqrt(P^2 + Q^2) quad quad tan theta = Q/P $ <ec-triangulo>

#clave[
  La potencia reactiva $Q$ *no se consume*: su valor medio es cero. Pero *sí circula*, y
  por lo tanto calienta los cables, ocupa la sección del conductor y satura el
  transformador exactamente igual que la activa. Por eso la distribuidora la cobra: no
  cobra energía que no entregó, cobra la infraestructura que tuvo que poner para
  transportar corriente que no hizo trabajo.
]

=== Corrección del factor de potencia

Una carga inductiva (todo lo que tiene bobinado: motores, balastos, transformadores)
toma $Q > 0$. Un capacitor en paralelo aporta $Q < 0$: los dos se cancelan parcialmente
y la corriente de línea baja. La carga sigue recibiendo la misma $P$.

Para pasar de $cos theta$ a $cos theta'$ manteniendo $P$:

$ Q_C = P (tan theta - tan theta') quad arrow.r quad
  C = (Q_C)/(omega V_"ef"^2) $ <ec-correccion>

La $V_"ef"$ de la @ec-correccion no es un descuido del convenio: la tensión de una
instalación se conoce y se especifica en eficaz, y la fórmula queda más corta así. En
valor de pico es $C = 2 Q_C \/ (omega V_m^2)$, que es el mismo número —otra vez el
$1\/2$, y en el único lugar donde tiene que estar.

#ejercicio("Corrección del cos φ de un motor")[
  Un motor monofásico de $P = 2200$ W trabaja en 220 V, 50 Hz, con
  $cos theta = 0,6$ en atraso. Se quiere llevarlo a $cos theta' = 0,95$.

  *0. Los datos vienen en eficaz*, como en cualquier instalación: 220 V es lo que marca
  el multímetro y lo que dice la chapa del motor. Por eso todo el ejercicio se hace con
  la forma eficaz de las fórmulas, sin el $1\/2$. Si hiciera falta el fasor de la línea,
  sería $overline(V) = 220 sqrt(2) angle 0 degree = 311 angle 0 degree$ V.

  *1. Estado inicial.*
  $ S = P/(cos theta) = (2200)/(0,6) = 3667 "VA" quad arrow.r quad
    I_"ef" = S/V_"ef" = (3667)/(220) = 16,7 "A" $
  $ theta = arccos 0,6 = 53,13 degree quad arrow.r quad
    Q = P tan theta = 2200 dot 1,333 = 2933 "VAr" $

  *2. Estado deseado.*
  $ theta' = arccos 0,95 = 18,19 degree quad arrow.r quad
    Q' = P tan theta' = 2200 dot 0,3287 = 723 "VAr" $

  *3. El capacitor tiene que aportar la diferencia.*
  $ Q_C = 2933 - 723 = 2210 "VAr" $
  $ C = (Q_C)/(omega V_"ef"^2) = (2210)/(2 pi dot 50 dot 220^2)
      = (2210)/(314,16 dot 48400) = "145 µF" $

  *4. Qué se ganó.*
  $ I'_"ef" = P/(V_"ef" cos theta') = (2200)/(220 dot 0,95) = 10,5 "A" $
  La corriente de línea bajó de 16,7 A a 10,5 A: un *37 % menos*. Las pérdidas en el
  cable, que van con $I^2$, bajaron un 60 %. Y todo eso sin cambiar en nada lo que el
  motor entrega por el eje.

  *5. Lo que hay que mirar en la práctica.* El capacitor debe soportar la tensión de línea
  de forma permanente (se especifica en volt de *alterna*, no de continua) y no conviene
  pasarse: sobrecorregir lleva el factor de potencia al adelanto, que también se penaliza
  y además puede producir sobretensiones al desconectar la carga.
]

== Máxima transferencia de potencia en alterna

El teorema del Módulo 9 se generaliza con una vuelta de tuerca. Con
$overline(Z)_"th" = R_"th" + j X_"th"$, la carga que recibe la máxima potencia activa es
la *conjugada*:

$ overline(Z)_L = overline(Z)_"th"^* = R_"th" - j X_"th"
  quad arrow.r quad P_(L,"máx") = (V_(m,"th")^2)/(8 R_"th")
  = (V_("ef","th")^2)/(4 R_"th") $ <ec-max-pot-ac>

La razón es directa: la parte reactiva de la carga *cancela* la de la fuente, dejando un
circuito puramente resistivo, y sobre ese circuito vale el resultado del Módulo 9. Si la
carga solo puede ser resistiva, el óptimo pasa a ser $R_L = |overline(Z)_"th"|$.

El 8 del denominador es el 4 del Módulo 9 multiplicado por el $1\/2$ del convenio de
pico. Escrita en eficaz, la fórmula es *idéntica* a la de continua, y esa es la mejor
comprobación de que el convenio no cambió la física.

== Resonancia

#definicion("Resonancia")[
  Un circuito está en resonancia cuando su impedancia es *puramente resistiva*: la
  reactancia inductiva y la capacitiva se cancelan y la corriente queda en fase con la
  tensión. Ocurre a la frecuencia
  $ omega L = 1/(omega C) quad arrow.r quad omega_0 = 1/sqrt(L C)
    quad arrow.r quad f_0 = 1/(2 pi sqrt(L C)) $
  Es la misma $omega_0$ del Módulo 10: la respuesta transitoria y la respuesta en
  frecuencia son dos vistas del mismo circuito.
]

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([], [*Serie*], [*Paralelo (tanque)*]),
    [En $omega_0$ la impedancia es], [*mínima* ($= R$)], [*máxima*],
    [En $omega_0$ la corriente es], [máxima], [mínima],
    [Factor de mérito $Q$], [$(omega_0 L)\/R = (1\/R) sqrt(L\/C)$], [$R\/(omega_0 L) = R sqrt(C\/L)$],
    [Sobre-magnitud], [$V_L = V_C = Q dot V$ (sobretensión)], [$I_L = I_C = Q dot I$ (sobrecorriente)],
    [Se usa para], [captar / cortar una frecuencia en serie], [sintonizar (radio, osciladores)],
  ),
  caption: [Resonancia serie y paralelo],
)

El *ancho de banda* —el rango entre las frecuencias donde la potencia cae a la mitad— vale

$ "BW" = (f_0)/Q quad ["Hz"] $ <ec-bw>

de modo que $Q$ mide, a la vez, cuánta sobretensión aparece y *cuán selectivo* es el
circuito. Un $Q$ alto es una campana angosta.

#ejercicio("Resonancia serie y sobretensión")[
  $L = 10$ mH, $C = 1 mu F$, $R = 40 Omega$ — el mismo circuito del Ejercicio 10.2,
  ahora visto en frecuencia. Se lo alimenta con $overline(V) = 10 angle 0 degree$ V, o
  sea 10 V *de pico*.

  *1. Frecuencia de resonancia.*
  $ f_0 = 1/(2 pi sqrt(10^(-2) dot 10^(-6))) = 1/(2 pi dot 10^(-4)) = 1592 "Hz" $

  *2. Factor de mérito.*
  $ Q = (omega_0 L)/R = (10^4 dot 10^(-2))/(40) = 2,5 $
  Que es, como debe ser, $1\/(2 zeta)$ con el $zeta = 0,2$ que había dado el Módulo 10.

  *3. En resonancia.* La impedancia es $overline(Z) = R = 40 Omega$ (las reactancias, ambas
  de 100 $Omega$, se cancelan). Entonces
  $ I = (10 "V")/(40 Omega) = 0,25 "A" $
  $ V_L = I dot X_L = 0,25 dot 100 = 25 "V" = Q dot V quad checkmark $
  Los tres valores están en pico: 10 V, 0,25 A y 25 V. En eficaz serían 7,07 V,
  0,177 A y 17,7 V. La relación $V_L \/ V = 2,5$ es la misma en las dos escalas, porque
  es un cociente — por eso el factor de mérito se puede leer sin preguntar en qué
  convenio está escrito el circuito.

  Sobre el inductor hay *dos veces y media* la tensión de la fuente. En un circuito de
  potencia con $Q = 50$ eso son 500 V donde la fuente pone 10, y es una causa real de
  destrucción de capacitores.

  *4. Ancho de banda.*
  $ "BW" = (f_0)/Q = (1592)/(2,5) = 637 "Hz" $
  El circuito deja pasar, con menos de 3 dB de atenuación, desde unos 1273 Hz hasta unos
  1910 Hz. Para sintonizar una emisora de AM harían falta $Q$ de varios cientos.
]

#tp("Con los TP N.º 4 y 5, y con el Módulo 3")[
  El TP N.º 4 define el valor eficaz y el TP N.º 5 manda medirlo con el multímetro en
  CA. El módulo del fasor de este módulo *no* es ese número: es la amplitud, que es lo
  que se lee en la pantalla del osciloscopio, y vale $sqrt(2)$ veces más. Los dos
  instrumentos miden bien la misma señal y dan números distintos, y esa es toda la
  razón por la que el convenio hay que declararlo antes de operar y no después. La
  tabla de conversión completa está al frente del apunte, en *Convenciones y notación*.

  Y el desfasaje que el osciloscopio muestra entre dos canales —la diferencia
  horizontal entre dos pasajes por cero, convertida a grados con
  $theta = 360 degree dot Delta t \/ T$— es el ángulo del fasor, medido a mano.

  Del lado del transformador (Módulo 3): la potencia aparente $S$ en VA es la que figura
  en la chapa del aparato, y no en watt, precisamente porque el fabricante no sabe qué
  factor de potencia va a tener la carga que le cuelguen. Un transformador de 100 VA
  entrega 100 W a una carga resistiva y solo 60 W a un motor con $cos phi = 0,6$, sin que
  nada esté fallando.
]
