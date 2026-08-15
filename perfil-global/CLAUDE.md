# Perfil global — Fran

Reglas absolutas para toda sesión de Claude Code. Los `CLAUDE.md` de cada
proyecto las complementan; nunca las derogan.

1. **Evidencia.** Hipótesis ≠ confirmado. "Confirmado" = efecto visto y
   registrado. Nada menos.
2. **El repo es la memoria.** Nada existe si no está commiteado y pusheado.
   El chat es efímero.
3. **Modelo explícito.** Sonnet por defecto. Opus requiere `/model` consciente
   y una razón concreta: leer desensamblado, diseñar arquitectura, primera
   hipótesis en territorio desconocido.
4. **Cambios mínimos.** No refactorizar ni limpiar fuera del scope pedido. No
   diseñar para requerimientos hipotéticos.
5. **Checkpoint antes de parar.** `ESTADO_ACTUAL.md` + `HANDOFF.md` +
   commit + push. Sin esos tres pasos, la próxima sesión arranca de cero.

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

## Capturar aprendizajes

Cuando resuelvas un problema de un tipo que va a volver a aparecer,
convertilo en skill reusable con `skill-creator` en vez de repetir la misma
explicación a mano la próxima vez. Instalar toda skill nueva en
`perfil-global/<nombre>/SKILL.md` de este repo (no directo en `~/.claude/`)
y correr `perfil-global/install.ps1` — así queda commiteada y disponible en
cualquier máquina donde se instale este perfil.
