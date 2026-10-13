#import "../plantilla.typ": *

#modulo(
  "El otro lado del contrato: los vehículos lanzadores",
  [Leer los requerimientos de alto nivel de un lanzador argentino (el SZ);
   leer un diagrama funcional de etapas de lanzador e identificar sus
   bloques y sus tipos de conexión; ubicar las revisiones del ciclo de vida
   de NASA en el calendario real de un lanzador; leer el perfil de misión,
   la tabla de capacidad y la operación en tierra de un lanzador comercial
   (el Falcon 9); y sacar de todo eso las *consideraciones de lanzamiento*
   que pide la sección 3 del trabajo práctico final.],
  clave: "lanzadores",
)

#lectura[
  Clase 8, diapositivas 65 a 76.
]

== Por qué un curso de satélites mira lanzadores

Un satélite pasa los primeros diez minutos de su vida adentro de otro
sistema, que lo sacude, lo calienta, le corta la energía y lo suelta en
una órbita que él no eligió del todo. El lanzador es la primera *interfaz
externa* del satélite y una de sus restricciones más duras: fija la masa
máxima, el volumen (la cofia), las cargas mecánicas y la órbita a la que se
puede llegar. La cátedra muestra cuatro: el *SZ*, el *SZS*, el *SZZS* y el
*Falcon 9* #diapo(8, 65).

== El SZ: requerimientos de alto nivel

Los requerimientos de alto nivel del SZ entran en seis renglones
#diapo(8, 66): órbita baja (LEO), *polar*, altitud de *600 km*, carga útil
de *250 kg*, *desarrollado en la Argentina*, con *sitio de lanzamiento en
la Argentina*.

#deduccion("dos de los seis no son de desempeño, y son los que más mandan")[
  Órbita, altitud y masa son requerimientos de *desempeño*. «Desarrollado en
  la Argentina» y «lanzado desde la Argentina» no lo son: son
  *restricciones*, en el sentido del Ejercicio de Alcance del módulo
  #M("verificacion-validacion-y-alcance"). No dicen qué tiene que hacer el
  lanzador sino dentro de qué límites se lo puede hacer, y descartan de
  entrada toda la familia de soluciones «comprar afuera» o «lanzar desde
  un sitio ecuatorial». Una restricción bien escrita poda el espacio de
  diseño más que diez requerimientos de desempeño.
]

#cuidado[
  La lámina rotulada «Vehículo Lanzador Espacial SZ — Cofia»
  #diapo(8, 67) muestra, según su propio epígrafe, las dimensiones de la
  cofia del *Falcon 1 y Falcon 1e*. Sirve igual para lo que se quiere
  mostrar —el «volumen de carga útil» es un cilindro con un cono arriba, con
  cotas— pero no es la cofia del SZ.
]

== El diagrama funcional de un lanzador

#figure(
  placement: auto,
  image("../figuras/c08-p068.png", width: 80%),
  caption: [Diagrama funcional de las etapas superiores del SZ: la computadora de control de vuelo en el centro, la navegación, el sistema de radio, la gestión de salud del vehículo, el control del empuje (TVCE), los tanques, la potencia y la terminación de vuelo, con los buses de datos en colores (diapositiva 68).],
)

Las diapositivas 68 y 69 dibujan el SZ como un *diagrama funcional*, etapa
por etapa. Los bloques que aparecen, agrupados por lo que hacen:

- *pensar*: la computadora de control de vuelo (gestión de misión,
  guiado, navegación y control) y la secuenciadora de cada etapa;
- *saber dónde está*: el sistema de navegación (unidad inercial y GPS);
- *empujar y apuntar*: los tanques, la tobera y la electrónica de control
  del vector de empuje (TVCE), y el sistema de control de reacción (RCS);
- *cuidarse*: la gestión de salud del vehículo (_LV Health Management_)
  en cada etapa;
- *hablar con tierra*: telemetría, radiofaro (_beacon_), video y el sistema
  de radio;
- *poder destruirse*: el sistema de terminación de vuelo (_Flight
  Termination System_), uno por etapa;
- *separarse*: los pirotécnicos de separación de etapas, de cofia y del
  satélite;
- *alimentarse*: el sistema de potencia eléctrica de cada etapa;
- y, en la primera etapa, el *umbilical* hacia el equipo de tierra (EGSE)
  y el centro de control de lanzamiento, que se desconecta en el
  despegue #diapo(8, 69).

#posta[
  Un lanzador tiene casi los mismos subsistemas que un satélite —cerebro,
  navegación, potencia, comunicaciones, propulsión— más dos que un satélite
  no tiene: *separarse en pedazos a propósito* y *autodestruirse si se
  desvía*. El segundo es un requerimiento de seguridad de la sexta
  categoría, la de «otros» (módulo #M("familia-de-requerimientos-y-trazabilidad")):
  no hace volar mejor al cohete, protege a todos los que no están arriba.
]

== El ciclo de vida de un lanzador real

#figure(
  placement: auto,
  image("../figuras/c08-p070.png", width: 85%),
  caption: [El ciclo de vida del SZ con sus revisiones: SRR y SDR en la Fase A, PDR en la B (julio de 2000), CDR en la C (diciembre de 2001), y en la D la fabricación, la integración, el FRR y el primer lanzamiento previsto para julio de 2003 (diapositiva 70).],
)

La diapositiva 70 pone las revisiones del módulo
#M("ciclo-de-vida-y-diagrama-en-v") sobre un calendario real, con lo que
se hace en cada fase: en la *A*, el concepto de operación, la arquitectura,
la evaluación de alternativas, la simulación y el desarrollo de los
elementos críticos (propulsante, propulsores); en la *B*, el diseño
preliminar, el plan de reducción de riesgos y el plan de ensamblado,
integración y verificación; en la *C*, el diseño detallado y la
demostración de reducción de riesgo, la plataforma de lanzamiento, las
interfaces con el _spacecraft_ y la infraestructura de soporte; en la
*D*, la fabricación y la integración hasta el FRR y el vuelo.

#cuidado[
  Fijate que *las interfaces con el spacecraft* aparecen en la Fase C del
  lanzador. Para el satélite, en cambio, el lanzador es una restricción
  desde la Pre-Fase A: la masa y el volumen de cofia disponibles condicionan
  el concepto desde el primer día. Los dos sistemas tienen cada uno su
  propio ciclo de vida, y la interfaz entre ellos madura a ritmos distintos
  de cada lado. Por eso la elección del lanzador es una de las primeras
  decisiones de una misión, aunque el contrato se firme mucho después.
]

Las otras dos láminas de la serie muestran el concepto de operación de un
lanzador con primera etapa que vuelve volando a la base —el SZS, con una
figura de un estudio de la empresa SEI— y el flujo de procesamiento en tierra
de un lanzador de etapas grandes —el SZZS: recepción de los elementos,
integración vertical en el edificio de ensamblado, lanzamiento y
recuperación de los propulsores— #diapo(8, 71) #diapo(8, 72).

== El Falcon 9: perfil de misión, capacidad y operación en tierra

El módulo #M("el-alcance-en-la-practica") ya usó el Falcon 9 como ejemplo
de ConOps. La clase 8 agrega tres láminas con *números*, y son las que
sirven para el trabajo práctico.

*El perfil de misión* #diapo(8, 73), una misión de ejemplo a órbita de
transferencia geoestacionaria: despegue; máxima presión dinámica a los 82
s; corte del motor principal (MECO) a los 170 s; separación de etapas a los
175 s; encendido de la segunda etapa a los 180 s; *liberación de la cofia
a los 220 s*; primer corte de la segunda etapa a los 540 s; reencendido a
los 25,3 min, segundo corte a los 26,4 min y *separación del satélite a
los 26,9 min*.

*La capacidad*, en la misma lámina: una tabla de masa de carga útil según
la altitud de la órbita circular (de 200 a 1000 km) y la inclinación
(28,5°, 38° y 51,6°). Lee dos cosas: la capacidad *baja* cuando sube la
altitud (de 10 454 kg a 200 km y 28,5° a 8687 kg a 1000 km), y baja
*también* cuando sube la inclinación (a 200 km, de 10 454 kg con 28,5° a
9823 kg con 51,6°).

#deduccion("por qué la inclinación cuesta masa")[
  Un lanzamiento hacia el este aprovecha la velocidad de rotación de la
  Tierra, que es máxima en el ecuador y ya viene «de regalo». Una órbita
  más inclinada que la latitud del sitio obliga a desviar el lanzamiento
  del este y a regalar parte de esa velocidad, y esa diferencia se paga con
  propulsante, o sea, con carga útil. Por eso la tabla corta en 28,5°: es
  la latitud de Cabo Cañaveral, la inclinación más barata desde ahí. Una
  órbita *polar* o *heliosincrónica* —como la del LDCM, a 98°— es de las
  más caras de todas, y es la que va a pedir casi cualquier misión de
  observación de la Tierra del trabajo práctico.
]

*La primera etapa reutilizable* #diapo(8, 74): después de la separación,
la primera etapa da vuelta, enciende para volver (_boostback_), reentra
con un encendido de frenado, despliega sus aletas de grilla, hace el
encendido de aterrizaje, despliega las patas y se posa sobre un barco
dron.

*La operación en tierra* #diapo(8, 75) #diapo(8, 76): una línea de tiempo
de 16 días antes del lanzamiento, en tres carriles paralelos —el vehículo,
las instalaciones de tierra y la *carga útil*—. Del lado del satélite: su
llegada, el acople al adaptador, la verificación y la carga de
combustible, el *encapsulado en la cofia*, el traslado a la instalación de
integración y la conexión del umbilical; de por medio, un ensayo general
de la misión (_mission rehearsal_) y las revisiones de alistamiento para el
lanzamiento.

#posta[
  Para la sección «consideraciones de lanzamiento» del trabajo práctico,
  sacá de acá la lista de preguntas: ¿qué lanzador, y con qué capacidad a
  *tu* altitud y *tu* inclinación?; ¿entrás en la cofia?; ¿qué cargas te
  hace soportar en el ascenso?; ¿cuándo te separan y en qué órbita te
  dejan?; ¿qué pasa con tu satélite en los días de campaña de tierra
  (combustible, baterías, umbilical)? Si viajás de acompañante en un
  lanzamiento compartido, la órbita la elige el pasajero principal, y eso
  también es una restricción.
]
