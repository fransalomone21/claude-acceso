# Proyecto dbz-niveles — contrato de contexto

Un Dragon Ball con **más personajes** (todas las formas de Goku y Vegeta,
Ultra Instinto, Ultra Ego) y **niveles de poder realistas**, para jugar de a
dos, y si se puede cada uno en su computadora. Dos caminos en estudio: el de
PS2 (los mods de Tenkaichi 3: *Niveles de Poder* y *Tenkaichi 4*) y el de PC
(Sparking ZERO con mods).

**Naturaleza:** `ingenieria` — ver
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los
repite: un dato que vive en dos lados diverge.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| saber qué sigue y qué la cierra | `PDP.md`, sección 4 |
| rutas de ISOs, IDs de PS2, partidas y herramientas ya encontradas | `../ps2-casa/RUTAS.md` (no buscar dos veces) |
| el Sparking ZERO de la notebook: qué mods tiene y sus scripts | `C:\Users\frans\Desktop\Juegos\Mods\Dragon Ball\DBZ-mods\LEEME.txt` y `DBZ-inventario-y-plan.md` (locales: listan la colección, no van al repo público) |
| problemas abiertos | `PROBLEMAS.md` |

## Las reglas propias de este proyecto

1. **Nada de la colección en el repo**: el repo es público. Nombres de repacks,
   links de descarga y listados de lo que hay en el disco van a los archivos
   locales de `DBZ-mods`, no acá.
2. **Los ISOs originales no se tocan**: se trabaja sobre una copia fechada.

## Dónde corre esto

En la notebook (los ISOs de PS2, el Sparking ZERO con mods, PCSX2 y 7-Zip) y en
la PC de casa (Sparking ZERO sin mods, *Niveles de Poder 8.1* portátil; por SSH
con la llave `~\.ssh\pc-cable`, usuario `Fran`, ZeroTier `10.147.20.3`, y el
comando mandado con `-EncodedCommand`: por SSH las comillas se pierden). Una
sesión en la nube no llega a ninguno de los dos: lo dice en vez de simular.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
