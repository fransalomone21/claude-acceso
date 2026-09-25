#import "../plantilla.typ": *

#modulo("Rotación alrededor de un eje fijo: el Sears, capítulos 9 y 10", clave: "rotacion")[
  El escalón que faltaba entre la partícula y el cuerpo rígido en tres
  dimensiones: un cuerpo que gira alrededor de un eje que no se mueve. Con
  eso solo aparecen el momento de inercia, el torque como producto
  vectorial, $tau = I alpha$, $L = I omega$ —y por qué esa ecuación «no es
  la más general»—, la conservación del impulso angular y, al final, el
  giróscopo que no se cae. Es la lista de temas «Impulso angular» de la
  cátedra, fila por fila.
]

*Antes de cualquier ecuación, el experimento.* Se toma una rueda de
bicicleta con un eje largo, se apoya un extremo del eje sobre la punta de un
poste y se suelta. Si la rueda está quieta, pasa lo que cualquiera espera: el
eje cae, la rueda golpea la mesa. Si la rueda está *girando* rápido, pasa otra
cosa: el eje no cae. Queda horizontal, «flotando», apoyado sólo en la punta
del poste, y además empieza a dar vueltas lentamente alrededor del poste. Eso
se llama *precesión*, y el Sears lo presenta con una honestidad poco común:
dice que es un movimiento que «se opone a la intuición» (S&Z §10.7, pág.
323).

#aparte[
  Se empieza por acá y no por la fórmula a propósito. Aníbal no perdona que
  un fenómeno se explique desde la teoría como si alguien lo hubiera deducido
  primero y medido después: los espectroscopistas midieron líneas durante
  décadas sin tener idea de qué eran, y nadie dedujo el giróscopo en un
  pizarrón antes de soltar uno. Primero se mira. Después se entiende. En ese
  orden, que es el de la historia y el de la cátedra.
]

Para entender por qué no cae hacen falta cuatro piezas, y este módulo las
arma en el orden en que se necesitan:

+ *La velocidad angular como vector*, no sólo como número: sin eso, «el eje
  gira para allá» no se puede escribir.
+ *El momento de inercia*, que aparece solo —sin que nadie lo invente— al
  escribir la energía cinética de algo que gira.
+ *El torque*, que es para la rotación lo que la fuerza es para la
  traslación, y la *ley* que los une: $tau = I alpha$ en la versión de eje
  fijo, $bold(tau) = d bold(L) \/ d t$ en la general.
+ *El momento angular del cuerpo*, $L = I omega$, que es lo que el torque
  cambia. En el giróscopo, el torque del peso le cambia a $bold(L)$ la
  *dirección* y no el tamaño, y eso —exactamente eso— es la precesión.

Todo el módulo supone que el eje de giro *no cambia de dirección*, salvo en la
última sección, que es justamente donde esa suposición se rompe y aparece lo
interesante. El caso general —el eje que se mueve como quiere— es el de los
cuatro módulos que siguen.

#lectura[
  *Sears-Zemansky (Young & Freedman), volumen 1, capítulo 9* («Rotación de
  cuerpos rígidos»): §9.1 velocidad angular (pág. 274), §9.3 relación con la
  cinemática lineal (pág. 281), §9.4 energía de rotación y momento de inercia
  (pág. 284, con la Tabla 9.2 en la pág. 286) y §9.5 teorema de los ejes
  paralelos (pág. 288). *Capítulo 10* («Dinámica del movimiento de
  rotación»): §10.1 torca (pág. 304), §10.2–10.3 $tau = I alpha$ y rotación
  con traslación (pág. 307–313), §10.5 momento angular (pág. 316), §10.6
  conservación (pág. 321) y §10.7 giróscopos y precesión (pág. 323).

  *Roederer, Mecánica elemental*, §2.h («La velocidad angular», pág. 58) y
  §4.e («La conservación del impulso angular», pág. 120), para una segunda
  lectura — la cátedra lo pide así en la propia lista de temas.

  Qué abrir para qué: el Sears para todo lo de este módulo, en orden y con
  muchos ejemplos numéricos; el Roederer cuando se quiera la versión
  vectorial, más corta y más fina.
]

#aparte[
  Sí: el Sears. El famoso Sears-Zemansky que tanto le gusta a Aníbal —y que
  la propia lista de temas de la cátedra, en la columna de comentarios,
  califica de «un poco elemental», mandando a apoyarse en el Roederer.
  Traducción al castellano de cursada: lean los dos. Es, más o menos, la
  respuesta a cualquier pregunta que empiece con «¿cuál de los libros…?».
]

== La velocidad angular: un número y un vector

Un cuerpo rígido gira alrededor de un eje fijo $z$. Cada punto del cuerpo
describe un círculo alrededor del eje, y todos barren el *mismo ángulo* en
el mismo tiempo: eso es lo que significa que el cuerpo sea rígido. Así que
alcanza con un solo ángulo $theta(t)$ para describir la rotación entera, y su
derivada es la velocidad angular (S&Z ec. 9.3, pág. 275):

$ omega_z = (d theta)/(d t) $ <rot-omega>

con $theta$ en *radianes*. El subíndice $z$ no es decorativo: $omega_z$ tiene
signo —positivo si el cuerpo gira antihorario visto desde la punta del eje
$z$, negativo al revés—, y su valor absoluto $omega$ es la *rapidez* angular.

#aparte[
  Radianes. Siempre radianes. El día que se meta un ángulo en grados en
  alguna de las fórmulas de abajo, el resultado va a salir mal por un factor
  de $57,3$ — y se va a escuchar, en plena exposición, el clásico «no, no,
  no: esto se hace así».
]

*Parte escalar y definición vectorial.* La cátedra lo marca en la lista de
temas: «hay que tener clara su parte escalar y su definición vectorial». La
escalar es $omega_z$. La vectorial es el vector $bold(omega)$ *sobre el eje de
rotación*, con módulo $omega$ y sentido dado por la regla de la mano derecha:
los dedos acompañan el giro, el pulgar marca $bold(omega)$ (S&Z Fig. 9.5,
pág. 276). Para rotación alrededor de un eje fijo las dos cosas dicen lo
mismo —$bold(omega) = omega_z thin hat(bold(k))$—; la diferencia importa
cuando el eje se mueve, y ahí el que manda es el vector.

#definicion("velocidad angular de un punto respecto de otro, a la Roederer")[
  El Roederer la define sin necesidad de cuerpo rígido: para un móvil que está
  en $bold(r)$ con velocidad $bold(v)$, visto desde un punto $O$,
  $ bold(omega) = (bold(r) times bold(v)) / r^2 $
  (Roederer §2.h, pág. 58–60). Es la velocidad lineal «de costado» dividida
  por la distancia, y apunta perpendicular al plano en el que se mueve el
  punto: el mismo vector del Sears, obtenido desde la partícula en vez de
  desde el cuerpo. Se ve de paso por qué la velocidad angular depende del
  punto desde donde se mira, cosa que para un cuerpo rígido con eje fijo no
  se nota porque todos lo miran desde el eje.
]

*De la velocidad angular a la velocidad de cada punto.* Un punto a distancia
$r$ del eje recorre un arco $s = r theta$ (S&Z ec. 9.1). Como $r$ no cambia
—cuerpo rígido—, derivar es inmediato, y derivar otra vez da la aceleración
tangencial. La radial es la centrípeta de siempre, $v^2\/r$, reescrita con
$v = r omega$ (S&Z ecs. 9.13 a 9.15, pág. 281; Fig. 9.9, pág. 280):

$ v = r omega, quad quad a_"tan" = r alpha, quad quad a_"rad" = v^2/r = omega^2 r $ <rot-v>

con $alpha = d omega_z \/ d t$ la aceleración angular. En forma vectorial,
$bold(v) = bold(omega) times bold(r)$: el producto vectorial da el módulo
$omega r sin phi$ —que es $omega$ por la distancia al *eje*— y la dirección
tangente al círculo, sin tener que pensarla.

== La energía de rotación: de ahí sale el momento de inercia

La cátedra lo dice en una línea: «el momento de inercia aparece al escribir la
energía cinética de rotación». Es literal. Nadie lo define de antemano: se
escribe la energía de un cuerpo que gira y se lo encuentra adentro.

#deduccion("por qué la energía cinética de rotación es un medio de I omega al cuadrado")[
  Se parte el cuerpo en partículas $m_i$, cada una a distancia $r_i$ del eje.
  La energía cinética total es la suma de las de cada una, y cada rapidez es
  $v_i = r_i omega$ por la @rot-v, *con el mismo $omega$ para todas*:
  $ K = sum_i 1/2 m_i v_i^2 = sum_i 1/2 m_i r_i^2 omega^2 = 1/2 underbrace((sum_i m_i r_i^2), I) thin omega^2 $
  El $omega$ sale de la suma porque es común a todo el cuerpo rígido; lo que
  queda adentro depende sólo de *cómo está repartida la masa respecto del
  eje*, no del movimiento. Eso tiene nombre (S&Z ecs. 9.16 y 9.17, pág. 284).
]

$ I = sum_i m_i r_i^2 , quad quad K = 1/2 I omega^2 $ <rot-energia>

$I$ es a la rotación lo que la masa a la traslación: mide cuánto cuesta
ponerla en marcha. Pero con una diferencia que la masa no tiene: *depende del
eje*. La misma varilla tiene un $I$ si gira por el centro y otro, cuatro
veces más grande, si gira por la punta, porque $r_i^2$ castiga la masa lejana.

#cuidado[
  $r_i$ es la distancia de cada partícula *al eje*, no al origen. Para un
  punto en $(x, y, z)$ con el eje sobre $z$, es $sqrt(x^2 + y^2)$ — la $z$ no
  entra. Confundir las dos es el error más común en el cálculo de un $I$.
]

Para cuerpos continuos la suma pasa a integral, y los resultados de las formas
usuales están tabulados (S&Z Tabla 9.2, pág. 286). Los que más aparecen:

#align(center, table(
  columns: 2,
  align: (left, center),
  stroke: 0.4pt + luma(170),
  inset: 5pt,
  table.header([*Cuerpo (masa $M$), eje*], [*$I$*]),
  [varilla de largo $L$, eje por el centro], [$1/12 M L^2$],
  [varilla de largo $L$, eje por un extremo], [$1/3 M L^2$],
  [aro o cilindro hueco de pared delgada, radio $R$, eje de simetría], [$M R^2$],
  [cilindro o disco macizo, radio $R$, eje de simetría], [$1/2 M R^2$],
  [esfera maciza, radio $R$, eje por el centro], [$2/5 M R^2$],
  [esfera hueca de pared delgada], [$2/3 M R^2$],
))

#aparte[
  La cátedra lo dejó por escrito, en la columna de comentarios: «no hay que
  memorizar nada, sólo saber buscar». Es probablemente la única vez en la
  historia de la materia en que alguien pide expresamente que *no* se
  aprenda algo de memoria. Hay que aprovecharlo. Eso sí: «saber buscar»
  supone tener el libro abierto sobre la mesa, no perdido en algún PDF del
  Classroom entre otros cuatrocientos.
]

== Steiner: cambiar de eje sin volver a integrar

La tabla da casi siempre el $I$ respecto de un eje *por el centro de masa*. El
teorema de los ejes paralelos —el de Steiner— da el de cualquier otro eje
paralelo a ése, sin integrar de nuevo (S&Z §9.5, ec. 9.19, pág. 288):

$ I_P = I_"cm" + M d^2 $ <rot-steiner>

con $d$ la distancia entre los dos ejes.

#deduccion("por qué el término cruzado se anula")[
  Se pone el origen en el centro de masa, el eje por el cm sobre $z$ y el eje
  nuevo, paralelo, pasando por $(a, b)$, con $d^2 = a^2 + b^2$. La distancia
  al cuadrado de cada partícula al eje nuevo es $(x_i - a)^2 + (y_i - b)^2$,
  y al desarrollar:
  $ I_P = underbrace(sum_i m_i (x_i^2 + y_i^2), I_"cm") - 2 a underbrace(sum_i m_i x_i, = 0) - 2 b underbrace(sum_i m_i y_i, = 0) + (a^2 + b^2) underbrace(sum_i m_i, M) $
  Los dos términos del medio son $M x_"cm"$ y $M y_"cm"$, y son cero porque
  el origen *es* el centro de masa (módulo #M("centro-de-masa")). Ése es todo
  el teorema: el eje por el cm es el único que anula los términos cruzados, y
  por eso cualquier otro eje paralelo tiene un $I$ *mayor*.
]

Control con la tabla: la varilla por un extremo está a $d = L\/2$ del centro,
y $1/12 M L^2 + M (L\/2)^2 = (1/12 + 3/12) M L^2 = 1/3 M L^2$. Coincide. La
versión en tres dimensiones —con productos de inercia, y un tensor en lugar de
un número— está en el módulo #M("inercia").

== El torque: lo que hace girar

Una puerta no se abre empujando cerca de las bisagras, y el motivo es
geométrico: lo que hace girar no es la fuerza sino la fuerza *por su distancia
al eje*. Para una fuerza $bold(F)$ aplicada en un punto que está en $bold(r)$
respecto de $O$ (S&Z ecs. 10.2 y 10.3, pág. 305):

$ bold(tau) = bold(r) times bold(F), quad quad tau = r F sin phi = F l $ <rot-torque>

con $phi$ el ángulo entre $bold(r)$ y $bold(F)$, y $l = r sin phi$ el *brazo
de palanca*: la distancia de $O$ a la recta de acción de la fuerza. Una fuerza
aplicada en el propio $O$, o dirigida hacia él, no hace girar nada.

#geometria[
  *La regla de la mano derecha, «muy importante!!»* —así, con dos signos de
  exclamación, en la lista de la cátedra—. $bold(tau)$ es perpendicular al
  plano de $bold(r)$ y $bold(F)$: se apuntan los dedos a lo largo de
  $bold(r)$, se cierran hacia $bold(F)$, y el pulgar da $bold(tau)$ (S&Z Fig.
  10.4, pág. 305). El producto vectorial ya está en el módulo
  #M("vectores")#repaso[$bold(a) times bold(b)$ es perpendicular a los dos,
  con módulo $a b sin phi$ y sentido por la mano derecha; $bold(a) times
  bold(b) = - bold(b) times bold(a)$.]\; lo nuevo acá es que esa dirección
  *es física*: es el eje alrededor del cual la fuerza tiende a hacer girar.
]

#aparte[
  Dos signos de exclamación. En toda la lista de temas no hay otro renglón
  con dos. Sacá tus propias conclusiones sobre qué se va a preguntar. (Y si
  en la exposición te descubrís girando la mano como quien enrosca una
  lamparita: tranquilo, así se hace.)
]

== $tau = I alpha$: la segunda ley de Newton, versión rotación

#deduccion("de dónde sale que el torque sea I por alfa")[
  Sobre cada partícula $m_i$ del cuerpo, la componente tangencial de la fuerza
  neta es la que la acelera a lo largo de su círculo: $F_("tan",i) = m_i
  a_("tan",i) = m_i r_i alpha$, por la @rot-v. Su torque respecto del eje es
  esa fuerza por $r_i$ —las componentes radial y axial no hacen girar
  alrededor de $z$—:
  $ tau_(z,i) = F_("tan",i) thin r_i = m_i r_i^2 alpha $
  Se suma sobre todo el cuerpo. Los torques de las fuerzas *internas* se
  cancelan de a pares —acción y reacción, sobre la misma recta— y el
  $alpha$, común a todo el cuerpo rígido, sale de la suma (S&Z §10.2, ec.
  10.7, pág. 307):
  $ sum tau_z = (sum_i m_i r_i^2) alpha = I alpha $
]

$ sum tau_z = I alpha_z $ <rot-tau-ialfa>

*La analogía que la cátedra pide observar* —«entre la fuerza y el torque,
entre la masa y el momento de inercia y entre la aceleración lineal y la
angular»— no es una coincidencia de forma: sale de que cada punto del cuerpo
obedece la segunda ley de Newton, y la rotación es sólo esa ley sumada con el
peso $r_i^2$.

#block(breakable: false, width: 100%, align(center, table(
  columns: 3,
  align: (left, center, center),
  stroke: 0.4pt + luma(170),
  inset: 5pt,
  table.header([], [*Traslación*], [*Rotación (eje fijo)*]),
  [lo que acelera], [$F$], [$tau$],
  [la inercia], [$m$], [$I$],
  [la aceleración], [$a$], [$alpha$],
  [la ley], [$F = m a$], [$tau = I alpha$],
  [la cantidad de movimiento], [$p = m v$], [$L = I omega$],
  [la energía cinética], [$1/2 m v^2$], [$1/2 I omega^2$],
)))

*Rotación y traslación a la vez.* Un cuerpo que rueda —una rueda, un yo-yo,
un cilindro por un plano inclinado— se mueve y gira al mismo tiempo, y el
Sears lo parte en dos, que es exactamente lo que el módulo
#M("centro-de-masa") ya había hecho con el teorema del centro de masa y con
König (S&Z Figs. 10.11 y 10.12, ecs. 10.8, 10.12 y 10.13, pág. 310–313):

$ K = 1/2 M v_"cm"^2 + 1/2 I_"cm" omega^2, quad quad sum bold(F)_"ext" = M bold(a)_"cm", quad quad sum tau_z = I_"cm" alpha_z $ <rot-traslacion>

La primera es König#repaso(destino: <cm-sistema-cm>)[la energía cinética de
un sistema es la del centro de masa, $1/2 M v_"cm"^2$, más la del movimiento
*relativo* al centro de masa — que en un cuerpo rígido es pura rotación,
$1/2 I_"cm" omega^2$.]\; la segunda es el teorema del centro de masa; la
tercera es la @rot-tau-ialfa *tomada alrededor del centro de masa*, que vale
aunque ese eje se esté trasladando — siempre que no cambie de dirección.

== El momento angular de un cuerpo que gira: $L = I omega$

El momento angular de una partícula ya está en el módulo
#M("momento-angular"): $bold(L) = bold(r) times m bold(v)$. Para un cuerpo
que gira alrededor de un eje, se suma sobre las partículas. Si el cuerpo es
una placa en el plano perpendicular al eje, cada partícula tiene $bold(r)_i
perp bold(v)_i$, y su momento angular respecto del eje vale $m_i r_i v_i =
m_i r_i^2 omega$. Sumando (S&Z §10.5, ec. 10.28, pág. 318):

$ L = I omega $ <rot-l-iw>

#notacion[
  El Sears lo llama *momento angular*; la cátedra, *impulso angular*; el Beer,
  $bold(H)$. Es el mismo vector con tres nombres. Y cuando el Sears dice
  «razón de cambio», quiere decir *derivada respecto del tiempo* — aclaración
  de la propia cátedra en la lista de temas.
]

#cuidado[
  *«Ojo con esa ecuación, no es la más general»* —la cátedra, sobre la ec.
  10.28—. La @rot-l-iw, y su versión vectorial $bold(L) = I bold(omega)$,
  valen cuando el cuerpo gira alrededor de un *eje de simetría* (más en
  general, de un eje principal de inercia). Para un cuerpo cualquiera, girando
  alrededor de un eje cualquiera, $bold(L)$ y $bold(omega)$ *no son
  paralelos*: una rueda torcida sobre su eje tiene un $bold(L)$ que se sale de
  la dirección del eje y da vueltas con el cuerpo. Eso es lo que hace vibrar
  una rueda mal balanceada, y es el tema entero del módulo #M("inercia").
]

#aparte[
  «Ojo con esa ecuación, no es la más general.» Es el equivalente escrito de
  levantar una ceja en medio de una exposición. Cuando la cátedra escribe
  eso al lado de una fórmula, la fórmula va a volver en algún parcial, con
  un cuerpo asimétrico adentro, a ver quién se la aplicó igual.
]

*La ley que manda sobre todo lo demás.* Para un sistema de partículas, la
derivada del momento angular total es el torque de las fuerzas *externas*
(S&Z ec. 10.29, pág. 319):

$ sum bold(tau)_"ext" = (d bold(L))/(d t) $ <rot-tau-dl>

Es la misma ecuación de movimiento que el módulo #M("momento-angular") dedujo
para una partícula#repaso(destino: <angm-tau>)[derivando $bold(L)_O = bold(r)
times m bold(v)$: el término $bold(v) times m bold(v)$ se anula y queda
$bold(r) times sum bold(F) = sum bold(tau)_O$.], sumada sobre todas: los
torques internos se cancelan de a pares, igual que las fuerzas internas en
$sum bold(F)_"ext" = d bold(P)\/d t$. Y a diferencia de la @rot-l-iw, ésta
*sí* es general: vale para cualquier cuerpo, rígido o no, girando como sea.
La $tau = I alpha$ es un caso particular de ella —eje fijo, $I$ constante—.

== Conservación del impulso angular

Si el torque externo es cero, la @rot-tau-dl dice que $bold(L)$ no cambia.
Para un cuerpo que puede cambiar su forma —y con ella su $I$— sin que nada de
afuera lo tuerza (S&Z §10.6, ec. 10.30, pág. 321):

$ I_1 omega_1 = I_2 omega_2 $ <rot-conserva>

#ejemplo("Cualquiera puede bailar ballet (S&Z Ejemplo 10.10)")[
  Un profesor de física —así, textual, en el Sears— se para en el centro de
  una mesa giratoria sin fricción, con los brazos extendidos y una mancuerna
  de $5,0$ kg en cada mano, a $1,0$ m del eje. Gira a una vuelta cada $2,0$
  s. Pega las mancuernas al abdomen, a $0,20$ m del eje. Su propio momento de
  inercia baja de $3,0$ a $2,2$ kg·m². ¿Con qué velocidad gira al final?
  (S&Z pág. 321.)

  Cada mancuerna es una partícula y aporta $m r^2$. La mesa no hace torque
  sobre el eje vertical, así que se conserva $L_z$:
  $ I_1 = 3,0 + 2(5,0)(1,0)^2 = 13 "kg·m²", quad quad I_2 = 2,2 + 2(5,0)(0,20)^2 = 2,6 "kg·m²" $
  $ omega_2 = I_1/I_2 thin omega_1 = 13/2,6 times 0,50 "vueltas/s" = 2,5 "vueltas/s" $
  *¿Y la energía?* Con $L$ fijo, $K = L^2 \/(2 I)$, y el $I$ bajó cinco
  veces: $K$ se *quintuplica*, de $64$ J a $321$ J. No se violó nada: la
  energía extra la puso el profesor, con los músculos, al tirar de las
  mancuernas hacia adentro. El impulso angular se conserva; la energía
  cinética, no.
]

#aparte[
  Un profesor de física, girando sobre una mesita, con una mancuerna en
  cada mano, en un libro de texto de circulación mundial. Queda a criterio
  del lector a qué profesor se imagina. Lo que sí es seguro es que, si
  alguna vez lo hace en clase, no va a explicar nada: va a preguntar por qué
  giró más rápido, y va a esperar.
]

#posta[
  Si nadie te tuerce, tu $L$ es tuyo para siempre. Lo único que podés hacer
  es repartirlo distinto: juntás la masa y girás más rápido, la abrís y
  girás más lento. Es el mismo truco de la patinadora, del clavadista que
  se hace bolita y del satélite que despliega los paneles y se frena solo.
  La cuenta es siempre la misma, $I_1 omega_1 = I_2 omega_2$.
]

La conexión con lo que ya está hecho: la conservación del momento angular *de
una partícula* bajo fuerza central es la segunda ley de Kepler del módulo
#M("momento-angular"). Acá es la misma ley, para un cuerpo extendido; el
Roederer las presenta juntas, en §4.e (pág. 120).

== El giróscopo que no se cae

Ahora sí, el experimento del principio. Un volante simétrico, de masa $M$ y
momento de inercia $I$ alrededor de su eje, con el eje horizontal apoyado en
un pivote $O$ sin fricción; el centro de masa está a distancia $r$ del
pivote. Sobre él actúan sólo dos fuerzas: la normal $bold(n)$ del pivote, que
no hace torque respecto de $O$ porque está aplicada *en* $O$, y el peso
$bold(w) = M bold(g)$, aplicado en el centro de masa. El torque del peso es
horizontal y perpendicular al eje (@fig-giroscopo).

#fig([El giróscopo apoyado en un pivote. De costado: el peso hace un torque
$bold(tau) = bold(r) times bold(w)$ horizontal, que entra en la hoja. Desde
arriba: ese torque le suma a $bold(L)$ un $d bold(L)$ perpendicular, y el eje
gira un ángulo $d phi$ sin cambiar de largo. Redibujada de S&Z Figs. 10.34 y
10.35, pág. 323–324.], fig-giroscopo-pivote) <fig-giroscopo>

*Si el volante no gira*, $bold(L)$ arranca en cero, y la @rot-tau-dl dice que
en cada $d t$ aparece un $d bold(L) = bold(tau) thin d t$ en la dirección del
torque (S&Z ec. 10.32, pág. 323). El momento angular crece siempre hacia el
mismo lado: el eje gira hacia abajo, cada vez más rápido, hasta pegar contra
la mesa. Lo esperable.

*Si el volante gira*, ya hay un $bold(L)$ grande a lo largo del eje. El torque
sigue siendo el mismo, pero ahora el $d bold(L)$ que produce es
*perpendicular* a $bold(L)$. Y un cambio perpendicular a un vector le cambia
la dirección sin cambiarle el módulo. El eje no cae: *gira en el plano
horizontal*.

#posta[
  Es un movimiento circular uniforme, pero con $bold(L)$ en lugar de
  $bold(p)$. Si atás una piedra a un hilo y tirás siempre perpendicular a
  su velocidad, la piedra no se te viene encima: da vueltas. El peso tira
  del giróscopo «perpendicular a su $bold(L)$», y $bold(L)$ da vueltas. El
  Sears usa exactamente esta comparación (pág. 324), y es la que conviene
  tener a mano cuando la intuición diga que el eje *tiene* que caer.
]

#deduccion("la velocidad de precesión")[
  En un $d t$, $bold(L)$ recibe $d bold(L)$ perpendicular y gira un ángulo
  $d phi = |d bold(L)| \/ |bold(L)|$ (el panel «desde arriba» de la figura). La
  velocidad angular de precesión es la rapidez de ese giro:
  $ Omega = (d phi)/(d t) = (|d bold(L)| \/ |bold(L)|)/(d t) = tau/L $
  El torque del peso tiene módulo $tau = w r = M g r$ (el brazo es $r$, porque
  el peso es perpendicular al eje), y $L = I omega$ con $omega$ el giro del
  volante (S&Z ec. 10.33, pág. 324):
]

$ Omega = (w r)/(I omega) = (M g r)/(I omega) $ <rot-precesion>

Tres cosas que esta ecuación dice y que hay que ver con los ojos:

- *Cuanto más rápido gira el volante, más lento precesa.* Y al revés: si la
  fricción lo va frenando, la precesión *se acelera*. Es lo que se ve en un
  trompo de juguete cuando se está por caer.
- *En forma vectorial*, con $bold(Omega)$ vertical: $bold(tau) = bold(Omega)
  times bold(L)$. Es la terna $(bold(L), bold(tau), bold(Omega))$ —las tres
  mutuamente perpendiculares, en ese orden de mano derecha— que conviene
  dibujar antes de hacer cualquier cuenta: da el *sentido* de la precesión
  sin pensar. Con $bold(L)$ hacia afuera del pivote y $bold(tau)$ como en la
  figura, $bold(Omega)$ sale hacia arriba: antihorario visto desde arriba.
- *Es una aproximación.* Se supuso que todo $bold(L)$ es el del giro del
  volante; la precesión misma agrega un pedacito vertical, $~ M r^2 Omega$,
  que se despreció. Vale si $Omega lt.double omega$ —*precesión lenta*—, y
  la propia @rot-precesion garantiza eso cuando $omega$ es grande. El caso
  sin esa aproximación, con el eje inclinado, es la precesión estable del
  módulo #M("euler-giroscopo").

#cuidado[
  *El pivote hace más que sostener.* El centro de masa describe un círculo de
  radio $r$ con velocidad angular $Omega$, así que necesita una fuerza
  centrípeta horizontal $M Omega^2 r$, y la única que puede darla es la del
  pivote. La componente vertical de la fuerza del pivote es igual al peso —
  el centro de masa no sube ni baja—; la horizontal es esa centrípeta (S&Z
  pág. 324). Si el enunciado pide «la fuerza hacia arriba» que hace el
  pivote, es el peso; si pide *la* fuerza, son las dos.
]

#aparte[
  Si a esta altura el giróscopo todavía parece brujería, no hay de qué
  preocuparse: el Sears también lo dice. La diferencia entre la brujería y
  la física es que la física deja calcular cuánto tarda en dar la vuelta.
  Que es lo que sigue.
]

#ejemplo("El giróscopo del Sears: cuánto gira la rueda (S&Z Ejemplo 10.13)")[
  Una rueda de giróscopo, cilindro macizo de radio $R = 3,0$ cm, con el
  pivote $O$ a $r = 2,0$ cm de su centro de masa y la masa del eje
  despreciable. Vista desde arriba: el centro de masa está a la derecha del
  pivote y el giro de la rueda hace que $bold(omega)$ —y con él $bold(L)$—
  apunte *hacia el pivote*, hacia la izquierda. La precesión da una vuelta
  cada $4,0$ s. (a) ¿Horaria o antihoraria, vista desde arriba? (b) ¿Con qué
  rapidez angular gira la rueda? (S&Z pág. 325.)

  *(a) El sentido, con la terna.* Con $x$ a la derecha, $y$ hacia arriba en
  la hoja y $z$ saliendo de la hoja: $bold(r) = r hat(bold(x))$, $bold(w) = -
  M g hat(bold(z))$, así que
  $ bold(tau) = r hat(bold(x)) times (- M g hat(bold(z))) = - M g r thin (hat(bold(x)) times hat(bold(z))) = + M g r thin hat(bold(y)) $
  El torque apunta hacia arriba de la hoja, y $bold(L) = - L hat(bold(x))$.
  Sumarle a $- L hat(bold(x))$ un poquito de $+ hat(bold(y))$ lo hace girar
  desde los $180°$ hacia los $90°$: el ángulo *disminuye*, así que la
  precesión es *horaria* vista desde arriba. Control con $bold(tau) =
  bold(Omega) times bold(L)$: hace falta $bold(Omega) = - Omega hat(bold(z))$,
  porque $(- hat(bold(z))) times (- hat(bold(x))) = hat(bold(z)) times
  hat(bold(x)) = hat(bold(y))$. $bold(Omega)$ entra en la hoja: horario.
  Coincide con el libro.

  *(b) La rapidez de la rueda.* $Omega = 2 pi \/ (4,0 "s") = 1,571$ rad/s, y
  para un cilindro macizo $I = 1/2 M R^2$. Despejando $omega$ de la
  @rot-precesion:
  $ omega = (M g r)/(I Omega) = (M g r)/(1/2 M R^2 Omega) = (2 g r)/(R^2 Omega) = (2 (9,8)(0,020))/((0,030)^2 (1,571)) "rad/s" = 277 "rad/s" $
  o sea unas $2,6 times 10^3$ rpm. (El libro redondea a $280$ rad/s, con dos
  cifras significativas.) Control de la aproximación: $Omega\/omega = 1,571
  \/ 277 = 0,57 %$. Precesión lenta, como se supuso.

  #clave[
    *La masa se canceló.* El torque es proporcional a $M$ y el momento
    angular también, así que si se duplica la masa del volante sin tocar
    nada más, la precesión *no se entera*. Es la pregunta de «Evalúe su
    comprensión» con que el Sears cierra §10.7 (pág. 325): la respuesta es
    la (iii), $Omega$ no cambia.
  ]
]

#ejemplo("El giróscopo de juguete de la guía (S&Z 10.51)", nivel: "a fondo")[
  *Enunciado (guía de la cátedra, Conservación de impulso angular).* El rotor
  de un giróscopo de juguete tiene masa $0,140$ kg y momento de inercia $I =
  1,20 times 10^(-4)$ kg·m² alrededor de su eje. El marco pesa $0,0250$ kg. El
  giróscopo se apoya en un solo pivote, con su centro de masa a $4,00$ cm
  horizontales del pivote, y precesa en un plano horizontal a razón de una
  vuelta cada $2,20$ s. (a) La fuerza hacia arriba que ejerce el pivote. (b)
  La rapidez angular del rotor, en rpm. (c) El diagrama con $bold(L)$ y
  $bold(tau)$.

  *El planteo, antes de la primera cuenta.* Es exactamente el giróscopo de la
  @fig-giroscopo: el pivote es el vértice del poste, el eje del rotor está
  horizontal y el marco gira junto con él en la precesión —pero *no* gira con
  el rotor sobre el eje, así que no aporta momento angular de giro—. Dos
  preguntas que conviene separar: *qué pesa* (el rotor *y* el marco: el
  centro de masa de $4,00$ cm es el del conjunto), y *qué gira rápido* (sólo
  el rotor: el $I$ que va en $L = I omega$ es el suyo).

  *(a) La fuerza del pivote.* El centro de masa no sube ni baja, así que la
  componente vertical de la fuerza del pivote equilibra el peso entero:
  $ n = (m_"rotor" + m_"marco") g = (0,140 + 0,0250)(9,80) "N" = (0,165)(9,80) "N" = 1,62 "N" $
  Control de la horizontal, que no se pide: $Omega = 2 pi \/ 2,20 "s" = 2,856$
  rad/s, y la centrípeta es $M Omega^2 r = (0,165)(2,856)^2 (0,0400) = 0,054$
  N, un $3 %$ del peso. Por eso el enunciado pregunta «hacia arriba»: la
  otra es chica, pero existe.

  *(b) La rapidez del rotor.* El torque del peso respecto del pivote:
  $ tau = M g r = (1,62 "N")(0,0400 "m") = 0,0647 "N·m" $
  Despejando $omega$ de $Omega = tau \/ (I omega)$:
  $ omega = tau/(I Omega) = (0,0647)/((1,20 times 10^(-4))(2,856)) "rad/s" = 189 "rad/s" $
  y en rpm, $189 times 60 \/ (2 pi) = 1,80 times 10^3$ rpm. Control de la
  aproximación: $Omega \/ omega = 2,856 \/ 189 = 1,5 %$. Precesión lenta:
  la @rot-precesion vale.

  *(c) El diagrama.* $bold(L)$ va sobre el eje del rotor, en el sentido que
  dé la mano derecha con el giro del rotor. $bold(tau) = bold(r) times
  bold(w)$ es horizontal y perpendicular al eje —con $bold(r)$ del pivote al
  centro de masa y $bold(w)$ hacia abajo—, y es hacia donde se está moviendo
  la punta de $bold(L)$. Es el panel «desde arriba» de la @fig-giroscopo, con
  los números de este problema.

  #clave[
    La trampa del problema es el marco: *pesa* y por eso entra en $tau$ y en
    $n$, pero *no gira sobre el eje*, y por eso no entra en $L$. Usar $0,140$
    kg en el torque da $omega = 160$ rad/s, un $15 %$ menos — y ese error no
    se nota en ningún control de unidades.
  ]
]

#aparte[
  Mirá los dos resultados juntos: $2,6 times 10^3$ rpm la rueda del libro,
  $1,8 times 10^3$ rpm el de juguete. Un taladro de mano gira a eso. Por
  eso un giróscopo de juguete zumba: no es un adorno del diseño, es la
  condición para que la precesión sea lenta y la aproximación, buena.
]

#guia("qué ejercicios cubre este módulo")[
  Los tres problemas de *Conservación de impulso angular* que la cátedra tomó
  del Sears salen enteros de acá:

  - *Problema 1 (S&Z 10.1)*, el torque de una fuerza sobre una varilla en seis
    casos: la @rot-torque, con $phi$ el ángulo entre la varilla y la fuerza.
    Los casos (e) y (f) —fuerza aplicada en $O$, y fuerza dirigida hacia $O$—
    son las dos maneras de que el torque sea cero.
  - *El problema sin número (S&Z 10.51)*, el giróscopo de juguete: resuelto
    arriba, como ejemplo a fondo.
  - *Ej. 7 (S&Z 10.53)*, los giróscopos del Hubble: $L = I omega$ con $I = m
    R^2$ (cilindro de pared delgada) y el torque que hace precesar $L$ a una
    velocidad $Omega$ dada es $tau = Omega L$ — la @rot-precesion leída al
    revés. Da $2,4 times 10^(-12)$ N·m, que es el punto del problema: así de
    poco hace falta para mover un giróscopo, y así de poco lo mueve cualquier
    perturbación.

  Los Problemas 2 a 5 son de momento angular de partícula, y están en el
  módulo #M("momento-angular").
]

== Lo que se usa después

Todo lo de este módulo supuso un eje de giro con dirección fija —salvo el
giróscopo, donde el eje se movía despacio y se lo trató con una aproximación—.
Los cuatro módulos siguientes sacan esa suposición:

- el módulo #M("cinematica-cr") describe la rotación de un cuerpo cuyo eje cambia
  todo el tiempo, y cómo se deriva un vector visto desde un sistema que gira;
- el módulo #M("inercia") muestra por qué $L = I omega$ «no es la más general»: en
  tres dimensiones $I$ es un tensor y $bold(L)$ se sale de la dirección de
  $bold(omega)$ (y ahí vuelve Steiner, @rot-steiner, en su versión completa);
- el módulo #M("euler-giroscopo") escribe $bold(tau) = d bold(L)\/d t$ en ejes que giran
  con el cuerpo y resuelve la precesión *sin* suponer que es lenta;
- el módulo #M("peonza") hace el caso en que el torque es cero y, sin embargo, el
  eje precesa igual.

Ecuaciones: @rot-omega, @rot-v, @rot-energia, @rot-steiner, @rot-torque,
@rot-tau-ialfa, @rot-traslacion, @rot-l-iw, @rot-tau-dl, @rot-conserva,
@rot-precesion.

#aparte[
  Resumen de lo que hizo este módulo: sentarse con el Sears, capítulos 9 y
  10, y seguirlo en orden. Que es, casualmente, lo que la cátedra venía
  pidiendo desde el primer día. El apunte es el mapa; el territorio sigue
  siendo el libro.
]
