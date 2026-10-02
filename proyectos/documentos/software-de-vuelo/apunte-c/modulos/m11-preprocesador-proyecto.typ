#import "../plantilla.typ": *

= Preprocesador y proyecto

#objetivo[
  Escribir macros con parámetros que no te traicionen (o cambiarlas por una
  función), elegir qué código se compila con `#if` y `#ifdef`, frenar la compilación
  cuando algo no cuadra con `#error` y `_Static_assert`, y partir un programa en
  `.h` y `.c` como cualquier proyecto real: la interfaz por un lado, lo de adentro
  por el otro, y la guarda que evita que todo explote al incluir dos veces.
]

== El preprocesador, de vuelta

El módulo 3 lo presentó: antes de compilar, el _preprocesador_ recorre el archivo
y reemplaza texto. Todo lo que empieza con `#` es para él: `#include` pega un
archivo entero en ese lugar, `#define` reemplaza un nombre por un texto, y los `#if`
deciden qué partes del código ni siquiera llegan al compilador. No sabe C: sabe
cortar y pegar. Eso es lo que lo hace útil, y lo que lo hace peligroso.

== Macros con parámetros

Un `#define` puede recibir parámetros, y entonces parece una función:

#codigo("m11-macros", salida: true, titulo: "Dos macros y una función")

`CUADRADO_MAL(n + 1)` no es $(n+1)^2$: el preprocesador pega el texto tal cual y
queda `n + 1 * n + 1`, que con $n = 3$ da $3 + 3 + 1 = 7$. Con cada parámetro entre
paréntesis, y la macro entera también, `CUADRADO` da los 16 que se querían. Es la
regla del módulo 3, ahora con parámetros: paréntesis alrededor de cada uso, y de
todo.

Los paréntesis no salvan a `MAYOR`. El texto de `muestra++` aparece *dos veces*
en el reemplazo (una en la comparación, otra en el resultado), así que se
incrementa dos veces: `tope` queda en 6 y `muestra` en 7, cuando se le pasó un 5. La
función `mayor` evalúa cada argumento una sola vez, como cualquier función, y da lo
esperable. Ninguna de las dos trampas da warning con los flags de la cátedra
(gcc 13.3, medido).

`static inline` le sugiere al compilador que pegue el cuerpo de la función en cada
llamada, como haría una macro, pero con tipos, con un solo cálculo por argumento y
visible en el depurador. Lo que antes se hacía con macros por velocidad, hoy se hace
así.

#mejora("funciones antes que macros")[
  Si algo se puede escribir como función, va como función: MISRA-C:2012 lo aconseja
  (directiva 4.9). Las macros con parámetros quedan para lo que una función no puede
  hacer, como usar `__FILE__` y `__LINE__` del lugar donde se llama (el ejemplo que
  sigue). Y si escribís una, cada parámetro entre paréntesis, el total entre
  paréntesis, y nunca un argumento con `++` o una llamada adentro.
]

== Compilación condicional

`#if`, `#elif`, `#else` y `#endif` eligen qué código se compila según el valor de
una macro. `#ifdef X` pregunta si `X` está definida, valga lo que valga. Así se
arma una sola fuente para varias versiones: el OBC de ingeniería y el de vuelo, con
mensajes de depuración y sin ellos.

#codigo("m11-config", salida: true, titulo: "Un solo código, dos modelos y dos versiones")

Con `OBC_MODELO` en 2, el compilador ni ve la línea de 64 KB: para él, nunca
existió. Si alguien pone un 3, la rama de `#error` corta la compilación con ese
mensaje, en vez de compilar un OBC con una cantidad de RAM inventada.

`LOG` muestra lo que una función no puede: `__FILE__` y `__LINE__` son macros que
el preprocesador reemplaza por el archivo y la línea *donde se usan*, así que cada
mensaje dice de dónde salió (líneas 36 y 38: las de los dos `LOG` en `main`). Sin
`OBC_DEPURACION`, `LOG` se reemplaza por `do { } while (0)`, que no hace nada pero
sigue siendo una instrucción completa con su punto y coma: la versión de vuelo no
tiene ni un `printf`, y el código que usa `LOG` no cambia ni una letra.

La macro no tiene por qué estar escrita en el código: `gcc -DOBC_DEPURACION`
la define desde la línea de comandos, y es como se separan las versiones *Debug* y
*Release* de un proyecto. CubeIDE hace lo mismo: en las propiedades del proyecto,
_Preprocessor_, están las que define él (`USE_HAL_DRIVER`, el modelo del micro,
`DEBUG`).

`_Static_assert` es de C11, y es un control que corre *al compilar*: si la
condición es falsa, no hay ejecutable. Acá asegura que `housekeeping_t` mida 8
bytes, que es lo que espera el software de tierra. El día que alguien agregue un
campo, o lo compile un compilador que rellena distinto (el módulo 10), el
problema aparece en el escritorio y no en órbita: _static assertion failed:
"housekeeping_t ya no mide 8 bytes"_ (medido, cambiando el 8 por un 6).

== Un proyecto: `.h` y `.c`

Un programa de vuelo de verdad no entra en un archivo. Se parte en _módulos_, cada
uno con dos archivos: el `.h` (_header_, encabezado), que dice *qué* ofrece el
módulo, y el `.c`, que dice *cómo* lo hace. Los demás incluyen el `.h` y nunca
miran el `.c`.

#proyecto("m11-termico", archivos: ("termico.h", "termico.c", "main.c"), salida: true, titulo: "El control térmico, como módulo aparte")

El calefactor se prende por debajo de $-5$ grados y se apaga por encima de 0. Entre
los dos umbrales no cambia: es _histéresis_, y sirve para que una temperatura que
oscila alrededor de un solo umbral no prenda y apague el calefactor cada segundo
(un relé no dura mucho así). Nueve lecturas, tres conmutaciones.

*El `.h` es la interfaz.* Tiene el tipo de la configuración y las declaraciones
de las tres funciones que el resto del OBC puede usar, y nada más. *El `.c` es la
implementación*: las variables y la función `poner_calefactor` son `static`, así
que `main.c` no las puede tocar aunque quiera. Si lo intenta, `conmutaciones` no
existe para él: _'conmutaciones' undeclared_ (medido). La única forma de saber
cuántas conmutaciones hubo es preguntarle al módulo, con
`termico_conmutaciones()`. Si mañana el control térmico cambia por dentro, nadie
afuera se entera.

`main.c` incluye `termico.h` en la sección `User libraries` de `template.c`, y
con comillas: `"termico.h"` se busca primero en la carpeta del archivo que lo incluye;
`<stdio.h>`, entre los del sistema. Lo incluye *dos veces*, a propósito, y no pasa
nada: es la guarda.

=== La guarda del `.h`

`#ifndef TERMICO_H` / `#define TERMICO_H` / `#endif` envuelven todo el
encabezado. La primera vez, `TERMICO_H` no existe: se define, y se pega el
contenido. La segunda vez ya existe, y el `#ifndef` saltea todo hasta el `#endif`.
En un proyecto grande el doble `#include` no es a propósito, pasa solo: `main.c`
incluye `termico.h` y `telemetria.h`, y `telemetria.h` también incluye
`termico.h`. Sin la guarda, el compilador ve dos veces la definición de
`termico_config_t` y corta: _conflicting types for 'termico_config_t'_ (medido,
borrando las tres líneas de la guarda).

#ojo[en un `.h` se *declaran* cosas, no se *definen* variables. Si `termico.h`
dijera `uint16_t contador_global = 0u;`, cada `.c` que lo incluye tendría su propia
`contador_global`, y al juntar los dos el _linker_ corta con _multiple definition
of 'contador_global'_ (medido). Si una variable tiene que verse desde otro
archivo, en el `.h` va `extern uint16_t contador_global;` (que dice «existe, en
algún lado») y la definición, con su valor, va en *un solo* `.c`. Mejor todavía:
que no se vea, y que el módulo ofrezca una función para leerla, como
`termico_conmutaciones`.]

== Bibliotecas

Una _biblioteca_ es lo mismo a otra escala: un conjunto de `.h` que dicen qué
ofrece y `.c` (o código ya compilado) que lo hacen. `<stdio.h>` es la interfaz de
la biblioteca de C; la HAL de ST es una biblioteca con un par `.h`/`.c` por
periférico: `stm32f4xx_hal_gpio.h` y `stm32f4xx_hal_gpio.c`, en la carpeta
`Drivers` del proyecto de CubeIDE. Tu código va en `Core/Inc` (los `.h`) y
`Core/Src` (los `.c`), y el control térmico de arriba se mudaría tal cual:
`termico.h` a `Core/Inc`, `termico.c` a `Core/Src`, y en `main.c`, un `#include`
en la sección de usuario.

#posta[
  Macros con parámetros, sólo si una función no puede: con paréntesis en cada
  parámetro y en el total, y sin `++` en los argumentos. `#if` y `#ifdef` eligen qué
  se compila; `#error` y `_Static_assert` frenan lo que no cuadra antes de que
  vuele. Cada módulo, un `.h` con la interfaz y su guarda, y un `.c` con lo de
  adentro en `static`. En un `.h` se declara, nunca se define una variable.
]
