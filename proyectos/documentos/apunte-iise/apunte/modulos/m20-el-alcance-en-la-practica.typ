#import "../plantilla.typ": *

#modulo(
  "El alcance en la práctica: el Ejercicio de Alcance y seis ConOps reales",
  [Aplicar el Ejercicio de Alcance a una necesidad científica real (¿fue
   Marte habitable?) para ver cómo se desciende de necesidad a misión; y
   recorrer seis Conceptos de Operación reales —Space Shuttle, Falcon 9,
   Curiosity, un satélite meteorológico, una misión tripulada a Marte y una
   misión a un asteroide— para ver la misma estructura aplicada una y otra
   vez.],
  clave: "el-alcance-en-la-practica",
)

#lectura[
  Clase 6, diapositivas 14 a 67.
]

== El Ejercicio de Alcance

#posta[
  La unidad 5 ya definió cada elemento del alcance por separado. Esta clase
  no agrega elementos nuevos: le pone nombre a la *estructura completa* — el
  *Ejercicio de Alcance*— y la recorre con un caso científico real, de punta
  a punta.
]

#clave[
  El Ejercicio de Alcance existe porque los interesados científicos y los
  ingenieros hablan lenguajes distintos: *"los científicos tienen ideas, y
  los ingenieros hacen que esas ideas se hagan prácticas."* Es la estructura
  que traduce una pregunta científica —a veces literalmente inconmensurable—
  en algo que se puede diseñar, construir y operar.
]

=== Caso: ¿fue Marte habitable?

#ejemplo("de una pregunta científica a una misión, paso a paso", nivel: "a-fondo")[
  - *Necesidad:* la NASA se pregunta hace años si Marte es o fue habitable.
  - *Meta:* explorar Marte y encontrar si fue habitable — concretamente, si
    hubo agua.
  - *Objetivo:* buscar en un área de Marte con signos de agua, como los
    cañones de los Valles Kanei, formados por erosión hídrica.
  - *Hipótesis:* incluye el nivel de tecnología disponible —por ejemplo, la
    sensibilidad de cierto instrumento— y las asociaciones con otras
    misiones.
  - *Misión:* poner un rover en un valle con vestigios de agua, para
    recorrer terreno y analizar muestras en el lugar.
  - *ConOps:* aterrizar, recorrer los territorios elegidos, recabar
    información y enviarla a la Tierra.
  - *Restricciones:* presupuestarias (desde 200 millones hasta varios miles
    de millones de dólares, según la misión) y de ventana de lanzamiento —
    perder la ventana óptima a Marte cuesta esperar 18 meses más.
  - *Autoridad y responsabilidad:* líneas claras sobre quién construye el
    vehículo, quién es responsable de los instrumentos de carga útil, y
    quién dirige la ingeniería de sistemas.
]

#deduccion("por qué el orden importa")[
  Cada elemento *acota* al siguiente: la necesidad (¿fue Marte habitable?)
  es demasiado amplia para diseñar nada; la meta (encontrar agua) ya sugiere
  dónde mirar; el objetivo (los Valles Kanei) ya es un lugar concreto; y
  recién ahí la misión puede especificar un *producto* —un rover— que
  realice ese objetivo. Saltear pasos deja un vehículo diseñado para una
  necesidad demasiado vaga para verificar.
]

== Seis Conceptos de Operación reales

#posta[
  La unidad 5 ya definió #t[concepto de operación (ConOps)] con el ejemplo
  del CEV. Acá van seis casos más, para ver la misma herramienta aplicada a
  sistemas muy distintos entre sí.
]

=== 1. Space Shuttle: del pad al espacio, y la física de volver

El ConOps del Shuttle no es sólo el vuelo: empieza con el *procesamiento en
tierra* (limpieza e inspección post-misión, reconstrucción de partes) y el
transporte al pad en una plataforma tractora, y sigue con los boosters
sólidos recuperables cayendo al mar y el tanque externo no recuperable
desprendiéndose a los ocho minutos de vuelo.

#ejemplo("el corredor de reentrada, con números", nivel: "a-fondo")[
  Reentrar a la atmósfera es un problema de ángulo. Si el ángulo es *muy
  cerrado*, la nave rebota en las capas altas y sale disparada de vuelta al
  espacio — "como una piedra haciendo patito en el agua". Si es *muy
  abierto*, el exceso de fricción desintegra la nave. El corredor real:
  *6,2° de incidencia, con apenas 0,7° de margen a cada lado.*
]

#figure(
  image("../figuras/c06-p053.png", width: 60%),
  caption: [Simulación del vehículo a Mach 2,46 y 20.116 m — el color muestra el coeficiente de fricción superficial durante la reentrada.],
)

#clave[
  El ConOps del Shuttle también definía *cuatro tipos de aborto intacto*:
  retorno al sitio de lanzamiento, aborto transatlántico, aborto tras una
  vuelta completa, y aborto desde cualquier órbita. Ningún requerimiento de
  aborto sale de la física del vuelo nominal — sale de *pensar el ConOps
  hasta el peor día posible*, la misma idea de "estar siempre listo para un
  mal día" que ya apareció en el margen de la unidad 5.
]

=== 2, 3. Falcon 9 y Curiosity: mismo ConOps, otro objeto

El material de la cátedra sobre el Falcon 9 es sobre todo gráfico —una
secuencia fotográfica del lanzamiento, la separación de la primera etapa y
su aterrizaje— y no agrega vocabulario nuevo: es el mismo tipo de cuadro de
fases que ya se vio, aplicado a un lanzador reusable moderno. El caso de
Curiosity es más puntual: antes del lanzamiento, el rover se encapsula
dentro de la *cofia* (_fairing_) del vehículo lanzador en una sala limpia
(_clean room_) — un paso de integración que también es, en sí mismo, parte
del ConOps.

=== 4. Un satélite meteorológico: el segmento de tierra es la mitad del problema

#deduccion("por qué el ConOps de un satélite no termina en el satélite")[
  El caso NOAA/NASA de observación meteorológica en órbita baja (LEO)
  muestra algo que un ConOps centrado sólo en el *spacecraft* se pierde: la
  complejidad está en el *segmento de tierra*. Un satélite LEO polar tiene
  visibilidad de 10 a 15 minutos por estación de paso — hacen falta entre
  15 y 20 antenas distribuidas por el mundo para lograr cobertura global y
  bajar los datos casi en tiempo real, antes de que la memoria limitada del
  satélite se llene.
]

#clave[
  Es la misma lección de la interfaz Módulo de Comando – Módulo Lunar de la
  unidad 5: construir cada segmento por separado no muestra la dimensión
  real del problema. Un sistema espacial completo *siempre* incluye su
  segmento de tierra, y el ConOps tiene que cubrir los dos.
]

=== 5. Una misión tripulada a Marte: de punta a punta, con muchas piezas

Una misión tripulada a Marte —aterrizaje, estadía de un año, retorno—
necesita *varios lanzadores* para poner en órbita terrestre toda la carga
y la tripulación antes de partir, que después tienen que *juntarse* para el
viaje. El ConOps acá cumple dos funciones a la vez: muestra la arquitectura
completa del conjunto de vehículos, y permite preguntar si hay un diseño
más simple —con menos lanzadores, menos combustible— sin perder de vista
ninguna fase, desde la puesta en órbita hasta el regreso.

=== 6. Una misión a un asteroide

El mismo tipo de cuadro de punta a punta se usa para un viaje de ida y
vuelta a un asteroide: el ConOps recorre el trayecto completo, no sólo el
encuentro con el objetivo.

== La dinámica de traducir necesidades en requerimientos

#posta[
  La cátedra usa un ejercicio de clase para vivir esta tensión: a un grupo
  se le reparten tarjetas con necesidades —parciales, y distintas entre
  sí— que sólo pueden *describir por su funcionalidad*, sin nombrar el
  producto. El otro grupo, en el rol de ingeniero, tiene que plasmar esas
  necesidades como requerimientos escritos. Es una puesta en escena de la
  cita de Gentry Lee de la unidad 5: los requerimientos son una
  *traducción* del lenguaje del cliente, y esa traducción es trabajo del
  ingeniero, no del cliente.
]
