# Fase B del remake — firma de bloque de malla y verificación del GtID — 2026-09-04

Cierra los dos experimentos baratos que quedaron pendientes de
`remake-geometria-2026-09-04.md`. En frío, sin abrir el emulador. ISO
original montado en `D:\` (`Mount-DiskImage`, sólo lectura — no se tocó el
archivo).

## 1. La firma de bloque de malla — CONFIRMADO por barrido masivo

Búsqueda de `00 00 00 05 03 01 00 01 00 80` en los 270 `.DB`/`.bin` del ISO
(script ad-hoc, no se guardó como herramienta — ver comando abajo).

```
archivos con al menos un hit : 233 / 270
total de apariciones         : 132.630
```

**No es ruido.** Una secuencia de 10 bytes fijos tiene probabilidad
~1/2⁸⁰ de aparecer por azar; encontrarla más de cien mil veces, y en
posiciones **espaciadas de forma periódica y variable dentro de cada
archivo** (ej. `BG1_AK1.DB`: offsets 134676, 135956, 137124, 138276 — deltas
1280, 1168, 1152 bytes, no un stride fijo) es la firma de un **formato real
con bloques de tamaño variable**, consistente con un header por malla/submalla
seguido de datos de vértice.

Contexto de un hit (`BG1_AK1.DB`, offset 134676):
```
... 00 00 00 00 00 00 00 00 | 00 00 00 05 03 01 00 01 00 80 | 30 6c cb 9d 99 bc 79 e6 65 ba 72 1c 78 bd ...
    (padding/fin de bloque anterior)   LA FIRMA (10 bytes)      datos que siguen (floats empaquetados, verosímil)
```

**Conclusión: los bloques de malla quedan localizados sin parsear nada más.**
Buscar esta firma en cualquier `.DB`/`.bin` de BLACK da directamente el
offset de cada malla. Es el punto de entrada para conectar
`fmt_Burnout3LRD.py` (que ya trae `rapi.unpackPS2VIF`) con estos archivos,
tal como proponía `remake-geometria-2026-09-04.md` punto 1.

## 2. El GtID de la cabecera del `.DB` — REFUTADO para el header completo

La hipótesis de `remake-geometria-2026-09-04.md` §3 era `[probable]`: que los
8 primeros bytes del `.DB` son `GtID(nombre_del_archivo)`, y sólo estaba
verificada para DOS invariantes parciales (byte 0 y bytes 6-7), no para el
valor completo.

**Codec verificado contra la fuente primaria** (bajado del wiki oficial,
`MediaWiki:CgsID/Compress.js`, no reimplementado de memoria) y contrastado
con el control positivo publicado: `compress("BURNOUT") = 0x5667885FFDD40000`
— exacto.

**Comparación completa, los 139 `.DB` del ISO:**

| qué se compara | resultado |
|---|---:|
| **8 bytes completos** = `compress(nombre)` empaquetado little-endian | **0 / 139** |
| byte 0 == `0x00` | 139 / 139 (invariante ya conocida, re-confirmada) |
| bytes 6-7 == `"FT"` | 139 / 139 (invariante ya conocida, re-confirmada) |
| bytes 4-7 (mitad alta) == la del `compress()` | 136 / 139 |

**El header NO es un `GtID` directo del nombre completo del archivo — la
hipótesis de §3 queda REFUTADA en su forma fuerte.** Ejemplo (`BG1_AK1.DB`):

```
archivo   : 00 14 81 9b 72 12 46 54
compress  : 00 00 c6 97 72 12 46 54
                    ^^^^^^^^^^^^^^^ coincide (mitad alta)
            ^^^^^^^ NO coincide (mitad baja)
```

La mitad alta coincidiendo en 136/139 sugiere que el prefijo del nombre
(`BG1_` + 1-2 caracteres más) SÍ participa de alguna forma en esos 4 bytes,
pero la mitad baja no es la cola del `GtID` del nombre completo — es otra
cosa (candidatos sin probar: tamaño de archivo, checksum, o un campo
data-driven que no depende del nombre). **No se investigó más profundo**:
excede el alcance de esta verificación puntual y es territorio de hipótesis
nueva, no de ejecutar un experimento ya diseñado.

## Comando usado (no se guardó como herramienta, es de un solo uso)

```python
# compress(): traducción literal de MediaWiki:CgsID/Compress.js
# (alfabeto " -/0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_", validado contra
#  compress("BURNOUT") == 0x5667885FFDD40000 antes de usarlo)
```
Script completo corrido ad-hoc, no commiteado (es de un solo uso y no deja
estado). Si se retoma la pregunta de la mitad baja del header, reescribirlo
como herramienta con autotest, no ad-hoc.
