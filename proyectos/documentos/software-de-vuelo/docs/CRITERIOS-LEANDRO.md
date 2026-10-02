# Criterios de Leandro para el C de la materia — resumen público

**Fecha:** 2026-10-02. **Qué es:** nuestra **interpretación**, resumida, de lo
que pide Leandro en «Ingeniería de Software de Vuelo» (UNSAM, 2C 2026) para
escribir C. **No es textual** ni lo escribió la cátedra: el registro textual,
con la diapositiva o el práctico de donde sale cada criterio, vive en un repo
privado (`catedras`, `LEA-01` a `LEA-18`). Publicarlo así lo decidió Fran el
2026-10-02: estos criterios ya aparecen, en parte, en las cajas «Lo que pide
la cátedra» del apunte de C.

Sirve para que una sesión que no tiene el repo privado (la de la nube) escriba
el apunte con los mismos criterios. Si algo de acá contradice al registro
privado, **gana el privado** y esto se corrige.

| Id | Criterio (interpretado) |
|---|---|
| LEA-01 | Se compila con `gcc -Wall -Wextra -std=c11`. Terminado quiere decir **cero warnings** |
| LEA-04 | El programa sigue la estructura de `template.c`: bibliotecas de C, macros, bibliotecas propias, variables globales, declaraciones de funciones, `main`, definiciones de funciones |
| LEA-10 | Tipos de ancho fijo (`uint8_t`, `int16_t`…); `unsigned` por defecto, con signo sólo si el dato puede ser negativo |
| LEA-11 | Todo bucle de espera tiene una cota fija: termina aunque el hardware no conteste |
| LEA-12 | Los bits se manejan con los operadores de bit (máscaras, `\|=`, `&= ~`, `^`, `<<`, `>>`) |
| LEA-13 | Lo que se repite va en una función; lo configurable, en macros con nombre |
| LEA-14 | Una máquina de estados es un `enum` y un `switch`, con un `default` que lleva a falla |
| LEA-15 | Nada bloqueante en el superloop |
| LEA-16 | Sin `malloc`; `volatile` para lo que cambia fuera del flujo del programa |
| LEA-17 | Los ejemplos se ambientan en un OBC (computadora de a bordo) |

Los ids que faltan (02, 03, 05 a 09, 18) no entran en este resumen: el
registro privado los tiene.

**Regla propia del apunte, no de la cátedra:** los ejemplos no resuelven los
prácticos. Mismo OBC imaginario, otros casos y otros números.
