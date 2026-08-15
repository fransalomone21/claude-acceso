---
name: verify-before-build
description: Chequeo de tres capas antes de empezar a construir algo no trivial - CLAUDE.md actualizado con lo que salio de la entrevista/spec, permisos de herramientas configurados, y zonas de validacion humana explicitas. Usar despues de tener un plan o spec y antes de escribir la primera linea de codigo. No confundir con el /verify de Claude Code, que corre despues, con la app ya construida.
---

# Verify Before You Build

Un plan correcto con el entorno mal configurado falla igual. Antes de
construir, confirmar que el entorno — no sólo el plan — está listo.

Esto corre **antes** de escribir código, como cierre de `spec-interview` o de
cualquier plan. Es distinto del `/verify` incluido en Claude Code, que corre
**después**, construyendo y probando la app ya hecha.

## Las tres capas

1. **CLAUDE.md actualizado.** ¿Las convenciones, restricciones y decisiones
   que salieron del spec/entrevista ya están escritas en el `CLAUDE.md` del
   proyecto (o en la memoria correspondiente)? Si no, escribirlas ahora,
   antes de construir — no después. Esto evita que la próxima sesión (o el
   propio Claude, más adelante en la misma tarea) vuelva a preguntar algo ya
   resuelto.

2. **Herramientas habilitadas.** ¿Los permisos que la tarea necesita ya
   están configurados en `settings.json` / `settings.local.json`, o cada
   paso va a interrumpirse con un prompt de permiso? Agregar sólo las reglas
   que la tarea concreta necesita — no ampliar permisos "por las dudas" (ver
   regla de cambios mínimos).

3. **Zonas de validación humana.** Marcar explícitamente, antes de empezar,
   qué partes de esta tarea en particular el usuario quiere revisar en
   persona antes de que se ejecuten — más allá de las reglas globales sobre
   acciones irreversibles (push, borrado de datos, cambios de configuración
   compartida). Si la tarea no tiene ninguna zona así, decirlo explícitamente
   en vez de asumirlo en silencio.

## Cuándo saltarlo

Tareas mecánicas de un solo paso, o cuando el spec/entrevista ya cubrió las
tres capas explícitamente. No repetir el checklist por repetirlo — eso viola
el principio de costo mínimo de `engineering-orchestrator`.

## Gotchas

- Capa 2 (permisos) no es "dar acceso a todo": cada regla agregada a
  `settings.json` debe mapear a una necesidad concreta de la tarea actual.
- Capa 3 no reemplaza las reglas globales de acciones irreversibles — las
  complementa para el caso específico de la tarea.
