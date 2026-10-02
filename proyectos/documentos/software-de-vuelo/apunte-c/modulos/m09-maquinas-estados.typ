#import "../plantilla.typ": *

= Máquinas de estados

#objetivo[
  Modelar el comportamiento del OBC como una máquina de estados: los modos con un
  `enum`, las transiciones con un `switch` que cae a falla ante lo inesperado, los
  cambios disparados por eventos y no por relojes, y todo corriendo en un superloop
  que no se queda esperando a nadie, ni siquiera cuando el contador de
  milisegundos da la vuelta.
]

== El OBC siempre está en algún modo

Un satélite recién separado del lanzador no hace lo mismo que uno estabilizado
apuntando a la Tierra, y ninguno de los dos hace lo mismo que uno con la batería en
el piso. Lo que hace depende del *modo* en que está, y el modo cambia cuando pasa
algo: un _evento_. Eso es una _máquina de estados_: un conjunto finito de estados,
uno solo activo por vez, y reglas que dicen a qué estado se pasa ante cada evento.

Antes de escribir una línea de código, la máquina se escribe como tabla. La de
nuestro OBC:

#tabla(
  columns: (auto, 1fr, auto),
  [*Modo*], [*Evento que importa*], [*Pasa a*],
  [`ARRANQUE`], [separación del lanzador], [`DETUMBLING`],
  [`DETUMBLING`], [el giro bajó del umbral], [`NOMINAL`],
  [`NOMINAL`], [batería baja], [`SEGURO`],
  [`SEGURO`], [batería recuperada], [`NOMINAL`],
  [`FALLA`], [ninguno: sale sólo por telecomando], [—],
  [cualquier otro valor], [cualquiera], [`FALLA`],
)

_Detumbling_ es frenar el giro que le deja al satélite la separación, con los
magnetorquers, antes de poder hacer cualquier otra cosa. La última fila parece
sobrar, y es la más importante: vas a ver por qué.

== `enum`: los modos con nombre

Un `enum` define un tipo cuyos valores son nombres: `MODO_ARRANQUE`,
`MODO_DETUMBLING`... C les asigna números solo, desde 0 y de a uno. Es lo mismo que
una lista de `#define`, pero con dos ventajas: los valores van juntos bajo un
tipo, y el compilador sabe cuáles son, así que puede avisar si un `switch` se
olvida de alguno.

`typedef` le pone un nombre corto al tipo: con `typedef enum { ... } modo_t;`, se
declara `modo_t modo;` en vez de repetir el `enum` entero. La terminación `_t` es
costumbre para los tipos (como `uint8_t`). `typedef`
vuelve con todo en el módulo 10.

== La máquina: un `switch` sobre el modo

#codigo("m09-modos", salida: true, titulo: "Los modos de la misión")

`transicion` hace una sola cosa: recibe el modo actual y el evento, y *decide* el
modo siguiente. No prende nada, no transmite nada: eso lo hace otro código según
el modo. Separar la decisión de las acciones deja la máquina escrita en un solo
lugar, legible contra la tabla de arriba, renglón por renglón.

Mirá la tercera línea de la salida: en `DETUMBLING` llega «batería baja», y la
máquina no hace nada, porque la tabla no dice nada para ese par. ¿Está bien?
Depende: si el satélite gira rápido, quizá no puede ni orientar los paneles, y
pasar a seguro no ayuda. Si está mal, se agrega una fila. Lo importante es que la
decisión está *a la vista*, en un renglón de la tabla, y no escondida en un `if`
perdido en el medio del superloop.

#catedra("máquina de estados")[
  Una máquina de estados es un `enum` con los estados y un `switch` sobre el estado
  actual, con un `default` que lleva a falla.
]

La última línea es el `default` haciendo su trabajo. Un bit dado vuelta en la RAM
(en órbita pasa: es radiación, no mala suerte) dejó `modo` en 9, que no es ningún
modo. C no lo impide: meter un 9 en un `enum` compila sin avisar (gcc 13.3,
medido). El `switch` no encuentra el `case`, cae en `default`, y la máquina va a
`FALLA`, el único estado del que no se sale solo. Sin el `default`, el OBC
seguiría en un modo que no existe, sin hacer nada de nada y sin que nadie se
entere.

#ojo[el `default` tiene un costo escondido. Sin `default`, si te olvidás un `case`
de un `enum`, gcc avisa con `-Wall`: _enumeration value 'MODO_FALLA' not handled in
switch_. *Con* `default`, ese aviso se apaga, porque el compilador asume que el
`default` se encarga. El día que agregues un modo nuevo y te olvides su `case`, va
a ir a parar a `FALLA` sin que nadie te lo diga. Por eso el ejemplo tiene un `case`
para *cada* modo, incluso `MODO_FALLA`, que no hace nada (medido en gcc 13.3).]

#mejora("-Wswitch-enum en tus compilaciones")[
  `-Wswitch-enum` avisa de un valor del `enum` sin su `case` *aunque haya*
  `default`. No está entre los flags de la cátedra; en tu proyecto, agregalo: el
  `default` queda para lo corrupto, y lo olvidado lo ve el compilador. Y una nota
  de forma: `template.c` no tiene una sección para los tipos; acá van en
  `/* Types */`, entre las macros y las variables globales.
]

== Por evento, no por tiempo

Lo tentador es escribir «el detumbling dura 30 minutos, después pasá a nominal».
Y anda, hasta el día que la separación dejó al satélite girando el doble y a los 30
minutos sigue dando vueltas: pasa a nominal, intenta apuntar la antena con el
satélite girando, y no se comunica con nadie. La transición correcta es por el
*evento* que importa: el giro bajó del umbral. Eso es lo que el modo necesitaba
lograr.

El tiempo no desaparece: puede ser un evento más. «Pasaron 90 minutos sin contacto
con tierra» es un evento, que el superloop genera mirando el reloj y que la
máquina trata como cualquier otro. La diferencia es que el tiempo pasa a ser *una
condición más*, no la única.

== El superloop que no espera

El módulo 1 presentó el superloop: un `while (1)` que da vueltas para siempre. Si
una vuelta se queda esperando (un `HAL_Delay(500)`, un `scanf`, una espera sin
cota), todo lo demás se congela con ella: la telemetría no sale, el watchdog no se
alimenta, la máquina no ve eventos. La alternativa es no esperar *nunca*: en cada
vuelta, preguntar la hora, y hacer sólo lo que ya le toca.

#catedra("nada bloqueante")[
  En el superloop no va nada que se quede esperando.
]

En la práctica: ni `HAL_Delay`, ni esperas sin cota. Los tiempos se miden con
`HAL_GetTick()`.

`HAL_GetTick()` devuelve los milisegundos desde el arranque: un `uint32_t` que la
interrupción del SysTick incrementa uno por milisegundo (la HAL lo guarda en una
variable `volatile`, por lo del módulo 3). En la PC no hay SysTick, así que el
ejemplo lo simula: cada vuelta «dura» un milisegundo.

#codigo("m09-superloop", salida: true, titulo: "Dos tareas con distinto período, sin esperar")

Cada tarea guarda cuándo se ejecutó por última vez, y en cada vuelta pregunta
`(ahora - ultimo) >= PERIODO`. Si no le toca, sigue de largo. El LED cada 1,5
segundos, la telemetría cada 4, y nueve mil vueltas en las que nadie esperó a
nadie: entre una tarea y otra, el superloop podría atender la UART (preguntar si
llegó un byte, y si no, seguir), la máquina de estados, o el watchdog.

=== La vuelta del contador

Un `uint32_t` de milisegundos llega a su máximo a los 49,7 días, y vuelve a 0. Un
satélite está años en órbita: va a pasar, y muchas veces. El ejemplo arranca 2
segundos antes, a propósito: mirá la columna `tick`, que pasa de `0xFFFFFE0B` a
`0x000003E7` y el LED ni se entera.

La razón es el módulo 2: la resta entre sin signo es *módulo* $2^32$. Si `ultimo`
vale `0xFFFFFE0B` y `ahora` vale `0x000003E7`, `ahora - ultimo` da `0x5DC`, 1500,
exactamente lo que pasó. La resta da bien *aunque* el contador haya dado la vuelta.

La cuenta ingenua, `ahora >= ultimo + PERIODO`, no tiene esa suerte: cuando
`ultimo + PERIODO` se pasa del máximo, da la vuelta y queda chico, y `ahora`, que
todavía es enorme, es mayor desde la primera vuelta. La condición queda cierta en
*cada* vuelta del superloop hasta que `ahora` también da la vuelta. La última línea
lo midió: 505 conmutaciones en lugar de 5. Un LED que parpadea como loco es
gracioso; un calefactor que se prende y apaga quinientas veces, o un transmisor que
manda quinientos paquetes, no tanto. Y en tierra no se ve: hay que esperar 49,7
días.

#posta[
  Primero la tabla, después el código. Los modos, en un `enum`; la decisión, en un
  `switch` con un `case` por modo y un `default` que lleva a falla. Las
  transiciones, por el evento que importa; el tiempo, como un evento más. Y el
  superloop no espera nunca: pregunta la hora con `HAL_GetTick()` y compara con
  `(ahora - ultimo) >= PERIODO`, que sobrevive a la vuelta de los 49,7 días.
]
