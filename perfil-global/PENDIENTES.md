# Pendientes del perfil

Lo que le falta al perfil **mismo**. No se inyecta por hook: es estado de este
proyecto, y una sesión de BLACK no gana nada leyéndolo. Vive acá por la tabla
de memorias de [`CLAUDE.md`](CLAUDE.md) — estado del proyecto, en el repo del
proyecto.

Antes de repetir que algo de acá sigue abierto: verificalo. Un documento no se
entera de que alguien lo cerró.

---

## 1. La alarma sin probar — `verify-install.ps1` — RESUELTO (2026-08-17)

`verify-install.ps1` verifica por **efecto** (corre los hooks por Git Bash y
mide lo que emiten), que es lo correcto. Pero nadie había roto la instalación
a propósito para ver si se pone en rojo. Por la regla del saboteador (regla 3
de `CLAUDE.md`), era una alarma sin probar: no se sabía si verificaba o si
siempre decía que sí.

Se rompieron los cuatro modos, de a uno, sobre la instalación viva de
`~/.claude/` (con respaldo previo de `settings.json` y de
`hooks/emitir-contexto.ps1`, restaurados y verificados bit a bit iguales al
original después de cada modo):

1. **Archivo de hook faltante** (`emitir-contexto.ps1` renombrado) → ROJO.
   `[FAIL] hooks/emitir-contexto.ps1 - no encontrado` + los 4 hooks fallan por
   efecto (exit=127).
2. **Archivo de hook vacío** (truncado a 0 bytes) → ROJO. `[FAIL]
   hooks/emitir-contexto.ps1 existe pero parece vacio (0 bytes)` + los 4 hooks
   fallan por efecto (exit=0, sin salida) — el mismo síntoma exacto de la
   lección 13 que el propio script cita en su comentario.
3. **Hook mal registrado en `settings.json`** (la clave `UserPromptSubmit`
   escrita como `userPromptSubmit`) → dio VERDE la primera vez. Es el hallazgo
   de la fase: `-contains` y el acceso `.hooks.$evento` de PowerShell son
   case-**insensitive** por default, así que el chequeo de registro nunca
   distinguía mayúsculas de minúsculas — aunque el harness real sí es
   case-sensitive (confirmado en el mismo experimento: el validador de
   settings.json del propio Claude Code rechazó `userPromptSubmit` como
   "Not a recognized hook event" al intentar editarlo con la herramienta Edit).
   Corregido en el mismo turno (no se reportó el hallazgo y se dejó para
   después, por la propia instrucción de este archivo): la búsqueda de la
   propiedad ahora usa `-ceq` para exigir el nombre exacto. Re-probado el
   mismo modo contra el script corregido → ROJO, `[FAIL] settings.json no
   define el hook UserPromptSubmit (nombre exacto, distingue
   mayusculas/minusculas)`.
4. **Comando de hook con `$VAR` sin escapar** (`$env:USERPROFILE` en vez de la
   ruta resuelta) → ROJO, con doble confirmación: el chequeo estático lo
   nombra (`el comando expande variables de shell`) y el chequeo de efecto
   también falla porque bash no resuelve `$env:` (exit=127).

Instalación restaurada y verificada en verde al cerrar, con los mismos cuatro
números de control positivo que al abrir la fase (2649/5247/8042/1422 chars).
Cierra el círculo de la lección 7 y confirma la regla 3 de `CLAUDE.md`: la
alarma no "siempre decía que sí" en tres de los cuatro modos, pero sí lo hacía
en el cuarto hasta que se la rompió — que es exactamente el caso que la regla
existe para atrapar.

## 2. La secuencia falsa — RESUELTO (2026-08-17)

El chequeo transversal defendía contra el **paralelismo** falso ("el paso 2
depende del 1 → secuencial, nada de fan-out") pero no contra la **secuencia**
falsa: una lista se escribe en orden porque así se piensa, no porque las
dependencias sean ésas. Hunt & Thomas, cap. 5, §28, p. 172: la piña colada,
12 pasos escritos y ejecutados en orden, de los que 5 podían arrancar a la
vez.

**Procedimiento** (agregado a
[`chequeo-de-trabajo.md`](chequeo-de-trabajo.md), sección "antes de ejecutar
una lista de pasos escrita en orden"): para listas de 4+ pasos que se van a
ejecutar o delegar, para cada paso preguntar qué necesita que **sólo** un
paso anterior produzca — un dato, un archivo, un estado, un efecto de lado —
y no "qué escribí antes en la lista". Flecha únicamente cuando esa respuesta
es concreta y nombrable. Pointer barato agregado también en
`recordatorio-transversal.md` (que se inyecta cada turno) apuntando a la
sección completa, para que el guardia simétrico se use en la práctica y no
sólo se lea una vez al abrir sesión.

**Probado en un caso concreto**: la propia lista de esta tarea, escrita como
naturalmente hubiera salido —
`1. leer PENDIENTES → 2. leer pilares p.172 → 3. elegir caso de prueba →
4. diseñar el procedimiento → 5. aplicarlo al caso → 6. escribirlo en
chequeo-de-trabajo → 7. agregar el pointer → 8. cerrar el pendiente →
9. commit` — una cadena lineal de 9. Aplicado el procedimiento, flecha por
flecha:

- **1, 2 y 3 no tienen flecha entre sí.** Leer PENDIENTES no produce nada que
  necesite la lectura de pilares, y viceversa (ya se habían corrido en
  paralelo, sin planearlo así). Elegir el caso de prueba tampoco necesitaba
  el contenido de ninguna lectura ni del procedimiento ya diseñado — sólo
  necesitaba que existiera una lista real de pasos, y ésa ya existía antes de
  leer nada. Hallazgo real: el orden natural pone "elegir caso" después de
  "diseñar" porque se siente como su continuación lógica, pero la
  dependencia no existe — es exactamente el efecto que describe Hunt &
  Thomas.
- 4 sí depende de 1 y 2 (necesita el pedido exacto y el vocabulario de la
  fuente). 5 depende de 3 y 4. 6 depende de 4 (y condicionalmente de 5, sólo
  si el test hubiera obligado a revisar el diseño — no fue el caso). 7
  depende de 6 (necesita el nombre de la sección para referenciarla). 8
  depende de 5, 6 y 7. 9 depende de 6, 7 y 8.
- Grafo real: primera ola de **3** arranques independientes (1, 2, 3), no de
  2 como asumía la lista lineal. Un caso chico, pero el mismo error que la
  piña colada: la lista escrita en orden ocultaba un fan-out real.

Cierra el pendiente: no alcanzaba con documentar el procedimiento en
abstracto, y acá quedó aplicado a un caso con el resultado a la vista.

## 3. La asimetría del registro — RESUELTO (2026-08-17)

36 lecciones, 36 fracasos, cero registros de qué salió bien. `aprender.py`
sólo sabía registrar lo que costó tiempo.

Se agregó el subcomando `aprender.py exito --titulo ... --explicacion ...
[--descartado ...] [--proyecto ...]`. Deliberadamente no reusa los campos de
`agregar` (`costo`/`sintoma`/`regla`): un éxito no tiene costo ni síntoma,
tiene una **explicación causal** de por qué funcionó — la regla 2 de
`CLAUDE.md` dice que un éxito sin explicar es una coincidencia todavía no
descubierta — y, si aplica, qué se **descartó** en el camino por no
entenderse. Las entradas llevan `"tipo": "exito"` y caen en su propia sección
de `LECCIONES.md` ("Éxitos auditados"), separada de los grupos de lecciones
porque no comparten la taxonomía `GRUPOS` (que es de orden de lectura al
abrir sesión, pensada para fracasos).

Probado por efecto, no por precondición: se registró una entrada de prueba
real (`exito`), se confirmó que apareció en `LECCIONES.md` bajo la sección
nueva y que `listar`/`digesto` no rompen con una entrada sin `regla`/`grupo`
(`listar` ahora cae a `explicacion` cuando no hay `regla`), y después se sacó
del `.jsonl` y se regeneró el índice para no dejar basura en el registro.

No hace falta seguir foldeando esto en `chequeo-de-trabajo.md`: la regla 2 ya
vive ahí (Nivel 0, sección Pragmatic Programmer) como disciplina a aplicar,
no como comando a recordar — lo que faltaba era sólo el mecanismo de
registro, y ese es el que se cierra acá.

## 4. `perfil-global/` debería ser su propio repositorio — MIGRADO (2026-08-17)

Vivía en la rama de BLACK de `claude-acceso` por razones históricas. Ahora
tiene repositorio propio y privado:
**https://github.com/fransalomone21/perfil-global**.

**Cómo se migró**: `git subtree split -P perfil-global -b perfil-global-history`
sobre esta rama, para llevarse los 27 commits reales que tocaron la carpeta
(no un commit único con el estado actual — se conserva el "por qué" de cada
regla, regla 2 de `CLAUDE.md`). Esa rama se pusheó como `main` del repo nuevo,
que Fran creó vacío y privado en GitHub (no hay `gh` CLI instalado en esta
máquina, así que la creación del repo fue manual). Clonado en
`C:\Users\frans\Desktop\perfil-global\` — hermano de `claude-acceso`, no
adentro.

**Probado por efecto, no por precondición**: `install.ps1` corrido desde el
repo nuevo detectó por sí solo (con el mismo mecanismo de siempre, sin tocar
código) el número de lecciones desactualizado en el encabezado de
`chequeo-de-trabajo.md` (decía 36, el registro ya tenía 37 — corregido en
ambos repos). `verify-install.ps1` dio verde con los cuatro hooks emitiendo
por efecto bajo Git Bash. `aprender.py donde`, corrido desde una carpeta
neutral (`Desktop`), confirmó que `origen.txt` apunta al repo nuevo. Se
registró una entrada de prueba real con `aprender.py agregar`, se confirmó
por `grep` que apareció en el `.jsonl` del repo **nuevo** y no en el de
`claude-acceso` (1 vs. 0), y después se sacó y se regeneró el índice.

**Mitigado, no cerrado del todo**: por decisión explícita, `perfil-global/`
queda de **espejo temporal** acá, en `claude-acceso`, sin editar contenido
más allá de este párrafo — se borra en una sesión aparte, una vez que unos
días de uso real confirmen que la instalación desde el repo nuevo sigue
sólida. Mientras el espejo exista, **instalar siempre desde el repo nuevo**
(`C:\Users\frans\Desktop\perfil-global\install.ps1`): correrlo desde acá
volvería a pisar `origen.txt` apuntando a `claude-acceso`.
