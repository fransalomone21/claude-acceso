// =====================================================================
//  Modelo A del 2.o parcial (26/11/2026) -- cuerpo rigido, Beer cap. 18.
//  2026-11-25, pedido de Fran: «2 modelos de 2do parcial sabiendo que no
//  entran CMG, igual mete alguno de CMG como extra; considera todos los
//  modelos que tomo Anibal, parcialito y parcial; resoluciones y resultados
//  abajo, con dibujos vectoriales efectivos».
//  Forma: la del 1er parcial (ANI-41: un numerico del Beer con figura, uno de
//  dibujo 3D con preguntas cortas, uno de «escriba (o deduzca)» con «opine»)
//  mas un cuarto al estilo de sus parcialitos (ANI-R3, R11, R16: palabras,
//  «demuestre», «haga surgir»). El 1 se resuelve con el workflow de ocho pasos
//  (ANI-79, workflow.typ). Cada numero sale de cuentas_2do_parcial.py, por dos
//  caminos, y lo mide validar.py.
// =====================================================================
#import "estilo.typ": *
#import "workflow.typ": W, tipo, oral
#import "figuras-2do-parcial.typ": fig-a1-sonda, fig-a1-suma, fig-a1-libre, fig-a3-polo, fig-a4-rueda
#import "figuras-cr3d.typ": fig-cardanes, fig-precesion-estable, fig-mancuerna
#import "../apunte/biblioteca/figuras-cmg.typ": fig-cmg-3d

#show: documento.with(
  titulo: [Modelo A de 2.º parcial — cuerpo rígido],
  subtitulo: [Un pulso que hace bambolear una sonda, el giróscopo en cardanes, las ecuaciones de Euler con la Tierra, y la rueda y la mancuerna de los parcialitos. Con un extra de CMG],
  encabezado: [Modelo A de 2.º parcial — cuerpo rígido],
)

#caja([Qué entra, y de dónde sale cada ejercicio], c-azul)[
  El 2.º parcial es el *jueves 26/11* (ANI-74). Entra el cuerpo rígido del capítulo 18 del Beer; *el CMG no entra*
  (lo dijo Fran el 25/11), así que va al final como extra, de yapa. La forma copia la del 1.er parcial: un problema
  *numérico del Beer con su figura*, uno de *dibujo 3D con preguntas cortas* y uno de *«escriba (o deduzca)»* que
  termina en números y en un *«opine»*; el cuarto va como sus parcialitos, en palabras.

  // simbolos: G, H_G, omega, phidot, psidot, I
  #set par(justify: false)
  #table(
    columns: (0.35fr, 1.6fr, 1.4fr, 1.1fr),
    inset: (x: 4pt, y: 3pt),
    table.header(..([Ej.], [Qué es], [Forma (cómo pregunta Aníbal)], [Beer / guía]).map(t => text(size: 8pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([1], [Pulso fuera de $G$ sobre una sonda que gira: $bold(H)_G$, $bold(omega)$, conos, $dot(phi)$ y $dot(psi)$], [numérico con figura, con el workflow de ocho pasos], [§18.3, §18.11; P7 y P9 de CR, PR 18.6]),
      ([2], [Giróscopo en cardanes en precesión estable], [dibujo 3D + preguntas; la base no ortonormal (parcialito 5)], [§18.9–18.10, ec. 18.44]),
      ([3], [Ecuaciones de Euler; el polo de la Tierra], [«escriba (o deduzca)» + números + «opine»], [§18.5–18.6, §18.11; Beer 18.117 y 18.123]),
      ([4], [La rueda de la estudiante, la mancuerna torcida, $I$ desde la energía], [parcialitos 3 y 4, en palabras], [§18.1–18.2; Sears §10.7]),
      ([extra], [CMG de un cardán], [de yapa: no entra], [m22 del apunte; Lappas 2002]),
    ).flatten().map(c => text(size: 8pt, c)),
  )
]

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Dos horas y media, con calculadora y la hoja de fórmulas. Toda aproximación se dice y se justifica (ANI-53). Donde
  se pide un dibujo, el dibujo es parte de la respuesta: dirección, sentido y rótulos. *Notación (la del Beer y la de
  Aníbal):* $bold(H)_G$ es el momento angular respecto del centro de masa $G$ (la guía le dice _impulso angular_);
  $bold(omega)$ es la velocidad angular del cuerpo y $bold(Omega)$ la de los ejes; en un cuerpo de revolución, $I$ es
  el momento de inercia *axial* e $I'$ el *transversal*; $theta$ es el ángulo entre $bold(H)_G$ y el eje de simetría,
  y $gamma$ el ángulo entre $bold(omega)$ y ese eje; $dot(phi)$ es la velocidad de precesión y $dot(psi)$ la de spin.
  // simbolos: H_G, G, omega, Omega, I, I', theta, gamma, phidot, psidot
]

= Enunciados

#consigna[
#ejercicio(1, [la sonda y el propulsor que falló], [3])
#origen[Beer §18.3 (impulso en 3D) y §18.11 (cuerpo simétrico sin cupla); el molde es el Problema 7 de CR resuelto por Aníbal y el PR 18.6.]

Una sonda de masa $m = 900$ kg es un cuerpo de revolución alrededor de su eje $z$, con radios de giro respecto de $G$
$k = 0,80$ m (axial) y $k' = 1,20$ m (transversal). Gira alrededor de su eje con $omega_0 = 0,50$ rad/s cuando el
propulsor $A$, en $bold(r)_A = (0; 0,80; 1,50)$ m respecto de $G$, entrega por una falla un pulso de 0,20 s con
impulso $bold(J) = 80 hat(i)$ N·s (paralelo a $+x$, en el instante de la figura).
// simbolos: m, z, k, k', omega_0, A, r_A, J, ihat

#figure(fig-a1-sonda)

#set enum(numbering: "a)")
+ Determine $bold(H)_G$ inmediatamente después del pulso y el ángulo $theta$ que forma con el eje de la sonda.
+ Determine $bold(omega)$ inmediatamente después del pulso y el ángulo $gamma$ que forma con el eje.
+ ¿La precesión que sigue es directa o retrógrada? Justifique y dibuje los dos conos.
+ Calcule las velocidades de precesión $dot(phi)$ y de spin $dot(psi)$.
+ ¿Cuánto cambió la velocidad de $G$? ¿El pulso le dio o le sacó energía cinética a la sonda?
+ *Opine:* ¿dónde o cómo tendría que haberse aplicado un pulso para cambiar sólo la velocidad de giro, sin bamboleo?
]

#consigna[
#ejercicio(2, [el giróscopo en cardanes, dibujado y en precesión estable], [2,5])
#origen[Beer §18.9, figs. 18.15–18.16, y §18.10, ec. 18.44; las hojas 2 a 4 de Aníbal; el parcialito 5.]

El rotor de la figura es simétrico, con $I = 2,0 times 10^(-3)$ kg·m² (axial) e $I' = 1,0 times 10^(-3)$ kg·m²
(transversal), y su centro de masa $O$ queda fijo.
// simbolos: O

#figure(fig-cardanes(rotulos: false, escala: 0.58cm))

#set enum(numbering: "a)")
+ Sobre el dibujo, marque los ángulos de Euler $phi$, $theta$, $psi$ y los ejes $x y z$ pegados al balancín interior
  ($z$ sobre el eje del rotor). Diga en palabras qué pieza gira cada ángulo y alrededor de qué eje.
+ Escriba la velocidad angular $bold(omega)$ del rotor y la $bold(Omega)$ de los ejes en la base
  $(bold(K), hat(j), hat(k))$. ¿Es ortonormal? Escríbalas en $(hat(i), hat(j), hat(k))$.
+ Se lo hace precesar de manera estable con $dot(phi) = 2,0$ rad/s, $theta = 60 degree$ y $dot(psi) = 50$ rad/s.
  Calcule $bold(omega)$ y $bold(H)_O$ en $(hat(i), hat(j), hat(k))$.
+ Calcule el momento $sum bold(M)_O$ que sostiene ese movimiento y dibújelo junto con $bold(H)_O$ y
  $dif bold(H)_O \/ dif t$. ¿Sobre qué eje actúa, y quién lo puede hacer?
+ ¿Por qué conviene usar ejes pegados al balancín interior y no al rotor?
// simbolos: phi, psi, K, jhat, khat, H_O, M_O
]

#consigna[
#ejercicio(3, [las ecuaciones de Euler, y el polo de la Tierra que da vueltas], [2,5])
#origen[Beer §18.5–18.6 (ec. 18.25) y §18.11; los problemas de la Tierra que mandó Aníbal: 18.117 y 18.123, «analizar las diferencias».]

+ Escriba (o deduzca) la relación entre $sum bold(M)_G$ y la derivada de $bold(H)_G$ vista desde unos ejes que giran
  con $bold(Omega)$. Con ejes principales clavados al cuerpo, escriba las tres ecuaciones de Euler.
+ Para un cuerpo de revolución ($I_x = I_y = I'$, $I_z = I$) libre de cuplas, demuestre que $omega_z$ es constante
  y que $(omega_x; omega_y)$, visto desde el cuerpo, gira con velocidad angular $lambda = (I - I') omega_z \/ I'$.
  ¿Para qué lado gira si el cuerpo es achatado?
+ Dibuje $bold(omega)_perp = (omega_x; omega_y)$ en el plano $x y$ del cuerpo, con su sentido de giro.
+ Tome la Tierra como rígida, con $(I - I') \/ I' = 1\/305$ y $omega_z = 2 pi \/ (86 thin 164 thin "s")$ (un día
  sideral). ¿Cada cuánto da una vuelta el polo de rotación alrededor del polo de figura, visto desde la Tierra?
+ *Opine:* el bamboleo libre del polo que se mide (el de Chandler) tarda unos 433 días. ¿Qué supuesto del modelo
  falla? ¿Es lo mismo que la precesión de los equinoccios? Analice las diferencias.
// simbolos: M_G, I_x, I_y, I_z, omega_x, omega_y, omega_z, lambda, omega_perp, pi
]

#consigna[
#ejercicio(4, [la rueda, la mancuerna y el momento de inercia, en palabras], [2])
#origen[Parcialito 3 (la estudiante con la rueda) y parcialito 4 (las dos masas en la barra, «haga surgir»); Sears §10.7 y §9.4; Beer §18.1–18.2.]

Conteste con palabras y con las fórmulas mínimas, sin cuentas.

+ Una estudiante sostiene por el eje, horizontal, una rueda de bicicleta que gira rápido; su momento angular
  $bold(L)$ apunta hacia la derecha de ella. El profesor le pide que levante el extremo derecho del eje en un plano
  vertical. ¿Qué tendencia registra en sus manos? Justifique con $Delta bold(L) = bold(tau) Delta t$ y un gráfico
  vectorial.
+ Dos masas puntuales iguales $m$, unidas por una barra de largo $ell$ y masa despreciable, son solidarias a un eje
  con el que la barra forma un ángulo $beta$ ($0 < beta < 90 degree$); el sistema gira con $bold(omega)$ paralela al
  eje. Demuestre que $bold(H)_G$ no es cero ni paralelo a $bold(omega)$. ¿Qué forma describe la barra al girar? ¿Y
  $bold(H)_G$? ¿Hace falta un momento externo para mantener el giro?
+ Escriba la energía cinética de un rígido que gira alrededor de un eje fijo y haga surgir de ahí el momento de
  inercia. ¿Depende del eje elegido? ¿De la velocidad angular?
// simbolos: L, tau, Delta, ell, beta
]

#consigna[
#ejercicio([extra], [de yapa (el CMG no entra): un CMG de un cardán], [1])
#origen[Módulo 22 del apunte, «El CMG por dentro»; Lappas, Steyn y Underwood (2002); la guía del parcialito de CMG.]

Un CMG tiene un rotor con $I_r = 0,010$ kg·m² que gira a 6000 rpm, y el cardán lo hace girar con
$dot(delta) = 1,0$ rad/s alrededor de un eje perpendicular al del rotor.
// simbolos: I_r, deltadot

#set enum(numbering: "a)")
+ ¿Cuánto vale el momento angular $h$ del rotor?
+ ¿Qué torque recibe el satélite (módulo y dirección)? Dibuje $bold(h)$, el eje del cardán y la cupla.
+ Una rueda de reacción con el mismo rotor, ¿qué aceleración angular necesitaría para dar ese torque? ¿Por qué se dice
  que el CMG *amplifica* el torque?
+ Si el satélite tiene $I_s = 400$ kg·m² alrededor del eje de la cupla, ¿qué aceleración angular toma?
+ ¿Por qué esa cupla no se puede sostener indefinidamente en la misma dirección?
// simbolos: h, I_s
]

#pagebreak()
= Resoluciones

== Resolución del Ejercicio 1 — la sonda y el propulsor que falló

#tipo([B])[Un impulso fuera de $G$ sobre un cuerpo que ya gira: el $bold(H)_G$ de después es el de antes más
$bold(r) times bold(J)$, y de ahí en adelante, libre de cuplas, el cuerpo precesa alrededor de ese $bold(H)_G$ fijo.
Cargan el peso los pasos W4 (la suma de momentos angulares) y W6 (los ángulos y la ley de los senos).]
// simbolos: r

#W(1)
Datos: $m = 900$ kg; $I = m k^2 = 900 dot.op 0,80^2 = 576$ kg·m² (axial) e $I' = m k'^2 = 900 dot.op 1,20^2 =
1296$ kg·m² (transversal): $I < I'$, la sonda es *alargada*. Antes del pulso gira sólo alrededor de su eje, así que
$bold(H)_0 = I omega_0 hat(k) = 576 dot.op 0,50 hat(k) = 288 hat(k)$ kg·m²/s. Se pide $bold(H)_G$, $theta$,
$bold(omega)$, $gamma$, el tipo de precesión, $dot(phi)$, $dot(psi)$, el cambio de velocidad de $G$ y la energía.
// simbolos: H_0

#W(2)
Ejes $G x y z$ con origen en el centro de masa, pegados a la sonda en el instante del pulso: $z$ sobre el eje de
revolución y $x$, $y$ como en la figura. Son *principales* por simetría (cualquier par perpendicular al eje lo es en un
cuerpo de revolución), así que $bold(H)_G = (I' omega_x; I' omega_y; I omega_z)$ sin productos de inercia.

#W(3)
Durante el pulso actúa sólo $bold(J)$, y es *impulsivo*: dura 0,20 s contra un período de giro de
$2 pi \/ omega_0 = 12,6$ s, así que la sonda gira $0,10$ rad (5,7°) mientras empuja y se toma como instantáneo
(supuesto dicho, ANI-53). Después no actúa nada: $bold(H)_G$ se conserva en módulo y dirección, y la cantidad de
movimiento también. El momento angular respecto de $G$ y el movimiento de $G$ se separan.

#W(4)
Me pregunto qué le agrega el pulso al momento angular respecto de $G$: es el momento del impulso, $bold(r)_A times
bold(J)$, que tiene la misma forma que $bold(r) times bold(F)$ pero con $bold(J) = integral bold(F) dif t$. Lo
escribo componente por componente en los ejes de la sonda, donde están dados los dos vectores:
$ bold(r)_A times bold(J) = (y_A J_z - z_A J_y; thin z_A J_x - x_A J_z; thin x_A J_y - y_A J_x)
  = (0; thin 1,50 dot.op 80; thin -0,80 dot.op 80) = (0; 120; -64) " kg·m²/s". $
// simbolos: x_A, y_A, z_A, J_x, J_y, J_z, F
El pulso le agrega una parte sobre $y$ (eso inclina $bold(H)_G$) y le *saca* sobre $z$ (frena el spin: empuja en
contra de como se movía $A$). Sumo:
$ bold(H)_G = bold(H)_0 + bold(r)_A times bold(J) = (0; 120; 224) " kg·m²/s", quad
  abs(bold(H)_G) = sqrt(120^2 + 224^2) = 254,1 " kg·m²/s". $
El ángulo con el eje sale de las dos componentes: $tan theta = H_y \/ H_z = 120 \/ 224 = 0,536$, así que
$theta = 28,2 degree$.
// simbolos: H_y, H_z

#figure(fig-a1-suma, caption: [La suma de los momentos angulares, a escala, en el plano $y z$ de la sonda.
  $bold(omega)$ no va sobre $bold(H)_G$: queda entre él y el eje.])

#W(5)
La ecuación que manda es $bold(H)_G = bold(I) bold(omega)$ en ejes principales, componente por componente: cada
componente de $bold(H)_G$ dividida por *su* momento de inercia.
$ omega_x = H_x / I' = 0, quad omega_y = 120 / 1296 = 0,0926 " rad/s", quad omega_z = 224 / 576 = 0,389 " rad/s". $
// simbolos: H_x
$omega_x = 0$ ¿por qué? Porque $H_x = 0$ y los ejes son principales: no hay producto de inercia que mezcle
componentes. Entonces $bold(omega) = (0; 0,0926; 0,389)$ rad/s, con $abs(bold(omega)) = 0,400$ rad/s, y
$tan gamma = omega_y \/ omega_z = 0,238$: $gamma = 13,4 degree$.

#W(6)
$theta = 28,2 degree > gamma = 13,4 degree$: $bold(omega)$ queda *entre* el eje y $bold(H)_G$, y eso es precesión
*directa* (sonda alargada, $I < I'$; Beer pág. 1191). Los conos: el *espacial* tiene su eje sobre $bold(H)_G$ y
semiángulo $theta - gamma = 14,8 degree$ (lo barre $bold(omega)$ en el espacio); el *corporal* tiene su eje sobre el
eje de la sonda y semiángulo $gamma = 13,4 degree$; el corporal rueda *por afuera* del espacial, apoyados sobre la
línea de $bold(omega)$.

#figure(fig-a1-libre, caption: [Lo que sigue al pulso (esquema, ángulos exagerados): $bold(H)_G$ fijo, el eje
barre un cono alrededor de él y $bold(omega)$ queda entre los dos.])

La velocidad angular se arma como $bold(omega) = dot(phi) bold(K) + dot(psi) hat(k)$, con $bold(K)$ el versor de
$bold(H)_G$: un triángulo con lados $dot(phi)$, $dot(psi)$ y $omega$ y ángulos $gamma$ (frente a $dot(phi)$),
$theta - gamma$ (frente a $dot(psi)$) y el suplemento de $theta$ (frente a $omega$). Ley de los senos:
$ dot(phi) = omega (sin gamma) / (sin theta) = 0,400 dot.op (sin 13,4 degree) / (sin 28,2 degree)
  = 0,196 " rad/s", quad
  dot(psi) = omega (sin(theta - gamma)) / (sin theta) = 0,216 " rad/s". $
El eje da una vuelta alrededor de $bold(H)_G$ cada $2 pi \/ dot(phi) = 32,0$ s.

#W(7)
Otro camino, sin el triángulo: $dot(phi) = H_G \/ I' = 254,1 \/ 1296 = 0,196$ rad/s, y
$dot(psi) = (I' - I) \/ (I I') thin H_G cos theta = 720 \/ (576 dot.op 1296) dot.op 224 = 0,216$ rad/s. Y
$tan gamma = (I \/ I') tan theta = 0,444 dot.op 0,536 = 0,238$, el mismo $gamma$. Coinciden.

*El inciso e).* La cantidad de movimiento: $m Delta bold(v)_G = bold(J)$, así que $Delta bold(v)_G = 80 \/ 900 =
0,0889$ m/s sobre $+x$. La energía cinética antes: $T_0 = 1/2 I omega_0^2 = 72,0$ J. Después:
$1/2 (I' omega_y^2 + I omega_z^2) = 49,1$ J de rotación más $1/2 m Delta v_G^2 = 3,56$ J de traslación, en total
52,7 J: *perdió* 19,3 J. ¿Cómo puede un empujón sacar energía? Porque $A$ se movía en contra: antes del pulso
$bold(v)_A = bold(omega)_0 times bold(r)_A = -0,40 hat(i)$ m/s, y el pulso empuja hacia $+x$. Lo verifico por el
trabajo: $W = bold(J) dot.op (bold(v)_A^"antes" + bold(v)_A^"después") \/ 2 = 80 dot.op (-0,400 - 0,0833) \/ 2 =
-19,3$ J, con $bold(v)_A^"después" = Delta bold(v)_G + bold(omega) times bold(r)_A = -0,0833 hat(i)$ m/s. Coincide.
// simbolos: v_G, T_0, v_A, W

#W(8)
Conclusiones: después del pulso $bold(H)_G = (0; 120; 224)$ kg·m²/s queda fijo en el espacio; el eje de la sonda
precesa alrededor de él con $theta = 28,2 degree$ y $dot(phi) = 0,196$ rad/s (una vuelta cada 32 s), mientras la
sonda gira sobre sí misma con $dot(psi) = 0,216$ rad/s: precesión directa. El centro de masa se va a 8,9 cm/s y la
sonda perdió 19,3 J.

*Opine.* Para cambiar sólo el giro, $bold(r) times bold(J)$ tiene que salir *paralelo al eje*: $bold(J)$
perpendicular al eje y aplicado en el plano de $G$ ($z_A = 0$). Mejor todavía, *dos* propulsores tangenciales
opuestos, en puntos opuestos del borde: la suma de impulsos es cero (el centro de masa no se mueve) y la suma de
momentos queda sobre $z$. Es una cupla pura alrededor del eje: cambia $omega_0$ y no aparece bamboleo.

#oral(
  ([¿Por qué $bold(H)_G$ queda fijo si la sonda se bambolea?], [Porque después del pulso no hay momento externo: lo que se mueve es el cuerpo alrededor de $bold(H)_G$, no $bold(H)_G$.]),
  ([¿Y si la sonda fuera achatada, con los mismos números de $bold(H)_G$?], [$gamma > theta$: $bold(omega)$ del otro lado de $bold(H)_G$, retrógrada, y el cono corporal envuelve al espacial.]),
  ([¿La masa de la sonda aparece en $theta$?], [Sólo a través de $I$; $theta$ depende de $bold(H)_0$ y del momento del impulso, no de $m$ suelta.]),
)

== Resolución del Ejercicio 2 — el giróscopo en cardanes

*a) Los ángulos, en palabras.* $phi$: el balancín *exterior* gira respecto de la base alrededor del eje fijo vertical
$A A'$ ($bold(K)$): es la precesión. $theta$: el balancín *interior* gira respecto del exterior alrededor del eje
$B B'$ (la línea de nodos, $hat(j)$): es la nutación, y $theta$ es el ángulo entre $bold(K)$ y el eje del rotor. $psi$:
el *rotor* gira respecto del balancín interior alrededor de su eje $C C'$ ($hat(k)$): es el spin. Los ejes $x y z$:
origen en $O$, $z$ sobre $C C'$, $y$ sobre $B B'$, y $x = hat(j) times hat(k)$, en el plano del balancín interior.
Se mueven con el balancín interior, no con el rotor.
// simbolos: A', B, B', C, C'

#figure(fig-cardanes(rotulos: true, escala: 0.6cm), caption: [Los tres ángulos y los ejes del balancín interior
  (Beer fig. 18.15, la que usó Aníbal en el parcialito 5).])

*b) Las dos velocidades angulares.* El rotor acumula los tres giros; los ejes, sólo los dos de los balancines:
$ bold(omega) = dot(phi) bold(K) + dot(theta) hat(j) + dot(psi) hat(k), quad
  bold(Omega) = dot(phi) bold(K) + dot(theta) hat(j). $
// simbolos: thetadot
La base $(bold(K), hat(j), hat(k))$ *no* es ortonormal: $bold(K)$ y $hat(k)$ forman el ángulo $theta$, no 90°. Para
pasarla, proyecto $bold(K)$ sobre los ejes del balancín: queda en el plano $x z$, a $theta$ de $z$ y del lado de $-x$,
$bold(K) = -sin theta thin hat(i) + cos theta thin hat(k)$. Entonces
$ bold(omega) = -dot(phi) sin theta thin hat(i) + dot(theta) hat(j) + (dot(psi) + dot(phi) cos theta) hat(k), quad
  bold(Omega) = -dot(phi) sin theta thin hat(i) + dot(theta) hat(j) + dot(phi) cos theta thin hat(k). $
La diferencia es justo el spin: «no siempre $bold(Omega) = bold(omega)$».

*c) Con números* ($dot(theta) = 0$ porque $theta$ queda fijo): $omega_x = -2,0 sin 60 degree = -1,732$ rad/s,
$omega_y = 0$, $omega_z = 50 + 2,0 cos 60 degree = 51,0$ rad/s. El momento angular, cada componente con su momento de
inercia: $bold(H)_O = (I' omega_x; I' omega_y; I omega_z) = (-1,73 times 10^(-3); 0; 0,102)$ kg·m²/s. Casi todo
sobre el eje del rotor: el spin manda.

*d) El momento que lo sostiene.* $sum bold(M)_O = (dif bold(H)_O \/ dif t)_(O x y z) + bold(Omega) times
bold(H)_O$. En precesión estable las componentes de $bold(H)_O$ en estos ejes no cambian, así que la primera parte es
cero y queda $bold(Omega) times bold(H)_O$, con $bold(Omega) = (-1,732; 0; 1,0)$ rad/s:
$ sum bold(M)_O = (Omega_z H_x - Omega_x H_z) hat(j) = (1,0 dot.op (-1,73 times 10^(-3)) + 1,732 dot.op 0,102) hat(j)
  = 0,175 hat(j) " N·m". $
// simbolos: Omega_x, Omega_z, H_x, H_z
Control con la ec. 18.44 del Beer: $(I omega_z - I' dot(phi) cos theta) dot(phi) sin theta = (0,102 - 0,0010)
dot.op 1,732 = 0,175$ N·m. Coincide. Va sobre $hat(j)$, la línea de nodos $B B'$: perpendicular al plano de $bold(K)$
y del eje. $dif bold(H)_O \/ dif t$ es ese mismo vector: la punta de $bold(H)_O$ se corre de costado, sobre $hat(j)$,
y $bold(H)_O$ barre un cono alrededor de $bold(K)$ (la mano derecha: «el spin persigue al torque»). ¿Quién lo hace?
$B B'$ es un cojinete libre: no puede hacer momento sobre su propio eje. Lo tiene que poner algo de afuera: un peso
colgado del balancín interior fuera de $O$, un resorte o un motor sobre $B B'$. Es el papel del peso en el trompo.

#figure(fig-precesion-estable, caption: [a) $bold(omega)$ como suma de la precesión y el spin; b) con
  $theta = 90 degree$, giro, par y precesión forman una terna derecha.])

*e)* Con ejes clavados al rotor, $bold(Omega) = bold(omega)$ y todo giraría con el spin de 50 rad/s: las componentes de
$bold(H)_O$ oscilarían aunque el movimiento sea estable. Pegados al balancín interior, y como el rotor es simétrico,
los momentos de inercia siguen constantes y las componentes también: la cuenta sale con una sola resta.

== Resolución del Ejercicio 3 — Euler y el polo de la Tierra

*1. La derivada en ejes que giran.* Lo que manda es Newton para la rotación, $sum bold(M)_G = (dif bold(H)_G \/
dif t)$ vista desde un sistema que no gira. Si anoto $bold(H)_G$ en ejes que giran con $bold(Omega)$, su derivada
tiene dos partes: lo que cambian las componentes (lo que ve el que viaja en los ejes) y lo que arrastra el giro de los
ejes. Por el teorema del transporte:
$ sum bold(M)_G = ((dif bold(H)_G) / (dif t))_(G x y z) + bold(Omega) times bold(H)_G. $
Con ejes principales *clavados al cuerpo* ($bold(Omega) = bold(omega)$), $bold(H)_G = (I_x omega_x; I_y omega_y; I_z
omega_z)$ y salen las ecuaciones de Euler (Beer ec. 18.25):
$ sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z, quad
  sum M_y = I_y dot(omega)_y - (I_z - I_x) omega_z omega_x, quad
  sum M_z = I_z dot(omega)_z - (I_x - I_y) omega_x omega_y. $
// simbolos: M_x, M_y, M_z, omegadot_x, omegadot_y, omegadot_z

*2. Sin cupla y de revolución.* La tercera: $I dot(omega)_z = (I' - I') omega_x omega_y = 0$, así que $omega_z$ es
constante. Las otras dos, con $lambda = (I - I') omega_z \/ I'$:
$ dot(omega)_x = (I' - I) / I' omega_z omega_y = -lambda omega_y, quad
  dot(omega)_y = (I - I') / I' omega_z omega_x = lambda omega_x. $
Derivo otra vez la primera y uso la segunda: $dot.double(omega)_x = -lambda^2 omega_x$, un oscilador. La solución es
$omega_x = A cos lambda t$, $omega_y = A sin lambda t$: $bold(omega)_perp$ tiene módulo constante $A$ y da vueltas con
velocidad angular $lambda$. Si el cuerpo es achatado ($I > I'$), $lambda > 0$ y gira para el mismo lado que el
cuerpo; si es alargado, para el otro.
// simbolos: omegaddot_x, A, t

#figure(fig-a3-polo, caption: [$bold(omega)_perp$ visto desde el cuerpo: su punta recorre un círculo con velocidad
  angular $lambda$.])

*4. La Tierra.* $lambda = omega_z \/ 305$, así que el período es $2 pi \/ lambda = 305 dot.op 86 thin 164 thin "s" = 2,628
times 10^7$ s, es decir *304 días*: el polo de rotación da una vuelta alrededor del polo de figura cada 304 días,
visto desde la Tierra (el período de Euler).

*5. Opine.* Lo medido (433 días) es un 42 % más largo. Falla el supuesto de *rígida*: el manto es elástico y los
océanos se acomodan al eje de rotación, y eso achica la diferencia efectiva $I - I'$, baja $lambda$ y alarga el
período. *No* es la precesión de los equinoccios: esa es *forzada* (la cupla del Sol y la Luna sobre el abultamiento
ecuatorial, Beer 18.117), mueve el eje *en el espacio* alrededor del polo de la eclíptica y tarda unos 26 000 años; la
de Chandler es *libre* (sin cupla, $bold(H)_G$ quieto, Beer 18.123), mueve el eje *respecto del cuerpo* unos metros
en el polo y tarda poco más de un año. Mismo nombre de familia, otra física.

== Resolución del Ejercicio 4 — en palabras

*1. La rueda.* $bold(L)$ apunta a la derecha de ella ($+x$; adelante es $+y$ y arriba $+z$). Subir el extremo
derecho es girar el eje alrededor de $-y$, y para eso ella hace un torque $bold(tau)$ sobre $-y$, *hacia ella*. Pero
$Delta bold(L) = bold(tau) Delta t$ va *sobre $-y$*: $bold(L)$ no sube, gira en el plano horizontal y el extremo
derecho del eje se le viene encima (el izquierdo se aleja). Siente que la rueda se le escapa de costado. Para que
suba, tendría que empujar el extremo derecho *hacia adelante*: $hat(i) times hat(j) = hat(k)$, un torque hacia
arriba. El spin persigue al torque.

#figure(fig-a4-rueda, caption: [Lo que ella intenta (subir) y lo que pasa: $Delta bold(L)$ va hacia ella.])

*2. La mancuerna torcida.* Cada masa está en $bold(r) = plus.minus (ell \/ 2) hat(b)$ ($hat(b)$ sobre la barra) y
aporta $bold(r) times m (bold(omega) times bold(r)) = m [r^2 bold(omega) - bold(r)(bold(r) dot.op bold(omega))]$.
Sumando las dos:
$ bold(H)_G = (m ell^2) / 2 thin [bold(omega) - hat(b) (hat(b) dot.op bold(omega))]. $
// simbolos: bhat, r
Su componente sobre la barra es $(m ell^2 \/ 2) (omega cos beta - omega cos beta) = 0$: $bold(H)_G$ es
*perpendicular a la barra*, en el plano de la barra y el eje, con módulo $(m ell^2 \/ 2) omega sin beta$. No es cero
(salvo $beta = 0$) ni paralelo a $bold(omega)$ (salvo $beta = 90 degree$). La barra barre un *cono doble* alrededor
del eje, y $bold(H)_G$ un cono de semiángulo $90 degree - beta$, que gira con el sistema. Como $bold(H)_G$ cambia de
dirección, $dif bold(H)_G \/ dif t = bold(omega) times bold(H)_G != 0$: hace falta un momento externo, el de los
cojinetes, que gira con el eje. Es el desbalance dinámico de una rueda mal balanceada.

#figure(fig-mancuerna, caption: [La mancuerna torcida: $bold(H)_G$ perpendicular a la barra, no sobre $bold(omega)$.])

*3. El momento de inercia, desde la energía.* Cada partícula del rígido gira en un círculo de radio $r_i$ (su distancia
al eje) con la misma $omega$, así que $v_i = omega r_i$ y
$ T = sum 1/2 m_i v_i^2 = 1/2 (sum m_i r_i^2) omega^2 = 1/2 I omega^2. $
// simbolos: m_i, v_i, r_i, T
$I = sum m_i r_i^2$ aparece solo, como el coeficiente que acompaña a $omega^2$: es la «masa» de la rotación. Depende
del eje (las distancias $r_i$ se miden a ese eje; Steiner pasa de un eje por $G$ a uno paralelo) y de cómo está
repartida la masa; *no* depende de $omega$ ni del tiempo, porque el cuerpo es rígido.

== Resolución del extra — el CMG

*a)* $h = I_r Omega_r = 0,010 dot.op 6000 dot.op 2 pi \/ 60 = 6,28$ N·m·s, sobre el eje del rotor.
// simbolos: Omega_r

*b)* El cardán gira $bold(h)$ con $dot(bold(delta))$: sobre el rotor actúa $dif bold(h) \/ dif t = dot(bold(delta))
times bold(h)$, y el satélite recibe la reacción, $-dot(bold(delta)) times bold(h)$, de módulo $h dot(delta) = 6,28$
N·m, perpendicular al eje del rotor y al del cardán.

#figure(fig-cmg-3d, caption: [El CMG por dentro (módulo 22 del apunte): $bold(h)$ sobre el rotor, el cardán y la
  cupla que recibe el satélite.])

*c)* Una rueda de reacción da torque *cambiando el módulo* de $h$: necesitaría $alpha = tau \/ I_r = 6,28 \/ 0,010 =
628$ rad/s², pasar de 0 a 6000 rpm en un segundo, con un motor que haga 6,28 N·m. El CMG cambia sólo la *dirección*
de un $h$ grande con un motor de cardán chico (que mueve el cardán a 1 rad/s): sale mucho más torque del que entra.
Eso es la amplificación.
// simbolos: alpha

*d)* $alpha_s = 6,28 \/ 400 = 0,0157$ rad/s².
// simbolos: alpha_s

*e)* La cupla va sobre $hat(delta) times hat(h)$, que gira con el cardán: a medida que $delta$ crece, cambia de
dirección. Cuando $bold(h)$ quedó alineado con la cupla que se quería, ya no queda momento angular para dar en esa
dirección: saturación (y, con varios CMG, las singularidades).
// simbolos: delta, deltahat, hhat

#pagebreak()
= Resultados

#set par(justify: false)
#table(
  columns: (0.5fr, 2.2fr),
  inset: (x: 5pt, y: 4pt),
  table.header(..([Ej.], [Resultado]).map(t => text(size: 9pt, weight: "bold", fill: c-azul)[#t])),
  ..(
    [1a], [$bold(H)_G = (0; 120; 224)$ kg·m²/s, $abs(bold(H)_G) = 254,1$ kg·m²/s; $theta = 28,2 degree$],
    [1b], [$bold(omega) = (0; 0,0926; 0,389)$ rad/s, $abs(bold(omega)) = 0,400$ rad/s; $gamma = 13,4 degree$],
    [1c], [directa ($theta > gamma$, alargada); el cono corporal rueda por afuera del espacial],
    [1d], [$dot(phi) = 0,196$ rad/s (una vuelta cada 32,0 s); $dot(psi) = 0,216$ rad/s],
    [1e], [$Delta v_G = 0,0889$ m/s sobre $+x$; perdió 19,3 J (de 72,0 J a 52,7 J)],
    [1f], [cupla pura alrededor del eje: dos propulsores tangenciales opuestos],
    [2c], [$bold(omega) = (-1,732; 0; 51,0)$ rad/s; $bold(H)_O = (-1,73 times 10^(-3); 0; 0,102)$ kg·m²/s],
    [2d], [$sum bold(M)_O = 0,175 hat(j)$ N·m, sobre la línea de nodos; lo pone algo externo sobre $B B'$],
    [3], [$omega_z$ constante; $bold(omega)_perp$ gira con $lambda = (I - I') omega_z \/ I'$; Tierra: 304 días (medido 433: no es rígida)],
    [4], [el eje gira hacia ella, no sube; $bold(H)_G perp$ barra, cono; $T = 1/2 I omega^2$],
    [extra], [$h = 6,28$ N·m·s; cupla 6,28 N·m; rueda: 628 rad/s²; satélite: 0,0157 rad/s²],
  ).map(c => text(size: 9pt, c)),
)
