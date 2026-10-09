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
| R0 | control, `base` y `j2_cambio`: J y J2 comparten soporte y buffers (`0x00597810`, `0x006EC700`, `0x006EC780`), y el cambio de J2 cambia el modelo del soporte de J (la pistola `0x01AE7E00` → la SPAS `0x01A33100`, los de (124)) | |
| R1 | pieza, `base`, carga 1 y carga 2: `J2+0x328` = `0x0046FFC0`, `+0x354` = `0x0046FD00`, `+0x358` = `0x0046FD80`, los accesorios 5-7 de J2 = `0x00470000/20/40` con duenio J2; los de J donde estaban (soporte `0x00597810`, buffers `0x006EC7x0`, accesorios con duenio J) | |
| R2 | pieza, `j2_cambio`: el modelo del soporte de **J2** pasa a la SPAS y el de **J** **no cambia** (sigue la pistola); `j2_vuelve`: el de J2 vuelve a la pistola | |
| R3 | pieza, en todos los pasos: lo que hay en cada buffer (los primeros `*(mod+0x3C)` / `*(mod+0x44)` B) es igual a los registros del modelo de **su** soporte | |
| R4 | pieza: el contador de cuadros de J2 sube entre todos los pasos de las dos cargas (sin ROJO_MUERTO), y la carga 2 no cuelga | |

## I — en pantalla (el discriminador: las mitades `-izq` / `-der` de cada foto)

| # | Prediccion | Resultado |
|---|---|---|
| I0 | control, `j2_cambio`: F7 — la mitad de J dibuja la SPAS torcida con el bloque de basura, la de J2 la SPAS bien | |
| I1 | pieza, `base`: las dos mitades dibujan la pistola, bien formada (la pieza no rompe el arranque) | |
| I2 | pieza, `j2_cambio`: la mitad de **J** dibuja **su pistola** bien formada; la de **J2**, **la SPAS** bien formada | |
| I3 | pieza, `j2_vuelve`: las dos mitades, la pistola | |
| I4 | pieza, carga 2: I1–I3 otra vez | |

**H-acc (sin prediccion firme, `hipotesis`):** con la pistola el accesorio 5 de J2 lleva un agregado enganchado a la
ranura compartida, no a R3; si en la mitad de J2 aparece un fragmento fuera de lugar, es eso (`docs/16` (125)) y no
refuta la pieza.

**Refuta:** si con la pieza la mitad de J sigue dibujando la SPAS en `j2_cambio`, el arma se dibuja tambien desde otro
lado (empezar por `clon_comparte.py`: `+0x294`, `+0x35C`). Si la mitad de J2 queda con las manos vacias o con basura,
SOP2 o los buffers de J2 estan mal (mirar R1 y R3). Si R1 no se cumple, la llamada no corrio (mirar el envoltorio
instalado: 111 palabras). Si el contador de J2 se clava, la pieza cuelga el armado y nada de lo demas mide.
