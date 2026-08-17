# Pendientes del perfil

Lo que le falta al perfil **mismo**. No se inyecta por hook: es estado de este
proyecto, y una sesión de BLACK no gana nada leyéndolo. Vive acá por la tabla
de memorias de [`CLAUDE.md`](CLAUDE.md) — estado del proyecto, en el repo del
proyecto.

Antes de repetir que algo de acá sigue abierto: verificalo. Un documento no se
entera de que alguien lo cerró.

---

## 1. La alarma sin probar — `verify-install.ps1`

`verify-install.ps1` verifica por **efecto** (corre los hooks por Git Bash y
mide lo que emiten), que es lo correcto. Pero nadie rompió la instalación a
propósito para ver si se pone en rojo. Por la regla del saboteador (regla 3 de
`CLAUDE.md`), hoy es una alarma sin probar: no sabemos si verifica o si
siempre dice que sí.

Cierra cuando: se rompan a propósito los cuatro modos de falla —archivo
faltante, archivo vacío, hook mal registrado en `settings.json`, comando de
hook con `$VAR` sin escapar— y cada uno ponga el script en rojo con un mensaje
que diga cuál es. Es una tarde de trabajo y cierra el círculo de la lección 7.

## 2. La secuencia falsa

El chequeo transversal defiende contra el **paralelismo** falso ("el paso 2
depende del 1 → secuencial, nada de fan-out") pero no contra la **secuencia**
falsa: una lista se escribe en orden porque así se piensa, no porque las
dependencias sean ésas. Hunt & Thomas, cap. 5, p. 172: la piña colada, 12
pasos escritos en orden, 5 podían arrancar a la vez.

Falta el procedimiento — escribir los pasos y después preguntar, flecha por
flecha, cuál dependencia existe de verdad. Detalle en
[`pilares/pragmatic-programmer.md`](pilares/pragmatic-programmer.md).

## 3. La asimetría del registro

34 lecciones, 34 fracasos, cero registros de qué salió bien. `aprender.py` sólo
sabe registrar lo que costó tiempo.

Tiene dos respaldos ahora: el "éxito inexplicado" de Hunt & Thomas dice que el
éxito no revisado es el caso más peligroso, no el más seguro — y es la regla 2
de `CLAUDE.md`, que hoy no tiene dónde escribirse. Cierra cuando el registro
acepte una entrada de éxito con su explicación, o cuando se decida
explícitamente que no corresponde y se escriba por qué.

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
