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
| Glosario controlado | **unidades 1 a 4**: 34 términos en `fuentes/glosario.md`. Las 5 a 7 entran al escribir sus módulos. La cita de «tabla N²» se corrigió en esta sesión (diapositiva 31 → 71/73: apuntaba a la sección equivocada) |
| `verificar-lexico.py` | **escrito y en VERDE** |
| `probar-verificar-lexico.py` | **escrito y en VERDE**: los tres sabotajes dan rojo, el control positivo da verde y la excepción declarada se respeta |
| Infraestructura Typst | **montada** en `apunte/`: `plantilla.typ`, `biblioteca/paleta.typ`, `biblioteca/figuras.typ` |
| **Unidad 0 — el glosario (M00)** | **ESCRITA** — `apunte/modulos/m00-glosario.typ`, los 29 términos |
| **Unidad 1 — M01, M02, M03** | **ESCRITA** — los tres módulos, sobre las 41 diapositivas de la clase 1 |
| **Unidad 2 — M04, M05, M06, M07** | **ESCRITA** (2026-09-20) — sobre las 97 diapositivas de la clase 2: arquitectura de sistema, pensamiento sistémico y emergentes, forma/función y entidades (Tareas 1-2), relaciones y tabla N² (Tareas 3-4) |
| **Unidad 3 — M08, M09, M10** | **ESCRITA** (2026-09-20) — sobre las 48 diapositivas de la clase 3: rol del arquitecto y entregables, la ambigüedad (borrosidad/incertidumbre, información desconocida/conflictiva/falsa), y el PDP (cuatro casos reales + PDP genérico + PDP global de 3 vistas) |
| **Unidad 4 — M11, M12, M13, M14** | **ESCRITA** (2026-09-20) — sobre las 124 diapositivas de la clase 4 (la más grande): por qué hace falta la IS (Saturno V, Hubble), sistema de sistemas y la ISS, el proceso de punta a punta (Space Shuttle y un rover marciano) y el motor de NASA de 17 actividades |
| Unidades 5 a 7 | **pendientes** — una sesión por unidad |
| PDF | **compila**: `apunte/apunte.pdf`, **67 páginas** |
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

## Lo que esta sesión (unidad 2) dejó medido

1. **Otro defecto real de citación, encontrado mirando el PNG antes de
   escribir (regla propia 2):** el glosario citaba «tabla N²» en la
   diapositiva 31 de la clase 2, que es la sección de Emergentes — nada que
   ver. La ubicación real (diapositiva 71, diagrama; diapositiva 73, las dos
   tablas) se confirmó mirando `c02-p074.png` y `c02-p075.png`, que son las
   tablas reales sin texto extraíble del `.txt`.
2. **Una tabla con una columna vacía de más compiló en verde** (Tabla 2.3
   recortada, en M06): quedó una cuarta columna sin encabezado ni contenido,
   visible sólo al mirar la página renderizada. Se sacó.
3. Las dos tablas N² del circuito amplificador (formal y funcional) se
   reprodujeron enteras como tablas Typst, verificadas contra las imágenes
   `c02-p074.png`/`c02-p075.png` — no son un resumen, son el contenido real
   de la Tabla 2.5 de la cátedra.

## Lo que esta sesión (unidad 3) dejó medido

1. **Primera vez que el apunte embebe una imagen (`image()`) en vez de
   reconstruir todo como tabla.** Dos figuras del libro —el PDP de
   Helicopter Inc. (Fig. 9.2) y el marco holístico de las 7 preguntas W
   (Fig. 9.6)— no se pueden reescribir como tabla sin perder el diagrama en
   sí, que es el contenido. Typst sandboxea el proyecto a la carpeta de
   `apunte.typ`: una ruta `../../fuentes/figuras/...` que sale de ahí falla
   con «would escape the project root». Se resolvió copiando las dos PNG
   necesarias a `apunte/figuras/` (nueva carpeta, DENTRO del sandbox, y esas
   sí se commitean) en vez de mover el `--root` del compilador.
2. El PDP genérico (Concebir–Diseñar–Implementar–Operar) es, letra por
   letra, el mismo CDIO de la unidad 1 — la cátedra lo señala explícito
   (clase 3, diapositiva 23) y quedó como `deduccion` en M10.

## Lo que esta sesión (unidad 4) dejó medido

1. **Primer módulo con una figura fuera del libro de Crawley/Cameron/Selva:**
   las Alternativas Propuestas para el Space Shuttle (Fig. en clase 4,
   diapositiva 45) muestran 14 familias de conceptos reales evaluados antes
   de elegir uno — se embebió igual que las de la unidad 3, copiando el PNG
   a `apunte/figuras/`.
2. **Dos conexiones nuevas con unidades anteriores**, quedaron explícitas
   como `deduccion`/`clave` en los módulos: el CDIO detallado de 8 pasos
   (clase 4, diapositiva 41) es el mismo CDIO de 4 fases de la unidad 1, con
   más resolución; y la jerarquía del sistema (7 niveles: Sistema, Segmento,
   Elemento, Subsistema, Componente, Sub ensamble, Parte) es el mismo
   «principio de los niveles» (N+1/N/N-1) de la unidad 1, con nombre propio
   en cada escalón — y la fórmula de niveles = log(partes)/log(7) conecta
   directo con el 7±2 de la unidad 2.
3. Glosario de la unidad 4 escrito de cero en esta sesión (5 términos
   nuevos): sistema de sistemas, jerarquía del sistema, CDIO detallado,
   motor de la ingeniería de sistemas, atributos del ingeniero de sistemas.

## Qué sigue

**Unidad 5** (ciclo de vida, requerimientos, márgenes, alcance): son los
módulos M15–M18 del PDP. La unidad 4 ya dejó dos promesas explícitas que la
5 tiene que cumplir: desarrollar **verificación y validación (V&V)** a
fondo (prometido en M03 y otra vez en M13) y los **márgenes** (prometido en
M11, con el Saturno V como ejemplo ya usado — no repetirlo, referenciarlo).
El glosario de la unidad 5 todavía no está escrito.
