# Las fuentes — dónde está cada libro en el disco

Los PDFs **no se copian al repo**: pesan cientos de MB y no son nuestros. Esta
tabla es el puntero. Medida contra el disco el 2026-08-30.

| Cita en el apunte | Libro | Ruta |
|---|---|---|
| S&Z vol. 1 | Young & Freedman, *Física universitaria con Física Moderna* Vol. 1 (Pearson, 2018) | `C:\Users\frans\Desktop\Mis Documentos\SistemasEspaciales\Libros de Fisica\Hugh D. Young_ Roger A. Freedman - Física universitaria_ con Física Moderna. 1-Pearson Educación (2018).pdf` |
| S&Z vol. 2 | ídem, Vol. 2 | `…\Libros de Fisica\Hugh D. Young_ Mark Waldo Zemansky_ … - Física universitaria con física moderna 2-Pearson Educación (2018).pdf` |
| Roederer | Roederer, *Mecánica elemental* (Eudeba, 2008) | `…\Libros de Fisica\Roederer, Juan G. - Mecánica elemental-Eudeba (2008).pdf` |
| Beer | Beer & Johnston, *Mecánica vectorial para ingenieros: Dinámica* | `…\Libros de Fisica\Beer_ Mec vectorial para ingenieros _ dinámica.pdf` |
| Bate | Bate, Mueller & White, *Fundamentals of Astrodynamics* (Dover, 1971) | `…\Libros de Fisica\Roger  R. Bate, … - Fundamentals of astrodynamics-Dover Publications (1971) (1).pdf` |
| Curtis | Curtis, *Orbital Mechanics for Engineering Students* (Elsevier, 2020) | `…\Libros de Fisica\(Elsevier Aerospace Engineering Series) Curtis, Howard D - Orbital mechanics for engineering students-Elsevier, Butterworth-Heinemann (2020).pdf` |

**Medido de nuevo el 2026-08-31: los seis libros ya están en `Libros de
Fisica`.** Antes esta tabla decía que Bate y Curtis vivían sólo en `Downloads`,
que es una carpeta que se limpia. Hoy:

- *Curtis* se **movió**: ya no está en `Downloads`.
- *Bate* se **copió**: hay uno en `Libros de Fisica` y dos en `Downloads` (el
  original y una copia `(1)`, idénticos en tamaño). El de `Libros de Fisica`
  es el que lleva el `(1)` en el nombre — un detalle que importa si se escribe
  la ruta a mano.

**Cómo abrirlos desde un script: no escribir la ruta a mano.** Los nombres
llevan acentos, y hay canales —el heredoc del Bash tool, sin ir más lejos— que
los reescriben: el script falla con «no such file» sobre un archivo que existe,
y el error apunta al código, que está bien. Se localiza el libro por glob:

```python
import glob, os
base = os.path.join(os.path.expanduser('~'), 'Desktop', 'Mis Documentos',
                    'SistemasEspaciales', 'Libros de Fisica')
p = [f for f in glob.glob(os.path.join(base, '*.pdf')) if 'Roederer' in f][0]
```

## Material de la cátedra (no libros)

| Qué | Ruta | Estado |
|---|---|---|
| Guía de problemas 2026 (17 pág.) | `C:\Users\frans\Downloads\PROBLEMAS FÍSICA ESPACIAL.pdf` | los enunciados largos son texto; los cortos son **imágenes** — se renderizan con PyMuPDF para leerlos |
| Plan de 17 semanas | `C:\Users\frans\Downloads\Plan Fisica E 26.docx` | transcripto en `TEMARIO.md` |
| Lista de temas — Conservación de P | `C:\Users\frans\Downloads\Lista de temas Conservación P (1).pdf` | transcripta en `TEMARIO.md` |
| Lista de temas — Gravitación | `C:\Users\frans\Downloads\Lista de temas Gravitación (1).pdf` | transcripta en `TEMARIO.md` |
| Lista de temas — Cuerpo rígido | `C:\Users\frans\Downloads\Temas de CR_2.docx` | transcripta en `TEMARIO.md` |
| Clase: potencial eficaz (manuscrito) | `C:\Users\frans\Downloads\potencial eficaz.pdf` y `potencial eficaz_2.pdf` | **escaneos**: no tienen capa de texto, se leen renderizados |
| Clase: problema equivalente y masa reducida (3 pág.) | `C:\Users\frans\Downloads\problema equivalente masa reducida_1.pdf` | ídem |
| Road Map de mecánica orbital | `C:\Users\frans\Downloads\Road Map.pdf` | es el **Apéndice B de Curtis**, escaneado, con `mu = G(m1+m2)` anotado a mano |

### Cómo leer un escaneo sin capa de texto

`pdftotext` devuelve vacío y el lector de PDF de la sesión necesita
`pdftoppm`, que no está instalado. El camino que funciona:

```bash
python -c "import pymupdf; d=pymupdf.open('archivo.pdf'); [p.get_pixmap(dpi=110).save(f'p{i+1}.png') for i,p in enumerate(d)]"
```

y después se leen los PNG. Vale para cualquier PDF escaneado de la materia.
