# Rutas de ps2-casa — el cajón exacto de cada cosa

**Se lee antes de buscar nada.** Lo que está acá ya se encontró: se abre la
ruta, no se vuelve a buscar. Si una ruta deja de existir, se corrige acá en el
mismo turno (y se dice con qué se midió). Fran, 2026-11-06: «lo buscás y lo
encontrás una vez; después se abre el cajón exacto, mecánicamente».

Medido el 2026-11-06 salvo donde se diga otra cosa.

## Las consolas y la red

| Qué | Dónde / valor |
|---|---|
| PS2 8C (la que anda) | SCPH-90001, chip Matrix Infinity 1.93 |
| Arranque a uLaunchELF 4.43a | prender con **R1**, sin disco, tarjeta en ranura 1 → `mc0:/BOOT/BOOT.ELF` |
| Otros botones del chip | △ → Infinity Manager · START → chip apagado · R2 → `BOOT2.ELF` · L2 → `BOOT3.ELF` |
| IP de la PS2 | `192.168.137.50` / 255.255.255.0 / puerta `192.168.137.1` (en `mc0:/SYS-CONF/IPCONFIG.DAT`) |
| Placa de la notebook hacia la PS2 | «Ethernet 2», `192.168.137.1/24` (cable directo, 100 Mbps) |
| FTP de la PS2 (uLE → ps2ftpd) | `ftp://192.168.137.50:21`, anónimo. La tarjeta es **`/mc/0/`** (no `/mc0/`); también `/mass/`, `/pfs/`. Una conexión de datos por sesión: reconectar por archivo |
| **Prender la red de la PS2** | en uLE: **MISC → PS2Net**. Sin eso la placa ni da enlace (la notebook ve «Ethernet 2: Disconnected»). Medido 2026-11-06 |
| Medir que la PS2 está | `ping 192.168.137.50` y `Test-NetConnection 192.168.137.50 -Port 21` → True |

## La memory card (`/mc/0/`)

| Qué | Ruta |
|---|---|
| **R1 al prender → OPL directo** | `BOOT/BOOT.ELF` = OPL v1.2.0-Beta-2271 (desde 2026-11-06 tarde) |
| uLaunchELF 4.43a (no actualizar: última con FTP sano) | `BOOT/BOOT2.ELF` (**R2** al prender), `BOOT/BOOT3.ELF` (**L2**), `BOOT/ULE.ELF` (pestaña Aplicaciones del OPL, `OPL/conf_apps.cfg`) |
| uLE **no lee** `SYS-CONF/LAUNCHELF.CNF` (su menú no muestra ni «X: OPL»): su arranque automático no sirve | foto de Fran, 2026-11-06 |
| OPL v1.2.0-Beta-2271 (copia) | `BOOT/OPNPS2LD.ELF` |
| OPL viejo (por si el nuevo falla) | `BOOT/OPL-VIEJO.ELF` |
| Config del OPL | `OPL/conf_opl.cfg` (vmode=2 NTSC 480i, usb_mode=2, eth_mode=1, default_device=0, Spanish) |
| Red del OPL | `OPL/conf_network.cfg` (SMB a `192.168.137.1`, share `PS2SMB`, puerto 445) |
| Español del OPL | `OPL/lang_Spanish.lng`, `OPL/font_Spanish.ttf` |
| Config de uLE (arranque solo del OPL a los 3 s, X = OPL) | `SYS-CONF/LAUNCHELF.CNF` (`LK_auto_E1`, `LK_auto_Timer`) |
| Partida BT3 (BT3 Remake, Anime War, Crossover, Niveles de Poder 8.1) | `BASLUS-21678DBZT3/` |
| Partida BT4 (Beta 14 y Beta 14 REV2) | `BASLUS-21978DBZT4/` |
| **Fuente de las partidas al 100 %** | tarjeta del emulador de la PC: `C:\Users\frans\Documents\<emulador>\memcards\BT3-TODO-DESBLOQUEADO.ps2` (BT3 + BT4); se lee con `python -m mymcplus <tarjeta> ls/extract` |
| Partidas DBZ que había antes en la consola | `C:\Games\PS2-respaldos\partidas-dbz-antes-de-100\` |
| ROM de la 8C | **2.30** (`rom0:ROMVER` = 0230AC20080220): Free McBoot no sirve (se sacó); OpenTuna sí |
| Instalador PS2BBL + OpenTuna | `BOOT/INSTALAR.ELF` (se corre desde uLE: ○ → mc0:/BOOT/) |
| Config de PS2BBL (qué arranca al prender) | `SYS-CONF/PS2BBL.INI` |

## En la PC

| Qué | Ruta |
|---|---|
| Respaldo entero de la tarjeta (antes de tocar nada) | `C:\Games\PS2-respaldos\mc0-2026-11-06\` |
| PS2BBL OpenTuna Installer bajado + `PS2BBL.INI` | `C:\Games\PS2-respaldos\ps2bbl-opentuna\` |
| Respaldo de la tarjeta antes de OpenTuna | `C:\Games\PS2-respaldos\mc0-2026-11-06-tarde\` |
| OPL bajado + configs editadas que se subieron | `C:\Games\PS2-respaldos\opl-1.2.0-beta-2271\` |
| ISOs (1) | `C:\Games\PS2-ISOs\` — Anime War, Crossover V2, BT3 Remake AF V6, dbzpoderes |
| ISOs descomprimidos de GamesGX (contraseña de los .7z/.rar: la del sitio) | `C:\Games\PS2-ISOs\_extraidos\` — GTA SA Latino v1.3, LEGO Batman (PAL), Simpsons H&R Latino 0.8 |
| ISOs (2) | `C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\` — BT4 Beta 14, BT4 Beta 14 REV2, Niveles de Poder 8.1, God of War II, Black y sus mods |
| Descargas de juegos (comprimidos) | `C:\Users\frans\Downloads\` |
| 7-Zip | `C:\Program Files\7-Zip\7z.exe` (la contraseña con `-p...` desde Bash: PowerShell 5.1 corta el argumento en el punto) |

## El pendrive (D:, SanDisk Cruzer Blade, FAT32, ~7 MB/s de escritura)

| Qué | Ruta |
|---|---|
| ISOs de menos de 4 GiB (OPL los lista solos) | `D:\DVD\` — LEGO Batman, Simpsons Hit and Run Latino |
| ISOs de más de 4 GiB, partidos (formato USBExtreme) | `D:\ul.cfg` + `D:\ul.<CRC>.<ID>.00..NN` — BT4 B14 REV2 (`ul.60FFAAB6.SLUS_219.78`), Niveles de Poder 8.1 (`SLUS_219.99`) |
| Tapas del OPL | `D:\ART\<ID>_COV.png` (140x200; **sólo PNG**: OPL 1.2 no busca JPG, `src/textures.c`; para los ISO de `DVD\` también con el nombre del archivo), armadas con `herramientas/armar_tapas.py` desde `C:\Games\PS2-respaldos\tapas\src\` (bajadas de github.com/xlenore/ps2-covers) |
| Tema visual | `D:\THM\thm_Pixel-Prime\` (github.com/PixeliGer/OPL-Theme-Pixel-Prime v1.3), `theme=Pixel-Prime` en `conf_opl.cfg` |
| Config por juego | `D:\CFG\<ID>.cfg` — LEGO Batman (PAL, `SLES_551.35`): GSM forzado a NTSC 480i (`$GSMVMode=0`) |
| IDs de los juegos | LEGO Batman `SLES_551.35` · Simpsons H&R `SLUS_206.24` · GTA SA `SLUS_209.46` · BT3 y mods `SLUS_216.78` · BT4 `SLUS_219.78` · Niveles de Poder `SLUS_219.99` |
| El pendrive es **GPT** y el OPL nuevo lo lee igual; tarda en aparecer (esperar o reconectar) | 2026-11-06 |
| Fotos de Fran (no tocar) | raíz de D: |

## Herramientas propias (`proyectos/ingenieria/ps2-casa/herramientas/`)

| Script | Para qué |
|---|---|
| `respaldar_mc.py <destino>` | baja `/mc/0/` entero por FTP, verifica tamaños |
| `subir_mc.py local=/mc/0/...` | sube a la tarjeta y verifica tamaño |
| `borrar_mc.py NOMBRE...` | borra entradas de `/mc/0/` por nombre exacto; nunca BOOT, OPL, SYS-CONF ni FMCB |
| `iso_a_ul.py <iso> D:/ <ID> "<nombre<32>" --dvd [--probar]` | parte un ISO > 4 GiB para OPL por USB |

## Fuentes que ya se consultaron

| Qué | Dónde |
|---|---|
| Código del OPL (modos de video, `ul.cfg`, CRC de las partes) | github.com/ps2homebrew/Open-PS2-Loader: `src/gui.c` (lista de vmode), `include/supportbase.h` (registro de 64 B), `src/system.c` (`USBA_crc32`), `src/bdmsupport.c` (USB lee `ul.cfg`), `include/iosupport.h` (números de dispositivo) |
| Releases del OPL | `gh release download latest -R ps2homebrew/Open-PS2-Loader` |
| Qué se puede hacer por red | `docs/investigacion-red.md` |
| Carpeta de partida de cada ISO | se lee del ELF del ISO (`7z e <iso> SYSTEM.CNF SLUS_*` y buscar `BASLUS-…`) |
