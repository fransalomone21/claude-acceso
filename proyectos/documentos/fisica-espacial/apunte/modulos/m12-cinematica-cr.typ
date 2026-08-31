#import "../plantilla.typ": *

#modulo("Cinemática del cuerpo rígido y sistemas rotantes")[
  Describir cómo se mueve un cuerpo que ya no es un punto: por qué todo
  movimiento con un punto fijo es una rotación alrededor de un eje que
  cambia de un instante a otro, por qué las velocidades angulares se suman
  como vectores aunque las rotaciones finitas no, y —el resultado que
  sostiene los tres módulos que siguen— cómo se deriva un vector cuando el
  sistema desde el que se lo mira está girando. Con eso queda armado el
  aparato que en el módulo 14 produce las ecuaciones de Euler.
]

Los once módulos anteriores trataron a cada cuerpo como un *punto*: una masa
sin tamaño, con una posición y nada más. Alcanzó para una órbita entera
porque la Tierra vista desde $42 thin 000$ km efectivamente es un punto. Deja
de alcanzar apenas la pregunta cambia de *dónde está* el satélite a *hacia
dónde apunta*: una antena, una cámara, un panel solar y un motor apuntan a
algún lado, y ese lado es lo que hay que controlar.

#definicion("cuerpo rígido")[
  Un sistema de partículas en el que la distancia entre dos cualesquiera de
  ellas no cambia nunca. Es una idealización —todo se deforma un poco— pero es
  exactamente la que hace falta: al fijar todas las distancias, la posición de
  un cuerpo entero queda determinada por *seis* números y no por $3N$.

  Tres de esos seis son la posición del centro de masa, y ésos ya están
  resueltos: el teorema del módulo 3 dice que el centro de masa se mueve como
  un punto de masa $M$ empujado por la resultante de las fuerzas externas, y
  toda la Parte III fue eso. Los otros tres son la *orientación*, y de ellos
  se ocupa esta parte.
]

== Con un punto fijo, todo movimiento es una rotación

#deduccion("por qué siempre hay un eje, aunque el cuerpo se mueva de cualquier manera")[
  Sea un cuerpo con un punto $O$ fijo. En lugar de mirarlo entero, se recorta
  una esfera con centro en $O$: la posición de la esfera determina la del
  cuerpo. Dos puntos $A$ y $B$ sobre la esfera alcanzan para fijar esa
  posición, así que basta con llevar $A_1 B_1$ hasta $A_2 B_2$.

  Como la esfera es rígida, el arco $A_1 B_1$ mide lo mismo que $A_2 B_2$.
  Trazando las bisectrices de los arcos $A_1 A_2$ y $A_2 B_2$ y llamando $C$ a
  su intersección, resulta $A_1 C = A_2 C = B_2 C$: los triángulos esféricos
  $A_1 C A_2$ y $B_1 C B_2$ son congruentes, y por lo tanto una *sola* rotación
  alrededor del eje $O C$ lleva la esfera de una posición a la otra.
  (Beer §15.12, pág. 988–989; es el *teorema de Euler*.)
]

Haciendo tender a cero el intervalo, esa rotación finita se vuelve una
velocidad angular $bold(omega)$ a lo largo de un eje que pasa por $O$: el
*eje instantáneo de rotación*. Y con él, la velocidad de cualquier punto del
cuerpo:

$ bold(v) = bold(omega) times bold(r) $ <m12-v>

$ bold(a) = bold(alpha) times bold(r) + bold(omega) times (bold(omega) times bold(r)),
  quad quad bold(alpha) = (d bold(omega))/(d t) $ <m12-a>

(Beer ecs. 15.37 a 15.39, pág. 989.)

#cuidado[
  *$bold(alpha)$ no apunta, en general, a lo largo del eje instantáneo.* En el
  movimiento plano sí: ahí $bold(omega)$ sólo puede cambiar de módulo, así que
  su derivada va en la misma dirección y todo el mundo se acostumbra a
  escribir $alpha$ como un número con signo. En tres dimensiones $bold(omega)$
  también cambia de *dirección*, y ese cambio es un pedazo de $bold(alpha)$
  que no está en el eje — de hecho suele ser perpendicular a él. Es el mismo
  fenómeno del módulo 1: la derivada de un vector tiene un término por el
  módulo y otro por la dirección, y en cartesianas el segundo no aparece.

  Consecuencia práctica, que el Beer subraya (pág. 989): *las partículas que
  están sobre el eje instantáneo tienen velocidad cero, pero no aceleración
  cero*, y las aceleraciones del cuerpo no se pueden calcular como si el
  cuerpo estuviera girando para siempre alrededor de ese eje.
]

#clave[
  *$bold(alpha)$ es la velocidad de la punta del vector $bold(omega)$.* Sale de
  la definición misma: $bold(alpha) = d bold(omega) \/ d t$ es a $bold(omega)$
  lo que $bold(v)$ es a $bold(r)$. Sirve para ver la dirección de $bold(alpha)$
  sin calcularla: es tangente a la curva que la punta de $bold(omega)$ describe
  en el espacio. Si esa curva es un círculo —que es lo que pasa en toda
  precesión estable—, $bold(alpha)$ es perpendicular a $bold(omega)$ y el
  módulo de $bold(omega)$ no cambia nunca.
]

== Las velocidades angulares se suman; las rotaciones finitas, no

#deduccion("por qué las velocidades angulares son vectores de verdad")[
  Un cuerpo con un punto fijo $O$ gira a la vez alrededor de dos ejes, con
  velocidades angulares $bold(omega)_1$ y $bold(omega)_2$. Por el teorema de
  Euler ese movimiento tiene que ser equivalente a una sola rotación
  $bold(omega)$. Para una partícula cualquiera del cuerpo, en $bold(r)$, la
  @m12-v da las tres velocidades:
  $ bold(v) = bold(omega) times bold(r), quad bold(v)_1 = bold(omega)_1 times bold(r), quad bold(v)_2 = bold(omega)_2 times bold(r) $
  Y las *velocidades lineales* sí se suman como vectores, porque son derivadas
  de vectores posición y de eso no hay ninguna duda: $bold(v) = bold(v)_1 +
  bold(v)_2$. Entonces
  $ bold(omega) times bold(r) = (bold(omega)_1 + bold(omega)_2) times bold(r) $
  para *cualquier* $bold(r)$, y eso obliga a que los dos vectores del lado
  izquierdo del producto sean el mismo. (Beer §15.12, pág. 990–991.)
]

$ bold(omega) = bold(omega)_1 + bold(omega)_2 $ <m12-suma>

#cuidado[
  *Las rotaciones finitas tienen módulo y dirección, y aun así no son
  vectores.* Girar un libro $90degree$ alrededor de $x$ y después $90degree$
  alrededor de $y$ no deja el libro donde lo dejan las dos rotaciones en el
  orden inverso: no cumplen la ley del paralelogramo, así que no se pueden
  sumar. Lo que la @m12-suma dice es que *las velocidades angulares* —o, lo que
  es lo mismo, las rotaciones infinitesimales— sí. La demostración de arriba es
  la que marca la diferencia, y es la que justifica que en toda la Parte IV se
  escriba $bold(omega)$ como una suma de contribuciones.
]

#fig([El disco del Problema 2 de la guía: la horquilla gira con
$bold(omega)_2$ alrededor de la vertical y el disco gira con $bold(omega)_1$
alrededor de su propio eje. Su velocidad angular es la *suma* de las dos, y la
recta que la contiene —punteada— es el eje instantáneo de rotación. Nótese que
ese eje no está fijo ni al espacio ni al disco: barre un cono en cada uno.],
fig-suma-omegas)

#ejemplo("El disco en la horquilla: velocidad y aceleración angulares")[
  _(Problema 2 de la sección de cuerpo rígido, en su mitad cinemática; el
  impulso angular queda para el módulo 13 y su derivada para el 14.)_ Un disco
  homogéneo de radio $r$ gira con $omega_1$ constante alrededor de su eje de
  simetría, sostenido por una horquilla que a su vez gira con $omega_2$
  constante alrededor de la vertical.

  *Los ejes.* Se toman solidarios a la *horquilla*: $hat(k)$ a lo largo del eje
  del disco, $hat(j)$ vertical (el eje de la horquilla) y $hat(i) = hat(j)
  times hat(k)$. Con esa elección los dos ejes de rotación son ejes
  coordenados, que es lo único que se le pide a una elección de ejes.

  *(a) Velocidad angular.* Por la @m12-suma, directamente:
  $ bold(omega) = omega_2 hat(j) + omega_1 hat(k), quad quad abs(bold(omega)) = sqrt(omega_1^2 + omega_2^2) $
  El eje instantáneo forma con el eje del disco un ángulo
  $arctan((omega_2)/(omega_1))$ — y no está fijo a ninguna de las dos piezas.

  *(b) Aceleración angular.* Acá aparece el resultado que sorprende: las dos
  rapideces son *constantes*, y sin embargo $bold(alpha) != 0$. El motivo es que
  $hat(k)$ —el eje del disco— gira con la horquilla, así que $bold(omega)$
  cambia de dirección aunque no cambie de módulo. Con la @m12-derivada, que se
  deduce dos secciones más abajo, y $bold(Omega) = omega_2 hat(j)$ la velocidad
  angular de los ejes elegidos:
  $ bold(alpha) = underbrace((dot(bold(omega)))_(O x y z), = 0) + bold(Omega) times bold(omega)
    = omega_2 hat(j) times (omega_2 hat(j) + omega_1 hat(k)) = omega_1 omega_2 hat(i) $

  #clave[
    *$bold(alpha)$ es perpendicular a los dos ejes de rotación y a
    $bold(omega)$.* Se comprueba en un renglón: $bold(alpha) dot bold(omega) =
    omega_1 omega_2 hat(i) dot (omega_2 hat(j) + omega_1 hat(k)) = 0$. Es el
    caso del cuadro azul de más arriba —la punta de $bold(omega)$ recorre un
    círculo, así que su velocidad es perpendicular a él— y es también el origen
    de todo el comportamiento «raro» del giróscopo: para sostener este
    movimiento hace falta una cupla en la dirección $hat(i)$, perpendicular a
    las dos rotaciones. El módulo 14 la calcula.
  ]
]

== El eje instantáneo se mueve: cono espacial y cono corporal

El eje instantáneo cambia de un instante a otro, y cambia respecto de *dos*
cosas distintas: respecto del espacio y respecto del cuerpo. Barre entonces
dos superficies cónicas con vértice en $O$ —el *cono espacial* y el *cono
corporal*—, y como en cada instante el eje pertenece a las dos, los dos conos
son tangentes a lo largo de él. El movimiento entero se resume en una imagen:
*el cono corporal rueda sin resbalar sobre el cono espacial* (Beer §15.12,
pág. 989, fig. 15.33).

#fig([Los dos conos, en el caso de precesión estable —el de los módulos 14 y
15—, donde los dos son circulares. $Z$ es el eje alrededor del cual precesa el
cuerpo; $z$ es su eje de simetría; $bold(omega)$ es el eje instantáneo, la
generatriz común. El cono corporal está clavado al cuerpo y rueda sobre el
espacial, que está clavado al espacio.], fig-conos)

#geometria[
  *Los dos conos son circulares sólo si $theta$ y $gamma$ son constantes.* En
  general el eje instantáneo puede recorrer cualquier curva, y los conos no
  son de revolución — por eso el Beer aclara al pie de la pág. 989 que «cono»
  ahí quiere decir cualquier superficie generada por una recta que pasa por un
  punto fijo. El caso circular es el que aparece en los módulos 14 y 15, y es
  el único que se resuelve con fórmulas cerradas.
]

En el disco de la horquilla los dos conos se leen del ejemplo anterior: el
cono espacial tiene eje vertical y semiángulo $arctan((omega_1)/(omega_2))$; el
corporal tiene eje sobre el eje del disco y semiángulo
$arctan((omega_2)/(omega_1))$. Los dos comparten la generatriz $bold(omega)$.

== La derivada de un vector visto desde un sistema que rota

Éste es el resultado central del módulo, y el que el resto de la Parte IV usa
todo el tiempo. La pregunta es sencilla de enunciar: un mismo vector, mirado
desde un sistema fijo y desde uno que gira, ¿tiene la misma derivada? No — y
la diferencia es exactamente un producto vectorial.

#deduccion("cómo se relacionan las dos derivadas")[
  Dos sistemas con el mismo origen $O$: uno fijo, $O X Y Z$, y uno que gira con
  velocidad angular $bold(Omega)$, $O x y z$. Un vector cualquiera $bold(Q)(t)$
  se escribe en la base que gira:
  $ bold(Q) = Q_x hat(i) + Q_y hat(j) + Q_z hat(k) $
  Derivando y tratando a $hat(i)$, $hat(j)$, $hat(k)$ como *fijos* —que es lo
  que hace un observador montado en el sistema que gira— sale la derivada
  relativa:
  $ (dot(bold(Q)))_(O x y z) = dot(Q)_x hat(i) + dot(Q)_y hat(j) + dot(Q)_z hat(k) $
  Para el observador fijo hay que derivar *también* los tres versores. Los
  términos que aparecen, $Q_x dot(hat(i)) + Q_y dot(hat(j)) + Q_z dot(hat(k))$,
  son lo único que quedaría si $bold(Q)$ estuviera clavado al sistema que gira:
  y en ese caso $bold(Q)$ es el vector posición de un punto que rota con
  $bold(Omega)$, así que por la @m12-v esa suma vale $bold(Omega) times
  bold(Q)$. (Beer §15.10, pág. 975–976.)
]

$ (dot(bold(Q)))_(O X Y Z) = (dot(bold(Q)))_(O x y z) + bold(Omega) times bold(Q) $ <m12-derivada>

#fig([La @m12-derivada, en sus dos casos. *Izquierda:* si $bold(Q)$ está
clavado al sistema que rota, su punta recorre un círculo de radio $Q sin
theta$ y su derivada es la velocidad de esa punta, $bold(Omega) times
bold(Q)$, tangente al círculo y de módulo $Omega Q sin theta$. *Derecha:* si
además $bold(Q)$ cambia dentro del sistema, las dos contribuciones se suman
como vectores.], fig-vector-rotante)

#clave[
  *Los versores polares del módulo 1 son este teorema, en el caso más chico que
  hay.* Un sistema plano que gira con la partícula tiene $bold(Omega) =
  dot(theta) hat(k)$, y sus versores están clavados a él, así que su derivada
  relativa es cero. La @m12-derivada da entonces
  $ (d hat(r))/(d t) = dot(theta) hat(k) times hat(r) = dot(theta) hat(theta),
    quad quad (d hat(theta))/(d t) = dot(theta) hat(k) times hat(theta) = -dot(theta) hat(r) $
  que es exactamente lo que el módulo 1 dedujo con un triangulito y un límite.
  No es una coincidencia ni una analogía: es el mismo teorema, y por eso todo
  lo que se aprendió a hacer en polares vuelve a servir acá sin traducción.
]

#geometria[
  *$bold(Omega)$ es la velocidad angular del SISTEMA; $bold(omega)$ es la del
  CUERPO. No siempre son la misma, y confundirlas es el error caro de este
  tema.* Si los ejes se clavan al cuerpo, entonces sí $bold(Omega) =
  bold(omega)$ — pero clavarlos al cuerpo no siempre conviene. En un cuerpo con
  simetría de revolución, los momentos de inercia son los mismos en *cualquier*
  sistema que acompañe al eje de simetría, gire o no gire con el cuerpo
  alrededor de él; y elegir un sistema que *precede pero no gira* deja las
  cuentas mucho más simples (Beer §18.5, pág. 1170). En ese caso $bold(Omega)
  != bold(omega)$, y la @m12-derivada hay que aplicarla con $bold(Omega)$, no
  con $bold(omega)$.

  La regla, entonces: *en la @m12-derivada va siempre la velocidad angular del
  sistema desde el que se mira.* Antes de escribirla, decir en voz alta a qué
  está clavado el sistema elegido.
]

#notacion[
  *«Razón de cambio» quiere decir «derivada respecto del tiempo»* — es el
  comentario textual de la cátedra sobre esta misma sección del Beer, y sobre
  la §12.7 que ya se usó en el módulo 7. El Beer traducido la usa en todos los
  títulos, y el subíndice del paréntesis dice *respecto de qué sistema* se
  deriva, no respecto de qué variable.
]

#ejemplo("El volante en el gimbal: por qué hace falta una cupla", nivel: "a fondo")[
  _(Problema 3 de la sección de cuerpo rígido, en su mitad cinemática. La
  aceleración angular del gimbal, que es lo que el enunciado pide, sale en el
  módulo 14 con las ecuaciones de Euler; acá se resuelve la parte de la que
  esa cuenta depende.)_ Un volante gira con $omega_s = 100$ rad/s constante
  alrededor de $z$. Está montado en un gimbal —sin peso— sobre una plataforma
  que gira con $omega_p = 0,5$ rad/s constante alrededor de $y$. Los ejes
  $x y z$ están clavados *al gimbal*, y el gimbal arranca quieto respecto de
  la plataforma.

  *(a) La velocidad angular del volante.* Por la @m12-suma, y en el instante en
  que el gimbal todavía no gira respecto de la plataforma:
  $ bold(omega) = omega_p hat(j) + omega_s hat(k) = 0,5 hat(j) + 100 hat(k) " rad/s" $
  $ abs(bold(omega))^2 = 0,5^2 + 100^2 = 10 thin 000,25 ==> abs(bold(omega)) = 100,001 " rad/s" $
  El eje instantáneo está a $arctan(0,005) = 0,29degree$ del eje de giro: casi
  encima, y esa cercanía es la que hace que el volante «se sienta» como un
  giróscopo.

  *(b) La velocidad angular de los ejes.* Los ejes están clavados al gimbal,
  que en ese instante sólo acompaña a la plataforma:
  $ bold(Omega) = omega_p hat(j) = 0,5 hat(j) " rad/s" $

  #geometria[
    *$bold(Omega) != bold(omega)$, y ésta es la línea del problema donde se
    pierde el planteo.* El volante gira con $100 " rad/s"$ alrededor de $z$; el
    gimbal, no. Los ejes acompañan al gimbal, así que su velocidad angular no
    tiene componente $z$. Meter el spin adentro de $bold(Omega)$ da un
    $bold(alpha)$ absurdo y una cupla equivocada por un factor de doscientos.
  ]

  *(c) La aceleración angular del volante.* Las dos rapideces son constantes y
  las dos direcciones son ejes coordenados, así que la derivada relativa se
  anula y queda sólo el producto vectorial de la @m12-derivada:
  $ bold(alpha) = (dot(bold(omega)))_(O x y z) + bold(Omega) times bold(omega)
    = 0 + 0,5 hat(j) times (0,5 hat(j) + 100 hat(k)) = 50 hat(i) " rad/s²" $

  #clave[
    *Nada acelera y sin embargo hay una aceleración angular de $50$ rad/s²,
    perpendicular a las dos rotaciones.* Ése es el efecto giroscópico entero,
    ya visible sin haber escrito una sola ecuación de la dinámica: obligar a un
    volante que gira rápido a precesar despacio le produce una $bold(alpha)$
    grande en la tercera dirección, y por lo tanto exige una cupla grande en
    esa dirección. Es lo que hace el *torquer* del enunciado, y por qué la
    respuesta del problema —$600$ N·m producen sólo $20$ rad/s² de
    aceleración del gimbal— no es la que uno esperaría dividiendo cupla por
    inercia.
  ]
]

== Dos puntos cualesquiera: el movimiento general

Si el cuerpo no tiene ningún punto fijo, se elige un punto $A$ del cuerpo como
referencia y se mira el movimiento *relativo* a un sistema que traslada con
$A$ pero no rota. Respecto de ese sistema, $A$ está fijo — y vale todo lo de
arriba:

$ bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B slash A) $ <m12-vgen>

$ bold(a)_B = bold(a)_A + bold(alpha) times bold(r)_(B slash A)
  + bold(omega) times (bold(omega) times bold(r)_(B slash A)) $ <m12-agen>

(Beer ecs. 15.43 y 15.44, pág. 991.) Todo movimiento de un cuerpo rígido es,
en cada instante, una traslación con la velocidad de un punto cualquiera más
una rotación alrededor de ese punto.

#clave[
  *$bold(omega)$ y $bold(alpha)$ no dependen del punto de referencia elegido.*
  Se despeja la @m12-vgen para $bold(v)_A$ y sale la misma relación con los
  papeles de $A$ y $B$ cambiados, con los *mismos* $bold(omega)$ y
  $bold(alpha)$. Es lo que permite hablar de «la velocidad angular del cuerpo»
  sin aclarar respecto de qué punto, algo que con el momento angular —módulo
  7— nunca se puede hacer.
]

== Una partícula vista desde un sistema que rota: Coriolis en tres dimensiones

Falta el caso en que lo que se mueve no está clavado al cuerpo: una partícula
que se desplaza *dentro* de un sistema que además gira. Se aplica la
@m12-derivada dos veces —una a $bold(r)$ y otra al resultado— y sale:

$ bold(v)_P = bold(Omega) times bold(r) + (dot(bold(r)))_(O x y z) $ <m12-coriolis-v>

$ bold(a)_P = dot(bold(Omega)) times bold(r)
  + bold(Omega) times (bold(Omega) times bold(r))
  + 2 bold(Omega) times (dot(bold(r)))_(O x y z)
  + (dot.double(bold(r)))_(O x y z) $ <m12-coriolis-a>

(Beer ecs. 15.45 y 15.47, pág. 1002.) El tercer término es la *aceleración de
Coriolis*, $bold(a)_c = 2 bold(Omega) times bold(v)_(P slash cal(F))$. Si
además el origen del sistema móvil se traslada, se le suma $bold(a)_A$ y las
posiciones se miden desde $A$ (Beer ecs. 15.52 y 15.54, pág. 1004): nada más
cambia.

#clave[
  *La aceleración en polares del módulo 1 es la @m12-coriolis-a, y se comprueba
  en cuatro renglones.* Con $bold(Omega) = dot(theta) hat(k)$ y $bold(r) = r
  hat(r)$, término por término:
  $ dot(bold(Omega)) times bold(r) = r dot.double(theta) hat(theta), quad
    bold(Omega) times (bold(Omega) times bold(r)) = -r dot(theta)^2 hat(r) $
  $ 2 bold(Omega) times (dot(bold(r)))_(O x y z) = 2 dot(r) dot(theta) hat(theta), quad
    (dot.double(bold(r)))_(O x y z) = dot.double(r) hat(r) $
  y sumando queda $bold(a) = (dot.double(r) - r dot(theta)^2) hat(r) + (r
  dot.double(theta) + 2 dot(r) dot(theta)) hat(theta)$, que es la del módulo 1
  sin cambiarle una letra. Los cuatro términos que ahí había que aprender de
  memoria son, uno a uno, los cuatro de la @m12-coriolis-a.
]

#cuidado[
  *En tres dimensiones $abs(bold(a)_c)$ no vale $2 Omega v_"rel"$.* En el
  movimiento plano $bold(Omega)$ y la velocidad relativa son siempre
  perpendiculares, y el módulo del producto vectorial se simplifica; en el
  espacio no tienen por qué serlo, así que hay que calcular el producto
  vectorial completo. Y hay dos casos en que la aceleración de Coriolis
  *desaparece*: cuando $bold(Omega)$ y $bold(v)_"rel"$ son paralelos, y cuando
  alguno de los dos es cero. (Beer, pág. 1003.)
]

#guia("qué ejercicios cubre este módulo")[
  *La sección de cuerpo rígido de la guía no trae ningún problema puramente
  cinemático*, así que —igual que con el centro de masa en la Parte II— acá no
  se inventa uno: se usan las *mitades cinemáticas* de los Problemas 2 (el
  disco en la horquilla) y 3 (el volante en el gimbal), que son la primera
  cuenta que los dos piden, y los módulos 13 y 14 los terminan con las mismas
  letras y los mismos ejes. Los dos ejemplos de acá y los de los dos módulos
  siguientes son, entonces, dos problemas resueltos enteros y no cuatro
  problemas sueltos.
]

== Lo que se usa después

1. *La @m12-derivada.* Es la herramienta del módulo 14: el momento angular de
   un cuerpo rígido se calcula en ejes que acompañan al cuerpo —los únicos en
   los que los momentos de inercia no cambian con el tiempo— y después hay que
   derivarlo respecto del espacio fijo, que es lo único que la segunda ley de
   Newton acepta. Ese paso es la @m12-derivada, y de él salen las ecuaciones
   de Euler.

2. *La @m12-suma.* Toda velocidad angular de la Parte IV se escribe como una
   suma: precesión más nutación más giro. Los tres ángulos de Euler del módulo
   14 son exactamente eso.

3. *Los dos conos.* Son la forma de *ver* un movimiento de precesión sin
   resolver ninguna ecuación, y en el módulo 15 la posición relativa de los dos
   —uno afuera del otro, o uno adentro del otro— es lo que distingue una
   precesión directa de una retrógrada.
