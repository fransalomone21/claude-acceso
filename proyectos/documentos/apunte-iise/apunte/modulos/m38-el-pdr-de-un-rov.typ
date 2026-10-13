#import "../plantilla.typ": *

#modulo(
  "Una PDR de punta a punta: el ROV subacuático",
  [Saber para qué es una PDR y qué hay que cubrir en ella; preparar su
   presentación con los consejos de la cátedra; recorrer las funciones
   clave de la ingeniería de sistemas sobre un proyecto real —requerimientos
   por tipo, arquitectura por subsistemas, un _trade study_ con pesos
   calculado a mano, presupuestos de potencia y de masa, plan de V&V,
   documentos a entregar—; y entender por qué la madurez tecnológica se
   mira en la PDR, con el caso del Mars 2020.],
  clave: "el-pdr-de-un-rov",
)

#lectura[
  Clase 10, diapositivas 22 a 59.
]

== Para qué es una PDR, y qué se cubre

El módulo #M("fase-b-a-fondo") definió la PDR desde el lado de NASA: qué
revisa y qué baseline establece. La clase 10 la mira desde el lado *del
equipo que la presenta*, con un proyecto de ROV subacuático
#diapo(10, 22) #diapo(10, 24). Su propósito #diapo(10, 25): presentar el
«progreso del diseño» a los clientes y demás interesados para que lo
evalúen, con tres metas:

+ *validar la definición del problema*;
+ dialogar acerca de *tres o más diseños viables*;
+ *acordar el diseño elegido*.

Y, de paso, impresionar al cliente con las competencias y la
profesionalidad del equipo: construir confianza y credibilidad.

#clave[
  Qué cubrir en una PDR, según la cátedra #diapo(10, 26):
  - las *necesidades, requerimientos, restricciones y entregables*
    (documentos y productos);
  - los resultados del aprendizaje del proyecto;
  - *varios diseños viables*, con los pros y los contras de cada uno y
    *cómo se eligió* finalmente;
  - la estimación de los fondos y los costos;
  - una planificación que produzca los entregables con *abundante tiempo
    para la validación* del producto;
  - *identificar honestamente los problemas potenciales y los riesgos*, y
    cómo el plan va a lidiar con ellos.
]

#deduccion("la primera meta es validar el problema, no el diseño")[
  Fijate el orden: antes de mostrar un solo diseño, la PDR *valida la
  definición del problema*. Es la #t[validación (de requerimientos)] del
  módulo #M("verificacion-validacion-y-alcance") puesta como primer punto
  del orden del día: si el cliente no reconoce su problema en lo que
  presentás, el mejor diseño del mundo resuelve otra cosa. Y la sexta
  viñeta dice «honestamente»: un revisor desconfía mucho más de una lista
  de riesgos vacía que de una larga.
]

=== Cómo presentarla

La diapositiva 27 da consejos concretos para la presentación de la PDR, y
valen igual para el MCR del trabajo práctico:

- estén preparados para recibir la evaluación de los revisores; se les
  pide a los participantes que *vayan a fondo con las preguntas*;
- *planeen hablar entre 15 y 25 minutos* y dejen después *unos 40 minutos
  para el diálogo*;
- hagan una presentación elegante (o una página web), con un *flujo
  lógico* de un elemento al siguiente;
- *eviten las listas largas*: las diapositivas tienen que enfatizar lo que
  *no es texto* —dibujos, esquemas, *diagramas de bloques*, diagramas de
  flujo, ecuaciones, tablas—, con el texto justo para listar los puntos
  importantes y que cada diapositiva se explique sola (la descripción
  detallada va en el informe);
- impriman la presentación para la audiencia, *dos o tres páginas*, para
  que tomen notas;
- *numeren las diapositivas*, para poder referirse a ellas, sobre todo si
  alguien está conectado a distancia.

#posta[
  Hacé la cuenta: 15 a 25 minutos hablando y 40 de preguntas. La cátedra
  espera que *la mayor parte de la revisión sean preguntas*. No es un
  examen oral que hay que llenar hablando: es una conversación en la que
  tu presentación es la excusa. Preparar las respuestas a las preguntas
  probables vale tanto como preparar las diapositivas.
]

== Las funciones clave, recorridas sobre el ROV

La cátedra usa la matriz de funciones clave de la ingeniería de sistemas
—la del módulo #M("fase-a-a-fondo"), ahora citada como documento del
Goddard de NASA (GPG 7120.5)— como *índice* de la PDR del ROV
#diapo(10, 28) #diapo(10, 29), y la recorre fila por fila
#diapo(10, 30) #diapo(10, 47).

*Entender los objetivos* es, otra vez, el Ejercicio de Alcance:
necesidades, metas, objetivos, misión, hipótesis, restricciones,
autoridades y responsabilidades, y conceptos operacionales #diapo(10, 30).

*El ConOps* tiene que incluir, como mínimo #diapo(10, 31): la descripción
de las fases mayores con una línea de tiempo de las operaciones; los
escenarios operacionales; la estrategia de comunicaciones de punta a
punta y la arquitectura de los datos; el enfoque de comando y control;
las instalaciones operacionales; y los *eventos críticos* (despliegue o
activación, inserción en órbita, maniobras de mantenimiento o de
corrección, maniobras de fin de misión).

=== Los requerimientos, por tipo

Los requerimientos de alto nivel del ROV se presentan en tablas con *ID,
tipo, descripción, fuente, aprobación, prioridad y fecha*, separados por
tipo #diapo(10, 32) #diapo(10, 33) #diapo(10, 34): funcionales (RF: «el
sistema será un vehículo sumergible», «realizará tareas programadas»,
«sensará el ambiente», «será operado por un humano desde tierra»),
tecnológicos (RT: hidrófonos, cámaras, CPU de propósito general, IMU) y de
desempeño (RP: estanco hasta *40 m*, autonomía de *1 hora*, velocidad
máxima de *1 m/s*, menos de *30 kg*, no más de *50 × 50 × 50 cm*), más
las restricciones (costo por unidad menor a 10 000 dólares, terminado en
*un año*, de acuerdo con una normativa).

#cuidado[
  Las tablas son un ejemplo de la cátedra y traen defectos que el módulo
  #M("escribir-buenos-requerimientos") te enseñó a ver, así que no las
  copies tal cual: dicen «será» y «realizará» en vez de «deberá»; hay dos
  requerimientos con el mismo ID (RF 002); uno de desempeño repite uno
  funcional (las tareas programadas); «de una manera exacta y repetible» no
  se puede verificar; y los «tecnológicos» fijan la solución («usará una
  IMU») sin una rationale escrita que lo justifique. Las restricciones, en
  cambio, están bien marcadas como tales (*Restric*).
]

=== La arquitectura, por subsistemas

El análisis funcional parte al ROV en subsistemas, que «son
requerimientos» #diapo(10, 36): flotación, estructura, estanqueidad,
procesamiento, comunicación, propulsión, potencia, cámaras e iluminación,
y la carga útil de sensores. Para cada subsistema hay alternativas que se
comparan: la cátedra lo muestra con los _trades_ de un submarino para
Titán, donde cada subsistema (navegación, propulsión, potencia,
flotación, estructura, comunicaciones) lista sus opciones #diapo(10, 35).

=== El trade study, con la cuenta hecha

#definicion("trade study (estudio de alternativas con criterios ponderados)")[
  La comparación de varios diseños viables contra *criterios escritos de
  antemano, cada uno con su peso*: cada diseño recibe una nota por
  criterio, la nota se multiplica por el peso y la suma da el puntaje con
  que se elige #diapo(10, 38).
]

Los tres diseños del ROV #diapo(10, 37): el *1*, el sistema actual,
ya construido (marco de fleje de acero, dos compartimentos, cuatro
propulsores); el *2*, un sistema *balanceado* diseñado de cero (hasta seis
propulsores, CPU de propósito general, cámaras, hidrófonos e IMU); y el
*3*, uno *complejo y caro* (marco mecanizado por control numérico, cúpula
formada al vacío, propulsores vectoriales comerciales, CPU más GPU).

#figure(
  table(
    columns: (1.6fr, 0.8fr, 0.9fr, 0.9fr, 0.9fr),
    align: (left, center, center, center, center),
    stroke: 0.4pt + luma(180),
    [*Criterio*], [*Peso*], [*Diseño 1*], [*Diseño 2*], [*Diseño 3*],
    [Costo mínimo], [30 %], [8], [5], [2],
    [Robustez], [20 %], [5], [6], [8],
    [Exactitud], [15 %], [3], [8], [9],
    [Funcionalidad], [15 %], [3], [7], [8],
    [Trabajo], [10 %], [7], [4], [2],
    [Flexibilidad], [10 %], [3], [7], [7],
    [*Total*], [100 %], [*5,30*], [*6,05*], [*5,65*],
  ),
  caption: [Los criterios de evaluación de los tres diseños, con sus pesos (diapositiva 38).],
)

#deduccion("de dónde sale el 6,05, y qué dice")[
  El puntaje es la suma de nota × peso. Para el diseño 2:
  5 × 0,30 + 6 × 0,20 + 8 × 0,15 + 7 × 0,15 + 4 × 0,10 + 7 × 0,10 =
  1,50 + 1,20 + 1,20 + 1,05 + 0,40 + 0,70 = *6,05*. Con la misma cuenta,
  el diseño 1 da 5,30 y el 3 da 5,65. Gana el *balanceado*, y no por ser el
  mejor en algo: no gana en *ningún* criterio por separado (el 1 es el más
  barato y el que menos trabajo da; el 3, el más robusto, exacto y
  funcional). Gana porque no es malo en nada. Ojo con la lectura de dos
  filas: en «costo mínimo» y en «trabajo» la nota alta es para el diseño
  *más barato* y el que *menos trabajo* lleva —la nota mide qué tan bien
  cumple el criterio, no cuánto cuesta—.
]

#posta[
  El resultado depende de los pesos, y los pesos son una decisión del
  *interesado*, no del ingeniero. Si el cliente pusiera 50 % en costo, el
  diseño 1 ganaría. Por eso los criterios y los pesos se escriben *antes*
  de puntuar: si los elegís después de ver los números, cualquier diseño
  puede ganar, y el revisor lo sabe.
]

=== Diagramas de bloques y presupuestos

Las diapositivas 39 y 40 son dos diagramas de bloques del sistema de
vehículos universitarios: uno con los compartimentos, las baterías, la
computadora y los controladores de los propulsores; el otro con su
notación de líneas por tipo de conexión (analógica, disparo, potencia de
los propulsores, alimentación del controlador, serie, señal de control,
bus de datos). Es el diagrama funcional del módulo
#M("el-diagrama-funcional"), en la forma que se presenta en una PDR.

#figure(
  placement: auto,
  image("../figuras/c10-p040.png", width: 76%),
  caption: [Diagrama de bloques de un vehículo subacuático con la leyenda de tipos de conexión abajo a la izquierda (diapositiva 40).],
)

Los *presupuestos* de potencia y de masa #diapo(10, 41) son tablas que
suman el aporte de cada componente:

#figure(
  table(
    columns: (1.5fr, 1fr, 1fr, 0.8fr, 0.8fr, 1fr),
    align: (left, center, center, center, center, center),
    stroke: 0.4pt + luma(180),
    [*Componente*], [*Potencia (W)*], [*Uso por hora*], [*Wh*], [*Cantidad*], [*Total (Wh)*],
    [Propulsor], [55,5], [0,2], [11,1], [6], [66,6],
    [CPU], [45], [0,5], [22,5], [1], [22,5],
    [Controlador de motor], [0,625], [0,75], [0,469], [12], [5,625],
    [Salida de potencia], [22,2], [0,1], [2,22], [6], [13,32],
    [], [], [], [], [*Total*], [*124,7*],
  ),
  caption: [El presupuesto de potencia de un ROV: energía por hora de operación (diapositiva 41).],
)

#deduccion("cómo se lee una fila del presupuesto de potencia")[
  Un propulsor consume 55,5 W cuando anda, pero anda *el 20 % del tiempo*:
  en una hora gasta 55,5 × 0,2 = 11,1 Wh; seis propulsores, 66,6 Wh. La
  columna de «uso» —el *ciclo de trabajo*— es la que separa un presupuesto
  realista de uno que suma potencias pico. Con 124,7 Wh por hora de
  operación y el requerimiento de una hora de autonomía, la batería tiene
  que entregar al menos eso, *más el margen* del módulo
  #M("que-es-un-requerimiento-y-margenes"). En un satélite, la misma tabla
  se arma por órbita, con el eclipse como el tramo en que manda la batería.
]

El presupuesto de masa de la misma lámina suma cuatro propulsores de 7,5
libras, el marco con sus tapas (9,6), dos baterías de 2,4, la electrónica
(4,5) y el alojamiento del hidrófono (1,2): *50,1 libras*.

#cuidado[
  Las dos tablas de la diapositiva 41 no son del mismo vehículo: la de
  potencia cuenta *seis* propulsores y la de masa, *cuatro*. Como ejemplos
  sueltos sirven; en un proyecto real, los presupuestos de potencia, de
  masa y la lista de componentes *tienen que hablar del mismo diseño*, y
  un revisor que compara las tablas encuentra la diferencia en un minuto.
]

=== Las preguntas de los revisores

La cátedra anticipa qué van a preguntar los revisores de la PDR del ROV
#diapo(10, 42) #diapo(10, 43) #diapo(10, 44): *sobre la física* —la
flotación, la estabilidad, el empuje—; *sobre los grados de libertad*
—un vehículo rígido tiene seis: avance, desplazamiento lateral, arfada,
rolido, cabeceo y guiñada; ¿cuántos se controlan activamente, y con
cuántos motores?, ¿ocho propulsores para controlar guiñada, cabeceo,
arfada, avance y rolido?—; y *sobre la arquitectura del software de a
bordo*: planear la misión, controlar los motores, el servidor de visión,
el de actuación, la interfaz del usuario y la telemetría.

#figure(
  placement: auto,
  image("../figuras/c10-p043.png", width: 72%),
  caption: [Los seis grados de libertad de un vehículo subacuático, con sus fuerzas, momentos, velocidades y posiciones (diapositiva 43).],
)

#posta[
  Para el MCR del trabajo práctico el equivalente es directo: ¿qué órbita,
  y por qué esa?, ¿cuánto pesa y cuánta potencia necesita, aunque sea a
  ojo?, ¿cómo baja los datos?, ¿cómo se apunta? Si tu informe no tiene la
  respuesta, que por lo menos tenga la pregunta escrita como un TBD con su
  plan para resolverla.
]

=== El plan de V&V y los documentos

El plan de V&V del ROV #diapo(10, 46): los ensayos se hacen durante toda
la integración; integrada la estructura primaria con su carga, se
verifica la *flotabilidad*; a lo largo de todo el proceso se verifica que
los compartimentos estancos lo sean, *simulando la presión de trabajo más
un factor de seguridad*; se ensayan los movimientos de todos los motores y
sus límites con el _joystick_; y al final, el ROV en su ambiente, con todos
los movimientos y los sensores. *Cada ensayo se describe con su método y
se convierte en un procedimiento paso a paso, certificado.*

Los documentos que el proyecto entrega #diapo(10, 52): la especificación
de requerimientos, la síntesis del sistema, la planificación del proyecto,
la especificación de diseño (sistema e interfaces), el plan de AIV y de
ensayos, el protocolo de ensayos con sus resultados, el manual del
usuario, el reporte técnico, un documento de reflexión sobre el proyecto,
una página web, un video de presentación, las *minutas de las reuniones*
semanales y el *contrato del grupo*, que establece los términos de
ejecución del proyecto.

== La madurez tecnológica en la PDR: el Mars 2020

La clase cierra el ROV con un caso real de NASA. El calendario del Mars
2020 #diapo(10, 55): KDP-A en noviembre de 2013, KDP-B en mayo de 2015,
*PDR en febrero de 2016*, KDP-C en junio de 2016, CDR en febrero de 2017 y
lanzamiento entre julio y agosto de 2020.

La escala es el #t[TRL — nivel de madurez tecnológica] del módulo
#M("trl-irl-srl"), que la clase repasa #diapo(10, 56). Y la regla, ahora
con su fuente #diapo(10, 57): las guías de NASA y de la
oficina de auditoría del gobierno de los Estados Unidos (GAO) establecen
que *las tecnologías críticas tienen que estar por lo menos en TRL 6 cuando
el proyecto completa la PDR*. En la PDR del Mars 2020, *cinco de sus siete
tecnologías críticas* —entre ellas el sello del mecanismo que guarda las
muestras— estaban en TRL 5 o menos #diapo(10, 58). Los responsables lo
reconocieron y lo trataron en su presentación del KDP-C, con un plan de
mitigación del riesgo que se aceptó; para diciembre de 2016 las
tecnologías del sistema de muestreo ya estaban en TRL 6, y la
recomendación fue validar todas antes del CDR.

#cuidado[
  Esta es la lámina que sostiene el umbral de TRL 6 del módulo
  #M("fase-b-a-fondo"): la clase 10 lo da con su fuente —la guía de NASA y
  de la GAO— y con un caso en el que *no se cumplió*: el Mars 2020 pasó la
  PDR con cinco tecnologías por debajo, y lo que hizo falta fue un plan de
  mitigación aprobado en la compuerta. La regla es una guía fuerte, no una
  ley física: se puede romper, pero se paga con un riesgo declarado.
]

El ejemplo de la cátedra de una tecnología agregada en el camino es el
*helicóptero* del Mars 2020 #diapo(10, 54) #diapo(10, 59): unos 1,4 kg y
1,2 m entre las puntas de las palas, para volar delante del _rover_ y
ayudar a planificar las rutas; el helicóptero y sus componentes asociados
le suman *10 kg* a la masa del vehículo, y NASA aprobó su desarrollo y
ensayos para el año fiscal 2016, antes de decidir si seguía.
