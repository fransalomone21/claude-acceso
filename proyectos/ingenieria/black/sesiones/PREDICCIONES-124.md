# Predicciones de (124) — F7: el soporte del modelo de primera persona, en vivo

Escritas **antes** de la corrida, el 2026-10-09, con la lectura en frio de `docs/16` seccion (124). Se agregan
resultados al lado; ninguna fila se reescribe.
Banco: `herramientas/f7_soporte.py` (pnach por defecto, **sin** la pieza 2b; City Streets por el selector; precondicion
de `arma_pieza_banco.py --solo-j2`: J2 junta la SPAS y queda con dos armas, J con la pistola).

**La hipotesis** (`probable` en frio): J y J2 dibujan con **el mismo** soporte de modelo (`P+0x328` → `0x00597810` en
los volcados de (93)) y **los mismos** buffers de registros (`P+0x354`, `P+0x358`). El que cambia de arma ultimo le
pone su modelo; cada uno lo dibuja con su pose y su mapa de huesos. **La intervencion**: en pausa, devolverle al
soporte el modelo de la pistola y copiar los registros de ese modelo (lo que hace `FUN_00136B50`); despues, otra vez
la SPAS (ON → OFF → ON).

## R — en RAM (el seam barato: se lee siempre)

| # | Prediccion | Resultado |
|---|---|---|
| R1 | en `base` y en `j2_cambio`: `J+0x328` = `J2+0x328`, `J+0x354` = `J2+0x354`, `J+0x358` = `J2+0x358` (el mod de hoy, como el de (93)) | **CUMPLIDA** en los cinco estados: soporte `0x00597810`, buffers `0x006EC700` / `0x006EC780` (las mismas direcciones que en los volcados de (93)); las ranuras si son distintas (`0x004ED7F0` / `0x0046E100`) |
| R2 | `*(soporte)` **cambia** entre `base` y `j2_cambio` (de la pistola a la SPAS) | **CUMPLIDA**: `0x01AE7E00` (pistola) → `0x01A33100` (SPAS) con el cambio de J2 (indices 0,0 → 0,1) |
| R3 | `M+0x08` (`pers+0x8F8`), muestreado 5 veces en `base` y 5 en `j2_cambio`, toma **los mismos** valores en los dos estados (el bloque de la ranura que anima ultima en el cuadro), aunque el arma dibujada en la mitad de J cambie: `M+0x08` no sigue al que cambio | **CUMPLIDA**: varia DENTRO de cada estado (`base` 2, 0x23, 5, 5, 5; `j2_cambio` 5, 5, 0x23, 2, 2; igual en los otros tres) y toma el mismo juego de valores en todos. El asignador no sigue a la variable: queda descartado como causa |

## I — en pantalla (el discriminador)

| # | Prediccion | Resultado |
|---|---|---|
| I0 | `base`: las dos mitades dibujan la pistola (C1 de (123)); `j2_cambio`: F7 — la de J dibuja la SPAS torcida con el bloque de basura, la de J2 la SPAS bien | **CUMPLIDA** (`base.png`, `j2-cambio.png`) |
| I1 | **B** (soporte y registros ← pistola): la mitad de J dibuja **la pistola bien formada**; la de J2 **deja** de dibujar la SPAS bien (pistola torcida o basura: la malla de la pistola con el esqueleto de la SPAS) | **CUMPLIDA** (`b-pistola.png`): la mitad de J dibuja su pistola entera, como en la base; la de J2 queda con las dos manos vacias y un fragmento suelto -- la SPAS desaparece |
| I2 | **C** (soporte y registros ← SPAS): vuelve la foto de F7 | **CUMPLIDA** (`c-spas.png`): otra vez la SPAS torcida con el bloque en la mitad de J y la SPAS bien en la de J2 |
| I3 | **B otra vez**: igual que I1 | **CUMPLIDA** (`d-pistola.png`) |

**Refuta:** si con B la mitad de J sigue con la SPAS, el soporte no decide la malla de la mitad de J y F7 vive en otra
capa (los accesorios `+0x25C` o el dibujo diferido). Si con B la mitad de J2 no cambia, J2 dibuja con otro soporte (y R1
tendria que haber salido distinto). Si el contador de cuadros de J2 no sube entre pasos, el juego esta colgado y nada
de esto mide.

## Resultado (2026-10-09 19:45, `volcados/arma/f7-soporte-20261009-194546/`, `resumen.json`)

Las siete filas cumplidas. Vivo entre todos los pasos (cuadros de J2: 816, 955, 1060, 1165, 1272), cinco fotos
distintas por md5, cada copia de registros leida de vuelta igual (56 B y 96 B: los mismos largos para la pistola y
la SPAS). **F7 pasa a `confirmado`:** intervine en la causa (el modelo del soporte y sus registros) y vi el efecto en
las dos mitades, en los dos sentidos y tres veces (ON → OFF → ON). J y J2 dibujan el arma de primera persona desde
**un solo soporte**, que J2 hereda por ser copia del molde, y el ultimo que cambia de arma le pone el suyo.
