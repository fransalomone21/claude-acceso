# Thinking in Systems — Donella Meadows (2008)

**Fuente:** `C:\Users\frans\Downloads\Meadows-2008.-Thinking-in-Systems.pdf`,
235 pp. de PDF / 213 pp. de libro. Earthscan, 2008; manuscrito de 1993,
publicado póstumo y editado por Diana Wright.
**Extraído con PyMuPDF** a `_tis.txt` (432.347 chars, ~108k tokens).
Control positivo: `'Leverage' in t` → True; `t.count('feedback') > 50` → True.

**Offset de páginas:** PDF = libro + 17. Las anclas de esta ficha van con el
número de página *del libro*, que es el que aparece impreso.

**Leído dirigido**, no de cero: `leverage-points.md` (Meadows 1999) ya destiló
el capítulo 6. Acá se busca *el desarrollo* de esos 12 puntos y —sobre todo—
lo que el paper corto no tiene: la mecánica (stocks, flujos, retardos) y los
arquetipos del capítulo 5.

Ficha: los conceptos que **cambian una decisión** en nuestro sistema (Fran +
Claude + el repo + la máquina). Lo que se entiende y no cambia nada no está
acá. El pilar —lo que sube a la capa que se lee sola— está al final.

---

## La tesis, en una frase

El comportamiento de un sistema **sale de su estructura**, no de los eventos
que lo golpean. El Slinky rebota porque es un Slinky; la mano sólo soltó un
comportamiento que ya estaba latente en la estructura del resorte. La caja en
que vino el Slinky, soltada igual, no hace nada.

> "The system, to a large extent, causes its own behavior! An outside event
> may unleash that behavior, but the same outside event applied to a
> different system is likely to produce a different result." (p. 2)

Corolario que duele: los problemas que **no se van** —los que resisten años de
inteligencia y esfuerzo— son sistémicos. Nadie los quiere y persisten igual,
porque son el comportamiento característico de una estructura que sigue en pie
(p. 4).

---

## Capítulo 1 — Los básicos

### 1.1 Elementos < interconexiones < propósito

Un sistema son tres cosas: **elementos**, **interconexiones** y una **función o
propósito**. Y el orden de importancia es el inverso al de visibilidad:

| Se cambia… | Efecto | Ejemplo de Meadows |
|---|---|---|
| los elementos | el menor | cambiás los once jugadores y sigue siendo el mismo equipo |
| las interconexiones | grande | cambiás las reglas de fútbol por las de básquet y es otro juego |
| el propósito | drástico | mismos jugadores, mismas reglas, la meta pasa a ser perder |

> "The least obvious part of the system, its function or purpose, is often the
> most crucial determinant of the system's behavior." (p. 16)

**Nuestra traducción.** Los elementos de nuestro sistema son: qué modelo, qué
skill, qué archivo, qué agente. Las interconexiones son: qué hook inyecta qué,
qué lee `CLAUDE.md`, qué escribe `aprender.py` y dónde. El propósito es el
triángulo de hierro. Cambiar de Sonnet a Opus es cambiar un elemento — el
escalón de menos efecto, coherente con el #12 de *Leverage Points*.

**Qué cambia:** cuando algo no funciona, la pregunta no arranca en "¿qué
elemento reemplazo?" sino en "¿la interconexión existe?" y "¿el propósito real
es el que declaramos?".

### 1.2 El propósito se deduce del comportamiento, nunca de la retórica

Esta es, para nosotros, la línea más filosa del capítulo.

> "If a government proclaims its interest in protecting the environment but
> allocates little money or effort toward that goal, environmental protection
> is not, in fact, the government's purpose. **Purposes are deduced from
> behavior, not from rhetoric or stated goals.**" (p. 14)

Es exactamente el hueco que `leverage-points.md` dejó abierto en su sección
final: el triángulo de hierro es una meta *declarada*, y la meta *real* de este
sistema, medida por lo que produce, sigue siendo mayormente resolver el
problema de hoy. Meadows da acá el método para auditarlo, y es barato:
**mirá dónde se fue el esfuerzo, no qué dice el documento.**

**Qué cambia:** para saber cuál es la meta real de una sesión, se cuenta en qué
se gastaron los turnos, no qué dice el `CLAUDE.md`. Es una medición, no una
lectura — y es la misma forma de la lección 19 ("el estado del entorno se mide,
no se lee"), aplicada a las intenciones en vez de a la máquina.

### 1.3 Los sub-propósitos que suman a un resultado que nadie quiere

> "One of the most frustrating aspects of systems is that the purposes of
> subunits may add up to an overall behavior that no one wants." (p. 15)

Cada actor puede ser racional y bienintencionado y el total dar pésimo. Y:
"Keeping sub-purposes and overall system purposes in harmony is an essential
function of successful systems" (p. 16).

**Nuestro caso concreto:** el sub-propósito de cada subagente es *responder
bien lo que le preguntaron*; el sub-propósito de cada respuesta es *no dejar al
usuario esperando*. Ninguno de los dos es "que la sesión siguiente arranque
sabiendo". Los dos fan-outs de ~600k tokens no fueron irracionales por parte de
ningún actor: fue la suma.

### 1.4 Stocks y flujos: el stock es la memoria de los flujos

Un **stock** es lo que se puede contar en un instante: agua en la bañera,
plata en el banco, confianza, la reserva de buena voluntad. Un **flujo** es lo
que lo llena o lo vacía. "A stock is the present memory of the history of
changing flows within the system" (p. 18).

Tres cosas de acá que sí cambian decisiones:

**(a) Un stock se puede subir bajando el desagüe, no sólo abriendo la canilla.**

> "There's more than one way to fill a bathtub!" (p. 22)

La mente se fija primero en los stocks, después en los flujos de entrada, y
casi nunca en los de salida. Prolongar una economía petrolera descubriendo más
petróleo y quemando menos petróleo son **el mismo efecto** sobre el stock.

*Traducción:* el stock que nos importa es **conocimiento disponible al abrir la
sesión**. Todo el esfuerzo histórico se fue a la canilla (aprender más,
documentar más). El desagüe —lo que se pierde entre el final de una sesión y el
principio de la siguiente— recién se tapó con los hooks. Ante "¿cómo mejoramos
X?", preguntar siempre las dos: *¿cómo entra más?* y *¿cómo se pierde menos?*

**(b) Los stocks cambian despacio aunque los flujos cambien de golpe.**

> "Stocks generally change slowly, even when the flows into or out of them
> change suddenly. Therefore, stocks act as delays or buffers or shock
> absorbers in systems." (p. 23)

*Traducción:* una regla nueva en `CLAUDE.md` es un cambio de flujo instantáneo.
El stock que importa —la conducta efectiva a lo largo de las sesiones— se mueve
con retardo. Medir el efecto de una regla el mismo día que se escribe es medir
el flujo y creer que se midió el stock. Y al revés: **no darse por vencido
temprano.** "If you have a sense of the rates of change of stocks, you don't
expect things to happen faster than they can happen. You don't give up too
soon" (p. 23).

**(c) Los stocks existen para desacoplar los flujos.**

Permiten que entrada y salida sean independientes y estén temporalmente
desbalanceadas (p. 24). Es la función del buffer, y es por qué existe el
`ESTADO_ACTUAL.md`: desacopla el ritmo al que se descubre algo del ritmo al que
se lo necesita.

### 1.5 Un comportamiento que persiste delata un lazo

> "If you see a behavior that persists over time, there is likely a mechanism
> creating that consistent behavior. That mechanism operates through a feedback
> loop. **It is the consistent behavior pattern over a long period of time that
> is the first hint of the existence of a feedback loop.**" (p. 25)

**Qué cambia:** un error que vuelve dos veces no es un evento repetido: es la
firma de un lazo. Deja de tratarse como incidente ("me olvidé otra vez") y pasa
a tratarse como estructura ("¿qué lazo lo está produciendo?"). Esto es lo que
convierte la lección 11 —*una regla que depende de recordarla no es una
regla*— de una observación en una consecuencia derivable.

### 1.6 Un lazo de realimentación puede fallar de siete maneras distintas

Meadows enumera, casi al pasar, el diagnóstico completo de por qué un lazo
negativo existe y no funciona (p. 30):

> "Feedbacks […] can fail for many reasons. Information can arrive **too
> late** or at the **wrong place**. It can be **unclear** or **incomplete** or
> **hard to interpret**. The action it triggers may be **too weak** or
> **delayed** or **resource-constrained** or simply **ineffective**."

Ésta es la lista de chequeo que nos faltaba para el "verificar el efecto, no la
precondición". Cuando un hook, un test o un aviso está puesto y el error igual
pasa, la causa es una de esas ocho. Vale la pena recorrerlas en orden en vez de
suponer que el aviso "no se leyó".

*Ejemplo nuestro, del propio historial:* `skipWorkflowUsageWarning: true` es el
caso "acción desactivada". El aviso de desactualización del chequeo de
lecciones es el caso "llega tarde". Una skill de consulta de 42 KB que hay que
invocar es el caso "lugar equivocado".

### 1.7 Etiquetas sin dirección

Detalle de método que vale la pena robar: Meadows etiqueta sus diagramas
"stored energy in body", nunca "low energy level"; "coffee intake", nunca "more
coffee". Porque **el lazo funciona en las dos direcciones** y una etiqueta
direccional esconde la mitad del comportamiento (p. 28).

*Traducción:* al escribir una regla o una hipótesis, nombrá la **variable**, no
el sentido en el que la viste moverse. Es el complemento exacto de la lección
que ya tenemos ("un efecto probado en un sentido no prueba el inverso"): ahí el
riesgo es asumir simetría; acá es no ver que el mecanismo es simétrico y quedar
ciego a la mitad de sus efectos. Las dos se resuelven igual: **escribir la
dirección explícitamente, y por separado de la variable.**

---

## Capítulo 2 — El zoológico de sistemas

Es el capítulo de mecánica. La mayor parte es cultura general —la bañera, el
termostato, la población— pero tiene tres cosas que sí cambian decisiones.

### 2.1 "High leverage, wrong direction" — el caso completo, y es el nuestro

El ejemplo es una concesionaria de autos con tres retardos: de **percepción**
(promedia las ventas de 5 días antes de creerle a una suba), de **respuesta**
(cubre un tercio del faltante por pedido) y de **entrega** (5 días de la
fábrica). Sube la demanda 10%, de una vez y para siempre. Resultado:
**oscilaciones** (p. 54).

La dueña —que es un sistema que aprende— decide arreglarlo **reaccionando más
rápido**: baja la percepción de 5 días a 2. Empeora un poco. Baja el retardo de
respuesta de 3 días a 2. **Empeora muchísimo** (p. 56).

Lo que había que hacer era lo contrario: **subir** el retardo de respuesta de 3
a 6 días. Las oscilaciones se amortiguan y el sistema encuentra su equilibrio
nuevo rápido y limpio (p. 57).

> "'High leverage, wrong direction,' the system-thinking car dealer says to
> herself […] someone trying to fix a system is attracted intuitively to a
> policy lever that in fact **does** have a strong effect on the system. And
> then the well-intentioned fixer pulls the lever in the wrong direction!"
> (p. 57)

**Por qué esto es exactamente nuestro problema.** Nuestro lazo de
autoperfeccionamiento es un lazo negativo con los tres retardos:

| Retardo de Meadows | El nuestro |
|---|---|
| percepción | cuántas veces tiene que fallar algo antes de que lo llamemos patrón |
| respuesta | cuánto de la corrección se aplica de una (una lección → una línea nueva del chequeo) |
| entrega | **una sesión entera**: lo aprendido hoy recién actúa cuando el hook lo inyecta mañana |

El retardo de entrega no lo podemos bajar de una sesión: el hook corre al
abrir. Y el instinto ante "esto falló otra vez" es reaccionar más rápido y más
fuerte —agregar la regla ya, subirle el volumen—. Meadows muestra, con
simulación, que en un sistema con retardo de entrega fijo **eso amplifica la
oscilación**. La oscilación nuestra tiene forma conocida: reglas que se agregan,
se contradicen, se corrigen y se vuelven a agregar.

**Qué cambia, concreto:** ante un fallo, no se agrega la regla en el mismo
turno por reflejo. Se pregunta primero *cuántas veces pasó* (el filtro de
percepción que ya tiene `/lecciones-aprendidas`) y se aplica **una fracción**
de la corrección, no la corrección entera. La lección 26 —"no subir al pilar lo
que ya está"— es este amortiguador escrito de otra forma, y ahora se sabe por
qué funciona.

### 2.2 El termostato: la meta hay que ponerla por encima del objetivo

Dos lazos negativos peleando por un mismo stock: el horno que calienta y la
fuga al exterior. El cuarto se estabiliza **siempre por debajo** de donde está
puesto el termostato, porque mientras el horno corrige, sigue fugando.

> "A stock-maintaining balancing feedback loop must have its goal set
> appropriately to compensate for draining or inflowing processes that affect
> that stock. Otherwise, the feedback process will fall short of […] the target
> for the stock." (p. 40)

**Traducción:** todo stock nuestro tiene una fuga permanente. El contexto se
consume mientras se trabaja; la disciplina se afloja mientras se ejecuta; la
documentación envejece mientras se escribe. Si el objetivo es "cortar el chat
al 50% de ventana", el umbral hay que ponerlo **abajo** del 50%, porque entre
que se detecta y que se corta se consume más. Un objetivo puesto justo en el
valor deseado se incumple siempre, y no por falta de disciplina: por estructura.

### 2.3 La información de un lazo sólo puede afectar el futuro

> "The information delivered by a feedback loop—even nonphysical feedback—can
> only affect **future** behavior; it can't deliver a signal fast enough to
> correct behavior that drove the current feedback." (p. 39)

Obvio dicho así, y sin embargo es la razón estructural de por qué el
aprendizaje de una sesión **nunca** puede arreglar esa sesión, y de por qué
`ESTADO_ACTUAL` + `HANDOFF` + commit + push no son burocracia: son el único
canal por el que la señal llega a un momento donde todavía puede actuar.

### 2.4 Misma estructura de lazos ⇒ mismo comportamiento, aunque no se parezcan

> "Systems with similar feedback structures produce similar dynamic behaviors,
> even if the outward appearance of these systems is completely dissimilar."
> (pp. 50-51)

Una población y una economía industrial no se parecen en nada y se comportan
igual, porque las dos tienen un lazo reforzador de reproducción y uno
balanceador de muerte.

**Qué cambia:** habilita transferir un diagnóstico entre dominios que no se
parecen, siempre que se haya identificado la estructura de lazos —y **sólo** si
se identificó. Es la licencia para decir "esto es el mismo animal que aquello",
y también el límite: el parecido tiene que ser de lazos, no de apariencia.

### 2.5 Tres preguntas para auditar cualquier escenario o predicción

Meadows las pone como recuadro (p. 47), y sirven tal cual para auditar una
estimación, un plan o la propuesta de un documento externo:

1. **¿Es probable que los factores impulsores se desplieguen así?**
   (No se puede contestar con hechos: es una apuesta sobre el futuro.)
2. **Si lo hicieran, ¿reaccionaría el sistema así?**
   (Ésta sí es científica: es una pregunta sobre la calidad del modelo.)
3. **¿Qué está impulsando a los factores impulsores?**
   (Ésta es una pregunta sobre **dónde se puso la frontera del sistema**: los
   supuestos "independientes" ¿son de verdad independientes, o están adentro?)

> "Model utility depends not on whether its driving scenarios are realistic
> (since no one can know that for sure), but on whether it responds with a
> realistic pattern of behavior." (p. 48)

La pregunta 3 es la que más nos falta. Cuando se estima "esto son dos
sesiones", el factor impulsor es "cuánto rinde una sesión", y eso no es
independiente: depende del contexto que se quema, que depende de cuánto haya
que re-derivar, que depende de qué tan buena fue la sesión anterior.

### 2.6 Mejorar la eficiencia puede matar la señal que frenaba al sistema

El caso de la pesquería. La flota crece, los peces bajan, el rendimiento por
barco cae y esa caída es el lazo negativo que frena la inversión. Entonces
llega el sonar: **mejora la eficiencia** y sostiene la captura por barco un rato
más. Resultado: el sistema pasa de estabilizarse suavemente a oscilar (p. 70);
con un poco más de eficiencia, a colapsar del todo, peces y flota (p. 71).

La eficiencia no rompió el recurso. Rompió **la señal**: el mecanismo por el
cual la escasez se hacía sentir a tiempo.

**Traducción, y es incómoda:** cada mejora que hace más barato quemar contexto
—mejor compresión, herramientas más rápidas, resúmenes más eficientes— debilita
la señal "se está poniendo caro" que es lo único que hace cortar el chat a
tiempo. No es un argumento para no mejorar la eficiencia: es un argumento para
que, **cuando se mejora la eficiencia de la extracción, haya que reponer
explícitamente la señal que esa mejora acaba de silenciar.**

### 2.7 Stock-limitado vs. flujo-limitado

- **No renovable = limitado por stock.** Está todo disponible de una; cuanto más
  rápido se extrae, menos dura. La ventana de contexto de una sesión es esto.
- **Renovable = limitado por flujo.** Aguanta extracción indefinida, pero sólo
  hasta el caudal de regeneración. Pasado un umbral crítico, **se vuelve no
  renovable**. La atención de Fran, la confianza en el sistema y la disciplina
  del método son esto.

La confusión de categorías es cara: tratar un recurso de flujo como si fuera de
stock (exprimirlo hasta el fondo porque "todavía queda") es el mecanismo exacto
de la pesquería colapsada.

Y el dato que acompaña: **una cantidad que crece exponencialmente hacia un
límite lo alcanza sorprendentemente rápido.** Duplicar o cuadruplicar el
recurso corre el pico apenas ~14 años en el modelo del petróleo (p. 63).
Duplicar la ventana de contexto no duplica lo que se puede hacer en una sesión;
corre el problema un poco.

---

## Capítulo 3 — Por qué los sistemas funcionan tan bien

Tres propiedades: resiliencia, auto-organización, jerarquía.

### 3.1 Resiliencia no es estabilidad, y por eso se sacrifica sin darse cuenta

> "Placing a system in a straitjacket of constancy can cause fragility to
> evolve." — C. S. Holling (p. 76)

La resiliencia sale de **muchos lazos negativos redundantes**, operando por
mecanismos distintos y a escalas de tiempo distintas, uno entrando cuando otro
falla. Por encima hay meta-resiliencia (lazos que reconstruyen lazos) y
meta-meta-resiliencia (lazos que aprenden y diseñan lazos nuevos).

Lo importante es la distinción:

> "Static stability is something you can **see** […] Resilience is something
> that may be very hard to see, unless you exceed its limits, overwhelm and
> damage the balancing loops, and the system structure breaks down. **Because
> resilience may not be obvious without a whole-system view, people often
> sacrifice resilience for stability, or for productivity**, or for some other
> more immediately recognizable system property." (p. 77)

Y la imagen que lo hace inolvidable: la resiliencia es una **meseta** por la
que el sistema puede andar, con paredes elásticas que lo devuelven si se acerca
al borde. A medida que la pierde, la meseta se angosta y las paredes se vuelven
bajas y rígidas, hasta que opera sobre el filo.

> "Loss of resilience can come as a surprise, because the system usually is
> **paying much more attention to its play than to its playing space**. One day
> it does something it has done a hundred times before and crashes." (p. 78)

**Qué agrega esto a lo que ya sabíamos.** `leverage-points.md` (Hallazgo 3) ya
tiene "el freno que se saca porque nunca salta". Esto explica **por qué es tan
fácil sacarlo**: la estabilidad se ve semana a semana; la resiliencia sólo se
ve el día que se acaba. El ejemplo de Meadows es *just-in-time*: bajó costos y
bajó inestabilidad de inventarios, y volvió al sistema vulnerable a cualquier
perturbación de combustible, tráfico, computadoras o mano de obra. Es el mismo
trato que hacemos cada vez que apretamos una sesión al máximo.

*Sin evidencia todavía, y anotado como pendiente:* nuestro sistema no tiene
redundancia de lazos. `verify-install.ps1` es el único verificador, y sólo corre
si se lo invoca. Un solo lazo negativo no es resiliencia, es un punto único de
falla.

### 3.2 Auto-organización: sale de pocas reglas simples

Un copo de Koch, un helecho, el ADN: estructuras de complejidad enorme
generadas por **muy pocas reglas de organización** (pp. 80-81). Y la
auto-organización se sacrifica, igual que la resiliencia, por productividad y
estabilidad de corto plazo; requiere "freedom and experimentation, and a certain
amount of disorder" (p. 80).

**Qué cambia:** un perfil que crece por acumulación de reglas específicas va en
contra de esto. La forma correcta de que el método se vuelva capaz de más cosas
no es una lista más larga, sino **menos reglas y más generativas**. Es el
argumento estructural a favor de que el Nivel 0 sea corto: no es ahorro de
tokens, es que las reglas generativas producen conducta correcta en casos que
nadie enumeró.

### 3.3 Hora y Tempus: por qué el checkpoint no es burocracia

Dos relojeros hacen relojes de mil piezas. Tempus arma el reloj entero de una;
cuando suena el teléfono y suelta la pieza, **todo se desarma y empieza de
cero**. Hora arma subconjuntos estables de diez piezas, después diez de esos, y
después diez de esos. Cuando lo interrumpen, pierde una fracción chica. Hora
prospera; Tempus se funde — y se funde **más rápido cuanto más clientes tiene**,
porque cada cliente es una interrupción (pp. 82-83).

> "Complex systems can evolve from simple systems only if there are **stable
> intermediate forms**. […] Among all possible complex forms, hierarchies are
> the only ones that have had the time to evolve." (p. 83)

**Esto es la regla 5 del perfil, con su mecanismo.** `ESTADO_ACTUAL` + `HANDOFF`
+ commit + push, y la ficha escrita cada ~60 páginas en vez de al final, son
formas intermedias estables. No suben al pilar —ya están, y duplicarlas sería
la lección 26— pero ahora se sabe **por qué** funcionan y, sobre todo, **cuándo
son obligatorias**: el tamaño del subconjunto estable se elige contra la
frecuencia de interrupción, no contra el gusto. Cuanto más probable es que te
corten (ventana de contexto, tiempo de Fran, un límite de plan), más chico
tiene que ser el bloque que se cierra.

### 3.4 Las jerarquías existen para servir a los de abajo

> "The original purpose of a hierarchy is always to help its originating
> subsystems do their jobs better. This is something, unfortunately, that both
> the higher and the lower levels of a greatly articulated hierarchy easily can
> forget." (p. 84)

Las jerarquías evolucionan de abajo hacia arriba, y su función es **reducir la
cantidad de información que cada parte tiene que rastrear**: los vínculos
adentro de un subsistema son más densos que entre subsistemas.

Los dos modos de falla son simétricos:
- **Subotimización**: la meta del subsistema domina a costa de la del total.
- **Demasiado control central**: si el cerebro controlara cada célula al punto
  de impedirle mantenerse, el organismo muere (p. 85).

**Qué cambia:** `perfil-global/` es la capa de arriba y existe para que los
proyectos —BLACK, electrónica, lo que venga— hagan mejor su trabajo. El día que
seguir el método cueste más de lo que rinde en el proyecto, la jerarquía está
fallando, y la respuesta correcta es aflojar la capa de arriba, no exigirle más
al proyecto. Y al revés: el proyecto que optimiza su propia sesión quemando el
método está subotimizando.

---

## Capítulo 4 — Por qué los sistemas nos sorprenden

Es el capítulo con más densidad de reglas por página del libro. Meadows lo
llama, textual, "a warning list".

### 4.1 Evento → comportamiento → estructura

> "Events are the outputs, moment by moment, from the black box of the system.
> […] It's endlessly engrossing to take in the world as a series of events, and
> constantly surprising, because that way of seeing the world **has almost no
> predictive or explanatory value**." (p. 88)

Tres niveles de profundidad:

| Nivel | Qué es | Qué te permite |
|---|---|---|
| Evento | "falló el hook hoy" | nada; entretiene |
| Comportamiento | "falla cada vez que hay una carpeta nueva" | predecir |
| Estructura | stocks, flujos y lazos que lo producen | **cambiarlo** |

> "When a systems thinker encounters a problem, the first thing he or she does
> is look for **data, time graphs, the history of the system**. That's because
> long-term behavior provides clues to the underlying system structure." (p. 89)

**Qué cambia, y es la línea más operativa del capítulo:** ante un fallo, el
primer movimiento no es diagnosticarlo — es **preguntar cuántas veces pasó y
cuándo**. Eso es exactamente lo que `lecciones.jsonl` y el historial de git
permiten hacer en segundos y casi nunca hacemos. Un fallo aislado se arregla;
un fallo con historia se rediseña, y son cosas distintas que se ven idénticas
desde adentro del turno.

Corolario del budworm (p. 93): *"If you're doing event-level analysis, you will
blame the outburst on the warm, dry springs."* El evento gatillo siempre está
disponible y siempre es convincente.

### 4.2 Los flujos no se relacionan con flujos: responden a stocks

> "There's no reason to expect any flow to bear a stable relationship to any
> other flow. Flows go up and down, on and off, in all sorts of combinations,
> **in response to stocks, not to other flows**." (p. 90)

Buscar la correlación entre dos flujos es buscar algo que no existe. Funciona
mientras la estructura no cambie, y se rompe justo cuando la necesitás —cuando
alguien abre una ventana o cambia el aislamiento.

**Qué cambia:** correlacionar "tokens gastados" con "calidad del resultado" son
dos flujos. La relación entre ellos no es estable y no tiene por qué serlo. Lo
que hay que mirar es el stock que los conecta: **cuánto contexto útil hay
cargado en ese momento**. Es la misma trampa que la lección de "identificá al
actor por efecto antes de medirlo", con la forma sistémica.

### 4.3 No linealidad: la causa no produce un efecto proporcional

Y lo más importante no es que rompa la intuición sobre magnitudes:

> "Nonlinearities are important not only because they confound our expectations
> about the relationship between action and response. They are even more
> important because they **change the relative strengths of feedback loops**.
> They can flip a system from one mode of behavior to another." (p. 92)

La no linealidad es la causa principal del *shifting dominance*: el sistema
venía comportándose de una manera y de golpe se comporta de otra, sin que nadie
haya cambiado nada.

**Qué cambia:** un procedimiento que funcionó veinte veces puede dejar de
funcionar sin que se haya tocado nada, porque un stock cruzó un umbral. Ante
"esto siempre funcionó y hoy no", la primera hipótesis no es "lo hice mal": es
**qué stock creció desde la última vez**.

### 4.4 Las nubes son el borde de tu modelo, no el borde del sistema

Las "nubes" de los diagramas marcan dónde dejaste de mirar. Casi nunca marcan
un límite real.

> "When you draw boundaries too narrowly, the system surprises you." (p. 97)

Y la trampa simétrica, que Meadows le adjudica explícitamente a los analistas
de sistemas: hacer los bordes **demasiado grandes**, el juego de "mi modelo es
más grande que el tuyo", que produce análisis enormes cuya única función es
tapar la respuesta a la pregunta que se hizo (p. 98).

> "There is no single, legitimate boundary to draw around a system. We have to
> invent boundaries for clarity and sanity; and boundaries can produce problems
> when we forget that we've artificially created them." (p. 97)
>
> "Where to draw a boundary around a system depends on **the purpose of the
> discussion—the questions we want to ask**." (p. 97)

También, de Hardin, sobre el lenguaje:

> "A fundamental misconception is embedded in the popular term 'side-effects'
> […] This phrase means roughly 'effects which I hadn't foreseen or don't want
> to think about.' […] Side-effects no more deserve the adjective 'side' than
> does the 'principal' effect." (p. 95)

**Qué cambia:** el borde se redibuja **por pregunta**, no por sesión ni por
proyecto. Y "efecto secundario" es una palabra que hay que dejar de usar: si
apareció, es un efecto.

### 4.5 La ley del mínimo: sólo importa el factor limitante — y se mueve

Liebig: no importa cuánto nitrógeno tenga el trigo si lo que falta es fósforo.
Echar más fósforo no sirve de nada si lo que falta es potasio (p. 101).

> "At any given time, the input that is most important to a system is the one
> that is most limiting."

Y la segunda mitad, que es la que casi nadie usa:

> "Insight comes not only from recognizing which factor is limiting, but from
> seeing that **growth itself depletes or enhances limits and therefore changes
> what is limiting**. […] To shift attention from the abundant factors to the
> next potential limiting factor is to gain real understanding of, and control
> over, the growth process." (p. 102)

El modelo de crecimiento corporativo de Forrester: contratan vendedores buenos
→ el límite pasa a ser la capacidad de producción → invierten en plantas → el
límite pasa a ser la pericia de la mano de obra → invierten en capacitación →
el límite pasa a ser el sistema de pedidos. Cada límite resuelto **fabrica el
siguiente**.

**Qué cambia:** optimizar el factor abundante no hace nada, por bien hecho que
esté. Y la respuesta a "¿cuál es el cuello de botella?" **vence**: hay que
volver a preguntarla después de cada mejora, porque la mejora la cambió. Nuestro
caso documentado: mientras el cuello de botella era que lo aprendido no llegaba
a la sesión siguiente, optimizar tokens era echar fósforo. Resuelto eso con los
hooks, el cuello de botella ya **no es** ése — y no sabemos cuál es, porque
todavía no lo volvimos a preguntar.

### 4.6 Retardos: multiplicá por tres

Jay Forrester, sobre estimar cualquier retardo de construcción o de proceso:
preguntarle a todos los del sistema cuánto creen que tarda, hacer la mejor
estimación, y **multiplicarla por tres**. Meadows agrega que le funciona
perfecto para estimar cuánto tarda en escribir un libro (p. 103).

> "Overshoots, oscillations, and collapses are always caused by delays." (p. 105)
>
> "When there are long delays in feedback loops, **some sort of foresight is
> essential. To act only when a problem becomes obvious is to miss an important
> opportunity to solve the problem.**" (p. 105)

Y el equilibrio, que completa el §2.1: responder con retardo desvía la decisión;
responder demasiado rápido "may nervously amplify short-term variation and
create unnecessary instability".

### 4.7 Racionalidad acotada: cambiar al actor no cambia el resultado

El corazón del capítulo, y la línea más aplicable de todo el libro a nuestro
sistema.

La gente decide razonablemente **con la información que tiene**. No es
estupidez: es que desde ese lugar del sistema no se ve otra cosa. Meadows
enumera además cómo deformamos incluso la información que sí tenemos:
sobrestimamos unos riesgos y subestimamos otros, **vivimos en un presente
exagerado** —demasiado peso a lo reciente, muy poco a lo pasado— y "we don't
let in at all news we don't like, or information that doesn't fit our mental
models" (p. 107).

Y entonces:

> "**Taking out one individual from a position of bounded rationality and
> putting in another person is not likely to make much difference.** Blaming
> the individual rarely helps create a more desirable outcome. […] What makes a
> difference is redesigning the system to improve the information, incentives,
> disincentives, goals, stresses, and constraints that have an effect on
> specific actors." (pp. 108, 110)

**Por qué esto nos pega directo.** El reflejo ante un mal resultado es *subir el
modelo*, *meter un subagente mejor*, *usar más effort*. Todo eso es **poner otro
actor en la misma posición de racionalidad acotada** — y es, en la escala de
*Leverage Points*, el puesto 12. Si Claude abre una sesión sin saber qué se
decidió ayer, un Claude mejor abre la sesión sin saber qué se decidió ayer. Ésta
es la demostración, desde la teoría, de por qué los hooks rindieron más que
cualquier cambio de modelo que hayamos hecho.

Y el caso de los medidores holandeses aparece acá, en el capítulo 4, con el
detalle completo: suburbio de Ámsterdam, casas idénticas, mismo precio de la
electricidad, familias parecidas; las que tenían el medidor en el hall de
entrada consumían **un tercio menos** que las que lo tenían en el sótano
(p. 109). El pilar actual dice "30%", que es la cifra del paper de 1999; el
libro dice "one-third". Misma historia, ninguna corrección necesaria.

---

## Capítulo 5 — Las trampas: el catálogo, y cuáles son las nuestras

Éste es el capítulo que el paper de *Leverage Points* no tiene, y la razón
principal para haber leído el libro.

Un **arquetipo** es una estructura que aparece una y otra vez en sistemas que
no se parecen en nada, y que produce un patrón de comportamiento problemático
característico. Meadows insiste en el punto que las vuelve útiles:

> "The destruction they cause is often blamed on particular actors or events,
> although it is actually a consequence of system structure. **Blaming,
> disciplining, firing, twisting policy levers harder, hoping for a more
> favorable sequence of driving events, tinkering at the margins—these standard
> responses will not fix structural problems.**" (p. 112)

Las ocho, con la salida, y el veredicto honesto sobre si nos aplica:

| Trampa | Estructura | Salida | ¿Nuestra? |
|---|---|---|---|
| **Resistencia a la política** | varios actores tiran de un mismo stock hacia metas distintas; todos gastan energía en mantenerlo donde nadie lo quiere | soltar, o encontrar una meta mayor que alinee a todos | sí, en chico |
| **Tragedia de los comunes** | beneficio individual, costo compartido; falta el lazo del recurso al usuario | educar + **reponer el lazo faltante**: privatizar o regular | sí |
| **Deriva a bajo desempeño** | el estándar se ajusta al desempeño percibido, y la percepción está sesgada a lo malo | estándar absoluto, o anclado en el **mejor** resultado pasado | sí, y es la que más duele |
| **Escalada** | cada actor fija su meta en superar al otro | desarme unilateral, o negociar lazos de control | no, por ahora |
| **Éxito al exitoso** | ganar da los medios para volver a ganar | diversificar, limitar, emparejar la cancha | sí |
| **Trasladar la carga al interventor** (adicción) | la intervención tapa el síntoma y **atrofia** la capacidad propia del sistema | fortalecer la capacidad propia y **retirarse** | sí, y es estructural |
| **Elusión de la regla** | cumplimiento aparente: la letra sí, el espíritu no | rediseñar la regla hacia su propósito, no endurecerla | sí |
| **Buscar la meta equivocada** | el indicador no mide lo que importa; el sistema lo produce obedientemente | indicadores que reflejen el bienestar real; **no confundir esfuerzo con resultado** | sí |

### 5.1 Deriva a bajo desempeño — y el sesgo de nuestro propio registro

El mecanismo: hay un lazo negativo normal (estándar vs. estado real) que
debería sostener el desempeño. Pero **el actor le cree más a las malas noticias
que a las buenas**: los mejores resultados se descartan como excepción, los
peores quedan en la memoria. Y como el estándar deseado se ajusta al estado
*percibido*, el estándar baja. Menos discrepancia, menos corrección, peor
estado, estándar más bajo. El lazo negativo queda tapado por un reforzador
cuesta abajo (p. 122). El otro nombre es **metas que se erosionan**, y el
tercero es la rana hervida.

> "There are two antidotes to eroding goals. One is to keep standards absolute,
> regardless of performance. Another is to **make goals sensitive to the best
> performances of the past, instead of the worst.** […] The reinforcing loop
> going downward […] becomes a reinforcing loop going upward: 'The better things
> get, the harder I'm going to work to make them even better.'" (p. 123)

**Observación incómoda sobre nuestro sistema, y la marco como hipótesis, no
como efecto medido.** `lecciones.jsonl` son 32 entradas y las 32 son fracasos.
El chequeo que se inyecta en cada sesión es, textual, "cada línea es un error
que ya se cometió". No hay ningún registro de qué salió bien ni de cuál fue el
mejor trabajo hecho hasta ahora. Es exactamente la memoria sesgada a lo peor
que describe el arquetipo.

No estoy afirmando que las metas se estén erosionando: eso habría que medirlo, y
el registro de fracasos cumple una función distinta —reconocer un síntoma— que
sí funciona y está probada. Lo que sí es un hecho verificable del repo es la
**asimetría**: el sistema tiene un mecanismo para recordar lo que falló y
ninguno para recordar lo que funcionó. Meadows dice que ese es el lado del lazo
que fija el estándar. Queda anotado como candidato concreto para el pipeline de
`aprender.py`, no como cambio a hacer hoy.

### 5.2 Trasladar la carga al interventor — el arquetipo con nuestro nombre

La estructura: un mecanismo correctivo propio del sistema anda mal o
regular. Un interventor eficiente y bienintencionado mira, entra y le saca la
carga de encima. Resuelve rápido. Se felicita. Pero como no se tocó la causa,
el problema vuelve, y hace falta más intervención. Y si la intervención hace que
la capacidad propia se atrofie, **se necesita cada vez más intervención para el
mismo efecto** (p. 133).

> "Addiction is finding a quick and dirty solution to the symptom of the
> problem, which prevents or distracts one from the harder and longer-term task
> of solving the real problem. Addictive policies are insidious, because they
> are **so easy to sell, so simple to fall for**." (p. 133)

Meadows aclara que trasladar la carga puede estar perfecto y hacerse a
propósito: la vacuna contra la viruela es mejor que la inmunidad parcial. La
trampa no es intervenir, es **atrofiar**.

Y da las tres preguntas exactas del interventor (p. 135):

1. ¿Por qué están fallando los mecanismos de corrección propios del sistema?
2. ¿Cómo se sacan los obstáculos a que funcionen?
3. ¿Cómo se los hace más efectivos?

> "If you are the intervenor, work in such a way as to **restore or enhance the
> system's own ability to solve its problems, then remove yourself**." (p. 135)

**Traducción, sin adornos:** este arquetipo describe la relación entre Claude y
el trabajo de Fran mejor que cualquier cosa que tengamos escrita. La versión
sana no es "resolvés el problema": es "la próxima vez el sistema —Fran, el repo,
las herramientas— lo resuelve con menos ayuda". El síntoma de que se cruzó al
lado malo no es que las respuestas sean malas: es que **haga falta más
intervención para el mismo resultado**. Eso es medible.

### 5.3 Buscar la meta equivocada — esfuerzo vs. resultado

> "Systems, like the three wishes in the traditional fairy tale, have a terrible
> tendency to produce **exactly and only what you ask them to produce**. Be
> careful what you ask them to produce." (p. 138)

Si la seguridad nacional se define como gasto militar, el sistema produce gasto
militar. Si la educación se mide por plata por alumno, produce plata por alumno.
En los primeros programas de planificación familiar en India la meta era número
de DIU colocados, y los médicos los colocaron sin consentimiento (p. 139).

> "These examples **confuse effort with result**, one of the most common
> mistakes in designing systems around the wrong goal."

Y el ejemplo mayor: el PBI mide flujo (throughput), no stock; suma bienes y
males; mide esfuerzo y no logro. Una lamparita que da la misma luz con un octavo
de la electricidad y dura diez veces más **hace bajar el PBI** (p. 139).

**Qué cambia:** el criterio de salida de una fase tiene que ser un **resultado
verificable**, no una cantidad de trabajo hecho. "Leí el libro" es esfuerzo;
"la ficha está escrita y el pilar foldeado" es resultado. Es la misma distinción
que ya hace la regla de evidencia del perfil ("confirmado = efecto visto"),
extendida de las hipótesis a las metas.

### 5.4 Elusión de la regla — el cumplimiento aparente

> "Notice that rule beating **produces the appearance of rules being
> followed**." (p. 137)

Vermont pidió aprobación compleja para lotes de diez acres o menos, y ahora
tiene una cantidad extraordinaria de lotes de apenas más de diez acres. Europa
restringió la importación de granos forrajeros y entró mandioca de Asia.

> "Rule beating is usually a response of the lower levels in a hierarchy to
> **overrigid, deleterious, unworkable, or ill-defined rules from above**. […]
> The way out […] is to understand rule beating as **useful feedback**, and to
> revise, improve, rescind, or better explain the rules." (p. 137)

**Qué cambia:** el cuadro de fase puesto de compromiso, el HANDOFF que dice
"seguir donde quedamos", el criterio de salida escrito tan vago que se cumple
solo: eso no es indisciplina, es **retroalimentación sobre la regla**. Si una
regla del perfil se está cumpliendo en la letra y no en el espíritu, la
respuesta correcta no es endurecerla —eso es el camino más adentro de la
trampa— sino preguntarse qué la vuelve impracticable.

Y el cierre del capítulo, la fábula de los veleros de regata (p. 141): las
reglas definieron clases, los diseños se optimizaron hasta el último centímetro
cuadrado de vela dentro de esas clases, y los barcos de la Copa América hoy son
rapidísimos, extremadamente sensibles y **casi innavegables**. Nadie los usaría
para pescar. *"The boats are so optimized around the present rules that they
have lost all resilience. Any change in the rules would render them useless."*
Optimizar contra la métrica hasta el fondo destruye la resiliencia: es la 5.3 y
la 3.1 chocando.

---

## Capítulo 6 — Leverage Points

Es la versión larga del paper de 1999 que ya está destilado en
[`leverage-points.md`](leverage-points.md). **Verificado contra el resumen del
apéndice (p. 194): la lista de los doce y su orden son idénticos** al de la
ficha que ya tenemos. No hay corrección que hacer ni pilar nuevo que sacar de
acá.

---

## Capítulo 7 — Vivir en un mundo de sistemas

El capítulo más honesto del libro, y el que Meadows escribió contra su propia
disciplina.

### 7.1 La confesión

> "We gave learned lectures on the structure of addiction and could not give up
> coffee. We knew all about the dynamics of eroding goals and eroded our own
> jogging programs. We warned against the traps of escalation and shifting the
> burden and then created them in our own marriages." (p. 167)

Y la corrección de expectativa:

> "Self-organizing, nonlinear, feedback systems are inherently unpredictable.
> **They are not controllable.** […] For any objective other than the most
> trivial, we can't optimize; we don't even know what to optimize."
>
> "We can't control systems or figure them out. **But we can dance with them!**"
> (pp. 167, 170)

**Qué cambia:** entender la estructura no produce la conducta. Es la advertencia
directa contra el error de esta misma capa Nivel 0: escribir el pilar no es
haberlo adoptado. Lo único que cierra esa brecha es el mecanismo, que es de lo
que trata la escalera de la lección 11.

### 7.2 Las quince guías, y las cinco que nos cambian algo

La lista completa (p. 194): 1) tomarle el pulso al sistema; 2) exponer los
modelos mentales; 3) honrar y distribuir la información; 4) cuidar el lenguaje;
5) atender a lo importante, no a lo cuantificable; 6) políticas de
realimentación para sistemas de realimentación; 7) ir por el bien del conjunto;
8) escuchar la sabiduría del sistema; 9) ubicar la responsabilidad dentro del
sistema; 10) quedarse humilde, quedarse aprendiz; 11) celebrar la complejidad;
12) expandir los horizontes de tiempo; 13) desafiar las disciplinas; 14) expandir
el círculo de lo que importa; 15) no erosionar la meta de la bondad.

Las que cambian una decisión nuestra:

**(1) Tomarle el pulso antes de tocar nada.**

> "Starting with the behavior of the system forces you to focus on facts, not
> theories. It keeps you from falling too quickly into your own beliefs or
> misconceptions, or those of others." (p. 171)

Y el remate, que es el que vale:

> "Starting with history **discourages the common and distracting tendency we
> all have to define a problem not by the system's actual behavior, but by the
> lack of our favorite solution.** (The problem is, we need to find more oil.
> The problem is, we don't have enough salesmen.)" (p. 171)

Un problema definido como la ausencia de la solución que ya te gustaba no es un
problema: es la solución disfrazada. Se reconoce porque el enunciado ya contiene
el verbo de lo que querías hacer.

**(2) Exponer los modelos mentales.**

> "**Instead of becoming a champion for one possible explanation or hypothesis
> or model, collect as many as possible.** Consider all of them to be plausible
> until you find some evidence that causes you to rule one out. That way you
> will be emotionally able to see the evidence that rules out an assumption
> that may become entangled with your own identity." (p. 172)

El perfil ya pide nombrar la segunda explicación más plausible. Meadows agrega
**la razón**: se juntan varias no por rigor sino para que ninguna se enrede con
la identidad de uno, porque una hipótesis propia deja de poder ser refutada.

**(6) Políticas de realimentación para sistemas de realimentación.**

> "A dynamic, self-adjusting feedback system cannot be governed by a static,
> unbending policy. […] Especially where there are great uncertainties, the best
> policies not only contain feedback loops, but **meta-feedback loops—loops that
> alter, correct, and expand loops. These are policies that design learning into
> the management process.**" (pp. 177-178)

El ejemplo es el Protocolo de Montreal: en 1987 no había certeza sobre el ozono,
así que el protocolo fijó metas **y además** obligó a monitorear y a reconvocar
el congreso para cambiar el cronograma. En 1990 hubo que acelerarlo. La política
traía adentro el mecanismo para corregirse.

**Qué cambia:** una regla nueva del perfil no se escribe sola: se escribe con
**qué la revisaría**. `aprender.py` + `install.ps1` (que avisa cuando la
síntesis quedó atrasada) ya son eso — es el nivel #4, auto-organización, de la
escalera. Lo que falta es hacerlo explícito al escribir cada regla, no sólo
tenerlo como herramienta aparte.

**(9) Ubicar la responsabilidad dentro del sistema — "responsabilidad
intrínseca".**

> "'Intrinsic responsibility' means that the system is designed to send feedback
> about the consequences of decision making **directly and quickly and
> compellingly to the decision makers**. Because the pilot of a plane rides in
> the front of the plane, that pilot is intrinsically responsible." (p. 179)

El contraejemplo es perfecto y es nuestro: Dartmouth sacó los termostatos de las
oficinas y los puso bajo una computadora central, para ahorrar energía. Efecto
observado desde abajo: **más oscilación**. Cuando la oficina se recalentaba,
había que llamar a otra punta del campus, que corregía en horas o días, y que
solía sobrecorregir, lo que obligaba a otra llamada (p. 179). El termostato en
la oficina era responsabilidad intrínseca; centralizarlo alargó el retardo del
lazo, que es §2.1 otra vez.

Diseñar responsabilidad intrínseca: que quien emite aguas residuales al río
ponga su **toma** río abajo de su descarga.

**Qué cambia:** quien decide tiene que comer la consecuencia, rápido y de forma
imposible de ignorar. Nuestra versión: quien decide seguir en el mismo chat es
quien después paga la re-derivación — y hoy eso se paga *dos turnos después*,
difuso. El cuadro de fase es un intento de responsabilidad intrínseca; el
retardo sigue siendo largo.

**(10) Quedarse aprendiz, y "error-embracing".**

> "The thing to do, when you don't know, is **not to bluff and not to freeze,
> but to learn**. […] 'Stay the course' is only a good idea if you're sure
> you're on course. Pretending you're in control even when you aren't is a
> recipe not only for mistakes, but **for not learning from mistakes**. What's
> appropriate when you're learning is small steps, constant monitoring, and a
> willingness to change course as you find out more." (p. 180)

Citando a Don Michael: *"when addressing complex social issues, acting as if we
knew what we were doing simply decreases our credibility."*

**(5) Atender a lo importante, no sólo a lo cuantificable.**

> "Pretending that something doesn't exist if it's hard to quantify leads to
> faulty models. […] **Be a quality detector.** […] Don't be stopped by the 'if
> you can't define it and measure it, I don't have to pay attention to it'
> ploy." (pp. 176-177)

Complemento necesario de 5.3: la salida de "buscar la meta equivocada" no es
encontrar una métrica mejor, porque a veces no hay. Es nombrar la cualidad y
sostenerla aunque no se pueda medir.

---

## Lo que NO sube al pilar, y por qué

Para que quede el criterio y no haya que re-decidirlo:

- **Toda la mecánica**: bañera, stocks y flujos, termostato, población,
  petróleo, pesquería, ecuaciones del apéndice. Es lo que hace entender el
  resto. No cambia ninguna decisión de mañana por sí sola.
- **Hora y Tempus / formas intermedias estables**: el perfil ya tiene la regla
  de checkpoint (regla 5). Sube el mecanismo a esta ficha como respaldo, no una
  línea duplicada arriba. Lección 26.
- **Resiliencia, auto-organización, jerarquía como conceptos**: valiosos para
  entender por qué el sistema aguanta, pero la decisión concreta que salía de
  ahí ("un freno que nunca salta es un lazo de emergencia") **ya está en el
  pilar** desde *Leverage Points*.
- **Seis de las ocho trampas**: el catálogo completo vive acá. Al pilar sube
  sólo el puntero y las dos que se activan seguido.
- **Diez de las quince guías**: la mayoría son disposición, no procedimiento.
- **Toda la parte ambiental, el PBI, el NAFTA, la política**: dominio ajeno.

---

## El pilar — lo que sube a la capa que se lee sola

Cinco líneas. El filtro fue el mismo de siempre: ¿cambia una decisión concreta
que se toma seguido, y que no esté ya cubierta por las cuatro de
*Leverage Points*?

1. **Antes de arreglar un fallo, mirá cuántas veces pasó.** Evento →
   comportamiento → estructura. Un fallo aislado se arregla; uno con historia se
   rediseña, y desde adentro del turno se ven idénticos. El evento gatillo
   siempre está disponible y siempre convence. (cap. 4, p. 89)
2. **Cambiar el actor no cambia nada si la información que recibe es la misma.**
   Subir el modelo, meter un subagente mejor o más effort es poner otro actor en
   la misma posición de racionalidad acotada. (cap. 4, p. 108)
3. **En un sistema con retardo, reaccionar más rápido y más fuerte amplifica la
   oscilación.** Ante un fallo, aplicá una fracción de la corrección, no la
   corrección entera. (cap. 2, p. 57)
4. **La meta real se deduce del comportamiento, no de lo declarado — y un
   sistema medido por esfuerzo produce esfuerzo.** El criterio de salida de una
   fase tiene que ser un resultado verificable. (cap. 1 p. 14; cap. 5 p. 139)
5. **Sólo importa el factor limitante, y se mueve cada vez que mejorás algo.**
   Optimizar el abundante no hace nada. Y un stock sube tapando la fuga, no sólo
   abriendo la canilla. (cap. 4 p. 102; cap. 1 p. 22)

Más el puntero al catálogo de trampas, que es lo que justifica tener la ficha
a mano.

