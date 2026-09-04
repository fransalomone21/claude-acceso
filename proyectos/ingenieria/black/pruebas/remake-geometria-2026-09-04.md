# Línea de remake — pregunta 1: geometría, RenderWare y el formato `.WDD`

**Investigación del 2026-09-04**, lanzada como agente en paralelo (Opus).
Contesta la pregunta 1 de `sesiones/HANDOFF.md` §10. La pregunta 2
(texturas / IA) va en `remake-texturas-ia-2026-09-04.md`.

**No repite** el barrido del 2026-09-02 (`barrido-remake-2026-09-02.md`) — pero
sí lo **corrige** en cuatro puntos: ver la última sección.

> `[confirmado]` = visto en fuente primaria (código, wiki oficial, el hilo
> mismo). `[probable]` = fuente secundaria creíble. `[hipótesis]` = inferencia.

---

## LOS TRES HALLAZGOS QUE CAMBIAN EL PLAN

### 1. `fmt_Burnout3LRD.py` NO es "sólo texturas": trae un decodificador de geometría PS2 funcionando

`[confirmado]` — es una **corrección** a lo que el proyecto tenía anotado. El
docstring del plugin declara modelos para Burnout 3 / Legends / Revenge /
Dominator, y tiene la función `boMdlPS2(mdl, vifStart, vifFull, primLine)` con:

```python
vifUnpack.extend(rapi.unpackPS2VIF(mdl.readBytes(vifSize)))
```

**`rapi.unpackPS2VIF()` es una función nativa de Noesis**: el desempaquetado de
streams VIF de PS2 **ya está resuelto por el host**, no hay que escribirlo.

Y el mismo archivo **ya abre los contenedores de BLACK** (`.db` y siete
variantes de `.bin`: Glob, Guns, LevelDat, StLevel, StUnit, Unit, Font).

**Por eso el trabajo no es "escribir un importador desde cero": es conectar el
parser de contenedor de BLACK, que ya existe, con el decodificador de
geometría PS2, que ya existe, los dos en el mismo archivo.** Tarea acotada, no
programa de investigación.

https://github.com/EdnessP/scripts/blob/main/burnout/fmt_Burnout3LRD.py

> **LICENCIA — leer antes de derivar nada.** `EdnessP/scripts` **no tiene
> archivo de licencia**, o sea todos los derechos reservados por defecto (igual
> que `escape209/AWDio`). Si esto termina publicado, corresponde pedir permiso
> o reimplementar. `librw` sí es MIT. **Por eso no se commiteó ningún archivo
> de terceros a este repo, que es público.**

### 2. Existe `burnout.wiki`, con ~650 páginas del motor de Criterion — y no estaba en el barrido

`[confirmado]` https://burnout.wiki/ — documenta estructuras internas
(`CGtV3d`, `CGtMatrix3x4`, `GtID`, Texture Dictionary, Wave Dictionary,
Static/Streamed Track Data, Resource Types…), mantenida por la misma gente que
escribió el plugin de Noesis. Es el agujero grande del barrido anterior.

**Nota operativa:** `WebFetch` da **403** en ese sitio, y `api.php` también
está bloqueado. Se lee con:

```bash
curl -A "Mozilla/5.0" "https://burnout.wiki/index.php?title=<Pagina>&action=raw"
```

**Dato ejecutable en 10 minutos** (de *Formats (Takedown-Dominator)*): cada
bloque de datos de malla en la versión PS2 **empieza con la secuencia
`00 00 00 05 03 01 00 01 00 80`**. Buscarla en los `.DB` y `.bin` de BLACK: si
aparece, los bloques de malla quedan localizados sin parsear nada. Si no
aparece, se mató una hipótesis barata — pero probar también **desplazada y
alineada a 16 bytes** antes de anotar el cero.

### 3. La cabecera del `.DB` está descifrada: es un **GtID**, el nombre lógico del propio archivo

`[probable, verificable en un comando]` — y explica una invariante que el
proyecto tenía medida sin entender.

`GtID` es el formato de string comprimido de Criterion: hasta 12 caracteres en
8 bytes, alfabeto de 40 símbolos `" -/0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_"`,
little-endian. El agente verificó el códec con **dos controles positivos**
antes de usarlo: las 10 constantes del plugin de Edness se re-codifican exactas
(10/10), y el ejemplo publicado del wiki (`GtID("BURNOUT") = 0x5667885FFDD40000`)
da idéntico.

Decodificando **nuestra propia medición** (byte 0 = `0x00`, bytes 6-7 = `"FT"`):

```
top bytes 0x5446  ->  el string empieza con "BG1_"
```

Y a la inversa: **cualquier nombre que empiece con `BG1_` produce exactamente
bytes 6-7 = `46 54` = `"FT"`**, y byte 0 = `0x00` si el nombre tiene ≤ 9
caracteres. Las dos invariantes de 139/139 caen solas. El byte 5
(`0x12`/`0x14`/`0x15`) queda determinado por el **quinto carácter** del nombre.

Cierra con lo que ya sabíamos: los archivos se llaman `BG1_XXX.DB`. **La
cabecera del `.DB` es el nombre lógico del propio archivo**, igual que el
Texture Dictionary de Criterion empieza con `GtID("TEXDIC")`.

**Predicción que sale de esto y conviene testear en el mismo rato:** el plugin
hace `chkVer = readUInt(0); if chkVer != 4: seek(0x18); chkVer = readUInt()`.
O sea que la versión del `.DB` de BLACK PS2 está en **`0x18`**, con un
preámbulo de 24 bytes = probablemente **tres GtID de 8 bytes**. Decodificar
`[0x08:0x10]` y `[0x10:0x18]`: si salen strings legibles, la cabecera queda
resuelta entera.

---

## EL `.WDD`: qué NO es, y la hipótesis que queda

### No es una tabla de chunks de RenderWare `[confirmado]`

`0x0000020C` no es un chunk type conocido (los core van 0x01–0x2C; los de
plugin son 0x0110, 0x0116, 0x0118, 0x0120…), y aunque lo fuera, un header RW
válido pediría size y version coherentes detrás — que ya medimos que no están.
**Descartado.**

### NO es "Wave Dictionary" — la pista era buenísima y se cae con dos medidas `[confirmado]`

Criterion tiene un *RenderWare Audio Wave Dictionary* y **BLACK lo usa**
(https://burnout.wiki/wiki/Wave_Dictionary, que nombra a BLACK explícitamente).
Encajaba muy bien: nuestros dos tamaños, 16384 y 65536, son 8× y 32× `0x800`,
y `AWDio` documenta *"Container length must be multiple of this"* para `0x800`.

**Pero:**

1. El magic del stream header es `0x809` en `0x00`. Nuestros `.WDD` tienen
   `0x020C`. `AWDio` valida y rechaza.
2. **vgmstream ya soporta los wave dictionaries de BLACK, y los llama `.awd`,
   no `.wdd`.** En `src/meta/awd.c` hay incluso una rama con el comentario
   `/* not used in Black */` — alguien ya probó ese parser contra este juego.
   Extensiones registradas: `awd`, `hwd`, `lwd`. **`wdd` no está.**

**Beneficio lateral: el audio de BLACK ya está resuelto** — vive en `.AWD` y
es extraíble con vgmstream sin trabajo.

### La hipótesis que queda: el u32 de `0x00` es un **puntero al inicio de los datos** `[hipótesis]`

Los 19 valores del byte 0 con el byte 1 fijo en `0x02` ponen el u32 en
`[0x0200, 0x02FF]` = **512-767**. Eso no parece una versión (sería constante)
ni un magic (sería constante): parece **un tamaño de cabecera variable**. A favor:

- La convención de punteros de Criterion en estos archivos es **offset absoluto
  relativo al archivo** (en el plugin, `readPtr()` lee un int y se usa directo
  con `seek()`; `0` = nulo). Dato útil por sí solo: ahorra el ensayo-error.
- El propio AWD hace exactamente eso (`data_offset` en `0x08`, `header_size` en
  `0x28`, y vgmstream **exige que sean iguales**). Es idiomático del motor.
- **Explica `GRDPIN.WDD`**: `0x020C` = 524, y de 4 a 16383 todo ceros →
  cabecera de 524 bytes vacía y cero datos. Es un **slot preasignado sin
  contenido**, no un archivo corrupto.

Rivales, para matarlas explícitamente: **(b)** `[byte0 = cantidad][byte1 =
versión = 2]` como dos `uint8` — a favor, Criterion documenta diccionarios cuyo
primer campo es `muVersion` con valor **2**; en contra, ahí es `uint32_t`.
**(c)** u32 = cantidad de entradas — en contra, 524 entradas en un archivo
entero en cero es raro. **(d)** magic propio — en contra, variaría en 19 valores.

### Y el razonamiento de "potencia de dos = slot fijo" queda REFORZADO `[confirmado]`

**16384 = 8 × 0x800** y **65536 = 32 × 0x800**, y `0x800` es a la vez el sector
de un DVD de PS2 y la unidad de alineación que Criterion usa explícitamente en
sus contenedores. Un archivo con sólo dos tamaños posibles, ambos múltiplos
exactos de `0x800` y con relleno en cero, es un **buffer de tamaño fijo leído
con un DMA de N sectores sin consultar tamaño**. Un comprimido no produce dos
tamaños exactos en 141 archivos.

### Los tres experimentos que lo resuelven, en orden de costo

1. **`strings` sobre el ELF (`SLUS_213.76`) buscando `WDD`, `.wdd`, `%s.wdd`.**
   Si aparece una cadena de formato con la extensión, la referencia cruzada
   lleva al cargador, y el cargador dice qué es el archivo.
2. **Mirar un `.WDD` que NO esté vacío.** `GRDPIN.WDD` está vacío y por eso no
   informa. En uno con contenido: ¿el offset del u32 de `0x00` es donde
   empiezan los datos no nulos? ¿Hay GtIDs decodificables cada 8 bytes? ¿Hay
   valores que parezcan offsets dentro de `[0, filesize)`?
3. **Control positivo obligatorio:** antes de leer cualquier cero como
   hallazgo, verificar que el decodificador GtID encuentra los nombres que **ya
   sabemos** que están (`TEXDIC`, `MODELS`) en un `.DB`. Si no los encuentra
   ahí, un "no hay GtIDs en el WDD" no vale nada.

---

## ¿HAY CAMINO PARA EXTRAER GEOMETRÍA?

**Sí, y el cuello de botella no era el que creíamos.** La limitación de `librw`
no es el bloqueo; el bloqueo es que **nadie publicó nunca una herramienta que
saque geometría de BLACK, en ninguna plataforma**.

### Dos personas ya lo hicieron, en privado `[confirmado]`

Hilo de ResHax leído entero (6 participantes, feb-2024 a may-2025):
https://reshax.com/topic/514-ps2xbox-black-by-criterion-games-bin-db/

- **h3x3r** (490 posts, 216 de reputación), 2024-02-20, textual: *"I reversed
  it a long time ago. xbox version is easier. I want to make remake in cryengine
  but I don't have a time..."*
- **shak-otay** (1,5k posts), 2024-04-25, corrobora con **una captura del
  modelo abierto** (`Unit_02-bin.png`).
- Tres pedidos posteriores de plugin, **sin una sola respuesta con
  herramienta**. No hay script, BMS, plantilla 010 ni plugin en todo el hilo.
- El autor dejó **muestras reales** de `.bin`/`.db`:
  https://mega.nz/folder/wOJChSLZ#ang6cHByvOfKjaW2azO7tA

**h3x3r reversó BLACK, quiere hacer un remake y no tiene tiempo. Es exactamente
el perfil que le contesta a alguien que sí va a hacer el trabajo.** Escribirle
es la acción de mayor apalancamiento de esta línea. Y el Discord de Burnout
Modding (`discord.gg/8zxbb4x`, citado dentro del propio plugin) es donde vive
lo que no está en el wiki.

### Qué es "pre-instanced" y por qué cuesta `[confirmado]`

https://gtamods.com/wiki/Native_Data_PLG_(RW_Section) — chunk `0x00000510`
(**no** `0x1B`, que es otra cosa en algunas tablas).

Es la geometría ya convertida al formato de la plataforma. *"A pre-instanced
DFF can only be used by the same platform that wrote the file"*. El `data` **no
es una lista de vértices**: es una **cadena de paquetes DMA que se mandan al
VIF al dibujar**. DMAtags (`cnt`/`ref`/`ret`) y VIFcodes (`NOP`, `STCYCL`,
`ITOP`, `STMOD`, `FLUSH`, `MSCALF`, `MSCNT`, `UNPACK`). Los atributos son
`xyz`, `xyzw`, `uv`, `uv2`, `rgba`, `normal` **y cuatro clusters definidos por
el usuario** — ésos cuatro son la razón por la que un parser genérico falla
contra un juego que no sea GTA.

**Reglas de alineación que sirven de control:** todo atributo múltiplo de 4
bytes; vértices por batch múltiplo de 4; para triángulos, múltiplo de 12.

### El camino, en orden

1. Correr `fmt_Burnout3LRD.py` en Noesis con `BoDebug = True` y
   `BoModels = True` sobre un `.bin` de BLACK (`Unit*.bin` / `StUnit`). Ver qué
   imprime: offsets VIF, tamaños, orden de unpack.
2. Buscar la firma `00 00 00 05 03 01 00 01 00 80` en los `.DB`/`.bin`.
3. Si aparece, pasar ese bloque a `boMdlPS2()` / `rapi.unpackPS2VIF()`. **Es el
   experimento de menor costo y mayor información del proyecto ahora mismo.**
4. Escribirle a h3x3r y al Discord de Burnout Modding.
5. El **reimport** es el tramo sin precedente público: nadie publicó
   re-instanciación a PS2 para este motor. Lo más cercano es `bxv_palsplit.bms`
   de Edness, que sí reimporta **texturas y paletas**, no malla.

### Sobre la ruta por Xbox: sí es más fácil, pero es **oráculo, no atajo**

`[probable]`. Lo sostienen la afirmación de h3x3r + la captura de shak-otay, y
sobre todo **evidencia estructural**: en Xbox la geometría es un vertex buffer
D3D8 plano, en PS2 es la cadena DMA/VIF; las texturas son DXT1 contra
CLUT4/CLUT8 con paleta entrelazada. Y por **revelación de preferencia**: *todos*
los scripts de modelos publicados para este motor son Xbox o X360.

**Contrapeso honesto:** el objetivo es reimportar **en PS2**. Extraer por Xbox
da la malla para mirarla y para **validar** el parser propio, pero el camino de
vuelta obliga igual a re-instanciar a VIF/DMA. Sirve como oráculo.

---

## NEGATIVOS MEDIDOS — no volver a buscarlos

| qué se buscó | resultado | cómo se midió |
|---|---|---|
| herramienta pública que extraiga **geometría** de BLACK, cualquier plataforma | **NO EXISTE** | hilo ResHax 514 leído completo: cero scripts. El plugin de Noesis lista BLACK sólo en *Textures*. ZenHAX/XeNTaX/GitHub/Reddit: nada |
| BLACK en `burnout.wiki` | **CERO páginas** | full-text: `WDD` → 0 hits, `GRDPIN` → 0, `Black` → 4 irrelevantes. La *Contributor guide* **autoriza explícitamente** documentar BLACK ahí; nadie lo hizo |
| `.WDD` documentado en algún lado | **NADA** | burnout.wiki (0), `formats.c` de vgmstream (no registrado), web. Lo único con esa extensión es RAGE/GTA IV — **motor distinto, falso amigo** |
| modelos de BLACK en Models-Resource / Sketchfab / VG-Resource | no encontrado | búsquedas dirigidas. Negativo de confianza **media**: no se revisó sitio por sitio |
| QuickBMS para `.db`/`.wdd` de BLACK | **NO EXISTE** | listado completo de tools de Edness y de burnout.wiki/Modding |
| el `.SLB` (`01 00 00 00` + `"KING"`) | **sin identificar** | `KING` no aparece en burnout.wiki como magic. **Queda abierto** |

---

## CORRECCIONES a lo que el proyecto tenía anotado — leer sí o sí

1. **"El plugin de Noesis es SÓLO texturas."** Cierto **para BLACK**, falso
   para el plugin: trae un importador de modelos PS2 vía VIF/DMA funcionando
   para las pistas de Burnout 3/Revenge/Dominator. Subestimar esto es lo que
   hacía parecer el problema más grande de lo que es.
2. **"librw no soporta el DFF pre-instanciado de PS2 → bloqueo."** librw **sí**
   des-instancia (`objUninstance` en `src/ps2/ps2.cpp:874`,
   `genericUninstanceCB`, `convdff -u`), y lo hace mejor que el RenderWare
   original, que directamente no puede. El límite real es **no conocer el
   pipeline VU1 del juego** (~20 líneas de `MatPipeline` para describirlo). De
   todos modos no aplica a BLACK: nuestros archivos no son streams RW en
   primera capa, así que librw ni los abre. Queda como **referencia de cómo se
   des-instancia y como validador**, no como herramienta de línea.
3. **"Hay reversing público del XBE de BLACK con offsets concretos."** Cierto
   pero **inútil para este objetivo**. El artículo de agarmash.com trata
   **exclusivamente** de desactivar la verificación de firma de los savefiles
   (`XCalculateSignatureBegin/Update/End`, parche `74` → `EB` en `0x1E2E01`,
   con Ghidra + `ghidra-xbe`). **No menciona RenderWare, ni `.db`, ni `.wdd`,
   ni carga de assets.** Los "offsets concretos" que el barrido anotaba son de
   la rutina de firma de guardado.
4. **"Dos personas dicen que Xbox usa formatos más simples."** Más preciso:
   **h3x3r lo afirma y shak-otay lo corrobora con una captura**, y además lo
   sostiene la evidencia estructural.
5. **Faltaban `burnout.wiki` y el Discord de Burnout Modding**, las dos fuentes
   densas del dominio.
