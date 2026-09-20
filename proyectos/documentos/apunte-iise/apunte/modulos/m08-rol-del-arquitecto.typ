#import "../plantilla.typ": *

#modulo(
  "El rol del arquitecto",
  [Enunciar los tres roles del #t[arquitecto de sistemas] —reducir
   ambigüedad, emplear creatividad, gestionar complejidad—; explicar por qué
   no es un generalista; y enumerar los entregables del arquitecto,
   distinguiéndolos de las tareas que los producen.],
  clave: "rol-del-arquitecto",
)

#lectura[
  Clase 3, diapositivas 2 a 17 y 40. La fuente es el capítulo 9, "El Rol de
  la Arquitectura", del mismo libro que la unidad 2 (Crawley, Cameron y
  Selva).
]

== Un especialista, no un generalista

El énfasis en el holismo de la unidad anterior puede leerse mal: parecería
que el arquitecto tiene que gestionar *todo*. No es así.

#definicion("rol del arquitecto")[
  Parafraseando a Eberhardt Rechtin: el arquitecto no es un generalista, sino
  un *especialista* en #t[resolver la ambigüedad, enfocar la creatividad y
  simplificar la complejidad]. Los tres se centran en la *información*:
  identificar la información necesaria, coherente e importante reduciendo la
  ambigüedad; *agregar* información nueva a través de la creatividad; y
  *gestionar la explosión* de información hasta la arquitectura final.
  #diapo(3, 3) #diapo(3, 7)
]

#cuidado[
  El arquitecto *no es* el equipo de diseño, el controlador financiero, el
  ejecutivo de marketing ni el gerente de planta #diapo(3, 3). El holismo de
  la unidad 2 es una *herramienta de pensamiento*, no una descripción del
  puesto: el arquitecto piensa el sistema entero, pero su entregable es
  acotado y concreto — los tres roles de abajo, no la ejecución de cada
  disciplina.
]

== Los tres roles

=== 1. Reduce la ambigüedad

Antes de que el arquitecto se involucre hubo un *proceso ascendente* —
estrategia, marketing, necesidades del cliente— lleno de ambigüedad
#diapo(3, 4). El arquitecto es responsable de crear límites y concretar
objetivos: interpretar estrategias corporativas y análisis de mercado,
escuchar a los interesados, considerar la competencia de fabricación,
interpretar regulaciones, y *desarrollar objetivos* para el sistema a partir
de esas influencias #diapo(3, 4). Este rol se desarrolla en el módulo
siguiente.

=== 2. Emplea la creatividad

Una vez definidos los objetivos, hay una tarea creativa: definir el
#t[concepto] del sistema #diapo(3, 5).

#clave[
  Un buen concepto *no garantiza* el éxito del sistema, pero una mala
  elección de concepto *casi seguro lo condena al fracaso* #diapo(3, 5) — la
  misma idea que ya apareció en la unidad 2, ahora explícita como parte del
  rol. Las tareas típicas: proponer y desarrollar opciones conceptuales,
  identificar métricas y drivers clave, seleccionar un concepto a llevar
  adelante (y tal vez uno de respaldo), y *anticipar modos de falla* y sus
  planes de mitigación.
]

=== 3. Gestiona la complejidad

En el momento en que se elige el concepto hay poca información sobre el
sistema. Pero esa información *explota* rápidamente: interfaces externas,
descomposición de primer nivel, consideraciones de factores posteriores
#diapo(3, 6). El arquitecto gestiona esa inversión y evolución de
complejidad para que el sistema siga siendo *comprensible para todos*, a
través de:

- Descomposición de forma y función; asignación de funcionalidad a
  elementos de forma.
- Definición de interfaces entre subsistemas y con el contexto.
- Configuración de subsistemas y grado de modularidad.
- Equilibrio entre flexibilidad y optimalidad, entre diseño interno y
  _outsourcing_.
- Control de la evolución del producto.

#posta[
  Los tres roles en una frase: *el arquitecto entra con demasiada ambigüedad
  y muy poca información, y sale con objetivos claros, un concepto, y una
  complejidad organizada de forma que el equipo entero la entienda.*
]

== El principio del rol del arquitecto

#definicion("principios del rol del arquitecto")[
  El rol del arquitecto es *resolver la ambigüedad, enfocar la creatividad y
  simplificar la complejidad*. Busca crear sistemas elegantes que generen
  valor y ventaja competitiva definiendo objetivos, funciones y límites;
  creando el concepto que incorpora la tecnología adecuada; asignando
  funcionalidad; y definiendo interfaces, jerarquías y abstracciones para
  gestionar la complejidad. #diapo(3, 8)
]

#cuidado[
  Tres consecuencias prácticas del principio, y son las que se preguntan
  #diapo(3, 8):
  - Dada la ambigüedad y la complejidad, *suele ser deseable* que la
    arquitectura la cree *un solo individuo o un grupo pequeño* — no un
    comité amplio.
  - El arquitecto mantiene una visión holística, pero *siempre se enfoca* en
    la pequeña cantidad de problemas críticos para el diseño — el mismo par
    holismo/enfoque de la unidad 2, aplicado al rol.
  - El arquitecto *no sigue un solo método*: adopta distintos marcos, vistas
    y paradigmas según corresponda.
]

#deduccion("por qué la tensión de la ingeniería de sistemas también es del arquitecto")[
  La ingeniería de sistemas tradicional concibe un proyecto como una
  compensación a tres bandas entre desempeño, cronograma y costo: se puede
  *fijar* una, *administrar* una segunda, y hay que dejar *flotar* la tercera
  #diapo(3, 7). La complejidad, la creatividad y la ambigüedad —el material
  de trabajo del arquitecto— son más amorfas que esas tres variables, pero la
  misma metáfora de la tensión aplica: uno de los mecanismos principales por
  los que el arquitecto actúa es *reconocer, comunicar y resolver tensiones*
  en el sistema.
]

== Los entregables del arquitecto

#definicion("entregables del arquitecto")[
  El *resultado final*, no el procedimiento por el cual se logra el estado.
  Incluyen: un conjunto de objetivos claros, completos, consistentes y
  alcanzables (con 80-90% de confianza); una descripción del contexto más
  amplio del sistema (legal y estándares incluidos); un #t[concepto] para el
  sistema y su concepto de operaciones; una descripción funcional con al
  menos *dos capas de descomposición*; la descomposición de la forma a dos
  niveles de detalle, con la función asignada a ella; el detalle de las
  interfaces externas y un proceso para controlarlas; y una noción de costo,
  cronograma y riesgo. #diapo(3, 16)
]

#cuidado[
  *⚠ La distinción que la cátedra marcó en el parcialito 3, otra vez:* los
  entregables son *muy diferentes de las tareas* en que son el resultado
  final, no el procedimiento #diapo(3, 16). Enumerar tareas ("reunirse con
  el cliente", "hacer un diagrama de bloques") donde se pide un entregable es
  el error que se corrige. Y la descomposición lleva *el número*: dos capas,
  no "varias".
]

#posta[
  Casi todos los entregables de la lista salen de los tres roles: los
  objetivos y el contexto vienen de *reducir la ambigüedad*; el concepto, de
  *emplear la creatividad*; la descomposición, las interfaces y la
  complejidad organizada, de *gestionar la complejidad*. El único que no sale
  directo de un rol es la noción de costo/cronograma/riesgo — es el resumen
  del proyecto que se va a ejecutar.
]

== Resumen

#clave[
  El arquitecto no es un generalista, sino un especialista en resolver
  ambigüedad, enfocar creatividad y simplificar complejidad. La arquitectura
  se sienta *a horcajadas* entre las actividades anteriores —lo que se hace
  antes de que exista la arquitectura— y las posteriores —lo que se hace
  después, pero que hay que incluir en la arquitectura desde el principio.
  La ambigüedad surge de ambos lados. #diapo(3, 17)
]

#deduccion("por qué un edificio y un satélite comparten arquitecto")[
  El término "arquitecto" viene de la arquitectura civil, y el libro cierra
  el capítulo con un caso de estudio que vale la pena para ver el concepto
  desde otro ángulo: en el diseño de edificios, el *concepto* también es "la
  idea unificadora mediante la cual se evalúan todas las decisiones de
  diseño", y nunca está terminado de pulir. Lo que el caso agrega es una
  quinta cualidad, la *magia* — lo que hace que una arquitectura, civil o de
  sistemas, se vuelva memorable más allá de cumplir su función. No es
  examinable como término controlado, pero es el mismo argumento que sostiene
  por qué "un buen concepto no garantiza el éxito, pero uno malo casi
  garantiza el fracaso": la arquitectura es *una ciencia y un arte* en las
  dos disciplinas.
]
