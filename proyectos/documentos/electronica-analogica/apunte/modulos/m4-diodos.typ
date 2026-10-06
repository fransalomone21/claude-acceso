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

=== Levantar la curva en el laboratorio

El punto 1 del TP N.º 6 pide construir esa curva midiendo, no dibujándola. El circuito
es la fuente variable $V_S$, una resistencia $R$ en serie que limita la corriente, el
amperímetro que mide $I_T$ y el voltímetro sobre el diodo, que mide $V_D$. La consigna
hace variar $V_S$ de 0 a 1,2 V de a 0,1 V y anotar las tres columnas.

#laboratorio[
  *La resistencia serie no está en la consigna y hay que elegirla.* Con $R = 100 Omega$,
  el último renglón de la tabla ($V_S = 1,2$ V) cae justo en $I_T approx 5$ mA y
  $V_D approx 0,70$ V: la tabla barre el codo entero sin acercarse al límite del diodo.
  Con $R$ mucho más chica, los últimos renglones se van de escala; con $R$ mucho más
  grande, la curva se aplana y el codo no se ve.
]

La tabla que sigue es lo que *debería* salir con $R = 100 Omega$ y un diodo de silicio,
calculada con la @ec-shockley tomando $eta = 2$ y $I_S$ ajustada para que dé 5 mA a
0,70 V. Los valores exactos cambian de un diodo a otro; lo que tiene que reproducirse es
*la forma*: tres décimas de nada, y después todo junto.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    table.header([$V_S$ [V]], [$I_T$ [mA]], [$V_R$ [V]], [$V_D$ [V]]),
    [0],   [0],        [0],     [0],
    [0,1], [≈ 0],      [≈ 0],   [0,10],
    [0,2], [≈ 0],      [≈ 0],   [0,20],
    [0,3], [0,002],    [0,000], [0,30],
    [0,4], [0,015],    [0,002], [0,40],
    [0,5], [0,09],     [0,009], [0,49],
    [0,6], [0,36],     [0,036], [0,56],
    [0,7], [0,88],     [0,088], [0,61],
    [0,8], [1,6],      [0,16],  [0,64],
    [0,9], [2,4],      [0,24],  [0,66],
    [1,0], [3,2],      [0,32],  [0,68],
    [1,1], [4,1],      [0,41],  [0,69],
    [1,2], [5,0],      [0,50],  [0,70],
  ),
  caption: [Valores esperados del punto 1 del TP N.º 6, con $R = 100 Omega$],
) <tab-curva-tp6>

#clave[
  Mirando las dos últimas columnas se ve el reparto: hasta $V_S = 0,4$ V *toda* la
  tensión de la fuente cae en el diodo y la resistencia no ve nada, porque no circula
  corriente. Pasado el codo se invierte: de 0,7 V en adelante el diodo se queda clavado
  en unas siete décimas y *todo el excedente se lo come $R$*. Eso es lo que significa
  «el diodo no es una resistencia», leído en una tabla de laboratorio.
]

#atencion[
  *En inversa el amperímetro va a marcar cero, y esa es la medición.* La corriente de
  fuga del 1N4007 es de unos 5 µA: un multímetro en su rango de miliampere tiene una
  resolución de 0,01 mA = 10 µA, así que no puede distinguirla de cero. No es un error
  de conexión ni un instrumento roto — es la resolución del instrumento, la sección «Resolución, rango, alcance y clase» del Módulo 1.
  La conclusión que el TP pide es justamente ésa: *la rama inversa no se puede medir con
  el instrumental del banco*, y se la dibuja sobre el eje.
]

*Las dos ramas no entran en la misma escala, y ése es el resultado.* La rama directa va
de 0 a 5 mA en 0,7 V; la inversa, de 0 a unos pocos microampere en decenas de volts. Son
tres órdenes de magnitud en corriente y dos en tensión. En la hoja milimetrada se dibujan
con *escalas distintas en cada cuadrante* —es lo que hace la figura de la consigna, y por
eso su eje negativo parece vacío—, y se aclara al pie cuál se usó en cada uno. Un solo par
de escalas para los cuatro cuadrantes deja la curva inversa pegada al eje y la directa
aplastada contra el margen.

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
    [PIV por diodo (sin filtro)], [$V_p$], [$2V_p$],  [$V_p$],
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

=== Caídas y corrientes en el esquemático: de dónde sale cada PIV

La tabla de arriba da la PIV como un dato, y un dato se olvida. Conviene saber
*deducirla*, y sobre todo contestar la objeción que la tabla no contesta: *si el
transformador tiene punto medio, ¿por qué cada diodo aguanta la bobina entera?* Eso se
resuelve leyendo el esquemático con método, que es lo que sigue.

*Cómo se lee un diodo.* La flecha del símbolo va del ánodo al cátodo y marca el único
sentido en que puede circular la corriente. La tensión del diodo, $v_D$, se mide *siempre
de ánodo a cátodo*: positiva y de unos $0,7$ V cuando conduce, negativa cuando está
cortado. La PIV es el valor más negativo que alcanza $v_D$ en todo el ciclo, dicho sin el
signo. Un diodo cortado no cae cero volts ni cae un valor fijo de fábrica: *cae lo que el
resto del circuito le deje*, y eso hay que calcularlo.

*El método, que vale para cualquier rectificador:*

+ Se decide quién conduce: el diodo cuyo ánodo está más positivo que su cátodo, por lo
  menos $0,7$ V.
+ Cada diodo que conduce se reemplaza por una caída de $0,7$ V (modelo de caída fija).
+ Con eso quedan determinados los potenciales de todos los nodos, medidos contra una
  referencia: en el punto medio, contra $M$.
+ La tensión de un diodo cortado es la diferencia de potencial entre sus dos extremos. Se
  la calcula recorriendo *cualquier* camino que los una y sumando las caídas (malla de
  Kirchhoff). Si dos caminos dan distinto, hay un error en algún potencial.

*Media onda.* En el pico positivo el diodo conduce, $v_D approx +0,7$ V, y el resto de la
fuente cae en $R_L$. En el pico negativo el diodo está cortado, así que *no circula
corriente*; sin corriente, la resistencia no cae nada ($v_R = i R_L = 0$), y la malla
$v_e = v_D + v_R$ da $v_D = v_e = -V_p$. La fuente entera queda sobre el diodo porque la
resistencia, sin corriente, no se queda con nada. De ahí sale $"PIV" = V_p$.

*Punto medio.* Acá viene la objeción: «el punto medio parte la bobina en dos, entonces
cada diodo debería ver sólo una mitad». Se lo resuelve con el método, en el pico en que
$A$ es positivo (la figura de abajo lo dibuja).

Con $V_p$ el pico de *media* bobina, los potenciales contra $M$ son $v_A = +V_p$ y
$v_B = -V_p$; la bobina entera, de $A$ a $B$, vale $2 V_p$. $D_1$ conduce, así que el
cátodo común queda en $v_K = v_A - 0,7 = V_p - 0,7$. $D_2$ tiene el ánodo en $B$ y el
cátodo en $K$:

$ v_(D 2) = v_B - v_K = -V_p - (V_p - 0,7) = -(2 V_p - 0,7) approx -2 V_p $

#circuito([Punto medio en el pico del semiciclo en que A es positivo: la tensión que
  soporta el diodo cortado])[
#fig-piv-punto-medio()
#pie-figura[Potenciales medidos contra $M$, con diodos ideales para no ensuciar los
  números (con $0,7$ V de caída en $D_1$, $K$ queda $0,7$ V más abajo y la cota, $0,7$ V
  más chica). La corriente $i$ sale de $A$, pasa por $D_1$ y por $R_L$, y vuelve al
  bobinado por $M$ sin tocar $D_2$. La cota roja es lo que soporta $D_2$.]
]

El mismo número sale por el otro camino, el que va de $K$ a $B$ pasando por $D_1$ y la
bobina entera: $D_1$ conduce y se comporta como un cable (menos sus $0,7$ V), así que el
cátodo de $D_2$ está *colgado del extremo $A$*, y entre $A$ y $B$ está la bobina completa,
$2 V_p$. Los dos recorridos coinciden, que es la prueba de que los potenciales están bien.

#clave[
  *El punto medio es un nodo, no un escudo.* Es el retorno de la carga, y la carga no
  está en el lazo de $D_2$: ese lazo es $B arrow.r D_2 arrow.r K arrow.r D_1 arrow.r A
  arrow.r$ bobina entera $arrow.r B$, y $M$ no figura en él. Lo que lo distingue de la
  media onda es el cátodo: allí el diodo cortado tiene el cátodo en $0$ (la resistencia
  sin corriente lo deja en masa), y acá el cátodo de $D_2$ lo *sostiene en $+V_p$ el
  otro diodo*, mientras el ánodo baja a $-V_p$. Las dos tensiones se suman sobre $D_2$.
]

*Con números.* Un transformador de $12 V_"ef"$ en cada media bobina tiene
$V_p = 12 dot sqrt(2) approx 17$ V. Contra $M$: $v_A = +17$ V, $v_B = -17$ V,
$v_K = 17 - 0,7 = 16,3$ V. Entonces $v_(D 2) = -17 - 16,3 = -33,3$ V. Por la bobina
entera, que son $24 V_"ef"$ y tiene un pico de $34$ V: $-34 + 0,7 = -33,3$ V. Coinciden.
Un 1N4007, que aguanta $1000$ V, ni se entera.

*Puente.* Mismo método, misma conclusión. En el pico en que $A$ es positivo conducen $D_1$
y $D_4$, en serie con la carga, y los otros dos quedan cortados. Cada diodo cortado tiene
un extremo pegado a un extremo de la bobina, y el otro atado al otro extremo de la bobina
a través de un diodo que conduce: cae *la bobina entera menos los $0,7$ V de un diodo que
conduce*, $v_D = -(V_p - 0,7) approx -V_p$. La regla es la
misma en las tres topologías: *el diodo cortado ve toda la fuente que tiene en serie*. En
el punto medio esa fuente es la bobina entera, de $2 V_p$; en el puente, también la bobina
entera, pero para entregar el mismo pico $V_p$ a la carga alcanza con una bobina de
$V_p$. Por eso el puente le pide la mitad al diodo: no es magia del puente, es que el punto
medio necesita el doble de bobina y la mitad de ella queda sin trabajar en cada semiciclo.

*Corrientes.* La carga recibe un valor medio $I_"cc" = V_"cc"\/R_L$. En la media onda lo
lleva un solo diodo, y lo lleva *todo*: $I_(D"medio") = I_"cc"$. En el punto medio y en el
puente la carga recibe corriente en los dos semiciclos, pero cada diodo conduce sólo en
uno de ellos, y las dos ramas se turnan: $I_(D"medio") = I_"cc"\/2$. El *pico* no se
reparte: en el máximo, el diodo que conduce lleva la corriente de la carga entera,
$I_(D"pico") = V_p'\/R_L$ (sin filtro). En el esquemático, la corriente siempre cierra
una malla completa: sale de la fuente, atraviesa el diodo que conduce y la carga, y vuelve
a la fuente —por $M$ en el punto medio, por el otro diodo de la diagonal en el puente—.
Si alguna flecha no vuelve a donde salió, el dibujo está mal.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([], [*Media onda*], [*Punto medio*], [*Puente*]),
    [Diodos que conducen a la vez],     [1],          [1],                       [2, en serie],
    [Tensión del que conduce],          [$+0,7$ V],   [$+0,7$ V],                [$+0,7$ V cada uno],
    [Tensión del cortado (PIV)],        [$-V_p$],     [$-(2 V_p - 0,7)$ V],      [$-(V_p - 0,7)$ V],
    [Corriente media por diodo],        [$I_"cc"$],   [$I_"cc"\/2$],             [$I_"cc"\/2$],
    [Corriente de pico por diodo],      [$V_p'\/R_L$],[$V_p'\/R_L$],             [$V_p'\/R_L$],
  ),
  caption: [Qué le pasa a cada diodo, sin capacitor de filtro. $V_p$ es el pico que cada
    topología entrega a la carga (media bobina en el punto medio)],
)

#atencion[
  *Con capacitor de filtro, la PIV de la media onda se duplica.* El capacitor queda cargado
  cerca de $V_p$ y mantiene el cátodo alto; cuando la fuente llega a $-V_p$, el diodo ya no
  tiene el cátodo en masa sino en $V_p - 0,7$, y $v_D = -V_p - (V_p - 0,7) approx -2 V_p$.
  Es la misma situación del punto medio, por la misma razón: *el cátodo no está libre*. Y una
  fuente de media onda sin filtro no sirve para nada fuera del libro, así que la PIV que hay
  que comparar con el $V_"RRM"$ del datasheet es la del circuito real, con su capacitor y con
  margen. El punto medio queda igual ($2 V_p$) y el puente también ($V_p$), porque el diodo
  que conduce lo ata a la bobina con o sin capacitor.
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
  1N4007 aguanta 1000 V: correctísimo. (Así, sin capacitor; con uno de filtro serían
  $approx 33$ V, y el 1N4007 sigue sobrado.)

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
  - *Punto 1 (curva del diodo)*: la sección «Levantar la curva en el laboratorio» tiene
    la tabla de valores esperados con $R = 100 Ω$, por qué el amperímetro marca cero en
    inversa —y por qué eso *es* la medición—, y por qué las dos ramas no entran en la
    misma escala de la hoja milimetrada. La conclusión que el TP pide sale de ahí.
  - *Punto 2 (LED con 330 Ω)*: es el Ejercicio 4.1. Al repetirlo con otros colores se
    comprueba que $V_F$ cambia y la corriente también.
  - *Punto 3 (datasheet del 1N4007)*: la tabla de arriba trae los ocho parámetros que la
    consigna lista —$V_(R R M)$, $V_R$, $I_F$, $I_(F S M)$, $V_F$, $I_R$, $t_"rr"$ y
    $C_j$— con la explicación de cada uno, que es lo que el TP pide redactar.
]
