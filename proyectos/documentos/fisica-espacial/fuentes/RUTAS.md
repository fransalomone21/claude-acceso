# Las fuentes — dónde está cada libro en el disco

Los PDFs **no se copian al repo**: pesan cientos de MB y no son nuestros. Esta
tabla es el puntero. Medida contra el disco el 2026-08-30.

| Cita en el apunte | Libro | Ruta |
|---|---|---|
| S&Z vol. 1 | Young & Freedman, *Física universitaria con Física Moderna* Vol. 1 (Pearson, 2018) | `C:\Users\frans\Desktop\Mis Documentos\SistemasEspaciales\Libros de Fisica\Hugh D. Young_ Roger A. Freedman - Física universitaria_ con Física Moderna. 1-Pearson Educación (2018).pdf` |
| S&Z vol. 2 | ídem, Vol. 2 | `…\Libros de Fisica\Hugh D. Young_ Mark Waldo Zemansky_ … - Física universitaria con física moderna 2-Pearson Educación (2018).pdf` |
| Roederer | Roederer, *Mecánica elemental* (Eudeba, 2008) | `…\Libros de Fisica\Roederer, Juan G. - Mecánica elemental-Eudeba (2008).pdf` |
| Beer | Beer & Johnston, *Mecánica vectorial para ingenieros: Dinámica* | `…\Libros de Fisica\Beer_ Mec vectorial para ingenieros _ dinámica.pdf` |
| Bate | Bate, Mueller & White, *Fundamentals of Astrodynamics* (Dover, 1971) | `C:\Users\frans\Downloads\Roger  R. Bate, Donald D. Mueller, Jerry E. White - Fundamentals of astrodynamics-Dover Publications (1971).pdf` |
| Curtis | Curtis, *Orbital Mechanics for Engineering Students* (Elsevier, 2020) | `C:\Users\frans\Downloads\(Elsevier Aerospace Engineering Series) Curtis, Howard D - Orbital mechanics for engineering students-Elsevier, Butterworth-Heinemann (2020).pdf` |

**Los dos últimos viven en `Downloads`, que es una carpeta que se limpia.** Si
alguno desaparece, el apunte pierde su fuente para órbitas y maniobras — están
para moverse a `Libros de Fisica` cuando haya ocasión.

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
