# Handoff — minecraft-amigos

**Escrito el:** 2026-10-03 · **Fase al cerrar:** 1 (la juntada), abierta

## Arrancá por acá

Medir si el server está vivo antes de creerle a este archivo:
`python proyectos\ingenieria\minecraft-amigos\herramientas\rcon.py list`
(si no conecta, el server está apagado: `C:\Users\frans\MinecraftServer\juntada\iniciar-server.bat`).

## Lo que quedó a medias

- El server quedó corriendo **oculto** (sin ventana), lanzado por la sesión,
  con Chunky pregenerando radio 1200. Para apagarlo: `rcon.py stop`. Para el
  uso normal, Fran lo abre con `iniciar-server.bat` (con ventana; se cierra
  escribiendo `stop`). No abrir el .bat con el oculto corriendo: el puerto choca.
- Nadie se conectó todavía desde otra PC: la fase no está cerrada.
- **En la PC de Fran (usuario `Fran`, donde juega Agus)** quedó hecho el runbook
  `docs/actualizar-instancia-pc.md` pasos 1-4 y 6. Falta el **paso 5**: entrar al
  juego. Dos cosas a mirar antes:
  - Había un cliente de Minecraft corriendo desde 02:59 con el set de mods
    **viejo**. Hay que cerrarlo y relanzar, o va a dar mismatch contra el server.
  - El server quedó **arrancado con ventana** (`start.bat`, con `pause`): se apaga
    escribiendo `stop` en esa ventana. `enable-rcon=false` en este server, así que
    `rcon.py` **no** sirve acá (sí en el de la notebook).

## Lo que NO hay que volver a intentar

- Los mods de la tabla "Callejones" de `ESTADO_ACTUAL.md`: no existen para Fabric 1.21.4.

## Datos que no se pueden aproximar

- MC 1.21.4, Fabric loader 0.19.3, installer 1.1.2. Java: `%APPDATA%\PrismLauncher\java\java-runtime-delta` (21.0.7).
- Server: `C:\Users\frans\MinecraftServer\juntada`, puerto 25565, RCON 25575 (clave en `rcon-password.txt` ahí, no en el repo).
- IP ZeroTier del host: 10.147.20.2. Red: "Red de franquiito".
- Paquete: `C:\Users\frans\MinecraftServer\paquete-amigos` (zip 191 MB) = Drive privado `Mi unidad/Minecraft/La Juntada`.
- Op: `Fran`.
- **La PC (usuario `Fran`, no `frans`)**: instancia
  `%APPDATA%\PrismLauncher\instances\Nuevo 1.21.4` (79 jars) y server
  `C:\Users\Fran\MinecraftServer_1.21.4` (62 mods), **puerto 25566**, RCON 25576
  pero `enable-rcon=false`. Java del server: `C:\Program Files\Java\jdk-21`.
  `C:\Users\Fran\MinecraftServer` (puerto 25565, 1 mod, mundo sin tocar desde
  julio) **no** es este server: es el viejo, no confundirlos.
  Los 2 jars que la PC tenía de más y el pack no (`entity_model_features`,
  `entity_texture_features`) quedaron en
  `instances\Nuevo 1.21.4\mods_fuera_de_pack\` — no se borraron.

## Si hay que abrir un chat nuevo

Proyecto minecraft-amigos, fase 1. Leer `ESTADO_ACTUAL.md` y este archivo;
primer comando: `rcon.py list`. Sonnet, esfuerzo bajo: es operación, no diseño.
