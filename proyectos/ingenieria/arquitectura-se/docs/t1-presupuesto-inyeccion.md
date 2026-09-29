# T1 — Presupuesto de inyección (A1): concepción, alternativas, elección y sonda

**Qué es.** El diseño de T1 del camino crítico
([`diagnostico-2026-09-28.md`](diagnostico-2026-09-28.md) §3): qué ve de verdad
la sesión de lo que el método le inyecta, qué se inyecta de ahora en más y cómo
se parte, y el medidor con su saboteador. Sesión del **2026-09-28**, en frío:
**ningún archivo vivo tocado** — todo lo medido salió de los transcripts, del
binario de Claude Code y de correr los medidores sin cambiarlos. **Es para que
Fran lo revise antes de construir** (compuerta de diseño: lo vivo se toca
después).

---

## 1. Concepción: lo medido

### 1.1 El umbral es 10 000 caracteres por hook — `confirmado`, por dos caminos

- **Código.** Claude Code 2.1.284
  (`%APPDATA%\Claude\claude-code\2.1.284\claude.exe`): la función que recibe la
  salida de cada hook hace `if (e.length <= s) return e` con `s = qUo = 1e4`, y
  se aplica a `stdout.trim()` **de cada comando de hook por separado** (también
  a `additionalContext` y `systemMessage`). Lo que pasa se guarda en un archivo
  y la sesión recibe una vista previa de `XEe = 2000` caracteres. `e.length`
  cuenta unidades UTF-16: para los `.md` inyectados, que son ASCII puro, es
  igual a caracteres.
- **Efecto.** Censo de **1 235 salidas de hooks** en todos los transcripts de
  la máquina (17/08 → 28/09): la más grande que entró entera tiene **9 666**; la
  más chica que se cortó figura como «10.0KB». El «KB» del harness es de
  **1024** (pilares: 12 863 bytes → «12.6KB»), así que esa midió al menos
  10 189. **Ninguna excepción** en 988 enteras y 247 cortadas.
- **Es por hook, no por evento ni total.** Tres hooks de 9 000 entran los tres.
  Eso es lo que hace posible partir.
- **Desde cuándo.** `chequeo-de-trabajo.md` entró entero por última vez el
  **21/08** (8 808 caracteres). El **22/08** pasó los 10 000 y desde entonces
  —**37 días**— la sesión ve sus primeros 2 000. `pilares.md` se corta desde
  que pasó los 10 000.

### 1.2 El segundo presupuesto: el tiempo — `confirmado`

`.claude/hooks/arranque-proyecto.ps1` (repo) tiene `timeout: 60` y corre la
capa rápida de `chequeo-completo.ps1`. Medido en los transcripts:

- Cuando termina tarda **33 a 59 s**; mediana de las últimas 15 sesiones,
  **58,6 s**. Su comentario dice «7,0 s medidos el 2026-08-29».
- **Se cortó por timeout en 13 de las últimas 30 sesiones** (16 en total),
  **incluida esta**. Cortado = **no llega nada**: ni la medición ni el texto fijo
  de `arranque.md` (las autorizaciones permanentes y el comando de apertura de
  cada proyecto), porque los dos salen del mismo proceso y el harness sólo
  entrega la salida de un hook que terminó.
- Por qué tarda, medidor por medidor, **en serie** (hoy): estructura 15,7 s,
  publicar-apuntes 10,4, sincronía 10,2, verificar-drive 7,7, verify-install 5,5,
  triage 0,1 → **~50 s**, más el arranque de PowerShell.
- **En paralelo no alcanza** (sonda): 39,5 s de pared, porque los dos
  medidores de Drive pasan de 10 y 8 s a **39 s cada uno** cuando corren
  juntos (mismo rclone, mismo token).
- Y **Fran espera** ese minuto — `probable`: en esta sesión el primer mensaje
  entró a la cola 0,27 s después del corte a los 60,2 s, que es lo que se
  vería si el harness retiene el mensaje hasta que terminan los hooks de
  arranque. Una sesión no alcanza para confirmarlo.

### 1.3 El medidor existía y estaba ciego por construcción — `confirmado`

`verify-install.ps1` ya corre cada hook bajo bash y cuenta lo que emite. Hoy
dijo: **`[OK] Hook SessionStart emite 134667 chars bajo bash`**. Medía el
efecto correcto (lo emitido, no el archivo) y **no tenía umbral**: da `OK` a
cualquier número mayor que cero. Es la regla 3 del perfil del lado que no
duele: una alarma que nunca dijo otra cosa que OK.

### 1.4 Inventario

| Hook | Evento | Emite hoy | Llega a la sesión |
|---|---|---|---|
| `apertura-proyecto.md` | SessionStart | 9 758 | entero, con **242** de margen |
| `pilares.md` | SessionStart | 12 863 | **2 000** (16 %) |
| `chequeo-de-trabajo.md` | SessionStart | 134 667 | **2 000** (1,5 %) |
| `arranque-proyecto.ps1` (repo) | SessionStart | ~3 500 (2 616 de texto fijo) | **nada en el 43 %** de las sesiones |
| `recordatorio-transversal.md` | UserPromptSubmit | 5 634 por prompt | entero; mediana 2 prompts por sesión |
| `fase_activa.py` (repo) | PostToolUse | ≤ 783 | entero |

Al arrancar hoy se emiten **~160 000** caracteres y llegan **~16 000**: la
apertura entera, 2 000 + 2 000 de vista previa, y el arranque en el 57 % de
las sesiones.

Datos de uso que condicionan el diseño (mediana sobre 165 sesiones con al
menos 5 llamadas): **87 llamadas a herramientas por sesión**; un hook de Python
por llamada cuesta **~200 ms** (`fase_activa.py`); el emisor de PowerShell,
**~550–700 ms**.

---

## 2. Criterios, escritos antes de elegir

**Mandatorios** (pasa o no pasa):

- **M1.** Todo hook emite **≤ 10 000** (rojo) y el diseño apunta a **≤ 9 000**
  (el margen que hoy le falta a la apertura).
- **M2.** Cada hook de arranque termina con margen antes de su timeout, y **lo
  que es texto fijo llega aunque la medición no termine**.
- **M3.** Nada se pierde: la fuente sigue siendo una sola
  (`chequeo-de-trabajo.md`, `lecciones.jsonl`, `pilares.md`); lo inyectado es
  **vista generada**, como las fichas.
- **M4.** Se desinstala solo (regla 6 del perfil).

**El criterio del 17/09**, que es de Fran y no se repondera acá: **lo que se
inyecta pesa menos, Y la lección del paso en curso está adentro.** Las dos
condiciones, no una a cambio de la otra. Se usa como filtro, no como puntaje:
por eso esta elección no necesita pesos nuevos.

---

## 3. Alternativas para `chequeo-de-trabajo` (el 83 % del peso)

El archivo tiene 15 secciones por **momento** («ANTES DE MEDIR», «AL LEER UN
NEGATIVO»…) de 1 a 33 KB, y 198 viñetas de ~670 caracteres, cada una con su
regla en la primera oración y su caso después.

| | Qué es | Pesa menos | La lección del paso adentro | Veredicto |
|---|---|---|---|---|
| **A** | Partir en 14 hooks de ≤ 9 000: llega todo | **no**: 133 K por sesión, y otra vez en cada compactación | no, y **ya medido**: el 17/09 la lección estaba en el contexto (línea 553 de 95 KB) y el error se cometió cinco veces igual | descartada por el criterio |
| **B** | Núcleo generado (momentos + la regla de cabecera de cada viñeta) y el detalle por puntero | sí | a medias: llega la regla, no el caso; y **el puntero no se sigue** (medido con Fran) | no alcanza sola |
| **C** | Sólo al paso: un hook detecta el momento por la herramienta y su resultado e inyecta el extracto | sí | sí donde el momento se ve desde afuera; **nada** para los que no | no alcanza sola |
| **D** | **B + C**: el núcleo al arrancar, el detalle al paso | sí | sí | **elegida** |

---

## 4. La sonda (en frío, contra los transcripts reales)

**S1 — ¿Cabe el núcleo?** Las 198 reglas de cabecera suman **18 308**
caracteres (mediana 82 por regla, p90 132); recortadas a 120, **17 468**. **No
entran en un hook; sí en dos** de ≤ 9 000, cortando en frontera de sección. El
núcleo pesa **−87 %** que el archivo de hoy y lleva **todas** las reglas.

**S2 — ¿Qué momentos se detectan desde afuera?** Un clasificador por
herramienta y resultado, repetido sobre las llamadas reales de 165 sesiones:

| Momento | % de sesiones | Primera vez, llamada n.º (mediana) | Lectura |
|---|---|---|---|
| creerle a un resultado (salida con OK/verde/PASS) | 98 | 4 | **no discrimina** |
| leer un negativo (sin resultados, «not found») | 93 | 4 | **no discrimina** |
| estado de la máquina (ESTADO, HANDOFF, git status/log) | 89 | 9 | **no discrimina** |
| medir (medir/verificar/probar) | 83 | 14 | **no discrimina** |
| git | 85 | 42 | casi universal |
| typst | 30 | 26 | discrimina |
| pcsx2 | 19 | 47 | discrimina |
| **poner un freno** (Write/Edit sobre hooks, guardias, verificadores, settings) | **17** | 48 | discrimina |
| rclone | 9 | 14 | discrimina |
| **fan-out** (Agent/Task/Workflow) | **7** | 42 | discrimina |

Sin deduplicar, **58 disparos por sesión**: ruido. Con deduplicado (un momento
una vez por sesión) y un extracto de 3 000, **16 500 por sesión** de mediana.

**Lo que cambia del diseño:** los cuatro momentos que disparan en casi toda
sesión y en las primeras llamadas **van al núcleo**: «al paso» ahí sería lo
mismo que «al arrancar», con más costo. **Al paso** van sólo los que
discriminan: poner un freno, fan-out, la GUI de escritorio y cada herramienta
con viñetas propias (rclone 7 viñetas / 5,0 K, typst 7 / 7,2 K, pcsx2 10 /
7,5 K, ghidra, gh, git 16 / 11,6 K recortado).

**S3 — ¿Paralelizar el arranque alcanza?** No (1.2): 39,5 s, atado a Drive.
Lo que alcanza es **separar** el texto de la medición y ponerle a la medición
una **fecha límite propia**.

---

## 5. La elección

| Hook | Hoy | Queda | Emite |
|---|---|---|---|
| `apertura-proyecto.md` | 9 758 | igual; **amarillo** hasta bajar de 9 000 (candidato: el molde de los cuadros, que ya va entero en el recordatorio de cada prompt) | ≤ 9 000 |
| `pilares.md` | 12 863 | **dos hooks**, corte en frontera de sección; la fuente sigue siendo un archivo | 2 × ~6 400 |
| `chequeo-de-trabajo.md` | 134 667 | **núcleo generado** en dos hooks: cómo funciona (al paso + `aprender.py buscar`) + cada momento con la regla de cabecera de cada viñeta. Se regenera en `install.ps1`, como las fichas | 2 × ≤ 9 000 |
| `arranque-proyecto.ps1` | ~3 500 en 58 s, 43 % perdido | **dos hooks**: el texto fijo solo (instantáneo) y la medición con **fecha límite interna de 40 s** que entrega lo que terminó y **nombra** lo que no. No corre en `compact` | ~2 600 + ~1 000 |
| **al paso** (nuevo, del perfil) | — | Python en PreToolUse/PostToolUse: por clave (freno, fan-out, GUI, herramienta) inyecta las viñetas de esa clave **una vez por sesión** (estado por `session_id`) | ≤ 9 000 por disparo |

**Resultado esperado al arrancar:** se emiten **~45 000** y llegan los 45 000
(hoy: 160 000 emitidos, 16 000 llegan). Es la condición «pesa menos» sobre lo
emitido (−72 %) y la primera vez en 37 días que lo emitido y lo recibido son lo
mismo.

**Lo que no se toca:** el recordatorio por prompt (5,6 K, entra entero y es el
que sostiene los cuadros) y `fase_activa.py`.

---

## 6. El medidor y su saboteador

**`perfil-global/herramientas/medir-inyeccion.py`**, en los medidores de
`chequeo-completo.ps1`. Dos mitades, porque cada una ve lo que la otra no:

1. **Antes (lo emitido).** Lee los `settings.json` del perfil y del repo, corre
   cada hook de SessionStart y UserPromptSubmit **como lo corre el harness**
   (bajo bash), y mide `len(stdout.strip())` y la duración. Al hook al paso lo
   corre con una entrada sintética por cada clave. **Rojo** > 10 000 o duración
   > timeout; **amarillo** > 9 000 o > 50 % del timeout. El hook de medición del
   arranque se saltea con una variable de entorno (si no, se mide a sí mismo en
   bucle); lo cubre la otra mitad.
2. **Después (lo que el harness hizo).** Lee los transcripts de las últimas
   sesiones del proyecto: toda salida de hook con `<persisted-output>` o todo
   `hook_cancelled` posterior al último cambio de los `settings.json` es
   **rojo**, con hook y fecha. Es el efecto medido sobre el objeto: no depende
   de reproducir el harness.

**`probar-medir-inyeccion.ps1`**, sobre un `settings.json`, un emisor y
transcripts **sintéticos** en una carpeta temporal (nunca sobre `~/.claude`:
la lección de `probar-chequeo-lecciones.ps1`): 9 999 → verde; 10 001 → rojo;
9 500 → amarillo; un hook que duerme más que su timeout → rojo; un transcript
con `<persisted-output>` → rojo; uno con `hook_cancelled` → rojo; el caso
limpio → verde (control).

Y `verify-install.ps1` deja de dar `OK` a cualquier número: su chequeo de
hooks pasa a usar el mismo umbral, o se le saca y queda uno solo. Dos
medidores del mismo dato divergen.

---

## 7. Orden de construcción (sesiones siguientes)

1. El medidor y su saboteador **primero**: tiene que dar **rojo sobre el estado
   de hoy** (pilares, chequeo, el timeout del arranque) y amarillo en la
   apertura. Un medidor que nace en verde está sin verificar.
2. El arranque partido (repo). → verde en tiempo.
3. Pilares en dos hooks. → verde.
4. El núcleo generado de chequeo. → verde.
5. El hook al paso, con su propio saboteador (cada clave → extracto ≤ 9 000;
   la segunda vez en la misma sesión → nada).
6. **Validación (P10):** a las 3–5 sesiones reales, la mitad «después» del
   medidor tiene que dar **0 cortados y 0 cancelados**, y el tiempo de arranque
   bajar de ~60 s a ~40 s. Eso cierra A1.

**Avance (2026-09-28, 2.ª sesión): pasos 1 y 2 construidos.** El medidor
nació en rojo sobre el estado de hoy y su saboteador va 10/10 (ver
`ESTADO_ACTUAL.md`). Dos notas de construcción, sin cambio de diseño: el
timeout por defecto de un hook sin `timeout` se toma 60 s (`hipótesis`: no se
encontró en el binario); y **S3 queda corregida**: `publicar-apuntes
-Verificar` es bimodal corriendo solo (10–11 s o 45–46 s), así que la lentitud
en paralelo no era contención con el otro medidor de Drive. La conclusión de
S3 (paralelizar no alcanza; hace falta la fecha límite) se sostiene igual.

**Avance (2026-09-28, 3.ª sesión): pasos 3 y 4 construidos; la capa rápida
entera en verde.** El paso 2 pasó su primera sesión real (0 `hook_cancelled`).
Tres notas de construcción:

- **El corte lo hace el lanzador** (`emitir-contexto.ps1 archivo parte de`),
  al emitir: la parte es una vista que no puede quedar vieja, y la fuente
  instalada sigue verificándose por hash. Empaca secciones hasta 9 000; si el
  archivo pide más partes que hooks registrados, la última se lleva el resto
  y el medidor da rojo (saboteador, casos 11 y 12). Pilares: 7 940 + 4 791.
- **El núcleo va en cuatro hooks, no en dos.** Medido: las 200 cabeceras
  suman ~17 800 enteras y, con el preámbulo y las oraciones que se suman
  cuando la primera abre una lista, 25 914. Ni con tope de 90 por cabecera
  entraba en 2 × 9 000, y el corte es por momento: «antes de confiar en una
  herramienta» sola ocupa 7 800. Queda 6 831 / 3 732 / 7 790 / 7 764. No es
  cambio de diseño —M1 es ≤ 9 000 **por hook**; el «2» era una estimación—,
  pero sí un **riesgo nuevo**: un momento que pase ~8 900 no entra en ningún
  hook. Lo emitido al arrancar queda en ~51 000 (esperado ~45 000).
- **`install.ps1` retira lo que sale del manifiesto.** Reemplazaba por
  archivo, y así la entrada vieja de `pilares.md` quedaba viva al lado de las
  partes. Ahora toda entrada que invoca el lanzador es suya y por evento deja
  exactamente `Get-Ganchos` (M4).

**Avance (2026-09-28, 4.ª sesión): paso 5 construido.** `hooks/al-paso.py`,
seis claves (freno, fanout, gui, rclone, typst, pcsx2), saboteador 20/20
(`probar-al-paso.ps1`) y medido por `medir-inyeccion` con una entrada por
clave. Tres notas, sin cambio de diseño:

- **Sólo PreToolUse.** Toda clave se detecta por la herramienta y su entrada,
  así que no hace falta PostToolUse; `additionalContext` en PreToolUse llega
  (`confirmado`: se vio en la sesión que lo instaló, recargado en caliente).
- **El tope se mide sobre stdout**, no sobre el texto: el JSON escapa cada
  salto de línea y eso cuenta contra el corte de 10 000.
- **`freno` no entra entero** (31 viñetas, salen 16 en ~8 400): el pie del
  extracto cuenta las que faltan. Entregar el resto en la segunda llamada de la
  clave sería un cambio de diseño («una vez por sesión»), así que queda anotado
  y no hecho.

**Riesgos:** el clasificador al paso inyecta donde no hace falta (se ve en
S2: por eso sólo claves que discriminan, y deduplicado); el harness cambia el
umbral en una versión nueva (lo atrapa la mitad «después» del medidor, que no
asume el número); los 200 ms por llamada del hook de Python (~17 s por sesión
de 87 llamadas; si pesa, se une con `fase_activa.py` en un solo proceso).
