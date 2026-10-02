#import "../plantilla.typ": *

= Constantes y calificadores

#objetivo[
  Leer cualquier literal de C (y no caer en el cero de adelante), ponerle nombre a
  cada número con `#define` sin que la precedencia te lo cambie, y saber qué
  promete cada calificador: `const` (esto no se toca), `volatile` (esto cambia por
  fuera) y `static` (esto vive toda la ejecución, o esto no sale de este archivo).
]

== Los literales: cómo se escribe un valor

Un _literal_ es un valor escrito directamente en el código, como el `42` en
`x = 42;` o la `'S'` de un modo de vuelo. Parece lo más inocente del lenguaje, y tiene más formas de las que uno
espera:

#tabla(
  columns: (auto, auto, 1fr),
  [*Forma*], [*Se escribe*], [*Ejemplos de la clase*],
  [entero decimal], [como siempre, sin cero adelante], [`0`, `123`],
  [entero octal], [con un `0` adelante], [`0123`],
  [entero hexadecimal], [con `0x` adelante], [`0xA024`],
  [entero binario], [con `0b` adelante], [`0b1001`],
  [flotante], [con punto, o con exponente `e`], [`0.6`, `2.5e9`, `-6.3E5`],
  [carácter], [entre comillas simples], [`'D'`],
  [cadena], [entre comillas dobles], [`"Leandro"`],
)

El mismo número, escrito de cuatro maneras, y dos sorpresas de yapa:

#codigo("m03-literales", salida: true, titulo: "Un valor, muchas formas de escribirlo")

Las cuatro configuraciones valen 42: la base es cómo lo escribís vos, no cómo lo
guarda la máquina (que siempre guarda bits). Para registros y máscaras se usa
hexadecimal, porque cada cifra son exactamente cuatro bits y se lee de un vistazo;
`%02X` lo imprime así.

#ojo[un cero adelante *no* es prolijidad: convierte el número en octal. El que
escribió `010` quería el ID 10 y le salió el 8, que es otra cámara. El `0123` de
la diapositiva, de paso, vale 83 en decimal. C no avisa: para el compilador es un
número perfectamente válido, sólo que no el que pensabas.]

La `'S'` es un carácter, y para C un carácter *es* un número: su código ASCII, 83.
Por eso se puede imprimir con `%c` o con `%d`, y por eso `char` es también «un
entero chico». Y el `-6.3E5` de la tabla no es un literal negativo: es el literal
`6.3E5` con el operador menos adelante. Detalle de abogado, pero el día que leas un
mensaje de error sobre eso, vas a saber de qué habla.

#ojo[`0b` no es C11: es una extensión de gcc, y el estándar la adopta recién en C23.
Con los flags de la cátedra compila sin decir nada; si agregás `-Wpedantic`, gcc
avisa que _binary constants are a C2X feature or GCC extension_. En la placa
compila igual (el compilador de CubeIDE también es gcc), pero si algún día el
código pasa por otro compilador, es lo primero que se cae.]

El sufijo dice el tipo del literal. Sin sufijo, `5.5e5` es `double`; con `f`,
`float`. En un entero, `u` lo hace sin signo:

#tabla(
  columns: (auto, 1fr, auto),
  [*Sufijo*], [*Tipo del literal*], [*Ejemplo*],
  [ninguno], [`int` (entero) o `double` (con punto)], [`1500`, `3.3`],
  [`u`], [`unsigned int`], [`1500u`],
  [`f`], [`float`], [`3.3f`],
  [`UL`], [`unsigned long`], [`100000UL`],
)

== `#define`: un nombre para un número

Un `3300` suelto en el medio del código no dice nada: ¿son milivolts, grados,
milisegundos? `#define` le pone nombre. Es una orden para el _preprocesador_, el
paso que corre *antes* del compilador y que reemplaza texto: donde dice
`CELDA_MIN_MV`, escribe `3300u`, y recién ahí compila. No tiene tipo, no ocupa
memoria, y no lleva punto y coma (si se lo ponés, el `;` viaja con el reemplazo).

#codigo("m03-bateria", salida: true, titulo: "Los límites de una celda de la batería")

La convención es mayúsculas, y la unidad en el nombre: `CELDA_MIN_MV` no deja
dudas, `LIMITE` sí. Si mañana cambia la batería, se cambia un número en un solo
lugar y el resto del programa se entera solo.

#catedra("lo configurable, con nombre")[
  Lo que se repite va en una función; lo configurable, en macros con nombre. Los
  límites, los umbrales y los tiempos se definen una vez, arriba, en la sección
  `Macros` de `template.c`.
]

=== La comparación vale 0 o 1

Mirá las cuatro variables del medio: no hay ningún `if`. En C, una comparación es
una expresión que *vale* algo: `1` si es cierta, `0` si no. Se puede guardar en un
`uint8_t`, combinar con `&&` (y), `||` (o) y `!` (no), e incluso sumar: la última
línea cuenta cuántas alarmas hay prendidas sumando condiciones. La celda está a
10 mV del límite, así que `baja` vale 1 y `celda_ok` vale 0: el OBC ya sabe que
tiene que cortar el consumo, y no hizo falta un solo `if` para enterarse.

== La trampa del `#define`: los paréntesis

Como el preprocesador reemplaza *texto*, sin entender nada de cuentas, una macro
con una operación adentro es una bomba de tiempo:

#codigo("m03-macro", salida: true, titulo: "El margen que se comió la precedencia")

`2u * MARGEN_MAL` se convierte, letra por letra, en `2u * 100u + 50u`. La
multiplicación va primero, y queda $200 + 50 = 250$. Con paréntesis, en
`2u * (100u + 50u)`, que da los 300 que se querían. Cincuenta miliampere de
margen que desaparecieron sin un warning, y que alguien va a extrañar el día que
el panel entregue menos de lo que dice la hoja de datos.

#mejora("paréntesis y sufijo, siempre")[
  Toda macro que tenga una operación va entera entre paréntesis, sin excepción
  (las macros con parámetros piden más todavía: se ven en el módulo 11). Y toda
  constante entera sin signo lleva la `u`, como `3300u`: lo exige la regla 7.2 de
  MISRA-C:2012, el estándar de C para sistemas críticos que vuelve en el módulo 12.
]

== `const`: el dato que no se toca

`const` delante del tipo dice que el programa no puede modificar esa variable. En
el ejemplo de la batería, la lectura de la celda es `const`: una vez tomada, no
hay motivo para cambiarla, y si alguien lo intenta:

```c
const uint16_t celda_mv = 3290u;
celda_mv = 3300u;
```

gcc no avisa: *corta*. Es un error, no un warning, y no hay ejecutable:
`error: assignment of read-only variable 'celda_mv'` (gcc 13.3 de Ubuntu).

#catedra("const")[
  `const` va antes del tipo y hace que el dato no se pueda modificar. Sirve para
  tres cosas: que no lo cambie el programa, poder ubicar el dato en la memoria
  flash (de sólo lectura), y documentar la intención de quien lo escribió.
]

Lo de la flash importa más de lo que parece. La NUCLEO-F446RE tiene 512 KB de
flash y 128 KB de RAM: una tabla de calibración de 2 KB declarada `const` (y
global, o `static`) se queda en la flash, donde sobra lugar; sin el `const`, el valor
inicial igual se guarda en la flash, y además el programa lo copia a la RAM al
arrancar, donde no sobra nada. Pagás dos veces por un dato que no ibas a cambiar.

#ojo[la diapositiva declara `const int c1, c2 = 10;`. El `const` alcanza a las dos
variables, pero el `= 10` es sólo de `c2`. Si eso está adentro de una función,
`c1` queda con lo que haya en la memoria, y como es `const`, *no se puede arreglar
después*: una constante de valor desconocido, para siempre. Se declara una por
línea y cada una con su valor.]

¿`#define` o `const`? Las dos ponen nombre a un valor, pero no son lo mismo:

#tabla(
  columns: (1fr, auto, auto),
  [*Pregunta*], [*`#define`*], [*`const`*],
  [¿tiene tipo, y el compilador lo chequea?], [no], [sí],
  [¿la ve el depurador?], [no: ya no existe], [sí],
  [¿ocupa memoria?], [no], [sí (en flash, si es global)],
  [¿sirve como tamaño de un vector global o en un `case`?], [sí], [no, en C],
)

La regla práctica: los límites y parámetros de configuración, con `#define` (como
pide la cátedra); los datos que se calculan o se leen una vez y no cambian más, y
las tablas, con `const`.

== `volatile`: lo que cambia por fuera

El compilador optimiza suponiendo que una variable sólo cambia cuando el código
que está viendo la cambia. Si en un bucle nadie escribe `dato_listo`, puede
leerla una sola vez, guardarla en un registro del procesador, y no volver a mirar
la memoria nunca más. En la PC eso es razonable. En un microcontrolador es un
desastre, porque hay cosas que cambian *sin que el código las toque*: un registro
del hardware que se pone en 1 cuando el ADC terminó, o una variable que escribe
una interrupción (la ISR, la función que el hardware llama cuando pasa algo).

`volatile` le avisa al compilador justamente eso: este dato puede cambiar por
fuera del flujo del programa, así que *leelo de la memoria cada vez*.

#codigo("m03-espera", salida: true, titulo: "Esperar al magnetómetro, pero no para siempre")

En la placa, `dato_listo` la pondría en 1 la interrupción del magnetómetro. En la
PC no hay magnetómetro ni interrupción, así que nadie la toca y la espera vence:
cien mil intentos, y el sensor queda marcado como caído. Que es exactamente lo que
tiene que pasar si el sensor se murió en órbita. Sin la cota, el OBC se queda
esperando a un magnetómetro que no va a contestar, con el resto del satélite
congelado detrás, hasta que el watchdog se apiade y lo reinicie.

#catedra("esperas con cota y volatile")[
  Todo bucle de espera lleva una cota fija: tiene que terminar aunque el hardware
  no conteste. Y lo que cambia por fuera del flujo del programa (hardware,
  interrupciones) se declara `volatile`, que obliga a leerlo de memoria cada vez.
]

#ojo[`volatile` no hace que una operación sea indivisible. Si `main` y una ISR
hacen `contador++` sobre la misma variable, ese `++` es leer, sumar y escribir: si
la interrupción cae justo en el medio, se pierde una cuenta, con `volatile` y
todo. Eso se arregla con secciones críticas, en el módulo 12.]

=== `const volatile`: sólo lectura, y cambia solo

Los dos juntos no se contradicen: `const` dice que *el programa* no lo escribe;
`volatile`, que cambia igual, por otro lado. Es la descripción exacta de un
registro de estado del hardware:

```c
/* Registro de estado del ADC1 de la F446RE: lo escribe el hardware, no nosotros */
#define ADC1_SR   (*(const volatile uint32_t *)0x40012000u)
```

Los asteriscos y el número de dirección son punteros, y se entienden en el
módulo 8. Por ahora alcanza con leer las dos palabras: el programa no puede escribir ahí
(`const`), y cada lectura va al hardware a buscar el valor de ese instante
(`volatile`).

== `static`: dos palabras con el mismo nombre

`static` significa dos cosas distintas según dónde se escriba, lo que es una
decisión de diseño de los años setenta que todavía pagamos.

*Adentro de una función*, cambia cuánto vive la variable. Una variable local
común nace en cada llamada y muere al salir; una `static` nace una sola vez, antes
de `main`, y conserva su valor entre llamadas:

#codigo("m03-watchdog", salida: true, titulo: "Contar los reinicios del watchdog")

`registrar_reset` es una función: se declara arriba de `main` y se define abajo,
como pide `template.c` (el detalle es del módulo 6). Cada vez que se la llama,
`automatica` vuelve a nacer en cero y llega a 1; `cuenta` arranca donde había
quedado.

#ojo[el `= 0u` de una `static` local se ejecuta *una vez*, no en cada llamada.
Parece que la reinicia y no: si la reiniciara, no serviría para nada.]

*Afuera de una función* —en una variable global, o delante de una función—,
`static` cambia quién la ve: sólo el `.c` donde está escrita. `resets_totales` y
`registrar_reset` son `static`, así que otro archivo del proyecto no las puede
tocar ni chocar con ellas. Con un archivo da igual; con veinte (el módulo 11) es
la diferencia entre que dos archivos tengan cada uno su `contador`, tranquilos, o
que el linker corte con _multiple definition_. Y con compiladores viejos, algo
peor: que no corte y los dos compartan el mismo `contador` sin que nadie lo sepa.

#catedra("static")[
  `static` local: conserva su valor entre llamadas y vive toda la ejecución.
  `static` global o en una función: visibilidad limitada al `.c`, para encapsular
  y evitar choques de nombres. Y en vuelo, sin `malloc`: la memoria se reserva
  así, de entrada y con tamaño fijo.
]

#posta[
  Cuatro palabras, cuatro preguntas. ¿Es un número que no cambia nunca y tiene que
  tener nombre? `#define`, con paréntesis y sufijo. ¿Es un dato que el programa no
  debe tocar? `const`. ¿Puede cambiar sin que tu código lo toque? `volatile`, y la
  espera con cota. ¿Tiene que acordarse de algo entre llamadas, o no debe salir de
  este archivo? `static`.
]
