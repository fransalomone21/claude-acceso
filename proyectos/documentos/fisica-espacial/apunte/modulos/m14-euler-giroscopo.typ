#import "../plantilla.typ": *

#modulo("Ecuaciones de Euler y el giróscopo")[
  Derivar $bold(H)_G$ respecto del tiempo —con la herramienta del módulo 12 y
  el tensor del módulo 13— para llegar a las ecuaciones de Euler, y usarlas
  para entender el efecto que ya se vio *sin* dinámica en los dos ejemplos
  cinemáticos del módulo 12: por qué un giróscopo responde a una cupla
  precesando, no acelerando en la dirección que el sentido común esperaría.
]

El módulo 13 calculó $bold(H)_G$ en un instante. Para llegar a la dinámica
—qué cupla hace falta para *sostener* un movimiento, o qué movimiento produce
una cupla dada— hace falta $d bold(H)_G \/ d t$, y ésa es exactamente la
@m12-derivada del módulo 12 aplicada a $bold(H)_G$ en vez de a un vector
cualquiera.

== La derivada de $bold(H)_G$: la @m12-derivada, por fin en uso

#deduccion("de dónde sale la relación general entre cupla y H")[
  La segunda ley de Newton para rotación, $sum bold(M)_G = dot(bold(H))_G$,
  pide la derivada de $bold(H)_G$ *respecto del espacio fijo*. Pero
  $bold(H)_G$ sólo tiene componentes simples —las de la @m13-diagonal— en
  ejes que en cada instante son principales del cuerpo, y esos ejes en
  general están girando. La @m12-derivada, con $bold(Omega)$ la velocidad
  angular de *esos ejes* (no necesariamente la del cuerpo), resuelve
  exactamente esa tensión:
  $ dot(bold(H))_G = (dot(bold(H))_G)_(O x y z) + bold(Omega) times bold(H)_G $
  <m14-derivada-h>
  (Beer ecs. 18.22 y 18.23, pág. 1169–1170; la misma relación vale para
  $bold(H)_O$ de un cuerpo con un punto fijo, ecs. 18.27 y 18.28, pág.
  1171–1172, cambiando $G$ por $O$.) El primer término es la derivada
  *tratando a los ejes como fijos* —lo que cambian $I_x omega_x$, etc., si
  no fueran cíclicos entre sí— y el segundo es el precio de que los ejes
  giren, exactamente como en cualquier otra aplicación de la @m12-derivada.
]

$ (bold(Omega) times bold(H))_x = Omega_y H_z - Omega_z H_y, quad
  (bold(Omega) times bold(H))_y = Omega_z H_x - Omega_x H_z, quad
  (bold(Omega) times bold(H))_z = Omega_x H_y - Omega_y H_x $

#geometria[
  *Qué ejes elegir es una decisión, no un dato del problema —y la decisión
  correcta ya se discutió en el módulo 12.* Hay dos caminos:

  - *Clavar los ejes al cuerpo*, $bold(Omega) = bold(omega)$. Los tres
    momentos de inercia quedan constantes por definición —los ejes giran
    exactamente con la masa— y de ahí salen las *ecuaciones de Euler*
    clásicas, de la sección siguiente.
  - *Elegir ejes que acompañan sólo la simetría del cuerpo, sin girar con
    él* —$bold(Omega) != bold(omega)$—, la salida que el módulo 12 ya
    recomendaba (pág. 1170) para un cuerpo con eje de revolución: los
    momentos de inercia siguen siendo constantes igual —cualquier eje
    transversal de un cuerpo de revolución es principal—, y la cuenta se
    simplifica porque no hace falta seguir el espín, que suele ser la
    componente más grande y la menos interesante.

  Los dos ejemplos de este módulo son del segundo tipo: en los dos hay una
  pieza que gira rápido *relativa* a un armazón —el disco relativo a la
  horquilla, el volante relativo al gimbal— y los ejes se clavan al armazón,
  no a la pieza.
]

== Las ecuaciones de Euler ($bold(Omega) = bold(omega)$, ejes clavados al cuerpo)

Si los ejes giran exactamente con el cuerpo, $(dot(bold(H))_G)_(O x y z) =
I_x dot(omega)_x hat(i) + I_y dot(omega)_y hat(j) + I_z dot(omega)_z hat(k)$
—los tres momentos son constantes— y la @m14-derivada-h, componente a
componente con la fórmula de arriba, da

$ sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z $
$ sum M_y = I_y dot(omega)_y - (I_z - I_x) omega_z omega_x $
$ sum M_z = I_z dot(omega)_z - (I_x - I_y) omega_x omega_y $
<m14-euler-clasicas>

(Beer ec. 18.25, pág. 1170.) Son *las* ecuaciones de Euler: tres ecuaciones
diferenciales acopladas y no lineales —cada una tiene un producto de las
otras dos velocidades— que valen para *cualquier* cuerpo rígido, en los ejes
principales que lo acompañan. Los dos ejemplos de este módulo no las usan
directamente —eligen $bold(Omega) != bold(omega)$—, pero son la forma que
tiene el nombre «ecuaciones de Euler», y el módulo 15 vuelve a ellas para la
peonza simétrica.

#guia("qué ejercicios cubre este módulo")[
  El punto 2 del Problema 2 (la cupla que sostiene al disco de la horquilla)
  y el Problema 3 completo (el volante en el gimbal). Los ángulos de Euler y
  la precesión estable de las dos últimas secciones no tienen ejercicio
  propio en este módulo: son la herramienta que el módulo 15 aplica a los
  Problemas 4 y 6.
]

#ejemplo("El disco en la horquilla: la cupla que sostiene el movimiento")[
  _(Problema 2, punto 2, de la sección de cuerpo rígido: $d bold(H)_G \/ d
  t$, continuando el ejemplo del módulo 13.)_ Con $bold(H)_G = 1/4 m r^2
  omega_2 hat(j) + 1/2 m r^2 omega_1 hat(k)$ (módulo 13) y $bold(Omega) =
  omega_2 hat(j)$ —los ejes están clavados a la horquilla, no al disco, y
  $omega_1$, $omega_2$ son constantes—, la @m14-derivada-h se reduce a un solo
  término: el primero es cero porque las componentes de $bold(H)_G$ en esta
  base no cambian.
  $ dot(bold(H))_G = bold(Omega) times bold(H)_G
    = omega_2 hat(j) times (1/4 m r^2 omega_2 hat(j) + 1/2 m r^2 omega_1 hat(k))
    = 1/2 m r^2 omega_1 omega_2 hat(i) $

  #clave[
    *La cupla necesaria apunta exactamente donde el módulo 12 encontró
    $bold(alpha)$.* Con $sum bold(M)_G = dot(bold(H))_G$, sostener este
    movimiento —los dos giros constantes, para siempre— exige una cupla
    $1/2 m r^2 omega_1 omega_2$ sobre $hat(i)$: la misma dirección que
    $bold(alpha) = omega_1 omega_2 hat(i)$ del módulo 12 (ahí para el
    volante del Problema 3, acá para el disco, pero el mecanismo es
    idéntico). No es casualidad: es la cupla giroscópica que el módulo 12 ya
    había señalado sin poder calcularla, porque todavía no existía el tensor
    de inercia.
  ]
]

#ejemplo("El volante en el gimbal: por qué 600 N·m dan sólo 20 rad/s²", nivel: "a fondo")[
  _(Problema 3 completo. Retoma el ejemplo del módulo 12: volante con
  $I_x=I_y=5$, $I_z=10$ kg$dot.op$m², girando a $omega_s = 100$ rad/s sobre
  $hat(k)$, montado en un gimbal sin peso sobre una plataforma que gira a
  $omega_p = 0,5$ rad/s sobre $hat(j)$. El gimbal arranca quieto respecto de
  la plataforma. Pide la aceleración angular del gimbal cuando el torquer
  aplica $600$ N$dot.op$m sobre $hat(i)$.)_

  *Los ejes y el punto fijo.* $hat(i), hat(j), hat(k)$ están clavados al
  *gimbal* —no al volante, que gira relativo a él—, con origen $O$ en el
  centro del volante, fijo en el espacio porque ahí se cruzan los dos
  pivotes. El gimbal sin peso no tiene inercia propia: toda la masa del
  sistema es la del volante, así que $bold(H)_O$ del volante es el
  $bold(H)_O$ de todo el sistema, y la única cupla externa relevante es la
  del torquer.

  *La velocidad angular de los ejes vs. la del volante.* El gimbal gira con
  la plataforma sobre $hat(j)$ y, cuando el torquer actúa, empieza a girar
  *relativo* a la plataforma sobre $hat(i)$ —ésa es la variable que se busca:
  $ bold(Omega) = Omega_x hat(i) + omega_p hat(j), quad quad
    bold(omega) = Omega_x hat(i) + omega_p hat(j) + omega_s hat(k) $
  con $Omega_x = 0$ en el instante inicial (el gimbal «arranca quieto»,
  pero *su derivada* $dot(Omega)_x$ es justo lo que se pide).

  *El momento angular.* $hat(i), hat(j), hat(k)$ son principales del volante
  en todo instante (por su simetría de revolución sobre $hat(k)$), así que
  con la @m13-diagonal:
  $ bold(H)_O = I_x Omega_x hat(i) + I_y omega_p hat(j) + I_z omega_s hat(k)
    = 5 Omega_x hat(i) + 2,5 hat(j) + 1000 hat(k) " kg" dot.op "m"^2\/"s" $
  que en el instante inicial ($Omega_x = 0$) es $bold(H)_O = 2,5 hat(j) +
  1000 hat(k)$.

  *La ecuación de momento, componente $x$.* Con la @m14-derivada-h y la
  fórmula de componentes de más arriba:
  $ sum M_x = (dot(H)_O)_(O x y z, x) + (Omega_y H_z - Omega_z H_y)
    = I_x dot(Omega)_x + omega_p (I_z omega_s) - 0
    = 5 dot(Omega)_x + (0,5)(1000) $
  $ 600 = 5 dot(Omega)_x + 500 ==> dot(Omega)_x = 20 " rad/s"^2 $

  #clave[
    *De los $600$ N$dot.op$m aplicados, $500$ se van en sostener la
    dirección de $bold(H)_O$ y sólo $100$ aceleran el gimbal.* El término
    $Omega_y H_z = omega_p I_z omega_s$ no depende de $Omega_x$: es la cupla
    que hace falta *sólo* para que $bold(H)_O$ —dominado por el término
    $I_z omega_s = 1000$, enorme frente a $I_x Omega_x$— gire junto con la
    plataforma sin cambiar de módulo, incluso si el gimbal no acelerara nada.
    Dividir cupla por inercia, $600\/5 = 120$ rad/s², ignora ese término y da
    seis veces más de lo que en realidad acelera al gimbal. Es la misma
    «rigidez giroscópica» que hace que un giróscopo resista a que le cambien
    el eje: buena parte de la cupla aplicada se gasta en seguirle el ritmo a
    un $bold(H)$ grande, no en acelerar nada.
  ]
]

== Los ángulos de Euler: cómo describir la orientación de un giróscopo

Para un cuerpo con un punto fijo $O$ y un eje de simetría —el caso del
giróscopo—, tres ángulos alcanzan para describir su orientación en cualquier
instante (Beer §18.9, fig. 18.15, pág. 1187):

#definicion("ángulos de Euler")[
  Partiendo de un eje fijo $Z$ y el eje de simetría $z$ del cuerpo, en $O$:
  - *$phi$, la precesión*: el ángulo, medido en el plano $X Y$ fijo, de una
    recta llamada *línea de nodos* —la intersección entre el plano $X Y$ y
    el plano perpendicular a $z$ que pasa por $O$.
  - *$theta$, la nutación*: el ángulo entre $Z$ y $z$.
  - *$psi$, el giro (o *spin*)*: el ángulo, medido en el plano perpendicular
    a $z$, entre la línea de nodos y un eje $x$ solidario al cuerpo.

  Los tres son independientes y alcanzan porque el cuerpo tiene simetría de
  revolución: girarlo sobre su propio eje $z$ un ángulo $psi$ no cambia nada
  que $theta$ y $phi$ no describan ya.
]

Los ejes naturales para escribir $bold(omega)$ son los que giran con $phi$ y
$theta$ pero *no* con $psi$ —el segundo camino de la sección anterior,
$bold(Omega) != bold(omega)$—, porque son principales del cuerpo (uno de
ellos es $z$, el eje de simetría) sin tener que seguir el espín:

$ bold(Omega) = dot(phi) sin theta thin hat(e) + dot(theta) hat(f) + dot(phi) cos theta thin hat(k),
  quad quad bold(omega) = bold(Omega) + dot(psi) hat(k) $

(Beer ecs. 18.35 a 18.38, pág. 1187–1188; $hat(e)$ es la línea de nodos y
$hat(f) = hat(k) times hat(e)$.) Con $I$ el momento de inercia transversal
—sobre $hat(e)$ o $hat(f)$— e $I'$ el momento sobre el eje de simetría $z$,
$bold(H)_O = I Omega_e hat(e) + I Omega_f hat(f) + I' omega_z hat(k)$, y las
tres componentes de $sum bold(M)_O = dot(bold(H))_O$ dan las tres ecuaciones
diferenciales del giróscopo (Beer ec. 18.39, pág. 1188), cuya solución general
no es elemental. *Se citan porque son las que hay que resolver en el caso
general* —el módulo no las resuelve enteras: la sección siguiente resuelve el
caso particular que sí tiene solución simple.

== Precesión estable: el caso que sí se resuelve a mano

#deduccion("de dónde sale la cupla que sostiene una precesión constante")[
  *Precesión estable* es el caso en que $theta$, $dot(phi)$ y $dot(psi)$ son
  las tres constantes: el eje $z$ barre un cono perfecto alrededor de $Z$, a
  velocidad angular y ángulo de apertura fijos. Entonces $dot(theta) = 0$ y
  $bold(Omega) = dot(phi) sin theta thin hat(e) + dot(phi) cos theta thin
  hat(k)$ es constante en el tiempo *dentro* de la base $(hat(e), hat(f),
  hat(k))$ que gira con ella —su módulo y su ángulo con $hat(k)$ no cambian—,
  así que $bold(H)_O$ también tiene componentes constantes en esa base:
  $ bold(H)_O = I dot(phi) sin theta thin hat(e) + I' (dot(phi) cos theta +
    dot(psi)) hat(k) $
  y el primer término de la @m14-derivada-h se anula. Queda sólo
  $bold(Omega) times bold(H)_O$, con $bold(Omega)$ y $bold(H)_O$ los de
  arriba y usando $hat(e) times hat(k) = -hat(f)$:
  $ sum bold(M)_O = dot(phi) sin theta thin [ (I - I') dot(phi) cos theta -
    I' dot(psi) ] thin hat(f) $
]

$ sum bold(M)_O = dot(phi) sin theta thin [ I' dot(psi) + (I - I') dot(phi)
  cos theta ] thin hat(f) $ <m14-precesion-estable>

(Beer ecs. 18.40 a 18.44, pág. 1189; con el signo que da $hat(e) times hat(k)$
según la orientación elegida.) *La cupla necesaria es perpendicular al plano
que forman $Z$ y $z$* —sobre $hat(f)$, la línea de nodos girada $90degree$—,
nunca dentro de ese plano: es la traducción formal de que un giróscopo no
«cae» en la dirección de la cupla aplicada, sino que precesa perpendicular a
ella.

#cuidado[
  *Caso particular, $theta = 90degree$: el eje de simetría queda siempre
  perpendicular a $Z$.* Ahí $sin theta = 1$, $cos theta = 0$, y la
  @m14-precesion-estable se reduce a
  $ sum bold(M)_O = I' dot(phi) dot(psi) thin hat(f) $ <m14-precesion-90>
  (Beer ec. 18.45, pág. 1189.) Es la forma más simple de toda la sección —el
  producto de las dos velocidades angulares por el momento de inercia axial,
  sin ningún coseno— y el mismo mecanismo, con otra letra para cada
  velocidad, que ya apareció dos veces en este módulo: $bold(alpha) =
  omega_1 omega_2 hat(i)$ en el módulo 12 y $dot(bold(H))_G = 1/2 m r^2
  omega_1 omega_2 hat(i)$ en el primer ejemplo de hoy.
]

== Lo que se usa después

1. *La @m14-derivada-h, con $bold(Omega) != bold(omega)$.* Es la herramienta
   entera de la Parte IV a partir de acá: cada vez que un cuerpo tiene un eje
   de simetría rápido —un volante, una peonza, un satélite estabilizado por
   giro—, conviene elegir ejes que sigan la precesión y no el espín.

2. *Los ángulos de Euler y la notación $I$, $I'$.* El módulo 15 los usa tal
   cual, con el cuerpo simétrico *sin* cuplas externas —$sum bold(M)_O = 0$—
   como el caso especial que sigue.

3. *La @m14-precesion-estable y su caso particular.* La versión sin cuplas
   ($sum bold(M)_O = 0$) es la que resuelve la peonza libre del módulo 15:
   ahí la ecuación no dice cuánta cupla hace falta, sino qué relación entre
   $theta$, $dot(phi)$ y $dot(psi)$ hace que la precesión sea estable *sola*.
