# Glosario controlado de IISE

La fuente única de cómo se nombra cada cosa en el apunte. **Un término se
define acá una vez, y después se usa siempre igual** — en esta materia dos
palabras distintas son dos conceptos distintos, y así se corrige.

Estado: **unidades 1 a 3 cubiertas** (las que ya tienen parcialito). Las
unidades 4 a 7 se agregan a medida que se escriben sus módulos.

## Cómo se lee cada entrada

- **Definición:** la canónica. La que va en el apunte y en el parcial.
- **Fuente:** `clase N, diapositiva M` — verificada contra
  `fuentes/clases/clase-N.txt`, que trae el número real del PDF.
- **Grado:** `confirmado` = la frase está textual en la diapositiva.
  `probable` = reconstruida o parafraseada; se verifica antes de cerrar el módulo.
- **No confundir con:** el término vecino y **en qué se distingue**. Esta línea
  es la que hace falta: el error que la cátedra castiga no es no saber el
  término, es usarlo por otro.

---

## Las decisiones de vocabulario, antes que nada

Medido sobre las 7 clases, y no se discute más:

| Se dice | No se dice | Conteo |
|---|---|---|
| **requerimiento** | requisito | 742 contra 8 |
| **interesado** | stakeholder | 38 contra 5 |
| **diapositiva** (en las citas del apunte) | slide, lámina | decisión del apunte |

---

## Unidad 1 — qué es esto

### sistema
**Definición.** Una combinación de elementos que interactúan, organizados para
alcanzar un propósito establecido; un conjunto de entidades y sus relaciones,
cuya funcionalidad es mayor que la suma de las entidades individuales.
**Fuente:** clase 1, diapositiva 25 · clase 2, diapositiva 28. **Grado:** confirmado.
**La prueba por el negativo**, que es la que se pregunta: *un ladrillo no es un
sistema* porque es uniforme en su consistencia y **no contiene entidades**
(clase 2, diapositiva 28). Si no hay entidades que interactúen, no hay sistema.
**No confundir con:** *agregado* — un montón de piezas sin relaciones
funcionales entre ellas no es un sistema, porque no hay nada que emerja.

### entidad (o elemento)
**Definición.** Los constituyentes del sistema: aquello en lo que el sistema se
descompone y que mantiene relaciones con los demás.
**Fuente:** clase 2, Tarea 2. **Grado:** probable.
**No confundir con:** *parte* en el sentido de la jerarquía NASA (sistema →
segmento → elemento → subsistema → ensamble → subensamble → parte), donde
«parte» es el nivel más bajo y concreto. «Entidad» es relativo al nivel que se
esté mirando.

### forma
**Definición.** **Lo que un sistema ES**: su encarnación física o informativa,
que existe o tiene el potencial de existir. Tiene figura, configuración,
disposición, *layout*. Durante un período de tiempo es estática y perseverante.
**Fuente:** clase 2, diapositiva 40. **Grado:** confirmado.

### función
**Definición.** **Lo que un sistema HACE**: las actividades, operaciones y
transformaciones que causan, crean o contribuyen al desempeño.
**Fuente:** clase 2, Tarea 1. **Grado:** probable.
**No confundir con:** *forma*. La pregunta de examen siempre pide las dos sobre
un mismo ejemplo. Regla corta: **forma = sustantivo; función = verbo.** El
sistema digestivo tiene forma (órganos) y función (digerir y asimilar).

### proceso
**Definición.** La parte de la función que es **pura acción o transformación**,
y por lo tanto la parte que **cambia el estado del operando**.
**Fuente:** clase 2, Tarea 1. **Grado:** probable.
**No confundir con:** *función*. La función es más amplia: incluye el proceso
**y** el operando sobre el que actúa. «Digerir» es el proceso; «digerir
alimentos» es la función.

### operando
**Definición.** El objeto que se transforma, o cuyo estado cambia.
**Fuente:** clase 2, Tarea 1. **Grado:** probable.

### proyecto
**Definición.** Un conjunto de tareas relacionadas entre sí, con un objetivo
común, que se completan dentro de ciertas especificaciones (desempeño), tienen
fecha de inicio y de terminación (planificación) y fondos limitados (costos), y
consumen recursos.
**Fuente:** clase 1, diapositiva 5. **Grado:** confirmado.

### triángulo de hierro
**Definición.** La representación de los tres ejes que el jefe de proyecto
balancea — **desempeño (performance), planificación (schedule) y costos** — con
el **riesgo del proyecto en el centro**. Es un triángulo *de hierro* **si los
tres están restringidos**: ahí no se puede mejorar uno sin empeorar otro.
**Fuente:** clase 1, diapositiva 17. **Grado:** confirmado.
**El detalle que se pierde:** no es «los tres ejes de un proyecto». Es la
condición de que **los tres estén restringidos a la vez**. Sin esa cláusula, la
respuesta describe cualquier proyecto y no el triángulo de hierro.

### ciencia · tecnología · ingeniería
**Definición.** **Ciencia:** sistemas teóricos de explicación de dominios
fenoménicos; justificaciones; carácter descriptivo. **Tecnología:** control de
procesos, control de la acción; actividad orientada al control de procesos.
**Ingeniería:** reglas exitosas de transformación; actividad orientada a crear
productos, sistemas y procesos.
**Fuente:** clase 1, diapositiva 3. **Grado:** confirmado.
**La relación, que es la segunda mitad de la pregunta:** son niveles distintos
de fundamentalismo, no sinónimos. La ciencia **puede** existir sin tecnología
ni ingeniería; sin ciencia no hay tecnología ni ingeniería. Y hay
realimentación: la ingeniería avanzada produce tecnología que habilita nueva
ciencia.

### ingeniería de sistemas
**Definición (INCOSE).** Un enfoque interdisciplinario y unos medios para
permitir la realización de sistemas exitosos. Se focaliza en definir las
necesidades del cliente y la funcionalidad requerida temprano en el ciclo de
desarrollo, documentar los requerimientos, y proceder con la síntesis del
diseño y la validación del sistema, considerando el problema **en su
completitud**: operaciones, costos y planificación, desempeño, entrenamiento y
soporte, ensayos, manufactura y fin de ciclo.
**Fuente:** clase 1, diapositivas 7 y 9 (INCOSE SE Handbook v3.2). **Grado:** confirmado.
**No confundir con:** *dirección de proyecto*, que son las tareas de **gestión**
para la mejor utilización de los recursos. La ingeniería de sistemas decide
**qué sistema** y **cómo se descompone**; la dirección de proyecto administra
**recursos, plazos y costos** para lograrlo.

### CDIO
**Definición.** Las cuatro fases del desarrollo de nuevos productos:
**Concebir, Diseñar, Implementar, Operar.**
**Fuente:** clase 1, diapositiva 2. **Grado:** confirmado.
**Los antecedentes, que es lo que se pregunta:** proyectos fallidos y
semifallidos que **despreciaron el contexto del producto** y valoraron de más
el reduccionismo y la especialización. El desbalance del perfil del ingeniero
—exceso de ciencias de la ingeniería, déficit de práctica y de habilidades
interpersonales— producía pérdidas de tiempo y económicas. CDIO es la
corrección de ese desbalance.

---

## Unidad 2 — pensamiento de sistema y arquitectura

### arquitectura de sistema
**Definición.** Una **descripción abstracta de las entidades de un sistema y de
las relaciones entre esas entidades**; el mapeo de la función a la forma a
través del **concepto**; la asignación de la función física o informativa
(proceso) a los elementos de la forma (objetos), y la definición de las
interfaces estructurales entre esos objetos.
**Fuente:** clase 2 (definiciones) · clase 4, diapositivas 30 y 44. **Grado:** confirmado.
**Qué hace buena a una arquitectura** —la segunda mitad de la pregunta—: es
fácil de integrar, admite una evolución sostenida en el tiempo antes de quedar
obsoleta, es **lo menos ambigua posible** y tiene una descomposición óptima.
**Puede ser compleja; no puede ser confusa.**
**No confundir con:** *diseño*. La arquitectura decide **qué entidades hay y
cómo se relacionan**; el diseño resuelve **cómo se construye cada una**
(se desarrolla en M24, unidad 7).

### concepto
**Definición.** Lo que relaciona la función con la forma. Es el puente: sin
concepto no hay mapeo de una a la otra.
**Fuente:** clase 2, diapositiva 21 (figura Función–Forma) · clase 4, diapositiva 30.
**Grado:** confirmado.
**El peso que tiene:** un buen concepto no garantiza el éxito del sistema, pero
**una mala elección del concepto casi con seguridad lo condena al fracaso**
(clase 3, diapositiva 5).

### emergente (emergencia)
**Definición.** Lo que aparece, se materializa o emerge **cuando un sistema
funciona**: se produce cuando la función de las entidades y su interacción
funcional se combinan. Es la funcionalidad del todo que ninguna entidad tiene
por separado.
**Fuente:** clase 2, sección de Emergentes. **Grado:** confirmado.
**Depende de la ESTRUCTURA, no sólo de las piezas:** con las mismas entidades y
otro patrón de conexión, emerge otra cosa — el mismo resistor y el mismo
capacitor dan un filtro pasabajos o uno pasaaltos según cómo se conecten
(clase 2, figura 2.13).
**Los cuatro tipos**, que es como se pregunta:

| | **Deseable** | **No deseable** |
|---|---|---|
| **Anticipado** | la función que se buscaba | la falla prevista, con su mitigación planeada |
| **No anticipado** | la sinergia que aparece sola | **la que cuesta el sistema** |

**Los tres métodos para predecirlos:** **modelado** (modelos aproximados o
teóricos: físicos, matemáticos, simulaciones), **experiencia** (relacionar el
sistema y sus partes con sistemas pasados que comparten función, forma o
contexto) y **experimentación** (someter un prototipo o versión temprana a
ensayos para verificar requerimientos y detectar malfuncionamientos).

### pensamiento holístico (holismo)
**Definición.** El holismo sostiene que **todas las cosas existen y actúan como
conjuntos, no sólo como la suma de sus partes**; su sentido es el **opuesto al
reduccionismo**. Pensar holísticamente es pensar deliberadamente sobre el todo:
identificar **todas** las entidades y problemas que podrían ser importantes
para el sistema.
**Fuente:** clase 2, diapositivas 56 y 57. **Grado:** confirmado.
**No confundir con:** *enfoque*, que es el movimiento contrario y
complementario — reducir todo lo que generó el pensamiento holístico a la lista
corta de lo que es **verdaderamente importante**. El holismo **abre**; el
enfoque **cierra**. En la Tarea 2 se usan los dos, en ese orden.

### abstracción
**Definición.** La expresión de la cualidad sin el objeto completo: una
representación que **conserva lo intrínseco y oculta el detalle innecesario**.
**Fuente:** clase 2, Tarea 2. **Grado:** probable.

### límite del sistema
**Definición.** Lo que delimita qué está dentro y qué está fuera del sistema;
**separa el sistema de su contexto**.
**Fuente:** clase 2, diapositiva 49. **Grado:** confirmado.

### relaciones formales y relaciones funcionales
**Definición.** Las **formales** son las que existen o podrían existir: la
**estructura**. Las **funcionales** son las que **hacen algo**: implican
operaciones, transferencias o intercambios entre las entidades — la
**interacción**.
**Fuente:** clase 2, Tarea 3. **Grado:** probable.
**No confundir:** dos entidades pueden estar formalmente conectadas y no
intercambiar nada. La N² tiene una tabla para cada tipo, por eso mismo.

### las cuatro Tareas del pensamiento de sistema
**Definición.**
1. **Identificar** la forma, las entidades y la función, y **crear el concepto**
   del sistema. Se usa el holismo; es el momento de **concebir y reducir la
   ambigüedad**.
2. **Definir los límites** del sistema y separarlo del contexto.
3. **Reconocer las entidades**, sus relaciones funcionales y formales, y las
   **interfaces**.
4. **Prever los emergentes** y el régimen de operación del sistema.

**Fuente:** clase 2, Tarea 1 a Tarea 4 (diapositivas 43 a 86). **Grado:** probable
(la numeración es de la cátedra; la redacción de cada una se cierra al escribir M07).
**Se piensa todo como sistemas, subsistemas y suprasistemas.**

### tabla N² (diagrama N²)
**Definición.** Un artefacto de interfaces: los componentes o funciones del
sistema se colocan **en la diagonal** de una matriz cuadrada de N×N, y las
celdas representan las interfaces. **Las salidas van en las filas
(horizontal); las entradas, en las columnas (vertical).** Donde la celda está
en blanco, **no hay interfaz** entre esos dos.
**Fuente:** clase 7, diapositiva 22 · clase 2, diapositiva 31 (tabla 2.5).
**Grado:** confirmado.
**Lo que se pierde si no se dice:** existe **en versión de tabla y en versión
de diagrama**, y hay una para las relaciones **formales** y otra para las
**funcionales**. Un lazo de realimentación es un flujo bidireccional entre dos
funciones, y se ve como dos celdas simétricas ocupadas.

---

## Unidad 3 — el rol del arquitecto

### rol del arquitecto
**Definición.** **Resolver la ambigüedad, enfocar la creatividad y simplificar
la complejidad.** Los tres se centran en la **información**: identificar la
información necesaria, coherente e importante reduciendo la ambigüedad;
**agregar** información nueva a través de la creatividad; y **gestionar la
explosión** de información hasta la arquitectura final.
**Fuente:** clase 3, diapositivas 7 y 8. **Grado:** confirmado.

### arquitecto de sistemas
**Definición.** El **especialista** en reducir la ambigüedad y elaborar el
concepto del sistema, y en emplear su creatividad para obtener **la mejor
arquitectura**.
**Fuente:** clase 3. **Grado:** confirmado (corregido en el parcialito 3).
**No confundir con:** «el ingeniero que sabe un poco de todo». **Esa respuesta
se corrige.** No es un generalista: es un especialista en una disciplina
concreta — interpretar las partes y su suma como algo distinto del todo.

### ambigüedad
**Definición.** En la práctica común, una **combinación de información confusa,
incertidumbre, información faltante, información conflictiva e información
incorrecta**. Contiene incógnitas conocidas e incógnitas desconocidas, además de
suposiciones en conflicto y falsas.
**Fuente:** clase 3, diapositivas 14 y 17. **Grado:** confirmado.
**Sus dos ideas base:** **incertidumbre** (no se conoce el resultado de un
evento) y **confusión** (un mismo evento admite múltiples interpretaciones).
**Los tipos de información que la producen:**

| Tipo | Qué pasa |
|---|---|
| **desconocida** | la información no está determinada o no está disponible |
| **conflictiva** | dos o más piezas ofrecen indicaciones opuestas |
| **falsa** | las entradas presentadas son incorrectas |

**Dónde es más aguda:** en la interfaz con las **influencias ascendentes** —
porque **nadie diseña los procesos ascendentes** (clase 3, diapositiva 14).

### influencias ascendentes y descendentes
**Definición.** Las **ascendentes** son lo que llega al arquitecto desde antes
de que se involucre: problemas, oportunidades, necesidades, estrategia,
regulaciones. Las **descendentes**, lo que el sistema produce hacia abajo y
hacia adelante. **Nadie diseña las ascendentes**, y por eso son la fuente
principal de ambigüedad.
**Fuente:** clase 3, diapositivas 4 y 15. **Grado:** confirmado.

### entregables del arquitecto
**Definición.** El **resultado final, no el procedimiento por el cual se logra
el estado**. Incluyen: un conjunto de objetivos claros, completos, consistentes
y alcanzables; un concepto del sistema y de las funcionalidades de los
subsistemas; una buena descomposición **de al menos dos niveles de
profundidad**; una definición clara de las interfaces internas y externas;
conceptos de operaciones; y una noción de costos, cronogramas y de las
influencias ascendentes.
**Fuente:** clase 3, diapositiva 16. **Grado:** confirmado.
**⚠ LA CORRECCIÓN DEL PARCIALITO 3.** «Los entregables son **muy diferentes de
las tareas** en que son el resultado final, no el procedimiento» — está textual
en la diapositiva 16. Responder esta pregunta enumerando tareas es el error que
la cátedra marca. Y la descomposición lleva **el número**: *al menos dos
niveles*, no «una buena descomposición».

### PDP — proceso de desarrollo de producto
**Definición.** El **marco empresarial** que captura la metodología de
desarrollo de productos —terminología, fases, hitos, cronogramas, listas de
tareas y **resultados**— con la intención de capturar la sabiduría de los
esfuerzos de desarrollo anteriores.
**Fuente:** clase 3, sección 3. **Grado:** confirmado.
**⚠ LA CORRECCIÓN DEL PARCIALITO 3**, en rojo: **«resultados de procesos ≠
tareas»**. El PDP no es una lista de tareas: es el marco que las organiza y que
define **qué resultado** produce cada fase. Definirlo como «una lista de
tareas, cronogramas e hitos» es la respuesta que se corrige.
**Sus cuatro fases genéricas:** **concepción** (determinar qué se construirá,
según las necesidades del mercado y la tecnología disponible), **diseño** (la
representación del objeto de información que define qué se va a implementar),
**implementación** (convertir el diseño en realidad: código, fabricación,
integración) y **operaciones** (operar el sistema para entregar valor; terminan
en el **retiro**).

### compuerta de control (control gate)
**Definición.** El punto de decisión que habilita el **cambio de fase**.
**Fuente:** clase 3. **Grado:** probable.
**No confundir con:** las **revisiones técnicas** (PDR, CDR, SRR…), que son los
eventos donde se evalúa; ni con los **KDP** de NASA, que son los puntos de
decisión del ciclo de vida. Se desarrollan en M15.

### principio de ambigüedad
**Definición.** «La fase inicial de un diseño de sistema se caracteriza por una
gran ambigüedad. El arquitecto debe resolver esta ambigüedad para producir —y
actualizar continuamente— los objetivos del equipo del arquitecto.»
**Fuente:** clase 3, recuadro 9.2. **Grado:** confirmado.

### las preguntas W canónicas
**Definición.** Los siete atributos del producto o sistema: **por qué**
(necesidad/oportunidad), **qué** (metas/desempeño), **cómo**
(función/interacción), **dónde** (forma/estructura), **cuándo**
(comportamiento/dinámica), **quién** (operador/usuario) y **cuánto**
(costo/gasto).
**Fuente:** clase 3, figura 9.6. **Grado:** confirmado.

---

## Pendiente

Las unidades 4 a 7 todavía no están: sistema de sistemas, niveles de sistema,
requerimiento y su familia, márgenes, las siete palabras del alcance
(necesidad, meta, objetivo, hipótesis, misión, ConOps, restricción),
verificación y validación, interfaces e ICD/IDD, los modelos de ciclo de vida
(V, cascada, espiral, ágil) y los métodos de creación de arquitecturas. Se
agregan al escribir sus módulos.
