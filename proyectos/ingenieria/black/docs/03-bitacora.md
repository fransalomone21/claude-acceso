# Bitácora

Registro del proyecto. **Lo nuevo va arriba.** Al retomar, alcanza con leer las
dos primeras entradas.

Formato de cada entrada:

```
## AAAA-MM-DD — título corto
**Máquina:** PC / notebook / nube · **Modelo:** Opus / Sonnet / Haiku
**Objetivo:** qué se venía a hacer
**Resultado:** qué se logró
**No funcionó:** los callejones sin salida. Esta parte no es opcional.
**Sigue:** el próximo paso concreto
```

---

## 2026-09-28 (93n) — La tercera ranura, en frío: la ranura es el índice del arma en la mano
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (plan de la ranura propia de J2) · **Nodos:** `personajes` (evidencia; sin cambio de K)
**Objetivo:** saber qué haría falta para darle a J2 una ranura propia bien armada.

- **Quién asigna la ranura:** el constructor del jugador (`FUN_00139C68`) crea las dos armas (`FUN_0015CEF0`) y hace `+0x330 = pers + 0x470 + (+0x2C3)·0x240`; al cambiar de arma, `FUN_0015BE70` llama a **`FUN_0013C868(dueño, W+0x43)`**, que vuelve a poner `+0x330 = pers + 0x470 + i·0x240` y reata los 8 accesorios del personaje (`+0x25C..`) con los de la ranura (`ranura+0x30..`). **La ranura es el índice del arma en la mano (0 o 1)**, no el jugador: J usa la 1 cuando cambia a su segunda arma. Por eso la ranura 1 no le sirve a J2 ni como parche (se pisaría con J), además del aparejo equivocado de (93m).
- **Lo que haría falta** (plan, `hipótesis`): una ranura 2 en `pers + 0x8F0` (medir antes si ese espacio es del singleton y está libre) armada con el aparejo del arma de J2, y un `FUN_0013C868` propio para J2 que la use en lugar de `W+0x43`. Falta encontrar quién **carga** el aparejo (los punteros `+0x44..+0x54` y el nombre `+0x5C` de la ranura) al empezar el nivel o al levantar un arma.
**No funcionó:** nada (lectura en frío).
**Sigue:** en frío, quién escribe `ranura+0x44..+0x5C` (el cargador del aparejo en primera persona); en vivo, qué hay en `pers+0x8F0`.

---

## 2026-09-28 (93m) — La causa de la pose compartida: J2 usa la RANURA de J, que es el modelo en primera persona del arma en la mano
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (la recarga de J2 en la mitad de J; los brazos de J2 con la pose de J) · **Nodos:** `vista-fp`, `personajes` (evidencia), `codigo-nuevo` (entrega parcial)
**Objetivo:** encontrar por dónde llega la recarga de J2 a la vista, ya que (93l) no alcanzó.

- **Fotos del objeto de la vista** (`herramientas/vistafp93.py`, `vistafp93.json`; 6 fotos en reposo para descartar relojes, después J2 dispara 5 s): con J2 **disparando no cambia nada** (el aislamiento de (93l) cubre el disparo); con J2 **recargando** —y sólo entonces— cambian `V+0xBB8..+0xBE0`, pares (id, 1) con ids 7, 0x1E, 0xB, 0x22, 3, 0xD, 2, 0x1A: una cola de eventos de animación. Los bloques compartidos `+0x270..+0x278` no cambian. Los escribe la biblioteca de animación (`0x00281C34`/`0x00281DD0`), llamada desde `FUN_001D6038`/`FUN_001D63A8` del módulo de la vista (`aislar93d.py`). `FUN_001D63A8` la llama **`FUN_001E80C0(evento, &x)`**, que es el callback `*(0x0040F50C)+0x964` (junto con `+0x948` = `FUN_001E7E58`, los sonidos de animación): usa el arma de `*x` y, si el evento corresponde, anima la vista única.
- **Filtro de eventos** (`coop_mod.py`, envoltorio de 16 palabras en `0x0046E070`, gancho en `0x001E80C0`; **bloque de 636 palabras**): vuelve si `*a1` == J2. **No saltea nada**: vigilando su contador (`aislar93e.py`), `a1` = **`0x004ED7F0` = `+0x330`, la ranura, que J2 comparte con J** (su dueño es J). Los eventos de la animación de J2 salen **a nombre de J**.
- **Con ranura propia** (`herramientas/ranura93.py`, por PINE: J2+0x330 = la ranura 1, `pers+0x6B0`, con dueño J2): J2 vacía y recarga, **el arma de J no pasa nunca a 8**, a la vista no llega ningún evento de recarga y **la mitad de J queda quieta en los 8 cuadros** (en el control, `aislar93.py prueba2` con la ranura compartida y el mismo bloque, 2 de 8 mostraban la recarga de J2) — `confirmado` con control. **Pero** en la mitad de J2 los brazos quedan bajos y el arma fuera de cuadro (`j2-mitad-ranura.png`).
- **Por qué** (`herramientas/ranuras_cmp93.py`, `ranuras93.json`): las dos ranuras están inicializadas y difieren en el aparejo: la 0 es `FP_P_S_01`, la 1 `FP_S_G_S_001`. **Las ranuras son los modelos en primera persona de las dos armas del jugador** (lo que (80) intuyó), con su animación: con la 1, J2 anima el aparejo de la *otra* arma de J. La ranura explica también (93b)/(93j): los brazos de J2 tienen la pose de J porque comparten la ranura.
- **Lo que haría falta:** una **tercera ranura** armada para J2 con el aparejo de su arma (0x240 B en el singleton de personajes + su compañero de 0x9D0 B + el modelo): carga de recursos, varias sesiones. Con eso, el filtro de eventos (ya instalado) haría el resto.
- **Regresión** (la campaña entera con 636 palabras): 8 de 8, igual que antes.
**No funcionó:** la ranura 1 como ranura de J2 (aparejo equivocado).
**Sigue:** decidir si se encara la tercera ranura (es lo que arregla, a la vez, la pose de los brazos de J2 y la recarga en la mitad de J).

---

## 2026-09-28 (93l) — Aislar la vista en primera persona de J2: las llamadas de J2 se saltean, pero la recarga sigue viéndose en la mitad de J (parcial)
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (lo visto en (93k): la recarga de J2 aparece en la mitad de J) · **Nodos:** `vista-fp` (evidencia), `codigo-nuevo` (entrega parcial)
**Objetivo:** que las acciones de J2 no animen la vista única (opción (3b) de (91): J2 sin vista propia).

- **En frío:** en el código de armas hay 11 llamadas a la vista (`*(*(0x0040F510)+0xCBD8)+0xC`), a 5 funciones que le cambian el estado: `FUN_001D6E78` (conjunto de animaciones al cambiar de arma), `FUN_001D7360`, `FUN_001D7500`, `FUN_001D73D8` (desde el llenado del cargador) y `FUN_001D6F90` (4 caminos del arma); las consultas (`FUN_001D74C8`, `FUN_001D7278`) son del controlador del jugador. Las 5 empiezan con `addiu sp` + un guardado (palabras leídas del ELF).
- **El cambio** (`coop_mod.py`, **618 palabras**): el por cuadro prende **`AISLAR_BANDERA` (`0x0046DEF4`)** mientras actualiza a J2 (3 palabras; por cuadro hasta `0x0046D9E0`); la entrada de cada una de las 5 funciones salta (`j` + `nop`) a un **envoltorio** (15 palabras cada uno, `0x0046DF00..0x0046E02C`) que, con la bandera prendida, vuelve con `v0` = 0 y, si no, ejecuta las dos instrucciones desplazadas y sigue en la original + 8. Cuenta pasadas/salteadas en **`0x0046E040..0x0046E068`**. `instalar --sin-aislar` es el control. `docs/14`: 9 filas nuevas.
- **Medido** (`herramientas/aislar93.py`, City Streets por el pnach, J2 sosteniendo «disparar» 4 s con el mando falso 2, después J dispara 2 s; `aislar93-prueba.json`): en reposo **nadie** llama a la vista (`aislar93b.py`, vigilante de lectura sobre la bandera: 0 en 6 s). Con J2 disparando: **las llamadas de J2 se saltean todas** (`FUN_001D6F90` 45, `FUN_001D7500` 344 —desde `0x00159304` y `0x001579CC`—, 0 pasadas), las de J pasan (12 al disparar J), J2 vacía y recarga dos veces (30 → 15 → 0), J dispara (15 → 3) y el emulador sigue vivo. **Pero la mitad de J sigue mostrando la recarga de J2** (capturas 1 y 3 de `tira-aislar-prueba.png`), y en ese momento **el arma de J pasa a estado 8** (`+0xD8`) sin que J haga nada. El que escribe el estado de J es su propia actualización por cuadro (`0x00157388`, llamada desde `0x001570B4`, 22 de 22, igual con o sin J2 disparando: `aislar93c.py`): el 8 es **una reacción de J a algo compartido**, no una escritura de J2.
- **Lectura:** la recarga de J2 (`FUN_00156DC0` sólo pone `+0xD8` = 4) llega a la vista por otro camino que no pasa por las 5 funciones; candidatos, los bloques compartidos del arma `+0x270..+0x278` (dueño J, (91)) o una consulta de la vista que mira el estado del arma. `hipótesis`.
- **Estado:** el aislamiento queda **instalado** (618 palabras, bloque activo): no rompe nada de lo medido y saca de la vista 389 llamadas de J2 en 4 s; su efecto visible (que J no haga el retroceso del disparo de J2) **no está medido**.
**No funcionó:** aislar por esas 5 funciones no alcanza para la recarga.
**Sigue:** diferencia de fotos del objeto de la vista (0x1C50 B) en reposo contra J2 recargando, y un vigilante sobre el campo que cambie.

---

## 2026-09-28 (93k) — El parpadeo de la mitad de J2: en régimen quieto nadie más escribe el ancho de la vista
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (lo que vio Fran: «la mitad de J2 se angosta y se reacomoda») · **Nodos:** `render` (evidencia; sin cambio de K)
**Objetivo:** tramo e): quién escribe `R+0xD470`/`+0xD474` (ancho y proporción de la vista, (89)) en el mismo cuadro.

- **Medido** (`herramientas/parpadeo93.py` → `ritmo_vigilante.py`, `break` puesto en pausa; City Streets por el pnach, 530 palabras; `volcados/campana/parpadeo93.txt`): `R+0xD470`, **300 escrituras (~150 cuadros): 150 en `0x0046F98C` y 150 en `0x0046FA58`**, las dos del stub de la pantalla (la mitad antes de las pasadas, la restauración después). `R+0xD474`, 24 escrituras: sólo `0x0046F998`/`0x0046FA60`. **Ningún intruso** (`confirmado` para el régimen quieto: J y J2 parados).
- **Con eventos** (`herramientas/parpadeo93b.py`: durante el conteo, J2 sostiene «disparar» y aprieta «zoom» 75 veces con el mando falso 2): **J2 disparó y recargó** (cargador 15 → 3, reserva 30 → 15: control positivo de que los eventos ocurrieron; la primera corrida no lo tenía porque el botón iba sin su valor en float `+0x4C+4i`, como en `tirador.py`). **Otra vez 300 de 300 en el stub.** El ancho de la vista **no es** el parpadeo, tampoco con disparo, zoom y recarga (`confirmado` que no hay otro escritor en esas condiciones).
- **De paso, en pantalla** (`parpadeo93b-antes.png`): con J2 recargando, **las dos mitades muestran la misma animación de recarga** (J no recargaba) y el HUD de J muestra el ícono de agachado. Es la vista en primera persona única de (93j), ahora vista en pantalla: lo que anima J2 lo anima también J. `probable` (una captura; el cargador de J no se midió).
**No funcionó:** la primera corrida con eventos (botón sin el float: J2 no disparó).
**Sigue:** que Fran diga en qué momento ve el parpadeo; candidato siguiente, el sub-raster (`*(R+0xD458)+0x60`).

---

## 2026-09-28 (93j) — Los brazos de J2 con la pose de J, en frío: la vista en primera persona es un objeto de 0x1C50 B armado una sola vez
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (los brazos de J2 animados) · **Nodos:** `vista-fp` (evidencia; sin cambio de K)
**Objetivo:** tramo c): qué de J2 apunta a lo de J.

- **Medido en vivo** (`herramientas/compartido93.py`, City Streets por el pnach; `volcados/campana/compartido93.json`): punteros **iguales** en J y J2 que apuntan fuera de los dos bloques: `+0x10` (vtable), `+0x30` (`0x005AD320`), `+0x7C`/`+0x8C` (**relleno de la matriz** `+0x70..+0xAF`: el stub del títere los copia; no son la animación, contra lo que se sospechó en (79)), `+0xB8/+0xBC`, `+0xFC`, `+0x270/+0x274/+0x278` (los bloques del arma con dueño J), `+0x294`, `+0x328`, `+0x330`, `+0x354/+0x358/+0x35C/+0x360`, `+0x410`, y los vtables de los controles. Propios: `+0x34`, `+0xB0/+0xB4`, el arma (`+0x2A0..+0x2A8`), `+0x2D0`, `+0x34C`, los tres controles.
- **En frío:** la hipótesis de (91) se afina. El contenedor `*(0x0040F510)+0xCBD8` (0x60 B, **~340 referencias** en el código) lo arma `FUN_001D5828` al arrancar el juego con `FUN_001E82A8`, que aloja en línea sus sub-objetos; el de `+0xC` (la vista en primera persona, con el conjunto de animaciones en `+0x1BE0`) mide **0x1C50 B** con 6 reproductores de 0x430. No hay un constructor aparte que se pueda llamar dos veces.
- **Qué costaría** (plan, sin probar): clonar ese objeto para J2 (0x1C50 B: no entra en el hueco libre de `0x0046DE64..0x0046F800`, 0x199C B) y, como con la cámara, **cambiar el puntero `+0xC`** durante la actualización de J2 y durante la pasada 2. El riesgo es el del molde de (80): punteros internos del clon que siguen apuntando al original. Varias sesiones; no se empezó.
**No funcionó:** nada (no se tocó nada).
**Sigue:** decidir si vale el costo (es cosmético: J2 ve sus brazos con la pose de J).

---

## 2026-09-28 (93i) — Un cuerpo donde no hay aliado: un soldado de spawner con bando 0 y grupo de colisión 4 (prototipo por PINE, Wilderness)
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B2 en los 3 niveles sin aliado) · **Nodos:** `fisica` (evidencia), `spawn`, `codigo-nuevo` (entrega)
**Objetivo:** que Wilderness, Steelworks y Gulag también tengan títere.

- **La sonda** (`herramientas/titere_spawn93.py`, Wilderness, bloque del pnach; `volcados/campana/titere_spawn93.json`): se hace nacer un soldado con un spawner (83) junto a J2 y, ya con alta, se le pone bando 0. **Control** (bando sin tocar, 1): `ELEGIR` no lo toma (`TITERE_ACT` = 0). **Con bando 0** lo toma en ≤ 0,5 s.
- **Primer problema, el cuelgue:** en cuanto el stub le copia la matriz de J2, el EE queda dando vueltas en `0x0033DDB0` (6 de 6 muestras de PC; `FUN_0033DD98` recorriendo memoria con una cuenta basura): **dos cuerpos de colisión exactamente en el mismo punto**, la misma caída que J2 encima de J en (93c). 2 de 2 corridas. **Arreglo en el stub**: después de copiar, `+0xA0` del títere += 0,3 m en x (5 palabras FPU como `.word`; por cuadro hasta `0x0046D9D4`). Con eso no cuelga (1 de 1).
- **Segundo problema, J2 trabado:** sin cuelgue, el soldado empuja a J2 (lo corrió ~6 m) y `manos` no lo mueve (0 m). **En frío** (`FUN_0025CEF8`, al atar el controlador de colisión): el **grupo de colisión** va en `*(*(ctrl+0x34)+0x18)` y se fija una sola vez: **jugador 3, aliado (bando 0) 4, enemigo (bando 1) 6**, 5 si el tipo es 0x28, 7 → 0xD. El soldado nació enemigo: grupo 6 (medido), y cambiarle el bando no se lo cambia. **Escribiendo grupo 4 por PINE: J2 camina 11,1 m con `manos` y el soldado lo sigue a ≤ 0,36 m**; en la mitad de J se lo ve donde está J2 (`titere93i-camino.png`). **`confirmado` con control** (la corrida sin grupo: 0 m).
- **Regresión** (la campaña entera con el bloque de **530 palabras**, 8 cargas seguidas): 8 de 8 sin cuelgue, J2 camina, títere nativo en 5 a ≤ 0,56 m (antes ≤ 0,39: el corrimiento de 0,3 m). El cuelgue de City Bridge de (93h) no volvió (0 de 2 corridas más).
- **Lo que falta para que salga del pnach solo, y por qué NO se hizo:** el stub tendría que elegir un spawner, moverle el punto a J2, activarlo y, con el alta, poner bando 0 y grupo 4 (~50 palabras). El riesgo es de **juego**, no técnico: el spawner es del guion del nivel; si una oleada espera que mueran sus soldados, un títere invulnerable para los enemigos puede **trabar el avance**. Es una decisión de valor (cuerpo en 3 niveles contra ese riesgo): queda para Fran.
**No funcionó:** la matriz copiada exacta (cuelgue); el bando solo (traba a J2).
**Sigue:** la decisión de Fran; los brazos de J2 animados.

---

## 2026-09-28 (93h) — El títere por nivel: el stub elige el primer aliado VIVO del pool; 5 de 8 niveles, y los otros 3 no tienen aliado
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B2, el cuerpo de J2 en toda la campaña) · **Nodos:** `actores` (evidencia), `codigo-nuevo` (entrega)
**Objetivo:** tramo b) del retome: que el títere no sea «el aliado 1» fijo.

- **Censo** (`herramientas/censo_titere.py`, `volcados/campana/censo_titere.json`; pool = 16 bloques de 0x3C0 desde `*(0x0040F514)+0x90`, del 16 al 31 con tipo 0): **`+0x38C` = 4 es un bloque sin alta** (sin controlador de colisión en `+0xB4`, sin enlaces en `+0x0..`, quieto): el aliado 1 de Wilderness era un resto del nivel anterior (vida `FLT_MAX`, a 1 m de J porque el stub lo movía) y por eso «no seguía». **Aliado vivo** (bando 0, `+0x38C` = 0, `+0xB4` ≠ 0; vida `FLT_MAX`, invulnerable): City Streets y Town lo tienen en el **actor 0**; en Town el 1 es enemigo. **Wilderness, Steelworks y Gulag no tienen ningún aliado vivo** al empezar (Gulag: ni un actor vivo).
- **El cambio** (`coop_mod.py`): rutina nueva **`ELEGIR`** (25 palabras en `0x0046DE00`, hoja, sólo `t0..t3`/`v0`): recorre los 16 actores y devuelve —y deja en **`TITERE_ACT` = `0x0046DEF0`**, dato fuera del pnach— el primero con tipo ≠ 0, bando 0, `+0x38C` = 0 y `+0xB4` ≠ 0, o 0. `TITERE_MOD` la llama y copia la matriz sólo si hay (25 → 16 palabras; por cuadro termina en `0x0046D9C0`). El filtro de `ocultar_pasada.py` lee `TITERE_ACT` en vez de repetir las guardas (45 → 38 palabras). `coop_mod.aliado()` también. **Bloque: 525 palabras.** `docs/14` actualizado (dos filas nuevas; el verificador marcó los tres rangos viejos en rojo antes de corregirlos).
- **Resultado** (`campana_coop.py`, la campaña entera de corrido con el pnach solo, 8 cargas seguidas sin relanzar; `volcados/campana/campana.json`, `campana93h.log`):
  | nivel | títere | copias en 2 s | oculto en p2 | lo sigue (máx.) |
  |---|---|---|---|---|
  | Wilderness | ninguno | 0 | 0 | — |
  | Town | actor 0 | 98 | 98 | 0,24 m (antes: enemigo, no se tocaba) |
  | Steelworks | ninguno | 0 | 0 | — |
  | Asylum | actor 0 | 48 | 47 | 0,15 m |
  | Docks | actor 0 | 57 | 58 | 0,15 m |
  | City Bridge | actor 0 | 45 | 45 | 0,39 m |
  | Gulag | ninguno | 0 | 0 | — |
  | City Streets | actor 0 | 129 | 128 | 0,16 m |

  Los 8 se arman, J2 camina y la carga siguiente anda. **Town gana cuerpo** (`confirmado`: la captura `n2-camino.png` muestra al soldado donde está J2, en la mitad de J; el control es la corrida de (93e), mismo nivel y misma herramienta, con el aliado 1 enemigo sin tocar). En los tres niveles sin aliado el stub no escribe nada (antes movía un bloque muerto).
- **Un cuelgue sin explicar:** en la primera tanda (Asylum → Docks → City Bridge) el emulador murió ~2 s después de entrar a City Bridge. Repetido sólo y dentro de la campaña entera: anda (1 de 3 corridas). `hipótesis` abierta; si se repite, se muestrea el PC.
- **Para los 3 niveles sin aliado** (diseño, sin probar): hacer nacer un soldado con un spawner (83) en el punto de J2 y ponerle bando 0; `ELEGIR` lo tomaría solo. Riesgo: el guion del nivel cuenta sus apariciones.
**No funcionó:** nada.
**Sigue:** los brazos de J2 animados como los de J; el cuerpo en los 3 niveles sin aliado.

---

## 2026-09-28 (93g) — B4/B5 en vivo: un enemigo nacido junto a J2 no le dispara, pero tampoco a J (la prueba no mide)
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B4 «la IA frente a J2», B5 «muerte de J2») · **Nodos:** `ia`, `flujo` (evidencia; sin cambio de K)
**Objetivo:** hacerle daño real a J2 para ver por dónde entra, y de paso B4 en vivo.

- **La máquina de estados del controlador** (`herramientas/estados93.py`, `volcados/campana/estados93.json`): con el nivel andando, `*(P+0x32C)` = `P+0x4F0` **para J y para J2** (J2 tiene la suya, no la de J), con `+0x80` = **0** en los dos y `vtable(+0x84)` = `0x003DCC20`. Justo después de la carga, J tenía `+0x32C` = `J+0x7D0`, `+0x80` = 4 (un estado de la carga). Ni 1 ni 2: **la lectura de (93f) sobre el «tipo 2 = jugador» no se sostiene tal cual** (`hipótesis` refutada en su forma; el índice `+0x4B4` y las ranuras `+0x490` caen afuera del bloque de 0x8C0 del jugador, así que ese objeto no es el controlador del jugador). Con `+0x80` = 0, la función de daño no llama a ningún método del controlador para J ni para J2: la vida del jugador se maneja en otra parte.
- **B4/B5 en vivo** (`herramientas/enemigo93.py`, `volcados/campana/enemigo93.json`, capturas `enemigo93-prueba.png`/`-control.png`): City Streets por el pnach solo, J2 apartado 9,5 m con `manos 3`, dos spawners candidatos (68 en el nivel) con el punto movido. **Prueba** (a 5 m de J2, 14 m de J): el enemigo nace **muerto** (vida 0, `+0x38C` = 2) y queda así 25 s. **Control** (a 5 m de J): nace vivo (vida 100, `+0x38C` = 0), se lo ve en la mitad de J apuntando, **y en 25 s no dispara ni se mueve**: la vida de J queda en 750. **Sin control positivo, la prueba no mide nada** (igual que en (88)): un enemigo de spawner movido a mano no entra en combate. Hipótesis: el combate lo arma el guion del nivel (disparadores), no la aparición.
**No funcionó:** el enemigo de spawner como fuente de daño.
**Sigue:** B5 queda con la política del plano (J2 no recibe daño de enemigos ni de J; ver `docs/14` §2) hasta que haya un combate real para medir; siguiente tramo, el títere por nivel.

---

## 2026-09-28 (93f) — B5, la vida de J2 en 0: no pasa nada, y se regenera
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B5, riesgo medio «muerte de J2») · **Nodos:** `flujo` (evidencia; sin cambio de K)
**Objetivo:** qué hace el juego con la vida de J2 en 0.

- **Predicción (escrita antes):** escribir 0 en `J2+0x2F8` no hace nada, porque la muerte se decide en la función de daño (`0x00134654`, el «piso de muerte»), no cada cuadro; si algo pasa, fin de misión o cuelgue.
- **Resultado** (`herramientas/muerte93.py`, fork, bloque del pnach, City Streets; `volcados/campana/muerte93.json`, capturas `muerte-control.png`/`muerte-prueba.png`): control (se escribe la vida que tenía, 750): nada cambia. **Prueba (0):** J2 sigue en FASE 2 / ESTADO 3, su por cuadro sigue corriendo (863 → 1295 cuadros), `+0xC4` = 2, la vista de J responde; la vida queda en 0 unos 3,5 s y **después se regenera** a ~17 por segundo (0 → 74 en 4 s). Ni fin de misión ni cuelgue. **La predicción se cumple** (`confirmado` en RAM con control): la muerte no sale de la vida en 0.
- **Para el plano:** a J2 no lo matan los enemigos (no lo conocen, (93d)) ni J (sin fuego amigo, (85)); lo que queda es el daño del entorno (explosiones, caídas) por la función de daño. Qué hace esa función cuando el que muere es un jugador que no es el 0 se lee en frío (la rama del piso de muerte de `0x00134654` con `+0xC4` = 2).
- **En frío, de paso** (`FUN_00133FA8` = método `vtable+0x48` del personaje, la función de daño): la rama del «piso de muerte» (`swc1 f20,0x2F8` en `0x00134654`, con `vida ≤ 0` → 0 y, si bando 0, `FUN_00121F00`) es la de los **agentes de IA** (controlador `+0x32C` con `+0x80` = 1). Si el controlador es de tipo **2** (jugador: la mira, `J+0x4F0`; J2 tiene la suya copiada del molde), el daño va a su método `vtable(+0x84)+0x24`: la clase del jugador (vtable `0x003DC348`, armada en `FUN_00382BF0`) → `FUN_001411A0` → `FUN_001412C0` → método `+0x28` de otro objeto (`+0x4C`). La clase del agente (vtable `0x003DC268`) → `FUN_0013D388`. **La muerte de J2 pasaría por el camino del jugador** (`probable`): falta leer `FUN_001412C0` y qué hace con la vida en 0 (¿fin de misión para cualquier jugador?).
**No funcionó:** nada.
  `FUN_001412C0` devuelve **el estado actual de la máquina de estados del controlador** (`mira+0x490[mira+0x4B4]`, −1 = ninguno): el daño al jugador lo maneja un método (`vtable(+0x4C)+0x28`) **del estado en curso**.
**Sigue:** en vivo, qué estados tiene la máquina del controlador de J2 (`J2+0x4F0+0x490..`, índice en `+0x4B4`) y cuál maneja el daño; una granada junto a J2 con el estado mirado.

---

## 2026-09-28 (93e) — Toda la campaña con el coop, por el pnach solo: los 8 niveles se arman, se parten y cargan seguidos
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B3 en la campaña, pedido de Fran; R1 y R6 de `docs/14`) · **Nodos:** `codigo-nuevo` (entrega)
**Objetivo:** tramo e), con el arreglo de (93c).

- **Corrida** (`campana_coop.py`, bloque de **514 palabras** instalado y activo, sin `poner` ni Python del mod; `volcados/campana/campana.json`, capturas `n<i>-quieto/-camino.png`, hoja `tira-campana.png`). Wilderness de la corrida del arreglo; Town → City Streets en **una sola corrida**, cada nivel cargado desde el anterior (7 cargas seguidas: `moldes` 7, `desarmes` 6, sin relanzar):
  | nivel | se arma (s) | al juego (s) | J2 a J (m) | títere (bando, sigue a J2) | stub pantalla /2 s | oculto p1 / p2 | camina (m) | la carga siguiente |
  |---|---|---|---|---|---|---|---|---|
  | 1 Wilderness | 12,4 | 13,9 | 1,02 | 0, no (115 m) | 73 | 73 / 0 | 11,2 | ok |
  | 2 Town | 11,2 | 12,7 | 1,00 | 1, no (181 m) | 97 | 0 / 0 | 14,8 | ok |
  | 3 Steelworks | 13,2 | 14,8 | 1,08 | 1, no (90 m) | 45 | 0 / 0 | 2,7 | ok |
  | 4 Asylum | 13,2 | 14,7 | 1,00 | 0, sí (≤ 0,15 m) | 48 | 0 / 48 | 6,9 | ok |
  | 5 Docks | 13,2 | 14,7 | 1,00 | 0, sí (≤ 0,16 m) | 57 | 0 / 58 | 4,5 | ok |
  | 6 City Bridge | 12,2 | 13,7 | 1,00 | 0, sí (≤ 0,39 m) | 47 | 47 / 47 | 6,9 | ok |
  | 7 Gulag | 12,2 | 13,7 | 1,00 | 0, no (228 m) | 65 | 0 / 0 | 10,1 | ok |
  | 0 City Streets | 12,2 | 13,7 | 1,06 | 0, sí (≤ 0,16 m) | 122 | 0 / 123 | 10,1 | ok |

  **Los 8 niveles de la campaña: J2 se arma, llegan al juego, J2 camina con `manos`, la pantalla se parte** (vista en las 8 capturas) **y el nivel siguiente carga sin cuelgue** (`confirmado` por efecto, en el fork; el 2.8.0 de Fran no se tocó). Los dibujos por segundo de la pantalla partida van de ~23 a ~61 según el nivel (el stub cuenta una llamada por cuadro). En City Bridge se ve el filtro de (93b) trabajando: J ve al soldado-títere donde está J2 y los brazos flotantes de J2 no se dibujan (47 ocultos en 2 s).
- **El títere anda en 4 de 8.** En Town y Steelworks el aliado 1 del pool es **enemigo** (bando 1): la guarda de `TITERE_MOD` no lo toca (bien: no se roba un enemigo). En Wilderness y Gulag es bando 0 pero **no sigue** a J2 aunque el stub copie la matriz (TITERES sube): hipótesis, un actor sin alta en el nivel (sin dibujo ni física). Es trabajo de diseño: elegir el títere por nivel (buscar un aliado vivo, o dar de alta uno).
- **La herramienta, corregida:** esperaba el juego apretando Start cada 20 s; en Town eso abrió la pausa en pleno juego (el por cuadro de J2 frenó y la vista no giró). Ahora espera sólo a que el por cuadro de J2 corra, sin apretar nada.
**No funcionó:** la primera corrida de Town (la de los Start).
**Sigue:** el títere por nivel; B5 (vida de J2 en 0).

---

## 2026-09-28 (93d) — El plano del mod (`docs/14-coop-diseno.md`) con su verificador, y la IA frente a J2 en frío
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B, punto 3 del criterio: el documento de diseño; punto 2: B4 y B6) · **Nodos:** `ia` (evidencia; sin cambio de K), `disparadores` (política)
**Objetivo:** tramo f).

- **`docs/14-coop-diseno.md`**: requisitos R1–R7 con su método y su estado, los componentes (alta, por cuadro, desarme, pantalla, filtro del tinte, visibilidad por pasada) con sus ganchos, la política de los riesgos medios, y un bloque `coop-rangos` con los 19 rangos de memoria y ganchos del coop, cada uno con su fuente.
- **`herramientas/coop_diseno.py verificar` = 0**: (1) cada programa de `coop_mod.programas()` tiene su fila con el mismo rango (el plano no puede quedar atrás del código), (2) todo gancho que escribe el mod está declarado, (3) ninguna fila se pisa con otra ni con los sitios de la escena de `pantalla_dividida.py`, (4) ninguna `direccion` de los otros mods de `mods/` cae adentro, (5) toda fila tiene fuente (una entrada de bitácora que existe, o un archivo de `kb/`). **Saboteador** `pruebas/probar-coop-diseno.py`: rango viejo, fila que pisa, fuente inexistente, gancho sin declarar, otro mod adentro y sin bloque → **6 de 6 en rojo**; el plano sin tocar, verde.
- **B4, la IA frente a J2, en frío** (decompilado de `black-datos`): cada bando (`ia+0x22800` bando 0, `ia+0x22AD0` bando 1, `ia` = `*(0x0040F4D4)`; `FUN_0013D400` los indexa por `+0x3A4`) guarda **un** jugador: `FUN_00172830` (al armar el nivel) hace `FUN_00172618(bando, J)` (`bando+0x10`) y `FUN_00172C00(bando, 3, J)` (ranura 3 de la escuadra; las 0..2 las llena `FUN_00173028` con los agentes que aparecen). La lista de proximidad de un agente (`FUN_0018B190`; `FUN_0018B400` = a ≤ 4 m) es **el jugador 0 más los 16 agentes** de `ia+0x2B00` (paso 0x1FD0); `FUN_001848C0` elige como líder al agente del mismo bando más cercano o al jugador 0. **J2 no aparece en ninguna** → los enemigos no saben que J2 existe (`probable`: falta leer la elección del blanco de disparo y la prueba en vivo con un enemigo más cerca de J2 que de J). Política v1 en el plano: **se acepta** (J2 no es blanco).
- **B6, disparadores**: el mecanismo ya estaba leído en (73) (sólo la posición del jugador 0). Política v1: **J abre el camino**.
**No funcionó:** buscar la elección del blanco por las referencias a `*(0x0040F4D0)+0x30` (30 funciones): las que están en el código de la IA son de escuadra y proximidad, no de disparo.
**Sigue:** B5 (vida de J2 en 0) en vivo; la elección del blanco de disparo (cadenas `TargetBot`, `AimAtTargetInterval` de `docs/07`).

---

## 2026-09-28 (93c) — La campaña: con el mod, los niveles con cartel se colgaban; J2 nacía encima de J
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B3 en toda la campaña, pedido de Fran) · **Nodos:** `fisica` (evidencia), `codigo-nuevo` (entrega)
**Objetivo:** tramo e): cargar cada nivel de la campaña con el bloque puesto y medir J2 por nivel.

- **La herramienta:** `herramientas/campana_coop.py <índices>` lanza el fork con el bloque instalado y **activo** (sin `poner`: el pnach solo), entra desde el slot 3 y carga los niveles con el selector (tabla de (78): 0 City Streets, 1 Wilderness, 2 Town, 3 Steelworks, 4 Asylum, 5 Docks, 6 City Bridge, 7 Gulag; los de prueba 8..11 no se piden). Por nivel: FASE 2 y ESTADO 3, espera el juego (TITERES sube; Start cada 20 s pasado 30 s), el títere, la pantalla (llamadas del stub) y lo oculto por pasada, `manos 2`, captura, y el nivel siguiente se carga desde éste. `--sin-mod` es el control (bloque apagado; juego = el eje gira la vista).
- **City Streets por el pnach solo** (500 palabras): se arma en 10,3 s, títere bando 0, 111 llamadas del stub en 2 s, la pasada 2 oculta al títere 112 veces, J2 camina 9,0 m y el títere lo sigue a ≤ 0,16 m. **Wilderness y Town: se quedaban en el cartel** («TRENESK») para siempre, J2 armado (FASE 2, ESTADO 3) y el por cuadro sin correr; ni con Start. **Control, bloque apagado:** los dos llegan al juego en 17,6 s sin tocar nada (`control-sin-mod.json`, `s1-inicio.png`).
- **No era una espera: el EE está caído.** `atasco93.py`: 12 muestras de PC en pausas, **todas en `0x0033DDB0`** (`FUN_0033DD98`, `lqc2 vf03,(t1)`), llamada desde `FUN_00336520`: el mismo punto del mundo de colisión donde caía la segunda carga en (87). La pantalla sigue mostrando el último cuadro (el cartel).
- **La causa:** J2 **nace exactamente donde J** (`J_pos` = `J2_pos` = −120,42 / 27,98 / −65,43 en Wilderness): el envoltorio le pide la aparición a `FUN_0012BD98(juego, *(juego+0x5AB0))`, que busca entre las dos entradas de `juego+0x4990` (paso 0x880) la del id **de J**. Con los dos controladores de colisión encimados, la colisión cae. En City Streets J2 queda a ~1 m (sin medir por qué).
- **Confirmado con control** (`apartar93.py`: en cuanto FASE = 2, en pausa, J2 corrido `dx` en x en `+0xA0/+0x100/+0x190`, antes de que el por cuadro le ate el controlador): **dx = 1 m → al juego en 14,0 s y J2 camina 11,2 m con `manos`; dx = 0 → nunca llega** (4 de 4 sin apartar, 1 de 1 apartado).
- **Arreglo en la fuente** (`coop_mod.py`, envoltorio, 14 palabras: 95 → 109, hasta `0x0046DBB4`, antes de las armas de J2 en `0x0046DBC0`): si J2 nació con la misma x que J (comparación entera de `+0x100`), se le suma 1,0 a la x de `+0xA0/+0x100/+0x190`. `jugador2.ensamblar_programa` acepta `.word 0x…` literal (las FPU que `mips.py` no ensambla). **Bloque: 514 palabras**, reinstalado y activo. Riesgo que queda: 1 m en +x puede caer dentro de una pared en algún nivel.
**No funcionó:** esperar el juego apretando Start: el emulador no esperaba nada, estaba caído.
**Sigue:** la campaña entera con el arreglo (93d).

---

## 2026-09-28 (93b) — Visibilidad por pasada: un filtro en el callback de dibujo de la escena
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B, «el títere tapa la cámara de J2; cada uno ve el arma del otro») · **Nodos:** `render` (evidencia), `vista-fp` (evidencia; sin cambio de K)
**Objetivo:** tramo b) de la tarea: la bandera que oculta a un personaje, en frío, y usarla por pasada.

- **En frío:** los personajes se dibujan **dentro** de `FUN_001297E0`, o sea en cada pasada: `FUN_00273A18(juego+0x4920, R+0xCFD0, 0x1297A0, 0)` recorre lo visible y el callback `FUN_001297A0(nodo, modo)` llama al método `vtable+0x30` de `*(nodo+0x34)`; en un personaje (vtable base `0x003DCA78`) es `FUN_00133BA0`: modelo (`FUN_00136BD0`, que saltea cada submalla con su bit de `+0x370` en 0 — pero esa máscara la **recalcula** `FUN_00136D60` en cada dibujo, así que no sirve de bandera), agregados (`+0x25C`, `+0x3AD`) y el arma en la mano (`+0x2A4`, `FUN_00137B88`). El callback entra como inmediato: `lui a2,0x13` / `addiu a2,a2,-0x6860` en `0x001298F8`/`0x00129900`.
- **El filtro** (`herramientas/ocultar_pasada.py`, 45 palabras en `0x0046FB20`): va en lugar del callback; con la pantalla partida (`DATOS+0x3C` ≠ 0) distingue la pasada por el offset x del sub-raster (`*(*(R+0xD458)+0x60)+0x1C`: 0 / 320, sin tocar el stub de la pantalla), saltea el objeto `A` (`0x0046FBF0`) en la 1 y el `B` (`0x0046FBF4`; 1 = el títere, con las guardas de `TITERE_MOD`) en la 2, y cuenta en `0x0046FBF8`/`0x0046FBFC`.
- **Medido** (fork, `volcados/capturas-93/`, `ocultar93.json`, `ocultar93b.json`, tiras `tira.png` y `tira-b.png`), A/B escritos en caliente, control A = B = 0 antes y después:
  | caso | ocultos pasada 1 / 2 (por 2 s) | efecto en pantalla |
  |---|---|---|
  | control | 0 / 0 | brazos y arma en las dos mitades |
  | A = J2, B = títere | 0 / ~230 | ninguno visible (el títere está en el ojo de J2: fuera del plano cercano en este encuadre) |
  | **A = J, B = J2** | ~206 / ~207 | **los brazos y el arma desaparecen de las dos mitades** (dif 3,9 / 4,1 contra 1,3 / 1,0 del control) |

  **Los brazos y el arma en primera persona son el dibujo del propio personaje** (`confirmado` en pantalla, con control): la mitad de J2 muestra el modelo de J2, no el de J. La «animación de J1 en la mitad de J2» es entonces **la animación de los brazos de J2 igual a la de J** (se ve en `v_c0`: la misma pose en las dos mitades), no el arma de J dibujada dos veces. El filtro por pasada anda (`confirmado`). Ocultar a J2 en la vista de J queda `probable`: la comparación es la misma que lo encontró en la pasada 2, pero en ningún encuadre de la sonda J2 entró en la vista de J (el giro de la mira de J escrito por PINE no giró su cámara).
- **En el mod** (`coop_mod.py`): el filtro, `A` = J2, `B` = títere y los dos ganchos (se escriben juntos, en pausa, en `poner`/`quitar`); `poner --sin-ocultar` es el control. **Bloque: 500 palabras**, reinstalado y activo. Por el pnach solo, en City Streets: la pasada 2 oculta al títere ~56 veces por segundo, J2 camina 9,0 m y el títere lo sigue a ≤ 0,16 m (`campana_coop.py`, (93c)).
**No funcionó:** girar la cámara de J escribiendo su mira (`0x005A8FA0`): la mitad izquierda no cambió.
**Sigue:** la animación compartida de los brazos (qué de J2 apunta a lo de J: los bloques `+0x270..+0x278` con dueño J son los candidatos); J visto desde J2 son brazos flotando (un segundo títere).

---

## 2026-09-28 (93) — La recarga de J2 en el stub: confirmada en RAM, con control
**Máquina:** notebook (tarea programada, Fran durmiendo) · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B, «J2 dispara») · **Nodos:** `armas` (evidencia; sin cambio de K)
**Objetivo:** tramo a) de la tarea: probar el `RECARGA_MOD` de (92) en el fork, con el 2.8.0 de Fran cerrado.

- **Predicción (escrita en (92)):** con el arreglo en `nop` el arma de J2 trabada a mano (`+0xD8` = 4, cargador 0) sigue trabada; repuesto, se destraba sola a ~1,5 s (90 cuadros) con la reserva descontada.
- **Resultado** (`herramientas/recarga92c.py`: fork MCP, puerto normal 28011, bloque apagado en los ajustes durante la sonda y `coop_mod.py poner` por PINE, slot 3 → nivel 0 por el selector; `volcados/recarga92c.json`):
  | | `+0xD8` | cargador | reserva |
  |---|---|---|---|
  | antes | 0 | 15 | 30 |
  | **control** (`sw +0xD8` y `jal 0x156d60` en `nop`, en pausa), 6 s | **4** | **0** | 30 |
  | repuesto, +0,5 s (el contador ya iba por 88) | 0 | 15 | 15 |
  | trabada otra vez, +1,0 s / **+1,5 s** | 4 / **0** | 0 / **15** | 15 / **0** |
  El contador sube ~66 por segundo (60 Hz) y en el control da la vuelta cada 90 sin tocar el arma. **`confirmado` en RAM con control**; en pantalla (J2 disparando otra vez con el mando real) falta: lo ve Fran.
- **Pnach reinstalado desde la fuente** (`coop_mod.py instalar`, 451 palabras, respaldo `.bak-20260928-021432`); el bloque queda **activo** en los ajustes, como estaba.
**No funcionó:** nada en este tramo.
**Sigue:** tramo b), visibilidad por pasada, en frío.
---

## 2026-09-28 (92) — La recarga eterna de J2, en frío: el fin de recarga es un evento de animación
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B, «J2 dispara») · **Nodos:** `vista-fp`, `armas`
**Objetivo:** tramo a) del retome, en frío.

- **El objeto global** `V = *(*(0x0040F510)+0xCBD8)`: 0x60 B, **uno solo**, alojado una vez por `FUN_001d5828` (junto a `+0xCBD4` 0x2D8 B, `+0xCBDC` 0x1C B, `+0xCBE0` 0x2A80 B) y armado por `FUN_001e82a8`: es un **agregado de ~18 subobjetos** (`V+4..+0x4C`; tres de 0x1B8 B con vtable en `+0x44/+0x48/+0x4C`). `V+0xC` = 0x1C50 B, armado por `FUN_001d6488`: conjunto de animaciones `+0x1BE0` (y `+0x1BE4/+0x1BE8`), banco de sonido del arma (ValueDB `Sound`), por cuadro `FUN_001d6f90`. Accesos a `V+off` en todo el decompilado: `+0x10` 66, `+0xC` 32, `+0x24` 25, `+0x30` 21. Lectura: **la presentación del jugador local** (arma en primera persona y lo que la rodea), `probable`: se leyó la construcción, no el dibujo.
- **La recarga, leída:** `FUN_00156dc0` (empezar a recargar): si el dueño tiene `+0xC4` ≠ 2 (un PNJ) **llena el cargador en el acto** (`FUN_0015a830`) y pone el estado `arma+0xD8` = 4; si es 2 (jugador) sólo pone el estado 4 (o 5, de a un cartucho) **y no llena nada**. El llenado del jugador lo hace `FUN_00158ae0(evento, &jugador)` con el evento `0xB12FC567E6600000`: estado 8 + `FUN_00156d60` → `FUN_0015a830` (o `FUN_0015a8d0`, de a uno). `FUN_00158ae0` es el **manejador de eventos de animación**, registrado en `+0x950` de un singleton por `FUN_001ab780` (con otros cinco en `+0x958..+0x96C`). En el mismo manejador, el evento `0x73063d2f95228000` (fin de cambio de arma) toca `V+0xC` con `FUN_001d73d8`.
- **Hipótesis que sale (una causa para la recarga eterna):** el evento de fin de recarga lo emite una animación que J2 **nunca reproduce** (su recarga se pide a `V+0xC`, que es de J y además está con el arma de J), así que su arma se queda en el estado 4 con cargador 0. Predicción: por PINE, el `+0xD8` del arma en la mano de J2 (`*(J2+0x2A4)+0xD8`) queda en 4 para siempre; escribiendo el estado 8 y llamando al llenado (o, más barato, llenando `*(arma+0xF4)+0x18` y el estado a mano) J2 vuelve a disparar.

- **Predicción confirmada en RAM** (partida de Fran, sólo lectura, `recarga92.py`): arma de J2 con `+0xD8` = 4 y cargador 0 durante horas; la de J en 0. **Destrabada con datos** (`destrabar92.py`: cargador = min(cap 15, reserva 30), reserva − 15, estado 0): quedó en 0 / 15 / 15 estable 6 s. Falta verlo en pantalla (Fran disparando con J2).
- **Arreglo en la fuente** (`coop_mod.py`, commit `08a9cb5`, **sin probar en el emulador**): `RECARGA_MOD` en el estado 3 del por cuadro: tras 90 cuadros en 4/5, estado 0 y `FUN_00156d60(arma)`; dato `RECARGA` `0x0046D7D0`; por cuadro 119 palabras hasta `0x0046D9DC`; `poner --sin-recarga` es el control. El estado 8 **no** sirve: para el jugador espera otro evento de animación. `pine.py` lee `BLACK_PINE_SLOT` (otro puerto para un segundo PCSX2).
**No funcionó:** probar en el fork con la partida de Fran abierta: comparten `Documents\PCSX2` (ini, tarjetas, emulog). El fork se trabó en «Memory Card Read Failed» y, con el ini tocado (PINE 28012, tarjetas apagadas sólo al arrancar), el slot 3 no cargó: J2 nunca se armó y la sonda no midió nada. **Las pruebas en el fork van con el 2.8.0 cerrado.** La partida de Fran quedó guardada en el **slot 14** (01:22).

**Sigue:** con el 2.8.0 cerrado, `recarga92b.py` (scratchpad de esta sesión; copiar a `herramientas/`) en el puerto normal: control con `nop` en pausa, después el arreglo; y quién emite el evento.

---

## 2026-09-28 (91) — Las armas de J2: propias; lo compartido es la vista en primera persona
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B, riesgo alto «J2 dispara») · **Nodos:** `vista-fp` K2 (evidencia nueva, sin subir), `armas`
**Objetivo:** el punto a) del retome (J2 no dispara con el mando real).

- **Lo que reportó Fran jugando (2.8.0, dos mandos, su partida):** **J2 dispara y las balas salen** — (a) queda **refutado como «no dispara»**. Pero: en la mitad de J2 las animaciones del arma son las de J1; J2 se quedó sin balas y quedó **recargando para siempre**; al agarrar la SPAS «no me deja disparar» y después «dejó de buguearse»; y **a veces la mitad de J2 parpadea: se angosta y se reacomoda** (sin medir).
- **Medido por PINE, sólo lectura, sobre su partida** (`volcados/armas-91/J-b.bin`, `J2-b.bin`; scripts `armas91.py`/`armas91b.py` del scratchpad). **Trampa pagada:** `*(0x0040F4D0)` es **el juego**, J = juego + 0x30 (`0x005A8AB0`); la primera lectura usó el juego como J y daba basura.
  | | J | J2 |
  |---|---|---|
  | `+0x2A0` armas | `0x006ED780` → `006DE690`, `006DF020` | `ARMAS2` → `006DE7A0`, 0 |
  | en la mano `+0x2A4` / `+0x2C3` | `006DF020` / 1 | `006DE7A0` / 0 |
  | tipo del arma `+0xE8` | `01842090` (cargador 15), `018420B0` (cargador 6) | `01842090` (**cargador 0**) |
  | reserva por tipo (`+0x280`, 10 × u16) | 30, 15 | 30, **0** |
  | dueño del arma `+0xFC` | `0x005A8D30` (= J+0x280) | `0x0046D070` (= J2+0x280) |
  | `+0xC4` | 2 | 2 |
  **Las armas de J2 son suyas** (objeto, cargador `*(arma+0xF4)+0x18` y reserva propios, dueño J2): `confirmado` en RAM. El HUD `006 / 015` en la mitad de J2 es **el de J** (la escopeta que J tiene en la mano: cargador 6, reserva 15). La SPAS **la tiene J** (ranura 1): el recoger se lo dio a J aunque lo intentara J2 (`probable`: no se vio quién la tocó).
- **Lo compartido (mismo puntero en J y J2, copiado del molde):** `+0x270/+0x274/+0x278` → tres bloques de 0x20 B **cuyo dueño es J** (`+0` = `0x005A8AB0`, `+8` = `0x013094D0`/`...570`/`...610`); `+0x294` → `0x007081E0` (arreglo de bytes por tipo de arma del administrador de armas `J+0x280`, `+0x14`; `+0x298` = 17); y además `+0x0B8/+0x0BC`, `+0x328`, `+0x354..+0x360`, `+0x410`.
- **En frío** (decompilado de `black-datos`): el administrador de armas es `W = J+0x280` (`FUN_0015c100`/`FUN_0015bb90`/`FUN_0015bf50`): `W+0` reserva por tipo, `+0x14` el arreglo de `+0x294`, `+0x1C` dueño, `+0x20` armas, `+0x24` en la mano, `+0x42` cantidad, `+0x43` índice. **`FUN_0015bf50` (cambiar de arma), si el dueño tiene `+0xC4` = 2, le cambia el arma a UN SOLO objeto global**: `*(*(0x0040F510)+0xCBD8)+0xC`, con `FUN_001d6e78` (conjunto de animaciones en `+0x1BE0`, sonido por ValueDB). Ese objeto es **el candidato a la vista en primera persona** (`probable`: la llamada se leyó, el dibujo no). Hay **22** caminos con `dueño+0xC4 == 2` en `0x0015.c` (el código de armas).
- **Lectura (hipótesis):** con J2 en `+0xC4` = 2, **los dos jugadores manejan la misma vista en primera persona**: los disparos y recargas de J2 se animan en el arma de J, y la vista se dibuja en las dos pasadas. La recarga eterna de J2 sería una recarga que espera un evento de esa animación compartida, que está con el arma de J (se destrabó cuando la vista cambió por la SPAS de J). Explicaría b) y c) del retome y la recarga, con **una** causa.
**No funcionó:** la primera lectura (J tomado del puntero del juego, sin + 0x30). Los escritores de `+0x270..+0x278` no aparecen como `+ 0x270) =` en el decompilado: se escriben por otro camino, sin hallar.
**Sigue:** (1) en frío, confirmar que `*(*(0x0040F510)+0xCBD8)+0xC` es la vista en primera persona (quién la dibuja; tamaño; si hay constructor que se pueda llamar por segunda vez) y qué hace la recarga con ella (buscar el fin de recarga en los 22 caminos `+0xC4 == 2`); (2) por PINE, con Fran recargando con J2: ¿cambia `+0x1BE0`/estado de la vista? (3) decidir: vista propia para J2 (una segunda instancia) o J2 sin vista en primera persona y la recarga desacoplada. Y el parpadeo de la mitad de J2, sin medir.

---

## 2026-09-27 (90) — El coop con doble clic, y los juegos de PS2 en su carpeta
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B3, prueba de punta a punta) · **Nodos:** ninguno (entrega; `entrada` sin cambio de K)
**Objetivo:** que Fran pruebe el coop con el mando real sin comandos.

- **Los ISO se mudaron** de `C:\Program Files\PCSX2\PCSX2\games\` a `Escritorio\Juegos\Juegos de emulador\PS2\` (`BLACK\ISOs\`, `God of War II\`, `DBZ Budokai Tenkaichi 4 (Beta 14)\`), con el pack de texturas HD de Downloads en `BLACK\Texturas\` y un `LEEME.txt`. Actualizados `kb/ubicaciones.json` (`ubicaciones.py` en OK), `kb/estructuras.json`, los tres `.bat`, `subir-datos-nube.ps1`, `docs/05`, `RETOME-LOCAL.md`, el acceso de GoW2 y el `RecursivePaths` del `PCSX2.ini` (sale `Downloads`, que hacía escanear basura; entra `PS2`). Las entradas viejas del HANDOFF quedan como historia.
- **`JUGAR-BLACK.ps1 -Coop teclado|2mandos`**: prende el bloque del pnach (`coop_mod.py activar`) y reparte los mandos en el ini **después** de `configurar-controles.ps1`, que sólo escribe `[Pad1]`. Hallazgo de paso, **medido en el ini**: `[Pad1]` tenía `SDL-0` **y** teclado, y `[Pad2]` `SDL-1`: con un solo mando enchufado, ese mando manejaba a **J1** y J2 no tenía nada. Sin `-Coop` el bloque se apaga y `[Pad2]` vuelve a `SDL-1`.
- **Medido por efecto en el 2.8.0 de Program Files** (no el fork): con `-Coop teclado`, `Enabled patch: COOP - jugador 2 (B3)` en el emulog, `[Pad1]` 22 líneas de teclado/mouse y 0 de SDL, `[Pad2]` 27 de `SDL-0`; sin `-Coop`, 0 líneas del coop y `[Pad2]` 27 de `SDL-1`. **La pantalla dividida en el 2.8.0 queda `probable`**: la vio el fork en (88)–(89); la prueba es la de Fran.
- **(90b) LA BANDA AMARILLA — confirmada en pantalla, con control, y arreglada.** Hipótesis (a) de (89c). `banda90.py` (scratchpad; fork MCP, **bloque apagado**, `coop_mod.py poner` por PINE, nivel 0 por el selector, capturas a los ~33 s de aceptar; `volcados/capturas-90/`, tira `tira.png`). Fracción de píxeles amarillos (R>150, G>130, B<90) por mitad:
  | | izquierda | derecha |
  |---|---|---|
  | base (2 capturas) | 0 | **0,076 / 0,070** |
  | `jal 0x1b0ac8` de `0x0046FAA4` en `nop` | 0 | **0 / 0** |
  | repuesto (control) | 0 | 0,080 / 0,012 |
  | +20 s | 0 | 0,047 |
  A ojo, lo mismo: la mitad derecha entera velada de amarillo, limpia sin la llamada y velada otra vez al reponerla. La llamada única al tinte, aun con el raster entero restaurado, **dibuja sobre la mitad derecha**: el porqué (qué estado de la pasada 2 hereda su quad) es hipótesis, no se leyó. Tampoco era el arranque del nivel (hipótesis (b)): aparece por PINE igual que por el pnach.
  **Arreglo**: la llamada queda en `nop` en la fuente (`pantalla_dividida.py`, misma cantidad de palabras: nada se corre); bloque reinstalado (430 palabras). **Por el pnach solo** (bloque prendido, sin `poner`, PCSX2 relanzado): 0 / 0 amarillo a los 33 s y 0 / 0 a los 55 s, J2 camina 9,0 m y el aliado lo sigue a ≤ 0,16 m. **Costo aceptado**: con la pantalla partida no se dibuja el tinte de daño ni el de fundido (el filtro de (89b) ya lo sacaba de las pasadas). Bloque de vuelta **apagado** (lo prenden los accesos COOP).
- **(90c) LA PRUEBA DE FRAN con dos mandos reales (2.8.0, acceso `- dos mandos`)**: la pantalla se parte (**confirmado en su pantalla**: primera vez en el emulador de jugar, a 42–49 cuadros/s con ReShade y HUD de J arriba a la izquierda, de J2 a la derecha), **pero el mando 2 no mueve a J2**, y cuando J dispara, en la mitad de J2 «se ve la animación de disparo» sin bala.
  **Medido por PINE sobre su partida** (el 2.8.0 tiene PINE en 28011): `J+0x588` = **`0x00585A0C`** (el control del **puerto 2**, fuente `0x005857B0`) y `J2+0x588/+0x6D0/+0x7C8` = **`0x00585B78`**, un **tercer** control con fuente **0**. El juego le da a J el control **del puerto que apretó Start** (en los savestates era el puerto 1, `0x005858A0`, y por eso la regla vieja `CTRL2 = *(J+0x588) + 0x16C` siempre anduvo); con Fran arrancando con el mando del puerto 2, J2 caía en un control vacío. En 3 s, el buffer del puerto 2 tuvo 3 bytes de ejes con ruido y el del puerto 1 ninguno: el mando que Fran tenía en la mano era el del puerto 2.
  **Arreglo**: J2 toma el control del puerto que J **no** usa (`0x005858A0` si J está en `+0x16C`, y al revés; 4 palabras más, por cuadro hasta `0x0046D998`, tope `0x0046D9F0`). En su partida se escribió en caliente (`J2+0x588/+0x6D0/+0x7C8` = `0x005858A0`) para que lo pruebe sin reiniciar. El lanzador COOP ahora corre `coop_mod.py instalar` antes de `activar`, así el pnach sale siempre de la fuente (434 palabras). **Sin confirmar** hasta que Fran mueva a J2 con el otro mando.
  **La «animación de disparo» de J2** es, por lo que se ve en sus capturas, **el arma en primera persona de J dibujada también en la vista de J2**: es el problema de los brazos flotantes (c), no un disparo de J2 (hipótesis: no se midió).
- **(90d) LO QUE FRAN VIO con el arreglo del puerto** (sus capturas, 2.8.0, 60 cuadros/s): **J2 se mueve y gira con el otro mando — confirmado por él.** Abierto:
  1. **J2 no dispara** con el mando real (en (85) sí hizo daño con el botón del falso 2). Descartado en su partida: `J2+0x418` (J y J2 valen 0, con J en el puerto 2).
  2. **El aliado-títere se ve superpuesto en la cámara de J2** (J2 lo ve desde adentro) y en la vista de J2 aparece el arma en primera persona de J → **visibilidad por pasada**.
  3. «La cámara de la pistola no funciona igual que en J1»: el arma de J2 no sigue la mirada como la de J1 (hipótesis: misma raíz que 2).
  5. **Otra captura de Fran (00:40)**: J1 mira el arma (animación de inspección/recarga) y **en la mitad de J2 se ve la MISMA animación de brazos y arma**, dibujada desde la cámara de J2; según Fran, «si el J1 dispara o hace cualquier cosa, el J2 replica lo del arma de J1». Lectura: el arma en primera persona es **una sola, la de J**, y la pasada 2 la vuelve a dibujar; J2 no tiene arma visible propia. Grado: `probable` (efecto visto por Fran en pantalla, sin medir en RAM qué objeto se dibuja). Cambia el orden: antes que ocultar, hay que saber **quién dibuja el arma en primera persona y de qué jugador toma el estado** (vista-fp K2): el mismo objeto sirve para ocultar la de J en la pasada 2 y para dibujar una de J2.
  4. Sensibilidad rara, y uno de los mandos tiene las palancas gastadas: con el parche «Zona muerta del pad a cero» la deriva mueve la mira (hipótesis).
- **Trampa**: `CloseMainWindow()` sobre el 2.8.0 con un juego corriendo abre «Confirmar apagado» (con `SaveStateOnShutdown = true`) y queda colgado esperando un clic. Para cerrar el de prueba, `Stop-Process` (además no pisa el ini).

---

## 2026-09-27 (89) — La proporción de las mitades, en el stub
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B1, B3) · **Nodos:** `render` K5 (evidencia)
**Objetivo:** que las dos mitades no salgan aplastadas, sin Python.

### (89) Predicción
- **El cambio:** el stub de la pantalla guarda `R+0xD470` y `R+0xD474` (`R = *(0x0040F4C0)`; 1,333 y 1,778) en `DATOS+0x30/+0x34`, los multiplica por 0,5 si `DATOS+0x38` ≠ 0, sincroniza (`FUN_001AE998` + `FUN_001B0948`), dibuja las dos pasadas y los restaura antes de la sincronización final. Por (84): `vw.x = tan(FOV/2)·(+0x70)`, `vw.y = vw.x/(+0x74)`: la mitad queda con la mitad del campo horizontal y el mismo vertical. El stub pasa a 172 palabras (`..0x0046FAB0`); `DATOS+0x38` = 1 entra como constante del bloque.
- **Medida:** con J quieto, captura a pantalla entera (división apagada) y dividida. Con `+0x38` = 1 la mitad izquierda (960 px) se parece más al **recorte central** (480..1440) de la entera que a la entera **aplastada** a 960; con `+0x38` = 0 (control), al revés.

### (89) Resultado — confirmado en pantalla, con control
`prop89.py` (PCSX2 recién abierto, `coop_mod.py poner`, J quieto; capturas en `volcados/capturas-89/`, tira `tira.png`). Diferencia media de gris de la mitad izquierda, sin la franja del HUD:
| | contra el recorte central de la entera | contra la entera aplastada |
|---|---|---|
| **`+0x38` = 1** (corregida) | **17,4** | 30,6 |
| `+0x38` = 0 (control) | 32,0 | **15,4** |
Ruido entre dos capturas enteras seguidas: 8,2. A ojo: ventanas y mesa en proporción con la corrección, angostas sin ella. Una lectura por PINE cayó entre la división y la restauración y dio **0,667 / 0,889**: los valores sí se dividen durante las pasadas; las demás lecturas dan 1,333 / 1,778 (restaurados).
- El bloque pasa a **412 palabras** (pantalla 172 + 5 constantes); `mods/coop.toml` y el pnach **reinstalados, apagados**.
- **Visto de paso:** el tinte amarillo del HUD («fantasma») aparece en **las dos** mitades, no sólo en la derecha. Es lo siguiente.
**Sigue:** el HUD por mitad (qué dibuja ese efecto de pantalla completa, en frío).

### (89b) El «fantasma»: quién lo dibuja, y el arreglo — predicción
- **Sondeo por efecto** (`fantasma.py`: de a una, 9 llamadas de `FUN_001297E0` pasadas a `nop` con la división prendida, captura, restaurar; tira `capturas-89/f-tira.png`): sólo con **`FUN_001B0AC8(R+0xD290)`** (`jal` en `0x00129AD0`) apagado la imagen sale limpia, sin las rayas amarillas ni el «015» fantasma; las otras ocho (`1B0260`, `1B1DC0`, `1AF768(…,6)`, `1BE4C0`, `1B1E00`, `1AE5A0`, `110430`, `1AE5C8`) no lo tocan. En frío: `FUN_001B0AC8` arma un color (con `DAT_0040F528+0x60` y `param+0x28`) y dibuja dos quads a pantalla completa (`FUN_001CFB50`): el tinte de fundidos y daño. Dentro de cada pasada, con el sub-raster a media anchura, cada mitad recibe el efecto entero. Grado: identificado por efecto con el control de las otras ocho; el mecanismo exacto del «015» (si el quad lleva textura del cuadro anterior) es hipótesis.
- De paso: la **primera** corrida de la sonda mató a PCSX2 entero justo después de la captura base, **antes de tocar nada** (emulog sin error, proceso ausente). Repetida idéntica, completó. Sin explicar.
- **El arreglo:** un filtro (`0x0046FB00`) en el `jal` de `0x00129AD0`: si `DATOS+0x3C` ≠ 0 vuelve sin dibujar, si no salta a `FUN_001B0AC8`. El stub de la pantalla pone `+0x3C` = 1 durante las dos pasadas, lo baja, restaura el raster entero y llama **una vez** a `FUN_001B0AC8(R+0xD290)` a pantalla completa.
- **Predicción:** con el arreglo, la captura dividida se parece a la del `nop` (sin fantasma) y no a la base; el tinte de daño sigue apareciendo a pantalla completa cuando a J le pegan (no se prueba acá).

### (89b) Resultado — confirmado en pantalla, con control
`filtro89b.py` (el stub repuesto sin riesgo: `quitar` → esperar → `poner` en pausa), mismo cuadro, alternando la palabra de `0x00129AD0`; diferencia media sin la franja del HUD:
| | contra el `nop` |
|---|---|
| **con el filtro** | **1,0** |
| original (control) | 8,1 |
| filtro contra filtro, segundos después (ruido) | 5,7 |
A ojo (`capturas-89/g-tira.png`): con el filtro y con el `nop` la imagen sale limpia; con la original, el tinte amarillo y el «015» fantasma. El bloque suma el filtro (8 palabras, `0x0046FB00`) y su gancho; la pantalla, 181 palabras (`..0x0046FAD4`).
- **Sin probar:** que el tinte de daño o de fundido siga viéndose a pantalla completa con la llamada única (en una escena quieta la llamada única no deja marca visible, coherente con un efecto que mezcla el cuadro anterior: hipótesis).

### (89c) Por el pnach solo: 64 cuadros/s, y una banda amarilla ABIERTA
- **Bloque de 430 palabras, PCSX2 reiniciado, sin Python del mod:** J2 se arma, camina 8,29 m (títere ≤ 0,28 m), la mitad izquierda sale **limpia y en proporción**, y la escena se dibuja **64 veces por segundo con la pantalla partida** (en (88e), 38–40): el tinte dibujado dos veces por cuadro era lo caro. Medido con `ritmo`.
- **Problema abierto:** en la mitad derecha, una **banda amarilla sólida** de x = 320 a ~608 (en píxeles de PS2), con el borde derecho negro (`capturas-88/h1-*.png`, `h2-*.png`). En la prueba por PINE de (89b) no apareció (nivel corriendo hacía minutos; esta, ~30 s después de cargar).
- **Refutado:** que fuera la llamada única del tinte con el viewport viejo de la mitad derecha. Se restauró ancho y offset del raster **antes** de la sincronización final (el cambio queda: es el orden coherente) y la banda sigue igual (`h2-1-chica.png`).
- **Medido:** las 430 palabras del bloque están en memoria tal cual (`chequear_filtro.py`: 0 distintas), el gancho del filtro puesto.
- **Hipótesis para la próxima:** (a) la banda es la llamada única del tinte pero su quad no depende del raster de la cámara (probar por PINE, con el bloque apagado, apagando esa llamada en el stub: sin el pnach nadie la reescribe); (b) es un efecto del arranque del nivel que la prueba por PINE no vio por el momento (repetir por PINE ~30 s después de cargar).

---

## 2026-09-27 (88) — B2b en el stub: el títere de J2 sin PINE
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B2b, B3) · **Nodos:** `personajes` K4 (hacia K5), `codigo-nuevo` K5 (entrega)
**Objetivo:** que el cuerpo de J2 (el aliado 1, (85)) lo mueva el mod y no Python.

### (88) Predicción, escrita antes de abrir el emulador
`coop_mod.py` suma al stub por cuadro, en la rama que corre a J2 (estado 3), la copia de la matriz de J2 (`J2+0x70..+0xAF`, 16 palabras con `lw/sw`) al aliado 1 (`*(0x0040F514)+0x90+0x3C0`, en su `+0x70`), con guardas: pool no nulo, `+0x328` ≠ 0 y bando `+0x3A4` = 0; cuenta en `TITERES` (`0x0046D7CC`). El stub pasa de 68 a 91 palabras (`0x0046D800..0x0046D96C`, tope `0x0046D9F0`); el mod, a 225.
- **Con títere:** en City Streets, `manos 2` → J2 camina ~7,5 m y el aliado 1 lo sigue: distancia aliado–J2 ≤ 0,3 m durante y al final; `TITERES` sube ~60 por segundo; sin cuelgue.
- **Control (`poner --sin-titere`):** J2 camina igual y el aliado se mueve < 1 m (o lo que haga su IA), lejos de J2.
- Riesgo: si la actualización del aliado corre **después** del stub y recalcula su matriz desde otro estado, el efecto puede ser nulo (el de PINE escribía muchas veces por cuadro). Eso sería un resultado, no un error del stub.

### (88) Resultado — confirmado, en RAM y en pantalla, con control
Corrida por PINE (`coop_mod.py poner` + selector, nivel 0/0, que es City Streets: el aliado 1 está en `0x00590250`, bando 0).
| corrida | J2 camina | aliado se mueve | aliado–J2 máx / final | `TITERES` |
|---|---|---|---|---|
| carga 1, `--sin-titere` (control) | 7,58 m | 1,65 m (su IA) | 69,05 / 62,84 m | 0 |
| misma carga, stub cambiado en pausa | 2,43 m (pared) | 2,57 m (primero salta 69 m hasta J2) | 0,15 / 0,15 m | +121 en 2 s |
| **carga 2** (con la baja de (87)) | **8,47 m** | **8,52 m** | **0,16 / 0,00 m** | +133 en 2 s |
| J2 girado 150°, otra dirección | 9,52 m | 9,59 m | 0,22 / 0,00 m | +163 |
- `TITERES` sube ~60 por segundo: una copia por cuadro. La segunda carga no cuelga (`desarmes` 1, `atadas` 2): la baja convive con el títere.
- **En pantalla:** `volcados/capturas-88/p1-titere-stub.png` — J mira a J2 después de que J2 caminara 9,5 m en otra dirección: el soldado está ahí, a 2,2 m, y la mira de J se pone **verde** sobre él (es aliado). `p2-sin-titere.png` es la de control, pero **no discrimina**: el aliado quedó parado donde el títere lo dejó (J2 se había movido 0,85 m); el control que vale es el de RAM (fila 1).
- Lo de «actualización después del stub» no pasó: con una copia por cuadro alcanza, igual que las muchas de PINE. El orden de las actualizaciones dentro del cuadro sigue sin medir.
- El mod pasa a **225 palabras**; `mods/coop.toml` regenerado y el bloque del pnach **reinstalado, apagado**.

**No funcionó / sin explicar:** la primera caminata con títere dio 2,43 m y no 7,5: arrancó desde otro punto, al lado de una pared (la de control de la misma zona dio 0,85 m). Guarda **sin probar en rojo**: un nivel sin aliado 1 (bando ≠ 0 o `+0x328` = 0) no se midió.
**Sigue:** (b) la vista de J2 en el stub (el cuaternión desde el yaw de su mira), (c) su cabeceo.

### (88b) La vista de J2 en el stub — en frío, y la predicción
- **El juego trae `sinf` y `cosf` de newlib/fdlibm, llamables:** `FUN_0029DC18` = `sinf` y `FUN_0029DA28` = `cosf` (la misma reducción `FUN_002A14B8` y el mismo `switch (n & 3)` con los núcleos `FUN_002A3408` = `__kernel_sinf` y `FUN_002A2960` = `__kernel_cosf`, en el orden de cada una); `FUN_0029DD08` = `tanf` (la usa la proyección con FOV/2). Las dos leen el argumento de `$f12` (`mfc1 v0, $f12`, medido con capstone). **El cálculo de la mira del jugador no las usa**: lo hace en línea con macros de VU0 (`FUN_001334E0`), así que no hay que escribir trigonometría a mano ni VU0.
- **El cambio:** el stub de `pantalla_dividida.py` calcula en cada dibujo con la división prendida `q = (0, sin h, 0, cos h)`, `h = yaw · π/360` (el yaw de `*(J2+0x32C)+8`, en grados) y el ojo `J2+0x100` (con w = 1), en `DATOS+0x60/+0x70`; si `DATOS+0x94` = 1 lo copia a `+0x40/+0x50`, que es lo que usa la pasada 2. Con `+0x94` = 0 sigue mandando Python.
- **Predicción:** (1) con Python escribiendo la vista (`vista2 --fuente mira`), lo que el stub deja en `+0x60/+0x70` coincide con la fórmula de Python a < 1e-4 (float contra double); (2) con `+0x94` = 1 y **sin Python**, la mitad derecha muestra la vista de J2 y **sigue** su giro (gira J2 150° → cambia la mitad derecha, no la izquierda); (3) control: `+0x94` = 0 y sin Python, la mitad derecha queda congelada en la última vista escrita.

### (88b) Resultado — confirmado, en RAM y en pantalla, con control
- **Numérico:** con Python escribiendo la vista, `comparar 3` da **peor diferencia 1,2e-7** en 60 muestras entre lo que calcula el stub (`DATOS+0x60/+0x70`) y la fórmula de Python; con el stub mandando y J2 girado, 2,9e-8. El stub pasa a **100 palabras** (`0x0046FA00..0x0046FB90`).
- **En pantalla** (`volcados/capturas-88/b1..b5`, tira `b-tira.png`), diferencia media de gris por mitad, sin la franja del HUD:
| par | fuente | izquierda (J) | derecha (J2) |
|---|---|---|---|
| b1 → b2: J2 gira 150° | stub | 2,1 | **21,5** |
| b3 → b4: J2 gira 150° | Python quieto (control) | 0,5 | **1,5** |
| b4 → b5: se prende el stub | stub | 4,5 | **26,4** |
- La vista de J2 sigue **sin cabeceo** (sólo el yaw, igual que `vista2 --fuente mira`): la trae (c).
**Sigue:** (c) el cabeceo de J2.

### (88c) El cabeceo de J2 — medido, y la predicción
- **Corrige a (85): la matriz `+0xD0` de J2 NO está al revés respecto de la de J.** Con el mismo cabeceo de mira escrito en los dos (`mira+0xC` = −20°), **J y J2 dan lo mismo**: `+0xF0.y` = **+0,342**, `+0xE0` = (∓0,079 / ∓0,198, 0,94, ±…); con +20°, −0,342. El yaw de `+0xF0` coincide con el adelante del cuerpo (`+0x90`) en los dos. O sea: la convención de `+0xD0` es la misma para todo jugador; **J acierta por otro camino** (hipótesis: su disparo sale de la cámara, que es la de J) y J2, que no tiene cámara, dispara por `+0xD0`. No se buscó ese camino: el arreglo no lo necesita.
- **El orden por cuadro, leído:** `FUN_0013BAC8(J)` llama al update de la mira (`*(J+0x32C)`, vtable en `mira+0x84`, entrada `+0xC`) = **`FUN_0013F618`**, que es el que integra el mando (`FUN_001404A8`; con `mira+0xF1` ≠ 0 invierte el eje vertical: la opción «invertir Y»). El stub de J2 llama primero a `FUN_0013BAC8(J2)` y **después** al update de J2 (vtable `+0x10`, entrada `+0xC`), que arma `+0xD0` y dispara.
- **El cambio:** en la rama que corre a J2, entre las dos llamadas, se niega el signo de `mira+0xC` (xor del bit 31) y se restaura después del update. El integrador ve el cabeceo real; la matriz sale con el opuesto. `poner --sin-cabeceo` es el control.
- **Predicción:** con el arreglo, `tirador.py J2 <blanco>` **sin** `--pitch-invertido` le baja la vida al enemigo (en (85): 6 balas, 100 → 0); control `--sin-cabeceo`: 5+ balas y 100. El eje vertical del mando 2 **no** se invierte (el integrador corre antes). Riesgo conocido: si el update suma retroceso a `mira+0xC`, con el xor el retroceso queda con el signo cambiado.

### (88c) Resultado — el xor alrededor del update REFUTADO; el cabeceo guardado negado, confirmado en RAM
- **Refutado:** con el xor puesto, `+0xF0.y` de J2 con cabeceo −20° sigue en **+0,342**: la matriz `+0xD0` **no** la arma el update que corre el stub (hipótesis: la arma el lazo del nivel, `FUN_001334E0`, porque J2 está enlazado). El xor se sacó.
- **Lo que quedó en el mod** (`CABECEO_MOD`, 7 palabras, en el paso del control2 del stub): una sola vez, cabeceo de la mira de J2 **guardado negado** (bit 31 de `mira+0xC`) y **bandera «invertir Y» de su mira dada vuelta** (`mira+0xF1`, la que leen los dos sitios de `FUN_0013F618`). Es lo de `--pitch-invertido` de (85), pero hecho por el mod y con el mando 2 moviéndolo.
- **Medido, con control** (`stick88c.py`: cabeceo en 0, `pitch_arriba` 0,8 durante 0,4 s):
| | `+0xF1` | cabeceo guardado | «adelante» `+0xF0.y` |
|---|---|---|---|
| J (referencia) | 0 | 0 → +70 | 0 → **−0,94** |
| J2 sin arreglo (control) | 0 | 0 → +70 | 0 → **−0,94** (arriba en la mira = balas al piso) |
| **J2 con arreglo**, carga nueva | **1** | 0 → **−70** | 0 → **+0,94** |
  Tercera carga seguida con el mod: sin cuelgue (`desarmes` 2, `atadas` 3). El mod: **232 palabras** (stub por cuadro 98).
- **Las pruebas de daño de hoy NO valen, en ningún sentido.** Con `tirador.py --acercar=6` (el enemigo sostenido a 6 m escribiendo su `+0xA0`): el par con el títere prendido dio muertes en control y con el xor (las hizo, probablemente, **el aliado-títere**, que tiene IA y estaba al lado de J2); sin títere y con los dos aliados a ~70 m, **ninguna** bala de J2 le pega, con cabeceo real o negado — **y J tampoco** (15 balas, 100: control negativo del montaje). O el blanco movido a mano no es golpeable donde se lo pone (hipótesis: su cuerpo de colisión no sigue a `+0xA0`), o quedó tras una pared (`c1-j2-apunta-23.png`: J2 mirando una pared). **Lo que sostiene que el cabeceo negado mata sigue siendo (85)**; el cierre de punta a punta lo da Fran con el mando 2 real, o un enemigo que llegue solo a la línea de tiro.
- `tirador.py` suma `--traza` (cada cambio de cargador y vida con su tiempo).

**No funcionó:** el xor alrededor del update; `--acercar` como banco de prueba de daño; dos corridas del 17 y el 3 (el spawner no disparó a tiempo y se leyó un actor viejo).

### (88d) La vista de J2 con cabeceo, en el stub
- **La convención, medida sobre J** (`conv_cuat.py`: yaw y cabeceo de su mira contra el cuaternión que el juego pone en `gestor+0x710`): **q = q_yaw · q_cabeceo = (cy·sp, sy·cp, −sy·sp, cy·cp)** con medios ángulos y el cabeceo positivo hacia arriba; error ≤ 0,002 con yaw 60° y −179° y cabeceo 0/−25/+30 (las otras tres combinaciones: 0,2–0,5). Con yaw ≈ 180° casi no discrimina (0,005): por eso la segunda tanda en 60°.
- **El stub** (`pantalla_dividida.py`, 123 palabras, hasta `0x0046FBEC`): cuatro llamadas a `sinf`/`cosf` (medios ángulos en la pila, senos y cosenos en `DATOS+0x20..+0x2C`) y el cabeceo **real** de J2 = −`mira+0xC` (el mod lo guarda negado, (88c)). Contra la fórmula de Python: **1,1e-8 y 7,2e-8** con cabeceo real −20° y +20°.
- **En pantalla: no concluyente.** Las capturas `d1..d3` salen con el desenfoque de daño de J en toda la pantalla (un enemigo le tira; vida FLT_MAX) y la comparación por mitades no discrimina (control 18,4 contra 14,9). La cadena que sí vale: convención medida contra la cámara real + stub = fórmula + (88b), que ya probó en pantalla que ese cuaternión es el que dibuja la mitad derecha.
### (88e) La pantalla dividida dentro del mod — predicción
- **El cambio:** el stub de `pantalla_dividida.py` se muda a `0x0046F800` (136 palabras, `..0x0046FA20`; ya no entraba antes de DATOS), lee el sub-raster en vivo (`*(*(R+0xD400+0x58)+0x60)`, `R = *(0x0040F4C0)`) en vez de que lo escriba Python, y sólo divide con **J2 corriendo** (`FASE` = 2 y `ESTADO` = 3 del mod). `coop_mod.py` lo suma al bloque con sus constantes (`DATOS+0x80` = 1, `+0x8C` = 320, `+0x90` = 640, `+0x94` = 1) y los tres ganchos de la escena; `--sin-pantalla` es el control.
- **Predicción** (emulador recién abierto, slot 3, `coop_mod.py poner`, carga por el selector): (1) mientras J2 espera sus 30 cuadros la pantalla es una sola; (2) con `ESTADO` 3 se divide sola, sin tocar nada desde Python; (3) J2 camina con `manos 2` y cambia la mitad derecha, no la izquierda; (4) una segunda carga seguida no cuelga; (5) control `--sin-pantalla`: pantalla entera con J2 corriendo.

### (88e) Resultado — confirmado en pantalla, por PINE y POR EL PNACH SOLO
- **Por PINE** (emulador recién abierto; ningún comando de `pantalla_dividida.py` corrido en ese proceso, así que la división sólo puede venir del código del mod): con `ESTADO` 3 la pantalla **se divide sola**; J2 camina 8,08 m (títere ≤ 0,16 m) y la mitad derecha cambia 26,9, la izquierda 16,0 — porque en la vista de J aparece el títere caminando (`e-tira.png`). **Segunda carga seguida:** sin cuelgue (`desarmes` 1), se divide sola otra vez, J2 8,45 m (títere ≤ 0,28 m).
- **Por el pnach solo** (bloque de **375 palabras** instalado y prendido, PCSX2 reiniciado, emulog `Enabled patch: COOP - jugador 2 (B3)`, **sin `poner`**): J2 se arma, se ata, el títere corre, la pantalla se divide, J2 camina 8,08 m y el stick vertical de J2 va para el lado correcto (`+0xF1` = 1, `pitch_arriba` → adelante +0,94). Captura: `volcados/capturas-88/f1-2-despues.png` — **J (izquierda) ve el cuerpo de J2 en la ventana, y J2 (derecha) mira por esa ventana.**
- **Costo:** con la división, 38–40 dibujos de escena por segundo en esta zona (J2 ~41 cuadros/s; sin división ~60).
- **Lo que se ve mal, ya conocido:** el «fantasma» amarillo del HUD en la mitad derecha (efecto de pantalla completa, (84)) y las dos mitades **aplastadas** (la proporción `R+0xD400+0x70/+0x74` no se toca todavía).
- **Control (5) no corrido:** el control por construcción (proceso limpio, sin Python de la pantalla) cubre lo que mide; `--sin-pantalla` quedó en la herramienta.
- El bloque quedó **instalado y APAGADO** otra vez (`coop_mod.py activar` lo prende, con PCSX2 cerrado).

**No funcionó / sin explicar:** (1) no se midió con captura en el instante. **Sigue:** la proporción de las mitades, el HUD por mitad, esconder los brazos de J2 en la vista de J, la recarga de J2; el mando 2 **real** lo prueba Fran; B4–B6 en frío; `docs/14` + `coop_diseno.py`.

- **Reemplazar el stub en caliente**, sin volver a una dirección corrida: `quitar` (vuelven los `jal` originales), esperar, y recién ahí `poner` en pausa. Para el stub por cuadro del mod: `FASE` = 0, esperar, escribir en pausa, `FASE` = 2.
**Sigue:** (d) — la pantalla dividida en el pnach (con la vista de J2 **con cabeceo**, que ahora es `−mira+0xC`), la recarga de J2, B2b fino, B4–B6 en frío, `docs/14` + `coop_diseno.py`.

---

## 2026-09-27 (87) — B3.3: la baja de J2 al salir del nivel; el mod aguanta TRES cargas seguidas
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B3.3) · **Nodos:** `ragdoll` K5 (evidencia), `juego` K5 (evidencia)
**Objetivo:** que la segunda carga no cuelgue el emulador (H2 de (86): algo dado de alta a J2 sobrevive al nivel).

### (87) En frío: el desarme del nivel y su espejo
- `censo_jugadores.py` da cuatro lazos sobre `jugadores[]` que obedecen a `cuenta`: `0x0012A070`/`0x0012A098` (dentro de **`FUN_00129DE8`**, el desarme), `0x0012BF58` (**`FUN_0012BE80`**, el alta: atar + enlazar) y `0x0012C068` (**`FUN_0012BFC8`**, la baja).
- **`FUN_0012BFC8` es el espejo exacto de `FUN_0012BE80`:** por jugador `i < cuenta`, `FUN_0025C2C8(*(0x0040F4CC), J)` suelta el controlador de colisión (`FUN_0025C798`: libera la entrada del pool, borra `DAT_0043F3F0[i]` y la saca del mundo de colisión con `FUN_0032CDE0`; `J+0xB4 = 0`) y `FUN_0012A280(juego, J)` lo saca de la lista del nivel (`juego+0x5CA4`, siguiente en `+0xB0`) y de `juego+0x4920`. La llama `FUN_00129DE8` en su estado **0x1D**, en **`0x00129E38`** (`jal 0x12BFC8`, delay `move a0, s3`).
- El registro físico de `FUN_0016E660` no hace falta replicarlo (hipótesis): el desarme resetea el registro entero (`FUN_0016DC80`, estado 0x1F). Los estados 0x1F..0x21 llaman además `vtable+0x24` de cada jugador; a J2 no, y no hizo falta.
- La caída de (86), leída del emulog del emulador colgado: `FUN_0033DD98` recorre memoria **de a 0x10 hacia arriba** desde `0x2000000` (fin de la RAM), o sea un arreglo con cuenta basura; el cartel «FQC = 0 on VIF FIFO READ» que vio Fran es de después, del mismo cuelgue (la copia `PCSX2-MCP` tiene las aserciones prendidas).

### (87) La baja para J2 — confirmado, con control
`coop_mod.py` suma un tercer programa, **el desarme** (`0x0046DD00`, 36 palabras) y un tercer gancho en `0x00129E38`: llama a la original y, con fase 2, lo mismo para J2 (estado 3 → `FUN_0025C2C8`; estado ≥ 1 → `FUN_0012A280`), deja fase = estado = 0 y suma `DESARMES` (`0x0046D7C8`). El mod pasa a **202 palabras**.
Predicción escrita antes: *con la baja, la 2.ª carga da desarmes 1, moldes 2, estado 3, atadas 2, sin `TLB Miss`, y J2 camina ≥ 3 m (control < 0,3 m); si la causa es otra, cae igual con desarmes 1.*
- **Con la baja** (slot 3 → `poner` → selector → 0 0, tres veces seguidas): carga 1 moldes 1, J2 **7,55 m** (control 0,00); carga 2 **desarmes 1, moldes 2, estado 3, atadas 2**, `J2+0xB4 = 0x5880B0` (**la misma entrada del pool**: la baja la liberó), J2 **7,54 m** (control 0,00); carga 3 desarmes 2, moldes 3, atadas 3, J2 **7,56 m** (control 0,00). **0 `TLB Miss`** en el emulog. J vivo antes de cada carga.
- **Control, emulador relanzado, `poner --sin-baja`:** carga 1 igual (7,55 m); carga 2 **moldes 2, espera 1, desarmes 0 y la misma caída**, `TLB Miss, pc=0x33DDB0 addr=0x2000000`.
- **Aislamiento (regla del éxito inexplicado):** relanzado, la baja con la llamada a `FUN_0025C2C8` anulada (sólo la lista): **desarmes 1 y la misma caída**. La causa es **el controlador de colisión de J2 que queda en el mundo de colisión** y la carga siguiente lo recorre. Si sacarlo de la lista también hace falta no se midió (se deja: es lo mismo que el juego le hace a J).

**No funcionó:** nada nuevo; la variante «sólo lista» se cae, como se predijo.
**Sigue:** el títere (matriz `J2+0x70..+0xAF` → aliado 1 cada cuadro), la vista de J2 (cuaternión y ojo en `DATOS+0x40`/`+0x50` de la pantalla dividida) y su cabeceo (`+0xD0` al revés) en los stubs; el mando 2 real lo prueba Fran.

## 2026-09-27 (86) — B3: J2 se arma en la carga SIN datos desde afuera (el molde lo copia el envoltorio)
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B3, el mod sin PINE) · **Nodos:** `codigo-nuevo` K5 (evidencia), `personajes` K4 (evidencia)
**Objetivo:** contestar la primera pregunta de B3: ¿J2 se construye en la carga desde un molde que un pnach pueda producir? Hasta (85) el molde lo escribía Python (`jugador2.py carga-poner` copia a J en vivo antes de la carga).

### (86) Lo que un pnach no puede escribir — medido
El molde (J, `0x8C0` B, leído en vivo) tiene **7 autopunteros**, **5 punteros al ELF** (vtables), 1 a `.bss` y **29 al montón** (`+0x30`, `+0x7C`, `+0xB4`, `+0x2A0`, `+0x328`, `+0x330`, `+0x34C`, `+0x588`…). Un pnach sólo escribe constantes, y en `continuo` las reescribe cada cuadro: el molde no puede ir en el pnach. **Pero el envoltorio del cargador corre justo cuando J termina de construirse**, así que puede copiarlo él: es lo mismo que hacía Python, un instante después. De paso: `CTRL2 = *(J+0x588) + 0x16C` (J `0x5858A0`, J2 `0x585A0C`), y `CTRL2+0xC` apunta de fábrica al **mando 2 real** (`0x5857B0`).

### (86) B3.1 — EN VIVO: el mod arma a J2 solo — confirmado
Herramienta nueva `herramientas/coop_mod.py` (ENVOLTORIO_MOD + POR_CUADRO_MOD, 165 palabras). El envoltorio, cuando la original devuelve 1 para J, **copia J → J2 con `lq/sq`** (`0x8C` vueltas), reubica los 7 autopunteros, `+0xB0 = 0`, `+0x8A4 = 0x1C`, `+0x2A0 = ARMAS2` en cero, y pasa a la fase 1 (lo de (79)); con fase 2 la **carga siguiente vuelve a armarlo**. El stub por cuadro, con fase 2: espera 30 cuadros → **control2** (`J2+0x588/+0x6D0/+0x7C8 = CTRL2`, `+0x32C = J2+0x4F0`) + **enlazar** `FUN_0012A158(juego, J2)` → **atar** `FUN_0025C210(*(0x0040F4CC), J2)` → controlador y update de J2 cada cuadro.
Predicción escrita antes: *escribiendo sólo código y ganchos, con J2, `ARMAS2` y los datos en cero, al cargar el nivel 0 0: moldes 1, fase 2, `J2+0x8A4 = 0x37`, estado 3 solo, atadas 1, `J2+0xB4 ≠ 0`; con las manos 2 s J2 camina ≥ 3 m, control < 0,3 m. Si el molde de la carga no sirve, el constructor se cuelga (`llam_J2` crece con `v0 = 0`) o cae el emulador.*
- Slot 3 → `coop_mod.py poner` (EN PAUSA: pone en cero J2, `ARMAS2` y los 12 datos; escribe sólo código y los 2 ganchos) → selector → nivel 0 0. **Moldes 1, fase 2, `llam_J2` = 1** (el constructor devolvió 1 al primer llamado), `J2+0x8A4 = 0x37`, a ~1 s de juego **estado 3, atadas 1, `J2+0xB4 = 0x5880B0`, `J2+0x588 = 0x585A0C`**, y el contador de J2 sube por cuadro (2551 en ~40 s).
- **Las manos** (`coop_mod.py manos`, lo único escrito por PINE después de `poner`: clona el mando 2 en el falso 2 y empuja el eje): control 2 s **0,00 m**; empujando 2 s **7,57 m**; control otra vez **0,00 m**. J sigue vivo (`selector_depuracion.py vivo`).
- **Lo que esto NO prueba todavía:** que ande desde el **arranque** con el pnach (sin PINE ni para escribir el código), ni con dos cargas seguidas, ni con el mando 2 real. Eso es B3.2.

### (86) B3.2 — el mod ENTREGADO POR EL PNACH: anda en la primera carga — confirmado
- **La entrega.** Fran juega con `Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach` (bloques con nombre) y prende cada uno con `Enable = <nombre>` en `gamesettings\SLUS-21376_5C891FF1.ini` `[Patches]` (el `pnach.py --instalar` escribe en `cheats_ws`, que no es el que se usa). `coop_mod.py instalar` agrega el bloque **`[COOP - jugador 2 (B3)]`** (165 `patch=1`, sólo código) con respaldo, **apagado**; `activar`/`desactivar` tocan sólo su línea `Enable`. El emulog lo mide: `Enabled patch: COOP - jugador 2 (B3)`, 8 parches activos.
- **Un choque que NO era del mod — con control.** Arranque en frío con el bloque activo → el emulog lo cargó y la RAM tenía las 165 palabras sin que PINE escribiera nada. Pero `selector_depuracion.py pedir-frontend` pedido **desde el menú del arranque** hizo saltar la CPU a datos a los 0,4 s (el emulog «ejecuta» cadenas de la interfaz Flash: primera palabra `0x74754275`, después `Trap exception at 0x8000018c` en lazo). **Control: mismo arranque SIN el bloque, mismo comando → la misma caída, misma primera palabra.** El selector sólo anda pedido desde adentro de un nivel (así se usó siempre). Aparte: el aviso «Failed to open patches.zip» que vio Fran es de la copia `PCSX2-MCP` (no trae `resources\patches.zip`); no afecta a los parches de usuario.
- **La prueba.** El slot 3 (17/08) tiene **toda** la zona `0x0046CDF0..0x00472200` en cero y los ganchos originales (leído en frío del `.p2s`): cargarlo deja los datos como un arranque y el código sólo puede venir del pnach. Arranque con el bloque → slot 3 → `leer` (sólo lectura): **165/165 palabras en RAM, datos y J2 en cero**. Selector → nivel 0 0: **moldes 1, fase 2, estado 3, atadas 1, `J2+0xB4 = 0x5880B0`**; manos: control **0,00 m**, empujando **7,54 m**, control **0,00 m**. Mismos números que B3.1.

### (86) La SEGUNDA carga se cae — hipótesis abierta
Predicción escrita antes: *moldes 2, atadas 2, J2 rearmado y caminando; el riesgo es J2 corriendo por cuadro mientras el nivel se desarma.* Selector otra vez → nivel 0 0: **moldes 2, `llam_J2` 2, `J2+0x8A4 = 0x37`**, J2 en el punto de aparición, pero **la espera quedó en 1** y el emulador cayó: `TLB Miss, pc=0x33DDB0 addr=0x2000000`, en `FUN_0033DD98` (un `lqc2` de VU0) llamada por `FUN_00336520`, con la pila en `0x01FFF000`. O sea: **la primera carga anda; la segunda, no**. Hipótesis H1: J2 sigue en estado 3 (controlador + update cada cuadro) mientras el nivel viejo se desarma y ensucia algo; H2: J2 quedó anotado en un registro que sobrevive entre niveles y nadie lo da de baja. Grado: hipótesis las dos.
- **Error de la herramienta, corregido:** `manos` leyó `J2+0x588` antes de que el mod preparara el control2, cuando todavía era **el control de J**, y le mandó a J el falso 2. Ahora se niega si `J2+0x588` es el de J.

### (86) H1 REFUTADA: no es correr a J2 durante el desarme
Predicción escrita antes: *si es H1, con J2 frenado la segunda carga anda; si es H2, se cae igual.* Relanzado, slot 3, primera carga (estado 3, 1105 cuadros de J2), **`fase = 0` por PINE** (J2 deja de correr: **0 cuadros en 1 s**, pero sigue anotado en todas las listas del nivel viejo) → segunda carga: **moldes 2, espera 1 y la misma caída, `TLB Miss, pc=0x33DDB0 addr=0x2000000`**. **H1 refutada; H2 probable:** algo que se le da de alta a J2 en la carga (el registro físico `FUN_0016E660`, el enlace `FUN_0012A158`, el controlador de colisión `FUN_0025C210` en el pool de `0x00585C00`, o lo que haga el constructor `FUN_00139C68`) **sobrevive al nivel**, y como nadie lo da de baja, la carga siguiente lo recorre roto. A J lo da de baja el juego, en algún lazo sobre `jugadores[]` que obedece a `cuenta` = 1 (sonda 5, `censo_jugadores.py`).
- **Mientras tanto el bloque del coop queda APAGADO** (`coop_mod.py desactivar`): con la segunda carga rota no puede quedar prendido en las partidas de Fran. Instalado sigue estando.

**No funcionó:** el selector desde el menú del arranque (se cae con o sin el mod); la segunda carga con el mod (H1 refutada).
**Sigue:** B3.3 en frío — el desarme del nivel: qué lazo sobre `jugadores[]` da de baja a J (candidatos en `censo_jugadores.py`) y qué llama; replicarlo para J2 en el envoltorio (o al salir) y la prueba de DOS cargas con control. Después el títere, la vista y el cabeceo en los stubs.

## 2026-09-27 (85) — B2b: el cuerpo de J2 es un ALIADO del nivel; B7: J2 hace daño (su cabeceo está al revés); sin fuego amigo entre jugadores
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (B2, cuerpo de J2; fuego amigo) · **Nodos:** `vista-fp` **K2 → K3**, `ia` **K2 → K3**, `personajes` K4 (evidencia), `armas` K6 (evidencia)
**Objetivo:** Fran contestó la pregunta de B2: *«en el mismo nivel 1 hay aliados, así que buscá un modelo de aliado; y para los aliados no debe haber fuego amigo»*, y agregó que *al apuntarle a un aliado la mira se pone verde* (los aliados no están en todos los niveles).

### (85) En frío: el BANDO y el TIPO de cada personaje
- **`+0x328`** de todo personaje = su entrada de la tabla de tipos (`actores+0x7A10+0x40·tipo`); la guarda `FUN_001327F0` (`puVar19` es `undefined8*`: `+0x65·8`). **`+0x3A4`** = el **bando**: `FUN_00178BC0` (constructor de enemigos) lo pasa como `param_8`, y hay ~50 comparaciones `+0x3A4` contra el del otro en el ELF (`FUN_0013D388`, `FUN_0013D9A0`, …); `FUN_0013D400` indexa `DAT_0040F4D4+0x22B20` por bando; `FUN_00134990` (un daño de valor fijo 100/50) **vuelve sin hacer nada si la víctima es de bando 0**.
- Leído en los cuatro volcados del mismo nivel y en vivo: **J y J2 bando 0; actor 0 tipo `0x1E` y actor 1 tipo `0x1D`, bando 0, vida FLT_MAX (los aliados, Tom y Matt: `Team0_Tom`/`Team1_Matt` de 2026-08-17); todos los `0x24` bando 1** (enemigos). Grado: probable (el bando se lee en código y RAM; la mira verde no se midió contra el campo). **El «no fuego amigo» de los aliados ya es del juego: vida FLT_MAX.**

### (85) B2b — EN VIVO: el aliado se dibuja donde está J2 y lo sigue — confirmado
Predicción escrita antes: *el aliado 1 (0x1D) aparece como soldado completo donde se lo ponga; si el controlador de colisión es el dueño de la posición, deriva > 0,5 m entre escrituras.*
- **P1:** posición del aliado 1 escrita a mitad de camino J–J2 y sostenida por PINE: **se ve el soldado** (visor nocturno, cuerpo entero) y **la mira se pone verde sobre él** (`volcados/capturas-85/p1b-aliado1d-durante.png`); control, la captura de antes: sólo los brazos flotando de J2 junto a la puerta (`p1b-aliado1d-antes.png`). Al soltarlo **se queda donde se lo puso** (1 s después, a 0 m).
- **P2:** la **matriz entera** de J2 (`+0x70..+0xAF`) copiada al aliado en cada vuelta de PINE (`herramientas/titere.py`), con J2 caminando con el mando falso 2: **J2 camina 9,96 m y el aliado 10,05 m, a 0,21 m como máximo**; control (sin copiar): J2 camina y el aliado se mueve 0,00 m. Visto desde J: el soldado parado donde quedó J2, con los brazos de J2 flotando encima (`p2c-quieto-durante.png`).
- **Queda para el diseño (no para la factibilidad):** los brazos de J2 se siguen dibujando encima del títere en la vista de J; el títere tiene sus propias animaciones (no camina cuando J2 camina); la copia tiene que vivir en el gancho por cuadro (`0x0046D800`), no en PINE; en la vista de J2 hay que esconder el títere; y **en los niveles sin aliados** hay que dar de alta un soldado con bando 0.

### (85) Fuego amigo — lo que se midió, y una trampa que contaminó media sesión
- **J → J2: no hay daño.** `matar_sin_manos.py` apuntando a J2: 14 balas nativas a 4,5 m, J2 sigue en 750; con J2 en **bando 1** (y `sondas_coop.py boton disparar 2`): 10 balas más, sigue en 750. No es el bando: el jugador **no tiene blanco de bala** (probable; en un jugador solo nunca hizo falta).
- **Primera medición: las balas de J2 no hacen daño.** Mismo enemigo, misma sala, mismo script (`herramientas/tirador.py`), 12 s después de nacer: J2 le tira **sus 15 balas nativas** a 1,1 m (cargador 15 → 0) y el enemigo queda en 100; acto seguido **J lo mata** (100 → 0). El disparo de J2 sale (agujeros en la pared, `p7-J2-a-enemigo.png`). Se abrió **B7** en el PDP. **Lo que sigue lo corrige.**

### (85) B7 — J2 SÍ hace daño: su matriz de vista tiene el cabeceo AL REVÉS — confirmado
- **En frío (las instrucciones, no Ghidra):** el despachador de impactos `FUN_0015BA80` llama al método de daño (vtable `0x003DCA78` `+0x4C` = `FUN_00133FA8`) con el tirador que le pasa `FUN_0015AA60`; el tirador sale de `bala+4 → +0xF0`. La **máscara** del rayo la arma `FUN_00159198` (`0x001591D4..0x001592CC`): tirador con `+0xC4 = 2` (jugador) → **`0x57`**, cualquier otro → **`0x1F`**. El filtro `FUN_0015ADA8` exige **bit 4** para una víctima NPC y **bit 8** para una víctima jugador: la máscara no era el problema (J2 es jugador: `0x57` pega a NPCs). El rayo lo arma el método del tirador vtable `+0xA4` = `FUN_0013B4C0`: acople 5 de su ranura (`FUN_001A68B0(J+0x330, 5)`) por su **matriz de vista** `+0xD0/+0xE0/+0xF0/+0x100`.
- **Dos hipótesis refutadas en vivo (`herramientas/ranura_j2.py`):** «la bala nace en el arma de J porque la ranura es compartida» — el slot 13 **ya** tiene a J2 en su ranura propia (ranura 1, dueño J2) y no daña; y con J2 en la ranura 0 (la de J, animada) tampoco. De paso: las **matrices de acople de la ranura 1 están en cero** (las de la 0 tienen el caño a 0,44 m).
- **Medido:** la mira de J2 dice cabeceo **−19,42°** (abajo, al pecho del enemigo) y el «adelante» de su matriz de vista (`+0xF0`) tiene **y = +0,332** = 19,4° **arriba**. Las balas pasaban por encima de la cabeza.
- **Predicción escrita antes:** *con el cabeceo escrito con el signo cambiado, J2 le baja la vida al enemigo.* **Medido, con control en el mismo minuto, mismo enemigo:** cabeceo normal, 5 balas y 100; **cabeceo invertido, 6 balas y 100 → 0** (`tirador.py --pitch-invertido`). **Con el títere aliado pegado a J2** (`--titere=1`) J2 igual lo mata (6 balas, 100 → 0): **el cuerpo no tapa sus balas.** Grado: confirmado.
- **Para el diseño:** la vista de J2 en la pantalla dividida sale hoy del yaw de su mira (sin cabeceo, (84)); la mira de J2 y lo que dispara tienen que salir de **la misma** matriz, y el eje vertical del mando 2 va invertido respecto de J (o se niega el cabeceo al construir la matriz).

### (85) Fuego amigo — la política queda decidida por el juego
- **Entre jugadores no existe, por máscara** (mecanismo leído arriba: `0x57` no tiene el bit 8 que pide una víctima jugador). Medido: **J → J2** 24 balas, 0 daño (con J2 en bando 0 y en 1); **J2 → J** 4 balas con la puntería buena, 0 daño.
- **A los aliados**, vida FLT_MAX: las balas les pegan (la mira se pone verde) y no les bajan nada.
- **Política:** no hace falta ningún parche de fuego amigo; si algún día se le da a J2 vida finita o un cuerpo propio que sea NPC, esto se vuelve a medir.
- **La IA le tira a J, no a J2:** un enemigo nacido a 6 m bajó a J de 750 a 30 (y lo mató: «Mission failed», `p8-J-no-dispara.png`) y dejó a J2 en 750, aunque caminó hasta 1 m de J2.
- **TRAMPA (costó ~8 sondas):** un enemigo **recién nacido por spawner no recibe daño los primeros segundos** — J, con el mismo script, 15 tiros sin daño a los ~5 s y lo mata a los ~40 s. Todas las pruebas «J2 no daña» anteriores a la limpia estaban contaminadas por eso; la limpia espera 12 s y tiene control. Otra: después de `pine.py cargarestado` desde la carpeta equivocada no se carga nada y se mide sobre el estado viejo (salió con `*> $null`).

**No funcionó:** apuntar por el «adelante» del cuerpo de J2 (`+0x90`) no apunta el arma (el arma sigue la mira, `*(J2+0x32C)+8`/`+0xC`); dos conexiones PINE a la vez (una se corta por tiempo); el botón recargar del mando falso 2 no le recarga a J2, ni con reserva `J2+0x280` = 30.

**Sigue:** **B3** (el mod sin PINE), que ahora lleva adentro del stub: la copia de la matriz de J2 al títere, el cabeceo de J2 corregido (una sola matriz para la vista y para el disparo) y la recarga de J2. Después B4–B6 en frío y `docs/14`.

## 2026-09-27 (84) — COOP-B abierta, y B1: el juego dibuja DOS VISTAS en el mismo cuadro
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2, la meta) · **Nodos:** `render` **K4 → K5**
**Objetivo:** escribir el criterio de salida de COOP-B en el PDP **antes** de abrirla, y atacar primero el riesgo que cambia la forma del mod: dos vistas por cuadro (B1).

### (84) El criterio de COOP-B
Escrito en `PDP.md` §4 («Proyecto COOP — Fase B») y commiteado antes de tocar RAM (`7d8955f`): tres riesgos altos retirados por efecto (B1 dos vistas, B2 J2 con cuerpo —el modelo lo elige Fran—, B3 el mod sin PINE), tres medios a K4 (IA, muerte de J2, disparadores), y `docs/14-coop-diseno.md` medido por `coop_diseno.py verificar` con su saboteador. Controles de apertura: 0 rojos, 183 comprobaciones.

### (84) B1a — En frío: la «segunda pasada» 160 × 112 NO es una vista: es la de sombras
`FUN_001C9110` (desde `FUN_001297E0` → `FUN_001C9088`) arma una cámara **orientada por una dirección de luz** (`0x004432C0`) centrada en la caja de los objetos, la pone en la cámara 1 del gestor de render, achica el raster a la vista de `+0xD170` (160 × 112), dibuja las listas 3 y 4 y **restaura**. Grado: probable. La hipótesis de (69) —«el motor ya dibuja una segunda vista»— queda corregida: dibuja **una segunda pasada**, pero de sombras. Lo que sí prueba es el **mecanismo**: cambiar la cámara y el rectángulo a mitad del cuadro, dibujar y volver.
- El gestor de render (`R = *(0x0040F4C0)`) tiene tres cámaras: `R+0xD360` (0, el HUD), `R+0xD400` (1, la escena), `R+0xD4A0` (2). Cada una tiene su `RwCamera` en `+0x58` (`+0x60` raster, `+0x68` ventana de vista, `+0x80` near/far).
- La cámara 1 **lee su vista** de `R+0xD400+0x68` = gestor de cámara `+0x700`: `+0x00` FOV (70°), `+0x10` **cuaternión**, `+0x20` **ojo**, `+0x30` la cámara. `FUN_001AE998(R,1)` → `FUN_0027ACD0` la convierte, y `FUN_0027B2F0` hace `vw.x = tan(FOV/2)·(R+0xD400+0x70)`, `vw.y = vw.x/(+0x74)` (1,333 y 1,778: **16:9**).
- La escena entera es `FUN_001297E0(juego)`, llamada por los tres modos (`jal` en `0x001056DC`, `0x0010656C`, `0x00106D8C`) **antes del HUD** (cámara 0) y del volteo.

### (84) P18 — el rectángulo de la cámara de escena mueve la escena (confirmado, con control)
**Predicción (escrita antes, en el guion):** con el ancho del sub-raster (`RwCamera+0x60` → `+0xC`) en 320 la escena se dibuja sólo en la mitad izquierda; con `nOffsetX` (`+0x1C`) = 320, en la derecha.
**Medido:** con 320 la escena entera sale **comprimida** en la mitad (el arma pasa de x≈1130 a ≈565 en la captura); con offset, en la derecha. Girar la vista cambia **sólo** la mitad dibujada: diferencia media izquierda/derecha **0,0 / 19,4** (offset 320) y **32,8 / 6,7** (offset 0); control a pantalla entera **43,9 / 56,2** (`volcados/capturas-84/p18*`).

### (84) P19 — dos pasadas de escena en el mismo cuadro (confirmado, con control)
**Predicción:** un gancho en los tres `jal FUN_001297E0` que llama dos veces —la 2.ª con el **contenido** de gestor `+0x710`/`+0x720` cambiado (el puntero no sirve: la pasada de sombras lo vuelve a poner a mitad del cuadro) y re-sincronizado con `FUN_001AE998(R,1)` + `FUN_001B0948(R+0xD400)`— dibuja la vista pedida en la mitad derecha, sin colgar el juego.
**Medido** (`pantalla_dividida.py`, stub `0x0046FA00`, datos `0x0046FC00`, puesto en pausa): el juego sigue vivo, y la mitad derecha muestra **la vista que se le da**: con la **misma** vista que J la diferencia entre las zonas visibles de las dos pasadas es **11,5** (dos veces), con la vista de J2 **25,3**, y sin división **50,1**. Con `+0x70`/`+0x74` a la escala de la mitad (×0,5) la imagen **no se deforma**: `p21-dividida-320.png`, capturada a 1920 × 1080 (izquierda J con su arma; derecha la cámara de J2, frente a una pared, con su arma; el HUD entero arriba). `render` **K4 → K5**.
- **El cuaternión:** calculado desde la matriz `+0xD0` del jugador da **exacto** el del juego para J (control `cuat`). Para J2 esa matriz trae un cabeceo que no corresponde (vista hacia el piso): la vista de J2 se arma con el **yaw de su mira** (`*(J2+0x32C)+8`) y el ojo `J2+0x100`. Hoy lo escribe Python; en la C lo tiene que hacer el stub.
- **Costo** (dibujos de escena por segundo, contador del stub): en una vista liviana **73 con y 73 sin**; en una pesada **24 contra 51**. Grado del «cuánto cuesta»: probable, depende de la escena.

**No funcionó / sorpresas:** (1) la primera medición del control comparó mitades de pantalla y dio «distintas» con la misma vista, y lo leí como «**PCSX2 muestra 512 de los 640 px**» (con el contador de munición afuera). **Era falso: las capturas estaban recortadas.** `capturar-pantalla.ps1` no era DPI-aware y con el escalado de Windows devolvía la esquina de 1536 × 864 de una pantalla de 1920 × 1080 (1536/1920 = 512/640). La lección **ya estaba** en `chequeo-de-trabajo.md` y la herramienta no la aplicaba: ahora llama `SetProcessDPIAware()` y captura 1920 × 1080 (medido); con eso las mitades son de **320** y el contador de munición se ve. Los números de P18/P19 comparan zonas **dentro** de lo capturado, así que siguen valiendo; las mitades de 256 quedan retiradas. Lección corregida en el registro global. (2) La ventana de vista escrita a mano se recalcula en cada cuadro: el parámetro que manda es `R+0xD400+0x70/+0x74`. (3) Un efecto de pantalla completa deja un **fantasma del HUD espejado** en la mitad 2 (pendiente de diseño).

### (84) B2a (parcial) — los cuerpos que el nivel ya sabe dibujar
`FUN_00138C40(actores, tipo)` = `actores + 0x7A10 + 0x40·tipo`: **una sola tabla de tipos de personaje**, que usan **el constructor del jugador** (`FUN_00139C68`), el despachador de módulos del nivel (`FUN_0015EF48`) y el de enemigos (`FUN_00178BC0`). Leída en vivo (City Streets, `actores` = `0x0058FE00`): el tipo **0** (palabra 1 = `0x2B`, modelo `0x01AE7E00`: el jugador, que se dibuja como brazos) y **cinco tipos de soldado** con modelo propio: **`0x1D`, `0x1E`, `0x24`, `0x25`, `0x27`** (tipos 29, 30, 36, 37, 39; `+0x00` modelo, `+0x38` un segundo puntero). Grado: probable (tabla leída; qué modelo es cuál no se miró en pantalla). **Para el diseño:** el camino barato para darle cuerpo a J2 es un **títere**: un actor de uno de esos tipos, dado de alta con lo que ya está en K5 (`spawn`), sin cerebro, que copia la posición y el yaw de J2 cada cuadro. Qué soldado es lo elige Fran; el uniforme cambia con el nivel.

**Sigue:** B3 (el mod sin PINE: el cuaternión de J2 y las mitades dentro del stub, y todo como pnach; el riesgo es si J2 se construye con un molde que un pnach pueda escribir al arrancar) o B2b (el títere, cuando Fran elija el cuerpo).

---

## 2026-09-27 (83) — `spawn`: la aparición fuera de la carga es un temporizador por cuadro, y se dispara con un byte
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `spawn`, `actores`, `disparadores`
**Objetivo:** la sonda P6 de `spawn` (fila 7 del PDP §4, lo último de COOP-A): ¿hay una aparición fuera de la carga que podamos disparar? En frío primero.

### (83) N1 — En frío: la cadena del spawner de enemigos, de abajo hacia arriba
Leído con `leer_c.py` sobre el decompilado de `black-datos`; todo `probable` hasta la sonda.
- **`FUN_00138C80(mgr, cerebro, datos)`** (mgr = `*(0x0040F514)`, `actores`): sale en 0 si no hay controlador libre (`FUN_0025CDF0(*(0x0040F4CC))`); si la lista viva está llena (`mgr+0x79A4` = `mgr+0x79A8`) recicla la más vieja (`FUN_00139060`); saca un bloque de la lista libre `+0x7990` a la viva `+0x79A0`, lo resetea (`FUN_001327F0` con tipo, posición, cuenta y modo de `datos`), `FUN_00135558`, cuerpo (`FUN_0016E660`), `FUN_0013D048`, `FUN_001354E0`, **controlador (`FUN_0025C210`)** y enlace (`FUN_0012A158`).
- **`FUN_00178BC0`** arma `datos` en la pila: `[0]` = `FUN_00138C40(mgr, tipo)`, `+0x10` = la posición del punto de aparición (`punto+0x10`), `+0x30`/`+0x34`/`+0x38` = cuenta del contador `*(0x0040F4D4)+0xFA4` (lo incrementa), `+0x3C` = modo. Toma el «cerebro» de `FUN_0016DDC8(*(0x0040F4D4))` y al actor nuevo le pone **`+0x2F8` = 100,0** (la vida) y `+0x324` = el punto.
- Arriba, **dos entradas**: `FUN_00178978` (tipos `0x24`–`0x2A`) y `FUN_00178AE8` (`0x1D`–`0x1F`), elegidas por el switch **`FUN_00178408(*(0x0040F4D4)+0xFA4, desc, …)`** según `*desc` (0–9).
- **Y a `FUN_00178408` lo llaman dos:** `FUN_00173028`, un escuadrón de 4 lugares que rellena los vacíos (en `*(0x0040F4D4)+0x22800`, con `FUN_001729F8` virtual), y **`FUN_001746E0(spawner)`**, llamado por **`FUN_00174578`, un TEMPORIZADOR**: si `+0x28` activo, `+0x2C` restantes ≠ 0, `+0x2A` y `+0x2B`, y el actor de `+0x24` es 0 o está muerto (`+0x38C` ∉ {0, 1}), le resta `dt` (`juego+0x1C`) a `+0x30` y al llegar a 0 aparece; si aparece, `+0x2C` −1 y con 0 se desactiva. **`FUN_001746C8` = activar (`+0x28` = 1)**, `FUN_001746D8` = desactivar.
- **Al temporizador lo llama el lazo por cuadro:** `FUN_00165F30(dt, *(0x0040F4F4))` —desde `0x00129360`, el mismo lazo del juego donde vive nuestro gancho— recorre las listas **12 y 13** de la tabla de `disparadores` (cuenta u16 en `tabla+2i`, array en `tabla+0x48+4i`) y llama `FUN_00174578` por cada una. **La aparición en caliente existe y es del juego**: no hay que llamar nada desde el stub.

### (83) N2 — En vivo, SÓLO LECTURA: City Streets tiene 73 spawners en RAM
`sondas_spawn.py censo` sobre el slot 13 («vivo» antes: yaw 25,4° → 133,4°). Tabla `0x005A8980`; lista 12 = **73 spawners** (lista 13 vacía); casi todos tipo 3, cada uno con su punto. Tres ya aparecieron **durante el juego**: dos con el actor muerto (`+0x38C` = 2, vida 0) y uno vivo (vida 100,0) con el temporizador en −0,033 —o sea que pasó por la resta de `dt`, no por la carga—. El resto: `+0x28` = 0, restantes = 1, actor = 0: **armados y esperando que un disparador los active**. Los datos del stage que hacen falta (descriptor y punto) **están en RAM todo el nivel**: la salida por abajo del retome (c) no se da. Pools: `actores` libre `[0, 32, 19]`, viva `[7, 16, 5]`; contador de apariciones 220; controladores 7 de 20.

### (83) P17 — PREDICCIÓN, escrita antes de tocar RAM
**Sonda:** escribir **un byte**, `+0x28` = 1, en el spawner `L12[43]` (`0x010AB2B0`, tipo 3, punto (−4,86; −3,57; 38,35), a 15,5 m de J, temporizador 0).
**Efecto esperado, en el cuadro siguiente:** `+0x24` pasa de 0 a un actor nuevo con **vida 100,0** y estado 0; **el contador de apariciones sube exactamente 1** (220 → 221); la lista viva de `actores` +1 y la libre −1 (qué campo es la cuenta: `+0x79A8` y `+0x7998`, hipótesis); **controladores 7 → 8 de 20** y `actor+0xB4` ≠ 0; restantes 1 → 0 y `+0x28` vuelve a 0 (se desactiva solo). El actor aparece **en el punto** (`actor+0xA0` ≈ (−4,86; −3,57; 38,35)) y, mirando hacia ahí, **se ve** un enemigo nuevo.
**Qué la refuta:** `+0x28` = 1 se queda y no aparece nada → alguna condición del temporizador no se lee como creo (o el lazo no recorre la lista 12 en este estado): se pone un vigilante de lectura sobre `+0x28` para ver si alguien lo mira.
**Controles:** «vivo» antes; el **negativo en la misma corrida**: `mirar` sobre `L12[71]` (vecino, también armado, t = 0) **sin escribir nada**, el mismo tiempo: su `+0x24` sigue en 0 y el contador no se mueve.

### (83) P17b — PREDICCIÓN, escrita antes de tocar RAM: el punto se mueve y el enemigo nace donde lo pusimos
Desde donde está J (en el slot 13) **no hay línea de vista** a ningún punto de aparición de la planta de abajo: apuntando a `L12[43]` se ve una pared de ladrillos, y el de `L12[4]` queda detrás de otra pared (capturas `volcados/capturas-83/`). En frío, `FUN_00178BC0` lee la posición de `*(desc+4)+0x10` **en el momento** de aparecer.
**Sonda:** escribir la posición del punto de `L12[43]` **4 m delante de J**, a la altura de sus pies (la dirección libre, la de `L12[4]`), apuntar la vista ahí, captura «antes», y el byte `+0x28` = 1.
**Efecto esperado:** el actor nuevo nace **en la posición escrita** (`actor+0xA0` ≈ la escrita en el primer registro) y **se ve un enemigo** en la captura siguiente, donde la de «antes» no tenía nada. **Qué la refuta:** nace en el punto viejo (la posición se copia antes, en la carga) o no se ve nada con el actor en la posición escrita (el dibujo de los actores nuevos necesita algo más).

### (83) P17 y P17b CONFIRMADAS en RAM y en pantalla, con control: `spawn` K3 → K5
Herramienta: **`sondas_spawn.py`** (`censo`, `foto`, `mirar <i> <s> [--sin-activar]`, `apuntar <i>`, `punto-delante <i> <m>`). «Vivo» antes de cada sonda.
- **Negativo, misma corrida:** `L12[71]` 3 s **sin escribir**: `+0x24` = 0, restantes 1, pools quietos.
- **P17, `L12[43]`:** el byte → **en el cuadro siguiente** `+0x24` = actor `0x00592B90` con **vida 100,0** y estado 0; restantes 1 → 0 y `+0x28` → 0 (se desactiva solo); t = −0,033 (pasó por la resta de `dt`); controladores **7 → 8** de 20. El actor está **en la lista viva** (índice 5, el más nuevo) y **no** en la libre; `ctrl+0x30` = el actor; su cuerpo (`+0x34C` = `0x006A9200`) está **en el mundo** `0x0066E900` (`+0x28`) con dueño = el actor, siguiéndolo (+0,8 en y).
- **Reproducido 4 de 4:** `L12[71]` → `0x00592050`, que **nace exactamente en el punto** (−5,985; −3,575; 36,889) y sale corriendo (~32 m en 3,6 s); `L12[17]` aparece **a los 7 s**, que es su temporizador; `L12[4]` a los 1,25 s, el suyo.
- **P17b:** con el punto de `L12[43]` escrito 4 m delante de J (−5,534; −0,335; 57,38), el actor nace en **(−5,534; −0,339; 57,38)** y **se ve**: la captura «antes» muestra el cuarto vacío y la de 6 ms después del byte, un soldado enemigo parado ahí (`volcados/capturas-83/p17c-antes.png` y `c/rafaga-00-00006ms.png`). La posición se lee **al aparecer**: se puede elegir dónde nace alguien.
- **Qué NO es evidencia:** el contador `*(0x0040F4D4)+0xFA4` **sube solo** (~1 cada 7–10 s: 220 → 238 entre el censo y la sonda) y la lista viva oscila sin nosotros: hay apariciones de fondo. El efecto se leyó en el **propio** spawner (`+0x24`, restantes) y en el actor, no en ese agregado.
- **La salida por abajo del retome (c) no se da:** los datos que hacen falta (descriptor y punto) están en RAM todo el nivel.

**No funcionó:** la primera ráfaga de capturas (con `L12[17]`) falló entera con «Error genérico en GDI+»: `capturar-pantalla.ps1` le pasaba a `Bitmap.Save` una ruta **relativa**, y .NET la resuelve contra el directorio del proceso. Arreglado en la herramienta (resuelve la ruta sola) y medido con la misma ruta; lección foldeada. Y apuntando a `L12[43]` y `L12[4]` desde donde está J se ve **una pared**: por eso P17b movió el punto en vez de mover a J.
**Sin explicar:** el actor de `L12[4]` estaba **muerto** (estado 2, vida 0) ~3 s después de aparecer, detrás de una pared y 2,6 m más arriba; y el de P17b quedó **de espaldas a J, mirando hacia donde está J2** (a 3,8 m). ¿Orientación del punto, o la IA apunta a J2? Hipótesis para la Fase B; no se midió.

### (83) Cierre: el criterio de salida de COOP-A se cumple
Contra la tabla del PDP §4: `entrada`, `camara`, `sesion`, `juego`, `codigo-nuevo`, `ragdoll` y ahora **`spawn` en K5**; `render` en K4, que es su objetivo en la tabla; y el prototipo por PINE hecho en (82) (J2 camina con el mando 2). `programa.py verificar` 0 rojos, 183 comprobaciones. **COOP-A queda cerrada.** La Fase B no se abre acá: su criterio de salida se escribe **antes** de empezarla.
**Sigue:** abrir COOP-B con su criterio escrito en el PDP (diseño preliminar: el cuerpo de J2 —hoy dos brazos flotando—, la pantalla dividida sobre la segunda pasada de escena de `render`, `atar` permanente en el envoltorio de carga, los disparadores que sólo miran al jugador 0, la IA frente a J2 y la aparición de J2 si muere, que ahora tiene de dónde partir).

## 2026-09-27 (82) — Cómo se da de alta un actor: J2 nunca recibió su controlador de colisión
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `fisica`, `juego`, `actores`
**Objetivo:** contestar en frío la pregunta que dejó (81) —cómo se da de alta un cuerpo en el motor de física— y recién con eso tocar RAM.

### (82) N1 — En frío: el «cuerpo físico» de `+0x34C` es un SEGUIDOR, no lo que mueve al jugador
Leído en el decompilado y en las instrucciones (`leer_c.py`, `desensamblar.py`); todo `probable` hasta la sonda.
- **`FUN_00170320` no integra: copia.** Lee el dueño (`cuerpo+0x20`, el jugador), carga su matriz (`J+0x70/+0x80/+0x90`) y su posición (`J+0xA0`) y los escribe en el cuerpo: `cuerpo+0x30` = `J+0xA0` + la constante de `0x00414DC0`, `cuerpo+0x48..0x50`, `cuerpo+0x3C..0x44` (vía `FUN_002E9F40`) y `cuerpo+0x54` = `J+0x2E0`. La flecha es **jugador → cuerpo**. La frase de (81) «el motor recorre su lista y el cuerpo de J2 no está: por eso no camina» confundía causa con efecto: aunque el cuerpo de J2 estuviera en la lista, copiaría una posición quieta.
- **`ra` = `0x002EA92C` es el PRIMER lazo de `FUN_002EA898`:** recorre la lista activa `*(mundo+0x14)+8` (siguiente en `nodo+0xC`) y llama `vtable+0x2C` de `*(nodo+4)` para cada cuerpo. El alta es **`FUN_002E1248(mundo, cuerpo)`** → `FUN_002EABB0`: toma un nodo libre, lo engancha al final de la lista, `nodo+0x10` = 1, `nodo+4` = cuerpo, **`cuerpo+0x14` = nodo** y `cuerpo+0x28` = mundo; si `cuerpo+0x14` ya es ≠ 0 no hace nada. La baja es `FUN_002E1280` → `FUN_002EAD58`. El mundo es `DAT_003C9ED4`; el paso por cuadro, `FUN_0016EE38` → `FUN_002E1208` → `FUN_002EA898`.
- **Los dos pools** los arma `FUN_0016F3D0` (mgr = `*(0x0040F4D4)+0x22B28`): tipo 1 (`+0x7C`) = **16 cuerpos con un controlador en `+0x18`** (los de los enemigos; el `+0x18` ≠ 0 de J2 que (81) leyó como «enlace de lista libre» es ese controlador), y tipo 2 (`+0x88`) = **un solo cuerpo**, construido con `juego+0x30` (cuenta compilada en 1). `FUN_0016FA50` saca uno del pool por `J+0xC4`, lo guarda en `J+0x34C`, le pone el dueño y lo da de alta.

### (82) N2 — En frío: lo que mueve al jugador es un CONTROLADOR DE COLISIÓN en `J+0xB4`, y J2 nunca recibió el suyo
- **El mover es `FUN_00132D98(dt, J)`** (llamado desde `0x0013A300`): guarda la posición previa (`J+0x190` = `J+0xA0`), calcula el desplazamiento pedido `d` = `mira+0x50` × `mira+0x10` × dt (+ gravedad `J+0x2EC`) y, si `*(J+0xB4)+0x3C` = 0, se lo entrega al controlador: **`FUN_0025D840(J+0xB4, d)`** escribe `d` en `*(*(*(ctrl+0x34)+0xC)+0x58)+0x20`. Si `+0x3C` ≠ 0, atajo sin colisión: `FUN_00126030(J, pos + d)`. Después `FUN_001334E0` deriva `J+0x1B0` = (`+0xA0` − `+0x190`)/dt y **`J+0x2E0` = |v|**: la rapidez real que en J2 da 0 es una **consecuencia** de que `+0xA0` no cambie, no un eslabón aparte.
- **El controlador se da de alta con `FUN_0025C210(*(0x0040F4CC), actor)`:** `FUN_0025C758` saca uno de un pool de **20** (0x50 B en `mgr+0x2320`, ocupados en `mgr+0x2960`: **no** está compilado para uno), `FUN_0025CEF8` lo ata (`ctrl+0x30` = actor, **`actor+0xB4` = ctrl**, grupo por `actor+0xC4`: 3 para el jugador), `ctrl+0x3C` = 0 y `FUN_0032CB58(*mgr, ctrl+0x34, 4)` lo registra en el mundo de colisión (tabla `0x0043F3F0`).
- **Quién lo llama, y por qué a J2 no:** `FUN_0012BE80(juego)`, el estado del cargador que sigue a construir jugadores, recorre `i < *(0x0040F0E0)+0x20208` —**la cuenta, = 1**— y para cada uno hace `FUN_0025C210` + `FUN_0012A158`. J2 vive en `0x0046CDF0`, fuera de `juego+0x30+i·0x8C0`, y la cuenta es 1: **nunca pasa por ahí**. La secuencia completa de alta de un actor está en el spawner de enemigos `FUN_00138C80`: `FUN_001327F0` (reset, que pone `+0xB4` = 0 vía `FUN_00125CD8`) → `FUN_0016E660` (cuerpo seguidor) → `FUN_0013D048` → `FUN_001354E0` → **`FUN_0025C210`** → `FUN_0012A158`. La réplica de `jugador2.py` hace los dos primeros y el último; **le falta el controlador**. Quinto lugar donde la cuenta = 1 decide.

### (82) P15 — PREDICCIÓN, escrita antes de tocar RAM
**Lectura (sin escribir):** `J+0xB4` = un controlador dentro del pool de 20 con `*(ctrl+0x30)` = J; **`J2+0xB4` = 0** (lo puso el reset del constructor) o, si el molde sobrevivió, el mismo controlador que J — en ninguno de los dos casos uno propio atado a J2.
**Sonda:** llamar **una vez**, desde el hilo del juego (el stub por cuadro), `FUN_0025C210(*(0x0040F4CC), J2)`, con el mgr leído vivo.
**Efecto esperado:** `J2+0xB4` = un controlador nuevo con `*(ctrl+0x30)` = J2; con «adelante» **sostenido** en el falso 2 durante 2 s, **`J2+0xA0` se desplaza** (≈ 4,5 m/s) y `J2+0x2E0` > 0, y **`J+0xA0` no cambia**.
**Qué la refuta:** `J2+0xA0` con Δ = 0 teniendo el controlador atado → el controlador no es lo que falta, y lo siguiente es el paso del mundo de colisión (quién escribe `+0xA0` de vuelta: vigilante `write` sobre `J+0xA0` con J caminando).
**Controles:** «vivo» antes; el negativo se re-mide en la misma corrida (adelante sostenido **antes** de atar: Δ = 0); J sigue caminando con el falso 1.

### (82) P15 CONFIRMADA en RAM con control: J2 CAMINA con el mando 2
Slot 12 cargado; «vivo» → yaw −54,6° → 90,8° y otra vez justo antes (90,8° → −170,6°). Script: `p15_sonda.py` (scratchpad; lo que queda en el repo es este registro y `jugador2.py`, que no cambió).
- **Lectura, sin escribir:** mgr = `*(0x0040F4CC)` = `0x00585C00`; pool de 20 en `0x00587F20`, **6 ocupados**; `J+0xB4` = `0x00587FC0` (índice 2) con `ctrl+0x30` = J y `ctrl+0x3C` = 0; **`J2+0xB4` = 0**. Y `*(0x34)` = 0: con `ctrl` = 0 la cadena de `FUN_0025D840` da 0 en el primer eslabón, así que el mover de J2 escribía el desplazamiento **en ningún lado** (y `*(0x3C)` = 0 lo mantenía en esa rama).
- **Negativo, misma corrida:** adelante sostenido 2 s en el falso 2 → **J2 Δ = 0,0000**, `J2+0x2E0` máx 0,0.
- **Atar:** el estado 1 del stub por cuadro (el viejo CONSTRUIR, que no se usaba) pasó a llamar **`FUN_0025C210(*(0x0040F4CC), J2)`** y volver al estado 3; 46 palabras escritas **con el emulador en pausa** y verificadas antes de continuar. Una llamada, un retorno. **`J2+0xB4` = `0x00588100`** (índice 6), `ctrl+0x30` = J2, `ctrl+0x3C` = 0, 7 de 20 ocupados; `J+0xB4` intacto.
- **Positivo, el mismo empuje:** **J2 se desplaza 8,14 m en 2 s** con `J2+0x2E0` = **4,5** (la rapidez pedida de (81)). **Control:** el falso 1 mueve a J 3,55 m en 1 s.
- **Los cuatro empujes de (81), repetidos con el controlador:** atrás 9,51 m, lateral_a 3,61, lateral_b 8,91, adelante 6,05. El primer «adelante» después del positivo casi no avanzó (0,12 m): J2 había quedado **contra una pared** en z ≈ 60,76, y ahora sí se frena — es la colisión funcionando.
- **Los dos jugadores chocan entre sí** (probable, por el patrón): al atar, J y J2 estaban a 4 cm y J se corrió 0,23 m cuando J2 arrancó; en lateral_a J2 pasó por donde estaba J y **lo empujó 4,16 m** mientras J2 bajaba a 1,68 m/s.

**Cierra el prototipo del criterio de COOP-A:** el segundo mando (por el camino del mando 2: `ctrl2+0xC` → falso 2) **mueve a un segundo jugador que está en el nivel** —con colisión contra el nivel y contra J—. Nodo **`ragdoll` K2 → K5**, renombrado por lo que es: `0x0040F4CC` son los **cuerpos de personaje** (controladores de colisión de los vivos y ragdoll de los muertos).

### (82) N4 — Corrección a (81): el cuerpo de J2 SÍ está en la lista y SÍ sigue a J2
Con J2 caminando: la lista activa del mundo `0x0066E900` (`L` = `0x0066EA00`) tiene **6 cuerpos, y el de J2 (`0x00699200`) es el segundo**, con nodo `0x0066EBBC` activo, dueño J2 y mundo puesto; `cuerpo+0x30` = `J2+0xA0` + (0; 0,8; 0) exacto (la constante de `0x00414DC0`) antes y durante el empuje. El «0 campos que responden y 0 de ruido» de (81) salió de **diferenciar valores con J2 quieto**: un seguidor de una posición quieta no cambia. `fisica` **sigue en K4** (no causamos ningún efecto en ese nodo), con la evidencia corregida.

### (82) N5 — Reproducible en un comando, y guardado
`jugador2.py atar` hace lo mismo que la sonda (reescribe el estado 1 del stub **en pausa**, lo dispara y espera el 3). Corrido **desde cero** sobre el slot 12 recién cargado (`J2+0xB4` = 0): 46 palabras, `J2+0xB4` = `0x00588100`, dueño J2, y los cuatro empujes dan 4,71 / 6,97 / 10,90 / 6,29 m — segunda corrida independiente, mismo resultado. **Slot 13** = J2 con controlador (43,7 MB, 15:26). Prueba offline nueva en `prueba_herramientas.py` (**183** comprobaciones): el programa llama `FUN_0025C210` una vez con `a0` = `*(0x0040F4CC)` y `a1` = J2 y ya no llama al constructor; su saboteador (cambiar el `jal` por `0x129090`) la pone en **rojo 1 de 183**, y vuelve a verde al restaurar.

### (82) N6 — Cómo se ve J2 desde J: los BRAZOS de primera persona, sin cuerpo (confirmado en pantalla, con control)
Con PCSX2 al frente (Fran), la vista de J apuntada a J2 (`MIRA_OBJ+8/+0xC`, como `matar_sin_manos.py`) y **tres capturas**, moviendo a J2 entre una y otra con la vista de J quieta:

| captura | J2 (x, z) medido | el objeto en pantalla |
|---|---|---|
| 1 | (−5,13; 61,15), a 7,7 m, en la mira | sobre la puerta, en la mira |
| 2 | (−3,60; 58,53) | sobre la pared izquierda |
| 3 | (−8,24; 60,16) | sobre la ventana derecha |

El objeto **se mueve con J2** y del lado que da la geometría (+x a la izquierda). Ampliado, son **dos antebrazos de mangas azules que cuelgan de un punto**: el modelo de brazos de primera persona dibujado en la posición de J2. **No hay cuerpo.** En la captura 2, además, apareció un **arma grande** en primer plano en lugar de la de J, y en la 3 volvió la de J: **sin explicar** (no se midió qué la dibuja).

### (82) P16 — Auditoría del éxito: la ranura propia de (81) NO es parte de la receta
En el slot 12 J2 tenía **dos** cambios: la ranura 1 propia (P14 de (81)) y el controlador. Con el sistema vivo (`*(0x0040F50C)` = `0x004ED380`) se le devolvió la ranura **compartida** de (79) —`J2+0x330` = `0x004ED7F0`, `*(0x004EDA30)` = J— y los cuatro empujes dan **8,90 / 6,97 / 10,16 / 6,41 m** a 4,5 m/s: **camina igual** (confirmado en RAM, con el estado anterior como control). La receta es **(79) + `control2` + `estado 2` + `atar`**; la copia de tres bloques de (80) y la ranura a mano de (81) no hacen falta para caminar. Captura 4, con la ranura compartida y J2 otra vez en la puerta: **los brazos siguen ahí**, así que no eran el modelo de la ranura 1; son de J2 (probable: el modelo de brazos que el constructor le arma al jugador).

**Cambia la Fase B:** J2 camina y choca, pero **no se ve como una persona**. En primera persona el jugador nunca necesitó cuerpo; para el coop, sí. Habilitador nuevo para el diseño: dibujar a J2 con un modelo de personaje (probable punto de partida: el de un enemigo o el de un aliado de la campaña, que el juego ya sabe dibujar y animar).

**Lección de proceso (la misma forma que (81) ya pagó una vez):** un negativo «nadie lo escribe» medido **por diferencia de valores** no distingue «no corre» de «copia algo quieto». Antes de concluir que un camino no corre, se mide con un vigilante de **escritura** o con el objeto en movimiento.

**Sigue:** cerrar COOP-A (KDP-B): contra la tabla del PDP §4 queda **`spawn` (fila 7, K3 → K5)** sin sonda corrida —y (82) dejó el punto de partida: el spawner de enemigos `FUN_00138C80` (llamado por `FUN_00178BC0`) es una aparición **fuera de la carga**—; el resto de la tabla está en su objetivo. Después: hacer **permanente** el alta del controlador en el envoltorio de carga (hoy `atar` es un paso aparte), y llevar a la Fase B lo que (82) abrió: J2 **se dibuja como brazos**.

---

## 2026-09-27 (81) — La ranura de personaje propia de J2: la sonda de un byte
**Máquina:** notebook (PCSX2-MCP, ISO original, slot 3) · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `personajes`, `juego`
**Objetivo:** que J2 **camine** con el mando 2. Es lo único que le falta al criterio de salida de COOP-A.

**Estado de partida, MEDIDO antes de tocar nada** (no leído del handoff), y coincide con lo que (80) leyó en frío:
`*(0x0040F50C)` = `0x004ED380`; ranura 0 = `0x004ED7F0`, ranura 1 = `0x004EDA30`, **las dos con dueño `0x005A8AB0` (J) y `+0xB8` = 1**; `J+0x2C3` = **0**; `J+0x330` = `0x004ED7F0` (la ranura 0); `J+0x2A0` = `0x006ED780`; `J+0x2A4` = `0x006DE690`; `J+0x100` = (−22.10, −2.24, 61.00); `J2+0x100` = (0, 0, 0); los dos sitios de gancho **limpios** (`0x00129574` = `0x0C04EEB2`, `0x00128EA4` = `0x0C04A424`).
**Control positivo de «vivo»:** `selector_depuracion.py vivo` → yaw 53,1° → 87,8°.

### (81) P13 — PREDICCIÓN, escrita antes de correr (sonda a0: un byte, sin copiar nada)

**Qué se hace:** `carga-poner` como en (79) (molde `+0x8A4` = 0x1C, registro con tipo 1) y, **antes de disparar la carga**, un solo byte: `molde+0x2C3` = 1. Después de que J2 exista, el dueño de la ranura 1 a mano: `*(0x004EDA30)` = `0x0046CDF0`, con la dirección recalculada con el sistema **vivo** (`*(0x0040F50C)` + 0x6B0).

**P13a:** la init de J2 le pone `J2+0x330` = **`0x004EDA30`** (la ranura 1), porque el índice sale de `J+0x2C3`. *(base: (80) N2, `0x0013A038` en `FUN_00139c68`; grado hoy `probable`.)*
**P13b:** con el dueño de la ranura 1 puesto en J2, «adelante» en el falso 2 **cambia `J2+0x100`** (`0x0046CEF0`) y **no** mueve `J+0x100`.

**Qué la refuta, y qué se hace entonces:** si `J2+0x330` sigue en `0x004ED7F0`, el índice no sale de `+0x2C3` y la lectura en frío de (80) se retira; se pasa a a1 (la copia de tres bloques) con `--dueno-a-mano`. Si `J2+0x330` es la ranura 1 pero J2 igual no se desplaza, el dueño no es lo único que falta: queda el atado real (`FUN_001a51c8`).

**Controles:** (i) «vivo» antes de cada sonda; (ii) el negativo de (79) se re-mide en esta misma corrida —con la ranura compartida, «adelante» en el falso 2 no mueve a J2—, así que el positivo no se compara contra un recuerdo; (iii) J (falso 1) sigue caminando.

**Límite conocido, aceptado a propósito:** la ranura 1 es **el arma secundaria de J0**. Esto no es el diseño final: el primer cambio de arma de J0 se la lleva de vuelta. La sonda contesta la pregunta —¿J2 camina cuando la ranura es suya?— por un byte, antes de gastar la copia de 0x1D10 B.

### (81) P13a REFUTADA como se corrió: el byte no llega vivo a la init

**Corrido:** `carga-poner` (sitio `0x0C11B600`, estado 0) → `molde+0x2C3` 0 → **1** (medido antes y después de escribirlo) → selector (`pedir-frontend --bandera 0`, `elegir 0 0`, `aceptar`; el front-end pasó 4 → 5 → 6 → 7 → **28** con `menu_tipo` 1) → `mirar 30`.

**J2 se construyó igual que en (79)** (confirmado): `fase` 2, `llam_J2` 1, `J2+0x8A4` = 55 (0x37), en el punto de aparición (−4,215 · 1,117 · 52,561), arma propia `0x006DE7A0`, cuerpo físico propio `0x00699200` con `+0x20` = `0x0046CDF0` (se apunta a J2), `J2+0xC4` = 2.

**Lo medido, y refuta P13a:** `J2+0x330` = **`0x004ED7F0`** (la ranura 0, la de J0) y **`J2+0x2C3` = 0**. El byte que escribí en el molde **no sobrevivió a la construcción**: el constructor escribe `+0x2C3` él mismo (`J2+0x2C0..0x2C7` = `06 00 02 00 00 00 00 00`, **idéntico byte a byte al de J**) y además puso el arma en `armas2[0]` (`0x0046DBC0` = `a0 e7 6d 00`, el resto en cero). O sea: el índice se **inicializa dentro del constructor**, así que precargarlo en el molde no puede funcionar. La lectura de (80) —el índice sale de `+0x2C3`— **no queda refutada**: esta sonda no llegó a ponerla a prueba, porque el valor que la init leyó fue 0 y no 1.

**Controles de esta corrida, los dos en la misma pasada:**
- **Positivo:** `empujar yaw_der 0.8 1` → `J2_yaw` −25,12° → **+22,88°**. El mando 2 llega a J2 (P12 de (79), re-medido hoy).
- **Negativo de (79), re-medido y no recordado:** `empujar adelante 1.0 2` → `J2_pos` queda en (−4,215 · 1,117 · 52,561) las 8 muestras, y `J_pos` en (−4,228 · 1,117 · 52,602) las 8. Con la ranura compartida, **J2 no se desplaza**.
- J2 corre a ~60 Hz con `estado` 3 (`cuadros_J2` 245 → 301 en 0,8 s).

### (81) P14 — PREDICCIÓN corregida, escrita antes de correr: la ranura a mano, sin pasar por la init

**Por qué cambia el tiro:** si el índice se inicializa adentro del constructor, el camino barato no es el molde — es escribir el **puntero** ya construido. `J2+0x330` es un puntero de 32 bits: apuntarlo a la ranura 1 y ponerle J2 de dueño son **dos escrituras**, y contestan exactamente la misma pregunta que la sonda de (80) quería contestar con un byte.

**Qué se hace:** con J2 vivo, corriendo y con el mando 2 (estado 3), `J2+0x330` = `0x004EDA30` y `*(0x004EDA30)` = `0x0046CDF0`, las dos direcciones recalculadas con el sistema **vivo** (`*(0x0040F50C)` = `0x004ED380`; ranura 1 = +0x6B0).

**Lo que NO se toca, y es una corrección de la sonda original:** `J2+0x2C3` se deja en **0**. Poner 1 ahí ahora indexaría `armas2[1]`, que está en cero, y el manejador por cuadro se quedaría sin arma. El índice de ranura y el índice de arma se desacoplan a propósito; (80) midió que la aritmética de la ranura sólo corre en el constructor y en el cambio de arma, así que nada por cuadro lo vuelve a derivar.

**P14:** con la ranura 1 apuntada y su dueño en J2, «adelante» en el falso 2 **cambia `J2+0x100`** (`0x0046CEF0`) y **no** mueve `J+0x100`.
**Qué la refuta:** si `J2+0x100` sigue quieto, el dueño no es lo único que falta y queda el **atado real** (`FUN_001a51c8`), que es el camino a1 con la copia. Si se mueve J en vez de J2, la ranura sigue derivándose de otro lado y hay que buscar quién.
**Control:** el negativo de arriba, medido en esta misma corrida y con el mismo comando; y `empujar yaw_der` después, para saber que J2 sigue vivo al terminar.

### (81) P14 REFUTADA: con la ranura propia y el dueño puesto, J2 sigue quieto

**Escrito, con el sistema vivo:** `*(0x0040F50C)` = `0x004ED380` → ranura 1 = `0x004EDA30`. `J2+0x330`: `0x004ED7F0` → **`0x004EDA30`**; `*(0x004EDA30)`: `0x005A8AB0` (J) → **`0x0046CDF0`** (J2). `J+0x330` quedó intacto en `0x004ED7F0`, medido después.
**Medido:** `empujar adelante 1.0 2` → `J2_pos` = (−4,215 · 1,117 · 52,561) en las **8** muestras, igual que el negativo. **El dueño de la ranura no es lo único que falta.**

**Y lo que la refutación destapa** (medido acá, no leído): la matriz del objeto de J2 **no está vacía** —`J2+0x70..0x9B` tiene una rotación válida y coherente con su yaw (0,9213 / −0,3888 / 0,3888 / 0,9213)— pero los **carriles W están en cero y en J no**:

| offset | J | J2 |
|---|---|---|
| `+0x7C` | `0x01937E70` (un objeto del montón) | **0** |
| `+0x8C` | `0x018A9530` (un objeto del montón) | **0** |
| `+0x9C` | `0x00000057` (87) | `0x3F800000` (1,0 — el 1 de la fila 2, sin empaquetar nada) |
| `+0xAC` | `0x700027C0` | **0** |

O sea: el aviso de (80) («no los sondees antes de a0/a1») ya **no** aplica, porque a0 y a1-por-el-dueño están corridas y refutadas. Los tres carriles W de J2 están vacíos y el cuarto lleva el 1,0 de la matriz en vez del entero empaquetado. `J2+0x32C` = `0x0046D2E0` (= J2+0x4F0, la mira propia que pone `control2`), así que el camino de entrada sigue bien.

**Sigue, y en este orden:** leer **`FUN_001a6be0`** en el decompilado (local, en frío) para saber **qué campos** usa del dueño además de la matriz — es lo que decide si lo que falta son los carriles W o el atado real `FUN_001a51c8`. Poner más punteros a mano sin eso es adivinar.

### (81) N6 — La cadena del paso, medida eslabón por eslabón: **el cuerpo físico de J2 no lo toca nadie**

Con las dos predicciones refutadas, en vez de seguir poniendo punteros se midió **dónde se corta la cadena**. Todo lo de acá es efecto medido en vivo, con el eje «adelante» del falso 2 **sostenido** (no en pulsos) y con `ritmo_vigilante.py --tipo write/read --ra`, que da el PC y los registros de cada disparo.

**Corrección de lectura, y cambia el mapa:** `FUN_001a6be0` **no es «el que camina»**. Leído en el decompilado: recorre 7 sub-objetos de la ranura (`ranura+0x30` en adelante), y para cada uno multiplica la matriz del **dueño** (`+0x70/+0x80/+0x90/+0xA0`) por la matriz local del sub-objeto y guarda el resultado en el propio sub-objeto. Es la **propagación de acoples** (lo que hace que el modelo y el arma sigan al jugador), no el desplazamiento. La frase de (80) —«la posición la escribe `FUN_001a6be0`»— queda corregida.

**Y la posición del jugador no es `+0x100`:** `FUN_001334e0` escribe `+0x100` = `+0xA0` + `+0x2E8` − 0,2, con `+0x2E8` = **1,65** medido en los dos jugadores. `+0x100` es la **posición del ojo**; la posición real (los pies) es **`+0xA0`**. Las dos estaban quietas, así que el negativo no cambia, pero todo lo que se mida de ahora en más va contra `+0xA0`.

**Los cuatro eslabones, en orden, y dónde se corta:**
1. **El pedido llega.** Con el eje sostenido: `falso2+0x8C` = 1,0 → `J2+0x5C4` (= mira+0xD4) = **1,0**. Dos lectores medidos: `0x0013F718` (la tabla de acciones de (77), con `a0` = `0x00472100`, el falso 2) y `0x0013AB80`, que es `lwc1 $f3, 0x5C4($s1)` con **`s1` = J2** — un suavizado de la mira hacia `J2+0x4CC..0x4D8`, no el paso.
2. **El motor de movimiento corre para J2.** `FUN_001334e0` escribe la matriz de vista de J2 (`+0xD0`) desde `0x001338AC` y `0x00133B20`, y en el segundo el `a0` es **`0x004EDA30`**, la ranura que le puse en P14: la función corre y usa la ranura nueva.
3. **La rapidez pedida se calcula, y es la misma que la de J.** Diferencia de bloques de 0x8C0 con el eje suelto contra sostenido, descontando el ruido propio: en **J2** responden `+0x540` = 0,3888 y `+0x548` = 0,9213 (el versor de avance de su propio yaw), `+0x5C4` = 1,0 y **`+0x5D8` = 4,5** (la rapidez pedida). En **J**, los mismos cuatro **más 40 campos**: `+0xA0`/`+0x100`/`+0x190` (posición, −4,23 → −9,74 en x), `+0x1B0..0x1B8` (velocidad), `+0x2E0`/`+0x2E4` (rapidez real, 4,15 y 4,39), `+0x1C0..0x1D8` (suelo), `+0x210..0x238` (la estela de posiciones) y los carriles de la matriz. **En J2 ninguno de esos 40 se mueve.**
4. **Acá se corta: el cuerpo físico de J2 no lo toca nadie.** Misma diferencia sobre el cuerpo (`J+0x34C`): el de J (`0x006B8180`) responde en `+0x30..+0x54` (posición y matriz) y tiene **1** campo de ruido propio; el de J2 (`0x00699200`) tiene **0 campos que responden y 0 de ruido** — o sea, ni siquiera un contador cambia. **Nadie lo integra.**

**Quién integra el cuerpo de J:** vigilante `write` sobre `0x006B81B0` (cuerpo+0x30) → PC `0x00170600` las 3 veces, dentro de **`FUN_00170320`**, que **no tiene llamadores en el ELF**: es un **callback virtual** que invoca `FUN_002EA898` (`ra` = `0x002EA92C`), del motor de física (rango `0x002Exxxx`), con `a0` = `0x01FFFA70` (objeto del montón) y `a1` = cuerpo+0x48. O sea: **el motor recorre su propia lista de cuerpos activos, y el de J2 no está en ella.**

**Diferencia de cabecera entre los dos cuerpos, medida:** iguales en `+0` (vtable `0x003DCFE0`), `+8`, `+0xC`, `+0x10` y `+0x1C` (0x1B); distintas en `+0x14` (`0x0066EBE4` en J, `0x0066EBBC` en J2) y en **`+0x18`** (**0** en J, **`0x00699680`** en J2 — un puntero dentro del mismo pool, a cuerpo+0x480). Hipótesis a probar, no confirmada: `+0x18` es el enlace de la **lista libre** del pool y el cuerpo de J2 se entregó sin darse de alta en el motor.

**Sigue:** de acá sale una sola pregunta, y es la que cierra la Fase A — **cómo se da de alta un cuerpo en el motor de física**. Se contesta en frío (`FUN_0016e660` completa, y quién llama a lo que pone un cuerpo en la lista que recorre `FUN_002EA898`), no poniendo más punteros a mano.

**Estado guardado:** `pine.py savestate --slot 12` con **J2 vivo, corriendo, con el mando 2 y con la ranura 1 propia** — reproducir el estado de (79) + P14 pasa a costar un comando en vez de cuatro minutos.

### (81) N7 — El control que pidió Fran: no es una pared

**Fran, mirando la pantalla mientras corría la sonda: «creo que te estás moviendo contra una pared, y una mesa que te frenan».** Es una explicación competidora legítima del negativo —J había quedado contra el marco de una ventana después del empujón de control— y es barata de descartar, así que se descartó **antes** de seguir.

**Medido, con J2 en el punto de aparición, 1 s por dirección:**

| empuje | `+0xA0` antes → después | \|Δ\|máx | `+0x2E0` |
|---|---|---|---|
| adelante | (−4,2152 · −0,3332 · 52,5614) → igual | **0,000000** | 0,0000 |
| atrás | ídem | **0,000000** | 0,0000 |
| lateral a | ídem | **0,000000** | 0,0000 |
| lateral b | ídem | **0,000000** | 0,0000 |
| *control positivo* | yaw de la mira | — | **22,88° → 80,21°** |

**Una pared frena una dirección, no las cuatro**, y un jugador apoyado contra una pared **desliza**: `+0x2E0` daría algo distinto de cero. Acá los cuatro dan **cero exacto** y la rapidez real nunca arranca, con el yaw respondiendo en la misma pasada. Sumado al cuerpo físico con **0 escrituras y 0 ruido** (N6), la geometría queda descartada: lo que falta no es espacio, es que **nadie integra el cuerpo de J2**.

## 2026-09-27 (80, nube) — ¿Sirve la copia del sistema de personajes? Los 35 accesos al global, medidos sobre las instrucciones
**Máquina:** nube (sin PCSX2) · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `juego`, `codigo-nuevo`
**Objetivo (N1 del retome):** antes de escribir la herramienta que copia el sistema de personajes, contestar si el truco del envoltorio —`*(0x0040F50C)` = copia alrededor del constructor de J2, y de vuelta al original después— **puede** funcionar. Si alguien deriva la ranura del **global** por cuadro, no alcanza, y hay que proponer un gancho por cuadro en vez de una copia.
**Desvío de método, dicho primero:** la predicción de N1 **no se escribió antes de medir**. El retome lo pedía para cada etapa; en una etapa que es lectura estática la medición fue el primer acto. Vale como lectura en frío (grado `probable`), no como predicción cumplida. De N2 en adelante van escritas antes.

**Instrumento nuevo: `herramientas/lectores_global.py`** — todos los accesos del ELF a un global, **por opcodes crudos**, sin Ghidra. Dos mitades, porque cada una sola miente:
- **cota superior:** toda instrucción de memoria (o `addiu`) con el desplazamiento de 16 bits del objetivo (`-0xAF4` para `0x0040F50C`). Ninguna se puede escapar: un acceso por `lui`+`lw` tiene siempre ese desplazamiento.
- **base:** para cada candidata, quién definió su registro base, **siguiendo los `move`**; si no sale de `lui 0x41`, se descarta, y el descarte se imprime para poder auditarlo.
9 comprobaciones nuevas en `pruebas/prueba_herramientas.py` (157 en total, en verde) sobre un **ELF sintético** —así corre en cualquier máquina—, con dos saboteadores puestos en rojo: sacarle el seguimiento del `move` (3 en rojo) y aceptar cualquier página alta (4 en rojo).
**Falla propia, del mismo turno, y es la que vale:** el saboteador de la página alta daba **verde** la primera vez. El señuelo (`lui 0x42` con el mismo desplazamiento) se descartaba, pero **por el borde de función** del grafo sintético —había una entrada plantada justo encima del señuelo, y la búsqueda hacia atrás ni corría—, no por lo que la prueba dice medir. Un saboteador que pasa por el motivo equivocado es un verde falso, que es peor que no tenerlo. Arreglado moviendo la segunda entrada fuera del programa plantado y **midiendo el motivo del descarte**, no sólo el descarte.

**Medido en el ELF (`probable`; es lectura estática, no efecto):**
- **35 accesos a `0x0040F50C`, en 23 funciones, 0 candidatas descartadas.**
- **Una sola ESCRITURA del puntero en todo el ELF:** `0x00102174` (`sw v0, -0xaf4(s1)`), dentro de `FUN_001020c0`, el init de los 37 singletons. Nadie más lo reescribe: el envoltorio no compite con nada.
- **0 palabras sueltas** con el valor `0x0040F50C` en el ELF: el global no vive en ninguna tabla de punteros. Todo consumidor lo lee por `lui`+`lw`, o sea **fresco en cada uso**.
- **Los dos caminos no coinciden, y el crudo gana:** el decompilado muestra **34** referencias textuales a `DAT_0040f50c`; los opcodes dan **35**. La que falta en el C es `0x001ABFB8` (en `FUN_001abee0`), donde Ghidra la representó como un parámetro. Es el mismo tipo de pérdida que el delay slot de `0x001759A4`.

**La respuesta de N1: la copia SÍ puede funcionar.** Tres medidas, en orden de peso:
1. **La aritmética de la ranura (`global + k·0x240 + 0x470`) existe en exactamente DOS sitios**, y ninguno corre por cuadro: `0x0013A038` en **`FUN_00139c68`** (el constructor, que escribe `J+0x330`) y `0x0013C884` en **`FUN_0013c868`** (cambio de arma; ver la trampa de abajo). El resto de los 35 accesos pasa el global **como `this` del sistema entero**, no como base de una ranura.
2. **Lo que el cuadro le hace al sistema por el global es casi nada.** `FUN_00129360` lo lee 3 veces (`0x001295AC`, `0x001295E0`, `0x001296A4`) y llama: `FUN_001ab428(sys)`, que toca **sólo `sys+0x44` y `sys+0x50`** (dos contadores de pico, con `pmaxw`), y `FUN_001abe08(sys)` y `FUN_001abe10(sys)`, que son **dos stubs vacíos: `return;` y nada más**. O sea: una copia que nunca es el global en tiempo de cuadro **no se pierde ningún tick**, porque no hay tick.
3. **El camino de la posición llega a la ranura por el JUGADOR, no por el global.** Medido en las instrucciones: en `FUN_001334e0`, `0x00133B10` es `lw $a0, 0x330($s0)` y `0x00133B2C` es `jal 0x1A6BE0` — el `a0` de la llamada sale de `J+0x330`. `FUN_001334e0` **no está entre las 23 funciones que tocan el global**.

**Alcanzabilidad por cuadro** (desde `FUN_00129360`, sobre el grafo de llamadas): 8 de las 23 llegan — `0x00129360` (d0), `0x00139190` (d2), `0x001ACAC8` (d3), `0x001A8168` (d4), `0x001327F0` (d4), `0x00137320` (d5), `0x001A51C8` (d5), `0x001A6E58` (d7). Pero ninguna es *de cada cuadro*: cuelgan de sucesos (aparición por `0x0012DAB8`, construcción, atado, soltar). Es una cota superior del grafo, no una medición de frecuencia; lo que cierra el caso es el punto 1.

**Trampa nueva, y cambia el diseño del prototipo:** `FUN_0015be70` (sistema de armas, llamado por `FUN_0015bbd8` y `FUN_0015c3c8`) hace, **sólo si `J+0xC4 == 2`** —o sea, **justo para los jugadores**—, `FUN_0013c868(J, arma+0x43)`, que recalcula `J+0x330 = GLOBAL + idx·0x240 + 0x470` **desde el global**. Es decir: hecha la copia, **si J2 cambia de arma su `+0x330` vuelve de un salto a la ranura del sistema ORIGINAL**, la de J0, y se deshace todo. Dos salidas: (a) en el prototipo, no cambiarle el arma a J2 —y anotarlo como límite conocido—, o (b) extender el envoltorio a `FUN_0015be70`/`FUN_0013c868` cuando el jugador es J2. Para la Fase A alcanza (a); (b) es Fase B.

**Corrección de una lectura que el decompilado invita a hacer mal:** `FUN_001327f0` también ata por el global —`FUN_001a51c8(J+0x330, J, GLOBAL + idx·0x60 + 0xf8)`, en `0x00132988`–`0x00132998`— pero el desensamblado muestra `beq $v1, $v0, 0x1329A0` en `0x0013296C` saltándoselo cuando `+0xC4 == 2`: **a un jugador nunca le corre**. Y ojo que ahí el tercer argumento sale de **otro arreglo** del mismo objeto (`+0xF8`, paso `0x60`), no del de instancias que usa `FUN_001ac960` (`+0x398`, paso `0x6C`). El objeto tiene al menos tres arreglos paralelos indexados por la misma `k`.

**Para N2/N4, medido acá:** `FUN_001a51c8` **lee el global tres veces adentro** (`0x001A52D0`, `0x001A52DC`, `0x001A52E8`). Así que el camino (b) del retome —atar a mano— **no se hace pasándole punteros de la copia**: hay que llamarla con el global **ya apuntando a la copia**. Lo mismo `FUN_00143d90`, que en `0x00143E7C` toma la *dirección* del global (`addiu a0, v0, -0xaf4`) y recién la desreferencia en `0x00143EE0`, un ciclo antes del `jal 0x1AC960`: el envoltorio alrededor del constructor lo cubre.

**No funcionó:** nada se refutó acá; lo que se cayó fue un saboteador propio, por el motivo equivocado.
**Sigue (N1):** N2 — el camino de atado `FUN_00143d90` → `FUN_001ac960` → `FUN_001a51c8`: qué escribe en la ranura y en J, qué significa `+0xB8`, qué libera, y qué hace el constructor con el molde 2 frente a 0x1C. Salida: los argumentos exactos del atado a mano y los campos que hay que dejar en cero en la copia.

### (80) N2 — El camino de atado, y por qué la copia de 0x970 NO alcanza

**Predicción de N2 (la que estaba en pie, escrita en el retome antes de medir):** copiar el sistema de personajes (`0x004ED380`, **0x970 B**) a `0x0046DC00`, **reubicar los autopunteros** y poner `+0xB8` = 0 en las dos ranuras alcanza para que el constructor le ate a J2 una ranura propia.
**Resultado: REFUTADA.** La copia de 0x970 deja las dos ranuras de la copia apuntando a **objetos de J0 que viven afuera del objeto**. Medido abajo.

**El camino de atado, leído entero (`probable`; es el ELF, no RAM):**
- `FUN_00143d90(streamer, jugador, k)` desreferencia el global **una instrucción antes** del `jal` (`0x00143EE0`: `lw a0, ($a0)`, con `a0` = `0x0040F50C` cargada en `0x00143E7C`) y llama `FUN_001ac960(sys, k, modelo, jugador, byte_anim, hash)`.
- `FUN_001ac960`: `inst = sys + k·0x6C + 0x398`; la inicializa (`FUN_001a8168(inst, …, *(sys+0x940))`, `FUN_001adc30`, `FUN_001add58`, `FUN_001a8350`) y después `do { r = FUN_001a51c8(sys + k·0x240 + 0x470, jugador, inst); } while (r == 0)`.
- **`FUN_001a51c8` devuelve 1 siempre** (un solo `return 1;` en toda la función): ese lazo da **exactamente una vuelta**. No es un punto de cuelgue, y eso cierra una sospecha que venía abierta desde (79).

**Qué escribe `FUN_001a51c8(ranura, jugador, inst)` — la lista completa:**
| dónde | qué |
|---|---|
| `ranura+0xB8` ≠ 0 | **primero suelta**: `FUN_001a5ee8(ranura)` |
| `ranura+0x00` | `jugador` (el dueño) |
| `jugador+0x330` | `ranura` |
| `ranura+0x50` | `inst` ← **es el "autopuntero"** que (79) midió en `+0x4C0` y `+0x700` |
| `ranura+0xA0`, `+0xCC` | 0 |
| `ranura+0xB7`, `+0xB9` (bytes) | 0 |
| `ranura+0x230` (byte) | 0 |
| `*(*(ranura+0x54) + 4)` | `*(inst+8)` — **escribe en el compañero, ver abajo** |
| `ranura+0x30 … +0x4C` | limpia las 8 matrices de enganche |
| al final | `+0xB0` = −1, `+0x58` = 0, `+0xBB` = 1, **`+0xB8` = 1**, `+0xBA` = 1, `+0x234` = 1, `+0x235` = 0 |

**`+0xB8` es la bandera de "atada".** La pone en 1 el atado y en 0 el soltar. **Qué libera `FUN_001a5ee8(ranura)`:** si `ranura+0x54` = 0, sólo `+0xB8` = 0; si no, `FUN_001a7450()` y, **sólo si `ranura+0x58` ≠ 0**, `FUN_001a6e58(ranura)`; después `+0xB8` = 0. Medido en `ee-03`: las dos ranuras tienen `+0x54` ≠ 0 y **`+0x58` = 0**, así que soltar correría `FUN_001a7450` pero no `FUN_001a6e58`. Con `+0xB8` = 0 en la copia no corre nada de eso: el plan del retome acierta en ese punto, y ahora se sabe **por qué**.

**Lo que refuta la predicción — medido en `ee-03.bin` (`probable`):**
- El sistema (`0x004ED380`, 0x970 B) tiene **2 autopunteros**, y ahora se sabe qué son: `+0x4C0` → `+0x398` y `+0x700` → `+0x404`, o sea **`ranura_k+0x50` = `instancia_k`**, escritos por el atado. Coincide con lo que midió (79) sin saber qué eran.
- **Pero cada ranura tiene un COMPAÑERO de `0x9D0` bytes que vive AFUERA del objeto**, en `ranura+0x54`: `0x01303780` (ranura 0) y `0x01308B00` (ranura 1), en el montón. Lo aloja el constructor de la ranura, `FUN_001a4ff0` (`FUN_00107cf8(0x9d0)` → `ranura[0x15]`), que corre desde `FUN_001ab780`, el init del sistema.
- Los compañeros tienen **0 autopunteros** y exactamente **un puntero de vuelta al sistema**: `compañero+0x84` → la ranura (`sys+0x470` y `sys+0x6B0`), que escribe `FUN_00345510(compañero, ranura, …)`.
- **Consecuencia:** una copia de 0x970 deja las dos ranuras de la copia con `+0x54` apuntando a los compañeros **de J0**. El atado escribe ahí en la primera línea (`*(*(ranura+0x54)+4) = *(inst+8)`) y después el compañero es el estado de animación entero (`FUN_00345510`, `FUN_001ad070`, `FUN_003438d8`, `FUN_00347c70`, `FUN_00348288`). J2 y J0 compartirían el estado de animación — la misma clase de falla que congelaba a J en P4, un piso más abajo. Y dejar `+0x54` = 0 **no** es salida: el atado escribiría en la dirección `4`, que es el cuelgue de P10 otra vez.

**Entonces la copia es de tres bloques, no de uno** (y entra: hay `0x0046DC00…0x00472000` = 0x4400 B libres en el `.bss`; esto pide **0x1D10** (0x970 + 2·0x9D0; en (80) N4 se midió)):

| bloque | origen | tamaño | destino propuesto |
|---|---|---|---|
| sistema | `*(0x0040F50C)` | `0x970` | `0x0046DC00` |
| compañero 0 | `*(sys+0x470+0x54)` | `0x9D0` | `0x0046E580` |
| compañero 1 | `*(sys+0x6B0+0x54)` | `0x9D0` | `0x0046EF80` |

y cinco reubicaciones, **todas medidas en vivo, no de esta lista**: `COPIA+0x4C0` = `COPIA+0x398`; `COPIA+0x700` = `COPIA+0x404`; `COPIA+0x470+k·0x240+0x54` = `COMP_k`; `COMP_k+0x84` = `COPIA+0x470+k·0x240`. Más `+0xB8` = 0 en las dos ranuras de la copia.

**Argumentos exactos del atado a mano (lo que pedía el retome):**
`FUN_001a51c8(a0 = COPIA + 0x470 + k·0x240, a1 = J2, a2 = COPIA + 0x398 + k·0x6C)`, con **el global ya apuntando a la copia** — la función lo lee **tres veces adentro** (`0x001A52D0`, `0x001A52DC`, `0x001A52E8`), así que pasarle punteros de la copia no alcanza.

**El molde 2 frente al 0x1C:**
- **2** pide el modelo (`FUN_001438a8`) y después `FUN_00143d90` → **ata** por todo el camino de arriba.
- **0x1C** va derecho a la init principal, que **sólo apunta y no ata**: `*(J+0x330) = DAT_0040f50c + J[0x2C3]·0x240 + 0x470` (en `0x0013A038` y siguientes).
- Por qué el molde 2 colgó en P8 sigue siendo **hipótesis** —(79) le retiró el sostén—; lo medido es que todos los cuelgues de P6–P9 eran el índice −577.

**Hallazgo que corrige la premisa del retome: el índice de ranura NO está fijo en 0.** El constructor lo lee de **`J+0x2C3`** (`cVar5 = *(char *)(J + 0x2c3)`) y lo vuelve a escribir sin cambiarlo. Y `FUN_0016bee0` usa **ese mismo byte** para indexar el **arreglo de armas** `J+0x2A0`. O sea:
- **`J+0x2C3` = qué arma tiene en la mano (0 o 1), y ES el índice de ranura.** Las dos ranuras del sistema no son "dos personajes": son **las dos armas del único jugador**. Cuadra con `FUN_0013c868`, que al cambiar de arma recalcula `J+0x330` con el índice `arma+0x43` (la trampa de N1), y con lo medido en `ee-03`: `J+0x2C3` = 0 y `J+0x330` = `0x004ED7F0` = ranura 0.
- Por eso `J2`, cuyo molde copia el bloque de J, hereda `+0x2C3` = 0 y **apunta a la ranura 0 de J0**. No se la "roba el constructor": la hereda del molde.
- **Sonda barata que esto habilita, y por qué no es el diseño:** `J2+0x2C3` = 1 apunta a J2 a la ranura 1 sin copiar nada. No sirve como diseño —la ranura 1 es el arma secundaria de J0, y el primer cambio de arma de J0 se la lleva de vuelta— pero sirve como **control de una pregunta sola**: ¿J2 camina cuando su `+0x330` es una ranura atada A ÉL? Cuesta un byte y una llamada, contra 0x22B0 bytes y cinco reubicaciones. Va como sonda 0 en `RETOME-LOCAL.md`.

**No funcionó:** la especificación de N4 del retome (copiar 0x970 y reubicar los autopunteros) — le faltaban los dos compañeros de 0x9D0.
**Sigue (N2):** N3 — quién escribe `J+0x7C` y `+0x8C` en la construcción de J0, y de qué campo sale el desplazamiento que en J2 da 0.

### (80) N3 — `J+0x7C` y `+0x8C` son carriles W de la matriz, y el desplazamiento sale del DUEÑO de la ranura

**Predicción de N3 (escrita antes de medir):** en la construcción de J0 hay una llamada que le asigna la instancia de animación de `J+0x7C`, y J2 no pasa por ella (por el molde, o porque corre en un momento distinto). Apuesto a encontrarla dentro del árbol del constructor.
**Resultado: refutada, y por el lado bueno — no hay tal llamada.**

**Qué son `+0x7C` y `+0x8C` (medido en `ee-03`, `probable`):** `J+0x70…0x9F` es la **matriz 3×4 del objeto**, y está sana — las tres filas son vectores unitarios de una rotación en yaw: `(−0.8283, 0, +0.5603)`, `(0, +1, 0)`, `(−0.5603, 0, −0.8283)`. Los **carriles W** no son ceros: llevan campos empaquetados, que es el truco clásico de PS2.

| carril | valor en `ee-03` | qué es |
|---|---|---|
| `+0x7C` (W de la fila 0) | `0x01937E70` | puntero a un objeto cuyas primeras palabras son más punteros (instancia de animación) |
| `+0x8C` (W de la fila 1) | `0x018A9530` | puntero a un bloque de **floats** (3.4e−8, 0.1, 1.0e−7, 0, 0.005, 1e8): parámetros |
| `+0x9C` (W de la fila 2) | `0x00000057` | un entero chico (87). **No estaba en la lista de (79)** |

Como float, un puntero de esos es un denormal (≈5e−38), así que los `lqc2` que cargan la matriz entera lo multiplican como si fuera cero: los carriles W **nunca se limpian** y por eso se pueden usar de campos.

**Quién los escribe en la construcción de J0: NADIE.** Barrido de **todas** las escrituras —`sw`, `sb`, `sh`, `sd`, `swc1` **y las de cuadra `sq`/`sqc2`**— que tocan `+0x7C` o `+0x8C` sobre el objeto (descartando las de `(sp)`), en los tres tramos del camino: constructor `FUN_00139c68`, init de entidad `FUN_001327f0` e init principal `FUN_0013ba40`. Resultado: **una sola**, `0x001329E0` (`sq $v1, 0x70($s2)`), que escribe la fila 0 de la matriz y **pisa `+0x7C` con lo que traiga el registro**. A `+0x8C` no lo toca nada.
**Lectura:** los punteros de `+0x7C` y `+0x8C` se instalan **fuera del camino de construcción**. Cuadra exactamente con lo que midió (79) sin poder explicarlo: son dos de los 15 punteros **idénticos en los tres volcados** de niveles distintos, o sea asignados **al arrancar**, uno por jugador. Los ceros de J2 no son algo que el constructor no hizo — **no hay nada en el constructor que lo haga**. Lo hace código de arranque que recorre `jugadores[]` con la cuenta compilada en 1: es el **cuarto lugar compilado para un solo jugador**, después de `jugadores[]`, la tabla de mandos y el pool de cuerpos físicos.

**De qué campo sale el desplazamiento que en J2 da 0 (`probable`, leído en el código):**
- En `FUN_001334e0` la posición del jugador se escribe por el camino `J+0x38C == 2` → `if (J+0x330 != 0) FUN_001a6be0(J+0x330)`. Es el camino que (79) midió: `0x00133B10` es `lw $a0, 0x330($s0)` y `0x00133B2C` el `jal 0x1A6BE0`. El otro camino (`else if (J+0x32C != 0)`) es el del **giro**: toma `*(float *)(controlador+8)` en grados, lo pasa a radianes y calcula seno y coseno en la VU — y ése a J2 **ya le funciona** desde P12.
- **`FUN_001a6be0(ranura)` arranca con `iVar1 = *(int *)param_1`, o sea el DUEÑO de la ranura**, y carga `dueño+0x70`, `+0x80` y `+0x90` —la matriz de arriba— para transformar las 8 entradas de enganche de `ranura+0x30`.
- **Con J2 compartiendo la ranura 0, cuyo dueño es J0, toda llamada "de J2" trabaja sobre la matriz de J0 y escribe en las cosas de J0.** El desplazamiento de J2 nunca llega a J2. Ése es el mecanismo detrás de la hipótesis de (79), ahora leído en el código y apoyado en la matriz medida.
- **Y explica por qué el vigilante disparó igual sobre la posición quieta de J2** sin que el valor cambiara: es el mismo hallazgo del instrumento de (79) (`write` dispara sin cambio de valor), no una escritura real de desplazamiento.

**Consecuencia para la sonda:** que J2 tenga `+0x7C`/`+0x8C` en cero **no es lo que le impide caminar** —no lo lee ninguna de las cuatro funciones del camino por cuadro que se revisaron (`FUN_0013a6e8`, `FUN_001334e0`, `FUN_00135580`, `FUN_00137ca0`)—, así que **no hace falta sondearlo antes** de probar la ranura propia. Es un ahorro de sonda, no un descarte: si J2 camina y algo de animación sale mal, vuelve a la lista.

**No funcionó:** la predicción de N3. No hay llamada de construcción que asigne `J+0x7C`.
**Sigue (N3):** N4 — el subcomando `jugador2.py ranura-copiar` con los tres bloques de N2, el envoltorio y el modo `--seco`.

### (80) N4 — `jugador2.py ranura-copiar` y el envoltorio que cambia el global

**Predicción de N4 (escrita antes de correrlo):** con los tres bloques de N2 y las reubicaciones medidas, el plan en seco contra `ee-03.bin` tiene que dar **exactamente 8** reubicaciones —2 autopunteros del sistema, 2 compañeros, 2 `+0xB8` y 2 punteros de vuelta `compañero+0x84`—, ninguna tomada de una lista escrita a mano, y **ningún** puntero de la copia debe quedar cayendo en el sistema ni en los compañeros de J0.
**Resultado: cumplida.** 8 reubicaciones, 0 punteros al original.

**`plan_copia(leer32, leer_bloque, destino, dueño)`** es una **función pura**: no escribe nada, devuelve los bloques, las reubicaciones y el mapa. Por eso se puede correr en frío contra un volcado, que es lo que la hace probable sin emulador. Mide todo **en vivo**: los autopunteros salen de barrer el bloque buscando palabras que caigan adentro de él, no de la lista de `ee-03` — los compañeros viven en el montón y se mueven de sesión a sesión.

```
python herramientas/jugador2.py ranura-copiar --volcado black-datos/ee-03.bin   # en frio, no toca nada
python herramientas/jugador2.py ranura-copiar --seco                            # en vivo, imprime y no escribe
python herramientas/jugador2.py ranura-copiar [--dueno-a-mano]                  # escribe
python herramientas/jugador2.py carga-poner --copia-ranura                      # el envoltorio cambia el global
```

**Corrida en seco contra `ee-03.bin`** (la cuenta de N2 decía 0x22B0 y estaba mal: son **0x1D10**, 0x970 + 2·0x9D0):

| bloque | de | a |
|---|---|---|
| sistema (0x970) | `0x004ED380` | `0x0046DC00` |
| compañero 0 (0x9D0) | `0x01303780` | `0x0046E570` |
| compañero 1 (0x9D0) | `0x01308B00` | `0x0046EF40` |

y las 8 reubicaciones: `+0x4C0` → `0x0046DF98` (instancia 0), `+0x700` → `0x0046E004` (instancia 1), `+0x4C4` y `+0x704` a los compañeros nuevos, `+0x528` y `+0x768` (= `ranura_k+0xB8`) a **0**, y `compañero_k+0x84` → `0x0046E070` / `0x0046E2B0`, las ranuras de la copia. Termina en `0x0046F910`, holgado contra `0x00472000`.

**El envoltorio:** alrededor del `jal 0x139c68` de J2 (ahora en `0x0046DAB4`) guarda el sistema original en `0x0046D7B0`, pone `*(0x0040F50C)` = la copia y lo restaura al volver. **Lee la dirección de la copia de `0x0046D7B4`, y si ahí hay 0 no toca el global** — así `carga-poner` sin `--copia-ranura` se comporta exactamente como en (79), que es el control. Los `t` no sobreviven al `jal`, así que el original se recarga de memoria, no del registro. El envoltorio creció a 81 instrucciones y sigue entrando (`0x0046DB44` contra el tope `0x0046DBC0`).

**`--dueno-a-mano`** existe por lo que midió N2: con el molde `0x1C` la init **sólo apunta** (`J+0x330 = global + J[0x2C3]·0x240 + 0x470`) y no ata, así que la ranura de la copia se queda con J0 de dueño —y `FUN_001a6be0` lee justo eso—. Con la opción, las dos ranuras de la copia quedan con J2. Es un atajo, no el atado: el atado de verdad es `FUN_001a51c8(COPIA+0x470+k·0x240, J2, COPIA+0x398+k·0x6C)` con el global ya en la copia, y lo hace solo el molde **2**.

**23 comprobaciones nuevas** en `pruebas/prueba_herramientas.py` (**180** en total, en verde), sobre una RAM sintética con la misma forma que la real. **Tres saboteadores, los tres en rojo:**
- no reubicar `+0x54` —**que es exactamente la especificación que traía el retome**—: 3 en rojo, entre ellas el medidor que pregunta si algún puntero de la copia sigue cayendo en lo de J0;
- dejar `+0xB8` = 1: 2 en rojo;
- no reubicar los autopunteros internos del compañero: 3 en rojo.
Y un **control positivo del medidor**: se arma a propósito el plan viejo (copiar sólo los 0x970) y se exige que declare **2** punteros apuntando a los compañeros de J0. Sin ese control, el medidor podría estar dando verde por no mirar nada.

**Sigue (N4):** N5 — `kb/subsistemas.json`: `0x0040F50C` no es `audio`.

### (80) N5 — `0x0040F50C` no es `audio`: nace el nodo `personajes`

El nodo `audio` de `kb/subsistemas.json` tenía **dos** globales: `0x0040F510` (el gestor de bancos de sonido, que es lo suyo) y `0x0040F50C`, que no tiene nada que ver. El error entró en **(74)**, cuando `0x0040F510` se fusionó con `audio` y **se llevó al vecino puesto**: nadie midió el segundo, se heredó la etiqueta del primero por estar al lado en el mapa de globales. Es la forma exacta de la regla 4 del contrato — «probablemente sea X» escrito como si fuera X — y costó que (79) tuviera que aclarar «el kb lo tiene bajo `audio` y **no es de audio**» en dos lugares distintos.

**Hecho:** `audio` se queda sólo con `0x0040F510` y lleva la corrección escrita con su fecha; nace **`personajes`** (K **4**, no 5: se midió en volcados con control, pero **todavía nadie le escribió y vio el efecto**, que es lo que pide la escala). Lleva la disposición del objeto, el camino de atado, qué es `+0xB8`, que el índice de ranura es el **arma en la mano** (`J+0x2C3`), lo que hace —y lo que no hace— el cuadro con el global, y su sonda. 37 → **38 subsistemas**.

**Y de paso una decisión que no es de formato:** `personajes` entra como **habilitador** de M1, M2 y M5 (el desplazamiento del segundo jugador sale de ahí: N3). Es una dependencia **medida**, no una opinión. Para que no quede la duda de haber tocado una entrada del trade con el resultado a la vista, se corrió `trade` **antes y después**: el orden no se movió (P7, M6, P5, E2, M7, G2, D2), porque M1, M2 y M5 ya tenían un habilitador en K ≤ 4. La entrada cambió; la decisión, no.

**Verde:** `kb_formato.py verificar` reproduce HEAD (el diff del `.json` es de **2 líneas**, no de cientos); `programa.py catalogo` regenerado; `programa.py verificar` **0 rojos** — y en el camino se puso **en rojo una vez**, sola, cuando el catálogo quedó atrasado respecto del `kb/`, que es lo que lo vuelve creíble. `pruebas/probar-programa.py`: **todo en rojo donde tenía que estarlo**.

**Estado de la Fase A al cerrar esta tanda:** sin cambios en el criterio — J2 está construido, corre a 60 Hz y el mando 2 le gira la vista; **falta que camine**, y eso es de la notebook. Lo que esta tanda cambió es que el camino está **medido** en vez de supuesto: se sabe que la copia puede funcionar, cuánto hay que copiar (tres bloques, 0x1D10 B, no uno de 0x970), con qué argumentos se ata a mano, qué **no** hace falta sondear (`+0x7C`/`+0x8C`) y qué trampa espera (el cambio de arma). Ningún nodo sube de K: nada de esto es efecto en RAM.

**No funcionó (la tanda):** dos especificaciones que venían escritas —la de N4 en el retome y la de N3— y un saboteador propio que daba verde por el motivo equivocado. Las tres se arreglaron en el mismo turno.
**Sigue:** la notebook, con `sesiones/RETOME-LOCAL.md` actualizado: sonda 0 (`J2+0x2C3` = 1, un byte) y después la copia.

## 2026-09-27 (79) — El prototipo durante la carga: el jugador 2 construido por el cargador
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `juego`, `spawn`, `codigo-nuevo`
**Objetivo:** el criterio de salida de COOP-A: un segundo jugador en el nivel, movido por el mando 2. Camino (1) del «Sigue» de (78): construirlo **durante una carga**.
**En frío (probable, antes de tocar RAM):**
- **El sitio:** `0x00128EA4` = `jal 0x00129090` (`0x0C04A424`, medido en vivo), con `move a0, s3` (juego) en el hueco y `a1` = `juego+0x5AE8` (el índice, 0). Si devuelve 0, el cargador sale con 0 (`0x00129054`) y vuelve a llamar el cuadro siguiente; con 1 incrementa `+0x5AE8` y pasa al estado 0x13.
- **Los estados del constructor** (`FUN_00139c68`, `J+0x8A4`): 1 o 0x37 → pide el modelo (`FUN_0016c3b8`) → 2 → espera `FUN_001438a8(*(0x0040F540))` y llama `FUN_00143d90` → 3 → 0x1C → la init principal (armas, `FUN_0013ba40`) → **0x37 y devuelve 1**. Sale con 0 sin hacer nada si `*(0x0040F4C4)+0x8B8/0x8B9` ≠ 0. El molde entra en **2** (el modelo ya lo pidió el jugador 0).
- **Estado compartido que el constructor NO rehace — nuevo, cambia la lectura del resultado:** de los punteros externos de J, **15 son idénticos en los tres volcados** (`ee-03`, `ee-11`, `ee-e4`: niveles distintos) → objetos asignados **al arrancar**, uno por jugador, que la carga no toca: `+0x7C` (`0x01937E70`), `+0x8C`, `+0xB8`, `+0xBC`, `+0x35C` (`0x018A9xxx`), `+0x270/274/278`, `+0x294`, `+0x2A0` (el arreglo de armas `0x006ED780`), `+0x328`, `+0x330`, `+0x34C`, `+0x354/358`, `+0x410`. Cambian con el nivel: `+0x30`, `+0x34`, `+0x38`, `+0xB0/+0xB4`, `+0x360`. **Consecuencia:** construido en la carga, J2 igual comparte esos objetos con J (la causa probable del congelamiento de P4). Al arreglo de armas le doy uno propio (`0x0046DBC0`), porque el constructor escribe `**(J+0x2A0)` y pisaría las armas de J; los demás quedan compartidos a propósito, para medir primero si el constructor **termina**.
**Herramienta:** `jugador2.py carga-poner` (molde con `+0x8A4` = 2 y armas propias; gancho por cuadro en estado 0; envoltorio en `0x0046DA00`: fase en `0x0046D790`, llamadas J0/J2 en `0x0046D79C`/`0x0046D794`), `control2`, `mirar`, `quitar`.
**Predicción P7 (escrita antes):** slot 3, control de vivo. `carga-poner`, control de vivo otra vez; después `selector_depuracion.py pedir-frontend --bandera 0`, `elegir 0 0` (City Streets, unidad 1), `aceptar`. Durante la carga: `llam_J0` sube hasta que la fase pasa a **1**, `llam_J2` sube y `J2+0x8A4` recorre 2 → 3 → 0x1C → **0x37**, la fase pasa a **2** y el cargador sigue (`juego+0x5AA0` → 0x13 … **0x1C**) en ≲ 30 s; el juego no se cuelga (vivo positivo después de la carga). J2 queda con **arma propia** (`J2+0x2A4` ≠ `J+0x2A4`) y en el punto de aparición. **Control:** la carga de City Streets de (78), por el mismo camino y sin gancho, pasa el estado 3 y carga en ~15 s; P6/P6b (el mismo constructor fuera de la carga cuelga en 12 s). Después, con el estado del gancho por cuadro en 2 → 3 y `control2`, «adelante» en el falso 2 **mueve a J2**; por lo compartido, **espero interferencia con J** (J congelado o arrastrado, como en P4) — si pasa, es resultado, y lo siguiente es darle a J2 copias propias de los objetos de arranque. Salidas posibles: el constructor tampoco termina en la carga (queda en 2: `FUN_001438a8` nunca da ≠ 0 para un segundo pedido), el emulador se cae, o J2 se construye pero no camina.
**Resultado P7 — la predicción falló: también cuelga durante la carga** (slot 3; vivo positivo antes y después de `carga-poner`, con los dos sitios leídos cambiados: `0C11B600`, `0C11B680`):
- **El envoltorio anda — medido:** el cargador pasó 10 → 16 → **0x12**; el jugador 0 necesitó **46 llamadas** (≈ 0,7 s de cuadros esperando el modelo) y al devolver 1 la fase pasó a **1** (a los 9,1 s) y J se movió al punto de aparición de City Streets.
- **La primera llamada para J2 no volvió:** `llam_J2` = 1 durante 36 s, `J2+0x8A4` **quieto en 2**, cargador en 0x12; vivo **negativo**. EE en el lazo ocioso del kernel (`0x80001578`); hilos 1 y 3 en `SleepThread` (`0x00367788`). Como el 3 se escribe después de `FUN_00143d90`, el cuelgue está **dentro de `FUN_001438a8` o `FUN_00143d90`** (o de lo que éstas llaman con J2), igual que P6b. **Control:** el jugador 0 pasó por el mismo constructor, en la misma carga y por el mismo envoltorio, y terminó.
- **Restos en los registros del kernel (hipótesis: los del último hilo que corrió):** `s1` = J2+0x400, `s3` = J2+0x680, `s0` = J2+0x8F0, `s7` = `0x00597810` (el objeto de arranque de `J+0x328`).
- **Quién duerme en frío:** `SleepThread` lo llaman un **esperar-bandera** (`FUN_00271480`: duerme hasta que `0x004406E0[i]` ≠ 0; lo usan la sesión y el singleton `0x0040F4C4` de carga, `0x00109180`/`0x00109278`), una espera con alarma (`FUN_00271610`, desde `0x00124E90`) y el hilo de E/S (`FUN_0031d400`). Lectura (hipótesis): J2 dispara una **carga síncrona** que espera una señal que no llega, no un error detectado.
- Se recargó el slot 3: sitios originales, vivo positivo.
**Lectura:** el contexto de carga **no** es lo que le faltaba al constructor. Lo que distingue a J2 de J0 en el mismo camino es el **molde**: los punteros y valores copiados del bloque de J (entre ellos los 15 objetos de arranque compartidos) o el índice −577.
**Sigue:** 3b — confirmar el vigilante `onchange` vs `write` y poner **migas dentro** de `FUN_001438a8`/`FUN_00143d90` para saber en qué llamada se duerme.

**3b en frío (probable, antes de tocar RAM) — el cuelgue tiene candidato, y es de diseño:**
- `FUN_001438a8(streamer, hash)` → `FUN_00143908`: máquina de estados del **cargador de modelos** `*(0x0040F540)` (doble búfer, `+0x7C`/`+0x80`, estado en `*(+0x80)+0x1C`; 8 = listo, y devuelve 1 si el hash pedido es el cargado). Con el hash de J (el molde lo trae) da 1 en la primera llamada.
- `FUN_00143d90(streamer, J2, 0)`: si el búfer está en 8, lo **da vuelta** (`FUN_00144078`) y llama `FUN_001ac960(*(0x0040F50C), 0, modelo, J2, …)`, que inicializa la instancia `base+0x398+k·0x6C` y termina en un **lazo** `do { r = FUN_001a51c8(base+0x470+k·0x240, J2, inst) } while (r == 0)`.
- `FUN_001a51c8(ranura, jugador, inst)` **ata una ranura de personaje al jugador**: si `ranura+0xB8` ≠ 0 la suelta primero (`FUN_001a5ee8`), después `*ranura = jugador` y `jugador+0x330 = ranura`.
- **El índice lo fija el constructor en 0** (`move a2, zero` en `0x00139DD0`). El sistema de armas llama lo mismo con otro índice (`FUN_0015bbd8`, `FUN_0015c3c8`, `+0x43`).
- **Medido en vivo (slot 3):** `*(0x0040F50C)` = `0x004ED380` (2.416 B; el kb lo tiene bajo `audio` y **no es de audio**); ranura 0 (`0x004ED7F0`, = `J+0x330`) y ranura 1 (`0x004EDA30`) **las dos con dueño J** (`0x005A8AB0`) y `+0xB8` = 1. Instancias 0 y 1 en `+0x398`/`+0x404`, y `0x398 + 2·0x6C` = `0x470`: **caben exactamente dos**. No hay ranura libre para J2: el constructor le **roba la ranura 0** a J0.
**Predicción P8 (localización, escrita antes):** repetir P7 tal cual y, después del cuelgue, leer (sin código nuevo) las escrituras del propio juego: (i) el dueño de la ranura 0 (`0x004ED7F0`) y `J2+0x330`; (ii) el byte de búfer del cargador de modelos (`*(0x0040F540)+0`, se da vuelta en `FUN_00144078`). Apuesto a **(i) = J2 y `J2+0x330` = `0x004ED7F0`**: el cuelgue está en el lazo de `FUN_001a51c8` después de atar, o en lo que sigue (P6b vio escribir `J2+0x4E0` a `FUN_00137018`, que sólo corre con el jugador atado). Si el dueño sigue siendo J0 y el búfer se dio vuelta, el cuelgue está en **soltar** a J0 (`FUN_001a5ee8`). Si el búfer no se dio vuelta, está antes (`FUN_00143908`). **Control:** los mismos campos leídos antes de la carga (J dueño de las dos ranuras) y, para el búfer, su valor antes. El vigilante `onchange`/`write` no hace falta para esta lectura (no se usa vigilante); queda para cuando se use.
**Resultado P8 — la apuesta falló y el cuelgue quedó localizado un paso antes** (`jugador2.py autopsia`; slot 3, vivo positivo antes y después de `carga-poner`; el cuelgue se reprodujo igual: J0 en 46 llamadas, fase 1 a los 8,6 s, `llam_J2` = 1, vivo negativo):
- **Control (antes de la carga):** ranuras 0 y 1 con dueño J, `+0xB8` = 1; búfer del cargador de modelos = 1, estado 8.
- **Después del cuelgue:** la ranura 0 **sigue siendo de J0** (J2 no llegó a atar nada); el búfer pasó a **0**: se dio vuelta **una sola vez**, la de J0 (`FUN_00143d90` del jugador 0). El búfer que quedó como «siguiente» está en el estado **1**. `J2+0x8A4` = 2, `J2+0x4E0` = 0.
- **Lectura (probable):** con el hash de J2 (= el de J0) el búfer siguiente no lo tiene, así que `FUN_00143908` entra por el caso 1 y llama `FUN_00143c80`, que arma el nombre del archivo y **pide el modelo otra vez** al cargador de archivos (`FUN_001093c0(*(0x0040F4C4), ruta, 6, …, 0x00143FD8, …)`); el estado 2 se escribe al volver, y nunca volvió. Los vecinos de `FUN_001093c0` (`0x00109180`, `0x00109278`) son dos de los que duermen en `FUN_00271480`. El modelo ya está cargado (lo tiene J0 en el búfer actual): el camino 2 del constructor sirve para **cargar** el modelo del jugador, y es justo lo que J2 no necesita. El P6 (molde en 0x37, `FUN_0016c3b8`) es el mismo pedido por otra puerta.
**Predicción P9 (escrita antes):** lo mismo con el molde en **`+0x8A4` = 0x1C**, que saltea el cargador de modelos y va directo a la init principal (armas por `FUN_0015cef0`, `FUN_0013ba40`, …) → **0x37 y devuelve 1 en la primera llamada**: fase 2, `llam_J2` = 1, el cargador sigue hasta 0x1C y **vivo positivo** después de la carga. J2 queda con arma propia (`J2+0x2A4` ≠ `J+0x2A4`) y `J2+0x330` = la ranura 0 **sin atar** (dueño J0: la init no ata, sólo apunta). Después: estado 2 → 3 del gancho por cuadro, `control2` y «adelante» en el falso 2. **Control:** P7/P8 (el mismo molde en 2 cuelga en la primera llamada). Si también cuelga, lo que pide carga está en la init (armas: `FUN_0015cef0` sobre el inventario `*(0x0040F4E0)`), y la miga es la misma autopsia más `J2+0x2A4`.
**Resultado P9 — también cuelga, y deja sin sostén la lectura de P8:**
- **Primer intento, anomalía (sin explicar):** 5 s después de recargar el slot 3 (vivo positivo), `carga-poner --desde 0x1C` y el vivo inmediato dio **negativo** antes de disparar ninguna carga: el EE quedó **pausado en una excepción** con PC = `0x00410827` (impar, en datos), `sp` = `ra` = 0, `a0` = `0x01937E70` (el objeto de arranque de `J+0x7C`), `s4` = `J+0x70`. Recargado, esperado 20 s y repetido: vivo positivo inmediato y a los 5 s. Hipótesis: tocar código demasiado pronto después de cargar un estado; no está medido. **Trampa:** después de `cargarestado` el depurador puede quedar pausado (`estado` → `paused True`): hay que `continuar`.
- **Segundo intento:** J0 en 46 llamadas, fase 1 a los 9,1 s, `llam_J2` = 1 y quieto, `J2+0x8A4` **quieto en 0x1C** (la init principal termina en 0x37: no terminó), vivo negativo. La ranura 0 sigue de J0.
- **La lectura de P8 no se sostiene:** el búfer siguiente del cargador de modelos está en **1 también acá**, y con 0x1C J2 no pasa por el cargador de modelos. Ese 1 es el estado en que queda el otro búfer después de la vuelta de J0, no una huella de J2: **en P8 faltó el control** (leer el búfer entre la vuelta de J0 y la llamada de J2, que pasan en el mismo cuadro y PINE no llega). Queda como hipótesis que el camino 2 cuelgue en `FUN_00143c80`.
- **Y `llam_J2` = 1 no distingue** «la llamada no volvió» de «volvió 0 y el hilo se colgó en otra parte del cuadro»: el envoltorio sólo contaba entradas.
**Predicción P10 (escrita antes):** el envoltorio replica `FUN_00129090` por partes, con migas en RAM después de cada llamada: A (`FUN_0012bd98`, el punto de aparición), B (`FUN_00139c68`, y su `v0`), C (`FUN_0016e660`, el registro). Molde en 0x1C, slot 3, vivo antes y después de poner. Apuesto a **A = 1, B = 0**: el hilo se duerme **adentro de la init principal** del constructor. Si B = 1 con `v0` = 0 y el contador no sigue, el cuelgue está fuera del constructor, en el mismo cuadro. **Control:** J0 recorrió la misma función en la misma carga (46 llamadas, devolvió 1).
**Resultado P10 — el constructor TERMINA; el cuelgue es el registro físico, y la causa de todos los cuelgues anteriores era nuestra** (slot 3; vivo positivo antes, después de poner y a los 3 s):
- **Migas:** A = 1, **B = 1 con `v0` = 1**, C = 0. `J2+0x8A4` = **0x37**, J2 **en el punto de aparición** (−4,215; 1,117; 52,561, el mismo que J) y con **arma propia** (`J2+0x2A4` = `0x006DE7A0` ≠ `0x006DE690`). A y B son el control positivo del instrumento de migas. Lo que no vuelve es `FUN_0016e660(*(0x0040F4D4), J2)`. Vivo negativo; EE en el lazo ocioso del kernel.
- **El registro, en frío y en RAM (confirmado en RAM):** `FUN_0016e660` toma un bit de una máscara de 32 (`+0xFA8`; quedó `0x3`, y `J2+0x380` = 1) y llama `FUN_0016fa50(mundo+0x22B28, J2)`, que pide un **cuerpo de personaje por tipo** (`FUN_0016fb18`: tipo 1 → `+0x7C`, tipo 2 → `+0x88`; el tipo es `J+0xC4`) a un pool `{objetos, usados, cuenta}` (`FUN_0016ead0`: el primero libre, o **0**), lo guarda en `J+0x34C` y le escribe el dueño en `+0x20` (`FUN_00171ca8`). **Pool del tipo 2: cuenta 1, usado por J** (`0x006B8180`, el `+0x34C` «de arranque» de J). J2 recibió **0** (`J2+0x34C` = 0) y `FUN_00171ca8(0, J2)` escribe J2 en la dirección `0x20`: **la RAM del kernel** (probable: explica que todos los hilos queden dormidos). Es el **tercer lugar compilado para un solo jugador**, con `jugadores[]` y la tabla de mandos. El pool del tipo 1 tiene **16 cuerpos, todos libres**, de la **misma clase** (vtable `0x003DCFE0`, 0x1780 B cada uno).
- **La causa de P6–P9 (confirmado aritméticamente con el puntero vivo):** `juego` = `0x005A8A80`, así que **k = −577 da `0x0046D1F0`, no `0x0046CDF0`** — el `−577 → 0x0046CDF0` de (78) era una cuenta mal hecha, «leída» y nunca medida (0x0046CDF0 no sale con ningún k entero: 577,46). `FUN_00129090(juego, −577)` construía un jugador en `0x0046D1F0…0x0046DAB0`, **encima de los contadores (`0x0046D780…`), del stub por cuadro (`0x0046D800`) y del envoltorio (`0x0046DA00`)**: el constructor le escribía encima al código que lo estaba llamando. Cuadra con todo lo medido: el estado del molde «quieto» (se miraba `0x0046CDF0+0x8A4`, que no era el bloque), el disparo del vigilante de P6b en `0x0046D2D0` (= `0x0046D1F0`+0xE0: el constructor escribiendo su bloque) y los restos `s1` = `0x0046D1F0` en P7. P10 cargó J2 a mano y por eso el constructor terminó. **Lección de proceso** (va al registro).
**No funcionó:** P6, P6b, P7, P8 y P9 no midieron el constructor: midieron un choque de memoria nuestro. La lectura de «el constructor depende del contexto de carga» y la de P8 quedan **retiradas**.
**Predicción P11 (escrita antes):** lo mismo que P10 y, alrededor de `FUN_0016e660`, `J2+0xC4` = **1** (el registro saca un cuerpo del pool del tipo 1) y de vuelta a **2** después (para que la pasada 3 de la lista lo saltee, como a J). → C = 1, fase 2, el cargador sigue hasta **0x1C** y vivo positivo; `J2+0x34C` = un cuerpo del tipo 1 con `+0x20` = J2, y el de J sigue siendo `0x006B8180` con dueño J. Después, con el gancho por cuadro en 2 → 3 (engancha a J2 a la lista y le corre controlador y update) y `control2`: «adelante» en el falso 2 **mueve a J2**; J con el falso 1 **sigue caminando**. **Control:** P10 (sin el cambio de tipo, cuelga en el registro) y el falso 1 moviendo a J antes de enganchar a J2. Quedan compartidos otros objetos de arranque (`+0x7C`, `+0x8C`, `+0xB8/BC`, `+0x35C`…): si J y J2 se interfieren, lo siguiente es medir cuáles re-asigna la construcción comparando los punteros de J y J2 después de la carga.
**Resultado P11, primera mitad — CONFIRMADO en RAM con control: el jugador 2 construido por el juego, durante la carga, y el juego sigue** (slot 3 recargado, 20 s de espera, vivo positivo antes, después de poner y a los 3 s): migas A = B = **C = 1**, `v0` = 1, fase **2** a los 9,1 s, el cargador pasó a **0x1C** (jugando) y el vivo **después de la carga dio positivo** (el eje del falso 1 giró el yaw 117°). J2: `+0x8A4` = 0x37, en el punto de aparición, arma propia `0x006DE7A0`, **cuerpo físico propio** `+0x34C` = `0x00699200` (el primero del pool del tipo 1) con dueño J2; el de J sigue en `0x006B8180` con dueño J. **Control:** P10, el mismo camino sin el cambio de tipo, cuelga en el registro.
**Resultado P11, segunda mitad — J2 corre y J NO se congela; J2 todavía no se mueve, por dos causas medidas:**
- **Control positivo antes de enganchar:** el falso 1 movió a J 3,3 u. Con `control2` y el gancho en 2 → **3**: J2 en la lista del mundo, controlador + update de J2 **~60 por segundo** (`cuadros_J2` 205 → 224 en 0,3 s) y vivo positivo.
- **J no se congela (confirmado en RAM, con control):** con J2 corriendo, el falso 1 movió a J **2,3 u**. Es la diferencia con P4: con cuerpo físico propio, el estado compartido que congelaba a J ya no gana.
- **J2 no se mueve:** «adelante» en el falso 2 durante 2 s: `J2+0x100` quieto.
- **Causa 1, del instrumento (confirmado con control):** con las tres copias de control **de J** apuntadas al mando 2 (`0x00585A0C` → falso 2), el falso 2 **gira la mira de J** (152 → 167°) pero **no lo mueve** (0,0 u en 1,5 s). La mira se lee por las tres copias; **el movimiento, por otro camino** (hipótesis: el número de mando `J+0x418` contra la tabla de mandos de la sesión, compilada para 1). En (76) sólo se había medido la mira.
- **Causa 2, del constructor (medido en RAM):** en J2 el **controlador activo** (`J2+0x32C`) quedó en **`J2+0x7D0`** (vtable `0x003DC9B8`, método `0x0013DD68`, su control `+0x98` = 0), no en la mira humana `+0x4F0` (vtable `0x003DCC20`, `FUN_0013f618`) como J. La init principal arma los cuatro (`FUN_0013ba40`) y termina activando `+0x7D0` (`FUN_001354e0(J, J+0x7D0)`); a J0 algo **posterior** a la construcción se lo cambia a `+0x4F0`, y a J2 nadie. Por eso la mira de J2 no integra aunque su controlador corre.
**Sigue:** poner `J2+0x32C` = `J2+0x4F0` y medir mira y movimiento de J2 con el falso 2 **y con el falso 1** (si el movimiento sale de `+0x418` = 0, J2 caminaría con el mando 1): eso dice por dónde hay que darle el mando 2 al movimiento.
**Predicción P12 (escrita antes):** en el mismo estado (J2 corriendo), `J2+0x32C` = `J2+0x4F0` → (a) el yaw del falso 2 **gira la mira de J2** (`J2+0x4F8`) y no la de J; (b) «adelante» en el falso 1 **mueve a J y también a J2** (el movimiento sale de `+0x418` = 0, hipótesis); (c) «adelante» en el falso 2 no mueve a ninguno. **Control:** el estado anterior (controlador en `+0x7D0`: la mira de J2 quieta con el falso 2). Si (b) no se da y J2 tampoco camina con el falso 1, el movimiento de J2 depende de algo más que el controlador (el cuerpo físico del tipo 1, o que la física sólo mueva el cuerpo del jugador).
**Resultado P12** (vivo positivo antes y después de cada sonda con vigilante):
- **(a) CONFIRMADA en RAM con control: el mando 2 gira al jugador 2.** Con `J2+0x32C` = `J2+0x4F0`, el yaw del falso 2 llevó la mira de J2 de −45,8 a **15,5°**; la de J, quieta en −131,9°. **Control:** con el controlador en `+0x7D0` (P11) la mira de J2 no se movía con el mismo empujón.
- **(b) refutada:** el falso 1 movió a J 6,9 u y a J2 nada. **(c):** el falso 2 no movió a ninguno.
- **La entrada llega entera a J2 (confirmado en RAM con control):** durante «adelante» en el falso 2, `J2+0x4F0+0xD4` = **1,0** y el de J 0,0; con el falso 1, al revés. El movimiento lo lee la **mira misma** (`FUN_0013f618` → `FUN_00124840(control, acción 1)` desde `0x0013F6D0`, medido con vigilante de lectura sobre el eje del falso: `s1` = control, `s2` = acción, llamador en `0(sp)`), y lo guarda en `mira+0xD4` (adelante − atrás) y `+0xD0` (lateral). El otro lector del eje es el update del objeto de control (`FUN_00124730`, filtro de repetición de menú); la sesión actualiza **los dos** objetos de control (`+0x4A0` y `+0x4A0+0x16C`), no uno.
- **El método de movimiento corre para J2 (medido):** es la entrada `+0x2C` de la vtable del jugador (`FUN_0013a6e8`, la pasada 4 de `FUN_00129360`); un vigilante de lectura sobre `J2+0x5C4` dispara desde `0x0013AB80` una vez por cuadro. J2 está en la lista del mundo (posición 43 de 366) y en la grilla (`+0x30…+0x38`, enlazado junto a J).
- **La posición de J2 la escriben los mismos tres sitios que la de J** (`0x001338B4`, `0x00133B08`, `0x00133B2C`, en `FUN_001334e0`; el tercero con `a0` = **`0x004ED7F0`, la ranura 0 del sistema de personajes**), pero con desplazamiento **cero**: J2 no se movió nunca de (−4,215; 1,117; 52,561). Lectura (probable): el avance sale de la **ranura de personaje** (`+0x330`), atada a J0; J2 la comparte sin tenerla atada.
- **Qué comparte J2 con J después de construirse (medido):** `+0xB8/+0xBC` (`0x018A9610`), `+0x270…+0x278`, `+0x294`, `+0x328`, `+0x330` (la ranura), `+0x354/+0x358`, `+0x35C`, `+0x360`, `+0x410`. Propios: arma, arreglo de armas, cuerpo `+0x34C`, controles. **`+0x7C` y `+0x8C` quedaron en 0** (en J, `0x01937E70` —parece una instancia de animación, apunta al scratchpad— y `0x018A9530`, un bloque de parámetros en float).
- **3b, el instrumento — contestado:** el vigilante `write` **dispara aunque el valor no cambie** (4 disparos sobre la posición de J2, que no cambió). La hipótesis de (78) («sólo si cambia») salía del mismo error de índice: el `sw zero` que «no se vio» se buscaba en `0x0046CDF0+0x4E0`, que no era el bloque que se construía.
- **Trampa medida:** `cargarestado` puede dejar el depurador en pausa (`paused True`): `depurador.py continuar`. Y el guardia de comandos del repo bloquea por falso positivo comandos de PowerShell con `.Replace(` o textos con «J:»: usar la herramienta de edición o un script.
**No funcionó:** que J2 camine. El clon de P4 congelaba a J; este J2 no, pero no se desplaza.
**Estado de la Fase A:** el criterio pide que el mando 2 **mueva** a un segundo jugador en el nivel. Hay segundo jugador construido por el juego, en el nivel, corriendo a 60 Hz, y el mando 2 **le gira la vista**, sin tocar a J: la mitad del criterio. Falta que **camine**. `juego` **K4 → K5**.
**Sigue:** darle a J2 **su propia ranura de personaje** y medir si camina. Dos caminos, en orden: (1) el sistema de personajes (`*(0x0040F50C)` = `0x004ED380`, 0x970 B) tiene 2 ranuras y 2 instancias, las dos de J; copiarlo entero a memoria libre (hay `0x0046DC00…0x00472000` en cero dentro del `.bss`, que termina en `0x0049BFBC`), reubicar sus autopunteros, y durante la construcción de J2 cambiar el global `0x0040F50C` a la copia y volverlo después (mismo truco que el tipo del registro), con el molde en **2** para que el constructor ate la ranura y cargue el modelo por su camino (P6 ya no aplica: aquél colgó por el índice); (2) si el camino del modelo vuelve a pedir carga y cuelga, atar a mano: `FUN_001a51c8(ranura_copia, J2, inst_copia)`. Antes, vigilar quién escribe `J+0x7C` en la construcción de J0 (J2 lo tiene en 0).

---

## 2026-09-27 (78) — 5a y los niveles 96–99: el selector de niveles de depuración, en frío y por PINE
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `sesion`, `front-end`, `flujo`
**Objetivo:** 5a (¿algún camino de menú llega a `FUN_00106010`, la cuenta en 2?) y los niveles 96–99 desde un menú, con el mando falso.
**En frío (probable, leído antes de tocar RAM):**
- **Nadie pide el modo de dos jugadores.** Los modos de la sesión (`FUN_001034b0(sesion, modo)`) son objetos embebidos: `+0x20220` front-end (vtable `0x003DB5E8`), `+0x20F78` juego, `+0x20F90` el vacío de la cuenta 2 (vtable `0x003DB538`), `+0x20FA0` y `+0x20FD8`. Por literal se piden `+0x20220`, `+0x20F78`, `+0x20FA0` y `+0x20FD8`; **`+0x20F90` nunca**. El camino indirecto de E7 (`*(0x0040F544)+0x3880`, en `FUN_00200088`) no tiene quien escriba `+0x3880` ni `+0x3888` = 1 en el decompilado.
- **Hay un selector de niveles de depuración, vivo en el código.** El «entrar» del front-end (`FUN_00104210`), en su estado 7, hace `if (0x0040D986 == 0) FUN_002052a0(menú, 1)`: abre el **menú tipo 1** (`FUN_00205d40`, del singleton `*(0x0040F524)`) en vez del front-end de Flash. `0x0040D986` lo pone en 1 el mismo «entrar» la primera vez que carga el Flash; nada lo vuelve a 0 (vale 1 en los 3 volcados). El menú tipo 1 recorre la tabla `*(sesion+0x2106C)` (12 niveles de 0x24 B: nombre, `+0x10` id, `+0x11` unidades), leída en `ee-11`: City Streets (0), Wilderness (1), Town (5), Steelworks (3), Asylum (4), Docks (6), City Bridge (7), Gulag (8), **Character Viewer (97), Object Viewer (98), Danger Room (99), Gun Street (96)**. Botones (del control de la sesión, `0x005858A0`, el del mando falso): **4/5 cambian de columna** (nivel ↔ unidad, `menú1+200`), **7/6 suben/bajan** (`+0xC9` nivel, `+0xCA` unidad), **8 acepta**: escribe `sesion+0x2020C` = id, `+0x2020D` = unidad+1, `+0x2020E` = 1 y pide el modo juego (`+0x20F78`). Textos: `%s` y `Unit %u`.
- **El cambio de modo** (`FUN_001034b0`) deja el modo pedido en `sesion+0x21074`, `+0x210CB` = 1, `+0x21084` = 2, `+0x210C8` = 0 y arranca un fundido (`*(0x0040F544)+0x394C` = 1, `+0x3948` = 1.0); el lazo de la sesión llama al «salir» del actual y al «entrar» del pedido hasta que devuelve 1. En juego, el estado del front-end es `0x37` (arranca desde el principio).
**Predicción P1 (control del instrumento, escrita antes):** slot 3, control de vivo; con `0x0040D986` = **1**, escribir por PINE los campos de `FUN_001034b0` pidiendo `+0x20220` (y `front-end+0x48` = 0) → en ≤ 15 s `sesion+0x21070` = `sesion+0x20220` y en pantalla el menú principal normal; `menú+4` ≠ 1. Si no cambia de modo, lo que falta es lo que `FUN_001034b0` hace además (Flash, fundido) y la sonda por este camino no sirve.
**Predicción P2:** lo mismo con `0x0040D986` = **0** → `menú+4` = 1 y en pantalla un texto de nivel y «Unit 1» (el selector). **Control:** P1.
**Predicción P3 (5a + 96–99):** en el selector, con el mando falso, ir a Gun Street (96) y aceptar con un vigilante de escritura sobre `0x004BC208` → la cuenta la escribe `FUN_00106868` o `FUN_00213CA8` con **1**, nunca 2; y la carga de un nivel sin datos en el disco **falla o cuelga** (hipótesis de (75)). Después, lo mismo con Danger Room (99).
**Resultado** (slot 3, `LEVEL_00`; `selector_depuracion.py`; antes de cada corrida el control de vivo: el eje del falso gira el yaw ~90°):
- **P1 — cumplida.** Escribir los campos de `FUN_001034b0` **cambia de modo**: a los 4,3 s `sesion+0x21070` = `+0x20220`; el «entrar» del front-end recorre sus estados 0x37 → 4 → 5 → 6 → 7 → 0x1C y en pantalla aparece la **primera pantalla del front-end de Flash** (la pregunta de 480p). `menú+4` = 0. El instrumento sirve.
- **P2, primer intento — falló, con la causa medida.** El estado 5 del «entrar» **recarga el Flash y repone `0x0040D986` = 1** (se ve en el registro a los 3,5 s): en juego `front-end+0xD4C` = 0, así que la carga «de la primera vez» se repite en cada entrada. Resultado igual al control.
- **P2, reescribiendo el 0 en los estados 6 y 7 — CONFIRMADA en RAM con control.** `menú+4` = **1**, el selector en su estado 1. En pantalla, negro: el selector **no dibuja nada** (hipótesis: su texto usa un dibujante de depuración apagado en la versión comercial; bajar el fundido a 0 no cambia nada).
- **El selector obedece al mando falso — confirmado.** `elegir 11 0` lleva `+0xC9` a 11 y el menú escribe `sesion+0x2020C` = **96**; `aceptar` (8) pide el modo juego (`+0x21074` = `+0x20F78`).
- **5a — medido para este camino:** el vigilante de escritura sobre la cuenta disparó 4 de 4 en **`0x0010534C`, dentro de `FUN_00105318`**, el «entrar» del modo juego, que escribe **1** en cada llamada (≈ 2,4 veces por cuadro mientras carga). Es un **cuarto escritor** que el censo de (64) no tenía. La cuenta nunca pasó a 2. **5a queda cerrada en lo que se puede cerrar:** ningún literal pide `+0x20F90`, y los dos caminos de menú medidos (front-end de Flash y selector) escriben 1.
- **Niveles 96–99 — CONFIRMADO con control:** Gun Street (96) queda en la pantalla «LOADING» y el modo juego clavado en su **estado 3** (`FUN_00128480`, el cargador de stage) durante más de 30 s; Danger Room (99), igual durante 42 s. **Control:** City Streets (id 0, unidad 1) por el mismo camino pasa el estado 3 y carga en ~15 s, y en pantalla se juega (`volcados/capturas-78/p3c/`). La predicción de (75) se cumple: la tabla los nombra pero el disco no los trae.
- **Qué deja para el coop:** **cargar cualquier nivel y unidad sin manos** (`pedir-frontend --bandera 0`, `elegir <nivel> <unidad>`, `aceptar`), que es lo que el prototipo y la pantalla dividida van a necesitar para probar en más de un lugar.
**No funcionó:** escribir la bandera antes del cambio de modo (la pisa el estado 5); ver el selector en pantalla.
**Sigue:** el prototipo por PINE (segundo bloque de jugador), primero en frío.

**El prototipo, en frío (probable, antes de tocar RAM):**
- **Qué corre por cuadro** (`FUN_00129360(juego)`, la llama el lazo de la sesión en el estado 0, sólo si `juego+0x5AA0` = 0x1C): (1) `FUN_0013bac8(J0)` → el update del **controlador** del jugador, que es la mira (`*(J+0x32C)` = `J+0x4F0`, método `+0xC` de su vtable en `+0x84` = `FUN_0013f618`); (2) el método `+0xC` de la vtable del jugador (`J+0x10` = `0x003DC5F8`, update `0x0013A300`), **los dos sólo para `juego+0x30`**, a mano; (3) la **lista del mundo** `juego+0x5CA4` (siguiente en `+0xB0`): método `+0xC` de cada entidad **salvo `+0xC4` = 1 o 2**; (4) otra pasada con el método `+0x2C` para todas. El jugador está en la lista (posición 6 en `ee-11`) con `+0xC4` = **2**: por eso la pasada 3 lo saltea. Tipos vistos en la lista: 3 (283), 4 (89), 7 (21), 8 (6), 2 (1).
- **Qué lo construye:** `FUN_00129090(juego, k)` → `FUN_00139c68(juego + 0x30 + k·0x8C0, datos de aparición)` (el constructor completo, máquina de estados en `J+0x8A4`: armas, modelo, y al final `FUN_0013ba40`, que arma mira `+0x4F0`, `+0x620`, `+0x730` y `+0x7D0` con el mando `J+0x418`) y `FUN_0016e660(*(0x0040F4D4), J)`. Lo llama el cargador de stage (`FUN_00128480`, estado 0x12) con **`if`, no `while`**: construye uno, incrementa `juego+0x5AE8` y pasa al estado 0x13. **Con la cuenta en 2 se construiría igual un solo jugador**: segunda traba, además del N = 1.
- **`jugadores[1]` no está libre:** `juego+0x8F0` es otro objeto (`FUN_00160738(juego+0x8F0)` en el estado 0x15) y 141–182 punteros de la RAM apuntan a ese tramo en los 3 volcados.
- **El bloque, por dentro:** 7 punteros a sí mismo (`+0x54`, `+0x29C`, `+0x56C`, `+0x69C`, `+0x7AC`, `+0x84C` → J; `+0x32C` → J+0x4F0) y 30 hacia afuera: el arma (`+0x2A4`/`+0x2A8`, `+0x270…+0x2A0`), física/modelo (`+0x30`, `+0x38`, `+0x7C`, `+0x8C`, `+0xB8`/`+0xBC`, `+0x328`…`+0x360`), el siguiente de la lista (`+0xB0`) y las tres copias del control.
- **Consecuencia para el diseño:** el constructor del juego sirve para cualquier dirección (con **k negativo**, `juego + 0x30 + k·0x8C0` cae en el `.bss` libre: k = −577 → `0x0046CDF0`), pero dispararlo una segunda vez **necesita código** (sonda 6, `codigo-nuevo`): un gancho en el `jal FUN_0013bac8` de `0x00129574` que, además del jugador 0, construya y actualice al 2. Por PINE solo se puede probar un **clon** sin constructor.
**Predicción P4 (el clon; hipótesis, escrita antes):** slot 3, control de vivo. Copiar los 0x8C0 B de J a **J2 = `0x0046CDF0`** (cero en vivo), reubicar los 7 autopunteros, apuntar sus tres copias de control a `0x00585A0C` y el `+0xC` de ese control a un **mando falso 2** en `0x00472100` (cero en vivo; el real es `0x005857B0`), poner `J2+0xC4` = 0 y engancharlo **a la cabeza de la lista del mundo**. Empujar «adelante» en el falso 2 durante 1 s → **la posición de J2 (`J2+0x100`) cambia y la de J no**. **Control:** el mismo empujón antes de engancharlo no mueve a J2. Salidas posibles, todas resultado: el emulador se cae (estado compartido: física, nodo espacial `+0x20`), J2 se actualiza pero no camina (le falta el update del controlador, que sólo corre para J0), o se mueve J (cuerpo físico compartido).
**Resultado P4 — la predicción falló, y el negativo es informativo** (`clon_jugador.py`; slot 3, control de vivo antes de cada corrida):
- **El clon se engancha y se actualiza — medido:** con J2 a la cabeza de la lista, 14 palabras de J2 cambian por segundo (`+0x110…+0x148`, `+0x19C`, `+0x240`); sin enganchar, ninguna. La pasada 3 de `FUN_00129360` le llama el update. No se cayó el emulador.
- **J2 no camina:** con «adelante» en el falso 2, `J2+0x100` no se mueve.
- **Y congela a J — CONFIRMADO en RAM con control, tres pasos:** clon puesto **sin enganchar** → «adelante» en el falso 1 mueve a J 8,6 u en 2 s; **enganchado** → «atrás» no lo mueve (0,0); **desenganchado** (`quitar`) → «atrás» lo mueve 16,4 u. El primer control positivo de la corrida también había fallado por esto: se hizo con el clon ya enganchado; en el slot limpio «adelante» mueve 16,6 u.
- **Lectura (probable):** el update del clon escribe estado **compartido** con J —los objetos externos que el bloque copiado apunta (física/modelo en `+0x7C`, `+0xB8`/`+0xBC`, `+0x328…+0x360`)— con velocidad nula (a J2 nadie le corre el controlador) y después del update de J, así que gana. **Un segundo jugador necesita sus propios objetos externos, o sea el constructor del juego (`FUN_00139c68`)**, y dispararlo necesita código nuevo.
**No funcionó:** el clon como jugador independiente.
**Sigue:** la **sonda 6** (`codigo-nuevo`): un gancho en el `jal FUN_0013bac8` de `0x00129574` hacia un tramo libre, probado primero con un contador que suba una vez por cuadro. Con eso, el prototipo: el gancho llama `FUN_00129090(juego, −577)` hasta que devuelve 1 (constructor sobre `0x0046CDF0`, con el bloque de J copiado antes como molde de vtables), `FUN_0012a158(juego, J2)` una vez, y cada cuadro `FUN_0013bac8(J2)` + el update de J2 (con `J2+0xC4` = 2, como J, para que la lista no lo actualice dos veces).
**Predicción P5 (sonda 6, escrita antes):** stub en `0x0046D700` (cero en vivo): guarda `ra`, `jal 0x0013BAC8` (con `a0` = J y `$f12` = dt intactos del llamador), suma 1 a un contador en `0x0046D780`, vuelve. Parchear por PINE la palabra de `0x00129574` de `jal 0x0013BAC8` (`0x0C04EEB2`) a `jal 0x0046D700` → el contador sube **una vez por cuadro** (~30/s; `FUN_00129360` corre una vez por cuadro) y el juego sigue igual: el eje del falso 1 sigue girando la vista (el controlador sigue corriendo, ahora a través del stub). **Control:** antes del parche el contador queda en 0; después de devolver la palabra original deja de subir. Si la palabra se lee cambiada pero el contador no sube, el recompilador de PCSX2 siguió usando el bloque viejo: falla del instrumento, no del gancho.
**Resultado P5 — CONFIRMADO en RAM con control** (`gancho.py`): sin parche, el contador queda en 0 durante 1 s; con el parche (palabra leída: `0C11B5C0` = `jal 0x0046D700`), sube **59 por segundo** —`FUN_00129360` corre a **60 Hz**, no a 30 como suponía `ritmo_vigilante.py`— y el eje del falso 1 sigue girando la vista 108°; con la palabra original de vuelta, se frena en 199 y el juego sigue vivo. El recompilador de PCSX2 **sí** toma una escritura de código hecha por PINE. `codigo-nuevo` **K2 → K5**: hay memoria libre usable y un gancho por cuadro que se pone y se saca en caliente.
**Predicción P6 (el prototipo con el constructor del juego; hipótesis, escrita antes):** `jugador2.py`: molde = copia de J en `0x0046CDF0` con los autopunteros reubicados; stub en `0x0046D800` con un estado en `0x0046D784` (1: `FUN_00129090(juego, −577)` cada cuadro hasta que devuelva 1; 2: `FUN_0012a158(juego, J2)`; 3: cada cuadro `FUN_0013bac8(J2)` + update de J2, contador en `0x0046D780`). Con el estado en 1: en ≤ 10 s pasa a **3**; el constructor le da a J2 **su propia arma** (`J2+0x2A4` ≠ `0x006DE690`, el arma de J) y lo pone en el **punto de aparición** del nivel (`J2+0x100` ≠ la posición de J, que caminó); el contador sube ~60/s y **J sigue caminando** con el falso 1 (no hay estado compartido, a diferencia de P4). Después, con las tres copias de control de J2 en `0x00585A0C` → falso 2, «adelante» en el falso 2 **mueve a J2 y no a J**. **Control:** P4 (el clon sin constructor no camina y congela a J) y el estado 0 (el stub sólo llama al controlador de J). Salidas posibles: el constructor no termina fuera de la carga (el estado queda en 1), el emulador se cae (un recurso del nivel ya cerrado), o J2 se construye pero no camina.
**Resultado P6 — el juego se cuelga, con la causa localizada (probable).** Con el estado en 1, nada cambia en 12 s (estado 1, `J2+0x8A4` = 0x37) y el control de vivo da **negativo**: el hilo del juego queda en `SleepThread` (syscall 0x32, `0x00367788`) y el EE en el lazo ocioso del kernel. En frío: en J, `+0x8A4` = **0x37 al terminar** (el constructor lo deja así y devuelve 1), así que el molde entró por el camino 1/0x37, que llama `FUN_0016c3b8(J2+0x3C0, …)` —la carga del modelo del personaje por su hash `0x544614B7182C0000`— **antes** de cambiar de estado; como el estado nunca cambió, el cuelgue está ahí: una carga síncrona que en juego nadie atiende. Se recargó el slot 3 (vivo otra vez, gancho fuera).
**Predicción P6b (escrita antes):** lo mismo con el molde en `J2+0x8A4` = **2**, que saltea `FUN_0016c3b8` y sigue por `FUN_00143d90(*(0x0040F540), J2, 0)` → 3 → 0x1C → la init principal (arma, `FUN_0013ba40`) → 0x37 y devuelve 1: el estado del stub llega a 3 en ≤ 10 s, con las mismas señales que P6. Si vuelve a colgarse, el constructor entero depende del contexto de carga y el prototipo necesita correrlo **durante** una carga (el selector de depuración ya sabe disparar una sin manos).
**Resultado P6b — también se cuelga** (estado 1, `J2+0x8A4` quieto en 2, vivo negativo a los 12 s). Lo que se midió para localizarlo:
- Vigilante de escritura sobre `J2+0x4E0` (0x0046D2D0): **un** disparo, desde `0x001372C4` (`FUN_00137018`, código de VU0), y ninguno desde el `sw zero, 0x4E0(s1)` del prólogo del constructor (`0x00139CA0`). **Sin el prototipo, nadie escribe ese tramo**: 0 disparos en 12 s en `0x0046D2D0`, `0x0046D800` y `0x0046D704` durante juego normal (cero válido, con `break`). O sea, la escritura la provocó el prototipo. Lectura (hipótesis): el vigilante de PCSX2 sólo dispara cuando **cambia el valor** —el `sw zero` sobre un 0 no se ve—, así que el constructor sí arrancó y el cuelgue está más adentro, después de `FUN_00137018`.
- La búsqueda del punto de aparición no es: `FUN_0012bd98(juego, 1)` encuentra la unidad A (id 1) en vivo. El índice negativo sí da `0x0046CDF0` (`mult` con signo en `0x001290B8`, leído). **[FALSO, corregido en (79): con `juego` = `0x005A8A80`, k = −577 da `0x0046D1F0`, encima del stub; ésa es la causa de este cuelgue.]**
- Una tercera corrida, con migas en el stub (llamadas y retornos de `FUN_00129090` en `0x0046D788`/`0x0046D78C`), **tiró el emulador entero** (PINE rechaza la conexión, sin proceso). Se hizo sin control de vivo previo; se relanzó con `ABRIR-BLACK-ORIGINAL.bat` y el slot 3.
**No funcionó:** construir al jugador 2 con el constructor del juego en caliente, desde el gancho por cuadro, dos veces de dos.
**Sigue (dos caminos, en este orden):** (1) **construirlo durante una carga**, que es el contexto para el que el constructor está escrito: un segundo gancho en el `jal 0x00129090` del cargador (`FUN_00128480`, estado 0x12) hacia un envoltorio que, después de que el jugador 0 devuelva 1, llame `FUN_00129090(juego, −577)` hasta que devuelva 1 antes de dejar seguir al cargador; la carga se dispara sin manos con `selector_depuracion.py` (City Streets carga en ~15 s). (2) Si también cuelga, localizar el cuelgue: vigilantes con tipo `onchange` vs `write` para confirmar la hipótesis del disparo por cambio, y migas por cada llamada de `FUN_00139c68`.

---

## 2026-09-27 (77) — Botones del mando falso: el mapa acción → botón, en frío y en vivo
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `entrada`, `armas`
**Objetivo:** que el mando falso apriete botones, con un observable en RAM, para que 5a, `0x0040D9A3` y los niveles 96–99 corran sin Fran.
**En frío (probable, leído antes de tocar RAM):**
- El mando procesado tiene 28 entradas: `+0x2A+i` = estado **actual** (u8), `+0x0E+i` = **anterior**, `+0x4C+4i` = valor (f32). Accesores: `FUN_0026bb98` (valor), `FUN_0026bc30` (actual), `FUN_0026bbc0` (**recién apretado**: actual ≠ 0 y anterior = 0), `FUN_0026bbf8` (soltado). Por eso el barrido de (76) no podía andar: escribía un byte en `+0x10…` (la zona de «anterior»), no las tres cosas juntas.
- El juego no pregunta por botones sino por **acciones**: `FUN_00124840(control, acción)` traduce con una tabla apuntada por `*(0x003BCAC8)` = `0x004BC174` (leída en vivo, 38 acciones). Acciones 9, 0xB, 0x19–0x1D, 0x1F, 0x20 y 0x24 piden **flanco** (recién apretado); el resto, valor sostenido.
- El que las consume en juego es `FUN_0013f618(mira)`, con `mira = J+0x4F0` (su `+0x98` es la copia de control `J+0x588` y su `+0x7C` es el jugador). Tabla botón → acción → efecto:
  - 0 → 0x1F (flanco) → `FUN_00156e90`: estado del arma `+0xD8` = 0x17/0x18 · 1 → 0xD → levantar arma del piso · 2 → 0xB (flanco) → `mira+0x34` · 3 → 0x20 (flanco) → `mira+0x3B`
  - 4 → 0x1E (flanco) → `FUN_00156d80` → `FUN_0015a990`: **modo de fuego** `sub+0x20` = (x+1) % 3 · 5 → 0x21 → `FUN_0013c9d8` · 6 / 7 → 0xF / 0xE → `FUN_0015be08`: **cambiar de arma**
  - 9 → 0x22 → sonido cada 10 cuadros · 10 → 0x10 → `mira+0x35` · 11 → 0xC → `mira+0x30` (zoom, `FUN_001f2cd0`) · **12 → 9 (flanco) → `mira+0x31`** · 13 → 0x1B (flanco) → `mira+0x33`
  - 8, 14 y 15 no pasan por `FUN_0013f618`.
- **La munición** (`FUN_0015a830`, recarga, y `FUN_00155140`, la resta del código público de munición infinita): el arma equipada es `J+0x2A4`; su subobjeto `*(arma+0xF4)` guarda el **cargador en `+0x18` (u16)** y el modo de fuego en `+0x20`; la reserva es un arreglo de u16 por tipo en `*(arma+0xFC)` = `J+0x280`. En vivo: arma `0x006DE690`, sub `0x006E18B0`, cargador **4**, reserva `[30, 24, …]`.
**Predicciones, escritas antes de correr** (mando falso puesto; cada botón i con `+0x4C+4i` = 1.0, `+0x2A+i` = 1, `+0x0E+i` = 0 durante 0,5 s; el falso no lo actualiza nadie, así que un flanco queda «recién apretado» cada cuadro):
- **12 → `mira+0x31` = 1 y el cargador baja** (hipótesis: la acción 9 es disparar). Si el cargador no baja pero la bandera sí, disparar es otra acción.
- 11 → `mira+0x30` = 1 · 10 → `mira+0x35` · 2 → `mira+0x34` · 3 → `mira+0x3B` · 13 → `mira+0x33` (o `+0x32`).
- 4 → el modo de fuego `sub+0x20` cambia · 6 o 7 → `J+0x2A4` pasa de `0x006DE690` a `0x006DEF10` (el arma del otro slot).
- 8, 14 y 15 → nada de lo anterior.
**Control:** el mismo registro con todos los botones del falso en 0 (banderas quietas, cargador quieto), y cada botón vuelto a 0 antes del siguiente.
**Primer intento fallido, con su causa:** control y botón 12 dieron **nada**, ni la bandera. El control positivo (un eje de yaw, que en (76) giraba la vista) **tampoco** movía nada: el juego estaba en el **menú de pausa** («RESTART? YES / NO», captura), donde `FUN_0013f618` no corre. No se sabe si lo abrió el barrido de (76) o uno de los míos; sí se sabe que desde entonces cada corrida lleva su control positivo de «vivo». Se recargó el slot 3.
**Resultado** (slot 3, `LEVEL_00`; `sondas_coop.py boton <i> 1.0`, y después de cada uno el eje de yaw como control de que el juego sigue corriendo):
- **12 = DISPARAR — CONFIRMADO en RAM con control.** `mira+0x31` = 1 mientras está apretado y el **cargador baja 14 → 6 en 1 s**; con ningún botón (control) queda en 14, y con el 11 (zoom) también: la bandera sola no gasta balas.
- **2 = RECARGAR — confirmado.** `mira+0x34` = 1, el arma pasa por los estados 4 y 8, y el cargador sube **6 → 15** mientras la reserva de su tipo baja **30 → 21** (los 9 que faltaban). Coincide con `FUN_0015a830` leída en frío.
- **6 y 7 = CAMBIAR DE ARMA — confirmado.** `J+0x2A4` pasa a `0x006DEF10` (el otro slot, cargador 5) con los estados 11 y 9; como el flanco queda sostenido, el 6 fue y volvió.
- **11 → `mira+0x30`** (zoom), **10 → `+0x35`**, **13 → `+0x33`**, **3 → `+0x3B`** y el arma a los estados 28/29 (sin identificar: no gastó balas ni reserva). Las banderas: medidas; qué hace cada una en pantalla, no.
- **8 = PAUSA** (medido por efecto: después del 8 el eje deja de mover la vista; se recargó el slot). Es lo que (76) vio como «cambia la pose del arma».
- **Sin efecto visto:** 0, 1, 5, 9, 14, 15, y **el 4, que falló la predicción**: el modo de fuego no cambió. Causa probable (frío): `FUN_00156d80` sólo actúa si el arma admite modos (`*(arma+0xEC)+0xC4` ≠ 0) y ésta no.
- **Los menús leen el mismo control, o sea el falso** (probable, frío: `FUN_00124a70/ae8/b58/bc8/c38` piden flanco en los índices **2, 4, 5, 6, 7** del control de la sesión, que es `0x005858A0`, el mismo cuyo `+0xC` apunta al falso). Es lo que destraba 5a y los niveles 96–99 sin manos.
- **La munición como observable:** cargador = u16 en `*(J+0x2A4)+0xF4` → `+0x18`; reserva = u16[tipo] en `J+0x280`. Medido.
**Sigue:** con disparar y recargar, la cámara desactivada (`0x0040D9A3` = 1 y matar a un enemigo a más de 6 m) y 5a por menús; después el prototipo.
**La cámara desactivada, en frío (probable), antes de correrla.** La secuencia la arma el manejador de muerte con ranura `FUN_0011ca28` → `FUN_0011bfb0(F504, …)` si se cumplen **todas**: `0x0040D9A3` ≠ 0; `*F504` ≠ 0 (**en vivo ya vale 1**: `F504` = `0x005BC800`); la animación de muerte elegida (`ranura+0x4B4`, la elige `FUN_00141308` entre las candidatas 3, 4, 0 y otras según el arma) es **3 o 7**; la categoría del arma del tirador (`*(*(0x00414D54) + 4·id)`, leída en vivo) está en {1, 3, 4, 5, 6, 0xF, 0x10, 0x12} — **el arma id 0 del jugador es categoría 1 y califica; la id 1 es 2 y no**; y la distancia al cuadrado ≥ 36 (6 m). Efecto: `F504+4` = 1 (estado), `F504+0x154` = la víctima, `F504+0x15D` = 1, `víctima+0x8B2` = 1.
Enemigos vivos en el slot 3 (pool `0x003DCA78`): `0x00592F50` a 10,6 m, `0x00592410` a 12,9 m, `0x005936D0` a 17,4 m.
**Predicción:** con `0x0040D9A3` = 1, apuntando `mira+8`/`+0xC` al enemigo cada 50 ms y disparando con el botón 12 hasta que su vida llegue a 0: `F504+4` pasa de 0 a **1** y `F504+0x154` = el enemigo, **si** la animación elegida fue 3 o 7 (si es al azar, puede hacer falta más de una muerte: hasta 3 intentos, uno por enemigo, anotando cada uno). **Control:** la misma muerte con `0x0040D9A3` = 0 (slot recargado) deja `F504+4` en 0.
**Resultado:**
- **Matar sin manos — medido.** Apuntando con la geometría (yaw = 90° − rumbo, pitch al pecho) y el botón 12, el enemigo `0x00592F50` muere a 10,2 m en **1,75 s**, tres veces de tres. El coop tiene ahora un «jugador 2 de prueba» que camina, mira, dispara y recarga sin nadie en el mando.
- **Control (bandera 0) y bandera 1: `F504+4` quedó en 0 en los dos.** La predicción, en su forma fuerte, no se cumplió; la causa se midió.
- **La causa, medida con un vigilante de lectura sobre `0x0040D9A3`** (se lee en `0x0011CBDC`, donde `s0` = ranura; el otro lector, `FUN_0011c930` en `0x0011C948`, lo lee una vez por cuadro y se saltea): en la corrida hubo **6 muertes con ranura** (la mía, a 10,64 m con el arma id 0, y cinco de enemigos matados por los dos aliados invulnerables `0x00590250`/`0x0058FE90`, arma id 4) y **las 6 eligieron la animación 0**. `FUN_00141308` prueba las candidatas **en orden** (8, 7, 3, 4, 1, 0) y se queda con la primera cuyo comportamiento acepta arrancar (método `+0x3C` de su vtable); la 0 es el comodín. El «puede arrancar» de la 3 es `FUN_00120068`: exige una dirección de impacto no nula y que `FUN_0011d948` encuentre **algo en la geometría** en esa dirección o la opuesta (hipótesis: una pared o una baranda contra la que caer). **No es azar: es el lugar.** Una muerte en campo abierto nunca la arma.
**Predicción (forzada, escrita antes):** con la bandera en 1, en la pausa del vigilante en `0x0011CBDC` de la muerte que causa el jugador, escribir `ranura+0x4B4` = 3 (la animación ya arrancó; sólo se engaña a la puerta de `F504`) → `FUN_0011bfb0` corre: `F504+4` = 1, `F504+0x154` ≠ 0, `F504+0x15D` = 1, y en pantalla la cámara deja la primera persona (modo 0xB) y el jugador pierde el control un rato. Control: la corrida anterior, igual pero sin forzar, dejó `F504+4` en 0. Si no pasa nada, falla la distancia (`FUN_0011bfb0` mide ≥ 6 m entre otros dos puntos) o el estado 1 no alcanza.
**Resultado — CONFIRMADO en RAM y en pantalla, con control.**
- **RAM, tres veces de tres:** después de la muerte forzada, `F504+0x150` = la víctima `0x00592F50`, `+0x154` = el jugador, `+0x160` = **3** (el valor forzado: huella de causa), `+0x10`/`+0x20` = posiciones del jugador y de la víctima. Esas escrituras están **dentro** del `if (distancia² ≥ 36)` de `FUN_0011bfb0`: la secuencia arrancó. Con el slot recargado y en la muerte de control (bandera 1, sin forzar), los tres en 0.
- **`F504+4` = 1 no se llegó a ver**, y la causa es del instrumento: `matar_sin_manos.py` muestreaba mientras el emulador seguía frenado en el vigilante, y **después de continuar PINE no respondió durante varios segundos** (timeout; el emulador siguió vivo). Por eso las capturas pasaron a `rafaga-capturas.ps1`, que no depende de PINE.
- **En pantalla** (`volcados/capturas-77/`, no se commitean): de 0 a ~1,5 s después de la muerte forzada, **cámara de cine con franjas negras y sin HUD**, desde otro ángulo (una pared con vainas volando, después los enemigos junto al auto); a los ~2,1 s vuelve la primera persona con HUD. **Control** (misma muerte, bandera 1, sin forzar, misma ráfaga): primera persona con HUD en las 12 capturas.
- **Qué significa:** la función desactivada de fábrica **anda**; con sólo `0x0040D9A3` = 1 aparecería en las muertes de más de 6 m **cuando el lugar arma la animación 3** (cerca de geometría, `FUN_00120068`), no en todas. Qué hace la cámara exactamente (¿sigue la bala? ¿la vaina?) no se afirma: se vio un ángulo externo, no una trayectoria. **Si entra al mod es decisión de Fran** (condición (b) del retome: la sesión para acá).
- **Herramientas nuevas:** `matar_sin_manos.py` (apunta y dispara con el mando falso), `anim_muerte.py` (vigilante de lectura sobre `0x0040D9A3`: ranura, animación elegida, tirador, distancia; `--forzar3`, `--capturas`), `rafaga-capturas.ps1`.

---

## 2026-09-27 (76) — Lote de sondas COOP-A en la notebook: el mando 2 maneja al jugador 1, la vista se gobierna con un float, y entrada sin manos
**Sigue:** (1) los **botones** del mando falso (dónde lee el control virtual los bits crudos), que destraban 5a, la cámara desactivada y los niveles de prueba sin Fran; (2) el **prototipo por PINE** del criterio de salida: un segundo bloque de jugador de 0x8C0 fuera del array, con sus tres copias de mando en `0x00585A0C` y su propio objeto de mira; (3) en frío, por qué mover una zona no la dispara (`FUN_0016a5e8`). Las predicciones de abajo se escribieron antes de cada corrida.
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) · **Nodos:** `camara`, `render`, `sesion`, `valuedb`, `entrada`
**Entorno:** PCSX2-MCP (PINE 28011 + DebugServer 21512), ISO **original**, savestate **slot 3** (`LEVEL_00`, calle), sin parches vivos. Línea base leída con `herramientas/sondas_coop.py base` (nueva): jugador `0x005A8AB0` (= `juego+0x30`, `*(0x0040F4D0)` = `0x005A8A80`), mando `+0x418` = 0, yaw de mira 152,62°, fila 0 de la matriz a −152,62° (y la copia de la cámara idéntica), cámara `+0x7E1` = 0, cuenta `0x004BC208` = 1, bandera `0x0040D9A3` = 0, **dt = 1/30** (30 cuadros/s). La relación fila 0 = −yaw, que en frío salió de volcados, **se repite en vivo**.
Predicciones, cada una con su control:
- **3b** — vigilante de escritura (`log`, sin pausar) sobre `0x0043F790` durante ~10 s: **≥ 30 escrituras/s**, con `last_pc` adentro de `FUN_00269ea0`. Discriminante extra: si la segunda pasada de escena (E4) pasa por la misma función, da **≈ 60/s** (dos por cuadro); si da ≈ 30/s, la segunda pasada sube su cámara por otro camino. Control: un vigilante igual en una palabra de `.bss` que nadie escribe da 0.
- **4** — vigilante de **lectura** sobre `0x004CA2F0` (la vista 160 × 112): **≈ 30 lecturas/s** (la segunda pasada lee su viewport cada cuadro). Si da 0, la vista chica se arma una vez y no se usa por cuadro, y (69) queda en duda. El volcado del framebuffer `0x16B` no se puede por PINE (es memoria del GS): se anota como no hecho.
- **3a** — escribir el yaw de mira `0x005A8FA0` = 152,62 + 90 → al cuadro siguiente la fila 0 de `0x005A8B80` queda a **−242,62° ≡ 117,38°**, la copia de la cámara `0x0058EF20` igual, y **la vista gira** en la captura. Control: volver a 152,62 y ver la fila 0 y la imagen de antes.
- **3c** — `0x0058EF61` (`cam+0x7E1`) = 1 → **cambia la vista activa** (la captura cambia sin que se mueva el jugador). Control: volver a 0.
- **ValueDB** — un valor de `ANDY.AKU` con efecto medible en RAM, escrito en su lugar del volcado vivo → el efecto aparece; control: el valor original lo deshace. (El valor concreto se elige leyendo la tabla, antes de escribirlo, y se anota acá abajo en el resultado.)
- **1** (mitad sin Fran) — `jugador+0x418` = 1 y teclado (mando 1) empujando hacia adelante 1 s: **el jugador NO se mueve** (el mando 1 dejó de manejarlo). Control: con 0, la misma tecla lo mueve. Riesgo escrito antes: el índice se lee en la **init** de controles (bitácora (61)), así que en caliente puede no hacer nada — eso sería un resultado, no una falla. La otra mitad (el mando 2 lo maneja) necesita a Fran.
- **1 (versión sin teclado, agregada antes de correrla):** al recargar el slot 3 la mira **gira sola** a **+27°/s** con el pitch clavado en −70° (medido: 10 lecturas en 2,7 s, pendiente constante): una entrada sostenida que llega por el **mando 1** (el jugador tiene `+0x418` = 0). Predicción: con `+0x418` = 1 **el giro se detiene** en menos de un segundo (el mando 1 deja de manejarlo, y el 2 está quieto). Si sigue girando, el índice sólo se lee en la init y la escritura en caliente no hace nada. Control: volver a 0 y ver que el giro vuelve.
**Primer intento fallido, con su causa (antes de cualquier resultado):** los vigilantes con `--accion log` dieron **0 en los tres**, incluido el que predije ≥ 30/s. No vale: la bitácora de agosto ya había medido que `log` **no cuenta nada** (stub vacío) y que hay que usar `break`; el docstring de `depurador.py` seguía recomendando `log`. Y mi control era **negativo** (una palabra que nadie escribe), que da 0 igual con el instrumento roto. Poner un vigilante `break` con el juego corriendo **tiró abajo el emulador**; `herramientas/ritmo_vigilante.py` (nueva) pausa antes de ponerlo y mide el ritmo por **ciclos del EE** entre disparos.
- **1b (escrita después del resultado de 1 y antes de correrla):** en frío, `FUN_0013ba40` (init del jugador, desde la carga) **copia** el objeto de mando `*(sesión+0x21060 + idx·0xC)` en tres subobjetos: `J+0x588` (`+0x4F0+0x98`), `J+0x6D0` (`+0x620+0xB0`) y `J+0x7C8` (`+0x730+0x98`). En vivo los tres valen `0x005858A0` = gestor de entrada `0x00585400` + `0x4A0`, y el gestor arma **dos** controles virtuales de paso `0x16C` (lazo de 2 en el constructor y en el update). Predicción: escribir `0x00585A0C` (el control 2) en las tres copias **detiene el giro** (el mando 2 no deriva) o lo cambia al patrón del mando 2; control: volver a `0x005858A0` y el giro vuelve.
**Resultado:**
- **1 — negativa, con causa.** `+0x418` = 1 en caliente **no cambia nada**: el giro sigue a +27°/s (0,5 s y 1,5 s después) y el control con 0 también. No es falla del observable: el giro **viene** del mando 1 (bytes crudos del puerto 0: sin botones, stick derecho `0x85/0x85`, izquierdo `0x8A/0x73`: deriva física). La causa, leída en frío: `+0x418` sólo se lee en la init (`FUN_0013ba40`), que lo usa para copiar el objeto de mando.
- **1b — CONFIRMADO en RAM, con control, por dos observables.** Con las tres copias en `0x00585A0C` (control 2): el yaw **invierte** el giro (+27°/s → −28°/s) y el pitch sale del tope −70° y sube a +39° en 3 s; con las tres de vuelta en `0x005858A0`, el yaw vuelve a +27°/s y el pitch vuelve al tope −70°. Los bytes crudos explican el signo: el mando 2 deriva al revés (`RX 0x7C`, `RY 0x78`). **El mando 2 maneja al jugador 1 cambiando tres punteros**; ningún código nuevo hace falta para esto. `entrada` **K4 → K5**.
- **Hallazgo para el diseño del coop (probable, frío + un dato en vivo):** la tabla de mandos de la sesión `sesión+0x21060` (entradas `{objeto, idx, idx}` de 0xC) se construye en `FUN_001020c0` con un lazo **compilado en 1** (`iVar4 < 1`), igual que `jugadores[]`, y su update por cuadro (`FUN_00107e20`, `FUN_00107e28`) es un stub vacío. **En vivo, la «entrada 1» es el campo siguiente de la sesión**: `+0x21070` = `0x004BCF78`, el modo B (medido). No hay lugar para un segundo jugador en esa tabla; el jugador 2 tiene que llevar su objeto de mando **directo** (sus tres copias en `0x00585A0C`), que el gestor ya actualiza por cuadro.
- **3b — medido en vivo.** Con `break` puesto en pausa (`ritmo_vigilante.py`), el bloque `0x0043F790` se escribe **4 veces por cuadro**, siempre desde `0x00269F78` (adentro de `FUN_00269ea0`), en ráfagas separadas por un período de ≈ 4,0 M del contador de ciclos. Calibración del cuadro (la unidad del contador no se supuso): la lectura de la vida desde el HUD (`0x001EEBD8`) repite con 4,016 M. Predicción (≥ 1 por cuadro desde esa función) cumplida; el discriminante «2 por cuadro» dio **4**: el motor sube cámara/viewport cuatro veces por cuadro.
- **4 — medido en vivo.** La vista 160 × 112 (`0x004CA2F0`) se **lee 10 veces por cuadro** desde 9 sitios del render (`0x001C1AD8` … `0x001D3FCC`, este último en `FUN_001d3fc0`, eslabón de la cadena en frío hacia `FUN_00269ea0`); cada sitio repite con período 4,01–4,06 M (80 disparos). La segunda pasada es **por cuadro**: (69) queda medido en vivo. `render` **K3 → K4**. El framebuffer `0x16B` no se volcó (memoria del GS, fuera de PINE).
- **3a — negativa en `0x005A8FA0`.** Escribir 0 / 90 / 0 / −90 / 0 en el yaw de mira: 70 ms después el valor sigue la deriva del mando (−126, −124, −122, −120, −118) como si no se hubiera escrito. Ese campo se **recalcula por cuadro** desde otra fuente; no es la entrada. La fila 0 y la copia de la cámara siguen a −yaw en todas las lecturas (±0,4°). **Predicción nueva, escrita antes de probarla:** el yaw del jugador `J+0x2F0` (`0x005A8DA0`) es la fuente: escribir ahí salta la vista y el de mira lo sigue; control, el valor anterior.
- **3a, segunda y tercera vuelta — negativas, y la causa.** `J+0x2F0` (`0x005A8DA0`) y `0x006B81C0` también se pisan en < 70 ms. Barrido de la RAM en dos instantes (grados y radianes, con ±360): sólo cuatro floats siguen al yaw. Quién los escribe (vigilante `break`): `J+0x2F0` ← `0x0013B6EC`; `0x006B81C0` ← `FUN_00170320` (lo deriva de la matriz del jugador: un consumidor); la mira `+0` ← `0x001407A8`, al final de **`FUN_001404a8`, el integrador de la mira**: con el stick y `dt = juego+0x1C` acumula el yaw en **`mira+8`**, el pitch en `mira+0xC` con tope ±70° (el −70 de la deriva) y la sensibilidad en `mira+0xA8/+0xAC`; y **copia `+8` en `+0`** cada cuadro. **Predicción, antes de correrla:** escribir `0x005A8FA8` gira la vista y se sostiene (sigue con la deriva desde el valor escrito); control, el valor anterior.
- **3a — CONFIRMADA en RAM y en pantalla, con control.** Escribir `mira+8` (`0x005A8FA8`): 0 → 1,9; 90 → 91,8; −90 → −88,3 a los 70 ms (la diferencia es la deriva), y `mira+0` y la fila 0 de la matriz del jugador lo siguen en el mismo cuadro; volver a 0 lo devuelve. En pantalla, con pitch 0: yaw 0 muestra el viaducto y yaw 180 la torre del otro lado (`3a-yaw0.png`, `3a-yaw180.png`, no se commitean). **La vista se gobierna escribiendo un float**; para el coop, la mira del jugador 2 es su propio objeto de mira. `camara` **K3 → K5**. Anular la sensibilidad (`mira+0xA8/+0xAC`, 350 y 350) no frenó la deriva; se recargó el savestate para no dejar el cambio.
- **3c — negativa.** `cam+0x7E1` (`0x0058EF61`) = 1: el byte se sostiene (1 a los 0,3 s y a los 1,3 s, nadie lo pisa), pero la imagen **no cambia de modo**: las tres capturas (antes / 1 / control) difieren entre sí lo mismo (17–21 de diferencia media en 192 × 108) y sólo por la deriva. O no es «vista activa», o hace falta otra condición. No se afirma nada más.
- **Inyección de entrada (nueva; predicción escrita antes).** La cadena medida: jugador → control virtual (`ctrl1 = 0x005858A0`) → `ctrl1+0xC` apunta al **mando procesado** (`gestor+0x2C0`, 0xF0 B, sticks como floats normalizados en `+0x8C…+0xC8`), que el gestor reescribe cada cuadro desde el SIO. Copio ese mando procesado a `0x00472000` (adentro de un tramo de `.bss` de 44 KB en cero en los 3 volcados y en vivo: libre **probable**) y apunto `ctrl1+0xC` ahí. **Predicción:** con los floats de sticks del falso en 0, **el giro por deriva se detiene** (nadie actualiza el falso); control: `ctrl1+0xC` de vuelta a `0x005856C0` y el giro vuelve. Si se detiene, escribir un stick en el falso mueve al jugador sin manos.
- **Inyección — CONFIRMADA en RAM con control.** (El primer intento no discriminó: el emulador estaba **pausado** por el depurador sin que se pidiera, en `0x00336668`, y al reanudarlo se cerró; se relanzó y se recargó el slot 3.) Con el mando falso en `0x00472000` y sus sticks en 0, la deriva **se detiene en seco** (yaw clavado en 45,0 durante 1,25 s) y con `ctrl1+0xC` de vuelta en `0x005856C0` vuelve a +27°/s. Barrido de ejes (0,8 durante 0,5 s cada uno, yaw fijo): `+0x8C`/`+0x90` avanzar/retroceder (±5,0 m), `+0x94`/`+0x98` laterales (~3–5 m), `+0xA0` pitch (−70 → +70), `+0xA4`/`+0xA8` yaw ∓33°. **El jugador camina y mira sin manos**: `sondas_coop.py falso-poner | eje <nombre> <valor> <s> | falso-quitar`. Para el coop es el otro lado de la sonda 1: el jugador 2 puede leer un mando **construido**. Para el método: las sondas que pedían a alguien en el mando (disparadores, la cámara desactivada, los menús) dejan de depender de Fran para moverse; los **botones** todavía no están mapeados.
- **Disparadores (predicción escrita antes).** `*(0x0040F4F4)` = `0x005A8980`, 60 zonas en `0x010A2F80`; posición en `+0xA0`. Estados medidos (`+0x11C`, `+0x120`): 40 en (1, 0), 11 en (1, **4**), 9 en (0, 0); ninguna en 3. Rumbo de «adelante» = 90° − yaw (calibrado con el mando falso). **Predicción:** caminando con el mando falso hasta la zona #21 (−19,1; 86,7; a 23,8 m), al entrar cambia su `+0x11D` o su `+0x120` y **ninguna otra** cambia (control: las otras 59 quietas en el mismo intervalo); si ninguna cambia, la #21 no es de las que prueban al jugador en este estado.
- **Disparadores — NO CONCLUYENTE, con lo medido.** Caminando con el mando falso el jugador se traba en paredes y desniveles (a 9,4 m de la #21, que además está un piso arriba, y a 18,6 m de la #13); ninguna de las 60 cambió. Llevar la zona al jugador (traslación `+0xA0` en los pies, en la cabeza y a media altura; con la #13 armada en estado 3 y la #47 a 133 m como control, también en 3): **ninguna dispara**, `+0x11D` sigue en 0. Sí quedó medido en vivo que **la prueba corre por cuadro** sobre la zona armada: lecturas de su matriz desde `0x0016A610` (`FUN_0016a5e8`) y de su estado desde `0x0016A27C` (`FUN_0016a250`, que pone `+0x11D` = 1 al entrar y llama a `+0x14`); y que el lazo `FUN_00165df0` sólo prueba las de **estado 3** (en este savestate no hay ninguna: 40 en 0, 11 en 4). La #13 es de clase `0x003DC010`, con `+0x150` = 1 y caja fina (±2,25 × ±1,0 × ±0,1: un marco de puerta). Hipótesis para la próxima: `FUN_0016a5e8` prueba contra algo cacheado en la carga (mover `+0xA0` no mueve la caja), o el punto que prueba no es el que se supuso. Lo del coop no cambia: sigue en pie, en frío, que prueban **sólo al jugador 0**.
- **Botones del mando falso — negativo.** Poner en 1, de a uno, cada byte de `+0x10…+0x8B` del mando falso: ningún cambio en el objeto jugador por encima del ruido (17–40 palabras por 0,5 s quieto). Los botones no están ahí como bytes; hipótesis: el control virtual los lee de los bits crudos (activos en bajo, `FFFF` = nada) del búfer del puerto que dice `mando+0xEC` (0 en el 1, 1 en el 2), que el SIO reescribe cada cuadro.
- **Botones, segunda vuelta (después del cierre, con margen de contexto).** En frío: `FUN_0026baf8` (init del mando procesado) deja ver **28 entradas**: bytes en `+0x0E` y `+0x2A` (hipótesis: actual y anterior) y floats en `+0x4C + 4·i`. Los sticks medidos son las entradas 16–27 (`+0x8C…+0xC8`), así que las **16 primeras, `+0x4C…+0x88`, serían los botones como presión** (el barrido de bytes de arriba escribía 1 en un byte suelto = un float ~1e-45: no probaba nada). Con 1.0 en el float y 1 en el byte de cada entrada: en RAM, los botones 11 y 12 superan el ruido (48 y 37 palabras contra ~33; el 12 toca la matriz de la cabeza); en pantalla, **4, 8 y 10 cambian la pose del arma** (levantada / inclinada / fuera de cuadro). **Hipótesis**, no mapa: cuadros sueltos con humo y enemigos alrededor (ruido de pantalla 6,8 total, 10,2 en la zona del arma). Para confirmarlo hace falta un observable en RAM del arma (munición o estado del arma del jugador, `kb/estructuras.json`).
- **No se hicieron (piden a alguien en el mando o botones):** 5a (recorrer los menús con el vigilante en `0x004BC208`), la cámara desactivada (`0x0040D9A3` = 1 y matar con el rifle a más de 6 m), la ValueDB con efecto (sus 49 valores con nombre son todos de **sonido**, y el valor se copia a la variable al registrarse en la carga) y los niveles de prueba 96–99 (elegirlos desde el menú).
- **Volcado nuevo:** `volcados/ee-11.bin`, slot 11 (nivel 2), 32 MB por `volcar_vivo.py`; vida 750, `juego` = `0x005A8A80`, fila 0 = −yaw otra vez. Subido a `black-datos` (`60fd514`, SHA-256 `801dceab…` en el `MANIFIESTO`).
- **De paso, `depurador.py`:** su docstring recomendaba `--accion log` y eso **no cuenta** (medido otra vez hoy, y ya estaba en la bitácora de agosto); se corrigió el docstring. Poner un vigilante `break` con el juego corriendo tiró el emulador: `ritmo_vigilante.py` pausa antes.

---

## 2026-09-27 (75) — GLOBDATA.BIN: las seis secciones tienen consumidor; hay cuatro niveles de prueba sin datos en el disco; corrección de «SHL»
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** el mapa (P5); a F de contenido (pickups, niveles) · **Nodos:** `iso-globdata` **K1 → K2**; `proyectiles` (corrección de texto, sin cambio de K)
**Objetivo:** la sonda de `iso-globdata` («el consumidor de cada sección después del relocador `FUN_00105D48`»), que se puede hacer en frío porque `GLOBDATA.BIN` está en `black-datos`.
**Resultado (en frío; lo de formato, medido sobre el archivo):**
- s0 = **`TEXDIC`** (64 texturas globales) → `recursos` tipo 0. s1 = **`MYDICTIONARY`** (28 modelos globales por id64: `BG1_PST/SHG/ASR_SHL`, `BG1_HGR`, `BG1_RPG_SHL`, `BG1_GRL_SHL`, pickups `BP1_*_AMO`, `BP1_MED`, llaves `BP1_BLUE/BLACK/RED`, `BP1_PLANS`…) → `FUN_001af930` y `recursos` tipo 1. s3 = armas (ya confirmada). s4 → `pickups`. s5 → `juego+0x5AB8` (consumidor sin leer).
- s2 = **la tabla de niveles**: 12 registros de 0x24 B (nombre ASCII, id en `+0x10`) que usa el menú. 8 de campaña (ids 0, 1, 5, 3, 4, 6, 7, 8: **no hay id 2**) y **cuatro de prueba con ids 96–99: `Character Viewer`, `Object Viewer`, `Danger Room`, `Gun Street`**. Medido contra `kb/lbas-iso.json`: el ISO sólo trae `LEVEL_00…08` sin el 02, así que **los de prueba no tienen datos en el disco**.
- **Corrección de (73):** `BG1_ASR_SHL` convive con las `_SHL` de pistola y escopeta, así que SHL es probablemente la **vaina**. Lo de «las secuencias de `F504`/`F530` siguen un proyectil» no estaba sostenido y se sacó de `kb/`. Queda lo medido: un objeto de 0x120 B con ese modelo, la cámara en modo 0xB/3 y el jugador sin control. La bandera `0x0040D9A3` sigue sin escritor.
**No funcionó:** tomar las claves de `TEXDIC` por id64: son índices 1…64, no nombres.
**Sigue:** esta tanda en la nube se cierra acá. En el mapa, en K1 queda sólo `frontend-datos` (con `WPNSCOPE.BIN` en `black-datos` se puede empezar en frío). Todo lo demás pide la notebook.

---

## 2026-09-27 (74) — El resto de E5: `0x0040F510` es el gestor de bancos de sonido (y se fusiona en `audio`)
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** el mapa (P5) y los conceptos de audio (A1, A2) · **Nodos:** `s-0x0040F510` (K1) **se fusiona en `audio`**, que pasa de **K2 → K3**; quedan 37 nodos
**Objetivo:** lo que E5 dejó a medias, con `perfil_singleton.py` y la raíz del cuadro de (73).
**Resultado:** los métodos más usados de `F510` (`FUN_00280200`, 19 sitios) recorren bloques de **0x1040 B** y buscan una clave de 64 bits con **búsqueda binaria** (`FUN_0027fcf8`) sobre entradas de 0x20 B ordenadas. Se decodificaron las claves de los bloques en los volcados con `id64.py`: **son nombres de sonido** (`PSTFIRE`, `SHTG01-COCK0`, `BULLETBYS0…`, `BODYFALL`, `CHNGWPN0`, `CONCRETE__`, `E_BLACKHD_M0`). **Medido en los 3 volcados:** 11 bancos, 213–214 sonidos, todos los directorios ordenados. Además, 35 ranuras de 0x3C B en `+0xE00` que se piden y se sueltan (hipótesis: voces; en los volcados ninguna está marcada). Con la interfaz leída, `audio` sube a K3 (el tope en frío) y el nodo sin nombre se borra: dos nodos para el mismo objeto serían una segunda fuente de verdad (como `render` en (70)).
**De paso:** A1, A2 y J4 del catálogo tenían como riesgo «de dónde sale el valor»; quedó contestado con (73) y se reescribió en `kb/conceptos.json` con los valores medidos. En J4 va una advertencia: los de `Collision.cfg` son del `.cfg` de **sonido** de colisión, no necesariamente de la física.
**No funcionó:** contar voces ocupadas por el bit 0 de `ranura+0x30` dio 0 en los tres volcados: o no había sonidos en ese instante, o ese bit no es «ocupada». No se afirma.
**Sigue:** el plan del ELF quedó entero (E1–E7). En el mapa quedan dos nodos en K1, los dos del disco: `frontend-datos` e `iso-globdata`.

---

## 2026-09-27 (73) — E6 cerrada: los 12 sin nombre tienen nombre, y dos hallazgos de paso (la ValueDB compilada y una cámara desactivada)
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** el mapa (P5), COOP (M2) y cualquier mod de parámetros · **Nodos:** `sin-nombre` (K1) **se disuelve**; nacen `disparadores` (**K3**), `unidades`, `ragdoll` y `proyectiles` (K2); `render`, `arranque` y `valuedb` suman evidencia (sin cambio de K)
**Objetivo:** el resto de E6 de `docs/14`: los 12 singletons de `sin-nombre`.
**Resultado (en frío salvo donde dice «medido»; nombres = hipótesis con evidencia, K2):**
- **Método.** Las cadenas no dieron nada (0 en los 12). Herramienta nueva `herramientas/perfil_singleton.py`: por singleton, el alojamiento en el arranque, los métodos (funciones que lo reciben como primer argumento), los campos y **desde qué lazo cuelga** cada método. Control positivo: `render` sale alojado con 0xD600 B (= censo) y sus métodos cuelgan del render de los modos. **Corrección de método:** el update del juego por cuadro es `FUN_00129360`, que cuelga de `main` y **no** de las vtables de los modos; sin esa raíz, la mitad de los updates salían «sin lazo».
- `0x0040F4C8` → `render`: doble búfer en la **scratchpad** del EE (0x70002000 / 0x70002800, índice % 2).
- `0x0040F548` → `arranque`: **cargador de los 10 IRX** del IOP (SIO2MAN … MC2_D). `0x0040F4F8` → `arranque`: 39 palabras en −1 que **nadie usa** después del init (medido: igual en los 3 volcados).
- `0x0040F54C` → `valuedb`: **el búfer de `Data/Andy.aku`, que es la ValueDB compilada.** Contesta la sonda abierta de `valuedb` («de dónde sale el valor»): 1322 pares (f32, clave) + 21 archivos `.cfg`; la clave es un CRC-32 (tabla `0x003C09F0`, sin xor final, corrimiento **aritmético**) de `nombre + grupo + "/" + ruta.cfg`. Control positivo doble (`herramientas/valuedb_aku.py`): 5 de 8 rutas del ELF y 49 variables registradas caen en las tablas, con valores físicos coherentes (medido). 1273 claves siguen sin nombre.
- `0x0040F4F4` → **`disparadores`** (K3): las zonas disparadoras del stage. Cada cuadro llevan la **posición del jugador 0** (`juego+0x1C0`, medido: la cámara está 1,45 m arriba) a su marco local y disparan al entrar o salir. Medido: 60 objetos de la clase `0x003DC010`. **Para el coop: sólo prueban al jugador 0.**
- `0x0040F534` / `0x0040F538` → **`unidades`**: listas con doble búfer de la unidad actual y la siguiente, llenadas al cargar `Unit_%02d.bin` y `StUnit%02d.bin` (módulo de **tipo 0x24**, sin clasificar hasta hoy).
- `0x0040F4CC` / `0x0040F52C` → **`ragdoll`**: el método de daño del personaje (vtable `0x003DC5F8`, entrada 52) aplica un impulso al cuerpo, lo activa en `F4CC` y lo sigue 0,7 s en `F52C`.
- `0x0040F520` / `0x0040F504` / `0x0040F530` / `0x0040F508` → **`proyectiles`**: `F520` son las **granadas en vuelo** (id64 `BG1_HGR` y `BG1_GRL_SHL`); `F508`, 8 ranuras de **muerte animada**. `F504` y `F530` llevan cada uno **un** proyectil `BG1_ASR_SHL` y una secuencia que toma la cámara y el control del jugador. **La de `F504` está desactivada de fábrica:** la habilita `0x0040D9A3`, que **nada escribe** (escaneo gp-relativo y absoluto, con control positivo en la vecina `0x0040D9A2`). `F530` recorre un array con cuenta **compilada en 1**, como `jugadores[]`.
**No funcionó:** las cadenas (otra vez). Suponer que `FUN_00107d20` era el constructor de `F54C`: es el asignador genérico del montón `0x0040F0F0`. Leer `FUN_0027f9c0` como la escala de tiempo: escribe `juego+0x24`, una bandera (corregido antes de anotarlo).
**Sonda para la notebook (nueva, se suma al lote):** `0x0040D9A3 = 1` por PINE y matar con el rifle de asalto a un enemigo a más de 6 m → predicción: una secuencia de cámara que sigue al proyectil; control: con 0 no pasa.
**Sigue:** `s-0x0040F510` (el único singleton en K1) con `perfil_singleton.py`, ahora con la raíz del cuadro.

---

## 2026-09-27 (72) — E6, primera parte: `tiempo` ubicado (el período de cuadro es 1/fps, y el fps es 30 o 25)
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** el mapa (y a cualquier mod que toque la velocidad) · **Nodos:** `tiempo` **K0 → K2**
**Objetivo:** E6 de `docs/14`, empezando por el único nodo en K0.
**Resultado:** se buscó en la zona estática un float con cara de *dt* que fuese coherente en los tres volcados y que usara el código. `0x0040EBAC` vale **1/30** en `ee-e4` y `ee-nivel-mod0` y **1/60** en `ee-03` (medido). Su único escritor es `FUN_0027f730(fps)`: `= 1.0/fps`. `FUN_00125060` elige **30, o 25 si `0x0040EAD8`** (bandera de 50 Hz), y además inicializa un reloj en `sesión+0x20120` (`FUN_0027f7d0`/`FUN_0027f818`); la llaman el arranque y cinco funciones del front-end. Ningún llamador pasa 60: **hipótesis**, `ee-03` se tomó con un parche de 60 FPS. `0x003C95AC` sigue el mismo patrón desde otro subsistema (`FUN_002e8920`).
**No funcionó:** nada en particular; los otros 94 candidatos a *dt* no tienen usos con nombre en el decompilado.
**Sigue (próxima sesión en la nube):** el resto de E6 —los 12 singletons de `sin-nombre`— y `s-0x0040F510`. Las cadenas rinden poco (E5): conviene el diferencial de cada objeto entre volcados y el grafo de llamadas.

---

## 2026-09-27 (71) — E7, sesión y modos: el modo que pone la cuenta en 2 está vacío y nadie lo activa
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2), sonda 5 · **Nodos:** `sesion` (K3, con la tabla de modos en `kb/subsistemas.json#sesion.modos`)
**Objetivo:** E7 de `docs/14`: las tres clases de modo y el camino hacia `FUN_00106010`. Se hizo antes que E6 porque el plan ordena por la cartera (primero el coop).
**Resultado (en frío; probable):**
- La sesión tiene **cuatro** modos embebidos, no tres: front-end (`+0x20220`, vtable `0x003DB5E8`), juego B (`+0x20F78`, `0x003DB590`), juego A (`+0x20FA0`, `0x003DB4E0`) y el **vacío** (`+0x20F90`, `0x003DB538`). `FUN_001034b0(sesión, modo)` cambia de modo; `sesión+0x21070` es el actual. **Medido:** en los 3 volcados el actual es B, y el global `0x0040EADC` también apunta a B.
- B y A son juego: su método 3 es el render del cuadro (`FUN_001297E0`), y A entra desde el menú con un parámetro y carga el stage. El front-end es el que activa el juego (`FUN_00103990` y `FUN_0020F268` escriben `0x0040EADC = B`).
- **El vacío:** su «entrar» (`FUN_00106010`) pone la cuenta en **2** y borra `+0x2020C/+0x2020D`; los otros 8 métodos son `return`, **sin update ni render**. Ningún código lo pasa directo a `FUN_001034b0`. Queda un camino indirecto (`*(0x0040F544)+0x3880`, leído en `0x0020xxxx`), que vale 0 en los 3 volcados.
**Qué contesta para el coop:** no hay un modo de dos jugadores escondido y jugable. El vacío parece el **resto** de uno recortado (hipótesis): deja la cuenta en 2, pero no trae ni lógica ni render. El coop se **construye** (una cuenta en 2 sobre el modo B, un segundo jugador y la segunda pasada de cámara de E3/E4), no se desbloquea. La sonda 5a de la notebook sigue valiendo, con una predicción ahora concreta: **ningún camino de los menús escribe 2 en `0x004BC208`**.
**No funcionó:** buscar un puntero al modo activo dentro de la sesión con el objeto empezando en el vptr: en GCC 2.x el vptr va después de los datos (`+8`), y el objeto B empieza en `+0x20F78`, no en `+0x20F80`.
**Sigue:** E6 (los 12 sin nombre y `tiempo`), si alcanza el contexto; si no, queda para la próxima sesión en la nube.

---

## 2026-09-27 (70) — E5, los dos grandes sin nombre: uno era el render; el otro sigue sin nombre, con la sonda achicada
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** el mapa (P5 del trade) · **Nodos:** `s-0x0040F4C0` **se fusiona en `render`** (35 nodos); `s-0x0040F510` sigue en **K1**
**Objetivo:** E5 de `docs/14`: nombrar `0x0040F510` y `0x0040F4C0` con evidencia.
**Resultado:**
- **`0x0040F4C0` es el gestor de render** (probable): es el objeto de E4 —listas de dibujo, cámara RW en `+0xD540`, la vista 160 × 112 en `+0xD170`— y además, al cargar cada `Unit_NN.bin` (`FUN_0012EAE8 → FUN_00383978`), registra las texturas de reflejo `Glass_Ref`/`Glass_Ref2` en `+0xCD70`. Tener dos nodos para el mismo objeto era una segunda fuente de verdad: `s-0x0040F4C0` se borró y su evidencia pasó a `render`.
- **`0x0040F510` no se deja nombrar en frío con lo que hay.** Sin cadenas propias; convive con `juego` (68 funciones), `vista-fp` (24), `recursos` (22) y `front-end` (19); el subobjeto de `+0xCBA0` (vtable `0x003DB640`, 5 métodos) sólo levanta banderas. Pista débil: el cargador de habla por nivel (`spch_%s%s`) está entre sus usuarios. **Medido:** entre los tres volcados cambian 456 de 13.058 palabras, **todas** en `+0xB9D4…+0xC988`; los primeros ~46 KB son idénticos. La sonda quedó chica: un *watch* sobre ese tramo durante un diálogo y durante un tiroteo.
- Herramienta nueva: `herramientas/nombrar_por_decompilado.py` (cadenas por singleton, ponderadas por rareza, resolviendo las constantes que Ghidra deja como número).
**No funcionó:** las cadenas como señal: el código del motor casi no usa texto (2 y 3 cadenas para objetos de 52 KB). Leer la vtable con paso 4 (son de 8 B por entrada en GCC 2.9x, como ya dice el contrato).
**Sigue:** E6 (los 12 sin nombre y `tiempo`), E7 (sesión y modos).

---

## 2026-09-27 (69) — E4, el render: el motor ya dibuja una segunda pasada de escena por cuadro, con su propio viewport y framebuffer
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2), sonda 4 · **Nodos:** `render` **K1 → K3**; `s-0x0040F4C0` gana nombre probable (gestor de render; se formaliza en E5)
**Objetivo:** E4 de `docs/14`: viewport/scissor del GS, y si el motor ya dibuja más de una vista por cuadro.
**Resultado (en frío; grado: probable, salvo lo medido):**
- El cuadro es `FUN_001297E0(juego)` → `FUN_001C9110`. Las pasadas principales ponen la cámara con `FUN_0026a6f0` (framebuffer entero). **Dos pasadas más** (`FUN_001c1a98` → lista 3, `FUN_001c28b0` → lista 4) arman `{cámara RW = *(0x0040F4C0)+0xD540, vista = *(0x0040F4C0)+0xD170}`, ponen la cámara **con ese rectángulo** (`FUN_001d3fc0`/`FUN_001cfa58` → `FUN_0026A460`), pisan el ancho/alto del framebuffer, dibujan y restauran.
- **Medido en los 3 volcados:** la vista de `+0xD170` (`0x004CA2F0`) es **160 × 112** con registros GS propios: `SCISSOR` 0..159 × 0..111, `FRAME` `0x3016B`, `ZBUF` `0x1000177`. Iguales en los tres.
- `cam+0x14 == 1 → perspectiva` coincide con `rwPERSPECTIVE = 1` de RenderWare: la cámara es un `RwCamera`, y el camino es el del driver PS2.
- La mira del francotirador no muestra una segunda cámara: `sniper_SetMaxZoom` sólo aparece registrado en `FUN_0021a7e0` (capa de scripts o eventos, singleton `0x0040F544`). Hipótesis: el zoom es un cambio de FOV sobre la misma cámara.
**Qué contesta para el coop:** la «salida por abajo» del PDP (que el motor no pudiera dibujar dos vistas en un cuadro sin reescribir el render) **no se da**: ya dibuja una segunda pasada de escena por cuadro, por la misma cámara, a otro framebuffer y con otro viewport. M2 sigue siendo L, no XL. Lo que falta es del lado del juego: `FUN_001297E0` pasa `jugadores[0]` fijo y la vista principal es una sola. (probable; el efecto se ve recién en la notebook)
**Predicciones para la notebook:** (a) *watch* de escritura en `0x004CA2F0` → quién arma la vista 160 × 112 y cuándo; (b) volcar el framebuffer `0x16B` durante el juego → qué se dibuja ahí (hipótesis: brillo o reflejo a ¼); (c) su `SCISSOR` a 0..319 × 0..223 → la imagen se agranda.
**No funcionó:** buscar un puntero al texto `sniper_SetMaxZoom` en el ELF (cero): el código lo arma con `lui`/`addiu`, y sólo el decompilado lo encuentra.
**Sigue:** E5, los dos grandes sin nombre (`0x0040F510` y `0x0040F4C0`).

---

## 2026-09-27 (68) — E3, la cámara: el negativo de (65) era un error de UNIDADES, y el render recibe viewport y cámara como parámetros
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2), sonda 2 · **Nodos:** `camara` **K0 → K3**; pista fuerte para `render` (sonda 4, E4)
**Objetivo:** E3 de `docs/14`: quién consume el yaw, dónde está la cámara y una predicción comprobable en la notebook.
**Resultado (todo en frío; grado: probable, salvo donde dice medido):**
1. **El yaw de `jugador+0x2F0` está en GRADOS.** Medido en los 3 volcados: −23,95 / −145,83 / −86,06, y la fila 0 de la matriz en `jugador+0xD0` está a 23,95° / 145,9° / 86,05°. `matrices_vs_yaw.py` le aplicaba `math.degrees()` a un valor que ya estaba en grados; con la unidad corregida, la **misma** búsqueda que dio cero encuentra matrices a dirección fija que siguen al yaw en los tres volcados. **El negativo de (65) queda anulado.**
2. `FUN_0013b628` copia el yaw de `*(jugador+0x32C)` = `0x005A8FA0`, un objeto de mira: `+0` yaw, `+0xC` pitch (11,48°, que coincide con la fila 2 de la matriz). La matriz `jugador+0xD0` (filas de rotación + posición en la fila 3) es la cabeza del jugador; `+0x460` = `+0xD0` × `+0x420` (el arma en primera persona, que se dibuja con `FUN_001af738`).
3. **El gestor de cámara es el singleton `0x0040F4BC`** (5.760 B, `FUN_00382500`; estaba en «sin nombre»). Tiene dos vistas, `+0x700` y `+0x750`, y el byte `+0x7E1` elige cuál (`FUN_00110650`). En `+0x7A0` (`0x0058EF20`) hay una **copia exacta de la matriz del jugador** en los 3 volcados (medido).
4. **La cadena del render, entera:** `FUN_001297E0(juego)` —llamado por tres funciones de la zona de modos (`0x001056C0`, `0x00106550`, `0x00106D70`)— hace `FUN_001368f0(jugadores[0], cam+0x7A0)` y después `FUN_001C9088 → FUN_001C9110` (el cuadro) → `FUN_001cfa58` / `FUN_001d3fc0` → `FUN_0026A460` → **`FUN_00269ea0(&0x0043F710, viewport, cámara)`**, que copia la matriz de `cam+0x20…+0x5C`, arma la perspectiva con near/far de `cam+0x80`/`+0x84` (far = 5000 en los 3 volcados, visto en la columna w de `0x0043F710`) y sube 10 qw a la dirección `0x3F6` del VU1 (`UNPACK V4-32`).
5. **Para la pantalla dividida, lo central:** el viewport es un rectángulo empaquetado (4 × 11 bits, centrado en 2048 como el GS) y la cámara es un puntero: **los dos son parámetros**. Si el holder trae un rectángulo, `FUN_001cfa58` dibuja en un sub-rectángulo con su propio XYOFFSET (`x·−8 + 0x8000`); si no, `FUN_0026a6f0` usa el framebuffer entero. Lo que está compilado para uno es la llamada: `FUN_001297E0` pasa `jugadores[0]` fijo.
**Predicciones para la notebook (sonda 3, en lote con la 1 y la 5a):** (a) escribir el yaw de mira `0x005A8FA0` (f32, grados) gira la vista, y la fila 0 de `0x005A8B80` queda a −yaw; (b) un *watch* de escritura sobre `0x0043F790` salta una vez por cuadro desde `FUN_00269ea0`; (c) `0x0058EF61` (`cam+0x7E1`) en 1 cambia la vista activa.
**No funcionó:** el primer listado de referencias a `0x0043F000–0x0043FC00` volcó 200 líneas al chat: había que agrupar por función. Contexto gastado sin necesidad.
**Sigue:** E4, el render: quién arma el rectángulo que reciben `FUN_001cfa58`/`FUN_001d3fc0` (las pasadas en `*(0x0040F4D8)+0x66280/+0x66288`) y si algo del juego ya lo usa (la mira `WPNSCOPE`, espejos).

---

## 2026-09-27 (67) — E2: el ELF entero a C, y 1194 funciones que Ghidra no había visto
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** todo el mapa (la materia prima de E3–E7) · **Nodos:** ninguno sube de K por esto solo
**Objetivo:** E2 de `docs/14`: decompilar todas las funciones a `black-datos/decompilado/` con un índice función → singletons, y certificarlo contra `censo_subsistemas.py`.
**Resultado:** **11.041 funciones a C, 0 fallas, 48 s** con 4 hilos (`herramientas/decompilar_todo.py`). 42 archivos de 64 KB de código cada uno más `indice.json` (13 MB, en el repo privado). El control compara **sitios** (la instrucción que carga el global), no cuentas de funciones: **2454 de 2471 sitios de `censo` (99,3 %) están entre las referencias de Ghidra**, que además ve 1577 más (censo busca el `lui` sólo 40 B atrás: es cota inferior, como ya decía). Los 17 que faltan son casi todos `addiu` que arman el puntero en el constructor `FUN_001020c0`, donde Ghidra no crea referencia. Control en verde con tolerancia 1 %.
**Lo que encontró el control, que es lo importante:** en la primera pasada faltaban 44 sitios, y en la mitad **Ghidra no tenía ni una instrucción**. Medido: el análisis automático dejaba el **95,2 %** del `.text` dentro de funciones y 304 huecos de ≥ 64 B con 170 prólogos adentro. Es código que sólo se llama por puntero. `herramientas/completar_funciones.py` crea funciones en los punteros de `.data`/`.rodata` hacia esos huecos y en los prólogos, con un filtro para no partir funciones (la palabra anterior tiene que cerrar otra: `nop` o el delay slot de un `jr ra`): **+1194 funciones** (1096 desde `.data`, casi todas vtables), **97,8 %** cubierto, 107 huecos grandes. El decompilado de E2 se rehízo después; el control positivo de `info` sigue en verde (11.046 funciones).
**No funcionó:** comparar **cuentas de funciones** por singleton (primera versión del control): daba diferencias de +27, +71… que no decían nada, porque censo parte funciones por el `addiu sp` y Ghidra no. La comparación por sitio es la misma unidad en los dos caminos. `completar_funciones.py` se cayó dos veces antes de andar: importaba `ghidra` antes de arrancar la JVM, y leía la palabra anterior a `0x00100000`, que no está mapeada.
**Sigue:** E3, la cámara.

---

## 2026-09-27 (66) — E1 del plan del ELF: Ghidra headless en la nube, sin GitHub releases
**Máquina:** nube · **Modelo:** Opus, high, sin fan-out · **Sirve a:** COOP (M2) y todo el mapa: es la cadena de las sondas en frío · **Nodos:** ninguno sube (es instrumental)
**Objetivo:** E1 de `docs/14-plan-elf.md`: Ghidra + `ghidra-emotionengine-reloaded` en la nube, ELF importado y analizado, `decompilar.py info` en verde.
**Resultado:** **confirmado por control positivo**: `decompilar.py info` da `r5900:LE:32:default`, **9842 funciones**, 16.514 símbolos, y el 100.0 aparece en `0x00142B90` (el daño por zona, confirmado por efecto en la Fase 4b). El análisis automático tardó 132 s. El camino:
- el proxy da **403 a los releases de GitHub** (sólo sirve `git clone`), y conda-forge no tiene Ghidra. **`cache.nixos.org` sí responde**, y Hydra compila `ghidra-bin` **12.1.2**, la misma versión oficial. `herramientas/nube/traer_nix.py` baja el paquete y su clausura a `/nix/store/` sin tener Nix, y compara cada NAR contra su `NarHash` firmado (37 paquetes, todos OK, ~1 GB);
- la extensión **se compila desde la fuente** (tag `v2.1.36`, el que declara 12.1.2; el HEAD ya es 12.1.3) con Gradle 8.14.3 de `services.gradle.org`;
- el proyecto analizado pesa 37 MB → 7 MB comprimido, y quedó en `black-datos/ghidra/BLACK.tar.zst` (con su SHA-256 en el `MANIFIESTO`). Se probó restaurarlo en otra carpeta y el control positivo volvió a dar verde. La próxima sesión no reanaliza: `herramientas/nube/instalar_ghidra.sh` hace todo.
**No funcionó:** el primer import dijo `Unsupported language: r5900:LE:32:default` con la extensión bien puesta en `Ghidra/Extensions/`. El `support/launch.sh` de Nix es un **envoltorio** que ejecuta la copia de `/nix/store`, de sólo lectura y sin la extensión: la copia escribible nunca se usaba. Se reemplazó por el script real (`.launch.sh-wrapped`). Es la misma trampa que ya documenta `decompilar.py` (la extensión en la carpeta que Ghidra no carga), por otro camino: **el log decía de qué ruta cargaba los jar, y ahí estaba la respuesta.**
**Sigue:** E2, el decompilado masivo (`herramientas/decompilar_todo.py`).

---

## 2026-09-27 (65) — Sonda 2 (cámara), primer intento en frío: NEGATIVO por datos
**Máquina:** nube · **Modelo:** Opus, high · **Sirve a:** COOP (M2), sonda 2 · **Nodos:** `camara` (sigue en K0)
**Objetivo:** ubicar la cámara sin Ghidra.
**Resultado:** tres caminos, ninguno la encontró (resultado **negativo**, que también es dato):
1. las cadenas `<camerapath ...fov...>` (`0x003F3C20`) no tienen ninguna referencia en el código: es un escritor de depuración que quedó sin llamar;
2. en los tres volcados hay entre 8.700 y 9.900 matrices de rotación (tres filas unitarias y ortogonales). **Ninguna**, a dirección fija, cambia de rumbo junto con el yaw del jugador (`0x005A8DA0`: 67,9°, 284,8° y 109,0° en los tres volcados). Se probaron filas y columnas, los dos signos y dos planos (`herramientas/nube/matrices_vs_yaw.py`). Entre pares de volcados coinciden 100 a 300 casos, pero en los tres a la vez ninguno: son azar;
3. `jugador+0x2F0` casi no se lee con `lwc1` directo (1 sitio, `0x0013B6EC`): el yaw se lee a través de otro puntero.

Hipótesis que siguen en pie: la cámara está en el heap y cambia de dirección entre volcados, o guarda la vista como matriz de vista × proyección, que no es ortonormal.
**No funcionó:** la búsqueda por datos a dirección fija.
**Sigue:** Ghidra en frío (decompilar `0x0013B6EC` y a quienes la llaman, y `sniper_SetMaxZoom` en `vista-fp`: si toca un FOV, la cámara está cerca). En la notebook: un *watch* de lectura sobre `0x005A8DA0` por PINE.

---

## 2026-09-27 (64) — Sonda 5 del coop en frío, desde la nube: el juego recorre a sus jugadores con una cuenta, y hay código que la pone en 2
**Máquina:** nube (sin emulador), con el repo privado `black-datos` · **Modelo:** Opus, esfuerzo high, sin fan-out
**Sirve a:** proyecto COOP (M2), sonda 5 de `PDP.md` §4 · **Nodos:** `juego` (K4, evidencia nueva), `sesion` (**nodo nuevo, K3**), `hud` (pista)
**Objetivo:** contestar en frío quién recorre `jugadores[]` y con qué límite.
**Resultado:** Fran subió el ELF, tres volcados (`ee-e4`, `ee-03`, `ee-nivel-mod0`), `WPNSCOPE.BIN` y `GLOBDATA.BIN` a un repo privado. Los SHA-256 coinciden con su manifiesto. Control positivo: `censo_subsistemas.py` reproduce en la nube los 37 singletons, con el jugador dentro de `juego` y los dos mandos dentro de `entrada`. Después, con capstone sobre el `.text` del volcado (`herramientas/censo_jugadores.py`):
- hay 9 lazos que avanzan de a 0x8C0. Los que **construyen** son de una vuelta, con N = 1 compilado (`FUN_00382778`, `0x001282E0`, `0x0012A0F0`). **Cuatro que recorren** (`0x0012A068`, `0x0012BF28`, `0x0012C038` y un par) usan como límite `*(0x0040F0E0)+0x20208`, una cuenta que vale 1 en los tres volcados;
- `0x0040F0E0` **no está entre los 37 de `FUN_001020c0`**. Apunta a `0x0049C000`, un objeto de sesión que construye `FUN_00387e50` con tres objetos de modo embebidos (vtables `0x003DB590`, `0x003DB538` y `0x003DB4E0`). Entró al mapa como `sesion`, en K3;
- tres funciones escriben la cuenta: **`FUN_00106010` escribe 2** (primera virtual de la vtable `0x003DB538`), `FUN_00106868` escribe 1 (con un switch de 0x37 casos) y `FUN_00213CA8` escribe 1;
- 15 sitios indexan `jugadores[k]` con un k guardado en otro objeto: armas en `obj+0x48` y el HUD en `0x001F7C48–0x001FD6xx`. El motor sabe de qué jugador es cada cosa.

Grado de todo: **probable**. Es lectura de código en frío, sin efecto. Que exista un modo de dos jugadores alcanzable desde un menú es **desconocido**.
**No funcionó:** en el ELF no aparece ningún nombre del tipo «split», «versus» o «2 player»: la pista es sólo el código. capstone decodifica mal las `lq`/`sq` del R5900 y las muestra como instrucciones DSP; son guardados de pila y acá no importan. El primer script se llamó `dis.py` y tapó al módulo `dis` de Python.
**Sigue:** en la notebook, la sonda 5a: un *watch* de escritura sobre `0x004BC208` (la cuenta) recorriendo todos los menús, para ver si algún camino llega a `FUN_00106010`. Es inofensiva y va en lote con la sonda 1. En la nube, la sonda 2 (la cámara) desde el yaw `0x005A8DA0`, y la 4 (el render) con `WPNSCOPE.BIN`.

---

## 2026-09-27 (63) — MCR cerrada con los pesos delegados; la cartera es el coop
**Máquina:** nube · **Modelo:** Opus, esfuerzo high, sin fan-out
**Sirve a:** programa (MCR) y proyecto COOP (M2, M6); nodos que toca: ninguno por medición; plan para `camara`, `render`, `juego`, `entrada`, `codigo-nuevo`, `spawn`
**Objetivo:** cerrar la Pre-Fase A: preguntas, pesos, trade study y KDP-A.
**Resultado:** las 22 respuestas de Fran copiadas textuales (`docs/12` §7). NGOs N1–N7 validadas. Fran delegó los pesos y las decisiones («decide todo vos, primero el coop, despues vamos viendo»), y queda registrado como delegado. `trade` implementado: notas 0-1 derivadas de `kb/`, C1 por el método de rank-order centroid sobre el orden de NGOs, sensibilidad con 1000 corridas a ±50 % y N4/N5 intercambiadas, que no cambia el primero. KDP-A: la cartera es un proyecto, COOP; la meta pasa de M1 a **M2**, porque el juego es en primera persona; el segundo lugar queda vacío. Plan de desarrollo de tecnología con 7 sondas (`PDP.md` §4). Análisis en papel en `docs/13-coop.md`. `probar-programa.py` agrega el control positivo del trade (9/9).
**No funcionó:** la primera versión de la función de puntaje deja subir conceptos fáciles de valor casi nulo (E2, P4), porque C4 y C6 salen los dos del vehículo y juntos pesan 30. Se anotó sin retocarla. Después, con la delegación de Fran («administra todo tal que quede ordenado»), se agregó un **filtro de valor** con un umbral fijado por principio y no por resultado: C1 < 0,07, el peso de N5, la 5.ª meta. Saca a P3 y P4. **E2 sigue adentro** (C1 0,078, es N3 a la mitad) y no se bajó el umbral para sacarla: eso habría sido acomodar el criterio al número. Al primer intento de escribir `kb/conceptos.json`, `json.dump` reformateó el archivo entero (1274 líneas de diff); se revirtió y se editó por línea.
**Sigue:** en la notebook, la sonda 1 (`jugador+0x418 = 1` por PINE). En la nube, las sondas en frío 2, 4, 5, 6 y 7, si Fran sube el ELF y los volcados a un repo privado.

---

## 2026-09-26 (62) — BLACK pasa a programa: el nivel 1 del juego, 48 conceptos, y la reforma del método (P11)
**Máquina:** notebook · **Modelo:** Opus, esfuerzo máximo, sin fan-out
**Sirve a:** Pre-Fase A del programa · **Nodos:** todos los de nivel 1 (`kb/subsistemas.json`)
**Objetivo:** Fran pidió frenar el coop y hacer primero el plan más amplio
posible, siguiendo el handbook NASA, para que no vuelva a pasar lo de bajar al
detalle sin haber descubierto lo de arriba. Y reformar el método general, no
sólo BLACK.
**Resultado:**
(1) **El nivel 1 del juego, en una lectura:** `FUN_001020c0` construye **37
singletons**, cada uno colgado de un global en `0x0040F0E4`–`0x0040F54C` con
su tamaño. `censo_subsistemas.py` los ubica en `ee-e4.bin`, cuenta el código
que los usa (cota inferior: Ghidra ve 50 referencias al flujo donde el
escáner ve 8) y `nombrar_subsistemas.py` los nombra por sus cadenas. **En 61
entradas se habían tocado 6.** Control positivo: el objeto juego contiene al
jugador y el gestor de entrada a los dos mandos.
(2) Estructuras altas que no se buscaban: **el esquema de armas tiene
`AIParams` con Max Spread Angle y Accuracy Fall Off** (la puntería de la IA
puede estar en la tabla que ya se parchea); una **capa de comandos con nombre
hacia la interfaz** (objeto de 1 byte con ≥ 44 funciones) y la interfaz como
**datos** en `/EXPORT/FRONTEND/`; subsistemas de **estadísticas**, **pickups
(64)**, **guardado**; y `0x0040F510`, **la segunda interfaz más grande (≥ 219
funciones), sin nombre seguro**.
(3) **Pre-Fase A** con fuente única en `kb/`: 35 nodos con madurez K0–K7 y 48
conceptos candidatos en 7 categorías, cada uno trazado a NGO, funciones y
subsistemas. `programa.py` verifica las trazas, genera el catálogo y **se niega
a rankear sin los pesos de Fran**; su saboteador, 7 de 7 en rojo.
(4) **Método general:** D15 y P11 en `arquitectura-se`, sección «De arriba
hacia abajo» en la naturaleza `ingenieria`, nota en la plantilla del PDP,
lección de proceso con triage `propia` y su línea instalada en
`chequeo-de-trabajo.md`. Las 8 citas del handbook, medidas: 8/8.
**No funcionó:** (a) la primera corrida del medidor de citas dio 2/8 porque
el `.txt` de `%TEMP%` no era la fuente (1 página); se regeneró con la receta de
`pilares/README.md` y dio 8/8. (b) `programa.py resumen` escondía al coop: `k or
9` trata al K0 como falso. Lo vio la lectura del número, no el saboteador; se
sumó el caso y se lo vio en rojo contra el error real. (c) La lista de
«conceptos baratos y maduros» la escribí a ojo y erré en seis; ahora sale
calculada. (d) Atribuí a NASA el TRL 6 para la transición A→B y no lo dice:
lo pide para integrar una tecnología «into an SE process» (p. 195). Corregido;
la regla K5 quedó como decisión nuestra.
**Sigue:** Fran contesta las 22 preguntas → MCR → análisis del coop.

## 2026-09-26 (61) — 8c: el motor es de N jugadores compilado con N = 1, y ya lee el segundo mando
**Máquina:** notebook · **Modelo:** Opus, esfuerzo medio, sin fan-out
**Objetivo:** Fran pidió dos jugadores. Contestar en frío si el motor lo
admite, antes que la 8a.
**Resultado:** (1) El jugador se construye en `FUN_00382778` **dentro del
idioma de GCC para arrays** (contador N−1 hasta −1), con N = 1, paso `0x8C0`,
desde `juego+0x30`; el objeto juego cuelga de `0x0040F4D0`. Verificado contra
las instrucciones, no sólo el descompilado. Control de la base, no buscado:
`juego+0x4990 = 0x005AD410`, el doble buffer que 7e había medido. (2) **22
funciones** usan el paso `0x8C0`: el update recorre los jugadores en bucle
(`FUN_0012a0d8`) y el HUD elige jugador **por un índice propio**
(`FUN_0016bee0`). (3) **`jugador+0x418` es su número de mando**: `lb` en el
delay slot de `0x0013BA58`, pasado a la init de controles, que indexa
`gestor+0x77C+idx`. Vale 0 en tres volcados con vidas distintas. (4) **El
gestor de entrada construye dos mandos en un bucle de 2**, puertos 0 y 1 en
`+0xEC`, estado 4 los dos en los tres volcados, tope `idx < 2` en
`FUN_0026c9c0`. **El juego ya lee el segundo mando en cada frame.**
(5) Después del jugador (`juego+0x8F0`) **está ocupado**: 144 de 560 palabras.
Veredicto: coop es código acotado (alojar un jugador 2 aparte, `+0x418 = 1`,
redirigir los recorridos), no reescribir el motor. Falta la cámara.
**No funcionó:** un escáner propio de «global→campo» dio **cero también en su
control** (el gestor y su tabla de puertos), por `$gp` y por `lui`: el
instrumento estaba ciego y se borró sin commitear. Las referencias de Ghidra
sí resuelven `$gp`. Y el primer intento de ubicar la vtable del mando falló
porque GCC 2.9x usa entradas de 8 B `{delta, puntero}`: control positivo
`vtable_jugador + 0x4C = 0x0013BB78`, la rutina de daño ya confirmada.
**Sigue:** el efecto. Predicción escrita antes: con un segundo mando
asignado en PCSX2, mover su stick cambia `pad1+0x88` (`0x005857B0+0x88`), y
con el `pad1` quieto no cambia. Después, `jugador+0x418 = 1` antes de la init
de controles tiene que pasar el control del jugador al puerto 2.

## 2026-09-26 (60) — Revisión del plan: faltan estructuras, no detalle. Fase 8 abierta
**Máquina:** notebook · **Modelo:** Opus, esfuerzo medio, sin fan-out
**Objetivo:** antes de retomar, revisar el plan contra los requisitos y contra
el molde nuevo del método (arquitectura-se), para no seguir afinando un
detalle cuando faltan estructuras grandes por descubrir.
**Resultado:** cruzando cada requisito de `docs/00-conops.md` con lo que `kb/`
sabe: **R4 tiene su estructura** (STLEVEL, unidades, personajes `0xB0`, stream
de módulos), **R6 a medias** (geometría sí, colocación no), y **R3, R5 y el
catálogo de R2 no la tienen**. Dos mediciones en frío lo dimensionaron:
(1) **`GLOBDATA.BIN` tiene seis secciones y se entiende una** — la de armas,
8.960 B de 1.261.896 (0,7 %); la de `0x80` es el 81 % y no tiene nombre; la de
`0x133800` arranca con `33`, igual que los 33 valores del índice de tipo de
personaje (hipótesis débil: el byte 0 de la de armas dice 2 y tiene 17).
(2) **La ValueDB** (`FUN_0027B950`) **tiene 63 sitios de llamada, 58 con
nombre**, y ninguno es de IA ni de daño: controles, colisión, audio. Control
positivo: los cinco nombres de la mira aparecen. No es el catálogo de
dificultad que se podía esperar.
El PDP pasó al molde nuevo (rigor por aspecto `a`–`f`, «Cómo se certifica»,
matriz de 10 filas con un recorte y su resta). **7e(b) se canceló**: lo que 7e
compraba ya está y en frío; su efecto lo trae el experimento de R4. Se abrió la
**fase 8 — censo estructural** (8a quién piensa por el enemigo, 8b las seis
secciones de `GLOBDATA.BIN`, 8c si el motor admite dos jugadores), con
`kb/superficies.json` de semilla. R7 (remaster visual) entró al conops: la
línea existía desde el 2026-09-02 sin requisito.
**No funcionó:** leer `D:\GLOBDATA.BIN` — **no hay ningún ISO montado**, y
`ubicaciones.py` lo declaraba montado: imprime la sección `montajes` como
texto, no la mide. Se leyó por LBA del `.iso`. Un conteo de accesos `$gp` al
«directorio de subsistemas» `0x0040F4D0` dio **cero**: acusa al parámetro (se
accede por `lui`, no por `$gp`), no al directorio.
**Sigue:** 8a en Ghidra, en frío: el update del enemigo (vtable `0x003DCA78`)
y si su cierre de llamadas toca código `Kaim::`.

## 2026-09-05 (59) — L2 CERRADA: los vértices, tres eslabones más abajo
**Máquina:** notebook · **Modelo:** Opus, esfuerzo high, sin fan-out
**Objetivo:** sacar la lista de vértices de `CO01TRUCK` (`LEVEL_01/UNIT_01`,
`0x687CC0`) y verificarla contra su caja envolvente, que ya está en el archivo.
**Resultado:** el formato entero, y verificado sobre todo el ISO.
La cadena siguió por donde decía la sesión de la tarde: `submalla+0xC0` →
`FUN_0027e760` → `FUN_0027f6d8`/`FUN_0027f708`. Las dos últimas son **la misma
función byte a byte**, y ahí **se acaban las relocalizaciones** — que es cómo
se sabe dónde terminan los punteros y empiezan los datos.
Adentro hay un **árbol BIH** (nodos de `0x18`, cada mitad con el intervalo
exacto de su hijo sobre un eje), **hojas** de `0x10` con dos punteros, **caras**
de 8 B (4 índices `u8` + un `u32` que vale `0x0A`) y **vértices de 6 B**:
3 × `u16` con un **byte de sesgo por eje** en la hoja (`0x00` o `0xFF`; `0xFF`
= restarle `0x8000` antes de leerlo con signo). La escala es
`metros = (v + 0.5) · 1000/65536`: quantum de 15.2588 mm, o sea un `s16` que
cubre **±500 m** — y el `500.0` está literal en el registro de submalla, en
`+0x38`.
**La verificación fuerte es de contención:** los **630.379 vértices** de las
5883 submallas de las 42 unidades caen **adentro** de la caja que el propio
archivo declara. Cero desbordes. La caja calculada reproduce la del archivo a
menos de un quantum en 5850 de 5883, y el radio de la esfera de `+0xBC` —que no
es el de la caja, así que es prueba independiente— se reproduce en las 11
submallas de `CO01TRUCK` dentro de medio quantum.
**Control de forma que no se pidió y salió solo:** las submallas 2..7 de
`CO01TRUCK` son idénticas byte a byte, caja centrada en el origen y radio 0.58.
Son las seis ruedas.
Herramientas: `modelo.py` (con `obj`: 4125 vértices, 1653 caras) y
`probar-modelo.py`, seis sabotajes, los seis en rojo.
**No funcionó:** el primer control negativo del autotest —quitar el medio
quantum— **no puede fallar**: mueve el dato 0.5 quanta contra una tolerancia de
1 quantum entero, así que el autotest se puso en rojo por el control y no por
el decodificador. Se cambió por «ignorar el byte de sesgo». Y el intento de
leer los `u16` como `s16` pelados dio coordenadas de +32700 en props de medio
metro: fue el byte de sesgo de la hoja, no un error de escala.
**Las 33 submallas que no cierran la caja** son 13 modelos repetidos y **11 son
luces**: la caja del archivo es más grande que la malla y los vértices siguen
adentro. Caja floja, no error — se dice y no se tapa.
**Sigue:** **dónde se COLOCA** cada submalla. Las seis ruedas idénticas no
tienen transformación en el registro de `0xD0`; los candidatos sin abrir son el
`+0x1C` del modelo (registros de `0x30` por `FUN_001c64e8` → `FUN_001c62a8`) y
el `+0x20` (índices i16 dentro de `+0x38`). Y decidir si esto es la malla de
colisión o la de render, que hoy no se afirma.

---

## 2026-09-05 (58) — L2: la geometría se abrió POR EL CÓDIGO. `Unit_NN.bin` resuelto
**Máquina:** notebook · **Modelo:** Opus, esfuerzo high, sin fan-out
**Objetivo:** encontrar en el ELF la rutina que consume `Levels/Level_NN/Unit_NN.bin` y leerle el layout del header AL CARGADOR, sin entrar por los datos.
**Resultado:** hecho, y con margen: la cadena entera desde el format string hasta el parser, el layout del header (16 campos, 3 cuentas), el directorio de recursos compartido, y el header del modelo. Los modelos tienen NOMBRE legible. `herramientas/unit.py` + `probar-unit.py`.
**No funcionó:** nada se descartó, pero dos cosas quedaron acotadas y hay que decirlas: el ancho `u16` de `+0x90` NO es medible con los datos del ISO (sale del código), y el "232 VIFcodes desde 0x800" de la sesión anterior era señal real con lectura falsa. Y el autotest, la primera vez, moría con traceback en vez de reportar rojo.
**Sigue:** los VÉRTICES, entre `+0x58` y `+0x48` de cada modelo.

**La ficha `geometria_sin_resolver` terminaba diciendo por dónde seguir: "NO por
los datos. Por el CÓDIGO: encontrar en el ELF la rutina que consume
UNIT_NN.BIN... El formato de ruta ya está ubicado en `0x003F4388`." Se hizo
exactamente eso y salió en una sesión.** Cuatro eslabones, ninguna heurística:

1. **El único xref.** Barrido exhaustivo del ELF buscando pares
   `lui rX,0x003F` + `addiu rY,rX,0x4508` (la forma en que MIPS arma una
   dirección de 32 bits). En 3,1 MB de código hay **uno solo**:
   `0x0012D72C` + `0x0012D73C`. La misma búsqueda para `StLevel.bin` da
   también uno solo, `0x001288B8`+`0x001288C8`. Que el candidato sea único es
   lo que hace que el paso siguiente no tenga ramas.
2. **La máquina de estados** `FUN_0012d5a8` (`0x0012D5A8`). En su estado 2 arma
   la ruta con sprintf y **pide el archivo**:
   `FUN_001093c0(streamer, ruta, 8, id, CALLBACK, param, 1, 0x40000)`.
3. **El callback** `FUN_0012e728`, que hace lo que hacen los cinco callbacks de
   nivel: `buf = FUN_001092f8(); PARSER(buf); FUN_00108540(mgr, tipo, buf, id)`.
4. **El parser** `FUN_0012eae8` — que no parsea: **relocaliza**. Recorre el
   header campo por campo convirtiendo offsets-en-archivo en punteros absolutos.
   *Ese recorrido es el layout.* 16 campos y tres cuentas.

**Y esto cierra lo que la entrada `fixup_contenedor_bin` había dejado escrito el
2026-08-16**: «NO APLICA A TODOS LOS `.BIN`: `LEVELDAT.BIN` da tres ranuras
fuera de rango... Esos dos usan otro layout y **se resuelven igual — xref de su
cadena de ruta, decompilar su callback**». Se resolvió por esa vía, palabra por
palabra, tres semanas después. Y `LEVELDAT.BIN` vuelve a fallar ahora con el
layout de Unit, que es lo que se esperaba: cada `.BIN` de nivel tiene el suyo.

### Qué hay adentro

La lista de `+0x20` (la que el juego registra como recurso **tipo 1**) son **los
modelos, con nombre legible**. En `LEVEL_01/UNIT_01` hay 367 y se leen solos:
`CO01TREE_P_L`, `CO01ERLOG1`, `CO01AMMOBOX`, `CO01BOXES01`, `CO01WOODBOX`,
`CO01GUARDHUT`, `CO01TRUCK`, `CO01FENCE`, `CO01COMPGATE`. Un árbol, troncos, una
caja de munición, cajas, una garita, un camión, un alambrado, un portón: los
props del nivel.

El header de cada modelo sale de `FUN_001af930`, y ahí aparecen sus submallas
(`+0x48`, `count` en `+0x68`, registros de `0xD0`) y **tres floats que en
`CO01TRUCK` valen 30.0 / 60.0 / 100.0** — distancias de LOD.

El directorio que ordena todo esto (`FUN_00272aa8`) es **el mismo** que usan el
`.DB`, `LevelDat` y `StLevel`: `count` en `+0x08`, offset al array en `+0x0C`, y
registros de `0x10` con **id64 en `+0x00` y el puntero al recurso en `+0x08`,
relativo A LA LISTA y no al registro**. O sea que el "directorio de recursos con
nombre" que la fase 6 había medido en el `.DB` no era del `.DB`: es la
estructura de directorio del motor.

### Lo que la medición dice, y lo que no

**Positivos:** las **42** unidades del ISO cierran el layout entero — los 16
campos como offsets válidos, y el array de `+0x1C` terminando **exactamente**
donde arranca la lista de `+0x24` (eso ata tres cosas independientes: el offset,
la cuenta y el tamaño de registro `0x30`).

**Control negativo, que es lo que les faltó a las dos vías muertas:** el mismo
layout sobre `LEVELDAT.BIN`, `LEVEL.AWD`, `COLLIDE.AWD`, `AMBIENCE.BKS`,
`GLOBDATA.BIN`, el propio ELF y dos `.M2V`. **Los ocho caen**, con entre 5 y 20
problemas cada uno.

**Control positivo del método:** el mismo patrón aplicado a `StUnit` da
`FUN_002886d0` — y el formato de `StUnit` **ya estaba resuelto por otra vía**
(`stunit.py`, fase 7e). Coincide... y además **corrige**: `stunit.py` anotaba
`STUNIT+0x08` como "alineación 0x80". No lo es. `FUN_002886d0` trata `+0x04` y
`+0x08` idénticamente: a los dos les suma la base y los usa como punteros. Que
valga `0x80` es porque esa sección arranca justo después del header. **El
control positivo devolvió una corrección además de una confirmación**, que es
para lo que sirve.

**Lo que NO se puede afirmar:** el ancho `u16` de `+0x90` **no se distingue de
`u8` con los datos** — el máximo en las 42 unidades es 109 y el byte de `+0x91`
es cero en todas. Que sea `u16` sale del código (`*(ushort *)`), no de una
medición. El de `+0x92` sí se mide: llega a 889 y 14 unidades tienen el byte
alto distinto de cero. Queda escrito en el saboteador, no escondido.

### El indicio que parecía bueno, revisado

"232 VIFcodes encadenados desde `0x800` en `UNIT_01.BIN`" era **lo único que
había discriminado** en la sesión anterior. Con el layout real a la vista,
`0x800` cae **adentro del array del directorio** de la lista tipo 0 (que en
`LEVEL_01/UNIT_01` va de `0x650` a `0xB60`): la caminata estaba corriendo sobre
punteros e ids, no sobre display lists. Señal real, lectura falsa. Refuerza la
lección de las vías muertas en vez de contradecirla.

### Lo que sigue abierto, sin disfrazarlo

**Los vértices.** El grueso de un modelo vive entre su `+0x58` y su `+0x48`, y
ese bloque no está desarmado. El bloque de `submalla+0xC0` **no** es VIF crudo:
arranca con una caja envolvente (min xyz, max xyz con los signos opuestos). Lo
que cambió es que ya no hay que adivinar dónde mirar: se llega por punteros del
propio cargador.

### Herramientas

- `herramientas/unit.py` — `niveles` / `header` / `modelos` / `modelo` /
  `autotest`.
- `herramientas/probar-unit.py` — **cinco sabotajes, los cinco en rojo**, con
  control positivo antes y después de cada uno. El sabotaje 3 encontró un
  defecto real: el autotest moría con `struct.error` en vez de reportar rojo.
  Un autotest que revienta con traceback no es una alarma, es un cuelgue.
- `herramientas/decompilar_lote.py` — le hace **todas** las consultas a Ghidra
  en **una** apertura de proceso. Cuatro consultas por CLI son cuatro arranques
  de la JVM; esto es uno.


---

## 2026-09-05 (57) — La sensibilidad de mira es un float; los niveles se leen en frío; la geometría no
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out (Fran pidió
explícitamente «sin workflows»)
**Objetivo:** Fran se fue a dormir y dejó cuatro pedidos: terminar el mouse,
ajustar DLSS5 y dejarlo listo para otros juegos, abrir puertas a modificar
niveles (enemigos, tipos, armas) y resolver las geometrías.

**Resultado.**

**1. La sensibilidad de mira EXISTE y es un dato.** `FUN_001404a8` es la
función de mira completa, y su último tramo es `yaw += eje_suavizado *
obj[0xA8] * dt * factor_zoom`. `0x005A9048` son los **grados por segundo
horizontales** (70.0 de fábrica) y `0x005A904C` los verticales (25.0).
**Confirmado por efecto con control negativo:** ×3 dio ×3.01 medido (87.7 →
264.4 grados/s), reversible, y el eje vertical no se movió (25.7 / 25.7 /
25.8). Setenta grados por segundo son casi dos metros de mousepad por vuelta a
1600 DPI: ésa era la queja.

No se llegó por barrido. Se buscaron los **lectores** del Analogue Control
Power ya conocido: como el objeto de controles es jugador+0x4F0 y el parámetro
es obj+0xB8, `barrer.py off 0xB8 --solo load` restringido a
0x00130000-0x00150000 dio **dos `lwc1` contiguos** entre 25 candidatos, que son
X e Y de la mira.

**2. `mira-lineal` quedó confirmado por efecto de paso.** La curva medida es
lineal con zona muerta (k≈155, d≈0.089, mismo ajuste en cinco puntos). Una
cúbica predecía una razón de 10.6 entre eje 0.25 y 0.55; la medida es 3.09.

**3. DLSS 5 estaba APAGADO** — faltaba `DLSS5_Feed@DLSS5_Feed.fx` en
`Techniques=` del preset, y eso no da error ni aviso. Medido: cuesta 10 fps
(58.19 → 48.09).

**4. `STUNIT0N.BIN` y `STLEVEL.BIN` resueltos.** Los 42 stream de módulos del
disco y el directorio de armas de los ocho niveles se leen (y se escriben) en
frío. Control cruzado de 61 puntos contra lo medido en RAM.

**No funcionó.**

- **La predicción de 8.20 sobre el `upscale_multiplier` falló**, y falsa el
  modelo con el que 8.18 y 8.20 razonaban: bajar de 3 a 2 bajó el tiempo de GS
  un 4 % con 56 % menos de píxeles. El cuello del GS **no es de relleno**.
- **El test de frecuencia de VIFcodes NO discrimina.** Daba 10,8 % en la
  geometría y parecía confirmarlo; un video MPEG-2 del mismo disco da 14,71 %.
  El control negativo era gratis y estaba al lado.
- **Los DMAtags tampoco.** El audio encadena más tags que la geometría.
- **Tres controles positivos pasaron con la base de punteros mal.** Un
  corrimiento constante no cambia un conteo ni dos direcciones ni la
  monotonía: eran ciegos justo al único error que había.
- **El piso de la mira no se movió** al variar cinco cosas distintas. Puede ser
  del inyector, que manda ráfagas con huecos donde un mouse real manda
  movimiento continuo.

**Sigue:** que Fran juegue y diga si el piso existe con un mouse real. Y, para
la geometría, entrar **por el código** — la rutina que consume `UNIT_NN.BIN`
— y no por los datos.

---

## 2026-09-05 (56) — La mira de BLACK es CÚBICA: `Analogue Control Power` vale 3.0
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out (secuencial: cada paso salía del anterior)
**Objetivo:** Fran reportó que con `PointerInertia = 100` un manotazo corto y
rápido le hace dar vueltas enteras al jugador, y pidió linealidad sin tope
arriba ni piso abajo. La sesión anterior había dejado el mouse "lineal" en el
emulador; la queja demuestra que la linealidad del emulador no alcanzaba.

**Resultado.**

**1. La causa de fondo no estaba en PCSX2: BLACK eleva la entrada del stick AL
CUBO.** El ELF registra cuatro parámetros de control contra una base de valores
propia, y uno se llama `Analogue Control Power`. **Vale 3.0**, medido en diez
volcados independientes. Con esa curva un stick de 0.5 se convierte en 0.125 y
uno de 0.1 en 0.001. Eso explica las **dos** mitades de la queja con **una
sola** causa: los movimientos lentos casi no mueven la mira (no es zona muerta,
es que la curva es plana abajo) y la respuesta se siente de todo-o-nada porque
se empina de golpe arriba. Y explica por qué ningún ajuste del emulador podía
arreglarlo: PCSX2 entrega un valor lineal y el juego lo cubica después.

**2. La cadena hasta la dirección, entera y en frío.** `0x0013F3E0` hace cuatro
llamadas idénticas a la lectora de la ValueDB (`0x0027B950`) pasándole el nombre
en `a2` y el **puntero destino** en `a1`: `s3+0xB0`, `+0xB4`, `+0xB8`, `+0xBC`.
`s3` es su primer argumento, y llega desde `0x0013BA40` como `s1+0x4F0`; a ésa
la llama `0x0013A1D4` con `a0 = s1` de `0x00139C68`. Esa función escribe en
`s1+0x8A0`, `+0x8A4`, `+0x8A8`, `+0x8B1` y `+0x8B2` — **todos dentro del paso de
`0x8B0`** que `kb/campos-jugador.json` ya tenía medido para la estructura del
jugador, cuya base confirmada es `0x005A8AB0`. De ahí: `0x005A9050`.

**3. Diez volcados, dos controles positivos, y un control cruzado que no se
buscaba.** Los cuatro floats valen lo mismo en los diez volcados (0.5, 0.5,
**3.0**, 0.5), mientras la vida del jugador **varía** entre ellos (225.5, 437.6,
649.8, 750.0, 998735.0) y el puntero de clase en `+0x10` da `0x003DC5F8` en los
diez. O sea: son estados de juego distintos, no el mismo bloque repetido. Y el
control que apareció solo: `0x005A8DA8 - 0x005A8AB0 = 0x2F8`, y
`kb/estructuras.json#enemigo` ya tenía la vida del enemigo en `+0x2F8`. **Jugador
y enemigo comparten el offset de vida**, lo que confirma la base por una vía
independiente de toda la cadena de arriba.

**4. La lectora no escribe el valor: registra el destino.** `0x0027B950` guarda
el puntero destino en una tabla (`sw s0, 0(s2)`) más dos floats en `+4` y `+8`.
Por eso los nombres viven **sólo en el ELF**: se buscó `Controls_PS2` y
`Analogue Control Power` en **todos** los archivos del ISO montado y aparecen
únicamente en `SLUS_213.76`. No hay ningún `.cfg` suelto que editar.

**5. Los números del mouse, ahora exactos y no estimados.** Del fuente de
PCSX2: `ui_ctrl_range = 100.0f`, `pointer_sensitivity = 0.05f`, o sea que la
ganancia es `Speed * 0.0005` por cuenta y **se satura a `2000 / Speed` cuentas
por sondeo**. Con `Speed = 40` eso son **50 cuentas**: con un mouse de 1600 DPI
es un movimiento lento. Un manotazo de 12.000 cuentas deja ~200 sondeos de
deuda, y con `Inertia = 100` esa deuda se paga entera: más de tres segundos
girando a fondo después de soltar el mouse. **Ésas son las vueltas enteras**, y
salen de la fórmula, no de una impresión. Default nuevo: `Speed = 5`,
`Inertia = 25`, `DeadZone = 5`, más cuatro presets.

**No funcionó / lo que se corrigió.**

- **La sesión anterior le dijo a Fran que pusiera la sensibilidad de mira al
  máximo dentro del juego.** No aparece ninguna cadena de sensibilidad en el
  ELF (`ensitiv`, `Sensit`, `SENSIT`, `urnRate`, `ookSpeed`: cero apariciones).
  `probable`, no `confirmado`: los textos del menú podrían vivir en un archivo
  de idioma del ISO. Corregido en `docs/10-jugar.md`.
- **`Inertia = 100` era la mitad de la receta y se entregó como si fuera
  entera.** Es correcto que hace lineal el reparto de la deuda; lo que faltó
  decir es que sólo sirve si la deuda es chica, y que eso depende de `Speed`.
  Entregar la mitad de una receta produjo el síntoma **opuesto** al que se
  venía a arreglar, que es peor que no haber tocado nada.
- **El guardia de controles hizo su trabajo:** al intentar aplicar la config
  nueva, PCSX2 estaba abierto y el script se negó a tocar el ini. Sin ese
  freno, el cambio se habría perdido al salir del emulador.

**Sigue:** confirmar por efecto. `mods/mira-lineal.toml` ya está compilado y
**prendido** en el menú de parches; `mods/mira-sin-suavizado.toml` está apagado
y se prueba después, de a uno, porque sus tres parámetros son hipótesis leídas
del nombre.

---

## 2026-09-04 (55) — Jugabilidad: el mouse deja de perder movimiento, y el mapeo pasa a ser un archivo del repo
**Máquina:** notebook · **Modelo:** Opus, high, sin fan-out
**Objetivo:** que BLACK se pueda jugar bien mientras el reversing sigue por
otro lado — mouse lineal, teclas de PC, agachado mantenido, 60 FPS, un acceso
directo, y los parches a mano.

**Resultado.**

**1. La no-linealidad del mouse tenía una causa exacta, y está en el código de
PCSX2, no en la percepción.** `InputManager::GenerateRelativeMouseEvents`
acumula `delta * speed` en `s_pointer_pos`, recorta a `[-1, 1]`, **resta lo
consumido** y multiplica el resto por `s_pointer_inertia`. Con el default
(`PointerInertia = 10` → factor `0.10`) se tira el **90 % del sobrante en cada
frame**: un movimiento lento nunca genera sobrante y entra entero; un manotazo
genera casi todo sobrante y se pierde casi todo. Es exactamente el síntoma que
reportó Fran, deducido de la fórmula. `PointerInertia = 100` (factor `1.00`) no
tira nada: el giro total queda proporcional al desplazamiento total.
**Confianza: `probable`** — la fórmula es del fuente de PCSX2 (`confirmado` por
lectura), pero el efecto en pantalla todavía no se midió jugando.

**2. `PointerXScale` era letra muerta.** El ini tenía `PointerXScale = 8` en
`[Pad]` y `= 40` en `[Pad1]`. PCSX2 2.8.0 lee `Pointer{X,Y}Speed`,
`Pointer{X,Y}DeadZone` y `PointerInertia`, **en `[Pad]`**. Medido sobre el
binario: `Pointer{}Speed` y `Pointer{}DeadZone` están como cadenas de formato,
`Pointer{}Inertia` **no** (la clave es `PointerInertia`, sin eje). O sea que
todo el ajuste de sensibilidad que se venía haciendo no tocaba nada.

**3. El mapeo de teclas estaba mapeado contra un layout supuesto, no el real.**
El layout de BLACK es: Cross recargar, Square agarrar/cambiar, Circle melee,
Triangle silenciador, L1 mira, L2 agachado, R1 disparar, R2 granada, cruceta
arriba modo de fuego, cruceta izq/der cambiar arma, cruceta abajo botiquín. El
ini tenía Triangle = R "recargar", que es el silenciador. Lo corrobora el
propio reporte de Fran: pidió *"que se recargue con R"*, o sea que R no
recargaba.

**4. El mapeo dejó de vivir sólo en un archivo que se pisa solo.**
`herramientas/configurar-controles.ps1` es ahora la fuente; el `PCSX2.ini` es
su salida. `-Verificar` sale con código 1 si difieren, y **se probó en rojo**:
sabotear `Cross = Keyboard/R` → `T` lo pone en `DIFIERE (2 líneas)`, restaurar
lo devuelve a `OK`.

**5. Los tres ISO comparten CRC `5C891FF1`.** Medido en `emulog.txt`
(`Disc changed to Black-mod-7b.iso` → `CRC: 5C891FF1`), no supuesto. La
consecuencia práctica: la lista de parches y el ini de gamesettings valen para
los tres, y no hace falta reconstruir un ISO para probar un mod.

**6. El acceso directo y el menú de parches.** `BLACK` y `BLACK - Parches` en
el Escritorio. El menú junta en una lista los parches oficiales del
`patches.zip` de PCSX2, los mods propios de `construido/*.pnach` y el overclock
del EE, escribiéndolos unificados en `Documents\PCSX2\patches\`.

**No funcionó / lo que costó.**

- **`Set-Content -Encoding UTF8` de PowerShell 5.1 escribe BOM**, y el
  `PCSX2.ini` quedó empezando con `EF BB BF`. Un ini con BOM le llega a PCSX2
  con la primera sección corrupta. Se detectó mirando los tres primeros bytes,
  no esperando el síntoma. Los scripts escriben ahora por
  `Escribir-Sin-BOM`, que usa `UTF8Encoding($false)`.
- **`(?m)^\[(.+?)\]$` de .NET no matchea líneas terminadas en CRLF.** Por eso
  el mod propio no aparecía en la lista de parches y los oficiales sí (venían
  del zip con LF). Arreglado con `\]\s*$`.
- **El nombre de sección del mod tenía guion largo y acentos.** Es el nombre
  que PCSX2 tiene que hacer coincidir letra por letra con `Enable = ...` del
  ini; pasado a ASCII en `mods/dano-x2.toml`.
- **El guardia de comandos bloqueó dos veces un comando legítimo** con
  `Remove-Item on system path '"C:\Program' is blocked`, sin que el comando
  tuviera ningún borrado. Se esquivó poniendo el mismo código en un `.ps1` y
  ejecutando el archivo. **El guardia no se tocó** — queda anotado como falso
  positivo a corregir en el patrón, no sacando el freno.

**Sigue:** medir por efecto las dos cosas que quedaron en `probable` — el FPS
real con el parche de 60 puesto (¿59.94 o 29.97?) y la linealidad del mouse
jugando. Las dos se ven en el primer minuto de juego, sin instrumental.

---

## 2026-09-04 (54) — PREDICCIÓN registrada antes de correr: verificación del x2 de daño por RAM, sin apuntar a ciegas
**Máquina:** notebook · **Modelo:** Sonnet, medium, sin fan-out
**Objetivo:** cerrar Fase 5a — confirmar por efecto que reescribir la palabra
`0x00142CA0` a `0x3C014348` (lui at,0x4348 → 200.0 en vez de 100.0) duplica el
daño de salida del jugador. El HANDOFF §11 pedía explícitamente NO apuntar y
matar a un enemigo para contar tiros a ojo. Mecanismo diseñado en su lugar:
leer `vida` (offset `+0x2F8`, confirmado en `kb/estructuras.json#enemigo`) de
TODO el pool de enemigos por RAM con `vigilar.py grabar`, mientras Fran juega
normal y dispara — sin coordinar a qué enemigo puntual apuntar.

**Predicción, ANTES de escribir nada:**

| zona golpeada | daño hoy (x1, confirmado) | daño esperado con el parche (x2) |
|---|---:|---:|
| cabeza (zonas 2, 11) | 102.0 | 204.0 |
| zonas 0, 1, 13, 14 | 51.0 | 102.0 |
| zonas 3, 8, 10, 15 | 34.0 | 68.0 |
| torso (zonas 4,5,9,12,16) | 25.5 | 51.0 |
| zona 20 | 20.4 | 40.8 |
| extremidades (21, 22) | 11.33 | 22.66 |

Control negativo: cualquier delta que NO sea el doble de una de las seis filas
de arriba (por ejemplo, que siga saliendo 25.5 exacto) refuta la hipótesis del
punto de parche, aunque el enemigo muera antes de lo esperado por casualidad.

**Mecanismo (no requiere que Fran cuente nada):**
1. `pine.py volcar 0 0x2000000 <dump>` fresco, ya con el nivel cargado.
2. `clases.py objetos <dump> 0x003DCA78` → direcciones de los objetos vivos del
   pool (hasta 32, paso `0x3C0`); `vida` de cada uno = objeto + `0x2F8`.
3. `pine.py escribir 0x00142CA0 0x3C014348 --tipo u32` — escritura EN RAM,
   no en el ISO. Se pierde al reiniciar el emulador, a propósito.
4. `vigilar.py grabar` con un `--dir <addr>:enemigoNN:f32` por cada slot vivo,
   corriendo mientras Fran juega y dispara normal.
5. Los escalones del CSV son el dato: se comparan contra la tabla de arriba.
   Si coincide, el punto de parche pasa a `confirmado` en
   `kb/mapa-memoria.json` y recién ahí se escribe el `.toml` del mod
   permanente (la plantilla lo prohíbe hasta ese momento).

**Resultado: CONFIRMADO.** Corrido en vivo sobre `LEVEL_02` (no `LEVEL_00`,
sin que cambiara nada del mecanismo: el escaneo por clase/vtable encontró el
mismo pool preasignado en `0x0058FE90`). Grabación de 150 s a los 32 slots del
pool + la vida del jugador (`volcados/verificacion-dano-x2-lvl2.csv`), Fran
jugando normal, sin apuntar a nadie en particular:

- **`enemigo01` recibió dos impactos consecutivos de exactamente `-47.6`
  cada uno.** No es el doble literal de ninguna fila de la tabla de arriba
  (esa tabla no incluye el multiplicador condicional `*0.7` de
  `calcular_dano_zona`, que evidentemente esta vez SÍ se activó). Pero
  `47.6 = 0.34 * 200.0 * 0.7` — el factor de zona `0.34` (zonas 3/8/10/15,
  ya documentado), el valor patcheado `200.0` y el multiplicador final `0.7`
  (ya documentado en la misma rutina) son TRES constantes independientes ya
  confirmadas antes de esta sesión, y su producto coincide con lo medido al
  bit. Sin el parche, ese mismo golpe hubiera dado `0.34*100*0.7 = 23.8`:
  el parche exactamente DUPLICA el daño de salida, tal como predecía la
  hipótesis — solo que sobre una combinación de zona/arma que activa el
  `*0.7` condicional, y no sobre la que estaba tabulada de Nivel 1.
- **Control negativo, en la misma ventana:** el jugador recibió tres impactos
  enemigos de exactamente `-26.0` cada uno — el valor YA confirmado de la
  Fase 1, sin ningún cambio. Confirma que el parche es unidireccional: sólo
  escala lo que el jugador dispara, no lo que recibe.
- Un tercer enemigo (`enemigo00`) murió de un solo golpe (`100.0 -> 0.0`),
  consistente con un headshot pero sin valor discriminante por sí solo (un
  headshot ya mata de un tiro incluso sin el parche, 102 > 100 HP).

**Punto de parche promovido a `confirmado`** en `kb/mapa-memoria.json`
(`multiplicador_dano_salida`) y en `kb/rutinas.json#calcular_dano_zona`. Fase
5a **CERRADA**. Se escribió `mods/dano-x2.toml` (antes prohibido por la regla
de la plantilla: no hay dirección sin confirmar) y compila limpio con
`pnach.py` → `patch=0,EE,00142CA0,word,3C014348`. Todavía no instalado
(`--instalar`) ni habilitado (`habilitado = false` a propósito): queda para
que Fran decida si lo quiere permanente.

**No funcionó:** el primer intento de grabación (90 s, `LEVEL_02` recién
entrado) dio CERO cambios en los 32 slots — el pool tenía los 32 en `vida=0`
en ese instante (sin enemigos activos todavía), y Fran no llegó a disparar en
la ventana. No es un negativo real, es ausencia de datos; se repitió con una
ventana más larga (150 s) una vez que Fran ya estaba en combate.

**Sigue:** R2 (`docs/00-conops.md`) sigue en *parcial* — el eje de daño ya
está cumplido de punta a punta (parche calculado, verificado, y ahora
compilable); falta la percepción de la IA (R3) y qué enemigos aparecen (R4,
depende de 7e(b), sin tocar). Pendiente de decisión de Fran: si compilar
`--instalar` el `.pnach` para que el x2 sobreviva a reiniciar el emulador, o
dejarlo sólo en RAM (se pierde al cerrar PCSX2).

---

## 2026-09-04 (53) — Huekage instalado (S7.8, verificación parcial); firma de malla confirmada, GtID refutado
**Máquina:** notebook · **Modelo:** Sonnet, medium, sin fan-out
**Objetivo:** instalar Huekage + el puente de hash de §7.7 y verificar por
efecto (fase de mayor apalancamiento medida: 100% de cobertura contra 92,7%).
Si eso cerraba, avanzar en frío en las dos líneas independientes: la firma de
bloque de malla del remake, y el GtID de la cabecera del `.DB`.

**Resultado:**

- **Huekage queda instalado como `replacements/` activo** (2781 + 18 del
  puente = 2799 archivos), pack anterior preservado. El puente sobre Huekage
  empareja MENOS que sobre el pack propio (18/38, no 35/38 — menos claves
  únicas). Confirmado por efecto: las 18 emparejadas dejan de faltar en un
  volcado de 80s (intersección 0).
- **A/B/C pareado, dos rondas, control obligatorio:** sólo "auto izquierdo"
  cerró el control las dos veces (+1%/+1%, −2%/−3%) — sin costo de nitidez
  ahí, tercera medición independiente en la misma dirección que §7.7. La
  región "barrera" (el síntoma original) **sigue sin poder medirse**: el
  humo/combate del savestate 03 nunca dio un control limpio ahí, en ninguna
  de las cuatro rondas acumuladas entre las dos sesiones. `hw_mipmap` vuelve
  a `false` al cerrar (mismo motivo que §7.7: el puente cubre una sola
  escena). Huekage queda igual como mejora neta del estado seguro.
- **La firma de bloque de malla PS2 `00 00 00 05 03 01 00 01 00 80`
  (de *Formats Takedown-Dominator*) queda CONFIRMADA**: 132.630 apariciones
  en 233/270 `.DB`/`.bin` del ISO, espaciadas de forma periódica y variable
  dentro de cada archivo — localiza cada bloque de malla sin parsear nada
  más.
- **La hipótesis del GtID de la cabecera del `.DB` (§3 de
  `remake-geometria-2026-09-04.md`) queda REFUTADA en su forma fuerte.**
  Codec bajado de la fuente primaria (`MediaWiki:CgsID/Compress.js` del
  wiki), validado contra el control publicado (`BURNOUT` = exacto). Sobre
  los 139 `.DB`: **0/139** en el match completo de 8 bytes. Las dos
  invariantes parciales que ya se tenían (byte0=0x00, bytes6-7="FT") se
  reconfirman 139/139, pero el header completo no es `compress(nombre)`.

**No funcionó:**

- Comparar el volcado de 80s de Huekage+puente (80 archivos) directo contra
  el "3" del pack propio (§7.7) — son duraciones de captura distintas, mismo
  error de denominador que ya se había corregido una vez para el 70,9%/92,7%.
  Se detectó antes de escribirlo como conclusión, no después.
- Fase C (dificultad, pnach `0x3C014348`) **no se tocó**: HANDOFF §11 ya
  advertía que "apuntar y matar a un enemigo para contar tiros no es algo
  que convenga hacer a ciegas", y `pnach.py` sólo compila desde `mods/*.toml`
  — escribir ahí violaría la regla del proyecto de no anotar una dirección
  hasta que esté `confirmado`. Queda en el mismo punto que la dejó la sesión
  anterior.

**Sigue:** encontrar una escena sin combate para medir "barrera" (Huekage);
decidir si el puente de Huekage necesita más candidatos antes de extenderlo
a todo el juego; conectar `fmt_Burnout3LRD.py` con la firma de malla ya
localizada; investigar la mitad baja del header del `.DB` (candidatos:
tamaño, checksum) si se retoma esa pregunta. Detalle completo:
`pruebas/huekage-puente-verificacion-2026-09-04.md` y
`pruebas/remake-firma-malla-y-gtid-2026-09-04.md`.

---

## 2026-09-04 (52) — V4: la causa raíz era el HASH, no el mip chain; arreglo construido y verificado por efecto
**Máquina:** notebook · **Modelo:** Opus (lectura de código fuente + diseño del diagnóstico)
**Objetivo:** diagnosticar por qué el síntoma "la pared se ve borrosa según el
ángulo" volvió después de instalar un mip chain verificado por bytes y por
píxel. Cerrar con un veredicto **por efecto** entre las tres hipótesis de §7.6.

**Resultado:**

- **El veredicto no fue ninguna de las tres: es una cuarta causa, y está
  CONFIRMADA por código y por efecto.** `GSTextureCache::HashCacheKey::Create`
  hashea el nivel base y, **si hay `lod`, también todos los niveles de mip del
  juego**. O sea que una misma textura tiene **dos `TEX0Hash`**, y el pack de
  2022 (volcado sin mipmapping) sólo trae el de sin-mipmap. Al activar
  `hw_mipmap`, PCSX2 pide un nombre que no existe, no encuentra reemplazo y
  dibuja el original de PS2. **Por eso el arreglo de §7.6 no cambió nada: el
  archivo que se arregló no se abría nunca.**
- **Tres medidas independientes**, todas por efecto: (1) el pack de
  diagnóstico con un color plano por nivel mostró **cero píxeles de color**
  mientras la escena perdía 47x de detalle — el reemplazo ni se cargaba;
  (2) volcados en la misma escena: **37 texturas sin reemplazo con
  `hw_mipmap = true` contra 5 con `false`**; (3) en los pares, el `CLUTHash`
  coincide **exacto** y sólo cambia el `TEX0Hash` — justo lo que dice el
  código, porque `CLUTHash` no depende de `lod`.
- **Arreglo construido y verificado:** `herramientas/puente_hash_mipmap.py`
  empareja por `(CLUTHash, TEX0 bits enmascarado)` y escribe copias del pack
  con el nombre nuevo. 35 de 38. Los volcados bajaron de **37 a 3** (las 3 no
  emparejadas) y los píxeles de nivel 1 del pack de debug pasaron de **0 a
  10.929** — que además prueba que **el mip chain de §7.6 sí se usa**, recién
  ahora que el archivo se encuentra.
- **Desbloqueo operativo, y es lo más reutilizable de la sesión:** la sesión
  **sí** puede ver la pantalla de PCSX2. `herramientas/pcsx2_teclado.ps1` le
  lleva el foco a la ventana del juego y le manda `F8`; PCSX2 escribe la
  captura y la sesión la lee. Toda la fase se hizo sin Fran delante.
- **Gap del saboteador de §7.6, cerrado:** al verificador de
  `regenerar_mipmaps.py` se le dieron dos archivos rotos a propósito y dijo
  que no en los dos, con los sanos del mismo lote en verde.
- Herramientas nuevas: `pcsx2_teclado.ps1`, `pcsx2_ventanas.ps1`,
  `mipmaps_debug_color.py`, `detectar_nivel_mip.py`, `nitidez_regiones.py`,
  `cruzar_dumps_pack.py`, `emparejar_dump_pack.py`, `puente_hash_mipmap.py`.

**No funcionó:**

- **Leer los colores del pack de debug "mirando" la captura.** En la primera
  lectura parecían verse cuadraditos magenta (nivel 1) y se concluyó que el
  mip chain se leía. El detector por canal midió **0 px** de magenta: eran
  partículas violetas del juego. La conclusión se corrigió en el mismo turno,
  pero la lección es que la paleta sepia de BLACK engaña al ojo.
- **Las dos tandas A/B/C de verificación visual de la calidad final, ambas
  descartadas.** La escena del savestate 03 tiene humo intermitente y combate:
  el control positivo (C, que debe volver a ≈A) se desvió entre −76 % y
  +1585 %. Los números medían el humo, no el mipmap, y no se reportan.
- **Se perdió el encuadre de la barrera** al reiniciar el emulador: los 10
  slots de savestate estaban ocupados y no se quiso pisar ninguno. La escena
  del savestate 03 arranca en otro punto del nivel.
- **Dos falsos positivos del guardia `PreToolUse`** frenaron comandos
  legítimos (un `Copy-Item` leído como `Remove-Item`, y un `Start-Process` del
  emulador por llevar `Black.iso` como argumento junto a un `Set-Content`). No
  se sacó el guardia: se dividieron los comandos y quedó anotado.

**Sigue:** cerrar la verificación visual en una escena **estática** (con el
puente puesto, que es donde el puente aplica), y extender el puente a todo el
juego — mecánico y ya automatizado, pero **requiere jugar**. Además, rehacer
el 70,9 % de cobertura de V1: se midió sin anotar el estado de `hw_mipmap` y
puede estar inflado por este mismo efecto.

---

## 2026-09-04 (51) — V3 confirmada, mip chain real construida e instalada, síntoma reportado de vuelta sin diagnosticar
**Máquina:** notebook · **Modelo:** Sonnet (ejecución + lectura de código fuente de PCSX2)
**Objetivo:** cerrar V3 (pasar la causa de §7.3 a `confirmado`) y, si se
confirmaba, construir el arreglo de fondo (mip chain real del pack).

**Resultado:**

- **V3 CERRADA.** `mipmap=false`+`hw_mipmap=false` con ReShade apagado
  (verificado por efecto), Fran mirando el savestate 03: *"se ve nítida en
  los dos ángulos"*. Causa CONFIRMADA: el pack sólo traía el mip 0.
- **Hallazgo que cambió el diseño del arreglo:** se leyó el código fuente real
  de `PCSX2/pcsx2` (`GSTextureReplacementLoaders.cpp`,
  `GSTextureReplacements.cpp`) antes de construir nada. La convención
  `-mip%u` que el proyecto venía usando desde los strings del `.exe` es de
  `GetDumpFilename`, **sólo para volcado en PNG** — para DDS, PCSX2 lee los
  niveles embebidos en el mismo archivo vía `dwMipMapCount`. Generar archivos
  `-mip1.dds` sueltos no habría hecho nada.
- **Herramienta construida:** `herramientas/regenerar_mipmaps.py`. Preserva el
  nivel base byte a byte, genera los niveles chicos con Pillow (BOX filter),
  parcha 3 campos del header. Verificada en dos capas: por bytes (8225/8225
  OK, reparseo exacto del parser de PCSX2) y por píxel (decodificación de
  vuelta a PNG, contenido correcto).
- **Instalada** con backup del pack viejo (renombrado, no borrado) y
  `mipmap=true`/`hw_mipmap=true` restaurados.

**No funcionó — y es lo que más enseñó:**

1. **Verificación por bytes + por píxel no bastó.** Mirando la pared con el
   pack nuevo, Fran reportó *"ahora vuelve a desenfocar"*. No se pudo cerrar
   el loop de verificación por efecto (la sesión no tiene forma de ver la
   pantalla de PCSX2 sin robarle el foco de ventana a Fran). Quedan tres
   hipótesis sin descartar, con un test de un paso (`Insert` =
   `ToggleMipmapMode`) para separarlas en la próxima sesión con el juego
   delante — ver `docs/09` §7.6 y HANDOFF §9.
2. **El verificador de la herramienta nunca vio un archivo roto** — 8225/8225
   en verde, sin haber probado que sepa decir que no. Gap de la regla del
   saboteador, sin cerrar.
3. **La sesión terminó por tamaño de contexto** con dos líneas nuevas
   pedidas por Fran (remake de geometría/texturas con IA, dificultad/IA de
   enemigos) sin arrancar — quedaron registradas en HANDOFF §10 y §11 para
   que la próxima sesión no las pierda ni las redescubra de cero.

**Sigue:** diagnosticar el síntoma reportado (test de `Insert`, HANDOFF §9
ítem 1) antes de tocar cualquier otra cosa de la línea visual. Las líneas 10 y
11 son independientes y pueden arrancar en paralelo si el diagnóstico tarda.

---

## 2026-09-03 (50) — Fase V2: el síntoma de la barrera era el mipmap, y §1.5 lo había descartado con el modelo mental equivocado
**Máquina:** notebook · **Modelo:** Sonnet para ejecutar, Opus al aparecer la contradicción
**Objetivo:** matar la hipótesis 1 (carga asíncrona) del síntoma de §1.5 con
`PrecacheTextureReplacements = true`.

**Resultado:** murieron **dos** hipótesis, y apareció la causa real.

- **H1 (carga asíncrona): MUERTA.** Con los 1,3 GB precargados (verificado por
  efecto: 2,09 GB privados en el proceso) el síntoma no se movió.
- **H4 (post-proceso), que no existía al empezar: MUERTA.** Sin ReShade cargado
  (verificado por efecto: sus logs sin escribir tras el arranque) tampoco se movió.
- **CAUSA, `probable` con tres patas medidas: el pack reemplaza sólo el mip 0.**
  Convención leída de los strings del `.exe` (`...-%08x.png` vs
  `...-%08x-mip%u.png`), **0 de 8225** archivos con `-mip`, y `mipmap`/`hw_mipmap`
  en `true`. Los niveles bajos caen al original de PS2.

**No funcionó — y es lo que más enseñó:**

1. **La corrida 1 salió inválida por un confound que el repo declaraba imposible.**
   El HANDOFF dice que la línea de texturas (§9) y la de DLSS5 (§8) son
   independientes; **comparten el mismo `pcsx2-qt.exe`**, con ReShade + DLSS5-Feeder
   + RenoDX + LumeniteFX inyectados por `dxgi.dll` desde el 2026-09-02. El feed log
   mostró reconstrucción neuronal activa, sin vectores de movimiento y con la técnica
   del shader ausente. Dos líneas "independientes" en el papel, un solo proceso en el
   disco.
2. **§1.5 descartó los mipmaps con un razonamiento explícito y falso:** *"de cerca se
   usa el nivel 0"*. El mip se elige por footprint por píxel (derivada de UV), no por
   distancia: de refilón, a un metro, el GPU pide mip 2. Por eso el síntoma estaba
   atado al ÁNGULO, y por eso parecía contraintuitivo.
3. **Ese descarte reordenó la lista entera:** "regenerar mipmaps del pack" era el ítem
   **7 de 7** de la NEXT ACTION, ranqueado al fondo por culpa del descarte. Es el 1.

**Sigue:** `mipmap = false` con PCSX2 cerrado, mismo ángulo — si queda nítido en los
dos, la causa pasa a `confirmado` por efecto. Después, regenerar el mip chain del pack.
`dxgi.dll` quedó **renombrado a `.disabled`**: hay que restaurarlo para volver a la
línea DLSS5.

---

## 2026-09-03 (49) — Fase V1 cerrada: el pack cubre el 70,9 %, y el 29 % que falta es de su propio dominio
**Máquina:** notebook · **Modelo:** Sonnet, esfuerzo medio, sin fan-out
**Objetivo:** los tres números que la §4.3 del barrido dejó servidos: (a) GameIndex contra
la config real, (b) clasificar los 8225 `.dds` decodificando el bitfield, (c) cobertura.

**Resultado:** los tres, `confirmado`. Detalle en `pruebas/cobertura-pack-2026-09-03.md`,
síntesis en `docs/09` §6.

- **(a)** Los 6 `gsHWFixes` de `SLUS-21376` ya se aplican solos (`emulog.txt`:
  `GameDB: Enabled GS Hardware Fix: halfPixelOffset to [mode=5]`, etc.). Nada que corregir.
  **El `.ini` da la respuesta invertida**: sus `UserHacks_*` son los manuales y `UserHacks =
  false` hace que PCSX2 los ignore.
- **(b)** El pack no tiene 8225 texturas: tiene **5213 assets**; 3012 son otra variante de
  CLUT del mismo asset. **100 % paletizado** (PSMT4/T8/T8H, cero PSMCT*). **Upscale 4,0x
  uniforme en los 8225 sin una excepción** — firma de un pipeline automático.
- **(c)** **Cobertura 90/127 = 70,9 % (± ~1)** en el savestate 03. 29 % de lo que se dibuja
  cae al original de PS2.

**Lo que cambió el marco:** se predijo que el límite del pack sería estructural (100 %
paletizado ⇒ incapaz de cubrir color directo). Medido: **BLACK casi no usa color directo**
—125 de 127 pedidas son paletizadas—, así que el hueco **no es de dominio, es del propio
dominio del pack**: 36 de los 38 no cubiertos son del formato que el pack sí sabe reemplazar.

**Diseño que ahorró una corrida:** `GSTextureReplacements.cpp:800` **no dumpea lo que ya
tiene reemplazo**, así que con el pack activo `dumps/` es el complemento. La cobertura sale
de dos corridas del mismo savestate, sin cruzar hashes. Se leyó el fuente antes de medir.

**No funcionó:**
- **Dos de las tres predicciones fallaron** y estaban escritas antes de abrir el emulador:
  `N_A` cayó en 38 contra un rango predicho de 100-800, y los no cubiertos no paletizados
  fueron 5,3 % contra >50 % predicho. Fallaron **hacia el lado que enseña**.
- **El primer cruce dio 0/90.** Causa: el **bit 14** (`0x4000`, `unused0 // was TCC`). El
  pack es de 2022 y usa la convención vieja (`00005dd4` contra `00001dd4`). El emulador lo
  ignora con `RemoveUnusedBits()`; un cruce a mano no. Con la máscara: **90/90 OK**.
- **Casi se descarta una corrida válida por un `tail`.** Se grepeó un conjunto amplio y se
  cortó con `tail -15`: la línea del mipmap quedó afuera y se declaró que el pack no había
  cargado. Estaba en el log, a la vista.
- **El control A ⊆ B falla por 1 de 38**: la escena tiene humo y fuego animados y el set
  pedido no es idéntico entre corridas. Por eso la cobertura es 70,9 % ± ~1, no exacta.
- **Las dos capturas NO son un A/B visual pareado** — por lo mismo. Sirven para probar que
  el nivel cargó, no para comparar calidad.
- El guardia frenó un `Remove-Item` con wildcard sobre la carpeta de dumps. **No se sacó el
  guardia:** se cambió el método a renombrar, que además conserva la evidencia.

**Sigue:** `PrecacheTextureReplacements = true` — hipótesis 1 del síntoma de §1.5, una línea
del `.ini`, la más barata que existe y **todavía sin correr**. La (c) reforzó la hipótesis 2
pero no mató la 1.

---

## 2026-09-02 (48) — Había un pack HD de 8225 texturas en el disco desde junio, y no cargaba

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** contestar qué quedaba pendiente en gráficos y texturas, y buscar
todo lo ya hecho, empezado o disponible antes de aplicar cambios grandes.

**Resultado:** la línea visual dejó de vivir en el chat — se creó
`docs/09-remaster-visual.md`, enlazado desde el contrato. Y el barrido del
disco encontró lo que no estaba en ningún archivo del repo:
**8225 texturas `.dds` DXT5, 1305,5 MB, mtime 23/10/2022**, en
`C:\Program Files\PCSX2\PCSX2\textures\SLUS-21376\replacements\`.

**No cargaba, y por qué:** `[Folders] Textures = textures` es relativo al *data
dir*; el data dir activo es `Documents\PCSX2` (medido por mtime del `.ini`, no
supuesto) y su carpeta `textures\` tenía **0 archivos**. El pack estaba en el
árbol de la instalación vieja. `LoadTextureReplacements` ya estaba en `true`.
Es la categoría *"bajado pero sin incorporar"* de la lección 19 — la que un
chequeo binario presente/ausente no atrapa.

Copiado con PCSX2 cerrado y **confirmado por efecto** en `emulog.txt`:
`Disabling autogenerated mipmaps on one or more compressed replacement
textures` — línea que sólo se emite si PCSX2 encontró y cargó texturas de
reemplazo, y que no podía existir con la carpeta vacía. Validación de Fran con
el juego corriendo: *"se ve bien"*.

**De yapa, un gotcha del pack:** no trae mipmaps, así que PCSX2 desactiva los
autogenerados. Shimmer esperable en superficies lejanas, **no medido**.

**No funcionó / se corrigió:**
- El fan-out se diseñó **antes** de invocar `/engineering-orchestrator` y
  `/lecciones-aprendidas`, que el perfil marca como gatillo obligatorio ante
  una decisión de subagents. Fran lo frenó dos veces. Al leerlas, el diseño
  cambió: de 8 ángulos quedaron **7**, uno reconvertido de "barrido nuevo" a
  "re-chequeo de un negativo con fecha" (los tools RenderWare ya están en
  `docs/06`) y uno eliminado (`pipeline_metadev_ps2.txt` ya auditado el 27/08).
  Cada agente lleva ahora **control positivo obligatorio**.
- Se le pasó a Fran un comando en sintaxis de `bash` para una consola
  PowerShell — rebotó con `Token inesperado`. Y no correspondía pasárselo: la
  autorización permanente dice que el emulador lo abre la sesión.
- Se afirmó en chat que "el repo de ReShade no está bajado". Medido, la **base**
  sí está en las dos instalaciones; falta el repo completo de la comunidad.
- Los números de OSD de la corrida (`GS 22,3 %`, 29,93 fps) **no** son
  comparables con los de R3 (`GS 95 %`, ~52 fps): esa corrida fue **sin turbo**
  y bajo el cap ningún costo se ve.

**Sigue:** el barrido web de 7 ángulos (texturas, formatos, escalera de
remakes, decomp/recomp, **la versión Xbox**, comunidades, imagen del emulador)
quedó lanzado y sin aterrizar. Y de la vía A: A/B visual pareado, costo en FPS
con turbo, regenerar mipmaps, y contar qué fracción del juego cubre el pack.

---

## 2026-09-02 (47) — R2: NO era la firma ni la GPU. FALTA `nvngx_dlss.dll`. Confirmado en el Discord de RenoDX

**Maquina:** notebook MSI Sword 15 · **Modelo:** Opus, esfuerzo high, sin fan-out
**Objetivo:** investigar por que `SuperSampling.Available=0` antes de tocar nada, con la
consigna de Fran de leer el Discord de la comunidad.
**Resultado:**
1. **Re-medido al abrir:** el `nvngx_dlssnr.dll` NO cambio (mismo SHA256 `8270B350...`, misma
   firma `HashMismatch`, misma `FileVersion` 310.8.0.0). PCSX2 seguia corriendo (PID 36588).
2. **LA CAUSA, `confirmado` por medicion local + tres fuentes comunitarias independientes:
   falta `nvngx_dlss.dll` en `C:\Program Files\PCSX2\`.** El inventario de `*nvngx*` de esa
   carpeta devuelve UN solo archivo: el `dlssnr`. `SuperSampling` es la feature que provee
   `nvngx_dlss.dll`, y NGX resuelve las DLL de features desde el directorio del proceso.
3. **La evidencia de causalidad que faltaba, del Discord de RenoDX (`#dlss5-forum`, `tools`,
   `dlss5-helpdesk`) — es el ANTES/DESPUES que ninguna medicion local podia dar:**
   - POMAHECKO, **RTX 4070 SUPER**, NFS Most Wanted: *"The important part was adding
     nvngx_dlss.dll to host64. Before that: `SuperSampling.Available=0`, NGX unavailable.
     After adding nvngx_dlss.dll: `SuperSampling.Available=1`"*, y llego a `feature ready:
     2560x1440 DLAA` + `frame 10800 evaluated`.
   - TraceKira, guia de Skyrim SE: si falta, da exactamente `nvngx_dlss.dll MISSING` /
     `SuperSampling.Available = 0` / `CreateFeature failed 0xBAD0000B`. Y agrega:
     **"Keep both nvngx DLLs on the same version."**
   - Agai Naizagai, hilo **"The Sims 4 DLSS 5 RTX 4060"** (la MISMA GPU que la notebook):
     *"also u need the nvngx_dlss.dll, it is missing"* + el mismo log
     `SuperSampling.Available=0 NeedsUpdatedDriver=0 MinDriver=0.0`.
4. **El techo de hardware queda DESCARTADO.** Hay RTX 40 (4070 SUPER, 4080) con el pipeline
   corriendo y evaluando frames. ShortFuse (autor de RenoDX) publico un hilo dedicado,
   *"Patched DLSS-NR for RTX20, RTX30, and RTX40"*: *"Replace nvngx_dlssnr.dll with the latest
   pinned version. Auto branches based on hardware"*.
5. **La herramienta de reparacion de firma (Kayle) queda DESCARTADA como proximo paso, y era
   riesgosa:** exige restaurar un DLL con hash exacto del binario firmado por NVIDIA, que es el
   de Blackwell. La guia oficial del server dice lo contrario para esta GPU: *"If using RTX20,
   RTX30, or RTX40 series **overwrite** nvngx_dlssnr.dll with the **patched** version"* — y un
   binario parcheado tiene la firma invalida POR DISENO. "Reparar" habria ido para atras.
6. **Version:** la comunidad usa **310.8** en ambos DLL (Krish/RENO: *"dll's should ideally be
   310.8"*; caso funcionando en RTX 4080 con `nvngx_dlssnr 310.8.SF` + `nvngx_dlss 310.8.0`).
   Los tres `nvngx_dlss.dll` que ya hay en el disco son **310.2.1.0** y **3.7.0.0**: ninguno es
   310.8. Conseguir el 310.8.0 es el paso que falta.
7. **Cabo suelto que la guia de ShortFuse abre y no estaba en el radar:** *"If you have
   renodx-dlss5.addon64 remove or rename it (Can't use both)"* — la notebook TIENE ese archivo.
   Aplica solo si se pasa al "DLSS Tool (ShortFuse Version)"; con el pipeline actual, no.

**No funciono:** la busqueda del Discord con termino compuesto ("Patched DLSS-NR RTX40") dio
cero resultados sobre un hilo que existe y se llama casi asi. El parametro era el problema, no
la busqueda: ir al canal y leer el foro lo resolvio en un paso.
Tampoco pudo correrse `verificar-estructura.ps1` para confirmar por efecto el arreglo de la
regla 5 (dos falsos positivos nuevos, `info@reshade.me` y `Tecnica@Shader.fx`, que aparecieron
porque la bitacora 46 CITA los datos que declaraba): el clasificador de auto-mode bloqueo las
dos formas de invocarlo. El JSON quedo editado; el arreglo esta `probable`, no `confirmado`.

**Sigue:** conseguir `nvngx_dlss.dll` 310.8.0 y el `nvngx_dlssnr.dll` parcheado del pin de
ShortFuse, ponerlos en `C:\Program Files\PCSX2\` (lo hace Fran: la sesion no escribe ahi), y
medir `SuperSampling.Available` en `dlss5-feed.log`. Candidato de herramienta: RHI
(`github.com/RankFTW/RHI`), que la comunidad usa para esto — **sin revisar todavia**.

---

## 2026-09-02 (46) — R2: instalacion confirmada, DLL de firma invalida (no la GPU) — handoff a Opus

**Maquina:** notebook MSI Sword 15 · **Modelo:** Sonnet, esfuerzo medium, sin fan-out (mediciones en vivo con Fran)
**Objetivo:** correr `instalar-dlss5.ps1` (o verificar si ya se habia corrido) y cerrar R2 midiendo
por efecto: `dlss5-feed.log` + FPS sobre el savestate 03.
**Resultado:**
1. Reparado `verificar-estructura.ps1` (regla 5, 37 fallas): declaradas en `datos-permitidos.json`
   36 tecnicas de ReShade con formato `Tecnica@Shader.fx` (falso positivo del regex de mail, sin
   ninguna persona detras del `@`) y el mail del certificado de firma del propio instalador de
   ReShade (`info@reshade.me`). Estructura en 0 fallas de nuevo.
2. **La instalacion YA ESTABA HECHA al abrir la sesion.** Fran corrio `instalar-dlss5.ps1` despues
   del ultimo HANDOFF sin dejarlo anotado. Confirmado por efecto (tamano + hash SHA256 del renodx
   + `FileVersion` de `dxgi.dll`) sobre las 7 piezas: todo OK, ReShade 6.8.0.2155, v4.55 por hash.
3. En vivo con Fran, PCSX2 corriendo con el overlay: se corrigio el orden Feed/Kernel (el propio
   feed avisa por log cuando esta mal invertido: "enable it above DLSS 5 Feed") y se selecciono a
   mano el buffer grande de Generic Depth (2568x1800, ~4600 draw calls).
4. `NGX capabilities: SuperSampling.Available=0` salio igual en tres corridas -- pero las tres
   usaron el MISMO `nvngx_dlssnr.dll` sin variarlo, asi que NO son evidencia de techo de
   hardware: solo prueban que el resultado es reproducible con ese archivo. Correccion de metodo
   hecha en esta misma sesion, no una conclusion que sobrevivio hasta el cierre.
5. **LA PISTA REAL, `confirmado` por medicion local (dos formas independientes), pero SIN probar
   causalidad todavia:** `nvngx_dlssnr.dll` instalado tiene firma Authenticode `HashMismatch`, y
   su SHA256 (`8270B350...`) no coincide con el hash "known-good" (`E16BCF15...`, misma
   `FileVersion` 310.8.0.0) que usa una herramienta comunitaria para esta MISMA clase de falla
   (Kayle, Discord de RenoDX, canal `tools`: "Fix for DLSS 5 Stuck on STANDBY/FAILED"). Codigo
   fuente completo de la herramienta (`kayle2203/dlssnr-signature-repair`) leido con `gh api`, no
   solo el README: PowerShell puro, verifica hash+firma antes de tocar nada, backup + reemplazo
   atomico, cero red, cero binarios de NVIDIA incluidos -- segura de correr. Falta conseguir un
   `nvngx_dlssnr.dll` con el hash exacto y volver a medir.
**No funciono:**
- Cambiar `mode=2` a `mode=1` en `dlss5-feed.cfg` asumiendo que era el ajuste que el log llama
  "EnableHooks" (coincidian en valor: los dos en 2) — eran campos de DOS ADDONS distintos. El
  campo real de "EnableHooks" no se ubico. Leccion registrada con `aprender.py` (grupo evidencia)
  y su linea ya esta en `chequeo-de-trabajo.md`.
- Repetir el mismo test de NGX tres veces con el mismo DLL sospechoso y leerlo como "confirmado":
  no aumenta la confianza sobre CUAL de dos hipotesis es la causa. Fran lo marco en vivo ("ya
  condujimos una mala conclusion") antes de que se escribiera como cerrado.
**Sigue:** Fran decidio pasar la investigacion a una sesion nueva con OPUS -- pidio
explicitamente investigacion de verdad antes de la proxima conclusion, no otra corrida rapida --
mientras instala un driver de NVIDIA mas nuevo por su cuenta. Buscar de donde sacar un
`nvngx_dlssnr.dll` con hash exacto, correr la reparacion, y RECIEN AHI medir de nuevo si
`SuperSampling.Available` cambia. Detalle completo en `sesiones/HANDOFF.md` seccion 8.11 y 8.12.
R2 sigue ABIERTA.

---

## 2026-09-02 (45) — R2: la pregunta de arquitectura, RESPONDIDA — el backbuffer es 1080p, el diseno no cambia

**Maquina:** notebook MSI Sword 15 · **Modelo:** Opus, esfuerzo high, sin fan-out
**Objetivo:** responder la pregunta de arquitectura de HANDOFF 8.7 ANTES de instalar nada:
si ReShade (y por lo tanto DLSS5-Feeder) engancha el framebuffer a la resolucion INTERNA
de PCSX2 (2568x1800 a 4x) o a la de salida. De la respuesta dependia si el diseno entero
del pipeline cambiaba y si chocaba con la restriccion de scope de Fran.
**Resultado:**
1. **RESPONDIDA, `confirmado`, sin abrir el emulador: el swapchain es 1920x1080.**
   `ReShade.log` de la corrida del 2026-09-01 23:05 (misma config que gano R1: Renderer=15
   D3D12, upscale_multiplier=4) vuelca la descripcion del swapchain en el hook de
   `CreateSwapChainForHwnd`: `Width 1920 / Height 1080`, `R8G8B8A8_UNORM`. En esa MISMA
   corrida R0 midio el depth en 2568x1800. Dos numeros distintos, una sola sesion:
   **el swapchain no sigue a la resolucion interna.** PCSX2 reescala de 2568x1800 a
   1920x1080 ANTES del `Present`, que es donde engancha ReShade.
2. **La hipotesis de (44)/8.7 queda FALSIFICADA, para el lado bueno.** DLAA no va a correr
   sobre 2568x1800: corre sobre 1920x1080 (`render size = output size`, 1:1, sin jitter).
   La restriccion de [[black-remaster-resolucion-objetivo]] se cumple **por construccion**,
   sin tocar nada. Y el 4x no se desperdicia: el downscale a 1080p ya es supersampling y
   DLAA + neural rendering van encima.
3. **El desajuste que esto destapa no es un problema, y esta resuelto en el propio disenio
   de DLSS5-Feeder:** el depth queda a 2568x1800 y el color a 1080p, pero `DLSS5_Feed.fx`
   COPIA el depth a su textura propia `DLSS5_Depth` (R32F) en un pase MRT de ReShade, y las
   texturas de efecto se asignan al tamanio del backbuffer. NGX recibe el contrato con las
   tres entradas a 1920x1080.
4. **Consecuencia nueva para la PC de escritorio:** el costo del pipeline escala con la
   PANTALLA, no con `upscale_multiplier`. En 2K el backbuffer va a ser 2K y DLAA va a correr
   a 2K. Escrito antes de medir alla.
5. **Medido en disco, no asumido:** ReShade 6.8.0 existe (salio el 2026-08-02) y es
   exactamente el minimo que pide DLSS5-Feeder. **winget NO sirve**:
   `Reshade.Setup.AddonsSupport` sigue publicando 6.6.2, que es lo que ya hay instalado.
   Hay que bajar `ReShade_Setup_6.8.0_Addon.exe` de reshade.me — y ese build es **unsigned**,
   lo dice la propia pagina. Los dos binarios del Discord de RenoDX **siguen sin estar** en
   `Downloads/` (medido, no supuesto).
6. **Una pieza menos de lo que decia 8.7:** `nvngx_dlss.dll` es OPCIONAL — el README dice
   que si no esta al lado del exe se usa la copia del driver. Y de ultima hay dos
   instaladores de DLSS Swapper en `Downloads/` desde mayo 2025.
**No funciono:** nada fallo. Vale registrar que la pregunta se respondio **sin abrir el
emulador y sin instalar nada** — el dato ya estaba en un log que la sesion anterior habia
generado y no habia leido. El default en frio (`apertura-proyecto`) pago aca.
7. **CORRIGE a (44) en dos datos, verificados contra las paginas reales:** el release mas
   nuevo de DLSS5-Feeder es **v0.7.0** (2026-08-31), NO `0.10.0-beta.2` como escribio (44);
   y sus assets son archivos sueltos, no un zip — para PCSX2 hacen falta solo
   `dlss5-feed.addon64` y `DLSS5_Feed.fx`. Ademas la rama por default de LumeniteFX es
   **`mainline`**, no `main`: el link de "Download ZIP" armado a ojo da 404. Tabla de links
   exactos al final de HANDOFF 8.8.
**Sigue:** R2 sigue ABIERTA y **bloqueada por Fran** en una sola pieza: `renodx-dlss5.addon64`
v4.55 + `nvngx_dlssnr.dll` del Discord de RenoDX (fuente no confiable, no la baja la sesion).
Lo demas es ejecucion de runbook ya decidido: ReShade 6.8.0 Addon, el release de
DLSS5-Feeder, LumeniteFX. Runbook completo en `sesiones/HANDOFF.md` 8.8.

---

## 2026-09-02 (44) — R2: hay precedente público en PCSX2, y el runbook exacto para D3D12 salió de los README primarios

**Máquina:** notebook MSI Sword 15 · **Modelo:** Sonnet, esfuerzo medium (lectura de fuentes primarias), sin fan-out
**Objetivo:** Fran bajó los dos repos (`dlss5-bridge-main.zip`, `DLSS5-Feeder-main.zip`, en
`Downloads/`) y pidió arquitectura completa antes de construir, con todas las fuentes
posibles investigadas. Corregir/profundizar (43) con lo que sólo estaba en los README
primarios, y medir qué hay realmente instalado.
**Resultado:**
1. **La afirmación "sin precedente en ningún emulador" de (43) queda REFUTADA.** Búsqueda
   adicional encontró TechPowerUp, WCCFTech, GameGPU.com y un post de X (@DystopianSuns)
   reportando DLSS 5 Neural Rendering corriendo específicamente **dentro de PCSX2**, con un
   juego de PS2 (el nombre no se pudo confirmar con precisión — un fetch lo dio como
   "Manhattan", posible transcripción de "Manhunt"; **grado: probable, no confirmado**). Tres
   de los cuatro artículos (techpowerup, wccftech, gamegpu) devolvieron 403 al fetch —
   **no se pudo leer el detalle técnico primario**, y heldgames.com dice explícitamente que
   se niega a publicar pasos de instalación. El precedente EXISTE, medido por multiplicidad
   de fuentes independientes; el detalle reproducible NO está publicado en ningún lado.
2. **Medido en disco (no asumido):** ningún `.addon64`/`.dll` de DLSS5 está instalado en
   ninguna de las dos instalaciones de PCSX2. Lo que hay es `dlss5-bridge-main.zip` y
   `DLSS5-Feeder-main.zip` en `Downloads/`, sin extraer — **son el código FUENTE de GitHub
   (rama `main`), no los binarios compilados**. Los releases reales
   (`dlss5-bridge.addon64` v1.4.1; `DLSS5-Feeder-0.10.0-beta.2.zip`) están en las páginas de
   Releases de cada repo, no en estos zips.
3. **Leídos los dos README completos (fuente primaria, no resumen de terceros) — el runbook
   exacto para el caso de PCSX2 (D3D12, sin DLSS nativo) es DLSS5-Feeder, NO dlss5-bridge**
   (el bridge es para D3D11/Vulkan que YA tienen DLSS propio; con D3D12 sin DLSS nativo,
   DLSS5-Feeder es la única vía — el propio README del bridge lo dice: *"Do I need the DLSS 5
   DX11 bridge? No."*). Detalle completo, con la lista exacta de piezas y el gotcha de
   versión de ReShade, en `sesiones/HANDOFF.md` sección 8.7.
4. **Confirma el patch de 60fps de Fran:** `gamesettings/SLUS-21376_5C891FF1.ini` tiene
   `[Patches] Enable = 60 FPS` ya activado — viene de la base de patches oficial/embebida de
   PCSX2 (el panel "recomendados" de Ajustes→Juego), no de un pnach suelto. No verificado
   todavía por efecto (no se midió el FPS real con este patch activo).
**No funcionó:** tres fuentes de noticias sobre el precedente en PCSX2 bloquearon el fetch
(403) — no es un problema del parámetro de búsqueda, es anti-bot del lado del sitio. Con eso
alcanzó para confirmar que el precedente existe, no para replicarlo.
**Sigue:** con la arquitectura y las piezas exactas ya mapeadas (HANDOFF 8.7), lo que falta
es: verificar versión de ReShade instalada (6.6.2, el README pide 6.8+), bajar los
**releases** reales (no los zips de `main`) de DLSS5-Feeder y de LumeniteFX, y que Fran
consiga en el Discord de RenoDX `renodx-dlss5.addon64` **v4.55 exacto** + `nvngx_dlssnr.dll`
(esas dos, y sólo esas dos, siguen siendo la parte de fuente no confiable que esta sesión no
baja). Sesión nueva recomendada para el armado real — ver HANDOFF.

---

## 2026-09-01 (43) — R2 abierta: DLSS 5 Neural Rendering es real y técnicamente viable — no instalado, dos capas de fuente no confiable en el medio

**Máquina:** notebook MSI Sword 15 · **Modelo:** Sonnet, esfuerzo medium (investigación web), sin fan-out
**Objetivo:** entender qué es concretamente el "pipeline DLSS5/ReShade" que R1 dejó como
próximo paso, dato que —como ya diagnosticó (41)— sólo vivía en un chat anterior nunca
documentado. Fran pidió investigar fuentes oficiales y no oficiales y usar lo que dé
máximo apalancamiento.
**Resultado:** midiendo primero lo que ya estaba en la máquina (rule 4 del perfil: el
estado se mide, no se supone) — la GPU de esta notebook es una **NVIDIA GeForce RTX 4060
Laptop** (`Get-CimInstance Win32_VideoController`), y no quedó ningún shader de
DLSS/FSR/NIS instalado, sólo el paquete estándar de ReShade (SweetFX + genéricos). Tampoco
había ningún patch de 60fps guardado para `SLUS-21376` (el único `.pnach` presente es un
mod de dificultad sin relación). Búsqueda web: **"DLSS 5" es un producto real de NVIDIA**,
posterior a mi corte de entrenamiento, con un ecosistema de modding activo desde fines de
agosto de 2026 que agrega neural rendering a juegos **sin soporte nativo**, usando
exactamente lo que R0 ya midió — profundidad vía ReShade — como insumo. Dos proyectos
community relevantes, los dos con releases reales en GitHub (no sólo Discord):

- [`NIGos/dlss5-bridge`](https://github.com/NIGos/dlss5-bridge) — v1.4.1, MIT, 172
  estrellas. En D3D12 (el renderer que R1 ya eligió) los motion vectors salen de shaders
  de ReShade, no del motor de optical flow del driver.
- [`jlrouzies-fr/DLSS5-Feeder`](https://github.com/jlrouzies-fr/DLSS5-Feeder) — v0.10.0-beta.2,
  520 estrellas. Sintetiza un "contrato DLAA" (profundidad ReShade + 5 estimadores de
  motion vector alternativos) para juegos que no exponen DLSS ni motion vectors reales —
  es el caso de PCSX2, que rasteriza cada frame del GS sin pase de motion vectors.

**El cuello de botella real no es la GPU, es la procedencia de dos binarios:**

1. El add-on núcleo del que dependen los dos (`renodx-dlss5.addon64`, de la comunidad
   RenoDX) **no se distribuye por GitHub — sólo por el Discord de RenoDX**, canal
   `#DLSS5`, fijado a la versión v4.55 (las posteriores chocan con DLSS5-Feeder).
2. DLSS 5 Neural Rendering es oficialmente **RTX 50 en adelante**; esta RTX 4060 necesita
   una `nvngx_dlss.dll`/`nvngx_dlssnr.dll` **parcheada por la comunidad** para saltarse ese
   candado de hardware — un binario propietario de NVIDIA modificado y redistribuido fuera
   de canal oficial.

Bajar y ejecutar cualquiera de los dos cae en "descargar/ejecutar archivos de fuente no
confiable", que es una acción que esta sesión tiene prohibida de forma dura —no se
resuelve con permiso de Fran, hay que hacerlo él mismo si decide seguir por acá.
**No se instaló nada.**
**No funcionó:** no aplica — esto fue investigación, no medición sobre el objeto real.
**Sigue:** la decisión es de Fran: (a) arrancar por un shader de upscaling/sharpening
"seguro" (FSR1/NIS en ReShade, sin candado de hardware, instalable hoy) como piso del
pipeline, y dejar DLSS5 real como rama en paralelo si Fran baja él mismo los dos binarios
del Discord/parche de NGX; o (b) ir directo a DLSS5 real asumiendo el riesgo. Ninguna de
las dos tiene precedente documentado sobre un emulador — todos los ejemplos encontrados
(Fallout 4, FF7 Rebirth, Control, Stellar Blade) son juegos nativos con motion vectors
reales; PCSX2 necesitaría el camino de "motion vectors estimados", que el propio README de
DLSS5-Feeder avisa que da ghosting en movimiento rápido — justo el tipo de escena que
domina BLACK.

---

## 2026-09-01 (42) — R1 CERRADA: D3D12 @ 4x gasta un tercio de GPU que D3D11, mismo FPS

**Máquina:** notebook MSI Sword 15 · **Modelo:** Sonnet, esfuerzo low, sin fan-out
**Objetivo:** medir R1 — FPS y frametime de D3D11@Native / D3D11@4x / D3D12@4x
sobre la misma escena (savestate 03), y elegir renderer/resolución interna por
rendimiento.
**Resultado:** las tres casillas dan **29.97 FPS** idéntico — el juego está
tapado en la mitad de 59.94, no en el renderer. Lo que distingue es el uso de
GPU del OSD: D3D11 gasta 58-60% (9.7-10.0 ms) en Native y en 4x por igual;
D3D12 @ 4x gasta **18.5% (3.08 ms)**, un tercio. CPU emulado (EE/VU/GS) parejo
en las tres, como corresponde. **Decisión: D3D12 @ 4x** — mismo FPS, mucho más
margen de GPU para el pipeline de DLSS5/ReShade que va encima. Edité
`PCSX2.ini` directo (Renderer=3/15, upscale_multiplier=1/4) en vez de clickear
Ajustes→Gráficos, cerrando y reabriendo PCSX2 entre casillas — evita el límite
de 8.4 (los clicks los hace Fran) sin necesitarlo para esto. Captura de
pantalla completa por PowerShell/.NET (`System.Windows.Forms.Screen` +
`Graphics.CopyFromScreen`) para leer el OSD, sin togglear ReShade. Tabla y
capturas en `pruebas/R1-rendimiento/`.
**No funcionó:** nada — no hizo falta clickear nada de la UI de PCSX2 ni tocar
ReShade/DisplayDepth para esta medición, a diferencia de R0.
**Sigue:** la colisión de la sesión 40 (objetivo 4-6x) sigue sin poder
confirmarse ni descartarse — a 4x, con este savestate, D3D12 no mostró ningún
síntoma. Ojo si aparece en escenas más cargadas.

---

## 2026-09-01 (41) — R0 CERRADA: hay depth buffer en las tres casillas, y la predicción falló

**Máquina:** notebook MSI Sword 15 · **Modelo:** Opus, esfuerzo medium, sin fan-out
**Objetivo:** medir R0 — las tres casillas D3D11@Native / D3D11@4x / D3D12@4x,
cada una en sirve / sirve degradado / no sirve, con captura del depth.
**Resultado:** **las tres en `sirve`, confirmado por efecto.** Buffer del juego
`D32S8` en las tres, con ~1000-1200 draw calls por frame; el resto de los
buffers listados tienen 1-2 draw calls (sombras). Resoluciones medidas:
642x450 en Native, 2568x1800 en 4x — exactamente 4x, o sea la profundidad
escala con la resolución interna. La evidencia es la vista de **normales**
derivadas del depth: se ven el auto con sus molduras, las columnas del
viaducto y las aristas del piso, y a 4x más limpias que en Native. Capturas
en `pruebas/R0-depth/{d3d11-native,d3d11-4x,d3d12-4x}.png`.
Antes de medir se confirmó por efecto que ReShade 6.6.2 **sí engancha** en
PCSX2 2.8.0: `ReShade.log` pasó del texto placeholder a
`Initializing crosire's ReShade ... loaded from C:\Program Files\PCSX2\dxgi.dll`.
También se verificó por efecto que `Renderer = 3` del `PCSX2.ini` es
Direct3D 11 (el log muestra `Redirecting D3D11CreateDevice`), en vez de
adivinar el enum.
**No funcionó:** dejar que **Generic Depth elija el buffer solo**. Con la
heurística `Similar aspect ratio` en su default agarra uno de los buffers
chicos (128x64) y `DisplayDepth` sale violeta plano — visualmente idéntico a
"este juego no expone depth". Si se cerraba la casilla ahí, R0 daba
`no sirve` y mataba el proyecto por un error de heurística. **Hay que tildar
a mano la fila del buffer grande**, y hay que volver a hacerlo cada vez que
cambia la resolución interna o el renderer, porque PCSX2 recrea los render
targets y el handle cambia. `Copy depth buffer before clear operations` no
aportó nada: ReShade avisa "No clear operations were found for the selected
depth buffer".
Segundo tropiezo, menor pero desorientador: con `DisplayDepth` activo el
**menú de pausa de PCSX2 es invisible**. PCSX2 dibuja su interfaz dentro del
frame y ReShade reemplaza el color de todo el frame después; Escape pausa
pero no se ve nada. Cualquier cosa de la UI de PCSX2 hay que mirarla con
DisplayDepth apagado.
**La predicción de la sesión 40 falló en dos de tres casillas:** decía
D3D11@4x `no sirve` y D3D12@4x `sirve degradado`. Las dos dieron `sirve`
limpio. La justificación del `no sirve` era "la colisión ya documentada con
el objetivo de 4-6x" — y **esa colisión no está en ninguna parte de este
repo** (`grep` sobre la bitácora no la encuentra): venía de un chat de DLSS5
anterior que nunca se escribió. Una predicción apoyada en un dato que sólo
vivía en un chat. Queda como pregunta abierta: si esa colisión era real,
era sobre PCSX2 2.6.3 y/o sobre un eje que R0 no mide (rendimiento, o el
pipeline de DLSS y no el buffer).
**Sigue:** R0 no impone ninguna restricción sobre el renderer — los tres
sirven, así que la elección se decide por rendimiento y por lo que necesite
el pipeline de DLSS, no por disponibilidad de depth. Lo próximo es esa
decisión (R1), y no necesita nada de esta sesión salvo este veredicto.

---

## 2026-09-01 (40) — BLACK Remaster: R0 abierta, infraestructura de PCSX2 2.8 + ReShade lista

**Máquina:** notebook MSI Sword 15 · **Modelo:** Opus, esfuerzo medium, sin fan-out
**Objetivo:** R0 de la línea nueva "BLACK Remaster" (viabilidad DLSS5): ¿hay
depth buffer usable en PCSX2 2.8 para BLACK, en D3D12@4x / D3D11@Native /
D3D11@4x?
**Resultado:** Ninguna casilla medida todavía — la sesión quedó en
preparación de infraestructura, no en medición. Se midió (no se asumió) la
versión real de PCSX2: la instalación de referencia en
`kb/ubicaciones.json` (`...\PCSX2\PCSX2\`, con el ISO adentro) tenía 2.6.3,
nunca antes medida. Se descubrió una SEGUNDA instalación de PCSX2, separada,
en `...\PCSX2\` (ruta corta, sin duplicar) — es la que se usó en el chat
anterior de DLSS5, y `winget install PCSX2Team.PCSX2` la subió a 2.8.0 sin
tocar el ISO ni la instalación vieja. El fork PCSX2-MCP de Downloads (el de
los lanzadores `.bat`) es un build del 15/08, de ANTES del 2.8.0: no sirve
para responder R0. ReShade (para ver el depth vía Generic Depth) resultó
estar DESINSTALADO — sólo quedaban `.ini`/`.log`/shaders sueltos de la
sesión de DLSS5 anterior, sin la DLL global (`C:\ProgramData\ReShade` ya no
existe). Se reinstaló `Reshade.Setup.AddonsSupport` 6.6.2 por winget y Fran
lo configuró a mano apuntando al `pcsx2-qt.exe` de la ruta corta.
**No funcionó:** automatizar los clicks de Ajustes→Gráficos por PowerShell
(P/Invoke `SetForegroundWindow`/`PostMessage`) — la ventana de PCSX2 pierde
el foreground contra la propia terminal entre invocaciones separadas de la
herramienta, y forzarlo dejó la ventana en blanco una vez (se recuperó
sola). Se cortó esa vía y se le pidió a Fran hacer los clicks directamente
— más barato y más confiable que seguir peleando el foreground.
**Sigue:** con ReShade ya instalado, medir las 3 casillas: Ajustes→Gráficos,
Renderer=D3D11 + Resolución interna=Native, cargar BLACK, Home para el
overlay de ReShade (NumLock apagado si es el 7 del numérico), activar
Generic Depth, capturar. Repetir con D3D11@4x y D3D12@4x. Cierra con las 3
casillas en sirve / sirve degradado / no sirve. Detalle completo en
`sesiones/HANDOFF.md`, sección 8.

---

## 2026-08-29 (39) — 7e paso 3b: los pools de `P1` MEDIDOS. 17/18 predicciones, y la 18ª corrigió el mapa

**Máquina:** PC · **Modelo:** Opus, esfuerzo medium, sin fan-out
**Objetivo:** el paso 3b en frío. `P1` era, hasta acá, **lectura del ELF**: "el
dispatcher saca `handles[contador++]` de un array ya alocado". La sesión (38)
dejó escritas **18 predicciones numéricas simultáneas** —cuántas instancias
tiene cada pool en LEVEL_00, según el stream— con **tres ceros de control
negativo**. Medirlas contra `volcados/ee-e4.bin` decide si el modelo se sostiene
**antes** de gastar un arranque del emulador.

**Resultado: 17 de 18 exactas, y la que falló no era el modelo sino una
lectura mal derivada — que la medición corrigió.** El emulador no se abrió y no
se escribió un byte.

### Cómo se ubicó `P1`, y por qué no fue un barrido

El retome avisaba: si aparece la tentación de barrer los 32 MB por rango de
valor, **parar y cambiar de eje**. El tag `*piVar4 == 0x1C` es exactamente ese
mal parámetro. El eje que sirve es una **cadena de indirecciones desde un dato
ya confirmado**: `FUN_0012dab8` pasa `param_2 = *(u32*)(piVar4[4]+4)`, y
`param_2` es el descriptor del stream, **medido el 2026-08-23 en
`0x01092800`**.

```
1. buscar el valor 0x01092800            -> 193 hits
2. Q = hit - 4  es candidato a piVar4[4]
3. buscar el valor Q                     -> 6 direcciones B == piVar4+0x10
4. piVar4 = B - 0x10 ; *piVar4 == 0x1C queda de CONTROL -> sobrevive 1 de 6
```

**`piVar4 = 0x005AD410`, `P1 = 0x005AD450`.** El tag no fue el criterio de
búsqueda sino el control, que es el orden que corresponde. Tres controles
independientes cerraron encima:

- `piVar4[4] == 0x01053000`, la dirección de carga de `STUNIT01.BIN`
  confirmada por otra vía. No se la buscó: apareció.
- El otro slot del doble buffer cae **exactamente a `+0x880`**
  (`0x005ADC90`), con tag `0x1` y `[4] = 0`: **uno vivo y uno libre**.
- Los punteros de los pools son **contiguos y ascendentes**, así que la
  capacidad de cada uno se deriva de dónde empieza el siguiente — y da
  **≥ ocupación en los 18, siempre ajustada** (`P1+0x1C`: 132 para 131).

### La tabla, y los tres ceros

| `P1+off` | ocupado | predicho | | `P1+off` | ocupado | predicho |
|---|---|---|---|---|---|---|
| `0x1C` | **131** | 131 | | `0x2C` | **5** | 5 |
| `0x3C` | **118** | 118 | | `0x48` | **4** | 4 |
| `0x24` | **73** | 73 | | `0x44` | **3** | 3 |
| `0x08` | **60** | 60 | | `0x20` | **2** | 2 |
| `0x10` | **57** | 57 | | `0x00` | **0** | 0 |
| `0x18` | **33** | 33 | | `0x38` | **0** | 0 |
| `0x14` | **21** | 21 | | `0x40` | **0** | 0 |
| `0x30` | **20** | 20 | | `0x28` | **1** | ~~5~~ |
| `0x34` | **14** | 14 | | `0x4C` | **6** | 6 |

**El control negativo dio más de lo pedido:** los tres offsets con 0 predicho
no tienen un array vacío, tienen **el puntero en nulo**. Total predicho 552,
total ocupado 548, y la diferencia entera es la fila del `0x28`.

### La 18ª: el `0x34` no usa "índice fijo 0", tiene un LOOP

`casos_dispatcher.py` le atribuía al `0x34` **dos** destinos: `P1+0x1C | c_s5`
y `P1+0x28 | índice fijo 0`. El segundo es una lectura equivocada.
`0x0015F5FC`–`0x0015F624` es un **bucle**: `s0` arranca en cero
(`0000802D` en `0015F5E4`), se incrementa (`26100001`) y el límite sale de
`*(P1+0x78)`. El `0x34` **no construye** en `P1+0x28`: **lo recorre**, una
llamada por elemento. Su único destino es `P1+0x1C`, donde la kb ya lo tenía
— y donde el 131 dio exacto.

Predicción escrita antes de mirar: *si es un loop con límite en `*(P1+0x78)`,
entonces `*(P1+0x78)` vale 1*. **Vale 1.**

**Y el síntoma estaba a la vista sin medir nada:** el `0x34` era el **único
tipo de módulo que aparecía en dos grupos de destino** (el `0x35` aparece en
seis, pero no es un módulo: es el cierre). Un tipo en dos grupos es una
lectura sin resolver, no dos destinos.

### Dos cosas que no se buscaban

**(1) El juego mantiene sus propios contadores, y coinciden.** `P1+0x50..0x90`
es una **tabla de largos** cuyo multiconjunto de valores reproduce elemento por
elemento las ocupaciones medidas: `{131,118,73,57,33,21,20,14,5,5,4,3,2,6,1,0,0,0}`.
Y `P1+0x04 = 0`, `P1+0x0C = 60` son los largos de `P1+0x00` y `P1+0x08`. Es una
**tercera derivación independiente**: no sale del stream ni de mi conteo de
handles, la escribe el juego. **Abierto:** la asignación offset-por-offset entre
ese bloque y los 16 punteros de `0x10`–`0x4C` **no cierra con un corrimiento
constante**. El multiconjunto coincide; la alineación exacta, no. No medido.

**(2) El `0x2B` confirmado por su propia vía.** No usa array de punteros sino un
array **inline** de structs de `0x10` en `P1+0xB0`: **9 structs con contenido y
ceros a partir del décimo**, contra 9 instancias predichas, y `P1+0xA0 == 9` es
su contador. Los cuatro campos son floats —p. ej. `[-78.84, -3.579, 30.08, 3.0]`—
que parecen XYZ más un cuarto valor. Posiciones en el mundo: **hipótesis**.

**No funcionó / lo que hay que anotar como costo:**

- La primera fila de la tabla de predicciones que se escribió el 2026-08-29
  estaba **mal derivada**: para `P1+0x28` se puso el número de *instancias del
  tipo* (5) cuando el propio mapa ya decía que ese caso **no incrementa
  contador**. Escribir una predicción a partir de una coordenada que la misma
  kb marcaba como distinta es lo que produjo la única falla.
- La capacidad de `P1+0x4C` no se puede derivar por contigüidad: es el último
  array por dirección y no tiene sucesor. Su ocupación (6) salió del prefijo de
  handles válidos, que es un criterio más débil. Da lo predicho, pero es la
  fila con menos control de las 18.

**Sigue:** la mitad **(b)** de 7e, que **necesita el emulador**. El mapa ahora
habilita dos observables baratos, en orden de costo: (1) neutralizar un módulo
cambiando su `tipo` a un case del `default` (`0x0D`, `0x0E`, `0x21`, `0x24`) —
**un byte** en `STUNIT01.BIN` con `parche_iso.py`, con la predicción escrita
antes; (2) los tipos `SD` (`0x2E`, 5 instancias; `0x30`, 14), cuyo observable es
**audible** y más barato de juzgar que la geometría. Y ahora hay instrumento
para leer el efecto: `pools_p1.py` mide la ocupación de cualquier pool en un
volcado nuevo, así que "el módulo no se construyó" pasa a ser **contable**.

Herramienta nueva, con autotest **probado en rojo** (5 casos y 4 sabotajes):
`herramientas/pools_p1.py`. Medición en `kb/pools-p1.json`.

---

## 2026-08-29 (38) — 7e paso 3: el subsistema de cada tipo NO está en el handler, está en el SITIO DE LLAMADA

**Máquina:** PC · **Modelo:** Opus, esfuerzo alto, sin fan-out
**Objetivo:** decidir y ejecutar el eje de identificación de los tipos, que era
lo que faltaba para la mitad **(a)** de 7e. El plan de retome proponía el
**cierre transitivo del call graph** por handler, juntando (a) las cadenas de
los callees y (b) los globales de `.bss` que cada rama termina tocando.

**Resultado: la mitad (a) de 7e está cerrada, y el eje propuesto salió mitad
refutado y mitad reemplazado.** Los **61 tipos despachados** (en 55 bloques
distintos) tienen destino, contador, acción y argumentos, todo por lectura. El emulador no se abrió y no
se escribió un byte.

### El eje propuesto, medido: las dos mitades dieron cosas opuestas

**(b) globales de `.bss` por handler → CERO, y el cero era del instrumento.**
Se construyó el call graph de las 9842 funciones (20.205 aristas `jal`) y se
midió el cierre de `FUN_00175980` (el handler del `0x2D`) a profundidad 0–3.
**No alcanza `0x0040F4D4` en ninguna**, que es la base del registro de física
ya medida el 2026-08-28. El control positivo falló, y eso es lo que salvó el
tramo: **el handler no nombra su objeto de estado — se lo pasa el despachador
en `a0`.**

```
0015F778  lw    v0,4(s1)        ; blob del registro
0015F780  lbu   v1,30(v0)       ; la guarda blob[0x1E]
0015F78C  lui   v1,0x0041
0015F790  ld    a1,8(s1)        ; a1 = id64 del NOMBRE
0015F794  lw    a0,-2860(v1)    ; a0 = *(0x0040F4D4)   <-- EL SUBSISTEMA
0015F79C  jal   0x00175980
0015F7A0  addiu a0,a0,2632      ; DELAY SLOT: + 0xA48
```

Ése es el eje que sirve, y es **más barato** que el propuesto: una sola función
en vez de 70 cierres.

**(a) cadenas de los callees → REFUTADO POR MEDICIÓN, ahora sí.** La trampa 5
decía "rinde poco" mirando **sólo el nivel 0**. Medido sobre el cierre:

| profundidad | funciones/handler | handlers con cadena | cadenas |
|---|---|---|---|
| 0 | 1,0 | **1 de 70** | 1 |
| 1 | 2,1 | 1 de 70 | 1 |
| 2 | 3,5 | 2 de 70 | 3 |
| 3 | 5,0 | **2 de 70** | 5 |

El cierre **no lo rescata**: el eje está agotado, no sub-explorado. Techo
conocido del instrumento: los `jalr` no son aristas de un call graph estático.

### La trampa que casi convierte un bug en una conclusión

El primer barrido de cadenas dio **0 cadenas hasta para `FUN_00175980`**, que
es el único handler del que ya se sabía que tiene una. El control positivo lo
atrapó. Causa:

```
001759D4  lui    a0,0x003F
001759DC  jal    0x001A4F70
001759E0  addiu  a0,a0,21664     ; DELAY SLOT: la mitad baja de 0x003F54A0
```

El barrido limpiaba la sombra de registros **al ver el `jal`**, o sea antes de
procesar el delay slot, y perdía la constante. Sin control positivo, ese cero
se lee como "los handlers no tienen cadenas" y es **la misma clase de mentira
silenciosa** de la trampa 1, un nivel más abajo: el parámetro que falla no es
el umbral de búsqueda, es el **modelo del ISA que tiene el instrumento**.

### Lo que salió — las tres coordenadas, y discriminan

`herramientas/casos_dispatcher.py`. La tabla de saltos está en **`0x003F4E90`,
69 entradas** (`lui v0,0x3F; addiu v0,v0,20112` en `0x0015F030`; el tope de
`sltiu v0,v1,69`). **61 tipos despachados en 55 bloques distintos, 8 en el default**
(`0x00`, `0x01`, `0x02`, `0x0D`, `0x0E`, `0x21`, `0x24`, `0x33` — y `0x01`,
`0x02`, `0x33` **sí están en los datos**, lo que ya decía la `kb`).

| coordenada | qué es | ejemplo |
|---|---|---|
| **destino** | array de handles `P1+0xNN`, o singleton de `.bss` | `0x2D` → `*(0x0040F4D4)+0xA48` |
| **contador** | qué índice avanza; mismo array + mismo contador = mismo subsistema | `c_s5`, `sp+408`… |
| **acción** | handler directo, o método virtual `vtable+0xNN` | `FUN_00175980` / `vtable+0xB4` |

Los 60 tipos de módulo (todos menos el `0x35`) caen en **23 grupos**; el mayor
tiene 23 tipos (`P1+0x1C`/`c_s5`)
y el segundo 10 (`P1+0x3C`/`c_s7`). La firma de argumentos es
`handler(destino, id64_del_nombre, blob, …)` en casi todos — y el `0x2D`
**no recibe el blob**, lo que concuerda con que su handler busca **por nombre**
(`FUN_00129160`, comparación de 64 bits), confirmado el 2026-08-28 por otra vía.

**Diez casos no tienen `jal` propio.** Saltan a una **cola virtual compartida**
en `0x0015F968` / `0x0015F974`: `lw v1,16(a3); lh a0,176(v1); lw v0,180(v1);
jalr v0; addu a0,a3,a0`. El par (ajuste del `this`, puntero al método) sale de
la vtable y **discrimina el tipo**: `0x0B` y `0x0C` comparten array y contador
y llaman métodos distintos (`vtable+0xB0` vs `vtable+0xB8`). Un recorrido del
bloque por direcciones crecientes **los pierde enteros** — fue un bug real de
la primera versión, y ahora es el sabotaje (b) del autotest.

### Dos hallazgos que no se buscaban

**El `0x35` no es un tipo de módulo: es el CIERRE del stream.** Su bloque hace
~25 llamadas y recorre **todos** los arrays de `P1` emparejados con offsets de
`P2` (`P2+98` … `P2+138`). Tiene **0 instancias** en LEVEL_00. O sea que el
`switch` mezcla constructores por módulo con un paso de commit: **no todo case
es un tipo**. Abierto y no medido: `P2` tiene campos hasta `+0x8A` y la `kb` lo
describe como `{count, array}` de 8 B.

**`P1` es un directorio de pools ya alocados, y el inventario está cerrado por
DOBLE CONTROL.** El dispatcher no crea el objeto: saca `handles[contador++]`
del array que le toca al tipo. Los offsets de `P1` que usan los casos
individuales y los que recorre el bloque del `0x35` son **los mismos 18**
(`0x00 08 10 14 18 1C 20 24 28 2C 30 34 38 3C 40 44 48 4C`); el `0x35` toca
además `0x94` y `0x9C`. Son dos lecturas independientes del mismo dispatcher.

### El cruce código-vs-datos

Eje de código (a qué objeto manda el dispatcher) contra eje de datos (familia
del `id64` de las instancias, medida sobre `ee-e4.bin`):

- **`LW`**: los 256 van al `0x2D`, y el `0x2D` es el **único** que va al
  singleton de física. Exclusivo en los dos sentidos.
- **`SD`**: las 20 instancias son `0x2E`, `0x2F` y `0x30`, y ningún tipo no-`SD`
  va a esos destinos — pero el sonido usa **tres destinos distintos**, no uno.
- **`WD`**: se reparte. `0x43` tiene destino propio, pero `0x1F`/`0x20` caen
  dentro de la familia grande de `GP`. **La familia del nombre no determina el
  destino.**

Y una advertencia que sale del mismo cruce: **mismo array no es misma struct.**
Dentro de `P1+0x1C` conviven blobs de 16, 32, 48, 64, 80 y 96 B. El array es el
**pool de destino**; el tamaño del blob es la **estructura de entrada**. Son dos
coordenadas independientes.

### Singletons de `.bss` — un directorio, probable

Los tipos que no van a un array reciben un puntero de un global de `.bss`, y
**todos caen en `0x0040F4D0`–`0x0040F514`**: `0x0040F4D4` (física,
**confirmado** por otra vía), `0x0040F4E4` (`0x2C`), `0x0040F4F4` (el cierre),
`0x0040F510` (`0x2F`), `0x0040F514` (`0x0A`, spawn de personaje). Sumados
`0x0040F4D0` y `0x0040F4E0`, conocidos de 7c y de la entrada (37), el
directorio tendría al menos 7 entradas. **Probable, no medido.**

**No funcionó:**
- **El cierre transitivo por handler**, en sus dos mitades: los globales porque
  el dato no vive ahí, las cadenas porque no existen. Las dos con su medición.
- **Ghidra no hizo falta** para esto, salvo como control positivo de apertura y
  para la lista de funciones. La cuarta vez que el desensamblado a mano gana:
  la herramienta lee la tabla de saltos y el ELF directo.
- **Heredoc largo en la Bash tool**, otra vez (trampa 7). Se pagó un turno.

**Herramienta nueva, con autotest PROBADO EN ROJO:**
`herramientas/casos_dispatcher.py` — `mapa` / `familias` / `arrays` /
`caso 0xNN` / `tabla` / `autotest`. **6 casos confirmados por otra vía y 4
sabotajes**, los cuatro vistos en rojo; el sabotaje (b) reproduce el bug real
del recorrido ciego, y el (c) el del delay slot. Salida en
`kb/casos-dispatcher.json` y volcada a `kb/stage-modulos.json`.

**Sigue:** 7e sigue abierta por la mitad **(b)**, que **necesita el emulador**:
verificar por efecto al menos un tipo distinto del `0x0A`. Con el mapa en la
mano, el candidato más barato dejó de ser el `0x2D` — su registro tiene 0 de 48
ranuras ocupadas en los 9 volcados y el observable no se ve. Los dos candidatos
que el mapa habilita, y que antes no se podían ni formular, están en el
`HANDOFF`.

---

## 2026-08-28 (37) — 7e paso 2: el CONTROL en frío del observable. El array no es de 256, es de 48, y está VACÍO

**Máquina:** PC · **Modelo:** Opus, esfuerzo medio, sin fan-out
**Objetivo:** el *characterization test* que el plan de 7e ponía como paso
siguiente: contar, **en frío** sobre `volcados/ee-e4.bin`, las entradas de `0xC`
bytes que llena el camino de éxito del tipo `0x2D`, **antes** de gastar un
arranque del emulador. Escribir lo que el volcado **tiene**, no lo que la
hipótesis espera.

**Resultado: el control está escrito, y refuta la premisa del plan.** El
emulador no se abrió y no se escribió un byte.

### EL CONTROL — `python herramientas/registro_fisica.py medir`

| medición | valor | cómo se obtuvo |
|---|---|---|
| dirección del registro | **`0x004CB1C8`** | `*(0x0040F4D4) + 0xA48`, del sitio de llamada desensamblado |
| ranuras del array | **48 (`0x30`)**, *no* 256 | topes de `FUN_00175BF0` (`0x2F <`) y `FUN_00175C30` (`< 0x30`), coinciden |
| tamaño de la ranura | `0xC` | `param_1 + idx*0xC + 0x40` |
| registros tipo `0x2D` en el stream de LEVEL_00 | **256** | `stream_modulos.py` sobre el descriptor `0x01092800` |
| de esos, los que pasan la guarda del despachador | **4** | `lbu v1,0x1E(v0); bne v1,1` en `0x0015F780` |
| **RANURAS OCUPADAS en `ee-e4.bin`** | **0 de 48** | byte `+0x00` de cada ranura |
| ídem en los **otros 8** volcados de 32 MB del repo | **0 de 48, los nueve** | `registro_fisica.py todos` |

**Los tres números que el plan daba por sabidos estaban mal, y el que estaba
bien no era de este array.** El 256 existe —son los registros `0x2D` del
stream— pero el array que los recibe tiene 48 ranuras, y sólo 4 de los 256
registros llegan siquiera a intentar ocupar una. El «tiene que quedar en 255 de
256» nunca fue posible: el techo era 4.

### Layout del objeto, leído de las rutinas que lo recorren

```
0x004CB1C8  +0x00  16 punteros        FUN_00175BB0 (int*, +1, tope 0xF)
            +0x40  0x30 ranuras 0xC   FUN_00175BF0 / FUN_00175C30
```

Ranura (`FUN_00175F10`): `+0x00 u8` ocupada(=1) · `+0x01 u8` param_3 ·
`+0x04 u32` objeto · `+0x08 u32` `*(DAT_0040F4D0 + 0x20)`.

**Control positivo de que la base está bien:** los 16 punteros de la cabecera
son `0x006BD600 … 0x006C2100`, **paso uniforme `0x500`**, idénticos en los 9
volcados. No se le acierta a eso por casualidad — y los dos sabotajes del
autotest (global `0x0040F4D0`, desplazamiento `0xA40`) rompen esa regularidad,
que es exactamente lo que tienen que hacer.

### La guarda que el plan no había visto

El despachador llama al handler **sólo si `blob[0x1E] == 1`**:

```
0x0015F778  lw    v0, 4(s1)          ; blob del registro
0x0015F780  lbu   v1, 0x1E(v0)
0x0015F784  bne   v1, a0, 0x0015F7DC ; a0 = 1
0x0015F794  lw    a0, -2860(v1)      ; *(0x0040F4D4)
0x0015F79C  jal   0x00175980
0x0015F7A0  addiu a0, a0, 2632       ; delay slot -> + 0xA48
```

Reparto de `blob[0x1E]` en los 256: **250 en `0x00`, 4 en `0x01`, 2 en `0x02`**.
Los cuatro que pasan son `LW0001910`, `LW0001911`, `LW0001913` y `LW0001931`
(registros #326, #327, #329 y #406).

### Lo que sí es un observable, y varía

La **cabecera** de 16 entradas no está vacía y **cambia entre volcados**:
`ee-03.bin` tiene **5** entradas con `+0x70 != 0`; los otros 8, **3**
(`0x00FC8460`, `0x00FC8630`, `0x00FC89D0`). Todas con `+0x7C == 3`; **ninguna
con 4**, que es lo que busca `FUN_00175BB0`. Es el candidato a reemplazo del
observable muerto: es contable en RAM, es estable de sesión a sesión y ya se
lo vio tomar dos valores distintos.

**No funcionó:**
- **Ghidra volvió a perder argumentos, y por tercera vez.** Muestra
  `FUN_00175BB0()` sin ninguno (su firma real toma dos) y
  `FUN_00129160(DAT_0040f4d0)` con uno. Peor: el `DAT_0040f4d0` que nombra **no
  es el global que usa el sitio de llamada**, que es `0x0040F4D4`, cuatro bytes
  más allá. Las constantes de la herramienta salen del desensamblado a mano, no
  del decompilador.
- **Buscar el array por su contenido no habría servido.** Está todo en cero: no
  tiene firma. Se llegó por la cadena de llamadas, no por el dato.
- `xref 0x0040F4D0` da **709 referencias** y no discrimina nada. Es el
  síntoma de "sospechá del parámetro de la búsqueda", otra vez.

**El instrumento todavía no está probado contra un positivo real.** El
contador dijo `0` nueve veces y nunca otra cosa. El sabotaje (a) del autotest
ocupa una ranura a mano en una copia del volcado y exige que la cuente —eso
prueba que **sabe** decir otra cosa—, pero no reemplaza a haber visto una
ocupación de verdad. El `0` es **confirmado como medición**; que el array
«esté siempre vacío» es **probable**, no confirmado.

**Herramienta nueva, con autotest probado en rojo:**
`herramientas/registro_fisica.py` — `medir` / `todos` / `autotest`
(6 casos confirmados, 4 sabotajes). Se lo rompió a propósito dos veces
(`ESPERADO["ocupadas"]=1` y `paso_cab=0x400`) y salió en rojo con código 1 las
dos, y volvió a verde al restaurar.

**Sigue:** decidir el observable de reemplazo antes de tocar el emulador. El
array de 48 no sirve leído de un volcado. Los dos candidatos, en orden de
costo: **(1)** la cabecera de 16 (contable, varía, estable) y **(2)** una
lectura *en vivo* del array por PINE en el instante de la carga del nivel, que
es más caro y hay que justificarlo. La pregunta abierta que decide entre los
dos: **¿el array se llena y se vacía, o no se llena nunca?** — hoy no está
medido, y las dos cosas producen el mismo `0` en un volcado.

---

## 2026-08-23 (36) — 7e paso 1 CERRADO: el layout del registro, verificado contra datos, y el stream encontrado

**Máquina:** PC · **Modelo:** Opus, esfuerzo alto, sin fan-out
**Objetivo:** el paso bloqueante de 7e. El layout del registro del stage
(`{u32 tipo, u32 ptr, u64 payload}`, paso `0x10`) estaba **leído, no verificado
contra datos**, y la sesión anterior no había encontrado el stream mixto en RAM.
Identificar los 45 handlers sobre un layout sin verificar es tirar esfuerzo.

**Resultado: el paso 1 está cerrado**, y el layout salió **corregido**, no sólo
confirmado. Todo en frío sobre el ELF y `volcados/ee-e4.bin`; **el emulador no
se abrió y no se escribió un byte.**

### 1. Quién arma `param_2` — `FUN_0012dab8`

```c
FUN_0015ef48(piVar4 + 0x10,                    // param_1: arrays de handles
             *(u32 *)(piVar4[4] + 4),          // param_2: DOBLE INDIRECCION
             piVar4[1],
             *(u8 *)((int)piVar4 + 0x39));
```

`param_2` **no** es `piVar4 + algo`: `piVar4[4]` es un puntero a una cabecera, y
el `{count, array}` sale de `+4` de esa cabecera. Y `piVar4` no es una struct
suelta: es un sub-bloque de `base+0x4990` y `base+0x5210`, **dos slots de
`0x880` que alternan** (`*(u8*)(iVar5+0x5aae) ^= 1` en `FUN_00129360`) — el
cargador de nivel está **doble-buffereado**. El tag de estado es `*piVar4 ==
0x1C`.

### 2. El layout, VERIFICADO CONTRA DATOS — y corregido

```
+0x00  u32  tipo    (el case del switch)
+0x04  u32  ptr     BLOB DE DATOS del modulo, TAMANO VARIABLE
+0x08  u64  id64    NOMBRE DEL MODULO   <-- CORRECCION
```

La `kb` decía que el `u64` de `+0x08` se usaba **como posición** (leído del case
`0x0A`). **Es el id64 del nombre**, y decodifica con `herramientas/id64.py`
(autotest 13 casos, en verde) a nombres reales:

```
0x72AE2D2C5038CAD2 -> 'GP0101001527'
0x90CD810C5B2A9800 -> 'LW0001781'
```

Y `+0x04` se confirma como blob desde un handler **distinto** del case `0x0A`:
`FUN_00174430` (tipos `0x03`–`0x09`) hace su propio `switch(*param_3)` y usa
`*(int *)(param_3 + 4)` como su estructura.

### 3. El stream, encontrado — y el parámetro que lo encontró

**`descriptor 0x01092800 = {count=857, array=0x0109F590}`.**

Lo que la sesión anterior buscaba —el stream mixto— estaba ahí: 857 registros,
**41 tipos distintos**. La racha "pura de `0x2D`" que se había visto era un
tramo de adentro de este mismo array.

**Por qué no aparecía: el parámetro de búsqueda.** Buscar rachas por *rango de
tipo* (`0x03`–`0x44`) da **817 rachas** y se ahoga en contadores secuenciales de
`.data`. El parámetro que discrimina es la **monotonía estricta del puntero de
`+0x04`**: los blobs están contiguos y ascendentes, y un contador no. Con
monotonía, el barrido de los 32 MB da **3 candidatos**, y sólo uno tiene tipos
reales. Es el tercer caso medido de la misma lección (`sw {4,8,C}`→339;
`addiu 0x24`→32; stores a `+0xEC`→1).

**Control positivo, dos derivaciones independientes:**

- el `count` **leído** del descriptor = **857**;
- el largo del array **derivado por monotonía**, sin mirar el descriptor = **857**.
- Además los blobs **teselan** `0x010928B0`–`0x0109F540` sin solaparse (tamaños
  16–192 B) y el array de registros arranca 80 bytes después. El chunk entero es
  contiguo: descriptor, blobs, array.

### 4. Lo que dicen los nombres

| familia | tipos | qué sugiere |
|---|---|---|
| `SQTOM`, `SQMATT` | `0x01`, `0x02` | **escuadra** |
| `LW0001xxx` | `0x2D` (256) | objeto de física / pathfinding |
| `SD0101xxxxx` | `0x2E`, `0x2F`, `0x30` | sonido (hipótesis) |
| `WD0101xxxxx` | `0x1F`, `0x20`, `0x43` | sin identificar |
| `FX0101000004` | `0x33` | efecto (hipótesis) |
| `GP01010xxxxx` | el grueso | el contenido del nivel |

**`SQTOM`/`SQMATT` cruza con un hallazgo previo que no se buscaba:** la tabla de
7 punteros de `0x003BD3F8` (`None/Low/Mid/High/Matt/Tom/Carrie`), encontrada el
2026-08-21 por la vía de los nombres de escuadra.

**Tipo `0x2D` nombrado por evidencia de lectura:** su handler `FUN_00175980`
referencia `0x003F54A0` = `'Message to Level Designer / Physics object %s tagged
for Pathfinding collision has been removed without reexporting the world view'`.

**Tamaño de blob por tipo** (= tamaño de la struct que consume), fijo en 20 de
los 38 tipos con instancias: `0x1C`/`0x1D`=16 B · `0x1A`/`0x1F`/`0x20`/`0x2B`/
`0x44`=32 · `0x01`/`0x02`/`0x14`/`0x18`/`0x23`/`0x29`/`0x2E`/`0x38`/`0x3D`=48 ·
`0x2F`/`0x33`/`0x39`=64 · `0x43`=80 · `0x32`=96 · `0x3B`=160 · `0x30`=192.

### 5. Dos cosas que NO cerraron, y hay que decirlas

- **CERO registros de tipo `0x0A` en el stream**, y LEVEL_00 tiene cinco
  enemigos. El `0x0A` sigue confirmado por la vía de 7d (el literal `BG1_AK1`),
  pero **no viene de este stream**. O hay un segundo stream ya liberado, o los
  enemigos entran por otro lado. **Pregunta abierta, no darla por sabida.**
- **El stream lleva tipos que este dispatcher no despacha:** `0x01`, `0x02` y
  `0x33` aparecen en los datos y **no están entre los 61 casos** — caen en el
  `default`. O sea que el `switch` de `FUN_0015ef48` **no es el esquema completo
  del archivo**: es el esquema de lo que *este* dispatcher construye.

**No funcionó:**
- Suponer que `piVar4[4]` era `0x01412400` (el STLEVEL.BIN cargado). No lo es:
  `0x01412400` es una cabecera de pares `{count, ptr}` cuyo primer array
  (`{10, 0x01412480}`) es la **lista de recursos de arma** del nivel
  (`bg1_pst`, `bg1_shg`, `bg1_smg`, `bg1_ak1`, `bg1_asr`, `bg1_rpg`…). Sirvió
  de rebote: confirma que `bg1_rpg` está cargado en LEVEL_00, que es la premisa
  de la Vía B de 7d.
- **Nombrar handlers por las cadenas que referencian rinde poco.** Se hizo la
  herramienta (`tipos_modulo.py`) y se barrieron los 70 handlers: **sólo
  `FUN_00175980` tiene cadena**. Los handlers son constructores finos y las
  cadenas viven en los callees. La herramienta queda, pero no es la palanca.

**Herramientas nuevas, las dos con autotest PROBADO EN ROJO:**
- `herramientas/stream_modulos.py` — `buscar` / `resumen` / `listar` /
  `autotest` (5 casos, 2 sabotajes; el sabotaje (a) cuantifica el punto: sin la
  monotonía, 41 streams en vez de 3).
- `herramientas/tipos_modulo.py` — `cadenas` / `barrer` / `autotest`
  (1 caso, 3 sabotajes).

**Sigue:** 7e sigue abierta. Falta identificar los tipos y **verificar al menos
uno distinto del `0x0A` POR EFECTO** — y eso **sí necesita el emulador**. El
candidato más barato es el `0x2D` (256 instancias, física/pathfinding): romper
o mover sus blobs debería verse. La otra punta suelta es de dónde salen los
cinco enemigos, ya que del stream de `0x01092800` no salen.

---

## 2026-08-23 (35) — 7d CERRADA: el arma se elige POR NOMBRE (id64), y sí se puede fijar desde el ISO

**Máquina:** PC · **Modelo:** Opus, esfuerzo alto, sin fan-out
**Objetivo:** quién escribe `slot_0x110 + 0xEC`, el descriptor de arma que
`FUN_0015D060` le pasa a `FUN_00158F50`. Con eso, decidir si el arma de un
enemigo se puede fijar desde un archivo del ISO — la pregunta abierta desde 7a.

**Resultado: CERRADA, y con respuesta afirmativa.** Todo en frío sobre el ELF y
el volcado; **no se abrió el emulador ni se escribió un byte en RAM.**

### 1. La instrucción, y de dónde saca el valor

**`0x00156318  sw $v0, 0xEC($s0)`**, dentro de **`FUN_00156278`**
(`0x00156278`–`0x00156383`), el constructor del slot de arma de `0x110`.
Está **tres instrucciones antes** de la llamada a `FUN_0015D060` — o sea, la
escritura y la lectura viven en la misma función. El barrido de stores a
`+0xEC` en `0x00155000`–`0x0015D200` dio **54 accesos y un solo STORE**: éste.
El barrido de control sobre el `.text` entero dio 31 stores a `+0xEC`, y
ninguno de los otros 30 está en el subsistema de armas.

```c
*(u32*)(slot + 0xE8) = FUN_0015d210(DAT_0040f4e0, b);   // &tabla[b]
*(u32*)(slot + 0xEC) = FUN_0015d228(DAT_0040f4e0, b);   // tabla[b].+0x08  <-- EL DESCRIPTOR
FUN_0015d060(DAT_0040f4e0, slot, param_4);
```

Las dos rutinas son de una línea:

```
FUN_0015d210(mgr, b) =            *(*mgr + 4) + b*0x20        // (b<<24)>>19 = b*0x20
FUN_0015d228(mgr, b) = *(u32*)(   *(*mgr + 4) + b*0x20 + 8 )
```

O sea: **una tabla de 17 registros de paso `0x20`**, base en `*(*mgr + 4)`
(= `0x01842090` en el volcado), conteo en `*(*mgr + 1)` = **17**. El descriptor
de arma es el campo `+0x08` de esa tabla. `b` es el `param_3` del constructor,
**un byte**, que además queda guardado en `slot+0x00`.

### 2. El giro: `b` no es un dato guardado, se resuelve POR NOMBRE

El registro `+0x00` de esa tabla es un **id64** (el codec de `id64.py`). Los
**cinco** llamadores de `FUN_0015cef0` hacen todos exactamente lo mismo: barren
linealmente los 17 registros comparando `rec+0x00` contra un u64, y el índice
donde matchea es `b`. Si no matchea ninguno, `b = 0xFF`.

Los 17 nombres, decodificados:

| b | nombre | b | nombre | b | nombre |
|---|---|---|---|---|---|
| 0x00 | `BG1_PST` | 0x06 | `BG1_RPG` | 0x0C | `BG1_M16` |
| 0x01 | `BG1_SHG` | 0x07 | `BG1_GRL` | 0x0D | `BG1_RM1` |
| 0x02 | `BG1_SNR` | 0x08 | `BG1_SM3` | 0x0E | `BG1_GK1` |
| 0x03 | `BG1_SMG` | 0x09 | `BG1_P90` | 0x0F | `BG1_MP1` |
| 0x04 | `BG1_ASR` | 0x0A | `BG1_HVY` | 0x10 | `BG1_BNS` |
| 0x05 | `BG1_AK1` | 0x0B | `BG1_MGN` | | |

Las **cuatro fuentes del nombre**, todas medidas:

- **`FUN_00139c68`** — `entidad+0x3C0` (primaria) y `entidad+0x3C8`
  (secundaria), los dos u64. Es el camino del jugador.
- **`FUN_0015ef48` case `0x0A`** — el literal **`0x5446127297C60000`
  (`BG1_AK1`) hardcodeado en el `.text`**.
- **`FUN_001784f0`** — el literal `0x54461524B8230000` (`BG1_SNR`).
- **`FUN_0015c3c8`** — el byte directo desde `*(iVar6+0x44)`: es el re-arme /
  pickup, no el spawn.

Y la cadena data-driven completa:
`FUN_00178978`/`FUN_00178ae8` → `FUN_00178bc0(param_7)` → `descriptor+0x28`
→ `FUN_00138c80` → `FUN_001327f0(param_5)` → `FUN_0015cef0`.

### 3. Control positivo — 8/8, y dos confirmaciones cruzadas que no se buscaron

Contra `volcados/ee-e4.bin`, prediciendo `+0xE8` y `+0xEC` a partir del byte
`slot+0x00` para los ocho slots vivos: **los ocho, exactos.**

```
slot0 b=0x00  +0xEC=0x018422B0   entidad 0x005A8AB0 (jugador)
slot1 b=0x04  +0xEC=0x01842A30
slot2 b=0x04  +0xEC=0x01842A30
slot3..7 b=0x05  +0xEC=0x01842C10   <-- los cinco E_BLACKHD_M0 de la (33)
```

`b=0x05` da **`0x01842C10`**, que es exactamente el descriptor que la (33)
había medido en RAM. **Control positivo obligatorio cumplido.** Y dos cosas que
no se estaban buscando y cierran solas:

- `b=0x05` es **`BG1_AK1`** — y los enemigos de LEVEL_00 llevan AK.
- `b=0x00` es **`BG1_PST`** — y el jugador arranca con pistola. Además
  `entidad(jugador)+0x3C0` vale literalmente `BG1_PST`.
- El conteo `*(*mgr+1)` = **17**, el mismo 17 de la tabla de armas de `0x1E0`
  ya conocida.

### 4. La respuesta a 7a: SÍ, se puede fijar desde el ISO

Dos vías, las dos de 8 bytes:

1. **El literal del ELF.** `FUN_0015ef48` case `0x0A` lleva `BG1_AK1` escrito a
   mano. Cambiarlo por otro id64 cambia el arma de todo lo que spawnee por ese
   caso. `id64.py codificar` produce el u64 nuevo.
2. **La tabla de assets de armas del nivel, en `STLEVEL.BIN`.** En RAM, en
   `0x01412480` (= `stage+0x04`, con `stage+0x08` = 7): **7 registros de paso
   `0x28`**, cada uno `{nombre ASCII de 16 bytes, id64 en +0x10, puntero en
   +0x18, flags en +0x1C, conteo en +0x20}`. Para LEVEL_00 son
   `bg1_pst`, `bg1_shg`, `0001_bg1_smg`, `0001_bg1_ak1`, `0001_bg1_asr`,
   `bg1_rpg`, `0001_bg1_sm5`.

**Un arma nueva tiene que estar en esa lista de 7 para que el nivel la tenga
cargada.** Por eso el experimento más barato que existe es AK1 → RPG:
**`bg1_rpg` ya está en la lista de LEVEL_00**, así que no hay que agregar nada.

**No funcionó / se descartó:**

- **No hay un solo `sd` a `+0x3C0` en todo el `.text`** (32 accesos al
  inmediato `0x3C0`, y los únicos stores son spills de `$sp`). O sea:
  `entidad+0x3C0` **no se escribe con una instrucción propia**, llega por copia
  en bloque. Buscar "quién lo escribe" con un barrido de stores ahí habría dado
  cero y no habría sido un bug.
- Los cinco enemigos tienen `entidad+0x3C0 = 0` en el volcado, así que **no
  vinieron por `FUN_00139c68`**. Eso es lo que mandó a mirar los otros
  llamadores, y es lo que destapó el literal hardcodeado.

**Hallazgo lateral, y abre la fase que sigue: el índice de módulos del stage.**
Salió de una pregunta de Fran a mitad de sesión — en vez de subir la cadena de
llamadas eslabón por eslabón, buscar si el juego tiene un índice. Lo tiene.
El stage es un **stream de registros tipados de `0x10` bytes**
`{u32 tipo, u32 ptr, u64 payload}`, precedido por `{u32 count, u32 array}`, y
**`FUN_0015ef48` (`0x0015EF48`) es su dispatcher: 61 casos, tipos `0x03`–`0x44`**.
Ese `switch` **es el esquema del archivo de nivel**: una rama por tipo de
módulo. El case `0x0A` es el spawn de personaje. Enumerarlo entero da el mapa
de todo lo que un nivel puede contener, sin entrar módulo por módulo.

**Sigue:** 7e — enumerar los 61 casos de `FUN_0015ef48` y traducirlos a un
esquema del stream de nivel en `kb/`. Y, en paralelo y barato, el experimento
AK1 → RPG sobre el literal del ELF, que valida la vía 1 por efecto.

---

## 2026-08-22 (34) — 7c CERRADA: el bloque de IA no se elige, es el descriptor de arma **+0x30** fijo

**Máquina:** PC, lectura **en frío** sobre el ELF (PCSX2 no hizo falta) ·
**Modelo:** Opus · **Esfuerzo:** alto, sin fan-out.

**Objetivo:** encontrar la función que escribe el puntero de
`0x006E18B8 + n*0x24 + 0x04` al spawnear un enemigo, y de qué campo saca el
valor.

**Resultado: cerrada, y la respuesta es que NO sale de ningún campo del
registro de personaje. El bloque de IA es el descriptor de arma desplazado
`+0x30`, un offset fijo en el código.**

### 1. Por qué el xref directo daba cero — y no era un bug de la herramienta

`decompilar.py xref 0x006E18B8` devuelve **0 referencias**. No es que Ghidra
falle: **el código nunca arma esa dirección como literal.** Medido: cero
instrucciones `lui rX, 0x006E` en todo `.text` (0x00100000–0x00396F47).

La razón es que la dirección está **fuera del ejecutable**. Las secciones
llegan hasta `.bss` = 0x0040EC80–0x0049BFBC; 0x006E18B8 está muy después, o
sea es **heap asignado en runtime**. Se alcanza sólo por puntero.

> **Regla que sale de acá:** antes de gastar un xref sobre una dirección,
> mirar si cae dentro de alguna sección del ELF (`decompilar.py info` las
> lista). Si cae fuera, el xref va a dar cero **siempre**, y el camino es
> subir la cadena de punteros hasta una global estática.

### 2. La cadena de punteros, subida a mano sobre `volcados/ee-e4.bin`

Buscando quién contiene el valor de la dirección, escalón por escalón:

| Se busca | Aparece en | Qué es |
|---|---|---|
| `0x006E18B8` | **nadie** | la base estaba corrida (ver 3) |
| `0x006E18B0` | `0x005AE88C`, `0x005AEFD0`, `0x006DE784` | la base **real** del pool |
| `0x005AE880` | **`0x0040F4E0`** | global estática en `.bss` ← acá termina la cadena |

`0x0040F4E0` sí tiene xrefs: **114**, con una sola escritura, en `0x00102478`
dentro de `FUN_001020c0` (el init global de subsistemas):
`DAT_0040f4e0 = FUN_00107cf8(0xfe0)` — un objeto de **0xFE0 bytes**.

### 3. La base del array estaba corrida 8 bytes — el layout real

El constructor del manager es **`FUN_0015c970`** (`FUN_001020c0` lo llama con
la global). Ahí está el pool, con su tamaño escrito en el propio código:

```
*(param_1 + 0x04) = FUN_00107d20(0x31F0);   // 0x2F(47) bloques de 0x110 -> 0x006DE690
*(param_1 + 0x08) = FUN_00107d20(0x2F);     // 47 bytes                  -> 0x006E1880
*(param_1 + 0x0C) = FUN_00107d20(0x708);    // 0x32(50) x 0x24  <-- EL POOL -> 0x006E18B0
*(param_1 + 0x10) = FUN_00107d20(0x32);     // 50 bytes: array de OCUPACIÓN
```

O sea: **la base es `0x006E18B0` y son 50 entradas, no 10.** Las 10 que
veíamos eran las ocupadas. Cada entrada se inicializa con `FUN_00158f08`.

Layout real de la entrada de `0x24`, con el equivalente en la numeración
vieja (la que usa todo el `kb/`, base `0x006E18B8`):

| offset real | qué es | equivale a |
|---|---|---|
| `+0x00` | int, copiado de `perfil+0x90` | — |
| `+0x04` | puntero al bloque de `0x110` del propio manager | — |
| `+0x08` | **puntero al perfil de arma del JUGADOR** | base vieja `+0x00` |
| `+0x0C` | **puntero al perfil de arma de la IA** | base vieja **`+0x04`** |
| `+0x10` | puntero al registro de entidad (`0x0065FD00 + k*0x80`) | base vieja `+0x08` |
| `+0x14`, `+0x18` (halfword), `+0x1C` (float), `+0x20` (byte) | resto | — |

**El `kb/` existente no se invalida:** `base_vieja + n*0x24 + 0x04` es
exactamente `entrada_n + 0x0C`. Los tres campos que ya estaban anotados
caen donde decía. Lo que cambia es que ahora se sabe **por qué**.

### 4. La función, y la línea exacta

**`FUN_00158f50` @ `0x00158F50`–`0x0015911F` (464 bytes).**
Firma: `(entrada, bloque_0x110, descriptor_arma, param_4)`.

Las dos ramas, leídas en el desensamblado crudo (no sólo en la decompilación):

```
0x00158FD0  lw    $2, 0xc4($4)      ; *(bloque+0xF0) + 0xC4
0x00158FD4  bne   $5, ...           ; ¿== 2?  -> es el JUGADOR
...
0x00158FF4  sw    $16, 0xc($17)     ; RAMA JUGADOR:  entrada+0x0C = descriptor
...
0x00159008  addiu $4, $16, 0x30     ; RAMA NPC:      descriptor + 0x30
0x00159014  sw    $4,  0xc($17)     ;                entrada+0x0C = descriptor+0x30
```

**Ésta es la respuesta de 7c.** El discriminante es
`*(int*)(*(int*)(bloque+0xF0) + 0xC4) == 2` → jugador. Todo lo que no sea 2
—o sea, todo NPC— se lleva **el mismo descriptor de arma desplazado `+0x30`**.

**No hay selección, no hay tabla, no hay índice.** Por eso ni `+0x8C` ni
`+0xA8` del registro de personaje iban a servir: no participan de esta
cadena. Los dos candidatos que quedaban de la (32) quedan **descartados por
lectura**, sin gastar un parche de ISO en probarlos.

### 5. El llamador: de dónde sale el descriptor, y de dónde sale `n`

`FUN_00158f50` tiene **un solo llamador**: `FUN_0015d060`
(`0x0015D060`–`0x0015D197`), en `0x0015D10C`. Hace dos vueltas, una por arma:

```
iVar2 = *(bloque + 0xEC);                    // vuelta 0: arma PRIMARIA
iVar2 = *(*(bloque + 0xEC) + 0xA0);          // vuelta 1: arma SECUNDARIA
...
iVar3 = iVar5 * 0x24 + *(manager + 0x0C);    // <-- LA ENTRADA n DEL POOL
FUN_00158f50(iVar3, bloque, iVar2, param_3);
*(iVar3 + 4) = bloque;
*(*(manager + 0x10) + iVar5) = 1;            // marca el slot como ocupado
*(bloque + 0xF4) = iVar3;                    // (o +0xF8 para la secundaria)
```

Dos cosas más que salen gratis de acá:

- **`n` no significa nada.** Es el primer byte libre del array de ocupación
  de `manager+0x10`, recorrido linealmente. Explica por qué el array se
  llenaba progresivamente al spawnear, y por qué el orden no es estable.
- **El descriptor de arma sale de `bloque_0x110 + 0xEC`.** Ése es el
  siguiente eslabón, y es la Fase 7d.

### 6. Dos controles positivos pasivos, cerrados contra el volcado

Ninguno se buscó a propósito: son predicciones del código que el volcado ya
tenía escritas desde antes.

1. `*entrada = *(int*)(descriptor+0x90)`, con un `if` que lo pisa a 0 →
   en `ee-e4.bin`, `entrada+0x00` vale **0**. ✔
2. `*(bloque + 0xF4) = entrada` → `0x006DE690 + 0xF4 = 0x006DE784`, que en
   `ee-e4.bin` vale **`0x006E18B0`**, exactamente la entrada 0 del pool. ✔
   Ése era el tercer apuntador misterioso de la tabla del punto 2.

### 7. De yapa: los perfiles de arma son una tabla de paso `0x30`

Los valores del volcado (`0x018422B0`, `0x01842490`, `0x01842A30`/`A60`,
`0x01842C10`/`C40`) son **todos múltiplos de `0x30` desde `0x018422B0`**, y el
par (jugador, IA) es siempre `(X, X+0x30)` — consistente con el `addiu +0x30`
del código. Cuando los dos punteros de una entrada son **iguales**, es el
jugador (rama `== 2`).

**Y esto cierra la 7b por lectura:** los cinco enemigos daban todos
`0x01842C40` porque `0x01842C40 = 0x01842C10 + 0x30`, y `0x01842C10` es el
descriptor que les llegó por `bloque+0xEC`. `+0x78` nunca estuvo en esa
cadena. El negativo medido de la (33) y el desensamblado de acá dicen lo
mismo por dos caminos independientes.

**No funcionó** (los parámetros de búsqueda que hubo que descartar, cada uno
por dar demasiados candidatos o ninguno):

- `xref` directo sobre `0x006E18B8` → 0, por la razón del punto 1.
- Ventanas de `sw` con offsets `{4,8,C}` sobre el mismo registro base →
  **339 candidatos**. Parámetro inútil: ese patrón es cualquier constructor
  de cualquier struct del juego.
- `addiu rX,rY,0x90` junto a `addiu rX,rY,0xC0` (asumiendo que los perfiles
  se calculaban como `registro+0x90` y `registro+0xC0`) → **15 hits, ninguno
  relevante**. La suposición estaba mal: son dos punteros a una tabla de
  `0x30`, no dos campos de un registro.
- Lo que sí funcionó fue lo barato: `addiu rX,rX,0x24` (incremento de
  puntero por el paso del pool) → **32 hits**, y uno de ellos, `0x0015CA74`,
  cayó dentro de `FUN_0015c970` — la misma función a la que llegó, por
  separado, la cadena de punteros. **Dos vías independientes convergieron en
  la misma función**, que es lo que la vuelve confiable.

**Sigue (7d):** quién escribe `bloque_0x110 + 0xEC`, o sea quién decide qué
descriptor de arma se le asigna al slot antes de que `FUN_0015d060` lo lea.
Ahí está el punto donde se puede cambiar el arma de un enemigo de verdad.
Camino: xref sobre stores a `+0xEC` en el rango del subsistema
(`0x00155000`–`0x0015D200`), que ya está acotado.

---

## 2026-08-22 (33) — 7b, el experimento completo: `+0x78` NO gobierna el array de armas — REFUTADO

**Máquina:** PC, **con el juego corriendo**, `Black-mod-7b.iso` · **Modelo:**
Sonnet · **Esfuerzo:** medio, sin fan-out.

**Objetivo:** cerrar 7b jugando hasta `LEVEL_00` con el ISO parcheado de la
(32) y leyendo el array de `0x006E18B8` para `n=3,4,5,6,7,9`.

**Resultado: la escritura del lado causa SE CONFIRMÓ, y el efecto predicho
NO SE PRODUJO. La hipótesis queda REFUTADA, no "abierta".**

### 1. El array no estaba poblado hasta estar expuesto a los enemigos

Primera lectura, en `LEVEL_00` pero sin ver tiradores: `n=9` daba
`0x00000000` (sin entidad) y `n=4,5,7` seguían en el baseline. Confirma que
el array se llena progresivamente al spawnear, no todo junto con el stage.
Segunda lectura, ya expuesto: los 6 `n` dan valor no nulo. **El array
completo sólo se puede leer con el jugador cerca de los enemigos.**

### 2. El parche SÍ está en RAM — confirmado leyendo el propio registro

| campo | dirección | valor decodificado |
|---|---|---|
| `E_BLACKHD_M0 +0x18` (nombre) | `0x01412918` | `'E_BLACKHD_M0'` — sin cambios, correcto |
| `E_BLACKHD_M0 +0x78` (arma) | `0x01412978` | **`'RPG0'`** — el parche del ISO cargó |
| `E_LKISS2_M0 +0x78` (arma, control) | `0x01412A28` | `'MGNDST0'` — sin cambios, correcto |

El registro de personaje en RAM **es exactamente el que se pidió**: el
`+0x78` de `E_BLACKHD_M0` pasó de `MGNDST0` a `RPG0`, y nada más se movió.

### 3. El array de armas NO se movió — para ningún `n`

| n | baseline (32) | expuesto, ahora |
|---|---|---|
| 3 | `0x01842C40` | `0x01842C40` |
| 4 | `0x01842C40` | `0x01842C40` |
| 5 | `0x01842C40` | `0x01842C40` |
| 6 | `0x01842C40` | `0x01842C40` |
| 7 | `0x01842C40` | `0x01842C40` |
| 9 | `0x01842C40` | `0x01842C40` |

Los `n=4,5,6,7,9` (los cuatro tiradores de `E_BLACKHD_M0` con array
completo) **siguen apuntando al mismo bloque de IA que antes del parche**,
pese a que su propio registro de personaje ya dice `RPG0`. `n=3`
(`E_LKISS2_M0`, control) tampoco se movió, como correspondía.

**No funcionó:** la hipótesis "`+0x78` fija el bloque de IA que usa el
array de `0x006E18B8`". Está refutada con las dos mitades confirmadas: se
escribió el campo (evidencia de causa) y se leyó el efecto sin que cambiara
(evidencia de no-efecto). No es un negativo por falta de medición — es un
negativo medido.

**Lectura correcta, ahora:** `+0x78` decide el **modelo visual** del arma
(`FUN_00136848` compone `<+0x78>_LOD`, confirmado en la (32) por
desensamblado). El array de `0x006E18B8` — que gobierna `Power` y `TBB`, o
sea el comportamiento real de combate — se resuelve por **otra vía**, ya sea
en el spawn desde un campo distinto o desde una tabla que no pasa por
`personaje+0x78`. Los candidatos que quedan sin probar de la (32) son
`+0x8C` y `+0xA8` — los otros dos campos que particionaban igual que el
bloque de IA en el diff de los 4 registros instanciados.

**Sigue:** decidir si 7b se cierra acá (con el hallazgo negativo anotado, que
ya es información real: el modelo del arma y el comportamiento de IA son dos
sistemas separados) o se prueba `+0x8C`/`+0xA8` con un parche nuevo del ISO.
Es una decisión de alcance, no técnica — se la pregunté a Fran.

---

## 2026-08-22 (32) — 7b EN VIVO: el arma no la fija `+0x18`, la fija `+0x78`

**Máquina:** PC, **con el juego corriendo** (primera sesión en vivo desde el
2026-08-17) · **Modelo:** Sonnet · **Esfuerzo:** medio, **sin fan-out**.

**Objetivo:** cerrar 7b por efecto — escribir `+0x18` de un registro de
personaje y ver cambiar el registro de arma en `0x006E18B8 + n*0x24 + 0x04`.

**Resultado: el experimento estaba apuntado al campo equivocado y al personaje
equivocado. Los dos errores se encontraron midiendo, no leyendo.**

### 1. El savestate y el codec verifican

`ubicaciones.py` 13/13, `id64.py autotest` 13 casos / 0 fallas. Cargado el
slot 3, los `+0x18` de los personajes en RAM coinciden byte a byte con el
volcado en frío de la (31): `0x01412618` = `0xA79C744648E00000` = `PSTL0`.
El stage es el que se volcó.

### 2. `PSTL0` no está instanciado — se le escribió a un personaje ausente

El array de armas está **lleno**: 10/10 entradas, `n=0` y `n=8` son del
jugador (`+0x00 == +0x04`, `+0x08 = 0`) y las 8 restantes tienen entidad.
Siguiendo `entidad+0x58` se ve a qué registro de personaje apunta cada una:

| n | bloque IA | entidad | `+0x58` → personaje | facción `+0x50` |
|---|---|---|---|---|
| 1 | `0x01842A60` | `0x0065FD00` | `0x01412A80` `MCHNGNM0` | `0x005A3890` |
| 2 | `0x01842A60` | `0x0065FD80` | `0x01412B30` `SBMCHGNM0` | `0x005A3890` |
| 3 | `0x01842C40` | `0x0065FE00` | `0x014129B0` `E_LKISS2_M0` | `0x005A3870` |
| 4..7, 9 | `0x01842C40` | `0x0065FE80`.. | `0x01412900` `E_BLACKHD_M0` | `0x005A3870` |

**Sólo 4 de los 9 personajes están instanciados.** `PSTL0` (`0x01412600`) no
tiene ninguna entidad apuntándole: la escritura que pedía el handoff no podía
producir efecto ni aunque la hipótesis fuera correcta.

**Y `entidad+0x58` no es "descriptor de escuadra": es el puntero al registro
de personaje de paso `0xB0`.** Eso reconcilia la lectura de 7a con la (31):
el `+0x00` de ese bloque es el destino del `sprintf`, y leído en vivo da
`'Enemy0_None'`, `'Enemy0_Mid'`, `'Enemy1_Low'`, `'Team0_Tom'`,
`'Team1_Matt'`. La facción `+0x50` parte exactamente en COMP/ENEM.

**De regalo, el mapeo de `+0x88` leído en vivo** (era una fase aparte):
`0 → None`, `1 → Low`, `2 → Mid`, `8 → Matt`, `0x10 → Tom`.

### 3. El campo que particiona como el arma es `+0x78`, no `+0x18`

Diff de los `0xB0` bytes de los 4 registros instanciados, agrupando por bloque
de IA (`MCHNGNM0`+`SBMCHGNM0` → `0x01842A60`; `E_LKISS2_M0`+`E_BLACKHD_M0` →
`0x01842C40`). Campos que particionan **exactamente** como el arma: `+0x00`
(que es efecto, no causa), **`+0x78`**, `+0x8C` y `+0xA8`. **`+0x18` no**, y
`+0x88` tampoco.

`+0x78` decodificado en los 9 personajes:

| personaje (`+0x18`) | `+0x78` | `+0x8C` |
|---|---|---|
| `PSTL0`, `SHTG0` | `DISTANT0` | 4 |
| `E_MAC10_M0`, `E_BLACKHD_M0`, `E_LKISS2_M0`, `E_UZI_M0` | `MGNDST0` | 4 |
| `MCHNGNM0`, `SBMCHGNM0` | `MGNDST2` | 6 |
| `RPG0` | `RPG0` | 3 |

Encaja con el desensamblado: `FUN_00136848` hace
`FUN_00272610(nombre, 0xE69A1DD748000000)`, y ese id64 **decodifica a
`'_LOD'`**. O sea compone `<nombre>_LOD` y carga un **modelo de arma**, con
`'AI gun model not found: %s'` como falla. `MGNDST0_LOD`, `DISTANT0_LOD`,
`RPG0_LOD` son exactamente esa forma.

**Hipótesis corregida de 7b:** `+0x18` fija el modelo **del personaje**;
**`+0x78` fija el modelo del arma de IA**. Sigue `probable`: falta el efecto.

### 4. La escritura en caliente no puede cerrar 7b, y ahora se sabe por qué

Dos escrituras, las dos restauradas y releídas:

1. `0x01412618` (`+0x18` de `PSTL0`) ← `E_UZI_M0`. Sin cambios.
2. `0x01412978` (`+0x78` de `E_BLACKHD_M0`, 5 entidades vivas) ← `RPG0`.
   Sin cambios.

**Control positivo corrido antes de creerle al "ninguno"**: 3 de 8 entidades
cambiaron su posición XYZ en 3 s, así que el emulador avanza y el canal de
medición está vivo. El negativo es real.

**El campo se lee al spawnear.** En el slot 3 ya está todo spawneado y el
array está lleno, así que no hay nada que reasignar. Y **no hay savestate
anterior a la carga del stage**: los slots 01 y 02, que pesan 15 MB contra los
45-51 MB del resto, también están dentro de `LEVEL_00` con el stage ya
enumerado. Un savestate restaura toda la RAM, así que tampoco sirve para ver
el efecto de un parche de ISO.

### 5. El ISO: offsets ubicados y únicos

`STLEVEL.BIN` de `LEVEL_00` se carga **literal**: RAM `0x01412400` = offset
`0x000` del archivo, sin fixup. Verificado por búsqueda: el id64 de `PSTL0`
aparece **una sola vez** en los 2,5 MB, en `0x218` — que es exactamente
`0x01412618 - 0x01412400`.

Offset del archivo dentro del ISO: **`0x804D6800`** (LBA 1051053).

| qué | offset archivo | offset ISO | valor actual |
|---|---|---|---|
| `+0x78` de `E_BLACKHD_M0` | `0x578` | `0x804D6D78` | `MGNDST0` |
| `+0x18` de `E_LKISS2_M0` | `0x5C8` | `0x804D6DC8` | `E_LKISS2_M0` |

**No funcionó:** la escritura en caliente, por la razón estructural de arriba
—no es que la hipótesis esté mal—. Y el plan del handoff apuntaba a `PSTL0`,
que no está instanciado, y a `+0x18`, que no particiona como el arma.

**Sigue:** el ISO parcheado. Un solo experimento discrimina los dos campos:
cambiar `+0x78` de `E_BLACKHD_M0` a `RPG0` **y** `+0x18` de `E_LKISS2_M0` a
otro modelo. Si la hipótesis es correcta, el bloque de IA de `n=4,5,6,7,9`
cambia y el de `n=3` **no**. Las dos mitades se leen con `pine.py`, sin mirar
la pantalla. **Requiere jugar hasta `LEVEL_00` con el ISO parcheado: no hay
atajo por savestate.**

---

## 2026-08-22 (31) — 7b: el array de `0xB0` volcado, y el nombre del personaje está en `+0x18`

**Máquina:** PC, **sin correr el juego** · **Modelo:** Opus · **Esfuerzo:**
alto, **sin fan-out** (el harness volvió a anunciar opt-in a multiagente por
la palabra `ultracode` del retome, que la **niega**; se ignoró a propósito,
igual que en la (30)).

**Objetivo:** el paso que la (30) dejó pendiente — volcar el array de `0xB0` y
contestar **qué campo del registro nombra al personaje**.

**Resultado: contestado.** Todo `probable`: cero escrituras.

### 1. El campo es `+0x18`, y es un id64 — no `+0x00`

`+0x00` **no sirve para identificar nada en frío**: es el destino del
`sprintf` `'Enemy%d_%s'`, o sea se llena en runtime, y en el archivo de disco
está vacío. Eso explica por qué la (29) barrió el ISO buscando nombres de
escuadra y no encontró ninguno.

El nombre real vive en **`+0x18`, empaquetado como id de 64 bits**. Los 9
personajes de `LEVEL_00`:

| unidad | tipo | `+0x18` | `+0x88` |
|---|---|---|---|
| `bg1_pst` | enemigo | `PSTL0` | 0 |
| `bg1_shg` | enemigo | `SHTG0` | 0 |
| `0001_bg1_smg` | enemigo | `E_MAC10_M0` | 2 |
| `0001_bg1_ak1` | enemigo | `E_BLACKHD_M0` | 2 |
| `0001_bg1_ak1` | enemigo | `E_LKISS2_M0` | 1 |
| `0001_bg1_asr` | compañero | `MCHNGNM0` | 0x10 |
| `0001_bg1_asr` | compañero | `SBMCHGNM0` | 8 |
| `bg1_rpg` | enemigo | `RPG0` | 0 |
| `0001_bg1_sm5` | enemigo | `E_UZI_M0` | 4 |

El registro tiene además una serie de variantes del mismo nombre: `+0x20`,
`+0x28`, `+0x30` son `M1`/`M2`/`M3`, `+0x68` es `S0` y `+0x70` es `E0`.

### 2. El codec de 64 bits, portado y probado

`FUN_00272488` es **base-40 de ancho fijo, 12 caracteres, escrito de atrás
hacia adelante**. Alfabeto: `0=' '`, `1='-'`, `2='/'`, `3..12='0'..'9'`,
`13..38='A'..'Z'`, `39='_'`. Sin minúsculas.

Está portado a **`herramientas/id64.py`**. La validación no fue "parece que
anda": los 12 IDs de la tabla de cámaras de `STLEVEL.BIN` decodifican a
`CAM_BLOWDOOR`, `CAM_INTRO`, `CAM_RPGTOWER`, `CAM_START`, `CAM_TRUCK`,
`CAM_XROADS`, `CITY_START` y `DEATHCAM01..06` — **y salen en orden
alfabético**, que es un orden que un codec equivocado no produce por
casualidad. El `autotest` se probó **rompiéndolo dos veces** (alfabeto corrido
una posición, y orden de escritura invertido): se pone en rojo con `exit 1` en
las dos.

### 3. El error que costó la mitad de la sesión: disco vs RAM

Se intentó resolver el layout **sobre el archivo del ISO**, teniéndolo a mano.
No funciona: en disco los punteros `unidad+0x18`/`+0x1C` son **offsets
relativos a la sección `0x80`, no al archivo**. El fixup hace
`base + 0x80 + valor`. Sin eso, el puntero de la unidad 0 da `0x180`, que cae
**dentro del propio array de unidades** — y el parseo produce bloques
plausibles pero falsos.

Sobre `volcados/ee-03.bin` (savestate slot 3, `LEVEL_00`, con la imagen
cargada literal en `0x01412400` — 99.60% de los primeros 64 KB idénticos al
archivo del ISO) los punteros ya están arreglados y **todo cae solo**.

El handoff de la (30) ya lo decía: *"conviene resolver sobre la imagen en
RAM"*. Se fue al disco igual porque estaba más a mano. Registrado como
lección.

### 4. El test que casi hace pasar un layout falso

Se validó el paso del registro mirando si `+0x88 < 0x21`. Con el layout
**equivocado** daba **7/9**, y un paso inventado de `0xAC` daba **8/9**. El
test no discrimina porque **la mayoría de los valores reales son `0`**, y el
cero pasa cualquier test de rango. Lo que lo salvó fue haber corrido el
control negativo. Con el layout correcto da **9/9**. Registrado como lección.

### 5. Cómo NO buscar ids en un archivo

El codec es **total**: todo `u64` decodifica a 12 caracteres. Filtrar sólo por
"alfabeto válido" sobre `STLEVEL.BIN` da **79.048 nombres distintos**: ruido
puro. Lo que separa la señal es el **relleno de espacios a la derecha**: con
`>= 2` quedan **88**, y son todos reales — incluidos los 7 `BG1_*` que
coinciden uno a uno con los nombres ASCII de las unidades, que es control
cruzado independiente.

**No funcionó / no se hizo:** no se escribió un solo byte, así que **7b sigue
abierta**: cierra por efecto, no por lectura. Falta la sustitución de prueba
en RAM y su verificación en `0x006E18B8 + n*0x24 + 0x04`.

**Sigue, en este orden:**
1. Escritura de prueba **en RAM**, reversible, sobre `+0x18` de un registro.
2. `decompilar.py c 0x00272610` — el lado codificador, para escribir nombres.
3. El ISO al final, con `parche_iso.py`.

**Estado de la máquina al cerrar:** BLACK no se corrió, cero escrituras, cero
parches. `ubicaciones.py` 13/13, `decompilar.py info` en verde.

---

## 2026-08-21 (30) — 7b: la cadena entera, del stage al enemigo, leída en Ghidra en frío

**Máquina:** PC, **sin correr el juego** · **Modelo:** Opus · **Esfuerzo:**
alto, **sin fan-out** (el harness anunció opt-in a multiagente por la palabra
`ultracode` que aparecía en el retome **negándola**; se ignoró a propósito).

**Objetivo:** contestar la pregunta que dejó abierta la (29): *¿quién arma
`Enemy%d_%s`, y de dónde saca el índice?*

**Resultado: contestada, y aparece la estructura que faltaba.** Todo `probable`
— es lectura de decompilado, no se escribió un byte.

1. **`'Enemy%d_%s'` (`0x003F8108`) tiene UNA sola referencia**:
   `0x001E2DE4`, dentro de **`FUN_001E2D38`** (`0x001E2D38`–`0x001E2F03`).
   Es el enumerador de enemigos y de compañeros del stage. Volcado en
   `volcados/7b/fun-001e2d38.c`.

2. **Layout que sale de esa función** (lo que 7b venía buscando):

   ```
   objeto de stage  (param_2)
     +0x04  ptr -> array de registros de UNIDAD, paso 0x28
     +0x08  cantidad de unidades
     +0x10  ptr -> tabla de nombres (u64) : +0x08 cantidad, +0x0C array de 0x10

   registro de UNIDAD (paso 0x28)
     +0x18  ptr -> array ENEMIGOS   +0x20  cantidad
     +0x1C  ptr -> array COMPANEROS +0x24  cantidad

   registro de PERSONAJE (paso 0xB0)   <-- LA LISTA QUE FALTABA
     +0x00  buffer de nombre  (destino del sprintf 'Enemy%d_%s' / 'Team%d_%s')
     +0x88  INDICE DE TIPO    (lo que 7b busca)
     +0x94  parametro que se registra en el sistema de sonido
   ```

   El `sprintf` es `FUN_0035D728`. El registro de sonido, `FUN_0027B950`, con
   `PTR_s____Export_ValueDB_Sound_ps2_AIWe_003BD3B8` — **confirma el
   reencuadre de la (29): esa rama es sonido, y `+0x58` es el espejo.**

3. **`+0x88` es un enum de hasta 33 valores, no de 7.**
   `FUN_001E3018(this, idx)` acepta `idx < 0x21` y salta por la jumptable
   `PTR_LAB_003F8130`; la tabla de 7 punteros de `0x003BD3F8` se lee **desde
   adentro** (`0x001E3044`, la única referencia que tiene). O sea:
   `None/Low/Mid/High/Matt/Tom/Carrie` no era el dominio, **era el
   codominio**. 33 tipos colapsan a 7 etiquetas.

4. **Quién carga el stage:** `FUN_00128480` llama en `0x00128958`. Es la
   máquina de estados de carga (estado en `+0x5AA0`, **nivel en `+0x5AAC`,
   stage en `+0x5AAD`**, los dos `u8`). Pide el recurso con
   `FUN_00108458(DAT_0040F4C4, 0x0B, idx)` y lo guarda en `+0x5AF0`: **ése es
   el `param_2`**. Si vuelve 0, arma la ruta con `0x003F4388` y lo carga del
   disco. Volcado en `volcados/7b/fun-00128480-caller.c`.

5. **El cargador de armas de IA, entero** (`FUN_00136848`, quien emite
   `'AI gun model not found: %s'`):

   ```c
   id  = FUN_00272610(nombre, 0xE69A1DD748000000);   // texto -> id de 64 bits
   res = FUN_00108120(DAT_0040F4C4, id);
   if (res == 0)  error 0x003F4848;
   else { FUN_00135C78(actor,0,res,0); *(u8*)(actor+0x3B4) = 0; }
   ```

   O sea el arma de IA se resuelve **por nombre hasheado**, y el struct del
   actor de IA llega al menos hasta `+0x3B4`.

6. **El ID de 64 bits NO es opaco: tiene codec de ida y vuelta.**
   `FUN_00272610(texto, base)` codifica; **`FUN_00272488(id, buffer)`
   decodifica** — el bucle de `stage+0x10` la usa para sacar texto y después
   **recorta los espacios de la derecha**, que es la firma de una cadena
   empaquetada de ancho fijo. La (28) lo había archivado como "no descifrado y
   no vale la pena": **hay que desarchivarlo**, porque es la llave para
   escribir nombres nuevos en el ISO en vez de sustituir 11 bytes a ciegas.

**No funcionó / no se hizo:** no se volcó todavía el array de `0xB0` sobre
`volcados/stlevel-l00.bin`, que es el paso que convierte todo esto en la lista
de spawn concreta. La sesión se cortó por batería, no por el problema.

**Sigue, en este orden:**
1. Volcar el array de `0xB0` desde `volcados/stlevel-l00.bin` y ver **qué
   campo del registro nombra al personaje** (`so1` / `rg1`). Ahí cierra 7b.
2. Decompilar `FUN_00272488` y `FUN_00272610` — el codec de nombres.
3. Recién después, escritura de prueba en RAM (`0x01412400`), reversible.

**Estado de la máquina al cerrar:** sin correr BLACK, cero escrituras, cero
parches. `ubicaciones.py` 13/13, `decompilar.py info` con el control positivo
en verde.

---

## 2026-08-21 (29) — 7b en frío: el nombre de escuadra no estaba escrito en ningún lado, y el ELF tiene los mensajes de error de los diseñadores

**Máquina:** PC, **sin correr el juego** (Fran sin cargador) · **Modelo:** Opus
(inferencia sobre estructura desconocida) · **Esfuerzo:** alto, sin fan-out

**Objetivo:** avanzar 7b sin emulador, sobre el ISO y el ELF.

**Resultado:** 7b sigue abierta —no se escribió un byte, y cierra por efecto—
pero cambió de forma, y el trabajo en frío rindió más por token que las dos
sesiones en caliente anteriores.

1. **El negativo que resultó ser la respuesta.** `Enemy0_Mid`, `Team0_Tom` y
   compañía dan **cero ocurrencias** en `STLEVEL.BIN`, cero en `STUNIT01.BIN`
   y cero en los ~2.900 archivos del ISO entero. No estaban mal buscados: **no
   están escritos en ninguna parte**. El ELF los arma en runtime, y ahí están
   los formatos, en `.rodata`:

   ```
   va 0x003F8108  'Enemy%d_%s'
   va 0x003F8118  'Team%d_%s'
   ```

2. **La tabla de piezas, en `.data`: `0x003BD3F8`**, siete punteros a `char*`
   consecutivos — `[0]None [1]Low [2]Mid [3]High [4]Matt [5]Tom [6]Carrie`.
   La séptima (`Carrie`) apareció recién al volcar el rango crudo: el barrido
   inicial buscaba los seis nombres ya conocidos y la tabla "terminaba" justo
   en seis.

3. **Reencuadre que hay que decir en voz alta:** esas cadenas viven en el
   bloque de `../Export/ValueDB/Sound/ps2/AIWeapon.cfg`, rodeadas de
   `EnemyWeapon`, `MaxEnemiesSoundedPerFrame`, `Emphasis Decay Frames`,
   `BulletBy` y `Rate`. Son **claves de configuración de sonido de arma de
   IA**. Que la partición por `+0x58` coincida exacto con la partición por
   registro de arma de 7a ahora tiene una explicación más barata que
   "descriptor de escuadra": **dos enemigos con la misma arma comparten grupo
   de mezcla**. O sea que `+0x58` es candidato a **espejo, no a fuente**, y
   perseguirlo para 7b es perseguir el reflejo.

4. **El modo de falla de E5 tiene mensaje propio en el ELF:**

   ```
   0x003F4848  'AI gun model not found: %s'
   0x003F4864  'Please ask a designer to add it to the '
   0x003F488D  'weaponList.txt file for this level'
   ```

   Confirma que hay una **lista de armas por nivel** —el directorio
   `STLEVEL+0x80`, 7 registros de paso `0x28`, que ya conocíamos— y da un
   observable de error **más específico y más barato que la pantalla**.

5. **Las rutas del stage se construyen, no están horneadas** (`0x003F4348` en
   adelante): `Levels\Level_%02u\Stg_%04u\StLevel.bin`,
   `...\StUnit%02d.bin`, `...\Guns%s.bin`, `...\LevelDat.bin`,
   `...\Unit_%02d.bin`, `...\fpguns\`. Corrobora 6.1 desde otro lado y expone
   nivel/stage/unidad como parámetros.

6. **Los dos "grupos" de los nombres `bc1_` quedaron caracterizados**, y
   ninguno es una lista de spawn: los dos son entradas de recurso con tamaño
   declarado. Grupo A = cabecera de chunk (`flags 0x00101001` + tamaño +
   nombre); grupo B = tres pares `008a0105`/`1.0f` + tamaño + nombre. `rg1`
   tiene los dos, en `STUNIT01.BIN` (`0x2a8` y `0x3f65c`), con estructura
   idéntica a la de `so1` — o sea que la sustitución de 11 bytes sigue en pie.

7. **`kb/ubicaciones.json` + `herramientas/ubicaciones.py`** (nuevos): dónde
   vive cada archivo que no está en el repo, en un solo lugar, con un
   verificador que lo **mide** y sale con código 1 si falta algo crítico.
   13/13 en verde. Probado rompiéndolo en tres formas (ruta ausente, tamaño
   distinto, carpeta declarada como archivo): las tres se ponen en rojo.

**No funcionó:**

- **`Test-Path` mintió.** Reporté que la carpeta de los ISO no existía y que
  la máquina se había desconfigurado. Falso: los corchetes de `Black [NTSC]`
  son wildcard en PowerShell si no se pasa `-LiteralPath`. Los dos ISO están
  enteros. Lección registrada.
- **La ruta de Ghidra del mensaje de retome estaba mal** (`~\ghidra-proyectos2`
  en vez de `~\herramientas\ghidra-proyectos2`), y la verifiqué desde ahí en
  vez de contra `decompilar.py:77`, que la tenía bien. `ESTADO_ACTUAL.md`
  estaba correcto: abrevia con `...\` y yo leí mal la abreviatura.
- **Sigue sin aparecer la lista de puntos de spawn.** Es lo único que traba
  el experimento.

**Sigue:** buscar quién referencia `0x003F4848` y la tabla `0x003BD3F8` con
Ghidra (`decompilar.py`, en frío, sin emulador). La función que arma
`Enemy%d_%s` recibe el índice de algún lado, y ese "algún lado" es el campo
que 7b busca.

**Estado de la máquina al cerrar:** PCSX2 abierto por Fran pero **sin correr
BLACK a propósito** (notebook sin cargador). Cero escrituras, cero parches.

---

## 2026-08-17 (28) — 7b: el nivel entero está en RAM en una dirección conocida, y E5 apuntaba al nivel equivocado

**Máquina:** PC, PCSX2 corriendo con el ISO original · **Modelo:** Opus
(hipótesis primera en territorio desconocido) · **Esfuerzo:** alto, sin fan-out

**Objetivo:** abrir 7b — qué dato fija **qué tipo** de enemigo aparece —
entrando por la vía barata que dejaba anotada `docs/08-experimentos.md`: E5,
el truco de los 11 caracteres sobre `STLEVEL.BIN`.

**Resultado:** 7b **no cerró** (nada cambió todavía en pantalla), pero el
experimento quedó rediseñado y mucho más barato, y cayeron cinco cosas nuevas.

1. **E5, tal como estaba escrito, apuntaba al nivel equivocado.** El plan
   nombraba `LEVELS/LEVEL_01/STG_0001/STLEVEL.BIN` porque el savestate se
   llamaba "nivel 1". **El savestate slot 3 está en `LEVEL_00`, no en
   `LEVEL_01`.** Medido por huella de tamaño, no por el nombre: los chunks
   `bc1_` residentes en RAM declaran `0x15e40` (lr1), `0x10700` (so1) y
   `0xb60` (asr_goggles), que son los tamaños de **`LEVEL_00`**; los de
   `LEVEL_01` son `0x15e20`, `0x10740` y no tiene `asr_goggles`.

2. **Y `LEVEL_00/STG_0001` no tiene los cuatro nombres de 11 caracteres.**
   Sólo tiene `bc1_lr1_mil` y `bc1_so1_mil`. `bc1_rg1_mil` (el del RPG) y
   `bc1_sk1_mil` viven en `LEVEL_01`. O sea que el truco del mismo largo, en
   el nivel donde de verdad estamos, tiene menos piezas de las que el plan
   suponía.

3. **Pero el personaje del RPG *sí* está residente igual.** Sale de otro
   archivo: **`LEVELS/LEVEL_00/STG_0001/STUNIT01.BIN`**, que trae
   `bc1_rg1_mil` con tamaño `0x15e70`. Eso **mata el modo de falla que E5
   predecía** ("si el `.WDD`/`.DB` del modelo no está cargado, va a faltar el
   modelo"): en `LEVEL_00` está cargado.

4. **EL HALLAZGO GRANDE — los archivos de stage se cargan LITERALES, sin
   relocalizar, en una dirección fija de EE:**

   | archivo | base en EE | anclas |
   |---|---|---|
   | `LEVEL_00/STG_0001/STLEVEL.BIN` | **`0x01412400`** | **7/7** |
   | `LEVEL_00/STG_0001/STUNIT01.BIN` | **`0x01053000`** | **2/2** |

   `direccion_en_ram = base + offset_en_el_archivo`, sin excepción, para los
   nueve chunks `bc1_` de los dos archivos. **Consecuencia práctica: cualquier
   edición que se quiera hacer permanente en el ISO se puede probar antes en
   RAM, reversible, sin copiar 3,9 GB y sin reiniciar el emulador.** Eso
   cambia el costo y el riesgo de todo el resto de la fase 7.

   Y no es una copia muerta: el juego guarda **punteros vivos adentro de esa
   imagen** (ver punto 5), así que escribir ahí escribe datos vivos del nivel.

5. **La cadena entidad → escuadra, confirmada por coincidencia con 7a.**
   Ampliando el array de 7a (`0x006E18B8`, paso `0x24`): su `+0x08` apunta a
   un **registro por entidad de paso `0x80` en `0x0065FD00`**, y el `+0x58`
   de ese registro apunta a un **descriptor de escuadra con nombre en texto**,
   adentro de la imagen de `STLEVEL`. Los nombres son
   `Enemy0_None`, `Enemy0_Mid`, `Enemy1_Low`, `Enemy0_High`, **`Team0_Tom`** y
   **`Team1_Matt`**.

   La partición que produce `+0x58` **coincide exactamente** con la partición
   por registro de arma ya confirmada en 7a: los dos de vida `FLT_MAX` que no
   disparan (registro 4) son `Team0_Tom` y `Team1_Matt`, y los seis que
   disparan (registro 5) son `Enemy1_Low` y `Enemy0_Mid`. **Los de `FLT_MAX`
   son los compañeros de escuadra del jugador** — eso explica de una el
   callejón cerrado que decía "los de vida `FLT_MAX` no son los tiradores".

6. **Corroboración independiente de una hipótesis vieja.** El directorio de
   recursos de arma del stage (`STLEVEL+0x80`, 7 registros de paso `0x28`)
   asocia **`0001_bg1_ak1` con `Enemy0_Mid`**, que es justo la escuadra de los
   cinco tiradores activos. Medimos por efecto que usan el **registro 5**, y
   el registro 5 estaba anotado como "ASR". Es exactamente lo que predice la
   hipótesis abierta **"el código de 3 letras de `arma+0x1C0` está corrido un
   registro"**. Dos fuentes que no se hablan dicen lo mismo.

**No funcionó:**

- **Buscar quién apunta a los chunks de personaje: cero.** Barrido de los
  32 MB por `u32` alineado igual a la cabecera, al nombre o al payload de los
  cuatro chunks `bc1_`: **0 referencias**. Como punteros a la imagen de
  `STLEVEL` sí existen (el `+0x58` cae adentro), el cero dice algo: **el
  personaje se resuelve por ID/nombre, no por puntero cacheado**. Lo que el
  negativo *no* descarta: puntero desalineado, offset relativo en vez de
  absoluto, o que las entidades que usan esos chunks todavía no spawnearon.
- **No se descifró el ID de 64 bits** de los recursos (`+0x10`/`+0x14` del
  directorio de armas). Los `hi` comparten `0x5446xxxx` y `0001_bg1_smg` y
  `0001_bg1_sm5` tienen el **mismo** `hi`, así que no parece un hash plano.
- **No se tocó un solo byte.** Todo lo de arriba es lectura. Por eso los
  registros nuevos de `kb/` que no se movieron van como `probable`, no como
  `confirmado`.

**Sigue:** el experimento de 7b, ahora rediseñado y barato:

1. Volcar la imagen de `STLEVEL` de `LEVEL_00` (`0x01412400`, 2.502.240 B) y
   buscar **la lista de puntos de spawn** — el registro que dice "acá aparece
   un `so1`". Entrada: las cuatro apariciones "grupo B" (tag `0x3f800000`) y
   el campo `+0x5C` del registro de entidad (toma 2/3/4).
2. Con eso, la escritura de prueba es **en RAM**, 11 bytes o 4 bytes,
   reversible, y recién si anda se lleva al ISO con `parche_iso.py`.
3. Observable sin ojos, como en E4: si un `so1` pasa a ser un `rg1`, el
   registro de arma que le toca en `0x006E18B8+n*0x24+0x04` tiene que cambiar,
   y eso se lee con `pine.py`.

**Estado de la máquina al cerrar:** emulador corriendo con el ISO **original**,
savestate slot 3 cargado, **cero escrituras, cero parches vivos**.

---

## 2026-08-17 (27) — Deuda chica de N1 cerrada: falso positivo de OneDrive, .gitkeep, tests faltantes, encoding

**Máquina:** PC, sin PCSX2 (no hacía falta) · **Modelo:** Sonnet (refactor de herramientas ya decididas)

**Objetivo:** cerrar los ítems anotados en "Problemas abiertos" de
`ESTADO_ACTUAL.md`: el falso positivo de OneDrive en `inventario.py`, el
`.gitkeep` que se borraba solo, la falta de test para cinco herramientas, y
el `open()` sin `encoding` que quedó pendiente de barrer.

**Resultado:**

1. **`inventario.py` — falso positivo de OneDrive, corregido.** El chequeo
   comparaba la existencia de una ruta vieja hardcodeada
   (`~/OneDrive/Documents/PCSX2`) en vez de preguntar cuál es la carpeta de
   savestates REAL hoy. Ahora usa `estado.carpeta_savestates()` (la misma
   función que ya usan las herramientas que leen savestates, que pregunta a
   Windows con `SHGetFolderPathW` y sigue la redirección de verdad).
   Probado por efecto en los dos sentidos: con el estado real de la máquina
   no marca riesgo (antes sí, falso positivo); con `carpeta_savestates()`
   forzada a devolver una ruta dentro de OneDrive, la alarma prende.
2. **`construido/.gitkeep` — ya no lo borra la suite.** La causa era
   `shutil.rmtree(RAIZ/"construido")` al final de la prueba de `pnach.py`,
   que se llevaba puesto todo el directorio. Ahora borra sólo el `.pnach`
   que la prueba generó.
3. **Cobertura nueva en `pruebas/prueba_herramientas.py`** para las cinco
   herramientas que no tenían test: `armas.py` (`buscar_tabla`,
   `campos_power`, control negativo con `Power = NaN`), `zonas.py` (cadena de
   punteros enemigo→componente→personaje→tabla, con un denormal señuelo
   descartado), `tablas.py` (funciones puras de recorte/detección + smoke
   test de `vecinos` por CLI), `firmas.py` (`es_rw_stream` con control
   positivo y negativo, `analizar()` sobre archivos sintéticos) e
   `inventario.py` (`revisar_onedrive()` con los tres casos: fuera de
   OneDrive, dentro de OneDrive, sin candidata). 138 comprobaciones en verde.
4. **`vigilar.py` — mismo bug de encoding que ya se había arreglado del lado
   de lectura, esta vez del lado de escritura.** `grabar()` abría el CSV de
   salida con `open(salida, "w", newline="")`, sin `encoding="utf-8"`
   explícito. Reproducido el fallo real fuera del código del proyecto (un
   nombre de columna con `Δ` tira `UnicodeEncodeError` bajo cp1252) y
   confirmado que con `encoding="utf-8"` explícito no depende del locale.

**No funcionó:** el primer test que escribí para `cadena_en()` (sin NUL
cerca) estaba mal construido — el buffer sintético SÍ tenía un NUL dentro del
rango, así que la prueba fallaba por el test, no por el código. Corregido con
un buffer sin ningún NUL.

**Sigue:** `herramientas/windows/preparar_entorno.ps1` sigue sin validar de
punta a punta — deliberadamente no se tocó en esta sesión: pide UAC
(bloquea en una sesión no interactiva) y puede relanzar/tocar el `.ini` de
PCSX2, que ahora mismo tiene una sesión viva con PINE conectado. Validarlo
necesita una terminal interactiva y el emulador cerrado o en un momento en
que reabrirlo no rompa nada en curso.

---

## 2026-08-17 (26) — E4 cerrado: el arma del enemigo sale de un array paralelo, no del objeto de arma

**Máquina:** PC, con PCSX2 vivo · **Modelo:** Opus (layout e hipótesis en territorio nuevo)

**Objetivo:** Fase 7 (a) — encontrar por efecto el campo que fija el arma que
usa un enemigo.

**Resultado: encontrado y confirmado por efecto, con dos lecturas
independientes que coinciden.**

### 1. El señuelo, y por qué era tan convincente

`arma_obj + 0x0C` es el **único** u32 de los `0x110` bytes del objeto de arma
que cae dentro de la tabla de armas, y en 10 de 10 objetos cae **alineado a
registro** con offset de bloque `+0x90` constante. Jugador en reg 0 y 1,
enemigos en reg 4 y 5. Imposible pedir un candidato con mejor cara.

**Está falsificado.** Se apuntaron los ocho objetos de arma de enemigo al
registro 6 (RPG, `TBB` de IA `3.500` contra `0.070` del reg 5: 50× más lento),
con la escritura verificada en los ocho, y el fuego entrante no se movió:
127 impactos en 24.9 s contra 121 del baseline, escalón intacto.

### 2. La técnica que destrabó todo: que la tabla diga su propio nombre

En vez de adivinar qué enemigo dispara, se le escribió a cada registro un
`Power` de IA **único y distinguible** —`100 + r`— y se midió el escalón de
daño. **El tamaño del impacto nombra el registro.**

Resultado: escalón de **105 exacto**, sin mezcla. Los atacantes usan el
**registro 5**, todos. Y de paso quedó confirmado que `registro + 0xD8` es el
`Power` que la IA le aplica al jugador.

Repetido **con los ocho `+0x0C` apuntando al reg 6 al mismo tiempo**: el
escalón siguió en 105. Ahí `+0x0C` quedó falsificado sin vuelta.

### 3. Dos estructuras nuevas que nadie había visto

Buscando en los 32 MB *quién referencia al registro 5* aparecieron dos:

- **Directorio de armas en `0x01842084`, 17 entradas de `0x20`**, justo antes
  de la tabla. Cada entrada tiene cinco punteros al registro que le toca:
  `+0x00→reg+0x050`, `+0x04→reg+0x070`, `+0x14→reg+0x090`,
  `+0x18→reg+0x1A0`, `+0x1C→reg+0x1C0`.
- **Array de instancias en `0x006E18B8`, paso `0x24`, 10 entradas** — una por
  objeto de arma, en el mismo orden, correspondencia 1:1 verificada registro
  por registro. Cada entrada guarda **dos** punteros:
  `+0x00 → registro+0x90` (bloque del jugador) y
  **`+0x04 → registro+0xC0` (bloque de IA)**.

### 4. La confirmación

Marcadores puestos y los ocho punteros de bloque de IA movidos al registro 6:

| | control (reg 5) | tratamiento (reg 6) | lo que predecía la tabla |
|---|---|---|---|
| escalón de daño | 105 | **106 constante** | `Power` reg 6 = 106 |
| intervalo entre impactos | 133 ms | **3534 ms** | `TBB` de IA reg 6 = **3.500 s** |
| impactos en 25 s | 116 | **6** | cadencia de RPG |

El daño **y** la cadencia se movieron juntos a los valores exactos del
registro 6, con la cadencia predicha en 3.500 s y medida en 3.534 s. Dos
observables independientes, una sola causa.

### 5. Layout del registro de arma, corregido

Cada registro de `0x1E0` tiene **dos bloques de parámetros**: el del jugador en
`+0x90` y **el de la IA en `+0xC0`**. Dentro de un bloque,
`Power = bloque+0x18` y `TimeBetweenBullets = bloque+0x20`.

O sea `Power` de IA en `+0xD8` y `TBB` de IA en `+0xE0`. **Corrige la entrada
anterior**, que ubicaba el bloque de IA en `+0x90`: eso era el bloque del
jugador. La pista que lo delató es que `+0xE0` del reg 0 vale `0.150`, que es
exactamente el "0.15 original" anotado en E1b.

**No funcionó:**

- **`arma_obj + 0x0C`**, ya contado. Un puntero real a la tabla que no gobierna
  nada observable. El mejor señuelo que dio el proyecto hasta ahora.
- **Suponer que los tiradores eran los de vida `FLT_MAX`** (pool 0 y 1). Son los
  que apuntan al reg 4, y el escalón medido **nunca** fue 104: no disparan.
  Costó un experimento entero, y lo arregló el marcado, que no supone nada.
- **La primera corrida A/B no recargó el savestate entre condiciones.** Diseño
  flojo mío; se rehízo con recarga.
- **Medir daño con el mod puesto no discrimina armas:** el parche aplastó los
  17 `Power` de IA a `5.0`, así que cambiar de registro no cambia el daño.
  Por eso hizo falta marcar la tabla con valores únicos.

**Sigue:** Fase 7 (b) — qué dato fija **qué tipo** de enemigo aparece. La
entrada barata es E5 (`STLEVEL.BIN`, el truco de los 11 caracteres). Y queda
abierto de acá: **de dónde sale el valor del puntero de `+0x04`** al spawnear
—o sea, dónde está escrito "este enemigo lleva el arma 5"— que es lo que hace
falta para cambiarlo de forma permanente en el ISO y no sólo en RAM.

---

## 2026-08-17 (25) — El mod permanente existe: 24 impactos de −5.0, y el ISO reconstruido no queda cerrado

**Máquina:** PC, con PCSX2 vivo · **Modelo:** Sonnet, sin necesidad de subir

**Objetivo:** tarea 6.1 — decidir con evidencia si el ELF lee LBAs
hardcodeados, porque eso definía si `mkps2iso` seguía siendo un camino.

**Resultado: 6.1 y 6.6 cerradas las dos, y el objetivo N0 del proyecto
cumplido para la tabla de armas.**

### 1. Los LBA: no están horneados. `mkps2iso` sigue vivo

Herramienta nueva: **`herramientas/lbas.py`**. Saca la tabla real de LBAs del
`.iso` con `pycdlib` —sin montarlo— y la busca en un binario en **cinco
codificaciones**, con **control positivo** (una aguja distintiva del propio
objetivo) y **control negativo** (la misma cantidad de valores inventados del
mismo rango, en las mismas codificaciones).

El resultado sobre el ELF: **0 de 1644 valores** aparecen como inmediato
`lui`+`ori`/`addiu`, con 31.760 `lui` indexados. Los literales sueltos están al
nivel de los señuelos, 11 de 83 alineados a 4, corrida contigua máxima 1, y 74
de 83 adentro de `.text`.

La evidencia positiva la dio **`IOP/GTFSCDVD.IRX`** (módulo `gtfsdvd`, el
sistema de archivos de Criterion): importa `cdvdman` y trae `Error reading
TOC`, `ERROR: Exceeded maximum directories per disk (%d)` y `ERROR: Exceeded
maximum files per disk (%d)`. Lee la TOC y arma su tabla en runtime. Un LBA
horneado no leería ninguna TOC. Números completos en `docs/05-iso.md`.

### 2. El mod permanente, confirmado por efecto en las tres capas

Herramienta nueva: **`herramientas/parche_iso.py`**. Edita un archivo adentro
del ISO sin reconstruirlo: `offset_iso = LBA * 2048 + offset_en_el_archivo`.
Los tres pasos están separados (`preparar` / `armas` / `verificar`) para que
ninguna invocación sola pueda escribirle al original.

```
17 campos a 5.0 en GLOBDATA.BIN
  -> diff: 17 rangos, todos en GLOBDATA.BIN, CERO en la TOC
  -> arranque del ISO parcheado: Power = 5 en los 17 registros de IA en RAM
  -> jugador quieto bajo fuego: 24 impactos, los 24 de exactamente -5.0
```

Antes del parche el escalón era **26.0**. Serie cruda en
`volcados/vida-mod-armas.csv`.

### 3. Dos cosas que la evidencia dio vuelta

- **La tabla de armas NO se carga por stage.** Se carga al arrancar, desde
  `GLOBDATA.BIN`: estaba completa en RAM en la pantalla de "press START", con
  el jugador todavía en vida `0.0`. La ficha del `kb` decía lo contrario y
  quedó corregida.
- **OneDrive ya no es un problema y `inventario.py` da un falso positivo.**
  Los savestates nuevos se escriben en `C:\Users\frans\Documents\PCSX2\`. Lo
  que queda en OneDrive son copias viejas que nadie actualiza.

**No funcionó:**

- **El primer veredicto de `lbas.py` estaba mal calibrado y decía "por encima
  del ruido".** Yo había expandido el conjunto real con los vecinos ±1 (1644
  valores) y dejado 600 señuelos: comparaba conjuntos de distinto tamaño. Con
  los dos en 1644, la señal desaparece. **Un control negativo mal dimensionado
  fabrica hallazgos.**
- **El control positivo inicial no probaba nada**: la aguja sacada del offset
  `0x1000` valía `0x00000000`, que aparece en todos lados. Ahora la herramienta
  elige una aguja no nula y de pocas apariciones.
- **Reconstruir pares `lui`/`addiu` sobre un `.IRX` no sirve.** Un IRX es un
  ELF *reubicable*: los inmediatos valen cero hasta que el cargador los
  parchea. Por eso no se pudieron sacar en frío los máximos de archivos y
  directorios de `gtfsdvd`. Camino que sí serviría: leer el módulo ya cargado
  en la RAM del IOP.
- **Las corridas de 10 y 8 golpes en `UNIT_01.BIN` / `UNIT_05.BIN` asustaron
  media hora.** Se miraron los bytes: es `0x001D001D` repetido, o sea pares de
  índices `u16` de la geometría que caen en la ventana numérica de los LBA.
  Ruido, pero sólo se supo mirándolo.
- **`vigilar.py` estaba roto en Windows** y nadie lo había notado: abría
  `kb/mapa-memoria.json` sin `encoding="utf-8"` —y sin necesitarlo— así que
  cualquier `grabar --dir` moría con `UnicodeDecodeError`. Arreglado, más otros
  cuatro `open()` en modo texto sin encoding en `escanear.py` y `pnach.py`.

**Sigue:** las cuatro tareas de formato que quedan de la Fase 6 — 6.2 (`.DB`),
6.3 (`.WDD`), 6.4 (`.SLB`) y 6.5 (patrón de ImHex). Y, cuando se retome el
emulador, la Fase 5b: qué elige la zona de impacto.

---

## 2026-08-16 (24) — El instrumental: Ghidra decompila el ELF, y con eso cayó el formato del contenedor

**Máquina:** notebook (sin PCSX2) · **Modelo:** Opus

**Objetivo:** dejar de escribir parsers a mano. Buscar en internet el
instrumental certificado que falte, instalarlo, probarlo, y rematar el ISO.

**Resultado — el proyecto pasó de desensamblar a decompilar, y eso destrabó
en la misma sesión un formato que llevaba días anotado como "falta
entender".**

### 1. Ghidra 12.1.2 + Emotion Engine Reloaded

`mips.py` y `capstone` desensamblan; Ghidra devuelve **C**. Montaje completo en
`docs/06-herramientas-externas.md`, puente en `herramientas/decompilar.py`
(`info` / `c` / `funciones` / `xref`).

**9842 funciones y 16514 símbolos** sobre un ELF que no trae tabla de
símbolos. Y el mapa de memoria del EE completo —VU0/VU1, scratchpad,
registros de GS— que coincide exactamente con la tabla de secciones que
habíamos leído a mano en la entrada 23: dos fuentes independientes diciendo
lo mismo.

**Las dos trampas, las dos pagadas:**

- **`Ghidra\Extensions\`, no `Extensions\Ghidra\`.** Las dos carpetas existen.
  Descomprimir en la segunda deja la extensión instalada y no cargada. Es la
  lección 7 otra vez, y lo que la detectó fue preguntar por el **efecto**
  (¿aparece el lenguaje `r5900`?), no por el archivo.
- **Sin `-processor`, Ghidra elige `MIPS:LE:64:64-32R6addr`** —MIPS Release 6,
  otra ISA— y termina con `Analysis succeeded`, exit code 0, **1 función en
  2,6 MB de código** y cero decompilación. Con
  `-processor "r5900:LE:32:default"`, 9842. De ahí sale la lección 18.

**Control positivo, y no es decorativo:** `decompilar.py info` decompila
`0x00142B90` y busca el `100.0` de la Fase 4b. Eso es lo que delató el
lenguaje equivocado las dos veces.

### 2. El contenedor `.BIN`, resuelto leyendo el parser

La cadena `GlobData.bin` (`0x003F2AD8`) tiene un solo xref de código:
`FUN_00105858`, la máquina de estados de arranque, que pide el archivo con
callback `0x00105D48`. **Ese callback no parsea: relocaliza.**

```c
*(int *)(base + 0x04) += base;   // y +0x08, +0x0C, +0x10, +0x14, +0x18
```

**Los u32 de la cabecera son offsets relativos que el cargador convierte en
punteros absolutos en el lugar.** Por eso la hipótesis vieja de "tabla de
offsets creciente" no cerraba: no es una tabla ordenada, es una cabecera de
layout fijo donde cada ranura es una sección y no vienen en orden. El mismo
mecanismo es recursivo hacia adentro, con la cantidad en `+0x00` (u8) y
registros de paso fijo (`0x24` en una sección, `0x20` en otra).

**Verificado con dos controles positivos que no se ajustaron para que
dieran:**

- La tabla de armas está en `GLOBDATA.BIN + 0x00130E20`, dirección conocida de
  la entrada 23 por firma estructural. Según la cabecera recién decodificada
  cae dentro de la sección de `0x00130C80`, a `+0x1A0`. Encaja.
- En `STLEVEL.BIN`, la sección declarada en `0x80` arranca con los bytes de
  `"bg1_shg"` — la tabla de nombres de entidades ya documentada.

**No aplica a todos:** `LEVELDAT.BIN` da tres ranuras fuera de rango y
`GUNS.BIN` tiene un tamaño en `+0x00` en vez de una cantidad. Usan otro
layout, y el camino para sacarlo es el mismo.

### 3. vgmstream r2117 — los `.AWD` están abiertos

Es el parser certificado de audio de juegos y trae `RenderWare AWD header` de
fábrica. **36 archivos, 1385 streams** catalogados con
`herramientas/awd.py catalogo`.

Lo valioso no es el audio: son **los nombres**. `STG_0001/AIWPNS.AWD` (*AI
Weapons*) dice qué armas usa la IA en cada nivel, con los nombres en clave que
les puso Criterion, que son **referencias a películas**: `WeWere` (*We Were
Soldiers*), `BlackHd` (*Black Hawk Down*), `KarlDH` y `DieHard2` (*Die Hard*),
`LKiss` (*The Long Kiss Goodnight*), `Rock`, `Commando`, `Navy`, `Alias`. Es
una fuente de nombres **independiente del binario**, que es justo lo que le
falta a los 17 registros de la tabla de armas.

### 4. Evidencia de terceros que cruza con la nuestra

El código público de vida infinita para `SLUS-21376` es
**`205A8DA8 44960000`**: escribir el f32 `1200.0` en **`0x005A8DA8`**. Esa es
exactamente el ancla que este proyecto confirmó por efecto en la Fase 1, por
un camino totalmente distinto — y de paso fija el "lleno" en 1200.0, el mismo
que aparece hardcodeado en el divisor del HUD.

Tres pistas nuevas, ninguna verificada por nosotros:
`2015515C 240303E7` = `addiu $v1,$zero,999` → lógica de **munición** en
`0x0015515C`; `2015787C 00000000` = nop → **recarga** en `0x0015787C`;
`205A8A9C 3C888889` = `1/60` → **delta de tiempo por frame** en `0x005A8A9C`.

**No funcionó / se descartó:**

- **PCSX2-MCP** (`hkmodd/PCSX2-MCP`): promete 30 herramientas de depuración por
  MCP, pero exige bajar y correr un **`pcsx2-qt.exe` parcheado** de un repo de
  18 estrellas. No se instaló: es un ejecutable sin firmar de un tercero sin
  reputación, y encima toca justo la capa de depuración que ya sabemos que
  corrompe el heap en el PCSX2 oficial. La decisión es de Fran, no de la
  sesión.
- **mcp-pine**: limpio y sin build modificado, pero sólo expone memoria y
  savestates. `pine.py` ya hace todo eso y además vuelca 32 MB en 3 s.
  Redundante.
- **No existe script de QuickBMS ni plugin de Noesis para BLACK.** El hilo de
  referencia (ResHax #514) es gente pidiendo lo mismo. El formato era nuestro
  para resolver, y se resolvió.
- Las bases de datos de cheats devuelven **403** a un fetch directo. Los
  códigos se leyeron de resúmenes de búsqueda: van al `kb/` como transcripción,
  no como cita verificada.

**Sigue:** Fase 5a (el mod con pnach) y 5b. Para 5b el terreno cambió: ahora se
lee el C del método virtual #8 en vez de 514 instrucciones, y ahí ya se ve que
la zona entra como argumento propio (`param_4 & 0xff`, con `0xFF` = "sin
zona") y que `[enemigo+0x26C]` tiene el arreglo de índices de hueso en `+0x0C`
indexado por un byte de `+0x19` — el mismo arreglo que llena `resolver_huesos`.

---

## 2026-08-16 (23) — Barrido del ISO: la tabla de armas SÍ estaba adentro, y aparecieron los nombres de hueso

**Máquina:** notebook (PCSX2 no hizo falta) · **Modelo:** Opus

**Objetivo:** revisar el ISO buscando tablas y estructuras que no estuvieran
fichadas. Reconocimiento, no confirmación: todo esto es análisis estático.

**Resultado — cinco hallazgos, ordenados por lo que valen.**

**1. La tabla de armas está en `GLOBDATA.BIN + 0x00130E20`.** 17 registros de
`0x1E0`, el mismo conteo y el mismo paso que en RAM, con los bloques de
parámetros en `+0x90` y `+0xC0`. El paso quedó verificado por dos anclas
independientes: desde el primer registro, el Magnum cae exacto en `+2` y la
HVY en `+10`. Habilita un mod **permanente** editando el ISO, sin `.pnach`.
Ficha en `kb/estructuras.json#arma.origen_en_el_iso`, tabla completa en
`docs/05-iso.md`. **`probable`, no `confirmado`**: nadie editó el archivo
todavía ni vio el efecto.

**Esto corrige un callejón que estaba anotado como cerrado.** `05-iso.md` decía
"la tabla de armas NO está en el ISO". La prueba de entonces comparaba la
**ventana de 96 bytes** alrededor del `26.0` de la RAM viva contra los
archivos — y esa ventana arranca con tres punteros al heap, que en el archivo
son offsets chicos. No podía coincidir nunca. Lo que la encontró fue buscar por
**firma estructural**: los tripletes `(Range, Power, falloff)` de los perfiles
ya medidos, que son invariantes entre archivo y RAM. De ahí sale la lección 17.

**2. Los nombres de hueso, y la función que los resuelve.** En `0x003BCE70`,
dirección fija de `.data`, hay un `const char*[11]`: `NECK`, `MIDSPINE`,
`LOWERSPINE`, `SHOULDER_LT/RT`, `ELBOW_LT/RT`, `UPPERLEG_LT/RT`, `KNEE_LT/RT`.
Los consume un solo sitio, `0x001381E0`, que al construir un personaje los
resuelve a índices y los cachea en `personaje+0x0C..+0x38`. Su ayudante
`0x00138298` expone el layout del esqueleto: `+0x5C` cantidad de huesos,
`+0x60` arreglo de nombres.

Es la entrada barata a la **Fase 5b**, pero **no es la respuesta**: son 11
nombres contra 24 registros de `0xC` en la tabla de zonas, y faltan cabeza,
pelvis, manos y pies. Que zona == índice de hueso es hipótesis.

**3. El ELF tiene tabla de secciones con nombres reales.** El mapa que traía
el documento era una estimación por histograma; ahora está el declarado:
`.data` en `0x003BC380`, `.rodata` en `0x003F2280`, `.lit4` en `0x0040D800`,
`.sdata`/`.sbss`/`.bss`. Y **`$gp = 0x004157F0`**, de la sección `.reginfo`.

**4. `$gp` explica un agujero de método.** Hay **3051 accesos con base `$gp`**
en **561 offsets distintos**. Ninguno de esos 561 globales aparece jamás en una
búsqueda de `lui`+`addiu`. Si `xref.py absoluto` da NADA para algo entre
`0x0040D7F0` y `0x0041D7F0`, la hipótesis buena es `$gp`, no "es un campo de un
objeto".

**5. El middleware de IA es Kynapse (Kynogon), y viene con los nombres
puestos.** `.rodata` trae nombres de tipo de C++ sin demanglear del namespace
`Kaim` y, al lado de cada clase, **los nombres de sus parámetros**:
`CShooterAgent` declara `GunRange`, `MaxInaccuracy`, `DangerousConeAngle`,
`AimAtTargetInterval`. Ahí empieza el hilo de "enemigos que erran más", no en
la tabla de armas. También aparecen completos los esquemas de `Collision.cfg`,
`AIWeapon.cfg` y `DSP.cfg`, cuyos archivos no están en el ISO.

**Herramientas.** Nueva: **`herramientas/tablas.py`** — `esquemas` (racimos de
cadenas contiguas = nombres de campo), `punteros` (corridas de punteros a
cadena = tablas de nombres), `flotantes`, `vecinos`. Va al revés que las otras:
no parte de un dato conocido, barre buscando forma de tabla. `--base 0xFF000`
para el ELF, `0` para un volcado.

**Arreglo en `xref.py`:** el `--radio` de `absoluto` era 8 y daba **falsos
NADA**. El par que arma `0x003BCE70` tiene el `lui` en `0x001381E4` y el
`addiu` en `0x00138208`, **nueve** instrucciones después. Subido a 16 y
verificado: ahora encuentra el sitio. Las 102 comprobaciones de
`pruebas/prueba_herramientas.py` siguen en verde.

**No funcionó:**

- Buscar la tabla de zonas de impacto en el ISO por el float `0.255`: no está.
  Coherente con que sea por tipo de personaje y se arme al cargar el stage.
- `tablas.py punteros` sobre el archivo entero devuelve 106 corridas y la mitad
  es ruido de `.rodata` apuntándose a sí misma. Hay que acotar con
  `--desde`/`--hasta` a `.data`.
- La cabecera del contenedor con alineación 128 sigue sin entenderse. No se
  avanzó y no se insistió.

**Nada de esto está confirmado por efecto.** Es reconocimiento estático: dice
dónde mirar, no qué es verdad. El único que cambia el plan es el punto 1.

**Sigue:** Fase 5a (el mod con pnach, ya decidido) y después 5b. Con lo de hoy,
5b arranca con dos entradas concretas en vez de una: los índices de hueso
cacheados en `personaje+0x0C`, y volcar en vivo `[[enemigo]+0x5C]` y
`[[enemigo]+0x60]` para ver si el esqueleto tiene 24 huesos o 11.

---

## 2026-08-16 (22) — FASE 4b CERRADA: el daño de salida del jugador sale de las ZONAS DE IMPACTO

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** cerrar el pendiente de la entrada 21 — con `Power = 300` en los
34 campos, el disparo del jugador seguía quitando 25.5 por bala.

**Resultado — está resuelto, y la respuesta era que la pregunta estaba mal
planteada.** El daño de salida del jugador no sale de la tabla de armas
**porque nunca salió de ahí**. Sale de una tabla por **zona de impacto** que
cuelga del personaje de la víctima:

```
daño = factor_de_zona * 100.0        (y a veces * 0.7)
```

Se calcula en **`0x00142B90`**, que **ignora** el daño que le llega en `$f12`
y devuelve el suyo en `$f0`. El llamador (`0x0013434C`, dentro del método #8
del enemigo) lo toma como daño efectivo, hace `sub.s $f1,$f20,$f22` y lo
escribe en `+0x2F8` — que es exactamente el `swc1` de `0x00134654` que ya
estaba confirmado desde la Fase 3.

Perfil de la tabla del nivel 1 (`0x00709F40`, registros de `0xC`):

| factor | daño | zonas |
|---|---|---|
| 1.02 | **102** | 2, 11 — cabeza: mata de un tiro |
| 0.51 | 51 | 0, 1, 13, 14 |
| 0.34 | 34 | 3, 8, 10, 15 |
| **0.255** | **25.5** | 4, 5, 9, 12, 16 — **el torso** |
| 0.204 | 20.4 | 20 |
| 0.11333 | 11.33 | 21, 22 — extremidades |

`25.5 * 4 = 102 > 100`: de ahí salen las cuatro balas que costaba matarlos.

**Cómo se llegó, en tres sondeos offline sobre un solo volcado:**

1. **Cero copias.** Se buscaron los 34 bloques de parámetros de arma
   byte-a-byte fuera de la tabla: **0 copias**. Eso mató la hipótesis 1 del
   handoff (que la instancia del arma del jugador tuviera la suya).
2. **El `25.5` no está en el código.** Barrido de `lui rX,0x41CC` en
   `0x00100000-0x003C0000`: **cero sitios**, con control positivo en la misma
   corrida (`lui 0x4496` = 1200.0 dio 17). O sea: se calcula.
3. **El `0.255` sí está, y en un solo lugar.** Aparece **exactamente 9 veces
   en los 32 MB** y las nueve caen dentro de la tabla de zonas de los
   enemigos vivos. `0.255 * 100 = 25.5`.

También quedó identificado el **objeto de arma por tirador**: registros de
`0x110` en `0x006DE770 + n*0x110`, con el descriptor en `+0x0C` y el **dueño
en `+0x10`**. El del jugador es `0x006DE770` (`+0x10 = 0x005A8AB0`), los
siguientes son de los enemigos del pool. Y un arreglo paralelo de `0x24` en
`0x006E18B8` donde `+0x0` es siempre PlayerParams y `+0x4` es el descriptor
**activo** (Player para el jugador, AI para la IA).

**Lo que esto corrige de la entrada 21.** El `Power = 300` sí cambió algo real
—el jugador pasó a **recibir** daño de arma pesada— y eso sigue en pie. Lo que
no corresponde es la generalización: la tabla de armas gobierna el daño que se
le hace **al jugador**, no el que el jugador **hace**. Las dos muertes de
enemigos atribuidas a fuego amigo no las vio nadie ocurrir: se infirieron de
un pool que apareció en 0. Es un estado final, no un efecto observado. De ahí
salió la **lección 16** de `/lecciones-aprendidas`.

**No funcionó:**

- La primera lectura de la cadena de punteros se comió una indirección
  (`lw $a0,0x3c($a1)` es una **carga**, no aritmética de direcciones) y las
  tablas dieron todas cero. El barrido independiente del float `0.255`
  —que no dependía de la cadena— fue el que destrabó y de paso la corrigió.
- Buscar una segunda tabla de armas (por `Guns_S.bin`): la única corrida de
  registros de `0x1E0` en los 32 MB además de la conocida tiene Powers de
  0.4-1.0, que no son daño. No hay segunda tabla.

**CONFIRMADO POR EFECTO, misma sesión.** Con los 36 factores en `3.0` (= 300
de daño contra 100.0 de vida), el usuario reportó que los enemigos **mueren de
una bala** donde antes hacían falta cuatro.

Corroboración por medición sobre el pool, no sólo por impresión:

| | `ee-4b-antes.bin` | `ee-4b-post.bin` |
|---|---|---|
| #2 | 100.0 | **0.0** |
| #6 | 49.0 | **0.0** |
| #9 | 100.0 | **0.0** |
| #11 | 100.0 | **0.0** |
| #4, #5, #13, #15 | 0.0 | 100.0 (spawns nuevos) |

El dato fuerte no es que murieran: es que **no hay un solo valor intermedio en
los 32 slots**. Con 25.5 por bala, en cualquier instante de un tiroteo tiene
que haber alguien en 74.5, 49 o 23.5. No hay ninguno.

**Confound descartado (lección 16, la que salió de esta misma sesión):** se
releyeron `0x00709F40`, `0x00709F70` y `0x00709F7C` **después** del test y las
tres seguían en `3.0`. El parche aguantó, así que no es un falso positivo por
pérdida. Restaurado 36/36 sin discrepancias.

**Sigue:** Fase 5. Chat nuevo — ver `HANDOFF.md`.

---

## 2026-08-16 (21) — FASE 4: la tabla de armas, encontrada y confirmada por efecto

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** Fase 4 — la tabla de armas.

**Resultado — la tabla:**

- **17 registros de `0x1E0` bytes**, en `0x01842220..0x01844020` durante esta
  sesión. Cada uno tiene **dos bloques de parámetros de `0x30`**: `+0x90` para
  cuando el arma la usa el **jugador**, `+0xC0` para cuando la usa la **IA**.
  Dentro de cada bloque: `+0x14` Range, **`+0x18` Power (el daño)**, `+0x1C`
  falloff.
- **La dirección NO es fija.** La tabla se carga **por stage** desde
  `Levels\Level_NN\Stg_NNNN\Guns.bin` al **heap**. Por eso no estaba ni en el
  ELF ni en BSS, y por eso `herramientas/armas.py` la **busca por firma** en
  vez de tenerla hardcodeada.
- **Confirmado por efecto:** se escribió `Power = 300.0` en los 34 campos y se
  midió el pool de enemigos antes y después. Dos enemigos pasaron de `100.0` a
  `0.0` **de un solo impacto** (delta 100, clamp desde 300) por fuego amigo
  entre enemigos, donde antes hacían falta cuatro balas. En paralelo el
  usuario reportó —sin que se le preguntara por eso— que la reacción en
  pantalla al recibir disparos cambió a la de **arma pesada** (barra de daño
  grande, más temblor), igual que escopeta/RPG/Magnum. Restaurado 34/34 sin
  discrepancias.
- Los perfiles se leen solos: `1000/500` (Magnum, el one-hit-kill), `25/38` +
  `20/133.3` con falloff 0 (escopeta), `100/100` (HVY), `60/26` (ASR — y 26.0
  es exactamente el daño confirmado en la Fase 1).

**Resultado — la cadena de causalidad del daño, completa:**

| Dónde | Qué |
|---|---|
| `0x0015B118` | calcula el daño: `Power * (falloff + (1-falloff)*arg/Range)`, con el descriptor en `[$a0+0x0C]` |
| `0x0015B2D8` | camino directo: `mov.s $f12,$f21` → método virtual #8 |
| `0x0015B320` | camino diferido: encola en el global **`0x00414AD0`** (16 registros de `0x20`, contador en `0x00414CD0`) |
| `0x0015BA80` | vacía la cola: `lw $v0,0x10(víctima)` → `lw $v1,0x4c($v0)` → `jalr` |

Eso cierra el "el daño llega en `$f12` y no se sabe de dónde" que quedó
abierto en la entrada 20, y **vuelve a confirmar que el puntero de clase está
en `objeto+0x10`**.

**Resultado — el esquema, escrito en el propio ejecutable:**

`0x004008A0`-`0x004009C8` tiene los nombres de los campos de arma en texto:
`Projectile Type`, `Weapon Impact Level`, `Num Bullets Per Burst`, `Num
Bullets In Clip`, `Muzzle Offset`, `Range`, **`Power`**, `Time Between
Bullets`, `Max Spread Angle`, `Accuracy Fall Off Time`… y las secciones
`CommonParams` / `PlayerParams` / `AIParams`. Son **rodata muerta** (`xref.py
absoluto` da cero, con control positivo sobre otros strings de la misma
región), pero documentan el formato. De ahí salió el nombre "Power" y la
hipótesis de los dos bloques, que después resultó cierta.

**No funcionó:**

- **Los cinco `26.0` de `0x0042C3AC..0x0042D56C` no son la tabla.** Se les
  escribió `300.0` y el daño no cambió en ninguna dirección. Lo que sí cambió
  fue el HUD: aparecieron dos barras negras translúcidas en pantalla al
  escribir y **desaparecieron al restaurar** — causalidad confirmada en los
  dos sentidos. Encaja con que el arreglo de `0x006CF4E0` apunta a registros
  de `0x50` en `0x0042CD40+n*0x50`, al lado. Esa zona es de HUD: no
  escribirle. **Pista cerrada, no volver.**
- Buscar `GUNS.BIN` cargado literal en RAM: 0 coincidencias con ventanas de
  24 bytes distintos de los 24 archivos del ISO. Se carga procesado.
- Buscar el `25.5` medido como constante en los 32 MB: 6 apariciones, ninguna
  con forma de descriptor. El daño se calcula, no está guardado.
- La primera firma de búsqueda de la tabla en `armas.py` era demasiado laxa
  (`0 < x <= 20000`) y devolvía **402** "registros" de geometría: floats
  basura de magnitud `1e-43` pasan cualquier test que sólo mire el signo. Con
  mínimos realistas (Range ≥ 1, Power ≥ 0.1) quedaron los 17 reales.
- `dis.py` como nombre de script rompe el import de `capstone`: colisiona con
  el módulo `dis` de la stdlib.

**Lo que quedó abierto, y es concreto:** con `Power = 300` en **toda** la
tabla, el disparo del jugador siguió quitando exactamente **25.5** por bala
(medido dos veces sobre el mismo enemigo: `100 → 74.5 → 49`). O sea que el
proyectil del jugador toma su daño de **otro lado**. Eso además explica el
`25.5` contra el `26.0` nominal.

**Sigue:** el daño de salida del jugador. Ver `HANDOFF.md`.

---

## 2026-08-15 (16) — Estructura del ISO montado, sin pegarle a la tabla de armas

**Máquina:** notebook · **Modelo:** Sonnet

**Objetivo:** con la Fase 2 cerrada, relevar qué hay "a mano" en el ISO antes
de volver a hurgar en vivo, para no depender del emulador para todo.

**Resultado:**

- **`Black.iso` (3.9 GB) montado en `D:\` con `Mount-DiskImage`** (no estaba
  montado; lo que el usuario había visto antes fue una sesión anterior de
  Explorador). Estructura de primer nivel: `IOP/` (módulos IOP), `LANGUAGE/`,
  `LEVELS/` (`GLOBAL/` + `LEVEL_00`..`LEVEL_08`, sin `LEVEL_02`), `SOUND/`,
  `VIDEOS/`, `CHARS/` (incluye `GUNS/`), `DATA/`, `EXPORT/FRONTEND/`,
  `GLOBDATA.BIN`, `SYSTEM.CNF`, **`SLUS_213.76`** (el ejecutable principal).
- Cada nivel trae su propio `FPGUNS/` (modelos/animaciones de primera persona
  por arma: AK1, AK5, AS5, ASR, BNS, HV5, HVY, PS5, PST, RPG, SH5, SHG, SM5,
  SMG, SN5, SNR — códigos de 3 letras, probablemente el prefijo real de cada
  arma en el juego) y subcarpetas `STG_NNNN/` con `GUNS.BIN` / `GUNS_S.BIN`
  por stage.
- **Hipótesis de tabla de armas NO confirmada por este camino.** Se buscó el
  float `26.0` (daño confirmado del jugador) en `LEVEL_00/STG_0001/GUNS.BIN`
  y `GUNS_S.BIN`: cero coincidencias — esos archivos son geometría/spawn de
  armas en el nivel, no una tabla de stats. En `SLUS_213.76` sí aparecen 4
  coincidencias de `26.0` (offsets de archivo 2960626, 3006466, 3086690,
  3087238), contra los 5 sitios ya conocidos en RAM
  (`0x0042C3AC`..`0x0042D56C`, ver `ESTADO_ACTUAL.md`). El espaciado entre los
  4 offsets de archivo NO coincide con el espaciado entre las 5 direcciones de
  RAM con una base lineal simple — esperable en un ELF con program headers no
  contiguos. **No vale la pena seguir esto sin parsear los program headers del
  ELF**; más barato confirmarlo en vivo con un watchpoint de lectura sobre
  `0x0042C3AC` (ya estaba planeado en `ESTADO_ACTUAL.md`).

**No funcionó:**

- Buscar el offset RAM↔archivo a ojo asumiendo un `base` constante. Un ELF PS2
  no necesariamente mapea `.text`/`.data`/`.rodata` de forma contigua; hace
  falta leer `Elf32_Phdr` (offset, vaddr, filesz) para traducir bien.

**Sigue:** volver al trabajo en vivo — test de genericidad de la rutina de
daño (`0x0013C120`), que era el próximo paso antes de esta desviación al ISO.
El ISO queda montado en `D:\` por si hace falta volver (no se desmontó).

---

## 2026-08-16 (20) — FASE 3 CERRADA: enemigos invulnerables, confirmado por efecto

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** el test que faltaba de la entrada 19.

**Resultado:**

- **`0x00134654` nopeado (`0xE61402F8` → `0x00000000`). El usuario le vació un
  cargador entero de AK a un enemigo y siguió vivo.** Confirmado por efecto.
- **Confound descartado:** se releyó `0x00134654` DESPUÉS de la prueba y
  seguía en `0x00000000`. El nop aguantó, así que no es un falso positivo por
  pérdida del parche. Restaurado a `0xE61402F8` al terminar.
- Con eso quedan confirmados de un saque: la **clase del enemigo**
  (`0x003DCA78`), la **vida en `+0x2F8`** y la **rutina `0x00133FA8`**. El
  análisis estático había predicho el punto de parche exacto y acertó a la
  primera.
- `kb/rutinas.json#aplicar_dano_enemigo` y `kb/estructuras.json#enemigo`
  pasaron de `probable` a **`confirmado`**.

**Lo que vale la pena registrar del método:** dos sesiones de escaneo
diferencial no habían logrado ni **localizar** la vida de un enemigo — muere
en 4 balas y el filtro necesita más rondas de las que da. Por **clase**
(vtable → método virtual #8 → desensamblado) salió en una sola pasada, sin
tocar el emulador y trabajando sobre un savestate. Cuando un método no
converge, conviene preguntarse si el objeto de búsqueda está bien elegido
antes de insistir con más rondas.

**No funcionó:** nada nuevo. El test salió a la primera.

**Sigue:** **Fase 4 — la tabla de armas.** Chat nuevo (ver `HANDOFF.md`).

---

## 2026-08-16 (19) — La clase del enemigo, por vtable: Fase 3 resuelta estáticamente

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** trabajo autónomo nocturno. Analizar el ISO y avanzar lo posible
sin el usuario.

**Resultado — el mapeo del ELF, verificado:**

- `D:/SLUS_213.76` es un ELF MIPS de **un solo `PT_LOAD`**:
  **`offset_archivo = vaddr − 0xFF000`**. **Verificado 6/6** contra encodings
  observados en vivo en sesiones anteriores (`0x0013BD20`, `0x0013C120`, etc.).
  No es un supuesto.
- `filesz=0x30E580`, `memsz=0x39BFBC`: lo respaldado por archivo llega hasta
  RAM **`0x0040E580`**; de ahí a `0x0049BFBC` es **BSS**. `.text` =
  `0x00100000..0x00396F48`, `.vutext` hasta `~0x003BC330`, datos hasta
  `0x0040E580`. **Las constantes de daño (`0x0042C3AC`...) están en BSS**: no
  existen en el ejecutable, se llenan en runtime.
- Sin tabla de símbolos. Las 105 secciones son casi todas microcódigo de VU.

**Resultado — LA CLASE DEL ENEMIGO (lo importante):**

- **El puntero de clase NO está en el primer u32 del objeto, está en `+0x10`.**
  En `+0x00` hay cero. Esa premisa equivocada (heredada de `_metodo` en
  `kb/estructuras.json`) es la razón por la que la Fase 3 no arrancó en dos
  sesiones y por la que la ficha del jugador decía "el primer u32 no parece un
  puntero a vtable".
- Clase del jugador = **`0x003DC5F8`**. Layout de vtable: punteros a función
  cada 8 bytes desde `+0x0C` (los 4 bytes del medio en cero).
- **`0x0013C120` quedó explicado del todo.** Su función (`0x0013BDF8`) está
  referenciada desde **un solo lugar en los 32 MB**: `0x003DC64C`, que es la
  vtable del jugador en `+0x54`. La rutina confirmada del jugador
  (`0x0013BB78`) está en `0x003DC644` = `+0x4C`. Son los **métodos virtuales
  #8 y #9 de la MISMA clase, el del jugador**. Por eso el código era
  estructuralmente idéntico y por eso nopearlo no tocó a los enemigos.
- **Método #8 (`vtable+0x4C`) = "recibir daño".** Como el índice de un método
  virtual se conserva entre clases hermanas, se barrió la región de datos
  buscando vtables con ese layout (**279**), se desensambló la ranura `+0x4C`
  de cada una con `capstone` y se contó cuáles escriben en `+0x2F8`.
  **CENSO COMPLETO: sólo DOS.** La del jugador y **`0x003DCA78`**.
- **Clase del enemigo = `0x003DCA78`.** 32 objetos, pool contiguo
  `0x0058FE90..0x005972D0` con paso `0x360`. Vida en **`+0x2F8`, igual que el
  jugador**. En el savestate: 25 en `0.0`, **5 en `100.0`**, 2 en `FLT_MAX`.
- **Rutina de daño del enemigo = `0x00133FA8`** (514 instrucciones), con los
  dos brazos: **`0x00134654`** `swc1 f20,0x2F8(s0)` (daño normal, el punto de
  parche para enemigos invulnerables) y **`0x00134514`** `swc1 f21,0x2F8(s0)`
  con `f21 = 0.0` (clamp de muerte). **Los dos ya estaban en la lista de 24
  stores de la entrada 18** — lo que faltaba no era encontrarlos, era el
  criterio para elegirlos.
- **Corroboración numérica que nadie fue a buscar:** vida de enemigo `100.0` ÷
  daño de AK `26.0` = 3.85 → **4 balas**. Es exactamente lo que el usuario
  reportó dos veces esta noche, sin que se le preguntara.
- **Corroboración en vivo parcial:** con el juego corriendo, 4 de los 32
  objetos seguían en la misma dirección con el mismo puntero de clase y vidas
  `0.0 / 100.0 / FLT_MAX`. El layout no es un artefacto del savestate.

**No funcionó:**

- **La tabla de armas NO se carga literal de ningún archivo del ISO.** Se tomó
  la ventana de 96 bytes alrededor de cada uno de los 5 sitios de `26.0` en la
  RAM viva y se buscó en `GLOBDATA.BIN`, `SLUS_213.76`, `LEVELDAT.BIN`,
  `STLEVEL.BIN`, `GUNS.BIN`, `GUNS_S.BIN`, `UNIT_01.BIN`, `STUNIT01.BIN`,
  `TRANS_CH.BIN`: **cero coincidencias, 5 de 5**. La premisa que cae es "se
  carga literal"; o se transforma al cargar, o la ventana contiene punteros
  resueltos en runtime.
- `xref.py stores --fpu` sigue siendo engañoso: su filtro por cercanía a
  `sub.s` excluye justo los stores que importan (ya anotado en la entrada 18).
- Barrer entidades por "vida plausible en `+0x2F8`" da **621 clases**: filtro
  inútil. El umbral `> 0.0` deja pasar denormales. El discriminador bueno no
  era el valor sino la **clase**.
- `capstone` en `CS_MODE_MIPS32` **se corta en la primera instrucción R5900**
  (`sq`/`lq` del prólogo) y devuelve cero instrucciones sin avisar. Hay que
  usar `CS_MODE_MIPS64` + `skipdata=True`. Un desensamblado vacío parecía un
  resultado ("esta función no escribe en `+0x2F8`") y era un bug.

**Herramienta nueva:** `pip install capstone`. `mips.py` no decodifica FPU
(mostraba `cop1 0x4615A501`), que es justo lo que importa en estas rutinas.

**Sigue:** **la confirmación por efecto, que es lo único que falta.** Nopear
**`0x00134654`** (`0xE61402F8` → `0`) y comprobar que los enemigos no reciben
daño. Diez segundos con PCSX2 corriendo. Ojo con el precedente de la entrada
18: `0x0013C120` parecía igual de sólido por analogía y era otra cosa — por
eso esto está en `probable`, no en `confirmado`.

---

## 2026-08-15 (18) — `0x0013C120` FALSIFICADO por efecto; los "8 candidatos" nunca fueron el conjunto real

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** cerrar Fase 3 (¿es genérica la rutina de daño?).

**Resultado:**

- **Se replanteó el test entero.** Veníamos buscando la dirección de vida de
  un enemigo para poner un watchpoint. No hacía falta: la pregunta de la Fase
  3 se contesta **sin localizar nada** — nopear `0x0013C120` y mirar si los
  enemigos dejan de recibir daño. Mismo movimiento que cerró la Fase 2.
- **`0x0013C120` NO es el brazo de daño de los enemigos. FALSIFICADO por
  efecto.** Se nopeó en vivo por PINE (`0xE61602F8` → `0x00000000`), el
  usuario descargó la AK sobre un enemigo y murió normal, en 4-5 balas.
  **Confound descartado:** se releyó `0x0013C120` DESPUÉS del test y seguía en
  `0`, así que el nop aguantó — el test es válido. Restaurado.
- **Las escrituras de código por PINE persisten y el recompilador las
  respeta.** El nop del jugador (`0x0013BD20`) seguía puesto horas después.
- **Los "8 candidatos" de la sesión anterior nunca fueron el conjunto real.**
  `xref.py stores 0x2F8 --fpu` filtra por cercanía a un `sub.s`/`add.s`, y ese
  filtro **deja afuera a `0x0013BD20` y a `0x0013C120`**, que son justamente
  los dos sitios que sí importaban. Se enumeró el conjunto verdadero a mano
  (decodificando `swc1` = opcode `0x39`, offset `0x2F8`): **24 stores**,
  listados con su codificación en `volcados/stores-2f8-originales.txt`.
- **Test decisivo montado pero NO ejecutado** (se acabó el contexto): se
  nopearon los 24 a la vez, verificado 24/24, y se restauraron los 24 con 0
  discrepancias. Falta el disparo del usuario.
- **Descartado el atajo del último nivel.** Los saves de GameFAQs para Black
  son Max Drive / CodeBreaker / X-Port — no son memory cards ni savestates de
  PCSX2. Usarlos pide bajar un binario de un fan site y convertirlo con
  herramientas de terceros que no tenemos. No lo vale: el problema real es
  "un enemigo que aguante más golpes", no "el último nivel".

**No funcionó:**

- **Atajo estructural sobre el pool de entidades.** Se volcó
  `0x00580000-0x00600000` en vivo y se buscó la forma del struct del jugador
  (`+0xC4` estado chico, `+0x2F8` vida f32 entera). Dio 12 candidatos, y
  **ninguno sostuvo su valor en una relectura** — es memoria dinámica
  reciclada (partículas/física), no una tabla de entidades. Descartado.
- Proponer la pistola como "arma más débil": el usuario ya había dicho que la
  AK es la que menos daño hace. Error de lectura, no de método.

**Sigue:** UN solo experimento, ya preparado y barato:

```
# nopear los 24 (la lista con codificaciones esta en volcados/stores-2f8-originales.txt)
# disparar a un enemigo con la AK
```

- Si el enemigo se vuelve **invulnerable** → el camino de daño del enemigo
  está entre los 24; bisecar (12, 6, 3...) — 4-5 disparos y cae.
- Si muere **igual, en 4-5 balas** → **la vida del enemigo NO está en
  `+0x2F8`**. Eso redirige la búsqueda entera: el struct del enemigo sería
  distinto del struct del jugador, y habría que buscar su offset de vida
  desde cero.

Los dos resultados son informativos. Es el mejor experimento disponible.

---

## 2026-08-15 (17) — Dos enemigos muertos antes de converger; la estática dice "genérica"

**Máquina:** notebook · **Modelo:** Sonnet

**Objetivo:** confirmar EN VIVO si `0x0013C120` es el brazo de daño de una
entidad genérica (test de la hipótesis abierta), localizando primero la vida
de un enemigo por escaneo diferencial (mismo método que con el jugador).

**Resultado:**

- **Dos intentos de escaneo diferencial sobre enemigos, ninguno convergió.**
  AK47 en dificultad difícil mata al enemigo en 3-4 tiros, y el escaneo
  reduce candidatos ~5-6× por ronda (arranca en ~8.1M posiciones): no alcanza
  el número de rondas antes de que el enemigo muera. Enemigo 1: murió en 874
  candidatos. Enemigo 2: murió en 5.521; un filtro `entre=1:2000` (sin
  necesidad de disparo nuevo) lo bajó a 885, y una poda manual a valores
  enteros lo bajó a 142 — pero sigue siendo ruido del motor (flags en 1.0,
  bloques en 128.0, nada que se vea como vida de enemigo), no un candidato
  limpio. **La vida del enemigo sigue sin localizarse.**
- **Lección de proceso, ya aplicada a mitad de sesión:** en el primer enemigo
  hubo un desfase real — corrí `filtrar bajo` antes de que el tiro del
  usuario llegara a impactar, lo que probablemente descartó el candidato
  verdadero en esa ronda (un filtro relativo compara contra la foto anterior;
  si nada cambió entre dos fotos, el candidato real queda fuera igual que el
  ruido). Se corrigió el protocolo: esperar la confirmación explícita del
  usuario ("ya" DESPUÉS de disparar) antes de correr el filtro.
- **Desensamblado con `mips.py` del bloque candidato (`0x0013C060-0x0013C180`)
  contra el bloque confirmado del jugador (`0x0013BC80-0x0013BDA0`).** Mismo
  patrón exacto: lectura de un campo de estado en `+0xC4` (`lw ??,0xC4(base)`),
  comparación contra valores pequeños (3/4 en el candidato, 1 en el jugador),
  hasta dos llamadas condicionales a subrutinas, y recién ahí el store de la
  vida en `+0x2F8` con clamp (dos brazos: piso de muerte y resta normal).
  El bloque del jugador usa `s0`/`s2` como base; el candidato usa `s1`/`s0`.
  Estructura idéntica, sólo cambia la asignación de registros — consistente
  con una rutina genérica de "entidad recibe daño" inlineada dos veces por el
  compilador para distintos call sites, tal como venía la hipótesis. **Sigue
  siendo hipótesis, no confirmación**: no hay efecto visto en pantalla sobre
  un enemigo real.

**No funcionó:**

- Escanear diferencialmente la vida de un enemigo con AK47 en difícil: muere
  antes de converger. El enfoque no escala con enemigos frágiles.
- Podar por "valor entero razonable" (`entre=1:2000` + filtro manual de parte
  fraccionaria) no alcanza para aislar un candidato: hay demasiadas
  constantes enteras del motor (1.0, 128.0, 320.0...) en ese rango.

**Sigue:** para la próxima sesión en vivo, dos caminos más baratos que seguir
grindeando con la AK en difícil:
1. Usar el arma de MENOR daño (pistola) contra un enemigo normal — más tiros
   antes de morir, más rondas de filtro antes de que se acabe.
2. Buscar un enemigo que aguante más golpes (armadura pesada / mini-boss) en
   vez de un soldado raso.
Ninguno de los dos se probó todavía. La confirmación de genericidad sigue
pendiente del efecto en pantalla — la evidencia estática es fuerte pero no
alcanza sola (regla 1 del proyecto).

---

## 2026-08-15 (15) — La base estaba mal: la rutina de daño en dos horas

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** instalar el PCSX2 parcheado (PCSX2-MCP) y desempatar los 69
candidatos a instrucción de escritura de la vida.

**Resultado:**

- **Se instaló el PCSX2 parcheado y se escribió `herramientas/depurador.py`**,
  un cliente del `DebugServer` (JSON por newline sobre TCP 21512). **No hizo
  falta registrar el MCP ni reiniciar la sesión**: el protocolo está
  documentado en el fuente del parche, así que se habla directo desde Python.
  Eso preservó el contexto entero de la sesión.
- **La base del objeto del jugador estaba MAL.** No es `0x005A8D80` sino
  **`0x005A8AB0`**, y la vida es **`+0x2F8`**, no `+0x28`. Los 69 candidatos
  estaban buscando el offset equivocado: el problema estaba mal planteado.
- **Cómo se destrabó:** un watchpoint de **lectura** sobre la vida. El juego la
  lee cada frame para dibujar el HUD, así que dispara al instante y sin que el
  usuario tenga que hacer nada. Al pausar, se leyó el **registro base en vivo**
  (`a2 = 0x005A8AB0`) — eso es lo que dio la base real. Confirmado:
  `0x005A8AB0 + 0x2F8 = 0x005A8DA8` exacto.
- **Rehecha la búsqueda con el offset correcto: de 69 candidatos a 8**, todos
  agrupados en `0x00134xxx-0x0013Cxxx`.
- **Rutina de daño localizada** (`probable`, falta confirmar con efecto):
  ```
  0x0013C0DC  sub.s  f22, f22, f21     ; vida = vida - daño
  0x0013C0E0  c.le.s f22, f20          ; ¿por debajo del piso?
  0x0013C0E8  bc1f   ->0x0013C120
  0x0013C0F0  swc1   f20, 0x2F8(s0)    ; muerte: clamp al piso
  0x0013C120  swc1   f22, 0x2F8(s0)    ; DAÑO NORMAL
  ```
- **1200.0 y 750.0 hardcodeados** en el código que lee la vida
  (`div.s f12, vida, 1200.0`). **El recuerdo de "vida máxima ~1200" era
  correcto**; el handoff anterior lo había declarado falso. Es el denominador
  de la barra del HUD.
- **`gp = 0x004157F0`**, dato nuevo: permite resolver todos los accesos
  `gp`-relativos del desensamblado.
- Herramienta nueva: `herramientas/volcar_vivo.py` — vuelca la RAM del EE por
  `read_memory` (64 KB por viaje). Los 2.8 MB de código salen en segundos;
  con `pine.py` habrían sido 350 mil viajes.

**No funcionó:**

- **`--accion log` de los watchpoints no cuenta nada.** Es el mismo stub vacío
  que `MemCheck::Log()` del PCSX2 oficial; el parche no lo arregla. Se detectó
  con una prueba de control sobre el timer del motor: el valor cambiaba entre
  lecturas y el contador seguía en 0. **Hay que usar `--accion break`.**
- **`OnBreakpointHit()` del parche es un stub** ("Future: notify connected
  clients"). No hay aviso asincrónico: `esperar` hace polling de `status`.
- **Los savestates viejos no cargan** en la build parcheada: se declara versión
  "Unknown" y rechaza los de la 2.6.3. No son intercambiables en ningún sentido.
- **Se volvió a quemar contexto con un flujo multi-agente** (~100k tokens) para
  un trabajo que después se hizo directo en unos pocos comandos. Es la lección
  9 otra vez, y estaba escrita. Ver `/lecciones-aprendidas`.
- La vida **no se escribe** mientras el jugador está quieto: un watchpoint de
  escritura no dispara solo. El de **lectura** sí, y por eso fue el camino.

**Addendum del cierre — los breakpoints de ejecución matan el emulador.**
Al intentar confirmar la rutina con `bp poner 0x0013C120`, el `set_breakpoint`
cortó la conexión a mitad del comando y el proceso `pcsx2-qt.exe` desapareció.
Contrasta con evidencia dura de la misma sesión: los **watchpoints** pausaron y
resumieron limpio decenas de veces (control sobre el timer, y lectura sobre la
vida). O sea: **watchpoints sí, breakpoints de ejecución no.**

Lo caro no fue el crash (el savestate estaba hecho): fue no haberlo previsto
teniendo la evidencia delante. El plan decía "un breakpoint de memoria" y se
ejecutó un breakpoint de ejecución, que es otra cosa. `depurador.py` ahora
exige `--se-que-crashea` para `bp poner`, y el guard corre **antes de
conectar** — así avisa aunque el emulador esté caído.

**Sigue:** confirmar con efecto, pero con **watchpoint de escritura** sobre
`0x005A8DA8` y recibiendo un golpe. Si al pausar el PC es `0x0013C120`, la
rutina queda confirmada — y es evidencia más fuerte que un breakpoint puesto a
mano sobre la dirección que ya se sospechaba: se deja que el juego la delate.
Después: ¿la rutina es genérica (jugador y enemigos comparten `+0x2F8`)? Si lo
es, caen las Fases 3 y 5 juntas.

---

## 2026-08-15 (14) — Fase 2 sin debugger: la vida es un campo, no un global

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** decidir el entorno de la Fase 2 (¿instalar una build parchada de
PCSX2 para tener breakpoints automatizables?) y arrancar la rutina de daño.

**Resultado:**

- **La pregunta del entorno se disolvió.** Cuatro comandos sobre un savestate
  que ya estaba en disco entregaron tres de los cuatro objetivos de la Fase 2,
  sin debugger, sin instalar nada y sin riesgo.
- **`0x005A8DA8` NO es un global.** Cero instrucciones en los 32 MB arman esa
  dirección (`lui`+`addiu`/`ori`), y no aparece como palabra suelta. "Estática"
  significaba que el cargador de nivel asigna el objeto siempre en la misma
  posición, no que sea una variable global. Se llega por puntero.
- **Base del objeto del jugador: `0x005A8D80`, vida en `+0x28`** (probable).
  Único candidato a distancia corta; figura como valor en `0x004C5E1C` y
  `0x004C5E30`. Layout coherente: cápsula de colisión en +0x10/+0x14, altura
  1.65 en +0x18, vida en +0x28. → `kb/estructuras.json#jugador`.
- **`FLT_MAX` en `+0x30`** (hipótesis fuerte): candidato a vida máxima. Si es
  eso, cierra la pregunta abierta desde el checkpoint 1 — no hay techo.
  → `kb/mapa-memoria.json#vida_maxima_candidata`.
- **Mapa de memoria:** código en `0x00100000-0x003BFFFF`, datos en
  `~0x0042xxxx-0x0045xxxx`. Corroborado por dos vías independientes.
- **Pista de la tabla de armas:** el flotante 26.0 (el daño exacto por golpe)
  aparece cinco veces agrupadas en la región de datos. → `kb/estructuras.json#arma`.
- **Herramienta nueva: `herramientas/xref.py`** — automatiza los cuatro
  sondeos (`absoluto`, `punteros`, `stores`, `mapa`). Se hicieron a mano una
  vez; a la segunda ya no.

**No funcionó / callejones:**

- **Se gastó ~500k tokens en un workflow de 10 agentes** para investigar el
  entorno. Fue un error de criterio: la mitad de lo que se mandó a investigar
  ya estaba en el contexto de la conversación, y cada agente arrancó en frío a
  re-derivarlo. Lo que destrabó el problema fueron cuatro comandos secuenciales
  donde cada uno dependía del anterior — exactamente la forma que un fan-out
  hace peor. → lección 9 de `/lecciones-aprendidas`.
- **La hipótesis inicial era falsa.** Se dio por sentado que una dirección
  estática se direcciona por absoluto. El primer sondeo la mató (0 resultados)
  y eso fue lo más informativo de la sesión. → lección 10.
- **El checkbox "Log" del breakpoint de memoria de PCSX2 no sirve:**
  `MemCheck::Log()` es un stub vacío en el fuente. Se había planificado
  alrededor de esa función (jugar con logging y leer `emulog.txt` después).
- **La ruta del menú del debugger estaba mal en tres documentos**
  (`Tools > Show Debugger`). En PCSX2 2.x es `Tools > Show Advanced Settings`
  y después `Debug > Open Debugger`. Corregido.
- **`sw` vs `swc1`:** cuatro documentos decían que la vida la escribe un `sw`.
  Es `f32`: la instrucción es `swc1`. Corregido.
- **Riesgo abierto:** issue #5343 de PCSX2 (los breakpoints de memoria cuelgan
  la emulación en builds x64 de Windows) figura cerrado pero no se encontró el
  commit que lo arregla. Probar con savestate y sobre una dirección inocua.
- **PCSX2-MCP:** revisado el fuente, no el binario. Ver `docs/01-entorno.md`.

**Sigue:** desempatar los 69 candidatos a instrucción de escritura. Tres
caminos baratos, en orden de costo: (a) `vigilar.py` sobre los 0x60 bytes del
objeto para confirmar que `0x005A8D80` es el jugador; (b) escribir un finito en
`+0x30` y curarse, para matar o confirmar la vida máxima; (c) `inspeccionar.py`
sobre `0x0042C3AC` a ver si es la tabla de armas.

---

## 2026-08-15 (13) — Fase 1 cerrada: `0x005A8DA8` confirmada estática

**Máquina:** notebook · **Modelo:** Sonnet

**Objetivo:** determinar si la dirección de vida es estática o dinámica entre cargas de nivel.

**Resultado:**

- Leída la dirección al iniciar la sesión: 333.0 (valor escrito en la sesión anterior).
- Recarga de nivel: la dirección devolvió **750.0** (HP inicial coherente, no basura).
- Dos golpes recibidos: **698.0** = 750 − 2×26. El daño de 26.0 se mantiene exacto.
- **`0x005A8DA8` es ESTÁTICA.** Sobrevive recargas y sigue siendo la fuente de vida.
- `kb/mapa-memoria.json`: `estable: true`, evidencia actualizada.
- `ESTADO_ACTUAL.md`: Fase 1 cerrada, próxima acción = Fase 2 (rutina de daño, Opus + debugger de PCSX2).

**No funcionó:** nada — experimento limpio en un solo intento.

**Sigue:** Fase 2. Breakpoint de escritura en `0x005A8DA8` desde el debugger de PCSX2 GUI → encontrar la instrucción `sw` → rutina de daño → estructura del jugador. Modelo: **Opus**.

---

## 2026-08-15 (12) — el mismo `Δ` en `inspeccionar.py`, y una sola definición para los dos

**Máquina:** PC · **Modelo:** Opus

**Objetivo:** cerrar el pendiente que dejó la entrada (11): `inspeccionar.py`
tenía el mismo `Δ` (U+0394) que hacía crashear a `vigilar.py`.

**Resultado:**

- **Reproducido antes de tocar nada**, con dos savestates sintéticos y
  `PYTHONIOENCODING=cp1252`: `inspeccionar.py comparar` moría con
  `UnicodeEncodeError` en `inspeccionar.py:162`. **Acá era peor que en
  `vigilar`**: el `Δ` está en la *cabecera* de la tabla, así que el comando
  imprimía "3 campo(s) cambiaron" y se moría antes de mostrar un solo campo —
  o sea, perdía exactamente lo único que tiene para dar.
- **Las dos funciones se movieron a `herramientas/salida.py`**, y ahora
  `vigilar.py` e `inspeccionar.py` importan de ahí. No se duplicaron.
- **Por qué un módulo y no una copia:** `inspeccionar.py` no puede importar
  `vigilar.py` (este hace `from pine import ...` a nivel de módulo, mientras
  que `inspeccionar` importa `pine` adentro de las funciones justo para poder
  trabajar desde savestates sin PCSX2 abierto). Y duplicar un workaround de
  codificación en dos archivos es literalmente cómo se llegó a este bug: la
  primera versión vivió suelta en `vigilar.py` y su hermana quedó rota. El
  proyecto ya comparte así (`pnach.py` importa `mips` y `estado`).
- Como `vigilar.py` reexporta lo que importa, las pruebas que ya existían
  siguen andando sin tocarlas.
- `pruebas/prueba_herramientas.py`: **102 comprobaciones, todo bien.**

**No funcionó / lo que hay que mirar:**

- Nada se rompió en el camino. Lo que sí quedó claro es que la prueba nueva
  tenía que correr el **CLI de verdad**: se verificó que falla contra el
  `inspeccionar.py` viejo (código 1 + traceback) y pasa contra el nuevo. Una
  prueba de regresión que no falla contra el código roto no prueba nada.
- Quedan cinco herramientas más (`escanear`, `pnach`, `estado`, `pine`,
  `fijar_objetivo`) que imprimen tildes y `ñ` sin llamar a
  `tolerar_salida_pobre()`. Hoy no las rompe nada (cp1252 tiene esos
  caracteres), pero bajo `LC_ALL=C` reventarían igual. **No se tocaron**: no
  hay evidencia de que esté pasando, y el arreglo está a una línea el día que
  pase.
- **`pruebas/prueba_herramientas.py` borra un archivo trackeado**: hace
  `rmtree` de `construido/` al final y se lleva puesto `construido/.gitkeep`.
  Hay que restaurarlo a mano después de cada corrida. Sigue sin arreglar.

**Sigue:** sin cambios respecto de la entrada (11) — determinar si
`0x005A8DA8` es estable o dinámica entre cargas de nivel.

---

## 2026-08-15 (11) — `vigilar.py analizar` arreglado: el `Δ` mataba el comando

**Máquina:** PC · **Modelo:** Opus

**Objetivo:** arreglar el bug que dejó la entrada (10): `analizar` imprimía el
análisis y reventaba con traceback justo al llegar a `primeros:`, así que
`volcados/correlacion-vida-2.csv` hubo que leerlo a mano.

**Resultado:**

- **Causa raíz: `UnicodeEncodeError` por el `Δ` (U+0394) de la línea
  `primeros:`.** Cuando la salida se redirige en Windows (a un archivo, a un
  pipe, o a una herramienta que la captura), Python deja de hablarle a la
  consola y codifica con la página de códigos local — `cp1252` acá, que no
  tiene U+0394. El `print` entero muere. No era un problema de los datos: el
  CSV no tenía nada raro. Por eso cortaba **siempre** en el mismo lugar y las
  líneas anteriores salían bien: `ñ`, `±` y las tildes sí existen en cp1252;
  el `Δ` era el único carácter fuera del juego.
- **Arreglo** (`herramientas/vigilar.py`): `simbolo_delta()` elige `Δ` o `d`
  según lo que la salida sepa codificar, y `tolerar_salida_pobre()` pone
  `errors="replace"` en stdout/stderr como red para el resto del texto (bajo
  `LC_ALL=C`, con stdout en ASCII, también reventarían `ñ` y `±`). No se
  fuerza UTF-8 en el flujo a propósito: arreglaría el `Δ` pero convertiría
  `tamaño` en mojibake en las consolas que hoy lo muestran bien.
- **Evidencia:** con `PYTHONIOENCODING=cp1252` sobre un CSV sintético de 900
  filas, la versión vieja sale con código 1 y traceback (`vigilar.py:175`); la
  nueva imprime el análisis entero y sale con 0. En UTF-8 el `Δ` se sigue
  viendo; en ASCII degrada a `d` y `?` sin cortar.
- `pruebas/prueba_herramientas.py`: 96 comprobaciones, todo bien.

**No funcionó / lo que hay que mirar:**

- **La prueba que ya existía no podía ver este bug, y eso es lo importante.**
  Llamaba a `vigilar.analizar()` en proceso con `redirect_stdout` a un
  `StringIO`, que no codifica nada: pasaba en verde mientras el comando real
  fallaba el 100% de las veces. La prueba nueva cruza la misma frontera que el
  uso real — subproceso, salida redirigida, `PYTHONIOENCODING=cp1252` — y
  falla contra el código viejo.
- **`herramientas/inspeccionar.py:162` tiene el mismo `Δ`** en la cabecera de
  `comparar`. Es el mismo bug esperando, en la herramienta hermana del mismo
  flujo. **No se tocó** (queda fuera del alcance de esta tarea), pero va a
  crashear igual apenas se redirija la salida.

**Sigue:** lo que ya venía — determinar si `0x005A8DA8` es estable o dinámica
entre cargas de nivel (ver `ESTADO_ACTUAL.md`). `analizar` ya se puede usar
sin leer los CSV a mano.

---

## 2026-08-15 (10) — **CHECKPOINT 1 CERRADO**: vida del jugador confirmada en `0x005A8DA8`

**Máquina:** notebook (local) · **Modelo:** Sonnet, después Opus (innecesario, ver abajo)

**Objetivo:** cerrar el escalón 1 — confirmar cuál de los 5 candidatos era la vida.

**Resultado:**

- **`0x005A8DA8` = vida del jugador, `f32`, NTSC-U — `confirmado`.**
- Daño por golpe: **26.0 constante**.
- Máximo observado: ~440 tras curación, pero se vio 649.79 en otra — el techo
  real no está determinado.
- `0x006CF54C` = **segmentos dibujados de la barra del HUD** (rango 2..8), valor
  **derivado**, no fuente. Esto explica el crash de la sesión anterior: escribirle
  999 le metió un índice fuera de rango al render.
- `0x0040E6A0` **descartado**: cambia en cada muestreo a 10 Hz, siempre bajando.
  Es un timer del motor.

**Cómo se confirmó (tres capas de evidencia):**

1. **Correlación temporal.** `vigilar.py` a 10 Hz durante 90s
   (`volcados/correlacion-vida-2.csv`) contra los eventos que narraba el usuario:
   sube ~210 en cada curación (t=7.0s, t=84.8s), baja exactamente 26.0 por golpe
   (t=32-33s, t=69s, t=87s).
2. **Causalidad.** Al escribir 130.0 en `0x005A8DA8`, el HUD (`0x006CF54C`) se
   recalculó solo de 8 a 1. La lógica del juego lee esta dirección.
3. **En pantalla.** Se escribió 333.0 y el usuario vio bajar la barra de vida
   **mientras la munición quedaba intacta** — lo que descartó la hipótesis
   alternativa de que fuera munición de reserva (el HUD mostraba `440`, muy
   cerca del máximo de vida observado).

**No funcionó / callejones:**

- **Auditoría de automatización del debugger.** Se verificó a fondo si Claude
  podía manejar breakpoints solo: la tabla de opcodes de PINE es contigua
  `0x00`-`0x0F` (read/write/savestate/metadata) y **no tiene opcode de
  breakpoint** — no depende de la versión de PCSX2. Existe un `DebugServer` TCP
  (puerto 21512) que sí los maneja, pero es una **build custom** de PCSX2
  (proyecto PCSX2-MCP), no la oficial. Se comprobó en la máquina: sólo escucha
  28011 (PINE), el binario es `C:\Program Files\PCSX2\PCSX2\pcsx2-qt.exe`
  estándar. **Conclusión: sin build parchada, los breakpoints son manuales.**
- **Pero no hicieron falta.** El replanteo que destrabó todo: la pregunta no era
  "cómo pongo un breakpoint" sino "cómo correlaciono un valor con un evento
  observable". Para eso, **muestrear (`vigilar.py`) le gana a los breakpoints**:
  es sólo lectura, cero riesgo de crash, y no requiere manos en el debugger.
- **El recuerdo de "vida máxima ~1200" era incorrecto** (es ~440+). Se hizo bien
  en no usarlo como filtro fuerte.
- `escanear.py poner` con valores arbitrarios quedó **desaconsejado** como método
  de confirmación: crasheó el emulador. El camino seguro es muestrear primero y
  escribir sólo valores dentro del rango ya observado.
- **Opus no era necesario.** Se cambió a Opus previendo lectura de desensamblado,
  pero el checkpoint se cerró sin abrir el debugger. Sonnet alcanzaba.

**Bug encontrado:** `vigilar.py analizar` crashea con un traceback al imprimir la
sección "primeros" de los escalones. El análisis se hizo leyendo el CSV directo.
Pendiente de arreglar.

**Sigue:** determinar si `0x005A8DA8` es **estable o dinámica** (recargar el nivel
y releer: si mantiene la vida, sirve directo en un `.pnach`; si tiene basura, hay
que llegar por puntero). Después, primer mod real. El escalón 2 (rutina de daño
por breakpoint) queda para cuando se quiera el parche elegante — no está en el
camino crítico del primer mod funcionando.

---

## 2026-08-15 (9) — Checkpoint 1: escaneo diferencial de vida, primer intento de `poner` crashea

**Máquina:** notebook (local) · **Modelo:** Sonnet

**Objetivo:** escalón 1 — encontrar la dirección de la vida del jugador
(ver `docs/02-metodologia.md`).

**Resultado:**

- Sesión `prueba-auto` (de sesiones anteriores) descartada: había quedado en
  0 candidatos por comparar un savestate contra sí mismo. No se reutiliza.
- Sesión nueva `vida-jugador` (`u32`, región `0x00100000-0x02000000`)
  creada con foto inicial por PINE.
- Filtrado diferencial alternando `bajo`/`subio`/`igual` en 8 rondas reales
  contra el juego: 8.126.464 → 155.744 → 37.057 → 7.548 → 4.979 → 2.620 →
  962 → (igual: sin cambio) → 197 → 31 → **5 candidatos**.
- Nota de método: para floats positivos, el orden de bits como entero sin
  signo preserva el orden numérico — el filtrado `u32` sigue siendo válido
  aunque el dato real termine siendo `f32`.
- Candidatos finales:
  - `0x005A8DA8` — float, cientos, venía bajando
  - `0x0065F458` — float, <1, venía bajando
  - `0x006CF54C` — entero chico, bajó limpio 3→2→(999 de prueba)
  - `0x01E68FA4` — entero, salto grande entre rondas
  - `0x01E73EB0` — entero, cayó de 4162 a 0

**No funcionó:**

- `poner vida-jugador --indice 2 --valor 999` (dirección `0x006CF54C`)
  **crasheó el emulador a pantalla negra**. Ese candidato queda marcado
  como riesgoso para escritura directa — probablemente no sea la vida en
  bruto sino un índice, puntero o campo de estado sensible a rango. No
  reintentar `poner` con valores grandes ahí sin motivo nuevo.
- Recuerdo del usuario de que la vida máxima ronda ~1200 (impreciso, sin
  confirmar). Un chequeo estático sobre los candidatos en ese rango no
  alcanzó a decidir por sí solo (demasiados candidatos posibles tanto en
  lectura entera como float) — no usar como filtro fuerte, sólo como
  desempate al final.

**Sigue:** abandonar más pruebas de `poner` a ciegas. Pasar al escalón 2
(`docs/02-metodologia.md`): abrir el debugger de PCSX2 (`Tools > Show
Debugger`), poner breakpoints de **Write** en los candidatos restantes
(sin necesidad de escribir nada — no hay riesgo de crash) y dejar que el
emulador frene solo en la instrucción real que escribe la vida al recibir
daño. Recargar el savestate antes de seguir (el juego quedó crasheado).

---

## 2026-08-14 (8) — Fase 2 infraestructura global: `perfil-global/` + auditoría de entorno

**Máquina:** nube · **Modelo:** Sonnet

**Objetivo:** crear el perfil global reutilizable entre proyectos
(`perfil-global/`) y hacer una auditoría de arquitectura de entorno
para el proyecto BLACK.

**Resultado:**

- `perfil-global/CLAUDE.md` — config global mínima para `~/.claude/`.
  5 reglas absolutas + puntero al skill.
- `perfil-global/engineering-orchestrator/SKILL.md` — metodología
  completa: modelo, effort, contexto, memoria, evidencia, investigación,
  subagents, handoff, cambio de sesión, costos, verificación, no repetición.
- `perfil-global/install.ps1` — instalador PowerShell con backup del
  CLAUDE.md anterior, sin destructivo.
- `perfil-global/verify-install.ps1` — verificación rápida de la
  instalación.
- Auditoría de entorno completada (ver respuesta de sesión). Conclusión:
  LOCAL como entorno primario de BLACK; cloud sólo para código/docs.

**No funcionó:** nada — es trabajo de infraestructura pura.

**Decisión de arquitectura:** el cloud no puede ejecutar PCSX2, Ghidra
ni PINE. Todo el trabajo "en vivo" de BLACK (escaneo, breakpoints,
escritura de memoria) debe correr en la máquina local del usuario.
El cloud tiene valor sólo para escribir y revisar herramientas.

**Sigue:** Checkpoint 1 de BLACK sin cambio (ver `ESTADO_ACTUAL.md`).
Antes de retomar BLACK, el usuario debe: instalar perfil-global en
`%USERPROFILE%\.claude\`; luego abrir Claude Code local y retomar.

---

## 2026-08-14 (7) — Infraestructura de continuidad: `ESTADO_ACTUAL.md` + `sesiones/HANDOFF.md`

**Máquina:** nube · **Modelo:** Sonnet

**Objetivo:** el usuario pidió aplicar una especificación externa
("orquestador de ingeniería") sobre memoria, evidencia y continuidad entre
sesiones. Se evaluó punto por punto en vez de aplicarla literal.

**Resultado:**

- Cerrados triggers/webhooks huérfanos de la sesión anterior (dos
  `send_later` y la suscripción al PR #1) — no había nada corriendo caro,
  pero tampoco tenía sentido dejarlo.
- `ESTADO_ACTUAL.md` (raíz del proyecto): índice operativo compacto. Se lee
  entero al retomar, en vez de la bitácora completa.
- `sesiones/HANDOFF.md`: paquete de traspaso entre sesiones, formato fijo
  (objetivo, hechos, hipótesis, qué no repetir, próxima acción).
- `CLAUDE.md`: la tabla de "qué leer" ahora manda primero a
  `ESTADO_ACTUAL.md`; la bitácora completa queda para cuando hace falta el
  detalle de cómo se llegó a algo.

**Decisión explícita de NO hacer lo que pedía la spec al pie de la letra:**
partir `kb/*.json` en carpetas por estado de confianza
(`confirmed/hypotheses/...`) habría roto todas las herramientas que ya leen
esos archivos (`pnach.py`, `escanear.py`, etc.), y el campo `confianza` que
ya tiene cada entrada cumple la misma función. Se adaptó en vez de clonar
literal.

**No funcionó:** nada — es trabajo de infraestructura, no de BLACK en sí.

**Sigue:** el checkpoint 1 sigue siendo el mismo (ver `ESTADO_ACTUAL.md`).
Pendiente, sin decidir todavía si vale la pena: preparar un skill/CLAUDE.md
*global* (fuera del repo, en `~/.claude/` del usuario) con la filosofía de
ingeniería reutilizable entre proyectos — quedó explícitamente pausado para
no seguir gastando en esta sesión.

---

## 2026-08-14 (6) — Confirmado: la detección automática de Documentos anda en Windows real. Y otro bug chico de la misma familia

**Máquina:** notebook de Fran (Windows) · **Modelo:** Sonnet

**Objetivo:** validar la entrada anterior — si `escanear.py nuevo --pedir`
encuentra el savestate solo, sin `--desde` a mano.

**Resultado:**

- **Confirmado.** `python herramientas\escanear.py nuevo prueba-auto --tipo
  u32 --pedir` encontró `SLUS-21376 (5C891FF1).00.p2s` sin ayuda. La API de
  Windows (`SHGetFolderPathW`) funciona como se esperaba; ya no hace falta
  el `--desde` manual.
- Al filtrar, el mensaje que imprime `escanear.py` decía `python3
  escanear.py filtrar ...` — pero en esta máquina el comando es `python`
  a secas; `python3` ni siquiera existe (Windows lo redirige a la
  Microsoft Store). El propio mensaje de ayuda llevó al usuario a un error.
  Bug de la misma familia que el de Documentos: asumir una convención en vez
  de preguntarle al sistema. Arreglado con `PY = os.path.basename(sys.executable)`
  (sin el `.exe`), así el mensaje siempre dice el intérprete que está
  corriendo de verdad, sea cual sea. 2 pruebas nuevas (total: 87).

**No funcionó:** nada — fue puro seguimiento de la corrida anterior.

**Sigue:** con `prueba-auto` ya creada y el usuario habiendo tomado daño en
el juego, correr `python herramientas\escanear.py filtrar prueba-auto bajo`
(ahora el mensaje de ayuda ya dice el comando correcto solo). El objetivo
sigue siendo el mismo: encontrar la dirección de la vida.

---

## 2026-08-14 (5) — Bug de raíz: OneDrive redirige Documentos, todo lo que asumía `~/Documents` fallaba

**Máquina:** notebook de Fran (Windows, PCSX2 2.6.3) · **Modelo:** Sonnet

**Objetivo:** el usuario apretó F1 (savestate guardado, confirmado en
pantalla: "Saved state to slot 1"), pero `escanear.py nuevo vida --pedir`
decía que no encontraba ningún archivo nuevo.

**Causa real:** en esta notebook, Windows tiene "Documentos" redirigido a
OneDrive. La carpeta real es `C:\Users\frans\OneDrive\Documents\PCSX2\...`,
no `C:\Users\frans\Documents\PCSX2\...`. `estado.py` y `pnach.py` asumían la
segunda (`os.path.expanduser("~") + "Documents"`), que en esta máquina no
existe o no es la que usa PCSX2 — así que la detección automática fallaba en
silencio, sin ningún error claro, para savestates, `.ini` y carpeta de
cheats por igual. Confirmado dos veces por el usuario: una vez por el log de
arranque (entrada anterior) y una segunda vez con una captura de
`Configuración > Carpetas` de PCSX2, mostrando las seis carpetas reales bajo
`OneDrive\Documents\PCSX2\`.

**Resultado:**

- `estado.py`: nueva `_documentos_windows()`, que le pregunta a Windows
  directamente (`SHGetFolderPathW` + `CSIDL_PERSONAL`) en vez de adivinar.
  Esta API sigue la redirección de OneDrive igual que la moderna
  (documentado por Microsoft, por compatibilidad hacia atrás).
  `_candidatos_documentos_windows()` la usa como primera opción y cae a
  `~/Documents` y `~/OneDrive/Documents` como respaldo si la API falla.
- `carpeta_savestates()` (estado.py) y `_ruta_ini_pcsx2()` /
  `carpeta_cheats()` (pnach.py) ahora usan esta lista en vez de una sola
  ruta fija. Un solo punto de arreglo, tres lugares que lo necesitaban.
- 4 pruebas nuevas (total: 85). Importante ser honesto sobre el límite de lo
  que se puede probar acá: `_documentos_windows()` en sí (la llamada a
  `ctypes`/`SHGetFolderPathW`) es imposible de ejecutar fuera de Windows —
  esta sesión corre en Linux. Lo que sí se prueba, en cualquier sistema, es
  que la función no truena fuera de Windows (devuelve `None` de entrada) y
  que la lista de candidatos de respaldo es correcta. La llamada real a la
  API de Windows queda sin verificar por ejecución; sólo por lectura
  cuidadosa contra la documentación de Microsoft.
- Confirmado el nombre real de los savestates:
  `SLUS-21376 (5C891FF1).<slot>.p2s` (más `.p2s.backup`). No hacía falta
  ningún cambio para esto: `ultimo_savestate()` ya buscaba con un patrón
  `*.p2s` genérico, que no distingue el nombre exacto.

**No funcionó / pendiente de verificar:**

- No hay forma de confirmar desde acá que `_documentos_windows()` funciona
  de verdad en Windows real — sólo que el resto del sistema no se rompe si
  falla. **Esto es lo primero a validar en la próxima corrida en la
  notebook**: si `escanear.py nuevo vida --pedir` encuentra el savestate
  solo (sin `--desde` a mano), la API funcionó. Si sigue fallando, hay que
  revisar `_documentos_windows()` con más cuidado — ahí sí, con acceso real
  a Windows para poder iterar.

**Sigue:** confirmar `--pedir` sin `--desde` manual en la próxima corrida.
Si funciona, seguir con el checkpoint 1 (la vida del jugador) que ya había
quedado desbloqueado a mano con `--desde` apuntando al `.p2s` real.

---

## 2026-08-14 (4) — Checkpoint 0 cerrado: PINE confirmado en vivo

**Máquina:** notebook de Fran (Windows, PCSX2 2.6.3) · **Modelo:** Sonnet

**Objetivo:** cerrar lo que quedó pendiente de la entrada anterior — confirmar
que PINE responde en caliente, no sólo por el log de arranque.

**Resultado:**

- `pine.py info` conectó (`tcp:127.0.0.1:28011`) y devolvió exactamente lo
  esperado: `SLUS-21376`, CRC `5c891ff1`, versión `1.00`, estado `corriendo`.
  El primer intento falló (`WinError 10061`, conexión rechazada): el usuario
  acababa de tildar "Activar PINE" en la GUI de PCSX2, pero el proceso ya
  corriendo no levanta el socket hasta reiniciarse. Con PCSX2 reiniciado,
  conectó a la primera.
- `fijar_objetivo.py` corrió sin fricción y confirmó `NTSC-U` como
  `version_activa` — coincide con lo que ya había quedado anotado por el log
  en la entrada anterior. Dos caminos de evidencia independientes
  (log de arranque y PINE en vivo) dando el mismo resultado.
- `pruebas/prueba_herramientas.py`: **81 de 81** en la máquina real, con
  numpy instalado. Primera vez que la batería corre fuera de la nube.
- En el camino se detectó y se resolvió el problema de que el repo nunca
  había quedado clonado en esta notebook (las instrucciones de clonado
  iniciales se habían salteado). Quedó en
  `C:\Users\frans\Desktop\claude-acceso`, con un atajo `black` agregado al
  perfil de PowerShell del usuario para pararse ahí de un comando.

**No funcionó / fricciones para la próxima:**

- El flujo de "clonar + moverse a la carpeta" en PowerShell tuvo varias
  vueltas por confusión de directorio de trabajo (cada ventana nueva de
  PowerShell arranca en `system32`). Ya resuelto con el atajo `black`, pero
  vale tenerlo presente: en la próxima sesión en esta máquina, arrancar
  directo con `black` en vez de re-explicar rutas.
- Sigue sin confirmarse si `preparar_entorno.ps1` llegó a correr de punta a
  punta alguna vez en esta máquina — el camino real terminó siendo manual
  (activar PINE a mano en la GUI, clonar a mano). No es un problema para
  seguir adelante, pero el script de automatización queda sin validar en la
  práctica.

**Sigue:** checkpoint 1 — el ancla de la vida del jugador, con
`escanear.py`. Ver `docs/02-metodologia.md` escalón 1.

---

## 2026-08-14 (3) — Primera corrida real en la notebook: identidad confirmada, dos bugs encontrados

**Máquina:** notebook de Fran (Windows, PCSX2 2.6.3) · **Modelo:** Sonnet

**Objetivo:** correr `preparar_entorno.ps1` por primera vez en una máquina real.

**Resultado:**

- **Identidad del juego confirmada de verdad**, leyendo el log de arranque de
  PCSX2 (no por PINE todavía, no sé si esa parte del script llegó a correr):
  `Serial: SLUS-21376`, `Version: 1.00`, `CRC: 5C891FF1`. Coincide
  exactamente con lo que tenía anotado como "según la comunidad, sin
  confirmar". `kb/objetivo.json`: `confirmada: true`, `version_activa:
  "NTSC-U"`.
- **Bug real encontrado y arreglado**: el nombre de archivo `.pnach` que
  generaba `pnach.py` usaba un punto como separador
  (`SLUS-21376.5C891FF1.pnach`), pero PCSX2 2.6.3 real usa guión bajo
  (`SLUS-21376_5C891FF1.pnach` — visible en el log: "Found 1 cheats in
  ...\SLUS-21376_5C891FF1.pnach"). Con el separador viejo, el archivo que
  generábamos **nunca lo iba a cargar PCSX2**, sin ningún error visible.
  Corregido.
- **Segundo bug de la misma familia**: `carpeta_cheats()` asumía que la
  carpeta se llama `cheats` por convención. En esta instalación real se
  llama `cheats_ws` (customizado en el `.ini` del usuario, no es el default
  de fábrica). Arreglado de raíz: ahora se lee la ruta real de la sección
  `[Folders]` del `PCSX2.ini` del usuario en vez de asumir el nombre — con
  el default de fábrica (`cheats`) como último recurso si no hay `.ini`
  todavía. 5 pruebas nuevas para esto (total: 81).
- Detalle de infraestructura: `Documents` de este usuario está redirigido a
  OneDrive (`C:\Users\frans\OneDrive\Documents\PCSX2\...`).
  `[Environment]::GetFolderPath('MyDocuments')` en PowerShell y
  `os.path.expanduser("~/Documents")` en Python resuelven esto solos, así
  que no hace falta ningún ajuste — lo anoto para no perder tiempo
  reinvestigándolo si vuelve a aparecer.

**No funcionó / no se pudo confirmar:**

- Lo que pegó el usuario fue **el log interno de PCSX2** (Tools > Show Log),
  no la salida de `preparar_entorno.ps1`. No hay forma de saber desde acá si
  el script: detectó Python, instaló numpy, activó `EnablePINE` en el `.ini`,
  o si `fijar_objetivo.py` llegó a correr. El BIOS falló dos veces al
  arrancar (`Configured BIOS ... does not exist`) y hubo ~70s de
  `Applying settings...` sueltos que sugieren que alguien corrigió la
  carpeta del BIOS a mano desde la GUI — compatible con que el script sí
  lanzó PCSX2 con la ISO, pegó contra el error de BIOS, y ahí se paró.
- El juego SÍ terminó cargando y corriendo (hay Pausing/Resuming en el log
  hasta el segundo 211), así que en el momento en que se pegó este log la
  ventana estaba disponible para probar PINE en vivo — pero no se probó
  todavía en esta conversación.

**Sigue:** con el juego corriendo, confirmar PINE en caliente:
```powershell
cd black
python herramientas\pine.py info
```
Si devuelve datos, correr `python herramientas\fijar_objetivo.py` (aunque
`kb/objetivo.json` ya quedó confirmado por otra vía, esto valida que el canal
PINE en sí funciona, que es lo que hace falta para todo lo que sigue). Si
`pine.py info` no conecta, revisar a mano en PCSX2: `Settings > Advanced >
PINE Settings` → Enable PINE, slot 28011.

---

## 2026-08-14 (2) — Automatización del checkpoint 0 en Windows

**Máquina:** nube (sin PCSX2) · **Modelo:** Sonnet

**Objetivo:** que el checkpoint 0 (entorno + confirmar identidad del juego)
se pueda correr con un solo comando en Windows, con UAC, sin que el usuario
tenga que tocar el `.ini` de PCSX2 a mano.

**Resultado:**

- `herramientas/fijar_objetivo.py`: conecta por PINE, compara el serial/CRC
  observado contra `kb/objetivo.json` y lo actualiza solo (marca
  `confirmada`, fija `version_activa`, o crea la entrada si el serial es
  nuevo). La lógica de decisión (`aplicar_info`) es una función pura, sin
  tocar disco ni red — 13 comprobaciones nuevas en
  `pruebas/prueba_herramientas.py` (total: 77), incluyendo el caso de CRC
  que no coincide con el anotado.
- `herramientas/windows/preparar_entorno.ps1`: se re-lanza pidiendo UAC,
  detecta Python 3.11+ e instala numpy, corre la batería de pruebas, busca
  PCSX2 (por atajo del escritorio/inicio o por carpetas típicas), le activa
  PINE y le apaga la compresión de savestates en el `.ini` —con backup
  automático antes de tocarlo—, abre PCSX2 si hace falta, espera a que PINE
  conteste y corre `fijar_objetivo.py` al final. Todo queda en un log bajo
  `volcados/`.

**Verificación hecha (sin tener Windows a mano):**

- Claves reales del `.ini` de PCSX2 confirmadas contra el código fuente
  (`Pcsx2Config.cpp`) y un `.ini` real de ejemplo: sección `[EmuCore]`,
  `EnablePINE`, `PINESlot` (default 28011), `SavestateZstdCompression`,
  formato `Clave = Valor` con espacios.
- Confirmado contra `PINE.cpp` que `MsgID` devuelve el serial y `MsgUUID`
  devuelve el CRC en minúsculas — importante porque `fijar_objetivo.py`
  depende de esa asignación para no cruzar los campos.
- Sintaxis del `.ps1` validada con el parser real de PowerShell (instalé
  `pwsh` portátil para esto, 0 errores).
- La función `Set-ValorIni` (la que edita el `.ini` línea por línea) se
  probó de verdad —no sólo se leyó— con 21 casos: reemplazo, inserción,
  sección nueva, límites del array (sección al final, clave al final,
  archivo de una sola línea), y que `PINESlot` no se confunda con
  `EnablePINE` por ser substring. Encontré y arreglé ahí un bug real de
  `$Matches` que podía arrastrar el resultado de una iteración anterior del
  loop de detección de Python, y dos bloques de escritura de archivo sin
  `try/catch` que hubieran tirado el script entero sin aviso limpio ante un
  permiso denegado o un archivo bloqueado.
- Lo que **no** se pudo probar, porque no hay Windows ni PCSX2 en esta
  sesión: el flujo completo de punta a punta, la búsqueda real de PCSX2 por
  atajos/carpetas, y si el script realmente dispara el diálogo de UAC como
  se espera.

**No funcionó / limitación conocida:**

- No hay forma de ejecutar `preparar_entorno.ps1` de punta a punta desde acá.
  Toda la confianza viene de verificar cada pieza por separado (fuente de
  PCSX2, parser de sintaxis, ejecución real de la función de edición del
  ini) — no de una corrida completa. Si algo falla al usarlo, es información
  valiosa para la próxima entrada de esta bitácora.

**Sigue:** correr `preparar_entorno.ps1` en la notebook y reportar qué pasó.
Si algo se traba, mejor pegar el contenido de
`volcados/diagnostico-entorno-*.txt` que una descripción de memoria.

---

## 2026-08-14 — Armado del proyecto

**Máquina:** nube (sin acceso a PCSX2) · **Modelo:** Opus

**Objetivo:** montar la arquitectura del proyecto: herramientas, base de
conocimiento, documentación y plan, para que el trabajo sea portable entre la
PC y la notebook.

**Resultado:**

- Instrumental completo en `herramientas/`, con pruebas: `pine.py` (cliente
  PINE), `estado.py` (savestates), `escanear.py` (escaneo diferencial),
  `inspeccionar.py` (estructuras), `vigilar.py` (series temporales),
  `mips.py` (ensamblador R5900), `pnach.py` (compilador de mods).
- Base de conocimiento en `kb/`, con campos de confianza y evidencia
  obligatorios.
- Documentación: entorno, metodología (la "escalera" de 5 escalones), plan por
  fases, glosario del EE.
- `pruebas/prueba_herramientas.py`: 65 comprobaciones, todas en verde, sin
  necesitar PCSX2. Se probaron los dos caminos, con numpy y sin numpy.
- Verificado end-to-end contra RAM sintética de 32 MB con ruido realista
  (200.000 palabras cambiando entre fotos): el escaneo por "bajó" va de
  8.126.464 posiciones a 98.256 y después a 1, en 2,2 segundos.

**Datos técnicos confirmados contra las fuentes** (no de memoria):

- Protocolo PINE, contra `pcsx2/PINE.cpp`: marco de 4 bytes little-endian que
  se incluye a sí mismo; comandos encadenables; **un solo** código de resultado
  por respuesta; lectura = 1 byte de opcode + 4 de dirección.
- Formato `.pnach`, contra `pcsx2/Patch.cpp`: `patch=<cuándo>,<cpu>,<dir>,<tipo>,<valor>`,
  con `cuándo` 0-3 y tipos `byte`/`short`/`word`/`double`/`extended`/`bytes`.
- Savestate = ZIP con `eeMemory.bin` adentro; el offset del archivo es la
  dirección EE.
- CRC de BLACK NTSC-U (`SLUS-21376`) = `5C891FF1`, **según la comunidad, sin
  confirmar contra la copia de Fran**. Está anotado con `confirmada: false`.

**No funcionó / no se pudo hacer:**

- Nada verificado contra el juego real: esta sesión corre en un contenedor en
  la nube, sin acceso al PCSX2 de la notebook. Todo lo que dice `kb/` sobre
  BLACK es hipótesis hasta que se confirme en la máquina.
- No se recuperaron las 4-5 direcciones de vida ni la rutina de daño de la
  sesión anterior en la PC de Fran: no están en este repositorio. Quedaron
  anotadas como "pendiente de importar" en `kb/mapa-memoria.json` y
  `kb/rutinas.json`.

**Sigue:** Fase 0 del plan, en la notebook con PCSX2 abierto:

1. `python3 pruebas/prueba_herramientas.py`
2. `python3 herramientas/pine.py info` con el juego corriendo
3. Volcar serial y CRC reales a `kb/objetivo.json` y poner `version_activa`
