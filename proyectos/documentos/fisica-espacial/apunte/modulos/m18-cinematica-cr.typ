#import "../plantilla.typ": *
// voz: 2026-09-25 -- pasada de la fase 11, tanda (d)

#modulo("Cinemática del cuerpo rígido y sistemas rotantes", clave: "cinematica-cr")[
  Describir cómo se mueve un cuerpo que ya no es un punto: por qué todo
  movimiento con un punto fijo es una rotación alrededor de un eje que
  cambia de un instante a otro, por qué las velocidades angulares se suman
  como vectores aunque las rotaciones finitas no, y —el resultado que
  sostiene los tres módulos que siguen— cómo se deriva un vector cuando el
  sistema desde el que se lo mira está girando. Con eso queda armado el
  aparato que en el módulo #M("euler-giroscopo") produce las ecuaciones de Euler.
]

Hasta el módulo #M("tres-cuerpos"), cada cuerpo fue un *punto*: una masa sin tamaño, con una
posición y nada más. El módulo #M("rotacion") hizo una trampa honesta —le dio
tamaño al cuerpo pero le clavó el eje de giro en una dirección fija— y acá esa
trampa se termina. Alcanzó para una órbita entera
porque la Tierra vista desde $42 thin 000$ km efectivamente es un punto. Deja
de alcanzar apenas la pregunta cambia de *dónde está* el satélite a *hacia
dónde apunta*: una antena, una cámara, un panel solar y un motor apuntan a
algún lado, y ese lado es lo que hay que controlar. Un satélite en la órbita
perfecta con la antena mirando al Sol es chatarra muy bien ubicada.

#gancho[Todo lo que viene de acá al final del apunte contesta una sola
pregunta de ingeniería: cómo se controla hacia dónde apunta un satélite, y
qué hace solo si nadie lo controla. Las respuestas están entre las más raras
de la física clásica. Un cuerpo que gira rápido se resiste a que le cambien
el eje y, si se lo empuja, se corre de costado: es el giróscopo, y con él se
navega sin GPS. Un satélite que gira alrededor del eje equivocado termina
dando tumbos sin que nada lo toque: le pasó al Explorer 1. Una cupla chiquita
puesta en el lugar justo produce una enorme en otro: es el CMG, con el que se
apuntan estaciones espaciales enteras. Entender esta parte es poder predecir
todo eso antes de lanzar. Lo simple: sale de una sola ley, cupla igual a
cambio del momento angular. Lo complicado son dos cosas que en el plano no
existían: en tres dimensiones el momento angular y la velocidad angular dejan
de apuntar para el mismo lado, y los ejes desde los que conviene mirar giran
ellos también. Este módulo arma la segunda dificultad —los ejes que giran—;
el que sigue, la primera.]

Este módulo es, casi de punta a punta, el Beer, capítulo 15: la cátedra arma
la lista de cuerpo rígido entera sobre el Beer, y avisa de entrada que «son
muy útiles los resúmenes que hace el Beer al final (o a la mitad) de cada
capítulo». Hay que darle la razón: los resúmenes existen y son buenos. Lo que
la frase no dice es que para llegar al resumen hay que atravesar el capítulo.

#definicion("cuerpo rígido")[
  Un sistema de partículas en el que la distancia entre dos cualesquiera de
  ellas no cambia nunca. Es una idealización —todo se deforma un poco— pero es
  exactamente la que hace falta: al fijar todas las distancias, la posición de
  un cuerpo entero queda determinada por *seis* números y no por $3N$.

  Tres de esos seis son la posición del centro de masa, y ésos ya están
  resueltos: el teorema del módulo #M("centro-de-masa") dice que el centro de masa se mueve como
  un punto de masa $M$ empujado por la resultante de las fuerzas externas, y
  las Partes III y IV enteras fueron eso. Los otros tres son la *orientación*,
  y de ellos se ocupa esta parte. (El Roederer, §5.b, llega a los mismos
  seis números en la pág. 165.)
]

En ingeniería espacial esa partición tiene nombre propio, y conviene usarlo
desde ya: los tres números del centro de masa son la *órbita* y los tres de
la orientación son la *actitud*. Son dos subsistemas distintos de un
satélite, con sus propios sensores, actuadores y gente que se pelea por la
masa disponible. Lo dice así la primera clase escrita de cuerpo rígido de la
cátedra, que en la lista de temas dejó el renglón «Definición CR» con un
signo de pregunta en la columna del libro; el Beer no la escribe en ningún
lado con todas las letras, y la definición de arriba es la que corresponde.

Y la palabra que más importa de esa definición es *idealización*. La misma
clase lo advierte: un satélite con paneles solares flexibles, combustible que
chapotea en el tanque (el *sloshing*) o antenas que vibran no es del todo
rígido, y «esa diferencia será clave». Lo es: la energía que se pierde en
esos movimientos internos fue lo que hizo dar tumbos al primer satélite
norteamericano, y la historia está al final del módulo #M("euler-giroscopo").

#lectura[
  *Roederer, capítulo 5* («Dinámica del cuerpo rígido»), §5.b («Cinemática del
  cuerpo rígido», pág. 161) y §5.h («Sistemas no-inerciales en rotación», pág.
  193). *Beer, Dinámica, capítulo 15* («Cinemática de cuerpos rígidos»),
  §15.10 («Razón de cambio de un vector con respecto a un sistema de
  referencia en rotación», pág. 975) y §15.11 («...Aceleración de Coriolis»,
  pág. 977); las secciones \*15.12 a \*15.14 (pág. 988–1004) extienden lo mismo
  a tres dimensiones. El Beer les pone asterisco de opcionales; la lista de la
  cátedra se los saca sin decir nada, y el cono espacial y la suma de
  velocidades angulares —§15.12— entran al parcial igual.

  Beer trae la deducción de la derivada en un sistema rotante con más detalle
  algebraico y es la fuente de la fórmula que sostiene los módulos que siguen;
  Roederer conecta el mismo resultado con el marco no inercial del módulo
  #M("marcos"), que es el hilo que este módulo retoma. Y para *ver* la
  derivada antes de hacerla: *Curtis, §1.6* («Time derivatives of moving
  vectors», págs. 21–26), con la Fig. 1.15, que la cátedra mandó a mirar
  para la clase del 19/10.
]

== Con un punto fijo, todo movimiento es una rotación

#gancho[Reduce cualquier movimiento de un cuerpo con un punto fijo —un trompo
sobre su punta, un satélite girando alrededor de su centro de masa— a una
sola flecha, $bold(omega)$: un eje y una rapidez. Con esa flecha se saca la
velocidad de cualquier punto del cuerpo con un producto vectorial, sin
seguirlos de a uno: dónde está la punta de un panel, cuán rápido se mueve una
antena. Lo que lo complica es que el eje no se queda quieto, y de eso sale
todo lo raro del resto de la parte.]

#duda[Si el cuerpo se puede mover de cualquier manera, ¿cómo puede ser que en cada instante gire alrededor de un solo eje?]
#dedos[Pinchá una naranja por el centro con un tenedor —ése es el punto
fijo— y marcale dos puntos con birome. Llevala a cualquier posición nueva,
con todas las vueltas que se te ocurran. Siempre existe un pinche, una recta
por el centro, alrededor del cual *un solo giro* la habría dejado igual. La
demostración de abajo lo prueba con dos puntos y dos bisectrices; la naranja
lo prueba en la cocina.]

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

Lindo teorema para una demostración que entra en un párrafo: no importa cuán
borracho sea el movimiento, si hay un punto fijo, cada instante es una
rotación pura. Haciendo tender a cero el intervalo, esa rotación finita se
vuelve una velocidad angular $bold(omega)$ a lo largo de un eje que pasa por
$O$: el *eje instantáneo de rotación*. Y con él, la velocidad de cualquier
punto del cuerpo:

$ bold(v) = bold(omega) times bold(r) $ <cin-v>

$ bold(a) = bold(alpha) times bold(r) + bold(omega) times (bold(omega) times bold(r)),
  quad quad bold(alpha) = (d bold(omega))/(d t) $ <cin-a>

(Beer ecs. 15.37 a 15.39, pág. 989.)

#duda[Si la rapidez de giro no cambia nunca, ¿puede haber aceleración angular?]
#dedos[Sí. $bold(omega)$ es una flecha, y $bold(alpha)$ es la velocidad de su
punta. Si la flecha gira sin estirarse —un trompo que precesa, una rueda de
auto en una curva—, su punta se mueve, y eso es $bold(alpha)$, de costado. Es
lo mismo que la piedra revoleada: rapidez constante, aceleración que no es
cero, porque la velocidad cambia de *dirección*.]

#cuidado[
  *$bold(alpha)$ no apunta, en general, a lo largo del eje instantáneo.* En el
  movimiento plano sí: ahí $bold(omega)$ sólo puede cambiar de módulo, así que
  su derivada va en la misma dirección y todo el mundo se acostumbra a
  escribir $alpha$ como un número con signo. En tres dimensiones $bold(omega)$
  también cambia de *dirección*, y ese cambio es un pedazo de $bold(alpha)$
  que no está en el eje — de hecho suele ser perpendicular a él. Es el mismo
  fenómeno del módulo #M("vectores"): la derivada de un vector tiene un término por el
  módulo y otro por la dirección, y en cartesianas el segundo no aparece.

  Consecuencia práctica, que el Beer subraya (pág. 989): *las partículas que
  están sobre el eje instantáneo tienen velocidad cero, pero no aceleración
  cero*, y las aceleraciones del cuerpo no se pueden calcular como si el
  cuerpo estuviera girando para siempre alrededor de ese eje. Estar quieto un
  instante no es estar quieto: pregúntenle a una pelota en el punto más alto
  del tiro vertical.
]

#posta[
  El eje instantáneo es como la bisagra de una puerta que se mueve mientras
  la puerta gira: en cada instante hay una recta que no se mueve, pero no es
  siempre la misma recta. Y como la bisagra se mueve, la derivada de
  $bold(omega)$ tiene un pedazo que no apunta a lo largo de $bold(omega)$.
  Si en un problema $bold(alpha)$ te sale paralela a $bold(omega)$ en 3D,
  sospechá antes de festejar.
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

#gancho[Te deja armar la velocidad angular de un mecanismo de piezas
articuladas sumando lo que aporta cada articulación: el disco en su horquilla,
el giróscopo en sus cardanes, el rotor de un CMG dentro de un satélite que
maniobra. Es la primera cuenta de casi todo problema de esta parte, y la que
pide escribir el parcialito. Lo simple: es una suma. Lo traicionero: cada
sumando se mide respecto de una pieza distinta, y los giros *grandes* no se
suman.]

#duda[¿Por qué las velocidades angulares se pueden sumar, si los giros de un libro no?]
#dedos[Por lo mismo que en la cinta del aeropuerto: si la cinta te lleva a
1 m/s y vos caminás a 1 m/s sobre ella, vas a 2 m/s respecto del piso. Cada
pieza «camina» sobre la que la sostiene: el disco gira sobre la horquilla, la
horquilla sobre el piso. Los giros grandes, en cambio, dependen del orden
—el libro de abajo lo muestra—. Una velocidad angular es un giro chiquito, de
un instante, y con giros chiquitos el orden deja de importar.]

#deduccion("por qué las velocidades angulares son vectores de verdad")[
  Un cuerpo con un punto fijo $O$ gira a la vez alrededor de dos ejes, con
  velocidades angulares $bold(omega)_1$ y $bold(omega)_2$. Por el teorema de
  Euler ese movimiento tiene que ser equivalente a una sola rotación
  $bold(omega)$. Para una partícula cualquiera del cuerpo, en $bold(r)$, la
  @cin-v da las tres velocidades (la deducción es la del Beer §15.12,
  paso por paso):
  $ bold(v) = bold(omega) times bold(r), quad bold(v)_1 = bold(omega)_1 times bold(r), quad bold(v)_2 = bold(omega)_2 times bold(r) $
  Y las *velocidades lineales* sí se suman como vectores, porque son derivadas
  de vectores posición y de eso no hay ninguna duda: $bold(v) = bold(v)_1 +
  bold(v)_2$. Entonces
  $ bold(omega) times bold(r) = (bold(omega)_1 + bold(omega)_2) times bold(r) $
  para *cualquier* $bold(r)$, y eso obliga a que los dos vectores del lado
  izquierdo del producto sean el mismo. (Beer §15.12, pág. 990–991.)
]

$ bold(omega) = bold(omega)_1 + bold(omega)_2 $ <cin-suma>

#cuidado[
  *Las rotaciones finitas tienen módulo y dirección, y aun así no son
  vectores.* Girar un libro $90degree$ alrededor de $x$ y después $90degree$
  alrededor de $y$ no deja el libro donde lo dejan las dos rotaciones en el
  orden inverso: no cumplen la ley del paralelogramo, así que no se pueden
  sumar. Lo que la @cin-suma dice es que *las velocidades angulares* —o, lo que
  es lo mismo, las rotaciones infinitesimales— sí. La demostración de arriba es
  la que marca la diferencia, y es la que justifica que en toda la Parte V se
  escriba $bold(omega)$ como una suma de contribuciones. Se prueba con
  cualquier libro que haya a mano —el Beer sirve, y es de las pocas cosas para
  las que su peso ayuda—: dos vueltas de $90degree$ en un orden, dos en el
  otro, y el libro queda mirando para lados distintos.
]

#fig([El disco del Problema 2 de la guía: la horquilla gira con
$bold(omega)_2$ alrededor de la vertical y el disco gira con $bold(omega)_1$
alrededor de su propio eje. Su velocidad angular es la *suma* de las dos, y la
recta que la contiene —punteada— es el eje instantáneo de rotación. Nótese que
ese eje no está fijo ni al espacio ni al disco: barre un cono en cada uno.],
fig-suma-omegas)

#ejemplo("El disco en la horquilla: velocidad y aceleración angulares")[
  _(Guía de la cátedra 2026, sección Cuerpo rígido, Problema 2, en su mitad
  cinemática; el momento angular queda para el módulo #M("inercia") y su
  derivada para el #M("euler-giroscopo"). La resolución de la cátedra es
  «Ejercicio 2 CR 2026», de la clase del 19/10.)_ Un disco
  homogéneo de radio $r$ gira con $omega_1$ constante alrededor de su eje de
  simetría, sostenido por una horquilla que a su vez gira con $omega_2$
  constante alrededor de la vertical.

  *Los ejes.* Se toman solidarios a la *horquilla*: $hat(k)$ a lo largo del eje
  del disco, $hat(j)$ vertical (el eje de la horquilla) y $hat(i) = hat(j)
  times hat(k)$. Con esa elección los dos ejes de rotación son ejes
  coordenados, que es lo único que se le pide a una elección de ejes.

  *(a) Velocidad angular.* Por la @cin-suma, directamente:
  $ bold(omega) = omega_2 hat(j) + omega_1 hat(k), quad quad abs(bold(omega)) = sqrt(omega_1^2 + omega_2^2) $
  El eje instantáneo forma con el eje del disco un ángulo
  $arctan((omega_2)/(omega_1))$ — y no está fijo a ninguna de las dos piezas.

  *(b) Aceleración angular.* Acá aparece el resultado que sorprende: las dos
  rapideces son *constantes*, y sin embargo $bold(alpha) != 0$. El motivo es que
  $hat(k)$ —el eje del disco— gira con la horquilla, así que $bold(omega)$
  cambia de dirección aunque no cambie de módulo. Con la @cin-derivada, que se
  deduce dos secciones más abajo, y $bold(Omega) = omega_2 hat(j)$ la velocidad
  angular de los ejes elegidos#burbuja[$bold(Omega)$: la velocidad angular de
  los *ejes* que elegiste —acá, clavados a la horquilla—, respecto del
  espacio. No es la del disco, $bold(omega)$. Y $(dot(bold(omega)))_(O x y z)$
  es cómo cambia $bold(omega)$ vista *desde la horquilla*: cero, porque desde
  ahí los dos giros son constantes y sobre ejes quietos.]:
  $ bold(alpha) = underbrace((dot(bold(omega)))_(O x y z), = 0) + bold(Omega) times bold(omega)
    = omega_2 hat(j) times (omega_2 hat(j) + omega_1 hat(k)) = omega_1 omega_2 hat(i) $

  #clave[
    *$bold(alpha)$ es perpendicular a los dos ejes de rotación y a
    $bold(omega)$.* Se comprueba en un renglón: $bold(alpha) dot bold(omega) =
    omega_1 omega_2 hat(i) dot (omega_2 hat(j) + omega_1 hat(k)) = 0$. Es el
    caso de la idea de más arriba —la punta de $bold(omega)$ recorre un
    círculo, así que su velocidad es perpendicular a él— y es también el origen
    de todo el comportamiento «raro» del giróscopo: para sostener este
    movimiento hace falta una cupla en la dirección $hat(i)$, perpendicular a
    las dos rotaciones. El módulo #M("euler-giroscopo") la calcula.
  ]
]

== El eje instantáneo se mueve: cono espacial y cono corporal

#gancho[Es la manera de *ver* una precesión sin resolver una sola ecuación.
Dos conos y una regla de juego —uno rueda sobre el otro— te dicen hacia
dónde se mueve el eje de un cuerpo que gira libre, y en el módulo #M("peonza")
te dicen si precesa para el mismo lado que su spin o al revés, que es la
pregunta que separa un satélite achatado de uno alargado.]

#duda[¿Qué rueda sobre qué? ¿Esos conos son algo del cuerpo, o un dibujo?]
#dedos[Son un dibujo, pero de algo real. Imaginá dos conos de cartulina: uno
pegado al cuerpo, otro pegado a la pieza donde estás vos. El cuerpo se mueve
exactamente como si su cono rodara sobre el tuyo sin patinar. La recta donde
se tocan es el eje instantáneo: como el punto de una rueda que toca el piso,
los puntos del cuerpo que están sobre ella, en ese instante, no se mueven.]

El eje instantáneo cambia de un instante a otro, y cambia respecto de *dos*
cosas distintas: respecto del espacio y respecto del cuerpo. Barre entonces
dos superficies cónicas con vértice en $O$ —el *cono espacial* y el *cono
corporal*—, y como en cada instante el eje pertenece a las dos, los dos conos
son tangentes a lo largo de él. El movimiento entero se resume en una imagen:
*el cono corporal rueda sin resbalar sobre el cono espacial* (Beer §15.12,
pág. 989, fig. 15.33).

#fig([Los dos conos, en el caso de precesión estable —el de los módulos #M("euler-giroscopo") y
#M("peonza")—, donde los dos son circulares. $Z$ es el eje alrededor del cual precesa el
cuerpo; $z$ es su eje de simetría; $bold(omega)$ es el eje instantáneo, la
generatriz común. El cono corporal está clavado al cuerpo y rueda sobre el
espacial, que está clavado al espacio.], fig-conos)

#geometria[
  *Los dos conos son circulares sólo si $theta$ y $gamma$ son constantes.* En
  general el eje instantáneo puede recorrer cualquier curva, y los conos no
  son de revolución — por eso el Beer aclara al pie de la pág. 989 que «cono»
  ahí quiere decir cualquier superficie generada por una recta que pasa por un
  punto fijo. El caso circular es el que aparece en los módulos #M("euler-giroscopo") y #M("peonza"), y es
  el único que se resuelve con fórmulas cerradas.
]

Es de esas imágenes que parecen poesía de libro y resultan ser la forma más
barata de no equivocarse con un signo. En el disco de la horquilla los dos
conos se leen del ejemplo anterior (Beer §15.12, fig. 15.33): el
cono espacial tiene eje vertical y semiángulo $arctan((omega_1)/(omega_2))$; el
corporal tiene eje sobre el eje del disco y semiángulo
$arctan((omega_2)/(omega_1))$. Los dos comparten la generatriz $bold(omega)$.

== La derivada de un vector visto desde un sistema que rota

Éste es el resultado central del módulo, y el que el resto de esta parte usa
todo el tiempo: es el Beer §15.10, ec. 15.31 (pág. 976), que el propio Beer
bautiza «relación fundamental» y que la lista de la cátedra marca con número
—no marca muchas—. La pregunta es
sencilla de enunciar: un mismo vector, mirado desde un sistema fijo y desde
uno que gira, ¿tiene la misma derivada? No — y la diferencia es exactamente
un producto vectorial. Si de todo el módulo queda una sola línea, que sea
ésta.

El módulo #M("marcos") ya contestó esta pregunta para el caso chico: plano, y
con $bold(Omega)$ constante. Lo que sigue es el caso general —tres dimensiones,
y un $bold(Omega)$ que puede cambiar—, y de él la @marcos-rotante sale como
caso particular: no son dos resultados, es uno y su recorte.

#gancho[Es la llave de toda la Parte V, y la que más se confunde, así que
vale la pena venderla bien. La segunda ley de Newton —cupla igual a cambio
del momento angular— sólo vale para el que mira desde el espacio. Pero los
números lindos, los momentos de inercia que no cambian, viven en ejes
clavados al cuerpo, que giran. Este teorema es el traductor entre los dos: te
deja hacer la cuenta en los ejes cómodos y devolverle a Newton lo que pide.
La consecuencia es que aparecen términos que nadie puso a mano —el efecto
giroscópico, la centrífuga, Coriolis— y que son exactamente el precio de
mirar desde algo que gira. Lo simple: es una suma de dos términos. Lo que
cuesta: decidir quién mira, en qué ejes se anota y qué $bold(Omega)$ va.]

*Antes de la cuenta, las cuatro preguntas de cada vector.* La mitad de los
errores de esta parte no son de álgebra: son de no haberse hecho alguna de
estas cuatro preguntas. De acá al final del apunte cada vector las tiene
contestadas, y al pie de las páginas, en un globito, se recuerdan donde hagan
falta.

#figure(
  table(
    columns: (1.15fr, 1.9fr, 2fr),
    inset: 5pt,
    align: left,
    table.header([*La pregunta*], [*Qué contesta*], [*Dónde se lee en la notación*]),
    [¿Qué es?], [la cantidad física: velocidad angular, momento angular, cupla], [la letra: $bold(omega)$, $bold(H)$, $bold(M)$],
    [¿Respecto de qué punto?], [sólo para lo que depende del punto: la posición, el momento angular, la cupla], [el subíndice de la letra: $bold(H)_G$ respecto del centro de masa, $bold(H)_O$ respecto de un punto fijo $O$],
    [¿Quién lo mira para derivarlo?], [qué sistema considera quietos sus ejes al decir «cambió»], [el subíndice del paréntesis: $(dot(bold(Q)))_(O X Y Z)$ el fijo, $(dot(bold(Q)))_(O x y z)$ el que gira],
    [¿En qué ejes se anota?], [la base de las componentes: la regla con que se mide], [los versores que aparecen: los del fijo, o $hat(i)$, $hat(j)$, $hat(k)$ del que gira],
  ),
  caption: [Las cuatro preguntas. Las dos últimas son *independientes*: se puede derivar mirando desde el espacio y anotar el resultado en los ejes del cuerpo, y es exactamente lo que hacen las ecuaciones de Euler del módulo #M("euler-giroscopo").],
)

#duda[La derivada de un vector, ¿no es una sola? ¿Cómo puede depender de quién la mira?]
#dedos[Pintá una flecha en el piso de una calesita, del centro hacia el
borde. El chico que va arriba la ve siempre igual: para él la flecha no
cambia, y su derivada es cero. La mamá que mira desde afuera la ve dar
vueltas: para ella la punta se mueve todo el tiempo. Los dos tienen razón,
porque «cambió» quiere decir «cambió *comparada con algo*», y cada uno compara
contra lo que tiene quieto adelante. La diferencia entre lo que ven los dos
es lo que el giro de la calesita le agrega a la flecha: un producto
vectorial, el de la fórmula de abajo.]

#duda[Si escribo un vector con los versores del sistema que gira, ¿ya lo estoy mirando desde el sistema que gira?]
#dedos[No, y es la confusión que más cuesta en toda la parte. Una cosa es
*quién mira* para decir cuánto cambió el vector; otra, *con qué regla anota*
el resultado. Un auto que dobla: cuánto cambió su velocidad lo dice alguien
parado en la vereda —eso es «mirado desde el espacio»—, y ese cambio lo podés
anotar como «tanto hacia adelante del auto y tanto hacia su izquierda» —eso
es «escrito en los ejes del auto»—. Las dos cosas a la vez, sin
contradicción. En la fórmula, el subíndice del paréntesis dice quién mira;
los versores en que después anotes el resultado son otra elección, y libre.]

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
  $bold(Omega)$, así que por la @cin-v esa suma vale $bold(Omega) times
  bold(Q)$. (Beer §15.10, pág. 975–976.)
]

$ (dot(bold(Q)))_(O X Y Z) = (dot(bold(Q)))_(O x y z) + bold(Omega) times bold(Q) $ <cin-derivada>

El Curtis llega a lo mismo en dos escalones, y el primero vale la pena
mirarlo solo. Su Fig. 1.15 es un vector $bold(A)$ de módulo fijo pintado
sobre un cuerpo que gira: en un $dif t$ el cuerpo gira $dif theta = omega dif
t$ alrededor del eje instantáneo, y la punta de $bold(A)$ recorre un arquito
de radio $A sin phi$, con $phi$ el ángulo entre $bold(A)$ y el eje. Ese
arquito, con su dirección, es un producto vectorial: $dif bold(A)\/dif t =
bold(omega) times bold(A)$ si el módulo no cambia (Curtis ec. 1.52, pág. 23).
El segundo escalón es aplicarle eso a los tres versores de una terna que gira,
y sale la @cin-derivada (Curtis ec. 1.56, pág. 25). En las resoluciones de la
cátedra la fórmula se llama *teorema del transporte*: el segundo término
«transporta» el vector con la terna, y el nombre ayuda a no olvidarse de que
la $bold(Omega)$ de ahí es la de la terna.

#posta[
  Lo que ve el de afuera es lo que ve el que gira, más lo que el giro le
  agrega. El que va sentado en la calesita ve el vector quieto; el de afuera
  lo ve dar vueltas; la diferencia entre los dos es $bold(Omega) times
  bold(Q)$ y nada más. Toda la Parte V es esta frase aplicada a $bold(L)$.
]

#fig([La @cin-derivada, en sus dos casos. *Izquierda:* si $bold(Q)$ está
clavado al sistema que rota, su punta recorre un círculo de radio $Q sin
theta$ y su derivada es la velocidad de esa punta, $bold(Omega) times
bold(Q)$, tangente al círculo y de módulo $Omega Q sin theta$. *Derecha:* si
además $bold(Q)$ cambia dentro del sistema, las dos contribuciones se suman
como vectores.], fig-vector-rotante)

#clave[
  *Los versores polares del módulo #M("vectores") son este teorema, en el caso más chico que
  hay.* Un sistema plano que gira con la partícula tiene $bold(Omega) =
  dot(theta) hat(k)$, y sus versores están clavados a él, así que su derivada
  relativa es cero. La @cin-derivada da entonces
  $ (d hat(r))/(d t) = dot(theta) hat(k) times hat(r) = dot(theta) hat(theta),
    quad quad (d hat(theta))/(d t) = dot(theta) hat(k) times hat(theta) = -dot(theta) hat(r) $
  que es exactamente lo que el módulo #M("vectores") dedujo con un triangulito y un límite.
  No es una coincidencia ni una analogía: es el mismo teorema, y por eso todo
  lo que se aprendió a hacer en polares vuelve a servir acá sin traducción.
]

#duda[¿Qué velocidad angular va en el producto vectorial: la del cuerpo o la de los ejes?]
#dedos[La de la silla en la que te sentaste. El término $bold(Omega) times
bold(Q)$ es lo que el giro *de tus ejes* le agrega a lo que ves. Si te
sentaste en el cuerpo, es la del cuerpo; si te sentaste en una pieza que no
lo acompaña en todo —la horquilla del disco, el balancín de un giróscopo, el
cardán de un CMG—, es la de esa pieza.]

#geometria[
  *$bold(Omega)$ es la velocidad angular del SISTEMA; $bold(omega)$ es la del
  CUERPO. No siempre son la misma, y confundirlas es el error caro de este
  tema.* Si los ejes se clavan al cuerpo, entonces sí $bold(Omega) =
  bold(omega)$ — pero clavarlos al cuerpo no siempre conviene. En un cuerpo con
  simetría de revolución, los momentos de inercia son los mismos en *cualquier*
  sistema que acompañe al eje de simetría, gire o no gire con el cuerpo
  alrededor de él; y elegir un sistema que *precede pero no gira* deja las
  cuentas mucho más simples (Beer §18.5, pág. 1170). En ese caso $bold(Omega)
  != bold(omega)$, y la @cin-derivada hay que aplicarla con $bold(Omega)$, no
  con $bold(omega)$.

  La regla, entonces: *en la @cin-derivada va siempre la velocidad angular del
  sistema desde el que se mira.* Antes de escribirla, decir en voz alta a qué
  está clavado el sistema elegido. En voz alta de verdad: el compañero de al
  lado va a mirar raro, pero el corrector mira peor.
]

#notacion[
  *«Razón de cambio» quiere decir «derivada respecto del tiempo»* — es el
  comentario textual de la cátedra sobre esta misma sección del Beer, y sobre
  la §12.7 que ya se usó en el módulo #M("momento-angular"). El Beer traducido la usa en todos los
  títulos, y el subíndice del paréntesis dice *respecto de qué sistema* se
  deriva, no respecto de qué variable. Punto para Aníbal: sin esa traducción,
  «razón de cambio» suena a contabilidad.
]

#ejemplo("El volante en el gimbal: por qué hace falta una cupla", nivel: "a fondo")[
  _(Guía de la cátedra 2026, sección Cuerpo rígido, Problema 3, en su mitad cinemática. La
  aceleración angular del gimbal, que es lo que el enunciado pide, sale en el
  módulo #M("euler-giroscopo") con las ecuaciones de Euler; acá se resuelve la parte de la que
  esa cuenta depende.)_ Un volante gira con $omega_s = 100$ rad/s constante
  alrededor de $z$. Está montado en un gimbal —sin peso— sobre una plataforma
  que gira con $omega_p = 0,5$ rad/s constante alrededor de $y$. Los ejes
  $x y z$ están clavados *al gimbal*, y el gimbal arranca quieto respecto de
  la plataforma.

  *(a) La velocidad angular del volante.* Por la @cin-suma, y en el instante en
  que el gimbal todavía no gira respecto de la plataforma:
  $ bold(omega) = omega_p hat(j) + omega_s hat(k) = 0,5 hat(j) + 100 hat(k) " rad/s" $
  $ abs(bold(omega))^2 = 0,5^2 + 100^2 = 10 thin 000,25 ==> abs(bold(omega)) = 100,001 " rad/s" $
  El eje instantáneo está a $arctan(0,005) = 0,29degree$ del eje de giro: casi
  encima, y esa cercanía es la que hace que el volante «se sienta» como un
  giróscopo.

  *(b) La velocidad angular de los ejes.* Los ejes están clavados al gimbal,
  que en ese instante sólo acompaña a la plataforma:
  $ bold(Omega) = omega_p hat(j) = 0,5 hat(j) " rad/s" $
  Es la velocidad angular de los ejes#burbuja[$bold(Omega)$: la de los ejes
  $x y z$, clavados al gimbal, respecto del espacio. $bold(omega)$: la del
  volante, también respecto del espacio. Las dos se anotan en los mismos
  ejes $x y z$, y aun así son flechas distintas.], no la del volante.

  #geometria[
    *$bold(Omega) != bold(omega)$, y ésta es la línea del problema donde se
    pierde el planteo.* El volante gira con $100 " rad/s"$ alrededor de $z$; el
    gimbal, no. Los ejes acompañan al gimbal, así que su velocidad angular no
    tiene componente $z$. Meter el spin adentro de $bold(Omega)$ da un
    $bold(alpha)$ absurdo y una cupla equivocada por un factor de doscientos.
  ]

  *(c) La aceleración angular del volante.* Las dos rapideces son constantes y
  las dos direcciones son ejes coordenados, así que la derivada relativa se
  anula y queda sólo el producto vectorial de la @cin-derivada:
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

#gancho[Un satélite no tiene ningún punto clavado: se traslada y gira a la
vez. Esta sección te dice que igual alcanza con dos datos —cómo se mueve un
punto que elijas y cómo gira el cuerpo— para saber cómo se mueve cualquier
otro: la punta de un panel, la boquilla de un propulsor, el foco de una
cámara. Lo simple: un solo $bold(omega)$ para todo el cuerpo. Lo que hay que
cuidar: desde qué punto se mide la flecha que va al otro.]

#duda[Si cambio el punto de referencia, ¿cambia la velocidad angular?]
#dedos[No. Subite a cualquier lugar de una calesita, al centro o al borde:
desde todos lados ves al resto girar igual de rápido. Cambia cuánto se
traslada cada punto, no cuánto gira el cuerpo.]

Si el cuerpo no tiene ningún punto fijo, se elige un punto $A$ del cuerpo como
referencia y se mira el movimiento *relativo* a un sistema que traslada con
$A$ pero no rota. Respecto de ese sistema, $A$ está fijo — y vale todo lo de
arriba:

$ bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B slash A) $ <cin-vgen>

con $bold(r)_(B slash A)$#burbuja[$bold(r)_(B slash A)$: la flecha que sale
de $A$ y llega a $B$, los dos puntos del mismo cuerpo. $bold(omega)$ y
$bold(alpha)$, las del cuerpo respecto del espacio.] la posición de $B$
medida desde $A$, y

$ bold(a)_B = bold(a)_A + bold(alpha) times bold(r)_(B slash A)
  + bold(omega) times (bold(omega) times bold(r)_(B slash A)) $ <cin-agen>

(Beer ecs. 15.43 y 15.44, pág. 991.) Todo movimiento de un cuerpo rígido es,
en cada instante, una traslación con la velocidad de un punto cualquiera más
una rotación alrededor de ese punto.

#clave[
  *$bold(omega)$ y $bold(alpha)$ no dependen del punto de referencia elegido.*
  Se despeja la @cin-vgen para $bold(v)_A$ y sale la misma relación con los
  papeles de $A$ y $B$ cambiados, con los *mismos* $bold(omega)$ y
  $bold(alpha)$. Es lo que permite hablar de «la velocidad angular del cuerpo»
  sin aclarar respecto de qué punto, algo que con el momento angular —módulo
  #M("momento-angular")— nunca se puede hacer.
]

== Una partícula vista desde un sistema que rota: Coriolis en tres dimensiones

Falta el caso en que lo que se mueve no está clavado al cuerpo: una partícula
que se desplaza *dentro* de un sistema que además gira. Es la situación del
módulo #M("marcos"), ahora sin las dos restricciones que allá la hacían corta
—el plano y el $bold(Omega)$ constante—. Es el Beer §15.14, y también el
Roederer §5.h («Sistemas no-inerciales en rotación», pág. 193), que lo cuenta
desde la fuerza de Coriolis en la Tierra.

#gancho[Es lo que pasa cuando algo se mueve *adentro* de algo que gira: un
astronauta que camina en una estación que rota, combustible que corre por un
tanque, un brazo que se despliega en un satélite que gira. Te dice qué
fuerzas aparecen de la nada —la centrífuga y la de Coriolis— y a quién le
toca pagarlas. En el módulo #M("actitud") es exactamente esto lo que frena a
un satélite que estira sus brazos. Lo simple: son cuatro términos y cada uno
tiene su porqué. Lo traicionero: el 2 de Coriolis, que sale de dos lugares
distintos.]

#duda[¿Por qué Coriolis lleva un 2? ¿No alcanza con sumar el giro una vez?]
#dedos[Porque el giro le juega dos veces a la partícula que camina hacia
afuera. Una: la dirección en que camina va girando, así que su velocidad
relativa cambia de dirección. Dos: al alejarse del centro llega a lugares
del disco que van más rápido, así que la velocidad de arrastre crece. Cada
efecto aporta lo mismo, y la suma es el doble. La hormiga de abajo lo
muestra con números.]

Se aplica la @cin-derivada dos veces —una a $bold(r)$ y otra al resultado— y
sale:

$ bold(v)_P = bold(Omega) times bold(r) + (dot(bold(r)))_(O x y z) $ <cin-coriolis-v>

$ bold(a)_P = dot(bold(Omega)) times bold(r)
  + bold(Omega) times (bold(Omega) times bold(r))
  + 2 bold(Omega) times (dot(bold(r)))_(O x y z)
  + (dot.double(bold(r)))_(O x y z) $ <cin-coriolis-a>

(Beer ecs. 15.45 y 15.47, pág. 1002.) El tercer término es la *aceleración de
Coriolis*, $bold(a)_c = 2 bold(Omega) times bold(v)_(P slash cal(F))$. Si
además el origen del sistema móvil se traslada, se le suma $bold(a)_A$ y las
posiciones se miden desde $A$ (Beer ecs. 15.52 y 15.54, pág. 1004): nada más
cambia.

#ejemplo("La hormiga sobre el disco: la regla aplicada dos veces")[
  _(Material de la cátedra: «Derivada de un vector en sistemas rotantes»,
  Feder–Valenti 2026, subido con la clase de los ángulos de Euler. No está en
  la guía.)_ Un disco gira con $bold(Omega) = Omega hat(k)$ constante. Sobre
  él hay pintada una línea radial con el versor $hat(e)_1$ encima ($hat(e)_2$
  perpendicular, los dos clavados al disco). Una hormiga sale del centro en
  $t = 0$ y camina por la línea con rapidez $v$ *respecto del disco*:
  $bold(r) = v t thin hat(e)_1$. El que va en el disco la ve ir en línea
  recta; el de afuera, dibujar una espiral.

  *Velocidad.* Con la @cin-derivada, la derivada que ve el disco es $v
  hat(e)_1$ y el transporte agrega $bold(Omega) times bold(r)$:
  $ bold(v)_I = v hat(e)_1 + Omega v t thin hat(e)_2 $
  Ojo con lo que dice esa $bold(v)_I$#burbuja[$bold(v)_I$: la velocidad de la
  hormiga mirada desde el inercial —el de afuera del disco—, pero *anotada*
  con los versores del disco, $hat(e)_1$ y $hat(e)_2$. Mirar desde un lado y
  anotar con la regla de otro, otra vez.]: es la que ve el de afuera.
  La radial es lo que camina la hormiga; la tangencial, lo que la arrastra
  el disco.

  *Aceleración: la regla otra vez, pero sobre $bold(v)_I$.* Visto desde el
  disco, $bold(v)_I$ cambia sólo porque su componente tangencial crece: $Omega
  v hat(e)_2$. El transporte suma $bold(Omega) times bold(v)_I = Omega v
  hat(e)_2 - Omega^2 v t thin hat(e)_1$. Juntando:
  $ bold(a)_I = 2 Omega v thin hat(e)_2 - Omega^2 r thin hat(e)_1 $
  La centrípeta, por estar en un punto que gira, y la de Coriolis, $2 Omega
  v$: la mitad porque la dirección de $v hat(e)_1$ gira, la otra mitad
  porque la tangencial $Omega r$ crece con $r$. Es la @cin-coriolis-a con
  $(dot.double(bold(r)))_(O x y z) = 0$ y $dot(bold(Omega)) = 0$, sin
  haberla usado.

  *Con números* (los de la cátedra): $Omega = 1$ rad/s, $v = 0,5$ m/s, a
  los $2$ s la hormiga está a $r = 1$ m. $bold(v)_I = (0,5; 1,0)$ m/s, de
  módulo $1,12$ m/s; $bold(a)_I = (-1,0; 1,0)$ m/s² en $(hat(e)_1;
  hat(e)_2)$, de módulo $1,41$ m/s². Desde el disco, la hormiga tiene
  aceleración *cero*: toda la diferencia la ponen los términos con
  $bold(Omega)$. Para que la hormiga siga la línea, el disco la tiene que
  empujar de costado con $2 m Omega v$; ella lo siente al revés y lo llama
  fuerza de Coriolis.

  #cuidado[
    Los dos errores que la hoja de Aníbal pone primero en su lista, y con
    razón. *Derivar las componentes no alcanza*: en la base del disco,
    $sum dot(A)_i hat(e)_i$ es sólo la derivada que ve el disco; el término
    de los versores es el que se olvida. Y *para la aceleración se deriva
    $bold(v)_I$, no la velocidad que ve el disco*: si se deriva la
    equivocada, el 2 de Coriolis sale 1 y la hormiga se cae de la línea. La
    misma cuenta en la Tierra (su tercer ejercicio): un proyectil a $300$
    m/s hacia el norte, a $35degree$ de latitud sur, tiene una Coriolis
    horizontal de $2 Omega_T v sin 35degree approx 0,025$ m/s², hacia la
    izquierda de su marcha: al oeste, como todo en el hemisferio sur.
  ]
]

#clave[
  *La aceleración en polares#repaso(destino: <vec-polares>)[
    Son las dos componentes de la aceleración de una partícula en
    coordenadas polares: la radial, $dot.double(r) - r dot(theta)^2$
    (con el término centrípeto, $-r dot(theta)^2$), y la transversal,
    $r dot.double(theta) + 2 dot(r) dot(theta)$ (con el de Coriolis,
    $2 dot(r) dot(theta)$). Se deducen paso a paso en el módulo
    #M("vectores"), sección 1.6.
  ] del módulo #M("vectores") es la @cin-coriolis-a, y se comprueba
  en cuatro renglones.* Con $bold(Omega) = dot(theta) hat(k)$ y $bold(r) = r
  hat(r)$, término por término:
  $ dot(bold(Omega)) times bold(r) = r dot.double(theta) hat(theta), quad
    bold(Omega) times (bold(Omega) times bold(r)) = -r dot(theta)^2 hat(r) $
  $ 2 bold(Omega) times (dot(bold(r)))_(O x y z) = 2 dot(r) dot(theta) hat(theta), quad
    (dot.double(bold(r)))_(O x y z) = dot.double(r) hat(r) $
  y sumando queda $bold(a) = (dot.double(r) - r dot(theta)^2) hat(r) + (r
  dot.double(theta) + 2 dot(r) dot(theta)) hat(theta)$, que es la del módulo #M("vectores")
  sin cambiarle una letra. Los cuatro términos que ahí había que aprender de
  memoria son, uno a uno, los cuatro de la @cin-coriolis-a. Quien los
  memorizó en el módulo #M("vectores") ahora puede olvidarlos tranquilo: los
  vuelve a sacar en cuatro renglones cuando los necesite.
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
  cuenta que los dos piden, y los módulos #M("inercia") y #M("euler-giroscopo") los terminan con las mismas
  letras y los mismos ejes. Los dos ejemplos de acá y los de los dos módulos
  siguientes son, entonces, dos problemas resueltos enteros y no cuatro
  problemas sueltos.
]

== Lo que se usa después

1. *La @cin-derivada.* Es la herramienta del módulo #M("euler-giroscopo"): el momento angular de
   un cuerpo rígido se calcula en ejes que acompañan al cuerpo —los únicos en
   los que los momentos de inercia no cambian con el tiempo— y después hay que
   derivarlo respecto del espacio fijo, que es lo único que la segunda ley de
   Newton acepta. Ese paso es la @cin-derivada, y de él salen las ecuaciones
   de Euler.

2. *La @cin-suma.* Toda velocidad angular de la Parte V se escribe como una
   suma: precesión más nutación más giro. Los tres ángulos de Euler del módulo
   #M("euler-giroscopo") son exactamente eso.

3. *Los dos conos.* Son la forma de *ver* un movimiento de precesión sin
   resolver ninguna ecuación, y en el módulo #M("peonza") la posición relativa de los dos
   —uno afuera del otro, o uno adentro del otro— es lo que distingue una
   precesión directa de una retrógrada.
