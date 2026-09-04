# Línea de remake — pregunta 2: normal maps por IA y packs de la competencia

**Investigación del 2026-09-04**, lanzada como agente en paralelo (Opus).
Contesta la pregunta 2 de `sesiones/HANDOFF.md` §10. La pregunta 1
(geometría / RenderWare) va en `remake-geometria-2026-09-04.md`.

**No repite** el barrido del 2026-09-02 (`barrido-remake-2026-09-02.md`).

> **Cómo leer los grados de confianza.** `[confirmado]` = visto en fuente
> primaria (código, página de descarga, documentación oficial). `[probable]` =
> fuente secundaria creíble. `[hipótesis]` = inferencia, no medición.

---

## LOS TRES HALLAZGOS QUE CAMBIAN UNA DECISIÓN

### 1. PCSX2 NO PUEDE RECIBIR NORMAL MAPS — la pregunta 1 se cierra por arquitectura

`[confirmado]`, medido sobre el código fuente y no sobre documentación:

- En `GSTextureReplacements.cpp` (979 líneas), un grep de
  `normalmap|normal_map|bumpmap|specular|roughness|pbr` da **cero
  coincidencias**. La única aparición de "bump" es un comentario sobre una
  cola de trabajo, sin relación con gráficos.
- La tabla de loaders (`GSTextureReplacementLoaders.cpp`, líneas 25-27) tiene
  **exactamente dos entradas**: `png` y `dds`.
- El sistema mapea **un hash → un archivo**. No existe el concepto de
  "segunda textura asociada al mismo hash".

**No es un problema de calidad de DeepBump ni de ninguna herramienta: no hay
dónde enchufar el resultado.** Tampoco existe fork, build ni addon de PCSX2
con soporte PBR (buscado explícitamente).

**Veredicto: no generar normal maps.** Las razones, en orden de dureza:

1. PCSX2 no tiene dónde recibirlos `[confirmado en código]`.
2. La única vía que llega al render es **hornear el relieve en el diffuse**, y
   BLACK es el peor caso posible: es un shooter de **iluminación dinámica**
   (fogonazos, destrucción, linternas). Un relieve horneado tiene una sola
   dirección de luz congelada, y cuando la luz del motor viene de otro lado
   el sombreado falso apunta al revés — peor que la textura plana.
3. La entrada es mala: moda 128×128, 100 % paletizada.
4. Escala: 5213 assets, para un mejor caso que la literatura llama "sutil".

**Lo barato que SÍ vale probar, en este orden** — y encaja con que el GS está
al 95 % con la GPU ociosa al 20-25 %, o sea que un shader de post-proceso sale
casi gratis (a diferencia del Neural Rendering, que costó −12,5 %):

1. **Shader de bumpmapping de guest(r)** (2019, GPL v2) `[probable]`: genera
   relieve en tiempo real **desde el color buffer**, sin necesitar normal map.
   Es un `.fx`: se instala y se ve en cinco minutos. Si no se ve nada, se
   cierra la pregunta 1 para siempre.
   https://reshade.me/forum/shader-presentation/5605-2d-scaler-and-bumpmapping-shader-for-reshade
2. **MXAO / qUINT** https://github.com/martymcmodding/qUINT — deriva normales
   del **depth buffer**, así que da oclusión **entre objetos**, nunca relieve
   por téxel. Y va a pelear con el upscaling (ver abajo).
3. **Nunca**: generar 5213 normal maps.

**Sobre el depth buffer de PCSX2** `[confirmado]`: la guía vigente
(https://readshade.github.io/ReadShade/software/emulators/pcsx2.html) pide
**Direct3D 11**, aspect ratio "Fit to Window" y **resolución interna Native** —
lo último **choca de frente** con `upscale_multiplier = 3`. Y **la guía que
sale primero en las búsquedas está obsoleta**: el hilo "[Release] Pcsx2 with
depth buffer access" es de 2017 y exige OpenGL vía GSdx, el sistema de plugins
que PCSX2 eliminó antes de la 2.0. **No aplica a 2.8.0, ignorarlo.**

### 2. HAY CINCO PACKS MÁS DE BLACK, Y DOS SON DE HACE DIEZ DÍAS

Son **seis en total** contando el nuestro. El juego está mucho más trabajado
de lo que el proyecto asumía.

| pack | fecha | tamaño | notas |
|---|---|---|---|
| **el nuestro** | 2022 | 312,9 MB | `[probable]` es `Black (USA) [SLUS-21376] HD Remaster.rar` del mirror de archive.org |
| **Huekage** | **2026-08-25** | **774 MB** | `[confirmado]` declara **2781 texturas, upscale 4x**. Cubre USA **y** PAL |
| **HD Reimagined** | **2026-08-29** | **2,19 GB** | `[confirmado]` ~7x el nuestro. No declara conteo ni upscaler |
| **Bl4ckH4nd** | n/d | 854 MB | `[confirmado]` paywall de Patreon, **pero hay mirror libre** |
| **CCKrizalid** | n/d | n/d | `[confirmado]` requiere cuenta de Mega |
| **Johnazeitona** | 2023-02-12 | n/d | `[confirmado]` en portugués. Recomienda **"midmapping: off"** — coincide con lo que medimos en §7.7 |

Enlaces: Huekage
https://gbatemp.net/threads/ps2-hd-textures-pack-black-slus-21376-usa-sles-53886-pal.683983/ ·
HD Reimagined https://www.moddb.com/addons/black-hd-reimagined-texture-pack
(MD5 `f7384ede03583784f68de43da83742c5`, licencia propietaria) ·
Bl4ckH4nd mirror https://1024terabox.com/s/19iSDx1EWmQ4dPlKiF21Tlg

**Dos cosas de los comentarios de HD Reimagined, útiles directo** `[confirmado]`:
- Un usuario reporta **líneas blancas alrededor de los objetos con upscaling
  interno a 6x, que desaparecen bajando a 4x**. Es un artefacto de seam. Si se
  prueba ese pack, arrancar en 4x.
- El autor confirma que **el preset de ReShade es opcional y separable** del
  pack de texturas. Se pueden tomar sólo las texturas y dejar el pipeline
  RenoDX/LumeniteFX intacto.

### 3. LOS PACKS SON FUSIONABLES, Y ESO ES LO MÁS RENTABLE QUE HAY

`[confirmado]` en `GSTextureReplacements.cpp`:

- El nombre de archivo es `[TEX0Hash]-[CLUTHash]-[bits].ext` y el hash sale
  del **contenido de la textura del juego, no del pack**. Por eso **los
  nombres son directamente comparables entre packs distintos del mismo juego**.
- El escaneo usa `FILESYSTEM_FIND_RECURSIVE` (línea 416): **un pack ajeno
  metido en una subcarpeta de `replacements/` se levanta igual**. No hace
  falta aplanar nada.
- **Cuidado con los duplicados:** en colisión de hash el código usa
  `emplace` (línea 432), que **no pisa**: gana el primero que devuelva el
  enumerador del filesystem, **en silencio y sin log**. Cuál gana es
  indefinido. Los duplicados se resuelven a mano **antes**, no conviviendo.

**Lo accionable:** bajar los packs, listar sus nombres y calcular la
**diferencia de conjuntos** contra los 8225 instalados. Eso contesta **medido,
no estimado**, si alguno cubre parte del 29 % faltante — y **sin correr el
juego**. Es una operación de minutos sobre nombres de archivo.

**Nadie documentó este flujo** (todas las guías asumen empezar de cero); se
derivó del código fuente.

---

## LO QUE REENCUADRA EL 70,9 % DE COBERTURA

`[confirmado]`, blog oficial de PCSX2 2.0
(https://pcsx2.net/blog/2024/pcsx2-2-release/), citando textual:

> *"there are some textures which will **not** be replaceable, as they generate
> new hashes every time they are loaded. This cannot be worked around, this
> cannot be fixed, this is the PS2 GS working as intended."*

**El techo real no es 100 %.** Una fracción del 29 % es inalcanzable por
construcción. Se detecta porque el dump genera nombres nuevos para lo que
visualmente es la misma textura.

Y una segunda consecuencia, incómoda y **directamente relacionada con la fase
V4**: el mismo blog avisa que **los hashes pueden cambiar entre versiones de
PCSX2** a medida que la emulación se vuelve más precisa. `[hipótesis]` parte
del 29 % podría ser **deriva de hash**, no ausencia original — comprobable
dumpeando hoy y comparando contra los nombres del pack.

`[confirmado]` BLACK **no** figura en la lista "Unsupported" del índice de la
comunidad: el juego es empaquetable, no hay impedimento a nivel título.

### El bug de mipmaps tiene issue abierto — y confirma la fase V4 desde afuera

`[confirmado]` https://github.com/PCSX2/pcsx2/issues/11600 —
*"[BUG]: Texture replacement feature is not loading mip maps"*, abierto el
**2024-07-20**, **sigue abierto**, sin PR ni asignado. Falla **igual con PNG +
mips externos que con DDS + mips internos**.

Es evidencia externa e independiente de lo que §7.7 midió por efecto, y
explica que Johnazeitona recomiende mipmapping en off desde 2023.

> **Ojo con la atribución.** El issue dice que los mips no se cargan. Lo que
> esta sesión midió es más específico: **con el puente de hash puesto, los
> mips SÍ se cargan y se usan** (0 → 10.929 píxeles de nivel 1). O sea que al
> menos en este caso la causa era el **hash**, no el loader. Puede ser el
> mismo bug visto desde otro lado, o dos cosas distintas. No darlo por
> equivalente sin medirlo.

---

## CÓMO AMPLIAR EL PACK (el flujo concreto)

`[confirmado]` https://sites.google.com/view/pcsx2-hd-textures-project/tutorial

El estándar de facto en 2025-2026 **no es Real-ESRGAN**: es **4xHDCube4**
corrido en **ChaiNNer**, con blend de dos modelos.

- Texturas de alto detalle: `0 % 4xHDCube4.pth / 100 % 4xHDCube4Plus-B.pth`
- Texturas suaves o 2D: `30-70`, o más peso del Model A
- Salida: **DDS BC7 (Linear)**, compresión Best Quality
- HUD en **DDS-RGBA sin comprimir**; arte de galería en PNG por espacio
- **`4xHDCube3` es gratuito pero NO upscalea el canal alfa** — limitación
  seria en un juego con humo, fuego y partículas como BLACK
- Heurística de calidad de dump: los nombres con **2-3 guiones son buenos**;
  los de **un solo guión son dumps malos** y hay que investigarlos y borrarlos

Esto es materialmente más nuevo que el pipeline que produjo nuestro pack de
2022 (upscale 4,0x uniforme sin excepciones, típico de ESRGAN batch de la época).

### Herramientas de la comunidad que aplican directo a este proyecto

`[confirmado]`, de la hoja `Tools` del índice maestro:

| herramienta | para qué sirve acá | autor |
|---|---|---|
| **Texture Cleaner** | borra duplicados y dumps malos — **aplicable a nuestras 3012 variantes de CLUT** | TEODOR_MAX |
| **Alpha & RGBA Adjuster** | pasa el alfa del original a la textura nueva — tapa el agujero de 4xHDCube3 | JosephsDeadish |
| **Seamless Upscale Workflow for chaiNNer** | corrige seams en batch — **candidato para las líneas blancas de HD Reimagined** | Reverie |
| **Dumps Organizer** | organiza los dumps PNG de PCSX2 | TexMaster |
| **Texture Alpha Scaler** | escala transparencia a alfa 255 | TEODOR_MAX |
| **DDS Converter** | conversión batch a DDS | u7angel |

Casi todas en *Texture Nexus v1.0.0*:
https://gbatemp.net/threads/texture-nexus-v1-0-0-release.668694/

### Dónde vive todo esto

- **Índice maestro** (SadOrigami), la fuente autoritativa — 1432 packs, **907
  de PS2**, 460 mirrors libres, más hojas de Tools, ReShade Presets,
  Unsupported y Blacklist. Se baja como `.xlsx` con `.../export?format=xlsx`:
  https://docs.google.com/spreadsheets/d/1sif8FeRGJRbytK8wFRXgF6Hke9V6GUFs/edit
- Hub, **con dumps completos y savefiles ya hechos por juego** (evita tener
  que jugar el título entero para dumpear):
  https://gbatemp.net/threads/pcsx2-hd-texture-packs-save-files-resources-hub.643280/
- Discord de la comunidad: https://discord.com/invite/68gz2BAsfz
- Mirror masivo (211,7 GB, 150 packs): https://archive.org/details/cover_20231010

---

## NEGATIVOS MEDIDOS — no volver a buscarlos

1. **Ningún pack de BLACK reporta cobertura.** Ninguno de los seis. El
   `STATUS: Complete` del índice es **declaración del autor, no medición**.
   **Nuestro 70,9 % es, hasta donde llegó la búsqueda, el único dato de
   cobertura real que existe para este juego.**
2. **Ningún autor declara qué upscaler usó.** Ninguno de los seis. El índice
   los clasifica genéricamente como "AI Upscale".
3. **No hay conteo público** de texturas para HD Reimagined, Bl4ckH4nd ni
   CCKrizalid. Sólo tamaños. El único conteo declarado es el de Huekage: 2781.
4. **No existe fork, build ni addon de PCSX2 con soporte de normal maps/PBR.**
   Queda **un solo hilo sin verificar** en todo el informe: "SSAO and
   raytracing support in PCSX2" en forums.pcsx2.net, ilegible porque
   Cloudflare bloquea ese dominio por fetch **y** por navegador. Por fecha y
   contexto pertenece a la era GSdx/2017.
5. **No existe el Discord "Enhance Everything!"** que el proyecto listaba. El
   activo de esta escena es el del archivo de SadOrigami (arriba).
6. **No hay ninguna evaluación publicada de DeepBump sobre texturas de
   ~128×128.** Sólo un paper de SBGames 2022 (https://arxiv.org/abs/2212.09692)
   que evalúa **otro** modelo (Hudon et al., ECCV 2018) y le encuentra *"blurry
   and imprecise edges"* y *"exaggerated smoothing"* por estar entrenado en
   alta resolución. Extenderlo a DeepBump es `[hipótesis]`, aunque el
   mecanismo de falla es el mismo (DeepBump se entrenó sobre escaneos PBR
   reales). El paper cierra pidiendo, como trabajo futuro, entrenar un modelo
   sobre pixel art: reconoce que el modelo adecuado no existe.
7. **Poly Haven no genera normal maps** — es biblioteca de assets CC0. Pista
   muerta.
8. **No hay guía publicada de "ampliar un pack existente"** (dumpear sólo lo
   faltante y fusionar). Todas asumen empezar de cero. El flujo de fusión de
   arriba se derivó del código fuente.

**Nota de método:** GBAtemp, ModDB y forums.pcsx2.net devuelven 403 a fetch
directo. Los dos primeros se leen con el navegador; forums.pcsx2.net bloquea
también por ahí.
