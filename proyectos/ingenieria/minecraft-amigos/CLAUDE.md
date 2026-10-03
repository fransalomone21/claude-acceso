# Proyecto minecraft-amigos — contrato de contexto

Server de Minecraft con mods (Fabric 1.21.4) hosteado en la notebook de Fran,
para jugar con amigos por ZeroTier, y el paquete que les deja la instancia de
Prism lista con un doble clic y gráficos según su PC.

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

Sólo en la notebook de Fran (MSI, ZeroTier 10.147.20.2):

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
