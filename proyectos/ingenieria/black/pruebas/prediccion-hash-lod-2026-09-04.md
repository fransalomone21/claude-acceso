# Predicción — el hash del reemplazo cambia al activar el mipmapping

Escrita **antes** de correr el experimento. 2026-09-04, ~02:0x.

## La causa raíz propuesta (leída del código fuente, falta confirmarla por efecto)

`GSTextureCache::HashCacheKey::Create` (repo oficial `PCSX2/pcsx2`, master):

```cpp
// base level is always hashed
HashTextureLevel(TEX0, TEXA, region, hash_st, s_unswizzle_buffer);

if (lod)
{
    // hash and combine full mipmaps when enabled
    const int basemip = lod->x;
    const int nmips = lod->y - lod->x + 1;
    for (int i = 1; i < nmips; i++)
    {
        const GIFRegTEX0 MIP_TEX0{g_gs_renderer->GetTex0Layer(basemip + i)};
        HashTextureLevel(MIP_TEX0, TEXA, region.AdjustForMipmap(i), hash_st, s_unswizzle_buffer);
    }
}

ret.TEX0Hash = FinishBlockHash(hash_st);
```

Y en `LookupHashCache`, ese mismo `key` es el que se le pasa a
`GSTextureReplacements::LookupReplacementTexture(key, lod != nullptr, ...)`,
que construye el **nombre de archivo** que busca en el pack.

Es decir: **para una misma textura, el hash cambia según si el juego la usa
con mipmapping o sin él.** Con mipmapping, el hash combina los bytes del
nivel base *y de todos los niveles de mip del juego*.

El pack HD es de 2022 y sus 8225 nombres traen el hash de **sólo el nivel
base**. Al poner `hw_mipmap = true`, toda textura que el juego dibuje con
mipmapping pasa a pedir un hash **que no existe en el pack** → no hay
reemplazo → se dibuja el original de PS2, de baja resolución.

Si esto es cierto, **regenerar el mip chain nunca podía funcionar**: el
archivo que se arregló no se busca nunca bajo ese estado.

## Lo que ya explica, sin ajustar nada (dato ya medido, no predicción)

| observación | encaja |
|---|---|
| blur extremo, ~30-47x de pérdida de detalle | sí: es el original de PS2, no un mip de la HD |
| CERO píxeles de color con el pack de debug instalado | sí: la textura de reemplazo ni siquiera se carga |
| el efecto depende de la superficie, no de la distancia | sí: depende de si el juego mipmapea esa textura |
| el HUD y algunas superficies cercanas quedan intactas | sí: sin mipmapping para ellas, `lod == nullptr`, hash base, reemplazo encontrado |
| `mipmap = false` lo arregla todo (fase V3, validado por Fran) | sí: vuelve a hashear sólo la base |
| el pack pasó 8225/8225 por bytes y por píxel y no cambió nada | sí: el archivo está perfecto y nunca se abre |

## El experimento

`DumpReplaceableTextures = true` con el pack **activo**. PCSX2 **no vuelca lo
que ya tiene reemplazo** (`GSTextureReplacements.cpp`, ya registrado en el
DO NOT REPEAT del HANDOFF), así que con el pack puesto la carpeta `dumps/`
es exactamente **el complemento**: lo que quedó sin reemplazar.

Dos corridas, misma escena (savestate 03), lo único que cambia es `hw_mipmap`.

## Predicción, falsable

| corrida | predicción |
|---|---|
| `hw_mipmap = true` | **muchos** dumps: las texturas mipmapeadas perdieron su reemplazo |
| `hw_mipmap = false` | **pocos** dumps: las mismas texturas encuentran su reemplazo |

**Predicción concreta:** la corrida con `hw_mipmap = true` va a volcar
**bastantes más** archivos que la de `hw_mipmap = false`, en la misma escena.
Y los nombres volcados con mipmap on **no van a existir** en el pack, aunque
esas mismas superficies se vean HD con mipmap off.

**Qué la falsaría:** que las dos corridas vuelquen la misma cantidad, o que
la de mipmap on vuelque menos. En ese caso la causa es otra y hay que volver
al código.

---

# Resultado del experimento, y predicción del ARREGLO

## Resultado: predicción CONFIRMADA

| corrida | dumps (texturas sin reemplazo) |
|---|---:|
| `hw_mipmap = true` | **37** |
| `hw_mipmap = false` | **5** |

Misma escena (savestate 03), mismo pack, lo único que cambió fue `hw_mipmap`.
**32 texturas pierden su reemplazo al activar el mipmapping.** Ninguna de las
volcadas existe en el pack, como corresponde: sus hashes son nuevos.

## El remate: son la misma textura con dos nombres

`emparejar_dump_pack.py` cruzó las 38 volcadas contra el pack **por imagen** y
encontró par para 37. Pero lo más limpio no fue la imagen: en los pares, el
**CLUTHash coincide exacto** y sólo cambia el TEX0Hash.

```
12b94fd2d758273b-3f05a08934941622-00001dd4.png   (lo que PCSX2 pide con mipmap)
678a1512bdcbdb48-3f05a08934941622-00005dd4.dds   (lo que el pack tiene)
                 ^^^^^^^^^^^^^^^^ idéntico
```

Es exactamente lo que dice el código: `CLUTHash` no depende de `lod`,
`TEX0Hash` sí. Eso hace el mapeo **determinista**, sin comparar imágenes.

## El arreglo, y su predicción

`puente_hash_mipmap.py` emparejó por `(CLUTHash, TEX0 bits enmascarado)` y
escribió **35 copias** del pack con el nombre que PCSX2 pide con mipmapping
activado. De las 38: 35 emparejadas (18 de ellas eran candidatos con bytes
idénticos — variantes de CLUT, da igual cuál), 1 ambigua real, 1 sin par, y 1
que no es textura de pack (`r640x448`, un render target).

**Predicción, falsable:** con esas 35 copias instaladas y `hw_mipmap = true`:

1. los dumps de la misma escena bajan de **37 a ~3** (las no emparejadas);
2. la escena se ve **nítida**, con la nitidez de la corrida de mipmap off;
3. y esta vez el mip chain construido el 2026-09-04 **sí se usa**, porque
   recién ahora el archivo se encuentra.

**Qué la falsaría:** que los dumps sigan en ~37 (el emparejamiento está mal, o
el nombre no es lo único que faltaba), o que la escena siga borrosa aunque los
dumps bajen (entonces el reemplazo se encuentra pero se dibuja otra cosa).
