# Estado actual — Software de Vuelo (guías de C y de IDEs)

## 2026-10-02 (nube, 8.ª) — apunte de C v0.9: módulo 10, tipos compuestos

- **Módulo 10** (`apunte-c/modulos/m10-tipos-compuestos.typ`): `struct` con
  `typedef`, inicializadores designados, `.` y `->`, pasar por puntero
  `const`, asignar copia; relleno (*padding*) con `offsetof` (12 contra 8
  bytes según el orden); el `enum` que ocupa 4 en la PC y 1 en la placa;
  `union` para ver la *endianness* y corrimientos para armar la trama *big
  endian*; campos de bits y por qué no para registros; mapear el GPIOC con un
  `struct` `volatile` (offsets del manual: ODR +0x14, BSRR +0x18) y `BSRR`
  contra el `|=`. MISRA 19.2 y 6.1. **4 programas nuevos** (`m10-housekeeping`,
  `m10-padding`, `m10-endian`, `m10-registro`): en total **43**, verificador
  en verde, `probar-verificar-ejemplos.py` TODO BIEN, `revisar-pdf.py` verde.
  Render mirado **entero** (págs. 62 a 68; el PDF tiene 68). Carátula:
  «v0.9 — módulos 1 a 10 de 12».
- **Nuevo en la nube: `arm-none-eabi-gcc` 13.2** (se instala con
  `apt-get install gcc-arm-none-eabi`, ~1 min). Lo que era supuesto ahora es
  medido para el Cortex-M4 (`-mcpu=cortex-m4 -mthumb`, sin optimizar):
  punteros de 4 bytes; `enum` de **1 byte** (`-fshort-enums` viene prendido);
  `struct` de enteros, mismo tamaño y offsets que en la PC; campos de bits,
  mismo orden (`0x2D`); `unos_recursivo` del módulo 6 usa **32 bytes** por
  llamada (33 anidadas = 1056 bytes). Los módulos 6, 7 y 8 se corrigieron con
  esos números. Los cuatro ejemplos del 10 compilan con cero warnings también
  en ARM.
- **Medido en gcc 13.3:** inicialización por posición incompleta avisa
  `-Wmissing-field-initializers` (`-Wextra`); con `.campo =` no; `-Wpadded`
  avisa cada relleno.

## 2026-10-02 (nube, 7.ª) — apunte de C v0.8: módulo 9, máquinas de estados

- **Módulo 9** (`apunte-c/modulos/m09-maquinas-estados.typ`): la tabla de
  transiciones antes que el código; `enum` y `typedef`; `transicion()` que
  sólo decide (modos de la misión: arranque → detumbling → nominal ↔ seguro,
  y falla); `default` a falla ante un modo corrupto; el costo escondido del
  `default` (apaga `-Wswitch`) y la mejora `-Wswitch-enum`; por evento y no
  por tiempo (el tiempo como un evento más); superloop no bloqueante con
  `HAL_GetTick()` simulado y la vuelta de los 49,7 días: `(ahora - ultimo) >=
  PERIODO` aguanta, `ahora >= ultimo + PERIODO` conmuta **505 veces en vez de
  5** (medido por el propio ejemplo). LEA-14 y LEA-15 en cajas. **2 programas
  nuevos** (`m09-modos`, `m09-superloop`): en total **39**, verificador en
  verde, `probar-verificar-ejemplos.py` TODO BIEN. Render mirado (págs. 56 a
  62; el PDF tiene 62). Carátula: «v0.8 — módulos 1 a 9 de 12».
- **Sección `/* Types */`**: `template.c` no tiene dónde poner tipos; el
  ejemplo la agrega entre macros y globales, y el módulo lo declara en la caja
  «Mejora». Confirmar en la PC si la cátedra dice algo (`catedras`).
- **No resuelve el Práctico 3 ej. 4 ni el Práctico 1 ej. 7** (la máquina es la
  de los modos de la misión, sin LEDs ni botones); los dos sin leer (nube).
- **Medido a mano en gcc 13.3:** `switch` sobre `enum` sin `default` y con un
  valor sin `case` avisa `-Wswitch` (`-Wall`); con `default`, no;
  `-Wswitch-enum` avisa igual; `modo_t x = 9` no avisa; `sizeof(enum)` = 4.
- **Desborde de página, dos veces, arreglado de raíz.** `m09-superloop` (66
  líneas) y `m09-modos` (86) no entraban en una página: un bloque que no se
  parte se sale por abajo, pisa el número de página y Typst no avisa. El
  primero se compactó a 54; el segundo **se declaró «render mirado» sin haber
  mirado su página** (lección en el HANDOFF). Arreglo en tres capas:
  **(1)** `plantilla.typ`: un ejemplo de más de 55 líneas se muestra en dos
  bloques, cortados en el renglón vacío más cercano a la mitad, con el rótulo
  pegado al primero (la plantilla común de `guia-ides` sigue sin partir
  bloques, a propósito); **(2)** `revisar-pdf.py`: mide en **todas** las
  páginas si hay texto a la altura del número de página (verde sobre la v0.8;
  **rojo en la página 58** con la plantilla anterior, control medido);
  **(3)** `revisar-pdf.py --probar`: saboteador que compila 80 líneas sin
  partir y exige rojo, y 20 y exige verde (TODO BIEN). El PDF quedó en 61
  páginas.

## 2026-10-02 (nube, 6.ª) — apunte de C v0.7: módulo 8, punteros

- **Módulo 8** (`apunte-c/modulos/m08-punteros.typ`): `&` y `*`, tamaño del
  puntero (8 en la PC, 4 en la placa), tipos incompatibles; nombre del vector
  como dirección, `*(v + i)`, recorrer con `p++` hasta un `fin`, «sumar 1
  avanza un elemento»; `NULL` como «no hay» (en la placa, `*NULL` no falla:
  la dirección 0 es espejo de la flash); no devolver la dirección de una
  local; `const` a cada lado del `*` (tabla); el `ADC1_SR` del módulo 3 leído
  entero; puntero a puntero como cursor que se mueve desde una función;
  tabla de despacho con punteros a función (reescribe el despachador del
  módulo 5). MISRA 18.4. Cierra las recetas de los módulos 3, 4, 5, 6 y 7.
  **5 programas nuevos** (`m08-direccion`, `m08-recorrer`, `m08-null`,
  `m08-cursor`, `m08-despacho`): en total **37**, verificador en verde,
  `probar-verificar-ejemplos.py` TODO BIEN. Render mirado (págs. 49 a 55; el
  PDF tiene 55). Carátula: «v0.7 — módulos 1 a 8 de 12».
- **Ningún ejemplo imprime direcciones** (`%p` cambia en cada corrida y el
  verificador compara igual): se imprimen comparaciones y diferencias.
- **Medido a mano en gcc 13.3:** puntero sin inicializar avisa
  `-Wuninitialized`; devolver la dirección de una local avisa
  `-Wreturn-local-addr`; `uint16_t *` apuntado a un `uint32_t` avisa
  `-Wincompatible-pointer-types`; perder el `const` avisa
  `-Wdiscarded-qualifiers`; `*NULL` **no avisa** y en la PC da *Segmentation
  fault*.
- **`hipótesis` sin medir, escrita con cuidado:** que en la F446RE leer `*NULL`
  devuelva el principio de la flash (por el *remap* de arranque desde flash,
  manual de referencia de ST). El texto no da un número.

## 2026-10-02 (nube, 5.ª) — apunte de C v0.6: módulo 7, vectores y cadenas

- **Módulo 7** (`apunte-c/modulos/m07-vectores-cadenas.typ`): declarar e
  inicializar, índice desde cero, `<` y el *off-by-one*, `sizeof` total y
  cantidad, índice fuera de rango (C no controla), `= { 0u }`; buffer circular
  con máscara (LEA-16, sin `malloc`); tabla de dos dimensiones (patrón del LED
  de estado por modo, `static const`, fila tras fila); cadenas con `'\0'`,
  `strlen` contra `sizeof`, `char x[5] = "ORBIT"`; `snprintf` mirando lo que
  devuelve; vector como parámetro (se pasa como puntero, `sizeof` se rompe;
  `ESPERA-WARNING: -Wsizeof-array-argument`) y `const` en el parámetro. MISRA
  21.6 mencionada. **5 programas nuevos** (`m07-muestras`, `m07-circular`,
  `m07-patrones`, `m07-cadenas`, `m07-parametro`): en total **32**,
  verificador en verde, `probar-verificar-ejemplos.py` TODO BIEN. Render
  mirado (págs. 42 a 48; el PDF tiene 48). Carátula: «v0.6 — módulos 1 a 7 de 12».
- **No resuelve el Práctico 3 ej. 3**: la tabla de patrones es la del LED de
  estado por modo, no la de un display de 7 segmentos. Práctico 1 ej. 2: sin
  leer (nube), `hipótesis`.
- **Medido a mano en gcc 13.3:** `m[8] = 3u` en un vector de 8 **no avisa**, ni
  con `-O2`; `char x[5] = "ORBIT"` **no avisa**; `snprintf` con todo constante
  que no entra avisa `-Wformat-truncation` (y con `-Werror` corta); `sizeof`
  de un parámetro vector avisa `-Wsizeof-array-argument`.
- Se verificó que ninguna línea de código de los ejemplos pase de 92
  columnas (con tabulador de 2): más larga, se parte en el PDF.

## 2026-10-02 (nube, 4.ª) — apunte de C v0.5: módulo 6, funciones

- **Módulo 6** (`apunte-c/modulos/m06-funciones.typ`): por qué funciones
  (LEA-13), declarar arriba y definir abajo como `template.c`, `return`, el
  *cast* a 32 bits en una conversión del ADC (y por qué en un micro de 16 bits
  importa), `f()` contra `f(void)`, por valor (copia) y por referencia (la
  receta `*`/`&`, remitida al 8), estado por `return` y dato por puntero (como
  `HAL_StatusTypeDef`), `static` en funciones, recursión contra iteración con la
  profundidad medida. MISRA 17.7, 15.5, 17.2. **4 programas nuevos**
  (`m06-adc`, `m06-referencia`, `m06-estado`, `m06-recursion`): en total **27**,
  verificador en verde, `probar-verificar-ejemplos.py` TODO BIEN. Render mirado
  (págs. 35 a 41; el PDF tiene 41). Carátula: «v0.5 — módulos 1 a 6 de 12».
- **No resuelve el Práctico 3 ej. 3**: no hay `mostrar_digito` ni display de 7
  segmentos. Práctico 1 ej. 8 y 9: sin leer (nube), `hipótesis`.
- **Medido a mano en gcc 13.3:** `static uint8_t f();` llamada con 3
  argumentos **no avisa**; camino sin `return` avisa `-Wreturn-type`; función
  sin declarar avisa `-Wimplicit-function-declaration` y termina en error de
  tipos en conflicto. `gcc -fstack-usage`: `unos_recursivo` usa 64 bytes por
  llamada en x86-64 sin optimizar (33 anidadas para `0x80000000`).
- **`hipótesis` escrita en el módulo con «suele»**: `_Min_Stack_Size = 0x400`
  en el `.ld` que genera CubeIDE. Confirmarlo en el `.ld` del `tp2` en la PC.

## 2026-10-02 (nube, 3.ª) — apunte de C v0.4: módulo 5, control de flujo

- **Módulo 5** (`apunte-c/modulos/m05-control-flujo.typ`): `if`/`else if`
  (la primera cierta gana: el orden de los umbrales *es* la lógica), `=` por
  `==`, *dangling else* (con `ESPERA-WARNING: -Wdangling-else`), `switch` con
  `break`, `case` apilados y `default`, `while` con cota y el `;` pegado,
  `do-while` para reintentos, `for` contando para atrás con `uint8_t` (`t > 0u`,
  no `t >= 0u`), `break`/`continue`, `scanf` mirando lo que devuelve, con
  `SCNu16` y una entrada que trae basura. MISRA 15.6, 15.7, 16.3, 16.4.
  **6 programas nuevos** (`m05-enlace`, `m05-dangling`, `m05-comandos`,
  `m05-reintentos`, `m05-despliegue`, `m05-periodo` con `.entrada`): en total
  **23**, verificador en verde, `probar-verificar-ejemplos.py` TODO BIEN. Render
  mirado (págs. 27 a 34; el PDF tiene 34). Carátula: «v0.4 — módulos 1 a 5 de 12».
- **Plantilla:** `#codigo(..., entrada: true)` muestra el `.entrada` (lo que se
  tipeó) entre el código y la salida, en azul. Para todo ejemplo con `scanf`.
- **Medido a mano en gcc 13.3:** `if (x = 3u)` avisa `-Wparentheses`; un
  `break` olvidado entre `case` con código avisa `-Wimplicit-fallthrough`
  (lo prende `-Wextra`); `uint8_t i < 300` y `t >= 0u` avisan `-Wtype-limits`;
  `while (c > 0u);` con el `;` pegado **no avisa**.
- **Prácticos:** el Práctico 1 ej. 5, 6 y 7 tampoco se pudieron leer en la
  nube: que no se pisen es `hipótesis`, como el ej. 4.

## 2026-10-02 (nube) — apunte de C v0.3: módulo 4, operadores y los de bit

- **Módulo 4** (`apunte-c/modulos/m04-operadores-bits.typ`): `/` y `%` juntos,
  asignación compuesta, `%` con negativos; relacionales y lógicos con
  cortocircuito como guardia (dividir por cero: en la PC mata el proceso, en
  un Cortex-M4 devuelve 0 salvo `DIV_0_TRP`); `&` contra `&&`; `++` antes y
  después, `k = k++`; ternario; tabla de precedencia y la trampa `&` con `==`;
  operadores de bit, las cuatro operaciones con máscara, imprimir en binario;
  `~` promovido a `int`; armar y desarmar la cabecera CCSDS (133.0-B) con `<<`,
  `>>` y máscaras; desplazar sólo sin signo. MISRA 13.5, 12.1, 10.1, 12.2 en
  cajas «Mejora». **5 programas nuevos** (`m04-reloj`, `m04-logicos`,
  `m04-precedencia` con `ESPERA-WARNING: -Wparentheses`, `m04-banderas`,
  `m04-paquete`): en total **17**, verificador en verde,
  `probar-verificar-ejemplos.py` TODO BIEN. Render mirado (págs. 19 a 26; el
  PDF tiene 26). Carátula: «v0.3 — módulos 1 a 4 de 12».
- **No resuelve el Práctico 2 ej. 1** (contador de 4 bits en PB0–PB3, según el
  HANDOFF del 2026-09-29): ningún ejemplo cuenta en LEDs. **El Práctico 1
  ej. 4 no se pudo leer** (está en el material de la PC): que no se pise con
  los ejemplos es `hipótesis` hasta que la PC lo compare.
- **Medido a mano en gcc 13.3** (no entra al verificador): `~m == 0xFBu` con
  `uint8_t` avisa `-Wsign-compare`; `k = k++` avisa `-Wsequence-point`;
  `1 << 31` y `-16 >> 2` pasan callados; `printf("%b")` imprime en la glibc
  2.39 sin aviso (es C23, no C11); dividir por cero da SIGFPE.
- **Criterios de Leandro, públicos y resumidos** en `docs/CRITERIOS-LEANDRO.md`
  (decisión de Fran del 2026-10-02; la regla 3 del `CLAUDE.md` lo dice).
- **Sin publicar**: lo sube Fran desde la PC.

## 2026-10-02 (nube) — apunte de C v0.2: módulo 3, constantes y calificadores

- **Módulo 3** (`apunte-c/modulos/m03-constantes-calificadores.typ`): literales
  (bases, la trampa del octal, `0b` como extensión de gcc/C23, sufijos),
  `#define` con unidad en el nombre, la comparación como valor 0/1, la trampa
  de los paréntesis, `const` (error y no warning; flash vs RAM; la tabla
  `#define` contra `const`), `volatile` con espera de cota fija, `const
  volatile` (registro de estado del ADC1 de la F446RE, `0x40012000`), `static`
  local y de archivo. **5 programas nuevos** (`m03-literales`, `m03-bateria`,
  `m03-macro`, `m03-espera`, `m03-watchdog`): en total **12**, verificador en
  verde, `probar-verificar-ejemplos.py` TODO BIEN. Render mirado (págs. 10 a 16
  del cuerpo; el PDF tiene 18). Carátula: «v0.2 — módulos 1 a 3 de 12».
- Ninguno resuelve el Práctico 1: batería (3300–4200 mV, 1500 mA), margen de
  un panel, magnetómetro, reinicios del watchdog.
- **Medido a mano en gcc 13.3** (no entra al verificador porque es error, no
  warning): asignar a una `const` da `assignment of read-only variable`; una
  `const` como tamaño de vector global o como `case`, error. `0b101010` pasa
  callado con los flags de la cátedra y con `-Wpedantic` avisa.
- **Sesión en la nube (Linux)**: `verificar-ejemplos.py` corre sin WSL si
  `sys.platform != "win32"`; los 7 ejemplos viejos dieron verde **sin
  regenerar** (el gcc de la nube es el mismo 13.3 de Ubuntu 24.04). Los
  criterios de la cátedra se tomaron del **resumen de Fran en el pedido**: el
  repo `catedras` no está en este clon.
- **Sin publicar**: en la nube no hay rclone. Lo sube Fran desde su PC
  (`.\publicar-apuntes.ps1`, que compara por MD5; un `pull` no dispara el
  `post-commit`).

## 2026-10-02 — fase 0 cerrada; el apunte de C arranca (v0.1, módulos 1 y 2)

- **Alcance** (`docs/ALCANCE.md`): 12 módulos en el orden de la clase de C de
  Leandro, cada uno con su diapositiva y su práctico. Los criterios de Leandro
  quedaron en `catedras` (LEA-R1 a R4, LEA-01 a 18). **La «presentación del
  18/08» no existe en el material**: ese PDF es la entrega del grupo de Fran
  (comparativa de OBC).
- **Apunte de C** en `apunte-c/` (`apunte.pdf`, 10 pág.): módulo 1 (el
  programa mínimo: `template.c`, compilar con los flags, leer un warning, el
  superloop) y módulo 2 (variables y tipos: ancho fijo, signo, `sizeof`,
  `printf`, desborde, división entera). **7 programas**, todos en
  `apunte-c/ejemplos/`, compilados en el gcc 13.3 de Ubuntu (WSL) con
  `-Wall -Wextra -std=c11 -Werror`; la salida y el warning impresos son los de
  la corrida real. `verificar-ejemplos.py` en verde; `probar-verificar-ejemplos.py`
  5 de 5 en rojo por su motivo, control en verde. Render mirado, las 10 págs.
- **Medido con el gcc de CubeIDE 1.18.1 (ARM, Cortex-M4):** `uint32_t` es
  `long unsigned int`, `%u` da `-Wformat` y `PRIu32` no; `long` mide 4 bytes
  (en la PC, 8). Está en el módulo 2.
- **Publicado** en el Drive de apuntes (carpeta Software de Vuelo).

## 2026-09-29 (01:20) — la guía de IDEs v0.3, PUBLICADA

Fran dio el OK sin contar nada del TP2 todavía, así que **v0.4 no existe**:
se publicó la v0.3 tal cual. Declarada en `.claude/apuntes-publicos.json`
(materia «Software de Vuelo», en Drive como «Guia de IDEs - STM32CubeIDE y VS
Code.pdf») y **verificada por MD5** con `publicar-apuntes.ps1 -Verificar`.
**Regla de Fran desde hoy:** lo público se sube ni bien se tiene o se modifica.
Para que eso no dependa de acordarse, el hook `post-commit` ahora mira la
**lista declarada** y no sólo `apunte/apunte.pdf`: un commit que toque
`guia-ides/guia-ides.pdf` la republica solo (probado con el commit 8f15bfe:
el hook viejo decía «no», el nuevo «sí»; con la lista saboteada vuelve a «no»).

**La guía de C queda para después**, a pedido de Fran.

**TP Cohete (Petrilli):** su informe (`Informe_Cohete_de_Agua.docx`) estaba en
la carpeta **pública** `TDC` del Drive de apuntes, con link público. Se movió
(mismo ID de archivo) a `01 - UNSAM…/GRUPOS - trabajos por materia/Software de
Vuelo - TP Cohete de Agua (Petrilli)/` y el permiso `anyone` **se cayó con la
mudanza** (era heredado de la carpeta: medido, queda sólo el dueño). **No está
compartido con los autores:** el documento **no tiene mails ni nombres** —se
buscaron en el texto, encabezados, metadatos y comentarios del .docx de Drive y
en los 30+ archivos locales del TP (0 mails)—. Falta que Fran diga quiénes son.

## 2026-09-29 (00:50–02:00) — la guía de IDEs, adelantada para el TP2

**Fase 0 sigue abierta** (faltan los criterios de Leandro y `docs/ALCANCE.md`).
**La fase 2 se adelantó** a pedido de Fran, que entrega el TP2 hoy (PDP §6):

- **Guía pública, v0.3** — `guia-ides/guia-ides.pdf` (6 pág., 1 de carátula),
  fuente `guia-ides.typ` sobre `guia-ides/plantilla.typ` (el formato de los
  apuntes, liviano). **El método es el de la cátedra**, sacado de sus clases
  («STM32CubeIDE — Instalación», «De CubeIDE a Wokwi», semana 4), del TP2 y
  del TP3, incluidas las diapositivas que son sólo imagen (renderizadas y
  miradas); lo agregado va en cajas «Mejora». Lo que salió de las diapositivas
  y no del texto: la licencia de Wokwi **dura 30 días**, el simulador tiene su
  botón de reinicio, y el profe arma el circuito en wokwi.com y copia el
  `diagram.json`. **Sin publicar**: espera el visto bueno de Fran.
- **`guia-ides/preparar-vscode.ps1`** — deja un proyecto de CubeIDE listo para
  VS Code: `tasks.json` (compila con el `make` y el `gcc` de CubeIDE),
  `c_cpp_properties.json` (con los `-D`/`-I` del `subdir.mk`), y `wokwi.toml`
  + `diagram.json` sólo para la NUCLEO-C031C6 y sólo si no existen. Probado
  de punta a punta sobre **copias** (nunca el workspace real, CubeIDE estaba
  abierto): 5 de 5 casos, entre ellos correr **exactamente** el comando de la
  tarea (exit 0, `.elf` donde apunta `wokwi.toml`), no pisar un
  `diagram.json` del usuario, fallar sin `.ioc` **por el motivo correcto**, y
  no escribir Wokwi para la F446RE. Un error de sintaxis sale como
  `../Core/Src/main.c:125:11: error:` (exit 2). **Lo que no se probó:**
  arrancar el simulador con los archivos generados (necesita la GUI) y
  IntelliSense con la configuración generada.
- **Guía personal** — en el repo privado `catedras/software-de-vuelo/personal/`
  (`mi-entorno.typ` + `compilar.ps1`), PDF en
  `Desktop\01 - UNSAM\Software de Vuelo\Guia de entornos - mi entorno (personal).pdf`
  (3 pág.): las rutas de Fran, sus dos proyectos, lo instalado (medido) y el
  TP2 con los comandos listos para copiar. No va a ningún lado público.

## 2026-09-29 — el proyecto nace, fase 0 abierta

- **Material de la cátedra**: extraído completo (65 archivos, las 9 carpetas
  del Drive de la materia) en
  `C:\Users\frans\Desktop\01 - UNSAM\Software de Vuelo\Material de catedra\`.
  **Sin leer.** Índice en `catedras/software-de-vuelo/MATERIAL.md` (privado).
- **Proyectos de STM32CubeIDE**: el workspace entero se mudó a
  `...\Software de Vuelo\STM32\workspace_1.18.1\` y CubeIDE apunta ahí.
  Medido: `primer_proyecto_nucleo` (NUCLEO-C031C6, el de la clase) recompila
  de cero con 0 errores desde la ruta nueva, **con espacios en la ruta**;
  `tata_22_09TP3` (NUCLEO-F446RE, la placa de Fran) compila con 0 errores
  sobre una copia, y en el workspace está cerrado desde el 27/09.
- **Criterios de la cátedra**: los de Petrilli están registrados; los de
  Leandro, no (fase 0 de `catedras`).
- **Nada escrito de las guías todavía.**

**Una hipótesis para la guía de IDEs**, que la fase 2 tiene que probar y no
repetir: CubeMX (el `.ioc`) para configurar pines y reloj y generar la HAL;
VS Code con la extensión de ST para escribir, compilar y depurar; CubeIDE si la
cátedra pide el proyecto en su formato; Wokwi para simular, como en la semana
4; y **la placa, desde Windows y no desde WSL**, porque el ST-LINK por USB
dentro de WSL agrega un paso (usbipd) que no hace falta.
