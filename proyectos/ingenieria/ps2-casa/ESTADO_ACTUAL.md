# Estado actual — ps2-casa

**Última actualización:** 2026-11-06

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-Fase A, *Concept Studies* | **en curso** |

**Qué cierra la fase en curso:** en PDP §6, con fecha, el concepto que eligió
Fran para cada consola (exploit de arranque + carga de juegos), y acá abajo el
ROMVER de las dos.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| Las dos consolas son SCPH-90001 NTSC U/C, códigos de fecha 8C y 1C | etiquetas, en fotos de Fran | 2026-11-06 |
| Hay **una sola** memory card: la «Sony 64 MB MagicGate» (las dos fotos eran su frente y su dorso; la etiqueta trasera dice SCPH-10020). No hay tarjeta de 8 MB; Agustín tendría una, para más adelante | Fran, 2026-11-06 («no tengo de 8 MB») | 2026-11-06 |
| Una de las consolas (falta saber si la 8C o la 1C): Browser 1.40, CD Player 2.00, PlayStation Driver 2.00, DVD Player **3.11U** | foto de «Version Information» (△ en el menú principal), Fran | 2026-11-06 |
| La consola medida es la **8C** | Fran | 2026-11-06 |
| La tarjeta de 64 MB TIENE homebrew: carpetas BOOT, APPS, OPL y cuatro «Free McBoot» (instalación múltiple), más partidas (Tom y Jerry, NFS MW…). En la 8C **no arrancó sola** | foto del navegador de la tarjeta, Fran | 2026-11-06 |
| **La 8C tiene chip**: arranca el BLACK grabado | Fran, 2026-11-06 | 2026-11-06 |
| Chip **Matrix Infinity 1.93**; R1 al prender lanza **uLaunchELF v4.43a** de la tarjeta | foto del menú de uLE, Fran | 2026-11-06 |
| uLE trae red: 192.168.0.10 / 255.255.255.0 / puerta 192.168.0.1. El cable a la notebook da enlace a 100 Mbps | foto + `Get-NetAdapter` (Ethernet 2 Up, 100 Mbps) | 2026-11-06 |
| La placa Ethernet de la notebook tiene 192.168.137.1/24 (la de Windows cuando comparte internet): no coincide con la de la PS2 | `Get-NetIPAddress` | 2026-11-06 |
| **La notebook llega a la PS2**: IP cambiada a 192.168.137.50 en uLE; ping 1 ms y puerto FTP 21 abierto | `ping` + `Test-NetConnection -Port 21` → True | 2026-11-06 |
| **Tarjeta respaldada entera** en `C:\Games\PS2-respaldos\mc0-2026-11-06\` (fuera del repo): 83 archivos, 3,4 MB, las 21 entradas de `/mc/0/`, cada tamaño igual al de la PS2. Ruta FTP de uLE (ps2ftpd): `/mc/0/`, no `/mc0/`; abre una conexión de datos por sesión, así que se reconecta por archivo | `respaldar_mc.py` (FALLAS 0) | 2026-11-06 |
| **OPL actualizado en la tarjeta** a v1.2.0-Beta-2271 (GitHub ps2homebrew, 2026-11-03) en `BOOT/OPNPS2LD.ELF`; el viejo (1 175 272 B) queda como `BOOT/OPL-VIEJO.ELF`. Más `OPL/lang_Spanish.lng` + `font_Spanish.ttf`, `language_text=Spanish`, y la red de OPL a 192.168.137.50 / puerta y SMB en 192.168.137.1 (share `PS2SMB`, ya estaba configurado) | `subir_mc.py` (tamaños) + relectura por FTP con MD5 igual. **Falta que Fran lo vea arrancar** | 2026-11-06 |
| La config heredada del OPL tenía `vmode=11` = **HDTV 1080i** (lista de `src/gui.c`): por el cable compuesto (blanco/rojo/amarillo) da pantalla negra. Y `usb_mode=0` = USB **apagado** (`START_MODE_DISABLED`). Corregido: `vmode=2` (NTSC 640x448i), `usb_mode=2` (auto), `eth_mode=1` (manual hasta que haya SMB), `default_device=0` (BDM/USB en la numeración nueva), `wide_screen=0`. Rescate si no se ve: △+X apretados al arrancar el OPL lo pasan a Auto | fuente de OPL + MD5 de la relectura | 2026-11-06 |
| uLE arranca solo el OPL a los 3 s (`LK_auto_E1 = mc:/BOOT/OPNPS2LD.ELF`, `LK_auto_Timer = 3`); X lo lanza ya. [probable] cualquier botón durante la cuenta lo frena | MD5 de la relectura; falta verlo en la tele | 2026-11-06 |
| **Tarjeta limpia** (pedido de Fran): borradas las partidas de Tom y Jerry (NTSC y PAL), NFS Carbon, NFS MW, MK Shaolin Monks, RE4 (datos de sistema), un `.srm` de SNES suelto en la raíz, y tres carpetas DBZ mal copiadas que ningún ISO usa (`BASLUS-21578`, `-217311`, `-217312`). Quedan `BASLUS-21678DBZT3` (la usan BT3 Remake, Anime War, Crossover y Niveles de Poder 8.1) y `BASLUS-21978DBZT4` (BT4 B14 y B14 REV2): las carpetas sacadas de los ELF de cada ISO. Todo lo borrado está en el respaldo del 2026-11-06 | `borrar_mc.py` (FALLAS 0, con prueba de la lista de protegidas) | 2026-11-06 |
| **Pendrive listo para jugar** (expulsado seguro): `D:\DVD\` LEGO Batman (PAL) + Simpsons H&R Latino; BT4 B14 REV2 partido (`ul.cfg` de 64 B bien formado, 6 partes que suman 5 396 742 144 B = el ISO, partes 00 y 05 con MD5 igual al tramo del ISO). BT3 Remake AF sacado (Fran: «no quiero uno AF»). Niveles de Poder 8.1 frenado para jugar ya: va después (`SLUS_219.99`, 4,67 GB, entra) | MD5 / tamaños | 2026-11-06 |
| Partida al 100 % de DBZ: no se encontró una fuente confiable (búsqueda web: sitios basura; la página de descarga del Team BT4 da 404). Abierto | WebSearch / WebFetch | 2026-11-06 |
| Pendrive D:\DVD\: BT3 Remake (MD5 igual al original). Anime War sacado (pedido de Fran; sigue en `C:\Games\PS2-ISOs\`). LEGO Batman (PAL) y Simpsons H&R Latino en copia; BT4 B14 REV2 partido en formato ul (6 partes de 1 GiB, `ul.60FFAAB6.SLUS_219.78.NN`, `herramientas/iso_a_ul.py`, CRC copiado de `USBA_crc32` de OPL `src/system.c`) | `ls` / MD5 | 2026-11-06 |
| La 1C no da señal de video | Fran | 2026-11-06 |
| El △ en el menú principal abre «Version Information» sin programas | la foto de arriba | 2026-11-06 |
| ISOs de PS2 en la PC: 13 (≈ 59 GB). En `C:\Games\PS2-ISOs\` 4 de DBZ/anime; en `Desktop\Juegos\Juegos de emulador\PS2\` BT4 Beta 14 y 14 REV2, Niveles de Poder 8.1, God of War II, BLACK y sus mods | búsqueda en todos los discos, archivos > 100 MB | 2026-11-06 |
| 5 ISOs pasan de 4 GB (GoW II 7,95; Black USA 7,29; BT4 5,03 y 4,98; Niveles 4,35): no entran en un pendrive FAT32, y el de 16 GB lleva 3 o 4 juegos | mismo listado | 2026-11-06 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| La tarjeta de 64 MB es un clon | que el exploit no se instale o no arranque desde ella | no se instaló nada |
| La consola 1C tiene ROM 2.30 | ROMVER en uLaunchELF | hace falta lanzar uLaunchELF en la consola |
| La 8C acepta FreeMcBoot | ROMVER + que arranque solo | idem |
| La tarjeta de 64 MB ya tiene FMCB (Fran recuerda entrar con un truco de botones) | prender con la tarjeta y ver el menú de FMCB, o R1 apretado al prender | falta que Fran lo pruebe |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|

## Lo próximo

Respaldar la tarjeta por FTP, juegos al pendrive (los que entran en FAT32) y
por red (SMB + OPL). El orden está en HANDOFF. Investigación: `docs/investigacion-red.md`.
