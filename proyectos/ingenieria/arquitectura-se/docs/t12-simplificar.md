# T12 — Simplificar la arquitectura: concepción (sin construir)

**2026-10-02.** Pedido de Fran después de aceptar la crítica: *«ingeniá vos la
simplificación, con los libros; yo aporto intuición; sensatez antes que
orgullo»*. Esto es la **concepción**: el problema, el criterio y los
candidatos como **hipótesis**. Lo diseña y lo decide la sesión T12; nada de
acá está medido todavía salvo lo marcado.

## 1. El problema

El método crece por acumulación: cada falla suma una regla, un hook, una línea
del cuadro o un medidor, y casi nunca se saca nada. **Medido el 2026-10-02:**
para editar un párrafo de `arquitectura-se` la puerta exigió releer ~37 K
tokens; el cuadro PARA VOS + el de fase van en **cada** respuesta, incluso en
una pregunta personal; la sesión del día se comió casi toda la ventana de 5 h
mayormente en el método, no en un proyecto.

## 2. El criterio, escrito antes de elegir

- **Lo que importa es el costo por unidad de valor**, no el costo solo. Tres
  presupuestos distintos, que no se suman (lección: «un costo que se paga una
  vez y uno que se paga por turno no van en el mismo total»): **por sesión**
  (lo inyectado al abrir), **por turno** (el recordatorio de cada mensaje, los
  cuadros), **por entrada a proyecto** (lo que exige la puerta).
- **Se saca o se poda si** su costo es alto y la falla contra la que fue
  diseñada **no reaparece** sin él, o la cubre otra pieza que mide el efecto.
  Un freno no se saca sin escribir contra qué impacto fue diseñado (regla 6).
- **Éxito de T12:** el costo por turno y por sesión baja de forma medible y,
  en las 5 sesiones de validación, no sube ninguna de las fallas que hoy se
  miden (cascada salteada, inyección cortada, correcciones de Fran por algo
  ya escrito).

## 3. Los libros que mandan (ya están en `perfil-global/pilares/`)

- **NASA, tailoring y matriz de cumplimiento** (`nasa-seh/tailoring.md`): la
  herramienta para **restar** requisitos con su justificación escrita. Cada
  regla y cada freno pasa por la matriz: se cumple, se recorta (con su resta)
  o se saca.
- **Rechtin & Maier** (`rechtin-maier/heuristicas.md`): «Simplify. Simplify.
  Simplify.» y las heurísticas de partición.
- **Saltzer, economía de mecanismo**: casi todo el mecanismo está en las capas
  que menos garantizan.
- **Meadows**: sacar una capa que no mueve nada es subir de nivel, no bajar.
- **Hunt & Thomas**: DRY y ortogonalidad (un dato o una regla en un solo lugar).

## 4. Candidatos, como HIPÓTESIS a medir (no decididos)

| # | Candidato | Por qué sospecho | Qué hay que medir antes |
|---|---|---|---|
| C1 | El recordatorio de **cada mensaje** (`recordatorio-transversal.md`) | Se paga por turno y repite lo que ya dicen `CLAUDE.md` y `apertura-proyecto.md` | Su tamaño exacto; si los cuadros se siguen poniendo con una versión de 10 líneas (fue diseñado contra cuadros sin formato: no se saca, se achica) |
| C2 | Los cuadros en respuestas que no tocan un proyecto | Una pregunta suelta paga ~25 líneas | Si una forma corta («sin cambios») alcanza para Fran |
| C3 | Las reglas del perfil con su historia adentro (la 10 ocupa una pantalla) | El porqué va al pilar; la regla, en una línea | Que el texto que queda siga cumpliéndose |
| C4 | Capas que dicen lo mismo: `arranque.md`, `CLAUDE.md`, `apertura-proyecto.md`, el recordatorio | DRY violado por el método mismo | Mapa de qué frase vive en cuántos lados |
| C5 | Lo que la puerta exige para `metodo` y `diseno` (~37 K) | Fichas enteras donde alcanzaría el índice | Si las sesiones usan lo leído (correcciones de Fran) |
| C6 | Filas del enrutador y estados largos (T3) | BLACK: 11 K en una fila, 121 K de estado | Ya medido en el diagnóstico (A2) |
| C7 | T11b entero | Suma 4 piezas más | Quedarse sólo con lo barato y con freno (el `--nivel` de la regla 15) |

## 5. Orden

1. ~~Medir el peso real (por sesión, por turno, por entrada) con lo que ya
   existe (`medir-inyeccion.py`, `cascada_puerta.py --exige`) — no a ojo.~~
   **Hecho el 2026-10-02 (§6)**, con un instrumento nuevo porque ninguno de
   los dos medía el efecto en la ventana: `medir-costo.py`.
2. Matriz de cumplimiento de **todo el método**: cada pieza con su impacto
   original, su costo y su veredicto (cumple / recortada con resta / sale).
3. Podar en ese orden, con saboteador corrido después de cada poda: lo que
   frenaba tiene que seguir frenando.
4. De T11b, sólo lo que sobreviva.
5. Validar en 5 sesiones reales con `medir-cascada.py` y `medir-inyeccion.py`.

## 6. El costo ANTES — medido, no a ojo (2026-10-02)

**Instrumento:** [`../medir-costo.py`](../medir-costo.py). Lee el
**transcript** (lo que el harness metió de verdad en la ventana), no el tamaño
de los archivos, y separa lo que cobra el método de lo que pone el harness.
Es la semilla de P10 (*affordable*, SEH p. 165-166): el «después» se mide con
la misma vara. Control: sobre esta sesión reprodujo, al carácter, las salidas
de hook que el inspector crudo del transcript había contado a mano
(2 970 / 7 940 / 9 592 …). Un defecto propio encontrado al usarlo: el
contenido de `nested_memory` viene como objeto, y la primera versión contaba
4 caracteres donde había 18 475.

**Línea de base: las 10 sesiones más recientes de este repo con ≥ 2 turnos,
más ésta.** Caracteres (≈ 3,5 por token, a ojo).

| Presupuesto | Qué lo forma | Mediana | Rango |
|---|---|---|---|
| **Por sesión, método** | hooks `SessionStart` + `CLAUDE.md` + `MEMORY.md` | **75 701** (antes de T1) → **~125 000** (desde T1) | 62 163 – 131 889 |
| Por sesión, `CLAUDE.md` de subcarpeta al leer adentro | `nested_memory` | 15 143 | 0 – 32 997 |
| Por sesión, al paso | viñetas antes de una herramienta | 0 – 16 044 | — |
| **Por turno** | recordatorio `UserPromptSubmit` | **5 520** | 4 830 – 5 541 |
| Por turno, salida | los dos cuadros | 1 444 | 1 000 – 2 305 |
| **Por entrada a proyecto** | lo que la puerta exige (`metodo,diseno`) | **137 884** | la sesión de T11 sumó 309 528 en varias declaraciones |
| Por sesión, **harness** (no es del método) | prompt, herramientas, listado de skills y plugins | 217 587 | 210 136 – 238 524 |

**Desglose de una apertura (la de esta sesión), de mayor a menor:**

| Caracteres | Pieza | Nota |
|---|---|---|
| **54 602** | `CLAUDE.md` raíz (el enrutador) | **43 % del costo fijo del método**; dice ser «sólo a dónde ir» |
| 26 265 | núcleo de `chequeo-de-trabajo` (4 hooks) | entró entero con T1 |
| 15 549 | `~/.claude/CLAUDE.md` (perfil global) | la regla 10 sola ocupa 4 513 |
| 12 731 | `pilares.md` (2 hooks) | |
| 9 592 | `apertura-proyecto.md` | repite las reglas 10-12 |
| 4 348 | `MEMORY.md` | |
| 3 443 | arranque (texto + medición) | |

**Lo que la medición cambia de los candidatos de §4** (todavía sin decidir;
eso es §7):

- **C6 sube al primer lugar.** El enrutador cuesta más que pilares, núcleo y
  apertura juntos, y es el único que se paga en **toda** sesión, toque o no
  un proyecto. El diagnóstico lo había medido en 47 KB (A2); hoy son 55 KB.
- **T1 duplicó el costo fijo** (75 K → 125 K): lo que llegaba como vista
  previa de 2 KB ahora llega entero. Era lo pedido —que lo que «se lee solo»
  se lea— y no se revierte; pero cambia la cuenta: cada carácter del núcleo y
  de los pilares ahora se paga de verdad.
- **C1 + C4 son una sola cosa**: la especificación de los cuadros vive en la
  regla 10-12 del perfil (5 654), en `apertura-proyecto.md` (~9 600), en el
  recordatorio de cada turno (5 520) y en la skill `/cuadro-de-fase`. Se paga
  tres veces por sesión y una más por turno.
- **Hay un costo que nadie había contado**: `nested_memory`. Leer cualquier
  archivo de `perfil-global/` carga **otra vez** el perfil global (su
  `CLAUDE.md` fuente, 18 475), que ya está instalado en `~/.claude/`. Es el
  mismo texto dos veces en la misma ventana.
- **El al paso duplica a la puerta**: en esta sesión la puerta exigió leer
  `chequeo-de-trabajo.md` 1578-1835 y, minutos después, `al-paso` inyectó
  17 viñetas de ese mismo tramo (8 795).
- **El harness no es del método, pero se paga igual**: ~218 K por sesión, y el
  listado de skills trae dos plugins (SEO y Adobe) que ningún proyecto usa.
  Eso no lo poda T12; es una pregunta para Fran (§8).
