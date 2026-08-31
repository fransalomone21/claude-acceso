#import "../plantilla.typ": *

#modulo("Vectores y cinemática en coordenadas polares")[
  Escribir un vector en componentes y volver de las componentes al vector;
  usar el producto escalar para proyectar y el vectorial para construir una
  dirección perpendicular; resolver los dobles productos sin caer en la
  trampa de asociarlos; y —lo que se usa todo el resto del apunte— deducir
  la velocidad y la aceleración de una partícula en coordenadas polares,
  incluidos los dos términos que no aparecen en cartesianas.
]

Esta materia es, casi entera, la aplicación de tres teoremas de conservación a
cuerpos que se mueven en el espacio. Los tres se escriben con vectores, y dos
de ellos —el del momento angular y el de la energía en un campo central— sólo
son manejables en coordenadas polares. De ahí que la cátedra dedique la primera
semana entera a repasar vectores: no es trámite, es la herramienta con la que
está escrito todo lo demás.

El módulo va de lo conocido a lo que probablemente no lo sea. Las secciones
#link(<m1-escalar>)[1.2] a #link(<m1-dobles>)[1.4] son repaso y se leen rápido;
la #link(<m1-derivada>)[1.5] y la #link(<m1-polares>)[1.6] son el corazón, y de
ahí sale la mitad de las fórmulas de los módulos 7 al 11.

== El vector, sus componentes y sus cosenos directores

Un vector en el espacio queda determinado por tres números, sus componentes
sobre una terna ortonormal:

$ bold(A) = A_x hat(i) + A_y hat(j) + A_z hat(k), quad abs(bold(A)) = sqrt(A_x^2 + A_y^2 + A_z^2) $

El *versor* de $bold(A)$ —el vector de módulo 1 que apunta para el mismo
lado— es $hat(u)_A = bold(A) \/ abs(bold(A))$. Sus tres componentes son los
*cosenos directores*: los cosenos de los ángulos $alpha$, $beta$, $gamma$ que
$bold(A)$ forma con cada eje.

#deduccion("Por qué los cosenos directores son las componentes del versor")[
  El ángulo $alpha$ entre $bold(A)$ y el eje $x$ es, por definición, el ángulo
  entre $bold(A)$ y $hat(i)$. Del producto escalar,
  $ bold(A) dot hat(i) = abs(bold(A)) dot 1 dot cos alpha ==> cos alpha = (bold(A) dot hat(i)) / abs(bold(A)) = A_x / abs(bold(A)) $
  que es exactamente la primera componente de $bold(A)\/abs(bold(A))$. Lo mismo
  con $beta$ y $gamma$. De paso queda demostrada la identidad que sirve de
  control de la cuenta:
  $ cos^2 alpha + cos^2 beta + cos^2 gamma = (A_x^2 + A_y^2 + A_z^2) / abs(bold(A))^2 = 1 $
]

#cuidado[
  Esa identidad es el chequeo más barato que hay: si los tres cosenos que
  calculaste no cierran en 1, la cuenta está mal y lo sabés antes de seguir.
  Vale la pena hacerla siempre — cuesta tres cuadrados y una suma.
]

== El producto escalar: proyectar <m1-escalar>

$ bold(A) dot bold(B) = A_x B_x + A_y B_y + A_z B_z = abs(bold(A)) abs(bold(B)) cos theta $

Las dos expresiones son la misma cosa vista distinto: la primera es una cuenta,
la segunda dice qué significa. Lo que el producto escalar mide es *cuánto de un
vector va en la dirección del otro*.

#fig([La proyección de $bold(B)$ sobre $bold(A)$. El producto escalar mide el
largo de esa sombra, multiplicado por $abs(bold(A))$.], fig-proyeccion)

#deduccion("La proyección de B sobre A")[
  La sombra de $bold(B)$ sobre la recta de $bold(A)$ mide $B cos theta$: es el
  cateto adyacente del triángulo rectángulo de hipotenusa $B$. Como
  $bold(A) dot bold(B) = A B cos theta$, dividir por $A$ deja la sombra sola:
  $ "proy"_bold(A) bold(B) = (bold(A) dot bold(B)) / abs(bold(A)) = bold(B) dot hat(u)_A $
  Y si lo que se quiere es el *vector* proyección y no su largo, se lo vuelve a
  multiplicar por el versor:
  $ bold(B)_(||) = (bold(B) dot hat(u)_A) hat(u)_A $
  Esa descomposición —una parte paralela a una dirección y el resto
  perpendicular— es la que se usa en el módulo 7 para separar la velocidad en
  radial y transversal, y en el 13 para el momento de inercia respecto de un eje.
]

#geometria[
  *El ángulo del producto escalar es el que forman los dos vectores con el
  origen en común.* Si en el dibujo uno de los dos está trasladado —dibujado
  desde la punta del otro, como en una suma— el ángulo que se ve NO es
  $theta$: es su suplementario, y el coseno cambia de signo. Antes de escribir
  $cos theta$, llevá mentalmente los dos vectores a un mismo origen.
]

#clave[
  $bold(A) dot bold(B) = 0$ con los dos vectores no nulos significa
  *perpendiculares*. Es la forma más barata de verificar una perpendicularidad,
  y se usa constantemente: que la fuerza central no haga trabajo, que el
  momento angular sea perpendicular al plano de la órbita, que un versor y su
  derivada sean ortogonales.
]

#ejemplo("Cosenos directores y proyección")[
  *(a)* Cosenos directores de $bold(A) = (1, -1, 3)$ #h(4pt) _(Ej. 11 de la guía)_.

  $abs(bold(A)) = sqrt(1 + 1 + 9) = sqrt(11) approx 3,317$, y entonces
  $ cos alpha = 1/sqrt(11) approx 0,302, quad cos beta = -1/sqrt(11) approx -0,302, quad cos gamma = 3/sqrt(11) approx 0,905 $
  Control: $(1 + 1 + 9)\/11 = 1$. #sym.checkmark

  El signo menos no es un detalle: dice que el vector forma con el eje $y$ un
  ángulo mayor que $90degree$ ($beta approx 107,5degree$).

  *(b)* Proyección de $bold(B) = (2, 5, -1)$ sobre $bold(A) = (1, 0, -3)$
  #h(4pt) _(Ej. 14)_.

  $ bold(A) dot bold(B) = 2 + 0 + 3 = 5, quad abs(bold(A)) = sqrt(10) $
  $ "proy"_bold(A) bold(B) = 5/sqrt(10) approx 1,581 $
  y como vector: $bold(B)_(||) = 1,581 dot (1,0,-3)/sqrt(10) = (0,5; 0; -1,5)$.

  *(c)* Cosenos directores de un vector paralelo al eje $z$ #h(4pt) _(Ej. 12)_.

  Es $(0,0,C)$ con $C != 0$: los cosenos son $(0, 0, plus.minus 1)$ según el
  sentido. El caso trivial existe en la guía para que quede claro que los
  cosenos directores describen una *dirección orientada*, no una recta.
]

== El producto vectorial: construir una perpendicular

$ bold(A) times bold(B) = mat(delim: "|", hat(i), hat(j), hat(k); A_x, A_y, A_z; B_x, B_y, B_z), quad abs(bold(A) times bold(B)) = abs(bold(A)) abs(bold(B)) sin theta $

El resultado es un *vector*, perpendicular a los dos, con el sentido que da la
regla de la mano derecha, y con módulo igual al área del paralelogramo que los
dos vectores forman.

#fig([El módulo del producto vectorial es el área del paralelogramo: base
$abs(bold(A))$ por altura $abs(bold(B)) sin theta$.], fig-producto-vectorial)

#deduccion("Por qué el módulo es el área")[
  El paralelogramo tiene base $abs(bold(A))$ y altura la componente de $bold(B)$
  perpendicular a $bold(A)$, que es $abs(bold(B)) sin theta$. Área $=$ base $times$
  altura $= abs(bold(A)) abs(bold(B)) sin theta$. Es el complemento exacto del
  escalar: uno se queda con la parte *paralela* ($cos theta$), el otro con la
  *perpendicular* ($sin theta$).
]

#clave[
  La consecuencia que más se usa: $bold(A) times bold(B) = bold(0)$ con los dos
  no nulos significa *paralelos*. En el módulo 7 eso es exactamente la condición
  para que el momento angular de una partícula sea nulo, y en el 9 es la que
  define el perigeo y el apogeo — los dos únicos puntos de una órbita donde la
  velocidad es perpendicular al radio, y por eso donde $|bold(r) times bold(v)|$
  se calcula sin trigonometría.
]

#ejemplo("Versor perpendicular a dos vectores dados")[
  _(Ej. 13 de la guía)_ Hallar el versor perpendicular a $bold(A) = (0,1,5)$ y
  $bold(B) = (-3,0,2)$.

  $ bold(A) times bold(B) = mat(delim: "|", hat(i), hat(j), hat(k); 0, 1, 5; -3, 0, 2) = (1 dot 2 - 5 dot 0) hat(i) - (0 dot 2 - 5 dot (-3)) hat(j) + (0 - (-3)) hat(k) = (2, -15, 3) $

  $abs(bold(A) times bold(B)) = sqrt(4 + 225 + 9) = sqrt(238) approx 15,43$, así que

  $ hat(n) = 1/sqrt(238) (2, -15, 3) approx (0,130; -0,972; 0,194) $

  Control barato: $hat(n) dot bold(A) = (2 dot 0 - 15 dot 1 + 3 dot 5)\/sqrt(238) = 0$. #sym.checkmark

  Y hay *dos* respuestas: $-hat(n)$ también es perpendicular a los dos. Cuál de
  las dos es «la» respuesta lo decide el orden en que se escribió el producto,
  que es una elección, no un dato del problema.
]

== Los dobles productos, y la trampa <m1-dobles>

Con tres vectores hay dos combinaciones que aparecen todo el tiempo:

*Producto mixto* $bold(A) dot (bold(B) times bold(C))$. Es un *escalar*, y vale
el volumen del paralelepípedo de aristas $bold(A)$, $bold(B)$, $bold(C)$ —con
signo—. Se calcula como el determinante de las tres filas de componentes. Si da
cero, los tres vectores son coplanares.

*Doble producto vectorial* $bold(A) times (bold(B) times bold(C))$. Es un
*vector*, y siempre está en el plano de $bold(B)$ y $bold(C)$:

$ bold(A) times (bold(B) times bold(C)) = bold(B) (bold(A) dot bold(C)) - bold(C) (bold(A) dot bold(B)) $

Se la recuerda como *«BAC menos CAB»*, y se usa sin demostrarla: la deducción
por componentes es tres páginas de álgebra que no cambian el entendimiento de
nada. Lo que sí hay que entender es *por qué* el resultado cae en el plano de
$bold(B)$ y $bold(C)$: porque $bold(B) times bold(C)$ es perpendicular a ese
plano, y cruzar $bold(A)$ con algo perpendicular al plano devuelve algo que
está *en* el plano.

#cuidado[
  *El producto vectorial no es asociativo.* En general
  $ (bold(A) times bold(B)) times bold(C) != bold(A) times (bold(B) times bold(C)) $
  El primero vive en el plano de $bold(A)$ y $bold(B)$; el segundo, en el de
  $bold(B)$ y $bold(C)$. Son vectores distintos, y en el Ej. 15 de la guía se
  piden los dos justamente para que la diferencia se vea con números. *Los
  paréntesis no son decorativos: sin ellos la expresión no significa nada.*
]

#geometria[
  Dos casos particulares que salen gratis de lo anterior y ahorran cuentas:
  - $bold(A) times (bold(A) times bold(B)) = bold(A)(bold(A) dot bold(B)) - bold(B) abs(bold(A))^2$ — está en el plano de $bold(A)$ y $bold(B)$, no es perpendicular a nada obvio.
  - $(bold(A) dot bold(B))(bold(A) times bold(B))$ es un vector paralelo a $bold(A) times bold(B)$, escalado por un número: *no* es un doble producto vectorial, aunque se le parezca escrito.
]

== La derivada de un vector: dos partes, no una <m1-derivada>

Acá empieza lo que realmente hace falta. Un vector puede cambiar de dos maneras
independientes: cambiando de *módulo* y cambiando de *dirección*. Su derivada
tiene un término por cada una:

$ bold(A) = A hat(u) ==> (d bold(A))/(d t) = underbrace(dot(A) hat(u), "cambia el módulo") + underbrace(A (d hat(u))/(d t), "cambia la dirección") $

En cartesianas el segundo término no aparece nunca, porque $hat(i)$, $hat(j)$ y
$hat(k)$ no se mueven. Ese es todo el motivo por el que las cartesianas son
cómodas — y también por el que son inútiles para una órbita, donde la dirección
del radio cambia todo el tiempo.

#deduccion("La derivada de un versor es perpendicular a él")[
  Un versor tiene módulo constante: $hat(u) dot hat(u) = 1$. Derivando los dos
  lados,
  $ (d)/(d t)(hat(u) dot hat(u)) = 2 hat(u) dot (d hat(u))/(d t) = 0 ==> hat(u) perp (d hat(u))/(d t) $
  Dos renglones, y queda demostrado en general: *la derivada de cualquier vector
  de módulo constante es perpendicular a él*. Esa es la razón por la que la
  aceleración de un movimiento circular uniforme apunta al centro, y no otra.

  Falta el módulo de esa derivada, y sale del dibujo:
]

#fig([Dos posiciones del mismo versor, separadas $Delta theta$. Como los dos
miden 1, la cuerda que los une mide $Delta theta$ (en radianes) y, en el
límite, es perpendicular a $hat(r)$.], fig-derivada-versor)

#deduccion("cuánto vale la derivada del versor radial")[
  El triángulo de la figura es isósceles con los dos lados iguales a 1. La
  cuerda opuesta al ángulo $Delta theta$ mide $2 sin(Delta theta \/ 2)$, que
  para ángulos chicos es $approx Delta theta$. Entonces
  $ abs(Delta hat(r)) approx Delta theta ==> abs((d hat(r))/(d t)) = lim_(Delta t -> 0) (Delta theta)/(Delta t) = dot(theta) $
  y por lo recién demostrado esa derivada es perpendicular a $hat(r)$, es decir
  va en la dirección de $hat(theta)$. Juntando módulo y dirección:
  $ (d hat(r))/(d t) = dot(theta) hat(theta), quad (d hat(theta))/(d t) = -dot(theta) hat(r) $
  (la segunda sale igual; el signo menos aparece porque al girar $hat(theta)$
  noventa grados más se llega a $-hat(r)$). Beer, §11.14, pág. 668, ec. (11.42).
]

== Velocidad y aceleración en coordenadas polares <m1-polares>

#fig([Los versores polares en un punto de una trayectoria cualquiera. $hat(r)$
apunta hacia afuera a lo largo de $bold(r)$; $hat(theta)$ es $hat(r)$ girado
$90degree$ en el sentido en que crece $theta$. *Los dos giran con la
partícula.*], fig-versores-polares)

Con el vector posición escrito como $bold(r) = r hat(r)$ y las dos derivadas
recién deducidas, todo sale de derivar dos veces.

#deduccion("Velocidad y aceleración en polares, de punta a punta")[
  *Velocidad.* Derivando $bold(r) = r hat(r)$ con la regla del producto y
  reemplazando $dot(hat(r)) = dot(theta) hat(theta)$:
  $ bold(v) = dot(r) hat(r) + r dot(hat(r)) = dot(r) hat(r) + r dot(theta) hat(theta) $
  Los dos términos se leen solos: $dot(r)$ es cuánto me alejo del origen, y
  $r dot(theta)$ es cuánto me corro *alrededor* de él. (Beer ec. 11.43.)

  *Aceleración.* Derivando otra vez, término por término:
  $ bold(a) = dot.double(r) hat(r) + dot(r) dot(hat(r)) + dot(r) dot(theta) hat(theta) + r dot.double(theta) hat(theta) + r dot(theta) dot(hat(theta)) $
  y reemplazando $dot(hat(r)) = dot(theta) hat(theta)$ y
  $dot(hat(theta)) = -dot(theta) hat(r)$:
  $ bold(a) = (dot.double(r) - r dot(theta)^2) hat(r) + (r dot.double(theta) + 2 dot(r) dot(theta)) hat(theta) $
  (Beer ec. 11.44 y 11.46, pág. 669.)
]

Los cuatro términos de la aceleración tienen nombre, y conviene reconocerlos
porque dos de ellos no tienen análogo en cartesianas:

#table(
  columns: (auto, auto, 1fr),
  align: (left, center, left),
  table.header([*Término*], [*Va en*], [*Qué es*]),
  [$dot.double(r)$], [$hat(r)$], [aceleración radial «de verdad»: el radio cambia su ritmo de cambio],
  [$-r dot(theta)^2$], [$hat(r)$], [*centrípeta*. Aparece aunque $r$ sea constante y $dot(theta)$ constante: es el término que sostiene una órbita circular],
  [$r dot.double(theta)$], [$hat(theta)$], [aceleración angular: la partícula gira cada vez más rápido],
  [$2 dot(r) dot(theta)$], [$hat(theta)$], [*Coriolis*. Aparece sólo si la partícula se aleja o se acerca *mientras* gira],
)

#cuidado[
  *$a_r$ no es la derivada de $v_r$.* Es la advertencia textual del Beer
  (pág. 669) y es de las que se cobran caro: $v_r = dot(r)$, pero
  $a_r = dot.double(r) - r dot(theta)^2$. Derivar la componente y componer la
  derivada no son la misma operación cuando los versores giran, porque al
  derivar hay que derivar también el versor.
]

#notacion[
  *Beer escribe $e_r$ y $e_theta$ donde la cátedra escribe $hat(r)$ y
  $hat(theta)$* — misma cosa, otra letra. Roederer y el manuscrito de clase usan
  $hat(r)$, $hat(theta)$, que es lo que usa este apunte. Y en el manuscrito de
  la cátedra el mismo versor aparece a veces como $hat(u)_r$: es la notación de
  Bate y de Curtis para los versores, y también es el mismo objeto.
]

#geometria[
  Los versores $hat(r)$ y $hat(theta)$ *dependen del punto*. No son una base
  fija: son una base que viaja con la partícula. Dos consecuencias prácticas:

  1. No tiene sentido sumar la componente $hat(r)$ de un instante con la de
     otro, ni las de dos partículas distintas — están escritas en bases
     diferentes. Para sumar hay que pasar a cartesianas.
  2. $hat(theta)$ apunta en el sentido en que *crece* $theta$. Si el problema
     define $theta$ midiendo para el otro lado, $hat(theta)$ da vuelta y con
     él el signo de $v_theta$. Fijá el sentido de $theta$ en el dibujo antes
     de escribir la primera ecuación.
]

#ejemplo("El cohete visto por el radar", nivel: "a fondo")[
  _(Ej. 10 de la guía.)_ Un cohete se lanza verticalmente desde una plataforma
  en $B$. Un radar en $A$, a distancia fija $b$, lo sigue. Determinar la
  velocidad del cohete en términos de $b$, $theta$ y $dot(theta)$.

  #v(4pt)
  #fig-cohete-radar
  #v(4pt)

  *Por qué no se puede simplemente derivar la altura.* Lo que el radar mide es
  $theta$ y su ritmo de cambio $dot(theta)$: la altura no la mide nadie. El
  problema pide justamente la traducción de lo que se mide a lo que se quiere.

  *Paso 1 — la geometría.* El triángulo $A B "cohete"$ es rectángulo en $B$,
  con cateto adyacente $b$ (constante) y ángulo $theta$ en $A$:
  $ r = b / (cos theta), quad y = b tan theta $

  *Paso 2 — derivar el vínculo.* $b$ es constante, así que la única variable es
  $theta$:
  $ dot(r) = b (d)/(d t)(sec theta) = b sec theta tan theta dot(theta) = (b sin theta)/(cos^2 theta) dot(theta) $

  *Paso 3 — armar la velocidad en polares.* Con
  $bold(v) = dot(r) hat(r) + r dot(theta) hat(theta)$:
  $ bold(v) = (b dot(theta) sin theta)/(cos^2 theta) hat(r) + (b dot(theta))/(cos theta) hat(theta) $

  *Paso 4 — el módulo.*
  $ v = b dot(theta) sqrt((sin^2 theta)/(cos^4 theta) + 1/(cos^2 theta)) = (b dot(theta))/(cos^2 theta) sqrt(sin^2 theta + cos^2 theta) = (b dot(theta))/(cos^2 theta) $

  *El control que cierra el problema.* El cohete sube vertical, así que su
  velocidad tiene que ser $dot(y)$. Derivando $y = b tan theta$ directamente:
  $ dot(y) = b sec^2 theta dot(theta) = (b dot(theta))/(cos^2 theta) $
  Idéntico. #sym.checkmark Las dos componentes polares, que por separado no se
  parecen a nada, se recomponen exactamente en la velocidad vertical que uno
  esperaba.

  #geometria[
    La trampa del problema es creer que como el movimiento es vertical, la
    componente $hat(theta)$ debería ser cero. No lo es: $hat(r)$ y $hat(theta)$
    están definidos *respecto del radar*, no respecto de la trayectoria. Un
    movimiento rectilíneo tiene las dos componentes polares distintas de cero
    en cuanto el origen no esté sobre la recta.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  Los quince ejercicios de la sección *Vectores*. Los 11 a 15 son cuenta
  directa con lo de las secciones 1.1 a 1.4. El *9* pide escribir la velocidad
  en polares —es la deducción de la sección 1.6, no un ejercicio distinto— y el
  *10* es el ejemplo de arriba. Si el 9 y el 10 salen, el módulo está.
]

== Lo que se usa después

Tres resultados de este módulo se van a usar hasta el final:

1. *$bold(A) dot bold(B) = 0 <==> perp$* y *$bold(A) times bold(B) = bold(0) <==> ||$*. Con eso se prueba que una fuerza central no hace variar el momento angular (módulo 7) y que en apogeo y perigeo $h = r v$ sin senos (módulo 9).

2. *La derivada de un vector de módulo constante es perpendicular a él.* Es el argumento de dos renglones detrás de la aceleración centrípeta, y reaparece entero en el módulo 12 cuando el vector que rota es un eje del cuerpo rígido.

3. *$bold(v) = dot(r) hat(r) + r dot(theta) hat(theta)$.* De acá salen las dos cantidades que gobiernan la mecánica orbital: el momento angular específico $h = r^2 dot(theta)$, y la energía cinética partida en su parte radial y su parte angular —que es lo que da origen al *potencial eficaz* del módulo 9.
