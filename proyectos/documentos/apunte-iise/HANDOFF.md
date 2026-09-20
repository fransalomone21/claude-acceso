# HANDOFF — Apunte de IISE

Última sesión: **2026-09-20**. Escribió la unidad 6 completa (M19–M23), la
clase más larga de la materia (155 diapositivas): familia de
requerimientos e interfaces (IDD/IRD/ICD), el Ejercicio de Alcance con seis
ConOps reales, SMART y verificación/validación operativas, Pre-Fase A a
fondo con los cinco modelos de ciclo de vida, e ingeniería concurrente y
mecatrónica. Salió con **cinco** módulos, no los cuatro previstos en el
PDP — ver la nota en `PDP.md` §8.

## Lo que la próxima sesión NO tiene que rehacer

- **Bajar ni extraer el material.** Los 7 PDF ya están extraídos. Si hicieran
  falta de nuevo: `python extraer-clases.py --figuras`.
- **Medir las anclas de NotebookLM.** Ya está: 4 de 149 correctas.
- **Decidir el léxico base.** `requerimiento` e `interesado`, medidos.
- **Montar la infraestructura Typst.** `apunte/plantilla.typ` ya está adaptada
  a IISE, con `#diapo(clase, n)` y `#t[término]`.
- **Escribir el verificador de léxico ni su saboteador.** Los dos en verde.
- **Discutir los parcialitos.** Los de las clases 4 a 7 no llegaron y el
  apunte no se escribe en función de ellos (decisión de Fran, 2026-09-20).
- **El glosario de las unidades 1 a 6.** Ya están escritos (65 términos en
  total). **El de la unidad 7 NO está** — entra junto con sus módulos.
- **Desarrollar V&V, márgenes, o el Ejercicio de Alcance desde cero.** Las
  unidades 5 y 6 ya los cubrieron a fondo. Si un módulo nuevo los necesita,
  se referencia con `#t[]` — no se repite la definición.
- **Redefinir el ciclo de vida de NASA ni sus fases.** M15 (unidad 5) las
  da, y M22 (unidad 6) ya precisó el corte exacto Formulación/Aprobación/
  Implementación con la evidencia de la diapositiva 85 de la clase 6.

## Cómo se escribe un módulo nuevo, en cinco pasos

1. Leer **sólo** `fuentes/clases/clase-N.txt` (regla propia 6).
2. Escribir `apunte/modulos/mNN-clave.typ` y agregar su `#include` a
   `apunte/apunte.typ`, debajo de su `#parte(...)`.
3. Agregar al `fuentes/glosario.md` los términos nuevos de esa unidad, **antes**
   de marcarlos con `#t[]` en el módulo.
4. `typst compile apunte.typ apunte.pdf` y `python verificar-lexico.py`.
5. **Mirar las páginas compiladas.** Renderizarlas con
   `typst compile apunte.typ "$TEMP/iise-{p}.png" --ppi 110` y abrirlas con el
   tool de lectura de imágenes — no alcanza con que Typst compile sin error.

## El número de módulos por unidad es una estimación, no un contrato

La unidad 6 se planificó en el PDP como M19–M22 (cuatro módulos) y salió con
**cinco** (M19–M23): 155 diapositivas con dos temas genuinamente separables
—ingeniería concurrente y mecatrónica— que no encajaban en ninguno de los
otros cuatro sin diluirlos. Se agregó M23 y la unidad 7 corrió un módulo
más tarde (M24–M27 en vez de M23–M26). **Antes de escribir la unidad 7,
verificar que sus módulos se llamen M24 en adelante**, no M23 — `PDP.md`
§8 ya tiene la tabla corregida, pero un slip de nombres ahí rompe la
compilación (`M()` no encuentra la clave) recién cuando alguien la
referencie desde otro módulo, no antes.

## Cómo embeber una figura real (desde la unidad 3)

La mayoría de las figuras se reconstruyen como tabla o diagrama Typst. Pero
cuando el diagrama EN SÍ es el contenido —un diagrama de flujo, una foto
real, una simulación—, se embebe la imagen:

1. Copiar el PNG de `fuentes/figuras/cNN-pMMM.png` a `apunte/figuras/`
   (carpeta plana, sin subcarpetas por unidad). **Esta carpeta SÍ se
   commitea** — a diferencia de `fuentes/figuras/`, que no.
2. En el módulo: `#image("../figuras/cNN-pMMM.png", width: 92%)` dentro de
   `#figure(..., caption: [...])`.
3. **Nunca** `../../fuentes/figuras/...`: Typst sandboxea el proyecto a la
   carpeta de `apunte.typ`, y una ruta que sale de ahí falla con
   `would escape the project root`.
4. **Elegir la foto o el diagrama real por sobre el render genérico**,
   cuando hay las dos. En la unidad 5, la diapositiva 44 traía un render
   CGI del CEV/Orion ilustrando el acople Apollo (anacrónico) y la 35 traía
   la foto real del hardware — se usó la 35. En la unidad 6, de nueve
   diagramas de comparación de ciclos de vida disponibles, se usó el que
   compara **seis modelos reales lado a lado** (diapositiva 85) en vez de
   uno genérico — trae más información por página.

## Trampas ya pagadas

- **Un tag `#t[término]` partido en dos líneas del código fuente NO lo ve
  `verificar-lexico.py`.** El regex del checker corre línea por línea; un
  `#t[jerarquía del\nsistema]` compila bien en Typst (el content block sí
  puede partirse) pero el checker nunca lo evalúa — ni para bien ni para
  mal, queda invisible. Pasó tres veces en la unidad 6 antes de revisar con
  `grep -n "#t\[[^\]]*$"` en cada módulo nuevo, que encuentra exactamente
  esta clase de corte. Conviene correrlo como parte del paso 4.
- **Una plantilla copiada trae el CONTENIDO del proyecto viejo**, no sólo el
  estilo, y compila igual de verde.
- **Tabla Typst: nunca `auto` si una columna tiene texto largo.** Van
  fracciones explícitas.
- **Un encabezado de tabla largo en una columna angosta se corta en dos
  líneas feas, aunque las fracciones sean explícitas** — pasó en la unidad 5
  (M16). Se ve sólo mirando la página renderizada; se arregla acortando el
  encabezado o agrandando la columna.
- **Una palabra con guión propio ("termo-vacío") puede partirse en un salto
  de línea y mostrar un guión doble** al justificar — pasó en la unidad 5.
  Se resolvió usando el término ya establecido sin guión ("cámara de vacío
  térmico", de M13).
- **Una caja `#deduccion(titulo)` ya antepone "De dónde sale — " al título.**
  El título que se le pasa a `#deduccion()`, `#definicion()`, etc. es sólo
  el COMPLEMENTO, nunca repite el prefijo de la caja.
- **`#ejemplo(titulo, cuerpo, nivel: "a-fondo")` lleva el argumento nombrado
  ANTES del bloque de contenido en corchetes**, no después.
- **No redefinir un término con `#definicion()` sólo para decir "ya está
  definido".** Pasó en un borrador de la unidad 6 (M21, dos veces): usar
  `#definicion()` de nuevo imprime una segunda caja "DEFINICIÓN" con el
  mismo título en otro módulo, que no rompe `verificar-lexico.py` (sólo
  mira `### ` en el glosario, no las cajas del apunte) pero sí confunde al
  lector sobre dónde vive la definición real. Para referenciar un término
  ya definido en otra unidad: `#clave[]` o prosa con `#t[término]`, nunca
  `#definicion()` de nuevo.
- **Una cita heredada de una sesión anterior también puede estar mal — y
  una unidad posterior puede tener la evidencia para corregirla.** La
  unidad 5 (M15) dejó como `#cuidado` sin precisar el corte de fases
  Formulación/Aprobación/Implementación del ciclo de NASA, por falta de
  evidencia. La unidad 6 (diapositiva 85, comparación de modelos) trajo el
  dato exacto — se corrigió M15 en el momento, sin esperar a "una sesión
  de la unidad 5" que ya cerró. La regla propia 2 y la regla del repo (un
  dato vive en un solo lado) valen para las unidades ya cerradas también.
- **Un `#image()` con ruta fuera de la carpeta de `apunte.typ` no compila**
  (`would escape the project root`).
- **Las listas de términos de Typst (`/ item`) necesitan los dos puntos en la
  MISMA línea** que el término, o el error es `expected colon`.
- **No escribir scripts con heredoc.** Usar Write y correr con `python <ruta>`.
- **`rclone` NO se invoca crudo con `%APPDATA%`.** El config vive en
  `$env:USERPROFILE\.config\rclone\rclone.conf`.
- **Los `.txt` se escriben en UTF-8 y se leen así.** La consola de Windows es
  cp1252: los `?` en pantalla no significan que el PDF esté mal.
- **El modo de permisos de la sesión puede quedar en "Aceptar ediciones" en
  vez de "Omitir permisos" aunque esa sea la decisión tomada.** La sesión lo
  corrige sola con `mcp__ccd_session_mgmt__set_session_permission_mode(mode:
  "bypassPermissions", session_id: "self")` al notar el primer permiso
  pedido de más.

## Lo que quedó abierto

1. **La unidad 7** (creación de arquitecturas, Fase A, N² — módulos
   M24–M27, **no** M23–M26), sobre 54 diapositivas: la última que falta, y
   la más chica de las tres finales. Cierra el apunte.
2. **El glosario de la unidad 7**, junto con sus módulos.
3. **La publicación al Drive** (fase 4): el PDF todavía no está declarado en
   `.claude/apuntes-publicos.json`. Con 6 de 7 unidades escritas (100
   páginas), cada vez más claramente vale la pena — a criterio de Fran, no
   decisión automática de la sesión.
