# v5: las 21 filas visibles del menú con un tema famoso cada una

Hecha el 2026-11-21 sobre el flujo v1–v4 (`C:\Users\frans\herramientas\lp-trabajo`). Es la vía A de `menu-musica.md`.

## Qué cambia

Las filas M_0102…M_0122 del menú «Música de fondo» (ondas 93–100 y 103–115 de `bgm_main_Cnk_00.awb`, que eran
interludios y temas de otros discos) pasan a **un tema famoso** cada una; los nombres se ponen con el JSON de
ZeroSpark. M_0123 (*Invisible*) y las pistas de pelea M_1000…M_1044 (la v4, medleys de 4) no se tocan.

| Fila | Tema | Fila | Tema |
|---|---|---|---|
| M0102 | In the End | M0113 | Bleed It Out |
| M0103 | Numb | M0114 | Hit the Floor |
| M0104 | Crawling | M0115 | Runaway |
| M0105 | Faint | M0116 | Easier to Run |
| M0106 | One Step Closer | M0117 | From the Inside |
| M0107 | Papercut | M0118 | With You |
| M0108 | Somewhere I Belong | M0119 | Don't Stay |
| M0109 | Breaking the Habit | M0120 | Figure.09 |
| M0110 | What I've Done | M0121 | Castle of Glass |
| M0111 | Points of Authority | M0122 | Burn It Down |
| M0112 | Lying from You | | |

17 de 21 son de Hybrid Theory y Meteora.

## Cómo se hizo (para repetirlo)

1. `scripts/armar-filas.py` (copia aquí; el original corre desde `lp-trabajo\scripts`): convierte cada mp3 a WAV
   48 kHz estéreo en `_intermedios\todo\bgm_main_Cnk_00\Cue_N.wav`, mueve la `N.hca` y el WAV viejos a
   `_intermedios\respaldo-v4-filas`, y actualiza los nombres en `LISTO\ZeroSpark\LinkinParkNombres.json`.
2. `SparkingZeroAudioTool.exe "<...>\todo\bgm_main_Cnk_00"` con `nombre-v3.txt` por stdin (si la salida ya
   existe pregunta «Delete? (y/n)»: apartar antes `juego\...\~mods\zzLinkinParkTodo_P.*`).
3. Pak final con los DOS awb: copiar `todo\bgm_main_Cnk_00.awb` a
   `pak-todo\zzLinkinParkTodo_P\SparkingZERO\Content\CriWareData\` y
   `UnrealPak.exe <ruta>\zzLinkinParkTodo_P.pak -create=<ruta>\pak-todo\filelist.txt`; el `.ucas/.utoc` salen de
   la herramienta (tabla con los offsets nuevos).
4. `scripts\verificar-banco.py` sobre los dos bancos (ver `ESTADO_ACTUAL` por el resultado esperado).
5. `LISTO\v5-filas\` (pak, ucas, utoc, JSON, `md5-v5.txt`) → PC con `pc-instalar-v5.ps1` (cierra el juego solo con
   `-CerrarJuego`, aparta la v4, copia, mide md5).

## Lo que enseñó

- La lista tiene ~46 filas, no 25: las de tele van detrás de *Invisible*. La medición del 2026-11-21 18:54 solo
  vio las primeras (ver corrección en `menu-musica.md`).
- Esas filas de tele llevan **nombre** de LP pero **audio de anime**: cambiarlas requiere otra vía (Ryo).
