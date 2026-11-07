# Predicciones de (136) — el compañero como fantasma (F-RED-3)

Escritas el 2026-11-06 **antes** de medir. Fase PLAT-PreA (spike). Traza: L1-06, L1-07, L1-18, L0-03 (`docs/20`) y
F-RED-3 de `docs/24-fallos-coop.md`. Hipótesis H1-H3 descritas ahí.

## Paso 0 — lo que ya existe (sin jugar)

El `black.log` (y `black.prev.log`) de la PC, si es el de la noche del 31/10 (la PC fue la copia que se une). Se trae
con `lanzadores\ACCESO-PC.ps1 -Traer C:\Games\BLACK\coop\logs -A volcados\plataforma\pc-<fecha>`. Lo que se busca ahí:
`npc: the host is not heard` / `is heard` (H2), `puppet ... made by its spawner` con hora contra los avances de unidad
del anfitrión (885 s, 3421 s) (H1), y `npc ... let go`. Si ya se pisó, se dice y se pasa al ensayo.

## El ensayo (dos copias en la notebook, 127.0.0.1, exe con 01+02+03)

`lanzadores\COMPILAR-COOP.ps1`, después `lanzadores\PROBAR-PARCHE-COOP.ps1` (con el 03). City Streets desde el menú.

| # | Escena | Predicción |
|---|---|---|
| P1 | El anfitrión se adelanta una unidad y pelea; el compañero queda atrás, quieto | En el registro del compañero salen líneas `npc: ... of the host's waits here: its spawner's unit is not loaded` (≥ 1) y en su ventana **no** están los enemigos que el anfitrión tiene delante (H1) |
| P2 | El compañero llega a esa zona | Esos enemigos (los vivos en el anfitrión) aparecen en la ventana del compañero en ≤ 2 s de cargar la unidad; las líneas `made by its spawner` siguen a las de P1 |
| P3 | El anfitrión abre su menú de pausa 10 s con un enemigo disparándole al compañero | Sale `npc: the host's states are stale: the puppets stand` y el enemigo deja de disparar en la ventana del compañero; al cerrar, `drive the puppets again` (H2) |
| P4 | El compañero entra primero a una zona nueva y espera 30 s; el anfitrión no viene | Si la oleada de esa zona cuelga de un disparador de entrada o de tipo 12 (H3): ningún `npc+` de esa zona en el anfitrión hasta que él llega |
| P5 | Control | La misma escena con los dos juntos: cero líneas `waits here`, ningún `stale` |

**Lo que refuta:** P1 sin líneas `waits here` con el anfitrión claramente adelante → H1 no es el mecanismo (el spawner
sí estaba cargado). P3 sin `stale` → la pausa del anfitrión no congela a los títeres.

## Resultados

- **2026-11-06 22:39, compilado (no instalado):** `C:\Games\BLACK\src\black-recomp\out\build\release\BLACK.exe`, sha256
  `76EA8E13A5BC…`, con 01+02+03. Las cadenas del 02 (`fired at the partner, unit %u's`) y del 03 (`waits here: its
  spawner`, `are stale: the puppets stand`) están en el binario (grep, 1 cada una): el 03 compila. La primera corrida
  de `COMPILAR-COOP.ps1` sin consola propia falló en `build.bat` (cmd no heredaba la carpeta): arreglado con ruta
  absoluta. P1-P5: sin medir (necesitan a Fran con dos mandos).
