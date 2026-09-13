#import "../plantilla.typ": *

#modulo("Marcos de referencia: cuándo vale F = m a, y qué pasa cuando no", clave: "marcos")[
  Decir desde dónde se está mirando, y saber qué cambia cuando eso cambia:
  enunciar las tres leyes de Newton y reconocer que la primera no es una ley
  sino la *definición del escenario* donde valen las otras dos; deducir la
  transformación de Galileo y, con ella, que hay infinitos marcos igual de
  buenos y ninguno privilegiado; decidir, frente a un problema concreto, si el
  marco elegido es inercial o no; y escribir las correcciones que aparecen
  cuando no lo es — la de un marco que acelera en línea recta y la de uno que
  gira.
]

Todo el resto del apunte se apoya, directa o indirectamente, en una sola
ecuación: $bold(F) = m bold(a)$. Los tres teoremas de conservación salen de
ella, la órbita sale de ella y el giróscopo sale de ella. Conviene entonces
saber una cosa que casi nunca se dice en voz alta: *esa ecuación no es cierta
siempre*. Es cierta *en ciertos marcos de referencia*, y es falsa en otros.

El ejemplo lo vio todo el mundo. Un colectivo frena y el bolso que estaba
quieto en el asiento de al lado arranca solo hacia adelante. Nadie lo empujó,
no hay ninguna fuerza nueva, y sin embargo aceleró. Para el que está parado en
la vereda no pasó nada raro —el bolso siguió derecho, y lo que cambió de
velocidad fue el colectivo—, pero para el pasajero $bold(F) = m bold(a)$ acaba
de fallar adentro del colectivo.

La pregunta no es filosófica, y no se puede postergar: tres de los momentos más
delicados de lo que viene dependen de contestarla bien.

#clave[
  *Los tres lugares donde este módulo se cobra, y por qué conviene pagarlo
  ahora:*
  + El sistema centro de masa del módulo #M("centro-de-masa") es inercial
    *sólo si* $bold(v)_"cm"$ es constante. Esa condición escondida es de acá.
  + Clavar el origen «en el centro de la Tierra» —lo que hacen los módulos
    #M("gravitacion") y #M("momento-angular") sin declararlo— *no* da un marco
    inercial, y ésa es la razón entera por la que existe el módulo
    #M("dos-cuerpos") y su masa reducida.
  + El marco que gira con la Tierra y la Luna, que es el único desde el cual el
    problema de tres cuerpos se puede escribir, *no* es inercial: los dos
    términos de más que aparecen en el módulo #M("tres-cuerpos") se deducen
    acá.
]

== La idea completa, antes de la primera ecuación

Antes de escribir nada conviene tener el plan entero, porque son tres pasos y
cada uno contesta una pregunta distinta:

+ *Escribir las tres leyes, y notar que la primera no dice lo mismo que las
  otras dos.* La segunda y la tercera son afirmaciones sobre fuerzas; la
  primera es una afirmación sobre *dónde hay que pararse* para que las otras
  dos sean ciertas. Eso le da nombre al escenario: el marco inercial.

+ *Mostrar que el escenario no es uno solo.* Si un marco es inercial, todos los
  que se trasladan respecto de él con velocidad *constante* también lo son, y
  la traducción entre uno y otro es una resta. Eso es la transformación de
  Galileo, y su consecuencia —que ninguno de esos marcos es «el verdadero»— es
  la que permite elegir el más cómodo en cada problema sin pedirle permiso a
  nadie.

+ *Ver qué pasa cuando el marco no es inercial.* No se rompe todo: se puede
  seguir usando $bold(F) = m bold(a)$ a cambio de sumar, del lado de las
  fuerzas, unos términos que no son fuerzas de interacción sino el precio de
  mirar desde donde se está mirando. Hay dos casos, y son los dos que el apunte
  necesita después: el marco que acelera en línea recta, y el que gira.

#posta[
  Esto es, en criollo, «decidir desde dónde mirás antes de empezar a escribir».
  Y no es un trámite: es la decisión que hace que un problema entre en media
  carilla o no entre nunca.

  Lo que ganás es concreto. Un choque mirado desde el andén es un enredo de
  cuatro velocidades; mirado desde el centro de masa es simétrico y se resuelve
  casi de memoria (módulo #M("centro-de-masa")). El sistema Tierra–Luna mirado
  desde afuera son dos cuerpos moviéndose los dos a la vez; mirado desde el
  marco que gira con ellos, los dos están clavados, y recién ahí se puede
  escribir algo (módulo #M("tres-cuerpos")).

  A lo que te ahorrás pensar: una vez que sabés que *todos* los marcos que se
  trasladan parejo son igual de válidos, elegir el cómodo deja de ser una
  trampa y pasa a ser parte del método. La única obligación que queda es *decir
  cuál elegiste*, y no mezclar en una misma ecuación números medidos desde dos
  marcos distintos — que es el error caro de todo este tema, y el que te va a
  querer arruinar el módulo #M("esfera-influencia").
]

== Las tres leyes, y cuál de ellas no es una ley

Las tres, escritas, porque el apunte entero las usa y nunca están de más:

#definicion("las tres leyes de Newton")[
  + *Primera.* Un cuerpo libre de fuerzas de interacción permanece en reposo o
    en movimiento rectilíneo uniforme.
  + *Segunda.* $sum bold(F) = m bold(a)$ — o, en la forma que sobrevive cuando
    la masa cambia, $sum bold(F) = (d bold(p)) \/ (d t)$, que es la del módulo
    #M("cantidad-movimiento").
  + *Tercera.* Si un cuerpo ejerce $bold(F)_(1 2)$ sobre otro, el otro ejerce
    $bold(F)_(2 1) = -bold(F)_(1 2)$ sobre el primero: misma recta de acción,
    mismo módulo, sentido opuesto, *y aplicadas a cuerpos distintos*.
]

#clave[
  *La primera ley no es un caso particular de la segunda, aunque lo parezca.*
  Leída como «si $bold(F) = 0$ entonces $bold(a) = 0$» es efectivamente la
  segunda con $bold(F) = 0$, y no agregaría nada. Pero no es eso lo que dice.
  Lo que dice es que *existen* marcos de referencia en los que eso se cumple, y
  ésa es una afirmación sobre el mundo y no sobre álgebra — porque resulta ser
  falsa en casi todos los marcos que uno elegiría por comodidad.

  Dicho de una vez: la primera ley no describe el movimiento de los cuerpos.
  *Define el escenario en el que las otras dos son ciertas.*
]

#definicion("marco inercial")[
  Un *marco inercial* es un sistema de referencia en el que se cumple $bold(F)
  = m bold(a)$ con $bold(F)$ la resultante de las fuerzas de interacción y de
  las reacciones de vínculo, y nada más. Equivalentemente: uno en el que un
  cuerpo libre de interacciones se mueve en línea recta con rapidez constante.
  (Roederer, cap. 3, pág. 100.)

  No es una propiedad del cuerpo ni del problema: es una propiedad *del
  observador*. El mismo satélite, mirado desde dos lugares distintos, obedece
  la ecuación en uno y no en el otro.
]

#cuidado[
  *Ningún marco de los que se usan en la materia es exactamente inercial, y eso
  no es un problema mientras se sepa cuánto se está mintiendo.* La superficie
  de la Tierra gira; el centro de la Tierra orbita el Sol; el Sol orbita la
  galaxia. Lo que salva las cuentas es la escala: para un choque que dura
  milisegundos el laboratorio es inercial con enorme precisión; para una órbita
  de doce horas ya no lo es, y por eso existe el módulo #M("dos-cuerpos").

  La pregunta útil, entonces, nunca es «¿es inercial?», que casi siempre se
  contesta que no. Es *«¿se aparta lo suficiente como para que se note en lo
  que estoy calculando?»* — y ésa se contesta con un número.
]

== La transformación de Galileo

Si un marco es inercial, ¿cuáles otros lo son? La respuesta es la que uno
esperaría, y conviene verla salir, porque de ella cuelga el derecho a elegir
marco.

#fig([Los dos marcos de la transformación de Galileo. El marco $S'$ se traslada
respecto de $S$ con velocidad *constante* $bold(V)$, y al cabo de un tiempo $t$
su origen se corrió $bold(V) t$. Un mismo punto $P$ tiene dos vectores
posición, $bold(r)$ y $bold(r)'$, y la única diferencia entre ellos es ese
corrimiento. Los ejes no giran —$x$ y $x'$ son el mismo eje—, y por eso lo que
se resta es un vector y no una rotación.], fig-galileo)

#deduccion("la transformación de Galileo, y por qué F = m a no se entera")[
  Con $S'$ trasladándose respecto de $S$ con velocidad constante $bold(V)$, la
  posición de un mismo punto vista desde los dos orígenes se relaciona por la
  suma de vectores de la figura:
  $ bold(r) = bold(r)' + bold(r)_0 + bold(V) t $ <marcos-galileo>
  donde $bold(r)_0$ es dónde estaba $O'$ en $t = 0$. Y se le agrega lo que la
  física clásica da por evidente —que el tiempo transcurrido entre dos sucesos
  no depende del marco desde el que se lo mide—:
  $ t = t' $
  Las dos juntas son la *transformación de Galileo* (Roederer, ec. 3.23,
  pág. 101). Derivando la @marcos-galileo una vez, y otra:
  $ bold(v) = bold(v)' + bold(V), quad quad bold(a) = bold(a)' $
  porque $bold(V)$ es constante y su derivada es cero. *Las velocidades son
  distintas; las aceleraciones son las mismas.*

  Falta el paso que cierra: la fuerza tampoco cambia. Las fuerzas de la
  mecánica dependen de *distancias entre cuerpos* —la gravitación del módulo
  #M("gravitacion") depende de $abs(bold(r)_1 - bold(r)_2)$— y esa resta no se
  entera del corrimiento, porque el $bold(V) t$ se cancela al restar. Con la
  masa igual en los dos marcos:
  $ bold(F)' = bold(F) = m bold(a) = m bold(a)' $
  que es $bold(F) = m bold(a)$ otra vez, idéntica. Si $S$ era inercial, $S'$
  también lo es.
]

#clave[
  *Todo marco que se traslada con velocidad constante respecto de un marco
  inercial es también inercial, y hay infinitos.* No existe «el marco en
  reposo»: estar en reposo no es una propiedad de un cuerpo, es una relación
  entre un cuerpo y un observador.

  Eso es el *principio de relatividad* de la mecánica clásica —las leyes no
  cambian de forma al pasar de un marco inercial a otro (Roederer, pág. 101)—
  y su consecuencia práctica es la que se usa todo el tiempo: *elegir el marco
  más cómodo es gratis*, siempre que se traslade parejo.
]

#notacion[
  La transformación de Galileo es una *resta de velocidades*, no una rotación:
  los ejes de $S'$ apuntan siempre en la misma dirección que los de $S$. Un
  marco cuyos ejes *giran* no entra acá — es otra cosa, y es la última sección
  de este módulo. Confundir los dos casos es leer el resultado equivocado:
  entre marcos de Galileo la aceleración *no cambia*; entre un marco fijo y uno
  que gira, cambia, y cambia mucho.
]

== Qué sobrevive a la transformación, y qué no

Es tentador leer lo anterior como «entonces da igual», y no da igual: lo que no
cambia es la *forma de las leyes*, no el valor de las cantidades.

#cuidado[
  *La cantidad de movimiento, la energía cinética y el trabajo SÍ cambian de un
  marco inercial a otro.* $bold(p) = m bold(v)$ y $K = 1/2 m abs(bold(v))^2$ se
  calculan con la velocidad, y la velocidad cambia. S&Z lo dice con todas las
  letras al deducir el teorema trabajo–energía: vale en cualquier marco
  inercial, pero los valores de $W$ y de $K$ pueden ser distintos de un marco a
  otro (S&Z vol. 1, pág. 179).

  Lo que se conserva, se conserva *en cada marco por separado*. Si $bold(P)$ es
  constante en un choque visto desde el andén, también lo es visto desde el
  tren — con otro valor. *Lo que nunca se puede hacer es mezclar*: una ecuación
  con una velocidad medida desde un marco y otra medida desde otro no es una
  ecuación, es un error con apariencia de física.

  Ése es exactamente el error que espera agazapado en el módulo
  #M("esfera-influencia"), donde conviven una velocidad respecto del Sol y una
  respecto del planeta, y la diferencia entre las dos es el viaje entero.
]

== Cuando el marco acelera en línea recta

Sale del mismo cálculo, cambiando una sola cosa: que $bold(V)$ ya no sea
constante.

#deduccion("de dónde sale la fuerza de inercia")[
  Si el marco $S'$ acelera con $bold(A)$ respecto del inercial $S$, derivar dos
  veces la @marcos-galileo ya no mata el último término:
  $ bold(a) = bold(a)' + bold(A) $
  El observador de $S$, que sí es inercial, escribe $bold(F) = m bold(a)$. El
  de $S'$ mide $bold(a)'$, así que para él:
  $ m bold(a)' = bold(F) - m bold(A) $ <marcos-inercia>
  Ahí está el bolso del colectivo. Sobre el bolso no actúa ninguna fuerza
  horizontal —$bold(F) = bold(0)$—, pero el pasajero lo ve acelerar hacia
  adelante con $bold(a)' = -bold(A)$, que es justo lo que la @marcos-inercia
  predice cuando el colectivo frena. (Roederer, cap. 3, pág. 102.)
]

#definicion("fuerza de inercia")[
  El término $-m bold(A)$ de la @marcos-inercia es la *fuerza de inercia*. No
  es una fuerza de interacción: no la ejerce ningún cuerpo. Es el precio de
  haberse parado en un marco que acelera, escrito del lado de las fuerzas para
  poder seguir usando $bold(F) = m bold(a)$ con la forma de siempre.
]

#geometria[
  *Cómo se reconoce una fuerza de inercia, y por qué conviene saber
  reconocerla: no tiene reacción.* Toda fuerza de interacción viene de a pares
  por la tercera ley — si algo tira del bolso, el bolso tira de algo. La fuerza
  de inercia no: no hay ningún cuerpo del otro lado. Ése es el test, y es el
  que delata a un marco no inercial *desde adentro*, sin necesidad de mirar
  afuera.

  Y es también el que explica una frase que vuelve tres veces en el apunte:
  «hay que pagar términos de más». Los términos de más son siempre fuerzas de
  inercia, y aparecen exactamente cuando el marco elegido no es inercial.
]

== Cuando el marco gira

Éste es el caso que la parte de gravitación necesita, y se deduce entero con lo
que ya dio el módulo #M("vectores"): no hace falta ninguna herramienta nueva.
Se toma el caso que alcanza —movimiento en un plano, y un marco que gira con
velocidad angular $Omega$ *constante* alrededor del eje perpendicular—, que es
justo el del problema de tres cuerpos.

#deduccion("las dos correcciones de un marco que gira, desde la aceleración en polares")[
  La aceleración de una partícula en polares, deducida en el módulo
  #M("vectores") y vista desde el marco fijo:
  $ bold(a) = (dot.double(r) - r dot(theta)^2) hat(r)
            + (r dot.double(theta) + 2 dot(r) dot(theta)) hat(theta) $
  El marco que gira usa el mismo $r$ —la distancia al origen es la misma para
  los dos observadores— pero mide el ángulo desde un eje que se corrió:
  $theta' = theta - Omega t$. Derivando, y usando que $Omega$ es constante:
  $ dot(theta) = dot(theta)' + Omega, quad quad dot.double(theta) = dot.double(theta)' $
  Reemplazando arriba y agrupando según quién mide qué:
  $ bold(a) = underbrace((dot.double(r) - r dot(theta)'^2) hat(r)
              + (r dot.double(theta)' + 2 dot(r) dot(theta)') hat(theta),
              bold(a)_"rel" ", lo que mide el que gira")
            + underbrace(2 Omega (dot(r) hat(theta) - r dot(theta)' hat(r)),
              "Coriolis")
            + underbrace(-r Omega^2 hat(r), "centrífugo") $
  Los dos últimos grupos son, escritos en vectores, $2 bold(Omega) times
  bold(v)_"rel"$ y $bold(Omega) times (bold(Omega) times bold(r))$ — se
  comprueba en dos renglones poniendo $bold(Omega) = Omega hat(k)$ y
  $bold(v)_"rel" = dot(r) hat(r) + r dot(theta)' hat(theta)$. O sea:
  $ bold(a) = bold(a)_"rel" + 2 bold(Omega) times bold(v)_"rel"
            + bold(Omega) times (bold(Omega) times bold(r)) $ <marcos-rotante>
  (Beer §15.11, ec. 15.35, págs. 977–978.)
]

Pasando a fuerzas, con $bold(F) = m bold(a)$ válida en el marco fijo:

$ m bold(a)_"rel" = bold(F) - 2 m bold(Omega) times bold(v)_"rel"
                  - m bold(Omega) times (bold(Omega) times bold(r)) $ <marcos-rotante-f>

#clave[
  *Un marco que gira cuesta dos fuerzas de inercia, y son de naturalezas
  distintas:*
  - La *centrífuga*, $-m bold(Omega) times (bold(Omega) times bold(r))$,
    depende sólo de *dónde* está el cuerpo. Apunta hacia afuera, y está ahí
    aunque el cuerpo esté quieto en el marco que gira.
  - La de *Coriolis*, $-2 m bold(Omega) times bold(v)_"rel"$, depende de *cómo
    se mueve* el cuerpo respecto del marco. Si está quieto en el marco que
    gira, no existe; y es siempre perpendicular a $bold(v)_"rel"$, así que *no
    hace trabajo* — dato que en el módulo #M("tres-cuerpos") es justo el que
    permite que exista una constante de movimiento.
]

#notacion[
  El término de Coriolis ya había aparecido una vez, sin ese nombre y sin
  ningún marco que gire: es el $2 dot(r) dot(theta)$ de la aceleración en
  polares del módulo #M("vectores"). No es casualidad ni analogía — los
  versores polares *son* un marco que gira con la partícula, y por eso la
  cuenta de arriba salió sin herramientas nuevas.
]

#clave[
  *Lo de esta sección vale para $Omega$ constante y movimiento plano, y con eso
  alcanza para todo lo que este apunte hace con gravitación.* El caso general
  —tres dimensiones, y un $bold(Omega)$ que además cambia— es la cinemática del
  cuerpo rígido, y se deduce en el módulo #M("cinematica-cr"), donde aparecen
  dos términos más. La @marcos-rotante es el caso particular de aquélla, no una
  fórmula distinta.
]

== Lo que se usa después

+ *La definición de marco inercial* es la condición escondida del sistema
  centro de masa (módulo #M("centro-de-masa")) y la razón de ser del módulo
  #M("dos-cuerpos").
+ *La transformación de Galileo* es la que autoriza a pararse en el centro de
  masa para mirar un choque, y la que hace que «restarle $bold(v)_"cm"$ a
  todo» sea legítimo y no un truco.
+ *Que $bold(p)$, $K$ y $W$ cambien de marco* es lo que obliga a declarar
  siempre respecto de qué se mide una velocidad: la distinción entre velocidad
  respecto del Sol y respecto del planeta es el módulo #M("esfera-influencia")
  entero.
+ *Las dos fuerzas de inercia de un marco que gira* son las que aparecen en el
  módulo #M("tres-cuerpos"), y que Coriolis no trabaje es lo que hace que ahí
  exista la constante de Jacobi.
