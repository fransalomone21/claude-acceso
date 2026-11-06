# Estado actual — ps2-casa

**Última actualización:** 2026-11-06

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-Fase A, *Concept Studies* | **en curso** |

**Qué cierra la fase en curso:** en PDP §6, con fecha, el concepto que eligió
Fran para cada consola (exploit de arranque + carga de juegos), y acá abajo el
ROMVER de las dos.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| Las dos consolas son SCPH-90001 NTSC U/C, códigos de fecha 8C y 1C | etiquetas, en fotos de Fran | 2026-11-06 |
| Hay **una sola** memory card: la «Sony 64 MB MagicGate» (las dos fotos eran su frente y su dorso; la etiqueta trasera dice SCPH-10020). No hay tarjeta de 8 MB; Agustín tendría una, para más adelante | Fran, 2026-11-06 («no tengo de 8 MB») | 2026-11-06 |
| Una de las consolas (falta saber si la 8C o la 1C): Browser 1.40, CD Player 2.00, PlayStation Driver 2.00, DVD Player **3.11U** | foto de «Version Information» (△ en el menú principal), Fran | 2026-11-06 |
| La consola medida es la **8C** | Fran | 2026-11-06 |
| La tarjeta de 64 MB TIENE homebrew: carpetas BOOT, APPS, OPL y cuatro «Free McBoot» (instalación múltiple), más partidas (Tom y Jerry, NFS MW…). En la 8C **no arrancó sola** | foto del navegador de la tarjeta, Fran | 2026-11-06 |
| **La 8C tiene chip**: arranca el BLACK grabado | Fran, 2026-11-06 | 2026-11-06 |
| La 1C no da señal de video | Fran | 2026-11-06 |
| El △ en el menú principal abre «Version Information» sin programas | la foto de arriba | 2026-11-06 |
| ISOs de PS2 en la PC: 13 (≈ 59 GB). En `C:\Games\PS2-ISOs\` 4 de DBZ/anime; en `Desktop\Juegos\Juegos de emulador\PS2\` BT4 Beta 14 y 14 REV2, Niveles de Poder 8.1, God of War II, BLACK y sus mods | búsqueda en todos los discos, archivos > 100 MB | 2026-11-06 |
| 5 ISOs pasan de 4 GB (GoW II 7,95; Black USA 7,29; BT4 5,03 y 4,98; Niveles 4,35): no entran en un pendrive FAT32, y el de 16 GB lleva 3 o 4 juegos | mismo listado | 2026-11-06 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| La tarjeta de 64 MB es un clon | que el exploit no se instale o no arranque desde ella | no se instaló nada |
| La consola 1C tiene ROM 2.30 | ROMVER en uLaunchELF | hace falta lanzar uLaunchELF en la consola |
| La 8C acepta FreeMcBoot | ROMVER + que arranque solo | idem |
| La tarjeta de 64 MB ya tiene FMCB (Fran recuerda entrar con un truco de botones) | prender con la tarjeta y ver el menú de FMCB, o R1 apretado al prender | falta que Fran lo pruebe |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|

## Lo próximo

Fran mide el ROMVER de las dos y contesta las preguntas abiertas (HANDOFF);
con eso la sesión arma el concepto y él elige. Investigación: `docs/investigacion-red.md`.
