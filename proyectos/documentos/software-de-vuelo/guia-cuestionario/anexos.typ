// Anexos de la guía del cuestionario: definiciones robustas con un ejemplo
// cotidiano, y las palabras que se dan por sabidas. Lo incluye guia.typ al final.

#import "plantilla.typ": *

#pagebreak()

= Anexo A — Las definiciones, completas y con un ejemplo <sec-anexo-def>

El cuerpo de la guía va rápido a propósito. Acá está cada concepto con la
definición entera, como la escribirías en un examen que pide precisión, y un
ejemplo de la vida diaria para que se entienda antes de memorizarlo. Las
definiciones salen de las clases de Leandro; los ejemplos cotidianos son
nuestros y sirven para entender, no para contestar con ellos. Están en el
mismo orden que la guía.

== Confiabilidad y radiación

#definicion[Confiabilidad][La capacidad de un sistema de seguir cumpliendo
su función durante toda la misión, en su entorno, aun cuando algunas de sus
partes fallen. No es que nada falle: es que las fallas estén previstas y el
sistema se recupere.][un auto con rueda de auxilio no es un auto al que no
se le pinchan las gomas: es uno que, cuando se le pincha una, sigue viaje.]

#definicion[COTS y rad-hard][COTS (_Commercial Off-The-Shelf_) son
componentes comerciales, de catálogo, no diseñados para radiación: baratos,
disponibles y potentes, pero toleran poca dosis (2-10 krad). Rad-hard son
componentes endurecidos por diseño y proceso para el espacio: toleran 100 a
1000+ krad y millones de veces menos errores, a cambio de costo, peso y poca
disponibilidad.][un celular común contra un handy militar: el celular hace
más cosas y cuesta menos, pero el handy aguanta que se le caiga de un
camión.]

#definicion[TID (dosis ionizante total)][El efecto *acumulativo* de la
radiación: carga atrapada en el óxido de los transistores que corre sus
umbrales de conducción y degrada el componente a lo largo de la misión. Se
mide en rad o gray y define la *vida útil*.][el sol sobre una remera:
cada día la destiñe un poco, y no hay un día en que «se rompa»; un día
simplemente ya no es negra.]

#definicion[SEE, SEU y SEL][Un SEE (_Single Event Effect_) es el efecto de
*una sola* partícula que impacta en el lugar justo. Si da vuelta un bit de
una memoria o registro sin dañar el hardware es un *SEU* (_upset_, blando);
si dispara un tiristor parásito del CMOS y una corriente alta que, sin
protección, quema el chip, es un *SEL* (_latch-up_, duro).][SEU: alguien te
cambia una cifra del número de teléfono anotado en la heladera; el papel está
sano, el dato está mal. SEL: un cortocircuito en la zapatilla; si no salta
la térmica, se quema.]

#definicion[EDAC / código Hamming SECDED][Detección y corrección de errores:
se guardan bits de control calculados a partir del dato. Al leer, se
recalculan; si no coinciden, se sabe que hubo un error y, con Hamming
SECDED, se corrige uno y se detectan dos por palabra.][el dígito
verificador del CUIT o de una tarjeta: si te equivocás en un número al
tipearlo, el sistema se da cuenta. Hamming va un paso más: además sabe
*cuál* número cambió y lo arregla.]

#definicion[Scrubbing][Recorrer periódicamente toda la memoria leyéndola
con EDAC, corrigiendo cada error de un bit y reescribiendo el dato bueno,
para que no se acumulen dos errores en la misma palabra (que Hamming ya no
corregiría).][pasar el trapo por la mesada cada tanto: una mancha se saca
fácil; si dejás que se junten, ya no sale.]

#definicion[Redundancia DMR, TMR y en frío][DMR: dos módulos iguales en
paralelo cuyas salidas se comparan; detecta la falla pero no sabe cuál
módulo falló. TMR: tres módulos y un votador por mayoría; enmascara la
falla y sigue. En frío: un respaldo apagado que se enciende cuando falla el
principal.][DMR son dos relojes que no coinciden: sabés que uno anda mal,
no cuál. TMR son tres: los dos que coinciden tienen razón. En frío es el
reloj de repuesto guardado en el cajón.]

#definicion[Lockstep][Dos núcleos del mismo procesador ejecutan las mismas
instrucciones al mismo tiempo y una lógica compara sus salidas en cada
ciclo; ante una diferencia dispara una excepción. Es DMR dentro del
silicio, como en el Cortex-R del TMS570.][dos contadores que cuentan la
misma plata en paralelo y comparan el total antes de cerrar la caja.]

#definicion[Watchdog][Un temporizador que el software tiene que reiniciar
antes de que venza; si no lo hace, el watchdog asume que el programa se
colgó y resetea el procesador. El externo es un componente aparte, y por eso
sirve aunque el micro se cuelgue entero.][el «hombre muerto» del tren: el
maquinista tiene que apretar un pedal cada tanto; si deja de hacerlo, el
tren frena solo.]

#definicion[FDIR][_Fault Detection, Isolation and Recovery_: la función de
la OBC que detecta una falla, la aísla para que no se propague y lleva al
sistema a un estado recuperado o seguro.][el disyuntor de tu casa: detecta
la fuga, corta ese circuito y el resto de la casa sigue con luz.]

#definicion[OBC y C&DH][El C&DH (_Command and Data Handling_) es el
subsistema que maneja los datos del satélite: recibe telecomandos, junta y
guarda la telemetría, lleva el tiempo. La OBC es su computadora: el hardware
y el software que lo hacen.][el C&DH es la administración de un
edificio; la OBC, el administrador con su computadora.]

== Arquitectura

#definicion[Procesador y microcontrolador][El procesador (núcleo) es la
unidad que ejecuta instrucciones: pipeline, registros, ALU, controlador de
interrupciones. El microcontrolador es un chip que integra el núcleo con su
memoria flash, su RAM y sus periféricos (UART, SPI, ADC, timers).][el
núcleo es el motor; el microcontrolador, el auto entero con el motor
adentro.]

#definicion[Harvard y Von Neumann][Von Neumann: instrucciones y datos
comparten un único bus, y no se puede buscar una instrucción mientras se lee
un dato. Harvard: buses separados para cada uno, y las dos cosas pasan en el
mismo ciclo. El Cortex es Harvard en los buses con un único mapa de
memoria.][una cocina con una sola mesada (o cortás o emplatás) contra una
con dos.]

#definicion[Interrupción, ISR y NVIC][Una interrupción es un aviso del
hardware que corta el programa para atender un evento; la ISR es la
función que lo atiende; el NVIC es el controlador que las prioriza, permite
que una más urgente corte a otra (anidado) y busca solo la dirección de cada
ISR en la tabla de vectores (vectorizado).][el timbre mientras cocinás:
dejás lo que hacías, abrís la puerta y volvés. El NVIC decide que si suena
el detector de humo, ese gana sobre el timbre.]

#definicion[Excepción y fault][Una excepción es todo evento que desvía el
flujo normal: reset, interrupciones, llamadas al sistema y fallas. Un fault
es la excepción que señala algo anómalo (acceso a memoria inválido,
instrucción indefinida) y entra a su handler, que en vuelo alimenta al
FDIR.][un fault es el GPS que te dice «ruta imposible»: no podés seguir
como venías y alguien tiene que decidir qué hacer.]

#definicion[Pila (stack) y heap][La pila es memoria que se apila y desapila
sola con cada llamada a función (variables locales, argumentos, dirección de
retorno). El heap es memoria que se pide y se devuelve a mano (`malloc`,
`free`), sin un orden fijo.][la pila es una pila de platos: el último que
pusiste es el primero que sacás. El heap es un depósito donde guardás cajas
donde haya lugar, y si te olvidás de retirarlas, quedan ocupando.]

#definicion[`.text`, `.data` y `.bss`][Secciones fijas de la memoria de un
programa: `.text` guarda el código; `.data`, las variables globales y
`static` inicializadas con un valor; `.bss`, las que no tienen valor inicial
(arrancan en cero). Existen antes de que corra `main()`.][`.text` es el
recetario; `.data`, los frascos que ya vienen con algo; `.bss`, los frascos
vacíos etiquetados.]

== C de vuelo

#definicion[`volatile`][Calificador que le dice al compilador que la
variable puede cambiar por fuera del flujo del programa (hardware, una ISR,
otra tarea), así que tiene que leerla de memoria cada vez y no puede
optimizar esas lecturas.][mirar el celular cada vez que querés saber la
hora, en vez de acordarte de la hora que viste hace un rato.]

#definicion[`static` y `const`][`static` en una variable local la hace
durar toda la ejecución y conservar su valor entre llamadas; en una global o
una función, la deja visible sólo en su archivo. `const` declara que algo no
se modifica y convierte un intento de escribirlo en un error de
compilación.][`static` local es la libreta que queda en el escritorio entre
reunión y reunión; `const` es un cartel de «no tocar» que el compilador hace
respetar.]

#definicion[Puntero][Una variable que guarda la dirección de memoria de
otra. Con `&` se obtiene una dirección, con `*` se llega a lo que está ahí.
Pasar un puntero a una función le permite modificar el original.][la
dirección de una casa anotada en un papel: el papel no es la casa, pero con
él podés ir y pintarla.]

#definicion[Puntero a función y callback][Un puntero a función guarda la
dirección del código de una función para llamarla de forma indirecta. Un
callback es un puntero a función que se le entrega a otro módulo para que lo
llame cuando ocurra un evento.][dejarle tu número al mecánico: él no sabe
qué vas a hacer con la noticia; sólo te llama cuando el auto está listo.]

#definicion[Máquina de estados][Un modelo en el que el sistema está siempre
en uno de un conjunto finito de estados y pasa de uno a otro por eventos
definidos. En C: un `enum` con los estados y un `switch` que decide la
transición, con `default` hacia un estado de falla.][un semáforo: verde,
amarillo, rojo, siempre en ese orden y siempre en uno solo; si alguna vez
aparece un color que no existe, se pone en titilante.]

#definicion[MISRA-C][Un estándar de codificación para C en sistemas
críticos: 16 directivas y 159 reglas (C:2012), clasificadas en Mandatory,
Required (desvío documentado) y Advisory, que prohíben las construcciones
del lenguaje que llevan a comportamiento indefinido o difícil de
verificar.][el reglamento de tránsito del C: se puede manejar sin él, pero
nadie te deja llevar pasajeros así.]

== Periféricos

#definicion[Sincrónico y asincrónico][Una comunicación es sincrónica cuando
viaja un reloj que marca cuándo leer cada bit (SPI, I²C); asincrónica cuando
no hay reloj compartido y los dos extremos acuerdan de antemano la velocidad
(UART).][sincrónico es dictar con alguien que te hace una seña en cada
palabra; asincrónico es dictar a un ritmo que los dos acordaron antes.]

#definicion[Maestro y esclavo][En un bus, el maestro es el que inicia cada
transferencia y, en SPI e I²C, genera el reloj; el esclavo sólo responde
cuando el maestro lo llama.][el maestro es el que llama por teléfono; el
esclavo atiende, pero nunca llama.]

#definicion[Open-drain y pull-up][Una salida open-drain sólo puede llevar
la línea a cero; cuando no la baja, la deja «suelta», y una resistencia de
pull-up a la alimentación la lleva a uno. Así varios dispositivos comparten
una línea sin cortocircuito.][una soga atada a un resorte que la mantiene
arriba: cualquiera puede tirarla para abajo, nadie la empuja para arriba, y
si nadie tira, sube sola.]

#definicion[Señal diferencial][Cada bit viaja por un par de cables, uno con
la señal y otro con su inversa; el receptor mide la diferencia. El ruido que
entra igual en los dos se cancela al restar.][medir la altura de alguien
parado en un barco: el barco sube y baja, pero la diferencia entre cabeza y
pies no cambia.]

#definicion[Checksum y CRC][Un checksum es un valor calculado sobre los
datos de una trama y enviado con ella para detectar errores; el XOR del TP4
es el más simple y no ve dos errores en el mismo bit. Un CRC es un checksum
más fuerte, basado en una división polinómica, que detecta todas las
ráfagas cortas de errores; es el de los protocolos de vuelo (y de CAN). La
parte de la división es de afuera.][el checksum es contar los bultos al
cargar y al descargar el camión; si cambiaste uno por otro, no te
enterás. El CRC además mira qué hay en cada bulto.]

#definicion[ICD][_Interface Control Document_: el documento que fija lo que
dos equipos acuerdan en la frontera entre sus sistemas (señales, tramas,
valores). Ninguno lo cambia sin acordarlo con el otro.][el plano de los
caños que comparten dos departamentos: si uno corre la bajada sin avisar, el
otro se inunda.]

== RTOS

#definicion[Tiempo real][Un sistema es de tiempo real cuando su corrección
depende del resultado y del instante en que se obtiene. *Hard*: perder un
plazo es una falla. *Firm*: el resultado tarde no sirve. *Soft*: tarde
degrada la calidad.][hard es el airbag (tarde no sirve y es grave); firm,
la foto de la llegada en una carrera (tarde se descarta); soft, el
streaming (si se atrasa, se ve peor).]

#definicion[Tarea, scheduler y preempción][Una tarea es una función con un
lazo infinito, su propia pila y una prioridad. El scheduler decide cuál usa
la CPU: en FreeRTOS, la lista de mayor prioridad. Preempción es que el
scheduler le saque la CPU a una tarea en ejecución porque quedó lista otra
más prioritaria.][una guardia de hospital: el médico atiende al que más
urge; si entra uno grave, deja al del resfrío y vuelve después.]

#definicion[Cambio de contexto][Guardar el estado de registros de la tarea
que deja la CPU en su pila y cargar el de la que entra, para que cada una
siga exactamente donde estaba.][poner un señalador en el libro antes de
agarrar otro.]

#definicion[Cola, semáforo y mutex][Una cola pasa datos entre tareas,
copiándolos, en orden FIFO. Un semáforo señaliza que ocurrió un evento (o
cuenta recursos), sin datos ni dueño. Un mutex protege un recurso
compartido: tiene dueño, sólo lo libera quien lo tomó y aplica herencia de
prioridad.][la cola es la cinta del súper; el semáforo, el timbre de «tu
pedido está listo»; el mutex, la llave del baño de una estación de
servicio: el que la tiene es el único que entra, y la devuelve él.]

#definicion[Inversión de prioridad y herencia][Inversión: una tarea de
alta prioridad espera un recurso que tiene una de baja, y una de prioridad
media, que no lo necesita, desaloja a la de baja; la alta termina esperando
a la media. Herencia: mientras la baja tenga el recurso, hereda la
prioridad de la alta, y la media ya no puede desalojarla.][la ambulancia
espera que el que está estacionado en la salida mueva el auto, pero a ese
lo frena un inspector por una multa. Con herencia, al que tiene que mover
el auto lo dejan pasar primero.]

#definicion[Bloqueante y no bloqueante][Una llamada es bloqueante cuando
el que la hace no puede seguir hasta que termine (`HAL_Delay`, recepción
por _polling_); no bloqueante cuando vuelve enseguida y el resultado llega
después por una interrupción, una marca o una comparación de tiempo.][hacer
la fila del banco contra sacar número y seguir con lo tuyo hasta que te
llamen.]

= Anexo B — Palabras que se dan por sabidas <sec-anexo-glosario>

Las que aparecen en la guía, en las clases o en los TP sin que nadie las
explique, en orden alfabético.

#set par(justify: false)
#tabla(
  columns: (auto, 1fr),
  [*Palabra*], [*Qué es*],
  [ACK / NACK], [respuesta que confirma (_acknowledge_) o rechaza la recepción de un mensaje],
  [ADC], [conversor analógico-digital: convierte una tensión en un número],
  [API], [el conjunto de funciones que una biblioteca o un sistema ofrece para usarlo (`xTaskCreate` es de la API de FreeRTOS)],
  [Baudrate], [velocidad de una UART en símbolos por segundo; 115200 es lo de la materia],
  [Bit, byte], [bit: un 0 o un 1. Byte: 8 bits, de 0 a 255 sin signo],
  [Bus], [conjunto de cables compartido por varios dispositivos para comunicarse],
  [Bandera (flag)], [un bit o una variable que indica que algo pasó o está activo],
  [Bloque `USER CODE`], [zona de un archivo generado por CubeMX donde el código propio sobrevive a la regeneración],
  [Compilar, enlazar], [compilar traduce C a código máquina en archivos objeto; enlazar (_link_) los une y fija las direcciones en un ejecutable],
  [CS / NSS], [_Chip Select_: la línea con que el maestro SPI elige con qué esclavo hablar (activa en bajo)],
  [CubeMX / `.ioc`], [la herramienta y el archivo que configuran gráficamente pines y periféricos y generan el código de inicialización],
  [Deadline], [el plazo máximo para que una tarea termine],
  [Determinista], [que se comporta siempre igual y en un tiempo acotado y predecible],
  [`.elf`], [el archivo del programa compilado, el que se carga en la placa o en Wokwi],
  [Endianness], [el orden en que se guardan los bytes de un número de varios bytes (little-endian: el menos significativo primero)],
  [Firmware], [el programa que corre en un microcontrolador],
  [Flanco], [el instante en que una señal pasa de 0 a 1 (subida) o de 1 a 0 (bajada)],
  [FreeRTOS], [el sistema operativo de tiempo real de la materia, gratuito y muy usado en CubeSats],
  [Full / half-duplex], [full: los dos sentidos a la vez; half: los dos, por turnos],
  [GPIO], [pin de propósito general, configurable como entrada o salida digital],
  [HAL], [_Hardware Abstraction Layer_: la biblioteca de ST con funciones como `HAL_GPIO_WritePin`, que esconde los registros],
  [Hexadecimal], [base 16, con dígitos 0-9 y A-F; `0xA5` es 165 y en binario `1010 0101`],
  [Housekeeping], [la telemetría de estado del satélite: tensiones, corrientes, temperaturas],
  [Host / payload], [en los TP: la OBC (host) y la carga útil (payload), el instrumento al que la OBC le pide cosas],
  [I²C, SPI, UART, CAN], [buses de comunicación serie; ver la sección de periféricos],
  [Kernel], [el núcleo de un sistema operativo: el que reparte la CPU y maneja colas y semáforos],
  [krad], [mil rad: unidad de dosis de radiación absorbida],
  [LEO / GEO], [órbita baja (cientos de km) / órbita geoestacionaria (≈36 000 km)],
  [Macro], [un nombre que el preprocesador reemplaza por un valor o un texto antes de compilar (`#define`)],
  [Máscara], [un número que, combinado con operadores de bit, elige qué bits tocar o leer],
  [MSB / LSB], [el bit más / menos significativo de un número],
  [Payload], [carga útil: lo que el satélite lleva para cumplir la misión (cámara, sensor, experimento)],
  [Periférico], [un bloque del microcontrolador que no es el núcleo: UART, SPI, timers, ADC],
  [Polling], [preguntar una y otra vez si algo pasó, en vez de esperar un aviso por interrupción],
  [Prototipo], [la declaración de una función (tipo, nombre y parámetros) antes de definirla],
  [Registro], [una celda de memoria del procesador o de un periférico, con una dirección fija, que controla o informa algo del hardware],
  [Reset], [volver a arrancar el procesador desde cero],
  [ST-LINK], [el programador y depurador por USB que viene en la placa Nucleo; también hace de puerto serie],
  [Telemetría / telecomando], [TM: datos que el satélite manda a tierra. TC: órdenes que tierra manda al satélite],
  [Tick], [la unidad de tiempo del sistema operativo, generada por un timer (1 ms en la materia)],
  [Timeout], [tiempo máximo de espera, pasado el cual se abandona la espera],
  [Trama], [un paquete de bytes con un formato fijo (inicio, comando, datos, verificación)],
  [TRL], [_Technology Readiness Level_: madurez de una tecnología, de 1 (idea) a 9 (probada en vuelo)],
  [Wokwi], [simulador de placas y circuitos que corre adentro de VS Code],
  [XOR], [operación de bits que da 1 cuando los bits son distintos; `A5 ^ 01 = A4`],
)
