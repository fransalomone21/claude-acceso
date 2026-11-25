# Estado actual — juegos-casa

**Última actualización:** 2026-11-25

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Concepto (Pre-Fase A), con el spike de Double Dragon II | **en curso**: (a) el sí de Fran, dado el 2026-11-25 (requisitos v0.2 en línea base); falta (b), la demora de Double Dragon II en red |
| 1 — El índice | **cerrada** el 2026-11-25 (criterio cumplido y el sí de Fran) |
| 2 — Los espacios retro | sin abrir |
| 3 — Pantalla dividida a dos pantallas (spike) | sin abrir |

**Qué cierra la fase en curso:** (a) el sí de Fran al concepto y a los requisitos L0-L1; (b) Double
Dragon II jugado de a dos entre la notebook y la PC, cada uno en su pantalla, con la conexión, la demora
en cuadros y el MD5 de la ROM medidos (`PDP.md` §4).

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| Notebook: 9 GB libres de 931, 23,8 GB de RAM; sin RetroArch, RetroBat, Playnite, Moonlight ni Apollo | `Get-PSDrive`, `Test-Path` de cada ruta | 2026-11-24 |
| PC: 106 GB libres de 953, 15,3 GB de RAM, RTX 3090; su cuarentena ya está vacía (0 GB) | por SSH: `Get-PSDrive`, tamaño de la carpeta | 2026-11-24 |
| La ROM de Double Dragon II ya está bajada por Fran | `Descargas\Double Dragon II - The Revenge (Japan).zip`, adentro un `.md` de 1 MB (7-Zip) | 2026-11-24 |
| Los 7 comprimidos «no sé qué es» de la cuarentena de la notebook son 6 juegos de PS2 (God of War II NTSC y PAL, GTA SA latino, Simpsons Hit & Run latino, PES 6, LEGO Batman) | listados con 7-Zip y la contraseña que dio Fran | 2026-11-24 |
| La planilla que mandó Fran es la base pública de packs de ROMs de Retro Rusty (links de descarga), con nombres de carpeta de RetroBat | leída como CSV | 2026-11-24 |
| 1.21.1 es la versión de Minecraft más nueva con casi tantos mods como 1.20.1 | API de Modrinth (va a `minecraft-amigos`) | 2026-11-24 |
| **Double Dragon II en red anda**: RetroArch 1.22.2 portable en `C:\Games\RetroArch` de las dos, Genesis Plus GX, ROMs con MD5 igual; la PC se unió a la notebook por ZeroTier en ~40 s | `Get-NetTCPConnection`: `10.147.20.2:55435 <- 10.147.20.3 Established`; `docs/spike-double-dragon.md` | 2026-11-24 |
| Ghost of Sparta (pkg + rap) en `C:\Games\PS3-ISOs\` de la PC y 5 ISOs de PS2 en `C:\Games\PS2-ISOs\` (GoW II PAL, GTA SA latino, Simpsons latino, PES 6, LEGO Batman), MD5 y tamaño verificados | log de la copia y tamaños exactos por SSH | 2026-11-24 |
| La notebook pasó de 9 a 121 GB libres: cuarentena vaciada, zip de CoD y rar de DBZ duplicados borrados (cada ISO verificado antes), intermedios del Sparking borrados (quedó `LISTO`), todo con el sí de Fran | `Get-PSDrive` antes y después | 2026-11-24 |

| 16 clásicos de a dos de Mega Drive (Streets of Rage 1-3, Golden Axe I-III, Double Dragon 1 y 3, Battletoads & DD, TMNT Hyperstone Heist, Gunstar Heroes, Contra Hard Corps, ToeJam & Earl, Sonic 2 y 3, Mega Bomberman) en `C:\Games\RetroArch\roms\megadrive` de las dos, MD5 igual (18/18 con DD II y Chase) | `Compare-Object` de los dos listados MD5; tabla en `docs/spike-double-dragon.md` | 2026-11-25 |
| Accesos «ser anfitrión / unirse / los dos en esta máquina» de los 17 de red + Chase, una subcarpeta por juego en `Escritorio\Juegos\Juegos de a dos` de las dos (52 cada una), generados por `scripts/instalar-retroarch.ps1` + `scripts/juegos-de-a-dos.csv` | conteo de `.lnk` y argumentos leídos por COM en las dos | 2026-11-25 |
| Los dos escritorios ya tenían una sola carpeta `Juegos`; los 4 accesos sueltos viejos de DD II/Chase se mudaron a `C:\Games\_deshacer\accesos-sueltos-2026-11-25` (planilla y deshacer: `docs/orden-escritorio-2026-11-25.md`) | listado de los escritorios por SSH y local; Grep del repo | 2026-11-25 |
| `LEEME.txt` en `Escritorio\Juegos` de las dos = `docs/LEEME-lo-hecho-y-lo-que-se-puede.md` (reescrito con el índice) | MD5 igual en los tres | 2026-11-25 |
| **El índice en las dos máquinas** (L1-01, L1-02, L1-11, L1-12, L2-*): note 45 juegos, PC 54, desde `scripts/catalogo.json` (63 juegos) | `indice.py verificar`: «VERDE: el indice esta completo», 0 sin catalogar, 0 accesos viejos sin lugar, 0 accesos rotos | 2026-11-25 |
| **Forma nueva del índice** (pedido de Fran, tarde): juegos de PC sueltos, Sega / PS2 / PS3 / Android, Minecraft ordenado (Servidores, Otros launchers), `Clasificados\`; 39 íconos de juego (carátulas de libretro-thumbnails para Sega y PS2, ICON0 de cada juego de PS3) en `C:\Games\_indice\iconos` de las dos | `generar` verde en las dos, dos veces seguidas (el almacén no cambia: 66 accesos en la note); sabotajes en rojo y control verde en las dos; captura de la carpeta Sega con las carátulas | 2026-11-25 |
| El generador dejaba accesos vacíos cuando un servidor no existe en esa máquina (`continue` dentro de un `switch` de PowerShell) y el control los perdonaba | arreglado: el control da rojo con un destino vacío (lo dio con los dos accesos malos puestos) y el generador los saltea | 2026-11-25 |
| El verificador discrimina | `indice.py sabotaje`: un acceso borrado del disco da rojo nombrando el juego; un juego sacado del catálogo da «sin catalogar» con su ROM; el índice real, verde (en las dos) | 2026-11-25 |
| El control de accesos rotos encontró uno que ya estaba: Ghost of Sparta apuntaba a `Escritorio\Programas` (no existe desde el 12/11); ahora sale del RPCS3 donde está instalado | rojo L1-03 → verde después del arreglo | 2026-11-25 |
| **Las carpetas del índice de la notebook abren solas en íconos grandes** (las carátulas se ven): `indice.py generar` escribe un `desktop.ini` (plantilla Imágenes) en las 62 carpetas y las deja de solo lectura | `scripts/medir-vista.ps1`: Juegos, Sega y la carpeta más honda de Clasificados en vista 1 / ícono 96 (sale 0); una carpeta sin el archivo, vista 4 / ícono 16 (sale 1); `generar` dos veces seguidas y `sabotaje` en rojo como debe, control verde | 2026-11-25 |
| Los 18 de Mega Drive arrancan en la notebook con la config nueva | capturas en `C:\Games\_pruebas\caliente-2026-11-25\` (hoja.png): 18 pantallas de inicio | 2026-11-25 |
| RetroArch de las dos con la config de red nueva (2 cuadros de demora, chequeo cada 30) | `retroarch.cfg` leído: `netplay_input_latency_frames_min = "2"`, `netplay_check_frames = "30"`, nick Fran / Kheven | 2026-11-25 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| RetroArch en red con Genesis Plus GX conecta la notebook y la PC con 0-2 cuadros de demora (L1-05) | el indicador de netplay en una partida | la conexión se midió; la demora no |
| Las carpetas del índice de la PC abren en íconos grandes (el `desktop.ini` ya está: `generar --maquina pc` a las 16:33 del 2026-11-25 escribió 65, índice verde) | `medir-vista.ps1` como tarea interactiva en la PC | a las 16:13, 16:20 y 16:35 alguien la usaba (sesión activa, Steam, Epic y Spotify): lo que abre ventanas no se corrió |
| Los 18 de Mega Drive arrancan en la PC | `scripts/caliente-sega.ps1` como tarea interactiva en la PC | el 2026-11-25 a las 12 alguien usaba la PC (sesión activa): nada se abre mientras la usan. En la note pasó 18/18 |
| El arreglo de red de RetroArch (2 cuadros) saca la desincronización | jugar Double Dragon II en red note-PC | escrito en la config, sin jugar todavía |
| El `.pkg` de God of War: Ghost of Sparta (9,1 GB) de la cuarentena ya está instalado en RPCS3 | encontrar su carpeta de juego en `dev_hdd0\game` del RPCS3 de la notebook | no se miró (la puerta pide declarar el sistema `rpcs3`) |
| La PC dibuja dos instancias y manda una a la notebook (Apollo + Nucleus Co-op u OBS) | fase 3, spike | nadie documenta la combinación; es lo último de la escalera |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Leer la wiki de emulación (gametechwiki) desde el navegador del panel | Cloudflare la bloquea | usar otras fuentes o pedirle a Fran que la abra |

## Lo próximo

El sí de Fran al concepto (cierra la 0 y la 1); con la PC libre, en una sola pasada: `indice.py generar --maquina
pc` (íconos grandes), `medir-vista.ps1` y la prueba en caliente (`caliente-sega.ps1`), las dos como tarea interactiva; después
RetroBat con tema de cajas (sesión 6 del plan). El plan por sesiones está en `HANDOFF.md`.
