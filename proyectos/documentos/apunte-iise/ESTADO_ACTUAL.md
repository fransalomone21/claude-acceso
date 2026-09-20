# ESTADO ACTUAL — Apunte de IISE

**Fase 1** (el glosario controlado). La fase 0 cerró el **2026-09-20**.

## Qué hay

| Cosa | Estado |
|---|---|
| Material fuente de las 7 clases | **cerrado** — 590 diapositivas en `fuentes/clases/clase-N.txt`, con el número de diapositiva REAL y el título de cada una |
| Índice de diapositivas por título | **cerrado** — `fuentes/clases/titulos.md` |
| Diapositivas-figura | **cerrado** — 177 PNG en `fuentes/figuras/` (no se commitean; las regenera el extractor) |
| Insumos de NotebookLM | **guardados y medidos** — `fuentes/externo/`: 149 descripciones de figuras y el relevamiento de términos |
| Glosario controlado (M00) | **unidades 1 a 3 escritas** en `fuentes/glosario.md`: 27 términos con definición canónica, fuente verificada y confundibles. Faltan las unidades 4 a 7 |
| Módulos del apunte | **ninguno escrito** en Typst todavía |
| Parcialitos | **1, 2 y 3 en `fuentes/parcialitos.md`** — 16 preguntas y las 6 correcciones del profesor. Faltan los de las clases 4 a 7 |
| `verificar-lexico.py` | **no escrito** — es lo que falta para cerrar la fase 1 |

## Las cifras del material

| Clase | Diapositivas | Caracteres | Diapositivas-figura |
|---|---|---|---|
| 1 | 41 | 19.555 | 8 |
| 2 | 97 | 78.916 | 21 |
| 3 | 48 | 56.520 | 6 |
| 4 | 124 | 50.551 | 46 |
| 5 | 71 | 33.507 | 18 |
| 6 | 155 | 65.960 | 67 |
| 7 | 54 | 54.777 | 11 |
| **total** | **590** | **359.786** | **177** |

## Lo que la fase 0 dejó medido, y cambia cómo se trabaja

1. **Los `[pN]` de NotebookLM no sirven como cita.** De 149, **4** coincidían
   con la página real. El corrimiento no es constante (+2, +7, +14, +20…), así
   que ningún offset lo arregla. Se usan sus **descripciones**; el número lo
   pone quien escribe el módulo, **mirando el PNG**.
2. **Anclar por texto una figura es circular** y tampoco alcanza: justo las
   diapositivas con menos texto son las que peor se ubican. Comprobado con el
   diagrama de criterios de aprobación de la clase 1 — el reanclaje lo mandó a
   la p8 y está en la p4. Por eso `verificar-anclas.py` marca todo como
   **probable** y ninguna de sus anclas dice «confirmado».
3. **El léxico de la cátedra, medido:** `requerimiento` 342 + `requer.` 400 =
   **742**, contra `requisito` **8**. `interesado` **38**, `stakeholder` **5**.

4. **Los parcialitos son todos de definición.** 16 preguntas medidas sobre los
   tres primeros, uno por clase, 5 o 6 preguntas cada uno: *qué es X*, *cuáles
   son los tipos de X*, *cuáles son los roles / entregables / tareas de X*.
   Ninguna de cálculo ni de aplicación abierta. Eso **confirma por evidencia**
   que el glosario es el apunte y no un anexo.
5. **Las marcas del profesor valen más que las diapositivas** para saber qué se
   castiga. La más filosa, en rojo sobre la definición del PDP: **«resultados
   de procesos ≠ tareas»**. Y la frase que la respalda está textual en la clase
   3, diapositiva 16.

## Qué sigue

Cerrar la **fase 1**, y le falta una sola cosa: **`verificar-lexico.py`** —
que lea `fuentes/glosario.md`, chequee que ningún módulo use un término
controlado sin haberlo definido y que no aparezcan los pares prohibidos
(*requisito*, *stakeholder*) — más su saboteador poniéndolo en rojo a
propósito. El glosario de las unidades 1 a 3 ya está; las 4 a 7 se completan
al escribir sus módulos.
