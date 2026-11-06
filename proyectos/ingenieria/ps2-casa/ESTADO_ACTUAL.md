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
| Memory cards: una Sony 8 MB (SCPH-10020) y una «Sony 64 MB MagicGate» | fotos de Fran | 2026-11-06 |
| ISOs de PS2 en la PC: 13 (≈ 59 GB). En `C:\Games\PS2-ISOs\` 4 de DBZ/anime; en `Desktop\Juegos\Juegos de emulador\PS2\` BT4 Beta 14 y 14 REV2, Niveles de Poder 8.1, God of War II, BLACK y sus mods | búsqueda en todos los discos, archivos > 100 MB | 2026-11-06 |
| 5 ISOs pasan de 4 GB (GoW II 7,95; Black USA 7,29; BT4 5,03 y 4,98; Niveles 4,35): no entran en un pendrive FAT32, y el de 16 GB lleva 3 o 4 juegos | mismo listado | 2026-11-06 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| La tarjeta de 64 MB es un clon | que el exploit no se instale o no arranque desde ella | no se instaló nada |
| La consola 1C tiene ROM 2.30 | ROMVER en uLaunchELF | hace falta lanzar uLaunchELF en la consola |
| La 8C acepta FreeMcBoot | ROMVER + que arranque solo | idem |
| Fran ya tiene FMCB instalado en alguna tarjeta | que lo diga, o que la tarjeta lo arranque | dijo «supe instalar»: puede ser pasado |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|

## Lo próximo

Fran mide el ROMVER de las dos y contesta las preguntas abiertas (HANDOFF);
con eso la sesión arma el concepto y él elige. Investigación: `docs/investigacion-red.md`.
