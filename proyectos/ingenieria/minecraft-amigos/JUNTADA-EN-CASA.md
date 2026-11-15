# Minecraft en casa — la guía rápida

Para jugar Fran (notebook) + su hermano (PC) en la misma casa, sin vueltas.
Sin requisitos ni fases: esto es la receta, medida el 2026-11-15.

## Lo que hay que saber de entrada

- **El "Abrir en LAN" NO sirve con estas cuentas.** El mundo LAN exige cuenta
  original; el hermano entra y lo patea al segundo con un "Disconnected" pelado
  (log de la notebook: `APRETIN1 (/10.147.20.3) lost connection: Disconnected`).
  No perder tiempo: **se usa el server**, que tiene `online-mode=false`.
- Las dos máquinas tienen la instancia de Prism **`Nuevo 1.21.4`** con los
  mismos 79 mods (Fabric 1.21.4). El server usa 62 de esos (los demás son sólo
  de cliente). Medido: los 62 del server están en las dos instancias.

## Las máquinas

| | Notebook (host) | PC (hermano) |
|---|---|---|
| Nombre | `MSI`, usuario `frans` | `PCFRAN`, usuario `Fran` |
| IP por cable (router) | 192.168.1.7 | 192.168.1.10 |
| IP ZeroTier | 10.147.20.2 | 10.147.20.3 |
| Instancia Prism | `%APPDATA%\PrismLauncher\instances\Nuevo 1.21.4` | ídem |

Las IP del router las da el DHCP: si cambian, `Get-NetNeighbor` en la notebook
las lista (la PC es la MAC `F0-2F-74-1C-1E-0D`).

## La receta (2 minutos)

1. **Arrancar el server en la notebook**: doble clic en
   `C:\Users\frans\MinecraftServer\juntada\iniciar-server.bat`. Está listo
   cuando la ventana dice `Done (…s)!`. Se apaga escribiendo `stop` en esa
   ventana (no con la X).
2. **En las dos máquinas**: Prism → `Nuevo 1.21.4` → Multijugador →
   Conexión directa:
   - notebook: `localhost`
   - PC: `10.147.20.2` (ZeroTier; anda siempre) o `192.168.1.7` (cable)
3. Listo.

## El mundo

- El server elige el mundo por `level-name` en
  `C:\Users\frans\MinecraftServer\juntada\server.properties`.
- **Mundo de los hermanos**: `hermanos-2026-11-15` (creado el 2026-11-15).
- El mundo viejo de la juntada con amigos (`juntada`, pregenerado con Chunky)
  sigue ahí intacto: para volver, `level-name=juntada`.
- Copia del properties anterior: `server.properties.bak-2026-11-15`.
- Mundo nuevo = cambiar `level-name` a un nombre que no exista y arrancar.

## Cómo entra la sesión a la PC (para no buscarlo de nuevo)

SSH con clave, sin contraseña:

```powershell
ssh -i "$env:USERPROFILE\.ssh\pc-cable" Fran@192.168.1.10 hostname   # o Fran@10.147.20.3
```

Para correr PowerShell allá sin pelear con comillas: armar el script, pasarlo
a base64 (UTF-16LE) y mandarlo con `powershell -NoProfile -EncodedCommand`.
Por SSH **no** se pueden abrir ventanas en el escritorio de la PC (corre en
otra sesión): el juego allá lo abre el que está sentado.

## Firewall

- Notebook: el `java.exe` del server (Prism `java-runtime-delta`) tiene regla
  de entrada sólo en perfil **Público**. ZeroTier es Público → anda. El cable
  es **Privado**, y aun así la PC llegó por `192.168.1.7:25565` el 2026-11-15
  (medido con `Test-NetConnection`); si un día no llega por cable, usar la IP
  de ZeroTier o crear la regla con permisos de admin:
  `New-NetFirewallRule -DisplayName 'Minecraft 25565' -Direction Inbound -Protocol TCP -LocalPort 25565 -Action Allow -Profile Private,Public`
  (la sesión no es admin: lo corre Fran en una consola como administrador).

## Avisos del log que son normales

- `Couldn't load pack metadata … Carnivorous Plants … min_format 88`: ese
  datapack es de una versión más nueva y no carga. Inofensivo.
- `[RecipeInjector] … mythicmetals:adamantite_forge_recipe`: receta duplicada,
  inofensivo.
