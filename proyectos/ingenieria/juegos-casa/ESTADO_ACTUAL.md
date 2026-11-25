# Estado actual — juegos-casa

**Última actualización:** 2026-11-24

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Concepto (Pre-Fase A), con el spike de Double Dragon II | **en curso** |
| 1 — El índice | sin abrir |
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

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| RetroArch en red con Genesis Plus GX conecta la notebook y la PC con 0-2 cuadros de demora | el spike de Double Dragon II | es la fase 0, la sesión de ejecución |
| El `.pkg` de God of War: Ghost of Sparta (9,1 GB) de la cuarentena ya está instalado en RPCS3 | encontrar su carpeta de juego en `dev_hdd0\game` del RPCS3 de la notebook | no se miró (la puerta pide declarar el sistema `rpcs3`) |
| La PC dibuja dos instancias y manda una a la notebook (Apollo + Nucleus Co-op u OBS) | fase 3, spike | nadie documenta la combinación; es lo último de la escalera |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Leer la wiki de emulación (gametechwiki) desde el navegador del panel | Cloudflare la bloquea | usar otras fuentes o pedirle a Fran que la abra |

## Lo próximo

Sesión de ejecución (Sonnet, esfuerzo medio): pasar las ISOs de PS2 a la PC y liberar la notebook;
RetroBat en las dos máquinas; el spike de Double Dragon II. El plan por sesiones está en `HANDOFF.md`.
