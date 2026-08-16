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

#definicion("Los cuatro parámetros del instrumento")[
  *Resolución*: la mínima variación que el instrumento puede distinguir (en un
  analógico, el valor de una división; en un digital, el último dígito).
  *Rango*: el conjunto de valores que puede medir en la escala elegida (por ejemplo,
  0 a 30 V). *Alcance*: el valor máximo de esa escala (30 V), también llamado fondo de
  escala. *Clase*: el error máximo del instrumento expresado en porcentaje *del
  alcance*, no de la lectura.
]

El error por clase es la trampa más habitual del módulo:

$ E_c = "clase"[%] / 100 dot "alcance" $ <ec-clase>

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
  $ E_c = 2,5/100 dot 30 "V" = 0,75 "V" $

  *2. Intervalo de la medición*: $V = 9,6 plus.minus 0,75$ V, es decir, la tensión real
  está entre 8,85 V y 10,35 V.

  *3. Error relativo porcentual*:
  $ epsilon_r = 0,75/9,6 dot 100 = 7,8% $

  *Conclusión*: un instrumento "de 2,5%" arrastró un error de *7,8%* porque se leyó a
  menos de un tercio de la escala. Si el mismo instrumento se hubiera puesto en la
  escala de 10 V: $E_c = 0,25$ V y $epsilon_r = 2,6%$ — tres veces mejor, con el
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
```
        VOLTIMETRO                        AMPERIMETRO
     (en PARALELO con R)              (en SERIE, hay que ABRIR)

   ┌───────( V )───────┐                      ┌──( A )──┐
   │                   │                      │         │
   ├──────/\/\/\───────┤            ──────────┘  /\/\/\ └────────
   │         R         │                            R
   │                   │
   o                   o
```
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

Un instrumento de bobina móvil se define por dos datos: la corriente de plena escala
$I_g$ (la que hace llegar la aguja al fondo) y su resistencia interna $R_i$. Para medir
más de lo que ese movimiento admite, se le agrega una resistencia.

=== Amperímetro: resistencia shunt (derivadora)

Se coloca *en paralelo* con el instrumento, para que la corriente sobrante se desvíe
por ella.

#circuito([Expansión de rango de un amperímetro con shunt])[
```
                    Ig
             ┌────( G )────┐        G: instrumento, Ri
             │    Ri       │
   ──── It ──┤             ├──── It ────
             │             │
             └──/\/\/\/\───┘        Rsh: shunt
                  Rsh
                  Ish = It - Ig
```
]

Al estar en paralelo, ambas ramas tienen la misma tensión:
$ I_g dot R_i = I_"sh" dot R_"sh" $
y por la primera ley de Kirchhoff $I_"sh" = I_t - I_g$. Reemplazando:

$ R_"sh" = (I_g dot R_i) / (I_t - I_g) $ <ec-shunt>

Definiendo el *factor de multiplicación* $n = I_t \/ I_g$, la fórmula queda en su forma
más cómoda:

$ R_"sh" = R_i / (n - 1) $ <ec-shunt-n>

=== Voltímetro: resistencia multiplicadora

Se coloca *en serie* con el instrumento, para que absorba la tensión sobrante.

#circuito([Expansión de rango de un voltímetro con multiplicadora])[
```
        Rm                Ig
   o──/\/\/\/\──────────( G )──────o
   │                     Ri        │
   │<─────── V a medir ──────────> │
```
]

Recorriendo la malla con la segunda ley de Kirchhoff, y sabiendo que por ambos elementos
circula la misma $I_g$:
$ V = I_g dot R_m + I_g dot R_i $

$ R_m = V/I_g - R_i $ <ec-mult>

Con el factor $m = V \/ (I_g dot R_i)$, o sea la relación entre la tensión nueva y la que
el instrumento medía solo:

$ R_m = R_i (m - 1) $ <ec-mult-m>

#clave[
  Las dos expansiones son duales y conviene memorizarlas juntas: *shunt en paralelo y se
  divide* por $(n-1)$; *multiplicadora en serie y se multiplica* por $(m-1)$. Si el
  resultado da negativo, el instrumento ya medía más de lo pedido y la expansión no tiene
  sentido.
]

#ejercicio("Shunt y multiplicadora sobre el circuito del sensor PT100")[
  Un instrumento de $I_g = 1$ mA y $R_i = 100 Omega$ debe medir una corriente de hasta
  *100 mA*. Otro, de $I_g = 1$ mA y $R_i = 50 Omega$, debe medir hasta *10 V*.

  *1. Shunt del amperímetro.* Factor de multiplicación:
  $ n = I_t/I_g = (100 "mA")/(1 "mA") = 100 $
  Con la @ec-shunt-n:
  $ R_"sh" = R_i/(n-1) = (100 Omega)/(99) = 1,01 Omega $
  Verificación por el camino largo, con la @ec-shunt:
  $ R_"sh" = (1 "mA" dot 100 Omega)/(100 "mA" - 1 "mA") = (0,1 "V")/(99 "mA") = 1,01 Omega $
  Los 99 mA sobrantes circulan por la shunt y solo 1 mA entra al instrumento.

  *2. Multiplicadora del voltímetro.* Con la @ec-mult:
  $ R_m = V/I_g - R_i = (10 "V")/(1 "mA") - 50 Omega = 10 000 - 50 = 9950 Omega $
  Sin multiplicadora, ese instrumento llegaba a
  $V = I_g R_i = 1 "mA" dot 50 Omega = 50$ mV. Con los 9950 $Omega$ en serie llega a 10 V:
  un factor $m = 200$.

  *Atención al valor de la shunt*: 1,01 $Omega$ es una resistencia que no existe en la
  serie comercial E24 y cuya tolerancia domina el error total del amperímetro. En la
  práctica se construye con alambre calibrado, no con un resistor de carbón.
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
