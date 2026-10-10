# Predicciones de (125) — la pieza 2d (J2 con su soporte de modelo), en vivo

Escritas **antes** de la corrida, el 2026-10-09, en frio, con el diseno de `docs/16` seccion (125) y el codigo de
`herramientas/coop_soporte2.py` (regla 12 de `coop_diseno.py` en verde). Se agregan resultados al lado; ninguna fila
se reescribe.

**Banco:** `herramientas/soporte2_banco.py` (City Streets por el selector; precondicion de `arma_pieza_banco.py`, solo
J2: junta la SPAS y queda con dos armas, J con la pistola).

```
python herramientas/soporte2_banco.py control    # instalar --sin-soporte2: la linea de base (F7)
python herramientas/soporte2_banco.py pieza      # instalar --con-soporte2: dos cargas
```

**El mecanismo que se pone a prueba** (`probable` en frio): con la pieza, el cambio de arma de J2
(`FUN_0013C868(J2, i)`) escribe **su** soporte y **sus** buffers, asi que la mitad de J sigue dibujando la pistola
de J con sus registros. Sin la pieza, F7 como en (124).

## R — en RAM (el seam; lo lee `soporte2_banco.veredicto()`)

| # | Prediccion | Resultado |
|---|---|---|
| R0 | control, `base` y `j2_cambio`: J y J2 comparten soporte y buffers (`0x00597810`, `0x006EC700`, `0x006EC780`), y el cambio de J2 cambia el modelo del soporte de J (la pistola `0x01AE7E00` → la SPAS `0x01A33100`, los de (124)) | **(126) CUMPLIDA**: comparten los tres en base/cambio/vuelta; el modelo de J pasa `0x01AE7E00` → `0x01A33100` → vuelve (`banco-soporte2-control-20261009-214309.json`; cambio en 3 pulsaciones; cuadros de J2 1040 → 1336 → 1465, vivo) |
| R1 | pieza, `base`, carga 1 y carga 2: `J2+0x328` = `0x0046FFC0`, `+0x354` = `0x0046FD00`, `+0x358` = `0x0046FD80`, los accesorios 5-7 de J2 = `0x00470000/20/40` con duenio J2; los de J donde estaban (soporte `0x00597810`, buffers `0x006EC7x0`, accesorios con duenio J) | **(126) CUMPLIDA, carga 1 y 2**: exactamente esos valores (duenio de los accesorios de J2 = `0x0046CDF0`, J2; los de J `0x006ED6F0/710/730` con duenio `0x005A8AB0`, J) (`banco-soporte2-pieza-20261009-214843.json`) |
| R2 | pieza, `j2_cambio`: el modelo del soporte de **J2** pasa a la SPAS y el de **J** **no cambia** (sigue la pistola); `j2_vuelve`: el de J2 vuelve a la pistola | **(126) CUMPLIDA, carga 1 y 2**: carga 1 J2 `0x01AE7E00` → `0x01A33100` → `0x01AE7E00`, J fijo en `0x01AE7E00`; carga 2 (el nivel aloja los modelos en otro lado) J2 `0x01A35E00` → `0x01AE5100` → `0x01A35E00`, J fijo en `0x01A35E00`. Cambio en 1 y 2 pulsaciones (carga 1), 2 y 1 (carga 2) |
| R3 | pieza, en todos los pasos: lo que hay en cada buffer (los primeros `*(mod+0x3C)` / `*(mod+0x44)` B) es igual a los registros del modelo de **su** soporte | **(126) MAL ESCRITA, corregida antes de correr la pieza:** en el control (sin el mod de por medio) el buffer de `+0x354` difiere de su modelo en 10 de 14 palabras en todos los pasos, en J y en J2, estable en el tiempo: el dibujo lo reescribe en cada pasada (`FUN_00136BD0` → `FUN_001AF738` con un puntero adentro de cada registro de 0x1C). De la copia sobreviven las dos primeras palabras de cada registro; `+0x358` queda exacto. R3 se lee con `copia_ok` (eso); medido: positivo verde en J y J2, negativo (los buffers contra la SPAS) rojo en los dos buffers |
| R4 | pieza: el contador de cuadros de J2 sube entre todos los pasos de las dos cargas (sin ROJO_MUERTO), y la carga 2 no cuelga | **(126) CUMPLIDA**: carga 1 784 → 912 → 1123, carga 2 1994 → 2205 → 2333; R3 (`copia_ok`) verde en los 12 estados (J y J2, base y cambio, dos cargas). Pnach con la pieza: 1106 palabras |

## I — en pantalla (el discriminador: las mitades `-izq` / `-der` de cada foto)

| # | Prediccion | Resultado |
|---|---|---|
| I0 | control, `j2_cambio`: F7 — la mitad de J dibuja la SPAS torcida con el bloque de basura, la de J2 la SPAS bien | **(126) CUMPLIDA**: `base.png` las dos con la pistola; `j2-cambio.png` la mitad de J (HUD 015\030, su pistola) dibuja la SPAS torcida con el bloque de basura abajo, la de J2 (006\000) la SPAS bien (`volcados/arma/pieza-soporte2-control-carga1-20261009-214238/`) |
| I1 | pieza, `base`: las dos mitades dibujan la pistola, bien formada (la pieza no rompe el arranque) | **(126) CUMPLIDA** (`pieza-soporte2-pieza-carga1-20261009-214721/base.png`) |
| I2 | pieza, `j2_cambio`: la mitad de **J** dibuja **su pistola** bien formada; la de **J2**, **la SPAS** bien formada | **(126) CUMPLIDA**: J (015\030) su pistola, J2 (006\000) la SPAS, sin bloque de basura (`.../j2-cambio.png`). **F7 arreglado** |
| I3 | pieza, `j2_vuelve`: las dos mitades, la pistola | **(126) CUMPLIDA** |
| I4 | pieza, carga 2: I1–I3 otra vez | **(126) CUMPLIDA** (`pieza-soporte2-pieza-carga2-20261009-214823/`) |

**H-acc (sin prediccion firme, `hipotesis`):** con la pistola el accesorio 5 de J2 lleva un agregado enganchado a la
ranura compartida, no a R3; si en la mitad de J2 aparece un fragmento fuera de lugar, es eso (`docs/16` (125)) y no
refuta la pieza.
**(126):** no se vio ningun fragmento en las 6 fotos de la pieza. En RAM, H-acc esta: con la SPAS los enganches de
los accesorios de J2 pasan a `0x013094D0/570/610` (los huesos de la ranura compartida 1), los de J quedan en
`0x01304150/1F0/290` (ranura 0). Mientras J y J2 tengan indices distintos no se pisan; el caso que lo mostraria
(los dos con el mismo indice y armas distintas) este banco no lo construye. Sigue `hipotesis`, sin sintoma.

**Refuta:** si con la pieza la mitad de J sigue dibujando la SPAS en `j2_cambio`, el arma se dibuja tambien desde otro
lado (empezar por `clon_comparte.py`: `+0x294`, `+0x35C`). Si la mitad de J2 queda con las manos vacias o con basura,
SOP2 o los buffers de J2 estan mal (mirar R1 y R3). Si R1 no se cumple, la llamada no corrio (mirar el envoltorio
instalado: 111 palabras). Si el contador de J2 se clava, la pieza cuelga el armado y nada de lo demas mide.
