# HANDOFF — Apunte de IISE

Última sesión: **2026-09-20**. Cerró la fase 1 y escribió la unidad 0 y la
unidad 1 del apunte.

## Lo que la próxima sesión NO tiene que rehacer

- **Bajar ni extraer el material.** Los 7 PDF ya están extraídos. Si hicieran
  falta de nuevo: `python extraer-clases.py --figuras`.
- **Medir las anclas de NotebookLM.** Ya está: 4 de 149 correctas.
- **Decidir el léxico base.** `requerimiento` e `interesado`, medidos.
- **Montar la infraestructura Typst.** `apunte/plantilla.typ` ya está adaptada
  a IISE (portada, encabezado y pie propios) y tiene los dos helpers nuevos:
  `#diapo(clase, n)` para citar y `#t[término]` para marcar léxico controlado.
- **Escribir el verificador de léxico ni su saboteador.** Los dos en verde.
- **Discutir los parcialitos.** Decisión de Fran del 2026-09-20: los de las
  clases 4 a 7 no llegaron y **el apunte no se escribe en función de ellos**.
  Se sigue el patrón de lo que ya se midió —preguntas de definición— pero como
  apunte general, no como preparación de un parcialito concreto. La fase 3 del
  PDP se reinterpreta: valida contra **los parcialitos que sí están**, y no
  bloquea nada.

## Cómo se escribe un módulo nuevo, en cinco pasos

1. Leer **sólo** `fuentes/clases/clase-N.txt` (regla propia 6).
2. Escribir `apunte/modulos/mNN-clave.typ` y agregar su `#include` a
   `apunte/apunte.typ`, debajo de su `#parte(...)`.
3. Agregar al `fuentes/glosario.md` los términos nuevos de esa unidad, **antes**
   de marcarlos con `#t[]` en el módulo.
4. `typst compile apunte.typ apunte.pdf` y `python verificar-lexico.py`.
5. **Mirar las páginas compiladas.** Renderizarlas con
   `typst compile apunte.typ "$TEMP/iise-{p}.png" --ppi 110` y abrirlas. Este
   paso encontró dos defectos reales que compilaban en verde.

## Trampas ya pagadas

- **Una plantilla copiada trae el CONTENIDO del proyecto viejo**, no sólo el
  estilo, y compila igual de verde. La portada de este apunte habló de Beer y
  de mecánica orbital hasta que alguien miró la página 1.
- **Tabla Typst de 3 columnas: nunca `auto` si una columna tiene texto largo.**
  Colapsa las otras a una letra por renglón, sin warning. Van fracciones
  explícitas.
- **Las listas de términos de Typst (`/ item`) necesitan los dos puntos en la
  MISMA línea** que el término, o el error es `expected colon` y apunta al
  final del párrafo, no al principio.
- **No escribir scripts con heredoc.** El guardia lo niega y tiene razón: se
  escriben con la herramienta Write y se corren con `python <ruta>`.
- **`rclone` NO se invoca crudo con `%APPDATA%`.** El config vive en
  `$env:USERPROFILE\.config\rclone\rclone.conf`.
- **Los `.txt` se escriben en UTF-8 y se leen así.** La consola de Windows es
  cp1252: los `?` en pantalla no significan que el PDF esté mal.

## Lo que quedó abierto

1. **Las unidades 2 a 7.** Una sesión por unidad, en orden. La 2 es la más
   grande en diapositivas (97) y la 6 la más grande en figuras (67).
2. **El glosario de las unidades 4 a 7**, que entra junto con sus módulos.
3. **La publicación al Drive** (fase 4): el PDF todavía no está declarado en
   `.claude/apuntes-publicos.json`. Hacerlo recién cuando haya algo que valga
   la pena compartir — hoy son 25 páginas de 7 unidades.
