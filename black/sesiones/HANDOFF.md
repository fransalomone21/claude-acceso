# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-23**, PC, **en frío sobre el ELF** (el emulador
no se abrió en ningún momento).
**7d CERRADA, con respuesta afirmativa.** El arma **se elige por NOMBRE**
(id64), no por índice — y **sí se puede fijar desde el ISO**, en 8 bytes. Eso
cierra la pregunta que venía abierta desde 7a.
Lo que sigue (**7e**) salió de una pregunta de Fran a mitad de sesión y es de
más apalancamiento que todo lo anterior: **el nivel tiene un índice de
módulos**, y está enumerado en un `switch` de 61 casos.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — el bloque **7d/7e** en N2 y las **tres primeras
   filas** de la tabla de hechos (son las nuevas).
2. `black/docs/03-bitacora.md`, **sólo la entrada (35)**. Tiene la cadena
   completa con direcciones; la (34) ya está resumida acá abajo.
3. `black/kb/rutinas.json`, las cuatro entradas nuevas: `arma_slot_constructor`,
   `arma_indice_desde_tabla`, `arma_resolver_por_nombre` y
   **`stage_stream_dispatcher`** (ésta es la de 7e).

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, las entradas (29)–(34), y nada de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**7e — el índice de módulos del nivel.** El stage es un **stream de registros
tipados de `0x10` bytes** `{u32 tipo, u32 ptr, u64 payload}`, precedido por
`{u32 count, u32 array}`. **`FUN_0015ef48` (`0x0015EF48`–`0x0015FDBF`) es su
dispatcher: 61 casos, tipos `0x03`–`0x44`.** Ese `switch` **es el esquema del
archivo de nivel**: una rama por tipo de módulo.

**Cierra cuando** los 61 casos estén traducidos a un esquema en `kb/` que diga,
por cada tipo, qué estructura consume y qué subsistema toca — **y con al menos
un tipo distinto del `0x0A` verificado por efecto**, para que el esquema no
quede en papel.

**Por qué ésta y no otra:** es la jugada de flujo de información, no de más
esfuerzo. Hasta ahora, cada cosa que se quiso tocar costó subir la cadena de
llamadas eslabón por eslabón (7a→7d fueron cuatro sesiones para un campo). El
índice contesta de una sola vez qué puede contener un nivel. Sirve igual a la
Fase 6 (exprimir el ISO) que a la 7.

**Lo ya anclado del dispatcher:** el case `0x0A` es el **spawn de personaje**, y
está confirmado por otra vía — es el que lleva el literal `BG1_AK1`, y los cinco
enemigos de LEVEL_00 tienen justo ese descriptor. Ése es el ancla desde la que
se leen los demás casos.

**Fase paralela y barata, no bloquea a 7e:** el experimento **AK1 → RPG** sobre
el literal del ELF. Valida por efecto la respuesta de 7d, que hoy es sólo
lectura. Ver §4.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

**7d, la cadena entera:**

```
FUN_00156278 (constructor del slot de 0x110)
   0x00156318  sw $v0, 0xEC($s0)     <-- LA instruccion. Unico store a +0xEC
                                          en 0x00155000-0x0015D200 (54 accesos,
                                          53 loads)
   slot+0xE8 = FUN_0015d210(mgr,b) =        *(*mgr+4) + b*0x20
   slot+0xEC = FUN_0015d228(mgr,b) = *(u32*)(*(*mgr+4) + b*0x20 + 8)
   slot+0x00 = b   (el indice, un BYTE)
   ...3 instrucciones despues: FUN_0015d060, que lee ese +0xEC (fase 7c)
```

- **`directorio_armas` = 17 registros de paso `0x20` en `0x01842090`**, conteo
  en `*(u8*)(*mgr+1)` = 17. `rec+0x00` = **id64 del nombre** (u64);
  `rec+0x08` = **el descriptor de arma**.
- **El arma se elige POR NOMBRE.** `b` no está guardado en ningún lado: los
  **cinco** llamadores de `FUN_0015cef0` barren los 17 registros comparando el
  id64 de `rec+0x00` contra un u64 y usan el índice que matchea; `0xFF` si no
  matchea ninguno.
- Los 17 nombres: `BG1_PST SHG SNR SMG ASR AK1 RPG GRL SM3 P90 HVY MGN M16 RM1
  GK1 MP1 BNS` (índices `0x00`–`0x10`, en ese orden).
- **Las cuatro fuentes del nombre:**
  - `FUN_00139c68` → `entidad+0x3C0` (primaria) y `+0x3C8` (secundaria). Es el
    camino del **jugador**.
  - `FUN_0015ef48` case `0x0A` → literal **`0x5446127297C60000` = `BG1_AK1`,
    hardcodeado en el `.text`**. Es el camino de **los cinco enemigos**.
  - `FUN_001784f0` → literal `0x54461524B8230000` = `BG1_SNR`.
  - `FUN_0015c3c8` → `b` directo desde `*(iVar6+0x44)`: es re-arme/pickup, no
    spawn.
  - Cadena data-driven: `FUN_00178978`/`FUN_00178ae8` →
    `FUN_00178bc0(param_7)` → `descriptor+0x28` → `FUN_00138c80` →
    `FUN_001327f0(param_5)` → `FUN_0015cef0`.
- **Control positivo cumplido:** 8/8 slots de `ee-e4.bin` predichos exacto, y
  `b=0x05` → `0x01842C10`, el descriptor que la (33) había medido en RAM. Dos
  cruces que no se buscaban: `b=0x05` = `BG1_AK1` (los enemigos llevan AK) y
  `b=0x00` = `BG1_PST` (el jugador arranca con pistola).
- **`directorio_armas` pasó de `probable` a `confirmado`** en
  `kb/mapa-memoria.json`, y se corrigió su dirección: `0x01842084` era el
  **puntero** a la tabla; la tabla está en `0x01842090`.

**Sigue valiendo de antes, y no se toca:** todo lo de 7c (`FUN_00158F50`, el
bloque de IA = descriptor+`0x30` fijo en `0x00159008`, el pool `0x006E18B0` de
50 entradas de `0x24`, `n` no significa nada, la cadena hasta la global `.bss`
`0x0040F4E0`); `+0x78` = modelo **visual** del arma; `+0x8C` y `+0xA8`
descartados por lectura; `entidad+0x58` = registro de personaje (paso `0xB0`);
el parche de ISO in-place **anda**, confirmado tres veces.

**Herramienta nueva, ya en el repo: `herramientas/barrer.py`.** Es el
decodificador manual del `.text` (el que reemplaza a capstone) convertido en
herramienta, con autotest. **La alarma está probada rompiéndola**: se saboteó de
dos formas independientes (un dato esperado falso, y el decodificador corrompido)
y **sale con código 1 en las dos**; sana, sale 0.

```
python herramientas/barrer.py autotest
python herramientas/barrer.py off 0xEC --desde 0x00155000 --hasta 0x0015D200
python herramientas/barrer.py imm 0x24 --op addiu
```

## 4. LO QUE SIGUE, CONCRETO

```
python herramientas/ubicaciones.py          # control positivo del entorno
python herramientas/decompilar.py info      # control positivo de Ghidra
python herramientas/barrer.py autotest      # control positivo del barredor
```

**Vía A — 7e, el índice de módulos (es la fase).** El paso 1 YA ESTÁ HECHO y
está en **`kb/stage-modulos.json`**: los 61 tipos con su handler, `0x03`–`0x44`,
**45 handlers distintos** (los tipos `0x03`–`0x08` caen por fall-through en el
mismo `FUN_00174430` que el `0x09`). Empezar por ahí, no por decompilar de nuevo.

1. Identificar handlers: `decompilar.py c <handler>` y ver qué construye. Los
   45 son independientes entre sí — es el único tramo de toda la fase 7 que
   admitiría paralelizar, si alguna vez el presupuesto lo banca.
2. **La pregunta abierta que hay que resolver primero:** el layout del registro
   (`{u32 tipo, u32 ptr, u64 payload}`, paso `0x10`) está **leído, no verificado
   contra datos**. Un barrido de `ee-e4.bin` buscando rachas de registros con
   tipo en `0x03`–`0x44` dio: (a) tres rachas **puras de tipo `0x2D`** con id64
   reales — 246 registros desde `0x0109F7D0`, nombres `LW0001781`, `LW0001324`…
   — que **encajan** con el layout; y (b) falsos positivos en `.data` que son
   contadores secuenciales `0x03,0x04,0x05…`. **El stream MIXTO no apareció.**
   Dos hipótesis: se libera después de procesarse, o el layout es otro. Se
   decide mirando `FUN_0012dab8` (`0x0012DAB8`), que es quien arma `param_2`.
3. Anclar contra el nivel real: el stage de LEVEL_00 está cargado literal en
   **`0x01412400`** dentro de `volcados/ee-e4.bin`.
4. El case `0x0A` ya está resuelto y es el ancla: es el único tipo confirmado.
5. **Para cerrar hace falta un tipo verificado POR EFECTO**, no sólo leído.

**Vía B — validar 7d por efecto (barata, no bloquea):** parchear el literal
`0x5446127297C60000` (`BG1_AK1`) por el de `BG1_RPG` en el ELF dentro del ISO,
con `herramientas/parche_iso.py`. **`bg1_rpg` ya está en la lista de assets de
LEVEL_00**, así que no hay que agregarle nada al nivel. El id64 nuevo sale de
`python herramientas/id64.py codificar BG1_RPG`. Observable: los enemigos de
LEVEL_00 llevan RPG. Modo de falla esperado si el arma NO estuviera cargada:
el mensaje `'AI gun model not found: %s'` (`0x003F4848`), que ya está en `kb/`.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 NO está corriendo** y no se abrió en toda la sesión. Ejecutable
  correcto (NO el de Program Files):
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  Lanzador: `C:\Users\frans\Desktop\BLACK\ABRIR-BLACK-MOD-7B.bat`
- **RAM LIMPIA, cero parches vivos.** La sesión **no escribió un solo byte** ni
  en memoria ni en ningún ISO: fue toda lectura en frío sobre el ELF y sobre
  `volcados/ee-e4.bin`.
- **Ningún ISO se tocó.** `Black-mod-7b.iso` y `Black-mod-armas.iso` como
  estaban. El nop de vida infinita de `0x0013BD20` sigue restaurado
  (`0xE65402F8`).
- `ubicaciones.py` **13/13** y `decompilar.py info` en verde (9842 funciones,
  control positivo sobre `0x00142B90` pasa). `barrer.py autotest` en verde.
- **El emulador no hace falta para 7e.** `volcados/ee-e4.bin` (32 MB, con el
  stage de LEVEL_00 cargado en `0x01412400`) ya está commiteado, y
  `decompilar.py estado` mete el savestate adentro de Ghidra sin PCSX2.
- Se pierde al reiniciar el emulador: cualquier parche escrito en RAM. Los ISO
  parcheados sobreviven.

## 6. LAS TRAMPAS YA PAGADAS — no volver a pagarlas

1. **`capstone` no sirve para desensamblar el `.text` del EE de corrido.** Con
   `CS_MODE_MIPS32` se detiene a las 2 instrucciones en el primer opcode propio
   del R5900. **Ya no hay que reimplementar el decodificador a mano: está en
   `herramientas/barrer.py`.**
2. **Un xref sobre una dirección de heap siempre da 0.** Antes de gastarlo,
   mirar si cae dentro de alguna sección (`decompilar.py info` las lista).
   `.bss` termina en `0x0049BFBC`.
3. **El parámetro de búsqueda que sirve es el que DISCRIMINA.** No es un barrido
   con más esfuerzo. Tres casos medidos: `sw` con offsets `{4,8,C}` → 339
   candidatos, inútil; `addiu rX,rX,0x24` → 32, y cerró 7c; stores a `+0xEC` en
   el subsistema → **1**, y cerró 7d. Si un barrido devuelve decenas, el
   problema es el parámetro. `barrer.py` avisa solo cuando pasa de 40.
4. **Un campo sin ningún store con ese inmediato en todo el `.text` no es un
   misterio: es una copia en bloque.** `entidad+0x3C0` se lee con `ld` en dos
   lugares y **no tiene un solo `sd`** — de 32 accesos al inmediato `0x3C0`, los
   únicos stores son spills de `$sp`. Buscar "quién lo escribe" ahí habría dado
   cero y no habría sido un bug.
5. **Antes de subir la cadena de llamadas eslabón por eslabón, preguntar si el
   sistema tiene un índice.** Es la lección que dejó esta sesión, y la trajo
   Fran, no el método. Ver §7.
6. **Heredocs largos con `<<'EOF'` en la Bash tool fallan** ("unexpected EOF")
   cuando el cuerpo es grande o tiene comillas mezcladas. Para scripts de más de
   ~30 líneas: escribir el `.py` con la herramienta Write y después correrlo.
   Y ojo con `cd` en comando compuesto: el cwd se resetea entre llamadas, así
   que las rutas relativas a `black/` hay que rehacerlas cada vez.
7. **`comando | tail` devuelve el exit code de `tail`, no del comando.** Si lo
   que se está midiendo es que un verificador salga en rojo, hay que medir el
   código de salida sin pipe (`cmd > /dev/null 2>&1; echo $?`). Pasó en esta
   misma sesión al probar el sabotaje de `barrer.py`: mostraba `EXIT=0` con el
   test en rojo.

## 7. PENDIENTES QUE NO SON DE LA FASE

- **BLACK a 10 fps en el menú, y el apagado del 2026-08-22.** Es entorno, no
  ingeniería reversa: **no mezclarlo con 7e.** Ya medido, no repetir: el apagado
  fue un **evento 1074** lanzado por `SysWOW64\shutdown.exe` — apagado
  **ordenado**, **cero Kernel-Power 41**, o sea "térmico o alimentación" queda
  **refutado por medición**. Hipótesis viva: el cambio a GPU discreta conmuta
  MSHybrid↔Discrete y el panel del fabricante lo aplica llamando a
  `shutdown.exe`. **Criterio de salida, dos minutos:** reabrir BLACK ahora que
  el modo discreto quedó aplicado y medir los fps en el **mismo** menú. Si
  suben, las dos cosas eran un solo problema.
- **Fase 5a — pnach sobre `0x00142CA0`** (daño de salida del jugador).
  **PARQUEADA a propósito**, lista para cuando Fran vuelva al emulador.
