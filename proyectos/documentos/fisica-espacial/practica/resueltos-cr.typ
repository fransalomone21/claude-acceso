// =====================================================================
//  Cuerpo rigido -- la seccion entera de la guia, resuelta con un workflow
//  (2026-11-15). Pedido de Fran: «la guia completa de cuerpo rigido y los
//  ejercicios que fuimos viendo y que no estan en la guia, todos resueltos
//  con la idea conceptual y el paso a paso, tipo workflow que marca Anibal».
//  El molde de ocho pasos sale de la resolucion manuscrita del Problema 7 que
//  subio Anibal el 15/11 (workflow.typ). Los Problemas 1 a 4 reescriben
//  resueltos-cr-1-a-4.typ con ese molde; los extras (lo que no esta en la
//  guia) los escribe resueltos-cr-extras.typ y entran al final. Cada numero
//  tiene su cuenta en validar.py.
// =====================================================================
#import "workflow.typ": *
#import "../apunte/biblioteca/figuras.typ" as figs
#import "../apunte/biblioteca/estilo.typ": esquema, paneles
#import "../apunte/biblioteca/figuras-euler.typ": _triangulo, _leyenda-senos

#show: documento.with(
  titulo: [Cuerpo rígido — la guía entera, resuelta con un workflow],
  subtitulo: [Problemas 1 a 9 y los dos adicionales de la guía, y los ejercicios que vimos y no están en ella: cada uno con la idea, su utilidad y los mismos ocho pasos],
  encabezado: [Cuerpo rígido — la guía resuelta con el workflow],
)

#let figura(archivo, ancho, epigrafe) = figure(
  image("figuras-cr/" + archivo, width: ancho),
  caption: text(size: 9pt, epigrafe),
)
#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)
#let supuestos(..filas) = {
  set par(justify: false)
  table(
    columns: (1.2fr, 2.2fr, 0.9fr),
    inset: (x: 5pt, y: 4pt),
    table.header(..([Supuesto], [Por qué vale acá], [Cuánto pesa]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t])),
    ..filas.pos().flatten().map(c => text(size: 8.5pt, c)),
  )
}
// El triángulo de velocidades de Aníbal (omega = precesión + spin), con los
// números del problema: theta en grados, y precesión y spin ya escalados.
#let triangulo(th, ph, ps, retro: false, epigrafe) = figure(
  block({
    esquema(escala: 0.85cm, _triangulo(th, ph, ps, retro: retro))
    _leyenda-senos
  }),
  caption: text(size: 9pt, epigrafe),
)

#caja([De dónde sale cada cosa, y cómo usar esto], c-viole)[
  Los once enunciados son la sección *Cuerpo rígido* de la guía de la cátedra
  (versión 5, la del 5/11: Problemas 1 a 9 y los dos *Ejercicios adicionales*),
  recortados tal como los pegó Aníbal. Lo que él subió para estos problemas
  entra donde corresponde: sus resoluciones de los Ejercicios 1 y 2 (clase del
  19/10), el Ejercicio 3 «sin torque externo» (27/10) y el *Problema 7 resuelto
  a mano* (15/11), que es el molde de todo el documento. Al final, en el
  capítulo de *extras*, los ejercicios que vimos en clase y no están en la
  guía.

  *Cómo usarlo.* Leé una vez el capítulo del workflow. Después, en cada
  problema, tapá todo lo que está debajo del enunciado y tratá de recorrer
  los ocho pasos solo; recién ahí compará. El orden de cada problema es
  siempre el mismo: para qué sirve, qué tipo de problema es, la duda, con los
  dedos, los ocho pasos, el resultado y las preguntas del oral.

  #mapa(
    ([1], [Satélite cúbico con un _thruster_: impulso angular y tensor isótropo], [Clase A · «Ejercicio 1 CR 2026» de Aníbal · Beer §18.2]),
    ([2], [Disco en la horquilla: el momento angular y su derivada por el transporte], [Clase B · «Ejercicio 2 CR 2026» · Beer §15.10 y §18.5]),
    ([3], [Volante en el _gimbal_: dónde se van los 600 N·m], [Clase D · «Ej. 3 sin torque externo» · Beer §18.5-18.6]),
    ([4], [_Spacecraft_ que precesa: período y sentido del spin], [Clase C · Beer §18.9 y §18.11]),
    ([5], [Estación de cinco esferas: la precesión libre con un cociente de inercias], [Clase C · Meriam 7/99]),
    ([6], [Cilindro hueco: ¿cuándo directa, cuándo retrógrada?], [Clase C · Beer §18.11]),
    ([7], [Cápsula con un cohete: el problema modelo de Aníbal], [Clase A · «Ej 7 CR» manuscrito de Aníbal]),
    ([8], [La misma cápsula, que ya giraba, con el otro cohete], [Clase A · Beer §18.11]),
    ([9], [Satélite octogonal: todo en función de los parámetros, y después con números], [Clase A · Beer 18.125]),
    ([Ad. 1], [Brazos telescópicos: el empuje que mantiene la velocidad angular], [Clases B y E · Curtis §12]),
    ([Ad. 2], [Rueda de reacción: el par interno no cambia el total], [Clase E · Curtis ej. 12.10]),
  )
]

#notacion[
  La guía le dice «impulso angular» a $bold(L)_G$; acá es el *momento angular*
  $bold(H)_G$, la letra del Beer y de las resoluciones de Aníbal («ojo, $L$ es
  $H$ y $P$ es $L$»), y el *impulso angular* es lo que una cupla le cambia en un
  intervalo: $integral bold(M) dif t = Delta bold(H)$. En un cuerpo con simetría
  de revolución, $I$ es el momento de inercia *axial* (sobre el eje de
  simetría) e $I'$ el *transversal*, como el Beer (§18.10-18.11, págs. 1189-1190)
  y como Aníbal. $bold(omega)$ es la velocidad angular del *cuerpo*;
  $bold(Omega)$, la de la *terna de ejes* desde la que se deriva. No siempre son
  la misma.
  // simbolos: L_G, H_G, M, H, I, I', omega, Omega, L, P, Delta
]

= El workflow: plantear siempre igual

#gancho[
  En el parcial cada problema de cuerpo rígido viene disfrazado distinto —un
  cubo, una cápsula, un octógono, la Tierra— y adentro hay siempre las mismas
  tres o cuatro ideas. Si uno resuelve reconociendo el disfraz, el día que
  aparece uno nuevo se queda en blanco. Si resuelve con un *procedimiento
  fijo*, el disfraz no importa: los ocho pasos se recorren igual y el problema
  se arma solo. Eso es lo que Aníbal llama «armar un workflow», y es lo que
  hace en su hoja del Problema 7: no empieza por la cuenta, empieza por los
  datos, el sistema de referencia y qué vale antes del impulso. Lo simple es
  que el procedimiento es siempre el mismo; lo complicado es elegir bien la
  terna y no confundir $bold(omega)$ con $bold(H)$.
]

#duda[¿Para qué un procedimiento fijo, si cada problema pide una cosa distinta?]

#dedos[
  Por lo mismo que un piloto lee la lista de chequeo aunque haya despegado mil
  veces: no es para el día que todo sale bien, es para el día que algo raro
  aparece y uno no se acuerda de mirar. En cuerpo rígido lo raro es casi
  siempre lo mismo —$bold(H)$ y $bold(omega)$ no son paralelos, la terna gira
  con otra velocidad que el cuerpo, el signo de un producto vectorial— y cada
  paso del workflow está puesto para atajar uno de esos.
]

== Las cuatro ideas que sostienen todo, y para qué sirve cada una

+ *La ley: $sum bold(M)_G = dot(bold(H))_G$*, y su versión integrada para un
  golpe o un encendido corto, $Delta bold(H)_G = integral bold(M)_G dif t$
  (Beer §18.3 y §18.2). Vale respecto del centro de masa $G$ *aunque $G$
  acelere*, y respecto de un punto fijo. *Para qué sirve:* es la única
  ecuación de la rotación; todo lo demás es saber escribir sus dos lados.
  // simbolos: G, M_G, Hdot_G, Delta
+ *$bold(H)_G$ componente a componente:* en ejes principales,
  $bold(H)_G = I_x omega_x hat(i) + I_y omega_y hat(j) + I_z omega_z hat(k)$.
  Cada componente de $bold(omega)$ se multiplica por *su* momento de inercia,
  así que $bold(H)_G$ es paralelo a $bold(omega)$ sólo si los tres son iguales
  (el cubo) o si el cuerpo gira sobre un eje principal. *Para qué sirve:*
  explica por qué un satélite que recibe un golpe no gira «para donde lo
  empujaron» sino que bambolea.
  // simbolos: I_x, I_y, I_z, omega_x, omega_y, omega_z
+ *El teorema del transporte:* $(dif bold(H) \/ dif t)_"inercial" =
  (dif bold(H) \/ dif t)_"terna" + bold(Omega) times bold(H)$, con
  $bold(Omega)$ la velocidad angular *de la terna*, que uno elige (Beer §15.10,
  ec. 15.31). *Para qué sirve:* dice cuánta cupla cuesta hacer girar un
  $bold(H)$ grande; es el «efecto giroscópico», el CMG y la cupla que siente un
  soporte.
+ *El cuerpo simétrico libre de cuplas:* $bold(H)_G$ queda fijo en el espacio
  y el eje de simetría gira a su alrededor. Con los ángulos de Euler,
  $bold(omega) = dot(phi) bold(K) + dot(psi) hat(k)$: $dot(phi)$ es la
  *precesión* (alrededor de $bold(H)_G$, que es el eje $bold(K)$) y $dot(psi)$
  el *spin* (alrededor del eje de simetría $hat(k)$). Si $theta$ es el ángulo
  entre el eje y $bold(H)_G$ y $gamma$ el ángulo entre el eje y $bold(omega)$
  (Beer §18.11, págs. 1189-1191):
  // simbolos: phidot, psidot, K, theta, gamma
  $ tan gamma = I/I' tan theta, quad quad dot(phi) = H_G/I', quad quad dot(psi) = (I' - I)/I dot(phi) cos theta $
  Si el cuerpo es *achatado* ($I > I'$), $gamma > theta$ y la precesión es
  *retrógrada* ($dot(psi) < 0$); si es *alargado* ($I < I'$), $gamma < theta$ y
  es *directa*. *Para qué sirve:* con un solo cociente de inercias se sabe para
  qué lado y con qué rapidez bambolea un satélite, y por qué los que giran
  sobre su eje mayor son estables.
  // simbolos: H_G

== Los ocho pasos

#{
  set par(justify: false)
  table(
    columns: (auto, 1.25fr, 2.3fr, 1.6fr),
    inset: (x: 5pt, y: 4pt),
    table.header(..([], [Paso], [Qué se hace, y la pregunta que hay que hacerse], [El error que ataja]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([W1], [Datos y qué se pide], [Escribir los datos con unidades y la incógnita. ¿Qué se pide *exactamente*: un vector, un ángulo, un período, un sentido?], [Contestar otra cosa: «spin» como $dot(psi)$ o como $omega_z$]),
      ([W2], [Sistema de referencia], [Origen en $G$ (o en el punto fijo) y ejes principales, *dibujados*. Decir a qué está clavada la terna y con qué $bold(Omega)$ gira.], [Meter el spin en $bold(Omega)$ cuando la terna es la del _gimbal_]),
      ([W3], [Qué actúa, y qué se conserva], [Fuerzas y cuplas externas respecto de $G$; el peso en $G$ no hace cupla. Sin cupla externa, $bold(H)_G$ se conserva. Supuestos dichos y, si se puede, con número (ANI-53).], [Olvidar que un par interno (motor, rueda) no cambia el total]),
      ([W4], [El momento angular], [$bold(H)_G$ antes, y $bold(H)_G$ como $I_x omega_x hat(i) + dots.h$ componente a componente.], [Escribir $bold(H) = I bold(omega)$ con un solo $I$]),
      ([W5], [La ecuación que manda], [$Delta bold(H)_G = bold(r) times bold(J)$ para un golpe; $sum bold(M)_G = (dot(bold(H)))_"terna" + bold(Omega) times bold(H)$ para un movimiento sostenido.], [Derivar sólo las componentes y perder el transporte]),
      ([W6], [La geometría], [$theta$ y $gamma$; ¿$gamma > theta$? Directa o retrógrada; el triángulo $bold(omega) = dot(phi) bold(K) + dot(psi) hat(k)$ y la ley de los senos.], [Dar vuelta directa y retrógrada]),
      ([W7], [Verificación], [Otro camino que tiene que dar lo mismo ($dot(phi) = H_G \/ I'$ contra la ley de los senos), unidades, caso límite.], [Un número que nadie miró dos veces]),
      ([W8], [Conclusiones], [Qué hace el cuerpo visto desde afuera, en palabras, y qué pasaría si se cambia un dato («¿y si ya tenía $bold(H)$?»).], [Terminar en un número sin decir qué significa]),
    ).flatten().map(c => text(size: 8.5pt, c)),
  )
}
// simbolos: r, J, Hdot

#anibal[
  Su hoja del Problema 7 es exactamente este recorrido, y vale la pena leerla
  en ese orden. *Datos* ($m$, $I_x$, $I_y$, $I_z$, empuje y tiempo).
  *«Sist. ref. en C.M.»* *$bold(L)_G (t = 0) = 0$*: el estado antes. *$bold(J)
  = E Delta t$*, el impulso, y *$bold(L)_G$ (after) $= bold(r)_A times bold(J)$,
  «luego $bold(L)_G$ = cte»*: lo que actúa y lo que se conserva. *$bold(r)_A =
  (0; 2; -1,25)$ «(verificar)»*: el punto que hay que mirar en la figura. *$tan
  theta = L_(G y) \/ L_(G z)$*: el ángulo entre el eje y $bold(L)_G$. *«De $bold(L)
  // simbolos: m, E, L, r_A, L_G, L_Gy, L_Gz, I_3
  = bold(I) bold(omega)$»* sale $bold(omega)$ componente a componente, con la
  pregunta *«$omega_x = 0$, ¿por qué?»*. *$tan gamma$* y *«como $gamma >
  theta$, precesión retrógrada o inversa»*. El triángulo y *«para calcular
  $dot(phi)$ y $dot(psi)$, ley de los senos»*. Y cierra con *Conclusiones*: «$bold(L)$
  es constante (luego del disparo)», «el cuerpo precesa alrededor de $bold(L)$
  con un ángulo $theta$ de 32°». En su segunda hoja dibuja los dos casos y lo
  dice con una frase que conviene robarle: *«$I_3$ tira de $bold(omega)$ hacia
  $bold(L)$»* (lo explicamos en el Problema 7).
]

== Las cinco clases de problema

Antes de la primera cuenta conviene decir *qué clase de problema es*, porque
eso dice qué pasos cargan el peso:

#{
  set par(justify: false)
  table(
    columns: (auto, 1.7fr, 1.6fr, 1.1fr),
    inset: (x: 5pt, y: 4pt),
    table.header(..([], [Clase], [Qué se conoce y qué se busca], [Problemas]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([A], [Golpe o impulso, y después libre], [Un encendido corto o un choque: $Delta bold(H) = bold(r) times bold(J)$; después, precesión libre. Pesan W4, W5 y W6.], [1, 7, 8, 9; PR 18.6, 18.127, _coning_]),
      ([B], [Se conoce el movimiento, se busca la cupla], [$bold(omega)$ impuesto (horquilla, órbita): $sum bold(M) = bold(Omega) times bold(H)$. Pesan W2 y W5.], [2, Ad. 1; satélite GEO, la Tierra 18.117]),
      ([C], [Libre de cuplas, dado el estado], [Nada actúa: relaciones entre $theta$, $gamma$, $dot(phi)$ y $dot(psi)$. Pesa W6.], [4, 5, 6; la Tierra 18.123]),
      ([D], [Se conoce la cupla, se busca el movimiento], [Ecuaciones de Euler o el transporte despejando la aceleración. Pesan W2 y W5.], [3]),
      ([E], [Partes que se mueven entre sí], [El par interno no cambia el $bold(H)$ total; cada parte por separado. Pesan W3 y W4.], [Ad. 1, Ad. 2; CMG]),
    ).flatten().map(c => text(size: 8.5pt, c)),
  )
}

#posta[
  Los once problemas son la misma película en cinco versiones. En la A le
  pegás al cuerpo y mirás cómo queda bamboleando; en la B lo obligás a girar
  de cierta manera y preguntás cuánto te cuesta; en la C nadie lo toca y sólo
  hay que leer el bamboleo; en la D lo empujás y preguntás qué hace; en la E
  hay algo que gira adentro y el total no se entera. Si sabés en cuál estás,
  ya sabés qué paso del workflow es el difícil.
]

#pagebreak()
= Problema 1 — el satélite cúbico

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 1. El inciso 4 lo agregó Aníbal en «Ejercicio 1 CR 2026» (clase del 19/10). Beer §18.2 y §18.6.]
  #image("recortes/cr-1-1.pdf", width: 100%)
  4. *Addendum (Aníbal, 19/10):* ¿qué pasa con el desplazamiento?
]

#gancho[
  Es el problema más simple de la guía y por eso es el que enseña la
  estructura: un _thruster_ fuera del centro de masa *traslada y hace girar a
  la vez*, y el impulso angular que deja, lo que le cambia al momento angular, es $Delta bold(H) = bold(r) times bold(F) Delta t$. La
  gracia del cubo es que es *isótropo*: sus tres momentos de inercia son
  iguales, $bold(H)_G$ sale paralelo a $bold(omega)$ y no hay bamboleo. Es el
  caso de control contra el que se miden todos los demás: cuando el cuerpo no
  es un cubo, aparece la precesión.
  // simbolos: F
]

#tipo("A")[Un encendido de 4 s y después nada: golpe y libre. Pesan W4 y W5; W6 es corto porque el cubo no precesa, y decir por qué *es* el W6.]

#duda[Si el _thruster_ empuja para $+x$, ¿por qué el cubo no gira alrededor de un eje perpendicular a $x$ cualquiera, sino de uno en particular?]

#dedos[
  Porque lo que hace girar no es la fuerza sino la fuerza *por su brazo*: el
  eje de giro es perpendicular a la vez a la fuerza y a la flecha que va del
  centro al punto donde empuja. Empujá un cubo de juguete por una esquina con
  el dedo: gira alrededor de la diagonal de la cara que el dedo «abraza».
]

#W(1)
Datos: arista $d = 2$ m, masa $m = 120$ kg, empuje $F_E = 4$ N, impulso
específico $I_"sp" = 50$ s, encendido $Delta t = 4$ s, y el dato $I = 1/6 m
d^2$. Se pide $bold(omega)$ al terminar, el caudal $dot(m)$, cuánto tiempo gira
y (Aníbal) qué pasa con la traslación.
// simbolos: d, F_E, I_sp, mdot

#W(2)
Origen en $G$, ejes paralelos a las aristas. Como los tres momentos son
iguales, *cualquier* terna por $G$ es principal: el tensor es $I$ por la
identidad. El _thruster_ está en el vértice $bold(r) = (1; 1; 1)$ m y empuja
sobre la arista paralela a $x$: $bold(F) = (4; 0; 0)$ N.
// simbolos: F

#W(3)
Una fuerza fuera de $G$ equivale a *la misma fuerza en $G$* (traslada) *más
un par* $bold(r) times bold(F)$ (hace girar). Después del encendido no actúa
nada: $bold(H)_G$ se conserva.

#supuestos(
  ([Masa e inercia constantes], [En 4 s se queman $32,6$ g de 120 kg.], [$0,027$ %]),
  ([El empuje gira con el cubo], [Para la rotación no importa: $bold(omega)$ sale paralela a la cupla y la cupla, clavada al cuerpo, está *sobre* ese eje, así que no se mueve. Para la traslación sí (W8).], [$1,4$ % en $Delta v$]),
  ([Sin cuplas externas después], [Arrastre, radiación y campo magnético, chiquitos; el gradiente de gravedad es *cero* en un cubo isótropo (depende de las diferencias entre momentos).], [despreciable]),
)
// simbolos: v

#W(4)
$ I = 1/6 m d^2 = 1/6 (120 " kg")(2 " m")^2 = 80 " kg·m²", quad quad bold(H)_G = I bold(omega) " (cubo isótropo)" $
Antes del encendido, $bold(H)_G = bold(0)$.

#W(5)
La cupla es constante durante los 4 s:
// simbolos: tau
$ bold(tau) = bold(r) times bold(F) = (1; 1; 1) times (4; 0; 0) = (0; 4; -4) " N·m", quad abs(bold(tau)) = 4 sqrt(2) = 5,66 " N·m" $
$ Delta bold(H)_G = bold(tau) Delta t = (0; 16; -16) " N·m·s" $
Es $F$ por un brazo de $sqrt(2)$ m: la distancia de la arista al centro.

#W(6)
$ bold(omega) = (Delta bold(H)_G)/I = (0; 0,2; -0,2) " rad/s", quad abs(bold(omega)) = 0,2 sqrt(2) = 0,283 " rad/s" $
Sobre la diagonal de cara $(0; 1; -1)$. *No hay conos*: $theta = gamma = 0$
porque $bold(omega)$ y $bold(H)_G$ son paralelos; no hay precesión ni spin que
separar. Una vuelta cada $22,2$ s. El caudal sale de la definición de
impulso específico:
$ dot(m) = F_E/(I_"sp" g_0) = (4 " N")/((50 " s")(9,81 " m/s²")) = 8,16 times 10^(-3) " kg/s" $
con $g_0 = 9,81$ m/s², la gravedad estándar con la que se define el impulso específico.
// simbolos: g_0

#figura("cr1-cubo.svg", 55%)[El cubo con el _thruster_ en $(1; 1; 1)$: $bold(F)$ sobre $+x$, y $bold(tau)$ y $bold(omega)$ sobre la diagonal de cara $(0; 1; -1)$.]

#W(7)
El brazo, por geometría: la arista del _thruster_ está a media diagonal de
cara del centro, $sqrt(1^2 + 1^2) = sqrt(2)$ m, y $4 dot.op sqrt(2) = 5,66$ N·m,
igual que el producto vectorial. La masa quemada, $8,16 " g/s" times 4 " s" =
32,6$ g: el supuesto de masa constante queda justificado con un número.

#W(8)
*Gira para siempre* a $0,283$ rad/s alrededor de un eje fijo en el espacio y
en el cuerpo: nada lo frena salvo cuplas chiquitas. Para pararlo hay que
meterle la cupla opuesta: el _thruster_ del vértice $(1; -1; -1)$ empujando
también hacia $+x$ da $(0; -4; 4)$ N·m. *Y el desplazamiento* (inciso de
Aníbal): $G$ acelera con $bold(F) \/ m$ esté donde esté aplicada la fuerza,
$Delta v = F Delta t \/ m = 0,133$ m/s sobre $+x$. Como el cubo gira $32,4$°
mientras empuja, el empuje real se tuerce y el impulso lineal sale $0,131$ m/s
a $10,8$° de $x$: un $1,4$ %.

#figura("cr1-empuje.svg", 70%)[El empuje visto desde la punta de $bold(omega)$, segundo a segundo: gira $32,4$° en el encendido. La suma (verde) es el impulso lineal real, un poco más corto y torcido que el de la cuenta con $bold(F)$ fijo (gris).]

#trampa[
  El _thruster_ diametralmente opuesto, $(-1; -1; -1)$ empujando hacia $-x$,
  *no lo frena: lo acelera*. Da $(0; 4; -4)$ N·m, la misma cupla. Los dos
  juntos son un *par puro*: giran sin trasladar, y por eso los sistemas de
  actitud montan las toberas de a pares.
]

#final[$I = 80$ kg·m²; $bold(omega) = (0; 0,2; -0,2)$ rad/s, de módulo $0,283$ rad/s, sobre una diagonal de cara; $dot(m) = 8,16$ g/s; gira para siempre; $G$ sale a $0,133$ m/s.]

#oral(
  ([¿Por qué el cubo no precesa?], [Porque es isótropo: $bold(H)_G = I bold(omega)$ con un solo $I$, así que $bold(omega)$ es paralela a $bold(H)_G$, que está fijo.]),
  ([¿Y si fuera un prisma?], [El mismo pulso da el mismo $bold(H)_G$, pero $bold(omega)$ ya no le es paralela y empieza a precesar alrededor de él: es el Problema 7.]),
  ([¿Depende el resultado de dónde se apoya la fuerza a lo largo de su recta?], [No: $bold(r) times bold(F)$ no cambia si $bold(r)$ se corre sobre la recta de acción de $bold(F)$.]),
)

= Problema 2 — el disco en la horquilla

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 2 (la figura es del Beer). Resolución de Aníbal: «Ejercicio 2 CR 2026», con tres animaciones (horquilla, disco, inercial). Beer §15.10 y §18.5.]
  #image("recortes/cr-2-1.pdf", width: 100%)
]

#nota[«impulso angular $bold(L)_G$» es el momento angular $bold(H)_G$. El texto dice «eje vertical» pero la figura muestra el eje del disco horizontal y la horquilla girando alrededor de la vertical: se resuelve con la figura, como Aníbal.]

#gancho[
  Es el primer problema donde *nada acelera y sin embargo hace falta una
  cupla*. Las dos rapideces son constantes, pero el $bold(H)_G$ del disco da
  vueltas con la horquilla, y hacer girar un vector cuesta. Esa cupla es la que
  siente el soporte de cualquier rotor que se mueve: la rueda de una moto en
  una curva, el rotor de un CMG, un disco rígido de notebook que alguien gira.
  Lo simple: una sola resta de productos vectoriales. Lo complicado: elegir la
  terna.
]

#tipo("B")[El movimiento está impuesto (las dos rapideces son constantes) y se busca la derivada de $bold(H)_G$, que es la cupla que lo sostiene. Pesan W2 (qué terna) y W5 (el transporte).]

#duda[Si las dos rapideces no cambian, ¿cómo puede ser que la derivada de $bold(H)_G$ no sea cero?]

#dedos[
  Porque $bold(H)_G$ es un vector y puede cambiar sin cambiar de largo: basta
  con que cambie de dirección. Pensá en la aguja de un reloj: mide siempre lo
  mismo y sin embargo su punta tiene velocidad. La parte de $bold(H)_G$ que
  está sobre el eje del disco gira con la horquilla, como la aguja.
]

#W(1)
Disco delgado de masa $m$ y radio $r$; gira a $omega_1$ (constante) sobre su
eje, y la horquilla gira a $omega_2$ (constante) alrededor de la vertical. Se
pide $bold(H)_G$ y $dif bold(H)_G \/ dif t$.
// simbolos: omega_1, omega_2

#W(2)
Tres ternas con origen en $G$, como en la resolución de Aníbal: la
*inercial* $G X Y Z$; la *de la horquilla* $G x y z$ ($z$ sobre el eje del
disco, $y$ sobre la vertical), que gira con $bold(Omega) = omega_2 hat(j)$; y la
*del disco*, que además gira con $omega_1$. Elijo la de la horquilla: ahí las
componentes de $bold(H)_G$ quedan quietas.
// simbolos: X, Y, Z

#W(3)
El peso actúa en $G$: no hace cupla respecto de $G$. $G$ no se mueve. La
horquilla, a través del eje, hace la cupla que se busca. Nada se conserva:
justamente $bold(H)_G$ cambia.

#W(4)
$bold(omega) = omega_2 hat(j) + omega_1 hat(k)$. Los ejes de la horquilla son
principales del disco (su eje y dos diámetros), con $I_z = 1/2 m r^2$ e $I_y =
1/4 m r^2$:
$ bold(H)_G = I_y omega_2 hat(j) + I_z omega_1 hat(k) = 1/4 m r^2 (omega_2 hat(j) + 2 omega_1 hat(k)) $
No es paralelo a $bold(omega)$: sobre el eje del disco la inercia pesa el doble.

#W(5)
// simbolos: underbrace
$ dot(bold(H))_G = underbrace(((dif bold(H)_G)/(dif t))_"horquilla", = 0) + bold(Omega) times bold(H)_G = omega_2 hat(j) times 1/4 m r^2 (omega_2 hat(j) + 2 omega_1 hat(k)) $
La derivada relativa es cero: en la terna de la horquilla las componentes no
cambian (las rapideces son constantes y el disco es redondo alrededor de $z$).

#W(6)
$hat(j) times hat(j) = 0$ y $hat(j) times hat(k) = hat(i)$:
$ dot(bold(H))_G = 1/2 m r^2 omega_1 omega_2 hat(i) $
Horizontal y perpendicular al eje del disco. Visto desde afuera, $bold(H)_G$
tiene una parte vertical fija y una horizontal que gira con la horquilla: barre
un cono alrededor de $Y$, y $dot(bold(H))_G$ es tangente a ese cono.

#figura("cr2-disco.svg", 92%)[*(a)* $bold(omega)$ y $bold(H)_G$ en el plano de la horquilla: no son paralelos; $dot(bold(H))_G$ entra en la hoja, sobre $hat(i)$. *(b)* Desde afuera, $bold(H)_G$ barre un cono alrededor de $Y$: un cuadro de la animación inercial de Aníbal.]

#W(7)
*En la terna del disco* (la parte «opcional» de Aníbal): con $phi.alt =
omega_1 t$, las componentes de $bold(H)_G$ dependen de $phi.alt$, la derivada
relativa ya no es cero y el transporte usa $bold(Omega) = bold(omega)$; sumando
las dos sale otra vez $1/2 m r^2 omega_1 omega_2 hat(i)$, pagando senos y
cosenos que se cancelan. Unidades: kg·m²·s⁻², o sea N·m. Caso límite: sin
horquilla ($omega_2 = 0$) la derivada es cero, como tiene que ser.

#W(8)
Como $sum bold(M)_G = dot(bold(H))_G$, el resultado es *la cupla que la horquilla
le hace al disco*, a través de dos fuerzas verticales opuestas en los brazos.
Con números nuestros (no del enunciado): un disco de 2 kg y 10 cm de radio a
100 rad/s, en una horquilla que da 2 rad/s, pide $1/2 (2)(0,1)^2 (100)(2) =
2,00$ N·m; con los brazos a 5 cm, cada uno empuja 40 N, el doble del peso del
disco.

#trampa[
  Usar en el transporte la $bold(omega)$ del disco con los ejes de la horquilla
  da *la mitad*: $omega_1 hat(k) times 1/4 m r^2 omega_2 hat(j) = -1/4 m r^2
  omega_1 omega_2 hat(i)$ de más. En el transporte va la $bold(Omega)$ *de la
  terna desde la que se deriva*, siempre (ANI-61: «no siempre $bold(Omega) =
  bold(omega)$»).
]

#final[$bold(H)_G = 1/4 m r^2 (omega_2 hat(j) + 2 omega_1 hat(k))$, no paralelo a $bold(omega)$; $dot(bold(H))_G = 1/2 m r^2 omega_1 omega_2 hat(i)$: la cupla que la horquilla le hace al disco.]

#oral(
  ([¿Qué ve cada observador?], [La horquilla ve $bold(H)_G$ quieto (todo es transporte); el disco lo ve girar en un cono alrededor de su eje (mitad y mitad); el inercial, en un cono alrededor de la vertical (todo es derivada relativa). La suma es la misma: ANI-55.]),
  ([¿Depende de la masa de la horquilla?], [No: se pide el momento angular del disco.]),
  ([¿Qué pasa si la horquilla se suelta?], [Sin la cupla, $bold(H)_G$ queda fijo y el disco deja de seguir a la horquilla: pasa a precesar libre, como el Problema 4.]),
)

= Problema 3 — el volante en el _gimbal_

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 3. Aníbal no subió la resolución de éste tal cual: subió el «Ejercicio 3 CR, sin torque externo» (27/10), que está al final. Beer §18.5 y §18.6.]
  #image("recortes/cr-3-1.pdf", width: 100%)
]

#nota[«Kg/m²» es una errata: los momentos de inercia van en kg·m². Los ejes $x y z$ están *clavados al gimbal*: no al volante ni a la plataforma.]

#gancho[
  Es el CMG antes de que se llame CMG. Un volante con mucho $bold(H)$ al que
  la plataforma obliga a dar vueltas: hacer girar ese $bold(H)$ se come casi
  toda la cupla que le aplicás, y sólo lo que sobra acelera al _gimbal_. Leído
  al revés, es cómo un motorcito que gira el eje de una rueda rápida produce
  cuplas enormes sobre un satélite. Lo simple: una ecuación lineal. Lo
  complicado: no meter el spin en la velocidad de la terna.
]

#tipo("D")[Se conoce la cupla (600 N·m) y se busca el movimiento (la aceleración angular del _gimbal_). Pesan W2 (la terna y su $bold(Omega)$) y W5 (la componente $x$ del transporte).]

#duda[Si le aplico 600 N·m a algo con $I_x = 5$ kg·m², ¿no acelera a $600 \/ 5 = 120$ rad/s²?]

#dedos[
  Eso vale si nada gira. Acá el volante tiene un $bold(H)$ de 1000 sobre $z$ y
  la plataforma lo arrastra alrededor de $y$: sólo para acompañarla hace falta
  una cupla sobre $x$. Es como empujar un carrito que ya va en curva: parte de
  tu fuerza se va en doblar, no en acelerar.
]

#W(1)
Volante: $omega_s = 100$ rad/s sobre $z$, $I_x = I_y = 5$ kg·m², $I_z = 10$
kg·m²; plataforma: $omega_p = 0,5$ rad/s sobre $y$; cupla aplicada: $M_x = 600$
N·m. Se pide $dot(Omega)_x$, la aceleración angular del _gimbal_, en el instante
inicial (está quieto respecto de la plataforma: $Omega_x = 0$).
// simbolos: omega_s, omega_p, M_x, Omegadot_x, Omega_x

#W(2)
Terna del _gimbal_, origen en el centro del volante $O$. Gira con la plataforma
y, si el torquer lo mueve, sobre $x$; el volante, además, sobre $z$:
// simbolos: O
$ bold(Omega) = Omega_x hat(i) + omega_p hat(j), quad quad bold(omega) = Omega_x hat(i) + omega_p hat(j) + omega_s hat(k) $
Los ejes del _gimbal_ son principales del volante aunque éste gire, porque es
de revolución sobre $z$.

#W(3)
Actúan la cupla del torquer sobre $x$ y lo que ponga la plataforma sobre $y$
(motor) y el motor del volante sobre $z$. No se conserva nada. Supuestos: el
_gimbal_ sin masa (dato), $omega_s$ y $omega_p$ constantes (los sostienen
motores), el centro del volante fijo.

#W(4)
$ bold(H)_O = I_x Omega_x hat(i) + I_y omega_p hat(j) + I_z omega_s hat(k) = 5 Omega_x hat(i) + 2,5 hat(j) + 1000 hat(k) " kg·m²/s" $
// simbolos: H_O

#W(5)
Componente $x$ de $sum bold(M) = (dot(bold(H)))_"gimbal" + bold(Omega) times bold(H)$; la de
$bold(Omega) times bold(H)$ es $Omega_y H_z - Omega_z H_y$:
// simbolos: Omega_y, Omega_z, H_y, H_z
$ M_x = I_x dot(Omega)_x + (omega_p H_z - 0 dot.op H_y) quad ==> quad 600 = 5 dot(Omega)_x + (0,5)(1000) $

#W(6)
$ dot(Omega)_x = (600 - 500)/5 = 20 " rad/s²" $
De los 600 N·m, *500 se van en hacer girar $bold(H)$ con la plataforma* y
sólo 100 aceleran al _gimbal_. Las otras dos componentes, en $t = 0$, dan $M_y =
M_z = 0$; apenas el _gimbal_ gira, la plataforma tiene que poner $M_y = -Omega_x H_z$.
// simbolos: M_y, M_z

#figura("cr3-gimbal.svg", 92%)[*(a)* $bold(H)$ enorme sobre $z$, $bold(Omega)$ sobre $y$ y $bold(Omega) times bold(H)$ sobre $x$, donde actúa el torquer. *(b)* Los 600 N·m: 500 en girar $bold(H)$, 100 en acelerar.]

#W(7)
La fórmula $dot(Omega)_x = (M_x - omega_p I_z omega_s) \/ I_x$ en sus casos
límite: sin plataforma o con el volante quieto da $120$ rad/s², la de Física 1;
con $M_x = 500$ N·m el _gimbal_ no se mueve (es la *cupla giroscópica*); con el
volante a 120 rad/s, tampoco; a 200 rad/s, $dot(Omega)_x = -80$ rad/s²: acelera
*al revés* de la cupla.

#figura("cr3-barrido.svg", 64%)[$dot(Omega)_x$ contra la velocidad del volante: arranca en 120 (sin giróscopo), pasa por 20 (el problema) y se anula en $omega_s = 120$ rad/s.]

#W(8)
El _gimbal_ arranca a 20 rad/s². *La variante de Aníbal, sin cupla externa*
(«Ej. 3 sin torque externo», 27/10): con $M_x = 0$, la misma ecuación da
$ dot(Omega)_x = - (I_z omega_s omega_p)/I_x = - (10 dot.op 100 dot.op 0,5)/5 = -100 " rad/s²" $
y él cierra con «el sistema evoluciona oscilando, ver animación»: el _gimbal_
no se queda quieto ni se va, *oscila*, porque apenas gira aparece otra cupla
giroscópica que lo devuelve. Leído desde el satélite, esto es un CMG: girar el
eje de un volante rápido a $0,5$ rad/s produce 500 N·m sobre lo que lo sostiene.

#trampa[
  Dividir $600 \/ 5 = 120$ rad/s² ignora el transporte y da seis veces de más.
  Y el error que lo produce casi siempre es meter el spin dentro de
  $bold(Omega)$: la terna es la del _gimbal_, que *no* gira con $omega_s$.
]

#anibal[
  En la variante escribe $bold(M)_"ext" = (dif bold(L) \/ dif t)_"móvil" +
  bold(Omega) times bold(L)$ con «sist. coord. fijo al gimbal» resaltado,
  $bold(Omega) = dot(theta) hat(i) + omega_p hat(j) = omega_p hat(j)$ «estado
  inicial», $bold(L) = A dot(theta) hat(i) + B omega_p hat(j) + C omega_s
  hat(k)$ (sus $A$, $B$, $C$ son nuestros $I_x$, $I_y$, $I_z$) y llega a $dot.double(theta)
  = -C omega_s omega_p \/ A = -100$ rad/s². Es el W2 y el W5 de este problema,
  con $M_x = 0$.
  // simbolos: thetadot, thetaddot, A, B, C, M_ext
]

#final[$dot(Omega)_x = 20$ rad/s² en el instante inicial (500 de los 600 N·m se van en girar $bold(H)$); sin cupla externa, $-100$ rad/s², y el _gimbal_ oscila.]

#oral(
  ([¿Qué cupla deja quieto al _gimbal_?], [$omega_p I_z omega_s = 500$ N·m: la cupla giroscópica, la misma del Problema 2.]),
  ([¿Depende de $I_y$?], [No en $t = 0$: $I_y omega_p$ es paralelo a $bold(Omega)$ y no aporta al transporte.]),
  ([¿Por qué oscila sin cupla?], [Si el _gimbal_ gira sobre $x$, el transporte $Omega_x hat(i) times I_z omega_s hat(k)$ aparece sobre $y$ y cambia la cupla sobre $x$ que hace falta: se arma un vaivén, como un péndulo.]),
)

= Problema 4 — el _spacecraft_ que precesa

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 4. Beer §18.9 (ángulos de Euler) y §18.11 (cuerpo simétrico sin cuplas). Sevilla, lección 7, diap. 5 a 9.]
  #image("recortes/cr-4-1.pdf", width: 100%)
]

#nota[«Velocidad angular de spin» se lee como $dot(psi)$, el giro del cuerpo *respecto de la terna que precesa* (Beer §18.9); con la otra lectura la respuesta cambia, y está en W7.]

#gancho[
  Nada toca al satélite y sin embargo su eje bambolea: es la *precesión libre*,
  la solución más simple de las ecuaciones de Euler. Con un solo cociente de
  inercias se sabe con qué rapidez y para qué lado bambolea, y si el satélite
  está girando sobre su eje bueno (el mayor) o sobre el malo. Es lo que
  diferencia al Sputnik, que giraba tranquilo, del Explorer 1, que a las horas
  daba tumbos.
]

#tipo("C")[Libre de cuplas, con el estado dado ($theta = 2$°, el spin): no hay ecuación de movimiento que integrar, sólo leer el bamboleo. Pesa W6.]

#duda[Si nada actúa, ¿por qué el eje no se queda quieto?]

#dedos[
  Porque lo que queda quieto es $bold(H)_G$, no el eje. El satélite no gira
  exactamente sobre un eje principal, así que $bold(omega)$ y $bold(H)_G$ no
  coinciden, y el eje del cuerpo da vueltas alrededor de $bold(H)_G$ como una
  moneda que gira inclinada sobre la mesa.
]

#W(1)
Radio de giro axial $k_z = 720$ mm, transversal $k = 540$ mm; el eje describe
un cono de $theta = 2$° alrededor de $bold(H)_G$; spin $dot(psi) = 1,5$ rad/s. Se
pide el período de precesión y el sentido del spin.
// simbolos: k_z, k

#W(2)
Terna inercial con $bold(K)$ sobre $bold(H)_G$ (que está fijo) y terna del
cuerpo con $hat(k)$ sobre el eje de simetría. Ángulos de Euler: $dot(phi)$
alrededor de $bold(K)$, $dot(psi)$ alrededor de $hat(k)$, $theta$ entre los dos.

#W(3)
Sin cuplas externas (gradiente de gravedad, arrastre y radiación, despreciados
en una vuelta de 2 s): $bold(H)_G$ se conserva. Cuerpo rígido sin disipación.

#W(4)
$I = m k_z^2$ (axial) e $I' = m k^2$ (transversal); la masa no hace falta:
$ I/I' = (720/540)^2 = 16/9 > 1 $
El cuerpo es *achatado* respecto de su eje: gira sobre su eje mayor.

#W(5)
$bold(omega) = dot(phi) bold(K) + dot(psi) hat(k)$; que $bold(H)_G$ esté sobre
$bold(K)$ obliga a (Beer §18.11, págs. 1190-1191)
$ dot(psi) = (I' - I)/I dot(phi) cos theta, quad quad dot(phi) = H_G/I' > 0 $

#W(6)
Con $(I' - I) \/ I = 9\/16 - 1 = -7\/16$:
// simbolos: T, pi
$ abs(dot(phi)) = (1,5)/((7/16)(cos 2 degree)) = 3,431 " rad/s", quad quad T = (2 pi)/abs(dot(phi)) = 1,832 " s" $
con $T$ el período de una vuelta de precesión.
$dot(phi) > 0$ y $(I' - I)\/I < 0$: $dot(psi) < 0$, *el spin apunta hacia $-z$*.
Precesión *retrógrada*: $tan gamma = (16\/9) tan 2 degree$ da $gamma = 3,55$°,
mayor que $theta$; el cono espacial queda adentro del corporal (Beer fig. 18.24, pág. 1191).

#figura("cr4-conos.svg", 88%)[Los conos (ángulos exagerados). *(a)* Este satélite: $bold(H)_G$ entre $z$ y $bold(omega)$, cono espacial adentro del corporal: retrógrada. *(b)* Con los radios de giro al revés: alargado, conos por afuera, directa.]

#W(7)
La componente de $bold(omega)$ sobre $z$ es $dot(phi) cos theta + dot(psi) = 3,429
- 1,5 = 1,929$ rad/s, positiva: el cuerpo gira «para adelante»; lo negativo es
el giro respecto de la terna que precesa. *Con la otra lectura* (si $1,5$ fuera
$omega_z$): $omega_z = (I'\/I) dot(phi) cos theta$ da $dot(phi) = 2,668$ rad/s y $T
= 2,355$ s. En un examen se escribe cuál se usó.
// simbolos: omega_z

#W(8)
El eje de simetría da una vuelta alrededor de $bold(H)_G$ cada $1,83$ s, para
el lado contrario al spin relativo. Gira sobre su eje mayor, así que con
disipación el cono de 2° se *cierra*: es estable. Si fuera alargado
(radios al revés), precesaría directo con $dot(phi) = 1,930$ rad/s ($T = 3,256$
s) y, con disipación, terminaría dando tumbos como el Explorer 1.

#final[$abs(dot(phi)) = 3,431$ rad/s, período $1,832$ s; el spin apunta hacia $-z$: achatado ($I\/I' = 16\/9$), precesión retrógrada.]

#oral(
  ([¿Que $dot(psi)$ sea negativo quiere decir que gira para atrás?], [No: $omega_z = 1,929$ rad/s es positiva. Lo negativo es el giro respecto de la terna que precesa, que va más rápido que el cuerpo.]),
  ([¿Depende de la masa?], [No: sólo entra el cociente $k_z^2 \/ k^2$.]),
  ([¿Y si el ángulo fuera 20° en vez de 2°?], [Cambia poco: el período depende de $cos theta$; con 20°, $T = 1,722$ s. Lo que manda es el cociente de inercias.]),
)

= Problema 5 — la estación de cinco esferas

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 5 («M 7.99»: Meriam, Dinámica, problema 7/99). Beer §18.11.]
  #image("recortes/cr-5-1.pdf", width: 100%)
  #image("recortes/cr-5-2.pdf", width: 55%)
]

#nota[La redacción se enreda («respecto al eje A-A respecto a O»); el dato del Meriam es una razón: el momento de inercia respecto del eje $A$-$A$ es *el doble* del que tiene respecto de cualquier eje por $O$ perpendicular a $A$-$A$. La figura lo avala: cinco esferas en un plano, y para masas en un plano el teorema de los ejes perpendiculares da justo la mitad.]

#gancho[
  Las estaciones espaciales giratorias —la de _2001_, los diseños de von Braun—
  giran sobre su eje para tener gravedad artificial en el borde. Este problema
  pregunta qué pasa si ese eje queda un poquito torcido: la estación bambolea,
  y el bamboleo tiene una rapidez fija que sale de un solo número, el cociente
  de inercias. Lo simple: no hacen falta ni las masas ni las distancias. Lo
  complicado: leer el enunciado.
]

#tipo("C")[Libre de cuplas («el centro de masa no está acelerado»), con el estado dado: el spin y un ángulo chico. Pesa W6; W4 se reduce a un cociente.]

#duda[¿Cómo calculo la precesión si no me dan ni la masa de las esferas ni sus distancias?]

#dedos[
  No hacen falta: la precesión libre depende sólo de *cuánto más pesada es la
  inercia axial que la transversal*, y eso te lo dan como «el doble». Es como
  saber que una moneda bambolea más rápido de lo que gira sin saber cuánto
  pesa la moneda.
]

#W(1)
$I_(A A) = 2 I'$ (axial el doble que la transversal); spin $3$ rev/min;
ángulo chico entre $A$-$A$ y el eje fijo $Z$. Se pide la precesión $dot(chi)$
(la letra del Meriam para nuestro $dot(phi)$).
// simbolos: I_AA, chidot

#W(2)
$bold(K)$ sobre $Z$, que es la dirección de $bold(H)_O$ (fijo); $hat(k)$ sobre
$A$-$A$, el eje de simetría. Origen en el centro de masa $O$.

#W(3)
Sin cuplas externas: $bold(H)_O$ se conserva. Ángulo chico: $cos theta approx 1$.

#W(4)
$I = I_(A A) = 2 I'$: un cuerpo *achatado* (plano), $I > I'$.

#W(5)
$ dot(psi) = (I' - I)/I dot(phi) cos theta = (I' - 2 I')/(2 I') dot(phi) cos theta = - 1/2 dot(phi) cos theta $

#W(6)
$ abs(dot(phi)) = 2 abs(dot(psi)) = 2 (3 " rev/min") = 6 " rev/min" = 0,628 " rad/s" $
Una vuelta de bamboleo cada $10,0$ s. *Retrógrada*: el spin relativo va al
revés que la precesión, porque el cuerpo es achatado.

#W(7)
*Con la otra lectura de «spin»* (los 3 rev/min como componente total sobre
el eje): $omega_z = dot(phi) cos theta + dot(psi) = dot(phi) - 1/2 dot(phi) = 1/2
dot(phi)$, así que $dot(phi) = 2 omega_z = 6$ rev/min otra vez. En este cuerpo
las dos lecturas dan lo mismo, que es una casualidad del «doble»: verificado
por las dos fórmulas.

#W(8)
La estación bambolea dos veces por cada vuelta que da sobre su eje. Como gira
sobre su eje *mayor*, es estable: con disipación (gente caminando, agua que se
mueve) el bamboleo se amortigua en vez de crecer.

#final[$dot(chi) = 6$ rev/min $= 0,628$ rad/s (período $10,0$ s), retrógrada: la estación es achatada, $I = 2 I'$.]

#oral(
  ([¿Por qué «el doble»?], [Para masas en un plano, $I_z = I_x + I_y$ (ejes perpendiculares); con simetría $I_x = I_y$, el axial es el doble del transversal.]),
  ([¿Depende de la masa o del tamaño de la estación?], [No: sólo del cociente $I \/ I'$.]),
)

= Problema 6 — el cilindro hueco: ¿directa o retrógrada?

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 6. Beer §18.11 y la tabla de momentos de inercia.]
  #image("recortes/cr-6-1.pdf", width: 100%)
  #image("recortes/cr-6-2.pdf", width: 55%)
]

#gancho[
  Es el problema de *diseño* de la guía: sin un solo número, pregunta qué forma
  hay que darle a un cuerpo para que bambolee para un lado o para el otro. La
  respuesta es una frontera para el cociente entre el largo $ell$ y el radio $r$, $ell \/ r = sqrt(6)$, y separa
  // simbolos: ell
  los cuerpos tipo disco (achatados, retrógrados, estables girando sobre su eje) de los tipo
  lápiz (alargados, directos, inestables con disipación: el Explorer 1). Saber
  de qué lado está un satélite es saber si se puede estabilizar por giro.
]

#tipo("C")[Libre de cuplas; no se pide un número sino el signo de $I' - I$. Pesan W4 (los dos momentos) y W6 (el criterio).]

#duda[¿Qué tiene que ver el largo del tubo con el sentido en que bambolea?]

#dedos[
  El largo sólo le suma inercia a los ejes *transversales* (los que lo hacen
  dar vueltas «de punta»), no al axial. Tubo cortito: el axial gana, es una
  moneda. Tubo largo: el transversal gana, es un lápiz. Y moneda y lápiz
  bambolean para lados opuestos.
]

#W(1)
Cilindro de paredes delgadas (sin tapas), masa $m$, radio $r$, largo $ell$;
precesión de ángulo chico. Se pide para qué $ell \/ r$ es directa y para cuáles
retrógrada.

#W(2)
$hat(k)$ sobre el eje del cilindro, origen en $G$; dos diámetros transversales
por $G$.

#W(3)
Sin cuplas: $bold(H)_G$ fijo, precesión libre.

#W(4)
Toda la masa está a distancia $r$ del eje (tabla de momentos de inercia):
$ I = m r^2, quad quad I' = 1/2 m r^2 + 1/12 m ell^2 $

#W(5)
$dot(psi) = (I' - I) \/ I dot(phi) cos theta$: el signo de $I' - I$ decide.
Directa si $I' > I$; retrógrada si $I' < I$.

#W(6)
$ I' > I quad <==> quad 1/12 ell^2 > 1/2 r^2 quad <==> quad ell/r > sqrt(6) = 2,449 $
*Directa* para $ell \/ r > sqrt(6)$ (largo, tipo lápiz) y *retrógrada* para
$ell \/ r < sqrt(6)$ (corto, tipo anillo). En $ell \/ r = sqrt(6)$ los tres
momentos son iguales: el tubo se porta como el cubo del Problema 1 y no
precesa.

#W(7)
Casos límite: $ell -> 0$ es un anillo, $I' = I \/ 2$, achatado: retrógrado, como
una moneda (el Beer 18.129, la moneda que se lanza, da retrógrada). $ell ->
oo$ es una varilla: $I'$ crece sin límite, alargado, directa.

#W(8)
Un satélite cilíndrico estabilizado por giro tiene que ser *más ancho que
alto* en este sentido ($ell < 2,45 thin r$ para un tubo), así gira sobre su eje
mayor y la disipación lo estabiliza. El Explorer 1, un lápiz con antenas, estaba
del lado equivocado de esta frontera.

#final[Directa para $ell \/ r > sqrt(6) approx 2,45$; retrógrada para $ell \/ r < sqrt(6)$; en el límite, isótropo y sin precesión.]

#oral(
  ([¿Depende de la masa?], [No: $m$ multiplica a los dos momentos y se cancela en la comparación.]),
  ([¿Y si el cilindro fuera macizo?], [$I = 1/2 m r^2$, $I' = 1/4 m r^2 + 1/12 m ell^2$: la frontera pasa a $ell \/ r = sqrt(3)$.]),
)

= Problema 7 — la cápsula con un cohete: el problema modelo

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 7. Aníbal subió su resolución a mano el 15/11 («Ej 7 CR»): es el molde de este documento. Beer §18.11.]
  #image("recortes/cr-7-1.pdf", width: 100%)
  #image("recortes/cr-7-2.pdf", width: 52%)
]

#gancho[
  Es *el* problema de la clase A, y por eso Aníbal lo resolvió entero: un
  cohete de actitud se enciende un segundo, le deja a la cápsula un momento
  angular que ya no cambia, y la cápsula queda girando y bamboleando para
  siempre. Todo lo que hay que saber del cuerpo simétrico libre aparece una
  vez: el impulso angular, $bold(omega)$ que no es paralela a $bold(H)$, los dos
  ángulos, el sentido de la precesión y el triángulo de velocidades. Lo simple:
  el impulso es un solo producto vectorial. Lo complicado: no perder signos.
]

#tipo("A")[Golpe (1 s de cohete) y después libre. Pesan W4, W5 y W6: los tres pasos de la hoja de Aníbal.]

#duda[Si el cohete empuja en $x$, ¿por qué la cápsula no gira alrededor de un eje perpendicular a $x$ y listo, como el cubo?]

#dedos[
  Gira con un $bold(H)$ que sí es perpendicular a $x$; pero la cápsula no es un
  cubo: sobre su eje tiene más inercia que de costado. Entonces la componente de
  $bold(omega)$ sobre el eje sale *más chica* (en proporción) que la de
  $bold(H)$, y $bold(omega)$ queda torcida respecto de $bold(H)$. Esa torcedura
  es la que hace bambolear.
]

#W(1)
Datos: $m = 1000$ kg, radios de giro $k_x = k_y = 1$ m y $k_z = 1,25$ m;
empuje $E = 50$ N en $+x$ durante $Delta t = 1$ s; la cápsula arranca sin
girar. Se pide el eje de precesión y las velocidades de spin y de precesión.
// simbolos: k_x, k_y

#W(2)
Origen en el centro de masa $G$, ejes principales $x y z$ de la figura ($z$
sobre el eje de simetría). La cápsula es de revolución: $I = m k_z^2$ axial e
$I' = m k_x^2$ transversal.

#W(3)
Durante el segundo actúa el empuje en $A$; después, nada: $bold(H)_G$ se
conserva («luego $bold(L)_G$ = cte», Aníbal). Supuesto: el encendido es corto
frente a lo que gira la cápsula mientras dura, así que el impulso es $bold(J)
= E Delta t thin hat(i) = 50 thin hat(i)$ N·s, aplicado en un punto que no se movió.
De la figura, *$A$ está en el borde de la base*: $bold(r)_A = (0; 2; -1,25)$ m
(las cotas de 2 m y 1,25 m son radio y altura respecto de $G$; la coordenada
$x$ no importa, ver W5).

#W(4)
Antes: $bold(H)_G (t = 0) = bold(0)$. Momentos:
$ I' = 1000 (1)^2 = 1000 " kg·m²", quad quad I = 1000 (1,25)^2 = 1562,5 " kg·m²" $

#W(5)
$ bold(H)_G = bold(r)_A times bold(J) = (0; 2; -1,25) times (50; 0; 0) = (0; -62,5; -100) " kg·m²/s" $
Pensado en voz alta: el impulso va sobre $x$, así que el producto vectorial no
puede tener componente $x$; la parte $y$ sale de la altura de $A$ ($-1,25$ por
50) y la parte $z$, del radio ($-2$ por 50). La coordenada $x$ de $A$ se cancela
sola: $bold(r)$ y $bold(r) + c hat(i)$ (corrido un largo $c$ cualquiera sobre $x$) dan el mismo producto con un $bold(J)$
// simbolos: c
sobre $hat(i)$. $abs(bold(H)_G) = 117,9$ kg·m²/s.

#W(6)
*$theta$, entre el eje de simetría y $bold(H)_G$*:
$ tan theta = abs(H_y)/abs(H_z) = (62,5)/100 = 0,625 quad ==> quad theta = 32,0 degree $
(medido desde $-z$, que es hacia donde apunta $bold(H)_G$; desde $+z$ son
$148$°). *$bold(omega)$ componente a componente*, cada una con su momento:
$ omega_y = (-62,5)/1000 = -0,0625 " rad/s", quad omega_z = (-100)/(1562,5) = -0,0640 " rad/s", quad omega_x = 0 $
«$omega_x = 0$, ¿por qué?»: porque la componente $H_x$ de $bold(H)_G$ es cero y el eje $x$ es principal. *$gamma$,
// simbolos: H_x
entre el eje y $bold(omega)$*:
$ tan gamma = (0,0625)/(0,0640) = 0,977 quad ==> quad gamma = 44,3 degree $
*Como $gamma > theta$, precesión retrógrada*: el cuerpo es achatado, $I = 1562,5
> I' = 1000$. El triángulo $bold(omega) = dot(phi) bold(K) + dot(psi) hat(k)$
tiene lados $dot(phi)$, $dot(psi)$ y $omega = 0,0895$ rad/s, y ángulos que
salen de $theta$ y $gamma$; por la ley de los senos:
$ (dot(phi))/(sin gamma) = omega/(sin theta) = (abs(dot(psi)))/(sin(gamma - theta)) $
$ dot(phi) = 0,0895 (sin 44,3 degree)/(sin 32,0 degree) = 0,118 " rad/s", quad quad abs(dot(psi)) = 0,0895 (sin 12,3 degree)/(sin 32,0 degree) = 0,0360 " rad/s" $
// simbolos: E

#triangulo(32.0, 3.3, -1.0, retro: true)[El triángulo de la hoja de Aníbal con los números del Problema 7, dibujado en el plano de $bold(H)_G$ y el eje de simetría: $bold(omega)$ (azul) es la suma de la precesión sobre $bold(H)_G$ (verde) y el spin sobre el eje (rojo), que en la retrógrada va para atrás.]

#W(7)
*Por las fórmulas del cuerpo simétrico*, sin triángulo: $dot(phi) = H_G \/ I' =
117,9 \/ 1000 = 0,118$ rad/s, y $dot(psi) = (I' - I)\/I dot(phi) cos theta =
(-562,5 \/ 1562,5)(0,118)(0,848) = -0,0360$ rad/s. Coinciden. En las unidades de
Aníbal: $dot(phi) = 7,07$ rad/min y $abs(dot(psi)) = 2,16$ rad/min, que son
los números de su hoja.

#W(8)
Después del disparo, $bold(H)_G$ queda fijo en el espacio, a $32$° del eje de
la cápsula. El eje de simetría da una vuelta alrededor de $bold(H)_G$ cada
$53,3$ s (precesión), mientras la cápsula gira sobre sí misma al revés (spin
negativo, retrógrada). Y el centro de masa sale despedido a $E Delta t \/ m =
0,05$ m/s sobre $+x$.

#anibal[
  Su segunda hoja dibuja los dos casos y dice *«$I_3$ tira de $bold(omega)$
  hacia $bold(L)$»*. Leído con cuidado: $bold(omega) = H_x \/ I_x thin hat(i) + dots.h + H_3 \/ I_3 hat(k)$;
  cuanto más grande es el momento de una componente, más *chica* queda esa
  componente de $bold(omega)$ comparada con la de $bold(H)$. Si $I_3 > I_x$, la
  componente axial de $bold(omega)$ se encoge más que la transversal y
  $bold(omega)$ se abre *más lejos* del eje que $bold(H)$: $gamma > theta$,
  retrógrada (su caso 2). Si $I_x > I_3$, es al revés: $bold(omega)$ queda entre
  el eje y $bold(H)$, $theta > gamma$, directa (su caso 1, «caso inverso»).
  // simbolos: H_3
]

#trampa[
  Calcular $theta$ con las componentes de $bold(omega)$ o $gamma$ con las de
  $bold(H)$: los dos ángulos se cruzan y la conclusión directa/retrógrada se
  da vuelta. $theta$ es de $bold(H)$, $gamma$ es de $bold(omega)$; y la regla
  «$gamma > theta$, retrógrada» sólo vale si los dos se miden desde la misma
  punta del eje.
]

#final[$bold(H)_G = (0; -62,5; -100)$ kg·m²/s, fijo: es el eje de precesión, a $theta = 32,0$° del eje de simetría; $gamma = 44,3$°, retrógrada; $dot(phi) = 0,118$ rad/s ($7,07$ rad/min) y $dot(psi) = -0,0360$ rad/s ($2,16$ rad/min, al revés).]

#oral(
  ([¿Por qué $omega_x = 0$?], [Porque $bold(r) times bold(J)$ es perpendicular a $bold(J)$, que va sobre $x$: $H_x = 0$, y en ejes principales $omega_x = H_x \/ I_x$.]),
  ([¿Depende de la masa de la cápsula?], [La precesión sí: $dot(phi) = H \/ I'$, y a igual impulso una cápsula más pesada bambolea más lento. Los ángulos sólo dependen de los cocientes.]),
  ([¿Y si el cohete fuera el $B$?], [Cambia $bold(r)$ y con él $bold(H)$: es el Problema 8.]),
)

= Problema 8 — la misma cápsula, que ya giraba, con el cohete $B$

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 8. La guía lo rotula «Beer 18.126»; en la edición del Beer que tenemos ese número es el del octógono con los propulsores A y D (pág. 1198), así que el rótulo es de otra edición.]
  #image("recortes/cr-8-1.pdf", width: 100%)
]

#gancho[
  El Problema 7 con una sola diferencia que cambia todo: la cápsula *ya tenía*
  momento angular. Un impulso no reemplaza al $bold(H)$ que había: se le *suma
  como vector*. Es lo que pasa cada vez que un satélite que ya gira corrige su
  actitud con un pulso, y por qué una corrección mal sincronizada empeora el
  bamboleo en vez de arreglarlo.
]

#tipo("A")[Golpe y libre, pero con estado inicial. W4 tiene dos partes: $bold(H)$ antes y $Delta bold(H)$.]

#duda[¿El impulso del cohete no «pisa» al giro que tenía?]

#dedos[
  No: el momento angular se suma como las flechas. Si ya ibas girando y te
  dan un empujón de costado, terminás girando en una dirección intermedia,
  no en la del empujón.
]

#W(1)
Igual que el 7, más $bold(omega)_0 = 0,02 hat(j) + 0,10 hat(k)$ rad/s antes del
encendido; ahora se enciende $B$ (50 N en $+x$, 1 s).
// simbolos: omega_0

#W(2)
La misma terna del 7. De la figura, $B$ está *arriba*, en el borde de la tapa
angosta: $bold(r)_B = (0; 1,25; 2)$ m (radio y altura intercambiados respecto de
$A$).
// simbolos: r_B

#W(3)
Durante el segundo, el empuje; después, nada. Supuesto: en 1 s la cápsula
gira $0,10$ rad ($5,7$°) sobre su eje, y se toma el empuje como si no hubiera
girado; con más precisión habría que integrar el empuje que gira, como el
inciso de Aníbal del Problema 1.

#W(4)
$ bold(H)_0 = (0; I' omega_(0 y); I omega_(0 z)) = (0; 1000 dot.op 0,02; 1562,5 dot.op 0,10) = (0; 20; 156,25) " kg·m²/s" $
con $omega_(0 y)$ y $omega_(0 z)$ las componentes de $bold(omega)_0$.
// simbolos: H_0, omega_0y, omega_0z

#W(5)
$ Delta bold(H) = bold(r)_B times bold(J) = (0; 1,25; 2) times (50; 0; 0) = (0; 100; -62,5), quad quad bold(H)_G = bold(H)_0 + Delta bold(H) = (0; 120; 93,75) " kg·m²/s" $

#W(6)
$ bold(omega) = (0; 120\/1000; 93,75\/1562,5) = (0; 0,12; 0,06) " rad/s" $
$ tan theta = 120/(93,75) = 1,28 ==> theta = 52,0 degree, quad quad tan gamma = (0,12)/(0,06) = 2 ==> gamma = 63,4 degree $
$gamma > theta$: retrógrada, como tiene que ser (el cuerpo es el mismo). Por la
ley de los senos, con $omega = 0,134$ rad/s:
$ dot(phi) = 0,134 (sin 63,4 degree)/(sin 52,0 degree) = 0,152 " rad/s", quad quad abs(dot(psi)) = 0,134 (sin 11,4 degree)/(sin 52,0 degree) = 0,0338 " rad/s" $

#triangulo(52.0, 3.35, -0.74, retro: true)[El triángulo del Problema 8: el mismo cuerpo, otro $bold(H)_G$, más inclinado ($theta = 52$°); la retrógrada no cambia porque depende del cuerpo, no del golpe.]

#W(7)
$dot(phi) = H_G \/ I' = 152,3 \/ 1000 = 0,152$ rad/s y $dot(psi) = (I' - I)\/I
dot(phi) cos theta = -0,0338$ rad/s. Coinciden. Antes del encendido la cápsula
ya precesaba: $bold(H)_0$ estaba a $7,3$° del eje.

#W(8)
El eje de precesión pasó de estar a $7,3$° del eje de la cápsula a estar a
$52$°: el pulso *agrandó* el bamboleo. El sentido (retrógrado) no cambió,
porque es una propiedad del cuerpo. En unidades de Aníbal: $dot(phi) = 9,14$
rad/min, $abs(dot(psi)) = 2,03$ rad/min.

#final[$bold(H)_G = (0; 120; 93,75)$ kg·m²/s, a $52,0$° del eje; $bold(omega) = (0; 0,12; 0,06)$ rad/s, $gamma = 63,4$°, retrógrada; $dot(phi) = 0,152$ rad/s, $dot(psi) = -0,0338$ rad/s.]

#oral(
  ([¿Puede un impulso cambiar el sentido de la precesión?], [No: directa o retrógrada depende del signo de $I' - I$, que es del cuerpo.]),
  ([¿Cuándo el pulso *achicaría* el bamboleo?], [Si $Delta bold(H)$ empuja a $bold(H)_G$ hacia el eje de simetría; por eso los pulsos de corrección se sincronizan con la fase del giro (el _coning_ de los extras).]),
)

= Problema 9 — el satélite octogonal

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026, Cuerpo rígido, Problema 9. Es el Beer 18.125 (pág. 1198), que trae el dato que la guía no copió, $omega_0 = 36$ rev/h, y las respuestas al final del libro (pág. 1360).]
  #image("recortes/cr-9-1.pdf", width: 100%)
  #image("recortes/cr-9-2.pdf", width: 100%)
]

#gancho[
  Es el Problema 7 pedido *en letras*: primero todo en función de los
  parámetros, después con números. Es exactamente lo que pide un parcial con
  «escriba una expresión» (ANI-43): el planteo vale más que la cuenta. Y trae
  una trampa de signo —el gas sale para $+y$, así que la fuerza sobre el
  satélite va para $-y$— que ya se dio vuelta una vez en este apunte.
]

#tipo("A")[Golpe de dos propulsores y después libre, con estado inicial ($omega_0$ sobre el eje). Los ocho incisos son, casi uno por uno, los ocho pasos.]

#duda[Si los propulsores empujan paralelo al eje de simetría, ¿cómo lo pueden torcer?]

#dedos[
  Porque no empujan *en* el eje sino al costado de él, en el borde de la tapa:
  es como empujar para arriba el borde de una mesa redonda; sube, pero además
  se inclina. La parte que inclina es $bold(r) times bold(F)$.
]

#W(1)
$m = 2500$ kg, alto $2,4$ m, octógono de lado $1,2$ m; $I_y = 2400$ kg·m²
(axial, $y$ es el eje de simetría), $I_x = I_z = 2000$ kg·m²; gira a $omega_0$
sobre $y$; $A$ y $B$ expulsan gas hacia $+y$ con $J = 20$ N durante $T = 2$ s.
(Ojo: en este problema $J$ es un *empuje*, en N, y $T$ un tiempo.)
// simbolos: omega_0, J, T, x_A, y_A, z_A, x_B, y_B, z_B, R_A, R_B

#W(2)
Origen en $G$, ejes principales de la figura. $bold(R)_A = (x_A; y_A; z_A)$ y
$bold(R)_B = (x_B; y_B; z_B)$, en dos vértices de la tapa de arriba.

#W(3)
El gas sale hacia $+y$: *al satélite lo empuja $bold(F) = -J hat(j)$*. Después,
libre. *(Inciso 1)* El tipo de precesión ya se sabe: $I_y = 2400 > I_x = 2000$,
achatado, *retrógrada*.

#W(4)
Antes: $bold(H)_0 = I_y omega_0 hat(j)$. Cada propulsor, en su posición $bold(R)$, deja $bold(R) times
// simbolos: R
bold(F) T = (y dot.op 0 - z (-J); z dot.op 0 - x dot.op 0; x (-J) - y dot.op 0) T = J T (z;
0; -x)$: la coordenada $y$ no aparece (la fuerza es paralela al eje).

#W(5)
*(Inciso 2)*
$ bold(H) = (J T (z_A + z_B); I_y omega_0; -J T (x_A + x_B)) $
*(Inciso 3)* $bold(omega) = (H_x \/ I_x; omega_0; H_z \/ I_x)$.

#W(6)
*(Incisos 4 y 5)*, medidos desde el eje $y$:
$ cos theta = (I_y omega_0)/abs(bold(H)), quad quad cos gamma = omega_0/abs(bold(omega)) $
*Con números (inciso 8).* El dato que falta, del Beer: $omega_0 = 36$ rev/h $=
0,0628$ rad/s. De la figura del Beer, la cara entre $A$ y $B$ mira hacia $+z$:
$x_A = -0,6$, $x_B = 0,6$ y $z_A = z_B = 1,449$ m (la apotema del octógono de
lado $1,2$ m). Entonces $x_A + x_B = 0$, $z_A + z_B = 2,897$ m y
// simbolos: omega
$ bold(H) = (20 dot.op 2 dot.op 2,897; 150,8; 0) = (115,9; 150,8; 0) " kg·m²/s", quad abs(bold(H)) = 190,2 " kg·m²/s" $
$ bold(omega) = (0,0579; 0,0628; 0) " rad/s", quad theta = 37,5 degree, quad gamma = 42,7 degree $
$gamma > theta$: retrógrada, como se anunció. $dot(phi) = abs(bold(H)) \/ I_x =
0,0951$ rad/s ($54,5$ rev/h) y $dot(psi) = (I_x - I_y)\/I_y dot(phi) cos theta =
-0,0126$ rad/s ($-7,2$ rev/h).

#triangulo(37.5, 3.33, -0.44, retro: true)[*(Inciso 6)* $bold(H)$, $bold(omega)$, la precesión y el spin del octógono, en el plano $x y$: $bold(H)$ queda entre el eje y $bold(omega)$.]

#W(7)
Con los radios de giro del Beer ($k_x = 0,90$ y $k_y = 0,98$ m, o sea $I_x = 2025$ e
$I_y = 2401$ kg·m²) la misma cuenta da las respuestas del libro (sus $theta_x$ y $theta_y$ son los ángulos de $bold(H)$ con los ejes): $theta_y =
// simbolos: theta_x, theta_y
37,5$°, $theta_x = 52,5$°, precesión $53,8$ rev/h y spin $6,68$ rev/h. Y con $A$
y D encendidos, las del 18.126.

#W(8)
*(Inciso 7)* Visto desde afuera: $bold(H)$ queda fijo, inclinado $37,5$° hacia
$+x$ respecto de donde estaba el eje; el eje de simetría y $bold(omega)$ giran
alrededor de $bold(H)$ una vez cada 66 s, mientras el satélite gira sobre sí
mismo para el otro lado; el cono espacial queda adentro del corporal.

#trampa[
  Tomar $bold(F) = +J hat(j)$ porque «los propulsores expelen en $+y$» da vuelta
  $bold(H)_x$ y el satélite se inclina para el otro lado. El gas sale para un
  lado y el satélite es empujado para el otro: acción y reacción, antes que
  cuerpo rígido.
]

#final[$bold(H) = (J T (z_A + z_B); I_y omega_0; -J T (x_A + x_B))$; con números, $(115,9; 150,8; 0)$ kg·m²/s; $theta = 37,5$°, $gamma = 42,7$°, retrógrada; $dot(phi) = 0,0951$ rad/s ($54,5$ rev/h), $dot(psi) = -0,0126$ rad/s.]

#oral(
  ([¿Por qué no aparece $y_A$?], [Porque la fuerza es paralela a $y$: $bold(r) times bold(F)$ no ve la componente de $bold(r)$ a lo largo de $bold(F)$.]),
  ([¿Qué cambia si se encienden A y D?], [A y D están en caras distintas: la suma de sus $x$ y de sus $z$ cambia, y $bold(H)$ se inclina en otra dirección (Beer 18.126).]),
)

= Adicional 1 — los brazos telescópicos

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026 (versión 5), Ejercicios adicionales de cuerpo rígido, 1. Curtis cap. 12; en el apunte, módulo de actitud.]
  #image("recortes/cr-ad1-1.pdf", width: 82%)
]

#gancho[
  Es la patinadora que abre los brazos, al revés: si los brazos se estiran y
  uno *no* quiere que la nave se frene, hay que empujarla. El problema mide
  cuánto. Sirve para cualquier cosa que despliega masa girando: paneles,
  antenas, el yo-yo que frena satélites recién separados.
]

#tipo("B y E")[Se conoce el movimiento ($omega_0$ constante, $r(t)$ dado) y se busca la cupla; además, hay partes que se mueven respecto del cuerpo. Pesan W4 y W5.]

#duda[Si la velocidad angular no cambia, ¿para qué hace falta empujar?]

#dedos[
  Porque el momento angular sí cambia: es $I omega_0$, y al estirar los brazos
  $I$ crece. Sin empuje, $I omega$ se conservaría y $omega$ bajaría, como la
  patinadora que abre los brazos y se frena.
]

#W(1)
$omega_0 = 1,25$ rad/s constante; dos módulos de $m = 10$ kg que van de $r_1 =
1,2$ m a $r_2 = 4,5$ m a velocidad constante en $120$ s; dos propulsores a $1,1$
m del eje, con empujes $T$ opuestos (un par). Se pide $T(t)$.
// simbolos: r_1, r_2, rdot, I_0

#W(2)
Eje $z$ de giro, origen en $G$. Terna que gira con la nave.

#W(3)
Actúa el par de los propulsores, $M_z = 2 (1,1) T$. Los brazos no tienen masa;
los módulos son partículas. No se conserva $H_z$: justamente hay que aportarlo.

#W(4)
$ H_z = (I_0 + 2 m r^2) omega_0 $
con $I_0$ la nave sin los módulos; $dot(r) = (4,5 - 1,2) \/ 120 = 0,0275$ m/s.

#W(5)
$ M_z = (dif H_z)/(dif t) = 4 m r dot(r) omega_0 quad ==> quad 2 (1,1) T = 4 (10) r (0,0275)(1,25) quad ==> quad T = 0,625 thin r " N" $

#W(6)
Con $r(t) = 1,2 + 0,0275 thin t$:
$ T(t) = 0,75 + 0,0172 thin t " N" $
de $0,75$ N al empezar a $2,81$ N al terminar. No hay conos: el giro es sobre un
eje principal fijo.

#W(7)
*Por Coriolis*: en la terna que gira, cada módulo que se aleja a $dot(r)$
necesita una fuerza de costado $2 m dot(r) omega_0$ para no quedarse atrás; con
brazo $r$ y dos módulos, la cupla es $4 m r dot(r) omega_0$. Lo mismo. Y el
$I_0$ de la nave no hace falta: es constante y no aporta a la derivada.

#W(8)
El empuje crece linealmente porque el brazo de la fuerza de Coriolis crece.
Si los propulsores fallan, $H_z$ se conserva y la nave se frena: con los
brazos estirados, $omega$ baja en la proporción $(I_0 + 2 m r_1^2) \/ (I_0 + 2 m
r_2^2)$.

#final[$T(t) = 0,75 + 0,0172 thin t$ N (de $0,75$ a $2,81$ N); $I_0$ no hace falta.]

#oral(
  ([¿Depende de la inercia de la nave?], [No: $I_0$ es constante y su derivada es cero.]),
  ([¿Y si los brazos se retraen?], [$dot(r) < 0$: el empuje cambia de signo; hay que frenar la nave para que no se acelere.]),
)

= Adicional 2 — la rueda de reacción

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía 2026 (versión 5), Ejercicios adicionales de cuerpo rígido, 2. Es el ejemplo 12.10 del Curtis con otras letras.]
  #image("recortes/cr-ad2-1.pdf", width: 80%)
]

#nota[La figura rotula $I_w$ al momento de inercia de la rueda; el texto le dice $I_R$. Es la misma cantidad.]
// simbolos: I_R, I_w

#gancho[
  Es el actuador de actitud más usado: una rueda adentro del satélite que,
  al acelerarla, hace girar al satélite al revés. Como el par es *interno*, el
  momento angular total no cambia: la rueda se lleva lo que el satélite pierde.
  Lo simple: una conservación. Lo complicado: no mezclar la velocidad de la
  rueda respecto de la nave con la absoluta.
]

#tipo("E")[Dos partes que se mueven entre sí, con un par interno. Pesan W3 (qué se conserva) y W4 (cada parte por separado).]

#duda[Si el motor está adentro de la nave, ¿cómo puede hacerla girar?]

#dedos[
  Igual que vos sentado en una silla giratoria con una rueda de bicicleta: la
  hacés girar para un lado y la silla gira para el otro. El motor empuja a la
  rueda y la rueda empuja al motor, que está atornillado a la nave.
]

#W(1)
$I$: toda la nave, rueda incluida; $I_R$: la rueda sola; par del motor $M$
constante durante un tiempo $T$; todo parte del reposo. Se pide $omega_"nave"$ y
$omega_"rel"$, la de la rueda respecto de la nave.
// simbolos: omega_nave, omega_rel

#W(2)
Eje $z$ común; terna inercial. La velocidad absoluta de la rueda es
$omega_"nave" + omega_"rel"$.

#W(3)
El par es interno: *el $H_z$ total se conserva y vale cero*. Para cada parte,
el par del motor sí es externo.

#W(4)
Nave sin la rueda: momento $I - I_R$. Rueda: $I_R$.

#W(5)
Impulso angular sobre cada parte (la integral de la cupla del motor, que es lo que le cambia el momento angular a cada una):
$ I_R (omega_"nave" + omega_"rel") = M T, quad quad (I - I_R) omega_"nave" = - M T $

#W(6)
$ omega_"nave" = - (M T)/(I - I_R), quad quad omega_"rel" = (M T)/I_R + (M T)/(I - I_R) = (I M T)/(I_R (I - I_R)) $
La nave gira al revés que la rueda. Con números nuestros (no del enunciado):
un microsatélite con $I = 20$ kg·m², una rueda de $I_R = 0,002$ kg·m² y $M T =
0,1$ N·m·s da $omega_"nave" = -0,00500$ rad/s y $omega_"rel" = 50,0$ rad/s.

#W(7)
El total: $(I - I_R) omega_"nave" + I_R (omega_"nave" + omega_"rel") = I
omega_"nave" + I_R omega_"rel" = 0$. Y coincide con el ejemplo 12.10 del Curtis
(pág. 676).

#W(8)
Para girar el satélite hay que acelerar la rueda; para frenarlo, frenarla.
Si una perturbación externa empuja siempre para el mismo lado, la rueda
termina en su velocidad máxima (*saturación*) y hay que descargarla con una
cupla externa: propulsores o magnetotorquers.

#final[$omega_"nave" = -M T \/ (I - I_R)$, al revés que la rueda; $omega_"rel" = I M T \/ (I_R (I - I_R))$; el $H_z$ total queda en cero.]

#oral(
  ([¿Puede una rueda de reacción cambiar el momento angular total del satélite?], [No: el par es interno. Sólo lo reparte; para cambiar el total hace falta una cupla externa.]),
  ([¿Por qué la rueda gira tan rápido?], [Porque $I_R$ es chico: para llevarse el mismo $H$ que la nave, necesita una $omega$ mucho mayor.]),
)

#pagebreak()
#caja([Extras: lo que vimos y no está en la guía], c-viole)[
  Los ejercicios que siguen no están en la sección de cuerpo rígido de la guía,
  pero Aníbal los mostró, los pidió o subió material para ellos: el Problema
  Resuelto 18.6 del Beer (su «problema modelo»), el 18.127 con su cuaderno de
  Python, la Tierra en el 18.117 y el 18.123 («analizar las diferencias»), el
  satélite geoestacionario que apunta a la Tierra, la reorientación por
  _coning_ y el CMG con números. Se resuelven con el mismo workflow.
]

#include "resueltos-cr-extras.typ"

= La tarjeta del workflow

Lo que hay que tener en la cabeza al abrir un problema de cuerpo rígido, en
el orden en que se usa:

+ *¿Qué clase es?* A golpe y libre · B movimiento dado, cupla buscada · C
  libre, estado dado · D cupla dada, movimiento buscado · E partes que se
  mueven.
+ *Datos con unidades, y la incógnita exacta* (¿«spin» es $dot(psi)$ o
  $omega_z$?).
+ *Origen en $G$, ejes principales, y la terna dicha*: ¿a qué está clavada y con
  qué $bold(Omega)$ gira?
+ *Qué actúa y qué se conserva*; cada supuesto con su número.
+ *$bold(H)$ antes, y $bold(H)$ componente a componente* con *su* momento.
+ *La ecuación*: $Delta bold(H) = bold(r) times bold(J)$, o $sum bold(M) =
  (dot(bold(H)))_"terna" + bold(Omega) times bold(H)$.
+ *$theta$ (de $bold(H)$) y $gamma$ (de $bold(omega)$)*: $gamma > theta$
  retrógrada (achatado), $gamma < theta$ directa (alargado); el triángulo y la
  ley de los senos.
+ *Verificar* ($dot(phi) = H \/ I'$) *y concluir en palabras*: qué ve el de
  afuera, y qué pasaría si cambia un dato.

#{
  set par(justify: false)
  table(
    columns: (auto, auto, 2.4fr, 1.6fr),
    inset: (x: 5pt, y: 4pt),
    table.header(..([Problema], [Clase], [La idea en una línea], [El número]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([1], [A], [Isótropo: $bold(omega) parallel bold(H)$, no precesa], [$0,283$ rad/s]),
      ([2], [B], [Rapideces constantes, $bold(H)$ que gira: hace falta cupla], [$1/2 m r^2 omega_1 omega_2$]),
      ([3], [D], [La cupla se reparte: 500 en girar $bold(H)$, 100 en acelerar], [$20$ rad/s²]),
      ([4], [C], [Achatado: retrógrada, el spin para atrás], [$T = 1,832$ s]),
      ([5], [C], [$I = 2 I'$: precesa al doble del spin], [$6$ rev/min]),
      ([6], [C], [La forma decide el sentido], [$ell \/ r = sqrt(6)$]),
      ([7], [A], [El modelo: $theta$, $gamma$, triángulo], [$0,118$ y $0,0360$ rad/s]),
      ([8], [A], [El impulso se suma al $bold(H)$ que había], [$theta = 52,0$°]),
      ([9], [A], [Todo en letras, después con números], [$54,5$ rev/h]),
      ([Ad. 1], [B, E], [$I$ crece: hay que empujar para mantener $omega$], [$0,75 + 0,0172 thin t$ N]),
      ([Ad. 2], [E], [El par interno no cambia el total], [$-M T \/ (I - I_R)$]),
    ).flatten().map(c => text(size: 8.5pt, c)),
  )
}
