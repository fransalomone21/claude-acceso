# Comparación medida de los packs de texturas de BLACK — 2026-09-04

Los packs se bajaron con autorización de Fran y viven **fuera del repo**, en
`Documents\PCSX2\textures\SLUS-21376\packs-descargados\`. Acá va sólo la
**medición**, que es lo que el proyecto necesita recordar.

Método: `herramientas/comparar_packs.py`, que cruza por nombre de archivo. El
nombre de un reemplazo es `[TEX0Hash]-[CLUTHash]-[bits]` y **el hash sale del
contenido de la textura del juego, no del pack**, así que los nombres son
directamente comparables entre packs. El bit 14 (`0x4000`) se enmascara
siempre — sin eso el cruce da 0 % aunque todo coincida.

> La herramienta se validó antes de usarla, contra **dos respuestas conocidas**:
> nuestro pack con puente contra el mismo sin puente da exactamente **35**
> nuevas, y una carpeta contra sí misma da **0**.

---

## Huekage (2026-08-25) — bajado y medido

`huekage-2026-08-25.zip`, **811.720.483 bytes**, ZIP válido. Contiene
**2781 `.dds`** en `SLUS-21376/replacements/` — coincide **exacto** con las
2781 texturas que el autor declara en su hilo. Cubre USA y PAL.

### Qué suma sobre nuestro pack

| medida | valor |
|---|---:|
| claves de Huekage | 2781 |
| **ya las teníamos** | 2044 |
| **NUEVAS — lo que suma** | **737** |
| que el nuestro tiene y él no | 6181 |
| solapamiento | 73,5 % de sus claves ya estaban |

Las 737 claves nuevas están listadas en
`packs-descargados/huekage-claves-nuevas.txt`.

### Y cubre justo lo que nos faltaba

Sobre las **82 texturas** de la escena del savestate 03 (el denominador
medido en §7.7 de `docs/09`):

| pack | cubre | cobertura |
|---|---:|---:|
| el nuestro (2022) | 76 | 92,7 % |
| **Huekage** | **82** | **100 %** |
| la unión | 82 | 100 % |

**Las 6 texturas que a nuestro pack le faltaban, Huekage las tiene: 6 de 6.**

### Ya trae mip chain

Muestra de 400 archivos: **400/400 con el flag `DDSD_MIPMAPCOUNT`**. O sea que
sobre Huekage **no hace falta correr `regenerar_mipmaps.py`**.

### PERO tiene el mismo problema de hash que el nuestro

Éste es el punto que sólo se puede ver después de la fase V4, y es el que
decide cómo usarlo:

| | hashes que PCSX2 pide con **mipmap ON** (38) | hashes con **mipmap OFF** (6) |
|---|---:|---:|
| el nuestro | **0 de 38** | 0 de 6 |
| Huekage | **3 de 38** | **6 de 6** |

**Huekage también fue volcado sin mipmapping.** Los 3 de 38 son texturas que el
juego no mipmapea, no una excepción del pack. **Con `hw_mipmap = true` sigue
haciendo falta el puente de `puente_hash_mipmap.py`**, igual que con el nuestro.

### Conclusión operativa

**La mejor combinación medida es Huekage + puente**, no el pack de 2022:
cubre más (100 % contra 92,7 % en esa escena), trae mips propios, y necesita
exactamente el mismo trabajo de puente. Antes de fusionarlo con el nuestro hay
que resolver las **2044 colisiones**: PCSX2 usa `emplace`, que **no pisa**, así
que en un empate gana el primero que devuelva el enumerador del filesystem, en
silencio y sin log. Cuál gana es indefinido si conviven.

---

## BLACK HD Reimagined (2026-08-29) — bajado y medido

`hd-reimagined-2026-08-29.rar`, **2.350.452.820 bytes**. **MD5 verificado
idéntico al publicado**: `f7384ede03583784f68de43da83742c5`. Licencia
propietaria. Trae **1211 `.dds` + 113 `.png`**, más un `.ini` de ReShade y dos
PDF de instalación (inglés y portugués).

**Pesa 3x más que Huekage y suma 7x menos:**

| medida | valor |
|---|---:|
| claves | 1302 |
| ya las teníamos | 1192 |
| **NUEVAS** | **110** |
| solapamiento | **91,6 %** |

**Su valor no está en la cobertura sino en la resolución por textura**
(~1,8 MB por archivo). Es un pack **selectivo de alta resolución**, no de
cobertura.

De los comentarios de su página, útiles antes de probarlo: un usuario reporta
**líneas blancas alrededor de los objetos con upscaling interno a 6x, que
desaparecen bajando a 4x**; y el autor confirma que **su preset de ReShade es
opcional y separable**, así que se pueden tomar sólo las texturas y dejar el
pipeline RenoDX/LumeniteFX intacto.

---

## EL CUADRO COMPLETO, medido

### Cobertura sobre las 82 texturas de la escena del savestate 03

| pack | cubre | cobertura | las 6 que nos faltaban |
|---|---:|---:|---:|
| el nuestro (2022) | 76 | 92,7 % | 0 de 6 |
| **Huekage** | **82** | **100 %** | **6 de 6** |
| HD Reimagined | 23 | **28,0 %** | 0 de 6 |
| nuestro + Huekage | 82 | 100 % | — |
| los tres juntos | 82 | 100 % | — |

**Huekage solo ya llega al 100 %**: no necesita al nuestro para esta escena.
HD Reimagined cubre apenas el 28 % y **no aporta ninguna** de las que nos
faltaban.

### Resolución y mip chain (muestra de 600 archivos por pack)

| pack | lado mayor más frecuente | mip chain |
|---|---|---|
| nuestro 2022 | 256, 512, algo de 1024 | **SIN mips** (600/600) |
| Huekage | **1024**, con 2048/2560/4096 | **con mips** (600/600) |
| HD Reimagined | **2560, 2752, 3072, 4096** | **con mips** (600/600) |

Los dos packs nuevos **ya traen mip chain**: sobre ellos **no hace falta
correr `regenerar_mipmaps.py`**. Y los dos son de resolución claramente mayor
que el nuestro de 2022.

### Y los tres tienen el mismo problema de hash

| | hashes que PCSX2 pide con **mipmap ON** (38) | con **mipmap OFF** (6) |
|---|---:|---:|
| el nuestro | 0 de 38 | 0 de 6 |
| Huekage | 3 de 38 | **6 de 6** |

Los tres fueron volcados **sin mipmapping**. **El puente de
`puente_hash_mipmap.py` sigue haciendo falta con cualquiera de ellos.**

### Recomendación, con lo medido

**Huekage + puente** es la mejor combinación: cubre 100 % de la escena contra
92,7 % del nuestro, tiene las 6 que nos faltaban, trae mips propios y pesa un
tercio que HD Reimagined. HD Reimagined queda como fuente de **texturas
puntuales de altísima resolución** (2560-4096), no como pack base.

**Antes de fusionar, resolver las colisiones** (2044 con Huekage, 1192 con HD
Reimagined): PCSX2 usa `emplace`, que **no pisa**, así que en un empate gana el
primero que devuelva el enumerador del filesystem, **en silencio y sin log**.

---

## Los otros tres packs, sin bajar

`Bl4ckH4nd` (854 MB, paywall de Patreon **con mirror libre**), `CCKrizalid`
(requiere cuenta de Mega) y `Johnazeitona` (2023, acortador con ads). Ninguno
declara cobertura ni upscaler. Enlaces en
`remake-texturas-ia-2026-09-04.md`.
