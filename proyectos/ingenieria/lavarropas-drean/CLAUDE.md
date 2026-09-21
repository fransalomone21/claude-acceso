# Proyecto lavarropas-drean — contrato de contexto

Diagnosticar y arreglar el ruido creciente del lavarropas **Drean Next 6.06
ECO** de casa. Lo ejecutan Fran y su papá sobre la máquina; la sesión produce
el procedimiento, no el arreglo.

**Naturaleza:** `ingenieria` — ver
[`ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md) para lo que se
lee siempre en esta clase de proyecto. Hay una realidad externa que puede
contradecir cualquier cosa escrita acá, y la contradice midiendo.

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los
repite.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | [`ESTADO_ACTUAL.md`](ESTADO_ACTUAL.md) (entero — es corto) |
| saber qué sigue y qué la cierra | [`PDP.md`](PDP.md), sección 4 |
| **trabajar sobre la máquina** | [`docs/guia.typ`](docs/guia.typ) y su PDF al lado — es el entregable, y la fuente única |
| de dónde salió un precio o una medida | [`docs/guia-reparacion.md`](docs/guia-reparacion.md) — quedó como el archivo de fuentes |
| entender cómo se llegó a algo, o qué no funcionó | [`docs/bitacora.md`](docs/bitacora.md) |
| saber qué muestran las fotos | [`docs/evidencia-fotos.md`](docs/evidencia-fotos.md) |

## Las reglas propias de este proyecto

1. **No se compra nada antes de que la fase 1 cierre.** El kit de rulemanes
   sale ~$20.000 y no descarta ninguna de las otras cinco causas. La regla
   existe porque este es el dominio donde comprar primero es la tentación
   barata y el desarme es irreversible.
2. **Las medidas de repuesto se escriben con su fuente y su grado.** Lo leído
   de una publicación de venta es `probable`; lo leído del aro del rodamiento
   que está en la mano es `confirmado`. Nunca se anota lo primero como si
   fuera lo segundo: el que compra es el papá de Fran, no la sesión.
3. **La guía es para dos personas paradas frente a la máquina.** Si una frase
   necesita que alguien vuelva a preguntar, la guía tiene un hueco y se
   corrige ahí, no en el chat.

## Dónde corre esto

**Sobre la máquina, que está en la casa de Fran y no en el repo.** Ninguna
sesión puede medir T1–T7 por su cuenta: los resultados los trae Fran. Una
sesión que no los tenga tiene que **decirlo**, no suponerlos.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
