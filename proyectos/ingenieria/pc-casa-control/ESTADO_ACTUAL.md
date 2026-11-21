# Estado actual — pc-casa-control

**Última actualización:** 2026-11-21

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-A: registrar el camino | **en curso** (scripts, tareas y mapa de menús en el repo; falta que una sesión nueva lo repita) |

**Qué cierra la fase en curso:** una sesión nueva, con solo `docs/camino.md` y `scripts/`, llega a la lista
«Música de fondo» de J1 contra J2 con una captura que la muestre y el guardado con el mismo md5.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| El camino portada → Menú principal → Batalla y entrenamiento → Batalla → Sin conexión → J1 contra J2 → Música de fondo, con sus esperas | capturas `v5-r1..r6` en `lp-trabajo\_intermedios\capturas-pc\` | 2026-11-21 |
| Teclas durante la carga caen en el menú equivocado (arrancó Nuevo juego de Goku) y cambian el guardado | md5 del guardado vivo distinto del respaldo (100716 B) | 2026-11-21 |
| El guardado se devuelve cerrando el juego y copiando el respaldo | md5 de vuelta igual a `0C0BB9E095C4DF702968FFBA49F8DB69` | 2026-11-21 |
| `leer-ejes.ps1` lee joy0 y joy2 (los dos DualShock 4) | `ejes.log` en la PC, 19:18:56 | 2026-11-21 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| `pc-teclas.ps1` de `scripts/` apunta a rutas de la notebook (`$dst`): hay que ajustarlas para otra máquina | correrlo desde otra carpeta | solo se usó desde la notebook de Fran |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Mandar la secuencia entera de teclas de un tirón | cayó en Episodio de batalla | un paso, una captura |
| `ESC`/`BACKSPACE` para volver atrás | no vuelven en las pantallas de menú | usar `HOLD_BACK_1500` |

## Lo próximo

Llenar el PDP (el hook pide leer las fichas de alcance); repetir el camino desde una sesión nueva y cerrar la fase 0.
