#import "../plantilla.typ": *

= Funciones

#objetivo[
  Escribir una función como pide `template.c` (declarada arriba, definida abajo),
  saber qué recibe de verdad (una copia, salvo que le pases dónde está el dato),
  devolver un resultado y un estado a la vez como hace la HAL de ST, y entender por
  qué en vuelo la recursión se cambia por un bucle.
]

== Lo que se repite, en una función

Desde el módulo 3 los ejemplos vienen usando funciones sin presentarlas. Llegó el
momento. Una función es un pedazo de programa con nombre, que recibe datos, hace
algo, y opcionalmente devuelve un resultado. Se escribe una vez y se usa cuantas
veces haga falta, y eso es más que comodidad: si la conversión de un sensor está
copiada en cinco lugares y aparece un error, se corrige en cuatro.

#catedra("lo que se repite, en una función")[
  Lo que se repite va en una función; lo configurable, en macros con nombre.
]

== Declarar y definir

`template.c` pide dos lugares para cada función. Arriba de `main`, en
`Functions declaration`, va la _declaración_ (o _prototipo_): el tipo que devuelve, el nombre y
los parámetros, con punto y coma. Abajo, en `Functions definition`, va la
_definición_: lo mismo, pero con el cuerpo entre llaves. La declaración existe para
que el compilador, que lee de arriba hacia abajo, sepa cómo se usa la función antes
de llegar a su código.

#codigo("m06-adc", salida: true, titulo: "Cuentas del ADC a milivolts, una sola vez")

Las partes de `adc_a_mv`: devuelve un `uint16_t`, recibe un `uint16_t` que adentro
se llama `cuentas`, y con `return` entrega el resultado al que la llamó. En `main`,
`adc_a_mv(panel_x)` se reemplaza por lo que devolvió: se puede imprimir, guardar o
comparar como cualquier valor.

El `(uint32_t)` adelante de `cuentas` es un _cast_ (el del módulo 4): $4095 dot
3300$ son más de trece millones, y no entran en 16 bits. En la PC y en la placa la
cuenta se haría igual en 32 bits sin el cast, porque `int` es de 32 bits en las dos;
pero en un micro de 16 bits (un MSP430, un AVR) se desbordaría sin avisar. El cast
deja escrito que la cuenta necesita 32 bits, en cualquier lado.

La última lectura vale 4095, el tope de escala: 3300 mV exactos. Un termistor que
marca el máximo posible no está midiendo un incendio: casi siempre está
desconectado, y la resistencia de _pull-up_ lleva el pin a la tensión de referencia.
Un dato que está justo en el borde del rango merece desconfianza antes que alarma.

#ojo[`static uint8_t leer();`, con los paréntesis vacíos, en C11 *no* quiere decir
«sin parámetros»: quiere decir «no digo qué parámetros». Llamarla con
`leer(1, 2, 3)` compila sin un solo warning con los flags de la cátedra (gcc 13.3,
medido). Sin parámetros se escribe `(void)`, como `int main(void)`. C23 cambió esa
regla, pero la materia es C11.]

#ojo[dos que gcc sí ve. Una función que no es `void` y tiene un camino sin `return`
devuelve basura por ese camino: _control reaches end of non-void function_ (lo
prende `-Wall`). Y una función usada sin declarar: _implicit declaration of
function_, que además suele terminar en error cuando aparece la definición. Las dos,
medidas en gcc 13.3.]

== Por valor: la función recibe una copia

Cuando se llama a una función, cada argumento se *copia* en su parámetro. La
función trabaja sobre la copia, y lo que le haga no sale de ahí:

#codigo("m06-referencia", salida: true, titulo: "Limitar el calefactor, dos veces")

`limitar_copia` hace bien su trabajo: adentro, el `duty` queda en 80. Pero era una
copia, y al volver, el `duty` de `main` sigue en 95. El calefactor va a recibir 95 %
y el driver, que soportaba hasta 80, va a durar lo que dura un fusible. Ningún
warning: el código es legal, sólo que no hace lo que su nombre promete.

== Por referencia: la función recibe dónde está el dato

Para que una función cambie una variable del que la llama, no se le pasa el valor:
se le pasa *dónde está*. Es lo que hace `limitar`, y la receta tiene dos partes:

- en el parámetro, un `*` entre el tipo y el nombre: `uint8_t *duty` dice «recibo
  la dirección de un `uint8_t`», y adentro `*duty` es la variable de afuera;
- en la llamada, un `&` adelante: `limitar(&duty)` pasa «la dirección de `duty`».

Es la misma receta que `scanf` en el módulo 5, por el mismo motivo: `scanf`
necesita escribir en tu variable. Qué es una dirección, y qué más se puede hacer
con ella, es el módulo 8. Por ahora alcanza con la receta.

== Un resultado y un estado

Una función devuelve un solo valor con `return`. ¿Y si tiene que devolver dos
cosas, como un dato y si la lectura salió bien? La costumbre en embebido es: el
estado por `return`, el dato por referencia.

#codigo("m06-estado", salida: true, titulo: "Leer tres sensores de presión, y saber cuál falló")

`main` no usa `presion_hpa` hasta saber que la lectura salió bien. El sensor 1
falla, y su línea no inventa un número: si `main` hubiera impreso `presion_hpa` sin
mirar el estado, habría mostrado 1012, el valor que quedó del sensor 0, como si
fuera del 1. Un dato viejo con cara de nuevo es de las fallas más difíciles de
encontrar, porque el número es perfectamente razonable.

#idea[la HAL de ST trabaja así. Casi todas sus funciones devuelven
`HAL_StatusTypeDef` (`HAL_OK`, `HAL_ERROR`, `HAL_BUSY` o `HAL_TIMEOUT`) y los datos
los escriben en un puntero que les pasás. Cuando la uses en la placa, el patrón ya
lo conocés.]

#mejora("el valor que devuelve se usa, y se sale por un solo lugar")[
  Si una función devuelve algo, el que la llama lo usa (regla 17.7 de
  MISRA-C:2012): ignorar el estado de una lectura es la falla de arriba. Y la
  función sale por un solo `return`, al final (regla 15.5, de las «aconsejadas»):
  por eso `leer_presion` arranca suponiendo la falla y sólo la cambia si todo salió
  bien. Si alguien agrega un camino nuevo y se olvida de algo, el resultado por
  defecto es «falló», que es el error seguro.
]

== `static` en una función

Todas las funciones de los ejemplos son `static`. Es el `static` de afuera del
módulo 3: la función sólo se ve en este `.c`. Con un archivo da igual; en un
proyecto con veinte archivos (el módulo 11), evita que dos funciones `convertir`
de dos sensores distintos choquen, y deja claro qué funciones son internas y
cuáles son la interfaz del archivo.

== Recursión: una función que se llama a sí misma

Una función puede llamarse a sí misma. Para algunos problemas queda elegante:
contar los bits en 1 de un registro de fallas es «el bit de abajo, más los unos del
resto», y eso se escribe casi textual:

#codigo("m06-recursion", salida: true, titulo: "Contar las fallas activas, con y sin recursión")

Las dos versiones dan lo mismo. La diferencia está en la última columna. Cada
llamada que todavía no terminó ocupa su lugar en el _stack_ (la memoria donde viven
las variables locales y la dirección de retorno de cada llamada): con `0x5`, cuatro
llamadas anidadas; con `0x80000000`, que tiene *un solo* bit en 1, treinta y tres.
La memoria que usa depende del *dato*, no del código.

Medido con `gcc -fstack-usage` (que anota cuánto stack usa cada función), en la PC
cada llamada a `unos_recursivo` ocupa 64 bytes: treinta y tres anidadas son más de
2 KB. En la placa los números son otros, pero la forma es la misma, y el stack es
chico: en los proyectos que genera CubeIDE, el mínimo reservado está en el _linker
script_ (el `.ld` del proyecto) como `_Min_Stack_Size`, y suele ser `0x400`, un
kilobyte. Mirá el tuyo. Cuando el stack se acaba no hay mensaje de error: pisa la
memoria de al lado, y el satélite empieza a hacer cosas raras que nadie puede
reproducir en tierra.

`unos_iterativo` hace lo mismo con un `for`: una sola llamada, y la misma memoria
para cualquier dato. Eso se puede calcular antes de volar; la profundidad de una
recursión, en general, no.

#mejora("sin recursión")[
  Una función no se llama a sí misma, ni directa ni indirectamente (regla 17.2 de
  MISRA-C:2012). Todo lo que se escribe con recursión se puede escribir con un
  bucle, y el bucle tiene un uso de memoria fijo y medible. Va en la misma línea
  que la falta de `malloc` de la cátedra: en vuelo, la memoria se conoce antes de
  despegar.
]

#posta[
  Lo que se repite, en una función: declarada arriba, definida abajo, `static`, y
  con `(void)` si no recibe nada. Por valor recibe una copia; para cambiar algo de
  afuera, `*` en el parámetro y `&` en la llamada. El estado por `return`, el dato
  por referencia, y el estado se mira antes de usar el dato. Y nada de recursión:
  un bucle hace lo mismo con memoria fija.
]
