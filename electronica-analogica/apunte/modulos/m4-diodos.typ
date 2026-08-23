#import "../plantilla.typ": *

#modulo("Diodos semiconductores y rectificación", [
  Explicar por qué un diodo conduce en un sentido y no en el otro, usar el modelo
  adecuado para cada cálculo, dimensionar la resistencia de un LED, proteger un circuito
  contra inversión de polaridad, y analizar las tres topologías de rectificación sabiendo
  cuál conviene en cada caso y por qué.
])

== La juntura PN

El silicio puro tiene cuatro electrones en su última capa y forma una red cristalina
perfecta: no conduce. Todo cambia cuando se lo *dopa*, es decir, cuando se le agregan
impurezas controladas.

- *Material tipo N*: se agregan átomos con cinco electrones de valencia (fósforo,
  arsénico). Sobra un electrón por átomo. Los portadores mayoritarios son *electrones*
  (carga negativa).
- *Material tipo P*: se agregan átomos con tres electrones de valencia (boro, galio).
  Falta un electrón, y ese hueco se comporta como una carga positiva móvil. Los portadores
  mayoritarios son *huecos*.

#definicion("Juntura PN y barrera de potencial")[
  Al unir un cristal P con uno N, los electrones que sobran del lado N se difunden hacia
  el lado P y se recombinan con los huecos. En la frontera queda una *zona de
  agotamiento*, sin portadores libres, y una diferencia de potencial que se opone a que la
  difusión continúe: la *barrera de potencial*. Vale aproximadamente *0,7 V en silicio* y
  *0,3 V en germanio*.
]

=== Polarización

#circuito([Polarización directa e inversa del diodo])[
#fig-polarizacion-diodo()
#pie-figura[Con el $+$ de la fuente en el ánodo, la barrera se vence y la
  corriente circula con $V_D approx 0,7$ V. Con el $+$ en el cátodo, la barrera se
  ensancha y solo pasa la corriente de fuga.]
]

*Polarización directa*: el positivo de la fuente al ánodo (material P). El campo aplicado
se opone al de la barrera, la estrecha, y a partir de unos 0,7 V el diodo conduce con
facilidad. #text(fill: c-rojo)[Siempre hace falta una resistencia en serie que limite la
corriente]: el diodo no la limita solo.

*Polarización inversa*: el positivo al cátodo (material N). El campo aplicado refuerza la
barrera, la ensancha y no circula corriente, salvo una pequeñísima *corriente de fuga*
$I_R$ del orden de los microampere. Si la tensión inversa sigue creciendo, se llega a la
*tensión de ruptura* y el diodo se destruye (salvo que sea un zener, diseñado para
trabajar ahí).

=== Curva característica

#circuito([Curva característica del diodo])[
#graf-curva-diodo()
]

La curva no es una recta: el diodo *no es una resistencia*. La relación real la describe
la ecuación de Shockley,

$ I_D = I_S (e^(V_D \/ (eta V_T)) - 1) $ <ec-shockley>

que se cita como referencia pero *no se usa para calcular a mano*. Para eso están los
modelos simplificados.

== Modelos del diodo

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Modelo*], [*Qué supone*], [*Cuándo usarlo*]),
    [*Ideal* (llave)],
    [$V_D = 0$ al conducir; circuito abierto en inversa.],
    [Análisis rápido, tensiones altas (más de 20 V), primera aproximación.],
    [*Caída fija*],
    [$V_D = 0,7$ V constante al conducir (0,3 V si es germanio).],
    [El modelo de la materia. Casi siempre es el correcto.],
    [*Con resistencia dinámica*],
    [$V_D = 0,7 "V" + I_D dot r_d$, con $r_d$ de algunos ohms.],
    [Corrientes altas, o cuando importa la caída exacta.],
  ),
  caption: [Modelos del diodo, del más simple al más exacto],
)

#atencion[
  El error clásico es olvidar la caída de 0,7 V cuando la tensión de trabajo es chica. En
  un circuito de 24 V, ignorar 0,7 V es un error del 3 % y no cambia nada. En un circuito
  de 3 V, ignorarlo es un error del 23 % y arruina el cálculo. *El modelo se elige mirando
  la tensión del circuito.*
]

== El diodo LED

Un LED (#emph[Light Emitting Diode]) es un diodo que emite luz al recombinarse los
portadores. Funciona igual que cualquier diodo, con dos diferencias que importan:

- Su tensión directa $V_F$ *no es 0,7 V*: depende del color, porque depende de la energía
  del fotón emitido.
- Su tensión inversa máxima es baja (unos 5 V). Conectarlo al revés en un circuito de
  12 V lo destruye.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (center, center, center, center, center),
    table.header([*Color*], [Rojo], [Amarillo / Verde], [Azul / Blanco], [Infrarrojo]),
    [$V_F$ típica], [1,8 – 2,0 V], [2,0 – 2,2 V], [3,0 – 3,4 V], [1,2 – 1,4 V],
  ),
  caption: [Tensión directa típica de un LED según su color],
)

#circuito([LED con resistencia limitadora])[
#fig-led-limitadora()
]

La malla da $V_"cc" = I_F dot R + V_F$, y despejando la resistencia:

$ R = (V_"cc" - V_F) / I_F $ <ec-led>

#laboratorio[
  La corriente de trabajo de un LED indicador común es de *10 a 20 mA*, y *20 mA es el
  máximo*: por encima de eso se destruye. Si el LED debe solo verse, con 5 mA alcanza y
  dura más. Un LED sin resistencia en serie dura entre uno y dos segundos.
]

#ejercicio("LED con resistencia de 330 Ω")[
  Con una resistencia de 330 $Omega$ en serie con un LED rojo, ¿hasta qué tensión de
  alimentación se puede llegar antes de alcanzar los 20 mA? (Es el punto 2 del TP N.º 6.)

  *1. Datos*: $R = 330 Omega$, $I_F = 20$ mA, $V_F approx 2,0$ V (rojo).

  *2. Despejando $V_"cc"$ de la @ec-led*:
  $ V_"cc" = I_F dot R + V_F = 0,02 "A" dot 330 Omega + 2,0 "V" = 6,6 "V" + 2,0 "V" = 8,6 "V" $

  *3. Verificación con 5 V*, la alimentación más común:
  $ I_F = (5 "V" - 2,0 "V")/(330 Omega) = 9,1 "mA" $
  Perfectamente utilizable: el LED se ve bien y trabaja lejos del límite. Por eso 330
  $Omega$ es el valor "de fábrica" para LEDs en circuitos de 5 V.

  *4. Qué pasa al cambiar de color.* Con un LED azul ($V_F = 3,2$ V) alimentado con 5 V:
  $ I_F = (5 - 3,2)/330 = 5,5 "mA" $
  *Casi la mitad de corriente con la misma resistencia*, y por eso se ve más apagado de lo
  esperado. Conclusión del TP: la resistencia hay que recalcularla para cada color.
]

== El diodo como protección

=== Contra inversión de polaridad

#circuito([Dos formas de proteger contra polaridad invertida])[
#fig-proteccion-polaridad()
#pie-figura[La de la izquierda es más simple, pero pierde 0,7 V siempre. La de
  la derecha no pierde tensión: si se invierte la alimentación el diodo conduce,
  quema el fusible y salva el circuito.]
]

*En serie*: si la alimentación se conecta al revés, el diodo queda en inversa y no circula
corriente. Es la protección más simple, pero cuesta 0,7 V permanentes y toda la corriente
del circuito pasa por el diodo.

*En paralelo (crowbar)*: el diodo está al revés respecto de la alimentación correcta, así
que normalmente no conduce y no cuesta nada. Si se invierte la polaridad, el diodo conduce
a saco, provoca un cortocircuito controlado y *quema el fusible* antes de que el circuito
se dañe.

=== Diodo volante (flyback)

Toda bobina — un relé, un motor, un solenoide — almacena energía en su campo magnético. Al
cortar la corriente bruscamente, la @ec-faraday del Módulo 3 dice que aparece una tensión
inducida enorme, que puede llegar a cientos de volts y destruir el transistor que estaba
comandando. Un diodo en antiparalelo con la bobina le da a esa corriente un camino por
donde extinguirse. Se retoma en el Módulo 6.

== Rectificación

Rectificar es convertir una señal alterna, de valor medio cero, en una que tenga *un solo
signo* y por lo tanto valor medio distinto de cero. Es la segunda etapa de toda fuente
lineal.

=== Rectificador de media onda

#circuito([Rectificador de media onda])[
#fig-rectificador-media-onda()
#v(6pt)
#graf-media-onda()
]

Un solo diodo. Deja pasar el semiciclo positivo y bloquea el negativo. El valor medio de
la salida es el área de medio ciclo repartida en un período entero:

$ V_"cc" = V_p / pi = 0,318 dot V_p $ <ec-media-onda>

- Frecuencia del ripple: $f_r = f_"red" = 50$ Hz (un pulso por ciclo).
- Caída de diodos: *una* ($V_p' = V_p - 0,7$ V).
- Tensión inversa de pico (PIV) que soporta el diodo: $V_p$.

=== Rectificador de onda completa con punto medio

#circuito([Onda completa con transformador de punto medio])[
#fig-rectificador-punto-medio()
#v(6pt)
#graf-onda-completa()
]

Aprovecha la contrafase del punto medio: cuando A es positivo conduce D1, cuando B es
positivo conduce D2. La carga recibe siempre corriente en el mismo sentido.

$ V_"cc" = (2 V_p) / pi = 0,637 dot V_p $ <ec-onda-completa>

- Frecuencia del ripple: $f_r = 2 f_"red" = 100$ Hz. *El doble*, que es la gran ventaja.
- Caída de diodos: *una* por semiciclo.
- PIV: $2 V_p$. Es su desventaja — cada diodo ve la tensión de todo el secundario.
- Necesita transformador con punto medio, y $V_p$ es el de *media bobina*.

=== Puente de Graetz

#circuito([Puente rectificador de Graetz])[
#fig-puente-graetz()
#pie-figura[En el semiciclo positivo conducen $D_1$ y $D_4$; en el negativo,
  $D_3$ y $D_2$. En los dos casos la corriente atraviesa $R_L$ en el mismo sentido.]
]

Cuatro diodos, sin necesidad de punto medio. En cada semiciclo conducen dos diodos en
serie, en diagonal.

$ V_"cc" = (2 V_p) / pi = 0,637 dot V_p $

- Frecuencia del ripple: $f_r = 2 f_"red" = 100$ Hz.
- Caída de diodos: *dos* en serie ($V_p' = V_p - 1,4$ V). Es su desventaja.
- PIV: $V_p$. Cada diodo soporta la mitad que en la topología de punto medio.

=== Comparación

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([], [*Media onda*], [*Punto medio*], [*Puente*]),
    [Diodos],                 [1],        [2],        [4],
    [$V_"cc"$ (sin filtro)],  [$V_p\/pi$],[$2V_p\/pi$],[$2V_p\/pi$],
    [Frecuencia del ripple],  [50 Hz],    [100 Hz],   [100 Hz],
    [Caída total de diodos],  [0,7 V],    [0,7 V],    [1,4 V],
    [PIV por diodo],          [$V_p$],    [$2V_p$],   [$V_p$],
    [Transformador especial], [no],       [sí, con punto medio], [no],
  ),
  caption: [Las tres topologías de rectificación, comparadas],
)

#clave[
  *Por qué el puente es el que se usa casi siempre*: duplica la frecuencia del ripple
  respecto de la media onda, lo que permite un capacitor de filtro *la mitad de grande*
  para el mismo rizado (se demuestra en el Módulo 5); no necesita un transformador
  especial; y cada diodo soporta la mitad de tensión inversa que en la topología de punto
  medio. El precio son dos diodos más y 0,7 V extra de caída, que es barato.
]

#ejercicio("Rectificador de media onda con 12 V eficaces")[
  Entrada de $V_"in" = 12 V_"ef"$ y carga $R_L = 1$ k$Omega$. Calcular la tensión continua
  de salida, la corriente máxima por el diodo y la potencia disipada en la carga. (Es la
  parte 1 del TP N.º 7, cálculo teórico.)

  *1. Valor pico de la entrada*:
  $ V_p = V_"ef" dot sqrt(2) = 12 dot 1,4142 = 16,97 approx 17 "V" $

  *2. Valor pico real, descontando el diodo* (modelo de caída fija, un solo diodo):
  $ V_p' = 17 - 0,7 = 16,3 "V" $

  *3. Tensión continua de salida*, con la @ec-media-onda:
  $ V_"cc" = V_p'/pi = (16,3)/(3,1416) = 5,19 "V" $

  *4. Corriente máxima por el diodo*, que ocurre en el pico:
  $ I_(D "máx") = V_p'/R_L = (16,3 "V")/(1000 Omega) = 16,3 "mA" $
  Un 1N4007 admite 1 A: sobra con enorme margen.

  *5. Potencia en la carga.* Se calcula con el valor *eficaz*, no con el medio. Para una
  senoidal rectificada de media onda, $V_"ef(salida)" = V_p'\/2 = 8,15$ V:
  $ P = V_"ef"^2/R_L = (8,15)^2/1000 = 66 "mW" $

  *6. Verificación de la PIV.* En el semiciclo negativo el diodo soporta $V_p = 17$ V. El
  1N4007 aguanta 1000 V: correctísimo.

  *Conclusión*: de 12 V eficaces de entrada salen apenas *5,2 V de continua*, y con un
  rizado enorme. Sin capacitor de filtro, una fuente de media onda no sirve para nada.
]

== Lectura del datasheet: el 1N4007

El 1N4007 es el diodo rectificador de propósito general que se usa en todos los TPs.
Interpretar su hoja de datos es parte del punto 3 del TP N.º 6.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    table.header([*Parámetro*], [*Valor típico*], [*Qué significa*]),
    [$V_"RRM"$ — tensión inversa repetitiva máxima], [1000 V],
    [La máxima tensión inversa que puede soportar *ciclo tras ciclo*, indefinidamente. Es
     el número que hay que comparar con la PIV del circuito.],
    [$V_R$ — tensión inversa máxima (continua)], [1000 V],
    [Lo mismo, pero para tensión inversa constante. Define el margen de seguridad del
     diseño.],
    [$I_(F("AV"))$ — corriente directa media máxima], [1 A],
    [La corriente media que puede conducir en forma permanente sin superar su temperatura
     máxima. Superarla lo destruye por calor.],
    [$I_"FSM"$ — corriente de pico no repetitiva], [30 A],
    [Un único pico brevísimo (un semiciclo) que tolera sin romperse. *Es la que importa al
     encender una fuente*: el capacitor descargado se comporta como un cortocircuito.],
    [$V_F$ — tensión directa], [1,1 V @ 1 A],
    [La caída real al conducir. Crece con la corriente: los 0,7 V del modelo valen a
     corrientes chicas.],
    [$I_R$ — corriente inversa (fuga)], [5 µA],
    [Lo que se escapa estando bloqueado. Idealmente cero; crece mucho con la temperatura.],
    [$t_"rr"$ — tiempo de recuperación inversa], [decenas de µs],
    [Lo que tarda en dejar de conducir al invertirse la tensión. *El 1N4007 es lento*: a
     50 Hz no molesta, pero lo descarta para fuentes conmutadas o señales rápidas.],
    [$C_j$ — capacitancia de juntura], [≈ 15 pF],
    [La juntura en inversa se comporta como un capacitor. En alta frecuencia deja pasar
     señal aunque esté "cortado".],
  ),
  caption: [Características del diodo de propósito general 1N4007],
)

#atencion[
  $I_(F("AV")) = 1$ A *no* significa que el diodo pueda alimentar una carga de 1 A en una
  fuente con filtro capacitivo. Con capacitor, la corriente circula en pulsos angostos y
  altos, cuyo valor de pico es varias veces la corriente media entregada. Siempre conviene
  elegir el diodo con al menos el doble de margen.
]

#tp("TP N.º 6 — II Cuatrimestre")[
  - *Punto 1 (curva del diodo)*: al levantar la tabla punto a punto se ve en el laboratorio
    exactamente la curva de la sección 4.1. Hasta 0,5 V la corriente es casi nula; entre
    0,6 y 0,7 V se dispara. En inversa, el miliamperímetro no marca nada: la fuga es de
    microampere.
  - *Punto 2 (LED con 330 Ω)*: es el Ejercicio 4.1. Al repetirlo con otros colores se
    comprueba que $V_F$ cambia y la corriente también.
  - *Punto 3 (datasheet del 1N4007)*: la tabla de arriba, con las explicaciones que el TP
    pide redactar.
]
