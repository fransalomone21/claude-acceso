# HANDOFF — Software de Vuelo

## 2026-10-02 (nube, 10.ª) — apunte de C v1.0 terminado: lo que falta es de la PC

**El apunte de C tiene los 12 módulos** (v1.0, 82 págs., 49 programas). En la
nube no hay nada más para escribir sin material nuevo. **En la PC, en orden:**

1. `git pull`; en `apunte-c/`: `typst compile --root .. apunte.typ apunte.pdf`,
   `python verificar-ejemplos.py` (49 en verde), `python
   probar-verificar-ejemplos.py` (TODO BIEN, 8 sabotajes), `python
   revisar-pdf.py` y `python revisar-pdf.py --probar` (necesita `pip install
   pymupdf`). Si el verificador da rojo en WSL y verde en la nube, es el gcc:
   comparar `gcc --version` (la nube usó 13.3 de Ubuntu 24.04).
2. `.\publicar-apuntes.ps1` y `.\publicar-apuntes.ps1 -Verificar`: **cierra la
   fase 1** del PDP (lo único que falta).
3. **Cotejar con el material de la cátedra** (no se pudo en la nube): que
   ningún ejemplo resuelva el Práctico 1 (ej. 2 y 4 a 9), el Práctico 2 ej. 1
   ni el Práctico 3 (ej. 3 y 4). Si alguno coincide, se cambia el ejemplo
   (mismo OBC, otro caso).
4. **Medir en la placa o en el proyecto `tp2`**: `_Min_Stack_Size` del `.ld`
   (el módulo 6 dice «suele ser `0x400`»); que leer `*NULL` dé el principio de
   la flash (módulo 8, sin número); la *Build Analyzer* (módulo 12).
5. **Contra `catedras`:** el resumen `docs/CRITERIOS-LEANDRO.md` (que no
   contradiga el registro textual) y si la cátedra dice dónde van los tipos en
   `template.c` (el apunte usa `/* Types */`).
6. Registrar con `aprender.py` las **3 lecciones** de los bloques «LECCIONES
   PARA aprender.py» de este HANDOFF (2.ª, 5.ª y 7.ª sesión de hoy) y borrar
   esos bloques.

**Herramientas que sumó esta tanda:** `revisar-pdf.py` (+ `--probar`), el
verificador con proyectos, `#proyecto` y `#codigo(..., entrada: true)` en la
plantilla, y el corte en dos de los ejemplos largos.

**Si se sigue en la nube:** la guía de IDEs (fase 2) necesita la placa; lo que
queda posible sin placa es una revisión de lectura completa del apunte v1.0
(coherencia entre módulos, remisiones «el módulo N» que apunten bien).

## 2026-10-02 (nube, 9.ª) — apunte de C v0.10: sigue el módulo 12, el último

**Lo primero, en la PC:** `git pull`, recompilar, verificador (46 en verde) y
`probar-verificar-ejemplos.py` (8 sabotajes), `revisar-pdf.py`,
`.\publicar-apuntes.ps1` (v0.2 a v0.10 sin publicar). Pendientes acumulados de
medir en la PC: sin cambios respecto del bloque de la 8.ª.

**Después: el módulo 12, memoria y C de vuelo** (stack, `.data`/`.bss`, por
qué no `malloc`, `volatile` en profundidad, registros mapeados, secciones
críticas, MISRA-C, programación defensiva; clase 86-99, 134-140, 149-157).
Herramienta para medir en la nube: `arm-none-eabi-gcc` + `arm-none-eabi-size`
(`apt-get install gcc-arm-none-eabi`) para mostrar en qué sección cae cada
variable (`const` global → `.rodata`/flash; inicializada → `.data`, que ocupa
flash **y** RAM; en cero → `.bss`). Es medición con `-c` (sin linkear, no hace
falta el `.ld`). El módulo 12 cierra las promesas: la sección crítica del
`contador++` (módulos 3 y 10), `volatile` en profundidad (3), MISRA (3 y
siguientes), el stack (6).

**Cómo citar un proyecto:** `#proyecto("<nombre>", archivos: ("a.h", "a.c",
"main.c"), salida: true, titulo: "...")`; los archivos del proyecto llevan las
secciones de `template.c`.

## 2026-10-02 (nube, 8.ª) — apunte de C v0.9: sigue el módulo 11

**Lo primero, en la PC:** `git pull`, recompilar, verificador (43 en verde),
`python apunte-c\revisar-pdf.py`, `.\publicar-apuntes.ps1` (v0.2 a v0.9 sin
publicar). Pendientes de medir en la PC (acumulados): prácticos contra
ejemplos; `_Min_Stack_Size` del `.ld`; `*NULL` en la placa; dónde van los
tipos según `catedras`.

**Después: el módulo 11, preprocesador y proyecto** (`#include`, guardas,
compilación condicional, `.h` y `.c`, bibliotecas; clase 126-133, 144-146).
**Problema de forma a resolver primero:** el verificador compila un `.c`
suelto (`gcc ... nombre.c`). Un ejemplo de varios archivos necesita otra
cosa: propuesta, una carpeta `ejemplos/m11-proyecto/` con `.h` y `.c`, y que
`verificar-ejemplos.py` compile todos los `.c` de la carpeta juntos (con su
saboteador nuevo en `probar-verificar-ejemplos.py`). Y `#codigo` muestra un
solo archivo: hace falta un `#codigo("m11-proyecto/sensor.h")` o similar.
Medir antes: las macros con parámetros (la promesa del módulo 3: «piden más
todavía»), `#if`/`#ifdef` para el modo de prueba, `#error`, guardas
`#ifndef X_H`.

**En la nube conviene instalar** `gcc-arm-none-eabi` al arrancar (lo usa el
módulo 12 para medir `.data`/`.bss` con `arm-none-eabi-size`).

## 2026-10-02 (nube, 7.ª) — apunte de C v0.8: sigue el módulo 10

**Lo primero, en la PC:** `git pull`, recompilar, verificador (39 en verde),
`.\publicar-apuntes.ps1` (v0.2 a v0.8 sin publicar). Pendientes de medir en la
PC, acumulados: Práctico 1 ej. 2 y 4 a 9, Práctico 3 ej. 3 y 4 contra los
ejemplos; `_Min_Stack_Size` del `.ld`; `*NULL` en la placa; si `catedras` dice
dónde van los tipos en `template.c` (el apunte usa `/* Types */`).

**Después: el módulo 10, tipos compuestos** (`struct`, `->`, *padding*,
`union`, *endianness*, campos de bits, mapear un registro; clase 112-125; sin
práctico). Ideas del mismo OBC: un `struct` de telemetría de housekeeping;
medir el *padding* con `sizeof` y `offsetof` (determinístico en la PC: x86-64
y Cortex-M4 alinean igual los tipos de hasta 4 bytes, pero **medirlo**, no
suponerlo); `union` para ver los bytes de un `uint32_t` y la *endianness*
(los dos son *little endian*; la cabecera CCSDS del módulo 4 viaja *big
endian*); campos de bits y por qué MISRA desconfía (el orden lo decide el
compilador); mapear un registro con un `struct` como hace la HAL
(`GPIOA->ODR`), sin poder correrlo en la PC: un `struct` apuntado a una
variable que hace de periférico.

**Verificación nueva, después de compilar:** `python revisar-pdf.py` (ningún
bloque se sale por abajo de la página) y, si se toca la plantilla, `python
revisar-pdf.py --probar`. Un ejemplo de más de 55 líneas lo parte la
plantilla en dos bloques: no hace falta achicarlo, pero si se puede, mejor.
Y el escáner de trampas de Typst que uso antes
de compilar (renglón que empieza con «número y punto», `+`, `/ `; comilla
invertida impar; `~ < > @ \` fuera de código) está en el HANDOFF de la 3.ª
sesión como receta: conviene hacerlo script (`apunte-c/revisar-typ.py`) en la
PC, con su saboteador, y sumarlo al verificador.

## 2026-10-02 (nube, 6.ª) — apunte de C v0.7: sigue el módulo 9

**Lo primero, en la PC:** `git pull`, recompilar, verificador (37 en verde),
`.\publicar-apuntes.ps1` (v0.2 a v0.7 sin publicar). Lo pendiente de medir en
la PC suma uno: con la NUCLEO enchufada, leer `*(volatile uint32_t *)0` en el
depurador y ver que da el primer valor de la tabla de vectores (el módulo 8 lo
afirma sin número).

**Después: el módulo 9, máquinas de estados** (`enum` + `switch`, `default`
defensivo, transición por evento y no por tiempo, el superloop no bloqueante
con `HAL_GetTick()`; clase 100; Práctico 1 ej. 7; Práctico 3 ej. 4). En la PC
no hay `HAL_GetTick()`: simularlo con un contador de milisegundos que el
superloop avanza a mano (determinístico, para que la salida sea igual en cada
corrida). **No** escribir la máquina del Práctico 3 ej. 4 (no se pudo leer en
la nube: elegir una del OBC que no sea de LEDs ni de botones, por ejemplo los
modos de la misión: arranque → detumbling → nominal → seguro). LEA-14 (enum +
switch con `default` a falla) y LEA-15 (nada bloqueante) van en cajas
`#catedra`. Lo que el módulo 5 prometió: «el `switch` vuelve como corazón de
las máquinas de estados»; lo que prometió el 5 sobre la UART: «se lee si hay
algo, y si no, el superloop sigue» (no hay UART en la PC: alcanza con decirlo).

## 2026-10-02 (nube, 5.ª) — apunte de C v0.6: sigue el módulo 8

**Lo primero, en la PC de Fran:** `git pull`, recompilar, `python
apunte-c\verificar-ejemplos.py` (32 en verde), `.\publicar-apuntes.ps1` (la
v0.2 a la v0.6 no están en el Drive). Lo que la nube no pudo medir sigue igual
(Práctico 1 ej. 2 y 4 a 9; `_Min_Stack_Size` del `.ld` del `tp2`).

**Corrección al bloque de la 4.ª sesión:** decía que `-Warray-bounds` avisa
un índice constante fuera de rango «con optimización». **Medido: no avisa**
(`m[8] = 3u` en un vector de 8, ni con `-O0` ni con `-O2`). El módulo 7 dice
lo medido.

**Después: el módulo 8, punteros** (dirección y `&`, `*`, `NULL`, aritmética,
puntero y nombre de array, puntero a puntero, punteros a función y *dispatch
table*; clase 57-72, 83-85, 108-111; Práctico 1 ej. 9). Tiene que **cerrar**
lo adelantado: la receta `*`/`&` del módulo 6, el `&` de `scanf` (5), el
vector que llega como puntero (7), el `const char *` (4 y 7), el `const
volatile uint32_t *` del registro del ADC (3). La *dispatch table* puede
reescribir el despachador de telecomandos de `m05-comandos` con una tabla de
punteros a función: es el mismo OBC y no es un práctico. Imprimir direcciones
con `%p` cambia en cada corrida (ASLR): el verificador compara la salida
**igual**, así que no se imprimen direcciones; se imprimen diferencias o
comparaciones.

**Regla de forma nueva:** las líneas de código de un ejemplo, con tabulador
de 2, no pasan de 92 columnas (más largas se parten en el PDF). Se mide con
`expand -t2 ejemplos/X.c | awk 'length > 92'`.

### LECCIONES PARA aprender.py (las registra la PC)

- **Título:** el render se mira entero, o lo mide un script; nunca por
  muestreo. **Síntoma:** en el módulo 9 se miraron las páginas 56, 59, 61 y
  62, se escribió «render mirado» en el ESTADO y se commiteó; la 58 tenía el
  `switch` de `m09-modos` saliéndose por abajo de la hoja, pisando el número
  de página. Se vio recién al contar líneas por otra razón. **Regla:** para
  dar por mirado un render, o se miran todas las páginas del módulo, o corre
  un medidor sobre todas (acá, `revisar-pdf.py`), y el ESTADO dice cuál de
  las dos. **Opuesto:** mirar las páginas «con riesgo» y suponer las demás.

- **Título:** en un HANDOFF, lo que no se midió va como pregunta, no con la
  respuesta puesta. **Síntoma:** el bloque de la 4.ª sesión listaba «trampas
  a medir» y, entre paréntesis, adelantaba el resultado (`-Warray-bounds`
  avisa con optimización). La 5.ª sesión lo midió y era falso; si lo hubiera
  copiado al apunte sin medir, el apunte publicaba un dato falso con cara de
  medido. **Regla:** en el HANDOFF, «a medir: X» sin resultado; el resultado
  se escribe recién con la medición, y con la marca «medido». **Opuesto:**
  escribir lo que uno espera que dé el compilador como si ya lo hubiera dado.

## 2026-10-02 (nube, 4.ª) — apunte de C v0.5: sigue el módulo 7

**Lo primero, en la PC de Fran:** `git pull`, recompilar, `python
apunte-c\verificar-ejemplos.py` (27 en verde), `.\publicar-apuntes.ps1` (la
v0.2 a la v0.5 no están en el Drive). Dos cosas que la nube no pudo medir:
**(1)** cotejar el Práctico 1 ej. 4 a 9 contra los ejemplos `m04-*`, `m05-*` y
`m06-*`; **(2)** abrir el `.ld` del `tp2` y confirmar `_Min_Stack_Size`: el
módulo 6 dice que «suele ser `0x400`». Si es otro, se corrige ese renglón.

**Después: el módulo 7, vectores y cadenas** (arrays de una y dos
dimensiones, recorrerlos, tablas de patrones, cadenas y el `'\0'`; clase
73-82 y 101; Práctico 1 ej. 2; Práctico 3 ej. 3). **No** escribir la tabla de
patrones de un display de 7 segmentos: es el Práctico 3 ej. 3. Otra tabla de
patrones del mismo OBC (p. ej., la secuencia de un LED de estado o una tabla
de calibración). Trampas a medir: índice fuera de rango (gcc avisa sólo si es
constante: `-Warray-bounds` necesita optimización), `sizeof` de un vector
pasado a una función (avisa `-Wsizeof-array-argument`), cadena sin lugar para
el `'\0'`.

**Usos adelantados que el 7 tiene que cerrar:** el `const char *` de
`imprimir_bits` (m04) y el `%s`.

## 2026-10-02 (nube, 3.ª) — apunte de C v0.4: sigue el módulo 6

**Lo primero, en la PC de Fran:** `git pull`, recompilar, `python
apunte-c\verificar-ejemplos.py` (23 en verde) y `.\publicar-apuntes.ps1` (ni
la v0.2, ni la v0.3, ni la v0.4 están en el Drive). Y **cotejar con el material
de la PC** que ningún ejemplo de los módulos 4 y 5 resuelva el Práctico 1 ej.
4, 5, 6 o 7: en la nube no se pudo leer.

**Después: el módulo 6, funciones** (declarar y definir como pide
`template.c`, retorno, por valor y por referencia, recursión y por qué no en
vuelo; clase 102-107; Práctico 1 ej. 8 y 9; Práctico 3 ej. 3,
`mostrar_digito`: **no** escribir un `mostrar_digito` ni un display de 7
segmentos). Desde el módulo 3 los ejemplos ya usan funciones `static`
declaradas arriba y definidas abajo: el 6 lo formaliza. Por referencia
necesita `&` y `*`, que son del 8: mostrarlo como receta («el `*` en el
parámetro y el `&` en la llamada») y remitir al 8.

**Cómo se usa la entrada nueva:** un ejemplo con `scanf` lleva
`ejemplos/<nombre>.entrada` y se cita con `#codigo("<nombre>", salida: true,
entrada: true)`.

## 2026-10-02 (nube, 2.ª) — apunte de C v0.3: sigue el módulo 5

**Lo primero, en la PC de Fran:** `git pull`, recompilar
(`typst compile --root .. apunte.typ apunte.pdf` en `apunte-c/`),
`python apunte-c\verificar-ejemplos.py` (17 en verde) y
`.\publicar-apuntes.ps1`: ni la v0.2 ni la v0.3 están en el Drive. Y una
comparación que la nube no pudo hacer: abrir el **Práctico 1, ej. 4** y
confirmar que ningún ejemplo del módulo 4 (`m04-*.c`) lo resuelve.

**Después: el módulo 5, control de flujo** (`if`/`else if`, *dangling else*,
`switch`, `while` con cota, `do-while`, `for`, `scanf`; clase 31-55; Práctico
1 ej. 5, 6 y 7). El 4 ya usó un `for` (en `imprimir_bits`) y un `while` con
cota está en el 3: el 5 los formaliza. Un ejemplo con `scanf` necesita
`ejemplos/<nombre>.entrada` (el verificador lo pasa como stdin). Trampa
medida que le toca al 5: `for (uint8_t i = 7u; i >= 0u; i--)` nunca termina, y
gcc avisa con `-Wextra` (`-Wtype-limits`).

**Criterios en la nube:** ahora están en `docs/CRITERIOS-LEANDRO.md` (resumen
público y fechado, decisión de Fran del 2026-10-02). Ya no hace falta pegarlos
en el pedido.

**Trampas nuevas de Typst:** un código en línea (entre comillas invertidas)
**no se corta entre renglones**: si no entra, se pasa entero al renglón
siguiente (y si el corte deja un `+` al principio del renglón, abre lista
numerada). Un mensaje de gcc largo va en cursiva (`_..._`), que sí se corta.
Una tabla larga que queda partida entre páginas se envuelve en
`#block(breakable: false)[...]`.

### LECCIONES PARA aprender.py (las registra la PC)

- **Título:** el esqueleto de `template.c` se copia, no se recuerda.
  **Síntoma:** `m04-banderas.c` salió con `/* Function declarations */` y
  `/* Function definitions */`, y compilaba y daba verde: el verificador no
  mira comentarios. Se vio recién al leer `m01-template.c` para otra cosa; el
  `template.c` dice `/* Functions declaration */` y `/* Functions definition */`.
  **Regla:** antes de escribir un ejemplo con secciones nuevas, abrir
  `m01-template.c` y copiar los encabezados tal cual. **Opuesto:** escribir los
  encabezados de memoria porque «son comentarios».

## 2026-10-02 (nube) — apunte de C v0.2: sigue el módulo 4

**Lo primero, en la PC de Fran:** `git pull`, recompilar
(`typst compile --root .. apunte.typ apunte.pdf` en `apunte-c/`) y
`.\publicar-apuntes.ps1`: la v0.2 (módulos 1 a 3) **no está en el Drive** (la
nube no tiene rclone). Correr también `python apunte-c\verificar-ejemplos.py`
para confirmar el verde en WSL.

**Después: el módulo 4, operadores y los de bit** (aritméticos, compuestos,
relacionales, lógicos, ternario; máscaras, `|=`, `&= ~`, `^`, `<<`, `>>`,
imprimir en binario; clase 17-19 y 29-30; Práctico 1 ej. 4, Práctico 2 ej. 1).
El módulo 3 ya adelantó que la comparación vale 0/1 y que el hexa es para
máscaras: el 4 arranca desde ahí.

**Trampa nueva de Typst:** un renglón del `.typ` que **empieza** con «número y
punto» (`8. Por ahora...`, porque el corte cayó en «módulo 8.») abre una lista
numerada. Al cortar, que el número quede pegado a su palabra.

**En la nube (Linux):** `verificar-ejemplos.py` ya corre sin WSL; typst 0.15
se baja de GitHub releases (`typst-x86_64-unknown-linux-musl.tar.xz`); para el
render, `pip install pymupdf`. Las fuentes de *fallback* (Consolas, Georgia)
avisan que faltan, pero las principales vienen embebidas en typst.

## 2026-10-02 — apunte de C v0.1: sigue el módulo 3

**Arrancá por acá:** `cd apunte-c; python verificar-ejemplos.py` (tiene que dar
verde) y después el **módulo 3, constantes y calificadores** (`#define`,
`const`, `volatile`, `static`; clase diap. 15 y 28; Práctico 1 ej. 2 y 3). El
orden de los 12 está en `docs/ALCANCE.md`.

**Cómo se escribe un módulo** (no cambiar sin motivo): el programa va en
`apunte-c/ejemplos/mNN-nombre.c`, completo; en el módulo, `#codigo("mNN-nombre",
salida: true)`; después `python verificar-ejemplos.py --regenerar` (escribe el
`.salida` de la corrida real) y `python verificar-ejemplos.py` sin flag. Un
ejemplo que existe para mostrar un warning lleva `// ESPERA-WARNING: <flag>` en
la **última** línea y se muestra con `#aviso("...")`. Compilar con
`typst compile --root .. apunte.typ apunte.pdf` (el `--root` hace falta: la
plantilla sale de `../guia-ides/`). Al terminar, mirar el render.

**Trampas pagadas hoy:** `*mili*ampere` (asterisco pegado a letras) no
compila en Typst: `#strong[mili]ampere`. Identificadores con `_` van siempre
entre comillas invertidas, o abren cursiva. Un `#codigo("...")` en un
comentario del `.typ` cuenta como cita para el verificador. Los ejemplos
**no resuelven los prácticos**: mismo OBC, otros casos y otros números.

**Voz:** criollo, sarcástico e integrado en la prosa (pedido de Fran del
2026-10-02, «nuestra esencia»); el humor nunca adentro de una línea de código
ni rompiendo una cuenta.

## 2026-09-29 (04:50) — TP2 hecho y empaquetado; carpeta del Cohete compartida

**TP2:** `workspace_1.18.1\tp2` completo. PB5 y ADC1 IN0 se agregaron al `.ioc`
y el código se regeneró **sin abrir CubeIDE**, con el motor de CubeMX que trae
adentro (`java -jar ...\com.st.stm32cube.common.mx_*\STM32CubeMX.jar -q
script`, con `config load` + `project generate`). La compilación también fue
sin GUI (`stm32cubeidec.exe ... headlessbuild -cleanBuild tp2/Debug`):
**0 errores, 0 advertencias**. El código va en los bloques USER CODE, con
comentarios cortos en criollo. `diagram.json` verificado **pin por pin** contra
`wokwi-boards/boards/st-nucleo-c031c6/board.json`, con saboteador en rojo: `PB0`
y `3V3` **no existen** en esa placa, son `PB0.1` y `3V3.1`. **Sin simular**: lo
abre Fran. La entrega está en `Desktop\01 - UNSAM\Software de Vuelo\TP2_Salomone.zip`
(proyecto + `.elf` + `diagram.json` + `wokwi.toml`). Hay un respaldo del tp2
anterior en el scratchpad de la sesión.

**Cohete:** la carpeta de Drive está compartida como `writer` con los dos
compañeros, renombrada con los apellidos y declarada por hash en
`.claude/estructura-drive.json` (`verificar-drive` en verde). El análisis
contra los criterios de Petrilli y la predicción de qué no le gustó de la
presentación están en el repo privado:
`catedras/software-de-vuelo/COHETE-ANALISIS.md`.

## 2026-09-29 (03:00) — circuito del TP2 armado; mañana, el código

`tp2\diagram.json` escrito con los dos ejercicios del TP2 (PB0–PB3 contador, PB5
alarma, potenciómetro en PA0, monitor serie en PA2/PA3); JSON válido, **sin
simular todavía**. `3V3` como nombre de pin es `hipótesis`. **El editor visual de
Wokwi en VS Code es pago** (Community: «Upgrade to Edit Diagram»); las dos guías
lo dicen. **Mañana Fran sigue con `Core/Src/main.c`**: el `.ioc` tiene que tener
PB0–PB3 y PB5 en `GPIO_Output` y `ADC1 → IN0`.

## 2026-09-29 (02:40) — el doc del grupo, leído

`Downloads\Sistema cohete de agua.pdf` (9 pág.): **no tiene mails** (0, medido) y
la **sección 7, «Máquina de estados», está vacía**. La nuestra quedó alineada con
sus fases (Tierra, Ascenso, Apogeo, Descenso, Aterrizaje; ≤ 250 m el principal) y
sin las balizas, que el doc no pide. Errores encontrados en el doc, para Fran: el
índice no coincide con el cuerpo; «BPM280» (es BMP280); «6. 2.6.1 Operaciones»
sobrante en el ConOps; REQ-L0-4 con el rationale cortado; REQ-L0-6 sin rationale;
L1 vacío y con REQ-L1-01 repetido; «controlador» y «demostrador» tecnológico
mezclados en 2.7. **Los mails siguen sin aparecer.**

## 2026-09-29 (02:10) — guía pública v0.4 (Wokwi paso a paso)

Ampliada la sección de Wokwi (dónde van los archivos, tres formas de editarlos, correr y reiniciar) y agregado el cartel Board Project Options. Publicada por el hook post-commit. **La guía personal sigue en v0.3**: falta pasarle lo mismo. Máquina de estados del Cohete en `01 - UNSAM\Software de Vuelo\TP Cohete de Agua (Petrilli)\maquina-de-estados\` (PNG + .drawio editable + generar.py). El doc del grupo está en OneDrive y **no se pudo leer** (Word Online no expone el texto): hace falta una copia .docx para ver si ya trae máquina de estados y los mails.

## 2026-09-29 (01:20) — guía de IDEs publicada; el TP Cohete salió de lo público

**Hecho:** guía de IDEs v0.3 publicada y verificada por MD5; el hook
`post-commit` la republica sola en cada commit que toque su PDF. El informe del
TP Cohete salió de la carpeta pública `TDC` a una carpeta de GRUPOS privada
(detalle en `ESTADO_ACTUAL.md`).

**Búsqueda de los autores del Cohete (01:40), para retomar mañana con Fran.**
Fran cree que los mails están en «el doc inicial» del grupo y dice que se va
a trabajar sobre ese, no sobre los generados. **No apareció:**
- Drive (búsqueda de texto completo, incluidos los compartidos conmigo desde
  el 15/08): con «cohete», «apogeo», «BMP280», «paracaídas», «Petrilli» y
  «ESP32» sale sólo nuestro .docx y, además, un dibujo **«Esquema ESP32»
  de Santiago** (el del grupo de TdC), creado el 15/09 a las 03:39. Es
  del Cohete, así que Santiago es integrante `probable`. Ese dibujo es de él y
  está **público por link**; no es nuestro y no se tocó.
- Las sesiones de Claude: el informe se armó el 15/09 (`ddd5e1a3`) **a partir
  de lo que Fran dictó**, sin ningún doc adjunto ni link. Tampoco aparece en
  `Classroom` ni en `SOLO FRAN`, ni en `Downloads`.
- Hipótesis: el doc inicial es de otro integrante y a Fran le llegó por link
  (un doc abierto sólo por link no figura en «compartidos conmigo»). Pedirle
  el link a Fran.

**CubeIDE, para la v0.4 de la guía:** al crear el proyecto de la C031C6, después
del Finish aparece **«Board Project Options»**: elegir los componentes BSP (LED
verde LD4, botón de usuario, Virtual Com Port, los tres tildados por defecto) y
«Generate demonstration code» sin tildar. Se deja así y OK. El Virtual Com
Port es lo que genera `BSP_COM_Init`. La guía v0.3 no lo menciona (Fran lo vio
el 29/09 al crear `tp2`).

**Lo que sigue, en orden:**
1. **Compartir la carpeta del TP Cohete con los autores**, cuando Fran diga
   quiénes son o pase el link del doc inicial (el .docx nuestro no tiene mails:
   medido). Y abrir el Cohete como proyecto **privado** aparte (regla 2 del
   contrato), no acá. Al compartir, declararla en
   `.claude/estructura-drive.json` → `compartido-con-nombre`, **por hash del
   mail** (nunca el mail: el repo es público), y renombrar la carpeta con los
   apellidos, como la de Teoría de Circuitos.
2. Con lo que Fran cuente del TP2, corregir y subir a v0.4 las dos versiones.
   Commitear el PDF público alcanza: el hook lo sube.
3. La guía de C, cuando Fran la pida (la dejó para después el 29/09).

## 2026-09-29 (madrugada) — la guía de IDEs v0.3, adelantada para el TP2

**Hecho:** guía pública (`guia-ides/`, 6 pág., sin publicar) y guía personal
(`catedras/software-de-vuelo/personal/`, PDF en la carpeta local de la
materia). Detalle en `ESTADO_ACTUAL.md`.

**Lo que sigue, en orden:**
1. **Preguntarle a Fran si se publica la pública** en el Drive de apuntes. Si
   dice que sí: declararla en `.claude/apuntes-publicos.json` (materia
   «Software de Vuelo», `local` = `proyectos/documentos/software-de-vuelo/guia-ides/guia-ides.pdf`)
   y `.\publicar-apuntes.ps1`. **Ojo:** el detector de «sin declarar» busca
   sólo archivos llamados `apunte.pdf`, así que esta guía **no aparece** en
   rojo si nadie la declara — no esperar que el arranque lo recuerde.
2. Con lo que Fran cuente del TP2 (si el script, el simulador o IntelliSense
   fallaron), corregir y subir a v0.4. Es la validación real de la guía.
3. La fase 0 sigue igual: criterios de Leandro en `catedras`, y
   `docs/ALCANCE.md`.

**Trampas de esta sesión:** en PowerShell, `"...$placa: ..."` no compila (la
variable seguida de `:` es un calificador; va `${placa}`). En Typst, un bloque
de código en medio de una lista numerada la corta y reinicia la numeración: se
indenta dentro del ítem. Y un `raw` largo sin espacios (una ruta de WSL) se
sale de la celda de una tabla.

## 2026-09-29 — primera sesión

**Lo que sigue:** la fase 0 de este proyecto espera a la fase 0 de
`catedras` (los criterios de Leandro). Orden:

1. En `catedras`: leer la presentación del 18/08 y los prácticos 1 a 3 y
   registrar `LEA-R1` a `LEA-R4` con sus criterios (ver su `HANDOFF.md`).
2. Acá: `docs/ALCANCE.md`, cada tema de las dos guías con la clase o el
   práctico que lo pide.

**No hacer:** abrir el TP Cohete acá (regla 2), ni publicar nada que no sea
una de las dos guías.
