# `pilares/` — los libros que sostienen el método

Un libro no entra al perfil leyéndolo. Entra **destilado**, en tres capas, y
sólo la primera se lee sola. Esta carpeta es donde vive ese proceso.

La razón es de contexto, no de pereza: un libro son cientos de miles de
tokens. No entra en una ventana, y aunque entrara, cargarlo en cada sesión
sería pagar el libro entero para usar cinco reglas. El destilado es la parte
que cambia decisiones; el libro es de dónde salió.

## Las tres capas

| Capa | Qué es | Dónde | Cuándo entra |
|---|---|---|---|
| Pilar | 5-10 reglas operativas, en imperativo | foldeado en `chequeo-de-trabajo.md` y/o `CLAUDE.md` | **sola**, en cada sesión |
| Ficha | 200-400 líneas: los conceptos que cambian decisiones, con el ejemplo que los hace reconocibles | `pilares/<libro>.md` | cuando el tema aparece |
| Fuente | el libro | `pilares/fuentes/` o su ruta en la máquina | cuando hace falta la cita exacta |

**El precedente ya está en el repo y funcionó:**
`engineering-orchestrator/referencias/ingenieria-de-sistemas.md` es NASA
SP-2016-6105 + NPR 7123.1 + NPR 7150.2 + Power of Ten destilados a 267 líneas,
y el pilar son los **8 puntos** que quedaron en el cuerpo de la skill bajo
"lo mínimo que cambia decisiones". Ese es el formato objetivo.

## El protocolo, y por qué es un libro por sesión

1. **Un libro por chat.** Dos libros en una ventana garantizan que el resumen
   se lleve puesto justo lo que no se puede aproximar. Es la misma regla del
   cuadro de fase aplicada al estudio.
2. **La ficha se escribe incremental**, cada ~100 páginas, no al final. Si la
   ventana se agota a mitad, lo leído hasta ahí queda. Checkpoint temprano.
3. **Cada regla del pilar lleva su ancla**: capítulo o página. Sin eso, en dos
   meses no se puede volver a chequear de dónde salió.
4. **El filtro de qué entra al pilar es uno solo: ¿cambia una decisión?** Un
   concepto que se entiende y no cambia nada de cómo se trabaja es cultura
   general, va a la ficha y no sube. El chequeo se lee en cada sesión: cada
   línea que se agrega se paga siempre.
5. **Al cerrar el libro**: foldear el pilar, correr `install.ps1` (avisa si el
   chequeo quedó atrasado), commit y push.

## Qué NO hacer

- **No pegar el libro en el chat.** Se pasa la ruta del archivo y se lee por
  rangos de página.
- **No resumir capítulo por capítulo.** Un resumen fiel del libro no sirve:
  lo que sirve es la regla operativa. La pregunta no es "qué dice este
  capítulo" sino "qué haría distinto mañana si me lo creo".
- **No subir al pilar lo que ya está.** Si el libro dice algo que el perfil ya
  hace, va en la ficha como respaldo —"esto que ya hacíamos se llama X y la
  razón es Y"— y no se duplica arriba. Es la lección 26.

## Estado

| Libro | Ficha | Pilar foldeado | Fuente |
|---|---|---|---|
| **Leverage Points** (Meadows, 1999, 21 pp.) | [`leverage-points.md`](leverage-points.md) | sí — 4 líneas en `pilares.md` | `~/Downloads/Leverage_Points.pdf` |
| **Thinking in Systems** (Meadows, 2008, 235 pp.) | [`thinking-in-systems.md`](thinking-in-systems.md) | sí — 6 líneas en `pilares.md` | `~/Downloads/Meadows-2008.-Thinking-in-Systems.pdf` |
| **The Pragmatic Programmer** (Hunt & Thomas, 1999, 348 pp., ed. brasileña de la 1ª ed.) | [`pragmatic-programmer.md`](pragmatic-programmer.md) | sí — 7 líneas en `pilares.md` | `~/Downloads/o-programador-pragmatico.pdf` |

Los tres libros del Nivel 0 están leídos y foldeados. Lo que queda de esta
capa es **integrarla dentro de `CLAUDE.md`**, que era la tarea que esperaba a
tener los tres — no antes.

El destilado vive en `perfil-global/pilares.md` (ASCII), que es **Nivel 0** y
lo inyecta su propio hook `SessionStart`. Esta carpeta guarda las fichas
largas, que se leen bajo demanda.

## Cómo se leen los PDF acá

El `Read` nativo renderiza páginas y necesita `pdftoppm`, que **no está** en
esta máquina. No hace falta: `PyMuPDF` sí está, y extraer texto cuesta ~10x
menos contexto que renderizar.

```python
import fitz                       # PyMuPDF
d = fitz.open(ruta_pdf)
txt = "".join("\n\n===== PAGINA %d =====\n" % i + p.get_text()
              for i, p in enumerate(d, 1))
```

Y el **control positivo antes de leer** (lección 14): buscar en el texto
extraído algo que tiene que estar sí o sí —el título, los encabezados
numerados, el índice—. Si no aparece, lo que falló es la extracción y todavía
no sabés nada del libro.

Dos cosas que ya costaron viajes de más y que en el libro 3 van a costar más,
porque *The Pragmatic Programmer* está en edición portuguesa y viene lleno de
no-ASCII:

1. **La consola de esta máquina es cp1252: `print` del texto extraído explota.**
   No con acentos —con las **ligaduras tipográficas** que mete el PDF: `ﬁ`,
   `ﬂ`, `ﬀ`. El error es `UnicodeEncodeError: 'charmap' codec can't encode
   character 'ﬁ'`, y sale a mitad de la impresión, así que parece que
   falló la extracción y no la salida. Normalizar a ASCII antes de imprimir:

   ```python
   import unicodedata
   MAPA = {'ﬀ': 'ff', 'ﬁ': 'fi', 'ﬂ': 'fl',
           'ﬃ': 'ffi', 'ﬄ': 'ffl',
           '‘': "'", '’': "'", '“': '"', '”': '"',
           '–': '-', '—': '--', '…': '...', ' ': ' '}
   for k, v in MAPA.items():
       s = s.replace(k, v)
   s = unicodedata.normalize('NFKD', s).encode('ascii', 'ignore').decode()
   ```

2. **No transportes el texto por stdout del shell.** Tiene tope: arriba de
   ~30 KB te devuelve "Output too large" y te guarda un archivo que igual hay
   que abrir con la herramienta de lectura — un viaje de más por cada tramo.
   Escribí el rango a archivo y leelo con la herramienta de leer, o dimensioná
   el tramo en ~20 páginas antes del primer intento. (Lección 33.)

**Ancla de páginas:** anotar en la ficha el offset entre la página del PDF y la
del libro impreso (en Meadows 2008 es `PDF = libro + 17`). Las anclas de la
ficha van con el número **del libro**, que es el que se puede chequear después.
