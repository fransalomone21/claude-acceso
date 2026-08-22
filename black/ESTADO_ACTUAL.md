# Estado actual

Índice operativo compacto. **Esto se lee primero**, entero, en cualquier
sesión nueva — es más rápido que releer la bitácora. Para el detalle de cómo
se llegó a cada cosa, ir a `docs/03-bitacora.md`; para el instrumental, a
`docs/06-herramientas-externas.md`.

Se actualiza cada vez que cambia algo real. No es historial — para eso está
la bitácora. Si una línea de acá contradice la bitácora, la bitácora tiene
razón y esto está desactualizado: corregirlo.

---

## Lo primero de cualquier sesión

```powershell
python herramientas/ubicaciones.py         # DÓNDE está cada cosa, medido
python herramientas/inventario.py          # qué hay en LA MÁQUINA
python herramientas/decompilar.py info     # control positivo de Ghidra
```

**Las rutas no se copian a mano nunca más.** Viven en `kb/ubicaciones.json`,
en un solo lugar, y `ubicaciones.py` las mide (sale con código 1 si falta algo
crítico). Para usarlas en un script:
`python herramientas/ubicaciones.py ruta iso_original`.

> **Trampa de Windows que ya costó dos turnos:** `Test-Path` y `Get-ChildItem`
> sin `-LiteralPath` dan **False / vacío** sobre rutas que existen, si la ruta
> tiene corchetes — y la carpeta de los ISO es `...\Black [NTSC]\`. Los
> corchetes son wildcard. Por eso el verificador está en Python.

**El repo es la memoria del proyecto, no la de la máquina.** Antes de decir
que una herramienta "no está instalada", se corre `inventario.py`. Esa regla
nació de un error real: PCSX2-MCP estaba bajado en `Descargas` desde el
2026-08-15 y varias sesiones seguidas lo dieron por ausente porque el repo lo
decía.

---

## Mapa de fases — de mayor a menor abstracción

Cuatro niveles. Se baja de nivel sólo cuando el de arriba tiene su criterio de
salida cumplido. `docs/04-plan.md` tiene el detalle histórico por fase; **este
mapa manda**.

```
N0  OBJETIVO       Modificar BLACK con criterio, y que el cambio sobreviva
                   a cerrar el emulador.
     └─ CUMPLIDO el 2026-08-17 para la tabla de armas: existe
        `Black-mod-armas.iso` (artefacto) y `herramientas/parche_iso.py`
        (el procedimiento repetible que lo produce), y el efecto está
        confirmado en RAM tras arrancar ese ISO. Sigue abierto para
        cualquier OTRA cosa que se quiera modificar.

N1  CAPACIDADES    Cuatro, independientes entre sí.
     ├─ A. LEER LA MÁQUINA VIVA .......................... CERRADA
     │     PINE, escaneo diferencial, savestates, watchpoints.
     ├─ B. LEER EL CÓDIGO ................................ CERRADA
     │     Ghidra + r5900, 9842 funciones. Y desde 2026-08-16,
     │     la RAM viva ADENTRO de Ghidra (`decompilar.py estado`).
     ├─ C. LEER EL ISO ................................... ABIERTA  <-- acá estamos
     │     Contenedor .BIN resuelto, LBAs resueltos (6.1).
     │     Faltan .WDD .DB .BKS .SSH .SLB.
     └─ D. ESCRIBIR ...................................... CERRADA
           pnach: listo para probar. ISO permanente: **anda**, in-place,
           confirmado por efecto (`parche_iso.py`).

N2  FASES DEL JUEGO
     0  entorno ........................................... cerrada
     1  ancla: vida del jugador ........................... cerrada
     2  rutina de daño del jugador ........................ cerrada, por efecto
     3  enemigos .......................................... cerrada, por efecto
     4  tabla de armas .................................... cerrada (daño AL jugador)
     4b daño de SALIDA del jugador ........................ cerrada, por efecto
     5a mod de daño ...................................... PARQUEADA (ver abajo)
     5b qué elige la zona de impacto ..................... pendiente, es Opus
     6  exprimir el ISO ................................... 6.1 y 6.6 CERRADAS
     7  arquitectura de entidades y de la IA .............. ABIERTA <-- acá estamos
        7a  qué campo fija el ARMA de un enemigo ......... CERRADA 2026-08-17
            por efecto: `0x006E18B8 + n*0x24 + 0x04`, el puntero al bloque
            de IA del registro de arma. Daño 105→106 y cadencia
            133ms→3534ms a la vez, las dos coincidiendo con el reg 6.
        7b  qué dato fija QUÉ TIPO de enemigo aparece .... CERRADA, negativo
            **2026-08-22, EXPERIMENTO COMPLETO — REFUTADO (ver bitácora
            (33)).** `+0x18` es el modelo DEL PERSONAJE. `+0x78` fija el
            **modelo visual del arma** (`DISTANT0`/`MGNDST0`/`MGNDST2`/
            `RPG0`), confirmado con `FUN_00136848` componiendo
            `<nombre>_LOD`. Pero **no gobierna el array de armas de IA**
            (`0x006E18B8`, `Power`/`TBB`): con `Black-mod-7b.iso` jugado
            hasta `LEVEL_00` y expuesto a los enemigos, el registro de
            `E_BLACKHD_M0` en RAM YA lee `+0x78 = 'RPG0'` (el parche cargó),
            y sin embargo `n=4,5,6,7,9` **siguen apuntando al mismo bloque
            de IA de antes** (`0x01842C40`, igual que el control `n=3`). Las
            dos mitades del experimento están medidas: se confirmó la causa
            (el campo cambió en RAM) y se confirmó el no-efecto (el array no
            se movió). **`+0x78` decide sólo el modelo visual; el
            comportamiento de IA se resuelve por otra vía.** Candidatos sin
            probar: `+0x8C` y `+0xA8`, los otros dos campos que particionaban
            igual que el bloque de IA en el diff de la (32).
            `entidad+0x58` NO es escuadra: **es el puntero al registro de
            personaje** — sólo 4 de los 9 están instanciados, y `PSTL0`
            **no lo está**. **Fran decidió cerrar 7b con el negativo**: no
            se probaron `+0x8C`/`+0xA8`, quedan anotados como candidatos en
            `kb/estructuras.json` para si se retoma la pregunta de "qué
            arma usa realmente la IA" más adelante.
            **El experimento se rediseñó el 2026-08-17 y ahora es barato.**
            Los archivos de stage se cargan LITERALES en RAM
            (`STLEVEL.BIN` de `LEVEL_00` en **`0x01412400`**, 7/7 anclas),
            así que la prueba se hace **en RAM, reversible**, y recién
            después se lleva al ISO. Falta: encontrar la lista de puntos
            de spawn. **OJO: E5 tal como estaba escrito apuntaba a
            `LEVEL_01` y el savestate 3 está en `LEVEL_00`.**
            **2026-08-21, en frío:** los nombres de escuadra NO están
            escritos en ningún archivo del ISO — se arman con
            `'Enemy%d_%s'` (`0x003F8108`) sobre la tabla de 7 punteros
            de **`0x003BD3F8`** (`None/Low/Mid/High/Matt/Tom/Carrie`).
            Y esas cadenas son claves de **sonido** (`AIWeapon.cfg`), así
            que **`+0x58` es candidato a espejo, no a fuente**. La lista
            de spawn sigue sin aparecer; la vía nueva es Ghidra sobre
            quién arma ese nombre y quién emite `'AI gun model not
            found'` (`0x003F4848`).
            **2026-08-21, noche — la estructura que faltaba, leída en
            Ghidra (`probable`, no se escribió un byte).** `'Enemy%d_%s'`
            tiene UNA sola referencia: `FUN_001E2D38`. De ahí sale el
            layout: `stage+0x04` = array de UNIDADES (paso `0x28`),
            `stage+0x08` = cantidad; `unidad+0x18/+0x20` = array de
            ENEMIGOS y cantidad, `unidad+0x1C/+0x24` = COMPAÑEROS; y el
            **registro de PERSONAJE es de paso `0xB0`**, con el nombre en
            `+0x00` y **el índice de tipo en `+0x88`**. Ese índice acepta
            hasta **33 valores** (`FUN_001E3018`, `idx < 0x21`, jumptable
            `PTR_LAB_003F8130`): la tabla de 7 de `0x003BD3F8` era el
            **codominio**, no el dominio. **La "lista de spawn" dejó de ser
            un agujero: es el array de `0xB0` y lo que falta es volcarlo.**
        7c  de dónde sale el puntero al spawnear ......... ABIERTA
            hace falta para hacerlo permanente en el ISO, no sólo en RAM.
        Sirve al objetivo que fijó Fran el 2026-08-17: hacer BLACK más
        difícil y meterle cambios tipo remaster (armas, tipos de enemigo,
        coop). El plan de experimentos está en `docs/08-experimentos.md`
        y los requisitos contra los que se valida, en `docs/00-conops.md`.

N3  TAREAS CONCRETAS DE LA FASE 6         (criterio de salida de cada una)
     6.1  ¿el ELF tiene LBAs hardcodeados? .. CERRADA: NO. rebuild sigue vivo
     6.2  .DB  : firma '..FT' en 6-7        -> qué son los 139 archivos
     6.3  .WDD : byte1 = 0x02, 16K/64K      -> qué es el byte 0
     6.4  .SLB : magia "KING"               -> buscar el formato por esa magia
     6.5  patrón de ImHex del contenedor .BIN -> commitear en `patrones/`
     6.6  parche in-place de GLOBDATA.BIN .. CERRADA, confirmado por efecto
```

**Por qué 5a está parqueada:** Fran decidió el 2026-08-16 exprimir el ISO
**antes** de volver al emulador. El pnach de `0x00142CA0` sigue siendo válido
y es media hora de trabajo cuando se retome; no se perdió nada.

---

## Fase 6 — el ISO. Lo que se sabe al 2026-08-17

### 6.1 CERRADA — el ELF **no** lleva LBAs horneados

La pregunta era si el juego lee sectores escritos a mano, porque eso cerraría
`mkps2iso` como camino. **No los lee.** Resuelve por nombre contra la TOC, en
runtime, vía `IOP/GTFSCDVD.IRX` (módulo `gtfsdvd`, el sistema de archivos de
Criterion), que importa `cdvdman` y falla con `Error reading TOC` /
`ERROR: Exceeded maximum files per disk (%d)`. Un LBA horneado no necesitaría
leer ninguna TOC.

Medición, con control positivo y piso de ruido del mismo rango numérico:
**0 de 1644 valores** aparecen como inmediato `lui`+`ori`/`addiu` en el ELF
(31.760 `lui` indexados), y los literales sueltos están al nivel de los
señuelos, desalineados y en `.text`. El detalle completo, los números y las
dos trampas que hubo que desactivar están en **`docs/05-iso.md`**.

**El parche in-place sigue siendo el camino preferido** —no cambia el layout,
ni la TOC, ni el CRC del ELF, así que los savestates y los `.pnach` siguen
valiendo— pero ahora por razones medidas. `mkps2iso` queda **abierto** como
plan B, con tres condiciones anotadas en `docs/05-iso.md`.

### 6.6 CERRADA — el mod permanente funciona, confirmado por efecto

`herramientas/parche_iso.py` edita un archivo **adentro** del ISO sin
reconstruirlo: `offset_en_el_iso = LBA * 2048 + offset_en_el_archivo`.

Artefacto vivo: **`Black-mod-armas.iso`**, al lado del original, con los 17
`Power` del bloque de IA en `5.0`. Verificado byte a byte contra el original:
**17 rangos de diferencia, todos dentro de `GLOBDATA.BIN`, cero diferencias en
la TOC.**

**Confirmado por efecto el 2026-08-17:** se arrancó el emulador con ese ISO y
la tabla de armas en RAM (`0x01842220`) trae `Power = 5` en los 17 registros
del bloque de IA, con el bloque del jugador intacto. **La tabla ya está cargada
antes de que el jugador tenga vida** (vida = `0.0`, pantalla de "press START"),
o sea que sale de `GLOBDATA.BIN` al arrancar y **no** por stage.

> **Trampa que hay que decir en voz alta: un savestate tapa el mod.** Restaura
> la RAM entera, tabla de armas incluida, con los valores de antes del parche.
> Para ver el efecto hay que empezar o seguir un nivel, no cargar un estado
> guardado previo.

### Firmas de cabecera — `herramientas/firmas.py` (nueva)

Se busca **por posición de byte**, no por u32: un entero en little-endian
mezcla los cuatro bytes y esconde justo la constante que uno busca.

| Familia | N | Tamaños | Firma encontrada |
|---|---|---|---|
| `.SLB` | 9 | 720 B – 23 KB | **`01 00 00 00` + `"KING"` + `00 00 00 00`**, los 12 bytes constantes en 9/9 |
| `.WDD` | 141 | **16384 o 65536 exactos** | **byte 1 = `0x02` en 141/141**; byte 0 varía (19 valores) |
| `.DB` | 139 | 504–725 KB | **byte 0 = `0x00`, bytes 6-7 = `"FT"` en 139/139**; byte 1 sólo `0x14`/`0x94`; byte 5 sólo `0x12`/`0x14`/`0x15` |

**Ninguno de los archivos del ISO es un RenderWare binary stream plano**
(0/141, 0/139, 0/9): los primeros 12 bytes no parsean como cabecera de chunk
RW con tamaño coherente. O sea que los formatos son contenedores de Criterion;
puede haber streams RW **adentro**, pero no en la primera capa.

`.WDD` con tamaño potencia de dos exacta = búfer de tamaño fijo, no stream.
`GRDPIN.WDD` es `0C 02 00 00` y después **todo ceros**: un búfer vacío. Eso
sostiene la lectura de "slot de tamaño fijo" y no la de "archivo comprimido".

### El encuadre que cambió

BLACK corre sobre **RenderWare**, de la propia Criterion. Dejamos de buscar
"herramientas para BLACK" —no existen— y pasamos a buscar "herramientas para
RenderWare", que sobran: RW Analyze, Magic.TXD, RWview, rw-parser, y **el SDK
original de RenderWare 3.10 para PS2 está en archive.org**, con headers. Ver
`docs/06-herramientas-externas.md`.

**Dato de terceros, sin verificar:** dos personas distintas en ResHax dicen
que **la versión de Xbox del mismo juego usa formatos más simples**. Si la
geometría se traba, comparar contra el build de Xbox es una entrada barata.

---

## Instrumental — verificado 2026-08-16 con `inventario.py`

| Herramienta | Estado |
|---|---|
| Ghidra 12.1.2 + extensión EE Reloaded v2.1.36 | instalado |
| pyghidra 3.1.0 · capstone 5.0.9 · numpy 2.5.2 | instalado |
| **pycdlib 1.20.0** · **zstandard** · **kaitaistruct** | **instalados 2026-08-16** |
| **ImHex 1.38.1** (winget, va SIN `--scope user`) | **instalado 2026-08-16** |
| ffmpeg 9.0 (winget `Gyan.FFmpeg`) | ya estaba |
| vgmstream r2117 | instalado |
| **`herramientas/lbas.py`** — tabla de LBAs del ISO y búsqueda con controles | **nueva 2026-08-17** |
| **`herramientas/parche_iso.py`** — editar un archivo adentro del ISO, in-place | **nueva 2026-08-17** |
| **`herramientas/experimento.py`** — banco A/B con savestate, vida inflada y predicción registrada | **nueva 2026-08-17** |
| **`herramientas/kynapse.py`** — las 182 clases de la IA, con nombre y padre | **nueva 2026-08-17** |
| **`herramientas/estructura.py`** — campos de una clase, cruzando instancias con los métodos de su vtable | **nueva 2026-08-17** |
| **`herramientas/ubicaciones.py`** + `kb/ubicaciones.json` — dónde vive cada archivo fuera del repo, medido, con código de salida | **nueva 2026-08-21**. 13/13 en verde, y probada rompiéndola en tres formas |

**PCSX2-MCP: YA ESTÁ EN USO.** Fran lo ejecutó el 2026-08-16. El emulador que
corre es su `pcsx2-qt.exe` (build `d75a0ad`), con DebugServer en 21512 y PINE
en 28011, los dos verificados. El servidor MCP en sí (`pcsx2-mcp-server/`,
Node) sigue sin levantarse — y **no hace falta**: `pine.py` y `depurador.py`
cubren lectura, escritura, volcado, savestates y watchpoints.

**La RAM viva adentro de Ghidra — funcionando desde el 2026-08-16.**
`decompilar.py estado` carga un savestate sobre una **copia** del programa
(`/SLUS_213.76_estado`), nunca sobre el limpio. Pisa `.data`, `.sdata`,
`.sbss`, `.bss`, `.lit4`, `.vudata`, `.gcc_except_table`, y crea **`.other`
con 28,7 MB de heap navegable** desde `0x0049BFBC`. Control positivo pasado:
`jugador+0x10 = 0x003DC5F8` y vida `437.57`.

---

## Formato del contenedor `.BIN` — RESUELTO (2026-08-16)

Cayó **decompilando el cargador**, no mirando bytes. El callback de
`GlobData.bin` (`0x00105D48`) no parsea: **relocaliza**. Los u32 de la
cabecera son offsets relativos que el cargador convierte en punteros absolutos
sumándoles la base, en el lugar:

```c
*(int *)(base + 0x04) += base;   // y +0x08, +0x0C, +0x10, +0x14, +0x18
```

Por eso fallaba la hipótesis de "tabla de offsets creciente": no es una tabla
ordenada, es una cabecera de layout fijo donde cada ranura es una sección.
Recursivo hacia adentro: cantidad en `+0x00` (u8), registros de paso fijo.

Verificado con dos controles que no se ajustaron para que dieran: la tabla de
armas (`0x00130E20`) cae dentro de la sección de `0x00130C80` a `+0x1A0`; y en
`STLEVEL.BIN` la sección de `0x80` arranca con `"bg1_shg"`. Ficha en
`kb/rutinas.json#fixup_contenedor_bin`.

**No aplica a `LEVELDAT.BIN` ni a `GUNS.BIN`**: usan otro layout.

---

## Barrido del ISO (2026-08-16) — reconocimiento

1. **La tabla de armas está en `GLOBDATA.BIN + 0x00130E20`** — 17 registros de
   `0x1E0`, paso verificado por dos anclas (Magnum en `+2`, HVY en `+10`).
   Habilita el mod permanente. `probable`: nadie editó el archivo todavía.
2. **Nombres de hueso en `0x003BCE70`** (`const char*[11]`: `NECK`,
   `MIDSPINE`, `LOWERSPINE`, `SHOULDER/ELBOW/UPPERLEG/KNEE_LT/RT`). Los
   resuelve a índices `0x001381E0`. Material de Fase 5b, **no** la respuesta:
   11 nombres contra 24 registros de zona.
3. **Mapa exacto del ELF**: `.data 0x003BC380`, `.rodata 0x003F2280`,
   `.lit4 0x0040D800`, `.sdata 0x0040D980`, `.bss 0x0040EC80`, y
   **`$gp = 0x004157F0`**.
4. **561 globales se direccionan por `$gp`** (3051 accesos). Si
   `xref.py absoluto` da NADA entre `0x0040D7F0` y `0x0041D7F0`, la hipótesis
   buena es `$gp`.
5. **El middleware de IA es Kynapse**: `CShooterAgent` declara `GunRange` y
   `MaxInaccuracy`.

---

## Hechos confirmados

| Hecho | Evidencia |
|---|---|
| Identidad: `SLUS-21376`, CRC `5C891FF1`, versión `1.00`, NTSC-U | `pine.py info` + log de arranque → `kb/objetivo.json` |
| **Vida del jugador = `0x005A8DA8`** (`jugador 0x005A8AB0 + 0x2F8`, f32) | escaneo diferencial + escritura con efecto. **Confirmación independiente de terceros:** el código público es `205A8DA8 44960000` |
| **Daño al jugador: `0x0013BD20`** (`swc1 f20,0x2F8(s2)`) | watchpoint + golpe real; nop = vida infinita |
| **El puntero de clase está en `objeto+0x10`** | vtable del jugador `0x003DC5F8`; reconfirmado por el cargador de savestates el 2026-08-16 |
| **Método virtual #8 (`vtable+0x4C`) = "recibir daño"** | censo de las 279 vtables |
| **Clase del enemigo = `0x003DCA78`** — 32 objetos, pool `0x0058FE90`, paso `0x3C0`, vida `100.0` en `+0x2F8` | `clases.py`, confirmado por efecto |
| **Daño al enemigo: `0x00134654`**; clamp de muerte `0x00134514` | nop puesto → cargador entero de AK sin matarlo |
| **Tabla de armas: 17 registros de `0x1E0`, `Power` en bloque+`0x18`** — gobierna el daño que se le hace **al jugador** | `Power = 300` → reacción de arma pesada en pantalla |
| **El daño de salida del jugador NO usa `Power`**: sale de `zona * 100.0` en `0x00142B90` | factores en 3.0 → mueren de UNA bala; parche releído después del test |
| **Objeto de arma por tirador: `0x006DE770 + n*0x110`**, dueño en `+0x10` | volcado: `+0x10` = `0x005A8AB0` |
| **EL ARMA DEL ENEMIGO SE FIJA EN `0x006E18B8 + n*0x24 + 0x04`** — puntero al bloque de IA (`registro+0xC0`) del registro de arma. Array de 10 entradas, paso `0x24`, 1:1 con los objetos de arma y en el mismo orden. `+0x00` es el puntero al bloque del jugador (`registro+0x90`) | **2026-08-17, confirmado por efecto con DOS observables: escalón de daño 105→106 y cadencia 133 ms→3534 ms, las dos coincidiendo con el registro 6 (`Power` 106, `TBB` de IA 3.500 s). Series en `volcados/e4-D-marcado.csv` y `volcados/e4-F-bloque-ia.csv`** |
| **Layout del registro de arma: DOS bloques.** Jugador en `+0x90`, **IA en `+0xC0`**. Dentro del bloque, `Power = +0x18` y `TimeBetweenBullets = +0x20`. O sea `Power` de IA en `+0xD8`, `TBB` de IA en `+0xE0` | marcado único por registro (`Power = 100+r`) → el escalón medido nombró el registro. Corrige la lectura previa que ponía el bloque de IA en `+0x90` |
| **Directorio de armas en `0x01842084`**, 17 entradas de `0x20`, justo antes de la tabla. Cinco punteros por entrada: `+0x00→reg+0x50`, `+0x04→reg+0x70`, `+0x14→reg+0x90`, `+0x18→reg+0x1A0`, `+0x1C→reg+0x1C0` | barrido de punteros a la tabla sobre `volcados/ee-e4.bin`. `probable`: no se tocó todavía |
| **Los enemigos del arranque del nivel 1 usan el registro 5** (ASR); los dos del pool con vida `FLT_MAX` usan el 4 y **no disparan** | escalón de 105 exacto, sin mezcla con 104, en 116 impactos |
| **Los archivos de stage se cargan LITERALES en RAM, sin relocalizar**: `direccion = base + offset_en_el_archivo`. `LEVEL_00/STG_0001/STLEVEL.BIN` → **`0x01412400`**; `STUNIT01.BIN` del mismo stage → **`0x01053000`** | **2026-08-17. 7/7 y 2/2 chunks `bc1_` caen exactos, y los tamaños declarados desempatan el archivo de origen. Habilita probar en RAM —reversible, sin copiar 3,9 GB— cualquier edición que después vaya al ISO** |
| **Los dos del pool con vida `FLT_MAX` son los COMPAÑEROS de escuadra**: `Team0_Tom` y `Team1_Matt` | el `+0x58` del registro de entidad (`0x0065FD00`, paso `0x80`) apunta a un descriptor de escuadra **con el nombre en texto** dentro de la imagen de `STLEVEL`. La partición que produce coincide exacto con la de registro de arma de 7a |
| **Cadena entidad→personaje**: `0x006E18B8 + n*0x24` `+0x08` → registro de entidad `0x0065FD00 + k*0x80`; de ahí `+0x10..+0x18` = posición XYZ, **`+0x58` = puntero al REGISTRO DE PERSONAJE de paso `0xB0`** (no una escuadra), `+0x50` = facción | **2026-08-22, en vivo.** Los 4 destinos son `0x01412900/9B0/A80/B30`, direcciones exactas del array volcado en la (31), y su `+0x00` leído en vivo da `Enemy0_Mid`/`Enemy1_Low`/`Team0_Tom`/`Team1_Matt`. La facción `+0x50` parte exacto en COMP/ENEM |
| **El arma de IA la fija `personaje+0x78`, NO `+0x18`** — `+0x18` es el modelo del personaje; `+0x78` es el modelo del arma y vale `DISTANT0`/`MGNDST0`/`MGNDST2`/`RPG0`. `FUN_00136848` compone `<+0x78>_LOD` (el id64 `0xE69A1DD748000000` decodifica a `'_LOD'`) | **2026-08-22.** Diff de los `0xB0` bytes de los 4 registros instanciados: `+0x78`, `+0x8C` y `+0xA8` particionan exacto como el bloque de IA; `+0x18` y `+0x88` no. `probable`: falta el efecto, el ISO ya está parcheado |
| **Mapeo de `+0x88` a las 7 etiquetas, leído en vivo**: `0→None`, `1→Low`, `2→Mid`, `8→Matt`, `0x10→Tom` | **2026-08-22.** `+0x00` del registro de personaje después del `sprintf`, contra el `+0x88` del volcado en frío. Sale gratis sin mapear la jumptable `PTR_LAB_003F8130` |
| **El savestate 3 está en `LEVEL_00`, NO en `LEVEL_01`** | huella de tamaño de los chunks residentes (`0x15e40`/`0x10700`/`0xb60`) contra los dos `STLEVEL.BIN`. El nombre "nivel 1" del savestate era engañoso |
| **Cola de daño diferido = global `0x00414AD0`** (16 registros de `0x20`) | `lui 0x41 + addiu 0x4AD0` en `0x0015B308` |
| **MOD PERMANENTE EN EL ISO: anda.** Editar `GLOBDATA.BIN` in-place cambia el daño en pantalla | **2026-08-17. Cadena entera: 17 campos a `5.0` en el archivo → `Power = 5` en la tabla de RAM al arrancar → `vigilar.py` midió 24 impactos y los 24 son de exactamente `-5.0` (vida 750→630, salto constante, sin varianza). Antes del parche el escalón era `26.0`.** Serie en `volcados/vida-mod-armas.csv` |
| **Los nombres de escuadra se ARMAN en runtime, no están en el ISO**: `'Enemy%d_%s'` en `0x003F8108` y `'Team%d_%s'` en `0x003F8118`, con las piezas en la tabla de 7 punteros de **`0x003BD3F8`** (`None/Low/Mid/High/Matt/Tom/Carrie`) | **2026-08-21, en frío.** `Enemy0_Mid` da 0 ocurrencias en `STLEVEL.BIN`, 0 en `STUNIT01.BIN` y 0 en los ~2.900 archivos del ISO. Las cadenas de formato están en `.rodata` y la tabla en `.data`. **Cuidado con el encuadre**: viven en el bloque de `ValueDB/Sound/ps2/AIWeapon.cfg` — son claves de **sonido** de arma de IA, así que la coincidencia con la partición de 7a se explica por "misma arma = mismo grupo de mezcla" |
| **Hay una lista de armas POR NIVEL, y el ELF la nombra**: `'AI gun model not found: %s'` (`0x003F4848`) + `'weaponList.txt file for this level'` | 2026-08-21. Es el directorio `STLEVEL+0x80` ya conocido, y **es el modo de falla que E5 predecía, con mensaje propio** — un observable de error más barato que la pantalla |
| **Las rutas de nivel se construyen con formato**, no están horneadas: `Levels\Level_%02u\Stg_%04u\StLevel.bin` (`0x003F4388`), `...\StUnit%02d.bin`, `...\Guns%s.bin`, `...\LevelDat.bin`, `...\Unit_%02d.bin` | 2026-08-21, `.rodata`. Corrobora 6.1 desde otro lado y expone nivel/stage/unidad como parámetros |
| **Lista de personajes por unidad, VOLCADA Y RESUELTA.** El registro de personaje (paso `0xB0`) nombra al personaje en **`+0x18`, un id64 base-40** — no en `+0x00`, que es el buffer que el `sprintf` pisa en runtime y que en disco está vacío. Los 9 de `LEVEL_00`: `PSTL0`, `SHTG0`, `E_MAC10_M0`, `E_BLACKHD_M0`, `E_LKISS2_M0`, `MCHNGNM0`, `SBMCHGNM0`, `RPG0`, `E_UZI_M0`. Índice de tipo en `+0x88` (los 9 bajo `0x21`). Cuelgan de `unidad+0x18` (enemigos, cantidad en `+0x20`) y `unidad+0x1C` (compañeros, `+0x24`); las unidades son de paso `0x28`, con nombre ASCII en `+0x00` e id64 en `+0x10`, y cuelgan de `stage+0x04`, cantidad en `stage+0x08` | **2026-08-22.** `probable` — leído de `volcados/ee-03.bin` en `0x01412400`. Nadie escribió nada todavía. **En disco los punteros son relativos a la sección `0x80`, no al archivo**: sobre el ISO crudo el parseo falla. Volcados en `volcados/7b/` |
| **El índice de tipo admite 33 valores (`< 0x21`)**, no 7: `FUN_001E3018` salta por la jumptable `PTR_LAB_003F8130` y la tabla de 7 punteros de `0x003BD3F8` se lee **desde adentro** (`0x001E3044`, su única referencia) | 2026-08-21. `probable`. Corrige el encuadre de la (29): `None/Low/Mid/High/Matt/Tom/Carrie` es el **codominio** |
| **El arma de IA se resuelve por NOMBRE hasheado**: `FUN_00136848` hace `id = FUN_00272610(nombre, 0xE69A1DD748000000)` → `FUN_00108120(DAT_0040F4C4, id)`; si da 0 emite `'AI gun model not found'`, si no llama `FUN_00135C78` y pone `actor+0x3B4 = 0` | 2026-08-21. `probable`. El struct del actor de IA llega al menos a `+0x3B4` |
| **El ID de 64 bits de los recursos NO es opaco: tiene codec de ida y vuelta.** `FUN_00272610(texto, base)` codifica; **`FUN_00272488(id, buffer)` decodifica** | 2026-08-21. `probable`. El bucle de `stage+0x10` decodifica y **recorta espacios a la derecha** — firma de cadena empaquetada de ancho fijo. **Desarchiva lo que la (28) había dado por "no vale la pena"** |
| **Carga del stage: `FUN_00128480`**, máquina de estados con **nivel en `+0x5AAC` y stage en `+0x5AAD`** (`u8`); pide `FUN_00108458(DAT_0040F4C4, 0x0B, idx)` → `+0x5AF0`, y si falla arma la ruta con `0x003F4388` | 2026-08-21. `probable`. Expone nivel y stage como dos bytes en una global |
| **El ELF NO lleva LBAs horneados**; resuelve por nombre contra la TOC | 0/1644 inmediatos en el ELF con control positivo y piso de ruido; `gtfsdvd` lee la TOC. Ver `docs/05-iso.md` |
| **`arma + bloque + 0x20` = `Time Between Bullets`** (segundos entre balas dentro de una ráfaga) | **2026-08-17, `experimento.py`, 4 réplicas A/B con predicción registrada: hueco intra-ráfaga 133.17 ms → 66.53 ms con factor 0.2, 555 dispersiones de separación, y el hueco entre ráfagas sin moverse. Está CUANTIZADA A FRAMES (2/4/5 frames a 30 fps) y la relación NO es proporcional** |
| **El jugador REGENERA vida**: `+0.5` por tick, ~3,6/s | medido con `vigilar.py` el 2026-08-17. Nunca antes anotado; explica que se estabilice en vez de morir |
| **El daño recibido no es exactamente el `Power`** | con `Power = 5`: 5.00 exacto a distancia media, pero mediana 4.50 y mínimo 1.90 a quemarropa. Sin explicar — es el experimento E2 |
| **Mapeo del ELF: `offset_archivo = vaddr - 0xFF000`**, un solo `PT_LOAD` | verificado 6/6 |
| **Los breakpoints de EJECUCIÓN crashean el emulador**; los watchpoints no | `bp poner` mató el proceso |
| Un volcado completo de los 32 MB por PINE tarda **~3 s** | medido 2026-08-16 |

## Callejones cerrados — no repetir

- **`arma_obj + 0x0C` NO fija el arma del enemigo.** Es el único u32 del objeto
  que cae en la tabla, alineado a registro, en 10 de 10 — y no gobierna nada.
  Se apuntaron los ocho a un registro 50× más lento y el fuego entrante no se
  movió. El mejor señuelo que dio el proyecto: **alineación no es causalidad**.
- **Los enemigos con vida `FLT_MAX` del slot 3 (pool 0 y 1) no son los
  tiradores.** Usan el registro 4 y el escalón nunca fue 104.
- **Con el mod puesto, el daño no discrimina armas:** los 17 `Power` de IA
  están aplastados a `5.0`. Para distinguir registros hay que **marcar la tabla
  con un valor único por registro** y leer el escalón.
- **Los cinco `26.0` de `0x0042C3AC..0x0042D56C` NO son la tabla de armas.**
  Están en BSS, se les escribió 300.0 y no cambió nada; además ensucian el HUD.
- ~~**La tabla de armas no está en el ISO.**~~ **REABIERTO: sí está**, en
  `GLOBDATA.BIN + 0x00130E20`. Lo que sigue en pie: **`GUNS.BIN` no es la
  tabla** (es geometría).
- **`0x0013C120` es el método #9 de la clase del JUGADOR.** Falsificado por efecto.
- **El escaneo diferencial no sirve para la vida de un enemigo**: muere en 4 balas.
- **No hay script de QuickBMS ni plugin de Noesis para BLACK.** Reverificado
  2026-08-16 en ResHax #514: el hilo no tiene una sola línea técnica.
- **Los archivos del ISO no son RenderWare binary streams planos.** 0/141 `.WDD`,
  0/139 `.DB`, 0/9 `.SLB`. Medido con `firmas.py` el 2026-08-16.

## Hipótesis activas

- **Vida máxima = 1200.0**, hardcodeada. Falta qué elige entre 1200.0 y 750.0.
- `arma+0x18` (25, 10, 50) es candidato a **cargador**. Sin confirmar.
- El código de 3 letras de `arma+0x1C0` está **corrido un registro**.
  **Corroborado de forma independiente el 2026-08-17:** el directorio de
  recursos de arma del stage (`STLEVEL+0x80`) asocia `0001_bg1_ak1` con la
  escuadra `Enemy0_Mid`, que es la de los cinco tiradores que medimos usando
  el **registro 5** — anotado como "ASR". Sigue sin ser `confirmado`: nadie
  escribió nada para probarlo.
- `.SLB` con magia `"KING"` es la tabla de nombres del sistema de audio; el
  trío `.BKS` (banco, hasta 117 MB) + `.SSH` (cabeceras) + `.SLB` (índice)
  parece ser un solo sistema. Sin verificar.

## Estado de la máquina — verificado 2026-08-17, madrugada

- **Fuera del repo:** `C:\Users\frans\herramientas\ghidra_12.1.2_PUBLIC`
  (extensión EE en `Ghidra\Extensions\ghidra-emotionengine-reloaded`),
  `...\vgmstream\vgmstream-cli.exe`, `...\SLUS_213.76` (copia del ELF),
  proyecto Ghidra en `...\ghidra-proyectos2\BLACK` — **y ahora también
  `/SLUS_213.76_estado`, la copia con la RAM viva encima**.
  `ghidra-proyectos` (sin el 2) tiene el análisis MALO de MIPS R6: no usarlo.
- **Autorización vigente de Fran:** instalar lo que haga falta sin preguntar.
- **El emulador que corre es el de PCSX2-MCP**, no el de Program Files:
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  (build `d75a0ad`). Trae DebugServer en 21512 y **PINE en 28011**, los dos
  verificados andando. Fran ya lo ejecutó: dejó de ser "bajado sin incorporar".
- **Los dos ISO, en la misma carpeta** — reverificado el 2026-08-21, enteros:
  `Black.iso` (original, 3.919.609.856 B, **no tocar nunca**) y
  `Black-mod-armas.iso` (parcheado, mismo tamaño exacto). **La ruta no se
  copia acá**: `python herramientas/ubicaciones.py ruta iso_original`.
  Accesos directos en `C:\Users\frans\Desktop\BLACK\`:
  `ABRIR-BLACK-ORIGINAL.bat` y `ABRIR-BLACK-MOD-ARMAS.bat`.
- **`D:` y `E:` montan los dos el MISMO `Black.iso` original.** Verificado por
  huella, no por letra: `GLOBDATA.BIN` de las dos unidades tiene el mismo md5
  `e48221c5d55af24abe41399fad359500`. **El ISO parcheado no está montado.**
  `lbas.py` y `parche_iso.py` no necesitan montaje: leen el `.iso`.
- **Parches vivos en memoria: NINGUNO.** El emulador se reinició el 2026-08-17,
  así que el nop de vida infinita en `0x0013BD20` **ya no está puesto**.
- Savestates en **`C:\Users\frans\Documents\PCSX2\sstates\`** (ya NO en
  OneDrive; la carpeta de OneDrive quedó con copias viejas y confunde).
  **`pine.py cargarestado --slot N` los carga**, así que una sesión puede
  correr experimentos sin nadie al teclado.

  | slot | qué es |
  |---|---|
  | **3** | **la condición experimental**: jugador pegado a dos tiradores cerca del primer auto del nivel 1, con la **vida ya inflada a ~1e6** para que la muerte no trunque una medición. Es el que usa `experimento.py`. |
  | 4 | mismo nivel, distancia media, vida normal |
  | 6 | el punto de trabajo histórico |
  | 7, 8 | capturas intermedias del 2026-08-17 |
  | 9 | la partida que Fran tenía abierta el 2026-08-16 a las 23:39 |
  | 10 | pegado a los tiradores pero con poca vida: **muere en segundos**, no sirve de condición inicial |

## Problemas abiertos

- **`herramientas/windows/preparar_entorno.ps1` sigue sin validar de punta a
  punta.** No se tocó a propósito el 2026-08-17: pide UAC (bloquea en una
  sesión no interactiva) y puede relanzar PCSX2 / tocar su `.ini`, y ahora
  mismo el emulador tiene una sesión viva con PINE conectado — correrlo sin
  avisar arriesgaba esa sesión. Necesita terminal interactiva y, si se
  prueba con `-SinPatchIni` primero, no toca el `.ini`; el flujo completo
  (con el patch) mejor con el emulador cerrado.

**Cerrados el 2026-08-17** (detalle completo en `docs/03-bitacora.md`,
entrada 27): el falso positivo de OneDrive en `inventario.py` (ahora usa
`estado.carpeta_savestates()` en vez de una ruta vieja hardcodeada, probado
por efecto en los dos sentidos); `construido/.gitkeep` ya no lo borra
`prueba_herramientas.py`; `armas.py`, `zonas.py`, `tablas.py`, `firmas.py` e
`inventario.py` tienen test nuevo (138 comprobaciones en verde); y el
`open()` de escritura en `vigilar.py::grabar()` que le faltaba
`encoding="utf-8"`.

## Riesgos relevantes

- Las direcciones son válidas sólo para NTSC-U / `5C891FF1`. No portan a PAL.
- **No escribir valores arbitrarios en `0x006CF54C`**: índice de render, crashea.
- No escribir en `0x0042Cxxx`: zona de HUD, ensucia la pantalla.
- **Nunca editar el ISO original.** 3,9 GB por copia; hay 165 GB libres.
