# Predicciones de (115) — COOP-C pieza 1: el HUD doble en el stub

Escritas **antes** de instalar y medir. El resultado va debajo de cada una, sin reescribir la predicción.

Pieza: `herramientas/coop_hud.py` (diseño a nivel instrucción, `docs/listados/C1-coop-hud.txt`), instalada con
`coop_mod.py instalar --con-hud`. Medición: `herramientas/hud_pieza.py <etiqueta>` (estado en RAM + tres fotos:
base, J dispara, J2 dispara). Banco: el fork, `campana_coop.lanzar()` + `probar_nivel(0)` (City Streets) y una
segunda carga seguida.

## C1a — carga 1, con la pieza

- **RAM:** los 13 ganchos del HUD en RAM; cuenta de paneles 2; rectángulos (40, 22, 386,7, 458) y
  (466,7, 22, 813,3, 458); escala `+8` de los dos marcos raíz 0,75; tipo del panel 1 = tipo del panel 0 (≠ 0);
  `*(0x0040F4D0)` el de siempre (la conmutación vuelve).
- **Pantalla (`base`):** dos HUD, uno por mitad, a 3/4, sin encimarse.
- **El discriminador:** J dispara → baja el cargador de J en RAM y **cambia sólo el número de la izquierda**; J2
  dispara → baja el de J2 y **cambia sólo el de la derecha**. Los dos números de munición son distintos entre sí
  (o lo pasan a ser después de disparar uno solo).
- Por qué (mecanismo): los 11 pasos en 0 hacen que todo elemento lea `jugadores[0]` (H4a, (113)); `PANELH` corre la
  actualización del panel 1 con `*(0x0040F4D0)` = `J2 − 0x30`, así `jugadores[0]` = J2 (P2, `docs/16`).
- **Si falla:** la derecha igual a la izquierda → la conmutación no corre (FASE ≠ 2 o el sitio `0x001F25DC` no es
  el lazo por cuadro); basura o cuelgue → falta un campo en la cabecera sombra (el censo (112) sería incompleto).

## C1b — control (el mismo bloque sin la pieza)

- `coop_mod.py instalar` (sin `--con-hud`), fork relanzado, misma carga: 0 de 13 ganchos en RAM, cuenta 1, **un
  solo HUD**; disparar con J2 no cambia ningún número del HUD.

## C1c — dos cargas seguidas, con la pieza

- La segunda carga (otro `probar_nivel`) arma a J2 (FASE 2, ESTADO 3), **no cuelga** y repite C1a (dos HUD, la
  derecha de J2).
- Por qué: la única activación por carga es la del juego (`0x00128F64`); el desarme (`FUN_00129DE8` →
  `FUN_001F26C0`) desactiva los `cuenta` = 2 paneles y pone `+0x238` = 0x38, así la activación siguiente no
  re-enlista elementos ya enlistados (el ciclo de la lista que congeló el mundo en (113), `probable`).
- **Si cuelga:** el desarme no pasa por `FUN_001F26C0` en el camino del selector, o deja algo del panel 1 vivo; el
  arreglo vuelve a `docs/16` antes de tocar el stub.

## Lo que esta prueba NO mide

- El indicador de daño, los avisos y los carteles de J2 (llegan por la fachada con panel 0: riesgo (iii) de
  `docs/16`); la pausa desde el panel de J2 (descartada a propósito, `+0x28` en la sombra).
- Los 8 niveles y el ritmo: eso es la regresión de la C.

---

## Resultados (medidos después, sin tocar las predicciones de arriba)

- **C1a, CUMPLIDA (confirmado en pantalla y en RAM).** `volcados/hud/banco-pieza-20261002-121243.json`, fotos en
  `volcados/hud/pieza-pieza-carga1-20261002-121145/` (md5 distintos, con foco). RAM: 13 de 13 ganchos, cuenta 2,
  rectángulos (40, 22, 386,7, 458) y (466,7, 22, 813,3, 458), escala 0,75 y 0,75, tipos 1 y 1, `*(0x0040F4D0)` =
  0x5A8A80 en las tres lecturas. Pantalla: dos HUD, uno por mitad, a 3/4, sin encimarse. **J dispara** (cargador
  15 → 13): izquierda 013, derecha 015. **J2 dispara** (15 → 13): derecha 013. Vida 750 y 750 (no se probó daño).
- **C1b, CUMPLIDA.** `banco-control-20261002-121459.json`, `pieza-control-carga1-20261002-121452/`: 0 de 13
  ganchos, cuenta 1, escala 1,0; un solo HUD (el de siempre) y después del disparo de J2 muestra 013 = el cargador
  de J.
- **C1c, CUMPLIDA.** Segunda carga seguida: J2 armado en 14,2 s (la primera 14,3), no cuelga, y repite C1a
  (`pieza-pieza-carga2-20261002-121236/`: izquierda 013, derecha 015 tras el disparo de J).
- **No medido:** el daño a J2 en la barra de vida de la derecha; queda para la regresión o una partida de Fran.
