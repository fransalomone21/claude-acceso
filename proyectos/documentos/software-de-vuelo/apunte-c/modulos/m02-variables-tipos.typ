#import "../plantilla.typ": *

= Variables y tipos

#objetivo[
  Elegir el tipo de cada dato contestando dos preguntas —¿puede ser negativo?
  ¿cuánto rango necesita?—, saber cuánto ocupa en la PC y en la placa, imprimirlo
  con el especificador correcto, y reconocer las dos trampas que más telemetría
  arruinan: el desborde y la división entera.
]

== Qué es una variable

Una variable es un pedazo de memoria con *nombre*. Tiene cuatro cosas, y conviene
nombrarlas desde ya porque las cuatro vuelven: un *nombre* (`temperatura`), un
*tipo* (`int16_t`: cuántos bits ocupa y cómo se leen), un *valor* (`-18`) y una
*dirección*, el lugar de la memoria donde vive. La dirección la vas a ignorar
hasta el módulo de punteros, y ese día va a ser la protagonista.

En C toda variable se *declara* antes de usarla, diciendo su tipo. Declarar e
*inicializar* (darle valor) se puede hacer junto, y conviene:

```c
int16_t  temperatura = -18;   /* declarada e inicializada */
uint16_t corriente;           /* declarada: vale... cualquier cosa */
```

#ojo[una variable local declarada sin valor *no vale cero*: vale lo que haya
quedado en ese pedazo de memoria, que puede ser cualquier cosa y cambiar de una
corrida a otra. Es el error que funciona en tu máquina y falla en la de otro. Se
inicializa siempre, aunque sea en cero.]

== Los tipos de C, y por qué no alcanzan

C trae cuatro tipos básicos: `char` (un carácter, o un entero chico), `int`
(entero), `float` (decimal de precisión simple) y `double` (decimal de precisión
doble). Se les pueden agregar calificadores de tamaño (`short`, `long`) y de signo
(`signed`, `unsigned`). Hasta acá, lo de cualquier curso de C.

El problema es que C *no garantiza* cuánto mide cada uno: lo decide cada
compilador según la máquina. El estándar sólo promete mínimos —un `int` tiene *al
menos* 16 bits—. Este programa pregunta los tamaños con `sizeof`, que devuelve
cuántos bytes ocupa un tipo:

#codigo("m02-sizeof", salida: true, titulo: "Cuánto mide cada tipo, en la PC")

Ésa es la salida en la PC con Ubuntu. El mismo programa, compilado con el gcc
para ARM que trae CubeIDE, da `long` de *4* bytes, no de 8 (medido con el
compilador de CubeIDE 1.18.1 para un Cortex-M4, el de la NUCLEO-F446RE). Mismo
código, mismo nombre de tipo, la mitad de bits. Si ese `long` era un contador que
viaja en un paquete de telemetría, la estación terrena lo va a leer mal y nadie va
a entender por qué.

== La solución: tipos de ancho fijo

La biblioteca `<stdint.h>` trae tipos cuyo nombre *dice* cuánto miden, en
cualquier máquina:

#tabla(
  columns: (auto, auto, 1fr),
  [*Tipo*], [*Bits*], [*Rango*],
  [`uint8_t`], [8], [0 a 255],
  [`int8_t`], [8], [−128 a 127],
  [`uint16_t`], [16], [0 a 65 535],
  [`int16_t`], [16], [−32 768 a 32 767],
  [`uint32_t`], [32], [0 a 4 294 967 295],
  [`int32_t`], [32], [−2 147 483 648 a 2 147 483 647],
)

El nombre se lee solo: `u` es _unsigned_ (sin signo), el número son los bits, y
`_t` es «tipo». La regla del rango sale de contar: con $n$ bits hay $2^n$
combinaciones. Sin signo van de $0$ a $2^n - 1$; con signo, la mitad se usa para
los negativos, y van de $-2^(n-1)$ a $2^(n-1) - 1$. Por eso `int8_t` llega a 127 y
no a 128: el cero ocupa un lugar del lado positivo.

#catedra("ancho fijo, siempre")[
  La clase lo dice en mayúsculas: en código embebido se usan *siempre* tipos de
  ancho fijo, y `unsigned` por defecto para lo que son cantidades o patrones de
  bits. El tamaño tiene que ser inequívoco y explícito.
]

== Con signo o sin signo: dos preguntas

Para cada dato, antes de escribir el tipo, se contestan dos preguntas: *¿puede ser
negativo?* y *¿hasta dónde puede llegar?* Una rueda de reacción —la que gira
para orientar el satélite— lo ilustra bien:

#codigo("m02-rueda", salida: true, titulo: "Telemetría de una rueda de reacción")

El número de muestra no puede ser negativo y crece: `uint16_t`, que llega a 65 535.
La velocidad sí puede ser negativa, porque la rueda gira para los dos lados y el
signo es justamente *para cuál*: `int16_t`. La corriente en miliampere es una
cantidad: `uint16_t`. La tensión tiene decimales: `float`.

#ojo[la corriente viene en #strong[mili]ampere, y la potencia se calcula en watt. Si se
multiplica sin convertir, el resultado sale mil veces más grande: el satélite
estaría consumiendo 4956 W, más o menos lo de un horno eléctrico con el aire
acondicionado prendido. Las unidades se convierten *antes* de operar, y el
`1000.0f` (con punto) es a propósito: se ve en la última sección.]

== Imprimir con el especificador correcto

`printf` no sabe qué tipo le pasaste: se lo dice el especificador, y si no
coinciden imprime cualquier cosa. Los que se usan en la materia:

#tabla(
  columns: (auto, 1fr, auto),
  [*Especificador*], [*Para*], [*Ejemplo*],
  [`%d`], [enteros con signo], [`-3450`],
  [`%u`], [enteros sin signo], [`1207`],
  [`%f`, `%.2f`], [`float` y `double`; `.2` son los decimales], [`4.96`],
  [`%X`, `%02X`], [hexadecimal; `02` rellena con ceros a dos dígitos], [`0F`],
  [`%c`], [un carácter], [`A`],
  [`%s`], [una cadena], [`MISION-DEMO`],
  [`%zu`], [lo que devuelve `sizeof`], [`4`],
  [`%%`], [el signo de porcentaje mismo], [`%`],
)

#ojo[en la PC, `printf("%u", x)` con un `uint32_t` compila sin quejas. En la placa
*no*: para el gcc de ARM, `uint32_t` es un `long unsigned int`, y `-Wall` avisa que
`%u` espera un `unsigned int` (medido con el compilador de CubeIDE). El arreglo
portable es la macro `PRIu32` de `<inttypes.h>`: `printf("%" PRIu32 "\n", x);`.
Se ve fea, y funciona en las dos máquinas, que es lo que importa.]

== La primera trampa: el desborde

Un tipo tiene un rango, y C no avisa cuando se lo pasa. Un contador de paquetes de
8 bits:

#codigo("m02-desborde", salida: true, titulo: "Un contador de 8 bits que se da vuelta")

Después de 255 viene 0. En un tipo *sin signo* eso está definido por el estándar:
la cuenta da la vuelta como un cuentakilómetros. Si la estación terrena usa ese
número para detectar paquetes perdidos, va a creer que perdió 255 de golpe. El
arreglo es elegir el ancho pensando en el *peor caso*: ¿cuántos paquetes manda el
satélite en una pasada? ¿Y en un año?

#ojo[en un tipo *con signo* el desborde es todavía peor: el estándar dice que es
_comportamiento indefinido_, o sea que el compilador puede hacer lo que quiera,
incluido algo distinto según cuánto optimice. No es «da la vuelta a −128»: es «no
se sabe». Con signo, se chequea *antes* de sumar.]

== La segunda trampa: la división entera

Si los dos operandos de una división son enteros, C hace división *entera*: tira
los decimales, sin redondear. Calcular el porcentaje de batería parece una regla
de tres, y es un campo minado:

#codigo("m02-division", salida: true, titulo: "Tres formas de calcular un porcentaje")

La primera divide antes de multiplicar: `790 / 1200` da `0` (es menos de uno, y la
parte decimal se tira), y cero por cien es cero. La batería está al 65 % y el OBC
cree que está vacía: según cómo esté programado, entra en modo seguro y apaga la
carga útil. La segunda multiplica primero —`79 000 / 1200`— y da 65: los decimales
se siguen tirando, pero al final, donde pesan menos. La tercera mete un `float`
en la cuenta (`100.0f`) y C pasa *toda* la operación a punto flotante: 65,8.

#posta[
  En C el tipo no es un detalle de escritura: decide cuánto entra, qué pasa cuando
  se pasa, y cómo se hace cada cuenta. Por cada variable, dos preguntas: ¿puede ser
  negativo? ¿hasta dónde llega? Y en cada división, una tercera: ¿estos dos son
  enteros?
]
