# The Last of Us (PS3) Factions de a dos: notebook y PC

**Abierto el 2026-11-25** por la sesión `tlou-factions` (lanzada por la principal de `juegos-casa`). Pedido de
Fran, textual: «quiero que dejes el tlou de ps3 andando de a dos cada uno en una pc, hace lo necesario ...
quiero un tlou cualquiera que haya para jugar multijugador».

Requisitos que traza: **L0-02** (cada juego de red de a dos, un jugador por máquina), **L1-04** (conexión en
180 s desde el primer doble clic), **L1-05** (demora: acá se mide la latencia de la partida, porque RPCS3 no
tiene indicador de cuadros de demora), **L1-15** (MD5 del juego igual en las dos máquinas).

## 1. Por qué este camino (lo ya descartado)

| Opción | Resultado | Fuente |
|---|---|---|
| The Last of Us Part I de PC | no tiene multijugador | ficha del juego |
| Mod de Factions para la Part II de PC | Sony lo frenó en septiembre de 2026 | prensa (PC Gamer, Wccftech, GamesRadar, 2026) |
| Versión de PS4 (Remastered) emulada | no hay emulación online de PS4 | — |
| **PS3 en RPCS3 + servidor casero** | **el único camino vivo** | este documento |

## 2. Lo que la comunidad ya resolvió (buscado afuera)

Fuentes leídas el 2026-11-25 (clon de `https://github.com/comradesean/tlou-factions-server`, commit
`0204949`, último push 2026-08-22, 4 estrellas):

- `README.md` y `client/README.md`: backend de cinco servidores en Python 3.8+ sólo con la biblioteca estándar
  (`server/run_all.py`): `http_gateway` (:80, contenido S3 y el Facebook falso), `ticket_server` (:7320),
  `session_manager` (:7314, partidas), `location_server` (:7312), `voice_server` (:7313).
- `research/notes/net1bin-server-list.md`: `net1.bin.psarc.crypt` lleva la IP del servidor de tickets
  (`50.18.104.153:7320`) como texto; el juego la usa directo, sin DNS. El formato está resuelto: Blowfish (la
  clave de los guardados de Naughty Dog) sobre un PSARC con zlib, y un encabezado de 24 bytes en claro (largo +
  HMAC-SHA1). `server/lib/psarc_crypt.py` tiene `extract` / `repack`, y el autor midió que su repack con la IP
  cambiada **lo acepta el juego** (`connect to 192.168.1.100:7320 ... connect ok`, 2026-08-14). El juego borra y
  re-extrae `net1.bin` en cada inicio de red: lo que vale es el `.crypt` servido, no un parche en el disco.
- `docs/capture-howto.md`: RPCS3 redirige nombres (no IPs) con «IP/Hosts switches», `host=ip` unidos por `&&`,
  el host es una regex de cadena entera, sin `http://`.
- `client/patches/`: dos `patch.yml`, cada uno con entradas para la 01.00 (`PPU-9df60dc1...`) y la 01.11
  (`PPU-120fb71f...`). `minplayers_patch.yml` baja el mínimo de «buscar partida» de 6 a 2 (hace falta en las dos
  máquinas, cualquiera puede quedar de anfitrión). `facebook_stub_patch.yml` es para los clanes de Facebook.
- `research/notes/2026-08-16-two-player-party-and-match-working.md`: dos máquinas reales, invitación a grupo
  por RPCN, unirse al grupo, partida real jugada; abiertos: el rango del otro no se ve, el equipo del otro sale
  al azar, una vez «Host quit for cheating» a los 3,5 s (no se repitió), un cuelgue de RPCS3.
- `server/session_manager.py` y `docs/capture-howto.md`: para que una sala llegue a la partida hizo falta el
  ajuste de RPCS3 **«Stub PPU Traps»**.
- El autor probó con **RPCS3 0.0.41** (`docs/tooling.md`).
- RPCN: `https://github.com/RipleyTom/rpcn`, release 1.12.1 (2026-10-20) con `rpcn-win.zip`. Su `rpcn.cfg`
  trae `EmailUrl=` vacío = **sin validación de mail**: las cuentas se crean desde RPCS3 sin mail real.
  Puertos: TCP 31313 y UDP 3657 (señalización).
- Búsqueda general (2026-11-25, «The Last of Us Factions PS3 RPCS3 revival server»): no aparece otro servidor de
  Factions de PS3; lo que hay en prensa es el mod de la Part II.

## 3. Lo que hace falta (el sistema)

| Pieza | Dónde | Nota |
|---|---|---|
| backend `run_all.py` | la PC (10.147.20.3, ZeroTier) | siempre prendida; la IP de ZeroTier sirve en casa y con Kevin |
| RPCN propio 1.12.1 | la PC, al lado del backend | sin mail; cuentas sólo con el sí de Fran |
| `net1.bin.psarc.crypt` (y `net10`) con la IP 10.147.20.3 | `server/data/served_content/` de la PC | sale de la copia propia (BCUS98174DATA2) |
| RPCS3 con BCUS98174 + la misma actualización | las dos | la note hoy tiene la versión EU (BCES01584): no sirve |
| IP/Hosts switches, RPCN apuntado a 10.147.20.3, «Stub PPU Traps», los dos parches | config por juego de las dos | |
| firewall de la PC: TCP 80, 7312-7314, 7320, 31313; UDP 3657 | la PC | |

## 4. Riesgos

- **Guardados de la familia**: se respaldan con MD5 antes de tocar la config de RPCS3 (`dev_hdd0/home/*/savedata`).
- **Versión de RPCS3 y de RPCN**: el protocolo de RPCN cambia entre versiones; si 0.0.37/0.0.39 no hablan con
  RPCN 1.12.1, se usa un RPCS3 aparte, igual en las dos, sin tocar los que ya hay.
- **Rendimiento**: TLOU en RPCS3 pide CPU; la notebook puede no dar (frena la tarea si no da).
- **«No se puede volver a armar `net1.bin`»**: se mide con `psarc_crypt.py extract` + `repack` ida y vuelta.

## 5. Predicción (escrita antes de probar)

*(se completa en cada prueba: predicción antes, medición después, y si la medición gana, la corrección acá
mismo)*

P1 — El repack de `net1.bin.psarc.crypt` sin cambios sale byte a byte igual al original (MD5 igual) y con la IP
cambiada da `HMAC OK` al releerlo.

P2 — Con el backend y el RPCN en la PC, la PC arranca TLOU, entra a Facciones online y el log del
`ticket_server` muestra su conexión desde 10.147.20.3; la notebook hace lo mismo desde 10.147.20.2.

P3 — Una invitación a grupo de una a la otra y «buscar partida» con el parche de mínimo 2 llevan a una partida
de dos en menos de 180 s desde el primer doble clic (L1-04), con latencia entre las dos máquinas por debajo de
30 ms por ZeroTier en la red de casa (L1-05, medida con `ping` durante la partida).

## 6. Lo medido

### 2026-11-25 ~16:45 — las dos máquinas (sólo lectura)

| Qué | Medido | Cómo |
|---|---|---|
| RPCS3 **0.0.43-20568-b94078be** en `C:\Games\RPCS3` de **las dos** (el mismo build) | confirmado | primera línea de `log\RPCS3.log` en cada una |
| La carpeta `rpcs3-0.0.39-18592-win64` de la PC corre en realidad **0.0.41-19512** | confirmado | su `RPCS3.log` |
| PC: la **actualización 01.11** de BCUS98174 está en `dev_hdd0\game\BCUS98174` del 0.0.41 (0,26 GB) | confirmado | `PARAM.SFO` (01.11 y 01.00 adentro) |
| **El disco de EE. UU. (BCUS98174) NO está en ninguna máquina.** PC: `games.yml` apunta a `Downloads\Last of Us, The (USA) (En,Fr,Es,Pt).iso`, que no existe; notebook: apunta a `Downloads\The Last of Us\`, que no existe. Tampoco el europeo de la note (`Downloads\The Last of Us ps3\...`) | confirmado | `Test-Path`, búsqueda por nombre en todo `C:` de las dos (sin seguir uniones), papeleras de las dos |
| Ningún RPCS3 de las dos tiene `config\rpcn.yml`: nadie usa RPCN hoy | confirmado | listado de `config\` |
| El índice de las dos muestra «The Last of Us (PS3)» aunque falte el disco: el inventario lo da por presente leyendo `games.yml`, sin medir que la ruta exista | confirmado | `inventario/note.json` (entradas `BCUS98174` / `BCES01584` con rutas de Descargas) |

**Lo que cambia**: sin el disco no hay juego que arrancar, y la sesión no baja juegos (R-01). El encargo partía
de «la copia está en las dos máquinas»: era una lectura de `games.yml`, no una medición. Hace falta que Fran
vuelva a poner la copia de EE. UU.

### 2026-11-25 ~16:45 — P1, el armado de `net1` y `net10` (en la notebook, scratchpad)

Predicción (P1, arriba): ida y vuelta byte a byte igual; con la IP cambiada, `HMAC OK`.

- `net1.bin.psarc.crypt` (65 160 bytes, MD5 `b2f315865c1537cd895aaa1bce4dbbcb`) y `net10.bin.psarc.crypt`
  (102 368 bytes, MD5 `a80c0446f20014a0d4d4287faf365eb8`) **se bajaron del S3 original, que sigue vivo**
  (`http://t1.final.prod.s3.amazonaws.com/`, HTTP 200). El tamaño de `net1` coincide con el que cita el autor.
  `net1` es de la 01.00 y `net10` de la 01.11 (`docs/served-content.md` del repo del servidor).
- `psarc_crypt.py extract` → `repack` sin cambios: **MD5 igual al original en los dos** (P1, primera mitad:
  confirmado).
- IP `50.18.104.153` → `10.147.20.3` (una ocurrencia en cada uno, mismo largo rellenando con ceros, 9 bytes
  distintos): `repack` y releído, **`HMAC OK`**, la IP nueva 1 vez y la vieja 0 (P1, segunda mitad: confirmado
  el armado; que el juego lo acepte se mide recién con el juego corriendo).
  MD5 de los parcheados: `net1` `39e0ccd4fc54073ac30c659503a1e9a5`, `net10` `9a91295c0585f1fe124a84aeac1cf712`.

**Estado al frenar (2026-11-25 ~16:50)**: no se instaló ni se cambió nada en ninguna máquina (todo lo de arriba
fue lectura o archivos en el scratchpad de la sesión). No hay nada que desinstalar.

### 2026-11-25 ~17:10 — lo que no depende del disco (Fran: «en 20 min se descarga la de usa»)

La europea tampoco estaba en ninguna máquina (medido arriba), así que no hubo nada que probar con ella.

| Qué | Medido | Cómo |
|---|---|---|
| Respaldo del RPCS3 0.0.43 (savedata, `config`, `patches`) en `C:\Games\_respaldos\tlou-2026-11-25` | note 18 archivos, PC 19, **0 distintos** | `md5-original.csv` al lado, recomparado |
| Servidor en la PC: `C:\Games\tlou-factions\servidor` (commit `0204949`) + RPCN 1.12.1 (`rpcn-win.zip`, MD5 `7C62BAD910FEEA06A6FA0E5C97FE598B`, certificado propio con `--cert-gen`) | **los 7 puertos escuchan** (TCP 80, 7312, 7313, 7314, 7320, 31313; UDP 3657 en `[::]` con IPv6-only apagado, que también recibe IPv4: `udp_server.rs` de RPCN) | `scripts/tlou/servidor-tlou.ps1 -Estado` |
| Arranca con la tarea **a pedido** `TLOU-servidor` (sin disparador, S4U: sin ventana) y sigue corriendo al terminar la tarea | confirmado | `Start-ScheduledTask` y `-Estado` 25 s después |
| Firewall de la PC: regla `TLOU Factions (juegos-casa)`, perfil privado, sólo 10.147.20.0/24 y 192.168.1.0/24 | confirmado | los 6 TCP conectan **desde la notebook** por ZeroTier (28-41 ms) |
| El servidor entrega el `net10` parcheado | HTTP 200, 102 368 bytes, **MD5 `9A91295C...`** = el parcheado | `curl` desde la note con `Host: t1.final.prod.s3.amazonaws.com` |
| Latencia note-PC | ZeroTier 27,7 ms de media (máx. 41); la PC a la note por la LAN da 23,8 ms: **lo pone el Wi-Fi de la notebook**, no ZeroTier (va DIRECT por 192.168.1.3) | `Test-Connection`, `zerotier-cli peers` |
| La PC cambió de IP en la LAN: hoy es **192.168.1.3**, no .7 | confirmado | `Get-NetIPAddress` en la PC |
| Actualización **01.11** (EBOOT.BIN + patch1.psarc, 15 archivos) en `C:\Games\RPCS3\dev_hdd0\game\BCUS98174` de **las dos** | **MD5 igual** en los 15 (L1-15, mitad de la actualización) | lista MD5 de la PC contra la de la note |
| Lado jugador en las dos (`scripts/tlou/cliente-tlou.ps1`): `custom_configs\config_BCUS98174.yml` (Stub PPU Traps 1, Internet y RPCN prendidos, IP swap list a 10.147.20.3), `rpcn.yml` apuntado a `10.147.20.3:31313` sin cuenta, los dos parches y `patch_config.yml` con «min players = 2» y el Facebook falso para 01.00 y 01.11 | puestos (ninguno existía antes; se sacan con `-Deshacer`) | salida del script |

**Cuentas de RPCN (2026-11-25 ~17:05, con el sí de Fran: «pone Fran y el otro nombre pone Male»)**: `Fran` en
la notebook y `Male` en la PC, creadas en el RPCN de la casa con `scripts/tlou/rpcn-cuenta.py` (cliente propio
del protocolo de RPCN 1.12.1; mail ficticio `@casa.lan`, que el RPCN de la casa no valida; la clave se genera ahí
y sólo vive en el `rpcn.yml` de cada máquina). El log de RPCN dice `Successfully created account Male`, y
`rpcn-cuenta.py --probar` entra con cada una (**login OK en las dos**). Sin control negativo del login (una
clave mala que dé rojo): se intentó y lo frenó el permiso de la sesión; queda pendiente.
Primer intento fallido: el avatar vacío lo rechaza (`get_string(false)` de RPCN); se manda el avatar por
defecto de RPCS3.

Predicción P1-bis (antes de arrancar el juego): con el disco, el log del RPCS3 va a decir `PAT: Applied patch`
para las tres entradas de 01.11, y el `http_gateway.log` de la PC va a mostrar el pedido de `net10.bin.psarc.crypt`.

### 2026-11-25 ~17:25 — el disco llegó y el primer arranque en la notebook

- Fran bajó la copia de EE. UU. a la notebook: `Last of Us The (USA) (EnFrEsPt).zip` (32 117 159 081 bytes) con
  la ISO **ya desencriptada** (`Last of Us, The (USA) (En,Fr,Es,Pt).iso`, 35 380 920 320 bytes, MD5
  `4E2B4C0E03B54189DE0AB97FC3A36C3C`), extraída a `C:\Games\PS3-ISOs\`. El zip queda en Descargas (R-02).
- RPCS3 lee ISO desde el commit «ISO: Add ISO reader code and ISO device» (2026-01-09), anterior a este build.
- `jugar-factions.ps1`: servidor OK, juego OK contra la referencia, RPCS3 abierto: ventana
  `FPS: 30.97 | Vulkan | 0.0.43-20568 | The Last of Us™ [BCUS98174]` a los 45 s (**la notebook lo mueve**).
- ~~Del lado del servidor (17:25:42): el juego pidió `net10` y se conectó al `ticket_server` con la IP parcheada
  (P1 confirmado en vivo).~~ **CORREGIDO a las 17:50: era falso, el actor equivocado.** El `GET
  /net10.bin.psarc.crypt` del log es de las 16:53 y su `User-Agent` es `curl/8.22.0`: la prueba de la sesión. Y
  las conexiones a :7320 que cerraron sin mandar nada (17:25:42, dos, y 17:49:06, dos) son el `Test-Servidor`
  de `jugar-factions.ps1`, que abre y cierra ese puerto para ver si el servidor vive (las de las 17:49 salieron
  del sabotaje, que no abrió el juego). **Lo que sí pidió el juego** (`User-Agent: DNTG-HTTPC/1.1`, 17:27): `GET
  /patch.psarc.crypt` de `t1.patch.s3.amazonaws.com` (el S3 original ya no lo tiene; el servidor responde 200
  vacío) y `GET /campaign3.config.txt.crypt` (bajado del S3 vivo y guardado). O sea: **la IP swap list anda**
  (el juego llegó a nuestro servidor por nombre); **que acepte el `net10` parcheado sigue sin medir** (lo pide al
  entrar a Facciones). Arreglo: la prueba de vida del lanzador pasa al puerto 7312 (`location_server`), que no
  ensucia el log de tickets.
- RPCN: `Authentified as Fran` desde 10.147.20.2, con `SyncTrophies` y `GetNetworkTime`: el RPCS3 de la notebook
  entró solo con su cuenta.
- RPCS3 tiene el `RPCS3.log` abierto en exclusivo mientras corre: lo de adentro (parches aplicados) se lee al
  cerrarlo.

### 2026-11-25 ~17:55 — Fran en el gym («avanza tranquilo»): la sesión maneja el juego de la notebook

- La notebook no tiene mando conectado («Wireless controller not detected», captura `00.png`): el perfil activo
  pasa a **Default** (teclado: Start = Enter, X = X, Círculo = C, flechas) mientras la sesión lo maneja; el
  original (`ps4 dualshock`) está en `C:\Games\_respaldos\tlou-2026-11-25\active_input_configurations.yml.dualshock`
  y **se devuelve al terminar**. Teclas por scancode y una captura por paso: `scripts/tlou/rpcs3-teclas.ps1`
  (capturas en `C:\Games\_pruebas\tlou-2026-11-25\`).
- **Los parches no entraban**: RPCS3 0.0.43 sólo carga `patches\patch.yml`, `imported_patch.yml` y
  `patches\<TITLE_ID>_patch.yml` (`Utilities/bin_patch.cpp`: `append_global_patches` / `append_title_patches`); el
  README del servidor dice «cualquier .yml sirve» y en el primer arranque no hubo ni una línea `PAT:`. Arreglo:
  `scripts/tlou/unir-parches.py` arma `BCUS98174_patch.yml` (MD5 `A8DC505B...` igual en las dos). Segundo
  arranque: **`PAT: Applied patch`** para «min players = 2», «Facebook sign-in» y «Facebook Graph names» (01.11).
- Primer arranque (log copiado en `RPCS3-arranque1.log`): `Applying custom config ... config_BCUS98174.yml`, la IP
  swap list leída, `PPU executable hash: PPU-120fb71f...` (la 01.11, el hash de los parches), `DnsHook: Solving
  t1.patch.s3.amazonaws.com to 10.147.20.3`, y **`rpcn: You are now logged in RPCN(Fran | Fran)!`**.
- Menú principal → «FACTIONS MP» → **«To connect to Factions you must download some FREE map content. OK / No»**
  (`03.png`). Es el pedido de la **actualización 1.09** (agosto de 2014): desde ahí Facciones exige bajar de la
  tienda de PS3 dos mapas gratis (Beach y Financial Plaza) ([blog de Naughty Dog](https://naughtydog.com/blog/the_last_of_us_patch_103_and_109_free_maps),
  [PlayStation Blog](https://blog.playstation.com/2014/08/29/the-last-of-us-free-maps-and-new-weapons/)). La
  tienda ya no existe y la sesión no baja contenido (R-01).
- **Camino que no depende de eso**: la **01.00 del disco** (anterior a la 1.09) y el servidor casero la soporta
  (parches con el hash `PPU-9df60dc1...`, `net1` para la 01.00, ya parcheado y servido). La actualización 01.11 de
  la notebook se movió (no se borró) a `C:\Games\_deshacer\tlou-actualizacion-0111\` (15 archivos). Con eso la 01.00
  compila sus módulos por primera vez.

### 2026-11-25 ~18:01 — la 01.00 entra a Facciones y habla con todo el servidor

- La 01.00 compila sus 147 módulos (~1,5 min la primera vez), muestra el menú viejo (NEW GAME / FACTIONS /
  OPTIONS / DOWNLOADABLES, `06.png`) y **FACTIONS no pide mapas**: «Connecting...» (`07.png`).
- **Del lado del servidor, ahora sí el juego** (18:00:48, desde 10.147.20.2): `ticket_server` recibe el hello de
  `heartbeat-server` y el comando `heartbeat Fran` («presence refreshed for 'Fran'»); `session_manager` recibe el
  `np_id` `Fran` y `ClientHello2` (0x146); `http_gateway` sirve `userdata/Fran.txt.crypt`, `profiles/Fran/profile.21`
  y **guarda el perfil** (`PUT ... profile.21`, 367 bytes). Esto prueba que el juego tomó la IP del servidor del
  `net1` parcheado (el de la 01.00): **P1 confirmado en vivo, ahora sin el actor equivocado**.
- Pantalla siguiente: **«ONLINE USER AGREEMENT»** de Sony (versión 1.00.063), con «DECLINE» / «ACCEPT» (Triángulo)
  y la afirmación de ser mayor de 18 (`08.png`). **La sesión no lo acepta en nombre de Fran** (aceptar términos
  pide su sí explícito): el juego queda abierto ahí en la notebook.
- La 01.11 de la PC también se apartó (no se borró) a `C:\Games\_deshacer\tlou-actualizacion-0111\` (15 archivos).
  La PC sigue con sesión activa (`quser`: activa, sin tiempo inactivo): no se abrió nada ahí.

### 2026-11-25 ~18:05 — Fran: «aceptalo, investiga ... los graficos corruptos, actualiza la pc y dejemos aca»

- **Acuerdo de Sony aceptado** con su sí (Triángulo, después ACCEPT y X; `09.png`-`10.png`). Lo que sigue
  (`11.png`): **«You need an Online Pass to access Online.»** (Redeem Online Pass Code / Purchase / Leave). La
  01.00 de lanzamiento traía el Online Pass de la caja (PS3, 2013; [MP1st](https://mp1st.com/news/the-last-of-us-is-officially-out-launch-patch-1-01-available-new-mp-videos));
  el servidor casero no lo trata (no hay nada sobre «Online Pass» en su repo). **Hoy no se llega a la partida**: con
  la 01.00 falta el Online Pass, con la 01.11 los mapas gratis de la tienda.
- **Gráficos corruptos** (el verde y las rayas de los menús que vio Fran; capturas `01.png`-`02.png`). Fuentes:
  - la base oficial de parches de RPCS3 (la que baja el Patch Manager, `rpcs3.net/compatibility?patch&api=v1&v=1.2`,
    sha256 verificado; `scripts/tlou/parches-oficiales.py`): 19 parches para la 01.00 y 27 para la 01.11. La nota
    de **«Disable in-built MLAA»** dice textual que *permite usar el escalado de resolución* y *arregla la "Green
    Rain"*; RPCS3 corre acá a **150 % de resolución**: es la causa probable del verde;
  - [issue #16296 de RPCS3](https://github.com/RPCS3/rpcs3/issues/16296): kd-11 (desarrollador de la GPU de RPCS3)
    pide *read depth, RSX detiling y strict rendering mode*; otros suman ZCULL relajado (placas Pascal; la 3090 y la
    4060 no lo son);
  - la [página de la wiki de RPCS3](https://wiki.rpcs3.net/index.php?title=The_Last_of_Us) (Cloudflare no deja
    leerla desde la sesión; lo que dice salió del resumen de la búsqueda: leer y escribir buffers de color y
    profundidad, «Handle RSX memory tiling», «Accurate RSX reservation access»).
- **Aplicado en las dos** (`cliente-tlou.ps1 -Actualizar`, MD5 iguales en las dos): la config del juego suma
  `Read/Write Color Buffers`, `Read/Write Depth Buffer`, `Handle RSX Memory Tiling`, `Strict Rendering Mode` y
  `Accurate RSX reservation access`; `patches\patch.yml` = la base oficial; `patch_config.yml` prende «Disable
  in-built MLAA», «Enable GPU Lighting» y «Depth border fix» para 01.00 y 01.11. En la notebook el log dice
  **`PAT: Applied`** para los seis (tres del servidor + tres de gráficos). **El efecto en pantalla no se miró**:
  Fran pidió «hacelo en frío, no abras más cosas» y se cerró el juego antes de la captura.
- El mando de la notebook volvió a `ps4 dualshock`. Nada abierto en ninguna de las dos.
- **Índice**: `tlou-ps3` suma «cada uno en su pantalla», el lanzador «The Last of Us - Facciones de a dos»
  (`C:\Games\tlou-factions\Jugar Facciones de a dos.cmd`) y su `de_a_dos` (estado: sin probar); `tlou-factions`
  entra a «no son juegos» (el inventario la tomaba como juego). `indice.py generar --maquina ambas`: **VERDE en las
  dos** (note 45 juegos, PC 54), con el acceso en `PS3\` y en `Clasificados\De a dos\The Last of Us (PS3)\`.
- **LEEME** con el estado, copiado a `Escritorio\Juegos\LEEME.txt` de las dos: MD5 `9ADFF31A...` igual en los tres.

## 7. Lo que falta (al 25/11, 18:15), en orden

1. **Pasar la traba de entrada**, una de dos: (a) en la 01.00, el Online Pass: buscar en el EBOOT el chequeo
   (`sceNpDrmIsAvailable` / entitlement) y un parche que lo dé por bueno, como hizo el autor con el de Facebook; o
   (b) en la 01.11 (sin Online Pass), los mapas gratis: o el paquete del DLC gratis lo aporta Fran (R-01), o un
   parche que saltee el chequeo de «FREE map content». Antes, buscar si la comunidad ya lo resolvió.
2. Mirar en pantalla el arreglo de gráficos (con Fran libre o con su OK para abrir ventanas).
3. La primera partida de a dos: invitación por RPCN, buscar partida con el mínimo de 2, cronómetro (L1-04) y ping
   durante la partida (L1-05).
4. La PC: abrir allí el juego sólo con la PC libre (`quser` sin actividad).
5. Prueba en rojo pendiente: login de RPCN con una clave mala.

## 7b. Lo que falta, en orden, cuando vuelva el disco (escrito antes; los pasos 1-5 quedaron hechos)

1. Fran pone la copia de EE. UU. (BCUS98174, carpeta o ISO) en la PC, por ejemplo en `C:\Games\PS3-ISOs\`.
2. La sesión: MD5 del disco, copia a la notebook (MD5 igual, L1-15) y la actualización 01.11 a las dos.
3. Respaldo con MD5 de `dev_hdd0\home\*\savedata` y `config\` del RPCS3 0.0.43 de las dos.
4. Backend + RPCN 1.12.1 en la PC (firewall: TCP 80, 7312-7314, 7320, 31313; UDP 3657), `net10` parcheado servido.
5. Config propia del juego (IP/Hosts switches, RPCN apuntado a 10.147.20.3, «Stub PPU Traps»), los dos parches.
6. Cuentas de RPCN (con el sí de Fran), P2 y P3, lanzadores en el índice y el LEEME.

## Conclusión

Probable (no confirmado): Factions de PS3 se juega de a dos con el servidor casero; el autor lo jugó entre dos
máquinas con RPCS3 0.0.41 y la 01.11 o 01.00. Lo que no está probado para esta casa: que la notebook tenga la
versión de EE. UU. y la potencia, que un RPCN propio sin tickets firmados sirva, y que todo ande por ZeroTier.
Se prueba en ese orden, de lo más barato a lo más caro.
