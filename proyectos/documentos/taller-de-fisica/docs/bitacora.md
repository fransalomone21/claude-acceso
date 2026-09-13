# Bitácora — Taller de Física

## 2026-09-13 — nace el proyecto

Viene de un pedido que Fran hizo al cerrar la fase 5 de `fisica-espacial`:
incorporar temas de un Taller de Física, materia aparte, con tres libros
propios. El detalle completo de cómo se llegó acá está en el HANDOFF de esa
sesión (`../fisica-espacial/HANDOFF.md`, ya reemplazado por el cierre de fase
6 de ese proyecto — ver su `docs/bitacora.md` si existe, o el historial de
git).

**Las tres fuentes, localizadas y con alcance revisado** (detalle en
`fuentes/RUTAS.md`): Ferraro (3 capítulos, cerrado), Pisacane (12 capítulos,
441 páginas — el propio libro trae un programa de curso en el prefacio),
Young-Freedman (ya usado en `fisica-espacial`, ahora como referencia general).

**El recorte de Pisacane que se le propuso a Fran, para que quede registrado
y no haya que rehacer la lectura del prefacio:**

Capítulos: 1 Introducción · 2 Sistema Solar · 3 El Sol · 4 Campos magnético y
eléctrico · 5 Campo gravitatorio · 6 Magnetosfera · 7 Ambiente neutro
(atmósfera) · 8 Interacciones de plasma · 9 Interacciones de radiación ·
10 Contaminación de la nave · 11 Meteoroides y basura espacial · 12 Control
térmico.

Propuesta (no confirmada): **3, 4, 6, 8, 9, 11.** Fuera: 1 (introducción
genérica, historia de fallas — no es física), 2 (sistema solar, ya lo cubre
`fisica-espacial` con más profundidad orbital), 5 (campo gravitatorio — el
propio Pisacane lo recomienda omitir primero si hay que sacar uno, y ya está
cubierto por `fisica-espacial`), 7 (mucho detalle de teoría cinética de gases
para lo que aporta — aunque el arrastre atmosférico en LEO es relevante y
quedó como posible agregado), 10 (contaminación de sala limpia — operativo,
no fundamento físico) y 12 (control térmico — el propio autor dice que es
tema de un curso aparte si ya existe uno).

**Por qué no se cerró:** Fran pidió que el criterio sea la correlación con
las listas de temas YA CONFIRMADAS — las de `fisica-espacial`
(`../fisica-espacial/fuentes/TEMARIO.md`) — no el juicio de esta sesión.
Cruzar capítulo por capítulo contra ese temario queda para cuando arranque la
fase 1.

**Decisión de arquitectura:** proyecto propio, separado de `fisica-espacial`
(ver PDP.md §6 para el porqué). Fran dijo explícitamente "decidilo vos" — la
alternativa considerada (Parte VI del mismo `apunte.typ`) se descartó porque
el Taller es una materia distinta y el apunte de Física Espacial ya cerró su
fase 5 con 149 páginas verificadas.

**No se escribió contenido.** Fran fue explícito: "todo lo de taller de
física es para un plazo más largo, yo te voy a decir cuándo empezarlo". Esta
sesión deja la fase 0 (estructura y fuentes) casi cerrada — falta sólo el
cruce del recorte de Pisacane contra el temario confirmado — y la fase 1
(escribir) bloqueada a propósito, sin fecha.
