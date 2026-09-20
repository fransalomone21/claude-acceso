# Glosario controlado de IISE

La fuente única de cómo se nombra cada cosa en el apunte. **Un término se
define acá una vez, y después se usa siempre igual** — en esta materia dos
palabras distintas son dos conceptos distintos, y así se corrige.

Estado: **las 7 unidades cubiertas, completo** (las 1 a 3 tienen parcialito;
la 4, la 5, la 6 y la 7 se escribieron junto con sus módulos, sin uno).

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
**Fuente:** clase 7, diapositiva 22 · clase 2, diapositivas 71 (diagrama, fig.
2.10-2.11) y 73 (las dos tablas, tabla 2.5). **Grado:** confirmado — corregido
en esta sesión: la cita previa (diapositiva 31) apuntaba a la sección de
Emergentes, no a la Tarea 3; se verificó mirando `c02-p074.png` y
`c02-p075.png`, que son las tablas reales sin texto extraíble.
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

## Unidad 4 — la necesidad de la IS, sistema de sistemas, el motor NASA

### sistema de sistemas (SoS)
**Definición.** Un problema interdisciplinario de gran escala que involucra
sistemas múltiples, heterogéneos y distribuidos. Sus ocho características:
elementos del sistema que operan independientemente; elementos con
**diferentes ciclos de vida**; requerimientos iniciales probablemente
ambiguos; la **complejidad** es el factor más importante; la gestión
(_management_) puede oscurecer la ingeniería; límites difusos causan
confusión; y la ingeniería de un SoS **nunca termina**.
**Fuente:** clase 4, diapositiva 20 (INCOSE SE Handbook v3.2). **Grado:** confirmado.
**No confundir con:** un #t[sistema] grande. Lo que distingue a un SoS no es
el tamaño: es que sus elementos **ya eran sistemas completos y operativos
por su cuenta**, con dueños y ciclos de vida propios, antes de juntarse.

### jerarquía del sistema
**Definición.** La notación NASA para descomponer un producto en piezas cada
vez más chicas: **Sistema → Segmento → Elemento → Subsistema → Componente →
Sub ensamble → Parte**.
**Fuente:** clase 4, diapositivas 41, 111 y 112. **Grado:** confirmado.
**El detalle que se pierde:** el nivel es **relativo al proyecto, no
absoluto** — *"el sistema de un proyecto es el componente de otro"*
(diapositiva 111). Es la misma idea que el #t[principio de los niveles] de
la unidad 1 (sistema N+1 / N / N-1), ahora con **siete escalones** con
nombre en vez de tres genéricos.

### CDIO detallado
**Definición.** La versión de ocho pasos del ciclo de vida de un proyecto,
más específica que el #t[CDIO] de cuatro fases: **Necesitar, Requerir,
Descomponer, Diseñar, Integrar, Verificar, Operar y Disponer**.
**Fuente:** clase 4, diapositiva 41. **Grado:** confirmado.
**No confundir con:** el CDIO simple de la unidad 1. Son la misma secuencia
vista con más resolución — la cátedra lo dice explícitamente: *"esto es CDIO
pero más detallado, más específico"*.

### motor de la ingeniería de sistemas
**Definición.** El modelo de NASA con **17 actividades de proceso** para el
diseño, la realización y la dirección de un sistema, agrupadas en seis
procesos: **Definición de Requerimientos** (1-2), **Definición de
Soluciones Técnicas** (3-4), **Realización de Producto** (5-6),
**Evaluación** (7-8: verificación y validación del producto), **Transición
del Producto** (9), **Planificación Técnica** (10) y **Control Técnico**
(11-15: gestión de requerimientos, interfaces, riesgo técnico,
configuración y datos técnicos), cerrando con **Evaluación Técnica** (16) y
**Análisis de Decisión Técnica** (17).
**Fuente:** clase 4, diapositivas 102 a 119 (NASA SE Handbook SP-2007-6105).
**Grado:** confirmado.
**Lo que se pierde si no se dice:** los requerimientos fluyen **hacia
abajo** por la estructura del sistema (proceso de diseño) mientras los
productos se realizan y fluyen **hacia arriba** (proceso de realización) —
son dos direcciones simultáneas sobre la misma jerarquía, no dos fases
sucesivas.

### atributos del ingeniero de sistemas
**Definición (Gentry Lee).** Los rasgos que distinguen a un buen ingeniero
de sistemas: curiosidad intelectual; ver el _big picture_ y el detalle a la
vez; hacer conexiones en un sistema grande (tabla N²); estar cómodo con el
cambio, la incertidumbre y lo desconocido; ser un comunicador excepcional en
las dos direcciones; «paranoia apropiada» (esperar lo mejor, planificar para
lo peor); confianza en sí mismo y decisión («comisión, no omisión»);
apreciar el rigor de los procesos y saber dónde parar; ser fuerte como
miembro de equipo y como líder; y tener habilidades técnicas diversas para
aplicar juicio técnico.
**Fuente:** clase 4, diapositiva 122. **Grado:** confirmado.
**La cita que cierra la unidad:** *"Nunca ha habido un proyecto en la
historia que cualquier conjunto de requerimientos haya cubierto el
significado real de aquello que necesita ser hecho"* — los requerimientos
son aproximaciones hechas con lenguaje, y se interpretan.

---

## Unidad 5 — ciclo de vida, requerimientos, márgenes, alcance

### ciclo de vida de NASA
**Definición.** Las siete fases con las que NASA organiza un proyecto:
**Pre-Fase A** (Estudio Conceptual), **Fase A** (Desarrollo de Concepto y
Tecnología), **Fase B** (Diseño Preliminar), **Fase C** (Diseño Final y
Fabricación), **Fase D** (AIT y Lanzamiento), **Fase E** (Operaciones y
Sostenimiento) y **Fase F** (Cierre). La cátedra las agrupa en tres bloques
—**Formulación**, **Aprobación** e **Implementación**— sin marcar en qué
fase exacta cae el corte entre uno y otro.
**Fuente:** clase 5, diapositiva 5. **Grado:** confirmado (las siete fases);
probable (el corte de los tres bloques, no explícito en la diapositiva).
**No confundir con:** las **revisiones técnicas** (SRR, PDR, CDR…) ni los
**KDP**, que son los puntos de decisión *entre* fases, no las fases en sí
— #t[compuerta de control], unidad 3.

### diagrama en V
**Definición.** El modelo del ciclo de vida de un proyecto que dibuja, en el
lado *descendente* (izquierdo), la descomposición desde el concepto de
operación hasta el diseño de detalle, y en el lado *ascendente* (derecho),
la verificación correspondiente a cada nivel —unidad, subsistema, sistema—
en simetría con su contraparte de la izquierda. Muestra tres perspectivas a
la vez: la del cliente/usuario, la de la ingeniería de sistemas y la del
contratista.
**Fuente:** clase 5, diapositivas 7 y 8. **Grado:** confirmado.
**El detalle que se pierde:** el lado izquierdo es *altamente iterativo*; el
lado derecho, una vez que arranca la implementación, es *principalmente
serial* (diapositiva 7).

### requerimiento
**Definición.** Una declaración que describe una función necesaria o una
característica del sistema que se va a Concebir, Diseñar, Implementar y
Operar, e impacta en su performance, planificación, costos y otras
características (riesgo incluido). Se organiza **jerárquicamente**: los de
alto nivel dicen *qué* debe alcanzarse, no *cómo*, y se especifican en cada
nivel hasta el hardware y software de cada componente.
**Fuente:** clase 5, diapositiva 10. **Grado:** confirmado.
**No confundir con:** *requisito* — el término prohibido de la cátedra, ver
la tabla del principio de este glosario.

### margen (de requerimientos)
**Definición.** Una **reserva no alojada** a ningún subsistema en
particular —de masa, tamaño, memoria, potencia— que existe para absorber la
incertidumbre del diseño temprano, y que **controlan la ingeniería de
sistemas y la dirección de proyecto**, no cada subsistema por separado.
**Fuente:** clase 5, diapositivas 17 y 18. **Grado:** confirmado.
**Guías típicas de margen de masa, y cómo se consumen con el tiempo:** se
establece +30% en el SRR, y se va bajando a medida que el diseño madura:
20% antes del PDR, 10% antes del CDR, 5% antes del IOC. El crecimiento de
masa real medido en programas de vehículos tripulados es del 10 al 60%,
según cuán novedoso es el proyecto.
**La conexión que ya se usó:** es el mismo margen del *quinto motor* del
Saturno V (unidad 4) — un margen que en el papel "no hacía falta" y que
terminó siendo la diferencia entre una misión posible y una imposible.

### verificación (de requerimientos)
**Definición.** El proceso de confirmación de que un sistema está en
conformidad con sus requerimientos: contesta la pregunta *¿el sistema
encuentra sus requerimientos?* Confirma además que los requerimientos son
en verdad verificables, e identifica qué facilidades de ensayo hacen falta.
**Fuente:** clase 5, diapositiva 50. **Grado:** confirmado.
**No confundir con:** #t[validación (de requerimientos)] — la verificación
mira *un* requerimiento puntual contra el sistema ya construido; la
validación mira el *conjunto* de requerimientos contra la intención
original de los interesados. La distinción ya se usó, sin desarrollar, en
el ejemplo del rover marciano (unidad 4).

### validación (de requerimientos)
**Definición.** El proceso de confirmar la **completitud, la compatibilidad
y la exactitud** de los requerimientos: contesta si están definidos
correctamente y si el conjunto completo es autoconsistente.
**Fuente:** clase 5, diapositiva 56. **Grado:** confirmado.

### tipos de requerimientos
**Definición.** Cinco categorías, cada una con su propia prueba:
**funcionales** (qué función debe cumplirse — *el TVC proveerá control de
pitch y yaw*), **de performance o desempeño** (el grado de esa
funcionalidad — *el TVC gimbalará el motor hasta 9° ±0,1°*), **de
restricción** (no negociables en costo, programación o desempeño — *el TVC
no pesará más de 50 kg*), **de interfaz** (cómo un ítem se conecta con
otro) y **ambientales** (las cargas —vibroacústicas, térmicas, de shock—
que el diseño debe soportar).
**Fuente:** clase 5, diapositiva 60. **Grado:** confirmado.

### trazabilidad
**Definición.** La propiedad de un requerimiento de bajo nivel de poder
seguirse **hacia arriba**, hasta el requerimiento de alto nivel del que
proviene. Sin trazabilidad no se puede confirmar que una pieza construida
en el nivel más bajo sigue sirviendo al objetivo original de la misión.
**Fuente:** clase 5, diapositiva 37. **Grado:** confirmado.

### Statement of Work (SOW)
**Definición.** Un documento de gestión de proyecto: la descripción
narrativa del trabajo requerido, con actividades, entregables y
cronogramas específicos para el proveedor que le presta servicio al
cliente. Suele incluir también requerimientos de muy alto nivel y
precios, y acompaña a un contrato de servicio maestro o a un RFP (*Request
For Proposal*).
**Fuente:** clase 5, diapositiva 25. **Grado:** confirmado.

### semántica de los requerimientos (shall / will / should)
**Definición.** Tres verbos con tres funciones distintas en la redacción
técnica: **"shall" / "deberá"** redacta un *requerimiento* en sí (*el
sistema pesará...*); **"will"** redacta una *declaración de hecho*, que
suele preceder a uno o más requerimientos dentro de un escenario; **"should"
/ "debería"** redacta una *meta* de diseño, cuantificable pero no exigible
como un requerimiento.
**Fuente:** clase 5, diapositiva 24. **Grado:** confirmado.
**No confundir con:** #t[meta (elemento del alcance)], que es la meta del
*proyecto*, no la del diseño de un ítem puntual — comparten la palabra,
no el nivel al que se aplican.

### necesidad (elemento del alcance)
**Definición.** El elemento del alcance del que se deriva todo lo demás:
relacionado con el plan estratégico o de negocio, explica *por qué* el
proyecto desarrolla este sistema desde el punto de vista de los
interesados. **No es** una definición del sistema ni de una solución, y no
cambia mucho durante la vida del proyecto.
**Fuente:** clase 5, diapositiva 63. **Grado:** confirmado.

### meta (elemento del alcance)
**Definición.** Un objetivo amplio y fundamental que la organización espera
lograr para satisfacer una #t[necesidad (elemento del alcance)].
**Fuente:** clase 5, diapositiva 63. **Grado:** confirmado.

### objetivo (elemento del alcance)
**Definición.** La expansión concreta de *cómo* se va a alcanzar una
#t[meta (elemento del alcance)]: las iniciativas que la implementan, junto
con sus criterios de éxito — el mínimo que los interesados esperan del
sistema para considerarlo exitoso.
**Fuente:** clase 5, diapositiva 63. **Grado:** confirmado.

### misión (elemento del alcance)
**Definición.** El caso comercial —o de negocio— de por qué se necesita el
producto; definir y restringir la misión ayuda a identificar los
requerimientos.
**Fuente:** clase 5, diapositiva 63. **Grado:** confirmado.

### restricción (elemento del alcance)
**Definición.** Un elemento externo que **no se puede controlar** y que se
debe cumplir igual, identificado al definir el alcance — casi siempre en
términos de cronograma y presupuesto.
**Fuente:** clase 5, diapositiva 64. **Grado:** confirmado.

### autoridad y responsabilidad (elemento del alcance)
**Definición.** Quién tiene la potestad sobre los distintos aspectos del
desarrollo del sistema — un centro gubernamental, un contratista, el
cliente.
**Fuente:** clase 5, diapositiva 64. **Grado:** confirmado.

### hipótesis (elemento del alcance)
**Definición.** Un supuesto identificado por los interesados como parte de
la definición del alcance —por ejemplo, que cierta tecnología necesaria
será alcanzable— que condiciona a los requerimientos que se derivan
después.
**Fuente:** clase 5, diapositiva 64. **Grado:** confirmado.

### concepto de operación (ConOps)
**Definición.** Una descripción, paso a paso, de cómo el sistema propuesto
va a operar e interactuar con sus usuarios y con sus interfaces externas
durante las fases de la misión, para cumplir las expectativas de los
interesados. Estimula el desarrollo de requerimientos relacionados con el
usuario y revela funciones de diseño a medida que se consideran distintos
casos de uso.
**Fuente:** clase 5, diapositivas 64 y 65. **Grado:** confirmado.
**El ejemplo que lo prueba:** en la misión Mars Phoenix, el ConOps de
"poder *ver* el descenso y aterrizaje" agregó un requerimiento de cámara
(MARDI) que, en operación nominal, no habría hecho falta — la misma lógica
del margen: una necesidad que aparece al pensar el ciclo de vida completo,
no en el requerimiento del día uno.

---

## Unidad 6 — familia de requerimientos, interfaces, modelos de ciclo

### curva de la tasa de fracasos (curva de bañadera)
**Definición.** El modelo que describe cómo varía la tasa de falla de un
sistema a lo largo del tiempo, en tres períodos: *mortalidad infantil* (tasa
alta que decrece, por fallas de fabricación o control de calidad
inadecuado), *vida útil* (tasa constante, fallas al azar) y *desgaste* (tasa
creciente, al final de la vida útil).
**Fuente:** clase 6, diapositiva 5. **Grado:** confirmado.

### familia de requerimientos (padres, hijos, huérfanos)
**Definición.** La relación jerárquica entre requerimientos: un
requerimiento *padre* da origen a requerimientos *hijos* en el nivel de
abajo. Si el padre es incompleto, incorrecto, ambiguo, conflictivo o
inverificable, los hijos y las generaciones siguientes serán
*progresivamente peores*. Un requerimiento sin padre es un *huérfano*, y
debe evaluarse si corresponde incluirlo.
**Fuente:** clase 6, diapositivas 9 y 70. **Grado:** confirmado.

### documentos de interfaz (IDD, IRD, ICD)
**Definición.** Tres documentos distintos según qué se conecta. *IDD*
(Interface Definition Document): define las interfaces de un sistema *ya
existente* —por ejemplo, un lanzador ya elegido—; es propiedad de ese otro
sistema y probablemente no se puede alterar. *IRD* (Interface Requirement
Document): define interfaces entre *dos sistemas en desarrollo
simultáneo*; necesita un dueño conjunto, oficializado por ambos
directores. *ICD* (Interface Control Document): identifica la *solución
física* de la interfaz — los planos.
**Fuente:** clase 6, diapositiva 11. **Grado:** confirmado.

### requerimiento SMART
**Definición.** La sigla que resume las cinco cualidades de un buen
requerimiento: **E**specífico (un solo aspecto, en términos de la
necesidad — qué y cuán bien —, no de la solución), **M**edible (desempeño
cuantificable y verificable), **A**lcanzable (técnica y económicamente),
**R**elevante (apropiado para el nivel que se está especificando) y
**T**razable (fluye claramente desde un requerimiento padre).
**Fuente:** clase 6, diapositiva 70 (Ivy Hooks, INCOSE 1993). **Grado:**
confirmado.

### rationale (de un requerimiento)
**Definición.** La justificación que acompaña a un requerimiento: por qué
se necesita, qué hipótesis se hicieron, y qué esfuerzo de diseño lo
originó. Captura la motivación para que el requerimiento se pueda mantener
y entender con el tiempo.
**Fuente:** clase 6, diapositiva 74. **Grado:** confirmado.

### TBD / TBC / TBR
**Definición.** Tres marcas para lo indefinido en un requerimiento
temprano: **TBD** (*To Be Determined/Defined*) — todavía no determinado;
**TBC** (*To Be Confirmed*) — pendiente de confirmar; **TBR** (*To Be
Resolved*) — un valor estimado, con su rationale, a resolver. Cuanto más
tarde se resuelven, más caro sale — se resuelven lo antes posible.
**Fuente:** clase 6, diapositivas 69 y 73. **Grado:** confirmado.

### baseline
**Definición.** Sustantivo y verbo a la vez. Como sustantivo, un conjunto
*acordado* de requerimientos, diseños o documentos (datos de ingeniería)
con control de cambios formal. Como verbo, el proceso de establecer ese
conjunto. **Cada revisión técnica crea un baseline nuevo** del sistema.
**Fuente:** clase 6, diapositiva 86. **Grado:** confirmado.

### ingeniería concurrente
**Definición.** La gestión del conocimiento de un proyecto donde el
problema se estudia *en conjunto*, con optimización universal y esfuerzo
paralelo masivo.
**Fuente:** clase 6, diapositiva 114. **Grado:** confirmado.
**No confundir con:** el *diseño secuencial* (esfuerzo serial, con largos
períodos de iteración) ni el *diseño centralizado* — son los otros dos
tipos de gestión del conocimiento que distingue la cátedra, y la
ingeniería concurrente es el tercero.

### mecatrónica
**Definición.** La disciplina que integra mecánica, electrónica e
informática/control en un mismo producto. Junto con la *robótica*, es un
subconjunto de las temáticas de la ingeniería de sistemas espacial.
**Fuente:** clase 6, diapositivas 121 y 122. **Grado:** confirmado.

### modelo cascada
**Definición.** El modelo de desarrollo secuencial "clásico": el flujo se
mueve de una fase a la siguiente *sólo cuando la anterior está completa y
congelada*, sin retorno. La variante "modificada" agrega retroalimentación
entre fases — lo que rompe el principio de fases congeladas de la versión
clásica.
**Fuente:** clase 6, diapositiva 142. **Grado:** confirmado.
**No confundir con:** el #t[modelo Vee], que admite iteraciones localizadas
en vez de fases estrictamente congeladas.

### modelo Vee
**Definición.** Un modelo secuencial de ciclo de vida que resume el
concepto de verificación y validación a lo largo de todo el desarrollo:
mantiene la dimensión de tiempo de izquierda a derecha, pero algunas
iteraciones se capturan como movimientos en un eje vertical. No hay una
única definición formal, pero la filosofía de fondo es siempre la misma.
**Fuente:** clase 6, diapositivas 144 y 145. **Grado:** confirmado.
**No confundir con:** el #t[diagrama en V] de la unidad 5 — el modelo Vee
es el concepto general de ciclo de vida secuencial con V&V incorporada; el
diagrama en V de la unidad 5 es una instancia concreta de él, con las tres
perspectivas (cliente, ingeniería de sistemas, contratista) ya
desarrolladas.

### desarrollo en espiral
**Definición.** Un modelo de creación de prototipos *cíclico* que
desarrolla la definición e implementación del sistema en pasos
incrementales, disminuyendo el riesgo en cada ciclo. Cada ciclo incluye una
revisión que garantiza el compromiso de los interesados con la solución en
evolución.
**Fuente:** clase 6, diapositiva 147. **Grado:** confirmado.

### desarrollo ágil (Agile)
**Definición.** Un método que divide un conjunto de objetivos en pasos
incrementales pequeños, priorizados por el cliente, con planificación
mínima, entregando en cada paso un sistema o subsistema de trabajo.
Se caracteriza por equipos multifuncionales trabajando en ráfagas cortas
("*sprints*"). Incluye metodologías como Programación Extrema (XP), Scrum,
DSDM y modelado ágil.
**Fuente:** clase 6, diapositivas 150 y 151. **Grado:** confirmado.
**No confundir con:** el #t[modelo cascada] ni el #t[desarrollo en
espiral] — el ágil prioriza la entrega incremental rápida sobre la
planificación exhaustiva, que es exactamente lo opuesto del énfasis del
modelo cascada.

---

## Unidad 7 — creación de arquitecturas, Fase A, N²

### síntesis y descubrimiento (crear arquitecturas)
**Definición.** Las dos técnicas primarias para crear una arquitectura de
sistema, las dos beneficiadas por entender el desempeño y las limitaciones
de los sistemas heredados. La **síntesis** modifica o combina sistemas
existentes para satisfacer necesidades nuevas —requiere lógica y buen
conocimiento de esos sistemas—. El **descubrimiento** usa el conocimiento
de arquitecturas existentes para descubrir una nueva —requiere, además,
habilidad de abstracción para reconocer un sistema análogo en otro
dominio—.
**Fuente:** clase 7, diapositiva 10. **Grado:** confirmado.

### métodos de creación de arquitectura (normativo, racional, participativo, heurístico)
**Definición.** Cuatro métodos que apoyan a la síntesis y al descubrimiento,
agrupados en dos familias. **Basados en ciencia (deductivos):**
**normativo** (reglas estrictas ya dadas; el éxito se define siguiéndolas) y
**racional** (soluciones derivadas de objetivos, con técnicas formales y
optimizadas). **Basados en arte (inductivos):** **participativo** (solución
por consenso de grupos, con los interesados involucrados) y **heurístico**
(reglas blandas manejadas por la experiencia y las lecciones aprendidas).
**Fuente:** clase 7, diapositiva 11. **Grado:** confirmado.

### factores de balance de la arquitectura
**Definición.** Los factores que la ingeniería de sistemas equilibra al
elegir entre arquitecturas candidatas: **requerimientos del sistema**,
**función**, **forma**, sencillez, robustez, asequibilidad, complejidad,
imperativos ambientales y factores humanos. La elección de un concepto de
referencia (*baseline*) se hace a pesar de incertidumbres típicamente
grandes y, a veces, de prioridades ambiguas de los clientes.
**Fuente:** clase 7, diapositiva 12. **Grado:** confirmado.
**La esencia de la arquitectura, en una frase:** estructurar, simplificar,
comprometer y balancear.

### descripciones de arquitectura (vistas)
**Definición.** Ninguna figura o diagrama, por sí solo, puede capturar la
arquitectura completa de un sistema: hace falta usar varias vistas o
perspectivas a la vez. Las principales: *renderings* del *spacecraft* y
diagramas de bloques de subsistemas; diagramas de flujo de comunicación;
diagramas de flujo funcionales (diagramas de bloques funcionales); y
diagramas de interfaces de subsistemas —frecuentemente capturados con el
#t[tabla N² (diagrama N²)]—.
**Fuente:** clase 7, diapositiva 14. **Grado:** confirmado.
**La analogía que da la cátedra:** son a la arquitectura de un sistema
espacial lo que los planos, cotas, elevaciones, plantas, presupuestos y
planos de cableado son a un edificio, en la ingeniería civil.

### SRR — Revisión de Requerimientos de Sistema
**Definición.** La primera de las dos revisiones técnicas primarias de la
Fase A, a cargo de un equipo técnico externo. Confirma que los
requerimientos de alto nivel están claramente definidos y ajustados a los
objetivos de los interesados, que fluyeron correctamente hacia abajo; que
las interfaces internas y externas están definidas; que los riesgos del
desarrollo están identificados con un plan para abordarlos; y que existe un
Plan de Gestión de la Ingeniería de Sistemas y un plan inicial de
Verificación y Validación. **Establece el baseline de los Requerimientos de
Sistema.**
**Fuente:** clase 7, diapositivas 41 y 45. **Grado:** confirmado.

### MDR — Revisión de Diseño de Misión
**Definición.** La segunda revisión técnica primaria de la Fase A, posterior
a la SRR. Evalúa si el concepto *baseline* —ya más maduro y con más
detalle— es razonable, alcanzable y completo; si es consistente con los
recursos disponibles (masa, potencia) y con costos y planificación; si los
riesgos mayores están identificados con estrategias de mitigación; y si los
planes de maduración tecnológica están en curso para terminar en la Fase B.
**Establece el baseline Funcional.**
**Fuente:** clase 7, diapositivas 44 y 45. **Grado:** confirmado.
**Cuidado con la sigla:** la diapositiva 45 la nombra también *System
Definition Review* (SDR/MDR) — la cátedra usa las dos siglas para la misma
revisión, sin distinguirlas.

---

## Pendiente

No queda ninguna unidad pendiente: las 7 unidades y el glosario (M00-M27)
están escritas. Lo que sigue es la fase 3 (cobertura contra los
parcialitos) y la fase 4 (publicación) — ver PDP.md.
