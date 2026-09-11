#import "../plantilla.typ": *

#modulo("El problema restringido de tres cuerpos y los puntos de Lagrange")[
  Qué queda del problema de dos cuerpos cuando hay tres y ninguno se puede
  ignorar. El precio que hay que pagar —no existe la solución cerrada— y lo
  que se gana a cambio: sentarse en un sistema que gira con los dos cuerpos
  grandes, donde los dos quedan *quietos* y tiene sentido preguntar dónde
  puede quedarse quieta una nave. Ahí aparecen los cinco *puntos de
  Lagrange*, dos de ellos con una respuesta exacta y en una línea. Y aparece
  la única cantidad que todavía se conserva —la *constante de Jacobi*—, que
  es el diagrama de energía del módulo 5 otra vez, y que dice adónde una nave
  *no puede llegar* aunque no se sepa resolver su trayectoria.
]

El módulo 17 dejó una deuda escrita con todas las letras: el método de las
cónicas parcheadas *no sirve para la Luna*. La esfera de influencia de la Luna
mide el 17% de su distancia a la Tierra, y ninguna de las dos mentiras que el
método necesita —«es un punto», «está en el infinito»— se sostiene. El párrafo
terminaba mandando acá.

Y hay una segunda cosa que el problema de dos cuerpos no puede ni plantear.
En una órbita alrededor de un solo cuerpo no existe ningún lugar donde una
nave se pueda quedar *quieta respecto de los dos*: o está en órbita, o se
cae. Sin embargo el telescopio James Webb está hoy en un punto que acompaña a
la Tierra alrededor del Sol a distancia fija, y no es magia ni es un motor
prendido. Es geometría de tres cuerpos, y sale de acá.

== La idea completa, antes de la primera ecuación

Todavía no hay ninguna cuenta hecha. Lo que sigue es el plan, en tres pasos.

+ *Aceptar la pérdida, y recortar el problema.* Tres cuerpos que se atraen
  entre sí no tienen solución cerrada: no hay fórmula que dé la posición en
  función del tiempo, y no es que todavía no se encontró — se sabe que no
  existe. Así que se recorta el problema hasta el caso que sí se puede
  estudiar: dos cuerpos grandes girando en *círculo* uno alrededor del otro,
  y un tercero tan chico que no los perturba. Eso es el *problema restringido
  circular*, y describe bien a la nave frente a la Tierra y la Luna, o frente
  al Sol y la Tierra.

+ *Cambiar de marco.* Si los dos cuerpos grandes giran con velocidad angular
  constante, hay un sistema de ejes —uno que gira con ellos— en el que los
  dos están *quietos*. Ese cambio no es cosmético: convierte un problema
  donde todo se mueve en uno donde sólo se mueve la nave. El precio son las
  dos fuerzas ficticias que el módulo 12 ya dedujo, la centrífuga y la de
  Coriolis, y hay que pagarlo entero.

+ *Preguntar dónde se puede estar quieto, y dónde no se puede llegar.* Con
  los dos cuerpos quietos, la pregunta «¿dónde queda una nave permanentemente
  en reposo?» recién ahí tiene sentido, y la respuesta son cinco puntos. Y
  aunque las ecuaciones no se sepan resolver, todavía se conserva *una*
  cantidad, que alcanza para dibujar las regiones del espacio en las que la
  nave no puede entrar.

#posta[
  La posta de este módulo son tres ideas y ninguna es una fórmula.

  La primera: *que un problema no tenga solución cerrada no quiere decir que
  no se sepa nada de él.* Acá no vamos a poder decir dónde está la nave
  dentro de dos horas —para eso hay que integrar numéricamente—, y aun así
  vamos a poder decir dónde hay puntos de equilibrio, cuáles sirven para
  estacionar y a qué regiones del espacio la nave tiene prohibido entrar. Eso
  es muchísimo, y es gratis.

  La segunda: *sentarse arriba del sistema que gira es el truco entero.* En
  el marco inercial, la Tierra y la Luna se mueven y el problema es
  incomprensible. En el marco que gira con ellas, las dos están clavadas y
  aparecen cinco lugares donde te podés quedar quieto. No cambió ninguna
  física: cambió desde dónde se mira.

  Y la tercera, que es la que más se usa en la práctica: *la constante de
  Jacobi es un diagrama de energía*, igual al del módulo 5 y al del potencial
  eficaz del módulo 9. Se dibuja una curva, se traza una recta horizontal a
  la altura que te dio el motor, y lo que queda arriba de la recta es
  territorio prohibido. Sin resolver una sola ecuación diferencial.
]

#clave[
  *El plan del módulo, en cuatro pasos:*
  + Armar el marco que gira y escribir ahí las tres ecuaciones de movimiento.
  + Buscar los puntos de equilibrio: dos salen exactos en un renglón, los
    otros tres necesitan una raíz numérica.
  + Comparar la frontera que sale de acá —la esfera de Hill— con la esfera
    de influencia del módulo 17, que mide lo mismo con otro criterio.
  + Deducir la constante de Jacobi y leerla como un diagrama de energía.
]

== El marco que gira con los dos cuerpos

#definicion("el problema restringido circular de tres cuerpos")[
  Dos cuerpos de masas $m_1$ y $m_2$ —con $m_1 > m_2$— giran en *órbita
  circular* de radio $r_12$ alrededor de su centro de masa común $G$. Un
  tercer cuerpo de masa $m$, *despreciable frente a las otras dos*, se mueve
  bajo la atracción de ambos sin perturbarlos.

  Las tres restricciones son las tres palabras del nombre: *restringido*
  porque la tercera masa no cuenta en el problema de las otras dos,
  *circular* porque la órbita de los primarios lo es, y *de tres cuerpos*
  porque los dos primarios tiran de la nave *al mismo tiempo*, que es
  exactamente lo que el módulo 17 se negaba a hacer.
]

Los ejes se eligen así: origen en $G$, eje $x$ apuntando de $m_1$ hacia
$m_2$, eje $y$ en el plano de la órbita y eje $z$ perpendicular. *Este sistema
gira*, con la misma velocidad angular que los dos primarios, y por eso en él
$m_1$ y $m_2$ están quietos sobre el eje $x$.

#fig([El marco que gira con los dos cuerpos, que es el cambio de punto de
vista del que sale todo el módulo. Lo que hay que sacar del dibujo son tres
cosas: que el origen es el *baricentro* $G$ y no el cuerpo grande; que en
este marco $m_1$ y $m_2$ están *clavados* sobre el eje $x$, cada uno a su
fracción de la distancia $r_12$; y que la nave se ubica con tres vectores
distintos —$bold(r)$ desde $G$, $bold(r)_1$ desde $m_1$ y $bold(r)_2$ desde
$m_2$— porque las tres cosas que hay que calcular se miden desde tres lugares
distintos. La flecha curva $bold(Omega)$ es lo único que recuerda que el
marco entero está girando.], fig-tres-cuerpos-marco)

La velocidad angular sale de la tercera ley de Kepler del módulo 10 aplicada
a la órbita circular de los primarios, con $mu = G(m_1 + m_2)$:

$ bold(Omega) = Omega hat(k), quad quad Omega = (2 pi)/T = sqrt(mu\/r_12^3) $ <m19-omega>

y las posiciones de los dos cuerpos salen de la definición de centro de masa
del módulo 8 (@m8-cm), $m_1 x_1 + m_2 x_2 = 0$, junto con
$x_2 = x_1 + r_12$:

$ x_1 = - pi_2 r_12, quad quad x_2 = pi_1 r_12, quad quad
  pi_1 = m_1/(m_1 + m_2), quad pi_2 = m_2/(m_1 + m_2) $ <m19-pi>

#notacion[
  *Esos dos $pi$ no tienen nada que ver con el número $pi$.* Es la notación
  de Curtis (§2.12) y es desafortunada, pero es la que van a ver en el libro
  que la cátedra pide, así que se usa. Son dos *fracciones de masa* que
  cumplen $pi_1 + pi_2 = 1$, y el segundo es el que aparece en todas las
  fórmulas de acá en adelante: para el par Tierra–Luna vale $0,01215$ y para
  el par Sol–Tierra, $3,0 times 10^(-6)$.

  Buena parte de la bibliografía los llama $mu$ y $1 - mu$, lo cual choca de
  frente con el parámetro gravitatorio $mu = G M$ que este apunte viene
  usando desde el módulo 6. Entre dos choques, se eligió el que no pisa una
  cantidad que aparece en todos los módulos anteriores.
]

Con la nave en $bold(r) = x hat(i) + y hat(j) + z hat(k)$, sus posiciones
respecto de cada primario son

$ bold(r)_1 = (x + pi_2 r_12) hat(i) + y hat(j) + z hat(k), quad quad
  bold(r)_2 = (x - pi_1 r_12) hat(i) + y hat(j) + z hat(k) $ <m19-r12>

#deduccion("las tres ecuaciones de movimiento")[
  La segunda ley de Newton vale en un marco *inercial*, y el nuestro gira. La
  aceleración absoluta de un punto visto desde un marco rotante es la fórmula
  de cinco términos del módulo 12 (@m12-coriolis-a). Acá se simplifica sola:
  el centro de masa del par se mueve con velocidad constante (módulo 8), así
  que su aceleración es cero, y la órbita es circular, así que
  $dot(bold(Omega)) = bold(0)$. Quedan tres términos:

  $ dot.double(bold(r))_"abs" = bold(Omega) times (bold(Omega) times bold(r))
    + 2 bold(Omega) times bold(v)_"rel" + bold(a)_"rel" $

  Con $bold(Omega) = Omega hat(k)$, el primer término da
  $-Omega^2 (x hat(i) + y hat(j))$ —la centrífuga, que no tiene componente
  $z$— y el segundo da $2 Omega (- dot(y) hat(i) + dot(x) hat(j))$. Agrupando:

  $ dot.double(bold(r))_"abs" = (dot.double(x) - 2 Omega dot(y) - Omega^2 x) hat(i)
    + (dot.double(y) + 2 Omega dot(x) - Omega^2 y) hat(j)
    + dot.double(z) hat(k) $

  Del otro lado va la gravedad de los dos primarios, cada una con la ley del
  módulo 6 escrita hacia adentro, y la masa $m$ se cancela porque aparece en
  los dos miembros:

  $ dot.double(bold(r))_"abs" = - (mu_1)/(r_1^3) bold(r)_1 - (mu_2)/(r_2^3) bold(r)_2,
    quad quad mu_1 = G m_1, quad mu_2 = G m_2 $

  Igualando componente a componente con la @m19-r12 quedan las tres.
]

$ dot.double(x) - 2 Omega dot(y) - Omega^2 x
  = - (mu_1)/(r_1^3)(x + pi_2 r_12) - (mu_2)/(r_2^3)(x - pi_1 r_12) $ <m19-mov-x>

$ dot.double(y) + 2 Omega dot(x) - Omega^2 y
  = - (mu_1)/(r_1^3) y - (mu_2)/(r_2^3) y $ <m19-mov-y>

$ dot.double(z) = - (mu_1)/(r_1^3) z - (mu_2)/(r_2^3) z $ <m19-mov-z>

#clave[
  *Estas tres ecuaciones no se resuelven, y conviene ver por qué.* No es que
  el despeje sea largo: no hay función conocida que las satisfaga. Dos cosas
  las arruinan, y las dos se ven mirándolas.

  La primera es que $r_1$ y $r_2$ dependen de $x$, $y$ y $z$ —son raíces
  cuadradas de sumas de cuadrados— y aparecen al cubo en el denominador. Eso
  ya es no lineal de la peor manera.

  La segunda son los términos $-2 Omega dot(y)$ y $+2 Omega dot(x)$: la
  aceleración de Coriolis, que *acopla las dos ecuaciones*. La de $x$ no se
  puede resolver sin la de $y$ y al revés. Es exactamente lo que el módulo 12
  anticipó cuando dijo que Coriolis es lo que hace que un marco rotante no
  sea un marco normal con una fuerza de más.

  Lo que sí se hace —y es lo que hace cualquier centro de control— es
  *integrarlas numéricamente*: se les da un estado inicial y se avanza paso a
  paso. Eso no da una fórmula, da una trayectoria. Todo lo que sigue en este
  módulo es lo que se puede saber *sin* integrar.
]

== Los cinco puntos de Lagrange

Un *punto de equilibrio* es un lugar donde una nave puesta en reposo se
queda en reposo: velocidad nula y aceleración nula, las dos medidas en el
marco que gira. Visto desde afuera no está quieta —da vueltas con el sistema,
con el mismo período que los primarios—, pero *respecto de la Tierra y de la
Luna no se mueve nunca*.

Imponer $dot(x) = dot(y) = dot(z) = 0$ y $dot.double(x) = dot.double(y) =
dot.double(z) = 0$ en las tres ecuaciones deja tres condiciones algebraicas.
La tercera se resuelve de un vistazo: la @m19-mov-z queda

$ (mu_1/r_1^3 + mu_2/r_2^3) z = 0 $

y los dos sumandos son positivos, así que $z = 0$. *Los cinco puntos de
equilibrio están en el plano de la órbita*, sin excepción y sin aproximación.

#deduccion("los dos puntos triangulares")[
  Se busca primero el caso $y != 0$, que es el que sale exacto. Con $z = 0$,
  las dos condiciones que quedan son

  $ Omega^2 x = (mu_1)/(r_1^3)(x + pi_2 r_12) + (mu_2)/(r_2^3)(x - pi_1 r_12),
    quad quad Omega^2 y = ((mu_1)/(r_1^3) + (mu_2)/(r_2^3)) y $

  Usando $Omega^2 = mu\/r_12^3$, $mu_1 = pi_1 mu$, $mu_2 = pi_2 mu$ y
  $pi_1 = 1 - pi_2$, y dividiendo la segunda por $y$ —que se puede, porque
  estamos suponiendo $y != 0$— las dos quedan así:

  $ (1 - pi_2)(x + pi_2 r_12) 1/r_1^3 + pi_2 (x + pi_2 r_12 - r_12) 1/r_2^3
    = x/r_12^3 $
  $ (1 - pi_2) 1/r_1^3 + pi_2 1/r_2^3 = 1/r_12^3 $

  Acá está el truco, y es de álgebra elemental: *son dos ecuaciones lineales
  en las incógnitas $1\/r_1^3$ y $1\/r_2^3$*. Resolviendo el sistema de dos
  por dos sale, sin ninguna aproximación,

  $ 1/r_1^3 = 1/r_2^3 = 1/r_12^3 quad ==> quad r_1 = r_2 = r_12 $ <m19-equilatero>

  O sea: los dos puntos están a la *misma distancia de los dos primarios*, y
  esa distancia es la que hay *entre* los primarios. Eso es un triángulo
  equilátero, y con eso las coordenadas salen de la geometría: escribiendo
  $r_1 = r_12$ en la @m19-r12 y despejando,
]

$ L_4, L_5 : quad x = r_12/2 - pi_2 r_12, quad quad
  y = plus.minus sqrt(3)/2 r_12, quad quad z = 0 $ <m19-l45>

#clave[
  *Los dos puntos triangulares no dependen de las masas, y eso es lo raro.*
  En la @m19-equilatero no quedó ningún $pi_2$: las distancias a los dos
  primarios valen $r_12$ *sea cual sea la razón de masas*. Un grano de polvo
  a $60°$ por delante de la Luna está en equilibrio, y también lo está uno a
  $60°$ por delante de Júpiter.

  Vale la pena ver por qué no es magia. En $L_4$ las dos atracciones son
  distintas —la Tierra tira mucho más que la Luna— pero la *suma* de las dos
  apunta exactamente al baricentro $G$, porque el triángulo es equilátero y
  el baricentro divide el lado en la misma proporción que las masas. Y una
  fuerza dirigida al centro, con el módulo justo, es lo único que hace falta
  para una órbita circular de radio $abs(bold(r))$ y período $2 pi \/ Omega$.
  El equilibrio no es «las fuerzas se cancelan»: es «la resultante es
  exactamente la centrípeta que hace falta».
]

Los otros tres puntos son los que están *sobre el eje*, con $y = 0$ además de
$z = 0$ — que también satisface la @m19-mov-y, porque su miembro derecho se
anula. Ahí $r_1 = abs(x + pi_2 r_12)$ y $r_2 = abs(x + pi_2 r_12 - r_12)$, y
la condición que queda es una sola. Conviene escribirla sin unidades, con
$xi = x \/ r_12$:

$ f(pi_2, thin xi) = (1 - pi_2) (xi + pi_2)/(abs(xi + pi_2)^3)
  + pi_2 (xi + pi_2 - 1)/(abs(xi + pi_2 - 1)^3) - xi = 0 $ <m19-colineales>

#clave[
  *Por qué dos salieron exactos y estos tres no.* La diferencia no es de
  suerte. Con $y != 0$ había *dos* ecuaciones independientes y eso alcanzó
  para fijar las dos distancias de golpe. Sobre el eje, la ecuación de $y$ se
  satisface sola y queda *una* sola condición para una sola incógnita — pero
  esa condición, sacándole los denominadores, es un *polinomio de grado
  cinco* en $xi$. Y desde Abel se sabe que la quíntica general no tiene
  solución por radicales.

  O sea que la @m19-colineales no se despeja *nunca*, ni con más paciencia ni
  con más álgebra. Se resuelve numéricamente, y hay que hacerlo una vez por
  cada par de cuerpos. Lo que sí se sabe de antemano es *cuántas* raíces hay
  y dónde: una a la izquierda de $m_1$ ($L_3$), una entre los dos primarios
  ($L_1$) y una más allá de $m_2$ ($L_2$).
]

#definicion("el método de bisección")[
  La receta más simple para encontrar una raíz de $f(x) = 0$, y la que Curtis
  usa acá (algoritmo 2.4, pág. 123). Se parte de dos valores $x_ell < x_u$ que
  encierren la raíz, lo que se reconoce porque $f(x_ell)$ y $f(x_u)$ tienen
  *signos opuestos*. Se calcula el punto medio $x_m$; si $f(x_m)$ tiene el
  signo de $f(x_ell)$, la raíz está en $(x_m, x_u)$, y si no, en $(x_ell,
  x_m)$. Se repite con el intervalo nuevo.

  Cada paso parte el intervalo al medio, así que el error se divide por dos
  cada vez: para una tolerancia $epsilon$ alcanza con

  $ n > 1/(ln 2) ln(abs(x_u - x_ell)/epsilon) $

  pasos. Es lento comparado con otros métodos, pero *no puede fallar*
  mientras el intervalo inicial encierre la raíz — y eso, para una función
  con tres raíces y dos asíntotas verticales como la @m19-colineales, vale
  más que la velocidad.
]

#fig([Los cinco puntos de Lagrange del par Tierra–Luna. En el panel (a), a
escala real: $L_4$ y $L_5$ están sobre la propia órbita de la Luna, $60°$
por delante y por detrás, formando con la Tierra y la Luna dos triángulos
equiláteros —eso es la @m19-equilatero dibujada—, y los tres colineales
caen sobre el eje, con $L_3$ casi en el punto opuesto a la Luna. El panel
(b) amplía la zona que el panel (a) no puede mostrar: $L_1$ y $L_2$ están
a menos de $65 thin 000$ km de la Luna, y ahí aparecen *tres* fronteras que
miden lo mismo y no coinciden — las dos distancias a $L_1$ y $L_2$, la esfera
de Hill de la sección que sigue, y la esfera de influencia del módulo 17.
Entre la más chica y la más grande hay un 14%, y la sección que sigue mide
esa diferencia y explica de dónde sale.], fig-lagrange-puntos)

#ejemplo("los cinco puntos de Lagrange del sistema Tierra–Luna")[
  Con $m_1 = 5,974 times 10^24$ kg, $m_2 = 7,348 times 10^22$ kg y
  $r_12 = 384 thin 400$ km. (Curtis, ejemplo 2.16, pág. 124.)

  *La fracción de masa*, que es el único parámetro del problema:

  $ pi_2 = m_2/(m_1 + m_2) = (7,348 times 10^22)/(6,047 times 10^24) = 0,01215 $

  *Los dos triangulares, sin cuentas.* Por la @m19-l45 están sobre la órbita
  de la Luna, a $60°$ de ella: $x = 187 thin 529$ km,
  $y = plus.minus 332 thin 900$ km.

  *Los tres colineales, por bisección.* Se buscan las raíces de la
  @m19-colineales con $pi_2 = 0,01215$. Para $L_3$ conviene arrancar con
  $xi_ell = -1,1$ y $xi_u = -0,9$, que encierran la raíz porque
  $f(-1,1) = +0,262$ y $f(-0,9) = -0,046$ tienen signos opuestos. Con
  tolerancia $epsilon = 10^(-6)$ hacen falta $n = 18$ pasos, y sale
  $xi_3 = -1,00506$. Las otras dos, igual, arrancando de los dos lados de
  $xi = 1$:

  $ xi_1 = 0,83692, quad quad xi_2 = 1,15568, quad quad xi_3 = -1,00506 $

  Multiplicando por $r_12$ se obtienen las posiciones respecto del
  baricentro, y restándoles $x_1 = -pi_2 r_12 = -4670$ km, las distancias al
  *centro de la Tierra*, que es como se las suele dar:

  #align(center, table(
    columns: 4,
    stroke: none,
    align: (left, right, right, left),
    table.hline(stroke: 0.6pt),
    table.header([*Punto*], [*$x$ desde $G$*], [*desde la Tierra*], [*dónde está*]),
    table.hline(stroke: 0.4pt),
    [$L_1$], [321 710 km], [326 381 km], [entre la Tierra y la Luna],
    [$L_2$], [444 244 km], [448 915 km], [detrás de la Luna],
    [$L_3$], [$-386 thin 346$ km], [381 675 km], [del otro lado de la Tierra],
    table.hline(stroke: 0.6pt),
  ))

  *Lo que hay que leer en esos números.* $L_1$ y $L_2$ no están simétricos
  respecto de la Luna: quedan a $58 thin 019$ km y $64 thin 515$ km de ella,
  y esa asimetría no es un error de redondeo — es la centrífuga, que del lado
  de afuera ayuda y del lado de adentro estorba. Y $L_3$ no cae exactamente
  en el punto opuesto a la Luna sino un poco más lejos ($xi_3 = -1,005$ y no
  $-1$), porque desde ahí el cuerpo que hay que orbitar no es la Tierra sola
  sino el par entero.
]

#posta[
  Cinco puntos, y conviene tener una imagen de cada uno.

  $L_1$ es el *punto de vista*: está entre los dos cuerpos, mirando a los dos.
  Ahí está el SOHO, vigilando el Sol sin que la Tierra se le cruce nunca.

  $L_2$ es la *sombra*: está detrás del cuerpo chico visto desde el grande,
  así que una nave ahí tiene al Sol, a la Tierra y a la Luna todos del mismo
  lado y puede taparlos a los tres con una sola pantalla. Por eso está ahí el
  James Webb, que necesita estar helado para ver en infrarrojo.

  $L_3$ es el *inútil famoso*: está del otro lado del Sol, permanentemente
  invisible desde la Tierra. Es el que la ciencia ficción usó cien veces para
  esconder un planeta gemelo, y es justo el que menos sirve para algo real,
  porque desde ahí no se puede ni hablar con casa.

  $L_4$ y $L_5$ son los *estacionamientos*: los únicos estables, y por eso los
  únicos donde la naturaleza puso cosas sola. En los de Júpiter hay miles de
  asteroides —los troyanos— que llevan ahí toda la vida del sistema solar sin
  que nadie los mantenga.
]

== Dos fronteras para lo mismo: Hill contra la esfera de influencia

Acá hay algo que conviene mirar de frente, porque el apunte ya definió una
frontera para el mismo problema y no es ésta.

El módulo 17 dibujó la *esfera de influencia* comparando perturbaciones, y le
dio a la Luna un radio de $66 thin 200$ km (@m17-soi). Este módulo acaba de
poner a $L_1$ a $58 thin 019$ km de la Luna, que es *otra* frontera para lo
mismo: más allá de $L_1$ la nave ya no le pertenece a la Luna. Las dos
pretenden marcar dónde termina el dominio de un cuerpo, salen de criterios
distintos y dan números distintos. Vale la pena entender cuánto y por qué.

#deduccion("el radio de Hill, o por qué L1 está donde está")[
  La posición exacta de $L_1$ pide la quíntica, pero su *tamaño* sale en tres
  renglones si se supone que está cerca de $m_2$, que es lo que pasa cuando
  $m_2 << m_1$. Se llama $d$ a la distancia de $L_1$ a $m_2$, con
  $d << r_12$. Entonces $r_1 = r_12 - d$, $r_2 = d$, y
  $x - pi_1 r_12 = -d$, así que la condición de equilibrio sobre el eje queda

  $ Omega^2 (pi_1 r_12 - d) = (mu_1)/((r_12 - d)^2) - (mu_2)/d^2 $

  Con $Omega^2 = mu\/r_12^3$ y $pi_1 mu = mu_1$, el miembro izquierdo es
  $mu_1\/r_12^2 - mu d\/r_12^3$. En el derecho se desarrolla el primer
  término a primer orden, $1\/(1-epsilon)^2 approx 1 + 2 epsilon$ con
  $epsilon = d\/r_12$:

  $ (mu_1)/(r_12^2) - (mu d)/(r_12^3)
    = (mu_1)/(r_12^2) + (2 mu_1 d)/(r_12^3) - (mu_2)/d^2 $

  Los dos $mu_1\/r_12^2$ se cancelan —y eso es lo que hay que ver: *el tirón
  del cuerpo grande no decide nada acá*, porque le pega casi igual a la nave
  y a $m_2$, que es la misma idea de marea del módulo 17—. Queda

  $ (mu_2)/d^2 = ((3 mu_1 + mu_2) d)/(r_12^3) approx (3 mu_1 d)/(r_12^3) $
]

$ r_"Hill" = r_12 (m_2/(3 m_1))^(1\/3) $ <m19-hill>

Para la Luna da $61 thin 524$ km, que es un 6% más que los $58 thin 019$ km
medidos de $L_1$ — el precio de haber desarrollado a primer orden. La
comparación con la esfera de influencia es lo interesante:

#align(center, table(
  columns: 5,
  stroke: none,
  align: (left, right, right, right, right),
  table.hline(stroke: 0.6pt),
  table.header(
    [*Cuerpo chico*],
    [*$L_1$*],
    [*Hill (@m19-hill)*],
    [*SOI (módulo 17)*],
    [*$L_2$*],
  ),
  table.hline(stroke: 0.4pt),
  [Luna (frente a la Tierra)], [58 019 km], [61 524 km], [66 183 km], [64 515 km],
  [Tierra (frente al Sol)], [1 491 577 km], [1 496 585 km], [924 664 km], [1 501 558 km],
  table.hline(stroke: 0.6pt),
))

#clave[
  *Las dos fórmulas no son la misma aproximación de lo mismo: son dos
  criterios distintos, y se separan cuando la razón de masas se hace chica.*
  Dividiendo la @m19-hill por la @m17-soi del módulo 17, todo lo dimensional
  se va y queda una potencia sola:

  $ r_"Hill"/r_"SOI" = (1/3)^(1\/3) (m_2/m_1)^(1\/3 - 2\/5)
    = 0,693 (m_2/m_1)^(-1\/15) $ <m19-razon>

  Ese exponente $-1\/15$ es *tan chico* que la razón casi no se mueve: hay
  que cambiar la relación de masas en un factor de mil para que cambie un
  50%. Por eso las dos fronteras dan parecido en casi todos los pares del
  sistema solar y nadie nota que son cosas distintas. Pero «casi no se mueve»
  no es «no se mueve»: para la Luna frente a la Tierra la razón vale $0,93$
  —Hill es *más chica* que la esfera de influencia— y para la Tierra frente
  al Sol vale $1,62$, o sea Hill es un 62% *más grande*.

  Y esa segunda fila tiene una consecuencia concreta, que se lee en la tabla
  de arriba: *$L_1$ y $L_2$ del sistema Sol–Tierra están afuera de la esfera
  de influencia de la Tierra*. Están a 1,5 millones de kilómetros, y la
  esfera de influencia del módulo 17 termina a $925 thin 000$. O sea que el SOHO y
  el James Webb están en lugares que el método de las cónicas parcheadas
  considera *territorio del Sol*, en los que sin embargo se quedan quietos
  respecto de la Tierra. Ninguna de las dos descripciones está mal: están
  contestando preguntas distintas.
]

#cuidado[
  *No hay que elegir una de las dos fronteras: hay que saber cuál contesta la
  pregunta que uno tiene.* La esfera de influencia mide *qué término de la
  ecuación de movimiento se puede ignorar*, y sirve para decidir con qué
  problema de dos cuerpos se aproxima cada tramo de un viaje: es una
  herramienta de *diseño de trayectorias*. La esfera de Hill mide *hasta
  dónde un cuerpo puede retener algo en órbita propia*, y sirve para decidir
  si una luna es estable o si un satélite se escapa: es una herramienta de
  *estabilidad*.

  Un ejemplo donde la diferencia importa: una nave a $70 thin 000$ km de la
  Luna está afuera de las dos fronteras, pero una a $63 thin 000$ km está
  *adentro* de la esfera de influencia y *afuera* de la de Hill. Eso quiere
  decir que se la puede seguir calculando como un problema de dos cuerpos con
  la Luna —la aproximación es buena—, pero que no va a quedarse: no hay
  órbita lunar estable ahí.
]

#clave[
  *La esfera de Hill queda siempre entre $L_1$ y $L_2$, y eso no es
  casualidad.* Se ve en las dos filas de la tabla:
  $58 thin 019 < 61 thin 524 < 64 thin 515$ para la Luna, y
  $1 thin 491 thin 577 < 1 thin 496 thin 585 < 1 thin 501 thin 558$ para la
  Tierra. La
  @m19-hill es el desarrollo a primer orden de la *misma* condición de
  equilibrio que da los dos puntos, y a ese orden $L_1$ y $L_2$ son
  simétricos respecto de $m_2$: la asimetría es de segundo orden. El radio de
  Hill es, literalmente, el promedio de los dos a primer orden.
]

== Cuáles sirven para estacionar

Que un punto sea de equilibrio no dice nada sobre qué pasa si la nave se
corre un poco. Un lápiz parado sobre la punta está en equilibrio.

#definicion("equilibrio estable e inestable")[
  Un punto de equilibrio es *estable* si una nave desplazada un poco tiende a
  volver —en la práctica queda oscilando alrededor del punto, en lo que se
  llama una *órbita halo*— e *inestable* si se aleja cada vez más rápido y
  termina yéndose del todo.

  Para el problema restringido circular, el resultado es (Battin, 1987):

  - *$L_1$, $L_2$ y $L_3$ son siempre inestables*, para cualquier razón de
    masas.
  - *$L_4$ y $L_5$ son estables* si las masas son lo bastante distintas:

  $ m_1/m_2 + m_2/m_1 >= 25 $ <m19-estable>
]

La @m19-estable se lee mejor despejada. Llamando $k = m_1\/m_2$, la condición
$k + 1\/k >= 25$ es $k^2 - 25 k + 1 >= 0$, cuya raíz mayor es
$(25 + sqrt(621))\/2$:

$ k >= 24,96 quad quad "o, en fracción de masa," quad quad pi_2 <= 0,0385 $ <m19-routh>

Para el par Tierra–Luna $k = 81,3$ y para el par Sol–Júpiter $k$ es más de
mil: los dos pasan cómodos. Y ahí están, efectivamente, los miles de
asteroides troyanos de Júpiter — que es la mejor comprobación experimental
que se puede pedir, porque nadie los puso.

#cuidado[
  *Que $L_4$ y $L_5$ del par Tierra–Luna cumplan el criterio no quiere decir
  que una nave se quede ahí sola.* El criterio de la @m19-estable vale para
  el problema restringido *de tres cuerpos*, y en el sistema Tierra–Luna hay
  un cuarto que no es despreciable: el Sol. Su perturbación desestabiliza los
  dos puntos triangulares, así que una nave estacionada ahí igual necesita
  corregir.

  Es el mismo tipo de advertencia que cierra el módulo 17: un modelo dice
  hasta dónde llega él, no hasta dónde llega la realidad.
]

#posta[
  Acá hay algo que suena mal y no lo es: *casi todas las misiones reales
  están en los puntos inestables*, no en los estables. SOHO y el James Webb
  están en $L_1$ y $L_2$ del par Sol–Tierra, que se les escapan solos.

  Hay dos razones y las dos son plata. La primera es que los puntos
  inestables están *donde uno los necesita* —$L_1$ mirando al Sol, $L_2$ con
  todo el calor a la espalda— y los estables están a 150 millones de
  kilómetros de la Tierra, tan lejos como el Sol.

  La segunda es más linda: *la inestabilidad también es barata para salir*.
  Un punto que te expulsa si te corrés un poco es un punto al que también se
  llega, y del que se sale, con un empujón mínimo. Las trayectorias de bajo
  consumo entre la Tierra y la Luna —las que tardan meses en vez de días—
  usan justamente eso: se dejan caer por donde el sistema ya los quiere
  llevar. Un lugar estable es cómodo para quedarse y caro para irse.
]

== La constante de Jacobi: el diagrama de energía, otra vez

Las tres ecuaciones de movimiento no se resuelven, pero *algo* se conserva. Y
lo que se conserva alcanza para contestar, sin integrar nada, la pregunta más
útil que hay: ¿a dónde *no* puede llegar esta nave?

#deduccion("la constante de Jacobi")[
  El truco es el mismo que el módulo 5 usó para sacar el teorema del trabajo
  y la energía: multiplicar cada ecuación por la velocidad correspondiente y
  sumar. Se multiplica la @m19-mov-x por $dot(x)$, la @m19-mov-y por
  $dot(y)$, la @m19-mov-z por $dot(z)$, y se suman las tres.

  *Lo primero que pasa es que Coriolis desaparece.* Los dos términos que
  aporta son $-2 Omega dot(y) dot(x)$ y $+2 Omega dot(x) dot(y)$: se cancelan
  exactamente.

  De los términos que quedan, los del miembro izquierdo son derivadas
  reconocibles:

  $ dot.double(x) dot(x) + dot.double(y) dot(y) + dot.double(z) dot(z)
    = 1/2 dif/(dif t) (v^2), quad quad
    x dot(x) + y dot(y) = 1/2 dif/(dif t) (x^2 + y^2) $

  y el miembro derecho también, aunque cueste más verlo. Derivando
  $r_1^2 = (x + pi_2 r_12)^2 + y^2 + z^2$ respecto del tiempo y despejando
  sale

  $ dif/(dif t) (1/r_1) = - 1/r_1^3 (x dot(x) + y dot(y) + z dot(z) + pi_2 r_12 dot(x)) $

  que es exactamente el paréntesis que acompaña a $mu_1\/r_1^3$ en la suma, y
  lo mismo con $r_2$. Entonces la suma entera es la derivada de una sola cosa:

  $ dif/(dif t) [1/2 v^2 - 1/2 Omega^2 (x^2 + y^2) - (mu_1)/r_1 - (mu_2)/r_2] = 0 $

  y lo que está adentro del corchete es constante.
]

$ C = v^2/2 - (Omega^2 (x^2 + y^2))/2 - (mu_1)/r_1 - (mu_2)/r_2 $ <m19-jacobi>

donde $v$ es la rapidez *relativa al marco que gira*. Ésa es la *constante de
Jacobi*, descubierta en 1836, y es la única cantidad conservada que se conoce
para este problema.

#clave[
  *Coriolis no aparece en la @m19-jacobi porque no trabaja.* La cancelación
  de los dos términos no fue un golpe de suerte algebraico: la aceleración de
  Coriolis es $-2 bold(Omega) times bold(v)$, siempre *perpendicular a la
  velocidad*, y una fuerza perpendicular al movimiento no hace trabajo — es
  el mismo argumento con el que el módulo 5 mostró que la componente
  transversal no aporta. Por eso desvía la trayectoria pero no cambia el
  balance energético.

  Y eso deja a la constante de Jacobi con la estructura exacta de una
  energía. Llamando *potencial de Jacobi* a todo lo que no es cinético,

  $ U_J = - (Omega^2 (x^2 + y^2))/2 - (mu_1)/r_1 - (mu_2)/r_2,
    quad quad C = v^2/2 + U_J $ <m19-potj>

  queda $C = K + U_J$, que es el $E = K + U$ del módulo 5 palabra por
  palabra. Los dos últimos términos de $U_J$ son las energías potenciales
  gravitatorias de los dos primarios, y el primero es la energía potencial de
  la fuerza centrífuga — negativa y creciente en módulo hacia afuera, porque
  la centrífuga empuja para afuera.
]

#notacion[
  *El nombre «potencial de Jacobi» es de este apunte, no del libro.* Curtis
  escribe la @m19-jacobi entera y no le pone nombre a la agrupación. Se le
  puso uno acá por la misma razón por la que el módulo 9 usa «potencial
  eficaz»: sin un nombre para el bulto, la única forma de leer la ecuación es
  término por término, y con nombre se lee como un diagrama de energía de una
  variable, que es lo que es. Ojo también con el factor: buena parte de la
  bibliografía define la constante con un $2$ adelante o con el signo
  cambiado, así que los valores numéricos de $C$ no se comparan entre libros
  sin mirar la definición.
]

Como $v^2 >= 0$ siempre, la @m19-potj impone una condición sobre *dónde puede
estar* la nave:

$ C >= U_J (x, thin y, thin z) $ <m19-prohibido>

Los puntos donde $C < U_J$ son *inalcanzables*: llegar ahí pediría energía
cinética negativa. La superficie donde vale la igualdad —donde la nave
llegaría con velocidad exactamente nula— es la *superficie de velocidad
cero*, y es una pared: la trayectoria no la cruza.

#fig([El potencial de Jacobi a lo largo de la línea Tierra–Luna, que es el
diagrama de energía del módulo 5 aplicado a este problema. Lo que hay que
sacar del dibujo es cómo se lee: la nave tiene un $C$ fijo, que se dibuja
como una recta horizontal, y sólo puede estar donde esa recta queda *por
encima* de la curva. Los tres máximos son $L_1$, $L_2$ y
$L_3$ — y que sean máximos es la razón de que los tres sean inestables. La
ventana vertical es angosta a propósito: mide 0,19 km#super[2]/s#super[2] de
alto, porque las tres alturas que importan están dentro de ese rango y con
una ventana que mostrara los dos pozos enteros, $C_1$ y $C_2$ quedarían
encimadas. Los dos pozos se van por abajo del dibujo, y ahí es donde están
la Tierra y la Luna.], fig-jacobi-perfil)

#clave[
  *Las cuatro puertas, en orden, y cuánto cuesta cada una.* La figura se lee
  de abajo hacia arriba, y cada vez que la recta de $C$ sube por encima de un
  máximo se abre un camino nuevo. Para el par Tierra–Luna:

  + *$C < C_1$* — la nave está encerrada alrededor de la Tierra. Del otro lado
    de $L_1$ hay una región permitida alrededor de la Luna, pero no se puede
    llegar: están separadas por la barrera.
  + *$C = C_1 = -1,6735$* — se abre $L_1$ y las dos regiones se conectan por
    un corredor angosto. *Recién acá la Luna es alcanzable.*
  + *$C = C_2 = -1,6650$* — se abre $L_2$: la nave puede salir del sistema
    Tierra–Luna, pasando por detrás de la Luna. Es el mínimo de energía para
    escapar del par.
  + *$C = C_3 = -1,5810$* — se abre $L_3$ y la salida también es posible por
    el lado opuesto a la Luna.

  Más arriba de $C_3$ lo último que queda prohibido son dos islas alrededor
  de $L_4$ y $L_5$, que también terminan desapareciendo. Y la escala de la
  figura dice lo que hay que llevarse: *entre abrir la puerta a la Luna y
  abrir la puerta de salida del sistema hay $0,0085$ km#super[2]/s#super[2]*,
  una diferencia de medio por ciento.
]

#cuidado[
  *Dos cosas que la constante de Jacobi no dice, y que es fácil creer que
  dice.*

  La primera: *$C$ no es la energía de la nave.* La energía mecánica de la
  nave en un marco inercial *no se conserva* — los dos primarios se mueven, y
  un campo gravitatorio que cambia con el tiempo hace trabajo neto. Lo que se
  conserva es esta combinación, y sólo en el marco que gira. Por eso el
  término centrífugo aparece con el aspecto de una energía potencial aunque
  la centrífuga no sea una fuerza real.

  La segunda, más peligrosa: *que una región esté permitida no quiere decir
  que la nave vaya a llegar.* La @m19-prohibido es una condición *necesaria*,
  no suficiente: prohíbe, no promete. Con el $C$ justo para abrir $L_1$ la
  nave *puede* pasar a la región de la Luna, pero si apunta para otro lado no
  pasa. Saber a dónde llega de verdad pide integrar las ecuaciones, y eso
  vuelve al principio del módulo.
]

#ejemplo("cuánta velocidad separa quedarse en casa de escaparse del sistema", nivel: "a fondo")[
  Una nave se apaga a $200$ km de altura sobre la Tierra, en el punto del eje
  $y$ del marco rotante (o sea, a $90°$ de la línea Tierra–Luna), con la
  velocidad de apagado $v_"bo"$ relativa al marco. ¿Cuánto vale $v_"bo"$ para
  cada uno de los seis escenarios de la figura anterior? (Curtis, ejemplo
  2.17, pág. 130.)

  *El planteo es un despeje, y eso es todo el ejemplo.* De la @m19-jacobi,

  $ v^2 = Omega^2 (x^2 + y^2) + (2 mu_1)/r_1 + (2 mu_2)/r_2 + 2 C $

  Las coordenadas del punto de apagado son las de la Tierra en $x$ —porque el
  punto está sobre la vertical de la Tierra— y el radio en $y$:

  $ x = -pi_2 r_12 = -4670,6 " km", quad quad y = -(6378 + 200) = -6578 " km" $

  Con $mu_1 = 398 thin 620$ km#super[3]/s#super[2], $mu_2 = 4903$
  km#super[3]/s#super[2] y $Omega = 2,6654 times 10^(-6)$ rad/s, cada valor
  de $C$ da su $v_"bo"$:

  #align(center, table(
    columns: 3,
    stroke: none,
    align: (right, right, left),
    table.hline(stroke: 0.6pt),
    table.header([*$C$* (km#super[2]/s#super[2])], [*$v_"bo"$* (km/s)], [*qué habilita*]),
    table.hline(stroke: 0.4pt),
    [$-1,8000$], [10,8455], [ni siquiera llega a la Luna],
    [$-1,6735$], [10,8571], [se abre $L_1$: la Luna es alcanzable],
    [$-1,6649$], [10,8579], [se abre $L_2$: se puede escapar],
    [$-1,5810$], [10,8656], [se abre $L_3$],
    [$-1,5683$], [10,8667], [quedan sólo las islas de $L_4$ y $L_5$],
    [$-1,5600$], [10,8676], [todo el sistema accesible],
    table.hline(stroke: 0.6pt),
  ))

  *Y ahora los dos números que hacen que valga la pena el ejemplo.* Entre la
  primera fila y la última hay *22 metros por segundo*: dos décimas de por
  ciento de la velocidad de apagado. Entre «no llego a la Luna» y «llego a la
  Luna» hay *12 metros por segundo*.

  Para tomarle la medida a eso: son doce metros por segundo sobre casi once
  mil, en un cohete que acaba de quemar el 95% de su masa. Y las seis
  velocidades están todas dentro del $1,5%$ de la velocidad de escape a esa
  altura, que por la @m16-vesc del módulo 16 vale

  $ v_"esc" = sqrt((2 mu_1)/r) = sqrt((2 dot 398 thin 600)/6578) = 11,01 " km/s" $

  #clave[
    *Ésta es la razón técnica por la que una inyección translunar es una
    maniobra de precisión.* No es que la trayectoria sea difícil de calcular:
    es que el rango entero de resultados cualitativamente distintos —desde
    quedarse en órbita terrestre hasta escapar del sistema Tierra–Luna—
    entra en 22 m/s.

    Y da la vuelta completa sobre el módulo 17. Allá, el error del método de
    las cónicas parcheadas se midió en $0,7$ km/s de velocidad en la frontera,
    y se dijo que eso eran «decenas de metros por segundo» en el diseño.
    Acá se ve contra qué escala hay que comparar esas decenas de metros por
    segundo.
  ]
]

#cuidado[
  *El ejemplo 2.17 de Curtis tiene dos erratas en tres renglones, las dos
  inofensivas para el resultado y las dos capaces de trabar a quien siga la
  cuenta.* La primera: imprime $m_1 = 5,947 times 10^24$ kg donde va
  $5,974 times 10^24$ — es la misma transposición de dos cifras que ya
  apareció en el ejemplo 2.13 (ver el módulo 18), y se confirma porque la
  división que el propio libro imprime dos símbolos más adelante da $0,9878$,
  que es lo que sale con $5,974$ y no con $5,947$.

  La segunda es más molesta: escribe $x_1 = -pi_1 r_12 = -0,9878 dot 384 thin
  400 = -4670,6$ km. El símbolo y el factor son los de $pi_1$, pero el
  resultado es el de $pi_2$: $0,9878 dot 384 thin 400 = 379 thin 700$, no
  $4670,6$. Lo correcto es $x_1 = -pi_2 r_12$, que es lo que dice la propia
  ecuación (2.177a) del libro, y el número impreso es el bueno.
]

== Lo que se usa después

Este módulo cierra la Parte V y, con ella, el apunte. Lo que queda dicho para
lo que siga:

1. *La deuda del tiempo sigue abierta, y ya no es de este módulo.* Los $3,2$
   días que el módulo 17 le atribuye a la travesía de la esfera de influencia
   de la Tierra siguen citados y no deducidos: piden la ecuación de Kepler
   hiperbólica, que el módulo 18 nombró y no desarrolló. Este módulo tampoco,
   y a propósito: es el capítulo 3 de Curtis y es un tema entero. Acá no
   habría entrado sin desplazar lo que sí es de tres cuerpos.

2. *El problema de cuatro cuerpos no existe como tema aparte.* Cuando hay un
   cuerpo más —el Sol perturbando el par Tierra–Luna, por ejemplo— no hay una
   teoría nueva: se integra numéricamente, con las mismas ecuaciones de la
   sección 19.2 más un término por cada cuerpo que se agregue. Todo lo que
   este módulo dedujo sin integrar —los puntos de equilibrio, la constante de
   Jacobi, las regiones prohibidas— *deja de valer exactamente* y sigue
   valiendo como primera aproximación, que es justo lo que dice el cuadro
   rojo sobre $L_4$ y $L_5$ del par Tierra–Luna.

3. *Las tres fronteras de un cuerpo chico.* Quedan las tres definidas y con
   sus criterios separados: la esfera de influencia del módulo 17 para decidir
   *con qué problema de dos cuerpos se aproxima cada tramo*, la esfera de
   Hill de la @m19-hill para decidir *qué puede quedar en órbita*, y las
   distancias exactas a $L_1$ y $L_2$ cuando hace falta el número fino.

4. *Las órbitas halo*, que son el tema práctico que sale de acá: órbitas
   alrededor de un punto que no es un cuerpo. Son la aplicación directa de
   este módulo y el lugar donde están hoy varias de las misiones científicas
   más caras que hay volando.

5. *Y la idea que atraviesa la Parte V entera.* El módulo 16 dio la forma de
   toda salida y toda llegada; el 17, la licencia para partir un viaje en
   problemas de dos cuerpos y la medida de cuánto miente esa licencia; el 18,
   la forma de escribirlo todo en vectores para una computadora; y el 19, qué
   queda cuando la licencia se vence. Los cuatro contestan la misma pregunta
   desde cuatro lados: *cuánto se puede saber de una trayectoria sin
   resolverla.*
