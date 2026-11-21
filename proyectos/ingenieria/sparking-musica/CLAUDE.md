# Proyecto sparking-musica — contrato de contexto

**Naturaleza:** `ingenieria` — ver [`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

**El plan y las fases están en [`PDP.md`](PDP.md).**

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` y `HANDOFF.md` |
| saber qué sigue y qué la cierra | `PDP.md`, sección 4 |
| qué resolvió ya la comunidad | `docs/investigacion-previa.md` |
| el trabajo de audio ya hecho (v1..v4) | `C:\Users\frans\herramientas\lp-trabajo\RETOME.md` |
| problemas abiertos | `PROBLEMAS.md` |
| voces en inglés, la música en el ataque final / modo Sparking | `docs/investigacion-voces-y-ultimate.md`, `docs/voces-cobertura.txt` |
| las filas del menú (v5), la tele con Ryo, el menú medido, los mandos | `docs/v5-filas.md`, `docs/ryo-tele.md`, `docs/menu-musica.md`, `docs/controles-l2.md` |

## Las reglas propias de este proyecto

1. **Afuera primero (DA-145).** Antes de cambiar nada en el juego, la búsqueda de mods y herramientas de la
   comunidad que ya lo resuelven, escrita en `docs/investigacion-previa.md`. Prueba y error sobre la PC, no.
2. **El DLC de música no se toca**: el guardado lo exige (ver callejones en ESTADO_ACTUAL).
3. **Nada en la PC mientras juegan** y siempre con respaldo del guardado antes de abrir el juego cambiado.

## Dónde corre esto

PC de casa (PCFRAN), por SSH desde la notebook. Datos en HANDOFF.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Lecciones: `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
