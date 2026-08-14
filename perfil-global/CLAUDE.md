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
control de costos, verificación, no repetición.
