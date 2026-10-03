# Estado actual — minecraft-amigos

**Última actualización:** 2026-10-03

## Dónde estamos

| Fase | Estado |
|---|---|
| 1 — La juntada del 2026-10-02 | **en curso** |

**Qué cierra la fase en curso:** al menos un amigo, desde su PC, instaló con
`instalar-juntada.bat` y entró al server 10.147.20.2 sin tocar nada a mano.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| Server Fabric 1.21.4 (loader 0.19.3) arranca con los 62 mods de servidor | log: `Done (10.9s)`, escuchando en 25565 | 2026-10-02 |
| El pack resuelve: 79 jars, todos en Modrinth, sha1 verificado | `armar_pack.py`: "sin version: ninguno; no-Modrinth: ninguno" | 2026-10-02 |
| El instalador anda en una PC real (esta) | corrido en auto → ALTO (RTX 4060, 24 GB) y forzado a MEDIO: options.txt, iris.properties e instance.cfg cambian como se espera | 2026-10-02 |
| Firewall: java.exe del server tiene regla de entrada en perfil Público (ZeroTier y wifi son Público) | `Get-NetFirewallApplicationFilter` | 2026-10-02 |
| Pregeneración con Chunky, radio 1200, en curso | `rcon.py "chunky progress"` | 2026-10-02 |
| **La PC** (usuario `Fran`): instancia `Nuevo 1.21.4` con los 79 jars del pack | paso 4: `Compare-Object` contra `manifiesto-nuevo.json` sin salida, 79/79, con control negativo en rojo | 2026-10-03 |
| **El server de la PC** es `C:\Users\Fran\MinecraftServer_1.21.4` (`server-port=25566`), y el mundo de verdad vive ahí (1.0 GB) | `motd` no dice "Nuevo 1.21.4" pero el puerto 25566 lo identifica (ver `SETUP_OTRA_PC.md`); sus 25 mods previos eran todos subconjunto del pack | 2026-10-03 |
| Ese server arranca con los 62 mods de servidor | `sincronizar_server.py`: `[ok] server con 62 mods (esperados 62); +37 nuevos, 0 a mods_viejos/`; log: `Done (1.940s)`, `Loading 149 mods`, 0 `Incompatible mods`, 0 `requires`, escuchando en 25566 | 2026-10-03 |
| **Paso 5 cumplido**: la instancia actualizada carga y entra al server, sin pantalla de mods faltantes | log del server: `fran joined the game` + `Receiving client config`, 03:30:56 | 2026-10-03 |
| El `ERROR key missing: bei_ExtraDragonFight` era benigno: migración de primer arranque de YungsBetterEndIsland | segundo arranque (03:42): 0 ocurrencias, `Done (0.774s)` | 2026-10-03 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| Un amigo entra por ZeroTier | que entre | no hay ninguno conectado todavía |
| El perfil MEDIO alcanza ~60 fps en las notebooks i5/i7 12.ª sin placa | F3 en esas notebooks | no hay acceso a esas máquinas |
| `carnivorous-plant-1.2` no aporta contenido: su datapack pide un formato de una versión más nueva (`min_format 88`) y 1.21.4 no lo carga | ver si aparecen sus plantas | **probable**, no hipótesis: el log del server de la PC lo dice textual — `Couldn't load pack metadata: No key pack_format ... min_format:88`. Falta ver el efecto en el juego |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Naturalist, Creeper Overhaul, Bumblezone, Farmer's Delight, Supplementaries, Aether, YIGD, Handcrafted, Graveyard, Bountiful, Guard Villagers | sin versión Fabric 1.21.4 en Modrinth | se quedaron afuera; si se migra a otra versión, revisar de nuevo |

## Lo próximo

Que entren los amigos. Después: decidir si el server queda para más sesiones (backups del mundo).

En la PC el runbook `docs/actualizar-instancia-pc.md` quedó **completo** (pasos
1-6, el 5 incluido). Respaldos del 2026-10-03 en el Escritorio de la PC:
`Nuevo-saves-backup.zip` (112.9 MB) y `world-backup.zip` (704.4 MB, 726
entradas, verificado abriéndolo). El server de la PC se reabre con
`C:\Users\Fran\MinecraftServer_1.21.4\start.bat` y se apaga escribiendo `stop`
en su ventana (`enable-rcon=false`: `rcon.py` no sirve en este server).
