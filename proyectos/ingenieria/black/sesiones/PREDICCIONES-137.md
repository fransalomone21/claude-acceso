# Predicciones de (137) — el fantasma, después de cruzar los dos registros (F-RED-3)

Escritas el 2026-11-06 **antes** de la próxima partida. Fase PLAT-PreA (spike). Traza: L1-06, L1-07 (`docs/20`) y
F-RED-3 de `docs/24-fallos-coop.md`, párrafo (137).

## Lo medido hoy, sin jugar (el control en frío)

`herramientas/cruzar_registros.py <anfitrión> <compañero> <desfase s>` sobre la noche del 31/10 (desfase 378,3 y 2225):
dentro de un nivel con los dos jugando, **1 enemigo del anfitrión de 237 sin títere** en la copia de Agustín; mediana
de demora 0,6 s. En el cruce de los 1110 s (los 92 s del rescate) los títeres de la unidad 5 nacieron en el mismo
segundo. **H1 (spawner no cargado) no explica ese cruce.** Sabotaje de la herramienta: con el desfase en 0 da 167
faltantes (rojo); con el correcto, 0 o 1.

**Por eso no se escribió el parche 04 pedido** («cargar la unidad del anfitrión en la copia que se une»): el mod ya
activa esa unidad (`FlowMessages`), y avanzarla sin mover al jugador lo deja en una unidad descargada.

## La próxima partida (las dos máquinas con 01+02+03, sha E63DEEDB…)

| # | Escena | Predicción |
|---|---|---|
| P1 | Fran (anfitrión) cruza primero a una zona nueva; Agustín viene atrás y camina hasta la puerta | En el registro del anfitrión: «the advance to unit N waits for the partner». En el de Agustín: o «the partner's copy advanced» en ≤ 5 s de que él cruce (pasa sola), o nada (no puede cruzar) |
| P2 | Si Agustín no puede cruzar (P1, el segundo caso) | Una captura de su pantalla muestra **qué** lo frena (puerta cerrada, pared, un evento): es H3. En su registro, cero `waits here: its spawner's unit is not loaded` (H1 sigue descartada) |
| P3 | Si Fran ve a Agustín «fantasma» (los enemigos no le tiran) | `cruzar_registros.py` da ≤ 1 faltante; si da más, H1 vuelve. Si sale `the host's states are stale: the puppets stand` en el de Agustín, es H2 |
| P4 | Control | Entrando juntos a la zona: cero esperas largas (> 10 s) en el registro del anfitrión |

**Lo que refuta lo de hoy:** más de 3 enemigos del anfitrión sin títere en un mismo nivel con los dos jugando (H1
vive), o líneas `waits here` en el registro de Agustín.

## Resultados

(vacío: falta la partida)
