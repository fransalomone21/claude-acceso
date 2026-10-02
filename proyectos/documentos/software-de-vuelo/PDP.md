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
| 0 | **Alcance de las dos guías** (tipo: **Fase A**) | `docs/ALCANCE.md` lista cada tema de cada guía con la clase o el práctico de la materia que lo pide, y ningún práctico (1 a 3) queda sin tema | los criterios de Leandro registrados en `catedras` (su fase 0 cerrada) **y** un chequeo de que cada práctico aparezca en `docs/ALCANCE.md` | **cerrada 2026-10-02**: 12 módulos con su clase y su práctico; LEA-R1 a R4 y LEA-01 a 18 en `catedras` (`verificar-criterios.py` 97/15 en verde, saboteador 3 de 3) |
| 1 | **Apunte de C** (tipo: **Fase D**) | los 12 módulos de `docs/ALCANCE.md` escritos en `apunte-c/`; **todo** programa del apunte es un `.c` de `apunte-c/ejemplos/` que compila con `gcc -Wall -Wextra -std=c11` sin warnings y cuya salida impresa es la de la corrida real; publicado en Drive y verificado por MD5 | `python apunte-c\verificar-ejemplos.py` en verde **y** `python apunte-c\probar-verificar-ejemplos.py` con sus 5 sabotajes en rojo por su motivo; el render de cada módulo nuevo **mirado**; `publicar-apuntes.ps1 -Verificar` | **abierta, falta sólo publicar** (2026-10-02, nube): los 12 módulos escritos (v1.0, 82 pág., 49 programas: 48 sueltos y 1 proyecto de 3 archivos); verificador en verde; saboteador TODO BIEN con **8** sabotajes; `revisar-pdf.py` verde y su saboteador TODO BIEN; render de cada módulo mirado (del 10 en adelante, entero). Falta: `publicar-apuntes.ps1` y `-Verificar` en la PC |
| 2 | Guía de IDEs (tipo: **Fase D**) | PDF que contesta la pregunta de §1 con una recomendación y su porqué, con el flujo probado en la NUCLEO-F446RE (compilar y cargar un proyecto por el camino recomendado) | a escribir al abrir la fase | **adelantada**: v0.3 entregada el 2026-09-29 (flujo de simulación probado; F446RE sin probar; sin publicar) |

> **Tipo Fase A:** se decide **qué** entra y por qué, no se escribe la guía.

**Fase en curso:** 1 — Apunte de C (tipo **Fase D**: se escribe lo que la
fase 0 decidió; un tema nuevo no se agrega sobre la marcha, vuelve a
`docs/ALCANCE.md`).

**Qué la cierra, exactamente:** los 12 módulos de `docs/ALCANCE.md` escritos;
cada programa del apunte es un `.c` de `apunte-c/ejemplos/` que compila sin
warnings con los flags de la cátedra y cuya salida impresa es la real; el
render de cada módulo, mirado; y el PDF publicado y verificado por MD5.

**Cómo se certifica:** `python apunte-c\verificar-ejemplos.py` en verde (en
rojo se ve así: un programa con un warning, una salida que el programa no
imprime, un `.c` que nadie cita o un `#codigo` sin su `.c`) y
`python apunte-c\probar-verificar-ejemplos.py` diciendo `TODO BIEN`; más
`python apunte-c\revisar-pdf.py` en verde (ningún bloque sale de la página) y
`.\publicar-apuntes.ps1 -Verificar`. Lo que ningún comando hace: mirar el
render. **No cubierto por el saboteador:** la entrada «entorno» (sin WSL o sin
gcc, el verificador sale en rojo por código, pero ese camino no se provocó).

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| La guía de IDEs recomienda VS Code y la cátedra exige entregar el proyecto de CubeIDE | media | alta | mitigar: leer los prácticos antes (fase 0) | un práctico que pida el `.ioc` o el proyecto de CubeIDE |
| Lo que se sabe hoy de la extensión de ST para VS Code quedó viejo | media | media | medir en la fase 2: instalar y probar, no citar de memoria | la versión instalada no coincide con lo escrito |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-10-02 | Los criterios de Leandro también van como **resumen público, interpretado y fechado** (`docs/CRITERIOS-LEANDRO.md`); el textual sigue en `catedras` y gana si discrepan | dejarlos sólo en el privado | decisión de Fran: «son interpretaciones nuestras»; la sesión en la nube no tiene `catedras` y escribía con criterios pegados en el pedido |
| 2026-10-02 | El verificador acepta **proyectos** (`ejemplos/<nombre>/`, `#proyecto(...)` que muestra todos sus archivos) | un `.c` suelto que simula los otros archivos | el módulo 11 trata justamente de partir en `.h` y `.c`: simularlo enseñaría lo contrario |
| 2026-10-02 | El render se mide además de mirarse: `revisar-pdf.py` (ningún bloque sale de la página), y la plantilla parte en dos los ejemplos de más de 55 líneas | sólo mirar el render | un bloque que se salía de la página se dio por mirado sin haberlo mirado (lección en el HANDOFF) |
| 2026-09-29 | Proyecto **público**, con los criterios en el repo privado `catedras` | todo privado | las guías son públicas por pacto; lo privado es el criterio, y ya tiene casa |
| 2026-09-29 | Dos guías en el mismo proyecto | un proyecto por guía | misma materia, mismo destinatario, mismo circuito de publicación |
| 2026-09-29 | **La guía de IDEs se adelanta** (fase 2, tipo D) como **v0.3**, con la fase 0 todavía abierta, porque Fran la necesita para entregar el TP2 | esperar a cerrar las fases 0 y 1 | la prioridad la pone Fran: el TP2 se entrega hoy. La fase 2 **no cierra**: falta el flujo en la F446RE real y publicarla |
| 2026-09-29 | **El método base es el de la cátedra** (semana 4, TP2, TP3), y lo que se agrega va en cajas «Mejora» | un método propio (compilar en VS Code como camino principal) | pedido de Fran: *«antes de inventar un método, sacalo de las presentaciones del profe; si lo podés mejorar, hacelo»* |
| 2026-09-29 | **Dos versiones**: la pública (esta, para la materia) y una **personal** con las rutas y el entorno de Fran, en el repo privado `catedras/software-de-vuelo/personal/`, con el PDF en su carpeta local | una sola guía con todo | pedido de Fran: lo público es lo que la materia pide; lo de su máquina es suyo |
| 2026-10-02 | **Ningún programa vive adentro del `.typ`**: cada ejemplo es un `.c` completo en `apunte-c/ejemplos/`, el apunte lo lee con `#codigo()`, y la salida y el warning que muestra son los de la corrida real en el gcc de Ubuntu (WSL) | código escrito a mano en el `.typ` y compilado aparte | un apunte público que enseña con un ejemplo que no compila enseña mal a muchos (aspecto `a`); así no puede pasar |
| 2026-10-02 | **El orden del apunte es el de la clase de Leandro** (12 módulos, `docs/ALCANCE.md`); los ejemplos usan el mismo OBC imaginario pero **otros casos** que los prácticos | seguir un libro de C | el método del profe primero (memoria `feedback_apuntes-materia`); y el apunte no resuelve los prácticos (§2) |
| 2026-10-02 | **Voz de la casa con humor**: criollo, sarcástico, integrado en la prosa (regla 8 de `fisica-espacial`), a pedido de Fran: «dale el toque artístico y humorístico nuestro a todo, es nuestra esencia» | tono neutro de manual | lo pidió Fran |
| 2026-09-29 | Formato: una **plantilla liviana** (`guia-ides/plantilla.typ`) con la paleta, la tipografía, las marcas y las cajas del apunte de Física Espacial, sin módulos ni anexos | usar la plantilla de Física Espacial entera | pedido de Fran: *«el formato que usamos, sin complicarla»*. La guía de C la puede reusar |

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
