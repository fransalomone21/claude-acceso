# Spike — Double Dragon II en red, cada uno en su pantalla (2026-11-24)

Fase 0 de `../PDP.md`, mitad (b). Requisitos que mide: L1-04 (conectar en menos de 180 s), L1-05
(demora de 0 a 2 cuadros), L1-15 (MD5 igual en las dos).

## Lo instalado (medido)

- RetroArch 1.22.2 estable (buildbot oficial) portable en `C:\Games\RetroArch` de las dos máquinas, con
  `genesis_plus_gx_libretro.dll` del nightly del 2026-11-24 (el mismo archivo copiado a las dos).
- ROMs: `Double Dragon II - The Revenge (Japan).md` MD5 `57169954F90BFEF473F4952B9633E57A` y
  `Chase H.Q. II (USA).md` MD5 `93CACC2D10B6176AFA16E4D08AB6EE1C`, **iguales en las dos** (L1-15: pasa).
- Accesos: notebook en `Escritorio\Juegos\Juegos de a dos`, PC en `Escritorio\Juegos de a dos`: «ser
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
