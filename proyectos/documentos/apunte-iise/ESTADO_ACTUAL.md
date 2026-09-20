# ESTADO ACTUAL — Apunte de IISE

**Fase 2** (redacción, una unidad por sesión). La fase 0 cerró el **2026-09-20**
y la **fase 1 también**, el mismo día.

## Qué hay

| Cosa | Estado |
|---|---|
| Material fuente de las 7 clases | **cerrado** — 590 diapositivas en `fuentes/clases/clase-N.txt`, con el número de diapositiva REAL y el título de cada una |
| Índice de diapositivas por título | **cerrado** — `fuentes/clases/titulos.md` |
| Diapositivas-figura | **cerrado** — 177 PNG en `fuentes/figuras/` (no se commitean; las regenera el extractor) |
| Insumos de NotebookLM | **guardados y medidos** — `fuentes/externo/` |
| Glosario controlado | **unidades 1 a 3**: 29 términos en `fuentes/glosario.md`. Las 4 a 7 entran al escribir sus módulos |
| `verificar-lexico.py` | **escrito y en VERDE** |
| `probar-verificar-lexico.py` | **escrito y en VERDE**: los tres sabotajes dan rojo, el control positivo da verde y la excepción declarada se respeta |
| Infraestructura Typst | **montada** en `apunte/`: `plantilla.typ`, `biblioteca/paleta.typ`, `biblioteca/figuras.typ` |
| **Unidad 0 — el glosario (M00)** | **ESCRITA** — `apunte/modulos/m00-glosario.typ`, los 29 términos |
| **Unidad 1 — M01, M02, M03** | **ESCRITA** — los tres módulos, sobre las 41 diapositivas de la clase 1 |
| Unidades 2 a 7 | **pendientes** — una sesión por unidad |
| PDF | **compila**: `apunte/apunte.pdf`, **25 páginas** |
| Parcialitos | 1, 2 y 3 en `fuentes/parcialitos.md`. Los de las clases 4 a 7 **no van a llegar**: la cátedra no los devolvió, y **el apunte NO se escribe en función de ellos** (decisión de Fran, 2026-09-20) |

## Lo que la fase 1 dejó medido

1. **El verificador encontró cinco cosas reales en su primera corrida**, sobre
   módulos recién escritos: dos términos marcados que el glosario no tenía con
   ese nombre, una sigla sin alias, y una palabra prohibida sin declarar. No
   fue un verde de cortesía.
2. **La excepción se declara con `// lexico-ok` en la misma línea.** El módulo 0
   nombra a propósito las palabras que *no* se usan; sin ese mecanismo, la
   única tabla que explica el léxico sería la que rompe el léxico.
3. **La plantilla copiada de `fisica-espacial` traía el TEXTO de Física
   Espacial**, no sólo el estilo: portada, pie de página y encabezado hablaban
   de Beer, Curtis y mecánica orbital, y **Typst compilaba en verde**. Lo
   atrapó mirar la página compilada (regla propia 4), nada más.
4. **Una tabla Typst de tres columnas con anchos `auto` colapsa** si una de
   ellas tiene texto largo: la del medio salió con *una letra por renglón* y
   compiló sin un solo warning. En este apunte las tablas llevan fracciones
   explícitas (`1.5fr`), no `auto`.

## La numeración impresa NO es la del PDP

El PDP numera M00…M26 — son las **claves de archivo y de planificación**. El
apunte impreso numera los módulos por su posición: el glosario es el **módulo
1**, y M01 del PDP es el **módulo 2** impreso. No hay divergencia de datos: la
prosa nunca escribe un número, usa `#M("clave")` y el número sale del orden de
los `#include` de `apunte.typ`.

## Qué sigue

**Unidad 2** (clase 2, 97 diapositivas, 21 de ellas figura): pensamiento
sistémico, forma y función, emergentes, las cuatro Tareas. Son los módulos
M04–M07 del PDP. Una sesión, leyendo **sólo** `fuentes/clases/clase-2.txt`.
