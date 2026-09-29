# Estado actual — Software de Vuelo (guías de C y de IDEs)

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
