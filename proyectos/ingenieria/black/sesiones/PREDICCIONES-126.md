# Predicciones de (126) — F7b: el doble búfer de recursos de arma, con dos jugadores

Escritas **antes** de medir, el 2026-10-09, en vivo (notebook, fork abierto con el pnach por defecto de 1106 palabras:
la pieza 2d prendida). Se agregan resultados al lado; ninguna fila se reescribe.

**El mecanismo** (`probable`, en frío, del decompilado de `black-datos/decompilado/0x0014.c` y una sonda de escritura
de esta sesión): `*(0x0040F540)` = `0x005BFC00` es un **doble búfer** de recursos del arma en la mano. `+0` el
índice del actual, `+0x08` y `+0x40` los dos búferes de 0x38 B (`+0x08` cue, `+0x0C` cue alterno, `+0x14` modelo,
`+0x18` agregados), `+0x7C` = el actual, `+0x80` = el otro (`FUN_00144078` los alterna). Un cambio de arma pide cargar
el arma nueva (`FUN_00143C80`, «chars/guns/…») en **el otro**; al llegar, `FUN_00143FD8` **libera** lo que ese búfer
tenía (`FUN_00108668`), y `FUN_00143D90` alterna y arma (`FUN_001AC960`). El escritor de `+0x7C` medido con vigilante:
`0x001440A0`, `a0` = `0x005BFC00`.

**Lo que predice con dos jugadores (F7b):** después de un cambio de X, el actual es el de X y el otro es el de Y. Si X
cambia **otra vez**, la carga va al búfer de Y y libera el arma que Y tiene en la mano: el soporte de Y (con la pieza
2d, propio) queda apuntando a un modelo liberado o reemplazado. El banco de (125) pasó porque el segundo cambio de J2
volvía a la pistola, **la misma arma de J**: se recargó lo mismo en el mismo lugar.

**Banco:** `herramientas/f7b_buffer.py` (fork abierto; J junta una 2.ª arma, distinta de las de J2).

| # | Predicción | Resultado |
|---|---|---|
| B0 | precondición: J con {pistola, X}, J2 con {pistola, SPAS}, X ≠ SPAS; los dos en la pistola | |
| B1 | `j2_spas` (J2 → SPAS): el modelo de J2 = `+0x14` del actual; el de J = `+0x14` del otro. Imagen: J pistola, J2 SPAS | |
| B2 | `j_x` (J → X): X entra en el búfer de J (el otro); el de J2 sigue residente. Imagen: J con X, J2 con la SPAS | |
| B3 | `j_pistola` (J → pistola, el 2.º cambio seguido de J): la carga va al búfer **de J2**: el modelo de J2 deja de ser el `+0x14` de algún búfer (o su memoria cambia de contenido). Imagen: la mitad de J2 deja de dibujar la SPAS bien (pistola, basura o vacío) mientras su HUD sigue en la SPAS | |
| B4 | el contador de cuadros de J2 sube entre todos los pasos (el juego vivo) | |

**(126) B0 NO SE CONSTRUYÓ** (`volcados/arma/f7b-20261009-220031/`): J no junta (3 de 3; el recogible 29 pasó de
`ban` 0x4 a 0x0 sin sumarle arma a J, y el búfer 1 quedó con modelo 0), lo mismo que (123). Nada de B1–B4 se lee.

**Precondición alternativa, escrita antes de correrla (`f7b_buffer.py --por-j2`):** J2 cambia su pistola por una
tercera arma X del piso (S1 sobre otro recogible, con J2 en la pistola) → J2 {X, SPAS}, J {pistola}.

| # | Predicción | Resultado |
|---|---|---|
| C0 | J2 queda con {X, SPAS}, X ≠ pistola; J con la pistola, residente | **(126) a medias, y por el motivo que C1 predecía:** J2 quedó con {X = `0x5446150037A78000` (un rifle con mira), SPAS}, pero la juntada **misma** ya desalojó la pistola de J: búferes `[0x0, 0x01AEA800]`, el modelo de J (`0x01A35E00`) en ninguno (`volcados/arma/f7b-porj2-20261009-220157/`) |
| C1 | `j2_a` (el 1.er cambio de J2 después de juntar, que ya fue una carga de J2): la carga va al búfer de la **pistola de J**: J deja de estar residente. Imagen: la mitad de J deja de dibujar su pistola bien | **(126) adelantada un paso (pasó en la juntada):** `base.png`, la mitad de J (HUD 015\030, la pistola) muestra **las manos sin arma**; la de J2 el rifle bien. **F7b `probable`** (RAM + imagen, una corrida, sin control simétrico: falta la misma juntada sin la 2d y con J2 en otra arma). Antes de la juntada, el intento fallido de J sobre el recogible 29 ya había dejado el búfer 1 con modelo 0 |
| C2 | `j2_b` (otro cambio de J2): igual que C1 (cada cambio de J2 cae en el búfer que no es el último cargado) | |

## La pausa (escrita antes de correr `f7b_pausa.py`)

**En frío (`probable`):** el menú de pausa (`FUN_0020AEA0`) pide el búfer «otro» con clave 0 (`FUN_001438C8` →
`FUN_00143908(inst, 0)`: `FUN_00143B00` lo vacía — cues parados, `+0x14` = 0 — y queda en estado 9) y carga ahí
`Export/FrontEnd/PseMenu.bin` (`FUN_00143F90`); al salir, `FUN_001438E8` lo deja en 0. En un jugador el «otro» es el
arma anterior; con dos, puede ser **el arma en la mano del compañero**. Banco: lanzar, City Streets, J2 junta la SPAS.

| # | Predicción | Resultado |
|---|---|---|
| P0 | control: los dos en la pistola (un búfer), J pausa y despausa: los dos siguen residentes y con la pistola en su mitad | |
| P1 | J2 a la SPAS (el actual pasa a ser el de J2, el otro el de J), J pausa: el búfer de J queda vacío (`+0x14` = 0) | |
| P2 | al despausar: J **no** residente y la mitad de J sin arma (HUD en la pistola); J2 con la SPAS bien | |
| P3 | el juego vivo entre todos los pasos (contador de J2) | |

**Refuta:** si en P2 J sigue residente, la pausa no usa el búfer del arma (o lo restaura) y el diseño no la necesita.

**(126) Primera corrida con la pausa bien cerrada (`volcados/arma/f7b-pausa-20261009-221210/`, pieza 2d prendida):**
P0 **cumplida** (control: la pausa vació el búfer «otro», el de la SPAS vieja; los dos siguieron residentes y el
juego volvió). P1 **cumplida** (con J2 en la SPAS, la pausa vació el búfer de la pistola de J: J no residente). P2
**no se pudo leer, y por algo peor:** el menú de pausa quedó **a medio cargar** (los puntitos de carga, sin barra de
selección; `prueba-en-pausa.png`) — el búfer reservado en estado 9 con el recurso de la pistola todavía adentro, y el
cargador ocupado (`*(0x0040F4C4)+0x8B8` = 1) sin avanzar: **la partida queda trabada en pausa**. Intervención en el
soporte de J (apuntarlo a la SPAS residente): **no destraba** — no es la referencia de la 2d lo que frena.

| # | Predicción del control (escrita antes de correrlo) | Resultado |
|---|---|---|
| P4 | **sin la 2d** (`f7b_pausa.py --sin-soporte2`), la misma secuencia: si la traba es de la 2d, la pausa carga y el juego vuelve; si es del doble búfer con dos jugadores, se traba igual | **(126) la pausa ANDA sin la 2d**: carga, CONTINUE, el juego vuelve (contador 1120 → 1200); J sin la 2d comparte el soporte de J2 (F7, como siempre) y nadie dibuja la pistola del búfer vaciado (`volcados/arma/f7b-pausa-20261010-003512/`) |
| P5 | con la 2d y `--espera 6` (la pausa lejos del cambio de J2): si se traba igual, no es el tiempo entre el cambio y la pausa | **(126) se TRABA igual** (contador clavado en 1262, menú a medio cargar; `f7b-pausa-20261010-003742/`). **Confirmado** (ON → OFF → ON: 2 de 2 con la 2d, 0 de 1 sin ella; el tiempo no influye): **con la 2d, pausar después de que J2 cambió a otra arma traba la partida.** Decisión: la 2d vuelve a **apagada por defecto** (pnach 1059) |

**Lo que todavía no se sabe de la traba:** qué espera el cargador. No es el puntero de modelo del soporte de J
(intervenido, no destraba). Candidatos (`hipótesis`): lo que J dibuja sigue tocando el recurso de la pistola por otro
lado (los agregados `soporte+0x38`, los registros reescritos por el dibujo, los accesorios), y el cargador no suelta
un recurso en uso. Sin la 2d no aparece porque nadie dibuja el arma del búfer «otro».

**Refuta:** si en B3 el modelo de J2 sigue residente y la mitad de J2 dibuja la SPAS bien, el doble búfer no libera lo
del otro (o el juego tiene un tercer búfer) y la 2d alcanza. **Control dentro de la corrida:** B2 (un solo cambio de J
después del de J2) no tiene que romper nada; si B2 ya rompe, el modelo de alternancia está mal.
