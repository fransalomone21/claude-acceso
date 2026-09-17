# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 5 de N. **2026-09-17.** Opus, esfuerzo alto, **inline, sin un solo
subagente** — la cuarta fase seguida así. Cerrada con presupuesto de sobra:
**12 puntos** del límite de 5 h (13 % → 25 %) y **1** del semanal (79 % → 80 %),
medidos al cerrar.

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Rechtin & Maier. Fran: "mínima ambigüedad
posible", y las necesidades que generaron la arquitectura actual **siguen
valiendo**.

## ESTADO — fase 4 CERRADA, abre la fase 5

La fase 4 cerraba por **dos** cosas y cerró por las dos, las dos en
**`perfil-global/pilares/rechtin-maier/heuristicas.md`**:

1. **Las heurísticas de arquitectura que aplican a un sistema de trabajo de
   UNA persona**, organizadas por la taxonomía de tareas del propio libro
   (scoping, modeling, prioritizing, aggregating, partitioning, integrating,
   certifying, assessing, re-architecting) más las multitarea.
2. **Cada una con su caso propio ya vivido** — del repo, no inventado. Cada
   caso apunta a un archivo o a una lección del registro, buscable por
   síntoma. **Las que no tenían caso no entraron**, y están listadas con su
   motivo en la sección 6 de la ficha.

**Citas 99/99**, medidas y saboteadas. **Los cuatro libros de lectura están
cerrados.**

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. El denominador del medidor de citas se auditó, y había que auditarlo.**
El medidor dijo 87/87. Un conteo independiente de comillas dio **106 spans
candidatos**: faltaban 19. Se abrieron los 19 — **12 son citas cortas
legítimas del libro** que el medidor descarta por su mínimo de 40 caracteres o
7 palabras (*A model is not reality.*, *Simplify. Simplify. Simplify.*), y 7
no son citas. Las 12 se verificaron a mano por secuencia de letras: **99/99**.
Es la lección de la fase 1 (*un medidor con regex de comillas puede estar
mirando el 27 % del corpus*) aplicada al medidor **ya arreglado**: un medidor
depurado sigue teniendo un denominador que hay que medir.

**2. El ancla de este libro es CONSTANTE, y eso también se mide.** `+27`, con
**cero excepciones** sobre 422 encabezados, y 191/191 del índice. Que Douglass
no sea constante no vuelve sospechosos a los demás; que el SEH fuera +25 no
predice nada de éste. Cinco libros, cinco anclas.

**3. Es el primer libro que no trajo trampa nueva de extracción, y se midió
para saberlo.** La variante de partición de palabras es la misma del SEH (con
guion): 1907 cortes, **0** de la variante de NASA. `extraer.py` se copió sin
tocar una línea. **Copiarlo sin medir habría dado el mismo resultado esta
vez** — y por eso es la vez en que más barato sale medir.

**4. El mismo falso rojo del cruce índice↔cuerpo apareció por segunda vez en
dos libros.** Fase 3: 39/41, era el script. Esta: 186/191, era el parser del
índice. La diferencia es que esta vez se abrieron los cinco **antes** de
escribirlos como excepción, porque la lección ya estaba escrita. Costó dos
minutos en vez de una hora. *Una lección escrita es una `P` para una `D` que
va a volver.*

## HALLAZGOS QUE CAMBIAN UNA DECISIÓN (entradas a la fase 5 y 6)

1. **Al molde de fase del PDP le falta un campo: CÓMO SE CERTIFICA el criterio
   de salida.** Hoy pide el criterio; no pide el medidor ni exige que el
   medidor no sea invariante bajo el error que busca. Caso: una fase de
   `fisica-espacial` cerrada en falso por un `grep` del nombre. Fuente:
   Rechtin p. 398, *define how an acceptance criterion is to be certified at
   the same time the criterion is established*.
2. **La tercera forma de usar heurísticas —pegarlas a los pasos del proceso—
   es la que falta y la que más rinde.** Hoy el repo usa la 1 (escanear la
   lista) y la 2 (codificar la experiencia). El libro advierte el límite: sólo
   las que no dependen del dominio.
3. **Al registro de lecciones le falta el criterio de ENTRADA.** Tiene
   `--triage` (salida) y no los cinco criterios de selección (p. 33-34). Y el
   propio `triage` resultó ser, palabra por palabra, la heurística del triage
   del libro (p. 402) con sus tres ramas.
4. **El trade study de la fase 5 lleva sus criterios ponderados ESCRITOS
   ANTES.** Si empata, se rehacen los criterios, no el estudio.
5. **«Chat nuevo cuando cambia la fase» no es sólo ahorro de contexto: es el
   único reemplazo de EQUIPO que existe acá.** El *team* de la heurística
   p. 406 es la sesión, no la persona. Caso: `verificar-citas.py` v1 lo dio
   por bueno la sesión que lo escribió.
6. **La revisión independiente no tiene respuesta, y se declara sin
   respuesta.** Las tres cosas más cercanas (saboteador, chat nuevo, LLM
   externo) no lo son, y del LLM externo hay lección propia: de 4 propuestas,
   3 ya estaban implementadas.
7. **Las heurísticas de cliente NO se descartan por ser una persona: se
   traducen.** El cliente es el que ejecuta el lunes; el arquitecto, el que
   diseña el método. Ya divergieron, y por eso existe el cuadro PARA FRAN.
8. **DEFECTO VIVO, NO ARREGLADO, para la fase 6.**
   `perfil-global/chequeo-de-trabajo.md` línea 19 y
   `perfil-global/herramientas/aprender.py` línea 243 dicen **186**; el
   registro tiene **201**. `CLAUDE.md` ya prohíbe ese número con el caso
   anterior escrito (decía 45, había 76). El arreglo correcto es **derivarlo**,
   no actualizarlo, y eso toca una herramienta viva.

## LO QUE SE TOCÓ FUERA DEL PROYECTO, Y POR QUÉ NO ROMPE LA REGLA 4

Nada vivo de la arquitectura. Sólo `perfil-global/pilares/rechtin-maier/`, que
es material de lectura nuevo. **No se tocó `verificar-citas.py`**: el `--dir`
de la fase 2 sirvió tal cual para el cuarto libro.

Sí se actualizaron, en el mismo turno y por las reglas 4 y 7: la fila del
enrutador, las filas del contrato del proyecto y la fila 4 del `PDP.md`.

## LO SIGUIENTE — fase 5: diseñar la arquitectura nueva

La cierra (PDP §4): **documento de arquitectura + matriz de cumplimiento, con
trade study explícito** (NASA cap. 6.8): 2-3 alternativas, criterios
ponderados, y por qué perdieron las que perdieron. **Sin tocar un solo archivo
vivo.**

Entradas ya escritas y listas para usar:

- Los **cuatro** destilados: `nasa-seh/` (17 tramos), `incose-gtwr/reglas.md`,
  `incose-seh/mapeo-15288.md`, `rechtin-maier/heuristicas.md`.
- **El hallazgo que manda la reforma**, con tres fuentes confirmadas: la
  organización **elige** qué reglas usa y lo escribe (NASA 3.11 p. 34-42, SEMP
  §9.0 p. 232, GtWR R39 p. 84). El SEH no la agrega: aporta el proceso de
  tailoring con IPO (p. 216-218) y cinco trampas (p. 218).
- **El desacople más grande, ya identificado:** el corte NASA 3/4
  (lógico/físico) contra INCOSE T4/T5 (arquitectura/diseño). No se pueden
  cumplir los dos sin duplicar artefactos. **La matriz elige uno y lo
  declara.**
- **`ingenieria-de-sistemas.md` se escribió sin abrir el libro.** Contrastarlo
  es parte de esta fase.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

```powershell
python perfil-global\pilares\fuentes\medir.py      # 10/10 OK
```

y después, **nada de extraer PDF**: la fase 5 es de diseño y sus entradas son
las cuatro fichas, que ya están en el repo. Si hace falta volver a un libro,
cada pilar tiene su `pag.py` con el ancla ya medida.
