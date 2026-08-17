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

## 2. La secuencia falsa

El chequeo transversal defiende contra el **paralelismo** falso ("el paso 2
depende del 1 → secuencial, nada de fan-out") pero no contra la **secuencia**
falsa: una lista se escribe en orden porque así se piensa, no porque las
dependencias sean ésas. Hunt & Thomas, cap. 5, p. 172: la piña colada, 12
pasos escritos en orden, 5 podían arrancar a la vez.

Falta el procedimiento — escribir los pasos y después preguntar, flecha por
flecha, cuál dependencia existe de verdad. Detalle en
[`pilares/pragmatic-programmer.md`](pilares/pragmatic-programmer.md).

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

## 4. `perfil-global/` debería ser su propio repositorio

Vive en la rama de BLACK de `claude-acceso` por razones históricas: se creó
ahí. Aplica a todo, así que su lugar natural es un repositorio propio — y la
condición que este pendiente esperaba ya se dio: apareció `electronica-analogica/`
en el árbol de trabajo de esta rama (2026-08-17).

Mitigado, no resuelto: lo instalado en `~/.claude/` funciona en cualquier
carpeta de la máquina, y `~/.claude/aprendizaje/origen.txt` hace que
`aprender.py` escriba siempre en este repo aunque se lo invoque desde otro
lado. Lo que sigue roto el día que haya un repo separado de verdad es
**actualizar** el perfil desde allá.

Es una decisión de Fran: implica un remoto nuevo. La solución no es mergear
ramas — los proyectos no se mezclan.
