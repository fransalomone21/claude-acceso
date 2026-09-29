// =====================================================================
//  Modelo de parcial 1 -- primera evaluacion
//  Siete ejercicios integradores sobre los temas centrales. Cada numero
//  de la resolucion tiene su cuenta en validar.py (c_modelos).
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp

#show: documento.with(
  titulo: [Modelo de parcial 1],
  subtitulo: [Cantidad de movimiento, cohete, energía, parámetros orbitales, maniobras y momento angular],
  encabezado: [Modelo de parcial 1],
)

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Tiempo sugerido: *3 horas*. Hoja de fórmulas propia y calculadora. En cada
  paso hay que decir *qué se conserva y por qué*: vale tanto como el número.
  Datos: $mu_T = 398 thin 600$ km³/s², $R_T = 6378$ km, $g_0 = 9,81$ m/s².
  *Notación:* la del apunte — $bold(L)$ momento angular (la guía de la cátedra
  lo llama *impulso angular*), $bold(tau)$ torque, $omega$ velocidad angular,
  $bold(P)$ cantidad de movimiento. Cada resolución abre con la notación de su
  tema y cómo aparece en la guía y en los libros.
]

#mapa(
  ([1], [cantidad de movimiento + energía + órbitas], [Adicional 1 de cantidad de movimiento (las dos etapas que se separan)]),
  ([2], [cohete: empuje, más peso que empuje, integración de $a(t)$], [Ej. 6 (Beer 14.94) y Adicional 3 de cantidad de movimiento]),
  ([3], [energía y gravitación], [Problema 6 de gravitación (Beer 13.85)]),
  ([4], [parámetros orbitales desde un estado], [Adicional 5 de gravitación]),
  ([5], [maniobras (Hohmann) + ecuación del cohete], [Problema 5 de gravitación y Ej. 5 de cantidad de movimiento]),
  ([6], [momento angular: conservación, torque interno, energía], [Problemas 4 y 7 de impulso angular (giróscopos)]),
  ([7], [momento angular de una partícula (demostración)], [Problema 2 de impulso angular]),
)

#ejercicio(1, [las dos etapas que se separan en órbita], [1,5])
#origen[Cantidad de movimiento + energía cinética + vis-viva. Se apoya en el Adicional 1 de cantidad de movimiento.]

La tercera y la cuarta etapa de un lanzador (400 kg y 200 kg) viajan juntas, sin
motor, en una órbita circular a 300 km de altura. Una pequeña carga explosiva las
separa: justo después, la cuarta etapa sigue en la misma dirección pero con
60 m/s más que antes. La separación dura una fracción de segundo.

#fp.fig-separacion

+ Calcule la rapidez de la órbita circular.
+ Calcule la velocidad de la tercera etapa justo después de la separación y la
  velocidad relativa entre las dos.
+ ¿Cuánta energía entregó la carga explosiva a las etapas?
+ ¿En qué órbita queda cada etapa? Dé la altura del apogeo de la cuarta y la
  del perigeo de la tercera. ¿Alguna corre riesgo de reentrar pronto?

#ejercicio(2, [el cohete que no despega], [1,5])
#origen[Ecuación del cohete, empuje, integración de la aceleración. Se apoya en el Ej. 6 (Beer 14.94) y en el Adicional 3 de cantidad de movimiento.]

Un cohete de una etapa despega verticalmente con una masa total de
$M_0 = 20 thin 000$ kg, de los cuales $16 thin 000$ kg son propelente. El motor
tiene $I_"sp" = 300$ s y quema a razón constante de $mu = 200$ kg/s. Tome $g$
constante y desprecie el aire.

#fp.fig-cohete-p(datos: [$M_0 = 20$ t, \ propelente $16$ t, \ $I_"sp" = 300$ s])

+ Calcule la velocidad de los gases respecto del cohete, el empuje, y la
  aceleración al despegar y justo antes de agotar el propelente.
+ Escriba $a(t)$ e intégrela para obtener $v(t)$, diciendo qué es la constante
  de integración. Calcule la velocidad al apagarse el motor.
+ ¿Cuánta velocidad se «perdió» por la gravedad respecto del mismo cohete en
  el espacio?
+ Con el mismo cohete pero con un caudal de sólo $60$ kg/s: ¿despega apenas se
  enciende? Si no, ¿cuándo? ¿Y con qué velocidad llega al final del quemado?

#ejercicio(3, [cuánto cuesta subir un satélite], [1,25])
#origen[Energía mecánica en órbita, energía potencial gravitatoria general. Se apoya en el Problema 6 de gravitación (Beer 13.85).]

Un satélite de $2000$ kg está en una órbita circular a $300$ km de altura y hay
que ponerlo en la órbita circular de los GPS, de radio $26 thin 560$ km.

#fp.fig-hohmann-p(1.25, 2.7, rot1: [300 km], rot2: [$r = 26 thin 560$ km], transfer: false, superficie: 1.05, rot-sup: [Tierra])

+ Calcule la energía mecánica del satélite en cada órbita, y la energía que
  hay que agregarle para pasar de una a otra.
+ ¿Cuánta energía haría falta para ponerlo en la órbita GPS desde el reposo
  en la superficie (sin aire y sin contar la rotación de la Tierra)?
+ Separe la energía de la órbita GPS en cinética y potencial. Si subir la
  órbita cuesta energía, ¿cómo puede ser que el satélite quede *más lento*?
+ ¿Con qué rapidez habría que lanzarlo verticalmente desde la superficie para
  que llegue, frenándose, justo a $r = 26 thin 560$ km?

#ejercicio(4, [la órbita a partir de una medición], [1,5])
#origen[Momento angular específico, energía, ecuación de la órbita, elementos orbitales. Se apoya en el Adicional 5 de gravitación.]

Un radar mide un satélite a $r = 8000$ km del centro de la Tierra, con rapidez
$v = 7,5$ km/s y ángulo de trayectoria de vuelo $gamma = 10°$, alejándose de la
Tierra.

#fp.fig-orbita-p(0.215, 2.5, puntos: ((anom: 63.8, vel: true, gam: 10, gam-dib: 22, rot: [medición], desp: (0.12, 0.05), ancla: "west"),))

+ Calcule el momento angular específico $h$, la energía específica
  $epsilon$ y el semieje mayor.
+ Calcule la excentricidad y la anomalía verdadera del punto medido.
+ Calcule los radios, las alturas y las rapideces en el perigeo y en el
  apogeo, y el período.
+ Calcule la velocidad areolar. ¿Es la misma en el perigeo?
+ De los seis elementos orbitales clásicos, ¿cuáles quedaron determinados
  con estos datos y cuáles no? ¿Qué haría falta medir para el resto?

#ejercicio(5, [de 300 km a la órbita GPS], [1,5])
#origen[Transferencia de Hohmann + ecuación de Tsiolkovsky + tercera ley de Kepler. Se apoya en el Problema 5 de gravitación y en el Ej. 5 de cantidad de movimiento.]

El satélite del Ejercicio 3 (masa seca $2000$ kg) hace el cambio de órbita con
una transferencia de Hohmann, con un motor de $I_"sp" = 310$ s.

#fp.fig-hohmann-p(1.25, 2.7, rot1: [300 km], rot2: [GPS])

+ Calcule la velocidad en la órbita inicial, en el perigeo y en el apogeo de
  la transferencia, y en la órbita final.
+ Calcule los dos $Delta v$ y el total. ¿Hacia dónde apunta el motor en cada
  encendido?
+ ¿Cuánto propelente hace falta? ¿Cuánto se gasta en cada encendido?
+ ¿Cuánto dura la transferencia?

#ejercicio(6, [la rueda de reacción], [1,5])
#origen[Conservación del momento angular, torque interno, energía de rotación. Se apoya en los Problemas 4 y 7 de impulso angular.]

Un satélite, quieto, tiene momento de inercia $I_s = 150$ kg·m² respecto de un
eje $z$ que pasa por su centro de masa. Sobre ese eje lleva una rueda de
reacción de $I_w = 0,06$ kg·m², también quieta. Un motor eléctrico lleva la
rueda, a torque constante, hasta $2000$ rpm *respecto del satélite* en $10$ s,
la mantiene así un tiempo y después la frena en otros $10$ s, también a torque
constante.

#fp.fig-rueda-reaccion

+ Calcule la velocidad angular del satélite mientras la rueda gira a
  $2000$ rpm. ¿En qué sentido gira?
+ Calcule el torque del motor. ¿Por qué no cambia el momento angular del
  conjunto, si hay un torque?
+ ¿Cuánto tiempo hay que mantener la rueda a $2000$ rpm para que el satélite
  termine girado exactamente $90°$ y quieto?
+ ¿Cuánta energía cinética tiene el conjunto con la rueda a $2000$ rpm?
  ¿De dónde salió, si el momento angular sigue siendo cero?

#ejercicio(7, [la partícula libre], [1,25])
#origen[Momento angular de una partícula. Es el Problema 2 de impulso angular, con una pregunta más.]

Una partícula de masa $m$ se mueve con velocidad constante $bold(v)$ sobre una
recta que pasa a una distancia $d$ de un punto $O$.

#fp.fig-particula-libre

+ Demuestre que su momento angular respecto de $O$ es constante, y que su
  módulo vale $m v d$.
+ Si ahora sobre la partícula actúa una fuerza que siempre apunta hacia $O$
  (o en sentido contrario), ¿sigue siendo constante $bold(L)_O$? ¿Y respecto
  de otro punto? ¿Qué tiene que ver esto con las órbitas?

#pagebreak()

= Resolución

== Ejercicio 1 — las dos etapas que se separan

#notacion[
  Acá $bold(P) = sum m_i bold(v)_i$ es la cantidad de movimiento. El Beer la
  escribe $bold(L)$ (y usa $bold(H)$ para el momento angular); el Roederer la
  llama *impulso*. Para la cátedra, *impulso* es $integral bold(F) dif t$ y
  $Delta bold(P)$ es la variación de la cantidad de movimiento. $mu$ es el
  parámetro gravitatorio $G M_T$ (en el cohete, la misma letra es el caudal).
]

#idea[
  La explosión es una fuerza *interna* y enorme que dura muy poco. En ese
  instante la gravedad (externa) casi no alcanza a dar impulso, así que la
  cantidad de movimiento del conjunto *justo antes* es la misma que *justo
  después*. La energía cinética, en cambio, *no* se conserva: la carga
  explosiva la aumenta. Después de la separación cada etapa es un satélite
  suelto, con su propia órbita, que sale de su posición y su velocidad.
]

#paso(1, [la órbita circular])
En una órbita circular la gravedad es la fuerza centrípeta:
$ (mu m) / r^2 = m v^2 / r quad arrow.r.double quad v_0 = sqrt(mu / r) = sqrt((398 thin 600) / 6678) = 7,726 "km/s", $
con $r = 6378 + 300 = 6678$ km.

#paso(2, [cantidad de movimiento en la separación])
Todo pasa sobre la misma recta (la tangente a la órbita), así que alcanza una
componente. Con $v_4 = v_0 + 0,060$ km/s $= 7,786$ km/s:
$ (400 + 200) v_0 = 400 thin v_3 + 200 thin v_4 quad arrow.r.double quad v_3 = v_0 - 200 / 400 dot 0,060 = 7,696 "km/s". $
La tercera etapa pierde $30$ m/s, la mitad de lo que gana la cuarta, porque
tiene el doble de masa. La velocidad relativa es $v_4 - v_3 = 90$ m/s: la
cuarta se aleja hacia adelante a $90$ m/s.

#paso(3, [la energía que entregó la carga])
La energía liberada es lo que aumentó la energía cinética:
$ Delta K = [1/2 dot 400 thin v_3^2 + 1/2 dot 200 thin v_4^2] - 1/2 dot 600 thin v_0^2. $
Escribiendo $v_3 = v_0 - 30$ m/s y $v_4 = v_0 + 60$ m/s, los términos con
$v_0$ se cancelan (porque $400 dot 30 = 200 dot 60$, que es justamente la
conservación de $P$) y queda
$ Delta K = 1/2 dot 400 dot 30^2 + 1/2 dot 200 dot 60^2 = 540 thin 000 "J" = 540 "kJ". $

#camino[
  Se trabajó en el marco de la Tierra, que es el del enunciado. Tiene una
  trampa numérica: cada energía cinética es del orden de
  $1/2 dot 600 dot (7726)^2 approx 1,791 times 10^(10)$ J, y la diferencia
  es de $10^5$ J. Restar dos números enormes que difieren en la quinta
  cifra con la calculadora da basura si se redondea antes. Por eso se
  escribió $v_3$ y $v_4$ como $v_0$ más una corrección y se simplificó *antes*
  de poner números.
]

#alternativa([desde el centro de masa])[
  La velocidad del centro de masa no cambia (no hubo impulso externo), así que
  por el teorema de König la energía cinética se parte en
  $K = 1/2 M v_"CM"^2 + K_"rel"$, y la primera parte no cambia. Toda la energía
  de la explosión va a $K_"rel"$, que antes era cero. Para dos cuerpos,
  $K_"rel" = 1/2 m_r v_"rel"^2$ con la masa reducida
  $m_r = (400 dot 200) \/ 600 = 133,3$ kg:
  $ Delta K = 1/2 dot 133,3 dot 90^2 = 540 "kJ". $
  Mismo número, sin restar nada grande: es el camino que conviene cuando las
  velocidades son orbitales.
]

#paso(4, [las órbitas nuevas])
Justo después de la separación las dos etapas están a $r = 6678$ km con
velocidad *horizontal* (perpendicular al radio). Un punto con velocidad
perpendicular al radio es un ábside: para la cuarta, que va más rápido que la
circular, es el *perigeo*; para la tercera, más lenta, es el *apogeo*.

Cuarta etapa, con la vis-viva $v^2 = mu (2\/r - 1\/a)$:
$ a_4 = 1 / (2 \/ r - v_4^2 \/ mu) = 6784 "km" quad arrow.r.double quad r_(a,4) = 2 a_4 - r = 6890 "km", $
o sea el apogeo a $512$ km de altura. Tercera etapa: $a_3 = 6627$ km y su
perigeo es $r_(p,3) = 2 a_3 - r = 6575$ km, a $197$ km de altura. A esa altura
todavía hay atmósfera que frena: la tercera etapa va a perder energía en cada
perigeo y reentra en semanas, que es exactamente lo que se busca con una etapa
vieja.

#alternativa([con el momento angular y la excentricidad])[
  Como la velocidad es perpendicular al radio, $h = r v$ y en un ábside la
  ecuación de la órbita da $e = h^2 \/ (mu r) - 1$. Para la cuarta:
  $h = 6678 dot 7,786$ km²/s y $e = 0,0156$; el otro ábside está en
  $r_a = r (1 + e) \/ (1 - e) = 6890$ km. Para la tercera sale
  $e = 1 - h^2 \/ (mu r) = 0,00775$ y $r_p = r(1 - e)\/(1 + e) = 6575$ km.
  Mismos números: la vis-viva sale de juntar $h$ y la energía, así que los
  dos caminos son la misma física.
]

#final[$v_0 = 7,726$ km/s; $v_3 = 7,696$ km/s; $v_"rel" = 90$ m/s; $Delta K = 540$ kJ; la cuarta queda en una órbita de $300 times 512$ km y la tercera en una de $197 times 300$ km.]

== Ejercicio 2 — el cohete que no despega

#notacion[
  Este apunte (y el Roederer): $mu > 0$ es el *caudal* de masa y $v_r$ la
  velocidad de los gases *relativa al cohete*. El Sears escribe el caudal
  como $-dif m \/ dif t$ y la velocidad de salida $v_"esc"$; el Beer la llama
  $u$. El *impulso específico* es $I_"sp" = v_r \/ g_0$, en segundos (se vio
  en clase; no está en los libros). Ojo: acá $mu$ *no* es $G M$.
]

#idea[
  El cohete empuja gases hacia abajo y los gases lo empujan hacia arriba: esa
  fuerza es el *empuje*, $mu v_r$, y es constante si el caudal lo es. Lo que
  cambia es la masa, así que la misma fuerza acelera cada vez más. Contra el
  empuje está el peso $M(t) g$, que baja a medida que se quema propelente. Y
  el comentario de la cátedra: *el cohete puede comenzar con más peso que
  empuje* — en ese caso no se levanta, se queda quemando propelente sobre la
  plataforma hasta que el peso baja lo suficiente.
]

#paso(1, [velocidad de los gases, empuje y aceleración])
$ v_r = I_"sp" g_0 = 300 dot 9,81 = 2943 "m/s", quad F = mu v_r = 200 dot 2943 = 588,6 "kN". $
El peso inicial es $M_0 g = 196,2$ kN, menor que el empuje: despega. La
segunda ley para el cohete (que es la ecuación del cohete) da
$ M(t) thin a = mu v_r - M(t) g quad arrow.r.double quad a(t) = (mu v_r) / (M_0 - mu t) - g. $
Al despegar, $a(0) = 588 thin 600 \/ 20 thin 000 - 9,81 = 19,62$ m/s². El
propelente dura $t_b = 16 thin 000 \/ 200 = 80$ s; al final quedan
$4000$ kg y $a(t_b) = 588 thin 600 \/ 4000 - 9,81 = 137,3$ m/s² — unas $14 g$,
con el mismo motor.

#paso(2, [de $a(t)$ a $v(t)$, con la constante])
$v(t) = v(0) + integral_0^t a(s) dif s$. La constante de integración es
$v(0)$, la velocidad cuando se enciende el motor: acá cero, porque parte del
reposo. La integral del primer término sale con el cambio $w = M_0 - mu s$,
$dif w = -mu dif s$:
$ integral_0^t (mu v_r) / (M_0 - mu s) dif s = v_r integral_(M(t))^(M_0) (dif w) / w = v_r ln M_0 / M(t). $
Entonces
$ v(t) = v(0) + v_r ln M_0 / (M_0 - mu t) - g t. $
Al apagarse ($t_b = 80$ s, $M_0 \/ M_f = 5$):
$v_b = 2943 ln 5 - 9,81 dot 80 = 4737 - 784,8 = 3952$ m/s.

#paso(3, [la pérdida por gravedad])
En el espacio el mismo cohete ganaría $v_r ln(M_0\/M_f) = 4737$ m/s
(Tsiolkovsky). La gravedad se llevó $g t_b = 784,8$ m/s, el $16,6$ % del
total. Es el precio de tardar: cuanto más dura el quemado, más tiempo actúa
el peso.

#paso(4, [con $60$ kg/s: más peso que empuje])
El empuje es $60 dot 2943 = 176,6$ kN, *menor* que el peso inicial de
$196,2$ kN: al encender, la plataforma sigue sosteniendo al cohete y no
despega. Se levanta cuando $M(t) g = F$, o sea cuando
$M = 176 thin 580 \/ 9,81 = 18 thin 000$ kg: después de quemar $2000$ kg, a los
$t = 2000 \/ 60 = 33,3$ s. Desde ahí vale la ecuación del cohete, con
$v = 0$ como condición inicial y $18 thin 000$ kg como masa inicial. El quemado
entero dura $16 thin 000 \/ 60 = 266,7$ s, así que vuela $233,3$ s:
$ v_b = 2943 ln (18 thin 000) / 4000 - 9,81 dot 233,3 = 2137 "m/s". $
Con menos caudal el cohete tarda más, la gravedad se come
$4737 - 2137 = 2600$ m/s, y encima quemó $2000$ kg sin moverse.

#camino[
  Se escribió la segunda ley para el cohete como si fuera un cuerpo de masa
  $M(t)$ con una fuerza extra (el empuje), y se integró. Es lícito porque el
  empuje *ya incluye* el efecto de los gases que se van: sale de aplicar el
  teorema de la cantidad de movimiento al sistema cohete + gases.
]

#alternativa([desde la cantidad de movimiento, en un $dif t$])[
  En $t$ el sistema es el cohete, de masa $M$ y velocidad $v$. En $t + dif t$
  son dos cosas: el cohete, con $M - mu dif t$ y $v + dif v$, y los gases
  expulsados, $mu dif t$ con velocidad $v - v_r$. El impulso externo es
  $-M g dif t$:
  $ (M - mu dif t)(v + dif v) + mu dif t (v - v_r) - M v = -M g dif t. $
  Desarrollando y tirando el producto de dos diferenciales:
  $M dif v - mu v_r dif t = -M g dif t$, es decir
  $M thin dif v \/ dif t = mu v_r - M g$. Es la misma ecuación del Paso 1, y
  de ahí sale el mismo $v(t)$. La ventaja de este camino es que muestra de
  dónde sale el empuje, que es lo que la cátedra pide entender.
]

#trampa[
  Escribir $F = dif (M v) \/ dif t$ para el cohete *está mal*: los gases que
  se van no salen con velocidad cero, salen con $v - v_r$. Esa ecuación sólo
  vale si la masa que entra o sale lo hace en reposo.
]

#final[$v_r = 2943$ m/s; $F = 588,6$ kN; $a$ va de $19,62$ a $137,3$ m/s²; $v_b = 3952$ m/s; pérdida por gravedad $784,8$ m/s; con $60$ kg/s despega a los $33,3$ s y llega a $2137$ m/s.]

== Ejercicio 3 — cuánto cuesta subir un satélite

#notacion[
  $U = -G M m \/ r = -mu m \/ r$ es la energía potencial gravitatoria
  general (Sears §13.3), con el cero en el infinito. $E = K + U$ es la
  energía mecánica y $epsilon = E\/m$ la *energía específica* (Curtis). La
  hoja de clase escribe $V_g = -alpha \/ r$: para que sea una energía,
  $alpha = G M m$. El Beer usa $G M = g R^2$, con $R = 6370$ km: los números
  cambian en la tercera cifra.
]

#idea[
  En una órbita circular la energía cinética es la mitad del valor absoluto
  de la potencial: $K = mu m \/ (2 r)$, $U = -mu m \/ r$, y entonces
  $E = -mu m \/ (2 r)$. Subir la órbita hace a $E$ *menos negativa*: cuesta
  energía. Pero la que sube es la potencial, y sube el doble de lo que baja
  la cinética.
]

#paso(1, [energía en cada órbita])
Con $mu = 3,986 times 10^(14)$ m³/s², $r_1 = 6,678 times 10^6$ m y
$r_2 = 2,656 times 10^7$ m:
$ E_1 = -(mu m) / (2 r_1) = -59,69 "GJ", quad E_2 = -(mu m) / (2 r_2) = -15,01 "GJ", quad Delta E = 44,68 "GJ". $

#paso(2, [desde la superficie])
En reposo en la superficie sólo hay potencial: $E_0 = -mu m \/ R_T = -125,0$ GJ.
Hacen falta $E_2 - E_0 = 110,0$ GJ, más del doble que desde la órbita baja:
la mayor parte del trabajo de ir al espacio es *salir de abajo*.

#paso(3, [cinética y potencial en la órbita GPS])
$K_2 = mu m \/ (2 r_2) = 15,01$ GJ y $U_2 = -30,02$ GJ. Entre las dos órbitas
$Delta K = -44,68$ GJ y $Delta U = +89,36$ GJ: la potencial sube el doble de
lo que baja la cinética. Por eso la órbita alta es más lenta ($3,874$ km/s
contra $7,726$) y aun así tiene más energía.

#paso(4, [el lanzamiento vertical])
Si llega a $r_2$ con velocidad cero, la conservación de la energía entre la
superficie y ese punto da
$ 1/2 v_"lan"^2 - mu / R_T = 0 - mu / r_2 quad arrow.r.double quad v_"lan" = sqrt(2 mu (1 / R_T - 1 / r_2)) = 9,746 "km/s". $
Es menos que la de escape ($11,18$ km/s), y no deja el satélite en órbita:
llega quieto y se cae. Para quedarse le faltaría además la velocidad
horizontal de la órbita.

#camino[
  Se usó directamente $E = -mu m \/ (2 r)$ para cada órbita circular, que ya
  junta cinética y potencial. Es el camino corto, y vale *sólo* para órbitas
  circulares (para una elipse es $-mu m \/ (2 a)$).
]

#alternativa([cinética y potencial por separado])[
  $K_1 = 1/2 m v_1^2 = 1/2 dot 2000 dot (7726)^2 = 59,69$ GJ,
  $U_1 = -mu m \/ r_1 = -119,38$ GJ, así que $E_1 = -59,69$ GJ; igual para la
  órbita 2 con $v_2 = 3874$ m/s. Sale lo mismo, con el doble de cuentas, pero
  de paso muestra el $K = -E$ de la órbita circular.
]

#trampa[
  Usar $U = m g h$ acá está mal: esa fórmula supone $g$ constante, y a
  $20 thin 000$ km de altura $g$ vale menos del $6$ % de la de la superficie.
  $m g h$ es la aproximación de $-mu m\/r$ para $h << R_T$, no la ecuación
  general.
]

#final[$E_1 = -59,69$ GJ, $E_2 = -15,01$ GJ, $Delta E = 44,68$ GJ; desde la superficie $110,0$ GJ; $K_2 = 15,01$ GJ, $U_2 = -30,02$ GJ; $v_"lan" = 9,746$ km/s.]

== Ejercicio 4 — la órbita a partir de una medición

#notacion[
  $h = abs(bold(r) times bold(v))$ es el momento angular *específico*
  ($bold(L)\/m$; Curtis y Beer también $h$, pero el Beer usa $bold(H)$ para
  el total). $nu$ es la anomalía verdadera (Bate); Curtis y Beer la llaman
  $theta$. $gamma$ es el ángulo de trayectoria de vuelo: entre la velocidad y
  la horizontal local. $p = h^2\/mu$ es el parámetro de la órbita.
]

#idea[
  Una posición y una velocidad alcanzan para saber la órbita entera en su
  plano: $h$ sale de la parte de la velocidad perpendicular al radio, la
  energía sale de $r$ y $v$, y con esas dos constantes la cónica queda fija.
  Lo que falta es *dónde* está el punto sobre ella, y eso lo da el signo de
  la velocidad radial: si se aleja, ya pasó el perigeo.
]

#paso(1, [descomponer la velocidad])
$v_perp = v cos gamma = 7,386$ km/s y $v_r = v sin gamma = 1,302$ km/s. Entonces
$ h = r v_perp = 8000 dot 7,386 = 59 thin 088 "km"^2"/s", quad epsilon = v^2 / 2 - mu / r = -21,70 "km"^2"/s"^2. $
Energía negativa: órbita cerrada. $a = -mu \/ (2 epsilon) = 9184$ km.

#paso(2, [excentricidad y anomalía verdadera])
De la ecuación de la órbita $r = (h^2\/mu) \/ (1 + e cos nu)$ y de
$v_r = (mu \/ h) e sin nu$ salen las dos componentes:
$ e cos nu = h^2 / (mu r) - 1 = 0,0949, quad e sin nu = (v_r h) / mu = 0,1931. $
$e = sqrt(0","0949^2 + 0","1931^2) = 0,2151$ y $nu = arctan(0,1931 \/ 0,0949) = 63,8°$,
en el primer cuadrante porque las dos componentes son positivas: pasó por el
perigeo hace poco y se aleja.

#paso(3, [ábsides y período])
$r_p = a(1 - e) = 7209$ km (a $831$ km de altura) y
$r_a = a(1 + e) = 11 thin 160$ km (a $4782$ km). En los ábsides la velocidad
es perpendicular al radio, así que $v = h \/ r$:
$v_p = 8,197$ km/s y $v_a = 5,295$ km/s. Período:
$T = 2 pi sqrt(a^3 \/ mu) = 146,0$ min.

#paso(4, [velocidad areolar])
El radio barre área a razón $dif A \/ dif t = h \/ 2 = 29 thin 544$ km²/s, y
como $h$ se conserva (fuerza central), es la *misma* en el perigeo, en el
apogeo y en todos lados: es la segunda ley de Kepler.

#paso(5, [los elementos orbitales])
Quedaron determinados $a$ (o $h$), $e$ y $nu$: los que viven *en el plano*
de la órbita. Faltan la inclinación $i$, la ascensión recta del nodo
ascendente $Omega$ y el argumento del perigeo $omega$, que dicen cómo está
orientado ese plano y la elipse en el espacio. Para esos hace falta la
posición y la velocidad como *vectores* en un marco geocéntrico
(tres componentes cada uno), no sólo sus módulos y un ángulo.

#camino[
  Se sacó $e$ de sus dos componentes, $e cos nu$ y $e sin nu$. Así sale
  además $nu$ *con su cuadrante*, que es lo que el enunciado pide.
]

#alternativa([la excentricidad desde la energía])[
  Juntando la energía y el momento angular se llega a
  $e = sqrt(1 + 2 epsilon h^2 \/ mu^2) = sqrt(1 - 2 dot 21","70 dot 59 thin 088^2 \/ 398 thin 600^2) = 0,2151$.
  Mismo $e$, en un renglón. Pero no da $nu$: con
  $cos nu = (h^2 \/ (mu r) - 1)\/e$ sale $nu = plus.minus 63,8°$, y el signo
  lo decide recién el sentido de $v_r$ (se aleja: positivo).
]

#final[$h = 59 thin 088$ km²/s, $epsilon = -21,70$ km²/s², $a = 9184$ km, $e = 0,2151$, $nu = 63,8°$; perigeo $7209$ km ($8,197$ km/s), apogeo $11 thin 160$ km ($5,295$ km/s); $T = 146,0$ min; $dif A \/dif t = 29 thin 544$ km²/s.]

== Ejercicio 5 — de 300 km a la órbita GPS

#notacion[
  Igual que en los Ejercicios 2 y 3: $mu$ es $G M_T$ en las órbitas y el
  caudal en el cohete. $v_e = I_"sp" g_0$ es la velocidad de los gases (la
  $v_r$ del Ejercicio 2). El Beer llama a la transferencia simplemente
  «órbita de transferencia» (§12.13, Fig. 12.23).
]

#idea[
  La transferencia de Hohmann es media elipse tangente a las dos órbitas:
  su perigeo toca la órbita baja y su apogeo la alta. Cada encendido es un
  empujón *tangente*, que cambia la rapidez sin cambiar la dirección: el
  primero estira el apogeo hasta la órbita alta, el segundo levanta el perigeo
  hasta ella. Los dos van *hacia adelante*.
]

#paso(1, [las cuatro velocidades])
Semieje de la transferencia: $a_T = (6678 + 26 thin 560)\/2 = 16 thin 619$ km.
Con la vis-viva $v^2 = mu (2 \/ r - 1 \/ a)$:
circular inicial $7,726$ km/s; perigeo de la transferencia $9,767$ km/s;
apogeo de la transferencia $2,456$ km/s; circular final $3,874$ km/s.

#paso(2, [los $Delta v$])
$Delta v_1 = 9,767 - 7,726 = 2,041$ km/s y $Delta v_2 = 3,874 - 2,456 = 1,418$ km/s;
total $3,459$ km/s. Los dos encendidos, en el sentido del movimiento.

#paso(3, [el propelente])
$v_e = 310 dot 9,81 = 3,041$ km/s. Las razones de masas de encendidos seguidos
se multiplican, así que se puede usar el $Delta v$ total en Tsiolkovsky:
$ m_0 = m_"seca" e^(Delta v \/ v_e) = 2000 e^(3,459 \/ 3,041) = 6238 "kg", $
$4238$ kg de propelente. Entre los dos encendidos la masa es
$2000 e^(1,418\/3,041) = 3188$ kg: el primero quema $3050$ kg y el segundo
$1188$ kg.

#paso(4, [el tiempo])
Se recorre media elipse: $t = pi sqrt(a_T^3 \/ mu) = 2,96$ h.

#camino[
  Las velocidades salieron de la vis-viva, que ya junta la conservación de
  la energía con la del momento angular: se aplica punto por punto y no hace
  falta plantear un sistema.
]

#alternativa([con la conservación de $h$ y de la energía])[
  Entre el perigeo y el apogeo de la transferencia se conservan
  $h = r_1 v_p = r_2 v_a$ y $1/2 v_p^2 - mu\/r_1 = 1/2 v_a^2 - mu\/r_2$.
  Reemplazando $v_a = v_p r_1 \/ r_2$ en la energía y despejando:
  $ v_p = sqrt((2 mu r_2) / (r_1 (r_1 + r_2))) = 9,767 "km/s", quad v_a = v_p r_1 / r_2 = 2,456 "km/s". $
  Mismo resultado, y muestra que la vis-viva no es una ley aparte sino la
  combinación de las dos conservaciones.
]

#final[$Delta v_1 = 2,041$ km/s, $Delta v_2 = 1,418$ km/s, total $3,459$ km/s; $m_0 = 6238$ kg ($4238$ kg de propelente: $3050$ + $1188$); $2,96$ h.]

== Ejercicio 6 — la rueda de reacción

#notacion[
  $bold(L)$ es el momento angular — la guía lo llama *impulso angular*, el
  Sears §10.5 *momento angular* y el Beer lo escribe $bold(H)$. $bold(tau)$
  es el torque (Sears: *torca*; Beer: momento $bold(M)$). $omega$ es la
  velocidad angular e $I$ el momento de inercia respecto del eje de giro.
  Para un eje fijo, $L = I omega$ y $tau = dif L \/ dif t$.
]

#idea[
  El torque que el motor hace sobre la rueda es *interno* al satélite: la
  rueda le devuelve al satélite un torque igual y contrario (tercera ley, en
  versión rotacional). El momento angular del conjunto, que empezó en cero,
  sigue en cero. Si la rueda gira para un lado, el satélite gira para el otro:
  así se orienta un satélite sin gastar combustible.
]

#paso(1, [la velocidad angular del satélite])
El dato es la velocidad de la rueda *respecto del satélite*:
$omega_"rel" = 2000 dot 2 pi \/ 60 = 209,4$ rad/s. Respecto de un marco
inercial la rueda gira a $omega_s + omega_"rel"$. Momento angular total cero:
$ I_s omega_s + I_w (omega_s + omega_"rel") = 0 quad arrow.r.double quad omega_s = -(I_w omega_"rel") / (I_s + I_w) = -0,08374 "rad/s", $
o sea $4,798°$/s *al revés* que la rueda.

#paso(2, [el torque del motor])
La rueda pasa de $0$ a $omega_s + omega_"rel" = 209,36$ rad/s (inercial) en
$10$ s, a torque constante:
$tau = I_w Delta omega \/ Delta t = 0,06 dot 209,36 \/ 10 = 1,256$ N·m. Sobre
el satélite actúa $-1,256$ N·m. Los dos torques son internos y se cancelan en
la suma: por eso $bold(L)$ del conjunto no cambia. Cada parte, en cambio,
sí cambia su momento angular: $L_w = +12,56$ y $L_s = -12,56$ kg·m²/s.

#paso(3, [el tiempo para girar $90°$])
Mientras la rueda acelera, $omega_s$ crece linealmente de $0$ a su valor
final: el satélite gira el área bajo esa rampa,
$1/2 dot 4,798 dot 10 = 24,0°$. Al frenar la rueda pasa lo mismo al revés y
gira otros $24,0°$ (y queda quieto, porque $L$ vuelve a ser cero). Faltan
$90 - 48,0 = 42,0°$ a velocidad constante:
$t = 42,0 \/ 4,798 = 8,76$ s.

#paso(4, [la energía])
$ K = 1/2 I_s omega_s^2 + 1/2 I_w (omega_s + omega_"rel")^2 = 0,53 + 1315 = 1315 "J". $
El momento angular total es cero pero la energía no: el motor la sacó de la
batería. Conservar $bold(L)$ no dice nada de conservar $K$ (en el yo-yo del
modelo integrador pasa al revés: $L$ fijo y $K$ que baja).

#camino[
  Se escribió $L = 0$ con la velocidad *inercial* de cada parte, que es la
  única que vale en $L = I omega$: el momento angular se calcula respecto de
  un marco inercial.
]

#alternativa([tomar las $2000$ rpm como inerciales])[
  Si se toman las $2000$ rpm respecto del espacio (error típico), queda
  $I_s omega_s + I_w omega_"rel" = 0$ y $omega_s = -I_w omega_"rel" \/ I_s = -0,08378$ rad/s.
  La diferencia es del $0,04$ %: acá no importa porque la rueda es 2500
  veces más liviana (en inercia) que el satélite. Importaría con dos cuerpos
  parecidos — dos astronautas empujándose, una persona en una banqueta — y ahí
  hay que leer bien *respecto de qué* está dada la velocidad.
]

#final[$omega_s = -0,08374$ rad/s ($4,798°$/s, contrario a la rueda); $tau = 1,256$ N·m; mantener $8,76$ s; $K = 1315$ J, que puso la batería.]

== Ejercicio 7 — la partícula libre

#notacion[
  $bold(L)_O = bold(r) times bold(p)$ con $bold(p) = m bold(v)$ y $bold(r)$
  medido desde $O$ (Beer lo escribe $bold(H)_O$). El subíndice importa: el
  momento angular depende del punto.
]

#idea[
  El módulo de $bold(r) times bold(p)$ es $p$ por el *brazo*: la distancia
  de $O$ a la recta sobre la que va $bold(p)$. Si la partícula va en línea
  recta a velocidad constante, $p$ no cambia y el brazo tampoco (es siempre la
  distancia $d$ de $O$ a la misma recta). La dirección de $bold(r) times bold(p)$
  es perpendicular al plano que forman $O$ y la recta, que tampoco cambia.
]

#paso(1, [la demostración, con vectores])
La posición es $bold(r)(t) = bold(r)_0 + bold(v) t$. Entonces
$ bold(L)_O = bold(r) times m bold(v) = m (bold(r)_0 + bold(v) t) times bold(v) = m bold(r)_0 times bold(v) + m t (bold(v) times bold(v)) = m bold(r)_0 times bold(v), $
porque $bold(v) times bold(v) = 0$. No depende de $t$: es constante.

#paso(2, [el módulo])
$abs(bold(L)_O) = m v r sin phi$, con $phi$ el ángulo entre $bold(r)$ y
$bold(v)$, y $r sin phi = d$ es justamente la distancia de $O$ a la recta:
$abs(bold(L)_O) = m v d$.

#paso(3, [con una fuerza central])
$dif bold(L)_O \/ dif t = bold(r) times bold(F) = bold(tau)_O$. Si
$bold(F)$ apunta siempre hacia $O$ (o en contra), es paralela a $bold(r)$ y
el torque respecto de $O$ es cero: $bold(L)_O$ se conserva aunque la
trayectoria ya no sea recta y la rapidez cambie. Respecto de *otro* punto
$Q$, en cambio, $bold(F)$ ya no es paralela a $bold(r)_Q$ y hay torque:
$bold(L)_Q$ cambia. Eso es una órbita: la gravedad apunta al centro de la
Tierra y por eso se conserva $bold(L)$ *respecto de ese centro*, lo que da
el plano fijo de la órbita y la segunda ley de Kepler.

#camino[
  Se reemplazó $bold(r)(t)$ en la definición: es la demostración que se
  escribe en un renglón y que no depende de dibujos.
]

#alternativa([derivando respecto del tiempo])[
  $dif bold(L)_O \/ dif t = dot(bold(r)) times m bold(v) + bold(r) times m dot(bold(v)) = bold(v) times m bold(v) + bold(r) times bold(F)$.
  El primer término es cero siempre; el segundo es el torque, y es cero porque
  la partícula es libre ($bold(F) = 0$). Este camino tiene la ventaja de que
  sirve también para el inciso 2 sin cambiar nada: sólo hay que mirar cuándo
  $bold(r) times bold(F)$ se anula.
]

#final[$bold(L)_O = m bold(r)_0 times bold(v)$, constante, de módulo $m v d$. Con fuerza central respecto de $O$ se sigue conservando $bold(L)_O$, pero no el momento angular respecto de otro punto.]
