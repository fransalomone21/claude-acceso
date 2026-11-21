# Estado actual — sparking-musica

**Última actualización:** 2026-11-21 17:50

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-A: investigación externa (qué resolvió ya la comunidad) | **en curso**, a medias |

**Qué cierra la fase en curso:** `docs/investigacion-previa.md` con los mods más usados para música en
Sparking ZERO, qué hace cada uno (entradas nuevas, ocultar, aleatorio, cambio en pelea, pistas del DLC),
qué requiere, y la vía elegida con su porqué. Recién ahí se toca la PC.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| La PC tiene v4: 45 temas conocidos de LP, de a 4, en las peleas del juego base (M_1000..1044), nombres por ZeroSpark | instalada a las 16:45; captura de la lista 17:16 | 2026-11-21 |
| Las filas con ícono de tele = DLC Anime Music Pack 1/2 (M_2000..2022) y suenan anime | Fran las oyó | 2026-11-21 |
| Sin el DLC la partida NO carga ("falta contenido descargable") | captura sin-dlc-3, 17:24 | 2026-11-21 |
| Una tabla del DLC rearmada (mismo id de contenedor, sin cifrar ni firmar) también da "falta contenido descargable" | captura dlc-id-1, 17:40 | 2026-11-21 |
| Con el audio del DLC pisado y la tabla de fábrica, la pista queda muda (sigue la del menú, Easier to Run) | Fran, ~17:35 | 2026-11-21 |
| DLC vuelto a fábrica (md5 igual al original) y la partida carga | md5 + captura fabrica-1, 17:42 | 2026-11-21 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| Kuro's Music Manager da lo que pide Fran sin tocar el DLC: entradas LP nuevas, aleatorio por pelea, cambio en pelea (RePág/AvPág) | leer su doc y la del pack "Extra BGM Slots"; probar un BGMMod | la fase 0 quedó a medias |
| Con Music Manager se pueden ocultar las filas del DLC | su ReOrderBGM.json lista BGMMods según el mod 949; no dice nada del DLC | sin leer la doc de Kuro |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Mod del DLC en ~mods (prioridad normal y _999) | mudo | el DLC le gana a ~mods |
| Apartar el DLC | la partida no carga | el guardado exige el DLC |
| Pisar el audio del DLC en su lugar | mudo | la tabla que lee es la del DLC |
| Pisar la tabla del DLC con una propia | el juego da el DLC por faltante | el DLC exige su contenedor cifrado y firmado |

## Lo próximo

Cerrar la fase 0 (ver HANDOFF). Nada sobre la PC hasta cerrarla.
