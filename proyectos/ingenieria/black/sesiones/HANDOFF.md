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


**8.10b — EL SCRIPT FALLABA, ARREGLADO (2026-09-02).** Primera corrida:
`ArgumentNullException: source` en el paso 1. **Causa medida:** el instalador
de ReShade tiene un stub `.exe` delante del archivo comprimido, y
`[IO.Compression.ZipFile]::OpenRead` lo abre con **CERO entradas** — .NET no
ajusta el offset por los datos prepended. `zipfile` de Python sí, y por eso la
inspección de la sesión había funcionado sobre el mismo archivo. Nada se había
instalado: el script abortó antes de tocar nada y `dxgi.dll` seguía en
6.6.2.2081 (verificado).

**Arreglo: el script ya no abre ningún ZIP.** La sesión desempaquetó todo con
Python en **`C:\Users\frans\Downloads\_dlss5_staging\`** (14 archivos:
`ReShade64.dll` 5.592.064 bytes + `Shaders\` con los 8 `lumenite_*.fx` y 4
`include\*.fxh` + `Textures\lumenite_bluenoise256.png`), y el script es copia
pura. Sintaxis verificada con `PSParser::Tokenize` — 0 errores.

**Si el staging no está, el script aborta sin tocar nada y lo dice.** Se
rehace con Python desde `ReShade_Setup_6.8.0_Addon.exe` y
`LumeniteFX-mainline.zip`, los dos en `Downloads/`.

### 8.11 INSTALACIÓN CONFIRMADA POR EFECTO — 2026-09-02, sesión nueva

**Grado: `confirmado`.** Entre el cierre de 8.10b y esta sesión, Fran corrió
`.\instalar-dlss5.ps1` (nadie lo dejó anotado; se detectó porque `dxgi.dll` ya
no daba 6.6.2.2081 al abrir). Medido de nuevo, con el mismo criterio de
"por efecto" del script (tamaño de cada archivo + hash del renodx + FileVersion
del dxgi.dll), **no asumido de que "el script no dio error"**:

| archivo | medido | esperado | resultado |
|---|---|---|---|
| `dxgi.dll` | 5.592.064 b, FileVersion 6.8.0.2155 | 6.8.x | OK |
| `dlss5-feed.addon64` | 164.352 b | 164.352 | OK |
| `renodx-dlss5.addon64` | 1.694.720 b, SHA256 `9150097CDEE2…` | v4.55 | OK |
| `nvngx_dlssnr.dll` | 165.840.496 b | 165.840.496 | OK |
| `DLSS5_Feed.fx` | 44.814 b | 44.814 | OK |
| `lumenite_*.fx` | 8 archivos en `reshade-shaders\Shaders\` | 8 | OK |
| `lumenite_bluenoise256.png` | presente en `Textures\` | — | OK |

**La instalación en disco está cerrada.** Lo que NO está hecho todavía:
- `dlss5-feed.log` **no existe** en `C:\Program Files\PCSX2\` — PCSX2 no
  corrió ni una vez desde que se instaló el pipeline (`PCSX2.ini` sigue con
  `LastWriteTime` del 2026-09-01 23:05, de la corrida de R1; ningún proceso
  `pcsx2-qt` activo al medir).
- La config del overlay (8.3 + el punto 6 de la receta: casilla del depth
  buffer grande en Generic Depth, `DLSS5_MV_PROVIDER=3`, orden de efectos,
  neural rendering) **no se hizo**, y no se puede haber sobrevivido de una
  instalación anterior aunque alguien la hubiera tocado antes: **reinstalar
  ReShade resetea la selección de depth buffer** (ya documentado en 8.3). Es
  la primera vez que se abre el overlay contra el ReShade 6.8.0 recién puesto.

**Por qué esto NO lo termina la sesión sola:** la config del overlay es
navegación dentro de una ventana nativa (PCSX2 + sus paneles de ReShade) —
no hay herramienta de automatización de UI de escritorio en este entorno
(las de navegador no aplican; PCSX2 no es una página web), y hacerlo a
ciegas con `SendKeys` sobre una lista de depth buffers cuyo layout no se
conoce de antemano es exactamente el tipo de atajo que la regla 6 del perfil
pide no tomar sin medir antes. Los 7 pasos de la receta (retome, sección 6)
siguen pendientes, a mano.

**Lo que la sesión SÍ puede hacer apenas eso esté listo:** correr el
protocolo de medición de FPS ya usado en R0/R1 sobre el savestate 03 — editar
`PCSX2.ini` con PCSX2 cerrado, lanzar con `-statefile`, esperar, capturar
pantalla completa por `.NET`/PowerShell y leer el OSD de la imagen — y leer
`dlss5-feed.log` buscando `feature ready ... DLAA` y `frame N delivered`, que
es lo que cierra R2.

### 8.12 [SUPERADA POR 8.13] "NGX rechaza esta GPU/driver" — la conclusion era FALSA, leer 8.13

**Fran hizo en vivo, con PCSX2 corriendo, los pasos que 8.11 dejaba
pendientes:** ordenó `LUMENITE: Kernel 2.0` arriba de `DLSS 5 Feed` en la
lista de técnicas (el propio feed avisa por log cuando está al revés: `enable
it above DLSS 5 Feed`) y tildó a mano la fila del buffer grande de Generic
Depth (`2568x1800`, ~4600 draw calls). Los dos, confirmados por captura de
pantalla del overlay.

**El resultado de fondo NO cambió, en TRES corridas independientes — la
última con el wiring perfecto desde el primer frame:**

| corrida | wiring al momento del chequeo NGX | resultado |
|---|---|---|
| 1 (primera vez completo) | roto (`MV_PROVIDER=0`, sin motion vectors) | `SuperSampling.Available=0` → `stopped` |
| 2 (relanzamiento limpio) | correcto desde el primer scan (`Kernel enabled`) | `SuperSampling.Available=0` → `stopped`, idéntico |
| 3 (con `mode=1` en vez de `mode=2`) | correcto | `SuperSampling.Available=0` → `stopped`, idéntico |

Secuencia siempre igual, tal cual queda en `dlss5-feed.log`:
```
[feed] NVSDK_NGX_D3D12_Init -> 0x00000001 (Success)
[feed] NGX capabilities: SuperSampling.Available=0
stopped: DLSS is not available on this GPU/driver. The game renders normally.
```

**CORRECCIÓN DE MÉTODO, hecha en la misma sesión: las tres corridas NO
prueban un techo de hardware.** Las tres usaron el MISMO `nvngx_dlssnr.dll`
sin cambiarlo — repetir el mismo test con el mismo insumo sospechoso tres
veces confirma que el resultado es REPRODUCIBLE, no CUÁL de las dos hipótesis
(techo de la GPU vs. archivo roto) es la causa. Ese es exactamente el error
que `chequeo-de-trabajo.md` pide evitar: nombrar la segunda explicación
plausible y diseñar el test que la mata, no reforzar la primera con más
repeticiones del mismo insumo. La variable que faltaba variar era el DLL, y
resultó ser la que importaba (ver abajo).

**LA CAUSA REAL, `confirmado` por dos mediciones locales independientes —
NO es un techo de hardware:** el `nvngx_dlssnr.dll` instalado tiene la firma
Authenticode INVÁLIDA:
```
PS> Get-AuthenticodeSignature 'C:\Program Files\PCSX2\nvngx_dlssnr.dll'
Status: HashMismatch
"...el hash del archivo no coincide con el hash almacenado en la firma digital."
```
Y su SHA256 (`8270B350CD82DE5CE89806872CDD6B6A9249B80836B91BBEB3573470744CC206`)
es DISTINTO del hash "known-good" que usa una herramienta comunitaria para
esta misma clase de falla (`E16BCF15E16E13F527491CDF7845B2FE6521A738D8F7C9C721866A8496E1FC8E`,
misma versión de archivo 310.8.0.0 — mismo número, contenido distinto).
`ReShade.log` ya lo venía avisando y no se le dio suficiente peso a tiempo:
`WARN | signed runtime sha256 8270B350... (custom runtime accepted; untested
build, NR failures may be specific to it)`. El archivo que bajamos de un
adjunto de Discord (HANDOFF 8.9/8.10) nunca se verificó por firma, sólo por
`FileVersion`/`Company`/"PE válido" — una verificación mucho más débil.

**Fran encontró en el Discord de RenoDX (canal `tools`) el hilo "Fix for
DLSS 5 Stuck on STANDBY/FAILED" de Kayle, que describe EXACTAMENTE este
mecanismo** (`nvngx_dlssnr.dll` dañado/modificado, firma inválida, log con
`feature 18 create failed with 0xBAD00002`) y linkea una herramienta:
`https://github.com/kayle2203/dlssnr-signature-repair`.

**La herramienta fue revisada — código fuente completo leído, no sólo el
README (`gh api repos/kayle2203/dlssnr-signature-repair/contents/...`):**
repo chico (creado 2026-08-28, 8 estrellas), con `LICENSE` y `SECURITY.md`.
El script (`DLSSNR-Repair.ps1`, PowerShell puro) hace SÓLO esto: pide una
carpeta ORIGEN (un juego que YA tenga un `nvngx_dlssnr.dll` sano) y una
carpeta DESTINO; verifica el origen por hash SHA256 EXACTO
(`E16BCF15...`) + versión + firma Authenticode válida de NVIDIA antes de
tocar nada; si no matchea, aborta sin cambiar un solo byte; si matchea,
hace backup del archivo roto (`.bad-signature-backup-<fecha>`) y reemplaza
de forma atómica (`[IO.File]::Replace`), con rollback automático si algo
falla. **Cero llamadas de red, cero binarios de NVIDIA incluidos, cero
credenciales pedidas.** Es seguro de correr; el único requisito es
conseguir una fuente cuyo hash sea el exacto `E16BCF15...` (una copia rota
o de otra build NO sirve — el script la rechaza a propósito).

**Corroboración independiente, desde OTRO módulo:** el addon separado
`renodx-dlss5.addon64` (panel "DLSS 5 Neural Rendering") no ve nunca una
`DLSSD`/`DLSS` feature creada — `HOOKS ARMED - NO DLSS CREATE SEEN` — lo
cual es consistente: si `dlss5-feed` se rinde antes de llamar
`CreateFeature`, no hay nada que `renodx-dlss5` pueda interceptar. Mismo
techo, visto desde el módulo de al lado.

**Dato técnico suelto, NO la causa actual, pero es una pista real para la
sesión que sigue:** `ReShade.log` (no `dlss5-feed.log`) registra que el
propio hook de `renodx-dlss5` sobre el NGX real del driver falla en una de
cuatro funciones:
```
DEBUG | vtable::Hook(NVSDK_NGX_D3D12_CreateFeature hooked ...)
DEBUG | vtable::Hook(NVSDK_NGX_D3D12_EvaluateFeature hooked ...)
ERROR | vtable::Hook(Failed to find NVSDK_NGX_D3D12_EvaluateFeature_C)
DEBUG | vtable::Hook(NVSDK_NGX_D3D12_ReleaseFeature hooked ...)
```
El módulo detourado es
`C:\WINDOWS\System32\DriverStore\FileRepository\nvmii.inf_amd64_62de3bd48abb42a6\_nvngx.dll`
(el core NGX que trae el driver 610.62). Ese export no está ahí. **No se
sabe si un driver más nuevo lo agrega** — es una hipótesis sin probar, no un
hecho. No es la causa de lo medido arriba porque `dlss5-feed` nunca llega a
ese punto del código, pero si algún día `SuperSampling.Available` empezara a
dar `1`, este sería el siguiente escollo a mirar.

**Cabo suelto sin cerrar, de bajo valor:** `dlss5-feed.log` sigue diciendo
`EnableHooks=2 (user-set; leaving it alone)` pase lo que pase con `mode=` en
`dlss5-feed.cfg`. Son dos ajustes de DOS ADDONS distintos que coinciden en
nombre-de-log y en valor por casualidad (`ReShade.log` sí atribuye
`EnableHooks=2` a `renodx-dlss5`, no a `dlss5-feed`). Dónde vive el
`EnableHooks` real de `renodx-dlss5` — otro `.cfg`, `ReShade.ini`, registro —
**no se ubicó**. Lección registrada:
`perfil-global/chequeo-de-trabajo.md`, sección "AL LEER EL ESTADO DE LA
MÁQUINA". Dado que el bloqueo real (la respuesta de NGX) es anterior a este
ajuste, no es prioritario — pero si se retoma el hilo de "probar
EnableHooks=1", primero hay que encontrar el archivo correcto.

**DECISIÓN DE FRAN (2026-09-02, de madrugada): handoff a sesión nueva con
Opus.** Mientras tanto él instala un driver de NVIDIA más nuevo por su
cuenta (acción de sistema, la hace él, no la sesión). El encargo explícito:
*"la gente lo pudo hacer andar con placas similares a la mía, investigá bien
y si podés leé el Discord"*. Esto es investigación en territorio
desconocido con final abierto (por qué otros con RTX 40-series lo lograron,
si es que lo lograron, y qué hicieron distinto) — no un runbook ya decidido,
así que corresponde **Opus**, con esfuerzo **high o xhigh** y probablemente
**fan-out** (Discord, issues de GitHub de DLSS5-Feeder y de RenoDX, cambios
recientes de driver, reportes de otros usuarios son fuentes independientes)
una vez que un sondeo barato confirme que hay superficie ancha real — la
decisión fina de effort/fan-out es de esa sesión, vía `/enrutador-modelo`.

**Restricción ya medida, no la repitas:** el 2026-09-02 esta sesión no pudo
buscar en el Discord de RenoDX — `list_connected_browsers` da vacío (Claude
in Chrome no conectado) y el navegador interno no tiene sesión de Discord
(8.8 lo documenta con el mismo detalle). Si para la próxima sesión Fran
conectó la extensión, probarlo; si no, no perder un turno re-descubriendo
esto — ir directo a fuentes públicas (GitHub, foros, Reddit) y decirle a
Fran que necesita conectar la extensión si el Discord es la única fuente
que falta.

### 8.13 LA CAUSA REAL: FALTA `nvngx_dlss.dll`. No es la GPU y no es la firma — 2026-09-02, sesión Opus

**Esta sección corrige a 8.12 en su conclusión operativa. 8.12 sigue siendo correcta en su
corrección de método (tres corridas con el mismo insumo no prueban causa), pero la pista que
dejó abierta — reparar la firma del `dlssnr` — resultó ser la equivocada, y además riesgosa.**

#### Lo medido localmente, primero

Re-medición de apertura (por si el driver nuevo había cambiado algo): **nada cambió.**
`nvngx_dlssnr.dll` sigue con SHA256 `8270B350CD82DE5CE89806872CDD6B6A9249B80836B91BBEB3573470744CC206`,
firma `HashMismatch`, `FileVersion` 310.8.0.0. PCSX2 seguía corriendo (PID 36588, arrancado 01:53).

**El inventario que nadie había hecho** — todos los `*nvngx*` de la carpeta del juego:

```
nvngx_dlssnr.dll   165.840.496   ver=310.8.0.0   sig=HashMismatch   sha=8270B350...
```

**Uno solo.** No está `nvngx_dlss.dll`. Y `SuperSampling` es la feature que provee
`nvngx_dlss.dll`, no el `dlssnr` (que provee Ray Reconstruction / Neural Rendering). NGX
resuelve las DLL de features **desde el directorio del proceso**: si el archivo no está ahí,
`SuperSampling.Available=0` es la respuesta correcta y esperable del runtime.

Barrido de todo `C:` — el archivo **ya existe en la máquina, tres veces, todas firmadas y
válidas**:

```
48.971.832   v310.2.1.0   Valid   C:\Games\The Last of Us Part I\nvngx_dlss.dll
51.256.376   v3.7.0.0     Valid   C:\Games\The Last of Us Part II Remastered\nvngx_dlss.dll
48.971.832   v310.2.1.0   Valid   ...\DLSS Swapper\dlls\dlss\dlss_v310.2.1.0_3A875F45...\nvngx_dlss.dll
```

En el `DriverStore` sólo hay `nvngx_dlssg.dll` (frame generation, 9.3 MB, v310.2.1.0, firma
válida). **No hay ningún `nvngx_dlss.dll` del driver.**

#### La causalidad, que ninguna medición local podía dar

Fran entró al Discord de RenoDX por QR en el navegador interno (ver 8.14 para el estado de esa
sesión). Tres fuentes independientes, del `dlss5-forum`, `tools` y `dlss5-helpdesk`:

| quién | GPU | qué aporta |
|---|---|---|
| POMAHECKO (NFS Most Wanted 2005) | **RTX 4070 SUPER** | el **antes/después** exacto: *"The important part was adding `nvngx_dlss.dll` to host64. Before that: `SuperSampling.Available=0`, NGX unavailable. After adding `nvngx_dlss.dll`: `SuperSampling.Available=1`"*. Llegó a `feature ready: 2560x1440 DLAA` y `frame 10800 evaluated`. |
| TraceKira (guía Skyrim SE) | RTX 5070 mobile | el síntoma completo por omisión: `nvngx_dlss.dll MISSING` → `SuperSampling.Available = 0` → `CreateFeature failed 0xBAD0000B`. Y la regla de versión: **"Keep both nvngx DLLs on the same version."** |
| Agai Naizagai (hilo *"The Sims 4 DLSS 5 **RTX 4060**"*) | **la misma GPU que la notebook** | *"also u need the `nvngx_dlss.dll`, it is missing"*, con el log idéntico al nuestro: `SuperSampling.Available=0 NeedsUpdatedDriver=0 MinDriver=0.0`. |

El caso de POMAHECKO es el que cierra la causalidad: es la **misma variable variada** (agregar el
archivo) con el **mismo síntoma antes** y el **resultado buscado después**, en una RTX 40.

#### Dos cosas que quedan descartadas

**1. El techo de hardware.** Hay RTX 40 con el pipeline corriendo y evaluando frames. ShortFuse
(autor de RenoDX) mantiene un hilo dedicado, *"Patched DLSS-NR for RTX20, RTX30, and RTX40"*:
*"Replace `nvngx_dlssnr.dll` with the latest pinned version. (Yes. Use pins). Auto branches based
on hardware. Supports RTX20/RTX30 by replacing FP8 calls..."*.

**2. La herramienta de reparación de firma de Kayle — y era un riesgo real, no sólo un desvío.**
Esa herramienta exige un origen con hash exacto `E16BCF15...`, que es el **binario firmado por
NVIDIA**, o sea el de Blackwell. La guía del propio server dice lo contrario para esta GPU:

> *"If using RTX20, RTX30, or RTX40 series **overwrite** `nvngx_dlssnr.dll` with the **patched**
> version"*

Un binario parcheado tiene la firma inválida **por diseño**. `HashMismatch` no era el defecto:
puede ser la firma esperada de un archivo modificado. "Reparar" habría reemplazado un DLL
posiblemente correcto por uno que no corre en Ada. **La firma inválida era una pista, no la
causa, y su lectura estaba invertida.**

#### Versión: el detalle que falta cerrar

La comunidad estandarizó en **310.8** para ambos DLL:

- Krish [RENO]: *"dlls should ideally be 310.8"*.
- Caso funcionando en **RTX 4080** (driver 616.56, ReShade 6.8.0.2155): `nvngx_dlssnr 310.8.SF`
  (ShortFuse build) + `nvngx_dlss 310.8.0`.
- Variantes del `dlssnr` que la comunidad distribuye: `310.8.2 Default`, `310.8.SF-v2`,
  `310.8.SF`, `310.8.0`, `Custom`.

**Los tres `nvngx_dlss.dll` que ya hay en el disco son 310.2.1.0 y 3.7.0.0 — ninguno es 310.8.**
Copiar el 310.2.1.0 es el experimento barato y reversible (y el `dlssnr` instalado es 310.8.0.0,
así que violaría "same version"); conseguir el 310.8.0 es el camino que la comunidad valida.

#### Cabo suelto nuevo, de la guía de ShortFuse

> *"If you have `renodx-dlss5.addon64` remove or rename it to `renodx-dlss5.addon64x`.
> (Cant use both)."*

La notebook **tiene** `renodx-dlss5.addon64`. Esto aplica sólo si se migra al *"DLSS Tool
(ShortFuse Version)"*, que usa `renodx-dlss.addon64` (sin el 5). Con el pipeline actual
(DLSS5-Feeder + renodx-dlss5) **no** hay que tocar nada. Anotado para no pisarlo por accidente.

#### Herramienta que la comunidad usa, y que NO está revisada

**RHI** — `https://github.com/RankFTW/RHI`. Aparece en 131 mensajes del server como la respuesta
estándar: instala ReShade, descarga los DLL correctos y **deja elegir la versión del `dlssnr`**
(el dropdown con `310.8.2 Default / 310.8.SF-v2 / 310.8.SF / 310.8.0 / Custom`). Un usuario que no
encontraba el `310.8.SF` a mano lo desplegó con RHI.

**No fue revisada por esta sesión.** Antes de recomendarla hay que leerle el código como se le
leyó a la de Kayle (8.12). Hay también un reporte negativo: *"rhi doesnt download the
DLSS5_Feed.fx, its not a good app"*.

#### Lo que sigue, en orden

1. Conseguir `nvngx_dlss.dll` **310.8.0** y, si se quiere cerrar el eje Ada, el `nvngx_dlssnr.dll`
   parcheado del pin de ShortFuse.
2. Ponerlos en `C:\Program Files\PCSX2\` — **lo hace Fran**: escribir ahí sigue bloqueado para la
   sesión (confirmado tres veces).
3. Medir `SuperSampling.Available` en `dlss5-feed.log`. Ese es el criterio de salida de R2(a).
4. Si da 1 y aparece `feature ready ... DLAA` + `frame N delivered`, recién ahí el FPS sobre el
   savestate 03, con el método de R0/R1.

**Predicción escrita antes de probar (regla 3):** con `nvngx_dlss.dll` presente,
`SuperSampling.Available` pasa a `1`. Si sigue en `0` con el archivo puesto y en la versión
correcta, la hipótesis del archivo faltante muere y el siguiente sospechoso es el `dlssnr` no
parcheado para Ada — que es una variable distinta y se varía sola.

**Nota de performance, de la misma fuente:** TraceKira, en una RTX 5070 mobile, midió 80 → 30 FPS
con Neural Rendering activo. Es una notebook y es una GPU superior a la de acá. El costo de esto
es alto y hay que tenerlo presente antes de festejar un `Available=1`.

#### Lo que se intentó y NO concluyó — no repetirlo igual

Para saber si el `nvngx_dlssnr.dll` instalado es el original de **Blackwell** o
uno **parcheado para Ada** (la pregunta que decide si además del `dlss` hay que
cambiar también el `dlssnr`), se intentaron **dos** inspecciones estáticas del
binario de 165 MB, y **las dos dieron vacío**:

1. Scan de strings `sm_NN` / `compute_NN` y de las palabras `Ada`, `Lovelace`,
   `Blackwell` — **cero coincidencias** en todo el archivo.
2. Scan de headers ELF (`\x7fELF`) para leer `e_machine=190` (EM_CUDA) y sacar
   el SM de `e_flags` — **cero headers ELF en todo el archivo**, ni CUDA ni
   x86-64.

Que no haya **ningún** header ELF en un archivo de ese tamaño sugiere que los
cubins van en fatbins **comprimidos**, que es lo que NVIDIA usa hoy.
Descomprimirlos requiere parsear el contenedor fatbin (magic `0xBA55ED50`) y
descomprimir cada entrada — factible, pero es trabajo de un rato y **no hace
falta para el próximo paso**: la pregunta se responde sola por efecto una vez que
esté `nvngx_dlss.dll` en la carpeta. Si con el `dlss` puesto `SuperSampling` pasa
a 1 pero después falla el `CreateFeature`, ahí sí el `dlssnr` vuelve a ser
sospechoso, y conviene ir directo al parcheado del pin de ShortFuse en vez de
analizar el binario.

### 8.14 SESIÓN DE DISCORD ABIERTA EN EL NAVEGADOR INTERNO — 2026-09-02

`list_connected_browsers` (Claude in Chrome) sigue dando **vacío**: la extensión no está
conectada, igual que en 8.8 y 8.12. **La restricción se levantó por otra vía:** el navegador
interno (`mcp__Claude_Browser__`) abrió `discord.com` y ofreció **login por QR**, que Fran escaneó
con la app del teléfono. La sesión quedó abierta como `chicoleche`, con acceso al server RenoDX.

Detalle que costó dos intentos: el link *"O puedes iniciar sesión con una clave..."* abre el flujo
de **passkey de Windows** ("Elige una clave de paso"), que **no** es el QR y no sirve. El QR se
escanea desde **adentro de la app de Discord** (foto de perfil → ícono de QR), no con la cámara
del sistema.

Canales útiles del server: `dlss5`, `dlss5-helpdesk`, `dlss5-forum`, `tools`, `guides`.
La cuenta **no tiene permiso de escritura** ("Debes completar algunos pasos más antes de poder
hablar") — se puede leer y buscar, no postear.

**Lección de método:** buscar `"Patched DLSS-NR RTX40"` en el buscador del server dio **cero
resultados** sobre un hilo que existe y se llama *"Patched DLSS-NR for RTX20, RTX30, and RTX40"*.
El parámetro de búsqueda era el problema, no la búsqueda. Abrir el canal `dlss5-forum` y leer el
listado del foro lo resolvió en un paso.

### 8.15 AUDITORÍA DE LOS LINKS Y LAS VERSIONES: qué NO hay que bajar, y la 4.ª fuente que confirma 8.13 — 2026-09-02

Fran trajo cuatro links nuevos del Discord y pidió revisarlos **antes** de bajar nada. Se
auditaron por metadata de GitHub y README/release notes, no por lo que dice el mensaje que los
compartió.

#### Lo primero, y cierra un eje que estaba abierto: el `dlssnr` YA es el parcheado de ShortFuse

La captura del pin de ShortFuse (*"Patched DLSS-NR for RTX20, RTX30, and RTX40 support"*) muestra
el adjunto `nvngx_dlssnr.dll` de **158,16 MB**. El instalado mide **165.840.496 bytes = 158,16 MiB**
exactos. Es el mismo archivo.

`confirmado` por coincidencia de tamaño al centésimo de MB + `FileVersion` 310.8.0.0 + firma
`HashMismatch` (la que corresponde a un binario parcheado). **El segundo sospechoso de la
predicción de 8.13 —"el `dlssnr` no parcheado para Ada"— queda descartado sin necesidad de
probarlo.** Si tras copiar `nvngx_dlss.dll` el valor sigue en 0, el siguiente sospechoso ya NO es
ese: hay que buscar otro.

#### CUARTA fuente independiente de la causa de 8.13, y esta vez es un desarrollador

`NIGos/dlss5-bridge` documenta el mismo mecanismo desde afuera del Discord, en su README y en las
notas de dos releases:

> README, tabla de requisitos: *"`nvngx_dlss.dll` **3.1.13 or newer** — from the game, if it has
> DLSS. ... **the driver store carries no super-resolution snippet**"*
>
> v1.4.2 (2026-09-02): *"**A missing `nvngx_dlss.dll` is named before the substitute contract is
> attempted.** A game without DLSS brings no super-resolution snippet and the NVIDIA driver
> carries none, so the panel and the log now say which file to copy beside the executable"*
>
> v1.4.0: *"`nvngx_dlss.dll` must be beside the executable, **in a game without DLSS too**"*

Las tres fuentes de 8.13 eran usuarios del Discord; ésta es el autor de un add-on, que además
mide el efecto en su propio banco de pruebas. Y aporta **el requisito duro que faltaba**:

**El umbral es `>= 3.1.13`, no 310.8.** *"DLAA arrived in SDK 3.1.13; older runtimes accept it and
degrade the picture"*. El `310.8` del Discord (*"keep both nvngx DLLs on the same version"*) es
convención de la comunidad, no un requisito medido.

**Consecuencia operativa: el camino (a) del retome deja de ser un test de descarte y pasa a ser
el camino correcto.** El `310.2.1.0` que ya está en el disco cumple el requisito documentado con
holgura. No hay que conseguir nada para cerrar la fase.

Origen elegido, re-medido el 2026-09-02:
```
C:\Games\The Last of Us Part I\nvngx_dlss.dll
  48.971.832 bytes | v310.2.1.0 | firma Valid | SHA256 4E85CDBE0896AAB5...
```
La copia del caché de DLSS Swapper tiene el **mismo SHA256** — son el mismo archivo, da igual cuál
se use. El caché de DLSS Swapper se inventarió entero: **sólo tiene 310.2.1.0**, no hay 310.8.

#### Los cuatro links, uno por uno

| Link | Qué es | Veredicto |
|---|---|---|
| `NIGos/dlss5-bridge` v1.4.2 | 184★, MIT, C++, creado 2026-08-28 | **NO APLICA** |
| `NIGos/ngxGym` | 1★, creado 2026-09-01 | **NO** |
| `RankFTW/RHI` 2.5.4 | 897★, GPL-3.0, C#, "ReShade HDR Installer" | **NO, y no es por seguridad** |
| `jlrouzies-fr/DLSS5-Feeder` 0.11.0-beta.2 | el feeder ya instalado, versión de hoy | **NO AHORA** |

**dlss5-bridge — no aplica por arquitectura, y su propio README lo dice:** *"The DLSS 5 neural
rendering add-on only works where a game runs DLSS on **DirectX 12**. This bridge gives it that:
it mirrors a **DirectX 11 or Vulkan** game's own DLSS onto a private DirectX 12 session"*. PCSX2
acá corre **D3D12 nativo** (`Renderer=15`), que es justamente lo que el bridge existe para
fabricar. Instalarlo agrega un add-on que hookea los mismos entry points de NGX sin resolver nada.

**ngxGym — es el banco de pruebas del desarrollador del bridge**, no una herramienta de usuario:
*"A scriptable DLSS host for testing the dlss5-bridge ReShade add-on"*. Un día de vida, 1 estrella.

*Aclaración de atribución:* el texto que venía pegado a ese link en el mensaje de Fran (*"V4.5
with more F5 compat improvements... All credit to @speedlemur for the original mod
(ControlDLSS5)"*) **no es de ngxGym**: es el changelog de la mod de **ShortFuse**, que es una
línea distinta (ver abajo).

**RHI — el problema es el tamaño de la intervención, no la confianza.** Es un gestor de mods HDR
para bibliotecas enteras: instalador de 26 MB, detección de 8 tiendas, 10 componentes, escritura
directa en perfiles del driver NVIDIA, **elevación persistente vía Task Scheduler**, auto-update
cada 4 horas. Para copiar un archivo de 48 MB entre dos carpetas, eso es desproporcionado
(regla 6: cambios mínimos; lo que se instala solo tiene que poder desinstalarse solo). Sí gestiona
swaps de DLSS SR, o sea que **serviría** si algún día hiciera falta el 310.8 — pero para eso ya
está DLSS Swapper instalado, que sólo descarga DLLs. El reporte negativo del Discord (*"rhi doesnt
download the DLSS5_Feed.fx"*) es coherente: RHI no conoce el pipeline DLSS5-Feeder. **No se le
leyó el código; no hizo falta llegar a esa pregunta.** Si alguna vez se lo considera en serio, ahí
sí corresponde la revisión completa que se le hizo a la de Kayle (8.12).

#### La pregunta de Fran sobre las versiones 4.5 / 4.55 / 4.6 / 4.7 — hay DOS numeraciones distintas

| línea | archivo | autor | versiones |
|---|---|---|---|
| RenoDX DLSS5 | `renodx-dlss5.addon64` (**con** el 5) | Krish [RENO] | 4.5, 4.55, **4.6**, **4.7** |
| ShortFuse | `renodx-dlss.addon64` (**sin** el 5) | ShortFuse, basada en ControlDLSS5 de speedlemur | hasta V4.5, *"likely the last version"* |

Por eso Krish rotula sus posts *"(Not ShortFuse's mod)"* y *"(Different to Shortfuse's mod)"*: son
proyectos separados que colisionan en el número. Lo instalado es de la línea de **Krish** —
el log lo identifica como `renodx-dlss5.addon64 v0.2026.828.517 -- v45+`.

**Fran acertó en no bajar 4.6/4.7, pero por una razón distinta a la que suponía.** No es que
"haga falta la 4.5": es que **el Feeder v0.7.0 instalado no las soporta**. El soporte entró en
`v0.10.0-beta.2`: *"DLSS 5 add-on v4.6/v4.7 support (#27)"*. Con el feeder actual, un add-on 4.7
recibiría los workarounds de un build pre-4.5. Actualizar el add-on obliga a actualizar el feeder:
**dos variables a la vez, en medio de un experimento de una sola.**

Dato asociado, de las notas de `0.11.0-beta.2`: un `.addon64` renombrado con versión
(`renodx-dlss5-4.7.addon64`) no era reconocido por el feeder, y **ReShade carga todos los
`*.addon64` de la carpeta** — dos copias hookean NGX las dos. Si alguna vez se actualiza el
add-on, la vieja se **borra**, no se renombra.

#### Feeder 0.11.0-beta.2 — no ahora, y la razón está medida

Se leyeron las notas de 0.8 → 0.11 completas. **Ninguna de las cinco betas toca
`SuperSampling.Available=0`**: los fixes son Smooth Motion en D3D11, juegos de 32 bits
(feature-level 10, plateaus a 30 fps en DXVK), nombres versionados de add-on y minidumps de
crash. Nada de eso describe el síntoma de acá. Confirma por omisión que el bloqueo no es un
defecto del feeder.

**Cabo suelto nuevo, para cuando la fase cierre:** desde `0.11.0-beta.1` el autor recomienda
**Deep Fried Chicken** (`deep-fried-chicken.addon64`, de Alexander) *en reemplazo* de
`renodx-dlss5.addon64` como neural consumer, con ABI negociada en vez de colisión de hooks.
`renodx-dlss5` sigue soportado como alternativa. **Exactamente uno de los dos**, nunca los dos.
No se toca hasta que haya un frame entregado con el stack actual.

#### Estado medido en esta sesión (re-medición de apertura)

```
C:\Program Files\PCSX2\  -> nvngx_dlssnr.dll  165.840.496  ver 310.8.0.0   [UNO SOLO]
                            nvngx_dlss.dll    AUSENTE
PCSX2: corriendo, PID 36588, arrancado 01:53:55
dlss5-feed.log (01:54:02, última corrida):
  [feed] DLSS 5 add-on: renodx-dlss5.addon64 v0.2026.828.517 -- v45+ engine
  [feed] config: enabled=1 mode=1 ... work_resolution=100%
  [feed] DLSS5_MV_PROVIDER=3 (LumeniteFX Kernel) -> Lumenite_Kernel (enabled), depth reversed=1
  [feed] NVSDK_NGX_D3D12_Init -> 0x00000001 (Success)
  [feed] NGX capabilities: SuperSampling.Available=0
  stopped: DLSS is not available on this GPU/driver.
```
El wiring está perfecto desde el primer scan (`MV_PROVIDER=3`, Kernel enabled): el overlay que
Fran configuró en 8.12 **persistió**. La única pieza que falta sigue siendo el archivo.

Nota: el feeder corre en `mode=1`, no en `mode=2`. 8.12 midió los dos sin diferencia — pero eso
fue **antes** del `nvngx_dlss.dll`. Si `SuperSampling` pasa a 1 y no aparece `frame N delivered`,
`mode=2` es lo primero a probar, y es una variable sola.

#### El paso que queda, sin cambios respecto de 8.13

1. Cerrar PCSX2 (PID 36588).
2. **Fran** copia (escribir en `C:\Program Files\PCSX2\` sigue bloqueado para la sesión, 3 veces
   confirmado):
   `Copy-Item "C:\Games\The Last of Us Part I\nvngx_dlss.dll" "C:\Program Files\PCSX2\"`
3. Relanzar y leer `SuperSampling.Available` en `dlss5-feed.log`.

**Predicción, sin cambios y ahora con el requisito de versión verificado:** con `nvngx_dlss.dll`
v310.2.1.0 presente (>= 3.1.13), `SuperSampling.Available` pasa a `1`. Si sigue en `0`, muere la
hipótesis del archivo faltante **y también la del `dlssnr` sin parchear** (queda descartada arriba
por tamaño): habría que abrir un sospechoso nuevo.

### 8.16 `SuperSampling.Available=1` — LA CAUSA DE 8.13 QUEDA CONFIRMADA POR EFECTO — 2026-09-02, 11:19

**La predicción escrita en 8.13 y re-verificada en 8.15 se cumplió.** Fran copió
`nvngx_dlss.dll` v310.2.1.0 desde `C:\Games\The Last of Us Part I\` a `C:\Program Files\PCSX2\`
y relanzó (PID 37508, 11:19:35).

Variable variada: **una sola**, el archivo. Todo lo demás quedó igual — mismo `dlssnr`, mismo
add-on, mismo feeder, mismo `mode=1`, mismo overlay.

```
ANTES (01:54, un solo nvngx)      DESPUES (11:19, con nvngx_dlss.dll)
  SuperSampling.Available=0   ->    SuperSampling.Available=1
  stopped: DLSS is not             session ready (same-device)
  available on this GPU/driver     feed: session open (same-device D3D12)
```

Inventario de la carpeta, medido después de la copia:
```
nvngx_dlss.dll     48.971.832   ver 310.2.1.0
nvngx_dlssnr.dll  165.840.496   ver 310.8.0.0
```

**Esto cierra tres cosas de una vez:**

1. **La causa de 8.13 pasa de `confirmado por fuentes` a `confirmado por efecto` en esta
   máquina.** Faltaba `nvngx_dlss.dll`; NGX lo resuelve desde el directorio del proceso.
2. **La conclusión de 8.12 queda definitivamente enterrada.** No había ningún techo de hardware:
   la misma GPU, el mismo driver y el mismo `dlssnr` de firma inválida ahora responden `1`.
3. **La discusión de versión queda resuelta en la práctica, y a favor de 8.15.** El `310.2.1.0`
   funcionó con un `dlssnr` `310.8.0.0`. El *"keep both nvngx DLLs on the same version"* del
   Discord no era un requisito duro; el umbral documentado por el autor de `dlss5-bridge`
   (`>= 3.1.13`) sí describe el comportamiento real. **No hizo falta conseguir el 310.8.**

#### El add-on ahora ve lo que antes no veía

`ReShade.log` cambió de forma verificable. Antes detouraba **un** módulo NGX; ahora detoura
**dos**, y el segundo es el archivo recién copiado:

```
DLSS5 Generic: detoured NGX module copy [0] ...DriverStore\...\_nvngx.dll (core)
DLSS5 Generic: detoured NGX module copy [1] C:\Program Files\PCSX2\nvngx_dlss.dll
DLSS5 Generic: D3D12 NGX hooks installed across 2 module copy(ies);
               inline DLSS contract capture armed
```

Ya no aparece `HOOKS ARMED - NO DLSS CREATE SEEN`. El `renodx-dlss5` está armado y esperando un
create.

*Cabo suelto que sigue igual y sigue sin importar todavía:* `ERROR | vtable::Hook(Failed to find
NVSDK_NGX_D3D12_EvaluateFeature_C)`. Es el mismo de 8.12, sobre el `_nvngx.dll` del driver. Tres
de cuatro funciones se hookean bien. No bloqueó nada hasta acá.

#### Lo que falta, y es UNA variable: `mode=1` -> `mode=2`

El feeder abrió la sesión pero **no crea la feature NGX**, y lo dice con todas las letras:

```
11:19:44.143  [feed] transport ready (mode 1, no NGX feature)
```

`C:\Program Files\PCSX2\dlss5-feed.cfg` (200 bytes, sin tocar desde el 01:53) tiene `mode=1`.
En `mode=1` el feeder sólo transporta; el path completo es `mode=2`. Esto ya estaba anticipado al
final de 8.15.

**Ojo con la trampa de 8.12:** ahí se probó `mode=1` vs `mode=2` y "no hubo diferencia". Eso fue
**antes** de que existiera `nvngx_dlss.dll` — con `SuperSampling.Available=0` ningún valor de
`mode` podía cambiar nada, porque el feeder se rendía antes. Aquella medición no dice nada sobre
la situación actual y **no debe usarse para descartar `mode=2`**.

#### Baseline de FPS medido, sin DLSS — sirve para el A/B posterior

Con `mode=1` (transporte activo, sin neural), sobre lo que Fran tenía en pantalla:

```
11:19:53  600 frames: feed CPU 2.45 ms/frame | frame interval 19.14 ms (52.2 fps) | feed 13% del frame
11:20:03  600 frames: feed CPU 0.02 ms/frame | frame interval 16.68 ms (59.9 fps) | feed  0% del frame
```

El primer bloque es calentamiento; el segundo es el régimen: **59,9 fps, y el feeder cuesta
0,02 ms/frame (0 % del frame)**. Backbuffer **1920x1080 R8G8B8A8_UNORM**, que vuelve a confirmar
la arquitectura de 8.8 (la swapchain es 1080p, no 2568x1800).

Este número **no** es todavía el baseline formal de R2: se midió sobre lo que hubiera en pantalla,
no sobre el savestate 03 con el método de R0/R1. Sirve como referencia de orden de magnitud y como
prueba de que el transporte no cuesta nada.

#### El paso siguiente, exacto

1. Cerrar PCSX2 (PID 37508) — el `.cfg` se edita con el emulador cerrado, igual que el `.ini`.
2. `mode=1` -> `mode=2` en `C:\Program Files\PCSX2\dlss5-feed.cfg` (lo hace **Fran**: escribir en
   `C:\Program Files\PCSX2\` sigue bloqueado para la sesión).
3. Relanzar con `lanzadores\ABRIR-BLACK-ORIGINAL.bat` (lo hace **la sesión**).
4. Leer `dlss5-feed.log`. Lo que se busca ahora: `feature ready ... DLAA` y `frame N delivered`.
5. Recién con eso, el FPS formal sobre el savestate 03 (`SLUS-21376 (5C891FF1).03.p2s`, existe),
   con el método de R0/R1.

**Predicción antes de probar:** con `mode=2` aparece el create de la feature y `frame N
delivered`. Si el create falla, el código de error de NGX es el dato que decide el siguiente paso
— y **ahí sí** el desajuste de versión (310.2 con 310.8) vuelve a ser sospechoso, porque
`CreateFeature` es la primera llamada donde los dos DLL tienen que trabajar juntos, cosa que la
consulta de capacidades no exige.

### 8.17 R2(a) CERRADA: DLSS 5 NEURAL RENDERING CORRIENDO EN BLACK — 2026-09-02, 11:25

**Los tres criterios de salida de la fase, en la misma corrida.** `mode=1` -> `mode=2` en
`dlss5-feed.cfg` (lo hizo Fran; escribir en `C:\Program Files\PCSX2\` sigue bloqueado para la
sesión) fue el único cambio respecto de 8.16.

```
11:25:18.767  [feed] NGX capabilities: SuperSampling.Available=1
11:25:19.892  [feed] feature ready: 1920x1080 DLAA, flags=74 (SDR MVLowRes DepthInverted
                     AutoExposure), color R8G8B8A8_UNORM -> output R8G8B8A8_UNORM,
                     depth R32_FLOAT (reversed), mv R16G16_FLOAT
11:25:19.899  [feed] frame 1 delivered (1920x1080, reset=1, same-device)
11:25:20.650  [feed] frame 2 delivered (1920x1080, reset=0, same-device)
11:25:20.653  [feed] frame 3 delivered (1920x1080, reset=0, same-device)
11:25:42.055  [feed] MV probe (centre 64x64, frame 1200): mean |mv| 14.854 px, max 15.10 px,
                     100% non-zero
```

**Estado: `confirmado` por efecto.** DLSS 5 Neural Rendering corre sobre BLACK en PCSX2, en una
**RTX 4060 Laptop**, con un `nvngx_dlss.dll` 310.2.1.0 junto a un `nvngx_dlssnr.dll` 310.8.0.0
parcheado por ShortFuse. La `MV probe` con **100 % de vectores no nulos** confirma que el
contrato que arma LumeniteFX es real, no un tapón de ceros.

La línea 8.12 (*"NGX rechaza esta GPU/driver"*) queda cerrada por completo, y también su
corolario implícito de que hacía falta el 310.8.

#### TRAMPA ENCONTRADA: los lanzadores abren OTRO emulador

`lanzadores\ABRIR-BLACK-ORIGINAL.bat`, `ABRIR-BLACK-MOD-7B.bat` y `ABRIR-EMULADOR.bat` — **los
tres** — apuntan a:

```
C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe
```

que es el emulador parcheado con DebugServer + PINE, el de la **línea 7e (reversing)**. **Todo el
pipeline DLSS vive en la otra instalación**, `C:\Program Files\PCSX2\`, que es la que
`dlss5-feed.log` nombra en su segunda línea (`host:`).

Usar un lanzador para una prueba de DLSS abre el emulador sin ReShade, sin addons y sin los
`nvngx_*`: **no se produce ningún log de DLSS, y el síntoma sería "dejó de andar"**, no "abrí el
programa equivocado". Se detectó leyendo el `.bat` antes de correrlo, así que no costó una
sesión — pero por poco.

El comando correcto para las pruebas de DLSS, hasta que haya un lanzador propio:
```powershell
Start-Process -FilePath "C:\Program Files\PCSX2\pcsx2-qt.exe" -ArgumentList '-fastboot','-batch','--','C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso'
```
Los ISOs (`Black.iso`, `Black-mod-7b.iso`, `Black-mod-armas.iso`) sí viven bajo
`C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\` y los comparten las dos instalaciones.

#### Números de FPS: hay dos, y TODAVÍA NO SON UN A/B VÁLIDO

| corrida | config | régimen | feed CPU | costo del feed |
|---|---|---|---|---|
| 11:19 (8.16) | `mode=1`, sin feature neural | **59,9 fps** (16,68 ms) | 0,02 ms/frame | 0 % |
| 11:25 (ésta) | `mode=2`, DLAA + neural | **56,9 fps** (17,57 ms) | 1,29 ms/frame | 7 % |
| 11:25, warm-up | `mode=2`, primeros 600 frames | 46,6 fps (21,46 ms) | 4,75 ms/frame | 22 % |

La resta da **-3 fps (~5 %)**, y ese número **no se reporta todavía**: las dos corridas
midieron **escenas distintas** (la de las 11:19 fue sobre lo que hubiera en pantalla; ésta arrancó
por `-fastboot` desde el ISO). Comparar dos escenas distintas y llamarlo A/B es exactamente el
error que el método de R0/R1 existe para evitar.

Sirven para dos cosas legítimas, las dos ya medidas: el orden de magnitud del costo (**~1,3 ms de
CPU por frame en régimen**) y que el warm-up de los primeros ~600 frames cuesta casi 4x eso, o
sea que **una medición corta sobreestima el costo**.

#### Observación menor, sin efecto medido

Esta corrida **no imprimió la línea `[feed] config: enabled=1 mode=... `** que sí aparecía en las
tres anteriores. El `.cfg` fue reescrito con `Set-Content -Encoding ASCII`, y se leyó bien (la
feature se creó, que es el efecto). Hipótesis sin probar y de bajo valor: el feeder sólo lista la
config cuando algún valor difiere del default, y `mode=2` es el default. **No investigar salvo que
algo más falle**; queda anotado para que no se lea como síntoma nuevo.

#### Lo que sigue: R3, el FPS formal

R2 cerró con el pipeline entregando frames. Lo que falta es el número que R0/R1 dejaron pendiente,
y **exige el método de R0/R1**, no dos corridas sueltas:

1. Mismo contenido en las dos ramas: savestate **03** (`SLUS-21376 (5C891FF1).03.p2s`, existe en
   `C:\Users\frans\Documents\PCSX2\sstates\`), cargado con `-statefile`.
2. Emulador **cerrado** para tocar cualquier `.ini` o `.cfg`.
3. La variable a variar es `mode=2` <-> `mode=1` (o `enabled=0`) en `dlss5-feed.cfg` — **no** el
   renderer ni el `upscale_multiplier`, que tienen que quedar idénticos entre ramas.
4. Captura de pantalla y lectura del OSD, como en R0/R1.

**Medido: las DOS instalaciones comparten un único `PCSX2.ini`**, y no está en ninguna de las dos
carpetas de programa:

```
OK     C:\Users\frans\Documents\PCSX2\inis\PCSX2.ini
         Renderer = 15   upscale_multiplier = 4   OsdShowFPS = true   EnableFastBoot = true
FALTA  C:\Program Files\PCSX2\inis\PCSX2.ini
FALTA  ...\Downloads\PCSX2-MCP-v1.0.0-win64\...\inis\PCSX2.ini
```

Consecuencia que hay que tener presente: **tocar ese `.ini` cambia también el emulador de la línea
7e**, porque es el mismo archivo. Para el A/B de DLSS no hace falta tocarlo — la variable vive en
`dlss5-feed.cfg` — pero cualquier cambio de `Renderer` o `upscale_multiplier` que se haga para una
línea le llega a la otra sin aviso. El respaldo está en `pruebas/PCSX2.ini.respaldo-2026-09-02`.

`OsdShowFPS = true` ya está puesto, así que el OSD sirve para la lectura de R3 sin tocar nada.

### 8.18 R3: EL COSTO ESTÁ MEDIDO Y ES CHICO. LA CALIDAD EMPEORA, Y HAY DOS CAUSAS CANDIDATAS — 2026-09-02, 11:45

**Fran hizo el A/B bien, y con mejor método que el planeado en 8.17:** misma escena, mismo frame,
misma posición del jugador, variando **una sola cosa** — la casilla `DLSS 5 Feed` en la lista de
técnicas de ReShade. No hizo falta el savestate 03 ni cerrar el emulador; la variable se varía en
caliente y la escena queda idéntica por construcción. **R3 queda cerrada con esto.**

| rama | FPS (OSD) | frame | GS | GPU |
|---|---|---|---|---|
| `DLSS 5 Feed` **destildado** | **54,29** | 18,42 ms | 94,6 % (17,42 ms) | 25,2 % (4,64 ms) |
| `DLSS 5 Feed` **tildado** | **52,99** | 18,87 ms | 95,1 % (17,54 ms) | 20,4 % (3,85 ms) |

**Costo del neural: −1,3 fps (−2,4 %), 0,45 ms de frame.** Coincide con lo que el propio feeder
mide desde adentro en el mismo tramo (`feed CPU 0,35 ms/frame | feed is 2% of the frame`), que es
una segunda medición independiente del mismo número. `confirmado`.

**El cuello de botella no es la GPU ni DLSS: es el GS.** `GS: 95 %` en las dos ramas, con la GPU
al 20-25 %. La emulación del Graphics Synthesizer satura antes que cualquier otra cosa, y por eso
un costo de 0,35 ms sobre un frame de 18,4 ms casi no se ve. Esto también explica por qué en 8.17
la resta ingenua daba −3 fps: aquella medición comparaba escenas distintas, y la diferencia real
es menos de la mitad.

**Fran aclaró después que venía usando el modo turbo (avance rápido) para cargar menús y niveles.
Eso NO invalida la medición: la mejora.** Sin turbo, PCSX2 capa la emulación a la velocidad
nominal (60 fps NTSC) y un costo de 0,45 ms se lo come el cap entero — el A/B daría 60 contra 60 y
la conclusión sería "no cuesta nada", que es falsa. **Con el cap levantado, el emulador corre al
techo real y el costo se hace visible.** Que las dos ramas midan 54,29 y 52,99 —las dos por debajo
de 60— confirma que el cap no estaba actuando en ninguna de las dos, que es justo la condición que
hace comparable la resta.

**La advertencia real es otra, y la trajo el propio Fran: la relación de aspecto también mueve los
FPS.** Es una segunda variable, y si hubiera cambiado entre capturas la resta no valdría. Las dos
capturas muestran el mismo encuadre y el mismo pillarbox, así que `probable` que se haya mantenido
— pero es `probable`, no `confirmado`, y es la única grieta que le queda a este número.

Config al momento de la medición (medida, no asumida): `Renderer=15` (D3D12),
**`upscale_multiplier=3`** (Fran lo bajó de 4), `linear_present_mode=1`, `work_resolution=100`,
`mode=2`.

#### El hallazgo que importa: **se ve PEOR**, y el feeder lo viene avisando

Reporte de Fran: *"se ve más borroso con el DLSS5"*. El log lo respalda con una línea propia,
repetida durante todo el tramo:

```
[feed] MV probe (centre 64x64, frame 58800): mean |mv| 0.000 px, max 0.00 px, 0% non-zero
       <-- DLSS is getting (almost) no motion vectors
```

Con una excepción aislada (`frame 54000: mean 0.179 px, 40% non-zero`). Compárese con la corrida
de 8.17, en cinemática: `mean 14.854 px, 100% non-zero`.

**Ojo con la lectura fácil: `0 %` con el jugador quieto NO es un defecto.** Si la cámara no se
mueve, los motion vectors del centro de la pantalla valen cero y eso es correcto. El dato no dice
"los MV están rotos"; dice **"en estos frames el neural no tiene nada nuevo que integrar"**.

Dos causas candidatas para la borrosidad, en el orden en que hay que probarlas:

**(1) El panel del consumidor neural está COLAPSADO, y su switch puede estar apagado.** Medido en
`ReShade.ini`:
```
OverlayCollapsed=DLSS 5 Neural Rendering@renodx-dlss5.addon64, DLSS 5 Feed 0.7.0@dlss5-feed.addon64
[RenoDX.DLSS5]
SavePresetFile=0
```
Los **dos** paneles están colapsados, y la sección `[RenoDX.DLSS5]` no guarda ni un solo ajuste
(`SavePresetFile=0`): lo que haya en ese panel vive en memoria y no dejó rastro en disco. La
casilla que Fran tildó es la del **feed** — el transporte —, que es una cosa distinta del
**consumidor neural**. El README de `dlss5-bridge` lo dice para el mismo add-on: *"The neural
add-on's own toggle has to be on, in its panel or in `ReShade.ini`"*.

Si ese switch está apagado, lo que Fran vio es **DLAA puro sin neural rendering** — que es
exactamente un suavizado, sin nada que lo compense. Es la hipótesis barata y se verifica abriendo
la pestaña; **hay que descartarla antes de creerle a la (2)**.

**(2) Falta el jitter de cámara, y eso es arquitectónico.** El README del propio DLSS5-Feeder lo
plantea sin rodeos:

> *"Real DLSS upscaling needs the **game** to render smaller than your screen and jitter its
> camera, then hands DLSS that small frame. This feeder only ever sees the finished, screen-sized
> frame ReShade has, so what it can publish is a 1:1 DLAA contract: same size in, same size out."*

DLAA acumula muestras entre frames; lo que hace que esa acumulación **agregue detalle** en vez de
sólo promediar es que la proyección jitteree sub-píxel entre frames. **PCSX2 no jitterea.** Sin
jitter, el blend temporal no aporta información nueva: suaviza. Esto no se configura — pedirlo
sería pedirle a PCSX2 que cambie su matriz de proyección.

**Y hay un agravante que no es defecto de nadie:** con `upscale_multiplier=3`, PCSX2 ya renderiza
a ~1920x1344 y baja a la ventana. Ese downsample **es** supersampling, que es antialiasing de
mejor calidad que cualquier método temporal. El neural no está mejorando una imagen aliaseada:
está suavizando una que ya venía antialiaseada por fuerza bruta.

#### Consecuencia para el objetivo del proyecto

El pipeline **funciona** — eso quedó cerrado en 8.17 y no se toca. Lo que esta sección agrega es
que **funcionar no es lo mismo que servir**: en esta configuración el neural cuesta 2,4 % de FPS y
devuelve una imagen peor. Si la causa es (1), se arregla con un switch. Si es (2), el techo es del
enfoque post-proceso y no hay ajuste que lo levante en PCSX2.

**Predicción, antes de que Fran abra el panel:** si el switch del consumidor neural está apagado,
prenderlo cambia la imagen de forma visible (a mejor o a peor, pero **cambia**) y el costo en ms
sube por encima de los 0,35 ms actuales, porque hoy ese número es sospechosamente barato para una
red neuronal corriendo a 1080p. **Si el switch ya estaba prendido**, la causa (1) muere y queda la
(2), que no tiene arreglo por configuración.

### 8.19 `NR IS OFF` — el neural rendering nunca corrió, y eso invalida el número de R3 — 2026-09-02, 12:00

**La predicción de 8.18 se cumplió, y el propio add-on lo dice sin ambigüedad.** Fran abrió el
panel colapsado (`DLSS 5 Neural Rendering`, pestaña Add-ons) y el diagnóstico está impreso ahí:

```
RenoDX DLSS5 Generic v4.1.5 | DLSSNR v310.8.0:  NR IS OFF
NR was switched off (ini, overlay, or the NR toggle hotkey). To turn it on, tick
'Enable DLSS Neural Rendering' above or press the NR toggle key in gameplay.
Hook diagnostics below remain valid.
```

Con `[ ] Enable DLSS Neural Rendering` y `[ ] Enable Upscaling (WIP)` **los dos destildados**.

**La causa (1) de 8.18 queda `confirmada` y la (2) queda sin probar.** El jitter sigue siendo un
techo real del enfoque, pero **todavía no es el que estamos viendo**: lo que Fran evaluó como
"más borroso" era el pase DLAA solo, sin neural rendering encima. La (2) no se puede juzgar hasta
que la (1) esté corregida.

#### Consecuencia directa: el costo medido en 8.18 NO es el costo del neural

R3 midió el A/B de la casilla `DLSS 5 Feed`, con `NR IS OFF` en las **dos** ramas. Entonces
`−1,3 fps (−2,4 %)` y `0,35 ms/frame` son **el costo del feed más el pase DLAA**, no del neural
rendering. El costo real del pipeline completo está sin medir y **va a ser mayor** — lo cual, de
paso, explica por qué 0,35 ms parecía sospechosamente barato para una red neuronal a 1080p (la
sospecha quedó anotada en 8.18 y resultó ser el síntoma correcto).

**R3 se reabre.** Su número describe una configuración que no es la que interesa.

#### Lo que el panel confirma que SÍ está bien (no rehacer)

```
NGX modules detoured: 2 | core present: yes
NGX hooks: creates 9 | evaluations 148246
Runtime sha256: 8270B350...744CC206 (custom build)
Latest NR NGX result: 0x00000001 (ok)
Successful NR frames: 46088 | Guides: 1920x1080 | Output: 1920x1080
Insertion: immediately after the game's NGX DLSS output; UI remains downstream
Codec: FP16 working surface
```
Feed: `Session: open`, `Feature: ready`, `Frames delivered: 73657`, `Mode: Full DLSS path`,
`Work resolution: 100%`, `provider matches the shader's DLSS5_MV_PROVIDER`.

**`Successful NR frames: 46088` con `Latest NR NGX result: ok` prueba que el NR corrió en algún
tramo anterior de esta misma sesión** — probablemente antes de que la tecla `F6` (`NR Toggle Key`)
lo apagara. O sea que el camino completo ya funcionó una vez; no hay nada roto que arreglar, sólo
un switch que prender.

**Generic Depth eligió el buffer correcto:** `1926x1350 | D32S8 | 4132 draw calls | 246756
vertices`, consistente con `upscale_multiplier=3`. Los otros tres candidatos son de 576x384 o
menos. Esto valida lo que Fran configuró a mano en 8.12 y que sigue vivo.

#### Herramientas del panel que no estaban documentadas y cambian el método

| tecla / control | qué hace |
|---|---|
| **F5** | `Capture Screenshot` — modo A/B pareado, guarda en `DLSS5Screenshots\` junto al exe |
| **F6** | `NR Toggle Key` — prende y apaga el NR en vivo, sin tocar archivos |
| `NR Preset` | *"Presets differ in how hard DLSS clamps history against the current frame. If motion warps around transparents (dust, smoke, flames), try E or F."* |
| `NR Style` | segundo eje, separado del preset |
| `NR Intensity`, `Local Tone Strength`, `Local Structure Strength`, `Skin Structure Strength` | sliders |
| `Reset NR feature and clear failure latch` | botón de recuperación |

**F5 + F6 juntos son el método de medición que a R3 le faltaba:** F6 varía la única variable en
vivo sin cerrar nada, y F5 captura las dos ramas sobre el mismo frame. Eso es estrictamente mejor
que el savestate 03 que 8.17 planificaba, y mejor todavía que tildar la casilla del feed — que
además de la variable movía el transporte entero.

#### Discrepancia de versión, anotada sin resolver

El panel se identifica como **`RenoDX DLSS5 Generic v4.1.5`**; el archivo declara
`Versión: 0.2026.828.517`; el feeder lo clasifica como `v45+ engine`. El HANDOFF venía diciendo
`v4.55` desde 8.11. **Son tres numeraciones distintas para el mismo binario** y no se sabe cuál
corresponde a la que Krish publica en el Discord (4.5 / 4.55 / 4.6 / 4.7).

`v45+ engine` no es una versión: es la clase de motor que el feeder detecta (v4.5 o superior).
No se toca nada por esto — 8.15 ya estableció que actualizar el add-on obliga a actualizar el
feeder — pero **la afirmación "tenemos la 4.55" no está confirmada** y no debe repetirse como si
lo estuviera.

#### El pedido de Fran: "gran apalancamiento visual"

Ordenado por la escala de Meadows, de mayor a menor, con lo que hoy está montado:

1. **Prender `Enable DLSS Neural Rendering`.** No es un parámetro: es la diferencia entre el
   sistema corriendo y no corriendo. Todo lo demás de esta lista es ruido mientras esto esté en
   `OFF`.
2. **F5/F6 como método.** Sin A/B pareado sobre el mismo frame no hay forma de saber si un cambio
   mejoró; con él, cada prueba siguiente cuesta segundos. Es flujo de información, no parámetro.
3. **El insumo de motion vectors.** Hoy: `LumeniteFX Kernel, 1/8 res, filtro Bilinear`. El neural
   no puede ser mejor que sus guías. Alternativas ya presentes en el panel: `4 LumeniteFX
   QuantMotion`, y los `Geometry vectors (camera model + depth) — EXPERIMENTAL`, hoy apagados.
4. **`NR Preset` / `NR Style`**, que eligen comportamiento del modelo, no intensidad.
5. **Los sliders** (`NR Intensity`, `Local Tone/Structure Strength`). El escalón más bajo.

**Y el techo que ninguna de las cinco levanta, dicho de frente:** BLACK es un juego de PS2 con
texturas de 2006. `upscale_multiplier=3` sube la geometría a 1926x1350, pero las texturas siguen
siendo las que trae el ISO. El neural rendering reconstruye e ilumina — **no inventa textura que
no existe**. El salto visual grande de un juego de PS2 vive en las texturas y el shading, que es
otra línea de trabajo (y se toca con la 7e, no con este pipeline).

**Predicción antes de prender el switch:** con `Enable DLSS Neural Rendering` tildado, (a) la
imagen cambia de forma visible respecto de lo que Fran evaluó, (b) el costo por frame sube por
encima de los 0,35 ms medidos, y (c) el contador `Successful NR frames` empieza a avanzar en vivo.
Si (a) no pasa, el sospechoso siguiente es que el NR se esté insertando después del punto que
importa — y para eso el panel ya dice dónde se inserta (*"immediately after the game's NGX DLSS
output; UI remains downstream"*).

### 8.20 NR ENCENDIDO: se ve mejor, y cuesta 5x más de lo que R3 había medido — 2026-09-02, 11:58

Fran tildó `Enable DLSS Neural Rendering`. **Las dos predicciones de 8.19 se cumplieron.**

**(a) La imagen cambió, y para mejor.** Reporte de Fran: *"ahora se ve mejor"*. Estado:
`hipótesis` sostenida por juicio visual directo — no hay captura pareada todavía, y por eso no
sube de escalón. Lo que sí queda `confirmado` es que **cambió**, que es lo que la predicción
arriesgaba.

**(b) El costo subió, y mucho.** Seis bloques consecutivos de 600 frames, todos con el jugador
quieto:

| | NR OFF (8.18) | NR ON (ésta) | delta |
|---|---|---|---|
| feed CPU | 0,35 ms/frame | **0,95 ms/frame** | +0,60 ms — **2,7x** |
| frame interval | ~19,2 ms | **~21,9 ms** | **+2,7 ms** |
| FPS | ~52 | **~45,5** | **−6,5 fps (−12,5 %)** |

Estabilidad: `0,93 / 0,94 / 0,95 / 0,95 / 0,98` ms en bloques sucesivos, y `44,4 / 45,4 / 45,7 /
45,7 / 46,3 / 46,5` fps. La dispersión es chica; el salto respecto de los `0,34-0,36 ms` de ocho
bloques previos es enorme.

**El costo real del pipeline completo es ~5x el que R3 había medido** (−12,5 % contra −2,4 %),
porque aquel A/B tenía `NR IS OFF` en las dos ramas. La corrección de 8.19 queda cuantificada.

**Detalle que vale leer:** el frame interval sube **+2,7 ms** pero el `feed CPU` sólo **+0,60 ms**.
Los ~2,1 ms de diferencia son trabajo de **GPU** del pase neural, que el feeder no contabiliza en
su propia métrica de CPU. O sea: el grueso del costo no está donde el feeder lo mide.

**Estado del número: `probable`, no `confirmado`.** Los dos tramos son consecutivos pero no
pareados — misma sesión y jugador quieto en los dos, pero no garantizadamente la misma escena.
Para subirlo a `confirmado` está la herramienta que 8.19 encontró y que **todavía no se usó**:
`F6` togglea el NR en vivo sin tocar un archivo, y el feeder escribe un bloque de 600 frames cada
~12 s. Tres pulsaciones (ON → OFF → ON), quieto en el mismo lugar, dan tres bloques comparables
sin ninguna otra variable moviéndose. La carpeta `DLSS5Screenshots\` **no existe todavía**: `F5`
no se usó.

#### El trade que el cuello de botella deja a la vista, y es el próximo movimiento de peso

Los números de 8.18 dejaron medido que **el cuello es el GS (95 %), con la GPU al 20-25 %**. El
neural rendering gasta **GPU**, que es justamente el recurso que sobra; el supersampling de
`upscale_multiplier=3` gasta **GS**, que es el que está saturado.

Eso abre un experimento de apalancamiento alto, que **no es un slider**:

> **Bajar `upscale_multiplier` de 3 a 2 con el NR encendido.**

Libera presión sobre el recurso saturado y se la pasa al que está ocioso. La pregunta que
responde: **¿el neural rendering compensa la pérdida de supersampling?** Si la respuesta es sí, se
recuperan los ~6,5 fps sin costo visual — y además se despeja la duda de fondo de 8.18, donde el
supersampling y el neural estaban compitiendo por hacer el mismo trabajo (antialiasing) desde dos
recursos distintos.

Requiere emulador cerrado (es `PCSX2.ini`, compartido con la línea 7e — ver 8.17) y respaldo ya
existe en `pruebas/PCSX2.ini.respaldo-2026-09-02`.

#### Orden pendiente, sin cambios respecto de 8.19 salvo el punto 1, que ya se hizo

1. ~~Prender `Enable DLSS Neural Rendering`~~ — **hecho**.
2. **`F6` + `F5` como método.** Sin esto, cada prueba siguiente vuelve a producir un número
   `probable`. Es lo más barato que queda y habilita todo lo demás.
3. **El insumo de motion vectors** (`LumeniteFX Kernel, 1/8 res, Bilinear` hoy). Alternativas en
   el panel: `4 LumeniteFX QuantMotion`, `Geometry vectors (camera model + depth)`.
4. **`NR Preset` / `NR Style`** — comportamiento del modelo. La doc sugiere `E` o `F` si el
   movimiento se deforma alrededor de transparencias (polvo, humo, llamas — BLACK tiene los tres).
5. Los sliders.

Y **el experimento del `upscale_multiplier`** de arriba, que por apalancamiento va entre el 2 y el
3: es estructura (a qué recurso se le pide el trabajo), no parámetro fino.

---

## 9. TEXTURAS / LINEA VISUAL - abierta el 2026-09-02. Fuente: `docs/09-remaster-visual.md`

**Esta sección NO se extiende.** Todo el detalle vive en `black/docs/09-remaster-visual.md`,
enlazado desde el contrato. Acá va sólo lo que una sesión nueva necesita para no repetir
trabajo ni pisar nada.

### Lo cerrado

**2026-09-02 - el pack carga.** Había 8225 `.dds` DXT5 (1305 MB, mtime 23/10/2022) en
`C:\Program Files\PCSX2\PCSX2\textures\SLUS-21376\` y nunca cargaron: PCSX2 lee del
*data dir*, que es `C:\Users\frans\Documents\PCSX2\`. Copiadas al lugar correcto,
`emulog.txt` emite `Disabling autogenerated mipmaps...`. Fran validó jugando: *"se ve bien"*.

**2026-09-03 - FASE V1 CERRADA: los tres números.** Detalle y controles en
`pruebas/cobertura-pack-2026-09-03.md`; síntesis en `docs/09` §6.

```
(a) GameIndex : los 6 gsHWFixes de SLUS-21376 YA se aplican solos. Nada que corregir.
(b) el pack   : 5213 assets (no 8225: 3012 son variantes de CLUT).
                100 % paletizado. Upscale 4,0x UNIFORME en los 8225.
(c) COBERTURA : 90/127 = 70,9 % (+/- ~1).  29 % cae al original de PS2.
```

**2026-09-03 (noche) - FASE V2 CERRADA: el sintoma de la barrera es el MIPMAP.**
Detalle completo en `docs/09` **§7**; el experimento y su arbol de decision en
`pruebas/precache-prediccion-2026-09-03.md`.

```
H1 carga asincrona  : MUERTA. Precache ON (2,09 GB privados, medido) y no se movio.
H4 post-proceso     : MUERTA. ReShade fuera (logs sin escribir) y no se movio.
CAUSA (`probable`)  : el pack reemplaza SOLO el mip 0. 0 de 8225 archivos llevan
                      '-mip'. Los niveles bajos caen al original de PS2.
                      El sintoma esta atado al ANGULO, no a la distancia.
```

**2026-09-03/04 - FASE V3 CERRADA: la causa queda `confirmado` por efecto.**
Detalle en `docs/09` **§7.5**; prediccion en `pruebas/prediccion-V3-mipmap-2026-09-03.md`.

```
mipmap = false, hw_mipmap = false (PCSX2 cerrado) + ReShade apagado, verificado
por efecto (logs sin escribir Y emulog.txt logea "El mipmapping esta desactivado").
Fran mirando el savestate 03 en los dos angulos: "se ve nitida en los dos angulos".
CAUSA: CONFIRMADA. mipmap=false queda como estado de hecho hasta regenerar el
mip chain del pack (item 1 de la NEXT ACTION, mas abajo) - no revertir.
```

**El confound que hay que conocer antes de tocar nada de esta linea:** el
`pcsx2-qt.exe` de la ruta corta es **el mismo binario** de la linea DLSS5 (§8), con
ReShade + DLSS5-Feeder + RenoDX + LumeniteFX inyectados por `dxgi.dll`. Las dos
lineas NO son independientes en el disco, aunque este archivo las declaraba asi.
**`dxgi.dll` quedo renombrado a `dxgi.dll.disabled`** para la corrida limpia: hay
que restaurarlo para volver a la linea DLSS5.

### DO NOT REPEAT

- **No descartar los mipmaps con "de cerca se usa el nivel 0".** El nivel de mip se
  elige por el **footprint de la textura por pixel** (derivada de UV), no por
  distancia: una pared plana mirada de refilon a un metro pide mip 2. Ese descarte
  mal razonado vivio en `docs/09` §1.5 desde el 2026-09-02, y ademas **ranqueo
  "regenerar mipmaps" como item 7 de 7** en esta misma lista de NEXT ACTION.
- **No correr NINGUNA prueba visual de esta linea sin verificar antes que ReShade no
  este cargado**, y verificarlo por EFECTO (que `ReShade.log` y `dlss5-feed.log` no
  se escriban tras el arranque), no por que el archivo este renombrado.
- **No leer el `.ini` para saber si los fixes del GameDB están puestos: da la respuesta
  INVERTIDA.** `UserHacks_HalfPixelOffset = 0` y `UserHacks_native_scaling = 0` son los
  valores **manuales**, y `UserHacks = false` hace que PCSX2 los ignore y aplique los del
  GameDB (`GameDatabase.cpp:705`). Se mide en `emulog.txt`, buscando
  `GameDB: Enabled GS Hardware Fix`.
- **No cruzar nombres del pack contra dumps sin enmascarar el bit 14** (`0x4000`,
  `unused0 // was TCC`). El pack es de 2022 y trae la convención vieja: `00005dd4` contra
  `00001dd4`. El emulador lo ignora (`RemoveUnusedBits()`), un cruce a mano no, y **da 0 %
  de coincidencia**. Pasó en la sesión del 2026-09-03.
- **No diseñar la medición de cobertura como "contar todo y cruzar".** PCSX2 **no dumpea lo
  que ya tiene reemplazo** (`GSTextureReplacements.cpp:800`), así que con el pack activo
  `dumps/` ES el complemento. Son dos corridas, no un cruce.
- **No dar por buena una corrida porque el log tiene la línea del mipmap sin mirar la
  pantalla.** El savestate puede no haber cargado. Se verifica con una captura.
- **No leer los números de OSD de la corrida del 2026-09-02 como costo del pack:** fue sin
  turbo, y bajo el cap de velocidad nominal ningún costo se ve.
- **No dar por pendiente el test de los 12 bytes del `.WDD`:** las tareas 6.2 y 6.3 de
  `ESTADO_ACTUAL.md` §N3 ya tienen resultado parcial. Lo abierto es el **byte 0**.
- **No volver a auditar `Downloads/pipeline_metadev_ps2.txt`**: hecho el 2026-08-27.
- **El emulador de esta línea es `C:\Program Files\PCSX2\pcsx2-qt.exe`**, no los
  `lanzadores/*.bat` (ésos abren el fork PCSX2-MCP del reversing).

### Cómo se lanza una corrida de esta línea (probado el 2026-09-03)

```powershell
$iso = 'C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso'
$st  = 'C:\Users\frans\Documents\PCSX2\sstates\SLUS-21376 (5C891FF1).03.p2s'
Start-Process 'C:\Program Files\PCSX2\pcsx2-qt.exe' -ArgumentList @('-statefile', "`"$st`"", "`"$iso`"")
```

El savestate 03 cae **dentro de un nivel**, primera persona, con arma y HUD - verificado por
captura, no supuesto. Para desactivar el pack (rama B del A/B) se **renombra**
`replacements\`; **PCSX2 recrea una `replacements\` vacía al arrancar sin ella**, así que al
restaurar hay que sacar la vacía primero. `Remove-Item` con wildcard ahí lo **frena el
guardia**: se renombra, no se borra - y así además queda la evidencia.

### ESTADO DE LA MÁQUINA — actualizado al cierre del 2026-09-04

- **PCSX2 CORRIENDO** (la corrida de V3, savestate 03 cargado). Cero parches
  vivos en ISO, ningún ISO tocado.
- **`C:\Program Files\PCSX2\dxgi.dll` sigue renombrado a `dxgi.dll.disabled`.**
  ReShade/DLSS5/LumeniteFX/RenoDX **no cargan** en esta corrida — apagado a
  propósito para la V3 limpia. **Entre el cierre de V2 y el inicio de esta
  sesión Fran ya lo había restaurado una vez** (medido: nombre activo antes de
  volver a deshabilitarlo) — este archivo se toca ida y vuelta según qué línea
  se esté probando, y **el nombre por sí solo no prueba el estado**: se
  verifica por efecto (`ReShade.log`/`dlss5-feed.log`) antes de cada corrida
  visual, sin excepción.
- `C:\Users\frans\Documents\PCSX2\textures\SLUS-21376\replacements\` = **8225 archivos**,
  **ninguno con `-mip`**: sólo reemplazan el nivel 0. Sigue siendo el ítem 1 de
  la NEXT ACTION.
- `DumpReplaceableTextures = false`. `PrecacheTextureReplacements = true`.
  `LoadTextureReplacements = true`, `Async = true`. **`mipmap = false`,
  `hw_mipmap = false`** (cambiado el 2026-09-03 para V3; QUEDA ASÍ — es la
  causa confirmada, revertir a `true` reintroduce el síntoma).
- Respaldos del `.ini`: `pruebas/PCSX2.ini.respaldo-2026-09-02`, `...-2026-09-03-V1`,
  `...-2026-09-03-V2` y **`...-2026-09-03-V3`** (el previo al cambio de mipmap).
- Evidencia fuera del repo, en `Documents\PCSX2\textures\SLUS-21376\`:
  `dumps-A2-pack-activo` (38), `dumps-B-pack-off` (127), `dumps-A1-sospechosa` (37) y
  `replacements-vacia-recreada` (0). Los **listados** sí están en `pruebas/`.

### NEXT ACTION, en orden de apalancamiento — REORDENADA el 2026-09-04 por §7.5 (V3 cerrada)

1. **Regenerar el mip chain del pack** — el arreglo de fondo, ahora ítem de
   mayor apalancamiento abierto de esta línea. `mipmap=false` es el parche de
   hecho (funciona, confirmado por efecto) pero apaga mipmapping GLOBAL, con
   riesgo de shimmer/aliasing en otras superficies (anticipado en §1.4, nunca
   medido). Regenerar mips propios para los 8225 `.dds` permite volver a
   `mipmap=true` sin el síntoma original. Requiere: decodificar DXT5, generar
   niveles descendentes, recomprimir a DXT5, nombrar con el sufijo `-mip%u`
   confirmado en los strings del `.exe` (§7.3). Tarea de ingeniería nueva, no
   un runbook — sondear herramientas disponibles antes de diseñar el script.
2. **A/B visual pareado de verdad.** Las capturas del 2026-09-03 NO lo son: la escena tiene
   humo y fuego animados y los frames no coinciden.
3. **Atar la barrera concreta que Fran vio a un hash de la lista A**
   (`pruebas/cobertura-A-sin-reemplazo-2026-09-03.txt`, 38 entradas).
4. **Cobertura en otra escena**: 70,9 % es de un savestate, no del nivel.
5. **Costo en FPS con turbo**, método de R3 (`F6`/`F5`).
6. `accurate_blending_unit` 3 -> 4, que el GameDB recomienda (mode=4) y nadie midió.

~~1. `mipmap = false` (o `hw_mipmap = false`), PCSX2 cerrado, mismo ángulo~~ —
**corrida y CONFIRMADA el 2026-09-04** (§7.5). Fran: *"se ve nítida en los dos
ángulos"*.

~~1. `PrecacheTextureReplacements = true`~~ — **corrida y MUERTA el 2026-09-03.**
Quedó en `true` en el `.ini`; no molesta, cuesta 1,3 GB de RAM y ~8 s de arranque.

**MODEL/EFFORT REC:** Sonnet, esfuerzo medio, sin fan-out. El método está decidido y lo que
queda es ejecutar y tabular. Sube a Opus sólo si un resultado contradice lo anotado.
