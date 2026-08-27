# Apunte de Aplicaciones de Electrónica Analógica — contrato de contexto

Apunte teórico-práctico completo de la materia de **4.º año** de la E.E.S.T.
N.º 1 de Vicente López. Fuente única en **Typst**, se compila a PDF.
Destinatario primario: **el docente**; en segundo lugar, los alumnos.

**Naturaleza:** `documentos`. Antes de trabajar acá se lee
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md):
el render se mira, las fuentes se anotan donde se usan, y las referencias
cruzadas de texto plano no las valida el compilador.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber qué partes están cerradas | `ESTADO_ACTUAL.md` (entero) |
| lo que quedó a medias y las trampas de Typst ya pagadas | `HANDOFF.md` |
| tocar o agregar una figura | `docs/figuras.md` |
| verificar un dato contra la bibliografía | `fuentes/` y `docs/referencia/` |
| generar el PDF | `/pdf-con-codigo` — el flujo y el chequeo visual |

## La regla propia

**Ninguna sección se da por cerrada sin haber mirado su página compilada.**
Que Typst compile no dice nada sobre si los rótulos se cruzan, si una figura
entró, o si una tabla se cortó. Ya costó dos rondas de correcciones sobre
material que "estaba listo".

## Dónde está cada cosa

```
apunte/        el fuente Typst y el PDF compilado
docs/          figuras.md (el catalogo) y referencia/ (material de consulta)
fuentes/       bibliografia y material de la materia
ESTADO_ACTUAL.md · HANDOFF.md
```

## Pendiente de estructura (2026-08-27)

Todavía no tiene `PDP.md`. Su `ESTADO_ACTUAL.md` ya cumple parte de ese rol,
pero las decisiones de contenido y el criterio de "sección cerrada" están
implícitos. Armarlo con [`plantillas/PDP.md`](../../../plantillas/PDP.md) en la
próxima sesión de contenido.

**`ESTADO_ACTUAL.md` sigue diciendo `Rama: claude/manual-analogica-tr0mk6`.**
Eso quedó viejo: ahora hay una sola rama, `main`. Corregirlo al tocarlo.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
