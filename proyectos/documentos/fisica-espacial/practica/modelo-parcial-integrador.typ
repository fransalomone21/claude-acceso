// =====================================================================
//  Modelo de parcial integrador -- sobre el apunte entero
//  Cada ejercicio cruza al menos dos partes del apunte. Cada numero de la
//  resolucion tiene su cuenta en validar.py.
// =====================================================================
#import "estilo.typ": *

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
  *Nombres:* $bold(L)$ o $bold(H)$ es el *momento angular*; el *impulso
  angular* es $integral bold(tau) dif t = Delta bold(L)$.
]

== Ejercicio 1 — del estacionamiento a la geoestacionaria #h(1fr) #text(size: 10pt, weight: "regular")[(2,5 puntos)]

_Cantidad de movimiento (cohete) + energía + Kepler._ Un satélite de $1500$ kg
(masa seca, sin propelente) está en una órbita circular de estacionamiento a
$300$ km de altura, y hay que llevarlo a la geoestacionaria ($r = 42 thin 164$ km)
con una transferencia de Hohmann. El motor tiene $I_"sp" = 320$ s.

+ Calcule la velocidad en la órbita inicial, en el perigeo y en el apogeo de la
  elipse de transferencia, y en la órbita final.
+ Calcule los dos $Delta v$ y el total. ¿En qué sentido se enciende el motor
  en cada caso?
+ ¿Cuánta masa tiene que tener el satélite, con el propelente, antes del
  primer encendido? ¿Cuánta masa tiene entre los dos encendidos?
+ ¿Cuánto dura la transferencia?

== Ejercicio 2 — una órbita a partir de un estado #h(1fr) #text(size: 10pt, weight: "regular")[(2,5 puntos)]

_Momento angular + energía + ecuación de la órbita._ Un radar mide un satélite a
$r = 7500$ km del centro de la Tierra, con rapidez $v = 8,2$ km/s y ángulo de
trayectoria de vuelo $gamma = 5°$, alejándose de la Tierra.

+ Calcule el momento angular específico $h$ y la energía específica $epsilon$.
+ Calcule el semieje mayor, la excentricidad y la anomalía verdadera del punto
  medido.
+ Calcule los radios y las alturas del perigeo y del apogeo. ¿Corre riesgo
  de rozar la atmósfera?
+ Calcule el período.

== Ejercicio 3 — el cilindro que empieza a precesar #h(1fr) #text(size: 10pt, weight: "regular")[(2,5 puntos)]

_Impulso angular ($integral bold(tau) dif t$) + tensor de inercia + movimiento libre de torques._ Un
satélite cilíndrico macizo de $800$ kg, radio $R = 1,0$ m y altura $3,0$ m gira
libre en el espacio a $omega_0 = 2,0$ rad/s alrededor de su eje de simetría $z$.
Un propulsor montado en el borde, en $x = R$, empuja paralelo al eje $z$ con
$100$ N durante $1,5$ s.

+ Calcule los momentos de inercia axial y transversal respecto del centro de
  masa.
+ Calcule el impulso angular que entrega el propulsor —el cambio de momento
  angular que produce— y el momento angular después del encendido: módulo y
  ángulo con el eje $z$.
+ Calcule la velocidad angular después del encendido y su ángulo con el eje.
+ Calcule la velocidad de precesión y la de spin. ¿La precesión es directa o
  retrógrada? ¿Por qué?
+ ¿Cuánto cambió la energía cinética de rotación?

== Ejercicio 4 — el yo-yo que frena al satélite #h(1fr) #text(size: 10pt, weight: "regular")[(2,5 puntos)]

_Conservación del momento angular + energía + impulso angular._ Un satélite
cilíndrico, con momento de inercia $I = 40$ kg·m² respecto de su eje, gira a
$60$ rpm. Lleva dos masas de $1$ kg a $0,5$ m del eje, que se sueltan a la vez
sobre cables radiales hasta quedar a $3,0$ m del eje. No hay torques externos.

+ Calcule la velocidad angular final, en rad/s y en rpm.
+ Compare la energía cinética de rotación antes y después. ¿A dónde fue la
  diferencia?
+ Calcule el impulso angular que los cables le hacen al cuerpo del satélite,
  es decir, cuánto le cambian el momento angular. ¿Cuánto les hacen a las
  masas?

#pagebreak()

= Resolución

== Ejercicio 1

$r_1 = 6378 + 300 = 6678$ km, $r_2 = 42 thin 164$ km,
$a_T = (r_1 + r_2)\/2 = 24 thin 421$ km. Las velocidades salen de la vis-viva
$v^2 = mu (2\/r - 1\/a)$:

+ Circular inicial $v_1 = sqrt(mu\/r_1) = 7,726$ km/s; perigeo de la
  transferencia $10,152$ km/s; apogeo de la transferencia $1,608$ km/s;
  circular final $v_2 = 3,075$ km/s.
+ $Delta v_1 = 10,152 - 7,726 = 2,426$ km/s y $Delta v_2 = 3,075 - 1,608 =
  1,467$ km/s; total $3,893$ km/s. Los dos encendidos van *en el sentido del
  movimiento*: el primero estira el apogeo hasta $r_2$ y el segundo levanta el
  perigeo hasta $r_2$.
+ $v_e = I_"sp" g_0 = 3,139$ km/s. Tsiolkovsky, aplicado a los dos
  encendidos juntos porque las razones de masas se multiplican:
  $m_0 = 1500 thin e^(3,893\/3,139) = 5183$ kg, o sea $3683$ kg de propelente.
  Entre los dos encendidos queda $1500 thin e^(1,467\/3,139) = 2393$ kg.
+ Media elipse: $t = pi sqrt(a_T^3\/mu) = 5,28$ h.

== Ejercicio 2

Se separa la velocidad: $v_perp = v cos gamma$ y $v_r = v sin gamma$.

+ $h = r v cos gamma = 7500 dot 8,2 cos 5° = 61 thin 266$ km²/s;
  $epsilon = v^2\/2 - mu\/r = -19,527$ km²/s² (negativa: órbita cerrada).
+ $a = -mu\/(2 epsilon) = 10 thin 207$ km. De la ecuación de la órbita y de
  $v_r = (mu\/h) e sin nu$: $e cos nu = h^2\/(mu r) - 1 = 0,2556$ y
  $e sin nu = v_r h\/mu = 0,1098$. Entonces $e = 0,2782$ y $nu = 23,3°$
  (primer cuadrante: pasó hace poco por el perigeo y se aleja).
+ $r_p = a(1 - e) = 7367$ km, a $989$ km de altura; $r_a = a(1 + e) = 13 thin 046$ km,
  a $6668$ km de altura. El perigeo está muy por encima de la atmósfera
  sensible: no la roza.
+ $T = 2 pi sqrt(a^3\/mu) = 171,0$ min.

== Ejercicio 3

+ Cilindro macizo: $I_z = 1\/2 m R^2 = 400$ kg·m² y
  $I_x = m(3 R^2 + h^2)\/12 = 800$ kg·m², así que $I_z = 400$ e $I_x = 800$:
  es un cuerpo *alargado*.
+ $bold(tau) = bold(r) times bold(F) = (R, 0, z) times (0, 0, F) = (0, -R F, 0)$:
  el impulso angular es $integral bold(tau) dif t = bold(tau) thin Delta t = (0; -150; 0)$
  kg·m²/s. Antes había
  $I_z omega_0 = 800$ kg·m²/s sobre $z$, así que
  $bold(H) = (0; -150; 800)$ kg·m²/s, $abs(bold(H)) = 813,9$ kg·m²/s, a
  $arctan(150\/800) = 10,62°$ del eje.
+ $omega_x = 0$, $omega_y = -150\/800 = -0,1875$ rad/s, $omega_z = 2,0$ rad/s
  (el encendido no toca la componente axial). Ángulo con el eje:
  $arctan(0,1875\/2) = 5,36°$, *menor* que el de $bold(H)$ porque
  $I_z < I_x$.
+ Precesión $dot(phi) = abs(bold(H))\/I_x = 1,017$ rad/s; spin
  $dot(psi) = omega_z (I_x - I_z)\/I_x = 1,000$ rad/s. Los dos del mismo signo:
  *directa*, porque el cuerpo es alargado ($I_z < I_x$).
+ Antes $T = 1\/2 I_z omega_0^2$; después se suma $1\/2 I_x omega_y^2$:
  $Delta T = 14,06$ J, que es el trabajo del propulsor.

== Ejercicio 4

+ $I_0 = 40 + 2 dot 1 dot 0,5^2 = 40,50$ kg·m² e
  $I_1 = 40 + 2 dot 1 dot 3,0^2 = 58$ kg·m². Sin torque externo el momento
  angular se conserva: $omega_1 = omega_0 I_0\/I_1$, con $omega_0 = 6,283$
  rad/s, da $omega_1 = 4,387$ rad/s $= 41,9$ rpm.
+ $K_0 = 1\/2 I_0 omega_0^2 = 799,4$ J y $K_1 = 1\/2 I_1 omega_1^2 = 558,2$ J:
  se pierde el $30,2$ % (con $L$ constante, $K = L^2\/(2 I)$ baja cuando $I$
  sube). La diferencia se disipa en el mecanismo que frena a las masas al
  final del recorrido.
+ El impulso angular sobre el cuerpo es su cambio de momento angular:
  $40 (omega_1 - omega_0) = -75,8$ N·m·s (lo frena). Sobre las masas, el
  mismo valor con el signo cambiado: el total no cambia, que es exactamente lo
  que dice la conservación.
