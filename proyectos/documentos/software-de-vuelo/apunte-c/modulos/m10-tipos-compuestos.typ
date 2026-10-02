#import "../plantilla.typ": *

= Tipos compuestos

#objetivo[
  Agrupar datos distintos en un `struct` y usarlo con `.` y con `->`, entender por
  qué el orden de los campos cambia lo que ocupa, ver los bytes de un número con una
  `union` y no depender de su orden para mandarlo por el enlace, saber qué tienen de
  traicioneros los campos de bits, y leer cómo la HAL convierte un periférico en un
  `struct` apuntado a una dirección fija.
]

== `struct`: datos distintos, un solo nombre

Un vector junta muchos datos del *mismo* tipo. Un `struct` junta datos de tipos
distintos que van juntos: el tiempo de misión, la tensión de la batería, la
temperatura y el modo forman el paquete de _housekeeping_ (el estado general que el
satélite manda cada minuto). Separados son cuatro variables sueltas; en un `struct`
son una cosa sola, que se pasa, se copia y se guarda entera.

#codigo("m10-housekeeping", salida: true, titulo: "El paquete de housekeeping")

Con `typedef struct { ... } housekeeping_t;` el tipo queda con nombre propio, como
`modo_t` en el módulo 9. Cada campo se alcanza con un punto: `hk.modo`. La
inicialización con `.campo = valor` (inicializadores _designados_) nombra cada
campo, así que no importa el orden y no se puede confundir uno con otro; lo que no
se nombra queda en cero, como `resets`. Sin nombres, en orden, `{ 93784u, 3790u }`
también compila, pero `-Wextra` avisa que faltan campos (_missing initializer for
field_; gcc 13.3, medido), y con los nombres no avisa: está claro que es a
propósito.

Las funciones reciben un *puntero* al `struct`. Por valor se copiaría entero en
cada llamada (doce bytes acá; un paquete de verdad tiene cientos). Con el puntero, en
vez del punto se usa la flecha: `hk->resets` es lo mismo que `(*hk).resets`, «el
campo `resets` del `struct` al que apunta `hk`». `mostrar` lo recibe `const`: lee
sin copiar y promete no tocar, la combinación del módulo 7.

La última línea muestra que asignar un `struct` copia todos los campos: cambiar la
copia no toca el original.

== El relleno: el orden de los campos importa

El procesador lee más rápido (y algunos, sólo pueden leer) un `uint32_t` que empieza
en una dirección múltiplo de 4, un `uint16_t` en una par, y así. Para cumplirlo, el
compilador mete bytes de _relleno_ (_padding_) entre los campos, y al final. Los
mismos campos en otro orden pueden ocupar distinto:

#codigo("m10-padding", salida: true, titulo: "Los mismos cuatro campos, en dos órdenes")

`offsetof` (de `<stddef.h>`) dice en qué byte empieza cada campo. En el
desordenado, `modo` ocupa el byte 0, y `met_s` no puede empezar en el 1: salta
al 4. Después de `resets`, en el 8, `bateria_mv` salta al 10. Doce bytes, de los
cuales cuatro son aire. Ordenados del más grande al más chico, los campos caen
alineados solos: ocho bytes, ninguno de relleno. Mil paquetes guardados esperando
la pasada sobre la estación son cuatro kilobytes de diferencia, en una placa que
tiene 128.

Estos tamaños dan igual en la PC y en el Cortex-M4: medido con
`arm-none-eabi-gcc` 13.2 para la F446RE, los dos alinean igual los enteros de 1, 2, 4 y 8 bytes. Lo que
*no* da igual es lo que sigue.

#ojo[un `enum` ocupa 4 bytes en la PC y *1* en la placa: `arm-none-eabi-gcc` usa
_enums_ cortos por defecto (`-fshort-enums`), y ahí un `enum` ocupa lo mínimo que
necesitan sus valores (medido en los dos compiladores). Un `struct` con un campo
`modo_t` tiene un tamaño en la PC y otro en la placa, y sus campos empiezan en otros
bytes. Si el simulador de tierra y el OBC comparten ese `struct`, no se entienden.
En un `struct` que viaja o se guarda, los campos son de ancho fijo: `uint8_t modo`,
no `modo_t modo`.]

#mejora("del más grande al más chico, y -Wpadded")[
  Los campos se ordenan de mayor a menor tamaño, y el relleno desaparece casi
  siempre. `-Wpadded` hace que gcc avise cada vez que mete relleno (no está entre
  los flags de la cátedra; sirve para revisar un `struct` puntual). Y un `struct`
  nunca se manda por el enlace «tal cual está en memoria»: el relleno y el orden de
  los bytes dependen del compilador. Se arma la trama byte por byte, como sigue.
]

== `union` y el orden de los bytes

Una `union` se declara como un `struct`, pero sus campos no van uno después del
otro: van *todos en el mismo lugar*. Sirve para mirar los mismos bytes de dos
maneras, y la manera más útil de usarla en un apunte es para ver algo que el
procesador no muestra: en qué orden guarda los bytes de un número.

#codigo("m10-endian", salida: true, titulo: "El tiempo de misión, en memoria y en la trama")

`93784` es `0x00016E58`. En la memoria quedó `58 6E 01 00`: el byte menos
significativo primero. Eso es _little endian_, y es como guardan los números la PC
y el Cortex-M4. Los protocolos espaciales, como la cabecera CCSDS del módulo 4,
mandan el más significativo primero, _big endian_: `00 01 6E 58`.

La trama se arma con corrimientos, no con la `union`. `met_s >> 24` es el byte más
alto *por definición*, en cualquier procesador; leer `bytes[0]` de la `union` da el
más bajo en este procesador y el más alto en otro. El código con corrimientos
funciona igual en todos; el de la `union`, sólo donde lo probaste.

#mejora("union, mejor no")[
  MISRA-C:2012 aconseja no usar `union` (regla 19.2): leer un campo distinto del
  último que se escribió depende del compilador y del procesador. Acá sirvió para
  *mirar*; para *convertir*, corrimientos y máscaras.
]

== Campos de bits

Un `struct` puede tener campos de menos de un byte, con dos puntos y la cantidad de
bits:

```c
typedef struct {
    uint8_t modo   : 3;   /* 0 a 7 */
    uint8_t alarma : 1;
    uint8_t resets : 4;   /* 0 a 15 */
} estado_compacto_t;
```

Los tres campos entran en un byte (`sizeof` da 1, en la PC y en la placa: medido).
Se leen y se escriben como cualquier campo, y el compilador hace las máscaras por
vos. Parece ideal para mapear un registro, y no lo es: *el orden de los bits dentro
del byte lo decide el compilador*. gcc pone el primer campo en los bits de abajo (con `modo` 5, `alarma` 1 y
`resets` 2, el byte vale `0x2D`, en la PC y en la placa: medido);
otro compilador puede ponerlo arriba, y el estándar lo permite. Además, el tipo del
campo (`uint8_t` acá) es una extensión: C11 sólo garantiza `unsigned int`, `int` y
`_Bool` (MISRA lo exige, regla 6.1).

Por eso los encabezados de ST no describen los bits de un registro con campos de
bits sino con máscaras con nombre (terminadas en `_Msk`, con su posición en
`_Pos`): las operaciones del módulo 4, que hacen exactamente lo que dicen en
cualquier compilador.

== Mapear un periférico con un `struct`

Un periférico del micro, como un puerto GPIO, es un bloque de registros de 32 bits,
uno detrás del otro, a partir de una dirección fija. Un `struct` con un campo por
registro, en el mismo orden, *es* ese bloque: si se apunta un puntero a la dirección
base, cada campo cae justo sobre su registro. Así está hecha la HAL de ST:

#codigo("m10-registro", salida: true, titulo: "El puerto GPIOC, como struct")

Los desplazamientos que mide `offsetof` coinciden con los del manual de referencia
de la F446RE: `ODR` en `+0x14`, `BSRR` en `+0x18`. Cada campo es `volatile` (el
módulo 3: lo que se lee lo puede haber cambiado el hardware, y lo que se escribe
tiene que llegar). En la placa, `GPIOC` es `((gpio_t *)0x40020800u)`, la dirección
del puerto C; en la PC no hay nada ahí, y el ejemplo apunta a una variable que hace
de periférico. El resto del código es idéntico: `GPIOC->ODR |= (1u << 9)` prende la
pata 9, exactamente como en la placa.

La HAL lo hace igual: su tipo se llama `GPIO_TypeDef`, sus campos están declarados
con `__IO` (que es `volatile` con otro nombre), y `GPIOC` está definido como un
puntero a esa estructura en la dirección base del puerto. Cuando escribís
`HAL_GPIO_WritePin`, adentro pasa esto.

#ojo[`GPIOC->ODR |= (1u << 9)` es leer, modificar y escribir: tres pasos. Si una
interrupción cambia *otra* pata del mismo puerto justo en el medio, el `|=` la
pisa con el valor viejo (el `contador++` del módulo 3, otra vez). Para eso el
puerto tiene `BSRR`: escribir `1u << 9` prende la pata 9, y escribir
`1u << (9 + 16)` la apaga, en una sola escritura y sin tocar las demás. Es lo que usa
`HAL_GPIO_WritePin` por dentro.]

#posta[
  Lo que va junto, en un `struct`, inicializado con `.campo =` y pasado por puntero
  `const`; con puntero, flecha. Los campos, del más grande al más chico, y de ancho
  fijo si el `struct` viaja: un `enum` ocupa distinto en la PC y en la placa. Los
  bytes de un número dependen del procesador; la trama se arma con corrimientos.
  Campos de bits para registros, no: máscaras. Y un periférico es un `struct`
  `volatile` en una dirección fija, que es todo lo que la HAL hace por dentro.
]
