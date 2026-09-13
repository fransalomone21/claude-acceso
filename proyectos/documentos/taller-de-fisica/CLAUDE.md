# Taller de Física — contrato de contexto

Apunte propio para sostener las clases del Taller de Física — materia aparte
de Física Espacial, con dinámica de cátedra (las clases las arma la cátedra,
no un profesor individual). Fuente única prevista en **Typst**, mismo formato
que `fisica-espacial`, cuando arranque a escribirse.

**Naturaleza:** `documentos` — ver
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md).

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los
repite: un dato que vive en dos lados diverge.

## Antes que nada: este proyecto NO está escribiendo contenido

La fase 1 (escribir) está **bloqueada a propósito**. Fran: "todo lo de
taller de física es para un plazo más largo, yo te voy a decir cuándo
empezarlo" (2026-09-13). Si no hay una instrucción explícita de Fran diciendo
que arranca la fase 1, lo único pendiente es cerrar el recorte de fuentes de
la fase 0 — ver `HANDOFF.md`.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| saber qué sigue y qué la cierra | `PDP.md`, sección 4 |
| entender cómo se llegó a las fuentes y al recorte propuesto | `docs/bitacora.md` |
| verificar una fuente, o dónde está cada libro | `fuentes/RUTAS.md` |

**No leas todo "por las dudas".** Cada documento cuesta contexto, y el
contexto es lo que después falta para pensar el problema difícil.

## Las reglas propias de este proyecto

1. **Mismo estándar de rigor que `fisica-espacial`, aunque el nivel de
   detalle sea menor.** "Lo más importante, sin ir al detalle de todo" (Fran)
   es un recorte de TEMAS, no una licencia para citar sin deducir. Toda
   fórmula que entre se deduce o se cita con página exacta — igual que en
   [`../fisica-espacial/CLAUDE.md`](../fisica-espacial/CLAUDE.md), reglas 1
   y 2.
2. **El recorte de cada fuente se registra ANTES de escribir, no se decide
   sobre la marcha.** Están en `fuentes/RUTAS.md` y `docs/bitacora.md` — si
   un tema no está en esa lista y parece necesario, se anota primero por qué
   se amplía, no se agrega en silencio.

## Dónde está cada cosa

```
PDP.md            el plan: fases, criterios de salida, riesgos, decisiones
CLAUDE.md         este archivo: el indice, se carga solo al abrir aca
ESTADO_ACTUAL.md  donde estamos hoy. Se actualiza cuando cambia algo real
HANDOFF.md        el mensaje para la proxima sesion
docs/bitacora.md  como se llego a las fuentes y al recorte propuesto
fuentes/RUTAS.md  donde esta cada libro en el disco, y su alcance confirmado
```

## Dónde corre esto

No aplica todavía — no hay compilación ni entorno propio hasta que arranque
la fase 1 (va a ser Typst, igual que `fisica-espacial`).

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.

Sin esos pasos, la próxima sesión arranca de cero.
