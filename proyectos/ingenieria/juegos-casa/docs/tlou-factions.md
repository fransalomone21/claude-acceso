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

*(vacío hasta la primera prueba)*

## Conclusión

Probable (no confirmado): Factions de PS3 se juega de a dos con el servidor casero; el autor lo jugó entre dos
máquinas con RPCS3 0.0.41 y la 01.11 o 01.00. Lo que no está probado para esta casa: que la notebook tenga la
versión de EE. UU. y la potencia, que un RPCN propio sin tickets firmados sirva, y que todo ande por ZeroTier.
Se prueba en ese orden, de lo más barato a lo más caro.
