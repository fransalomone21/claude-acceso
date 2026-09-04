# Predicción — puente de hash sobre Huekage — 2026-09-04

Escrita ANTES de arrancar PCSX2 con `hw_mipmap = true`.

## Lo medido del puente (ya corrido)

```
puente_hash_mipmap.py dumps-mipmapON-2026-09-04 -> replacements(Huekage) -> puente-huekage-2026-09-04 --aplicar

pack Huekage   : 2779 archivos indexados, 2197 claves (cluthash, tex0bits)
dumps (escena) : 38

emparejadas   : 18  (0 por desempate de imagen, 0 por candidatos identicos)
ambiguas      : 1
sin par       : 18
sin parsear   : 1  (r640x448 — render target, no es textura de pack)
```

**Esto es peor que "nuestro" pack (2022), que emparejó 35 de 38** (§7.7 de
`docs/09-remaster-visual.md`). Huekage tiene 2781 archivos / 2197 claves
contra los 5213 assets únicos del nuestro — con menos variantes de CLUT por
textura, el puente tiene menos candidatos para emparejar por
`(CLUTHash, TEX0 bits enmascarado)`.

## Predicción

Con `comparacion-packs-2026-09-04.md`: Huekage ya cubre 3 de los 38 hashes de
mipmap-ON *sin* puente (los que el juego no mipmapea). El puente de esta
corrida suma 18 más.

```
cobertura esperada  : 3 (ya presentes) + 18 (puente) = 21 de 38
sin reemplazo (dumps): 38 - 21 = 17   <- NO ~3 como con "nuestro" pack
```

Si la corrida real da un número **bastante distinto de 17** (no ~3, pero
tampoco 21+ o el total 38), la hipótesis de "menos claves = menos parejas" no
alcanza para explicarlo y hay que revisar el puente o el pareo con Huekage
específicamente.

## Qué se hace con esto

El plan original asumía que el puente de Huekage se comportaría como el del
pack propio. No fue así — medido, no hipotético. Sea cual sea el resultado
real, esto **no invalida** que Huekage cubra el 100% de la escena en
`hw_mipmap = false` (dato ya confirmado en `comparacion-packs-2026-09-04.md`);
sólo dice que el puente de mipmap-ON necesita más trabajo con este pack
específico (más candidatos, o ampliar el radio de búsqueda) antes de
declararlo "listo" para `hw_mipmap = true`.
