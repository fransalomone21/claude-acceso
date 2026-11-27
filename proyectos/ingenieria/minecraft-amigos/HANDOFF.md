# Handoff — minecraft-amigos

**Escrito el:** 2026-11-26 · **Fase al cerrar:** 2 (el pack nuevo y la tienda), abierta: tienda construida
y probada con sus 86 mods; falta la validación con Fran y Kevin.

## Lo último (2026-11-27, madrugada): el mundo 1.21.4 con Agus, en la notebook

Fran y Agus juegan en `C:\Users\frans\MinecraftServer\agus-1.21.4` (puerto 25566) con la instancia «Nuevo 1.21.4»
(100 jars) — ver `ESTADO_ACTUAL.md`, bloque del 27. Pendiente, en este orden:
1. **La tienda para las dos versiones** (pedido de Fran): hoy `tienda/` es sólo 1.21.1 NeoForge; el pack 1.21.4
   vive en `pack/agregar.txt` + `armar_pack.py`. Falta decidir cómo la página ofrece 1.21.4 Fabric (otro catálogo,
   otro cargador, server de prueba Fabric) sin romper lo de 1.21.1.
2. Los requisitos (`docs/10-requisitos.md`) dicen 1.21.1 (L1-01): sumar la 1.21.4 es un cambio de requisito y va
   con el sí de Fran.
3. RCON apagado en el server 25566 (`enable-rcon=false`): para apagarlo bien, `stop` en su ventana minimizada.

## Lo de antes (2026-11-26): los 52 nuevos arrancan — HECHO

Los pasos 1-3 del bloque de abajo están hechos y medidos (`ESTADO_ACTUAL.md`, bloque «2026-11-26»). Lo que sigue
es de Fran: el punto 2 de «Arrancá por acá (mediodía)», abajo (cuentas sin conexión en Prism, elegir una
combinación en la tienda, jugar con Kevin). La deuda del punto 4 (formato de `curado.json`) sigue abierta.
Un mod nuevo que no arranca por «requires X»: mirar si X está en `prueba/mods`; si falta, va a `deps_faltan`
de `curado.json`.

## Lo de antes (2026-11-25, 18:20, desde la sesión de juegos-casa; Fran: «termina ahora y deja para despues»)

La tienda creció a 86 cartas con subsectores, conejos y fotos desplegables (ver `ESTADO_ACTUAL.md`, bloque «a la
tarde»); la página nueva ya está sirviendo (tienda reiniciada minimizada). **Primero, al volver:**

1. Arreglar las dos dependencias que frenan el arranque: sumar `{"slug": "irons-lib"}` a `extras` de
   `tienda/datos/curado.json` (o la versión que pida `irons_spellbooks`: ≥ 1.21.1-2, < 1.21.1-3) y llevar Patchouli
   a ≥ 1.21.1-93 (está fijada por Better MC 5: `python catalogar.py --ultimas` la sube, o sacar «hamsters»).
2. Repetir la prueba de los 52 nuevos juntos SIN publicar, desde `tienda/`:
   `python probar_sin_publicar.py nuevas datos\cartas-antes-2026-11-25.json` (también `combo:<id>` o
   `cartas:a,b`). Resuelve, baja al cache y corre `armar.probar` sin `publicar`, y mide que `publicado/lista.json`
   no cambie. Si no arranca, partir en mitades hasta dar con el mod.
3. `python tienda/verificar_cartas.py --sabotaje` (verde y rojo) y `python tienda/biblioteca.py` (L1-11: los jars
   nuevos a la PC, por familia).
4. Deuda: `curado.json` se reescribió con `json.dump` y perdió su formato compacto (una carta por bloque): se
   lee igual, pero el diff es grande. Si molesta al editar a mano, volver al formato con un volcador propio.

### Si hay que abrir un chat nuevo (2026-11-25, 18:20)

```
Proyecto minecraft-amigos (claude-acceso), fase 2 (Fase C/D: la tienda de mods). Tarea: que los 52 mods nuevos
de la tienda arranquen.
0. En la PC el perfil se carga solo; en otra maquina: bash .claude/nube/traer-perfil.sh y leer lo que lista.
1. .\cascada.ps1 minecraft-amigos -Necesidad ninguna  y leer lo que pida; despues HANDOFF.md (bloque "Lo ultimo")
   y tienda/LEEME.md. No leer docs/fase-2-tienda.md entero.
2. La fase 2 la cierra Fran jugando con Kevin (PDP §4); esta tarea es una pieza: los 52 nuevos arrancan juntos.
3. Sonnet, esfuerzo medio, sin agentes: es arreglar dependencias y probar.
4. Maquina: tienda.py corriendo minimizada en :8765 (notebook) con la pagina nueva; cache y server de prueba en
   C:\Users\frans\MinecraftServer\tienda\; publicado: Aventura minecraftera (no se toco).
5. Resuelto: 86 cartas, 25 subsectores, fotos (verificar_cartas.py VERDE, sabotaje ROJO), catalogo 353 proyectos.
6. Primer comando (desde tienda/): python probar_sin_publicar.py nuevas datos\cartas-antes-2026-11-25.json
7. Efecto esperado hoy: "NO ARRANCO: ... irons_lib ... patchouli ..."; despues del arreglo: "ARRANCO; publicado igual".
```

## Arrancá por acá (2026-11-25, mediodía)

1. Lo hecho y medido está en `ESTADO_ACTUAL.md` (bloques «La tienda» y «Lo nuevo del 2026-11-25 al mediodía»);
   el índice de archivos, `tienda/LEEME.md`. L1-11, L1-12 y L1-13 quedaron verificados hoy.
2. Lo que falta es de Fran (la fase la cierra él): (a) en Prism de cada máquina, Cuentas > Agregar sin
   conexión (note: la suya; PC: «Kheven»); (b) «Tienda de mods» en la note, elegir y confirmar; (c) «Server de
   la tienda» (prende server y pack); (d) Prism > «Tienda 1.21.1» > Jugar en la note y en la PC: después,
   `tienda/verificar-instancia.ps1` en cada una tiene que salir 0; (e) Kevin con `paquete-kevin.zip`.
   Con el juego abierto, la sesión mide L1-14 (spark, `/spark tps`) y L1-15 (menú con 8 GB).
3. Ideas pensadas y no hechas (shaders por combinación, packs de cielo, «Espacio B» con Stellaris): en
   `docs/mc-tienda-hallazgos.md` (ya en el repo y nombrado en el contrato).

## Lo de antes (2026-11-24, fase 2 sin construir)

Son las sesiones 4 y 5 del plan de `proyectos/ingenieria/juegos-casa/HANDOFF.md` (Sonnet, esfuerzo
medio, sin agentes). Leer `docs/10-requisitos.md` y `docs/fase-2-tienda.md` enteros. Antes: que la
notebook tenga lugar (la sesión 2 de juegos-casa pasa las ISOs de PS2 a la PC).

- **Sesión 4 — la tienda**: packwiz (no tiene releases: se compila con Go, `winget` está autorizado) y
  `packwiz-installer-bootstrap.jar` (releases de GitHub); el catálogo de mods de 1.21.1 NeoForge desde la
  API de Modrinth, filtrando por versión y cargador (`?loaders=["neoforge"]&game_versions=["1.21.1"]`),
  con descripción en criollo y familia; las combinaciones de `fase-2-tienda.md` §4; la página local; el
  server de prueba y los dos sabotajes (Tough As Nails bloqueado; un mod de otro cargador que no publica).
- **Sesión 5 — el server y las instancias**: server NeoForge 1.21.1 en la notebook sincronizado por
  packwiz (lado server); instancia en la notebook y en la PC con el comando previo de packwiz-installer;
  el paquete de Kevin preparado (su notebook no está a mano).

Lo que no se toca: el server 1.21.4 (`C:\Users\frans\MinecraftServer\juntada`) y sus mundos.

## Lo de la fase 1 (historia: la juntada 1.21.4)

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
