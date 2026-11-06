# Proyecto ps2-casa — contrato de contexto

Dejar las dos PS2 Slim de la casa listas para que el hermano y la mamá de Fran
jueguen los juegos que Fran tiene en la PC, aprovechando el Ethernet de la Slim
todo lo que dé.

**Naturaleza:** `ingenieria` — ver
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los
repite: un dato que vive en dos lados diverge.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| **cualquier cosa que necesite una ruta, IP, carpeta o script** | `RUTAS.md` **antes de buscar**: lo que está ahí no se vuelve a buscar |
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| saber qué sigue y qué la cierra | `PDP.md`, sección 4 |
| qué se puede hacer por red, con fuentes | `docs/investigacion-red.md` |
| problemas abiertos | `PROBLEMAS.md` |

## Las reglas propias de este proyecto

1. **La sesión no ve las consolas.** Todo lo que pasa en la PS2 se confirma con
   captura o foto de Fran; nunca se da por hecho.
2. **Nada de datos de la etiqueta en el repo** fuera del modelo y el código de
   fecha: el repo es público y los seriales no hacen falta.
3. **Antes de formatear una tarjeta, su copia en la PC.**

## Dónde corre esto

Las consolas están en la casa de Fran; los juegos y los servidores de red, en
su PC. Una sesión en la nube puede escribir guías y scripts, no probarlos.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
