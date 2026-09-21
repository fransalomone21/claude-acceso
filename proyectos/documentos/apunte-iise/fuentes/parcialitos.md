# Banco de parcialitos — lo que la cátedra realmente pregunta

Reconstruido el **2026-09-20** desde los parcialitos 1, 2 y 3 corregidos. Los
PDF originales están en `fuentes/pdf/parcialitos/` (ignorados: llevan nombre
propio y las respuestas manuscritas). Acá va **sólo la pregunta**, que es lo
que el apunte tiene que cubrir.

Los PDF **no tienen texto**: son fotos de hoja manuscrita, 0 caracteres
extraíbles. Las preguntas se reconstruyeron leyendo las respuestas página por
página, así que su redacción es **probable**, no textual. Lo que sí es
`confirmado` es el **tema** de cada una y su número.

## El patrón, y es lo que decide el apunte

**Un parcialito por clase. Cinco o seis preguntas. Todas de definición.** No
hay una sola de cálculo ni de aplicación abierta: se pide *qué es X*, *cuáles
son los tipos de X*, *cuáles son los roles / entregables / tareas de X*. Con
16 preguntas medidas, ninguna se sale de esa forma.

Eso **confirma por evidencia** la decisión del PDP §6: el glosario controlado
no es un anexo del apunte, es el apunte. Y predice la forma de los parcialitos
4 a 7, que todavía no se rindieron o no volvieron corregidos.

## Cómo se lee la columna «Dónde se responde»

`M07 §La tabla N²` es el **módulo** y el **título exacto de la sección** de
`apunte/modulos/mNN-*.typ` que contesta la pregunta. No es una referencia
aproximada: `verificar-cobertura.py` la resuelve contra el archivo y se pone
en rojo si el módulo o la sección no existen. La primera sección es la que
alcanza para contestar; las que siguen amplían.

## Parcialito 1 — clase 1

| # | Pregunta | Dónde se responde |
|---|---|---|
| 1 | ¿Cuáles fueron los antecedentes que llevaron al enfoque CDIO? | M01 §La historia, en cuatro pasos · M01 §CDIO: qué desbalance vino a corregir |
| 2 | ¿Cuál es el rol del ingeniero de sistemas en un proyecto? | M02 §Las tres actividades que se confunden · M03 §Las definiciones · M03 §Los seis pasos del enfoque |
| 3 | ¿Qué es un sistema? Dar un ejemplo e identificar en él forma, función y entidades | M03 §Qué es un sistema, y el principio de los niveles · M05 §Qué es un sistema, otra vez, y la prueba por el negativo · M06 §Tarea 1 — Forma y función · M06 §Tarea 2 — Entidades, límite y contexto |
| 4 | ¿Qué es el triángulo de hierro? | M02 §El triángulo de hierro |
| 5 | Diferenciar ciencia, tecnología e ingeniería, y explicar cómo se relacionan | M01 §Tres actividades, no tres sinónimos · M01 §Cómo se relacionan, que es la segunda mitad de la pregunta |

## Parcialito 2 — clase 2

| # | Pregunta | Dónde se responde |
|---|---|---|
| 1 | ¿Qué es la arquitectura de un sistema? ¿Qué hace que una arquitectura sea buena? | M04 §Qué es la arquitectura de un sistema · M04 §Qué hace buena a una arquitectura |
| 2 | ¿Qué son los emergentes? Enumerar sus cuatro tipos con un ejemplo de cada uno | M05 §Lo emergente: la magia y el poder de los sistemas · M05 §Los cuatro tipos de emergente · M05 §El principio de lo emergente |
| 3 | ¿Qué es el pensamiento holístico? | M06 §Pensamiento holístico · M06 §Enfoque: reducir a lo manejable |
| 4 | ¿En qué cuatro tareas se descompone el pensamiento de sistema? | M05 §Pensamiento sistémico, no sistemático · M06 §Tarea 1 — Forma y función · M07 §Tarea 3 — Relaciones entre entidades |
| 5 | ¿Qué es la tabla N²? | M07 §La tabla N² · M27 §La misma herramienta, ahora para interfaces |
| 6 | ¿Cuáles son los métodos para predecir los emergentes? | M07 §Los tres métodos para predecir lo emergente · M07 §Tarea 4 — Predecir lo emergente |

**Los cuatro tipos de emergente** (pregunta 2) son la respuesta más larga de
los tres parcialitos y la que más marcas de corrección tiene: anticipado
deseable, anticipado no deseable, no anticipado deseable, no anticipado no
deseable. Van con un ejemplo cada uno.

## Parcialito 3 — clase 3 (rendido el 3/09)

| # | Pregunta | Dónde se responde |
|---|---|---|
| 1 | ¿Cuáles son los roles principales del arquitecto de sistemas? | M08 §Los tres roles · M08 §El principio del rol del arquitecto |
| 2 | ¿Qué es la ambigüedad? ¿Qué tipos de información la producen? | M09 §Dos ideas, no una: borrosidad e incertidumbre · M09 §Información desconocida, conflictiva y falsa |
| 3 | ¿Qué es el PDP? | M10 §Qué es un PDP, y para qué sirve · M10 §El PDP genérico |
| 4 | ¿Cuáles son los entregables del arquitecto de sistemas? | M08 §Los entregables del arquitecto |
| 5 | ¿En qué es especialista el arquitecto de sistemas? | M08 §Un especialista, no un generalista |

## Lo que la cátedra CORRIGIÓ — el error que castiga

Esto es lo más valioso del banco, y no se deduce de las diapositivas: son las
marcas del profesor sobre las respuestas. Cada una es una distinción léxica
que el apunte tiene que dejar cerrada.

| Dónde | La corrección | Dónde queda saldada |
|---|---|---|
| P3 · 3 (PDP) | **«Resultados de Procesos ≠ Tareas»**, escrito en rojo | M10 §Qué es un PDP, y para qué sirve — el `#cuidado` que abre el módulo |
| P3 · 4 (entregables) | subrayado: **«buena descomposición de al menos DOS niveles de profundidad»** | M08 §Los entregables del arquitecto — «al menos *dos capas de descomposición*», con el número |
| P3 · 5 | subrayado: **«especialista en emplear su creatividad para obtener la mejor arquitectura»** | M08 §Un especialista, no un generalista · M08 §Los tres roles |
| P2 · 1 | subrayado: **«descripción abstracta de las decisiones tomadas y del concepto»** | M04 §Qué es la arquitectura de un sistema — la definición canónica, más el `#clave` de las decisiones tempranas |
| P2 · 2 | subrayado: **«influyen en las influencias ascendentes y descendentes»** | M09 §Las influencias ascendentes y descendentes |
| P2 · 5 | subrayado: **«existe su versión en tablas Y en diagramas»** | M07 §Tarea 3 — Relaciones entre entidades · M07 §La tabla N² |

**Una salvedad sobre P2 · 2, y es `hipótesis`.** «Influencias ascendentes y
descendentes» es vocabulario de la **clase 3** (el arquitecto y la ambigüedad),
no de la clase 2, así que leer ese subrayado como que define a los *emergentes*
por su efecto hacia arriba y hacia abajo en la jerarquía puede ser una mala
reconstrucción de la pregunta. Las dos lecturas están cubiertas —la jerárquica
en M05 §El principio de lo emergente, la literal en M09—, así que no cambia
ninguna decisión del apunte; queda anotada para no citarla como `confirmado`.

## Cobertura — el medidor de la fase 3

**16 preguntas, 16 mapeadas, ninguna huérfana**, verificado el 2026-09-20
contra los 28 módulos escritos:

```powershell
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\verificar-cobertura.py"
python "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\apunte-iise\probar-verificar-cobertura.py"
```

**Este mapeo estaba mal en 9 de las 16 preguntas hasta el 2026-09-20.** Se
había escrito el mismo día que se reconstruyó el banco, *desde los parcialitos
y de memoria*, sin abrir un solo módulo — y además con la numeración anterior a
que la unidad 6 creciera a cinco módulos, así que la tabla N² aplicada apuntaba
a M26 (revisiones de la fase A) en vez de M27. Los errores no eran sutiles:
CDIO y triángulo de hierro estaban cruzados entre M01 y M02, ambigüedad y
entregables cruzados entre M08 y M09, y el pensamiento holístico mandaba a M04
cuando se define en M06. Lo que lo atrapó fue exigir la **sección exacta**: un
mapeo a nivel módulo se puede escribir sin mirar nada y suena plausible igual.
Por eso ahora la columna lleva `§sección` y la resuelve un script.

La cobertura es un **piso, no un techo** (PDP §4): un módulo que ningún
parcialito toca no sobra. Faltan los parcialitos de las clases 4 a 7 y **no van
a llegar**; si aparecieran, se agregan acá y se vuelve a correr el medidor.
