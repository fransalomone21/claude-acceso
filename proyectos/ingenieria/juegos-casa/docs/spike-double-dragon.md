# Spike — Double Dragon II en red, cada uno en su pantalla (2026-11-24)

Fase 0 de `../PDP.md`, mitad (b). Requisitos que mide: L1-04 (conectar en menos de 180 s), L1-05
(demora de 0 a 2 cuadros), L1-15 (MD5 igual en las dos).

## Lo instalado (medido)

- RetroArch 1.22.2 estable (buildbot oficial) portable en `C:\Games\RetroArch` de las dos máquinas, con
  `genesis_plus_gx_libretro.dll` del nightly del 2026-11-24 (el mismo archivo copiado a las dos).
- ROMs: `Double Dragon II - The Revenge (Japan).md` MD5 `57169954F90BFEF473F4952B9633E57A` y
  `Chase H.Q. II (USA).md` MD5 `93CACC2D10B6176AFA16E4D08AB6EE1C`, **iguales en las dos** (L1-15: pasa).
- Accesos: en `Escritorio\Juegos\Juegos de a dos` de las dos máquinas (corregido el 2026-11-25: decía que
  en la PC estaban en `Escritorio\Juegos de a dos`, medido que no; desde ese día, una subcarpeta por juego): «ser
  anfitrión», «unirse a la PC / la note» (por ZeroTier: anda en casa y desde afuera), «los dos en esta
  máquina» y Chase H.Q. II. Script: `../scripts/instalar-retroarch.ps1`.

## Predicción (escrita antes de probar)

1. La notebook abre como anfitrión y Windows pide permiso de red para RetroArch la primera vez (lo acepta
   Fran); sin ese permiso la PC no conecta.
2. La PC se une por ZeroTier (10.147.20.2) y el log de las dos dice que conectaron en menos de 30 s.
3. Por la red de la casa la demora queda en 0-2 cuadros.

## Lo medido

- **2026-11-24, ~22:32**: anfitrión en la notebook, la PC se unió por ZeroTier. `Get-NetTCPConnection` en
  la notebook: `10.147.20.2:55435 <- 10.147.20.3:49285 Established`. Conexión en ~40 s desde el primer
  doble clic (L1-04: **pasa**, con margen contra 180 s).
- Predicción 1: el permiso de red no hizo falta pedirlo (o ya estaba): la conexión entró igual.
- Predicción 2: la conexión, sí; el log, **no**: RetroArch no escribió `retroarch.log` (`log_to_file`
  pide además la verbosidad prendida). La evidencia es la conexión TCP, no el log.
- L1-05 (demora en cuadros) **no se midió**: queda para la partida de Fran y Kevin, mirando el indicador
  de netplay. Las dos ventanas de prueba se cerraron.

## 2026-11-25 — 16 clásicos más, con la misma receta

Sacados del pack de Mega Drive que bajó Fran (`Descargas\Sega Genesis Megadrive (SG-M)-…zip`, 1179 entradas;
el `Fusion.exe` y el `.apk` que trae **no** se extrajeron). Cada `.bin`, renombrado limpio, en
`C:\Games\RetroArch\roms\megadrive\` de las dos máquinas. **L1-15 pasa para los 18**: el MD5 de las 18 ROMs
medido en las dos da 0 diferencias (`Compare-Object` de los dos listados, 18/18 líneas).

| ROM | MD5 |
|---|---|
| Streets of Rage.bin | 569CFEC15813294A8F0CF88CCCC8C151 |
| Streets of Rage 2.bin | CB75D5A6919B61EFE917BEA5762C1CB7 |
| Streets of Rage 3.bin | 2D0B0C8F10EDF76131708E874E8D1EE4 |
| Golden Axe.bin | 04D2C7DA9AAC3FBEADF6BB8CCD27B560 |
| Golden Axe II.bin | 2CD3573172961FA52F622F14CCFF4E1A |
| Golden Axe III.bin | 945CF1786CC7B28C02F1A127A0C58209 |
| Double Dragon.bin | 6C34E2FD2B6800194DFAD16FADAEF820 |
| Double Dragon 3.bin | 783A70FD1A6339D947A2BA8556BD7BBA |
| Battletoads and Double Dragon.bin | 78F3EA32BCB4F627E4F9BC9711E017B8 |
| TMNT The Hyperstone Heist.bin | 30EDE62C8EFE3E046E5409758B091EB6 |
| Gunstar Heroes.bin | 9A369CFC6355DB48677771E345421E0E |
| Contra Hard Corps.bin | 2BD30479556DA5C310D8F2A1FE66E8FA |
| ToeJam and Earl.bin | 0A6AF20D9C5B3EC4E23C683F083B92CD |
| Sonic 2.bin | 9FEEB724052C39982D432A7851C98D3E |
| Sonic 3.bin | D724EA4DD417FE330C9DCFD955C596B2 |
| Mega Bomberman.bin | 514F6CAD98F5F632D680983A050FFFC4 |

Accesos: `scripts/instalar-retroarch.ps1` generalizado (lee `scripts/juegos-de-a-dos.csv`), una subcarpeta por
juego en `Escritorio\Juegos\Juegos de a dos` de las dos, 52 accesos en cada una; nick `Fran` en la note,
`Kheven` en la PC (el que ya tenía). Con RetroArch abierto el script **no** toca `retroarch.cfg` (al salir lo
reescribe). **Sin probar en caliente todavía**: Fran y Kevin estaban jugando; la prueba con captura de cada uno
queda para cuando terminen.
