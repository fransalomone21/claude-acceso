# PDP — Carrera: plan de estudios y tablero de materias

## 1. El problema

Fran cursa varias materias a la vez y cada una tiene su proyecto; ninguna
sesión sabía **qué tiene que cubrir** una materia según el plan oficial, ni
**qué le falta** a cada una para elegir por dónde seguir. Pedido del
2026-10-02: *«registralos en algún lado importante y transversal a todo… y
registrá lo que le falte a cada materia, así cada vez que quiera avanzar
alguna, sabemos por dónde seguir»*.

**Para quién es:** Fran, y toda sesión que produzca para una materia.

**Cómo sabremos que sirvió (validación):** que Fran pida «avancemos X» y la
sesión arranque por el próximo paso de la fila de X sin preguntarle dónde
quedó.

## 2. Qué NO es

- No es el criterio de los profesores: eso es el repo privado `catedras`.
- No es el estado fino de cada proyecto: eso es su `ESTADO_ACTUAL.md`.
- No produce apuntes: los apuntes viven en el proyecto de cada materia.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `documentos` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` el plan textual | se rehace barato | conocidos | copia fiel, sin resumir | es la fuente; resumirlo la falsifica |
| `b` el tablero | se rehace barato | conocidos | cada «le falta» con cómo se midió y su grado | un hueco inventado manda a escribir lo que ya está |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | **Línea de base** (tipo: **Fase A**) | el plan textual con sus 33 códigos, una fila en `MATERIAS.md` por materia cursada, y la cascada exigiendo leer `MATERIAS.md` en toda necesidad `materia` | `(Select-String -Path PLAN-DE-ESTUDIOS.md -Pattern '^## \((ISE\|CMP)').Count` da 33, y `.\cascada.ps1 software-de-vuelo -Necesidad materia` lista `carrera\MATERIAS.md` | **cerrada 2026-10-02** |
| 1 | **Mantenimiento** (tipo: **Fase E**) | cada sesión que cambia qué tiene una materia actualiza su fila en el mismo commit | revisión al cerrar cada sesión de materia | abierta |

**Fase en curso:** 1 — Mantenimiento.

**Qué la cierra, exactamente:** no cierra mientras Fran curse; se cancela al
recibirse.

**Cómo se certifica:** al cerrar una sesión de materia, `git log -1 --stat`
del commit incluye `carrera/MATERIAS.md` si cambió qué tiene la materia.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| El tablero se atrasa respecto de los proyectos | alta | media | vigilar: regla 2 del contrato | una fila que dice algo que el `ESTADO_ACTUAL` del proyecto contradice |
| «Programación» no es ISE04 | media | baja | preguntarle a Fran | el nombre oficial de la materia en el SIU |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-10-02 | Proyecto público en `claude-acceso` | dentro de `catedras` | `catedras` no tiene remote (vive en una sola máquina), y el plan de estudios es público |
| 2026-10-02 | La cascada lee `MATERIAS.md` entero y no el plan | leer el plan entero (15 K) | el plan se consulta por código; el tablero es lo que decide por dónde seguir |

## 7. Verificación

Los dos comandos de la fase 0. El primero se probó en rojo contando con un
patrón equivocado (`^## ISE`, sin el paréntesis): da 0.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `CLAUDE.md §Las reglas #1` (evidencia graduada) | `b` | `cumple` | |
| `plantillas/naturalezas/documentos.md §Las cinco #1` (el destinatario está escrito) | todos | `cumple` | |
| `plantillas/naturalezas/documentos.md §Las cinco #3` (toda afirmación tiene fuente) | `a` | `cumple` | |
