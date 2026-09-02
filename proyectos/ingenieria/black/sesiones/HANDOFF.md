# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

**Dos líneas de trabajo activas en paralelo, independientes entre sí:**
- **7e** (reversing, secciones 1-7 de este archivo) — intacta, nadie la tocó
  esta sesión.
- **BLACK Remaster / DLSS5** (sección **8**) — R0 y R1 cerradas; **R2 abierta**,
  investigación de viabilidad hecha, nada instalado.

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

## 8. BLACK REMASTER / DLSS5 — R0/R1 CERRADAS, R2 ABIERTA (línea nueva, no toca 7e)

### 8.1 QUÉ LEER PARA RETOMAR ESTO, EN ORDEN

1. Esta sección, entera — **empezar por 8.7**, es lo abierto.
2. `ESTADO_ACTUAL.md`, bloque "REMASTER GRÁFICO (DLSS5)" (después de N2).
3. `docs/03-bitacora.md`, entradas 43, 42, 41 y 40.
4. Las capturas: `pruebas/R0-depth/` y `pruebas/R1-rendimiento/`.

**NO hace falta** leer nada de 7e (secciones 1-7 de este mismo archivo) para
seguir con esto — son líneas independientes.

### 8.2 R0 — CERRADA EL 2026-09-01, LAS TRES CASILLAS EN `sirve`

| casilla | veredicto | buffer | draw calls |
|---|---|---|---|
| D3D11 @ Native | **sirve** | 642x450 `D32S8` | ~1200 |
| D3D11 @ 4x | **sirve** | 2568x1800 `D32S8` | ~1034 |
| D3D12 @ 4x | **sirve** | 2568x1800 `D32S8` | ~1001 |

Confirmado **por efecto**, no por conteo: la vista de normales derivadas del
depth (`DisplayDepth.fx`, mitad izquierda) muestra el auto con sus molduras,
las columnas del viaducto y las aristas del piso. A 4x, más limpias que en
Native. Capturas en `pruebas/R0-depth/{d3d11-native,d3d11-4x,d3d12-4x}.png`.

2568x1800 es exactamente 4x de 642x450: **la profundidad escala con la
resolución interna**, no se queda en nativo.

**Consecuencia para el proyecto:** R0 no impone ninguna restricción sobre el
renderer. Los tres sirven, así que elegir entre D3D11 y D3D12 se decide por
rendimiento y por lo que pida el pipeline de DLSS, no por disponibilidad de
depth.

### 8.3 EL REQUISITO QUE SALIÓ DE MEDIR — vale para el pipeline final

**El buffer de depth hay que FIJARLO A MANO.** Con la heurística
`Similar aspect ratio` de Generic Depth en su default, ReShade elige uno de
los buffers de 128x64 (1-2 draw calls, son sombras) y `DisplayDepth` sale
**violeta plano** — visualmente idéntico a "este juego no expone depth". Si
la casilla se hubiera cerrado ahí, R0 daba `no sirve` y mataba el proyecto
por un error de heurística.

Se arregla tildando la casilla izquierda de la fila del buffer grande (el de
~1000 draw calls) en la pestaña **Add-ons**. Y **hay que rehacerlo cada vez
que cambia el renderer o la resolución interna**: PCSX2 destruye y recrea los
render targets, el handle cambia y la selección forzada se pierde.

`Copy depth buffer before clear operations` **no** aporta nada acá — ReShade
avisa `No clear operations were found for the selected depth buffer`.

Segundo detalle, menor pero desorientador: **con `DisplayDepth` activo el menú
de pausa de PCSX2 es invisible.** PCSX2 dibuja su interfaz dentro del frame y
ReShade reemplaza el color de todo el frame después; `Escape` pausa pero no se
ve nada. Cualquier cosa de la UI de PCSX2 hay que mirarla con DisplayDepth
apagado.

### 8.4 LA PREDICCIÓN FALLÓ, Y POR QUÉ IMPORTA

La sesión 40 escribió, antes de medir: D3D11@Native `sirve`, D3D11@4x
`no sirve`, D3D12@4x `sirve degradado`. **Acertó una de tres**, y las dos que
falló, falló para el lado optimista (salió mejor de lo predicho).

La justificación del `no sirve` para 4x era *"la colisión ya documentada con
el objetivo de 4-6x"*. **Esa colisión no está en ninguna parte de este repo** —
`grep` sobre `docs/03-bitacora.md` no la encuentra. Venía de un chat de DLSS5
anterior que nunca se escribió: una predicción apoyada en un dato que sólo
vivía en un chat.

Queda **abierto**: si esa colisión era real, era sobre PCSX2 2.6.3 y/o sobre
un eje que R0 no mide (rendimiento, o el pipeline de DLSS y no el buffer). No
se puede ni confirmar ni descartar con lo que hay escrito.

### 8.5 R1 — CERRADA EL 2026-09-01: D3D12 @ 4x, por GPU%, no por FPS

Medido sobre el mismo savestate 03. Las tres casillas dan el **mismo FPS**
(29.97 — el juego está tapado en la mitad de 59.94 V-Blank, es un techo del
juego, no del renderer/resolución). Lo que distingue es el **uso de GPU** del
OSD:

| casilla | FPS | GPU% | GPU ms |
|---|---|---|---|
| D3D11 @ Native | 29.97 | 60.1% | 10.02 ms |
| D3D11 @ 4x     | 29.97 | 57.9% |  9.67 ms |
| D3D12 @ 4x     | 29.97 | **18.5%** | **3.08 ms** |

**Decisión: D3D12 @ 4x.** Un tercio del gasto de GPU de D3D11 para el mismo
FPS — margen para el pipeline de DLSS5/ReShade que va encima. Tabla completa,
metodología y capturas: `pruebas/R1-rendimiento/resultados.md`.

**Método replicable, sin clicks en Ajustes→Gráficos:** editar
`Documents\PCSX2\inis\PCSX2.ini` directo (`Renderer` = 3 D3D11 / 15 D3D12,
`upscale_multiplier` = 1 Native / 4 4x) con PCSX2 **cerrado** — si está
corriendo, lo pisa al salir con lo que tenía en memoria. Lanzar con
`-statefile`, esperar ~20-25s a que se estabilice, capturar pantalla completa
(PowerShell: `[System.Windows.Forms.Screen]::PrimaryScreen.Bounds` +
`Graphics.CopyFromScreen`, sin necesitar foreground ni clicks) y leer el OSD
de la imagen. No hizo falta togglear ReShade/DisplayDepth para esto.

**Sigue:** la colisión de la sesión 40 (memoria del "objetivo 4-6x") sigue sin
poder confirmarse ni descartarse — a 4x, con este savestate, D3D12 no mostró
ningún síntoma (ni caída de FPS ni stutter visible en el gráfico de frame
times). Si aparece en escenas más cargadas (más enemigos, más partículas),
ahí sí amerita revisar. Restricción de scope vigente (memoria del perfil,
`black-remaster-resolucion-objetivo.md`): la salida final del pipeline DLSS5
no debe superar la resolución nativa de cada pantalla — 1080p en la notebook,
2K en la PC de escritorio. Es un eje distinto de la resolución interna.

Próximo paso natural: **R2**, armar el pipeline real de DLSS5/ReShade sobre
D3D12 @ 4x y confirmar por efecto que sostiene FPS con el upscaler activo.

### 8.6 ESTADO DE LA MÁQUINA AL CERRAR

- **`PCSX2.ini` quedó en `Renderer = 15` (D3D12) y `upscale_multiplier = 4`**
  — la casilla ganadora de R1. `OsdShowFrameTimes` quedó en `true` (se
  activó para R1; antes estaba en `false`).
- PCSX2 **2.8.0** en `C:\Program Files\PCSX2\pcsx2-qt.exe` (ruta CORTA). La
  instalación vieja 2.6.3 en `C:\Program Files\PCSX2\PCSX2\` sigue intacta,
  con el ISO adentro (`games\Black [NTSC]\Black.iso`, ReadOnly, no se tocó).
- ReShade **6.6.2** Addon Support enganchado y **verificado por efecto**:
  `ReShade.log` en la ruta corta arranca con
  `Initializing crosire's ReShade version '6.6.2.2081' ... loaded from
  C:\Program Files\PCSX2\dxgi.dll into ... pcsx2-qt.exe`.
- **`PCSX2.ini` (`Documents\PCSX2\inis\`) tiene MAPEO DE TECLADO Y MOUSE
  agregado a mano en `[Pad1]`**, como líneas repetidas al lado de las del
  joystick (PCSX2 admite varios bindings por botón, así que el mando sigue
  andando). WASD = stick izquierdo; mouse (`Pointer-0/X±`, `Y±`) + flechas =
  stick derecho; click izq/der = R1/L1; Space = Cross; F = Square; R =
  Triangle; C = Circle; Shift = L3; Q = R3; G/V = L2/R2; Enter/Backspace =
  Start/Select; I J K L = cruceta. `PointerXScale`/`PointerYScale` = 40.
  **`TogglePause` se movió de `Keyboard/Space` a `Keyboard/P`** porque chocaba
  con el salto. Este archivo NO está en el repo y se pisa solo al salir de
  PCSX2: si se pierde, está descripto acá para rehacerlo.
- Formatos de binding verificados leyendo los strings del `pcsx2-qt.exe`, no
  adivinados: `Keyboard/<tecla>`, `Pointer-{}/Button{}`, y ejes de puntero
  `Pointer-{}/{}{:c}` → `Pointer-0/X+`.
- El fork PCSX2-MCP de Downloads (el de `lanzadores/*.bat`) es un build del
  15/08, ANTERIOR al 2.8.0: **no sirve** para esta línea, sólo para el
  reversing con DebugServer.
- Savestates útiles: `sstates/SLUS-21376 (5C891FF1).03.p2s` arranca en calle
  con vida llena y geometría 3D — es el que se usó para R0. El `.10.p2s`
  arranca con vida baja y el jugador muere solo.
- Se carga por CLI, sin tocar menús:
  `pcsx2-qt.exe -statefile "<ruta .p2s>" "<ruta Black.iso>"`.
- El ISO original y sus permisos (ReadOnly + guardia) **no se tocaron**. Cero
  parches vivos en RAM: esta sesión no escribió memoria ni ISO.

### 8.7 R2 — ABIERTA: arquitectura mapeada de fuente primaria, Fran ya baja los dos binarios de Discord

**Decisión de Fran (2026-09-02): se va por DLSS5 real (camino b).** Ya bajó
`dlss5-bridge-main.zip` y `DLSS5-Feeder-main.zip` a `Downloads/` — **son el
código FUENTE de GitHub, no los binarios compilados**; hace falta ir a la
página de **Releases** de cada repo, no al zip de `main`. Y confirmó que el
patch de 60fps que probó es el que aparece en el panel de patches
recomendados de PCSX2 (ver más abajo) — no un pnach suelto.

**Hay precedente público de DLSS5 corriendo específicamente en PCSX2**
(TechPowerUp, WCCFTech, GameGPU.com, un post de X de @DystopianSuns) —
`probable`, no `confirmado`: tres de esas cuatro fuentes bloquearon el fetch
(403) y la que se pudo leer (heldgames.com) se niega explícitamente a
publicar pasos de instalación o el nombre exacto del juego probado. El hecho
de que exista está medido por multiplicidad de fuentes independientes; el
cómo replicarlo **no está publicado en ningún lado** — hay que armarlo de los
README primarios, que es lo que sigue.

**El caso de PCSX2 es el MÁS SIMPLE de los cuatro que cubre DLSS5-Feeder**,
por partida doble:

1. **Es D3D12, no D3D11/Vulkan/32-bit.** El propio README: *"On a D3D12 game
   there is no transport at all: NGX runs on the game's own device and
   queue, motion vectors and depth are consumed zero-copy straight from the
   effect textures."* No hace falta el `host64\` de 32-bit, ni el mirror de
   Vulkan, ni siquiera `dlss5-bridge` — el bridge es **sólo** para juegos que
   YA tienen DLSS propio en D3D11/Vulkan (su propio README: *"Do I need the
   DLSS 5 DX11 bridge? No."* para el caso sin DLSS nativo). **La pieza
   correcta es `DLSS5-Feeder`, no `dlss5-bridge`** — corrige lo escrito acá
   ayer, que los daba como alternativas equivalentes.
2. **La profundidad ya está resuelta.** El requisito de Generic Depth con
   selección manual del buffer grande que R0 tuvo que descubrir a mano es
   **exactamente** el mismo requisito que pide DLSS5-Feeder (*"use ReShade's
   Add-ons → Generic Depth page to select the draw call/clear that contains
   the scene rather than UI or an already-cleared buffer"*) — R0 ya lo dejó
   resuelto y documentado (8.3), sólo hay que repetirlo si cambia el
   renderer/resolución.

**Lista exacta de piezas para un juego 64-bit D3D12 sin DLSS nativo — del
README de DLSS5-Feeder, sección Requirements + "Install for a 64-bit game":**

| Pieza | De dónde | Estado acá |
|---|---|---|
| ReShade **6.8+** con add-on support | reshade.me | **hay 6.6.2 — no alcanza, hay que reinstalar** (gotcha nuevo, no detectado en R0/R1 porque no importaba para Generic Depth) |
| `dlss5-feed.addon64` + `DLSS5_Feed.fx` | [Releases de DLSS5-Feeder](https://github.com/jlrouzies-fr/DLSS5-Feeder/releases/latest) | no bajado (el zip que hay es `main`, no el release) |
| Proveedor de motion vectors — [LumeniteFX](https://github.com/umar-afzaal/LumeniteFX) Kernel, `DLSS5_MV_PROVIDER=3` | repo propio, "Code → Download ZIP" | no bajado |
| `renodx-dlss5.addon64` **v4.55 exacto** + `nvngx_dlssnr.dll` | RenoDX Discord, canal `#DLSS5` — <https://discord.com/channels/1408098019194310818/1542647972695904317> | **fuente no confiable — la baja Fran, no esta sesión** |
| `nvngx_dlss.dll` (runtime DLSS Super Resolution) | de cualquier juego con DLSS, o [DLSS Swapper](https://github.com/beeradmoore/dlss-swapper) | sin verificar si el driver ya trae uno usable |

**Un gotcha real que casi se pisa:** `renodx-dlss5.addon64` tiene versiones
posteriores a v4.55 que ya arman su propio contrato sintético y **chocan**
con DLSS5-Feeder si se usan juntos — hay que pedir puntualmente v4.55 en el
Discord, no "la última".

**Pregunta de arquitectura sin responder, la más importante para esta
sesión que sigue — es la que le toca a Opus:** R0 midió el depth buffer de
ReShade a **2568×1800**, exactamente la resolución INTERNA a 4x. Eso
sugiere que ReShade —y por lo tanto DLSS5-Feeder, que en D3D12 lee "zero-copy
straight from the effect textures" del mismo backbuffer que ReShade ve— está
enganchando el framebuffer **antes** de cualquier reescalado de PCSX2 hacia
la ventana/pantalla de salida. Si es así, la reconstrucción DLAA de
DLSS5-Feeder correría sobre 2568×1800, no sobre 1080p/2K — mucho más caro
de lo necesario, y en tensión directa con la restricción ya guardada de
Fran ([[black-remaster-resolucion-objetivo]] en memoria del perfil: la
salida final no debe superar la resolución nativa de cada pantalla). Falta
confirmar: ¿PCSX2 presenta el swapchain D3D12 a resolución interna (y
reescala después, fuera del alcance de ReShade) o a resolución de
ventana/pantalla (y el downscale pasa ANTES del hook de ReShade)? No se
puede leer de un README genérico — es específico del present path de PCSX2
y hay que confirmarlo mirando el tamaño real del backbuffer que reporta
ReShade (`ReShade.log` lo imprime) contra el tamaño de la ventana.

**Patch de 60fps — confirmado el origen, no verificado el efecto:**
`gamesettings/SLUS-21376_5C891FF1.ini` ya tiene `[Patches] Enable = 60 FPS`
(además de `Video Mode` y `Widescreen 16:9`) — es la base de patches
oficial/embebida de PCSX2 (panel "recomendados" de Ajustes→Juego, no un
pnach suelto en disco: `Documents/PCSX2/patches/` está vacío porque esa base
no se guarda como archivo local). Activado en la config, **no medido por
efecto todavía** — falta arrancar con ese patch y leer el FPS real del OSD,
mismo método que R1.

**Modelo para lo que sigue: Opus, sin excepción.** No es investigación
general — es la primera hipótesis de arquitectura en territorio sin
precedente reproducible (el present path D3D12 de PCSX2 contra este
pipeline), con una pregunta abierta concreta arriba que decide si el diseño
entero cambia. Esfuerzo: high, sin fan-out — es un solo hilo de lectura y
diseño, no una tarea que se beneficie de paralelismo.
### 8.8 R2 — LA PREGUNTA DE ARQUITECTURA, RESPONDIDA: el backbuffer es 1920x1080, NO 2568x1800

**Grado: `confirmado`.** Medido de fuente primaria (`ReShade.log` de la
instalación corta, corrida del 2026-09-01 23:05, la misma config que ganó R1:
`Renderer = 15`, `upscale_multiplier = 4`):

```
23:05:49:807 | Redirecting IDXGIFactory2::CreateSwapChainForHwnd(...)
23:05:49:808 | > Dumping swap chain description:
23:05:49:808 |   | Width   | 1920 |
23:05:49:808 |   | Height  | 1080 |
23:05:49:808 |   | Format  | DXGI_FORMAT_R8G8B8A8_UNORM |
23:05:49:819 | Running on NVIDIA GeForce RTX 4060 Laptop GPU Driver 610.62.
```

Es el path D3D12 (el bloque inmediatamente anterior en el log es un
`D3D12_COMMAND_QUEUE_DESC` — Type/Priority/Flags/NodeMask), y en la misma
corrida R0 midió el depth en 2568x1800. **Dos números distintos en la misma
sesión: el swapchain NO sigue a la resolución interna.**

**Qué significa, y por qué cierra la duda:**

PCSX2 renderiza el GS a 2568x1800 en render targets propios (eso es lo que
Generic Depth encuentra como depth), y **reescala a 1920x1080 ANTES del
`Present`**. ReShade engancha el swapchain, así que sus texturas de efecto —
el `backbuffer` que DLSS5-Feeder lee "zero-copy" en D3D12 — son de
**1920x1080**.

| recurso | tamaño | quién lo ve |
|---|---|---|
| render target interno del GS | 2568x1800 | Generic Depth (el depth de R0) |
| **swapchain / backbuffer** | **1920x1080** | **ReShade y DLSS5-Feeder** |

**Consecuencia: EL DISEÑO NO CAMBIA.** La reconstrucción DLAA corre a
1920x1080 (`render size = output size`, 1:1, sin jitter — README de
DLSS5-Feeder, sección *How it works*), no a 2568x1800. La restricción de
scope de Fran ([[black-remaster-resolucion-objetivo]]: la salida final no
supera la resolución nativa de la pantalla) **se cumple por construcción**,
sin tener que tocar nada. La hipótesis de 8.7 —que DLAA iba a correr sobre
2568x1800 y salir carísimo— queda **falsificada**.

Y el 4x no se desperdicia: el downscale de 2568x1800 a 1080p ya es
supersampling, y DLAA + neural rendering corren encima de eso a 1080p.

**El desajuste de tamaños que esto destapa, y por qué NO es un problema:**
el depth queda a 2568x1800 mientras el color está a 1920x1080. No hay que
hacer nada: `DLSS5_Feed.fx` **copia** el depth a su propia textura
`DLSS5_Depth` (R32F) en un pase MRT de ReShade, y las texturas de efecto de
ReShade se asignan al tamaño del backbuffer. El resample lo hace ReShade al
bindear el depth con UVs normalizadas. El contrato que le llega a NGX es
1920x1080 en las tres entradas (color, depth, MV).

**Detalle de configuración que sale de esto:** `PCSX2.ini` tiene
`StartFullscreen = true`, y el swapchain salió `Windowed = TRUE` a 1920x1080
— o sea borderless a resolución de pantalla. **Si el pipeline se lleva a la
PC de escritorio (2K), el backbuffer va a ser 2K y DLAA va a correr a 2K**:
el costo del pipeline escala con la PANTALLA, no con el `upscale_multiplier`.
Es el eje correcto, pero conviene tenerlo escrito antes de medir allá.

**Qué falta para cerrar R2, medido en disco el 2026-09-02:**

| Pieza | Estado real |
|---|---|
| ReShade **6.8.0** Addon | **falta.** Hay 6.6.2. 6.8.0 salió el 2026-08-02 y existe (`ReShade_Setup_6.8.0_Addon.exe`, reshade.me). **winget NO sirve: `Reshade.Setup.AddonsSupport` sigue en 6.6.2.** El build Addon es **unsigned** (lo dice reshade.me). |
| `dlss5-feed.addon64` + `DLSS5_Feed.fx` | falta — de Releases de DLSS5-Feeder, no del zip de `main` |
| LumeniteFX (`DLSS5_MV_PROVIDER=3`) | falta — Code ▸ Download ZIP |
| `renodx-dlss5.addon64` **v4.55** + `nvngx_dlssnr.dll` | **falta, y sólo lo puede bajar Fran** (Discord de RenoDX). Medido: `Downloads/` NO los tiene todavía. |
| `nvngx_dlss.dll` | **OPCIONAL** — el README dice que si no está, se usa la copia del driver. Además hay dos instaladores de DLSS Swapper en `Downloads/` (de mayo 2025) si hiciera falta. |


**LINKS EXACTOS, verificados el 2026-09-02 — y DOS CORRECCIONES:**

| # | Pieza | Link |
|---|---|---|
| a | ReShade **6.8.0** Addon (unsigned) | `https://reshade.me/downloads/ReShade_Setup_6.8.0_Addon.exe` |
| b | DLSS5-Feeder release | `https://github.com/jlrouzies-fr/DLSS5-Feeder/releases/latest` |
| c | LumeniteFX (ZIP directo) | `https://github.com/umar-afzaal/LumeniteFX/archive/refs/heads/mainline.zip` |
| d | RenoDX Discord `#DLSS5` (lo baja **Fran**) | `https://discord.com/channels/1408098019194310818/1542647972695904317` |
| e | DLSS Swapper (opcional, para `nvngx_dlss.dll`) | `https://github.com/beeradmoore/dlss-swapper/releases/latest` |
| f | `ReShade.fxh` de repuesto, si el log dice que no lo encuentra | `https://github.com/crosire/reshade-shaders/tree/slim/Shaders` |
| — | dlss5-bridge — **NO bajar**, no es para este caso | `https://github.com/NIGos/dlss5-dx11-bridge/releases` |

1. **La bitácora 44 dijo `DLSS5-Feeder-0.10.0-beta.2.zip`. Es incorrecto.**
   El release más nuevo es **v0.7.0** (2026-08-31), y sus assets son
   archivos sueltos, no un zip: `dlss5-feed.addon64`, `dlss5-feed.addon32`,
   `dlss5-feed-host64.exe`, `DLSS5_Feed.fx`, `feed-vk-layer.zip`,
   `spike-gl64.exe`, `spike-gl32.exe`. Para el caso de PCSX2 (64-bit D3D12)
   hacen falta **sólo dos**: `dlss5-feed.addon64` y `DLSS5_Feed.fx`.
2. **La rama por default de LumeniteFX es `mainline`, no `main`.** El link
   de "Code ▸ Download ZIP" construido a ojo (`heads/main.zip`) da 404.


**GOTCHA DEL DISCORD (2026-09-02): el link de la fila (d) era de CANAL, no de
invitación.** Discord contesta *"parece que estás en un lugar extraño"* cuando
se abre una URL `discord.com/channels/<server>/<canal>` de un servidor del que
no se es miembro. El link de canal **sólo funciona después de entrar**. El de
invitación es:

    https://discord.com/invite/renodx     (alias: discord.gg/F6AUTeWJHM)

Entrar por ahí primero, y recién después el link de `#DLSS5` de la fila (d)
resuelve.

**LAS ALTERNATIVAS A ESE DISCORD SE BUSCARON Y SE DESCARTARON — decisión
tomada, no volver a abrirla sin evidencia nueva.** Hay al menos seis repos de
GitHub que rehostean `renodx-dlss5.addon64` + `nvngx_dlssnr.dll` en
instaladores "one-click" (`RankFTW/RHI`, `reiluisii/1-Click-DLSS5`,
`faisalkindi/DLSS5oneclick`, `ShugokiFable/dlss5-aio`, `zhubaohi/FF7R-DLSS5`,
`yumlevi/renodx-dlss-installer`) más mods en Nexus. **No se usan**, por tres
razones independientes y en este orden:

1. **`RankFTW/RHI` dice explícitamente que baja `renodx-dlss5.addon64` y lo
   mantiene actualizado EN SILENCIO.** Eso es exactamente lo que el README de
   DLSS5-Feeder prohíbe: cualquier build posterior a **v4.55** arma su propio
   contrato sintético y **choca** con el feeder. O sea: la opción más cómoda
   es la que garantiza romper el pipeline, en silencio, más adelante. No es
   un riesgo de seguridad, es un requisito incumplido.
2. **Provenance sucia.** Uno de esos repos se describe a sí mismo como
   *"One-click setup of the **leaked**..."*. Son binarios de NVIDIA
   redistribuidos por cuentas anónimas.
3. **Hay un incidente de repo IMPOSTOR documentado en este mismo
   ecosistema** (PSA en los foros de Steam de Crimson Desert sobre un GitHub
   falso de un mod de RenoDX). Bajar `.exe`/`.dll` sin firma de cuentas
   anónimas en un ecosistema con suplantación documentada no se hace.

**Medido en el disco el 2026-09-02, no asumido:** `nvngx_dlssnr.dll` **NO
está** en esta máquina. Lo único que hay del NGX del driver es
`nvngx_dlssg.dll` (Frame Generation), en
`Windows\System32\DriverStore\FileRepository\nvmii.inf_amd64_62de3bd48abb42a6\`
y en la caché de la NVIDIA App. Tampoco hay `nvngx_dlss.dll` en las
ubicaciones del driver — pero ése es **opcional**, y DLSS Swapper (ya hay dos
instaladores en `Downloads/`) inventaría los que traigan los juegos
instalados. El que bloquea es `nvngx_dlssnr.dll`, y su única fuente limpia es
el Discord de RenoDX.


**LA SESIÓN NO PUEDE BUSCAR EN EL DISCORD — medido el 2026-09-02, dos razones
independientes:** (1) `list_connected_browsers` devuelve vacío: la extensión
Claude in Chrome NO está conectada, así que no hay acceso a la sesión de
Discord de Fran; (2) el navegador interno es un perfil aparte, sin sesión —
`discord.com/channels/...` rebota a la landing — y loguearse por él está
prohibido. **Si se quiere que una sesión futura busque ahí, hay que conectar
antes la extensión Claude in Chrome.**

**RECETA DE BÚSQUEDA EN `#DLSS5`, para hacerla a mano en 30 segundos en vez de
scrollear.** El detalle que importa: **se busca una versión VIEJA (v4.55), y
el orden por default de la búsqueda de Discord es por más nuevo primero** — o
sea que el default entierra justo lo que se busca. Ordenar por **Old**, o
buscar el string de versión directo:

    in:#dlss5 4.55
    in:#dlss5 has:file renodx
    in:#dlss5 has:file addon64
    in:#dlss5 nvngx_dlssnr

Y antes que nada: **mirar los MENSAJES FIJADOS** del canal (icono de pin,
arriba a la derecha). Una distribución canónica de un binario suele vivir ahí,
no en el chat.

### 8.9 REVISIÓN DE LO DESCARGADO — 2026-09-02, medido archivo por archivo

**LOS DOS `renodx-dlss5.addon64` SON v4.6+, NINGUNO ES v4.55. No sirven.**

El README de DLSS5-Feeder da el discriminador exacto: *"The feeder detects a
v4.6 build (`NRToggleKey` marker)"*. Buscado en los dos binarios: **el
marcador está presente en ambos**. Y con el feeder **released** (v0.7.0, que
es el que se bajó) el README es terminante: *"with the released feeder
builds, stay on v4.55"* — los guardas para v4.6 sólo existen compilando desde
`main`, no en el release.

| archivo | bytes | SHA256 (12) | `NRToggleKey` | veredicto |
|---|---|---|---|---|
| `renodx-dlss5.addon64` | 1694720 | `9150097CDEE2` | **presente** | v4.6+, NO sirve |
| `renodx-dlss5 (1).addon64` | 1732608 | `D5ADF82EB44B` | **presente** | v4.6+, NO sirve |

Los dos declaran `FileVersion 0.2026.0828.0517` — un sello de FECHA, no
semántico: **el recurso de versión del PE NO distingue 4.55 de 4.6**, por eso
hay que ir al marcador. Son builds distintos entre sí: el (1) tiene
`reversible NR color bridge` y el string `RenoDX-DLSSNR`; el otro tiene el
camino `Control codec`/`Control HDR transfer`.

**EL LINK DIRECTO AL MENSAJE DE v4.55 ESTABA EN EL README TODO EL TIEMPO**, en
el bloque de advertencia del encabezado (que esta sesión no leyó cuando armó
la tabla de links — leyó la sección de instalación y la de Requirements y se
salteó el warning). Es un permalink a UN mensaje, no al canal:

    https://discord.com/channels/1408098019194310818/1542647972695904317/1543568908017995818

**El resto de lo descargado está BIEN — verificado, no supuesto:**

| archivo | verificación |
|---|---|
| `ReShade_Setup_6.8.0_Addon.exe` | `FileVersion 6.8.0.0`, Product `ReShade`, firmante `CN=ReShade, E=info@reshade.me`. Estado de firma `UnknownError` = cadena no confiable, **consistente** con que reshade.me declare unsigned el build Addon. Identidad del firmante correcta. |
| `dlss5-feed.addon64` | `FileVersion 0.7.0.0` — coincide con el release v0.7.0 |
| `DLSS5_Feed.fx` | 810 líneas, define `DLSS5_MV_PROVIDER` (default 0 — hay que ponerlo en **3**) |
| `LumeniteFX-mainline.zip` | completo: `Shaders/lumenite_Kernel.fx` + `include/` (4 `.fxh`) + `Textures/lumenite_bluenoise256.png` |

**Sin resolver:** `Sin confirmar 205983.crdownload`, 165 MB, **estancado** (mismo
tamaño en dos muestreos, mtime 00:44). Es una descarga de Chrome sin
confirmar; lo más probable es que esté esperando el botón *Conservar*. No se
sabe qué es. `nvngx_dlssnr.dll` **sigue sin aparecer** en `Downloads/`.


### 8.10 CORRECCIÓN A 8.9, Y EL PIPELINE LISTO PARA INSTALAR — 2026-09-02

**8.9 ESTABA MAL, Y ASÍ SE DESCUBRIÓ.** Fran trajo la captura del mensaje
original (Krish, `#DLSS5`, 30/8/26 7:31: *"v4.55 — Should now work with RE
Engine games"*, adjunto `renodx-dlss5.addon64`, 1.62 MB) y bajó ese archivo.
Resultado medido: **es byte a byte idéntico al primer `renodx-dlss5.addon64`
que ya estaba en `Downloads/`** — mismo SHA256 `9150097CDEE2…`, mismos
1.694.720 bytes. O sea: **el v4.55 ya lo tenía desde el principio.**

**El test del marcador `NRToggleKey` es INVÁLIDO como discriminador de
versión.** El v4.55 confirmado por el autor **también lo contiene**. La
conclusión de 8.9 —"los dos son v4.6, ninguno sirve"— era falsa.

El error de método, que es lo que hay que no repetir: **se armó un test y
nunca se le pasó un control positivo.** No había ningún v4.55 conocido contra
el cual probar que el test supiera decir "no". Un test que sólo vio ejemplares
de una clase y siempre dijo lo mismo está sin verificar — es exactamente la
regla del saboteador, aplicada a un discriminador en vez de a una alarma. Lo
que el README dice es que *el feeder* detecta un build v4.6 por ese marcador;
de ahí no se sigue que la mera presencia del string en el binario lo
identifique.

**IDENTIFICACIÓN BUENA — por procedencia y hash, no por heurística:**

| archivo en `Downloads/` | bytes | SHA256 (12) | qué es |
|---|---|---|---|
| `renodx-dlss5.addon64` | 1694720 | `9150097CDEE2` | **v4.55** |
| `renodx-dlss5 (2).addon64` | 1694720 | `9150097CDEE2` | **v4.55** — idéntico al anterior |
| `renodx-dlss5 (1).addon64` | 1732608 | `D5ADF82EB44B` | otro build (`reversible NR color bridge`, `RenoDX-DLSSNR`) |
| `renodx-dlss5 (3).addon64` | 573440 | `E1C28FDE0922` | otro build, sello `0.2026.0828.2110` |

El propio mensaje explica los sobrantes: *"Accidentally posted debug before"*
— en el canal hay builds de debug posteados por error.

**EL BLOQUEO DE R2 SE LEVANTÓ: `nvngx_dlssnr.dll` LLEGÓ.** Era el
`.crdownload` de 165 MB que estaba a medias. Medido:
`FileVersion 310.8.0.0`, `Product NVIDIA DLSSNR`, `Company NVIDIA`, PE válido,
165.840.496 bytes. Y **empareja por efecto**: el addon de RenoDX lleva adentro
el formato `RenoDX DLSS5 Generic %s | DLSSNR v310.8.0: %s` — espera
exactamente 310.8.0, que es la que hay. **Están todas las piezas.**

**LA SESIÓN NO PUDO INSTALAR: el clasificador de permisos lo bloqueó dos
veces**, por dos vías distintas — (1) `Start-Process … -Verb RunAs` del
instalador, (2) escritura de archivos dentro de `C:\Program Files\PCSX2`. No
se buscó una tercera vía a propósito: dos negativas sobre el mismo objetivo
son una decisión, no un obstáculo. Queda como **`.\instalar-dlss5.ps1`** en la
raíz del proyecto, para que lo corra Fran.

Lo que el script hace, y todo esto ya está medido y verificado:
- Aborta si PCSX2 está corriendo (al salir pisa `PCSX2.ini` y se pierde el
  mapeo de teclado de 8.6).
- **Verifica el SHA256 del addon contra el del v4.55 antes de copiar nada** —
  es el único chequeo que de verdad importa, y es por hash, no por heurística.
- Instala ReShade 6.8.0 **sin correr el instalador**: el `.exe` abre como ZIP
  y trae `ReShade64.dll` (5.592.064 bytes), que es lo que va como `dxgi.dll`.
- Copia el feeder, el renodx v4.55, `nvngx_dlssnr.dll`, `DLSS5_Feed.fx` y
  LumeniteFX a donde van.
- **Verifica por efecto**: tamaño de cada archivo instalado y hash del renodx.
- **`-Desinstalar` revierte todo** y restaura ReShade 6.6.2.

**Respaldos ya hechos por la sesión** (esto sí se pudo):
- `pruebas/PCSX2.ini.respaldo-2026-09-02` — 15.550 bytes, con el mapeo de
  teclado/mouse de `[Pad1]` adentro.
- `pruebas/reshade-662-respaldo/` — `dxgi.dll` 6.6.2.2081, `ReShade.ini`,
  `ReShadePreset.ini`.

**Lo que queda después de correr el script — es a mano, en el overlay:**
fijar el depth buffer grande en Generic Depth (8.3), `DLSS5_MV_PROVIDER = 3`,
habilitar `LUMENITE: Kernel 2.0` y debajo `DLSS 5 Feed`, encender neural
rendering, y leer `dlss5-feed.log`.

