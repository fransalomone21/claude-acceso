#import "../plantilla.typ": *
#import "../biblioteca/figuras-cmg.typ": fig-cmg-3d, fig-cmg-analogia, fig-cmg-silla, fig-cmg-piramide
#import "../biblioteca/figuras-omega.typ": fig-omega-rueda-completa, fig-omega-cmg-dos-completa
// voz: 2026-11-05 -- escrito con la voz de la regla propia 8 (CLAUDE.md), fase 18
// cada letra, presentada en palabras donde aparece primero: lo mide practica/verificar-simbolos.py (OBLIGADOS)

#modulo("El cuerpo que cambia de forma, y la actitud que se controla desde adentro", clave: "actitud")[
  Hasta acá el rígido era rígido: su momento de inercia no cambiaba nunca, y
  todo lo que le pasaba lo ponía una cupla de afuera. Este módulo afloja las dos
  cosas. Primero, una nave que estira dos brazos con masa en la punta y quiere
  seguir girando igual: alguien tiene que pagar la diferencia. Después, una
  nave que se gira a sí misma con una rueda que lleva adentro, sin que nada la
  toque. Son los dos ejercicios adicionales de cuerpo rígido de la guía (5), y
  de paso, el yo-yo que frena satélites, la saturación y el reparto de tareas
  entre ruedas, CMG y propulsores.
]

*La idea, antes de la primera cuenta.* El módulo #M("rotacion") dejó una ley
que parecía de patinadora y nada más: si nadie te tuerce, tu momento angular
es tuyo para siempre, y lo único que podés hacer es repartirlo distinto. Este
módulo es esa ley trabajando para un ingeniero, en sus dos versiones:

+ *Si cambia la forma y la velocidad angular tiene que quedar igual*, el
  momento angular cambia, y ese cambio no sale de la nada: lo paga una cupla
  de afuera. En el Adicional 1 la pagan dos propulsores; si nadie la pagara, la
  nave se frenaría sola, como la patinadora que abre los brazos. Y ese frenarse
  solo, usado a propósito, es el *yo-yo*.
+ *Si la cupla es interna* —un motor entre la nave y una rueda que lleva
  adentro—, el momento angular total no se mueve de donde estaba. Lo que la
  rueda gana para un lado, la nave lo gana para el otro. Así se apunta un
  satélite sin gastar combustible: es el Adicional 2, la *rueda de reacción*.

Las dos caben en una sola línea del módulo #M("rotacion"): «el momento angular
total cambia sólo por cuplas externas». La primera es la cupla externa que
hace falta poner; la segunda, la interna que no cambia nada del total y lo
cambia todo adentro. Y como la cátedra pide que esto se entienda dibujado antes
que escrito, cada paso tiene su figura.

#lectura[
  *Curtis, capítulo 12* («Spacecraft attitude dynamics»): §12.8 para el yo-yo
  (págs. 666–672, con el ejemplo 12.9) y §12.9 para las ruedas, los CMG y la
  saturación (el ejemplo 12.10 de la pág. 675–676 es el Adicional 2 con otras
  letras; la saturación, en la pág. 682). Es el libro que conviene abrir para
  todo lo de este módulo que tenga un satélite adentro. Para el CMG por
  dentro, los tres papers que pasó la cátedra: Chubb y Seltzer (NASA TN
  D-6068, 1971) para el Skylab, Lappas, Steyn y Underwood (_Acta
  Astronautica_, 2002) para el dimensionamiento, y Wrigley y Hollister
  (_Science_, 1965) para el giróscopo que mide.

  Para la física de base alcanza con lo que ya está: la conservación del
  momento angular del Sears (§10.6, la del módulo #M("rotacion")) y la
  aceleración de Coriolis del Beer (§15.11, la del módulo
  #M("cinematica-cr")). Los dos adicionales están en la guía (5) de la cátedra,
  págs. 23–24; la figura de la nave con brazos tiene el estilo del Meriam, pero
  no está en los recortes del disco, así que no se le pone página.
]

== Masa que se aleja con la velocidad angular fija: el Adicional 1

#block(breakable: false)[#guia("Adicional 1 de cuerpo rígido — los brazos telescópicos")[
  Una nave gira alrededor de su eje $z$ a $omega_0 = 1,25$ rad/s, y la quieren
  mantener así mientras estira dos brazos telescópicos desde $r_1 = 1,2$ m
  hasta $r_2 = 4,5$ m, a velocidad constante, en 2 minutos. En la punta de cada
  brazo hay un módulo de 10 kg, que se trata como partícula; los brazos no
  pesan. Para que $omega_0$ no cambie, se encienden dos propulsores chicos de
  empuje variable. ¿Qué empuje $T$ tiene que dar cada uno, en función del
  tiempo?
  // simbolos: omega_0, r_1, r_2, T
]]

Antes de tocar una ecuación, las letras y lo que significan. $omega_0$ es la
velocidad angular de la nave alrededor de $z$, la que no tiene que cambiar.
$r_1$ y $r_2$ son las distancias de cada módulo al eje al principio y al
final. $T$ es el *empuje* de cada propulsor: una fuerza, en newtons, que la
guía escribe con la misma letra que en otros problemas es un período o un
intervalo de tiempo. Acá es una fuerza y nada más.

#fig([Los brazos telescópicos, vistos desde arriba ($z$ sale de la hoja).
En gris, los módulos donde arrancan, a $r_1$ del eje; en negro, en un instante
cualquiera, a $r(t)$; con trazo cortado, donde terminan, a $r_2$. Cada brazo se
estira a $dot(r)$ constante mientras la nave sigue girando a $omega_0$.
Redibujada desde arriba de la figura del Adicional 1 de la guía (5) de la
cátedra, que la trae en perspectiva.], fig-act-brazos)
<fig-act-brazos>
// simbolos: r, rdot

La posición de cada módulo es $r(t)$, su distancia al eje en el instante $t$,
y $dot(r) = d r \/ d t$ es lo rápido que se estira el brazo. «A velocidad
constante» quiere decir que $dot(r)$ no cambia: 3,3 m en 120 s,

$ dot(r) = (r_2 - r_1)/(120 " s") = (3,3 " m")/(120 " s") = 0,0275 " m/s", quad quad r(t) = 1,2 " m" + 0,0275 " m/s" dot.op t $

Hay dos caminos para encontrar $T$, y vale la pena hacer los dos: el primero
mira la nave entera desde afuera, el segundo mira un módulo desde adentro. Si
llegan a lo mismo, la cuenta está bien y además se entendió por qué.

=== Primer camino: el momento angular que crece

// simbolos: I_0, m, H_z
Me pregunto qué tengo y qué quiero. Quiero la cupla, y la cupla es lo que
cambia el momento angular; entonces primero escribo $H_z$ y después lo
derivo. Todo gira con la misma $omega_0$ alrededor de $z$, así que el momento
angular sobre $z$ es momento de inercia por $omega_0$, y el momento de
inercia se suma pieza por pieza. El momento angular de todo el sistema
alrededor de $z$ es el de la nave sin los módulos más el de los dos módulos. La nave sin los módulos tiene un
momento de inercia $I_0$ alrededor de $z$ que la guía no da —y, spoiler, no
va a hacer falta—. Cada módulo es una partícula de masa $m = 10$ kg a
distancia $r$ del eje, así que aporta $m r^2$ al momento de inercia (el
módulo #M("rotacion"), sin integrar nada: es la definición para un punto).
Con $H_z$ el momento angular del sistema sobre $z$:

$ H_z = (I_0 + 2 m r^2) omega_0 $ <act-hz>

*Ojo con lo que dice esta ecuación:* $omega_0$ es fija, pero $r$ crece, así
que $H_z$ crece. El momento angular de la nave *no* se conserva, y no tiene
por qué: hay propulsores encendidos. La patinadora del módulo #M("rotacion")
conservaba $H_z$ y por eso cambiaba su velocidad angular $omega$; acá es al
revés.
// simbolos: omega

// simbolos: tau
¿Cuánto crece por segundo? Miro qué cambia adentro de $H_z$: $I_0$ no, la
masa no, $omega_0$ no (la fijan los propulsores); lo único que se mueve es
$r$, y está al cuadrado. Entonces derivo $r^2$ con la regla de la cadena,
$2 r dot(r)$, y el resto queda de factor:

$ (d H_z)/(d t) = 2 m dot.op 2 r dot(r) dot.op omega_0 = 4 m r dot(r) omega_0 $

Y lo que hace crecer un momento angular es una cupla externa (el módulo
#M("rotacion"), $tau = d L \/ d t$, con $L$ el momento angular como lo escribe
el Sears; acá $H$ en vez de $L$, porque es la letra del Beer en cuerpo rígido).
Con $tau$ la cupla neta sobre $z$:
// simbolos: L, H

$ tau = 4 m r dot(r) omega_0 = 4 dot.op 10 dot.op 0,0275 dot.op 1,25 dot.op r = 1,375 thin r " N·m" $ <act-tau-brazos>

con $r$ en metros. *La cupla crece con $r$*: un módulo más lejos lleva más
momento angular por cada metro que se aleja, así que cada metro cuesta más.

#fig([La pareja de propulsores, desde arriba. Dos empujes $T$ iguales y
opuestos, cada uno a $1,1$ m de $G$ (las cotas de la figura de la guía):
la suma de fuerzas es cero, así que $G$ no se mueve, y el momento respecto de
$G$ es el de una cupla, $2 dot.op 1,1 thin T$. Es la única manera de torcer
sin empujar. $G$ es el centro de masa de todo el sistema.], fig-act-pareja)
<fig-act-pareja>
// simbolos: G

¿Quién pone esa cupla? Los dos propulsores, que según la figura de la guía
están a $1,1$ m del eje cada uno, empujando en sentidos opuestos. Juntos
hacen una cupla de $2 dot.op 1,1 thin T = 2,2 thin T$, sin ninguna fuerza
neta: la nave no se desplaza, sólo se tuerce. Igualando:

$ 2,2 thin T = 1,375 thin r quad ==> quad T = 0,625 thin r $

y, con $r(t)$ de arriba,

$ T(t) = 0,625 (1,2 + 0,0275 thin t) = 0,75 + 0,0172 thin t " N" $ <act-empuje>

con $t$ en segundos, desde que empiezan a estirarse los brazos. Arranca en
$0,75$ N y termina, a los 120 s, en $2,81$ N.

#fig([Izquierda: el momento angular de los dos módulos, $2 m r^2 omega_0$,
que va de $36$ a $506$ kg·m²/s; crece como $r^2$, o sea como el cuadrado
del tiempo. La nave sin los módulos aporta $I_0 omega_0$, que es constante y
no se dibuja. Derecha: el empuje de cada propulsor, que es lo que paga ese
crecimiento. Es una recta porque es la *derivada* de la curva de la izquierda
dividida por el brazo de la pareja, y la derivada de algo que crece como
$t^2$ crece como $t$. Datos del Adicional 1.], fig-act-hz)
<fig-act-hz>

*El dato que no estaba, y no hacía falta.* $I_0$ desapareció al derivar:
como $omega_0$ es fija, el momento angular de la nave «pelada» no cambia, y
lo que no cambia no pide cupla. Si la guía lo hubiera dado, habría sido un
dato para distraer. Punto para quien escribió el problema, que no lo dio.

=== Segundo camino: Coriolis, módulo por módulo

Ahora desde adentro. Mirá *un* módulo. Se mueve en un círculo que se agranda:
gira con la nave a $omega_0$ y al mismo tiempo se aleja del eje a $dot(r)$.
Su velocidad tiene entonces dos partes: $r omega_0$, tangencial, por estar en
un brazo que gira, y $dot(r)$, radial, porque el brazo se estira.

#fig([Un módulo sobre el brazo, desde arriba. Izquierda: su velocidad es la
suma de la tangencial del brazo que gira, $r omega_0$, y la radial de que el
brazo se estira, $dot(r)$; la suma es $bold(v)$. Derecha: lo que el brazo
tiene que hacerle para que el módulo siga sobre él y a $omega_0$: una fuerza
hacia adentro, $m r omega_0^2$ (la centrípeta de siempre), y una de costado,
$2 m dot(r) omega_0$, que es la de Coriolis. Sin la de costado, el módulo se
atrasaría respecto del brazo, como la hormiga del módulo
#M("cinematica-cr").], fig-act-coriolis)
<fig-act-coriolis>
// simbolos: v

// simbolos: theta, thetadot, thetaddot
Las ecuaciones de una partícula en polares ya están deducidas en el módulo
#M("vectores"), y la que importa acá es la componente *transversal* de la
aceleración#repaso(destino: <vec-polares>)[
  En polares, con $theta$ el ángulo que barre la partícula alrededor del
  origen y $dot.double(r)$ la aceleración con que cambia su distancia al
  origen, la aceleración tiene una parte radial, $dot.double(r) - r
  dot(theta)^2$,
  // simbolos: rddot
  y una transversal, $r dot.double(theta) + 2 dot(r)
  dot(theta)$. El segundo término de la transversal es el de Coriolis. Se
  deducen con los versores girando en el módulo #M("vectores").
]. Con $theta$ el ángulo del brazo, $dot(theta)$ su velocidad angular y
$dot.double(theta)$ su aceleración angular, la aceleración transversal
$a_theta$ del módulo es
// simbolos: a_theta

$ a_theta = r dot.double(theta) + 2 dot(r) dot(theta) $

// simbolos: F_theta
El brazo gira a $dot(theta) = omega_0$ fija, así que $dot.double(theta) = 0$,
y queda sólo el término de Coriolis: $a_theta = 2 dot(r) omega_0$. Para que el
módulo tenga esa aceleración, alguien tiene que empujarlo de costado con una
fuerza $F_theta$, y el único que lo toca es el brazo:

$ F_theta = m a_theta = 2 m dot(r) omega_0 = 2 dot.op 10 dot.op 0,0275 dot.op 1,25 = 0,6875 " N" $

*Es constante*: no depende de $r$. Lo que sí depende de $r$ es el momento
que esa fuerza hace alrededor del eje, porque el módulo está cada vez más
lejos. Por tercera ley, el módulo le devuelve al brazo —o sea, a la nave— una
fuerza igual y opuesta, que *frena* la nave con un momento $r F_theta$ por
módulo. Los dos módulos juntos:

$ 2 r F_theta = 4 m r dot(r) omega_0 = 1,375 thin r " N·m" $

que es la @act-tau-brazos, letra por letra. Los propulsores existen para
cancelar exactamente este freno, y sale el mismo $T = 0,625 thin r$.

#posta[
  Estirar un brazo que gira es como caminar hacia afuera en una calesita: cada
  paso te deja con menos velocidad tangencial de la que necesitás ahí, y la
  calesita te tiene que empujar de costado para que no te quedes atrás. Lo que
  la calesita te da a vos, te lo saca a ella: se frena. Si querés que no se
  frene, alguien la tiene que empujar —acá, dos propulsores—, y como cada vez
  estás más lejos, cada vez hay que empujar más. La nave no sabe que existe
  Coriolis; sólo sabe que se está frenando.
]

#clave[
  Los dos caminos son la misma física contada desde dos lugares. El primero
  mira el sistema entero y pregunta *cuánto cambia el total*; el segundo mira
  una pieza y pregunta *quién la empuja*. Cuando un problema de cuerpo rígido
  se pone difícil, cambiar de sistema suele ser más barato que hacer la cuenta
  más larga —es lo que la cátedra llama «elegir bien los ejes»—.
]

== El mismo mecanismo sin propulsores: el yo-yo

¿Y si nadie pone la cupla? Entonces el momento angular se conserva, la masa se
aleja, y la nave se frena. Lo que en el Adicional 1 había que evitar
quemando combustible, en la práctica se *busca*: muchas sondas llegan del
lanzador girando rápido —el giro estabiliza la última etapa, como contó el
módulo #M("euler-giroscopo")— y después hay que pararlas. Para eso no se usa un
motor sino dos pesitas con hilo. Es el *yo-yo despin*, y el Curtis le dedica
su §12.8 (pág. 666): lo llevaron el Transit 1-A en 1959, la Mars Pathfinder,
los dos rovers de 2003 y la Dawn.

#fig([El yo-yo, desde arriba ($z$ sale de la hoja). Dos hilos enrollados
alrededor de la nave, con una masa en cada punta; se dibuja uno solo, como
en el libro: el otro hace lo mismo del lado opuesto para que $G$ no se mueva.
Al soltarlas, cada hilo se desenrolla: el punto de tangencia $T$ se corre por
el borde, el ángulo desenrollado es $phi$ y el tramo libre mide $R phi$. La
nave, de radio $R$, gira a $omega$. Redibujada de Curtis, fig. 12.19 (§12.8,
pág. 666); acá la $T$ es un punto, como en el libro, no un empuje.],
fig-act-yoyo)
<fig-act-yoyo>
// simbolos: phi, R

// simbolos: C, K
Las letras, las del Curtis: $C$ es el momento de inercia de la nave sin las
pesitas alrededor de su eje de giro, $m$ la masa *total* de las dos pesitas,
$R$ el radio de la nave (donde están enrolladas) y $omega$ su velocidad
angular, que arranca en $omega_0$. Antes de soltar, todo gira junto, y el
Curtis junta todo en un número sin unidades, $K$, que compara la inercia de la
nave con la de las pesitas (ecs. 12.103 y 12.104, pág. 667):

$ H_z = (C + m R^2) omega_0 = K m R^2 omega_0, quad quad K = 1 + C/(m R^2) $

Al soltar, el hilo hace la misma fuerza de costado que el brazo del
Adicional 1, pero al revés: es la pesita la que tira de la nave hacia atrás,
y nadie lo compensa. El Curtis resuelve el resto con dos conservaciones —el
momento angular, porque las fuerzas de los hilos son internas, y la energía,
porque un hilo ideal no disipa nada— y de esas dos sale un resultado que nadie
adivinaría: el hilo se desenrolla a velocidad constante respecto de la nave: la rapidez
$dot(phi)$ con que crece el ángulo desenrollado vale siempre lo mismo,
$dot(phi) = omega_0$ (ec. 12.115, pág. 669).
// simbolos: phidot
Y el largo de hilo que hace falta
para frenarla del todo, $omega = 0$, es

// simbolos: l
$ l = R sqrt(K) $ <act-yoyo>

(Curtis ec. 12.119, pág. 669), con $l$ el largo del tramo libre al soltar.
*No depende de lo rápido que giraba*: la misma pesita con el mismo hilo para
una nave que gira a 1 rad/s o a 10. El Curtis también lo dice con sorpresa
(«surprisingly»), y no es para menos.

#ejemplo("Un yo-yo de verdad: cuánto hilo para parar un satélite")[
  _(Curtis, ejemplo 12.9, págs. 671–672.)_ Un satélite con $C = 200$ kg·m²
  gira a $omega_0 = 5$ rad/s; las dos pesitas juntas pesan $m = 4$ kg y el radio
  es $R = 1$ m. Con la definición de $K$:
  $ K = 1 + 200/(4 dot.op 1^2) = 51, quad quad l = R sqrt(K) = 1 dot.op sqrt(51) = 7,14 " m" $
  Y como el hilo se desenrolla a $dot(phi) = omega_0$, desenrollar $phi =
  sqrt(K)$ radianes lleva $sqrt(51)\/5 = 1,43$ s. Cuatro kilos de pesitas y
  dos hilos de siete metros paran en un segundo y medio a un satélite de dos
  metros que giraba casi a una vuelta por segundo. Lo que no hace falta es
  combustible.
]

#posta[
  El yo-yo es la patinadora que abre los brazos, pero tirando los brazos al
  final. Mientras el hilo se desenrolla, las pesitas se llevan el momento
  angular; cuando se sueltan, se lo llevan *para siempre*, y la nave queda
  quieta. Es el Adicional 1 sin propulsores, y con el signo que conviene.
]

== La rueda de reacción: el Adicional 2

#block(breakable: false)[#guia("Adicional 2 de cuerpo rígido — la rueda de reacción")[
  Una nave con simetría alrededor de $z$ lleva adentro una rueda con su eje
  sobre $z$, movida por un motor clavado a la nave. Cuando el motor le hace un
  par a la rueda, la nave recibe uno igual y opuesto. Todo parte del reposo, y
  el motor hace un par constante $M$ durante un tiempo $T$. ¿Con qué
  velocidad angular termina (a) la nave, (b) la rueda *respecto de la nave*?
  El momento de inercia de toda la nave, rueda incluida, alrededor de $z$ es
  $I$; el de la rueda sola, $I_R$.
  // simbolos: M, I, I_R
]]

*Ojo con las letras, que este problema las recicla.* $M$ no es una masa: es el
*par* (la cupla, el torque) del motor, en N·m. $T$ no es un empuje como en el
Adicional 1: es el *intervalo de tiempo* que el motor está prendido, en
segundos. $I$ es el momento de inercia de *todo*, con la rueda adentro, e
$I_R$ el de la rueda sola; los dos alrededor de $z$, que para una nave
simétrica es el eje axial, el de la $I$ sin prima de toda la Parte V. Y la
figura de la guía le dice $I_w$ (de _wheel_) a lo que el texto llama $I_R$: es
la misma cantidad.

#fig([La nave con su rueda, en corte por el eje $z$, que va vertical. La rueda
es el disco horizontal; el motor está debajo, clavado a la nave. $I$ es el
momento de inercia de todo alrededor de $z$, rueda incluida; $I_R$, el de la
rueda sola. Redibujada de la figura del Adicional 2 de la guía (5), que la
rotula $I_w$.], fig-act-rueda-corte)
<fig-act-rueda-corte>
// simbolos: I_w

*La idea primero.* El motor está entre la nave y la rueda: es una cupla
*interna*. Si se mira el sistema entero —nave más rueda—, nadie de afuera lo
toca, así que su momento angular total no cambia, y como arrancó en reposo,
sigue en cero. Lo único que puede hacer el motor es *repartir*: lo que le da a
la rueda para un lado, se lo saca a la nave para el otro.

#fig([Par y contrapar. El motor le hace a la rueda un par $M hat(k)$ y, por
acción y reacción, a la nave un par $-M hat(k)$; los vectores van sobre $z$
por la regla de la mano derecha. Abajo de cada uno, lo que ese par le hace en
el tiempo $T$ que dura. $omega_R$ es la velocidad angular de la rueda
respecto del espacio, no de la nave.], fig-act-par)
<fig-act-par>
// simbolos: omega_R, omega_nave

// simbolos: omega_rel
Las velocidades, con nombre: $omega_"nave"$ es la de la nave respecto del
espacio (lo que pregunta el inciso a), $omega_"rel"$ la de la rueda *respecto
de la nave* (lo que pregunta el b), y $omega_R$ la de la rueda respecto del
espacio. Las tres van sobre $z$, así que se suman como números:

$ omega_R = omega_"nave" + omega_"rel" $

Ahora, cada cuerpo por separado, con el par constante y el impulso angular
—el par por el tiempo— igual al cambio de momento angular (módulo
#M("rotacion")). *La rueda*, que recibe $M$ durante $T$ y arranca quieta:

$ M T = I_R omega_R = I_R (omega_"nave" + omega_"rel") $ <act-rueda>

*La nave sin la rueda*, cuyo momento de inercia es $I - I_R$ (el de todo
menos el de la rueda), recibe $-M$ durante el mismo $T$:

$ -M T = (I - I_R) omega_"nave" quad ==> quad omega_"nave" = - (M T)/(I - I_R) $ <act-nave>

Ésa es la respuesta del inciso (a): la nave gira *al revés* que el par del
motor, más despacio cuanto más pesada sea. Para el (b), se despeja
$omega_"rel"$ de la @act-rueda y se reemplaza:

$ omega_"rel" = (M T)/I_R - omega_"nave" = (M T)/I_R + (M T)/(I - I_R)
  = (M T (I - I_R + I_R))/(I_R (I - I_R)) = (I M T)/(I_R (I - I_R)) $ <act-rel>

*Control, por el total.* Sumando la @act-rueda y la @act-nave queda $0 = I_R
omega_R + (I - I_R) omega_"nave"$: el momento angular total sigue en cero,
como tenía que ser. Escrito con $omega_"rel"$, $I omega_"nave" + I_R
omega_"rel" = 0$; y si se reemplazan los dos resultados, $I (-M T) \/ (I -
I_R) + I M T \/ (I - I_R) = 0$. Cierra.

Con números chicos se ve mejor (@fig-omega-rueda). Si la nave entera tiene
cuatro veces el momento de inercia de la rueda, la nave gira a un tercio de
$M T \/ I_R$ para atrás, la rueda a cuatro tercios para adelante *respecto de
la nave*, y la suma —lo que ve alguien de afuera— da justo $M T \/ I_R$.

#fig([Las tres velocidades angulares de la rueda de reacción y los dos
momentos angulares, con $I = 4 I_R$ y en unidades de $M T \/ I_R$. La
relativa se suma a la de la nave punta con cola; los momentos angulares de la
rueda y de la nave sin la rueda son iguales y opuestos.],
fig-omega-rueda-completa)
<fig-omega-rueda>

#fig([El momento angular, repartido. Antes de prender el motor, todo quieto:
$bold(H) = bold(0)$. Después de $T$ segundos, la rueda lleva $I_R omega_R$
hacia $+z$ y la nave sin la rueda lleva lo mismo hacia $-z$: las dos flechas
tienen el mismo largo a propósito, y la suma sigue siendo cero. El motor no
creó momento angular: lo separó en dos mitades opuestas.], fig-act-reparto)
<fig-act-reparto>
// simbolos: H

*Control, por el libro.* El Curtis hace este mismo problema en su ejemplo 12.10
(pág. 675–676), con una placa en lugar de la nave y un disco en lugar de la
rueda; llama $I_p$ al momento de inercia de la placa sola (o sea, $I - I_R$)
e $I_w$ al del disco. Llega a $Delta omega_"rel" = -(1 + I_p\/I_w) Delta
omega$, con $Delta$ el cambio de lo que tiene adelante —$Delta omega$, el de
la velocidad de la placa—.
// simbolos: Delta
Con $I_p = I -
I_R$, $I_w = I_R$ y $Delta omega = omega_"nave"$:
// simbolos: I_p
$ Delta omega_"rel" = -(1 + (I - I_R)/I_R) (- (M T)/(I - I_R)) = I/I_R (M T)/(I - I_R) $
que es la @act-rel. Dos caminos, el mismo número.

#cuidado[
  *La rueda gira mucho más rápido que lo que gira la nave.* De la @act-nave y la
  @act-rel, $omega_"rel" \/ abs(omega_"nave") = I\/I_R$: si la rueda tiene un
  centésimo de la inercia de la nave, gira cien veces más rápido. Es lo que el
  Curtis subraya al final de su ejemplo 12.10 («if $I_p >> I_w$…»), y es por qué
  las ruedas de reacción giran a miles de rpm para mover a la nave unos grados
  por segundo.
]

#ejemplo("La rueda con números: girar un microsatélite noventa grados")[
  _(Números de ejemplo, no de la guía: los del Adicional 2 son letras.)_ Un
  microsatélite de $I = 2$ kg·m² alrededor de $z$, con una rueda de $I_R =
  0,002$ kg·m², y un motor que hace $M = 0,01$ N·m durante $T = 10$ s:
  $ omega_"nave" = - (0,01 dot.op 10)/(2 - 0,002) = -0,0501 " rad/s" $
  unos $2,87 degree$ por segundo. Y la rueda, respecto de la nave:
  $ omega_"rel" = (2 dot.op 0,01 dot.op 10)/(0,002 dot.op 1,998) = 50,05 " rad/s" $
  casi 480 rpm. Para girar la nave $90degree$ hacen falta unos 31 s a esa
  velocidad, y después el motor tiene que *frenar* la rueda con el par opuesto:
  si no, la nave sigue girando para siempre. Apuntar es acelerar la rueda,
  esperar y frenarla.
]

#posta[
  Sentado en una silla giratoria con una rueda de bicicleta en las manos:
  hacés girar la rueda para un lado y la silla gira para el otro. Nadie te
  empujó, y sin embargo te moviste. Lo que hiciste fue repartir un momento
  angular que valía cero en dos pedazos que suman cero. Un satélite con
  ruedas de reacción hace eso, tres veces, una por eje, y así apunta un
  telescopio sin gastar una gota de combustible.
]

== Rueda, CMG y propulsor: quién cambia $bold(H)$ y quién lo reparte

La rueda resolvió un problema y abrió otro. Un satélite real no está aislado:
la presión solar, el gradiente de gravedad y el campo magnético de la Tierra
le hacen cuplas *externas* chiquitas, del orden de una milésima de N·m (Curtis
§12.9, pág. 682). Para que la nave no se mueva, la rueda tiene que absorber
esas cuplas, y cada segundo que las absorbe gira un poco más rápido. Un día
llega al tope de su motor: está *saturada*, y ya no puede absorber nada más.

#fig([La rueda hasta saturar, y la desaturación. Una cupla externa chica y
constante que la rueda absorbe la hace girar cada vez más rápido, parejo,
hasta el tope del motor. Ahí se enciende un propulsor —que sí cambia el
momento angular total— mientras el motor frena la rueda, y empieza otra vez.
Cualitativa: el diente de sierra es la forma, no la escala (Curtis §12.9,
pág. 682).], fig-act-saturacion)
<fig-act-saturacion>

Ahí aparece la diferencia de fondo entre los actuadores, que es la de las dos
mitades de este módulo. Una rueda o un CMG hacen cuplas *internas*: reparten el
momento angular entre la nave y la rueda, pero no pueden cambiar el total. Un
propulsor hace una cupla *externa*: es el único de los tres que puede sacarle
momento angular al sistema. Por eso la desaturación siempre la hace un
propulsor (o un magnetotorquer, que empuja contra el campo de la Tierra): la
rueda pasa la cuenta y el combustible la paga, de a poco y de vez en cuando
en lugar de todo el tiempo.

#fig([Tres actuadores, tres maneras de tocar el momento angular. El propulsor
hace una cupla de afuera y cambia el total. La rueda de reacción hace una
cupla interna sobre su propio eje y reparte el momento angular entre ella y
la nave. El CMG también es interno: no cambia la velocidad de un rotor que ya
gira rápido sino la *dirección* de su $bold(H)$, girándolo un ángulo
$delta$.], fig-act-actuadores)
<fig-act-actuadores>
// simbolos: delta

#figure(
  table(
    columns: (1.2fr, 1.6fr, 1.6fr, 1.6fr),
    align: (left, left, left, left),
    inset: 5pt,
    stroke: 0.4pt + luma(180),
    table.header([], [*Propulsor*], [*Rueda de reacción*], [*CMG*]),
    [La cupla es], [externa], [interna], [interna],
    [El momento angular total], [cambia], [no cambia: se reparte], [no cambia: se reparte],
    [Cómo hace la cupla], [empujando contra el gas que tira], [acelerando o frenando la rueda], [girando el eje de un rotor rápido],
    [La cupla de salida, contra la de entrada], [—], [igual: amplificación uno], [mucho mayor: la amplificación del módulo #M("euler-giroscopo")],
    [Lo que se gasta], [combustible], [electricidad], [electricidad],
    [Su límite], [el tanque], [la saturación], [la saturación y las posiciones singulares de los cardanes],
  ),
  caption: [Los tres actuadores de actitud, comparados. El CMG está contado con
  números en el módulo #M("euler-giroscopo") (el volante en el gimbal, torque de
  salida y amplificación); acá sólo se lo ubica al lado de los otros dos. Curtis
  §12.9.],
)

#clave[
  La regla para ubicar cualquier actuador nuevo es una sola pregunta: *¿la
  cupla la hace algo de afuera de la nave, o algo de adentro?* Si es de adentro
  —una rueda, un CMG, un brazo que se estira, un astronauta que se mueve—, el
  momento angular total no cambia, y lo único que se puede hacer es repartirlo.
  Si es de afuera —un propulsor, la presión solar, la gravedad—, el total
  cambia. Todo este módulo es esa pregunta, contestada cuatro veces.
]

== El CMG por dentro: tres velocidades angulares, un vector que se proyecta y dos satélites de verdad

La tabla de arriba despacha al CMG en una columna, y el módulo
#M("euler-giroscopo") lo contó con un volante en un _gimbal_ y dos números:
$500$ N·m de salida contra $2,5$ de entrada. Alcanzaba para el parcialito del
capítulo 18. No alcanza para una hora de clase entera sobre el tema, que es lo
que la cátedra dejó para el jueves 12/11 «a cargo exclusivamente» de los
alumnos: la manera elegante de Aníbal de decir que esto ya lo tendríamos que
saber explicar solos. Esta sección es el CMG desarmado pieza por pieza, con
las tres cosas que el parcialito del 29/10 pidió para el giróscopo —escribir
las velocidades angulares, proyectar vectores, dibujar— y los dos papers de
la cátedra que lo muestran funcionando: la estación Skylab y un microsatélite
de Surrey.

*La idea, antes de la primera cuenta.* Un CMG (_control moment gyroscope_) es
un rotor que gira *siempre igual*, rapidísimo, montado en un cardán que un
motor hace girar. El rotor no se frena ni se acelera nunca: lo único que
cambia es *hacia dónde* apunta su momento angular. Y como el motor del cardán
es interno, el momento angular de la nave más el del rotor no se mueve; lo que
el rotor tuerce para un lado, la nave lo tuerce para el otro. Es la analogía
que pidió Aníbal leída para la ingeniería: una fuerza perpendicular a la
velocidad le cambia la dirección y no el módulo, y una cupla perpendicular a
$bold(H)$, lo mismo. El CMG vive de esa segunda mitad.

=== Las tres velocidades angulares

Hay tres cuerpos, y cada uno gira distinto. Conviene armar las velocidades
como el Beer arma las del giróscopo en cardanes (§18.9, la sección de los
ángulos de Euler del módulo #M("euler-giroscopo")): *cada articulación suma
su giro relativo al de la pieza que la sostiene*.

// simbolos: ghat, shat, that
Para eso hace falta una terna pegada al cardán. *$hat(g)$* va sobre el eje del
cardán, el que gira el motor; *$hat(s)$* sobre el eje del rotor, el eje de
_spin_, siempre perpendicular a $hat(g)$; y *$hat(t) = hat(g) times hat(s)$*
es el tercero, transversal a los dos: ahí va a salir la cupla. La terna
$(hat(s), hat(t), hat(g))$ es derecha, así que con tres dedos: pulgar
$hat(s)$, índice $hat(t)$, mayor $hat(g)$. El satélite tiene su propia terna,
$hat(i), hat(j), hat(k)$, y el cardán está montado con su eje sobre $hat(k)$:
$hat(g) = hat(k)$, fijo en el satélite.

// simbolos: omega_b, Omega_g, deltadot, omega_r, Omega_s
- *El satélite* gira con $bold(omega)_b$ respecto del espacio (la _b_ es de
  _body_, como en los papers).
- *El cardán* gira con el satélite y, además, el motor lo hace girar sobre
  $hat(g)$ con $dot(delta)$, la derivada del ángulo de cardán $delta$ de la
  figura de los tres actuadores: $bold(Omega)_g = bold(omega)_b + dot(delta)
  hat(g)$.
- *El rotor* gira con el cardán y, además, sobre su eje $hat(s)$ con
  $Omega_s$, su velocidad *respecto del cardán*, que un motorcito propio
  mantiene constante (miles de rpm). Sumando:

$ bold(omega)_r = bold(omega)_b + dot(delta) hat(g) + Omega_s hat(s) $ <act-cmg-omega>

La terna $(hat(s), hat(t), hat(g))$ gira con $bold(Omega)_g$, *no* con
$bold(omega)_r$: sigue al cardán y no al _spin_. Es el «no siempre
$bold(Omega) = bold(omega)$» que Aníbal subrayó en su hoja del capítulo 18, y
es el mismo truco del balancín interior del Beer: ejes que son principales del
rotor sin tener que dar vueltas con él. (La $bold(Omega)$ de Aníbal es la
velocidad angular de los ejes, que acá es la $bold(Omega)_g$ del cardán.)
// simbolos: Omega

#fig([Las tres piezas y sus giros. El satélite gira con $bold(omega)_b$; el
cardán, montado sobre $hat(g) = hat(k)$, gira además $dot(delta)$ respecto
del satélite; el rotor gira además $Omega_s$ sobre $hat(s)$ respecto del
cardán. Cada flecha curva es un giro relativo; la velocidad angular de cada
pieza es la suma de las flechas que tiene debajo.], fig-act-cmg-giros)
<fig-act-cmg-giros>

=== El momento angular del rotor, y por qué alcanza con un término

// simbolos: H_r, I_s, I_t
El rotor es simétrico alrededor de $hat(s)$: *$I_s$* es su momento de inercia
axial, sobre $hat(s)$, e *$I_t$* el transversal, sobre cualquier eje
perpendicular por su centro. Pienso el momento angular como siempre: momento
por omega, componente a componente, en ejes principales. ¿Cuál omega? La del
rotor, $bold(omega)_r$, porque $bold(H)_r$ es de la masa del rotor. ¿Qué ejes?
La terna del cardán, que es principal para el rotor aunque no siga su spin
(el rotor es redondo). Entonces necesito las tres componentes de
$bold(omega)_r$ en esa terna: el spin y el cardán ya están escritos sobre
$hat(s)$ y $hat(g)$, pero $bold(omega)_b$ está en la terna del satélite, así
que lo proyecto sobre cada versor del cardán con un producto escalar. Cada
componente, por su momento (módulo #M("inercia")):

$ bold(H)_r = I_s (Omega_s + bold(omega)_b dot.op hat(s)) hat(s)
  + I_t (dot(delta) + bold(omega)_b dot.op hat(g)) hat(g)
  + I_t (bold(omega)_b dot.op hat(t)) hat(t) $

// simbolos: h
Proyectar es eso: $bold(omega)_b dot.op hat(s)$ es cuánto del giro del satélite
cae sobre $hat(s)$, y así con los otros dos. Ahora los tamaños: $Omega_s$ son
miles de rpm, $dot(delta)$ y $bold(omega)_b$ son unos grados por segundo. El
primer término le gana a los otros por varios órdenes de magnitud, y se
escribe
$ bold(H)_r approx h hat(s), quad quad h = I_s Omega_s $
que es la $h = I omega$ del paper de Lappas, Steyn y Underwood (2002, pág.
104). Un número fijo, montado sobre una dirección que gira con el cardán.

=== La derivada: de dónde sale la cupla de salida

Quiero la cupla, así que derivo $bold(H)_r = h hat(s)$. Elijo desde dónde
mirar: desde el cardán, porque ahí $hat(s)$ está quieto. Entonces, con el
teorema del transporte (la @cin-derivada), la derivada relativa es lo que
cambia $h hat(s)$ visto desde el cardán: nada, porque $h$ es fijo y $hat(s)$
no se mueve ahí. Queda sólo el transporte, con la velocidad angular de *mis
ejes*, que es la del cardán, $bold(Omega)_g$; la abro en sus dos giros y cada
uno lo cruzo con $h hat(s)$:
$ (d bold(H)_r)/(d t) = bold(Omega)_g times h hat(s)
  = (bold(omega)_b + dot(delta) hat(g)) times h hat(s)
  = h dot(delta) hat(t) + bold(omega)_b times h hat(s) $
porque $hat(g) times hat(s) = hat(t)$. Ésa es la cupla que el satélite, a
través de los cojinetes del cardán, le tiene que hacer al rotor. Por acción y
reacción, el satélite recibe la opuesta:

// simbolos: tau_sat
$ bold(tau)_"sat" = - h dot(delta) hat(t) - bold(omega)_b times h hat(s) $ <act-cmg-cupla>

// simbolos: N

- *El primer término es la cupla de salida.* Va sobre $hat(t)$, perpendicular
  al eje del cardán y al del rotor, y vale $h dot(delta)$: rotor grande por
  cardán lento da mucho. Es la ecuación 1 de Lappas, que a la cupla le dice
  $bold(N)$, $bold(N) = bold(h) times dot(bold(delta))$, escrita con otras letras: $h hat(s) times dot(delta)
  hat(g) = - h dot(delta) hat(t)$.
- *El segundo existe sólo si el satélite ya está girando.* Es lo que el paper
  llama _gyro torque_, y su parte sobre $hat(g)$ —que vale $h (bold(omega)_b
  dot.op hat(t))$, cambiada de signo— la tiene que aguantar el motor del cardán.
  Por eso el motor no trabaja gratis cuando el satélite maniobra: además de
  acelerar el cardán, sostiene esa cupla (Lappas, ecs. 6 a 8, pág. 106).

Las dos partes, dibujadas en la punta de $bold(H)_r$ (@fig-omega-cmg-dos): el
cardán la empuja sobre $hat(t)$, y si además el satélite gira sobre $hat(t)$,
el transporte la empuja sobre $-hat(g)$, justo contra el eje del motor.

#figure(placement: auto, kind: "fig", supplement: [Figura], caption: [Las dos
partes de $dif bold(H)_r \/ dif t$ en un CMG, punta con cola. La del cardán, $h
dot(delta) hat(t)$, da la cupla de salida; la del satélite, $bold(omega)_b times
h hat(s)$, con el satélite girando sobre $hat(t)$, cae sobre el eje del cardán y
la aguanta el motor. El satélite recibe la suma cambiada de signo, la
@act-cmg-cupla.], align(center, fig-omega-cmg-dos-completa))
<fig-omega-cmg-dos>

#cuidado[
  *El rotor no se frena.* $h$ no cambió en ningún momento: lo que el CMG le
  pasa al satélite sale de *girar la dirección* de $bold(H)_r$, no de gastar
  su giro. Una rueda de reacción hace al revés: no gira su eje, cambia su
  velocidad. Ésa es toda la diferencia de la tabla, en una línea.
]

#figure(placement: auto, kind: "fig", supplement: [Figura], caption: [Un CMG por dentro, con todos sus vectores. Sobre el satélite (la
placa), un motor gira el cardán —el anillo verde— alrededor de $hat(g)$ con
$dot(delta)$. Adentro, el rotor gira con $Omega_s$ sobre $hat(s)$ y lleva
$bold(H)_r = h hat(s)$, a un ángulo $delta$ del eje $hat(i)$ del satélite.
Al girar el cardán, la punta de $bold(H)_r$ se mueve sobre $hat(t)$ (azul), y
el satélite recibe la cupla al revés, $-h dot(delta) hat(t)$ (rojo). Cuando
veas uno, buscá esas tres flechas: el eje del cardán, el del rotor y la cupla,
perpendicular a los dos.], align(center, fig-cmg-3d))
<fig-cmg-3d>

#figure(placement: auto, kind: "fig", supplement: [Figura], caption: [La analogía de Aníbal, dibujada. La fuerza central empuja de costado a la
velocidad $bold(v)$ del satélite en órbita, y el cambio $Delta bold(v)$ la gira
sin agrandarla; la cupla del cardán empuja de costado a $bold(H)_r$, y $Delta
bold(H)_r$ lo gira sin cambiarle el tamaño $h$. El rotor no se frena por lo
mismo que el satélite en órbita circular no acelera.], align(center, fig-cmg-analogia))
<fig-cmg-analogia>

=== Proyectar: la misma cupla vista desde el satélite

Ahora con el satélite quieto ($bold(omega)_b = bold(0)$), para ver la cupla de
salida sola, y en los ejes del satélite, que es donde la necesita el que
controla la actitud. Pienso: la cupla me dio sobre $hat(t)$, que es un versor
del cardán, y el cardán está girado $delta$ respecto del satélite alrededor de
$hat(k)$. Entonces escribo los versores del cardán con los del satélite:
$hat(s)$ está a $delta$ de $hat(i)$ en el plano de $hat(i)$ y $hat(j)$, y $hat(t)$ es $hat(s)$
girado $90 degree$ más. Con $hat(g) = hat(k)$ y el ángulo de cardán $delta$
medido desde $hat(i)$:
$ hat(s) = cos delta thin hat(i) + sin delta thin hat(j), quad quad
  hat(t) = hat(k) times hat(s) = - sin delta thin hat(i) + cos delta thin hat(j) $
Las componentes de $bold(H)_r$ en la terna del satélite son $h (cos delta;
sin delta; 0)$. Derivándolas *componente por componente* —el satélite está
quieto, así que acá no hay transporte—, $d bold(H)_r \/ d t = h dot(delta)
(- sin delta; cos delta; 0) = h dot(delta) hat(t)$: lo mismo que dio el
transporte desde el cardán, por el otro camino. Y la cupla sobre el satélite:
$ bold(tau)_"sat" = h dot(delta) (sin delta thin hat(i) - cos delta thin hat(j)) $

#fig([La cupla de salida, proyectada. Vista desde arriba del satélite, con el
eje del cardán $hat(g) = hat(k)$ saliendo de la hoja. $bold(H)_r$ forma el
ángulo $delta$ con $hat(i)$ y se proyecta en $h cos delta$ y $h sin delta$.
Al girar el cardán, la punta de $bold(H)_r$ se mueve sobre $hat(t)$, y el
satélite recibe la cupla al revés: $-h dot(delta) hat(t)$.],
fig-act-cmg-proyeccion)
<fig-act-cmg-proyeccion>

La lectura es la que importa: *la cupla de salida gira con $delta$*. Con
$delta = 0$ sale toda sobre $-hat(j)$; con $delta = 90degree$, toda sobre
$+hat(i)$. Un CMG de un cardán da, en cada instante, cupla en *una sola*
dirección —la de $hat(t)$— y siempre en el plano perpendicular a su cardán.
Para controlar tres ejes hacen falta varios, y ahí empiezan los problemas.

=== Varios CMG: el reparto, la saturación y las posiciones singulares

// simbolos: h_i, deltadot_i, that_i, shat_i, H_c
Con varios CMG la cupla es la suma: cada uno, con su $h_i$, su velocidad de
cardán $dot(delta)_i$ y sus versores $hat(s)_i$ y $hat(t)_i$, aporta lo suyo,
$bold(tau)_"sat" = - sum_i h_i dot(delta)_i hat(t)_i$. Y el momento angular
del conjunto, $bold(H)_c = sum_i h_i hat(s)_i$, más el del satélite, no cambia
(cupla interna). De ahí salen los dos límites del CMG, que son los dos de la
tabla:

- *Saturación.* Cuando todos los $h_i hat(s)_i$ apuntan para el mismo lado,
  $bold(H)_c$ llegó a su largo máximo, $sum_i h_i$, y en esa dirección ya no
  puede absorber nada más. Es la rueda en el tope del motor, con otra forma.
- *Posición singular.* Cuando todos los $hat(t)_i$ quedan en un mismo plano,
  hay una dirección de cupla que ninguna combinación de $dot(delta)_i$
  produce, aunque el conjunto no esté saturado: el CMG «se traba» (_lock-up_,
  dice Lappas). Por eso hacen falta al menos cuatro CMG de un cardán, en
  pirámide, para controlar los tres ejes esquivando singularidades (Lappas,
  pág. 102), y por eso cada sistema real tiene una *ley de guiado* que elige
  los $dot(delta)_i$ lejos de esas posiciones.

#fig([Dos CMG con el cardán sobre el mismo eje, vistos desde arriba. Abiertos,
sus dos $hat(t)$ apuntan distinto y combinándolos sale cualquier cupla del
plano. Paralelos, los dos $hat(t)$ coinciden: una sola dirección de cupla, y
$bold(H)_c$ al máximo. Antiparalelos, $bold(H)_c = bold(0)$ y los $hat(t)$
siguen sobre una misma recta: singular sin estar saturado, la posición que el
Skylab evitaba a propósito (Chubb y Seltzer 1971, fig. 3).],
fig-act-cmg-singular)
<fig-act-cmg-singular>

#fig([Cuatro CMG de un cardán en pirámide, la disposición del paper de Lappas
(2002, fig. 15). Cada cardán $hat(g)$ (verde) es perpendicular a una cara y
cada $bold(H)_r$ (rojo) gira en el plano de su cara. Como los cuatro planos
son distintos, siempre hay una combinación de giros de cardán que da cupla
para cualquier lado.], fig-cmg-piramide)
<fig-cmg-piramide>

=== Dos satélites de verdad: Skylab y un microsatélite de Surrey

*Skylab* (Chubb y Seltzer, _Skylab Attitude and Pointing Control System_,
NASA TN D-6068, 1971: el informe que juntó la cátedra para esta clase). Una
estación de $8,3 times 10^4$ kg y $36$ m, con un telescopio solar que no podía
moverse más de un par de milésimas de radián. La controlaban *tres CMG de
doble cardán*, montados ortogonales, de $2700$ N·m·s cada uno, con el rotor a
$149$ vueltas por segundo, que son $936$ rad/s. Con eso el rotor sale:
$ I_s = h/Omega_s = 2700/936 approx 2,88 " kg" dot.op "m"^2 $
¿Por qué CMG y no los propulsores que ya tenía? El informe da dos razones, y
las dos son de esta sección: los gases de los propulsores habrían ensuciado la
óptica del telescopio, y las cuplas del gradiente de gravedad son *cíclicas*,
así que un CMG las absorbe en media órbita y las devuelve en la otra sin
gastar nada.

Lo que no es cíclico es el problema. Como los momentos de inercia del Skylab
son muy distintos ($0,886 times 10^6$ kg·m² sobre su eje largo contra unos
$5,8 times 10^6$ sobre los otros dos), el gradiente de gravedad le deja *de
regalo* unos $600$ N·m·s por órbita sobre el eje largo, siempre para el mismo
lado. *Predicción sin datos de más*, a la Aníbal: los tres CMG juntos guardan
a lo sumo $3 dot.op 2700 = 8100$ N·m·s, así que se saturarían en $8100\/600
approx 13,5$ órbitas; a $435$ km la órbita dura unos $93$ min, o sea *menos de
un día*. La solución del informe es preciosa: de día, poner el eje de menor
momento de inercia en el plano de la órbita para que el regalo sea mínimo; y
de noche, cuando el telescopio no mira al Sol, *girar la estación* para que el
mismo gradiente de gravedad empuje para el otro lado y desature los CMG gratis.
Sólo si el momento angular de los CMG pasa del $95$ % de su capacidad se
encienden los propulsores. Y una «ley de distribución» mantenía los tres
$bold(H)$ abiertos para no caer en la posición antiparalela de la figura de
arriba, con topes mecánicos de $plus.minus 1,4$ rad en el cardán interior.

// simbolos: alpha, theta_1, t_1, I_sat
*El microsatélite de Surrey* (Lappas, Steyn y Underwood 2002, el otro paper de
la cátedra) hace el camino al revés: del requisito al CMG. Un satélite de $130$
kg con $I_"sat" = 2,5$ kg·m² tiene que girar $30degree$ en $10$ s. Acelerando
la mitad del tiempo y frenando la otra mitad, recorre $theta_1 = 15degree =
0,2618$ rad en $t_1 = 5$ s con aceleración angular constante $alpha$:
$ alpha = (2 theta_1)/t_1^2 = (2 dot.op 0,2618)/25 approx 0,0209 " rad/s"^2,
  quad quad tau = I_"sat" alpha approx 0,0524 " N" dot.op "m" $
los $52,5$ mN·m del paper, con una velocidad máxima de $alpha t_1 = 0,105$
rad/s, $6degree$ por segundo. Con el cardán a lo sumo a $0,12$ rad/s, *un*
CMG necesitaría $h = tau \/ dot(delta) approx 0,44$ N·m·s; repartido entre
cuatro en pirámide, el paper llega a $0,35$ N·m·s por CMG, y con un motor de
$20 thin 000$ rpm ($2094$ rad/s) el disco sale de $I_s = 0,35 \/ 2094 approx
1,7 times 10^(-4)$ kg·m², lo que dice el paper. *Control por el momento
angular:* el satélite a $0,105$ rad/s lleva $2,5 dot.op 0,105 approx 0,26$
N·m·s, y eso es lo que los CMG tienen que poder sacarle; con $0,35$ cada uno
sobra, que es por qué el número cierra.

Lo armaron y lo probaron en una mesa de aire, que gira casi sin rozamiento: un
disco de $2 times 10^(-5)$ kg·m² a $11 thin 200$ rpm ($h approx 0,0235$
N·m·s), con el cardán a $24degree$ por segundo ($0,419$ rad/s), da $h
dot(delta) approx 9,83$ mN·m, y midieron $9,82$. Y la comparación que cierra
el paper es la de la tabla de arriba con precio: una rueda de reacción que
diera esos $52,5$ mN·m pesaría más de $4$ kg, unos $16$ kg las cuatro, contra
$940$ g de los cuatro CMG con su electrónica.

=== Y leído al revés: el giróscopo que mide

// simbolos: H_s
La misma ecuación hace de sensor, y es la otra mitad de la hoja «Giróscopos
como actuador y sensor» de la cátedra (módulo #M("rotacion")). Wrigley y
Hollister (_Science_, 1965, el tercer paper) la escriben $bold(omega) times
bold(H)_s = bold(M)$, con $bold(H)_s$ el momento angular de _spin_: si al
giróscopo lo hacen girar con $bold(omega)$, alguien tiene que hacerle la cupla
$bold(M)$, y midiendo esa cupla —o lo que la frena— se mide $bold(omega)$. Si
la cupla la pone un resorte, el ángulo que se tuerce el giróscopo dice la
*velocidad* de giro: es un _rate gyro_, el que el Skylab usaba para medir su
propia rotación. Si la pone un amortiguador, el ángulo dice cuánto *giró* en
total: un giróscopo integrador, la pieza del guiado inercial.

#fig([La silla y la rueda, con vectores. La rueda gira con su momento angular
horizontal (punteado, «antes»); quien está sentado le inclina el eje, y el
momento angular de la rueda gana un $Delta bold(H)$ hacia arriba. Nadie de
afuera tocó nada, así que la silla se lleva $-Delta bold(H)$: gira, vista de
arriba, en sentido horario. Es la niña con la rueda de la cátedra (módulo
#M("rotacion")) jugada al revés: ella sentía la cupla en las manos, acá la
cupla hace girar la silla.], fig-cmg-silla)
<fig-cmg-silla>

#posta[
  El CMG es la silla giratoria con la rueda de bicicleta, pero sin acelerar la
  rueda: la tenés girando y le *torcés el eje*. La silla gira, mucho, con
  poquito esfuerzo de tus manos, y la rueda sigue girando igual que antes. Lo
  que te devuelve la silla sale de cambiarle la dirección a un momento angular
  enorme que ya estaba ahí. El día que el eje queda apuntando para donde ya no
  lo podés torcer, se acabó la magia: saturaste, o te trabaste en una
  singularidad, y hay que pedirle ayuda a algo de afuera. El Skylab le pedía
  ayuda a la gravedad, de noche y sin gastar un gramo. Elegante, para algo
  hecho en 1970 con una computadora de 16 mil palabras.
]

== Cierre de la Parte V, y del apunte

La Parte V es, de punta a punta, el Beer: los capítulos 15 y 18, en el
orden de la lista de la cátedra, con el Sears de puerta de entrada en el
módulo #M("rotacion") y el Curtis de salida en éste. Y se sostiene con una
sola herramienta repetida: derivar un vector cuando el sistema que lo mira
está girando —la @cin-derivada del módulo #M("cinematica-cr"), la «relación
fundamental» del Beer— y aplicarla, primero al momento angular de una
partícula (módulo #M("momento-angular")), después al de un cuerpo entero
(módulos #M("inercia") y #M("euler-giroscopo")), hasta llegar al caso en el que
ni siquiera hace falta una cupla para que la física haga algo interesante, la
peonza del módulo #M("peonza"), y a éste, en el que la cupla está pero adentro,
y por eso no cambia nada del total y lo cambia todo en las partes. El satélite
achatado que precesa solo, la nave que estira los brazos y la que se gira con
una rueda son la misma ley: un cuerpo tiene el momento angular que le dieron
de afuera, y por adentro sólo lo puede repartir.

Veintidós módulos después del primer producto vectorial, el apunte termina
donde la cátedra quería que terminara: con un satélite que se apunta solo.
Si Aníbal pregunta de dónde salió todo esto, la respuesta es la de cada
sección: del libro que él mandó a leer. Que lo hayamos leído es la parte que
no se esperaba.
