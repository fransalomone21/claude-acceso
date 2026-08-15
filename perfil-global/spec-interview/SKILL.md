---
name: spec-interview
description: Entrevista al usuario para extraer los detalles clave de una tarea de ingenieria (problema central, para quien es y para quien no, decisiones de diseno) y devuelve un implementation spec compacto y confirmado antes de tocar codigo. Usar antes de implementar algo no trivial o cuando los requisitos estan poco claros.
---

# Spec Interview

Combina dos pasos que normalmente se saltean: entrevistar antes de asumir, y
escribir el spec antes de programar.

## Cuándo usar

Antes de implementar algo no trivial — más de ~3 archivos afectados,
requisitos ambiguos, o una decisión de arquitectura real. **No** usarlo para
bugfixes triviales o tareas mecánicas: ahí la entrevista cuesta más que la
tarea misma (ver Selección de effort en `engineering-orchestrator`).

## Proceso

1. **Entrevistar, no asumir.** Usar `AskUserQuestion` para cubrir, en este
   orden:
   - Problema central: ¿qué se rompe o falta hoy sin esto?
   - Para quién es — y explícitamente para quién **no** es.
   - 2-3 decisiones de diseño con trade-offs reales, presentadas como
     opciones concretas (no como preguntas abiertas tipo "¿cómo lo querés?").
   - Qué queda explícitamente fuera de alcance.

   Máximo 2-3 rondas. Si después de eso algo sigue ambiguo, avanzar con la
   opción más simple y decirlo explícitamente en el spec en vez de seguir
   preguntando.

2. **Resumir como spec, no como transcripción de la entrevista.**

   ```
   PROBLEMA        — qué falta o se rompe hoy sin esto
   ALCANCE         — para quién es, para quién no, qué queda afuera
   DECISIONES      — cada una: opción elegida + trade-off descartado + por qué
   PLAN            — pasos concretos en orden, con archivos/módulos afectados
   VERIFICACIÓN    — cómo se va a confirmar que funciona (ver `verify-before-build`)
   ```

3. **Confirmar antes de construir.** Mostrar el spec y esperar luz verde
   explícita. Si la sesión tiene `EnterPlanMode`/`ExitPlanMode` disponible,
   usarlo para esta confirmación en vez de texto libre en el chat.

4. **Guardar el spec en archivo**, no sólo en el chat — el repo es la
   memoria (ver `engineering-orchestrator` → Memoria). Ubicación sugerida:
   `docs/specs/<nombre-tarea>.md`, o el directorio de specs que ya use el
   proyecto.

## Gotchas

- No convertir la entrevista en un cuestionario largo: 2-3 rondas máximo.
  Pasado eso, la ambigüedad restante se resuelve con una decisión explícita
  documentada, no con más preguntas.
- Las opciones de `AskUserQuestion` deben ser decisiones reales con
  trade-offs distintos, no variaciones cosméticas de la misma opción.
- El spec no reemplaza el chequeo de `verify-before-build`: el spec define
  QUÉ construir, `verify-before-build` confirma que el entorno está listo
  para construirlo.
