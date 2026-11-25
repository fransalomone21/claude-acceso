# La tienda de mods (fase 2)

| Archivo | Qué hace | Requisitos |
|---|---|---|
| `abrir-tienda.bat` | abre `tienda.py` (página + pack en `:8765`) y el navegador | L0-02, L1-07..09 |
| `tienda.py` | la página, `/api/catalogo`, `/api/armar` (POST), `/api/estado`, `/pack/...` | L1-02 |
| `armar.py` | resolver (núcleo + cartas + dependencias), castigos, cache con SHA-1, server de prueba, publicar; `--server` pone al día el server de la tienda | L1-05, L1-06, L1-10 |
| `catalogar.py` + `modrinth.py` | arma `datos/catalogo.json` desde la instancia Better MC 5 (por SHA-1) y los extras de `datos/curado.json` | L0-03 |
| `datos/curado.json` | cartas en castellano, familias, núcleo, combinaciones y lista de castigos (lo único que se edita a mano) | L1-07, L1-08, L1-09 |
| `datos/locales.json` | los 20 jars de Better MC 5 que no están en Modrinth | — |
| `sincronizar.ps1` | comando previo de Prism: iguala `mods/` al pack por SHA-1 | L1-03, L1-04 |
| `verificar-instancia.ps1` | compara una instancia contra el pack, sin tocar nada (0 igual, 1 distinto, 2 sin pack) | L1-03 |
| `crear-instancia.ps1` | crea «Tienda 1.21.1» en un Prism (memoria según RAM, entra a `:25568`) | L1-04 |
| `iniciar-server-tienda.bat` | prende el server de la tienda (25568) con lo último publicado | L1-12, L1-13 |
| `biblioteca.py` | copia los jars del cache a `C:\Games\Minecraft-mods\<familia>` de la PC | L1-11 |
| `paquete-kevin/` | instalador de doble clic para la compu de Kevin | L1-17 |
| `probar_tienda.py` | sabotajes y controles (S1 castigo, S2 dependencia faltante, S3 instancia distinta, S4 sin pack) | L1-03, L1-06, L1-10 |

Fuera del repo (pesa): `C:\Users\frans\MinecraftServer\tienda\` con `cache\`, `publicado\`, `prueba\`,
`server\` y `neoforge\` (NeoForge 21.1.267).

Sumar un mod a la tienda: agregarlo a `extras` y a una carta en `datos/curado.json`, correr
`python catalogar.py` (avisa si no existe o no tiene versión 1.21.1 NeoForge), y armar una combinación que lo
use: si el server de prueba no arranca, no se publica.
