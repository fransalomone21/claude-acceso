# Estado actual — Taller de Física

**Última actualización:** 2026-09-13

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Estructura y fuentes | **CERRADA** |
| 1 — Escribir | **bloqueada a propósito, sin fecha** |

**La fase 0 cerró con el recorte de Pisacane confirmado por Fran:**
"correlativo = continúa un tema ya confirmado, sumá el 5" → 7 capítulos —
**3, 4, 5, 6, 8, 9, 11** de 12. Ferraro y Young-Freedman ya estaban cerrados
(ver `fuentes/RUTAS.md`).

**La fase 1 no arranca sin que Fran lo pida explícitamente**, aunque el
recorte ya esté confirmado. Dijo: "todo lo de taller de física es para un
plazo más largo, yo te voy a decir cuándo empezarlo".

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| Las tres fuentes del Taller están en el disco | `ls` de `Desktop\Mis Documentos\SistemasEspaciales\Libros de Fisica\`: Ferraro, Pisacane y Young-Freedman presentes | 2026-09-13 |
| Ferraro trae sólo los capítulos 1-3 (137 páginas), no el libro completo | `pymupdf` sobre el PDF: 137 páginas, contenido confirmado hasta §3.18 (pág. impresa ~123) leyendo el índice y una página de muestra | 2026-09-13 |
| Pisacane trae 441 páginas, 12 capítulos, con capa de texto (no hace falta rasterizar) | extracción de texto directa con `pymupdf`, incluido el índice completo y el prefacio con el programa de curso propio del autor | 2026-09-13 |
| El path de Pisacane supera los 260 caracteres de Windows y necesita el prefijo `\\?\` | `os.path.exists()` daba `False` con el path normal y `True` con el prefijo largo; se abrió y leyó el PDF con el prefijo | 2026-09-13 |
| Arquitectura: proyecto propio, separado de `fisica-espacial` | decisión de Fran ("decidilo vos"), registrada en `PDP.md` §6 | 2026-09-13 |
| Recorte de Pisacane: 7 capítulos (3,4,5,6,8,9,11) | confirmación explícita de Fran en el chat: "correlativo = continúa un tema ya confirmado, sumá el 5" | 2026-09-13 |

## Lo que es hipótesis

*(ninguna — la fase 0 cerró sin hipótesis pendientes)*

## Callejones sin salida

*(ninguno todavía)*

## Lo próximo

Que Fran dé la señal de arrancar la fase 1 (escribir). Cuando la dé, la
próxima sesión arma el PDP de esa fase con los 7 capítulos de Pisacane, los
3 de Ferraro y Young-Freedman como referencia — el detalle de cada uno está
en `fuentes/RUTAS.md` y `docs/bitacora.md`.
