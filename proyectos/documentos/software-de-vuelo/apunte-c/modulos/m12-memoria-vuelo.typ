#import "../plantilla.typ": *

= Memoria y C de vuelo

#objetivo[
  Saber en qué memoria termina cada variable (flash, RAM, stack) y cuánto cuesta,
  por qué en vuelo no se usa `malloc`, qué hace de verdad `volatile` mirando lo que
  genera el compilador, proteger un dato compartido con una interrupción, defender
  el código de los bits que da vuelta la radiación, y ubicar todo lo anterior en
  MISRA-C, el estándar que ordena el C de los sistemas críticos.
]

== Dónde vive cada variable

La F446RE tiene dos memorias: 512 KB de flash, que no se borra al apagar y casi no
se escribe, y 128 KB de RAM, rápida pero volátil y escasa. El compilador reparte
las variables en _secciones_, y el _linker_ (con el `.ld` del proyecto) ubica cada
sección en una de las dos memorias:

#tabla(
  columns: (auto, auto, 1fr),
  [*Sección*], [*Dónde*], [*Qué va*],
  [`.text`], [flash], [el código],
  [`.rodata`], [flash], [lo global o `static` que es `const`, y los textos entre comillas],
  [`.data`], [flash *y* RAM], [lo global o `static` con valor inicial distinto de cero],
  [`.bss`], [RAM], [lo global o `static` sin valor inicial (o en cero)],
  [stack], [RAM], [las variables locales, los parámetros, las direcciones de retorno],
)

#codigo("m12-secciones", salida: true, titulo: "Tres vectores iguales en tres secciones distintas")

Los tres vectores miden lo mismo, 512 bytes, y viven en lugares distintos. Para
verlo hay que compilar para la placa, no para la PC: con el compilador de ARM, que
es de la misma familia que el de CubeIDE, y la herramienta `size`, que lista las
secciones de un objeto:

#terminal[
  \$ arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -std=c11 -Wall -Wextra -c m12-secciones.c \
  \$ arm-none-eabi-size -A m12-secciones.o \
  .text   164 \
  .data   512 \
  .bss    512 \
  .rodata 622
]

(Medido con `arm-none-eabi-gcc` 13.2 y `size` 2.42, en la nube; las líneas de
`size` están recortadas a las cuatro secciones que importan.) `TABLA_NTC` es
`const`: fue a `.rodata`, que vive en la flash. Los 110 bytes que sobran ahí son los
textos de los `printf`. `historia` no tiene valor inicial: fue a `.bss`, RAM que el
arranque llena de ceros. Y `ganancia`, con sus valores iniciales, fue a `.data`, que
es la cara: los valores iniciales se guardan en la flash (si no, se perderían al
apagar), y el código de arranque (el `Reset_Handler` del archivo `startup` del
proyecto de CubeIDE) los *copia* a la RAM antes de llamar a `main`. Ocupa dos veces.
Es lo que el módulo 3 dijo de las tablas sin `const`, ahora medido.

Y `local` vive en el stack, que no aparece en la lista porque no se reserva por
variable: es una zona fija (el `_Min_Stack_Size` del módulo 6) que las funciones
van usando y devolviendo.

#idea[para ver cuánta RAM y flash usa tu proyecto entero, CubeIDE muestra la
pestaña _Build Analyzer_ después de compilar; y en la consola de compilación, el
mismo `arm-none-eabi-size` corre solo al final, con `text`, `data` y `bss`.]

== Por qué no `malloc`

`malloc` pide memoria mientras el programa corre, de una zona llamada _heap_, y
`free` la devuelve. En la PC es lo normal. En vuelo, no, por tres motivos que se
suman:

- *Puede fallar*, y fallar tarde. `malloc` devuelve `NULL` si no hay lugar, y eso
  pasa recién cuando el heap se llenó: a los tres meses de misión, en una
  combinación de eventos que nadie probó en tierra.
- *Se fragmenta.* Después de mil pedidos y devoluciones de distintos tamaños,
  puede haber 4 KB libres repartidos en huecos de 100 bytes, y un pedido de 200
  falla con memoria «libre» de sobra.
- *No es determinístico.* Cuánto tarda `malloc` depende de cómo esté el heap: no se
  puede asegurar que una tarea termine a tiempo si adentro pide memoria.

Todo lo que el apunte guardó (el buffer circular, la tabla de patrones, el
paquete de housekeeping) tiene tamaño fijo y se reservó de entrada: se sabe
cuánta memoria usa el programa *antes* de volar, y no cambia nunca.

#catedra("sin malloc")[
  Sin memoria dinámica: nada de `malloc`. La memoria se reserva de entrada, con
  tamaño fijo.
]

#mejora("MISRA lo prohíbe")[
  La regla 21.3 de MISRA-C:2012 prohíbe `malloc`, `calloc`, `realloc` y `free`. Va
  con la 17.2 (sin recursión) del módulo 6: las dos existen para que la memoria
  del programa se pueda calcular antes de volar.
]

== `volatile`, en profundidad

El módulo 3 dijo que `volatile` obliga a leer de memoria cada vez. Ahora se puede
*ver*. Una espera, sin `volatile`:

```c
uint8_t listo;                         /* la pone en 1 una interrupcion */
void esperar(void) { while (listo == 0u) { } }
```

Compilada para la placa con optimización (`arm-none-eabi-gcc -O2 -S`, que genera el
ensamblador en vez del ejecutable), queda así (medido; recortado a las
instrucciones):

#terminal[
  esperar: \
  #h(1em) ldr  r3, .L5 \
  #h(1em) ldrb r3, [r3] \
  #h(1em) cbnz r3, .L1 \
  .L3: \
  #h(1em) b    .L3 \
  .L1: \
  #h(1em) bx   lr
]

Lee `listo` *una sola vez* (`ldrb`). Si es distinto de cero, vuelve
(`cbnz`, `bx lr`). Si es cero, salta a `.L3`, que es `b .L3`: un salto *a sí mismo*, para
siempre. El compilador razonó, correctamente para él, que nadie en esa función
cambia `listo`, así que si era cero, va a seguir siendo cero. La interrupción la
pone en 1 en la memoria, y el procesador ni se entera: está girando sobre una
instrucción que ya no mira la memoria. Con `volatile uint8_t listo;`, en cambio:

#terminal[
  esperar: \
  #h(1em) ldr  r2, .L6 \
  .L2: \
  #h(1em) ldrb r3, [r2] \
  #h(1em) cmp  r3, \#0 \
  #h(1em) beq  .L2 \
  #h(1em) bx   lr
]

El `ldrb` quedó *adentro* del bucle: cada vuelta vuelve a leer la memoria. Ésa es
toda la diferencia, y es la diferencia entre un OBC que funciona y uno que se
cuelga apenas alguien compila en _Release_. Lo peor: sin optimización (el modo
_Debug_ de CubeIDE) la versión sin `volatile` anda: con `-O0` el `ldrb` queda
adentro del bucle igual (medido). El error aparece el día que se cambia a _Release_ para volar.

== Secciones críticas

El módulo 3 avisó que `volatile` no hace que `contador++` sea indivisible, y el
módulo 10 lo volvió a ver con el `|=` sobre un registro. Ahora, el caso completo.
`paquetes++` son tres pasos: leer, sumar, escribir. Si la interrupción de la radio
cae entre el segundo y el tercero, se pierde una cuenta. En la PC no hay
interrupciones, así que el ejemplo escribe los tres pasos a mano y llama a la ISR
justo en el peor lugar:

#codigo("m12-carrera", salida: true, titulo: "Una cuenta perdida, paso a paso")

Llegaron dos paquetes: el de `main` y el de la ISR. La ISR contó el suyo (1), y
`main` escribió el 1 que había calculado *antes* de la interrupción, pisándolo. En
la placa esto no pasa en cada ejecución: pasa una vez cada tantos millones, cuando
la interrupción cae justo en esas dos instrucciones. No se reproduce en el banco
de pruebas, y aparece en órbita.

La solución es una _sección crítica_: apagar las interrupciones mientras se hace
la operación de tres pasos, y volver a dejarlas como estaban. En la placa, con las
funciones de CMSIS (la capa de ARM que trae todo proyecto de CubeIDE):

```c
uint32_t estado = __get_PRIMASK();   /* como estaban las interrupciones */
__disable_irq();                     /* nadie interrumpe desde aca... */
paquetes++;
__set_PRIMASK(estado);               /* ...hasta aca: se dejan como estaban */
```

Se guarda el estado en vez de prender las interrupciones a ciegas porque, si la
función se llamó con las interrupciones ya apagadas, no le corresponde a ella
prenderlas. Y la sección crítica dura *lo menos posible*: mientras está, el OBC no
atiende a nadie, y una interrupción que llega tiene que esperar.

#ojo[apagar las interrupciones no es gratis ni universal. Una sección crítica larga
(un `printf`, un bucle) demora todas las interrupciones del sistema, y alguna
puede tener un plazo que se pierde. Adentro, sólo la operación compartida, nada
más.]

== Programación defensiva: el espacio da vuelta bits

En órbita, una partícula con energía suficiente puede cambiar un bit de la RAM: un
_single event upset_ (SEU). No es una rareza: en órbita baja pasa, y el software
tiene que contar con eso. La programación defensiva es escribir el código
suponiendo que *algo* va a salir mal, y que cuando pase, el sistema lo detecte y
quede en un estado seguro.

Varias herramientas del apunte eran eso sin decirlo: el `default` que lleva a falla
(módulos 5 y 9), la tabla de despacho que controla el índice (8), la tabla `const`
en flash, que una partícula no cambia como cambia la RAM (8), el `_Static_assert`
(11), las esperas con cota (3 y 5). Una más, clásica en satélites: guardar lo
crítico *tres veces* y votar.

#codigo("m12-tmr", salida: true, titulo: "El modo de la misión, por triple")

`votar` hace, bit por bit, lo que diría una mayoría: `(a & b) | (a & c) | (b & c)`
vale 1 en cada bit donde al menos dos de las tres copias tienen 1 (las operaciones
del módulo 4). Cuando la partícula da vuelta el bit 6 de `modo_b`, que pasa de 2 a
66, las otras dos copias siguen en 2 y el voto da 2. Después, el _fregado_
(_scrubbing_): se reescribe la copia mala con el valor votado, para que un segundo
error en otra copia no gane la votación. Es la _redundancia modular triple_ (TMR),
la misma idea que en hardware se usa con tres procesadores.

Cuesta el triple de memoria y de escrituras, así que se reserva para lo que, si se
corrompe, pierde la misión: el modo, los parámetros del control de actitud, el
contador de reinicios.

== MISRA-C, el mapa

MISRA-C:2012 son 143 reglas y 16 directivas (más las que sumaron sus enmiendas), nacidas en la industria automotriz y adoptadas
por casi todo el software crítico, espacial incluido. Cada una tiene un motivo
concreto: una forma de escribir C que, alguna vez, hizo que algo fallara. A lo
largo del apunte aparecieron éstas:

#tabla(
  columns: (auto, 1fr, auto),
  [*Regla*], [*Qué pide*], [*Módulo*],
  [6.1], [campos de bits sólo con tipos adecuados], [10],
  [7.2], [la `u` en las constantes sin signo], [3],
  [10.1], [operadores de bit sólo sobre sin signo], [4],
  [12.1], [paréntesis cuando se mezclan operadores], [4],
  [12.2], [no correr más bits que el ancho del tipo], [4],
  [13.5], [nada que cambie algo a la derecha de `&&` o `||`], [4],
  [15.5], [una sola salida por función (aconsejada)], [6],
  [15.6], [llaves siempre], [5],
  [15.7], [toda cadena `else if` termina en `else`], [5],
  [16.3], [`break` en cada `case`], [5],
  [16.4], [`default` en todo `switch`], [5],
  [17.2], [sin recursión], [6],
  [17.7], [el valor que devuelve una función se usa], [6],
  [18.4], [índices antes que aritmética de punteros (aconsejada)], [8],
  [19.2], [`union`, mejor no (aconsejada)], [10],
  [21.3], [sin `malloc` ni `free`], [12],
  [21.6], [sin `<stdio.h>` en producción], [7],
  [directiva 4.9], [funciones antes que macros con parámetros (aconsejada)], [11],
)

El texto completo de MISRA es pago y no se puede copiar acá; lo que importa es el
hábito: antes de escribir algo «ingenioso», preguntarse si alguien, alguna vez,
perdió un satélite por escribirlo así. Casi siempre la respuesta es sí, y la regla
ya existe.

#posta[
  Lo `const` va a la flash; lo inicializado ocupa flash *y* RAM; lo demás, RAM; y
  el stack es chico. La memoria se reserva de entrada: nada de `malloc`.
  `volatile` es la diferencia entre leer la memoria en cada vuelta o girar para
  siempre sobre una instrucción, y aparece al optimizar. Lo que comparten `main` y
  una interrupción se toca dentro de una sección crítica corta. Y el código de
  vuelo supone que un bit se va a dar vuelta: `default` a falla, índices
  controlados, tablas en flash, y lo crítico, por triple.
]
