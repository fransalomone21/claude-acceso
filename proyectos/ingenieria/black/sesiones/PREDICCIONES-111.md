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
