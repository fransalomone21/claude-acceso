# Ryo Framework: las filas de tele con temas de Linkin Park (2026-11-21)

Las ~23 filas con ícono de tele son del DLC *Anime Music Pack 1 y 2* (cues `M_2000`…`M_2022` de `bgm_DLC_01.acb` y
`bgm_DLC_02.acb`). El DLC viene cifrado y firmado y el guardado lo exige: cambiar sus paquetes no sirve
(callejones de `ESTADO_ACTUAL.md`). **Ryo Framework** (de RyoTune, sobre Reloaded-II) cambia el audio **por nombre de
pista mientras el juego corre**, sin tocar ningún paquete. El pack BT3 de la comunidad
([Nexus 65](https://www.nexusmods.com/dragonballsparkingzero/mods/65)) lo usa sobre esas mismas pistas.
Guía: [Ryo, audio replacement](https://ryotune.github.io/guides/audio/audio-replacement-ryo/);
[Importer de ANTIBigBoss (Nexus 493)](https://www.nexusmods.com/dragonballsparkingzero/mods/493?tab=docs).

## Qué quedó instalado en la PC (todo aparte de la carpeta del juego)

| Qué | Dónde | Cómo se deshace |
|---|---|---|
| Reloaded-II 1.31.0 + Ryo 2.11.5 + 3 dependencias (SigScan 1.2.14, SharedLib.Hooks 1.16.3, SharedScans 1.3.2) | `C:\Users\Fran\Reloaded-II\` (zip armado en la notebook: `herramientas\reloaded\descarga\Reloaded-II-armado.zip`) | borrar la carpeta |
| Mod `SZ.Tele.LinkinPark`: 46 `.hca` (23 cues + su variante `_SPK`), 402 MB | `...\Reloaded-II\Mods\SZ.Tele.LinkinPark\ryo\SparkingZERO-Win64-Shipping\bgm_DLC_0N.acb\M_20xx.hca` | borrar la carpeta |
| App del juego en Reloaded | `...\Reloaded-II\Apps\sparkingzero-win64-shipping.exe\AppConfig.json` (**`WorkingDirectory` = `...\Binaries\Win64`: sin eso el juego queda en pantalla negra**) | idem |
| .NET 9 Desktop Runtime x64 y x86, VC++ 2015+ x64 y x86 | sistema (winget) | desinstalar si se quiere |
| Tareas interactivas `reloaded-juego`, `reloaded-gui`, `captura-pc`, `ps-pc` | Programador de tareas | `Unregister-ScheduledTask` |
| Nombres nuevos de las filas de tele | `Mods\ZeroSpark\Json\LinkinParkNombres.json` (md5 `DBCE2E1C54FCDB9A0555D3DEFC64413A`); el anterior: `Mods-desactivados\paks\v5-nombres\` | copiar el viejo de vuelta |

**El juego SOLO suena así si se abre por `reloaded-juego`** (`Reloaded-II.exe --launch <exe>`), **no** por
`probar-juego`: sin Reloaded las filas de tele vuelven a sonar anime. Las dos formas conviven (el `dsound.dll` y el
UTocBypass del juego cargan igual: se vio `DSOUND.dll`, `DBSparkingZeroUTOCBypass.asi` y los módulos de Reloaded y Ryo
dentro del proceso).

## Qué filas

`armar-ryo.py` (copia en `scripts/`): M_2000…M_2022 → Numb, **Given Up** (M_2001, la fila que el juego elige por defecto
al abrir el menú), Pushing Me Away, A Place for My Head, By Myself, Forgotten, Cure for the Itch, Nobody's
Listening, Session, In the End, Crawling, Papercut, One Step Closer, Faint, Somewhere I Belong, Breaking the Habit,
Shadow of the Day, Leave Out All The Rest, Lying from You, Hit the Floor, Points of Authority, Runaway, Easier to Run.
Cada `.hca` se hace con VGAudioCli (loop 0–fin, calidad Highest, sin cifrar) y se copia también como `_SPK` (música del
modo Sparking).

## Lo confirmado y lo no

| Qué | Estado | Evidencia |
|---|---|---|
| Reloaded + Ryo entran al juego ElAmigos y conviven con el loader de la PC | **confirmado** | módulos del proceso y log `Reloaded-Mod-Loader-II\Logs` |
| Ryo registró el reemplazo de `M_2001 / bgm_DLC_01` | **confirmado** (con la prueba de una fila) | línea `Cue: M_2001 / bgm_DLC_01 … File added` en el log |
| El reemplazo SUENA (que el DLC en streaming acepte el cue reemplazado) | **sin confirmar**: el audio no sale en capturas | falta que Fran oiga «Given Up» (tele) con la vista previa □ |
| Los 46 reemplazos (23 cues + `_SPK`) registrados tras el último relanzamiento, sin errores | **confirmado** | 46 líneas `Cue: M_` en el log `22.54.38 ~ SparkingZERO-Win64-Shipping.txt`; juego vivo (3,5 GB) |
| La música elegida por defecto al abrir el menú es *Given Up* (fila de tele) | confirmado (no se guarda entre sesiones) | capturas `ryo-6-1.png` y `v5-r6-1.png` |

## Si no suena

Activar el Developer Mode de Ryo (consola de Reloaded) para ver qué cue y ACB se piden y con qué nombre de carpeta;
probar el HCA con la clave del juego (`.hcakey`, el flujo de `SparkingZeroAudioTool` cifra los HCA); mirar si el cue
streaming del DLC necesita reemplazo por onda (`Waves`, que la guía marca TODO). Respaldo del plan B: Kuro's Music
Manager (descargado, md5 OK, no instalado) o dejar las filas de tele ocultas con su `ReOrderBGM.json`.
