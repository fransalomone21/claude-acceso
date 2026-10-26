#import "../plantilla.typ": *

#modulo(
  "La gestión de interfaces y los cuatro tipos canónicos",
  [Explicar por qué las interfaces son el punto débil de un sistema, con el
   Ariane 5; clasificar cualquier interfaz en uno de los cuatro tipos
   canónicos —conexión física, flujo de energía, de masa, de información—
   con su magnitud y su dirección; y anotarlas en una DSM o tabla N²,
   simétrica o no según el tipo.],
  clave: "gestion-de-interfaces",
)

#lectura[
  Clase 13, diapositivas 1 a 16. Buena parte sale del curso 16.842,
  _Fundamentals of Systems Engineering_, del MIT (2015), que la cátedra cita
  al pie de las láminas.
]

== Por qué las interfaces

La clase 13 es la última de contenidos, y su temario tiene tres puntos: la
gestión de interfaces, la gestión del riesgo y la revisión de alistamiento
para el vuelo #diapo(13, 2). Este módulo es el primero; los otros dos, el
siguiente.

La mayor parte del esfuerzo se gasta en diseñar las *partes* de un sistema
—su funcionalidad, sus tolerancias, su tiempo medio entre fallas—, y las
interfaces quedan a menudo despreciadas, cuando son *el punto débil del
sistema*: cuellos de botella, fallas estructurales, llamadas a funciones
erróneas #diapo(13, 3).

#ejemplo("el vuelo 501 del Ariane 5", nivel: "a-fondo")[
  El 4 de junio de 1996, la primera prueba de vuelo del Ariane 5 explotó 37
  segundos después del lanzamiento por un mal funcionamiento del _software_
  de control #diapo(13, 3).

  _Lo que la lámina no cuenta, del informe de la comisión que investigó el
  accidente:_ el _software_ del sistema de referencia inercial se había
  reutilizado del Ariane 4, y una conversión de un número que en el Ariane
  5 —más rápido— resultaba demasiado grande desbordó la variable. Ningún
  componente estaba «roto»: el _software_ funcionaba para el cohete para el
  que se escribió. Lo que falló fue la interfaz entre ese _software_ y un
  vehículo nuevo.
]

Los sistemas complejos se diseñan y se construyen de a poco, por equipos
distribuidos geográficamente, y eso exige definir las interfaces con mucho
cuidado #diapo(13, 4). La lámina da seis razones para gestionarlas
#diapo(13, 5):

- los sistemas complejos tienen muchas interfaces;
- las interfaces estándar reducen la complejidad;
- la arquitectura decide qué tipos de interfaz se usan en el diseño;
- identificarlas y definirlas con claridad reduce los riesgos;
- *la mayoría de los problemas de los sistemas están en las interfaces*;
- verificarlas todas es crítico para la compatibilidad y las operaciones.

#clave[
  Las interfaces son *externas* —con lo que está afuera del sistema— o
  *internas*. La cátedra lo muestra con el sistema de una cámara de fotos y
  todos sus accesorios: flashes, lentes, baterías, cargadores, cables, la
  computadora, la impresora, la tele #diapo(13, 6). Cada línea del dibujo es
  una interfaz que alguien tuvo que especificar. Es la distinción que la
  consigna del trabajo práctico pide en el N² (módulo
  #M("fase-a-a-fondo"), sección de interfaces internas y externas).
]

== Qué pasa por una interfaz

#figure(
  table(
    columns: (1fr, 1.3fr, 1fr, 1fr),
    align: (left, left, left, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header([*De*], [*Qué pasa*], [*Magnitud*], [*A*]),
    [válvula], [flujo de masa], [$dot(m)$], [tanque],
    [cohete], [cantidad de movimiento], [$F thin Delta t$], [carga útil],
    [intercambiador de calor], [flujo de calor], [$dot(Q)$], [aire],
    [celda solar], [(dice «flujo de masa»)], [$V times I$], [batería],
    [sitio web (URL)], [archivo HTML], [datos], [navegador],
    [sensor de movimiento], [disparo (_trigger_)], [comando], [alarma],
    [radio], [novedades], [cognitivo], [oyente],
    [paciente], [sentimientos], [afectos], [psicólogo],
  ),
  caption: [Ejemplos de interfaces #diapo(13, 7).],
)

#cuidado[
  La celda solar no le pasa *masa* a la batería: le pasa *energía*, y la
  magnitud que la lámina escribe abajo, $V times I$, es una potencia
  #diapo(13, 7). El rótulo «flujo de masa» es un error de copia de la
  fila de la válvula. Si te lo preguntan: flujo de energía.
]

== Los cuatro tipos canónicos

#definicion("interfaces canónicas")[
  Los cuatro tipos con que se describe cualquier interfaz #diapo(13, 8):
  la *conexión física* (siempre simétrica: si A se conecta con B, B se
  conecta con A), el *flujo de energía*, el *flujo de masa* y el *flujo de
  información*.
]

=== Conexión física

Dos partes están físicamente conectadas si *se tocan* (rodillos, la pastilla
y el disco de un freno, el dedo y la pantalla táctil), si tienen una
*conexión reversible* (un conector eléctrico, un puerto USB, un pestillo,
tornillos y tuercas) o si están *unidas para siempre* (remaches, soldadura
de punto, fundido; y la lámina se anima con un «¿compilado?» para el
_software_) #diapo(13, 9). Lo que se transmite son fuerzas (N) y torques
(N·m).

#figure(
  placement: auto,
  image("../figuras/c13-p010.png", width: 68%),
  caption: [Conexión física: el vínculo estructural irreversible (soldadura; en _software_, el compilado, donde los objetos se funden en un ejecutable) y el reversible (bulones, un conector RJ-45) #diapo(13, 10).],
)

#definicion("DSM (matriz de estructura de diseño)")[
  La matriz que captura la conectividad de los componentes —la
  arquitectura— y da una capacidad de análisis que los esquemas
  tradicionales no tienen; la cátedra la escribe «DSM o N²»
  #diapo(13, 9). Para las conexiones físicas es *simétrica*: acción y
  reacción.
]

#notacion[
  La DSM es la #t[tabla N²] de las unidades 2 y 7 con otro nombre y una
  convención: en la DSM, que A se conecte con B y B con A llena las dos
  casillas espejadas. En el N² de la unidad 7 la casilla dice *qué* pasa
  de un elemento a otro; en la DSM de la conexión física, sólo *que* están
  conectados.
]

=== Flujo de energía

Hay flujo de energía si hay un *intercambio neto de trabajo* entre dos
componentes; se mide en potencia, $P = dif L slash dif t$, en W
#diapo(13, 11). Toma varias formas:

- *eléctrica*, la más común: continua (12 V, 5 V, 24 V…) o alterna (220 V
  50 Hz…), con $P = V I$;
- *térmica*: el flujo de calor $dif Q slash dif t$, por conducción,
  convección y radiación;
- *de RF*: microondas (2,4 GHz, 5,8 GHz…);
- *mecánica*: lineal, $P = F v$; rotativa, $P = tau omega$.

El flujo de energía suele implicar una conexión física (cables,
superficies conductoras), *pero no siempre*: la RF y la radiación térmica
no la necesitan #diapo(13, 11). Y está *dirigido*: va de un punto a otro,
así que su DSM ya no es simétrica #diapo(13, 12).

#cuidado[
  La nota importante de la lámina #diapo(13, 12): primero se mapean las
  interacciones *deseadas*, y después se descubren más de las *no
  deseadas*, como los flujos de calor residuales. El calor que disipa una
  electrónica no está en ningún requerimiento funcional y es una interfaz
  igual: con el subsistema térmico.
]

=== Flujo de masa

Hay flujo de masa si se intercambia materia entre dos elementos, $dif m
slash dif t$ en kg/s: fluidos (refrigerante, combustible, agua), gases
(aire, gases de escape) o sólidos (tóner, papel) #diapo(13, 13). Típicamente
implica una conexión física debajo, va *de la fuente al sumidero* y puede
formar un lazo continuo.

=== Flujo de información

Muchos sistemas electromecánicos reemplazaron funciones mecánicas con
_software_, y la información fluye por tres motivos #diapo(13, 14): la
interacción con el usuario u operador (interfaces gráficas, entradas y
salidas), con otros dispositivos (analógica con ADC y DAC, digital,
inalámbrica) y el control interno (sensores, actuadores, controladores,
filtros, amplificadores). *Siempre está dirigido*: en un satélite, la
*telemetría* baja (¿cómo se está comportando mi sistema?) y los *comandos*
suben.

#figure(
  placement: auto,
  image("../figuras/c13-p015.png", width: 58%),
  caption: [El lazo de control como flujo de información: el controlador actúa sobre la planta a través del actuador, el sensor mide, el comparador contrasta con la señal de referencia y el operador la fija #diapo(13, 15).],
)

== Los cuatro, en una tabla

#figure(
  table(
    columns: (1.1fr, 0.9fr, 1.5fr, 1.6fr),
    align: (left, left, left, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header([*Tipo*], [*Operando*], [*Proceso*], [*Forma que toma*]),
    [Conexión física], [fuerzas, torques (N, N·m)], [transmitir fuerza o torque], [bulones, arandelas, remaches, soldaduras de punto],
    [Flujo de energía], [trabajo (J)], [transmitir electricidad o calor], [cables de cobre, microondas],
    [Flujo de masa], [masa (kg)], [transmitir fluido, gas o materia sólida], [líneas de combustible, conductos de aire, caños de escape],
    [Flujo de información], [bits], [transmitir datos o comandos], [microinterruptores, RF inalámbrica, humanos],
  ),
  caption: [Los cuatro tipos canónicos de interfaz con su operando, su proceso y su forma #diapo(13, 16).],
)

#posta[
  Para el N² del trabajo práctico, esta tabla es la regla para llenar cada
  casilla: no «se conecta con», sino *qué tipo* de interfaz es y *qué
  pasa*. El panel solar y la batería: energía, en W. La computadora y el
  transmisor: información, en bits. La estructura y el panel: conexión
  física. Y si una casilla tiene dos tipos —un cable que lleva potencia y
  datos— son dos interfaces, y las dos van.
]
