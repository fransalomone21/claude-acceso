# Spikes de la fase 0

Cada spike lleva la predicción escrita **antes** de correrlo, y la medición
debajo. Lo que nombra la colección (nombres de mods, repacks) vive en los
archivos locales de `DBZ-mods`, no acá (regla 1 del contrato).

## Spike A — qué grupos de mods del Sparking ZERO arrancan (notebook)

**Fecha:** 2026-11-20 · **Objeto:** `C:\Games\Dragon Ball Sparking ZERO`, build
de junio 2025 · **Herramienta:** `DBZ-mods\scripts\mods-sparking.ps1` (mueve
grupos a `_mods-desactivados`) y un banco propio que abre el juego y lo mide.

**Estado al abrir (medido):** los grupos `musica`, `fps`, `roster`, `af`, `af2`
y `unlock` prendidos; `plugins` (5 mods de combate, escenarios y misiones)
apagado desde el 2026-09-05. Además hay 137 mods de julio 2025 en `~mods` y 8
plugins en `Mods` que ningún grupo mueve (la base: siempre prendidos).

**Qué cuenta como «arranca»:** el proceso `SparkingZERO-Win64-Shipping` sigue
vivo a los 60 s con más de 800 MB de memoria. Límite: eso dice que pasó la
carga, **no** que una pelea con esos personajes ande; eso lo prueba Fran
jugando.

**Predicción (escrita antes de abrirlo):**

1. El estado de hoy (todo menos `plugins`) arranca.
2. Prender `plugins` lo cierra: es el grupo que la sesión del 2026-09-05 dejó
   apagado, y sus mods tocan el motor de combate y los escenarios, que es lo
   que más cambia entre versiones del juego.
3. Dentro de `plugins`, uno o dos de los cinco son los culpables y el resto
   convive.

**Medición (2026-11-20):**

- **El estado de hoy ARRANCA — predicción 1 confirmada.** Proceso vivo 299 s
  después de arrancar, 2 170 MB, respondiendo. Respaldo del save antes:
  `DBZ-mods\respaldos\RESPALDO-save-20261120-221754` (4 archivos).
- **El primer banco se equivocó, no el juego.** Dio «SE CIERRA, pico 0 MB» a
  los 117 s: el lanzador `SparkingZERO.exe` tiene el flag de compatibilidad
  `RUNASADMIN` (medido en `HKCU\...\AppCompatFlags\Layers`), así que cada
  arranque pide permiso de administrador y el proceso recién apareció cuando
  alguien lo aceptó (22:19:53). El banco cortaba a los 20 s sin proceso. Y el
  juego elevado **no se puede cerrar** desde una consola sin permisos («Acceso
  denegado»): quedó abierto en segundo plano hasta que Fran lo cierre.
- **Arreglo del banco** (`banco-arranque.ps1`, local): lanza
  `SparkingZERO-Win64-Shipping.exe` directo (su manifiesto pide `asInvoker`),
  espera hasta 120 s a que aparezca («NO APARECE» es otro resultado, no «se
  cierra») y mide 60 s desde ahí; `-Sabotaje` lo mata a los 15 s y tiene que
  dar SE CIERRA.
- **Banco corregido, corrido el 2026-11-20 a las 22:49-22:54** (con acuerdo de
  turnos entre las sesiones):
  - sabotaje (`-SoloUna -Sabotaje`): **SE CIERRA** a los 18 s → el banco ve
    una caída; control: el mismo estado sin sabotaje **ARRANCA** (60 s, 2 094 MB);
  - **+ `plugins` entero: SE CIERRA** a los 12 s → **predicción 2 confirmada**;
  - de a uno, sobre el estado de hoy: StageAPI ARRANCA; **BetterCombat SE
    CIERRA** (9 s); **CustomMissionExpansion SE CIERRA** (9 s, sin
    BetterCombat); CustomBattleExporter y el ModUpdateManager ARRANCAN →
    **predicción 3 confirmada**: dos de cinco.
  - **Queda puesta la combinación más grande que arranca:** todos los grupos,
    y de `plugins` tres de cinco (BetterCombat y CustomMissionExpansion
    apagados en `_mods-desactivados\plugins`). Respaldos del save:
    `RESPALDO-save-20261120-224900` y `-224922`.
  - Límite: «arranca» = proceso vivo 60 s; una pelea no se probó.
- **Corrección a `ESTADO_ACTUAL`:** `DP_values.json` es casi plano en DP 1-10
  (los que usa el juego de fábrica: DP 5 = 1,05×, DP 9 = 1,25×, vida 1,00× en
  todos), pero define además DP 11-35, 800 y 900 con escalas fuertes (hasta
  240× de daño). Esas sólo pesan en personajes con ese DP.

## Spike B — qué archivos cambian los ISOs de PS2

**Fecha:** 2026-11-20 · **Herramienta:** `7z l -tiso` (sin `-tiso`, 7-Zip no
abre estos ISO: «0 files, Errors: 1», medido sobre `dbzpoderes.iso`).

**La referencia que hay (medido):** el BT3 sin modificar **no está** en la
notebook. `RUTAS.md` de ps2-casa lista Anime War, Crossover V2 y BT3 Remake AF
en `C:\Games\PS2-ISOs\`; hoy esa carpeta tiene sólo `dbzpoderes.iso` (otro mod
de BT3), y los accesos de `juegos db tk3` apuntan a `E:\`, un USB que no está
conectado. La referencia se arma con lo que hay: los tres mods (*Niveles de
Poder 8.1*, BT4 Beta 14 REV2 y `dbzpoderes`) y la **fecha de cada archivo
dentro del ISO**: lo que conserva fecha de 2005-2007 es del BT3 de fábrica; lo
fechado después lo reconstruyó el autor del mod.

**Predicción (escrita antes de listar):**

1. Los tres ISOs tienen la misma forma que el BT3: `SYSTEM.CNF`, un ELF
   `SLUS_*`, los módulos `IRX\` y unos pocos archivos `.AFS` grandes donde
   viven los personajes.
2. Lo que cambia en los mods son los `.AFS` (fecha nueva, otro tamaño); el ELF
   también cambia (serial, y probablemente parches chicos), pero la fuerza de
   cada personaje vive en los datos de los `.AFS`, no en el ELF.
3. *Niveles de Poder* y BT4 cambian los mismos archivos; difieren en tamaño
   porque cargan otros personajes.

**Medición (2026-11-20):**

| ISO | ELF | Archivos de datos | Fechas |
|---|---|---|---|
| *Niveles de Poder 8.1* | `SLUS_219.99`, 2 115 684 B | `PAK3US.DIR` + `PAK3US0.HFS` + `PAK3US1..4.AFS` (4,32 GB) | AFS de oct 2026; ELF de feb 2026 |
| BT4 Beta 14 REV2 | `SLUS_219.78`, 2 115 688 B | `PZS4US.DIR` + `PZS4US0..3.AFS` (5,10 GB) | jun 2026 |
| `dbzpoderes` | `SLUS_215.78`, 2 115 688 B | `PZS3US.DIR` + `PZS3US0..2.AFS` + `LOP.DIR`, `VOL.DIR` | ago 2024 |

- **Predicción 1: confirmada a medias.** Los tres tienen `SYSTEM.CNF`, un ELF,
  `IRX\` y archivos `.AFS`; el juego encuentra los archivos por la lista de
  `DATA\*.DIR`, y por eso cada mod los pudo renombrar.
- **Predicción 2: los datos, confirmado; el ELF, más chico de lo esperado.**
  Todos los AFS están reconstruidos (fechas 2024-2026). Los tres ELF tienen la
  misma forma (mismos segmentos, entrada `0x100008`): son el mismo ELF de BT3
  parchado. Diferencias byte a byte (control: un ELF contra sí mismo da 0):
  *Niveles* contra `dbzpoderes` 758 B en 207 tramos; BT4 contra los otros dos,
  7,2-7,8 KB. Qué hacen esos parches no se sabe sin el ELF de fábrica.
- **Predicción 3: falló.** No cambian «los mismos archivos»: cada mod reorganizó
  los archivos (4 AFS + HFS, 4 AFS, 3 AFS + dos `.DIR` extra).
- **Adentro de *Niveles*** (tablas de nombres de los AFS, leídas por streaming
  con `7z e -so`): `PAK3US1` = imágenes, voces y mapas (3 399 entradas);
  `PAK3US2` = audio (65 495); `PAK3US3` = **los personajes**: 161 ranuras con
  los nombres del BT3 de fábrica (`Goku_0..7`, `Vegeta_0..7`, …), cada una con
  sus paquetes de traje (`_1p..8p`), daño (`_dmg`), animación (`_anm`) y efectos
  (`_eff`). Las formas nuevas (Blue, Ultra Instinto) ocupan ranuras viejas: **el
  nombre no dice qué forma es**; eso se mapea con el juego andando.
- **Dónde está la fuerza en PS2: sin medir.** Hipótesis: en el bloque de
  parámetros del paquete de cada personaje (barras de vida, ki, Z-items), y
  quizá en los parches del ELF. Confirmarla pide sacar un `Goku_N_1p.pak` y
  compararlo entre mods, o mirar la vida en memoria con PCSX2.

## La tabla: personaje → nivel (fuente) → parámetro

Vive en `../ESTADO_ACTUAL.md` («La tabla de la fase 0»): ahí la pide el
criterio de cierre, y un dato en dos lados diverge.
