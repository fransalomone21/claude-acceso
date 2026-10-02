# Predicciones de la tanda (111), escritas ANTES de medir

## T1 — un enemigo ELIGE a J2 (2026-10-02, noche, fork solo, Fran durmiendo)

Mecanismo (ruta del repo): `herramientas/coop_ia.py` — PERC2 (`0x0046F000`) anota a J2 (id 1) en las amenazas de un
enemigo que lo percibe y ya está en combate (`+0x270` ≠ −1); HOST2 (sitio `0x00184904`) y DEF2 (`0x0018A8BC`) eligen
como blanco hostil / por defecto **al más cercano** de J y J2 (bitácora (107), (110)). El juego elige la amenaza actual
con sus pesos (en (110) los enemigos que peleaban con Tom siguieron con Tom): por eso el banco NO usa los enemigos de
Tom sino uno nacido de un spawner sobre el piso que J2 ya caminó (`s0_ia.py --hacia-j`), a ~3 m de J2 y con J a ~10 m.

**Predicción (IA prendida por defecto, pnach de 938 palabras):** el enemigo nacido ve a J (bit 0x1) en < 2 s; después
J2 entra a sus amenazas (id 1) y su amenaza ACTUAL (`+0x270`, índice de la lista) pasa a ser la ranura con id 1 en
< 5 s, y se queda ahí mientras J2 sea el más cercano. La vida de J2 puede bajar (los de spawner casi no disparan: que
no baje no refuta la elección).
**Control (`instalar --sin-ia`, misma carga y mismo banco):** id 1 nunca en sus amenazas; la actual es J (id 0).
**Refuta:** con la IA, 20 s con J2 en la lista y la actual nunca en J2 → la elección no pasa por HOST2/DEF2 (o los
pesos del juego ganan a «el más cercano»): se lee en frío quién escribe `+0x270`.
**Resultado T1 (`volcados/s0/t1-ia-1`, `t1b-muerte-j2`, `t1b-muerte-j2-2/3`, control `t1-ctl-1..3`):**
- **Elige a J2, confirmado con control.** `t1-ia-1`: el nacido (agente 8, a 2,5 m de J2 y 5,4 de J) ve a J2 (bit 0x2) y
  su actual es la ranura con id 1 desde 0,11 s; otro enemigo a 16 m (agente 11) también; J2 baja 750 → 680 en 1,6 s
  sin disparar. Control `--sin-ia` (792 palabras, mismo banco, 3 de 3): id 1 nunca, nadie le apunta, J2 en 750.
- **«El más cercano» REFUTADO como regla de cambio:** en `t1b-muerte-j2` el nacido vio primero a J (1,24 s), J2 entró a
  su lista a 1,70 s y la actual siguió en J los 20 s, con J2 a 2,5 m y J a 5,2. La elección es la PRIMERA percibida y
  HOST2/DEF2 no la reevalúan. Para el coop alcanza (los dos reciben enemigos); el ajuste fino es de la C.
- **`+0x270` = índice 0..2 de la lista:** en 7 corridas tomó sólo 0, 1, 2 y −1 (`act_crudos`). La hipótesis queda.

**Resultado T1b:** con 60 y con 40 la regeneración de J2 (~13/s hasta ~225) le gana al enemigo; con **6**, un disparo:
`J2+0x38C` = 2 a los 0,68 s y «MISSION FAILED» con J en 1e6 (`volcados/campana/t1b-3-final.png`). Confirmado.

**Resultado T5:** no se pudo: CONTINUE MISSION no se elige sin punto de control alcanzado (el cursor lo saltea, con
vuelta: RESTART -4-> QUIT -5-> RESTART -5-> QUIT; con dos opciones y vuelta eso no distingue arriba de abajo, así que lo
de (110), arriba = 4 y abajo = 5, sigue en pie). Queda pendiente: pide llegar a un punto de control.

## T2 — ¿suena el disparo de J2? (escrita antes de grabar)
Mecanismo (`docs/16-contexto-j2.md`, F4/(101)): el sonido del arma vive en la vista en primera persona `V`, que el
aislador (93l) saltea para J2 → el disparo de J2 no debería sonar. **Predicción:** en una escena callada (recién
cargado el nivel, o un nivel sin tiroteo de fondo), `fuego-J2` da un nivel de audio ≈ `quieto` (sin picos de
disparo) y `fuego-J` da picos claros (el control positivo del instrumento). **Refuta:** `fuego-J2` con picos del orden de
`fuego-J` → F4 no se reproduce con el mod actual. **Inválida** si `quieto` ya tiene picos (fondo ruidoso): se cambia de
escena, no se concluye.

**Resultado T2 (`volcados/inspeccion/20261002-025829` con el aislador, `…-030129` sin él; Town, sin tiroteo de fondo):**
Wilderness no sirvió (pistola con silenciador y nadie gastó balas: inválida). En Town los dos vacían el cargador (90 → 0):
| escena | con aislador (mod normal) | sin aislador (`--sin-aislar`) |
|---|---|---|
| quieto | media 2349 | media 2817 |
| fuego-J2 | media **3079**: fondo ~2000 y ráfagas cortas sueltas (impactos) | media **8349**, continuo |
| fuego-J (control) | media 9028, continuo ~10 000 | media 9163 |
**F4 confirmado con control** (el disparo de J2 no suena con el mod) y **la sonda S4 de `docs/16` confirmada**: sin el
aislador suena como el de J. El sonido vive en la vista `V`: la opción 1 (una `V2` propia) es la que arregla F4.

## T3a — la primitiva «traer a J2 junto a J» (escrita antes de probar)
Pregunta de marco: el riesgo de T3 es J2 quedando en la unidad vieja; la política natural (docs/14 §B6, «traer a J2
junto a J si queda lejos») necesita poder mover a J2. Mecanismo (82): el mover (`FUN_00132D98`) le entrega un
DESPLAZAMIENTO al controlador de `J+0xB4`; el controlador no guarda copia de la posición (medido: 0 campos en 0x400 B).
**Predicción:** escribir sólo `J2+0xA0` (en pausa) = J + (2, 0, 0) deja a J2 ahí (a < 0,5 m del destino a los 3 s) y
después camina (`coop_mod.py manos 2` > 5 m). **Control:** `--control` (no escribe): J2 queda donde estaba.
**Refuta:** J2 vuelve a su lugar (la posición tiene otra fuente: el cuerpo del motor de física) o cae/atraviesa el piso.

**Resultado T3a (Town):** control: J2 no se mueve (0,00 m). Escrito: J2 queda a 0,13 m y a 0,02 m del destino en dos
lugares distintos, y después camina 9,4 y 9,0 m (la primera caminata terminó en el lugar viejo por geometría: mismo
rumbo y misma duración desde casi el mismo punto; la segunda, desde otro destino, terminó en otro lado). **Confirmado.**
Con esto el diseño de T3 queda en `docs/16` (alternativa 1: gancho `0x0012DDCC` en la descarga, que corre ANTES de
sacar la colisión) y en `coop-plan-b`. El síntoma sin arreglo sigue sin medir (pide un cambio de unidad jugando).

## S1 — juntar: candidato compartido, consumidor por jugador
La predicción y el control son los de `docs/16` («Sonda del concepto» de juntar, escrita en (100), antes de esta
tanda). Herramienta: `herramientas/s1_juntar.py` (recogibles: `*(0x0040F4E4)` + i·0x160, posición `+0xA0`, tipo
`+0x140`, banderas `+0x152`; candidato `pickups+0x5848`).
**Resultado (City Streets):** J puesto sobre el arma 29 y J2 a 7,9 m mantiene «agarrar» → el candidato es esa arma
(5 de 5 lecturas), **J2 la levanta** (arma nueva en su ranura 1, en la mano), el arma desaparece del piso (`+0x152`
4 → 0) y J no cambia de arma (recibe 120 balas: la munición de al lado la toca J, como dice el diseño). **Control:**
J2 encima del arma 25 (0,3 m) y J a 5,1 m → candidato 0, nada cambia, el arma sigue. **Confirmado.**
Trampa medida en el camino: en City Streets el primer control salió inválido porque el teletransporte de una sola
escritura se pisa (ver T3b); con `teletransporte.py` (tres lugares) quedó limpio.

## T3b — el teletransporte en City Streets (corrige T3a)
Medido: escribir sólo `J2+0xA0` en City Streets **vuelve al lugar viejo en el mismo cuadro**. Vigilante de escritura
sobre `J2+0xA0`: `0x00126014` dentro de `FUN_00125F88` («poner la matriz»; ignora saltos de más de 50 m si
`+0xC4` = 4), llamada por el mover (`0x133044`) y por el callback del controlador (`FUN_0025D110` → `FUN_00387FC0`,
`ra` `0x388184`), más `0x0012603C` desde `0x1356EC`. El controlador **sí** guarda la posición, en el motor de física:
`e0c+0x40` (`e0c = *(*(ctrl+0x34)+0xC)`) y el cuerpo `*(e0c+0x58)+0x10`. Escribiendo los tres: se sostiene (0,00 m) y
camina 8,9 m. La lectura de T3a («el controlador no guarda copia») era de buscar en el lugar equivocado (0x400 B del
controlador, que es chico y apunta afuera): queda corregida acá y en `docs/16`. En Town alcanzó una escritura porque
el controlador estaba quieto (hipótesis: en City Streets lo mantiene activo el títere superpuesto a J2).

## F2 — J2 cambia de arma (escrita antes; J2 tiene dos armas desde S1)
Mecanismo (`docs/16`, (100), `probable`): el cambio pasa por `FUN_00143D90` → `FUN_001AC960` → el envoltorio de la
ranura 3 (`0x001ACA84`, (93s)), por jugador. **Predicción:** J2 aprieta `arma_a` (6) 0,3 s → su arma en la mano
(`J2+0x2A4`) pasa de `0x6dead0` a `0x6de7a0` e índice `+0x2C3` 1 → 0 en < 2 s; las de J no cambian.
**Control:** 2 s sin apretar nada: no cambia. **Refuta:** no cambia (el cambio de arma de J2 no corre) o cambia la de J.

**Resultado F2:** control: igual a los 2 s. Con `arma_a`: J2 `0x6dead0`/1 → `0x6de7a0`/0, y de vuelta con otro
`arma_a`; J sigue en `0x6de690`/0. **Confirmado.**
**De paso, F7 visto con control** (`volcados/campana/f2-cambio.png` y `f2-arma-nueva.png`): con J2 en la pistola las
dos mitades muestran pistola; con J2 en el AK **las dos mitades muestran el AK**, con J todavía con la pistola en RAM.
El modelo del arma en primera persona es uno solo y lo pone el último que cambió (el «sub» compartido de (102)): la
dirección J2 → J queda confirmada en pantalla, y con ella la elección del sub3 propio (B8).

## T1b — J2 muere por daño REAL (escrita después de `t1-ia-1`, antes de esta corrida)
Banco: el mismo, con la vida de J2 en 40 escrita a mano (la vida en 0 escrita no mata, (93f); acá el 0 lo pone el daño)
y J en 1e6. **Predicción:** al llegar a 0 por los disparos, J2 pasa a su segundo controlador (`J2+0x32C` =
`0x0046D410`), `J2+0x38C` = 2, y «MISSION FAILED» en < 10 s con J vivo (lo mismo que la llamada directa de (110) P3).
**Refuta:** vida de J2 ≤ 0 y `+0x38C` sigue en 0 → el daño al jugador 2 no llega a la muerte (otro camino que el de J).

## T5 — «CONTINUE MISSION» (punto de control) con el coop (escrita con el menú en pantalla, antes de elegir)
Mecanismo: (110) midió que RESTART MISSION pasa por el desarme de (87) (`DESARMES` +1) y el rearmado (`MOLDES`,
`ATADAS` +1) en ~2,3 s. **Predicción:** CONTINUE recarga el mundo por el mismo camino: `DESARMES` +1, `MOLDES` y
`ATADAS` +1 en < 10 s, FASE 2 / ESTADO 3, sin cuelgue en 60 s, y J2 camina (`coop_mod.py manos 2`: > 5 m; control
`--control`: ~0 m). **Refuta:** `DESARMES` no sube y J2 queda con el estado viejo (fantasma) o el EE se cuelga.

**Qué es `+0x270`:** hipótesis, el índice 0..2 de la lista `+0x150/+0x1B0/+0x210`; se mide en la misma corrida
(si toma valores fuera de 0..2 o −1, la hipótesis cae y la lectura de «actual» se rehace antes de concluir).
