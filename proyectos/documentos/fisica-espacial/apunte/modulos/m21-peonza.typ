#import "../plantilla.typ": *
// voz: 2026-09-25 -- pasada de la fase 11, tanda (d)

#modulo("Peonza simétrica, precesión directa y retrógrada", clave: "peonza")[
  Cerrar la Parte V —y el apunte— con el caso que se resuelve sin ecuaciones diferenciales:
  un cuerpo con simetría de revolución, sin ninguna cupla externa. Ahí
  $bold(H)_G$ queda fijo *solo*, sin que nadie lo sostenga, y esa fijeza
  alcanza para deducir a mano cómo precesa el cuerpo —y para contestar la
  pregunta que da nombre al módulo: ¿la precesión gira en el mismo sentido
  que el espín, o al revés?
]

Los tres módulos anteriores necesitaron una cupla para que algo pasara: el
módulo #M("euler-giroscopo") calculó qué cupla sostiene un movimiento dado, o qué movimiento
produce una cupla dada. Acá la cupla es cero —un satélite en el espacio, sin
motores encendidos, sin nada que lo toque— y sin embargo el cuerpo *sigue*
precesando, indefinidamente, sin que nadie lo sostenga. Es el caso más simple
de toda la Parte V, y por eso cierra el apunte: la @euler-precesion-estable
del módulo #M("euler-giroscopo") vale con $sum bold(M)_O = 0$, y esa sola condición fija todo lo
demás. Que el apunte termine con un cuerpo que se mueve sin que nadie lo
empuje tiene su poesía; que haya que hacer tres módulos de cuentas para
poder decirlo, también.

#lectura[
  *Beer, Dinámica, capítulo 18*, §18.11 («Movimiento de un cuerpo simétrico
  con respecto a un eje y que no se somete a ninguna fuerza», pág. 1190) —ya
  citada en el cuerpo de este módulo; el criterio de directa y retrógrada,
  con sus dos figuras (18.23 y 18.24), está en la pág. 1191.

  Para este módulo el Beer está solo. El Roederer trata el cuerpo rígido
  libre de momentos en §5.e (pág. 179: el satélite que se orienta con
  toberas, el gato que cae), pero no llega a la precesión libre, y su §5.g
  («Giróscopo y trompo», pág. 189) es el trompo *con* peso, contado en forma
  cualitativa. Buscar ahí la peonza sin cuplas es perder una tarde.
]

== Un cuerpo simétrico sin cuplas: $bold(H)_G$ queda fijo

#deduccion("de dónde sale que la precesión es automática")[
  $sum bold(M)_G = dot(bold(H))_G$, y si $sum bold(M)_G = 0$ entonces
  $bold(H)_G$ es un vector *constante*: mismo módulo, misma dirección, para
  siempre. Ésa es toda la física. El resto es geometría: como $bold(H)_G$ no
  se mueve, define un eje fijo en el espacio —hace exactamente el papel del
  eje $Z$ del módulo #M("euler-giroscopo")—, y el eje de simetría $z$ del cuerpo precesa
  alrededor de *él*, no de ningún eje elegido de antemano. (Beer §18.11,
  ecs. 18.46 a 18.48, pág. 1190.)
]

#posta[
  Sin nadie que lo toque, el cuerpo tiene un $bold(H)$ que no se mueve
  nunca, y ese $bold(H)$ hace de eje del mundo. El cuerpo, si no gira justo
  sobre un eje principal, se pone a dar vueltas alrededor de él como un
  trompo alrededor de la vertical, pero sin trompo y sin vertical: la
  «vertical» la puso él mismo al arrancar.
]

Con $theta$ el ángulo entre $bold(H)_G$ y $z$ —la nutación del módulo #M("euler-giroscopo"),
ahora medida contra $bold(H)_G$ en vez de contra un $Z$ impuesto desde
afuera— la componente transversal de $bold(H)_G$ es $H sin theta = I dot(phi)
sin theta$ (la $bold(H)_O$ de la deducción de la precesión estable, en el
módulo #M("euler-giroscopo"), componente sobre $hat(e)$), y como $sin theta$
aparece en los dos lados:

$ dot(phi) = H\/I $ <peon-precesion-libre>

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
  confusión que el módulo #M("cinematica-cr") ya advertía entre $bold(Omega)$ y
  $bold(omega)$: dos velocidades angulares con nombre parecido: acá son dos
  *ángulos* con nombre parecido, y conviene decir en voz alta cuál es cuál
  antes de usar la fórmula. El Beer no ayuda: usa $theta$ para una cosa en
  §18.9 y para otra en §18.11, a dos páginas de distancia, y confía en que
  el lector se dé cuenta solo.
]

Con $I$ el momento transversal e $I'$ el axial (módulo #M("euler-giroscopo")), la componente
axial de $bold(H)_G$ es $H cos gamma = I' omega_z = I' omega cos theta$, y la
transversal $H sin gamma = I omega_"transv" = I omega sin theta$ —descomponiendo
esta vez $bold(omega)$, no $bold(H)_G$, contra $z$. Dividiendo:

$ tan gamma = I/I' tan theta $ <peon-tan-gamma>

(Beer ec. 18.49, pág. 1190.) $bold(omega)$, $bold(H)_G$ y $z$ quedan siempre
en un mismo plano —el que gira con la precesión—, y esta fórmula dice qué tan
lejos de $z$ cae cada uno de los otros dos.

== Precesión directa y precesión retrógrada

#deduccion("de dónde sale el criterio del signo")[
  De la @euler-precesion-estable con $sum bold(M)_O = 0$: $I' dot(psi) + (I' -
  I) dot(phi) cos theta = 0$, así que
  $ dot(psi)/dot(phi) = (I - I')/I' cos theta $
  Con $theta < 90degree$ (el eje de simetría no llega a ser perpendicular al
  eje de precesión), $cos theta > 0$, y el signo de $dot(psi)\/dot(phi)$ —si
  el espín y la precesión giran para el mismo lado o para lados opuestos—
  queda decidido enteramente por el signo de $I - I'$. (Beer §18.11, pág.
  1191, que llega a lo mismo por la geometría de la @peon-tan-gamma.)
]

#cuidado[
  *$I > I'$ (cuerpo alargado, como una varilla o un cilindro largo):
  precesión directa. $I < I'$ (cuerpo achatado, como un disco o una
  moneda): retrógrada.* Con $I > I'$, $dot(psi)$ y $dot(phi)$ tienen el
  mismo signo: el espín y la precesión giran para el mismo lado. Con $I <
  I'$ es al revés, y el Beer lo dice con todas las letras para el satélite
  achatado de su fig. 18.24: «la precesión y el giro tienen sentidos
  opuestos» (pág. 1191). Los dos conos del módulo #M("cinematica-cr") lo muestran sin
  necesidad de ninguna fórmula: si el cono corporal es tangente al espacial
  *por afuera* —dos conos separados que se tocan a lo largo de
  $bold(omega)$, como en la @fig-conos-directa de abajo— la precesión es
  directa; si el corporal *envuelve* al espacial, que queda adentro, es
  retrógrada.

  Y la trampa en la que este apunte ya cayó una vez: la Tierra es achatada,
  y su bamboleo libre —el de Chandler— se describe en todos lados como
  «progrado». No contradice nada. Ese sentido se mide *desde la Tierra*: es
  el eje de rotación dando vueltas alrededor del eje de figura, visto por
  alguien parado encima, o sea el cono corporal. El directa/retrógrada del
  Beer compara el giro con la precesión vista *desde el espacio*. Mezclar
  las dos miradas invierte la respuesta, y con ella la de los Problemas 4,
  5, 6 y 9 de la guía.
]

#fig([Los dos conos del módulo #M("cinematica-cr"), reusados: tangencia *externa*, el
corporal como un cono aparte que toca al espacial desde afuera a lo largo de
$bold(omega)$. Es la configuración de un cuerpo alargado —$I > I'$— y de la
precesión directa (Beer fig. 18.23). El Problema 4 de abajo es del otro
caso: achatado y retrógrado, con el cono espacial adentro del corporal
(Beer fig. 18.24).], fig-conos)
<fig-conos-directa>

#guia("qué ejercicios cubre este módulo")[
  El Problema 4 (el *spacecraft* que precesa, achatado, precesión retrógrada) y
  el Problema 6 (el cilindro de paredes delgadas, el umbral entre directa y
  retrógrada según $ell \/ r$). Los Problemas 5, 7, 8 y 9 son variantes de
  los mismos dos mecanismos —la precesión estable del módulo #M("euler-giroscopo") y la
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
  respecto de su eje de simetría—, la precesión es retrógrada (sección
  anterior).

  *La velocidad de precesión.* De $dot(psi)\/dot(phi) = ((I-I')\/I')
  cos theta$, con $(I-I')\/I' = I\/I' - 1 = 9\/16 - 1 = -7\/16$:
  $ dot(phi) = dot(psi) (I'/(I-I')) 1/(cos theta)
    = -1,5 (16/7) 1/(cos 2degree) $
  $ abs(dot(phi)) = (24/7)/(0,9994) approx 3,431 " rad/s" $

  *El período.*
  $ tau = (2 pi)/abs(dot(phi)) = (2 pi)/(3,431) approx 1,832 " s" $

  *El sentido del spin.* Como $I' > I$, $dot(psi)$ y $dot(phi)$ tienen
  signos opuestos (deducción de la sección anterior). Con $Z$ sobre
  $bold(H)_G$, $dot(phi) = H\/I$ es positiva siempre —$H$ es un módulo—, así
  que $dot(psi) < 0$: el *spin* apunta en el sentido *negativo* de $z$. Es
  exactamente lo que dibuja el Beer en su fig. 18.24, donde el vector
  $dot(psi) hat(k)$ «tiene un sentido opuesto al del eje $z$» (pág. 1191).
  Hasta el 2026-09-25 este apunte contestaba «positivo», con una cuenta
  prolija y el signo al revés: la prolijidad no es un control.

  #clave[
    *El período no depende de $theta$, y eso no es una casualidad de este
    problema puntual.* La @peon-precesion-libre ya lo decía: $dot(phi) = H\/I$
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

  *El umbral.* Directa exige $I > I'$ (sección anterior):
  $ m (r^2/2 + ell^2/12) > m r^2 ==> ell^2/12 > r^2/2 ==> ell^2 > 6 r^2 $
  $ ==> ell/r > sqrt(6) approx 2,449 $

  #clave[
    *En $ell\/r = sqrt(6)$ exactos, los tres momentos de inercia se igualan
    —$I = I'$— y el cilindro se comporta, para esta pregunta, como el cubo
    isótropo del módulo #M("inercia"): sin dirección privilegiada, $bold(H)_G$ y
    $bold(omega)$ quedan paralelos y la distinción entre directa y
    retrógrada deja de tener sentido, porque no hay precesión que separar
    del espín.* Para $ell\/r < sqrt(6)$ —un cilindro corto y ancho, cerca de
    un disco— la precesión es *retrógrada*; para $ell\/r > sqrt(6)$ —largo y
    fino, cerca de una varilla— es *directa*. Una lata de atún precesa al
    revés que un caño. El número exacto no está en
    la guía ni hace falta memorizarlo: lo que importa es *que existe* un
    umbral, y que es la misma pregunta —¿el cuerpo es más achatado o más
    alargado que la esfera que lo iguala?— para cualquier cuerpo de
    revolución, no sólo para este cilindro.
  ]
]

== Cierre de la Parte V, y del apunte

La Parte V es, de punta a punta, el Beer: los capítulos 15 y 18, en el
orden de la lista de la cátedra, con el Sears de puerta de entrada en el
módulo #M("rotacion"). Y se sostiene con una sola herramienta repetida:
derivar un vector cuando el sistema que lo mira está girando —la
@cin-derivada del módulo #M("cinematica-cr"), la «relación fundamental» del
Beer— y aplicarla, primero al momento angular de una
partícula (módulo #M("momento-angular")), después al de un cuerpo entero (módulos #M("inercia") y #M("euler-giroscopo")), hasta
llegar al caso más simple de todos, el de este módulo, en el que ni siquiera
hace falta una cupla para que la física haga algo interesante. El satélite
achatado que precesa solo, sin que nadie lo sostenga, es la misma física que
hace que la Tierra se bambolee y que un giróscopo resista a que le cambien el
eje: un cuerpo con un eje de simetría rápido *siempre* tiene esta rigidez, la
haya pedido alguien o no.

Veintiún módulos después del primer producto vectorial, el apunte termina
donde la cátedra quería que terminara: con un problema que se resuelve
mirando dos conos. Si Aníbal pregunta de dónde salió todo esto, la
respuesta es la de cada sección: del libro que él mandó a leer. Que
lo hayamos leído es la parte que no se esperaba.
