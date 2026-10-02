# Estado actual — Software de Vuelo (guías de C y de IDEs)

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
