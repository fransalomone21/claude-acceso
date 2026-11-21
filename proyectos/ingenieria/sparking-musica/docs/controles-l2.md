# Controles: "a uno de los jugadores no le anduvo el L2" (Sparking ZERO, PC de casa)

Pedido de Fran, 2026-11-21, relayado por la sesión de arquitectura (DA-145/146). No es del proyecto de la
música: se anotó acá porque es la misma PC y el mismo juego, y no hay otro proyecto que lo tenga. Si crece,
va a un proyecto propio (o a `ps2-casa`/`dbz-niveles`, según lo que decida Fran).

## 1. Lo medido en la PC (sin cambiar nada) — 2026-11-21 ~19:00

| Qué | Dato | Cómo se midió |
|---|---|---|
| Mandos | **dos DualShock 4 v2** (USB VID 054C, PID 09CC), los dos por **cable USB**, los dos presentes y en estado OK | `Get-PnpDevice` por SSH |
| Cómo los ve Windows | winmm: `joy0` y `joy2` responden (el `joy1` no existe); en reposo los dos dan L2 y R2 = 0, botones = 0 | `joyGetPosEx` 6 muestras por mando |
| Deriva en reposo | `joy2`: el eje R (stick derecho, vertical) descansa en ~36 500 sobre 32 767 (≈ +11 %); `joy0`: todos los ejes a ≤ 4 % del centro | mismas muestras |
| Steam | instalado, **no corre**; el juego es la versión **ElAmigos con `steam_emu.ini`** (SteamInput=SteamInput006 del emulador), o sea **sin Steam Input real** | procesos + `steam_emu.ini` |
| DS4Windows | **no corre**. Está bajado y configurado (carpeta en `Desktop\Juegos\Juegos instalados`, perfil `Default.xml` sin remapeos, DS4 activado, "Exclusive mode" apagado; última config guardada 05/09/2026) | procesos + `%APPDATA%\DS4Windows` |
| Drivers virtuales | **ViGEm Bus** (Nefarius) y el bus de gamepad sintético de Xbox, los dos presentes | `Get-PnpDevice` |
| Config del juego | los mapeos de los mandos no están en un `.ini`: el juego los guarda en `SystemSaveData`/`MainGameSaveData` (binarios, sin tocar) | búsqueda de `.ini` |
| Pantalla | los íconos del menú son de PlayStation (✕ ○): el juego reconoce los DS4 como mandos PlayStation | captura `revision-1-1.png` |

Lo que **no** se midió: qué mando era el que falló, ni con qué se estaba jugando entonces (si DS4Windows
estaba abierto). Un L2 apretado a propósito, que es lo único que distingue "mando" de "juego": ver §4.

## 2. Lo que ya sabe la comunidad (afuera primero, DA-145)

Búsqueda hecha el 2026-11-21; **no hay un hilo de Sparking ZERO sobre "L2 que no responde en el segundo
mando"**. Lo que hay:

- Steam, hilo de Sparking ZERO: [Ps5 controller is trippin](https://steamcommunity.com/app/1790600/discussions/0/4846527127885649358).
  Un mando PlayStation anda mal "casi siempre"; **cerrar la app DS4 (DS4Windows) lo arregló** a dos
  usuarios (comentarios #3 y #4); desactivar Steam Input no alcanzó. Otro: "los botones del pad derecho no
  andan" = **modo zurdo activado** (Opciones → Controles y cámara → Accesibilidad → modo zurdo [off], #9).
- Otros juegos, mismo síntoma (L2/R2 muertos en mandos PlayStation en PC), arreglos que repiten:
  [Path of Exile](https://www.pathofexile.com/forum/view-thread/3594757) (gatillos muertos por Bluetooth;
  funcionan por USB o con Steam Input; reconectar por USB y confirmar los gatillos lo arregla) y
  [Rocket League](https://rocketleaguehelp.epicgames.com/help/en-US/c-Category_RocketLeague/c-RocketLeague_TechnicalSupport/how-do-i-troubleshoot-rocket-league-controller-issues-on-steam-a000084351)
  (con "soporte de configuración PlayStation" de Steam prendido; y reset del DS4 con el botón chico de atrás,
  al lado del L2, 3-5 s con un clip).
- Dos mandos locales en UE5: lo que se repite es que un dispositivo de más (otro joystick, un volante) o una
  herramienta de mando virtual (DS4Windows, x360ce, vJoy) toma el lugar del segundo
  ([Split Fiction, EA](https://forums.ea.com/discussions/ea-originals-discussion-en/split-fiction-cant-add-player-2-local-pc/12286336)).
- Desgaste: los gatillos de un DS4 viejo dejan de llegar al 100 % con los meses
  ([Steam: PS4 controller R2 not working](https://steamcommunity.com/discussions/forum/1/1696043806569248963)).
- El ajuste de L2 de cada preset: Clásico pone Ki (carga) en L2; Estándar lo reparte distinto
  ([gamepressure](https://www.gamepressure.com/newsroom/sparking-zero-controls-keyboard-xbox-controller-and-ps5-dualsense/z773d9)):
  un jugador con el preset Clásico y otro con Estándar **sienten** que "el L2 no hace lo mismo".
- No pude leer PCGamingWiki (Cloudflare lo bloqueó) ni la doc de DS4Windows (el navegador negó el sitio):
  esas dos quedan sin leer.

## 3. Hipótesis, ordenadas por lo que cuesta descartarlas

| # | Hipótesis | Grado | Qué la descarta o la confirma |
|---|---|---|---|
| 1 | **DS4Windows (o ViGEm) estaba abierto** cuando fallaba y el segundo mando llegaba duplicado o por el bus virtual | `hipotesis` (lo respalda el hilo de Steam; hoy no está corriendo) | Fran dice si en ese momento estaba abierto; hoy no hay nada que cambiar (no corre) |
| 2 | Los dos mandos tienen **presets o modo zurdo distintos** guardados en el juego | `hipotesis` | Mirar Opciones → Controles de cada jugador con los dos mandos |
| 3 | El **L2 físico** de uno de los DS4 está gastado o flojo (gatillo que no llega, o con el eje en reposo mal) | `hipotesis` | prueba de §4: el eje de L2 tiene que ir de 0 a ~32 767 en los dos |
| 4 | Un dispositivo de más tomó el lugar del segundo mando | `probable` que NO sea: hay solo dos DS4 presentes; el `joy1` vacío es un hueco de numeración | ya medido |

## 4. Lo que solo Fran puede probar (un paso)

Con el juego **en el menú** (nadie peleando), apretar **L2 a fondo y mantenerlo 3 s**, primero en un mando y después
en el otro, mientras la sesión lee los ejes por SSH. Resultado esperado si el mando está sano: el eje de L2
sube de 0 a ~32 767 y los botones suben el bit de L2. Si uno de los dos no sube, es del mando (hipótesis 3).
Si suben los dos, es del juego/preset/DS4Windows (hipótesis 1-2).

## Conclusión

**Todavía no hay causa; no hay nada que cambiar.** Lo medido descarta una parte: los dos mandos son DS4 por
cable, presentes y sanos a nivel Windows en reposo (L2/R2 = 0), y no hay DS4Windows ni Steam Input corriendo,
así que el mapeo por programas externos no puede ser lo que falló hoy. Lo que queda es el mando (hipótesis 3,
la prueba del §4 lo decide en 20 s) o la configuración guardada en el juego (hipótesis 2). Detalle aparte:
el stick derecho del `joy2` descansa con ~11 % de deriva en el eje vertical; no explica el L2, pero puede
molestar en la pelea. Cambios en la PC: **ninguno**; por eso no hizo falta respaldo ni `-Investigacion`.
