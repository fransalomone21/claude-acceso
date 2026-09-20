#import "../plantilla.typ": *

#modulo(
  "La familia de requerimientos, la curva de fracasos y los documentos de interfaz",
  [Explicar por qué un requerimiento padre mal escrito degrada a sus hijos;
   leer la curva de la tasa de fracasos y distinguir sus tres períodos;
   profundizar el diagrama en V con sus hitos de verificación por nivel; y
   distinguir los tres documentos de interfaz —IDD, IRD, ICD— según qué se
   está conectando.],
  clave: "familia-de-requerimientos-e-interfaces",
)

#lectura[
  Clase 6, diapositivas 1 a 13.
]

== Por qué los requerimientos importan tanto

#cuidado[
  *Los problemas en los requerimientos son la mayor causa de los problemas
  de un proyecto.* Si el requerimiento está mal, el diseño va a estar mal —
  y los requerimientos manejan costos, diseño, planificación, habilidades
  necesarias, planes de verificación y procedimientos operacionales: casi
  todo lo demás del proyecto cuelga de ahí.
]

#posta[
  Es asombroso cuántos equipos empiezan a resolver un problema *antes* de
  ponerse de acuerdo sobre cuál es el problema. Los requerimientos, sus
  restricciones y sus hipótesis son lo que *cuantifica* el problema — y de
  paso, establecen cómo se va a medir el éxito del proyecto.
]

== La curva de la tasa de fracasos

#definicion("curva de la tasa de fracasos (curva de bañadera)")[
  El modelo que describe cómo varía la tasa de falla de un sistema a lo
  largo del tiempo, en tres períodos: *mortalidad infantil* (tasa alta que
  decrece, por fallas de fabricación o control de calidad inadecuado),
  *vida útil* (tasa constante, fallas al azar) y *desgaste* (tasa creciente,
  al final de la vida útil).
]

#clave[
  El nombre viene de la forma del gráfico: alto al principio, plano en el
  medio, alto al final — como el perfil de una bañadera. Que la tasa de
  falla sea *constante* durante la vida útil no significa que no fallen
  componentes: significa que las fallas que ocurren ahí son al azar, no
  por un defecto sistemático de fabricación ni por desgaste acumulado.
]

== El diagrama en V, a nivel macro

La unidad 5 ya definió el #t[diagrama en V] con sus tres perspectivas
(cliente, ingeniería de sistemas, contratista). La cátedra agrega acá una
versión a *nivel macro*, con los hitos de verificación explícitos en cada
nivel:

#figure(
  table(
    columns: (1.4fr, 1.6fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    [*Lado izquierdo*], [*Lado derecho*],
    [Desarrollo del Concepto], [Validación del Sistema],
    [Diseño Preliminar], [Integración y Verificación],
    [Diseño de Detalle], [Calificación / Testing],
    [Construcción], [Plan de Ensayos de subsistemas y de componentes],
  ),
  caption: [El diagrama en V a nivel macro, con sus hitos de verificación explícitos en cada nivel (diapositiva 6, con crédito a Forsberg, Blanchard y Fabrycky).],
)

#deduccion("el mismo vértice, con más nombres")[
  No es un diagrama distinto del de la unidad 5: es el *mismo* vértice
  (concepto → detalle → implementación → verificación → validación), pero
  con los planes de ensayo nombrados en cada nivel: un *Test and Evaluation
  Master Plan* para el sistema completo, y planes de ensayo específicos
  para subsistemas y componentes. Cada plan se prepara del lado izquierdo,
  antes de llegar al vértice — la misma idea clave de la unidad 5.
]

== La familia de requerimientos

#definicion("familia de requerimientos (padres, hijos, huérfanos)")[
  La relación jerárquica entre requerimientos: un requerimiento *padre* da
  origen a requerimientos *hijos* en el nivel de abajo. Si el padre es
  incompleto, incorrecto, ambiguo, conflictivo o inverificable, los hijos y
  las generaciones siguientes serán *progresivamente peores*. Un
  requerimiento sin padre es un *huérfano*, y debe evaluarse si corresponde
  incluirlo.
]

#cuidado[
  Esto no es una advertencia abstracta: es la razón por la que un
  requerimiento de sistema mal escrito no se queda contenido en el nivel de
  sistema. Baja por la #t[jerarquía del sistema] completa —segmento,
  elemento, subsistema, componente— multiplicando el error en cada paso de
  la #t[trazabilidad].
]

== Interfaces: siempre que se descompone, aparecen

#clave[
  Al descomponer un sistema, *inexorablemente* se crean requerimientos de
  interfaz — entre cada subsistema, y entre cada subsistema y el sistema
  completo. La propiedad de una interfaz —quién es responsable de ella—
  *debe* establecerse explícitamente: no siempre es obvio.
]

#definicion("documentos de interfaz (IDD, IRD, ICD)")[
  Tres documentos distintos según qué se conecta. *IDD* (Interface
  Definition Document): define las interfaces de un sistema *ya
  existente* —por ejemplo, un lanzador ya elegido—; es propiedad de ese
  otro sistema y probablemente no se puede alterar. *IRD* (Interface
  Requirement Document): define interfaces entre *dos sistemas en
  desarrollo simultáneo*; necesita un dueño conjunto, oficializado por
  ambos directores. *ICD* (Interface Control Document): identifica la
  *solución física* de la interfaz — los planos.
]

#posta[
  El orden importa: primero se sabe *si* el otro sistema ya existe (IDD,
  sin margen de negociación) o se está construyendo en paralelo (IRD, con
  un dueño conjunto por definir). Recién después, cuando la solución física
  está decidida, se documenta con un ICD.
]

== Herramientas automatizadas

La cátedra menciona herramientas de gestión de requerimientos con modelos
ejecutables —CORE, DOORS, CRADLE, SLATE, Popkin, Valispace, entre otras— y
remite al *INCOSE Tool Survey* (incose.org), que lista quince herramientas
de gestión de requerimientos y diez de arquitectura de sistemas.

== Resumen de la sección

#clave[
  Los requerimientos definen el problema a resolver y establecen los
  términos con los que se va a medir el éxito. Se distribuyen por la
  arquitectura vía el flujo descendente —alojándolos y derivándolos—, y la
  #t[trazabilidad] permite evaluar rápido las consecuencias de un cambio.
  Cuando el sistema se descompone, las interfaces se crean solas y hay que
  definirlas y controlarlas — nunca asumir que van a quedar claras por su
  cuenta.
]
