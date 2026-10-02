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

## 7. La matriz de cumplimiento de TODO el método

Molde de NASA (`tailoring.md` §8, tabla 3.11-3): cada pieza con **por qué
existe** (el impacto contra el que se diseñó, que es lo que permite juzgar si
sacarla es barato o caro) y su **costo**; la **resta** se escribe sólo cuando
se recorta o se saca (p. 41: el default es silencio). Criterio de §2: se
recorta o sale si su costo es alto **y** la falla no reaparece sin ella, o la
cubre otra pieza que mide el efecto. Y el de p. 36: *«when the cost of
implementing the requirement adds more risk … by diverting resources than the
risk of not complying»* — acá el recurso desviado es la ventana.

**Lo que no se negocia** (p. 39-40, el piso que ni el tipo F baja a «no
existe»): qué se quería (PDP/meta), qué se decidió (ESTADO/HANDOFF), cómo se
verifica (los medidores y sus saboteadores), qué versión es (git) y qué se
aprendió (lecciones). **Se recorta la profundidad, no la existencia.**

Costo: **S** = por sesión, **T** = por turno, **E** = por entrada a proyecto,
**t** = tiempo. Medido salvo «~» (a ojo).

### 7.1 Lo que se inyecta solo

| Pieza | Por qué existe | Costo | Veredicto | Resta |
|---|---|---|---|---|
| Enrutador (`CLAUDE.md` raíz) | que toda sesión sepa qué proyectos hay y dónde (nivel 2); las 4 reglas de la estructura | **S 54 602** | **recortada** | Las 20 filas narran la historia de cada proyecto, que ya vive en su `ESTADO_ACTUAL` y que `cascada.ps1` imprime al lado de la fila. Queda: fila = qué es + fase + 1 línea de estado (≤ 300 car.); las 4 reglas en su enunciado; frenos, Drive y Mi unidad en sus reglas duras (qué remote es público, que se mide el permiso del objeto). La historia de cada incidente va a `MAPA.md`, que se lee una vez. Meta ≤ 15 000. Lo que frenaba lo sigue frenando: `verificar-estructura` (regla 3b, enlaces) y el contraste fila ↔ ESTADO de `cascada.ps1` |
| Perfil global (`~/.claude/CLAUDE.md`) | las reglas absolutas | **S 15 549** | **recortada** | Las reglas 10-12 (5 654) repiten el protocolo de `apertura-proyecto.md` con su historia («eran 12 hasta…»): quedan en 3 líneas cada una con puntero. «Autoperfeccionamiento» (~3 500) explica la historia de `--triage`/`--opuesto`, que es de `/lecciones-aprendidas`: quedan las 4 preguntas y el comando. Meta ≤ 9 000 |
| `apertura-proyecto.md` | el protocolo de abrir/cortar/cerrar y la spec de los cuadros | S 9 592 | **cumple, y pasa a ser la ÚNICA fuente de la spec de los cuadros** | (se le saca la historia de cada línea, ~2 000) |
| Recordatorio por turno | contra cuadros puestos sin el formato (la lección del molde literal) | **T 5 520** | **recortada** | Se queda **el molde literal** —es lo que el impacto original pide: «un recordatorio que describe el formato en vez de mostrarlo se cumple a medias»— y salen las explicaciones, que ya llegaron una vez en la apertura. Meta ≤ 2 000. Es el que más rinde: se paga en cada mensaje (30 mensajes = 165 K) |
| `pilares.md` (2 hooks) | el porqué de las reglas (nivel 0) | S 12 731 | cumple | — |
| Núcleo de `chequeo-de-trabajo` (4 hooks) | que las ~200 lecciones lleguen (A1, T1) | S 26 265 | cumple | (candidato a la próxima vuelta: renglones repetidos; no se mide hoy) |
| Arranque (texto + medición) | autorizaciones permanentes; estado medido y no leído del HANDOFF | S 3 443, t ~40 s | cumple | Drive sin medir en 4 de 15 arranques: no es un aviso que salte siempre |
| `MEMORY.md` | preferencias de Fran | S 4 348 | cumple | — |
| `nested_memory` de `perfil-global/CLAUDE.md` | **ninguno**: es un efecto del harness, que carga el `CLAUDE.md` de la carpeta donde se lee | **S 18 475** al tocar el perfil | **sale** | Es el mismo texto que `~/.claude/CLAUDE.md`, dos veces en la ventana. Se renombra la fuente (`perfil-global/CLAUDE.md` → un nombre que el harness no carga) y `install.ps1` la copia con el nombre de destino. Hay que tocar install y verify-install: va **después** de la renovación |

### 7.2 Lo que corre antes o después de una herramienta

| Pieza | Por qué existe | Costo | Veredicto | Resta |
|---|---|---|---|---|
| Puerta de la cascada | 1 de 113 sesiones leía las 4 piezas (A12) | E 137 884 (`metodo,diseno`) | **recortada en el catálogo, no en el mecanismo** | El mecanismo cumple (frenó lo que tenía que frenar). Lo que sobra es **qué** exige: `metodo` pide las fichas enteras de Meadows, Saltzer y mutation testing (35 748), cuyo pilar **ya entró** inyectado; y el tramo 1578-1835 de `chequeo` (18 441), que `al-paso` (`freno`) inyecta en el momento en que hace falta. La base pide el HANDOFF entero (15 175) cuando lo vigente es el bloque de arriba. Meta `metodo,diseno` ≤ 75 000 (138 K − 36 K de fichas − 18 K de chequeo − 11 K de HANDOFF viejo). Lo que frenaba lo sigue frenando: la base (ESTADO, HANDOFF, PDP, contrato, naturaleza) no se toca, y `--autotest` + `--verificar` se corren después |
| `al-paso` | la viñeta entera en el momento del paso | 0 – 16 044 por sesión | cumple | — |
| `fase_activa` | el tipo de fase al tocar el proyecto | ~600 por proyecto | cumple | — |
| `guardia-fanout`, `guardia-heredoc`, `guardia-iso` | fan-out sin decidir; heredoc que rompe contenido; el ISO intocable | 0 salvo que frenen | cumple | `guardia-heredoc` frenó una vez en esta sesión, con razón |

### 7.3 Lo que la sesión escribe

| Pieza | Por qué existe | Costo | Veredicto | Resta |
|---|---|---|---|---|
| Cuadro PARA VOS | que Fran sepa qué cambió para él y cuánto falta | T 1 000 – 2 300 de salida | cumple | — (la forma corta en una pregunta suelta es pregunta de sensación, §8) |
| Cuadro de fase | que la sesión declare fase, modelo, esfuerzo y contexto | incluido arriba | cumple | ídem |
| Checkpoint de 4 (ESTADO + HANDOFF + commit + push) | la próxima sesión arranca de cero sin él | ~ 2 000 por cierre | cumple | (el costo real es que ESTADO y HANDOFF crecen sin techo: T3) |
| ESTADO / HANDOFF / retomes por proyecto | dónde quedamos | E: lo que la puerta exige | cumple | el techo es T3, no T12 |

### 7.4 Lo que se corre a mano o al cerrar

| Pieza | Por qué existe | Costo | Veredicto | Resta |
|---|---|---|---|---|
| Medidores (capa rápida, 10) | el estado se mide, no se lee | t ~40 s, en paralelo al arranque | cumple | — |
| Saboteadores (capa lenta) | un verificador que nunca falló está sin verificar | t ~14 min (A6) | cumple | partirlos es T6, no T12 |
| `aprender.py` con `--triage` y `--opuesto` | que una lección llegue a una sesión y que no sea una preferencia | ~ 1 000 por lección | cumple | — |
| Skills (7 propias) | procedimientos que se repiten | sólo su descripción en el listado | cumple | — |
| T11b: `--nivel` de la regla 15 | que la lección diga a qué nivel se arregló | ~ 0 | **entra** | barato y con freno |
| T11b: herramientas por clase en `--verificar` | que cada clase tenga respaldo | ~ 0 | **entra** | es un chequeo del catálogo, no una pieza |
| T11b: mensaje `nueva` en la puerta + contador en `medir-cascada` | necesidades abiertas | ~ 0 | **diferida** | sin un caso real de necesidad desconocida no hay impacto contra el cual diseñarla |
| T11b: medir sesiones fuera de todo proyecto | ver si la albañilería necesita puerta | una medición | **entra como medición**, no como pieza | — |

### 7.5 El orden de la poda, por lo que ahorra y lo que arriesga

| # | Poda | Ahorro estimado | Riesgo si se corta a mitad | Saboteador después |
|---|---|---|---|---|
| 1 | Catálogo de la puerta (`metodo`, `diseno`, rango del HANDOFF) | E −65 000 | ninguno: un JSON, se valida antes de guardar | `cascada_puerta --verificar` y `--autotest` |
| 2 | Enrutador a vista corta | S −40 000 | bajo: un `.md` | `verificar-estructura` + `probar-verificador` |
| 3 | Recordatorio a sólo el molde | T −3 500 | bajo en el repo; **se instala** | `verify-install` + `probar-hooks` |
| 4 | Reglas 10-12 y autoperfeccionamiento a puntero | S −6 000 | bajo en el repo; **se instala** | `verify-install` |
| 5 | `nested_memory` del perfil (renombrar la fuente) | S −18 000 al tocar el perfil | **medio**: toca `install.ps1` | `verify-install` + `chequeo-completo` |

1 y 2 son vivas en cuanto se guardan (archivos del repo). 3 a 5 tocan el
perfil y sólo actúan después de `install.ps1`, que va **después de la
renovación del plan**: es lo único que, cortado a la mitad, deja la máquina
sucia.
