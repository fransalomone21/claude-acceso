#import "../plantilla.typ": *

#modulo(
  "Filosofía de modelos, calificación y aceptación, y ensayos ambientales",
  [Elegir una filosofía de modelos (protoflight, prototipo o híbrido) y
   decir qué se gana y qué se arriesga con cada una; distinguir la
   calificación de la aceptación con el gráfico de niveles y duraciones;
   nombrar los documentos de la verificación y el plan AIV; recorrer los
   ensayos ambientales por entorno; y ubicar los modelos de ingeniería (EDM,
   EM) antes del modelo de vuelo.],
  clave: "modelos-y-ensayos",
)

#lectura[
  Clase 11 A, diapositivas 29 a 46.
]

== Cuántos modelos se construyen: la filosofía de modelos

#definicion("filosofía de modelos (protoflight, prototipo, híbrido)")[
  Dilucidar el número óptimo de modelos, con sus características físicas,
  para verificar el producto con confianza, según un compromiso entre
  desempeño, costo, tiempo y riesgo #diapo("11 A", 29).
]

Hay dos paradigmas y un punto medio #diapo("11 A", 29):

- *protoflight*: el mismo modelo se califica y vuela. Cuesta menos, a
  cambio de aceptar un nivel *moderado* de riesgo;
- *prototipo*: un modelo de calificación aparte, que no vuela. Para
  diseños nuevos o complejos donde hay que correr riesgos *muy bajos*, y
  permite trabajar en paralelo sobre modelos distintos;
- *híbrido*: el compromiso entre los dos, para proyectos donde la
  calificación cae sobre partes de diseño nuevo o de impacto crítico en la
  verificación.

#clave[
  La cátedra da un caso: la aviónica de un vehículo lanzador. Todos sus
  equipos tienen que ser de muy bajo riesgo en uso regular, así que conviene
  una filosofía *de prototipo* #diapo("11 A", 29). Y una regla que vale para
  cualquiera de las tres: *la calificación se completa antes de aceptar* el
  equipo construido con los datos de ingeniería del modelo calificado.
]

== Calificación contra aceptación

#definicion("calificación (verificación de calificación)")[
  El proceso formal que establece la *aptitud para el vuelo del diseño*:
  del _hardware_, de los componentes elegidos y de los procesos de
  manufactura. Se hace por análisis, ensayos (mediciones cuantitativas),
  demostraciones (cualitativas) e inspecciones, sobre _hardware_ construido
  con los mismos requerimientos que el de vuelo aunque no vaya a volar
  #diapo("11 A", 32).
]

#definicion("modelo de calificación (QTM)")[
  El prototipo sobre el que se hace la calificación: sin propósito de
  vuelo, pero totalmente representativo del modelo de vuelo. Sus niveles de
  ensayo ambiental y sus duraciones superan las condiciones de vuelo y
  llevan a sus elementos a la fatiga, *sin* superar los márgenes de
  seguridad del diseño ni provocar modos de falla irreales
  #diapo("11 A", 30).
]

#definicion("aceptación (verificación de aceptación)")[
  La serie de ensayos que verifica que *cada unidad* de _hardware_ es
  conforme a los datos de ingeniería con que se construyó la unidad
  calificada #diapo("11 A", 32): que es idéntica a la calificada y está
  libre de defectos de construcción —el _workmanship_—
  #diapo("11 A", 16). Las unidades se aceptan si cumplen los procedimientos
  de ensayo de aceptación (ATP) #diapo("11 A", 30).
]

#figure(
  placement: auto,
  image("../figuras/c11a-p030.png", width: 78%),
  caption: [Niveles de ensayo contra duración, sin escala #diapo("11 A", 30). El prototipo o QTM se ensaya a nivel *y* tiempo de calificación (arriba a la derecha); la unidad de vuelo, a nivel y tiempo de aceptación (ATP, abajo a la izquierda); el protoflight, a nivel de calificación pero por tiempo de aceptación.],
)

#deduccion("por qué el protoflight se ensaya a nivel de calificación y tiempo de aceptación")[
  El modelo protoflight es el que vuela, y a la vez es el único que
  califica el diseño. Si se lo ensaya a nivel de aceptación, nadie probó
  que el diseño aguanta más que el vuelo; si se lo ensaya a nivel y
  duración de calificación, se lo lleva a la fatiga y se vuela un equipo
  gastado. La salida es el punto del gráfico: *el nivel de la calificación,
  la duración de la aceptación*. El ejemplo del control de actitud del SAC
  de la clase 11 B lo escribe así, componente por componente: «_qualified
  level, acceptance time (protoflight philosophy)_» (módulo
  #M("ait-de-un-subsistema")).
]

Para que la verificación funcione, cada requerimiento tiene que llegar al
proceso siendo *trazable*, *único* y con su identificación, *simple* —no una
combinación de requerimientos—, *verificable* por uno o más métodos, *no
ambiguo* y referenciado como necesario por otro requerimiento
#diapo("11 A", 31). Es la lista de SMART de la unidad 6, vista desde el que
tiene que verificarla.

== Los papeles de la verificación

La documentación es un compromiso: documentar lo mínimo por costo, y lo
suficiente para seguir los eventos de verificación, que es lo que reduce el
riesgo y permite recuperarse si algo sale mal. Y tiene un piso: *el
volumen de la documentación tiene que permitir construir otro sistema igual
al calificado* #diapo("11 A", 33).

El flujo de documentos #diapo("11 A", 34) parte de los requerimientos
aplicables (especificaciones, ICD) y de las expectativas del cliente;
pasa por la matriz de verificación (nivel y método de cada requerimiento) y
el plan AIV; se abre en cuatro ramas —ensayos, análisis, revisión de
diseño, inspección—, cada una con su especificación, su procedimiento y su
informe; y cierra con el *informe de verificación*. Si un requerimiento no
se verificó, vuelve al proceso como desviación, modificación de diseño o
repetición de la verificación.

#figure(
  table(
    columns: (1.9fr, 1fr, 2.3fr),
    align: (left, left, left),
    stroke: 0.4pt + luma(180),
    inset: 5pt,
    table.header([*Documento*], [*Fases*], [*Cuándo se entrega*]),
    [Matriz de verificación], [A, B, C], [en la PRR, SRR, PDR y CDR],
    [Plan de ensamble, integración y verificación (AIV)], [A a F], [PRR, SRR, PDR, CDR, QR, AR, EOL],
    [Documento de control de verificación], [B a F], [periódico; como mínimo en las mismas revisiones],
    [Especificaciones de ensayo], [C, D], [meses antes del ensayo],
    [Procedimientos de ensayo], [C a F], [semanas antes del ensayo],
    [Informe de ensayos], [D a F], [semanas después del ensayo],
    [Informe de análisis], [C, D], [semanas después del análisis],
    [Informes de inspección], [C a F], [—],
    [Informes de revisión de diseño], [D, E], [semanas después de la revisión],
    [Informe de verificación], [C a F], [—],
  ),
  caption: [La tabla de documentos del proceso de verificación #diapo("11 A", 43). Las fases son las columnas que la lámina marca con una cruz.],
)

El *plan AIV* es el plan maestro de la verificación del proyecto en la
Fase D, y muestra cómo se van a verificar los requerimientos en una
implementación coherente. Lleva la definición de los ensayos, los niveles
de ensamble de la unidad a ensayar, la configuración, los objetivos, las
facilidades, la instrumentación, el ambiente, la seguridad, el control de
contaminación, las fases y perfiles de ensayo, las operaciones funcionales,
las responsabilidades y los requerimientos de procedimientos e informes. De
él salen las especificaciones de ensayo #diapo("11 A", 35).

== Los ensayos ambientales

#definicion("ensayos ambientales")[
  Los ensayos en tierra que simulan el lanzamiento y la estadía en el
  espacio. Verificar es establecer la confianza en que el sistema va a
  operar correctamente en el espacio, y como el ambiente espacial es único
  y hay un solo camino para llegar, los sistemas espaciales atraviesan
  ensayos rigurosos antes #diapo("11 A", 36).
]

Los ensayos consideran tres entornos #diapo("11 A", 37):

+ *antes del lanzamiento*: transporte, manipulación, almacenamiento,
  calibración;
+ *durante el lanzamiento*: primero la inicialización previa al despegue y
  después el ambiente más riguroso —despresurización, térmica, acústica,
  aceleraciones, vibraciones, choque pirotécnico—;
+ *en órbita*: térmica, radiación, micrometeoritos.

#figure(
  table(
    columns: (1.1fr, 1.8fr, 1.7fr, 2fr),
    align: (left, left, left, left),
    stroke: 0.4pt + luma(180),
    inset: 5pt,
    table.header([*Ensayo*], [*Para qué*], [*Qué hace falta*], [*Cómo se hace*]),
    [Vibración y choque], [que el producto sobreviva al lanzamiento; cumplir lo que pide la autoridad del lanzador], [un modelo estructural validado; mesa de vibración con adaptadores para tres ejes; cámara acústica], [barrido de baja intensidad para encontrar los modos (la «firma»); vibración aleatoria de alto nivel con el perfil del lanzador; repetir el barrido y comparar; comparar con los modelos],
    [Vacío térmico], [medir el _outgassing_; que el producto opere en vacío a las temperaturas extremas del vuelo; validar los modelos térmicos], [cámara de vacío térmico; detector de _outgassing_; termómetros en los puntos clave (las baterías)], [operar a temperatura y presión ambiente; operar en caliente y en frío, oscilar entre las dos y monitorear; comparar con los modelos],
    [EMI / EMC], [que el producto no emita energía que interfiera con el resto del satélite, el lanzador o el _range safety_, y que no sea susceptible a ellos], [cámara anecoica, antena de ganancia conocida; susceptibilidad conducida en las cajas], [buscar las señales emitidas, sobre todo en las armónicas de los relojes; operar mientras se inyectan señales o caídas de potencia],
  ),
  caption: [Las claves de los ensayos ambientales espaciales #diapo("11 A", 39).],
)

#clave[
  Los ensayos ambientales son la parte más pesada de la campaña de
  calificación y aceptación, y no se planifican solos: se combinan con
  análisis para *validar los modelos*, dependen de la filosofía de modelos y
  tienen sus documentos con trazabilidad #diapo("11 A", 38). Si un
  resultado no cumple, se corrige el diseño o la manufactura y el ítem se
  vuelve a verificar, total o parcialmente según dónde apareció la no
  conformidad. Y el equipo de soporte de tierra (GSE) se verifica antes de
  usarlo con el _hardware_ de vuelo, igual que el de vuelo.
]

En resumen, un _spacecraft_ se ensaya en tierra —peso y balanceo, antenas en
cámara anecoica, vibración («_shake_»), vacío térmico («_bake_») y ensayos
previos al lanzamiento— y *también en órbita*: propulsores, despliegue de
todos los mecanismos, comunicaciones e instrumentos #diapo("11 A", 41). Qué
ambiente simular depende de adónde va: el del lanzador elegido; el espacial
(¿LEO, GEO o más allá de los cinturones de Van Allen?); el de una atmósfera
planetaria si entra en una; y el de una superficie si aterriza
#diapo("11 A", 42).

#cuidado[
  El _software_ también se verifica con los cuatro métodos, con su propia
  lectura #diapo("11 A", 44): *análisis* de los datos contra lo esperado
  (incluidos volcados de memoria); *inspección* del listado del código, los
  datos de ensayo y los documentos contra los estándares; *ensayo* en
  ambientes controlados, comparando salidas medidas con las predichas; y
  *demostración* por operación dinámica del programa, con un procedimiento
  «pasa o no pasa».
]

== Antes del modelo de vuelo: los modelos de ingeniería

#definicion("modelos de ingeniería (EDM, EM)")[
  Los modelos anteriores al protoflight o al prototipo #diapo("11 A", 45).
  El *EDM* (_Engineering Development Model_) prueba principios de diseño y
  produce datos para el diseño de detalle; es un subconjunto de la forma,
  el ajuste o la función del de vuelo y no necesita fidelidad a sus
  especificaciones. El *EM* (_Engineering Test Model_) prueba además los
  procesos de manufactura y tiene la forma, el ajuste y la función del de
  vuelo, aunque tampoco es fiel a sus especificaciones ni a sus procesos
  controlados.
]

#notacion[
  La lámina define *forma* (_form_) como la configuración del ítem —su
  geometría, densidad, peso y otros parámetros visuales— y *ajuste* (_fit_)
  como la habilidad del ítem de interfacearse físicamente con otro
  #diapo("11 A", 45). Es la #t[forma] de la unidad 2 con un pariente nuevo:
  el ajuste es la forma *vista desde la interfaz*.
]

#ejemplo("el Optimism, el gemelo del Perseverance en tierra", nivel: "a-fondo")[
  Un modelo de ingeniería no siempre se tira después de calificar. El
  _Optimism_ es una versión de ingeniería en escala real del rover
  Perseverance de Mars 2020, con ruedas, cámaras y computadoras para
  conducir en forma autónoma, y se usa para ensayar en tierra las
  operaciones y los comandos antes de mandárselos al rover en Marte
  #diapo("11 A", 46). Es el lazo de validación de la clase, del lado de las
  operaciones: antes de que el rover haga algo, lo hace su gemelo.
]
