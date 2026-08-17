# Auditoría del "Pipeline Metadev PS2"

Documento fuente: `pipeline-metadev-ps2.origen.txt` (en esta misma carpeta,
verbatim). Lo escribió Fran con Gemini, y llegó con una consigna precisa:

> *"Las ideas ya aplicadas, no las ignores, quizás crees que lo están pero no."*

Eso es exactamente el modo de falla de la lección 19 al revés: dar por
resuelto algo que sólo está escrito. Así que se auditó **ítem por ítem** —los
20 que propone el documento— contra lo que efectivamente corre, con cuatro
veredictos posibles:

| Veredicto | Qué significa |
|---|---|
| **YA ESTÁ** | implementado y verificado por efecto. Se dice dónde. |
| **A MEDIAS** | existía pero no cubría lo que decía cubrir. Se dice qué se completó. |
| **NUEVO** | no estaba. Se adoptó, y se dice dónde quedó. |
| **NO** | se rechaza, con la razón. Un rechazo sin razón se re-litiga solo. |

Fecha de la auditoría: 2026-08-17.

---

## 1. Ecosistema de ejecución

| # | Ítem del documento | Veredicto | Dónde / por qué |
|---|---|---|---|
| 1.1 | Claude en la nube no consume CPU/GPU/RAM local | **A MEDIAS** | Cierto y no es el dato que importa. El operativo es el inverso: una sesión en la nube **no llega** al PCSX2, al debugger ni a los puertos de tu máquina. Estaba escrito sólo en `black/CLAUDE.md`; se subió a global en `engineering-orchestrator` → Verificación, con la orden explícita de decirlo en vez de simular el resultado. |
| 1.2 | Claude Code (CLI oficial) | **YA ESTÁ** | Es donde corre todo esto. El perfil entero (`~/.claude/`, hooks, skills) es su mecanismo de configuración. |
| 1.3 | Cursor AI | **NO** | Es otro harness sobre el mismo modelo. Migrar significa reimplementar hooks, skills y `CLAUDE.md` en un sistema que no los tiene igual, y pagar API aparte del plan. Cero capacidad nueva. |
| 1.4 | Cline / Roo Code | **NO** | Mismo caso que 1.3, y además consumen créditos de API por fuera del plan Pro — el mismo motivo por el que Fable está prohibido (`enrutador-modelo`, regla cero). |
| 1.5 | Project Knowledge (200k) para anclar arquitectura | **NO** | Ese rol ya lo cumplen `CLAUDE.md` + `kb/` + `ESTADO_ACTUAL.md`, con dos ventajas que Project Knowledge no tiene: están versionados en git y los lee cualquier herramienta. Duplicarlos en la web crearía una segunda fuente de verdad que diverge en silencio. |

## 2. Optimización de datos, memoria y contexto

| # | Ítem | Veredicto | Dónde / por qué |
|---|---|---|---|
| 2.1 | **Context Loop**: la salida validada de un chat se guarda en disco y se reinyecta en el siguiente | **YA ESTÁ** | `ESTADO_ACTUAL.md` + `sesiones/HANDOFF.md` + `kb/*.json`, más el **mensaje de retome** (`cuadro-de-fase`), que es la pieza que el documento no tiene: no alcanza con guardar el estado, hay que dejar escrito qué decirle al chat nuevo para que lo lea. |
| 2.2 | **Bucle de metacognición**: al terminar, auditar los propios errores lógicos y escribir reglas de exclusión | **A MEDIAS → completado** | Existía en dos mitades desconectadas: la skill `lecciones-aprendidas` (24 lecciones largas, editada a mano = nivel 1, sólo dispara si alguien se acuerda) y `black/herramientas/aprender.py` (mecánico, pero encerrado en un proyecto: 5 lecciones, todas de BLACK). Ahora es uno solo y global: `perfil-global/herramientas/aprender.py` sobre `aprendizaje/lecciones.jsonl` (32 lecciones), con la síntesis en `chequeo-de-trabajo.md` inyectada por hook `SessionStart`. Ver lección 25. |
| 2.3 | Archivos `.prompt` / system prompts duros | **YA ESTÁ** | `perfil-global/CLAUDE.md` (se carga en toda sesión) + tres hooks que inyectan texto sin depender de que alguien los invoque. Es el nivel 3 de la tabla de la lección 11. |
| 2.4 | Estructuración XML (`<contexto>`, `<codigo>`, `<restricciones>`) | **NUEVO** | Adoptado en `engineering-orchestrator` → Optimización de contexto, con la salvedad de cuándo **no** usarlo: en un pedido corto es ceremonia. |
| 2.5 | Limpieza de historial: abrir hilo nuevo cuando acumula ruido | **YA ESTÁ** | Línea `Contexto` del cuadro de fase, con umbral concreto (~50%, cambio de fase, o lo que sigue no necesita nada de lo hablado) y el motivo técnico escrito: un resumen degrada primero lo que no se puede aproximar — direcciones, offsets, versiones. |

## 3. Infraestructura de ingeniería inversa (PS2)

Los cinco ítems (PCSX2 debugger, Ghidra/IDA/radare2, Emotion Engine R5900 y
el delay slot, VU0/VU1, DMA GIF/VIF) son **correctos y ya documentados**, pero
son del proyecto BLACK, no del perfil global: viven en `black/docs/01-entorno.md`,
`black/docs/05-iso.md`, `black/docs/06-herramientas-externas.md` y
`black/docs/90-glosario-ee.md`. No se suben a global — un perfil que arrastra
el glosario del Emotion Engine a una sesión de electrónica analógica es
contexto quemado.

Una nota de precisión, porque el documento generaliza donde ya hay una lección
concreta: "usar Ghidra para descompilar el ELF" es correcto y hueco al lado de
lo que costó aprender — Ghidra eligió solo `MIPS:LE:64:64-32R6addr`, reportó
`Analysis succeeded` con exit 0, y devolvió **1 función en 2,6 MB**. Forzando
el procesador real: 9842. Eso es la lección 18, y es la que hay que tener a
mano, no la recomendación de herramienta.

## 4. Persistencia total y realimentación

| # | Ítem | Veredicto | Dónde / por qué |
|---|---|---|---|
| 4.A | El estado vive en un `docs/architecture_knowledge.md` dinámico | **NO (el archivo), YA ESTÁ (la idea)** | La idea es correcta y está implementada mejor: `kb/*.json` legible por scripts, con `confianza` y `evidencia` por entrada, más `ESTADO_ACTUAL.md` para lo operativo. Crear el archivo nuevo con ese nombre sería una **segunda fuente de verdad** sobre lo mismo, que es la falla que la lección 15 describe: dos lugares con el dato correcto y sólo uno que manda. |
| 4.B | Cada chat es un procesador efímero: extrae del archivo, resuelve, devuelve refinado | **YA ESTÁ** | Es literalmente el ciclo del cuadro de fase + checkpoint de cierre (ESTADO_ACTUAL + HANDOFF + commit + push). |
| 4.C | El modelo evalúa su propia tasa de éxito y sugiere un perfil de razonamiento superior si falla | **NUEVO (con una corrección)** | Adoptado en `enrutador-modelo` → *Autocalibración*. La corrección importa: el documento escala directo al modelo, y eso es lo caro y lo menos probable. El orden implementado es **parámetro (lección 12) → instrumento (14, 18) → métrica (22) → recién ahí modelo/effort**. Subir a Opus con el parámetro equivocado compra una respuesta cara e igual de equivocada. Y el disparador se hizo observable —dos refutaciones seguidas, una búsqueda que no se achica, un resultado que contradice lo confirmado— porque "si notás que requiere más profundidad" no es un criterio, es una sensación. |

## 5. El system prompt metacognitivo

| # | Ítem | Veredicto | Dónde / por qué |
|---|---|---|---|
| 5.1 | Rol: Ingeniero de Sistemas Principal Autónomo, auto-optimizante | **YA ESTÁ** | `perfil-global/CLAUDE.md` + `engineering-orchestrator`, con el triángulo de hierro explícito (costo, planning, performance por encima de velocidad de respuesta). |
| 5.2 | Sin fricción: nada de saludos ni teoría genérica | **YA ESTÁ** | Regla 4 (cambios mínimos) y el estilo del perfil. El cuadro de fase es lo único obligatorio antes del contenido, y son tres líneas. |
| 5.3 | Si el usuario corrige un direccionamiento, asimilarlo como regla dura **en este hilo** | **A MEDIAS → mejorado** | La idea es correcta y el alcance estaba mal: una regla dura que vive "en este hilo" se muere con el hilo. Acá la corrección va al repo — `kb/` si es un dato, `lecciones.jsonl` si es de proceso — en el mismo turno. Es la regla 2 del perfil. |
| 5.4 | Evaluación de esfuerzo | — | Igual que 4.C. |
| 5.5 | **Bloque de telemetría al final de CADA respuesta** (Hito Técnico · Calibración · Estado · Saturación · Payload) | **NO** | Es, campo por campo, el cuadro de fase que ya va **al principio**. Ver el mapeo abajo. |

### El mapeo que justifica el único rechazo grande

| Campo del bloque de telemetría | Ya existe como |
|---|---|
| Hito Técnico | línea `Fase` — y con algo que el original no pide: **el criterio de salida** |
| Calibración Sugerida | línea `Modelo` — con el tramo y el disparador del cambio |
| Estado de la Sesión | `ESTADO_ACTUAL.md` + `kb/`, versionado, no re-tipeado cada turno |
| Saturación del Chat | línea `Contexto`, con umbral numérico |
| Payload de Transferencia | el **mensaje de retome**, que además dice qué leer y qué NO leer, el estado de la máquina y el primer comando |

Agregarlo habría significado un bloque duplicado en cada respuesta, para
siempre, a cambio de cero información nueva. Y una diferencia de diseño que no
es cosmética: el cuadro va **arriba** porque su función es cambiar lo que se
hace en ese turno. Al final ya no decide nada — describe.

---

## Lo que el documento acertó y no estaba

Dos cosas, y las dos se adoptaron: la **estructuración XML** (2.4) y sobre
todo la **autocalibración por fallo observado** (4.C), que era el hueco real
del perfil: había enrutado por *tipo de trabajo*, que es lo que se sabe antes
de empezar, y nada por *evidencia de que el tramo no está saliendo*.

Y una tercera, que es del documento entero y no de ningún ítem: la insistencia
en que la curva sea **estrictamente ascendente entre chats**. El perfil tenía
las piezas y una de ellas capturaba un solo proyecto. Eso quedó arreglado, y
la lección quedó escrita (25).

## Lo que se aprendió del ejercicio

Está en `lecciones-aprendidas` § 26: auditar ítem por ítem con cuatro cajones,
y **guardar la auditoría, no sólo la conclusión** — porque el documento va a
volver a aparecer, y sin esta tabla el trabajo se rehace entero.
