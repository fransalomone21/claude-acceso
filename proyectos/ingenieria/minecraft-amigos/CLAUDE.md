# Proyecto minecraft-amigos — contrato de contexto

Minecraft con mods para jugar con Kevin y los amigos por ZeroTier. Desde la fase 2 (2026-11-24): **1.21.1 con
NeoForge y la tienda de mods** (`tienda/`): Fran elige mods y combinaciones en una página de la notebook, se
prueban en un server de prueba, y las instancias de cada máquina se ponen iguales al pack al abrir el juego. La
fase 1 (Fabric 1.21.4, server `juntada`, el paquete de los amigos) queda como historia y su server sigue
andando para jugar con el hermano.

**Naturaleza:** `ingenieria` — ver
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

**El plan y las fases están en [`PDP.md`](PDP.md).**

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| qué mods hay, de qué lado corren, de dónde salió cada uno | `pack/manifiesto.json` (generado) y `pack/agregar.txt` (lo pedido, comentado) |
| sumar o sacar mods | `pack/agregar.txt` → `herramientas/armar_pack.py` → copiar al server los que no son `servidor: unsupported` |
| tocar el server | `servidor/` (plantillas) y `herramientas/rcon.py` |
| tocar el instalador de los amigos | `paquete/instalar-juntada.ps1` |
| poner la PC de Fran (instancia + su server, puerto 25566) al día con el pack | `docs/actualizar-instancia-pc.md` (pasos 1-6, mecánico) |
| **jugar en casa con el hermano** (server `juntada`, mundo de los hermanos) | `JUNTADA-EN-CASA.md` |
| **la fase 2: el pack nuevo (1.21.1 NeoForge) y la tienda de mods** | `docs/10-requisitos.md` (contra qué se construye) y `docs/fase-2-tienda.md` (la versión medida, Better MC 5, packwiz, las combinaciones, la V&V) |
| **usar o tocar la tienda** (qué hace cada script, sumar un mod) | `tienda/LEEME.md` |
| ideas de la tienda que no se hicieron (shaders por combinación, packs de cielo, «Espacio B» con Stellaris) y los candidatos espaciales medidos | `docs/mc-tienda-hallazgos.md` |

## Las reglas propias de este proyecto

1. **El repo es público**: la clave de RCON, la lista de miembros de ZeroTier
   y sus IPs físicas **no** entran acá. La clave vive sólo en
   `C:\Users\frans\MinecraftServer\juntada\rcon-password.txt`.
2. **La cuenta offline de Prism la resuelve cada uno.** La sesión no automatiza
   el truco de `accounts.json` que finge la compra del juego.
3. Un mod nuevo entra por `agregar.txt` + `armar_pack.py` (verifica sha1 y trae
   dependencias), nunca copiando un jar a mano: el manifiesto es lo que dice
   qué va al server.

## Dónde está cada cosa

```
pack/          agregar.txt (lo pedido) y manifiesto.json (lo que quedo, generado)
servidor/      server.properties e iniciar-server.bat (plantillas que se copian al server)
paquete/       instalar-juntada.bat/.ps1 y LEEME.txt (lo que reciben los amigos)
herramientas/  modrinth_check.py, armar_pack.py, empaquetar.py, rcon.py
```

## Dónde corre esto

**Fase 2 (la tienda):** en la notebook, `C:\Users\frans\MinecraftServer\tienda\` (cache, publicado, prueba,
server en el puerto 25568, NeoForge 21.1.267) y la página en el puerto 8765; la instancia «Tienda 1.21.1» en
el Prism de la notebook y de la PC; la biblioteca de jars en `C:\Games\Minecraft-mods\` de la PC. Los accesos
de cada máquina los arma el índice de `juegos-casa` en `Escritorio\Juegos\Minecraft`. **Desde el 2026-11-27 la tienda
tiene también la versión 1.21.4 Fabric** (L1-20): `TIENDA_VERSION=1.21.4`, página en 8766, server en 25569,
`C:\Users\frans\MinecraftServer\tienda-1.21.4\`, instancia «Tienda 1.21.4», biblioteca en
`C:\Games\Minecraft-mods\1.21.4\` (el cuadro de las dos, en `tienda/LEEME.md`).

**El mundo con Agus (1.21.4):** server en la notebook, `C:\Users\frans\MinecraftServer\agus-1.21.4`, puerto 25566,
sin RCON: se apaga con `stop` en su ventana o con `herramientas/escribir-en-consola.ps1 -Proceso <pid del java>`.
Su pack es `pack/agregar.txt` + `armar_pack.py` (instancia «Nuevo 1.21.4»), no la tienda.

**Fase 1** — sólo en la notebook de Fran (MSI, ZeroTier 10.147.20.2):

- Instancia de Prism: `%APPDATA%\PrismLauncher\instances\Juntada 1.21.4`
  (la base fue `Nuevo 1.21.4`, que no se toca).
- Server: `C:\Users\frans\MinecraftServer\juntada` (fuera del repo: pesa).
- Paquete para los amigos: `C:\Users\frans\MinecraftServer\paquete-amigos`,
  espejado en Drive privado `Mi unidad/Minecraft/La Juntada`.

Una sesión que no tiene eso al alcance tiene que **decirlo**, no simular.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
