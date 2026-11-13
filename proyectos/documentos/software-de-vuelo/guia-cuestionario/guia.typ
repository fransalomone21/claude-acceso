// Guía para el cuestionario de Leandro (Software de Vuelo, 13/11/2026).
// Compilar desde proyectos/documentos/software-de-vuelo:
//   python guia-cuestionario/recortar.py      (las figuras de las clases, una vez)
//   typst compile --root . guia-cuestionario/guia.typ guia-cuestionario/guia.pdf
// Las figuras y el PDF NO van al repo (material de la cátedra): ver .gitignore.

#import "plantilla.typ": *

#show: guia.with(
  titulo: "Guía para el cuestionario de Leandro",
  subtitulo: "Todo lo que vimos e hicimos, para repasar",
  institucion: "UNSAM · Ingeniería en Sistemas Espaciales",
  materia: "Ingeniería de Software de Vuelo para Sistemas Espaciales Críticos",
  ciclo: "2.º cuatrimestre 2026",
  version: "Versión 1.1 · 13/11/2026 · de las clases de las semanas 1 a 9, los prácticos 1 a 5 y nuestras entregas",
  presentacion: [
    *Para quién es.* Para vos, que mañana —bueno, hoy— tenés el cuestionario
    de Leandro sobre todo lo que vimos con él. La primera sección es la de
    los quince minutos: si sólo leés eso, leé eso. Después va cada tema en
    el orden en que lo dio, con para qué sirve, la duda que te vas a hacer,
    la idea con los dedos, lo formal, un pedazo de código, el error típico y
    preguntas con respuesta. Las figuras son *las de sus clases*, recortadas;
    lo que escribimos encima va en naranja. Cada TP tiene su sección: qué
    pedía, qué ejercita, cómo lo resolvimos y qué te pueden preguntar. Al
    final, un cuestionario mezclado. Lo que no sale del material de Leandro
    o de los TP se dice que es de afuera.
  ],
)

= Cómo está armada, y qué cubre <sec-mapa>

Leandro anunció el primer día, en la diapositiva de evaluación, un *quiz
sobre lo visto en cada clase teórica*, con premio: un departamento en
Miami y una lancha. No consta que alguien los haya cobrado. El cuestionario
de hoy es de *todo* lo visto, así que esta guía recorre todo, en el orden en
que se dio. La tabla es el índice de cobertura: cada fila es una clase o un
TP, y dice dónde está.

#tabla(
  columns: (auto, 1fr, auto),
  [*Cuándo*], [*Qué (presentación o TP)*], [*Sección*],
  [Semana 1], [_Confiabilidad de la aviónica espacial_ (radiación, COTS, redundancia, memorias, watchdog, EDAC)], [@sec-confiab],
  [18/08], [Nuestra entrega: _Comparativa de OBC de mercado_ (el primer TP)], [@sec-tp-obc],
  [Semana 2], [_Confiabilidad…_ parte 2 (procesadores, arquitecturas, FSW, RTOS, LabOSat, ATENEA)], [@sec-obc],
  [Semana 2], [_Arquitectura ARM_ (perfiles A/R/M, Harvard, Cortex-M, NVIC, MPU)], [@sec-arm],
  [Semana 3], [_Arquitectura ARM Cortex_ (modos, pila, compilación, memoria de un programa C, excepciones)], [@sec-arm],
  [Semana 2], [_Programación en C embebido_ (157 diapositivas) y los `codes/` de la clase], [@sec-c],
  [Semanas 2 y 3], [_MISRA-C_ y _MISRA-C kit de desarrollo_, con el ejercicio `satelite.c`], [@sec-misra],
  [Semana 3], [Práctico 1: C en Ubuntu (TP1)], [@sec-tp1],
  [Semana 4], [_STM32CubeIDE: instalación y demo_ y _De CubeIDE a Wokwi_ (LED y desafío del 7 segmentos)], [@sec-cubeide],
  [Semana 5], [Práctico 2: GPIO, ADC y UART en Wokwi (TP2)], [@sec-tp2],
  [Semana 6], [_Periféricos e interfaces de comunicación_ (UART, I²C, SPI, RS-485, CAN, 1553, SpaceWire)], [@sec-perif],
  [Semana 6], [Práctico 3: la NUCLEO-F446RE real (TP3)], [@sec-tp3],
  [Semana 7], [_Funciones y punteros_ (pasaje, recursión, punteros a función, callbacks, structs)], [@sec-punteros],
  [Semana 8], [_Sistemas operativos de tiempo real (RTOS)_], [@sec-rtos],
  [Semana 9], [Práctico 4: host y payload por SPI con interrupciones (TP4)], [@sec-tp4],
  [FreeRTOS], [Práctico 5: OBC y dos payloads con FreeRTOS y BMP180 (TP5)], [@sec-tp5],
)

*Lo que no entra, a propósito:* el TP Cohete de Agua (es de Petrilli, no de
Leandro, y tiene su propia guía en el Drive del grupo), y el detalle de la
instalación de CubeIDE paso a paso (está en la guía de IDEs). El C, tema por
tema y con cada programa compilado, está en el *Apunte de C* que ya hicimos:
acá va el resumen con lo que más se pregunta y el puntero a cada módulo.

*Al final hay dos anexos:* el A con cada definición completa y un ejemplo
de la vida diaria (@sec-anexo-def), y el B con las palabras que se dan por
sabidas (@sec-anexo-glosario).

= Lo que seguro preguntan: quince minutos <sec-seguro>

Si llegás con el colectivo en marcha, esto. Una línea por idea, en el orden
de la materia.

*Confiabilidad.*
- *TID* (dosis ionizante total) es acumulativa: define la *vida útil*. *SEE*
  (evento único) puede pasar en cualquier momento, aun en un componente sano.
- *SEU* = un bit dado vuelta (blando, no rompe nada). *SEL* = _latch-up_,
  alta corriente que quema el chip si no se corta a tiempo (duro). *SET* =
  un transitorio.
- Contra SEU: *EDAC* (Hamming SECDED: corrige 1 bit, detecta 2) + *scrubbing*
  (barrer la memoria para que no se junten dos errores en la misma palabra).
  Contra SEL: detección de sobrecorriente y *LCL* que cortan la alimentación.
- *DMR* detecta (no sabe cuál falló); *TMR* vota por mayoría y sigue
  andando. *Lockstep*: dos núcleos con las mismas instrucciones y un
  comparador (DMR en el silicio; el TMS570 es un Cortex-R en lockstep).
- *Watchdog*: el software lo «patea»; si deja de hacerlo, resetea. En vuelo,
  mejor *externo*.
- *FRAM y MRAM*: guardan el dato sin carga eléctrica, por eso un SEU no las
  cambia: memoria de salvaguarda.
- New Space = *COTS + mitigación*, misiones cortas en LEO; Old Space =
  rad-hard, TRL 9, décadas.

*Arquitectura.*
- ARM *licencia* núcleos; el fabricante (ST, TI) hace el *microcontrolador*
  (núcleo + memoria + periféricos).
- *Cortex-A* optimiza el promedio; *Cortex-R*, el peor caso (WCET,
  lockstep, ECC); *Cortex-M*, costo y consumo.
- *Harvard*: buses separados de instrucciones y datos (pero en ARM, un solo
  mapa de 4 GB). *Von Neumann*: un solo bus, que se vuelve cuello de
  botella.
- *NVIC*: controlador de interrupciones *anidado* y *vectorizado*. *MPU*:
  vigila accesos (no traduce direcciones como una MMU).
- *Reset*: el núcleo lee `0x00000000` (valor inicial del MSP) y
  `0x00000004` (vector de reset), y salta.
- Memoria de un programa C: `.text` (código), `.data` (globales
  inicializadas), `.bss` (sin inicializar), *heap* (crece hacia arriba,
  `malloc`), *stack* (crece hacia abajo, locales y marcos).

*C de vuelo y MISRA.*
- `gcc -Wall -Wextra -std=c11` y *cero warnings*; estructura de `template.c`.
- Tipos de ancho fijo (`uint8_t`, `int16_t`); `volatile` para lo que cambia
  por fuera del flujo (hardware, ISR); `static` para limitar visibilidad o
  conservar valor; todo bucle de espera *con cota*.
- MISRA: *Mandatory* (nunca se rompe: regla 1.3, nada de comportamiento
  indefinido), *Required* (sólo con desvío documentado), *Advisory* (buena
  práctica). Sin `malloc` (Dir 4.12), sin recursión (17.2), `switch` con
  `default` (16.4), variables inicializadas (9.1), validar toda entrada
  externa (Dir 4.14).

*Periféricos.*
- *UART*: asíncrona, punto a punto, ambos acuerdan baudrate (115200 8N1).
- *I²C*: 2 hilos (SDA, SCL), dirección de 7 bits por software, 100/400 kbit/s,
  centímetros; su talón de Aquiles es el *bus lockup*.
- *SPI*: SCLK, MOSI, MISO y *un CS por esclavo*; full-duplex, rápido; el
  maestro genera el reloj y el esclavo *nunca* inicia. CPOL/CPHA tienen que
  coincidir.
- *RS-422/485*: diferencial (el ruido se cancela al restar), decenas de
  metros; 485 es multipunto. *CAN*: diferencial + arbitraje no destructivo +
  CRC. *MIL-STD-1553*: maestro único, bus A/B redundante. *SpaceWire*: LVDS,
  enlaces punto a punto con routers.

*Funciones y punteros.*
- Por *valor* = copia; por *referencia* = se pasa la dirección y se modifica
  el original. Para devolver varios valores, punteros.
- Recursión: cada llamada apila un marco; en vuelo se reemplaza por un bucle.
- Puntero a función: `tipo (*nombre)(args)`. *Dispatch table* = tabla de
  punteros a función indexada por el código de telecomando (validando el
  índice). *Callback* = el driver llama a la función que le registraste.
- `.` con una variable struct, `->` con un puntero a struct.

*RTOS.*
- Tiempo real = *predecible*, no rápido. Hard / firm / soft.
- Tarea = función con lazo infinito, pila propia, prioridad y TCB. Estados:
  *Running, Ready, Blocked, Suspended*.
- FreeRTOS: corre la tarea lista de *mayor prioridad*; entre iguales,
  round-robin por tick. `vTaskDelay` bloquea sin gastar CPU; `HAL_Delay`
  gira en vacío.
- ¿Pasar un dato? *cola*. ¿Avisar un evento? *semáforo*. ¿Proteger un
  recurso? *mutex* (con herencia de prioridad, contra la *inversión de
  prioridad* de Mars Pathfinder).
- En el Cortex-M4: *SysTick* (tick), *PendSV* (cambio de contexto), *SVC*
  (arranque). *MSP* para kernel e ISR, *PSP* para las tareas.
- Las ISR que llaman a FreeRTOS: prioridad numérica *≥ 5* y sólo funciones
  `…FromISR()` + `portYIELD_FROM_ISR()`.

*Los TP en una línea.* TP1: C en Ubuntu con patrones de OBC. TP2: GPIO,
ADC y UART en Wokwi. TP3: la placa real, botón, 7 segmentos y blink sin
`HAL_Delay`. TP4: PC → host → payload por UART y SPI, todo por
interrupciones, con trama `A5 CMD 00 XOR`. TP5: lo mismo con FreeRTOS, dos
payloads en un SPI con dos CS, BMP180 por I²C y MISO en open-drain.

#posta[Si te tenés que quedar con una sola idea de la materia: *en vuelo
nadie te viene a resetear*. Por eso todo bucle tiene cota, todo `switch`
tiene `default`, toda entrada externa se valida, la memoria es estática, la
ISR sólo avisa y el watchdog está para cuando todo lo anterior falló. Lo
demás es el detalle de cómo.]

= Confiabilidad de la aviónica espacial <sec-confiab>

Es la primera clase, y está armada sobre un paper del que Leandro es
coautor: Cratere, Gagliardi y otros, _On-Board Computer for CubeSats_,
IEEE Access, 2024. Que el profesor dé su propio paper es una pista de
peso sobre qué le importa.

#gancho[todo lo que hacemos después —el C defensivo, MISRA, el watchdog, el
RTOS— existe por lo que cuenta esta clase: el espacio da vuelta bits, y un
satélite de cien mil dólares no puede llevar los componentes de cien
millones. La clase te da el vocabulario para justificar *cada* regla de
código que viene después.]

== New Space, CubeSats y la OBC

#tabla(
  columns: (auto, 1fr, 1fr),
  [], [*Old Space*], [*New Space*],
  [Satélite], [monolítico, o constelación de pocos], [chico, o constelaciones grandes],
  [Duración], [+10 años], [+3 / +4 años],
  [TRL], [9], [6],
  [Componentes], [rad-hard], [COTS],
  [Si falla uno], [falla la misión], [se repone rápido y barato],
)

Un *CubeSat* (estándar de 1999) se mide en unidades: *1U* es un cubo de
10 cm de hasta ≈2 kg, y se combinan en 3U, 6U, 12U. Cuesta del orden de
USD 200 000 y se hace en 1-2 años, contra USD 150-350 millones y 5-15 años
de un satélite convencional. El precio de esa economía: los *COTS* no están
hechos para el espacio y son más sensibles a la radiación. Ahí entra la
ingeniería de confiabilidad.

El *C&DH* (_Command and Data Handling_) es la gestión de los datos del
satélite: telemetría de estado (_housekeeping_), datos de misión,
telecomandos. La *OBC* es el hardware y software que lo hace: el cerebro.
Funciones: TM y TC, interfaces con sensores y actuadores, tiempo a bordo,
procesamiento y almacenamiento, y *FDIR* (detección, aislamiento y
recuperación de fallas).

== El enemigo: la radiación

#diapo("ambiente", ancho: 88%)[Ambiente espacial. Clase de la semana 1, _Confiabilidad de la aviónica espacial_, diapositiva 19. Para una órbita baja, lo que más pega son los cinturones.]

Tres fuentes: los *cinturones de Van Allen* (el campo magnético atrapa
protones y electrones; críticos para LEO), las *erupciones solares* (siguen
el ciclo de 11 años) y los *rayos cósmicos* (iones de altísima energía de
fuera del sistema solar, que no se pueden parar). La dosis cambia mucho con
la órbita: LEO, GEO o espacio profundo.

#tabla(
  columns: (auto, auto, 1fr),
  [*Efecto*], [*Tipo*], [*Qué hace*],
  [TID], [acumulativo], [carga atrapada en el óxido de los transistores; corre umbrales y degrada. Se mide en rad o gray. Define la *vida útil*],
  [DD], [acumulativo], [desplaza átomos de la red del silicio; pega en ópticos (paneles, cámaras, CCD)],
  [SET], [evento único], [transitorio de tensión o corriente; blando],
  [SEU], [evento único], [cambia un bit de una memoria o registro; no daña el hardware. Varias celdas: *MBU*],
  [SEL], [evento único], [_latch-up_: un tiristor parásito del CMOS se dispara, alta corriente; sin protección *quema* el chip],
)

#duda[¿si un SEU no rompe nada, por qué es tan grave? Porque cambia *qué
hace* el programa: un bit en una variable de estado, en un puntero o en
una instrucción puede llevar el código a un bucle infinito o a una rama que
nadie diseñó. El hardware está sano y el satélite, perdido.]

#dedos[blando es lo que se arregla con un reset o una corrección; duro es
daño físico. Esa distinción organiza toda la defensa: lo blando se combate
con *información redundante* (corregir el bit), lo duro con *cortar a
tiempo* (que el latch-up termine siendo un reinicio y no una placa
quemada).]

#tabla(
  columns: (auto, auto, auto, auto),
  [*Nivel*], [*TID [krad]*], [*LET umbral SEU*], [*Errores SEU por bit·día*],
  [COTS], [2 – 10], [< 5], [10⁻⁴],
  [Rad-tolerant], [20 – 50], [20], [10⁻⁷ a 10⁻⁸],
  [Rad-hard], [100 a 1000+], [> 60], [10⁻¹⁰ a 10⁻¹²],
)

Los rad-hard toleran unas cien veces más dosis y millones de veces menos
errores, pero son caros, pesados y difíciles de conseguir. La estrategia
típica de un CubeSat: *COTS + mitigación en capas*.

== Defensa por hardware

*Redundancia.* En *caliente* (estática) varios módulos andan a la vez y se
comparan: *DMR* (dos; si difieren se *detecta*, pero no se sabe cuál falló,
y se reinicia) y *TMR* (tres y un *votador*: si uno falla, los otros dos
ganan y el sistema sigue sin interrupción; cuesta triplicar hardware y
consumo). En *frío* (dinámica) hay un respaldo apagado que se enciende
cuando falla el principal: ahorra energía y reparte el desgaste acumulativo.
En cohetes, el FTS (_Flight Termination System_) usa el «hombre vivo» para
accionar redundancias o terminar el vuelo.

#grid(columns: (1fr, 1.3fr), column-gutter: 14pt, align: bottom,
  diapo("lockstep", ancho: 70%)[Lockstep del Cortex-R: DMR en el silicio (semana 1, diapo. 29).],
  diapo("watchdog")[Watchdog: hay que «patearlo» antes de que venza (semana 1, diapo. 33).],
)

*Lockstep*: dos núcleos ejecutan las mismas instrucciones en paralelo y una
lógica compara las salidas; ante una diferencia se dispara una excepción.
Es DMR dentro del procesador. El *TMS570* (el del laboratorio de la
materia, y el de LabOSat) es un Cortex-R con doble núcleo en lockstep.

*Memorias.* La SRAM (trabajo) es muy sensible a SEU; Flash y EEPROM son no
volátiles y más inmunes en la celda, pero su lógica de control no, y se
gastan con las escrituras. *FRAM* (polarización de un ferroeléctrico) y
*MRAM* (orientación magnética) no dependen de carga eléctrica: un SEU no
les cambia el dato, aguantan ≈1 Mrad y son no volátiles. Por eso son la
*memoria de salvaguarda*: parámetros críticos y estado, para recuperarse
después de una falla.

*Watchdog*: un temporizador que el software tiene que reiniciar («patear»)
periódicamente; si no lo hace, asume que el procesador se colgó y lo
resetea. Si un SEU manda el programa a un bucle infinito, el reset lo
recupera. El *interno* es simple, pero si el micro se cuelga entero puede
fallar con él; el *externo* es independiente y más confiable: en vuelo se
prefiere el externo, combinado con _checkpoints_ para restaurar el estado.

*Latch-up y otros circuitos.* Un sensor de corriente detecta el pico del
latch-up y corta la alimentación; después se reenciende (_power cycle_). Un
latch-up detectado a tiempo es un reinicio; no detectado, hardware perdido.
Además: protección de sobretensión (zener, TVS), *LCL* (limitadores que
aíslan la falla de un módulo para que no tire el bus), supervisores de
tensión (_brown-out_: si la tensión baja, reset limpio) y filtrado.

== Defensa por software

- *EDAC / ECC*: bits de control agregados. *Hamming SECDED* corrige 1 bit y
  detecta 2 (para 8 bits de dato, ≈4-5 de control). *Reed-Solomon* y *BCH*
  corrigen varios (útiles contra MBU). Puede estar en el hardware de la
  memoria o en software, en el módulo de FDIR (más barato, usa CPU).
- *Scrubbing*: leer periódicamente toda la memoria, corregir los errores de
  1 bit y reescribir, *antes* de que se junte un segundo error en la misma
  palabra (que Hamming ya no corrige). Crítico en FPGAs SRAM. EDAC +
  scrubbing es la combinación estándar.
- *Firmware*: varias copias; *bootloader* que verifica la integridad
  (checksum o CRC) y si no carga el respaldo; actualización en órbita (como
  Mars Pathfinder); en multinúcleo, reasignar tareas o _checkpointing_.

#ojo[el bootloader es a la vez protección y punto débil: si es la única
copia y se corrompe, el satélite queda inoperable. Por eso se replica.]

#tabla(
  columns: (auto, 1fr),
  [*Contra*], [*Capas*],
  [TID], [selección de componentes, blindaje, redundancia en frío],
  [SEU], [FRAM/MRAM, EDAC, scrubbing, TMR, watchdog],
  [SEL], [detección de sobrecorriente, LCL],
  [Fallas de software], [FDIR, programación defensiva, réplicas de firmware, checkpoints],
)

#pregunta[¿Qué diferencia hay entre DMR y TMR?][DMR detecta que hubo un
error (las dos salidas difieren) pero no sabe cuál módulo falló, así que
reinicia. TMR, con tres módulos y un votador por mayoría, enmascara el
error en tiempo real y sigue funcionando.]
#pregunta[¿Por qué EDAC solo no alcanza y hace falta scrubbing?][Porque
Hamming corrige un bit por palabra; un dato que no se lee en mucho tiempo
puede juntar dos errores y ya no se corrige. El scrubbing barre la memoria
y reescribe lo corregido antes de que se acumulen.]
#pregunta[¿Por qué en vuelo se prefiere un watchdog externo?][Porque si el
micro se cuelga por completo, un watchdog interno puede colgarse con él; el
externo es otro componente y garantiza el reset.]
#pregunta[¿Qué efecto define la vida útil de un componente y cuál puede
fallar en cualquier momento?][La vida útil la define la dosis acumulada
(TID, y el DD en ópticos); los eventos únicos (SEU, SEL, SET) pueden pasar
en cualquier momento, aun en un componente sano.]

= El primer TP: comparativa de OBC de mercado <sec-tp-obc>

*Qué pedía.* Buscar cinco OBC en satsearch, satbase u otro proveedor y,
para cada una: (a) qué parámetros de la clase de confiabilidad se ven en
su hoja de datos, (b) cinco características que la destacan y (c) cinco de
peor desempeño.

*Qué ejercita.* Leer una hoja de datos con los ojos de la clase 1: TID, TRL,
COTS o rad-hard, redundancia, memorias, latch-up, SEU, watchdog, FDIR y
buses.

*Cómo lo resolvimos* (Fran, Tomás y Santi, entregado el 18/08). Elegimos
NANOhpc-AI, Eddie Onboard Computer, CMCube, SIRIUS OBC LEON3FT y
Proton300k, y armamos tablas por tema. Lo que salió:

#tabla(
  columns: (auto, auto, auto, auto),
  [*OBC*], [*TID / tipo*], [*Redundancia y memorias*], [*Buses*],
  [Eddie], [no especifica], [FRAM interna y externa; watchdog interno y externo], [RS-485],
  [NANOhpc-AI], [no especifica], [redundancia en comunicaciones], [Ethernet],
  [CMCube], [COTS con blindaje 10×], [sin protección de memoria; watchdog externo], [varios buses aislados],
  [SIRIUS LEON3FT], [20-30 krad (COTS, supusimos)], [TMR; EDAC en boot flash y memorias; protección SEL], [SpaceWire, RS-422, RS-485],
  [Proton300k], [100 krad (rad-hard, supusimos)], [TMR; SEL parcial; FDIR], [RS-422],
)

Todas decían «TRL 9, _flight proven_». La conclusión que vale para el
cuestionario: *casi ninguna hoja de datos dice todo*; lo que no está
escrito no se puede suponer, y donde supusimos (COTS o rad-hard por los
krad) lo dijimos.

#pregunta[¿Qué datos de una hoja de datos de OBC hablan de su confiabilidad
frente a la radiación?][La TID tolerada (krad), si es COTS, rad-tolerant o
rad-hard, la protección contra latch-up, el tipo de memoria (FRAM/MRAM,
EDAC), la redundancia (TMR, frío), el watchdog y el FDIR.]
#pregunta[Una OBC tolera 100 krad y otra 20 krad. ¿Qué te dice eso?][Que la
primera está en el rango rad-hard (100 a 1000+ krad) y la segunda en el de
rad-tolerant o COTS: la segunda sirve para LEO corta, la primera para
misiones largas o más allá de LEO.]

= La OBC en la práctica: procesadores, arquitecturas y software <sec-obc>

Es la segunda parte de la clase de confiabilidad (el mismo paper).

#gancho[cuando te pregunten «¿qué OBC elegirías?», esto es lo que te deja
contestar con criterio y no por marca: qué familia de procesador, si
centralizada o distribuida, qué RTOS y qué framework.]

*Cuatro familias de procesamiento.* Microcontroladores COTS (lo más común:
housekeeping, TC/TM, actitud simple), procesadores rad-hard (más allá de
LEO: RAD750, LEON), FPGAs (paralelo reconfigurable: imágenes, compresión) y
SoC híbridos CPU + FPGA (+ GPU) para IA a bordo. ARM Cortex domina los µC
de CubeSats.

#tabla(
  columns: (auto, 1fr),
  [*µC*], [*Herencia*],
  [MSP430 (TI)], [16 bits, muy bajo consumo, ≈20 krad; LabOSat-01],
  [Cortex-M (STM32)], [el más popular en CubeSats COTS],
  [Cortex-R4F/R5F (TMS570)], [lockstep + ECC; LabOSat-02; grado automotriz],
  [AVR32 / AT91], [GomSpace NanoMind; Aalto-1],
  [LEON (SPARC)], [rad-hard, espacio profundo],
  [RAD750 (PowerPC)], [rad-hard, ≈200 krad; MRO, JWST],
)

*Centralizada o distribuida.* Centralizada: una OBC potente hace todo;
simple y barata, pero *único punto de falla* y poco escalable (CubeSats
simples). Distribuida: cada subsistema con su procesador y la OBC
coordinando por un bus; sin único punto de falla, modular, pero más
compleja de verificar y necesita un bus robusto. La regla práctica: cada
nodo se dimensiona para su tarea. Y la mayoría de los CubeSats son
*single-string*: si falla un elemento crítico, se pierde la misión.

*El software de vuelo (FSW)* se arma en capas: hardware → bibliotecas de
soporte → OS → middleware → framework → aplicación. Frameworks con herencia:
*cFS* de NASA, *KubOS* (Linux), *NanoSat MO Framework* de ESA (OPS-SAT),
*SAVOIR*. RTOS: *FreeRTOS* (el del laboratorio, el que domina en CubeSats),
*RTEMS*, *VxWorks* (Clementine, Juno, JWST), *RODOS*, Linux con PREEMPT_RT.

*Casos argentinos.* *LabOSat* (UNSAM): una placa que caracteriza
electrónica en LEO a ≈500 km, volando desde 2014 en satélites de
Satellogic; LabOSat-01 con MSP430 y LabOSat-02 con TMS570/RM48. *ATENEA*:
CubeSat 12U argentino que voló como carga secundaria de Artemis II (lanzado
el 1 de abril de 2026), liderado por CONAE con UNSAM, UNLP, FIUBA y VENG;
midió radiación hasta el espacio cislunar y se comunicó a más de 70 000 km.

La frase de cierre de la clase, que conviene tener a mano: *ensayar cómo se
va a volar, para volar como se ensayó*.

#pregunta[¿Cuándo convendría una arquitectura distribuida?][En misiones
complejas o plataformas reutilizables: elimina el único punto de falla,
reparte la carga y permite reusar módulos; a cambio exige un bus robusto y
cuesta más verificarla.]
#pregunta[¿Qué es «single-string»?][Una sola cadena sin redundancia total:
si falla un elemento crítico, se pierde la misión. Es lo más común en
CubeSats.]
#pregunta[Nombrá dos RTOS usados en vuelo y uno que usemos en la materia.][VxWorks
(JWST, Juno) y RTEMS (NASA y ESA); en la materia, FreeRTOS.]

= Arquitectura ARM: del núcleo al programa que corre <sec-arm>

Dos clases (semanas 2 y 3) sobre Yiu, _The Definitive Guide to ARM
Cortex-M3 and Cortex-M4_, y el manual de ARMv7.

#gancho[cuando un programa se cuelga en un HardFault, cuando una variable
local «desaparece» o cuando una interrupción no entra, la respuesta está
acá: dónde vive cada cosa en memoria y qué hace el núcleo antes de llegar
a tu `main`.]

== Perfiles, núcleo y microcontrolador

ARM *no fabrica chips*: diseña núcleos y los *licencia*. El fabricante (TI,
ST, NXP) les pone memoria y periféricos. Por eso dos micros con el mismo
Cortex pueden ser muy distintos por fuera.

#tabla(
  columns: (auto, 1fr, 1fr),
  [*Perfil*], [*Optimiza*], [*La pregunta que responde*],
  [Cortex-A], [rendimiento promedio; corre Linux], [¿qué tan rápido en promedio?],
  [Cortex-R], [peor caso acotado, confiabilidad (lockstep, ECC, TCM)], [¿qué tan lento en el peor caso? (WCET)],
  [Cortex-M], [costo, consumo, latencia de interrupción], [¿cuánto cuesta y cuánto consume?],
)

En un satélite pueden convivir los tres: A en el payload, R en la OBC, M en
los subsistemas. *Procesador* = sólo el núcleo (pipeline, registros, ALU,
controlador de interrupciones); *microcontrolador* = núcleo + flash + SRAM +
periféricos (UART, SPI, I²C, CAN, ADC, timers, GPIO). La F446RE de la
materia es un Cortex-M4 con FPU; el M4 es un M3 con instrucciones DSP y FPU
opcional (M4F).

#diapo("harvard", ancho: 92%)[Von Neumann contra Harvard (semana 2, _Arquitectura ARM_, diapo. 10). El Cortex tiene los buses de Harvard y un solo mapa de memoria.]

*Harvard*: buses separados para instrucciones y datos, así se busca la
próxima instrucción mientras se lee un dato; más rendimiento por ciclo y
tiempos más predecibles. *Von Neumann*: un solo bus que compiten
instrucciones y datos (el «cuello de botella de Von Neumann»). El Cortex es
Harvard *en los buses* con un *único* mapa de memoria de 4 GB.

#diapo("cortex-m", ancho: 80%)[Diagrama de bloques del Cortex-M3/M4 (semana 2, diapo. 11).]

Otras características que se preguntan: RISC de 32 bits *load/store* (la
ALU opera sobre registros); pipeline corto de 3 etapas en M3/M4 (el R tiene
8, con emisión dual); *Thumb-2* da densidad de código (menos flash: y en
vuelo la memoria es cara); WFI/WFE para dormir hasta un evento; la *MPU*
define regiones con permisos y convierte un puntero salvaje en una falla
detectada (no traduce direcciones, a diferencia de una MMU); el *NVIC* es
anidado (una más urgente interrumpe a otra) y vectorizado (el hardware
busca el handler en la tabla); latencia de interrupción fija de 12 ciclos
en M3/M4; *CMSIS* estandariza el acceso al núcleo entre fabricantes. En el
Cortex-R el controlador es externo (el *VIM* del TMS570).

== Modos, pilas y arranque

- *Cortex-M*: dos modos, *Thread* (aplicación) y *Handler* (excepciones);
  dos niveles, privilegiado y no privilegiado. Dos punteros de pila: *MSP*
  y *PSP*. *Cortex-R*: siete modos clásicos (User, System, SVC, IRQ, FIQ,
  Abort, Undefined), cada modo de excepción con su propio SP.
- La pila *crece hacia direcciones decrecientes* y guarda locales,
  argumentos que no entran en registros y direcciones de retorno. Al entrar
  a una excepción, el hardware apila parte del contexto solo.
- *Compilación*: preprocesador (`#include`, `#define`, `#if`) →
  compilador (a ensamblador) → ensamblador (objeto `.o`) → *linker* (une
  objetos y bibliotecas y fija direcciones con el *linker script*) → `.elf`,
  y de ahí `.bin`/`.hex` a la flash.
- *Reset*: se lee `0x00000000` y se carga en el MSP; se lee `0x00000004`
  (vector de reset) y se salta ahí; el *startup* inicializa la RAM, copia
  `.data`, configura relojes y salta a `main()`.
- *Tabla de vectores*: arreglo con la dirección de cada handler, en
  `0x00000000` tras reset; se puede mover con *VTOR*. Excepciones de sistema
  (Reset, NMI, HardFault, MemManage, BusFault, UsageFault, SVC, PendSV,
  SysTick) y desde la 16 las IRQ de periféricos (hasta 240).
- Un *fault* (acceso inválido, instrucción indefinida, división por cero si
  está habilitada) entra a su handler; el registro *CFSR* dice la causa. En
  vuelo, los faults son *entradas al FDIR*.

== Dónde vive cada cosa de un programa C

#diapo("memoria-c", ancho: 94%,
  notas: ((0.78, 0.17, [1]), (0.90, 0.43, [2])),
)[Ejecución de un programa en C (semana 3, _Arquitectura ARM Cortex_, diapo. 20 del recorte). *1*: el marco de `add()`, apilado sobre el de `main()`, con `a` y `b` copiados. *2*: lo que pidió `malloc`, en el heap: no se libera solo.]

La clase lo cuenta cuadro a cuadro: antes de la primera línea de `main()`,
las globales y `static` ya tienen lugar fijo (`total_global = 100` en
`.data`, `counter` en `.bss`). Al llamar a `main()` se apila su *marco*;
`malloc` reserva en el *heap* y el puntero `buf` vive en la pila pero
apunta al heap; `add()` apila su propio marco con `a` y `b` *copiados*; al
retornar, ese marco se destruye. Si te olvidás el `free`, el bloque queda
reservado para siempre: *memory leak*.

#pregunta[¿En qué sección queda `static int counter;`, y en cuál
`int total_global = 100;`?][`counter`, sin inicializar, en `.bss`;
`total_global`, inicializada, en `.data`. Las dos existen antes de que
corra `main()`.]
#pregunta[¿Qué hace el Cortex-M al salir del reset?][Carga en el MSP el
valor de la dirección `0x00000000`, toma el vector de reset de `0x00000004`
y salta ahí; el código de arranque inicializa la memoria y llama a
`main()`.]
#pregunta[¿Qué diferencia hay entre una MPU y una MMU?][La MPU sólo vigila
permisos por región y aborta accesos ilegales, con tiempo predecible; la
MMU además traduce direcciones (memoria virtual).]
#pregunta[¿Por qué el Cortex-R se elige para la OBC y no el
Cortex-A?][Porque optimiza el peor caso (tiempo acotado) y trae tolerancia a
fallas (lockstep, ECC, TCM de latencia fija); el A optimiza el promedio a
costa de la previsibilidad.]

= C embebido: lo que más se pregunta <sec-c>

La clase _Programación en C embebido_ son 157 diapositivas y están
convertidas, módulo por módulo y con cada programa compilado sin warnings,
en el *Apunte de C* (en el Drive de apuntes). Acá va el destilado.

#catedra[cómo se entrega el código][
  Se compila *siempre* con `gcc -Wall -Wextra -std=c11` y un ejercicio no
  está terminado hasta que da *cero warnings*. Un `.c` por ejercicio, en la
  terminal de Ubuntu. La estructura es la de `template.c`: bibliotecas de
  C, macros, bibliotecas propias, globales, *declaración* de funciones
  arriba de `main()` y *definición* abajo.
]

```c
/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */

/* User libraries */

/* Global variables */

/* Functions declaration */

int main(void) {
	/* Main program */

	return 0;
}

/* Functions definition */
```

#tabla(
  columns: (auto, 1fr, auto),
  [*Tema*], [*Lo que se pregunta*], [*Apunte de C*],
  [Tipos], [ancho fijo siempre (`uint8_t`, `int16_t`, `uint32_t`); `unsigned` para cantidades y bits; desborde; `sizeof`; `%u`, `%d`, `%X`], [módulo 2],
  [Calificadores], [`const` (no se modifica), `volatile` (lo cambia algo de afuera: no optimizar la lectura), `static` (local: conserva el valor; global: sólo ese archivo)], [módulo 3],
  [Bits], [poner `x |= (1U << n)`, borrar `x &= ~(1U << n)`, leer `x & (1U << n)`, invertir `^=`; nunca con `if` sueltos], [módulo 4],
  [Control], [`while` *con cota*; `switch` con `default`; *dangling else*], [módulo 5],
  [Funciones], [declarar y definir; valor y referencia; recursión (no en vuelo)], [módulo 6],
  [Vectores], [índices desde 0; cadena terminada en `'\0'`; tablas de patrones], [módulo 7],
  [Punteros], [`&`, `*`, `NULL`, aritmética, puntero y array, puntero a función], [módulo 8],
  [Máquinas de estados], [`enum` + `switch`, `default` que lleva a falla, transición por evento], [módulo 9],
  [Compuestos], [`struct`, `->`, padding, `union`, endianness, campos de bits], [módulo 10],
  [Preprocesador], [`#include`, guardas, `#if`, `.h` y `.c`], [módulo 11],
  [Memoria de vuelo], [stack, `.data`/`.bss`, sin `malloc`, `volatile`, registros mapeados, secciones críticas], [módulo 12],
)

#dedos[`volatile` es avisarle al compilador «esta variable la puede cambiar
alguien que vos no ves». Sin eso, ve un `while (bandera == 0)` donde nadie
escribe `bandera` adentro, la lee una vez y se queda girando para siempre,
aunque la interrupción ya la haya puesto en 1. Lo peor: con optimización
apagada suele andar igual, así que el bug aparece el día que alguien
compila en _Release_.]

Una máquina de estados como la quiere Leandro (`enum` + `switch` +
`default` defensivo):

```c
typedef enum { MODO_SAFE, MODO_NOMINAL, MODO_FALLA } modo_t;

static modo_t paso(modo_t modo, uint8_t bateria_ok)
{
	modo_t siguiente = MODO_FALLA;

	switch (modo) {
	case MODO_SAFE:
		siguiente = (bateria_ok != 0U) ? MODO_NOMINAL : MODO_SAFE;
		break;
	case MODO_NOMINAL:
		siguiente = (bateria_ok != 0U) ? MODO_NOMINAL : MODO_SAFE;
		break;
	default: /* un valor corrupto (un SEU) cae acá */
		siguiente = MODO_FALLA;
		break;
	}
	return siguiente;
}
```

#ojo[el error típico de bits es `x & ~1 << n` sin paréntesis, o borrar con
`x &= (1 << n)`, que deja *sólo* ese bit. Y el de espera es el `while`
sin cota: «un OBC no se puede quedar colgado esperando algo que no llega».]

#pregunta[¿Para qué sirve `volatile` y cuándo se usa?][Le dice al
compilador que la variable puede cambiar fuera del flujo del programa
(hardware, una ISR), así que la lee de memoria cada vez. Se usa en
registros mapeados y en variables compartidas entre una ISR y el `main`.]
#pregunta[¿Qué hace `static` en una variable local y en una global?][En una
local, la variable conserva su valor entre llamadas (vive en `.data` o
`.bss`, no en la pila); en una global, la deja visible sólo en ese archivo.]
#pregunta[¿Cómo apagás el bit 3 de un registro sin tocar los demás?][`reg &= ~(1U << 3);` — la máscara tiene todos unos menos el bit 3.]
#pregunta[¿Por qué tipos de ancho fijo y no `int`?][Porque el tamaño de
`int` depende del compilador y la plataforma; `uint16_t` mide 16 bits en la
PC y en el micro. Es la Directiva 4.6 de MISRA.]

= MISRA-C: el C defensivo con número de regla <sec-misra>

#gancho[MISRA no inventa nada: es la programación defensiva que venimos
viendo, convertida en un checklist que una herramienta puede verificar.
Sirve para justificar *por qué* algo está prohibido, que es lo que te van a
preguntar.]

*MISRA* (_Motor Industry Software Reliability Association_) publicó reglas
en 1998 para C en sistemas críticos; nació en el automotor y hoy se usa en
médicos (IEC 62304), automotriz (ISO 26262) y aviónica (bajo DO-178C).
*MISRA C:2012* tiene *175 guías*: *16 directivas* (generales, no siempre
verificables por herramienta) y *159 reglas* (verificables por análisis
estático).

#tabla(
  columns: (auto, 1fr),
  [*Categoría*], [*Qué significa*],
  [Mandatory], [nunca se rompe, no admite desvío (nueva en C:2012)],
  [Required], [se cumple salvo un *desvío documentado y justificado*],
  [Advisory], [buena práctica; el equipo puede no seguirla con menos trámite],
)

#tabla(
  columns: (auto, auto, 1fr),
  [*Regla*], [*Cat.*], [*Qué dice y por qué*],
  [1.3], [M], [nada de comportamiento indefinido: la regla paraguas],
  [9.1], [R], [no leer una local sin inicializar: tiene basura],
  [16.4], [R], [todo `switch` con `default`: un byte corrompido por un SEU no pasa de largo],
  [15.1], [A], [evitar `goto` (hay usos legítimos: la salida ante error)],
  [Dir 4.12], [R], [sin `malloc`/`free`: el heap no es determinista y se fragmenta],
  [17.2], [R], [sin recursión: la profundidad puede crecer y desbordar la pila],
  [11.1], [R], [no convertir punteros a función a otro tipo: saltarías a cualquier lado],
  [8.13], [A], [puntero a `const` si no se modifica: el error pasa a ser de compilación],
  [Dir 4.6], [A], [tipos de ancho fijo],
  [17.7], [R], [usar el valor de retorno: suele ser el aviso de error],
  [15.5], [A], [un solo punto de salida],
  [21.6], [R], [nada de `stdio.h` en vuelo: no hay consola ni archivos],
  [10.x], [R], [modelo de tipos esencial: sin conversiones implícitas peligrosas],
  [Dir 4.14], [R], [validar toda entrada externa (TC, sensor, byte de UART)],
  [14.4], [R], [la condición de un `if` es booleana: `if (p != NULL)`, no `if (p)`],
  [13.3], [A], [un solo efecto secundario por expresión con `++`/`--`],
  [13.4], [A], [no usar el resultado de una asignación: el clásico `if (x = 5)`],
  [2.1], [R], [sin código inalcanzable],
  [8.7], [A], [`static` si sólo se usa en el archivo: visibilidad mínima],
)

#diapo("misra-switch", ancho: 82%)[Regla 16.4: el `switch` sin `default` (incorrecto) y con él (correcto). _MISRA-C_, semana 2, diapo. 8.]

#diapo("misra-recursion", ancho: 82%)[Regla 17.2: el factorial recursivo (incorrecto) y el iterativo (correcto), diapo. 11.]

*El ejercicio `satelite.c`* (diapositiva final de MISRA): encontrar y
arreglar tres violaciones. Las tres: (1) `medicion_sensor` se lee sin
inicializar si el modo no es NORMAL (*9.1*: se inicializa al declarar);
(2) el `switch (modo_operacion)` no tiene `default` (*16.4*: se agrega uno
que lleve a modo seguro o registre la anomalía); (3) un `malloc` de 10
`uint32_t`, tamaño conocido de antemano (*Dir 4.12*: arreglo estático
`uint32_t buffer[10]`). Compilando con `-Wall -Wextra`, la primera la marca
el propio gcc (_may be used uninitialized_).

El *ejercicio 2* del kit: validar un byte «externo» antes de usarlo, con
condición explícitamente booleana y sin asignar y comparar en la misma
expresión (Dir 4.14, 14.4 y 13.4), probando con un valor válido y uno
inválido.

#pregunta[¿Qué diferencia hay entre una regla Required y una
Advisory?][La Required se cumple salvo que haya un desvío formal,
documentado y justificado; la Advisory es una recomendación que el equipo
puede no seguir con criterio profesional.]
#pregunta[¿Por qué MISRA prohíbe `malloc` en vuelo?][Porque el heap no es
determinista (el tiempo de reserva varía) y se fragmenta con el uso; en
tiempo real ninguna de las dos cosas se tolera. Se usa memoria estática
(Directiva 4.12).]
#pregunta[¿Por qué todo `switch` lleva `default` aunque «nunca» se
alcance?][Porque un valor inesperado (un byte corrompido por un SEU) tiene
que tener una acción definida, en vez de pasar sin que nadie se entere
(regla 16.4).]

= TP1 — Práctico de programación en C <sec-tp1>

*Qué pedía.* Nueve ejercicios en la terminal de Ubuntu, un `.c` cada uno,
todos ambientados en una OBC: 1 telemetría básica (tipos de ancho fijo,
porcentaje de batería entre 3,0 V y 4,2 V, potencia); 2 límites de
configuración (`#define`, `const`); 3 registro de hardware y contador de
arranque (`volatile`, `static`); 4 panel de banderas de subsistemas
(`|=`, `&= ~`, `&`, `<<`); 5 validación de telecomando (`if/else` +
`scanf`); 6 espera *acotada* a un sensor; 7 el integrador, secuencia de
arranque de la OBC; 8 y 9, bonus de funciones y paso por referencia.

*Qué ejercita.* Todo el C de vuelo básico: es la columna del Apunte de C
(módulos 1 a 9).

*Cómo se resolvió.* Cada ejercicio con `template.c` y `gcc -Wall -Wextra
-std=c11` hasta cero warnings, y la salida con el formato de la «salida
esperada» (los números pueden variar, el formato y la lógica no). Los
programas están en las prácticas de WSL y cada patrón tiene su ejemplo
compilado en el Apunte de C.

#pregunta[En el ejercicio 6, ¿por qué el `while` lleva un máximo de
intentos?][Porque si el sensor nunca responde, un bucle sin cota cuelga la
OBC para siempre; con la cota, se sale, se informa la falla y se sigue.]
#pregunta[En el ejercicio 3, ¿qué cambia si le sacás el `static` al
contador?][Se vuelve a crear en la pila en cada pasada y arranca en cero
cada vez; con `static` se inicializa una sola vez y conserva la cuenta.]

= STM32CubeIDE y Wokwi <sec-cubeide>

Semana 4: instalar *STM32CubeIDE 1.18.1* (versión fija para todos: anda y
trae la HAL integrada), crear el primer proyecto para la NUCLEO-F446RE y
mirar el `.ioc`. El paso a paso está en la *guía de IDEs* que hicimos;
acá, lo conceptual.

- *Workspace*: la carpeta que contiene todos los proyectos; sin espacios,
  acentos ni eñes en la ruta.
- Dos *perspectivas*: C/C++ (escribir y compilar) y *Device Configuration
  Tool* (se abre con el `.ioc`: es CubeMX adentro del IDE).
- El *`.ioc`* es la representación gráfica del micro: con él se *genera* el
  código C de inicialización (relojes, pines, periféricos). No escribe la
  lógica. Pin gris: libre; de color: usado o en conflicto.
- *Generate Code* traduce la configuración a `.c` y `.h`. Lo tuyo va
  *entre* `USER CODE BEGIN` y `USER CODE END`: lo de afuera se pisa al
  regenerar.
- *Build* (el martillo) compila sin placa; el resultado es un *`.elf`*.
- Wokwi no simula la F446RE, pero sí la *NUCLEO-C031C6* con el mismo patrón
  HAL: se compila para la C031C6 y se carga el `.elf` con `wokwi.toml` (qué
  programa) y `diagram.json` (qué placa y qué se conecta). El LED titila
  con `HAL_GPIO_TogglePin` cada medio segundo. El *desafío*: un display de
  7 segmentos contando de 0 a 9.

#pregunta[¿Por qué el código propio va entre `USER CODE BEGIN` y
`END`?][Porque al regenerar desde el `.ioc` CubeIDE reescribe el archivo y
sólo conserva lo que está dentro de esos bloques.]
#pregunta[¿Para qué sirven `wokwi.toml` y `diagram.json`?][`wokwi.toml` le
dice a Wokwi qué firmware cargar (la ruta al `.elf`); `diagram.json`, qué
placa simular y qué componentes se conectan a qué pines.]

= TP2 — GPIO, ADC y UART en Wokwi <sec-tp2>

*Qué pedía.* Sobre la NUCLEO-C031C6 simulada: *ejercicio 1*, cuatro LEDs
contando en binario de 0 a 15 en bucle; *ejercicio 2*, un potenciómetro
como sensor analógico leído por el ADC, con un LED de alarma cuando pasa un
umbral y el valor impreso por UART con `printf`.

*Qué ejercita.* GPIO de salida con varios pines, operadores de bit (cada
LED es un bit del contador), el ADC (tensión → número) y la redirección de
`printf` a la UART.

*Cómo se resolvió.* Proyecto por Board Selector, pines en el `.ioc`, la
lógica en `USER CODE`, y `diagram.json` con cada pin verificado contra la
definición de la placa en Wokwi (los pines repetidos llevan sufijo, como
`GND.9`; un nombre que no existe falla en silencio). Entregado como
`TP2_Salomone.zip`.

#pregunta[¿Cómo sacás el valor de un contador de 0 a 15 a cuatro LEDs sin
cuatro `if`?][Con una máscara por bit: el LED _n_ se prende si `(cuenta >> n) & 1U` vale 1; un bucle de 0 a 3 recorre los cuatro.]
#pregunta[¿Qué hace un ADC?][Convierte una tensión continua en un número;
no es una interfaz de comunicación, pero es la puerta de entrada de los
sensores analógicos.]

= Periféricos e interfaces de comunicación <sec-perif>

#gancho[cada vez que dos partes del satélite se hablan, alguien eligió un
bus. La clase te da con qué criterio: *qué tan lejos* tienen que viajar los
datos y *cuántos* dispositivos comparten el cable. Y te cuenta, con casos
reales, cómo falla cada uno.]

*Conceptos base.* Serie (un bit tras otro, pocos cables) o paralelo (varios
a la vez); simplex (un sentido), half-duplex (los dos, por turnos),
full-duplex (los dos a la vez); *single-ended* (la señal contra masa) o
*diferencial* (un par con la señal y su inversa: el receptor resta, y el
ruido que entra igual en los dos se cancela).

#grid(columns: (1fr, 1fr), column-gutter: 12pt,
  diapo("serie-paralelo", ancho: 86%)[Serie contra paralelo (semana 6, diapo. 2).],
  diapo("duplex", ancho: 86%)[Simplex, full-duplex y half-duplex (diapo. 3).],
)

#diapo("diferencial", ancho: 86%)[Single-ended contra diferencial (diapo. 4): a la derecha, el ruido entra igual en los dos cables del par y al restar se va.]

#tabla(
  columns: (auto, auto, auto, auto),
  [*Dominio*], [*Interfaces*], [*Distancia*], [*Dispositivos*],
  [Intra-sistema], [GPIO, ADC, I²C, SPI], [mm a ≈30 cm], [varios],
  [Frontera], [UART], [cm a metros], [punto a punto],
  [Inter-sistema], [RS-422/485, CAN, MIL-1553], [metros a decenas], [multipunto],
  [Alta velocidad], [SpaceWire, LVDS, Ethernet, USB, PCIe], [metros], [punto a punto o red],
)

== Intra-sistema: UART, I²C y SPI

*UART*: asíncrona (sin reloj compartido), dos hilos TX/RX, los dos extremos
acuerdan de antemano baudrate y formato (bits de datos, paridad, stop); sin
direccionamiento; punto a punto. Debug y TM/TC de baja velocidad.

#diapo("i2c", ancho: 84%,
  notas: ((0.72, 0.1, [1]),),
)[I²C: el bus y una trama de lectura de un sensor de temperatura (diapo. 13). *1*: los pull-up de SDA y SCL: los dispositivos sólo bajan la línea (open-drain).]

*I²C*: dos hilos compartidos, *SDA* y *SCL*; cada esclavo tiene una
*dirección de 7 bits* y el maestro llama a la que quiere. 100 kbit/s
estándar, 400 rápido, 1000 fast-plus; nació para chips de la misma placa
(centímetros). Problemas: *bus lockup* (un esclavo se queda a mitad de trama
reteniendo SDA y el bus entero queda inutilizable), sin timeout ni reset
estándar, y un solo chip defectuoso tumba todo. El caso real: la misión
*NASA V-R3x* agregó un circuito de aislación por dispositivo que se
auto-aísla si falla, y eliminó ese modo de falla en I²C y SPI.

#diapo("spi", ancho: 66%,
  notas: ((0.0, 0.0, [1]),),
)[SPI: los modos de reloj, de la hoja de datos de una memoria Cypress (diapo. 19). *1*: CPOL elige el nivel de reposo del reloj; CPHA, en qué flanco se toma el dato. Tienen que ser iguales en los dos lados.]

*SPI*: SCLK, MOSI, MISO y un *CS por dispositivo*; el maestro elige con quién
habla bajando su CS. Full-duplex, varios a decenas de Mbit/s, sin
direccionamiento por software; cada esclavo nuevo cuesta un pin de CS.
*CPOL/CPHA* son la polaridad y la fase del reloj y los dos extremos tienen
que coincidir. El caso real de la clase: entre dos unidades (LS01/LS02), un
SCLK en reposo *alto* (CPOL = 1) dejaba 3,3 V permanentes en el cable y
*alimentaba de forma parásita* a la otra placa, que se encendía sola; se
arregló con reposo bajo (CPOL = 0).

#tabla(
  columns: (auto, 1fr, 1fr),
  [], [*I²C*], [*SPI*],
  [Hilos], [2 (SDA, SCL)], [4 (SCLK, MOSI, MISO, CS)],
  [Direccionamiento], [por software (7 bits)], [por hardware (un CS por esclavo)],
  [Velocidad], [100-400 kbit/s], [varios Mbit/s],
  [Escala con], [muchos dispositivos, pocos pines], [pocos dispositivos, alta velocidad],
  [Falla vista], [bus lockup (V-R3x)], [alimentación parásita por CPOL (LS01)],
)

== Inter-sistema

- *RS-232*: single-ended, ±3 a ±15 V (el 1 es negativo), hasta 15 m;
  bancos de prueba y tierra, casi nunca a bordo.
- *RS-422/485*: diferencial, hasta 1200 m a baja velocidad. 422: un
  transmisor y hasta diez receptores; *485: multipunto*. Sin detección de
  errores ni arbitraje propio: hace falta un protocolo arriba.
- *CAN* (Bosch, automotor): diferencial, *multi-master con arbitraje no
  destructivo* por prioridad del ID (no se pierde el mensaje), y *CRC* en
  cada trama con señalización de error y retransmisión. Hasta 1 Mbit/s
  (5 en CAN FD). *SpaceCAN* propone reemplazar I²C por CAN en satélites
  chicos: más robusto, a costa de más consumo.
- *MIL-STD-1553*: militar, diferencial, determinista, con un *único bus
  controller* y *bus A / bus B* redundantes. BepiColombo lo usa para TM/TC.
- *SpaceWire* (ESA, ECSS-E-ST-50-12C): enlaces punto a punto full-duplex
  sobre *LVDS*, con routers que arman una red; 2 a 200 Mbit/s; JWST, Gaia,
  ExoMars. Su sucesor, SpaceFibre, hasta 10 Gbit/s.
- *LVDS* es una capa física, no un protocolo. *USB* y *Ethernet* son raros
  en vuelo (tierra, debug: el ST-LINK es USB). *PCIe* aparece en payloads
  de cómputo de alto rendimiento.

#diapo("can", ancho: 78%,
  notas: ((0.01, 0.09, [1]),),
)[La trama de CAN, de datos y remota (diapo. 29). *1*: el campo de arbitraje: el ID del mensaje es su prioridad.]

#pregunta[¿Por qué un bus diferencial aguanta más distancia que uno
single-ended?][Porque el ruido electromagnético entra igual en los dos
cables del par y el receptor mide la diferencia: el ruido se cancela.]
#pregunta[¿Qué es el bus lockup del I²C?][Un esclavo queda a mitad de trama
reteniendo SDA; como el protocolo no define timeout ni reset, el bus entero
queda inutilizable por un solo dispositivo.]
#pregunta[¿Qué tiene CAN que no tiene RS-485?][Arbitraje no destructivo
entre varios maestros y detección de errores con CRC en cada trama, con
retransmisión.]
#pregunta[¿Qué pasa si maestro y esclavo SPI tienen distinto
CPOL/CPHA?][Los datos llegan corridos o corruptos aunque haya actividad en
las líneas: es un error clásico de integración.]

= TP3 — La NUCLEO-F446RE de verdad <sec-tp3>

*Qué pedía.* Pasar de la simulación a la placa: *ejercicio 0*, que
`printf` llegue a una terminal de la PC por el puerto serie virtual del
ST-LINK; *1*, blink con distintos retardos; *2*, el LED modulado por el
botón de usuario B1 (entrada digital); *3*, un indicador NOMINAL/WARNING en
el display de 7 segmentos (`mostrar_digito`); *4* (bonus), *blink no
bloqueante*, sin `HAL_Delay` en ningún lado.

*Qué ejercita.* GPIO de entrada y salida reales, UART real, funciones
reusables y, sobre todo, la diferencia entre esperar *bloqueando* y
comparar tiempos.

*Cómo se resolvió.* En `tata_22_09TP3` (la F446RE), con la lógica en
`USER CODE`, el dígito en una función con tabla de patrones y el blink no
bloqueante con `HAL_GetTick()`:

```c
static uint32_t ultimo = 0U;

if ((HAL_GetTick() - ultimo) >= PERIODO_MS) {
	ultimo = HAL_GetTick();
	HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin);
}
/* el resto del lazo sigue corriendo: leer el botón, el display... */
```

#catedra[el bonus del Práctico 3][
  Leandro lo presenta como «el paso que separa un blink de juguete de código
  de vuelo real»: `HAL_Delay()` tiene un costo oculto, porque mientras
  espera la CPU no hace nada más.
]

#pregunta[¿Por qué `HAL_Delay` es un problema en una OBC?][Porque bloquea:
mientras espera, el programa no atiende nada más (ni telecomandos, ni el
watchdog). Comparando el tiempo transcurrido con `HAL_GetTick()`, el lazo
sigue corriendo.]
#pregunta[¿Por qué `HAL_GetTick() - ultimo` sigue funcionando cuando el
contador da la vuelta?][Porque la resta de enteros sin signo es módulo
2³²: la diferencia sale bien aunque el contador haya pasado por cero.
(Esto es de afuera: es aritmética de C, no está en la diapositiva.)]

= Funciones y punteros <sec-punteros>

Semana 7, con sus programas (`pasaje.c`, `retorno_multiple.c`,
`recursion.c`, `factorial_iterativo.c`, `punteros_funciones.c`,
`menu_obc_switch.c`, `callbacks.c`, `struct_satelite.c`).

#gancho[los drivers de la HAL, los callbacks de las interrupciones del TP4 y
las tareas de FreeRTOS del TP5 son *punteros a función* y *punteros a
struct*. Si esto está claro, el resto de la materia se lee de corrido.]

*Funciones.* Un bloque con nombre que hace *una* tarea; ninguna debería
pasar de ≈60 líneas (una hoja A4). Se *declara* (prototipo, arriba), se
*define* (abajo) y se *llama*.

#diapo("pasaje", ancho: 86%)[El ejemplo del intercambio, `pasaje.c` (semana 7, diapo. 5). Respuestas a los tres «¿cuánto vale acá?»: 10, 10 y 11.]

*Por valor* la función recibe una *copia*: modificarla no toca el
original. *Por referencia* (con un puntero) recibe la *dirección* y puede
modificar el original. En embebido importa el costo: un struct grande por
valor se copia entero a la pila; un puntero son 4 bytes. Regla: tipos
chicos por valor, estructuras y buffers por puntero. Para *devolver varios
valores*, punteros a donde guardarlos y el retorno como código de estado
(`retorno_multiple.c`: mínimo, máximo y promedio por punteros, y `0` o
`-1` de retorno).

*Recursión.* Necesita caso base y acercarse a él; cada llamada apila un
marco. En vuelo se *evita*: la profundidad puede depender de los datos y
desbordar la pila. El factorial iterativo usa un solo marco.

*Punteros a función.* El código de una función tiene dirección; un puntero
la guarda y permite llamarla indirectamente. Sintaxis `tipo (*nombre)(args)`
(los paréntesis son obligatorios):

```c
void (*p_encender)(uint32_t);
uint8_t (*p_apagar)(void);

p_encender = encender_camara;
p_encender(1080U);           /* llama a encender_camara(1080) */

p_apagar = apagar_camara;
estado = p_apagar();         /* devuelve CAMARA_APAGADA */
```

#ojo[sin los paréntesis, `void *p_encender(uint32_t);` no es un puntero a
función: es el prototipo de una función que *devuelve* un `void *`.]

*Dispatch table*: en vez de un `switch` largo, una tabla de punteros a
función indexada por el código de telecomando; agregar un comando es
agregar una entrada. La validación `codigo_de_tc < CANTIDAD_DE_TC` es
*obligatoria en vuelo*:

```c
typedef void (*comando_t)(void);
static const comando_t tabla_tc[CANTIDAD_DE_TC] = {
	encender_camara, apagar_camara, enviar_telemetria
};

if (codigo_de_tc < CANTIDAD_DE_TC) {
	tabla_tc[codigo_de_tc]();
}
```

*Callback*: un puntero a función que le pasás a otra función o módulo para
que te «devuelva la llamada» cuando pase algo. El driver de UART llama al
callback cuando llega un dato, sin conocer la aplicación: capas
independientes. En `callbacks.c`, `controlar_temperatura(80,
activar_modo_seguro)` no sabe *qué* hacer ante la alarma: llama a lo que le
pasaron. Cuidado: un callback suele correr en contexto de interrupción;
tiene que ser corto, no bloquear y cuidar los datos compartidos (`volatile`,
secciones críticas).

#diapo("struct", ancho: 80%,
  notas: ((0.62, 0.17, [1]), (0.80, 0.63, [2])),
)[Acceso a miembros (semana 7, diapo. 19). *1*: con la variable, `.`; *2*: con el puntero, `->`.]

*Structs.* Un array agrupa elementos del mismo tipo; un `struct`, datos de
tipos distintos relacionados (un paquete de telemetría: marca de tiempo,
id, estado, valor). Con una variable se accede con `.`; con un puntero, con
`->`. En drivers casi siempre se trabaja con punteros a struct, y se pasa
`const struct telemetria *` cuando la función sólo lee.

#pregunta[¿Qué imprime `incrementar_por_valor(contador)` en `main` si
`contador` vale 10? ¿Y por referencia?][Por valor, `main` sigue viendo 10
(se modificó la copia); por referencia, 11.]
#pregunta[¿Por qué la dispatch table necesita validar el índice?][Porque un
código de telecomando fuera de rango indexaría fuera de la tabla y el
programa saltaría a una dirección arbitraria.]
#pregunta[¿Qué es un callback y por qué desacopla capas?][Una función que
se registra en otro módulo para que la llame cuando ocurre un evento; el
driver no necesita conocer la aplicación, sólo llama al puntero que le
dieron.]
#pregunta[¿Cuándo `.` y cuándo `->`?][`.` con una variable de tipo struct;
`->` con un puntero a struct (`p->campo` es `(*p).campo`).]

= Sistemas operativos de tiempo real <sec-rtos>

#gancho[con el super-loop, una tarea lenta frena a todas. El RTOS es lo
que permite que el control de actitud corra cada 100 ms *pase lo que pase*
con la telemetría. Es también la clase más preguntable: tiene un caso real
famoso, un vocabulario cerrado y una tabla de «¿cuál uso?».]

#diapo("superloop", ancho: 86%)[Del super-loop al RTOS (semana 8, diapo. 4).]

*Tiempo real* = la corrección depende del resultado *y del instante*.
*Hard*: perder un plazo es una falla (control de actitud, encender un
propulsor). *Firm*: un resultado tarde no sirve pero el sistema sigue (un
cuadro de imagen tardío se descarta). *Soft*: tarde degrada la calidad
(housekeeping). *Tiempo real no es rápido: es predecible.*

#diapo("periodo", ancho: 86%)[Período T, ejecución C y deadline D; abajo, la salida de un RTOS donde dos tareas pierden su plazo (diapo. 6, sobre Wang, _Embedded and Real-Time Operating Systems_).]

Cada tarea tiene *período* T, *tiempo de ejecución* C y *deadline* D, con
la condición necesaria *C < D ≤ T*.

== Tareas, estados y scheduler

Una *tarea* es una función con un lazo infinito (nunca retorna), con *pila
propia*, una *prioridad* y un *TCB* (_Task Control Block_: prioridad,
estado, puntero de pila).

```c
void vTareaTelemetria(void *pv)
{
	for (;;) {
		armar_paquete();
		enviar_por_uart();
		vTaskDelay(pdMS_TO_TICKS(1000));
	}
}
/* en main(), antes de arrancar el scheduler: */
xTaskCreate(vTareaTelemetria, "TLM", 256, NULL, 2, NULL);
```

#diapo("estados", ancho: 82%)[Estados de una tarea (semana 8, diapo. 11). A Blocked se llega con `vTaskDelay()`, una cola vacía o un `Take` que espera.]

#diapo("contexto", ancho: 88%)[Cambio de contexto: los registros de la tarea saliente van a su pila y el SP pasa a la de la entrante (diapo. 10).]

*Scheduler* de FreeRTOS: corre siempre la tarea *lista de mayor prioridad*
(número más alto = más prioridad); con igual prioridad se turnan en cada
tick (*round-robin*); la tarea *Idle* (prioridad 0) corre cuando no hay
nada más. Decide en cada tick y cada vez que una tarea se bloquea o
desbloquea. Por defecto: `configUSE_PREEMPTION = 1` y
`configUSE_TIME_SLICING = 1`. Cómo asignar prioridades: *Rate Monotonic*,
a menor período, mayor prioridad (ADCS a 100 ms por encima de la
telemetría a 1 s).

#diapo("preempcion", ancho: 84%)[Preempción en una línea de tiempo (diapo. 14).]

#tabla(
  columns: (auto, 1fr, 1fr),
  [*Política*], [*Ventaja*], [*Riesgo*],
  [Cooperativa], [simple, sin sorpresas], [una tarea que no cede frena a todas],
  [Preemptiva por prioridades], [respuesta rápida a lo urgente], [inanición de las de baja prioridad],
  [Round-robin], [reparto equitativo], [más cambios de contexto],
)

*El tick* (típicamente 1 kHz → 1 ms). `vTaskDelay(n)` bloquea *n ticks*
sin consumir CPU; `vTaskDelayUntil()` mantiene un período fijo (ideal para
control). `HAL_Delay(100)` es *espera activa*: la CPU gira 100 ms y las de
menor prioridad no corren.

== Cola, semáforo, mutex

El problema: dos tareas leen un contador en 5 y escriben 6; se esperaba 7.
El error depende del instante del cambio de tarea.

#diapo("cola", ancho: 80%)[Colas: productor y consumidor (diapo. 19).]

#diapo("semaforo", ancho: 80%)[Semáforo binario: la ISR avisa, la tarea trabaja (diapo. 20).]

- *Cola*: buffer FIFO de tamaño fijo; los datos *se copian*. Cola vacía →
  quien recibe espera bloqueado sin consumir CPU; llena → quien envía puede
  esperar con timeout. Desacopla productor y consumidor.
  `xQueueCreate`, `xQueueSend`, `xQueueReceive`.
- *Semáforo binario*: vale 0 o 1, *señaliza un evento* («llegó el dato»).
  *Contador*: de 0 a N (eventos pendientes o N buffers). El patrón típico:
  la *ISR hace lo mínimo* (`Give`) y despierta a una tarea que hace el
  trabajo pesado con su prioridad.
- *Mutex*: un candado *con dueño* (sólo quien lo toma lo libera) para
  proteger un recurso (el bus I²C); se toma lo menos posible y se libera
  siempre. Tiene *herencia de prioridad*.

#diapo("inversion", ancho: 86%)[Inversión de prioridades (diapo. 23): M, que no necesita el mutex, corre mientras H espera.]

*Inversión de prioridades*: L (baja) toma el mutex; H (alta) lo pide y se
bloquea; M (media), que no necesita el mutex, desaloja a L y corre; H
termina esperando a M. *Solución, herencia de prioridad*: mientras L tiene
el mutex que H necesita, L hereda la prioridad de H y M ya no la desaloja.

*Mars Pathfinder (1997).* Días después de aterrizar, la computadora se
reiniciaba sola una y otra vez. Una tarea de meteorología de baja prioridad
tenía el mutex del bus de información; la tarea de alta prioridad del bus
lo esperaba; una de comunicaciones de prioridad media seguía corriendo. El
watchdog veía que la tarea del bus no completaba su ciclo y reseteaba. Se
arregló habilitando la herencia de prioridad en ese mutex de VxWorks:
*un parámetro, mandado desde la Tierra*.

#tabla(
  columns: (auto, 1fr, auto, auto),
  [*Mecanismo*], [*Sirve para*], [*¿Datos?*], [*¿Dueño?*],
  [Cola], [pasar datos entre tareas o desde una ISR], [sí (copia)], [no],
  [Semáforo binario], [señalizar un evento], [no], [no],
  [Semáforo contador], [contar eventos o recursos], [no], [no],
  [Mutex], [proteger un recurso compartido], [no], [sí, con herencia],
)

#posta[¿Pasar un dato? Cola. ¿Avisar que pasó algo? Semáforo. ¿Que dos no
toquen lo mismo a la vez? Mutex. Es la tabla de Leandro en una línea, y es
pregunta segura.]

== El RTOS en el Cortex-M4

- *SysTick*: timer de 24 bits del núcleo; genera el tick; en cada tick el
  kernel actualiza el tiempo, despierta tareas demoradas y decide si hay
  cambio de tarea.
- *PendSV*: excepción que se deja *pendiente* por software; ahí ocurre el
  *cambio de contexto*; tiene la *menor* prioridad, así corre cuando no
  queda ninguna ISR.
- *SVC*: la instrucción SVC; FreeRTOS la usa para lanzar la primera tarea
  en `vTaskStartScheduler()`.
- El cambio de contexto: el hardware apila xPSR, PC, LR, R12, R0-R3 al
  entrar; PendSV guarda R4-R11 en la pila de la saliente, carga la pila de
  la entrante, restaura y retorna.

#diapo("msp-psp", ancho: 80%)[MSP y PSP (diapo. 29).]

#diapo("nvic-prio", ancho: 80%)[Las dos escalas de prioridad (diapo. 30). La raya roja es `configMAX_SYSCALL_INTERRUPT_PRIORITY = 5`.]

*MSP* lo usan el kernel y las interrupciones; *PSP*, las tareas, cada una
con su pila: una ISR nunca consume pila de las tareas.

#ojo[*dos escalas al revés*: en el *NVIC*, número *menor* = más urgente; en
*FreeRTOS*, número *mayor* = tarea más importante. Con
`configMAX_SYSCALL_INTERRUPT_PRIORITY = 5`: las IRQ de 0 a 4 el kernel
nunca las bloquea y *no pueden* llamar a la API; las de 5 a 14 sí, con las
funciones `…FromISR()`; 15 es SysTick y PendSV.]

En un STM32 con FreeRTOS: la HAL también usa SysTick, así que su base de
tiempo se mueve a otro timer (TIM6); dentro de una ISR sólo las variantes
`…FromISR()` y `portYIELD_FROM_ISR()`; CubeMX genera con *CMSIS-RTOS v2*
(`osThreadNew`, `osDelay`, `osMessageQueuePut`, `osSemaphoreAcquire`,
`osMutexAcquire`, `osKernelStart`), que por debajo es FreeRTOS;
agrupamiento `NVIC_PRIORITYGROUP_4`.

#pregunta[¿Qué significa que un sistema sea de tiempo real?][Que su
corrección depende también del instante en que se obtiene el resultado: es
predecible (determinista), no necesariamente rápido.]
#pregunta[¿Cuáles son los estados de una tarea en FreeRTOS?][Running,
Ready, Blocked (espera un evento o un tiempo) y Suspended
(`vTaskSuspend`).]
#pregunta[¿Qué pasó en Mars Pathfinder y cómo se arregló?][Inversión de
prioridad: una tarea baja tenía el mutex que esperaba una alta, y una media
la desalojaba; el watchdog reseteaba. Se habilitó la herencia de prioridad
en el mutex de VxWorks, con un parche desde la Tierra.]
#pregunta[¿Por qué `vTaskDelay` y no `HAL_Delay` adentro de una
tarea?][`vTaskDelay` pasa la tarea a Blocked y libera la CPU; `HAL_Delay`
es espera activa y no deja correr a las de menor prioridad.]
#pregunta[¿Qué hacen SysTick, PendSV y SVC?][SysTick da el tick del
kernel; PendSV hace el cambio de contexto (con la menor prioridad); SVC
arranca la primera tarea.]
#pregunta[¿Qué es Rate Monotonic?][Asignar más prioridad a la tarea de
menor período.]

= TP4 — Host y payload por SPI, con interrupciones <sec-tp4>

*Qué pedía.* El primer eslabón de una OBC con su carga útil, en dos placas:
`PC --UART--> HOST --SPI--> PAYLOAD --UART--> PC`. Todo por
*interrupciones*: nada de esperas bloqueantes ni HAL en _polling_; «las ISR
sólo avisan, el programa principal trabaja». *A1* (host): consola por UART
con cola circular, comandos TEMP, PRES e ID. *A2*: maestro SPI que manda la
trama. *B1* (payload): esclavo SPI que valida e informa por UART y conmuta
LD2. *3*: integración (20 comandos seguidos, todos recibidos). *4*: tramas
corruptas (`BAD`) y contadores de válidas e inválidas.

*Qué ejercita.* El patrón de interrupciones de la HAL, el SPI maestro y
esclavo, el ICD como contrato entre equipos, la cola productor-consumidor
y la validación de entrada externa.

#tabla(
  columns: (auto, auto, 1fr),
  [*Byte*], [*Campo*], [*Contenido*],
  [0], [SOF], [`0xA5`],
  [1], [CMD], [`0x01` TEMP, `0x02` PRES, `0x03` ID],
  [2], [Reservado], [`0x00`],
  [3], [Checksum], [XOR de los bytes 0, 1 y 2],
)

#dedos[`TEMP` viaja como `A5 01 00 A4`, porque `A5 ^ 01 = A4`. Si el ruido
da vuelta *el mismo bit* en el comando y en el checksum (`01` a `03` y `A4` a `A6`) queda `A5 03 00 A6`: un `ID` perfecto que el payload acepta. Por eso
los protocolos de vuelo usan CRC.]

*El patrón de interrupciones, tres veces igual:* se *inicia* con una
función `_IT` que vuelve enseguida (`HAL_UART_Receive_IT`,
`HAL_SPI_Transmit_IT`, `HAL_SPI_Receive_IT`); cuando termina, la HAL llama
a un *callback* `__weak` que uno redefine en `USER CODE`
(`HAL_UART_RxCpltCallback`, `HAL_SPI_TxCpltCallback`,
`HAL_SPI_RxCpltCallback`); el callback *sólo deja una marca* y el `main`
trabaja.

#catedra[las cuatro reglas de oro del enunciado][
  (1) La ISR es corta: nada de `printf`, `HAL_Delay` ni nada bloqueante.
  (2) Toda variable compartida entre ISR y `main` es `volatile`. (3) La
  recepción por interrupción es *de un solo uso*: hay que volver a llamar a
  la `_IT`. (4) Cada periférico por interrupción necesita su casilla
  _Enabled_ en _NVIC Settings_ del `.ioc`; si no, el callback nunca corre
  («el error más común»).
]

```c
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	if (huart->Instance == USART2) {
		cola[escritura % TAM_COLA] = rx_byte; /* sólo la ISR toca escritura */
		escritura++;
		HAL_UART_Receive_IT(&huart2, &rx_byte, 1); /* re-armar: es de un solo uso */
	}
}
```

*Cómo lo resolvimos* (la guía del TP4 que armamos para los dos grupos, en
el Drive, tiene el código de los dos lados compilado y explicado). SPI2 en modo 0 (CPOL Low, CPHA 1 Edge), 8 bits,
MSB primero; en el host el CS es un GPIO (`PAYLOAD_CS`) que se baja antes de
transmitir y se sube en el callback; en el payload, *NSS por hardware*. La
trama vive en una variable estática (la transmisión sigue después de que la
función retorna) y un `spi_ocupado` volátil impide arrancar otra a medias.
En el payload, el pedido se *copia* antes de re-armar la recepción, porque
el siguiente se escribe en el mismo arreglo. Probamos en la PC, sin placas,
que lo que arma el host es lo que valida el payload (30 de 30) y que la
prueba ve seis roturas a propósito; lo que no se prueba en la PC (que el
NVIC esté habilitado, el CS a tiempo, los cables) lo mide el laboratorio.

#pregunta[¿Por qué el callback sólo pone una marca y no hace el
`printf`?][Porque la ISR tiene que ser corta: mientras corre, no se
atienden otras interrupciones, y un `printf` bloquea. El `main` ve la marca
y hace el trabajo.]
#pregunta[Funciona el primer comando y los siguientes no. ¿Por
qué?][Porque el payload no volvió a armar la recepción: `HAL_SPI_Receive_IT`
es de un solo uso.]
#pregunta[¿Por qué la trama de `enviar_pedido()` no puede ser un arreglo
local?][Porque la transmisión por interrupción sigue después de que la
función retorna, y el arreglo local ya no existiría.]
#pregunta[¿Cómo se entera el host de que el payload recibió bien?][Con este
protocolo, no se entera. Habría que sumar una respuesta (ACK/NACK) que el
host lea en otra transacción, porque el esclavo SPI no puede hablar primero:
es lo que agrega el TP5.]

= TP5 — OBC y dos payloads con FreeRTOS <sec-tp5>

*Qué pedía.* Tres placas: un host (OBC) que recibe comandos por consola y
consulta a *dos payloads por un único SPI*, con un CS para cada uno; cada
payload mide con un *BMP180 por I²C* y cada 10 s muestra su telemetría.
El enunciado reparte tres equipos: OBC (el host), PL1 (la placa PL-A, Fran y Horacio) y PL2 (la PL-B). La guía del TP5 que armamos sigue el payload `tp5_pl_b`.

#tabla(
  columns: (auto, 1fr, 1fr),
  [], [*Host*], [*PL-A y PL-B*],
  [Tareas], [`tarea_consola`, `tarea_a`, `tarea_b`], [`tarea_spi`, `tarea_telemetria`],
  [Colas], [`cola_a`, `cola_b`], [—],
  [Semáforos], [`sem_rx` (llegó un carácter)], [`sem_spi` (terminó un intercambio)],
  [Mutex], [`mutex_spi`, `mutex_print`], [`mutex_i2c`],
)

*Una consulta completa.* La consola recibe `TEMP A`; `tarea_consola` pone
`CMD_TEMP` en `cola_a`; `tarea_a` lo envía por SPI; en el payload la
interrupción de SPI despierta a `tarea_spi`, que decodifica y mide; deja el
dato listo; el host espera `T_ESPERA_MS`, lee el dato y lo imprime. Son
*dos intercambios* de `LEN_SPI` = 2 bytes: primero `[CMD_TEMP][0]`, después
`[dato alto][dato bajo]`, la temperatura en *décimas de °C* (215 es
21,5 °C). Sin medición o sin payload, `SIN_DATO`.

```c
void HAL_SPI_TxRxCpltCallback(SPI_HandleTypeDef *hspi)
{
	BaseType_t despertar = pdFALSE;
	if (hspi->Instance == SPI2) {
		xSemaphoreGiveFromISR(sem_spi, &despertar); /* sólo avisa */
		portYIELD_FROM_ISR(despertar); /* cambia al salir, si hace falta */
	}
}
```

*Qué ejercita.* Todo el RTOS en un sistema real: tareas con prioridades,
cola entre tareas, semáforo desde una ISR, mutex sobre dos recursos (el bus
SPI y el `printf`), la regla del 5 en el NVIC, y un bus compartido.

*Lo eléctrico que se pregunta.* Los dos payloads comparten MISO: con
salidas push-pull, uno en alto y otro en bajo serían un cortocircuito. Por
eso MISO va en *open-drain* en los payloads (sólo pueden *bajar* la línea)
con un *pull-up de 4,7 kΩ* a 3V3 que la sube. Si un payload no está, el
host lee todos unos: `0xFFFF`, que en `int16_t` es −1 = `SIN_DATO`. El
BMP180 va a PB8 (SCL) y PB9 (SDA), a 3V3.

*Cómo lo resolvimos.* Desde el proyecto `freeRTOS_example` de la cátedra,
renombrado (carpeta sin espacios, sin la carpeta `Debug`, `sed` del nombre
en `.project`, `.cproject` y `.ioc`, e importar sin copiar). Tareas con
`PILA_TAREA 512u`, verificación de lo creado con `goto EXEC_ERROR` (el
modelo de la cátedra), todo `printf` bajo `mutex_print`. `tarea_spi` con
más prioridad que `tarea_telemetria`. El 03/11 la placa midió 25,3 °C y
1007,2 hPa.

#pregunta[¿Por qué dos intercambios SPI y no uno?][Porque SPI es
full-duplex: en el mismo intercambio en que llega el comando el payload ya
está devolviendo algo, y todavía no midió. El dato viaja en el segundo.]
#pregunta[¿Por qué `tarea_spi` tiene más prioridad que la
telemetría?][Para que un pedido del host no espere a que termine el
`printf` de la telemetría.]
#pregunta[¿Por qué mutex y no semáforo binario para el sensor?][Por la
herencia de prioridad, que evita la inversión de prioridad.]
#pregunta[¿Por qué las IRQ de USART2 y SPI2 tienen prioridad numérica 5 o
más?][Porque llaman a funciones del kernel (`…FromISR`); las de 0 a 4 no
pueden, y si lo hacen salta el `configASSERT` y el sistema se traba.]
#pregunta[¿Qué lee el host si el payload no está, y por qué?][Todos unos
(`0xFFFF`) por el pull-up de MISO; como `int16_t` es −1, que es
`SIN_DATO`.]

= Cuestionario mezclado, con respuestas <sec-mezcla>

Tapá la respuesta y probá.

#pregunta[Un SEU da vuelta un bit de la variable de modo de una máquina de
estados. ¿Qué dos defensas de la materia lo atajan?][El `default` del
`switch`, que lleva a un estado de falla (MISRA 16.4), y el watchdog, si el
programa se pierde en un bucle. En memoria, EDAC lo corrige al leer.]
#pregunta[¿Qué tienen en común el lockstep, el TMR y el mutex con herencia
de prioridad?][Nada en el mecanismo, todo en la idea: son defensas
diseñadas *asumiendo* que algo va a fallar. Los dos primeros contra fallas
de hardware; el tercero contra un problema de planificación.]
#pregunta[Ordená de más a menos tolerante a la radiación: COTS,
rad-hard, rad-tolerant.][Rad-hard (100 a 1000+ krad), rad-tolerant (20 a
50), COTS (2 a 10).]
#pregunta[¿Por qué I²C no conviene para comunicar dos subsistemas a un metro
de distancia?][Es single-ended, de centímetros, sin detección de errores y
con bus lockup; para metros conviene un diferencial como RS-485 o CAN.]
#pregunta[¿Qué es el ICD y cómo apareció en los TP?][El documento de control
de interfaces: lo que dos equipos acuerdan en su frontera. En el TP4 y el
TP5 es `protocolo.h`, que no se toca sin acordarlo con el otro equipo.]
#pregunta[¿Qué es FDIR?][Detección, aislamiento y recuperación de fallas.
Los faults del Cortex son entradas al FDIR.]
#pregunta[¿Dónde vive una variable local de una función, y qué le pasa al
retornar?][En el marco de esa función, en la pila; al retornar, el marco se
destruye y la variable deja de existir.]
#pregunta[¿Qué hace `portYIELD_FROM_ISR(despertar)`?][Si la ISR despertó a
una tarea de más prioridad que la que estaba corriendo, hace el cambio de
contexto al salir de la interrupción en vez de esperar al próximo tick.]
#pregunta[¿Por qué la HAL deja de usar SysTick cuando se habilita
FreeRTOS?][Porque FreeRTOS usa SysTick como tick del kernel; la base de
tiempo de la HAL se mueve a otro timer (TIM6 en nuestro proyecto).]
#pregunta[Nombrá tres reglas de MISRA y su porqué en una línea cada
una.][16.4, `default` en todo `switch`: un valor corrupto tiene acción
definida. 17.2, sin recursión: la pila puede desbordar. Dir 4.12, sin
`malloc`: el heap no es determinista y se fragmenta.]
#pregunta[¿Cuál es la diferencia entre el procesador Cortex-M4 y el
STM32F446RE?][El Cortex-M4 es el núcleo que diseña ARM; el STM32F446RE es
el microcontrolador de ST que lo integra con flash, SRAM y periféricos.]
#pregunta[¿Por qué SpaceWire usa LVDS?][Porque LVDS es una capa física
diferencial de baja tensión: poco consumo, mucha inmunidad al ruido y alta
velocidad; SpaceWire define el protocolo por encima.]
#pregunta[¿Qué ventaja tiene CAN sobre I²C como bus de sistema, y qué
cuesta?][Detección de errores y arbitraje sin pérdida (más robusto, como
propone SpaceCAN); cuesta más consumo de potencia.]
#pregunta[Te piden la defensa en capas para un CubeSat 3U en LEO por un
año. ¿Qué ponés?][COTS con mitigación: watchdog externo, protección de
latch-up (sensor de corriente y LCL), memoria de salvaguarda FRAM, EDAC con
scrubbing, y software defensivo (MISRA, FDIR). Rad-hard y TMR completo no
se justifican para una LEO corta. (No hay una única respuesta: Leandro lo
plantea como ejercicio de justificar.)]

#include "anexos.typ"
