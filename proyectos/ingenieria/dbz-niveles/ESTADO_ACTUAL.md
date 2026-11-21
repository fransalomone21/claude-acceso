# Estado actual — dbz-niveles

**Última actualización:** 2026-11-20 (noche)

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-Fase A, estudio de conceptos | **en curso**: alcance escrito, los dos spikes hechos en parte, la tabla armada; falta que Fran elija |

**Qué cierra la fase en curso:** ¿está en `PDP.md` §6 el camino elegido por
Fran, con fecha, apoyado en la tabla «personaje → nivel (fuente) → parámetro»
de 3 personajes? Hoy: la tabla está (abajo); la elección, no.

Las mediciones con su predicción están en `docs/spikes-fase0.md`.

## La tabla de la fase 0

**Sparking ZERO.** La fuerza de un personaje sale de su **DP** (el costo de
equipo, 1-10 en el juego de fábrica): `Extension_Dynamic_DP` le pone a cada DP
un multiplicador de daño y uno de vida (`DP_values.json`). La ventaja de A
contra B se mide como **V = (daño A / daño B) × (vida A / vida B)**: cuántas
veces más rápido gana A, a igual habilidad.

| Personaje | DP (fuente, grado) | Lugar en la escala (fuente) | Hoy: daño · vida · V | Propuesta r = 2: daño · vida · V |
|---|---|---|---|---|
| Goku (Super) base | 5 (Game8, lista de DP; **probable**: no medido en esta build) | escalón 0 (orden de transformaciones de *Dragon Ball Super*) | 1,05 · 1,00 · **1,00** | 1,00 · 1,00 · **1** |
| Goku (Super) SSJ Blue | 8 (Game8, probable) | escalón 5: SSJ, SSJ2, SSJ3, Dios, Blue | 1,20 · 1,00 · **1,14** | 2,83 · 2,83 · **8** |
| Goku (Super) Ultra Instinto | 9 (Game8, probable) | escalón 7: … Blue, UI Señal, UI | 1,25 · 1,00 · **1,19** | 4,00 · 4,00 · **16** |

- **Hoy el Ultra Instinto le gana al base sólo 1,19 veces más rápido**: plano.
- **La propuesta** (`DBZ-mods\DP_values.propuesta-r2.json`, local, **sin
  aplicar**): cada DP arriba de 5 duplica V, repartido mitad en daño y mitad en
  vida (1,41× cada uno por DP); abajo de 5, la mitad por DP. Sólo toca DP 1-10;
  el resto del archivo queda igual. DP 1-10: 0,25 · 0,35 · 0,50 · 0,71 · 1,00 ·
  1,41 · 2,00 · 2,83 · 4,00 · 5,66.
- **El límite del camino:** la escala es por DP, no por personaje. UI Señal y
  Blue tienen el mismo DP (8): con este mod pesan igual. Separarlos pide
  cambiarle el DP a un personaje (otro mod): fase 1.
- **Sin medir:** que el juego lea `DP_values.json` (el mod depende de que se
  cargue `SZModLib`) y que `damageScale` sea el daño que el personaje **pega**
  y no el que **recibe**. Se confirma con una pelea con un valor exagerado.
- **La escala la decide Fran** (H-1 del PDP): las guías oficiales dan números
  sólo para *Z*, y con multiplicadores de guía una pelea dura un golpe. La
  propuesta usa el **orden** de la historia con saltos parejos; r es la perilla
  (1,5 suaviza, 3 endurece).

**PS2 (*Niveles de Poder*).** Las formas viven en las 161 ranuras del BT3
(`PAK3US3.AFS`, paquetes `Goku_N_*`); qué ranura es cada forma y dónde está el
parámetro de fuerza, **sin medir**. La fila de PS2 se completa si Fran elige ese
camino.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| En la notebook están los ISOs de PS2: *Niveles de Poder 8.1*, *Tenkaichi 4* Beta 14 y Beta 14 REV2, y `dbzpoderes` | listado del disco | 2026-11-20 |
| El BT3 sin modificar **no** está en la notebook; Anime War, Crossover y Remake AF tampoco están en `C:\Games\PS2-ISOs\` (sus accesos apuntan a `E:\`, desconectado) | listado del disco y de los `.lnk` | 2026-11-20 |
| Sparking ZERO de la notebook: ~137 mods en `~mods` y 20 plugins en `Mods`; con todo menos el grupo `plugins` **arranca** (vivo 299 s, 2,2 GB, respondiendo) | banco + medición del proceso | 2026-11-20 |
| El lanzador `SparkingZERO.exe` tiene el flag `RUNASADMIN`: cada arranque pide permiso de admin y el juego elevado no se cierra desde una consola común | registro `AppCompatFlags\Layers` + «Acceso denegado» | 2026-11-20 |
| `DP_values.json`: DP 1-10 casi plano (DP 5 = 1,05×, DP 9 = 1,25×, vida 1,00×); define también DP 11-35, 800 y 900 con escalas fuertes | lectura del json | 2026-11-20 |
| Los tres ISOs de PS2 son el mismo ELF de BT3 parchado (mismos segmentos); *Niveles* difiere de `dbzpoderes` en 758 B, BT4 en ~7,5 KB; los AFS están todos reconstruidos y cada mod los reorganizó | `7z l -tiso` + diff byte a byte con control | 2026-11-20 |
| En *Niveles*, los personajes están en `PAK3US3.AFS` con los nombres de ranura del BT3 | tabla de nombres del AFS | 2026-11-20 |
| El Sparking ZERO de la PC de casa no tiene mods; los dos son la build de junio 2025, sin DLC de personajes | listado por SSH | 2026-11-20 |
| La PC tiene *Niveles de Poder 8.1* portátil (PCSX2 2.6.3, perfil de 2 mandos) y *Tenkaichi 4* Beta 14; C: con 6,4 GB libres | listado por SSH | 2026-11-20 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| Prender el grupo `plugins` cierra el Sparking ZERO | `banco-arranque.ps1` | Fran está jugando esa instancia (abierta como admin: la sesión no la puede cerrar) |
| El Shipping arranca bien lanzado directo, sin el lanzador ni admin | el mismo banco (y su `-Sabotaje` en rojo) | ídem |
| El juego lee `DP_values.json` y `damageScale` es el daño que se **pega** | una pelea con DP 9 en 50× | pide jugar |
| En PS2 la fuerza vive en el paquete de cada personaje (`Goku_N_1p.pak`) | sacarlo y compararlo entre mods, o la vida en memoria con PCSX2 | sólo si Fran elige PS2 |
| PCSX2 no tiene juego en red: dos PCs = Parsec | probarlo con Agustín | no se probó |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Portar la jugabilidad del BT3 al Sparking ZERO (2026-09-05) | motores distintos | no es un mod |
| Lanzar el juego por `SparkingZERO.exe` desde un banco automático | espera el permiso de admin y queda elevado | el banco lanza el Shipping directo |

## Lo próximo

1. **No tocar el Sparking ZERO mientras Fran juega** (lo pidió el 2026-11-20;
   coordinar con las otras sesiones antes de abrir cualquier juego). Cuando
   Fran lo cierre: `banco-arranque.ps1 -SoloUna -Sabotaje` (tiene que dar SE
   CIERRA) y después el banco entero (`plugins`).
2. Fran aclara «una sola pantalla / con las dos» (PDP §6, TBR) y elige camino y
   escala (r) → §6 del PDP → se cierra la fase 0.
3. Si es «cada jugador en su pantalla»: spike de si el Sparking ZERO juega en
   red entre la notebook y la PC (el emulador de Steam del repack, por LAN).
