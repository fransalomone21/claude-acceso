---
name: pdf-con-codigo
description: Generar cualquier PDF (apuntes, informes, documentos con fórmulas, tablas o gráficos) escribiendo código y compilando, en vez de editar manualmente. Cubre qué herramienta usar (Typst por defecto), chequeo e instalación del entorno, el flujo extraer-escribir-compilar-verificar, las trampas de sintaxis ya pagadas, y cómo verificar visualmente el resultado antes de darlo por terminado. Usar siempre que el pedido sea "generame un PDF", "armá un apunte/informe en PDF", o cualquier documento que vaya a tener ecuaciones, tablas o gráficos.
---

# PDF con código

Todo PDF se genera con código fuente que se compila — nunca editando un PDF
existente a mano, nunca "dictando" contenido sin pasar por un archivo de
texto versionable. La razón de fondo: un PDF generado por código es
reproducible (se puede volver a compilar), verificable (el compilador avisa
errores de sintaxis con línea exacta) y corregible con `Edit` en vez de
regenerar todo desde cero.

## Herramienta por defecto: Typst, no LaTeX

Probado en la práctica (apunte de física de 11 páginas con ecuaciones,
tablas y cajas de alerta, compilado y verificado en la misma sesión):

- Compila en menos de 1 segundo — permite iterar por prueba y error sin
  costo.
- Matemática nativa sin paquetes: fracciones automáticas con `a/b`, símbolos
  griegos como palabras (`gamma`, `alpha`, `Delta`), sin preámbulo.
- `#outline()` da índice automático; `#set heading(numbering: "1.1")` numera
  las secciones solo.
- Errores de compilación traen número de línea exacto y una sugerencia
  accionable — no hay que adivinar qué se rompió.

LaTeX queda como alternativa solo si hace falta un paquete o un estilo muy
específico que Typst no tenga. Si no hay una razón concreta para eso, usar
Typst.

## Antes de escribir una línea: chequear el entorno

No asumir que las herramientas están instaladas — chequear, e instalar lo
que falte antes de empezar el contenido:

```bash
typst --version          # si falta: winget install --id Typst.Typst (Windows) / brew install typst (Mac) / paquete typst del gestor de Linux
python -c "import fitz"  # pymupdf — si falta: pip install pymupdf
```

`pymupdf` hace falta para dos cosas: extraer texto de PDFs fuente grandes, y
renderizar páginas del PDF de salida para verificarlo visualmente (ver más
abajo). No es opcional.

**Hallazgo de esta máquina (Windows, sin poppler instalado):** la
herramienta `Read` con el parámetro `pages` sobre un PDF depende de
poppler/`pdftoppm`, que acá no está instalado, y falla. No perder tiempo
reintentando `Read` con `pages` después del primer fallo — pivotar directo a
`pymupdf` (abajo). Si en otra máquina `Read` con `pages` sí funciona, usarlo
tranquilamente; esto es un dato del entorno, no una regla universal de
Typst.

## Flujo de trabajo

**1. Si hay que extraer contenido de PDFs fuente grandes** (libros,
capítulos largos), no releer el PDF original cada vez — volcar el texto
completo una sola vez a un `.txt` con marcadores de página, y trabajar sobre
ese archivo con `Read`/`Grep`:

```python
import fitz  # pip install pymupdf
doc = fitz.open("fuente.pdf")
with open("fuente_texto.txt", "w", encoding="utf-8") as f:
    for i in range(doc.page_count):
        f.write(f"\n=== PDF PAGE {i+1} ===\n")
        f.write(doc.load_page(i).get_text())
```

Los marcadores de página permiten citar la página exacta de cada afirmación
después, y ubicar rápido una sección buscando su encabezado con `Grep` en
vez de releer el libro entero.

Si el PDF fuente es grande y hay que extraer de más de una fuente
independiente a la vez, delegar cada extracción a un subagente en paralelo
(`Agent`, no `Workflow` — esto es una delegación simple, no una orquestación
de varias fases) protege el contexto propio de quedar lleno de texto
intermedio que no hace falta conservar.

**2. Escribir el `.typ` directo** con `Write`/`Edit`. No hay "modo
interactivo" para Typst: es código de punta a punta.

**3. Compilar:**

```bash
typst compile archivo.typ archivo.pdf
```

Chequear el exit code Y el stderr — un compile exitoso no imprime nada;
cualquier texto en stderr es un error real que hay que resolver antes de
seguir.

**4. Iterar rápido.** Cada error da número de línea exacto: usar `Edit`
sobre esa línea puntual y recompilar. No reescribir el archivo entero de
nuevo por un error de sintaxis.

**5. Verificar visualmente — siempre, sin excepción.** Un compile en verde
no alcanza: hay bugs de layout (ver más abajo) que el compilador no
reporta como error porque sintácticamente son válidos. Renderizar 3-6
páginas representativas (portada, índice, una página densa en ecuaciones,
una tabla si hay, la última página) y leerlas:

```python
import fitz
doc = fitz.open("archivo.pdf")
for i in [0, 1, 4, doc.page_count - 1]:   # elegir páginas representativas del documento real
    doc.load_page(i).get_pixmap(dpi=150).save(f"check_p{i+1}.png")
```

Después leer cada PNG con la herramienta `Read` de imágenes. Esto es lo que
agarra lo que el compilador no puede ver.

## Trampas de sintaxis de Typst (cada una costó un ciclo de error real)

- **Subíndices o superíndices de más de un carácter que sean letras**
  necesitan comillas, o Typst los busca como variable y tira
  `unknown variable`: `v_("esc")` es correcto, `v_(esc)` falla porque
  intenta resolver el identificador `esc`. Un solo carácter o un número no
  necesita comillas: `v_1`, `v_A` están bien.
- **`$ expr $` (espacio pegado a los dos `$`) es ecuación en bloque**
  (centrada, en su propia línea). `$expr$` (sin espacios) es inline. Usar la
  forma en bloque a mitad de oración, con texto o puntuación pegados
  inmediatamente después del `$` de cierre, deja esa puntuación huérfana en
  su propia línea. Separar la oración antes del bloque, o usar la forma
  inline si el texto tiene que seguir fluyendo.
- **No hace falta escapar `&`** como en LaTeX — `\&` imprime literalmente
  una barra invertida visible en el PDF. Escribir `&` directo, tanto en
  texto normal como dentro de strings en modo matemático.
- `abs(x)` es función nativa para valor absoluto `|x|`.
- Las fracciones son automáticas con `/` en modo matemático (`a/b`);
  agrupar con paréntesis si numerador o denominador tienen más de un
  término: `(a+b)/(c+d)`.

## Qué mirar específicamente al verificar visualmente

- Ecuaciones con `unknown variable` — el compile ya lo hubiera atajado, pero
  confirmar que no quedó ningún subíndice sin comillas que "compiló bien"
  de casualidad (coincide con un símbolo nativo de Typst).
- Puntuación huérfana después de una ecuación en bloque a mitad de oración.
- Páginas casi en blanco por un `#pagebreak()` puesto justo después de un
  bloque que ya desbordaba a la página siguiente (típico después de un
  índice largo) — revisar si el salto de página hace falta o si conviene
  dejar que el contenido fluya solo.
- Tablas: que las columnas no se corten, que el texto largo haga wrap en vez
  de desbordar el margen.
- Cajas de alerta o callouts con color de fondo: contraste de texto legible,
  y que el bloque no se parta feo justo en un salto de página.
- **Referencias cruzadas de texto plano** (`§X.Y` u otro patrón manual, no el
  `<etiqueta>`/`@etiqueta` nativo de Typst): el compilador no las valida —son
  strings comunes. Si un heading se agrega, se borra o se reordena, cada
  referencia manual puede quedar apuntando a un número que ya no es el que
  Typst renderizó. Antes de cerrar, grepear todas las ocurrencias del patrón
  y cruzarlas contra el índice/outline real, sección por sección — no contra
  el conteo mental de qué parte ocupa cada una (ver lección 17 de
  `/lecciones-aprendidas`).

## Gráficos y plots

Sin probar en profundidad todavía (la primera sesión que usó esta skill fue
solo texto, fórmulas y tablas) — documentado como punto de partida, no como
receta cerrada:

- **Diagramas hechos a mano** (circuitos, esquemas): paquete Typst `cetz`
  (`#import "@preview/cetz:..."`) dibuja vectorial nativo dentro del propio
  documento. Ya usado en este mismo repo, rama
  `claude/manual-analogica-tr0mk6` — ver
  `electronica-analogica/apunte/biblioteca/graficos.typ` y `circuitos.typ`
  como referencia de patrones ya probados en este entorno antes de
  reinventar algo parecido.
- **Gráficos de datos** (curvas, funciones, resultados numéricos):
  generarlos con Python (matplotlib) exportados como SVG o PDF vectorial —
  no PNG, para que no pixelen al hacer zoom o imprimir — y embeberlos con
  `#image("plot.svg")`. Alternativa nativa: paquete Typst `lilaq`.
- Regla general: vectorial (SVG/PDF) para cualquier gráfico que vaya a
  imprimirse o hacer zoom. Raster (PNG) queda reservado para las capturas de
  verificación visual del propio flujo de trabajo — esas son para que el
  modelo las lea, no para el documento final.

## Estilo de contenido

Cada concepto o ecuación necesita una explicación directa en palabras
llanas de qué significa y cómo se usa — la fórmula sola, con solo una cita
de página, no sirve como material de estudio ni como informe legible. Citar
la fuente exacta (libro, capítulo, ecuación, página) da trazabilidad, pero
no reemplaza la explicación.
