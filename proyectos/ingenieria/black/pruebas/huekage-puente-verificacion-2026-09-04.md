# Verificación visual — Huekage + puente instalados — 2026-09-04

Cierra la acción pendiente de §7.7 de `docs/09-remaster-visual.md`: instalar
Huekage + el puente de hash y verificar por efecto. Predicción escrita antes
de correr en `prediccion-puente-huekage-2026-09-04.md`.

## 1. Instalación

```
replacements/ (activo) <- packs-descargados/huekage/SLUS-21376/replacements (2781 .dds)
replacements-2022-con-puente/  <- el pack anterior, preservado (no se borró)
```

`puente_hash_mipmap.py dumps-mipmapON-2026-09-04 replacements puente-huekage-2026-09-04 --aplicar`:

```
pack Huekage  : 2779 archivos indexados, 2197 claves (cluthash, tex0bits)
dumps (escena): 38
emparejadas   : 18   (nuestro pack de 2022 había emparejado 35 de 38)
ambiguas      : 1
sin par       : 18
sin parsear   : 1  (r640x448, render target, no es textura de pack)
```

**Huekage empareja menos que el pack propio con el mismo puente** (18 contra
35 de 38): tiene 2197 claves únicas contra las 5213 assets del nuestro, así
que hay menos variantes de CLUT para emparejar por
`(CLUTHash, TEX0 bits enmascarado)`. Las 18 copias se sumaron a `replacements/`
(2781 + 18 = 2799 archivos).

## 2. Confirmado por efecto: las 18 emparejadas dejan de faltar

Con `hw_mipmap = true` y `DumpReplaceableTextures = true`, corrida de ~80s en
el savestate 03: **80 archivos volcados**. Los **18 archivos que el puente
resolvió NO aparecen entre los 80** (intersección = 0) — el puente funciona
para esos.

Los otros 62 no son comparables contra la baseline de 38: dejar correr la
escena 80s (combate y humo activos, ver captura abajo) expone más hashes
distintos que una captura corta, el mismo efecto ya documentado para la
diferencia 38 vs 82 entre escena corta y escena completa. **No se reporta
"80 vs 3" como regresión**: son dos mediciones con duración distinta, y
compararlas así repetiría el error ya corregido en §7.7 (70,9% vs 92,7%,
mismo error de denominador).

Volcado preservado en
`Documents\PCSX2\textures\SLUS-21376\dumps-huekage-conpuente-80s-2026-09-04\`.

## 3. A/B/C pareado (control obligatorio), dos rondas

Capturas en `Documents\PCSX2\textures\SLUS-21376\evidencia-huekage-mipmap-2026-09-04\`.
Escena con combate y humo activos en las dos rondas (confirmado por captura:
disparos, chispas, polvo en movimiento) — el mismo confusor ya documentado.

**Ronda 1** (A=on, B=off, C=on/control):

| región | A (on) | B (off) | C (control) |
|---|---:|---:|---:|
| barrera (el síntoma) | 65.1 | 49.3 (−24%) | 73.1 (+12%) |
| auto derecho | 344.7 | 468.9 (+36%) | 480.6 (+39%) |
| **auto izquierdo** | 559.5 | 566.7 (**+1%**) | 567.4 (**+1%**) |
| caja izquierda | 140.2 | 137.8 (−2%) | 153.4 (+9%) |
| **pared derecha** | 26.0 | 28.0 (+7%) | 25.7 (**−1%**) |
| poste derecho | 120.2 | 107.9 (−10%) | 130.1 (+8%) |

**Ronda 2** (A=on, B=off, C=on/control):

| región | A (on) | B (off) | C (control) |
|---|---:|---:|---:|
| barrera (el síntoma) | 491.2 | 111.6 (−77%) | 63.8 (−87%) |
| auto derecho | 575.9 | 482.8 (−16%) | 468.0 (−19%) |
| **auto izquierdo** | 580.1 | 567.8 (**−2%**) | 562.5 (**−3%**) |
| caja izquierda | 297.1 | 164.4 (−45%) | 140.0 (−53%) |
| pared derecha | 44.7 | 38.4 (−14%) | 26.3 (−41%) |
| poste derecho | 132.6 | 133.0 (+0%) | 121.3 (−8%) |

**Control positivo (C ≈ A):** sólo **"auto izquierdo" cierra en las dos
rondas** (+1%/+1% y −2%/−3%). El resto se descarta por control fallido — el
humo y el combate dominan la métrica, igual que en las dos tandas de §7.7.
La región **"barrera" (el síntoma original) no pudo medirse en ninguna de las
dos rondas**: sigue exactamente donde §7.7 la dejó, no es un dato nuevo.

**Donde el control cierra, la conclusión es la misma que con el pack
propio:** en "auto izquierdo", ON vs OFF da +1% y −2% — dentro del ruido, sin
costo de nitidez. Es la **tercera** medición independiente (dos de esta
sesión + la de §7.7 en "pared fondo derecha", −1%) que apunta en la misma
dirección: con el puente puesto, activar el mipmapping no cuesta nitidez
donde se puede medir. Sigue siendo evidencia **parcial** — ninguna medición
de esta línea logró aislar la región del síntoma de la interferencia del
humo.

## 4. Conclusión operativa

- Huekage + puente queda **instalado y activo** (`replacements/` = 2781 +
  18 = 2799 archivos), con el pack anterior preservado en
  `replacements-2022-con-puente/`.
- `hw_mipmap` vuelve a `false` **al cerrar la sesión**, mismo criterio que
  §7.7: el puente sólo cubre 18-21 de las texturas con lod de ESTA escena, no
  el juego. Activar `hw_mipmap = true` de forma persistente perdería
  reemplazo en el resto del juego, igual que con el pack propio.
- **Aun así, Huekage mejora el estado seguro** (`hw_mipmap = false`): ahí no
  hay problema de hash y Huekage cubre 82/82 contra 76/82 del pack de 2022
  (`comparacion-packs-2026-09-04.md`). Dejar Huekage activo es una mejora
  neta sobre el estado anterior, sin depender de resolver el mipmap.

## Lo que queda abierto

- Repetir el A/B/C en una escena **sin combate activo**, para poder medir
  la región "barrera" misma en vez de una región vecina. Ninguna sesión
  hasta ahora logró esto en el savestate 03.
- El puente sobre Huekage cubre bastante menos que sobre el pack propio
  (18/38 contra 35/38): si se decide extender el puente a todo el juego
  (NEXT ACTION #2 de `HANDOFF.md` §9), conviene evaluar si conviene ampliar
  el radio de búsqueda del puente para Huekage o simplemente aceptar la
  cobertura menor en las texturas con lod.
