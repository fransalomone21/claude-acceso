#import "../plantilla.typ": *

#modulo(
  "Arquitectura de sistemas: qué es y por qué importa",
  [Definir #t[arquitectura de sistema]; distinguir sistemas complejos de
   sistemas grandes; explicar con casos reales —NPOESS, Boeing 787— por qué
   las decisiones arquitectónicas tempranas condicionan todo lo que sigue; y
   enumerar qué hace *buena* a una arquitectura.],
  clave: "arquitectura-sistemas-intro",
)

#lectura[
  Clase 2, diapositivas 2 a 22. La fuente es _System Architecture — Strategy
  and Product Development for Complex Systems_, de Crawley, Cameron y Selva
  (MIT), el libro que da nombre a la unidad.
]

== Qué es la arquitectura de un sistema

La palabra "arquitectura" se usa hoy en campos muy distintos —una red
eléctrica, un sistema de pago móvil, una app— y en todos connota lo mismo: el
*ADN* del sistema, la base de su ventaja competitiva #diapo(2, 4). El desafío
es que la palabra tiene *límites nebulosos*: se usa tanto para una única
decisión que separa dos tipos de sistema ("arquitectura de conmutación de
paquetes" contra "de circuitos") como para una implementación casi completa
("arquitectura de servicio") #diapo(2, 8).

#definicion("arquitectura de sistema")[
  Una #t[arquitectura de sistema] es una *descripción abstracta de las
  entidades de un sistema y de las relaciones entre esas entidades*; el
  mapeo de la función a la forma a través del #t[concepto]; la asignación de
  la función física o informativa (proceso) a los elementos de la forma
  (objetos), y la definición de las interfaces estructurales entre esos
  objetos. #diapo(2, 16)
]

#clave[
  La arquitectura *no* es el diseño detallado ni todos los componentes: es el
  *conjunto de decisiones tempranas* que establece qué entidades hay y cómo se
  relacionan. Los autores lo dicen de forma directa: es más probable que un
  sistema tenga éxito si se tiene cuidado de *identificar y tomar* las
  decisiones que la establecen #diapo(2, 16). El resto de la materia —forma,
  función, entidades, relaciones, emergentes— es el vocabulario con el que se
  toman esas decisiones.
]

== Sistemas complejos: no es sólo "grande"

#deduccion("por qué la decisión del Módulo Lunar abre el tema")[
  En junio de 1962 la NASA decidió usar una cápsula dedicada —el *Módulo
  Lunar*— para bajar a la superficie desde órbita lunar, en vez de bajar con
  el Módulo de Comando/Servicio que llevó a los astronautas hasta ahí
  #diapo(2, 11). La decisión se tomó *siete años antes* de que la maniobra se
  ejecutara, antes de contratar a la mayoría del personal y antes de adjudicar
  los diseños. Fue *formativa*: eliminó diseños posibles y le dio a los
  equipos un punto de partida. Es el ejemplo con el que la cátedra abre la
  unidad porque muestra la propiedad central de una decisión arquitectónica:
  se toma temprano, con poca información, y condiciona todo lo que viene
  después.
]

Los sistemas de hoy no son sólo grandes: son a menudo *configurables* y
*costosos de entregar* #diapo(2, 12). Algunos números que la cátedra usa para
que la escala no quede en abstracto:

#figure(
  table(
    columns: (1.6fr, 1fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Sistema*], [*La escala*]),
    [Autos modernos], [70 procesadores, hasta 5 buses a 1 Mbit/s — contra 160 bit/s de los primeros buses de inyección de combustible],
    [Buque portacontenedores], [18.000 contenedores hoy, contra 480 en 1950],
    [Plataformas petroleras], [US\$ 200 a 800 millones cada una; 39 entregadas entre 2003 y 2009],
    [Configuraciones BMW (2004)], [1.500 millones de configuraciones potenciales ofrecidas a clientes],
    [Caza F-22 (2010)], [US\$ 160 millones; US\$ 350 millones con desarrollo incluido],
  ),
  caption: [La escala de los sistemas complejos contemporáneos, con números concretos en vez de adjetivos.],
)

#posta[
  Si te preguntan qué distingue a un sistema "complejo" de uno simplemente
  "grande": la complejidad agrega *configurabilidad* y *costo de entrega*, no
  sólo tamaño. Concebir, diseñar, implementar y operar (#t[CDIO]) sistemas así
  es, a veces, hacerlo *sin precedentes* #diapo(2, 11).
]

== Las ventajas de una buena arquitectura, y el costo de una mala

La pregunta que abre el tema: ¿los sistemas complejos satisfacen a los
interesados, se integran fácil, evolucionan con flexibilidad y funcionan de
manera simple y confiable? *Los que tienen buena arquitectura, sí*
#diapo(2, 15).

#cuidado[
  *NPOESS es el caso que se cita cuando la pregunta es "qué pasa con una mala
  decisión arquitectónica".* El programa fusionó en 1994 dos sistemas de
  satélites meteorológicos —uno civil, uno militar— con una oportunidad de
  ahorro de US\$ 1.3 mil millones #diapo(2, 19). La primera decisión fue
  incluir el superconjunto de instrumentos de ambos programas heredados (el
  instrumento VIIRS debía combinar las capacidades de *tres* instrumentos
  históricos). La segunda decisión —enumerar funciones nuevas *independientes*
  del concepto del sistema— encerró el rendimiento arquitectónico *en un
  rincón inalcanzable de su envolvente*: VIIRS debía hacer el trabajo de tres
  instrumentos con menos masa y volumen que uno solo #diapo(2, 20). Sumado a
  no haber designado un arquitecto responsable de gestionar esos
  intercambios, el programa se canceló en 2010, *US\$ 8.5 mil millones sobre
  el estimado original de US\$ 6.5 mil millones*.
]

Del otro lado, Boeing "apostó la compañía" al desarrollo del 787 y su
tecnología de materiales compuestos: en vez de repartir el riesgo en muchos
programas chicos, concentró el éxito o fracaso de la empresa en un solo
producto #diapo(2, 16). En el mercado de dispositivos móviles, BlackBerry y
Ericsson son los ejemplos de gigantes que cayeron por no innovar la
arquitectura de su oferta a tiempo #diapo(2, 17).

#clave[
  El patrón que conecta los tres casos —NPOESS, Boeing, BlackBerry/Ericsson—
  es el mismo: *las decisiones arquitectónicas tempranas se toman sin
  conocimiento completo del alcance eventual del sistema, y aun así tienen un
  impacto enorme en el diseño final* #diapo(2, 18). No son un detalle de
  ejecución: limitan la cobertura de desempeño, restringen sitios de
  fabricación y determinan quién puede capturar ingresos del mercado
  secundario.
]

== Qué hace buena a una arquitectura

La afirmación central del libro: estas decisiones tempranas *se pueden
analizar y tratar*, incluso sin conocer el diseño detallado de los componentes
#diapo(2, 18). Una buena arquitectura:

- Es *fácil de integrar*.
- Admite una *evolución sostenida* en el tiempo antes de quedar obsoleta.
- Es *lo menos ambigua posible*.
- Tiene una *descomposición óptima*.

#posta[
  Resumido en una frase que conviene tener lista: *puede ser compleja; no
  puede ser confusa.* La complejidad es del problema; la confusión es una
  falla de la arquitectura.
]

La arquitectura de un sistema es un proceso *suave*, un compuesto de ciencia y
arte: no es lineal ni produce una solución óptima única #diapo(2, 18). La
afirmación de los autores es que la *creatividad estructurada* —la que este
apunte va a desarrollar en las próximas unidades— es mejor que la creatividad
sin estructurar.

== Principios, métodos y herramientas

Para alcanzar los objetivos del curso, la cátedra distingue tres niveles, y la
distinción importa porque cada uno tiene un régimen de validez distinto
#diapo(2, 22):

#figure(
  table(
    columns: (0.9fr, 2fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Nivel*], [*Qué es*]),
    [*Principios*], [Fundamentos subyacentes y duraderos, *siempre (o casi siempre) válidos*.],
    [*Métodos*], [Formas de organizar enfoques y tareas para un fin concreto; fundados en principios, *usualmente o con frecuencia* aplicables.],
    [*Herramientas*], [Formas contemporáneas de facilitar el proceso; *aplicables a veces*.],
  ),
  caption: [Los tres niveles del enfoque del libro, ordenados de más duradero a más circunstancial.],
)

#cuidado[
  Cada principio que aparece en las próximas unidades trae una cita de algún
  pensador de sistemas — no es adorno: la cátedra los usa para mostrar que la
  idea es *recurrente*, no una ocurrencia del libro. El objetivo declarado del
  curso es que el lector termine con *sus propios* principios de arquitectura,
  construidos a partir de estos #diapo(2, 22).
]
