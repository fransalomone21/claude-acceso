# Proyecto pc-casa-control — contrato de contexto

Cómo manejar desde la notebook la PC de casa (PCFRAN) y sus juegos —SSH, teclas por scancode, capturas, tareas
interactivas, camino por los menús del Sparking ZERO, prueba de los mandos— para que ninguna sesión lo
reinvente ni toque el guardado a ciegas.

**Naturaleza:** `ingenieria` — ver [`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

**El plan y las fases están en [`PDP.md`](PDP.md)** (pendiente de llenar: ver HANDOFF).

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` y `HANDOFF.md` |
| manejar el juego, repetir la captura de «Música de fondo», probar los mandos | `docs/camino.md` (entero) |
| los scripts | `scripts/` (copias de los de la PC y de la notebook) |
| **correr cualquier PowerShell en la PC desde la notebook** | `scripts/en-pc.ps1 -Comando '...'` o `-Archivo x.ps1 -Argumentos '...'`: siempre codificado (el SSH de la PC abre PowerShell; un comando sin codificar o en sintaxis de cmd falla en silencio). Sale 0 o 1 |
| las tareas programadas de la PC | `tareas/tareas-programadas.xml.txt` |
| la música instalada y su porqué | `proyectos/ingenieria/sparking-musica/` |

## Las reglas propias de este proyecto

1. **Una captura por paso y se mira antes de la tecla siguiente.** Mandar teclas a ciegas durante una carga
   arrancó una partida nueva y tocó el guardado (2026-11-21).
2. **Respaldo del guardado con md5 antes de cerrar el juego o cambiar algo**, y comparar después.
3. **Nada mientras juegan Fran o su hermano.**

## Dónde corre esto

Los scripts de `scripts/` corren en dos lados: `pc-teclas.ps1` en la notebook y el resto en la PC
(`C:\Users\Fran\lp-todo\`). Sin la llave `~\.ssh\pc-cable` de la notebook y la ZeroTier de la PC no hay
acceso: una sesión que no los tenga debe decirlo en vez de simular resultados.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
