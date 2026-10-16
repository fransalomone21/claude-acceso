# T17 — los conectores bajo la puerta

**Sesión del 2026-10-16.** Fila 2 de la lluvia §6. Cierra **DA-046** («la estructura de control cubre una lista
cerrada de actuadores; todo actuador nuevo entra sin pasar por ningún freno»). Decisión de Fran (lluvia §7, 2026-10-12
16:45): **frenar compartir y publicar salvo lo declarado.** Requisitos: [`10-requisitos.md`](10-requisitos.md) §8
(N-10, L0-08, L1-12, L2-PTA-07..17, L2-VER-03; 0 VIOLA del GtWR extrayendo la columna Requisito).

## 1. Pérdida y peligro (Leveson, antes del control)

- **Pérdida:** algo personal o de terceros —datos de salud, documentos de identidad, mails de compañeros, material de
  cátedra que no se publica— queda al alcance de alguien que Fran no eligió.
- **Peligro, como estado del objeto:** *un objeto de Drive tiene un permiso que lo hace legible por alguien distinto de
  Fran y ese par objeto-destinatario no está en la Declaración_De_Audiencia*; o, la misma cosa por herencia, el objeto
  vive en una carpeta cuya audiencia no se eligió para él. No es «alguien llamó a `share_file`»: es el permiso en el
  objeto. Por eso hay dos capas y no una: la puerta (antes de la llamada) y `verificar-drive.ps1` (el permiso medido
  en el objeto, al arrancar). La puerta es la nueva; la segunda ya existía y sigue siendo la que mide el peligro.

## 2. La pregunta de marco: qué conectores hay de verdad (medido, no enumerado)

`session_connectors_status` el 2026-10-16, y los esquemas de cada herramienta cargados con ToolSearch:

| Servidor | id | Herramientas | ¿Puede crear el peligro? |
|---|---|---|---|
| Google Drive | `094616df-…` | 11: 6 de lectura, `share_file`, `create_file`, `copy_file`, `update_file`, `trash_file` | **sí**: `share_file` agrega un destinatario; `create_file`/`copy_file`/`update_file` con `parentId` ponen el objeto bajo la audiencia de otra carpeta (en Drive el permiso se hereda hacia abajo) |
| Claude Docs | `1a59c906-…` | 8 | **no**: su guía (`topic.sharing`) dice que ninguna herramienta comparte; compartir es un botón de Fran en claude.ai |
| visualize | `6f616b42-…` | 2 | no: dibuja en el chat |
| Artifact (nativa) | — | publish, delete, pin | no: la página nace privada; compartirla es un acto de Fran |
| navegadores, `mcp__terminal__run_in_terminal` | — | abiertos | **sí, y fuera de este alcance** (§6) |

**Qué tendría que ser verdad para que esto fuera el problema equivocado:** que el camino real de exposición no fueran
los conectores sino el navegador o la terminal. Medido: los dos existen y pueden publicar, pero su universo es abierto
(cualquier sitio, cualquier comando) y no admite lista blanca por nombre; los conectores sí. Este es el problema
correcto para una puerta por permiso; los otros dos quedan registrados como defectos aparte.

El uso legítimo también está medido: el 2026-10-13 una sesión creó por el conector la carpeta del TP4 de Software de
Vuelo y la compartió con cinco compañeros, a pedido de Fran (`estructura-drive.json`, `compartido-con-nombre`). El
freno tiene que dejar pasar eso cuando está declarado, o se lo termina sacando.

## 3. El diseño: permiso por lista blanca (Saltzer)

Dos archivos, cada dato con un dueño (T20):

- **`.claude/conectores.json`** (nuevo, Catálogo_De_Conectores): cada conector por su id y la **clase** de cada
  herramienta. Clases: `lectura` y `privado` (pasan), `comparte`, `ubica`, `papelera` (pasa: es reversible y no cambia
  la audiencia). Un conector o una herramienta sin clase **niega** (L2-PTA-07, -08): un conector nuevo entra frenado
  hasta que se lo clasifica.
- **`.claude/estructura-drive.json`** (ya existía; Declaración_De_Audiencia): se le agrega el `id` a los pares de
  `compartido-con-nombre` que se conocen, y la sección `destinos-del-conector` con las carpetas privadas por id.

Lo que decide la puerta, por clase:

| Clase | Pasa si… | Niega si… |
|---|---|---|
| `comparte` (`share_file`) | hay una entrada de `compartido-con-nombre` con `id` = `fileId`, el hash del destinatario en `quien-sha256` y un `rol` ≥ el pedido | cualquier otra cosa (L2-PTA-10, -11) |
| `ubica` (`create_file`, `copy_file`, `update_file`) | no trae `parentId` (raíz de Mi unidad, privada; o la misma carpeta del original; o un renombre), o el `parentId` es un destino privado declarado o una carpeta compartida declarada | el `parentId` es la carpeta pública (L2-PTA-13) o no está declarado (L2-PTA-14) |

- **El hash** es el de `verificar-drive.ps1` (sha256 del mail recortado y en minúsculas, primeras 16 cifras): el repo es
  público y los mails son de terceros. Para un espacio de Chat se hashea su id igual.
- **La carpeta pública no se toca por conector**: lo público sale sólo por `publicar-apuntes.ps1`, con su lista y su
  MD5. Un segundo camino es exactamente el camino paralelo de DA-046.
- **El enganche** es un matcher de `.claude/settings.json` que sólo atrapa herramientas con id de conector
  (`mcp__` + el patrón 8-4-4-4-12): las herramientas del harness (`mcp__ccd_*`, el navegador) no pagan el proceso. Lo
  verifica `--verificar` en cada arranque (L2-VER-03).
- **La caja negra** registra cada decisión con la herramienta, el objeto, el veredicto y el motivo; el destinatario va
  como hash (L2-PTA-17).

## 4. Las cuatro formas de fallar (Leveson)

| Forma | Cómo podría pasar | Qué la cubre |
|---|---|---|
| no actuar | un conector nuevo con nombre de otra forma (sin el id hexadecimal) no matchea | **límite declarado**: el disparador observable es un servidor nuevo en `session_connectors_status` con herramientas `mcp__<nombre>__…`; se agrega al matcher |
| actuar mal | la lista blanca deja pasar algo que comparte | clases por herramienta, no por verbo; `verificar-drive.ps1` mide el objeto igual |
| actuar tarde | — | la decisión es PreToolUse, antes de la llamada |
| dejar de actuar | el matcher se borra del registro | `--verificar` da ROJO en el arranque (L2-VER-03), con saboteador |

Y los caminos de salida temprana (Saltzer): catálogo ilegible → niega (L2-PTA-16); declaración ilegible → lista vacía
→ niega `comparte` y `ubica`; la puerta revienta → el lanzador niega (su política).

## 5. Verificación

- Autotest de la puerta, **caso 19**: controles positivos (lectura, privado, compartir declarado, ubicar en destino
  declarado, sin `parentId`) y sabotajes (conector desconocido, herramienta sin clase, destinatario sin declarar, rol
  mayor, carpeta pública, carpeta sin declarar, catálogo roto), con **mutantes vistos en su caso**.
- `probar-t17.py`: el verificador sin el matcher da ROJO; con el matcher, verde.
- **Efecto en la sesión real** (L1-12): una llamada de conector que comparte algo sin declarar sale NEGADA por la
  puerta con el motivo; una declarada pasa; `cascada_puerta.py --estado <sesión>` muestra las dos.

## 6. Lo que T17 no cubre, con su motivo

- **El navegador y la terminal** (`mcp__terminal__run_in_terminal` corre comandos en la terminal de Fran y no pasa por
  el matcher de Bash: tampoco lo ve la puerta de la cascada). Universo abierto: la lista blanca no aplica, y lo que
  queda es medir el objeto. La terminal quedó registrada como **DA-059**.

## 7. Lo medido al construir (2026-10-16)

- Autotest de la puerta: caso 19 con 17 casos (8 controles, 9 sabotajes), la caja negra y **4 mutantes vistos en su
  caso** (conector desconocido, destinatario sin comparar, rol ignorado, carpeta pública), cada uno juzgado sólo si su
  caso pasó sano en la misma corrida. `probar-t17.py`: 4 de 4 (dos rojos buscados, dos controles).
- `--verificar` dio **ROJO con el registro real antes de enganchar el matcher** y verde después (el defecto, visto).
- **Efecto en la sesión real** (`f475a5d5`): crear en una carpeta sin declarar → NEGADA; crear un archivo de prueba en
  `_REVISAR` (declarada) → pasó; compartirlo con un destinatario sin declarar → NEGADA; mandarlo a la papelera → pasó.
  `--estado` muestra las cuatro, con el destinatario como hash y ningún mail en claro.
- Medido de paso: 01 UNSAM y GRUPOS tienen sólo al dueño (`get_file_permissions`), por eso son destinos privados.
- `chequeo-completo`: un rojo de verdad en la primera corrida — los mails inventados del autotest los marcó la regla 5
  del repo público (la lección existía); se arman por partes. En la segunda, todo verde salvo «listo para la nube»
  antes del push, verde al re-medir.
- **Las sesiones abiertas fuera del árbol** (`puerta-afuera.py` no engancha conectores). Fran abre siempre en
  `claude-acceso`; queda anotado.
- **La declaración la escribe la sesión.** Igual que `apuntes-publicos.json`: declarar es un acto con commit, y la
  caja negra y `verificar-drive.ps1` lo dejan a la vista. El freno es contra el error (publicar sin querer), no contra
  una sesión que quiera saltearlo.
