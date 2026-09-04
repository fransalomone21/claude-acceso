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

## BLACK HD Reimagined (2026-08-29)

`hd-reimagined-2026-08-29.rar`, **2.350.452.820 bytes** esperados
(MD5 publicado: `f7384ede03583784f68de43da83742c5`). Licencia **propietaria**.

*(Medición pendiente: ver el estado en `sesiones/HANDOFF.md` §10. Si este
archivo no tiene la tabla de abajo completa, la comparación no llegó a
correrse y hay que correr `comparar_packs.py` contra su carpeta extraída.)*

Dos cosas ya sabidas de los comentarios de su página, que conviene tener a mano
antes de probarlo:

- Un usuario reporta **líneas blancas alrededor de los objetos con upscaling
  interno a 6x, que desaparecen bajando a 4x**. Arrancar en 4x.
- El autor confirma que **su preset de ReShade es opcional y separable** del
  pack de texturas: se pueden tomar sólo las texturas y dejar el pipeline
  RenoDX/LumeniteFX intacto.

---

## Los otros tres packs, sin bajar

`Bl4ckH4nd` (854 MB, paywall de Patreon **con mirror libre**), `CCKrizalid`
(requiere cuenta de Mega) y `Johnazeitona` (2023, acortador con ads). Ninguno
declara cobertura ni upscaler. Enlaces en
`remake-texturas-ia-2026-09-04.md`.
