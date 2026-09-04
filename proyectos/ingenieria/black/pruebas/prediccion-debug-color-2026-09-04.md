# Predicción — pack de DEBUG con mips de color plano (2026-09-04, 01:5x)

Escrita **antes** de instalar el pack y de mirar la pantalla. Regla del
proyecto: la predicción se escribe antes de abrir el emulador, si no el
experimento no distingue nada.

## Qué se instala

`replacements-DEBUG-colores-2026-09-04` (8225 archivos, generado por
`herramientas/mipmaps_debug_color.py` desde `replacements-sin-mips-2026-09-04`).
Nivel 0 = bytes originales intactos. Nivel 1 = magenta, 2 = verde, 3 = cyan,
4 = rojo, 5 = azul, 6 = amarillo, 7+ = naranja. Misma estructura de header y
misma cantidad de niveles que el pack real: la **única** diferencia es el
contenido de los niveles.

## Lo ya medido antes de este experimento (no es predicción, es dato)

Capturas pareadas del mismo encuadre, con el pack real de mip chain, tomadas
por la sesión con `pcsx2_teclado.ps1` + hotkey F8 (evidencia en
`Documents\PCSX2\textures\SLUS-21376\evidencia-mipmap-2026-09-04\`):

| región | mip ON (A) | mip OFF (B) | ON otra vez (C) |
|---|---:|---:|---:|
| barrera (el síntoma) | 34,4 | 1017,5 (+2854 %) | 34,5 (+0 %) |
| pared derecha | 125,9 | 405,5 (+222 %) | 125,9 (+0 %) |
| auto derecho | 728,6 | 1577,2 (+116 %) | 728,6 (+0 %) |
| poste derecho (cerca) | 189,1 | 347,7 (+84 %) | 189,1 (−0 %) |
| caja izquierda (cerca) | 195,2 | 210,6 (+8 %) | 195,2 (+0 %) |

Hipótesis 1 (**la barrera no tiene reemplazo**) queda **MUERTA**: con mipmap
apagado la barrera muestra detalle HD real —vetas, grietas, pintura
descascarada— y es reconociblemente la misma textura. Sin reemplazo eso no
puede pasar.

## Predicción, por hipótesis

| resultado en pantalla | qué queda probado |
|---|---|
| la barrera aparece de un **COLOR PLANO** (cyan/rojo/azul, o sea nivel 3-5) y las superficies cercanas siguen con su textura normal | El mip chain **SE LEE**. El problema es el **NIVEL ELEGIDO**, no el archivo. Hipótesis 2 muerta; queda una hipótesis nueva (H4, nivel demasiado agresivo para la resolución de render) que ninguna de las tres originales contemplaba |
| la barrera aparece de color **magenta o verde** (nivel 1-2) | El chain se lee y el nivel es razonable — entonces el blur no viene del nivel elegido sino de la calidad del downsample, y el arreglo es otro (filtro, sharpening) |
| la barrera sigue **borrosa y gris/beige, sin ningún color** | El chain **NO se lee**: los niveles bajos salen del original de PS2. Hipótesis 2 CONFIRMADA. Ahí sí hay que releer `GSTextureReplacements.cpp` a fondo |
| **toda** la pantalla de un color plano | algo del pack o del header está mal y el nivel 0 tampoco se usa — se revierte y se revisa la herramienta |

**Predicción concreta de esta sesión (la que se puede errar):** la barrera va
a salir de **color plano**, y el nivel va a ser **3 o más alto** (cyan/rojo/
azul/amarillo), porque una varianza de laplaciano de 34,4 contra 1017,5 es
una pérdida de detalle de ~30x, demasiada para el nivel 1 o 2. Las superficies
cercanas y frontales (caja izquierda, +8 % apenas) deberían quedar con su
textura **normal**, o sea nivel 0.

## Por qué este test y no más verificación del archivo

La verificación estática se agotó: el pack pasó 8225/8225 por bytes
(reparseo idéntico al parser real) y por píxel (decodificado a PNG), y el
síntoma volvió igual. Un archivo bien construido no prueba que PCSX2 lo lea
ni qué nivel elija. Esto se mira en la pantalla y el color contesta las dos
cosas de una.
