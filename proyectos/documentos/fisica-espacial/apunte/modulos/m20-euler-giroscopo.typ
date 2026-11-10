#import "../plantilla.typ": *
#import "../biblioteca/figuras-euler.typ": fig-euler-angulos, fig-euler-cardanes, fig-euler-efk, fig-euler-bloqueo, fig-precesion-estable, fig-dos-raices, fig-ladrillo-ejes, fig-explorer
// voz: 2026-09-25 -- pasada de la fase 11, tanda (d)

#modulo("Ecuaciones de Euler y el giróscopo", clave: "euler-giroscopo")[
  Derivar $bold(H)_G$ respecto del tiempo —con la herramienta del módulo #M("cinematica-cr") y
  el tensor del módulo #M("inercia")— para llegar a las ecuaciones de Euler, y usarlas
  para entender el efecto que ya se vio *sin* dinámica en los dos ejemplos
  cinemáticos del módulo #M("cinematica-cr"): por qué un giróscopo responde a una cupla
  precesando, no acelerando en la dirección que el sentido común esperaría.
]

El módulo #M("inercia") calculó $bold(H)_G$ en un instante. Para llegar a la dinámica
—qué cupla hace falta para *sostener* un movimiento, o qué movimiento produce
una cupla dada— hace falta $d bold(H)_G \/ d t$, y ésa es exactamente la
@cin-derivada del módulo #M("cinematica-cr") aplicada a $bold(H)_G$ en vez de a un vector
cualquiera. Dos módulos de preparación para una sola línea: es el tipo de
inversión que en el momento parece un despilfarro y al final del módulo
resulta barata.

#lectura[
  *Beer, Dinámica, capítulo 18* («Cinética de cuerpos rígidos en tres
  dimensiones»), §18.6 («Ecuaciones de movimiento de Euler», pág. 1170) y
  §18.9 («Movimiento de un giroscopio. Ángulos de Euler», pág. 1187).
  *Roederer, capítulo 5*, §5.g («Giróscopo y trompo», pág. 189), para la misma
  precesión con menos aparato matemático.

  Beer es la fuente de las ecuaciones y de la notación de este módulo —ya
  citada en el cuerpo—; Roederer sirve para una segunda lectura más corta,
  sin el tensor completo, si alcanza con la idea física. Para la aplicación a
  satélites (volantes, CMG, regla del eje mayor), las diapositivas de control
  de actitud de la Universidad de Sevilla que subió la cátedra el 19/10 (R.
  Vázquez, *Introduction to Attitude Dynamics*, 2021): catorce, sin una
  ecuación, y se leen en diez minutos.
]

== La derivada de $bold(H)_G$: la @cin-derivada, por fin en uso

#deduccion("de dónde sale la relación general entre cupla y H")[
  La segunda ley de Newton para rotación, $sum bold(M)_G = dot(bold(H))_G$,
  pide la derivada de $bold(H)_G$ *respecto del espacio fijo*. Pero
  $bold(H)_G$ sólo tiene componentes simples —las de la @iner-diagonal— en
  ejes que en cada instante son principales del cuerpo, y esos ejes en
  general están girando. La @cin-derivada, con $bold(Omega)$ la velocidad
  angular de *esos ejes* (no necesariamente la del cuerpo), resuelve
  exactamente esa tensión:
  $ dot(bold(H))_G = (dot(bold(H))_G)_(O x y z) + bold(Omega) times bold(H)_G $
  <euler-derivada-h>
  (Beer §18.5, ecs. 18.22 y 18.23, pág. 1169–1170 —las que la lista de la
  cátedra marca con «ver comentario posterior»; lo que el Beer comenta
  después, en el último párrafo de §18.5, es la opción de ejes que giran
  menos que el cuerpo, que está acá abajo—; la misma relación vale para
  $bold(H)_O$ de un cuerpo con un punto fijo, ecs. 18.27 y 18.28, pág.
  1171–1172, cambiando $G$ por $O$.) El primer término es la derivada
  *tratando a los ejes como fijos* —lo que cambian $I_x omega_x$, etc., si
  no fueran cíclicos entre sí— y el segundo es el precio de que los ejes
  giren, exactamente como en cualquier otra aplicación de la @cin-derivada.
]

$ (bold(Omega) times bold(H))_x = Omega_y H_z - Omega_z H_y, quad
  (bold(Omega) times bold(H))_y = Omega_z H_x - Omega_x H_z, quad
  (bold(Omega) times bold(H))_z = Omega_x H_y - Omega_y H_x $

#geometria[
  *Qué ejes elegir es una decisión, no un dato del problema —y la decisión
  correcta ya se discutió en el módulo #M("cinematica-cr").* Hay dos caminos:

  - *Clavar los ejes al cuerpo*, $bold(Omega) = bold(omega)$. Los tres
    momentos de inercia quedan constantes por definición —los ejes giran
    exactamente con la masa— y de ahí salen las *ecuaciones de Euler*
    clásicas, de la sección siguiente.
  - *Elegir ejes que acompañan sólo la simetría del cuerpo, sin girar con
    él* —$bold(Omega) != bold(omega)$—, la salida que el módulo #M("cinematica-cr") ya
    recomendaba (Beer §18.5, último párrafo, pág. 1170) para un cuerpo con eje de revolución: los
    momentos de inercia siguen siendo constantes igual —cualquier eje
    transversal de un cuerpo de revolución es principal—, y la cuenta se
    simplifica porque no hace falta seguir el espín, que suele ser la
    componente más grande y la menos interesante.

  Los dos ejemplos de este módulo son del segundo tipo: en los dos hay una
  pieza que gira rápido *relativa* a un armazón —el disco relativo a la
  horquilla, el volante relativo al gimbal— y los ejes se clavan al armazón,
  no a la pieza. Clavarlos a la pieza es posible y es masoquismo: se paga con
  senos y cosenos de un ángulo que da cien vueltas por segundo, para
  terminar en el mismo resultado.
]

#posta[
  Los ejes los elegís vos, y la derivada te cobra lo que giran: cuanto más
  giran, más largo el término $bold(Omega) times bold(H)$. Entonces se
  eligen ejes que giren lo menos posible sin dejar de ver al cuerpo siempre
  igual. Si el cuerpo es redondo alrededor de un eje, el giro alrededor de
  ese eje no hace falta seguirlo: el cuerpo se ve igual gire o no.
]

== Las ecuaciones de Euler ($bold(Omega) = bold(omega)$, ejes clavados al cuerpo)

Si los ejes giran exactamente con el cuerpo, $(dot(bold(H))_G)_(O x y z) =
I_x dot(omega)_x hat(i) + I_y dot(omega)_y hat(j) + I_z dot(omega)_z hat(k)$
—los tres momentos son constantes— y la @euler-derivada-h, componente a
componente con la fórmula de arriba, da

$ sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z $
$ sum M_y = I_y dot(omega)_y - (I_z - I_x) omega_z omega_x $
$ sum M_z = I_z dot(omega)_z - (I_x - I_y) omega_x omega_y $
<euler-euler-clasicas>

(Beer §18.6, ec. 18.25, pág. 1170.) Son *las* ecuaciones de Euler: tres ecuaciones
diferenciales acopladas y no lineales —cada una tiene un producto de las
otras dos velocidades— que valen para *cualquier* cuerpo rígido, en los ejes
principales que lo acompañan. Los dos ejemplos de este módulo no las usan
directamente —eligen $bold(Omega) != bold(omega)$—, pero son la forma que
tiene el nombre «ecuaciones de Euler», y el módulo #M("peonza") vuelve a ellas para la
peonza simétrica. Son, además, el lugar donde el apunte deja de poder
resolver todo a mano: tres ecuaciones acopladas y no lineales no se
despejan en un renglón, y quien diga lo contrario tiene un caso particular
escondido en la manga.

#cuidado[
  *La errata de la hoja de Aníbal.* En la primera hoja de su resumen
  manuscrito del capítulo 18, con subíndices 1, 2, 3 en lugar de $x$, $y$, $z$,
  la tercera ecuación dice $sum M_3 = I_3 dot(omega)_3 - omega_1 omega_2 (I_1 -
  I_3)$. Por la rueda $x arrow.r y arrow.r z$ el paréntesis es $(I_1 - I_2)$,
  como en la tercera de arriba y en el Beer 18.25; lo confirma el determinante
  de la misma hoja, cuya componente sobre $hat(k)$ es $I_2 omega_2 omega_1 - I_1
  omega_1 omega_2$. Las otras dos están bien. Si te la copiaste para el
  parcial, corregila: Aníbal no te va a perdonar una errata suya.
]

=== La otra mitad de §18.6: la extensión de d'Alembert

Las ecuaciones de Euler son la mitad de la sección 18.6 del Beer. La otra
mitad, que la guía del parcialito usa para sacar reacciones y este apunte no
nombraba, es la *extensión del principio de d'Alembert* (Beer §18.6, figs.
18.10 y 18.11, pág. 1171): el sistema de las fuerzas externas sobre un rígido es
*equivalente* a un vector $m overline(bold(a))$ aplicado en $G$ más una cupla
$dot(bold(H))_G$. Con $m$ la masa del cuerpo y $overline(bold(a))$ la
aceleración de su centro de masa, dice que todo lo que le hacen al cuerpo
desde afuera se puede leer como «empuja el centro de masa» más «tuerce
alrededor de él», y nada más. Es la versión en tres dimensiones del
diagrama de cuerpo libre de Física 1, con una cupla que ya no es $I alpha$
sino la derivada entera de $bold(H)_G$.
// simbolos: m, abar

Sirve, sobre todo, para un caso que parece no tener dinámica: un cuerpo
que gira a velocidad *constante* alrededor de un eje *fijo*. Ahí
$overline(bold(a)) = 0$ si $G$ está sobre el eje, y uno esperaría que los
cojinetes no hicieran nada. Hacen, si el cuerpo está torcido.

#deduccion("el disco torcido en sus cojinetes")[
  Un disco de momento axial $I$ y transversal $I'$ está montado en un eje que
  gira a $omega$ constante, pero *torcido*: su eje de simetría forma un ángulo
  $beta$ con el eje de giro (Beer §18.7 y 18.8, págs. 1171–1172). Descomponiendo
  $bold(omega)$ sobre los ejes principales del disco —$omega cos beta$ sobre su
  eje de simetría, $omega sin beta$ de costado—, el momento angular es
  $ bold(H)_G = I omega cos beta thin hat(e)_"eje" + I' omega sin beta thin hat(e)_"transv" $
  con $hat(e)_"eje"$ el versor del eje de simetría del disco y
  $hat(e)_"transv"$ el transversal en el mismo plano. Como $I != I'$, $bold(H)_G$
  *no* es paralelo a $bold(omega)$: queda entre el eje de giro y el eje del
  disco. Y está clavado al disco, así que da vueltas con él: su derivada es
  sólo el término de transporte de la @euler-derivada-h, $dot(bold(H))_G =
  bold(omega) times bold(H)_G$. Su módulo es $omega$ por la parte de
  $bold(H)_G$ perpendicular a $bold(omega)$, que es $I omega cos beta sin beta -
  I' omega sin beta cos beta$:
  $ abs(dot(bold(H))_G) = (I - I') omega^2 sin beta cos beta $
  // simbolos: beta, ehat_eje, ehat_transv
]

Por la extensión de d'Alembert, esa cupla la tienen que hacer los únicos
que tocan al disco: los cojinetes, con dos fuerzas iguales y opuestas $bold(F)$
y $-bold(F)$ que *giran con el eje*, una vuelta por vuelta. Es el
*desbalance dinámico* del módulo #M("inercia") (el de los productos de
inercia), y por eso a las ruedas de un auto se les ponen plomitos aunque
estén perfectamente centradas. Crece con $omega^2$ —al doble de velocidad,
cuatro veces la fuerza— y desaparece con $beta = 0$, cuando el eje de giro es
principal. El ingeniero que balancea una rueda no está buscando el centro de
masa: está buscando un eje principal.
// simbolos: F

#fig([El disco torcido, de costado, en el instante en que su eje queda en el
plano de la hoja: $bold(omega)$ sobre el eje de giro, el eje del disco a
$beta$ de él (exagerado en el dibujo) y $bold(H)_G$ entre los dos. Como
$bold(H)_G$ da vueltas con el eje, los cojinetes $A$ y $B$ tienen que hacer dos
fuerzas opuestas que giran con él. Redibujada para la guía del parcialito 5,
con el planteo del Beer §18.8.], fig-disco-torcido(respuesta: true))
// simbolos: A, B

=== Las dos reglas de la mano derecha, y el giróscopo con tres dedos

Todo el capítulo se dibuja con dos reglas, y la cátedra dijo que la mano
derecha es «muy importante» con signos de admiración (módulo
#M("rotacion")). Conviene tenerlas en la mano, literalmente:

+ *Un giro es un vector: una mano.* Cerrá la mano derecha con el pulgar
  parado; los dedos doblados siguen el sentido en que gira el cuerpo y el
  pulgar es el vector —$bold(omega)$, $bold(H)$, la precesión, el spin—. Para
  leer un dibujo es al revés: pulgar sobre la flecha, y los dedos dicen para
  dónde gira.
+ *Un producto vectorial son tres dedos.* Pulgar, índice y mayor abiertos en
  ángulo recto, como $x$, $y$, $z$: pulgar por índice da mayor, y en rueda.
  Para el giróscopo: *pulgar = el giro* ($bold(H)$), *índice = el par*,
  *mayor = la precesión*. Giro por par da precesión: el eje del rotor
  persigue al par. Leído en rueda, precesión por giro da el par, que es el
  $bold(Omega) times bold(H)$ de la @euler-derivada-h.

*Con las manos, el término giroscópico.* Agarrá un libro con las dos manos y
hacelo girar a la vez sobre dos ejes —el lomo y el que sale de la tapa—. Vas
a sentir que se quiere torcer hacia un tercer lado que vos no estás
empujando: es el $(I_y - I_z) omega_y omega_z$ de las ecuaciones de Euler, la
parte de $bold(Omega) times bold(H)$ que existe sólo porque $bold(H)$ no es
paralelo a $bold(omega)$. Con una pelota —momentos iguales— la mano no siente
nada, porque ese término se anula. Con un libro de Beer, que pesa como un
ladrillo, se siente bastante.

#guia("qué ejercicios cubre este módulo")[
  El punto 2 del Problema 2 (la cupla que sostiene al disco de la horquilla)
  y el Problema 3 completo (el volante en el gimbal). Los ángulos de Euler y
  la precesión estable de las dos últimas secciones no tienen ejercicio
  propio en este módulo: son la herramienta que el módulo #M("peonza") aplica a los
  Problemas 4 y 6.
]

#ejemplo("El disco en la horquilla: la cupla que sostiene el movimiento")[
  _(Guía de la cátedra 2026, sección Cuerpo rígido, Problema 2, punto 2: $d
  bold(H)_G \/ d t$, continuando el ejemplo del módulo #M("inercia"). Resuelto
  por la cátedra en «Ejercicio 2 CR 2026», con tres animaciones, una por
  observador.)_ Con $bold(H)_G = 1/4 m r^2
  omega_2 hat(j) + 1/2 m r^2 omega_1 hat(k)$ (módulo #M("inercia")) y $bold(Omega) =
  omega_2 hat(j)$ —los ejes están clavados a la horquilla, no al disco, y
  $omega_1$, $omega_2$ son constantes—, la @euler-derivada-h se reduce a un solo
  término: el primero es cero porque las componentes de $bold(H)_G$ en esta
  base no cambian.
  $ dot(bold(H))_G = bold(Omega) times bold(H)_G
    = omega_2 hat(j) times (1/4 m r^2 omega_2 hat(j) + 1/2 m r^2 omega_1 hat(k))
    = 1/2 m r^2 omega_1 omega_2 hat(i) $

  #clave[
    *La cupla necesaria apunta exactamente donde el módulo #M("cinematica-cr") encontró
    $bold(alpha)$.* Con $sum bold(M)_G = dot(bold(H))_G$, sostener este
    movimiento —los dos giros constantes, para siempre— exige una cupla
    $1/2 m r^2 omega_1 omega_2$ sobre $hat(i)$: la misma dirección que
    $bold(alpha) = omega_1 omega_2 hat(i)$ del módulo #M("cinematica-cr"), el mismo disco
    mirado allá sólo con la cinemática. No es casualidad: es la cupla giroscópica que el módulo #M("cinematica-cr") ya
    había señalado sin poder calcularla, porque todavía no existía el tensor
    de inercia.
  ]

  *La misma cuenta con ejes clavados al disco* —la parte «opcional» de la
  resolución de la cátedra, y la prueba de que la terna se elige por
  comodidad y no por necesidad—. Con $phi.alt = omega_1 t$ el ángulo girado
  por el disco, $hat(j) = sin phi.alt hat(i)'' + cos phi.alt hat(j)''$, y
  $bold(H)_G = 1/4 m r^2 (omega_2 sin phi.alt hat(i)'' + omega_2 cos phi.alt
  hat(j)'' + 2 omega_1 hat(k)'')$: ahora las componentes cambian, la derivada
  relativa vale $1/4 m r^2 omega_1 omega_2 (cos phi.alt hat(i)'' - sin phi.alt
  hat(j)'')$ y el transporte, con $bold(Omega) = bold(omega)$, da exactamente lo
  mismo. Sumados, $1/2 m r^2 omega_1 omega_2 (cos phi.alt hat(i)'' - sin
  phi.alt hat(j)'')$, que es el $hat(i)$ de la horquilla escrito con los
  versores del disco. Mismo resultado, repartido distinto:

  #align(center, table(
    columns: 4, inset: (x: 6pt, y: 4pt), align: left,
    [*Observador*], [*Qué hace $bold(H)_G$*], [*Derivada relativa*], [*Transporte*],
    [horquilla], [queda quieto], [$0$], [todo: $omega_2 hat(j) times bold(H)_G$],
    [disco], [cono alrededor del eje del disco, con $-omega_1$], [la mitad], [la otra mitad],
    [inercial], [cono alrededor de la vertical, con $+omega_2$], [todo], [$0$],
  ))

  (La tabla es la de la resolución de la cátedra.) El que va montado en el
  disco ve pasar la horquilla para el lado contrario al spin, y con ella a
  $bold(H)_G$; el de afuera ve a $bold(H)_G$ barrer un cono alrededor de la
  vertical, con semiángulo $arctan(2 omega_1\/omega_2)$, y a $dot(bold(H))_G$
  tangente al cono. Tres películas distintas del mismo vector, y el teorema
  del transporte de la @cin-derivada es el traductor entre las tres.
]

#ejemplo("El volante en el gimbal: por qué 600 N·m dan sólo 20 rad/s²", nivel: "a fondo")[
  _(Guía de la cátedra 2026, sección Cuerpo rígido, Problema 3 completo. Retoma el ejemplo del módulo #M("cinematica-cr"): volante con
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
  con la @iner-diagonal:
  $ bold(H)_O = I_x Omega_x hat(i) + I_y omega_p hat(j) + I_z omega_s hat(k)
    = 5 Omega_x hat(i) + 2,5 hat(j) + 1000 hat(k) " kg" dot.op "m"^2\/"s" $
  que en el instante inicial ($Omega_x = 0$) es $bold(H)_O = 2,5 hat(j) +
  1000 hat(k)$.

  *La ecuación de momento, componente $x$.* Con la @euler-derivada-h y la
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
    seis veces más de lo que en realidad acelera al gimbal —y es exactamente
    la respuesta que el problema está esperando que alguien dé, para poder
    corregirla—. Es la misma
    «rigidez giroscópica» que hace que un giróscopo resista a que le cambien
    el eje: buena parte de la cupla aplicada se gasta en seguirle el ritmo a
    un $bold(H)$ grande, no en acelerar nada.
  ]

  *Cambiando un número por vez*, la fórmula $dot(Omega)_x = (M_x - omega_p
  I_z omega_s)\/I_x$ cuenta toda la historia. Sin plataforma, o con el volante
  quieto, no hay nada que transportar y da los $120$ rad/s² de dividir. Con el
  volante a $120$ rad/s el peaje se come los $600$ N·m enteros y el _gimbal_
  *no se mueve*, aunque le estén aplicando la cupla. Y con el volante a $200$
  rad/s da $-80$ rad/s²: el _gimbal_ acelera *para el otro lado* del torque
  aplicado, porque lo que hace falta para acompañar a la plataforma es más de
  lo que se le da. Ninguna de las tres cosas se adivina con la intuición de
  Física 1, que es lo que la cátedra quería mostrar con este problema.

  *Y sin cupla, que es como lo resolvió Aníbal.* Su resolución escrita del
  Ejercicio 3 (la hoja «Sin torque externo», subida con la clase de los
  ángulos de Euler) pone $M_x = 0$: el gimbal está suelto y nadie lo empuja.
  La misma fórmula da
  $ dot(Omega)_x = - (omega_p I_z omega_s)/I_x = - ((0,5)(10)(100))/5 = -100 " rad/s"^2 $
  *El gimbal suelto no se queda quieto*: arranca solo, y para el lado que
  lleva el eje del volante a ponerse *paralelo* al eje de giro de la
  plataforma, con el mismo sentido. Como arranca a $90degree$ de esa
  posición y nada lo frena, se pasa de largo: oscila como un péndulo entre
  la posición inicial y la simétrica del otro lado, pasando por la
  paralela. Integrando numéricamente la ecuación completa con estos
  números, la ida y vuelta tarda unos $0,74$ s; las oscilaciones chicas
  alrededor de la posición paralela tienen $omega approx sqrt(omega_p I_z
  omega_s \/ I_x) = 10$ rad/s. La nota de Aníbal al pie lo dice en cuatro
  palabras: «el sistema evoluciona oscilando». Es el principio del
  *girocompás* —el GIF que subió con esa clase—: con la Tierra de
  plataforma, un volante libre en su gimbal busca ponerse paralelo al eje
  terrestre, y con un poco de rozamiento que mate la oscilación se queda
  apuntando al norte.

  *Y leído al revés, es un CMG.* Las diapositivas de control de actitud de la
  Universidad de Sevilla que subió la cátedra (R. Vázquez, 2021, diap. 10 y
  14) lo cuentan desde el satélite: un volante de $bold(H)$ grande y velocidad
  fija al que un motor le gira el eje —un _control moment gyroscope_— le hace
  al satélite una cupla $bold(Omega) times bold(H)$. Con este volante, girar
  el eje a $0,5$ rad/s da $500$ N·m con un motorcito que sólo tiene que
  mover el _gimbal_. Así maniobran rápido los satélites «ágiles» de
  observación (los Pléiades de la diapositiva 14), y por eso las diapositivas
  lo llaman el caso más extremo de usar una rueda.

  *Torque de salida y amplificación de torque* (los dos nombres que Aníbal
  dio para el parcialito del cap. 18). En un CMG hay dos torques sobre ejes
  distintos. El *de entrada* lo pone el motor del gimbal, sobre el eje del
  gimbal, y sólo tiene que vencer la inercia y el rozamiento del gimbal en
  ese eje: con el gimbal girando a velocidad constante, idealmente cero. El
  *de salida* es el que recibe el satélite, $bold(Omega) times bold(H)$, de
  módulo $H dot(delta)$, sobre el tercer eje, perpendicular al gimbal y al
  rotor. Con este volante ($H = 1000$ kg·m²/s) y el gimbal a $0,5$ rad/s,
  salen $500$ N·m. Si además el motor tiene que llevar el gimbal de cero a
  $0,5$ rad/s en un segundo (supuesto, para poner un número), le alcanza con
  $I_x dot.double(delta) = 5 dot.op 0,5 = 2,5$ N·m: entra $2,5$, salen
  $500$, una *amplificación* de $200$. No es magia: lo que el CMG le pasa al
  satélite es momento angular, sacado de *girar la dirección* de un
  $bold(H)$ grande que ya estaba ahí; el rotor no se frena. Una rueda de
  reacción, en cambio, da torque frenándose o acelerándose, y su torque de
  salida es igual al del motor: amplificación uno.
]

#posta[
  Un volante que gira rápido es un vector $bold(H)$ enorme, y a un vector
  enorme no se lo lleva de paseo gratis. Si la plataforma lo obliga a
  cambiar de dirección, alguien tiene que pagar esa cupla —acá, 500 de los
  600 N·m— antes de que sobre algo para acelerar lo que uno quería
  acelerar. Es lo que se siente en las manos al girar una rueda de bicicleta
  que está girando: no se deja.
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

Dibujados, que es como se entienden (@fig-euler-angulos): $phi$ vive en el piso
fijo, $theta$ en el plano vertical que contiene a $Z$ y a $z$, y $psi$ en el
plano del propio cuerpo. Cada uno se mide en un plano distinto, y la línea de
nodos es la bisagra que comparten.

#fig([Los tres ángulos de Euler, con las definiciones del Beer §18.9 (pág.
1187). Verde: $phi$, en el plano $X Y$ fijo, de $X$ a la línea de nodos.
Rojo: $theta$, de $Z$ al eje $z$ del cuerpo, girando sobre la línea de nodos.
Azul: $psi$, en el plano perpendicular a $z$ (punteado), de la línea de nodos
al eje $x$ pegado al cuerpo.], fig-euler-angulos)
<fig-euler-angulos>

Los ejes naturales para escribir $bold(omega)$ son los que giran con $phi$ y
$theta$ pero *no* con $psi$ —el segundo camino de la sección anterior,
$bold(Omega) != bold(omega)$—, porque son principales del cuerpo (uno de
ellos es $z$, el eje de simetría) sin tener que seguir el espín:

$ bold(Omega) = -dot(phi) sin theta thin hat(e) + dot(theta) hat(f) + dot(phi) cos theta thin hat(k),
  quad quad bold(omega) = bold(Omega) + dot(psi) hat(k) $

(Beer ecs. 18.33 a 18.38, pág. 1187–1188.) Los ejes son exactamente los del
Beer (su fig. 18.16): $hat(k)$ sobre el eje de simetría; $hat(f)$ sobre la
línea de nodos, que es el eje alrededor del cual gira la nutación; y
$hat(e) = hat(f) times hat(k)$, en el plano de $Z$ y $z$ pero del lado
*opuesto* a $Z$ —por eso el eje fijo se descompone $bold(K) = -sin theta
thin hat(e) + cos theta thin hat(k)$ (ec. 18.34) y la precesión aporta un
menos—. Ese menos no es decorativo: con $hat(e)$ apuntando para el otro lado
el corchete de la @euler-precesion-estable cambia de signo por dentro, y en
el módulo #M("peonza") eso da vuelta la precesión directa y la retrógrada.
Este apunte lo sabe por las malas. Con $I'$ el momento de inercia transversal
—sobre $hat(e)$ o $hat(f)$— e $I$ el momento sobre el eje de simetría $z$,
$bold(H)_O = I' Omega_e hat(e) + I' Omega_f hat(f) + I omega_z hat(k)$, y las
tres componentes de $sum bold(M)_O = dot(bold(H))_O$ dan las tres ecuaciones
diferenciales del giróscopo (Beer ec. 18.39, pág. 1188), cuya solución general
no es elemental. *Se citan porque son las que hay que resolver en el caso
general* —el módulo no las resuelve enteras: la sección siguiente resuelve el
caso particular que sí tiene solución simple—. Escritas, con $omega_z =
dot(psi) + dot(phi) cos theta$:

$ sum M_e = -I' (dot.double(phi) sin theta + 2 dot(theta) dot(phi) cos theta) + I dot(theta) omega_z, quad quad
  sum M_k = I (d omega_z)/(d t) $
$ sum M_f = I' (dot.double(theta) - dot(phi)^2 sin theta cos theta) + I dot(phi) sin theta thin omega_z $

El menos de $hat(e)$, que es el que más errores trae, se ve de una en el plano
de $Z$ y $z$ (@fig-euler-efk): $dot(phi) bold(K)$ se proyecta positivo sobre
$hat(k)$ y negativo sobre $hat(e)$, porque $hat(e)$ apunta para el lado
contrario de $Z$.

#fig([El plano que forman $Z$ y $z$, con la línea de nodos $hat(f)$ entrando
en la hoja. $hat(e) = hat(f) times hat(k)$ queda perpendicular a $z$ y *del
lado opuesto a $Z$*: por eso la precesión $dot(phi) bold(K)$ tiene componente
$dot(phi) cos theta$ sobre $hat(k)$ y $-dot(phi) sin theta$ sobre $hat(e)$ (Beer
ec. 18.34). El mismo $theta$ aparece dos veces: entre $Z$ y $z$, y entre
$hat(e)$ y la horizontal.], fig-euler-efk)
<fig-euler-efk>

Aníbal las pegó tal cual en su resumen manuscrito del capítulo, con una nota
que es todo el plan de lo que sigue: «ec. no lineales → casos particulares».
Y otra que vale oro para el parcialito: «el giróscopo ayuda a visualizar los
ángulos de Euler». El balancín exterior gira $phi$ alrededor del eje fijo, el
interior gira $theta$ dentro del exterior, y el rotor gira $psi$ dentro del
interior: tres cardanes, tres ángulos, uno por articulación
(@fig-euler-cardanes).

// flotante: entera no entra al pie de la página del texto, y en línea dejaba media página en blanco
#figure(placement: auto, kind: "fig", supplement: [Figura], caption: [El giróscopo en cardanes, que es como Aníbal dice que se visualizan los
ángulos de Euler. Cada articulación agrega un giro y nada más: el balancín
exterior gira $dot(phi)$ alrededor del eje fijo $Z$, el interior gira
$dot(theta)$ alrededor de la línea de nodos (los dos pivotes negros), y el
rotor gira $dot(psi)$ alrededor de su propio eje. Los ejes $hat(e)$, $hat(f)$,
$hat(k)$ del Beer viajan pegados al balancín interior: siguen a $phi$ y a
$theta$, no a $psi$.], align(center, fig-euler-cardanes))
<fig-euler-cardanes>

#notacion[
  *Tres ángulos alcanzan, pero tienen un agujero; por eso a bordo se usan
  cuaterniones.* La primera clase escrita de cuerpo rígido de la cátedra deja
  la pregunta: ¿cuántos números hacen falta para la actitud de un CubeSat, y
  por qué las computadoras de a bordo prefieren cuatro con un vínculo en vez
  de tres ángulos? Hacen falta *tres*, porque la orientación tiene tres
  grados de libertad (módulo #M("cinematica-cr")). El problema de los ángulos
  de Euler es que en una orientación se rompen: con $theta = 0$ el eje $z$
  coincide con $Z$, la línea de nodos deja de estar definida, y $phi$ y $psi$
  pasan a medir *el mismo* giro. Se perdió un grado de libertad en la
  descripción, aunque el cuerpo no perdió ninguno. En un giróscopo montado
  en cardanes ese agujero es mecánico: cuando dos ejes de cardán se alinean,
  el conjunto ya no puede acompañar un giro en cierta dirección —el
  *bloqueo de cardán* (@fig-euler-bloqueo), que Wrigley y Hollister (1965, el paper de la
  cátedra) describen y resuelven agregando cardanes—. Cualquier juego de tres
  ángulos tiene al menos una orientación así; se puede correr, no evitar.

  El *cuaternión* le da la vuelta usando el resultado de Euler del módulo
  #M("cinematica-cr"): toda orientación es un giro de un ángulo $beta$
  alrededor de un eje $hat(bold(e))$. Se guardan cuatro números, $q_0 = cos
  (beta\/2)$ y $(q_1, q_2, q_3) = hat(bold(e)) sin(beta\/2)$, con el vínculo
  $q_0^2 + q_1^2 + q_2^2 + q_3^2 = 1$ que deja tres libres. No tiene ninguna
  orientación singular, componer dos giros es multiplicar dos cuaterniones
  —sumas y productos, sin senos ni cosenos— y el error numérico se arregla
  renormalizando a $1$. Por eso los usa todo sistema de control de actitud.
  (Esto no está en los libros de la lista: contesta una pregunta de la clase,
  y la parte de los cardanes es de Wrigley y Hollister.)
]

#fig([El agujero, en los mismos cardanes. Con $theta = 50 degree$ los tres ejes
de giro apuntan para tres lados distintos. Con $theta = 0$ el eje del rotor
queda sobre $Z$, los dos balancines quedan en el mismo plano, y $dot(phi)$ y
$dot(psi)$ son giros alrededor del *mismo* eje: el conjunto perdió una
dirección en la que acompañar un giro. Es el bloqueo de cardán.],
fig-euler-bloqueo)
<fig-euler-bloqueo>

== Precesión estable: el caso que sí se resuelve a mano

#deduccion("de dónde sale la cupla que sostiene una precesión constante")[
  *Precesión estable* es el caso en que $theta$, $dot(phi)$ y $dot(psi)$ son
  las tres constantes: el eje $z$ barre un cono perfecto alrededor de $Z$, a
  velocidad angular y ángulo de apertura fijos. Entonces $dot(theta) = 0$ y
  $bold(Omega) = -dot(phi) sin theta thin hat(e) + dot(phi) cos theta thin
  hat(k)$ es constante en el tiempo *dentro* de la base $(hat(e), hat(f),
  hat(k))$ que gira con ella —su módulo y su ángulo con $hat(k)$ no cambian—,
  así que $bold(H)_O$ también tiene componentes constantes en esa base:
  $ bold(H)_O = -I' dot(phi) sin theta thin hat(e) + I (dot(phi) cos theta +
    dot(psi)) hat(k) $
  y el primer término de la @euler-derivada-h se anula. Queda sólo
  $bold(Omega) times bold(H)_O$, con $bold(Omega)$ y $bold(H)_O$ los de
  arriba y usando $hat(e) times hat(k) = -hat(f)$ y $hat(k) times hat(e) = hat(f)$:
  $ bold(Omega) times bold(H)_O = dot(phi) sin theta thin I (dot(phi) cos theta + dot(psi)) hat(f)
    - I' dot(phi)^2 sin theta cos theta thin hat(f) $
  y juntando:
  $ sum bold(M)_O = dot(phi) sin theta thin [ I dot(psi) + (I - I') dot(phi) cos theta ] thin hat(f) $
]

$ sum bold(M)_O = dot(phi) sin theta thin [ I dot(psi) + (I - I') dot(phi)
  cos theta ] thin hat(f) $ <euler-precesion-estable>

(Beer §18.10, ecs. 18.40 a 18.44, pág. 1189: el Beer la escribe como
$(I omega_z - I' dot(phi) cos theta) dot(phi) sin theta thin hat(j)$, con su
$hat(j)$ igual a nuestro $hat(f)$ y $omega_z = dot(psi) + dot(phi) cos
theta$; es la misma, y vale la pena comprobarlo abriendo el paréntesis.)
*La cupla necesaria es perpendicular al plano
que forman $Z$ y $z$* —sobre $hat(f)$, la línea de nodos—,
nunca dentro de ese plano: es la traducción formal de que un giróscopo no
«cae» en la dirección de la cupla aplicada, sino que precesa perpendicular a
ella. Con un trompo, el que pone esa cupla es el peso (@fig-precesion-estable).

#fig([Precesión estable de un trompo apoyado en $O$. El eje barre un cono de
semiángulo $theta$ fijo alrededor de $Z$. El peso, aplicado a una distancia
$c$ de $O$, hace una cupla horizontal sobre la línea de nodos $hat(f)$,
perpendicular al plano de $Z$ y $z$. Esa cupla no voltea el eje: le agrega
a $bold(H)_O$ un $dif bold(H)_O$ de costado, también sobre $hat(f)$, y la punta
de $bold(H)_O$ da vueltas. El caso con el eje inclinado y el peso es el de la
sección que sigue.], fig-precesion-estable)
<fig-precesion-estable>

#cuidado[
  *Caso particular, $theta = 90degree$: el eje de simetría queda siempre
  perpendicular a $Z$.* Ahí $sin theta = 1$, $cos theta = 0$, y la
  @euler-precesion-estable se reduce a
  $ sum bold(M)_O = I dot(phi) dot(psi) thin hat(f) $ <euler-precesion-90>
  (Beer ec. 18.45, pág. 1189.) Es la forma más simple de toda la sección —el
  producto de las dos velocidades angulares por el momento de inercia axial,
  sin ningún coseno— y el mismo mecanismo, con otra letra para cada
  velocidad, que ya apareció dos veces en este módulo: $bold(alpha) =
  omega_1 omega_2 hat(i)$ en el módulo #M("cinematica-cr") y $dot(bold(H))_G = 1/2 m r^2
  omega_1 omega_2 hat(i)$ en el primer ejemplo de hoy.
]

=== Con el eje inclinado y el peso: una cuadrática, dos precesiones

El caso de $90degree$ es el del dibujo de siempre. Con el eje *inclinado* —un
trompo, o el giróscopo apoyado en un pivote $O$ con el eje a $theta$ de la
vertical— la cupla la pone el peso y aparece algo que el caso horizontal
escondía. Con $W$ el peso, aplicado en $G$, y $c$ la distancia de $O$ a $G$
sobre el eje, el par del peso respecto de $O$ vale $W c sin theta$ y va sobre
la línea de nodos, que es justo donde la @euler-precesion-estable pide la
cupla. Los momentos de inercia ahora son respecto de $O$: el axial $I$ no
cambia (el eje pasa por $O$), y el transversal pasa a ser $I'_O = I'_G + m
c^2$, con $I'_G$ el transversal por $G$ y $m$ la masa (Steiner, módulo
#M("rotacion")). Igualando, el $sin theta$ se simplifica:
// simbolos: W, c, I'_O, I'_G, m

$ W c = [I dot(psi) + (I - I'_O) dot(phi) cos theta] dot(phi) quad ==> quad
  (I - I'_O) cos theta thin dot(phi)^2 + I dot(psi) thin dot(phi) - W c = 0 $ <euler-precesion-inclinada>

*Es cuadrática en $dot(phi)$*, así que hay *dos* precesiones estables
posibles para el mismo trompo con el mismo spin. Para un trompo de los de
siempre ($I'_O > I$ y $theta < 90degree$) el primer coeficiente es negativo y
las dos raíces son positivas: una *lenta*, que es la que se ve, y que con
spin grande vale casi $W c \/ (I dot(psi))$ —la de $90degree$ con otro
ángulo—; y una *rápida*, de orden $I dot(psi) \/ ((I'_O - I) cos theta)$, que
hay que largar a propósito y nadie ve en la mesa de la cocina. La razón de
fondo: con el eje inclinado, la propia precesión aporta un pedazo de momento
angular fuera del eje del rotor (el $-I'_O dot(phi) sin theta thin hat(e)$ de
$bold(H)_O$), y ese pedazo también rota con $bold(Omega)$; eso es el término en
$dot(phi)^2$.

Y la cuadrática dice cuándo el trompo se cae. Sus raíces son reales sólo si
el discriminante no es negativo, $I^2 dot(psi)^2 >= 4 (I'_O - I) cos theta
thin W c$: por debajo de un spin mínimo *no existe* precesión estable, y lo
que queda es nutación cada vez más ancha hasta que el trompo toca la mesa.
Mientras tanto, con el spin bajando, la lenta $W c \/ (I dot(psi))$ se
*acelera*: el trompo que se está por caer gira cada vez más rápido alrededor
de la vertical, que es exactamente lo que cualquiera vio de chico sin saber
que estaba viendo una cuadrática.

#ejemplo("El giróscopo de mesa a 60 grados: las dos raíces")[
  _(Modelo de parcialito 5, Ejercicio 11, con los números validados en
  `practica/validar.py`.)_ Un rotor de $1,5$ kg y $6$ cm de radio, con el
  centro a $c = 10$ cm del pivote, gira con $dot(psi) = 300$ rad/s y el eje
  a $theta = 60degree$ de la vertical. $I = 1/2 (1,5)(0,06)^2 = 0,00270$
  kg·m², $I'_O = 1/4 (1,5)(0,06)^2 + 1,5 (0,10)^2 = 0,01635$ kg·m² y $W c =
  1,4715$ N·m. La @euler-precesion-inclinada queda
  $ -0,006825 thin dot(phi)^2 + 0,810 thin dot(phi) - 1,4715 = 0 $
  con raíces $dot(phi) = 1,845$ rad/s (la lenta: una vuelta cada $3,40$ s) y
  $dot(phi) = 116,8$ rad/s (la rápida). La aproximada $W c \/ (I dot(psi))$ da
  $1,82$ rad/s, a un $1,6$ % de la lenta: con spin grande, $theta$ casi no
  importa. Y el spin mínimo, el del discriminante en cero, es
  $dot(psi)_"mín" = (2 \/ I) sqrt((I'_O - I) cos theta thin W c) = 74,2$
  rad/s: a la cuarta parte del spin actual, este giróscopo se cae.
  // simbolos: psidot_mín
]

Las dos raíces del ejemplo, barriendo el spin en vez de fijarlo, son la
@fig-dos-raices: lo que en la cuenta son dos números, en el dibujo son dos
ramas que se juntan en el spin mínimo.

#fig([Las dos precesiones estables del giróscopo de mesa a $60 degree$, en
función del spin. La lenta (roja) es la que se ve, y con spin grande se pega a
la aproximada $W c \/ (I dot(psi))$ (punteada). La rápida (azul) crece con el
spin. Las dos se juntan en $dot(psi)_"mín"$; a la izquierda, la cuadrática no
tiene raíces reales y el trompo no puede precesar parejo: nuta cada vez más y
se cae. Los puntos son los del ejemplo, a $300$ rad/s.], fig-dos-raices)
<fig-dos-raices>

== ¿Alrededor de qué eje conviene girar? El ladrillo, la raqueta y el Explorer 1

Dos de las tres «preguntas orientadoras» de la primera clase escrita de
cuerpo rígido se contestan acá, con las ecuaciones de Euler y nada más:
qué pasa con un ladrillo que se tira girando, y por qué el primer satélite
norteamericano terminó dando tumbos.

La idea, antes de la cuenta. Un cuerpo libre —sin cuplas— que gira
exactamente sobre un eje principal sigue girando así para siempre: con
$bold(omega)$ sobre un eje principal, $bold(H)_G$ es paralelo a
$bold(omega)$ (módulo #M("inercia")) y no hay nada que lo saque. La pregunta
de ingeniería es otra: si se lo desvía *un poquito*, ¿vuelve, o se desarma?
Un lápiz parado sobre la punta también está en equilibrio.

#deduccion("cuál de los tres ejes principales es inestable")[
  Sin cuplas, las ecuaciones de Euler (@euler-euler-clasicas) quedan
  $I_x dot(omega)_x = (I_y - I_z) omega_y omega_z$ y cíclicas. El cuerpo gira
  casi sobre $x$: $omega_x approx omega_0$, grande, y $omega_y$, $omega_z$
  chiquitas. En la primera ecuación el lado derecho es un producto de dos
  chiquitas, así que $omega_x$ casi no cambia. Las otras dos:
  $ I_y dot(omega)_y = (I_z - I_x) omega_0 omega_z, quad quad I_z dot(omega)_z = (I_x - I_y) omega_0 omega_y $
  Derivando la primera y reemplazando $dot(omega)_z$ con la segunda:
  $ dot.double(omega)_y = ((I_z - I_x)(I_x - I_y))/(I_y I_z) thin omega_0^2 thin omega_y $
  Si el coeficiente es *negativo*, es la ecuación de un resorte: $omega_y$
  oscila y queda chiquita, y el giro es *estable*. Si es *positivo*,
  $omega_y$ crece como una exponencial y el giro se desarma. El signo lo
  deciden los dos paréntesis: si $I_x$ es el *mayor* de los tres, o el
  *menor*, tienen signos opuestos y el producto es negativo; si $I_x$ es el
  *del medio*, los dos son positivos.
]

*Girar alrededor del eje de momento máximo o mínimo es estable; alrededor
del intermedio, no.* La pregunta del ladrillo de $20 times 10 times 5$ cm de
la cátedra sale con la tabla del módulo #M("inercia"), sin integrar: el eje
paralelo a la arista de $20$ tiene $I = M (10^2 + 5^2)\/12 = 125 M\/12$ (el
menor), el paralelo a la de $5$ tiene $(20^2 + 10^2) M\/12 = 500 M\/12$ (el
mayor), y el paralelo a la de $10$ queda en el medio, con $425 M\/12$. Tirado
girando alrededor de ése, el ladrillo da media vuelta de costado cada tanto
por más cuidado que uno ponga. Con una raqueta de tenis pasa lo mismo, y en
1985 un cosmonauta lo filmó en una estación espacial con una tuerca de
mariposa que se daba vuelta sola, con una regularidad que parecía brujería
y era esta cuenta.

#fig([El ladrillo de $20 times 10 times 5$ cm de la cátedra, con sus tres ejes
principales por $G$. El paralelo a la arista larga tiene el momento de inercia
menor; el paralelo a la corta, el mayor; los dos son estables. El del medio
—paralelo a la arista de $10$ cm— es el que se da vuelta.], fig-ladrillo-ejes)
<fig-ladrillo-ejes>

Hasta acá, el cuerpo rígido *perfecto*. El Explorer 1 (1958) no lo era. Era
un cilindro largo —alargado, $I_1 = I_2 > I_3$ en la clasificación del
módulo #M("inercia")— y lo pusieron a girar alrededor de su eje largo, el de
momento *mínimo*: según la deducción de arriba, estable. Pero llevaba cuatro
antenas de alambre flexibles, que se doblaban y vibraban, y eso disipa
energía. A las pocas horas daba tumbos, girando de punta a punta.

#deduccion("por qué un cuerpo que pierde energía termina girando sobre su eje mayor")[
  Sin cuplas externas, $bold(H)_G$ se conserva: lo que se pierde por
  rozamiento interno es *energía*, no momento angular. Girando sobre un eje
  principal de momento $I$, $H = I omega$ y $T = frac(1, 2) I omega^2$, así
  que
  $ T = H^2 / (2 I) $
  Con $H$ fijo, la energía más baja posible corresponde al $I$ más
  *grande*. Un cuerpo que disipa va bajando su energía sin poder tocar su
  momento angular, y la única manera es pasar a girar alrededor de un eje de
  más inercia. Termina en el de momento máximo, que es el único estable
  *con* disipación.
]

#fig([El Explorer 1 con el momento angular clavado. Al salir giraba sobre su
eje largo, el de momento mínimo: la energía $T = H^2 \/ (2 I)$ era la máxima
posible para ese $bold(H)_G$. Las cuatro antenas flexibles disiparon energía
sin poder tocar $bold(H)_G$, y la única salida fue girar sobre un eje de más
inercia: horas después daba tumbos de punta a punta, con el mismo
$bold(H)_G$ y la energía mínima.], fig-explorer)
<fig-explorer>

Para el Explorer 1, alargado, el eje de momento máximo es cualquiera
perpendicular al largo: el giro de punta a punta. Para un CubeSat 3U del
módulo #M("inercia") puesto a girar sobre su eje largo, la energía final
sería $T_f\/T_i = I_"mín"\/I_"máx" = 0,0067\/0,042 = 0,16$ de la inicial, y
el resto se lo comieron los paneles. Por eso los satélites estabilizados por
giro de la clasificación son *achatados*: el tambor de un Intelsat VI o de
un GOES gira sobre su eje de momento máximo, y ahí puede disipar lo que
quiera sin moverse. La lección del Explorer 1 —el primer satélite de los
Estados Unidos, y el primer ejemplo de cómo un detalle «no rígido» le gana a
una cuenta bien hecha— es la que la cátedra dejaba anunciada al definir el
cuerpo rígido como una idealización.

Las diapositivas de Sevilla que subió la cátedra para la clase del 19/10
(diap. 6 a 9) le ponen nombre a todo esto —la *regla del eje mayor*— y le
agregan la otra mitad de la historia. El Sputnik (1957) giraba sobre su eje
mayor y no tuvo problemas; el Explorer 1, un año después, sobre el menor; el
Telstar 1 (1962), el primer satélite de comunicaciones, ya salió girando a
200 rpm sobre su eje mayor. Y la regla tiene una excepción que se usa a
propósito: la inestabilidad del eje menor es *lenta*, de horas, así que las
últimas etapas de un lanzador se hacen girar sobre su eje largo justo antes
de encenderse —el efecto giroscópico achica el error de un empuje
desalineado—, y apenas se suelta la carga el giro se frena, con un
mecanismo de yo-yo o esperando a que la dinámica lo pase al eje mayor (el
ejemplo de las diapositivas es la Mars Odyssey). Un detalle de la diap. 7 que
vale la cita: la regla del eje mayor *no se puede deducir de un modelo de
cuerpo rígido*. La deducción de arriba necesitó la disipación, que es
justamente lo que el cuerpo rígido no tiene.

#posta[
  Un cuerpo libre gira tranquilo sobre su eje de más inercia o sobre el de
  menos; sobre el del medio, se da vuelta solo. Y si además tiene algo
  flojo adentro —una antena que flamea, combustible que chapotea—, ni el de
  menos le sirve: va a terminar sobre el de más, porque con el momento
  angular clavado, perder energía obliga a buscar más inercia. Si diseñás un
  satélite que gira, hacelo achatado. Si lo hacés largo, que no gire.
]

== Lo que se usa después

1. *La @euler-derivada-h, con $bold(Omega) != bold(omega)$.* Es la herramienta
   entera de la Parte V a partir de acá: cada vez que un cuerpo tiene un eje
   de simetría rápido —un volante, una peonza, un satélite estabilizado por
   giro—, conviene elegir ejes que sigan la precesión y no el espín.

2. *Los ángulos de Euler y la notación $I$, $I'$.* El módulo #M("peonza") los usa tal
   cual, con el cuerpo simétrico *sin* cuplas externas —$sum bold(M)_O = 0$—
   como el caso especial que sigue.

3. *La @euler-precesion-estable y su caso particular.* La versión sin cuplas
   ($sum bold(M)_O = 0$) es la que resuelve la peonza libre del módulo #M("peonza"):
   ahí la ecuación no dice cuánta cupla hace falta, sino qué relación entre
   $theta$, $dot(phi)$ y $dot(psi)$ hace que la precesión sea estable *sola*.
