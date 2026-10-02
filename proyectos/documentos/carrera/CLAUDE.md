# Carrera — el plan de estudios y por dónde sigue cada materia

El registro **transversal** de la carrera de Fran (Ingeniería en Sistemas
Espaciales, UNSAM): los **contenidos mínimos** oficiales de cada materia y un
**tablero** de qué tiene y qué le falta a cada una. Todo proyecto que produce
para una materia lo lee antes de producir (lo exige la cascada, necesidad
`materia`). Es público: no lleva nada personal.

**Naturaleza:** `documentos` — ver
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md).
El plan está en [`PDP.md`](PDP.md).

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| **producir para una materia, o elegir por dónde seguir** | [`MATERIAS.md`](MATERIAS.md) entero (corto a propósito) |
| saber qué tiene que cubrir una materia | [`PLAN-DE-ESTUDIOS.md`](PLAN-DE-ESTUDIOS.md), la sección de su código (`ISE03`…), no el archivo entero |
| lo que pide el **profesor** (manda sobre esto) | el repo privado `../catedras/` |
| retomar | `ESTADO_ACTUAL.md` |

## Las reglas propias

1. **`PLAN-DE-ESTUDIOS.md` es textual.** No se resume ni se corrige: si cambia
   el plan, entra el texto nuevo con su fecha y el viejo queda abajo, tachado.
2. **`MATERIAS.md` es una vista, no la fuente.** El estado fino es de cada
   proyecto. Al cerrar una sesión que cambió qué tiene una materia, se
   actualiza su fila en el mismo commit.
3. **Contenidos mínimos = piso, no techo.** El programa del profesor manda
   sobre esto en lo que agrega; lo que deja afuera de acá es un hueco a
   anotar, no a llenar en silencio.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md`, `HANDOFF.md` y la fila de `MATERIAS.md` que
   haya cambiado.
2. Lecciones: `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
