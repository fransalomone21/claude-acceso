#import "../plantilla.typ": *

#modulo("El problema de dos cuerpos y la masa reducida")[
  Sacar la suposición que los módulos 6 y 7 hicieron sin decirlo —que el cuerpo
  central está clavado— y ver qué cambia. Deducir que el movimiento *relativo*
  de dos cuerpos que se atraen es idéntico al de uno solo alrededor de un centro
  fijo, con $mu = G(m_1 + m_2)$; deducir la *masa reducida* y el problema
  equivalente; y saber, con un número, cuándo la corrección importa y cuándo no.
]

Todo lo que se escribió en los módulos 6 y 7 tiene una suposición adentro que
nunca se declaró: que la Tierra no se mueve. Pero la tercera ley de Newton no
admite excepciones — si la Tierra tira del satélite, el satélite tira de la
Tierra con la misma fuerza, y la Tierra también se acelera. El origen de
coordenadas que se puso «en el centro de la Tierra» no era, entonces, un
sistema inercial.

Este módulo hace la cuenta bien y llega a una conclusión que da tranquilidad:
*casi todo lo anterior se salva*, con una sola sustitución. Pero la sustitución
no es cosmética, y hay sistemas —el Tierra–Luna, sin ir más lejos, que la guía
usa en dos problemas— donde ignorarla se paga.

== La idea completa, antes de la primera ecuación

Todavía no hay ninguna cuenta hecha, y conviene tener el plan entero en la
cabeza antes de la primera línea, porque lo que sigue cambia *qué pregunta se
hace*. En vez de seguir a los dos cuerpos por separado —dos posiciones
moviéndose a la vez, cada una tirando de la otra, un enroscamiento incómodo
de escribir en limpio—, la única cantidad que se va a perseguir de acá en
más es *cuánto se separan entre sí*. Y lo que este módulo muestra es que esa
separación sola se porta *exactamente* como un cuerpo inventado, dando
vueltas alrededor de un punto fijo que *no es ninguno de los dos cuerpos
reales*: es sólo el origen desde el que se mide esa separación, y nunca hace
falta ubicarlo en ningún lugar del espacio, porque nunca se usa su posición
—sólo la distancia a él.

#fig([El problema de dos cuerpos y su equivalente. *Izquierda:* lo que pasa
de verdad — dos elipses semejantes con foco común en el centro de masa
(el punto verde, «CM»), con los cuerpos siempre en lados opuestos; la del
cuerpo pesado es la chica. *Derecha:* el problema equivalente — un solo
cuerpo de masa $m_r = m_1 m_2 \/ (m_1 + m_2)$ a distancia $bold(r)$ de un
centro *fijo* (el otro punto verde), que no es $m_1$ ni $m_2$ ni está en
ningún lado real. Las dos figuras describen el mismo movimiento, y la de la
derecha es la que se sabe resolver.], fig-dos-cuerpos)

#clave[
  *El plan del módulo, en tres pasos, y en ese orden:*
  + Mostrar que la separación entre los dos cuerpos, $bold(r)$, obedece la
    misma ecuación que un cuerpo solo orbitando un punto fijo, con
    $mu = G(m_1+m_2)$ en el lugar del $G M$ de los módulos 6 y 7.
  + Mostrar que esa $bold(r)$ *es*, en todo instante, la separación real
    entre los dos cuerpos de verdad —no una aproximación ni una versión a
    escala—, así que resolver el problema de uno solo *ya resuelve* lo que
    hacía falta.
  + Recién al final, *sólo si además hace falta saber dónde está cada
    cuerpo por separado* —no nada más qué tan lejos están—, repartir esa
    misma $bold(r)$ entre las dos masas.

  Los pasos 1 y 2 son los que hacen que el módulo sirva. El 3 contesta una
  pregunta distinta, y muchas veces ni siquiera hace falta darlo.
]

== El planteo, sin suponer nada

Dos cuerpos, $m_1$ y $m_2$, en un sistema inercial cualquiera, con posiciones
$bold(R)_1$ y $bold(R)_2$. Se define el vector que va de uno al otro y su
versor:

$ bold(r) = bold(R)_2 - bold(R)_1, quad hat(u)_r = bold(r) \/ r $

La fuerza sobre cada uno es la de Newton, y por la tercera ley
$bold(F)_(2 1) = -bold(F)_(1 2)$ (apunte de clase, 23/9, pág. 1):

$ m_1 bold(accent(R, dot.double))_1 = (G m_1 m_2) / r^2 hat(u)_r,
  quad m_2 bold(accent(R, dot.double))_2 = -(G m_1 m_2) / r^2 hat(u)_r $

#deduccion("la ecuación del movimiento relativo")[
  Se simplifica la masa en cada ecuación —y en eso se va la mitad del problema—:
  $ bold(accent(R, dot.double))_1 = (G m_2) / r^2 hat(u)_r,
    quad bold(accent(R, dot.double))_2 = -(G m_1) / r^2 hat(u)_r $
  Y ahora se resta, que es lo único que hay que hacer:
  $ bold(accent(r, dot.double)) = bold(accent(R, dot.double))_2 - bold(accent(R, dot.double))_1 = -(G m_1)/r^2 hat(u)_r - (G m_2)/r^2 hat(u)_r = -(G (m_1 + m_2))/r^2 hat(u)_r $
  Las dos posiciones absolutas —que dependían del origen elegido— desaparecen, y
  queda una ecuación para la *diferencia* sola.
]

$ bold(accent(r, dot.double)) = -mu/r^2 hat(u)_r = -mu/r^3 bold(r),
  quad mu = G(m_1 + m_2) $ <m8-relativa>

#clave[
  *Ésta es la ecuación de la que salió toda la Parte III, y es exacta.* Compárese
  con la del módulo 6: allá se escribió $bold(accent(r, dot.double)) = -G M \/ r^2
  thin hat(u)_r$ con $M$ la masa del cuerpo central y $bold(r)$ medido desde él.
  La ecuación de arriba es *idéntica*, con una sola diferencia: donde decía $G M$
  ahora dice $G(m_1 + m_2)$.

  Por lo tanto *todo lo deducido en los módulos 6 y 7 —y todo lo que sigue en
  los módulos 9, 10 y 11— vale exactamente, sin ninguna aproximación, si se
  interpreta que $bold(r)$ es la posición relativa de un cuerpo respecto del
  otro y que $mu = G(m_1 + m_2)$.* No hubo que rehacer nada; hubo que
  reinterpretar dos símbolos.

  Y de paso se entiende por qué en el módulo 6 el parámetro $mu$ mereció una
  letra propia: no es una abreviatura de $G M$, es $G$ por la *suma* de las dos
  masas, y sólo se parece a $G M$ cuando una de las dos es despreciable.
]

#cuidado[
  *Errata en el apunte de clase de la cátedra (23/9, pág. 1): a la ecuación
  recuadrada le falta el signo menos.* Ahí está escrito
  $bold(accent(r, dot.double)) = mu bold(r) \/ r^3$, y la forma correcta es la
  @m8-relativa, con menos. La confirmación no requiere ninguna cuenta nueva: *el
  renglón inmediatamente anterior, en la misma hoja*, dice
  $bold(accent(r, dot.double)) = -G(m_1 + m_2) \/ r^2 thin hat(u)_r$, con su
  menos, y como $hat(u)_r = bold(r)\/r$ las dos son la misma ecuación. Sin el
  menos la gravedad repelería.

  El mismo renglón tiene un desliz previo, del que la errata del recuadro es
  consecuencia: las dos aceleraciones se escriben
  $bold(accent(R, dot.double))_1 = G m_2 bold(r)\/r^3$ y
  $bold(accent(R, dot.double))_2 = G m_1 bold(r)\/r^3$, *las dos con el mismo
  signo*. Si eso fuera así, restarlas daría $G(m_2 - m_1) bold(r)\/r^3$ y los
  dos cuerpos se acelerarían para el mismo lado. Es tipográfico y la cátedra
  llega igual al resultado correcto, pero *copiar la fórmula recuadrada sin
  mirar el renglón de arriba deja un signo cambiado que después no se
  encuentra*.
]

== El centro de masa, y las dos órbitas verdaderas

La @m8-relativa dice cómo cambia la *separación*, no dónde está cada cuerpo.
Para eso hace falta el módulo 3: como no hay fuerzas externas, el centro de masa
se mueve con velocidad constante, así que *el sistema centro de masa es
inercial* y conviene pararse ahí. Midiendo desde él, por definición de CM
(apunte de clase, 23/9, pág. 2):

$ m_1 bold(r)_1 + m_2 bold(r)_2 = bold(0) $ <m8-cm>

#deduccion("dónde está cada cuerpo, en función de la separación")[
  Con $bold(r) = bold(r)_1 - bold(r)_2$ la separación medida desde el CM
  —cuidado: acá el apunte de clase invierte el orden respecto de la hoja
  anterior, y el signo de $bold(r)_1$ y $bold(r)_2$ va con esa elección— la
  @m8-cm da $bold(r)_1 = -(m_2\/m_1) bold(r)_2$, y sustituyendo:
  $ bold(r) = bold(r)_1 - bold(r)_2 = -(m_2/m_1) bold(r)_2 - bold(r)_2 = -bold(r)_2 (m_1 + m_2)/m_1 $
  de donde se despejan las dos, que es lo que se buscaba:
]

$ bold(r)_1 = m_2 / (m_1 + m_2) bold(r), quad bold(r)_2 = -m_1 / (m_1 + m_2) bold(r) $ <m8-posiciones>

#clave[
  *Los dos cuerpos recorren elipses semejantes, con foco común en el centro de
  masa, y siempre están en lados opuestos de él* —es el panel izquierdo de la
  figura de la introducción, ahora con las cuentas atrás. Las dos ecuaciones
  de la @m8-posiciones son la misma $bold(r)$ multiplicada por dos
  constantes, una positiva y otra negativa: si $bold(r)$ describe una elipse
  —cosa que el módulo 9 va a demostrar—, entonces $bold(r)_1$ y $bold(r)_2$
  describen elipses de la misma excentricidad, escaladas por
  $m_2\/(m_1+m_2)$ y $m_1\/(m_1+m_2)$, y giradas $180°$ una respecto de la
  otra.

  *El cuerpo pesado recorre la elipse chica.* Es lo que hace que una estrella
  con un planeta se «bambolee» — y ese bamboleo es como se descubrieron los
  primeros exoplanetas.
]

== La masa reducida y el problema equivalente

Falta la energía. Si el problema relativo va a reemplazar al de dos cuerpos,
tiene que dar también la energía cinética correcta.

#deduccion("la masa reducida sale de sumar las dos energías cinéticas")[
  Derivando la @m8-posiciones y sustituyendo en $K = 1/2 m_1 accent(r, dot)_1^2 +
  1/2 m_2 accent(r, dot)_2^2$ (apunte de clase, 23/9, pág. 2):
  $ K = 1/2 m_1 (m_2/(m_1+m_2))^2 accent(r, dot)^2 + 1/2 m_2 (m_1/(m_1+m_2))^2 accent(r, dot)^2 $
  El factor común es $1/2 accent(r, dot)^2$, y lo que queda entre corchetes se
  simplifica solo:
  $ (m_1 m_2^2 + m_2 m_1^2)/(m_1 + m_2)^2 = (m_1 m_2 (m_2 + m_1))/(m_1 + m_2)^2 = (m_1 m_2)/(m_1 + m_2) $
  o sea que la energía cinética *de los dos cuerpos juntos*, vista desde el CM,
  es la de *uno solo* con esa masa y con la velocidad relativa.
]

$ K = 1/2 m_r accent(r, dot)^2, quad m_r = (m_1 m_2)/(m_1 + m_2) $ <m8-reducida>

#definicion("problema equivalente")[
  Ya planteado en palabras al principio del módulo, ahora con nombre y
  número: un sistema de dos cuerpos que se atraen es *exactamente
  equivalente*, en su movimiento relativo, a *un solo cuerpo de masa $m_r$
  moviéndose en el potencial $U(r) = -G m_1 m_2 \/ r$ de un centro fijo*
  (apunte de clase, 23/9, pág. 2). Su energía es
  $ E = 1/2 m_r v^2 + U(r), quad U(r) = -(G m_1 m_2)/r $
  Es la reducción que da nombre al módulo, y la razón por la que el problema de
  dos cuerpos se considera «resuelto»: se lo convierte en el de uno solo, que ya
  está resuelto.
]

#clave[
  *Por qué funciona: la energía del sistema se parte en dos pedazos que no se
  hablan.* Vista desde un sistema inercial cualquiera,
  $ E_"tot" = 1/2 (m_1+m_2) V_"cm"^2 + (1/2 m_r accent(r,dot)^2 + U(r)) $
  El primer término es la energía de *todo el conjunto viajando junto*, a la
  velocidad de su centro de masa; el segundo es la de la separación sola,
  achicándose o creciendo y girando. Sin fuerzas externas el módulo 3 ya
  mostró que $bold(V)_"cm"$ es constante, así que el primer término nunca
  cambia y no le presta ni le saca energía al segundo: *están desacoplados*.
  Sacar el primero y quedarse sólo con el segundo no es una aproximación —es
  exacto—, y lo que queda tiene la forma de un cuerpo único porque a dos
  cuerpos menos un centro de masa que ya no se mueve le queda *un solo grado
  de libertad*: la separación $bold(r)$.
]

#geometria[
  *El "centro fijo" no es ningún cuerpo real: es un punto matemático, sin
  masa, que no está ni en $m_1$ ni en $m_2$ ni en el centro de masa.* Es
  sólo el origen desde el que se mide la resta $bold(r) = bold(R)_2 -
  bold(R)_1$. El cuerpo ficticio de masa $m_r$ es un tercer objeto que no
  existe en la realidad: se lo inventa, se lo pone a orbitar ese punto, y se
  lo hace *porque* su distancia al punto, en cada instante, va a valer lo
  mismo que la distancia entre los dos cuerpos de verdad. El punto no hace
  falta ubicarlo en ningún lugar físico —ni siquiera hace falta que sea el
  centro de masa— porque nunca se usa su posición: sólo se usa la distancia
  a él, que es $r$.

  *Y por eso alcanza igual si lo que hace falta es la separación.* No es que
  el problema equivalente dé una respuesta parcial que después hay que
  completar: el $bold(r)(t)$ que sale de resolverlo —con las fórmulas de
  los módulos 6, 9, 10 y 11, sin cambiarles una letra— *es*, directamente,
  la distancia entre los dos cuerpos reales en cada instante. No hace falta
  ningún paso más para tenerla.

  *El paso extra sólo hace falta para otra pregunta, distinta.* Si en vez de
  «¿qué tan separados están?» la pregunta es «¿dónde está *cada uno*, por
  separado, respecto del centro de masa?» —por ejemplo, cuánto se bambolea
  la Tierra— ahí sí hace falta un dato más, que la @m8-posiciones ya da
  gratis a partir del mismo $bold(r)$: $bold(r)_1 = m_2\/(m_1+m_2) thin
  bold(r)$ y $bold(r)_2 = -m_1\/(m_1+m_2) thin bold(r)$, dos versiones a
  escala del mismo vector, para lados opuestos.
]

#posta[
  La posta con el problema equivalente es que dejás de romperte la cabeza con
  dos cuerpos tirando cada uno del otro, cada uno acelerando y moviéndose a
  la vez —eso, escrito tal cual, es un quilombo de resolver—, y te quedás
  pensando en una sola cosa: cuánto se separan o se acercan entre sí. Esa
  separación, sola, se porta EXACTAMENTE igual que un cuerpo inventado
  ($m_r$) dando vueltas alrededor de un punto matemático que no está en
  ningún lado real —ni en la Tierra, ni en la Luna, ni en el medio—. Y ese
  punto te resuelve la vida porque el problema de "un cuerpo dando vueltas a
  un punto fijo" ya lo sabés resolver desde el módulo 6: le metés las mismas
  cuentas de siempre, y lo que te devuelve *ya es* la distancia real entre
  los dos cuerpos de verdad, sin ningún paso extra. El paso extra sólo
  aparece si además querés saber dónde está cada uno por separado —ahí sí
  repartís esa distancia entre las dos masas—, pero la parte jodida, la de
  los dos cuerpos tirándose entre sí, ya la resolviste sin darte cuenta.
]

#clave[
  *Las dos constantes del módulo describen cosas distintas y no se mezclan.*
  Conviene verlo junto, porque los dos números salen de las mismas dos masas y
  se usan en ecuaciones diferentes:

  #table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Cantidad*], [*Vale*], [*Dónde entra*]),
    [$mu$, parámetro gravitacional],
    [$G(m_1 + m_2)$],
    [en la *ecuación de movimiento* y en todo lo geométrico: la forma de la órbita, el período, las velocidades],

    [$m_r$, masa reducida],
    [$m_1 m_2 \/ (m_1 + m_2)$],
    [en la *energía* y en el momento angular del problema equivalente],
  )

  Una es una *suma* y la otra un *producto sobre una suma*; una crece con las
  dos masas y la otra está siempre por debajo de la más chica de las dos. Cuando
  $m_2 << m_1$, la primera tiende a $G m_1$ y la segunda a $m_2$.
]

#notacion[
  *La trampa que la cátedra marcó con una flecha en el margen: $mu$ se usa para
  las dos cosas.* En el apunte de clase, junto a $mu = G(m_1 + m_2)$, está
  escrito «no confundir con "masa reducida"». Y con razón: buena parte de la
  bibliografía de mecánica clásica —Landau, Goldstein, y el propio Roederer—
  llama $mu$ a la *masa reducida*, mientras que toda la bibliografía de
  astrodinámica —Curtis, Bate— llama $mu$ al *parámetro gravitacional*.

  Son cantidades de dimensiones distintas: kg contra m³/s². Una fórmula copiada
  del libro equivocado no sólo da un número mal, da un número con unidades que
  no cierran — y ésa es, justamente, la forma de detectarlo.

  *En este apunte, $mu$ es siempre $G(m_1 + m_2)$ y la masa reducida es siempre
  $m_r$*, que es la letra que usa el apunte de clase.
]

== Cuándo importa: un solo número

Toda la corrección de este módulo se resume en cuánto vale el cociente
$q = m_2 \/ m_1$ entre la masa chica y la grande:

$ mu = G m_1 (1 + q), quad m_r = m_2 / (1 + q) $

#clave[
  *Y de ahí sale el error que se comete al ignorar todo esto.* El período de una
  órbita va como $T prop mu^(-1\/2)$ (módulo 6, y con más generalidad en el
  módulo 10), así que usar $G m_1$ en lugar de $G(m_1 + m_2)$ da un período
  demasiado largo en un factor $sqrt(1 + q)$, o sea —para $q$ chico— un error
  relativo de aproximadamente
  $ (Delta T)/T approx q/2 $

  #table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    table.header([*Sistema*], [$q = m_2\/m_1$], [*Error en $T$ si se ignora $m_2$*]),
    [Tierra – satélite artificial], [$~10^(-21)$], [inexistente: hay que ignorarla],
    [Sol – Tierra], [$3,0 times 10^(-6)$], [$1,5 times 10^(-4)$ %],
    [Sol – Júpiter], [$9,5 times 10^(-4)$], [$0,05$ %],
    [*Tierra – Luna*], [$1,23 times 10^(-2)$], [*$0,61$ %* — cuatro horas por mes],
    [Plutón – Caronte], [$0,12$], [$6$ %],
    [estrella binaria igual], [$1$], [$41$ % — no hay aproximación posible],
  )

  *La regla práctica:* para todo lo que orbite la Tierra o el Sol, $mu = G M$ y
  se termina. Para la Luna, para Plutón y para cualquier binaria, no.
]

#ejemplo("Qué masa se midió, en realidad, al estimar la del Sol")[
  _(El Problema 0 de la guía, del módulo 6, rehecho con la herramienta nueva.)_
  En el módulo 6 se estimó la masa del Sol con la órbita de la Tierra y se
  obtuvo $1,99 times 10^30$ kg. ¿Qué es exactamente ese número?

  La cuenta fue $mu = v^2 r$ y después $M = mu \/ G$. Pero por la @m8-relativa,
  lo que la órbita determina es $mu = G(M_"Sol" + M_T)$, no $G M_"Sol"$. Lo que
  se midió, entonces, es la *suma*:
  $ M_"Sol" + M_T = 1,99 times 10^30 " kg" $

  ¿Cuánto sobra? Exactamente una masa terrestre, $5,97 times 10^24$ kg, o sea
  $ q = M_T / M_"Sol" = (5,972 times 10^24)/(1,989 times 10^30) = 3,0 times 10^(-6) $
  Tres partes por millón: la estimación del módulo 6 tiene *tres cifras
  significativas*, así que la corrección cae seis órdenes de magnitud por debajo
  de su propio error. Ignorarla no fue un descuido; fue lo correcto.

  *Lo que este ejemplo enseña.* Una órbita nunca mide la masa del cuerpo
  central: mide *la suma de las dos*. Que se pueda leer como «la masa del Sol»
  es una consecuencia de que $q$ sea chico, no de la física. Y decir en qué
  condiciones una aproximación es buena requiere haber hecho antes la cuenta
  exacta — que es todo el contenido de este módulo.

  #cuidado[
    Es el mismo mecanismo que el cuadro rojo del módulo 6, y ahora se puede
    decir con precisión: pesar la Tierra con la Luna da $M_T + M_L$, y pesar el
    Sol con la Tierra da $M_"Sol" + M_T$. Sumar los dos resultados para «pesar
    el sistema solar» contaría la masa de la Tierra *dos veces*. En el primer
    caso eso es un error del 1,2%; en el segundo, de tres millonésimas.
  ]
]

#ejemplo("El sistema Tierra–Luna: dónde está el centro y cuánto dura el mes", nivel: "a fondo")[
  _(Construido sobre los datos del Problema 8 de la guía —el LEM del Apollo—,
  que da la masa de la Luna como $0,01230$ veces la de la Tierra y su radio como
  $1740$ km. La guía no trae un ejercicio propio de masa reducida.)_

  Con $M_T = 5,972 times 10^24$ kg, la distancia media Tierra–Luna
  $a = 384 thin 400$ km y $R_T = 6370$ km, calcular *(a)* la masa de la Luna y
  el cociente $q$; *(b)* dónde está el centro de masa del sistema; *(c)* la masa
  reducida; y *(d)* la duración del mes, con y sin la corrección de este módulo.

  *(a) La masa de la Luna y el cociente.* El dato de la guía es directamente $q$:
  $ M_L = 0,01230 M_T = 7,346 times 10^22 " kg", quad q = 1,230 times 10^(-2) $

  *(b) El centro de masa.* Por la @m8-posiciones, la distancia del CM al centro
  de la Tierra es la separación por la fracción de masa del *otro* cuerpo:
  $ d_T = a M_L/(M_T + M_L) = a q/(1 + q) = (384 thin 400)(0,012150) = 4671 " km" $

  #geometria[
    *Ese número es menor que el radio de la Tierra*: $4671 < 6370$. El centro de
    masa del sistema Tierra–Luna está *adentro de la Tierra*, a unos $1700$ km
    bajo la superficie. Por eso la Tierra no «orbita la Luna» de manera visible:
    su elipse —la chica de la figura— tiene un semieje de $4671$ km y queda
    íntegramente dentro del planeta. Lo que la Tierra hace es *bambolearse*
    alrededor de un punto que lleva adentro.

    Y por eso la aproximación «la Luna gira alrededor de la Tierra» funciona
    tan bien a ojo, y sin embargo es falsa en el 1,2% que importa para las
    cuentas.
  ]

  *(c) La masa reducida.* Por la @m8-reducida:
  $ m_r = (M_T M_L)/(M_T + M_L) = M_L/(1 + q) = (7,346 times 10^22)/(1,01230) = 7,257 times 10^22 " kg" $
  Es el $98,8%$ de la masa de la Luna: *un poco menos que la más chica de las
  dos*, como siempre.

  *(d) El mes.* Con $mu = G(M_T + M_L)$:
  $ mu = (6,674 times 10^(-11))(6,0455 times 10^24) = 4,035 times 10^14 " m"^3\/"s"^2 $
  y por la fórmula del período de una órbita —del módulo 6, con el semieje en
  lugar del radio, que es lo que el módulo 10 va a justificar—:
  $ T = (2 pi a^(3\/2))/sqrt(mu) = (2 pi (3,844 times 10^8)^(3\/2))/(2,009 times 10^7) = 2,357 times 10^6 " s" = 27,28 " días" $
  El valor observado del mes sidéreo es $27,32$ días: el acuerdo es de una parte
  en mil, y lo poco que falta es la excentricidad real de la órbita lunar y la
  perturbación del Sol.

  *Y ahora sin la corrección*, es decir usando $mu = G M_T = 3,986 times 10^14$:
  $ T' = (2 pi (3,844 times 10^8)^(3\/2))/(1,997 times 10^7) = 2,372 times 10^6 " s" = 27,45 " días" $

  #clave[
    *La diferencia son cuatro horas por mes*, y coincide con la estimación de la
    tabla: $(T' - T)\/T = 0,61% approx q\/2$. Cuatro horas no se ven mirando el
    cielo una noche, pero son *dos días de error en un año* — más que suficiente
    para arruinar la predicción de un eclipse, que es la clase de cosa para la
    que se calculan estas órbitas.

    *Ese es el sentido de todo el módulo.* La corrección no cambia ninguna
    fórmula: cambia qué número se pone adentro. Y el criterio para saber si hace
    falta es un solo cociente, $q$, que se calcula en un renglón antes de
    empezar.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  *La guía no trae ningún ejercicio de masa reducida*, y por eso los dos
  ejemplos de arriba no son ejercicios nuevos: el primero rehace el *Problema 0*
  —ya resuelto en el módulo 6— con la herramienta nueva, y el segundo está
  construido sobre los datos del *Problema 8*, que da la masa de la Luna como
  fracción de la terrestre.

  Donde sí hace falta este módulo es para *leer bien* los enunciados: los
  problemas *8* y *9* de la sección de energía dan la masa de la Luna como
  $0,01230$ veces la de la Tierra, y la de Júpiter (*Problema 7*) como $319$
  veces. Esos datos están para calcular $mu$ del cuerpo central, y en ninguno de
  los tres casos la masa de la nave entra en la cuenta: los tres tienen
  $q approx 10^(-20)$.
]

== Lo que se usa después

1. *$mu = G(m_1 + m_2)$.* Es la constante que aparece en la ecuación de la
   órbita del módulo 9 y en la tercera ley de Kepler del módulo 10 — y la razón
   por la que la tercera ley, en su forma exacta, *no* dice que $T^2\/a^3$ sea
   igual para todos los planetas.

2. *La reducción a un cuerpo.* Todo el módulo 9 se escribe para «una partícula
   de masa $m$ en un potencial central». Después de este módulo eso no es una
   idealización: es el problema de dos cuerpos, exactamente, con $m = m_r$.

3. *Las dos elipses semejantes.* Es lo que hay que tener en la cabeza cuando un
   enunciado hable de un sistema binario o del bamboleo de una estrella.
