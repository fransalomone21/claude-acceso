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

  *Qué esperar* (leído de los cuatro parcialitos anteriores, no dicho por
  él): un tema, preguntas cortas encadenadas, *el dibujo es la respuesta*, y
  casi sin cuentas. Lo anunció «más conceptual». Igual van algunos números
  al final de cada tema, por las dudas.
]

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
)
