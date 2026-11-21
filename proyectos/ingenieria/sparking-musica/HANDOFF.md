# Handoff — sparking-musica

**Escrito el:** 2026-11-21 17:50 · **Fase al cerrar:** 0 (investigación externa), a medias

## Arrancá por acá

1. Llenar `PDP.md` (tipo de fase: Pre-A; criterio de salida de la fase 0 = el de ESTADO_ACTUAL).
2. Investigar AFUERA antes de tocar nada (DA-145). Leer enteras, con el navegador, sin agentes:
   - Kuro's Music Manager (Nexus, Sparking ZERO): qué hace, qué loader pide, si oculta pistas del DLC.
   - https://gamebanana.com/mods/589244 (Extra BGM Slots + In-Battle BGM changer): ya leído: entradas nuevas
     sin reemplazar, aleatorio por pelea, RePág/AvPág cambia de tema en la pelea, volumen con Inicio/Fin.
     Pide MusicManager en `SparkingZERO\Mods`. Los BGMMod se arman con el UE custom + Alpakit (WAV, looping).
     Bug conocido: la vista previa en el menú no suena; en la pelea sí.
   - https://www.nexusmods.com/dragonballsparkingzero/mods/949: ReOrderBGM.json ordena y oculta ("Locked").
   - https://www.nexusmods.com/dragonballsparkingzero/mods/93 (pide ModLoader, MusicManager, UtocByPass).
   - Ryo Framework (Reloaded-II): reemplaza por acb+cue en tiempo de ejecución; una carpeta con varios = aleatorio.
3. Escribir `docs/investigacion-previa.md` y elegir la vía. Recién ahí, la PC.

## Lo que quedó a medias

- La PC quedó como al principio de la sesión: v4 en las peleas del juego base, DLC de fábrica (md5 = el original),
  sin mods DLC en ~mods. Partida carga (captura fabrica-1).
- Las filas M_00xx/01xx/02xx (menús/historia) tienen LP poco conocido.
- Pedido de Fran sin empezar: que todos los personajes hablen en español y los diálogos tengan texto. En ~mods
  ya hay decenas de mods de voces latinas (*LAT*, *latino*); falta el inventario de quién queda sin español,
  y los subtítulos están en Opciones. Investigar primero, igual que la música.

## Lo que NO hay que volver a intentar

Las cuatro vías sobre el DLC de ESTADO_ACTUAL (callejones). El DLC no se toca: el guardado lo exige y su tabla
tiene que venir cifrada y firmada.

## Datos que no se pueden aproximar

- PC: SSH Fran@10.147.20.3, llave ~\.ssh\pc-cable, comandos por -EncodedCommand. Juego en
  `C:\Games\Dragon Ball Sparking ZERO\SparkingZERO`. Abrir: tarea `probar-juego`. Teclas + captura:
  `C:\Users\frans\herramientas\lp-trabajo\scripts\pc-teclas.ps1 -Teclas SPACE,WAIT2000 -Nombre x`.
- Respaldo del guardado: `C:\Users\Fran\lp-todo\respaldo-save-1724` (MainGameSaveData 100811 B).
- Respaldo del DLC de fábrica: `SparkingZERO\Mods-desactivados\DLC-anime-audio-original`.
- Loader de la PC: `Binaries\Win64\dsound.dll` + `plugins\DBSparkingZeroUTOCBypass.asi`; carpetas en `Mods\`
  (ZeroSpark, SZModLib, UnlockCharacters...). MusicManager NO está.
- Ids de contenedor del DLC: Pack1 38afd04a86bee775, Pack2 8dddabc8ac3898e2. Clave AES en sz-extractor\config.ini.
- Trabajo de audio: `C:\Users\frans\herramientas\lp-trabajo` (RETOME.md, LISTO\, scripts\).

## Si hay que abrir un chat nuevo

Ver el mensaje de retome de la sesión del 2026-11-21 17:50 (también al final de su última respuesta).
