#import "../plantilla.typ": *

#modulo("Peonza simétrica, precesión directa y retrógrada")[
  Cerrar la Parte IV con el caso que se resuelve sin ecuaciones diferenciales:
  un cuerpo con simetría de revolución, sin ninguna cupla externa. Ahí
  $bold(H)_G$ queda fijo *solo*, sin que nadie lo sostenga, y esa fijeza
  alcanza para deducir a mano cómo precesa el cuerpo —y para contestar la
  pregunta que da nombre al módulo: ¿la precesión gira en el mismo sentido
  que el espín, o al revés?
]

Los tres módulos anteriores necesitaron una cupla para que algo pasara: el
módulo 14 calculó qué cupla sostiene un movimiento dado, o qué movimiento
produce una cupla dada. Acá la cupla es cero —un satélite en el espacio, sin
motores encendidos, sin nada que lo toque— y sin embargo el cuerpo *sigue*
precesando, indefinidamente, sin que nadie lo sostenga. Es el caso más simple
de toda la Parte IV, y por eso cierra el apunte: la @m14-precesion-estable
del módulo 14 vale con $sum bold(M)_O = 0$, y esa sola condición fija todo lo
demás.

== Un cuerpo simétrico sin cuplas: $bold(H)_G$ queda fijo

#deduccion("de dónde sale que la precesión es automática")[
  $sum bold(M)_G = dot(bold(H))_G$, y si $sum bold(M)_G = 0$ entonces
  $bold(H)_G$ es un vector *constante*: mismo módulo, misma dirección, para
  siempre. Ésa es toda la física. El resto es geometría: como $bold(H)_G$ no
  se mueve, define un eje fijo en el espacio —hace exactamente el papel del
  eje $Z$ del módulo 14—, y el eje de simetría $z$ del cuerpo precesa
  alrededor de *él*, no de ningún eje elegido de antemano. (Beer §18.11,
  ecs. 18.46 a 18.48, pág. 1190.)
]

Con $theta$ el ángulo entre $bold(H)_G$ y $z$ —la nutación del módulo 14,
ahora medida contra $bold(H)_G$ en vez de contra un $Z$ impuesto desde
afuera— la componente transversal de $bold(H)_G$ es $H sin theta = I dot(phi)
sin theta$ (@m14-precesion-estable, componente sobre $hat(e)$), y como
$sin theta$ aparece en los dos lados:

$ dot(phi) = H\/I $ <m15-precesion-libre>

*La velocidad de precesión no depende de $theta$.* Cualquiera sea el ángulo
de apertura del cono, $bold(H)_G$ es siempre el mismo vector fijo y $I$ es
siempre el mismo momento transversal: la precesión de un cuerpo libre es
uniforme, sin que haga falta ninguna cupla que la mantenga así.

== El ángulo del eje instantáneo: $tan gamma = (I\/I') tan theta$

#notacion[
  *Dos ángulos, y ninguno es el de la sección anterior.* Para esta fórmula
  puntual el Beer usa $gamma$ para el ángulo entre $bold(H)_G$ (que acá hace
  de eje fijo) y el eje de simetría $z$ —es el $theta$ que se acaba de
  usar arriba— y reserva $theta$ para el ángulo entre el eje *instantáneo*
  $bold(omega)$ y $z$, que todavía no se había nombrado. Es la misma
  confusión que el módulo 12 ya advertía entre $bold(Omega)$ y
  $bold(omega)$: dos velocidades angulares con nombre parecido: acá son dos
  *ángulos* con nombre parecido, y conviene decir en voz alta cuál es cuál
  antes de usar la fórmula.
]

Con $I$ el momento transversal e $I'$ el axial (módulo 14), la componente
axial de $bold(H)_G$ es $H cos gamma = I' omega_z = I' omega cos theta$, y la
transversal $H sin gamma = I omega_"transv" = I omega sin theta$ —descomponiendo
esta vez $bold(omega)$, no $bold(H)_G$, contra $z$. Dividiendo:

$ tan gamma = I/I' tan theta $ <m15-tan-gamma>

(Beer ec. 18.49, pág. 1190.) $bold(omega)$, $bold(H)_G$ y $z$ quedan siempre
en un mismo plano —el que gira con la precesión—, y esta fórmula dice qué tan
lejos de $z$ cae cada uno de los otros dos.

== Precesión directa y precesión retrógrada

#deduccion("de dónde sale el criterio del signo")[
  De la @m14-precesion-estable con $sum bold(M)_O = 0$: $I' dot(psi) + (I -
  I') dot(phi) cos theta = 0$, así que
  $ dot(psi)/dot(phi) = (I' - I)/I' cos theta $
  Con $theta < 90degree$ (el eje de simetría no llega a ser perpendicular al
  eje de precesión), $cos theta > 0$, y el signo de $dot(psi)\/dot(phi)$ —si
  el espín y la precesión giran para el mismo lado o para lados opuestos—
  queda decidido enteramente por el signo de $I' - I$.
]

#cuidado[
  *$I' > I$ (cuerpo achatado, como un disco): precesión directa. $I' < I$
  (cuerpo alargado, como una varilla o un cilindro delgado): retrógrada.*
  Con $I' > I$, $dot(psi)$ y $dot(phi)$ tienen el mismo signo: el espín y la
  precesión giran para el mismo lado. Es el caso de la Tierra —achatada en
  los polos, $I'_"polar" > I_"ecuatorial"$— y su precesión libre (el
  bamboleo de Chandler) es, en efecto, directa. Con $I' < I$ es al revés:
  $dot(psi)$ y $dot(phi)$ tienen signos opuestos, retrógrada. Los dos conos
  del módulo 12 lo muestran sin necesidad de ninguna fórmula: si el cono
  corporal es tangente al espacial *por afuera* —dos conos separados que se
  tocan a lo largo de $bold(omega)$, como en la @fig-conos-directa de abajo—
  la precesión es directa; si el corporal es más ancho y *envuelve* al
  espacial por adentro, es retrógrada.
]

#fig([Los dos conos del módulo 12, reusados: tangencia *externa*, el
corporal como un cono aparte que toca al espacial desde afuera a lo largo de
$bold(omega)$. Es la configuración de un cuerpo achatado —$I' > I$— y de la
precesión directa: el Problema 4 de abajo es un caso así.], fig-conos)
<fig-conos-directa>

#guia("qué ejercicios cubre este módulo")[
  El Problema 4 (el *spacecraft* que precesa, achatado, precesión directa) y
  el Problema 6 (el cilindro de paredes delgadas, el umbral entre directa y
  retrógrada según $ell \/ r$). Los Problemas 5, 7, 8 y 9 son variantes de
  los mismos dos mecanismos —la precesión estable del módulo 14 y la
  precesión libre de éste— y quedan como práctica adicional, no resueltos
  acá: no agregan un caso conceptual nuevo.
]

#ejemplo("El satélite achatado: el período de una precesión que nadie sostiene", nivel: "a fondo")[
  _(Problema 4 de la sección de cuerpo rígido.)_ Un *spacecraft* simétrico
  respecto de $z$ tiene radio de giro axial $k_z = 720$ mm y radios de giro
  transversales iguales, $k = 540$ mm. Sin cuplas externas, el eje $z$
  describe un cono de $theta = 2degree$ alrededor de $bold(H)_G$. La
  velocidad de *spin*, $dot(psi)$, es $1,5$ rad/s. Pide el período de cada
  vuelta de precesión y si el spin apunta en el sentido positivo o negativo
  de $z$.

  *El cociente $I'\/I$ no necesita la masa.* Con $I = m k^2$ e $I' = m k_z^2$,
  y $k_z \/ k = 720\/540 = 4\/3$:
  $ I'/I = (k_z/k)^2 = (4/3)^2 = 16/9 $
  Como $I' > I$ —el radio de giro axial es mayor: el satélite es *achatado*
  respecto de su eje de simetría—, la precesión es directa (sección
  anterior).

  *La velocidad de precesión.* De $dot(psi)\/dot(phi) = ((I'-I)\/I')
  cos theta$, con $(I'-I)\/I' = 1 - I\/I' = 1 - 9\/16 = 7\/16$:
  $ dot(phi) = dot(psi) (I'/(I'-I)) 1/(cos theta)
    = 1,5 (16/7) 1/(cos 2degree) $
  $ dot(phi) = (24/7)/(0,9994) approx 3,431 " rad/s" $

  *El período.*
  $ tau = (2 pi)/dot(phi) = (2 pi)/(3,431) approx 1,832 " s" $

  *El sentido del spin.* Como $I' > I$, $dot(psi)$ y $dot(phi)$ tienen el
  mismo signo (deducción de la sección anterior): el *spin* apunta en el
  mismo sentido que la precesión, no en el opuesto. Con la convención
  habitual de tomar $dot(phi) > 0$, la respuesta es *positivo*.

  #clave[
    *El período no depende de $theta$, y eso no es una casualidad de este
    problema puntual.* La @m15-precesion-libre ya lo decía: $dot(phi) = H\/I$
    no tiene $theta$ adentro. Los $2degree$ del enunciado sólo entran a
    través de $cos theta$ en la relación entre $dot(psi)$ y $dot(phi)$
    —y ahí casi no pesan, porque $cos 2degree = 0,9994$ está a cuatro
    cifras de $1$—. El dato geométrico que de verdad importa es el cociente
    $I'\/I = 16\/9$, no el ángulo del cono.
  ]
]

#ejemplo("El cilindro de paredes delgadas: el umbral entre directa y retrógrada")[
  _(Problema 6 de la sección de cuerpo rígido.)_ Un cilindro hueco de
  paredes delgadas, radio $r$, longitud $ell$ y masa $m$, rota respecto de su
  eje de simetría y precesa con un ángulo pequeño. ¿Para qué valores de
  $ell\/r$ la precesión es retrógrada, y para cuáles directa?

  *Los dos momentos de inercia.* Toda la masa está a distancia $r$ del eje de
  simetría —pared delgada—, así que el axial es el de un aro:
  $ I' = m r^2 $
  El transversal —una tapa de aro más la varilla que la extiende a lo largo
  de $ell$, por el teorema de Steiner— es
  $ I = m (r^2/2 + ell^2/12) $

  *El umbral.* Directa exige $I' > I$ (sección anterior):
  $ m r^2 > m (r^2/2 + ell^2/12) ==> r^2/2 > ell^2/12 ==> r^2 > ell^2/6 $
  $ ==> ell/r < sqrt(6) approx 2,449 $

  #clave[
    *En $ell\/r = sqrt(6)$ exactos, los tres momentos de inercia se igualan
    —$I = I'$— y el cilindro se comporta, para esta pregunta, como el cubo
    isótropo del módulo 13: sin dirección privilegiada, $bold(H)_G$ y
    $bold(omega)$ quedan paralelos y la distinción entre directa y
    retrógrada deja de tener sentido, porque no hay precesión que separar
    del espín.* Para $ell\/r < sqrt(6)$ —un cilindro corto y ancho, cerca de
    un disco— la precesión es *directa*; para $ell\/r > sqrt(6)$ —largo y
    fino, cerca de una varilla— es *retrógrada*. El número exacto no está en
    la guía ni hace falta memorizarlo: lo que importa es *que existe* un
    umbral, y que es la misma pregunta —¿el cuerpo es más achatado o más
    alargado que la esfera que lo iguala?— para cualquier cuerpo de
    revolución, no sólo para este cilindro.
  ]
]

== Cierre de la Parte IV

Los quince módulos de este apunte llegan hasta acá con una sola herramienta
repetida: derivar un vector cuando el sistema que lo mira está girando —la
@m12-derivada del módulo 12— y aplicarla, primero al momento angular de una
partícula (módulo 7), después al de un cuerpo entero (módulos 13 y 14), hasta
llegar al caso más simple de todos, el de este módulo, en el que ni siquiera
hace falta una cupla para que la física haga algo interesante. El satélite
achatado que precesa solo, sin que nadie lo sostenga, es la misma física que
hace que la Tierra se bambolee y que un giróscopo resista a que le cambien el
eje: un cuerpo con un eje de simetría rápido *siempre* tiene esta rigidez, la
haya pedido alguien o no.
