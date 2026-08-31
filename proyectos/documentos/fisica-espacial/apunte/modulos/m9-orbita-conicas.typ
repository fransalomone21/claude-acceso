#import "../plantilla.typ": *

#modulo("El potencial eficaz y la ecuación de la órbita")[
  Meter la conservación del momento angular adentro de la conservación de la
  energía y quedarte con un problema de *una sola variable*, $r$, al que se le
  aplica tal cual el diagrama de energía del módulo 5; leer en ese diagrama, sin
  resolver ninguna ecuación diferencial, si la órbita es circular, elíptica,
  parabólica o hiperbólica; y después *resolverla*, con el cambio de variable
  que convierte la ecuación de movimiento en la ecuación de una cónica —
  $r = p \/ (1 + e cos nu)$—, que es la fórmula con la que se trabaja de acá
  hasta el final de la materia.
]

Éste es el módulo central de la Parte III, y el único que hace las dos cosas: la
mitad cualitativa —el potencial eficaz, que contesta *qué clase* de órbita es
sin integrar nada— y la mitad cuantitativa —la ecuación de la órbita, que dice
*cuál* es. Las dos salen del mismo ingrediente: sustituir $dot(theta) = h \/
r^2$, que es la conservación del momento angular del módulo 7, adentro de la
energía y de la ecuación de movimiento.

Lo que se gana es enorme y conviene decirlo antes de empezar. El problema de
partida tiene dos coordenadas, $r$ y $theta$, y una ecuación diferencial de
segundo orden acoplada para cada una. Después de este módulo hay *una* ecuación
para $r$ —y encima integrada— y $theta$ sale del momento angular. Ninguna de las
dos cosas costó una hipótesis nueva: las dos son la conservación de $bold(L)$,
usada dos veces.

== El potencial eficaz: dos variables que se vuelven una

#deduccion("el potencial eficaz")[
  En coordenadas polares la velocidad es $bold(v) = dot(r) hat(r) + r dot(theta)
  hat(theta)$ (módulo 1), y como los dos versores son perpendiculares,
  $ v^2 = dot(r)^2 + r^2 dot(theta)^2 $
  así que la energía cinética se parte en dos pedazos que no se mezclan:
  $ T = 1/2 m v^2 = 1/2 m dot(r)^2 + 1/2 m r^2 dot(theta)^2 $
  El primero es el movimiento de acercarse o alejarse; el segundo, el de girar.
  Ahora entra el módulo 7: la fuerza es central, así que $L = m r^2 dot(theta)$
  es *constante*, y de ahí $dot(theta) = L \/ (m r^2)$. Sustituyendo en el
  segundo término,
  $ 1/2 m r^2 dot(theta)^2 = 1/2 m r^2 (L/(m r^2))^2 = L^2/(2 m r^2) $
  y el $dot(theta)$ desapareció: lo que quedó depende sólo de $r$.
]

$ T = 1/2 m dot(r)^2 + L^2/(2 m r^2) $ <m9-T>

Sumando la energía potencial, la energía mecánica total queda

$ E = 1/2 m dot(r)^2 + underbrace(L^2/(2 m r^2) + U(r), U_"ef" (r)) $ <m9-E>

#definicion("potencial eficaz")[
  $ U_"ef" (r) = L^2/(2 m r^2) + U(r) = L^2/(2 m r^2) - (mu m)/r $ <m9-Uef>
  Es la suma de la energía potencial verdadera y del término que quedó al
  meterle la conservación del momento angular a la energía cinética. Con él, la
  @m9-E tiene *exactamente la forma* de un problema unidimensional:
  $E = 1/2 m dot(r)^2 + U_"ef" (r)$, una partícula que se mueve sobre el eje
  $r$ en el potencial $U_"ef"$.
]

#clave[
  *Éste es el paso que hace todo lo demás.* El problema tenía dos coordenadas;
  ahora tiene una. Y no se perdió nada: $theta$ no desapareció, quedó guardada
  en $L$, y se recupera cuando haga falta integrando
  $dot(theta) = L \/ (m r^2)$.

  La consecuencia práctica es que *toda la maquinaria del módulo 5 se aplica sin
  cambiarle una letra*: los puntos donde $E = U_"ef"$ son puntos de retorno
  —ahí $dot(r) = 0$—, la distancia vertical entre $E$ y la curva es la energía
  cinética radial, y un mínimo de $U_"ef"$ es una posición de equilibrio. Sólo
  que ahora «equilibrio» quiere decir *órbita circular*, y «punto de retorno»
  quiere decir *perigeo o apogeo*.
]

#cuidado[
  *El signo del último término, y una errata del apunte de la cátedra.* La hoja
  de clase escribe
  $E_"mec" = 1/2 m dot(r)^2 + L^2 \/ (2 m r^2) - U(r)$, con un *menos* delante de
  $U(r)$, y va un *más*. Confirmado ampliando el escaneo: la misma hoja define
  $U(r) = -G m_1 m_2 \/ r$ —o sea que el menos ya está adentro de $U$— y la
  llave del renglón siguiente agrupa los dos últimos términos bajo el nombre
  «potencial eficaz», que es la *suma* de los dos.

  Copiar el menos da $U_"ef" = L^2 \/ (2 m r^2) + mu m \/ r$, que es *positiva
  para todo $r$* y no tiene pozo: con ese signo ninguna órbita sería ligada, ni
  siquiera la de la Luna. Es la clase de errata que no se nota hasta que el
  gráfico sale sin mínimo.
]

#notacion[
  *La cátedra escribe este módulo con otras letras, y cambian
  cuatro.* La hoja de clase usa $V$ para energía potencial, $ell$ para el momento
  angular y $alpha$ para la constante de la ley de Newton:

  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    table.header([*Cantidad*], [*Este apunte*], [*Hoja de clase*]),
    [energía potencial gravitatoria], [$U(r) = -mu m \/ r$], [$V_g = -alpha \/ r$],
    [término centrífugo], [$L^2 \/ (2 m r^2)$], [$V_c = ell^2 \/ (2 m r^2)$],
    [potencial eficaz], [$U_"ef"$], [$V_"eff"$],
    [energía mecánica], [$E$], [$E_M$],
    [momento angular], [$L$], [$ell$],
  )

  *Y ojo con $alpha$*: en la hoja está anotado $alpha = G M$, pero para que
  $V_g$ sea una *energía* tiene que ser $alpha = G M m$ — si no, $V_g$ es
  energía por unidad de masa y no se le puede sumar $V_c$, que sí lleva la $m$.
  Este apunte evita el problema no dándole nombre propio: escribe
  $-mu m \/ r$, con $mu = G(m_1 + m_2)$ del módulo 8.
]

== Lo que el diagrama dice sin resolver nada

#fig([El potencial eficaz. La rama azul punteada es el término centrífugo, que
domina cerca del origen; la roja punteada es la gravedad, que domina lejos. La
suma —la curva negra— tiene un *pozo*, y el nivel de $E$ que se apoye en él
decide la órbita: el fondo es la circunferencia, un nivel negativo corta en dos
puntos y da una elipse entre $r_p$ y $r_a$, $E = 0$ es la parábola y $E > 0$ la
hipérbola. Es el diagrama del módulo 5, con $U_"ef"$ en lugar de $U$.],
fig-potencial-eficaz)

Las tres cosas que se leen en esa figura, en orden de importancia:

#clave[
  *Primera: hay una barrera centrífuga, y por eso un satélite con $L eq.not 0$
  nunca llega al centro.* Cuando $r arrow.r 0$, el término $L^2 \/ (2 m r^2)$
  crece como $1 \/ r^2$ y la gravedad sólo como $1 \/ r$: gana el primero, y
  $U_"ef" arrow.r + oo$. Ningún valor finito de $E$ alcanza para llegar a
  $r = 0$.

  Ésta es la respuesta a una pregunta que el módulo 6 no podía contestar: *por
  qué la Luna no se cae a la Tierra si la gravedad la atrae.* No es que algo la
  empuje para afuera; es que llegar al centro exigiría anular $dot(theta)$, y
  $r^2 dot(theta)$ no puede cambiar.
]

#geometria[
  *El término centrífugo no es una fuerza, y la palabra engaña.* $L^2 \/ (2 m
  r^2)$ es energía *cinética* —la del giro— disfrazada de energía potencial. Se
  la puede tratar como potencial únicamente porque, con $L$ constante, depende
  sólo de $r$; el disfraz es legítimo y es todo el truco del módulo.

  El precio de olvidarlo se paga en el sistema de referencia: *nada de esto
  necesita un sistema no inercial*. La deducción de la @m9-Uef se hizo entera en
  el sistema inercial del módulo 8, sin fuerzas ficticias. Confundir este
  término con «la fuerza centrífuga» es el error que hace escribir un $-$ donde
  va un $+$.
]

*Segunda: el fondo del pozo es la órbita circular.* Se lo encuentra derivando la
@m9-Uef e igualando a cero. Con $L = m h$ —la forma específica del módulo 7—:

$ (d U_"ef")/(d r) = -L^2/(m r^3) + (mu m)/r^2 = 0 quad ==> quad r_0 = L^2/(mu m^2) = h^2/mu $ <m9-r0>

y evaluando ahí,

$ U_"ef" (r_0) = E_"mín" = - (mu^2 m)/(2 h^2) = - (mu m)/(2 r_0) $ <m9-Emin>

#clave[
  *La última igualdad es una verificación, no una coincidencia.* El módulo 6
  había obtenido, por un camino completamente distinto —igualando la gravedad a
  la fuerza centrípeta—, que una órbita circular de radio $r$ tiene
  $E = -mu m \/ (2 r)$. Acá vuelve a salir, ahora como *el mínimo de una
  función*, sin haber supuesto que la órbita fuera circular.

  Y de paso queda una lectura que el módulo 6 no daba: una órbita circular es
  la órbita *de mínima energía para un momento angular dado*. No se puede tener
  el mismo $L$ con menos energía.
]

*Tercera: el signo de $E$ clasifica la órbita, y la clasifica en cuatro casos, no
en dos.* El módulo 6 había llegado hasta acá con $U$ sola y distinguía dos:
ligada o no. Con $U_"ef"$ aparecen los cuatro:

#table(
  columns: (auto, auto, 1fr),
  align: (center, left, left),
  table.header([*Energía*], [*Corte con $U_"ef"$*], [*Órbita*]),
  [$E = E_"mín"$], [un punto, $r = r_0$], [circunferencia: $r$ no cambia nunca],
  [$E_"mín" < E < 0$], [dos puntos, $r_p$ y $r_a$], [elipse: $r$ oscila entre los dos ábsides],
  [$E = 0$], [uno, y el otro en el infinito], [parábola: llega al infinito con $v = 0$],
  [$E > 0$], [uno solo], [hipérbola: llega al infinito con $v eq.not 0$],
)

#guia("el Problema 1, otra vez")[
  El *Problema 1* de la sección de energía —la curva $U(x)$ con los puntos $A$,
  $B$ y $C$— quedó resuelto entero en el módulo 5, y lo que se aprendió ahí a
  leer es exactamente esta figura: puntos de retorno, equilibrio estable en el
  fondo del pozo, y la energía cinética como distancia vertical. *Este módulo no
  agrega una técnica nueva de lectura: agrega la curva a la que hay que
  aplicarla.*
]

== La ecuación de la órbita

El diagrama dice de qué clase es la órbita, pero no dice su forma. Para eso hay
que integrar la ecuación de movimiento, y el problema es que en función del
*tiempo* no se puede hacer de cabeza. La salida es cambiar de variable
independiente.

#deduccion("por qué se cambia t por theta, y r por 1/r")[
  Con la fuerza central dirigida hacia $O$, las dos ecuaciones de movimiento en
  polares son (Beer §12.11, ecs. 12.31 y 12.32, pág. 736)
  $ m (dot.double(r) - r dot(theta)^2) = -F, quad quad m (r dot.double(theta) + 2 dot(r) dot(theta)) = 0 $
  La segunda no hace falta: es la conservación del momento angular otra vez, y
  conviene usarla en su forma integrada, $r^2 dot(theta) = h$ (Beer ec. 12.33).

  *El primer cambio: sacarse el tiempo de encima.* De $dot(theta) = h \/ r^2$
  sale $d \/ (d t) = (h \/ r^2) thin d \/ (d theta)$, y con eso toda derivada
  temporal se convierte en una derivada respecto del ángulo. Lo que se gana es
  que la incógnita pasa a ser *la forma de la trayectoria*, $r(theta)$, y no la
  historia del recorrido, $r(t)$ — que es más información de la que el problema
  pide.

  *El segundo cambio: llamar $u = 1 \/ r$.* Aplicando lo anterior dos veces
  (Beer ecs. 12.35 y 12.36) queda $dot(r) = -h thin d u \/ d theta$ y
  $dot.double(r) = -h^2 u^2 thin d^2 u \/ d theta^2$, y al sustituir en la
  primera ecuación de movimiento todo el desorden se cancela:
  $ (d^2 u)/(d theta^2) + u = F/(m h^2 u^2) $
  (Beer ec. 12.37, pág. 736.) *Ésa es la razón del cambio*: con $u$ la ecuación
  es lineal en el miembro izquierdo, y con $r$ no lo es.
]

Hasta acá vale para *cualquier* fuerza central. Recién ahora entra la
gravitación: con $F = G M m \/ r^2 = mu m u^2$, el miembro derecho se simplifica
entero y queda constante (Beer ec. 12.38, pág. 737):

$ (d^2 u)/(d theta^2) + u = mu/h^2 $ <m9-binet>

#clave[
  *Esa ecuación es un oscilador armónico con un término constante*, la misma que
  gobierna una masa colgada de un resorte. Su solución es la constante
  particular $mu \/ h^2$ más la solución general del homogéneo, $C cos(theta -
  theta_0)$. Eligiendo el eje polar de modo que $theta_0 = 0$:
  $ 1/r = mu/h^2 + C cos theta $
  Y ése es el momento en que las cónicas dejan de ser un nombre: la expresión de
  arriba *es* la ecuación polar de una sección cónica con el foco en el origen.
  No se buscaron elipses ni se supusieron: salieron de integrar.
]

Definiendo la *excentricidad* $e = C h^2 \/ mu$ (Beer ec. 12.40) y el
*parámetro* $p = h^2 \/ mu$, la ecuación se escribe en la forma en que se usa:

$ r = p/(1 + e cos nu), quad quad p = h^2/mu $ <m9-orbita>

(Beer ec. 12.39', pág. 737.)

#geometria[
  *El ángulo de la @m9-orbita no es cualquiera: se mide desde el perigeo.* Al
  elegir $theta_0 = 0$ se puso el eje polar en la dirección donde $cos theta =
  1$, o sea donde $r$ es *mínimo*. Ese ángulo tiene nombre propio —*anomalía
  verdadera*, $nu$— y por eso este apunte deja de escribir $theta$ a partir de
  acá: $theta$ es una coordenada cualquiera, $nu$ es la que se mide desde el
  perigeo.

  Confundirlas es el error más caro del módulo, porque no hace fallar la cuenta:
  la hace dar un número creíble. Si el enunciado da un ángulo medido desde otro
  lado —desde el eje $x$, desde el nodo, desde la posición de lanzamiento—, hay
  que sumarle o restarle el ángulo del perigeo antes de meterlo en la
  @m9-orbita.
]

== Las cónicas, y el puente entre la energía y la forma

#fig([Las cuatro cónicas con el *mismo* parámetro $p$ y el mismo foco: lo único
que las distingue es $e$. Como $r = p$ cuando $nu = 90°$, las cuatro pasan por
los dos mismos puntos, y ahí se ve que el parámetro es una longitud de la
órbita, no un factor de escala. La circunferencia ($e = 0$) es la única que no
tiene perigeo distinguido.], fig-conicas)

La clasificación por $e$ sale de mirar cuándo el denominador de la @m9-orbita se
anula, que es cuando $r arrow.r oo$ (Beer pág. 738):

#table(
  columns: (auto, auto, auto, 1fr),
  align: (center, center, center, left),
  table.header([*$e$*], [*Órbita*], [*$E$*], [*Por qué*]),
  [$0$], [circunferencia], [$E_"mín"$], [$r = p$ para todo $nu$],
  [$0 < e < 1$], [elipse], [$< 0$], [el denominador nunca se anula: $r$ queda acotado],
  [$1$], [parábola], [$0$], [se anula en $nu = 180°$, y sólo ahí],
  [$> 1$], [hipérbola], [$> 0$], [se anula en dos ángulos: las dos asíntotas],
)

Las columnas de $e$ y de $E$ no están puestas una al lado de la otra por
analogía: son la misma cosa, y la cuenta que las une entra en cinco renglones.

#deduccion("la relación entre la excentricidad y la energía")[
  Se evalúa la energía en el perigeo, que es el punto donde la cuenta es más
  corta: ahí $dot(r) = 0$, así que toda la velocidad es transversal y
  $v_p = h \/ r_p$, con $r_p = p \/ (1 + e)$ de la @m9-orbita. Entonces
  $ E = 1/2 m v_p^2 - (mu m)/r_p = (m h^2)/(2 r_p^2) - (mu m)/r_p $
  Usando $h^2 = mu p$ y $1 \/ r_p = (1 + e) \/ p$:
  $ E = (m mu p)/2 (1+e)^2/p^2 - (mu m)(1+e)/p = (mu m)/p [ (1+e)^2/2 - (1+e) ] $
  y sacando factor común $(1+e) \/ 2$ queda $(1+e)(e-1) \/ 2 = (e^2 - 1) \/ 2$:
]

$ E = (mu m (e^2 - 1))/(2 p) = (mu^2 m (e^2 - 1))/(2 h^2) quad <==> quad e = sqrt(1 + (2 E h^2)/(mu^2 m)) $ <m9-e-E>

#clave[
  *Ésta es la ecuación que cierra el módulo.* Dice que la forma de la órbita no
  es un dato independiente: está fijada por los dos escalares que se conservan,
  $E$ y $h$. Dos naves con la misma energía y el mismo momento angular recorren
  *la misma órbita*, aunque hayan llegado por caminos distintos.

  Y hace verificable la tabla de arriba, que hasta recién eran dos
  clasificaciones separadas: $E < 0 <==> e < 1$, $E = 0 <==> e = 1$,
  $E > 0 <==> e > 1$, y $E = E_"mín" <==> e = 0$ — donde el radicando se anula,
  que es justo la @m9-Emin.
]

Para la elipse hay una forma mucho más cómoda. Como $p = a (1 - e^2)$, la
@m9-e-E se despeja en

$ E = - (mu m)/(2 a) quad quad "y de ahí" quad quad v^2 = mu (2/r - 1/a) $ <m9-visviva>

#clave[
  *La segunda de las dos es la ecuación de la que más se va a usar en toda la
  materia*, y se la conoce como *ecuación vis-viva*. Sale de escribir
  $E = 1/2 m v^2 - mu m \/ r$ e igualar a $-mu m \/ (2 a)$: no hay ningún paso
  intermedio.

  Lo que la hace valiosa es que relaciona *tres* cosas y ninguna es un ángulo:
  la rapidez en un punto, la distancia a ese punto y el tamaño de la órbita. Si
  se conocen dos, sale la tercera. Casi todos los problemas de las secciones de
  energía y de maniobras se resuelven con ella más la conservación de $h$.

  Y contiene los dos casos del módulo 6 como casos particulares: con $a = r$
  (circunferencia) da $v_"circ"^2 = mu \/ r$, y con $a arrow.r oo$ (parábola) da
  $v_"esc"^2 = 2 mu \/ r$.
]

== La elipse y sus seis números

#fig([La elipse orbital y todo lo que se le mide. Arriba de la línea de ábsides,
lo que se mide *desde el foco*: el parámetro $p$, el radio $r$ de un punto
cualquiera y su anomalía verdadera $nu$. Abajo, lo que se mide *desde el
centro*: los semiejes $a$ y $b$, y las dos distancias de ábside. El cuerpo
central está en el foco $F$, nunca en el centro $C$ — y la distancia entre los
dos es exactamente $a e$.], fig-elipse-geometria)

De la @m9-orbita, evaluada en $nu = 0$ y $nu = 180°$, salen las dos distancias
de ábside; y de ellas, todo lo demás:

$ r_p = p/(1 + e), quad r_a = p/(1 - e), quad quad e = (r_a - r_p)/(r_a + r_p) $ <m9-absides>

$ a = (r_p + r_a)/2, quad quad b = sqrt(r_p thin r_a), quad quad p = a (1 - e^2) $ <m9-semiejes>

Las dos primeras de la @m9-semiejes son Beer ecs. 12.46 y 12.47, pág. 740, y las
dos salen de geometría de la elipse, no de física: el semieje mayor es la *media
aritmética* de los dos radios de ábside y el semieje menor es su *media
geométrica*. La primera es inmediata —$r_p + r_a = 2a$ mirando la figura—; la
segunda sale de $b^2 = a^2 - c^2$ con $c = a - r_p$.

#clave[
  *Y una relación que ahorra la mitad de las cuentas.* Sumando las dos
  expresiones de la @m9-absides y usando $p = h^2 \/ mu$:
  $ 1/r_p + 1/r_a = (2 mu)/h^2 $ <m9-suma-inversos>
  (Beer, problema 12.102, citada en la pág. 744.) Con los dos radios de ábside
  se obtiene $h$ *directamente*, sin pasar por $e$ ni por $a$ — y con $h$ salen
  las dos velocidades, porque en los ábsides $v = h \/ r$.
]

#ejemplo("El satélite del Ej. 4, ahora con la ecuación de la órbita")[
  _(Ejercicio 4 de «Conservación impulso angular» y Problema 4 de la sección de
  energía: son el mismo satélite.)_ El módulo 7 resolvió este satélite —perigeo
  a 400 km, apogeo a 4000 km— usando sólo la conservación de $h$, y para las dos
  posiciones intermedias tuvo que *anticipar* la @m9-orbita. Acá se cierra ese
  préstamo: se calcula la órbita entera desde cero.

  *Los seis números.* Con $r_p = 6778$ km y $r_a = 10 thin 378$ km, la
  @m9-absides y la @m9-semiejes dan directamente
  $ e = (10 thin 378 - 6778)/(10 thin 378 + 6778) = 3600/(17 thin 156) = 0,2098 $
  $ a = (6778 + 10 thin 378)/2 = 8578 " km", quad p = a (1 - e^2) = 8578 (0,9560) = 8200 " km" $

  *El momento angular, ahora deducido y no medido.* De $p = h^2 \/ mu$, con
  $mu = 3,986 times 10^5$ km³/s²:
  $ h^2 = mu p = (3,986 times 10^5)(8200) = 3,269 times 10^9 ==> h = 57 thin 172 " km"^2\/"s" $

  #clave[
    *Ese número ya estaba.* El módulo 7 lo obtuvo midiendo, de la figura de la
    guía: $h = r_P v_P = (6778)(8,435) = 57 thin 172$ km²/s. Acá salió de las
    *dos alturas del enunciado y nada más* — sin usar ninguna de las cuatro
    velocidades del dibujo.

    Eso quiere decir que las velocidades de la figura no eran un dato
    independiente: estaban determinadas por la geometría. Y da vuelta el
    ejercicio: en vez de leer velocidades y verificar que $h$ coincide, se puede
    calcular $h$ de las alturas y *predecir* las velocidades,
    $ v_p = h/r_p = (57 thin 172)/6778 = 8,435 " km/s", quad v_a = h/r_a = (57 thin 172)/(10 thin 378) = 5,509 " km/s" $
    que es exactamente lo que dice el dibujo, en las cuatro cifras.
  ]

  *Las dos posiciones intermedias, sin momento angular.* Con la @m9-orbita y las
  anomalías que marca la figura:
  $ nu = 96,09° ==> r = 8200/(1 + 0,2098 (-0,1061)) = 8200/(0,9777) = 8387 " km" $
  $ nu = 102,1° ==> r = 8200/(1 + 0,2098 (-0,2096)) = 8200/(0,9560) = 8577 " km" $
  Los mismos $8387$ y $8577$ km que el módulo 7 sacó proyectando velocidades con
  $h = r v cos gamma$.

  *La energía, y el control cruzado.* Por la @m9-visviva,
  $ E\/m = - mu/(2 a) = - (3,986 times 10^5)/(17 thin 156) = -23,23 " km"^2\/"s"^2 $
  y metiendo eso y $h$ en la @m9-e-E:
  $ e^2 = 1 + (2 (-23,23)(57 thin 172)^2)/((3,986 times 10^5)^2) = 1 - 0,9559 = 0,0441 ==> e = 0,210 $

  #clave[
    *Tres caminos independientes, el mismo número.* La excentricidad salió de
    las dos alturas ($0,2098$), de $E$ y $h$ ($0,210$), y quedó comprobada
    contra dos radios intermedios medidos por momento angular. *Ésa es la manera
    de usar un enunciado que da datos de más:* no elegir uno, sino cerrar el
    círculo — si los tres caminos no coinciden, hay un error de lectura antes de
    seguir.
  ]
]

#ejemplo("Frenar en Júpiter: de la parábola a la elipse", nivel: "a fondo")[
  _(Problema 7 de la sección de energía; Beer 13.100.)_ Una nave llega a Júpiter
  por una trayectoria *parabólica* y alcanza el punto $A$, a $350 times 10^3$ km
  del centro, con $v_A = 26,9$ km/s perpendicular a la línea $A B$. Sus motores
  la frenan para dejarla en una elipse cuyo otro ábside, $B$, esté a
  $100 times 10^3$ km. Determinar la reducción $Delta v$ en $A$. La masa de
  Júpiter es $319$ veces la terrestre.

  *La constante del planeta.* Como $mu = G M$ es proporcional a la masa (y la de
  la nave es despreciable, módulo 8):
  $ mu_J = 319 mu_T = 319 (3,986 times 10^5) = 1,2715 times 10^8 " km"^3\/"s"^2 $

  *Primero, verificar que la llegada es parabólica.* No es un adorno del
  enunciado: es el dato que fija la energía de entrada. Por la @m9-visviva con
  $a arrow.r oo$,
  $ v_"esc"^2 (A) = (2 mu_J)/r_A = ((2)(1,2715 times 10^8))/(3,5 times 10^5) = 726,6 ==> v_"esc" = 26,96 " km/s" $
  contra los $26,9$ del enunciado: coinciden dentro del redondeo. *La parábola
  quiere decir $E = 0$*, y con eso la nave llegó sin gastar nada — pero también
  quiere decir que no está capturada.

  *La elipse pedida.* En $A$ la velocidad es perpendicular al radio, así que $A$
  y $B$ son los dos ábsides. Como $r_A > r_B$, $A$ es el *apoápside* y $B$ el
  *periápside*:
  $ a' = (r_A + r_B)/2 = (350 + 100)/2 times 10^3 = 225 times 10^3 " km", quad e' = (350 - 100)/(350 + 100) = 0,5556 $

  *La velocidad que hay que tener en $A$.* Con la @m9-visviva:
  $ v'^2_A = mu_J (2/r_A - 1/a') = (1,2715 times 10^8)(5,714 times 10^(-6) - 4,444 times 10^(-6)) $
  $ v'^2_A = (1,2715 times 10^8)(1,270 times 10^(-6)) = 161,5 ==> v'_A = 12,71 " km/s" $

  #clave[
    *El mismo número por el otro camino, y sin pasar por $a$.* Con la
    @m9-suma-inversos:
    $ h'^2 = (2 mu_J)/(1\/r_B + 1\/r_A) = (2,543 times 10^8)/(1,2857 times 10^(-5)) = 1,978 times 10^(13) $
    $ h' = 4,447 times 10^6 " km"^2\/"s" ==> v'_A = h'/r_A = (4,447 times 10^6)/(3,5 times 10^5) = 12,71 " km/s" $
    Las dos rutas —energía y momento angular— dan lo mismo porque la @m9-e-E las
    ata. Conviene hacer las dos la primera vez y quedarse con la más corta
    después.
  ]

  *La respuesta.*
  $ Delta v = v_A - v'_A = 26,9 - 12,71 = 14,2 " km/s" $
  Y de paso, la velocidad en el periápside, que el enunciado no pide pero que es
  el número que dice si la órbita sirve:
  $ v'_B = h'/r_B = (4,447 times 10^6)/(1,0 times 10^5) = 44,5 " km/s" $

  #clave[
    *Los $14,2$ km/s son una barbaridad, y ahí está la lección del problema.* Es
    más que toda la velocidad que hace falta para salir de la Tierra desde la
    superficie. La cuenta de dónde se va ese gasto la da el propio potencial
    eficaz: frenar de $26,9$ a $12,7$ en $A$ no es «capturar la nave», es
    *capturarla y además bajarle el periápside hasta $100 thin 000$ km de una
    sola vez*.

    Capturar, solo, es baratísimo. Basta con dejar $E$ apenas por debajo de
    cero. Frenando a $26,0$ km/s en el mismo punto:
    $ E\/m = (26,0)^2/2 - (1,2715 times 10^8)/(3,5 times 10^5) = 338,0 - 363,3 = -25,3 " km"^2\/"s"^2 $
    $ a = mu_J/(2 abs(E\/m)) = (1,2715 times 10^8)/(50,6) = 2,51 times 10^6 " km" $
    o sea una elipse enorme, con apoápside a $4,7 times 10^6$ km — por
    $Delta v = 0,9$ km/s, *quince veces menos*. La órbita chica se paga después,
    y desde el apoápside sale mucho más barata: eso es lo que se calcula en el
    módulo 11.
  ]

  #cuidado[
    *Los dos errores que este problema busca.* El primero es tomar
    $mu_J = 319 mu_T$ y además cambiar el radio: el $319$ multiplica la *masa*,
    y el radio de Júpiter no aparece en ningún lado del problema — todas las
    distancias se dan desde el centro.

    El segundo es más fino: escribir $E = 0$ para la parábola *y también* usar
    $E = -mu m \/ (2a)$ con la $a$ de la parábola. Una parábola no tiene semieje
    mayor —o tiene $a = oo$—, y la @m9-visviva se le aplica sólo en el límite.
    Para trayectorias abiertas se trabaja con $E$ y con $p$, nunca con $a$.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  El *Problema 7* (Beer 13.100, Júpiter) es el ejemplo a fondo y es el único de
  la guía que necesita explícitamente la clasificación por cónicas: el dato
  «trayectoria parabólica» no se puede usar sin la @m9-e-E.

  El ejemplo simple *no es un ejercicio nuevo*: es el *Ej. 4* de impulso angular
  —que el módulo 7 ya había resuelto con $h$— rehecho desde la ecuación de la
  órbita, y de paso contesta los puntos (b) y (c) del *Problema 4* de energía.
  La guía no trae ningún ejercicio de potencial eficaz, así que en vez de
  inventar uno se reusa éste, que es el que la cátedra tomó dos veces.

  El *Problema 1* de energía es el diagrama de energía del módulo 5, que es
  literalmente esta figura con otro potencial.

  Y los *Problemas 4* (período), *8* y *9* (el LEM del Apollo) usan todo lo de
  acá pero su tema propio es Kepler y las transferencias: se resuelven en los
  módulos 10 y 11.
]

== Lo que se usa después

1. *La ecuación de la órbita, $r = p \/ (1 + e cos nu)$.* Es la fórmula de la
   que salen las tres leyes de Kepler en el módulo 10: la primera es ella misma
   con $e < 1$, la segunda ya salió del momento angular, y la tercera se deduce
   integrando el área.

2. *La vis-viva, $v^2 = mu (2\/r - 1\/a)$.* Es la herramienta con la que se
   resuelven las transferencias del módulo 11: cada encendido cambia $a$, y la
   vis-viva dice cuánta velocidad cuesta.

3. *$E = -mu m \/ (2 a)$.* Dice que la energía de una órbita depende *sólo del
   semieje mayor* — no de la excentricidad. Dos órbitas con la misma $a$ y
   formas muy distintas cuestan lo mismo, y ésa es la razón por la que las
   maniobras se piensan en términos de $a$.

4. *El potencial eficaz.* Vuelve en cualquier problema donde haya un momento
   angular conservado y un potencial radial. Es la misma construcción que se usa
   para el átomo de hidrógeno y para la dispersión de partículas.
