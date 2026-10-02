#import "../plantilla.typ": *

= El programa mínimo

#objetivo[
  Escribir un programa en C con la estructura que pide la cátedra, compilarlo con
  los flags de la materia, leer un warning sin entrar en pánico, y explicar por qué
  un programa de un satélite no termina nunca.
]

C nació en 1972 en los laboratorios Bell, y medio siglo después sigue siendo el
idioma en que se escribe casi todo el software que vuela. No es nostalgia. En un
satélite el procesador es chico, la memoria es poca y nadie va a subir a
reiniciarlo, así que hace falta un lenguaje que haga *exactamente* lo que se le
escribe: nada de recolector de basura que se despierta cuando quiere, nada de
magia escondida. C traduce casi uno a uno a lo que el procesador ejecuta, deja
tocar el hardware directo y se comporta igual todas las veces. La contracara es
que tampoco te cuida: si le pedís algo absurdo, lo hace con toda la cortesía del
mundo.

La idea: todo lo que viene en este apunte apunta a lo mismo que la clase de
Leandro pone en una diapositiva —escribir código *correcto, predecible y
mantenible* para un sistema que no se puede reparar una vez lanzado—. Cada tema de
C que aparezca va a tener esa pregunta atrás: ¿esto me ayuda a que el OBC no se
cuelgue a 500 km de altura?

== La plantilla de la cátedra

Todos los ejercicios de la materia arrancan de la misma plantilla, `template.c`.
No es burocracia: ordena el archivo para que cualquiera —incluido vos, dentro de
tres semanas— encuentre las cosas siempre en el mismo lugar. Ésta es la plantilla
con lo mínimo adentro:

#codigo("m01-template", salida: true, titulo: "La plantilla, con un programa adentro")

De arriba hacia abajo, cada sección tiene un trabajo:

#tabla(
  columns: (auto, 1fr),
  [*Sección*], [*Qué va*],
  [`C libraries`], [Las bibliotecas del sistema, con `#include <...>`. `stdio.h` trae `printf`; `stdint.h` trae los tipos de ancho fijo del módulo que viene.],
  [`Macros`], [Las constantes con nombre, con `#define`. Acá, el nombre de la misión.],
  [`User libraries`], [Las bibliotecas propias, con `#include "..."` (comillas, no ángulos). Aparecen en el módulo 11.],
  [`Global variables`], [Lo que tiene que ver todo el archivo. Cuanto menos, mejor.],
  [`Functions declaration`], [La *firma* de cada función propia: nombre, qué recibe, qué devuelve. Va arriba de `main` para que el compilador la conozca antes de que alguien la llame.],
  [`main`], [Donde arranca el programa. Siempre `int main(void)`.],
  [`Functions definition`], [El *cuerpo* de cada función declarada arriba.],
)

`int main(void)` se lee así: una función que se llama `main`, no recibe nada
(`void`) y devuelve un entero (`int`). Ese entero es el `return 0` del final, y le
avisa al sistema operativo que todo salió bien; cualquier otro número es un
código de error. En la placa no hay sistema operativo que lo lea, pero en la PC sí,
y la terminal lo usa.

#ojo[el punto y coma cierra cada *instrucción*, no cada renglón. Las llaves `{ }`
agrupan instrucciones y no llevan punto y coma después. Olvidarse uno es el error
número uno de toda la carrera, y el compilador lo va a reportar en la línea
*siguiente*, porque recién ahí se da cuenta.]

== Compilar: de texto a programa

El procesador no entiende C: entiende instrucciones de máquina. El compilador
traduce. En la terminal de Ubuntu, con el comando que pide la materia:

#terminal[
  \$ gcc -Wall -Wextra -std=c11 m01-template.c -o obc \
  \$ ./obc \
  OBC MISION-DEMO: arranque OK
]

#tabla(
  columns: (auto, 1fr),
  [*Pedazo*], [*Qué hace*],
  [`gcc`], [El compilador de C de GNU, el mismo que trae CubeIDE adentro (en su versión para ARM).],
  [`-Wall`], [Prende los avisos (_warnings_) más comunes. A pesar del nombre, no son *todos*.],
  [`-Wextra`], [Prende otro montón que `-Wall` deja afuera. Entre los dos, el compilador se vuelve un compañero desconfiado, que es lo que se quiere.],
  [`-std=c11`], [Compila según el estándar C de 2011. Así un programa se comporta igual en cualquier compilador que lo respete.],
  [`-o obc`], [El nombre del ejecutable que sale. Sin esto se llama `a.out`, que no le dice nada a nadie.],
  [`./obc`], [Lo corre. El `./` es «el que está en esta carpeta».],
)

#catedra("cero warnings")[
  El práctico lo dice sin anestesia: un ejercicio *no está terminado* hasta que
  compila con *cero* warnings con esos tres flags. Compilar no alcanza; compilar
  callado, sí.
]

== Leer un warning

Un warning es el compilador diciendo «esto es legal, pero me huele mal». El
programa se genera igual, y por eso la tentación es ignorarlo. En software de
vuelo un warning ignorado es una falla que todavía no ocurrió. Este programa
declara una temperatura y nunca la usa:

#codigo("m01-warning", titulo: "Una variable que nadie usa")
#aviso("m01-warning")

// La línea y la columna salen del warning real, no se escriben a mano: si el
// ejemplo cambia, el texto cambia solo (y si el formato de gcc cambia, no compila).
#let donde = read("../ejemplos/m01-warning.warning").match(regex("m01-warning\.c:(\d+):(\d+): warning")).captures

Se lee en tres partes, y siempre son las mismas. Primero *dónde*:
#raw("m01-warning.c:" + donde.at(0) + ":" + donde.at(1)) es archivo, línea
#donde.at(0), columna #donde.at(1) (gcc cuenta el tabulador como ocho columnas). Después *qué*: `unused
variable` (variable sin usar). Al final, entre corchetes, *qué flag lo prendió*:
`-Wunused-variable`, que viene incluido en `-Wall`. Abajo, gcc dibuja el renglón y
apunta con `^` al lugar exacto, que es más de lo que hacen muchos profesores.

Este warning en particular parece inofensivo, y casi siempre esconde algo peor:
si declaraste la temperatura es porque la ibas a mandar en la telemetría, y te
olvidaste. El compilador no sabe qué querías hacer, pero sabe que no lo hiciste.

#posta[
  Un warning es un error que todavía no te mordió. Se leen de arriba hacia abajo,
  se arregla *el primero* y se vuelve a compilar: muchas veces los de abajo eran
  consecuencia de ése y desaparecen solos.
]

== Un programa de vuelo no termina

En la PC, un programa arranca, hace lo suyo y termina. En el OBC no: si el
programa terminara, el satélite se quedaría mudo hasta que alguien lo reinicie, y
ese alguien está a varios cientos de kilómetros. Por eso todo programa embebido
tiene la misma forma: *una inicialización que corre una vez*, y después *un bucle
infinito* que repite lo mismo mientras haya energía —leer sensores, atender
telecomandos, mandar telemetría—. Se llama _superloop_, y en la placa se escribe
`while (1)`.

Para poder mostrarlo acá, el ejemplo lo corta a tres vueltas; en la placa esa
cota no existe:

#codigo("m01-superloop", salida: true, titulo: "El superloop, recortado para la PC")

#ojo[que el bucle *principal* no termine no quiere decir que *cualquier* bucle
pueda no terminar. Un `while` que espera a un sensor que se rompió cuelga al OBC
entero. Los bucles de espera llevan siempre una cota: se ve en el módulo 5.]

#mejora("compilar desde VS Code")[
  El mismo comando se puede atar a una tecla en VS Code (una *tarea*, `tasks.json`),
  así no se tipea cada vez. La guía de IDEs de la materia explica cómo.
]
