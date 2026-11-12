// =====================================================================
//  Guía para el parcialito de CMG -- 2026-11-10
//  Para el jueves 12/11: parcialito previo y una hora de CMG que dan los
//  alumnos (aviso de Aníbal, catedras ANI-R15). La forma de las preguntas
//  sale del parcialito del 29/10 (ANI-R14: escribir las velocidades
//  angulares del giróscopo y proyectar vectores) y de los criterios de
//  catedras/fisica-espacial/CRITERIOS.md; el contenido, del módulo `actitud`
//  del apunte (sección «El CMG por dentro») y de los tres papers que pasó
//  la cátedra: Chubb y Seltzer 1971 (Skylab), Lappas, Steyn y Underwood
//  2002 y Wrigley y Hollister 1965.
//  Cada número, en validar.py; cada pregunta, en una página
//  (verificar-consignas.py); cada letra, presentada donde aparece primero
//  (verificar-simbolos.py).
// =====================================================================
#import "estilo.typ": *
#import "../apunte/biblioteca/figuras.typ": fig-act-cmg-giros, fig-act-cmg-proyeccion, fig-act-cmg-singular, fig-act-actuadores
#import "../apunte/biblioteca/figuras-cmg.typ": fig-cmg-3d, fig-cmg-analogia, fig-cmg-silla, fig-cmg-piramide

#show: documento.with(
  titulo: [Guía para el parcialito — CMG],
  subtitulo: [El giróscopo de control de momento: las velocidades, los vectores, el Skylab y lo que va a preguntar Aníbal],
  encabezado: [Guía para el parcialito — CMG],
)

#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)
// El título y su origen no se quedan solos al pie: pegados a lo que sigue.
#let origen(cuerpo) = block(above: 2pt, below: 6pt, sticky: true, text(size: 9pt, fill: luma(90), style: "italic", cuerpo))
#let manos(cuerpo) = caja([Con las manos], c-ambar, cuerpo)
#let tabla(cols, ..celdas) = {
  set par(justify: false)
  align(center, table(columns: cols, inset: (x: 6pt, y: 3.5pt), align: left,
    ..celdas.pos().map(c => text(size: 9.5pt, c))))
}
#let pregunta(n, q, r) = consigna[
  #block(above: 10pt, below: 6pt, sticky: true, text(fill: c-azul, weight: "bold")[#(n). #q])
  #r
]

#caja([Cómo usar esto], c-azul)[
  *Qué pasa el jueves 12/11.* Aníbal lo avisó por escrito: «dedicaremos una
  hora a CMG a cargo exclusivamente de ustedes (con parcialito previo)». O sea,
  dos cosas el mismo día: un parcialito corto y después una hora de clase que
  dan los alumnos —la manera elegante de Aníbal de decir que esto ya lo
  tendríamos que saber explicar solos—. Esta guía sirve para las dos: las
  secciones 1 a 7 son el tema entero, la 8 es el parcialito 5 contestado y
  pasado a un CMG, la 9 son las preguntas que pueden caer con su respuesta, y
  la 10 es un guion para la hora de clase.

  *Cómo está contado cada tema.* Primero, en rosa, *para qué sirve*: qué te
  da, qué consecuencias tiene en un satélite de verdad, dónde está lo simple y
  dónde lo complicado. Después, en violeta, *la duda* que seguramente te vas a
  hacer, y en verde la respuesta *con los dedos*, sin cuentas. Recién ahí la
  cuenta. Y al pie de las páginas, en un globito, qué es cada letra y respecto
  de qué se mide, para no tener que volver atrás a buscarla.

  *Qué esperar del parcialito.* El último (29/10, cuerpo rígido) tuvo seis
  preguntas sobre el giróscopo en cardanes del Beer: definir los tres ángulos
  *«solamente de palabras»*, definir en palabras el sistema fijo al cuerpo,
  escribir la velocidad angular, nombrar cada giro, decir si la base es
  ortonormal y pasarla a una que lo sea. Ni un número, y cerraba con *«Sea
  prolijo»* y *«No entregue figuras»*. Ojo con eso último: en los parcialitos
  anteriores el dibujo era la respuesta, y en éste estaba prohibido. Con un
  CMG, esas mismas seis preguntas son la sección 8 de acá.

  *El material.* El paper nuevo es el del Skylab (Chubb y Seltzer, _Skylab
  Attitude and Pointing Control System_, NASA TN D-6068, 1971). Los otros dos,
  Lappas, Steyn y Underwood (2002) y Wrigley y Hollister (1965), son los
  mismos que la cátedra pasó el 28/09: ya estaban en el apunte, módulo 17. El
  desarrollo completo de todo esto está en el apunte, módulo 22, sección
  «El CMG por dentro»; acá va lo que hay que tener en la cabeza al entrar.
]

= 0. Lo que quiere Aníbal, y cómo lo contamos nosotros
#origen[Cada fila de la izquierda es un criterio de Aníbal (el id es el de la carpeta de criterios de la cátedra); la de la derecha, cómo lo resuelve esta guía. Lo de la derecha es la casa: criollo, con las manos, ninguna letra en el aire.]

// simbolos: H, Omega
#tabla((1fr, 1.25fr),
  [*Lo que pide Aníbal*], [*Cómo va acá*],
  [Concepto antes que deducción; «no se compliquen» (ANI-02)], [cada tema arranca con la idea en palabras; la cuenta viene después, y es corta],
  [El dibujo es la respuesta (ANI-31)… salvo cuando dice «No entregue figuras» (parcialito 5, ANI-77)], [las figuras están para pensar; la sección 8 practica la respuesta escrita, sin dibujo],
  [«Valiéndose solamente de palabras» (ANI-76)], [cada ángulo y cada sistema de referencia, definido en palabras, con las piezas por su nombre],
  [La regla de la mano derecha, «muy importante» (ANI-26)], [tres dedos para cada producto vectorial, en una caja ámbar],
  [La analogía giróscopo–órbita (ANI-20)], [es la idea del CMG: la cupla perpendicular al momento angular $bold(H)$ le cambia la dirección y no el módulo],
  [«No siempre $bold(Omega) = bold(omega)$»: la velocidad angular de los ejes no es la del cuerpo (ANI-61)], [la terna va pegada al cardán, que no sigue el spin],
  [Escribir velocidades angulares y proyectar (ANI-71)], [sección 2 y sección 4, con números],
  [Los libros y el material de la cátedra (ANI-14)], [Beer §18.9 para las velocidades, Curtis §12.9 para los actuadores, y los tres papers],
  [Las denominaciones importan (ANI-08)], [cupla = torque = par; $bold(H)$ es el momento angular, que la guía llama «impulso angular»],
  [Toda suposición, dicha (ANI-53)], [cada aproximación con su número: por qué el momento angular del rotor se toma sobre su eje],
  [Predicción sin datos de más (ANI-34)], [cuántas órbitas tarda en saturarse el Skylab, con una división],
)

#notacion[
  *Las letras de toda la guía, antes de la primera fórmula.* Cada sección
  presenta además las suyas donde aparecen.
  // simbolos: omega, M, I
  - $bold(omega)$ es una velocidad angular: el eje alrededor del cual gira
    algo y cuántos radianes por segundo. $bold(H)$ es un momento angular,
    $bold(M)$ una cupla (torque, par) e $I$ un momento de inercia, como en
    todo el capítulo 18 del Beer.
  // simbolos: ghat, shat, that
  - La terna del CMG, pegada al cardán: $hat(g)$ sobre el eje del cardán (el
    que gira el motor), $hat(s)$ sobre el eje del rotor (el de _spin_) y
    $hat(t) = hat(g) times hat(s)$, el tercero, por donde sale la cupla.
  // simbolos: delta, deltadot, Omega_s, h
  - $delta$ es el ángulo del cardán y $dot(delta)$ su velocidad, la que le
    da el motor. $Omega_s$ es la velocidad del rotor *respecto del cardán*,
    constante. $h$ es el módulo del momento angular del rotor.
]

*Cada vector, con su documento.* La mitad de los errores de este tema no son
de cuenta: son de no saber *de qué pieza* es un vector, *respecto de qué* se
mide y *en qué ejes* está escrito. Cuatro preguntas, siempre las mismas; la
tabla las contesta para todos los vectores de la guía, y al pie de las
páginas, en un globito, te las vuelvo a recordar donde hagan falta.

// simbolos: omega_b, Omega_g, omega_r, H_r, tau_sat
#tabla((0.75fr, 1.45fr, 1.5fr, 1.45fr),
  [*Vector*], [*Qué es, y de qué pieza*], [*Respecto de qué*], [*En qué ejes lo escribimos*],
  [$bold(omega)_b$], [la velocidad angular del satélite], [del espacio: es absoluta], [los del satélite, $hat(i)$, $hat(j)$, $hat(k)$],
  [$dot(delta) hat(g)$], [el giro del cardán], [*del satélite*: es lo que ve alguien sentado en el satélite], [sobre $hat(g)$, que está clavado al satélite],
  [$Omega_s hat(s)$], [el spin del rotor], [*del cardán*: lo que ve alguien sentado en el cardán], [sobre $hat(s)$, clavado al cardán],
  [$bold(Omega)_g$], [la velocidad angular del cardán, y por eso la de la terna $hat(s)$, $hat(t)$, $hat(g)$], [del espacio: $bold(omega)_b + dot(delta) hat(g)$], [la que convenga; es la $bold(Omega)$ del teorema del transporte],
  [$bold(omega)_r$], [la velocidad angular del rotor], [del espacio: las tres de arriba, sumadas], [cualquiera: el vector es uno solo],
  [$bold(H)_r$], [el momento angular del rotor], [de su centro, que es su centro de masa], [los del cardán: $approx h hat(s)$],
  [$bold(tau)_"sat"$], [la cupla que *recibe* el satélite del CMG], [de su centro de masa], [los del satélite, cuando se proyecta],
)

#duda[Cuando escribo la derivada de un vector «en los ejes del cardán», ¿la estoy midiendo desde el cardán?]
#dedos[No, y es la confusión número uno del tema. Son dos preguntas distintas:
*quién mira* el vector para decir cuánto cambió, y *con qué regla lo anota*
una vez que tiene el cambio. Un auto que dobla: el cambio de su velocidad lo
ve alguien parado en la vereda —eso es «respecto del espacio»—, y ese mismo
cambio lo podés anotar como «tanto hacia la izquierda del auto y tanto hacia
adelante» —eso es «escrito en los ejes del auto»—. Mirar desde la vereda y
anotar con los ejes del auto no se contradicen. En el CMG, la segunda ley de
Newton pide el cambio visto *desde el espacio*, siempre; lo escribimos en los
ejes del cardán o del satélite porque ahí los números salen lindos.]

*Las dudas que despierta el tema, en orden.* Cada una vuelve a aparecer, en
violeta, justo antes de la explicación que la contesta; primero va la
explicación con los dedos y después la cuenta.

+ Si el rotor gira siempre igual, ¿de dónde sale la cupla? (sección 1)
+ ¿Por qué las velocidades angulares se suman y los giros grandes no? (2)
+ Si el momento angular es «momento de inercia por velocidad angular», ¿por
  qué el del rotor apunta sólo sobre su eje? (3)
+ La derivada del momento angular, ¿la veo desde el cardán o desde el
  espacio? ¿De dónde sale el producto vectorial? (3)
+ ¿Por qué en el transporte va la velocidad angular del cardán y no la del
  rotor? (3)
+ ¿Quién le hace la cupla a quién, y por qué el menos? (3)
+ Si el vector es el mismo, ¿para qué se proyecta? (4)
+ Si sale mil veces más cupla de la que entra, ¿no se viola la energía? (5)
+ Si dos CMG antiparalelos suman cero, ¿por qué también se traban? (6)
+ ¿Por qué un CMG saturado no se descarga solo? (6)
+ Si los tres versores del parcialito miden uno, ¿por qué la base no es
  ortonormal? (8)

= 1. Qué es un CMG, en una frase y en las manos
#origen[Apunte, módulo 22, «El CMG por dentro» y la tabla de los tres actuadores; módulo 20, el volante en el gimbal; Curtis §12.9.]

#gancho[Un satélite que tiene que apuntar —un telescopio al Sol, una cámara a
una ciudad, una antena a la Tierra— necesita girar sobre sí mismo, y en el
espacio no hay contra qué apoyarse. Tiene tres maneras: tirar gas, que se
acaba y ensucia lo que tenga cerca; acelerar una rueda, que da poca cupla; o
*torcer* un rotor que ya gira, que es el CMG. El CMG es el que da mucha cupla
con poco motor, y por eso lo eligieron el Skylab, que tenía que tener su
telescopio clavado en el Sol, y el microsatélite de Surrey, que tenía que
girar rápido. Entenderlo te da cuatro cosas: cuánta cupla sale, para qué
lado, cuánto aguanta antes de llenarse y dónde se traba. Lo simple es la
cuenta, una sola multiplicación. Lo complicado es que la cupla cambia de
dirección mientras la usás, y que con varios CMG hay posiciones en las que,
aunque te quede capacidad, no podés empujar para el lado que querés.]

#duda[Si el rotor gira siempre a la misma velocidad, ¿de dónde sale la cupla? ¿No hay que frenarlo o acelerarlo para que cambie su momento angular?]
#dedos[El momento angular es una *flecha*, y una flecha cambia de dos maneras:
estirándose o girando. Una rueda de reacción la estira —acelera el rotor—;
un CMG la gira —le tuerce el eje al rotor—. Las dos cosas son un cambio, y
todo cambio de momento angular cuesta una cupla. Agarrá un lápiz por atrás y
giralo en el aire sin cambiarle el largo: la goma de la punta recorrió un
arquito. Ese arquito es el cambio de momento angular de un CMG, y la cupla
que hizo falta para provocarlo es la que el satélite recibe al revés.]

*La idea.* Un CMG es un rotor que gira *siempre igual*, rapidísimo, montado
en un cardán que un motor hace girar. El rotor no se frena nunca: lo único
que cambia es *hacia dónde* apunta su momento angular. Y como el motor está
adentro del satélite, el momento angular del satélite más el del rotor no
cambia: lo que el rotor tuerce para un lado, el satélite lo tuerce para el
otro. Es la analogía de Aníbal: una fuerza perpendicular a la velocidad le
cambia la dirección y no el módulo; una cupla perpendicular a $bold(H)$,
igual.

// simbolos: v, Delta
#figure(fig-cmg-analogia, caption: [La analogía, dibujada. A la izquierda, la
velocidad $bold(v)$ de un satélite en órbita: la fuerza central la empuja de
costado y el cambio $Delta bold(v)$ sale perpendicular, así que gira sin
crecer. A la derecha, el momento angular del rotor de un CMG, $bold(H)_r$:
la cupla del cardán también es perpendicular, y $Delta bold(H)_r$ lo gira
sin cambiarle el tamaño. El rotor nunca se frena, igual que el satélite
nunca acelera.])

#figure(fig-cmg-3d, caption: [Un CMG por dentro, con todos sus vectores.
Sobre el satélite (la placa), un motor gira el cardán —el anillo verde—
alrededor de $hat(g)$ con $dot(delta)$. Adentro, el rotor gira con $Omega_s$
sobre su eje $hat(s)$ y lleva el momento angular $bold(H)_r = h hat(s)$, que
forma el ángulo $delta$ con el eje $hat(i)$ del satélite. Al girar el
cardán, la punta de $bold(H)_r$ se mueve sobre $hat(t) = hat(g) times
hat(s)$ (flecha azul), y el satélite recibe la cupla al revés, $-h
dot(delta) hat(t)$ (flecha roja). Cuando veas uno, buscá esas tres flechas:
el eje del cardán, el del rotor y la cupla, perpendicular a los dos.])

#figure(fig-act-actuadores, caption: [Propulsor, rueda de reacción y CMG. El
propulsor cambia el $bold(H)$ total; la rueda lo reparte cambiando su
velocidad; el CMG lo reparte cambiando la *dirección* de un $bold(H)$ grande.
Del apunte, módulo 22.])

#manos[
  La silla giratoria y la rueda de bicicleta. Con la rueda quieta, si la
  girás en el aire, la silla apenas se entera. Con la rueda girando rápido,
  *torcele el eje* —de horizontal a inclinado— y la silla arranca a girar,
  fuerte, aunque tus manos hicieron poquito. La rueda sigue girando igual
  que antes. Eso es un CMG: la silla es el satélite, tus manos el motor del
  cardán, la rueda el rotor. (Fran, que en la primera clase de giróscopos lo
  describió como algo que *levitaba*, puede dar fe de que esta vez la que se
  mueve es la silla.)
]

#figure(fig-cmg-silla, caption: [La silla y la rueda, con vectores. La rueda
gira con su momento angular horizontal (punteado, «antes»); quien está
sentado le inclina el eje y el momento angular de la rueda gana un $Delta
bold(H)$ hacia arriba. Nadie de afuera tocó nada, así que la silla se lleva
$-Delta bold(H)$: gira, vista de arriba, en sentido horario. Es la niña con
la rueda de la cátedra, jugada al revés: ella sentía la cupla en las manos;
acá la cupla hace girar la silla.])

#trampa[
  *Amplificación no es magia.* El CMG da mucha más cupla que la que pone el
  motor del cardán, pero no crea momento angular: lo saca de *girar la
  dirección* de uno enorme que ya estaba ahí. El total, satélite más rotor,
  sigue igual.
]

= 2. Las tres velocidades angulares
#origen[Beer §18.9 (el giróscopo en cardanes: cada articulación suma su giro relativo), la hoja 2 del resumen manuscrito de Aníbal y el parcialito del 29/10, que pidió escribir esto mismo.]

#gancho[Todo lo que viene —el momento angular del rotor, la cupla, la
proyección— se arma con tres flechas: cómo gira el satélite, cómo gira el
cardán y cómo gira el rotor. Si una sale mal (la del rotor sin la del
satélite, por ejemplo), la cupla sale mal y ninguna cuenta lo avisa. Lo
simple: se suman. Lo sutil: cada una se mide respecto de una pieza distinta,
y en el examen eso es lo que se corrige.]

#duda[¿Por qué las velocidades angulares se suman, si los giros no se pueden sumar como vectores?]
#dedos[Por lo mismo que en la cinta del aeropuerto: si la cinta te lleva a
1 m/s y vos caminás a 1 m/s sobre ella, vas a 2 m/s respecto del piso. Cada
pieza «camina» sobre la que la sostiene: el cardán gira sobre el satélite, el
rotor sobre el cardán. Lo que no se suma son los giros *grandes*: girá un
libro 90° de costado y después 90° de frente, repetilo en el orden inverso, y
queda distinto (apunte, módulo 18). Una velocidad angular es un giro
chiquito, de un instante, y los giros chiquitos sí conmutan.]

Hay tres cuerpos: el satélite, el cardán y el rotor. *Cada articulación suma
su giro relativo al de la pieza que la sostiene*:

- el satélite gira con $bold(omega)_b$ respecto del espacio;
- el cardán, con $bold(Omega)_g = bold(omega)_b + dot(delta) hat(g)$;
- el rotor, con $bold(omega)_r = bold(omega)_b + dot(delta) hat(g) + Omega_s hat(s)$.

#figure(fig-act-cmg-giros, caption: [Las tres piezas y sus giros relativos.
Del apunte, módulo 22.])

*¿Qué ejes?* Los del cardán, $(hat(s), hat(t), hat(g))$, que giran con
$bold(Omega)_g$#burbuja[$bold(Omega)_g$: la velocidad angular del cardán
respecto del espacio, $bold(omega)_b + dot(delta) hat(g)$. Es también la de
la terna $hat(s)$, $hat(t)$, $hat(g)$, porque va pegada al cardán.] y *no* con $bold(omega)_r$: siguen al cardán y no al spin.
Es el «no siempre $bold(Omega) = bold(omega)$» que Aníbal subrayó, y el mismo
truco del balancín interior del Beer: ejes principales del rotor que no dan
vueltas con él.

*Con números.* El CMG del paper de Lappas: rotor a $20 thin 000$ rpm,
$Omega_s = 2094$ rad/s; el cardán sobre $hat(g) = hat(k)$ del satélite, a
$delta = 30degree$ y girando a $dot(delta) = 0,12$ rad/s; y el satélite
maniobrando con $bold(omega)_b = 0,05 hat(i)$ rad/s. Como $hat(s) = cos delta
thin hat(i) + sin delta thin hat(j)$, en los ejes del satélite:
$ bold(omega)_r = (0,05 + 2094 dot.op 0,866) hat(i) + 2094 dot.op 0,5 hat(j) + 0,12 hat(k)
  approx 1813,8 hat(i) + 1047,2 hat(j) + 0,12 hat(k) " rad/s" $
El spin le gana a todo por cuatro órdenes de magnitud. Eso no es un detalle:
es lo que hace que el momento angular del rotor apunte, prácticamente, sobre
$hat(s)$.

#trampa[
  *¿Depende del sistema de coordenadas?* El vector $bold(omega)_r$ no: es el
  mismo giro, se lo mire de donde se lo mire (respecto del espacio). Sus
  *componentes* sí: en los ejes del cardán son $(Omega_s + bold(omega)_b dot.op
  hat(s); bold(omega)_b dot.op hat(t); dot(delta) + bold(omega)_b dot.op
  hat(g))$, y en los del satélite, las de arriba. Es la pregunta del
  parcialito 4 («diga si depende del sistema de coordenadas elegido») con
  otro cuerpo.
]

= 3. El momento angular del rotor, y de dónde sale la cupla
#origen[Apunte, módulo 22; el teorema del transporte del módulo 18 (la «relación fundamental» del Beer, §15.10); Lappas 2002, ec. 1, pág. 104.]

#gancho[Ésta es la sección que te dice qué pasa *adentro* del aparato. El
rotor no se puede torcer solo: lo tuercen los cojinetes del cardán, y lo que
ellos empujan es la cupla de salida entera —mil y pico de veces lo que hace
el motor, como se ve en la sección 5—. Eso dimensiona la estructura: los
cojinetes y el soporte se diseñan para esa cupla, no para la del motor. Y la
cuenta muestra un segundo término que sólo existe si el satélite ya está
girando: cae sobre el eje del cardán, el motor lo tiene que vencer, y es la
manera en que el satélite y el CMG se empujan entre sí. Lo simple: con el
satélite quieto, todo es una multiplicación. Lo complicado: con el satélite
girando, ya no.]

#duda[¿No era $bold(H) = I bold(omega)$? Entonces el momento angular del rotor tendría que apuntar como $bold(omega)_r$, y no sólo sobre $hat(s)$.]
#dedos[$bold(H) = I bold(omega)$ es la versión de un solo eje. En tres
dimensiones el rotor tiene *dos* momentos de inercia distintos —uno grande
sobre su eje y otro de costado—, y cada uno *multiplica sólo su componente*
de $bold(omega)_r$: el de spin agranda la componente sobre $hat(s)$, el de
costado agranda las otras dos. Si los dos fueran iguales, las tres
componentes se estirarían igual y la flecha del momento angular quedaría
paralela a la de la velocidad angular; como no lo son, se tuerce hacia el eje
que más pesa. En el CMG, encima, la componente de spin ya es diez mil veces
más grande que las otras, así que el resultado es una flecha prácticamente
sobre $hat(s)$. (Es la misma razón por la que $bold(H)$ y $bold(omega)$ casi
nunca son paralelos: apunte, módulo 19.)]

// simbolos: I_s
*El momento angular.* El rotor es simétrico alrededor de $hat(s)$, con $I_s$
su momento de inercia sobre ese eje. Como $Omega_s$ es enorme frente a los
otros giros, su momento angular $bold(H)_r$#burbuja[$bold(H)_r$: el momento
angular del rotor, tomado respecto de su centro, que es su centro de masa.]
es, con muy buena aproximación,
$ bold(H)_r approx h hat(s), quad quad h = I_s Omega_s $
La aproximación tira los términos de $dot(delta)$ y de $bold(omega)_b$, que
con los números de arriba son diez mil veces más chicos (ANI-53: se dice y se
justifica).

#duda[Esa derivada, ¿es la que veo sentado en el cardán o la que ve alguien desde el espacio? ¿Y de dónde sale el producto vectorial?]
#dedos[Sentado en el cardán, ves el rotor girando siempre igual y su eje
quieto frente a vos: para vos, $bold(H)_r$ *no cambia*. Pero el cardán gira y
te lleva. Desde el espacio, esa flecha que vos ves quieta se mueve: su punta
recorre un arquito, y el arquito de una flecha que gira es siempre «velocidad
de giro por la flecha», un producto vectorial —la punta de un segundero se
mueve perpendicular al segundero—. La segunda ley de Newton, cupla igual a
cambio del momento angular, vale para el que mira *desde el espacio*: la
derivada que importa es ésa, y se arma con lo que ves vos (nada) más lo que
te lleva el cardán.]

*La derivada, mirada desde el espacio.* Con el subíndice diciendo quién
mira —«esp», el espacio; «car», alguien sentado en el cardán—, el teorema
del transporte da
$ ((d bold(H)_r)/(d t))_"esp" = ((d bold(H)_r)/(d t))_"car" + bold(Omega)_g times bold(H)_r $
y como la del cardán vale cero,
$ ((d bold(H)_r)/(d t))_"esp" = bold(Omega)_g times h hat(s) = h dot(delta) hat(t) + bold(omega)_b times h hat(s) $
*Y escrita en los ejes del cardán*: $h dot(delta)$ sobre $hat(t)$, más lo
que agregue el satélite si gira. Mirada desde el espacio, anotada con la
regla del cardán: son dos cosas distintas y no se pisan.

#duda[¿Por qué en el transporte va $bold(Omega)_g$, la del cardán, y no $bold(omega)_r$, que es la del rotor?]
#dedos[Porque la $bold(Omega)$ del transporte no es «la velocidad del
cuerpo»: es la velocidad *de los ejes en los que te sentaste*. Nos sentamos
en el cardán, que no da vueltas con el spin, así que va la del cardán. Si te
sentaras en el rotor también daría bien, pero verías las componentes de
$bold(H)_r$ dar vueltas a miles de rpm: misma respuesta, mucha más cuenta. Es
el «no siempre $bold(Omega) = bold(omega)$» de Aníbal.]

#duda[¿Quién le hace la cupla a quién? ¿Y por qué el satélite la recibe con un menos?]
#dedos[El rotor, solo, no puede girar su propia flecha: alguien lo tiene que
empujar, y ese alguien es el cardán, apoyado en el satélite. Acción y
reacción: lo que el satélite, a través del cardán y sus cojinetes, le hace al
rotor, el rotor se lo devuelve al satélite al revés. Como nadie de afuera tocó
nada, el momento angular que gana uno lo pierde el otro.]

La derivada de arriba es, entonces, la cupla que el satélite le hace al
rotor, y el satélite recibe la opuesta, $bold(tau)_"sat"$#burbuja[$bold(tau)_"sat"$:
la cupla que *recibe* el satélite, no la que hace. Es la derivada del espacio
con el signo cambiado.]:
$ bold(tau)_"sat" = - h dot(delta) hat(t) - bold(omega)_b times h hat(s) $

- *$- h dot(delta) hat(t)$ es la cupla de salida:* perpendicular al eje del
  cardán y al del rotor. Lappas la escribe $bold(N) = bold(h) times
  dot(bold(delta))$, que es lo mismo.
  // simbolos: N
- *$- bold(omega)_b times h hat(s)$ aparece sólo si el satélite ya gira.* Su
  parte sobre $hat(g)$ la tiene que aguantar el motor del cardán.

*Con los números de la sección 2* ($h = 0,35$ N·m·s, el del paper):
$ h dot(delta) = 0,35 dot.op 0,12 = 0,042 " N" dot.op "m" $
y el segundo término, $bold(omega)_b times h hat(s) = 0,05 hat(i) times 0,35
(0,866 hat(i) + 0,5 hat(j)) = 0,00875 hat(k)$ N·m: sobre el eje del cardán,
un $21$ % de la cupla de salida. Ése es el _gyro torque_ del paper, y por qué
el motor del cardán no trabaja gratis mientras el satélite maniobra.

#manos[
  Tres dedos de la mano derecha: pulgar $hat(g)$ (el giro del cardán), índice
  $hat(s)$ (el rotor), mayor $hat(t)$. Pulgar por índice da mayor: $hat(g)
  times hat(s) = hat(t)$. La punta de $bold(H)_r$ se va hacia $hat(t)$; al
  satélite le toca la cupla al revés, hacia $-hat(t)$.
]

= 4. Proyectar: la cupla vista desde el satélite
#origen[Apunte, módulo 22, figura de la cupla proyectada. Lo que pidió el parcialito del 29/10: bajar cada vector a la terna que se eligió.]

#gancho[El control de actitud piensa en los ejes del satélite: cuánto lo
hace girar cada cupla alrededor de su eje largo, de su eje corto, de su eje
de apuntado. Proyectar es lo que traduce el CMG a ese idioma, y de paso
muestra la consecuencia más incómoda del aparato: la cupla *gira con el
cardán*. Si querés empujar siempre para el mismo lado, el cardán no puede
girar mucho; si gira mucho, empuja para otro lado. Es la primera pista de por
qué hace falta más de un CMG.]

#duda[Si el vector es el mismo, ¿para qué lo proyecto en los ejes del satélite?]
#dedos[Porque el que pregunta es el satélite. Proyectar no cambia la flecha:
es leer su sombra sobre cada una de las tres reglas del satélite. La flecha
es una sola; las sombras dependen de dónde pongas las reglas.]

Con el satélite quieto y el cardán sobre $hat(k)$:
$ hat(s) = cos delta thin hat(i) + sin delta thin hat(j), quad quad
  hat(t) = hat(k) times hat(s) = - sin delta thin hat(i) + cos delta thin hat(j) $
$ bold(H)_r = h (cos delta; sin delta; 0), quad quad
  bold(tau)_"sat" = h dot(delta) (sin delta; - cos delta; 0) $
Y se puede llegar por los dos caminos: derivando las componentes de
$bold(H)_r$ en la terna del satélite (que está quieta) o con el transporte
desde el cardán. Dan lo mismo, y conviene decirlo en el examen: es el
control.

#figure(fig-act-cmg-proyeccion, caption: [$bold(H)_r$ proyectado sobre los
ejes del satélite, y la cupla de salida. Del apunte, módulo 22.])

*Con $delta = 30degree$ y $h dot(delta) = 0,042$ N·m:*
$bold(tau)_"sat" = 0,042 (0,5; -0,866; 0) = (0,021; -0,0364; 0)$ N·m#burbuja[Esas
tres componentes son las de los ejes del *satélite*, $hat(i)$, $hat(j)$,
$hat(k)$; el vector es el mismo de la sección 3, que estaba escrito en los del
cardán.]. La
lectura que vale el punto: *la cupla de salida gira con $delta$*. Con
$delta = 0$ va toda sobre $-hat(j)$; con $delta = 90degree$, toda sobre
$+hat(i)$. Un CMG de un cardán da cupla en una sola dirección por vez, y
siempre en el plano perpendicular a su cardán.

= 5. Torque de salida y amplificación
#origen[Apunte, módulo 20 (el volante en el gimbal: $500$ N·m de salida contra $2,5$ de entrada) y módulo 22; los dos nombres que Aníbal dio para el parcialito del cap. 18.]

#gancho[Es la razón por la que existe el CMG: con un motor de juguete en el
cardán se mueve un satélite entero. Lo que hay que llevarse es cuánto
amplifica, de qué depende —del momento angular del rotor y de qué tan rápido
se gira el cardán, no del motor— y de dónde *no* sale: no sale de la nada.
Es también lo que Aníbal nombró para el parcialito del cap. 18, «torque de
salida, amplificación de torques».]

// simbolos: I_G, deltaddot
Hay dos cuplas sobre ejes distintos. *La de entrada* la pone el motor sobre
$hat(g)$, y sólo tiene que acelerar el cardán: $I_G dot.double(delta)$, con
$I_G$ el momento de inercia del cardán (con el rotor) sobre su eje y
$dot.double(delta)$ su aceleración angular. *La de salida* la recibe el
satélite sobre $hat(t)$: $h dot(delta)$.

*Con números* (supuesto, para poner uno: el cardán de $I_G = 1 times
10^(-4)$ kg·m² llega a $0,12$ rad/s en $0,5$ s): entra $I_G
dot.double(delta) = 10^(-4) dot.op 0,24 = 2,4 times 10^(-5)$ N·m y salen
$0,042$ N·m: una amplificación de unas $1750$ veces. Una rueda de reacción
tiene amplificación uno: su cupla de salida es la de su motor.

#duda[Si sale mil setecientas veces más cupla de la que pone el motor, ¿no estoy sacando energía de la nada?]
#dedos[No: se amplifica la *cupla*, no la energía. Es una palanca: con la
mano hacés poca fuerza y levantás una piedra pesada, pero la mano recorre
mucho y la piedra poco. Acá la cupla grande la hacen los cojinetes,
empujando de costado sobre $hat(t)$, y con el satélite quieto nada gira
todavía en esa dirección: una cupla que no hace girar nada no trabaja. ¿Y
cuando el satélite ya gira y gana energía? Ahí aparece el término que cae
sobre el eje del cardán, el _gyro torque_ de la sección 3: el motor lo tiene
que vencer, y lo que pone es justo lo que gana el satélite.]

*La cuenta que lo confirma*, con la misma aproximación $bold(H)_r approx h
hat(s)$. La potencia que recibe el satélite es su cupla por su velocidad
angular; el término $bold(omega)_b times h hat(s)$ es perpendicular a
$bold(omega)_b$ y no aporta:
$ bold(tau)_"sat" dot.op bold(omega)_b = - h dot(delta) thin (hat(t) dot.op bold(omega)_b) $
El motor, para sostener $dot(delta)$, tiene que dar sobre $hat(g)$ la parte
del cambio de $bold(H)_r$ que cae ahí, $(bold(omega)_b times h hat(s)) dot.op
hat(g) = - h thin (bold(omega)_b dot.op hat(t))$ —producto mixto, y $hat(s)
times hat(g) = -hat(t)$—, y su potencia es eso por $dot(delta)$: la misma.
Con el satélite quieto, las dos valen cero.

= 6. Varios CMG: saturación y posiciones singulares
#origen[Apunte, módulo 22; Lappas 2002, pág. 102 (cuatro en pirámide); Chubb y Seltzer 1971, fig. 3 (la posición antiparalela).]

#gancho[Un CMG solo empuja en un plano: el perpendicular a su cardán. Para
los tres ejes hacen falta varios, y ahí aparece lo complicado de verdad, que
no es la física sino el *reparto*: decidir cuánto gira cada cardán para que la
suma dé la cupla pedida sin que el conjunto quede mal parado. Los ingenieros
del Skylab escribieron para eso una ley entera de distribución. Y es acá donde
el CMG tiene sus dos límites: uno que también tiene la rueda (llenarse) y uno
que es sólo suyo (trabarse).]

// simbolos: H_c
Con varios CMG la cupla es la suma, y el momento angular del conjunto,
$bold(H)_c$ (la suma de los $bold(H)_r$ de todos), más el del satélite, no
cambia. Dos límites:

- *Saturación:* todos los $bold(H)_r$ para el mismo lado. $bold(H)_c$ llegó
  a su largo máximo y en esa dirección no puede absorber más. En criollo:
  estamos en el horno, y sólo algo de afuera (un propulsor, la gravedad) nos
  saca.
- *Posición singular:* todos los $hat(t)$ en un mismo plano. Hay una
  dirección de cupla que ningún giro de los cardanes produce, aunque no esté
  saturado: el CMG «se traba». Por eso hacen falta *al menos cuatro* CMG de
  un cardán, en pirámide, para los tres ejes.

#duda[Si con dos CMG antiparalelos el momento angular del conjunto es cero, ¿por qué eso también es un problema?]
#dedos[Porque lo que importa no es cuánto momento angular hay guardado sino
*hacia dónde puede empujar* cada CMG, que es siempre sobre su $hat(t)$. Con
los dos rotores sobre la misma recta —para el mismo lado o para lados
opuestos—, los dos $hat(t)$ también quedan sobre una misma recta, y los dos
sólo saben empujar para ahí. Es un auto con el volante trabado: el motor
anda, pero no dobla.]

#duda[¿Y por qué un CMG saturado no se descarga solo, girando los cardanes para otro lado?]
#dedos[Porque todo lo que pasa adentro del satélite reparte el momento
angular entre sus piezas, pero no lo saca. Pasarte la plata de un bolsillo al
otro no te hace más pobre. Para sacarlo hace falta una cupla de *afuera*: un
propulsor, el campo magnético de la Tierra o la gravedad.]

#figure(fig-act-cmg-singular, caption: [Dos CMG sobre el mismo eje de cardán:
abiertos, paralelos y antiparalelos. Del apunte, módulo 22.])

#figure(fig-cmg-piramide, caption: [Cuatro CMG de un cardán en pirámide, la
disposición del paper de Lappas (2002, fig. 15). Cada cardán $hat(g)$ (verde)
es perpendicular a una cara, y cada $bold(H)_r$ (rojo) gira en el plano de su
cara. Como los cuatro planos son distintos, siempre queda alguna combinación
de giros de cardán que da cupla para cualquier lado: por eso cuatro y no
tres.])

= 7. Dos satélites de verdad, y el giróscopo que mide
#origen[Chubb y Seltzer 1971 (Skylab, NASA TN D-6068); Lappas, Steyn y Underwood 2002; Wrigley y Hollister 1965. Los tres, de la cátedra.]

#gancho[Los números de verdad, de los papers de la cátedra. Ver cuánto
guarda un CMG grande y uno chico, y cuánto tarda en llenarse, te da el orden
de magnitud para contestar un «opine» sin calculadora: un satélite con cuplas
externas que siempre empujan para el mismo lado se satura, y la pregunta de
ingeniería es cada cuánto y cómo se descarga sin gastar.]

*El Skylab.* Tres CMG de *doble* cardán, ortogonales, de $2700$ N·m·s cada
uno, con el rotor a $149$ vueltas por segundo ($936$ rad/s): el rotor tiene
$I_s = 2700 \/ 936 approx 2,88$ kg·m². Por qué CMG y no propulsores: el gas
habría ensuciado la óptica del telescopio solar, y las cuplas del gradiente
de gravedad son cíclicas, así que el CMG las absorbe en media órbita y las
devuelve en la otra. Lo que no es cíclico: unos $600$ N·m·s por órbita sobre
el eje largo, porque sus momentos de inercia son muy distintos ($0,886 times
10^6$ contra unos $5,8 times 10^6$ kg·m²).

*Predicción sin datos de más.* Los tres juntos guardan a lo sumo $3 dot.op
2700 = 8100$ N·m·s: se saturan en $8100 \/ 600 = 13,5$ órbitas. A $435$ km
la órbita dura unos $93,3$ min (tercera ley de Kepler), así que en *unas 21
horas*. La salida del informe: de noche, girar la estación para que el
gradiente de gravedad —una cupla *externa*— empuje para el otro lado y
desature gratis. Los propulsores, sólo si los CMG pasan del $95$ % de su
capacidad.

// simbolos: alpha, tau, I_sat
*El microsatélite de Surrey.* Del requisito al CMG: un satélite de
$I_"sat" = 2,5$ kg·m² tiene que girar $30degree$ en $10$ s. Acelerando $5$ s
y frenando $5$: $alpha = 2 dot.op 0,2618 \/ 25 approx 0,0209$ rad/s², con
$alpha$ la aceleración angular, y una cupla $tau = I_"sat" alpha approx
0,0524$ N·m. Llega a $0,105$ rad/s ($6degree$ por segundo). Con el cardán a
$0,12$ rad/s, un CMG solo necesitaría $h approx 0,44$ N·m·s; cuatro en
pirámide, $0,35$ cada uno. En la mesa de aire, un disco con $h approx
0,0235$ N·m·s y el cardán a $0,419$ rad/s dieron $9,83$ mN·m calculados
contra $9,82$ medidos.

// simbolos: H_s
*El giróscopo que mide* (Wrigley y Hollister). La misma ecuación al revés:
$bold(omega) times bold(H)_s = bold(M)$, con $bold(H)_s$ el momento angular
de spin. Si una cupla de resorte frena al giróscopo, el ángulo que se
tuerce dice la *velocidad* de giro (un _rate gyro_, como los del Skylab); si
la pone un amortiguador, dice el *ángulo* girado (el integrador del guiado
inercial). Y el girocompás con la sintonía de Schuler oscila con un período
de unos $84,4$ min, el de un péndulo del largo del radio terrestre.

#posta[
  El CMG es la silla con la rueda de bicicleta, pero torciéndole el eje en
  vez de acelerarla. Mucha cupla, poco motor, y el rotor ni se entera. El día
  que los ejes quedan donde ya no se pueden torcer —saturado, o trabado en
  una singularidad—, hay que pedirle ayuda a algo de afuera. El Skylab se la
  pedía a la gravedad, de noche y sin gastar un gramo. Si Aníbal pregunta
  algo de esto, casi todo se contesta con una sola idea: *girar la dirección
  de un $bold(H)$ grande cuesta una cupla, y esa cupla la paga el satélite*.
]

= 8. El parcialito 5, contestado, y el mismo examen con un CMG
#origen[El enunciado del 29/10 (la fig. 18.15 del Beer: el giróscopo en cardanes), que trajo Fran el 10/11. Las respuestas salen del Beer §18.9, ecs. 18.33 a 18.38, págs. 1187–1188, y de la hoja 2 del resumen manuscrito de Aníbal. Sin figuras, como pidió él: todo en palabras.]

// simbolos: C, C', B, B', A, A', Z, X, Y, O
Seis preguntas sobre el giróscopo del Beer —rotor sobre el eje $C C'$, un
anillo interior que gira sobre $B B'$, un anillo exterior que gira sobre el
eje fijo $A A'$, y la terna fija $X$, $Y$, $Z$ (con $Z$ sobre $A A'$) con
origen en $O$, el centro del rotor—, sin un número y sin dibujo. La cuenta es lo de menos: lo
que se evalúa es poder *escribir* lo que uno dibujaría. Primero el parcialito
tal como vino; después, las mismas seis preguntas con un CMG, que es por
dónde puede venir el del jueves.

// simbolos: phi, theta, psi
#pregunta(1, [Defina en palabras los tres ángulos que fijan la posición más general del giróscopo.])[
  $phi$: el ángulo que gira el anillo exterior alrededor del eje fijo $A A'$
  (el $Z$ de la figura), medido desde una posición de referencia del anillo
  (por ejemplo, con su plano conteniendo a $X$). $theta$: el ángulo que gira
  el anillo interior respecto del exterior alrededor de $B B'$; es el ángulo
  entre el eje del rotor $C C'$ y el eje fijo $Z$. $psi$: el ángulo que gira
  el rotor respecto del anillo interior alrededor de su propio eje $C C'$,
  medido desde una marca en el rotor. Tres articulaciones, tres ángulos, uno
  por articulación.
]

#pregunta(2, [Defina en palabras un sistema de referencia fijo al cuerpo.])[
  Origen en $O$, el centro del rotor, que es el punto fijo. $hat(k)$ sobre el
  eje del rotor, de $C$ hacia $C'$; $hat(j)$ sobre el eje $B B'$ de los
  cojinetes del anillo interior, hacia $B'$ (es la «línea de nodos»);
  $hat(i) = hat(j) times hat(k)$, en el plano que forman $Z$ y el eje del
  rotor. Y la característica que conviene decir: la terna está pegada al
  *anillo interior*, no al rotor. Gira con $phi$ y con $theta$ pero no con
  $psi$, así que sus ejes son principales del rotor sin dar vueltas con él
  («no siempre $bold(Omega) = bold(omega)$»).
]

// simbolos: K, phidot, thetadot, psidot
#pregunta(3, [Escriba en forma vectorial la velocidad angular total.])[
  Con $bold(K)$ el versor del eje fijo $Z$ y $dot(phi)$, $dot(theta)$,
  $dot(psi)$ las derivadas de los tres ángulos:
  $bold(omega) = dot(phi) bold(K) + dot(theta) hat(j) + dot(psi) hat(k)$.
  Cada giro va sobre el eje de *su* articulación.
]

#pregunta(4, [¿Qué nombre recibe cada velocidad angular?])[
  $dot(phi)$ es la velocidad de *precesión*, $dot(theta)$ la de *nutación* y
  $dot(psi)$ la de *giro propio* o *spin* (Beer §18.9; la hoja 2 de Aníbal).
]

#duda[Si $bold(K)$, $hat(j)$ y $hat(k)$ miden uno los tres, ¿por qué no es una base ortonormal?]
#dedos[Unitario quiere decir «mide uno», no «es perpendicular a los otros», y
ortonormal pide las dos cosas. Poné el índice vertical, como el eje fijo
$bold(K)$, y el pulgar inclinado, como el eje del rotor $hat(k)$: miden lo
mismo, pero entre ellos queda el ángulo $theta$, que no es recto. Con esa base
se puede escribir el vector, pero sus tres números no son las tres sombras
independientes de la flecha.]

#pregunta(5, [¿Es ortonormal la base del punto 3? ¿Por qué?])[
  No. Los tres versores son unitarios, y $hat(j)$ es perpendicular a los
  otros dos, pero $bold(K)$ y $hat(k)$ forman entre sí el ángulo $theta$: son
  perpendiculares sólo si $theta = 90degree$. Es una base, pero no
  ortogonal: mezcla un versor fijo al espacio con dos del anillo interior.
]

#pregunta(6, [Escriba ese vector en una base ortonormal.])[
  Se proyecta $bold(K)$ sobre la terna del anillo interior: $bold(K) = -sin
  theta thin hat(i) + cos theta thin hat(k)$ (Beer ec. 18.34; el menos es
  porque $hat(i)$ queda del lado opuesto a $Z$). Reemplazando,
  $bold(omega) = -dot(phi) sin theta thin hat(i) + dot(theta) hat(j) +
  (dot(psi) + dot(phi) cos theta) hat(k)$. Control: con $theta$ quieto y
  $theta = 90degree$, queda $-dot(phi) hat(i) + dot(psi) hat(k)$, dos giros
  perpendiculares, como tiene que ser.
]

*El mismo examen, con un CMG.* Las seis preguntas cambian de piezas y no de
forma: el anillo exterior es el satélite, el interior es el cardán, y el
rotor es el rotor.

#pregunta(7, [Defina en palabras los ángulos que fijan el rotor de un CMG de un cardán respecto del satélite, y un sistema fijo al cardán.])[
  Dos ángulos: $delta$, lo que gira el cardán alrededor de su eje —clavado al
  satélite— desde una posición de referencia; y el ángulo de spin del rotor
  alrededor de su propio eje, respecto del cardán. (La orientación del
  satélite agrega otros tres, los de su actitud.) El sistema: origen en el
  centro del rotor, $hat(g)$ sobre el eje del cardán, $hat(s)$ sobre el eje
  del rotor y $hat(t) = hat(g) times hat(s)$; pegado al cardán, que no
  sigue el spin.
]

#pregunta(8, [Escriba la velocidad angular del rotor, nombre cada término y diga si la base es ortonormal.])[
  $bold(omega)_r = bold(omega)_b + dot(delta) hat(g) + Omega_s hat(s)$: la
  del satélite, la *velocidad de cardán* (Lappas la llama _rate of
  precession or the gimbal rate_: en un CMG, girar el cardán *es* hacer
  precesar al rotor) y el *spin*. $hat(g)$ y $hat(s)$ son perpendiculares por
  construcción, pero $bold(omega)_b$ está escrita en la terna del satélite:
  la suma mezcla dos bases. Con $hat(g) = hat(k)$ del satélite y $hat(s) =
  cos delta thin hat(i) + sin delta thin hat(j)$, todo en la terna del
  satélite: $bold(omega)_r = bold(omega)_b + Omega_s cos delta thin hat(i) +
  Omega_s sin delta thin hat(j) + dot(delta) hat(k)$.
]

= 9. Preguntas que pueden caer, con la respuesta corta
#origen[Con la forma de sus parcialitos: preguntas encadenadas (ANI-30), el dibujo como respuesta (ANI-31), «diga si depende de…» (ANI-59), «discuta» (ANI-33), predicción (ANI-34) y, como el del 29/10, velocidades angulares y proyecciones (ANI-71).]

#pregunta(1, [Escriba la velocidad angular del rotor de un CMG montado en un satélite que gira. ¿Depende del sistema de coordenadas?])[
  $bold(omega)_r = bold(omega)_b + dot(delta) hat(g) + Omega_s hat(s)$: la
  del satélite, más la del cardán respecto del satélite, más la del rotor
  respecto del cardán. El vector no depende del sistema; sus componentes sí.
]

#pregunta(2, [Proyecte $bold(H)_r$ y la cupla de salida sobre los ejes del satélite, con el cardán sobre $hat(k)$ a un ángulo $delta$. Dibuje.])[
  $bold(H)_r = h (cos delta; sin delta; 0)$; la cupla sobre el satélite,
  $h dot(delta) (sin delta; -cos delta; 0)$: perpendicular a $bold(H)_r$ y
  al cardán, y girando con $delta$. El dibujo es el de la sección 4.
]

#pregunta(3, [¿Por qué el rotor no se frena? ¿De dónde sale el momento angular que gana el satélite?])[
  Porque la cupla que recibe el rotor es perpendicular a su $bold(H)$: le
  cambia la dirección y no el módulo (la analogía con la órbita). El
  satélite gana lo que el rotor «pierde» *en dirección*: el total no cambia
  porque el motor es interno.
]

#pregunta(4, [Un CMG de $h = 0,35$ N·m·s gira su cardán a $0,12$ rad/s. ¿Qué cupla recibe el satélite? Si el motor lleva el cardán a esa velocidad en $0,5$ s con $I_G = 10^(-4)$ kg·m², ¿cuánto amplifica?])[
  Sale $h dot(delta) = 0,042$ N·m; entra $2,4 times 10^(-5)$ N·m.
  Amplificación: unas $1750$ veces. No es magia: el momento angular sale de
  girar la dirección de uno grande.
]

#pregunta(5, [¿Qué pasa si los dos CMG de un par quedan paralelos? ¿Y antiparalelos?])[
  Paralelos: un solo $hat(t)$, una sola dirección de cupla, y $bold(H)_c$ al
  máximo (saturado en esa dirección). Antiparalelos: $bold(H)_c = bold(0)$
  pero los $hat(t)$ quedan sobre una misma recta: singular sin estar
  saturado. El Skylab tenía una «ley de distribución» para no caer ahí.
]

#pregunta(6, [¿Por qué el Skylab usó CMG y no sus propulsores para apuntar?])[
  Porque los gases habrían ensuciado la óptica del telescopio solar, y porque
  las cuplas del gradiente de gravedad son cíclicas: un CMG las absorbe y
  las devuelve sin gastar nada. Los propulsores quedaron para desaturar si
  hacía falta.
]

#pregunta(7, [Si el gradiente de gravedad le deja al Skylab $600$ N·m·s por órbita siempre del mismo lado, ¿en cuánto se saturan sus tres CMG de $2700$ N·m·s?])[
  $8100 \/ 600 = 13,5$ órbitas: unas 21 horas a $93,3$ min por órbita. Sin
  desaturar, menos de un día.
]

#pregunta(8, [¿Cómo desaturaba el Skylab sin gastar combustible? ¿Es una cupla interna o externa?])[
  Girando la estación de noche para que el gradiente de gravedad empujara
  al revés. Es *externa*: es la única manera de sacarle momento angular al
  conjunto. Un CMG solo, por ser interno, no puede desaturarse a sí mismo.
]

#pregunta(9, [Compare un CMG con una rueda de reacción: ¿cómo hace la cupla cada uno?])[
  La rueda cambia su *velocidad* sobre su eje fijo; amplificación uno. El
  CMG cambia la *dirección* de un $bold(H)$ de módulo fijo; amplificación
  grande. Los dos son internos y los dos se saturan; el CMG, además, tiene
  posiciones singulares.
]

#pregunta(10, [Discuta: ¿qué cambia si se duplica $h$?])[
  La cupla de salida se duplica para el mismo $dot(delta)$, y el conjunto
  guarda el doble antes de saturarse. A cambio, el rotor pesa más o gira
  más rápido (más motor, más energía), y el motor del cardán tiene que
  aguantar el doble de _gyro torque_ cuando el satélite maniobra.
]

#pregunta(11, [¿Para qué ejes vale escribir el teorema del transporte en un CMG? ¿Por qué no los del rotor?])[
  Los del cardán, que giran con $bold(Omega)_g = bold(omega)_b + dot(delta)
  hat(g)$: son principales del rotor y no siguen el spin. Con los del rotor
  las componentes de $bold(H)_r$ cambiarían a miles de rpm y daría lo mismo
  con mucha más cuenta: «no siempre $bold(Omega) = bold(omega)$».
]

#pregunta(12, [Un giróscopo como sensor: ¿qué mide un _rate gyro_ y qué uno integrador?])[
  Con $bold(omega) times bold(H)_s = bold(M)$: si la cupla la pone un
  resorte, el ángulo torcido es proporcional a la velocidad de giro (_rate
  gyro_); si la pone un amortiguador, al ángulo girado (integrador).
]

#pregunta(13, [La derivada de $bold(H)_r$ que entra en el teorema del transporte, ¿está medida desde el cardán o desde el espacio? ¿Y escrita en qué ejes?])[
  Medida desde el espacio: es la que pide la segunda ley. Escrita en los ejes
  del cardán, porque ahí sale corta. La derivada vista desde el cardán vale
  cero —el rotor gira siempre igual sobre un eje que el cardán ve quieto— y
  el transporte agrega $bold(Omega)_g times bold(H)_r$.
]

#pregunta(14, [La cupla de salida es mil veces la del motor del cardán. ¿Se viola la conservación de la energía?])[
  No: se amplifica la cupla, no la potencia. La cupla de salida la hacen los
  cojinetes sobre $hat(t)$ y, con el satélite quieto, no trabaja. Cuando el
  satélite gira, el motor vence el _gyro torque_ sobre $hat(g)$ y pone
  exactamente la potencia que gana el satélite, $- h dot(delta) thin (hat(t)
  dot.op bold(omega)_b)$.
]

= 10. Para la hora de clase: un guion de cuatro bloques
#origen[La hora es «a cargo exclusivamente» de los alumnos (ANI-R15). Aníbal valora la demostración y el video explicados (ANI-60) y la intuición en lo antiintuitivo (ANI-03).]

+ *La silla y la rueda* (5 min): la demostración de la caja de la sección 1,
  antes de una sola fórmula. Pregunta para la clase: ¿por qué gira la silla
  si la rueda sigue igual?
+ *Las tres velocidades y la cupla* (15 min): la figura de los giros, la
  terna del cardán con tres dedos y la cupla $-h dot(delta) hat(t)$ por el
  transporte. Cerrar con la proyección y la frase «la cupla gira con
  $delta$».
+ *Por qué hace falta más de uno* (10 min): saturación y singularidades con
  la figura de los dos CMG; la pirámide de cuatro.
+ *El Skylab* (15 min): por qué CMG, la predicción de las 21 horas, y la
  desaturación con la gravedad de noche. Es el final que se acuerda.

Si sobra tiempo: el microsatélite de Surrey como ejemplo de cómo se
dimensiona un CMG desde el requisito, y el giróscopo como sensor.

= Las fórmulas, juntas

#tabla((1fr, 1.4fr),
  [Velocidades], [$bold(Omega)_g = bold(omega)_b + dot(delta) hat(g)$; #h(0.8em) $bold(omega)_r = bold(omega)_b + dot(delta) hat(g) + Omega_s hat(s)$],
  [Terna del cardán], [$hat(t) = hat(g) times hat(s)$],
  [Momento angular del rotor], [$bold(H)_r approx h hat(s)$, con $h = I_s Omega_s$],
  [Cupla sobre el satélite], [$bold(tau)_"sat" = - h dot(delta) hat(t) - bold(omega)_b times h hat(s)$],
  [Proyectada (cardán sobre $hat(k)$)], [$bold(tau)_"sat" = h dot(delta) (sin delta; - cos delta; 0)$],
  [Amplificación], [$(h dot(delta))/(I_G dot.double(delta))$],
  [Sensor], [$bold(omega) times bold(H)_s = bold(M)$],
)
