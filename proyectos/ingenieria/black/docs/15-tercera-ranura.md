# La tercera ranura — J2 con su propio modelo en primera persona

**Estado:** diseño en frío cerrado (bitácora (93o), 2026-09-28). Prototipo por PINE: `herramientas/ranura3.py`. **El código para el pnach está escrito (93s)** en `coop_mod.py` (bandera `SIN_R3`, 785 palabras con la ranura, 636 sin ella) y **no se instaló todavía**: lo instala y lo mide la notebook.

## Para qué

J2 usa la ranura de J (`J2+0x330` = `pers+0x470+i·0x240`). La ranura es el modelo en primera persona del arma en la mano (brazos + arma) **con su animación**. Por compartirla, los brazos de J2 tienen la pose de J y la recarga de J2 se ve en la mitad de J ((93m), `confirmado` con control). Con una ranura propia, la animación de J2 queda en su ranura y el filtro de eventos ya instalado (`0x0046E070`) saltea lo que salga a nombre de J2.

## Lo que se sabe (y con qué grado)

`pers = *(0x0040F50C)` es el singleton de personajes. Se construye **una sola vez al arrancar** (`main` → `FUN_00264018` → `FUN_001020c0` → `FUN_001ab780`), en el **submontón 6** (persistente), y nada lo reinicia entre niveles (`confirmado` en frío).

| Qué | Dónde | Grado |
|---|---|---|
| Ranuras de primera persona de J (una por arma) | `pers+0x470` (r0), `pers+0x6B0` (r1), 0x240 B cada una | confirmado |
| Pool de 33 ranuras de personajes | 0x4A40 B en el submontón 6 (arranca en `0x0122C000`), lista `pers+0x70..+0xF0`, contador `pers+0xF4` (= 33: todas dadas) | confirmado en frío y en volcado |
| Pool de 44 bloques de animación de 0x3F9A B | asignador `pers+0x8F0` (modo `+0x20`, bloque elegido `+0x8`, pool en `+0xC`: base[], cursor[] en `+0x10`, 0 = libre) | confirmado en frío y en volcado |
| Bloques fijos | r0 → 0, r1 → 1, cada ranura del pool → el suyo (35 en total) | confirmado en volcado |
| Préstamos | hasta 8 en la lista `pers+0x93C` (`FUN_001ac7xx`, campo `+0xB0`); sin bloque, desaloja uno (`FUN_001ac680`) | confirmado en frío |
| Bloques libres en juego | 1 a 9 según el volcado (1 con los 8 préstamos tomados: `ee-e4.bin`) | confirmado en volcado |
| Submontón elegido en pleno juego | ninguno (`*(0x0040F4A4)` = −1): quien aloja tiene que elegir uno y soltarlo | confirmado en volcado |
| Espacio en el submontón 6 | 132 736 B libres (fin `0x0133C000`, cursor `0x0131B980`) en los 4 volcados | confirmado en volcado |

### La ranura (0x240 B)

| Campo | Qué es | Quién lo escribe |
|---|---|---|
| `+0x00` | dueño (el jugador) | `FUN_001a51c8` |
| `+0x10`, `+0x20` | vec4 (0,0,0,1) | `FUN_00343fc8` (el pool lo hace al construir) |
| `+0x30..+0x4C` | 8 matrices de 0xA0 (en primera persona sólo 5..7: `+0x44/+0x48/+0x4C`) | `FUN_001a4ff0` |
| `+0x50` | el **sub** de 0x6C: el modelo del arma (`pers+0x398+i·0x6C`) | `FUN_001a51c8` |
| `+0x54` | el **compañero** de 0x9D0: la instancia del modelo, **la pose** | `FUN_001a4ff0` / `FUN_00345510` |
| `+0x5C` | nombre del aparejo (p. ej. `FP_P_S_01`) | `FUN_001a51c8` |
| `+0x90` | `FUN_001a9ea0(sub, nombre)` | `FUN_001a51c8` |
| `+0xAC` | su bloque del pool de animación | `FUN_001a4ff0` → `FUN_001abfd8` |
| `+0xB0` | préstamo (−1 = ninguno) | lista `+0x93C` |
| `+0xB6` | 1 = primera persona | `FUN_001a4ff0` |
| `+0xB8` | cargada (si es 1, `FUN_001a51c8` descarga antes con `FUN_001a5ee8`) | `FUN_001a51c8` |

### Quién la usa

- **Anima:** el mover de cada jugador, `FUN_00132D98` → `FUN_001a54e0(dt, J+0x330)` (`confirmado` en frío). J2 pasa por el mover, así que una ranura colgada de `J2+0x330` se anima sola.
- **Dibuja:** el método de dibujo del personaje, `FUN_00133BA0`, lee `(J+0x330)+0x54` (la pose) y `(J+0x330)+0x50` (el modelo) (`confirmado` en frío). El filtro por pasada de (93b) oculta **por objeto personaje** (`*(nodo+0x34)`), no por ranura: la ranura 3 se oculta con J2 sin tocar nada.
- **El sub se puede compartir** (`probable`): el dibujo sólo le lee datos de modelo (`+0x30`); la pose vive en el compañero.
- **Cargador:** `FUN_00143d90(*(0x0040F540), jugador, i)` → `FUN_001ac960(pers, i, modelo, jugador, …)` → carga el sub `pers+0x398+i·0x6C` → `FUN_001a51c8(pers+0x470+i·0x240, jugador, sub)`. Corre al construir al jugador (i = 0) y al cambiar de arma (i = `W+0x43`).
- **Cambio de arma:** `FUN_0013C868(dueño, i)` reata los 8 accesorios (`+0x25C..`) con `ranura+0x30..` y al final pone `+0x330` = `pers+0x470+i·0x240`.

## El diseño

**Memoria** (del hueco libre `0x0046E0B0..0x0046F800`):

| Rango | Qué |
|---|---|
| `0x0046E0B0` | `R3_PEDIDO`: 1 = pedir, 2 = hecho, 3 = sin bloque |
| `0x0046E0B4` | `R3_ARMADA`: 1 = ya se corrió `FUN_001a4ff0` (se arma **una vez por arranque**, como r0/r1) |
| `0x0046E0B8` / `0x0046E0BC` | lo que quedó en `R3+0xAC` y en `J2+0x330` (control) |
| `0x0046E100..0x0046E340` | R3 (0x240 B, alineada a 16) |
| `0x0046E340..` | el código de una vez |

**Armar (una vez por arranque):** elegir el submontón 6 (`FUN_00107ab8(0x0040F0F0, 6, 0)`), `FUN_00343fc8(R3+0x10)`, `FUN_001a4ff0(R3, 1)` y soltar el submontón (`FUN_00107b08(0x0040F0F0, 6, 0)`, que lo deja en −1 como estaba). Toma **un** bloque del pool. **Corregido en vivo (93p):** el compañero no sale del submontón 6 sino del `malloc` del sistema (`FUN_00107c20` → `FUN_0035e7d8` cuando `*(0x0040F0F0+0x3B8)` = 0), así que elegir el submontón no hace falta.

**Cargar (en cada nivel):** `FUN_001a51c8(R3, J2, pers+0x398+i·0x6C)` con `i` = `(signed char) J2+0x2C3`. Deja `J2+0x330` = R3 y `*R3` = J2.

**Riesgos medidos:**
- Con los 8 préstamos tomados, la ranura 3 se lleva el último bloque libre y el préstamo número 8 pasa a desalojar a otro (el juego lo tolera: `FUN_001ac680`).
- Armar dos veces se come otro bloque cada vez (nadie los devuelve): por eso `R3_ARMADA` persiste y no va en el pnach.
- Si `R3+0xAC` sale −1, no se carga (`R3_PEDIDO` = 3).
- El sub se comparte con la ranura `i` de J: si J2 cambiara a un arma **de otro tipo** en ese índice, recargaría el modelo de J. Mientras J2 sea el molde de J, las armas coinciden.

**Para el pnach — lo que quedó en el código (93s), corrigiendo este plan:**
1. **Armar y cargar desde la llamada por cuadro a `FUN_001ab428`** (`0x001295A8`), no desde el envoltorio del cargador: con FASE 2, arma una vez y, si `J2+0x330` != R3, carga (o sólo reapunta, si R3 ya tiene `sub_i` en este nivel). Eso cubre la carga de cada nivel **y** el final del cambio de arma, sin envoltorio de `FUN_0013C868`.
2. **Los accesorios NO se reatan:** `J2+0x25C..` son los objetos de J (el molde los copia; medido en volcado).
3. **Envoltorio del único `jal 0x1a51c8` de `FUN_001ac960`** (`0x001ACA84`), no de la función entera: si `a1` = J2 y `a0` es r0/r1 → R3; y recarga `r_i` para su dueño si la tiene en la mano, porque `FUN_001ac960` ya le reconstruyó el sub.
4. **Baja en el desarme:** `FUN_001a5ee8(R3)`, el espejo del destructor de J (`FUN_00133ed8`), que a J2 no se le corre.

**El plan original (antes de (93s)):**
1. Armar + cargar en el envoltorio del cargador (cuando J2 ya está armado).
2. Envoltorio de `FUN_0013C868`: si el dueño es J2, al volver poner `J2+0x330` = R3 y reatar sus accesorios con `R3+0x30..`.
3. Envoltorio de `FUN_001a51c8`: si `a1` = J2 y `a0` es r0 o r1, cambiar `a0` por R3.

## El prototipo (`herramientas/ranura3.py`)

Por PINE, en City Streets por el pnach (636 palabras, bloque activo). Se escriben R3 y el código en pausa. La llamada por cuadro `0x001295A8: jal 0x1ab428` (la actualización de `pers`) se desvía a `jal 0x0046E340`: el código corre una vez si `R3_PEDIDO` = 1 y sigue a `FUN_001ab428` con los argumentos intactos. Al terminar se repone. (El gancho del mod en `0x00129574` no sirve: el pnach es `patch=1` y lo reescribe en cada cuadro.)

**Resultado (93p):** la ranura se arma y se carga sin colgar, y J2 tiene brazos en cuadro. La recarga de J2 en los brazos de J baja de 2/8 a 1/8 en las capturas.

**Resultado (93q), en RAM con control (`herramientas/ranura3b.py`):** con la ranura 3, la pose de J (compañero de r0) no cambia con J2 disparando (1 palabra contra 33 con la ranura compartida), la cola de eventos de V no se mueve (0 contra 8), el arma de J no pasa a 8 y el filtro de eventos saltea todo lo de J2 (19 contra 9 que pasaban). **La fuga está cerrada.** El «1 de 8» de las capturas no tiene correlato en RAM (`hipótesis`: la animación de reposo de J).

**Predicción, escrita antes de medir:** con la ranura 3, J2 recarga, la **mitad de J queda quieta** (diferencia de imagen ≈ la de reposo) y en la mitad de J2 los **brazos quedan en cuadro con pose propia**. En el control (misma corrida, antes de armar, ranura compartida) la mitad de J se mueve con la recarga de J2. El emulador sigue vivo, y `R3+0xAC` ≥ 2 con un bloque menos en el pool.
