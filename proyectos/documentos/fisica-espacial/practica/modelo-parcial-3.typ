// =====================================================================
//  Modelo de parcial 3 -- primera evaluacion
//  Siete ejercicios integradores. El 2 es el cohete que LLEGA desde
//  afuera y frena (condiciones iniciales distintas de cero), con la masa
//  que entra como contraejemplo. Cada numero tiene su cuenta en validar.py.
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp
#import "../apunte/biblioteca/figuras.typ" as figs

#show: documento.with(
  titulo: [Modelo de parcial 3],
  subtitulo: [Explosión, descenso con retrocohete, Kepler, parámetros orbitales, encuentro orbital y giróscopos],
  encabezado: [Modelo de parcial 3],
)

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Tiempo sugerido: *3 horas*. Hoja de fórmulas propia y calculadora. En cada
  paso hay que decir *qué se conserva y por qué*: vale tanto como el número.
  Datos: $mu_T = 398 thin 600$ km³/s², $R_T = 6378$ km, $g_0 = 9,81$ m/s²,
  $G = 6,674 times 10^(-11)$ N·m²/kg², día sideral $= 23,934$ h.
  *Notación:* la del apunte — $bold(L)$ momento angular (la guía de la cátedra
  lo llama *impulso angular*), $bold(tau)$ torque, $omega$ velocidad angular,
  $bold(P)$ cantidad de movimiento. Cada resolución abre con la notación de su
  tema y cómo aparece en la guía y en los libros.
]

#mapa(
  ([1], [cantidad de movimiento en 2D, explosión, centro de masa], [Ej. 1 y 2 de cantidad de movimiento y el centro de masa]),
  ([2], [cohete que llega y frena: $v_0 != 0$, $y_0 != 0$; masa que entra (contraejemplo)], [Ej. 6 a 9 de cantidad de movimiento (Beer 14.94–14.99) y la masa variable (Beer 14.12)]),
  ([3], [gravitación, tercera ley de Kepler, órbita geoestacionaria], [Problemas 0 y 3 de gravitación]),
  ([4], [parámetros orbitales desde dos mediciones], [Adicional 4 de gravitación]),
  ([5], [maniobras: Hohmann y ángulo de fase para un encuentro], [Problemas 5 y 10 de gravitación]),
  ([6], [momento angular: giróscopo, precesión, analogía con la órbita], [Problemas 4 y 7 de impulso angular (S&Z 10.51 y 10.53)]),
  ([7], [segunda ley de Kepler y momento angular (demostración)], [Problema 6 de impulso angular]),
)

#ejercicio(1, [el satélite que explota en tres], [1,25])
#origen[Cantidad de movimiento en dos dimensiones, energía liberada, centro de masa. Se apoya en los Ej. 1 y 2 de cantidad de movimiento.]

Un satélite en desuso de $100$ kg, en reposo respecto de un marco en caída
libre que lo acompaña, explota en tres pedazos que salen en el mismo plano:
$A$, de $20$ kg, a $30$ m/s en la dirección $0°$; $B$, de $30$ kg, a $20$ m/s en
la dirección $120°$; y $C$, de $50$ kg.

#fp.fig-explosion()

+ Calcule la velocidad de $C$: módulo y dirección.
+ ¿Cuánta energía liberó la explosión?
+ ¿Dónde está el centro de masa de los tres pedazos $10$ s después? Verifíquelo
  con las posiciones de cada uno.
+ ¿Hay alguna simetría que permita adivinar el resultado del inciso 1 sin
  hacer cuentas?

#ejercicio(2, [el módulo que llega y frena], [2])
#origen[Ecuación del cohete con condiciones iniciales distintas de cero, integración de $a$, $v$ e $y$ por partes, y la masa que entra. Se apoya en los Ej. 6 a 9 de cantidad de movimiento (Beer 14.94–14.99) y en la masa variable del Beer (§14.12).]

Un módulo de descenso de $4000$ kg (con $800$ kg de propelente) llega a la
Luna bajando verticalmente. Cuando está a $2000$ m de altura y baja a $60$ m/s,
enciende el motor apuntando hacia abajo: quema $5$ kg/s con los gases a
$3000$ m/s respecto del módulo. Tome $g_L = 1,62$ m/s² constante.

#fp.fig-cohete-p(baja: true, suelo: [Luna], rot-y0: [$y_0 = 2000$ m], datos: [$v_0 = -60$ m/s \ $4000$ kg])

+ Escriba $a(t)$ con $y$ hacia arriba. ¿El módulo frena apenas enciende?
+ Integre para obtener $v(t)$ e $y(t)$. ¿Qué son ahora las constantes de
  integración, y qué signo tienen?
+ ¿Cuándo queda quieto (en el aire)? ¿A qué altura? ¿Cuánto propelente gastó?
+ ¿Desde qué altura mínima puede encender, con este motor, para llegar al
  suelo justo con velocidad cero?
+ Resuelva de nuevo el inciso 3 suponiendo que la masa no cambia. ¿Cuánto se
  equivoca, y por qué tan poco?
+ *El caso al revés: la masa que entra.* Una nave de $2000$ kg viaja sin motor a
  $8,0$ km/s y atraviesa una nube de polvo en reposo, que se le pega a razón
  de $0,5$ kg por kilómetro recorrido. ¿Qué velocidad tiene después de
  $1000$ km, y cuánto tardó? ¿Qué empuje haría falta para mantener los
  $8,0$ km/s? ¿Vale acá $F = dif (m v) \/ dif t$?

#ejercicio(3, [la masa de la Tierra y la órbita geoestacionaria], [1,25])
#origen[Ley de gravitación, tercera ley de Kepler, órbita circular, energía. Se apoya en los Problemas 0 y 3 de gravitación.]

La Luna gira alrededor de la Tierra en $27,32$ días a una distancia media de
$384 thin 400$ km.

#fp.fig-tierra-luna

+ Estime la masa de la Tierra con esos dos datos.
+ Estímela de nuevo con $g_0$ y $R_T$. ¿Por qué no dan igual?
+ Calcule el radio, la altura y la velocidad de la órbita geoestacionaria.
  ¿Por qué se usa el día sideral y no las $24$ h?
+ ¿Cuánta energía por kilogramo hay que darle a un satélite para llevarlo del
  ecuador a la órbita geoestacionaria? ¿Cuánto ayuda la rotación de la Tierra?

#ejercicio(4, [la órbita desde dos mediciones], [1,5])
#origen[Ecuación de la órbita, parámetros orbitales, ángulo de trayectoria de vuelo. Se apoya en el Adicional 4 de gravitación.]

Un satélite se mide a $900$ km de altura en una anomalía verdadera de $45°$, y
a $4500$ km de altura en una anomalía verdadera de $150°$.

#fp.fig-orbita-p(0.247, 2.5, puntos: ((anom: 45, rot: [1]), (anom: 150, rot: [2], desp: (-0.1, 0.1), ancla: "south-east", rot-anom: $nu_2$, radio-anom: 1.05, rot-r: $bold(r)_2$, lado-r: "north-east")))

+ Calcule la excentricidad y el parámetro $p$ de la órbita.
+ Calcule los radios y las alturas del perigeo y del apogeo, el semieje
  mayor y el período.
+ Calcule el momento angular específico, y la rapidez y el ángulo de
  trayectoria de vuelo en el primer punto.
+ ¿La órbita roza la atmósfera?

#ejercicio(5, [alcanzar la estación], [1,5])
#origen[Transferencia de Hohmann, tercera ley de Kepler, ángulo de fase. Se apoya en los Problemas 5 y 10 de gravitación.]

Una nave está en una órbita circular a $250$ km de altura y tiene que
encontrarse con una estación que está en una órbita circular coplanar a
$420$ km, usando una transferencia de Hohmann.

#fp.fig-hohmann-p(1.5, 2.5, rot1: [250 km], rot2: [420 km], blanco: 40)
#align(center, text(size: 8.5pt, fill: luma(90))[Radios sin escala: la diferencia real es de sólo 170 km.])

+ Calcule los dos $Delta v$ y el total, y el tiempo de la transferencia.
+ ¿Qué ángulo tiene que llevarle de ventaja la estación a la nave en el
  momento del primer encendido?
+ En este momento la estación va $40°$ adelante de la nave. ¿Cuánto hay que
  esperar para encender?
+ ¿Y si la estación fuera $2°$ adelante? ¿Qué se podría hacer para no
  esperar tanto?

#ejercicio(6, [el giróscopo del telescopio], [1,5])
#origen[Momento angular de un rotor, torque, precesión, analogía giróscopo–órbita. Se apoya en los Problemas 4 y 7 de impulso angular (S&Z 10.51 y 10.53).]

Cada giróscopo de un telescopio espacial es un cilindro de pared delgada de
$2,0$ kg y $5,0$ cm de diámetro que gira a $19 thin 200$ rpm alrededor de su
eje.

#fp.fig-giroscopo-p()

+ Calcule su momento de inercia y su momento angular.
+ ¿Qué torque hace falta para que su eje preceda $1,0 times 10^(-6)$ grados
  durante una exposición de $5,0$ h?
+ En el laboratorio, el mismo rotor (con su marco, $2,3$ kg en total) se apoya
  en un pivote con el eje horizontal y el centro de masa a $4,0$ cm, como en la
  figura. Calcule la fuerza del pivote, el torque del peso y la velocidad de
  precesión. Dibuje $bold(L)$ y $bold(tau)$ y diga hacia dónde precede.
+ Explique por qué el giróscopo no se cae, comparándolo con un satélite en
  órbita circular que tampoco se cae.

#ejercicio(7, [la segunda ley de Kepler], [1,0])
#origen[Velocidad areolar y momento angular. Es el Problema 6 de impulso angular (la «pregunta fina»).]

+ Escriba la segunda ley de Kepler en términos de la velocidad areolar, y
  demuestre que es equivalente a la conservación del momento angular.
+ ¿Qué hace falta para que se cumpla: que la fuerza sea central y además
  vaya como $1\/r^2$, o alcanza con que sea central?

#figs.fig-velocidad-areolar

#pagebreak()

= Resolución

== Ejercicio 1 — el satélite que explota en tres

#notacion[
  $bold(P) = sum m_i bold(v)_i$ (Beer: $bold(L)$). El centro de masa es
  $bold(r)_"CM" = sum m_i bold(r)_i \/ M$ y se mueve con
  $bold(v)_"CM" = bold(P) \/ M$ (Sears §8.5). Los ángulos se miden desde el
  eje $x$, antihorario.
]

#idea[
  La explosión es interna: la cantidad de movimiento total sigue siendo la de
  antes, cero. Entonces las tres cantidades de movimiento tienen que sumar
  cero, y el centro de masa no se mueve nunca: los pedazos se alejan pero su
  «promedio pesado» se queda donde estaba el satélite.
]

#paso(1, [la velocidad de $C$])
$bold(v)_B = 20 (cos 120°; sin 120°) = (-10; 17,32)$ m/s. Con $bold(P) = 0$:
$ 50 thin bold(v)_C = -(20 (30; 0) + 30 (-10; 17,32)) = -(300; 519,6) quad arrow.r.double quad bold(v)_C = (-6,00; -10,39) "m/s", $
de módulo $12,0$ m/s, en la dirección $240°$.

#paso(2, [la energía liberada])
Antes era cero; después
$K = 1/2 dot 20 dot 30^2 + 1/2 dot 30 dot 20^2 + 1/2 dot 50 dot 12^2 = 9000 + 6000 + 3600 = 18 thin 600$ J.

#paso(3, [el centro de masa])
Sigue en el origen. Verificación a los $10$ s: $bold(r)_A = (300; 0)$,
$bold(r)_B = (-100; 173,2)$, $bold(r)_C = (-60; -103,9)$ m, y
$20 bold(r)_A + 30 bold(r)_B + 50 bold(r)_C = (6000 - 3000 - 3000; 0 + 5196 - 5196) = (0; 0)$.

#paso(4, [la simetría])
$p_A = 20 dot 30 = 600$ kg·m/s y $p_B = 30 dot 20 = 600$ kg·m/s, a $120°$ uno
del otro. Tres vectores que suman cero y dos de ellos iguales a $120°$: el
tercero tiene que ser igual y estar a $120°$ de los dos, en $240°$. Entonces
$p_C = 600$ y $v_C = 600 \/ 50 = 12$ m/s. Sin una cuenta.

#fp.fig-explosion(triangulo: true)

#camino[
  Conservación de $bold(P)$ por componentes: es el camino que funciona siempre,
  haya simetría o no.
]

#alternativa([el triángulo de cantidades de movimiento])[
  Poniendo $bold(p)_A$, $bold(p)_B$ y $bold(p)_C$ uno a continuación del otro
  tienen que cerrar un triángulo (suman cero). Con $p_A = p_B = 600$ y
  $120°$ entre sus direcciones, el ángulo interior entre ellos es $60°$ y el
  triángulo es equilátero: $p_C = 600$ kg·m/s. Es lo que la cátedra llama
  usar la simetría para no calcular.
]

#final[$bold(v)_C = (-6,00; -10,39)$ m/s: $12,0$ m/s a $240°$; se liberaron $18 thin 600$ J; el centro de masa queda en el origen.]

== Ejercicio 2 — el módulo que llega y frena

#notacion[
  $mu$ caudal, $v_r$ velocidad de los gases respecto del módulo (Sears:
  $v_"esc"$; Beer: $u$). *Todo con $y$ hacia arriba*: la velocidad inicial es
  $v_0 = -60$ m/s (baja) y el empuje es positivo (los gases salen hacia abajo).
  Para la masa que entra, el Beer (§14.12) escribe la ecuación general con la
  velocidad $bold(u)$ de la masa que entra o sale; acá se usa $lambda$ para la
  masa de polvo por unidad de longitud.
]

#idea[
  Es el mismo cohete que despega, mirado al revés: el motor empuja hacia
  arriba y la nave va hacia abajo, así que el empuje *frena*. Las ecuaciones
  son las mismas; lo que cambia son las *constantes de integración*: la
  velocidad inicial no es cero sino $-60$ m/s, y la altura inicial es
  $2000$ m. Un cero mal puesto acá es un módulo estrellado.
]

#paso(1, [la aceleración])
$ a(t) = (mu v_r) / (M_0 - mu t) - g_L = (15 thin 000) / (4000 - 5 t) - 1,62 "m/s"^2. $
El empuje, $15 thin 000$ N, supera al peso lunar, $4000 dot 1,62 = 6480$ N: al
encender $a(0) = 2,13$ m/s², *hacia arriba*. Como la velocidad es hacia abajo,
el módulo frena desde el primer instante.

#paso(2, [$v(t)$ e $y(t)$, con las constantes])
Integrando una vez (la integral del empuje es la de siempre, con
$w = M_0 - mu s$):
$ v(t) = v_0 + v_r ln M_0 / (M_0 - mu t) - g_L t, quad v_0 = -60 "m/s". $
Integrando otra vez, con la integral del logaritmo por partes
($u = ln M_0\/(M_0 - mu s)$, $dif v = dif s$, primitiva
$-(M_0 - mu s)\/mu$, igual que en el cohete que sube):
$ y(t) = y_0 + v_0 t + v_r [t - M(t) / mu ln M_0 / M(t)] - 1/2 g_L t^2, quad y_0 = 2000 "m". $
$v_0$ es negativa y $y_0$ positiva: las dos constantes son *datos del
problema*, no ceros. El término $v_0 t$ es el que hace caer al módulo
mientras el motor todavía no alcanzó a frenarlo.

#paso(3, [cuándo queda quieto])
Hay que resolver $v(t) = 0$:
$ 3000 ln 4000 / (4000 - 5 t) - 1,62 thin t = 60. $
No tiene despeje cerrado: se prueba. $v(27) = -0,74$ m/s y $v(28) = +1,52$ m/s;
interpolando, $t_s = 27,33$ s. Ahí $M = 4000 - 5 dot 27,33 = 3863$ kg (gastó
$136,6$ kg de propelente) y
$ y(t_s) = 2000 - 1639,7 + 1416,5 - 604,9 = 1172 "m". $
Queda quieto a $1172$ m de altura: frenó en $828$ m.

#paso(4, [la altura mínima para encender])
La caída mientras frena, $828$ m, no depende de dónde empiece (el motor y la
velocidad inicial son los mismos). Si enciende a $828$ m llega al suelo justo
con $v = 0$; más abajo, se estrella. Por eso los aterrizajes reales encienden
con margen.

#paso(5, [con la masa constante])
Si la masa no cambiara, $a = 2,13$ m/s² constante: $t = 60 \/ 2,13 = 28,17$ s
y la caída $60^2 \/ (2 dot 2,13) = 845$ m. El error es del $2$ %, chico porque
en $27$ s se quema sólo el $3,4$ % de la masa ($ln(M_0\/M) = 0,0348$): la
aceleración casi no cambia. En el cohete que despega del Ejercicio 2 del
Modelo 2, donde se quema el $60$ % de la masa, la misma aproximación sería un
desastre.

#camino[
  Ecuación del cohete integrada dos veces, con las condiciones iniciales del
  enunciado. Es la misma solución general de siempre; lo único nuevo es que
  $v_0$ e $y_0$ no son cero.
]

#alternativa([integrar la aceleración numéricamente])[
  Sin fórmulas: se avanza en pasos chicos, $v arrow.l v + a(t) Delta t$ e
  $y arrow.l y + v Delta t$, desde $v = -60$ m/s e $y = 2000$ m. Con
  $200 thin 000$ pasos hasta $t_s$ da $v = 0$ e $y = 1172$ m: las mismas cifras.
  Es el control de que la integración por partes está bien — y la forma de
  resolver el problema si el caudal no fuera constante.
]

#paso(6, [la masa que entra: el polvo])
El polvo está quieto y se pega: es un *choque plástico continuo*. El sistema
nave + polvo ya capturado no recibe fuerza externa, así que su cantidad de
movimiento se conserva:
$ m(x) v = M_0 v_0, quad m(x) = M_0 + lambda x quad arrow.r.double quad v(x) = (M_0 v_0) / (M_0 + lambda x). $
Con $lambda = 0,5$ kg/km, a los $1000$ km la masa es $2500$ kg y
$v = 2000 dot 8,0 \/ 2500 = 6,40$ km/s. La energía cinética baja de $64,0$ a
$51,2$ GJ: se pierden $12,8$ GJ en calor, como en todo choque plástico.

Para el tiempo hay que integrar otra vez, ahora en $x$ (en unidades SI:
$lambda = 5 times 10^(-4)$ kg/m, $x = 10^6$ m, $v_0 = 8000$ m/s):
$dif x \/ dif t = M_0 v_0 \/ (M_0 + lambda x)$, que se separa como
$(M_0 + lambda x) dif x = M_0 v_0 dif t$. Con $x(0) = 0$ como constante:
$ M_0 x + 1/2 lambda x^2 = M_0 v_0 t quad arrow.r.double quad t = (2000 dot 10^6 + 1/2 dot 5 times 10^(-4) dot 10^(12)) / (2000 dot 8000) = 140,6 "s". $

Para mantener la velocidad, en cada segundo hay que acelerar desde cero hasta
$v$ el polvo que entra, $lambda v$ kilos: $F = lambda v dot v = lambda v^2 = 5 times 10^(-4) dot 8000^2 = 32$ kN.

#trampa[
  ¿Vale $F = dif(m v)\/dif t$? *Acá sí*, y sólo porque el polvo que entra
  estaba *quieto*. En el cohete no vale, porque los gases salen con velocidad
  $v - v_r$, no cero. La ecuación que vale siempre (Beer §14.12) es
  $ m thin (dif v) / (dif t) = F + (dif m) / (dif t) (u - v), $
  con $u$ la velocidad de la masa que entra o sale. Para el cohete,
  $dif m\/dif t = -mu$ y $u - v = -v_r$: queda $m thin dif v\/dif t = F + mu v_r$,
  el empuje. Para el polvo, $dif m \/dif t = lambda v$ y $u = 0$: queda
  $m thin dif v\/dif t = F - lambda v^2$, que es lo mismo que
  $dif(m v)\/dif t = F$. *El contraejemplo es éste*: usar $F = dif(m v)\/dif t$
  en el cohete da un empuje equivocado.
]

#final[$a(0) = 2,13$ m/s² (frena); $v(t) = -60 + 3000 ln(4000\/(4000 - 5 t)) - 1,62 t$; queda quieto a los $27,33$ s, a $1172$ m, con $136,6$ kg gastados; altura mínima $828$ m (con masa constante, $845$ m). Polvo: $6,40$ km/s a los $1000$ km, en $140,6$ s; mantener $8$ km/s pide $32$ kN.]

== Ejercicio 3 — la masa de la Tierra y la órbita geoestacionaria

#notacion[
  $G$ constante de gravitación, $mu = G M$ (Curtis y Bate; el Roederer usa
  $mu$ para la masa reducida). La tercera ley de Kepler para órbita circular:
  $T^2 = 4 pi^2 r^3 \/ mu$. El Beer (Problema 12.80, el 3 de la guía) usa
  $G M = g R^2$ con $R = 6370$ km.
]

#idea[
  Una órbita circular es un equilibrio entre la gravedad y la aceleración
  centrípeta: la gravedad hace de «hilo». Midiendo el radio y el período de
  cualquier satélite —la Luna sirve— se mide cuánto tira ese hilo, o sea
  $G M$. Y al revés: fijando el período en un día, sale el radio.
]

#paso(1, [la masa desde la Luna])
$G M m \/ r^2 = m (2 pi \/ T)^2 r$, así que
$ M = (4 pi^2 r^3) / (G T^2) = (4 pi^2 (3,844 times 10^8)^3) / (6,674 times 10^(-11) (27,32 dot 86 thin 400)^2) = 6,030 times 10^24 "kg". $

#paso(2, [la masa desde $g$])
En la superficie $m g_0 = G M m \/ R_T^2$:
$M = g_0 R_T^2 \/ G = 5,979 times 10^24$ kg. La diferencia, de un $1$ %, es
casi toda física: la Luna no gira alrededor del centro de la Tierra sino los
dos alrededor de su centro de masa, y lo que mide la tercera ley es
$G(M_T + M_L)$. La Luna tiene el $1,2$ % de la masa de la Tierra.

#paso(3, [la geoestacionaria])
Tiene que dar una vuelta en lo que tarda la Tierra en girar *respecto de las
estrellas*, el día sideral, $T = 86 thin 162$ s:
$ r_g = (mu T^2 / (4 pi^2))^(1\/3) = 42 thin 164 "km", quad h = 35 thin 786 "km", quad v = sqrt(mu / r_g) = 3,075 "km/s". $
Las $24$ h son el día *solar*: de mediodía a mediodía la Tierra gira un poco
más de una vuelta, porque también avanzó en su órbita. Con $24$ h saldría
$r = 42 thin 241$ km, $77$ km de más, y el satélite se iría corriendo
despacio hacia el oeste.

#paso(4, [la energía por kilogramo])
Del reposo en la superficie a la órbita circular:
$ Delta epsilon = -mu / (2 r_g) - (-mu / R_T) = 57,77 "MJ/kg". $
En el ecuador el satélite ya tiene la velocidad de la rotación,
$2 pi R_T \/ T = 0,465$ km/s: ahorra $1/2 dot 0,465^2 = 0,108$ MJ/kg. Poco
en energía (el $0,2$ %), aunque en $Delta v$ del lanzador son $465$ m/s
gratis, y por eso se lanza hacia el este y cerca del ecuador.

#camino[
  Tercera ley en su forma de órbita circular, deducida en un renglón de
  $F = m a$ con la gravedad como fuerza centrípeta.
]

#alternativa([la geoestacionaria sin $mu$, desde la Luna])[
  La tercera ley dice que $r^3 \/ T^2$ es el mismo para todo lo que orbita
  la Tierra. Entonces
  $r_g = r_L (T_g \/ T_L)^(2\/3) = 384 thin 400 (0,99725 \/ 27,32)^(2\/3)$ km,
  que da unos $42 thin 300$ km: $0,3$ % arriba, porque la Luna trae adentro
  su propia masa (el $M_T + M_L$ del Paso 2). Es el camino de Kepler, sin
  saber $G$ ni $M$.
]

#final[$M_T approx 6,030 times 10^24$ kg desde la Luna y $5,979 times 10^24$ kg desde $g_0$ (la diferencia es la masa de la Luna); $r_g = 42 thin 164$ km, $h = 35 thin 786$ km, $v = 3,075$ km/s; $57,77$ MJ/kg, de los que la rotación ahorra $0,108$.]

== Ejercicio 4 — la órbita desde dos mediciones

#notacion[
  $r = p \/ (1 + e cos nu)$ con $p = h^2 \/ mu$ (Curtis la escribe con
  $theta$ en lugar de $nu$; Bate usa $nu$). La altura se mide desde la
  superficie: $r = R_T + z$.
]

#idea[
  La ecuación de la órbita tiene dos incógnitas de forma, $p$ y $e$. Dos
  puntos medidos (radio y anomalía) dan dos ecuaciones: alcanza. Con $p$ y
  $e$ sale todo lo demás.
]

#paso(1, [$e$ y $p$])
$r_1 = 7278$ km en $nu_1 = 45°$ y $r_2 = 10 thin 878$ km en $nu_2 = 150°$.
Igualando $p$ de los dos puntos:
$ r_1 (1 + e cos 45°) = r_2 (1 + e cos 150°) quad arrow.r.double quad e = (r_2 - r_1) / (r_1 cos 45° - r_2 cos 150°) = 3600 / (5146 + 9421) = 0,2471. $
$p = r_1 (1 + e cos 45°) = 8550$ km.

#paso(2, [ábsides, semieje, período])
$r_p = p \/ (1 + e) = 6856$ km ($478$ km de altura),
$r_a = p\/(1 - e) = 11 thin 356$ km ($4978$ km), $a = p \/ (1 - e^2) = 9106$ km,
$T = 2 pi sqrt(a^3\/mu) = 144,1$ min.

#paso(3, [el primer punto])
$h = sqrt(mu p) = 58 thin 378$ km²/s. En el punto 1:
$v_perp = h \/ r_1 = 8,021$ km/s, $v_r = (mu\/h) e sin 45° = 1,193$ km/s,
$v = 8,109$ km/s y $gamma = arctan(v_r\/v_perp) = 8,46°$ (se aleja).

#paso(4, [la atmósfera])
El perigeo está a $478$ km: por encima de la atmósfera que frena de verdad
(unos $100$–$200$ km). No la roza, aunque a esa altura hay un arrastre
chiquito que a lo largo de años baja la órbita.

#camino[
  Dos ecuaciones de la órbita, restadas para sacar $e$; es el Adicional 4 de
  la guía con otros números.
]

#alternativa([la rapidez del punto 1 por vis-viva])[
  Con $a = 9106$ km, $v_1 = sqrt(mu (2\/r_1 - 1\/a)) = 8,109$ km/s, sin
  descomponer. Y el perigeo también por la energía:
  $v_p = sqrt(mu(2\/r_p - 1\/a)) = 8,515$ km/s $= h\/r_p$. Los dos caminos
  coinciden porque la vis-viva y la ecuación de la órbita salen de las
  mismas dos conservaciones.
]

#final[$e = 0,2471$, $p = 8550$ km; $r_p = 6856$ km ($478$ km), $r_a = 11 thin 356$ km ($4978$ km), $a = 9106$ km, $T = 144,1$ min; $h = 58 thin 378$ km²/s; en el punto 1, $v = 8,109$ km/s y $gamma = 8,46°$. No roza la atmósfera.]

== Ejercicio 5 — alcanzar la estación

#notacion[
  $n = sqrt(mu \/ r^3)$ es el *movimiento medio*: la velocidad angular de
  una órbita circular ($2 pi \/ T$). $phi.alt$ es el ángulo que la estación
  le lleva de ventaja a la nave. La guía llama a esta maniobra *rendez-vous*
  y a la espera, *phasing*.
]

#idea[
  No alcanza con llegar a la órbita de la estación: hay que llegar *donde
  está la estación*. La nave tarda media elipse en subir; en ese tiempo la
  estación avanza un ángulo. Entonces, al encender, la estación tiene que
  estar adelantada justo lo que le falta para llegar al punto de encuentro
  al mismo tiempo que la nave.
]

#paso(1, [la transferencia])
$r_1 = 6628$ km, $r_2 = 6798$ km, $a_T = 6713$ km. Vis-viva:
$v_(c 1) = 7,755$, $v_p = 7,804$, $v_a = 7,609$, $v_(c 2) = 7,657$ km/s.
$Delta v_1 = 48,9$ m/s, $Delta v_2 = 48,6$ m/s, total $97,6$ m/s. Tiempo:
$t_T = pi sqrt(a_T^3\/mu) = 45,6$ min.

#paso(2, [el ángulo de fase])
En $45,6$ min la estación (período $92,97$ min) recorre
$360° dot 45,6 \/ 92,97 = 176,6°$. La nave recorre $180°$. Entonces la
estación tiene que ir adelante $phi.alt = 180° - 176,6° = 3,37°$.

#paso(3, [la espera])
La nave, más baja, es más rápida: período $89,50$ min. Cada minuto le
descuenta a la estación $360\/89,50 - 360\/92,97 = 0,1499°$. Para pasar de
$40°$ a $3,37°$:
$t = (40 - 3,37)\/0,1499 = 244$ min $= 4,07$ h.

#paso(4, [si la estación va $2°$ adelante])
Ya está *atrasada* respecto de lo que hace falta ($2° < 3,37°$), y la nave
la sigue alcanzando: hay que esperar casi una vuelta relativa entera,
$(360 - 1,37)\/0,1499$ min $approx 39,9$ h. Para no esperar, se usa una
*órbita de fasaje*: la nave sube primero a una órbita más alta y lenta que la
de la estación (o hace una transferencia más lenta que Hohmann) para dejarse
adelantar lo que haga falta, a costa de más $Delta v$. Es el Problema 10 de
la guía.

#camino[
  Tiempo de la transferencia por Kepler, ángulo recorrido por la estación con
  su movimiento medio, y espera con la velocidad angular *relativa*.
]

#alternativa([la espera con el período sinódico])[
  El tiempo que tarda la nave en sacarle una vuelta entera a la estación es
  el período sinódico, $T_"sin" = (1\/T_1 - 1\/T_2)^(-1) = 40,0$ h. La espera
  es la fracción de vuelta que falta: $(40 - 3,37)\/360$ de $T_"sin"$, o sea
  $4,07$ h. Lo mismo, con la fórmula que se usa para planetas.
]

#final[$Delta v_1 = 48,9$ m/s, $Delta v_2 = 48,6$ m/s ($97,6$ m/s); $t_T = 45,6$ min; $phi.alt = 3,37°$; esperar $4,07$ h (con $2°$ serían unas $39,9$ h: conviene una órbita de fasaje).]

== Ejercicio 6 — el giróscopo del telescopio

#notacion[
  $bold(L)$ momento angular (guía: *impulso angular*; Beer: $bold(H)$),
  $bold(tau) = bold(r) times bold(F)$ torque (Sears: *torca*),
  $omega$ velocidad angular del giro propio y $Omega$ la de precesión. Para
  un cilindro de pared delgada, $I = m R^2$ (Sears, Tabla 9.2). Sears §10.7:
  $Omega = tau \/ L$, «una primera aproximación» según la cátedra: vale si el
  giro propio es mucho más rápido que la precesión.
]

#idea[
  Un torque *perpendicular* a $bold(L)$ no lo agranda ni lo achica: lo hace
  *girar*. Como $dif bold(L) = bold(tau) dif t$ es perpendicular a $bold(L)$, la
  punta de $bold(L)$ se mueve de costado y describe un círculo. Es exactamente
  lo que pasa con la velocidad de un satélite en órbita circular: la gravedad,
  perpendicular a $bold(v)$, cambia su dirección y no su módulo. Por eso el
  satélite no cae y el giróscopo tampoco: los dos «caen» de costado todo el
  tiempo.
]

#paso(1, [inercia y momento angular])
$I = m R^2 = 2,0 dot 0,025^2 = 1,25 times 10^(-3)$ kg·m²;
$omega = 19 thin 200 dot 2 pi\/60 = 2011$ rad/s;
$L = I omega = 2,513$ kg·m²/s.

#paso(2, [el torque del telescopio])
$Omega = (1,0 times 10^(-6) dot pi\/180) \/ (5,0 dot 3600) = 9,70 times 10^(-13)$ rad/s
y $tau = Omega L = 2,44 times 10^(-12)$ N·m. Es un torque ridículamente chico:
por eso el giróscopo sirve para mantener la orientación — cuesta mucho
moverlo.

#paso(3, [en el pivote])
Verticalmente no se mueve, así que el pivote hace $N = m g = 2,3 dot 9,81 = 22,56$ N
hacia arriba. El peso hace torque respecto del pivote:
$tau = d m g = 0,040 dot 22,56 = 0,9025$ N·m, *horizontal* y perpendicular al
eje. Precesión: $Omega = tau \/ L = 0,3591$ rad/s, una vuelta cada
$17,5$ s.

#fp.fig-giroscopo-p(respuesta: true)

Con $x$ hacia la derecha (del pivote al rotor), $z$ hacia arriba e $y$
entrando en la hoja: el giro propio antihorario visto desde la derecha da
$bold(L)$ en $+x$ (regla de la mano derecha). El torque es
$bold(tau) = bold(d) times m bold(g) = (d hat(x)) times (-m g hat(z)) = +d m g hat(y)$:
entra en la hoja. $bold(L)$ se va hacia donde apunta $bold(tau)$, así que el
eje gira *hacia adentro de la hoja*: vista desde arriba, la precesión es
antihoraria.

#paso(4, [por qué no se cae])
El peso «quiere» bajar la punta del eje, pero lo que hace es cambiarle a
$bold(L)$ la dirección de costado: $dif bold(L)$ es horizontal. Igual que en
la órbita: la gravedad quiere acercar el satélite a la Tierra, pero como es
perpendicular a la velocidad, sólo la dobla. La tabla de la analogía:
$dif bold(L)\/dif t = bold(tau)$ con $bold(tau) perp bold(L)$ y
$Omega = tau\/L$, contra $dif bold(p)\/dif t = bold(F)$ con
$bold(F) perp bold(p)$ y $omega_"órbita" = F\/p = v\/r$.

#camino[
  Precesión como el vector $bold(L)$ girando con $abs(dif bold(L)) = tau dif t$,
  que es la «primera aproximación» del Sears: es lo que pide la lista de
  temas para este parcial.
]

#alternativa([el ángulo que barre $bold(L)$])[
  En un $dif t$ la punta de $bold(L)$ se corre $tau dif t$ de costado, y el
  ángulo que gira el eje es $dif phi = tau dif t \/ L$. Integrando a $tau$
  constante, $Delta phi = tau Delta t \/ L$: para el telescopio,
  $tau = L Delta phi \/ Delta t = 2,513 dot 1,745 times 10^(-8) \/ 18 thin 000 = 2,44 times 10^(-12)$ N·m.
  Lo mismo sin pasar por $Omega$: es el *impulso angular*
  $integral bold(tau) dif t$ que hace falta para correr el momento angular
  ese ángulo.
]

#final[$I = 1,25 times 10^(-3)$ kg·m², $L = 2,513$ kg·m²/s; $tau = 2,44 times 10^(-12)$ N·m; en el pivote $N = 22,56$ N, $tau = 0,9025$ N·m, $Omega = 0,3591$ rad/s (vuelta en $17,5$ s), antihoraria desde arriba.]

== Ejercicio 7 — la segunda ley de Kepler

#notacion[
  *Velocidad areolar*: $dif A \/ dif t$, el área que barre el radio vector
  por unidad de tiempo. $bold(L) = bold(r) times m bold(v)$ es el momento
  angular respecto del centro de fuerzas (la guía lo llama *impulso angular*; Beer: $bold(H)_O$, y por
  unidad de masa $h$).
]

#idea[
  En un tiempito $dif t$ el radio barre un triángulo finito de lados
  $bold(r)$ y $dif bold(r) = bold(v) dif t$. El área de un triángulo es la
  mitad del producto vectorial de dos lados: aparece $bold(r) times bold(v)$,
  que es el momento angular por unidad de masa.
]

#paso(1, [la equivalencia])
$ dif A = 1/2 abs(bold(r) times dif bold(r)) = 1/2 abs(bold(r) times bold(v)) dif t quad arrow.r.double quad (dif A) / (dif t) = abs(bold(L)) / (2 m) = h / 2. $
«Barre áreas iguales en tiempos iguales» es $dif A\/dif t$ constante, que es
$abs(bold(L))$ constante. Y como además el plano de la órbita es fijo (el de
$bold(r)$ y $bold(v)$, perpendicular a $bold(L)$), la segunda ley junto con la
órbita plana es exactamente la conservación del *vector* $bold(L)$.

#paso(2, [la pregunta fina])
$dif bold(L)\/dif t = bold(r) times bold(F)$. Para que sea cero *alcanza* con
que $bold(F)$ sea paralela a $bold(r)$: fuerza central. No importa cómo
dependa del radio — $1\/r^2$, $r$, lo que sea —. La forma $1\/r^2$ es la que
decide que la órbita sea una *cónica* (primera ley) y la relación entre
período y tamaño (tercera ley), pero la segunda ley es de cualquier fuerza
central.

#camino[
  Área como medio producto vectorial y derivada de $bold(L)$: la
  demostración de dos renglones de los libros (Beer §12.9, Sears §13.5).
]

#alternativa([la de Newton, con triángulos])[
  Newton (*Principia*, Proposición 1) lo hizo sin derivadas: sin fuerza, en
  dos intervalos iguales el cuerpo recorre $A B$ y $B C$ iguales, y los
  triángulos $S A B$ y $S B C$ tienen igual base y la misma altura desde $S$:
  igual área. Si en $B$ recibe un golpe dirigido hacia $S$, el punto $C$ se
  corre paralelo a $S B$, y el triángulo $S B C'$ conserva la base $S B$ y la
  altura: igual área. Haciendo los golpes cada vez más seguidos se obtiene una
  fuerza central continua, y las áreas siguen iguales. En ningún momento hizo
  falta saber *cuánto* valía el golpe: sólo que apuntara a $S$.
]

#final[$dif A \/ dif t = abs(bold(L))\/(2 m) = h\/2$: la segunda ley es la conservación del momento angular. Alcanza con que la fuerza sea central; el $1\/r^2$ no hace falta.]
