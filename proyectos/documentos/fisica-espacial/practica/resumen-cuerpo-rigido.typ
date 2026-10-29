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
// =====================================================================
#import "estilo.typ": *
#import "../apunte/biblioteca/figuras.typ": fig-conos

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
]

= 0. Lo que quiere Aníbal: siete ideas, dichas simple y después demostradas
#origen[Sus criterios: concepto antes que deducción, «no se compliquen», intuición en lo antiintuitivo, la analogía giróscopo–órbita, la simetría para no calcular. Cada idea va primero en palabras y después con vectores.]

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
$H_x = I' omega_x$, $H_z = I omega_z$; si $I != I'$, $bold(H)_G$ y
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
angular perpendicular a $bold(H)$, lo mismo. Con vectores: $bold(H)_G^+ =
bold(H)_G^- + bold(r) times m_0 bold(v)_0$ (Beer §18.3: sin impulso externo,
antes y después son equipolentes).

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
vectores: después de un golpe paralelo al eje a distancia $d$, $tan theta =
m_0 v_0 d \/ (I omega_0)$.

*7. Girarle la dirección a un momento angular grande cuesta, o da, un
torque grande.* En palabras: el giróscopo no se resiste a girar, se
resiste a que le cambien el eje, y contesta a $90degree$. Si uno le gira el
eje a la fuerza, aparece un torque perpendicular (giro de entrada, torque
de salida: el CMG); si uno le aplica un torque, el eje gira perpendicular
(torque de entrada, giro de salida: la precesión). Con vectores: $sum
bold(M) = bold(Omega) times bold(H)$, la misma ecuación leída para los dos
lados.

#notacion[
  *Las letras de la cátedra, que son las del Beer:* $bold(H)_G$ (Beer) $=$
  $bold(L)$ (las hojas de Aníbal) $=$ «impulso angular» (la guía) — el
  momento angular respecto del centro de masa. $bold(omega)$ es la
  velocidad angular del *cuerpo*; $bold(Omega)$, la del *sistema de
  referencia* desde el que se deriva. Aníbal lo subraya en su hoja: *«no
  siempre $bold(Omega) = bold(omega)$»*. En un cuerpo con eje de simetría,
  $I$ es el momento *axial* (sobre el eje) e $I'$ el *transversal*. Ojo: el
  apunte los tuvo al revés hasta el 27/10; desde ahí usa las del Beer. Y
  *«razón de cambio»* es derivada respecto del tiempo.
]

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
  con las velocidades absolutas o con las relativas a $G$ ($bold(H)_G =
  bold(H)'_G$): por eso se puede trabajar desde el centro de masa. La
  energía cinética se parte en la del centro de masa más la relativa a él.
]

= 2. Qué es un cuerpo rígido y cómo se mueve
#origen[Beer §15.1 a 15.3, 15.7 y 15.12 — apunte, módulo 18]

*La idea.* Rígido: la distancia entre dos puntos cualesquiera no cambia.
Consecuencia que Aníbal dijo en clase: *todos sus puntos tienen la misma
velocidad angular*. Y con un punto fijo, *todo* movimiento es, en cada
instante, una rotación alrededor de un eje que pasa por ese punto: el *eje
instantáneo*, que es la dirección de $bold(omega)$.

$ bold(v) = bold(omega) times bold(r), quad quad bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B\/A) $

- *Las velocidades angulares se suman* como vectores (el disco que gira en
  una horquilla que gira: $bold(omega) = bold(omega)_1 + bold(omega)_2$).
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
agrega. En las resoluciones de la cátedra se llama *teorema del transporte*:

$ (d bold(A))/(d t) bar.v_"fijo" = (d bold(A))/(d t) bar.v_"móvil" + bold(Omega) times bold(A) $

con $bold(Omega)$ la velocidad angular *de los ejes*. Si $bold(A)$ está
pegado al cuerpo y los ejes también, la derivada móvil es cero y queda
$dot(bold(A)) = bold(omega) times bold(A)$. Aplicada a la posición dos veces
sale la aceleración en un sistema rotante:

$ bold(a)_I = bold(a)_C + 2 bold(Omega) times bold(v)_C + bold(Omega) times (bold(Omega) times bold(r)) + dot(bold(Omega)) times bold(r) $

*La hormiga de la hoja:* camina a $0,5$ m/s por una línea pintada en un
disco que gira a $1$ rad/s. A los $2$ s, desde afuera, su velocidad es
$(0,5; 1,0)$ m/s ($1,12$ m/s de módulo) y su aceleración $(-1,0; 1,0)$ m/s²
($1,41$ m/s²): centrípeta más Coriolis. Desde el disco, aceleración cero.
Un proyectil hacia el norte a $300$ m/s en Buenos Aires ($35degree$ S)
tiene una Coriolis horizontal de $2 Omega_T v sin 35degree approx 0,025$
m/s², hacia el oeste.

#trampa[
  Los errores que la hoja de Aníbal lista, en orden: (1) «$bold(A)$ visto
  desde el cuerpo» y «desde afuera» *no son dos vectores*, son dos
  derivadas; (2) *derivar las componentes no alcanza*: falta el término de
  los versores; (3) para la aceleración se deriva $bold(v)_I$, no la
  velocidad que ve el disco: por eso Coriolis lleva un 2; (4) todos los
  términos en la misma base; (5) $bold(Omega)$ es la de los ejes respecto
  del inercial, no la de lo que se mueve adentro. Y un regalo: aplicada a
  $bold(Omega)$ misma, $bold(Omega) times bold(Omega) = 0$, así que
  $dot(bold(Omega))$ es igual en los dos sistemas.
]

= 4. Momento angular, momentos de inercia y ejes principales
#origen[Beer §18.2 (ecs. 18.11 y 18.13, fig. 18.6) y §18.5 · Beer vol. 1, §9.16–9.17 · apunte, módulo 19]

*La idea.* Para un rígido, $bold(H)_G = bold(I) thin bold(omega)$, con
$bold(I)$ el *tensor de inercia* (una matriz, no un número). En los *ejes
principales* la matriz es diagonal:

$ bold(H)_G = I_x omega_x hat(i) + I_y omega_y hat(j) + I_z omega_z hat(k), quad quad T = 1/2 bold(omega) dot.op bold(H)_G $

y en general *$bold(H)_G$ no es paralelo a $bold(omega)$* (la mancuerna
inclinada, la rueda desbalanceada). Sólo lo es si el cuerpo gira sobre un
eje principal.

- *Los ejes principales salen de la simetría, sin integrar*: un eje de
  simetría es principal; un plano de simetría tiene su normal principal.
- *No se calculan momentos de inercia* (Aníbal: «no es la idea»): se buscan
  en la tabla. *Steiner*, $I_P = I_G + m d^2$: saber que existe y qué dice.
- El momento de inercia *aparece* al escribir la energía cinética (lo
  preguntó así en el parcialito 4: «haga surgir»).

= 5. Ecuaciones del movimiento y ecuaciones de Euler
#origen[Beer §18.5–18.6 · resumen manuscrito de Aníbal, hoja 1 · apunte, módulo 20]

*La idea.* $sum bold(M)_G = dot(bold(H))_G$ pide la derivada *en el espacio
fijo*, pero $bold(H)_G$ es simple en ejes que giran con el cuerpo, porque
ahí $bold(I)$ es constante. La regla de la sección 3 lo resuelve:

$ sum bold(M)_G = (dot(bold(H))_G)_"móvil" + bold(Omega) times bold(H)_G $

*Ejes clavados al cuerpo* ($bold(Omega) = bold(omega)$), principales, dan
las *ecuaciones de Euler* (Beer §18.6, ec. 18.25; así las escribe Aníbal):

$ sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z $
$ sum M_y = I_y dot(omega)_y - (I_z - I_x) omega_z omega_x $
$ sum M_z = I_z dot(omega)_z - (I_x - I_y) omega_x omega_y $

Los términos cruzados son los *giroscópicos*: aunque no haya cupla, una
componente de $bold(omega)$ le cambia a otra. Son no lineales: se estudian
casos particulares.

#trampa[
  *«No siempre $bold(Omega) = bold(omega)$»* (subrayado en la hoja de
  Aníbal). En un cuerpo de revolución conviene usar ejes que siguen el eje
  de simetría pero *no giran con el spin*: los momentos de inercia siguen
  constantes y la cuenta se achica. Entonces en el $bold(Omega) times
  bold(H)$ va la de los ejes, no la del cuerpo. Antes de escribir la
  ecuación, decir a qué están clavados los ejes.
]

*El Ejercicio 3 de la guía (el volante en el gimbal).* Con los ejes del
gimbal: $I_x dot(Omega)_x = M_x - omega_p I_z omega_s$. Con la cupla de
$600$ N·m, $dot(Omega)_x = 20$ rad/s² (no $600\/5 = 120$: $500$ N·m se van en
llevar a $bold(H)$ de paseo con la plataforma). *Sin cupla*, como lo
resolvió Aníbal: $dot(Omega)_x = -100$ rad/s² en $t = 0$. El gimbal suelto
arranca solo, buscando poner el eje del volante paralelo al giro de la
plataforma; se pasa y *oscila*. Es el girocompás del GIF.

*La otra mitad de §18.6: la extensión de d'Alembert.* Las fuerzas externas
sobre un rígido equivalen a $m overline(bold(a))$ aplicada en $G$ más una
cupla $dot(bold(H))_G$. Sirve para sacar reacciones. El caso de §18.7–18.8 es
el *eje fijo*: un disco montado torcido un ángulo $beta$ en un eje que gira
con $omega$ constante tiene $bold(H)_G$ fuera de $bold(omega)$, que da vueltas
con el eje, y los cojinetes tienen que hacer la cupla

$ abs(dot(bold(H))_G) = abs(bold(omega) times bold(H)_G) = (I - I') omega^2 sin beta cos beta $

con dos fuerzas opuestas que *giran con el eje* (el desbalance dinámico,
módulo 19). Crece con $omega^2$ y desaparece si el eje de giro es principal
($beta = 0$). Con números, en el Ejercicio 10 del modelo de parcialito 5.

= 6. El giróscopo y los ángulos de Euler
#origen[Beer §18.9, figs. 18.15–18.16 · resumen manuscrito de Aníbal, hoja 2 · apunte, módulo 20]

*La idea* (Aníbal: «el giróscopo ayuda a visualizar los ángulos de
Euler»). Un rotor en dos cardanes (balancines), con el centro de masa fijo.
Tres articulaciones, tres ángulos:

#tabla((auto, auto, auto, auto),
  [*ángulo*], [*nombre*], [*quién gira*], [*alrededor de*],
  [$phi$], [precesión], [balancín exterior], [el eje fijo $Z$ ($A A'$)],
  [$theta$], [nutación], [balancín interior], [la línea de nodos ($B B'$)],
  [$psi$], [spin, giro propio], [el rotor], [su eje de simetría ($C C'$)],
)

Con los ejes $x y z$ pegados al balancín *interior* ($z$ sobre el rotor,
$y$ sobre $B B'$), que precesan y nutan pero no giran con $psi$:

$ bold(omega) = dot(phi) bold(K) + dot(theta) hat(j) + dot(psi) hat(k), quad quad bold(K) = -sin theta thin hat(i) + cos theta thin hat(k) $
$ bold(Omega) = -dot(phi) sin theta thin hat(i) + dot(theta) hat(j) + dot(phi) cos theta thin hat(k) $
$ bold(H)_O = -I' dot(phi) sin theta thin hat(i) + I' dot(theta) hat(j) + I (dot(psi) + dot(phi) cos theta) hat(k) $

La única diferencia entre $bold(Omega)$ y $bold(omega)$ es el spin (la nota
de Aníbal: «ojo, no gira en $psi$»). Metidas en $sum bold(M)_O =
(dot(bold(H))_O)_"móvil" + bold(Omega) times bold(H)_O$ dan las tres
ecuaciones del giróscopo (Beer 18.39): no lineales, sin solución general a
mano.

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
18.19): el spin «persigue» al par. Con el peso de palanca, $M g l = I
omega_"spin" omega_"prec"$, que es el $Omega = tau \/ L$ del Sears (Aníbal
remite al giróscopo del parcialito 3).

*Con el eje inclinado y el peso* (el trompo o el giróscopo apoyado en $O$):
el par del peso es $W c sin theta$, el $sin theta$ se simplifica y queda

$ W c = (I omega_z - I'_O dot(phi) cos theta) dot(phi) quad arrow.r.double quad (I - I'_O) cos theta thin dot(phi)^2 + I dot(psi) thin dot(phi) - W c = 0 $

Es *cuadrática*: hay dos precesiones estables posibles, una lenta (la que se
ve, $dot(phi) approx W c \/ (I dot(psi))$ si $dot(phi) << dot(psi)$) y una
rápida. $I'_O$ es respecto del pivote (Steiner, $I'_G + m c^2$), y $omega_z$
lleva el $dot(phi) cos theta$. Con menos spin la lenta se *acelera*, hasta
que deja de haber solución y el trompo cae. Con números, en el Ejercicio 11
del modelo de parcialito 5.

#trampa[
  El giróscopo no cae para el lado del par: precesa perpendicular a él. Y
  la precesión estable es un caso *particular*: para mantenerla hace falta
  exactamente ese par; si no, aparece nutación.
]

= 8. Cuerpo simétrico sin cupla: precesión libre
#origen[Beer §18.11, ecs. 18.46 a 18.52, figs. 18.20 a 18.24 · cuaderno del Beer 18.127 · apunte, módulo 21]

*La idea.* Sin cupla, $bold(H)_G$ queda *fijo en el espacio* y hace de eje
de precesión. El eje del cuerpo da vueltas alrededor de $bold(H)_G$ con
$theta$ constante: nadie la sostiene, es automática. Dos ángulos contra el
eje del cuerpo: $theta$ (a $bold(H)_G$) y $gamma$ (a $bold(omega)$):

$ tan gamma = I/I' tan theta, quad quad dot(phi) = H_G/I', quad quad dot(psi)/dot(phi) = (I' - I)/I cos theta $

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
= -0,159$ rad/s: retrógrada, porque el satélite es achatado ($k_y > k_x$).
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

Con los números del libro (dos discos de radio $0,8$ m, $60$ rpm, meteorito
de $m\/1000$ a $2000$ m/s): $omega_x = 2$ rad/s, $gamma = 17,7degree$,
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
- *De salida*: el que recibe el satélite, sobre el tercer eje, de módulo
  $h dot(delta)$: el rotor cambia su momento a razón $dot(bold(delta)) times
  bold(h)$ y el satélite se lleva el opuesto.

La *amplificación* es salida sobre entrada. Con el volante del Ejercicio 3
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
la *energía* (el peso es conservativo), el *momento angular sobre el eje
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
  [$T = sum 1/2 m_i v_i^2$ con $v_i = r_i omega$ (el mismo $omega$ para todos, $r_i$ la distancia al eje): $T = 1/2 (sum m_i r_i^2) omega^2$. Lo de adentro del paréntesis sólo depende de cómo está repartida la masa respecto del eje: eso es $I$.])

#pregunta(10, [Una hormiga camina hacia afuera por un radio de una calesita que gira. Visto desde afuera, ¿qué aceleraciones tiene?],
  [Centrípeta, $-Omega^2 r$ hacia el centro, y de Coriolis, $2 Omega v$ de costado. Desde la calesita, ninguna. Para que siga el radio, la calesita la empuja de costado con $2 m Omega v$; ella lo siente al revés: la «fuerza» de Coriolis.])

#pregunta(11, [Después de que lo golpea el meteorito, nadie le aplica torque al satélite. ¿Por qué se bambolea?],
  [Porque el golpe le dejó el momento angular inclinado respecto de su eje. Sin torque, $bold(H)_G$ queda fijo en esa dirección nueva, y el eje del satélite (con $bold(omega)$) da vueltas alrededor de él: un cono. El bamboleo es la precesión libre, y nadie la sostiene.])

#pregunta(12, [Prediga sin cuentas: si el mismo meteorito pegara sobre el eje de simetría, o con la velocidad apuntando a $G$, ¿habría bamboleo? ¿Y si pegara en el punto simétrico del otro lado?],
  [Sobre el eje o apuntando a $G$, $bold(r)$ es paralelo a $bold(v)_0$ y $bold(r) times m_0 bold(v)_0 = 0$: $bold(H)_G$ no se inclina y no hay bamboleo (el satélite sólo cambia un poquito su velocidad). Del otro lado, por simetría, el mismo $theta$ con el eje de precesión del lado opuesto: cambia el signo de la componente transversal, no su tamaño.])

#pregunta(13, [En un CMG, ¿por qué con un motor chico se saca un torque grande?],
  [Porque el motor sólo gira el gimbal; el torque de salida, $h dot(delta)$, sale de girarle la dirección a un momento angular grande que ya estaba guardado en el rotor. Sale sobre el tercer eje. Una rueda de reacción, en cambio, da como mucho el torque de su motor.])

= Las fórmulas, juntas

#tabla((auto, auto),
  [sistema de partículas], [$sum bold(F) = m overline(bold(a)), quad sum bold(M)_G = dot(bold(H))_G$],
  [rígido], [$bold(v) = bold(omega) times bold(r), quad bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B\/A)$],
  [transporte], [$dot(bold(A))_"fijo" = dot(bold(A))_"móvil" + bold(Omega) times bold(A)$],
  [sistema rotante], [$bold(a)_I = bold(a)_C + 2 bold(Omega) times bold(v)_C + bold(Omega) times (bold(Omega) times bold(r)) + dot(bold(Omega)) times bold(r)$],
  [momento angular], [$bold(H)_G = bold(I) bold(omega)$; en ejes principales, $H_x = I_x omega_x$, etc.; $T = 1/2 bold(omega) dot.op bold(H)_G$],
  [Steiner], [$I_P = I_G + m d^2$],
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
