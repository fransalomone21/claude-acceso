# Podcast para el parcial multiple choice de Leandro (13/11/2026)

Guion de dos voces, escrito desde `guia-cuestionario/guia.typ` (las clases de las
semanas 1 a 9 y los TP 1 a 5). Formato: `CARO:` / `MARTIN:` por renglón, y
`[PAUSA n]` = n segundos de silencio para contestar. Lo sintetizan `sintetizar.py`
(edge-tts) y `sintetizar-local.py` (Chatterbox en la GPU).

v2 (13/11, noche): mismo contenido, «con más onda, bien rioplatense» (Fran).
La v1, la que se escuchó para el parcial, está en el historial de git.

## Guion

CARO: Bueno, che, arrancamos. Esto es para el parcial de Leandro, el multiple choice. Así que olvidate del documental de la tele: acá venimos a entrenar para lo que te van a tomar. Cuatro opciones, tres suenan re bien, y una sola es la posta.
MARTIN: Y las tres que suenan bien son las que te cagan. El multiple choice no te pregunta qué es un watchdog. Te pregunta si lo distinguís del lockstep cuando te los ponen uno al lado del otro y te miran con cara de nada.
CARO: Tal cual. Así que vamos tema por tema, en el orden en que lo dio Leandro. En cada uno: la idea en criollo, los pares que se confunden, y cada tanto te tiro una pregunta con opciones y te dejo unos segundos para que contestes vos. En voz alta si querés.
MARTIN: Si estás en el bondi, mejor bajito. Que la gente ya te mira raro.
CARO: Eso. Y un dato motivacional: el primer día, en la diapositiva de evaluación, Leandro prometió un departamento en Miami y una lancha como premio de los quizzes.
MARTIN: No consta que nadie los haya cobrado.
CARO: No consta. Pero tampoco consta que no. Así que por las dudas, a meterle.
MARTIN: Y si te tenés que quedar con una sola idea de toda la materia, que sea esta: en vuelo nadie te viene a resetear.
CARO: Esa frase te explica todo, eh. Por qué todo bucle tiene una cota. Por qué todo switch tiene default. Por qué se valida cada cosa que viene de afuera. Por qué la memoria es estática, por qué la interrupción sólo avisa, y por qué existe el watchdog para cuando todo lo anterior se fue al tacho.
MARTIN: Posta: si en una pregunta dudás entre dos, preguntate cuál de las dos supone que algo puede fallar. Casi siempre esa es la de Leandro. El tipo es un paranoico profesional, y lo digo con cariño.
CARO: Arrancamos por la primera clase. Confiabilidad de la aviónica espacial.

CARO: Esta clase está armada sobre un paper del que Leandro es coautor, sobre computadoras de a bordo para CubeSats. Y si el profe te da su propio paper, ya sabés qué le importa.
MARTIN: Le importa que entiendas por qué un satélite de doscientos mil dólares no puede llevar los componentes de uno de trescientos millones. Que no es tacañería: es otra liga.
CARO: Eso es Old Space contra New Space. Old Space: satélites grandotes, monolíticos, más de diez años de vida, TRL 9, componentes rad-hard, y si falla uno, se fue la misión. New Space: satélites chiquitos o constelaciones, tres o cuatro años, TRL 6, componentes COTS, y si falla uno lo reponés al toque y barato.
MARTIN: COTS es comercial, de estante. Lo que comprás en una casa de electrónica. No está hecho para el espacio y la radiación le pega mucho más. Y de ahí sale toda la clase.
CARO: Un CubeSat se mide en unidades. Una U es un cubo de diez centímetros, de hasta unos dos kilos. Se combinan: tres U, seis U, doce U. Como ladrillitos.
MARTIN: Y la OBC, la computadora de a bordo, es el cerebro. Hace el manejo de comandos y datos: la telemetría, los telecomandos, el tiempo a bordo, guardar y procesar datos, y el FDIR.
CARO: FDIR: detección, aislamiento y recuperación de fallas. Anotala en la frente, porque vuelve por todos lados.
MARTIN: Ahora, el enemigo. La radiación viene de tres lados: los cinturones de Van Allen, que son los que más pegan en órbita baja; las erupciones solares, que siguen el ciclo de once años; y los rayos cósmicos, que vienen de afuera del sistema solar y no los para ni Dios.
CARO: Y acá viene la primera tabla que es pregunta fija: los efectos. Hay dos familias. Los acumulativos y los de evento único.
MARTIN: Acumulativos: la TID, la dosis ionizante total. Se va juntando carga en el óxido de los transistores, se corren los umbrales y el componente se va degradando de a poco. Se mide en rad o en gray. Y la TID es la que define la vida útil.
CARO: El otro acumulativo es el DD, daño por desplazamiento: mueve átomos de la red del silicio, y le pega sobre todo a lo óptico: paneles y cámaras.
MARTIN: Y después los eventos únicos, que pueden pasar en cualquier momento, aunque el componente esté sanito. Un SEU es un bit dado vuelta. Blando: no rompe nada. Si se dan vuelta varias celdas juntas, es un MBU.
CARO: El SEL es el latch-up: se dispara un tiristor parásito del CMOS, circula una corriente bestial y, si no la cortás a tiempo, te quema el chip. Ese es duro.
MARTIN: Y el SET es un transitorio de tensión o corriente. Un sacudón.
CARO: Ojo con la trampa. Te pueden poner: un SEU no daña el hardware, entonces es poco grave. Ni ahí.
MARTIN: Porque te cambia qué hace el programa. Un bit en la variable de estado, en un puntero o en una instrucción, y te vas a un bucle infinito o a una rama que no diseñó nadie. El hardware está impecable y el satélite está perdido. Un garrón.
CARO: Primera pregunta. ¿Qué efecto define la vida útil de un componente en órbita? A, el SEU. B, el SEL. C, la TID. D, el SET.
[PAUSA 4]
MARTIN: La C, la TID. Es la única acumulativa de las cuatro. Las otras tres son eventos únicos: te pueden pasar el primer día o nunca.
CARO: La cuenta mental es: acumulativo, vida útil. Evento único, en cualquier momento.
MARTIN: Y una forma de ordenar toda la defensa: lo blando se combate con información de más, o sea, corregir el bit. Lo duro se combate cortando a tiempo, que el latch-up termine siendo un reinicio y no una placa frita.
CARO: Los niveles de tolerancia, por si te los piden en orden. COTS: de dos a diez kilorad. Rad-tolerant: de veinte a cincuenta. Rad-hard: de cien a mil o más.
MARTIN: Los rad-hard aguantan unas cien veces más dosis y tienen millones de veces menos errores por bit, pero son carísimos, pesados y conseguirlos es un parto. Por eso la jugada típica de un CubeSat es COTS más mitigación en capas.
CARO: Vamos a la defensa por hardware. Redundancia. Y acá está la pareja que más se confunde de todo el parcial: DMR y TMR.
MARTIN: DMR son dos módulos que hacen lo mismo y se comparan. Si dan distinto, te enterás de que hubo un error. Pero no sabés cuál de los dos la pifió. Entonces reiniciás.
CARO: TMR son tres módulos y un votador. Si uno falla, los otros dos le ganan por mayoría, y el sistema sigue como si nada. El precio: triplicás hardware y consumo.
MARTIN: Dicho corto: DMR detecta. TMR vota y sigue.
CARO: Eso es redundancia en caliente, o estática: todos andando a la vez. La redundancia en frío, o dinámica, es un respaldo apagado que se prende cuando el principal muere. Ahorra energía y reparte el desgaste.
MARTIN: Que es justo lo que te sirve contra la TID: el que está apagado casi no acumula. Está en el banco de suplentes, tomando mate.
CARO: Y el lockstep. Dos núcleos que ejecutan las mismas instrucciones en paralelo, y una lógica que compara las salidas; si difieren, excepción. ¿A qué te suena?
MARTIN: Es un DMR adentro del silicio. Por eso detecta, no corrige. Y el ejemplo de la materia es el TMS570: un Cortex-R con doble núcleo en lockstep. El del laboratorio, y el de LabOSat.
CARO: Pregunta. Un procesador con dos núcleos en lockstep, cuando las salidas no coinciden... A, vota por mayoría y sigue. B, detecta el error y dispara una excepción. C, corrige el bit con Hamming. D, apaga el núcleo que falló y sigue con el otro.
[PAUSA 4]
MARTIN: La B. Con dos no hay mayoría posible, así que la A es de TMR. La C es EDAC, otra cosa. Y la D supone que sabe cuál falló, que es justo lo que con dos no podés saber.
CARO: Memorias. La SRAM, la de laburo, es re sensible a los SEU. Flash y EEPROM no son volátiles y la celda aguanta más, pero la lógica de control no, y encima se gastan con las escrituras.
MARTIN: Y las estrellas del asunto: FRAM y MRAM. La FRAM guarda el dato en la polarización de un ferroeléctrico, la MRAM en una orientación magnética. Ninguna depende de carga eléctrica, entonces un SEU no les toca el dato. Aguantan del orden de un megarad y no son volátiles.
CARO: Por eso son la memoria de salvaguarda: ahí van los parámetros críticos y el estado, para levantarse después de una falla.
MARTIN: El watchdog. Un temporizador que el software tiene que reiniciar cada tanto; se dice patearlo. Si el software deja de patearlo, el watchdog asume que el procesador se colgó, y pum, reset.
CARO: Y la sutileza que te preguntan: interno o externo. El interno es simple, pero si el micro se cuelga entero, se puede colgar con él. El externo es otro componente, independiente, y te garantiza el reset. En vuelo se prefiere el externo, junto con checkpoints para recuperar el estado.
MARTIN: Contra el latch-up: un sensor de corriente que detecta el pico y corta la alimentación, y después se vuelve a prender. Eso es un power cycle. Y los LCL, los limitadores de corriente, que aíslan la falla de un módulo para que no te tire abajo todo el bus.
CARO: Ahora defensa por software. EDAC, o ECC: bits de control que le agregás al dato. El clásico es Hamming SECDED.
MARTIN: SECDED: corrige un bit, detecta dos. Single error correction, double error detection.
CARO: Y para varios bits, Reed-Solomon o BCH, que sirven contra los MBU.
MARTIN: Y acá viene la pregunta trampa de esta parte: si ya tengo EDAC, ¿para qué quiero scrubbing?
CARO: Porque Hamming corrige un bit por palabra. Si un dato no se lee en mucho tiempo, se le puede sumar un segundo error en la misma palabra, y ahí ya fue: no lo corrige. El scrubbing barre la memoria cada tanto, corrige los errores de un bit y los reescribe antes de que se junten dos.
MARTIN: Es como lavar los platos todos los días en vez de esperar a que se acumule la pila. EDAC más scrubbing es la combinación estándar. Y en FPGAs con SRAM, el scrubbing es crítico.
CARO: Y el firmware: varias copias, un bootloader que verifica la integridad con checksum o CRC y, si la copia está rota, carga el respaldo.
MARTIN: Con la trampa de que el bootloader es a la vez protección y punto débil. Si hay una sola copia y se corrompe, el satélite queda como un ladrillo en órbita. Por eso se replica.
CARO: La tabla para cerrar la clase. Contra TID: elegir bien los componentes, blindaje y redundancia en frío. Contra SEU: FRAM o MRAM, EDAC, scrubbing, TMR y watchdog. Contra SEL: detección de sobrecorriente y LCL. Contra fallas de software: FDIR, programación defensiva, réplicas de firmware y checkpoints.
MARTIN: Pregunta. ¿Cuál de estas defensas NO apunta al SEU? A, scrubbing. B, memoria FRAM. C, limitador de corriente LCL. D, TMR.
[PAUSA 4]
CARO: La C. El LCL es contra el latch-up, que es un quilombo de corriente. Las otras tres son contra bits dados vuelta.

MARTIN: Segunda parte de esa clase: la OBC en la práctica. Qué procesador, qué arquitectura, qué software.
CARO: Cuatro familias de procesamiento. Microcontroladores COTS, lo más común, para housekeeping, telecomandos y telemetría. Procesadores rad-hard, para irse más allá de la órbita baja, como el RAD750 o el LEON. FPGAs, para procesar en paralelo, tipo imágenes o compresión. Y los SoC híbridos con CPU y FPGA, y a veces GPU, para meterle inteligencia artificial a bordo.
MARTIN: Nombres que te pueden aparecer como opciones. MSP430 de Texas: dieciséis bits, consume nada, unos veinte kilorad, voló en LabOSat uno. El TMS570, Cortex-R con lockstep y ECC, en LabOSat dos. El RAD750, PowerPC rad-hard, unos doscientos kilorad, en el Mars Reconnaissance Orbiter y en el James Webb.
CARO: Y el ARM Cortex se come los microcontroladores de CubeSats.
MARTIN: Centralizada o distribuida. Centralizada: una OBC potente hace todo. Simple y barata, pero es un único punto de falla y escala poco.
CARO: Distribuida: cada subsistema con su procesador y la OBC coordinando por un bus. No hay único punto de falla y es modular, pero verificarla es más laburo y necesitás un bus robusto.
MARTIN: Y la palabrita que puede caer: single-string. Una sola cadena sin redundancia total: si se rompe un elemento crítico, chau misión. Es lo más común en CubeSats.
CARO: El software de vuelo se arma en capas: hardware, bibliotecas de soporte, sistema operativo, middleware, framework y aplicación.
MARTIN: Frameworks: cFS de NASA, KubOS sobre Linux, NanoSat MO Framework de la ESA. Sistemas operativos de tiempo real: FreeRTOS, el de la materia y el que manda en CubeSats; RTEMS; VxWorks, que voló en el Juno y en el James Webb; y Linux con PREEMPT RT.
CARO: Y los casos argentinos, que a Leandro le encantan. LabOSat, de la UNSAM: una placa que caracteriza electrónica en órbita baja, a unos quinientos kilómetros, volando desde 2014 en satélites de Satellogic.
MARTIN: Y ATENEA: un CubeSat doce U argentino que voló como carga secundaria de Artemis Dos, liderado por la CONAE con la UNSAM, la UNLP, la FIUBA y VENG. Midió radiación hasta el espacio cislunar. Industria nacional, papá.
CARO: Y la frase de cierre de esa clase, que si aparece como opción, la marcás de una: ensayar como se va a volar, para volar como se ensayó.

MARTIN: Arquitectura ARM. Dos clases, semanas dos y tres.
CARO: Primera cosa, y es un clásico: ARM no fabrica chips. Diseña núcleos y los licencia. El fabricante, ST o Texas, le pone memoria y periféricos, y eso es el microcontrolador.
MARTIN: O sea: el Cortex-M4 es el núcleo. El STM32F446RE de nuestra placa es el microcontrolador de ST que mete ese núcleo junto con flash, SRAM y periféricos.
CARO: Si te ponen la opción "ARM fabrica el STM32", es mentira. Lo fabrica ST.
MARTIN: Los tres perfiles. Cortex-A optimiza el rendimiento promedio y corre Linux. Cortex-R optimiza el peor caso: tiempo acotado, lockstep, ECC. Cortex-M optimiza costo, consumo y latencia de interrupción.
CARO: Para acordártelo, pensá en la pregunta que responde cada uno. El A: ¿qué tan rápido en promedio? El R: ¿qué tan lento en el peor caso? El M: ¿cuánto sale y cuánto chupa?
MARTIN: Y en un satélite pueden convivir los tres: A en la carga útil, R en la OBC, M en los subsistemas. Todos en la misma mesa.
CARO: Pregunta. Para la OBC de un satélite donde importa acotar el tiempo de respuesta en el peor caso, conviene un... A, Cortex-A, porque es el más rápido. B, Cortex-R. C, Cortex-M, porque consume menos. D, cualquiera, si total son todos ARM.
[PAUSA 4]
MARTIN: La B. El R optimiza el peor caso y trae tolerancia a fallas. La A es la cáscara: el A es más rápido en promedio, pero menos predecible.
CARO: Harvard contra Von Neumann. Von Neumann: un solo bus, que comparten instrucciones y datos, y se arma un embotellamiento. Harvard: buses separados para instrucciones y datos, así buscás la próxima instrucción mientras leés un dato.
MARTIN: Y la sutileza del Cortex: es Harvard en los buses, pero con un único mapa de memoria de cuatro gigas. Si te preguntan si el Cortex tiene dos mapas de memoria separados, no, nada que ver.
CARO: Más características. Es RISC de treinta y dos bits, load-store: la ALU opera sobre registros. El M3 y el M4 tienen pipeline de tres etapas. Thumb-2 te da densidad de código, o sea, menos flash. Y el M4 es un M3 con instrucciones DSP y FPU opcional.
MARTIN: Ahora dos siglas que se confunden siempre: MPU y MMU. La MPU, unidad de protección de memoria, define regiones con permisos y frena los accesos ilegales. Te convierte un puntero loco en una falla detectada. Pero no traduce direcciones.
CARO: La MMU sí traduce direcciones: es memoria virtual. La MPU sólo vigila, como un patovica, y por eso tiene tiempo predecible.
MARTIN: Y el NVIC. Controlador de interrupciones anidado y vectorizado. Anidado: una interrupción más urgente puede colarse adentro de otra. Vectorizado: el hardware busca solito la dirección del handler en la tabla.
CARO: Latencia de interrupción fija, doce ciclos en el M3 y el M4. Y CMSIS estandariza el acceso al núcleo entre fabricantes.
MARTIN: Modos. El Cortex-M tiene dos: Thread, para la aplicación, y Handler, para las excepciones. Y dos niveles: privilegiado y no privilegiado. El Cortex-R, en cambio, tiene los siete modos clásicos, cada uno con su propia pila.
CARO: Y dos punteros de pila en el M: MSP y PSP. Guardátelos, que vuelven en RTOS.
MARTIN: La pila crece hacia direcciones decrecientes, o sea, para abajo. Guarda variables locales, argumentos que no entran en registros y direcciones de retorno. Y al entrar a una excepción, el hardware apila parte del contexto solo.
CARO: La compilación, en orden, que te la pueden dar mezclada para que la ordenes: preprocesador, compilador, ensamblador, linker. El preprocesador resuelve los include y los define. El compilador pasa a ensamblador. El ensamblador arma el objeto punto o. Y el linker junta objetos y bibliotecas y fija las direcciones con el linker script. Sale un punto elf, y de ahí el binario a la flash.
MARTIN: El reset, que es pregunta fija. El núcleo lee la dirección cero y la carga en el MSP, como valor inicial de la pila. Lee la dirección cuatro, que es el vector de reset, y salta ahí. El código de startup inicializa la RAM, copia la sección data, configura relojes y recién ahí llama a main.
CARO: Repetilo conmigo, como un mantra: cero, la pila. Cuatro, el reset.
MARTIN: Pregunta. Al salir del reset, un Cortex-M... A, empieza a ejecutar main en la dirección cero. B, carga el MSP desde la dirección cero y salta al vector de reset en la dirección cuatro. C, carga el PSP y arranca el scheduler. D, lee el linker script.
[PAUSA 4]
CARO: La B. La A es la trampa de creer que main es lo primero; antes corre todo el startup. La C te mezcla con RTOS. Y la D es un delirio: el linker script se usa al compilar, en el chip ni existe.
MARTIN: La tabla de vectores: un arreglo con la dirección de cada handler, en la dirección cero después del reset, y se puede mover con el registro VTOR. Las primeras son excepciones del sistema: Reset, NMI, HardFault, MemManage, BusFault, UsageFault, SVC, PendSV, SysTick. Desde la dieciséis, las interrupciones de periféricos.
CARO: Y un fault entra a su handler, y el registro CFSR te dice la causa. En vuelo, los faults son entradas al FDIR.
MARTIN: Y la parte más preguntable de la clase tres: dónde vive cada cosa de un programa en C.
CARO: Punto text: el código. Punto data: las globales y estáticas inicializadas. Punto bss: las globales y estáticas sin inicializar. El heap, que crece para arriba, es lo que pide malloc. Y el stack, que crece para abajo, con las locales y los marcos de cada función.
MARTIN: El ejemplo de la clase. Una global inicializada, total global igual a cien: va a data. Un static int counter sin inicializar: va a bss. Las dos existen antes de que arranque main.
CARO: Y cuando llamás a una función, se apila su marco con sus variables y con los argumentos copiados. Al retornar, el marco se destruye. Y si hiciste malloc y te olvidaste el free, ese bloque queda reservado para siempre: memory leak. Como el táper que le prestaste a tu tía.
MARTIN: Pregunta. La declaración static int counter, sin valor inicial, afuera de toda función, ¿dónde queda? A, en el stack. B, en el heap. C, en punto data. D, en punto bss.
[PAUSA 4]
CARO: La D, punto bss, porque no está inicializada. Si tuviera igual a cien, sería punto data. Stack y heap no: el stack es para locales, y el heap es sólo lo que pedís con malloc.

MARTIN: C embebido y MISRA. Acá Leandro tiene reglas que dijo textual, así que van derechito.
CARO: Se compila siempre con gcc, guión Wall, guión Wextra, guión std igual a c11. Y un ejercicio no está terminado hasta que da cero warnings. Cero. Ni uno chiquito. Un archivo punto c por ejercicio, en la terminal de Ubuntu.
MARTIN: Y la estructura es la de template punto c: primero las bibliotecas de C, después macros, bibliotecas propias, variables globales, la declaración de funciones arriba de main, y la definición abajo.
CARO: Tipos de ancho fijo siempre: uint8 t, int16 t, uint32 t. ¿Por qué no int, che?
MARTIN: Porque el tamaño de int depende del compilador y de la plataforma. Un uint16 t mide dieciséis bits en la PC y en el micro. Es la directiva cuatro punto seis de MISRA.
CARO: Los tres calificadores, que en el multiple choice te los mezclan a propósito. Const: no se toca. Volatile: lo puede cambiar algo de afuera, así que el compilador no tiene que hacerse el vivo optimizando la lectura. Static: en una local, conserva el valor entre llamadas; en una global, la deja visible sólo en ese archivo.
MARTIN: Volatile con los dedos: es avisarle al compilador que esa variable la puede cambiar alguien que él no ve. Sin eso, ve un while bandera igual a cero donde nadie escribe bandera adentro, la lee una sola vez y se queda girando para siempre, aunque la interrupción ya la haya puesto en uno.
CARO: Y lo peor: con la optimización apagada suele andar igual. El bug te salta el día que alguien compila en Release. O sea, el peor día posible.
MARTIN: Pregunta. Una variable que modifica una rutina de interrupción y lee el main se tiene que declarar... A, const. B, static. C, volatile. D, register.
[PAUSA 4]
CARO: La C, volatile. Static puede ir también, pero no es lo que resuelve el problema: lo que hace falta es que el compilador la relea de memoria cada vez.
MARTIN: Bits. Poner el bit n: equis or igual uno u corrido n. Borrar el bit n: equis and igual negado de uno u corrido n. Leer: equis and uno u corrido n. Invertir: con el or exclusivo.
CARO: Y nunca con if sueltos: Leandro quiere operadores de bit. El error típico es borrar con and igual sin el negado, que te deja sólo ese bit y te borra todos los demás. Un desastre.
MARTIN: Control: todo while con cota, porque un OBC no se puede quedar colgado esperando algo que no llega. Como esperar el bondi a las tres de la mañana. Y todo switch con default.
CARO: La máquina de estados como la quiere Leandro: un enum con los modos, un switch, y un default que lleva a falla. ¿Por qué el default si en teoría nunca entra?
MARTIN: Porque un SEU puede dejar la variable de modo en un valor que no es ninguno de los casos. Sin default, pasa de largo y nadie se entera. Con default, ese valor trucho tiene una acción definida.
CARO: Sin malloc en vuelo, asignación estática. Y en el TP1, los nueve ejercicios eran todos de OBC: telemetría con el porcentaje de batería entre tres y cuatro coma dos volts, límites con define y const, un registro de hardware con volatile y un contador de arranque con static, el panel de banderas con operadores de bit, validar un telecomando, esperar un sensor con un máximo de intentos, y la secuencia de arranque.
MARTIN: Y dos preguntas del TP1 que pueden caer. Si al contador de arranque le sacás el static, ¿qué pasa? Se vuelve a crear en la pila en cada pasada y arranca en cero cada vez. Y el while del sensor lleva cota porque si el sensor nunca contesta, sin cota se cuelga la OBC para siempre.
CARO: MISRA. Motor Industry Software Reliability Association. Nació en el mundo de los autos en 1998, y hoy se usa en equipos médicos, automotriz y aviónica. MISRA C dos mil doce tiene ciento setenta y cinco guías: dieciséis directivas y ciento cincuenta y nueve reglas.
MARTIN: La diferencia: las directivas son generales y no siempre las puede chequear una herramienta. Las reglas sí, por análisis estático.
CARO: Y las tres categorías, que son pregunta segurísima. Mandatory: nunca se rompe, no admite desvío. Required: se cumple salvo que haya un desvío documentado y justificado. Advisory: buena práctica, el equipo puede no seguirla con menos trámite.
MARTIN: Pregunta. Una regla Required de MISRA... A, no se puede romper nunca. B, se puede no cumplir con un desvío formal, documentado y justificado. C, es una sugerencia sin trámite. D, sólo aplica en autos.
[PAUSA 4]
CARO: La B. La A es Mandatory, y la C es Advisory. Ese es el triángulo que te van a revolver.
MARTIN: Las reglas con número que más aparecen. La uno punto tres, mandatory: nada de comportamiento indefinido. Es la regla paraguas.
CARO: Nueve punto uno: no leer una variable local sin inicializar, porque tiene basura.
MARTIN: Dieciséis punto cuatro: todo switch con default.
CARO: Diecisiete punto dos: sin recursión, porque la profundidad puede crecer y reventar la pila.
MARTIN: Directiva cuatro punto doce: sin malloc ni free, porque el heap no es determinista y se fragmenta.
CARO: Directiva cuatro punto catorce: validar toda entrada de afuera, sea un telecomando, un sensor o un byte de la UART. No le creas a nadie.
MARTIN: Catorce punto cuatro: la condición de un if es booleana. If p distinto de NULL, no if p solo.
CARO: Trece punto cuatro: no usar el resultado de una asignación. El clásico if equis igual cinco con un solo igual, que todos metimos alguna vez.
MARTIN: Y veintiuno punto seis: nada de stdio en vuelo, porque allá arriba no hay consola ni archivos.
CARO: Y el ejercicio de satelite punto c, que puede volver disfrazado: tres violaciones. Una medición del sensor que se lee sin inicializar si el modo no es normal: nueve punto uno. Un switch del modo de operación sin default: dieciséis punto cuatro. Y un malloc de diez enteros con tamaño conocido: directiva cuatro punto doce, se cambia por un arreglo estático de diez.
MARTIN: Y la primera te la canta el propio gcc con Wall y Wextra: el aviso de que puede usarse sin inicializar.

CARO: STM32CubeIDE y Wokwi, rapidito, que es más práctico que teórico. La versión fija para todos es la uno punto dieciocho punto uno. El workspace es la carpeta con todos los proyectos, y la ruta sin espacios, sin acentos y sin eñes.
MARTIN: El archivo punto ioc es la representación gráfica del micro. Con él se genera el código C de inicialización: relojes, pines, periféricos. La lógica la escribís vos.
CARO: Y la pregunta que puede caer: ¿por qué tu código va entre USER CODE BEGIN y USER CODE END? Porque cuando regenerás desde el ioc, el IDE pisa el archivo y sólo respeta lo que está adentro de esos bloques. Lo de afuera, a la basura.
MARTIN: Wokwi no simula la F446RE, pero sí la NUCLEO C031C6 con el mismo patrón de la HAL. El wokwi punto toml le dice qué firmware cargar, la ruta al elf. Y el diagram punto json, qué placa y qué componentes van conectados a qué pines.
CARO: En el TP2, cuatro LEDs contando en binario de cero a quince, y un potenciómetro leído con el ADC que prende un LED de alarma arriba de un umbral, imprimiendo el valor por UART.
MARTIN: Y un ADC no es una interfaz de comunicación: convierte una tensión en un número. Es la puerta de entrada de los sensores analógicos.

CARO: Periféricos e interfaces. Esta clase es tablita pura, ideal para multiple choice.
MARTIN: El criterio de Leandro para elegir un bus: qué tan lejos tienen que viajar los datos, y cuántos dispositivos comparten el cable.
CARO: Conceptos base. Serie, un bit atrás del otro, o paralelo, varios a la vez. Simplex, un solo sentido. Half-duplex, los dos sentidos pero por turnos, como un walkie-talkie. Full-duplex, los dos a la vez, como un teléfono.
MARTIN: Y single-ended contra diferencial. Single-ended: la señal medida contra masa. Diferencial: un par de cables con la señal y su inversa; el receptor resta, y el ruido que entró igual en los dos se cancela.
CARO: Por eso los diferenciales llegan más lejos. Si te preguntan por qué RS-485 aguanta más distancia que I2C: diferencial, el ruido común se va al restar.
MARTIN: UART: asíncrona, sin reloj compartido. Dos hilos, TX y RX. Los dos extremos se ponen de acuerdo de antemano en el baudrate y el formato, por ejemplo ciento quince mil doscientos, ocho N uno. Sin direcciones, punto a punto.
CARO: I2C: dos hilos compartidos, SDA para datos y SCL para el reloj. Cada esclavo tiene una dirección de siete bits y el maestro llama al que quiere. Cien kilobits estándar, cuatrocientos el rápido. Nació para chips de la misma placa: centímetros.
MARTIN: Los dispositivos sólo bajan la línea: son open-drain, y hay resistencias de pull-up que la suben. Y su talón de Aquiles es el bus lockup.
CARO: Un esclavo se queda a mitad de trama agarrando SDA, y como el protocolo no define timeout ni reset, el bus entero queda inutilizable por un solo dispositivo. Uno solo, y se pudre todo. El caso real de la clase: la misión de NASA V-R3x le puso un circuito de aislación a cada dispositivo, que se auto-aísla si falla.
MARTIN: SPI: cuatro señales. SCLK, el reloj. MOSI, del maestro al esclavo. MISO, del esclavo al maestro. Y un chip select por cada esclavo.
CARO: Full-duplex, rápido, de varios a decenas de megabits. Sin direcciones por software: el maestro elige con quién habla bajando su CS. Cada esclavo nuevo te cuesta un pin.
MARTIN: El maestro genera el reloj, y el esclavo nunca arranca la charla. Eso es clave para entender el TP4 y el TP5. El esclavo SPI es tímido: habla sólo si le hablan.
CARO: Y CPOL y CPHA: la polaridad y la fase del reloj. CPOL elige el nivel de reposo del reloj; CPHA, en qué flanco se toma el dato. Tienen que coincidir en los dos extremos; si no, los datos llegan corridos o hechos pelota, aunque veas actividad en las líneas.
MARTIN: Y el caso que contó Leandro, que es buenísimo: entre dos placas, un reloj SPI en reposo alto, o sea CPOL uno, dejaba tres coma tres volts fijos en el cable, y eso alimentaba de forma parásita a la otra placa, que se prendía sola. Se arregló poniendo el reposo en bajo, CPOL cero.
CARO: La placa que se prende sola. Fantasmas no hay, hay CPOL.
MARTIN: Pregunta. Comparado con I2C, el SPI... A, usa dos hilos y direcciones de siete bits. B, permite que el esclavo arranque la comunicación. C, es full-duplex y elige al esclavo con un chip select por dispositivo. D, es diferencial y llega a cientos de metros.
[PAUSA 4]
CARO: La C. La A es I2C. La B es falsa: el esclavo SPI nunca arranca. Y la D no es ninguno de los dos: diferencial y lejos es RS-485 o CAN.
MARTIN: Inter-sistema. RS-232: single-ended, hasta quince metros, el uno es una tensión negativa. Bancos de prueba y tierra, casi nunca a bordo.
CARO: RS-422 y 485: diferenciales, hasta mil doscientos metros a baja velocidad. El 422 es un transmisor y hasta diez receptores. El 485 es multipunto. Pero ojo al piojo: no tienen detección de errores ni arbitraje propio. Hace falta un protocolo arriba.
MARTIN: CAN, de Bosch, del mundo de los autos: diferencial, multi-master con arbitraje no destructivo por la prioridad del identificador, o sea que el mensaje que gana no se pierde, y CRC en cada trama, con señalización de error y retransmisión. Hasta un megabit, cinco en CAN FD.
CARO: Y SpaceCAN propone cambiar el I2C por CAN en satélites chicos: más robusto, a costa de consumir más.
MARTIN: MIL-STD 1553: militar, diferencial, determinista, con un único controlador de bus y dos buses redundantes, A y B. BepiColombo lo usa.
CARO: Y SpaceWire, de la ESA: enlaces punto a punto, full-duplex, sobre LVDS, con routers que arman una red. De dos a doscientos megabits. Lo usan el James Webb, Gaia y ExoMars.
MARTIN: Y la trampa: LVDS es una capa física, no un protocolo. SpaceWire es el protocolo que va arriba.
CARO: Pregunta. ¿Qué tiene CAN que no tiene RS-485? A, es diferencial. B, es multipunto. C, arbitraje no destructivo y detección de errores con CRC. D, llega más lejos.
[PAUSA 4]
MARTIN: La C. La A y la B las tienen los dos: los dos son diferenciales y multipunto. Esa es la jugada sucia: ponerte cosas que comparten como si fueran la diferencia.

CARO: Funciones y punteros. Semana siete.
MARTIN: Por valor, la función recibe una copia: la toqueteás todo lo que quieras y el original ni se entera. Por referencia, con un puntero, recibe la dirección y puede modificar el original.
CARO: El ejemplo de la clase: contador vale diez. Si llamás a incrementar por valor, en main sigue valiendo diez. Si llamás a incrementar por referencia, vale once.
MARTIN: Y en embebido importa lo que cuesta: un struct grande por valor se copia entero a la pila; un puntero son cuatro bytes. Tipos chicos por valor, estructuras y buffers por puntero.
CARO: Y para devolver varios valores, punteros a donde guardarlos, y el retorno como código de estado: cero si salió bien, menos uno si no.
MARTIN: Recursión: necesita caso base y acercarse a él, y cada llamada apila un marco. En vuelo se evita, porque la profundidad puede depender de los datos y reventarte la pila. El factorial iterativo usa un solo marco.
CARO: Punteros a función. El código de una función tiene dirección, y un puntero la puede guardar para llamarla de manera indirecta. La sintaxis: tipo, abre paréntesis, asterisco nombre, cierra paréntesis, y los argumentos.
MARTIN: Y la trampa de sintaxis: sin esos paréntesis, void asterisco p, abre paréntesis uint32 t, no es un puntero a función. Es el prototipo de una función que devuelve un puntero a void. Dos paréntesis te cambian todo.
CARO: La dispatch table: en vez de un switch kilométrico, una tabla de punteros a función indexada por el código de telecomando. Agregar un comando es agregar una entrada.
MARTIN: Y validar el índice es obligatorio en vuelo. ¿Por qué?
CARO: Porque un código fuera de rango indexaría afuera de la tabla, y el programa saltaría a cualquier lado. Que es la pesadilla de Leandro.
MARTIN: Callback: un puntero a función que le pasás a otro módulo para que te devuelva la llamada cuando pase algo. Como dejar tu número en la verdulería para que te avisen cuando llegan las paltas. El driver de la UART llama al callback cuando llega un dato, sin conocer la aplicación. Eso desacopla capas.
CARO: Y como suele correr en contexto de interrupción, tiene que ser cortito, no bloquear, y cuidar los datos compartidos.
MARTIN: Structs: punto con una variable de tipo struct, flecha con un puntero a struct. Pe flecha campo es lo mismo que asterisco pe, entre paréntesis, punto campo.
CARO: Pregunta. Tenés un puntero p a una estructura de telemetría. Para leer el campo estado escribís... A, p punto estado. B, p flecha estado. C, asterisco p flecha estado. D, ampersand p punto estado.
[PAUSA 4]
MARTIN: La B. El punto es para la variable, no para el puntero. Y la C desreferencia dos veces. Mucho asterisco junto, nunca es buena señal.

CARO: Llegamos a la clase más preguntable de todas: sistemas operativos de tiempo real.
MARTIN: Arranquemos por el porqué. Con el super-loop, una tarea lenta frena a todas. El RTOS es lo que te garantiza que el control de actitud corra cada cien milisegundos, pase lo que pase con la telemetría.
CARO: Y la definición que más gente pifia: tiempo real no es rápido. Es predecible. La corrección depende del resultado y también del momento en que lo obtenés.
MARTIN: Pregunta express. Un sistema de tiempo real es aquel que... A, ejecuta todo lo más rápido posible. B, garantiza que sus resultados son correctos y llegan dentro de un plazo predecible. C, usa un procesador de alta frecuencia. D, no usa interrupciones.
[PAUSA 3]
CARO: La B. La A es la trampa número uno de toda la clase. Que no te la vendan.
MARTIN: Hard, firm y soft. Hard: perder un plazo es una falla, como el control de actitud o prender un propulsor. Firm: un resultado tarde no sirve, pero el sistema sigue, como un cuadro de imagen que se tira. Soft: tarde degrada la calidad, como el housekeeping.
CARO: Cada tarea tiene un período T, un tiempo de ejecución C y un deadline D, con la condición C menor que D, menor o igual que T.
MARTIN: Una tarea es una función con un lazo infinito, que nunca retorna. Tiene pila propia, una prioridad y un TCB, el bloque de control de la tarea, que guarda la prioridad, el estado y el puntero de pila.
CARO: Los estados en FreeRTOS: Running, Ready, Blocked y Suspended. A Blocked se llega con un vTaskDelay, esperando una cola vacía o un semáforo.
MARTIN: El scheduler de FreeRTOS corre siempre la tarea lista de mayor prioridad. Número más alto, más prioridad. Si hay varias con la misma, se turnan en cada tick: round-robin. Y cuando no hay nada, corre la tarea Idle, de prioridad cero, que es la que está tirada en el sillón.
CARO: Cómo asignar prioridades: Rate Monotonic. A menor período, mayor prioridad. El control de actitud cada cien milisegundos va por encima de la telemetría cada un segundo.
MARTIN: Las políticas. Cooperativa: simple, pero una tarea que no suelta frena a todas. Preemptiva por prioridades: responde al toque a lo urgente, con el riesgo de que las de baja prioridad se mueran de hambre. Round-robin: reparto parejo, con más cambios de contexto.
CARO: El tick, típicamente un kilohertz, o sea un milisegundo. Y la pareja clásica: vTaskDelay contra HAL Delay.
MARTIN: vTaskDelay pasa la tarea a Blocked durante n ticks y libera la CPU. HAL Delay es espera activa: la CPU gira en el aire como un perro persiguiéndose la cola, y las tareas de menor prioridad no corren.
CARO: Y vTaskDelayUntil mantiene un período fijo, ideal para control.
MARTIN: Ahora el problema: dos tareas leen un contador que vale cinco, las dos escriben seis, y vos esperabas siete. El error depende del instante del cambio de tarea. Para eso están los tres mecanismos.
CARO: Y esta es la tabla de Leandro en una línea, pregunta segura: ¿pasar un dato? Cola. ¿Avisar que pasó algo? Semáforo. ¿Que dos no toquen lo mismo a la vez? Mutex.
MARTIN: La cola es un buffer FIFO de tamaño fijo, y los datos se copian. Si está vacía, el que recibe espera bloqueado sin gastar CPU. Desacopla al que produce del que consume.
CARO: El semáforo binario vale cero o uno y señaliza un evento: llegó el dato. El contador va de cero a N. Y el patrón típico: la interrupción hace lo mínimo, da el semáforo, y despierta a una tarea que hace el laburo pesado con su prioridad.
MARTIN: El mutex es un candado con dueño: sólo el que lo agarró lo puede soltar. Protege un recurso, como el bus I2C. Y tiene herencia de prioridad.
CARO: Pregunta. Una interrupción le tiene que avisar a una tarea que llegó un byte, sin pasarle datos. Lo más adecuado es... A, un mutex. B, un semáforo binario. C, una cola de cien elementos. D, una variable global sin volatile.
[PAUSA 4]
MARTIN: La B, semáforo binario: señalizar un evento. El mutex no, porque tiene dueño: lo agarra y lo suelta la misma tarea, y una interrupción no puede ser dueña. Y la D tiene dos errores en uno, es un combo.
CARO: Inversión de prioridades. L, la tarea baja, agarra el mutex. H, la alta, lo pide y se bloquea. M, la del medio, que ni necesita el mutex, desaloja a L y corre. Y H, la más importante, termina esperando a M. Un papelón.
MARTIN: La solución es la herencia de prioridad: mientras L tiene el mutex que H necesita, L hereda la prioridad de H, y M ya no la puede correr.
CARO: Y el caso famoso: Mars Pathfinder, mil novecientos noventa y siete. Días después de aterrizar en Marte, la computadora se reiniciaba sola, una y otra vez.
MARTIN: Una tarea de meteorología, de baja prioridad, tenía el mutex del bus de información. La tarea de alta prioridad del bus lo esperaba. Una de comunicaciones, de prioridad media, seguía corriendo como si nada. El watchdog veía que la tarea del bus no completaba su ciclo, y reseteaba.
CARO: ¿Y cómo lo arreglaron?
MARTIN: Habilitando la herencia de prioridad en ese mutex de VxWorks. Un parámetro. Mandado desde la Tierra. A Marte. Imaginate el mensajito.
CARO: La moraleja para el parcial: si te preguntan por qué mutex y no semáforo binario para proteger un recurso, la respuesta es la herencia de prioridad.
MARTIN: Pregunta. En Mars Pathfinder, el problema fue... A, un SEU en la memoria. B, un desborde de pila por recursión. C, una inversión de prioridad sobre un mutex, que hacía saltar el watchdog. D, un bus lockup de I2C.
[PAUSA 4]
CARO: La C. Y fijate que el watchdog aparece en la historia, pero no es el culpable: es el que reseteaba. Si te ponen "el watchdog estaba mal configurado", no.
MARTIN: El RTOS en el Cortex-M4, la parte más técnica. SysTick: un timer de veinticuatro bits del núcleo que genera el tick. En cada tick el kernel actualiza el tiempo, despierta tareas dormidas y decide si hay cambio de tarea.
CARO: PendSV: una excepción que se deja pendiente por software, y ahí pasa el cambio de contexto. Tiene la menor prioridad, así corre cuando no queda ninguna interrupción esperando.
MARTIN: Y SVC: FreeRTOS la usa para lanzar la primera tarea cuando arrancás el scheduler.
CARO: Tres siglas, tres funciones. SysTick, el tick. PendSV, el cambio de contexto. SVC, el arranque. Te las van a cruzar, fijo.
MARTIN: Y MSP y PSP: el MSP lo usan el kernel y las interrupciones; el PSP, las tareas, cada una con su pila. Así una interrupción nunca le come pila a una tarea.
CARO: Y la trampa más fina de la materia: las dos escalas de prioridad van al revés. En el NVIC, número menor es más urgente. En FreeRTOS, número mayor es tarea más importante. Sí, ya sé, quien lo diseñó así no nos quería.
MARTIN: Y la raya: configMAX SYSCALL INTERRUPT PRIORITY igual a cinco. Las interrupciones de prioridad cero a cuatro, el kernel nunca las bloquea, pero no pueden llamar a la API de FreeRTOS. Las de cinco a catorce sí pueden, con las funciones FromISR. Y la quince es la del SysTick y el PendSV.
CARO: Pregunta. Una interrupción que llama a xSemaphoreGiveFromISR tiene que tener en el NVIC una prioridad numérica... A, cero, la más urgente posible. B, mayor o igual a cinco. C, menor que cinco. D, da lo mismo.
[PAUSA 4]
MARTIN: La B, cinco o más. La A es la trampa del sentido común: querés que sea la más urgente, pero con cero no puede llamar al kernel, salta el assert y se cuelga todo.
CARO: Y adentro de una interrupción, sólo funciones FromISR, y al final portYIELD FROM ISR, que si despertaste a una tarea de más prioridad, hace el cambio de contexto al salir en vez de esperar al próximo tick.
MARTIN: Y con FreeRTOS en un STM32, la HAL deja de usar el SysTick, porque lo usa el kernel. Su base de tiempo se muda a otro timer, en nuestro proyecto el TIM6.

CARO: Los dos últimos prácticos, que son los que juntan todo. El TP4: PC, por UART, al host; host, por SPI, al payload; payload, por UART, a la PC. Todo por interrupciones.
MARTIN: La trama del ICD: cuatro bytes. El primero, A5, el inicio de trama. El segundo, el comando: uno temperatura, dos presión, tres identificación. El tercero, reservado en cero. Y el cuarto, el checksum: el or exclusivo de los tres primeros.
CARO: Y la debilidad de ese checksum, que es una pregunta muy de Leandro: si el ruido te da vuelta el mismo bit en el comando y en el checksum, la trama sigue siendo válida. Un pedido de temperatura se te puede transformar en un pedido de identificación impecable. Por eso los protocolos de vuelo usan CRC.
MARTIN: Las cuatro reglas de oro del enunciado. Uno, la ISR es cortita: nada de printf, nada de HAL Delay, nada que bloquee. Dos, toda variable compartida entre ISR y main es volatile. Tres, la recepción por interrupción es de un solo uso: hay que volver a armarla. Cuatro, cada periférico por interrupción necesita su casilla habilitada en el NVIC del ioc, o el callback nunca corre.
CARO: Pregunta. El payload recibe bien el primer comando por SPI y los siguientes no. Lo más probable es... A, el baudrate de la UART. B, que no se volvió a llamar a HAL SPI Receive IT después del callback. C, que falta el pull-up de I2C. D, que el checksum está mal calculado.
[PAUSA 4]
MARTIN: La B. Si anda una vez y después no, es la regla tres: la recepción por interrupción es de un solo uso. Como un forro. La A es otro periférico, y la C es otro bus.
CARO: Y una más del TP4: la trama que manda el host no puede ser un arreglo local de la función, porque la transmisión por interrupción sigue después de que la función retorna, y el arreglo local ya no existiría.
MARTIN: Y el host, con ese protocolo, no se entera si el payload recibió bien. Porque el esclavo SPI no puede hablar primero. Eso lo agrega el TP5.
CARO: El TP5, el que hiciste con Horacio, la placa PL-A. Un host que consulta a dos payloads por un único SPI, con un chip select para cada uno. Cada payload mide con un BMP180 por I2C.
MARTIN: Y que midió veinticinco coma tres grados y mil siete coma dos hectopascales el tres de noviembre. Laboratorio templado y sin tormenta. Un lujo.
CARO: En el host: tarea de consola y una tarea por payload, una cola para cada uno, un semáforo cuando llega un carácter, y dos mutex, uno para el SPI y otro para el printf. En cada payload: tarea SPI y tarea de telemetría, un semáforo para el SPI y un mutex para el I2C.
MARTIN: Y una consulta son dos intercambios SPI de dos bytes. ¿Por qué dos y no uno?
CARO: Porque SPI es full-duplex: en el mismo intercambio en que llega el comando, el payload ya está devolviendo algo, y todavía no midió nada. El dato viaja en el segundo. La temperatura en décimas de grado: doscientos quince son veintiuno coma cinco.
MARTIN: Y lo eléctrico. Los dos payloads comparten el MISO. Si fueran push-pull, uno en alto y otro en bajo sería un cortocircuito. Por eso MISO va en open-drain, que sólo puede bajar la línea, con un pull-up de cuatro coma siete kiloohms a tres coma tres volts.
CARO: Y si un payload no está, el host lee todos unos, efe efe efe efe, que en un entero de dieciséis bits con signo es menos uno, que es justo el valor de sin dato. Redondito.
MARTIN: Pregunta del bloque. En el TP5, ¿por qué se usa mutex y no semáforo binario para proteger el sensor? A, porque el mutex es más rápido. B, por la herencia de prioridad, que evita la inversión de prioridad. C, porque el semáforo no existe en FreeRTOS. D, porque el mutex copia los datos.
[PAUSA 4]
CARO: La B. La D es la cola.

MARTIN: Ronda rápida, che. Te tiro preguntas cortas, cuatro opciones, y menos tiempo. Como en el parcial cuando te quedan cinco minutos y te empieza a transpirar la nuca.
CARO: Uno. Hamming SECDED: A, corrige dos bits y detecta tres. B, corrige un bit y detecta dos. C, sólo detecta. D, corrige cualquier cantidad.
[PAUSA 3]
MARTIN: B. Corrige uno, detecta dos.
CARO: Dos. La memoria donde un SEU no te cambia el dato: A, SRAM. B, FRAM. C, la caché. D, los registros del núcleo.
[PAUSA 3]
MARTIN: B. FRAM, y también la MRAM.
CARO: Tres. En el NVIC, la prioridad más urgente es: A, el número más alto. B, el número más bajo. C, la quince. D, la cinco.
[PAUSA 3]
MARTIN: B. En el NVIC, número chico es más urgente. Al revés que las tareas de FreeRTOS.
CARO: Cuatro. ¿Cuál de estos buses tiene un único controlador y dos buses redundantes A y B? A, CAN. B, SpaceWire. C, MIL-STD 1553. D, I2C.
[PAUSA 3]
MARTIN: C. El 1553.
CARO: Cinco. MISRA prohíbe malloc en vuelo porque: A, gasta mucha memoria. B, el heap no es determinista y se fragmenta. C, no existe en C once. D, lo prohíbe gcc.
[PAUSA 3]
MARTIN: B. Directiva cuatro punto doce.
CARO: Seis. La excepción donde FreeRTOS hace el cambio de contexto: A, SysTick. B, SVC. C, PendSV. D, HardFault.
[PAUSA 3]
MARTIN: C. PendSV. SysTick da el tick, SVC arranca la primera tarea.
CARO: Siete. Una variable local de una función, al retornar: A, queda en punto data. B, deja de existir porque su marco de pila se destruye. C, queda en el heap hasta el free. D, se copia a la FRAM.
[PAUSA 3]
MARTIN: B.
CARO: Ocho. El watchdog externo se prefiere al interno porque: A, es más rápido. B, si el micro se cuelga entero, el interno se puede colgar con él. C, consume menos. D, lo exige MISRA.
[PAUSA 3]
MARTIN: B.
CARO: Nueve. CPOL y CPHA distintos entre maestro y esclavo SPI: A, no pasa nada. B, datos corridos o corruptos aunque haya actividad en las líneas. C, se quema el esclavo. D, el bus se traba como en I2C.
[PAUSA 3]
MARTIN: B. Error clásico de integración.
CARO: Diez. Rate Monotonic le da más prioridad a la tarea de: A, mayor período. B, menor período. C, mayor tiempo de ejecución. D, la que llegó primero.
[PAUSA 3]
MARTIN: B. Menor período, más prioridad.
CARO: Once. Una arquitectura distribuida, comparada con una centralizada: A, es más simple de verificar. B, elimina el único punto de falla pero necesita un bus robusto y cuesta más verificarla. C, es siempre más barata. D, no necesita bus.
[PAUSA 3]
MARTIN: B.
CARO: Doce. El TMS570 es: A, un Cortex-A con Linux. B, un Cortex-R con doble núcleo en lockstep. C, un MSP430 de dieciséis bits. D, un FPGA.
[PAUSA 3]
MARTIN: B. El del laboratorio y el de LabOSat dos.
CARO: Trece. Un if con un solo igual, if equis igual cinco, viola: A, la dieciséis punto cuatro. B, la trece punto cuatro, no usar el resultado de una asignación. C, la directiva cuatro punto doce. D, ninguna.
[PAUSA 3]
MARTIN: B.
CARO: Y catorce, la última. Si un SEU te da vuelta un bit de la variable de modo de una máquina de estados, ¿qué defensas de la materia lo atajan? A, sólo el blindaje. B, el default del switch que lleva a falla, y el watchdog si el programa se pierde en un bucle. C, el linker script. D, el round-robin.
[PAUSA 3]
MARTIN: B. Y si la variable está en una memoria con EDAC, se corrige al leerla.

CARO: Bueno. Antes de que te bajes del bondi, los pares que te van a cruzar, de un tirón.
MARTIN: TID vida útil, SEU en cualquier momento. SEU blando, SEL duro.
CARO: DMR detecta, TMR vota y sigue. Lockstep es DMR en el silicio.
MARTIN: EDAC corrige, scrubbing evita que se junten dos.
CARO: MPU vigila, MMU traduce.
MARTIN: Punto data inicializada, punto bss sin inicializar.
CARO: Cero la pila, cuatro el reset.
MARTIN: Mandatory nunca, Required con desvío, Advisory recomendación.
CARO: I2C dos hilos y direcciones, SPI cuatro hilos y un CS por esclavo.
MARTIN: RS-485 diferencial y multipunto, CAN además arbitra y tiene CRC.
CARO: Cola datos, semáforo eventos, mutex recursos.
MARTIN: NVIC número chico urgente, FreeRTOS número grande importante, y la raya en cinco.
CARO: Y tiempo real no es rápido: es predecible.
MARTIN: Y en vuelo nadie te viene a resetear.
CARO: Dale que sale, Fran. Y si te dan el departamento en Miami, la lancha es nuestra.
MARTIN: Mínimo invitanos a pasear. Suerte, maestro.
