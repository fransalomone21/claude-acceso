# Estado actual — minecraft-amigos

**Última actualización:** 2026-10-02

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

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| Un amigo entra por ZeroTier | que entre | no hay ninguno conectado todavía |
| El perfil MEDIO alcanza ~60 fps en las notebooks i5/i7 12.ª sin placa | F3 en esas notebooks | no hay acceso a esas máquinas |
| `carnivorous-plant-1.2` no aporta contenido: su datapack pide un formato de una versión más nueva (`min_format 88`) y 1.21.4 no lo carga | ver si aparecen sus plantas | venía de la base `Nuevo 1.21.4`; no rompe el arranque |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Naturalist, Creeper Overhaul, Bumblezone, Farmer's Delight, Supplementaries, Aether, YIGD, Handcrafted, Graveyard, Bountiful, Guard Villagers | sin versión Fabric 1.21.4 en Modrinth | se quedaron afuera; si se migra a otra versión, revisar de nuevo |

## Lo próximo

Que entren los amigos. Después: decidir si el server queda para más sesiones (backups del mundo).
