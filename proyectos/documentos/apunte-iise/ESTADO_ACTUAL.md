# ESTADO ACTUAL — Apunte de IISE

**PROYECTO CERRADO — las seis fases (0 a 5) cerradas.** Las fases 0 a 4
cerraron el 2026-09-20; la **fase 5 (figuras didácticas) el 2026-09-21**. El
apunte está escrito (7 unidades, 28 módulos, **123 páginas, 18 figuras**),
mapeado contra los parcialitos (16 preguntas, ninguna huérfana) y **publicado
en el Drive de los compañeros**, verificado por MD5, en la subcarpeta
`Material de Estudio nuestro/Apunte GENERAL` que armó Fran.

Lo único que queda vivo es el mantenimiento: si se toca un módulo, se
recompila, se corren `verificar-lexico.py` y `verificar-cobertura.py`, y se
vuelve a subir con `publicar-apuntes.ps1` — el medidor de cada arranque avisa
si el Drive quedó atrasado.

## Qué hay

| Cosa | Estado |
|---|---|
| Material fuente de las 7 clases | **cerrado** — 590 diapositivas en `fuentes/clases/clase-N.txt`, con el número de diapositiva REAL y el título de cada una |
| Índice de diapositivas por título | **cerrado** — `fuentes/clases/titulos.md` |
| Diapositivas-figura | **cerrado** — 177 PNG en `fuentes/figuras/` (no se commitean; las regenera el extractor) |
| Insumos de NotebookLM | **guardados y medidos** — `fuentes/externo/` |
| Glosario controlado | **las 7 unidades, completo**: 71 términos en `fuentes/glosario.md`. La cita de «tabla N²» se corrigió en una sesión previa (diapositiva 31 → 71/73: apuntaba a la sección equivocada) |
| `verificar-lexico.py` | **escrito y en VERDE** |
| `probar-verificar-lexico.py` | **escrito y en VERDE**: los tres sabotajes dan rojo, el control positivo da verde y la excepción declarada se respeta |
| Infraestructura Typst | **montada** en `apunte/`: `plantilla.typ`, `biblioteca/paleta.typ`, `biblioteca/figuras.typ` |
| **Unidad 0 — el glosario (M00)** | **ESCRITA** — `apunte/modulos/m00-glosario.typ`, los 29 términos |
| **Unidad 1 — M01, M02, M03** | **ESCRITA** — los tres módulos, sobre las 41 diapositivas de la clase 1 |
| **Unidad 2 — M04, M05, M06, M07** | **ESCRITA** (2026-09-20) — sobre las 97 diapositivas de la clase 2: arquitectura de sistema, pensamiento sistémico y emergentes, forma/función y entidades (Tareas 1-2), relaciones y tabla N² (Tareas 3-4) |
| **Unidad 3 — M08, M09, M10** | **ESCRITA** (2026-09-20) — sobre las 48 diapositivas de la clase 3: rol del arquitecto y entregables, la ambigüedad (borrosidad/incertidumbre, información desconocida/conflictiva/falsa), y el PDP (cuatro casos reales + PDP genérico + PDP global de 3 vistas) |
| **Unidad 4 — M11, M12, M13, M14** | **ESCRITA** (2026-09-20) — sobre las 124 diapositivas de la clase 4 (la más grande): por qué hace falta la IS (Saturno V, Hubble), sistema de sistemas y la ISS, el proceso de punta a punta (Space Shuttle y un rover marciano) y el motor de NASA de 17 actividades |
| **Unidad 5 — M15, M16, M17, M18** | **ESCRITA** (2026-09-20) — sobre las 71 diapositivas de la clase 5: ciclo de vida de NASA y diagrama en V, qué es un requerimiento (MCO vs. DC-3) y gestión de márgenes a fondo, la familia de requerimientos con trazabilidad de 6 niveles, y verificación/validación a fondo con los 7 elementos del alcance |
| **Unidad 6 — M19, M20, M21, M22, M23** | **ESCRITA** (2026-09-20) — sobre las 155 diapositivas de la clase 6 (la más larga): familia de requerimientos e interfaces (IDD/IRD/ICD), el Ejercicio de Alcance con seis ConOps reales, SMART y verificación/validación operativas, Pre-Fase A a fondo con los cinco modelos de ciclo de vida, e ingeniería concurrente y mecatrónica. **5 módulos, no los 4 previstos** — ver PDP.md §8 |
| **Unidad 7 — M24, M25, M26, M27** | **ESCRITA** (2026-09-20) — sobre las 54 diapositivas de la clase 7: cómo se crea una arquitectura (síntesis/descubrimiento, 4 métodos, factores de balance, arquitectura vs. diseño), Fase A a fondo con el ConOps del Mars 2020 y la herencia del Curiosity, las revisiones SRR y MDR una al lado de la otra, y el diagrama N² aplicado a interfaces con el caso real del TDRS y una matriz de 17 disciplinas. **Cierra el apunte: las 7 unidades escritas** |
| PDF | **compila**: `apunte/apunte.pdf`, **123 páginas**, 13 MB, 18 figuras embebidas |
| Parcialitos | 1, 2 y 3 en `fuentes/parcialitos.md`, **mapeados**: 16 preguntas, 34 anclas `MNN §sección`, ninguna huérfana. Los de las clases 4 a 7 **no van a llegar**: la cátedra no los devolvió, y **el apunte NO se escribe en función de ellos** (decisión de Fran, 2026-09-20) |
| `verificar-cobertura.py` | **escrito y en VERDE** — resuelve cada ancla contra el módulo y la sección reales |
| `probar-verificar-cobertura.py` | **escrito y en VERDE**: los cuatro sabotajes dan rojo y el control positivo da verde |

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

## Lo que esta sesión (unidad 5) dejó medido

1. **Las dos promesas pendientes se cumplieron.** M18 desarrolla verificación
   y validación a fondo (distinción ya usada sin desarrollar en M03 y M13),
   con la cámara de vacío térmico como ejemplo de verificación ambiental; y
   M16 desarrolla la gestión de márgenes a fondo, con la tabla de guías
   típicas (SRR +30% → IOC 5%) y la conexión explícita con el quinto motor
   del Saturno V (M11).
2. **Dieciocho términos nuevos en el glosario** (52 en total): la unidad más
   densa en léxico del apunte hasta ahora, porque la clase 5 es, literalmente,
   una taxonomía de requerimientos y de elementos del alcance — consistente
   con la regla propia 1.
3. **Dos figuras reales embebidas**: el sistema de acoplamiento del Apollo
   (M17) y una cámara de vacío térmico de NASA (M18), las dos fotografías,
   no diagramas reconstruidos.
4. **Dos defectos de redacción atrapados mirando la página compilada** (regla
   propia 4, otra vez): una tabla angosta partía "Margen de masa que se
   mantiene" en dos líneas feas (se acortó el encabezado y se ajustó el ancho
   de columna), y "cámara de termo-vacío" partía el guión propio de la
   palabra al justificar (se unificó con el término ya usado en M13, "cámara
   de vacío térmico").
5. **Una excepción de léxico declarada**: los nombres de documento estándar
   URD y SRD ("Requisitos de Usuario/Software") citan el término tal como
   aparece en la diapositiva 9 — es el nombre propio de un documento de la
   industria, no la elección de palabra de la cátedra. Marcada con
   `// lexico-ok` en `m15-ciclo-de-vida-y-diagrama-en-v.typ`.

## Lo que esta sesión (unidad 6) dejó medido

1. **La unidad más larga salió con cinco módulos, no cuatro.** 155
   diapositivas con material genuinamente separable (ingeniería concurrente
   + mecatrónica no encajaban en los otros cuatro sin diluirlos): se agregó
   M23, y la unidad 7 corre un módulo más tarde (M24–M27). PDP.md §8 tiene
   la nota completa.
2. **Trece términos nuevos en el glosario** (65 en total).
3. **Un hallazgo que corrigió retroactivamente la unidad 5:** la
   diapositiva 85 de esta clase (comparación de seis modelos de ciclo de
   vida) muestra el corte exacto Formulación/Aprobación/Implementación del
   ciclo de NASA sobre el eje de baseline —algo que M15 (unidad 5) había
   dejado deliberadamente sin precisar, por falta de evidencia—. Se
   corrigió el `#cuidado` de M15 a `#clave` con el dato confirmado, citando
   la clase 6. Es la primera vez que una unidad posterior corrige, con
   evidencia, una hedge explícita de una unidad ya cerrada.
4. **Tres figuras reales embebidas**: una simulación CFD del Shuttle en
   reentrada (M20), y las figuras de comparación de ciclos de vida y de
   la espiral de Boehm, las dos en M22.
5. **Ningún defecto de redacción esta vez** — las trampas ya documentadas
   en el HANDOFF (fracciones en tablas, tags `#t[]` sin partir en dos
   líneas) se aplicaron desde el primer borrador.

## Lo que esta sesión (unidad 7, y cierre de la fase 2) dejó medido

1. **Las 7 unidades quedaron escritas.** Fase 2 cerrada: 28 módulos
   (M00–M27), 71 términos de glosario, 115 páginas, `verificar-lexico.py`
   en verde en las 7 unidades sin excepción.
2. **Seis términos nuevos en el glosario** (71 en total) — la unidad más
   chica en léxico nuevo, porque gran parte de su contenido (ciclo de vida
   de NASA, tabla N², arquitectura de sistema, baseline) ya estaba definido
   en unidades anteriores y esta unidad lo *aplica* en vez de redefinirlo.
3. **Repetido, ya en el segundo módulo, el error de re-`#definicion()`ar un
   término ya definido** (ver HANDOFF — la unidad 6 ya lo había pagado una
   vez): esta vez sobre `arquitectura de sistema`, en el borrador de M24.
   Se corrigió antes de compilar, con `#t[]` en prosa en vez de una segunda
   caja "DEFINICIÓN".
4. **Un tag `#t[]` partido en el salto de línea, otra vez** (M25): el mismo
   defecto que costó tres repeticiones en la unidad 6. Esta vez se detectó
   con el mismo `grep -n "#t\[[^\]]*$"` ya incorporado al paso 4 del
   HANDOFF — funcionó al primer uso.
5. **Tres figuras reales embebidas**: el panorama de misiones a Marte
   (M25), el rover Mars 2020 heredero del Curiosity (M25), y un thruster
   real con su P&ID (M25).
6. **La cátedra usa dos siglas para la misma revisión** (SDR/MDR, "System
   Definition Review" / "Mission Design Review") sin distinguirlas — se
   documentó la inconsistencia en vez de silenciarla, con `#cuidado` en M26
   y en el glosario.

## Lo que la fase 3 dejó medido

1. **Ningún hueco de contenido.** Las 16 preguntas se contestan con los
   módulos ya escritos; no hizo falta agregar una línea. La cobertura es un
   piso, no un techo: 18 de los 28 módulos no los toca ningún parcialito y no
   sobran.
2. **El mapeo anterior estaba mal en 9 de las 16 preguntas, y era plausible.**
   Se había escrito el mismo día, desde los parcialitos y sin abrir un módulo:
   CDIO y triángulo de hierro cruzados entre M01 y M02, ambigüedad y
   entregables cruzados entre M08 y M09, pensamiento holístico mandando a M04
   cuando se define en M06, y la tabla N² aplicada apuntando a **M26** — la
   numeración de antes de que la unidad 6 creciera a cinco módulos. Un mapeo a
   nivel módulo se escribe de memoria y suena bien; por eso ahora la columna
   lleva `§sección` exacta y la resuelve `verificar-cobertura.py`.
3. **El saboteador encontró un agujero real en su primera corrida**, y no en
   el verificador sino en sí mismo: el sabotaje (b) reemplazaba la primera
   aparición del ancla de ejemplo, que está en la **prosa** del banco y no en
   una fila de tabla — el verificador daba verde con razón. Es exactamente la
   clase de falso verde que la regla 3 existe para atrapar.
4. **Una salvedad quedó como `hipótesis`, no se silenció**: la corrección
   «influyen en las influencias ascendentes y descendentes» (parcialito 2) usa
   vocabulario de la clase 3, así que la reconstrucción de esa pregunta puede
   estar mal. Las dos lecturas están cubiertas, así que no cambia nada — pero
   no se cita como `confirmado`.

## Lo que la fase 4 dejó medido

1. **Publicado**: `Apunte de Introduccion a la Ingenieria de Sistemas
   Espaciales.pdf`, 10,3 MB, en la carpeta `IISE` del Drive. `publicar-apuntes.ps1
   -Verificar` lo da al día **comparando MD5**, no fechas.
2. **El medidor se puso en rojo antes del verde.** Declarar el apunte en
   `.claude/apuntes-publicos.json` y todavía no subirlo dejó
   `IISE: SIN PUBLICAR en Drive` — el rojo que hace creíble al verde de después.
3. La entrada de `no-se-publican` traía escrito su propio criterio de salida
   («pasa a `apuntes` cuando estén escritas las 7 unidades»), y se cumplió sin
   discutirlo: la decisión estaba tomada de antemano, no en caliente.

## Lo que la fase 5 (figuras) dejó medido

1. **Siete figuras nuevas, y cinco candidatas descartadas.** Se miró cada PNG
   antes de decidir: la foto del Falcon 9 en el hangar no enseña nada, dos
   diapositivas son separadores de sección que el extractor marca como figura
   porque casi no tienen texto, el esquema de niveles N+1/N/N−1 ya estaba
   dibujado en Typst (mejor que la foto) y precisión-contra-exactitud no
   colgaba de ningún texto del apunte. **El descarte es la mitad del trabajo.**
2. **El extractor tenía un punto ciego con forma de virtud.** Exportaba PNG de
   las diapositivas con menos de 150 caracteres, que descubre solo las que son
   puro diagrama — y deja afuera justo las más didácticas, las que tienen el
   diagrama *y sus rótulos*. Cuatro de las siete elegidas estaban de ese lado.
   Se agregó `extraer-clases.py --pagina cN:pM`.
3. **Dos defectos de maquetación atrapados mirando la página** (regla propia 4):
   una figura sola al final de un módulo con media página en blanco, y otra al
   97% de ancho que empujaba su tabla a la página siguiente. Las dos veces el
   PDF compiló en verde.
4. **La unidad 2 dejó de ser la única sin ninguna figura.** Las unidades 1 y 3
   siguen con figuras dibujadas en Typst, no fotográficas, y así está bien.

## Qué sigue

**Nada.** El proyecto está cerrado. Si la cátedra cambia algo o aparece un
defecto en una página, se toca el módulo, se recompila, se corren los dos
verificadores y se vuelve a publicar.
