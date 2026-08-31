#import "../plantilla.typ": *

#modulo("Maniobras: Hohmann y rendez-vous")[
  Deducir la transferencia de Hohmann —el cambio de órbita circular que gasta
  menos combustible— a partir de la vis-viva del módulo 9 y del período del
  módulo 10; calcular cuánto tarda y en qué momento hay que lanzar para que el
  planeta de destino esté esperando; y resolver un rendez-vous entre dos
  satélites de la misma órbita con una *órbita de fasaje*, la misma idea con
  el reloj en el lugar de la distancia. Cierra la Parte III con el mapa
  completo de todo lo que se dedujo, de Newton hasta acá.
]

Los diez módulos anteriores dedujeron *de qué forma* es una órbita y *cuánto
dura*. Éste es el único de la Parte III que pregunta algo distinto: cómo
pasar de una órbita a otra gastando el mínimo combustible posible, y cómo
llegar al punto exacto del espacio en el momento exacto en que otro cuerpo
—un planeta, un satélite— también está ahí. Las dos preguntas se resuelven
con las mismas dos herramientas de siempre: la vis-viva y el período.

== La transferencia de Hohmann

#deduccion("por qué la elipse tangente a las dos circulares es la más barata")[
  Dos órbitas circulares coplanares, de radios $r_1 < r_2$, alrededor del
  mismo cuerpo central. Para pasar de una a la otra con el mínimo gasto, el
  camino más corto —literalmente, el de menor $Delta v$ total— es una elipse
  *tangente a las dos*: el perigeo de la elipse coincide con la órbita interior
  y el apogeo con la exterior. Tangente quiere decir que en cada uno de esos
  dos puntos la velocidad de la elipse es *paralela* a la velocidad circular
  que ahí se tiene o se quiere tener —los dos ábsides son perpendiculares al
  radio, igual que toda velocidad circular—, así que cada encendido es un
  simple cambio de *magnitud*, sin cambiar de dirección: el caso más barato
  que hay, porque no se paga ningún coseno.
]

$ a_t = (r_1 + r_2)/2 $ <m11-at>

Con la @m9-visviva evaluada en cada ábside se sacan las cuatro velocidades que
hacen falta —las dos circulares y las dos de la elipse de transferencia—:

$ v_1 = sqrt(mu/r_1), quad v_1' = sqrt(mu (2/r_1 - 1/a_t)), quad
  v_2' = sqrt(mu (2/r_2 - 1/a_t)), quad v_2 = sqrt(mu/r_2) $

$ Delta v_1 = v_1' - v_1, quad quad Delta v_2 = v_2 - v_2' $ <m11-deltav>

#clave[
  *Los dos encendidos son, los dos, para acelerar — si se va hacia afuera.*
  Como $a_t > r_1$, la @m9-visviva da $v_1' > v_1$: la elipse pasa por el
  perigeo *más rápido* que la circular interior, así que el primer encendido
  suma velocidad. Y como $a_t < r_2$, $v_2' < v_2$: la elipse llega al apogeo
  *más lenta* que la circular exterior, así que el segundo encendido *también*
  suma velocidad, para terminar de subir. Subir de órbita cuesta acelerar dos
  veces, no acelerar y después frenar.
]

#geometria[
  *Al revés —de la órbita exterior a la interior— los dos signos se dan vuelta,
  y la deducción no hay que rehacerla: alcanza con mirar la @m9-visviva otra
  vez.* Ahora $a_t$ sigue estando entre $r_1$ y $r_2$, pero se sale desde
  $r_2$: ahí $a_t < r_2$, así que la elipse pasa más *lenta* que la circular de
  partida, y el primer encendido *frena*. Al llegar a $r_1$, con $a_t > r_1$, la
  elipse llega más *rápida* que la circular de destino, y el segundo encendido
  *también frena*. Bajar de órbita cuesta frenar dos veces — nunca una
  combinación de las dos cosas, porque los dos ábsides de la transferencia
  son siempre los puntos más lento y más rápido de las cuatro velocidades en
  juego.
]

*El tiempo de vuelo.* La nave recorre exactamente la mitad de la elipse de
transferencia —de un ábside al otro—, así que tarda medio período, y el
período de *esa* elipse es la @m10-periodo con $a = a_t$:

$ t_v = tau_t/2 = pi sqrt(a_t^3/mu) $ <m11-tv>

*El ángulo de fase en el lanzamiento.* Para que el cuerpo de destino esté
en el punto de encuentro cuando la nave llega —no antes, no después— hace
falta calcular dónde tiene que estar *en el momento del lanzamiento*. La nave
recorre $180°$ en el tiempo $t_v$; el destino, con velocidad angular media
$n_2 = 2 pi \/ tau_2$ (su propio período orbital), recorre $n_2 t_v$ en ese
mismo tiempo. Si el encuentro es en $180°$ desde la posición de lanzamiento
de la nave, el destino tiene que arrancar $n_2 t_v$ *antes* de esa marca:

$ phi = 180° - n_2 t_v $ <m11-fase>

#cuidado[
  *La @m11-fase da el ángulo de lanzamiento, no el de encuentro.* Es el error
  más común de este tema: pensar que hay que apuntar al planeta *donde está*.
  Para cuando la nave llegue, el planeta ya se movió — y por eso el ángulo que
  hay que medir en el instante del lanzamiento es *menor* que $180°$, no igual.
  Apuntar directamente al planeta en su posición de hoy manda la nave a un
  punto vacío del espacio.
]

#ejemplo("Hohmann a Marte: cuándo lanzar y cuánto tarda", nivel: "a fondo")[
  _(Problema 5 de la sección de energía; S&Z 13.79, "Navegación
  interplanetaria".)_ Datos del apéndice F: $r_"Tierra" = 1,496 times 10^8$
  km, $r_"Marte" = 2,279 times 10^8$ km, $tau_"Marte" = 686,98$ días, y
  $mu_"Sol" = 1,327 times 10^11$ km³/s².

  *(a) Dirección de los encendidos.* Ida (Tierra a Marte, hacia afuera): los
  dos encendidos aceleran, en la dirección del movimiento —el cuadro azul de
  arriba—. Vuelta (Marte a Tierra, hacia adentro): los dos frenan, en contra
  del movimiento.

  *(b) El tiempo de vuelo.* Por la @m11-at,
  $ a_t = (1,496 + 2,279)/2 times 10^8 = 1,8875 times 10^8 " km" $
  y por la @m11-tv:
  $ t_v = pi sqrt((1,8875 times 10^8)^3/(1,327 times 10^11)) = pi (7,119 times 10^6) = 2,237 times 10^7 " s" $
  $ t_v = 2,237 times 10^7 " s" = 258,8 " días" approx 8,5 " meses" $

  #fig([La transferencia de Hohmann Tierra–Marte (a escala aproximada de
  radios). La nave recorre $180°$ en $258,8$ días; Marte, mientras tanto,
  recorre $135,6°$ de su propia órbita — por eso en el lanzamiento tiene que
  estar apenas $44,4°$ adelante de la Tierra, no en el punto de encuentro.],
  fig-hohmann)

  *(c) El ángulo Sol–Marte / Sol–Tierra en el lanzamiento.* La velocidad
  angular media de Marte es
  $ n_"Marte" = (360°)/(686,98) = 0,5240 "°/día" $
  y en los $258,8$ días del viaje recorre
  $ n_"Marte" t_v = (0,5240)(258,8) = 135,6° $
  Por la @m11-fase:
  $ phi = 180° - 135,6° = 44,4° $

  #clave[
    *Marte tiene que estar sólo $44°$ adelante de la Tierra, no "enfrente" ni
    "del otro lado del Sol".* Es la cifra que hace que las misiones a Marte
    tengan una *ventana de lanzamiento*, y no cualquier fecha sirva: la
    geometría Tierra–Marte pasa por ese ángulo de $44,4°$ una vez cada
    *período sinódico* —cada $780$ días aproximadamente—, no todos los días.
  ]
]

== Rendez-vous: encontrarse con algo en la misma órbita

Hohmann cambia el *tamaño* de la órbita. El rendez-vous es otro problema: dos
cuerpos que ya comparten la *misma* órbita circular, pero no están en el
mismo punto de ella, y hay que hacer que coincidan. Subir o bajar de órbita
no alcanza —volver a la misma órbita circular no cambia dónde se está en
ella—, así que la herramienta es distinta: una *órbita de fasaje*, una
elipse que sale del punto de partida y *vuelve a él* después de exactamente
una vuelta, tardando un tiempo distinto del que tardaría la órbita circular.

#deduccion("cuánto tiene que durar la órbita de fasaje")[
  El *chaser* está en el punto $theta = 0$ de la órbita circular; el *blanco*
  está $Delta phi$ adelante, en la misma órbita, moviéndose con el mismo
  período $T$. El chaser sale de $theta = 0$ hacia una elipse tangente ahí
  mismo —ese punto es un ábside de la nueva órbita, apogeo si la elipse baja
  el otro lado—, de período $T'$. Después de *una* vuelta completa de esa
  elipse, en un tiempo $T'$, el chaser vuelve exactamente al mismo punto
  físico $theta = 0$ — porque los ábsides de una elipse no precesan.

  Mientras tanto el blanco, que sigue en la circular, avanzó $360° dot T' \/
  T$ desde su posición original. Para que el encuentro sea exacto, esa
  posición tiene que coincidir con $theta = 0$ — es decir, el blanco, que
  arrancó $Delta phi$ adelante, tiene que completar la vuelta entera y volver
  a $theta = 0$ en ese mismo tiempo:
  $ Delta phi + 360° (T'/T) = 360° $
]

$ T'/T = 1 - (Delta phi)/(360°) $ <m11-fasaje>

#clave[
  *El chaser no persigue al blanco: los dos llegan al mismo lugar por caminos
  distintos.* El blanco completa una vuelta entera de la circular ($360°$),
  arrancando con $Delta phi$ de ventaja. El chaser completa una vuelta entera
  de *su propia* elipse, que dura menos tiempo si $Delta phi > 0$ —el blanco
  adelante exige $T' < T$, una órbita más rápida—. Los dos tardan lo mismo en
  volver al punto de partida del chaser, porque $T'$ se calculó exactamente
  para eso.
]

Con $a' = (r + r_p') \/ 2$ (si $r$ es el apogeo de la elipse de fasaje, el
punto de partida) y la @m10-periodo invertida, la @m11-fasaje se traduce en el
tamaño de la órbita:

$ a' = r (T'/T)^(2\/3) $ <m11-fasaje-a>

#geometria[
  *Cuanto más grande el salto de fase, más se hunde la órbita de fasaje — y
  eso tiene un límite físico.* Si $Delta phi$ es grande, la @m11-fasaje pide
  $T' \/ T$ chico, y la @m11-fasaje-a da un $a'$ mucho menor que $r$: el
  perigeo de esa elipse puede terminar *adentro* del cuerpo central, igual
  que le pasó al LEM del módulo 10. La salida no es forzar esa órbita: es
  repartir el mismo cambio de fase en *varias* vueltas de fasaje ($N > 1$ en
  vez de $N=1$ en la @m11-fasaje, con $Delta phi \/ N$ en lugar de $Delta
  phi$), que pide un $T'$ más parecido a $T$ y por lo tanto un $Delta v$
  menor — al precio de tardar $N$ veces más.
]

#ejemplo("Encontrarse con un satélite un cuarto de vuelta adelante", nivel: "a fondo")[
  _(Problema 10: "investigar, formular una solución, y encontrar una solución
  exacta para un caso determinado".)_ Dos satélites en la misma órbita
  circular geosíncrona —la del módulo 6, $r = 42 thin 140$ km, $tau = 86 thin
  162$ s, $v_"circ" = 3,08$ km/s—, con el blanco $Delta phi = 90°$ adelante
  del chaser. Se resuelve con una sola vuelta de fasaje ($N=1$).

  *El tamaño de la órbita de fasaje.* Por la @m11-fasaje,
  $ T'/T = 1 - (90°)/(360°) = 0,75 $
  y por la @m11-fasaje-a:
  $ a' = (42 thin 140)(0,75)^(2\/3) = (42 thin 140)(0,8256) = 34 thin 790 " km" $
  Como el punto de partida es el *apogeo* de la elipse de fasaje —el chaser
  tiene que *bajar* para ir más rápido—, el perigeo sale de $a' = (r + r_p')
  \/ 2$:
  $ r_p' = 2 a' - r = 2 (34 thin 790) - 42 thin 140 = 27 thin 440 " km" $
  muy por encima de la superficie terrestre: la maniobra es físicamente
  realizable sin repartir en varias vueltas.

  #fig([El rendez-vous por fasaje: el chaser baja a una elipse de fasaje
  tangente en su propio punto de partida —que ahí es el apogeo—, completa una
  vuelta en tres cuartos del período circular, y llega exactamente cuando el
  blanco, que mientras tanto recorrió $270°$, también llega.],
  fig-rendezvous-phasing)

  *El costo, en $Delta v$.* Con la @m9-visviva, la rapidez de la elipse de
  fasaje en su apogeo (el punto de partida):
  $ v_a'^2 = mu (2/r - 1/a') = (398 thin 600) (2/(42 thin 140) - 1/(34 thin 790)) = 7,459 $
  $ v_a' = 2,731 " km/s" $
  El primer encendido frena de $v_"circ"$ a $v_a'$; el segundo, al volver, es
  igual y contrario para recircularizar:
  $ Delta v_1 = 3,08 - 2,731 = 0,349 " km/s", quad quad Delta v_"total" = 2 (0,349) = 0,698 " km/s" $

  y el encuentro ocurre a los $T' = 0,75 (86 thin 162) = 64 thin 622$ s, unas
  $17,9$ horas después del primer encendido.

  #clave[
    *Casi $700$ m/s para cerrar un cuarto de vuelta en una sola órbita es
    caro — y la @m11-fasaje-a dice exactamente por qué.* Si en vez de una
    vuelta se usaran dos ($N=2$, cerrando $45°$ por vuelta), $T' \/ T = 1 -
    45\/360 = 0,875$, mucho más cerca de $1$ que $0,75$: la órbita de fasaje
    se parece más a la circular, pide menos $Delta v$, y tarda el doble en
    total. Es el mismo intercambio que el Júpiter del módulo 9 —rápido y caro
    contra lento y barato—, ahora con el tiempo de encuentro en el lugar de
    la energía de captura.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  El *Problema 5* (Hohmann a Marte) es el ejemplo a fondo del tema central del
  módulo. El *Problema 10* (rendez-vous) es abierto en la guía —pide
  investigar y proponer, no un número cerrado— y se resolvió acá con el
  método general de la órbita de fasaje más un caso numérico concreto, que es
  lo que el enunciado pide en su parte (C).
]

== El mapa completo

Acá cierra la Parte III, y conviene verla entera de una vez: once resultados,
de dos axiomas —las leyes de Newton y la *definición* del momento angular—, y
cada flecha es una sustitución, nunca una hipótesis nueva.

#fig([El mapa de todo lo que se dedujo en la Parte III, redibujado de la fig.
B.1 del apéndice B de Curtis. Los dos recuadros de trazo grueso son los dos
puntos de partida —ningún otro recuadro asume nada que no esté ya en una
flecha entrante—. La notación es la de Curtis, no la de este apunte: $theta$
en vez de $nu$, y $mu = G(m_1+m_2)$ —anotado a mano en el original, con la
misma fórmula del módulo 8— en vez de $mu$ solo.], fig-roadmap-curtis)

#notacion[
  *Cuatro letras cambian entre este mapa y el resto del apunte.* Curtis usa
  $theta$ donde este apunte usa $nu$ para la anomalía verdadera, y escribe la
  ecuación de la órbita, la vis-viva y el período exactamente como acá, sólo
  que sin nombrarle "vis-viva" a la del medio. El casillero de $t = h^3 \/
  mu^2 integral_0^theta d theta.alt \/ (1+e cos theta.alt)^2$ —las ecuaciones
  de Kepler que relacionan anomalía con tiempo— es lo único del mapa que este
  apunte no desarrolló: no está en el plan de las 17 semanas ni en la guía
  (§3 del PDP), y entra sólo como anexo si sobra lugar.
]

#clave[
  *Léase el mapa de arriba hacia abajo y de izquierda a derecha, y cada
  módulo de este apunte aparece en su lugar.* Newton y la definición de $h$
  son los módulos 6 y 7; la ecuación de dos cuerpos y la conservación de la
  energía, los módulos 6 y 8; la ecuación de la órbita y el potencial
  eficaz —que no está en el mapa de Curtis, porque Curtis no lo usa—, el
  módulo 9; las dos leyes de Kepler que faltaban y el período, el módulo 10.
  Lo único que este mapa agrega y que no tiene módulo propio es $v_r = (mu \/
  h) thin e sin theta$: la componente *radial* de la velocidad, que ninguno
  de los ejemplos de la guía necesitó calcular por separado —siempre alcanzó
  con $v_perp = h\/r$ en los ábsides, o con la vis-viva completa.
]

== Lo que se usa después

1. *La transferencia de Hohmann.* Es el bloque de construcción de toda
   maniobra orbital más allá de la Parte III: cualquier cambio de órbita que
   no sea instantáneo se piensa como una sucesión de arcos tangentes, cada uno
   resuelto con la misma vis-viva.

2. *La órbita de fasaje, y el intercambio tiempo-contra-$Delta v$.* Vuelve
   cada vez que dos cuerpos comparten órbita y hay que sincronizarlos —desde
   un rendez-vous con una estación hasta una constelación de satélites que
   hay que reordenar.

3. *El mapa entero.* Es el resumen de qué depende de qué en toda la mecánica
   orbital de dos cuerpos, y la referencia más rápida para no perderse en un
   problema largo: cualquier cantidad que aparezca en un enunciado tiene, en
   ese mapa, un camino de una sola dirección hasta las leyes de Newton.
