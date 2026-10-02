# Predicciones de la tanda (113), escritas ANTES de medir

## V2 — la escala del marco raíz del panel, para que el HUD no quede apretado (2026-10-02, fork, City Streets)

Mecanismo (leído en (113), C de `black-datos`; medido el ritmo):
- `FUN_001F1530` (lo llama la activación `FUN_001F2340`) pone en el marco raíz del panel (`*(panel+0x54)`) la
  escala `+8` = ancho/640 y `+0xC` = alto/480 (medido: 1,0 y 0,9333), origen `+0/+4` = 0.
- **Por cuadro**, `FUN_00276458` (lo llama `FUN_00278B48`, el dibujo de la lista) copia `+0..+0x1C` del raíz a su
  compuesto `+0x20..+0x3C` y compone cada hijo con `FUN_00276290`: `origen_hijo = pos_hijo · escala_padre +
  origen_padre`, `escala_hijo = escala_propia · escala_padre`, recursivo. Medido: vigilante de lectura sobre `+8`
  dispara 1 vez por cuadro desde `0x00276470`; sobre `+0x28` lo leen los hijos (`0x002762AC`/`0x00276308`).
- El rectángulo del panel (`+0x78..+0x84`) entra a las posiciones de los elementos en la ACTIVACIÓN (anclas de
  `FUN_001F1AD8`), no por cuadro.

Cuenta (en unidades de 640, medidas sobre `doble-20261002-101753/antes.png` a 1920 px, ÷3): la caja de vida va de
~47 a ~180 (anclada a la izquierda del rectángulo, a ≈ 17), la de munición de ~460 a ~593 (anclada a la derecha,
b ≈ 17); ancho w ≈ 133 cada una. En un rectángulo de 260 de ancho no entran (17 + 2·133 + 17 = 300 > 260): por eso se
enciman. Con escala s y el rectángulo dividido por s, el ancho útil sigue siendo 260 en pantalla y las cajas ocupan
300·s: entran si s < 0,867.

**V2a (sólo la escala, control del modelo):** con el HUD doble prendido, `+8` = 0,75 en los dos marcos raíz y nada
más. **Predicción:** todo se achica hacia x = 0 de la pantalla: las cajas quedan a 3/4 de ancho, el panel izquierdo
ocupa ~23–218 (sigue encimado: se achican posiciones y tamaños por igual) y el derecho se corre a ~262–458, **adentro
de la mitad izquierda**. La altura no cambia. **Refuta el modelo:** las cajas no cambian (la escala no llega a los
tamaños) o no se corren (no llega a las posiciones).

**V2b (escala + rectángulo ÷ s):** rectángulos (40, 22, 386,7, 458) y (466,7, 22, 813,3, 458), activar y tipos (que
reponen `+8` = 1) y después `+8` = 0,75 en los dos. **Predicción:** cada HUD dentro de su mitad (izquierdo ~30–290 de
640, derecho ~350–610), cajas a 3/4 de ancho y **sin encimarse** (hueco ≈ 260 − 225 = 35 unidades ≈ 105 px a
1920), la retícula en el centro de la mitad izquierda. **Control:** la foto `doble` de la misma corrida (s = 1,
encimadas). **Refuta:** siguen encimadas, o algún HUD sale de su mitad (el rectángulo no entra como posición escalada).
**Inválida:** `FOTOS_INVALIDAS`, o el EE colgado (contador del mod).

**Primera corrida V2 (`volcados/hud/doble-20261002-102035/`): INVÁLIDA.** Fue la SEGUNDA activación con cuenta 2 en
la misma carga (la H4a de las 10:17 había activado el panel 1 y lo dejó con tipo 1 y su rectángulo). La activación
corrió (1 llamada) y **desde ahí el mundo no se actualiza**: el sitio por cuadro de `llamar_una_vez.py` no corre (0
llamadas en 2 s), el contador del mod no sube, los dos tipos quedaron en 0 y las cuatro fotos siguientes son el mismo
md5 (`FOTOS_INVALIDAS`). El EE **no** está colgado ni en pausa del emulador: ciclos que avanzan y seis PC dispersos
(`0x0029E7F8`, `0x002010E0`, `0x00275324`, `0x0035EB7C`, `0x00360868`…); `juego+0x28` = 0 (no es la pausa de
`FUN_0027F818`). **`hipótesis`:** activar el panel 1 dos veces en la misma carga lo deja en un estado que frena el
cuadro del mundo. Para la C pesa en la otra forma: lo que H1 prende en una carga lo tiene que apagar la descarga, y
eso se mide con DOS cargas seguidas (lección de (86)). Se relanza y se repite V2 desde una carga limpia.

**Segunda corrida V2 (`volcados/hud/doble-20261002-102451/`, desde una carga limpia):**
- **V2a CONFIRMADA, con control** (`escala.png` contra `doble.png`, md5 distintos): las cajas quedan a 3/4 de ancho, el
  panel izquierdo ocupa ~35–205 (de 640) y el derecho se corrió a ~275–445, **adentro de la mitad izquierda**, los dos
  todavía encimados; la altura igual; la retícula pasó de x = 480 px a 360 px (= 480 · 0,75). El modelo de
  `FUN_00276290` (escala sobre posiciones y tamaños, origen 0) queda **medido**.
- **V2b sin ver:** la reactivación (la segunda con cuenta 2 en la carga) **volvió a congelar el mundo** (0 llamadas por
  cuadro, `escala-rect.png` = `despues.png`): la congelación de la primera corrida se reprodujo, **2 de 2** → `probable`.
  Con cuenta 1 (el deshacer de H4a) la reactivación no congela.

**V2b rediseñada (una sola activación; escrita antes de correrla):** en pausa, los rectángulos ya divididos por s
((40, 22, 386,7, 458) y (466,7, 22, 813,3, 458)) y cuenta 2; activar y tipos; foto `doble` (s = 1: el izquierdo se
estira hasta ~387 y el derecho se sale por la derecha de la pantalla); después `+8` = 0,75 en los dos raíces, foto
`escala`. **Predicción:** en `escala` cada HUD dentro de su mitad (~30–290 y ~350–610 de 640), cajas a 3/4 y **sin
encimarse** (hueco ≈ 105 px a 1920), retícula en x ≈ 160 de 640 (480 px). **Control:** `doble` de la misma corrida.
**Refuta:** encimadas, o un HUD fuera de su mitad. Deshacer con cuenta 1 (la reactivación que no congela).

**Resultado V2b (`volcados/hud/doble-20261002-102748/`, `--escala-una 0.75`): CONFIRMADA, con control.** Una sola
activación (1 llamada en cada paso, el mundo siguió), cuatro fotos con md5 distintos. En `escala.png`: el HUD de J
ocupa ~125–830 px y el de J2 ~1085–1790 px, **cada uno en su mitad, las cajas a 3/4 y sin encimarse** (hueco ≈ 100 px
entre vida y munición, predicho 105), la retícula en x ≈ 480 px. El control `doble.png` (s = 1, mismos rectángulos):
el izquierdo estirado hasta ~1110 px (cruza el corte) y el derecho se sale por la derecha (sólo se ve su vida), como
se predijo. Al deshacer (cuenta 1) el juego siguió. **La perilla del tamaño del HUD existe y anda: escala `+8` del marco
raíz = s, con el rectángulo del panel en x ÷ s; dura hasta la próxima activación.**

## V3 — la fábrica de cuerpos sin spawner (2026-10-02, fork, City Streets)

Mecanismo (`docs/16`, «Cuerpos», (112); releído en (113)): `FUN_001746E0(sp)` arma los 8 argumentos de la fábrica
`FUN_00178408(*(0x0040F4D4)+0xFA4, *(sp+0x18), *(sp+0x1C), *(sp+0x40), *(sp+8), *(sp+0xC), *(sp+0x38), *(sp+0x29))`
desde el descriptor y sólo escribe `sp+0x24` (el nacido). **La sonda:** copiar los 0x48 primeros bytes del spawner
L12[17] (`0x010A9DC0`, tipo 3, inactivo, 1 restante, sin nacido) a `0x0046F400` (`.bss` libre: fuera de
`coop-rangos`, `coop-plan-b` y de `llamar_una_vez.py`) y llamar `FUN_001746E0(0x0046F400)` una vez
(`llamar_una_vez.py`, en pausa). Herramienta: `herramientas/fabrica_cuerpo.py`.
**Predicción:** la copia `+0x24` pasa a apuntar a un actor nuevo, que está en la lista viva de actores
(`mgr+0x79A0`), con vida 100 y su posición en el punto del descriptor (~(−2,7, −3,6, 38,6)); el spawner original queda
**igual** en `+0x24` (0), `+0x28` (0) y `+0x2C` (1). El juego sigue (contador del mod).
**Control (misma sesión):** el mismo spawner activado con su byte (`sondas_spawn.py mirar 17 …`, (83)): `+0x24` pasa a
apuntar al nacido y `+0x2C` baja a 0.
**Refuta:** la copia queda en 0 (la fábrica necesita algo del spawner real, p. ej. que esté en la tabla), o el original
cambia. **Inválida:** EE colgado, o el sitio de `llamar_una_vez` no corre (0 llamadas).

**Resultado V3: CONFIRMADA, con control.** La llamada corrió (1, sitio devuelto). La copia `+0x24` = `0x00592050`:
vida 100, estado 0, lista viva 5 → 6, libres 23 → 22, controladores de cuerpo 7 → 8, contador de apariciones 18 → 19.
El spawner original, **igual** (`+0x24` 0, `+0x28` 0, `+0x2C` 1). El nacido estaba a 3,7 m del punto al segundo y a
~11 m a los ~15 s: camina (es un enemigo: el tipo del descriptor). **Control** (`sondas_spawn.py mirar 17 4`, el mismo
spawner con su byte): su temporizador (7 s) termina y `+0x24` = `0x00592B90`, `+0x2C` 1 → 0, `+0x28` vuelve a 0 —
el camino del spawner lo gasta; el de la fábrica, no. Lo que sigue para la C: el nacido es del bando del descriptor;
pasarlo a bando 0, grupo de colisión 4 e invulnerable es la receta de (93i), sin medir sobre este camino.
