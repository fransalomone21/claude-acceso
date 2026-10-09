# Predicciones de (123) — COOP-C pieza 2b en vivo, con el banco que construye la precondición

Escritas **antes** de cada corrida. Se agregan resultados al lado; ninguna fila se reescribe.
Banco: `herramientas/arma_pieza_banco.py` (City Streets por el selector, fork, notebook, Fran durmiendo).

## Lo que la primera corrida de control dejó (2026-10-09 01:47, `volcados/arma/banco-control-20261009-014809.json`)

- La precondición **se construyó**: J2 juntó el recogible 25 (SPAS 12) y quedó con dos armas. Los dos intentos
  de darle una 2.ª arma a J (recogibles 29 y 20) **fallaron**.
- **La mitad de J no dibujó NINGUNA arma**, ni en la base (los dos en la pistola) ni después; tampoco a los minutos
  ni después de hacer caminar a J (`volcados/arma/diag-20261009/`). En (121), sin los intentos de J, la mitad de J
  dibujaba la pistola en la misma escena. **La foto de P3a no podía discriminar nada.**
- Al armar J2 la escopeta en `sub_1`, la plantilla de `sub_0` (la que usa la ranura de J) pasó a **no viva**
  (`viva` True → False). Con el AK en (121) siguió viva. `hipótesis`: el tamaño del arma decide si pisa la
  arena de la plantilla de `sub_0`.
- El «vuelve» de J2 (`arma_a` a 1,5 s del cambio) **no ocurrió**: índice fijo en 1.
- `R3_CARGAS` = 1 en todos los pasos (sin la pieza no hay testigo del índice).

Cambios al banco (instrumento, no a la pieza): `--solo-j2` (no intenta la 2.ª arma de J) y 2,5 s entre pasos.

## C — control otra vez, `control --solo-j2`

| # | Predicción | Resultado |
|---|---|---|
| C1 | sin los intentos de J, la mitad de J **dibuja su pistola** en la base, como en (121). Si no, la causa no son los intentos de J sino el teletransporte o la escena | **CUMPLIDA** (01:53 y 01:57): la base muestra la pistola en las dos mitades. Grado `probable` para «los intentos fallidos de J lo dejan sin arma dibujada» (una corrida con y dos sin) |
| C2 | J2 cambia (índice 0 → 1, ranura a `sub_1`) y la mitad de J **deja de dibujar la pistola de J** (F7: el arma de J2, o nada si `sub_0` muere como hoy) | **CUMPLIDA** (01:57, `pieza-control-carga1-20261009-015716/j2-cambio.png`): HUD de J 015\030 (pistola) y la mitad de J dibuja la SPAS 12 de J2, con un bloque de basura encima. `sub_0` siguió **viva** esta vez |
| C3 | a 2,5 s, J2 **vuelve** (índice 1 → 0) | **NO a la primera** (01:53: ni el cambio ni la vuelta entraron). El banco pasó a **apretar y medir** (`cambiar`, hasta 4 pulsaciones): 01:57, cambio con 1 pulsación y vuelta con 2 |
| C4 | `R3_CARGAS` queda en 1 en todos los pasos | **CUMPLIDA** en las tres corridas |

## P — la pieza, `pieza --solo-j2` (`instalar --con-sub3`), dos cargas

| # | Predicción | Resultado |
|---|---|---|
| P3a | en `j2_cambio`, la mitad de J **sigue dibujando la pistola de J** y la de J2 su arma nueva | |
| P3f | `R3_CARGAS` **sube** en `j2_cambio` (el testigo del índice de (122) recarga R3) | |
| P3b | la carga 2 termina **viva**, con el mismo ciclo | |
| P3e | `SUB3_MOLDE` = `MOLDES` en las dos cargas | |
| P3g | la plantilla de `sub_0` **sigue viva** después del cambio de J2 (con la pieza J2 arma en su sub propio) | |

**Resultado de la corrida P (02:00, `volcados/arma/banco-pieza-20261009-020343.json`): ninguna fila se pudo
medir — el juego se COLGÓ al juntar J2 la SPAS en la carga 1** (contador de J2 clavado en 672 en todos los pasos
de las dos cargas, seis fotos con el mismo md5, EE en el manejador «Syscall: undefined» del kernel). Los datos de
(121) muestran lo mismo (671). Causa, en frío y en RAM: el sub3 no tiene su puntero de tabla virtual (`+0x5C` = 0)
y `FUN_001A51C8` hace una llamada virtual sobre él → salto a la dirección 0. Ver `docs/16` sección (123).

## P' — la pieza CON el puntero de tabla (`SUBH` le escribe `0x003E0180` en `+0x5C`), `pieza --solo-j2`

| # | Predicción | Resultado |
|---|---|---|
| P3h | J2 junta la SPAS y el juego **sigue vivo**: el contador de J2 sube entre todos los pasos, en las dos cargas | **CUMPLIDA** (02:18, `volcados/arma/banco-pieza-20261009-022004.json`): 788 → 1166 → 1295 en la carga 1 y 2166 → 2294 → 2423 en la 2. Junta, cambio (0→1) y vuelta (1→0) en las dos cargas. **El cuelgue de (121) y de las 02:00 queda arreglado por efecto, con control** (la misma corrida sin el puntero colgó 2 de 2) → la causa pasa a `confirmado` |
| P3a | en `j2_cambio`, la mitad de J dibuja **la pistola de J** y la de J2 la SPAS (el control dibuja la SPAS en las dos) | **REFUTADA** (`pieza-pieza-carga1-20261009-021839/j2-cambio.png`): la mitad de J dibuja **la SPAS de J2**, con el mismo bloque de basura que el control, aunque su ranura (`0x4ED7F0`) siga en `sub_0` con la plantilla de la pistola y la de J2 en `sub3`. Es el «Refuta» que (102) escribió para el sub: con índices distintos y subs distintos, el arma de J2 igual aparece en la mitad de J. **El sub propio no es lo que decide qué arma se dibuja en cada mitad** |
| P3f | `R3_CARGAS` **sube** en el cambio de J2 | **NO** (1 → 1 → 1 en la carga 1; 2 en la 2 por la carga). Mal predicha: con SUBH el cambio recarga R3 por el envoltorio de `FUN_001AC960` (`0x001ACA84`), que no cuenta en `R3_CARGAS`; el camino por cuadro no hace falta. El testigo del índice sigue sin ejercitarse |
| P3b/e | la carga 2 termina viva; `SUB3_MOLDE` = `MOLDES` en las dos | **CUMPLIDA** (`vivo_despues` True en las dos cargas) |
| P3i | después de armarse con la SPAS, el sub3 tiene `+0x34..+0x44` = `ffffffff` como los subs del juego (`hipótesis`: los escribe el método virtual) | **CUMPLIDA**: `ffffffff`×5 y `+0x48/+0x4C` = 1/2 con la pistola y 2/1 con la SPAS, igual que `sub_0`/`sub_1` |

**Lectura.** Dos cosas distintas, y no hay que mezclarlas: (1) el **cuelgue** era de la pieza y queda arreglado
(sub3 con su puntero de tabla); (2) **F7 no es del sub**. La pieza 2b arregla un cuelgue que ella misma introducía y no
entrega lo que prometía, así que **sigue APAGADA**. El mod **ya oculta a J2 en la pasada de J** (`ocultar por pasada`,
`oc.A` = J2, por defecto desde (93)), así que el arma de J2 en la mitad de J **tampoco viene del cuerpo de J2**. Queda un
sospechoso con nombre, en grado `hipótesis`: el estado del sistema de aparejos en `pers` (`*(0x0040F50C)`), que
`FUN_001A8168` y `FUN_001A51C8` reescriben con la arena del **último** que armó (`FUN_001AD030(pers, arena,
arena+18000)`, `FUN_001AC940`, `FUN_001AD050`, `FUN_001AC020`). Es «el arma del último que cambió», que es lo que F7
describe desde (96).
