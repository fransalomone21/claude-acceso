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
