# Software de Vuelo — guías de C y de IDEs, contrato de contexto

Dos guías **públicas** (se publican en el Drive de apuntes, pactado con Fran
el 2026-09-28) para la materia **Ingeniería de Software de Vuelo para
Sistemas Espaciales Críticos** (UNSAM, 2C 2026), la que Fran llama
«Programación»:

1. **Apunte de C**: variables, punteros, vectores, funciones y los temas que
   la materia pida.
2. **Guía de IDEs**: cómo se trabaja con **STM32CubeIDE** y con **VS Code**,
   y qué conviene usar de cada uno.

**Naturaleza:** `documentos`. Ver
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md).
El plan y las fases están en [`PDP.md`](PDP.md).

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| **producir cualquier cosa de las guías** | **primero** [`../catedras/software-de-vuelo/CRITERIOS.md`](../catedras/software-de-vuelo/CRITERIOS.md) (repo privado, sólo en esta máquina). Regla 1 |
| retomar | [`ESTADO_ACTUAL.md`](ESTADO_ACTUAL.md) |
| saber qué cierra la fase en curso | [`PDP.md`](PDP.md) §4 |
| encontrar el material de la cátedra o los proyectos de STM32 | [`../catedras/software-de-vuelo/MATERIAL.md`](../catedras/software-de-vuelo/MATERIAL.md) |
| generar un PDF | `/pdf-con-codigo` (Typst) |
| **escribir o tocar el apunte de C** | `docs/ALCANCE.md` (qué módulo, con qué clase y práctico) y `HANDOFF.md` (cómo se escribe un módulo). Todo programa va en `apunte-c/ejemplos/` y se mide con `python apunte-c\verificar-ejemplos.py` |

## Las reglas propias

**1. Nada se escribe sin haber leído los criterios de la cátedra.** Viven en
el repo privado `catedras`. Si en esta máquina no está, la sesión lo **dice**
y no produce contenido de la materia de memoria.

**2. El TP Cohete de Agua no va acá.** Es de Petrilli, es trabajo en grupo y
se comparte sólo con los integrantes: cuando Fran pida avanzar, se abre como
proyecto **privado** aparte. Acá van sólo las dos guías públicas.

**3. Lo público es sólo lo pactado.** Las guías, sí. Los criterios de los
profesores, el material de la cátedra y las entregas de otros alumnos, nunca
(Fran, 2026-09-28).

## Dónde corre esto

El material y los proyectos de STM32 viven en
`C:\Users\frans\Desktop\01 - UNSAM\Software de Vuelo\`; STM32CubeIDE 1.18.1
en `C:\ST\STM32CubeIDE_1.18.1\`. En otra máquina no están: decirlo, no
simular.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
