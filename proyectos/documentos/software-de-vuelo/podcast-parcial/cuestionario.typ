#set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm), numbering: "1")
#set text(font: "Libertinus Serif", size: 10.5pt, lang: "es")
#set par(justify: true)
#let azul = rgb("#1f4e79")
#align(center)[#text(17pt, weight: "bold", fill: azul)[Cuestionario multiple choice — Software de Vuelo (Leandro)] \
  #text(10pt)[31 preguntas por tema, con respuesta y porqué · 13/11/2026 · las mismas del podcast]]
#v(4pt)
Tapá la caja gris y contestá. La justificación dice por qué las otras opciones son trampa.


#v(6pt)
#text(13pt, weight: "bold", fill: azul)[Confiabilidad y radiación]

#block(breakable: false, below: 8pt)[*1.* ¿Qué efecto define la vida útil de un componente en órbita? \
*A)* el SEU \
*B)* el SEL \
*C)* la TID \
*D)* el SET
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* La C, la TID. Es la única acumulativa de las cuatro. Las otras tres son eventos únicos: te pueden pasar el primer día o nunca.]]
#block(breakable: false, below: 8pt)[*2.* Un procesador con dos núcleos en lockstep, cuando las salidas no coinciden... \
*A)* vota por mayoría y sigue \
*B)* detecta el error y dispara una excepción \
*C)* corrige el bit con Hamming \
*D)* apaga el núcleo que falló y sigue con el otro
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. Con dos no hay mayoría posible, así que la A es de TMR. La C es EDAC, otra cosa. Y la D supone que sabe cuál falló, que es justo lo que con dos no podés saber.]]
#block(breakable: false, below: 8pt)[*3.* ¿Cuál de estas defensas NO apunta al SEU? \
*A)* scrubbing \
*B)* memoria FRAM \
*C)* limitador de corriente LCL \
*D)* TMR
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* La C. El LCL es contra el latch-up, que es un quilombo de corriente. Las otras tres son contra bits dados vuelta.]]

#v(6pt)
#text(13pt, weight: "bold", fill: azul)[Arquitectura ARM]

#block(breakable: false, below: 8pt)[*4.* Para la OBC de un satélite donde importa acotar el tiempo de respuesta en el peor caso, conviene un... \
*A)* Cortex-A, porque es el más rápido \
*B)* Cortex-R \
*C)* Cortex-M, porque consume menos \
*D)* cualquiera, si total son todos ARM
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. El R optimiza el peor caso y trae tolerancia a fallas. La A es la cáscara: el A es más rápido en promedio, pero menos predecible.]]
#block(breakable: false, below: 8pt)[*5.* Al salir del reset, un Cortex-M... \
*A)* empieza a ejecutar main en la dirección cero \
*B)* carga el MSP desde la dirección cero y salta al vector de reset en la dirección cuatro \
*C)* carga el PSP y arranca el scheduler \
*D)* lee el linker script
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. La A es la trampa de creer que main es lo primero; antes corre todo el startup. La C te mezcla con RTOS. Y la D es un delirio: el linker script se usa al compilar, en el chip ni existe.]]
#block(breakable: false, below: 8pt)[*6.* La declaración static int counter, sin valor inicial, afuera de toda función, ¿dónde queda? \
*A)* en el stack \
*B)* en el heap \
*C)* en punto data \
*D)* en punto bss
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: D.* La D, punto bss, porque no está inicializada. Si tuviera igual a cien, sería punto data. Stack y heap no: el stack es para locales, y el heap es sólo lo que pedís con malloc.]]

#v(6pt)
#text(13pt, weight: "bold", fill: azul)[C embebido y MISRA]

#block(breakable: false, below: 8pt)[*7.* Una variable que modifica una rutina de interrupción y lee el main se tiene que declarar... \
*A)* const \
*B)* static \
*C)* volatile \
*D)* register
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* La C, volatile. Static puede ir también, pero no es lo que resuelve el problema: lo que hace falta es que el compilador la relea de memoria cada vez.]]
#block(breakable: false, below: 8pt)[*8.* Una regla Required de MISRA... \
*A)* no se puede romper nunca \
*B)* se puede no cumplir con un desvío formal, documentado y justificado \
*C)* es una sugerencia sin trámite \
*D)* sólo aplica en autos
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. La A es Mandatory, y la C es Advisory. Ese es el triángulo que te van a revolver.]]

#v(6pt)
#text(13pt, weight: "bold", fill: azul)[Periféricos e interfaces]

#block(breakable: false, below: 8pt)[*9.* Comparado con I2C, el SPI... \
*A)* usa dos hilos y direcciones de siete bits \
*B)* permite que el esclavo arranque la comunicación \
*C)* es full-duplex y elige al esclavo con un chip select por dispositivo \
*D)* es diferencial y llega a cientos de metros
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* La C. La A es I2C. La B es falsa: el esclavo SPI nunca arranca. Y la D no es ninguno de los dos: diferencial y lejos es RS-485 o CAN.]]
#block(breakable: false, below: 8pt)[*10.* ¿Qué tiene CAN que no tiene RS-485? \
*A)* es diferencial \
*B)* es multipunto \
*C)* arbitraje no destructivo y detección de errores con CRC \
*D)* llega más lejos
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* La C. La A y la B las tienen los dos: los dos son diferenciales y multipunto. Esa es la jugada sucia: ponerte cosas que comparten como si fueran la diferencia.]]

#v(6pt)
#text(13pt, weight: "bold", fill: azul)[Funciones y punteros]

#block(breakable: false, below: 8pt)[*11.* Tenés un puntero p a una estructura de telemetría. Para leer el campo estado escribís... \
*A)* p punto estado \
*B)* p flecha estado \
*C)* asterisco p flecha estado \
*D)* ampersand p punto estado
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. El punto es para la variable, no para el puntero. Y la C desreferencia dos veces. Mucho asterisco junto, nunca es buena señal.]]

#v(6pt)
#text(13pt, weight: "bold", fill: azul)[RTOS y FreeRTOS]

#block(breakable: false, below: 8pt)[*12.* Un sistema de tiempo real es aquel que... \
*A)* ejecuta todo lo más rápido posible \
*B)* garantiza que sus resultados son correctos y llegan dentro de un plazo predecible \
*C)* usa un procesador de alta frecuencia \
*D)* no usa interrupciones
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. La A es la trampa número uno de toda la clase. Que no te la vendan.]]
#block(breakable: false, below: 8pt)[*13.* Una interrupción le tiene que avisar a una tarea que llegó un byte, sin pasarle datos. Lo más adecuado es... \
*A)* un mutex \
*B)* un semáforo binario \
*C)* una cola de cien elementos \
*D)* una variable global sin volatile
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B, semáforo binario: señalizar un evento. El mutex no, porque tiene dueño: lo agarra y lo suelta la misma tarea, y una interrupción no puede ser dueña. Y la D tiene dos errores en uno, es un combo.]]
#block(breakable: false, below: 8pt)[*14.* En Mars Pathfinder, el problema fue... \
*A)* un SEU en la memoria \
*B)* un desborde de pila por recursión \
*C)* una inversión de prioridad sobre un mutex, que hacía saltar el watchdog \
*D)* un bus lockup de I2C
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* La C. Y fijate que el watchdog aparece en la historia, pero no es el culpable: es el que reseteaba. Si te ponen "el watchdog estaba mal configurado", no.]]
#block(breakable: false, below: 8pt)[*15.* Una interrupción que llama a xSemaphoreGiveFromISR tiene que tener en el NVIC una prioridad numérica... \
*A)* cero, la más urgente posible \
*B)* mayor o igual a cinco \
*C)* menor que cinco \
*D)* da lo mismo
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B, cinco o más. La A es la trampa del sentido común: querés que sea la más urgente, pero con cero no puede llamar al kernel, salta el assert y se cuelga todo.]]

#v(6pt)
#text(13pt, weight: "bold", fill: azul)[TP4 y TP5]

#block(breakable: false, below: 8pt)[*16.* El payload recibe bien el primer comando por SPI y los siguientes no. Lo más probable es... \
*A)* el baudrate de la UART \
*B)* que no se volvió a llamar a HAL SPI Receive IT después del callback \
*C)* que falta el pull-up de I2C \
*D)* que el checksum está mal calculado
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. Si anda una vez y después no, es la regla tres: la recepción por interrupción es de un solo uso. Como un forro. La A es otro periférico, y la C es otro bus.]]
#block(breakable: false, below: 8pt)[*17.* En el TP5, ¿por qué se usa mutex y no semáforo binario para proteger el sensor? \
*A)* porque el mutex es más rápido \
*B)* por la herencia de prioridad, que evita la inversión de prioridad \
*C)* porque el semáforo no existe en FreeRTOS \
*D)* porque el mutex copia los datos
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* La B. La D es la cola.]]

#v(6pt)
#text(13pt, weight: "bold", fill: azul)[Ronda rápida]

#block(breakable: false, below: 8pt)[*18.* Hamming SECDED: \
*A)* corrige dos bits y detecta tres \
*B)* corrige un bit y detecta dos \
*C)* sólo detecta \
*D)* corrige cualquier cantidad
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. Corrige uno, detecta dos.]]
#block(breakable: false, below: 8pt)[*19.* La memoria donde un SEU no te cambia el dato: \
*A)* SRAM \
*B)* FRAM \
*C)* la caché \
*D)* los registros del núcleo
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. FRAM, y también la MRAM.]]
#block(breakable: false, below: 8pt)[*20.* En el NVIC, la prioridad más urgente es: \
*A)* el número más alto \
*B)* el número más bajo \
*C)* la quince \
*D)* la cinco
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. En el NVIC, número chico es más urgente. Al revés que las tareas de FreeRTOS.]]
#block(breakable: false, below: 8pt)[*21.* ¿Cuál de estos buses tiene un único controlador y dos buses redundantes A y B? \
*A)* CAN \
*B)* SpaceWire \
*C)* MIL-STD 1553 \
*D)* I2C
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* C. El 1553.]]
#block(breakable: false, below: 8pt)[*22.* MISRA prohíbe malloc en vuelo porque: \
*A)* gasta mucha memoria \
*B)* el heap no es determinista y se fragmenta \
*C)* no existe en C once \
*D)* lo prohíbe gcc
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. Directiva cuatro punto doce.]]
#block(breakable: false, below: 8pt)[*23.* La excepción donde FreeRTOS hace el cambio de contexto: \
*A)* SysTick \
*B)* SVC \
*C)* PendSV \
*D)* HardFault
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: C.* C. PendSV. SysTick da el tick, SVC arranca la primera tarea.]]
#block(breakable: false, below: 8pt)[*24.* Una variable local de una función, al retornar: \
*A)* queda en punto data \
*B)* deja de existir porque su marco de pila se destruye \
*C)* queda en el heap hasta el free \
*D)* se copia a la FRAM
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B.]]
#block(breakable: false, below: 8pt)[*25.* El watchdog externo se prefiere al interno porque: \
*A)* es más rápido \
*B)* si el micro se cuelga entero, el interno se puede colgar con él \
*C)* consume menos \
*D)* lo exige MISRA
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B.]]
#block(breakable: false, below: 8pt)[*26.* CPOL y CPHA distintos entre maestro y esclavo SPI: \
*A)* no pasa nada \
*B)* datos corridos o corruptos aunque haya actividad en las líneas \
*C)* se quema el esclavo \
*D)* el bus se traba como en I2C
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. Error clásico de integración.]]
#block(breakable: false, below: 8pt)[*27.* Rate Monotonic le da más prioridad a la tarea de: \
*A)* mayor período \
*B)* menor período \
*C)* mayor tiempo de ejecución \
*D)* la que llegó primero
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. Menor período, más prioridad.]]
#block(breakable: false, below: 8pt)[*28.* Una arquitectura distribuida, comparada con una centralizada: \
*A)* es más simple de verificar \
*B)* elimina el único punto de falla pero necesita un bus robusto y cuesta más verificarla \
*C)* es siempre más barata \
*D)* no necesita bus
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B.]]
#block(breakable: false, below: 8pt)[*29.* El TMS570 es: \
*A)* un Cortex-A con Linux \
*B)* un Cortex-R con doble núcleo en lockstep \
*C)* un MSP430 de dieciséis bits \
*D)* un FPGA
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. El del laboratorio y el de LabOSat dos.]]
#block(breakable: false, below: 8pt)[*30.* Un if con un solo igual, if equis igual cinco, viola: \
*A)* la dieciséis punto cuatro \
*B)* la trece punto cuatro, no usar el resultado de una asignación \
*C)* la directiva cuatro punto doce \
*D)* ninguna
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B.]]
#block(breakable: false, below: 8pt)[*31.* Si un SEU te da vuelta un bit de la variable de modo de una máquina de estados, ¿qué defensas de la materia lo atajan? \
*A)* sólo el blindaje \
*B)* el default del switch que lleva a falla, y el watchdog si el programa se pierde en un bucle \
*C)* el linker script \
*D)* el round-robin
#block(fill: luma(235), inset: 6pt, radius: 3pt, width: 100%)[*Respuesta: B.* B. Y si la variable está en una memoria con EDAC, se corrige al leerla.]]