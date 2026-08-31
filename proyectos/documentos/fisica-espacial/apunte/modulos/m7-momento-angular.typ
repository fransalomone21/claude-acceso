#import "../plantilla.typ": *

#modulo("Momento angular y fuerzas centrales")[
  Escribir $bold(L)$ diciendo siempre respecto de qué punto; demostrar que una
  fuerza central lo conserva, y sacar de ahí las dos consecuencias que sostienen
  toda la mecánica orbital —que el movimiento es *plano* y que $r^2 dot(theta)$
  es *constante*—; traducir esa constante al momento angular específico $h$ que
  usan los libros de astrodinámica; y demostrar que la segunda ley de Kepler no
  es una ley aparte sino esa misma conservación, escrita en áreas.
]

Éste es el tercero de los teoremas de conservación, y la Parte II lo dejó para
acá a propósito: se entiende de verdad recién con la gravitación delante. Su
utilidad es distinta de la de los otros dos. La conservación de $bold(P)$ da
información sobre *el sistema entero*; la de $E$ da un escalar que dice hasta
dónde llega el cuerpo. La de $bold(L)$ da algo que ninguna de las dos da: *la
dirección*. Con energía sola se puede saber cuánto vale la velocidad en el
apogeo, pero no hacia dónde apunta — y ésa es la mitad que falta en casi todos
los problemas de la guía.

== Qué es el momento angular, y respecto de qué punto

Para una partícula de cantidad de movimiento $m bold(v)$ ubicada en $bold(r)$
respecto de un punto $O$ (Beer §12.7, ec. 12.12, pág. 721):

$ bold(L)_O = bold(r) times m bold(v) $ <m7-def>

y su módulo, con $phi$ el ángulo entre $bold(r)$ y $bold(v)$ (Beer ec. 12.13,
pág. 722):

$ L_O = m v r sin phi = m v d $ <m7-modulo>

donde $d = r sin phi$ es la *distancia de $O$ a la recta de acción de
$bold(v)$*: el brazo de palanca, igual que en estática.

#geometria[
  *«El momento angular» no significa nada hasta que se dice respecto de qué
  punto.* La @m7-def tiene una $bold(r)$ adentro, y $bold(r)$ se mide desde
  algún lado. La misma partícula, con la misma velocidad, tiene infinitos
  valores de $L$ — uno por cada origen posible.

  En los problemas de órbitas el punto es *siempre el centro del cuerpo
  central*, y no por convención sino porque es el único punto respecto del cual
  la gravedad no hace torque. Elegir otro origen no está mal, pero deja de
  conservarse, y entonces no sirve para nada.
]

#fig([El momento angular es un *brazo de palanca*: $L = m v d$, con $d$ la
distancia del origen a la recta de acción de $m bold(v)$. Los dos paneles
tienen la misma partícula y la misma velocidad, y sin embargo $L' eq.not L$,
porque el brazo cambió. Por eso $bold(L)$ se declara siempre con su punto.],
fig-momento-angular)

#notacion[
  *Éste es el choque de letras más peligroso de la materia, y la cátedra lo
  advirtió por escrito.* El Beer llama $bold(H)$ al momento angular y $bold(L)$
  a la cantidad de movimiento lineal — exactamente al revés de lo que usan la
  cátedra, el S&Z y este apunte:

  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    table.header([*Cantidad*], [*Cátedra, S&Z y este apunte*], [*Beer*]),
    [cantidad de movimiento lineal], [$bold(P)$, $m bold(v)$], [$bold(L)$],
    [momento angular (impulso angular)], [$bold(L)$], [$bold(H)_O$],
    [momento de una fuerza (torque)], [$bold(tau)$], [$bold(M)_O$],
  )

  *No es un detalle tipográfico:* una fórmula copiada del Beer con la letra
  cambiada da una ecuación que parece correcta y es otra cosa. Cuando este
  apunte cita una ecuación del Beer, la traduce; los números de ecuación son
  los del libro, pero las letras son las de la cátedra.

  Y una segunda advertencia textual de la cátedra, sobre el mismo libro: donde
  el Beer dice *«razón de cambio»*, hay que leer *derivada respecto del
  tiempo*. No hay ningún cociente escondido.
]

== La ecuación de movimiento del momento angular

#deduccion("por qué el torque es la derivada del momento angular")[
  Se deriva la @m7-def con la regla del producto vectorial (Beer §12.7,
  pág. 723):
  $ (d bold(L)_O)/(d t) = dot(bold(r)) times m bold(v) + bold(r) times m dot(bold(v)) = underbrace(bold(v) times m bold(v), = bold(0)) + bold(r) times m bold(a) $
  El primer término se anula *siempre*, porque $bold(v)$ y $m bold(v)$ son
  paralelos y el producto vectorial de dos vectores paralelos es cero. En el
  segundo, $m bold(a) = sum bold(F)$ por la segunda ley, y $bold(r) times sum
  bold(F)$ es por definición el torque respecto de $O$.
]

$ sum bold(tau)_O = (d bold(L)_O)/(d t) $ <m7-tau>

Es la versión rotacional de $sum bold(F) = d bold(P) \/ d t$ del módulo 2, y se
parece tanto por la misma razón: las dos salen de derivar una definición y usar
la segunda ley una sola vez.

== Fuerza central: las dos consecuencias

#definicion("fuerza central")[
  Una fuerza es *central* respecto de $O$ si su recta de acción pasa siempre
  por $O$, es decir $bold(F) = F(bold(r)) hat(r)$ (Beer §12.9, pág. 724). No se
  pide que su módulo dependa sólo de $r$ — eso hacía falta para la *energía*, en
  el módulo 5, y no hace falta acá.
]

Si la fuerza es central, $bold(r)$ y $bold(F)$ son paralelos, así que
$bold(tau)_O = bold(r) times bold(F) = bold(0)$, y por la @m7-tau:

$ bold(L)_O = "constante" quad "(en módulo y en dirección)" $ <m7-conserva>

(Beer ec. 12.23, pág. 724.) Que sea *un vector* el que se conserva, y no un
número, es lo que hace que este teorema rinda el doble.

#clave[
  *Primera consecuencia: el movimiento es plano.* De la @m7-def, $bold(r)$ es
  perpendicular a $bold(L)_O$ en todo instante — un producto vectorial es
  perpendicular a sus dos factores. Y si $bold(L)_O$ no cambia de dirección,
  entonces $bold(r)$ está *siempre* en el mismo plano: el plano perpendicular a
  $bold(L)_O$ que pasa por $O$ (Beer ec. 12.24, pág. 724).

  Esto es lo que permite escribir todo el resto de la Parte III con dos
  coordenadas, $r$ y $theta$, en vez de tres. No es una simplificación que se
  adopta: es un resultado que se demostró.
]

#clave[
  *Segunda consecuencia: $r^2 dot(theta)$ es constante.* Descomponiendo
  $bold(v)$ en polares —como en el módulo 1— sólo la componente transversal
  $v_theta = r dot(theta)$ contribuye al momento angular, porque la radial es
  paralela a $bold(r)$ (Beer ecs. 12.17 y 12.18, pág. 723):
  $ L_O = m r v_theta = m r^2 dot(theta) = "constante" $
  Y dividiendo por la masa se define el *momento angular específico* (Beer
  ec. 12.27, pág. 725; Curtis §2.4), que es la forma en que aparece en todo
  libro de astrodinámica y en la guía de la cátedra:
  $ h = L\/m = r^2 dot(theta) = r v_theta $
]

$ h = r v_theta = r v cos gamma $ <m7-h>

#geometria[
  *Los dos ángulos que se confunden.* En la @m7-modulo, $phi$ es el ángulo
  entre $bold(r)$ y $bold(v)$, y aparece como $sin phi$. En la @m7-h,
  $gamma$ es el ángulo entre $bold(v)$ y *la perpendicular al radio* —el
  *ángulo de trayectoria*, que es el que traen dibujado los enunciados—, y
  aparece como $cos gamma$. Son complementarios: $gamma = 90° - phi$, y por eso
  $sin phi = cos gamma$. Las dos fórmulas son la misma.

  *En los ábsides —perigeo y apogeo— la velocidad es perpendicular al radio*,
  así que $gamma = 0$ y queda simplemente $h = r v$. Ésa es la razón por la que
  casi todos los problemas de órbitas empiezan por un ábside: es donde la
  fórmula no tiene ángulo.
]

== La segunda ley de Kepler es esto mismo

#deduccion("la ley de las áreas, desde la conservación del momento angular")[
  En un tiempo $d t$ el radio barre un triángulo de base $r d theta$ y altura
  $r$, o sea un área $d A = 1/2 r^2 d theta$ (S&Z §13.5, ec. 13.14, pág. 410).
  La *velocidad areolar* es entonces
  $ (d A)/(d t) = 1/2 r^2 (d theta)/(d t) = 1/2 r^2 dot(theta) = h/2 $
  y como $h$ es constante por la @m7-conserva, la velocidad areolar es
  constante (S&Z ec. 13.16, pág. 411; Beer pág. 725). Eso *es* la segunda ley
  de Kepler.
]

$ (d A)/(d t) = h/2 = L/(2 m) = "constante" $ <m7-areas>

#fig([La segunda ley de Kepler, dibujada. Los dos sectores sombreados tienen
la *misma área* y se barren en el *mismo tiempo*. Cerca del foco el radio es
corto y el ángulo barrido grande; lejos, al revés — y el producto
$r^2 dot(theta)$ queda igual. Los semiángulos del dibujo no están puestos a
ojo: salen de igualar las dos integrales $integral 1/2 r^2 d nu$.],
fig-velocidad-areolar)

#clave[
  *La respuesta a la pregunta fina del Ej. 5 de la guía.* El enunciado
  pregunta: para que valga la ley de las áreas, ¿hace falta que el potencial
  sea del tipo $1\/r$ (fuerza $1\/r^2$), o alcanza con que la fuerza sea
  central?

  *Alcanza con que sea central*, y la deducción de arriba lo muestra sin
  esfuerzo: en ningún renglón se usó cuánto vale $F$, sólo que su recta de
  acción pasa por $O$. Vale para $1\/r^2$, para un resorte, para cualquier cosa.

  Conviene guardar las tres condiciones juntas, porque la guía las mezcla a
  propósito y son tres cosas distintas:

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Para que se conserve…*], [*hace falta que la fuerza sea…*]),
    [$bold(L)$, y valga la ley de áreas], [*central*, y nada más],
    [$E$, y exista energía potencial], [central *y con módulo $F(r)$* (módulo 5)],
    [y además la órbita *cierre* en una elipse], [central y exactamente $1\/r^2$ (módulo 9)],
  )

  Las tres son cada vez más exigentes, y la tercera es la única que necesita la
  forma exacta de la ley de Newton. Confundirlas es contestar mal una pregunta
  que la cátedra ya escribió dos veces.
]

#ejemplo("Dos demostraciones de una línea")[
  _(Problemas 2 y 3 de la sección «Conservación impulso angular».)_

  *Problema 2: demostrar que $bold(L)$ respecto de un punto cualquiera es
  constante para una partícula libre que se mueve con velocidad constante.*

  Sin fuerzas, no hay torque respecto de ningún punto, así que por la @m7-tau
  ya está. Pero la demostración *geométrica* es la que enseña algo: por la
  @m7-modulo, $L = m v d$, donde $d$ es la distancia del punto a la recta de
  acción de $bold(v)$. Si la partícula va en línea recta a velocidad constante,
  *su recta de acción es siempre la misma recta*, así que $d$ no cambia, $v$ no
  cambia, y $L$ tampoco. Una partícula libre tiene momento angular no nulo
  respecto de cualquier punto que no esté sobre su trayectoria — y eso no tiene
  nada de raro.

  *Problema 3: dos partículas de masa $m$ y velocidad $v$ en sentidos opuestos,
  sobre rectas paralelas separadas $d$; demostrar que $bold(L)$ del sistema no
  depende del origen.*

  Sea $O$ un origen a distancia $d_1$ de la primera recta; la segunda queda a
  $d_2 = d - d_1$ (o $d_1 - d$, según de qué lado). Como las velocidades son
  opuestas, los dos momentos angulares tienen el *mismo* signo si el origen está
  entre las rectas — las dos partículas «giran» en el mismo sentido alrededor de
  él:
  $ L = m v d_1 + m v (d - d_1) = m v d $
  y $d_1$ se fue. Con el origen fuera de la franja el mismo cálculo da signos
  distintos y también cancela.

  #clave[
    *Este resultado no es una curiosidad: es una regla general.* El momento
    angular de un sistema es independiente del origen *si y sólo si su cantidad
    de movimiento total es cero*, que es justo el caso acá ($m bold(v) - m
    bold(v) = bold(0)$). Es la misma estructura que en estática: una cupla —dos
    fuerzas opuestas— tiene el mismo momento respecto de cualquier punto,
    mientras que una fuerza sola no.

    Y es la razón por la que en el módulo 3 el sistema centro de masa resultó
    tan cómodo: ahí $bold(P)^* = bold(0)$ por construcción, así que $bold(L)^*$
    no depende de dónde se ponga el origen.
  ]
]

#ejemplo("El satélite de la figura: h en los cuatro puntos", nivel: "a fondo")[
  _(Ejercicio 4 de la sección «Conservación impulso angular».)_ *(A)* Calcular
  el impulso angular específico en el apogeo $A$ y el perigeo $P$ del satélite
  de la figura. *(B)* Con eso, calcular las distancias al centro terrestre en
  las otras dos posiciones marcadas.

  #fig([El satélite del ejercicio, redibujado con los datos de la figura de la
  cátedra. En los ábsides $bold(v)$ es perpendicular al radio; en las dos
  posiciones intermedias forma un ángulo $gamma$ con esa perpendicular.
  Velocidades en km/s.], fig-satelite-guia)

  *(A) Los ábsides.* Primero los radios, desde el centro de la Tierra:
  $ r_P = 6378 + 400 = 6778 " km", quad r_A = 6378 + 4000 = 10 thin 378 " km" $
  En los dos, $gamma = 0$, así que la @m7-h se reduce a $h = r v$:
  $ h_P = (6778)(8,435) = 57 thin 172 " km"^2\/"s" $
  $ h_A = (10 thin 378)(5,509) = 57 thin 172 " km"^2\/"s" $

  #clave[
    *Ésa es toda la parte (A), y el resultado es que dan lo mismo.* No es una
    coincidencia ni una comprobación numérica: es la @m7-conserva, y los dos
    números salen del dibujo por caminos distintos. Que coincidan en las cinco
    cifras dice que los datos de la figura son consistentes — y si no
    coincidieran, habría un error de lectura antes de seguir. *Conviene hacer
    esta comprobación siempre que el enunciado dé más datos de los necesarios.*
    Se toma $h = 57 thin 172$ km²/s de acá en adelante.
  ]

  *(B) Las dos posiciones intermedias.* Ahí $bold(v)$ *no* es perpendicular al
  radio: la figura da $gamma = 12,05°$ arriba y $gamma = 12,11°$ abajo. Con la
  @m7-h despejada,
  $ r = h / (v cos gamma) $

  Para la de arriba, con $v = 6,970$ km/s y $cos 12,05° = 0,9780$:
  $ r = (57 thin 172) / ((6,970)(0,9780)) = (57 thin 172) / (6,817) = 8387 " km" $
  Para la de abajo, con $v = 6,817$ km/s y $cos 12,11° = 0,9778$:
  $ r = (57 thin 172) / ((6,817)(0,9778)) = (57 thin 172) / (6,665) = 8577 " km" $

  O sea alturas de $2009$ km y $2199$ km sobre la superficie.

  #geometria[
    *Por qué no son iguales, si la elipse es simétrica.* Porque los dos puntos
    no están simétricos respecto del eje de ábsides: la figura los marca en
    anomalías distintas. Y hay una manera de verificarlo sin más datos que los
    que ya se usaron — la @m7-h no la da, pero la figura de la cátedra sí marca
    los dos ángulos de posición, $96,09°$ y $102,1°$, medidos desde el perigeo.
    Anticipando la ecuación de la órbita del módulo 9,
    $r = p\/(1 + e cos nu)$, con $p = 8578 (1 - 0,2098^2) = 8200$ km:
    $ nu = 96,09° ==> r = (8200)/(1 - 0,2098 (0,1061)) = 8387 " km" $
    $ nu = 102,1° ==> r = (8200)/(1 - 0,2098 (0,2096)) = 8577 " km" $
    *Los dos coinciden exactamente con lo calculado por momento angular.* Son
    dos caminos independientes —uno usa sólo $bold(L)$, el otro la geometría de
    la cónica— y llegan al mismo número: los datos de la figura son un sistema
    consistente, y el ejercicio se puede resolver por cualquiera de los dos
    lados.
  ]

  #cuidado[
    *El error que este ejercicio busca.* Es usar $h = r v$ en las posiciones
    intermedias, olvidando el $cos gamma$. Da $8203$ km y $8386$ km — números
    perfectamente creíbles, del orden correcto, y mal por casi 200 km. El
    $cos 12° = 0,978$ es una corrección del 2%, demasiado chica para que el
    resultado se vea absurdo y demasiado grande para ignorarla.

    *La regla: $h = r v$ sólo vale donde $bold(v) perp bold(r)$*, es decir en
    los ábsides y en cualquier punto de una órbita circular. En todo otro punto
    hay que proyectar.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  De la sección *Conservación impulso angular*: los *Problemas 2 y 3* son el
  ejemplo simple y el *Ejercicio 4* es el ejemplo a fondo. El *Ej. 5* —la ley
  de áreas y la pregunta sobre qué condición hace falta— está contestado entero
  en el cuadro azul de la sección anterior. El *Problema 1* es cálculo de
  torques con la @m7-tau: es la aplicación directa de $tau = F d$ en seis
  configuraciones, y sale de la definición sin nada nuevo.

  *El Ej. 6 está en blanco en el PDF de la cátedra* — no es un problema de
  impresión: el rótulo está y abajo no hay nada.

  Los que quedan de esa sección —el giróscopo de juguete y la estabilización del
  Hubble— *no* son de fuerzas centrales sino de precesión, y necesitan cuerpo
  rígido: se resuelven en el módulo 14.

  Y de la sección de energía, el *Problema 2* (la sonda de Beer, de $A$ a $B$):
  el módulo 6 dio la rapidez por energía, y la @m7-h da la dirección. Recién con
  los dos el problema queda cerrado.
]

== Lo que se usa después

1. *$h = r^2 dot(theta)$ constante.* Es lo que permite, en el módulo 9,
   cambiar la variable independiente de $t$ a $theta$ y convertir la ecuación de
   movimiento —que en el tiempo no se puede integrar de cabeza— en una ecuación
   lineal cuya solución son las cónicas.

2. *$h$ como término centrífugo.* Sustituyendo $dot(theta) = h\/r^2$ en la
   energía cinética aparece un $h^2 \/ (2 r^2)$ que se le suma a
   $U = -mu m \/ r$: ése es el *potencial eficaz*, y con él el diagrama del
   módulo 5 pasa a decidir la forma de la órbita, no sólo si está ligada.

3. *$h = r v cos gamma$, y $h = r v$ en los ábsides.* Es la ecuación con la que
   se resuelven, en los módulos 10 y 11, todos los problemas que dan datos en
   perigeo y piden algo en apogeo.

4. *$sum bold(tau) = d bold(L) \/ d t$.* Con un cuerpo rígido en lugar de una
   partícula, ésta misma es la ecuación de Euler del módulo 14, y la que
   explica por qué un giróscopo precesa en vez de caerse.
