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
| **Teoría de Circuitos** (ISE03) — Sanca | Apunte TDC, 103 pág., módulos 7 a 15 (mismo fuente que el de EA, compilado aparte desde el 2026-10-02); informes de laboratorio (`teoria-circuitos/`, repo aparte); clase asincrónica 3 (fase 2 en curso) | **Trifásicos**, **Laplace** (respuesta temporal), **filtros activos** de orden superior (Butterworth, Sallen-Key), **polos y ceros** en el plano $s$, **impedancia reflejada** del transformador, **señales en frecuencia** (Fourier: 3 menciones sueltas). Es la fase 3 de `electronica-analogica/PDP.md` | Escribir esos temas en `electronica-analogica` (fase 3); salen solos en los dos apuntes. Orden sugerido: Laplace → polos y ceros → filtros activos → trifásicos |
| **Programación** (ISE04 `probable`) — Leandro; TP Cohete: Petrilli | Guía de IDEs v0.4 publicada; TP2 entregado; **apunte de C v0.1** publicado: módulos 1 y 2 de 12 (`software-de-vuelo/apunte-c/`); criterios de Leandro registrados (LEA-01 a 18) | Módulos 3 a 12 del apunte de C (constantes, operadores de bit, control de flujo, funciones, vectores, punteros, máquinas de estado, tipos compuestos, preprocesador, memoria). Del ISE04: C++, Python, archivos, métodos numéricos y simulador **no** son de esta cursada (`probable`: la materia es «Software de Vuelo», C embebido) | Módulo 3 del apunte de C (`software-de-vuelo/HANDOFF.md`) |
| **Física Espacial** (ISE02) — Aníbal | Apunte cerrado y publicado (19 módulos, 149 pág.), hoja de fórmulas, 6 modelos de parcial, guía con resultados; fase 15 abierta (material del 28/09 sin leer) | **Toda la mitad de física moderna**: cuerpo negro, fotoeléctrico, modelo atómico y espectros, Schrödinger y función de onda, espín, Pauli, partículas, relatividad especial, nuclear (0 apariciones cada una). `hipótesis`: Aníbal la da en la segunda mitad del cuatrimestre, o el Taller la cubre | Cerrar la fase 15; preguntarle a Fran si la física moderna entra este cuatrimestre |
| **Taller de Física** — Aníbal | Exposición de Fran (Compton y pares) preparada en `catedras` | No figura en los contenidos mínimos: `hipótesis` que es parte práctica de ISE02 | Fase 1 bloqueada hasta que Fran diga «arrancamos» |
| **IISE** (ISE01) | Apunte cerrado y publicado (28 módulos, 126 pág.); repaso oral terminado | **Diagrama de Gantt** (0), QFD y liderazgo con una sola mención cada uno | Mantenimiento: si se reabre, una sección de Gantt / QFD / PERT juntos |

## Fuera de la carrera, pero con apunte

| Qué | Lo que hay | Próximo paso |
|---|---|---|
| Electrónica Analógica (4.º año, EEST N.º 1) | Apunte de 155 pág. en dos partes | Lo mismo que TDC: la fase 3 escribe para los dos |

## Lo que todavía no se cursa

ISE05 a ISE32 y CMP01: sin producción. Cuando arranque una, entra acá su fila
y, si va a tener apunte, su proyecto con `nuevo-proyecto.ps1`.
