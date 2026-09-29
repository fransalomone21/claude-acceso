// =====================================================================
//  Modelo de parcial 2 -- primera evaluacion
//  Siete ejercicios integradores. El 2 es el cohete "todo integrado":
//  a(t) -> v(t) -> y(t) con sus constantes, por partes y con desacople.
//  Cada numero de la resolucion tiene su cuenta en validar.py.
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp

#show: documento.with(
  titulo: [Modelo de parcial 2],
  subtitulo: [Choque, cohete de dos etapas integrado, energía, parámetros orbitales, escape y momento angular],
  encabezado: [Modelo de parcial 2],
)

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Tiempo sugerido: *3 horas*. Hoja de fórmulas propia y calculadora. En cada
  paso hay que decir *qué se conserva y por qué*: vale tanto como el número.
  Datos: $mu_T = 398 thin 600$ km³/s², $R_T = 6378$ km, $g_0 = 9,81$ m/s²;
  Luna: $mu_L = 0,01230 thin mu_T$, $R_L = 1740$ km (los del Beer).
  *Notación:* la del apunte — $bold(L)$ momento angular (la guía de la cátedra
  lo llama *impulso angular*), $bold(tau)$ torque, $omega$ velocidad angular,
  $bold(P)$ cantidad de movimiento. Cada resolución abre con la notación de su
  tema y cómo aparece en la guía y en los libros.
]

#mapa(
  ([1], [cantidad de movimiento en 2D + choque plástico + impulso], [Ej. 2 de cantidad de movimiento (S&Z 8.31, el choque oblicuo) y Adicional 2]),
  ([2], [cohete de dos etapas: $a(t)$, $v(t)$, $y(t)$ integrados, desacople, ascenso libre], [Ej. 7, 8 y 9 de cantidad de movimiento (Beer 14.97, 14.98, 14.99)]),
  ([3], [energía, escape, dónde deja de valer $m g h$], [Problemas 2 y 4 de gravitación]),
  ([4], [parámetros orbitales desde perigeo y apogeo], [Adicional 1 de gravitación]),
  ([5], [maniobras: escapar desde el perigeo o desde el apogeo], [Problema 4 de gravitación (S&Z 13.67)]),
  ([6], [momento angular: la banqueta y la rueda], [Problemas 4 y 7 de impulso angular]),
  ([7], [momento angular de un sistema (demostración)], [Problema 3 de impulso angular]),
)

#ejercicio(1, [el acople oblicuo], [1,5])
#origen[Cantidad de movimiento en dos dimensiones, choque plástico, impulso y fuerza media. Se apoya en el Ej. 2 (S&Z 8.31) y el Adicional 2 de cantidad de movimiento.]

Una nave $A$ de $3000$ kg se acerca a un módulo $B$ de $1000$ kg para acoplarse.
Respecto de un marco en caída libre que acompaña a los dos, $A$ se mueve a
$0,40$ m/s en $+x$ y $B$ a $0,30$ m/s en $+y$. Se acoplan y quedan unidos; el
acople dura $1,5$ s.

#fp.fig-acople

+ Calcule la velocidad del conjunto después del acople: módulo y ángulo con
  el eje $x$.
+ ¿Cuánta energía cinética se pierde? ¿A dónde va?
+ Calcule el impulso que recibe $B$ y la fuerza media sobre él. ¿Y el que
  recibe $A$?
+ Los dos están en órbita y la gravedad no es cero. ¿Por qué igual se puede
  usar la conservación de la cantidad de movimiento?

#ejercicio(2, [el cohete de dos etapas, todo integrado], [2])
#origen[Ecuación del cohete, integración de $a$, $v$ e $y$ con sus constantes, integración por partes, desacople, energía. Se apoya en los Ej. 7, 8 y 9 de cantidad de movimiento (Beer 14.97, 14.98 y 14.99).]

Un cohete de dos etapas despega verticalmente desde el reposo, con $g$
constante y sin aire.
*Etapa 1:* masa total al despegar $M_0 = 30 thin 000$ kg, con $18 thin 000$ kg
de propelente y $3000$ kg de estructura; quema $300$ kg/s con los gases a
$2500$ m/s respecto del cohete.
*Etapa 2 (con la carga útil):* $9000$ kg, de los cuales $6000$ kg son
propelente; quema $60$ kg/s con los gases a $3000$ m/s. Se enciende en el
mismo instante en que se suelta la estructura vacía de la etapa 1.

#fp.fig-cohete-p(etapas: 2, datos: [etapa 1: $30$ t, $mu_1 = 300$ kg/s \ etapa 2: $9$ t, $mu_2 = 60$ kg/s])

+ Escriba $a(t)$ durante la etapa 1 e intégrela *dos veces* para obtener
  $v(t)$ e $y(t)$, diciendo qué es cada constante de integración. Calcule la
  velocidad y la altura al agotarse la etapa 1.
+ Haga lo mismo para la etapa 2: ¿cuáles son ahora las constantes de
  integración? Calcule la velocidad y la altura al apagarse el motor.
+ ¿Qué pasa con la aceleración en el instante del desacople?
+ ¿Cuánta velocidad final se pierde si la estructura vacía de la etapa 1 no
  se suelta?
+ Después del apagado el cohete sigue subiendo sin motor. Calcule la altura
  máxima con $g$ constante y con la gravedad que baja como $1\/r^2$.
  ¿Cuál de las dos cree, y por qué?

#ejercicio(3, [la piedra lanzada desde la Luna], [1,25])
#origen[Conservación de la energía con la gravedad general, velocidad de escape, límite de validez de $m g h$. Se apoya en los Problemas 2 y 4 de gravitación.]

Desde la superficie de la Luna se lanza verticalmente una sonda con
$v_0 = 2,0$ km/s. No hay atmósfera.

#fp.fig-luna-vertical

+ Calcule la gravedad en la superficie lunar y la velocidad de escape.
  ¿Vuelve la sonda?
+ Calcule la altura máxima.
+ Calcule la altura máxima con la fórmula de tiro vertical, $h = v_0^2 \/ (2 g)$,
  y compárela. ¿Por qué da tan distinto?
+ ¿Con qué rapidez pasa la sonda por una altura igual a un radio lunar?

#ejercicio(4, [la órbita con el perigeo bajo y el apogeo alto], [1,5])
#origen[Parámetros orbitales, conservación del momento angular y de la energía, ángulo de trayectoria de vuelo. Se apoya en el Adicional 1 de gravitación.]

Un satélite tiene el perigeo a $600$ km de altura y el apogeo a $20 thin 000$ km.

#fp.fig-orbita-p(0.5816, 2.6, puntos: ((anom: 105.05, vel: true, gam: 33.5, rot: [$r = 13 thin 000$ km], desp: (-0.1, 0.1), ancla: "south-east"),))

+ Calcule la excentricidad, el semieje mayor, el período y la energía
  específica.
+ Calcule el momento angular específico y las rapideces en el perigeo y en el
  apogeo.
+ Cuando se aleja de la Tierra, ¿en qué anomalía verdadera pasa por
  $r = 13 thin 000$ km? Calcule ahí $v_r$, $v_perp$, la rapidez y el ángulo
  de trayectoria de vuelo.
+ ¿Cuánto vale la velocidad areolar? ¿En qué parte de la órbita pasa la
  mayor parte del período, y por qué?

#ejercicio(5, [escapar: desde el perigeo o desde el apogeo], [1,25])
#origen[Maniobras, velocidad de escape, ecuación del cohete. Se apoya en el Problema 4 de gravitación (S&Z 13.67).]

Una nave de $1000$ kg (con el propelente) está en una órbita elíptica con el
perigeo a $300$ km y el apogeo a $3000$ km de altura. Su motor tiene
$I_"sp" = 300$ s.

#fp.fig-orbita-p(0.17, 2.4, dv-apsides: true)

+ Calcule la rapidez en el perigeo y en el apogeo.
+ ¿Cuánto hay que aumentar la rapidez para escapar si se enciende el motor en
  el perigeo? ¿Y en el apogeo? ¿Cuál conviene, y por qué?
+ ¿Cuánto propelente gasta cada opción?
+ Si en vez de escapar quiere circularizar la órbita a $3000$ km de altura,
  ¿dónde y cuánto enciende?

#ejercicio(6, [la banqueta y la rueda], [1,5])
#origen[Conservación del momento angular con partes que giran, torque interno, energía. Se apoya en los Problemas 4 y 7 de impulso angular.]

Una persona está sentada, quieta, en una banqueta que gira sin roce alrededor
de un eje vertical; el momento de inercia de persona + banqueta es
$I_p = 6,0$ kg·m². Sostiene sobre su cabeza, con el eje vertical y sobre el eje
de la banqueta, una rueda de bicicleta (un aro de $2,4$ kg y $35$ cm de radio)
que gira a $30$ rad/s, antihoraria vista desde arriba. La persona da vuelta la
rueda en $0,8$ s, hasta dejar su eje otra vez vertical pero al revés. El
rulemán de la rueda no tiene roce: la rueda sigue girando a $30$ rad/s
respecto del piso.

#fp.fig-banqueta

+ Calcule el momento angular de la rueda antes de darla vuelta.
+ ¿Con qué velocidad angular gira la persona después? ¿En qué sentido?
+ ¿Se conserva la energía cinética? Si no, ¿quién la puso?
+ ¿Qué torque medio hizo la persona sobre la rueda? ¿Y la rueda sobre la
  persona?
+ ¿Y si la persona sólo acuesta la rueda (eje horizontal) en vez de darla
  vuelta?

#ejercicio(7, [dos partículas antiparalelas], [1,0])
#origen[Momento angular de un sistema de partículas, cambio de origen. Es el Problema 3 de impulso angular.]

Dos partículas de masa $m$ se mueven con velocidades $bold(v)$ y $-bold(v)$ sobre
rectas paralelas separadas una distancia $d$.

#fp.fig-antiparalelas

+ Demuestre que el momento angular del sistema es el mismo respecto de
  cualquier punto, y que su módulo es $m v d$.
+ ¿Qué propiedad del sistema es la que hace que no dependa del punto? ¿Pasa
  lo mismo con el torque de una cupla?

#pagebreak()

= Resolución

== Ejercicio 1 — el acople oblicuo

#notacion[
  $bold(P) = sum m_i bold(v)_i$ es la cantidad de movimiento (Beer:
  $bold(L)$; Roederer: *impulso*). El *impulso* es
  $bold(J) = integral bold(F) dif t = Delta bold(P)$ (teorema del impulso,
  Sears §8.1 ec. 8.6, que la cátedra marcó como «muy importante para entender
  el impulso de un cohete»). Un choque *plástico* (o perfectamente inelástico)
  es el que deja a los dos cuerpos unidos.
]

#idea[
  Durante el acople las fuerzas entre $A$ y $B$ son internas: la cantidad de
  movimiento del par se conserva, *como vector*, o sea componente por
  componente. La energía cinética no: el mecanismo de acople la absorbe (se
  deforma, amortigua, calienta). Para evaluar un choque hay que tener $P$ y
  $E$ antes y después — lo dice la lista de temas.
]

#paso(1, [la velocidad final, por componentes])
$ P_x: 3000 dot 0,40 = 4000 thin v_x quad arrow.r.double quad v_x = 0,300 "m/s", $
$ P_y: 1000 dot 0,30 = 4000 thin v_y quad arrow.r.double quad v_y = 0,075 "m/s". $
$abs(bold(v)_f) = sqrt(0","300^2 + 0","075^2) = 0,3092$ m/s, a
$arctan(0,075 \/ 0,300) = 14,04°$ del eje $x$: casi en la dirección de $A$,
que tiene el triple de masa.

#paso(2, [la energía perdida])
$K_0 = 1/2 dot 3000 dot 0,40^2 + 1/2 dot 1000 dot 0,30^2 = 240 + 45 = 285$ J y
$K_1 = 1/2 dot 4000 dot 0,3092^2 = 191,3$ J. Se pierden $93,75$ J, el
$32,9$ %: se van en deformación y calor del mecanismo de acople.

#alternativa([la energía perdida, desde el centro de masa])[
  En un choque plástico los dos terminan con la velocidad del centro de masa,
  así que se pierde *toda* la energía cinética relativa al centro de masa y
  nada más: $Delta K = 1/2 m_r v_"rel"^2$. Con
  $m_r = (3000 dot 1000)\/4000 = 750$ kg y
  $bold(v)_"rel" = (0,40; -0,30)$ m/s, de módulo $0,5$ m/s:
  $Delta K = 1/2 dot 750 dot 0,25 = 93,75$ J. Mismo número, y de paso dice
  que es la *máxima* energía que un choque entre estos dos puede disipar.
]

#paso(3, [impulso y fuerza media])
El impulso sobre $B$ es su cambio de cantidad de movimiento:
$ bold(J)_B = m_B (bold(v)_f - bold(v)_B) = 1000 [(0,300; 0,075) - (0; 0,30)] = (300; -225) "N·s", $
de módulo $375$ N·s. Fuerza media: $375 \/ 1,5 = 250$ N. Sobre $A$ el impulso
es $(-300; 225)$ N·s: igual y contrario (tercera ley), y por eso el total no
cambia.

#paso(4, [la gravedad])
La gravedad actúa, pero sobre los dos casi igual, y el marco elegido *cae
con ellos*: en ese marco las dos fuerzas de gravedad se compensan con la
«caída» del marco. Y aun en un marco inercial, el impulso de la gravedad en
$1,5$ s cambia la velocidad de los dos en la misma cantidad, sin tocar la
velocidad *relativa*, que es la que decide el choque. Como dice la cátedra,
«$P$ puede conservarse aun con fuerzas externas distintas de cero» (Sears,
Ejemplo 8.2): lo que importa es que su impulso durante el choque sea
despreciable frente al de las fuerzas internas.

#camino[
  Conservación de $bold(P)$ por componentes y energía antes y después, en el
  marco del enunciado.
]

#final[$bold(v)_f = (0,300; 0,075)$ m/s, $0,3092$ m/s a $14,04°$; se pierden $93,75$ J ($32,9$ %); $bold(J)_B = (300; -225)$ N·s, $375$ N·s, $F_"media" = 250$ N; sobre $A$, el opuesto.]

== Ejercicio 2 — el cohete de dos etapas, todo integrado

#notacion[
  $mu$ es el caudal (Roederer; el Sears pone $-dif m \/ dif t$), $v_r$ la
  velocidad de los gases respecto del cohete (Sears: $v_"esc"$; Beer: $u$).
  $M(t) = M_0 - mu t$ es la masa *durante el quemado*: $M_0$ es la masa al
  empezar *esa* etapa, no la del despegue. $y$ es la altura, medida hacia
  arriba desde la plataforma.
]

#idea[
  Mientras quema, cada etapa cumple la ecuación del cohete
  $M(t) thin dif v \/ dif t = mu v_r - M(t) g$. De ahí $a(t)$; integrando una
  vez, $v(t)$; integrando otra vez, $y(t)$. Cada integración trae una
  constante, y esa constante es *el estado al empezar el tramo*: en la etapa 1
  es el reposo en el suelo; en la etapa 2 es la velocidad y la altura que dejó
  la etapa 1. El desacople no cambia ni la posición ni la velocidad (soltar la
  estructura no es una explosión), pero sí la masa y el motor: por eso la
  aceleración salta y $v$, $y$ no.
]

#paso(1, [etapa 1: la aceleración])
$ a_1(t) = (mu_1 v_(r 1)) / (M_0 - mu_1 t) - g = (750 thin 000 "N") / (30 thin 000 - 300 t) - 9,81, quad 0 <= t <= 60 "s". $
El empuje es $750$ kN contra un peso inicial de $294,3$ kN: arranca con
$a_1(0) = 15,19$ m/s². El propelente dura $18 thin 000 \/ 300 = 60$ s y al
final la masa es $12 thin 000$ kg: $a_1(60^-) = 52,69$ m/s².

#paso(2, [etapa 1: de $a$ a $v$])
$ v_1(t) = v(0) + integral_0^t a_1(s) dif s, $
y la constante $v(0) = 0$ es la velocidad en la plataforma. La integral del
empuje sale con el cambio $w = M_0 - mu_1 s$:
$ integral_0^t (mu_1 v_(r 1)) / (M_0 - mu_1 s) dif s = v_(r 1) ln M_0 / (M_0 - mu_1 t), quad "así que" quad v_1(t) = v_(r 1) ln M_0 / (M_0 - mu_1 t) - g t. $
En $t_1 = 60$ s: $v_1 = 2500 ln 2,5 - 9,81 dot 60 = 2290,7 - 588,6 = 1702$ m/s.

#paso(3, [etapa 1: de $v$ a $y$, por partes])
$ y_1(t) = y(0) + integral_0^t v_1(s) dif s, $
con $y(0) = 0$, la altura de la plataforma. El término de la gravedad da
$-1/2 g t^2$. El del logaritmo es el que pide *integrar por partes*:
$ I(t) = integral_0^t ln M_0 / (M_0 - mu s) dif s. $
Se elige $u = ln M_0 \/ (M_0 - mu s)$, cuya derivada es
$dif u = mu \/ (M_0 - mu s) dif s$, y $dif v = dif s$ con la primitiva
*conveniente* $v = -(M_0 - mu s)\/mu$ (cualquier primitiva sirve; ésta hace
que el producto $v thin dif u$ sea una constante):
$ I = [-(M_0 - mu s) / mu ln M_0 / (M_0 - mu s)]_0^t + integral_0^t (M_0 - mu s) / mu dot mu / (M_0 - mu s) dif s = -M(t) / mu ln M_0 / M(t) + t. $
(En $s = 0$ el corchete vale cero porque $ln 1 = 0$.) Entonces
$ y_1(t) = v_(r 1) [t - M(t) / mu_1 ln M_0 / M(t)] - 1/2 g t^2. $
En $t_1 = 60$ s, con $M = 12 thin 000$ kg:
$y_1 = 2500 [60 - 40 ln 2,5] - 1/2 dot 9,81 dot 60^2 = 58 thin 371 - 17 thin 658 = 40 thin 713$ m,
unos $40,7$ km.

#paso(4, [etapa 2: las constantes nuevas])
Se cuenta el tiempo desde el encendido de la etapa 2, $t' = t - 60$ s. La masa
arranca en $9000$ kg y baja a $60$ kg/s durante $6000 \/ 60 = 100$ s. Las
mismas integrales, pero ahora las constantes *no* son cero:
$ v_2(t') = v_1 + v_(r 2) ln 9000 / (9000 - 60 t') - g t', $
$ y_2(t') = y_1 + v_1 t' + v_(r 2) [t' - M(t') / mu_2 ln 9000 / M(t')] - 1/2 g t'^2, $
con $v_1 = 1702$ m/s y $y_1 = 40 thin 713$ m. El término $v_1 t'$ es la
constante de la primera integración, que vuelve a integrarse: la etapa 2 sube
aunque apague el motor, porque ya venía subiendo. En $t' = 100$ s
($M = 3000$ kg, razón $3$):
$ v_2 = 1702 + 3000 ln 3 - 981 = 1702 + 3295,8 - 981 = 4017 "m/s", $
$ y_2 = 40 thin 713 + 170 thin 213 + 3000 [100 - 50 ln 3] - 49 thin 050 = 297 thin 084 "m", $
unos $297$ km (el corchete vale $135 thin 208$ m).

#fp.fig-v-dos-etapas
#align(center, text(size: 9pt, fill: luma(80))[$v(t)$ con las fórmulas de arriba: continua en el desacople, con un quiebre en la pendiente.])

#paso(5, [el desacople])
Justo antes, $a = 750 thin 000 \/ 12 thin 000 - 9,81 = 52,69$ m/s²; justo
después, $a = 180 thin 000 \/ 9000 - 9,81 = 10,19$ m/s². La aceleración salta
(cambian el motor y la masa), la velocidad y la altura no: por eso son ellas
las que pasan de una etapa a la otra como constantes de integración. En el
gráfico se ve como un quiebre en la pendiente de $v(t)$, sin salto.

#paso(6, [sin soltar la estructura])
La etapa 2 cargaría $3000$ kg de estructura muerta: su masa iría de
$12 thin 000$ a $6000$ kg (razón $2$, no $3$):
$v = 1702 + 3000 ln 2 - 981 = 2801$ m/s. Se pierden $1216$ m/s: para eso
se desacopla — no tiene sentido seguir acelerando un tanque vacío.

#paso(7, [el ascenso libre])
Con $g$ constante, la energía da $Delta h = v_2^2 \/ (2 g) = 822,4$ km, así que
llegaría a unos $1120$ km. Con la gravedad general, entre $r_b = 6378 + 297,1$ km
y el punto más alto, donde $v = 0$:
$ 1/2 v_2^2 - mu / r_b = - mu / r_"máx" quad arrow.r.double quad r_"máx" = 7718 "km", $
o sea $1340$ km de altura. Hay que creerle a la segunda: a $300$ km la
gravedad ya es $8,95$ m/s², y más arriba sigue bajando, así que $g$ constante
*frena de más* y subestima la altura en $220$ km. La primera es la «ecuación
que no es la más general» de la que habla la cátedra: vale sólo si la altura
es chica frente al radio de la Tierra.

#camino[
  Se integró la aceleración dos veces, con las constantes puestas en cada
  tramo. Es el camino que pide la cátedra y el único que da la *altura*:
  Tsiolkovsky sola da velocidades, no posiciones. La $g$ constante durante el
  quemado es una aproximación (a $297$ km el error ya es del $9$ %), que se
  acepta porque sin ella las integrales no tienen fórmula cerrada.
]

#alternativa([la integral de $y$ por sustitución, sin partes])[
  Con $w = M_0 - mu s$ ($dif s = -dif w \/ mu$) la integral del logaritmo es
  $ I = 1/mu integral_(M)^(M_0) (ln M_0 - ln w) dif w = 1/mu [(M_0 - M) ln M_0 - (w ln w - w)_M^(M_0)], $
  y usando $integral ln w dif w = w ln w - w$ (que es, justamente, la integral
  por partes más conocida) queda
  $I = [(M_0 - M) - M ln(M_0 \/ M)]\/mu = t - (M\/mu) ln(M_0\/M)$: lo mismo.
  Y hay un control independiente: integrar $a(t)$ numéricamente, en $200 thin 000$ pasos por etapa, da $v_2 = 4017$ m/s e $y_2 = 297 thin 084$ m, las mismas cifras.
]

#trampa[
  El error típico es arrancar la etapa 2 con $v(0) = 0$ e $y(0) = 0$, como si
  fuera un cohete nuevo en la plataforma. Da $v_2 = 2315$ m/s y una altura
  absurda. La otra: usar en la etapa 2 el $M_0 = 30 thin 000$ kg del
  despegue; en el logaritmo va la masa al *empezar la etapa*.
]

#final[Etapa 1: $v_1 = 1702$ m/s, $y_1 = 40 thin 713$ m. Etapa 2: $v_2 = 4017$ m/s, $y_2 = 297 thin 084$ m. La aceleración salta de $52,69$ a $10,19$ m/s². Sin desacople, $2801$ m/s ($-1216$). Altura máxima: $1340$ km con $1\/r^2$ (con $g$ constante, unos $1120$ km).]

== Ejercicio 3 — la piedra lanzada desde la Luna

#notacion[
  $U = -mu m \/ r$ con $mu_L = G M_L$ (Sears §13.3). La velocidad de escape
  es la que deja la energía mecánica en cero: $v_"esc" = sqrt(2 mu \/ R)$. El
  Beer da la masa de la Luna como $0,01230$ veces la de la Tierra; con el
  $mu_T$ del apunte, $mu_L = 4903$ km³/s².
]

#idea[
  Mientras la sonda sube, la gravedad la frena, pero cada vez *menos*: a más
  altura, menos gravedad. La fórmula de tiro vertical supone que la gravedad
  no cambia, así que frena de más y da una altura menor que la real. Si la
  altura es comparable con el radio, el error es enorme.
]

#paso(1, [gravedad y escape])
$g_L = mu_L \/ R_L^2 = 4903 \/ 1740^2 = 1,619 times 10^(-3)$ km/s² $= 1,619$ m/s².
$v_"esc" = sqrt(2 dot 4903 \/ 1740) = 2,374$ km/s. Como $v_0 = 2,0 < 2,374$ km/s,
la energía mecánica es negativa: la sonda vuelve.

#paso(2, [la altura máxima, con la energía])
Entre la superficie y el punto más alto ($v = 0$):
$ 1/2 v_0^2 - mu_L / R_L = - mu_L / r_"máx" quad arrow.r.double quad 1 / r_"máx" = 1 / R_L - v_0^2 / (2 mu_L), $
$r_"máx" = 5996$ km, o sea $h_"máx" = 4256$ km: más de dos radios lunares.

#paso(3, [con $g$ constante])
$h = v_0^2 \/ (2 g_L) = 2000^2 \/ (2 dot 1,619) = 1235$ km: $3,4$ veces menos.
Arriba de todo la gravedad real es $mu_L \/ r_"máx"^2 = 0,136$ m/s², doce veces
menos que en la superficie: suponerla constante es suponer que la sonda sube
siempre contra un freno que en realidad casi desapareció.

#paso(4, [a un radio lunar de altura])
$ v^2 = v_0^2 - 2 mu_L (1 / R_L - 1 / (2 R_L)) = v_0^2 - mu_L / R_L quad arrow.r.double quad v = 1,087 "km/s". $

#camino[
  Conservación de la energía con $U = -mu m \/ r$: no hace falta saber
  cuánto tarda ni integrar nada en el tiempo, sólo comparar dos puntos.
]

#alternativa([la segunda ley, integrada en $r$])[
  $m thin dif v \/ dif t = -mu_L m \/ r^2$. Como $dif v \/ dif t = v thin dif v \/ dif r$
  (regla de la cadena, con $dif r \/ dif t = v$):
  $ integral_(v_0)^0 v dif v = -mu_L integral_(R_L)^(r_"máx") (dif r) / r^2 quad arrow.r.double quad -v_0^2 / 2 = mu_L (1 / r_"máx" - 1 / R_L), $
  que es exactamente la ecuación del Paso 2. Así se *deduce* la conservación
  de la energía: es el teorema del trabajo y la energía con la fuerza
  gravitatoria general (Sears §6.2 y §13.3).
]

#final[$g_L = 1,619$ m/s²; $v_"esc" = 2,374$ km/s (vuelve); $h_"máx" = 4256$ km (con $g$ constante, $1235$ km); a $1740$ km de altura pasa a $1,087$ km/s.]

== Ejercicio 4 — la órbita con el perigeo bajo y el apogeo alto

#notacion[
  $h$ momento angular específico, $epsilon$ energía específica, $p = h^2\/mu$
  parámetro, $nu$ anomalía verdadera ($theta$ en Curtis y Beer), $gamma$
  ángulo de trayectoria de vuelo. $v_perp$ y $v_r$
  son las componentes transversal y radial de la velocidad (Beer:
  $v_theta$ y $v_r$).
]

#idea[
  Con los dos ábsides se sabe todo lo de la elipse: su tamaño ($a$), su forma
  ($e$) y, con $a$, la energía y el período. El momento angular sale de juntar
  las dos conservaciones entre los ábsides, donde la velocidad es
  perpendicular al radio.
]

#paso(1, [forma, tamaño, período y energía])
$r_p = 6978$ km, $r_a = 26 thin 378$ km.
$ e = (r_a - r_p) / (r_a + r_p) = 0,5816, quad a = (r_a + r_p) / 2 = 16 thin 678 "km", $
$T = 2 pi sqrt(a^3\/mu) = 5,954$ h y $epsilon = -mu \/ (2 a) = -11,95$ km²/s².

#paso(2, [momento angular y rapideces en los ábsides])
En los ábsides $h = r v$. Juntando $r_p v_p = r_a v_a$ con la energía entre los
dos puntos:
$ h = sqrt((2 mu r_p r_a) / (r_p + r_a)) = 66 thin 326 "km"^2"/s", quad v_p = h / r_p = 9,505 "km/s", quad v_a = h / r_a = 2,514 "km/s". $

#paso(3, [el punto a $13 thin 000$ km])
$p = h^2 \/ mu = 11 thin 036$ km. De la ecuación de la órbita,
$ cos nu = (p \/ r - 1) / e = (11 thin 036 \/ 13 thin 000 - 1) / 0,5816 quad arrow.r.double quad nu = 105,1° $
(se aleja: primer semiciclo). Ahí $v_perp = h\/r = 5,102$ km/s,
$v_r = (mu\/h) e sin nu = 3,375$ km/s, la rapidez es
$sqrt(v_perp^2 + v_r^2) = 6,117$ km/s y
$gamma = arctan(v_r \/ v_perp) = 33,5°$.

#alternativa([la rapidez por vis-viva])[
  $v = sqrt(mu (2\/r - 1\/a)) = sqrt(398 thin 600 (2\/13 thin 000 - 1\/16 thin 678)) = 6,117$ km/s,
  sin saber $nu$. Y $gamma$ sale de $cos gamma = h \/ (r v) = 66 thin 326 \/ (13 thin 000 dot 6,117)$,
  de nuevo $33,5°$ (positivo porque se aleja). Es más corto, pero no da
  dónde está el punto sobre la órbita: para eso hace falta la ecuación de la
  órbita.
]

#paso(4, [velocidad areolar])
$dif A \/ dif t = h\/2 = 33 thin 163$ km²/s, constante. Como el área se barre
a ritmo constante y el triángulo que barre cerca del apogeo es largo y
angosto, el satélite pasa *la mayor parte del período lejos*, del lado del
apogeo, y cruza rápido por el perigeo. Es la segunda ley de Kepler.

#camino[
  $h$ con la fórmula que junta las dos conservaciones; $nu$ con la ecuación
  de la órbita; $v_r$ con su fórmula en función de $nu$.
]

#final[$e = 0,5816$, $a = 16 thin 678$ km, $T = 5,954$ h, $epsilon = -11,95$ km²/s²; $h = 66 thin 326$ km²/s, $v_p = 9,505$ km/s, $v_a = 2,514$ km/s; en $r = 13 thin 000$ km: $nu = 105,1°$, $v_perp = 5,102$, $v_r = 3,375$, $v = 6,117$ km/s, $gamma = 33,5°$.]

== Ejercicio 5 — escapar: desde el perigeo o desde el apogeo

#notacion[
  Igual que antes: $mu$ es $G M_T$ en las órbitas y el caudal en el cohete.
  $v_"esc"(r) = sqrt(2 mu \/ r)$ es la velocidad de escape *en ese radio*,
  no sólo en la superficie.
]

#idea[
  Escapar es llevar la energía específica a cero: hay que *sumar*
  $abs(epsilon)$ de energía, que es la misma desde cualquier punto de la órbita.
  Pero un encendido corto cambia la energía en
  $Delta epsilon = v Delta v + 1/2 Delta v^2$: el mismo $Delta v$ rinde más
  energía donde la nave va *más rápido*. Por eso conviene el perigeo (es el
  efecto Oberth).
]

#paso(1, [las rapideces])
$r_p = 6678$ km, $r_a = 9378$ km:
$v_p = sqrt(2 mu r_a \/ (r_p (r_p + r_a))) = 8,350$ km/s y
$v_a = v_p r_p \/ r_a = 5,946$ km/s.

#paso(2, [escapar desde cada ábside])
Desde el perigeo: $v_"esc" = sqrt(2 mu\/r_p) = 10,926$ km/s, así que
$Delta v_P = 2,576$ km/s. Desde el apogeo: $v_"esc" = 9,220$ km/s y
$Delta v_A = 3,274$ km/s. Conviene el perigeo: $0,7$ km/s menos. En los dos
casos se suma la misma energía, $abs(epsilon) = mu\/(2a) = 24,83$ km²/s², pero
en el perigeo cada m/s vale más energía porque $v$ es más grande.

#paso(3, [el propelente])
$v_e = 300 dot 9,81 = 2,943$ km/s. De Tsiolkovsky, la masa quemada es
$m_0 (1 - e^(-Delta v \/ v_e))$: $583$ kg desde el perigeo y $671$ kg desde el
apogeo.

#paso(4, [circularizar a $3000$ km])
Se enciende en el *apogeo*, hacia adelante: la circular a $r_a$ pide
$sqrt(mu\/r_a) = 6,519$ km/s y la nave tiene $5,946$; $Delta v = 0,573$ km/s.
(Encender en el perigeo cambiaría el apogeo, no el perigeo.)

#camino[
  Velocidades de la vis-viva (o de juntar $h$ y la energía) y escape como
  $v_"esc" - v$ en cada punto.
]

#alternativa([pensarlo con la energía])[
  Hay que subir $epsilon$ de $-24,83$ a $0$ km²/s². En el perigeo:
  $Delta epsilon = v_p Delta v + 1/2 Delta v^2 = 8,350 dot 2,576 + 1/2 dot 2,576^2 = 24,83$ ✓.
  En el apogeo: $5,946 dot 3,274 + 1/2 dot 3,274^2 = 24,83$ ✓. La misma
  energía, con distinto $Delta v$: la diferencia la pone el término $v Delta v$.
]

#final[$v_p = 8,350$ km/s, $v_a = 5,946$ km/s; escapar: $Delta v_P = 2,576$ km/s ($583$ kg) contra $Delta v_A = 3,274$ km/s ($671$ kg), conviene el perigeo; circularizar a $3000$ km: $0,573$ km/s en el apogeo.]

== Ejercicio 6 — la banqueta y la rueda

#notacion[
  $bold(L)$ es el momento angular (guía: *impulso angular*; Beer:
  $bold(H)$). Para un aro, $I = m R^2$ respecto de su eje (Sears, Tabla 9.2:
  no se memoriza, se busca). Se toma $z$ vertical hacia arriba: el sentido
  antihorario visto desde arriba es $+z$ (regla de la mano derecha).
]

#idea[
  El piso no puede hacer torque *vertical* sobre la banqueta (gira sin roce),
  así que la componente vertical del momento angular de persona + banqueta +
  rueda se conserva. Al dar vuelta la rueda, su momento angular pasa de
  $+L_r$ a $-L_r$: para que el total siga igual, la persona tiene que tomar
  $+2 L_r$. La persona empuja la rueda y la rueda empuja a la persona.
]

#paso(1, [el momento angular de la rueda])
$I_r = 2,4 dot 0,35^2 = 0,294$ kg·m² y $L_r = I_r omega = 0,294 dot 30 = 8,82$ kg·m²/s,
en $+z$.

#paso(2, [la persona después])
$ L_z: quad 0 + I_r omega = I_p Omega + I_r (-omega) quad arrow.r.double quad Omega = (2 I_r omega) / I_p = 17,64 / 6,0 = 2,94 "rad/s", $
unas $28,1$ rpm, antihoraria vista desde arriba: en el sentido en que giraba
la rueda al principio.

#paso(3, [la energía])
$K_0 = 1/2 dot 0,294 dot 30^2 = 132,3$ J. Después la rueda tiene lo mismo
(sigue a $30$ rad/s) y se suma $1/2 dot 6,0 dot 2,94^2$: $K_1 = 158,2$ J. Hay
$25,93$ J más, que pusieron los músculos de la persona al dar vuelta la rueda
contra el giróscopo.

#paso(4, [el torque medio])
La componente vertical del momento angular de la rueda cambia en
$-2 L_r = -17,64$ kg·m²/s en $0,8$ s: la persona le hace un torque medio de
$22,05$ N·m hacia $-z$. La rueda le devuelve $22,05$ N·m hacia $+z$ a la
persona, que es lo que la pone a girar. Son torques internos: el total no
cambia.

#paso(5, [si sólo la acuesta])
Con el eje horizontal la rueda no aporta momento angular vertical:
$I_p Omega = L_r$ y $Omega = 1,47$ rad/s, la mitad (despreciando lo poco que aporta la rueda acostada al girar con la persona). (La componente horizontal
de $bold(L)_r$ la «absorbe» la Tierra a través del piso, que sí puede hacer
torque horizontal sobre la banqueta.)

#camino[
  Conservación de la componente vertical de $bold(L)$ del sistema completo,
  eligiendo el sistema para que los torques de la persona sobre la rueda
  queden adentro.
]

#alternativa([con el impulso angular sobre la persona])[
  Tomando como sistema sólo a persona + banqueta, sí hay un torque externo:
  el que le hace la rueda. Su integral en el tiempo, el impulso angular
  $integral tau dif t$, es el cambio del momento angular de la persona:
  $integral tau dif t = I_p Omega - 0$. Y ese impulso es igual y contrario al
  que la persona le hizo a la rueda, $Delta L_r = -17,64$ kg·m²/s. Entonces
  $I_p Omega = 17,64$ y $Omega = 2,94$ rad/s: lo mismo, mirado desde un
  sistema más chico.
]

#final[$L_r = 8,82$ kg·m²/s; $Omega = 2,94$ rad/s ($28,1$ rpm) en el sentido original de la rueda; $K$ sube de $132,3$ a $158,2$ J ($+25,93$ J, de los músculos); $tau_"medio" = 22,05$ N·m; acostándola, $Omega = 1,47$ rad/s.]

== Ejercicio 7 — dos partículas antiparalelas

#notacion[
  $bold(L)_O = sum bold(r)_i times m_i bold(v)_i$, con las posiciones medidas
  desde $O$ (Beer: $bold(H)_O$). Una *cupla* (o par) es un par de fuerzas
  iguales, opuestas y no colineales; la lista de temas usa «torca, torque o
  cupla» como sinónimos del momento de una fuerza.
]

#idea[
  Cambiar el origen suma a cada posición el mismo vector. Eso le agrega al
  momento angular un término que es ese vector cruz la cantidad de movimiento
  *total*. Si la cantidad de movimiento total es cero, no se agrega nada.
]

#paso(1, [el cambio de origen])
Si $O'$ está en $bold(R)$ (medido desde $O$), las posiciones desde $O'$ son
$bold(r)'_i = bold(r)_i - bold(R)$:
$ bold(L)_(O') = sum (bold(r)_i - bold(R)) times m_i bold(v)_i = bold(L)_O - bold(R) times sum m_i bold(v)_i = bold(L)_O - bold(R) times bold(P). $
Acá $bold(P) = m bold(v) + m(-bold(v)) = 0$, así que $bold(L)_(O') = bold(L)_O$
para cualquier $O'$.

#paso(2, [el módulo])
$bold(L)_O = bold(r)_1 times m bold(v) + bold(r)_2 times m (-bold(v)) = m (bold(r)_1 - bold(r)_2) times bold(v)$.
La componente de $bold(r)_1 - bold(r)_2$ perpendicular a $bold(v)$ es la
separación $d$ entre las rectas, así que $abs(bold(L)_O) = m v d$.

#paso(3, [la cupla])
Es la misma cuenta con fuerzas: el torque de $bold(F)$ y $-bold(F)$ respecto
de $O'$ es el de $O$ menos $bold(R) times (bold(F) - bold(F)) = 0$. El torque
de una cupla no depende del punto, y vale $F d$.

#camino[
  Se demostró en general, con el cambio de origen, y el resultado sale para
  *cualquier* sistema con $bold(P) = 0$.
]

#alternativa([con el origen en una de las rectas])[
  Poniendo $O$ sobre la recta de la partícula 1, su momento angular es cero
  (brazo nulo) y el de la 2 es $m v d$. Poniéndolo sobre la recta de la 2,
  es al revés: $m v d$ de la 1 y cero de la 2. Poniéndolo a mitad de camino,
  cada una aporta $m v d \/ 2$, en el mismo sentido. Siempre $m v d$. Es la
  forma de «verlo», pero no demuestra que valga para *todo* punto: para eso
  está el Paso 1.
]

#final[$bold(L)_(O') = bold(L)_O - bold(R) times bold(P)$ y $bold(P) = 0$: el mismo respecto de cualquier punto, de módulo $m v d$. Pasa igual con el torque de una cupla, $F d$.]
