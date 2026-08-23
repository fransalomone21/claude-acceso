# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-23**, PC, **en frío** (el emulador no se abrió).
**7e — PASO 1 CERRADO.** El layout del registro está **verificado contra datos**
y salió **corregido**, y **el stream mixto apareció**: `0x01092800 =
{count=857, array=0x0109F590}`. Lo que faltaba no era esfuerzo: era el
**parámetro de búsqueda**.
**7e sigue ABIERTA.** Lo que falta —identificar los tipos y verificar uno por
efecto— **necesita el emulador**, y ahí es donde entra la próxima sesión.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/kb/stage-modulos.json` — **entero**. Es el entregable acumulado: los
   61 tipos con su handler, más lo medido en esta sesión (instancias en
   LEVEL_00, tamaño de blob, familia de nombre, muestra de nombres).
2. `black/ESTADO_ACTUAL.md`, sólo el bloque **7e** de N2 y las **tres primeras
   filas** de la tabla de hechos (son las nuevas).
3. `black/docs/03-bitacora.md`, **sólo la entrada (36)**.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, las entradas (29)–(35), y nada de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**7e — el índice de módulos del nivel.** Sigue abierta.

**Cierra cuando** los tipos estén identificados en `kb/stage-modulos.json` —qué
estructura consume cada uno y qué subsistema toca— **y con al menos un tipo
distinto del `0x0A` verificado POR EFECTO.** Esa segunda mitad **requiere el
emulador**: en frío no se puede cerrar, y conviene decirlo de entrada en vez de
descubrirlo a mitad de sesión.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

### 3.1 El layout, VERIFICADO CONTRA DATOS (era el paso bloqueante)

```
+0x00  u32  tipo    el case del switch de FUN_0015ef48
+0x04  u32  ptr     BLOB DE DATOS del modulo, TAMANO VARIABLE
+0x08  u64  id64    NOMBRE DEL MODULO      <-- CORRECCION, no es una posicion
```

La `kb` decía que `+0x08` se usaba **como posición**. **Es el id64 del nombre** y
decodifica con `herramientas/id64.py` a nombres reales: `GP0101001527`,
`LW0001781`, `SQTOM`, `SD0101000007`, `FX0101000004`, `WD0101000012`.

`param_2` = `{u32 count en +0x00, u32 array en +0x04}`, confirmado en la
decompilación **y** contra datos.

### 3.2 Quién arma `param_2` — `FUN_0012dab8` (`0x0012DAB8`)

```c
FUN_0015ef48(piVar4 + 0x10,               // arrays de handles
             *(u32 *)(piVar4[4] + 4),     // param_2: DOBLE INDIRECCION
             piVar4[1], *(u8 *)((int)piVar4 + 0x39));
```

`piVar4` es un sub-bloque de `base+0x4990` y `base+0x5210`: **dos slots de
`0x880` que alternan** (`*(u8*)(iVar5+0x5aae) ^= 1`, en `FUN_00129360`) — el
cargador de nivel está **doble-buffereado**. Tag de estado: `*piVar4 == 0x1C`.

### 3.3 El stream, encontrado

**`descriptor 0x01092800 = {count=857, array=0x0109F590}`**, 41 tipos distintos.
La racha "pura de `0x2D`" que vio la sesión anterior era un **tramo de adentro**
de este mismo array.

**Control positivo, dos caminos independientes:** el `count` **leído** del
descriptor = 857, y el largo del array **derivado por monotonía del puntero**,
sin mirar el descriptor = 857. Los blobs **teselan** `0x010928B0`–`0x0109F540`
sin solaparse (16–192 B) y el array arranca 80 bytes después.

### 3.4 Lo que dicen los nombres

| familia | tipos | qué sugiere |
|---|---|---|
| `SQTOM`, `SQMATT` | `0x01`, `0x02` | **escuadra** — cruza con la tabla de 7 punteros de `0x003BD3F8` (`None/Low/Mid/High/Matt/Tom/Carrie`), hallada por otra vía el 2026-08-21 |
| `LW0001xxx` | `0x2D` (256) | **objeto de física / pathfinding** |
| `SD0101xxxxx` | `0x2E`, `0x2F`, `0x30` | sonido (hipótesis, sólo por el prefijo) |
| `WD0101xxxxx` | `0x1F`, `0x20`, `0x43` | sin identificar |
| `FX0101000004` | `0x33` | efecto (hipótesis, sólo por el prefijo) |
| `GP01010xxxxx` | el grueso | el contenido del nivel |

**Tipo `0x2D` nombrado**: su handler `FUN_00175980` referencia `0x003F54A0` =
`'Message to Level Designer / Physics object %s tagged for Pathfinding
collision has been removed without reexporting the world view'`. **Es evidencia
de LECTURA, no de efecto.**

**Tamaño de blob = tamaño de la struct.** Fijo en 20 de los 38 tipos con
instancias: `0x1C`/`0x1D`=16 B · `0x1A`/`0x1F`/`0x20`/`0x2B`/`0x44`=32 ·
`0x01`/`0x02`/`0x14`/`0x18`/`0x23`/`0x29`/`0x2E`/`0x38`/`0x3D`=48 ·
`0x2F`/`0x33`/`0x39`=64 · `0x43`=80 · `0x32`=96 · `0x3B`=160 · `0x30`=192.
Todo está en `kb/stage-modulos.json`, por tipo.

### 3.5 Sigue valiendo de antes, y no se toca

Todo 7d (el arma se elige **por nombre**/id64; `0x00156318 sw $v0,0xEC($s0)`;
`directorio_armas` = 17 registros de `0x20` en `0x01842090`; **sí se puede fijar
desde el ISO, 8 bytes**). Todo 7c (`FUN_00158F50`, bloque de IA =
descriptor+`0x30` fijo en `0x00159008`, pool `0x006E18B0`, global `.bss`
`0x0040F4E0`). `+0x78` = modelo **visual** del arma. `entidad+0x58` = registro
de personaje. El parche de ISO in-place **anda** (3 veces confirmado).

## 4. LO QUE SIGUE, CONCRETO

```
cd C:\Users\frans\Desktop\claude-acceso\black
python herramientas/ubicaciones.py
python herramientas/decompilar.py info
python herramientas/stream_modulos.py autotest
python herramientas/stream_modulos.py resumen 0x01092800
```

**Vía A — cerrar 7e por efecto. NECESITA EL EMULADOR.** El candidato más barato
es el **`0x2D`** (256 instancias, física/pathfinding): es el tipo con más
instancias y el único nombrado. El stage se carga **literal** en RAM, así que la
prueba se hace **en RAM, reversible**, y recién después va al ISO. Observable a
elegir antes de tocar nada (regla: escribir la predicción primero).

**Vía B — las dos puntas sueltas, que son datos, no fallas:**
1. **CERO registros `0x0A` en el stream**, y LEVEL_00 tiene cinco enemigos. El
   `0x0A` sigue confirmado por 7d, pero **no sale de este stream**. Hay un
   segundo stream (ya liberado) o los enemigos entran por otro lado.
   `stream_modulos.py buscar` sobre un volcado tomado **más temprano en la
   carga** contestaría esto.
2. **El `switch` no es el esquema del archivo entero.** `0x01`, `0x02` y `0x33`
   están en los datos y **no** entre los 61 casos: caen en el `default`. Es el
   esquema de lo que *este* dispatcher construye.

**Vía C — validar 7d por efecto (barata, no bloquea, sigue pendiente):**
parchear el literal `0x5446127297C60000` (`BG1_AK1`) por el de `BG1_RPG` con
`herramientas/parche_iso.py`. Esta sesión **confirmó de rebote la premisa**:
`0x01412400` tiene la lista de recursos de arma del nivel y **`bg1_rpg` está
ahí**. `python herramientas/id64.py codificar BG1_RPG`. Modo de falla esperado:
`'AI gun model not found: %s'` (`0x003F4848`).

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 NO está corriendo** y no se abrió en toda la sesión. Ejecutable
  correcto (NO el de Program Files):
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  Lanzador: `C:\Users\frans\Desktop\BLACK\ABRIR-BLACK-MOD-7B.bat`
- **RAM LIMPIA, cero parches vivos.** La sesión **no escribió un solo byte** ni
  en memoria ni en ningún ISO. Toda lectura en frío sobre el ELF y sobre
  `volcados/ee-e4.bin`.
- **Ningún ISO se tocó.** El nop de vida infinita de `0x0013BD20` sigue
  restaurado (`0xE65402F8`).
- Controles positivos en verde al abrir: `ubicaciones.py` **13/13**,
  `decompilar.py info` (9842 funciones, control sobre `0x00142B90`),
  `barrer.py autotest`, `id64.py autotest` (13 casos).
- Se pierde al reiniciar el emulador: cualquier parche escrito en RAM. Los ISO
  parcheados sobreviven.

**Herramientas nuevas, las dos con autotest PROBADO EN ROJO:**
- `herramientas/stream_modulos.py` — `buscar` / `resumen <desc>` /
  `listar <desc> --tipo 0xNN` / `autotest`. 5 casos y 2 sabotajes.
- `herramientas/tipos_modulo.py` — `cadenas <addr>` / `barrer` / `autotest`.
  1 caso y 3 sabotajes. **Rinde poco** (ver §6.5): queda, pero no es palanca.

## 6. LAS TRAMPAS YA PAGADAS — no volver a pagarlas

1. **Una búsqueda que da CERO acusa al PARÁMETRO, no al mundo.** Es LA lección
   de esta sesión, y ya está foldeada en `chequeo-de-trabajo.md` del perfil
   global. La sesión anterior concluyó "el stream mixto no apareció; se libera
   después de procesarse" — y estaba en RAM todo el tiempo. Un cero se lee como
   respuesta negativa en vez de como falla del instrumento, y por eso es **más
   peligroso** que "demasiados candidatos". **Cambiar el EJE, no aflojar el
   umbral del mismo eje**: pedile al objeto una invariante que cumpla **por cómo
   está construido**. Medido: por rango de tipo, **817** rachas de basura con la
   buena partida en pedazos; por monotonía del puntero, **3** y una real.
2. **`capstone` no sirve** para el `.text` del EE. Ya está resuelto:
   `herramientas/barrer.py`.
3. **Un xref sobre heap siempre da 0.** `.bss` termina en `0x0049BFBC`;
   `decompilar.py info` lista las secciones.
4. **El parámetro que sirve es el que DISCRIMINA**, no el barrido con más
   esfuerzo. Cuatro casos medidos ya: `sw {4,8,C}`→339; `addiu 0x24`→32; stores
   a `+0xEC`→1; y ahora monotonía del puntero→3.
5. **Nombrar handlers por las cadenas que referencian rinde poco.** Se barrieron
   los 70 handlers: **sólo `FUN_00175980` tiene cadena**. Son constructores
   finos y las cadenas viven en los callees. La herramienta queda hecha; la
   palanca está en otro lado (los nombres id64 y los tamaños de blob).
6. **No suponer que una dirección conocida es la que la cadena pide.**
   `0x01412400` (STLEVEL.BIN cargado) **no** es `piVar4[4]`; es una cabecera de
   pares `{count, ptr}` cuyo primer array es la lista de recursos de arma.
7. **Heredocs largos** en la Bash tool fallan. >~30 líneas: escribir el `.py`
   con Write y correrlo. El `cwd` se resetea entre llamadas: rutas absolutas.
8. **`comando | tail` devuelve el exit code de `tail`.** Para medir que un
   verificador sale en rojo: `cmd > archivo 2>&1; echo $?`, sin pipe.

## 7. PENDIENTES QUE NO SON DE LA FASE

- **BLACK a 10 fps en el menú, y el apagado del 2026-08-22.** Es entorno: **no
  mezclarlo con 7e.** Ya medido: **evento 1074** lanzado por
  `SysWOW64\shutdown.exe` — apagado **ordenado**, **cero Kernel-Power 41**, o
  sea "térmico o alimentación" **refutado por medición**. Hipótesis viva: el
  cambio a GPU discreta conmuta MSHybrid↔Discrete y el panel del fabricante lo
  aplica llamando a `shutdown.exe`. **Criterio de salida, dos minutos:** reabrir
  BLACK ahora que el modo discreto quedó aplicado y medir los fps en el **mismo**
  menú.
- **Fase 5a — pnach sobre `0x00142CA0`** (daño de salida del jugador).
  **PARQUEADA a propósito**, lista para cuando Fran vuelva al emulador.
