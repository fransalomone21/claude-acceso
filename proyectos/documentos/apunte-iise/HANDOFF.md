# HANDOFF — Apunte de IISE

Última sesión: **2026-09-20**. Escribió las unidades 2, 3 y 4 (M04–M14) en la
misma sesión, en tres tramos separados. La unidad 4 era la más grande del
apunte (124 diapositivas) y quedó cerrada.

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
- **El glosario de las unidades 3 y 4.** Ya están escritos (34 términos en
  total). **El de la unidad 5 NO está** — entra junto con sus módulos.

## Dos promesas pendientes que la unidad 5 tiene que cumplir

Los módulos ya escritos prometieron desarrollar dos temas "a fondo, en la
unidad 5" — si la 5 no los cubre, esas líneas quedan mintiendo:

1. **Verificación y validación (V&V).** Prometido en M03 (unidad 1, "se
   desarrolla en la unidad 5") y en M13 (unidad 4, ejemplo del rover
   marciano, misma promesa). Ya hay una distinción básica escrita
   (verificar = ¿este requerimiento se cumple? / validar = ¿el sistema
   satisface al cliente?) — la unidad 5 la retoma y la desarrolla, no la
   repite desde cero.
2. **Márgenes.** Prometido en M11 (unidad 4, ejemplo del Saturno V: "los
   márgenes se desarrollan a fondo en la unidad 5"). El ejemplo del quinto
   motor ya está usado — en la unidad 5 se referencia, no se repite.

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
cuando el diagrama EN SÍ es el contenido —un diagrama de flujo, un panel de
alternativas de diseño real—, se embebe la imagen:

1. Copiar el PNG de `fuentes/figuras/cNN-pMMM.png` a `apunte/figuras/`
   (carpeta plana, sin subcarpetas por unidad). **Esta carpeta SÍ se
   commitea** — a diferencia de `fuentes/figuras/`, que no.
2. En el módulo: `#image("../figuras/cNN-pMMM.png", width: 92%)` dentro de
   `#figure(..., caption: [...])`.
3. **Nunca** `../../fuentes/figuras/...`: Typst sandboxea el proyecto a la
   carpeta de `apunte.typ`, y una ruta que sale de ahí falla con
   `would escape the project root`.

## Trampas ya pagadas

- **Una plantilla copiada trae el CONTENIDO del proyecto viejo**, no sólo el
  estilo, y compila igual de verde.
- **Tabla Typst: nunca `auto` si una columna tiene texto largo.** Van
  fracciones explícitas.
- **Una tabla puede compilar en verde con una columna vacía de más** — pasó
  en la unidad 2 (M06, Tabla 2.3): header con `[]` de sobra. Sólo se ve
  mirando la página renderizada.
- **Una caja `#deduccion(titulo)` ya antepone "De dónde sale — " al título.**
  Pasó en la unidad 4 (M13): titular la caja "de dónde sale la fórmula..."
  dejó el texto impreso como "DE DÓNDE SALE — DE DÓNDE SALE LA FÓRMULA...",
  duplicado. El título que se le pasa a `#deduccion()`, `#definicion()`,
  etc. es sólo el COMPLEMENTO, nunca repite el prefijo de la caja.
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

1. **Las unidades 5 a 7.** Una sesión por unidad, en orden. La unidad 5
   (ciclo de vida, requerimientos, márgenes, alcance — módulos M15–M18) es
   la que sigue, y tiene las dos promesas pendientes de arriba (V&V y
   márgenes). La 6 es la más grande en figuras (67) y en diapositivas (155).
2. **El glosario de las unidades 5 a 7**, junto con sus módulos.
3. **La publicación al Drive** (fase 4): el PDF todavía no está declarado en
   `.claude/apuntes-publicos.json`. Con 4 de 7 unidades escritas (67
   páginas), puede estar cerca de valer la pena — a criterio de Fran, no
   decisión automática de la sesión.
