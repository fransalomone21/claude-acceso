#import "../plantilla.typ": *

#modulo("Las leyes de Kepler")[
  Mostrar que las tres leyes de Kepler —enunciadas cien años antes de Newton,
  a puro ajuste de datos— son *consecuencia* de lo que ya está deducido, no un
  agregado nuevo: la primera es la ecuación de la órbita del módulo 9; la
  segunda es la conservación del momento angular del módulo 7; y la tercera
  —el período— es lo único que falta, y sale de las dos anteriores en cinco
  renglones. Y entender por qué, en su forma *exacta*, la tercera ley no dice
  que $T^2 \/ a^3$ sea igual para todos los planetas.
]

Kepler llegó a sus tres leyes mirando las tablas de posiciones de Marte que
había heredado de Tycho Brahe, sin ninguna teoría de la gravitación detrás:
son un ajuste empírico, publicado casi un siglo antes que los *Principia*. Lo
notable, visto desde acá, es que las tres ya están adentro de lo que este
apunte dedujo en los módulos 7 y 9 — no hace falta una hipótesis nueva, sólo
leer lo que ya está escrito con otro nombre.

== Las tres leyes, ya deducidas

#clave[
  *Primera ley: las órbitas son elipses, con el Sol en un foco.* Es la
  @m9-orbita del módulo 9, evaluada en el caso $0 < e < 1$: $r = p \/ (1 + e
  cos nu)$ *es*, por definición, la ecuación polar de una elipse con el foco en
  el origen. No hay nada que agregar — Kepler la observó; este apunte la
  *derivó* de $accent(r, dot.double) = -mu bold(r) \/ r^3$ sin suponerla.
]

#clave[
  *Segunda ley: áreas iguales en tiempos iguales.* Es la @m7-areas del módulo
  7, $d A \/ d t = h \/ 2 = "constante"$, que salió de la conservación del
  momento angular y vale para *cualquier* fuerza central — no hace falta que
  sea $1 \/ r^2$. Kepler la observó en un caso particular; este apunte mostró
  que es más general que la gravitación misma.
]

Falta la tercera, y es la única que necesita una deducción nueva.

== La tercera ley: de dónde sale el período

#deduccion("el período, integrando el área")[
  La velocidad areolar es constante (@m7-areas), así que en un período completo
  $tau$ el radio barre el área entera de la elipse, $A = pi a b$:
  $ (d A)/(d t) = h/2 ==> A = h/2 tau ==> pi a b = h/2 tau $
  y despejando (Beer ec. 12.45, pág. 739):
  $ tau = (2 pi a b)/h $ <m10-tau-ab>
]

Para dejarla en función de $a$ sola —que es lo que se mide y lo que se
compara entre órbitas— hace falta reemplazar $b$ y $h$. Del módulo 9,
$b = a sqrt(1 - e^2)$ y $h^2 = mu p = mu a (1 - e^2)$:

#deduccion("el período, sólo en función del semieje mayor")[
  Elevando la @m10-tau-ab al cuadrado:
  $ tau^2 = (4 pi^2 a^2 b^2)/h^2 = (4 pi^2 a^2 dot a^2 (1-e^2))/(mu a (1-e^2)) = (4 pi^2 a^3)/mu $
  La excentricidad se cancela *entera* — no importa si la órbita es casi
  circular o muy alargada, el período depende sólo de $a$.
]

$ tau = (2 pi a^(3\/2))/sqrt(mu) $ <m10-periodo>

#clave[
  *Ésta es la tercera ley de Kepler, y es la misma fórmula del módulo 6 con
  una sola letra cambiada.* La @m6-T daba $T = 2 pi r^(3\/2) \/ sqrt(mu)$ para
  una órbita *circular* de radio $r$. La @m10-periodo dice que la fórmula vale
  *sin cambiar un signo* para cualquier elipse, con el semieje mayor $a$ en el
  lugar del radio. No es una coincidencia que se pueda verificar a posteriori:
  el módulo 9 ya había mostrado que la órbita circular es el caso $e = 0$ de
  la misma familia, con $a = r$.
]

#geometria[
  *"Radio" deja de tener sentido en una elipse, y $a$ es lo que lo reemplaza.*
  Un satélite en órbita elíptica no tiene un solo radio: tiene $r_p$, $r_a$, y
  todo lo intermedio. El período no depende de ninguno de ellos por separado,
  sino de su promedio, $a = (r_p + r_a)\/2$. Dos órbitas con el mismo $a$ y
  formas completamente distintas —una casi circular, otra muy excéntrica—
  tardan *exactamente lo mismo* en darle la vuelta al cuerpo central. Es la
  misma idea que cerró el módulo 9 con la energía: $E = -mu m \/ (2a)$ tampoco
  depende de $e$.
]

#cuidado[
  *La tercera ley, en su forma exacta, NO dice que $T^2 \/ a^3$ sea el mismo
  número para todos los planetas.* La @m10-periodo tiene $mu$ adentro, y el
  módulo 8 ya mostró que $mu = G(m_1 + m_2)$ depende de *las dos masas*, no
  sólo de la del Sol. Comparar dos planetas es comparar dos sistemas Sol +
  planeta con $mu$ *distinto* — apenas distinto, porque todo planeta pesa
  muchísimo menos que el Sol, pero distinto:
  $ T^2/a^3 = (4 pi^2)/mu = (4 pi^2)/(G (M_"Sol" + m_"planeta")) $
  Kepler enunció $T^2 \/ a^3 = "cte"$ porque para todo el sistema solar
  $m_"planeta" \/ M_"Sol"$ es chico —el mismo $q$ del módulo 8— y la
  diferencia entre planetas queda varios órdenes de magnitud por debajo de lo
  que Kepler podía medir con los datos de Tycho. La ley *aproximada* es
  extraordinariamente buena; la ley *exacta* compara el mismo sistema consigo
  mismo, no un planeta con otro.
]

== Ejemplo: el satélite del módulo 9, con período

#ejemplo("El período del satélite, y la parte que faltaba del Problema 4")[
  _(Problema 4 de la sección de energía, S&Z 13.67 — el mismo satélite de
  perigeo 400 km y apogeo 4000 km que el módulo 9 ya resolvió entero: ahí
  quedaron $e = 0,2098$, $a = 8578$ km, $p = 8200$ km y $h = 57 thin 172$
  km²/s. Acá se completan las cuatro partes del enunciado.)_

  *(a) El período.* Con $b = sqrt(r_p r_a) = sqrt(6778 times 10 thin 378) =
  8387$ km, la @m10-tau-ab da
  $ tau = (2 pi (8578)(8387))/(57 thin 172) = 7907 " s" = 2,197 " h" $
  o, verificando por el otro camino, con la @m10-periodo y sin pasar por $b$:
  $ tau = (2 pi (8578)^(3\/2))/(631,35) = 7907 " s" $
  Las dos coinciden porque son la misma fórmula — es la comprobación de que
  $b = 8387$ km, calculado arriba, es consistente con $h$.

  *(b) y (c), ya resueltas.* La razón de rapideces es geometría pura, de la
  conservación de $h = r v$ en los ábsides (módulo 7):
  $ v_p/v_a = r_a/r_p = (10 thin 378)/6778 = 1,531 $
  y las rapideces mismas ya están —$v_p = 8,435$ km/s, $v_a = 5,509$ km/s—
  desde que el módulo 9 las dedujo de $h$. La @m9-visviva las reproduce sin
  pasar por $h$, como comprobación cruzada:
  $ v_p^2 = mu (2/r_p - 1/a) = (3,986 times 10^5) (2/6778 - 1/8578) = 71,15 ==> v_p = 8,435 " km/s" $
  $ v_a^2 = mu (2/r_a - 1/a) = (3,986 times 10^5) (2/(10 thin 378) - 1/8578) = 30,35 ==> v_a = 5,509 " km/s" $
  Tres caminos —momento angular en el módulo 7, ecuación de la órbita en el
  9, vis-viva acá— y el mismo número las tres veces.

  *(d) Escapar desde perigeo, o desde apogeo.* Escapar significa $E = 0$,
  o sea alcanzar $v_"esc" = sqrt(2 mu \/ r)$ (módulo 6) en el punto donde se
  encienden los cohetes — sin cambiar el otro ábside, que es lo que un solo
  encendido tangencial puede hacer:
  $ v_"esc" (r_p) = sqrt((2)(3,986 times 10^5)/6778) = 10,85 " km/s" quad ==> quad Delta v_p = 10,85 - 8,435 = 2,41 " km/s" $
  $ v_"esc" (r_a) = sqrt((2)(3,986 times 10^5)/(10 thin 378)) = 8,765 " km/s" quad ==> quad Delta v_a = 8,765 - 5,509 = 3,26 " km/s" $

  #clave[
    *Conviene encender los cohetes en el perigeo — y no porque ahí "ya se va
    rápido".* El perigeo pide $2,41$ km/s de más y el apogeo $3,26$ km/s: casi
    un kilómetro por segundo de diferencia, en el mismo satélite, para llegar
    al mismo $E = 0$. La razón es la forma de $v_"esc" (r) = sqrt(2 mu \/ r)$:
    crece con $r$ chico, así que en el perigeo *hay menos distancia hasta la
    velocidad de escape*, no sólo más velocidad de partida. Es el mismo efecto
    que el módulo 9 mostró con Júpiter —capturar es barato si se hace donde ya
    se va rápido—, mirado al revés: escapar también es más barato ahí.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  El *Problema 4* es el ejemplo simple: las partes (b) y (c) ya estaban
  resueltas de los módulos 7 y 9, y lo que este módulo agrega son la (a) —el
  período— y la (d) —la comparación de escape—. El ejemplo a fondo son los
  *Problemas 8 y 9*, el LEM del Apollo, que van juntos porque el segundo
  continúa exactamente donde termina el primero.
]

#ejemplo("El LEM del Apollo: subir a encontrarse, y bajar a estrellarse", nivel: "a fondo")[
  _(Problemas 8 y 9 de la sección de energía; Beer 13.101 y su continuación.)_
  Después de la misión de exploración, el LEM tiene que reunirse con el módulo
  de mando, que orbita la Luna en círculo a $140$ km de altura. El radio de la
  Luna es $1740$ km y su masa $0,01230$ veces la terrestre —dato del módulo 8,
  que da directamente $mu_L$:
  $ mu_L = 0,01230 mu_T = (0,01230)(3,986 times 10^5) = 4903 " km"^3\/"s"^2 $

  #text(weight: "bold", fill: c-azul)[Problema 8 — la subida.]

  El LEM enciende el motor y sube desde la superficie lunar hasta un punto
  $A$, a $8$ km de altura, donde el motor se apaga con la velocidad *paralela
  a la superficie* — es decir, perpendicular al radio: $A$ es un ábside de la
  trayectoria que sigue de ahí en más, sin motor, hasta encontrarse con el
  módulo de mando en $B$, a $140$ km. Como $A$ y $B$ son las dos alturas
  extremas de una misma elipse de transferencia —perilunio $A$, apolunio
  $B$—, es *exactamente* el planteo de una transferencia de Hohmann del
  módulo 11, resuelto con las herramientas de éste.

  $ r_A = 1740 + 8 = 1748 " km", quad r_B = 1740 + 140 = 1880 " km", quad
    a' = (r_A + r_B)/2 = 1814 " km" $

  *(a) La rapidez al apagar el motor.* Por la @m9-visviva, en $A$:
  $ v'^2_A = mu_L (2/r_A - 1/a') = (4903)(2/1748 - 1/1814) = 2,907 ==> v'_A = 1,705 " km/s" $

  *(b) La velocidad relativa en el encuentro.* Hace falta $h'$, y conviene
  sacarlo de la @m9-suma-inversos —los dos ábsides, sin pasar por $a'$— porque
  después sirve para verificar $v'_A$ por el otro camino:
  $ h'^2 = (2 mu_L)/(1\/r_A + 1\/r_B) = (2 (4903))/(1\/1748 + 1\/1880) = 8,883 times 10^6 ==> h' = 2980 " km"^2\/"s" $

  #clave[
    *Control cruzado, gratis.* $v'_A = h' \/ r_A = 2980 \/ 1748 = 1,705$ km/s:
    el mismo número que la vis-viva, por el camino del momento angular. Los
    ábsides son los únicos puntos donde $h = r v$ sin ningún coseno de por
    medio (módulo 7), y por eso conviene sacar $h'$ ahí siempre que se pueda.
  ]

  En $B$ el LEM llega con $v'_B = h' \/ r_B = 2980 \/ 1880 = 1,585$ km/s,
  *tangencial* — porque $B$ también es un ábside. El módulo de mando, en su
  órbita circular a ese mismo radio, va a $v_"circ" = sqrt(mu_L \/ r_B) =
  sqrt(4903 \/ 1880) = 1,615$ km/s, también tangencial y en el mismo sentido.
  Como las dos velocidades son paralelas, la relativa es la resta directa:
  $ Delta v = v_"circ" - v'_B = 1,615 - 1,585 = 0,030 " km/s" = 30 " m/s" $

  #geometria[
    *Por qué la resta simple alcanza acá, y no en general.* Restar rapideces
    sin vectores sólo vale cuando las dos velocidades son *paralelas* — y acá
    lo son porque las dos, LEM y módulo de mando, están en un ábside de su
    propia órbita en el instante del encuentro: la del LEM porque $B$ es
    apolunio de la transferencia, la del módulo de mando porque *toda* su
    órbita circular es "ábside". Si el encuentro fuera en cualquier otro punto,
    haría falta descomponer.
  ]

  #text(weight: "bold", fill: c-azul)[Problema 9 — la bajada.]

  El LEM, ya emparejado con el módulo de mando en $B$ ($r = 1880$ km, $v =
  1,615$ km/s tangencial), gira para que el motor apunte hacia atrás y frena
  $200$ m/s *respecto del módulo de mando* — que se queda en su órbita
  circular. La nueva velocidad del LEM, todavía tangencial en $B$ porque el
  frenado es sobre la misma línea de movimiento:
  $ v_B'' = 1,615 - 0,200 = 1,415 " km/s" $

  #deduccion("la nueva órbita, y por qué no vuelve a subir")[
    Con $r = 1880$ km y $v = 1,415$ km/s tangencial, $B$ es un ábside de la
    *nueva* órbita —y como $v_B'' < v_"circ"$, es el ábside alto, el apolunio—:
    $ E''/m = v_B''^2/2 - mu_L/r_B = 1,001 - 2,608 = -1,607 " km"^2\/"s"^2 $
    $ a'' = mu_L/(2 abs(E''\/m)) = 4903/(3,214) = 1526 " km" $
    $ h'' = r_B v_B'' = (1880)(1,415) = 2660 " km"^2\/"s" $
    $ p'' = h''^2/mu_L = 2660^2/4903 = 1443 " km" quad ==> quad e'' = sqrt(1 - p''/a'') = sqrt(1 - 1443/1526) = 0,233 $
    y el perilunio de esta órbita, $r_p'' = a'' (1-e'') = 1526 (0,767) = 1171$
    km, está *adentro* de la Luna ($R_L = 1740$ km): el LEM no llega a
    completar la elipse — se estrella antes, en $C$, sobre la superficie.
  ]

  *La velocidad y el ángulo en $C$.* Con $r_C = R_L = 1740$ km, por la
  @m9-visviva:
  $ v_C^2 = mu_L (2/r_C - 1/a'') = (4903)(2/1740 - 1/1526) = 2,422 ==> v_C = 1,556 " km/s" $

  El ángulo se saca de $h'' = r_C v_C cos gamma$ (módulo 7), con $gamma$ el
  ángulo entre $bold(v)_C$ y la horizontal local:
  $ cos gamma = h''/(r_C v_C) = 2660/((1740)(1,556)) = 0,982 ==> gamma = 10,8° $

  #clave[
    *Y medido desde la vertical* $O C$ *— que es como lo pide el enunciado—*:
    $ phi = 90° - gamma = 79,2° $
    Un ángulo de $79°$ desde la vertical es un impacto *rasante*: el LEM llega
    casi paralelo a la superficie, con apenas $11°$ de componente hacia abajo.
    Tiene sentido con el número de más arriba — el perilunio de la órbita
    ($1171$ km) queda bastante por debajo de la superficie ($1740$ km), así que
    el LEM todavía está lejos de "apuntar derecho al centro" cuando choca.
  ]

  #cuidado[
    *La trampa de este problema es de signo, no de álgebra.* $v_B''$ tiene que
    ser *menor* que $v_"circ"$ —el LEM frena respecto del módulo de mando, que
    sigue en su órbita— y por eso $B$ queda como el ábside *alto* de la nueva
    órbita, no el bajo. Restar al revés ($v_"circ" + 0,200$) daría una órbita
    que sube en vez de bajar, y ningún perilunio negativo avisaría del error:
    seguiría siendo un número creíble, sólo que el LEM terminaría alejándose de
    la Luna en vez de estrellarse.
  ]
]

== Lo que se usa después

1. *$T = 2 pi a^(3\/2) \/ sqrt(mu)$.* Es la mitad de esta fórmula la que da,
   en el módulo 11, el tiempo de vuelo de una transferencia de Hohmann: media
   elipse se recorre en medio período.

2. *La tercera ley no compara planetas distintos con el mismo $mu$.* Es la
   advertencia que hace falta para no perder puntos comparando satélites de
   cuerpos centrales distintos —Tierra, Luna, Júpiter— con una sola constante.

3. *Los ábsides como los únicos puntos donde $h = r v$ sin coseno.* Cada vez
   que un problema da dos alturas y pide una velocidad —o al revés—, conviene
   preguntarse primero si esas alturas son ábsides. Si lo son, el camino más
   corto es casi siempre la @m9-suma-inversos.
