# Handoff — sparking-musica

**Escrito el:** 2026-11-21 19:45 · **Fase al cerrar:** 1 (instalar y probar), en curso

## Arrancá por acá

1. `.\cascada.ps1 sparking-musica -Necesidad investigar,ingenieria-inversa` y leer lo que pida.
2. Leer `ESTADO_ACTUAL.md` y `docs/v5-filas.md` (cómo se armó la v5) y, para manejar el juego,
   `proyectos/ingenieria/pc-casa-control/docs/camino.md` (una captura por paso, nunca teclas a ciegas).
3. Preguntarle a Fran: ¿oyó la v5 en una pelea J1 vs J2? ¿sigue con Ryo Framework para las filas de tele?

## Estado de la PC al cierre (2026-11-21 ~20:00)

- **El juego quedó ABIERTO, lanzado por Reloaded-II** (`reloaded-juego`), en la portada. Fran puede estar por probarlo.
- Música base = v5 (21 filas) + Ryo (23 filas de tele, `docs/ryo-tele.md`). Si se abre por `probar-juego`, la tele vuelve a anime.
- Guardado: el vivo cambió respecto del bueno `0C0BB9E0…` (se eligió música desde el menú); copias en
  `C:\Users\Fran\lp-todo\respaldo-save-v5b-1942` y `respaldo-save-v5-20261121-1918` (la buena). No se comparó después de la última sesión.

## La prueba que falta (la primera de la próxima sesión)

Fran oye en la PC: abrir por `reloaded-juego`, ir a Música de fondo (J1 contra J2, camino en `pc-casa-control/docs/camino.md`),
dejar la fila elegida por defecto «Given Up» (tele) y apretar □ (R): ¿suena **Given Up de Linkin Park** o el anime? Si es anime →
`docs/ryo-tele.md`, sección «Si no suena». Después: pelear J1 vs J2 y oír una fila mía y una de tele; y la prueba del L2.

## Lo que quedó a medias

- La PC quedó con el juego abierto en la pestaña «Música de fondo» (J1 contra J2), elegida *Burn It Down*.
- Ryo Framework sin instalar: ver hipótesis en ESTADO_ACTUAL. Plan: Reloaded-II en carpeta aparte, UNA fila de
  tele de prueba, con respaldo de `Binaries\Win64` y del guardado, y la puerta DA-145/146 declarada.
- L2: `leer-ejes.ps1` quedó corriendo en la PC hasta ~19:44 (log `C:\Users\Fran\lp-todo\ejes.log`); hay que
  relanzarlo cuando Fran esté frente a los mandos.

## Lo que NO hay que volver a intentar

Las cuatro vías sobre el DLC de ESTADO_ACTUAL (callejones). Mandar teclas sin mirar la pantalla.

## Datos que no se pueden aproximar

- PC: `Fran@10.147.20.3`, llave `~\.ssh\pc-cable`, `-EncodedCommand`. Juego en
  `C:\Games\Dragon Ball Sparking ZERO\SparkingZERO`. Abrir: tarea `probar-juego`.
- Guardado vivo: `C:\Games\Dragon Ball Sparking ZERO\SaveGame\76561197960271872\`. Bueno: Main
  `0C0BB9E095C4DF702968FFBA49F8DB69`, System `13EC118DB7FD136526F54D62723F6D56`. Respaldos en
  `C:\Users\Fran\lp-todo\respaldo-save-v5-20261121-1918` y `respaldo-save-1724`.
- v5: notebook `C:\Users\frans\herramientas\lp-trabajo\LISTO\v5-filas\` (md5-v5.txt); la v4 apartada en la PC
  `Mods-desactivados\paks\v4-conocidas`; la v4 también en `LISTO\v4-conocidas`.
- Filas → ondas (puerto 1 de `bgm_main.acb` + 84): M_0102→93, 0103→94, …, 0109→100, 0110→103 … 0122→115;
  M_0123→ bgm_main onda 82 (no tocada). Disco: quedan ~3,4 GB libres en la notebook (C:).

## Si hay que abrir un chat nuevo

Ver el mensaje del cierre de esta sesión. Motor: Sonnet, esfuerzo alto para Ryo; medio para el resto.
