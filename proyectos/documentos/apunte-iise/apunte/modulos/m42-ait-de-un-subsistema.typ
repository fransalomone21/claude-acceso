#import "../plantilla.typ": *

#modulo(
  "Los ensayos de un subsistema: el control de actitud de los SAC",
  [Ordenar los ensayos eléctricos de un subsistema por profundidad (de vida,
   funcional, abarcativo) y decir cuándo se usa cada uno, del laboratorio al
   _pad_; describir un subsistema por sus funciones; y recorrer un AIT real
   —el control de actitud y órbita de los satélites SAC— con su herencia,
   su filosofía protoflight, sus modos y sus secuencias de ensayo.],
  clave: "ait-de-un-subsistema",
)

#lectura[
  Clase 11 B, diapositivas 1 a 23.
]

== Los ensayos de un subsistema, del más rápido al más profundo

#definicion("ensayos funcionales de un subsistema (AT, FT, CPT)")[
  Tres profundidades de ensayo eléctrico #diapo("11 B", 2). El *de vida*
  (_aliveness test_, AT) verifica que el _hardware_ del subsistema y su
  redundante estén vivos —que funcionen la potencia y el camino de las
  señales, que la telemetría responda—, sin estímulo externo. El
  *funcional* (FT) aplica un estímulo externo y verifica la respuesta
  eléctrica o mecánica en el modo operacional mayor, con el _hardware_
  primario y el secundario. El *de desempeño abarcativo* (CPT) es el más
  profundo: todos los modos operacionales y de contingencia, todos los
  comandos, datos y caminos, incluidos los redundantes, para verificar todos
  los requerimientos.
]

#clave[
  Las tres son la misma pregunta con distinto presupuesto de tiempo. El AT
  es el chequeo rápido: al encender el subsistema, durante un ensayo
  ambiental cuando el ambiente no deja hacer algo más extenso, y *después de
  manipular o mudar el satélite* #diapo("11 B", 2). El CPT es caro y se
  reserva para los hitos: antes y después de los ambientales, antes de cada
  envío y en el sitio de lanzamiento.
]

Encima de esos tres hay ensayos que miran el subsistema *en movimiento*
#diapo("11 B", 3) #diapo("11 B", 4):

- *de fase*, de sensores y actuadores: se estimula físicamente el sensor y
  se compara con la predicción lo que sale de él, lo que entra a la
  computadora y lo que llega a la telemetría; si el sensor no está, se usa
  el equipo de soporte de tierra (GSE). Hecho de punta a punta sobre el
  sistema integrado, es el ensayo *de fase del sistema*;
- *de modo orbital*: la compatibilidad de todos los elementos y la
  habilidad del subsistema integrado de operar en su modo orbital normal;
- *especiales* del control de actitud: la fase de punta a punta (que el
  subsistema respete las coordenadas de referencia y los *signos*
  convenidos), las *transiciones entre modos*, la *lógica de detección de
  fallas* de a bordo y las *comunicaciones* (el camino entre los comandos y
  la telemetría).

#deduccion("por qué hay un ensayo sólo para los signos")[
  Un sensor de actitud montado al revés, o una convención de ejes distinta
  entre dos equipos, no rompe nada en un ensayo funcional: cada pieza
  responde, y responde bien. El error aparece recién cuando se cierra el
  lazo —el actuador corrige *para el otro lado* y el satélite, en vez de
  estabilizarse, gira cada vez más—. Por eso el ensayo de fase estimula el
  sensor *de verdad* y sigue la señal hasta la telemetría: es el único que ve
  la cadena entera. Es una falla de interfaz, no de componente.
]

En el *sitio de lanzamiento* hay ocho ensayos mayores
#diapo("11 B", 5): verificación de fugas, CPT, ensayo general de las
actividades en el _pad_, verificación eléctrica del umbilical, ensayo
funcional en el _pad_, ensayo de RF omnidireccional, ensayo compuesto de
alistamiento eléctrico y ensayo general de la misión. Al llegar, después de
la inspección del transporte, se cargan las baterías de vuelo y se corre un
*CPT* que repite los últimos del AIT, con el mismo GSE que en los
ambientales; y el *ensayo funcional en el _pad_* verifica que el transporte
no dañó nada #diapo("11 B", 6).

== Un subsistema se describe por sus funciones

Antes del ejemplo, la cátedra dibuja tres subsistemas sobre un mismo
satélite, rotulando *qué hace* cada pieza #diapo("11 B", 7)
#diapo("11 B", 8) #diapo("11 B", 9):

#figure(
  placement: auto,
  image("../figuras/c11b-p007.png", width: 80%),
  caption: [El subsistema de control de actitud y órbita, por sus funciones #diapo("11 B", 7): determinar posición y velocidad, rotación y actitud; cambiar la actitud y la velocidad; ejecutar los algoritmos de determinación y control.],
)

- *control de actitud y órbita*: sensores + actuadores + CPU = AOCS;
- *potencia*: colectar energía + almacenar + distribuir = PS (generar
  potencia, rotar paneles, almacenarla, distribuirla, prender y apagar
  equipos, definir modos de operación, colectar datos de telemetría);
- *gestión de datos y comunicaciones*: gestionar datos + distribuir
  comandos + CPU = C&DH; comunicar datos + recibir comandos = CS (proveer
  enlace con Tierra, proveer el tiempo, procesar telecomandos, generar
  telemetría).

#posta[
  Fijate que los rótulos son *verbos*: «determinar actitud», «distribuir
  potencia», «proveer tiempo». Es el diagrama funcional de la unidad 8 y la
  función de la unidad 2: un subsistema no es la lista de sus cajas, es lo
  que esas cajas hacen juntas. Así se dibuja el diagrama de subsistemas del
  trabajo práctico.
]

== Un caso real: el control de actitud de los SAC

El ejemplo de la clase es el AIT del subsistema de control de actitud y
órbita (A&OCS) de los satélites argentinos SAC #diapo("11 B", 10):
el SAC-B #diapo("11 B", 11) y su diagrama de _hardware_ #diapo("11 B", 13),
y el SAC-C en el resto de las láminas.

#cuidado[
  La clase mezcla los dos satélites sin avisar: la 11 y la 13 dicen SAC-B;
  la 12 y la 18, SAC-C #diapo("11 B", 11) #diapo("11 B", 12)
  #diapo("11 B", 13) #diapo("11 B", 18). La tabla de componentes y la de
  sensores y actuadores nombran al SAC-B como *herencia*, así que el
  satélite que se integra es el SAC-C.
]

=== Herencia y protoflight, componente por componente

#figure(
  table(
    columns: (1.6fr, 1.5fr, 0.7fr, 1.9fr),
    align: (left, left, center, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header([*Componente*], [*Proveedor*], [*Cant.*], [*Herencia*]),
    [Rueda de reacción (A)], [ITHACO], [2], [TOMS, Wake Shield],
    [Bobina de torque magnético (A)], [propia], [3], [ninguna],
    [Sensor de Tierra (S)], [ITHACO], [2], [TOMS, Wake Shield],
    [Magnetómetro (S)], [SAIC], [2], [SAC-B, SAC-A],
    [Sensor de estrellas (S)], [Kayser-Threde], [1], [TUBSAT (Alemania)],
    [DGPS (S)], [LABEN], [1], [SAC-A],
    [Sensor solar grueso, CSS (S)], [FIAR], [8], [SAC-B],
    [DTM (A)], [—], [4], [ninguna],
  ),
  caption: [Sensores (S) y actuadores (A) del A&OCS, con su herencia #diapo("11 B", 15).],
)

La tabla de componentes #diapo("11 B", 12) dice, para cada uno, de dónde
viene y cómo se verifica. Los de *diseño nuevo* —la tarjeta de los
_drivers_ de los magnetorquers, la de señales del control de empuje, las
barras de torque— se *califican a nivel de componente*; los *heredados* —las
ruedas y los sensores de horizonte, el magnetómetro, los sensores solares,
el sensor de estrellas, el GPS— pasan sólo un *ensayo de aceptación*. Y a
nivel de sistema, todos con el mismo criterio: *nivel de calificación,
tiempo de aceptación (filosofía protoflight)*.

#deduccion("la filosofía de modelos, aplicada a cada caja")[
  Es el gráfico de niveles del módulo #M("modelos-y-ensayos") resuelto
  componente por componente. Lo que ya voló en otro satélite tiene su
  diseño calificado: sólo hay que aceptar *esta unidad*. Lo nuevo no tiene
  quién lo respalde: hay que calificarlo. Y el satélite entero, que es uno
  solo y es el que vuela, va como protoflight. La herencia no es un dato de
  color en la tabla: *decide cuánto se ensaya*.
]

=== El plan, los modos y las secuencias

El plan de integración y ensayos tiene cuatro fases #diapo("11 B", 14):

+ el *modelo de ingeniería*: verificar los requerimientos eléctricos,
  demostrar la compatibilidad del sistema antes del modelo de vuelo y
  desarrollar la validación del _software_ y el GSE;
+ la *caja de electrónica de vuelo*: su verificación con criterio
  protoflight y la aceptación del _software_;
+ la *integración en el satélite*: instalar los componentes, el ensayo de
  fase, la verificación de interfaces, y después AT, FT, CPT, modo orbital
  y los especiales (punta a punta, detección de fallas y recuperación);
+ los *ensayos del satélite*: los ambientales, un CPT antes de cada envío
  (a Brasil y a Estados Unidos, dice la lámina) y, en el sitio de
  lanzamiento, CPT, funcional y de vida.

#figure(
  table(
    columns: (1.2fr, 3.4fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    table.header([*Modo*], [*Qué hace*]),
    [_Safe hold_], [apunta a la Tierra sin precisión; el mástil (_boom_) ayuda como gradiente de gravedad y el lazo de cabeceo mantiene el momento angular normal a la órbita. Condiciones estables de potencia y térmicas],
    [Apuntamiento al Sol], [apunta los paneles al Sol sin requerimiento de precisión: maximiza la potencia, o resuelve la emergencia de perder la señal de la Tierra],
    [_B-dot_], [el más simple: en cada eje, el negativo de la derivada del campo magnético terrestre. Reduce las velocidades de giro del desprendimiento (_tip-off_)],
    [Misión], [mantiene la terna LVLH según los requerimientos],
    [Propulsión], [mantenimiento de la órbita: el modo misión más el comando a los propulsores],
  ),
  caption: [Los modos del A&OCS #diapo("11 B", 17).],
)

Para ensayar los modos sin espacio, el satélite *vuela su órbita en
tierra*: el GSE de control de actitud tiene un simulador de vuelo y un
simulador de GPS que le cierran el lazo a la computadora, con monitores
aparte #diapo("11 B", 18). Las secuencias de ensayo del modelo de
ingeniería y del de vuelo #diapo("11 B", 19) #diapo("11 B", 20) ordenan
todo: la del de vuelo va CPT → vibración y choque en tres ejes → vacío
térmico → EMC → propiedades de masa → CPT → revisión del análisis →
entrega.

#clave[
  Mirá dónde están los dos CPT de la secuencia de vuelo: *antes y después*
  de los ambientales. El primero es la referencia; el segundo, la prueba de
  que la vibración y el vacío térmico no cambiaron nada. Es la «firma» del
  barrido de vibraciones del módulo #M("modelos-y-ensayos"), aplicada al
  subsistema entero.
]

=== Cruzar una pared: los pasamuros

Para ensayar en vacío hay que sacar las señales de la cámara sin romper el
vacío: un _feed-through_ de vacío es un conector que atraviesa la pared con
sus pines sellados #diapo("11 B", 21). El mismo problema tiene el ROV de
las clases 8 y 10 al revés: los conectores _SubConn_ llevan potencia y
datos a través de una tapa estanca bajo el agua #diapo("11 B", 22)
#diapo("11 B", 23). Es la interfaz física más literal que da la
materia: una pared que separa dos ambientes, y algo que tiene que pasar sin
que pase el ambiente.
