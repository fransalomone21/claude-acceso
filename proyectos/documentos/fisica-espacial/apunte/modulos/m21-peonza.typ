#import "../plantilla.typ": *
#import "../biblioteca/figuras-euler.typ": fig-peonza-componentes, fig-ley-senos, fig-meteorito, fig-nutacion
#import "../biblioteca/figuras-omega.typ": fig-omega-peonza-libre-completa, fig-omega-trompo-completa
// voz: 2026-09-25 -- pasada de la fase 11, tanda (d)

#modulo("Peonza simétrica, precesión directa y retrógrada", clave: "peonza")[
  El caso de la Parte V que se resuelve sin ecuaciones diferenciales:
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
de toda la Parte V: la @euler-precesion-estable
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
afuera— la componente transversal de $bold(H)_G$ es $H sin theta = I' dot(phi)
sin theta$ (la $bold(H)_O$ de la deducción de la precesión estable, en el
módulo #M("euler-giroscopo"), componente sobre $hat(e)$), y como $sin theta$
aparece en los dos lados:

$ dot(phi) = H\/I' $ <peon-precesion-libre>

*La velocidad de precesión no depende de $theta$.* Cualquiera sea el ángulo
de apertura del cono, $bold(H)_G$ es siempre el mismo vector fijo y $I'$ es
siempre el mismo momento transversal: la precesión de un cuerpo libre es
uniforme, sin que haga falta ninguna cupla que la mantenga así.

Que $bold(H)_G$ no cambie no quiere decir que nada cambie. El eje del cuerpo
y $bold(omega)$ sí se mueven: giran alrededor de $bold(H)_G$, cada uno en su
cono, y sus derivadas son las tangentes a esos conos
(@fig-omega-peonza-libre). Para el eje alcanza con $dif hat(k) \/ dif t =
bold(omega) times hat(k)$, porque $hat(k)$ está pegado al cuerpo; el spin no
lo mueve, así que sólo la precesión lo arrastra.

#fig([La peonza libre en el espacio. $bold(H)_G$ queda fijo y hace de eje; el
eje del cuerpo y $bold(omega)$ están en un mismo plano que gira alrededor de
él con $dot(phi) = H \/ I'$. Las derivadas (rojo) son tangentes a los conos:
cambia la dirección de $hat(k)$ y de $bold(omega)$, no su módulo.],
fig-omega-peonza-libre-completa)
<fig-omega-peonza-libre>

== El ángulo del eje instantáneo: $tan gamma = (I\/I') tan theta$

#notacion[
  *Dos ángulos contra el mismo eje $z$, y conviene decir cuál es cuál antes
  de usar la fórmula.* $theta$ es el de arriba: entre $bold(H)_G$ —que acá
  hace de eje fijo, el $Z$ del módulo #M("euler-giroscopo")— y el eje de
  simetría $z$. $gamma$ es nuevo: entre el eje *instantáneo* $bold(omega)$ y
  $z$. Así los usa el Beer en §18.11 (fig. 18.21, pág. 1190) y así los usa
  Aníbal en su resolución del 18.127. Es la misma confusión que el módulo
  #M("cinematica-cr") ya advertía entre $bold(Omega)$ y $bold(omega)$, ahora
  con ángulos: $theta$ dice dónde está el eje de simetría respecto de
  $bold(H)_G$; $gamma$, dónde está $bold(omega)$.
]

Con $I$ el momento axial e $I'$ el transversal (módulo #M("euler-giroscopo")),
y descomponiendo los dos vectores contra $z$: la componente axial de
$bold(H)_G$ es $H cos theta = I omega_z = I omega cos gamma$, y la transversal
$H sin theta = I' omega_"transv" = I' omega sin gamma$ (Beer ecs. 18.46 a
18.48). Dividiendo:

$ tan gamma = I/I' tan theta $ <peon-tan-gamma>

(Beer ec. 18.49, pág. 1190.) $bold(omega)$, $bold(H)_G$ y $z$ quedan siempre
en un mismo plano —el que gira con la precesión—, y esta fórmula dice qué tan
lejos de $z$ cae cada uno de los otros dos. Si el cuerpo es achatado ($I >
I'$), $gamma > theta$: $bold(omega)$ cae *más lejos* del eje que
$bold(H)_G$; si es alargado, más cerca. La @fig-peonza-componentes es la
deducción dibujada: las dos proyecciones de $bold(H)_G$ son las mismas que las
de $bold(omega)$, pero multiplicadas por momentos de inercia distintos.

#fig([Un cuerpo alargado ($I = I'\/2$) sin cuplas, en el plano que forman su
eje $z$ y $bold(H)_G$. Las proyecciones de $bold(H)_G$ sobre $z$ y sobre la
transversal son $I omega_z$ e $I' omega_"t"$. Como acá $I < I'$, a
$bold(omega)$ le toca proporcionalmente más componente axial que a
$bold(H)_G$, y cae más cerca del eje: $gamma < theta$. En un cuerpo achatado
pasa al revés.], fig-peonza-componentes)
<fig-peonza-componentes>
// simbolos: omega_t

== Precesión directa y precesión retrógrada

#deduccion("de dónde sale el criterio del signo")[
  De la @euler-precesion-estable con $sum bold(M)_O = 0$: $I dot(psi) + (I -
  I') dot(phi) cos theta = 0$, así que
  $ dot(psi)/dot(phi) = (I' - I)/I cos theta $
  Con $theta < 90degree$ (el eje de simetría no llega a ser perpendicular al
  eje de precesión), $cos theta > 0$, y el signo de $dot(psi)\/dot(phi)$ —si
  el espín y la precesión giran para el mismo lado o para lados opuestos—
  queda decidido enteramente por el signo de $I' - I$. (Beer §18.11, pág.
  1191, que llega a lo mismo por la geometría de la @peon-tan-gamma.)
]

#cuidado[
  *$I' > I$ (cuerpo alargado, como una varilla o un cilindro largo):
  precesión directa. $I' < I$ (cuerpo achatado, como un disco o una
  moneda): retrógrada.* Con $I' > I$, $dot(psi)$ y $dot(phi)$ tienen el
  mismo signo: el espín y la precesión giran para el mismo lado. Con $I' <
  I$ es al revés, y el Beer lo dice con todas las letras para el satélite
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
$bold(omega)$. Es la configuración de un cuerpo alargado —$I' > I$— y de la
precesión directa (Beer fig. 18.23). El Problema 4 de abajo es del otro
caso: achatado y retrógrado, con el cono espacial adentro del corporal
(Beer fig. 18.24).], fig-conos)
<fig-conos-directa>

=== La figura «Precesiones» de Aníbal: $beta$ contra $gamma$

Aníbal subió una figura suelta, «Precesiones», con los dos casos lado a lado,
y la usó en el parcialito. Tiene *otras letras* que el Beer, y hay que
traducirlas antes de usarla, que es justo lo que pide su «ojo con las
denominaciones». $I$ es el momento axial, igual que en el Beer; $I_0$ es el
*transversal*, el que el Beer y este apunte llaman $I'$. $theta$ es el mismo
del Beer, entre el eje del cuerpo y $bold(H)_G$. Y $beta$ es el ángulo entre
$bold(omega)$ y $bold(H)_G$: *no* es el $gamma$ del Beer, que va de
$bold(omega)$ al eje del cuerpo. Los tres ángulos viven en el mismo plano, así
que se pasa de uno a otro mirando quién queda en el medio: en un cuerpo
alargado $bold(omega)$ queda entre el eje y $bold(H)_G$, y $beta = theta -
gamma$; en uno achatado $bold(H)_G$ queda entre el eje y $bold(omega)$, y
$beta = gamma - theta$. En los dos, $beta = abs(theta - gamma)$.
// simbolos: I_0, beta

#fig([La figura «Precesiones» de Aníbal, redibujada con las letras del Beer
($I'$ donde ella dice $I_0$). Cuerpo simétrico sin cupla, con $bold(H)_G$
fijo y vertical. Cono verde, el espacial: alrededor de $bold(H)_G$, quieto, de
semiángulo $beta$. Cono azul, el corporal: alrededor del eje $z$ del cuerpo, de
semiángulo $gamma$, y va con el cuerpo. Alargado: los conos se tocan por
afuera y el spin $dot(psi)$ va para el mismo lado que la precesión $dot(phi)$.
Achatado: el corporal envuelve al espacial y el spin va al revés.],
fig-precesiones())

*Con las dos manos.* La izquierda cerrada, pulgar para arriba: es
$bold(H)_G$, y no se mueve, porque nadie empuja. La derecha con el pulgar
inclinado: es el eje del cuerpo. Llevá el pulgar derecho a dar vueltas
alrededor del izquierdo sin cambiarle la inclinación: eso es la precesión. Y
mientras, hacé girar la mano derecha sobre su propio pulgar: el spin. En el
cilindro el giro sobre el pulgar va para el mismo lado que la vuelta que da
el pulgar —directa—; en el disco, al revés —retrógrada—. Y si la derecha se
queda quieta respecto de la izquierda, no hay cono: el cuerpo gira sobre un
eje principal, sin bamboleo. Parece un ejercicio de mímica; es la manera más
barata de no confundir el signo en un parcial.

#guia("qué ejercicios cubre este módulo")[
  El Problema 4 (el *spacecraft* que precesa, achatado, precesión retrógrada) y
  el Problema 6 (el cilindro de paredes delgadas, el umbral entre directa y
  retrógrada según $ell \/ r$). Los Problemas 5, 7, 8 y 9 son variantes de
  los mismos dos mecanismos —la precesión estable del módulo #M("euler-giroscopo") y la
  precesión libre de éste— y quedan como práctica adicional, no resueltos
  acá: no agregan un caso conceptual nuevo.
]

#ejemplo("El satélite achatado: el período de una precesión que nadie sostiene", nivel: "a fondo")[
  _(Guía de la cátedra 2026, sección Cuerpo rígido, Problema 4. No está en
  el Beer del disco; como el Problema 5 de la misma guía es el «M 7.99», es
  probable que salga del Meriam, sin confirmar.)_ Un *spacecraft* simétrico
  respecto de $z$ tiene radio de giro axial $k_z = 720$ mm y radios de giro
  transversales iguales, $k = 540$ mm. Sin cuplas externas, el eje $z$
  describe un cono de $theta = 2degree$ alrededor de $bold(H)_G$. La
  velocidad de *spin*, $dot(psi)$, es $1,5$ rad/s. Pide el período de cada
  vuelta de precesión y si el spin apunta en el sentido positivo o negativo
  de $z$.

  *El cociente $I\/I'$ no necesita la masa.* Con $I' = m k^2$ e $I = m k_z^2$,
  y $k_z \/ k = 720\/540 = 4\/3$:
  $ I/I' = (k_z/k)^2 = (4/3)^2 = 16/9 $
  Como $I > I'$ —el radio de giro axial es mayor: el satélite es *achatado*
  respecto de su eje de simetría—, la precesión es retrógrada (sección
  anterior).

  *La velocidad de precesión.* De $dot(psi)\/dot(phi) = ((I'-I)\/I)
  cos theta$, con $(I'-I)\/I = I'\/I - 1 = 9\/16 - 1 = -7\/16$:
  $ dot(phi) = dot(psi) (I/(I'-I)) 1/(cos theta)
    = -1,5 (16/7) 1/(cos 2degree) $
  $ abs(dot(phi)) = (24/7)/(0,9994) approx 3,431 " rad/s" $

  *El período.*
  $ tau = (2 pi)/abs(dot(phi)) = (2 pi)/(3,431) approx 1,832 " s" $

  *El sentido del spin.* Como $I > I'$, $dot(psi)$ y $dot(phi)$ tienen
  signos opuestos (deducción de la sección anterior). Con $Z$ sobre
  $bold(H)_G$, $dot(phi) = H\/I'$ es positiva siempre —$H$ es un módulo—, así
  que $dot(psi) < 0$: el *spin* apunta en el sentido *negativo* de $z$. Es
  exactamente lo que dibuja el Beer en su fig. 18.24, donde el vector
  $dot(psi) hat(k)$ «tiene un sentido opuesto al del eje $z$» (pág. 1191).
  Hasta el 2026-09-25 este apunte contestaba «positivo», con una cuenta
  prolija y el signo al revés: la prolijidad no es un control.

  #clave[
    *El período no depende de $theta$, y eso no es una casualidad de este
    problema puntual.* La @peon-precesion-libre ya lo decía: $dot(phi) = H\/I'$
    no tiene $theta$ adentro. Los $2degree$ del enunciado sólo entran a
    través de $cos theta$ en la relación entre $dot(psi)$ y $dot(phi)$
    —y ahí casi no pesan, porque $cos 2degree = 0,9994$ está a cuatro
    cifras de $1$—. El dato geométrico que de verdad importa es el cociente
    $I\/I' = 16\/9$, no el ángulo del cono.
  ]

  #cuidado[
    *Que $dot(psi)$ sea negativo no quiere decir que el satélite gire «para
    atrás».* La componente de $bold(omega)$ sobre $z$ es $dot(phi) cos theta +
    dot(psi) = 3,429 - 1,5 = 1,929$ rad/s, positiva: el cuerpo gira hacia
    adelante sobre su eje, y lo negativo es su giro *respecto de la terna que
    precesa*, que va más rápido que él. Por eso conviene decir qué se entiende
    por «spin» antes de contestar. Si los $1,5$ rad/s fueran esa componente
    total y no $dot(psi)$, saldría $dot(phi) = 2,668$ rad/s y un período de
    $2,355$ s; se resuelve con la lectura del Beer porque la figura y la
    pregunta por el sentido son las de su §18.11.
  ]

  Y un dato de diseño que el enunciado no pide: este satélite gira sobre su
  eje *mayor* de inercia ($I > I'$), el del lado bueno de la regla del eje
  mayor del módulo #M("euler-giroscopo"). Si tuviera algo que disipe energía,
  el cono de $2degree$ se le cerraría en vez de abrirse. Con los radios de
  giro al revés sería alargado, precesaría en forma directa —$dot(phi) =
  1,930$ rad/s, un período de $3,256$ s— y sería un Explorer 1 esperando su
  turno.
]

#ejemplo("El cilindro de paredes delgadas: el umbral entre directa y retrógrada")[
  _(Guía de la cátedra 2026, sección «Cuerpo rígido», Problema 6.)_ Un cilindro hueco de
  paredes delgadas, radio $r$, longitud $ell$ y masa $m$, rota respecto de su
  eje de simetría y precesa con un ángulo pequeño. ¿Para qué valores de
  $ell\/r$ la precesión es retrógrada, y para cuáles directa?

  *Los dos momentos de inercia.* Toda la masa está a distancia $r$ del eje de
  simetría —pared delgada—, así que el axial es el de un aro:
  $ I = m r^2 $
  El transversal —una tapa de aro más la varilla que la extiende a lo largo
  de $ell$, por el teorema de Steiner— es
  $ I' = m (r^2/2 + ell^2/12) $

  *El umbral.* Directa exige $I' > I$ (sección anterior):
  $ m (r^2/2 + ell^2/12) > m r^2 ==> ell^2/12 > r^2/2 ==> ell^2 > 6 r^2 $
  $ ==> ell/r > sqrt(6) approx 2,449 $

  #clave[
    *En $ell\/r = sqrt(6)$ exactos, los tres momentos de inercia se igualan
    —$I' = I$— y el cilindro se comporta, para esta pregunta, como el cubo
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

#ejemplo("El satélite y el meteorito: precesión libre con números del Beer", nivel: "a fondo")[
  _(Beer, problema 18.127, pág. 1198. No está en la guía: es el que Aníbal
  resolvió en Python y subió como cuaderno, «Problema18_127_Beer.ipynb», junto
  con su resumen del capítulo 18. El libro no trae la respuesta de éste; las
  cuentas de abajo coinciden con las del cuaderno, hechas por separado.)_ Un
  satélite geoestacionario de $800$ lb gira con $bold(omega)_0 = 1,5 hat(j)$
  rad/s alrededor de su eje de simetría $y$ cuando lo golpea, en el punto $B$,
  un meteorito de $6$ oz con velocidad relativa $bold(v)_0 = (-1600; 1300;
  4000)$ ft/s. Radios de giro: $k_x = k_z = 28,8$ in, $k_y = 32,4$ in; $B$
  está a $42$ in del eje y $b = 20$ in por debajo de $G$. Se piden el eje de
  precesión y las velocidades de precesión y de spin después del impacto.

  *Los supuestos, dichos* (lo que pidió Aníbal el 19/10). El meteorito queda
  incrustado y su masa ($0,0116$ slug contra $24,8$) no cambia ni el centro
  de masa ni los momentos de inercia: es un $0,05$ %. Durante el choque la única
  cupla grande es la del impacto, así que el momento angular respecto de $G$
  del conjunto se conserva: el del satélite antes más el del meteorito.

  *Momento angular después del choque.* En unidades del Beer ($g = 32,2$
  ft/s², masas en slug): $I = I_y = m k_y^2 = 181,1$ y $I' = I_x = I_z = m
  k_x^2 = 143,1$ slug·ft² —el eje de simetría tiene el momento *mayor*: es
  achatado—. Con $bold(r)_B = (3,5; -1,667; 0)$ ft:
  $ bold(H)_G = I omega_0 hat(j) + bold(r)_B times m_"met" bold(v)_0
    = (-77,6; 108,6; 21,9) " slug" dot.op "ft"^2\/"s" $
  con módulo $H_G = 135,3$. Ésa es la dirección fija del espacio: el eje de
  precesión. Forma $theta = arccos(108,6\/135,3) = 36,6degree$ con el eje del
  satélite.

  *Velocidad angular y $gamma$.* Componente a componente, $omega_i = H_i\/I_i$:
  $bold(omega) = (-0,543; 0,600; 0,153)$ rad/s, de módulo $0,823$. Su ángulo con
  el eje de simetría sale de la @peon-tan-gamma: $tan gamma = (181,1\/143,1)
  tan 36,6degree$, $gamma = 43,2degree$ —*mayor* que $theta$, como corresponde
  a un cuerpo achatado—. El cuaderno de Aníbal hace exactamente esto.

  *Precesión y spin.* Con la @peon-precesion-libre, $dot(phi) = H_G\/I' =
  0,946$ rad/s; y de $dot(psi)\/dot(phi) = ((I'-I)\/I) cos theta$, $dot(psi) =
  -0,159$ rad/s. El spin sale *negativo*: gira al revés que la precesión,
  precesión *retrógrada*, la del cuerpo achatado. Las dos fórmulas del Beer
  con senos ($dot(phi) = omega sin gamma \/ sin theta$, $dot(psi) = omega
  sin(theta - gamma) \/ sin theta$) dan los mismos dos números: es un buen
  control, porque llegan por otro camino.

  #clave[
    *Un meteorito de 170 gramos pone a un satélite de 360 kilos a precesar
    en un cono de 37°.* No por fuerza bruta: porque viaja a más de un kilómetro por
    segundo y pega lejos del eje, y su momento angular respecto de $G$ —un
    brazo de un metro por una cantidad de movimiento enorme— es del mismo
    orden que el del satélite entero girando a $1,5$ rad/s. El satélite no
    se desvía casi nada; *se tuerce*. Es el Explorer 1 y la regla del eje
    mayor del módulo #M("euler-giroscopo") vista desde el otro lado: lo que
    importa en actitud no es la masa sino el momento angular.
  ]

  Dos detalles del cuaderno, por si lo abrís: la celda «1) Momentos de
  Inercia» en realidad calcula $bold(H)_G$, y `np.atan` existe recién desde
  NumPy 2; con una versión anterior hay que escribir `np.arctan`. La física
  no cambia.
]

== La receta del Beer: impulso, $bold(H)_G$, ángulos y la ley de los senos

Los dos satélites con meteorito —el de arriba y el de la página siguiente—
son el mismo procedimiento, y Aníbal lo dijo sin vueltas al mandar a hacer
el segundo: «hacer este problema es aprender a hacer el resto». El Beer lo
deja escrito en el recuadro de resolución de problemas de §18.11 (pág. 1194,
caso 2b). Son cuatro pasos, y el primero no es de esta sección sino de la
§18.3.

*Paso 1, el impulso* (Beer §18.3, pág. 1155–1156, fig. 18.6). Para un
rígido, las cantidades de movimiento de todas sus partículas se reducen a
$m overline(bold(v))$ aplicado en $G$ más el par $bold(H)_G$, y vale la misma
relación de siempre: cantidades de movimiento antes, más impulsos externos,
igual a cantidades de movimiento después. En un choque sin impulso externo
—el satélite y el meteorito como un solo sistema— lo de antes y lo de después
son *equipolentes*: misma cantidad de movimiento lineal y mismo momento
respecto de $G$. Por eso $bold(H)_G$ después del choque es el del satélite
antes más $bold(r) times m_0 bold(v)_0$ del meteorito.

*Paso 2, de $bold(H)_G$ a $bold(omega)$*, componente a componente en los
ejes principales: $omega_x = H_x \/ I'$, $omega_y = H_y \/ I'$, $omega_z =
H_z \/ I$. De ahí el módulo $omega$ y el ángulo $gamma$ con el eje de
simetría.

*Paso 3, el eje de precesión* es la dirección de $bold(H)_G$, fija desde ese
instante, y $theta$ (entre $bold(H)_G$ y el eje) sale de $tan theta =
H_"transv" \/ H_z$ o de la @peon-tan-gamma.

*Paso 4, la ley de los senos.* $bold(omega) = dot(phi) bold(K) + dot(psi)
hat(k)$ es una suma de dos vectores *oblicuos*: uno sobre el eje de
precesión, el otro sobre el eje de simetría. Dibujados punta con cola forman
un triángulo con lados $dot(phi)$, $dot(psi)$ y $omega$, en el que el ángulo
opuesto a $dot(phi)$ es $gamma$, el opuesto a $dot(psi)$ es $theta - gamma$, y
el opuesto a $omega$ es $180degree - theta$. El teorema del seno da todo de
una:

$ omega / (sin theta) = dot(phi) / (sin gamma) = dot(psi) / (sin(theta - gamma)) $

Si el cuerpo es achatado, $gamma > theta$ y $sin(theta - gamma) < 0$: la
fórmula misma da el spin negativo, la precesión retrógrada. Nadie tiene que
acordarse del signo. El triángulo, dibujado para los dos casos, es la
@fig-ley-senos.

#fig([La ley de los senos del Paso 4: $dot(phi) bold(K)$ (verde, sobre el eje
de precesión) más $dot(psi) hat(k)$ (rojo, paralelo al eje del cuerpo), punta
con cola, dan $bold(omega)$ (azul). A la izquierda, el PR 18.6 a escala; a la
derecha, un cuerpo achatado en esquema (en el Beer 18.127, $dot(psi)$ es apenas
la sexta parte de $dot(phi)$ y el triángulo casi no se ve).], fig-ley-senos)
<fig-ley-senos>

#ejemplo("El satélite de dos discos y el meteorito (Problema Resuelto 18.6 del Beer)", nivel: "a fondo")[
  _(Beer, Problema Resuelto 18.6, pág. 1192 —la página 618 del PDF—,
  mandado a hacer por Aníbal para el parcialito del cap. 18.)_ Un satélite de
  masa $m$ es dinámicamente equivalente a dos discos delgados de masa $m\/2$
  y radio $a = 0,8$ m, unidos por una barra liviana de largo $2 a$. Gira
  libre alrededor de su eje de simetría $z$ a $omega_0 = 60$ rpm $= 6,283$
  rad/s. Un meteorito de masa $m_0 = m\/1000$, a $v_0 = 2000$ m/s paralelo
  a $z$ y relativo al satélite, se incrusta en $C$, a distancia $a$ del eje
  sobre $y$ (@fig-meteorito).

  #fig([El satélite de dos discos del PR 18.6. El meteorito llega paralelo a
  $z$ y pega en $C$, a una distancia $a$ del eje: no cambia la componente de
  $bold(H)_G$ sobre $z$, le agrega $m_0 v_0 a thin hat(i)$ de costado. El
  $bold(H)_G$ que queda forma $theta = 38,5 degree$ con el eje del satélite y
  es, desde ese instante, el eje fijo de la precesión.], fig-meteorito)
  <fig-meteorito>

  *Momentos de inercia.* Axial, dos discos sobre su propio eje: $I = 2 dot.op
  1/2 (m/2) a^2 = 1/2 m a^2$. Transversal, cada disco sobre un diámetro más
  Steiner hasta $G$, a distancia $a$: $I' = 2 [1/4 (m/2) a^2 + (m/2) a^2] =
  5/4 m a^2$. Como $I < I'$, se puede adelantar el final: directa.

  *Paso 1.* El meteorito pega a distancia $a$ del eje con cantidad de
  movimiento paralela a él, así que le agrega momento angular *transversal*:
  $ bold(H)_G = a hat(j) times m_0 v_0 hat(k) + I omega_0 hat(k) = m_0 v_0 a thin hat(i) + I omega_0 hat(k) $
  (Supuesto, dicho: $m_0 = m\/1000$ no cambia ni $G$ ni los momentos de
  inercia.)

  *Paso 2.* $omega_x = m_0 v_0 a \/ I' = 4/5 (m_0/m) (v_0/a) = 2$ rad/s;
  $omega_z = omega_0 = 6,283$ rad/s. Entonces $omega = 6,594$ rad/s
  $= 63,0$ rpm, y $tan gamma = 2 \/ 6,283$, $gamma = 17,7degree$.

  *Paso 3.* $tan theta = H_x \/ H_z = (I' omega_x)\/(I omega_z) = 2,5 dot.op
  0,3183 = 0,796$: el eje de precesión forma $theta = 38,5degree$ con el eje
  del satélite, en el plano $x z$.

  *Paso 4.* Con la ley de los senos, $dot(phi) = omega sin gamma \/ sin
  theta$ y $dot(psi) = omega sin(theta - gamma) \/ sin theta$. Con los
  ángulos redondeados a un decimal, como hace el libro, sale $dot(phi) =
  30,8$ rpm y $dot(psi) = 35,9$ rpm; sin redondear nada, $30,7$ y $36,0$
  rpm, que es lo que dan también $dot(phi) = H_G\/I'$ y la relación entre spin
  y precesión de más arriba. Los dos son el mismo resultado: la diferencia es
  el redondeo del libro, y es exactamente por qué Aníbal dice que no le tiene
  confianza a los números.

  #clave[
    *Las dos velocidades salen positivas: precesión directa*, como
    anticipaban $I < I'$ y $gamma < theta$. Los conos son los de la figura
    18.23 del Beer (pág. 1191, la 617 del PDF, la que Aníbal mandó a
    revisar): el corporal, afinado alrededor del eje del satélite, rueda
    *por afuera* del espacial, que rodea a $bold(H)_G$. El 18.127 de más
    arriba es el mismo problema con el cuerpo achatado, y ahí el corporal
    envuelve al espacial.
  ]
]

== Cuando $theta$ también se mueve: el trompo y las tres conservaciones

La precesión estable del módulo #M("euler-giroscopo") y la peonza libre de este módulo
son los dos casos en que $theta$ queda fijo. El tercero que el Beer
nombra en su recuadro (pág. 1194, caso 3) es el *trompo* con un punto fijo
$O$ sobre su eje y sólo el peso como carga, con $theta$ que puede cambiar:
precesión, nutación y giro, ninguna constante. Es el «bamboleo» de verdad.
Las ecuaciones generales (las del giróscopo del módulo #M("euler-giroscopo")) no son
lineales, así que el Beer aconseja no resolverlas sino usar lo que se
conserva:

- *La energía*, porque el peso es conservativo y el apoyo en $O$ no hace
  trabajo. Con $c$ la distancia de $O$ a $G$:
  $ 1/2 [I' (dot(phi)^2 sin^2 theta + dot(theta)^2) + I omega_z^2] + m g c cos theta = E $
- *El momento angular sobre el eje vertical fijo $Z$*, porque el peso y la
  reacción en $O$ son verticales y no hacen momento alrededor de $Z$:
  $ bold(K) dot.op bold(H)_O = I' dot(phi) sin^2 theta + I omega_z cos theta = "cte" $
- *El momento angular sobre el eje de giro $z$*, porque $O$ y $G$ están los
  dos sobre él: $I omega_z = "cte"$.

Con tres cantidades fijas y tres incógnitas ($dot(phi)$, $dot(theta)$,
$dot(psi)$) para cada $theta$, el trompo queda acotado: $theta$ oscila entre
dos valores, y eso es la nutación (Beer, problemas 18.139 y 18.140). La
precesión estable es el caso particular en que esa oscilación tiene amplitud
cero.

Las dos conservaciones de momento angular salen del mismo dibujo
(@fig-omega-trompo): la cupla del peso respecto de $O$ es horizontal y
perpendicular al eje del trompo, y $dif bold(H)_O = sum bold(M)_O thin dif t$
va para el mismo lado. Un cambio que no tiene componente sobre $Z$ ni sobre
$z$ no puede cambiar las proyecciones de $bold(H)_O$ sobre esos dos ejes.

#fig([El trompo con su $bold(H)_O$. La cupla del peso, $c hat(k) times
(-W bold(K))$, cae sobre la línea de nodos; $dif bold(H)_O$ también. Por eso
las dos proyecciones punteadas, sobre la vertical y sobre el eje del trompo,
quedan fijas mientras el eje precesa y nutaciona.], fig-omega-trompo-completa)
<fig-omega-trompo>

Mirado desde arriba, la punta del eje queda encerrada entre dos circunferencias,
la de $theta_1$ y la de $theta_2$, y el dibujo que hace entre ellas depende de
cómo se largó el trompo (@fig-nutacion). Es el dibujo clásico de la nutación, y
vale más que las tres ecuaciones juntas para contestar qué se ve.
// simbolos: theta_1, theta_2

#fig([La punta del eje de un trompo con nutación, vista desde arriba ($Z$ sale
de la hoja). $theta$ oscila entre $theta_1$ (circunferencia de adentro: el eje
más parado) y $theta_2$. Si se larga con una precesión a favor, la punta hace
ondas; si se larga quieto con el eje en $theta_1$, el peso la tira para afuera
y arriba la precesión se anula un instante: cúspides; si se larga con una
precesión en contra, hace rulos. Esquema: la forma es la que importa, no el
número de vueltas.], fig-nutacion)
<fig-nutacion>

El módulo #M("actitud"), que cierra la Parte V, saca la última suposición que
quedaba: que el cuerpo no cambia de forma y que todo lo que lo tuerce viene de
afuera.
