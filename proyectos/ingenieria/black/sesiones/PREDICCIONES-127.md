# Predicciones de (127) — qué está haciendo el EE en la traba de la pausa

Escritas **antes** de medir, el 2026-10-11, en la notebook (fork cerrado al escribirlas). Se agregan resultados al
lado; ninguna fila se reescribe.

**Lo que se sabe en frío** (`docs/16` sección (127) (a)): el cargador no cuenta referencias ni espera a nadie; la
ranura 6 vacía el montón 14 y le lee `PseMenu.bin` encima; `+0x8B8` = 1 es la ranura 6 a medio hacer. Con la 2d, J
dibuja la pistola de ese montón.

**Hipótesis a probar (H-dibujo, `probable`):** el hilo **principal** queda en un lazo sin fin dibujando el arma de J
desde memoria pisada, no vuelve a dormir en el vblank (`FUN_00271480`), y el hilo del cargador (entrada `0x00108050`,
prioridad menor) no vuelve a correr.
**Alternativa (H-cargador):** el hilo principal sigue vivo (duerme y despierta en cada vblank, el menú espera) y el
que está trabado es el hilo del cargador, adentro de la lectura o del callback.

**Banco:** `herramientas/f7b_pausa.py --con-soporte2` (lo deja en la traba, como en (126)) y después
`herramientas/f7b_hilos.py` (sólo lectura: 8 muestras del PC, la lista de hilos, la pila del principal con el EE en
pausa del depurador, la bandera de la ranura 6 y la región `0x01F28800`–`0x01FF0000`).
**Control:** lo mismo con `f7b_pausa.py --sin-soporte2` (la pausa anda y el juego vuelve): `f7b_hilos.py` en juego.

| # | Predicción | Resultado |
|---|---|---|
| T0 | precondición: con la 2d, la traba se reproduce (menú a medio cargar, `+0x8B8` = 1) | **(127) cumplida** (`volcados/arma/f7b-pausa-20261011-200448/`): contador de J2 clavado en 1289, las dos fotos de la pausa con el mismo md5, `+0x8B8` = 1. Tercera vez de tres con la 2d |
| T1 | H-dibujo: las 8 muestras del PC en la traba caen en código del juego (no en el núcleo `0x8000xxxx` ni en la espera del vblank), en un rango chico (< 0x400 B, una función o dos) | **(127) cumplida:** 8 de 8 en código del juego, en **dos** funciones: `0x002B33D4`–`0x002B33E8` (el lazo de `FUN_002B32D8`) y `0x001C4F08` (el callback que ese lazo llama). Ninguna en el núcleo ni en `FUN_00271480`. (El «rango» de la herramienta da 0xEE4E0 porque mide de una función a la otra) |
| T2 | H-dibujo: en la lista de hilos, el principal está corriendo o listo (no en espera) y el del cargador está **listo, sin correr** (no en espera de un semáforo) | **(127) cumplida:** el principal (id 1 = `*(cargador+0xE08)`) **corriendo**; el del cargador (id 3 = `*(cargador+0xE0C)`) **listo** (estado 2), sin correr; 2 y 5 en espera de semáforo, 4 listo |
| T3 | la pila del principal en la traba pasa por el dibujo (algún marco en el render de la escena o del arma en primera persona), no por el menú | **(127) cumplida, y más preciso:** `0x001C4F08` ← `FUN_001C4D00` ← `FUN_002B32D8` ← `FUN_002B4E80` ← `FUN_00102BD0` ← `FUN_00264018`. `FUN_002B32D8` es el **cambio de cuadro del búfer de paquetes**: espera en un lazo a que el DMA termine de mandar el cuadro anterior (`DAT_0040E668 != DAT_0040E66C`), y nunca termina. El menú no aparece en la pila |
| T4 | control (`--sin-soporte2`, en juego): las muestras del PC se reparten (varias funciones y el núcleo), el principal duerme en el vblank en alguna muestra | **(127) NO SE LEYÓ, y por algo peor** (`volcados/arma/f7b-pausa-20261011-200815/`): la precondición no se armó (J2 quedó en la SPAS: `igualar.iguales` = falso, y el banco siguió — arreglado: ahora da `ROJO_PRECONDICION`), la pausa del «control» anduvo, y **al cambiar J2 de la SPAS a la pistola el juego se CAYÓ** (con el pnach por defecto, sin la 2d): las 8 muestras en `0x80001578` (núcleo), todos los hilos en espera, `Cause` = 0x20 (excepción de syscall), `EPC` = `0x0027DBFC` (un `nop`: no cierra), `v1` = 0x01010101. Riesgo nuevo **N27**, una vez, sin control |
| T5 | la región `0x01F28800`–`0x01FF0000` sigue en cero en las dos corridas (una observación más de que está libre; no lo confirma) | **(127) REFUTADA en su pie:** en las dos corridas de hoy, `0x01F28800`–`0x01F29400` tiene datos (206–214 palabras: floats y punteros a los montones 6 y 13 y a `0x0046E100`, la zona del mod). El arena de `malloc` crece hasta ahí con el coop: la región **no** es libre por construcción |

**Lectura:** el mecanismo de la traba queda **medido** (observación, sin intervenir): el hilo principal espera para
siempre que el DMA termine el cuadro anterior y el cargador, de menor prioridad, se queda sin correr con la ranura 6 a
medio hacer. Que lo que rompe el DMA sea **el arma de J dibujada desde el montón 14 pisado** sigue `probable`
(ON → OFF → ON de (126) + la lectura en frío: es lo único que la 2d agrega a ese montón). R4 queda en pie y se
corrige su memoria: **pedida a `malloc`**, no tomada de una región «libre».

**Refuta H-dibujo:** si en la traba el principal aparece en espera (durmiendo en el vblank) y el cargador en espera de
otra cosa. Entonces R4 (`docs/16` (127) (d)) se revisa antes de bajarla a instrucción: cambiar el montón de la pausa
podría no destrabar.
