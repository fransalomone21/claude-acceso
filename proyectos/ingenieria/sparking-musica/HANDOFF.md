# Handoff — sparking-musica

**Escrito el:** 2026-11-21 ~20:45 · **Fase al cerrar:** 1 (instalar y probar), en curso

## Arrancá por acá

1. `.\cascada.ps1 sparking-musica -Necesidad investigar,ingenieria-inversa` y leer lo que pida. Declarar el sistema
   ajeno **con la herramienta PowerShell, no por Bash** (DA-154): `.\cascada.ps1 -Sistema sparking-zero -Investigacion
   proyectos/ingenieria/sparking-musica/docs/investigacion-voces-y-ultimate.md -Prediccion "..." -Respaldo "..."`.
2. Leer `ESTADO_ACTUAL.md` (bloque «Lo nuevo»), `PROBLEMAS.md` (P1–P3) y `docs/investigacion-voces-y-ultimate.md`.
3. Preguntarle a Fran lo que sólo él sabe: ¿pasó las voces a japonés y Whis habla latino? ¿qué música Sparking tiene
   Vegeta en Personalización, y con un tema LP elegido se sigue cortando?

## Estado de la PC al cierre

- **Fran y su hermano estaban jugando** (20:16, Vegeta contra Whis, pantalla dividida, juego abierto por
  `reloaded-juego` a las 19:54). Antes de tocar nada: mirar si siguen (CPU del juego ~4 núcleos = pelea).
- **Una captura de la sesión abrió una consola encima del juego** (tarea `captura-pc`). Las tres tareas «ocultas»
  siguen sin arreglar: el cambio a `conhost --headless` quedó frenado por el clasificador mientras jugaban (P1 de
  `pc-casa-control`).
- Instalado en la PC por esta sesión: `pip install soundcard numpy` (Python 3.12 de Fran), `C:\Users\Fran\lp-todo\oir.py`,
  `oir_todos.py`, `utocs\` y `utocs.zip` (copias de los índices de `~mods`, borrables). Nada del juego cambió.

## Lo que quedó a medias

- P2 (la música en el ataque final) sin diagnosticar: no se pudo oír. El orden de las pruebas está en la Conclusion de
  `docs/investigacion-voces-y-ultimate.md`.
- `oir.py` por SSH da silencio exacto: hay que correrlo en la sesión interactiva por una tarea sin ventana, con el
  juego cerrado y un tono de control, antes de creerle a cualquier silencio.

## Lo que NO hay que volver a intentar

Las cuatro vías sobre el DLC (callejones de ESTADO_ACTUAL). Teclas sin mirar. **Cualquier tarea interactiva (aunque
sea una captura) mientras juegan.** Buscar los bancos de voz en `pakchunk0-Windows.utoc` (el índice viene cifrado y da
cero): la lista está en `lp-trabajo\_intermedios\voces.json`.

## Datos que no se pueden aproximar

- PC: `Fran@10.147.20.3`, llave `~\.ssh\pc-cable`, `-EncodedCommand`. Juego en
  `C:\Games\Dragon Ball Sparking ZERO\SparkingZERO`. Abrir con Ryo: tarea `reloaded-juego`.
- Guardado vivo: `C:\Games\Dragon Ball Sparking ZERO\SaveGame\76561197960271872\`; respaldos en
  `C:\Users\Fran\lp-todo\respaldo-save-v5-20261121-1918` (bueno) y `respaldo-save-v5b-1942`.
- Voces: `docs/voces-cobertura.txt`; Whis = `BTLCV_0790_00` (latino solo JP, `WhisMODLATINO_P`); familia Vegeta Super
  `0020_60/61/63`, `0022_62` (`VegetaSuper_P`, solo JP); el Ultra Ego es `Mods\VegetaUltraEgo` (sin voz propia; reusa
  ultimates de `0020_30`, `0154_00`, `0680_02`, `0941_00`).
- Música: Sparking por personaje `M_0200…M_0209` (LP desde v1–v4) y `M_10xx_SPK`; dramáticas `M_1100` (onda 17 del
  puerto 1, no tocada por la v5) y `M_2000…M_2022` (Ryo). Tabla: `python lp-trabajo\scripts\acb-cues.py
  _intermedios\fabrica\bgm_main.acb`.

## Si hay que abrir un chat nuevo

Motor: Opus, esfuerzo alto para el diagnóstico de la música (primera hipótesis en terreno nuevo); Sonnet para lo demás.
