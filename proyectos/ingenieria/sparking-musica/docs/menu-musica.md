# El menú "Música de fondo" del Sparking ZERO de la PC (registro completo)

Medido el 2026-11-21 ~18:54 en la PC de casa, juego relanzado a las 18:49 (v4 de audio, DLC de fábrica).
Ruta: Menú principal → R1 a "Batalla y entrenamiento" → Batalla → Sin conexión → J1 contra J2 → R1 a la
pestaña "Música de fondo". Capturas (en la notebook, `C:\Users\frans\herramientas\lp-trabajo\_intermedios\capturas-pc\`):
`musica-9-1.png`, `musica-10-1.png`, `musica-11-1.png`, `musica-12-1.png`.

> **CORRECCIÓN 2026-11-21 19:30:** la lista NO tiene 25 filas sino ~46: detrás de *Invisible* siguen ~24 filas
> con ícono de tele (What I've Done, Guilty All the Same, Rebellion, Mark the Graves, Leave Out All The Rest, The
> Summoning, Bleed It Out, Shadow of the Day, Hands Held High, Final Masquerade, No More Sorrow, IGYEIH…). Todas
> son del DLC (audio de anime con nombre de LP). La tabla de abajo cubre solo las primeras; ver `v5-filas.md`.

## Las 25 filas (la lista da la vuelta: de la primera con ARRIBA se cae a la última)

Nombre = el que muestra el juego (pack de nombres ZeroSpark `LinkinParkNombres.json`, `SetBGMNames`). Id = la
fila del diccionario de ese pack con ese nombre. **El audio de cada fila NO se verificó** (el audio no sale en
capturas); lo que se sabe del audio es la v4 de ESTADO_ACTUAL.

| # | Nombre en pantalla | Id | Tele (DLC) |
|---|---|---|---|
| 1 | The Emptiness Machine | BGM_M0102 | no |
| 2 | Cut the Bridge | M0103 | no |
| 3 | Heavy Is the Crown | M0104 | no |
| 4 | Over Each Other | M0105 | no |
| 5 | Casualty | M0106 | no |
| 6 | Overflow | M0107 | no |
| 7 | Two Faced | M0108 | no |
| 8 | Stained | M0109 | no |
| 9 | The Emptiness Machine (repetida) | M0110 | no |
| 10 | Until It's Gone | M0111 | no |
| 11 | Wastelands | M0112 | no |
| 12 | The Requiem | M0113 | no |
| 13 | The Radiance | M0114 | no |
| 14 | Burning in the Skies | M0115 | no |
| 15 | Empty Spaces | M0116 | no |
| 16 | When They Come for Me | M0117 | no |
| 17 | Robot Boy | M0118 | no |
| 18 | Jornada Del Muerto | M0119 | no |
| 19 | Waiting for the End | M0120 | no |
| 20 | Blackout | M0121 | no |
| 21 | Wretches and Kings | M0122 | no |
| 22 | Invisible | M0123 | no |
| 23 | The Little Things Give You Away | (M20xx, DLC Anime Music Pack) | **sí** |
| 24 | Wake | (M20xx, DLC) | **sí** |
| 25 | Given Up | (M20xx, DLC) | **sí** |

La música que aparece elegida al entrar a la pestaña es **Given Up** (fila 25, de tele = DLC, suena anime).
Atajos de la pantalla: ✕ confirmar, ○ atrás (mantener), □ reproducir, R3 aleatorio, L1/R1 cambian de pestaña.

## Lo que esto dice (cruzado con `lista-conocidas.txt` y `LinkinParkNombres.json` de la v4)

- Las 22 filas visibles son las pistas M0102–M0123 del juego (menús/historia) con nombres de LP **de los
  discos nuevos** (From Zero, One More Light, Hunting Party…). Ninguna lleva un tema de **Hybrid Theory ni de
  Meteora** por nombre.
- Los temas famosos que pidió Fran (Numb, In the End, Crawling, Faint, What I've Done, Breaking the Habit,
  Somewhere I Belong, One Step Closer, Papercut, Bleed It Out, Given Up…) viven en **M1000–M1044** (la v4,
  45 cues de a 4 temas encadenados). **Esas 45 no aparecen en este menú**: no se pueden elegir a mano. Solo
  suenan si el juego las elige solo para una pelea (y eso no se midió: ver "Sin confirmar").
- Los 3 temas del final (Little Things, Wake, Given Up) son las pistas de anime del DLC con **nombre** de LP
  puesto por el pack de nombres: por eso el menú dice "Given Up" y suena anime.

## Sin confirmar

- Qué suena de verdad en cada fila y si alguna pelea arranca con los M1000–M1044 (hace falta oído de Fran o una
  captura de audio de la PC).
- Si "Aleatorio" (R3) incluye los M1000–M1044.
- Qué música trae por defecto cada escenario (el menú de escenarios no se recorrió).

## Para decidir (la elige Fran)

Los famosos no son elegibles porque la v4 les puso cues nuevos que el menú no lista. Dos vías para que
**predominen Meteora y Hybrid Theory en todos lados**: (A) cambiar el audio de las 22 filas visibles por los
famosos (la misma herramienta de v1–v4, sin tocar el DLC ni el guardado), o (B) sumar filas nuevas con Kuro's
Music Manager (fase 0 de investigación, sin terminar). Recomendación: A para tenerlo hoy, B después si hace
falta elegir cada uno por separado.
