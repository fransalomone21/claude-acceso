// =====================================================================
//  Modelo de parcialito 5 -- capitulo 18 del Beer (cuerpo rigido en 3D)
//  2026-10-28. Lo que Anibal dijo del parcialito del 29/10 (ANI-R13, de
//  memoria por Fran): «es del capitulo 18», el Problema Resuelto 18.6 (el
//  meteorito) como modelo -- planteo de ejes, theta entre el eje de simetria
//  y el momento angular, eje de precesion, ley de los senos --, los conos de
//  §18.11, y «torque de salida, amplificacion de torques». Mas el material
//  del 27/10 (ANI-R12) y los criterios de evaluacion (ANI-30 a 70).
//  Parte A al estilo de sus parcialitos; parte B numerica, porque esta vez
//  mando a ejercitar un problema con numeros. Cada numero, en validar.py.
// =====================================================================
#import "estilo.typ": *
#import "../apunte/biblioteca/figuras.typ" as figs

#show: documento.with(
  titulo: [Modelo de parcialito 5 — cuerpo rígido (Beer, cap. 18)],
  subtitulo: [Ángulos de Euler, ecuaciones de Euler, precesión estable, precesión libre con la ley de los senos y el torque de salida],
  encabezado: [Modelo de parcialito 5 — cuerpo rígido],
)

#caja([Qué entra: el capítulo 18, y de dónde sale cada pregunta], c-azul)[
  Aníbal dijo que el parcialito es del *capítulo 18 del Beer* y que pueden
  entrar cosas que tengan que ver. Mandó a hacer el *Problema Resuelto 18.6*
  (el meteorito: «hacer este problema es aprender a hacer el resto»), a
  revisar los conos de §18.11, y nombró el *torque de salida* y la
  *amplificación de torques*. Esto es lo que contó Fran de la clase, no una
  consigna escrita.

  #set par(justify: false)
  #table(
    columns: (1.5fr, 0.9fr, 1.4fr, 0.5fr),
    inset: (x: 4pt, y: 3pt),
    table.header(..([Tema], [Beer], [Dónde en el apunte], [Acá]).map(t => text(size: 8pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([Momento angular de un rígido, tensor, ejes principales], [§18.2], [módulo 19], [A2, B6]),
      ([Impulso y cantidad de movimiento en 3D], [§18.3], [módulo 21, «La receta del Beer»], [B6]),
      ([Derivada en ejes que giran; ecuaciones de Euler], [§18.5–18.6], [módulos 18 y 20], [A2]),
      ([Giróscopo y ángulos de Euler], [§18.9], [módulo 20], [A1]),
      ([Precesión estable], [§18.10], [módulo 20], [A3]),
      ([Cuerpo simétrico sin cupla, conos, directa y retrógrada], [§18.11, PR 18.6], [módulo 21], [A4, B6]),
      ([Torque de salida, amplificación (CMG)], [—, material de la cátedra], [módulos 17 y 20], [A5, B7]),
    ).flatten().map(c => text(size: 8pt, c)),
  )
]

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Modelo *largo a propósito*: el parcialito real va a ser una parte de esto.
  Tiempo sugerido: *2 horas*. En la parte A se corrige el razonamiento, y
  donde se pide un dibujo *el dibujo es la respuesta* (dirección, sentido y
  rótulos). La parte B es numérica, con calculadora. Toda aproximación se
  dice y se justifica. *Notación (la del Beer y la de Aníbal):* $bold(H)_G$
  es el momento angular respecto del centro de masa (la guía le dice
  *impulso angular*); $bold(omega)$ la velocidad angular del cuerpo y
  $bold(Omega)$ la de los ejes; en un cuerpo simétrico, $I$ es el momento de
  inercia *axial* e $I'$ el *transversal*.
]

= Parte A — conceptual

#consigna[
#ejercicio(1, [los ángulos de Euler sobre el giróscopo], [1,5])
#origen[Beer §18.9, figs. 18.15 y 18.16; el resumen manuscrito de Aníbal, hoja 2.]

Un rotor simétrico está montado en dos cardanes (balancines), con su centro
de masa fijo.

+ Dibuje el giróscopo y marque los tres ángulos de Euler $phi$, $theta$ y
  $psi$, diciendo qué pieza gira cada uno y alrededor de qué eje. Nombre las
  tres velocidades $dot(phi)$, $dot(theta)$, $dot(psi)$.
+ Con ejes $x y z$ pegados al balancín interior ($z$ sobre el eje del
  rotor), escriba $bold(omega)$ del rotor y $bold(Omega)$ de los ejes.
  ¿Por qué no son iguales?
+ ¿Por qué conviene usar esos ejes y no unos pegados al rotor?
+ En un satélite simétrico que se bambolea libre de cuplas, ¿cuáles de los
  tres ángulos cambian con el tiempo y cuál queda fijo?
]

#consigna[
#ejercicio(2, [la derivada de $bold(H)_G$ y las ecuaciones de Euler], [1])
#origen[Beer §18.5–18.6; hoja de la cátedra «Derivada de un vector en sistemas rotantes».]

+ Escriba $sum bold(M)_G$ en función de la derivada de $bold(H)_G$ vista
  desde unos ejes que giran con $bold(Omega)$. ¿La derivada de $bold(H)_G$
  depende del sistema desde el que se la mira? ¿Y el vector $bold(H)_G$?
+ Con los ejes clavados al cuerpo y principales, escriba la componente $x$
  de las ecuaciones de Euler. ¿Qué es el término que no tiene ninguna
  derivada, y por qué puede haber $dot(omega)_x != 0$ sin cupla en $x$?
]

#consigna[
#ejercicio(3, [precesión estable con el eje horizontal], [1])
#origen[Beer §18.10, ecs. 18.44 y 18.45, figs. 18.18 y 18.19.]

Un giróscopo con el eje de giro horizontal precesa de manera estable
alrededor de la vertical.

+ ¿Qué par hace falta para sostener ese movimiento? Dé su expresión y
  dibuje los tres ejes: giro, par y precesión.
+ Si el rotor girara el doble de rápido con el mismo par, ¿qué le pasa a la
  velocidad de precesión? ¿Y si se duplica la masa del rotor, con el mismo
  brazo?
]

#consigna[
#ejercicio(4, [los conos: directa o retrógrada], [1])
#origen[Beer §18.11, figs. 18.22 a 18.24 («para revisar», dijo Aníbal); ec. 18.49.]

Un cuerpo simétrico se mueve libre de cuplas, con $bold(omega)$ fuera de su
eje de simetría. Marque la opción correcta y justifique con un dibujo de los
dos conos.

#set enum(numbering: "a)")
+ Si el cuerpo es *achatado* ($I > I'$), el eje instantáneo queda más cerca
  del eje de simetría que $bold(H)_G$, y la precesión es directa.
+ Si el cuerpo es *achatado* ($I > I'$), $bold(omega)$ queda más lejos del
  eje de simetría que $bold(H)_G$, el cono corporal envuelve al espacial y
  la precesión es retrógrada.
+ La precesión necesita una cupla que la sostenga; sin cupla, el eje queda
  quieto.
+ Directa o retrógrada depende de la velocidad de giro, no de la forma.
]

#consigna[
#ejercicio(5, [torque de salida y amplificación], [1])
#origen[«Torque de salida, amplificación de torques» (Aníbal, para este parcialito); el giróscopo como actuador y sensor (material del 28/09); Lappas, Steyn y Underwood (2002).]

+ En un giróscopo de control de momento (CMG), ¿qué es el torque de
  entrada y qué el de salida? ¿Sobre qué ejes actúa cada uno?
+ ¿Por qué se dice que un CMG *amplifica* el torque? ¿Por qué una rueda de
  reacción del mismo tamaño no lo hace?
+ Se apaga el motor y el gimbal queda suelto, sobre una plataforma que gira.
  ¿El gimbal se queda quieto? Explique la animación del girocompás que
  subió la cátedra.
]

= Parte B — numérica

#consigna[
#ejercicio(6, [el meteorito y el satélite achatado], [3])
#origen[Mismo procedimiento que el Problema Resuelto 18.6 del Beer, con un satélite achatado en vez de alargado.]

Un satélite de $500$ kg, simétrico respecto de su eje $z$, gira libre
alrededor de él a $omega_0 = 1,0$ rad/s. Sus momentos de inercia
centrales son $I = I_z = 400$ kg·m² e $I' = I_x = I_y = 250$ kg·m². Un
meteorito de $50$ g, que viaja a $3000$ m/s relativo al satélite en el
sentido de $-z$, se incrusta en el punto $C$, en $bold(r)_C = (0; 1,2; 0)$ m
desde el centro de masa $G$.

+ Justifique qué se conserva en el choque y por qué se puede despreciar la
  masa del meteorito.
+ Calcule $bold(H)_G$ después del choque. ¿Cuál es el eje de precesión? Halle
  el ángulo $theta$ entre ese eje y el eje de simetría.
+ Calcule $bold(omega)$ después del choque y el ángulo $gamma$ que forma con
  el eje de simetría.
+ Con la ley de los senos, halle las velocidades de precesión y de giro. ¿La
  precesión es directa o retrógrada? Dibuje los conos.
+ ¿Cuánto cambia la velocidad del centro de masa?
+ Discuta cómo depende el ángulo del bamboleo de la velocidad del meteorito,
  de dónde pega y de lo rápido que giraba el satélite. Opine: si usted
  diseña un satélite que tiene que mantener su eje aunque lo golpeen, ¿le
  conviene girar más rápido o más lento? ¿Achatado o alargado?
]

#consigna[
#ejercicio(7, [el CMG de un microsatélite], [1,5])
#origen[El CMG de Lappas, Steyn y Underwood (2002), material de la cátedra del 28/09.]

Un CMG tiene un rotor con momento angular $h = 0,35$ N·m·s, y su gimbal gira
a $dot(delta) = 0,12$ rad/s con el eje del gimbal perpendicular a $bold(h)$.
El gimbal, con todo lo que gira con él, tiene $I_g = 1,0 times 10^(-4)$ kg·m²
sobre su eje y el motor lo lleva de cero a $0,12$ rad/s en $0,5$ s.

+ Calcule el torque de salida que recibe el satélite y diga su dirección.
+ Calcule el torque que tiene que hacer el motor del gimbal para acelerarlo,
  y la amplificación.
+ ¿Qué torque daría una rueda de reacción movida por ese mismo motor?
]

#pagebreak()

= Resolución

== Ejercicio 1

+ *Balancín exterior:* gira $phi$ alrededor del eje fijo (vertical); es la
  *precesión*, $dot(phi)$. *Balancín interior:* gira $theta$ alrededor de su
  propio eje, la *línea de nodos*, montada en el exterior; $theta$ es el
  ángulo entre el eje fijo y el eje del rotor, la *nutación*, $dot(theta)$.
  *Rotor:* gira $psi$ alrededor de su eje de simetría; el *spin* o giro
  propio, $dot(psi)$. Una articulación, un ángulo.
+ Con $bold(K) = -sin theta thin hat(i) + cos theta thin hat(k)$ el versor del
  eje fijo escrito en esos ejes:
  $ bold(omega) = dot(phi) bold(K) + dot(theta) hat(j) + dot(psi) hat(k), quad quad bold(Omega) = dot(phi) bold(K) + dot(theta) hat(j) $
  La diferencia es $dot(psi) hat(k)$: los ejes del balancín interior
  precesan y nutan con el rotor, pero *no giran con el spin* («ojo, no gira
  en $psi$», la nota de Aníbal). Por eso «no siempre $bold(Omega) =
  bold(omega)$».
+ Porque el rotor es simétrico: cualquier eje transversal es principal, así
  que en los ejes del balancín los momentos de inercia ya son constantes
  ($I'$, $I'$, $I$) sin tener que seguir el spin, que es lo más rápido y lo
  menos interesante. Pegados al rotor, los ejes $x$ e $y$ darían vueltas a
  la velocidad del spin y las cuentas se llenarían de senos de $psi$.
+ Queda fijo $theta$, el ángulo entre el eje del satélite y $bold(H)_G$ (que
  hace de eje fijo): el eje barre un cono de abertura constante. Cambian
  $phi$ y $psi$, los dos a ritmo constante: la precesión y el giro. No hay
  nutación ($dot(theta) = 0$): nadie empuja.

== Ejercicio 2

+ $sum bold(M)_G = (dot(bold(H))_G)_"móvil" + bold(Omega) times bold(H)_G$.
  El vector $bold(H)_G$ es uno solo para todos; lo que depende del sistema es
  su *derivada*: el que gira con los ejes ve una, el de afuera ve esa más
  $bold(Omega) times bold(H)_G$. La ley vale con la derivada del inercial; los
  ejes móviles son sólo una manera de calcularla.
+ $sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z$. El término sin
  derivada es el *giroscópico*: viene del transporte ($bold(Omega) times
  bold(H)$ con $bold(Omega) = bold(omega)$). Con $sum M_x = 0$ queda $I_x
  dot(omega)_x = (I_y - I_z) omega_y omega_z$: si el cuerpo gira a la vez
  en $y$ y en $z$ y tiene momentos distintos, $omega_x$ cambia sin que nadie
  empuje en $x$. Es lo que hace inestable al eje intermedio.

== Ejercicio 3

+ Con $theta$, $dot(phi)$ y $dot(psi)$ constantes, $bold(H)_O$ es fijo en los
  ejes móviles y sólo queda el transporte. Con $theta = 90degree$ (Beer ec.
  18.45):
  $ sum bold(M)_O = I dot(psi) dot(phi) thin hat(j) $
  Sobre la línea de nodos: perpendicular al eje de precesión (vertical) y al
  de giro (horizontal). Giro, par y precesión forman una tríada derecha: el
  spin «persigue» al par.
+ Con el mismo par, $dot(phi) = M \/ (I dot(psi))$: el doble de spin da *la
  mitad* de precesión. Si se duplica la masa con el mismo brazo, el par del
  peso se duplica y $I$ también: la precesión *no cambia*.

== Ejercicio 4

La correcta es la *b)*. En palabras: el achatado es más «pesado de girar»
sobre su eje, así que por cada rad/s guarda más momento angular sobre el eje
que de costado; $bold(H)_G$ se acerca al eje y $bold(omega)$ queda más
lejos. Con vectores, la ec. 18.49, $tan gamma = (I \/ I') tan theta$:
si $I > I'$, $gamma > theta$, o sea $bold(omega)$ cae más lejos del eje que
$bold(H)_G$. El cono espacial (alrededor de $bold(H)_G$, fijo) queda adentro
del corporal (alrededor del eje del cuerpo): el corporal lo envuelve y rueda
sobre él, y spin y precesión tienen sentidos opuestos (Beer fig. 18.24).
La a) mezcla los dos casos: es el alargado ($I < I'$) el que tiene $gamma <
theta$ y precesión directa. La c) es el error de pensar que la precesión
necesita una cupla: sin cupla $bold(H)_G$ queda fijo y el eje igual precesa
a su alrededor. La d) es falsa: el signo lo decide $I' - I$, la forma.

#figure(figs.fig-conos, caption: [Los conos del caso alargado (precesión
directa, Beer fig. 18.23): tangentes por afuera a lo largo de
$bold(omega)$. En el achatado de la opción b), el corporal envuelve al
espacial.])

== Ejercicio 5

+ El rotor gira a velocidad constante con momento angular $bold(h)$ grande.
  El *torque de entrada* lo pone el motor del gimbal, sobre el eje del
  gimbal, para girarlo a $dot(delta)$. El *torque de salida* es el que
  recibe el satélite, sobre el *tercer eje*, perpendicular al gimbal y al
  rotor: el rotor cambia su momento a razón $dot(bold(delta)) times bold(h)$
  y el satélite recibe el opuesto, de módulo $h dot(delta)$. Es el
  giróscopo usado al revés que el del peso: giro de entrada, torque de
  salida.
+ Porque el motor sólo tiene que vencer la inercia y el rozamiento del
  gimbal sobre su eje (a velocidad constante, casi nada), mientras que el
  torque de salida es $h dot(delta)$, proporcional al $bold(h)$ grande que ya
  estaba guardado en el rotor. Una rueda de reacción da torque cambiando el
  *módulo* de su momento angular: su torque de salida es el del motor que la
  acelera o la frena, amplificación uno.
+ No se queda quieto. La plataforma le obliga al $bold(h)$ a girar con ella,
  eso pide un torque sobre el eje del gimbal, y como nadie lo pone, el
  gimbal arranca solo (en el Ejercicio 3 de la guía, sin cupla, $-100$
  rad/s² en el primer instante). Gira para el lado que pone el eje del rotor
  *paralelo* al giro de la plataforma, se pasa y oscila alrededor de esa
  posición, como un péndulo. Es el girocompás: con la Tierra de plataforma y
  algo de rozamiento que apague la oscilación, el eje termina apuntando al
  norte.

== Ejercicio 6

#idea[
  El satélite giraba con $bold(H)_G$ sobre su eje. El meteorito pega lejos
  del eje y le suma un pedacito de momento angular *de costado*: $bold(H)_G$
  queda inclinado. Desde ese instante no hay torque, así que $bold(H)_G$ se
  queda quieto en su dirección nueva y el satélite se pone a bambolear
  alrededor de él. Es la analogía con la órbita que pide Aníbal: un empujón
  perpendicular a $bold(p)$ le dobla la velocidad; uno perpendicular a
  $bold(H)$ le dobla el eje. Lo que sigue es ponerle números.
]

+ En el choque sobre el sistema satélite + meteorito no hay impulso externo:
  se conservan la cantidad de movimiento y el momento angular respecto de
  $G$ (Beer §18.3: las cantidades de movimiento antes y después son
  equipolentes). El meteorito pesa $0,05 \/ 500 = 10^(-4)$ veces el
  satélite: no mueve $G$ ni cambia los momentos de inercia de manera
  medible.
+ $bold(r)_C times m_0 bold(v)_0 = (0; 1,2; 0) times (0; 0; -150) = (-180; 0; 0)$
  kg·m²/s. Con el del satélite, $I omega_0 hat(k) = 400 hat(k)$:
  $ bold(H)_G = (-180; 0; 400) " kg" dot.op "m"^2"/s", quad H_G = 438,6 " kg" dot.op "m"^2"/s" $
  El eje de precesión es la dirección de $bold(H)_G$, fija en el espacio, en
  el plano $x z$ e inclinado hacia $-x$: $tan theta = 180 \/ 400$, $theta =
  24,2degree$.
+ Componente a componente: $omega_x = -180 \/ 250 = -0,72$ rad/s, $omega_y =
  0$, $omega_z = 400 \/ 400 = 1,0$ rad/s. $omega = 1,232$ rad/s y $tan gamma
  = 0,72 \/ 1,0$, $gamma = 35,8degree$. Control con la ec. 18.49: $(400 \/
  250) tan 24,2degree = 0,72$. Coincide.
+ $dot(phi) = omega sin gamma \/ sin theta = 1,754$ rad/s, y $dot(psi) =
  omega sin(theta - gamma) \/ sin theta = -0,600$ rad/s. El spin sale
  negativo porque $gamma > theta$: *retrógrada*, como corresponde a un cuerpo
  achatado ($I > I'$). Una vuelta de precesión cada $3,58$ s. Controles:
  $dot(phi) = H_G \/ I' = 438,6 \/ 250$ y $dot(psi) = ((I' - I)\/I) dot(phi)
  cos theta$ dan lo mismo. Los conos: el corporal envuelve al espacial.
+ $Delta v_G = m_0 v_0 \/ (m + m_0) = 0,30$ m/s, en el sentido de $-z$: el
  satélite casi no se desvía, pero queda bamboleando en un cono de $24degree$.
+ $tan theta = (m_0 v_0 d) \/ (I omega_0)$, con $d$ la distancia del punto de
  impacto al eje (acá $1,2$ m). Más rápido o más lejos del eje pega el
  meteorito, más bamboleo; si pega sobre el eje, o apuntando a $G$, nada. Y
  cuanto más momento angular tenía el satélite, $I omega_0$, *menos* lo
  inclina el mismo golpe: es la rigidez giroscópica, la razón de los
  satélites estabilizados por giro. *Opinión de ingeniero:* girar rápido, y
  sobre el eje de *mayor* momento de inercia (achatado), porque con las
  antenas flexibles que disipan energía un alargado termina dando tumbos,
  como el Explorer 1. Este satélite ya está bien elegido; lo que le falta es
  un amortiguador de nutación que mate el bamboleo.

#alternativa([sin triángulo, por componentes])[
  La ley de los senos es la mirada geométrica del Beer. Por componentes sale
  lo mismo sin dibujar: la precesión es $dot(phi) = H_G \/ I' = 438,6 \/ 250
  = 1,754$ rad/s, y como $omega_z = dot(psi) + dot(phi) cos theta$ (la
  componente axial de $bold(omega)$ recibe el giro y un pedazo de la
  precesión), $dot(psi) = omega_z - dot(phi) cos theta = 1,0 - 1,754 dot.op
  0,912 = -0,600$ rad/s. Dos caminos, el mismo número.
]

== Ejercicio 7

+ $tau_"salida" = h dot(delta) = 0,35 dot.op 0,12 = 0,042$ N·m, sobre el eje
  perpendicular al gimbal y al rotor; el satélite recibe $-dot(bold(delta))
  times bold(h)$, el opuesto de lo que cambia el rotor.
+ $dot.double(delta) = 0,12 \/ 0,5 = 0,24$ rad/s², y $tau_"motor" = I_g
  dot.double(delta) = 2,4 times 10^(-5)$ N·m. Amplificación:
  $0,042 \/ (2,4 times 10^(-5)) = 1750$. Y una vez que el gimbal gira
  parejo, el motor casi no hace nada mientras la salida sigue.
+ Una rueda de reacción movida por el mismo motor da $2,4 times 10^(-5)$
  N·m: su torque de salida es el del motor. Ésa es toda la ventaja del CMG.
