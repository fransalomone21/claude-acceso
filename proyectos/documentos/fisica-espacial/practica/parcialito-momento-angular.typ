// =====================================================================
//  Parcialito -- conservacion del momento angular
//  Sobre la seccion «Conservacion impulso angular» de la guia (Probl. 1-7).
//  Cada numero de la resolucion tiene su cuenta en validar.py.
// =====================================================================
#import "estilo.typ": *

#show: documento.with(
  titulo: [Parcialito — Momento angular],
  subtitulo: [Modelo sobre la sección «Conservación impulso angular» de la guía (Problemas 1 a 7)],
  encabezado: [Parcialito — Momento angular],
)

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Tiempo: *60 minutos*. Se puede usar una hoja de fórmulas propia y calculadora.
  Justificar cada paso: un número sin planteo no suma. Datos: $mu_T = 398 thin 600$
  km³/s², $R_T = 6378$ km, $g = 9,8$ m/s². *Nombres:* $bold(L) = bold(r) times bold(p)$
  es el *momento angular*; el *impulso angular* es $integral bold(tau) dif t = Delta bold(L)$.
]

== Ejercicio 1 #h(1fr) #text(size: 10pt, weight: "regular")[(3 puntos)]

Dos partículas de masa $m = 2$ kg se mueven en el plano $x y$ con velocidad
constante. La 1 recorre la recta $y = 4$ m con $bold(v)_1 = 3 hat(i)$ m/s; la 2
recorre la recta $y = -2$ m con $bold(v)_2 = -3 hat(i)$ m/s.

+ Calcule el momento angular de la partícula 1 respecto del origen $O$ cuando
  pasa por $x = 0$ y cuando pasa por $x = 6$ m. ¿Por qué coinciden?
+ Calcule el momento angular de la partícula 1 respecto de $Q = (0, 1, 0)$ m.
  ¿Por qué cambia al cambiar el punto?
+ Calcule el momento angular *del sistema* respecto de $O$ y respecto de $Q$.
  Explique por qué ahora no depende del punto, y verifique el módulo con
  $m v d$.

== Ejercicio 2 #h(1fr) #text(size: 10pt, weight: "regular")[(4 puntos)]

Un satélite de $500$ kg describe una órbita elíptica con el perigeo a $600$ km
de altura y el apogeo a $2000$ km de altura. En el perigeo su rapidez es
$7,895$ km/s.

+ Calcule el momento angular específico $h$ (por unidad de masa) del satélite.
+ Usando *sólo* la conservación del momento angular, calcule la rapidez en el
  apogeo.
+ En un punto intermedio el radar mide una rapidez de $7,279$ km/s, con un
  ángulo de trayectoria de vuelo $gamma = 5,19°$ (el ángulo entre la
  velocidad y la horizontal local). ¿A qué distancia del centro de la Tierra
  está, y a qué altura?
+ En el apogeo se quiere pasar a la órbita circular de ese radio con un único
  encendido tangencial. ¿Qué impulso angular, respecto del centro de la
  Tierra, tiene que entregar el motor? ¿Por qué hace falta, si la gravedad no
  ejerce ningún torque?

== Ejercicio 3 #h(1fr) #text(size: 10pt, weight: "regular")[(3 puntos)]

El rotor de un giróscopo de juguete es un disco macizo de $0,200$ kg y $3,0$ cm
de radio, que gira a $3000$ rpm alrededor de su eje, horizontal. El giróscopo se
apoya en un pivote, con el centro de masa a $5,0$ cm del pivote sobre el eje;
la masa del marco es despreciable.

+ Calcule el momento de inercia y el momento angular del rotor.
+ Calcule el torque del peso respecto del pivote, la velocidad angular de
  precesión y su período. ¿Cuánto vale la fuerza que hace el pivote?
+ Dibuje $bold(L)$, $bold(tau)$ y el sentido de la precesión vistos desde arriba.
+ ¿Cuánto vale el impulso angular que el peso le entrega al rotor en un cuarto
  de vuelta de precesión? ¿Y en una vuelta completa? Explique por qué el
  segundo resultado no contradice que el torque nunca se anula.

#pagebreak()

= Resolución

== Ejercicio 1

$bold(p)_1 = m bold(v)_1 = 6 hat(i)$ kg·m/s y $bold(p)_2 = -6 hat(i)$ kg·m/s.
En el plano, $L_z = x p_y - y p_x$.

+ En $x = 0$: $bold(r) = (0, 4, 0)$ y $L_z = -4 dot 6 = -24$; en $x = 6$:
  $bold(r) = (6, 4, 0)$ y otra vez $L_z = 6 dot 0 - 4 dot 6 = -24$. Queda
  $bold(L)_1 = -24 hat(k)$ kg·m²/s en los dos: la partícula libre no tiene
  torque, y geométricamente $abs(bold(L)) = p d$ con $d = 4$ m la distancia fija
  de $O$ a su recta (Problema 2 de la guía).
+ Desde $Q$: $bold(r) - bold(r)_Q = (x, 3, 0)$, así que $L_z = -18$ kg·m²/s.
  Cambia porque la distancia a la recta ahora es $3$ m: el momento angular de
  *una* partícula depende del punto.
+ Partícula 2 desde $O$: $L_z = -(-2)(-6) = -12$; total $-24 - 12 = -36$.
  Desde $Q$: $-18 + (-(-3)(-6)) = -18 - 18 = -36$. Mismo resultado,
  $bold(L) = -36 hat(k)$ kg·m²/s, porque al mover el origen en $bold(a)$ el
  momento angular cambia en $-bold(a) times bold(P)$, y acá
  $bold(P) = 6 hat(i) - 6 hat(i) = bold(0)$ (Problema 3 de la guía). Control:
  $m v d = 2 dot 3 dot 6 = 36$, con $d = 6$ m entre las rectas.

== Ejercicio 2

$r_p = 6378 + 600 = 6978$ km y $r_a = 6378 + 2000 = 8378$ km.

+ En el perigeo la velocidad es perpendicular al radio: $h = r_p v_p =
  6978 dot 7,895 = 55 thin 091$ km²/s.
+ $h$ se conserva (fuerza central): $v_a = h\/r_a = 6,576$ km/s.
+ Sólo la componente perpendicular al radio aporta a $h$:
  $h = r v cos gamma$, así que $r = 55 thin 091\/(7,279 cos 5,19°) = 7600$ km, a
  $1222$ km de altura.
+ La circular de radio $r_a$ pide $v_c = sqrt(mu\/r_a) = 6,898$ km/s, es decir,
  $322$ m/s más. El impulso angular es el cambio de momento angular:
  $m r_a (v_c - v_a) = 500 dot 8,378 times 10^6 dot 322 approx 1,35 times 10^12$
  kg·m²/s. La gravedad no hace torque respecto del centro, pero el *empuje*
  sí: es tangencial y está aplicado a $r_a$ del centro, y es lo único que puede
  cambiar $bold(L)$.

== Ejercicio 3

+ Disco: $I = 1\/2 m R^2 = 1\/2 dot 0,200 dot 0,030^2 = 9,0 times 10^(-5)$
  kg·m². Con $omega = 3000 dot 2 pi\/60 = 314,2$ rad/s:
  $L = I omega = 0,0283$ kg·m²/s.
+ $tau = m g d = 0,200 dot 9,8 dot 0,050 = 0,098$ N·m. Como $bold(tau)$ es
  perpendicular a $bold(L)$, lo hace girar sin cambiarle el módulo:
  $Omega = tau\/L = 3,47$ rad/s, período $2 pi\/Omega = 1,81$ s. El centro de
  masa no acelera verticalmente, así que el pivote hace $m g = 1,96$ N hacia
  arriba. ($Omega << omega$: la aproximación giroscópica vale.)
+ $bold(L)$ sobre el eje, saliendo del pivote si el rotor gira en sentido
  antihorario visto desde afuera; $bold(tau) = bold(r) times m bold(g)$ es
  horizontal y perpendicular a $bold(L)$; la punta de $bold(L)$ avanza en el
  sentido de $bold(tau)$.
+ El impulso angular es $Delta bold(L)$. En un cuarto de vuelta $bold(L)$ gira
  $90°$ sin cambiar el módulo: $abs(Delta bold(L)) = sqrt(2) L = 0,0400$
  kg·m²/s. En una vuelta completa $bold(L)$ vuelve a ser el mismo vector: el
  impulso angular neto es *cero*. No hay contradicción: $bold(tau)$ nunca se
  anula, pero gira junto con $bold(L)$, y la integral de un vector que da una
  vuelta completa suma cero.
