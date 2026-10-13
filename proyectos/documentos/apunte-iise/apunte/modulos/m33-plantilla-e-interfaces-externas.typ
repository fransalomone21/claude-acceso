#import "../plantilla.typ": *

#modulo(
  "La plantilla de requerimientos y las interfaces del satélite con su lanzador",
  [Llenar la plantilla de requerimientos de la cátedra campo por campo, y
   explicar para qué sirve cada uno (origen, verificación, satisfacción,
   costo, riesgo, conflictos, rationale, historia, aprobaciones);
   reconocer las interfaces externas de un satélite con su lanzador
   —estructura de empuje, adaptador, cofia— y qué cambia cuando el satélite
   viaja como carga útil secundaria o en un lanzamiento compartido.],
  clave: "plantilla-e-interfaces-externas",
)

#lectura[
  Clase 9, diapositivas 3 a 8.
]

== Dos repasos antes de la Fase B

La clase 9 arranca con dos piezas que no son de la Fase B pero que la Fase
B usa todo el tiempo: una *plantilla* para escribir cada requerimiento con
todo lo que lo rodea, y una serie de ejemplos de *interfaces externas* del
satélite con su lanzador. Las dos vuelven en el trabajo práctico: la
primera es el «formato» de la sección de requerimientos; la segunda,
media sección de «consideraciones de lanzamiento».

== La plantilla de requerimientos

#figure(
  placement: auto,
  image("../figuras/c09-p003.png", width: 82%),
  caption: [La plantilla de definición de requerimientos de la cátedra (diapositiva 3).],
)

La cátedra la presenta como una plantilla «que ayuda a capturar las
técnicas de verificación, rationale, significado y la trazabilidad»
#diapo(9, 3). Campo por campo:

#figure(
  table(
    columns: (1.4fr, 2.8fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    [*Campo*], [*Qué va*],
    [ID del requerimiento], [un identificador único alfanumérico],
    [Origen], [de dónde sale: una especificación, el ConOps, etc.],
    [Requerimiento], [el enunciado],
    [Fuente y fecha], [el autor y la fecha en que se originó],
    [Verificación], [¿cómo se va a ensayar el requerimiento? En una o dos oraciones],
    [Satisfacción del cliente], [de 1 a 5: 5 = esencial tenerlo; 1 = le es indiferente],
    [Insatisfacción del cliente], [de 1 a 5: 5 = muy insatisfecho si no se implementa; 1 = no le preocupa],
    [Costo de implementación estimado], [de 1 a 5: 5 = caro de construir; 1 = barato],
    [Riesgo de implementación estimado], [de 1 a 5: 5 = riesgo muy alto; 1 = sin riesgo],
    [Requerimientos relacionados y conflictivos], [la identificación de cada uno],
    [Rationale], [la información que justifica el requerimiento],
    [Historia], [origen, cambios y supresión, si corresponde],
    [Aprobaciones], [nombre y fecha del cliente y del proveedor],
  ),
  caption: [Los campos de la plantilla, uno por uno (diapositiva 3).],
)

#deduccion("por qué la satisfacción y la insatisfacción van separadas")[
  Parecen la misma pregunta dada vuelta y no lo son. Un requerimiento
  puede ser de los que el cliente *no extraña si no está* pero *celebra si
  está* (satisfacción alta, insatisfacción baja: un lujo), o de los que
  *nadie aplaude* pero *todos reclaman si falta* (satisfacción baja,
  insatisfacción alta: lo básico que se da por sentado). Con una sola
  columna de «importancia» los dos quedarían en el medio y se podrían
  recortar igual; con dos, se ve que el segundo no se toca. Cruzadas con
  el *costo* y el *riesgo*, las cuatro columnas son la materia prima para
  decidir qué entra cuando el presupuesto aprieta.
]

#clave[
  Casi todos los campos ya aparecieron sueltos en el apunte: el «deberá» y
  las reglas de escritura (módulo #M("escribir-buenos-requerimientos")), la
  #t[rationale (de un requerimiento)], la #t[trazabilidad] al padre que
  dice el *origen*, el método de verificación. La plantilla los obliga a
  estar *juntos*, en una fila por requerimiento. La
  #t[familia de requerimientos (padres, hijos, huérfanos)] se arma después
  leyendo la columna de origen y la de relacionados.
]

#posta[
  El trabajo práctico pide «estructurar los requerimientos según el formato
  NASA», sin decir cuál. Esta plantilla es la que la cátedra mostró: usarla
  (aunque sea con menos columnas) es la apuesta más segura. Lo que no puede
  faltar en ninguna fila es el ID con su nivel, el «deberá», la
  verificación y la rationale.
]

== Las interfaces externas del satélite con el lanzador

El lanzador es la primera interfaz externa del satélite (módulo
#M("lanzadores")). La clase 9 la muestra de cerca #diapo(9, 4): el
satélite primario va arriba, dentro de la *cofia*; abajo está la *última
etapa* del lanzador, y entre los dos, la *estructura de empuje* —el
adaptador— que transmite las cargas y por la que pasan las conexiones.
La interfaz mecánica es *estándar*: la lámina marca un diámetro de 62,01
pulgadas.

#figure(
  placement: auto,
  image("../figuras/c09-p004.png", width: 72%),
  caption: [Satélite primario y cargas útiles secundarias: el anillo ESPA, montado en la estructura de empuje entre el satélite y la última etapa, lleva satélites chicos y grandes alrededor (diapositiva 4).],
)

#definicion("carga útil secundaria (y su interfaz con el lanzador)")[
  Un satélite que viaja en un lanzamiento cuyo cliente principal es otro,
  montado en la estructura de empuje entre el satélite primario y el
  lanzador —por ejemplo, en un anillo ESPA—, o en un lanzamiento
  compartido (_rideshare_).
]

Los ejemplos siguientes muestran la misma idea a distintas escalas: un
programa de nanosatélites universitarios con varias cargas secundarias
adosadas a la estructura de empuje #diapo(9, 5) #diapo(9, 6), la cofia y el
lanzamiento de un Ariane IV #diapo(9, 7), y el Falcon 9 de una misión
*Transporter*: un solo lanzamiento que junta una gran cantidad de satélites
chicos de distintos países, fabricantes y usos —_cubesats_, microsatélites,
cargas alojadas y vehículos de transferencia orbital—, que se despliegan
durante unos 30 minutos después de llegar a órbita #diapo(9, 8).

#deduccion("qué gana y qué pierde el que viaja de acompañante")[
  Gana *costo*: comparte el lanzador con otros, y para un satélite chico
  es la diferencia entre volar y no volar. Pierde *control*: la órbita, la
  fecha y las condiciones del viaje las fija el pasajero principal o el
  integrador del lanzamiento compartido. Y hereda las restricciones de
  interfaz de un adaptador estándar, que no se diseñó para él. En términos
  del triángulo de hierro, compra costo con desempeño y con calendario.
  Para una misión de trabajo práctico en órbita baja, es el escenario más
  realista, y vale escribirlo como *restricción* en el Ejercicio de
  Alcance: «el satélite deberá ser compatible con un lanzamiento
  compartido a órbita heliosincrónica», no como un detalle de la sección de
  lanzamiento.
]
