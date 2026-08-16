# Estado actual — Apunte de Aplicaciones de Electrónica Analógica (4.º año)

**Fecha:** 2026-08-16
**Rama:** `claude/apunte-electronica-analogica`
**Proyecto nuevo.** No se mezcla con BLACK ni con el kit de teléfono (regla del
`CLAUDE.md` raíz: un proyecto por rama).

## Qué es esto

Apunte teórico-práctico completo de la materia, fuente única en **Typst**, listo para
compilar a PDF. Destinatario: alumnos de 4.º año de la E.E.S.T. N.º 1 de Vicente López.

## Cómo se compila

```bash
cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf
```

Typst **0.15.1** instalado en la máquina vía `winget install Typst.Typst`. No hace falta
LaTeX, pandoc ni nada más. Para trabajar con vista viva: `typst watch apunte.typ apunte.pdf`.

## Estado por módulo

| Módulo | Tema | Estado |
|---|---|---|
| — | `plantilla.typ` (estilo, cajas, contadores, carátula, índice) | **CERRADO**, verificado por render |
| 1 | Mediciones y expansión de rango | **CERRADO** — teoría + 4 ejercicios resueltos + 3 circuitos ASCII |
| 2 | Señales periódicas e instrumental | Andamio con plan de contenido |
| 3 | Electromagnetismo y transformadores | Andamio con plan de contenido |
| 4 | Diodos y rectificación | Andamio con plan de contenido |
| 5 | Fuentes lineales (incluye zener) | Andamio con plan de contenido |
| 6 | BJT en conmutación y relés | Andamio con plan de contenido |
| — | Anexos (código de colores, formulario, seguridad) | Andamio con plan de contenido |

Los andamios están en `apunte/modulos/pendientes.typ`. **No son relleno**: contienen el
plan de contenido ya decidido, con las deducciones y los ejercicios que van en cada
módulo, para que la próxima sesión no tenga que volver a diseñarlo.

## Evidencia (qué está confirmado y cómo)

- **Typst compila el documento completo** → `apunte.pdf`, 260 KB. Confirmado por
  ejecución, no por inspección del fuente.
- **Los acentos y las fórmulas renderizan bien** → confirmado por render de la página 6
  a PNG y lectura visual. Era el riesgo real: un problema de codificación habría
  arruinado las 150 páginas.
- **Las guías de TPs son las reales de la cátedra** → descargadas de los links de Drive
  que pasó Fran, texto extraído con `pypdf`, guardadas en `fuentes/`.

## Hallazgo que cambió el alcance

El temario que pasó Fran y los TPs de la cátedra **no coinciden**:

- Los TPs incluyen **regulador zener (TP 8, 1N4733)**, **filtro pasa bajos RC**
  (TP 5 p.4) y **circuitos serie/paralelo con multímetro** (TP 2 y 3), que el temario
  no menciona. Se incorporan igual: son evaluables.
- El temario incluye **transformadores (M3)** y **BJT/relé (M6)**, que **no tienen TP**
  en ninguna de las dos guías.

Decisión: el apunte cubre el temario completo **más** lo que los TPs exigen. Cada
módulo lleva una caja violeta "TP relacionado" que ata teoría con práctico.

## Fuentes

- `fuentes/TP_I_cuatrimestre.pdf` — 16 páginas, TP 0 a 5 + Anexo 1 (expansión de rango).
- `fuentes/TP_II_cuatrimestre.pdf` — 8 páginas, TP 6 a 8 (diodo, fuentes, zener).
- Autor de ambas: Prof. Guillermo Ruisi.
- **No accesible:** el aula virtual de Moodle (`moodle.tecnica1vl.org`) pide login. El
  apunte general de la materia y el interactivo siguen sin leerse.
