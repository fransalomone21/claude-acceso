// =====================================================================
//  Guía de estudio para el parcialito de cuerpo rígido -- 2026-10-28
//  La lista «Temas de CR» (fuentes/TEMARIO.md, sección Cuerpo rígido),
//  renglón por renglón: la idea, la fórmula y la trampa, con el material
//  que subió la cátedra (clase del 19/10 y el resumen manuscrito del cap. 18,
//  el Ejercicio 3 sin cupla, la hoja de la derivada en sistemas rotantes y
//  el cuaderno del Beer 18.127). Sale de los módulos 18 a 21 del apunte; los
//  criterios de evaluación, de catedras/fisica-espacial/CRITERIOS.md.
//  Cada número, en validar.py; cada pregunta, en una página
//  (verificar-consignas.py).
//  2026-10-29 (v4): las cuatro hojas manuscritas del cap. 18 y la figura
//  «Precesiones» que subió Aníbal, explicadas hoja por hoja; el capítulo 18
//  sección por sección (§18.1 a 18.11, con ecuación y página medidas en el
//  PDF del Beer); las figuras de figuras-cr3d.typ; y en cada tema la versión
//  formal, la simple y la de las manos (pedido de Fran: «que se pueda
//  explicar con los dedos y las manos»).
// =====================================================================
#import "estilo.typ": *
#import "../apunte/biblioteca/figuras.typ": fig-conos
#import "figuras-cr3d.typ": fig-cardanes, fig-precesion-estable, fig-precesiones, fig-HO

#show: documento.with(
  titulo: [Guía para el parcialito — cuerpo rígido],
  subtitulo: [La lista de temas de CR renglón por renglón, el material nuevo de Aníbal y las preguntas que pueden caer],
  encabezado: [Guía para el parcialito — cuerpo rígido],
)

#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)
#let tabla(cols, ..celdas) = {
  set par(justify: false)
  align(center, table(columns: cols, inset: (x: 6pt, y: 3.5pt), align: left,
    ..celdas.pos().map(c => text(size: 9.5pt, c))))
}
#let manos(cuerpo) = caja([Con las manos], c-ambar, cuerpo)
#let hoja(cuerpo) = caja([La hoja de Aníbal, renglón por renglón], c-viole, cuerpo)
#let pregunta(n, q, r) = consigna[
  #block(above: 10pt, below: 6pt, sticky: true, text(fill: c-azul, weight: "bold")[#(n). #q])
  #r
]

#caja([Cómo usar esto], c-azul)[
  Un tema por sección, en el orden de la lista de cuerpo rígido (Beer caps.
  14, 15 y 18). Cada uno con *la idea* en palabras, *la fórmula* y *la
  trampa*. El desarrollo entero está en el apunte, módulos 18 a 21; acá va
  lo que tenés que tener en la cabeza al entrar, más lo que Aníbal subió
  esta semana: su resumen a mano del capítulo 18, el Ejercicio 3 «sin
  torque externo», la hoja de la derivada en sistemas rotantes y el
  cuaderno del Beer 18.127.

  *Qué esperar.* Aníbal habló del parcialito dos veces (lo contó Fran de la
  clase). La primera: «*18.6 y precesión estable*, y capaz todo el 18»:
  §18.6 son las ecuaciones de Euler (sección 5) y §18.10 la precesión
  estable (sección 7). La segunda: que es del *capítulo 18 del Beer*, que
  pueden entrar cosas relacionadas, y mandó a hacer el *Problema Resuelto
  18.6* (el meteorito), a revisar los conos de §18.11 y a mirar el *torque de
  salida* y la *amplificación de torques*. Ojo: «18.6» es a la vez la sección
  y el problema resuelto; acá están los dos. De los parcialitos anteriores:
  preguntas cortas encadenadas, *el dibujo es la respuesta*, poca cuenta.
  Esta vez puede venir un problema con números: el 18.6 está en la sección 8,
  y en el modelo de parcialito 5 hay de todo (la parte C, Euler y precesión
  estable con números).

  *Lo último que subió Aníbal* (el resumen manuscrito del capítulo 18, cuatro
  hojas, y la figura suelta «Precesiones») está entero acá, *hoja por hoja*,
  en las cajas violetas: la hoja 1 en las secciones 4 y 5, las hojas 2 y 3 en
  la 6, la hoja 4 en la 7 y la figura en la 8. Y cada tema viene en tres
  capas: *la idea* en simple, *la fórmula* formal y una caja ámbar *con las
  manos*, para poder explicarlo con los dedos delante de Aníbal, que es como
  más se entiende un giróscopo.
]

= 0. Lo que quiere Aníbal: siete ideas, dichas simple y después demostradas
#origen[Sus criterios: concepto antes que deducción, «no se compliquen», intuición en lo antiintuitivo, la analogía giróscopo–órbita, la simetría para no calcular. Cada idea va primero en palabras y después con vectores.]

#notacion[
  *Las letras de toda la guía, antes de la primera fórmula.* Son las del
  Beer, que son las de la cátedra; cada sección presenta además las suyas,
  donde aparecen.
  // simbolos: G, m, rbar, vbar, abar, O, F, v, p
  - *$G$* es el centro de masa del cuerpo y *$m$* su masa total. Una barra
    arriba quiere decir «del centro de masa»: $overline(bold(r))$,
    $overline(bold(v))$ y $overline(bold(a))$ son la posición, la velocidad y
    la aceleración de $G$. *$O$* es un punto fijo (un pivote, o el origen
    desde donde se mide). $bold(F)$ es una fuerza externa, $bold(v)$ una
    velocidad cualquiera y $bold(p) = m bold(v)$ la cantidad de movimiento.
  // simbolos: omega, H_G, H, M_G, M, Hdot_G, L
  - *$bold(omega)$* es la velocidad angular del cuerpo: su dirección es el
    eje alrededor del cual gira en ese instante (regla de la mano derecha) y
    su módulo, cuántos radianes por segundo. *$bold(H)_G$* es el momento
    angular del cuerpo respecto de $G$: la suma, partícula por partícula,
    del momento de su cantidad de movimiento medido desde $G$. Sin
    subíndice, $bold(H)$ es un momento angular cualquiera; sin negrita,
    $H_G$ es el módulo. *$sum bold(M)_G$* es la suma de los momentos
    (torques) de las fuerzas externas respecto de $G$, y $bold(M)$ sin
    subíndice, un momento cualquiera. Un punto arriba es derivada respecto
    del tiempo: *$dot(bold(H))_G$* es cuánto cambia $bold(H)_G$ por segundo
    (la «razón de cambio» del Beer). Aníbal, en sus hojas, le dice
    $bold(L)$ al momento angular, y la guía de problemas, «impulso angular».
  // simbolos: Omega
  - *$bold(Omega)$* es la velocidad angular de los *ejes* desde los que se
    mira, que pueden girar distinto que el cuerpo. Aníbal lo subraya: *«no
    siempre $bold(Omega) = bold(omega)$»*.
  // simbolos: I, I', omega_x, omega_z, H_x, H_z
  - En un cuerpo con eje de simetría los ejes $x y z$ van pegados a él, con
    *$z$ sobre el eje de simetría* y $x$ perpendicular. *$I$* es el momento
    de inercia *axial* (alrededor de $z$) e *$I'$* el *transversal*
    (alrededor de cualquier eje perpendicular que pase por $G$). $omega_x$,
    $omega_z$, $H_x$ y $H_z$ son las componentes de $bold(omega)$ y de
    $bold(H)_G$ sobre esos ejes. Ojo: el apunte usó $I$ e $I'$ al revés
    hasta el 27/10.
  // simbolos: theta, gamma, K, phidot, psidot
  - Cuando el cuerpo simétrico se bambolea, su eje da vueltas alrededor de
    otro eje, el *de precesión*, cuyo versor es *$bold(K)$*; $hat(k)$ es el
    versor del eje del cuerpo. *$theta$* es el ángulo entre el eje del
    cuerpo y $bold(H)_G$, y *$gamma$* el ángulo entre el eje del cuerpo y
    $bold(omega)$. *$dot(phi)$* es la velocidad de precesión (qué tan rápido
    da vueltas el eje del cuerpo alrededor de $bold(K)$) y *$dot(psi)$* el
    *spin*, el giro propio del cuerpo sobre su eje. Los ángulos de los que
    salen esas dos derivadas se presentan en la sección 6.
]

*1. Sin cupla, el momento angular no se mueve.* En palabras: nadie lo
empuja, así que $bold(H)_G$ apunta siempre al mismo lugar del cielo, y todo
lo que se mueva se mueve *alrededor* de él. Con vectores: $sum bold(M)_G =
dot(bold(H))_G = 0 arrow.r.double bold(H)_G = "cte"$ (Beer §18.11). Es la
«dirección fija» de las figuras del libro.

*2. El momento angular no tiene por qué apuntar para donde gira el
cuerpo.* En palabras: el cuerpo es más «pesado de girar» en una dirección
que en otra, así que por cada rad/s de giro guarda más momento angular en
la dirección más pesada; $bold(H)_G$ se inclina hacia el eje de mayor
inercia y se separa de $bold(omega)$. Con vectores: en ejes principales
(los ejes en los que el cuerpo está «parejo», sin productos de inercia;
sección 4) $H_x = I' omega_x$, $H_z = I omega_z$; si $I != I'$, $bold(H)_G$ y
$bold(omega)$ sólo son paralelos cuando $bold(omega)$ va sobre un eje
principal.

*3. Si $bold(H)_G$ no está sobre el eje del cuerpo, el cuerpo se bambolea.*
En palabras: el eje de simetría, $bold(omega)$ y $bold(H)_G$ quedan en un
mismo plano, y ese plano da vueltas alrededor de $bold(H)_G$: el eje del
cuerpo barre un cono. Eso es la precesión libre, y no hace falta nadie que
la sostenga. Con vectores: $tan gamma = (I \/ I') tan theta$ y $dot(phi) =
H_G \/ I'$ (Beer ecs. 18.49 y siguientes).

*4. Un golpe de costado inclina el momento angular, como un empujón
lateral le dobla la velocidad a un satélite.* En palabras: el meteorito le
suma a $bold(H)_G$ un pedacito perpendicular, $bold(H)_G$ queda torcido
respecto del eje, y desde ese instante el satélite se bambolea alrededor de
la nueva dirección. Es la analogía que pidió Aníbal: una fuerza
perpendicular a $bold(p)$ le cambia la dirección y no el tamaño; un impulso
angular perpendicular a $bold(H)$, lo mismo. Con vectores: si el meteorito
tiene masa $m_0$ y velocidad $bold(v)_0$ y pega en el punto que está en
$bold(r)$ medido desde $G$, el momento angular justo después del golpe
($bold(H)_G^+$) es el de justo antes ($bold(H)_G^-$) más el momento de la
cantidad de movimiento que trae el meteorito:
// simbolos: m_0, v_0, r
$bold(H)_G^+ = bold(H)_G^- + bold(r) times m_0 bold(v)_0$ (Beer §18.3: sin
impulso externo, antes y después son equipolentes).

*5. La precesión y el giro se sacan con un triángulo.* En palabras:
$bold(omega)$ se puede ver como la suma de dos giros, uno alrededor del eje
de precesión y otro alrededor del eje del cuerpo; como esos dos ejes no son
perpendiculares, es un triángulo cualquiera, y se resuelve con el teorema
del seno. Ésa es toda la matemática del 18.6. Con vectores: $bold(omega) =
dot(phi) bold(K) + dot(psi) hat(k)$, y $omega \/ sin theta = dot(phi) \/
sin gamma = dot(psi) \/ sin(theta - gamma)$. Y por componentes, sin
triángulo: $dot(phi) = H_G \/ I'$ y, como la componente axial de
$bold(omega)$ junta el giro y un pedazo de la precesión, $dot(psi) =
omega_z - dot(phi) cos theta$. Los dos caminos dan el mismo número; el del
triángulo es el del libro, el de componentes es el que no necesita dibujo.

*6. Cuanto más rápido gira, menos lo tuerce un golpe.* En palabras: el
mismo empujón de costado inclina menos a un momento angular grande, como el
mismo viento desvía menos a una bala que a una pelota. Por eso los satélites
se estabilizan haciéndolos girar, y sobre el eje de *mayor* inercia (el
Explorer 1, alargado y con antenas que disipaban, terminó dando tumbos). Con
vectores: si el cuerpo giraba a $omega_0$ sobre su eje y el meteorito pega
con la velocidad paralela al eje, a una distancia $d$ de él, el golpe le
agrega a $bold(H)_G$ un pedazo transversal $m_0 v_0 d$ contra el axial $I
omega_0$ que ya tenía:
// simbolos: omega_0
$tan theta = m_0 v_0 d \/ (I omega_0)$.

*7. Girarle la dirección a un momento angular grande cuesta, o da, un
torque grande.* En palabras: el giróscopo no se resiste a girar, se
resiste a que le cambien el eje, y contesta a $90degree$. Si uno le gira el
eje a la fuerza, aparece un torque perpendicular (giro de entrada, torque
de salida: el CMG); si uno le aplica un torque, el eje gira perpendicular
(torque de entrada, giro de salida: la precesión). Con vectores: $sum
bold(M) = bold(Omega) times bold(H)$, la misma ecuación leída para los dos
lados.

#manos[
  *Las dos reglas de la mano derecha que alcanzan para todo el capítulo.*

  *1. Un giro es un vector (una mano).* Cerrá la mano derecha con el pulgar
  parado: los dedos doblados siguen el sentido en que gira el cuerpo y el
  pulgar es el vector ($bold(omega)$, $bold(H)$, $dot(psi) hat(k)$, $dot(phi)
  bold(K)$). Para leer un dibujo, al revés: poné el pulgar sobre la flecha y
  los dedos te dicen para dónde gira.

  *2. Un producto vectorial son tres dedos.* Pulgar, índice y mayor abiertos
  en ángulo recto, como los ejes $x$, $y$, $z$: *pulgar $times$ índice $=$
  mayor* (y en rueda: índice $times$ mayor $=$ pulgar, mayor $times$ pulgar
  $=$ índice). Con eso sale el giróscopo entero: *pulgar = el giro*
  ($dot(psi) hat(k)$, o $bold(H)$), *índice = el par* ($sum bold(M)$),
  *mayor = la precesión* ($dot(phi) bold(K)$). Giro por par da precesión: el eje
  del rotor «persigue» al par. Y leído en rueda, precesión por giro da el par:
  $bold(Omega) times bold(H) = sum bold(M)$, la fórmula de la precesión
  estable.
]

= El capítulo 18 entero, sección por sección
#origen[Secciones, ecuaciones y páginas medidas en el PDF del Beer (9.ª ed. en castellano), no copiadas de una lista. La última columna dice dónde está cada una en esta guía.]

// simbolos: H_O, I_O, M_O, Hdot_O
Las letras nuevas de la tabla se presentan en su sección; por adelantado:
$bold(H)_O$ es el momento angular respecto del punto fijo $O$, $bold(I)_O$
el tensor de inercia calculado respecto de $O$ y $sum bold(M)_O$ la suma de
los momentos externos respecto de $O$. Un paréntesis con subíndice, como
$(dot(bold(H))_G)_(G x y z)$, es la derivada *vista desde los ejes $G x y
z$, que giran* con el cuerpo: derivar las componentes y nada más (sección 3).

#tabla((auto, 1fr, auto, auto),
  [*§*], [*qué dice, en una línea*], [*ec. / pág.*], [*acá*],
  [18.1], [Introducción: $sum bold(F) = m overline(bold(a))$ y $sum bold(M)_G = dot(bold(H))_G$ siguen valiendo; lo nuevo es calcular $bold(H)_G$ y su derivada en 3D.], [18.1–18.2], [1, 5],
  [18.2], [$bold(H)_G$ de un rígido con el tensor de inercia (con productos de inercia); en ejes principales, diagonal; $bold(H)_O = overline(bold(r)) times m overline(bold(v)) + bold(H)_G$; con punto fijo, $bold(H)_O = bold(I)_O bold(omega)$.], [18.7, 18.11, 18.13; págs. 1152–1155], [4],
  [18.3], [Impulso y cantidad de movimiento en 3D: antes $+$ impulsos $=$ después, para $m overline(bold(v))$ y para $bold(H)_G$ a la vez (fig. 18.6).], [pág. 1156], [4 bis, 8],
  [18.4], [Energía cinética en 3D: la del centro de masa más la de rotación, con productos de inercia o, en ejes principales, sin ellos.], [18.14–18.17, 18.20; pág. 1157], [4 bis],
  [18.5], [La derivada de $bold(H)_G$ con ejes que giran: $dot(bold(H))_G = (dot(bold(H))_G)_(G x y z) + bold(Omega) times bold(H)_G$; los ejes pueden girar *menos* que el cuerpo.], [18.22; pág. 1169], [3, 5],
  [18.6], [Ecuaciones de Euler (ejes principales, $bold(Omega) = bold(omega)$) y la extensión de d'Alembert: las fuerzas externas equivalen a $m overline(bold(a))$ en $G$ más la cupla $dot(bold(H))_G$.], [18.25; pág. 1170], [5],
  // simbolos: Hdot_O
  [18.7], [Punto fijo $O$: momentos respecto de $O$ (la reacción no aparece), $sum bold(M)_O = (dot(bold(H))_O)_(O x y z) + bold(Omega) times bold(H)_O$.], [18.28; pág. 1172], [5],
  [18.8], [Eje fijo: con $omega$ constante, si hay productos de inercia los cojinetes hacen cupla (desbalance dinámico).], [18.29; pág. 1172], [5],
  [18.9], [El giróscopo en cardanes y los ángulos de Euler; $bold(omega)$, $bold(Omega)$ y $bold(H)_O$ en los ejes del balancín interior; las ecuaciones generales.], [18.33–18.39; págs. 1187–1188], [6],
  [18.10], [Precesión estable: $theta$, $dot(phi)$, $dot(psi)$ constantes; $sum bold(M)_O = bold(Omega) times bold(H)_O$; con $theta = 90degree$, $I dot(psi) dot(phi)$.], [18.40–18.45; pág. 1189], [7],
  [18.11], [Cuerpo simétrico sin cupla: $bold(H)_G$ fijo, precesión libre, conos, directa y retrógrada.], [18.46–18.52; págs. 1190–1191], [8],
)

= 1. Sistemas de partículas: lo que se arrastra del cap. 14
#origen[Beer §14.2 a 14.6, 14.9 y 14.12 — «ojo!!! notación: L es H y P es L»]

*La idea.* Todo lo de un cuerpo rígido sale de sumar partículas. Las
fuerzas internas se cancelan de a pares, y quedan dos leyes que valen para
*cualquier* sistema, rígido o no:

$ sum bold(F) = m overline(bold(a)), quad quad sum bold(M)_G = dot(bold(H))_G $

El centro de masa se mueve como si toda la masa y todas las fuerzas
estuvieran en él; la rotación alrededor de $G$ la decide $bold(H)_G$.
Sin fuerzas externas se conserva la cantidad de movimiento; sin momentos
externos respecto de $G$, $bold(H)_G$.

#trampa[
  *Notación del Beer:* su $bold(L)$ es la cantidad de movimiento ($m
  bold(v)$) y su $bold(H)$ el momento angular. «Momento resultante alrededor
  de $G$» quiere decir *respecto de* $G$. Y $bold(H)_G$ da lo mismo medido
  con las velocidades absolutas que con las relativas a $G$ (el Beer llama
  // simbolos: H'_G
  $bold(H)'_G$ al de las relativas, y $bold(H)_G = bold(H)'_G$): por eso se puede trabajar desde el centro de masa. La
  energía cinética se parte en la del centro de masa más la relativa a él.
]

= 2. Qué es un cuerpo rígido y cómo se mueve
#origen[Beer §15.1 a 15.3, 15.7 y 15.12 — apunte, módulo 18]

*La idea.* Rígido: la distancia entre dos puntos cualesquiera no cambia.
Consecuencia que Aníbal dijo en clase: *todos sus puntos tienen la misma
velocidad angular*. Y con un punto fijo, *todo* movimiento es, en cada
instante, una rotación alrededor de un eje que pasa por ese punto: el *eje
instantáneo*, que es la dirección de $bold(omega)$.

*Con un punto fijo.* Sea $bold(r)$ la posición de un punto cualquiera del
cuerpo, medida desde el punto fijo. Ese punto da vueltas en círculo
alrededor del eje instantáneo, así que su velocidad $bold(v)$ es
perpendicular al eje y a $bold(r)$, y su módulo es $omega$ por la distancia
al eje. Eso es justo un producto vectorial:

$ bold(v) = bold(omega) times bold(r) $

*Sin punto fijo* (el cuerpo además se traslada) se comparan dos puntos
// simbolos: A, B, v_A, v_B, r_B/A
cualesquiera del cuerpo, $A$ y $B$: $bold(v)_A$ y $bold(v)_B$ son sus
velocidades y $bold(r)_(B\/A)$ el vector que va de $A$ a $B$. Como la
distancia entre los dos no cambia, visto desde $A$ el punto $B$ sólo puede
girar alrededor de $A$, y con la misma $bold(omega)$ de todo el cuerpo. Es
la fórmula de arriba con $A$ haciendo de punto fijo, más lo que $A$ ya se
mueve:

$ bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B\/A) $

O sea: el movimiento de un rígido es *trasladarse con un punto más girar
alrededor de él*, y el giro es el mismo cualquiera sea el punto que se
elija. Con $A$ fijo ($bold(v)_A = 0$) vuelve la primera.

- *Las velocidades angulares se suman* como vectores: en el disco que gira
  en una horquilla que gira, si $bold(omega)_1$ es la de la horquilla y
  // simbolos: omega_1, omega_2
  $bold(omega)_2$ la del disco respecto de la horquilla, la del disco es
  $bold(omega) = bold(omega)_1 + bold(omega)_2$.
  *Las rotaciones finitas no*: girar 90° en $x$ y después en $y$ no es lo
  mismo que al revés. Probalo con un libro.
- *El eje instantáneo se mueve*, y deja dos conos: el *espacial* (lo que
  barre $bold(omega)$ visto desde afuera) y el *corporal* (visto desde el
  cuerpo). El movimiento es el cono corporal *rodando sin deslizar* sobre el
  espacial.

#figure(fig-conos, caption: [Cono espacial y cono corporal, tangentes a lo
largo de $bold(omega)$. Así se ve un cuerpo alargado en precesión libre
(Beer fig. 18.23); en uno achatado el corporal envuelve al espacial.])

= 3. La derivada de un vector en un sistema que rota
#origen[Beer §15.10, ec. 15.31 · Curtis §1.6 · hoja de la cátedra «Derivada de un vector en sistemas rotantes»]

*La idea* (palabras de la hoja de Aníbal): un vector es el mismo para todos
los observadores; lo que cambia es cómo ve cada uno que cambia. El que gira
con los ejes ve una derivada; el de afuera, esa más lo que el giro le
// simbolos: A
agrega. Con $bold(A)$ un vector cualquiera ($bold(H)_G$, una posición, una
velocidad), «fijo» el observador de afuera y «móvil» el que gira con los
ejes, en las resoluciones de la cátedra se llama *teorema del transporte*:

$ (d bold(A))/(d t) bar.v_"fijo" = (d bold(A))/(d t) bar.v_"móvil" + bold(Omega) times bold(A) $

con $bold(Omega)$ la velocidad angular *de los ejes*. Si $bold(A)$ está
pegado al cuerpo y los ejes también, la derivada móvil es cero y queda
// simbolos: Adot
$dot(bold(A)) = bold(omega) times bold(A)$ (la derivada para el de afuera).
Aplicada a la posición dos veces sale la aceleración en un sistema rotante.
Con $bold(r)$ la posición del punto medida desde el origen común de los dos
// simbolos: a_I, a_C, v_C, Omegadot
sistemas, $bold(v)_C$ y $bold(a)_C$ la velocidad y la aceleración que mide
el que gira con los ejes, $bold(a)_I$ la que mide el de afuera (el
inercial) y $dot(bold(Omega))$ la aceleración angular de los ejes:

$ bold(a)_I = bold(a)_C + 2 bold(Omega) times bold(v)_C + bold(Omega) times (bold(Omega) times bold(r)) + dot(bold(Omega)) times bold(r) $

El segundo término es la de Coriolis, el tercero la centrípeta y el último
existe sólo si los ejes aceleran su giro.

*La hormiga de la hoja:* camina a $0,5$ m/s por una línea pintada en un
disco que gira a $1$ rad/s. A los $2$ s, desde afuera, su velocidad es
$(0,5; 1,0)$ m/s ($1,12$ m/s de módulo) y su aceleración $(-1,0; 1,0)$ m/s²
($1,41$ m/s²): centrípeta más Coriolis. Desde el disco, aceleración cero.
Un proyectil hacia el norte a $300$ m/s (su rapidez $v$) en Buenos Aires
($35degree$ S), con $Omega_T$ la velocidad angular de la Tierra (una vuelta
// simbolos: Omega_T
por día sideral), tiene una Coriolis horizontal de $2 Omega_T v sin
35degree approx 0,025$ m/s², hacia el oeste.

#trampa[
  Los errores que la hoja de Aníbal lista, en orden: (1) «$bold(A)$ visto
  desde el cuerpo» y «desde afuera» *no son dos vectores*, son dos
  derivadas; (2) *derivar las componentes no alcanza*: falta el término de
  los versores; (3) para la aceleración se deriva $bold(v)_I$, la velocidad
  // simbolos: v_I
  que ve el de afuera, no la velocidad que ve el disco: por eso Coriolis lleva un 2; (4) todos los
  términos en la misma base; (5) $bold(Omega)$ es la de los ejes respecto
  del inercial, no la de lo que se mueve adentro. Y un regalo: aplicada a
  $bold(Omega)$ misma, $bold(Omega) times bold(Omega) = 0$, así que
  $dot(bold(Omega))$ es igual en los dos sistemas.
]

= 4. Momento angular, momentos de inercia y ejes principales
#origen[Beer §18.2 (ecs. 18.11 y 18.13, fig. 18.6) y §18.5 · Beer vol. 1, §9.16–9.17 · apunte, módulo 19]

*La idea.* Para un rígido, $bold(H)_G = bold(I) thin bold(omega)$, con
$bold(I)$ el *tensor de inercia* (una matriz, no un número: dice cómo está
repartida la masa alrededor de $G$ en cada dirección). En los *ejes
principales* la matriz es diagonal. Con $I_x$, $I_y$, $I_z$ los momentos de
// simbolos: I_x, I_y, I_z, omega_y, T
inercia respecto de esos tres ejes, $omega_x$, $omega_y$, $omega_z$ las
componentes de $bold(omega)$ sobre ellos y $T$ la energía cinética de
rotación (en el cuerpo simétrico, $I_z = I$ e $I_x = I_y = I'$):

$ bold(H)_G = I_x omega_x hat(i) + I_y omega_y hat(j) + I_z omega_z hat(k), quad quad T = 1/2 bold(omega) dot.op bold(H)_G $

y en general *$bold(H)_G$ no es paralelo a $bold(omega)$* (la mancuerna
inclinada, la rueda desbalanceada). Sólo lo es si el cuerpo gira sobre un
eje principal.

- *Los ejes principales salen de la simetría, sin integrar*: un eje de
  simetría es principal; un plano de simetría tiene su normal principal.
- *No se calculan momentos de inercia* (Aníbal: «no es la idea»): se buscan
  en la tabla. *Steiner*, $I_P = I_G + m d^2$, con $I_G$ el momento
  // simbolos: I_P, I_G, P
  respecto de un eje por $G$, $I_P$ el momento respecto de un eje paralelo
  que pasa por otro punto $P$ y $d$ la distancia entre los dos ejes: saber
  que existe y qué dice.
- El momento de inercia *aparece* al escribir la energía cinética (lo
  preguntó así en el parcialito 4: «haga surgir»).

*Formal, el caso general (Beer ec. 18.7, pág. 1152).* Con ejes cualesquiera
por $G$ aparecen los *productos de inercia*: $I_(x y) = integral x y thin d
// simbolos: I_xy, I_xz, I_yz, H_y
m$ (sumar, sobre toda la masa, cada pedacito $d m$ por sus dos coordenadas
$x$ e $y$), y lo mismo $I_(x z)$ e $I_(y z)$ con los otros pares. Miden
cuán «torcida» está la masa respecto de los ejes. Con $H_x$, $H_y$, $H_z$
las componentes de $bold(H)_G$:

$ mat(H_x; H_y; H_z) = mat(I_x, -I_(x y), -I_(x z); -I_(x y), I_y, -I_(y z); -I_(x z), -I_(y z), I_z) mat(omega_x; omega_y; omega_z) $

La matriz es simétrica, así que *siempre se puede diagonalizar*: hay tres
ejes perpendiculares (los principales) en los que los productos de inercia
son cero. Eso es lo que Aníbal escribe arriba de todo en su hoja 1.

*Respecto de otro punto* (Beer ec. 18.11, pág. 1154): el momento angular
respecto de un punto fijo $O$ es el «orbital» del centro de masa más el
«propio» alrededor de $G$, con $overline(bold(r))$ la posición de $G$
medida desde $O$:

$ bold(H)_O = overline(bold(r)) times m overline(bold(v)) + bold(H)_G $

#figure(fig-HO, caption: [La hoja 1 de Aníbal (Beer fig. 18.26): el sistema
de cantidades de movimiento de un rígido se reduce a $m overline(bold(v))$
aplicado en $G$ más el par $bold(H)_G$. Respecto de $O$, la cantidad de
movimiento suma su momento $overline(bold(r)) times m overline(bold(v))$.])

Y si el cuerpo gira alrededor de un punto fijo $O$, se puede ir directo:
$bold(H)_O = bold(I)_O thin bold(omega)$ con el tensor respecto de $O$ (Beer
ec. 18.13).

#hoja[
  *Hoja 1, primera mitad.* $sum bold(F) = m bold(a)$ (su $bold(a)$ es la
  // simbolos: a, I_1, I_2, I_3
  aceleración del centro de masa, sin la barra del Beer) y $sum bold(M)_G = d
  bold(L)\/d t |_G$ (centro de masa: «C: c.g.»). $bold(L) = bold(I)
  bold(omega)$ con la nota «se puede diagonalizar», y la matriz diagonal
  $"diag"(I_1, I_2, I_3)$, donde sus $I_1$, $I_2$, $I_3$ son los momentos
  principales (nuestros $I_x$, $I_y$, $I_z$): entonces $bold(L) = (I_1 omega_x; I_2 omega_y; I_3
  omega_z)$ y *$bold(L) parallel.not bold(omega)$* — tachó el paralelo: con
  momentos distintos, $bold(L)$ no es paralelo a $bold(omega)$. Abajo, el
  dibujo de este cuadro: $bold(L)_O = bold(R) times m bold(v) + bold(L)_G$.
  // simbolos: L_O, L_G, R
  Ojo con las letras: su $bold(L)$ es el $bold(H)$ del Beer ($bold(L)_O$ y
  $bold(L)_G$ son $bold(H)_O$ y $bold(H)_G$), su $bold(R)$ es nuestro
  $overline(bold(r))$ y su $bold(v)$, nuestro $overline(bold(v))$.
]

#manos[
  Pulgar de la mano derecha sobre $bold(omega)$ (los dedos, girando como el
  cuerpo). Ahora imaginá que el cuerpo es una mancuerna inclinada: cada pesa
  tiene $bold(r) times m bold(v)$ perpendicular a su brazo, y la suma te
  queda *inclinada respecto del pulgar*. Ésa es la mano de $bold(H)_G$ y la
  de $bold(omega)$ separadas: sólo coinciden si el pulgar va sobre un eje
  principal (la mancuerna derecha, perpendicular al eje).
]

= 4 bis. Impulso y energía en tres dimensiones
#origen[Beer §18.3 (fig. 18.6, pág. 1156) y §18.4 (ecs. 18.14 a 18.17 y 18.20, pág. 1157)]

*En simple.* Lo de siempre, con un vector más. En un choque o un golpe
corto: lo que el cuerpo tenía antes, más lo que le dieron, es lo que tiene
después; vale *a la vez* para la cantidad de movimiento (que va en $G$) y para
el momento angular. Y la energía cinética es la de $G$ corriendo más la de
girar alrededor de $G$.

*Formal.* Los subíndices 1 y 2 son antes y después del golpe, y $integral
// simbolos: vbar_1, vbar_2
bold(F) d t$ es el impulso de cada fuerza externa (su efecto sumado durante
el golpe):

$ m overline(bold(v))_1 + sum integral bold(F) d t = m overline(bold(v))_2, quad quad (bold(H)_G)_1 + sum integral bold(M)_G thin d t = (bold(H)_G)_2 $

$ T = 1/2 m overline(v)^2 + 1/2 (I_x omega_x^2 + I_y omega_y^2 + I_z omega_z^2) quad "(ejes principales, Beer 18.17)" $

y con ejes cualesquiera se suman los términos $-I_(x y) omega_x omega_y$
(etc.) de los productos de inercia (Beer 18.16). En forma compacta, $T = 1/2
m overline(v)^2 + 1/2 bold(omega) dot.op bold(H)_G$. Con un punto fijo $O$,
$T = 1/2 bold(omega) dot.op bold(H)_O$ con los momentos respecto de $O$ (Beer
18.20).

*Para qué sirve en el parcialito:* el meteorito (sección 8) es este
principio con $integral bold(M)_G d t = bold(r) times m_0 bold(v)_0$; y la
energía es la que se conserva en el trompo (sección 11) o la que *baja*
cuando un satélite disipa (sección 9).

#manos[
  *El golpe:* pulgar sobre el $bold(H)_G$ del satélite (para arriba). El
  meteorito le agrega un pedacito de costado: poné el índice de la otra mano
  saliendo de la punta del pulgar, hacia el costado. El $bold(H)_G$ nuevo va
  de la base del pulgar a la punta del índice: inclinado. Ese ángulo es el
  $theta$ del bamboleo.
]

= 5. Ecuaciones del movimiento y ecuaciones de Euler
#origen[Beer §18.5–18.6 · resumen manuscrito de Aníbal, hoja 1 · apunte, módulo 20]

*La idea.* $sum bold(M)_G = dot(bold(H))_G$ pide la derivada *en el espacio
fijo*, pero $bold(H)_G$ es simple en ejes que giran con el cuerpo, porque
ahí $bold(I)$ es constante. La regla de la sección 3 lo resuelve:

$ sum bold(M)_G = (dot(bold(H))_G)_"móvil" + bold(Omega) times bold(H)_G $

*Ejes clavados al cuerpo* ($bold(Omega) = bold(omega)$), principales, dan
las *ecuaciones de Euler* (Beer §18.6, ec. 18.25, pág. 1170). En ellas
$M_x$, $M_y$, $M_z$ son las componentes de $sum bold(M)_G$ sobre los ejes
// simbolos: M_x, M_y, M_z, omegadot_x, omegadot_y, omegadot_z
principales, y $dot(omega)_x$, $dot(omega)_y$, $dot(omega)_z$ cuánto cambian
por segundo las componentes de $bold(omega)$:

$ sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z $
$ sum M_y = I_y dot(omega)_y - (I_z - I_x) omega_z omega_x $
$ sum M_z = I_z dot(omega)_z - (I_x - I_y) omega_x omega_y $

Los términos cruzados son los *giroscópicos*: aunque no haya cupla, una
componente de $bold(omega)$ le cambia a otra. Son no lineales: se estudian
casos particulares.

#hoja[
  *Hoja 1, segunda mitad.* «Es necesario un sist. referencia que siga al
  cuerpo (para que $bold(L)$, $bold(I)$ sean constantes)»: en ejes fijos al
  espacio el tensor cambia cada vez que el cuerpo se da vuelta; en ejes que
  lo siguen, no. Después, la regla del transporte con los nombres del Beer:
  la derivada con «orientación fija, centrado en $G$» (el sistema $G X Y Z$
  // simbolos: X, Y, Z
  del Beer: ejes $X$, $Y$, $Z$ paralelos a los fijos, con origen en $G$; se
  traslada con $G$ pero no gira) es la derivada en los ejes
  del cuerpo más $bold(Omega) times bold(L)_G$, y eso es $sum bold(M)_G$.
  $bold(Omega)$: «vel. angular sist. cuerpo respecto al sist. fijo». Al lado,
  *«comentar sobre "razón de cambio" en Beer»*: el Beer llama *razón de
  cambio* a la derivada respecto del tiempo, y tiene *dos*: $dot(bold(H))_G$,
  la razón de cambio respecto de $G X Y Z$ (la que manda en la ley), y
  $(dot(bold(H))_G)_(G x y z)$, la razón de cambio *respecto del sistema en
  rotación*, que es derivar las componentes y nada más (ec. 18.21, pág.
  1169). Confundirlas es el error número uno de la hoja de sistemas rotantes.
  Abajo, subrayado: *«no siempre $bold(Omega) = bold(omega)$»*; a la derecha,
  $bold(Omega) times bold(L)_G$ como determinante, y de ahí las tres
  ecuaciones de Euler.

  *Ojo con una errata de la hoja:* con sus subíndices 1, 2, 3 (nuestros
  // simbolos: M_3, omegadot_3
  $x$, $y$, $z$), la tercera dice $sum M_3 = I_3 dot(omega)_3 - omega_x
  omega_y (I_1 - I_3)$. Por la rueda $x arrow.r y
  arrow.r z$ es $(I_1 - I_2)$, como en el Beer 18.25; se comprueba con el
  determinante de la misma hoja, cuya componente $hat(k)$ es $I_2 omega_2
  omega_1 - I_1 omega_1 omega_2$. Las otras dos están bien.
]

#manos[
  *Por qué aparece el término giroscópico, con un libro.* Tené un libro con
  las dos manos y hacelo girar a la vez sobre dos ejes (por ejemplo, el lomo
  y el que sale de la tapa). Vas a sentir que se quiere torcer hacia un
  tercer lado que vos no estás empujando: es $(I_y - I_z) omega_y omega_z$,
  la parte de $bold(Omega) times bold(H)$ que existe sólo porque $bold(H)$ no
  es paralelo a $bold(omega)$. Si el cuerpo fuera una esfera (momentos
  iguales), la mano no sentiría nada: el término se anula.
]

*Con un punto fijo y con un eje fijo* (Beer §18.7 y 18.8, ecs. 18.28 y
18.29, pág. 1172). Si el cuerpo está sujeto en $O$, se toman momentos
respecto de $O$ y la reacción desaparece de la cuenta: $sum bold(M)_O =
(dot(bold(H))_O)_(O x y z) + bold(Omega) times bold(H)_O$. Si además gira
alrededor de un eje fijo $z$ con $bold(omega) = omega hat(k)$ y $alpha =
// simbolos: alpha, omegadot
dot(omega)$ su aceleración angular, con ejes pegados al cuerpo:

$ sum M_x = -I_(x z) alpha + I_(y z) omega^2, quad sum M_y = -I_(y z) alpha - I_(x z) omega^2, quad sum M_z = I_z alpha $

// simbolos: tau
La tercera es la de siempre ($tau = I alpha$, torque igual a momento de
inercia por aceleración angular). Las dos primeras dicen que,
*aunque $omega$ sea constante*, si el cuerpo tiene productos de inercia
respecto del eje (está torcido o desbalanceado) los cojinetes tienen que
hacer momento: $omega^2$ por el producto de inercia. Es el disco torcido de
abajo.

#trampa[
  *«No siempre $bold(Omega) = bold(omega)$»* (subrayado en la hoja de
  Aníbal). En un cuerpo de revolución conviene usar ejes que siguen el eje
  de simetría pero *no giran con el spin*: los momentos de inercia siguen
  constantes y la cuenta se achica. Entonces en el $bold(Omega) times
  bold(H)$ va la de los ejes, no la del cuerpo. Antes de escribir la
  ecuación, decir a qué están clavados los ejes.
]

*El Ejercicio 3 de la guía (el volante en el gimbal).* Un volante con
$I_x = I_y = 5$ kg·m² e $I_z = 10$ kg·m² gira a $omega_s = 100$ rad/s (su
spin) sobre su eje $z$; está montado en un gimbal sin peso que puede girar
sobre $x$, y el gimbal en una plataforma que gira a $omega_p = 0,5$ rad/s
// simbolos: omega_s, omega_p, Omegadot_x
alrededor de $y$. Con los ejes clavados al gimbal, $M_x$ es el torque que se
le aplica sobre $x$ y $dot(Omega)_x$ la aceleración angular del gimbal (lo
que pide el problema):
$I_x dot(Omega)_x = M_x - omega_p I_z omega_s$. Con la cupla de
$600$ N·m, $dot(Omega)_x = 20$ rad/s² (no $600\/5 = 120$: $500$ N·m se van en
llevar a $bold(H)$ de paseo con la plataforma). *Sin cupla*, como lo
resolvió Aníbal: $dot(Omega)_x = -100$ rad/s² en $t = 0$. El gimbal suelto
arranca solo, buscando poner el eje del volante paralelo al giro de la
plataforma; se pasa y *oscila*. Es el girocompás del GIF.

*La otra mitad de §18.6: la extensión de d'Alembert.* Las fuerzas externas
sobre un rígido equivalen a $m overline(bold(a))$ aplicada en $G$ más una
cupla $dot(bold(H))_G$. Sirve para sacar reacciones. El caso de §18.7–18.8 es
el *eje fijo*: un disco (momento axial $I$, transversal $I'$) montado
// simbolos: beta
torcido un ángulo $beta$ respecto del eje, en un eje que gira con $omega$
constante, tiene $bold(H)_G$ fuera de $bold(omega)$, que da vueltas
con el eje, y los cojinetes tienen que hacer la cupla

$ abs(dot(bold(H))_G) = abs(bold(omega) times bold(H)_G) = (I - I') omega^2 sin beta cos beta $

con dos fuerzas opuestas que *giran con el eje* (el desbalance dinámico,
módulo 19). Crece con $omega^2$ y desaparece si el eje de giro es principal
($beta = 0$). Con números, en el Ejercicio 10 del modelo de parcialito 5.

= 6. El giróscopo y los ángulos de Euler
#origen[Beer §18.9, figs. 18.15–18.16 · resumen manuscrito de Aníbal, hoja 2 · apunte, módulo 20]

*La idea* (Aníbal: «el giróscopo ayuda a visualizar los ángulos de
Euler»). Un rotor en dos cardanes (balancines), con el centro de masa fijo.
Tres articulaciones, tres ángulos. Los nombres $A A'$, $B B'$ y $C C'$ son
// simbolos: phi, psi, A', B', C, C'
los de las figuras del Beer para los ejes de las tres articulaciones, y
$phi$, $theta$, $psi$ cuánto giró cada una:

#tabla((auto, auto, auto, auto),
  [*ángulo*], [*nombre*], [*quién gira*], [*alrededor de*],
  [$phi$], [precesión], [balancín exterior], [el eje fijo $Z$ ($A A'$)],
  [$theta$], [nutación], [balancín interior], [la línea de nodos ($B B'$)],
  [$psi$], [spin, giro propio], [el rotor], [su eje de simetría ($C C'$)],
)

Con los ejes $x y z$ pegados al balancín *interior* ($z$ sobre el rotor,
$y$ sobre $B B'$), que precesan y nutan pero no giran con $psi$, y con
// simbolos: thetadot
$dot(theta)$ la velocidad de nutación (cuánto cambia la inclinación por
segundo):

$ bold(omega) = dot(phi) bold(K) + dot(theta) hat(j) + dot(psi) hat(k), quad quad bold(K) = -sin theta thin hat(i) + cos theta thin hat(k) $
$ bold(Omega) = -dot(phi) sin theta thin hat(i) + dot(theta) hat(j) + dot(phi) cos theta thin hat(k) $
$ bold(H)_O = -I' dot(phi) sin theta thin hat(i) + I' dot(theta) hat(j) + I (dot(psi) + dot(phi) cos theta) hat(k) $

La única diferencia entre $bold(Omega)$ y $bold(omega)$ es el spin (la nota
de Aníbal: «ojo, no gira en $psi$»). Metidas en $sum bold(M)_O =
(dot(bold(H))_O)_"móvil" + bold(Omega) times bold(H)_O$ dan las tres
ecuaciones del giróscopo (Beer 18.39, pág. 1188; las pegó Aníbal en su hoja
// simbolos: phiddot, thetaddot
3). Dos puntos arriba es la derivada segunda: $dot.double(phi)$ y
$dot.double(theta)$ dicen cuánto se aceleran la precesión y la nutación:

$ sum M_x = -I' (dot.double(phi) sin theta + 2 dot(theta) dot(phi) cos theta) + I dot(theta) (dot(psi) + dot(phi) cos theta) $
$ sum M_y = I' (dot.double(theta) - dot(phi)^2 sin theta cos theta) + I dot(phi) sin theta (dot(psi) + dot(phi) cos theta) $
$ sum M_z = I thin d/(d t) (dot(psi) + dot(phi) cos theta) $

No lineales, sin solución general a mano: por eso los *casos particulares*
(precesión estable, sección 7; sin cupla, sección 8). Fijate que $dot(psi)$
nunca aparece suelto: siempre en $omega_z = dot(psi) + dot(phi) cos theta$,
que es todo el giro sobre el eje del rotor.

#figure(fig-cardanes(escala: 0.92cm), caption: [El giróscopo en cardanes
(redibujado de Beer figs. 18.15 y 18.16, las de la hoja 2 de Aníbal).
Balancín exterior (verde) girado $phi$ alrededor de $A A'$; interior (bordó)
girado $theta$ alrededor de $B B'$; rotor (azul) girando $psi$ alrededor de $C
C'$. Los ejes $x y z$ van pegados al balancín interior: $z$ sobre el rotor,
$y$ sobre $B B'$.])

#hoja[
  *Hoja 2 (Fig. 18.15).* Arriba, el armado: «CM fijo al espacio», «$O x y z$
  fijo al CM», «2 balancines», «eje $Z$ $parallel$ $A A'$», «$D D'$ dibujado
  // simbolos: D, D'
  sobre el rotor» y en el plano $Y Z$ ($D D'$ es una raya pintada en el
  rotor, una marca para poder ver cuánto giró).
  Después, los once pasos: (1) $phi$ es la rotación del balancín exterior
  alrededor de $A A'$; (2) $theta$, la del interior alrededor de $B B'$; (3)
  $psi$, la del rotor alrededor de $C C'$; (4) son los ángulos de Euler; (5)
  $dot(phi)$ precesión, $dot(theta)$ nutación, $dot(psi)$ spin; (6) el
  sistema $O x y z$ va en el balancín interior; (7) $y parallel B B'$, $z
  parallel C C'$; (8) en ese sistema «se ve girar al giróscopo con
  $dot(psi)$» (lo único que se mueve respecto de esos ejes es el rotor); (9)
  $bold(omega) = dot(phi) bold(K) + dot(theta) hat(j) + dot(psi) hat(k)$;
  (10) $bold(K) = -sin theta thin hat(i) + cos theta thin hat(k)$ (el dibujito
  de al lado: $bold(K)$ visto en el plano $x z$, a $theta$ de $z$); (11)
  sustituyendo, $bold(omega)$ y $bold(L)$ en componentes.

  *Hoja 3.* (12) $I_1 = I_2 = I'$, $I_3 = I$ (cuerpo de revolución) y
  $bold(L)$; después $bold(Omega) = dot(phi) bold(K) + dot(theta) hat(j)$
  «ojo, no gira en $psi$», la ley con la derivada «móvil», las 18.39, y tres
  conclusiones: el mismo tratamiento sirve para *un trompo con un punto
  fijo*; el giróscopo «ayuda» a visualizar los ángulos de Euler; ecuaciones no
  lineales $arrow.r$ casos particulares.
]

#manos[
  *Los tres ángulos con un lápiz.* El lápiz es el eje del rotor. *$phi$:* lo
  girás alrededor de la vertical, como una aguja de reloj acostada, sin
  cambiarle la inclinación (pulgar de la mano derecha para arriba: $dot(phi)
  bold(K)$). *$theta$:* lo inclinás respecto de la vertical, como una barrera
  que baja (el eje de giro es horizontal: la línea de nodos, $hat(j)$).
  *$psi$:* lo hacés rodar entre los dedos sobre su propio largo (pulgar a lo
  largo del lápiz: $dot(psi) hat(k)$). Los ejes $x y z$ son tu mano
  sosteniendo el lápiz: siguen la aguja y la barrera, pero *no* ruedan con el
  lápiz. Eso es $bold(Omega) = bold(omega) - dot(psi) hat(k)$.
]

*La pregunta orientadora de la clase de CR* (¿por qué a bordo se usan
cuaterniones?): tres ángulos alcanzan, pero con $theta = 0$ el eje del
rotor coincide con el fijo, $phi$ y $psi$ miden el mismo giro y se pierde un
grado de libertad en la descripción (en los cardanes reales, el *bloqueo de
cardán*). El cuaternión guarda cuatro números con un vínculo, no tiene esa
singularidad y compone giros sin senos ni cosenos.

= 7. Precesión estable
#origen[Beer §18.10, ecs. 18.40 a 18.45, figs. 18.17 a 18.19 · resumen manuscrito de Aníbal, hoja 4]

*La idea.* $theta$, $dot(phi)$ y $dot(psi)$ constantes: el eje barre un cono
perfecto. Entonces $bold(H)_O$ es constante *en los ejes móviles*, la
derivada móvil es cero, y sólo queda el transporte:

$ sum bold(M)_O = bold(Omega) times bold(H)_O = (I omega_z - I' dot(phi) cos theta) dot(phi) sin theta thin hat(j), quad omega_z = dot(psi) + dot(phi) cos theta $

Con el eje de giro *perpendicular* al de precesión ($theta = 90degree$):

$ sum bold(M)_O = I dot(psi) dot(phi) thin hat(j) $

El par va sobre la línea de nodos: *perpendicular al eje de precesión y al
eje de giro*. Giro, par y precesión forman una tríada derecha (Beer fig.
18.19): el spin «persigue» al par. Con el peso de palanca (una rueda de
masa $M$ colgada de un extremo de su eje, con $G$ a una distancia $l$ del
// simbolos: g, l, omega_spin, omega_prec
apoyo, $g$ la gravedad, $omega_"spin"$ su giro y $omega_"prec"$ su
precesión), $M g l = I omega_"spin" omega_"prec"$, que es el $Omega = tau
\/ L$ del Sears (ahí $Omega$ es la precesión, $tau$ el torque del peso y $L$
el momento angular; Aníbal remite al giróscopo del parcialito 3).

*Con el eje inclinado y el peso* (el trompo o el giróscopo apoyado en $O$):
con $W$ el peso, que actúa en $G$, y $c$ la distancia de $O$ a $G$ sobre el
// simbolos: W, c, I'_O
eje, el par del peso es $W c sin theta$. Con $I'_O$ el momento transversal
respecto del pivote $O$, el $sin theta$ se simplifica y queda

$ W c = (I omega_z - I'_O dot(phi) cos theta) dot(phi) quad arrow.r.double quad (I - I'_O) cos theta thin dot(phi)^2 + I dot(psi) thin dot(phi) - W c = 0 $

Es *cuadrática*: hay dos precesiones estables posibles, una lenta (la que se
ve, $dot(phi) approx W c \/ (I dot(psi))$ si $dot(phi) << dot(psi)$) y una
// simbolos: I'_G
rápida. $I'_O$ sale de Steiner, $I'_G + m c^2$, con $I'_G$ el transversal
por $G$; y $omega_z$
lleva el $dot(phi) cos theta$. Con menos spin la lenta se *acelera*, hasta
que deja de haber solución y el trompo cae. Con números, en el Ejercicio 11
del modelo de parcialito 5.

#figure(fig-precesion-estable, caption: [La precesión estable (redibujada de
Beer fig. 18.17, la de la hoja 4 de Aníbal). a) $bold(omega)$ es la suma de
la precesión $dot(phi) bold(K)$ y el giro $dot(psi) hat(k)$; en los ejes
móviles tiene $omega_z hat(k)$ sobre el eje y $-dot(phi) sin theta thin
hat(i)$ de costado. b) Con el eje horizontal, giro, par y precesión son una
tríada derecha: pulgar, índice y mayor.])

#trampa[
  El giróscopo no cae para el lado del par: precesa perpendicular a él. Y
  la precesión estable es un caso *particular*: para mantenerla hace falta
  exactamente ese par; si no, aparece nutación.
]

#hoja[
  *Hoja 4 (Fig. 18.17), paso por paso.* «$theta$, $dot(phi)$ y $dot(psi)$
  constantes» y «quiere saber fuerzas aplicadas para esa condición»: la
  pregunta es al revés que siempre, *qué par hace falta* para que el
  movimiento sea ése. Con $dot(theta) = 0$: $bold(omega) = dot(phi) bold(K) +
  dot(psi) hat(k)$ y $bold(Omega) = dot(phi) bold(K)$ — «el spin no aporta al
  giro del sist. ref.». En componentes, $bold(omega) = -dot(phi) sin theta
  thin hat(i) + omega_z hat(k)$, $bold(L)_O = -I' dot(phi) sin theta thin
  hat(i) + I omega_z hat(k)$, $bold(Omega) = -dot(phi) sin theta thin hat(i) +
  dot(phi) cos theta thin hat(k)$, con $omega_z = dot(psi) + dot(phi) cos
  theta$. Como todo es constante, *$bold(L)$ es constante en los ejes
  móviles*: $(d bold(L)_O \/ d t)_"móvil" = 0$, y queda $sum bold(M)_O =
  bold(Omega) times bold(L)_O = (I omega_z - I' dot(phi) cos theta) dot(phi)
  sin theta thin hat(j)$, «el par a aplicar». Caso «eje de precesión $perp$
  eje de giro», $theta = 90degree$: $sum bold(M) = I dot(psi) dot(phi)
  hat(j)$. Y la nota final, «ver problema quiz 3»: $"peso" dot.op l = I
  omega_"spin" omega_"prec"$, el giróscopo del parcialito 3 (ahí el par lo
  hace el peso con brazo $l$).
]

#manos[
  *La tríada con tres dedos* (figura b). Pulgar a lo largo del eje del rotor,
  hacia donde apunta su giro ($dot(psi) hat(k)$). Índice para donde empuja el
  par ($sum bold(M)$: con el peso colgando de un extremo, el par es
  horizontal y perpendicular al eje). El mayor te queda apuntando *para
  arriba o para abajo*: ése es el sentido de la precesión. Probalo con el
  ejemplo de siempre: rueda de bici sostenida de un extremo del eje, girando
  hacia vos; el par del peso pide índice horizontal, y el mayor dice que la
  rueda, en vez de caerse, gira alrededor de la cuerda. Al revés, con el
  CMG: si vos le girás el eje (mayor = el giro que imponés) teniendo el
  pulgar sobre $bold(H)$, el índice te dice para dónde *tenés que empujar*
  // simbolos: h, deltadot
  ($dot(bold(delta)) times bold(h)$, con $bold(h)$ el momento angular del
  rotor y $dot(bold(delta))$ la velocidad angular con que girás el gimbal;
  sección 10); lo que sentís en la mano, y lo que
  recibe el satélite, es el opuesto: el torque de salida.
]

= 8. Cuerpo simétrico sin cupla: precesión libre
#origen[Beer §18.11, ecs. 18.46 a 18.52, figs. 18.20 a 18.24 · cuaderno del Beer 18.127 · apunte, módulo 21]

*La idea.* Sin cupla, $bold(H)_G$ queda *fijo en el espacio* y hace de eje
de precesión. El eje del cuerpo da vueltas alrededor de $bold(H)_G$ con
$theta$ constante: nadie la sostiene, es automática. Dos ángulos contra el
eje del cuerpo: $theta$ (a $bold(H)_G$) y $gamma$ (a $bold(omega)$):

$ tan gamma = I/I' tan theta, quad quad dot(phi) = H_G/I', quad quad dot(psi)/dot(phi) = (I' - I)/I cos theta $

#figure(fig-precesiones(), caption: [La figura «Precesiones» que subió Aníbal,
redibujada. Cuerpo simétrico sin cupla: $bold(H)_G$ fijo (vertical, el eje
$Z$), el eje del cuerpo $z$ y $bold(omega)$ en un mismo plano que da vueltas
alrededor de $bold(H)_G$. Cono verde: el espacial (alrededor de $bold(H)_G$,
quieto; su semiángulo $beta$ es el ángulo entre $bold(omega)$ y
$bold(H)_G$). Cono azul: el corporal (alrededor de $z$,
semiángulo $gamma$, va con el cuerpo). Alargado: se tocan por afuera;
achatado: el corporal envuelve al espacial.])

#hoja[
  *La figura «Precesiones», leída.* Dos cuerpos simétricos libres de cupla,
  con $bold(H)_G$ vertical (su eje $Z$). *Las letras son de otro libro y hay
  que traducirlas* (ANI-08, «ojo con las denominaciones»): $I$ es el momento
  // simbolos: I_0
  *axial* (como el Beer) e $I_0$ el *transversal*, que en el Beer es $I'$.
  $theta$ es el ángulo entre el eje del cuerpo $z$ y $bold(H)_G$ (el mismo
  $theta$ del Beer), y $beta$ es el ángulo entre $bold(omega)$ y
  $bold(H)_G$ — no el $gamma$ del Beer, que se mide de $bold(omega)$ al eje
  del cuerpo. Se pasa de uno a otro mirando quién queda en el medio:
  alargado, $beta = theta - gamma$; achatado, $beta = gamma - theta$.
  Izquierda: el cilindro, $I < I_0$ ($I < I'$), $bold(omega)$ queda *entre*
  el eje y $bold(H)_G$, y $dot(psi) > 0$: spin y precesión del mismo signo,
  *directa*. Derecha: el disco, $I > I_0$, $bold(H)_G$ queda entre el eje y
  $bold(omega)$, y $dot(psi) < 0$: *retrógrada*. Las flechitas $dot(phi)$
  (arriba de $bold(H)_G$) y $dot(psi)$ (sobre $z$) son los dos giros: en el
  cilindro van para el mismo lado, en el disco al revés. Todo sale de $tan
  gamma = (I\/I') tan theta$ y $dot(psi)\/dot(phi) = ((I' - I)\/I) cos theta$.
]

#manos[
  *Los dos conos con las dos manos.* Mano izquierda cerrada con el pulgar
  para arriba: es $bold(H)_G$, y no se mueve (nadie empuja). Mano derecha con
  el pulgar inclinado: es el eje del cuerpo. Ahora llevá el pulgar derecho a
  dar vueltas *alrededor* del izquierdo sin cambiar la inclinación: eso es la
  precesión $dot(phi)$. Y mientras, hacé girar la mano derecha sobre su
  propio pulgar: el spin $dot(psi)$. *Cilindro* (alargado): el giro sobre
  el pulgar va para el mismo lado que la vuelta que da el pulgar —
  directa. *Disco* (achatado): va al revés — retrógrada. Y si
  dejás la derecha quieta respecto de la izquierda, no hay cono: el cuerpo
  gira sobre un eje principal, sin bamboleo.
]

#tabla((auto, auto, auto),
  [*cuerpo*], [*achatado* (disco, moneda): $I > I'$], [*alargado* (varilla, cohete): $I < I'$],
  [ángulos], [$gamma > theta$], [$gamma < theta$],
  [$dot(psi)$ y $dot(phi)$], [signos opuestos], [mismo signo],
  [precesión], [*retrógrada*], [*directa*],
  [conos], [el corporal envuelve al espacial], [tangentes por afuera],
)

*El 18.127 del Beer (el cuaderno de Aníbal):* un satélite de 800 lb que
gira a $1,5$ rad/s sobre su eje recibe un meteorito de 6 oz. Después del
choque, $bold(H)_G$ forma $theta = 36,6degree$ con el eje y $bold(omega)$,
$gamma = 43,2degree$; precesa a $dot(phi) = 0,946$ rad/s con spin $dot(psi)
= -0,159$ rad/s: retrógrada, porque el satélite es achatado. El libro da
los momentos como radios de giro ($I = m k^2$: $k$ es la distancia a la que
habría que poner toda la masa para tener el mismo momento): $k_y$, el del
// simbolos: k, k_y, k_x
eje de simetría (ahí es $y$), es mayor que $k_x$, el transversal; o sea
$k_y > k_x$ e $I > I'$.
El Problema 4 de la guía es el mismo tema: período de precesión $1,832$ s,
spin negativo.

*La receta del Problema Resuelto 18.6* (el que mandó a hacer Aníbal: «es
aprender a hacer el resto»). Cuatro pasos, siempre los mismos:

+ *Ejes e impulso.* Ejes principales con $z$ sobre el eje de simetría. Sin
  impulso externo, $bold(H)_G$ después $=$ $bold(H)_G$ antes $+ bold(r)
  times m_0 bold(v)_0$. Decir el supuesto: la masa del meteorito no cambia
  ni $G$ ni los momentos de inercia.
+ *De $bold(H)_G$ a $bold(omega)$*, componente a componente: $omega_x =
  H_x \/ I'$, $omega_z = H_z \/ I$. Sale $gamma$ (entre $bold(omega)$ y el
  eje).
+ *El eje de precesión* es $bold(H)_G$; $theta$ (entre $bold(H)_G$ y el eje)
  sale de $tan theta = H_x \/ H_z$.
+ *Ley de los senos* en el triángulo $bold(omega) = dot(phi) bold(K) +
  dot(psi) hat(k)$: $dot(phi) = omega sin gamma \/ sin theta$, $dot(psi) =
  omega sin(theta - gamma) \/ sin theta$. Dibujar los conos.

Con los números del libro (un satélite de masa $m$ hecho de dos discos de
// simbolos: a
radio $a = 0,8$ m unidos por una barra de largo $2 a$, que gira a $60$ rpm;
meteorito de $m\/1000$ a $2000$ m/s, que pega a una distancia $a$ del eje): $omega_x = 2$ rad/s, $gamma = 17,7degree$,
$theta = 38,5degree$; con los ángulos redondeados como el libro, $dot(phi)
= 30,8$ rpm y $dot(psi) = 35,9$ rpm; sin redondear, $30,7$ y $36,0$ rpm.
Las dos positivas: directa, porque dos discos separados por una barra son
un cuerpo alargado ($I = 1/2 m a^2 < I' = 5/4 m a^2$).

#trampa[
  Directa/retrógrada se mide *desde el espacio* (giro contra precesión). El
  bamboleo de Chandler de la Tierra se llama «progrado» porque se mide
  desde la Tierra: no contradice nada. Y no te confundas de letra: con las
  del Beer, *$I > I'$ es achatado*.
]

= 9. ¿Sobre qué eje conviene girar?
#origen[apunte, módulo 20 · diapositivas de control de actitud de Sevilla (subidas el 19/10) · preguntas orientadoras de la clase de CR]

- *Sin disipación*: girar sobre el eje de momento mayor o menor es
  estable; sobre el *intermedio*, inestable (el ladrillo, la raqueta, el
  efecto Dzhanibekov de la astronauta con la tuerca).
- *Con disipación* (antenas flexibles, combustible que chapotea): la
  energía baja con $bold(H)$ fijo, y el cuerpo termina girando sobre el eje
  de momento *mayor*. El Explorer 1 (1958) era alargado, giraba sobre el
  eje menor, y en una órbita ya daba tumbos. El Sputnik, no.
- *Para controlar la actitud*: volantes y CMG (el Ejercicio 3 leído al
  revés), y el gradiente de gravedad.

= 10. Torque de salida y amplificación de torques
#origen[Lo nombró Aníbal para el parcialito · material del 28/09 (actuador y sensor, Lappas 2002) · apunte, módulos 17 y 20]

*La idea.* Un CMG es un rotor que gira siempre igual (momento angular
$bold(h)$ grande) montado en un gimbal que un motor puede girar. Hay dos
torques en ejes distintos:

- *De entrada*: el del motor, sobre el eje del gimbal. Sólo vence la inercia
  y el rozamiento del gimbal; con el gimbal girando parejo, casi nada.
- *De salida*: el que recibe el satélite, sobre el tercer eje. Si el motor
  gira el gimbal a $dot(delta)$ (rad/s), el rotor cambia su momento a razón
  $dot(bold(delta)) times bold(h)$ y el satélite se lleva el opuesto, de
  // simbolos: tau_salida, tau_motor
  módulo $tau_"salida" = h dot(delta)$.

La *amplificación* es salida sobre entrada, $tau_"salida" \/ tau_"motor"$,
con $tau_"motor"$ el torque de entrada. Con el volante del Ejercicio 3
($h = 1000$ kg·m²/s) y el gimbal llevado a $0,5$ rad/s en un segundo:
entran $2,5$ N·m, salen $500$, una amplificación de $200$. Una rueda de
reacción da torque cambiando el *tamaño* de su momento angular: su salida es
la del motor, amplificación uno.

#trampa[
  El torque de salida no aparece sobre el eje del gimbal ni sobre el del
  rotor: sobre el tercero. Es la misma regla de siempre (giro, par y
  precesión forman una tríada derecha), leída al revés.
]

= 11. Cuando $theta$ también se mueve: el trompo
#origen[Beer, recuadro de resolución de §18.9–18.11, caso 3 (pág. 1194) · apunte, módulo 21]

Un trompo con un punto fijo en su eje, sólo con su peso, puede cambiar
$theta$: precesa, nuta y gira, y nada es constante. Las ecuaciones no son
lineales; el Beer aconseja usar lo que se conserva, que son tres cosas:
// simbolos: E
la *energía* $E$ (el peso es conservativo), el *momento angular sobre el eje
vertical* (ni el peso ni el apoyo hacen momento alrededor de él) y el
*momento angular sobre el eje del trompo*, $I omega_z$ (el apoyo y $G$ están
sobre ese eje). Con eso, $theta$ queda oscilando entre dos valores: la
nutación. La precesión estable es el caso en que esa oscilación es cero.

#pagebreak(weak: true)
= Cómo pregunta Aníbal en un parcialito
#origen[Leído de los parcialitos 2, 3 y 4 (criterios inferidos, no dichos por él)]

- *Una cadena, no una cuenta*: preguntas cortas encadenadas. Cada eslabón
  vale.
- *«Explique el video…»* (la astronauta del parcialito 4): una demostración
  de clase o un GIF se explica con la física, y la respuesta correcta suele
  contradecir la intuición. Esta vez hay candidatos: el girocompás, el
  satélite que gira, el disco en la horquilla.
- *«Diga si depende de…»* (del sistema de coordenadas, del observador): sí
  o no, *con la razón*. $bold(omega)$ de un rígido no depende del punto;
  la derivada de un vector sí depende del sistema desde el que se mira.
- *«Haga surgir…» y «demuestre que…»*: la cuenta mínima y después la
  imagen (en el parcialito 4, la barra inclinada: $bold(H)$ no es cero y
  barre un cono).
- *El dibujo es la respuesta*: $bold(H)$, $bold(omega)$, $bold(Omega)$,
  $bold(M)$ con dirección, sentido y nombre; los ángulos de Euler sobre el
  giróscopo.
- *Toda aproximación se dice y se justifica* (lo pidió el 19/10, «muy
  importante»): masa constante, meteorito que no cambia los momentos de
  inercia, precesión lenta. Con un número, si se puede.
- *Las denominaciones*: impulso angular / momento angular / $bold(H)$ /
  $bold(L)$; $bold(Omega)$ contra $bold(omega)$; $I$ contra $I'$. Y *dónde
  deja de valer* cada ecuación.

= Preguntas que pueden caer, con la respuesta corta

#pregunta(1, [¿Por qué para escribir $sum bold(M)_G = dot(bold(H))_G$ se usan ejes que giran, si la ley vale en un sistema inercial?],
  [Porque en ejes que acompañan al cuerpo el tensor de inercia es constante y $bold(H)_G$ se escribe fácil. El precio es el término de transporte: $dot(bold(H))_G = (dot(bold(H))_G)_"móvil" + bold(Omega) times bold(H)_G$. La ley sigue siendo la del inercial; sólo cambia cómo se calcula la derivada.])

#pregunta(2, [¿$bold(Omega)$ y $bold(omega)$ son lo mismo?],
  [No siempre. $bold(omega)$ es la del cuerpo; $bold(Omega)$, la de los ejes. Son iguales si los ejes están clavados al cuerpo (ecuaciones de Euler). En el giróscopo, los ejes del balancín interior no siguen el spin: $bold(omega) = bold(Omega) + dot(psi) hat(k)$.])

#pregunta(3, [Dibuje un giróscopo en dos cardanes y marque los tres ángulos de Euler.],
  [Balancín exterior girando $phi$ alrededor del eje fijo vertical (precesión); balancín interior girando $theta$ alrededor de su eje, que es la línea de nodos (nutación, el ángulo entre el eje fijo y el del rotor); rotor girando $psi$ alrededor de su propio eje (spin). Una articulación, un ángulo.])

#pregunta(4, [Un volante girando rápido, montado en un gimbal sobre una plataforma que gira, con el gimbal suelto. ¿Se queda quieto?],
  [No. $I_x dot(Omega)_x = - omega_p I_z omega_s$: arranca solo ($-100$ rad/s² en el Ejercicio 3) y oscila alrededor de la posición en que el eje del volante queda paralelo al giro de la plataforma. Es el principio del girocompás: con la Tierra de plataforma, el eje busca el norte.])

#pregunta(5, [Un giróscopo precesa de manera estable con su eje horizontal. ¿Para dónde apunta el par que lo sostiene?],
  [Perpendicular al eje de giro y al de precesión: $sum bold(M) = I dot(psi) dot(phi) hat(j)$, sobre la línea de nodos. Giro, par y precesión forman una tríada derecha. El par no lo hace caer para su lado: lo hace precesar.])

#pregunta(6, [Un satélite simétrico, libre de cuplas, gira con $bold(omega)$ no alineado con su eje. ¿Qué hace?],
  [$bold(H)_G$ queda fijo; el eje del satélite y $bold(omega)$ dan vueltas alrededor de él, en un mismo plano, con ángulos constantes. Si es achatado ($I > I'$) la precesión es retrógrada: spin y precesión al revés. Si es alargado, directa.])

#pregunta(7, [¿Por qué el Explorer 1 empezó a dar tumbos?],
  [Giraba sobre su eje de momento de inercia *menor* (era alargado) y tenía antenas flexibles que disipaban energía. Con $bold(H)$ fijo y la energía bajando, el único estado final posible es girar sobre el eje de momento *mayor*: el eje se fue inclinando hasta quedar de costado.])

#pregunta(8, [¿La velocidad angular de un cuerpo rígido depende del punto que se elija? ¿Y la derivada de un vector, del sistema de referencia?],
  [La $bold(omega)$ no: es la misma para todos los puntos del rígido. La derivada de un vector sí: el que gira con los ejes y el de afuera ven derivadas distintas, y difieren en $bold(Omega) times bold(A)$. El vector es uno solo.])

#pregunta(9, [Haga surgir el momento de inercia desde la energía cinética de un rígido que gira alrededor de un eje.],
  // simbolos: m_i, v_i, r_i
  [Con $m_i$ la masa de cada partícula y $v_i$ su rapidez, $T = sum 1/2 m_i v_i^2$ con $v_i = r_i omega$ (el mismo $omega$ para todos, $r_i$ la distancia de la partícula al eje): $T = 1/2 (sum m_i r_i^2) omega^2$. Lo de adentro del paréntesis sólo depende de cómo está repartida la masa respecto del eje: eso es $I$.])

#pregunta(10, [Una hormiga camina hacia afuera por un radio de una calesita que gira. Visto desde afuera, ¿qué aceleraciones tiene?],
  [Centrípeta, $-Omega^2 r$ hacia el centro, y de Coriolis, $2 Omega v$ de costado. Desde la calesita, ninguna. Para que siga el radio, la calesita la empuja de costado con $2 m Omega v$; ella lo siente al revés: la «fuerza» de Coriolis.])

#pregunta(11, [Después de que lo golpea el meteorito, nadie le aplica torque al satélite. ¿Por qué se bambolea?],
  [Porque el golpe le dejó el momento angular inclinado respecto de su eje. Sin torque, $bold(H)_G$ queda fijo en esa dirección nueva, y el eje del satélite (con $bold(omega)$) da vueltas alrededor de él: un cono. El bamboleo es la precesión libre, y nadie la sostiene.])

#pregunta(12, [Prediga sin cuentas: si el mismo meteorito pegara sobre el eje de simetría, o con la velocidad apuntando a $G$, ¿habría bamboleo? ¿Y si pegara en el punto simétrico del otro lado?],
  [Sobre el eje o apuntando a $G$, $bold(r)$ es paralelo a $bold(v)_0$ y $bold(r) times m_0 bold(v)_0 = 0$: $bold(H)_G$ no se inclina y no hay bamboleo (el satélite sólo cambia un poquito su velocidad). Del otro lado, por simetría, el mismo $theta$ con el eje de precesión del lado opuesto: cambia el signo de la componente transversal, no su tamaño.])

#pregunta(13, [En un CMG, ¿por qué con un motor chico se saca un torque grande?],
  [Porque el motor sólo gira el gimbal; el torque de salida, $h dot(delta)$, sale de girarle la dirección a un momento angular grande que ya estaba guardado en el rotor. Sale sobre el tercer eje. Una rueda de reacción, en cambio, da como mucho el torque de su motor.])

#pregunta(14, [En la figura «Precesiones», ¿qué son $I_0$ y $beta$? ¿Por qué en un cuerpo $dot(psi) > 0$ y en el otro $dot(psi) < 0$?],
  [$I_0$ es el momento transversal (el $I'$ del Beer) e $I$ el axial. $beta$ es el ángulo entre $bold(omega)$ y $bold(H)_G$; el $gamma$ del Beer va de $bold(omega)$ al eje, así que $beta = abs(theta - gamma)$. Con $dot(psi)\/dot(phi) = ((I' - I)\/I) cos theta$: el cilindro ($I < I'$) da $dot(psi) > 0$, directa; el disco ($I > I'$), $dot(psi) < 0$, retrógrada.])

#pregunta(15, [Escriba el momento angular respecto de un punto fijo $O$ de un cuerpo que se traslada y gira. ¿Cuándo $bold(H)_O = bold(H)_G$?],
  [$bold(H)_O = overline(bold(r)) times m overline(bold(v)) + bold(H)_G$ (Beer 18.11): el «orbital» de $G$ más el «propio». Son iguales si $overline(bold(r)) times m overline(bold(v)) = 0$: $G$ quieto, $O$ en $G$, o $overline(bold(v))$ apuntando a $O$ o desde $O$.])

#pregunta(16, [Explique con la mano derecha por qué un giróscopo colgado de un extremo de su eje no se cae.],
  [Pulgar sobre el eje, hacia donde apunta el giro ($bold(H)$). El peso hace un par horizontal y perpendicular al eje: índice. El mayor queda vertical: el eje gira en el plano horizontal (precesa). El par no hace crecer $bold(H)$ hacia abajo sino que le cambia la dirección de costado: $d bold(H) = sum bold(M) d t$ es perpendicular a $bold(H)$, como la fuerza central con la velocidad en una órbita.])

= Las fórmulas, juntas

#tabla((auto, auto),
  [sistema de partículas], [$sum bold(F) = m overline(bold(a)), quad sum bold(M)_G = dot(bold(H))_G$],
  [rígido], [$bold(v) = bold(omega) times bold(r), quad bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B\/A)$],
  [transporte], [$(d bold(A))/(d t) bar.v_"fijo" = (d bold(A))/(d t) bar.v_"móvil" + bold(Omega) times bold(A)$],
  [sistema rotante], [$bold(a)_I = bold(a)_C + 2 bold(Omega) times bold(v)_C + bold(Omega) times (bold(Omega) times bold(r)) + dot(bold(Omega)) times bold(r)$],
  [momento angular], [$bold(H)_G = bold(I) bold(omega)$; en ejes principales, $H_x = I_x omega_x$, etc.; $T = 1/2 bold(omega) dot.op bold(H)_G$],
  [Steiner], [$I_P = I_G + m d^2$],
  [respecto de $O$], [$bold(H)_O = overline(bold(r)) times m overline(bold(v)) + bold(H)_G$; punto fijo: $bold(H)_O = bold(I)_O bold(omega)$],
  [energía en 3D], [$T = 1/2 m overline(v)^2 + 1/2 (I_x omega_x^2 + I_y omega_y^2 + I_z omega_z^2) = 1/2 m overline(v)^2 + 1/2 bold(omega) dot.op bold(H)_G$],
  [eje fijo ($bold(omega) = omega hat(k)$)], [$sum M_x = -I_(x z) alpha + I_(y z) omega^2, quad sum M_y = -I_(y z) alpha - I_(x z) omega^2, quad sum M_z = I_z alpha$],
  [ley con ejes móviles], [$sum bold(M)_G = (dot(bold(H))_G)_"móvil" + bold(Omega) times bold(H)_G$],
  [Euler ($bold(Omega) = bold(omega)$)], [$sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z$ y cíclicas],
  [giróscopo], [$bold(omega) = dot(phi) bold(K) + dot(theta) hat(j) + dot(psi) hat(k), quad bold(Omega) = bold(omega) - dot(psi) hat(k)$],
  [precesión estable], [$sum bold(M)_O = (I omega_z - I' dot(phi) cos theta) dot(phi) sin theta thin hat(j); quad theta = 90degree: I dot(psi) dot(phi) hat(j)$],
  [libre de cuplas], [$tan gamma = (I\/I') tan theta, quad dot(phi) = H_G\/I', quad dot(psi)\/dot(phi) = ((I' - I)\/I) cos theta$],
  [directa / retrógrada], [$I < I'$ (alargado): directa; $I > I'$ (achatado): retrógrada],
  [impulso (choque)], [$bold(H)_G^+ = bold(H)_G^- + bold(r) times m_0 bold(v)_0, quad omega_x = H_x \/ I', quad omega_z = H_z \/ I$],
  [ley de los senos], [$omega \/ sin theta = dot(phi) \/ sin gamma = dot(psi) \/ sin(theta - gamma)$],
  [CMG], [$tau_"salida" = h dot(delta)$ sobre el tercer eje; amplificación $= tau_"salida" \/ tau_"motor"$],
  [trompo ($theta$ variable)], [se conservan $E$, $bold(K) dot.op bold(H)_O$ e $I omega_z$],
)
