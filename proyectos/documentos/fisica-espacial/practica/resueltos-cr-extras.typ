// =====================================================================
//  resueltos-cr-extras.typ -- los ejercicios de cuerpo rigido que vimos y
//  que NO estan en la guia de la catedra (E1 a E6). Lo incluye
//  resueltos-cr.typ al final, con el mismo molde de ocho pasos de
//  workflow.typ. Cada numero tiene su cuenta por dos caminos en
//  cuentas_extras.py, que exporta CONTROLES para validar.py.
//  Fuentes: Beer cap. 18 (PR 18.6, 18.117, 18.123, 18.127), el cuaderno
//  de Anibal del 18.127, sus dos .docx del 15/11 (GEO y coning), Martz
//  (NASA TN D-8452), Curtis §12.7 y el apunte de clase del CMG (nov. 2026).
// =====================================================================
#import "workflow.typ": *
#import "../apunte/biblioteca/figuras-euler.typ": fig-ley-senos
#import "../apunte/biblioteca/figuras.typ": fig-act-cmg-singular

#pagebreak(weak: true)

// Los seis van seguidos, sin salto de página entre uno y otro: con salto, la
// caja del oral que desborda dos renglones dejaba una página casi en blanco.
// El título de cada uno queda pegado a su enunciado (nunca solo al pie).
#show heading.where(level: 1): it => block(sticky: true, above: 18pt, below: 10pt, it)

#caja([Los que no están en la guía], c-viole)[
  Seis ejercicios de cuerpo rígido que se vieron en la materia y que la guía
  no trae: los mandó Aníbal en clase, los resolvió él en un cuaderno o los
  subió al Classroom el 15/11. Van con el mismo workflow de ocho pasos que los
  de la guía, porque la gracia es justamente esa: que el molde sirva para
  cualquier problema, incluso para uno que nunca viste.

  #mapa(
    ([E1], [El meteorito sobre el satélite de dos discos: el modelo de todos], [Beer, Problema Resuelto 18.6 (pág. 1192) · Aníbal: «hacer este problema es aprender a hacer el resto»]),
    ([E2], [El satélite geoestacionario y el meteorito en el punto B: el achatado],[Beer 18.127 (pág. 1198) · el cuaderno NumPy de Aníbal]),
    ([E3], [La Tierra: precesión de los equinoccios contra precesión libre], [Beer 18.117 y 18.123 (págs. 1196 y 1197) · «analizar las diferencias»]),
    ([E4], [El satélite GEO con el eje de spin apuntando a la Tierra], [Meriam (en el .docx de Aníbal del 15/11) · Beer §18.10]),
    ([E5], [Coning impulsivo: dos golpes y precesión libre en el medio], [Martz, NASA TN D-8452 (1977) · Curtis §12.7 · el .docx de Aníbal]),
    ([E6], [El CMG con números: salida, amplificación, saturación y desaturación], [Apunte de clase «El CMG como actuador de actitud» (nov. 2026) · la animación de la desaturación]),
  )
]

// simbolos: H_G, I, I', theta, gamma, phidot, psidot, omega
#notacion[
  La del Beer y la de Aníbal, igual que en el resto del documento: $bold(H)_G$
  es el *momento angular* respecto del centro de masa (la guía le dice
  «impulso angular»; acá el impulso angular es la integral del torque, lo que
  le cambia a $bold(H)_G$); $I$ es el momento de inercia *axial* (sobre el eje
  de simetría) e $I'$ el *transversal*; $theta$ es el ángulo entre
  $bold(H)_G$ y el eje de simetría, $gamma$ el ángulo entre la velocidad
  angular $bold(omega)$ y ese eje; $dot(phi)$ es la velocidad de precesión
  (alrededor de $bold(H)_G$) y $dot(psi)$ la de spin (alrededor del eje del
  cuerpo). Directa si $I < I'$ (alargado), retrógrada si $I > I'$ (achatado):
  Beer §18.11, págs. 1189-1191.
]

// =====================================================================
= E1 — El meteorito y el satélite de dos discos (Beer, PR 18.6)

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Beer, *Problema Resuelto 18.6*, pág. 1192 (la 618 del PDF), transcripto. No está en la guía: Aníbal lo mandó a hacer para el parcialito del cap. 18 con una frase que vale la materia, «hacer este problema es aprender a hacer el resto» (`catedras`, ANI-68). Las respuestas del libro están en el mismo problema.]
  // simbolos: m, a, omega_0, m_0, v_0, C, A, B
  Se sabe que un satélite espacial de masa $m$ es dinámicamente equivalente a
  dos discos delgados de igual masa. Los discos tienen un radio $a = 800$ mm y
  están rígidamente conectados mediante una barra ligera de longitud $2 a$. En
  un principio, el satélite gira con libertad alrededor de su eje de simetría
  a la velocidad $omega_0 = 60$ rpm. Un meteorito, de masa $m_0 = m\/1000$ y
  que viaja con una velocidad $bold(v)_0$ de $2000$ m/s relativa al satélite,
  choca con éste y se incrusta en $C$. Determine *a)* la velocidad angular del
  satélite inmediatamente después del impacto, *b)* el eje de precesión del
  movimiento resultante, *c)* las velocidades de precesión y giro del
  movimiento subsecuente.

  // simbolos: A, B
  _En la figura del libro:_ el eje de simetría es $z$; el disco $A$ arriba y el
  $B$ abajo; el meteorito sube paralelo a $+z$ y pega en $C$, en el borde del
  disco $B$, del lado de $-y$.
]

#gancho[Es el problema que más se repite del capítulo, contado en su versión
más limpia: algo golpea a un satélite que gira, y hay que decir para dónde
queda apuntando el eje alrededor del cual se bambolea, cuánto se abre el cono
y a qué ritmo. Te da tres cosas que un ingeniero de actitud quiere saber
después de un choque, un disparo mal hecho o un panel que se despliega
torcido: el eje nuevo, el ángulo del bamboleo y las dos velocidades. Lo simple
es que, si el golpe es interno, el momento angular no cambia y todo sale de
sumar dos vectores. Lo complicado es el final: precesión y spin no son
perpendiculares, y no se pueden leer como componentes.]

#tipo("A")[
  Un golpe corto (el choque) y después nada: *precesión libre* con el
  momento angular nuevo. Cargan el peso W3 (qué se conserva en el choque), W4
  ($bold(H)_G$ antes y después, componente a componente) y W6 (los ángulos, el
  sentido y la ley de los senos). W5 es corta: sin cupla, $bold(H)_G$ queda
  fijo.
]

#duda[El choque es violento y no sé con qué fuerza pega. ¿Cómo calculo algo
sin conocer esa fuerza?]
#dedos[No hace falta conocerla. Satélite y meteorito son un solo sistema, y
la fuerza del choque es interna: lo que uno recibe, el otro lo pierde. El
momento angular del conjunto respecto del centro de masa, $G$, es el mismo
// simbolos: G
antes y después del golpe. Es como dos patinadores que se agarran de la mano al cruzarse: no sabés
cuánto se tironearon, pero sabés que el giro de los dos juntos es la suma de
lo que traía cada uno.]

#W(1)
// simbolos: m, a, omega_0, m_0, v_0, r_C
Lo que tengo: la masa $m$ del satélite (no hace falta su valor: se va a
simplificar), el radio $a = 0,8$ m de cada disco, el giro inicial $omega_0 = 60$
rpm $= 6,283$ rad/s sobre el eje de simetría, y el meteorito: masa
$m_0 = m\/1000$, velocidad $bold(v)_0 = 2000 hat(k)$ m/s relativa al satélite,
incrustado en $C$, cuya posición desde $G$ es $bold(r)_C = -a hat(j) - a
hat(k)$ (borde del disco de abajo, del lado de $-y$). Lo que piden:
$bold(omega)$ justo después, el eje de precesión, $dot(phi)$ y $dot(psi)$.

#W(2)
// simbolos: G
El origen en $G$, el centro de masa (en el medio de la barra), y los ejes del
libro: $z$ sobre el eje de simetría, $x$ e $y$ en el plano del medio. Son ejes
*principales* por simetría (ANI-51): el tensor es diagonal y voy a poder
dividir componente por componente. Los momentos de inercia los pienso como
dos discos: el axial es el de cada disco sobre su eje, dos veces; el
transversal, cada disco sobre un diámetro más Steiner hasta $G$, a distancia
$a$:
$ I = 2 dot.op 1/2 (m/2) a^2 = 1/2 m a^2, quad I' = 2 [1/4 (m/2) a^2 + (m/2) a^2] = 5/4 m a^2 $
$I < I'$: dinámicamente es *alargado* (dos discos separados por una barra,
como unas pesas). Ya puedo apostar el final: precesión directa.

#W(3)
*Durante el choque* la única fuerza grande es la del impacto, interna al
sistema satélite + meteorito: se conserva el momento angular respecto de $G$.
*Después*, no hay cupla externa (el satélite está libre en el espacio): se
conserva $bold(H)_G$, en módulo y en dirección, para siempre. Supuestos,
dichos (ANI-53): el meteorito es una milésima de la masa, así que no corre $G$
ni cambia los momentos de inercia (el $0,1$ %); y el choque dura tan poco que
el satélite no alcanza a girar mientras tanto.

#W(4)
Antes, el satélite sólo gira sobre su eje: $bold(H)_G = I omega_0 hat(k)$. El
meteorito trae un momento angular respecto de $G$ que es su brazo por su
cantidad de movimiento. Pienso el producto vectorial antes de hacerlo:
$bold(r)_C$ tiene una parte sobre $-hat(j)$ y otra sobre $-hat(k)$; la de
$hat(k)$ es paralela a $bold(v)_0$ y no aporta nada, así que queda $-a hat(j)
times m_0 v_0 hat(k)$, y como $hat(j) times hat(k) = hat(i)$, el resultado
apunta a $-hat(i)$:
$ bold(H)_G = I omega_0 hat(k) + (-a hat(j) - a hat(k)) times m_0 v_0 hat(k) = - m_0 v_0 a thin hat(i) + I omega_0 hat(k) $
Es la ec. (1) del libro. Ahora la omega: tengo el momento angular y busco la
velocidad angular, así que divido, y sólo puedo dividir componente por
componente porque los ejes son principales. Lo de $hat(i)$ va con $I'$ y lo de
$hat(k)$ con $I$ (con $omega_x$, $omega_y$, $omega_z$ las componentes de
$bold(omega)$ en esos ejes):
// simbolos: omega_x, omega_y, omega_z
$ omega_x = (- m_0 v_0 a)/(I') = -4/5 m_0/m v_0/a = -2 " rad/s", quad omega_y = 0, quad omega_z = (I omega_0)/I = omega_0 = 6,283 " rad/s" $
La $m$ se fue, como prometí. El módulo, $omega = sqrt(omega_x^2 + omega_z^2) = 6,594$ rad/s, que son
$63,0$ rpm: el golpe casi no cambia cuánto gira; cambia *alrededor de qué*.

#W(5)
Sin cupla externa, $dif bold(H)_G \/ dif t = bold(0)$: el $bold(H)_G$ del
paso anterior es el *eje de precesión*, fijo en el espacio desde el instante
del choque. No hay más ecuación que esa: el resto es geometría.

#W(6)
// simbolos: H_x, H_z
Los dos ángulos los saco de las componentes. El de $bold(omega)$ con el eje,
de las omegas; el de $bold(H)_G$ con el eje, de los momentos ($H_x$ y $H_z$,
las componentes de $bold(H)_G$ sobre $x$ y sobre $z$):
$ tan gamma = abs(omega_x)/omega_z = 0,3183 arrow.r.double gamma = 17,7degree, quad tan theta = abs(H_x)/H_z = (I' abs(omega_x))/(I omega_z) = 2,5 dot.op 0,3183 = 0,796 arrow.r.double theta = 38,5degree $
*El eje de precesión* está en el plano $x z$, a $38,5degree$ del eje del
satélite, inclinado hacia $-x$ (porque $H_x < 0$). Como $gamma < theta$, la
precesión es *directa*, la que anticipaba $I < I'$.

Y ahora, partir $bold(omega)$ en precesión y spin. Me acuerdo de qué es la
velocidad angular de un cuerpo que precesa: la suma de dos giros, uno sobre
$bold(H)_G$ y otro sobre su propio eje, $bold(omega) = dot(phi) bold(K) +
dot(psi) hat(k)$. Esos dos ejes forman $theta$, no $90degree$: no puedo
proyectar. Lo que sí puedo es dibujarlos punta con cola: $dot(phi)$,
$dot(psi)$ y $bold(omega)$ forman un triángulo, con $gamma$ opuesto a
$dot(phi)$, $theta - gamma$ opuesto a $dot(psi)$ y $180degree - theta$ opuesto
a $omega$. El teorema del seno lo resuelve de una:
// simbolos: K
$ omega/(sin theta) = dot(phi)/(sin gamma) = dot(psi)/(sin(theta - gamma)) arrow.r.double dot(phi) = 30,7 " rpm", quad dot(psi) = 36,0 " rpm" $
Las dos positivas: precesión directa, confirmada por la cuenta y no por el
dibujo. Los conos son los de la fig. 18.23 del Beer: el corporal, alrededor
del eje del satélite, rueda *por afuera* del espacial, que rodea a
$bold(H)_G$.

#figure(fig-ley-senos, caption: text(size: 9pt)[La ley de los senos, de la
biblioteca del apunte. *Izquierda:* este problema a escala, $dot(phi)
bold(K)$ más $dot(psi) hat(k)$, punta con cola, dan $bold(omega)$ (directa).
*Derecha:* un cuerpo achatado en esquema, el caso del E2: el spin sale para
atrás (retrógrada).])

#W(7)
Otro camino, sin triángulo, con las relaciones de la precesión libre del Beer
(problema 18.119): $dot(phi) = H_G \/ I'$ y, de $omega_z = dot(psi) +
dot(phi) cos theta$, $dot(psi) = (I' - I)\/I' thin omega_z$. La segunda tiene
una gracia: con $I\/I' = 0,4$ da $dot(psi) = 0,6 dot.op 60 = 36,0$ rpm
*exactos*, sin ángulos de por medio. Y el libro, con los ángulos redondeados a
un decimal, imprime $dot(phi) = 30,8$ rpm y $dot(psi) = 35,9$ rpm: la
diferencia con los nuestros es el redondeo, no la física. También coinciden
$omega = 63,0$ rpm, $gamma = 17,7degree$ y $theta = 38,5degree$, que el libro
da en la misma página.

#trampa[*El signo de $omega_x$ depende de dónde está $C$, y $C$ está en la
figura.* Con $C$ del lado de $+y$, $hat(j) times hat(k) = +hat(i)$ y el eje de
precesión se inclina hacia $+x$: el mismo cono, espejado. $theta$, $gamma$,
$dot(phi)$ y $dot(psi)$ no cambian, pero un «eje de precesión» con el lado
equivocado está mal. La posición se lee del dibujo del enunciado, no del de un
resumen.]

#W(8)
Un meteorito de un kilo por tonelada de satélite, a $2$ km/s, no corre al
satélite de lugar: lo *tuerce*. El eje de simetría queda barriendo un cono de
$38,5degree$ alrededor de una dirección nueva, a $30,7$ rpm, mientras el
satélite gira sobre sí mismo a $36,0$ rpm. ¿Y si el meteorito hubiera pegado
sobre el eje, en el centro de la cara de abajo? Brazo paralelo a la velocidad:
cero momento angular, y el satélite seguiría girando como si nada (sólo se
llevaría el empujoncito de traslación). ¿Y si el cuerpo fuera achatado? Mismo
procedimiento, $gamma > theta$ y spin negativo: es el E2.

#final[$bold(omega) = (-2; 0; 6,283)$ rad/s, $63,0$ rpm; eje de precesión en
el plano $x z$, a $theta = 38,5degree$ del eje del satélite hacia $-x$;
$dot(phi) = 30,7$ rpm y $dot(psi) = 36,0$ rpm, directa. El libro: $30,8$ y
$35,9$ con los ángulos redondeados.]

#oral(
  ([¿Por qué se conserva $bold(H)_G$ en el choque si la fuerza es enorme?], [Porque es interna al sistema satélite + meteorito: no hay impulso angular externo, la integral del torque externo es cero.]),
  ([¿Depende el resultado de la masa del satélite?], [No: sólo del cociente $m_0\/m$, de $v_0$ y de $a$. La $m$ se simplifica en $omega_x$.]),
  ([¿Por qué no se proyecta $bold(omega)$ sobre el eje de precesión y sobre el eje del cuerpo?], [Porque esos dos ejes forman $theta$, no $90degree$: la base no es ortonormal. Se cierra el triángulo y se usa el teorema del seno.]),
  ([¿Directa o retrógrada, sin hacer cuentas?], [Directa: $I = 1/2 m a^2 < I' = 5/4 m a^2$. El cuerpo es alargado.]),
)

// =====================================================================
= E2 — El satélite geoestacionario y el meteorito en $B$ (Beer 18.127)

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Beer, problema *18.127*, pág. 1198 (la 624 del PDF), transcripto, con la figura P18.127 descripta. Aníbal lo resolvió en un cuaderno de Python, «Problema18_127_Beer.ipynb». El libro *no* trae la respuesta: la lista del final salta de 18.116 a 18.125 y de 18.126 a 18.129 (pág. 1360, la 786 del PDF, mirada).]
  // simbolos: b, k_x, k_y, k_z
  Un satélite geoestacionario de $800$ lb gira con una velocidad angular
  $bold(omega)_0 = (1,5 " rad/s") hat(j)$ cuando es golpeado en $B$ por un
  meteorito de $6$ oz que viaja con una velocidad relativa al satélite
  $bold(v)_0 = -(1600 " ft/s") hat(i) + (1300 " ft/s") hat(j) + (4000 " ft/s")
  hat(k)$. Si se sabe que $b = 20$ in y que los radios de giro del satélite
  son $k_x = k_z = 28,8$ in y $k_y = 32,4$ in, determine el eje de precesión y
  las velocidades de precesión y giro del satélite después del impacto.

  _En la figura:_ un cilindro con las antenas arriba; $y$ es el eje de
  simetría (vertical), $x$ sale hacia la derecha a la altura de $G$. El punto
  $A$ está sobre la pared, a $42$ in del eje sobre $x$; $B$, $b = 20$ in más
  abajo que $A$.
]

#gancho[Es el E1 con dos vueltas de tuerca: el meteorito llega en
diagonal (tres componentes de velocidad, no una) y el satélite es *achatado*,
como casi todos los geoestacionarios de spin de verdad, que son tambores más
anchos que altos. Lo que te da es lo mismo —el eje nuevo y las dos
velocidades— y además el primer caso de precesión *retrógrada* con números.
Lo simple: el workflow es idéntico, paso por paso. Lo complicado: el producto
vectorial tiene seis términos y un signo mal tirado da vuelta el eje, por eso
Aníbal se lo dejó a NumPy.]

#tipo("A")[
  // simbolos: r_B
  Otra vez golpe y precesión libre. El peso está en W4: el producto vectorial
  de la posición del impacto, $bold(r)_B$ (medida desde $G$), por la cantidad
  de movimiento del meteorito, $bold(r)_B times m bold(v)_0$, componente a
  componente, y la división
  componente por componente con *dos* momentos de inercia distintos. W6
  decide el sentido: $gamma > theta$.
]

#duda[El meteorito pesa seis onzas y el satélite ochocientas libras. ¿De
verdad lo puede torcer?]
#dedos[Sí, porque lo que cuenta no es la masa sino el momento angular que
trae. Seis onzas son $170$ gramos, pero a $4500$ ft/s, más de un kilómetro por
segundo, y pegando a un metro del eje. Su brazo por su cantidad de movimiento
es del orden del momento angular del satélite entero girando a $1,5$ rad/s.
Una bala de un rifle no tira una puerta, pero si pega en el borde la hace
girar.]

#W(1)
// simbolos: k_x, k_y, k_z, b, r_B, omega_0, v_0, g
Lo que tengo, en unidades del Beer ($g = 32,2$ ft/s²): satélite de $800$ lb
($24,84$ slug), meteorito de $6$ oz ($0,375$ lb, $0,01165$ slug), giro
inicial $bold(omega)_0 = 1,5 hat(j)$ rad/s sobre el eje de simetría $y$, radios
de giro $k_x = k_z = 2,4$ ft y $k_y = 2,7$ ft, y el punto de impacto: $B$ está
a $42$ in del eje sobre $x$ y $b = 20$ in por debajo de $G$, o sea $bold(r)_B =
(42; -20; 0)$ in $= (3,5; -1,667; 0)$ ft. La velocidad relativa,
$bold(v)_0 = (-1600; 1300; 4000)$ ft/s, de módulo $4500$ ft/s. Piden el eje de
precesión, $dot(phi)$ y $dot(psi)$.

#W(2)
Origen en $G$, ejes del libro: $y$ sobre el eje de simetría (el de la
antena), $x$ hacia $A$, $z$ completando la terna. Son principales por
simetría de revolución. Los momentos de inercia, del radio de giro: el
*axial* es el de $y$ y el *transversal* el de $x$ o $z$:
$ I = m k_y^2 = 181,1 " slug·ft²", quad I' = m k_x^2 = 143,1 " slug·ft²" $
$I > I'$: *achatado*. La apuesta, antes de la primera cuenta: retrógrada.

#W(3)
Igual que en el E1: el choque es interno al sistema satélite + meteorito,
así que se conserva $bold(H)_G$ durante el golpe; después no hay cupla
externa y $bold(H)_G$ queda fijo. El meteorito es el $0,05$ % de la masa: no
corre $G$ ni toca los momentos de inercia (supuesto dicho, ANI-53).

#W(4)
Antes, sólo el spin: $bold(H)_"sat" = I omega_0 hat(j) = (0; 271,7; 0)$. El
meteorito aporta su momento angular respecto de $G$. Lo armo pensando qué
componente sale de qué, con $r_x$, $r_y$, $r_z$ las componentes de
$bold(r)_B$ y $v_x$, $v_y$, $v_z$ las de $bold(v)_0$: la $x$ del producto
mezcla las $y$ y $z$ de los dos vectores, y así en ronda:
// simbolos: H_sat, H_met, m_met, r_x, r_y, r_z, v_x, v_y, v_z
$ bold(r)_B times bold(v)_0 = (r_y v_z - r_z v_y; thin r_z v_x - r_x v_z; thin r_x v_y - r_y v_x) = (-6667; -14 thin 000; 1883) " ft²/s" $
y multiplicado por la masa del meteorito, $bold(H)_"met" = m_"met" bold(r)_B
times bold(v)_0 = (-77,6; -163,0; 21,9)$. Fijate la del medio: el meteorito
le *quita* al spin el $60$ % de su momento angular sobre $y$. Sumando:
$ bold(H)_G = (-77,6; 108,6; 21,9) " slug·ft²/s", quad H_G = 135,3 $
Ahora la omega, dividiendo componente por componente: lo transversal ($x$,
$z$) con $I'$ y lo axial ($y$) con $I$:
// simbolos: H_x, H_y, H_z
$ bold(omega) = (H_x/I'; thin H_y/I; thin H_z/I') = (-0,543; 0,600; 0,153) " rad/s", quad omega = 0,823 " rad/s" $

#W(5)
Sin cupla después del choque: $dif bold(H)_G \/ dif t = bold(0)$. La
dirección de $bold(H)_G$ es el eje de precesión, fijo. Sus ángulos con los
ejes $x$, $y$, $z$ ($theta_x$, $theta_y$, $theta_z$, los cosenos directores
pasados a grados), en el formato en que el Beer da las respuestas de los
vecinos 18.125 y 18.126:
// simbolos: theta_x, theta_y, theta_z
$theta_x = 125,0degree$, $theta_y = 36,6degree$, $theta_z = 80,7degree$.

#W(6)
El ángulo del eje de simetría con $bold(H)_G$ sale de la componente sobre
$y$, y el de $bold(omega)$ igual, con su propia componente:
$ cos theta = H_y/H_G = (108,6)/(135,3) arrow.r.double theta = 36,6degree, quad cos gamma = omega_y/omega = (0,600)/(0,823) arrow.r.double gamma = 43,2degree $
$gamma > theta$: *retrógrada*, como anticipaba $I > I'$. El triángulo de la
ley de los senos es el panel de la derecha de la figura del E1: el lado de
$dot(psi)$ apunta para atrás, porque $sin(theta - gamma) < 0$:
$ dot(phi) = (omega sin gamma)/(sin theta) = 0,946 " rad/s", quad dot(psi) = (omega sin(theta - gamma))/(sin theta) = -0,159 " rad/s" $
El spin negativo *es* la retrógrada: el cuerpo gira sobre su eje al revés de
como su eje gira alrededor de $bold(H)_G$. Nadie tuvo que acordarse del signo:
lo da la fórmula. En números: el eje da una vuelta alrededor de $bold(H)_G$
cada $6,64$ s, y el satélite tarda $39,4$ s en dar una vuelta sobre sí mismo
respecto del plano que precesa.

#anibal[
  // simbolos: I_x, I_y, I_z
  Su cuaderno NumPy hace exactamente estos pasos, en este orden: datos y
  conversiones (pulgadas a pies, onzas a libras, libras a slugs); $I_x = I_z$
  (el transversal, nuestro $I'$) e $I_y$ (el axial, nuestro $I$) de los radios
  de giro; $bold(H)_G = I_y bold(omega)_0 + bold(r)_B
  times m_"met" bold(v)_0$ con `np.cross`; $bold(omega)$ dividiendo por cada
  momento de inercia; $theta$ con el arcocoseno de $H_y \/ H_G$; $gamma$ con
  $tan gamma = (I_y\/I_x) tan theta$ (la relación del Beer, en vez de la
  componente de $bold(omega)$); y la ley de los senos. Imprime $0,94556$ y
  $-0,15932$ rad/s, los mismos que acá. Tres detalles, por si lo corrés: la
  celda «1) Momentos de Inercia» en realidad calcula $bold(H)_G$; el
  comentario de $bold(omega)_0$ dice «ft/s» y son rad/s; y `np.atan` existe
  recién desde NumPy 2 (con uno anterior, `np.arctan`). Lo que muestra el
  cuaderno es lo que Aníbal evalúa: la cuenta la hace la máquina, el planteo
  lo hace uno (ANI-66).
]

#W(7)
Otro camino, sin triángulo: $dot(phi) = H_G \/ I' = 135,3 \/ 143,1 = 0,946$
rad/s, y $dot(psi) = (I' - I)\/I' thin omega_y = -0,2656 dot.op 0,600 = -0,159$
rad/s. Y el control de que todo cierra: la componente de $bold(omega)$ sobre el
eje tiene que ser spin más precesión proyectada, $omega_y = dot(psi) +
dot(phi) cos theta = -0,159 + 0,946 dot.op 0,803 = 0,600$. El libro no da la
respuesta, así que el control externo es el cuaderno de Aníbal, que coincide en
todas las cifras.

#W(8)
Un meteorito de $170$ g a $1,37$ km/s deja a un satélite de $363$ kg
bamboleando en un cono de $36,6degree$, con el eje dando una vuelta cada seis
segundos y medio: para una antena geoestacionaria, que tiene que apuntar a un
pedazo de Tierra con décimas de grado, es una catástrofe que sólo arregla el
control de actitud. ¿Y si pegaba en $A$, a la altura de $G$ (el 18.128)? Con
la posición de $A$,
// simbolos: r_A
$bold(r)_A = (3,5; 0; 0)$ ft, desaparecen los dos términos que traía $r_y$, y
cambia todo menos el procedimiento. ¿Y si el satélite fuera alargado? $gamma <
theta$ y directa, como el E1.

#final[Eje de precesión: la dirección de $bold(H)_G = (-77,6; 108,6; 21,9)$
slug·ft²/s, a $theta = 36,6degree$ del eje del satélite ($theta_x =
125,0degree$, $theta_y = 36,6degree$, $theta_z = 80,7degree$); $dot(phi) =
0,946$ rad/s y $dot(psi) = -0,159$ rad/s: retrógrada. Coincide con el cuaderno
de Aníbal; el Beer no trae la respuesta.]

#oral(
  ([¿Por qué el spin sale negativo?], [Porque el cuerpo es achatado ($I > I'$): $gamma > theta$ y $sin(theta - gamma) < 0$. Spin y precesión van al revés: retrógrada.]),
  ([¿Qué cambia si el meteorito vuelve a la misma velocidad pero al revés?], [$bold(H)_"met"$ cambia de signo: ya no le quita sino que le suma al spin, $bold(H)_G$ queda casi sobre $y$ y el cono se cierra.]),
  ([¿Importa que el satélite sea geoestacionario?], [Para esta cuenta, no: el choque dura un instante y la gravedad no alcanza a cambiar nada mientras tanto. Importa para lo que viene después: a la larga, mantener una antena apuntando a la Tierra pide su propia cupla (E4).]),
  ([¿Por qué se divide $H_y$ por $I$ y no por $I'$?], [Porque $y$ es el eje de simetría: su momento de inercia es el axial. $x$ y $z$ son transversales y van con $I'$.]),
)

// =====================================================================
= E3 — La Tierra: equinoccios contra Chandler (Beer 18.117 y 18.123)

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Beer, problemas *18.117* (pág. 1196, la 622 del PDF) y *18.123* (pág. 1197, la 623), transcriptos; la relación del 18.121 que usa el segundo, también. Aníbal pidió hacerlos juntos y «analizar las diferencias». El libro no trae las respuestas (la lista del final no los incluye).]
  // simbolos: R, M, A, m, r, n, omega_z
  *18.117.* Si la Tierra fuera una esfera, la atracción gravitacional del Sol,
  la Luna y los planetas siempre sería equivalente a una sola fuerza
  $bold(R)$ que actúa en el centro de masa de nuestro planeta. En realidad la
  Tierra es un esferoide achatado y el sistema gravitacional que actúa sobre
  ella es equivalente a una fuerza $bold(R)$ y un par $bold(M)$. Si se sabe
  que el efecto del par $bold(M)$ es causar que el eje terrestre preceda
  alrededor del eje $G A$ a una velocidad de una revolución en $25 thin 800$
  años, determine la magnitud promedio del par $bold(M)$ aplicado a la Tierra.
  Suponga que su densidad promedio es de $5,51$ g/cm³, que el radio promedio
  terrestre es de $6370$ km, y que $I = 2/5 m r^2$. _(Con $m$ la masa y $r$
  el radio de la Tierra. En la figura, el eje $G A$ es perpendicular a la
  eclíptica y el eje terrestre forma $23,45degree$ con él. Nota del libro:
  esta precesión forzada es la de los equinoccios y no debe confundirse con la
  libre del 18.123.)_

  // simbolos: n, omega_z
  *18.121 (la relación).* El vector $bold(omega)$ de un cuerpo simétrico no
  sometido a fuerzas, visto desde el cuerpo mismo, gira alrededor del eje de
  simetría a la razón constante $n = (I' - I)\/I' thin omega_z$. _(Con
  $omega_z$ la componente de $bold(omega)$ sobre el eje de simetría.)_

  *18.123.* Utilizando la relación dada en el problema 18.121, determine el
  periodo de precesión del polo norte de la Tierra alrededor de su eje de
  simetría. La Tierra puede aproximarse mediante un esferoide achatado de
  momento de inercia axial $I$ y un momento de inercia transversal $I' =
  0,99671 I$. _(Nota del libro: las observaciones muestran un periodo de
  aproximadamente $432,5$ días solares medios; la diferencia se debe a que la
  Tierra no es un cuerpo perfectamente rígido.)_
]

#gancho[Es el único problema del capítulo donde el cuerpo rígido es un
planeta, y el que mejor separa dos cosas que en el pizarrón se ven iguales:
una precesión *forzada*, en la que una cupla de afuera hace girar al momento
angular, y una *libre*, en la que el momento angular está quieto y lo que se
mueve es el cuerpo alrededor de él. Te da dos números que existen en el cielo:
la cupla con que el Sol y la Luna tuercen a la Tierra (la razón por la que
dentro de trece mil años la estrella polar no va a ser la Polar) y el período
con que el polo de rotación pasea sobre la superficie. Lo simple: dos fórmulas
del Beer, una cuenta cada una. Lo complicado: que el mismo cuerpo, con casi
el mismo dato, dé $25 thin 800$ años en un caso y $302$ días en el otro.]

#tipo("B y C")[
  El 18.117 es clase *B*: se conoce el movimiento (precesión estable, el
  ángulo y el período) y se busca la cupla. El 18.123 es clase *C*: libre de
  torques, con el estado dado, se busca el movimiento. Cargan el peso W5 (cada
  uno con su ecuación) y W8, que es el pedido de Aníbal: las diferencias.
]

#duda[Si los dos son «la precesión de la Tierra», ¿por qué uno tarda
veinticinco mil años y el otro menos de uno? ¿No es lo mismo?]
#dedos[No, y la diferencia entra en una mano. En la forzada, el eje de la
Tierra apunta a un lugar del cielo y, despacito, ese lugar da una vuelta
alrededor del polo de la eclíptica: lo empuja una cupla, y el momento angular
mismo gira. En la libre nadie empuja: el momento angular está clavado, y lo
que pasa es que el eje de giro no coincide del todo con el eje del abultamiento,
así que, parado sobre la Tierra, ves al polo de rotación dar vueltitas
alrededor del polo «geométrico». Una es el trompo que no se cae porque gira;
la otra, el plato que tiraste girando y bambolea solo.]

#W(1)
// simbolos: rho, R_T, epsilon, T_p
*18.117:* densidad $rho = 5510$ kg/m³, radio de la Tierra $R_T = 6,37 times
10^6$ m, $I = 2/5 m R_T^2$, oblicuidad $epsilon = 23,45degree$ (el ángulo entre el eje
terrestre y el eje de precesión $G A$, la normal a la eclíptica), período de
precesión $T_p = 25 thin 800$ años. Se pide la cupla media. Falta un dato que
el libro da por sabido: cuánto gira la Tierra. Uso la vuelta respecto de las
estrellas, el día sideral de $23$ h $56$ min, que da
$omega = 7,29 times 10^(-5)$ rad/s. *18.123:* $I' = 0,99671 I$ y la relación del 18.121; se pide el
período con que el polo de rotación gira alrededor del eje de simetría.

#W(2)
*18.117:* el que importa es un sistema *inercial* centrado en la Tierra, con
$bold(K)$ perpendicular a la eclíptica: ahí $bold(H)_G$ gira. *18.123:* el
sistema *pegado a la Tierra*, con $hat(k)$ sobre el eje de simetría (el polo
geográfico «de figura»): la relación del 18.121 es lo que se ve desde ahí. Son
dos marcos distintos, y no es un detalle: es la mitad de la respuesta a
Aníbal.

#W(3)
*18.117:* actúa la cupla del Sol y la Luna sobre el abultamiento ecuatorial.
Una esfera no la sentiría: con una esfera la gravedad es una sola fuerza en
$G$ (el enunciado lo dice). No se conserva $bold(H)_G$: cambia de dirección, no
de módulo. *18.123:* ninguna cupla (el problema la apaga a propósito), así que
$bold(H)_G$ se conserva entero. Supuestos, dichos: Tierra rígida en los dos
(el 18.123 dice que es justo lo que falla), simétrica de revolución, y en el
18.117 la cupla promediada en el año, porque la del Sol se anula en los
equinoccios y la de la Luna cambia con su órbita.

#W(4)
// simbolos: m, H, pi
*18.117:* la masa sale de la densidad por el volumen de la esfera (con $pi$
el de siempre), $m = rho 4/3 pi R_T^3 = 5,97 times 10^24$ kg, y el momento de
inercia que pide el libro, $I = 2/5 m R_T^2 = 9,68 times 10^37$ kg·m². El
momento angular $H$ es casi todo spin (la precesión es del orden de diez
millones de veces más lenta), y apunta sobre el eje:
$H = I omega = 7,06 times 10^33$ kg·m²/s. *18.123:* el momento angular tampoco hace falta en números:
basta saber que está fijo y que el eje de giro casi coincide con el de
simetría ($omega_z approx omega$).

#W(5)
*18.117, la precesión estable.* Pienso qué hace la cupla: la punta de
$bold(H)_G$, que forma $epsilon$ con $bold(K)$, recorre un círculo de radio
$H sin epsilon$, a la velocidad angular de precesión
$dot(phi) = 2 pi \/ T_p = 7,72 times 10^(-12)$ rad/s. La derivada de un vector
que gira es módulo por velocidad de giro, y esa derivada es la cupla:
// simbolos: M
$ M = abs((dif bold(H)_G)/(dif t)) = I omega dot(phi) sin epsilon = 2,17 times 10^22 " N·m" $
*18.123, la precesión libre vista desde la Tierra.* Me paro en el marco de la
Tierra y escribo las ecuaciones de Euler sin cupla (Beer ec. 18.37), con $x$,
$y$ transversales ($I'$) y $z$ axial ($I$); $dot(omega)_x$ y $dot(omega)_y$
son las derivadas de las componentes transversales de $bold(omega)$ vistas
desde la Tierra. Las dos transversales dan
// simbolos: lambda, omega_perp, omegadot_x, omegadot_y
$ I' dot(omega)_x = (I' - I) omega_y omega_z, quad I' dot(omega)_y = (I - I') omega_z omega_x arrow.r.double (dif bold(omega)_perp)/(dif t) = lambda hat(k) times bold(omega)_perp, quad lambda = (I - I')/I' omega_z $
o sea: la parte de $bold(omega)$ que se sale del eje, $bold(omega)_perp$, gira
alrededor de $hat(k)$ a la velocidad angular $lambda$. Con $I' = 0,99671 I$,
$(I - I')\/I' = 0,00330$, y el período $T$ de esa vuelta es
// simbolos: T
$ T =(2 pi)/lambda = I'/(I - I') dot.op (2 pi)/omega_z = 302 " días" $
(con la vuelta de un día solar en vez del sideral, $303$: da igual).

#W(6)
// simbolos: Xhat, Yhat
*El sentido de la forzada*, del producto vectorial y no del dibujo. Tomo
$bold(K)$ hacia el norte de la eclíptica, $hat(bold(X))$ hacia donde se
inclina el polo norte (los dos fijos en el espacio) e $hat(bold(Y)) =
bold(K) times hat(bold(X))$, así que $bold(H)_G = H (sin epsilon thin
hat(bold(X)) + cos epsilon thin bold(K))$. El Sol tira más del pedazo de
abultamiento que tiene cerca que del de enfrente, y eso tiende a *enderezar*
el ecuador sobre la eclíptica: a llevar $bold(H)_G$ hacia $bold(K)$. El giro
que lleva $hat(bold(X))$ hacia $bold(K)$ es alrededor de $-hat(bold(Y))$,
porque $(-hat(bold(Y))) times hat(bold(X)) = bold(K)$: la cupla apunta a
$-hat(bold(Y))$. Pero la cupla no inclina a $bold(H)_G$: le suma $dif
bold(H)_G = bold(M) dif t$, *de costado*, sobre $-hat(bold(Y))$. La proyección
horizontal de $bold(H)_G$ va de $hat(bold(X))$ hacia $-hat(bold(Y))$, y como
$hat(bold(X)) times (-hat(bold(Y))) = -bold(K)$, gira en sentido *horario*
visto desde el norte de la eclíptica: al revés del giro de la Tierra. Es la
precesión *retrógrada* de los equinoccios, que se corren hacia el oeste. «El
spin persigue a la cupla»: el eje no se acuesta, se corre.

*El sentido de la libre.* Para la Tierra $I > I'$, así que $lambda > 0$, y
$lambda hat(k) times bold(omega)_perp$ hace girar a $bold(omega)_perp$ en el
*mismo* sentido que $omega_z$: visto desde la Tierra, el polo de rotación da
vueltas alrededor del polo de figura en el sentido en que gira la Tierra, de
oeste a este. Es lo que mide la astronomía, y se llama «prógrado».

#trampa[*En el lenguaje del Beer, la precesión libre de la Tierra es
retrógrada, y eso no contradice lo de arriba.* Achatada, $I > I'$: $dot(psi) =
(I' - I)\/I' thin omega_z < 0$, spin al revés que la precesión del eje
alrededor de $bold(H)_G$ *en el espacio*. Lo que se ve desde la Tierra es otra
cantidad, en otro marco: el giro de $bold(omega)$ respecto del cuerpo, que es
$-dot(psi)$. Por eso la $n$ del 18.121 tiene el signo de $dot(psi)$ y el polo
anda para el otro lado. Un control que mide otra cantidad confirma una
deducción con el signo cambiado: pasó en este apunte, en septiembre.]

#W(7)
*18.117 por la ecuación entera* de la precesión estable (Beer ec. 18.44, con $I'
approx I$): $M = dot(phi) sin epsilon (I omega_z - I' dot(phi) cos epsilon)$.
El segundo término es $dot(phi)\/omega = 1,06 times 10^(-7)$ veces el primero:
no se ve ni en la cuarta cifra, y da $2,17 times 10^22$ N·m igual. Con el día
solar en vez del sideral, $2,16 times 10^22$: la diferencia es el $0,3$ %, y
el dato que falta en el enunciado no cambia nada que importe. *18.123 por el
18.119:* $dot(psi) = H_G cos theta (I' - I)\/(I I')$, y como $H_G cos theta = I
omega_z$, $abs(dot(psi)) = (I - I')\/I' thin omega_z = lambda$: los mismos
$302$ días. Y una tercera mirada, desde el espacio: el eje de figura gira
alrededor de $bold(H)_G$ con $dot(phi) = H_G \/ I' approx (I\/I') omega$, una
vuelta cada $23,9$ h. La misma precesión libre dura un día visto desde las
estrellas y $302$ días visto desde la Tierra.

#W(8)
Lo que pidió Aníbal, en una tabla:

#{
  set par(justify: false)
  set text(size: 8.6pt)
  table(
    columns: (1.05fr, 1.6fr, 1.6fr),
    inset: (x: 5pt, y: 4pt),
    table.header(..([], [*Forzada* (18.117, los equinoccios)], [*Libre* (18.123, Chandler)]).map(t => text(weight: "bold", fill: c-azul)[#t])),
    [Qué precesa], [El eje de la Tierra, y con él $bold(H)_G$], [El eje de rotación $bold(omega)$ respecto del eje de figura],
    [Alrededor de qué], [De la normal a la eclíptica ($G A$)], [Del eje de simetría de la Tierra],
    [En qué marco], [Inercial: se ve en las estrellas], [Pegado a la Tierra: se ve en la latitud de los observatorios],
    [Cupla], [Sí: Sol y Luna sobre el abultamiento, $2,17 times 10^22$ N·m de media], [Ninguna],
    [$bold(H)_G$], [Gira (cambia de dirección, no de módulo)], [Fijo],
    [Período], [$25 thin 800$ años], [$302$ días calculado, $432,5$ observado (en el espacio, $23,9$ h)],
    [Qué dato de inercia pesa], [$I$ entero: cuánto momento angular hay que hacer girar], [La diferencia $(I - I')\/I' = 0,33$ %: con una esfera, $I = I'$ y no habría nada],
    [Sentido], [Retrógrado: horario visto desde el norte de la eclíptica], [Desde la Tierra, el del giro de la Tierra (prógrado); en el Beer, $dot(psi) < 0$],
    [Qué falla del modelo rígido], [Poco: la cupla se deduce del período medido], [Mucho: la Tierra cede y el período real es un $43$ % más largo],
  )
}

*Por qué el dato de $I$ no es el mismo.* En el 18.117, $I = 2/5 m R_T^2$ es el de
una esfera uniforme; la Tierra real es más densa en el centro y su $I$ es algo
menor, así que la cupla verdadera es algo más chica. Pero el problema no
necesita más: $I$ entra como «cuánto pesa el trompo», y un error del
veinte por ciento da una cupla del mismo orden. En el 18.123, en cambio, la
esfera uniforme da $I = I'$, $lambda = 0$ y ninguna precesión: todo el efecto
vive en el $0,33$ % del abultamiento, por eso el libro da $I'$ con cinco
cifras. *Por qué el rígido no da el observado:* la Tierra no es rígida. Cuando
el eje de giro se corre, el abultamiento ecuatorial, que es elástico y tiene
océanos encima, se reacomoda en parte hacia el eje nuevo; la diferencia
$I - I'$ que «ve» la precesión es menor que la del planeta quieto, y con un
$lambda$ más chico el período se alarga: de $302$ días a los $432,5$ que
encontró Chandler en 1891. El Beer lo dice en su nota; la cuenta dice cuánto:
un $43$ % de más.

#final[*18.117:* $M = 2,17 times 10^22$ N·m de media (con $omega$ sideral; con
el día solar, $2,16 times 10^22$). *18.123:* $302$ días calculados contra
$432,5$ observados. Forzada: la cupla hace girar a $bold(H)_G$ en el espacio,
hacia el oeste, en $25 thin 800$ años. Libre: $bold(H)_G$ quieto, y el polo de
rotación da vueltas alrededor del de figura visto desde la Tierra. El Beer no
trae las respuestas.]

#oral(
  ([¿Por qué una esfera no tendría precesión de los equinoccios?], [Porque sobre una esfera la gravedad del Sol y la Luna es una sola fuerza en $G$: brazo cero, cupla cero. La cupla sale del abultamiento.]),
  ([¿La cupla del Sol inclina el eje terrestre hacia la eclíptica?], [No: tiende a hacerlo, pero sobre un cuerpo que gira la cupla hace correr a $bold(H)_G$ de costado ($dif bold(H)_G = bold(M) dif t$). El ángulo de $23,45degree$ queda; lo que cambia es hacia dónde apunta el eje.]),
  ([¿Por qué el 18.123 da días y el 18.117 milenios?], [Porque la libre depende sólo de la forma de la Tierra ($lambda$ es $0,33$ % del giro diario), y la forzada de lo débil que es la cupla comparada con el momento angular de la Tierra.]),
  ([¿Directa o retrógrada la libre de la Tierra?], [En el sentido del Beer, retrógrada: es achatada, $dot(psi) < 0$. Visto desde la Tierra, el polo gira en el mismo sentido que la Tierra: son dos cantidades distintas.]),
)

// =====================================================================
= E4 — El satélite GEO con el spin apuntando a la Tierra

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Problema del *Meriam* (Dinámica, cap. 7), en el .docx que subió Aníbal el 15/11 («Torque giroscópico satélite GEO»), con su traducción y su resolución. Tema: Beer §18.10, precesión estable.]
  // simbolos: omega_s, M_G
  Un satélite de comunicaciones está en órbita geoestacionaria (GEO), con
  período de $24$ h. Gira alrededor de su eje de simetría a $omega_s = 1$ rpm,
  con momento de inercia de $550$ kg·m² respecto de ese eje y de $225$ kg·m²
  respecto de los ejes transversales por el centro de masa $G$. Si el eje de
  spin apunta inicialmente hacia la Tierra, calcular la magnitud y la
  dirección del torque $bold(M)_G$ necesario para que el eje apunte *siempre*
  hacia la Tierra.

  _En la figura:_ la órbita circular, recorrida en sentido antihorario; en
  tres posiciones, $z$ radial hacia afuera, $x$ tangente a la órbita y
  $bold(omega)_s$ apuntando a la Tierra.
]

#gancho[Es el problema que explica por qué los satélites geoestacionarios
*no* se diseñan así. Te da el costo de una decisión de arquitectura: si el
momento angular grande apunta a la Tierra, tiene que dar una vuelta por día, y
hacer girar un momento angular cuesta una cupla todo el tiempo. Lo simple: es
una precesión estable con $theta = 90degree$, una línea. Lo interesante viene
después: con qué se hace esa cupla, cuánto combustible gasta en quince años, y
qué hace la industria en cambio.]

#tipo("B")[
  Se conoce el movimiento (el eje gira una vuelta por órbita) y se busca la
  cupla. El peso está en W2 (ejes en la terna que gira con la órbita), W4 (un
  $bold(H)_G$ con dos términos, uno de ellos de distracción) y W6 (el sentido,
  de un producto vectorial).
]

#duda[El satélite gira a $1$ rpm y la órbita es una vuelta por día. ¿No
debería alcanzar con dejarlo girar? ¿Por qué hace falta empujarlo?]
#dedos[Porque un giróscopo apunta siempre al mismo lugar *de las estrellas*,
y la Tierra, vista desde el satélite, da una vuelta por día. Si nadie lo
empuja, el eje que a la mañana apunta a la Tierra a la noche apunta al espacio
del otro lado. Para que la siga, hay que hacer girar al momento angular una
vuelta por día, y eso es exactamente lo que hace una cupla.]

#W(1)
// simbolos: I_0, p, Omega, M_G
Momento de inercia axial $I = 550$ kg·m² y transversal $I_0 = 225$ kg·m² (en
el Beer sería $I'$; acá uso la letra del .docx de Aníbal). Spin $p = 1$ rpm
$= 0,1047$ rad/s. Precesión que se exige: una vuelta por órbita, $Omega = 2 pi
\/ (24 " h") = 7,27 times 10^(-5)$ rad/s. Ángulo entre el eje de spin y el eje
de precesión: $90degree$ (el eje es radial, en el plano de la órbita, y
$Omega$ es perpendicular a ese plano). Se pide $bold(M)_G$, módulo y
dirección.

#W(2)
La terna de la figura, que *gira con la órbita*: $z$ radial hacia afuera, $x$
tangente en el sentido del movimiento, $y = z times x$ saliendo del papel. Como
la órbita es antihoraria en el papel, la velocidad angular de la terna es
$Omega hat(j)$, y el spin, que apunta a la Tierra, va sobre $-hat(k)$. Elijo
esta terna porque en ella las componentes de $bold(H)_G$ son constantes: la
derivada relativa es cero y sobrevive un solo producto vectorial (el teorema
del transporte, como en los Problemas 2 y 3).

#W(3)
Sobre el satélite tiene que actuar una cupla externa: es lo que se busca. No
se conserva $bold(H)_G$ en dirección; sí en módulo, porque la precesión es
estable. Supuestos: el satélite simétrico y rígido; el spin sostenido en
$1$ rpm; el resto de las cuplas del ambiente, ignoradas (en W8 se ve que son
chicas).

#W(4)
La velocidad angular del satélite es la de la terna más el spin: $bold(omega)
= Omega hat(j) - p hat(k)$. Los dos ejes son principales: $hat(j)$ es
transversal y va con $I_0$; $hat(k)$ es el de simetría y va con $I$:
$ bold(H)_G = I_0 Omega hat(j) - I p hat(k) $
El término sobre $hat(j)$ es diminuto ($p\/Omega = 1440$) y, además, como
$hat(j)$ es el eje alrededor del cual gira la terna, no cambia de dirección.
*Sutileza* que señala el .docx: no importa si el rpm se mide respecto de la
terna o del espacio, porque la componente de $bold(omega)$ sobre el eje es
$p + Omega cos 90degree = p$.

#W(5)
En la terna que gira con $Omega hat(j)$, las componentes de $bold(H)_G$ no
cambian, así que la derivada es sólo el transporte. Pienso cuál término
sobrevive: $hat(j) times hat(j) = 0$ se lleva al de $I_0$, y queda el de spin:
$ bold(M)_G = (dif bold(H)_G)/(dif t) = Omega hat(j) times bold(H)_G = Omega hat(j) times (-I p hat(k)) = -I p Omega thin hat(i) $
Es la ec. 18.44 del Beer, $M = Omega sin theta (I p - I_0 Omega cos theta)$,
con $theta = 90degree$: el coseno mata el término de $I_0$. *Los $225$ kg·m²
son un dato de distracción.*
$ M_G = I p Omega = 550 dot.op 0,1047 dot.op 7,27 times 10^(-5) = 4,19 times 10^(-3) " N·m" $

#W(6)
El sentido salió del producto: $hat(j) times hat(k) = hat(i)$, con el menos
del spin, $-hat(i)$. La cupla va sobre $-x$: *opuesta* a la velocidad orbital,
perpendicular al eje de spin y en el plano de la órbita. El control con las
manos: cuando el satélite avanza un poco, la dirección «hacia la Tierra» rota
con él, y la punta de $bold(H)_G$ (que es casi todo $-I p hat(k)$) se tiene que
correr: $Omega dif t thin hat(j) times (-hat(k)) = -Omega dif t thin hat(i)$,
hacia $-x$. La cupla apunta justo hacia donde tiene que ir la punta: el spin
persigue a la cupla.

#anibal[
  El .docx resuelve exactamente así: la terna de la figura, $bold(omega) =
  Omega hat(j) - p hat(k)$, $bold(H)_G = I_0 Omega hat(j) - I p hat(k)$,
  $bold(M)_G = Omega hat(j) times bold(H)_G$, y la observación de que $I_0$
  no interviene. Escribe $I_p$ para el producto $I p$, el momento angular de
  spin
  // simbolos: I_p
  («$57,6$ N·m·s»), y usa $24$ h para
  la órbita, aunque una geoestacionaria dura un día sideral: cambia el
  resultado en el $0,3$ %. Y después hace lo que más vale del problema: se
  pregunta con qué se aplicaría esa cupla.
]

#W(7)
Otro camino, sin teorema del transporte: el momento angular de spin, $I p =
57,6$ N·m·s, tiene que dar una vuelta entera por día. Lo que le cambia a un
momento angular en un intervalo es el impulso angular, la integral de la
cupla: en un día, $M_G dot.op 86 thin 400 " s" = 362$ N·m·s. Y hacer girar
$360degree$ un vector de módulo $57,6$ es recorrer una circunferencia de
largo $2 pi dot.op 57,6 = 362$ N·m·s. Las dos cuentas dan lo mismo: la cupla
es el ritmo al que hay que «doblar» el momento angular.

#W(8)
*Con qué se aplicaría.* Tiene que ser una cupla *externa*: ruedas o motores de
adentro reparten el momento angular entre piezas, no lo hacen girar entero. Y
está fija en la terna de la órbita mientras el cuerpo gira a $1$ rpm, así que
un actuador montado en el cuerpo hay que pulsarlo en fase con el spin.
  // simbolos: I_sp
- *Propulsores:* $362$ N·s por día con un brazo de $1$ m; con hidracina, de
  impulso específico $I_"sp" approx 220$ s, $0,17$ kg por día, unos $61$ kg por año y $920$ kg en
  quince años, sin contar lo que se pierde pulsando sólo en parte de cada
  vuelta. Inaceptable.
- *Magnetorquers:* en GEO el campo terrestre es de unos $100$ nT; harían
  falta $4,2 times 10^4$ A·m², y los de verdad dan de unos pocos a cientos.
  Sirven en órbita baja, no acá.
- *Presión de radiación:* del orden de $10^(-5)$ N·m, $419$ veces menos
  de lo que hace falta (el .docx dice «unas 100»: el orden de magnitud es lo
  que manda).
- *Gradiente de gravedad:* con el eje radial es *cero* (posición de
  equilibrio), y aunque no lo fuera, $3 Omega^2 (I - I_0) = 5,2 times 10^(-6)$
  N·m.

*Lo que se hace de verdad:* poner el momento angular grande *perpendicular a
la órbita*, que es una dirección que no cambia en el espacio. Con $bold(H)$
sobre $hat(j)$, $Omega hat(j) times H hat(j) = bold(0)$: no hace falta ninguna
cupla. Así son los de *doble spin* (Hughes HS-376, Intelsat VI: un tambor que
gira con el eje paralelo al eje polar y una plataforma «desgirada» por un motor
que da una vuelta por día para mirar a la Tierra) y los estabilizados en tres
ejes con una *rueda de momento* sobre el eje normal a la órbita, que es lo que
domina hoy en GEO. Los propulsores y los magnetorquers quedan para descargar
las ruedas de lo que acumulan las perturbaciones.

#final[$bold(M)_G = -I p Omega thin hat(i) = -4,19 times 10^(-3) hat(i)$ N·m:
sobre $-x$, opuesta a la velocidad orbital. $I_0$ no interviene. Mantenerlo
cuesta $362$ N·m·s de impulso angular por día: por eso los GEO llevan el
momento angular perpendicular a la órbita.]

#oral(
  ([¿Por qué no interviene el momento de inercia transversal?], [Porque con $theta = 90degree$ el término $I_0 Omega cos theta$ se anula: el $I_0 Omega hat(j)$ está sobre el eje de giro de la terna y no cambia de dirección.]),
  ([¿Puede una rueda de reacción a bordo hacer esta cupla?], [No a la larga: es interna y sólo reparte el momento angular. Hace falta una cupla externa para que el total gire.]),
  ([¿Y si el eje de spin apuntara perpendicular a la órbita?], [$bold(H)_G$ quedaría fijo en el espacio y la cupla necesaria sería cero. Es la arquitectura que se usa.]),
  ([¿Cuánto cambia si la órbita fuera de un día sideral?], [La cupla escala con $Omega$: un $0,3$ % más. Nada que cambie la conclusión.]),
)

// =====================================================================
= E5 — Coning impulsivo: dos golpes y la precesión libre en el medio

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[El .docx que subió Aníbal el 15/11 («Reorientación por coning impulsivo»), que sigue a *Martz, NASA TN D-8452* (1977, `Coning NASA.pdf`, ec. 5 y fig. 5); y el *Curtis* §12.7 (`Thrusters Curtis.pdf`, ej. 12.8). Los cuatro ejercicios son los del .docx, con sus respuestas, verificadas acá.]
  // simbolos: R_2, Phi_f, theta_0, Delta, psi, psi_0, psi_f, Q_2
  Datos de la figura 5 del TN: $I_x = 160$, $I_y = 100$, $I_z = 60$
  (los momentos principales, en unidades arbitrarias), ángulo de maniobra
  $R_2 = 0,1309$ rad (cuánto se inclina el eje de spin) y precesión total
  $Phi_f = 0,3327$ rad (cuánto gira el eje alrededor de $bold(H)$ en el
  viaje).
  + *Semiángulo del cono.* Con la relación del triángulo esférico, calculá
    $theta_0$.
  + *Rotación propia en el caso axisimétrico.* Suponé $I_x = I_y = 100$ e
    $I_z = 60$, y los mismos $R_2$ y $Phi_f$. Calculá el giro propio
    acumulado $Delta psi$.
  + *Costo.* Con el giro propio inicial $psi_0 = 0$ y el final $psi_f = Delta
    psi$, calculá el costo $Q_2$.
  + *Eje de polhodia.* Para el cuerpo asimétrico con $psi_0 = -0,2505$ rad
    (nutación hacia adentro), decidí si la polhodia rodea a $z$ o a $x$.
  + *Para pensar.* ¿Por qué el costo no depende de $H$? ¿Qué pasaría si los
    impulsos tuvieran duración finita?
]

#gancho[Es la forma de reorientar un satélite que gira gastando lo mínimo:
en vez de empujar el eje todo el camino, se le da un golpe que lo pone a
precesar en un cono que pasa por la orientación de partida y por la de
llegada, se espera sin gastar nada, y otro golpe lo frena al llegar. Es el
problema A del capítulo usado *al revés*: en vez de preguntar qué movimiento
deja un golpe, se diseña el golpe para que la precesión libre haga el
trabajo. Lo simple: con simetría de revolución, una relación de trigonometría
esférica lo resuelve. Lo complicado: con tres momentos de inercia distintos
el eje nuta, el cono deja de ser circular y casi nunca alcanza con dos
golpes.]

#tipo("A")[
  Golpe y precesión libre, pero de diseño: los impulsos son la incógnita. El
  peso está en W5 (la relación entre el cono y la maniobra), W6 (la geometría
  esférica y la polhodia) y W8 (el costo). W4 casi no tiene cuenta: el
  momento angular lo fija el golpe que uno elige.
]

#duda[Si al final el satélite queda quieto, ¿no se gasta lo mismo que
girándolo de a poco hasta el lugar?]
#dedos[No, y es la gracia. Es tirarle una pelota a un compañero: el gasto
está en el brazo al principio y en las manos que la atajan al final; el vuelo
es gratis. Acá el primer golpe pone al satélite a girar en un cono, el viaje
por el cono lo hace la precesión libre sin propulsor, y el segundo golpe lo
ataja justo cuando el eje llega a destino.]

#W(1)
// simbolos: I_x, I_y, I_z, R_2, Phi_f, theta_0, psi_0, psi_f, Q_2, H
Momentos de inercia principales $I_x = 160$, $I_y = 100$, $I_z = 60$ (el eje de
spin es $z$, el de menor momento: cuerpo alargado); para el caso axisimétrico,
$I_x = I_y = 100$ e $I_z = 60$, o sea, con las letras del Beer, $I' = 100$
(transversal) e $I = 60$ (axial). Maniobra: el eje de spin tiene que
inclinarse $R_2 = 0,1309$ rad ($7,5degree$), con una precesión total
$Phi_f = 0,3327$ rad ($19,1degree$) alrededor de $bold(H)$. Se piden el
semiángulo del cono $theta_0$, el giro propio $Delta psi$, el costo $Q_2$ y de
qué eje es la polhodia.

#W(2)
// simbolos: X, Y, Z, Phi, phi
La terna inercial $X Y Z$ con $Z$ sobre el momento angular $bold(H)$ que deja
el primer golpe, y la del cuerpo, $x y z$, con $z$ sobre el eje de spin.
Ángulos de Euler $z$-$y$-$z$: precesión $Phi$ alrededor de $bold(H)$, nutación
$theta$ (el semiángulo del cono) y spin $psi$. Ojo con las letras: el TN de
Martz llama $psi$ a la precesión y $phi$ al spin, al revés que acá y que el
Beer; el .docx lo avisa.

#W(3)
Entre los dos golpes no actúa nada: $bold(H)$ queda fijo en el espacio y la
energía también. Los golpes son impulsos de duración despreciable (cambian
$bold(H)$ sin que el cuerpo se mueva), el cuerpo es rígido, no hay cuplas
perturbadoras y la maniobra va de reposo a reposo: las hipótesis del TN.

#W(4)
El primer golpe crea un $bold(H)$ de módulo $H$ que forma $theta_0$ con el eje
de spin: componente axial $H cos theta_0$ (spin) y transversal $H sin
theta_0$ (precesión). El segundo golpe lo anula entero. Cuánto vale $H$ lo
elige uno, y en W8 se ve que no importa.

#W(5)
// simbolos: z_0, z_f
Pienso la geometría antes de escribirla: el eje de spin arranca en la
dirección $z_0$ y tiene que terminar en la $z_f$, a $R_2$ de distancia
angular; los dos tienen que
estar sobre el mismo cono de semiángulo $theta_0$ alrededor de $bold(H)$, y el
eje recorre un arco de ese cono que, visto desde $bold(H)$, abarca $Phi_f$. El
triángulo esférico con lados $theta_0$, $theta_0$ y $R_2$ se parte en dos
triángulos rectángulos iguales, y de uno de ellos sale la ec. 5 del TN:
$ sin theta_0 = (sin(R_2 \/ 2))/(sin(Phi_f \/ 2)) $
Para el giro propio, la precesión libre de un axisimétrico (Beer 18.119, con
las letras del Beer): $dot(Phi) = H\/I'$ y $dot(psi) = (I' - I)\/I' thin
omega_z$, con $omega_z = H cos theta_0 \/ I$. Dividiendo, $dot(psi) \/ dot(Phi)
= cos theta_0 (I'\/I - 1)$, constante, y acumulado en toda la maniobra:
// simbolos: Phidot
$ Delta psi = Phi_f cos theta_0 (I'/I - 1) $

#W(6)
*Ejercicio 1.* $sin theta_0 = sin(0,06545)\/sin(0,16635) = 0,395$, así que
$theta_0 = 0,4061$ rad, $23,3degree$. Coincide con el TN. Fijate la
proporción: para inclinar el eje $7,5degree$, el cono se abre $23,3degree$ y el
eje recorre sólo $19,1degree$ de vuelta. Había otras soluciones (conos más
chicos con más vuelta, o más grandes con menos); Martz buscó la de menor costo.

*Ejercicio 2.* $Delta psi = 0,3327 dot.op cos(0,4061) dot.op (100\/60 - 1) =
0,3327 dot.op 0,9187 dot.op 0,667 = 0,204$ rad. Positivo, mismo signo que
$Phi_f$: $I < I'$, cuerpo alargado, precesión *directa*. El spin y la
precesión van para el mismo lado, como en el E1.

*Ejercicio 4, la polhodia.* Con tres momentos distintos, el eje de spin ya no
precesa en un cono circular: nuta. El eje alrededor del cual precesa sólo
puede ser el de momento máximo ($x$, $160$) o el de mínimo ($z$, $60$),
nunca el intermedio, que es inestable (el efecto de la raqueta, el
Dzhanibekov). El criterio del TN compara la energía con el momento angular
escritos con $theta_0$ y $psi_0$:
$ tan^2 theta_0 cos^2 psi_0 = 0,185 dot.op 0,939 = 0,174 quad "contra" quad (I_x (I_y - I_z))/(I_z (I_x - I_y)) = (160 dot.op 40)/(60 dot.op 60) = 1,78 $
Como $0,174 < 1,78$, la polhodia rodea a $z$: el eje de spin precesa
alrededor de $bold(H)$ con nutación, pero sigue siendo él (y no $x$) el que
da vueltas cerca de $bold(H)$.

#W(7)
*Ejercicio 1 por otro camino*, con un caso que se sabe de memoria: el
ejemplo 12.8 del Curtis inclina el eje $90degree$ con media vuelta de
precesión, y dice que el $bold(H)$ intermedio va en la bisectriz, a
$45degree$ de las dos orientaciones. La ec. 5 con $R_2 = 90degree$ y $Phi_f =
180degree$ da $sin theta_0 = sin 45degree \/ sin 90degree$, $theta_0 =
45degree$: la misma bisectriz. *Ejercicio 2 por otro camino*, integrando: con
$H = 1$, la maniobra dura $t_f = Phi_f I'\/H$ y el spin crece a $dot(psi) =
(I' - I)\/I' thin H cos theta_0 \/ I$, con $t_f$ la duración de la maniobra;
// simbolos: t_f
el producto da los mismos $0,204$ rad.

#W(8)
*Ejercicio 3, el costo.* El TN mide el costo como impulso total por tiempo
total, sobre $I_y$, con los propulsores fijos en los ejes del cuerpo (por eso
el impulso transversal se reparte entre dos pares, según $psi$):
$ Q_2 = abs(Phi_f) sin theta_0 (abs(sin psi_0) + abs(cos psi_0) + abs(sin psi_f) + abs(cos psi_f)) + 2 abs(Phi_f) cos theta_0 $
La suma de senos y cosenos vale $0 + 1 + 0,202 + 0,979 = 2,182$; el término
transversal, $0,3327 dot.op 0,395 dot.op 2,182 = 0,287$; el axial, $2 dot.op
0,3327 dot.op 0,9187 = 0,611$. Total, $Q_2 = 0,898$, el «$approx 0,90$» del
.docx.

*Ejercicio 5, para pensar.* El costo no depende de $H$ porque impulso y
tiempo son inversos: un $H$ el doble cuesta el doble de propulsor, pero
precesa el doble de rápido ($dot(Phi) = H\/I'$) y la maniobra dura la mitad.
El producto, $H t_f \/ I' = Phi_f$, sólo depende de la geometría. Con impulsos
de duración finita, el cuerpo se mueve *mientras* se lo empuja: el
$bold(H)$ que queda no es exactamente el buscado, el cono sale corrido y hace
falta más propulsor para corregir; el modelo impulsivo vale si el disparo dura
poco frente al período de precesión.

*Lo que dice el TN de vuelta:* los cuerpos alargados se reorientan más barato
que los achatados; una asimetría de una parte en un millón ya encarece la
maniobra si se exige precisión exacta en el $theta$ y el $psi$ finales; y si
sólo importa adónde apunta el eje de spin (el $psi$ final libre), dos impulsos
alcanzan siempre, para cualquier distribución de inercia.

#final[$theta_0 = 0,4061$ rad ($23,3degree$); $Delta psi = 0,204$ rad (directa:
$I < I'$); $Q_2 = 0,898$; la polhodia rodea a $z$ ($0,174 < 1,78$). El costo no
depende de $H$ porque impulso y tiempo de maniobra son inversamente
proporcionales.]

#oral(
  ([¿Entre los dos impulsos se gasta algo?], [No: no hay cupla, $bold(H)$ está fijo y la precesión libre lleva el eje de un lugar al otro gratis.]),
  ([¿Por qué un cuerpo asimétrico complica la maniobra?], [Porque $theta$ deja de ser constante: el eje nuta mientras precesa, el cono no es circular y casi nunca cierra con dos golpes.]),
  ([¿Puede el eje de spin ser el de momento intermedio?], [No: la rotación alrededor del intermedio es inestable. La polhodia rodea al de máximo o al de mínimo.]),
  ([¿Por qué el Curtis pone $bold(H)$ en la bisectriz?], [Porque las dos orientaciones tienen que estar sobre el mismo cono: equidistantes de $bold(H)$. Con media vuelta de precesión, el eje pasa de una a la otra.]),
)

// =====================================================================
= E6 — El CMG con números: salida, saturación y desaturación

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Armado con los números del apunte de clase «El CMG como actuador de actitud» (noviembre de 2026, subido el 15/11), que no trae ejercicios: secciones 3, 4, 10, 11 y 12, y la animación `desaturacion_cmg_compensa.gif` (sus cuadros son las figuras 6 a 9 del apunte). La teoría completa, en la guía del parcialito de CMG (`resumen-cmg`, secciones 3 a 6): acá no se repite.]
  // simbolos: h, uhat, J, k
  + La ISS lleva CMG de $4760$ N·m·s que entregan hasta $258$ N·m. ¿A qué
    velocidad gira el cardán para dar esa cupla? Si los rodamientos están a
    $0,5$ m, ¿qué fuerza lateral aguanta cada uno? ¿Cuánto momento angular
    pueden guardar los cuatro?
  + El CMG 15-45S de Airbus guarda $15$ N·m·s y entrega $45$ N·m. ¿A qué
    velocidad gira su cardán?
  + Un par de CMG «en tijera» (dos rotores de momento $h$, abiertos un ángulo
    $theta$ a cada lado de un versor $hat(u)$) está saturado según $hat(u)$ en
    una nave quieta de momento de inercia $J = 4$ (en unidades de $h$·s). Se
    descarga con propulsores que le dan a la nave la cupla $-k hat(u)$, con $k
    = 0,25$ (en unidades de $h$/s), durante $8$ s. ¿Cómo tienen que moverse los cardanes
    para que la nave no se mueva? ¿Qué pasa al principio? ¿Y si los cardanes
    quedan trabados?
]

#gancho[Es el actuador de las estaciones espaciales y de los satélites ágiles
de observación, y este ejercicio le pone números a sus tres caras: cuánta
cupla saca girando un cardán despacio (la amplificación), cuánto momento
angular puede guardar antes de llenarse (la saturación) y cómo se lo vacía
sin que la nave se mueva (la desaturación). Lo simple: una sola fórmula,
cupla igual a momento angular por velocidad del cardán. Lo complicado: que la
dirección de esa cupla gira con el cardán, y que justo cuando está lleno no
puede empujar para donde hace falta.]

#tipo("E")[
  Partes que se mueven entre sí: el rotor dentro del cardán dentro de la nave.
  El peso está en W3 (qué es interno y qué externo: el CMG reparte, el
  propulsor saca), W5 (la cupla de salida) y W6 (la dirección de salida y la
  singularidad).
]

#duda[Si el CMG es una rueda que gira siempre igual, ¿de dónde sale la
cupla? ¿Y por qué no puede vaciarse solo?]
#dedos[Sale de *doblar* su momento angular, no de frenarlo: el motor del
cardán inclina un vector grande, y lo que hace falta para inclinarlo lo ponen
los rodamientos, empujando de costado; la nave recibe lo opuesto. Y no se
vacía solo porque todo lo que pasa adentro de la nave reparte el momento
angular entre sus piezas sin sacarlo. Dos personas con una rueda de bici cada
una, las dos apuntando para adelante: si abren los brazos en V, la suma
«para adelante» baja, pero lo que perdieron las ruedas lo ganó el bote en el
que están parados, si nadie de afuera se lo saca.]

#W(1)
// simbolos: h, tau, deltadot, F, L, J, k, uhat, theta
*ISS:* momento angular de cada rotor $h = 4760$ N·m·s, cupla máxima $tau =
258$ N·m, rodamientos separados $L = 0,5$ m, cuatro CMG. *Airbus:* $h = 15$
N·m·s, $tau = 45$ N·m. *Desaturación:* dos rotores de momento $h$, abiertos
$theta$ respecto de $hat(u)$; nave de $J = 4 h$·s, quieta; propulsores con $k
= 0,25 h$/s durante $8$ s. Se piden la velocidad del cardán $dot(delta)$, la
fuerza en los rodamientos $F$, la capacidad, la ley $theta (t)$ y qué pasa con
los cardanes trabados.

#W(2)
// simbolos: hhat, ghat, that, vhat, what
Los tres ejes del apunte de clase, que forman una terna derecha: spin del rotor
$hat(h)$, cardán $hat(g)$ (fijo a la nave) y salida $hat(t) = hat(g) times
hat(h)$. Para la tijera, $hat(u)$ es la dirección que se descarga, $hat(v)$
otra en el plano de los rotores, y $hat(w) = hat(u) times hat(v)$ el eje común
de los dos cardanes. Las direcciones de spin de los dos rotores:
// simbolos: hhat_1, hhat_2
$hat(h)_1 = cos theta hat(u) + sin theta hat(v)$ y $hat(h)_2 = cos theta
hat(u) - sin theta hat(v)$; el primero gira $+theta$ alrededor de $hat(w)$, el
segundo $-theta$.

#W(3)
*Interno:* el CMG le cambia el momento angular a la nave sólo pasándole el
suyo; el total no cambia. *Externo:* los propulsores. Así que con propulsores
prendidos, el momento angular total (nave más CMG) cae al ritmo de su cupla,
// simbolos: H_tot
$dif bold(H)_"tot" \/ dif t = -k hat(u)$, y lo único que se decide adentro es *de quién* sale lo que se pierde:
del CMG o de la nave. Supuestos: rotor a velocidad constante, cardán de
inercia despreciable, sin cuplas del ambiente durante la descarga.

#W(4)
Lo que guarda la tijera sobre $hat(u)$ es la suma de las dos componentes del
momento angular de los rotores,
// simbolos: h_CMG
$bold(h)_"CMG" dot.op hat(u) = 2 h cos theta$: con $theta = 0$, los dos
rotores juntos, $2 h$, saturado; con $theta = 90degree$, opuestos, cero. La
nave guarda $J omega$. Al principio, $H_"tot" = 2 h$, todo en el CMG.

#W(5)
La cupla de salida: el rotor es un vector de módulo fijo $h$ que gira con el
cardán a $dot(delta)$; su derivada es módulo por velocidad de giro, sobre
$hat(t)$, y la nave recibe la opuesta, $bold(tau)_"sat"$:
// simbolos: tau_sat
$ bold(tau)_"sat" = -h dot(delta) hat(t), quad abs(bold(tau)_"sat") = h dot(delta) $
*ISS:* $dot(delta) = tau\/h = 258 \/ 4760 = 0,054$ rad/s, unos $3,1degree$/s:
despacito. El par de los rodamientos es esa cupla: $F = tau\/L = 516$ N de
costado en cada uno (el «unos $500$ N» del apunte), y es por eso que las fallas
de los CMG de la ISS fueron de rodamientos. Los cuatro guardan $4 dot.op 4760 =
19 thin 040$ N·m·s. *Airbus:* $dot(delta) = 45\/15 = 3$ rad/s, $172degree$/s:
el chico saca su cupla girando el cardán rápido. *Amplificación:* con
$dot(delta)$ constante el motor no necesita cupla y la salida igual es $h
dot(delta)$; el ejemplo del apunte, $h = 100$ N·m·s a $1$ rad/s, da $100$
N·m.

#W(6)
*La tijera, componente a componente.* Pienso las salidas de cada rotor
($i = 1, 2$): $hat(t)_i = hat(w) times hat(h)_i$, y como $hat(w) times hat(u)
= hat(v)$ y $hat(w) times hat(v) = -hat(u)$,
// simbolos: that_i, hhat_i, i, that_1, that_2
$ hat(t)_1 = cos theta hat(v) - sin theta hat(u), quad hat(t)_2 = cos theta hat(v) + sin theta hat(u) $
Las velocidades de los dos cardanes son $dot(delta)_1 = dot(theta)$ y
$dot(delta)_2 = -dot(theta)$, con $dot(theta)$ la velocidad con que se abren
las tijeras; la cupla sobre la nave es
// simbolos: deltadot_1, deltadot_2, thetadot
$ bold(tau)_"sat" = -h dot(theta) hat(t)_1 + h dot(theta) hat(t)_2 = 2 h sin theta thin dot(theta) thin hat(u) $
Lo de $hat(v)$ se cancela entre los dos, y lo de $hat(u)$ empuja a la nave
para $+hat(u)$, justo contra los propulsores. Para que la nave no se mueva,
$2 h sin theta thin dot(theta) = k$: los cardanes se abren con
$dot(theta) = k\/(2 h sin theta)$. En los números del ejercicio, $dot(theta) =
0,125\/sin theta$ rad/s: $0,125$ rad/s con $theta = 90degree$, $0,483$ rad/s
con $theta = 15degree$, $1,43$ rad/s con $theta = 5degree$, e *infinito* con
$theta = 0$. Ahí está la singularidad: con los dos rotores sobre $hat(u)$, las
dos salidas $hat(t)_i$ quedan sobre $hat(v)$, perpendiculares a la dirección
que se quiere descargar, y ningún giro de cardán da cupla sobre $hat(u)$.

#figure(fig-act-cmg-singular, caption: text(size: 9pt)[Dos CMG sobre el mismo
eje de cardán, de la biblioteca del apunte: es la tijera de este ejercicio.
Paralelos, es el arranque saturado ($theta = 0$); antiparalelos, el final
descargado ($theta = 90degree$), singular para $hat(v)$ pero no para $hat(u)$,
que es la que se descargó; abiertos, cualquier instante del medio.])

#W(7)
Otro camino para la ley de la tijera: sin cupla en la nave, todo lo que pierde
el total sale del CMG, $2 h cos theta (t) = 2 h - k t$, o sea $cos theta (t) =
1 - t\/8$. A los $8$ s, $cos theta = 0$: $theta = 90degree$, los rotores
opuestos, el CMG vacío y la nave quieta, como la figura 8 del apunte. Derivando
esa ley se recupera $dot(theta) = k\/(2 h sin theta)$, el mismo resultado del
paso anterior. Y con ella, idealmente, la tijera llegaría a $15degree$ a los
$0,27$ s; en la simulación llega recién a los $2,4$ s (figura 6), porque cerca
de $theta = 0$ los cardanes no pueden ir a la velocidad que haría falta: en
ese rato la nave se desvía (unos $5degree$ como máximo, dice el apunte). Por
eso en la práctica se descarga *antes* de llegar al borde.

#W(8)
*Con los cardanes trabados* ($dot(theta) = 0$), los propulsores sacan igual
$2 h$ del total en $8$ s, pero no del CMG: de la nave. $J omega = -2 h$, así
que $omega = -0,5$ rad/s, $-28,6degree$/s, el «$-28,66degree$/s» del cuadro de
la animación: el total llegó a cero, el CMG sigue saturado y la nave queda
girando al revés. Desaturar no es sacar momento angular: es coordinar que
salga *del CMG* y no de la nave. Y una cuenta de borde para el «opine»: la
velocidad máxima de maniobra es la capacidad sobre la inercia, $2 h \/ J =
0,5$ rad/s en este modelo; el torque limita la aceleración, la capacidad
limita la velocidad.

#final[ISS: $dot(delta) = 0,054$ rad/s, $516$ N por rodamiento, $19 thin 040$
N·m·s los cuatro. Airbus: $3$ rad/s. Tijera: $dot(theta) = k\/(2 h sin
theta)$, infinita en $theta = 0$ (singularidad); final en $90degree$ con la
nave quieta. Trabada: $omega = -0,5$ rad/s y el CMG sigue lleno.]

#oral(
  ([¿Por qué el motor del cardán no hace la cupla de salida?], [Porque la salida es perpendicular al eje del cardán, y un motor sólo hace cupla sobre su propio eje. La hacen los rodamientos, de costado.]),
  ([¿Qué diferencia hay entre saturarse una rueda y saturarse un CMG?], [La rueda llega a su velocidad máxima; el CMG sigue a velocidad nominal pero ya tiene su momento angular apuntando todo lo posible en la dirección pedida: se satura por geometría.]),
  ([¿Puede el CMG descargarse girando los cardanes para el otro lado?], [No: eso sólo pasa el momento angular a la nave. Hace falta una cupla externa (propulsores, magnetorquers).]),
  ([¿Por qué la descarga es lenta al principio?], [Porque saturado está en una singularidad: las salidas son perpendiculares a la dirección a descargar y el torque sobre $hat(u)$ crece con $sin theta$, que arranca en cero.]),
)
