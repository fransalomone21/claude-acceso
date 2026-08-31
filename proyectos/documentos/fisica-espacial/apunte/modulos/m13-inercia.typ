#import "../plantilla.typ": *

#modulo("Momento de inercia y ejes principales")[
  Extender $bold(H)_G = I bold(omega)$ del plano al espacio, y descubrir que
  ahí $I$ deja de ser un número: se vuelve una matriz de seis datos —tres
  momentos y tres productos de inercia— que dicen cómo está repartida la masa
  alrededor del centro. Con eso se entiende por qué $bold(H)_G$ y
  $bold(omega)$ casi nunca apuntan para el mismo lado, salvo en la dirección
  privilegiada de cada cuerpo: su *eje principal*.
]

El módulo 7 definió $bold(H)_O = bold(r) times m bold(v)$ para una partícula,
y para un cuerpo rígido girando en el plano la suma de todas esas
contribuciones colapsaba en $H_G = I omega$, con $I$ un solo número que no
cambiaba con la dirección de giro porque en el plano *sólo hay* una
dirección posible, perpendicular a él. El módulo 12 mostró que en el espacio
$bold(omega)$ puede apuntar para cualquier lado, y con eso la pregunta que
este módulo contesta: ¿sigue valiendo $bold(H)_G = I bold(omega)$, con
$bold(H)_G$ apuntando siempre como $bold(omega)$? La respuesta es no, y
entender por qué es la herramienta que el módulo 14 necesita para llegar a
las ecuaciones de Euler.

== $bold(H)_G$ por integrales: momentos y productos de inercia

#deduccion("de dónde salen los seis números que hacen falta")[
  Un cuerpo rígido gira con velocidad angular $bold(omega)$ alrededor de su
  centro de masa $G$. Un elemento de masa $d m$, en la posición $bold(r)$
  medida desde $G$, tiene velocidad $bold(v) = bold(omega) times bold(r)$
  (@m12-v) y aporta al momento angular total $d bold(H)_G = bold(r) times
  (d m thin bold(v)) = d m thin bold(r) times (bold(omega) times bold(r))$.
  Integrando sobre todo el cuerpo:
  $ bold(H)_G = integral bold(r) times (bold(omega) times bold(r)) thin d m $
  <m13-hg-integral>
  La identidad vectorial $bold(r) times (bold(omega) times bold(r)) =
  bold(omega) (bold(r) dot bold(r)) - bold(r) (bold(r) dot bold(omega))$
  convierte el doble producto vectorial en algo que se puede integrar
  componente a componente. Con $bold(r) = x hat(i) + y hat(j) + z hat(k)$, la
  componente $x$ del integrando es
  $ omega_x (x^2+y^2+z^2) - x(x omega_x + y omega_y + z omega_z)
    = omega_x (y^2+z^2) - omega_y thin x y - omega_z thin x z $
  y las otras dos salen igual, permutando $x arrow.r y arrow.r z$. (Beer
  ecs. 18.4 a 18.6, pág. 1151–1152.)
]

Definiendo los *momentos de inercia* $I_x = integral (y^2+z^2) d m$ (y cíclico
para $I_y$, $I_z$) y los *productos de inercia* $I_(x y) = integral x y thin
d m$ (y cíclico para $I_(y z)$, $I_(x z)$), las tres componentes de
$bold(H)_G$ quedan

$ H_x = I_x omega_x - I_(x y) omega_y - I_(x z) omega_z $
$ H_y = -I_(x y) omega_x + I_y omega_y - I_(y z) omega_z $
$ H_z = -I_(x z) omega_x - I_(y z) omega_y + I_z omega_z $

(Beer ec. 18.7, pág. 1152.)

#notacion[
  *Momento de inercia versus producto de inercia.* Un momento de inercia
  $I_x$ es siempre positivo —es una suma de $(y^2+z^2) d m \geq 0$— y mide
  cuánta masa está lejos del eje $x$. Un producto de inercia $I_(x y)$ puede
  ser positivo, negativo o cero, y mide una *asimetría*: si la masa está
  repartida igual a ambos lados del plano $x=0$ o del plano $y=0$, la integral
  se cancela. Por eso un cubo con ejes por las aristas, o un disco con un eje
  sobre su simetría, tienen productos de inercia nulos: son casos con la
  simetría exacta que hace falta.
]

== El tensor de inercia

Las tres ecuaciones de arriba son un sistema lineal, y se escriben como una
sola ecuación matricial:

$ mat(H_x; H_y; H_z) = mat(I_x, -I_(x y), -I_(x z);
  -I_(x y), I_y, -I_(y z); -I_(x z), -I_(y z), I_z)
  mat(omega_x; omega_y; omega_z) $ <m13-tensor>

(Beer ec. 18.8, pág. 1153.) Esa matriz simétrica de $3 times 3$ es el
*tensor de inercia*: otra vez son *seis* números —como los seis grados de
libertad del módulo 12, pero éstos no describen dónde está el cuerpo sino
*cómo* está hecho— y no cambian mientras el cuerpo no se deforme.

#geometria[
  *Toda matriz simétrica tiene una base propia ortogonal: eso es álgebra
  lineal, no física.* Para cualquier cuerpo existe una terna de ejes —los
  *ejes principales de inercia*— en la que los tres productos de inercia se
  anulan a la vez, y el tensor queda diagonal:
  $ H_x = I_x omega_x, quad H_y = I_y omega_y, quad H_z = I_z omega_z $
  <m13-diagonal>
  (Beer §18.2 y ec. 18.9, pág. 1153.) El Beer lo afirma sin demostrarlo —la
  demostración está en el volumen de Estática, §§9.16–9.17, que no forma parte
  del material de esta cátedra— pero en la práctica no hace falta buscarlos a
  ciegas: *todo eje de simetría material es principal*, y con él alcanza para
  resolver los problemas de esta parte. Un eje de simetría de revolución (el
  eje de un disco, de un cilindro, de un cono) es principal, y también lo es
  cualquier eje perpendicular a él que pase por el centro; los tres ejes por
  las aristas de un cubo homogéneo, con origen en su centro, también lo son.
]

== Por qué $bold(H)_G$ y $bold(omega)$ casi nunca son paralelos

#cuidado[
  *$bold(H)_G = I bold(omega)$, con $I$ un número, sólo vale si $bold(omega)$
  va exactamente sobre un eje principal.* Ahí la @m13-diagonal da
  $bold(H)_G = I_x omega_x hat(i) = I_x bold(omega)$: paralelo, porque las
  otras dos componentes de $bold(omega)$ son cero. Pero si $bold(omega)$ tiene
  componentes sobre *dos* ejes principales distintos —$bold(omega) = omega_x
  hat(i) + omega_y hat(j)$, digamos— entonces
  $ bold(H)_G = I_x omega_x hat(i) + I_y omega_y hat(j) $
  y esto es paralelo a $bold(omega)$ sólo si $I_x = I_y$. En general no lo
  son, y entonces $bold(H)_G$ queda apuntando para otro lado que
  $bold(omega)$: más cerca del eje con el momento de inercia más grande, en
  la misma proporción en que ese eje pesa más en la suma. (Beer ec. 18.10,
  pág. 1153.) Es el hecho que hace no trivial toda la Parte IV que sigue: si
  $bold(H)_G$ y $bold(omega)$ fueran siempre paralelos, el cuerpo rígido en
  3D se resolvería exactamente como el movimiento plano.
]

== De $G$ a un punto cualquiera: $bold(H)_O$

La misma descomposición del módulo 8 —movimiento del centro de masa más
movimiento relativo a él— vale para el momento angular. Para un cuerpo con
centro de masa $G$ que se mueve con velocidad $bold(macron(v))$, el momento
angular respecto de un punto fijo $O$ cualquiera es

$ bold(H)_O = bold(macron(r)) times m bold(macron(v)) + bold(H)_G $ <m13-ho>

(Beer ec. 18.11, pág. 1154), con $bold(macron(r))$ el vector de $O$ a $G$: la
parte «orbital» —como si toda la masa estuviera en $G$— más la parte «de
espín» que este módulo acaba de calcular. Cuando $O$ es un punto fijo *del
cuerpo* (el pivote de un giróscopo, por ejemplo), $bold(macron(v)) =
bold(omega) times bold(macron(r))$ y la @m13-ho se puede escribir directamente
en términos del tensor de inercia calculado respecto de $O$ en vez de $G$
—el módulo 14 la usa así para el giróscopo con punto fijo.

== Energía cinética

#deduccion("por qué la energía cinética de rotación es media vez omega por H_G")[
  Para un cuerpo que gira puro alrededor de $G$ (sin traslación), cada
  elemento de masa aporta $1/2 (bold(omega) times bold(r)) dot (bold(omega)
  times bold(r)) thin d m$. La identidad del triple producto escalar,
  $bold(A) dot (bold(B) times bold(C)) = bold(C) dot (bold(A) times bold(B))$,
  aplicada con $bold(A) = bold(omega)$, $bold(B) = bold(r)$, $bold(C) =
  bold(omega) times bold(r)$, da
  $ (bold(omega) times bold(r)) dot (bold(omega) times bold(r))
    = bold(omega) dot (bold(r) times (bold(omega) times bold(r))) $
  que es el mismo integrando de la @m13-hg-integral. Integrando:
  $ T = 1/2 integral (bold(omega) times bold(r)) dot (bold(omega) times bold(r)) thin d m
    = 1/2 bold(omega) dot integral bold(r) times (bold(omega) times bold(r)) thin d m
    = 1/2 bold(omega) dot bold(H)_G $
]

$ T = 1/2 m macron(v)^2 + 1/2 bold(omega) dot bold(H)_G $ <m13-energia>

que en ejes principales, con la @m13-diagonal, es

$ T = 1/2 m macron(v)^2 + 1/2 (I_x omega_x^2 + I_y omega_y^2 + I_z omega_z^2) $

(Beer ecs. 18.16 y 18.17, pág. 1157.) Si en cambio el cuerpo tiene un punto
fijo $O$ y gira puro alrededor de él —el caso del giróscopo que viene en el
módulo 14—, no hay término de traslación y la energía es toda rotacional,
con los momentos de inercia tomados respecto de $O$:

$ T = 1/2 (I_x omega_x^2 + I_y omega_y^2 + I_z omega_z^2) $

(Beer ecs. 18.19 y 18.20, pág. 1157.)

#guia("qué ejercicios cubre este módulo")[
  El Problema 1 completo (el satélite cúbico) y el punto 1 del Problema 2 (el
  impulso angular del disco en la horquilla). El punto 2 del Problema 2
  —$d bold(H)_G \/ d t$— necesita la @m12-derivada aplicada al resultado de
  hoy, y queda para el módulo 14.
]

#ejemplo("El satélite cúbico: velocidad angular tras un encendido", nivel: "a fondo")[
  _(Problema 1 de la sección de cuerpo rígido.)_ Un satélite cúbico homogéneo,
  de arista $d = 2$ m y masa $m = 120$ kg, tiene un impulsor de gas frío
  ($F_E = 4$ N, $I_"sp" = 50$ s) montado en un vértice, con el empuje
  alineado con una de las aristas que salen de ese vértice. Se enciende
  $4$ s. Pide la velocidad angular resultante, el caudal másico del impulsor
  y cuánto tiempo seguirá girando el satélite.

  *Los ejes.* Con origen en el centro de masa y ejes paralelos a las aristas,
  el cubo es simétrico respecto de los tres planos coordenados: los tres
  productos de inercia son nulos y $x,y,z$ son ejes principales, con
  $ I_x = I_y = I_z = 1/6 m d^2 = 1/6 (120)(2^2) = 80 " kg" dot.op "m"^2 $
  (dato de la guía). *Esto es más fuerte que ser sólo principal:* como los
  tres momentos son iguales, el tensor es $I dot bold(1)$ —un múltiplo de la
  identidad— en *cualquier* terna de ejes por el centro, no sólo en ésta.
  Para el cubo, $bold(H)_G = I bold(omega)$ vale siempre, apunte $bold(omega)$
  para donde apunte.

  *(a) Velocidad angular.* El vértice está en $bold(r) = hat(i)+hat(j)+hat(k)$
  m (semiarista $=1$ m en cada dirección) y el empuje, alineado con la arista
  $x$, es $bold(F) = 4 hat(i)$ N. La cupla que produce respecto de $G$:
  $ bold(tau) = bold(r) times bold(F) = (hat(i)+hat(j)+hat(k)) times 4hat(i)
    = 4 hat(j) - 4 hat(k) " N" dot.op "m" $
  Como $bold(F)$ y por lo tanto $bold(tau)$ son constantes durante el
  encendido, el impulso angular es directo:
  $ Delta bold(H)_G = bold(tau) thin t = (4 hat(j) - 4 hat(k))(4)
    = 16 hat(j) - 16 hat(k) " N" dot.op "m" dot.op "s" $
  Y como el tensor es isótropo, $bold(omega) = Delta bold(H)_G \/ I$
  directamente, sin proyectar sobre ningún eje principal:
  $ bold(omega) = (16 hat(j) - 16 hat(k))/80 = 0,2 hat(j) - 0,2 hat(k) " rad/s",
    quad abs(bold(omega)) = 0,2 sqrt(2) approx 0,283 " rad/s" $
  a $45degree$ entre los ejes $y$ y $z$ (con signo opuesto), lejos de la
  dirección de la arista sobre la que empujó el impulsor: el vector cupla
  $bold(r) times bold(F)$ es perpendicular a $bold(F)$, no paralelo.

  *(b) Caudal másico.* Con $g_0 = 9,81 " m/s"^2$:
  $ dot(m) = F_E/(I_"sp" g_0) = 4/(50 times 9,81) = 4/(490,5)
    ==> dot(m) approx 8,16 times 10^(-3) " kg/s" $

  *(c) Cuánto tiempo sigue girando.* Para siempre. El encendido termina, y
  con él la única cupla externa; en el vacío no hay nada que frene al
  satélite. Y como el tensor es isótropo, esto no es sólo «no hay torque, así
  que $bold(omega)$ no cambia» —lo mismo valdría para cualquier cuerpo—: acá
  además $bold(H)_G$ queda paralelo a $bold(omega)$ para *cualquier* eje que
  el satélite adopte, así que ni siquiera hace falta que $bold(omega)$ esté
  sobre un eje principal para que el movimiento sea ese giro simple y
  estable. El módulo 14 va a mostrar que ésa es la excepción, no la regla.
]

#fig([El disco de la horquilla, ya visto en el módulo 12 (allá, para hallar
$bold(omega)$; acá, para hallar $bold(H)_G$). Los ejes $hat(i), hat(j),
hat(k)$, clavados a la horquilla, son en todo instante ejes principales del
disco: $hat(k)$ es su eje de simetría y $hat(i)$, $hat(j)$ son diámetros.],
fig-suma-omegas)

#ejemplo("El disco en la horquilla: el momento angular que no acompaña a omega")[
  _(Problema 2, punto 1, de la sección de cuerpo rígido. Mismo disco y misma
  horquilla del ejemplo del módulo 12: $omega_1$ constante sobre el eje del
  disco $hat(k)$, $omega_2$ constante sobre el eje vertical de la horquilla
  $hat(j)$, ejes $hat(i), hat(j), hat(k)$ solidarios a la horquilla.)_
  Calcular $bold(H)_G$ del disco.

  *Los ejes son principales, pero no todos iguales.* Al ser $hat(j)$ y
  $hat(k)$ perpendiculares y pasar por el centro del disco, y $hat(k)$ su eje
  de simetría, los tres son principales —a diferencia del cubo, acá los
  momentos *no* son iguales: uno es polar y los otros dos son diametrales.
  Para un disco delgado homogéneo de masa $m$ y radio $r$:
  $ I_z = 1/2 m r^2 " (polar, sobre " hat(k) ")", quad
    I_x = I_y = 1/4 m r^2 " (diametral, sobre " hat(i) " y " hat(j) ")" $

  Con $bold(omega) = omega_2 hat(j) + omega_1 hat(k)$ (sin componente sobre
  $hat(i)$) y la @m13-diagonal aplicada término a término:
  $ bold(H)_G = I_y omega_2 hat(j) + I_z omega_1 hat(k)
    = 1/4 m r^2 omega_2 hat(j) + 1/2 m r^2 omega_1 hat(k) $

  #clave[
    *$bold(H)_G$ no es paralelo a $bold(omega)$, aunque los dos estén escritos
    en los mismos dos ejes.* La razón entre componentes en $bold(omega)$ es
    $omega_2 \/ omega_1$; en $bold(H)_G$ es $(1/4 m r^2 omega_2)\/(1/2 m r^2
    omega_1) = omega_2 \/ (2 omega_1)$ — la mitad. $bold(H)_G$ está más cerca
    del eje $hat(k)$ que $bold(omega)$, exactamente porque $I_z = 2 I_x$ pesa
    el doble en esa dirección. Es la @m13-diagonal con $I_x != I_z$, en
    números: la demostración concreta de por qué la @m13-tensor no se reduce
    nunca a un escalar salvo que el cuerpo tenga los tres momentos iguales,
    como el cubo del ejemplo anterior.
  ]
]

== Lo que se usa después

1. *La @m13-diagonal, en ejes principales pegados al cuerpo.* El módulo 14
   deriva $bold(H)_G$ respecto del tiempo con la @m12-derivada, y para que
   $I_x$, $I_y$, $I_z$ no cambien mientras se deriva hace falta que los ejes
   giren *con* el cuerpo —o al menos acompañen a su eje de simetría—: de ahí
   salen las ecuaciones de Euler.

2. *La ec. 18.10 —la @m13-tensor sin diagonalizar.* Es la razón física de que
   $bold(H)_G$ tenga una derivada distinta de «$I$ veces $dot(bold(omega))$»:
   si $bold(H)_G$ y $bold(omega)$ fueran siempre paralelos, el cuerpo rígido
   en 3D no necesitaría nada nuevo respecto del movimiento plano.

3. *La @m13-energia.* Reaparece cuando el módulo 15 mida la precesión de la
   peonza simétrica: ahí $T$ y $bold(H)_G$ constantes son las dos cantidades
   conservadas que fijan la geometría del cono de precesión.
