#import "../plantilla.typ": *

#modulo("Cantidad de movimiento, impulso y choques")[
  Escribir la segunda ley en la forma que sobrevive cuando la masa cambia;
  calcular el impulso de una fuerza que dura poco y de la que no se conoce
  la forma; decidir —antes de escribir una ecuación— en qué dirección se
  conserva la cantidad de movimiento y en cuál no; y resolver un choque
  oblicuo hasta el final, incluida la fracción de energía que se disipa.
]

La materia se apoya en tres teoremas de conservación, y este es el primero. No
es el más profundo —ese es el del momento angular, que llega en el módulo 7—
pero sí el que más se usa: la propulsión de un cohete, el choque de dos
cuerpos, el retroceso de un satélite que suelta una antena, todo eso es este
teorema y nada más.

La cátedra lo dijo con una frase que conviene tomar en serio: *«es muy
importante para entender el impulso de un cohete»*. El módulo 4 es la
consecuencia directa de este.

== De $bold(F) = m bold(a)$ a $bold(F) = d bold(p) \/ d t$

La *cantidad de movimiento* de una partícula es

$ bold(p) = m bold(v) $

Un vector, con la dirección de la velocidad, que se mide en kg·m/s. Con él, la
segunda ley de Newton se escribe

$ sum bold(F) = (d bold(p)) / (d t) $ <m2-segunda-ley>

que es la forma en que Newton la enunció, y no la que se aprende primero.

#deduccion("por qué esta forma es más general que F = ma")[
  Derivando $bold(p) = m bold(v)$ con la regla del producto:
  $ (d bold(p)) / (d t) = m (d bold(v)) / (d t) + (d m) / (d t) bold(v) = m bold(a) + dot(m) bold(v) $
  Si la masa es constante, $dot(m) = 0$ y queda $sum bold(F) = m bold(a)$: las
  dos formas coinciden. Si la masa *no* es constante —un cohete que quema
  combustible, una vagoneta que pierde arena— sólo la primera sigue siendo
  cierta. (S&Z §8.1, ec. 8.4, pág. 238.)
]

#cuidado[
  Ese $dot(m) bold(v)$ del renglón de arriba *no* es la ecuación del cohete, y
  usarlo así es el error clásico. El motivo está en el módulo 4: en un cohete el
  sistema de masa $m$ no es cerrado —le sale masa por atrás—, y la segunda ley
  vale para sistemas cerrados. El planteo correcto es aplicar la conservación de
  $bold(p)$ al conjunto *cohete más gas*, y de ahí sale un término distinto.
]

#notacion[
  *Acá se acumulan tres notaciones distintas para lo mismo, y una de ellas está
  invertida.* La cátedra lo avisó textualmente:

  #table(
    columns: (auto, auto, 1fr),
    align: (left, center, left),
    table.header([*Fuente*], [*Cantidad de movimiento*], [*Momento angular*]),
    [este apunte y la cátedra], [$bold(P)$, $bold(p)$], [$bold(L)$],
    [Roederer], [$bold(P)$, $bold(p)$ («impulso»)], [$bold(L)$],
    [Beer, caps. 12 a 18], [$bold(L)$], [$bold(H)$],
  )

  Roederer llama *impulso* a $m bold(v)$ —lo dice en la pág. 111— y eso choca
  con la convención de la cátedra, que reserva la palabra *impulso* para
  $integral bold(F) d t$. Textual de la cátedra: «ojo con las denominaciones:
  para nosotros $P$ es cantidad de movimiento y $Delta P$ es variación de
  cantidad de movimiento. La fuerza por el tiempo es el impulso». Este apunte
  usa la convención de la cátedra.
]

== El impulso: integrar la fuerza en el tiempo <m2-impulso>

En un choque la fuerza dura milisegundos, es enorme y su forma exacta no la
conoce nadie. Lo notable es que para saber cómo quedan los cuerpos *no hace
falta conocerla*: alcanza con su integral.

#deduccion("el teorema del impulso, en dos renglones")[
  Se integra la @m2-segunda-ley entre $t_1$ y $t_2$:
  $ integral_(t_1)^(t_2) sum bold(F) d t = integral_(t_1)^(t_2) (d bold(p)) / (d t) d t = bold(p)_2 - bold(p)_1 $
  Al miembro de la izquierda se lo llama *impulso* $bold(J)$, y el resultado es
  el *teorema del impulso y la cantidad de movimiento*:
  $ bold(J) = integral_(t_1)^(t_2) sum bold(F) d t = Delta bold(p) $
  (S&Z ec. 8.6 y 8.7, pág. 239.) Es la ec. (4.5a) de Roederer, pág. 111.
]

#fig([La fuerza de un choque es un pico corto de forma desconocida. El impulso
es el *área* bajo la curva, y esa área es todo lo que hace falta. La fuerza
media $F_"med"$ se define, justamente, como la altura del rectángulo de igual
área.], fig-impulso-area)

Si la fuerza es constante —o si se la reemplaza por su media— la integral se
reduce a un producto:

$ bold(J) = bold(F)_"med" (t_2 - t_1) = bold(F)_"med" Delta t $

#clave[
  El impulso explica por qué un airbag salva vidas sin cambiar en nada el
  $Delta bold(p)$. La cantidad de movimiento que hay que sacarle al cuerpo está
  fijada por el choque; el airbag no la toca. Lo que hace es *estirar $Delta t$*,
  y como $F_"med" = Delta p \/ Delta t$, la fuerza baja en la misma proporción.
  Mismo impulso, otra fuerza.
]

== Cuándo se conserva: fuerzas internas y externas

Para un sistema de dos partículas $A$ y $B$ que interactúan entre sí y además
reciben fuerzas de afuera:

#deduccion("la conservación de P sale de la tercera ley")[
  Para cada partícula vale la @m2-segunda-ley:
  $ (d bold(p)_A) / (d t) = bold(F)_(B->A) + bold(F)_(A,"ext"), quad
    (d bold(p)_B) / (d t) = bold(F)_(A->B) + bold(F)_(B,"ext") $
  Sumando las dos, y usando que por la *tercera ley*
  $bold(F)_(B->A) = -bold(F)_(A->B)$, las fuerzas internas se cancelan de a
  pares y queda
  $ (d bold(P)) / (d t) = sum bold(F)_"ext", quad "con" quad bold(P) = bold(p)_A + bold(p)_B $
  De donde: *si la resultante de las fuerzas externas es nula, $bold(P)$ es
  constante.* (S&Z ecs. 8.10 a 8.13, §8.2, pág. 243.)
]

Lo importante de esa deducción no es el resultado sino *de dónde sale*: la
conservación de $bold(P)$ es la tercera ley de Newton escrita de otra manera.
Las fuerzas internas —por violentas que sean— nunca pueden cambiar el
$bold(P)$ total, porque vienen siempre de a pares opuestos.

#geometria[
  *$bold(P)$ se conserva componente a componente, y cada componente es una
  pregunta aparte.* La cátedra lo remarcó: «$P$ puede conservarse aun con
  fuerzas externas distintas de cero». El caso típico es un choque sobre una
  mesa: el peso y la normal son externos y no se cancelan instantáneamente,
  pero son *verticales*, así que la componente horizontal de $bold(P)$ se
  conserva igual.

  El procedimiento, antes de escribir nada: elegir los ejes, listar las fuerzas
  externas, y preguntarse por *cada eje por separado* si la suma de sus
  proyecciones es cero. Un choque en el plano da dos ecuaciones escalares, y
  puede pasar que una valga y la otra no.
]

#clave[
  Y hay un segundo caso, que es el que hace que los choques se puedan resolver:
  aunque haya fuerzas externas no nulas en todas las direcciones, si el choque
  dura $Delta t -> 0$ su impulso $bold(F)_"ext" Delta t$ es despreciable frente
  al de las fuerzas internas, que son enormes. Por eso *durante el choque*
  $bold(P)$ se conserva, aunque un segundo antes y un segundo después no lo
  haga.
]

== Choques: qué se conserva y qué no

En todo choque —siempre que las externas no cuenten, por lo recién dicho— se
conserva $bold(P)$. La energía cinética *puede o no* conservarse, y eso es lo
que da la clasificación:

#table(
  columns: (auto, auto, 1fr),
  align: (left, center, left),
  table.header([*Tipo*], [*$bold(P)$*], [*$K$*]),
  [elástico], [se conserva], [se conserva],
  [inelástico], [se conserva], [no: parte se va a deformación y calor],
  [perfectamente inelástico], [se conserva], [no, y es el que más disipa: los cuerpos quedan pegados],
)

La cátedra lo dijo así: *«para evaluar un choque hay que tener $P$ y $E$ antes
y después»*. Las dos cosas, siempre, aunque la segunda dé distinta.

#deduccion("el choque elástico frontal y la velocidad relativa")[
  Con dos cuerpos sobre una recta, $bold(P)$ y $K$ conservadas dan dos
  ecuaciones. Resolviéndolas (S&Z §8.4, ecs. 8.24 y 8.25, pág. 252) con $B$
  inicialmente en reposo:
  $ v_(A 2) = (m_A - m_B) / (m_A + m_B) v_(A 1), quad
    v_(B 2) = (2 m_A) / (m_A + m_B) v_(A 1) $
  Pero lo que conviene recordar no son esas dos fórmulas sino su consecuencia,
  que vale *para cualquier choque elástico rectilíneo*, con o sin cuerpo en
  reposo (ec. 8.26, pág. 252):
  $ v_(B 2) - v_(A 2) = -(v_(B 1) - v_(A 1)) $
  *La velocidad relativa cambia de signo y conserva el módulo.* Un renglón, y
  reemplaza a la ecuación cuadrática de la energía — que es la que se hace
  larga.
]

#cuidado[
  *La energía no es una ecuación vectorial.* En un choque en el plano,
  $bold(P)$ da *dos* ecuaciones escalares (una por eje) y $K$ da *una* sola.
  Contar mal esto es el error que deja un problema con más incógnitas que
  ecuaciones — o con una ecuación de más, que es peor, porque parece que
  sobra información y en realidad se está usando dos veces la misma.
]

#ejemplo("La astronauta y la herramienta")[
  _(Ej. 1 de la guía; S&Z 8.16.)_ Una astronauta de $68,5$ kg repara la
  estación espacial. Arroja una herramienta de $2,25$ kg con una rapidez de
  $3,20$ m/s *respecto de la estación*. ¿Con qué rapidez y en qué dirección
  empieza a moverse la astronauta?

  *Planteo.* El sistema es astronauta $+$ herramienta. Está flotando: no hay
  fuerzas externas apreciables, así que $bold(P)$ se conserva. Y arranca en
  reposo respecto de la estación, o sea $bold(P) = bold(0)$ *antes y después*.

  *Cuenta.* Sobre el eje del lanzamiento:
  $ 0 = m_h v_h + m_a v_a ==> v_a = - (m_h v_h) / (m_a) = - (2,25 dot 3,20) / (68,5) $
  $ v_a = -0,105 " m/s" $

  El signo dice lo esperable: *en sentido contrario al de la herramienta*, a
  unos 10,5 cm/s.

  #cuidado[
    El enunciado dice «respecto de la estación», y eso es un dato, no un
    adorno. Si la rapidez fuera #box[$3,20$ m/s] *respecto de la astronauta*, la
    ecuación sería $0 = 2,25 (3,20 + v_a) + 68,5 v_a$, y daría
    $v_a = -0,102$ m/s. La diferencia es chica acá porque la astronauta se
    mueve poco; en el módulo 4, con un cohete, la misma distinción cambia
    todo el resultado.
  ]
]

#ejemplo("Choque oblicuo de dos asteroides", nivel: "a fondo")[
  _(Ej. 2 de la guía; S&Z 8.31.)_ Dos asteroides de igual masa chocan de forma
  oblicua. $A$ viajaba a $40,0$ m/s; después del choque se desvía $30,0degree$
  respecto de su dirección original, y $B$ —que estaba en reposo— sale a
  $45,0degree$ del otro lado.
  #linebreak()
  *(a)* Rapidez de cada uno después del choque. *(b)* ¿Qué fracción de la
  energía cinética original de $A$ se disipa?

  #v(4pt)
  #fig-choque-oblicuo
  #v(4pt)

  *Paso 0 — qué se conserva.* En el espacio no hay externas: $bold(P)$ se
  conserva, y como es un vector, *da dos ecuaciones*. De la energía no se sabe
  nada todavía — justamente eso es lo que la parte (b) va a averiguar. Con dos
  incógnitas ($v_A$ y $v_B$) y dos ecuaciones, el problema cierra sin usar la
  energía. Ese es el planteo entero.

  *Paso 1 — los ejes.* $x$ a lo largo de la dirección original de $A$; $y$
  perpendicular. Las masas son iguales, así que $m$ se cancela en todo y se
  puede trabajar directamente con rapideces.

  *Paso 2 — las dos ecuaciones.*
  $ y: quad 0 = v_A sin 30degree - v_B sin 45degree $
  $ x: quad 40,0 = v_A cos 30degree + v_B cos 45degree $

  La ecuación en $y$ es la que más información trae, y es gratis: como $bold(P)$
  no tenía componente $y$ antes, no puede tenerla después.

  *Paso 3 — resolver.* De la primera,
  $ v_B = (sin 30degree) / (sin 45degree) v_A = 0,7071 v_A $
  y reemplazando en la segunda:
  $ 40,0 = v_A (cos 30degree + 0,7071 cos 45degree) = v_A (0,8660 + 0,5000) = 1,3660 v_A $
  $ v_A = 29,3 " m/s", quad v_B = 20,7 " m/s" $

  *Paso 4 — la energía.* Con masas iguales, las $m$ se cancelan también acá:
  $ K_1 = 1/2 m (40,0)^2 = 800 m, quad
    K_2 = 1/2 m (29,283^2 + 20,706^2) = 643 m $
  $ (K_1 - K_2) / K_1 = (800 - 643) / 800 = 0,196 $

  *Se disipa el $19,6%$* de la energía cinética original. El choque es
  inelástico —lo era desde el principio, sólo que no se sabía—, y esto es lo
  que la cátedra quiere decir con «hay que tener $P$ y $E$ antes y después»:
  $bold(P)$ *resuelve*, y $E$ *diagnostica*.

  #geometria[
    Los dos ángulos suman $75degree$, no $90degree$, y eso no es un detalle:
    en un choque elástico de masas iguales con uno en reposo los cuerpos
    salen siempre a $90degree$ exactos. Que acá salgan a $75degree$ ya
    anticipaba, antes de tocar la energía, que el choque no es elástico. Es
    un control barato que conviene hacer de entrada.
  ]

  #cuidado[
    $K_2$ se calcula con las rapideces *sin redondear* ($29,283$ y $20,706$).
    Redondear a tres cifras antes de elevar al cuadrado y restar corre la
    fracción disipada en la segunda cifra decimal, porque es una resta de dos
    números parecidos: el error relativo se amplifica. La regla general:
    redondear sólo al final, nunca antes de una resta.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  Los ejercicios *1, 2 y 3* de la sección *Conservación de cantidad de
  movimiento*. El 1 y el 2 son los dos ejemplos de arriba. El *3* —el calamar
  que se propulsa expulsando agua (S&Z 8.19)— es el 1 con otro disfraz en su
  parte (a); su parte (b), la energía cinética que genera, se resuelve en el
  módulo 5. Los ejercicios *4 al 9* son todos del módulo 4.
]

== Lo que se usa después

1. *$bold(J) = Delta bold(p)$.* En el módulo 4 el «choque» dura todo el vuelo y
   se aplica a un pedacito de gas por vez; de ahí sale la ecuación del cohete.
   En el 14 reaparece con su gemelo angular, $integral bold(M) d t = Delta bold(L)$
   (Beer §14.9, ecs. 14.32 y 14.33 — la cátedra las marcó como «muy
   importantes»).

2. *La resultante externa manda, las internas nunca.* Es la misma idea que en
   el módulo 3 permite decir que el centro de masa de un sistema no se entera
   de lo que pasa adentro, y en el 7 que una fuerza central no cambia el
   momento angular.

3. *El hábito de preguntar «¿en qué dirección se conserva?» antes de escribir.*
   En órbitas la pregunta se vuelve «¿respecto de qué punto?», y es la misma
   clase de pregunta.
