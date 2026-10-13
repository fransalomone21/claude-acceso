#import "../plantilla.typ": *

#modulo(
  "Madurez: TRL, IRL y SRL",
  [Recitar los nueve niveles de madurez tecnológica (TRL) de NASA y ubicar
   cuál es el umbral de cada fase; explicar qué mide el nivel de
   preparación para la integración (IRL) que el TRL no ve, con los cinco
   niveles de la cátedra; ubicar la integración en el diagrama en V; y no
   confundir esas dos escalas con la de madurez del sistema (SRL) del
   material de estudio, que numera distinto.],
  clave: "trl-irl-srl",
)

#lectura[
  Clase 9, diapositivas 20 a 27 y 52 a 54.
]

== Por qué medir la madurez

El módulo #M("fase-b-a-fondo") dijo que la Fase B tiene que «terminar de
madurar la tecnología». Para que esa frase sea verificable hace falta una
regla con números: ¿cuán madura está una tecnología, y cuán madura tiene
que estar? Eso es la escala TRL, y la cátedra le agrega una segunda, la
IRL, porque una tecnología madura todavía puede fallar *al juntarla con
las demás* #diapo(9, 20).

== TRL: los nueve niveles

#definicion("TRL — nivel de madurez tecnológica")[
  Escala de *9 niveles* que cuantifica la madurez de una tecnología, desde
  el conocimiento científico básico hasta su uso integrado en los productos
  de los clientes #diapo(9, 20). Al subir de nivel crece la madurez y
  *disminuye el riesgo* #diapo(9, 23).
]

#figure(
  placement: auto,
  image("../figuras/c09-p023.png", width: 85%),
  caption: [Los nueve niveles de NASA, de abajo hacia arriba, con la madurez creciente y el riesgo decreciente; a la izquierda, qué tipo de trabajo ocupa cada tramo (diapositiva 23).],
)

#figure(
  table(
    columns: (0.5fr, 2.2fr, 2.6fr),
    align: (center, left, left),
    stroke: 0.4pt + luma(180),
    [*TRL*], [*Nombre*], [*Qué se demostró*],
    [1], [Principios básicos observados y reportados], [el paso de la investigación científica a la aplicada; las herramientas son formulaciones matemáticas],
    [2], [Concepto o aplicación de la tecnología formulada], [la teoría se enfoca en una aplicación concreta; herramientas analíticas para simularla],
    [3], [Función crítica analítica y experimental: prueba de concepto], [factibilidad técnica en laboratorio, con implementaciones de _protoboard_ o _breadboard_ y datos representativos],
    [4], [Componente o subsistema validado en el laboratorio], [prototipos independientes probados; integración de elementos tecnológicos],
    [5], [Componente o _breadboard_ validado en un ambiente relevante], [el prototipo, probado a fondo en un entorno representativo, con elementos de apoyo realistas y las interfaces de destino],
    [*6*], [*Modelo o prototipo de sistema o subsistema demostrado en un ambiente relevante*], [prototipos en problemas realistas a gran escala; *viabilidad de ingeniería plenamente demostrada*],
    [7], [Prototipo del sistema demostrado en el ambiente operacional (espacial)], [a la escala del sistema operativo o cerca, con casi todas las funciones],
    [8], [Sistema real completo «calificado para vuelo»], [fin del desarrollo: integrado, con la documentación casi completa y la V&V terminada],
    [9], [Sistema real «probado en vuelo»], [demostrado en operaciones exitosas de misión],
  ),
  caption: [Los nueve TRL, con lo que pide cada uno (diapositivas 21 a 23).],
)

La lámina de NASA agrupa los niveles por el tipo de trabajo que los
produce #diapo(9, 23): investigación tecnológica básica (TRL 1-2),
investigación para probar la factibilidad (2-3), desarrollo de la
tecnología (3-5), demostración de la tecnología (5-6), desarrollo del
sistema o subsistema (6-8) y ensayo del sistema, lanzamiento y operación
(8-9). Otra lámina lo pone como la «cadena de la innovación»: la academia
cubre los primeros niveles, la industria los últimos, y en el medio está
la colaboración entre las dos #diapo(9, 24).

#deduccion("por qué el umbral de la Fase C es TRL 6, y no 5 ni 7")[
  Mirá dónde cambia la palabra clave de la tabla. Hasta TRL 5 se valida
  un *componente* (o un _breadboard_); en TRL 6 se demuestra un *modelo de
  sistema o subsistema*, en un ambiente relevante, y la tabla agrega
  «viabilidad de ingeniería plenamente demostrada». Ese es el último
  escalón que se puede subir *sin haber construido el sistema*: TRL 7 ya
  pide un prototipo en el ambiente operacional, es decir, en el espacio.
  La Fase C diseña el detalle suponiendo que cada tecnología funciona en
  su ambiente; TRL 6 es el primer nivel que lo garantiza con un ensayo, y
  el último que se puede pedir antes de volar.
]

#posta[
  Una trampa fácil para el parcial: TRL *alto* no es «tecnología nueva y
  sofisticada», es tecnología *vieja y probada*. Un panel solar que voló
  en cien satélites es TRL 9; el detector revolucionario que inventaste
  ayer es TRL 2. Y la heredad del Curiosity en el Mars 2020 (módulo
  #M("fase-a-a-fondo")) era, en el fondo, una decisión de TRL: comprar
  madurez en vez de fabricarla.
]

== IRL: lo que el TRL no ve

#definicion("integración (del sistema)")[
  El proceso de ensamblar el sistema a partir de sus componentes,
  construidos según sus requerimientos especificados; no sólo «armarlo»,
  sino lograr un sistema que funcione en el entorno para el que fue
  diseñado. Es la *pendiente ascendente* del modelo en V: empieza con la
  implementación y termina con la verificación y validación del sistema
  completo en su entorno operativo #diapo(9, 26).
]

«La integración de sistemas de vehículos no es una actividad trivial,
incluso con tecnologías de alto TRL» #diapo(9, 20). Por eso la escala
siguiente:

#definicion("IRL — nivel de preparación para la integración")[
  Escala que mide la preparación de una tecnología *para integrarse en un
  sistema determinado*, de la misma manera que el TRL mide la de cada
  componente individual. La de la cátedra tiene *5 niveles*
  #diapo(9, 27):
  + análisis conceptual del sistema completado;
  + análisis detallado del diseño del sistema completado;
  + maqueta física o prototipo del sistema sometido a un entorno de prueba
    en tierra;
  + prototipo o demostrador sometido a entornos de vuelo representativos;
  + sistema operativo fabricado, lanzamiento completado y operaciones
    comenzadas.
]

#figure(
  placement: auto,
  image("../figuras/c09-p025.png", width: 70%),
  caption: [TRL (centrado en la tecnología) al lado de IRL (centrado en el vehículo): la integración arranca cuando la tecnología ya está validada en laboratorio, y desde ahí las dos escalas avanzan juntas (diapositiva 25).],
)

#deduccion("cómo se leen las flechas entre las dos escalas")[
  La figura pone la IRL al lado de la TRL con flechas entre ellas
  #diapo(9, 25). La primera flecha, de un solo sentido, sale de TRL 4
  (validado en laboratorio) hacia IRL 1: no tiene sentido analizar cómo se
  integra algo que todavía no anda solo. De ahí para arriba las flechas
  van *en los dos sentidos*: cada nivel de integración necesita un nivel
  de madurez de la tecnología, y lo que aparece al integrar (una interfaz
  que no cierra, un calor que no estaba previsto) puede obligar a volver a
  madurar la tecnología. Esta lectura de la figura es del apunte; la
  lámina no la explica.
]

#cuidado[
  *TRL alto no implica IRL alto.* Una rueda de reacción con veinte años de
  vuelo es TRL 9 sola; en un satélite nuevo, con otra computadora, otro bus
  de datos y otra estructura, su integración puede estar en IRL 1. Es
  exactamente el problema de las interfaces de los módulos
  #M("familia-de-requerimientos-e-interfaces") y #M("el-diagrama-n2-aplicado"),
  ahora con escala.
]

== SRL: la madurez del sistema (material de estudio)

La cátedra cierra la clase con un artículo como material de estudio:
Yasseri y Bahai, sobre la estimación del *nivel de preparación del
sistema* (SRL) en sistemas de producción de petróleo y gas
#diapo(9, 52) #diapo(9, 53) #diapo(9, 54).

#definicion("SRL — nivel de preparación del sistema")[
  Escala que combina la madurez de las tecnologías y de su integración para
  medir la del *sistema* entero.
]

#figure(
  placement: auto,
  image("../figuras/c09-p052.png", width: 72%),
  caption: [El diagrama en V del artículo de Yasseri y Bahai con los TRL de su escala —de 0 a 7— puestos sobre cada nivel (diapositiva 52).],
)

El artículo pone los niveles sobre un diagrama en V #diapo(9, 52): las
necesidades del cliente en TRL 0, la arquitectura del sistema en TRL 1, la
definición de subsistemas en TRL 2-3 y, subiendo por la pendiente de
integración, la aceptación en TRL 6-7. Define TRL, IRL y SRL en una misma
tabla de *0 a 7*, agrupada en tres etapas —validación del concepto, de la
tecnología y del sistema— #diapo(9, 53), y los ubica sobre las etapas de un
proyecto: evaluar, seleccionar, definir, diseñar y fabricar, instalar,
operar y mantener #diapo(9, 54).

#cuidado[
  *Tres escalas distintas con nombres parecidos*, y no se mezclan:
  - la *TRL de NASA*, de 1 a 9 (la de las diapositivas 21 a 23);
  - la *IRL de la cátedra*, de 1 a 5 (diapositiva 27);
  - las escalas *TRL, IRL y SRL de Yasseri y Bahai*, las tres de 0 a 7 y
    pensadas para petróleo y gas (diapositivas 52 a 54).

  «TRL 6» quiere decir cosas distintas en la primera y en la tercera. Si
  el parcial dice TRL sin aclarar, es la de NASA.
]
