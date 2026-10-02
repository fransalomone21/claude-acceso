# T11 — La cascada que se ejecuta: lectura obligatoria por necesidad, con puerta

**2026-10-02.** Pedido de Fran al cerrar BLACK (110): *«ejecutar la cascada
obligatoria… que según MIS NECESIDADES se lean en cascada los documentos
relacionados… para que NUNCA vuelva a pasar que algo útil y necesario de la
arquitectura sea omitido»*. Y la imagen que lo resume: *«podés ser el mejor
arquitecto del mundo, pero si dependés de un libro y te lo olvidás en tu casa
cada día que vas a la oficina, estamos en el horno»*.

Es una tarea nueva del diagnóstico (`diagnostico-2026-09-28.md`): **A12**, el
problema, y **T11**, su arreglo. Entra en la fase 7 como T1: diseño escrito,
saboteador primero, construcción, y validación en sesiones reales.

---

## 1. Lo medido — A12: la cascada existe y no se ejecuta (`confirmado`)

Censo sobre los transcripts reales (`perfil-global/herramientas/medir-cascada.py`,
nacido de esta medición): por cada sesión y cada proyecto que la sesión tocó
con una **acción** (Edit, Write, o un comando que nombra el proyecto y no es
de sólo lectura), qué había leído **antes** de esa primera acción.

| Desde el 2026-09-01 (113 entradas sesión × proyecto) | Antes de la 1.ª acción |
|---|---|
| corrió `cascada.ps1` | 24 |
| leyó `ESTADO_ACTUAL.md` | 21 |
| leyó el `HANDOFF` | 24 |
| leyó el contrato (`CLAUDE.md` del proyecto) | 13 |
| leyó el `PDP` | 4 |
| **leyó los cuatro** | **1 de 113** |
| BLACK: corrió `abrir-sesion.ps1` | 7 de 28 |

Grado: `probable` en el número fino (el censo no ve lecturas por otros caminos,
como un retome pegado en el chat que copia el estado), `confirmado` en el orden
de magnitud: aun contando generoso, la cascada no se ejecuta. La primera
versión del censo contaba la propia lectura (`Get-Content …ESTADO…`) como
«primera acción» y daba 0 de 118; se corrigió antes de creerle.

**Y los casos que lo hicieron visible:**

- **BLACK (110):** la sesión no corrió los medidores ni la apertura de BLACK
  (que incluye la integridad del ISO). Fran lo notó; nada lo frenó.
- **El insumo del 29/09** (`insumo-2026-09-29-sesion-ides.md`): Fran corrigió
  **tres veces en vivo** preferencias que ya había pedido en otros proyectos
  (método del profe primero, formato de la casa, público ≠ personal).
  Vivían en un contrato ajeno y en memorias que ninguna capa trae.
- **Las fichas de ingeniería de sistemas** (NASA, INCOSE, Rechtin: ~900 KB,
  la base de esta reforma) sólo están indexadas en el contrato de
  `arquitectura-se`. Una sesión de BLACK que diseña o elige entre
  alternativas no tiene ningún camino que la lleve a ellas.

## 2. Por qué escribirlo más fuerte no sirve

`arranque.md` ya dice, en mayúsculas y en cada sesión, *«ENTRAR A UN PROYECTO
ES UN COMANDO, NO UN ACTO DE MEMORIA»*. Resultado: 24 de 113. Es la trampa de
Meadows en limpio: una regla que se incumple no se escribe más fuerte; se le
agrega el lazo que falta. El texto ya **llega** (T1 lo arregló); lo que no
existe es algo que **frene** la acción mientras el libro sigue en la casa.

Y no se puede «inyectar todo»: el harness corta a 10 000 caracteres por hook
(T1, `confirmado`), los documentos del nivel 5 de BLACK pesan 373 KB y las
fichas de pilares 900 KB. La pregunta no es cómo meter más texto: es **qué
lectura es obligatoria para esta necesidad**, y cómo **medir que ocurrió**.

## 3. La elección

| Alternativa | Qué hace | Por qué no / por qué sí |
|---|---|---|
| A. Texto más fuerte | Repetir la orden | Ya está; 1 de 113. Parámetro disfrazado |
| B. Inyectar al tocar el proyecto | Como `fase_activa` | 10 K por hook; inyectar no es leer (T1: 2 KB de 129) |
| **C. Puerta por permiso** | **No deja actuar sobre un proyecto hasta que la sesión LEYÓ (con la herramienta Read) lo que su necesidad exige** | **Mide el efecto —el contenido entró al contexto—, no la intención. Saltzer: permiso explícito, falla negando, se nota rápido** |

**Elegida la C.** Es un freno, así que nace con sus cuatro formas de fallar
escritas (Leveson) y su suite de dos mitades.

## 4. El diseño

### 4.1 Dos ejes, como los pidió Fran

1. **La necesidad** (qué hace falta resolver): `materia`, `ingenieria-inversa`,
   `diseno`, `metodo`, `investigar`, `publicar`, `ninguna`. La **declara la
   sesión** —clasificar un pedido en lenguaje natural no tiene criterio
   mecánico; se aumenta, no se reemplaza— con
   `.\cascada.ps1 <proyecto> -Necesidad a,b`. La puerta **obliga** a declarar:
   el momento de clasificar no se puede saltear.
2. **La naturaleza del concepto que la resuelve** (con qué se resuelve):
   `typst`, `freno`, `pcsx2`. Esto **no** se declara: se **observa** en la
   llamada misma (un `typst compile`, un Edit a un hook, un lanzamiento de
   PCSX2), con la misma idea que el hook al paso de T1.

Cada proyecto tiene además **necesidades por defecto** (BLACK siempre es
`ingenieria-inversa`; un apunte siempre es `materia`), que se suman a lo
declarado.

### 4.2 Las piezas

| Pieza | Qué es | Dueño del dato |
|---|---|---|
| `.claude/cascada.json` | El **catálogo**: la base (niveles 3-5 con su rango), las necesidades, los conceptos y las necesidades por defecto de cada proyecto | único; todo lo demás lo lee |
| `.claude/hooks/cascada_puerta.py` | La **puerta** (PreToolUse), el **registro de lecturas** (PostToolUse) y la CLI que calcula lo exigido | una sola implementación: la usan el hook y `cascada.ps1` |
| `cascada.ps1 -Necesidad / -Excepcion` | Imprime lo exigido con rutas y rangos exactos y el menú de necesidades | delega en el `.py` |
| `perfil-global/herramientas/medir-cascada.py` | El censo de §1, como medidor de validación | transcripts |

### 4.3 Qué exige la base (todo proyecto, al primer acto)

| Nivel | Documento | Rango exigido |
|---|---|---|
| 3 | `plantillas/naturalezas/<nat>.md` | entero |
| 4 | el contrato del proyecto | entero |
| 5 | `ESTADO_ACTUAL.md` | la **vista**: hasta el 2.º título `##`, tope 300 líneas |
| 5 | el `HANDOFF` (se busca en el disco) | la **vista**: hasta el 2.º `##`, tope 300 |
| 5 | `PDP.md` | la sección `## 4` (fases y qué las cierra) |
| — | los **comandos** de apertura del proyecto | haberlos corrido (BLACK: `abrir-sesion.ps1`) |

Los topes existen porque el nivel 5 de BLACK no entra en una lectura (ESTADO
121 KB, HANDOFF 252 KB). **El tope no es el arreglo, es la señal**: un
documento de estado que no entra en su vista es A2, y lo arregla T3.

### 4.4 La puerta, paso a paso

1. Una llamada Edit / Write / NotebookEdit / Bash / PowerShell que **nombra un
   proyecto** (ruta en la entrada o en el `cwd`) y **no** es de sólo lectura.
2. ¿La sesión declaró la necesidad para ese proyecto? Si no → **deny** con el
   comando exacto y el menú.
3. ¿Leyó cada rango exigido y corrió cada comando? Si no → **deny** con la
   lista de lo que falta, con `offset` y `limit` para leerlo.
4. Igual para los **conceptos** que la llamada dispara, haya proyecto o no.
5. Si todo está → deja pasar en silencio.

**Sólo lectura** = el comando empieza con una lectura conocida (`git log`,
`Get-Content`, `cascada.ps1`, `abrir-sesion`…) **y** no encadena nada
(`;`, `&&`, `||`, `>`, ni un pipe a algo que no sea un filtro). Un comando
compuesto que esconde una acción detrás de una lectura **no** pasa: todo
camino de salida temprana de un freno es un fail-open hasta que se pruebe.

**La salida explícita:** `.\cascada.ps1 <proyecto> -Excepcion "motivo"`. Deja
pasar ese proyecto en esa sesión y queda **registrada** con su motivo
(`~/.claude/hooks/cascada-excepciones.log`). Es la salida que T4 pide para
toda puerta: declarar una excepción es un acto, no un silencio. Cuántas se
usan es un dato de la validación.

**Compactar borra lo leído.** Un resumen degrada primero lo que no se puede
aproximar; después de compactar, las lecturas viejas no cuentan y la puerta
vuelve a pedir la vista. Las declaraciones sí sobreviven.

**El estado** es por sesión (`%TEMP%\claude-cascada\<session_id>.jsonl`, sólo
se agrega): dos sesiones en el mismo árbol (A11) no se pisan.

### 4.5 Las cuatro formas de fallar (Leveson), contestadas

| Forma | Cómo se manifestaría | Qué la ataja |
|---|---|---|
| No actuar | deja pasar sin lectura | autotest: cada caso de deny en rojo si la puerta calla; `medir-cascada` en sesiones reales |
| Actuar mal | frena lo legítimo (lectura pura, otro proyecto) | controles positivos del autotest: lectura pura, ruta fuera de `proyectos/`, todo leído |
| Actuar tarde | frena después del daño | es PreToolUse: decide antes de la llamada |
| Dejar de actuar | catálogo roto, Python ausente, hook desinstalado | catálogo roto → **deny** con el error (falla cerrado); el verificador del catálogo en la capa rápida; `probar-hooks` mide el registro |

**La salida de reparación:** editar `.claude/hooks/cascada_puerta.py` o
`.claude/cascada.json` nunca lo frena la propia puerta; si todo falla,
`.claude\desinstalar-hooks.ps1` la saca entera (regla 6).

## 5. Qué NO resuelve, declarado

- **Leer no es entender.** La puerta mide que el texto entró al contexto, no
  que la sesión lo use. Eso lo mide la validación (§6): que Fran deje de
  corregir lo que ya estaba escrito.
- **La clasificación de la necesidad es juicio de la sesión.** Una sesión que
  declara `ninguna` para un apunte se saltea `materia`. Lo atenúan las
  necesidades por defecto de cada proyecto, que no dependen de la sesión.
- **Las vistas son un parche hasta T3.** Hasta que ESTADO y HANDOFF sean
  vistas cortas de verdad, el tope de 300 líneas puede dejar afuera algo
  vigente de BLACK y de `fisica-espacial`.
- **Un libro que no está en el catálogo no se exige.** El catálogo es lo que
  hay que mantener; su verificador dice qué ruta no existe y qué proyecto no
  tiene entrada, no qué libro falta.

## 6. Verificación y validación

**Verificación** (que la pieza hace lo que dice):
`python .claude/hooks/cascada_puerta.py --autotest` — sabotajes (sin
declarar, declarado sin leer, lectura parcial, comando compuesto, compactación,
concepto sin leer, catálogo corrupto) que tienen que dar **deny**, y controles
positivos (todo leído, lectura pura, fuera de proyecto, excepción) que tienen
que dar **pasa**. Y `--verificar`: cada ruta del catálogo existe, cada
proyecto del disco tiene entrada, ningún rango pasa lo que entra en una
lectura. Corre en `probar-hooks.ps1` y en la capa rápida.

**Validación** (que sirve): en las próximas **5 sesiones reales** con
proyecto (Fran, 2026-10-02: «más de 3»), `medir-cascada.py` tiene que dar **las lecturas exigidas completas
antes de la 1.ª acción en el 100 %** de las entradas (contra 1 de 113), con
las excepciones contadas y su motivo legible; y **ninguna corrección de Fran
por algo que ya estaba escrito en un documento exigido**. La primera es la
sesión de BLACK que retoma COOP-B.

## 6 bis. Lo que Fran agregó al ver la primera versión (2026-10-02)

- **Las necesidades son abiertas.** Si una no encaja, se declara `nueva`: se
  escribe como requisitos verificables y de ahí salen qué leer y con qué
  herramienta; si va a volver, su clase entra al catálogo en esa sesión.
  Una necesidad desconocida sigue frenando: o se crea la clase, o es `nueva`.
- **Herramientas y respaldo por tarea.** Cada clase lista sus herramientas y
  qué guardar antes de intervenir; `cascada.ps1` los imprime al declarar.
- **Ingeniero aunque sea albañilería**, y **un error evitable frena la tarea y
  se arregla uno o n niveles más arriba** (reglas 14 y 15 del perfil).

## 7. Costo, medido contra lo que pidió Fran

Fran dijo *«aunque cueste tokens para siempre»*. La regla 9 del perfil dice
que el presupuesto del plan gana sobre cualquier instrucción de
exhaustividad, así que el costo se mide y se informa en vez de suponerse: la
base de un proyecto chico ronda 15-25 K caracteres; con una necesidad, 30-70 K
(≈ 10-20 K tokens, una vez por sesión y proyecto). Con un contexto de 1 M es
el 1-2 %. **Lo que se paga es una vez por sesión, no por turno.**
