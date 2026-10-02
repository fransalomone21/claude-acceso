# Alcance de las dos guías — cada tema, con la clase o el práctico que lo pide

Escrito el 2026-10-02, leyendo el material de Leandro (registro `LEA-R1` a
`LEA-R4` en el repo privado `catedras`). **El orden del apunte de C es el de
la clase de Leandro** (`Programacion_en_C_Embebido.pdf`, 157 diapositivas),
que es el método de la cátedra; lo que se agrega va marcado como mejora.

Fuentes, abreviadas: **Clase** = la de C embebido (número de diapositiva);
**Práctico 1** = «Práctico de Programación en C» (C sobre Ubuntu);
**Práctico 2** = TP2, GPIO y ADC en Wokwi; **Práctico 3** = primer contacto
con la NUCLEO-F446RE.

## Apunte de C

| # | Módulo | Lo que cubre | Lo pide |
|---|---|---|---|
| 1 | **El programa mínimo** | `template.c` y sus secciones, `main`, el superloop, compilar con `gcc -Wall -Wextra -std=c11`, leer un warning | Clase 7, 10; Práctico 1 (instrucciones generales) |
| 2 | **Variables y tipos** | declarar, inicializar, tipos de ancho fijo, `signed`/`unsigned`, rango y desborde, `sizeof`, `printf` con el especificador correcto, conversión de unidades | Clase 16, 21-27; Práctico 1 (ej. 1) |
| 3 | **Constantes y calificadores** | `#define`, `const`, `volatile`, `static` (local y global), la comparación como valor 0/1 | Clase 15, 28; Práctico 1 (ej. 2 y 3) |
| 4 | **Operadores, y los de bit** | aritméticos, compuestos, relacionales, lógicos, ternario; máscaras, `|=`, `&= ~`, `^`, `<<`, `>>`, imprimir en binario | Clase 17-19, 29-30; Práctico 1 (ej. 4); Práctico 2 (ej. 1) |
| 5 | **Control de flujo** | `if`/`else if`, *dangling else*, `switch`, `while` **con cota**, `do-while`, `for`, `scanf` | Clase 31-55; Práctico 1 (ej. 5, 6 y 7) |
| 6 | **Funciones** | declarar y definir (como pide `template.c`), retorno, por valor y por referencia, recursión (y por qué no en vuelo) | Clase 102-107; Práctico 1 (ej. 8 y 9); Práctico 3 (ej. 3, `mostrar_digito`) |
| 7 | **Vectores y cadenas** | arrays de una y dos dimensiones, recorrerlos, tablas de patrones, cadenas y el `'\0'` | Clase 73-82, 101; Práctico 1 (ej. 2); Práctico 3 (ej. 3) |
| 8 | **Punteros** | dirección y `&`, `*`, `NULL`, aritmética, puntero y nombre de array, puntero a puntero, punteros a función y *dispatch table* | Clase 57-72, 83-85, 108-111; Práctico 1 (ej. 9) |
| 9 | **Máquinas de estados** | `enum` + `switch`, `default` defensivo, transición por evento y no por tiempo, el superloop no bloqueante con `HAL_GetTick()` | Clase 100; Práctico 1 (ej. 7); Práctico 3 (ej. 4) |
| 10 | **Tipos compuestos** | `struct`, `->`, *padding*, `union`, *endianness*, campos de bits, mapear un registro | Clase 112-125 |
| 11 | **Preprocesador y proyecto** | `#include`, guardas, compilación condicional, `.h` y `.c`, bibliotecas | Clase 126-133, 144-146 |
| 12 | **Memoria y C de vuelo** | stack, `.data`/`.bss`, por qué no `malloc`, `volatile` en profundidad, registros mapeados, secciones críticas, MISRA-C, programación defensiva | Clase 86-99, 134-140, 149-157 |

**Cada práctico aparece:** Práctico 1 (módulos 1 a 9), Práctico 2 (4),
Práctico 3 (6, 7, 9).

**Afuera, a propósito:** E/S de archivos (clase 135-136: en un
microcontrolador sin sistema de archivos no aplica), GDB por JTAG en el
TMS570 (clase 143: no hay TMS570 en el kit de Fran), y la HAL de STM32
(es la guía de IDEs, no este apunte).

## Guía de IDEs

Ya existe (v0.4, publicada). Su alcance está en `guia-ides/guia-ides.typ`; lo
que le falta es el flujo probado sobre la NUCLEO-F446RE real (Práctico 3).
