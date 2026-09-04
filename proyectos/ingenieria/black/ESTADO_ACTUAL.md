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
        (7a, 7b, 7c y 7d cerradas; la abierta es 7e)
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
        7c  de dónde sale el puntero al spawnear ......... CERRADA 2026-08-22
            **En frío, sobre el ELF, sin tocar el emulador. Ver bitácora
            (34).** Lo escribe **`FUN_00158F50`** (`0x00158F50`), y el
            valor **no sale de ningún campo del registro de personaje**:
            el bloque de IA es **el descriptor de arma + `0x30`**, un
            offset FIJO puesto en una sola instrucción,
            **`0x00159008: addiu $4, $16, 0x30`**. El jugador —único caso
            distinto, discriminado por `*(*(slot+0xF0)+0xC4) == 2`— usa el
            descriptor sin desplazar (`0x00158FF4`). **No hay selección, no
            hay tabla, no hay índice**, así que `+0x8C` y `+0xA8` quedan
            **descartados por lectura**, sin gastar otro parche de ISO.
            Eso explica del todo el negativo de 7b: los cinco enemigos
            daban `0x01842C40` porque es `0x01842C10 + 0x30`.
            **Tres correcciones de estructura que salieron de paso:**
            (a) la base real del pool es **`0x006E18B0`, 50 entradas**, no
            `0x006E18B8` con 10 — la vieja es `entrada_0+0x08`, coincide
            entrada por entrada pero con los offsets corridos 8;
            (b) **`n` no significa nada**: es el primer byte libre del
            array de ocupación de `manager+0x10` (`FUN_0015D060`);
            (c) el pool cuelga del manager `0x005AE880`, que vive en la
            global `.bss` **`0x0040F4E0`** (malloc de `0xFE0` en
            `FUN_001020C0`, init en `FUN_0015C970`).
            **Por qué el xref directo daba 0 y no era un bug:**
            `0x006E18B8` es heap — `.bss` termina en `0x0049BFBC` y no hay
            una sola `lui rX,0x006E` en `.text`. Regla nueva: antes de
            gastar un xref, mirar si la dirección cae dentro de alguna
            sección (`decompilar.py info` las lista).
        7d  quién escribe `slot_0x110 + 0xEC` ............. CERRADA 2026-08-23
            **En frío sobre el ELF, sin abrir el emulador. Ver bitácora (35).**
            Lo escribe **una sola instrucción**, `0x00156318:
            `sw $v0, 0xEC($s0)`, dentro de **`FUN_00156278`** — el
            constructor del slot de `0x110`, tres instrucciones antes de la
            llamada a `FUN_0015D060` que lo lee. El barrido de stores a
            `+0xEC` en `0x00155000`–`0x0015D200` dio **54 accesos y un solo
            store**.
            **El valor sale de `directorio_armas[b] + 0x08`**: una tabla de
            **17 registros de paso `0x20`** en `0x01842090`, con el conteo en
            `*(*mgr+1)`. `b` es un **byte** que también queda en `slot+0x00`.
            **Y el giro: `b` no es un dato guardado, se resuelve POR NOMBRE.**
            El registro `+0x00` de la tabla es un **id64**, y los **cinco**
            llamadores de `FUN_0015cef0` hacen todos lo mismo: barren los 17
            comparando ese id64 contra un u64 y usan el índice que matchea
            (`0xFF` si no matchea ninguno). Los 17 nombres decodificados:
            `BG1_PST SHG SNR SMG ASR AK1 RPG GRL SM3 P90 HVY MGN M16 RM1 GK1
            MP1 BNS`.
            **Las cuatro fuentes del nombre:** `entidad+0x3C0` / `+0x3C8`
            (jugador, `FUN_00139c68`); el literal `BG1_AK1` **hardcodeado en
            el `.text`** (`FUN_0015ef48` case `0x0A`); el literal `BG1_SNR`
            (`FUN_001784f0`); y `descriptor+0x28` por la cadena data-driven
            `FUN_00178978`→`FUN_00178bc0`→`FUN_00138c80`→`FUN_001327f0`.
            **RESPUESTA A LA PREGUNTA ABIERTA DESDE 7a: SÍ se puede fijar
            desde el ISO**, y son 8 bytes. La vía más barata es el literal
            `BG1_AK1` del ELF, porque `bg1_rpg` **ya está** en la lista de
            assets de LEVEL_00 (`dir_recursos_arma_stlevel`) y no hay que
            agregarle nada al nivel.
            **Control positivo cumplido:** prediciendo `+0xE8` y `+0xEC` desde
            `slot+0x00` sobre `ee-e4.bin`, **8/8 slots exactos**, y
            `b=0x05` → `0x01842C10`, el descriptor que la (33) había medido
            en RAM. Dos cruces no buscados: `b=0x05` = `BG1_AK1` (los
            enemigos llevan AK) y `b=0x00` = `BG1_PST` (el jugador arranca
            con pistola).
        7e  el ÍNDICE DE MÓDULOS del nivel ................. ABIERTA <-- acá estamos
            (mitad (a) HECHA y MEDIDA; falta (b), que necesita el emulador)
            Salió de una pregunta de Fran a mitad de la sesión de 7d: en vez
            de subir la cadena de llamadas eslabón por eslabón cada vez que
            se quiere tocar algo, buscar si el juego tiene un índice. **Lo
            tiene.** El stage es un **stream de registros tipados de `0x10`
            bytes** `{u32 tipo, u32 ptr, u64 payload}` precedido por
            `{u32 count, u32 array}`, y **`FUN_0015ef48` (`0x0015EF48`) es su
            dispatcher: 61 casos, tipos `0x03`–`0x44`**. Ese `switch` **es el
            esquema del archivo de nivel**: una rama por tipo de módulo. El
            case `0x0A` es el spawn de personaje (confirmado por otra vía: es
            el que lleva el literal `BG1_AK1`).
            **Cierra cuando** los 61 casos estén traducidos a un esquema en
            `kb/` que diga, por cada tipo, qué estructura consume y qué
            subsistema toca — y con al menos **un tipo distinto del `0x0A`
            verificado por efecto**, para que el esquema no quede en papel.
            Es la vía de mayor apalancamiento que hay abierta: sirve igual a
            la Fase 6 (exprimir el ISO) que a la 7.
            **PASO 1 CERRADO 2026-08-23** (bitácora (36), en frío, sin abrir el
            emulador). El layout estaba **leído, no verificado**; ahora está
            **medido, y salió corregido**: `+0x08` **NO es una posición, es el
            id64 del NOMBRE** del módulo (`GP0101001527`, `LW0001781`,
            `SQTOM`). `+0x04` es el **blob de datos**, de tamaño variable.
            **El stream mixto apareció: `0x01092800 = {count=857,
            array=0x0109F590}`**, 41 tipos distintos — la racha "pura de
            `0x2D`" de la sesión anterior era un tramo de adentro. Lo encontró
            un **parámetro distinto**, no más esfuerzo: por rango de tipo son
            817 rachas; exigiendo **monotonía estricta del puntero de `+0x04`**
            son 3, y una sola con tipos reales. Control positivo: el `count`
            leído y el largo derivado por monotonía dan **857 los dos**, por
            caminos independientes.
            **Dos cosas que quedaron abiertas y no hay que dar por sabidas:**
            (a) **cero registros `0x0A` en ese stream**, y LEVEL_00 tiene cinco
            enemigos — el `0x0A` sigue confirmado por 7d, pero **no sale de
            acá**; (b) los tipos `0x01`/`0x02` (`SQTOM`/`SQMATT`, escuadra) y
            `0x33` (`FX0101000004`) **están en los datos y no entre los 61
            casos**: caen en el `default`, así que el `switch` es el esquema de
            lo que *este* dispatcher construye, **no del archivo entero**.
            Lo que falta para cerrar 7e es la **verificación por efecto**, y
            **ésa sí necesita el emulador**.
            **PASO 2 CERRADO 2026-08-28** (bitácora (37), en frío): el
            *characterization test* del observable del `0x2D` **refutó la
            premisa del plan**. El array del camino de éxito tiene **48
            ranuras (`0x30`), no 256**, vive en **`0x004CB1C8`**
            (`*(0x0040F4D4) + 0xA48`), y está **VACÍO: 0 de 48**, igual en los
            **9** volcados de 32 MB del repo. El «255 de 256» nunca fue
            posible: el despachador llama al handler **sólo si
            `blob[0x1E] == 1`**, y de los 256 registros `0x2D` **pasan 4**
            (`LW0001910/911/913/931`). El techo del observable era 4, y lo
            medido es 0. **El observable del plan está muerto también por esta
            vía.**
            **Lo que sí varía y es contable:** la cabecera de 16 entradas del
            mismo objeto — `ee-03.bin` tiene **5** con `+0x70 != 0`, los otros
            8 volcados tienen **3**. Es el candidato a reemplazo.
            **Pregunta abierta que decide el próximo paso:** ¿el array se llena
            y se vacía, o no se llena nunca? Las dos cosas dan el mismo `0` en
            un volcado, y **no está medido**.
            **PASO 3 CERRADO 2026-08-29** (bitácora (38), en frío): **la mitad
            (a) de 7e está hecha.** El eje de identificación que el plan
            proponía —cierre transitivo del call graph por handler— se midió y
            salió **mitad refutado, mitad reemplazado**. El objeto de estado
            **no lo nombra el handler: se lo pasa el despachador en `a0`**, y
            por eso el cierre de `FUN_00175980` no alcanza `0x0040F4D4` a
            ninguna profundidad. Lo que identifica el subsistema es el **SITIO
            DE LLAMADA**, y son **tres coordenadas**: el **destino** (array de
            handles `P1+0xNN` o singleton de `.bss`), el **contador** que
            avanza, y la **acción** (handler directo o método virtual
            `vtable+0xNN`). Los **61 tipos despachados** (en **55 bloques**;
            8 tipos caen en el `default`) están volcados en
            `kb/stage-modulos.json` con las tres, más qué consume cada uno
            —id64 del nombre, blob, `P1`, `P2`— leído de los argumentos.
            Los 60 tipos de módulo caen en **23 grupos** de destino+contador;
            el mayor tiene 23 tipos.
            **Tres cosas que no se buscaban.** (1) El **`0x35` no es un tipo
            de módulo: es el CIERRE del stream** — recorre todos los arrays de
            `P1` y tiene 0 instancias; el `switch` mezcla constructores con un
            paso de commit. (2) **`P1` es un directorio de pools ya alocados**
            y su inventario está cerrado por **doble control**: los 18 offsets
            que usan los casos individuales son exactamente los que recorre el
            bloque del `0x35`. (3) Los singletons de `.bss` caen todos en
            `0x0040F4D0`–`0x0040F514`: hay un **directorio de subsistemas**
            ahí (probable, no medido).
            **Y una advertencia que sale del cruce código-vs-datos:** mismo
            array **no** es misma struct — dentro de `P1+0x1C` conviven blobs
            de 16 a 96 B. El array es el pool de destino; el blob, la
            estructura de entrada. Dos coordenadas independientes.
            **El eje de las cadenas queda REFUTADO POR MEDICIÓN**, no ya por
            impresión: sobre el cierre a profundidad 3, **2 handlers de 70**
            tienen cadena, 5 en total. Y el primer barrido dio **0 hasta para
            el `0x2D`** porque limpiaba la sombra de registros antes del
            **delay slot** — lo atrapó el control positivo.
            Herramienta nueva con autotest **probado en rojo** (6 casos
            confirmados por otra vía, 4 sabotajes):
            `herramientas/casos_dispatcher.py`.
            **PASO 3b CERRADO 2026-08-29** (bitácora (39), en frío): `P1` deja
            de ser lectura y pasa a ser **medición**. Las **18 predicciones
            numéricas simultáneas** que el paso 3 dejó escritas —cuántas
            instancias tiene cada pool en LEVEL_00, según el stream— se
            contrastaron contra `volcados/ee-e4.bin`: **17 exactas**, y la 18ª
            no era el modelo sino una lectura mal derivada, **que la medición
            corrigió**. **`piVar4 = 0x005AD410`, `P1 = 0x005AD450`.**
            **No se ubicó por barrido, y eso es el punto.** El tag
            `*piVar4 == 0x1C` es el mal parámetro de siempre; el eje que sirve
            es la **cadena de indirecciones desde un dato ya confirmado**:
            `param_2 = *(u32*)(piVar4[4]+4)` y `param_2` es el descriptor
            `0x01092800`, medido el 2026-08-23. Dos saltos hacia atrás, y el
            tag queda de **control** — sobrevive **1 de 6** candidatos. Tres
            controles independientes cerraron encima, ninguno buscado:
            `piVar4[4] == 0x01053000` (la carga de `STUNIT01.BIN`, confirmada
            por otra vía), el otro slot del doble buffer **exactamente a
            `+0x880`** con tag `0x1` y `[4]=0` (uno vivo, uno libre), y las
            capacidades derivadas por contigüidad, **≥ ocupación en los 18 y
            siempre ajustadas** (132 para 131 en `P1+0x1C`).
            **El control negativo dio más de lo pedido:** los tres offsets con
            0 predicho (`P1+0x00`, `P1+0x38`, `P1+0x40`) no tienen un array
            vacío — tienen **el puntero en nulo**. Total predicho 552, total
            ocupado 548, y la diferencia entera es una sola fila.
            **Esa fila corrigió el mapa: el `0x34` no usa "índice fijo 0".**
            `0x0015F5FC`–`0x0015F624` es un **loop** (`s0` desde 0, límite en
            `*(P1+0x78)`): el `0x34` no construye en `P1+0x28`, **lo recorre**.
            Su único destino es `P1+0x1C | c_s5`, donde la kb ya lo tenía y
            donde el 131 dio exacto. Predicción escrita antes de mirar —
            *`*(P1+0x78)` vale 1*— y **vale 1**. **El síntoma era visible sin
            medir nada:** el `0x34` era el **único tipo de módulo en dos grupos
            de destino**. Un tipo en dos grupos es una lectura sin resolver.
            **Dos cosas que no se buscaban.** (1) **El juego mantiene sus
            propios contadores y coinciden**: `P1+0x50..0x90` es una tabla de
            largos cuyo multiconjunto reproduce elemento por elemento las
            ocupaciones medidas — una **tercera derivación independiente**, que
            no sale del stream ni de mi conteo. *Abierto:* la alineación
            offset-por-offset **no cierra** con un corrimiento constante.
            (2) El **`0x2B`** confirmado por su vía propia: array **inline** de
            structs de `0x10` en `P1+0xB0`, **9 con contenido y ceros después**
            contra 9 predichas, y `P1+0xA0 == 9`. Sus campos son floats que
            parecen XYZ (hipótesis).
            **Falta la mitad (b), y ésa necesita el emulador** — pero ahora hay
            **instrumento para leer el efecto**: `pools_p1.py` mide la ocupación
            de cualquier pool en un volcado nuevo, así que "el módulo no se
            construyó" pasa a ser **contable**.
            Herramientas nuevas de 7e, las cinco con autotest **probado en
            rojo**: `herramientas/stream_modulos.py`,
            `herramientas/tipos_modulo.py`, `herramientas/registro_fisica.py`,
            `herramientas/casos_dispatcher.py` y `herramientas/pools_p1.py`.
        Sirve al objetivo que fijó Fran el 2026-08-17: hacer BLACK más
        difícil y meterle cambios tipo remaster (armas, tipos de enemigo,
        coop). El plan de experimentos está en `docs/08-experimentos.md`
        y los requisitos contra los que se valida, en `docs/00-conops.md`.

REMASTER GRÁFICO (DLSS5) — línea aparte de N2, no depende de la fase 7e
     R0  ¿hay depth buffer usable en PCSX2 2.8 para BLACK? .... CERRADA
         SÍ, en las TRES casillas. Medido el 2026-09-01, confirmado por
         efecto (vista de normales derivadas del depth, no conteo):
             D3D11 @ Native ... sirve    642x450  D32S8  ~1200 draw calls
             D3D11 @ 4x ....... sirve   2568x1800 D32S8  ~1034 draw calls
             D3D12 @ 4x ....... sirve   2568x1800 D32S8  ~1001 draw calls
         Capturas: `pruebas/R0-depth/{d3d11-native,d3d11-4x,d3d12-4x}.png`.
         El depth escala con la resolución interna (2568x1800 = 4x exacto
         de 642x450). R0 no restringe el renderer: la elección se decide
         por rendimiento y por el pipeline de DLSS, no por disponibilidad.

         REQUISITO QUE SALIÓ DE LA MEDICIÓN, vale para el pipeline final:
         el buffer hay que FIJARLO A MANO. La heurística de Generic Depth
         elige uno de 128x64 y el resultado es indistinguible de "no hay
         depth". Y la selección se pierde cada vez que cambia el renderer
         o la resolución interna, porque PCSX2 recrea los render targets.

         La predicción escrita antes de medir falló en 2 de 3: daba
         D3D11@4x `no sirve` y D3D12@4x `sirve degradado`. Su justificación
         ("colisión documentada con el objetivo de 4-6x") NO está en este
         repo — venía de un chat anterior sin registrar. Ver bitácora 41.

         Infraestructura: PCSX2 2.8.0 (winget, `PCSX2Team.PCSX2`, en
         `C:\Program Files\PCSX2\`, SEPARADO de la instalación de
         `kb/ubicaciones.json` que tenía 2.6.3) + ReShade 6.6.2 addon
         support. Detalle: `sesiones/HANDOFF.md`, sección 8.

     R1  ¿qué renderer y resolución interna, por rendimiento? ...... CERRADA
         Las tres casillas dan el MISMO FPS (29.97, tapado en la mitad de
         59.94 V-Blank por el juego, no por el renderer). Lo que distingue
         es el uso de GPU del OSD:
             D3D11 @ Native ... 60.1% GPU (10.02 ms)
             D3D11 @ 4x ....... 57.9% GPU ( 9.67 ms)
             D3D12 @ 4x ....... 18.5% GPU ( 3.08 ms)  <- elegido
         Decisión: D3D12 @ 4x — mismo FPS, un tercio del gasto de GPU de
         D3D11, margen para el pipeline DLSS5/ReShade que va encima. Medido
         el 2026-09-01 sobre el savestate 03, editando `PCSX2.ini` directo
         (sin clicks en Ajustes→Gráficos). Tabla y capturas:
         `pruebas/R1-rendimiento/resultados.md`. Detalle: `sesiones/HANDOFF.md`
         sección 8.5. `PCSX2.ini` quedó en Renderer=15, upscale_multiplier=4.

     R2  armar el pipeline real de DLSS5/ReShade sobre D3D12@4x .... ABIERTA
         Decisión de Fran (2026-09-02): va por DLSS5 real. Ya bajó los ZIPS
         FUENTE (`main`, no release) de dlss5-bridge y DLSS5-Feeder. La pieza
         correcta para PCSX2 (D3D12, sin DLSS nativo) es **DLSS5-Feeder**, no
         dlss5-bridge (ese es sólo para D3D11/Vulkan con DLSS propio). Hay
         precedente PÚBLICO de DLSS5 corriendo en PCSX2 (varios medios,
         `probable` no `confirmado` -- el detalle técnico no está publicado
         en ningún lado). Lista exacta de piezas, gotcha de versión de
         ReShade (hace falta 6.8+, hay 6.6.2), y la PREGUNTA DE ARQUITECTURA
         sin responder (si ReShade engancha el framebuffer a 2568x1800
         interno o a la resolución de salida -- decide si el diseño entero
         cambia): `sesiones/HANDOFF.md` sección 8.7.

         LA PREGUNTA DE ARQUITECTURA ESTÁ RESPONDIDA (2026-09-02, Opus,
         `confirmado`, sin abrir el emulador): **el swapchain es 1920x1080**,
         no 2568x1800. `ReShade.log` de la corrida de R1 (Renderer=15,
         upscale_multiplier=4) vuelca `Width 1920 / Height 1080` en el hook de
         `CreateSwapChainForHwnd`, en la MISMA corrida en que R0 midió el
         depth a 2568x1800. PCSX2 reescala a resolución de ventana ANTES del
         `Present`, que es donde engancha ReShade.
             -> DLAA corre a 1080p, no a 2568x1800. **EL DISEÑO NO CAMBIA.**
             -> La restricción de resolución de salida se cumple sola.
             -> El 4x no se desperdicia: el downscale ya es supersampling.
             -> El depth a 2568x1800 con color a 1080p NO es problema:
                `DLSS5_Feed.fx` lo copia a `DLSS5_Depth` (R32F), y las
                texturas de efecto de ReShade son del tamaño del backbuffer.
             -> En la PC de escritorio (2K) el costo escala con la PANTALLA,
                no con `upscale_multiplier`.
         Detalle y runbook completo: `sesiones/HANDOFF.md` sección **8.8**.

         INSTALACIÓN CERRADA (confirmado por efecto, 2026-09-02): las 7
         piezas (ReShade 6.8.0, DLSS5-Feeder, renodx v4.55 por hash,
         `nvngx_dlssnr.dll`, LumeniteFX) están en
         `C:\Program Files\PCSX2\`, medidas por tamaño/hash/FileVersion, no
         asumidas. `.\instalar-dlss5.ps1` lo corrió Fran (el permiso de
         escritura en `Program Files` lo bloquea a la sesión). Detalle:
         `sesiones/HANDOFF.md` sección **8.11**.

         Overlay configurado en vivo por Fran (orden Feed/Kernel, buffer
         grande de Generic Depth) -- confirmado por captura. Con eso YA no
         es el bloqueo.

         CAUSA IDENTIFICADA (2026-09-02, Opus): **FALTA `nvngx_dlss.dll`
         en `C:\Program Files\PCSX2\`.** El inventario de `*nvngx*` de esa
         carpeta devuelve UN solo archivo (el `dlssnr`), y `SuperSampling`
         es la feature que provee `nvngx_dlss.dll` -- NGX resuelve las DLL
         de features desde el directorio del proceso. `Available=0` es la
         respuesta correcta del runtime a un archivo que no está.

         `confirmado` por medición local + TRES fuentes independientes del
         Discord de RenoDX, una de ellas con la MISMA GPU (RTX 4060) y otra
         con el antes/después exacto en RTX 4070 SUPER: agregar el archivo
         llevó `SuperSampling.Available` de 0 a 1 y el pipeline llegó a
         `feature ready ... DLAA` + `frame 10800 evaluated`.

         DOS COSAS QUE QUEDAN DESCARTADAS:
             -> el **techo de hardware**: hay RTX 40 con esto corriendo, y
                ShortFuse mantiene un `dlssnr` parcheado para RTX20/30/40.
             -> la **herramienta de reparación de firma** (`kayle2203`) --
                y era un riesgo, no sólo un desvío: restaura el binario
                firmado por NVIDIA, que es el de Blackwell. La guía del
                server dice lo contrario para esta GPU ("overwrite
                `nvngx_dlssnr.dll` with the **patched** version"), y un
                binario parcheado tiene la firma inválida POR DISEÑO.
                `HashMismatch` era una pista leída al revés.

         FALTA, y es lo único: conseguir `nvngx_dlss.dll` **310.8.0** (la
         comunidad estandarizó en 310.8 para ambos DLL; los tres que ya hay
         en el disco son 310.2.1.0 y 3.7.0.0), ponerlo en la carpeta -- lo
         hace FRAN, la sesión no escribe en `Program Files` -- y medir
         `SuperSampling.Available` en `dlss5-feed.log`.

         Detalle completo, con las citas, los hashes y la predicción escrita
         antes de probar: `sesiones/HANDOFF.md` sección **8.13**.
         La sesión de Discord quedó ABIERTA en el navegador interno (login
         por QR, usuario `chicoleche`): sección **8.14**.
         La sección **8.12** quedó marcada como SUPERADA: su conclusión
         operativa ("NGX rechaza esta GPU/driver") era falsa.

     T1  pack HD de texturas: ¿carga? ............................ CERRADA
         SÍ, confirmado por efecto el 2026-09-02. Había 8225 texturas .dds
         DXT5 (1305 MB, mtime 23/10/2022) en el disco desde junio, en el
         árbol de la instalación VIEJA, y por eso nunca cargaron: PCSX2 lee
         de `Documents\PCSX2\textures` (data dir activo, medido por mtime
         del .ini) y esa carpeta estaba vacía. Copiadas ahí, `emulog.txt`
         emite `Disabling autogenerated mipmaps on one or more compressed
         replacement textures` — línea imposible con la carpeta vacía.
         Validación de Fran, jugando: "se ve bien".
         GOTCHA: el pack NO trae mipmaps. ~~Shimmer esperable en superficies
         lejanas, sin medir.~~ **La consecuencia estaba mal predicha, y por eso
         nadie conectó este dato con T5 durante dos sesiones: no produce
         shimmer de lejos, produce BORROSO de cerca en ángulo oblicuo.** Medido
         el 2026-09-03: 0 de 8225 archivos llevan `-mip`. Detalle: `docs/09` §7.

     T2  ¿cuánto CUBRE el pack? ............................... CERRADA
         **70,9 % (± ~1)**, confirmado por efecto el 2026-09-03, fase V1(c).
         90 de 127 texturas pedidas en el savestate 03 tienen reemplazo;
         **29 % cae al original de PS2**. Método: PCSX2 NO dumpea lo que ya
         tiene reemplazo (`GSTextureReplacements.cpp:800`), así que con el
         pack activo `dumps/` es el complemento — dos corridas del mismo
         savestate, sin cruzar hashes. Control: las 90 cubiertas están en el
         pack, 90/90.
         El hueco NO es de dominio: 36 de los 38 no cubiertos son
         paletizados, el formato que el pack sí sabe reemplazar. BLACK casi
         no usa color directo (125 de 127 pedidas son paletizadas).
         Detalle: `pruebas/cobertura-pack-2026-09-03.md`, `docs/09` §6.

     T3  qué ES el pack ...................................... CERRADA
         **5213 assets**, no 8225: 3012 archivos son otra variante de CLUT
         del mismo asset. 100 % paletizado. **Upscale 4,0x uniforme en los
         8225 sin una excepción** — firma de un pipeline automático sobre un
         volcado completo. El original de PS2 tiene moda 128×128, no 512².
         Script: `herramientas/clasificar_pack.py`.

     T3b COBERTURA RECALCULADA: no era 70,9 %, es ~93 % ......... CERRADA
         **2026-09-04.** El 70,9 % de V1 se midio con `hw_mipmap = true`, o
         sea inflado por el efecto del hash de T7. Confirmado: los volcados
         de V1 y los de esta sesion con mipmap on comparten **37 de 38**
         claves. Rehecha con numerador y denominador en el MISMO estado
         (mipmap off): **82 texturas en la escena, 6 sin reemplazo -> 92,7 %**,
         con control positivo (las 6 son subconjunto exacto del total). Sobre
         la misma escena: 38 sin reemplazo con mipmap on contra 6 con off.
         El "29 % que cae al original de PS2" era el efecto del hash, no
         falta de cobertura. Vale para ESTA escena, no para el juego entero.

     T4  ¿cuánto CUESTA el pack en FPS? ...................... ABIERTA
         Los números de OSD de la corrida del 2026-09-02 (GS 22,3 %,
         29,93 fps) NO valen: fue SIN TURBO y bajo el cap nada se ve. Falta
         el A/B pareado con turbo, método de R3 (`F6`/`F5`).

     T5  el síntoma "mejor de lejos que de cerca" ................ CERRADA
         **CAUSA CONFIRMADA POR EFECTO, fase V3, 2026-09-04.** Es el MIPMAP,
         atado al ÁNGULO, no a la distancia: el pack reemplaza sólo el mip 0
         (0 de 8225 con `-mip`), y en ángulo oblicuo el GPU pedía mip 1-2-3,
         que caía al original de PS2. `mipmap=false`+`hw_mipmap=false` (con
         ReShade apagado, verificado por efecto): Fran, mirando el savestate
         03, "se ve nítida en los dos ángulos". Las dos hipótesis alternativas
         (H1 carga asíncrona, H4 post-proceso) MUERTAS antes, cada una con su
         control. Detalle: `docs/09` §7.5.
         **CORRECCIÓN del 2026-09-04 (fase V4):** el HECHO sigue en pie
         —apagar el mipmapping arregla el síntoma— pero el MECANISMO que
         esta línea propone es el equivocado. No es que el GPU pida un mip
         que el pack no trae: es que al activar el mipmapping **cambia el
         hash con el que PCSX2 busca el reemplazo**, no lo encuentra, y
         dibuja el original de PS2 entero, mip 0 incluido. Ver T7.

     T6  el arreglo de fondo (mip chain real) ................... CERRADA
         **NO ERA LA CAUSA, y por eso no cambio nada en pantalla.** El mip
         chain se construyo bien (`herramientas/regenerar_mipmaps.py`,
         verificado por bytes 8225/8225 y por pixel) y aun asi el sintoma
         volvio, porque **el archivo arreglado no se abria nunca**. Ver T7.
         Lo que si dejo: `-mip%u` es convencion de VOLCADO EN PNG
         (`GetDumpFilename`), NO de carga de DDS — para DDS los mips van
         EMBEBIDOS en el mismo archivo (`dwMipMapCount` del header). Y el
         verificador de la herramienta, que nunca habia visto un archivo roto,
         **ya vio dos** (truncado y `dwMipMapCount` mentiroso): dijo FALLOS en
         los dos, con los sanos en verde. Detalle: `docs/09` S7.6 y S7.7.

     T7  LA CAUSA RAIZ: el HASH cambia con el mipmapping ........ CERRADA
         **CONFIRMADA POR CODIGO Y POR EFECTO, fase V4, 2026-09-04.**
         `GSTextureCache::HashCacheKey::Create` hashea el nivel base y, **si
         hay `lod`, tambien todos los niveles de mip del juego**; el
         `CLUTHash` en cambio NO depende de `lod`. O sea: una misma textura
         tiene DOS `TEX0Hash`, y el pack de 2022 (volcado sin mipmapping)
         solo trae el de sin-mipmap. Al poner `hw_mipmap = true`, PCSX2 pide
         un nombre que no existe, no encuentra reemplazo y **dibuja el
         original de PS2**. Medido en la misma escena: **37 texturas sin
         reemplazo con `hw_mipmap = true` contra 5 con `false`**.
         ARREGLO: `herramientas/puente_hash_mipmap.py` empareja por
         `(CLUTHash, TEX0 bits enmascarado)` y escribe COPIAS del pack con el
         nombre nuevo; no borra ni modifica nada. 35 de 38 emparejadas.
         VERIFICADO POR EFECTO: los volcados bajaron de **37 a 3** (las 3 no
         emparejadas), y con el pack de diagnostico de color los pixeles de
         nivel 1 pasaron de **0 a 10.929** — o sea que el mip chain de T6
         **si se usa**, recien ahora. Detalle: `docs/09` S7.7.
         ABIERTO: la verificacion visual de la CALIDAD (las dos tandas A/B/C
         se descartaron: control positivo roto por el humo de la escena), y
         extender el puente a todo el juego, que **requiere jugar**.
         **2026-09-04, instalado Huekage + puente (§7.8):** Huekage (100% de
         cobertura en `hw_mipmap=false` contra 92,7% del pack 2022) es ahora
         el `replacements/` activo. Su puente empareja MENOS (18/38, no
         35/38 — menos claves unicas en el pack). Confirmado por efecto: las
         18 emparejadas dejan de faltar en un volcado de 80s (interseccion
         0). A/B/C con control obligatorio, dos rondas: solo "auto
         izquierdo" cerro el control las dos veces (+1%/+1%, -2%/-3%), sin
         costo de nitidez ahi — tercera medicion en la misma direccion que
         T7. La region "barrera" (el sintoma) sigue sin poder medirse: el
         humo/combate de esa escena nunca dio un control limpio ahi, en
         ninguna sesion. `hw_mipmap` vuelve a `false` al cerrar (mismo
         motivo: el puente cubre una sola escena). Detalle:
         `pruebas/huekage-puente-verificacion-2026-09-04.md`.

     T8  la sesion PUEDE ver la pantalla de PCSX2 .............. CERRADA
         PCSX2 escribe sus propias capturas (`Screenshot = F8` ->
         `Documents\PCSX2\snaps\`) y `herramientas/pcsx2_teclado.ps1` le
         lleva el foco a la ventana del juego y manda la tecla. Creer lo
         contrario costo la fase entera de S7.6. Ojo: PCSX2-Qt tiene DOS
         ventanas y `MainWindowHandle` de .NET devuelve la **de registro**,
         que no procesa hotkeys (`herramientas/pcsx2_ventanas.ps1` las lista).

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
| **El stream de módulos del nivel: `0x01092800 = {count=857, array=0x0109F590}`**, 41 tipos distintos, registros de `0x10` | dos derivaciones independientes dan 857: el `count` leído y el largo por monotonía del puntero. Los blobs teselan `0x010928B0`–`0x0109F540` sin solaparse. `stream_modulos.py autotest` |
| **Layout del registro: `+0x00` tipo, `+0x04` blob (tamaño variable), `+0x08` ID64 DEL NOMBRE** — `+0x08` NO es una posición | los id64 decodifican a `GP0101001527`, `LW0001781`, `SQTOM`, `SD0101000007`. `FUN_00174430` (tipos `0x03`–`0x09`) deferencia `param_3+4` como su struct |
| **Tipo `0x2D` = objeto de física registrado en el pathfinding** (256 instancias en LEVEL_00) | su handler `FUN_00175980` referencia `0x003F54A0`: `'Physics object %s tagged for Pathfinding collision…'`. **Evidencia de lectura, no de efecto** |
| **El registro que llena el `0x2D` tiene 48 ranuras (`0x30`), NO 256, y en los 9 volcados está VACÍO (0/48)** — vive en `0x004CB1C8` = `*(0x0040F4D4) + 0xA48` | topes de `FUN_00175BF0`/`FUN_00175C30`; base del sitio de llamada `0x0015F794`+delay slot; cabecera de 16 punteros con paso uniforme `0x500` como control positivo. `registro_fisica.py autotest` |
| **El despachador llama al handler del `0x2D` sólo si `blob[0x1E] == 1`: pasan 4 de 256** (`LW0001910/911/913/931`) | `lbu v1,0x1E(v0); bne v1,1` en `0x0015F780`. Reparto: 250 en `0x00`, 4 en `0x01`, 2 en `0x02` |
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
| **EL ARMA DEL ENEMIGO SE FIJA EN `0x006E18B8 + n*0x24 + 0x04`** — puntero al bloque de IA (`registro+0xC0`) del registro de arma. Array de **50** entradas, paso `0x24`, base real **`0x006E18B0`** (la base vieja es `entrada_0+0x08`: coincide entrada por entrada, offsets corridos 8). `n` es sólo el primer slot libre, no un id. `+0x00` es el puntero al bloque del jugador (`registro+0x90`) | **2026-08-17, confirmado por efecto con DOS observables: escalón de daño 105→106 y cadencia 133 ms→3534 ms, las dos coincidiendo con el registro 6 (`Power` 106, `TBB` de IA 3.500 s). Series en `volcados/e4-D-marcado.csv` y `volcados/e4-F-bloque-ia.csv`** |
| **EL ARMA SE ELIGE POR NOMBRE, NO POR ÍNDICE.** `slot_0x110+0xEC` (el descriptor) lo escribe **una sola instrucción, `0x00156318 sw $v0,0xEC($s0)`** en `FUN_00156278`, con el valor `directorio_armas[b]+0x08` (17 registros de `0x20` en `0x01842090`). El byte `b` **no está guardado en ningún lado**: los 5 llamadores de `FUN_0015cef0` barren los 17 comparando el **id64** de `rec+0x00`. Nombres: `BG1_PST SHG SNR SMG ASR AK1 RPG GRL SM3 P90 HVY MGN M16 RM1 GK1 MP1 BNS` | **2026-08-23, en frío, bitácora (35). 54 accesos a `+0xEC` en el subsistema y UN solo store. Control positivo sobre `ee-e4.bin`: 8/8 slots predichos exacto desde `slot+0x00`, y `b=0x05` → `0x01842C10`, el descriptor medido en la (33). Cruces no buscados: `b=0x05`=`BG1_AK1` y `b=0x00`=`BG1_PST`** |
| **EL ARMA DEL ENEMIGO SÍ SE PUEDE FIJAR DESDE EL ISO** — la pregunta abierta desde 7a. Son 8 bytes: el id64 literal de `BG1_AK1` en `FUN_0015ef48` case `0x0A`, o la lista de assets del nivel (`dir_recursos_arma_stlevel`, 7 registros de `0x28` en `STLEVEL+0x80`). Un arma nueva tiene que estar EN esa lista; **`bg1_rpg` ya está en LEVEL_00**, así que AK1→RPG no requiere tocar el nivel | **2026-08-23, por lectura. Literal `0x5446127297C60000` en el `.text`, decodificado con `id64.py`. Falta la confirmación POR EFECTO: el parche no se hizo todavía** |
| **El nivel tiene un ÍNDICE DE MÓDULOS**: stream de registros de `0x10` `{u32 tipo, u32 ptr, u64 payload}`, y `FUN_0015ef48` es su dispatcher con **61 casos, tipos `0x03`–`0x44`**. El case `0x0A` es el spawn de personaje | **2026-08-23, leído en Ghidra — `probable`, no ejecutado. El case `0x0A` sí está confirmado por otra vía: lleva el literal `BG1_AK1` y los cinco enemigos tienen justo ese descriptor** |
| **EL BLOQUE DE IA NO SE ELIGE: ES EL DESCRIPTOR DE ARMA `+0x30`, FIJO** — lo escribe `FUN_00158F50` en `0x00159008` (`addiu $4,$16,0x30`) para todo NPC; el jugador (`*(*(slot+0xF0)+0xC4)==2`) usa el descriptor sin desplazar. El descriptor le llega de `slot_0x110+0xEC` vía `FUN_0015D060`. El pool cuelga del manager `0x005AE880` ← global `.bss` `0x0040F4E0` | **2026-08-22, en frío sobre el ELF, bitácora (34). Dos vías independientes convergen en `FUN_0015C970` (cadena de punteros, y búsqueda de `addiu rX,rX,0x24`), y dos controles positivos pasivos cierran contra `volcados/ee-e4.bin`: `entrada+0x00 == 0` y `0x006DE784 == 0x006E18B0`** |
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
