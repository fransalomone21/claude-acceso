# La línea visual — remaster, texturas y remake

**Qué es esto.** El inventario de la línea de trabajo *visual* de BLACK: lo que
está montado, lo que está disponible sin usar, y lo que queda abierto. Es una
línea **aparte de la 7e** (reversing) y aparte del pipeline DLSS5, que ya tiene
su propio registro en `sesiones/HANDOFF.md` §8.

Nació el 2026-09-02 de una pregunta de Fran —*"¿qué quedaría pendiente en
gráficos o texturas?"*— que no tenía dónde contestarse: el pipeline DLSS estaba
documentado hasta el detalle y las texturas no aparecían en ningún archivo del
repo. Un pendiente que no vive en ningún lado no se retoma: se vuelve a
descubrir.

---

## 1. EL HALLAZGO: hay un pack de texturas HD instalado, y no está cargando

**Grado: `confirmado` lo medido; `probable` la conclusión.** Medido el
2026-09-02 con `Get-ChildItem` y lectura de cabeceras DDS en Python.

### 1.1 El pack existe y es grande

```
C:\Program Files\PCSX2\PCSX2\textures\SLUS-21376\replacements\
    8225 archivos .dds        1305,5 MB       todos DXT5
    mtime de los archivos:    23/10/2022  (min y max, rango de 32 minutos)
    mtime de la carpeta:      19/06 (2026)
```

Convención de nombre `<16 hex>-<16 hex>-<8 hex>.dds`, que es la de reemplazo de
texturas de PCSX2. Ejemplo: `1004865c455633eb-86566ebe97acefe8-00005554.dds`.
**52 sufijos distintos** en el tercer campo, con la mayor parte concentrada en
cinco (`00005dd4` ×1527, `00005994` ×1424, `00005554` ×1155, `00005114` ×1018,
`00004cd4` ×755).

Distribución de dimensiones, sobre una muestra sistemática de 484 archivos
(1 de cada 17):

| dimensión | n | | dimensión | n |
|---|---|---|---|---|
| 512×512 | 111 | | 1024×1024 | 26 |
| 256×256 | 98 | | 64×32 | 10 |
| 128×128 | 86 | | 256×128 | 9 |
| 64×64 | 57 | | 128×64 | 9 |
| 32×32 | 40 | | resto rectangulares | ~38 |

**Que sea un pack HD y no un volcado crudo es `probable`, no `confirmado`.** A
favor: están comprimidos en DXT5 —un volcado no hace ese paso—, viven en
`replacements/` y no en `dumps/`, y la moda es 512² con cola en 1024², cuando la
PS2 rara vez pasa de 256² por su VRAM de 4 MB. En contra: no hay README, ni
manifiesto, ni nada que diga de dónde salió. **El origen del pack está sin
identificar** y es una de las preguntas del barrido web (§4).

### 1.2 Por qué no está cargando

Tres mediciones encadenadas:

```
1. [Folders] Textures = textures        -> relativo al DATA DIR, no a la instalación
2. el data dir activo es Documents\PCSX2 -> su inis\PCSX2.ini tiene mtime 02/09/2026 12:03
                                            (el de OneDrive\Documents quedó en 16/08/2026)
3. C:\Users\frans\Documents\PCSX2\textures\  -> 0 archivos
```

Y ninguna de las dos instalaciones (`C:\Program Files\PCSX2\` ni
`C:\Program Files\PCSX2\PCSX2\`) tiene `portable.txt` ni carpeta `inis\`, así
que ninguna usa su propia carpeta como data dir hoy.

**Confirmado:** la carpeta que PCSX2 lee está vacía.
**Probable:** por eso el pack nunca cargó en ninguna de las corridas de R0/R1/R2.

*Hipótesis alternativa, nombrada a propósito (lección 4):* que en junio de 2026,
cuando la carpeta se creó, esa instalación sí corriera en modo portable y el
pack haya cargado entonces. Es compatible con todo lo medido y **no cambia la
conclusión para hoy**. Se descarta o confirma con el mismo test que lo resuelve
todo: mover el pack y mirar la pantalla.

### 1.3 El resto del sistema ya está a favor

```
LoadTextureReplacements       = true     <- ya prendido
LoadTextureReplacementsAsync  = true
PrecacheTextureReplacements   = false    <- a evaluar: 1,3 GB de precarga
DumpReplaceableTextures       = false    <- el switch para volcar y medir
DumpPaletteTextures           = true
```

**Costo de la prueba: copiar una carpeta.** No toca el ISO, no toca el CRC, no
toca los savestates, no interfiere con la línea 7e. Es el experimento de mejor
relación efecto/riesgo que hay abierto en todo el proyecto.

---

## 2. CORRECCIÓN a lo dicho el 2026-09-02 sobre ReShade

Se afirmó en chat que *"el repo estándar de ReShade no está bajado"*. Medido,
es más matizado y hay que anotarlo bien:

| instalación | Shaders | qué tiene |
|---|---|---|
| `C:\Program Files\PCSX2\reshade-shaders\` (**activa**) | 20 archivos | base de ReShade (`DisplayDepth`, `Deband`, `LUT`, `Daltonize`, `UIMask`) + los 8 `lumenite_*` + `DLSS5_Feed` |
| `C:\Program Files\PCSX2\PCSX2\reshade-shaders\` (vieja) | 13 archivos | base + `AdaptiveSharpen` + `FilmicPass`, y una carpeta `Textures\` completa (`Dirt`, `LensDB`, `MagicBloom_Dirt`, `SweetFX\`) |

O sea: **la base está en las dos; el repo completo de la comunidad (qUINT,
SweetFX entero, MXAO) no está en ninguna.** La instalación vieja tuvo en su
momento un ReShade más completo — sus texturas quedaron, sus shaders no.

---

## 3. EL INVENTARIO DE LO ABIERTO, ordenado por apalancamiento

### 3.1 Gráficos — el pipeline DLSS está montado, falta exprimirlo

Detalle completo en `sesiones/HANDOFF.md` §8.17–8.20. Resumen de lo abierto:

| # | qué | escalón | estado |
|---|---|---|---|
| 1 | **Cerrar R3 con F6+F5** — el `−12,5 %` de FPS del NR es `probable`, medido en dos tramos no pareados | flujo de información | el método existe y **nunca se usó** |
| 2 | **`upscale_multiplier` 3 → 2 con NR encendido** | estructura | el cuello es el **GS al 95 %** con la **GPU al 20-25 %**: el supersampling gasta el recurso saturado y el neural gasta el ocioso |
| 3 | insumo de motion vectors (hoy `LumeniteFX Kernel, 1/8, Bilinear`) | parámetro alto | alternativas en el panel: `QuantMotion`, `Geometry vectors` |
| 4 | `NR Preset` / `NR Style` | parámetro | la doc sugiere `E`/`F` con transparencias, y BLACK tiene polvo, humo y llamas |
| 5 | los sliders | el más bajo | sin tocar |

**Eje que todavía no se midió:** el costo escala con la **pantalla**, no con el
`upscale_multiplier` (§8.8 — el swapchain es 1920×1080 porque la notebook es
1080p). En la PC de escritorio el backbuffer va a ser 2K y DLAA + NR van a
correr a 2K. **Ningún número de R1/R3 porta a esa máquina.**

### 3.2 Texturas — dos vías independientes

**Vía A — reemplazo de PCSX2.** Barata, reversible, no toca el ISO. Es la de
§1: el pack ya está en el disco. Después de probarlo, lo que sigue es medir
contra qué se compara — prender `DumpReplaceableTextures`, cargar `LEVEL_00` y
**contar cuántas texturas usa el nivel**. Eso convierte "hacer un pack" de una
intención en un número.

**Vía B — RenderWare, adentro del ISO.** Es la **capacidad C** del mapa de
fases, abierta: faltan `.WDD` `.DB` `.BKS` `.SSH` `.SLB`. Herramientas ya
inventariadas en `docs/06-herramientas-externas.md` §"El frente RenderWare".
**Test barato pendiente desde el 2026-08-16, cuesta un minuto:** leer los
primeros 12 bytes de un `.WDD` de `FPGUNS/` y ver si el tipo de chunk cae en la
tabla RW (`0x16` = texture dictionary, `0x10` = clump). Los `.WDD` miden 65536
bytes exactos, lo que huele a búfer de tamaño fijo y no a stream.

**La diferencia que ordena las dos:** la vía A mejora **cómo se ve** el juego
que ya está. La vía B cambia **lo que el juego tiene** — es la única que sirve
para modelos, armas o niveles nuevos.

### 3.3 El techo que ninguna de las dos levanta

BLACK tiene texturas de 2006. El neural rendering **reconstruye e ilumina; no
inventa textura que no existe**. Y sin jitter de cámara —PCSX2 no jitterea— el
blend temporal de DLAA suaviza en vez de agregar detalle (§8.18, causa (2), sin
probar todavía). El salto visual grande de un juego de PS2 vive en las texturas
y en el shading, no en el post-proceso.

### 3.4 Lo no visual que sigue abierto

De la línea 7e: **7e(b)** —un módulo verificado por efecto— sigue sin hacerse y
ya está autorizado desde el 2026-08-29. **5b** (qué elige la zona de impacto) y
**5a** (pnach de daño de salida, parqueada) siguen igual.

Del `docs/00-conops.md`: **R3** (IA más aguda — clases identificadas, valores
no), **R4** (qué enemigos aparecen — depende de 7e), **R5** (coop) y **R6**
(nivel nuevo — depende de la vía B).

De entorno, sin fase: BLACK a 10 fps en el menú del 2026-08-22. Criterio de
salida de dos minutos, sin hacer.

---

## 4. EL BARRIDO WEB — lanzado el 2026-09-02, pendiente de aterrizar

Se lanzó un barrido de 7 ángulos sobre lo que hay hecho por terceros. **Lo que
NO se mandó a investigar, porque ya está en el repo** (lección 9): las
herramientas RenderWare de `docs/06`, las de ISO, y lo ya evaluado y descartado
(ResHax, QuickBMS/Noesis, mcp-pine). El ángulo de formatos se reconvirtió de
"barrido nuevo" a **re-chequear un negativo con fecha** — *"no hay script para
BLACK"* es del 2026-08-16 y un negativo escrito envejece peor que un positivo
(lección 19).

Los 7 ángulos: reemplazo de texturas en PCSX2 y origen del pack · formatos de
BLACK (re-chequeo) · la escalera de remakes de PS2 con precedentes · decomp y
recompilación estática · **la versión Xbox del juego** · comunidades y discords
activos · opciones de imagen del propio emulador.

**Cada agente llevó un control positivo obligatorio** —un ítem cuya respuesta ya
se conoce— para que sus negativos sean interpretables (lecciones 14, 17, 18).
Los resultados van abajo cuando aterricen.

---

## 5. Lo que NO es un hallazgo, para que no se vuelva a levantar

`Downloads/pipeline_metadev_ps2.txt` **ya fue auditado** el 2026-08-27, ítem por
ítem, y la auditoría está guardada en
`perfil-global/referencias/auditoria-pipeline-metadev.md` junto con el original.
Resultado de entonces: cinco mecanismos ya implementados, uno a medias, dos
adoptados, uno rechazado con razón. **No volver a auditarlo** — es la lección 26
y su propio caso de origen.
