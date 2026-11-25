# Proyecto juegos-casa — contrato de contexto

La biblioteca de juegos de la casa: todos los juegos de la notebook y de la PC en un índice clasificado
(igual en las dos), los emuladores (RetroBat como vitrina del retro) y la forma de jugar de a dos con
**cada jugador en su pantalla** cuando el juego lo permite. Nació adoptando la carpeta suelta del
BlueStacks (2026-11-24).

**Naturaleza:** `ingenieria` — ver [`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los repite.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` y `HANDOFF.md` (enteros, son cortos) |
| qué sigue, qué cierra la fase, las decisiones | `PDP.md` §4 y §6 |
| **qué existe afuera** (emuladores, red de a dos, servidores revividos, mods con red, packs, frontends) | [`docs/investigacion-2026-11-24.md`](docs/investigacion-2026-11-24.md) — y antes de tocar un emulador o un juego, se declara con ella: `.\cascada.ps1 -Sistema juegos-pc -Investigacion proyectos/ingenieria/juegos-casa/docs/investigacion-2026-11-24.md -Prediccion "..." -Respaldo "..."` |
| **contra qué se diseña y se verifica** | [`docs/10-requisitos.md`](docs/10-requisitos.md) (N, R, L0, L1) |
| la forma de jugar de a dos de un juego («la escalera») | investigación §3 |
| el BlueStacks de la PC (Android para el hermano) | [`EMULADOR-ANDROID.md`](EMULADOR-ANDROID.md) |
| el Minecraft | **no es de acá**: `proyectos/ingenieria/minecraft-amigos/` |
| manejar la PC desde la notebook (SSH, tareas con ventana, capturas) | `proyectos/ingenieria/pc-casa-control/CLAUDE.md` |
| las ISOs de PS2 para las consolas reales (OPL) | `proyectos/ingenieria/ps2-casa/` |

## Las reglas propias de este proyecto

1. **Las ROMs e ISOs las pone Fran.** La sesión instala emuladores, configura y ordena; no baja juegos
   comerciales (R-01). Lo que Fran ya bajó a mano (Descargas, la cuarentena) es para usarse: se mide y se
   incorpora.
2. **Un catálogo, dos índices.** El catálogo del repo dice qué juego es, su clasificación y su forma de a
   dos; **no** lleva rutas ni de dónde salió el archivo (el repo es público). Las rutas de cada máquina las
   mide el inventario y viven en un archivo ignorado por git.
3. **Nada mientras juegan, un juego abierto a la vez en la PC, y respaldo con MD5 antes de tocar un juego
   que tiene partidas de la familia** (las reglas de `pc-casa-control`).
4. **Lo pesado vive en la PC.** La notebook tiene poco disco: ahí va lo liviano (retro) y lo pesado se
   juega por streaming desde la PC.
5. **El PCSX2 2.6.3 de `C:\Program Files\PCSX2` de la PC no se toca** (BLACK). El de las dos máquinas para
   jugar es el 2.8.2 portátil de `C:\Games\PCSX2-2.8.2`.

## Dónde está cada cosa

```
PDP.md            el plan: fases, criterios de salida, riesgos, decisiones
CLAUDE.md         este archivo
ESTADO_ACTUAL.md  donde estamos hoy
HANDOFF.md        el mensaje para la proxima sesion (con el plan por sesiones)
docs/             investigacion, requisitos, spikes, bitacora
EMULADOR-ANDROID.md  el BlueStacks de la PC (2026-11-15)
```

## Dónde corre esto

En las dos máquinas: la notebook (`frans`, `C:\Games`, `Escritorio\Juegos`) y la PC (`Fran`, por SSH con
la llave `~\.ssh\pc-cable` a `10.147.20.3`). Sin esa llave y la ZeroTier no hay PC: una sesión que no las
tenga lo dice, no simula.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones: `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
