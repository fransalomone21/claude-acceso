// =====================================================================
//  Modelo B del 2.o parcial (26/11/2026) -- cuerpo rigido, Beer cap. 18.
//  2026-11-25, mismo pedido que el modelo A (Fran: «2 modelos de 2do
//  parcial sabiendo que no entran CMG, igual mete alguno de CMG como extra»).
//  Misma forma (ANI-41 + un cuarto al estilo de los parcialitos), otros
//  casos: el meteorito sobre un cuerpo ACHATADO (retrograda, el PR 18.6 que
//  mando Anibal), el disco torcido en sus cojinetes (d'Alembert, §18.7-18.8),
//  el trompo en precesion estable con las dos raices (§18.10) y, en palabras,
//  Euler, Explorer 1 y la analogia giroscopo-orbita. Cada numero sale de
//  cuentas_2do_parcial.py, por dos caminos, y lo mide validar.py.
// =====================================================================
#import "estilo.typ": *
#import "workflow.typ": W, tipo, oral
#import "figuras-2do-parcial.typ": fig-b1-satelite, fig-b1-suma, fig-b1-libre, fig-b3-raices, fig-b-cmg
#import "../apunte/biblioteca/figuras-precesion.typ": fig-disco-torcido
#import "../apunte/biblioteca/figuras-omega.typ": fig-omega-trompo-completa
#import "../apunte/biblioteca/figuras-euler.typ": fig-explorer

#show: documento.with(
  titulo: [Modelo B de 2.º parcial — cuerpo rígido],
  subtitulo: [Un meteorito que hace bambolear un satélite achatado, el disco torcido en sus cojinetes, el trompo en precesión estable, y Euler, el Explorer 1 y la órbita en palabras. Con un extra de CMG],
  encabezado: [Modelo B de 2.º parcial — cuerpo rígido],
)

#caja([Qué entra, y de dónde sale cada ejercicio], c-azul)[
  Mismo parcial que el modelo A (jueves 26/11, ANI-74; *el CMG no entra*, lo dijo Fran el 25/11: va de extra) y la
  misma forma —numérico del Beer con figura, dibujo 3D con preguntas cortas, «escriba (o deduzca)» con «opine», y uno
  en palabras como los parcialitos—, con los casos que el A no tiene: el cuerpo *achatado* (retrógrada), el *eje fijo*
  con sus cojinetes y el *trompo* con peso.

  // simbolos: H_G, omega, phidot, psidot
  #set par(justify: false)
  #table(
    columns: (0.35fr, 1.6fr, 1.4fr, 1.1fr),
    inset: (x: 4pt, y: 3pt),
    table.header(..([Ej.], [Qué es], [Forma (cómo pregunta Aníbal)], [Beer / guía]).map(t => text(size: 8pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([1], [Meteorito sobre un satélite achatado que gira: $bold(H)_G$, $bold(omega)$, conos, $dot(phi)$ y $dot(psi)$], [numérico con figura, con el workflow de ocho pasos], [PR 18.6 y 18.127 (el cuaderno de Aníbal); P4 de CR]),
      ([2], [Disco torcido sobre un eje fijo: $bold(H)_G$, cupla y cojinetes], [dibujo 3D + preguntas; «diga si depende de…»], [§18.7–18.8 (d'Alembert)]),
      ([3], [Trompo en precesión estable: las dos raíces y el spin mínimo], [«escriba (o deduzca)» + números + «opine»], [§18.10, ec. 18.44; hoja 4 de Aníbal]),
      ([4], [Ángulos de Euler, Explorer 1, giróscopo y órbita], [parcialitos 3 y 5, en palabras; opción múltiple], [§18.9, §18.11; Sears §10.7]),
      ([extra], [CMG que reorienta el satélite], [de yapa: no entra], [m22 del apunte]),
    ).flatten().map(c => text(size: 8pt, c)),
  )
]

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Dos horas y media, con calculadora y la hoja de fórmulas. Toda aproximación se dice y se justifica (ANI-53). Donde
  se pide un dibujo, el dibujo es parte de la respuesta. *Notación (la del Beer y la de Aníbal):* $bold(H)_G$ es el
  momento angular respecto del centro de masa $G$ y $bold(H)_O$ respecto de un punto fijo $O$ (la guía les dice
  _impulso angular_); $bold(omega)$ es la velocidad angular del cuerpo; en un cuerpo de revolución, $I$ es el momento
  de inercia *axial* e $I'$ el *transversal*; $theta$ es el ángulo entre $bold(H)_G$ y el eje de simetría, y $gamma$
  el ángulo entre $bold(omega)$ y ese eje; $dot(phi)$ es la velocidad de precesión y $dot(psi)$ la de spin.
  // simbolos: H_G, G, H_O, O, omega, I, I', theta, gamma, phidot, psidot
]

= Enunciados

#consigna[
#ejercicio(1, [el meteorito y el satélite achatado], [3])
#origen[Beer §18.3 y §18.11; el molde es el Problema Resuelto 18.6 («hacer este problema es aprender a hacer el resto», Aníbal) y el 18.127 de su cuaderno.]

Un satélite de masa $m = 600$ kg es un cuerpo de revolución alrededor de su eje $z$, con radios de giro respecto de
$G$ $k = 1,00$ m (axial) y $k' = 0,80$ m (transversal). Gira alrededor de su eje con $omega_0 = 1,50$ rad/s cuando un
meteorito de $m_m = 0,30$ kg, que viaja a $v_m = 2000$ m/s paralelo a $-z$, se incrusta en el punto $C$ del borde de
la tapa, en $bold(r)_C = (0; 1,00; 0,40)$ m respecto de $G$.
// simbolos: m, z, k, k', omega_0, m_m, v_m, C, r_C

#figure(fig-b1-satelite)

#set enum(numbering: "a)")
+ Determine $bold(H)_G$ inmediatamente después del choque y el ángulo $theta$ con el eje del satélite. Diga qué
  supuestos hace.
+ Determine $bold(omega)$ inmediatamente después y el ángulo $gamma$ con el eje.
+ ¿La precesión es directa o retrógrada? Justifique y dibuje los conos.
+ Calcule las velocidades de precesión $dot(phi)$ y de spin $dot(psi)$. Interprete el signo de $dot(psi)$.
+ ¿Cuánto cambia la velocidad de $G$? ¿Se conserva la energía cinética en el choque? ¿Por qué?
+ *Opine:* ¿dónde tendría que haber pegado el meteorito para no dejar bamboleo?
]

#consigna[
#ejercicio(2, [el disco torcido en su eje], [2,5])
#origen[Beer §18.7–18.8 (extensión de d'Alembert, eje fijo, reacciones en los cojinetes); la mancuerna del parcialito 4.]

Un disco delgado de masa $m = 3,0$ kg y radio $r = 0,12$ m está montado con su centro $G$ sobre un eje $A B$, pero
torcido: su eje de simetría forma $beta = 5 degree$ con el eje $A B$. El eje gira a 1200 rpm constantes, sostenido
por dos cojinetes separados $L = 0,40$ m, con $G$ en el medio. Ignore el peso.
// simbolos: r, A, B, beta, L

#figure(fig-disco-torcido(respuesta: false))

#set enum(numbering: "a)")
+ Dibuje los ejes principales del disco en $G$ y descomponga $bold(omega)$ sobre ellos.
+ Escriba $bold(H)_G$ en esos ejes. ¿Es paralelo a $bold(omega)$? ¿Qué ángulo forman? ¿Qué forma describe $bold(H)_G$
  al girar?
+ Calcule $dif bold(H)_G \/ dif t$ (módulo y dirección) y las fuerzas que hacen los cojinetes. Compárelas con el peso.
+ Diga si dependen del sistema de coordenadas elegido: el vector $bold(H)_G$; sus componentes.
+ ¿Para qué valores de $beta$ los cojinetes no hacen fuerza? ¿Y si los momentos de inercia fueran iguales?
+ Si se soltara el eje en el espacio, sin cojinetes, ¿seguiría girando igual? ¿Por qué?
]

#consigna[
#ejercicio(3, [el trompo en precesión estable], [2,5])
#origen[Beer §18.10, ec. 18.44 y figs. 18.17–18.19; la hoja 4 de Aníbal, «Precesión estable».]

Un trompo simétrico de masa $m = 0,30$ kg apoya su punta en el punto fijo $O$; su centro de masa está a $c = 0,040$ m
de $O$ sobre el eje. Respecto de $O$, $I = 1,2 times 10^(-4)$ kg·m² (axial) e $I' = 6,0 times 10^(-4)$ kg·m²
(transversal). Use $g = 9,81$ m/s².
// simbolos: c, g

+ Dibuje el sistema de coordenadas (fijo $X Y Z$ y el móvil $x y z$ del Beer), el peso, $bold(H)_O$ y el momento del
  peso.
+ Escriba (o deduzca) $bold(H)_O$ en los ejes $x y z$ en función de $dot(phi)$, $theta$ y $dot(psi)$.
+ Escriba (o deduzca) la condición de precesión estable ($theta$, $dot(phi)$, $dot(psi)$ constantes) y muestre que
  queda una ecuación de segundo grado en $dot(phi)$.
+ Con $theta = 60 degree$ y $dot(psi) = 150$ rad/s, calcule las dos velocidades de precesión posibles y compárelas
  con la aproximación $dot(phi) approx W c \/ (I dot(psi))$.
+ ¿Cuál es el spin mínimo para que haya precesión estable con $theta = 60 degree$?
+ *Opine:* ¿qué ve el que larga el trompo con menos spin? ¿Y con $theta = 90 degree$, qué cambia en la cuenta?
// simbolos: X, Y, Z, x, y, W
]

#consigna[
#ejercicio(4, [en palabras: Euler, el Explorer 1 y la órbita], [2])
#origen[Parcialito 5 (los ángulos en palabras), parcialito 3 y la analogía de la cátedra (Sears §10.7), las preguntas orientadoras de CR (Explorer 1).]

+ Valiéndose *solamente de palabras*, defina los tres ángulos de Euler para el satélite del Ejercicio 1 después del
  choque (respecto de qué miden, y qué gira cada uno). ¿Cuáles cambian con el tiempo y cuál queda fijo?
+ El Explorer 1 (1958) era un cilindro alargado puesto a girar alrededor de su eje largo, con cuatro antenas flexibles.
  En menos de una vuelta a la Tierra terminó girando de punta. Explique por qué con el momento angular y la energía.
+ Un giróscopo con un torque perpendicular a su $bold(L)$ no se cae: precesa. Un satélite en órbita circular no se cae
  a la Tierra. Explique por qué es la misma idea.
+ Marque la correcta. En un cuerpo rígido libre de cuplas: (i) $bold(omega)$ queda fijo en el espacio; (ii)
  $bold(H)_G$ queda fijo en el cuerpo; (iii) $bold(H)_G$ queda fijo en el espacio y $bold(omega)$ puede moverse
  respecto de él; (iv) si $bold(omega)$ no está sobre un eje principal, hace falta una cupla para que gire.
// simbolos: L
]

#consigna[
#ejercicio([extra], [de yapa (el CMG no entra): el CMG que reorienta el satélite], [1])
#origen[Módulo 22 del apunte, «El CMG por dentro» y la saturación; la guía del parcialito de CMG.]

Un satélite quieto tiene un CMG con $h = 20$ N·m·s, al principio sobre su eje $x$. El cardán, de eje $z$, empieza a
girar con $dot(delta) = 0,30$ rad/s. El momento de inercia del satélite es $I_s = 500$ kg·m² alrededor de $x$ y de
$y$, y el CMG cuenta poco en él.
// simbolos: h, deltadot, I_s

#set enum(numbering: "a)")
+ ¿Qué cupla recibe el satélite al arrancar, y alrededor de qué eje empieza a girar?
+ Sin integrar la cupla: ¿qué velocidad angular tiene el satélite cuando el cardán giró $delta = 30 degree$? Dibuje
  $bold(h)$ antes y después, $Delta bold(h)$ y lo que se lleva el satélite.
// simbolos: Delta
+ ¿Cuál es la máxima velocidad angular que este CMG le puede dar sobre $y$? ¿Qué pasa ahí?
// simbolos: delta
]

#pagebreak()
= Resoluciones

== Resolución del Ejercicio 1 — el meteorito y el satélite achatado

#tipo([B])[Un choque que se incrusta fuera de $G$: es un impulso, y suma $bold(r)_C times bold(p)$ al $bold(H)_G$ que el
satélite ya tenía. Después queda libre de cuplas. Es el PR 18.6 con otros números y otro cuerpo: acá el satélite es
*achatado*, y eso da vuelta la conclusión del modelo A.]

#W(1)
Datos: $I = m k^2 = 600 dot.op 1,00^2 = 600$ kg·m² (axial), $I' = m k'^2 = 600 dot.op 0,80^2 = 384$ kg·m²
(transversal): $I > I'$, *achatado*. Antes: $bold(H)_0 = I omega_0 hat(k) = 900 hat(k)$ kg·m²/s. La cantidad de
movimiento del meteorito: $bold(p) = m_m bold(v)_m = 0,30 dot.op 2000 (-hat(k)) = -600 hat(k)$ kg·m/s.
// simbolos: H_0, p, khat

#W(2)
Ejes $G x y z$ en el centro de masa, pegados al satélite en el instante del choque: $z$ sobre el eje de revolución;
principales por simetría.

#W(3)
En el choque actúa sólo la fuerza del meteorito, enorme y cortísima: impulsiva. Supuestos, dichos (ANI-53): la masa del
meteorito es $0,30 \/ 600 = 0,05$ % de la del satélite, así que no cambia $I$, $I'$ ni la posición de $G$ (se corre
$0,54$ mm); el choque es instantáneo. Después no actúa nada: $bold(H)_G$ constante, y la cantidad de movimiento total
también.

#W(4)
Lo que el meteorito le agrega al momento angular respecto de $G$ es el momento de su cantidad de movimiento,
$bold(r)_C times bold(p)$. Componente por componente, en los ejes del satélite:
$ bold(r)_C times bold(p) = (y_C p_z - z_C p_y; thin z_C p_x - x_C p_z; thin x_C p_y - y_C p_x)
  = (1,00 dot.op (-600); thin 0; thin 0) = (-600; 0; 0) " kg·m²/s". $
// simbolos: x_C, y_C, z_C, p_x, p_y, p_z
Le pega paralelo al eje y lejos del eje: el momento sale *perpendicular* al eje, sobre $-x$. No frena ni acelera el
spin: lo inclina. Sumo:
$ bold(H)_G = (-600; 0; 900) " kg·m²/s", quad abs(bold(H)_G) = sqrt(600^2 + 900^2) = 1081,7 " kg·m²/s", $
y $tan theta = 600 \/ 900 = 0,667$: $theta = 33,7 degree$, del lado de $-x$.

#figure(fig-b1-suma, caption: [La suma, a escala, en el plano $x z$ del satélite. Acá $bold(omega)$ queda *más
  lejos* del eje que $bold(H)_G$.])

#W(5)
$bold(H)_G = bold(I) bold(omega)$ en ejes principales:
$ omega_x = (-600) / 384 = -1,5625 " rad/s", quad omega_y = 0, quad omega_z = 900 / 600 = 1,50 " rad/s", $
// simbolos: omega_x, omega_y, omega_z
con $abs(bold(omega)) = 2,166$ rad/s y $tan gamma = 1,5625 \/ 1,50 = 1,042$: $gamma = 46,2 degree$. La componente
transversal de $bold(H)_G$ se divide por el $I'$ chico y la axial por el $I$ grande: por eso $bold(omega)$ se abre más
que $bold(H)_G$.

#W(6)
$gamma = 46,2 degree > theta = 33,7 degree$: $bold(H)_G$ queda *entre* el eje y $bold(omega)$, y la precesión es
*retrógrada* (achatado, $I > I'$; Beer pág. 1191). Los conos: el espacial, con eje sobre $bold(H)_G$ y semiángulo
$gamma - theta = 12,5 degree$; el corporal, con eje sobre el del satélite y semiángulo $gamma = 46,2 degree$, *envuelve*
al espacial y rueda con su cara de adentro sobre él.

#figure(fig-b1-libre, caption: [Lo que sigue al choque (esquema): $bold(H)_G$ fijo, el eje precesa a su alrededor
  y $bold(omega)$ queda del otro lado de $bold(H)_G$.])

Ley de los senos en el triángulo de $bold(omega) = dot(phi) bold(K) + dot(psi) hat(k)$. Acá $dot(psi)$ sale negativo
(el triángulo se arma con $dot(psi)$ hacia $-hat(k)$), y con módulos:
$ dot(phi) = omega (sin gamma) / (sin theta) = 2,166 dot.op (sin 46,2 degree) / (sin 33,7 degree) = 2,817 " rad/s",
  quad abs(dot(psi)) = omega (sin(gamma - theta)) / (sin theta) = 0,844 " rad/s". $
// simbolos: K
$dot(psi) = -0,844$ rad/s: el satélite, visto desde los ejes que precesan, gira *al revés* de como precesa. Eso es lo
retrógrado.

#W(7)
Otro camino: $dot(phi) = H_G \/ I' = 1081,7 \/ 384 = 2,817$ rad/s, y $dot(psi) = (I' - I) \/ (I I') thin H_G cos
theta = -216 \/ (600 dot.op 384) dot.op 900 = -0,844$ rad/s (el signo sale solo). Y $tan gamma = (I \/ I') tan theta
= 1,5625 dot.op 0,667 = 1,042$. Coinciden.

*El inciso e).* La cantidad de movimiento total se conserva: $m Delta bold(v)_G = bold(p)$, así que $Delta bold(v)_G =
-600 \/ 600 hat(k) = -1,0 hat(k)$ m/s. La energía cinética de rotación pasa de $1/2 I omega_0^2 = 675$ J a
$1/2 (I' omega_x^2 + I omega_z^2) = 1143,75$ J, más 300 J de traslación. Pero el meteorito traía
$1/2 m_m v_m^2 = 600 thin 000$ J: el satélite se queda con el 0,128 %, y el resto se va en calor, en romper y deformar.
El choque es plástico: lo que se conserva es el momento angular y la cantidad de movimiento, no la energía. Por eso se
plantea por impulso y no por energía.
// simbolos: v_G

#W(8)
Conclusiones: $bold(H)_G = (-600; 0; 900)$ kg·m²/s queda fijo; el eje del satélite precesa a su alrededor con
$theta = 33,7 degree$ y $dot(phi) = 2,817$ rad/s, y el satélite gira sobre sí mismo con $dot(psi) = -0,844$ rad/s:
retrógrada. El centro de masa sale a 1,0 m/s hacia $-z$.

*Opine.* Sin bamboleo hace falta $bold(r)_C times bold(p)$ paralelo al eje: con $bold(p)$ sobre $-z$, eso pasa sólo
si el meteorito pega *sobre el eje* ($x_C = y_C = 0$, en el centro de la tapa): no cambia $bold(H)_G$ y sólo empuja
al satélite. Si llegara en otra dirección, haría falta un impulso tangencial en el plano de $G$ (o un par de impulsos opuestos).

#oral(
  ([¿Por qué en el modelo A salía directa y acá retrógrada?], [Por la forma, no por el golpe: alargado ($I < I'$) da $theta > gamma$; achatado ($I > I'$) da $gamma > theta$.]),
  ([¿$dot(psi)$ negativo quiere decir que el satélite dejó de girar como antes?], [No: $omega_z = 1,50$ rad/s sigue igual. $dot(psi)$ es el giro medido desde los ejes que precesan, y la precesión rápida se lo «come».]),
  ([¿La velocidad del meteorito importa, o sólo su cantidad de movimiento?], [Sólo $bold(p)$ y dónde pega: el mismo $bold(p)$ con otra masa da el mismo bamboleo (y otra energía perdida).]),
)

== Resolución del Ejercicio 2 — el disco torcido

*a) Los ejes principales.* Por simetría: la normal $hat(n)$ al disco por $G$ (con $I = 1/2 m r^2 = 0,0216$ kg·m²) y
cualquier par de diámetros (con $I' = 1/4 m r^2 = 0,0108$ kg·m²). Tomo el diámetro $hat(d)$ que está en el plano de
$hat(n)$ y del eje $A B$. El eje gira a $omega = 1200 dot.op 2 pi \/ 60 = 125,7$ rad/s, y $bold(omega)$ (sobre $A B$)
se descompone en $omega cos beta$ sobre $hat(n)$ y $omega sin beta$ sobre $hat(d)$.
// simbolos: nhat, dhat, pi

*b) El momento angular.* Cada componente con su momento de inercia:
$ bold(H)_G = I omega cos beta thin hat(n) + I' omega sin beta thin hat(d)
  = 2,704 thin hat(n) + 0,1183 thin hat(d) " kg·m²/s". $
Como $I != I'$, *no* es paralelo a $bold(omega)$: el $I$ mayor «tira» de $bold(H)_G$ hacia la normal. Proyectado, su
parte perpendicular a $bold(omega)$ es $(I - I') omega sin beta cos beta = 0,1178$ kg·m²/s, y el ángulo entre
$bold(H)_G$ y $bold(omega)$ es $2,50 degree$ (la mitad del camino, porque $I = 2 I'$). $bold(H)_G$ gira con el disco:
barre un cono alrededor del eje $A B$.

#figure(fig-disco-torcido(respuesta: true), caption: [El disco torcido con $beta$ exagerado: $bold(H)_G$ entre el eje
  y la normal, y las fuerzas de los cojinetes, que giran con el eje.])

*c) La cupla.* El eje es fijo y $bold(omega)$ constante, así que $bold(H)_G$ sólo cambia de dirección:
$dif bold(H)_G \/ dif t = bold(omega) times bold(H)_G$, perpendicular al plano de $bold(omega)$ y $bold(H)_G$, de
módulo $omega dot.op 0,1178 = 14,8$ N·m. Esa cupla la tienen que hacer los cojinetes: dos fuerzas opuestas, separadas
$L$, de $F = 14,8 \/ 0,40 = 37,0$ N cada una, que *giran con el eje* (vibración a 1200 rpm). El peso del disco es
$29,4$ N: con sólo 5° de error, la carga dinámica supera a la estática.
// simbolos: F

*d)* El vector $bold(H)_G$ no depende del sistema de coordenadas: es una propiedad del cuerpo y de su movimiento
respecto de $G$. Sus *componentes* sí: en ejes del disco son constantes; en ejes fijos, giran a 1200 rpm.

*e)* $F = 0$ si $sin beta cos beta = 0$: con $beta = 0$ (el disco bien montado, el eje sobre un eje principal) o
$beta = 90 degree$ (el eje sobre un diámetro, también principal). Y si fuera $I = I'$ (un cuerpo isótropo, como una
esfera), $bold(H)_G$ quedaría siempre paralelo a $bold(omega)$: ningún eje produce cupla.

*f) Opine.* No: sin cojinetes nadie hace la cupla, $bold(H)_G$ queda fijo en el espacio y el disco pasa a precesar
alrededor de $bold(H)_G$, libre de cuplas, con $bold(omega)$ moviéndose: es el ejercicio 1 en otro cuerpo. El
«giro alrededor de $A B$» sólo se sostiene a fuerza de cojinetes.

== Resolución del Ejercicio 3 — el trompo

*1. El sistema.* Fijo: $O X Y Z$ con $Z$ vertical hacia arriba. Móvil (el del Beer): $z$ sobre el eje del trompo,
$x$ en el plano vertical que contiene al eje, $y$ horizontal sobre la línea de nodos; no gira con el spin. $theta$ es
el ángulo entre $Z$ y $z$. El peso $W = m g$ cuelga de $G$ y su momento respecto de $O$ es horizontal, sobre $y$, de
módulo $W c sin theta$.

#figure(fig-omega-trompo-completa)

*2. $bold(H)_O$.* La velocidad angular del trompo es la suma de la precesión y el spin, $bold(omega) = dot(phi) bold(K)
+ dot(psi) hat(k)$, y $bold(K) = -sin theta thin hat(i) + cos theta thin hat(k)$ en los ejes móviles. Entonces
$omega_x = -dot(phi) sin theta$, $omega_y = 0$, $omega_z = dot(psi) + dot(phi) cos theta$, y cada componente con su
momento de inercia respecto de $O$:
$ bold(H)_O = -I' dot(phi) sin theta thin hat(i) + I (dot(psi) + dot(phi) cos theta) hat(k). $
// simbolos: ihat

*3. La precesión estable.* Con $theta$, $dot(phi)$ y $dot(psi)$ constantes, las componentes de $bold(H)_O$ en los
ejes móviles no cambian, y su derivada es sólo el arrastre de los ejes, que giran con $bold(Omega) = dot(phi)
bold(K)$:
$ sum bold(M)_O = bold(Omega) times bold(H)_O = (I omega_z - I' dot(phi) cos theta) dot(phi) sin theta thin hat(j). $
// simbolos: Omega, jhat, M_O
Igualo al momento del peso, $W c sin theta thin hat(j)$, y divido por $sin theta$ (con $theta != 0$):
$ (I dot(psi) + (I - I') dot(phi) cos theta) dot(phi) = W c, quad "o sea" quad
  (I' - I) cos theta thin dot(phi)^2 - I dot(psi) thin dot(phi) + W c = 0. $
Segundo grado en $dot(phi)$: hay dos precesiones estables para el mismo $theta$ y el mismo spin.

*4. Con números.* $W c = 0,30 dot.op 9,81 dot.op 0,040 = 0,1177$ N·m; $(I' - I) cos theta = 2,4 times 10^(-4)$;
$I dot(psi) = 0,018$. Las raíces:
$ dot(phi) = (0,018 minus.plus sqrt(0","018^2 - 4 dot.op 2","4 times 10^(-4) dot.op 0","1177)) / (2 dot.op 2,4 times 10^(-4))
  = 7,24 " rad/s" quad "o" quad 67,8 " rad/s". $
La lenta, $7,24$ rad/s, es la que se ve. La aproximación da $W c \/ (I dot(psi)) = 6,54$ rad/s: la lenta es un 10,7 % más grande: con este
spin todavía no es buena, porque $I dot(psi)$ no es mucho más grande que el término que desprecia.

#figure(fig-b3-raices, caption: [Las dos precesiones estables contra el spin, con $theta = 60 degree$: se juntan en el
  spin mínimo.])

*5. El spin mínimo.* Hay raíces reales si el discriminante no es negativo: $(I dot(psi))^2 >= 4 (I' - I) cos theta
thin W c$, o sea $dot(psi) >= sqrt(4 (I' - I) cos theta thin W c) \/ I = 88,6$ rad/s.

*6. Opine.* Con menos de 88,6 rad/s no hay precesión estable a 60°: el trompo cabecea (nutación) cada vez más y se
cae. Con $theta = 90 degree$, $cos theta = 0$: el término cuadrático desaparece y queda una sola raíz, exacta,
$dot(phi) = W c \/ (I dot(psi))$ (la del giróscopo de laboratorio, 6,54 rad/s con este spin).

== Resolución del Ejercicio 4 — en palabras

*1. Los ángulos de Euler del satélite.* Se mide respecto de una terna fija con su tercer eje sobre $bold(H)_G$ (que
no se mueve). $theta$: el ángulo entre la dirección de $bold(H)_G$ y el eje de simetría del satélite. $phi$: cuánto
giró, alrededor de $bold(H)_G$, el plano que contiene a $bold(H)_G$ y al eje (la precesión). $psi$: cuánto giró el
satélite alrededor de su propio eje respecto de ese plano (el spin). Sin cupla, $theta$ queda fijo (33,7°) y $phi$ y
$psi$ crecen a ritmo constante.
// simbolos: phi, psi

*2. El Explorer 1.* Sin cupla, $bold(H)_G$ se conserva; la energía de rotación, con $bold(H)_G$ fijo, es $T = H^2 \/
(2 I_"eje")$ cuando gira sobre un eje principal. Las antenas flexibles disipan energía en cada vaivén, y la energía
baja con $bold(H)_G$ constante: el satélite busca el eje donde $T$ es mínima, el de *mayor* momento de inercia.
Lanzado a girar sobre su eje largo (el de *menor* $I$), terminó girando de punta, alrededor de un eje transversal. La
regla del eje mayor: sólo es estable, con disipación, el eje de máximo momento de inercia.
// simbolos: T, H, I_eje

#figure(fig-explorer)

*3. Giróscopo y órbita.* En la órbita circular la fuerza es perpendicular a la velocidad: cambia su *dirección* y no
su módulo, y el satélite «cae» todo el tiempo sin acercarse. En el giróscopo, el torque es perpendicular a $bold(L)$:
$Delta bold(L) = bold(tau) Delta t$ cambia la *dirección* de $bold(L)$ y no su módulo, y el eje gira de costado
(precesa) en vez de caer. Es la analogía de la cátedra: $bold(p) arrow.r bold(L)$, $bold(F) arrow.r bold(tau)$; la
precesión es el movimiento circular uniforme de la rotación.
// simbolos: tau, Delta, F

*4.* La (iii). $bold(H)_G$ es lo que se conserva; $bold(omega)$ se mueve alrededor de él (sobre el cono espacial)
salvo que gire sobre un eje principal. La (i) y la (ii) confunden qué es fijo y respecto de qué; la (iv) es al revés:
fuera de un eje principal, sin cupla, el cuerpo *precesa*; hace falta cupla para que *no* lo haga (Ejercicio 2).

== Resolución del extra — el CMG que reorienta

*a)* Al arrancar, el cardán gira $bold(h)$ alrededor de $z$: $dif bold(h) \/ dif t = dot(delta) hat(k) times h hat(i)
= h dot(delta) hat(j)$, y el satélite recibe la reacción, $-h dot(delta) hat(j) = -6,0 hat(j)$ N·m. Empieza a girar
alrededor de $-y$ con $alpha = 6,0 \/ 500 = 0,012$ rad/s².
// simbolos: alpha

*b)* Sin integrar: el sistema satélite + CMG no recibe cupla de afuera, y arrancó con $bold(h) = 20 hat(i)$ N·m·s. Lo
que cambia $bold(h)$ se lo lleva el satélite con signo contrario. Con $delta = 30 degree$,
$Delta bold(h) = h (cos delta - 1; sin delta; 0) = (-2,68; 10,0; 0)$ N·m·s, y el satélite queda con $-Delta bold(h)$:
$ omega_y = -(h sin delta) / I_s = -0,0200 " rad/s", quad omega_x = (h (1 - cos delta)) / I_s = 0,00536 " rad/s". $
La parte sobre $y$ es la maniobra; la de $x$ es una *fuga*: como la cupla gira con el cardán, deja de apuntar sobre
$y$. Se controla sumando la cupla de a pares de CMG que giran al revés (tijera).

#figure(fig-b-cmg, caption: [$bold(h)$ antes y después de girar el cardán 30°: el satélite se lleva $-Delta bold(h)$.])

*c)* La máxima sobre $y$ es con $delta = 90 degree$: $h \/ I_s = 0,040$ rad/s. Ahí $bold(h)$ quedó sobre $y$, la cupla
ya apunta sobre $+x$ y no hay más momento angular para dar sobre $y$: el CMG *saturó*. Para seguir, hay que
descargarlo con una cupla de afuera (propulsores o magnetotorques).

#pagebreak()
= Resultados

#set par(justify: false)
#table(
  columns: (0.5fr, 2.2fr),
  inset: (x: 5pt, y: 4pt),
  table.header(..([Ej.], [Resultado]).map(t => text(size: 9pt, weight: "bold", fill: c-azul)[#t])),
  ..(
    [1a], [$bold(H)_G = (-600; 0; 900)$ kg·m²/s, $abs(bold(H)_G) = 1081,7$ kg·m²/s; $theta = 33,7 degree$],
    [1b], [$bold(omega) = (-1,5625; 0; 1,50)$ rad/s, $abs(bold(omega)) = 2,166$ rad/s; $gamma = 46,2 degree$],
    [1c], [retrógrada ($gamma > theta$, achatado); el cono corporal envuelve al espacial],
    [1d], [$dot(phi) = 2,817$ rad/s; $dot(psi) = -0,844$ rad/s],
    [1e], [$Delta v_G = 1,0$ m/s sobre $-z$; la energía no se conserva (queda el 0,128 % de la del meteorito)],
    [1f], [pegando en el centro de la tapa, sobre el eje],
    [2], [$omega = 125,7$ rad/s; $bold(H)_G$ a 2,50° de $bold(omega)$; $dif bold(H)_G \/ dif t = 14,8$ N·m; $F = 37,0$ N por cojinete, contra 29,4 N de peso],
    [3], [$W c = 0,1177$ N·m; $dot(phi) = 7,24$ o $67,8$ rad/s (aproximada: 6,54); spin mínimo 88,6 rad/s],
    [4], [ángulos respecto de $bold(H)_G$; Explorer 1: eje de máximo $I$; misma idea: cambia la dirección, no el módulo; la (iii)],
    [extra], [cupla 6,0 N·m sobre $-y$; $alpha = 0,012$ rad/s²; $omega_y = -0,0200$ y $omega_x = 0,00536$ rad/s; máximo 0,040 rad/s],
  ).map(c => text(size: 9pt, c)),
)
