#import "../plantilla.typ": *

#modulo(
  "Verificación y validación a fondo, y los elementos del alcance",
  [Desarrollar a fondo la diferencia entre verificar y validar, que las
   unidades 1 y 4 dejaron prometida; y definir cada uno de los elementos del
   alcance —necesidad, meta, objetivo, misión, restricción, autoridad,
   hipótesis y ConOps— con el Crew Exploration Vehicle como ejemplo
   completo.],
  clave: "verificacion-validacion-y-alcance",
)

#lectura[
  Clase 5, diapositivas 49 a 71.
]

== Por qué esta sección estaba pendiente

#posta[
  El módulo 3 de la unidad 1 y el módulo 13 de la unidad 4 usaron la palabra
  *verificar* y la palabra *validar* con una distinción básica —¿se cumple
  el requerimiento? contra ¿el sistema satisface al interesado?— y
  prometieron desarrollarlas acá. Esta sección cumple esa promesa: no repite
  la distinción básica, la completa.
]

== Verificar

#definicion("verificación (de requerimientos)")[
  El proceso de confirmación de que un sistema está en conformidad con sus
  requerimientos: contesta la pregunta *¿el sistema encuentra sus
  requerimientos?* Confirma, además, que los requerimientos son en verdad
  verificables, e identifica qué facilidades de ensayo hacen falta.
]

#clave[
  Considerar la verificación *temprano* —no al final, cuando el sistema ya
  está construido— ayuda a entender el sistema en general: si un
  requerimiento no se puede verificar con ningún método razonable, eso dice
  algo sobre el requerimiento mismo, no sólo sobre el sistema.
]

Dos ejemplos de la cátedra, en escala opuesta: si un radio debe operar en
cierta frecuencia, se enciende en Tierra y se sintoniza esa frecuencia; si
un vehículo no debe superar cierto peso, se lo pone en una balanza. *Para
cada requerimiento tiene que existir un modo de verificarlo* — si no lo
hay, no es un requerimiento verificable.

=== Verificación ambiental: la cámara de vacío térmico

#ejemplo("verificar en las condiciones reales del espacio", nivel: "a-fondo")[
  Ciertos requerimientos —los ambientales— sólo se pueden verificar dentro
  de grandes complejos de facilidades. El Módulo de Comando del Apollo se
  verificaba dentro de una cámara de vacío térmico en el Johnson Space
  Center, con calentadores y un simulador solar que replicaban las
  condiciones del espacio: entre −150 °C y +132 °C, a una presión de
  10⁻⁵ torr. El hardware de vuelo debía soportar cinco ensayos de
  aceptación con ese perfil antes de certificarse.
]

#figure(
  image("../figuras/c05-p053.png", width: 82%),
  caption: [Una cámara de vacío térmico real de NASA: 19,8 m de diámetro por 36,6 m de altura, con una puerta de 12,2 m — la escala de la instalación que hace falta para verificar un solo tipo de requerimiento ambiental.],
)

Otro ejemplo de la cátedra, más chico en escala pero igual de exigente: un
*star tracker* se verifica poniéndolo frente a una placa con patrones de
estrellas iluminados en secuencia, para confirmar que los reconoce.

== Validar

#definicion("validación (de requerimientos)")[
  El proceso de confirmar la *completitud, la compatibilidad y la
  exactitud* de los requerimientos: contesta si están definidos
  correctamente y entendemos lo que se está intentando, y si el conjunto de
  requerimientos o especificaciones es *autoconsistente*.
]

#cuidado[
  *Verificar y validar no son la misma pregunta.* La verificación mira *un*
  requerimiento puntual contra el sistema ya construido o su modelo — ¿pesa
  lo que dice que pesa? La validación mira el *conjunto* de requerimientos
  contra la intención original de los interesados — ¿este conjunto, tomado
  entero, describe correctamente lo que hace falta? Un requerimiento puede
  verificarse perfectamente (el sistema cumple exactamente lo que dice) y el
  conjunto completo puede seguir estando mal *validado*, si lo que dice no
  era lo que hacía falta.
]

Los niveles 1, 2 y 3 de requerimientos —misión, sistema, segmento— se
especifican en la Fase A; los niveles 4, 5 y 6 —subsistema, componente,
parte— en la Fase B, ya dentro del #t[diagrama en V] de este bloque de
unidad.

== El alojamiento de requerimientos, en tres aplicaciones

El proceso completo de alojar requerimientos avanza en tres pasadas
sucesivas: la *primera aplicación* fija los límites del sistema, el ciclo de
vida aplicable y un plan de implementación de alto nivel, y produce los
requerimientos de sistema a partir de interesados y clientes. La *segunda*
descompone el sistema en funciones (concepto preliminar, mayores piezas). La
*tercera* llega a los parámetros de desempeño clave del sistema, los
subsistemas definidos y sus componentes.

#clave[
  Es la misma lógica de #t[trazabilidad] del módulo anterior, contada como
  *proceso* en vez de como *resultado*: cada aplicación agrega un nivel de
  detalle, y cada nivel se apoya en el anterior sin perder de vista el
  requerimiento de sistema del que salió todo.
]

== Los elementos del alcance

#posta[
  El módulo anterior usó el alcance completo del Apollo como ejemplo, antes
  de definir cada pieza. Acá van las definiciones, una por una — y son las
  que se preguntan sueltas en el parcial.
]

#definicion("necesidad (elemento del alcance)")[
  El elemento del que se deriva todo lo demás: relacionado con el plan
  estratégico o de negocio, explica *por qué* el proyecto desarrolla este
  sistema desde el punto de vista de los interesados. *No* es una
  definición del sistema ni de una solución, y no cambia mucho durante la
  vida del proyecto.
]

#definicion("meta (elemento del alcance)")[
  Un objetivo amplio y fundamental que la organización espera lograr para
  satisfacer una #t[necesidad (elemento del alcance)].
]

#definicion("objetivo (elemento del alcance)")[
  La expansión concreta de *cómo* se va a alcanzar una meta: las
  iniciativas que la implementan, junto con sus *criterios de éxito* — el
  mínimo que los interesados esperan del sistema para considerarlo exitoso.
]

#definicion("misión (elemento del alcance)")[
  El caso comercial —o de negocio— de por qué se necesita el producto.
  Definir y restringir la misión ayuda a identificar los requerimientos.
]

#definicion("restricción (elemento del alcance)")[
  Un elemento externo que *no se puede controlar* y que se debe cumplir
  igual, identificado al definir el alcance — casi siempre en términos de
  cronograma y presupuesto.
]

#definicion("autoridad y responsabilidad (elemento del alcance)")[
  Quién tiene la potestad sobre los distintos aspectos del desarrollo del
  sistema: un centro gubernamental, un contratista, el cliente.
]

#definicion("hipótesis (elemento del alcance)")[
  Un supuesto identificado por los interesados como parte del alcance —por
  ejemplo, que cierta tecnología necesaria va a ser alcanzable— que
  condiciona a los requerimientos que se derivan después.
]

#cuidado[
  Estos siete elementos no son sinónimos intercambiables. Un examen que pida
  "el alcance de un proyecto" espera las *siete* piezas por separado, no un
  párrafo genérico — es la misma lógica de la #t[ambigüedad] de la unidad
  3: información precisa en cada categoría, no una mezcla de todas.
]

== El Concepto de Operación (ConOps)

#definicion("concepto de operación (ConOps)")[
  Una descripción, paso a paso, de cómo el sistema propuesto va a operar e
  interactuar con sus usuarios y con sus interfaces externas durante las
  fases de la misión, para cumplir las expectativas de los interesados.
]

#clave[
  El ConOps no es un elemento más del alcance: es el que *conecta* a los
  demás con el diseño. Proporciona la perspectiva operativa, estimula
  requerimientos relacionados con el usuario, y revela funciones de diseño a
  medida que se consideran distintos casos de uso — incluyendo escenarios
  *no nominales*, no sólo el camino esperado.
]

#deduccion("el ConOps que agregó una cámara al Mars Phoenix")[
  En la misión Mars Phoenix, el ConOps de *poder ver el descenso y
  aterrizaje* agregó un requerimiento nuevo: una cámara (el *Mars Descent
  Imager*, MARDI) capaz de tomar imágenes de gran angular del sitio de
  aterrizaje desde que se desprende el aeroshell hasta la superficie. En
  operación *nominal*, esa cámara no habría sido necesaria — surgió de
  pensar el ConOps completo, no del requerimiento del día uno. Es la misma
  lógica del margen del quinto motor del Saturno V: una necesidad que
  aparece al mirar el ciclo de vida completo.
]

La información típica que trae un ConOps incluye: descripción de las fases
principales, escenarios operacionales o misiones de referencia de diseño
(*DRM*), líneas de tiempo de operación, estrategia de comunicación de punta
a punta, arquitectura de comando y datos, instalaciones operativas, soporte
logístico integrado y eventos críticos.

#figure(
  image("../figuras/c05-p070.png", width: 93%),
  caption: [Un ConOps dibujado, que es como se dibuja de verdad: la *misión de referencia de diseño* (DRM) lunar del CEV. El eje vertical son las órbitas —superficie terrestre, órbita baja, órbita lunar baja a 100 km, la Luna— y el recorrido va contando, paso a paso, qué pieza actúa y cuál se descarta: la etapa de partida (EDS) y la etapa de ascenso del módulo lunar quedan marcadas como _expended_. Ese descarte es una decisión de arquitectura, y se ve acá antes de estar escrita en ningún requerimiento #diapo(5, 70).],
)

#clave[
  Vale la pena mirar la figura dos veces, porque contesta dos preguntas
  distintas: leída de izquierda a derecha es la *línea de tiempo* de la
  misión, y leída por columnas es el *inventario de elementos* que hay que
  construir. Un ConOps que no permita las dos lecturas está incompleto.
]

== Ejemplo completo: el Crew Exploration Vehicle (CEV)

#ejemplo("los siete elementos del alcance, en un solo caso real", nivel: "a-fondo")[
  - *Necesidad:* dar acceso tripulado al espacio una vez retirado el Shuttle.
  - *Meta:* hacer el acceso al espacio más seguro y económico que el sistema vigente.
  - *Objetivo:* proveer acceso al espacio y reingreso a la Tierra para misiones a la EEI, la Luna y Marte.
  - *Misión:* soportar todas las misiones de vuelo espacial humano posteriores al Shuttle.
  - *Concepto operativo:* lanzamiento, cita, atraque, transferencia, reingreso.
  - *Hipótesis:* separación de tripulación y carga durante el lanzamiento.
  - *Restricciones:* entregar un vehículo operativo a más tardar en 2014; minimizar la brecha con el retiro del Shuttle en 2010.
  - *Autoridad y responsabilidad:* la NASA administra el CEV sin participación internacional.
]

#posta[
  Ocho líneas, siete categorías, un solo sistema. Si un examen pide "el
  alcance del CEV" y la respuesta junta todo en una sola oración, es el
  mismo error que junta *forma* y *función* en la unidad 2: dos categorías
  netamente distintas, tratadas como si fueran una.
]
