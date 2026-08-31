#import "../plantilla.typ": *

#modulo("Centro de masa y sistemas de partículas")[
  Ubicar el centro de masa de un sistema y saber por qué está siempre más cerca
  del cuerpo pesado; usar que su movimiento no se entera de nada de lo que pasa
  adentro; pasar al *sistema centro de masa*, donde los dos impulsos son
  opuestos y un choque se ve como lo que es; y separar la energía cinética en
  la parte que el choque puede disipar y la que no.
]

El módulo anterior terminó con un teorema que dice qué *no puede cambiar*. Este
lo da vuelta y pregunta qué punto del sistema es el que se comporta como si
nada estuviera pasando. Ese punto es el centro de masa, y en mecánica orbital es
mucho más que una curiosidad: la Tierra y la Luna orbitan el centro de masa del
par, no la una a la otra, y el problema de dos cuerpos del módulo 8 se resuelve
mudándose justamente a ese punto.

== El centro de masa

Para $N$ partículas de masas $m_i$ en posiciones $bold(r)_i$, con
$M = sum m_i$:

$ bold(r)_"cm" = (sum_i m_i bold(r)_i) / (sum_i m_i) = 1/M sum_i m_i bold(r)_i $ <m3-def>

(S&Z §8.5, ecs. 8.28 y 8.29, pág. 254-255; Roederer ec. 4.3, pág. 110.) Es un
promedio de posiciones *pesado por las masas*: cada partícula tira del punto
hacia sí con una fuerza proporcional a lo que pesa.

#deduccion("por qué el CM está sobre la recta que une los dos cuerpos")[
  Con dos masas, la @m3-def se puede escribir como una combinación de
  $bold(r)_1$ y $bold(r)_2$ con coeficientes que suman 1:
  $ bold(r)_"cm" = mu_1 bold(r)_1 + mu_2 bold(r)_2, quad
    mu_1 = m_1 / M, quad mu_2 = m_2 / M, quad mu_1 + mu_2 = 1 $
  Una combinación de dos puntos con pesos positivos que suman 1 es, por
  definición, un punto *del segmento* que los une. Y midiendo las distancias
  $d_1 = abs(bold(r)_"cm" - bold(r)_1)$ y $d_2 = abs(bold(r)_2 - bold(r)_"cm")$
  sale (Roederer, pág. 111):
  $ d_1 / d_2 = m_2 / m_1 $
  *La razón es la inversa de las masas*: el centro de masa está siempre más
  cerca del más pesado. Es exactamente lo que la cátedra remarcó — «el CM está
  en la línea que une los dos cuerpos».
]

#fig([El centro de masa de dos cuerpos: sobre la recta que los une, y a
distancias inversamente proporcionales a las masas.], fig-cm-dos-cuerpos)

#notacion[
  *Roederer llama «masas reducidas» a esos $mu_1$ y $mu_2$* (pág. 110), y no lo
  son en el sentido que el resto de la bibliografía —y el apunte manuscrito de
  la cátedra— le da a esa palabra. La *masa reducida* del problema de dos
  cuerpos, la que aparece en el módulo 8, es otra cosa:
  $ mu = (m_1 m_2) / (m_1 + m_2) $
  y tiene unidades de masa, mientras que las de Roederer son números sin
  dimensión entre 0 y 1. El propio Roederer avisa además que no hay que
  confundir su $mu$ con la masa gravitatoria $mu = G M$ de la astrodinámica —
  que es una *tercera* cosa con la misma letra, y la que más se va a usar de
  la Parte III en adelante.
]

== El teorema del centro de masa

Acá está el motivo por el que el punto vale la pena.

#deduccion("el CM se mueve como si toda la masa estuviera ahí")[
  Derivando la @m3-def respecto del tiempo y multiplicando por $M$:
  $ M bold(v)_"cm" = sum_i m_i bold(v)_i = bold(P) $ <m3-p>
  o sea: *la cantidad de movimiento total del sistema es la de una única
  partícula de masa $M$ que se moviera con el centro de masa* (S&Z ecs. 8.31 y
  8.32, pág. 256). Derivando otra vez y usando el resultado del módulo 2 —que
  las internas se cancelan de a pares—:
  $ sum bold(F)_"ext" = M bold(a)_"cm" $ <m3-teorema>
  (S&Z ecs. 8.34 y 8.36, pág. 258.)
]

Las dos ecuaciones dicen lo mismo desde dos lados, y la consecuencia es fuerte:

#clave[
  *El centro de masa no se entera de lo que pasa adentro.* Si la resultante
  externa es nula, $bold(v)_"cm"$ es constante — pase lo que pase entre las
  partes: choques, explosiones, motores, resortes.

  La figura 8.32 de S&Z (pág. 257), que la cátedra marcó, es la imagen que hay
  que recordar: un obús estalla en pleno vuelo, y el centro de masa de los
  fragmentos *sigue la misma parábola* que traía el obús entero. La explosión
  es interna; la gravedad, que sí es externa, no se enteró de nada.
]

== El sistema centro de masa <m3-sistema-cm>

Como $bold(v)_"cm"$ es constante cuando no hay externas, el sistema de
referencia que se mueve con el centro de masa es *inercial* —lo dijo la
cátedra, y está en Roederer pág. 111— y se llega a él con una transformación de
Galileo: a cada velocidad se le resta $bold(v)_"cm"$.

$ bold(v)^* = bold(v) - bold(v)_"cm" $

#clave[
  En ese sistema, por la @m3-p, $bold(P)^* = M bold(v)^*_"cm" = bold(0)$: la
  cantidad de movimiento total es *cero*. Con dos cuerpos eso significa
  $ bold(p)^*_1 = -bold(p)^*_2 quad "en todo momento, antes y después" $
  Un choque visto desde ahí es simétrico: dos impulsos opuestos que entran, dos
  impulsos opuestos que salen. Todo el choque se reduce a *cuánto giraron* y
  *cuánto se acortaron*.
]

#geometria[
  «El sistema centro de masa es inercial» tiene una condición escondida:
  $bold(v)_"cm"$ tiene que ser *constante*. Si hay fuerzas externas netas —un
  choque en presencia de gravedad, mirado en escala de segundos y no de
  milisegundos— el CM acelera y su sistema deja de ser inercial: aparecen
  fuerzas de inercia y nada de lo de arriba vale tal cual. En un choque eso no
  molesta, porque dura poco; en una órbita sí, y es la razón por la que el
  módulo 8 tiene que trabajar con la masa reducida en lugar de simplemente
  «pararse en el centro de masa».
]

== La energía cinética se parte en dos

#deduccion("el teorema de König")[
  Escribiendo cada velocidad como $bold(v)_i = bold(v)_"cm" + bold(v)^*_i$:
  $ K = sum_i 1/2 m_i abs(bold(v)_i)^2
      = sum_i 1/2 m_i (abs(bold(v)_"cm")^2 + 2 bold(v)_"cm" dot bold(v)^*_i + abs(bold(v)^*_i)^2) $
  El término del medio lleva $bold(v)_"cm" dot sum_i m_i bold(v)^*_i$, y esa
  suma es $bold(P)^* = bold(0)$: se va entero. Quedan dos términos:
  $ K = underbrace(1/2 M abs(bold(v)_"cm")^2, "del movimiento del conjunto")
      + underbrace(K^*, "del movimiento interno") $
]

#clave[
  De los dos términos, *el primero es intocable*: depende sólo de $bold(P)$, que
  se conserva. Un choque puede disipar, como mucho, el segundo — y lo disipa
  entero si los cuerpos quedan pegados, que es exactamente lo que define al
  choque perfectamente inelástico.

  Por eso la fracción de energía que un choque disipa se puede medir contra dos
  cosas distintas, y conviene saber cuál se está contestando: contra la energía
  cinética del laboratorio, o contra $K^*$, que es la única que estaba
  disponible.
]

#ejemplo("El mismo lanzamiento, visto desde el centro de masa")[
  _(Ej. 1 de la guía, otra vez.)_ La astronauta de $68,5$ kg y su herramienta de
  $2,25$ kg. *(a)* Rehacer el cálculo desde el centro de masa. *(b)* Diez
  segundos después, ¿a qué distancia está cada uno del CM?

  *(a)* Antes de soltar la herramienta el conjunto está en reposo, así que
  $bold(P) = bold(0)$ y, por la @m3-p, $bold(v)_"cm" = bold(0)$. No hay fuerzas
  externas: *el centro de masa se queda donde está, para siempre*. Y si el CM
  no se mueve, la condición $mu_1 v_1 + mu_2 v_2 = 0$ da directamente
  $ v_a = -(m_h) / (m_a) v_h = -(2,25) / (68,5) dot 3,20 = -0,105 " m/s" $
  El mismo resultado del módulo 2, con la diferencia de que acá no hizo falta
  escribir ninguna ecuación de conservación: *ya estaba escrita en el punto*.

  *(b)* En 10 s la separación entre los dos es
  $(3,20 + 0,105) dot 10 = 33,05$ m. El CM la reparte con la razón inversa de
  las masas:
  $ d_a = 33,05 dot (2,25) / (70,75) = 1,05 " m", quad
    d_h = 33,05 dot (68,5) / (70,75) = 32,0 " m" $
  Control: la astronauta se movió $0,105 dot 10 = 1,05$ m y la herramienta
  $3,20 dot 10 = 32,0$ m. #sym.checkmark Cierra, y muestra lo que la razón
  $d_1 \/ d_2 = m_2 \/ m_1$ significa en la práctica: el cuerpo pesado casi no
  se corre.
]

#ejemplo("Los asteroides, ahora desde el centro de masa", nivel: "a fondo")[
  _(Ej. 2 de la guía, revisitado.)_ El mismo choque del módulo 2: dos
  asteroides de igual masa $m$, uno a #box[$40,0$ m/s] y el otro en reposo, que salen
  a $30,0degree$ y $45,0degree$ con rapideces $29,28$ y $20,71$ m/s.
  Rehacerlo en el sistema centro de masa y separar la energía disipada de la
  que no se podía disipar.

  #v(4pt)
  #fig-choque-cm
  #v(4pt)

  *Paso 1 — la velocidad del centro de masa.* Por la @m3-p, con $M = 2m$:
  $ bold(v)_"cm" = (m dot 40,0 + m dot 0) / (2m) = 20,0 " m/s" quad "en" hat(x) $
  Con masas iguales el CM está justo en el medio y viaja a la mitad de la
  velocidad del que se mueve. Que sea constante lo garantiza el módulo 2: no
  hay externas.

  *Paso 2 — las velocidades antes, en el sistema CM.* Restando $bold(v)_"cm"$:
  $ bold(v)^*_(A 1) = (40,0 - 20,0) hat(x) = +20,0 hat(x), quad
    bold(v)^*_(B 1) = (0 - 20,0) hat(x) = -20,0 hat(x) $
  Opuestas, como tenían que ser. Toda la asimetría del enunciado —«uno viene y
  el otro está quieto»— era un efecto del sistema de referencia, no del choque.

  *Paso 3 — las velocidades después.* En cartesianas, en el laboratorio:
  $ bold(v)_(A 2) = 29,28 (cos 30degree, sin 30degree) = (25,36; 14,64) $
  $ bold(v)_(B 2) = 20,71 (cos 45degree, -sin 45degree) = (14,64; -14,64) $
  y restando $bold(v)_"cm" = (20,0; 0)$:
  $ bold(v)^*_(A 2) = (5,36; 14,64), quad bold(v)^*_(B 2) = (-5,36; -14,64) $

  *El control que cierra el problema.* Los dos vectores son *exactamente
  opuestos*, y los dos tienen módulo
  $ abs(bold(v)^*_2)^2 = 5,36^2 + 14,64^2 = 243,1 quad ==> quad abs(bold(v)^*_2) = 15,59 " m/s" $
  Eso no se impuso en ningún paso: salió solo, y es la prueba de que las
  rapideces del módulo 2 están bien. #sym.checkmark Si no hubieran dado
  opuestas, habría un error aritmético en aquel resultado.

  El ángulo que giraron es
  $theta^*$, con $tan theta^* = 14,64 \/ 5,36$, vale $69,9degree$: en el sistema centro de masa
  *el choque entero es una rotación de los dos impulsos, más un acortamiento*
  ($20,0 -> 15,59$).

  *Paso 4 — la energía, separada en dos.* Con $M = 2m$:
  $ K_"cm" = 1/2 (2m) (20,0)^2 = 400 m quad "(intocable)" $
  $ K^*_1 = 2 dot 1/2 m (20,0)^2 = 400 m, quad
    K^*_2 = 2 dot 1/2 m (15,59)^2 = 243 m $
  Control de König: $400 m + 400 m = 800 m$ antes, y
  $400 m + 243 m = 643 m$ después — los mismos dos números del módulo 2.
  #sym.checkmark

  *Lo disipado*: $400 m - 243 m = 157 m$, *idéntico* a $800 m - 643 m$ del
  laboratorio. La energía disipada no depende del sistema de referencia — lo que
  sí depende es contra qué se la compara:
  $ (157) / (800) = 19,6% "de la energía del laboratorio", quad
    (157) / (400) = 39,2% "de la que se podía disipar" $

  #clave[
    Los $400 m$ del movimiento del conjunto no estaban disponibles para
    disiparse *bajo ninguna circunstancia*: la conservación de $bold(P)$ los
    protege. Un choque perfectamente inelástico de estos dos asteroides habría
    disipado los $400 m$ de $K^*$ enteros —el máximo posible— y los dos habrían
    seguido pegados a $20,0$ m/s. Preguntarse «¿cuánta energía *puede* perder
    este choque?» es preguntarse cuánto vale $K^*$.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  *La guía no trae un ejercicio propio de centro de masa*, y no es un olvido:
  el CM aparece en la guía como herramienta, no como tema. Por eso los dos
  ejemplos de arriba son los ejercicios *1* y *2* de la sección de cantidad de
  movimiento resueltos otra vez desde el centro de masa. Vale la pena hacerlo
  así: en el parcial el CM no se pide, se *usa*, y el que lo usa resuelve el
  Ej. 1 en un renglón y controla el Ej. 2 sin volver a plantear nada.

  El material de la cátedra para este tema es S&Z §8.5 y §8.6 (con la fig. 8.32)
  y Roederer cap. 4, pág. 110-111.
]

== Lo que se usa después

1. *$bold(P) = M bold(v)_"cm"$ y $sum bold(F)_"ext" = M bold(a)_"cm"$.* En el
   módulo 4 son lo que permite tratar al cohete entero —chapa, tanque y gas—
   como un solo sistema cerrado mientras adentro pasa de todo.

2. *El sistema centro de masa.* En el módulo 8 deja de ser una comodidad y pasa
   a ser el planteo: el problema de dos cuerpos se convierte en el de *uno solo*
   de masa $mu = m_1 m_2 \/ (m_1 + m_2)$ moviéndose alrededor del centro de masa
   fijo. Todo lo que la Parte III dice de «un satélite alrededor de la Tierra»
   es, en rigor, eso.

3. *La partición de König.* Reaparece entera en el módulo 13, con la energía
   cinética de un cuerpo rígido partida en traslación del CM más rotación
   alrededor del CM (Beer ec. 14.29). Es la misma cuenta con otra letra.
