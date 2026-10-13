// =====================================================================
//  Modelo de parcialito 4 -- momento angular, rotacion y giroscopos
//  2026-10-13. Sobre la «Lista de temas Impulso angular (2)» (S&Z caps.
//  9 y 10, Roederer) y el material que dejo la catedra: la analogia
//  precesion <-> MCU, el giroscopo como actuador y sensor, el video del
//  ventilador, Kleppner 8.3-8.4 y Meriam 7/11.
//  Parte A al estilo de los parcialitos (criterios ANI-30 a ANI-40 y
//  ANI-52 del repo catedras): cadenas cortas, dibujo, opcion multiple con
//  distractores de concepto, prediccion sin datos. Parte B numerica, "por
//  las dudas" (pedido de Fran). Cada numero tiene su cuenta en validar.py.
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp
#import "../apunte/biblioteca/estilo.typ" as dib
#import "../apunte/biblioteca/figuras.typ" as figs

#show: documento.with(
  titulo: [Modelo de parcialito 4 — momento angular y giróscopos],
  subtitulo: [La lista de temas de impulso angular, entera: rotación, momento de inercia, torque, conservación y precesión],
  encabezado: [Modelo de parcialito 4 — momento angular y giróscopos],
)

#caja([Qué entra: la lista de temas, renglón por renglón], c-azul)[
  Es la *Lista de temas Impulso angular (2)* de la cátedra (idéntica a la
  (1)), con dónde está cada renglón en el apunte y qué pregunta de este
  modelo lo toca. La cátedra le dice *impulso angular* a $bold(L)$; el
  apunte y este modelo le dicen *momento angular*, y reservan «impulso
  angular» para $integral bold(tau) dif t = Delta bold(L)$. En el examen hay
  que reconocer las dos palabras.

  #set par(justify: false)
  #table(
    columns: (1.25fr, 1.1fr, 1.5fr, 0.5fr),
    inset: (x: 4pt, y: 3pt),
    table.header(..([Tema de la lista], [Sears (S&Z vol. 1)], [Dónde en el apunte (módulo de rotación)], [Acá]).map(t => text(size: 8pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([Velocidad angular: parte escalar y vectorial], [§9.1, Fig. 9.9, ecs. 9.13 y 9.15], [«La velocidad angular: un número y un vector»], [A1]),
      ([Energía de rotación; el momento de inercia aparece al escribirla], [§9.4, ecs. 9.16–9.17], [«La energía de rotación: de ahí sale el momento de inercia»], [A2, B1]),
      ([Tabla de momentos de inercia (no se memoriza)], [Tabla 9.2], [la tabla de seis cuerpos del mismo apartado], [A2, B1]),
      ([Teorema de Steiner], [§9.5 y resumen], [«Steiner: cambiar de eje sin volver a integrar»], [A2, B1]),
      ([Torque; regla de la mano derecha], [§10.1, ec. 10.3, Fig. 10.4], [«El torque: lo que hace girar»], [A3]),
      ([Rotación de un CR; analogías $F arrow.l.r tau$, $m arrow.l.r I$, $a arrow.l.r alpha$], [§10.3, ecs. 10.8, 10.12–10.13], [«$tau = I alpha$: la segunda ley de Newton, versión rotación»], [A3, B1]),
      ([Momento angular («razón de cambio» = derivada); ec. 10.28 no es la más general], [§10.5, ecs. 10.28–10.29], [«El momento angular de un cuerpo que gira: $L = I omega$»], [A3]),
      ([Conservación de $bold(L)$], [§10.6], [«Conservación del momento angular»], [A4]),
      ([Giróscopos y precesión («primera aproximación, se ve en CR»)], [§10.7, Figs. 10.32–10.34], [«El giróscopo que no se cae» y lo que sigue], [A5–A7, B2, B3]),
      ([Segunda lectura: velocidad angular y conservación de $bold(L)$], [Roederer pág. 58 h) y pág. 120 e)], [las cajas «Dónde leerlo» del módulo], [—]),
    ).flatten().map(c => text(size: 8pt, c)),
  )
]

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Modelo *largo a propósito*: el parcialito real va a ser una parte de esto.
  Tiempo sugerido para todo: *2 horas*. La parte A casi no tiene cuentas —
  se corrige el razonamiento, y donde se pide un dibujo *el dibujo es la
  respuesta* (dirección, sentido y rótulos, no la escala); en las de opción
  múltiple la letra sola no suma—. La parte B es numérica, con calculadora.
  Use lápiz y goma. Los momentos de inercia *no se calculan*: se buscan en
  la tabla. Datos: $g = 9,81$ m/s². *Notación:* $bold(omega)$ es la
  velocidad angular del giro propio, $bold(Omega)$ la de precesión,
  $bold(tau)$ (o $bold(M)$) el torque, $bold(L)$ el momento angular.
]

= Parte A — conceptual

#ejercicio(1, [la rueda de bicicleta: un número y un vector], [1])
#origen[Velocidad angular escalar y vectorial (S&Z §9.1, ecs. 9.13 y 9.15); todos los puntos de un rígido tienen la misma $omega$.]

La rueda de la figura gira alrededor de su eje, que sale de la hoja. $A$
está en la llanta y $B$ a mitad de un rayo.

#fp.fig-rueda-puntos()

+ Dibuje el vector $bold(omega)$ con la regla de la mano derecha y diga qué
  es la «parte escalar» de la velocidad angular y qué agrega la parte
  vectorial.
+ Marque la opción correcta:
  (a) $omega_A > omega_B$ y $v_A > v_B$;
  (b) $omega_A = omega_B$ y $v_A = 2 v_B$;
  (c) $omega_A = omega_B$ y $v_A = v_B$;
  (d) $omega_A = 2 omega_B$ y $v_A = 2 v_B$.
+ Escriba la velocidad de un punto en forma vectorial y dibuje $bold(v)_A$ y
  $bold(v)_B$.

#ejercicio(2, [el momento de inercia aparece solo], [1])
#origen[Energía de rotación, momento de inercia, Tabla 9.2 y Steiner (S&Z §9.4 y §9.5).]

+ Escriba la energía cinética de la rueda como suma de las energías de sus
  partículas y muestre en qué paso aparece el momento de inercia. ¿Por qué
  se dice que $I$ es «la masa de la rotación», y por qué depende del eje?
+ Un *aro* y un *disco macizo*, de la misma masa y el mismo radio, se sueltan
  juntos desde el reposo y ruedan sin deslizar por la misma rampa. ¿Cuál
  llega primero abajo? Justifique con la energía, buscando $I$ en la tabla
  (sin calcularlo). ¿Depende de la masa o del radio?
+ ¿Qué dice el teorema de Steiner? De todos los ejes paralelos entre sí,
  ¿respecto de cuál el momento de inercia es mínimo, y por qué?

#ejercicio(3, [torque, mano derecha y la ecuación que no es la más general], [1])
#origen[Torque (S&Z §10.1, ec. 10.3), analogías lineal–rotacional (ecs. 10.12–10.13), momento angular (§10.5, ecs. 10.28–10.29).]

+ Con una llave se aprieta un tornillo que sale de la hoja: la fuerza se
  aplica en el extremo del mango, perpendicular a él. Dibuje $bold(r)$,
  $bold(F)$ y $bold(tau) = bold(r) times bold(F)$, y diga hacia dónde avanza
  el tornillo.
+ Complete la tabla de analogías:

  #align(center, table(columns: 2, inset: (x: 10pt, y: 4pt),
    [*Traslación*], [*Rotación alrededor de un eje fijo*],
    [$bold(F)$], [?], [$m$], [?], [$bold(a)$], [?],
    [$bold(p) = m bold(v)$], [?], [$bold(F) = d bold(p) \/ d t$], [?],
    [$K = frac(1, 2) m v^2$], [?],
  ))
+ La cátedra marca que $L = I omega$ (ec. 10.28 del Sears) «no es la más
  general». Dé un ejemplo de un cuerpo que gira alrededor de un eje fijo y
  cuyo $bold(L)$ *no* es paralelo a $bold(omega)$. ¿Qué tienen que hacer los
  cojinetes en ese caso?

#ejercicio(4, [la banqueta y la rueda], [1])
#origen[Conservación del momento angular (S&Z §10.6).]

Una estudiante está sentada en una banqueta que puede girar sin rozamiento
alrededor de un eje vertical. Todo está quieto salvo una rueda que ella
sostiene sobre la cabeza, con el eje vertical, girando de modo que su
momento angular $bold(L)_r$ apunta hacia arriba. Entonces da vuelta la rueda
$180°$.

#block(breakable: false, fp.fig-banqueta)

+ ¿Qué pasa con la banqueta? Diga el sentido de giro y el momento angular
  que adquiere el conjunto estudiante + banqueta, en función de $L_r$.
+ ¿Qué componente del momento angular se conserva, y de qué sistema? ¿Por
  qué no importa que la estudiante haga fuerza sobre la rueda?
+ ¿Se conserva la energía cinética? Si no, ¿de dónde sale la que aparece?

#ejercicio(5, [el giróscopo: por qué no oscila como un péndulo], [1,5])
#origen[Giróscopos y precesión (S&Z §10.7; Kleppner §8.3; Meriam 7/11); la analogía precesión ↔ movimiento circular uniforme que dejó la cátedra.]

Un giróscopo apoya un extremo de su eje en un pivote; el centro de masa del
rotor está a una distancia $d$ del pivote, con el eje horizontal.

#fp.fig-giroscopo-p(rot-d: [$d$])

+ Si el rotor *no* gira y se suelta el eje, ¿qué hace? ¿Y si gira rápido?
  ¿Cuál es la pregunta correcta: «por qué no se cae» o «por qué no oscila
  como un péndulo»?
+ Desde arriba, dibuje $bold(L)$, el torque del peso respecto del pivote y
  el cambio $Delta bold(L) = bold(tau) Delta t$ en un intervalo corto.
  Deduzca el sentido de la precesión.
+ Complete la analogía con una piedra atada a una cuerda que gira en
  círculo (o con un satélite en órbita circular):
  $bold(p) arrow.r$ ?, $bold(F) arrow.r$ ?, «la fuerza es perpendicular a
  $bold(p)$, así que le cambia la dirección y no el módulo» $arrow.r$ ?,
  velocidad angular de la piedra $arrow.r$ ?.
+ El rotor se va frenando por rozamiento. La precesión:
  (a) se frena; (b) se acelera; (c) no cambia; (d) se detiene y el
  giróscopo cae enseguida.
+ Si el eje estuviera inclinado $30°$ sobre la horizontal, ¿cambiaría la
  velocidad de precesión?

#ejercicio(6, [el ventilador de Aníbal], [0,5])
#origen[El giróscopo como *sensor*: entra un giro, sale un torque (la hoja «Giróscopos como actuador/sensor» y el video del ventilador).]

Aníbal sostiene un ventilador encendido con las dos manos, con el eje
horizontal y el aire saliendo hacia los alumnos. Las aspas giran en sentido
horario *vistas desde atrás* (desde él). Sin inclinarlo, lo gira hacia su
izquierda alrededor de la vertical.

+ ¿Qué siente en las manos? Dibuje, vistos desde arriba, $bold(L)$,
  $bold(Omega)$ y el torque que tienen que hacer sus manos.
+ En el ejercicio 5 entraba un torque y salía una precesión. ¿Qué entra y
  qué sale acá? ¿Es la misma ecuación?

#ejercicio(7, [la Tierra como giróscopo: una predicción], [0,5])
#origen[Kleppner, Ejemplo 8.9: la precesión de los equinoccios.]

El eje de la Tierra precesa con un período de unos $26 thin 000$ años por el
torque que el Sol y la Luna hacen sobre su abultamiento ecuatorial.

+ ¿Por qué una Tierra perfectamente esférica no precesaría?
+ Si la Tierra girara sobre sí misma el doble de rápido, con la misma forma,
  ¿cuánto duraría la precesión? Conteste sin hacer ninguna cuenta con datos.

= Parte B — numérica

#ejercicio(8, [la rueda que se frena], [1])
#origen[Tabla 9.2, Steiner, energía de rotación, $tau = I alpha$.]

Una rueda de bicicleta se modela como un *aro de pared delgada* de $1,8$ kg y
$0,33$ m de radio (se desprecian rayos y eje).

+ Busque en la tabla su momento de inercia respecto del eje, y calcule con
  Steiner el respecto de un eje paralelo tangente a la llanta.
+ Se la hace girar a $150$ rpm alrededor de su eje. Calcule su energía
  cinética y su momento angular.
+ El rozamiento del eje hace un torque constante de $0,020$ N·m. Calcule la
  aceleración angular, cuánto tarda en detenerse y cuántas vueltas da.

#ejercicio(9, [la misma rueda, colgada de un extremo del eje], [1,5])
#origen[Precesión estable (S&Z §10.7, Kleppner ec. 8.2, Meriam ec. 7/24).]

La rueda del ejercicio 8, con su eje (masa total rueda + eje $2,0$ kg), se
cuelga de una cuerda atada a un extremo del eje, a $0,25$ m del centro de la
rueda; el eje queda horizontal y la rueda gira a $6$ vueltas por segundo.

+ Calcule el momento angular de giro propio, el torque del peso respecto del
  punto de la cuerda y la velocidad angular y el período de precesión.
+ Verifique que $Omega << omega$. ¿Por qué hace falta para usar
  $Omega = tau \/ L$?
+ ¿Cuánto tiene que valer la tensión de la cuerda? ¿Qué velocidad tiene el
  centro de la rueda?
+ ¿Cuál sería el período de precesión si la rueda girara a la mitad? ¿Y si
  el eje estuviera inclinado $20°$ sobre la horizontal?

#ejercicio(10, [el giróscopo de control de momento de un microsatélite], [1])
#origen[El giróscopo como actuador en un satélite: Lappas, Steyn y Underwood (2002), el paper que dejó la cátedra.]

Un giróscopo de control de momento (CMG) es un rotor que gira siempre igual
y que un motor puede inclinar («girar el cardán»). El del paper tiene un
momento angular de $0,35$ N·m·s a $20 thin 000$ rpm, y el motor del cardán
lo gira a $0,12$ rad/s.

+ ¿Qué torque recibe el satélite? Diga su dirección respecto de $bold(h)$ y
  del eje del cardán.
+ ¿Cuánto vale el momento de inercia del rotor?
+ Si el mismo rotor se usara como *rueda de reacción* (frenándolo, sin
  inclinarlo) para dar ese mismo torque, ¿en cuánto tiempo se quedaría
  quieto?
+ El satélite tiene $I = 2,5$ kg·m² respecto del eje de la maniobra y arranca
  quieto. Con el torque constante, ¿cuánto tarda en girar $30°$, y con qué
  velocidad angular termina?

#pagebreak()

= Resolución

== Ejercicio 1

#fp.fig-rueda-puntos(respuesta: true)

+ Los dedos de la mano derecha siguen el giro (antihorario visto de frente)
  y el pulgar da $bold(omega)$: *sale de la hoja*, sobre el eje. La parte
  escalar es *cuán rápido* gira, $omega = d theta \/ d t$ en rad/s; la parte
  vectorial agrega *alrededor de qué eje y en qué sentido*, que es lo que
  después hace falta para $bold(tau)$ y $bold(L)$.
+ *(b).* En un rígido *todos* los puntos barren el mismo ángulo en el mismo
  tiempo: misma $omega$. La rapidez es $v = omega r$, y $A$ está al doble de
  distancia del eje que $B$. La (a) es el error de pensar que «lo de afuera
  gira más rápido»: recorre más camino, no más ángulo.
+ $bold(v) = bold(omega) times bold(r)$: tangente a la circunferencia de cada
  punto, en el sentido del giro. $bold(v)_A$ hacia la izquierda en la llanta
  de arriba; $bold(v)_B$ hacia arriba, de la mitad de largo.

== Ejercicio 2

+ Cada partícula tiene $frac(1, 2) m_i v_i^2 = frac(1, 2) m_i r_i^2 omega^2$
  porque todas comparten $omega$. Sumando y sacando $omega^2\/2$ de factor
  común:
  $ K = frac(1, 2) (sum m_i r_i^2) omega^2 = frac(1, 2) I omega^2 $
  El paréntesis es $I$: aparece solo, sin que nadie lo haya definido antes,
  y ocupa el lugar que en $frac(1, 2) m v^2$ ocupa la masa. Depende del eje
  porque las $r_i$ se miden *desde el eje*: el mismo cuerpo, girando
  alrededor de otro eje, tiene otras distancias y otro $I$ (así lo presenta
  la cátedra en su presentación «Repaso impulso angular» —repaso del
  momento angular, en su vocabulario—, con la ec. 9.16 del Sears).
+ Llega primero el *disco*. Al bajar una altura $h$, la energía potencial se
  reparte entre traslación y rotación; rodando sin deslizar, $omega = v\/R$:
  $ M g h = frac(1, 2) M v^2 + frac(1, 2) I v^2 \/ R^2 $
  Tabla: aro $I = M R^2$, disco $I = frac(1, 2) M R^2$. El aro se guarda la
  mitad de la energía en girar ($v^2 = g h$); el disco sólo un tercio
  ($v^2 = frac(4, 3) g h$), así que en cada punto va más rápido. *No depende
  de $M$ ni de $R$*: se simplifican. Lo que importa es *cómo* está repartida
  la masa, no cuánta hay.
+ Steiner: $I = I_"cm" + M d^2$, con $d$ la distancia entre el eje y el
  paralelo que pasa por el centro de masa. El mínimo es el eje que pasa
  *por el centro de masa*: cualquier otro le suma $M d^2 > 0$.

== Ejercicio 3

+ $bold(r)$ va del tornillo a la mano, $bold(F)$ perpendicular al mango; con
  la mano derecha (dedos de $bold(r)$ hacia $bold(F)$), el pulgar da
  $bold(tau)$ sobre el eje del tornillo. Para *apretar* una rosca derecha la
  llave gira en sentido horario visto desde arriba: $bold(tau)$ *entra* en
  la hoja, y el tornillo avanza hacia adentro, en el sentido de
  $bold(tau)$ (es la Fig. 10.4 del Sears). Aflojar es al revés.
+ $bold(F) arrow.r bold(tau)$; $m arrow.r I$; $bold(a) arrow.r bold(alpha)$;
  $bold(p) arrow.r bold(L) = I bold(omega)$;
  $bold(F) = d bold(p)\/d t arrow.r bold(tau) = d bold(L)\/d t$;
  $frac(1, 2) m v^2 arrow.r frac(1, 2) I omega^2$.
+ La *mancuerna inclinada*: dos masas en los extremos de una barra soldada
  en ángulo a un eje vertical que gira. Cada masa tiene $bold(r) times m
  bold(v)$ perpendicular a la *barra*, no al eje, así que $bold(L)$ queda
  inclinado respecto de $bold(omega)$ y gira con la barra: $d bold(L)\/d t !=
  0$ aunque $omega$ sea constante. Los cojinetes tienen que hacer una *cupla*
  que gira con el eje (el desbalance dinámico que se corrige al balancear
  las ruedas de un auto). $L = I omega$ es la proyección de $bold(L)$ sobre
  el eje; coincide con $bold(L)$ entero sólo si el eje es *principal* (la
  primera clase de cuerpo rígido de la cátedra).

== Ejercicio 4

+ El momento angular vertical total era $L_r$ (sólo la rueda). Después la
  rueda aporta $-L_r$, así que estudiante + banqueta tienen que aportar
  $+2 L_r$: *giran en el sentido en que giraba la rueda al principio*, con
  momento angular $2 L_r$ hacia arriba.
+ Se conserva la componente *vertical* del momento angular del sistema
  estudiante + banqueta + rueda. Las fuerzas externas (peso, normal del piso)
  son verticales y no hacen torque vertical; el eje no tiene rozamiento.
  Lo que ella le hace a la rueda es *interno*: la rueda le devuelve un torque
  igual y opuesto (tercera ley).
+ No se conserva: al principio sólo giraba la rueda, y al final gira con el
  mismo módulo de $omega$ *más* la banqueta. La energía sale de los músculos
  de la estudiante, que hacen trabajo al dar vuelta la rueda contra el
  torque giroscópico.

== Ejercicio 5

+ Sin giro, el torque del peso lo hace *caer como un péndulo* alrededor del
  pivote. Girando rápido, el eje no baja: *precesa* horizontalmente. La
  pregunta buena (Kleppner) es la segunda: que no se caiga lo explica la
  normal del pivote, que vale $m g$; lo raro es que el torque del peso no lo
  haga oscilar.
+ $bold(L)$ va sobre el eje; el torque del peso respecto del pivote es
  horizontal y *perpendicular* a $bold(L)$. Entonces $Delta bold(L) = bold(tau)
  Delta t$ es perpendicular a $bold(L)$: le *cambia la dirección y no el
  módulo*. La punta de $bold(L)$ —el eje— se corre hacia donde apunta
  $bold(tau)$: en la figura, con $bold(L)$ hacia la derecha, $bold(tau)$
  entra en la hoja y el eje gira en sentido antihorario visto desde arriba.

  #fp.fig-giroscopo-p(respuesta: true, rot-d: [$d$])

  «El vector de giro persigue al vector torque» (Meriam, art. 7/11).
+ $bold(p) arrow.r bold(L)$; $bold(F) arrow.r bold(tau)$; «el torque es
  perpendicular a $bold(L)$, le cambia la dirección y no el módulo: *eso es
  la precesión*»; la velocidad angular de la piedra en su círculo $arrow.r$
  la velocidad de precesión $bold(Omega)$. Es el texto de la hoja que dejó
  la cátedra (Sears §10.7): la precesión es el análogo rotacional del
  movimiento circular uniforme, y por eso un satélite tampoco «se cae»: la
  gravedad, perpendicular a la velocidad, le dobla la trayectoria sin
  frenarlo.
+ *(b) se acelera.* $Omega = tau \/ L = m g d \/ (I omega)$: con menos
  $omega$, el mismo torque gira un $bold(L)$ más chico más rápido. La (d) es
  la intuición equivocada; recién cuando $Omega$ deja de ser chica frente a
  $omega$ el movimiento se vuelve errático y ahí sí cae (Kleppner, después de
  la ec. 8.2).
+ No cambia. Con el eje inclinado un ángulo $phi$ respecto de la vertical,
  el torque vale $m g d sin phi$ y la parte de $bold(L)$ que gira en el
  plano horizontal es $L sin phi$: el $sin phi$ se va y queda $Omega = m g d
  \/ L$ (Kleppner, Ejemplo 8.7).

== Ejercicio 6

#fp.fig-ventilador

+ Con la mano derecha, horario visto desde atrás quiere decir que
  $bold(L)$ apunta *hacia adelante*, hacia los alumnos. Girar a la izquierda
  es $bold(Omega)$ *hacia arriba*. Para que la punta de $bold(L)$ se corra
  hacia la izquierda hace falta $d bold(L) = bold(M) thin d t$ hacia la
  izquierda: $bold(M) = bold(Omega) times bold(L)$. Un torque horizontal
  hacia su izquierda es uno que *baja la trompa* del ventilador: eso tienen
  que hacer sus manos. Lo que él siente es la reacción: el ventilador
  *quiere levantar la trompa*, y no hacia el costado adonde él lo lleva: la
  respuesta sale a $90°$ de lo que uno hace, como con la niña y la rueda del
  parcialito 3. Para tener una idea: un rotor de $I = 0,010$ kg·m² a $1200$
  rpm tiene $L = 1,257$ kg·m²/s; girarlo $90°$ en un segundo ($Omega =
  1,571$ rad/s) pide $M = 1,974$ N·m: unos $6,6$ N en cada mano si lo agarra
  de arriba y de abajo, con las manos a $30$ cm.
+ Al revés que en el 5: *entra un giro* (el que le impone Aníbal) y *sale
  un torque* (el que siente). Es la misma ecuación, $bold(M) = bold(Omega)
  times bold(L)$, leída para el otro lado: en el 5 el torque es dato y la
  precesión, respuesta (actuador); acá la precesión es dato y el torque,
  respuesta (sensor). Así miden giro los giróscopos de un sistema de guiado:
  el torque que hace falta para obligarlos a seguir a la nave es
  proporcional a la velocidad con que gira la nave.

== Ejercicio 7

+ En una esfera homogénea la atracción del Sol actúa como si toda la masa
  estuviera en el centro: no hay brazo de palanca y no hay torque. El
  torque sale del abultamiento ecuatorial (unos $21$ km), que con el eje
  inclinado tiene una mitad más cerca del Sol que la otra.
+ El *doble*, unos $52 thin 000$ años. $Omega = tau \/ L$ y $L = I omega$: con
  la misma forma el torque es el mismo, $L$ se duplica y $Omega$ se reduce a
  la mitad. Es la misma cuenta que el inciso 4 del ejercicio 5, al revés.
  Con números (Kleppner): con $I approx 8,0 times 10^37$ kg·m² y un día
  sideral, $L = 5,83 times 10^33$ kg·m²/s; $Omega = 2 pi \/ (26 thin 000$
  años$) = 7,66 times 10^(-12)$ rad/s; el torque medio es
  $tau = Omega L sin 23,5° = 1,78 times 10^22$ N·m.

== Ejercicio 8

+ Aro: $I = M R^2 = 1,8 dot 0,33^2 = 0,196$ kg·m². Steiner, con $d = R$:
  $I' = M R^2 + M R^2 = 0,392$ kg·m².
+ $omega = 150 dot 2 pi \/ 60 = 15,71$ rad/s. $K = frac(1, 2) I omega^2 =
  24,18$ J y $L = I omega = 3,079$ kg·m²/s.
+ $alpha = tau \/ I = 0,1020$ rad/s² (frenando). Tarda $t = omega \/ alpha =
  154,0$ s, y gira $theta = omega t \/ 2 = 1209$ rad, es decir $192,4$
  vueltas. Control por energía: el trabajo del rozamiento $tau theta = 24,18$
  J es exactamente la energía que tenía.

== Ejercicio 9

+ $omega = 6 dot 2 pi = 37,70$ rad/s y $L = I omega = 0,196 dot 37,70 = 7,390$
  kg·m²/s (sólo la llanta: el eje casi no aporta momento de inercia, pero sí
  peso). $tau = m g d = 2,0 dot 9,81 dot 0,25 = 4,905$ N·m.
  $Omega = tau \/ L = 0,6638$ rad/s, y el período de precesión es
  $2 pi \/ Omega = 9,47$ s.
+ $Omega \/ omega = 0,0176$: la precesión es casi sesenta veces más lenta que
  el giro. Hace falta porque $Omega = tau\/L$ supone que $bold(L)$ es *sólo*
  el del giro propio; la precesión le agrega un momento angular vertical
  chico, que así se puede despreciar (Meriam, después de la ec. 7/25).
+ El centro de masa no sube ni baja: la cuerda tira $m g = 19,62$ N hacia
  arriba. Pero sí da vueltas: su velocidad es $Omega d = 0,166$ m/s, y la
  fuerza centrípeta $m Omega^2 d$ la pone un poco de inclinación de la
  cuerda.
+ A la mitad de giro, $L$ se reduce a la mitad y $Omega$ se duplica: el
  período baja a $4,73$ s. Con el eje inclinado $20°$, *no cambia* (Kleppner,
  Ejemplo 8.7): sigue en $9,47$ s.

== Ejercicio 10

+ El motor del cardán gira el vector $bold(h)$ a $dot(delta) = 0,12$ rad/s:
  $d bold(h)\/d t = dot(bold(delta)) times bold(h)$, de módulo $h dot(delta) =
  0,35 dot 0,12 = 0,042$ N·m. Ese torque lo hace el satélite sobre el rotor;
  el rotor le devuelve el opuesto: el satélite recibe $42$ mN·m,
  perpendicular a $bold(h)$ y al eje del cardán. (El paper usa cuatro CMG y
  saca $52,5$ mN·m del conjunto.)
+ $omega = 20 thin 000 dot 2 pi \/ 60 = 2094$ rad/s, así que $I = h \/ omega =
  1,67 times 10^(-4)$ kg·m²: un rotor de unos gramos.
+ Como rueda de reacción el torque es $d h \/ d t$: para dar $0,042$ N·m
  pierde $0,042$ N·m·s por segundo y se queda quieta en $0,35 \/ 0,042 =
  8,3$ s. El CMG, en cambio, *no gasta* $h$: lo gira. Por eso «amplifica» el
  torque con la misma potencia (Lappas y otros, 2002).
+ $alpha = 0,042 \/ 2,5 = 0,0168$ rad/s². Para $30° = 0,524$ rad desde el
  reposo, $theta = frac(1, 2) alpha t^2$: $t = 7,90$ s, y termina girando a
  $alpha t = 0,133$ rad/s. (En la realidad el torque cambia de dirección a
  medida que el cardán gira; por eso se usan cuatro.)
