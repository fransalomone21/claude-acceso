# R1 — rendimiento por casilla, medido el 2026-09-01

Misma escena en las tres: savestate `SLUS-21376 (5C891FF1).03.p2s` (calle,
vida llena), ~15-25s después de cargar, un solo frame leído del OSD nativo de
PCSX2 (`OsdShowFPS`, `OsdShowCPU`, `OsdShowGPU`, `OsdShowFrameTimes`).
Capturas: `d3d11-native.png`, `d3d11-4x.png`, `d3d12-4x.png`.

| casilla | FPS | Frame (OSD) | GPU% | GPU ms | EE% | EE ms | VU% | VU ms | GS% | GS ms |
|---|---|---|---|---|---|---|---|---|---|---|
| D3D11 @ Native | 29.97 | 16.68 ms | 60.1% | 10.02 ms | 39.3% | 6.56 ms | 18.0% | 3.00 ms | 16.1% | 2.68 ms |
| D3D11 @ 4x     | 29.97 | 16.69 ms | 57.9% |  9.67 ms | 38.3% | 6.39 ms | 17.5% | 2.92 ms | 16.2% | 2.70 ms |
| D3D12 @ 4x     | 29.97 | 16.68 ms | 18.5% |  3.08 ms | 40.9% | 6.82 ms | 17.9% | 2.99 ms | 19.5% | 3.26 ms |

## Lectura

**El FPS no discrimina: las tres casillas están tapadas en 29.97**, idénticas
entre sí (el juego corre a mitad de la tasa de V-Blank — 59.94 — sea cual sea
el renderer o la resolución interna). El frame time del OSD (~16.68 ms) es
consistente con eso y tampoco distingue.

**Lo que sí distingue es el uso de GPU.** D3D11 gasta 58-60% del frame
(9.7-10.0 ms) en las dos resoluciones, prácticamente sin diferencia entre
Native y 4x — el 4x no le cuesta nada extra a D3D11 en esta escena. D3D12
gasta **18.5% (3.08 ms)**, un tercio del tiempo de GPU de D3D11 para el mismo
4x y el mismo FPS. EE/VU/GS (trabajo de CPU emulado) están parejos en las
tres, como corresponde — no dependen del backend gráfico.

## Decisión

**D3D12 @ 4x.** Mismo FPS que las otras dos casillas (el tope es del juego,
no del renderer), con un tercio del gasto de GPU de D3D11. Esa diferencia
importa porque el pipeline final agrega DLSS5/ReShade encima de lo que
PCSX2 ya está usando: cuanto menos GPU consuma el renderer base, más margen
queda para el upscaler sin caer del FPS objetivo. No es una preferencia por
"D3D12 parece más moderno" — es la medición de GPU% la que decide.

No se pudo confirmar ni descartar la colisión que arrastra 8.4 del HANDOFF
(la de la sesión 40 con el objetivo 4-6x): a 4x, con este savestate, D3D12 no
mostró ningún síntoma (ni caída de FPS, ni stutter visible en el gráfico de
frame times, ni GPU saturada). Si aparece en escenas más cargadas, ahí sí
amerita revisar.
