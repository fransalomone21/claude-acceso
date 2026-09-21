# Banco de parcialitos — lo que la cátedra realmente pregunta

Reconstruido el **2026-09-20** desde los parcialitos 1, 2 y 3 corregidos, y
ampliado el **2026-09-21** con los parcialitos **4 y 5**, que aparecieron
después de que este mismo archivo declarara que no iban a llegar. Los
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
**28** preguntas medidas sobre **cinco** parcialitos, ninguna se sale de esa
forma — y los dos últimos, que llegaron un día después de que el patrón
estuviera escrito, lo confirmaron sin una sola excepción.

Eso **confirma por evidencia** la decisión del PDP §6: el glosario controlado
no es un anexo del apunte, es el apunte. La predicción se puso a prueba sola:
con 16 preguntas medidas este archivo predijo la forma de los parcialitos que
faltaban, y cuando llegaron los dos siguientes —12 preguntas más— **ninguna se
salió de la forma**. Es lo más parecido a una validación que este banco puede
ofrecer.

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

## Parcialito 4 — clase 5

| # | Pregunta | Dónde se responde |
|---|---|---|
| 1 | ¿Cuáles son las fases del ciclo de vida de NASA? | M15 §Las siete fases del ciclo de vida de NASA · M22 §Pre-Fase A, a fondo |
| 2 | ¿Qué es un requerimiento? ¿Qué tipos de requerimientos hay? | M16 §Qué es un requerimiento · M17 §El ejemplo largo: el Programa Apollo · M17 §Qué más es un requerimiento |
| 3 | ¿Qué enseña el diagrama en V? | M15 §El diagrama en V · M15 §El mismo diagrama, aplicado a software |
| 4 | ¿Qué es la validación de los requerimientos? | M18 §Validar · M18 §Verificar · M21 §Verificación y validación, en la práctica |
| 5 | ¿Qué es la trazabilidad de un requerimiento? ¿Qué es un requerimiento huérfano? | M17 §Trazabilidad: seis niveles, un solo objetivo · M19 §La familia de requerimientos |
| 6 | ¿Qué es un sistema de sistemas? | M12 §Qué es un sistema de sistemas · M12 §El ejemplo real: la Estación Espacial Internacional |

## Parcialito 5 — clase 6 (rendido el 17/09)

| # | Pregunta | Dónde se responde |
|---|---|---|
| 1 | ¿Qué implica que un requerimiento sea SMART? | M21 §Los buenos requerimientos son SMART · M21 §El checklist de nueve preguntas |
| 2 | ¿Qué expresa el _rationale_ de un requerimiento? | M21 §La rationale: por qué existe un requerimiento |
| 3 | ¿En qué orden van los elementos del alcance? | M18 §Los elementos del alcance · M20 §El Ejercicio de Alcance |
| 4 | ¿En qué consiste el Ejercicio de Alcance? | M20 §El Ejercicio de Alcance · M19 §Interfaces: siempre que se descompone, aparecen · M23 §Tres formas de gestionar el conocimiento de un proyecto |
| 5 | Comparar Waterfall y Agile | M22 §Comparación de modelos de ciclo de vida · M22 §Modelo cascada · M22 §Desarrollo ágil · M10 §Agile: iterativo e incremental |
| 6 | Explicar cada elemento del alcance, con un ejemplo | M18 §Los elementos del alcance · M17 §El ejemplo largo: el Programa Apollo |

**La pregunta 3 pide la CADENA, no la lista.** El orden —necesidad, meta,
objetivo, misión, hipótesis, restricciones, autoridad y responsabilidad,
ConOps— es la respuesta; enumerar los siete elementos sueltos contesta la
pregunta 6, no la 3. M18 lo dice ahora explícitamente, con la cadena escrita en
una línea.

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
| P4 · 1 (fases) | marcada la **Fase F** descripta como «operación y mantenimiento» | M15 §Las siete fases del ciclo de vida de NASA — el `#cuidado` nuevo: la Fase E opera, la **F cierra**. Correr las dos últimas deja el proyecto sin cierre |
| P4 · 2 (requerimiento) | resaltado: **«declaración de ALTO NIVEL»** | M16 §Qué es un requerimiento — el requerimiento se enuncia al nivel del sistema, no al del componente |
| P5 · 2 (_rationale_) | resaltado: **«el POR QUÉ / la justificación del requerimiento»** | M21 §El _rationale_ — el rationale no es una versión larga del requerimiento: es su fundamento, y va aparte |
| P5 · 4 (alcance) | resaltado: **IDD, IRD, ICD** y **MCR** | M19 §Las interfaces y sus tres documentos · M22 §Pre-Fase A — el ejercicio termina en un _baseline_ que pasa el MCR |
| P5 · 6 (elementos) | resaltados: **«necesidades: los intereses del usuario»**, **«misión: qué sistema y qué se logra con él»**, **«restricciones: delimitan el sistema del contexto»** | M18 §Los elementos del alcance — las tres definiciones, una por una |

**Una salvedad sobre P2 · 2, y es `hipótesis`.** «Influencias ascendentes y
descendentes» es vocabulario de la **clase 3** (el arquitecto y la ambigüedad),
no de la clase 2, así que leer ese subrayado como que define a los *emergentes*
por su efecto hacia arriba y hacia abajo en la jerarquía puede ser una mala
reconstrucción de la pregunta. Las dos lecturas están cubiertas —la jerárquica
en M05 §El principio de lo emergente, la literal en M09—, así que no cambia
ninguna decisión del apunte; queda anotada para no citarla como `confirmado`.

## Cobertura — el medidor de la fase 3

**28 preguntas, 28 mapeadas, ninguna huérfana**, verificado el 2026-09-21
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
parcialito toca no sobra.

**Faltan los de las clases 1 a 3 del segundo tramo —4 y 5 ya están— y este
archivo decía que no iban a llegar.** Llegaron el 2026-09-21, un día después.
Lo que hizo que eso costara poco fue que el mapeo estuviera medido: agregar 12
preguntas fue escribir doce filas y volver a correr `verificar-cobertura.py`,
que además exigió que el conteo declarado acompañara. Si en algún momento
aparecen los de las clases 6 y 7, el procedimiento es el mismo — y esta vez el
archivo no afirma que no vayan a aparecer.
