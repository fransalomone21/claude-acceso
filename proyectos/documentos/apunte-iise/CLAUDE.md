# Apunte de IISE — contrato de contexto

Apunte general de **Introducción a la Ingeniería de Sistemas Espaciales**
(UNSAM, 2026), unidades 1 a 7. Fuente única en **Typst**, un solo PDF.
Destinatario: **el alumno que cursa la materia y rinde sus parciales**.

**Naturaleza:** `documentos`. Antes de trabajar acá se lee
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md).

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber qué módulos están cerrados | [`ESTADO_ACTUAL.md`](ESTADO_ACTUAL.md) |
| qué cierra la fase en curso, o por qué se decidió algo | [`PDP.md`](PDP.md) — §4 y §6 |
| lo que quedó a medias y las trampas ya pagadas | [`HANDOFF.md`](HANDOFF.md) |
| **escribir un módulo de la unidad N** | `fuentes/clases/clase-N.txt` — **sólo ese archivo**. Trae las diapositivas de esa clase con su número real y su título. Las 7 juntas son ~90k tokens: no entran con margen para escribir |
| ubicar UNA diapositiva sin abrir el .txt entero | `fuentes/clases/titulos.md` — las 590 por título |
| escribir sobre una diapositiva marcada `[FIGURA]` | el PNG en `fuentes/figuras/cNN-pMMM.png`, **mirándolo**. El texto solo no alcanza: son 177 diapositivas donde el concepto vive en el diagrama |
| saber qué muestra una figura antes de abrirla | `fuentes/externo/notebooklm-figuras-reanclado.md` — **por su descripción, nunca por su número**. Ver la regla propia 2 |
| buscar la definición textual de un término | `fuentes/externo/notebooklm-terminos.md`, y **verificarla contra el `.txt`** antes de usarla |
| desambiguar un concepto que la diapositiva dice a medias | `perfil-global/pilares/nasa-seh/` e `incose-seh/` — los libros ya están extraídos a `.txt` por el proyecto `arquitectura-se` |
| saber qué módulo responde una pregunta de parcialito | [`fuentes/parcialitos.md`](fuentes/parcialitos.md) — la columna «Dónde se responde» trae el módulo **y la sección exacta**, y la mide `verificar-cobertura.py` |
| regenerar el material fuente | `python extraer-clases.py --figuras` |

## Las reglas propias

**1. El léxico es el contenido.** Un término controlado se define **una vez**,
en el glosario, y después se usa siempre igual. No se varía «para que no quede
repetitivo»: en esta materia dos palabras distintas son dos conceptos
distintos, y el parcial se corrige así. Está medido: la cátedra dice
**requerimiento** (742 apariciones) y no *requisito* (8); **interesado** (38) y
no *stakeholder* (5).

**2. Un número de diapositiva no se cita hasta haberlo visto.** El inventario
de figuras de NotebookLM trae un `[pN]` por entrada y **sólo 4 de 149
coincidían con la página real** — y el corrimiento no es constante, así que no
hay offset que lo arregle. `verificar-anclas.py` propone un ancla **probable**;
el número entra al apunte recién después de mirar el PNG. Citar mal una
diapositiva es la falla silenciosa de esta naturaleza: sale impreso, manda al
lector a otro lado, y nada avisa.

**3. Todo lo que viene de otra IA es un insumo, no una fuente.** Lo de
`fuentes/externo/` se contrasta contra `fuentes/clases/clase-N.txt` antes de
entrar al apunte. Ya pasó con propuestas de otro LLM sobre el apunte de Física
Espacial: de 4, tres ya estaban hechas.

**4. Ninguna sección se cierra sin haber mirado su página compilada.** Que
Typst compile no dice nada sobre rótulos cruzados, figuras que no entraron o
tablas cortadas. Ver `/pdf-con-codigo`.

**5. Se deduce lo que cambia el entendimiento; se cita lo que sólo cambia la
redacción.** Una definición que aparece de la nada incumple la primera mitad;
tres párrafos de paráfrasis incumplen la segunda.

**6. Una unidad por sesión.** Las 7 clases son 590 diapositivas y ~90k tokens.
Una sesión lee el `.txt` de su unidad y nada más.

**7. Una tabla de Typst con anchos `auto` no se da por buena hasta verla.** Si
una columna tiene texto largo, `auto` le da todo el ancho y deja a las otras en
una letra por renglón — *sin un solo warning*. En este apunte las tablas de más
de dos columnas llevan fracciones explícitas (`1.5fr`), y es un caso particular
de la regla 4: lo que se verifica es la página, no que el compilador no proteste.

## El estado en un comando

```powershell
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\verificar-lexico.py"
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\probar-verificar-lexico.py"
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\verificar-cobertura.py"
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\probar-verificar-cobertura.py"
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\verificar-anclas.py"
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\extraer-clases.py" --figuras
```

El apunte se compila y se mira así — los dos pasos, siempre:

```powershell
cd "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\apunte"; typst compile apunte.typ apunte.pdf; typst compile apunte.typ "$env:TEMP\iise-{p}.png" --ppi 110
```
