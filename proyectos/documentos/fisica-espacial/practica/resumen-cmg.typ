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

#show: documento.with(
  titulo: [Guía para el parcialito — CMG],
  subtitulo: [El giróscopo de control de momento: las velocidades, los vectores, el Skylab y lo que va a preguntar Aníbal],
  encabezado: [Guía para el parcialito — CMG],
)

#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)
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
  tendríamos que saber explicar solos—. Esta guía sirve para las dos: las secciones 1 a 7 son el
  tema entero, la 8 son las preguntas que pueden caer con su respuesta, y la 9
  es un guion para la hora de clase.

  *Qué esperar del parcialito.* El último (29/10, cuerpo rígido) pidió
  *escribir las velocidades angulares del giróscopo y proyectar vectores*. Con
  un CMG eso es exactamente la sección 2 y la 4 de acá: armar la velocidad
  angular del rotor sumando giros, y bajar el momento angular y la cupla a
  los ejes del satélite. Y de los parcialitos anteriores: preguntas cortas encadenadas,
  el dibujo es la respuesta, poca cuenta, y una predicción al final.

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
  [El dibujo es la respuesta (ANI-31)], [cada vector, dibujado: la terna del cardán, $bold(H)$ proyectado, la cupla de salida],
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

= 1. Qué es un CMG, en una frase y en las manos
#origen[Apunte, módulo 22, «El CMG por dentro» y la tabla de los tres actuadores; módulo 20, el volante en el gimbal; Curtis §12.9.]

*La idea.* Un CMG es un rotor que gira *siempre igual*, rapidísimo, montado
en un cardán que un motor hace girar. El rotor no se frena nunca: lo único
que cambia es *hacia dónde* apunta su momento angular. Y como el motor está
adentro del satélite, el momento angular del satélite más el del rotor no
cambia: lo que el rotor tuerce para un lado, el satélite lo tuerce para el
otro. Es la analogía de Aníbal: una fuerza perpendicular a la velocidad le
cambia la dirección y no el módulo; una cupla perpendicular a $bold(H)$,
igual.

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

#trampa[
  *Amplificación no es magia.* El CMG da mucha más cupla que la que pone el
  motor del cardán, pero no crea momento angular: lo saca de *girar la
  dirección* de uno enorme que ya estaba ahí. El total, satélite más rotor,
  sigue igual.
]

= 2. Las tres velocidades angulares
#origen[Beer §18.9 (el giróscopo en cardanes: cada articulación suma su giro relativo), la hoja 2 del resumen manuscrito de Aníbal y el parcialito del 29/10, que pidió escribir esto mismo.]

Hay tres cuerpos: el satélite, el cardán y el rotor. *Cada articulación suma
su giro relativo al de la pieza que la sostiene*:

// simbolos: omega_b, Omega_g, omega_r
- el satélite gira con $bold(omega)_b$ respecto del espacio;
- el cardán, con $bold(Omega)_g = bold(omega)_b + dot(delta) hat(g)$;
- el rotor, con $bold(omega)_r = bold(omega)_b + dot(delta) hat(g) + Omega_s hat(s)$.

#figure(fig-act-cmg-giros, caption: [Las tres piezas y sus giros relativos.
Del apunte, módulo 22.])

*¿Qué ejes?* Los del cardán, $(hat(s), hat(t), hat(g))$, que giran con
$bold(Omega)_g$ y *no* con $bold(omega)_r$: siguen al cardán y no al spin.
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

// simbolos: H_r, I_s
*El momento angular.* El rotor es simétrico alrededor de $hat(s)$, con $I_s$
su momento de inercia sobre ese eje. Como $Omega_s$ es enorme frente a los
otros giros, su momento angular $bold(H)_r$ es, con muy buena aproximación,
$ bold(H)_r approx h hat(s), quad quad h = I_s Omega_s $
La aproximación tira los términos de $dot(delta)$ y de $bold(omega)_b$, que
con los números de arriba son diez mil veces más chicos (ANI-53: se dice y se
justifica).

*La derivada.* Mirando desde el cardán, $h$ no cambia y $hat(s)$ está quieto,
así que sólo queda el transporte:
$ (d bold(H)_r)/(d t) = bold(Omega)_g times h hat(s) = h dot(delta) hat(t) + bold(omega)_b times h hat(s) $
Ésa es la cupla que el satélite le hace al rotor. El satélite recibe la
opuesta:
// simbolos: tau_sat
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
$bold(tau)_"sat" = 0,042 (0,5; -0,866; 0) = (0,021; -0,0364; 0)$ N·m. La
lectura que vale el punto: *la cupla de salida gira con $delta$*. Con
$delta = 0$ va toda sobre $-hat(j)$; con $delta = 90degree$, toda sobre
$+hat(i)$. Un CMG de un cardán da cupla en una sola dirección por vez, y
siempre en el plano perpendicular a su cardán.

= 5. Torque de salida y amplificación
#origen[Apunte, módulo 20 (el volante en el gimbal: $500$ N·m de salida contra $2,5$ de entrada) y módulo 22; los dos nombres que Aníbal dio para el parcialito del cap. 18.]

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

= 6. Varios CMG: saturación y posiciones singulares
#origen[Apunte, módulo 22; Lappas 2002, pág. 102 (cuatro en pirámide); Chubb y Seltzer 1971, fig. 3 (la posición antiparalela).]

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

#figure(fig-act-cmg-singular, caption: [Dos CMG sobre el mismo eje de cardán:
abiertos, paralelos y antiparalelos. Del apunte, módulo 22.])

= 7. Dos satélites de verdad, y el giróscopo que mide
#origen[Chubb y Seltzer 1971 (Skylab, NASA TN D-6068); Lappas, Steyn y Underwood 2002; Wrigley y Hollister 1965. Los tres, de la cátedra.]

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

= 8. Preguntas que pueden caer, con la respuesta corta
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

= 9. Para la hora de clase: un guion de cuatro bloques
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
