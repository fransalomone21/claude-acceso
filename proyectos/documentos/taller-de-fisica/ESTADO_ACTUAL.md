# Estado actual — Taller de Física

**Última actualización:** 2026-09-13

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Estructura y fuentes | **en curso, casi cerrada** |
| 1 — Escribir | **bloqueada a propósito, sin fecha** |

**Qué cierra la fase 0:** que el recorte de Pisacane quede cruzado contra
`../fisica-espacial/fuentes/TEMARIO.md` y confirmado por Fran. Ferraro y
Young-Freedman ya están cerrados (ver `fuentes/RUTAS.md`).

**La fase 1 no arranca sin que Fran lo pida explícitamente.** Dijo: "todo lo
de taller de física es para un plazo más largo, yo te voy a decir cuándo
empezarlo". Ninguna sesión escribe un módulo de contenido antes de esa señal,
aunque el recorte de Pisacane ya esté confirmado.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| Las tres fuentes del Taller están en el disco | `ls` de `Desktop\Mis Documentos\SistemasEspaciales\Libros de Fisica\`: Ferraro, Pisacane y Young-Freedman presentes | 2026-09-13 |
| Ferraro trae sólo los capítulos 1-3 (137 páginas), no el libro completo | `pymupdf` sobre el PDF: 137 páginas, contenido confirmado hasta §3.18 (pág. impresa ~123) leyendo el índice y una página de muestra | 2026-09-13 |
| Pisacane trae 441 páginas, 12 capítulos, con capa de texto (no hace falta rasterizar) | extracción de texto directa con `pymupdf`, incluido el índice completo y el prefacio con el programa de curso propio del autor | 2026-09-13 |
| El path de Pisacane supera los 260 caracteres de Windows y necesita el prefijo `\\?\` | `os.path.exists()` daba `False` con el path normal y `True` con el prefijo largo; se abrió y leyó el PDF con el prefijo | 2026-09-13 |
| Arquitectura: proyecto propio, separado de `fisica-espacial` | decisión de Fran ("decidilo vos"), registrada en `PDP.md` §6 | 2026-09-13 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| El recorte de Pisacane (caps. 3, 4, 6, 8, 9, 11) es el correcto | Cruzarlo contra `../fisica-espacial/fuentes/TEMARIO.md` y que Fran lo confirme | Fran pidió ese cruce explícito el 2026-09-13 y todavía no se hizo — ver `docs/bitacora.md` |

## Callejones sin salida

*(ninguno todavía)*

## Lo próximo

Cruzar el recorte propuesto de Pisacane contra el temario confirmado de
Física Espacial, y esperar que Fran dé la señal de arrancar la fase 1. El
detalle está en `PDP.md` §4 y §6.
