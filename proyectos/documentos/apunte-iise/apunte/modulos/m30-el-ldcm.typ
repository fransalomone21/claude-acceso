#import "../plantilla.typ": *

#modulo(
  "Una misión real de punta a punta: el LDCM",
  [Seguir una misión de observación de la Tierra real —el _Landsat Data
   Continuity Mission_— desde su meta hasta el satélite metido en la cofia:
   leer sus objetivos y sus requerimientos de alto nivel, ver cómo cambió el
   concepto durante la Fase A, separar plataforma de carga útil, leer el
   diagrama de interfaz entre las dos, el ConOps de tres segmentos y la
   jerarquía de requerimientos por niveles. Es el modelo más cercano que da
   la cátedra a lo que pide el trabajo práctico final.],
  clave: "el-ldcm",
)

#lectura[
  Clase 8, diapositivas 43 a 64.
]

== Por qué este ejemplo, y no otro

El trabajo práctico final pide una misión satelital en órbita baja, de
observación de la Tierra, telecomunicaciones o ciencia, llevada hasta su
_Mission Concept Review_. El LDCM es exactamente eso, ya hecho por NASA y
el Servicio Geológico de los Estados Unidos (USGS), y la cátedra lo
recorre entero en la clase 8. Leelo como si fuera el informe de otro grupo:
qué pusieron en cada sección, con qué nivel de detalle y en qué orden.

== De la meta a los objetivos

La meta, tomada del documento de requerimientos de ciencia y misión del
LDCM #diapo(8, 44): continuar la adquisición, el archivo y la distribución
de imágenes multiespectrales globales de la superficie terrestre, con
cobertura sinóptica y repetitiva, a una escala en la que se puedan
detectar, diferenciar, caracterizar y monitorear los cambios naturales y
los inducidos por el hombre.

De esa meta salen tres objetivos de misión mayores:

+ colectar y archivar imágenes multiespectrales de *resolución moderada*
  (unos 30 m de distancia de muestra en tierra), con cobertura de cada
  temporada de toda la masa terrestre, durante un período continuo de *no
  menos de 5 años*;
+ asegurar que los datos sean consistentes con los de las misiones Landsat
  anteriores —en adquisición, geometría, calibración, cobertura, espectro,
  calidad y disponibilidad— para poder estudiar cambios en el uso de la
  tierra a lo largo de *varias décadas*;
+ distribuir los productos al público en general, sin discriminación y a un
  precio no mayor que el costo incremental de atender al usuario.

#posta[
  Fijate el segundo objetivo: no habla del satélite sino de *los satélites
  anteriores*. La misión existe para que una serie de datos de cuarenta
  años no se corte. Esa es la necesidad, y explica casi todas las
  decisiones que vienen: la órbita, el horario de cruce, la calibración.
  Cuando escribas la necesidad de tu misión, buscá la frase equivalente: el
  «para qué» que justifica todo lo demás.
]

== Los requerimientos de alto nivel

La diapositiva 46 los lista, cada uno precedido por un «ID -» a completar:

- volar en órbita de *705 km*, casi polar, *heliosincrónica*;
- mantener las trazas de la grilla de referencia heredada (WRS-2) con un
  cruce del ecuador a las *10:00 de la mañana*;
- colectar imágenes multiespectrales (visible, infrarrojo cercano, de onda
  corta y térmico) a lo largo de una pisada de «X km» en cada trayectoria;
- cubrir la masa terrestre en cada temporada, colectando *400 escenas WRS-2
  por día*;
- mantener una calibración rigurosa (*TBD*);
- archivar los datos y distribuir los productos;
- dar acceso no discriminatorio al público general y generar productos de
  nivel 1;
- transmitir los datos directo a la red de estaciones terrenas
  internacionales que tengan un memorando de entendimiento con el USGS.

#deduccion("qué enseña una lista con «ID -», «X km» y «TBD»")[
  No es una lámina descuidada: es un borrador real de Pre-Fase A o Fase A.
  Tiene los dos defectos que el módulo #M("escribir-buenos-requerimientos")
  manda resolver antes del _baseline_: identificadores sin asignar y valores
  sin fijar. «X km» y «calibración rigurosa (TBD)» son, literalmente, lo
  que ese módulo llama un #t[TBD / TBC / TBR]: un hueco declarado que
  alguien va a tener que llenar —o por lo menos estimar, con un TBR— antes
  de que la SRR lo congele. Y «rigurosa» es justo la clase de palabra vaga
  que no se puede verificar.
]

#cuidado[
  La figura de la órbita #diapo(8, 45) dice 705 km, inclinación de 98,2°,
  período de 98,9 minutos y hora local de *9:45* de la mañana; el
  requerimiento de la diapositiva 46 dice *10:00*. Las dos cosas vienen de
  documentos distintos (la figura es la clásica de la serie Landsat), y
  para el parcial vale la del requerimiento. Lo interesante es el
  porqué: la hora de cruce *es* un requerimiento, porque fija la
  iluminación de cada imagen, y dos imágenes del mismo lugar con sombras
  distintas no se comparan bien.
]

== Cómo cambió el concepto durante la Fase A

#figure(
  placement: auto,
  image("../figuras/c08-p047.png", width: 88%),
  caption: [Tres conceptos de la Fase A del LDCM: volar en un satélite propio (_free flyer_) o alojado en la plataforma de otro programa (NPOESS), en dos variantes. De izquierda a derecha crecen la masa, el volumen, la complejidad técnica, el costo y el calendario (diapositiva 47).],
)

La lámina compara tres conceptos evaluados durante la Fase A. Lo que
dibuja y pesa no es el satélite entero sino *el paquete del
instrumento* —la nota al pie aclara que incluye el grabador de estado
sólido y todo el hardware de acomodación—: *170 kg*, 1,3 m³ y 400 W para
volar en un satélite propio a 705 km; *250 kg* y *400 kg* para viajar
alojado en la plataforma de otro programa, a 828 km. Las tres flechas de
abajo —técnica, costo, planificación— dicen lo mismo: *aumentan* de
izquierda a derecha.

#posta[
  Es el trade study del módulo #M("fase-a-a-fondo") con números reales. La
  Fase A no elige «el mejor satélite» en abstracto: compara conceptos
  completos contra los tres lados del triángulo de hierro. Y no termina
  con una foto linda: el resto de la clase muestra un satélite propio a
  705 km, que es lo que pedía el requerimiento de órbita.
]

== Plataforma y carga útil

#definicion("plataforma (bus) y carga útil")[
  Las dos grandes partes de un satélite. La *carga útil* es lo que cumple
  la misión; la *plataforma* o *bus* es todo lo que la sostiene y la sirve:
  estructura, potencia, control de actitud, comando y manejo de datos,
  comunicaciones, propulsión y control térmico #diapo(8, 57) #diapo(8, 58).
]

En el LDCM la carga útil son dos instrumentos: el *OLI* (el generador de
imágenes en el visible y el infrarrojo) y el *TIRS* (el sensor
infrarrojo térmico), montados sobre una cubierta de instrumentos. El
conjunto integrado de plataforma más carga útil se llama *observatorio*.

#figure(
  placement: auto,
  image("../figuras/c08-p057.png", width: 72%),
  caption: [El LDCM desarmado: arriba la carga útil (OLI, TIRS y la cubierta de instrumentos), abajo la plataforma con su panel solar y su módulo de propulsión (diapositiva 57).],
)

Los subsistemas de la plataforma, con sus números #diapo(8, 56)
#diapo(8, 58):

#figure(
  table(
    columns: (1.25fr, 3fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    [*Subsistema*], [*Qué tiene el LDCM*],
    [Comando y manejo de datos (C&DH)], [computadora RAD750; grabador de estado sólido de 3,1 Tbit; hasta 265 Mbps desde el OLI y 26,2 Mbps desde el TIRS; descarga a 384 Mbps],
    [Potencia eléctrica (EPS)], [un ala solar articulada en un eje, de arseniuro de galio, con 4300 W al final de la vida; batería de níquel-hidrógeno de 125 Ah; bus no regulado de 22 a 36 V],
    [Guiado, navegación y control (ACS)], [dos de tres seguidores de estrellas activos, unidad inercial de alta precisión, ruedas de reacción; estabilizado en tres ejes, con momento total nulo],
    [Estructura], [aluminio; componentes montados afuera; campos de visión y caminos de radiación de los instrumentos despejados],
    [Control térmico (TCS)], [pasivo, con calefactores y tubos de calor si hacen falta],
    [Propulsión], [hidracina en modo _blow-down_, ocho propulsores redundantes de 22 N],
    [Comunicaciones (RF)], [banda S con estaciones terrenas y con TDRSS para comando y telemetría; banda X a 384 Mbps para los datos de ciencia],
  ),
  caption: [Los subsistemas de la plataforma del LDCM (diapositivas 56 y 58).],
)

#deduccion("cómo se leen estos números como un sistema, no como una lista")[
  Los números se encadenan. La carga útil produce hasta 265 + 26,2 Mbps
  mientras mira; la descarga va a 384 Mbps, pero *sólo mientras el
  satélite ve una estación*. El grabador de 3,1 Tbit existe para cubrir esa
  diferencia: guarda lo que se toma lejos de las estaciones y lo baja
  cuando pasa por arriba. Las 400 escenas por día del requerimiento
  determinan cuánto se graba; el tiempo de contacto con tierra, cuánto se
  descarga. Es el diagrama N² del módulo #M("el-diagrama-n2-aplicado"),
  visto como cuentas: la salida de un subsistema es la entrada que
  dimensiona al siguiente.
]

== La interfaz entre la plataforma y la carga útil

#figure(
  placement: auto,
  image("../figuras/c08-p048.png", width: 80%),
  caption: [El observatorio LDCM interfaceando con la plataforma: comando y telemetría por un bus 1553, los datos de ciencia por buses de alta velocidad hacia un grabador del instrumento, y las dos salidas de radio, S para comando y telemetría y X para la ciencia (diapositiva 48).],
)

La lámina muestra las dos clases de flujo que conviven en un satélite:
el de *comando y telemetría*, angosto, que va por el bus 1553 y sale en
banda S; y el de *datos de ciencia*, ancho, que va por buses de alta
velocidad —todavía con su formato «TBD» en la lámina— al grabador y sale en
banda X. El TIRS aparece en línea punteada, con la leyenda «si el TIRS se
confirma para el LDCM»: en ese momento del proyecto, el segundo
instrumento todavía no estaba decidido.

#posta[
  Ese «si se confirma» es oro para el trabajo práctico: un diagrama de
  Fase A *puede y debe* mostrar lo que todavía no está decidido, marcado
  como tal. Inventar una certeza que no tenés es peor que dibujar una caja
  punteada con un cartelito honesto.
]

== El ConOps: tres segmentos

#figure(
  image("../figuras/c08-p052.png", width: 80%),
  caption: [El ConOps del LDCM: el segmento de vuelo (el observatorio), el segmento de tierra (operaciones de vuelo, procesamiento y archivo) y el segmento de lanzamiento (diapositiva 52).],
)

El ConOps del LDCM se parte en *tres segmentos* #diapo(8, 49)
#diapo(8, 52): el de *vuelo* (el observatorio con el OLI, el TIRS, el
C&DH y las dos bandas de radio), el de *tierra* (el segmento de
operaciones de vuelo, con la red de estaciones, el centro de operaciones
de la misión y la planificación de las tomas; y el segmento de
procesamiento y archivo de datos, con el portal para los usuarios) y el de
*lanzamiento*. Cada caja lleva el color de quién la provee: NASA, el USGS
o los dos.

#deduccion("por qué el ConOps dibuja quién paga cada caja")[
  Porque la frontera entre organizaciones es una *interfaz*, y de las más
  caras. Una caja provista por NASA que le pasa datos a una del USGS
  necesita un documento de control de interfaz entre dos organismos, con
  dos presupuestos y dos jefes. El ConOps lo hace visible antes de que
  exista una sola línea de requerimientos de interfaz. Para tu trabajo
  práctico: las interfaces *externas* del N² son, en buena parte, las
  flechas que cruzan de un color a otro en un dibujo como este.
]

== La jerarquía de requerimientos

La diapositiva 50 dibuja el árbol de documentos de requerimientos del
LDCM por niveles de control: en el *nivel 1*, la sede de NASA, con la ley
de política de sensado remoto, el memorando NASA-DOI-USGS y los
requerimientos de nivel 1 del LDCM; en el *nivel 2*, el control del
proyecto, con el documento de requerimientos de ciencia y misión y el
concepto de operaciones; en el *nivel 3*, los documentos de cada
segmento, de cada instrumento y de cada interfaz; y del *nivel 4* para
abajo, los del contratista. Cada documento lleva un color según quién lo
controla.

#cuidado[
  Fijate qué está arriba de todo, en el nivel 1: *una ley* y *un
  memorando entre organismos*. La familia de requerimientos del módulo
  #M("familia-de-requerimientos-y-trazabilidad") no empieza en un ingeniero
  sino en quien tiene la autoridad: es el eslabón «autoridades» del
  Ejercicio de Alcance hecho documento. Y el ConOps está en el nivel 2, *al
  lado* del documento de requerimientos de misión, no debajo: los dos
  salen juntos de los requerimientos de nivel 1.
]

== Del papel al hangar

Las últimas láminas del ejemplo son fotos y dibujos del satélite real: la
plataforma en el hangar #diapo(8, 59), el observatorio con su carga útil
#diapo(8, 60), la integración de la carga útil sobre la plataforma con una
grúa #diapo(8, 61), las dimensiones —el _spacecraft_ armado pesa *4565 libras* (≈ 2070
kg) con el combustible cargado, mide unos 19 pies de alto y despliega un panel solar de 32 pies
#diapo(8, 62)— y el observatorio metido en la mitad de la cofia de su
lanzador #diapo(8, 64). La Fase B del LDCM ya muestra el diseño del
observatorio con el escudo térmico desplegable, el deflector nadir y la
electrónica del criorrefrigerador del TIRS #diapo(8, 55).

#posta[
  Hacé la cuenta: el paquete del instrumento del concepto «propio» de la
  Fase A pesaba 170 kg; el _spacecraft_ armado, con el combustible
  cargado, ronda las dos toneladas. La carga útil es la razón de ser
  de la misión y apenas una fracción de su masa: el resto es la
  plataforma que la mantiene viva, apuntada y hablando con tierra.
]
