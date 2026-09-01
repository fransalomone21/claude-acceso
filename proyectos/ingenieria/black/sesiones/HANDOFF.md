# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

**Dos líneas de trabajo activas en paralelo, independientes entre sí:**
- **7e** (reversing, secciones 1-7 de este archivo) — intacta, nadie la tocó
  esta sesión.
- **BLACK Remaster / DLSS5, R0** (sección **8**, nueva) — abierta, sin medir
  todavía ninguna de las 3 casillas.

Si retomás 7e: las secciones 1-7 siguen siendo la fuente. Si retomás el
Remaster: andá directo a la sección 8.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/kb/stage-modulos.json` — **entero**. Es el entregable acumulado: los
   61 tipos con handler, instancias, tamaño de blob, familia de nombre, el
   `sitio_de_llamada` de cada uno, y **de esta sesión** las claves
   `_pools_p1_medidos` y `_el_0x34_no_usa_indice_fijo`.
2. `black/kb/pools-p1.json` — la medición de los 18 pools, cruda.
3. `black/docs/03-bitacora.md`, **sólo las entradas (39) y (38)**.
4. `black/ESTADO_ACTUAL.md`, sólo el bloque **7e** de N2.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, las entradas (29)–(37), y nada de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**7e — el índice de módulos del nivel.** Sigue abierta, **por la mitad (b)**.

- **(a) los tipos identificados: HECHO el 2026-08-29, y desde el paso 3b
  MEDIDO, no sólo leído.** Los 61 tipos despachados tienen destino, contador,
  acción y argumentos; y el modelo de "array de handles" está confirmado por
  medición contra el volcado, 17/18 predicciones exactas.
- **(b) al menos UN tipo distinto del `0x0A` verificado POR EFECTO: FALTA.**
  **Necesita el emulador**, y necesita que Fran juegue hasta cargar el nivel.
  **Fran autorizó abrir el emulador el 2026-08-29.**

**Cierra 7e** cuando un módulo concreto, elegido a propósito, deje de
construirse (o cambie) por un parche escrito **antes** de mirar, y eso se vea
en un observable declarado de antemano.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

### 3.1 `P1` está MEDIDO. `piVar4 = 0x005AD410`, `P1 = 0x005AD450`

Sobre `volcados/ee-e4.bin` (LEVEL_00). **17 de 18 predicciones exactas**, total
predicho 552 contra 548 ocupado, y la diferencia entera es una sola fila (la
que corrigió el mapa, §3.2).

| `P1+off` | ocup | pred | | `P1+off` | ocup | pred |
|---|---|---|---|---|---|---|
| `0x1C` | 131 | 131 | | `0x2C` | 5 | 5 |
| `0x3C` | 118 | 118 | | `0x48` | 4 | 4 |
| `0x24` | 73 | 73 | | `0x44` | 3 | 3 |
| `0x08` | 60 | 60 | | `0x20` | 2 | 2 |
| `0x10` | 57 | 57 | | `0x4C` | 6 | 6 |
| `0x18` | 33 | 33 | | `0x00` | **0** | 0 |
| `0x14` | 21 | 21 | | `0x38` | **0** | 0 |
| `0x30` | 20 | 20 | | `0x40` | **0** | 0 |
| `0x34` | 14 | 14 | | `0x28` | 1 | ~~5~~ |

**El control negativo dio más de lo pedido:** los tres ceros no son arrays
vacíos, son **punteros nulos**.

### 3.2 CÓMO se ubicó `P1` — y por qué NO fue un barrido

El tag `*piVar4 == 0x1C` es el mal parámetro de siempre. El eje que sirve es la
**cadena de indirecciones desde un dato ya confirmado**:
`param_2 = *(u32*)(piVar4[4]+4)`, y `param_2` es el descriptor `0x01092800`.

```
1. buscar el valor 0x01092800   -> 193 hits
2. Q = hit - 4                  -> candidato a piVar4[4]
3. buscar el valor Q            -> 6 direcciones B == piVar4+0x10
4. piVar4 = B - 0x10 ; *piVar4 == 0x1C de CONTROL -> sobrevive 1 de 6
```

Tres controles independientes, ninguno buscado: **`piVar4[4] == 0x01053000`**
(la carga de `STUNIT01.BIN`, confirmada por otra vía); el otro slot del doble
buffer **exactamente a `+0x880`** (`0x005ADC90`), con tag `0x1` y `[4]=0` —
**uno vivo y uno libre**; y las capacidades derivadas por contigüidad de los
punteros, **≥ ocupación en los 18 y siempre ajustadas** (132 para 131).

### 3.3 El `0x34` NO usa "índice fijo 0" — la medición corrigió el mapa

`0x0015F5FC`–`0x0015F624` es un **loop**: `s0` arranca en 0 (`0000802D` en
`0015F5E4`), se incrementa (`26100001`), y el límite sale de **`*(P1+0x78)`**.
El `0x34` **no construye** en `P1+0x28`: **lo recorre**, una llamada por
elemento. Su único destino es `P1+0x1C | c_s5`, donde la kb ya lo tenía y donde
el 131 dio exacto. Predicción escrita antes de mirar: `*(P1+0x78) == 1`. **Vale
1.**

**El síntoma era visible SIN medir nada:** el `0x34` era el **único tipo de
módulo que aparecía en dos grupos de destino** (el `0x35` aparece en seis, pero
no es un módulo: es el cierre). Un tipo en dos grupos es una lectura sin
resolver, no dos destinos. Ya está registrado como lección de proceso.

### 3.4 Dos cosas que no se buscaban

- **El juego mantiene sus propios contadores, y coinciden.** `P1+0x50..0x90` es
  una **tabla de largos** cuyo multiconjunto reproduce **elemento por elemento**
  las ocupaciones medidas: `{131,118,73,57,33,21,20,14,5,5,4,3,2,6,1,0,0,0}`. Y
  `P1+0x04 = 0`, `P1+0x0C = 60` son los largos de `P1+0x00` y `P1+0x08`. Es una
  **tercera derivación independiente**: no sale del stream ni de mi conteo.
  **ABIERTO:** la alineación offset-por-offset entre ese bloque y los 16
  punteros de `0x10`–`0x4C` **no cierra con un corrimiento constante**. El
  multiconjunto coincide; la alineación exacta, **no medida**.
- **El `0x2B`, confirmado por su vía propia.** Array **inline** de structs de
  `0x10` en `P1+0xB0`: **9 con contenido y ceros a partir del décimo**, contra 9
  predichas, y **`P1+0xA0 == 9`** es su contador. Los 4 campos son floats
  —p. ej. `[-78.84, -3.579, 30.08, 3.0]`— que parecen XYZ más un cuarto valor.
  **Hipótesis.**

### 3.5 Sigue valiendo intacto de las sesiones anteriores

**El subsistema está en el SITIO DE LLAMADA, no en el handler** (medido: el
cierre transitivo de `FUN_00175980`, 9842 funciones / 20.205 aristas `jal`, no
alcanza `0x0040F4D4` a profundidad 0-3). El despachador lo materializa:
`0015F78C lui v1,0x0041` / `0015F794 lw a0,-2860(v1)` / `0015F79C jal
0x00175980` / `0015F7A0 addiu a0,a0,2632` (**delay slot**, +0xA48).

Tabla de saltos `0x003F4E90`, **69 entradas** (`lui v0,0x3F` + `addiu
v0,v0,20112` en `0x0015F030`; tope de `sltiu v0,v1,69` en `0x0015F024`). **61
tipos en 55 bloques**; 8 en el `default` `0x0015FBDC`: `0x00 0x01 0x02 0x0D
0x0E 0x21 0x24 0x33`.

**Cola virtual:** `0x0B 0x0C 0x12 0x16 0x17 0x18 0x30 0x31 0x32 0x43` no tienen
`jal` propio; saltan a `0x0015F968` / `0x0015F974`
(`lw v1,16(a3) ; lh a0,176(v1) ; lw v0,180(v1) ; jalr v0 ; addu a0,a3,a0`).
Recorrer el bloque por direcciones crecientes los pierde **en silencio**.

**El `0x35` no es un tipo de módulo:** es el **cierre** del stream (0
instancias, ~25 llamadas, recorre todos los arrays de `P1` contra `P2+98..P2+138`).

**Singletons de `.bss`**, todos en `0x0040F4D0`–`0x0040F514`: `0x0040F4D4`
física (**CONFIRMADO**), `0x0040F4E4` (`0x2C`), `0x0040F4F4` (el cierre),
`0x0040F510` (`0x2F`), `0x0040F514` (`0x0A`, spawn de personaje, **probable**).

**Mismo array NO es misma struct:** dentro de `P1+0x1C` conviven blobs de 16 a
96 B. El array es el pool de destino; el blob, la estructura de entrada.

**Eje de cadenas REFUTADO POR MEDICIÓN:** sobre el cierre a profundidad 3, 2
handlers de 70 tienen cadena. **No volver a proponerlo.**

Layout del registro (`+0x00` tipo, `+0x04` ptr al blob, `+0x08` id64 del
nombre). Descriptor `0x01092800 = {count=857, array=0x0109F590}`.
`FUN_0012dab8` arma `param_2` con `*(u32*)(piVar4[4]+4)`; cargador
doble-buffereado `base+0x4990` / `base+0x5210`, `0x880`, tag `*piVar4==0x1C`,
alterna con `*(u8*)(iVar5+0x5aae)^=1` en `FUN_00129360`. El stream en el ISO:
`/LEVELS/LEVEL_00/STG_0001/STUNIT01.BIN`, LBA 1056910, 326.432 B, carga en
`0x01053000`, 98,46 %. Registro de física `0x004CB1C8 = *(0x0040F4D4)+0xA48`,
48 ranuras, **0 ocupadas en los 9 volcados**. Todo 7d; todo 7c; el parche de
ISO in-place **anda** (3×).

**Observables muertos:** `FUN_001A4F70` es un `printf` STUB; `'AI gun model not
found: %s'` hace `sprintf` sobre el stack y no lo usa.

## 4. LO QUE SIGUE, CONCRETO — PASO 4, POR EFECTO, CON EL EMULADOR

**Ahora hay instrumento para leer el efecto.** `pools_p1.py` mide la ocupación
de cualquier pool en un volcado nuevo, así que **"el módulo no se construyó"
pasa a ser contable**, con 17 pools de control que tienen que quedar iguales.
Ése es el cambio que habilita el paso 4 y que antes no existía.

**El experimento más barato — neutralizar UN módulo, un byte:**

1. Elegir una instancia concreta de un tipo con **pocas** instancias y pool
   propio, para que el delta sea inequívoco. Candidatos por orden: `0x2E`
   (5 inst., `P1+0x2C`, y observable **audible**), `0x1E` (4 inst., `P1+0x48`),
   `0x44` (3 inst., `P1+0x44`).
2. **ESCRIBIR LA PREDICCIÓN ANTES**, en la bitácora: qué tipo, qué instancia,
   qué pool baja en 1, y **qué 17 pools tienen que quedar idénticos**.
3. Cambiar el `tipo` de esa instancia a un case del `default` (`0x0D`, `0x0E`,
   `0x21` o `0x24` — están vacíos y no hacen nada) con `parche_iso.py` sobre
   `STUNIT01.BIN`. Es **un byte**.
4. Arrancar el ISO parcheado, **Fran juega hasta cargar LEVEL_00**, volcar los
   32 MB y correr `pools_p1.py pools` contra ese volcado.
5. El **control negativo del experimento**: el mismo volcado tiene que dar 17
   pools sin mover. Si se mueve otro, el modelo de "pool por tipo" está mal.

**El candidato barato ya NO es el `0x2D`**: su registro está vacío en los 9
volcados.

**Aparte, y no bloquea:** validar 7d por efecto parcheando el literal
`0x5446127297C60000` (`BG1_AK1`) por el de `BG1_RPG`.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 NO está corriendo** y no se abrió en toda la sesión. Ejecutable
  correcto (NO el de Program Files):
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
- **Fran autorizó abrir el emulador el 2026-08-29.** El default del proyecto
  sigue siendo en frío, pero el paso 4 lo necesita y está habilitado.
- **RAM limpia, cero parches vivos.** La sesión **no escribió un byte** ni en
  memoria ni en ningún ISO. Todo en frío sobre `volcados/ee-e4.bin` y el ELF.
- **Ningún ISO se tocó.** El nop de vida infinita de `0x0013BD20` sigue
  restaurado (`0xE65402F8`). `Black.iso` en ReadOnly + guardia `PreToolUse`.
- Controles de apertura en verde: `abrir-sesion.ps1` completo (integridad,
  `ubicaciones.py` 12/12, `inventario.py` 13/13, control positivo de Ghidra
  sobre `0x00142B90`). El hook `SessionStart` corrió los medidores de
  `chequeo-completo.ps1`: los tres en verde, saboteadores al día.
- Se pierde al reiniciar el emulador: cualquier parche escrito en RAM. Los ISO
  parcheados sobreviven.

## 6. LAS TRAMPAS YA PAGADAS — no volver a pagarlas

1. **Un CERO acusa al PARÁMETRO, no al mundo.** Y si el instrumento lo
   escribiste vos, el parámetro puede ser el **modelo del ISA**: en MIPS el
   **delay slot corre ANTES** y ahí vive la mitad baja de las direcciones. Todo
   barrido nuevo arranca por un caso **ya conocido**.
2. **No entres por un valor que abunda; entrá por una cadena de indirecciones
   desde algo ya confirmado.** El tag `0x1C` daba miles; la cadena desde el
   descriptor dio 6, y el tag como **control** dejó 1. El orden importa:
   primero el eje que discrimina, después el control.
3. **Un item que cae en DOS categorías excluyentes de tu propio clasificador es
   una lectura sin resolver, y se ve sin medir nada.** Contarlos ANTES de
   derivar predicciones de esa tabla.
4. **Un bloque de `switch` NO termina donde termina en direcciones**, y un
   `lw ...,0(v0)` adentro de un bloque puede ser el cuerpo de un **loop**, no un
   destino. Buscar el incremento y el límite antes de llamarlo "índice fijo".
5. **`capstone` NO sirve** para el `.text` del EE: `barrer.py`, o decodificar
   campos a mano (es lo que hacen `casos_dispatcher.py` y `pools_p1.py`).
6. **Un xref sobre heap siempre da 0.** `.bss` termina en `0x0049BFBC`.
7. **Heredocs largos fallan en la Bash tool** (>~30 líneas): escribir el `.py`
   con Write y correrlo. El `cwd` se resetea entre llamadas: **rutas absolutas**.
8. **`comando | tail` devuelve el exit code de `tail`.** Para medir un rojo:
   `cmd > archivo 2>&1; echo $?` — sin pipe.
9. **Corchetes en rutas de Windows son wildcard:** `-LiteralPath`, o medir desde
   Python. La carpeta de los ISO es `Black [NTSC]`.
10. **`0x01412400` (STLEVEL.BIN cargado) NO es `piVar4[4]`.** `piVar4[4]` es
    `0x01053000`, y eso ahora está medido.

## 7. PENDIENTES QUE NO SON DE LA FASE

- **BLACK a 10 fps en el menú, y el apagado del 2026-08-22.** Es entorno: **no
  mezclarlo con 7e**. Ya medido: evento **1074** lanzado por
  `SysWOW64\shutdown.exe` — apagado **ordenado**, **cero Kernel-Power 41**.
  Hipótesis viva: el cambio a GPU discreta conmuta MSHybrid↔Discrete y el panel
  del fabricante lo aplica llamando a `shutdown.exe`. **Criterio de salida, dos
  minutos:** reabrir BLACK ahora que el modo discreto quedó aplicado y medir los
  fps en el **mismo** menú.
- **Fase 5a — pnach sobre `0x00142CA0`** (daño de salida del jugador).
  **PARQUEADA a propósito**, lista para cuando se vuelva al emulador.
- **La alineación de la tabla de largos `P1+0x50..0x90`** con los 16 punteros:
  el multiconjunto coincide, la asignación offset-por-offset no. Barato de
  medir, no bloquea.
- **`P2` tiene campos hasta `+0x8A`** (los usa el `0x35`), y la kb lo describe
  como `{count, array}` de 8 B. **No medido.**

## 8. BLACK REMASTER / DLSS5 — R0 ABIERTA (línea nueva, no toca 7e)

### 8.1 QUÉ LEER PARA RETOMAR ESTO, EN ORDEN

1. Esta sección, entera.
2. `ESTADO_ACTUAL.md`, bloque "REMASTER GRÁFICO (DLSS5)" (después de N2).
3. `docs/03-bitacora.md`, entrada más nueva (2026-09-01).

**NO hace falta** leer nada de 7e (secciones 1-7 de este mismo archivo) para
seguir con esto — son líneas independientes.

### 8.2 LA FASE, Y QUÉ LA CIERRA

**R0 — ¿hay depth buffer usable para BLACK en PCSX2 2.8?** Abierta, **cero
casillas medidas**. Cierra con una captura del depth + veredicto en tres
casillas — **D3D12@4x / D3D11@Native / D3D11@4x** — cada una en
`sirve` | `sirve degradado` | `no sirve`. No cierra con "instalé ReShade":
eso es preparación, no medición.

### 8.3 LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

- **Hay DOS instalaciones de PCSX2 en la máquina, separadas.** La de
  `kb/ubicaciones.json` (`C:\Program Files\PCSX2\PCSX2\`, con el ISO adentro
  en `games\Black [NTSC]\Black.iso`) tenía **2.6.3.0**, medido por
  `VersionInfo`, nunca antes verificado. Hay una **segunda**, en
  `C:\Program Files\PCSX2\` (ruta CORTA, sin "PCSX2\PCSX2" repetido) que
  **ya existía de antes** de esta sesión — el `ReShade.log` viejo (ver abajo)
  prueba que es la que se usó en el chat anterior de DLSS5. `winget install
  --id PCSX2Team.PCSX2` la subió a **2.8.0** (verificado: `pcsx2-qt.exe`,
  15255040 B, ProductVersion 2.8.0.0). El ISO **no se tocó** (confirmado:
  mismo tamaño 3919609856 B, mismo `LastWriteTime` 2016-03-24, sigue
  ReadOnly).
- **El fork PCSX2-MCP de Downloads (el de `lanzadores/*.bat`) NO sirve para
  R0.** Es un build sin tag de versión (VersionInfo 0.0.0.0), compilado el
  **15/08/2026** — 13 días ANTES del release 2.8.0 (28/08). Para R0 hay que
  usar el `pcsx2-qt.exe` de la ruta CORTA (`C:\Program Files\PCSX2\`), no el
  del fork ni el de la ruta larga (2.6.3).
- **No hay flag `-renderer` en la CLI de PCSX2 2.8.0** (`-help` no lo lista).
  Cambiar Renderer y Resolución interna se hace por Ajustes → Gráficos en la
  UI — no hay atajo de línea de comandos, y no vale la pena adivinar el enum
  de `GSRendererType` en el `.ini` a ciegas.
- **Config compartida entre las dos instalaciones**: ninguna tiene
  `portable.txt`, así que ambas leen `C:\Users\frans\Documents\PCSX2\inis\
  PCSX2.ini`. Al cerrar la sesión estaba en `Renderer = -1` (automático, que
  en 2.8.0 resuelve a D3D12) y `upscale_multiplier = 3` (ni Native ni 4x —
  hay que cambiarlo a mano para cada casilla).
- **ReShade estaba DESINSTALADO, no es que la tecla fallara.** Quedaban
  restos de una instalación vieja en la carpeta LARGA
  (`PCSX2\PCSX2\ReShade.ini/.log/reshade-shaders/`, con `KeyOverlay=36,0,0,0`
  = Home puro, sin modificador — ese dato sigue siendo válido) pero
  `C:\ProgramData\ReShade\` (la DLL global) **ya no existe**, no hay tarea
  programada ni `AppInit_DLLs` — el log viejo terminaba en un
  "Exiting... Finished exiting" del 19/06, sin ninguna entrada de esta
  sesión. Por eso Home no abría nada (no era NumLock). Se reinstaló
  `Reshade.Setup.AddonsSupport` 6.6.2 por winget (el paquete trae Generic
  Depth en el núcleo, no como addon separado) y Fran completó el instalador
  a mano apuntando a `C:\Program Files\PCSX2\pcsx2-qt.exe` (la ruta corta),
  API "Direct3D 10/11/12", shaders estándar.
- **Restricción de scope de Fran (memoria del perfil,
  `black-remaster-resolucion-objetivo.md`):** la salida final del pipeline
  DLSS5 no debe superar la resolución nativa de cada pantalla — 1080p en
  esta notebook, 2K en la PC de escritorio (donde está el interés fuerte).
  Es un eje distinto de la resolución INTERNA de PCSX2 que R0 mide
  (Native/4x son sobre el render del juego, no la salida de DLSS).

### 8.4 LO QUE NO FUNCIONÓ — no reintentar sin cambiar de método

Automatizar los clicks de Ajustes → Gráficos desde PowerShell (P/Invoke:
`SetForegroundWindow` + `PostMessage`/`SendMessage` con `WM_LBUTTONDOWN`).
La ventana de PCSX2 pierde el foreground contra la terminal que ejecuta el
siguiente comando **entre invocaciones separadas** de la herramienta — el
truco (simular Alt + `SetWindowPos` topmost) solo sostiene el foreground
**dentro de una misma invocación**. Forzarlo de todos modos dejó la ventana
en blanco una vez (se recuperó sola, el proceso no llegó a colgarse:
`Responding = True`). Se cortó esa vía — más cara y menos confiable que
pedirle a Fran los clicks — y no vale la pena retomarla salvo que aparezca
una forma de automatizar sin pelear el foreground (por ejemplo, todo el
flujo — abrir Ajustes, cambiar cada campo, cerrar — en una ÚNICA invocación
de PowerShell, sin cortes entre medio).

### 8.5 LO QUE SIGUE, CONCRETO

Con ReShade ya instalado y apuntando al `pcsx2-qt.exe` correcto:

1. Ajustes → Gráficos en la ventana **"PCSX2 v2.8.0"** (no la del fork):
   Renderer = **Direct3D 11**, Resolución interna = **Native (1x)**.
2. Cargar cualquiera de los "Black" de la biblioteca (da igual cuál de los
   3 duplicados — R0 es sobre el renderer, no sobre el contenido) hasta ver
   geometría 3D real en pantalla.
3. Home (con NumLock apagado si es el 7 del numérico) para el overlay de
   ReShade, activar/mostrar **Generic Depth**, capturar.
4. Repetir cambiando solo Renderer/Resolución interna, en caliente, para
   **D3D11 @ 4x** y **D3D12 @ 4x** — no hace falta cerrar el juego entre
   cambios.
5. Veredicto por casilla: `sirve` | `sirve degradado` | `no sirve`, y cierra
   R0.

**Predicción escrita antes de medir (2026-08-31), para no sesgar por lo que
se vea:** D3D11@Native → sirve (ya validado en el chat anterior). D3D11@4x →
no sirve (la colisión ya documentada con el objetivo de 4-6x). D3D12@4x → la
incógnita real, apuesta **sirve degradado** — hipótesis de baja confianza,
no hay evidencia de que la reescritura del depth buffer en 2.8.0 haya
apuntado a este problema específico.

### 8.6 ESTADO DE LA MÁQUINA AL CERRAR (Remaster/DLSS5)

- PCSX2 2.8.0 instalado en `C:\Program Files\PCSX2\pcsx2-qt.exe`. La ventana
  quedó abierta en el escritorio de Fran con la biblioteca de juegos visible
  (proceso `pcsx2-qt`, puede haber más de uno si el fork MCP también estaba
  abierto — verificar con `Get-Process pcsx2-qt` antes de asumir cuál es
  cuál).
- ReShade 6.6.2 (Addon Support) instalado, Fran lo apuntó al exe correcto.
  **No verificado todavía** que el hook se haya enganchado de verdad en un
  arranque real del juego (eso es el paso 1 de la sección 8.5).
- El `.ini` de ReShade de esta instalación nueva vive junto al
  `pcsx2-qt.exe` de la ruta corta — **no** en `PCSX2\PCSX2\ReShade.ini`
  (ese es el remanente viejo, no editarlo pensando que es el activo).
- `PCSX2.ini` (`Documents\PCSX2\inis\`) sigue en `Renderer=-1,
  upscale_multiplier=3` — ninguna de las 3 casillas de R0 quedó configurada.
- El ISO original y sus permisos (ReadOnly + guardia) **no se tocaron**.
