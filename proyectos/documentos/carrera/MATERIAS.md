# Materias — qué tiene cada una y por dónde se sigue

**Se lee antes de producir algo para cualquier materia** (lo exige la cascada,
necesidad `materia`). Una fila por materia: qué hay hecho, qué le falta contra
sus **contenidos mínimos** ([`PLAN-DE-ESTUDIOS.md`](PLAN-DE-ESTUDIOS.md), por
código) y cuál es el próximo paso. **El estado fino es de cada proyecto**
(`ESTADO_ACTUAL.md`): acá va sólo lo que hace falta para elegir por dónde
seguir. Si una fila contradice al proyecto, manda el proyecto y esto se
corrige en el mismo turno.

**Cómo se midió «le falta»:** grep de los términos de los contenidos mínimos
sobre el fuente del apunte, el 2026-10-02. Un cero es `probable` hueco, no
`confirmado`: un tema puede estar con otro nombre. Lo que el **profesor**
pide (que manda sobre esto) está en el repo privado `catedras`.

## Cursando — 2C 2026

| Materia (código) | Lo que hay | Lo que le falta | Próximo paso |
|---|---|---|---|
| **Teoría de Circuitos** (ISE03) — Sanca | Apunte TDC, 103 pág., módulos 7 a 15 (mismo fuente que el de EA, compilado aparte desde el 2026-10-02); informes de laboratorio (`teoria-circuitos/`, repo aparte); clase asincrónica 3 (fase 2 en curso); **guía de estudio de función de transferencia, polos y ceros y respuesta completa** (14 pág., 2026-10-09, para la exposición del Grupo 1; privada: repo aparte y Drive del grupo) | **Trifásicos**, **Laplace** (respuesta temporal), **filtros activos** de orden superior (Butterworth, Sallen-Key), **polos y ceros** en el plano $s$, **impedancia reflejada** del transformador, **señales en frecuencia** (Fourier: 3 menciones sueltas). Es la fase 3 de `electronica-analogica/PDP.md` | Escribir esos temas en `electronica-analogica` (fase 3); salen solos en los dos apuntes. Orden sugerido: Laplace → polos y ceros → filtros activos → trifásicos. La guía privada del 2026-10-09 ya cubre polos, ceros y $H(s)$ con un ejemplo verificado: es semilla de ese módulo si Fran decide publicarla |
| **Programación** (ISE04 `probable`) — Leandro; TP Cohete: Petrilli | Guía de IDEs v0.4 publicada; TP2 entregado; **apunte de C v1.0**: los 12 módulos, **publicado** y verificado por MD5 el 2026-10-02 (`software-de-vuelo/apunte-c/`); criterios de Leandro registrados (LEA-01 a 18; resumen público en `software-de-vuelo/docs/CRITERIOS-LEANDRO.md`); **TP Cohete: código de la computadora de vuelo entregado el 16/10** con la V3 final y la guía del código; esa noche, con la devolución de Petrilli, pasó a la **versión de vuelo** (un paracaídas, despegue jumper Y altura), a adaptar al cohete el 20/10 (repo privado `cohete-de-agua`, Drive del grupo) | Guía de IDEs: el flujo en la NUCLEO-F446RE real. Del ISE04: C++, Python, archivos, métodos numéricos y simulador **no** son de esta cursada (`probable`: la materia es «Software de Vuelo», C embebido) | Cotejar los prácticos contra los ejemplos del apunte, medir `*NULL` en la placa, y la guía de IDEs en la F446RE (`software-de-vuelo/HANDOFF.md`) |
| **Física Espacial** (ISE02) — Aníbal | Apunte publicado (21 módulos, 212 pág.) con todo lo dado hasta el 13/10, hoja de fórmulas, 6 modelos de parcial y 2 de parcialito, guía con resultados, y el **1er parcial resuelto** (público desde el 13/10); $L$ = momento angular (C1 cerrado); fase 17 (mantenimiento) | **Toda la mitad de física moderna**: cuerpo negro, fotoeléctrico, modelo atómico y espectros, Schrödinger y función de onda, espín, Pauli, partículas, relatividad especial, nuclear (0 apariciones cada una). `hipótesis`: Aníbal la da en la segunda mitad del cuatrimestre, o el Taller la cubre | Cerrar la fase 15; preguntarle a Fran si la física moderna entra este cuatrimestre |
| **Taller de Física** — Aníbal | Exposición de Fran (Compton y pares) preparada en `catedras` | No figura en los contenidos mínimos: `hipótesis` que es parte práctica de ISE02 | Fase 1 bloqueada hasta que Fran diga «arrancamos» |
| **IISE** (ISE01) | Apunte publicado con las **clases 1 a 10** (40 módulos + anexo del trabajo final, 191 pág., 2026-10-13): WBS, red de actividades y camino crítico, **Gantt**, estimaciones, Fases B y C, TRL/IRL, gestión de riesgo; repaso oral terminado; consigna del **TP final (MCR)** y sus criterios en `catedras`; **resumen para el parcialito del 14/10** (clase 8 hasta el LDCM + Fase B, 12 pág., público en `Resumenes para parcialitos`) | QFD y liderazgo con una sola mención cada uno (no salieron en las clases 8 a 10) | Mantenimiento: la clase 11 cuando llegue; el TP final del MCR, si Fran lo pide |

## Fuera de la carrera, pero con apunte

| Qué | Lo que hay | Próximo paso |
|---|---|---|
| Electrónica Analógica (4.º año, EEST N.º 1) | Apunte de 155 pág. en dos partes | Lo mismo que TDC: la fase 3 escribe para los dos |

## Lo que todavía no se cursa

ISE05 a ISE32 y CMP01: sin producción. Cuando arranque una, entra acá su fila
y, si va a tener apunte, su proyecto con `nuevo-proyecto.ps1`.
