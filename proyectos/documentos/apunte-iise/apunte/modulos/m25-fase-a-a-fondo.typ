#import "../plantilla.typ": *

#modulo(
  "Fase A a fondo: qué produce, y dos ejemplos reales",
  [Explicar qué produce concretamente la Fase A y en qué se apoya de la
   Pre-Fase A; leer el ConOps del Mars 2020 como síntesis de un baseline de
   misión; explicar por qué heredar del Curiosity fue la decisión correcta
   para el presupuesto del Mars 2020; y leer un requerimiento de interfaz
   real, con sus números, del GLAST.],
  clave: "fase-a-a-fondo",
)

#lectura[
  Clase 7, diapositivas 16 a 40.
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
    de 16×14 km, acceso a sitios dentro de ±30° de latitud.
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
  movilidad se heredaron casi sin cambios. Los cambios reales fueron
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
