// =====================================================================
//  Modelo de parcial integrador -- sobre el apunte entero
//  Cada ejercicio cruza al menos dos partes del apunte. Cada numero de la
//  resolucion tiene su cuenta en validar.py (c_parciales, clave 'modelo').
//  Revisado el 2026-09-29: figuras, notacion por tema, caminos alternativos.
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp

#show: documento.with(
  titulo: [Modelo de parcial integrador],
  subtitulo: [Cohetes, órbitas, momento angular y cuerpo rígido — sobre el apunte completo],
  encabezado: [Modelo de parcial integrador],
)

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Tiempo: *3 horas*. Hoja de fórmulas propia y calculadora. Cada ejercicio vale
  $2,5$ puntos y cada uno pide herramientas de más de un módulo del apunte:
  decir en cada paso *qué se conserva y por qué* vale tanto como el número.
  Datos: $mu_T = 398 thin 600$ km³/s², $R_T = 6378$ km, $g_0 = 9,81$ m/s².
  *Nombres:* $bold(L)$ o $bold(H)$ es el *momento angular* (la guía lo llama
  *impulso angular*); el impulso angular propiamente dicho es
  $integral bold(tau) dif t = Delta bold(L)$.
]

#caja([Ojo con el Ejercicio 3], c-rojo)[
  Es de *cuerpo rígido en tres dimensiones* (precesión libre, Beer §18.11).
  En el plan de la cátedra ese tema va en la *segunda* evaluación (semanas 11
  a 14); los Modelos 1 a 3 no lo tocan. Si en clase no llegaron a verlo,
  saltéelo para el parcial del jueves.
]

#mapa(
  ([1], [cohete (Tsiolkovsky) + Hohmann + Kepler], [Problema 5 de gravitación y Ej. 5 de cantidad de movimiento]),
  ([2], [parámetros orbitales desde un estado], [Adicionales 2 y 5 de gravitación]),
  ([3], [impulso angular de un propulsor + tensor de inercia + precesión libre], [Problemas 7 y 8 de cuerpo rígido (la cápsula que se enciende)]),
  ([4], [conservación del momento angular + energía (el yo-yo)], [la conservación de $L$ (Sears §10.6) y el yo-yo de *despin* de los satélites]),
)

#ejercicio(1, [del estacionamiento a la geoestacionaria], [2,5])
#origen[Cantidad de movimiento (cohete) + energía + Kepler.]

Un satélite de $1500$ kg (masa seca, sin propelente) está en una órbita
circular de estacionamiento a $300$ km de altura, y hay que llevarlo a la
geoestacionaria ($r = 42 thin 164$ km) con una transferencia de Hohmann. El
motor tiene $I_"sp" = 320$ s.

#fp.fig-hohmann-p(0.9, 2.7, rot1: [300 km], rot2: [geoestacionaria])
#align(center, text(size: 8.5pt, fill: luma(90))[Radios sin escala.])

+ Calcule la velocidad en la órbita inicial, en el perigeo y en el apogeo de la
  elipse de transferencia, y en la órbita final.
+ Calcule los dos $Delta v$ y el total. ¿En qué sentido se enciende el motor
  en cada caso?
+ ¿Cuánta masa tiene que tener el satélite, con el propelente, antes del
  primer encendido? ¿Cuánta masa tiene entre los dos encendidos?
+ ¿Cuánto dura la transferencia?

#ejercicio(2, [una órbita a partir de un estado], [2,5])
#origen[Momento angular + energía + ecuación de la órbita.]

Un radar mide un satélite a $r = 7500$ km del centro de la Tierra, con rapidez
$v = 8,2$ km/s y ángulo de trayectoria de vuelo $gamma = 5°$, alejándose de la
Tierra.

#fp.fig-orbita-p(0.278, 2.5, puntos: ((anom: 23.3, vel: true, gam: 5, gam-dib: 18, rot: [medición], desp: (0.15, 0), ancla: "west"),))

+ Calcule el momento angular específico $h$ y la energía específica $epsilon$.
+ Calcule el semieje mayor, la excentricidad y la anomalía verdadera del punto
  medido.
+ Calcule los radios y las alturas del perigeo y del apogeo. ¿Corre riesgo
  de rozar la atmósfera?
+ Calcule el período.

#ejercicio(3, [el cilindro que empieza a precesar], [2,5])
#origen[Impulso angular ($integral bold(tau) dif t$) + tensor de inercia + movimiento libre de torques.]

Un satélite cilíndrico macizo de $800$ kg, radio $R = 1,0$ m y altura $3,0$ m
gira libre en el espacio a $omega_0 = 2,0$ rad/s alrededor de su eje de
simetría $z$. Un propulsor montado en el borde, en $x = R$, empuja paralelo al
eje $z$ con $100$ N durante $1,5$ s.

#fp.fig-cilindro-propulsor

+ Calcule los momentos de inercia axial y transversal respecto del centro de
  masa.
+ Calcule el impulso angular que entrega el propulsor —el cambio de momento
  angular que produce— y el momento angular después del encendido: módulo y
  ángulo con el eje $z$.
+ Calcule la velocidad angular después del encendido y su ángulo con el eje.
+ Calcule la velocidad de precesión y la de spin. ¿La precesión es directa o
  retrógrada? ¿Por qué?
+ ¿Cuánto cambió la energía cinética de rotación?

#ejercicio(4, [el yo-yo que frena al satélite], [2,5])
#origen[Conservación del momento angular + energía + impulso angular.]

Un satélite cilíndrico, con momento de inercia $I = 40$ kg·m² respecto de su
eje, gira a $60$ rpm. Lleva dos masas de $1$ kg a $0,5$ m del eje, que se
sueltan a la vez sobre cables radiales hasta quedar a $3,0$ m del eje. No hay
torques externos.

#fp.fig-yoyo

+ Calcule la velocidad angular final, en rad/s y en rpm.
+ Compare la energía cinética de rotación antes y después. ¿A dónde fue la
  diferencia?
+ Calcule el impulso angular que los cables le hacen al cuerpo del satélite,
  es decir, cuánto le cambian el momento angular. ¿Cuánto les hacen a las
  masas?

#pagebreak()

= Resolución

== Ejercicio 1 — del estacionamiento a la geoestacionaria

#notacion[
  $mu$ es $G M_T$; en el cohete, el mismo símbolo es el caudal (Roederer) y
  la velocidad de los gases es $v_e = I_"sp" g_0$ (la $v_r$ del apunte;
  Sears: $v_"esc"$; Beer: $u$). $a_T$ es el semieje de la transferencia.
]

#idea[
  Media elipse tangente a las dos órbitas: el primer encendido estira el
  apogeo hasta la geoestacionaria, el segundo levanta el perigeo hasta ella.
  El propelente sale de Tsiolkovsky, que no necesita saber *dónde* se
  enciende, sólo cuánto $Delta v$ se pide: las razones de masas de dos
  encendidos se multiplican.
]

#paso(1, [las velocidades])
$r_1 = 6378 + 300 = 6678$ km, $r_2 = 42 thin 164$ km,
$a_T = (r_1 + r_2)\/2 = 24 thin 421$ km. Con la vis-viva
$v^2 = mu (2\/r - 1\/a)$: circular inicial $v_1 = sqrt(mu\/r_1) = 7,726$ km/s;
perigeo de la transferencia $10,152$ km/s; apogeo de la transferencia
$1,608$ km/s; circular final $v_2 = 3,075$ km/s.

#paso(2, [los $Delta v$])
$Delta v_1 = 10,152 - 7,726 = 2,426$ km/s y
$Delta v_2 = 3,075 - 1,608 = 1,467$ km/s; total $3,893$ km/s. Los dos
encendidos van *en el sentido del movimiento*: el primero estira el apogeo
hasta $r_2$ y el segundo levanta el perigeo hasta $r_2$.

#paso(3, [la masa])
$v_e = I_"sp" g_0 = 3,139$ km/s. Tsiolkovsky, aplicado a los dos encendidos
juntos porque las razones de masas se multiplican:
$m_0 = 1500 thin e^(3,893\/3,139) = 5183$ kg, o sea $3683$ kg de propelente.
Entre los dos encendidos queda $1500 thin e^(1,467\/3,139) = 2393$ kg.

#paso(4, [el tiempo])
Media elipse: $t = pi sqrt(a_T^3\/mu) = 5,28$ h.

#camino[
  Vis-viva punto por punto y Tsiolkovsky con el $Delta v$ total.
]

#alternativa([encendido por encendido])[
  Hacia atrás desde el final: antes del segundo encendido la masa es
  $1500 e^(1,467\/3,139) = 2393$ kg; antes del primero,
  $2393 e^(2,426\/3,139) = 5183$ kg. El primero quema $2790$ kg y el segundo
  $893$ kg: el grueso del propelente se va en el primero, porque todavía
  arrastra el del segundo. Y para las velocidades de la transferencia, en
  lugar de la vis-viva, las dos conservaciones entre perigeo y apogeo
  ($r_1 v_p = r_2 v_a$ y la energía) dan
  $v_p = sqrt(2 mu r_2 \/ (r_1 (r_1 + r_2))) = 10,152$ km/s: lo mismo.
]

#final[$7,726 arrow.r 10,152$ y $1,608 arrow.r 3,075$ km/s; $Delta v = 2,426 + 1,467 = 3,893$ km/s; $m_0 = 5183$ kg ($3683$ kg de propelente), $2393$ kg entre encendidos; $5,28$ h.]

== Ejercicio 2 — una órbita a partir de un estado

#notacion[
  $h$ momento angular específico, $epsilon$ energía específica, $nu$
  anomalía verdadera (Curtis y Beer: $theta$), $gamma$ ángulo de trayectoria
  de vuelo (entre $bold(v)$ y la horizontal local).
]

#idea[
  $r$, $v$ y $gamma$ fijan las dos constantes de la órbita ($h$ y $epsilon$),
  y con ellas la cónica. El signo de $gamma$ (se aleja) dice de qué lado del
  perigeo está el punto.
]

#paso(1, [$h$ y $epsilon$])
Se separa la velocidad: $v_perp = v cos gamma$ y $v_r = v sin gamma$.
$h = r v cos gamma = 7500 dot 8,2 cos 5° = 61 thin 266$ km²/s;
$epsilon = v^2\/2 - mu\/r = -19,527$ km²/s² (negativa: órbita cerrada).

#paso(2, [$a$, $e$, $nu$])
$a = -mu\/(2 epsilon) = 10 thin 207$ km. De la ecuación de la órbita y de
$v_r = (mu\/h) e sin nu$: $e cos nu = h^2\/(mu r) - 1 = 0,2556$ y
$e sin nu = v_r h\/mu = 0,1098$. Entonces $e = 0,2782$ y $nu = 23,3°$
(primer cuadrante: pasó hace poco por el perigeo y se aleja).

#paso(3, [ábsides])
$r_p = a(1 - e) = 7367$ km, a $989$ km de altura;
$r_a = a(1 + e) = 13 thin 046$ km, a $6668$ km de altura. El perigeo está
muy por encima de la atmósfera sensible: no la roza.

#paso(4, [período])
$T = 2 pi sqrt(a^3\/mu) = 171,0$ min.

#camino[
  Componentes de la excentricidad, que dan $e$ y el cuadrante de $nu$ a la
  vez.
]

#alternativa([$e$ desde la energía])[
  $e = sqrt(1 + 2 epsilon h^2\/mu^2)$ da el mismo $0,2782$ en un renglón,
  pero para $nu$ deja la ambigüedad $plus.minus 23,3°$: la resuelve el signo
  de $v_r$. Y el perigeo sale también de $r_p = (h^2\/mu)\/(1 + e)$, sin pasar
  por $a$.
]

#final[$h = 61 thin 266$ km²/s, $epsilon = -19,527$ km²/s²; $a = 10 thin 207$ km, $e = 0,2782$, $nu = 23,3°$; perigeo $7367$ km ($989$ km), apogeo $13 thin 046$ km ($6668$ km); $T = 171,0$ min.]

== Ejercicio 3 — el cilindro que empieza a precesar

#notacion[
  En cuerpo rígido el apunte pasa a la letra del Beer: $bold(H)_G$ es el
  momento angular respecto del centro de masa (el $bold(L)$ de los módulos
  anteriores; la guía: *impulso angular*), $bold(M)$ o $bold(tau)$ el torque,
  $I_z = I'$ el momento de inercia *axial* e $I_x = I$ el *transversal*
  (Curtis: $C$ y $A$). $dot(phi)$ es la precesión y $dot(psi)$ el spin
  (ángulos de Euler). El *impulso angular* es $integral bold(tau) dif t = Delta bold(H)$.
]

#idea[
  El propulsor hace un torque perpendicular al eje durante un rato corto: le
  suma a $bold(H)$ un pedacito de costado. Después no hay torque y $bold(H)$
  queda fijo en el espacio, pero *inclinado* respecto del eje del cuerpo. Un
  cuerpo simétrico con $bold(H)$ inclinado no gira alrededor de $bold(H)$ sino
  que su eje da vueltas alrededor de él: precesión libre. Si es directa o
  retrógrada depende sólo de si es alargado o achatado.
]

#paso(1, [momentos de inercia])
Cilindro macizo: $I_z = 1/2 m R^2 = 400$ kg·m² y
$I_x = m(3 R^2 + h^2)\/12 = 800$ kg·m², así que $I_z = 400$ e $I_x = 800$:
es un cuerpo *alargado*.

#paso(2, [el impulso angular y $bold(H)$])
$bold(tau) = bold(r) times bold(F) = (R, 0, z) times (0, 0, F) = (0, -R F, 0)$:
el impulso angular es $integral bold(tau) dif t = bold(tau) thin Delta t = (0; -150; 0)$
kg·m²/s. Antes había $I_z omega_0 = 800$ kg·m²/s sobre $z$, así que
$bold(H) = (0; -150; 800)$ kg·m²/s, $abs(bold(H)) = 813,9$ kg·m²/s, a
$arctan(150\/800) = 10,62°$ del eje.

#paso(3, [la velocidad angular])
Componente a componente en los ejes principales, $omega_i = H_i \/ I_i$:
$omega_x = 0$, $omega_y = -150\/800 = -0,1875$ rad/s, $omega_z = 2,0$ rad/s
(el encendido no toca la componente axial). Ángulo con el eje:
$arctan(0,1875\/2) = 5,36°$, *menor* que el de $bold(H)$ porque $I_z < I_x$.

#paso(4, [precesión y spin])
Precesión $dot(phi) = abs(bold(H))\/I_x = 1,017$ rad/s; spin
$dot(psi) = omega_z (I_x - I_z)\/I_x = 1,000$ rad/s. Los dos del mismo signo:
*directa*, porque el cuerpo es alargado ($I_z < I_x$).

#paso(5, [la energía])
Antes $T = 1/2 I_z omega_0^2$; después se suma $1/2 I_x omega_y^2$:
$Delta T = 14,06$ J, que es el trabajo del propulsor.

#camino[
  $bold(H)$ por componentes en los ejes principales (donde el tensor de
  inercia es diagonal) y las fórmulas de la peonza libre del Beer (§18.11).
]

#alternativa([el spin desde la suma de velocidades angulares])[
  $bold(omega) = dot(phi) hat(bold(H)) + dot(psi) hat(bold(z))$: proyectando
  sobre el eje, $omega_z = dot(phi) cos theta + dot(psi)$ con
  $cos theta = 800\/813,9$. Entonces
  $dot(psi) = 2,0 - 1,017 dot 0,9829 = 1,000$ rad/s: el mismo spin, sin la
  fórmula de la peonza. Y la energía desde $bold(H)$:
  $T = H_z^2\/(2 I_z) + H_y^2 \/(2 I_x) = 800 + 14,06$ J.
]

#final[$I_z = 400$, $I_x = 800$ kg·m² (alargado); $bold(H) = (0; -150; 800)$, $813,9$ kg·m²/s a $10,62°$; $bold(omega) = (0; -0,1875; 2,0)$ rad/s a $5,36°$; $dot(phi) = 1,017$, $dot(psi) = 1,000$ rad/s, directa; $Delta T = 14,06$ J.]

== Ejercicio 4 — el yo-yo que frena al satélite

#notacion[
  $L = I omega$ es el momento angular para rotación alrededor de un eje fijo (Sears §10.5; la
  guía: *impulso angular*; Beer: $H$). Una masa puntual a distancia $r$ del
  eje aporta $m r^2$ al momento de inercia. El impulso angular sobre un
  cuerpo es su $Delta L$.
]

#idea[
  Los cables son internos: el momento angular total no cambia. Al alejarse
  las masas, el momento de inercia sube y la velocidad angular tiene que
  bajar. La energía cinética, $K = L^2 \/ (2 I)$ con $L$ fijo, baja: la
  diferencia se la come el mecanismo que frena a las masas.
]

#paso(1, [la velocidad angular final])
$I_0 = 40 + 2 dot 1 dot 0,5^2 = 40,50$ kg·m² e $I_1 = 40 + 2 dot 1 dot 3,0^2 = 58$ kg·m².
Sin torque externo el momento angular se conserva:
$omega_1 = omega_0 I_0\/I_1$, con $omega_0 = 6,283$ rad/s, da
$omega_1 = 4,387$ rad/s $= 41,9$ rpm.

#paso(2, [la energía])
$K_0 = 1/2 I_0 omega_0^2 = 799,4$ J y $K_1 = 1/2 I_1 omega_1^2 = 558,2$ J: se
pierde el $30,2$ % (con $L$ constante, $K = L^2\/(2 I)$ baja cuando $I$ sube).
La diferencia se disipa en el mecanismo que frena a las masas al final del
recorrido.

#paso(3, [los impulsos angulares])
El impulso angular sobre el cuerpo es su cambio de momento angular:
$40 (omega_1 - omega_0) = -75,8$ N·m·s (lo frena). Sobre las masas, el
mismo valor con el signo cambiado: el total no cambia, que es exactamente lo
que dice la conservación.

#camino[
  Conservación de $L$ del sistema completo (cuerpo + masas) y energía antes y
  después.
]

#alternativa([el impulso sobre las masas, directo])[
  Las masas pasan de $2 dot 1 dot 0,5^2 dot 6,283 = 3,14$ a
  $2 dot 1 dot 3,0^2 dot 4,387 = 78,97$ kg·m²/s: ganan $75,8$ kg·m²/s, lo que
  perdió el cuerpo. Y la energía con $K = L^2\/(2 I)$ y $L = 254,5$ kg·m²/s:
  $254,5^2\/(2 dot 40,50) = 799,4$ J y $254,5^2\/(2 dot 58) = 558,2$ J.
]

#final[$omega_1 = 4,387$ rad/s ($41,9$ rpm); $K$: $799,4 arrow.r 558,2$ J ($-30,2$ %); impulso angular (cambio de momento angular) sobre el cuerpo $-75,8$ N·m·s, sobre las masas $+75,8$.]
