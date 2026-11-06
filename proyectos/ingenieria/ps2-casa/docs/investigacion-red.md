# Qué se puede hacer con una PS2 Slim por Ethernet — investigación del 2026-11-06

Grado de cada línea entre corchetes. Nada de esto se probó todavía en las
consolas de la casa: lo `confirmado` es sólo lo que dicen varias fuentes que
coinciden, no lo medido acá.

## 1. Arrancar el cargador sin disco (la base de todo)

- [probable] SCPH-9000x con código de fecha **8A/8B** aceptan FreeMcBoot; desde
  **8C** es «tirar la moneda»; las de ROM **2.30** necesitan OpenTuna/FunTuna.
  Se sabe midiendo **ROMVER** en uLaunchELF (MISC → Debug Info, los 4 dígitos
  después de `rom0:ROMVER`). Fuente: FAQ del instalador de FMCB
  (israpps.github.io/FreeMcBoot-Installer/test/6_FAQ.html), r/ps2.
- [probable] El instalador de OpenTuna cubre ROM 1.10 a 2.30 y para 1.90-2.30
  usa el `icon_slims.cnf` (github.com/ps2homebrew/opentuna-installer;
  psx-place.com/resources/opentuna.1142).
- [hipótesis] En ROM 2.30 podría no arrancar solo (sólo lanzado a mano desde el
  navegador de la tarjeta). Hay un hilo de elotrolado que lo dice, sin fecha
  clara; FunTuna dice arrancar FMCB automático. **Se resuelve probando.**
- [probable] PS2BBL tiene paquete para las consolas que necesitan OpenTuna
  (israpps.github.io/PlayStation2-Basic-BootLoader).
- [probable] Una tarjeta que no es Sony puede no soportar las firmas de
  MagicGate que usa el exploit (consolemods.org/wiki/PS2:FMCB). Sony no hizo
  tarjetas de 64 MB: la de la casa es, muy probablemente, un clon.
- Para el primer arranque sin exploit en la Slim: FreeDVDBoot (un DVD quemado;
  consolemods.org/wiki/PS2:FreeDVDBoot).

### 1b. El primer arranque SIN disco (Fran no quiere quemar un DVD; 2026-11-06)

Una PS2 de fábrica no hace nada por red: el cable a la notebook no sirve hasta
que corre el primer programa casero. Caminos sin disco, de más moderno a menos:

| Camino | Qué destraba | Grado |
|---|---|---|
| **SD2PSX o MemCard PRO2** (memory card con microSD) | la imagen del exploit (PS2BBL/OpenTuna) se carga desde la PC al SD; además carga juegos desde el SD (MMCE) y una tarjeta virtual por juego | probable (sd2psxtd.github.io; timeextension.com 2025) |
| Memory card con OpenTuna ya instalado (compra) | el arranque, nada más | probable |
| La tarjeta con FMCB que Fran ya tenga, si existe | el arranque, gratis | pregunta abierta |
| Adaptador de memory card de PS3 a la PC | escribir la tarjeta original desde la PC | probable; adaptador raro y guías viejas |

[probable, 2026-11-06] **Ni el Ethernet ni el pendrive solos destraban una
consola de fábrica**: el sistema de Sony no ejecuta nada desde la red ni desde
USB, y ninguna fuente lista una entrada así. Las entradas conocidas son: una
tarjeta preparada (FMCB/OpenTuna), un disco (FreeDVDBoot, o la partida de un
juego original con exploit) o una tarjeta con microSD. Las fuentes: FAQ de
FMCB, README de FreeDVDBoot (github.com/CTurt/FreeDVDBoot), PS2BBL. La wiki de
vulnerabilidades (psdevwiki.com/ps2/Vulnerabilities) no se pudo leer: tiene
verificación anti-bots.

[probable] En ROM 2.30, PS2BBL funciona pero no arranca solo como
actualización del sistema (tabla de compatibilidad de PS2BBL): se lanza desde
el navegador de la tarjeta.

### 1c. La 8C tiene chip (2026-11-06): los botones al prender

[hipótesis] El chip es de la familia Modbo/Matrix Infinity (lo común en las
90001). Botones de Modbo 5.0 al prender (softandwarez.blogspot.com, 2017):
R1 → `mc0:/BOOT/BOOT.ELF`; △ → Infinity Manager; △+O → menú de configuración
del chip; X → navegador de Sony con el chip activo; START → chip apagado;
SELECT → arranque rápido; L1 → `hdd0:/__boot/boot.elf`. La tarjeta tiene una
carpeta BOOT: R1 lanzaría lo que tenga adentro.

## 2. Jugar los ISOs desde la PC, por cable

| Camino | Qué es | Grado | Nota |
|---|---|---|---|
| OPL por **SMB** | carpeta compartida de Windows; OPL lista y lanza los ISOs | confirmado (muchas fuentes) | ~2 a 2,5 MB/s leídos (gbatemp); alcanza para la mayoría |
| **Neutrino / OPL por UDPBD** | la PC sirve los juegos como disco por UDP | probable | más rápido que USB, MX4SIO y MMCE según consolemods.org/wiki/PS2:Neutrino; pide IP fija y editar config |
| USB (el pendrive) | OPL desde el pendrive | confirmado | USB 1.1: el más lento; respaldo para cuando la PC está apagada |

[hipótesis] Las dos consolas pueden leer de la misma carpeta SMB a la vez;
UDPBD, a medir (el servidor sirve un dispositivo de bloque).

## 3. Manejar la consola desde la PC

- [probable] **ps2link + ps2client**: desde la PC se manda a ejecutar un
  programa en la PS2, se la resetea o se la apaga (github.com/MegaBitmap/ps2client).
- [probable] **FTP de wLaunchELF** (menú PS2Net): ver y copiar los archivos de
  la tarjeta y el USB desde la PC. Advertencia: roto en varias versiones
  recientes; la última que anda bien sería la v4.43a de 2018
  (github.com/ps2homebrew/wLaunchELF/issues/53).
- [hipótesis] Tarjetas virtuales (VMC) de OPL guardadas en la carpeta de la PC:
  las partidas quedarían respaldadas solas. A verificar con la versión de OPL.
- Lo que **no** se encontró: control del mando por red, ni ver la pantalla de la
  PS2 desde la PC. No está en el alcance.

## 4. Jugar entre consolas y online

- [probable] Hay juegos con modo LAN/system link que andan entre dos PS2 en la
  misma red. Lista de juegos: a armar.
- [probable] Servidores revividos por fans (PS2Online, la comunidad de SOCOM),
  casi todos piden un rodeo de DNAS (es.wikipedia «PlayStation 2 online
  functionality»).
- [probable] XLink Kai: el modo LAN de un juego, llevado por internet.
