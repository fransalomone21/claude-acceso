# HANDOFF — Apunte de IISE

Última sesión: **2026-09-20**. Escribió la unidad 5 completa (M15–M18), la
más densa en léxico del apunte hasta ahora: ciclo de vida de NASA y diagrama
en V, qué es un requerimiento con sus dos casos (MCO malo, DC-3 bueno) y
gestión de márgenes a fondo, la familia de requerimientos con trazabilidad
de 6 niveles, y verificación/validación a fondo con los 7 elementos del
alcance. Cumplió las dos promesas que las unidades 1 y 4 habían dejado
abiertas (V&V y márgenes a fondo).

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
- **El glosario de las unidades 1 a 5.** Ya están escritos (52 términos en
  total). **El de la unidad 6 NO está** — entra junto con sus módulos.
- **Desarrollar V&V ni márgenes "a fondo".** Las dos promesas se cumplieron
  en la unidad 5 (M16 y M18). Si un módulo nuevo necesita mencionarlas, se
  referencia esos módulos — no se vuelven a desarrollar.

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

## Cómo embeber una figura real (desde la unidad 3)

La mayoría de las figuras se reconstruyen como tabla o diagrama Typst. Pero
cuando el diagrama EN SÍ es el contenido —un diagrama de flujo, una foto real
de hardware—, se embebe la imagen:

1. Copiar el PNG de `fuentes/figuras/cNN-pMMM.png` a `apunte/figuras/`
   (carpeta plana, sin subcarpetas por unidad). **Esta carpeta SÍ se
   commitea** — a diferencia de `fuentes/figuras/`, que no.
2. En el módulo: `#image("../figuras/cNN-pMMM.png", width: 92%)` dentro de
   `#figure(..., caption: [...])`.
3. **Nunca** `../../fuentes/figuras/...`: Typst sandboxea el proyecto a la
   carpeta de `apunte.typ`, y una ruta que sale de ahí falla con
   `would escape the project root`.
4. **Elegir la foto real por sobre el render genérico**, cuando hay las dos.
   En la unidad 5 la diapositiva 44 traía un render CGI del CEV/Orion
   ilustrando el acople Apollo (anacrónico) y la 35 traía la foto real del
   hardware de acople del Programa Apollo — se usó la 35.

## Trampas ya pagadas

- **Una plantilla copiada trae el CONTENIDO del proyecto viejo**, no sólo el
  estilo, y compila igual de verde.
- **Tabla Typst: nunca `auto` si una columna tiene texto largo.** Van
  fracciones explícitas.
- **Una tabla puede compilar en verde con una columna vacía de más** — pasó
  en la unidad 2 (M06, Tabla 2.3): header con `[]` de sobra. Sólo se ve
  mirando la página renderizada.
- **Un encabezado de tabla largo en una columna angosta se corta en dos
  líneas feas, aunque las fracciones sean explícitas** — pasó en la unidad 5
  (M16, tabla de márgenes): "Margen de masa que se mantiene" partido en dos
  renglones. La fracción explícita evita el colapso de la regla propia 7,
  pero no evita un mal salto de línea en un encabezado largo — para eso hay
  que acortar el texto o agrandar la columna, y sólo se ve mirando la
  página.
- **Una palabra con guión propio ("termo-vacío") puede partirse en un salto
  de línea y mostrar un guión doble** ("termo- / -vacío") al justificar —
  pasó en la unidad 5. Se resolvió usando el término sin guión ya
  establecido en un módulo anterior ("cámara de vacío térmico", de M13) en
  vez de inventar una variante nueva — dos beneficios en un solo cambio:
  consistencia terminológica y sin riesgo de partido feo.
- **Una caja `#deduccion(titulo)` ya antepone "De dónde sale — " al título.**
  Pasó en la unidad 4 (M13): titular la caja "de dónde sale la fórmula..."
  dejó el texto impreso como "DE DÓNDE SALE — DE DÓNDE SALE LA FÓRMULA...",
  duplicado. El título que se le pasa a `#deduccion()`, `#definicion()`,
  etc. es sólo el COMPLEMENTO, nunca repite el prefijo de la caja.
- **`#ejemplo(titulo, cuerpo, nivel: "a-fondo")` lleva el argumento nombrado
  ANTES del bloque de contenido en corchetes**, no después: `#ejemplo("t",
  nivel: "a-fondo")[cuerpo]`, nunca `#ejemplo("t")[cuerpo][nivel: "..."]` —
  esto último son dos bloques de contenido, no un argumento nombrado.
- **Una excepción de léxico legítima existe y hay que declararla, no
  evitarla.** En la unidad 5, los nombres de documentos estándar URD/SRD
  ("Requisitos de Usuario/Software") citan el término tal como aparece en la
  diapositiva de la cátedra — es el nombre propio de un documento de la
  industria, no una elección de palabra evitable. Se declaró con
  `// lexico-ok` en la misma línea, en vez de reescribir la sigla o evitar
  citarla.
- **Una cita heredada de una sesión anterior también puede estar mal.** El
  glosario traía «tabla N², clase 2, diapositiva 31» (era la sección de
  Emergentes). Se corrigió a diapositiva 71/73, verificado contra las
  imágenes. La regla propia 2 no es sólo para diapositivas nuevas.
- **Un `#image()` con ruta fuera de la carpeta de `apunte.typ` no compila**
  (`would escape the project root`) — ver la sección de arriba.
- **Las listas de términos de Typst (`/ item`) necesitan los dos puntos en la
  MISMA línea** que el término, o el error es `expected colon` y apunta al
  final del párrafo.
- **No escribir scripts con heredoc.** Usar Write y correr con `python <ruta>`.
- **`rclone` NO se invoca crudo con `%APPDATA%`.** El config vive en
  `$env:USERPROFILE\.config\rclone\rclone.conf`.
- **Los `.txt` se escriben en UTF-8 y se leen así.** La consola de Windows es
  cp1252: los `?` en pantalla no significan que el PDF esté mal.
- **El modo de permisos de la sesión puede quedar en "Aceptar ediciones" en
  vez de "Omitir permisos" aunque esa sea la decisión tomada.** La sesión lo
  corrige sola con `mcp__ccd_session_mgmt__set_session_permission_mode(mode:
  "bypassPermissions", session_id: "self")` al notar el primer permiso
  pedido de más. Ya registrado como lección de proceso en `perfil-global`.

## Lo que quedó abierto

1. **Las unidades 6 y 7.** Una sesión por unidad, en orden. La unidad 6
   (familia de requerimientos, interfaces, modelos de ciclo de vida —
   módulos M19–M22) es la que sigue: 155 diapositivas, la más grande de las
   tres que quedan, y con 67 figuras según el PDP — probablemente necesite
   más de cuatro módulos o módulos más largos que el promedio.
2. **El glosario de las unidades 6 y 7**, junto con sus módulos.
3. **La publicación al Drive** (fase 4): el PDF todavía no está declarado en
   `.claude/apuntes-publicos.json`. Con 5 de 7 unidades escritas (83
   páginas), cada vez más cerca de valer la pena — a criterio de Fran, no
   decisión automática de la sesión.
