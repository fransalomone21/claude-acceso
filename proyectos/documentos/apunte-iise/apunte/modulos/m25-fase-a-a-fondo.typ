#import "../plantilla.typ": *

#modulo(
  "Fase A a fondo: qué produce, y dos ejemplos reales",
  [Leer la matriz de funciones clave de la ingeniería de sistemas por fase,
   por fila y por columna; explicar qué produce concretamente la Fase A y
   en qué se apoya de la Pre-Fase A; leer el ConOps del Mars 2020 como
   síntesis de un baseline de misión; explicar por qué heredar del
   Curiosity fue la decisión correcta para su presupuesto; distinguir
   interfaces internas y externas sobre hardware real; y leer un
   requerimiento de interfaz real, con sus números, del GLAST.],
  clave: "fase-a-a-fondo",
)

#lectura[
  Clase 7, diapositivas 4 y 16 a 40.
]

== El mapa: qué hace la ingeniería de sistemas en cada fase

La clase 7 arranca con una lámina que vale por media materia
#diapo(7, 4): una matriz con las *funciones clave* de la ingeniería de
sistemas en las filas, las fases en las columnas y, en cada celda, en qué
estado tiene que quedar esa función cuando la fase termina. La cátedra la
vuelve a mostrar —dos veces— en la clase 9. Una lámina que se repite tres
veces no está de relleno.

#figure(
  image("../figuras/c07-p004.png", width: 100%),
  caption: [Las funciones clave de la ingeniería de sistemas, fase por fase: de *Concepto* a *Baseline*, a *Completo* y después a *Seguimiento de los cambios* (diapositiva 4).],
)

#deduccion("cómo se lee la matriz, en las dos direcciones")[
  - *Por fila*, una función a lo largo del ciclo. Casi todas suben la
    misma escalera: *Concepto* en la Pre-Fase A, *Baseline* en la Fase A,
    *Completo* en la B o la C, y de ahí en más *Seguimiento de los
    cambios*. Lo que distingue a una fila de otra es *cuándo* llega cada
    escalón. La V&V va atrasada a propósito —inicial en la A, asignar
    métodos en la B, desarrollar los planes en la C, completa recién en la
    D—, porque no se puede planificar cómo se verifica algo que todavía no
    está diseñado. Las interfaces y el seguimiento del presupuesto y de los
    recursos técnicos también van un paso atrás: *inicial* en la A,
    *baseline* en la B.
  - *Por columna*, el checklist de una fase. La de la Fase A dice qué tiene
    que existir al cerrarla: en *baseline*, los objetivos, el ConOps, la
    arquitectura y el diseño, los requerimientos de *alto nivel*, el
    ambiente de misión y el Plan de Gestión de la Ingeniería de Sistemas
    (el SEMP); en estado *inicial*, la V&V, las interfaces y el presupuesto
    de recursos técnicos; el riesgo analizado con FTA y RBD; la gestión de
    configuración reducida al control de los requerimientos de *nivel 1*; y
    la MDR como hito.
]

#notacion[
  La lámina no desarrolla las siglas de la fila de riesgo; son las
  estándar de confiabilidad, y las completa el apunte: *FTA*, análisis por
  árbol de fallas (_Fault Tree Analysis_); *RBD*, diagrama de bloques de
  confiabilidad (_Reliability Block Diagram_); *FMEA*, análisis de modos de
  falla y sus efectos (_Failure Modes and Effects Analysis_); *PRA*,
  evaluación probabilística del riesgo (_Probabilistic Risk Assessment_).
  Fijate que la lista *crece* fase a fase: se analiza más riesgo a medida
  que hay más diseño sobre el cual analizarlo.
]

#cuidado[
  En esta matriz la *SRR* figura en la columna de la *Fase B*, junto con
  la PDR. En la misma clase, las diapositivas 41, 44 y 45 la ponen en la
  *Fase A*, antes de la MDR, y así la desarrolla el módulo
  #M("revisiones-de-la-fase-a"). Para el parcial vale esa: es la que la
  clase explica y la del ciclo de vida de NASA del módulo
  #M("ciclo-de-vida-y-diagrama-en-v"). Las columnas de la matriz tampoco
  usan esos nombres de fase («Análisis preliminar», «Definición»,
  «Diseño», «Desarrollo»): es _probable_ que la lámina venga de un esquema
  de fases anterior de NASA, y eso explicaría el corrimiento. Esto último
  es una hipótesis del apunte, no algo que haya dicho la cátedra.
]

== Qué produce la Fase A

#clave[
  La Fase A establece un *baseline de los requerimientos de alto nivel* del
  sistema y un *concepto de baseline de sistema inicial* —un conjunto de
  datos de ingeniería de referencia—, partiendo de los objetivos que la
  #t[ciclo de vida de NASA] ya fijó en la Pre-Fase A y particionándolos
  sucesivamente en niveles más bajos. Al final de esta fase hay información
  específica para *comprar componentes*: qué tanque de propulsión, qué
  baterías, cuánta energía hace falta en eclipse.
]

#deduccion("por qué esto no es prematuro")[
  Comprar un componente en la Fase A no contradice que todavía se esté
  refinando el sistema: los requerimientos de alto nivel ya fluyeron hacia
  abajo lo suficiente como para fijar *qué tanque* y *qué baterías* hacen
  falta, aunque el diseño detallado —de qué manera se integran, cómo se
  verifican— siga abierto. Es la misma jerarquía de la
  #t[familia de requerimientos (padres, hijos, huérfanos)]: los hijos ya
  existen antes de que el sistema completo esté cerrado.
]

== Ejemplo: el Mars 2020, un ConOps sintetizado en un cuadro

#figure(
  image("../figuras/c07-p019.png", width: 92%),
  caption: [El panorama de misiones a Marte —operativas 2001–2017 y futuras 2018–2030— que la cátedra usa para introducir el "future planning" de la Fase A (diapositiva 19).],
)

#ejemplo("el baseline de la misión Mars 2020, resumido en cuatro fases", nivel: "a-fondo")[
  - *Lanzamiento:* clase MSL / capacidad del vehículo lanzador, ventana
    julio–agosto de 2020.
  - *Crucero-Acercamiento:* 7,5 meses de crucero, arribo en febrero de 2021.
  - *Entrada, Descenso y Aterrizaje:* sistema EDL del MSL (entrada guiada y
    descenso propulsado con grúa aérea — *Sky Crane*), elipse de aterrizaje
    de 16×14 km, acceso a sitios dentro de ±30° de latitud y a no más de
    −0,5 km de elevación. El *Range Trigger* (cuándo se abre el
    paracaídas) ya está en el baseline; la *Terrain Relative Navigation*
    (corregir el descenso mirando el terreno) está *financiada hasta el
    PDR*.
  - *Misión en superficie:* 20 km de capacidad de recorrido, buscar signos
    de vida pasada, resguardar muestras retornables, y preparar la futura
    expedición humana.
]

#clave[
  Esto *es* un #t[concepto de operación (ConOps)] —de la unidad 5 y 6—,
  ahora visto en su forma más comprimida: cuatro fases, cada una con sus
  requerimientos numéricos, sin una sola palabra de más. Sintetizar un
  ConOps en un cuadro así es exactamente el "layout de alto nivel" que la
  unidad 6 pedía para cualquier ConOps.
]

#posta[
  Mirá la diferencia entre las dos tecnologías del aterrizaje
  #diapo(7, 22). Una ya entró al baseline; la otra todavía no, y lo que la
  Fase A le aprueba es *plata para madurarla hasta el PDR*. Es la fila de
  riesgo de la matriz del principio, en un caso concreto: una tecnología
  que no está madura no se mete en el baseline a ver qué pasa, se le arma
  un plan y se le pone fecha.
]

== Ejemplo: heredar del Curiosity, y por qué fue la decisión correcta

#figure(
  image("../figuras/c07-p037.png", width: 80%),
  caption: [El rover Mars 2020 —heredero directo del chasis, ruedas y subsistemas del Curiosity, con instrumentos científicos nuevos (diapositiva 37).],
)

#deduccion("un presupuesto fijo, resuelto con herencia")[
  El Mars 2020 tuvo un presupuesto de *US\$ 1.500 millones* y reutilizó la
  tecnología del Curiosity. La Fase A fue rápida precisamente *porque*
  varios requerimientos de alto nivel ya estaban resueltos por el rover
  anterior: aviónica, potencia, GN&C, telecomunicaciones, térmica y
  movilidad se heredaron casi sin cambios. Hasta la envolvente es la
  misma: Curiosity y Perseverance miden los dos 2,9 m de ancho, 2,7 m de
  largo y 2,2 m de alto #diapo(7, 38). Los cambios reales fueron
  puntuales: nuevos instrumentos científicos, un nuevo sistema de captura
  de muestras, chasis modificado, *harness* modificado, software de
  superficie modificado, controlador de motor modificado y ruedas
  modificadas.
]

#posta[
  La lección no es "copiar es más barato" en abstracto: es que la Fase A
  se ahorra estudios de análisis enteros cuando la herencia es real y
  medible —el Curiosity ya voló, ya operó con éxito, y ya hay partes de
  repuesto—. Eso es evidencia de menor riesgo, no sólo de menor costo.
]

== Interfaces en la Fase A

#clave[
  Al descomponer cualquier sistema, las interfaces *inevitablemente
  gravitan* — el subsistema de potencia interfacea con casi todos los demás
  (propulsión, actitud, C&DH), y cada equipo necesita saber cómo se conecta
  con los otros. La ingeniería de sistemas resuelve esa incertidumbre con
  los #t[documentos de interfaz (IDD, IRD, ICD)]: cada equipo de subsistema
  se dedica a lo suyo sin preocuparse por la interfaz, porque ya está
  documentada.
]

#ejemplo("un requerimiento de interfaz real, con sus números: el GLAST", nivel: "a-fondo")[
  El *Interface Requirements Document* entre el instrumento científico y la
  plataforma del *spacecraft* GLAST especifica, por tipo de interfaz:
  - *Eléctrica:* el bus de tensión suministrará *28 V ± 6 V* en los
    terminales de entrada del instrumento.
  - *Datos:* la velocidad de datos del *spacecraft* hacia el instrumento no
    superará *70 Mbps*.
  - *Mecánica:* la masa máxima de lanzamiento del instrumento está
    restringida a *3.000 kg* (excluye la interfaz misma, pero incluye todo
    el hardware montado en el bus, como radiadores térmicos y cajas de
    electrónica).
  - *Térmica:* el rango de temperatura de las cajas de electrónica del
    instrumento se controla entre *−10 °C y +40 °C* en operación, y entre
    *−55 °C y +60 °C* en supervivencia (ambos valores marcados TBR).
]

#posta[
  Este es el mismo #t[TBD / TBC / TBR] de la unidad 6, en un documento real
  de la industria: incluso un requerimiento de interfaz con números
  precisos puede llevar un TBR, porque "preciso" y "definitivo" no son lo
  mismo. El GLAST voló en 2008 con estos requerimientos ya resueltos.
]

== Interfaces internas y externas, sobre hardware real

#clave[
  Una interfaz es *externa* cuando cruza el límite del sistema —el
  _spacecraft_ con el lanzador, con la plataforma de lanzamiento, con la
  antena en Tierra— e *interna* cuando une dos partes del mismo sistema:
  dos subsistemas, o dos tarjetas dentro de una caja. Las dos se definen en
  la Fase A, porque al descomponer un sistema las interfaces aparecen
  *inexorablemente* #diapo(7, 27).
]

#figure(
  image("../figuras/c07-p024.png", width: 62%),
  caption: [Tres interfaces en una lámina: el subsistema de propulsión del SPIRALE integrado en su plataforma (interna, entre subsistemas), el satélite bajando sobre su adaptador (externa y mecánica, con el lanzador) y un conector (interna, dentro de un subsistema) (diapositiva 24).],
)

#ejemplo("la interfaz mecánica con el lanzador: elegir el adaptador", nivel: "a-fondo")[
  El satélite necesita una interfaz externa para unirse mecánicamente al
  lanzador, y eso es un *requerimiento de alto nivel* #diapo(7, 25). La
  lámina muestra cómo se elige el adaptador (un PAS 1194VS):
  - la masa estimada del satélite es de *3932,9 kg*, unos *4000 kg*;
  - el adaptador tiene que resistir *más* que eso;
  - el de 1194 mm aguanta hasta *7000 kg*, y el sistema adaptador pesa
    como máximo *165 kg*.
]

#posta[
  El orden es todo el método: primero un número del satélite —una
  estimación, todavía de Fase A—, después lo que ese número le exige a la
  interfaz («más de 4000 kg») y recién ahí el hardware que lo cumple, con
  margen de sobra (7000 kg). El adaptador no se elige porque es lindo: se
  elige contra un requerimiento.
]

La misma interfaz tiene su lado *eléctrico* #diapo(7, 26). La guía del
usuario del Falcon 9 dibuja el camino de los cables desde el satélite, ya
encapsulado en la cofia, hasta la sala donde el cliente monitorea su
equipo antes del lanzamiento: el *plano de separación*, el *plano de
interfaz eléctrica estándar*, el umbilical que baja por el erector y las
cajas de conexión hasta la sala de EGSE (los equipos eléctricos de soporte
en tierra). Todo eso es interfaz externa: entre el satélite, el lanzador y
la plataforma de lanzamiento.

#cuidado[
  *No toda interfaz va al ICD.* Entre subsistemas, adentro del
  _spacecraft_, la interfaz se documenta y el cableado (_harness_) es
  casi siempre un subsistema en sí mismo. Pero adentro de una caja o de un
  componente de un subsistema, la interfaz la define *ese subsistema*, no
  un ICD #diapo(7, 27). El ICD es para lo que cruza de un equipo de
  trabajo a otro, no para cada tornillo.
]

#posta[
  ¿La unión entre las dos etapas del Falcon 9 es interna o externa? La
  cátedra contesta «depende» #diapo(7, 28), y es la respuesta correcta:
  si el sistema es el lanzador entero, es interna; si el sistema es una
  etapa, es externa. Lo que hace externa a una interfaz no es la pieza: es
  dónde pusiste el límite del sistema. Es la Tarea 2 de la unidad 2
  —entidades, límite y contexto— cobrando, cinco clases después.
]

#figure(
  image("../figuras/c07-p030.png", width: 60%),
  caption: [Las comunicaciones espacio–Tierra como una cadena de interfaces: la antena de la DSN, el centro de procesamiento de señales del complejo, la red WAN, el centro de operaciones del espacio profundo de JPL (DSOC) y el centro de operaciones de la misión (MOC) (diapositiva 30).],
)

#deduccion("las comunicaciones, contadas como interfaces")[
  La comunicación entre el _spacecraft_ y la antena de la estación terrena
  es una interfaz externa, y sus requerimientos son de alto nivel: se
  definen en la Fase A #diapo(7, 31). Pero la lámina muestra que la antena
  es sólo el primer eslabón #diapo(7, 30): la señal que recibe la antena
  de la DSN (_Deep Space Network_) pasa al centro de procesamiento de
  señales del mismo complejo, de ahí por una red WAN al DSOC de JPL, y de
  ahí al MOC, donde trabaja el equipo de la misión. Cada flecha de esa
  cadena es una interfaz, y si una sola no está definida, la misión no
  habla con nadie. La diapositiva anterior #diapo(7, 29) dibuja lo mismo
  en bloques: del lado del _spacecraft_, los instrumentos y los
  subsistemas de ingeniería colgados del sistema de comando, datos y
  comunicaciones; del lado de Tierra, el sistema de datos de la misión,
  con los investigadores y los ingenieros colgados de él; y en el medio,
  un único enlace espacio–Tierra.
]

== Ejemplo: el thruster, de la necesidad al hardware

#figure(
  image("../figuras/c07-p042.png", width: 92%),
  caption: [Un thruster real del subsistema de propulsión —hardware, ensayo de banco y esquema del sistema de alimentación de hidracina— como el que responde al requerimiento de empuje de la Fase A (diapositiva 42).],
)

#deduccion("cómo un requerimiento de empuje se convierte en una compra")[
  La cátedra usa los *thrusters* (motores cohete pequeños) como ejemplo del
  ciclo completo: en la Fase A se establece *cuánto empuje* hace falta para
  cumplir la misión; en fases posteriores ese requerimiento se aloja en un
  componente específico, se compra o se fabrica, y se ensaya para confirmar
  que produce el empuje requerido — todo esto *dentro* del margen de masa
  que el sistema puede alojar (la unidad 5 ya desarrolló ese margen a
  fondo). El diagrama del sistema de alimentación (tanque, válvulas,
  filtros, múltiples *thrusters* redundantes en dos ramas) es, en sí mismo,
  una red de interfaces que la Fase A tiene que dejar definida.
]
