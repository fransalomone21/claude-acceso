# PDP — Software de Vuelo: guía de C y guía de IDEs

## 1. El problema

Fran cursa **Ingeniería de Software de Vuelo para Sistemas Espaciales
Críticos** (Leandro; el TP Cohete lo da Petrilli) con una **NUCLEO-F446RE**
(STM32F446RE, Cortex-M4 con FPU). Le faltan dos cosas que sirvan también a los
compañeros:

1. un **apunte de C** con lo que la materia usa (variables, punteros,
   vectores, funciones y lo que pidan las clases y los prácticos);
2. una **guía de IDEs** que conteste **su** pregunta, textual del
   2026-09-28: *«si conviene usar mejor Visual para todo y sólo usar la HAL
   del STM32, o qué usar de cada uno»*. Fran viene de **VS Code** con
   **PlatformIO** y con **WSL Ubuntu**, y lo prefiere.

**Para quién es:** Fran primero; los compañeros de la materia después (van al
Drive público).

**Cómo sabremos que sirvió (validación):** que Fran resuelva un práctico de
la materia usando la guía de IDEs sin volver a preguntar cómo se configura el
entorno, y que la guía de C no contradiga ningún criterio de Leandro.
PENDIENTE de medir: es posterior a la fase 2.

## 2. Qué NO es

- No es el TP Cohete de Agua (regla 2 del contrato).
- No es un curso de C desde cero con todo el lenguaje: cubre lo que la materia
  usa, en el orden en que lo usa.
- No resuelve los prácticos: los explica. Resolverlos es la entrega de Fran.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `documentos` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` contenido técnico (C, HAL, IDEs) | se rehace barato | conocidos | cada ejemplo de código **compila** (y el de la placa, corre) | un ejemplo que no compila en un apunte público enseña mal a muchos |
| `b` ajuste a la cátedra | se rehace barato | desconocidos hasta leer el material | leer los criterios antes de escribir | es la prioridad que puso Fran |
| `c` publicación en Drive | se rehace barato, pero **se publica** | conocidos | declarado en `apuntes-publicos.json` y verificado por MD5 | lo público se decide antes, no después |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | **Alcance de las dos guías** (tipo: **Fase A**) | `docs/ALCANCE.md` lista cada tema de cada guía con la clase o el práctico de la materia que lo pide, y ningún práctico (1 a 3) queda sin tema | los criterios de Leandro registrados en `catedras` (su fase 0 cerrada) **y** un chequeo de que cada práctico aparezca en `docs/ALCANCE.md` | abierta |
| 1 | Guía de C (tipo: **Fase D**) | PDF compilado, cada ejemplo de código compila con `gcc -Wall -Wextra` sin warnings, publicado en Drive y verificado por MD5 | a escribir al abrir la fase | — |
| 2 | Guía de IDEs (tipo: **Fase D**) | PDF que contesta la pregunta de §1 con una recomendación y su porqué, con el flujo probado en la NUCLEO-F446RE (compilar y cargar un proyecto por el camino recomendado) | a escribir al abrir la fase | — |

> **Tipo Fase A:** se decide **qué** entra y por qué, no se escribe la guía.

**Fase en curso:** 0 — Alcance de las dos guías.

**Qué la cierra, exactamente:** que exista `docs/ALCANCE.md` con cada tema de
las dos guías y, al lado, la clase o el práctico de la materia que lo pide;
que los prácticos 1, 2 y 3 aparezcan los tres; y que los criterios de Leandro
estén en `catedras/software-de-vuelo/CRITERIOS.md`.

**Cómo se certifica:** `python ..\catedras\verificar-criterios.py` en verde con
entradas `LEA-R` presentes, y
`Select-String -Path docs\ALCANCE.md -Pattern 'Práctico 1','Práctico 2','Práctico 3'`
encontrando los tres. Lo corre la sesión que cierre la fase.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| La guía de IDEs recomienda VS Code y la cátedra exige entregar el proyecto de CubeIDE | media | alta | mitigar: leer los prácticos antes (fase 0) | un práctico que pida el `.ioc` o el proyecto de CubeIDE |
| Lo que se sabe hoy de la extensión de ST para VS Code quedó viejo | media | media | medir en la fase 2: instalar y probar, no citar de memoria | la versión instalada no coincide con lo escrito |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-09-29 | Proyecto **público**, con los criterios en el repo privado `catedras` | todo privado | las guías son públicas por pacto; lo privado es el criterio, y ya tiene casa |
| 2026-09-29 | Dos guías en el mismo proyecto | un proyecto por guía | misma materia, mismo destinatario, mismo circuito de publicación |

## 7. Verificación

Se define al abrir las fases 1 y 2: compilar cada ejemplo y probar el flujo
en la placa.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `CLAUDE.md §Las reglas #1` (evidencia graduada) | `a` | `cumple` | |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `a` | `cumple` | |
| `plantillas/naturalezas/documentos.md §Las cinco #1` (el destinatario está escrito) | todos | `cumple` | §1 |
| `plantillas/naturalezas/documentos.md §Las cinco #2` (el render se mira) | `a` | `cumple` | |
| `plantillas/naturalezas/documentos.md §Las cinco #5` (se escribe con código) | todos | `cumple` | Typst |
