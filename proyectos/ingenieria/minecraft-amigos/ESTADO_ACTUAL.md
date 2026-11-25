# Estado actual — minecraft-amigos

**Última actualización:** 2026-11-25

## Dónde estamos

| Fase | Estado |
|---|---|
| 1 — La juntada del 2026-10-02 (Fabric 1.21.4) | **cancelada** el 2026-11-24: la reemplaza la 2 (el server y los mundos 1.21.4 quedan) |
| 2 — El pack nuevo (1.21.1 NeoForge) y la tienda de mods | **en curso**: tienda construida y con sabotajes en verde; falta que Fran la use y juegue con Kevin |

**Qué cierra la fase en curso:** (a) Fran arma una combinación desde la tienda y las instancias de la
notebook y de la PC quedan iguales al pack (SHA-1) al abrir el juego; (b) los sabotajes de la tienda dan
rojo; (c) Fran y Kevin juegan en el server de la notebook (`PDP.md` §4).

**Lo nuevo del 2026-11-24 (medido):** 1.21.1 es la versión más nueva con casi tantos mods como 1.20.1
(33 826 contra 35 652 en Modrinth); Better MC 5 (NeoForge 1.21.1) trae 271 jars sin temperatura ni sed;
Tough As Nails estaba en el pack 1.21.4 (`pack/manifiesto.json`) y es el «frío y calor» que a Fran no le
gustó. Detalle: `docs/fase-2-tienda.md`. Desde el 2026-11-15 hay además `JUNTADA-EN-CASA.md` (jugar con
el hermano: server `juntada`, mundo `hermanos-2026-11-15`).

**Hecho el 2026-11-24 a la noche (para jugar con Kevin):** Tough As Nails y GlitchCore movidos a
`mods_fuera_de_pack` en el server `juntada`, en las instancias `Juntada 1.21.4` y `Nuevo 1.21.4` de la
notebook y en `Nuevo 1.21.4` de la PC; el server arrancó sin ellos (Done en 36 s, apagado por RCON).
Instancia **«Better MC 5 (1.21.1)»** (sin Serene Seasons, 267 jars con SHA-1 verificado) en la notebook
y en la PC; su server en `C:\Users\frans\MinecraftServer\bmc5` (puerto 25567), reparándose de mods de
pantalla con `herramientas/server_sin_mods_de_cliente.py` (resultado en `bmc5-arreglo.log`). La tienda y
el combo espacial los construye la sesión «mc-tienda».

**La tienda, construida y probada (2026-11-25, sesión de juegos-casa; mc-tienda frenó a pedido de Fran):**
`tienda/` (índice en `tienda/LEEME.md`). Medido:

| Qué | Evidencia |
|---|---|
| 5 combinaciones (Aventura, Dimensiones y jefes, Con mecanismos, Espacial, Liviana) arrancan en el server de prueba y se publican en 32-101 s (L1-02, TBR 300 s: pasa) | `armar.py --combo <c>`: «server de prueba: arranco en 29-50 s», «listo en 32-101 s» |
| Sabotajes 7/7: Tough As Nails bloqueado sin llegar al server (L1-10); Cataclysm sin lionfish no se publica (L1-06); instancia con 1 de más, 1 de menos y 1 distinto da rojo nombrándolos y queda igual tras sincronizar (L1-03); verificador sin pack no da verde | `python tienda/probar_tienda.py` |
| Instancia «Tienda 1.21.1» en la notebook y en la PC, igual al pack (47/47 de la Liviana) | `verificar-instancia.ps1` exit 0 en las dos |
| La PC llega a la tienda por ZeroTier (`/pack/lista.json` 200) y el firewall de la notebook ya deja entrar a python | por SSH y `Get-NetFirewallApplicationFilter` |
| Publicada ahora: **Aventura minecraftera** (106 mods) | `publicado/lista.json` |

Decisiones: sin packwiz (no borra mods de más: L1-03), NeoForge propio 21.1.267 (los extras piden ≥ 21.1.195),
cada mod en su última versión 1.21.1 (con las de Better MC 5 Aquamirae y Mowzie's no arrancaban), filtro de
archivos mal etiquetados en Modrinth (Structory Towers de 26.2), **Better MC 5 entero fuera de la tienda** (con
versiones nuevas choca consigo mismo: curios duplicado; sigue como instancia y server 25567 propios).
Detalle: `docs/fase-2-tienda.md` §3b.

**Lo nuevo del 2026-11-25 al mediodía (revisión del diseño y pendientes):**

| Qué | Evidencia |
|---|---|
| **L1-11**: los 297 jars del catálogo (277 de Modrinth + 20 locales) en `C:\Games\Minecraft-mods\<familia>` de la PC | `biblioteca.py`: «SHA-1 presentes 297/297»; sabotaje: un jar renombrado en la PC da «FALTAN 1» nombrándolo, restaurado 297/297 |
| `biblioteca.py` esperaba sólo lo del cache: 2 mods del catálogo (crash-assistant, towns-and-towers) quedaban afuera sin aviso; y su `mkdir` era de cmd (el SSH de la PC abre PowerShell) | arreglado: espera el catálogo entero y baja lo que falta; todo comando a la PC va codificado |
| **L1-12 y L1-13**: el server de la tienda acepta a la PC por ZeroTier (10.147.20.2:25568) y por la red de casa (192.168.1.2:25568) | `tienda/probar_red.py`: «CONECTA» en las dos, el puerto de control 25599 «NO, como debe»; arrancó en 102 s y se apagó con `stop` |
| «Server de la tienda» prende también el pack (8765) si estaba apagado: un solo doble clic | prueba: antes apagado, después escuchando, la PC lo lee (200), una segunda vez no duplica |
| El server de prueba y el de BMC5 se trababan al apagar (nadie leía su salida después del Done) | `armar.py` y `server_sin_mods_de_cliente.py` siguen leyendo hasta que el server cierra |
| `probar_tienda.py` dejaba publicada la Liviana encima de lo de Fran | ahora guarda lo publicado y lo devuelve, y prende el pack si falta |
| Los accesos de Minecraft de las dos máquinas los arma el índice de juegos-casa (`Escritorio\Juegos\Minecraft`, con «Como jugar.txt») | `indice.py verificar` en verde en las dos |

**Lo nuevo del 2026-11-25 a la tarde (pedido de Fran: «muchos mods mas ... desplegables ... 2 o 3 imagenes ... sub
sectorizar ... mods de conejos»):**

| Qué | Evidencia |
|---|---|
| La tienda pasó de 34 a **86 cartas** (52 nuevas, con un subsector **Conejos** de 4 cartas) y de 5 a **6 combinaciones** («Granja, bichos y conejos», 103 mods, 5 GB) | `catalogar.py`: «catalogo: 353 proyectos; no resueltos: ninguno»; `/api/catalogo` sirve 86 cartas y 6 combos |
| Cada familia con 2-4 **subfamilias** (25 en total) y cada carta con un desplegable «Ver fotos» de 2-3 fotos (galería de Modrinth; si no alcanza, las imágenes de la página del mod) | `verificar_cartas.py`: «cartas 86: VERDE»; su sabotaje da rojo nombrando la carta; en el navegador: 9 sectores, 25 subsectores, fotos de 270 px |
| L1-18 y L1-19 nuevos en `docs/10-requisitos.md` (v0.2) | el documento |
| Twilight Forest quedó afuera: no está en Modrinth | `mc_verificar`: «NO EXISTE the-twilight-forest» |

**Los 52 nuevos juntos NO arrancan todavía** (server de prueba, sin publicar; lo publicado quedó igual): «Mod
irons_spellbooks requires irons_lib 1.21.1-2 or above, and below 1.21.1-3» y «Mod adorablehamsterpets requires
patchouli 1.21.1-93-NEOFORGE or above» (en 21 s, 133 mods). Falta sumar `irons-lib` a los extras y subir Patchouli
(la de Better MC 5 es más vieja), y repetir la prueba. Hasta entonces la tienda NO publica una selección con
«Iron's Spells» o «Hámsters» (la combinación «Granja, bichos y conejos» los trae): la frena L1-06, como debe.

**Falta:** que Fran agregue las cuentas sin conexión en Prism (en la note no hay ninguna: sin eso Prism no abre
el juego; en la PC, «Kheven»), arme un combo y entre con Kevin al server de la tienda — eso cierra la fase; el
paquete de Kevin está en `C:\Users\frans\MinecraftServer\tienda\paquete-kevin.zip`; L1-14 (TPS con spark) y
L1-15 (cliente al menú con 8 GB) piden el juego abierto con una cuenta.

**Lo de abajo es de la fase 1 y vale como historia.**

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
