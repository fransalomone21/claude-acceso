# La tienda de mods (fase 2)

**Dos versiones, un solo código** (L1-01, L1-20): cada proceso atiende una, elegida por `TIENDA_VERSION` (`perfil.py`).

| Versión | Página y pack | Server de la tienda | Datos | Fuera del repo | Instancia |
|---|---|---|---|---|---|
| 1.21.1 NeoForge (principal) | `abrir-tienda.bat`, `:8765` | `iniciar-server-tienda.bat`, `:25568` | `datos/` | `MinecraftServer\tienda\` | «Tienda 1.21.1» |
| 1.21.4 Fabric (el mundo con Agus) | `abrir-tienda-1.21.4.bat`, `:8766` | `iniciar-server-tienda-1.21.4.bat`, `:25569` | `datos-1.21.4/` | `MinecraftServer\tienda-1.21.4\` | «Tienda 1.21.4» |

Cada página tiene arriba el botón para pasar a la otra. Por consola, la 1.21.4 es la misma orden con
`$env:TIENDA_VERSION='1.21.4'` antes. El mundo de Fran y Agus (`MinecraftServer\agus-1.21.4`, `:25566`) **no** es de
la tienda: su pack sigue siendo `pack/agregar.txt` + `armar_pack.py`; la combinación «El mundo con Agus» de la tienda
es ese mismo pack, con un mundo propio en el server de la tienda.

| Archivo | Qué hace | Requisitos |
|---|---|---|
| `abrir-tienda.bat` | abre `tienda.py` (página + pack en `:8765`) y el navegador | L0-02, L1-07..09 |
| `tienda.py` | la página, `/api/catalogo`, `/api/armar` (POST), `/api/estado`, `/pack/...` | L1-02 |
| `armar.py` | resolver (núcleo + cartas + dependencias), castigos, cache con SHA-1, server de prueba, publicar; `--server` pone al día el server de la tienda | L1-05, L1-06, L1-10 |
| `perfil.py` | las dos versiones: Minecraft, cargador, puertos, carpetas y nombre de la instancia | L1-01, L1-20 |
| `catalogar.py` + `modrinth.py` | arma `catalogo.json` desde la base (1.21.1: la instancia Better MC 5; 1.21.4: «Nuevo 1.21.4»), por SHA-1, y los extras de `curado.json`; una dependencia de la base sin versión suelta queda en `deps_adentro` (viene dentro del mod) | L0-03 |
| `datos/curado.json` (y `datos-1.21.4/curado.json`) | cartas en castellano, familias, núcleo, combinaciones, lista de castigos, `deps_faltan` (dependencias que el mod pide al arrancar y Modrinth no declara) y `lado_forzado` (un mod que Modrinth marca de un solo lado y otro lo pide en los dos: Fusion, para Rechiseled) — lo único que se edita a mano | L1-06, L1-07, L1-08, L1-09 |
| `datos/locales.json` | los 20 jars de Better MC 5 que no están en Modrinth | — |
| `sincronizar.ps1` | comando previo de Prism: iguala `mods/` al pack por SHA-1 | L1-03, L1-04 |
| `verificar-instancia.ps1` | compara una instancia contra el pack, sin tocar nada (0 igual, 1 distinto, 2 sin pack) | L1-03 |
| `crear-instancia.ps1` | crea «Tienda 1.21.1» en un Prism (memoria según RAM, entra a `:25568`); `-Version 1.21.4` crea «Tienda 1.21.4» (Fabric, `:25569`) | L1-04 |
| `iniciar-server-tienda.bat` | prende el server de la tienda (25568) con lo último publicado, y el pack (8765) si estaba apagado | L1-12, L1-13 |
| `probar_red.py` | prende el server, prueba desde la PC el 25568 por ZeroTier y por la red de casa (con un puerto de control) y lo apaga con `stop` | L1-12, L1-13 |
| `biblioteca.py` | guarda en `C:\Games\Minecraft-mods\<familia>` de la PC **cada** jar del catálogo (baja al cache lo que falte), por SHA-1; `--solo-verificar` sólo mide | L1-11 |
| `paquete-kevin/` | instalador de doble clic para la compu de Kevin | L1-17 |
| `probar_tienda.py` | sabotajes y controles (S1 castigo, S2 dependencia faltante —1.21.4: Mutant Monsters sin Puzzles Lib—, S3 instancia distinta, S4 sin pack) | L1-03, L1-06, L1-10 |
| `probar_sin_publicar.py` | arranca una combinación o unas cartas en el server de prueba sin tocar lo publicado | L1-05 |
| `verificar_cartas.py` | cada carta en una subfamilia de su familia y con 2-3 fotos (`--sabotaje` exige el rojo) | L1-18, L1-19 |

Fuera del repo (pesa): `C:\Users\frans\MinecraftServer\tienda\` con `cache\`, `publicado\`, `prueba\`,
`server\` y `neoforge\` (NeoForge 21.1.267); `C:\Users\frans\MinecraftServer\tienda-1.21.4\` igual, con `fabric\` en
vez de `neoforge\` (el lanzador oficial de Fabric 0.20.1 y lo que baja; se arma una vez con
`python armar.py --preparar-fabric`, y si se le da un server Fabric que ya anda —`C:\Users\frans\MinecraftServer\agus-1.21.4`—
copia de ahí, sólo leyendo, lo que ya bajó de Mojang).

Sumar un mod a la tienda: agregarlo a `extras` y a una carta en `datos/curado.json` (con su `familia` y su `sub`,
una de `subfamilias`), correr `python catalogar.py` (avisa si no existe o no tiene versión 1.21.1 NeoForge, y trae
sus fotos de Modrinth), `python verificar_cartas.py`, y armar una combinación que lo use: si el server de prueba no
arranca, no se publica. La página: sectores desplegables, subsectores adentro, y en cada carta «Ver fotos».
