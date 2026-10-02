#import "../plantilla.typ": *

= Operadores, y los de bit

#objetivo[
  Hacer cuentas enteras sin perder nada en el camino (`/` y `%` juntos), saber qué
  vale una condición y cuándo C ni se molesta en evaluarla, leer una expresión en el
  orden en que la lee el compilador, y manejar bits sueltos: prender, apagar,
  conmutar y consultar uno sin tocar a los vecinos, y armar y desarmar un campo
  adentro de una palabra.
]

== Los aritméticos, y el resto

Los de toda la vida: `+`, `-`, `*`, `/`, y uno que en la secundaria no se usa
nunca y en un micro se usa todo el tiempo: `%`, el _resto_ de la división entera.
`17 / 5` vale 3 (el módulo 2 ya avisó que la división entera tira los decimales) y
`17 % 5` vale 2, lo que sobró. Juntos no pierden nada: $17 = 3 dot 5 + 2$.

Ese par es justo lo que hace falta para pasar el tiempo de misión, que el OBC lleva
en milisegundos desde el despegue, a algo que un humano pueda leer:

#codigo("m04-reloj", salida: true, titulo: "El tiempo de misión, en días, horas, minutos y segundos")

Cada renglón hace lo mismo: la división dice cuántas unidades enteras entran, y el
resto es lo que queda para la unidad siguiente. Noventa y tres millones de
milisegundos son un día, dos horas y monedas: dicho así, el operador de tierra deja
de hacer cuentas en una servilleta. Y fijate que las macros tienen paréntesis: es
la lección del módulo 3, y acá `MS_POR_DIA` es una cuenta de cuatro factores
esperando que alguien la meta en una expresión.

`resto %= MS_POR_DIA` es una _asignación compuesta_: abrevia
`resto = resto % MS_POR_DIA`. Existe para casi todos los operadores (`+=`, `-=`, `*=`, `/=`, `%=`,
y los de bit que vienen después: `&=`, `|=`, `^=`, `<<=`, `>>=`), y se lee «a la
variable de la izquierda, aplicale esto».

#ojo[con negativos, `%` sigue al dividendo: `-7 % 3` vale `-1`, no `2` (desde C99
la división redondea hacia el cero, y el resto hereda el signo). Si lo usás para
saber «en qué lugar de una vuelta estoy» con un número que puede ser negativo, el
resultado puede ser negativo también. Otro argumento para el `unsigned` por
defecto. Y `%` es sólo para enteros: con `float` no compila.]

== Relacionales y lógicos

El módulo 3 adelantó que una comparación *vale* `1` o `0`. Éstos son todos:

#tabla(
  columns: (auto, 1fr, auto, 1fr),
  [*Relacional*], [*Vale 1 si…*], [*Lógico*], [*Vale 1 si…*],
  [`a == b`], [son iguales], [`p && q`], [las dos son distintas de cero (y)],
  [`a != b`], [son distintos], [`p || q`], [alguna es distinta de cero (o)],
  [`a < b`, `a <= b`], [menor, menor o igual], [`!p`], [`p` vale cero (no)],
  [`a > b`, `a >= b`], [mayor, mayor o igual], [], [],
)

Y tienen una propiedad que parece un detalle y es una herramienta: `&&` y `||`
evalúan de izquierda a derecha y *cortan apenas saben la respuesta*. Si lo de la
izquierda de un `&&` vale cero, el resultado ya es cero, y lo de la derecha no se
ejecuta. Es el _cortocircuito_, y sirve de guardia:

#codigo("m04-logicos", salida: true, titulo: "Temperatura de la cámara, con guardia y modo")

Con cero muestras, `(muestras != 0u)` vale 0 y la división `suma_dc / muestras`
*no se hace*. Sin esa guardia, en la PC el programa muere con _Floating point
exception_ (medido: el sistema lo mata, y no imprime nada más). En la placa es
peor, porque no muere: dividir por cero es comportamiento indefinido para C, y en
un Cortex-M4 como el de la F446RE la instrucción de dividir, de fábrica, devuelve 0
y sigue de largo (salvo que se prenda la trampa `DIV_0_TRP`, según el manual de
arquitectura de ARM). El OBC calcula un promedio de cero décimas, decide que la
cámara está fresquita, y sigue tan campante.

Con tres muestras el promedio da 475 décimas, 47,5 grados, por encima del límite: la
cámara está caliente y el modo pasa a seguro.

#ojo[`&` y `&&` no son lo mismo, por más que se lean parecido. La penúltima línea lo
muestra: `2 & 1` vale `0` (opera bit a bit: `10` y `01` no tienen ningún 1 en el
mismo lugar), y `2 && 1` vale `1` (los dos son distintos de cero). Se escribe uno por
el otro, compila igual, y el `if` decide al revés.]

#mejora("nada importante a la derecha de un && o un ||")[
  Como lo de la derecha puede no ejecutarse, ahí no va nada que cambie algo: ni un
  `++`, ni una asignación, ni una función que escriba un registro. En
  `(listo != 0u) && (reintentos++ < 3u)`, el contador sólo cuenta cuando `listo`
  vale distinto de cero, y eso nadie lo quiso. Es la regla 13.5 de MISRA-C:2012.
]

=== `++` y `--`, antes o después

`n++` suma uno a `n`, igual que `n += 1u`. La diferencia aparece cuando se usa el
*valor* de la expresión, como en las dos últimas líneas del ejemplo: `antes = n++`
guarda el valor viejo y después suma (`antes` vale 5, `n` pasa a 6);
`despues = ++n` suma primero y guarda el nuevo (`n` y `despues` valen 7).

#ojo[`k = k++;` no es una forma rebuscada de no hacer nada: es comportamiento
indefinido, porque la misma variable se modifica dos veces sin un orden establecido.
gcc avisa con `-Wall`: `operation on 'k' may be undefined` (gcc 13.3, medido). La
regla práctica: un `++` por variable y por expresión, y mejor si va solo en su
renglón.]

== El ternario

`condición ? valor_si : valor_no` es un `if` que *vale algo*, y por eso puede ir a
la derecha de un `=`. En el ejemplo, `modo` queda en `'S'` si la cámara está
caliente y en `'N'` si no, en un renglón y sin repetir el nombre de la variable en
dos ramas.

#ojo[un ternario adentro de otro compila perfecto y no lo entiende nadie, incluido
quien lo escribió, a la semana. Uno por expresión, para elegir un valor; si hay que
elegir qué *hacer*, es un `if`.]

== Quién va primero: la precedencia

Una expresión con varios operadores se evalúa en un orden fijo, y no es el que uno
supone mirando la línea. De mayor a menor, los de este módulo:

#block(breakable: false)[#tabla(
  columns: (auto, 1fr),
  [*Operadores*], [*Notas*],
  [`!` `~` `++` `--` y el menos de un solo operando], [los de un operando van primero],
  [`*` `/` `%`], [],
  [`+` `-`], [],
  [`<<` `>>`], [],
  [`<` `<=` `>` `>=`], [],
  [`==` `!=`], [*antes* que los de bit: ahí está la trampa],
  [`&`], [],
  [`^`], [],
  [`|`], [],
  [`&&`], [],
  [`||`], [],
  [`? :`], [],
  [`=` `+=` `-=` `&=` `|=` y el resto], [van último: primero se calcula, después se guarda],
)]

La fila marcada es el tropiezo clásico al consultar un bit:

#codigo("m04-precedencia", salida: true, titulo: "¿El GPS tiene posición?")
#aviso("m04-precedencia")

Como `==` va antes que `&`, la primera condición se lee
`estado & (0x08u == 0x08u)`, o sea `estado & 1`: pregunta por el bit 0, que está prendido, y responde
que el GPS tiene posición cuando no la tiene. Un OBC que cree saber dónde está es
más peligroso que uno que sabe que no sabe. gcc lo ve venir y avisa con `-Wall`;
por eso la cátedra exige cero warnings, y por eso éste no se ignora.

#mejora("los paréntesis no cuestan nada")[
  Cuando una expresión mezcla operadores de familias distintas (aritméticos, de
  bit, de comparación, lógicos), se ponen paréntesis aunque la precedencia dé bien:
  el que lee no tiene por qué saberse la tabla de memoria. Es la regla 12.1 de
  MISRA-C:2012, y el ejemplo de arriba es su razón de existir.
]

== Los operadores de bit

Hasta acá, un `uint8_t` era un número del 0 al 255. Ahora es otra cosa: *ocho
interruptores* en fila. En un micro se usa así todo el tiempo, porque cada
registro del hardware es eso: en uno del GPIO, cada bit es una pata; en uno de
estado, cada bit es un aviso. Los operadores trabajan bit por bit, cada uno con su
vecino del mismo lugar:

#tabla(
  columns: (auto, 1fr, auto),
  [*Operador*], [*Cada bit del resultado vale 1 si…*], [*Ejemplo en binario*],
  [`a & b`], [los dos valen 1 (y)], [`1100 & 1010` da `1000`],
  [`a | b`], [alguno vale 1 (o)], [`1100 | 1010` da `1110`],
  [`a ^ b`], [son distintos (o exclusivo)], [`1100 ^ 1010` da `0110`],
  [`~a`], [el de `a` vale 0 (los da vuelta)], [`~1100` da `0011` (en 4 bits)],
  [`a << n`], [corre todo `n` lugares a la izquierda; entran ceros], [`0011 << 2` da `1100`],
  [`a >> n`], [corre todo `n` lugares a la derecha], [`1100 >> 2` da `0011`],
)

#catedra("bits con operadores")[
  Los bits se manejan con los operadores de bit (máscaras, `|=`, `&= ~`, `^`, `<<`,
  `>>`), sobre tipos sin signo de ancho fijo.
]

=== Las cuatro operaciones con una máscara

Una _máscara_ es un número con unos sólo en los bits que te interesan. `(1u << 3)`
es un 1 corrido tres lugares: `00001000`, el bit 3 y nada más. Con una máscara, las
cuatro cosas que se le hacen a un bit son siempre las mismas:

#tabla(
  columns: (auto, auto, 1fr),
  [*Para…*], [*Se escribe*], [*Por qué anda*],
  [prender], [`x |= M;`], [`| 1` pone un 1; `| 0` deja lo que había],
  [apagar], [`x &= ~M;`], [`~M` tiene ceros sólo en los bits de `M`; `& 0` borra, `& 1` deja],
  [conmutar], [`x ^= M;`], [`^ 1` da vuelta el bit; `^ 0` lo deja],
  [consultar], [`(x & M) != 0u`], [queda distinto de cero sólo si el bit estaba en 1],
)

El OBC tiene un byte que dice qué está alimentado, un bit por equipo:

#codigo("m04-banderas", salida: true, titulo: "Prender y apagar equipos, de a un bit")

Cada operación toca sólo los bits de su máscara, y el resto del byte pasa intacto:
apagar la cámara no apaga el transmisor, que es la diferencia entre una foto menos
y un satélite mudo. El `^=` dos veces seguidas deja todo como estaba, que es la
gracia del o exclusivo (y la razón por la que conmutar a ciegas es mala idea: si no
sabés cómo estaba, no sabés cómo queda).

La función `imprimir_bits` es la forma de ver un número en binario: una máscara
arranca en `0x80` (el bit 7) y se corre un lugar a la derecha por vuelta,
consultando cada bit; cuando el 1 se cae por la derecha, la máscara vale cero y se
termina. El `for` es del módulo 5, y el `const char *`, de los módulos 7 y 8: acá
alcanza con leer lo que hace.

#idea[C11 no tiene un especificador para binario en `printf`. C23 agrega `%b`, y la
glibc de Ubuntu 24.04 ya lo entiende (medido: imprime `101` para un 5, y gcc 13 no
dice nada con los flags de la cátedra). Pero no es C11, y en la biblioteca de C de
la placa no está medido: la función de tres renglones anda en todos lados.]

#ojo[`~` sobre un `uint8_t` no da un `uint8_t`. Antes de operar, C promueve el
valor a `int`: con `m = 0x04u`, `~m` no es `0xFB` sino `0xFFFFFFFB`, y `~m == 0xFBu`
*nunca* es cierto. gcc avisa con `-Wextra`: _comparison of promoted bitwise
complement of an unsigned value with constant_ (gcc 13.3, medido). En `x &= ~M` no
hace daño, porque el resultado se recorta al guardarlo en `x`; para comparar, se
recorta a mano: `(uint8_t)~m == 0xFBu`.]

=== Correr bits: armar y desarmar una palabra

Los protocolos meten varios datos en una misma palabra, cada uno en su rango de
bits. La cabecera de un paquete de telemetría es el caso de libro: el estándar
CCSDS de paquetes espaciales (CCSDS 133.0-B), el que usan casi todas las misiones,
arranca cada paquete con 16 bits repartidos en cuatro campos: versión (3 bits),
tipo (1: telemetría o telecomando), si hay cabecera secundaria (1) y el _APID_ (11),
el número que dice de qué subsistema viene el paquete.

#codigo("m04-paquete", salida: true, titulo: "La cabecera de un paquete CCSDS, de ida y de vuelta")

*Armar* es correr cada campo a su lugar con `<<` y juntarlos con `|`: como los
rangos no se pisan, el `|` los apila sin mezclarlos. La máscara sobre el APID es
cinturón y tirador: si alguien define un APID de más de 11 bits, se recorta en vez
de pisar el bit de la cabecera secundaria. El `(uint16_t)` adelante es una
conversión explícita (un _cast_): la cuenta se hace en `unsigned int`, de 32 bits,
y el cast dice que quedarse con 16 es a propósito.

*Desarmar* es lo inverso: correr a la derecha hasta que el campo quede abajo de
todo, y quedarse con sus bits con una máscara. `0x1A5F` resulta ser un
telecomando, con cabecera secundaria, para el APID `0x25F`.

El contador de secuencia del paquete tiene 14 bits, así que después de 16383 viene
el 0. `& 0x3FFFu` hace eso solo: para un sin signo y una potencia de dos, quedarse
con los bits de abajo es lo mismo que el resto de dividir por esa potencia (acá,
`% 16384u`). Se escribe con la máscara porque dice lo que es: el campo tiene 14
bits, ni uno más.

#ojo[se corre siempre sobre sin signo. `1 << 31` en un `int` de 32 bits es
comportamiento indefinido (el 1 cae en el bit de signo), y gcc no dice nada con
los flags de la cátedra (medido). `>>` sobre un negativo depende del compilador
(gcc copia el bit de signo: `-16 >> 2` da `-4`). Y correr tantos lugares como bits
tiene el tipo, o más, es indefinido siempre. Por eso las máscaras se escriben
`1u << n`, con la `u`.]

#mejora("bits, sólo sobre sin signo")[
  Los operadores de bit van sobre operandos sin signo (regla 10.1 de MISRA-C:2012),
  y lo que se corre con `<<` o `>>` va de cero hasta uno menos que el ancho del
  tipo (regla 12.2). Con el `unsigned` por defecto de la cátedra, la primera viene
  de regalo.
]

#posta[
  `/` y `%` van juntos: uno dice cuántas veces entra, el otro qué sobra. `&&` y `||`
  cortan apenas saben, y eso se usa de guardia. La precedencia no se adivina: ante
  la duda, paréntesis, y si mezclás `&` con `==`, paréntesis sin duda. Y un byte son
  ocho interruptores: `|=` prende, `&= ~` apaga, `^=` conmuta, `&` consulta, `<<`
  arma y `>>` desarma. Siempre sobre sin signo.
]
