# El camino: manejar el Sparking ZERO de la PC de casa desde la notebook

Medido el 2026-11-21 (juego versión 2013.012.003.008.007, ElAmigos con `steam_emu`, idioma `latam`). Cada paso de
abajo se hizo con captura y se vio el efecto.

## 0. Reglas que cuestan caro (leer antes de mandar una sola tecla)

1. **Nunca mandar teclas a ciegas.** El juego tarda ~25 s en cargar la partida después de «Iniciar»; las teclas
   mandadas durante la carga cayeron en el menú equivocado y arrancaron *Episodio de batalla → Goku → Nuevo
   juego* (escena de Raditz). Eso **tocó el guardado** (100811 → 100716 bytes). Una captura por paso, se mira, y
   recién ahí la siguiente.
2. **Antes de cerrar o cambiar algo: respaldo del guardado con md5.** Vive en
   `C:\Games\Dragon Ball Sparking ZERO\SaveGame\76561197960271872\` (`MainGameSaveData`, `SystemSaveData`). Es el
   «vivo»; no está en `%LOCALAPPDATA%`. Referencia buena del 2026-11-21: Main `0C0BB9E095C4DF702968FFBA49F8DB69`
   (100811 B), System `13EC118DB7FD136526F54D62723F6D56` (5387 B). Para devolverlo: cerrar el juego y copiar.
3. **Nada mientras juegan** Fran o su hermano. Una pantalla de menú quieta 10+ minutos = nadie juega.
4. **Puerta de la cascada (DA-145/146):** antes de actuar sobre el juego,
   `.\cascada.ps1 -Sistema sparking-zero -Investigacion "<md con ## Conclusion>" -Prediccion "..." -Respaldo "<copia>"`
   y lo mismo con `-Sistema juegos-pc`.
5. El audio **no sale en capturas**: lo oye Fran. La sesión mide lista, md5 y que el proceso viva. `scripts/oir.py`
   graba la salida de audio (loopback); **por SSH da silencio exacto** (2026-11-21): sin probar todavía en la sesión
   interactiva.
6. **Las tareas «ocultas» NO son ocultas** (2026-11-21): `captura-pc`, `ps-pc` y `paso-sz` abren una consola visible
   encima del juego. Con alguien jugando, **ninguna** tarea interactiva, ni siquiera una captura. Señal de que juegan:
   el juego gasta ~4 núcleos (22 s de CPU en 5 s medido en plena pelea).

## 1. Cómo se llega a la PC

- SSH `Fran@10.147.20.3` (ZeroTier) con la llave `~\.ssh\pc-cable`. Los comandos se pasan por `-EncodedCommand`
  (base64 UTF-16LE) para esquivar las comillas; la salida trae ruido `CLIXML` que se filtra.
- Carpeta de trabajo en la PC: `C:\Users\Fran\lp-todo\`.
- El juego es una app de **sesión interactiva**: por SSH no se ven ventanas. Para teclas y capturas se usan
  **tareas programadas interactivas** (definidas en `tareas/tareas-programadas.xml.txt`):

| Tarea | Qué hace |
|---|---|
| `probar-juego` | abre `SparkingZERO-Win64-Shipping.exe` en `Binaries\Win64` (sesión de Fran) |
| `paso-sz` | corre `pc-paso.ps1` en la sesión interactiva: lee `paso-args.txt`, manda las teclas y deja `cap.png` y `paso.log` |

## 2. Los scripts (en `scripts/`)

| Script | Dónde corre | Qué hace |
|---|---|---|
| `pc-teclas.ps1 -Teclas A,B,... -Nombre x` | notebook | escribe las teclas en la PC, dispara `paso-sz`, espera el `listo` y trae la captura a `...\lp-trabajo\_intermedios\capturas-pc\x-N.png` (copia aquí en `scripts/`; ajustar `$dst`) |
| `tecla-juego.ps1` | PC | trae el juego al frente y manda teclas por **scancode** (SendKeys no sirve en juegos), captura la pantalla DPI-aware |
| `pc-paso.ps1` | PC | el envoltorio que corre la tarea `paso-sz` |
| `leer-ejes.ps1 -Segundos N` | PC | lee los mandos por winmm `joyGetPosEx` (joy0..3) y anota en `ejes.log` cada cambio de L2 (eje U, botón 7), R2 (eje V, botón 8) y demás |
| `pc-instalar-v5.ps1 [-CerrarJuego]` | PC | instala el mod de música v5 con md5 y aparta la v4 (ver `sparking-musica`) |

Tokens de `-Teclas`: `ENTER ESC UP DOWN LEFT RIGHT SPACE BACK TAB Q E R F W A S D Z X C V G T Y` (una pulsación de
80 ms), `WAIT<ms>` (pausa), y **`HOLD_<TECLA>_<ms>`** (mantener la tecla; el juego pide mantener ○/BACK ~1500 ms
para volver atrás: `HOLD_BACK_1500`). Teclado ↔ mando: `E` = R1, `Q` = L1, `ENTER` = ✕, `BACK` = ○, `R` = □
(Reproducir), `C` = R3 (Aleatorio). Idea pendiente: un token `SHOT` para varias capturas en una corrida.

## 3. El mapa de menús (verificado con capturas)

| Desde | Tecla | Llega a | Espera |
|---|---|---|---|
| juego recién abierto (`probar-juego`) | — | portada «Iniciar partida / Salir del juego» | ~50 s |
| portada | `ENTER` | lista **Iniciar / Opciones / Salir** | 2 s |
| lista | `ENTER` | carga la partida y llega al **Menú principal** (cursor en *Episodio de batalla*) | **~25 s** |
| Menú principal | `E` (R1) | pantalla *Batalla y entrenamiento* (cursor en *Batalla*) | 2,5 s |
| ídem | `ENTER` | submenú *Batalla*: En línea / **Sin conexión** | 3 s |
| submenú | `DOWN`,`ENTER` | *Sin conexión*: J1 contra CPU / CPU contra CPU / **J1 contra J2** | 3 s |
| ídem | `DOWN`,`DOWN`,`ENTER` | pantalla de escenario (pestaña *Escenario*) | 6 s |
| escenario | `E` | pestaña **Música de fondo** | 2,5 s |
| cualquier pantalla | `HOLD_BACK_1500` | un nivel atrás | 2,5 s |

Ojo: en el Menú principal el cursor arranca en *Episodio de batalla*: **un `ENTER` ahí arranca la historia**.
Primero `E`. Una pantalla blanca es una transición: esperar y volver a capturar.

**La lista «Música de fondo» tiene ~46 filas** (no 25: la primera medición solo vio 25): las ~21 de
`sparking-musica` (temas famosos), *Invisible* y unas 24 con **ícono de tele** (DLC Anime Music Pack,
suenan anime aunque el nombre diga Linkin Park). La lista **da la vuelta**; el cursor arranca en la elegida.
Confirmar = `ENTER` (la fila elegida queda con el borde claro y su nombre aparece a la derecha).

## 3b. Reloaded-II y Ryo (agregado el 2026-11-21)

Para que suenen las filas de tele el juego se abre por **`reloaded-juego`** (`Reloaded-II.exe --launch <exe>`) y no por
`probar-juego`. Tareas nuevas en la PC (definidas en `tareas/tareas-programadas.xml.txt`): `reloaded-juego`, `reloaded-gui`,
`captura-pc` (solo captura la pantalla a `cap.png`, sirve sin el juego) y `ps-pc` (corre `ps-args.ps1` en la sesión
interactiva y deja `ps-out.txt`: sirve para leer el texto de ventanas con UI Automation). `scripts/ps-pc.ps1` y
`scripts/captura.ps1`. Detalle y cómo se deshace: `sparking-musica/docs/ryo-tele.md`.

## 4. La prueba de los mandos (L2)

1. Con el juego en el menú (nadie peleando), lanzar el lector en segundo plano en la PC:
   `Invoke-CimMethod Win32_Process Create 'powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Users\Fran\lp-todo\leer-ejes.ps1 -Segundos 1500'`.
2. Pedir a Fran: L2 a fondo 3 s en el mando 1, después en el 2, después R2 en cada uno.
3. Leer `ejes.log`: un mando sano sube **U(L2)** de 0 a ~65535 (winmm usa 0..65535) y el bit 0x40 de botones;
   si uno no sube, es del mando. Medido en reposo 2026-11-21: `joy0` y `joy2` presentes, el `joy2` tiene el
   stick derecho (eje R) con ~11 % de deriva.
