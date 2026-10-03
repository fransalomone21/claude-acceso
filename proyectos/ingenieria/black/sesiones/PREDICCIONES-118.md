# Predicciones de (118) — COOP-C pieza 2

Escritas **antes** de medir. Lo que se mida se escribe **acá mismo**, al lado de la predicción,
diciendo si se cumplió o no: una predicción reescrita en silencio para que coincida es
indistinguible de no haber predicho nada.

---

## P1 — pieza 2a, el sonido de J2 por el cue (EN VIVO, pide la pantalla libre)

Copiada de `docs/16` «El sonido audible, (117)», sin cambios. Banco:
`python herramientas/sonido_pieza_banco.py pieza` y `... control` (Town = nivel 2). Con
`--con-sonido` la pieza va prendida en el pnach del banco; si el banco no la prende,
`coop_mod.py instalar --con-sonido` antes.

**Control positivo primero** (sin él, un False no distingue «el seam está mal» de «no suena»):
en `fuego-J`, el testigo `voces_tocaron` (el sello de las 2 voces de `V`: `V+0x284+8` y
`V+0x290+8`) tiene que dar **True**.

| # | Predicción | Resultado |
|---|---|---|
| P1a | control positivo `fuego-J`: `voces_tocaron` = **True** | *sin medir* |
| P1b | `fuego-J2` **con** la pieza: `voces_tocaron` = **True** | *sin medir* |
| P1c | `fuego-J2` **sin** la pieza (`--sin-sonido`, el control): **False** | *sin medir* |
| P1d | audio de `fuego-J2` con la pieza: media **≥ 6000 y continua** desde el primer segundo (control ~3900) | *sin medir* |
| P1e | dos cargas seguidas sin colgar | *sin medir* |

**Trampa ya medida:** la cuenta `cue+0x1D0` **no** sirve de testigo (la mezcla la baja a 0 al
terminar la muestra; 0 en los 16 volcados, también en los cuatro de J disparando). Y el audio solo
no discrimina: los impactos de J2 llegan a picos de ~8000–9900. Manda el seam en RAM.

**Si P1a–P1e se cumplen:** `CON_SONIDO = True` en `coop_mod.py`, las filas de la pieza pasan de
`coop-plan-b` a `coop-rangos` en `docs/14` (la regla 9 de `coop_diseno.py` lo exige) y `audio` sube
de K.

**Límites v1 aceptados, escritos antes:** (a) J2 suena con el **cue del arma de J** (iguales con la
misma arma, el caso de arranque; distinto timbre si no — `hipótesis`); (b) las 2 voces de `V` son
de los dos: un disparo puede cortar la cola del otro; (c) suena «en la cabeza» como el de J (N5).

---

## P2 — pieza 2b, el sub3 (EN FRÍO, ya medido en esta sesión)

| # | Predicción escrita antes de leer los volcados | Resultado |
|---|---|---|
| P2a | la cuádrupla de la plantilla (`+0x20..+0x2C`) apunta adentro de la arena del sub que la armó | **CUMPLIDA**: 4/4 en `sub0`, 16/16 volcados; control negativo (subs corridos `0x10`) 0/16 |
| P2b | hoy ningún par de subs comparte plantilla (el peligro es sólo del coop) | **CUMPLIDA**: 0/16 |
| P2c | los dos subs tienen su cuádrupla válida (los dos están armados) | **REFUTADA**: `sub1` **nunca** la tiene. `sub1+8` está colgado en 14/16 — apunta a memoria reusada. La instancia sí sobrevive en la arena (714 B) |

**Lo que P2c cambió** (`docs/16` «La guarda de plantilla viva, (118)»): la regla del dueño de
plantilla habría escrito cuatro palabras sobre un puntero colgado. Lleva la **guarda de plantilla
viva**: `*(p+0x1C) == p+0x4C`, que discrimina 16/16 contra 0/14. Tres instrucciones.

## P3 — pieza 2b en vivo (todavía sin fabricar, para cuando `coop_sub3.py` exista)

| # | Predicción | Resultado |
|---|---|---|
| P3a | J2 cambia de arma y la mitad de J **sigue mostrando el arma de J**; control `--sin-sub3`: la de J2 en las dos (F7) | *sin medir* |
| P3b | la secuencia del peligro (J y J2 con la misma pistola, J2 cambia, J cambia y vuelve) **sin cuelgue** | *sin medir* |
| P3c | el síntoma **sin** la regla del dueño no es basura: la ranura de J lee la **instancia de J2** (el arma del último que cambió, en las dos mitades) — `hipótesis` derivada de que la arena de J2 tiene instancia válida | *sin medir* |
| P3d | la guarda salta (no escribe) cuando `Bo` está colgado: medible contando cuántas veces se toma cada rama en el stub | *sin medir* |
| P3e | dos cargas seguidas sin colgar; `SUB3_MOLDE` = 0 después del desarme | *sin medir* |
