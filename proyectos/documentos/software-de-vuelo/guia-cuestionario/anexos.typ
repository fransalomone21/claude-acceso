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

= Anexo C — Todos los términos de la materia, de la A a la Z <sec-anexo-terminos>

Para buscar con Ctrl+F: cada sigla con lo que significa, en una línea. Va
ordenado solo (alfabético) y repite a propósito lo de los anexos A y B, así
una búsqueda cae siempre acá.

#let terminos = (
  ("Advisory (MISRA)", [categoría de recomendación: el equipo puede no seguirla con menos trámite]),
  ("ALU", [unidad aritmético-lógica del núcleo; en ARM opera sobre registros (load-store)]),
  ("Arbitraje no destructivo (CAN)", [si dos transmiten a la vez, gana el ID de mayor prioridad y su mensaje no se pierde]),
  ("ATENEA", [CubeSat 12U argentino (CONAE, UNSAM, UNLP, FIUBA, VENG) que voló en Artemis II y midió radiación cislunar]),
  ("BCH / Reed-Solomon", [códigos de corrección que corrigen varios bits: sirven contra MBU]),
  ("BMP180", [sensor de presión y temperatura por I²C del TP5 (PB8 SCL, PB9 SDA)]),
  ("Bootloader", [programa de arranque que verifica el firmware (checksum/CRC) y si está mal carga el respaldo; se replica]),
  ("Bus lockup (I²C)", [un esclavo queda a mitad de trama reteniendo SDA y el bus entero queda inutilizable]),
  ("C&DH", [Command and Data Handling: manejo de telecomandos, telemetría y datos; lo hace la OBC]),
  ("CAN / CAN FD", [bus diferencial multi-maestro de Bosch, arbitraje no destructivo y CRC; hasta 1 Mbit/s (5 en FD)]),
  ("Callback", [puntero a función que se le pasa a otro módulo para que lo llame cuando pasa algo]),
  ("cFS", [core Flight System: framework de software de vuelo de NASA]),
  ("CFSR", [registro del Cortex-M que dice la causa de un fault]),
  ("Checkpoint", [estado guardado para restaurar después de un reset]),
  ("CMSIS / CMSIS-RTOS v2", [estándar de ARM para acceder al núcleo; la v2 es la API de RTOS que genera CubeMX (osThreadNew, osDelay)]),
  ("Cola (queue)", [buffer FIFO de tamaño fijo para pasar DATOS entre tareas; copia los datos]),
  ("Cola circular", [buffer con índice de escritura y de lectura que da la vuelta (TP4, recepción UART)]),
  ("configMAX_SYSCALL_INTERRUPT_PRIORITY", [= 5: las IRQ 0-4 no pueden llamar a FreeRTOS; las 5-14 sí, con FromISR]),
  ("Cortex-A / R / M", [A: rendimiento promedio (Linux). R: peor caso, lockstep, ECC (OBC). M: costo, consumo, latencia]),
  ("COTS", [Commercial Off-The-Shelf: componente comercial, barato, 2-10 krad]),
  ("CPOL / CPHA", [polaridad (reposo del reloj) y fase (flanco de muestreo) del SPI; tienen que coincidir]),
  ("CRC", [chequeo de redundancia cíclica: detección de errores más fuerte que el XOR]),
  ("CS / NSS / chip select", [línea con que el maestro SPI elige al esclavo; activa en bajo; una por esclavo]),
  ("CubeSat / U", [satélite modular; 1U = cubo de 10 cm de hasta unos 2 kg; 3U, 6U, 12U]),
  ("DD (daño por desplazamiento)", [efecto acumulativo que desplaza átomos del silicio; pega en ópticos]),
  ("Deadline (D)", [plazo máximo de una tarea; condición C < D ≤ T]),
  ("default (switch)", [rama obligatoria (MISRA 16.4) que lleva a falla si el valor es inesperado]),
  ("Dir 4.12", [MISRA: sin malloc/free (heap no determinista y fragmentable)]),
  ("Dir 4.14", [MISRA: validar toda entrada externa]),
  ("Dir 4.6", [MISRA: tipos de ancho fijo (uint8_t, int16_t)]),
  ("Dispatch table", [tabla de punteros a función indexada por el código de telecomando; se valida el índice]),
  ("DMR", [dos módulos comparados: DETECTA la falla, no sabe cuál falló]),
  ("DSP / FPU", [instrucciones de procesamiento de señales / unidad de punto flotante (el M4F las tiene)]),
  ("ECC / EDAC", [bits de control para detectar y corregir errores en memoria]),
  ("Espera activa", [la CPU gira en vacío esperando (HAL_Delay); contraria a vTaskDelay]),
  ("Excepción", [evento que desvía el flujo: reset, IRQ, SVC, faults]),
  ("FDIR", [Fault Detection, Isolation and Recovery]),
  ("FPGA", [lógica reconfigurable: procesamiento en paralelo (imágenes, compresión); con SRAM necesita scrubbing]),
  ("FRAM / MRAM", [memorias que no dependen de carga: un SEU no les cambia el dato; memoria de salvaguarda]),
  ("FreeRTOS", [RTOS de la materia; corre la tarea lista de mayor prioridad, round-robin entre iguales]),
  ("FromISR", [variantes de la API de FreeRTOS que se pueden llamar desde una ISR (xSemaphoreGiveFromISR)]),
  ("goto EXEC_ERROR", [patrón de la cátedra para verificar lo creado en FreeRTOS y salir ante error]),
  ("HAL_Delay / HAL_GetTick", [espera bloqueante / contador de ms para comparar tiempos sin bloquear]),
  ("Hamming SECDED", [corrige 1 bit y detecta 2 por palabra]),
  ("Handler / Thread (modos)", [los dos modos del Cortex-M: Handler para excepciones, Thread para la aplicación]),
  ("HardFault / MemManage / BusFault / UsageFault", [excepciones de falla del Cortex-M]),
  ("Harvard / Von Neumann", [buses separados de instrucciones y datos / un solo bus compartido (cuello de botella)]),
  ("Heap", [memoria dinámica (malloc), crece hacia arriba; no se usa en vuelo]),
  ("Herencia de prioridad", [la tarea baja que tiene el mutex hereda la prioridad de la alta que lo espera]),
  ("I²C", [2 hilos (SDA, SCL), direcciones de 7 bits, 100/400 kbit/s, open-drain con pull-up, centímetros]),
  ("ICD", [Interface Control Document: el acuerdo de interfaz entre equipos (protocolo.h); no se toca]),
  ("Idle (tarea)", [tarea de prioridad 0 que corre cuando no hay nada más]),
  ("Inversión de prioridad", [la alta espera a la baja (mutex) y la media desaloja a la baja; Mars Pathfinder]),
  ("ISR", [Interrupt Service Routine: corta, sin printf ni nada bloqueante, sólo avisa]),
  ("Latch-up", [ver SEL]),
  ("LabOSat", [placa de la UNSAM que caracteriza electrónica en LEO desde 2014 (MSP430, después TMS570)]),
  ("LCL", [limitador de corriente que aísla la falla de un módulo (contra SEL)]),
  ("LEON / RAD750", [procesadores rad-hard (SPARC / PowerPC, unos 200 krad: MRO, JWST)]),
  ("Linker / linker script", [une los objetos y fija las direcciones; el script dice dónde va cada sección]),
  ("Load-store", [arquitectura donde la ALU opera sólo sobre registros]),
  ("Lockstep", [dos núcleos con las mismas instrucciones y un comparador: DMR en el silicio (TMS570)]),
  ("LVDS", [capa física diferencial de baja tensión (la usa SpaceWire)]),
  ("malloc / free", [reserva y libera heap; prohibido en vuelo (Dir 4.12); sin free = memory leak]),
  ("Mandatory (MISRA)", [categoría que nunca se rompe, sin desvío posible (ej. 1.3)]),
  ("Mars Pathfinder", [1997: resets por inversión de prioridad; se arregló habilitando herencia de prioridad en VxWorks desde la Tierra]),
  ("MBU", [Multiple Bit Upset: varios bits dados vuelta por una partícula]),
  ("MIL-STD-1553", [bus militar diferencial, determinista, un solo controlador, buses A y B redundantes (BepiColombo)]),
  ("MISO / MOSI / SCLK", [líneas SPI: esclavo a maestro / maestro a esclavo / reloj]),
  ("MISRA-C:2012", [175 guías: 16 directivas + 159 reglas; Mandatory, Required, Advisory]),
  ("MMU", [traduce direcciones (memoria virtual); la MPU no]),
  ("MPU", [vigila permisos por región y frena accesos ilegales; no traduce]),
  ("MSP / PSP", [punteros de pila del Cortex-M: MSP para kernel e ISR, PSP para las tareas]),
  ("MSP430", [µC de TI de 16 bits, bajo consumo, unos 20 krad (LabOSat-01)]),
  ("Mutex", [candado CON DUEÑO para un recurso compartido, con herencia de prioridad]),
  ("New Space / Old Space", [COTS, 3-4 años, TRL 6, barato / rad-hard, 10+ años, TRL 9]),
  ("NVIC", [controlador de interrupciones anidado y vectorizado; número MENOR = más urgente]),
  ("OBC", [On-Board Computer: la computadora de a bordo]),
  ("Open-drain", [salida que sólo baja la línea; necesita pull-up (I²C, MISO del TP5)]),
  ("PendSV", [excepción de menor prioridad donde FreeRTOS hace el cambio de contexto]),
  ("Pipeline", [etapas de ejecución en paralelo: 3 en M3/M4, 8 en el R]),
  ("portYIELD_FROM_ISR", [al salir de la ISR, cambia a la tarea despertada si es más prioritaria]),
  ("Power cycle", [apagar y volver a prender tras detectar un latch-up]),
  ("Preempción", [el scheduler le saca la CPU a una tarea porque quedó lista otra más prioritaria]),
  ("Push-pull", [salida que lleva la línea a 0 y a 1; dos en el mismo cable = cortocircuito]),
  ("Rad-hard / rad-tolerant", [100-1000+ krad / 20-50 krad]),
  ("Rate Monotonic", [a menor período, mayor prioridad]),
  ("Recursión", [función que se llama a sí misma; prohibida en vuelo (MISRA 17.2)]),
  ("Redundancia en frío / en caliente", [respaldo apagado que se prende al fallar / todos andando a la vez]),
  ("Required (MISRA)", [se cumple salvo desvío documentado y justificado]),
  ("Reset (Cortex-M)", [lee 0x00000000 → MSP, lee 0x00000004 → vector de reset, startup, main]),
  ("Round-robin", [tareas de igual prioridad se turnan en cada tick]),
  ("RS-232", [single-ended, hasta 15 m, el 1 es tensión negativa; tierra y bancos de prueba]),
  ("RS-422 / RS-485", [diferenciales, hasta 1200 m; 422 un transmisor y 10 receptores, 485 multipunto; sin detección de errores]),
  ("RTEMS / VxWorks", [RTOS de vuelo (VxWorks: Juno, JWST, Mars Pathfinder)]),
  ("RTOS", [sistema operativo de tiempo real: predecible, no necesariamente rápido]),
  ("Scheduler", [decide qué tarea usa la CPU]),
  ("Scrubbing", [barrer la memoria corrigiendo errores de 1 bit antes de que se junten dos]),
  ("SDA / SCL", [datos y reloj de I²C]),
  ("SEE", [Single Event Effect: efecto de UNA partícula; puede pasar en cualquier momento]),
  ("SEL", [latch-up: tiristor parásito, alta corriente, quema el chip si no se corta (duro)]),
  ("Semáforo binario / contador", [SEÑALIZA un evento (0/1) / cuenta eventos o recursos (0..N); sin dueño]),
  ("SET", [transitorio de tensión o corriente por una partícula]),
  ("SEU", [un bit dado vuelta (blando: no daña el hardware)]),
  ("Single-ended / diferencial", [señal contra masa / par de cables que se restan (cancela el ruido)]),
  ("Single-string", [sin redundancia: si falla algo crítico se pierde la misión (lo común en CubeSats)]),
  ("SoC híbrido", [CPU + FPGA (+ GPU) en un chip, para IA a bordo]),
  ("SpaceCAN", [propuesta de usar CAN en vez de I²C en satélites chicos]),
  ("SpaceWire / SpaceFibre", [ESA, punto a punto full-duplex sobre LVDS con routers, 2-200 Mbit/s (JWST, Gaia) / hasta 10 Gbit/s]),
  ("SPI", [4 hilos, un CS por esclavo, full-duplex, rápido; el esclavo nunca inicia]),
  ("Stack (pila)", [locales, argumentos y retornos; crece hacia direcciones decrecientes]),
  ("Startup", [código que inicializa RAM, copia .data, configura relojes y llama a main]),
  ("static / const / volatile", [conserva valor o limita visibilidad / no se modifica / lo cambia algo de afuera, se relee siempre]),
  ("Super-loop", [lazo infinito sin RTOS: una tarea lenta frena a todas]),
  ("SVC", [instrucción con que FreeRTOS lanza la primera tarea]),
  ("SysTick", [timer de 24 bits del núcleo que da el tick del kernel (la HAL se muda a TIM6)]),
  ("Tabla de vectores / VTOR", [direcciones de cada handler desde 0x00000000; VTOR la mueve]),
  ("TCB", [Task Control Block: prioridad, estado y puntero de pila de una tarea]),
  ("template.c", [estructura de la cátedra: bibliotecas, macros, propias, globales, declaraciones, main, definiciones]),
  ("Thumb-2", [juego de instrucciones denso: menos flash]),
  ("TID", [dosis ionizante total, acumulativa: define la VIDA ÚTIL]),
  ("TMR", [tres módulos y un votador: enmascara la falla y sigue]),
  ("TMS570", [Cortex-R con doble núcleo en lockstep (laboratorio, LabOSat-02)]),
  ("TP1", [C en Ubuntu, 9 ejercicios de OBC (ancho fijo, volatile, static, bits, espera acotada)]),
  ("TP2", [Wokwi, NUCLEO-C031C6: 4 LEDs en binario y ADC con alarma por UART]),
  ("TP3", [F446RE real: printf por ST-LINK, botón, 7 segmentos, blink sin HAL_Delay]),
  ("TP4", [PC → host → payload por UART y SPI, todo por interrupciones, trama A5 CMD 00 XOR]),
  ("TP5", [FreeRTOS, dos payloads en un SPI con dos CS, BMP180 por I²C, MISO open-drain]),
  ("UART", [asíncrona, TX/RX, sin reloj, punto a punto, baudrate acordado (115200 8N1)]),
  ("USER CODE BEGIN / END", [donde va el código propio para sobrevivir a la regeneración de CubeMX]),
  ("Van Allen", [cinturones de radiación atrapada; lo que más pega en LEO]),
  ("vTaskDelay / vTaskDelayUntil", [bloquea n ticks sin gastar CPU / mantiene un período fijo]),
  ("Watchdog", [timer que hay que patear; si no, resetea; en vuelo, externo]),
  ("WCET", [Worst-Case Execution Time: tiempo de ejecución en el peor caso]),
  ("xTaskCreate", [crea una tarea de FreeRTOS (en la cátedra, PILA_TAREA 512u)]),
  ("-Wall -Wextra -std=c11", [flags de gcc de Leandro: un ejercicio termina con cero warnings]),
)

#set par(justify: false)
#tabla(
  columns: (auto, 1fr),
  [*Término*], [*Qué es*],
  ..terminos.sorted(key: t => lower(t.at(0))).map(t => ([*#t.at(0)*], t.at(1))).flatten(),
)
