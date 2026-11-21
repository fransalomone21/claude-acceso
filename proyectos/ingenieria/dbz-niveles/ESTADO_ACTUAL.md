# Estado actual — dbz-niveles

**Última actualización:** 2026-11-20

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-Fase A, estudio de conceptos | **en curso** (recién abierta) |

**Qué cierra la fase en curso:** ¿está en `PDP.md` §6 el camino elegido por
Fran, con fecha, apoyado en la tabla «personaje → nivel (fuente) → parámetro»
de 3 personajes?

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| En la notebook están los ISOs de PS2: *Niveles de Poder 8.1*, *Tenkaichi 4* Beta 14 y Beta 14 REV2, y `dbzpoderes` | listado del disco | 2026-11-20 |
| El Sparking ZERO de la notebook tiene ~130 mods en `Content\Paks\~mods` y 20 en `SparkingZERO\Mods` (SZModLib, ZeroSpark, formas AF, Ultra Ego, desbloqueo, y `Extension_Dynamic_DP`) | listado del disco | 2026-11-20 |
| `Extension_Dynamic_DP` escala daño y vida por DP desde `Config\DP_values.json`; hoy está casi plano (DP 4 = 1,00×, DP 7 = 1,15×) | lectura del json | 2026-11-20 |
| El Sparking ZERO de la PC de casa no tiene mods ni carpeta `~mods`; los dos son la build de junio 2025, sin DLC de personajes | listado por SSH | 2026-11-20 |
| La PC tiene *Niveles de Poder 8.1* portátil (PCSX2 2.6.3, perfil de 2 mandos) y *Tenkaichi 4* Beta 14; C: con 6,4 GB libres | listado por SSH | 2026-11-20 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| Con todos los mods, el Sparking ZERO de la notebook no arranca (build 2025 contra mods 2026) | abrirlo una vez y ver si pasa de 800 MB y sigue vivo a los 50 s | no se abrió desde el 2026-09-05; su script `DEJAR-TODO-LISTO.ps1` tiene rutas viejas (`Desktop\DBZ-mods`) |
| *Niveles de Poder* cambia la fuerza por datos (los `.AFS`), no por el ejecutable | diff de los archivos del ISO contra BT3 y BT4 | es el primer paso de la fase |
| PCSX2 no tiene juego en red: dos PCs = Parsec | probarlo con Agustín | no se probó |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Portar la jugabilidad del BT3 al Sparking ZERO (2026-09-05) | motores distintos | no es un mod |

## Lo próximo

El alcance (§1-2 del PDP) con sus fuentes, y después los dos spikes: el diff
de ISOs y el arranque del Sparking con los mods por grupos.
