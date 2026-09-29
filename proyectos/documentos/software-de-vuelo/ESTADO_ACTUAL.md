# Estado actual — Software de Vuelo (guías de C y de IDEs)

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
