# Predicciones de (128) — N27: ¿la caída con el pnach por defecto es de la pausa?

Escritas **antes** de medir, el 2026-10-11, en la notebook (fork cerrado al escribirlas). Se agregan resultados al
lado; ninguna fila se reescribe.

**Lo que se sabe** (`docs/17` fila N27, `volcados/arma/f7b-pausa-20261011-200815/resumen.json` y `hilos.json`): una
sola vez, con el pnach por defecto (1059 palabras, sin la 2d): J2 juntó una 2.ª arma (clave `0x5446151ebc278000`, «la
SPAS» de acá en adelante) y quedó con ella en la mano; J con la pistola (`0x544614b7182c0000`) y una sola arma.
«Igualar» apretó el cambio de J2 **4 veces sin que ocurriera**; J1 pausó y volvió; J2 cambió a la pistola (2
pulsaciones) y el juego se cayó: EE en `0x80001578`, `Cause` = 0x20 (syscall), `v1` = 0x01010101. El EPC
`0x0027DBFC` es un `nop` entre comparaciones de float (desensamblado del ELF hoy): no explica nada solo.

**Lo leído en frío hoy** (`black-datos/decompilado/0x0014.c` `FUN_00143908`, `0x0015.c` `FUN_0015BBD8`/`FUN_0015BE08`):
- `FUN_00143908(dbuf, clave)` mira **sólo el búfer «otro»** (`*(dbuf+0x80)`): devuelve verdadero si está en estado 8
  con esa clave; si está en 8 con otra, lo pone en 0; en 0 lo vacía (`FUN_00143B00`) y pide la clave (estados 1–8).
- El cambio de arma (`FUN_0015BE08`, por el botón) sólo arranca con el estado del jugador `W+0x38` = 0 (`W` =
  `P+0x280`); en 2, espera que el «otro» tenga el arma, alterna (`FUN_00143D90`) y arma (`FUN_0015BE70` →
  `FUN_0013C868`). En reposo (0), cada cuadro precarga en el «otro» la alterna del jugador.
- Antes de la pausa la pistola está en el «otro» desde la juntada (la alterna de J2 **y** el arma en la mano de J).
  La pausa vacía ese «otro» (estado 9, `PseMenu.bin` encima); al volver, la precarga de J2 **recarga la pistola en el
  montón donde vive la pistola en la mano de J**. Sin la pausa, esa recarga no ocurre: el cambio sólo alterna.

**Banco:** `herramientas/n27_banco.py --rama pausa` y `--rama sin-pausa` (el control: misma precondición y misma
espera, sin la pausa). Pnach por defecto, City Streets. En cada paso: los dos búferes con estado (`+0x1C`) y clave
(`+0x28`), el estado del cambio de cada jugador (`W+0x38`, `+0x3C`, `+0x43`, `+0x45/+0x46`), el contador de J2; después
del cambio, el contador cada 0,5 s durante 6 s. En la caída: GPR, CP0, la RAM alrededor del EPC y `f7b_hilos.py`.
Orden: pausa, sin pausa, pausa, sin pausa (dos de cada una).

| # | Predicción | Resultado |
|---|---|---|
| N0 | precondición, en las cuatro: J2 con 2 armas y la 2.ª en la mano (clave ≠ la de J), J con la pistola sola, contador vivo; si no, `ROJO_PRECONDICION` y la corrida no cuenta | **(128) cumplida 4 de 4** (`volcados/arma/n27-*-20261011-*`): J2 {pistola, `…bc278000`} con la 2.ª en la mano, J {pistola}; `W+0x1C` = P en los dos (control de `W`) |
| N1 | rama pausa: la pausa abre y vuelve (el contador sube después de confirmar) y al volver el «otro» quedó vaciado (estado 0–8 recargando, no 9); antes del cambio la precarga de J2 lo deja en estado 8 con la clave de la pistola | **(128) cumplida 2 de 2:** en pausa el «otro» en estado 9 con clave 0; a 2,5 s de volver, estado 8 con la clave de la pistola y `+0x14` = 0 (el modelo lo llena recién la alternancia); contador vivo (752 → 832 → 908) |
| N2 | rama pausa: el cambio de J2 a la pistola ocurre (≤ 4 pulsaciones) y el juego **se cae** en ≤ 6 s (contador clavado, PC en `0x80001578`, `Cause` = 0x20) en **al menos 1 de 2** | **(128) cumplida 2 de 2** (3 de 3 con la de (127)): el cambio entra a la 1.ª pulsación y el contador queda clavado ya en la 1.ª muestra (≤ 2,5 s); PC 8 de 8 en `0x80001578`, `Cause` 0x20, `Status` 0x70030C00. Las dos caídas con los **mismos** registros: `EPC` `0x0026ECF0` (un `sw`: es el punto de vuelta de un hilo, no la instrucción que falló), `t3` = `0x00657CA0` (el cue del búfer recargado), `t7` = J2, `t9` = `0x00470000`, `a1` = 0x8000. Corregido de (127): `v1` es 0 en sus 32 bits bajos (el `0x01010101…` es la mitad alta del registro de 128 bits) |
| N3 | rama sin pausa (el control): el cambio ocurre y el juego **sigue vivo**: **0 caídas de 2** | **(128) cumplida 0 de 2:** el cambio entra (2 pulsaciones las dos veces) y el contador sube ~31/s durante los 6 s; el «otro» nunca se vacía (estado 8 con la pistola y su modelo en todos los pasos) |
| N4 | rama sin pausa: el cambio entra en ≤ 4 pulsaciones (en N27 «igualar» no lo logró en 4: si se repite, el control no se lee y el dato es qué deja `W+0x38` ≠ 0 antes de la pausa) | **(128) cumplida 2 de 2** (2 pulsaciones; `W+0x38` = 0 en todos los pasos). Lo de «igualar» en (127) queda sin explicar: no se repitió |

**Lectura (128):** **la pausa es necesaria para N27** — con la pausa 2 de 2 caídas, sin la pausa 0 de 2, con la misma
precondición y la misma espera (`confirmado` como condición: se sacó la pausa y la caída desapareció). Lo que la pausa
cambia, medido: vacía el «otro», que con estas armas es **el búfer de la pistola en la mano de J**, y la precarga de J2
lo recarga; el cambio de J2 alterna sobre esa recarga y el juego cae en el lazo de «syscall indefinida» del núcleo
(`0x80001564`: `printf` y `jr ra` sobre sí mismo). El mecanismo de la caída (qué escribe dónde) sigue `hipótesis`.
**N27 es de la familia F7b** y **R4 lo tapa** si la pausa deja de tocar el doble búfer: la secuencia queda igual a
la del control. Este banco es la prueba de R4 (con R4: `--rama pausa` tiene que dar 0 de 2).
**Riesgo que queda abierto:** cualquier otra carga que vacíe el búfer del arma en la mano de J (juntar, la precarga de
dos alternas) puede llevar a la misma caída; eso es R1–R3 (D'), y el banco de los cinco caminos lo tiene que cubrir.

**Qué decide cada resultado:**
- N2 sí y N3 sí → N27 es de la familia F7b (la pausa vacía el búfer del arma en la mano de J y la recarga cae
  encima): **R4 lo tapa** (la pausa deja de tocar el doble búfer) y se sigue con R4. Grado `probable` (sin intervenir
  en la causa: eso lo hace R4 mismo, con este banco como su prueba).
- N3 falla (cae sin la pausa) → N27 es **otra cosa**, de lo que juega Fran hoy: **frena la fabricación** y se
  persigue primero.
- N2 0 de 2 y N3 0 de 2 → no se reprodujo: la diferencia con la corrida de N27 son las 4 pulsaciones fallidas de
  «igualar» antes de la pausa; tercera rama que las repite antes de concluir nada.
