#import "../plantilla.typ": *

#modulo("La hipérbola: escapar, y llegar con velocidad de sobra")[
  Cerrar la clasificación de las cónicas que el módulo 9 dejó abierta: la
  parábola y la hipérbola, que hasta ahora eran dos renglones de una tabla.
  Sacar de la geometría de la hipérbola el único número que la gravedad de
  un planeta le hace a una nave que pasa de largo —el ángulo de giro—, y de
  la energía el número que decide si un lanzador alcanza para una misión: la
  velocidad de sobra en el infinito, $v_oo$, y su cuadrado $C_3$. Y agregar
  las dos fórmulas que faltaban para despejar la anomalía verdadera y el
  ángulo de trayectoria de vuelo, que cuatro ejercicios de la guía piden como
  dato de salida.
]

Los módulos 6 a 11 resolvieron órbitas *cerradas*: la nave sale, da la vuelta
y vuelve al mismo punto. Toda la Parte III se apoyó en eso — el período tiene
sentido porque la órbita se repite, y la transferencia de Hohmann es media
elipse porque el otro medio existe. La tabla de cónicas del módulo 9 nombró
los otros dos casos, $e = 1$ y $e > 1$, y ahí los dejó: son las trayectorias
de las que no se vuelve.

Este módulo las desarrolla, y no por completitud. La hipérbola es *la* forma
de toda trayectoria que sale de un planeta o que llega a él: cuando una nave
se va de la Tierra rumbo a Marte, el tramo que recorre cerca de la Tierra es
una hipérbola, y el tramo que recorre cerca de Marte es otra. El módulo 17 va
a pegar esos tramos con la elipse de Hohmann del módulo 11; acá se construye
la pieza.

== La idea completa, antes de la primera ecuación

Todavía no hay ninguna cuenta hecha. Lo que sigue es qué hace falta para
entender una hipérbola, en el orden en que hace falta, para tener el plan en
la cabeza antes de la primera ecuación.

+ *Necesitás que la trayectoria llegue al infinito.* Eso, en la ecuación de
  la órbita, quiere decir que el denominador $1 + e cos nu$ se anule en algún
  ángulo — y eso sólo pasa si $e >= 1$. Ese ángulo tiene nombre: la anomalía
  verdadera de la asíntota.
+ *Necesitás que, además, le sobre velocidad al llegar.* Eso es energía, no
  geometría: pide $E > 0$, y la @m9-e-E del módulo 9 ya dijo que $E > 0$ es lo mismo que
  $e > 1$. Lo que sobra tiene nombre y es el número que se usa para todo:
  $v_oo$.
+ *De esas dos cosas sale todo el resto.* La forma —dos asíntotas y un
  vértice— sale de la primera; el precio en combustible sale de la segunda; y
  el efecto que el planeta produce sobre la nave —torcerle la velocidad un
  ángulo $delta$ y devolvérsela con el mismo módulo— sale de las dos juntas.

#posta[
  La posta de la hipérbola es que es la trayectoria de *la que no volvés*, y
  que encima llegás lejos con nafta en el tanque. La parábola es el caso
  justo: te vas, pero llegás al infinito frenando hasta cero — te alcanzó
  para salir y nada más. La hipérbola es cuando te sobró: salís del pozo
  gravitatorio y todavía te queda una velocidad, que es la que después vas a
  usar para viajar a otro lado. Esa sobra, $v_oo$, es *lo único* que le
  importa a una misión interplanetaria, porque es la velocidad con la que
  arrancás el viaje de verdad una vez que te olvidaste de la Tierra.

  Y hay una segunda cosa, que es la que sorprende: cuando pasás cerca de un
  planeta sin quedar atrapado, el planeta *no te cambia la rapidez*. Entrás
  con $v_oo$ y salís con $v_oo$, el mismo número. Lo único que te hace es
  *torcerte la dirección* un ángulo $delta$. Toda la gravedad del planeta,
  para una nave de paso, se resume en cuánto te dobla — nada más.
]

#clave[
  *El plan del módulo, en cuatro pasos:*
  + La parábola primero, porque es corta y es el borde: separa las
    trayectorias de las que se vuelve de las que no.
  + La geometría de la hipérbola: las asíntotas, el ángulo $delta$ que se
    tuerce la velocidad, y el semieje $a$ — que existe, pero no se mide
    desde el foco.
  + La energía: $v_oo$, $C_3$, y por qué una sola vis-viva sirve para las
    tres cónicas si se acepta que $a$ pueda ser negativo.
  + Las dos fórmulas que faltaban —$v_r$ y el ángulo $gamma$— que no son de
    la hipérbola sino de *cualquier* cónica, y que hacen falta acá porque el
    ejemplo a fondo no se puede plantear sin ellas.
]

== La parábola: el caso justo, y por qué no es una órbita

Con $e = 1$ la ecuación de la órbita del módulo 9 queda

$ r = h^2/mu 1/(1 + cos nu) $ <m16-parabola>

y el denominador se anula en $nu = 180°$, y *sólo* ahí: hay una única
dirección por la que la trayectoria se escapa al infinito (Curtis §2.8,
pág. 90). La energía sale de la @m9-e-E del módulo 9 con $e = 1$: $E = 0$ exacto. Y con
$E = 0$, la conservación de la energía dice, en cualquier punto,

$ 1/2 v^2 - mu/r = 0 quad ==> quad v = sqrt((2 mu)/r) = v_"esc" $ <m16-vesc>

que es exactamente la velocidad de escape del módulo 6. No es una
coincidencia ni un resultado nuevo: la velocidad de escape *se definió* como
la que deja $E = 0$, y la parábola *es* la trayectoria de $E = 0$. Las dos
frases dicen lo mismo con distinto vocabulario.

#cuidado[
  *La parábola no tiene semieje mayor, y por eso la vis-viva del módulo 9 (@m9-visviva) no se le
  aplica.* Es el error que el módulo 9 ya señaló en su ejemplo de Júpiter, y
  vuelve acá: escribir $E = -mu m \/ (2a)$ para una parábola obliga a
  $a arrow.r oo$, que no es un número con el que se pueda calcular. Para la
  parábola la única ecuación de energía es la @m16-vesc, con el cero
  adentro.

  *Y en la práctica ninguna trayectoria real es una parábola.* $e = 1$ exacto
  es un solo valor entre infinitos: cualquier error de un metro por segundo
  en el encendido deja $e = 0,9999$ (elipse gigante) o $e = 1,0001$
  (hipérbola). La parábola sirve como *frontera* —de un lado se vuelve, del
  otro no— y no como trayectoria de diseño.
]

== La geometría de la hipérbola

#fig([La hipérbola y todo lo que se le mide. El cuerpo central está en el
foco $F$ y la nave recorre la rama de la izquierda: entra desde el infinito
por una asíntota, dobla alrededor de $F$ pasando por el perigeo $P$, y se va
por la otra. La rama punteada de la derecha es la *imagen matemática* de la
ecuación —haría falta una gravedad que empujara en vez de atraer, así que no
la recorre nadie—, pero su vértice $A$ es lo que la fórmula del apogeo
devuelve, y por eso aparece. El centro $C$ es el punto medio entre $P$ y $A$:
el semieje $a$ se mide desde ahí, *no desde el foco*. El ángulo $beta$ es el
que las asíntotas forman con la línea de ábsides, $delta$ es lo que se tuerce
la velocidad de punta a punta, y $Delta$ —el radio de puntería— es la
distancia entre la asíntota de entrada y una paralela que pase por $F$: es la
puntería con la que hay que apuntar desde lejos.], fig-hiperbola-geometria)

Con $e > 1$ el denominador de la ecuación de la órbita se anula cuando
$cos nu = -1 \/ e$, que ahora *sí* tiene solución. Ese ángulo es la anomalía
verdadera de la asíntota (Curtis §2.9, ec. 2.97):

$ nu_oo = arccos(-1/e) $ <m16-nuinf>

y como $-1 \/ e$ está entre $-1$ y $0$, $nu_oo$ cae siempre entre $90°$ y
$180°$. La trayectoria física es el tramo $-nu_oo < nu < nu_oo$: fuera de ese
rango la fórmula devuelve $r < 0$, que es la rama vacía.

#geometria[
  *Tres cosas se miden desde tres lugares distintos, y mezclarlas es el error
  del tema.*
  - $r$, $r_p$ y la anomalía $nu$ se miden *desde el foco* $F$, igual que en
    la elipse.
  - $a$ y $b$ se miden *desde el centro* $C$, que en la hipérbola no está
    entre el foco y el perigeo sino *del otro lado del perigeo* — a distancia
    $a e$ del foco, en la dirección del perigeo. Por eso $r_p = a(e-1)$ y no
    $a(1-e)$.
  - $beta$, $delta$ y $Delta$ se miden *sobre las asíntotas*, que no pasan ni
    por $F$ ni por $P$.
]

*El semieje.* Como en la elipse, se define por la distancia entre los dos
vértices, sólo que uno de ellos está en la rama vacía. Evaluando la ecuación
de la órbita en $nu = 180°$ sale $r_a = p \/ (1 - e)$, que con $e > 1$ es
*negativo*: es la señal de que ese vértice quedó del otro lado del foco. La
distancia real de $P$ a $A$ es entonces $abs(r_a) + r_p = 2a$, y de ahí

$ 2a = p/(e - 1) - p/(1 + e) quad ==> quad a = p/(e^2 - 1) = h^2/mu 1/(e^2 - 1) $ <m16-a>

$ r_p = a (e - 1), quad quad r_a = a (e + 1), quad quad b = a sqrt(e^2 - 1) $ <m16-rp>

que es la misma familia de fórmulas de la elipse con $1 - e^2$ cambiado por
$e^2 - 1$ — el único cambio que hace falta para que las raíces existan
(Curtis §2.9, ecs. 2.103 a 2.106).

*El ángulo de giro.* Es el resultado que hace que este módulo valga: dice
cuánto le tuerce la velocidad el planeta a una nave que pasa de largo.

#deduccion("el ángulo que se tuerce la velocidad al pasar")[
  Las asíntotas son las rectas a las que la trayectoria tiende, así que la
  velocidad de entrada apunta a lo largo de una y la de salida a lo largo de
  la otra: el ángulo entre las dos asíntotas *es* lo que la velocidad giró.

  Cada asíntota forma con la línea de ábsides el ángulo agudo
  $beta = 180° - nu_oo$, así que $cos beta = -cos nu_oo = 1 \/ e$ por la
  @m16-nuinf. Mirando la figura, el ángulo entre las dos asíntotas del lado
  por donde pasa la nave es $delta = 180° - 2 beta$, y entonces
  $ sin(delta/2) = sin(90° - beta) = cos beta = 1/e $
]

$ delta = 2 arcsin(1/e) $ <m16-delta>

#clave[
  *Todo lo que un planeta le hace a una nave que pasa de largo entra en un
  solo número, y ese número depende sólo de $e$.* No de la masa del planeta
  por separado, no de la velocidad por separado: de la excentricidad de la
  hipérbola, que es lo que resume a las dos.

  Y el límite se lee de la fórmula sin hacer ninguna cuenta: cuando $e$ crece
  —una nave que pasa muy rápido o muy lejos—, $arcsin(1 \/ e)$ tiende a cero
  y el planeta casi no la desvía. Cuando $e arrow.r 1^+$ —el borde de quedar
  capturada—, $delta arrow.r 180°$: la nave se da vuelta entera y sale por
  donde vino. Ésa es la razón por la que las maniobras de *asistencia
  gravitatoria* buscan pasar cerca y despacio.
]

#definicion("radio de puntería")[
  El radio de puntería $Delta$ es la distancia entre la asíntota de entrada y
  la recta paralela a ella que pasa por el foco. Es la puntería con la que hay
  que tirar la nave *desde lejos*, cuando la gravedad del planeta todavía no
  se nota: si se apuntara en línea recta con esa desviación, la nave pasaría
  a distancia $Delta$ del centro. La gravedad después la curva hasta $r_p$,
  que es bastante menos.

  De la figura, $Delta = (r_p + a) sin beta = a e sin beta$, y como
  $sin beta = sqrt(e^2 - 1) \/ e$ queda
  $ Delta = a sqrt(e^2 - 1) $
  es decir, $Delta = b$: el radio de puntería es exactamente el semieje menor
  (Curtis §2.9, ec. 2.107).
]

== La energía: la velocidad que sobra, y $C_3$

Acá está la mitad que la geometría no da. La @m9-e-E del módulo 9 ya
relacionaba energía con excentricidad para *cualquier* cónica; sólo hay que
usarla con $e > 1$ y reemplazar $p$ por la @m16-a:

$ E = (mu m (e^2 - 1))/(2 p) = (mu m (e^2-1))/(2 a (e^2-1)) quad ==> quad E = + (mu m)/(2 a) $ <m16-energia>

*Es la misma fórmula de la elipse con el signo cambiado*, y el cambio de
signo no se eligió: viene de que $p = a(e^2-1)$ en vez de $a(1-e^2)$. La
energía de una hipérbola es positiva y no depende de $e$ — sólo de $a$,
igual que en la elipse.

#fig([Por qué a la hipérbola le sobra velocidad. Es el pozo de potencial del
módulo 6 con una sola recta de energía, la del caso $E > 0$. A cualquier
distancia $r$, la energía cinética es la distancia vertical entre la recta y
la curva: el tramo verde es lo que se gasta en salir del pozo —justo
$1/2 m v_"esc"^2$— y el rojo es lo que queda por encima del cero. A medida
que $r$ crece el tramo verde se achica y el rojo *no cambia*, porque la recta
de energía es horizontal. En el infinito el verde vale cero y sólo queda el
rojo: ésa es la energía cinética con la que la nave llega, y su velocidad es
$v_oo$.], fig-hiperbola-energia)

#deduccion("la velocidad de sobra en el infinito")[
  Se escribe la conservación de la energía por unidad de masa y se la evalúa
  en $r arrow.r oo$, donde el término potencial se anula:
  $ v^2/2 - mu/r = mu/(2a) quad ==> quad v_oo^2/2 - 0 = mu/(2a) $
  de donde $v_oo = sqrt(mu \/ a)$. Y volviendo a la misma ecuación en un $r$
  cualquiera, reemplazando $mu \/ (2a)$ por $v_oo^2 \/ 2$:
  $ v^2/2 - mu/r = v_oo^2/2 quad ==> quad v^2 = (2 mu)/r + v_oo^2 $
]

$ v_oo = sqrt(mu/a), quad quad v^2 = v_"esc"^2 + v_oo^2, quad quad C_3 = v_oo^2 $ <m16-vinf>

#posta[
  La del medio es la que hay que llevarse. Dice que las velocidades no se
  suman: se suman *los cuadrados*. Si estás a una distancia donde escapar te
  cuesta $10,9$ km/s y querés llegar al infinito con $3$ km/s de sobra, no
  necesitás $13,9$ km/s: necesitás la $v$ que cumple
  $v^2 = 10,9^2 + 3^2 = 127,8$, o sea $11,3$ km/s. Los $3$ km/s de sobra te
  salieron $0,4$ km/s.

  Y ésa es *toda* la razón por la que conviene acelerar bien abajo, pegado al
  planeta, en vez de escapar primero y acelerar después. Es el mismo efecto
  que el módulo 11 ya usaba sin nombrarlo cuando el encendido de Hohmann iba
  en el perigeo: la energía va con el cuadrado de la velocidad, así que un
  $Delta v$ dado rinde más cuanto más rápido ya vas.

  $C_3$ es simplemente $v_oo^2$ con otro nombre. Se usa así porque es lo que
  el catálogo de un lanzador publica: "este cohete pone $4$ toneladas con
  $C_3 = 10$ km²/s²". Para saber si un lanzador sirve para una misión se
  compara un número contra otro, sin cuentas de por medio —
  $C_3$ del lanzador $>= C_3$ de la misión— y listo.
]

#notacion[
  *Curtis escribe $a > 0$ para la hipérbola y le pone el signo a mano; otros
  libros —y todo software de astrodinámica— la escriben con $a < 0$.* Las dos
  convenciones dicen lo mismo. Si se acepta $a < 0$, la @m16-a se escribe
  $a = (h^2 \/ mu) \/ (1 - e^2)$ y la energía $E = -mu m \/ (2a)$: es decir,
  *exactamente* las mismas fórmulas de la elipse, sin ninguna excepción, y la
  vis-viva
  $ v^2 = mu (2/r - 1/a) $
  vale para las tres cónicas sin cambiar una letra (Curtis §2.9, pág. 99).

  Este apunte usa la convención de Curtis —$a > 0$ y las fórmulas con
  $e^2 - 1$— porque es la del libro que la cátedra pidió. *Pero conviene
  saber que la otra existe:* un semieje mayor negativo en un dato o en una
  salida de programa no es un error, es una hipérbola.
]

== Las dos fórmulas que faltaban: $v_r$ y el ángulo $gamma$

Nada de esta sección es propio de la hipérbola: vale para las cuatro cónicas.
Está acá porque el ejemplo a fondo de este módulo no se puede ni plantear sin
ella, y porque son las dos fórmulas que la Parte III dejó implícitas.

El módulo 7 partió la velocidad en sus dos componentes polares y definió el
*ángulo de trayectoria de vuelo* $gamma$ como el que la velocidad forma con
la perpendicular al radio, de modo que $h = r v cos gamma$. De ahí sale la
componente transversal sin ninguna cuenta nueva, $v_perp = h \/ r$. Lo que
falta es la radial.

#deduccion("la componente radial de la velocidad")[
  $v_r$ es $dif r \/ dif t$, y $r$ depende del tiempo sólo a través de $nu$:
  $ v_r = (dif r)/(dif nu) (dif nu)/(dif t) $
  El segundo factor es la conservación del momento angular del módulo 7,
  $dot(nu) = h \/ r^2$. El primero sale de derivar la ecuación de la órbita
  respecto de $nu$:
  $ (dif r)/(dif nu) = h^2/mu (e sin nu)/(1 + e cos nu)^2 $
  Multiplicando, y usando que $r^2 = (h^2 \/ mu)^2 \/ (1 + e cos nu)^2$, los
  dos denominadores cuadrados se cancelan contra el $r^2$ y queda
  $ v_r = h^2/mu (e sin nu)/(1 + e cos nu)^2 dot h/r^2 = mu/h e sin nu $
]

$ v_perp = h/r, quad quad v_r = mu/h e sin nu, quad quad tan gamma = v_r/v_perp $ <m16-vr>

#clave[
  *Estas tres, más la ecuación de la órbita, forman un sistema cerrado.* Con
  cinco incógnitas —$h$, $e$, $nu$, $v_r$, $v_perp$— y cinco ecuaciones, un
  problema queda determinado con sólo dos datos del tipo "en tal radio la
  velocidad vale tanto y apunta así". Es la *caja de herramientas* con la que
  Curtis resuelve todo el capítulo 2 (pág. 99), y es el planteo de los dos
  ejemplos de abajo.

  El truco de cálculo, en los dos, es el mismo: se arma $e sin nu$ de la
  segunda ecuación y $e cos nu$ de la ecuación de la órbita, se elevan al
  cuadrado, se suman —y $sin^2 + cos^2 = 1$ borra $nu$—, con lo que sale $e$
  sola. Recién con $e$ se vuelve a cualquiera de las dos y sale $nu$.
]

#cuidado[
  *El signo de $v_r$ dice en qué mitad de la órbita se está, y es lo que
  desambigua $nu$.* Al despejar $nu$ de un coseno quedan siempre dos ángulos,
  $nu$ y $360° - nu$. El criterio no es elegir el chico: es mirar el signo de
  $v_r$, que por la @m16-vr tiene el signo de $sin nu$.
  - $v_r > 0$ (equivalente a $gamma > 0$): la nave se está *alejando* del
    cuerpo central, va del perigeo al apogeo, y $nu$ está entre $0°$ y
    $180°$.
  - $v_r < 0$: se está *acercando*, y $nu$ está entre $180°$ y $360°$.

  En un ábside $v_r = 0$ y las dos componentes se reducen a una sola: por eso
  ahí, y sólo ahí, vale $h = r v$ sin coseno — el resultado del módulo 7.
]

#guia("los ejercicios adicionales 1, 2, 4 y 5 de gravitación")[
  Los cuatro piden la anomalía verdadera o el ángulo de trayectoria de vuelo
  *como dato de salida*, y hasta este módulo el apunte no tenía cómo
  despejarlos: estaban implícitos en $r = p \/ (1 + e cos nu)$ y en
  $h = r v cos gamma$, pero no había fórmula cerrada. La @m16-vr es esa
  fórmula, y con ella los cuatro salen con el mismo planteo de cinco
  ecuaciones.

  El *5* está resuelto abajo como ejemplo simple. El *2* es el mismo
  camino al revés (se conocen $r_p$ y $v_p$, o sea $h$ y $e$, y se pide
  $gamma$ en $nu = 120°$). El *1* y el *4* ni siquiera necesitan $v_r$:
  les alcanza con la ecuación de la órbita evaluada en dos puntos, que es el
  módulo 9 — el *1* pide además $v_r$ y $v_perp$ en el punto que encuentra,
  y eso sí es la @m16-vr.
]

#ejemplo("La órbita a partir de una sola medición de radar")[
  _(Ejercicio adicional 5 de gravitación.)_ Un satélite terrestre tiene una
  velocidad de $7,5$ km/s y un ángulo de trayectoria de vuelo de $10°$ cuando
  su radio es de $8000$ km. Calcular la anomalía verdadera y la excentricidad
  de la órbita. Dato: $mu_T = 398 thin 600$ km³/s².

  *Primero, qué cónica es.* Con la @m16-vesc, la velocidad de escape a esa
  distancia es
  $ v_"esc"^2 = (2 mu)/r = (2 dot 398 thin 600)/8000 = 99,65 " km"^2"/s"^2 quad ==> quad v_"esc" = 9,98 " km/s" $
  Como $7,5 < 9,98$, la trayectoria es *ligada*: hay que esperar $e < 1$.

  *Las dos componentes de la velocidad*, del ángulo de trayectoria de vuelo:
  $ v_perp = v cos gamma = 7,5 cos 10° = 7,386 " km/s", quad
    v_r = v sin gamma = 7,5 sin 10° = 1,302 " km/s" $
  y de la transversal sale el momento angular específico:
  $ h = r v_perp = 8000 dot 7,386 = 59 thin 089 " km"^2"/s" $

  *Las dos combinaciones.* De la @m16-vr,
  $ e sin nu = (h v_r)/mu = (59 thin 089 dot 1,302)/(398 thin 600) = 0,1931 $
  y de la ecuación de la órbita evaluada en este punto,
  $ 1 + e cos nu = h^2/(mu r) = (3,4915 times 10^9)/(398 thin 600 dot 8000) = 1,0949
    quad ==> quad e cos nu = 0,0949 $

  *Se elevan al cuadrado y se suman*, y $nu$ desaparece:
  $ e^2 = 0,1931^2 + 0,0949^2 = 0,04629 quad ==> quad e = 0,215 $
  y volviendo a cualquiera de las dos,
  $ tan nu = (0,1931)/(0,0949) = 2,034 quad ==> quad nu = 63,8° $

  Las dos combinaciones salieron positivas, así que $sin nu$ y $cos nu$ lo
  son: $nu$ está en el primer cuadrante, y el cuadro rojo de arriba lo
  confirma por el otro lado — $gamma = +10°$ quiere decir que el satélite se
  está alejando del perigeo.
]

#ejemplo("Una nave que se va: mostrar que es hipérbola y medirla entera", nivel: "a fondo")[
  _(Curtis, ejemplo 2.10, pág. 100.)_ En cierto punto de su trayectoria
  geocéntrica una nave tiene $r = 14 thin 600$ km, $v = 8,6$ km/s y
  $gamma = 50°$. Mostrar que la trayectoria es una hipérbola y calcular el
  momento angular, la excentricidad, la anomalía verdadera, el radio de
  perigeo, el semieje, $C_3$, el ángulo de giro y el radio de puntería.

  *Que es hipérbola se decide antes de calcular nada*, comparando con la
  velocidad de escape en ese radio:
  $ v_"esc"^2 = (2 dot 398 thin 600)/(14 thin 600) = 54,60 quad ==> quad v_"esc" = 7,389 " km/s" $
  Como $8,6 > 7,389$, sobra velocidad: $E > 0$ y la trayectoria es hiperbólica.

  *(a) Momento angular.* Igual que en el ejemplo anterior:
  $ v_perp = 8,6 cos 50° = 5,528 " km/s", quad v_r = 8,6 sin 50° = 6,588 " km/s" $
  $ h = 14 thin 600 dot 5,528 = 80 thin 709 " km"^2"/s" $

  *(b) Excentricidad.* Las dos combinaciones de siempre:
  $ e sin nu = (h v_r)/mu = (80 thin 709 dot 6,588)/(398 thin 600) = 1,3340 $
  $ 1 + e cos nu = h^2/(mu r) = (6,5139 times 10^9)/(398 thin 600 dot 14 thin 600) = 1,1193
    quad ==> quad e cos nu = 0,1193 $
  $ e^2 = 1,3340^2 + 0,1193^2 = 1,7937 quad ==> quad e = 1,339 $
  y como $e > 1$, queda confirmado por segunda vez y por otro camino que la
  trayectoria es una hipérbola.

  *(c) Anomalía verdadera.*
  $ tan nu = (1,3340)/(0,1193) = 11,18 quad ==> quad nu = 84,9° $
  Las dos combinaciones son positivas y $gamma > 0$: la nave ya pasó el
  perigeo y se está yendo.

  *(d) Radio de perigeo*, con la ecuación de la órbita en $nu = 0$:
  $ r_p = h^2/mu 1/(1 + e) = (16 thin 341)/(2,339) = 6986 " km" $
  que son unos $600$ km de altura: la nave está saliendo desde una órbita
  baja.

  *(e) Semieje*, con la @m16-a:
  $ a = h^2/mu 1/(e^2 - 1) = (16 thin 341)/(0,7937) = 20 thin 588 " km" $

  *(f) La energía característica*, con la @m16-vinf:
  $ v_oo^2 = v^2 - v_"esc"^2 = 8,6^2 - 7,389^2 = 73,96 - 54,60 = 19,36 " km"^2"/s"^2 $
  $ C_3 = 19,36 " km"^2"/s"^2 quad quad (v_oo = 4,40 " km/s") $

  *(g) Ángulo de giro*, con la @m16-delta:
  $ delta = 2 arcsin(1/(1,339)) = 2 dot 48,3° = 96,6° $

  *(h) Radio de puntería*, con la @m16-rp:
  $ Delta = a sqrt(e^2 - 1) = 20 thin 588 dot 0,8909 = 18 thin 341 " km" $

  #clave[
    *Los ocho resultados salieron de dos datos y ninguna ecuación nueva.*
    Todo el ejemplo son las cinco de la caja de herramientas más las de la
    geometría de este módulo. Y conviene mirar el orden en que se dieron: sin
    $h$ y $e$ no hay nada, y con $h$ y $e$ está todo — son los *dos*
    parámetros de los que depende una cónica, y cualquier otra cosa que se
    pida es una fórmula que los usa.
  ]
]

== Lo que esto ya permite: el enlace con Hohmann

El ejemplo de Marte del módulo 11 calculó la transferencia de Hohmann *como
si la Tierra no existiera*: la nave era un punto que orbitaba el Sol, y el
$Delta v_1$ que salió de la vis-viva era el salto entre la velocidad de la
Tierra alrededor del Sol y la del perihelio de la elipse de transferencia.
Con las herramientas de este módulo ya se puede ver qué le falta a esa
cuenta, aunque la justificación completa —por qué está permitido pegar los
dos problemas— sea el módulo 17.

Con los datos de aquel ejemplo, la velocidad de la Tierra y la que la nave
necesita en el perihelio de la transferencia son

$ v_T = sqrt(mu_"Sol"/r_T) = 29,78 " km/s", quad quad
  v_"perihelio" = sqrt(mu_"Sol" (2/r_T - 1/a_t)) = 32,73 " km/s" $

y la diferencia, $2,94$ km/s, es lo que el módulo 11 llamó $Delta v_1$. *Pero
ésa no es la velocidad que hay que darle a la nave*: es la velocidad con la
que la nave tiene que *terminar de salir* de la Tierra. Es decir, es $v_oo$.

Con eso, la hipérbola de escape desde una órbita de estacionamiento a $300$
km de altura ($r_p = 6678$ km) sale de la @m16-vinf:

$ v_"esc"^2 = (2 dot 398 thin 600)/6678 = 119,4 quad ==> quad v_"esc" = 10,93 " km/s" $

$ v_p^2 = v_"esc"^2 + v_oo^2 = 119,4 + 8,7 = 128,1 quad ==> quad v_p = 11,32 " km/s" $

y como en esa órbita de estacionamiento la nave ya viaja a
$v_"circ" = sqrt(mu_T \/ r_p) = 7,73$ km/s, el encendido real vale

$ Delta v = 11,32 - 7,73 = 3,59 " km/s" $

#clave[
  *El número del módulo 11 y el de acá no se parecen, y la diferencia no es
  un error de ninguno de los dos: son dos cosas distintas.* Los $2,94$ km/s
  son la velocidad de sobra *medida desde el Sol*, después de que la Tierra
  quedó atrás. Los $3,59$ km/s son lo que el motor tiene que dar *desde la
  órbita baja*, y son más porque incluyen salir del pozo de la Tierra.

  Que sean $3,59$ y no $2,94 + 10,93 - 7,73 = 6,14$ es la @m16-vinf
  trabajando: las velocidades se suman en cuadrado, no linealmente. Salir del
  pozo terrestre *y además* quedar con $2,94$ km/s de sobra cuesta apenas
  $0,39$ km/s más que salir justo. Todo el beneficio viene de encender abajo,
  donde la nave ya va rápido.
]

#posta[
  Traducido: el módulo 11 te dijo cuánto hay que cambiar la órbita *alrededor
  del Sol*, y este módulo te dice cuánto sale *escaparte de la Tierra dejando
  ese sobrante*. Son dos problemas encadenados, no dos versiones del mismo, y
  el número que los pega es $v_oo$: es la salida de uno y la entrada del
  otro.

  Lo que todavía falta —y es el módulo 17— es la licencia para hacer eso.
  Porque mientras la nave está cerca de la Tierra hay dos cuerpos tirando de
  ella, el Sol y la Tierra, y las cuentas de la Parte III suponen *uno*. La
  respuesta corta es que se dibuja una frontera alrededor de cada planeta
  —la esfera de influencia—, adentro se resuelve un problema de dos cuerpos
  con el planeta y afuera otro con el Sol, y se pegan los dos en la frontera.
  Eso son las órbitas parcheadas.
]

== Lo que se usa después

1. *$v_oo$ y $C_3$.* Son la moneda de cambio entre el problema planetario y
   el interplanetario: todo el módulo 17 consiste en calcular $v_oo$ de un
   lado y usarlo del otro. Y $C_3$ es lo que se compara contra el catálogo de
   un lanzador para saber si una misión es lanzable.

2. *El ángulo de giro $delta$.* Es el resultado que hace posible la
   *asistencia gravitatoria*: una nave que pasa cerca de un planeta sale con
   la misma rapidez respecto del planeta pero con otra dirección, y eso, visto
   desde el Sol, cambia su velocidad heliocéntrica sin gastar combustible.

3. *El radio de puntería $Delta$.* Es lo que se controla de verdad en una
   maniobra de corrección a mitad de camino: no se apunta al perigeo, se
   apunta a $Delta$, que es la cantidad que se mide desde lejos.

4. *La caja de herramientas —$h$, $e$, $nu$, $v_r$, $v_perp$— y su truco de
   cálculo.* Es el planteo estándar de cualquier problema de órbitas que no
   involucre el tiempo, y resuelve, además de los dos ejemplos de acá, cuatro
   ejercicios adicionales de la guía.
