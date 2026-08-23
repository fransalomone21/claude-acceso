#import "../plantilla.typ": *

#modulo("Mediciones y expansión de rango", [
  Interpretar una medición con su error, distinguir exactitud de precisión, calcular
  la tolerancia resultante de asociar componentes, y *diseñar* la resistencia shunt o
  multiplicadora necesaria para que un instrumento mida fuera de su rango original.
])

== Qué significa medir

Medir es comparar una magnitud con otra de la misma especie tomada como *patrón*.
El resultado nunca es un número solo: es un número, una unidad y una incertidumbre.
Escribir "la tensión es 9 V" es una frase incompleta; la frase completa es
"la tensión es $9,0 plus.minus 0,3$ V".

#definicion("Magnitud, unidad y patrón")[
  *Magnitud*: propiedad de un cuerpo o fenómeno que puede medirse (tensión, corriente,
  resistencia). *Unidad*: cantidad de esa magnitud tomada como referencia (volt, ampere,
  ohm). *Patrón*: la materialización física de la unidad, conservada y comparada
  periódicamente. En Argentina, el sistema legal es el *SIMELA* (Ley 19.511) y el
  organismo que conserva los patrones y otorga la trazabilidad es el *INTI*.
]

=== Magnitudes invariables y variables

Una magnitud es *invariable* (o de continua) cuando su valor no cambia con el tiempo:
la tensión de una pila, la corriente por una resistencia alimentada con continua. Es
*variable* cuando cambia instante a instante: la tensión de red, la señal de un
generador de audio.

Esta distinción no es teórica, decide el instrumento:

- Magnitud invariable $arrow.r$ multímetro en la sección de *CC*. Basta un número.
- Magnitud variable $arrow.r$ multímetro en *CA* (que devuelve un solo número, el
  valor eficaz) o bien *osciloscopio*, que muestra la forma de onda completa.

#atencion[
  Un multímetro en CA sobre una señal que no es senoidal *miente*, salvo que sea un
  modelo "True RMS". La mayoría de los testers de laboratorio miden el valor medio de
  la señal rectificada y lo multiplican por un factor fijo (1,11) que solo vale para
  la senoidal. Con una onda cuadrada o triangular, la lectura es incorrecta.
]

== El error de medición

Ninguna medición coincide con el valor verdadero $X_v$. La diferencia es el error.

#definicion("Error absoluto y error relativo")[
  $ E_a = X_m - X_v $
  $ epsilon_r = E_a / X_v arrow.r.double epsilon_r [%] = E_a / X_v dot 100 $
  El error absoluto tiene la unidad de la magnitud (volts, ohms). El relativo no tiene
  unidad y es el único que permite comparar mediciones de distinta escala: equivocarse
  en 1 V midiendo 3 V es un desastre; equivocarse en 1 V midiendo 220 V es irrelevante.
]

=== Tipos de error

- *Sistemáticos*: se repiten siempre en el mismo sentido. Instrumento descalibrado,
  efecto de carga, temperatura. Se corrigen calibrando o cambiando el método.
- *Aleatorios*: cambian de signo y magnitud en cada medición. Ruido, apreciación del
  observador. *No se corrigen: se promedian.* Repetir la medición $n$ veces y promediar
  reduce el error aleatorio, no el sistemático.
- *Groseros*: equivocarse de escala, leer mal, conectar mal. No se tratan
  estadísticamente, se descartan.

#clave[
  *Exactitud* es cuán cerca está la medición del valor verdadero. *Precisión* es cuán
  parecidas son las mediciones entre sí. Un instrumento puede ser muy preciso y muy
  inexacto: cinco disparos juntos, pero lejos del centro del blanco.
]

=== Resolución, rango, alcance y clase

#definicion("Los parámetros que definen a un instrumento")[
  *Rango*: el conjunto de valores entre los límites inferior y superior en los que el
  instrumento trabaja de forma confiable (por ejemplo, de 0 a 30 V).
  *Alcance*: la diferencia entre el valor máximo y el mínimo del rango. Si el mínimo es
  cero — el caso habitual — el alcance coincide con la mayor medida posible: 30 V.
  *Sensibilidad*: la mínima variación de la magnitud que el instrumento alcanza a
  detectar. *Resolución*: la fracción más pequeña que puede leerse con la exactitud que
  el instrumento posee (en un analógico, una división de la escala; en un digital, el
  último dígito). *Linealidad*: un instrumento es lineal si su sensibilidad se mantiene
  constante en todo el rango. *Clase*: el mayor error absoluto que comete el aparato en
  cualquier punto de su campo de medida, expresado en porcentaje *del alcance*, no de
  la lectura.
]

En la Argentina las clases están normalizadas por IRAM: 0,25 — 0,5 — 1 — 1,5 — 2 — 3.
La norma alemana VDE usa letras (E, F, G, H, Z), donde la clase Z equivale a 2,5 %.

El error por clase es la trampa más habitual del módulo. De la definición de clase,

$ C% = Delta_"MAX" / "Alcance" dot 100 quad arrow.r.double quad Delta_"MAX" = plus.minus (C% dot "Alcance") / 100 $ <ec-clase>

Como $E_c$ es constante para toda la escala pero la lectura no, *el error relativo
empeora cuanto más abajo se lee en la escala*. De ahí la regla de laboratorio: elegir
siempre la escala más chica en la que la aguja no se pase.

En un multímetro digital el fabricante especifica el error de otra forma, típicamente
$plus.minus(a% "de la lectura" + n "dígitos")$. El primer término escala con lo medido;
el segundo es fijo y vale una cuenta del último dígito mostrado.

#ejercicio("Error por clase de un voltímetro analógico")[
  Un voltímetro de *clase 2,5* está en la escala de *30 V* y la aguja marca *9,6 V*.
  ¿Entre qué valores está la tensión real?

  *1. Error por clase*, con la @ec-clase:
  $ Delta_"MAX" = plus.minus (2,5 dot 30 "V")/100 = plus.minus 0,75 "V" $

  *2. Intervalo de la medición*: $V = 9,6 plus.minus 0,75$ V, es decir, la tensión real
  está entre 8,85 V y 10,35 V.

  *3. Error relativo porcentual*:
  $ epsilon_r = (0,75)/(9,6) dot 100 = 7,8% $

  *Conclusión*: un instrumento "de 2,5%" arrastró un error de *7,8%* porque se leyó a
  menos de un tercio de la escala. Si el mismo instrumento se hubiera puesto en la
  escala de 10 V: $Delta_"MAX" = 0,25$ V y $epsilon_r = 2,6%$ — tres veces mejor, con el
  mismo aparato y la misma señal.
]

== Tolerancia de los componentes y su propagación

El fabricante no entrega el valor nominal sino un intervalo: un resistor de
$4700 Omega plus.minus 5%$ vale entre 4465 y 4935 $Omega$. La pregunta útil es qué pasa
con la tolerancia *al asociar componentes*.

=== Asociación serie

$R_T = R_1 + R_2$, y los errores absolutos se suman en el peor caso:
$ Delta R_T = Delta R_1 + Delta R_2 = epsilon_1 R_1 + epsilon_2 R_2 $
El error relativo del conjunto queda:
$ epsilon_T = (epsilon_1 R_1 + epsilon_2 R_2) / (R_1 + R_2) $ <ec-serie>

=== Asociación paralelo

Partiendo de $R_T = (R_1 R_2)/(R_1 + R_2)$ y derivando en forma logarítmica
($ln R_T = ln R_1 + ln R_2 - ln(R_1+R_2)$):

$ (Delta R_T)/R_T = (Delta R_1)/R_1 + (Delta R_2)/R_2 - (Delta R_1 + Delta R_2)/(R_1+R_2) $

Reemplazando $Delta R_i = epsilon_i R_i$ y agrupando:

$ epsilon_T = (epsilon_1 R_2 + epsilon_2 R_1) / (R_1 + R_2) $ <ec-paralelo>

#clave[
  Tanto la @ec-serie como la @ec-paralelo son *promedios ponderados* de $epsilon_1$ y
  $epsilon_2$. Consecuencia que hay que saber: *si los dos resistores tienen la misma
  tolerancia, el conjunto conserva exactamente esa tolerancia*. Asociar componentes del
  5% nunca da algo mejor que el 5% ni peor que el 5%. Lo que sí cambia es a cuál de los
  dos se le exige precisión: en serie manda el resistor grande, en paralelo el chico.
]

#ejercicio("Tolerancia de dos resistores en serie y en paralelo")[
  Se toman $R_1 = 4,7 "k"Omega plus.minus 5%$ y $R_2 = 1 "k"Omega plus.minus 5%$.

  *1. Errores absolutos individuales*:
  $ Delta R_1 = 0,05 dot 4700 = 235 Omega quad quad Delta R_2 = 0,05 dot 1000 = 50 Omega $

  *2. En serie*:
  $ R_T = 4700 + 1000 = 5700 Omega $
  $ Delta R_T = 235 + 50 = 285 Omega arrow.r.double epsilon_T = 285/5700 dot 100 = 5% $
  El conjunto vale entre 5415 y 5985 $Omega$.

  *3. En paralelo*:
  $ R_T = (4700 dot 1000)/(5700) = 824,6 Omega $
  Con la @ec-paralelo:
  $ epsilon_T = (0,05 dot 1000 + 0,05 dot 4700)/(5700) = 0,05 = 5% $
  $ Delta R_T = 0,05 dot 824,6 = 41,2 Omega $
  El conjunto vale entre 783,4 y 865,8 $Omega$.

  *Conclusión*: en ambos casos la tolerancia resultante es 5%, la misma de los
  componentes. Es el resultado que anticipa la caja anterior, ahora verificado con
  números.
]

== El multímetro y el efecto de carga

#circuito([Conexión correcta del voltímetro (paralelo) y del amperímetro (serie)])[
#fig-conexion-instrumentos()
]

El voltímetro se conecta *en paralelo* y por eso debe tener resistencia interna
*altísima* (idealmente infinita), para no derivar corriente. El amperímetro se conecta
*en serie*, abriendo el circuito, y por eso debe tener resistencia interna *bajísima*
(idealmente cero), para no alterar la corriente que pretende medir.

#atencion[
  Conectar un amperímetro en paralelo con la fuente es el error que quema instrumentos:
  su resistencia interna es casi cero, así que se produce un cortocircuito franco. Antes
  de tocar la llave de la fuente, verificar dos cosas: función seleccionada y *en qué
  borne está enchufada la punta roja*.
]

El *efecto de carga* es el error sistemático que introduce el propio instrumento: al
conectar un voltímetro de resistencia $R_V$ sobre una resistencia $R$, el circuito pasa
a ver el paralelo $R parallel R_V$, que es menor, y la tensión medida resulta *menor* que
la real. En instrumentos analógicos esto se cuantifica con la *sensibilidad* en
$Omega\/"V"$: un tester de 20 000 $Omega\/"V"$ en la escala de 10 V presenta
$20 000 dot 10 = 200 "k"Omega$.

== Expansión de rango

El instrumento de base es el *galvanómetro de D'Arsonval*, una bobina móvil que se
define por dos datos y nada más:

- $I_m$: la *corriente de deflexión a plena escala*, la que hace llegar la aguja al fondo.
- $R_m$: la *resistencia interna* de la bobina.

Como el movimiento es delicado, $I_m$ es del orden del miliampere. Para medir más de lo
que ese movimiento admite, se le agrega una resistencia. Dónde se agrega es lo que
decide si el aparato es un amperímetro o un voltímetro.

#atencion[
  Cuidado con la letra: en la notación de la cátedra $R_m$ (minúscula) es la resistencia
  *interna* del galvanómetro, y $R_M$ (mayúscula) es la *multiplicadora*. No son lo
  mismo y aparecen en la misma fórmula.
]

=== Amperímetro: resistencia shunt o de derivación

Se coloca *en paralelo* con el galvanómetro, para que la corriente sobrante se desvíe
por ella y al instrumento le llegue solo $I_m$.

#circuito([Expansión de rango de un amperímetro con resistencia de shunt])[
#fig-shunt()
#pie-figura[El galvanómetro tiene resistencia interna $R_m$ y se desvía a plena
  escala con $I_m$. El shunt deriva el resto: $I_S = I - I_m$.]
]

Al estar en paralelo, las caídas de tensión en ambas ramas son iguales:

$ V_(R_S) = V_(R_m) quad arrow.r.double quad I_S dot R_S = I_m dot R_m $ <ec-shunt-kvl>

Como interesa despejar la derivación, $R_S = (I_m dot R_m) \/ I_S$; y por la primera ley
de Kirchhoff la corriente total se reparte, $I_S = I - I_m$. Reemplazando:

$ R_S = (I_m dot R_m) / (I - I_m) $ <ec-shunt>

Si se define el *factor de multiplicación* $n = I \/ I_m$ — cuántas veces se agranda el
rango — la expresión queda en su forma más rápida de usar:

$ R_S = R_m / (n - 1) $ <ec-shunt-n>

=== Voltímetro: resistencia multiplicadora

Se coloca *en serie* con el galvanómetro, para que absorba la tensión sobrante y limite
la corriente a $I_m$.

#circuito([Expansión de rango de un voltímetro con resistencia multiplicadora])[
#fig-multiplicadora()
]

Al estar en serie, la tensión aplicada se reparte entre ambos, y por ambos circula la
misma corriente $I_m$:

$ V = V_(R_M) + V_(R_m) = I_m dot R_M + I_m dot R_m = I_m (R_M + R_m) $ <ec-mult-kvl>

Despejando la multiplicadora:

$ R_M = (V - I_m dot R_m) / I_m = V/I_m - R_m $ <ec-mult>

#clave[
  Las dos expansiones son duales y conviene memorizarlas juntas: la *shunt va en
  paralelo* y desvía corriente; la *multiplicadora va en serie* y absorbe tensión. Si
  alguna de las dos da negativa, el instrumento ya medía más de lo pedido y la expansión
  no tiene sentido: revisar el enunciado.
]

=== Voltímetro de rangos múltiples

Un voltímetro comercial no tiene una multiplicadora sino varias, seleccionadas por una
llave. Cada rango se calcula por separado con la @ec-mult, usando siempre la misma
$I_m$ y la misma $R_m$.

#circuito([Voltímetro multirrango: una multiplicadora por escala])[
#fig-multirrango()
]

#ejercicio("Shunt y multiplicadora del Anexo 1")[
  Un galvanómetro de $I_m = 1$ mA y $R_m = 100 Omega$ debe medir corriente hasta
  *100 mA*. Otro, de $I_m = 1$ mA y $R_m = 50 Omega$, debe medir tensión hasta *10 V*.

  *1. Shunt del amperímetro.* Factor de multiplicación:
  $ n = I/I_m = (100 "mA")/(1 "mA") = 100 $
  Con la @ec-shunt-n:
  $ R_S = R_m/(n-1) = (100 Omega)/(99) = 1,01 Omega $
  Verificación por el camino largo, con la @ec-shunt:
  $ R_S = (1 "mA" dot 100 Omega)/(100 "mA" - 1 "mA") = (0,1 "V")/(99 "mA") = 1,01 Omega $
  Los 99 mA sobrantes circulan por la shunt y solo 1 mA entra al galvanómetro.

  *2. Multiplicadora del voltímetro.* Con la @ec-mult:
  $ R_M = V/I_m - R_m = (10 "V")/(1 "mA") - 50 Omega = 10 000 - 50 = 9950 Omega $
  Sin multiplicadora, ese instrumento llegaba apenas a
  $V = I_m dot R_m = 1 "mA" dot 50 Omega = 50$ mV. Con los 9950 $Omega$ en serie llega a
  10 V: doscientas veces más.

  *Atención al valor de la shunt*: 1,01 $Omega$ no existe en la serie comercial E24, y su
  tolerancia domina el error total del amperímetro. En la práctica se construye con
  alambre calibrado, no con un resistor de carbón.
]

#ejercicio("Voltímetro de tres rangos")[
  Con un galvanómetro de $R_m = 100 Omega$ e $I_m = 1$ mA se quiere un voltímetro de tres
  escalas: 0–100 V, 0–500 V y 0–1000 V. Calcular las tres multiplicadoras.

  Se aplica la @ec-mult una vez por rango, sin cambiar $I_m$ ni $R_m$:
  $ R_(M(a)) = (100 "V")/(1 "mA") - 100 Omega = 100 000 - 100 = 99 900 Omega $
  $ R_(M(b)) = (500 "V")/(1 "mA") - 100 Omega = 500 000 - 100 = 499 900 Omega $
  $ R_(M(c)) = (1000 "V")/(1 "mA") - 100 Omega = 1 000 000 - 100 = 999 900 Omega $

  *Observación*: cuanto mayor el rango, más despreciable se vuelve $R_m$ frente a
  $V\/I_m$. En la escala de 1000 V, ignorar los 100 $Omega$ del galvanómetro
  introduciría un error del 0,01 %; en una escala de 1 V sería un disparate.
  La *sensibilidad* de este voltímetro es $1\/I_m = 1000 Omega\/"V"$ en todas sus
  escalas: es una característica del movimiento, no del rango.
]

#ejercicio("Resistencia de los cables de un sensor PT100")[
  Una PT100 (100 $Omega$ a 0 °C) se conecta con dos cables de cobre de 35 m de largo y
  1 mm² de sección. Coeficiente de resistividad del cobre:
  $rho = 1,75 dot 10^(-8) Omega dot "m"$.

  *1. Pasar la sección a unidades del SI*: $1 "mm"^2 = 1 dot 10^(-6) "m"^2$.

  *2. Resistencia de cada cable*:
  $ R_C = rho L/S = (1,75 dot 10^(-8) Omega dot "m" dot 35 "m")/(1 dot 10^(-6) "m"^2) = 0,6125 Omega $

  *3. Efecto sobre la medición*: los dos cables están en serie con el sensor, así que
  aportan $2 dot 0,6125 = 1,225 Omega$. Como la PT100 varía aproximadamente
  $0,385 Omega\/degree"C"$, ese 1,225 $Omega$ equivale a un error de
  $1,225 \/ 0,385 approx 3,2 degree"C"$ *de más*, permanente y en el mismo sentido:
  es un *error sistemático*.

  *Conclusión*: por eso los sensores resistivos industriales se conectan a 3 o 4 hilos.
  No es un capricho de instalación, es la única forma de cancelar la resistencia del
  cable.
]

#tp("TP N.º 0, 1, 2, 3 y Anexo 1 — I Cuatrimestre")[
  - *TP 0 (Introducción: mediciones)*: las preguntas del documental se responden con
    la sección 1.1. La autoridad de medidas en Argentina es el INTI, bajo el SIMELA.
  - *TP 1 (Errores)*: los puntos 1a–1d son exactamente el Ejercicio 1.2. El punto 2
    pide identificar resolución, rango, alcance y clase, y calcular el error por clase:
    sección 1.2.3 y Ejercicio 1.1. El punto 3 (medir con 5 personas y promediar) es la
    forma práctica de atacar el *error aleatorio*.
  - *TP 2 y TP 3 (multímetro, serie y paralelo)*: la última consigna de ambos —"¿cómo
    puedo saber de antemano qué diferencia máxima voy a encontrar?"— se contesta con
    la sección 1.3: sumando tolerancias, no midiendo.
  - *Anexo 1 (Expansión de rango)*: resuelto íntegramente en los Ejercicios 1.3 y 1.4.
]
