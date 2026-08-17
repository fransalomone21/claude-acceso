# Perfil global — Fran

Reglas absolutas para toda sesión de Claude Code. Los `CLAUDE.md` de cada
proyecto las complementan; nunca las derogan.

1. **Evidencia.** Hipótesis ≠ confirmado. "Confirmado" = efecto visto y
   registrado. Nada menos.
2. **El repo es la memoria.** Nada existe si no está commiteado y pusheado.
   El chat es efímero. Pero el repo recuerda **lo que decidimos**, no **lo que
   hay en el disco**: el estado de la máquina se mide, no se lee. Antes de
   repetir que algo falta, mirá. (Lección 19.)
3. **Modelo explícito.** Sonnet por defecto. Opus requiere `/model` consciente
   y una razón concreta: leer desensamblado, diseñar arquitectura, primera
   hipótesis en territorio desconocido.
4. **Cambios mínimos.** No refactorizar ni limpiar fuera del scope pedido. No
   diseñar para requerimientos hipotéticos.
5. **Checkpoint antes de parar.** `ESTADO_ACTUAL.md` + `HANDOFF.md` +
   commit + push. Sin esos tres pasos, la próxima sesión arranca de cero.
6. **Cuadro de fase en TODA respuesta**, no sólo al abrir el chat. Tres
   líneas, arriba de todo, antes de cualquier otra cosa:

   ```
   Fase     : cuál es, y QUÉ LA CIERRA (criterio de salida concreto)
   Modelo   : el que corresponde a este tramo, y por qué
   Contexto : seguir acá | conviene chat nuevo, y por qué
   ```

   Se decide, no se pregunta: es una llamada de criterio del rol de
   ingeniero, no del usuario. Ver `/cuadro-de-fase` para el detalle y los
   casos borde.

7. **Si el cuadro dice "chat nuevo", la respuesta lleva el MENSAJE DE
   RETOME.** Una cuarta línea en el cuadro (`Retomar : ver el bloque al
   final`) y, al final de la respuesta, un bloque de código listo para pegar
   como primer mensaje del chat siguiente.

   Decir "conviene chat nuevo" sin dejar el mensaje es ordenar tirar el
   contexto sin decir cómo recuperarlo. El mensaje lleva, con rutas exactas:
   qué leer y qué no, la fase que se abre y su criterio de salida, el modelo,
   **el estado de la máquina** (qué hay instalado y dónde, qué está montado,
   qué parches vivos hay), lo que ya está resuelto, y el primer comando
   concreto. No se resume: si una ruta o un offset no entra, entra igual.

   **Nunca se gasta un turno —ni menos un chat— sólo en cerrar la sesión.**
   El mensaje sale en la misma respuesta en la que se decide cortar. Pedir un
   mensaje más para "guardar el estado" es cobrar un turno entero de contexto
   por algo que ya tenía que estar escrito.

## Dónde vive esto, y qué memoria es cuál

El perfil se edita en `perfil-global/` del repo `claude-acceso` y se instala
con `perfil-global\install.ps1`. `~/.claude/` es una **copia instalada**: si
algo se edita ahí, se pierde en la próxima instalación. Verificar con
`perfil-global\verify-install.ps1` — que comprueba el efecto de los hooks
corriéndolos por Git Bash, no que los archivos existan.

| Memoria | Qué va | Vive en |
|---|---|---|
| Perfil global | cómo se trabaja, en cualquier proyecto | `perfil-global/` → `~/.claude/` |
| Lecciones de proceso | lo que ya costó tiempo por *cómo* se trabajó | `perfil-global/aprendizaje/lecciones.jsonl` |
| `CLAUDE.md` del proyecto | contrato de contexto e índice de qué leer | el repo del proyecto |
| `kb/`, `ESTADO_ACTUAL`, `HANDOFF` | hechos y estado de *ese* proyecto | el repo del proyecto |
| Auto-memoria de la sesión | preferencias sueltas del usuario | `~/.claude/projects/<ruta>/memory/` |

Ante contradicción entre dos de ellas, gana la más específica y se corrige la
otra en el mismo turno. Un dato que vive en dos lados diverge.

## Metodología completa

Skill disponible: `/engineering-orchestrator`

Invocalo al principio de cualquier tarea de ingeniería nueva, o cuando haya
que tomar una decisión sobre modelo / effort / arquitectura / subagents.
Cubre: selección de modelo, selección de effort, optimización de contexto,
memoria, evidencia, investigación, subagents, handoff, cambio de sesión,
control de costos, verificación, no repetición, automatización, y el
triángulo de hierro (costo/planning/performance por encima de velocidad de
respuesta).

## Antes de construir algo no trivial

1. `/spec-interview` — entrevista para sacar el spec (problema, alcance,
   decisiones, plan, verificación) antes de tocar código.
2. `/verify-before-build` — chequeo de tres capas (CLAUDE.md actualizado,
   permisos de herramientas, zonas de validación humana) antes de la
   primera línea de código.

Para tareas triviales o mecánicas, saltar ambos pasos — el costo de la
entrevista/chequeo no se justifica.

## Autoperfeccionamiento — siempre activo, sin preguntar

Al cerrar cualquier tarea no trivial, **antes del commit**, correr este
chequeo y actuar. No preguntar si conviene: hacerlo y reportarlo.

1. **¿Falló algo por *cómo* se trabajó, no por lo que decía el código?**
   → registrarlo, con la herramienta, no a mano:

   ```
   python perfil-global\herramientas\aprender.py agregar --titulo ... \
       --costo ... --sintoma ... --regla ... --grupo ... --proyecto ...
   ```

   El síntoma se escribe **como se veía antes de entenderlo**: es la única
   forma de reconocerlo la próxima vez. Corre desde cualquier carpeta de la
   máquina y escribe siempre en el repo. El criterio de qué entra y qué no
   está en `/lecciones-aprendidas`; si la lección necesita el caso completo
   para entenderse, la versión larga va también a esa skill.
2. **¿Se repitió una explicación o un procedimiento que ya se dio antes?**
   → convertirlo en skill con `skill-creator`.
3. **¿Quedó algo mecánico que se hizo a mano?**
   → evaluarlo contra el criterio de Automatización de
   `/engineering-orchestrator` (sin criterio + 80% tolerable = automatizar;
   si no, augmentar sin reemplazar el juicio humano).
4. **¿Un verificador confirmó una precondición en vez de un efecto?**
   → arreglarlo. Ver lección 7 de `/lecciones-aprendidas`.

Toda skill nueva se instala en `perfil-global/<nombre>/SKILL.md` de este repo
(nunca directo en `~/.claude/`) y se corre `perfil-global/install.ps1` — así
queda commiteada y disponible en cualquier máquina donde se instale el
perfil. `install.ps1` levanta solo cualquier carpeta nueva con `SKILL.md`.

Skill de consulta: `/lecciones-aprendidas` — leerlo al empezar una tarea de
investigación o debugging.
