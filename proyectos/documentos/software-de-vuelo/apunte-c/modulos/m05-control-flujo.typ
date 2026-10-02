#import "../plantilla.typ": *

= Control de flujo

#objetivo[
  Elegir entre caminos con `if`, `else if` y `switch` sin que el orden o un `else`
  mal emparejado decidan por vos; repetir con `while`, `do-while` y `for` sabiendo
  cuál conviene y, sobre todo, cuándo termina cada uno; y leer datos del teclado con
  `scanf` sin creerle a ciegas.
]

== `if`, `else if`, `else`

Un `if` ejecuta su bloque si la condición vale distinto de cero (el módulo 3: una
comparación vale `1` o `0`). Con `else if` se encadenan varias, y con `else` se
atrapa todo lo que no cumplió ninguna. Lo que no siempre se ve es la regla de
fondo: *se evalúan en orden, y la primera que da cierta gana*. Las de abajo ni se
miran.

#codigo("m05-enlace", salida: true, titulo: "Cómo viene el enlace con la estación terrena")

La potencia recibida se mide en dBm, que es negativa (por eso `int16_t`, y por eso
es una de las pocas variables con signo del apunte): $-62$ es mucha señal, $-110$ es
casi nada. La primera cadena va del umbral más exigente al menos exigente, y acierta.
La segunda tiene *exactamente las mismas condiciones*, todas ciertas por separado,
pero en otro orden: $-62$ es mayor que $-105$, la primera da cierta, y un enlace
excelente queda clasificado como marginal. El OBC baja la velocidad de
transmisión por las dudas, y la mitad de las fotos del día se quedan a bordo.

#idea[en una cadena de umbrales, se ordena del más exigente al menos exigente, y
cada condición puede suponer que las de arriba ya dieron falso. Si las condiciones
no se pisan entre sí, el orden no importa; si se pisan, el orden *es* la lógica.]

#ojo[`if (modo = 3u)` compila: asigna 3 a `modo`, la expresión vale 3, y el `if`
entra siempre, de paso pisando el modo. Era `==`. gcc avisa con `-Wall`: _suggest
parentheses around assignment used as truth value_ (gcc 13.3, medido).]

== El `else` que se va con otro: _dangling else_

La sangría es para los humanos; el compilador no la mira. Cuando hay dos `if`
anidados sin llaves y un solo `else`, la regla es que el `else` se empareja con el
`if` *más cercano* que no tenga uno. Lo que diga la sangría da igual:

#codigo("m05-dangling", salida: true, titulo: "El plan del transmisor, según la sangría y según C")
#aviso("m05-dangling")

La sangría dice: «si no estoy en pasada, apagar el transmisor». C entiende: «si
estoy en pasada, y si la batería no está bien, apagarlo». Como no está en pasada,
no entra al primer `if` y no hace *nada*: el transmisor queda prendido, gastando
batería y hablándole a una estación que está del otro lado del planeta. gcc lo ve y
lo dice; la sangría, que es lo que leen los humanos en la revisión, no.

#mejora("llaves siempre")[
  Todo `if`, `else`, `while`, `do` y `for` lleva su bloque entre llaves, aunque
  tenga una sola línea (regla 15.6 de MISRA-C:2012). Con llaves, el _dangling
  else_ no puede pasar: cada `else` queda pegado a la llave que cierra su `if`. Y
  toda cadena `if ... else if` termina en un `else` (regla 15.7), aunque sea para
  dejar escrito por qué no hace nada.
]

== `switch`: uno de varios valores

Cuando la decisión es «según cuánto vale esta variable entera, hacer tal cosa»,
`switch` lo dice mejor que una cadena de `else if`. Cada `case` es un valor
*constante* (una macro sirve; una variable `const`, en C, no: el módulo 3 lo midió),
y `default` atrapa todo lo demás. Ningún lugar mejor que la entrada de
telecomandos, donde llega cualquier cosa:

#codigo("m05-comandos", salida: true, titulo: "El despachador de telecomandos")

Tres cosas para mirar. *Cada `case` termina en `break`*: sin él, la ejecución
sigue de largo al `case` de abajo (se dice que «cae», _fall through_), y un ping
terminaría reiniciando el satélite. *Dos `case` pegados* comparten código: la foto
en blanco y negro y la de color van al mismo lugar, y como entre ellos no hay
ninguna instrucción, no hay nada que caiga por error. Y *el `default`*: el último
telecomando es un byte que se corrompió en el viaje, y el OBC lo rechaza en vez de
hacer algo creativo con él.

#ojo[si te olvidás un `break` entre dos `case` con código, gcc avisa con `-Wextra`:
_this statement may fall through_ (gcc 13.3, medido). Es uno de los warnings que
justifican, solos, la regla de cero warnings.]

#mejora("default y break, siempre")[
  Todo `switch` tiene `default` (regla 16.4 de MISRA-C:2012), aunque creas que ya
  cubriste todos los valores: en vuelo, una radiación que da vuelta un bit te
  inventa valores. Y todo `case` con código termina en `break` (regla 16.3).
]

El `switch` vuelve en el módulo 9 como el corazón de las máquinas de estados, con
un `enum` en lugar de las macros y un `default` que lleva a falla.

== `while`: repetir mientras se cumpla

`while (condición) { ... }` mira la condición *antes* de cada vuelta: si de
entrada es falsa, el bloque no se ejecuta nunca. Ya apareció en el módulo 3,
esperando al magnetómetro, con su regla: en vuelo, *todo bucle tiene que
terminar*, aunque el hardware no conteste.

#catedra("esperas con cota")[
  Todo bucle de espera lleva una cota fija: tiene que terminar aunque el hardware
  no conteste.
]

La única excepción es el superloop del módulo 1, el `while (1)` de `main`, que no
tiene que terminar nunca: es el programa entero.

#ojo[`while (dato_listo == 0u);` con el punto y coma pegado es un bucle de cuerpo
vacío, y el bloque que venía abajo se ejecuta *una vez*, después, si es que alguna
vez se sale. Con los flags de la cátedra, gcc no dice nada (medido). Si el cuerpo
vacío es a propósito, se escribe `{ }` en su propio renglón, y se ve.]

== `do-while`: al menos una vez

`do { ... } while (condición);` mira la condición *después* de cada vuelta, así
que el bloque corre al menos una vez. Es justo lo que pide un reintento: primero se
intenta, después se pregunta si hace falta otra.

#codigo("m05-reintentos", salida: true, titulo: "Mandar un paquete hasta que llegue el ACK")

La condición tiene dos partes, y las dos importan: se sigue mientras *no* haya
confirmación *y* queden intentos. Sin la segunda, una estación terrena que se cayó
deja al OBC transmitiendo el mismo paquete hasta agotar la batería. Y fijate el
punto y coma después del `while` final: en el `do-while` va (es el fin de la
instrucción), en el `while` común es la trampa de arriba.

== `for`: contar

`for (inicio; condición; paso) { ... }` junta en una línea las tres partes de un
bucle que cuenta: dónde arranca, hasta cuándo sigue y cómo avanza. Es un `while`
con todo a la vista, y por eso es el que se usa cuando la cantidad de vueltas se
sabe de antemano.

#codigo("m05-despliegue", salida: true, titulo: "Cuenta regresiva y despliegue de paneles")

El primer `for` cuenta para atrás, y la condición es `t > 0u`, no `t >= 0u`. La
diferencia es todo: un `uint8_t` nunca es menor que cero, así que `t >= 0u` es
*siempre* cierto, y después de 0 viene 255 (el desborde del módulo 2). La cuenta
regresiva no termina nunca. gcc avisa con `-Wextra`: _comparison is always true
due to limited range of data type_ (gcc 13.3, medido). Es el precio del `unsigned`
por defecto, y se paga una sola vez, aprendiéndolo.

El segundo usa `break`: sale del bucle en el acto, sin terminar la vuelta ni
mirar la condición. El panel 2 no confirma, y desplegar el 3 con el 2 trabado puede
hacerlos chocar: se aborta la secuencia, y tierra decide.

#ojo[una variable `uint8_t` como contador de un `for` que llega a 300 nunca llega:
`i < 300` es siempre cierto, porque `i` da la vuelta en 255. El mismo aviso de
`-Wextra`, el mismo desborde. El contador tiene que poder contener el número al
que querés llegar.]

== `break` y `continue`

`break` sale del bucle (o del `switch`) en el que está. `continue` hace otra cosa:
saltea *lo que queda de esta vuelta* y pasa a la siguiente (en un `for`, pasando
por el paso). Los dos aparecen en el ejemplo que sigue.

== `scanf`: leer del teclado

`scanf` es el espejo de `printf`: usa los mismos especificadores, pero para
*leer*. Hay una diferencia en cómo se le pasa la variable: `&pedido_s`, con el `&`
adelante, que es «la dirección de» y se entiende en el módulo 8. Por ahora, la
regla es mecánica: en `scanf`, cada variable lleva `&`.

Y una regla que no es mecánica: *`scanf` devuelve cuántos datos pudo leer*, y ese
número hay que mirarlo. Un operador de tierra configura cada cuánto se manda la
telemetría, y escribe lo que escribe:

#codigo("m05-periodo", salida: true, entrada: true, titulo: "Configurar el período de telemetría desde la consola")

El bloque azul es lo que se tipeó (el verificador se lo pasa al programa como si
fuera el teclado). El 5 y el 30 se aceptan; el 0 y el 120 están fuera de rango y
`continue` los saltea sin tocar el período. Con «abc», `scanf` no puede leer un
número, devuelve 0, y el programa deja de leer. El 7 de abajo nunca se lee, y no
es un descuido: `scanf` no consume lo que no entiende, así que «abc» se queda
esperando en la entrada y cualquier `scanf("%u")` siguiente fallaría otra vez, para
siempre. Sin mirar lo que devuelve, el programa seguiría usando el último valor
como si fuera nuevo, y sin la cota, daría vueltas sin fin sobre la misma basura.

`SCNu16` es a `scanf` lo que `PRIu32` era a `printf` en el módulo 2: el
especificador correcto para un `uint16_t`, en cualquier plataforma.

#catedra("nada bloqueante")[
  En el superloop no va nada que se quede esperando.
]

`scanf` es bloqueante: el programa se queda quieto hasta que alguien tipee. En la
PC, para un práctico, está bien. En la placa no hay teclado, y lo que llega llega
por la UART, de a un byte y cuando quiere: se lee si hay algo, y si no, el
superloop sigue con lo suyo. Eso es el módulo 9.

#posta[
  En una cadena de `if`, la primera cierta gana: ordená del caso más exigente al
  menos exigente. Llaves siempre, y el _dangling else_ no existe. `switch` con
  `break` en cada `case` y `default` siempre. `while` mira antes, `do-while`
  después, `for` cuenta; y todos, salvo el superloop, terminan. Un `unsigned` nunca
  es menor que cero. Y lo que devuelve `scanf` se mira, siempre.
]
