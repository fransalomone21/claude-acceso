# The Pragmatic Programmer — Andrew Hunt & David Thomas (1999)

**Fuente:** `C:\Users\frans\Downloads\o-programador-pragmatico.pdf`, 348 pp.
Edición brasileña: *O Programador Pragmático: de aprendiz a mestre*, Bookman,
2010 — traducción de Aldir José Coelho Corrêa da Silva sobre la **1ª edición**
inglesa (Addison-Wesley, 2000). No es la 2ª edición de 2019: no tiene los
capítulos nuevos y sí tiene CORBA, RMI y Y2K.
**Extraído con PyMuPDF** a `_pp.txt` (683.462 chars, ~302k tokens).
Control positivo: 676 × `código`, 73 × `DICA`, `Hunt`/`Thomas` presentes,
**16 ligaduras tipográficas** (`ﬁ`, `ﬂ`, `ﬀ`) — las que rompen el `print` en
cp1252. `DRY` da **0**: la traducción lo llama **NSR** ("Não se repita").

**Offset de páginas: PDF = libro.** El cuerpo va de la p. 23 a la 282; las
pp. 283-330 son apéndices (bibliografía, respuestas de ejercicios, índice) y
no se destilaron. Las anclas de esta ficha son el número impreso.

**Estructura:** 8 capítulos, 46 secciones, 70 Dicas (*Tips*). Prólogo de Ward
Cunningham, que lo describe como "un lenguaje de patrones disfrazado": cada
Dica sale de experiencia, es concreta, y se sostiene con las otras.

Ficha: los conceptos que **cambian una decisión** en nuestro sistema (Fran +
Claude + el repo + la máquina). Lo que se entiende y no cambia nada no está
acá. El pilar —lo que sube a la capa que se lee sola— está al final.

---

## La tesis, en una frase

No hay respuestas fáciles, no hay una solución mejor: sólo sistemas más
apropiados **para un conjunto específico de circunstancias** (p. vii). De ahí
la palabra: *pragmaticus*, "hábil en el trabajo", del griego "hacer". El libro
no propone una teoría de desarrollo —y los autores dicen por qué: si tuvieran
una, cada capítulo tendría que defenderla. La programación tiene pocas leyes o
ninguna, así que el consejo estructurado como ley "suena bien por escrito pero
no funciona en la práctica" (Cunningham, p. xvi).

Las dos Dicas fundacionales, que sostienen todo el resto:

> **Dica 1 — Preocupate por tu trabajo.** (p. ix)
> **Dica 2 — Reflexioná sobre tu trabajo.** *Nunca pongas el piloto
> automático.* No es una auditoría que se hace una vez: es evaluación crítica
> constante de cada decisión, todos los días. (p. ix)

Cunningham ilustra la Dica 2 con el mejor ejemplo del libro: estás en una
reunión pensando que sería mejor estar programando. Hunt y Thomas pensarían
*por qué existe la reunión*, si algo puede reemplazarla, y si se puede
automatizar para que en el futuro no ocurra. "Esa reunión no estaba estorbando
la programación: **era** programación, y era programación que se podía
mejorar" (p. xvi).

---

## Capítulo 1 — Una filosofía pragmática (pp. 23-46)

### 1.1 Opciones, no excusas (§1, p. 24)

> **Dica 3 — Proveé opciones, no des excusas baratas.** (p. 25)

El mecanismo, que es lo que cambia una decisión: **antes** de ir a decir que
algo no se puede, está atrasado o se rompió, *parate y escuchate a vos mismo*.
Imaginá la conversación en la cabeza. ¿Qué es probable que te conteste el otro?
¿"Probaste esto…?" ¿"No consideraste aquello?" ¿Cómo vas a responder? "A veces
sabemos lo que la gente va a decir, así que ahorrales el trabajo" (p. 25).

Y el reemplazo concreto: no digas que no se puede hacer; explicá **qué sí se
puede hacer** para salvar la situación. ¿Hay que tirar el código? Explicá la
refactorización. ¿Hace falta tiempo para un prototipo? Pedilo. ¿Hacen falta
mejores tests o automatización para que no vuelva a pasar? Decilo. "No tengas
miedo de pedir o de admitir que necesitás ayuda."

El *pato de goma* aparece acá por primera vez —contale la excusa al pato de tu
monitor antes de decirla en voz alta— y vuelve en Depurando (p. 118) como
técnica de debugging.

→ **Candidato a pilar.** El chequeo ya tiene *«"No puedo" es una afirmación
sobre el mundo y necesita evidencia»*, que cubre la mitad epistemológica. Lo
que **no** está es la mitad operativa: correr la simulación de la respuesta
antes de reportar, y traer opciones en vez del bloqueo pelado.

### 1.2 Entropía de software: la ventana rota (§2, p. 26)

> **Dica 4 — No toleres ventanas rotas.** (p. 27)

De la *Broken Window Theory* [WK82]. Un edificio limpio y habitado se degrada
rapidísimo a partir de **una** ventana rota que queda sin reparar: los
habitantes desarrollan una sensación de abandono —"a los responsables no les
importa"—, y entonces se rompe otra, aparece basura, grafiti, daño
estructural. El experimento original: un auto abandonado quedó **una semana**
intacto; cuando le rompieron una sola ventana, lo destruyeron y lo dieron
vuelta **en horas** (p. 28).

Los autores son explícitos en que el factor dominante no es técnico: "hay
muchos factores que contribuyen a la deterioración del software. El más
importante parece ser la psicología, o cultura, que actúa en un proyecto"
(p. 26). Y: "la negligencia acelera la deterioración más que cualquier otro
factor" (p. 27).

La regla operativa no es "arreglá todo", es **la alternativa cuando no podés
arreglarlo**:

> "Si no hay tiempo suficiente para repararla apropiadamente, **tapiala**.
> Comentá el código inadecuado, mostrá un mensaje 'No implementado' o
> reemplazalo con datos ficticios. Tomá alguna medida para impedir un daño
> mayor y **mostrar que tenés la situación bajo control**." (p. 27)

El contraejemplo simétrico, que es la parte que se olvida: los bomberos que
llegan a apagar el incendio de una casa impecable **paran, con el fuego
ardiendo**, a desenrollar una alfombra desde la puerta hasta el living, para
no arruinar el carpet. En un sistema impecable nadie quiere ser el primero en
dañarlo — ni siquiera con un incendio encima (deadline, demo, release) (p. 28).

→ **Candidato a pilar.** Es un lazo de refuerzo (Meadows) con un punto de
entrada barato: la señal de abandono, no el daño. Y la acción concreta —tapiar,
o sea *marcar visiblemente lo roto que no se arregla hoy*— no está en ninguna
de las 10 líneas del Nivel 0.

### 1.3 Sopa de piedras y ranas hervidas (§3, p. 29)

> **Dica 5 — Sé un catalizador del cambio.** (p. 30)
> **Dica 6 — Acordate del escenario a gran escala.** (p. 30)

Dos historias, y los autores insisten en que son **fallas distintas**.

*Sopa de piedras*: los soldados hambrientos ponen tres piedras a hervir; los
aldeanos, curiosos, van agregando zanahorias, papas, carne, ajo. Nadie hubiera
aportado si le pedían la comida de entrada. La táctica contra la "fatiga
inicial": pedí lo que sí te van a dar, hacelo bien, mostralo, y esperá a que
te pidan lo que querías desde el principio. "A la gente le resulta más fácil
sumarse a algo que viene teniendo éxito" (p. 30). Al pie, Grace Hopper: "es
más fácil pedir disculpas que obtener permiso".

*Rana hervida*: tirada al agua hirviendo salta; puesta en agua fría que se
calienta de a poco, no nota el cambio y se cocina. Los proyectos se salen de
control de manera lenta e inexorable, feature a feature, parche sobre parche
"hasta que no queda nada del original" (p. 30).

La distinción explícita —y es la que vale:

> "El problema de la rana es **distinto** de la cuestión de las ventanas
> rotas. En la Teoría de la Ventana Rota, la gente **pierde la voluntad** de
> combatir la entropía porque percibe que a nadie le importa. La rana
> simplemente **no nota** el cambio." (p. 30)

Dos modos de falla, dos remedios: la ventana rota se arregla con una señal
(reparar o tapiar); la rana se arregla con **medición periódica contra el
estado inicial**, porque por definición no se detecta desde adentro del
proceso. Los autores cierran: "verificá constantemente lo que pasa a tu
alrededor, y no sólo lo que vos estás haciendo".

→ El desafío que dejan sin responder, y que es honesto: John Lakos les
preguntó cómo distinguir, mientras lo hacés, si estás haciendo sopa de piedras
(engaño progresivo que termina bien para todos) o sopa de rana (engaño
progresivo que termina mal). "¿La decisión es subjetiva u objetiva?" (p. 31).

### 1.4 Software satisfactorio (§4, p. 31)

> **Dica 7 — Hacé de la calidad parte de los requisitos.** (p. 33)

"Buscando lo mejor, generalmente arruinamos lo bueno" (Rey Lear, epígrafe).
El punto no es aceptar código malo: es que **el nivel de calidad es una
variable de requisitos que se negocia con el usuario**, no un máximo que se
persigue por default. "Estamos defendiendo que los usuarios tengan la
oportunidad de participar en la decisión de cuándo lo que producimos alcanzó
lo satisfactorio" (p. 32). Con la excepción declarada: marcapasos, transbordador
espacial, biblioteca de bajo nivel de difusión amplia — ahí las opciones son
más limitadas.

Y el corolario que sí es operativo, *Saber cuándo parar* (p. 33): la
programación es como la pintura; todo el trabajo se arruina si no sabés cuándo
parar. "No arruines un programa que funciona perfectamente adornándolo y
mejorándolo en exceso. Pasá a otra cosa y dejá que tu código hable un poco por
sí mismo. Puede no haber quedado perfecto. No te preocupes: **nunca** hubiera
quedado perfecto."

→ **Respaldo, no pilar.** El perfil ya lo tiene como regla 4 ("Cambios
mínimos. No refactorizar ni limpiar fuera del scope pedido") y como criterio de
salida de fase. El libro le agrega la razón —la calidad es un eje de requisitos,
no una constante— y el nombre.

### 1.5 Tu cartera de conocimientos (§5, p. 34)

> **Dica 8 — Invertí regularmente en tu cartera de conocimientos.** (p. 36)
> **Dica 9 — Analizá críticamente lo que leés y escuchás.** (p. 38)

El conocimiento es un **bien perecedero** (p. 34, con la nota al pie: "algo
cuyo valor disminuye con el tiempo — un depósito lleno de bananas, una entrada
para un partido"). Se gestiona como una cartera de inversiones: invertir
regularmente (el hábito importa más que el monto), diversificar, gestionar el
riesgo, comprar barato / vender caro, y **reexaminar y reestructurar**
periódicamente.

Objetivos concretos que proponen: una lengua nueva por año; **un libro técnico
por trimestre** —y una vez adquirido el hábito, uno por mes—; libros no
técnicos; cursos; grupos de usuarios; ambientes distintos.

La segunda mitad es la que muerde. *Pensamiento crítico* (p. 38): asegurate de
que el conocimiento de tu cartera sea exacto y no esté influido por la
publicidad. "Nunca subestimes el poder del comercio. Que un buscador liste un
resultado primero no significa que sea la mejor solución; el proveedor puede
haber pagado. Que una librería destaque un libro no significa que sea bueno ni
siquiera popular; pueden haber pagado por el destaque."

→ **Cultura general con un gancho.** Esta ficha *es* la Dica 8 ejecutándose —
tres libros, uno por sesión. No sube al pilar: no cambia una decisión de turno.
Lo que sí queda anotado es el protocolo de consultar a un experto (p. 39): sabé
exactamente qué querés preguntar y sé lo más específico posible; formulá la
pregunta y **entonces pará y buscala vos** con esas palabras clave antes de
mandarla. Es el mismo movimiento que el chequeo transversal ("¿ya lo sé o está
en el contexto? → no lo mandes a investigar de nuevo").

### 1.6 ¡Comunicate! (§6, p. 40)

> **Dica 10 — Es lo que decís y la manera en que lo decís.** (p. 43)

"Una buena idea queda huérfana sin una comunicación efectiva" (p. 40).
El acróstico **ASTUTO** (WISDOM en el original), Fig. 1.1, p. 42 — para
conocer al público:

| | |
|---|---|
| **A**prendan | ¿qué querés que aprendan? |
| **S**u interés | ¿cuál es su interés en lo que tenés para decir? |
| **T**rabajo | ¿qué nivel de sofisticación tiene? |
| **U**san | ¿qué nivel de detalle usan? |
| **T**enga la posesión | ¿quién querés que sea dueño de la información? |
| **O**írte | ¿cómo los motivás a escucharte? |

El resto de la sección: sabé qué querés decir (hacé un borrador y preguntate
"¿esto representa lo que estoy tratando de decir?"); elegí el momento —el
gerente que acaba de perder código fuente es el mejor oyente posible para tu
idea sobre repositorios—; elegí un estilo, **y si tenés dudas, preguntá**;
buena apariencia; involucrá al público mandando borradores; escuchá; y
respondé siempre, aunque sea "te contesto después".

→ **Respaldo.** El cuadro de fase *es* un contrato de estilo ya negociado
(qué va arriba de toda respuesta, en qué orden). El libro explica por qué
funciona: el formato es parte del mensaje, no decoración.

---

## Capítulo 2 — Un enfoque pragmático (pp. 47-92)

### 2.1 Los males de la duplicación — NSR / DRY (§7, p. 48)

> **Dica 11 — NSR: No te repitas.** (p. 49)
> **Dica 12 — Facilitá la reutilización.** (p. 55)

El principio, en la formulación exacta del libro:

> "**Cada bloque de informaciones debe tener una representación oficial,
> exclusiva y sin ambigüedades dentro de un sistema.**" (p. 49)

Y el argumento de por qué no alcanza con "acordate de cambiar los dos lados":

> "No es una cuestión de **si** te vas a acordar: es una cuestión de **cuándo**
> te vas a olvidar." (p. 49)

Antes viene la premisa que lo hace importante, y que suele saltearse: **el
mantenimiento no es una fase**. "La mayoría considera que el mantenimiento
empieza cuando se lanza la aplicación. Creemos que están equivocados. Los
programadores están constantemente en actividades de mantenimiento: nuestra
comprensión cambia diariamente" (p. 48).

Las **cuatro fuentes** de duplicación, que son cuatro problemas distintos:

| Tipo | Qué pasa | Cómo se ataca |
|---|---|---|
| **Impuesta** | el entorno parece exigirla (dos lenguajes, header + impl., doc + código) | generarla desde una fuente única |
| **Inadvertida** | error de diseño; nadie se dio cuenta | normalizar contra el modelo real |
| **Impaciente** | copiar y pegar porque parece más rápido | disciplina; "los atajos causan grandes atrasos" |
| **Entre desarrolladores** | la más difícil de detectar | comunicación activa, bibliotecario, lugar central |

El truco para la duplicación **impuesta**, que es el que cambia una decisión:

> "Normalmente, con un poco de habilidad conseguimos eliminar la necesidad de
> duplicación. La solución suele ser crear un generador de código o un filtro
> simple. […] **El truco es hacer el proceso activo**: no puede ser una
> conversión hecha una sola vez, o volveremos a la duplicación de los datos."
> (p. 50)

Dos ejemplos concretos: los fragmentos de código de este libro los inserta un
preprocesador cada vez que se formatea el texto; y Dave, en un switch de télex
internacional, **generó la batería de tests desde la especificación misma** —
cuando el cliente corregía la spec, los tests cambiaban solos (p. 51).

Sobre comentarios: "a los programadores se les dice que comenten su código:
un buen código tiene varios comentarios. Lamentablemente, nunca les explican
**por qué** el código necesita comentarios: **un código inadecuado requiere
muchos comentarios**." Y NSR aplicado: la información de bajo nivel va en el
código, los comentarios se reservan para lo de alto nivel — si no, cada cambio
toca los dos, los comentarios quedan desactualizados, y "**comentarios no
confiables son peores que ningún comentario**" (p. 51).

La *duplicación inadvertida* trae el ejemplo de la clase `Line` con `start`,
`end` y `length`: el largo está definido por los puntos, así que es duplicación
— tiene que ser un campo calculado. Y la excepción, bien delimitada: se puede
violar NSR por rendimiento (cachear), pero **localizando el impacto** — la
violación no se expone al exterior, sólo los métodos internos de la clase
mantienen la consistencia (p. 53).

El caso de terror de la duplicación entre desarrolladores: una auditoría Y2K
de un estado de EE.UU. revisó más de **10.000 programas, cada uno con su
propia versión de la validación de números de seguridad social** (p. 54).

→ **Respaldo fuerte, no pilar.** El perfil global ya cierra con "Un dato que
vive en dos lados diverge", y la tabla de qué memoria es cuál existe
exactamente para esto. Lo que el libro agrega y sí vale anotar: (a) el nombre
y la formulación canónica; (b) que NSR **no es sobre código** sino sobre
*bloques de información* —specs, docs, procesos, organización de equipos—;
(c) el criterio para la duplicación inevitable: **generarla activamente**, y
que un generador que corre una sola vez no cuenta. `install.ps1` es
exactamente eso, y su chequeo del conteo de lecciones también.

### 2.2 Ortogonalidad (§8, p. 56)

> **Dica 13 — Eliminá efectos entre elementos no relacionados.** (p. 57)

Definición: dos cosas son ortogonales cuando cambiar una no afecta la otra.
La imagen que la hace reconocible es el **helicóptero**: cuatro controles
—cíclico, colectivo, acelerador, pedales— donde cada corrección desencadena
efectos secundarios en todos los demás. Bajás el colectivo, baja la nariz,
empieza un descenso en espiral a la izquierda, compensás con el cíclico y el
pedal, y cada compensación vuelve a afectar todo. "Tus manos y pies están
constantemente moviéndose, tratando de equilibrar todas las fuerzas en
interacción" (p. 57). En un sistema no ortogonal **no existe el concepto de
corrección local**.

Las dos ganancias, y una de ellas es cuantitativa:

- **Productividad.** Si un componente hace M cosas y otro hace N, y son
  ortogonales, combinarlos da **M × N**. Si no son ortogonales, se solapan y
  el resultado es **menor**. "Obtenés más funcionalidad por unidad de
  esfuerzo combinando componentes ortogonales" (p. 58).
- **Riesgo.** El daño queda aislado; el sistema es menos frágil; se testea
  mejor; y quedás menos atado a una plataforma o proveedor.

Los tres tests operativos —y son tests, no consejos:

1. **De diseño** (p. 60): "cuando tengas los componentes mapeados, preguntate:
   *si cambio dramáticamente los requisitos detrás de una función específica,
   ¿cuántos módulos se ven afectados?*" En un sistema ortogonal la respuesta
   debe ser **uno**. (Con la nota al pie honesta: en el mundo real casi
   siempre son varios; el ideal es que *por función* sea uno.)
2. **De equipo** (p. 59): "una medida informal de la ortogonalidad de la
   estructura de un equipo: **cuánta gente necesita estar involucrada en la
   discusión de cada cambio solicitado. Cuanto mayor el número, menos
   ortogonal es el grupo**."
3. **De test** (p. 63): "construir tests unitarios ya es un test interesante de
   ortogonalidad. ¿Qué hace falta para construir y montar una unidad de test?
   ¿Tenés que involucrar un gran porcentaje del resto del sistema sólo para
   que el test compile? Si es así, encontraste un módulo que no está
   desvinculado."

Técnicas de codificación: mantené el código desvinculado (Ley de Demeter,
p. 160); **evitá datos globales** —incluso los que sólo pensás leer—; ojo con
los *singletons*, que suelen ser variables globales disfrazadas; evitá
funciones parecidas (código duplicado es síntoma de problema estructural).

Y una línea suelta que vale por sí misma, del ejemplo del número de teléfono
como identificador de cliente: "**no confíes en las propiedades de cosas que
no podés controlar**" (p. 61) — ¿qué pasa cuando la telefónica reasigna los
códigos de área?

→ **Candidato a pilar (el test de equipo).** Los tests 1 y 3 son de diseño de
software y no cambian una decisión nuestra de turno. El **test 2 sí**: es un
criterio medible para decidir si una descomposición en subagentes está bien
cortada — si cada cambio necesita coordinar N agentes, la descomposición no es
ortogonal y el fan-out va a costar más de lo que rinde. Y M × N vs. solapado
es el argumento de por qué la *calidad del corte* importa más que la
*cantidad* de piezas.
La línea del número de teléfono es **respaldo**: el chequeo ya tiene "si la
búsqueda depende de bytes que cambian entre representaciones, buscá por lo
invariante" — es el mismo principio en otro dominio.

### 2.3 Reversibilidad (§9, p. 66)

> **Dica 14 — No hay decisiones definitivas.** (p. 68)

"Nada es más peligroso que una idea cuando es la única que tenés"
(Alain, epígrafe). El problema no es equivocarse: es que **las decisiones
críticas no son fácilmente reversibles**, y cada una angosta el blanco.

> "A cada decisión crítica, el equipo de proyecto se compromete con un blanco
> más chico — una versión más estrecha de la realidad, que presenta menos
> opciones. En el momento en que se hayan tomado muchas decisiones críticas,
> el blanco se habrá vuelto tan chico que, si se mueve, si el viento cambia
> de dirección o si una mariposa en Tokio bate las alas, vas a errar. Y podés
> errar por mucho." (p. 66)

La escena: "¡Pero dijiste que usaríamos la base XYZ! Terminamos el 85% del
código, no podemos cambiar ahora." — "La empresa decidió estandarizar en PQD.
Está fuera de mi alcance. Van a trabajar los fines de semana hasta nuevo
aviso" (p. 66).

El reemplazo: "en vez de tomar decisiones esculpidas en piedra, consideralas
más bien escritas en la arena de la playa. Una ola grande puede venir y
barrerlas en cualquier momento" (p. 68). Y el criterio de tiempo: pasar de
cliente-servidor a autónomo "no debería llevar más de algunos días. Si lleva
más, no consideraste la reversibilidad" (p. 67).

El cierre, con los gatos de Schrödinger: pensá la evolución del código como
una caja llena de gatos de Schrödinger — cada decisión resulta en una versión
distinta del futuro. **¿Cuántos futuros posibles puede soportar tu código?
¿Cuáles son más probables? ¿Qué tan difícil va a ser soportarlos cuando
llegue el momento?** (p. 69).

Y una regla de simetría que es fácil de saltear: "cualquiera sea el mecanismo
que uses, **hacelo reversible. Si algo se agrega automáticamente, también se
puede quitar automáticamente**" (p. 69).

→ **Candidato a pilar.** Es un eje que el Nivel 0 no tiene. Meadows da el
*apalancamiento* de una intervención (qué tan arriba pega) y el *retardo*
(cuánto tarda en verse); Hunt & Thomas agregan el **costo de deshacerla**, que
es independiente de los otros dos. Una intervención de alto apalancamiento e
irreversible es un riesgo distinto que una de alto apalancamiento y reversible,
y hoy las evaluamos igual. La regla de simetría (lo que se instala solo, se
desinstala solo) aplica literalmente a `install.ps1`.

### 2.4 Proyectiles trazadores (§10, p. 70)

> **Dica 15 — Usá proyectiles trazadores para encontrar el blanco.** (p. 71)

Hay dos maneras de disparar una ametralladora en la oscuridad. Una: calcular
la posición exacta del blanco, las condiciones ambientales, las
especificaciones del cartucho, y usar tablas o una computadora de control de
tiro. Si todo funciona exactamente como está especificado, si las tablas están
bien y el ambiente no cambió, las balas deberían caer cerca. La otra: cargar
**balas trazadoras** intercaladas con las comunes. Se encienden al disparar y
dejan un rastro pirotécnico desde el arma hasta lo que sea que peguen. **Si
las trazadoras pegan en el blanco, las comunes también.**

Por qué funciona: operan en el mismo ambiente y bajo las mismas restricciones
que la munición real, el feedback es inmediato, y son baratas (p. 70).

El equivalente en código: algo que te lleve **de un requisito a algún aspecto
del sistema final rápida, visible y repetidamente** — una conexión de punta a
punta, delgada pero completa, atravesando todas las capas.

La distinción que hace que no sea "prototipo con nombre agresivo":

> "El código trazador **no es descartable**: se escribe para mantenerse
> indefinidamente. Contiene toda la verificación de errores, estructuración,
> documentación y autoverificación que tiene cualquier bloque de código de
> producción. Sólo que no es totalmente funcional." (p. 72)

Las ventajas, y una de ellas es un diagnóstico:

- El usuario ve algo funcionando temprano, y **te dice qué tan cerca del
  blanco estás** — que es información que la especificación escrita no da.
- Los desarrolladores tienen una estructura donde trabajar. "El papel más
  temible es el que no tiene nada escrito."
- **Plataforma de integración**: integrás todos los días, muchas veces por día,
  en vez de una vez al final.
- Siempre tenés algo para mostrar.
- Y el diagnóstico: como cada desarrollo individual es más chico, **evitás
  esos bloques monolíticos que se reportan como "95% terminados" semana tras
  semana** (p. 73).

Y la parte que suele saltearse: **los trazadores no siempre pegan en el
blanco**. "Muestran lo que estás pegando. No siempre se pega en el blanco. Por
lo tanto, hay que ajustar la puntería hasta que peguen. **Eso es lo que
importa.**" No te sorprendas si los primeros intentos fallan; un cuerpo chico
de código tiene poca inercia y es fácil de cambiar (p. 73).

→ **Candidato a pilar fuerte.** Es un criterio de arranque para territorio
desconocido que el Nivel 0 no tiene: en vez de especificar todo y disparar a
ciegas, atravesá el sistema entero con lo más delgado posible y **conservalo**.
Y el "95% terminado semana tras semana" es exactamente el síntoma de una fase
medida por esfuerzo en vez de por resultado — que el Nivel 0 ya nombra desde el
lado de Meadows, pero sin la salida operativa.

### 2.5 Prototipos y notas post-it (§11, p. 75)

> **Dica 16 — Creá prototipos para aprender.** (p. 76)

> "El valor de un prototipo **no está en el código producido, sino en las
> lecciones aprendidas**. Esa es la razón real para hacer prototipos." (p. 76)

Qué prototipar: cualquier cosa **arriesgada** — no probada antes, crítica para
el sistema final, experimental, dudosa, o con la que no te sentís cómodo.
Qué se puede ignorar en un prototipo: **precisión** (datos ficticios),
**integralidad** (un solo camino, un solo ítem de menú), **robustez** (puede
romperse en una gloriosa exhibición pirotécnica, sin problema) y **estilo**.

Y de ahí sale el test que decide cuál de las dos técnicas estás usando:

> "Si estás en un ambiente en el que **no podés ignorar los detalles**, tenés
> que preguntarte si realmente estás construyendo un prototipo. Tal vez un
> estilo de desarrollo tipo proyectil trazador sea más apropiado." (p. 75)

| | Prototipo | Trazador |
|---|---|---|
| Qué explora | **un aspecto** del sistema | cómo se integra el **sistema entero** |
| Qué queda | **se tira** | queda: es el esqueleto |
| Detalles | se ignoran | están todos, sólo falta funcionalidad |
| Metáfora | reconocimiento del terreno | el disparo |

El **peligro nombrado**, que es la razón por la que la distinción importa:
"los prototipos pueden ser engañosamente atractivos para gente que no sabe que
son sólo prototipos". Asegurate de que **todos** entiendan que es código
descartable, o los patrocinadores van a insistir en desplegarlo. "Podés
construir un gran prototipo de un auto nuevo con madera balsa y cinta
aisladora, pero no intentarías manejarlo en el tráfico de hora pico" (p. 78).
Y la salida: si en tu cultura hay chance de que se malinterprete, **usá
trazadores en vez de prototipos**.

Del checklist de prototipo de arquitectura (p. 77), el ítem que los autores
señalan como el que "tiende a generar las mayores sorpresas y los resultados
más importantes": **¿cada módulo tiene un camino de acceso a los datos que
necesita durante la ejecución, y lo tiene cuando lo necesita?**

→ **Candidato a pilar**, junto con el anterior: la pregunta "¿esto es un
prototipo o un trazador?" tiene una respuesta operativa (¿puedo ignorar los
detalles?) y decide si el código se tira o se conserva. Hoy no distinguimos
las dos cosas y eso produce el peor de los dos mundos: código exploratorio que
queda, sin la estructura del trazador.

### 2.6 Lenguajes de dominio (§12, p. 79)

> **Dica 17 — Programá en un nivel cercano al dominio del problema.** (p. 80)

"Los límites del lenguaje son los límites del mundo de una persona"
(Wittgenstein, epígrafe). Escribí código con el vocabulario del dominio; a
veces se puede ir al nivel siguiente y programar **en** el lenguaje del
dominio, con una minilengua propia. La especificación pasa a ser código
ejecutable.

Dos cosas que sí cambian una decisión nuestra:

1. **Los usuarios secundarios.** "Hay muchos usuarios de una aplicación. Está
   el usuario final... y también los **usuarios secundarios**: el equipo de
   operaciones, los gerentes de configuración y test, los programadores de
   soporte y mantenimiento, y **las futuras generaciones de desarrolladores**.
   Cada uno de esos usuarios tiene su propio dominio de problema, y podés
   generar miniambientes y lenguajes para todos ellos" (p. 80). — El lector
   de `HANDOFF.md` y `ESTADO_ACTUAL.md` es exactamente ese usuario secundario,
   y el cuadro de fase es su minilengua.
2. **Errores en el vocabulario del dominio** (recuadro, p. 81). Un error
   genérico dice `Syntax error: undeclared identifier`. Un error de dominio
   dice: `"AB123" is not a format. Known formats are ABC123, XYZ43B, PDQB and
   42.` — Es la diferencia entre un verificador que dice "falló" y uno que
   dice qué falló y cuáles eran las opciones válidas.

Y el trade-off final: entre lenguaje fácil de implementar y lenguaje fácil de
mantener, **elegí el legible**, porque "la mayoría de las aplicaciones exceden
el tiempo de vida esperado para ellas" (p. 85). El contraejemplo es el archivo
de configuración de `sendmail`.

→ **Respaldo.** Nombra bien algo que ya hacemos, pero no cambia una decisión de
turno por sí solo.

### 2.7 Estimando (§13, p. 86)

> **Dica 18 — Estimá para evitar sorpresas.** (p. 86)
> **Dica 19 — Reexaminá el cronograma junto al código.** (p. 91)

Esta sección es la que más carga operativa tiene del capítulo.

**Las unidades comunican la precisión.** Es el hallazgo central:

> "Si decís que algo va a llevar cerca de 130 días hábiles, la gente va a
> esperar que el resultado no tarde. Pero si decís 'en unos seis meses', van a
> saber que lo tienen que buscar en algún momento entre cinco y siete meses.
> Los dos números representan la misma duración, pero **'130 días' implica un
> nivel de precisión más alto del que percibimos**." (p. 87)

| Duración | Estimar en |
|---|---|
| 1-15 días | días |
| 3-8 semanas | semanas |
| 8-30 semanas | meses |
| más de 30 semanas | **pensalo bien antes de dar una estimación** |

**El truco básico, antes de construir modelos:** "preguntale a alguien que ya
pasó por el problema. Antes de ocuparte demasiado construyendo modelos, buscá
a alguien que estuvo en una situación similar en el pasado" (p. 87).

**El alcance elegido es parte de la respuesta**, y se dice en voz alta:
"Suponiendo que no haya accidentes de tránsito y haya nafta en el auto, llego
en 20 minutos" (p. 88).

**Qué parámetros importan:** los que se suman al resultado son menos
significativos que los que multiplican o dividen. "Duplicar la velocidad de una
línea puede duplicar los datos recibidos en una hora, mientras que agregar 5 ms
de retardo no va a tener ningún efecto perceptible" (p. 89).

**Y la regla sobre el resultado raro**, que es la mejor línea de la sección:

> "Durante la fase de cálculo podés empezar a obtener respuestas que parezcan
> extrañas. **No las descartes tan rápido.** Si tu aritmética está correcta,
> probablemente no entendiste bien el problema o tu modelo está mal. **Esa
> información es valiosa.**" (p. 89-90)

**Registrá tus estimaciones y comparalas con lo que pasó.** "Cuando una
estimación resulte errada, no te encojas de hombros y lo dejes pasar. Descubrí
por qué el resultado fue distinto de tu cálculo... si lo hacés, la próxima
estimación va a ser mejor" (p. 90). El desafío que dejan: si el error supera el
50%, buscá dónde te equivocaste.

**Y la respuesta correcta cuando te piden una estimación:**

> "Decí: **'Te contesto después'**. Casi siempre obtenemos mejores resultados
> cuando bajamos la velocidad del proceso... Las estimaciones dadas en la
> máquina de café te van a caer mal después, como el café." (p. 91)

→ **Candidato a pilar (las unidades) + respaldo (el resto).** Lo de las
unidades es una regla de comunicación que aplica a cada turno y no está en
ningún lado: la precisión que se **transmite** no es la que uno tenía en la
cabeza. "El resultado raro es información" es respaldo del chequeo, que ya
tiene "un cero que refuta la premisa es el mejor resultado posible". "Te
contesto después" choca con el modo de trabajo (acá se decide y se avanza en
el mismo turno) — pero se aplica a las **estimaciones**, no a las decisiones,
y ahí sí vale.

---

## Capítulo 3 — Las herramientas básicas (pp. 93-128)

La tesis del capítulo: las herramientas son extensiones de las manos, y el
error del programador novato es adoptar **una** herramienta poderosa —un IDE—
y no salir nunca de su interfaz cómoda (p. 94).

### 3.1 El poder del texto simple (§14, p. 95)

> **Dica 20 — Mantené la información en texto simple.** (p. 96)

Tres beneficios: **seguro contra la obsolescencia** ("las formas de datos
legibles por humanos y autodescriptivas sobreviven a todas las otras formas de
datos **y a las aplicaciones que las crearon**. Punto"), **aprovechamiento**
(toda herramienta del universo de la computación opera sobre texto) y **más
fácil de testear**.

La distinción que sí es fina — *legible* por humanos no es *comprensible* por
humanos (p. 97):

```
Field19=467abe              ->  DrawingType=UMLActivityDrawing
<FIELD10>123-45-6789</FIELD10>  ->  <SSNO>123-45-6789</SSNO>
```

Los dos de la izquierda son texto plano y no sirven de nada. El diagnóstico
del formato binario aplica igual al nombre opaco: **"el contexto necesario
para comprender los datos queda separado de los datos"**.

Y el recuadro de la filosofía Unix (p. 98): herramientas chicas y afiladas,
cada una haciendo una cosa bien, **posible gracias a un formato subyacente
común** — el archivo de texto basado en líneas. Al pie, sin comentario:
"todos los programas se vuelven legado apenas se crean".

→ **Respaldo.** El repo entero es esto. Lo que vale anotar es la distinción
legible/comprensible aplicada a nuestros propios nombres y salidas.

### 3.2 Juegos de shell (§15, p. 99)

> **Dica 21 — Usá el poder de los shells de comando.** (p. 102)

El argumento, en una sigla:

> "Un beneficio de las GUI es WYSIWYG — *what you see is what you get*. La
> desventaja es **WYSIAYG — *what you see is all you get***." (p. 100)

"Normalmente los ambientes de GUI quedan limitados a los recursos que sus
diseñadores planearon. Cuando necesitamos pasar los límites del modelo que el
diseñador proveyó, no tenemos suerte — y **casi siempre tenemos que ir más
allá de los límites del modelo**."

→ **Cultura general para nosotros** (ya vivimos en el shell), pero WYSIAYG es
un marco reutilizable: se aplica a cualquier envoltorio, no sólo a las GUI.

### 3.3 Edición avanzada (§16, p. 104)

> **Dica 22 — Usá bien un solo editor.** (p. 104)

Uno solo, para todo, en todas las plataformas, hasta que los atajos sean
reflejo. → Cultura general.

### 3.4 Control del código fuente (§17, p. 108)

> **Dica 23 — Usá siempre control de código fuente.** (p. 110)

"Siempre. Aunque seas un equipo de una persona en un proyecto de una semana.
Aunque sea un prototipo 'descartable'. Y **aunque aquello en lo que estés
trabajando no sea código fuente**." Todo: documentación, listas telefónicas,
memos a proveedores, makefiles, procedimientos de build, ese scriptcito que
graba el CD maestro. "Lo usamos rutinariamente en prácticamente todo lo que
tipeamos, **incluido el texto de este libro**."

Dos cosas que agrega y que sí son nuevas:

1. **Habilita builds automáticos y repetibles.** "La construcción es repetible
   porque siempre vas a poder reconstruir la fuente **en la forma en que estaba
   en una fecha específica**" (p. 110).
2. **Las preguntas que un SCCS contesta** (p. 109): ¿quién cambió esta línea?
   ¿cuál es la diferencia con la versión de la semana pasada? y —la que
   importa— **"¿qué archivos se cambiaron con más frecuencia?"**

→ **Respaldo de la regla 2 del perfil** ("el repo es la memoria"), con un
agregado real: la pregunta 2 es *"¿cuántas veces pasó?"* de Meadows vuelta
consultable. El Nivel 0 dice "antes de arreglar un fallo, mirá cuántas veces
pasó"; el historial de git es dónde se mira.

### 3.5 Depurando (§18, p. 112)

La sección más densa del capítulo para nosotros.

> **Dica 24 — Arreglá el problema, olvidate del culpable.** (p. 113)
> **Dica 25 — No entres en pánico.** (p. 113)

**La regla contra el "esto es imposible":**

> "Si tu primera reacción al encontrar un bug o escuchar el reporte de un bug
> es *'esto es imposible'*, obviamente estás equivocado. **No gastes ni una
> neurona en la línea de razonamiento que empieza con 'pero esto no puede
> pasar'**, porque es obvio que puede, y pasó." (p. 113)

**Miopía:** "resistí el impulso de corregir sólo los síntomas que estás
viendo; es más probable que la falla real esté bien lejos de lo que estás
observando" (p. 113).

**Antes de empezar:** trabajá sobre código compilado sin *warnings*, con los
niveles de aviso del compilador lo más alto posible. "No tiene sentido perder
tiempo buscando un problema **que el compilador podría encontrar por vos**"
(p. 113-114).

**Coincidencias:** "es fácil dejarse engañar por coincidencias y no te podés
dar el lujo de perder tiempo depurando coincidencias. Sobre todo, tenés que ser
**preciso en tus observaciones**" (p. 114).

**La historia del trazo de pincel** (p. 114), que es la mejor del libro para
nuestro trabajo. Cerca del lanzamiento, los testers reportan que la aplicación
gráfica se cae al dibujar un trazo con cierto pincel. El programador responsable
dice que no hay nada mal: él lo probó y funciona. El diálogo se repite **durante
varios días**, con los humos subiendo. Finalmente los juntan en la misma sala.
El tester elige el pincel y dibuja un trazo **de arriba a la derecha hacia abajo
a la izquierda**. La aplicación se cae. "Ah", dice el programador, con voz
débil, y admite que él sólo había probado trazos **de abajo a la izquierda hacia
arriba a la derecha**.

Los dos puntos que sacan, textuales:

1. "Puede que tengas que **entrevistar al usuario que reportó el bug** para
   juntar más datos de los que recibiste inicialmente."
2. "**Los tests artificiales no ejercitan una aplicación lo suficiente.** Hay
   que probar exhaustivamente tanto las condiciones límite como los patrones
   de uso realistas del usuario final."

**Reproducción** (recuadro, p. 115) — y acá está la barra concreta:

> "La mejor manera de empezar a corregir un bug es hacerlo reproducible. Al
> fin y al cabo, si no lo podés reproducir, ¿cómo vas a saber si algún día
> quedó arreglado? Pero queremos **más** que un bug reproducible siguiendo una
> serie larga de pasos: queremos un bug que se pueda **reproducir con un solo
> comando**. Es mucho más difícil arreglar un bug cuando hay que recorrer 15
> pasos para llegar al punto donde aparece. A veces, **al forzar el
> aislamiento de las circunstancias que exhiben el bug, se obtiene una
> percepción aún mayor de cómo corregirlo**."

**Rastreo** (p. 116): las sentencias de traza son primitivas frente a un
debugger de IDE, "pero son particularmente eficaces para diagnosticar varios
tipos de errores **que los debuggers no consiguen**. El rastreo es inestimable
en cualquier sistema donde el tiempo mismo sea un factor relevante: procesos
concurrentes, sistemas de tiempo real y aplicaciones basadas en eventos". Y:
los mensajes de traza deben tener **un formato regular y consistente**, porque
los vas a querer analizar automáticamente.

→ **Candidato a pilar (la barra de reproducción) + respaldo fuerte (el resto).**
"Reproducible" no es una barra: **"reproducible con un solo comando"** sí, y
además el acto de reducirlo a un comando es lo que produce el entendimiento.
Eso no está en ningún lado del perfil y aplica a cada bug de BLACK y a cada
falla del pipeline. Lo de las coincidencias y lo de "esto es imposible" son
respaldo del chequeo, que ya tiene *«correlación fuerte es 'probable'»* y
*«"no puedo" es una afirmación sobre el mundo»* — el libro les agrega la
versión imperativa y el costo (varios días perdidos en la historia del pincel).

#### 3.5.1 Rubber ducking (p. 117)

Explicarle el problema a alguien que sólo mira la pantalla y asiente — o a un
pato de goma. El mecanismo, que es lo que importa y no la anécdota:

> "Al explicarle el problema a otra persona vas a tener que **declarar
> explícitamente cosas que diste por aceptables** cuando recorriste el código
> vos solo. Al verbalizar algunas de esas suposiciones, podés obtener de
> repente una percepción nueva del problema." (p. 117)

La nota al pie da el origen: Dave, en el Imperial College, trabajó con Greg
Pugh, uno de los mejores desarrolladores que conoció, que durante meses andaba
con un patito de goma amarillo que apoyaba en su terminal mientras codificaba.
"Le llevó un tiempo a Dave juntar coraje para preguntar por qué…"

#### 3.5.2 "select no está roto" (§18, p. 118)

> **Dica 26 — "select" no está roto.** (p. 118)

Un ingeniero senior estaba convencido de que la llamada de sistema `select`
estaba defectuosa en Solaris. No hubo argumento ni lógica que lo hiciera
cambiar de idea — el hecho de que todas las demás aplicaciones de red de la
máquina anduvieran bien era irrelevante para él. **Pasó semanas construyendo
workarounds que, por alguna razón desconocida, no parecían arreglar el
problema.** Cuando finalmente se vio forzado a sentarse a leer la documentación
de `select`, encontró el problema y lo arregló **en cuestión de minutos**.

> "Si encontrás huellas de cascos, pensá en **caballos, no en cebras**. El
> sistema operativo probablemente no está roto. Y la base de datos debe estar
> funcionando bien." (p. 118)

Y el corolario, que es una regla dura:

> "**Si 'cambiaste sólo una cosa' y el sistema dejó de funcionar, esa única
> cosa es probablemente la responsable, directa o indirectamente, no importa
> lo imposible que parezca.**" (p. 118)

Con la excepción honesta: a veces no controlamos lo que cambió — versiones
nuevas del SO, del compilador, de la base. "En resumen, es una situación
enteramente nueva y **hay que volver a testear el sistema bajo esas nuevas
condiciones**. Por lo tanto, mirá bien el cronograma antes de considerar una
actualización."

Y si no hay lugar obvio por dónde empezar: **búsqueda binaria**. Fijate si los
síntomas están presentes en dos lugares distantes del código y mirá en el
medio (p. 119).

#### 3.5.3 El elemento sorpresa (§18, p. 119)

> **Dica 27 — No supongas: probá.** (p. 119)

La mejor heurística de la sección, y no está en ningún otro lado:

> "**El tamaño del susto que nos llevamos cuando algo sale mal es directamente
> proporcional al nivel de confianza y fe que tenemos en el código que se está
> ejecutando.** Por eso, ante una falla 'sorpresa', tenés que darte cuenta de
> que estás equivocado en una o más de tus suposiciones. **No ignores una
> rutina o bloque de código involucrado en el bug porque 'sabés' que
> funciona.** Probalo. Probalo *en ese contexto, con esos datos, con esas
> condiciones límite*." (p. 119)

Es decir: la sorpresa no es una reacción emocional a descartar — **es el
puntero a cuál suposición hay que testear**. Cuanto más te sorprendió, más
confiabas, y por eso mismo es ahí donde no miraste.

Después de arreglar un bug inesperado, el ciclo de cierre (p. 119-120):
**¿por qué no se detectó antes?** ¿hay que mejorar los tests? ¿hay **otro
lugar del código susceptible al mismo bug**? ¿si tardó, por qué tardó, y qué
se puede construir para que la próxima vez sea más fácil (mejores ganchos de
test, un analizador de logs)? Y si el bug salió de la suposición equivocada de
alguien, discutilo con el equipo entero: "si una persona entendió mal, le
puede pasar a otras".

**Lista de verificación de la depuración** (p. 120):

- ¿El problema reportado es resultado directo del bug o es un **síntoma**?
- ¿El bug está realmente en el compilador / en el SO, o está en tu código?
- **Si tuvieras que explicarle este problema en detalle a un colaborador, ¿qué
  dirías?**
- Si el código sospechoso pasa los tests unitarios, ¿los tests están
  suficientemente completos? ¿qué pasa si corrés el test con *estos* datos?
- ¿Las condiciones que causaron este bug están presentes en otro lugar?

→ **Candidatos a pilar: la sorpresa como puntero, y "select no está roto".**
El chequeo tiene "identificá al ACTOR por efecto antes de medirlo" y "¿qué
eligió la herramienta sola?", que apuntan a la herramienta como sospechosa.
Hunt & Thomas apuntan al lado opuesto y con más frecuencia estadística: la
falla es tuya, y el costo de creer lo contrario fue **semanas** de workarounds
que no funcionaban — y ese "mis workarounds no funcionan" **es** la señal de
que el modelo está mal. Rubber ducking es respaldo del método de trabajo
(escribir el razonamiento fuerza la suposición implícita a la superficie),
pero con el mecanismo explicitado, que es lo que lo hace usable.

### 3.6 Manipulación de texto (§19, p. 121)

> **Dica 28 — Aprendé un lenguaje de manipulación de texto.** (p. 122)

El argumento no es el lenguaje: es el **factor multiplicador y su umbral**.

> "Ese factor multiplicador es crucialmente importante para el tipo de
> experimentación que hacemos. **Gastar 30 minutos probando una idea loca es
> mucho mejor que gastar cinco horas. Gastar un día automatizando componentes
> importantes de un proyecto es aceptable; gastar una semana puede no
> serlo.**" (p. 121)

→ Es un criterio de corte para automatizar que el perfil no tiene numerado.

### 3.7 Generadores de código (§20, p. 124)

> **Dica 29 — Escribí código que cree código.** (p. 125)

La distinción que cambia una decisión, y que completa lo de §7:

| | **Pasivo** | **Activo** |
|---|---|---|
| Cuándo corre | **una vez** | **cada vez que hace falta la salida** |
| La salida | se vuelve fuente propia: se edita, se versiona, **se olvida de dónde salió** | **descartable**, se regenera |
| Estatus | "una conveniencia" | **"una necesidad si queremos seguir NSR"** |

> "Esto no es duplicación, porque las formas derivadas son descartables y las
> genera el generador cuando hacen falta — de ahí la palabra **activo**."
> (p. 126)

Dos detalles prácticos: (a) **un generador pasivo no tiene que ser exacto** —
el conversor troff→LaTeX de este mismo libro logró ~90% y el resto lo hicieron
a mano; "podés elegir cuánto esfuerzo poner en el generador según la energía
gastada en corregir sus salidas" (p. 126). (b) **un generador de código no
tiene que generar código**: HTML, XML, texto plano, cualquier cosa que sea
entrada en algún lugar del proyecto (p. 128).

Y el ejemplo del esquema de base de datos (Fig. 3.3, p. 127) trae el beneficio
oculto: si se borra una columna y el código se genera desde el esquema, el
campo desaparece y **el código de más alto nivel no compila**. "Capturaste el
error en tiempo de compilación y no en producción."

→ **Candidato a pilar, fusionado con §7.** `install.ps1` es un generador
activo: corre cada vez y regenera `~/.claude/` desde `perfil-global/`. La
distinción da el criterio: **cualquier cosa copiada una sola vez es pasiva y
va a divergir**; la pregunta al crear cualquier derivado es "¿esto se
regenera solo, o es una foto?".

---

## Capítulo 4 — Paranoia pragmática (pp. 129-158)

> "**No vas a conseguir crear software perfecto.** ¿Dolió? No debería.
> Aceptalo como un axioma de la vida. Abrazalo. Celebralo. Porque el software
> perfecto no existe." (p. 129)

Y el giro que hace que el capítulo no sea trivial:

> "Todos creen que ellos mismos son los únicos que manejan bien en el planeta
> Tierra… Por eso manejamos a la defensiva… Pero los programadores pragmáticos
> llevan esto un paso más allá: **tampoco confían en ellos mismos**. Sabiendo
> que nadie escribe código perfecto, ellos incluidos, **codifican
> defendiéndose de sus propios errores**." (p. 130)

### 4.1 Diseño por contrato (§21, p. 131)

> **Dica 30 — Diseñá con contratos.** (p. 133)

DBC de Meyer (Eiffel): **precondiciones** (qué tiene que ser verdad para que
la rutina se llame; responsabilidad **del llamador**), **poscondiciones** (qué
garantiza la rutina al terminar — lo cual implica que termina: nada de loops
infinitos) e **invariantes de clase**.

La postura de diseño, en una línea:

> "Sé **riguroso con lo que vas a aceptar** antes de empezar y **prometé lo
> menos posible** a cambio. Si tu contrato dice que aceptás cualquier cosa y
> prometés el mundo, vas a tener que escribir un código enorme." (p. 133)

Distinción que importa: **incumplir el contrato no es un bug**. "No es algo
que *podría* ocurrir — por eso las precondiciones **no** se usan para validar
entradas de usuario" (p. 133). La validación de entrada es del llamador; la
precondición documenta el dominio.

Y el beneficio principal, que es de diseño y no de runtime:

> "Tal vez el mayor beneficio del DBC es que **trae los requisitos y las
> garantías al primer plano**. Enumerar en el momento del diseño cuál es el
> dominio de las entradas, cuáles son las condiciones límite y qué promete
> entregar la rutina — **o, más importante, qué NO promete entregar** — es un
> gran paso adelante. **No declarando estas cosas, estás de vuelta en la
> programación basada en el azar.**" (p. 134-135)

Sin soporte del lenguaje: **poné el contrato como comentario igual**. "Como
mínimo, los contratos comentados te van a dar un lugar por dónde empezar a
buscar cuando aparezcan los problemas" (p. 135).

**Invariantes semánticas** (p. 138) — la parte más transferible:

Un *switch* de transacciones de tarjeta de débito tenía un requisito: que a un
usuario nunca se le aplicara la misma transacción dos veces. Es decir, ante
cualquier falla, **el error debía ser no procesar una transacción, no procesar
una duplicada**. Esa norma simple "resultó muy útil para resolver escenarios
complejos de recuperación de errores y dirigió el diseño y la implementación
detallada de muchas áreas". La escribieron así:

> **EL ERROR FAVORECE AL CONSUMIDOR.**

"Es una declaración clara, concisa y sin ambigüedad, aplicable en muchas áreas
distintas del sistema."

Con la advertencia explícita: **no confundas una norma fija inviolable con una
política que puede cambiar** con la próxima gerencia. Las invariantes
semánticas apuntan al significado verdadero de algo, no a caprichos.

→ **Respaldo con nombre + un candidato chico.** El perfil global *es* una
lista de invariantes semánticas ("el repo es la memoria", "confirmado = efecto
visto"), y ahora tienen nombre y un test para distinguirlas de las políticas.
Lo que **no** está y sí cambia una decisión: **declarar explícitamente lo que
NO se promete**. Un handoff que dice qué está resuelto pero no qué queda
explícitamente afuera deja al lector siguiente inventando garantías que nadie
dio.

### 4.2 Los programas muertos no cuentan mentiras (§22, p. 142)

> **Dica 31 — Terminá anticipadamente.** (p. 142)

"Es fácil dejarse llevar por la mentalidad *'esto no puede pasar'*." Todos
escribimos código que no chequea si un archivo se cerró bien o si una
sentencia de traza se creó como esperábamos. Y bajo condiciones normales no
haría falta. Pero:

> "**Todos los errores dan información.** Podrías convencerte de que el error
> no puede ocurrir y elegir ignorarlo. En vez de eso, los programadores
> pragmáticos piensan que **si hay un error, algo muy, muy malo pasó**."
> (p. 142)

Y la regla:

> "Cuando tu código perciba que algo considerado imposible acaba de ocurrir,
> **tu programa ya no es viable**. Cualquier cosa que haga a partir de ahí es
> sospechosa, así que terminalo apenas puedas. **Normalmente un programa
> muerto causa mucho menos daño que uno lisiado.**" (p. 143)

De ahí también: toda sentencia `case`/`switch` lleva cláusula `default`,
"porque queremos saber cuándo ocurrió lo 'imposible'" (p. 142).

→ **Candidato a pilar.** Es la contracara operativa de "todos los errores dan
información": lo que sigue corriendo después de un estado imposible produce
salida que **parece** dato. El chequeo tiene "'Succeeded' no es un resultado"
por el lado de la herramienta; esto es por el lado propio.

### 4.3 Programación asertiva (§23, p. 144)

> **Dica 32 — Si no puede pasar, usá aserciones para asegurar que no pase.**
> (p. 144)
> **Dica 33 — Dejá las aserciones activadas.** (p. 145)

El mantra que hay que desactivar: **ESTO NUNCA VA A PASAR**. Las cuatro
muestras que dan: "este código no se va a usar dentro de 30 años, así que
puedo usar fechas de dos dígitos"; "esta aplicación nunca se va a usar en el
exterior"; "`count` no puede ser negativo"; "este `printf` no puede fallar"
(p. 144). La regla: **cada vez que te pesques pensando "pero claro que esto
nunca podría ocurrir", agregá el código que lo verifique**.

Con los límites bien puestos: las aserciones no reemplazan el manejo real de
errores (no se asertan entradas de usuario), y la condición **no puede tener
efectos colaterales** — el recuadro de la p. 146 muestra un `ASSERT` con
`iter.nextElement()` adentro que hace que el loop procese la mitad de los
elementos. Lo llaman **"Heisenbug": depuración que altera el comportamiento
del sistema que se está depurando**.

Y la Dica 33, contra el "las aserciones son una función de depuración, se
desactivan en producción". Dos suposiciones obviamente falsas: (1) que los
tests encuentran todos los errores — "en cualquier programa complejo
probablemente no vas a testear ni un minúsculo porcentaje de las permutaciones
por las que va a pasar tu código"; (2) que el mundo de producción se parece al
de test — "durante los tests es improbable que las ratas roan un cable de
comunicaciones, que alguien agote la memoria o que los archivos de log llenen
el disco".

> "Desactivar las aserciones al distribuir un programa a producción es como
> **caminar en la cuerda floja sin red porque una vez ya lo lograste**. Tiene
> valor dramático, pero es difícil conseguir un seguro de vida." (p. 145)

Y la salida sensata si de verdad hay un problema de rendimiento: **desactivá
sólo las aserciones que lo afectan**, no todas.

→ **Respaldo de una línea que YA está en el Nivel 0**, y es el mejor ejemplo
de la lección 26 en todo el libro. El pilar de Leverage Points dice: "un freno
que nunca salta no es inútil: es un lazo de emergencia. Antes de sacar un aviso,
un test lento o una validación molesta, preguntá contra QUÉ IMPACTO fue
diseñado, no cuántas veces saltó". Hunt & Thomas llegan a lo mismo desde el
otro lado y le agregan la imagen de la cuerda floja y el permiso explícito de
sacar **sólo la que cuesta**. No sube nada nuevo; queda acá como respaldo.

### 4.4 Cuándo usar excepciones (§24, p. 147)

> **Dica 34 — Usá excepciones para problemas excepcionales.** (p. 149)

El test, que es lo aprovechable:

> "Supongamos que una excepción no capturada terminara tu programa. Preguntate:
> **'¿este código seguiría ejecutándose si yo sacara todos los manejadores de
> excepciones?'** Si la respuesta es 'no', tal vez las excepciones se estén
> usando en circunstancias no excepcionales." (p. 148)

El criterio del archivo: si el archivo **tenía** que estar ahí, la excepción
está justificada; si no sabés si tenía que estar, no es excepcional que no
esté y corresponde un retorno de error (p. 148-149). La razón de fondo: una
excepción es "una transferencia de control no local inmediata — un tipo de
`goto` en cascada", y **acopla la rutina con su llamador**.

### 4.5 Cómo balancear recursos (§25, p. 151)

> **Dica 35 — Terminá lo que empezaste.** (p. 151)

La rutina u objeto que asigna un recurso es responsable de liberarlo.

La historia, que vale por la firma del síntoma: `updateCustomer` abría el
archivo en `readCustomer` y lo cerraba en `writeCustomer`, acopladas por una
variable global `cFile` que **ni siquiera aparece en `updateCustomer`**. Cambia
la especificación (actualizar sólo si el saldo no es negativo), el programador
de mantenimiento agrega el `if`, **todo pasa los tests**… y en producción el
programa se cae **después de varias horas** quejándose de demasiados archivos
abiertos (p. 152).

Reglas de anidamiento (p. 153): **liberá en orden inverso al que asignaste**
(si no, dejás recursos huérfanos cuando uno referencia a otro), y **asigná
siempre en el mismo orden** en todos lados (reduce la chance de deadlock).

Cuando no se puede balancear (estructuras dinámicas): **establecé una
invariante semántica para la asignación** — decidí quién es responsable de los
datos de una estructura agregada. Tres opciones (la estructura de nivel
superior libera recursivamente / la libera y deja huérfanas las subestructuras
/ se niega a liberarse si tiene subestructuras). "La elección depende de cada
caso. Sin embargo, **tenés que hacerla explícita para cada una e implementar
tu decisión consistentemente**" (p. 157).

**Verificar el equilibrio** (p. 157): "ya que los programadores pragmáticos no
confían en nadie, ni en ellos mismos, siempre es buena idea construir código
que verifique que los recursos se estén liberando apropiadamente". Y el lugar
concreto: un programa de ejecución continua tiene **un solo punto al inicio de
su loop principal donde espera la próxima solicitud** — "ese es un buen lugar
para verificar que el uso de recursos no aumentó desde la última vuelta".

→ **Respaldo con un agregado.** "Terminá lo que empezaste" es el checkpoint de
la regla 5 del perfil visto como recurso. El agregado real es la **firma del
síntoma**: pasa los tests y falla después de horas en producción = desbalance
oculto por acoplamiento, no un bug de lógica.

---

## Capítulo 5 — Sé flexible (pp. 159-192)

El capítulo entero es la contracara constructiva de Reversibilidad (§9): allá
el peligro de las decisiones irreversibles, acá **cómo tomar decisiones
reversibles**.

### 5.1 La desvinculación y la Ley de Demeter (§26, p. 160)

> **Dica 36 — Reducí la vinculación entre módulos.** (p. 162)

"Buenas cercas hacen buenos vecinos" (Frost, epígrafe). La metáfora: espías y
disidentes se organizan en **células** — los individuos de una célula se
conocen entre sí pero no conocen a los de otras. Si una célula cae, no hay
suero de la verdad que revele nombres de afuera.

La **Ley de Demeter para funciones** (Fig. 5.1, p. 163): cualquier método de un
objeto sólo debería llamar métodos pertenecientes a **él mismo**, a **los
parámetros que le pasaron**, a **los objetos que él creó**, y a **los objetos
componentes que mantiene directamente**.

Lo transferible son **los tres síntomas de la explosión de dependencias**
(p. 162), porque son observables desde afuera:

1. Proyectos grandes donde **el comando que enlaza un test unitario es más
   largo que el propio programa de test**.
2. Cambios "simples" en un módulo que **se propagan a módulos no
   relacionados**.
3. **Desarrolladores que tienen miedo de cambiar el código porque no están
   seguros de qué puede verse afectado.**

Y el trade-off, dicho sin dogma: seguir Demeter cuesta muchos métodos
envoltorio, con costo de tiempo y espacio. Invertir la ley y acoplar
fuertemente varios módulos puede dar una mejora importante de rendimiento.
"**Mientras sea conocido y aceptable que esos módulos estén vinculados, tu
diseño está correcto**" (p. 163-164).

→ El síntoma 3 es el que vale para nosotros: **"miedo a tocar" es una medida
de acoplamiento**, no un rasgo de carácter. Y el trade-off explicitado es la
diferencia entre acoplamiento decidido y acoplamiento accidental.

### 5.2 Metaprogramación (§27, p. 166)

> **Dica 37 — Configurá, no integres.** (p. 166)
> **Dica 38 — Poné las abstracciones en el código y los detalles en
> metadatos.** (p. 167)
> **Dica 39 — No escribas código dodo.** (p. 170)

"Afuera con los detalles": sacalos del código para que el sistema sea
configurable y liviano. No sólo colores de pantalla, sino cosas hondas —
elección de algoritmos, producto de base de datos, estilo de interfaz.

El recuadro **"Cuándo configurar"** (p. 169) es lo que más nos toca:

> "Muchos programas sólo examinan estos ítems **en el arranque**, lo cual es
> inadecuado. Si tenés que cambiar la configuración, eso te obliga a reiniciar
> la aplicación. Un enfoque más flexible es hacer programas que puedan
> **recargar su configuración mientras se ejecutan**."

Con el costo dicho: es más complejo de implementar; para un servidor de
ejecución larga vale, para un cliente que reinicia rápido tal vez no.

→ **Observación sobre nuestro propio sistema, no pilar.** Los hooks del perfil
leen en `SessionStart` y nada más: editar `pilares.md` o el chequeo a mitad de
sesión **no tiene efecto en esa sesión**. Es la elección correcta para una
sesión de chat (reinicia rápido), pero conviene saberlo explícitamente en vez
de descubrirlo editando y esperando que cambie algo.

### 5.3 Vinculación temporal (§28, p. 172)

> **Dica 40 — Analizá el flujo de trabajo para mejorar la concurrencia.**
> (p. 173)
> **Dica 41 — Diseñá usando servicios.** (p. 176)
> **Dica 42 — Diseñá siempre pensando en la concurrencia.** (p. 178)

El diagnóstico de origen, que es la parte que vale:

> "Cuando la gente se sienta a diseñar una arquitectura o a escribir un
> programa, **las cosas tienden a ser lineales. Así es como piensa la mayoría
> de la gente**: hacen esto y después siempre hacen aquello. Pero pensar así
> lleva a la **vinculación temporal**: el método A siempre debe llamarse antes
> que el B; sólo se puede correr un reporte a la vez; hay que esperar a que la
> pantalla se redibuje antes de recibir el clic. **Tic tiene que venir antes
> que tac.** Ese enfoque no es muy flexible, ni muy realista." (p. 172)

El ejemplo de la piña colada (Fig. 5.2, p. 174): los usuarios describen 12
pasos en secuencia **y hasta los ejecutan en secuencia**, pero al dibujar el
diagrama de actividades se ve que las tareas 1, 2, 4, 10 y 11 pueden ocurrir
todas concurrentemente desde el arranque, y 3, 5 y 6 en paralelo después.

> "Puede ser revelador **ver dónde están realmente las dependencias**."

**Modelo del consumidor hambriento** (p. 176): en vez de un planificador
central, varias tareas consumidoras independientes y **una cola de trabajo
centralizada**. Cada consumidor agarra una porción, la procesa y vuelve a la
cola. "Si alguna tarea específica queda trabada, las otras pueden asumir por
ella y cada componente puede avanzar a su propio ritmo."

Y el argumento de por qué diseñar para concurrencia aunque no la uses:

> "Recorrer el otro camino —intentar agregarle concurrencia a una aplicación
> no concurrente— es mucho más difícil. Si diseñamos para permitir
> concurrencia, vamos a poder atender más fácilmente los requisitos de
> escalabilidad cuando llegue la hora; **y si la hora nunca llega, igual nos
> queda el beneficio de un diseño más limpio**." (p. 178)

→ **Candidato a pilar fuerte, y tapa un agujero real.** El chequeo transversal
que inyecta el hook hoy dice: *"¿El paso 2 depende del paso 1? → es SECUENCIAL.
Nada de fan-out."* Eso guarda **un solo** lado del error: la paralelización
falsa. Hunt & Thomas guardan el otro: **la secuencia falsa** — una lista de
pasos se escribe en orden porque así se piensa, no porque las dependencias
sean ésas. Los dos errores son reales y hoy sólo tenemos defensa contra uno.
El procedimiento es concreto y barato: escribí los pasos y después preguntá,
flecha por flecha, **cuál de esas flechas existe de verdad**.

### 5.4 Es apenas un modo de ver (§29, p. 179)

> **Dica 43 — Separá las vistas de los modelos.** (p. 183)

Publicación/suscripción y MVC: los objetos se registran para recibir sólo los
eventos que necesitan. "No queremos convertir a nuestros objetos en blanco de
spam" (p. 180). El anti-patrón nombrado: una sola rutina que recibe todos los
eventos de la aplicación, gobernada por "una inmensa sentencia `case` o un
`if-then` ramificado en varias direcciones" — viola encapsulamiento, aumenta
acoplamiento, y de paso NSR y ortogonalidad (p. 180).

Lo generalizable está en "más allá de las GUI" (p. 184): **la vista es una
interpretación del modelo y no tiene por qué ser gráfica**. El ejemplo del
relato de béisbol (Fig. 5.5, p. 185) arma una **red modelo-vista**: los datos
crudos del partido son el modelo; el marcador, las estadísticas del bateador,
los récords y las curiosidades son vistas; y esas vistas **se vuelven a su vez
modelos** de un objeto de nivel superior que decide qué mostrar, que a su vez
alimenta al teleprompter, a los subtítulos y a la página web.

> "Cada vínculo **desasocia los datos crudos de los eventos que los crearon**
> — cada vista nueva es una abstracción. Y como las relaciones son una red y
> no una cadena lineal, tenemos mucha flexibilidad."

→ Es la estructura exacta de esta capa: el libro es el modelo, la ficha es una
vista, `pilares.md` es una vista de la vista. Y explica por qué la lección 26
("no subas al pilar lo que ya está") es estructural y no estilística: dos
vistas que contienen el mismo dato dejaron de ser vistas y volvieron a ser
duplicación.

### 5.5 Pizarrones (§30, p. 187)

> **Dica 44 — Usá pizarrones para coordinar el flujo de trabajo.** (p. 191)

Los detectives alrededor de un pizarrón con una sola pregunta escrita arriba
—`H. DUMPTY (MASCULINO, HUEVO): ¿ACCIDENTE O ASESINATO?`— y cada uno agrega
hechos, testimonios y evidencia forense. Las características que enumeran
(p. 187):

- **Los detectives no necesitan saber que los otros existen**: sólo miran si
  hay información nueva en el pizarrón y agregan lo suyo.
- Pueden venir de disciplinas distintas, con distinta formación, y **ni
  siquiera trabajar en la misma comisaría**.
- **Pueden pasar por el pizarrón en turnos distintos.**
- No hay restricción sobre qué se puede poner: fotos, frases, evidencia
  física.

El caso de aplicación (hipotecas, p. 190) enumera las condiciones que lo hacen
la estructura correcta: **no hay garantías sobre el orden en que llegan los
datos**; los recolecta gente distinta en husos horarios distintos; parte llega
automáticamente y asincrónicamente; algunos datos dependen de otros; y **la
llegada de datos nuevos puede dar origen a reglas nuevas**.

Contra la alternativa de un sistema de flujo de trabajo: "pueden ser complejos
y exigir dedicación intensa del programador. A medida que las normas cambien,
el flujo debe reorganizarse". Y el cierre:

> "Podés obtener los mismos resultados con métodos de fuerza bruta, pero vas a
> tener un sistema más frágil. **Cuando se trabe, nadie va a conseguir hacerlo
> funcionar de nuevo.**" (p. 191)

Con el problema práctico anotado: cuando el caso es grande **el pizarrón se
llena y se vuelve difícil encontrar los datos**. La solución es dividirlo —
zonas, grupos de interés, o una estructura jerárquica (p. 190).

→ **Respaldo, con la mejor metáfora del libro para lo que hacemos.** El repo
**es** un pizarrón: sesiones distintas (turnos), Claudes distintos que no se
conocen entre sí, sin coordinación directa, cada uno lee lo que hay y agrega
lo suyo. Explica por qué "el repo es la memoria" funciona y por qué el chat no
puede reemplazarlo. Y el problema del pizarrón lleno es literalmente el
nuestro: 33 lecciones, `MEMORY.md`, `kb/`, las fichas — la respuesta del libro
es **dividirlo por zonas**, que es lo que ya hace la tabla "qué memoria es
cuál" del perfil.

---

## Capítulo 6 — Mientras estás codificando (pp. 193-222)

La premisa del capítulo, contra el sentido común: "cuando un proyecto está en
fase de codificación, el trabajo es casi todo mecánico". No. "**Hay decisiones
que tomar a cada minuto** — decisiones que requieren ponderación y juicio
cuidadoso si se espera que el programa resultante tenga una vida larga,
precisa y productiva" (p. 193).

### 6.1 Programación basada en el azar (§31, p. 194) ← la sección clave

> **Dica 45 — No programes por coincidencia.** (p. 197)

**La imagen.** El soldado sale del monte y tiene un claro por delante. ¿Hay
minas? No hay indicios: ni carteles, ni alambre de púa, ni pozos. Va sondeando
el suelo con la bayoneta y retrocediendo, esperando la explosión. No pasa nada.
Avanza con cuidado un rato, sondeando. Finalmente, **convencido de que el
campo es seguro, se compone y camina orgulloso** — y vuela en pedazos.

> "Las búsquedas iniciales del soldado no revelaron nada, pero eso fue apenas
> **suerte**. Fue llevado a una conclusión falsa, con resultados
> desastrosos." (p. 194)

**La historia de Fred**, y la línea que la hace valer:

Fred escribe código, lo prueba, parece andar. Escribe más, lo prueba, sigue
andando. Después de varias semanas así, el programa deja de funcionar de golpe
y, tras horas de intentar arreglarlo, sigue sin saber por qué.

> "**Fred no sabe por qué el código está fallando porque no sabe ni siquiera
> por qué funcionaba.** Parecía funcionar, dados los 'tests' limitados que
> hizo, pero eso fue una coincidencia. Amparado por una falsa confianza, Fred
> dejó de preocuparse demasiado temprano." (p. 195)

**Accidentes de implementación** (p. 195): apoyarse en condiciones límite o de
error **no documentadas**. El ejemplo es el mejor retrato de un parche vivo que
tiene el libro:

```java
paint(g); invalidate(); validate(); revalidate();
repaint(); paintImmediately(r);
```

"Acá parece que Fred está tratando desesperadamente de mostrar algo en
pantalla. Pero esas rutinas no fueron diseñadas para llamarse así; aunque
parezca que funcionan, es sólo una coincidencia." Y lo que sigue:

> "Y para no quedarse atrás, cuando el componente finalmente aparezca, Fred
> **no va a intentar sacar las llamadas incorrectas. 'Ahora funciona, mejor
> dejarlo así…'**" (p. 196)

Las cinco razones que dan para sacarlas igual:

1. **Puede no estar funcionando realmente** — puede sólo parecer que funciona.
2. La condición límite en la que te estás apoyando puede ser **accidental**:
   en otras circunstancias (otra resolución de pantalla) se comporta distinto.
3. El comportamiento no documentado **puede cambiar en la próxima versión**.
4. Las llamadas extra hacen el código más lento.
5. Las llamadas extra **agregan riesgo de errores nuevos causados por ellas
   mismas**.

Y la regla: "para las rutinas que vos llamás, **confiá sólo en comportamiento
documentado**. Si por alguna razón no podés, **documentá bien tu suposición**."

**Accidentes de contexto** (p. 196): "¿sólo porque ahora estás codificando
para un entorno gráfico, el módulo tiene que depender de que haya una GUI?
¿Estás pensando en usuarios que hablan portugués? ¿Usuarios alfabetizados?
**¿En qué más estás confiando que no está garantizado?**"

**Suposiciones implícitas** (p. 196): "las coincidencias pueden engañar en
todos los niveles — de la generación de requisitos al test. **El test es
particularmente propenso a falsas causalidades y resultados accidentales.**
Es fácil suponer que X causa Y, pero, como dijimos en Depurando: no supongas,
probá." Y: "**suposiciones no basadas en hechos bien establecidos son la ruina
de todos los proyectos**."

**Cómo programar deliberadamente** (p. 197-198), los siete puntos, de los que
tres son nuevos para nosotros:

- Estar siempre consciente de lo que estás haciendo. "Fred fue dejando
  lentamente que las cosas se salieran de control, **como la rana**."
- No codifiques a ciegas: usar una tecnología que no conocés en detalle "es
  una invitación a ser engañado por las coincidencias".
- Actuá según un plan — esté en tu cabeza, en el dorso de una servilleta o en
  un documento impreso.
- **Confiá sólo en cosas confiables. "Si no sabés la diferencia en
  circunstancias específicas, suponé lo peor."**
- Documentá tus suposiciones.
- **Testeá tus suposiciones, no sólo tu código.** "Escribí una aserción para
  testear tu suposición. Si la aserción está bien, mejoraste la documentación
  de tu código. **Si descubrís que tu suposición estaba mal, considerate con
  suerte.**"
- **Priorizá el esfuerzo.** "Gastá tiempo en los aspectos importantes: casi
  siempre son las partes difíciles. **Si no construís los aspectos básicos o
  la infraestructura correctamente, los adornos llamativos son
  irrelevantes.**"
- No seas esclavo de la historia. "No dejes que el código existente le dicte
  reglas al código futuro."

Cierre: "así que la próxima vez que algo **parezca** estar funcionando pero no
sepas por qué, **verificá que no sea sólo una coincidencia**."

→ **EL candidato a pilar del libro.** El perfil global tiene la regla 1
("Hipótesis ≠ confirmado; confirmado = efecto visto y registrado") y el chequeo
tiene cinco líneas sobre cómo no creerle a un resultado — pero **todas miran
el lado del fracaso o de la afirmación**: cómo no declarar confirmado algo que
no lo está. Ninguna mira el **éxito inexplicado**, que es el caso de Fred y es
el más peligroso porque no duele. Es también, exactamente, el pendiente
anotado de la asimetría del registro (33 lecciones = 33 fracasos): el perfil
no tiene ningún mecanismo que se active cuando algo **sale bien**.
El soldado del campo minado es, además, la mejor imagen para una línea que
**ya** está en el chequeo ("un negativo prueba dos cosas a la vez: que no
está, o que lo buscaste mal") — sondear y no encontrar nada no es evidencia de
que no hay nada.

### 6.2 Velocidad del algoritmo (§32, p. 199)

> **Dica 46 — Estimá el orden de tus algoritmos.** (p. 203)
> **Dica 47 — Testeá tus estimaciones.** (p. 204)

Notación O() y estimación por sentido común (loops simples → O(n); anidados →
O(m×n); división binaria → O(lg n); dividir y conquistar → O(n lg n);
combinatoria → factorial). Cultura general en su mayor parte. Lo que sí vale:

> "Después de todas esas estimaciones, **el único tiempo que interesa es la
> velocidad de tu código corriendo en el entorno de producción, con datos
> reales**." (p. 204)

Y el pie de página que lo prueba sobre ellos mismos: probando los algoritmos de
ordenamiento de esta sección en un Pentium de 64 MB, **se quedaron sin memoria
real con más de siete millones de números**; empezó a usar swap y los tiempos
empeoraron dramáticamente. O sea: la curva medida en chico no predice la de
producción cuando se cruza un umbral de recurso.

**"El mejor no siempre es mejor"** (p. 204): con un conjunto chico de entradas
un *insertion sort* anda igual de bien que un *quicksort* **y vas a tardar
menos en escribirlo y depurarlo**. Ojo con los algoritmos de costo de arranque
alto. Y: "cuidado con la optimización prematura. **Siempre es buena idea
asegurarse de que un algoritmo sea realmente un cuello de botella antes de
invertir tu precioso tiempo mejorándolo.**"

→ **Respaldo doble.** "Sólo cuenta el tiempo en producción con datos reales" es
la regla 2 del perfil ("el estado se mide, no se lee") aplicada al rendimiento.
Y "asegurate de que sea el cuello de botella antes de optimizar" es literalmente
el **factor limitante** de Meadows, que ya está en el Nivel 0.

### 6.3 Refactorización (§33, p. 206)

> **Dica 48 — Refactorizá temprano, refactorizá siempre.** (p. 208)

**La metáfora**, que es el aporte principal: el software no se parece a la
construcción de edificios (arquitecto → planos → contratistas → inquilinos
felices) sino a **la jardinería**. "Plantás muchas cosas según un plan y
condiciones iniciales. Algunas florecen, otras terminan siendo abono. Las
plantas más frondosas se separan o se podan, los colores que chocan se mueven
a lugares más agradables. Sacás yuyos y fertilizás lo que necesita ayuda extra.
**Monitoreás constantemente la salud del jardín y hacés ajustes.**" Y por qué
gana la otra: "a los empresarios les resulta cómoda la metáfora de la
construcción: es más científica que la jardinería, es repetible, hay una
jerarquía rígida de subordinación" (p. 206).

**Cuándo refactorizar** (p. 207): duplicación; diseño no ortogonal;
**conocimiento desactualizado** — "las cosas cambian, los requisitos varían y
**tu entendimiento del problema aumenta**. El código tiene que acompañar"; y
rendimiento.

**La excusa del tiempo, y la analogía médica** (p. 207-208):

> "Vas a tu jefe y le decís 'este código funciona, pero necesito otra semana
> para refactorizarlo'. No podemos mostrar su respuesta. […] No refactorices
> ahora y va a haber una inversión de tiempo mucho mayor para corregir el
> problema más tarde, cuando haya más dependencias que considerar. ¿Entonces
> va a haber más tiempo disponible? **No, según nuestra experiencia.**"

> "Considerá el código que necesita refactorización como un **tumor**. Sacarlo
> exige cirugía invasiva. Podés hacerla ahora, mientras todavía es chico. O
> podés esperar mientras crece y se disemina — pero entonces sacarlo va a ser
> caro y peligroso a la vez. Esperás un poco más **y podés perder
> definitivamente al paciente**."

**Las tres reglas de Fowler** para no hacer más daño que bien (p. 208):

1. **No intentes refactorizar y agregar funcionalidad al mismo tiempo.**
2. Asegurate de tener buenos tests **antes** de empezar, y corrélos tan seguido
   como puedas.
3. **Pasos cortos y deliberados.** "La refactorización suele involucrar muchos
   cambios localizados que resultan en un cambio de mayor escala. Si mantenés
   los pasos chicos, y testeás cada paso, **evitás una depuración
   prolongada**."

Y: "seguí la pista de lo que hay que refactorizar. **Si no podés refactorizar
algo inmediatamente, asegurate de que entre en el cronograma**" — que es
literalmente tapiar la ventana rota (§2).

→ **Candidato chico + respaldos.** La regla 1 de Fowler es concreta y no está:
el perfil dice "no refactorices fuera del scope" (regla 4), que cubre *no lo
hagas sin que te lo pidan*; Fowler cubre el otro caso, *si lo hacés, hacelo
solo*. Juntas cierran el tema. La regla 3 —pasos cortos, testear cada uno— es
respaldo directo del retardo de Meadows ("aplicá una fracción de la corrección,
no la corrección entera") desde otro dominio.

### 6.4 Código que sea fácil de testear (§34, p. 211)

> **Dica 49 — Diseñá para testear.** (p. 214)
> **Dica 50 — Testeá tu software o lo van a testear tus usuarios.** (p. 219)

**Testear contra el contrato** da dos cosas, no una: "si el código cumple el
contrato **y si el contrato significa lo que creemos que significa**" (p. 212).

**El orden importa** (p. 213-214). Si el módulo A usa `LinkedList` y `Sort`, se
testea el contrato completo de `LinkedList`, después el de `Sort`, y recién
después el de A. "Si los tests de `LinkedList` y `Sort` pasan pero el de A
falla, **tenemos certeza de que el problema está en A o en el uso que A hace de
esos subcomponentes**. Esta técnica es una gran manera de reducir el esfuerzo
de depuración: nos concentramos rápido en la causa probable y no perdemos
tiempo reexaminando los subcomponentes."

**Testes ad hoc** (p. 217) — la regla más barata y más olvidada:

> "Al final de la sesión de depuración, **formalizá el test ad hoc**. Si el
> código se rompió una vez, se puede romper de nuevo. **No descartes el test
> que creaste**: agregalo al test unitario existente."

**Construí una ventana de test** (p. 218). "Siempre vas a tener que testear el
software una vez desplegado, con datos del mundo real. A diferencia de un chip,
no tenemos pines de test en el software, pero **podemos proveer vistas del
estado interno de un módulo sin usar el debugger**" — que en producción puede
ser incómodo o imposible. Los mecanismos: archivos de log con **formato regular
y consistente** ("diagnósticos mal formateados o inconsistentes son sólo
verborragia: difíciles de leer e imposibles de analizar"), una combinación de
teclas que abre una ventana de diagnóstico, o un servidor web embebido en un
puerto no estándar para ver estado interno y logs.

**Una cultura de test** (p. 219). El ejemplo es Perl y su `make test`:

> "**No hay magia en Perl** respecto de esto… la gran ventaja es que **es un
> estándar: los tests ocurren en un lugar específico y tienen un resultado
> esperado. Testear es más cultural que técnico**; podemos crear esa cultura
> en un proyecto independientemente del lenguaje."

→ **Respaldos con dos agregados operativos.** El orden de testeo es el "control
positivo" del chequeo llevado a una cadena: verificás los subcomponentes
primero para que un fallo **localice**. Formalizar el test ad hoc es concreto y
no lo hacemos: los scripts de sondeo se escriben y se tiran. Y "testear es más
cultural que técnico — la ventaja es que **es un estándar, en un lugar
específico, con un resultado esperado**" es, en lenguaje de Meadows, la
observación de que la palanca no era la tecnología sino **la regla**; es lo
mismo que hace `install.ps1` + `verify-install.ps1` por el perfil.

### 6.5 Asistentes del mal (§35, p. 220)

> **Dica 51 — No uses código de un asistente que no entiendas.** (p. 221)

Los *wizards* generan el esqueleto: el entorno de Visual C++ generaba más de
1.200 líneas de un saque. "Pero **usar un asistente diseñado por un gurú no
convierte automáticamente al desarrollador Joe en un experto.** Joe puede
sentirse muy bien —acaba de producir un gran volumen de código y un programa de
aspecto elegante— pero si no entiende realmente el código que se produjo en su
nombre, **se está engañando: está programando basado en el azar**."

La objeción obvia, y **la respuesta, que es lo que hay que retener**:

> "Algunos dicen que ésta es una posición extrema. Dicen que los
> desarrolladores confían rutinariamente en cosas que no entienden por
> completo: la mecánica cuántica de los circuitos integrados, la estructura de
> interrupciones del procesador, los algoritmos de planificación de procesos,
> el código de las bibliotecas provistas. **Estamos de acuerdo. Y pensaríamos
> lo mismo de los asistentes si fueran apenas un conjunto de llamadas a
> biblioteca o servicios estándar del sistema operativo en los que se puede
> confiar. Pero no lo son.** El código generado por el asistente **se vuelve
> parte integral** de la aplicación de Joe: no queda detrás de una interfaz
> bien definida, sino **intercalado línea a línea** con la funcionalidad que
> Joe escriba. Con el tiempo deja de ser código del asistente y pasa a ser de
> Joe. **Y nadie debería producir código que no entienda íntegramente.**"
> (p. 221)

Y la otra mitad: "los asistentes son un camino de mano única — te crean el
código y eso es todo. Si lo que produjeron no está del todo correcto, o si las
circunstancias cambian y hay que adaptarlo, **estás por tu cuenta**."

→ **Candidato a pilar, y el más incómodo del libro.** Escrito en 1999 sobre
generadores de esqueletos de GUI, es punto por punto el argumento sobre el
código que yo genero. Lo importante es que **el criterio no es "entendé todo
lo que usás"** —los autores conceden explícitamente que eso es imposible— sino
**dónde queda lo generado**: detrás de una interfaz definida y estable se puede
confiar sin entenderlo; **intercalado línea a línea en tu propio código, pasó a
ser tuyo y hay que entenderlo entero**. Eso separa dos casos que hoy tratamos
igual, y es un test aplicable en el momento.

---

## Capítulo 7 — Antes del proyecto (pp. 223-244)

### 7.1 El abismo de los requisitos (§36, p. 224)

> **Dica 52 — No colectes requisitos: excavalos.** (p. 224)
> **Dica 53 — Trabajá con un usuario para pensar como un usuario.** (p. 226)
> **Dica 54 — Las abstracciones viven más que los detalles.** (p. 231)
> **Dica 55 — Usá un glosario del proyecto.** (p. 232)

Contra la palabra "recolección", que "parece implicar una tribu de analistas
felices juntando perlas de sabiduría desparramadas por el piso mientras suena
la Sinfonía Pastoral de fondo":

> "**Rara vez los requisitos están en la superficie. Normalmente están
> profundamente enterrados bajo capas de suposiciones, concepciones erradas y
> política.**" (p. 224)

**Requisito vs. política** (p. 225), que es la distinción operativa. El usuario
dice: *"sólo los supervisores del empleado y el departamento de personal pueden
ver su legajo"*. Eso mete una política de negocio dentro de una afirmación
absoluta. Si se escribe así, el desarrollador codifica un test explícito cada
vez que se accede a un legajo. Si se escribe *"sólo usuarios autorizados pueden
acceder a un legajo"*, el desarrollador construye un sistema de control de
acceso, y cuando la política cambie —y va a cambiar— **sólo se actualizan los
metadatos**. La recomendación: documentar la política **aparte** del requisito
y enlazarlos.

Y el criterio general: "**capturá las invariantes semánticas subyacentes como
requisitos y documentá las prácticas de trabajo actuales como políticas**"
(p. 230). Más el recordatorio seco: "los requisitos no son la arquitectura. Los
requisitos no son el diseño, ni la interfaz de usuario. **Los requisitos son
necesidades**."

**El porqué, no el cómo**: "es importante descubrir **la razón real** por la
que los usuarios hacen una cosa específica, en vez de saber sólo el modo en que
la hacen actualmente… Documentar las razones detrás de los requisitos le va a
dar a tu equipo información valiosa en la toma diaria de decisiones de
implementación" (p. 225).

**Y2K analizado** (p. 230-231), que es el mejor caso del capítulo:

> "La culpa del problema del año 2000 se le suele echar a programadores de
> vista corta desesperados por ahorrar unos bytes. **Pero no fue el
> comportamiento de los programadores y no fue realmente una cuestión de uso
> de memoria.** Si hubo un culpable, fue de los analistas y diseñadores. El
> problema surgió de dos causas principales: **no haber visto más allá de la
> práctica empresarial corriente**, y la violación de NSR. Las empresas usaban
> la abreviatura de dos dígitos **antes de que existieran las computadoras**.
> Era práctica común. Las primeras aplicaciones que procesaban fechas
> simplemente **automatizaron los procesos existentes y repitieron el
> error**."

O sea: **automatizar un proceso existente propaga sus errores a un lugar donde
arreglarlos cuesta mil veces más**. Aunque la arquitectura pidiera dos dígitos
para reportes, almacenamiento y entrada, tenía que haber una abstracción DATE
que **supiera** que esos dos dígitos eran una abreviatura.

**El "sólo un ítem más"** (p. 231-232): el crecimiento del alcance "es un
aspecto del síndrome de la rana hervida". Y la salida es un contador:

> "Es fácil ser succionado por el remolino del 'sólo un feature más', pero
> **rastreando los requisitos podés darte cuenta de que ese 'sólo un feature
> más' es en realidad el 15º agregado este mes**."

**Glosario** (p. 232): "es muy difícil que salga bien un proyecto donde
usuarios y desarrolladores se refieren a la misma cosa con nombres distintos
o, peor todavía, **se refieren a cosas distintas con el mismo nombre**."

→ **Candidato a pilar (el contador de la rana) + respaldos fuertes.** El Nivel 0
ya tiene la deriva gradual por el lado de Meadows y la rana por el lado de
Hunt & Thomas; lo que **ninguno de los dos tiene** es la salida, y acá está:
contra un cambio que no se nota desde adentro, **el remedio es contar**. No
mirar mejor: contar. Y2K es respaldo doblemente valioso: es un caso de "el
evento no era la causa" (Meadows) *y* de NSR, en el mismo hecho.

### 7.2 Resolviendo problemas imposibles (§37, p. 234)

> **Dica 56 — No pienses fuera de la caja: encontrá la caja.** (p. 235)

Alejandro corta el nudo gordiano con la espada: "es una interpretación sólo un
poco distinta de los requisitos, nada más… y terminó gobernando buena parte de
Asia."

> "'Pensar fuera de la caja' no está del todo bien. Si la 'caja' es el límite
> de las restricciones y condiciones, **el truco es encontrar la caja, que
> puede ser considerablemente más grande de lo que pensás**." (p. 235)

**El procedimiento**, textual: "ante un problema difícil, **enumerá todas las
salidas posibles que tenés adelante. No descartes nada, por más inútil o
estúpido que parezca. Ahora recorré la lista y pensá POR QUÉ un determinado
camino no se puede tomar. ¿Estás seguro? ¿Lo podés probar?**" Con el ejemplo:
el caballo de Troya — "podés apostar que inicialmente la alternativa 'por la
puerta del frente' fue descartada como suicidio."

Y priorizar restricciones como un carpintero: **cortá primero las piezas más
largas** y sacá las chicas de lo que sobra. "Identificá primero las
restricciones más limitantes y encajá las demás adentro."

**"¡Tiene que haber un camino más fácil!"** (p. 236). Cuando sentís que estás
en un problema mucho más difícil de lo que debería ser, las seis preguntas:

1. ¿**Hay** un camino más fácil?
2. ¿Estás resolviendo el problema correcto, o tu atención se desvió a un
   asunto técnico periférico?
3. ¿**Por qué** esto es un problema?
4. ¿Qué lo hace tan difícil de resolver?
5. ¿Tiene que hacerse **de esta manera**?
6. ¿Tiene que hacerse, después de todo?

"Muchas veces hay una revelación sorprendente al tratar de responder una de
estas preguntas. En muchos casos, **una reinterpretación de los requisitos hace
desaparecer un grupo entero de problemas** — igual que con el nudo gordiano."

→ **Candidato a pilar fuerte.** Tiene las dos mitades que hacen que una regla
sirva: **un disparador observable** ("esto está costando mucho más de lo que
debería") y **una acción fija** (las seis preguntas, o enumerar salidas y pedir
prueba de por qué cada una está descartada). El chequeo ya tiene el primo
cercano —"una búsqueda que sigue dando demasiados candidatos: sospechá del
PARÁMETRO de la búsqueda"— pero sólo para búsquedas.

### 7.3 No antes de que estés listo (§38, p. 237)

> **Dica 57 — Empezá sólo cuando estés listo.** (p. 237)

"Los profesionales exitosos comparten una peculiaridad: **saben cuándo empezar
y cuándo esperar**." El clavadista parado en el trampolín; el director frente a
la orquesta con los brazos levantados. Si te sentás a escribir y tenés una duda
insistente, prestale atención.

Y el test que separa el instinto de la procrastinación, que es lo que hace
usable la sección (p. 238):

> "**Empezá un prototipo.** Elegí un área que creas que va a ser difícil y
> empezá a producir alguna prueba de concepto. Normalmente pasa una de dos
> cosas. Enseguida podés sentir que **estás perdiendo el tiempo: ese
> aburrimiento es buena señal de que tu reluctancia era sólo ganas de
> postergar** — tirá el prototipo y andá al desarrollo real. O, a medida que
> el prototipo avanza, podés tener un momento de revelación en el que de golpe
> ves que **alguna premisa básica estaba mal** — y además ves cómo
> arreglarla."

Con la advertencia: "lo último que querés es pasar varias semanas desarrollando
en serio y después acordarte de que la intención inicial era hacer un
prototipo."

→ **Candidato a pilar.** Convierte un sentimiento no falsable ("algo no me
cierra") en un experimento barato y de resultado binario, en el que **las dos
respuestas son útiles**. No hay nada parecido en el perfil.

### 7.4 La trampa de las especificaciones (§39, p. 239)

> **Dica 58 — Algunas cosas son fáciles de hacer, pero no de describir.**
> (p. 240)

El desafío del cordón: escribí una descripción corta que le explique a alguien
cómo atarse los cordones. "Si sos parecido a nosotros, probablemente
abandonaste cerca de *'ahora deslizá el pulgar y el índice para que el extremo
libre pase por debajo y por dentro del lazo izquierdo…'*. Es muy difícil de
hacer. Y sin embargo, casi todos nos atamos los zapatos sin pensarlo."

**El efecto camisa de fuerza**: "un diseño que no deja espacio de
interpretación al codificador elimina del esfuerzo de programación toda
habilidad y arte… **Muchas veces es sólo durante la codificación que ciertas
opciones se vuelven aparentes**" (p. 240).

Y las dos advertencias que sí se aplican a cómo escribimos planes y skills:

> "Cuidado también con construir especificaciones basadas en otras
> especificaciones **sin ninguna implementación o prototipo que las sostenga:
> es demasiado fácil especificar algo que no se puede construir**." (p. 240)

> "Cuanto más permitas que las especificaciones actúen como **frazadas
> cómodas** que protegen a los desarrolladores del mundo aterrador de escribir
> código, más difícil va a ser pasar a codificar." Y la salida: si el equipo
> está protegido por especificaciones cómodas, **hacelos actuar — prototipo o
> proyectil trazador**. (p. 241)

Con la excepción declarada al pie: las especificaciones detalladas **sí**
corresponden en sistemas críticos para la vida, y en **interfaces y bibliotecas
que van a usar otros** — "cuando toda tu salida se va a ver como un conjunto de
llamadas a rutinas, mejor asegurarse de que esas llamadas estén bien
especificadas".

### 7.5 Círculos y flechas (§40, p. 242)

> **Dica 59 — No seas esclavo de los métodos formales.** (p. 242)
> **Dica 60 — Las herramientas caras no producen mejores diseños.** (p. 244)

El hallazgo que vale, del artículo de Robert Glass en CACM 1999 [Gla99b] sobre
siete tecnologías de desarrollo (4GL, técnicas estructuradas, CASE, métodos
formales, sala limpia, modelos de proceso, orientación a objetos):

> "Aunque hay indicios de que algunos métodos presentan beneficios, **esos
> beneficios sólo empiezan a manifestarse después de una caída significativa
> en la productividad y la calidad**, mientras la técnica se adopta y sus
> usuarios se acostumbran. **Nunca subestimes el costo de adoptar
> herramientas y métodos nuevos.** Estate preparado para tratar los primeros
> proyectos que las usen como una experiencia de aprendizaje." (p. 243)

Y: "no te dejes engañar por **la falsa autoridad de un método**. La gente puede
entrar a una reunión con cientos de diagramas de clases y 150 casos de uso,
pero todo ese papeleo sigue siendo **su interpretación falible** de los
requisitos y del diseño. Tratá de no pensar cuánto cuesta una herramienta
mientras examinás su salida" (p. 244).

→ **Respaldo importante de una línea del Nivel 0, con una consecuencia nueva.**
El pilar de Meadows dice que en un sistema con retardo, reaccionar más rápido y
más fuerte **amplifica** la oscilación. La curva en J de Glass es ese retardo
medido: **un método nuevo empeora las cosas primero**. La consecuencia
operativa, que no está escrita en ningún lado: **no evalúes un método durante
su propia caída de adopción**, o vas a matar exactamente lo que iba a andar.
La descripción de qué hace un programador pragmático con las metodologías —
"las considera críticamente, extrae lo mejor de cada una y las combina en un
conjunto de prácticas de trabajo **que mejora cada mes**"— es, literalmente,
la descripción de `perfil-global/`.

---

## Capítulo 8 — Proyectos pragmáticos (pp. 245-282)

### 8.1 Equipos pragmáticos (§41, p. 246)

> **Dica 61 — Organizá los equipos en base a la funcionalidad.** (p. 249)

El capítulo reformula las secciones anteriores en clave de equipo. Dos cosas
salen nuevas.

**El equipo hervido, y el rol que lo evita** (p. 247):

> "Es **todavía más fácil** que se cocine un equipo entero. **La gente supone
> que alguien está resolviendo el problema**, o que el líder debe haber
> aprobado el cambio que pide el usuario. Hasta los equipos mejor
> intencionados pueden ser descuidados con cambios significativos."

La salida es explícita y es un rol: designá un **supervisor de cambios del
entorno**, que busque constantemente aumentos de alcance, reducciones de
plazos, features adicionales, entornos nuevos — cualquier cosa que no formara
parte de lo acordado originalmente. Y el criterio, que es lo bueno:

> "**El equipo no necesita rechazar los cambios ya hechos: sólo tenés que
> saber que están ocurriendo. Si no, el que se cocina sos vos.**"

**Organización por funcionalidad, no por rol** (p. 249-250). La organización
tradicional asigna roles según el cargo —analistas, arquitectos, diseñadores,
programadores, testers, documentadores— con una jerarquía implícita: "cuanto
más cerca del usuario podés llegar, más categoría tenés". El error:

> "Es un error pensar que las actividades de un proyecto —análisis, diseño,
> codificación y test— pueden ocurrir aisladas. **No pueden.** Son distintos
> aspectos del mismo problema y separarlos artificialmente causa muchos
> problemas. Los programadores que están a dos o tres niveles de los usuarios
> reales de su código probablemente no van a conocer el contexto en el que se
> usa su trabajo. **No van a poder tomar decisiones fundadas.**"

En cambio: equipos chicos, cada uno responsable de **un aspecto funcional**,
autoorganizados internamente. "Queremos equipos cohesivos y muy independientes
— **exactamente los mismos criterios que usamos para modularizar el código**."
La señal de alarma: **dos subequipos trabajando sobre el mismo módulo**.

Con la advertencia que evita leerlo como anarquía: "esto sólo funciona con
desarrolladores responsables y una gerencia fuerte. **Armar un pool de equipos
autónomos y soltarlos sin liderazgo es una receta para el desastre.**" Hacen
falta dos liderazgos: uno técnico —define la filosofía y el estilo, asigna
responsabilidades, media, y **está siempre mirando el cuadro general buscando
atributos comunes entre equipos que reduzcan la ortogonalidad del esfuerzo**—
y uno administrativo.

Y sobre el supervisor de calidad delegado: "es ridículo. **La calidad sólo
puede venir de las contribuciones individuales de todos los miembros**"
(p. 247).

→ **Directo sobre la decisión de fan-out.** Los mismos criterios que para
modularizar código: cortar por funcionalidad, no por rol; que cada pieza tenga
contexto suficiente para decidir; señal de alarma si dos piezas tocan lo mismo;
y **un liderazgo técnico que mire el conjunto** — no hay tal cosa como soltar
agentes autónomos y esperar coherencia.

### 8.2 Automatización omnipresente (§42, p. 252)

> **Dica 62 — No uses procedimientos manuales.** (p. 253)

El Ford T necesitaba más de dos páginas de instrucciones para arrancar; el auto
moderno, girar la llave. "Una persona siguiendo una lista de instrucciones
puede ahogar el motor; **el arranque automático no**."

**La historia que es la nuestra** (p. 253):

> "Estuvimos en las instalaciones de un cliente donde todos los
> desarrolladores usaban el mismo IDE. El administrador le daba a cada uno un
> conjunto de instrucciones para instalar los paquetes complementarios: muchas
> páginas llenas de *hacé clic acá, bajá allá, arrastrá esto, doble clic en
> aquello, y hacelo todo de nuevo*. **No sorprende que la máquina de cada
> desarrollador hubiera quedado cargada de manera un poco distinta.
> Aparecían diferencias sutiles de comportamiento cuando desarrolladores
> distintos ejecutaban el mismo código. Los errores aparecían en una máquina
> y no en otras.**"

> "**La gente simplemente no está tan capacitada para repetirse como las
> computadoras. Ni deberíamos esperar que lo esté.**" (p. 253)

Y el argumento extra de poner el script bajo control de versiones: "podés
examinar los cambios que sufrió el procedimiento con el tiempo (***'pero antes
funcionaba…'***)".

**Generación del sitio** (p. 257), que es NSR + MVC aplicados a la
documentación:

> "El contenido web debe generarse **automáticamente** a partir de la
> información del repositorio y publicarse **sin intervención humana**. Es otra
> aplicación de NSR: la información existe en una forma, como documentos y
> código almacenado. **Lo que se ve en el navegador es sólo eso: una vista. No
> deberías tener que mantener esa vista a mano.**"

Con la línea que la justifica: "**información incorrecta es peor que ninguna
información**".

Y el dato de Glass [Gla99a], CACM abril 1999: **inspeccionar el código es
eficaz; hacer las revisiones en reuniones no lo es** (p. 258).

Cierre: *casa de herrero, cuchillo de palo* — "muy seguido, los que desarrollan
software son los que usan las peores herramientas para hacer su trabajo."

→ **Respaldo casi literal de `install.ps1` y `verify-install.ps1`.** El caso del
IDE es la razón por la que el perfil se instala con un script y se verifica por
efecto, en vez de con una lista de pasos en un README. Y "no deberías mantener
la vista a mano" abre una pregunta honesta sobre esta capa: la ficha se genera
sola desde el PDF (`tramo.py`), pero `pilares.md` **se cura a mano** desde la
ficha. Eso es correcto —el filtro "¿cambia una decisión?" es criterio, no
mecánica— pero hay que saber que es una vista **no** regenerable, y que por eso
puede divergir de la ficha sin que nada avise.

### 8.3 Testeando implacablemente (§43, p. 259)

> **Dica 63 — Testeá temprano. Testeá seguido. Testeá automáticamente.**
> (p. 259)
> **Dica 64 — La codificación sólo está terminada cuando pasaron todos los
> tests.** (p. 260)

"**Los tests que corren en cada build son mucho más eficaces que los planes de
test que quedan esperando a ser usados.**" Y: "que acabes de escribir el código
no significa que puedas ir a decirle a tu jefe que terminaste. No terminaste."

**Qué testear** — la lista de seis (p. 260-263): unidad, integración,
**validación y verificación**, **agotamiento de recursos / errores /
recuperación**, rendimiento, usabilidad.

De ésas, dos importan acá:

> **Validación y verificación:** "los usuarios te dijeron lo que querían, pero
> **¿es eso lo que necesitan?** … **Un sistema sin bugs que resuelve el
> problema equivocado no sirve de mucho.**" (p. 261)

> **Agotamiento de recursos:** la lista completa es memoria, espacio en disco,
> **ancho de banda de CPU**, **horas de reloj físico**, ancho de banda de
> disco, ancho de banda de red, paleta de colores y resolución de video. Y la
> pregunta: "es posible que verifiques fallas de disco o de asignación de
> memoria, pero **¿con qué frecuencia verificás las otras?**" (p. 262)

Sobre métricas (p. 264): complejidad ciclomática de McCabe, fan-in/fan-out,
conjunto de respuesta, tasas de vinculación. "Algunas métricas están diseñadas
para dar una nota de aprobación; **otras sólo sirven por comparación** — hay
que calcularlas para cada módulo y ver cómo se relaciona uno con sus pares. Si
encontrás un módulo cuya métrica es marcadamente distinta de todo el resto,
tenés que ponderar si eso es apropiado."

Y la nota al pie que resume la actitud del capítulo entero: sobre la frase
"**cuando** el sistema realmente falle" — "nuestro revisor quería que la
cambiáramos por '**si** el sistema realmente falla'. **No estuvimos de
acuerdo.**"

→ La lista de agotamiento de recursos es el respaldo más útil: nombra los
límites que **no** se chequean. Y "un sistema sin bugs que resuelve el problema
equivocado" es la misma cosa que el criterio de salida de fase por resultado y
no por esfuerzo.

#### 8.3.1 Saboteadores: testear el test (p. 266)

> **Dica 65 — Usá saboteadores para testear tus tests.** (p. 266)

Es la mejor idea del capítulo y no está en ningún lado del perfil:

> "Ya que no podemos crear software perfecto, **tampoco podemos crear software
> de test perfecto. Hay que testear los tests.** Pensá tu batería de tests
> como un sistema de seguridad elaborado, diseñado para hacer sonar la alarma
> cuando aparece un error. **¿Hay mejor manera de testear un sistema de
> seguridad que tratando de burlarlo?** Después de crear un test para detectar
> un error específico, **provocá el error deliberadamente y verificá que el
> test se queje.** Eso garantiza que va a capturar el error si ocurre de
> verdad."

Y llevado a rol: designá un **saboteador del proyecto**, que obtiene una copia
separada del árbol de fuentes, **introduce errores a propósito** y verifica que
los tests los capturen.

#### 8.3.2 Cobertura de estados, no de código (p. 267)

> **Dica 66 — Testeá la cobertura de estados, no la cobertura del código.**
> (p. 267)

```java
int test(int a, int b) { return a / (a + b); }
```

Tres líneas. Con `a` y `b` entre 0 y 999, tiene **1.000.000 de estados
lógicos**: 999.999 andan y **uno** no (cuando `a + b == 0`). "Saber que
ejecutaste esa línea de código no te informa de eso." Y el remate: "aun con
buena cobertura de código, los datos que uses importan mucho y, **lo más
importante, el orden en el que recorras el código puede ser lo que cause el
mayor impacto de todo**."

→ Una métrica de cobertura es un *proxy* que tapa justo lo que importa. Mismo
patrón que "medir esfuerzo produce esfuerzo".

#### 8.3.3 Encontrá los errores una sola vez (p. 268)

> **Dica 67 — Encontrá los errores una sola vez.** (p. 269)

> "Es obvio y prácticamente todos los libros lo recomiendan. **Pero por alguna
> razón la mayoría de los proyectos todavía no lo adoptó.** […] Cuando un
> testeador humano encuentra un error, **esa debe ser la última vez que un
> testeador humano lo encuentra**. Los tests automatizados deben modificarse
> para buscar ese error específico de ahí en adelante, siempre, sin
> excepciones, no importa lo trivial que sea ni cuántas veces el desarrollador
> se queje diciendo 'esto no va a pasar de nuevo'. **Porque va a pasar de
> nuevo.**"

→ **Respaldo exacto de `aprendizaje/lecciones.jsonl` y de `aprender.py`**, que
es esta Dica aplicada a errores de **proceso** en vez de a errores de código.
Ahora tiene nombre y, sobre todo, tiene la respuesta a la objeción ("esto no va
a pasar de nuevo").

### 8.4 Todo se reduce a escribir (§44, p. 270)

> **Dica 68 — Tratá el idioma como un lenguaje de programación más.** (p. 270)
> **Dica 69 — Construí la documentación adentro del código, no se la agregues
> como complemento.** (p. 270)

El epígrafe es, palabra por palabra, la regla 2 del perfil: **"La tinta más
débil es mejor que la memoria más afilada"** (proverbio chino).

**Comentarios: el porqué, no el cómo** (p. 271):

> "Los comentarios deben discutir **por qué** algo se hace, su finalidad y su
> objetivo. **El código ya muestra cómo se hace**, así que ese comentario sería
> redundante — y una violación de NSR. Comentar el código te da la oportunidad
> perfecta de documentar las partes vagas de un diseño que no se pueden
> documentar en otro lado: **elecciones de ingeniería, por qué se tomaron
> ciertas decisiones, qué alternativas se descartaron**."

→ Es exactamente el contrato de `ESTADO_ACTUAL.md` / `HANDOFF.md` / `kb/`: el
repo guarda **lo que decidimos y qué se descartó**, no lo que se puede leer del
disco.

**El efecto Stroop y los nombres que mienten** (p. 271-272):

> "Peor que los nombres sin significado son **los nombres ambiguos**. ¿Nunca
> escuchaste a alguien explicar inconsistencias en código legado con un *'la
> rutina que se llama `capturaDatos` en realidad escribe datos al disco'*?
> **El cerebro humano siempre se va a enredar con eso** — es el efecto
> Stroop."

El experimento: escribí nombres de colores con marcadores, nunca usando el
marcador del color que nombra la palabra ("azul" en verde, "marrón" en rojo).
Después decí en voz alta, rápido, el **color** de cada palabra. En algún
momento vas a empezar a leer los nombres. "**Los nombres son muy relevantes
para nuestro cerebro, y los nombres ambiguos van a llevar caos a tu código.**"

Y: "vas a leer el código muchos cientos de veces y sólo lo vas a escribir unas
pocas. **No trates de ganar tiempo escribiendo `cp` en vez de
`connectionPool`.**"

**Qué NO va en los comentarios** (p. 272), porque una herramienta lo deriva
mejor: la lista de funciones exportadas, el **historial de revisiones**, la
lista de archivos que usa, y **el nombre del archivo** — "si tiene que
aparecer, no lo mantengas a mano".

**Documentos ejecutables** (p. 273): elegí **una** fuente autorizada y exportá
las demás formas desde ella. "La única manera de cambiar el esquema es cambiar
el documento."

Y el cierre, que es la tesis del libro entero aplicada a la documentación:

> "**La documentación y el código son vistas distintas del mismo modelo
> subyacente, pero sólo la vista debe ser distinta.** No dejes que la
> documentación se vuelva un elemento de segunda clase, desterrado del flujo
> de trabajo principal del proyecto." (p. 276)

Con el desafío final, que es una acusación: "puede resultar incómodo documentar
el diseño porque todavía no está claro en tu cabeza; todavía está madurando. No
te parece que haya que perder tiempo describiendo lo que algo hace hasta que
realmente lo haga. **¿Eso no suena a programar basado en el azar?**" (p. 277)

### 8.5 Grandes expectativas (§45, p. 277)

> **Dica 70 — Excedé gentilmente las expectativas de tus usuarios.** (p. 277)

"En un sentido abstracto, una aplicación es exitosa cuando implementa
correctamente sus especificaciones. Lamentablemente, eso sólo paga cuentas
abstractas." Lo que se mide es hasta dónde cumple **las expectativas**. Y la
simetría, que es lo que hace útil la Dica: quedarse corto condena el proyecto
por bueno que sea el producto en términos absolutos, **pero excederse mucho
también falla** — el chico que llora abriendo un regalo caro porque esperaba la
muñeca barata.

Contra "gestión de expectativas": "nos parece una posición un poco elitista.
**Nuestro papel no es controlar las esperanzas de nuestros usuarios**", sino
llegar a un consenso con ellos y **considerar las expectativas que todavía no
verbalizaron**. Las dos técnicas para eso son las mismas de siempre:
**proyectiles trazadores y prototipos** — las dos construyen algo que el
usuario puede ver.

### 8.6 Orgullo y prejuicio (§46, p. 280)

> **Dica 70 (la última) — Firmá tu trabajo.** (p. 280)

> "**El anonimato, sobre todo en proyectos grandes, es terreno fértil para el
> descuido, los errores, la pereza y el código malo. Es fácil verse a uno
> mismo como una pieza del engranaje, produciendo excusas baratas en informes
> de estado interminables en vez de código interesante.**" (p. 280)

Con el matiz que evita el feudalismo: "aunque el código necesita un dueño, no
tiene que pertenecer a **una** persona" — la propiedad comunitaria de XP
funciona, pero requiere prácticas adicionales (programación de a pares) para
evitar los peligros del anonimato. Y: "no defiendas celosamente tu código
contra intrusos; y tratá el código de los demás con respeto."

> "Tu firma debe ser reconocida como un indicador de calidad. **La gente
> debería ver tu nombre en un código y esperar que sea consistente, bien
> escrito, testeado y documentado.** Un trabajo realmente profesional. Escrito,
> con seguridad, por un profesional. Un programador pragmático." (p. 281)

---

## EL PILAR — lo que sube a la capa que se lee sola

Filtro aplicado (README de `pilares/`): **¿cambia una decisión concreta que se
toma seguido, Y no está ya en las 10 líneas del Nivel 0?** De 70 Dicas, 46
secciones y ~35 anotaciones marcadas arriba, pasan **siete**. Lo que quedó
afuera y por qué:

| Queda afuera | Por qué |
|---|---|
| NSR / DRY (§7) | ya está: *"un dato que vive en dos lados diverge"* (perfil, tabla de memorias) |
| Aserciones siempre activadas (§23) | ya está: *"un freno que nunca salta es un lazo de emergencia"* (Leverage Points) |
| "Encontrá los errores una sola vez" (§43) | ya está, y es el mecanismo: `lecciones.jsonl` + `aprender.py` |
| Optimización prematura / cuello de botella (§32) | ya está: *"sólo importa el factor limitante"* (Thinking in Systems) |
| Control de fuentes siempre (§17) | ya está: regla 2 del perfil |
| Pasos cortos al refactorizar (§33) | ya está: *"aplicá una fracción de la corrección"* (retardo, Meadows) |
| Curva en J de adopción (§40) | mismo lazo que el retardo de Meadows; queda acá con su consecuencia |
| Calidad como requisito, saber cuándo parar (§4) | ya está: regla 4 (cambios mínimos) + criterio de salida por resultado |
| Pizarrón (§30), MVC (§29), Demeter (§26), lenguajes de dominio (§12), O() (§32), shell/editor/texto plano (§14-16) | cultura general o respaldo: no cambian una decisión de turno |
| Secuencia falsa vs. paralelismo falso (§28) | **no entra al pilar pero abre un pendiente**: el chequeo sólo defiende un lado. Ver abajo. |

Las siete que suben están escritas en ASCII puro en
[`perfil-global/pilares.md`](../pilares.md), bajo el título *"HACER ES UN
OFICIO, Y TIENE REGLAS"*. Cada una, con su ancla:

1. **El éxito inexplicado es una coincidencia todavía no descubierta** — §31,
   pp. 194-198 (Fred; el soldado del campo minado; las cinco razones para sacar
   las llamadas que "ya funcionan").
2. **Un verificador que nunca falló está sin verificar** — §43, p. 266
   (saboteadores).
3. **La sorpresa mide la confianza, y ahí está la suposición equivocada** —
   §18, p. 119 (el elemento sorpresa) + p. 118 ("select no está roto").
4. **Trazador o prototipo: decidilo antes, no después** — §10-11, pp. 70-78.
5. **"Esto cuesta más de lo que debería" es un disparador, no una queja** —
   §37, pp. 234-236 (encontrá la caja; las seis preguntas).
6. **El costo de deshacer es un eje propio** — §9, pp. 66-69 (reversibilidad;
   decisiones escritas en la arena) + §40, p. 243 (la curva en J: un método
   nuevo empeora las cosas primero).
7. **Lo generado se juzga por dónde queda, no por si lo entendés todo** — §35,
   pp. 220-221 (asistentes del mal).

## PENDIENTES QUE ABRE ESTE LIBRO (no son de esta fase)

1. **El chequeo de trabajo defiende un solo lado de la descomposición.** Hoy
   dice: *"¿El paso 2 depende del paso 1? → es SECUENCIAL. Nada de fan-out."*
   Eso protege contra el **paralelismo falso**. Hunt & Thomas (§28, p. 172)
   describen el error simétrico y más frecuente: **la secuencia falsa** — "las
   cosas tienden a ser lineales; así es como piensa la mayoría de la gente".
   El ejemplo de la piña colada muestra 12 pasos escritos y ejecutados en
   orden de los que 5 podían arrancar a la vez. Falta la contraparte en
   `chequeo-de-trabajo.md`, con su procedimiento: escribí los pasos y después
   preguntá, flecha por flecha, cuál de esas flechas existe de verdad.
2. **`verify-install.ps1` nunca fue saboteado.** Verifica por efecto, que es
   lo correcto (lección 7), pero **nadie rompió la instalación a propósito
   para ver si se pone en rojo**. Según §43 (p. 266), eso lo deja en la
   categoría de "sistema de alarma sin probar". Es una tarde de trabajo y
   cierra el círculo de la lección 7.
3. **`pilares.md` es una vista curada a mano de las fichas.** §42 (p. 257)
   dice que las vistas se generan y no se mantienen a mano. Acá la curación
   **es** el trabajo (el filtro "¿cambia una decisión?" es criterio, no
   mecánica), así que la excepción está justificada — pero conviene saber que
   es una vista no regenerable y que puede divergir de las fichas sin que nada
   avise.
