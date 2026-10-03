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
| P1a | control positivo `fuego-J`: `voces_tocaron` = **True** | **CUMPLIDA**, 3 de 3 corridas (las 2 cargas con la pieza y la del control): sellos de `V+0x284+8`/`+0x290+8` cambian con cada disparo de J |
| P1b | `fuego-J2` **con** la pieza: `voces_tocaron` = **True** | **CUMPLIDA**, 2 de 2 cargas: `[0,0]` → `[55517,55519]` (carga 1) y `[0,0]` → `[56721,56723]` (carga 2) |
| P1c | `fuego-J2` **sin** la pieza (`--sin-sonido`, el control): **False** | **CUMPLIDA**: sellos `[0,0]` → `[0,0]`, con las **mismas 90 salteadas** del envoltorio 4 — el disparo de J2 llega igual al seam y lo único que cambia es la pieza |
| P1d | audio de `fuego-J2` con la pieza: media **≥ 6000 y continua** desde el primer segundo (control ~3900) | **CUMPLIDA**: media 8398 (carga 1) y 8566 (carga 2), contra **3925** en el control. Para referencia, `fuego-J` da 8906/8757/8971 y `quieto` 1495–2381 |
| P1e | dos cargas seguidas sin colgar | **CUMPLIDA**: carga 1 armado 14,3 s, carga 2 armado 13,2 s, `vivo_despues` en las dos, `cuelga_o_no_arma` nulo |

**Medición (119), 2026-10-03, notebook caliente, pantalla libre.** Banco: `sonido_pieza_banco.py pieza` (dos cargas) y
`... control` (una). Town (nivel 2), por el selector. Salidas:
`volcados/inspeccion/banco-sonido-pieza-20261003-153506.json` y `banco-sonido-control-20261003-153539.json`.
El testigo del seam es `voces_tocaron` (el sello de las 2 voces de `V`), no el audio: el audio solo no discrimina
(los impactos de J2 ya llegaban a picos de ~9000 sin la pieza, y de hecho el control marca max 9035 con media 3925).

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
| P3a | J2 cambia de arma y la mitad de J **sigue mostrando el arma de J**; control `--sin-sub3`: la de J2 en las dos (F7) | **SIN MEDIR** (121): la corrida con la pieza **no ejerció el caso** — J2 no cambió de arma en 3 intentos (índice fijo en 1), así que las tres fotos salieron idénticas y el banco las marcó `FOTOS_INVALIDAS`. **El control sí quedó medido y fotografiado** (`volcados/arma/sonda-precondicion/`, pnach sin la pieza): con J2 en el fusil las **dos** mitades lo dibujan aunque el HUD de J marque su pistola (015\030), y con J2 de vuelta en la pistola las dos muestran pistola. F7 reproducido hoy |
| P3b | la secuencia del peligro (J y J2 con la misma pistola, J2 cambia, J cambia y vuelve) **sin cuelgue** | **REFUTADA** (121): la **carga 2 terminó con el juego no vivo** (`vivo_despues: false`, confirmado después con `selector_depuracion.py vivo`: el yaw no se mueve). La carga 1 llegó a jugarse bien (armado 14,4 s). Dos cargas seguidas **no** se cumplen |
| P3c | el síntoma **sin** la regla del dueño no es basura: la ranura de J lee la **instancia de J2** (el arma del último que cambió, en las dos mitades) — `hipótesis` derivada de que la arena de J2 tiene instancia válida | **SIN MEDIR** (121): depende de P3a, que no se ejerció |
| P3d | la guarda salta (no escribe) cuando `Bo` está colgado: medible contando cuántas veces se toma cada rama en el stub | **SIN EJERCITAR** (121): `SUB3_ESCRIB` = 0 y `SUB3_SALTOS` = 0 en las dos cargas. SUBH **sí corrió** (la ranura de J2 pasó a `sub3` y la de J quedó en `sub_0`, contra `sub_0`/`sub_0` sin la pieza), pero con la plantilla vieja en 0 (sub3 recién armado) sale por `FIN3` sin tocar ninguna de las dos ramas: la guarda nunca llegó a decidir. El contador discrimina; lo que faltó fue el caso |
| P3e | dos cargas seguidas sin colgar; `SUB3_MOLDE` = 0 después del desarme | **A MEDIAS** (121): `SUB3_MOLDE` = `MOLDES` en las **dos** cargas (`de_este_nivel: true`), así que el desarme corrió y la carga siguiente lo rearmó; pero la carga 2 no terminó viva, así que «dos cargas seguidas sin colgar» **no** se cumple |

**Lo que la corrida de (121) dejó, y por qué la pieza NO se prende.** Banco nuevo:
`herramientas/arma_pieza_banco.py` (`pieza` / `control`), calcado de `sonido_pieza_banco.py`. Pnach con la pieza:
**1181 palabras** (control: 1059), gancho **1 de 1** en RAM.

- **A favor de la pieza, medido:** con ella la ranura de J2 carga **su propio sub** (`R3+0x50` = `SUB3`
  `0x0046EF00`) y la de J queda en el suyo (`sub_0`), en las dos cargas; sin ella las dos caen en `sub_0`. El
  molde por nivel se invalida y se rearma bien (P3e, primera mitad).
- **En contra, medido:** con la pieza **J2 dejó de cambiar de arma** (3 intentos, índice fijo; sin la pieza el
  mismo helper lo cambió 1 → 0 veinte minutos antes). El gancho de la pieza vive justo en el camino del cambio
  (`0x001ACA2C`, dentro de `FUN_001AC960`): el sospechoso obvio es la pieza, en grado `probable` — **una sola
  corrida, sin control simétrico en la misma carga**. Y la **carga 2 terminó con el juego muerto**.
- **Hallazgo nuevo que puede explicar las dos cosas (`hipótesis`, sin control):** el arreglo de armas de J2 vive
  en memoria del mod (`ARMAS2` `0x0046DBC0`) y **sobrevive a la descarga**: en la carga 2 J2 arrancó ya con dos
  armas, que son instancias del nivel anterior. El desarme no lo limpia. Entra como riesgo **N26**.
- **El banco se equivocó primero, y el arreglo fue un nivel más arriba:** suponía que los jugadores tenían dos
  armas para alternar. En City Streets por el selector **tienen una sola**, así que la primera corrida salió
  idéntica en los cuatro pasos. Ahora el banco **construye** la precondición con la receta de (111)
  (`s1_juntar.py`) y sale en **ROJO** si no la logra, en vez de fotografiar un experimento que no discrimina.

**Lo que la lectura en frío de (122) le hizo a este P3** (no se reescribe ninguna fila; esto se agrega al lado). El sospechoso de P3a/P3b —el gancho `0x001ACA2C`— queda **descartado por lectura**: el tramo `0x001ACA34`–`0x001ACA68` da por vivos sólo `s0`, `s1` y `s6`, y SUBH no pisa ninguno de los tres. El «índice fijo» tiene una causa que no es la pieza: `FUN_0015bbd8` vuelve sin tocar el índice cuando `arreglo[1 - índice]` es nulo, y en los 5 volcados con el mod J2 (y J) tienen **una sola** arma (`herramientas/armas_estado.py`). **P3a y P3b hay que volver a medirlos** con el banco que construye la precondición. Aparte, (122) encontró y arregló un defecto distinto —el testigo por cuadro era el puntero del sub, que con la pieza es constante— así que al volver al banco se agrega una predicción:

| # | Predicción | Resultado |
|---|---|---|
| P3f | con el testigo del índice (`SUB3_IDX`), **R3 se recarga** cuando J2 cambia de arma: `R3_CARGAS` (`0x0046E0B8`) sube en el cambio; sin el testigo se queda fijo después de la primera carga | sin medir |
