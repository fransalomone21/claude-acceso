#import "../plantilla.typ": *

#modulo(
  "Estimar tiempo, costo y recursos",
  [Explicar para qué se estima en un proyecto; distinguir la estimación de
   arriba hacia abajo de la de abajo hacia arriba y saber en qué orden se
   usan; ubicar cuándo, en el ciclo de vida, alcanza una macro estimación y
   cuándo hace falta la detallada; leer el rango de error de cada orden de
   estimación (ROM ±35 %, ±15 %, ±10 %); y clasificar un costo como
   directo, directo general o general y administrativo.],
  clave: "estimaciones",
)

#lectura[
  Clase 8, diapositivas 17 a 19 y 27 a 33.
]

== Qué es estimar, y para qué

#definicion("estimación (de arriba hacia abajo y de abajo hacia arriba)")[
  El proceso de *pronosticar o aproximar los tiempos y costos de los
  entregables* de un proyecto. Permite balancear las expectativas de los
  interesados con las necesidades de control mientras el proyecto se
  ejecuta #diapo(8, 17).
]

Por qué importa #diapo(8, 18): para tomar y sostener buenas decisiones,
para planificar el trabajo, para saber cuánto debería costar y cuánto
tardar, *para decidir si el proyecto vale la pena*, para saber cuánta
plata hace falta y cuándo (el flujo de caja), para medir si el proyecto
avanza bien, y para armar el presupuesto por fases y fijar el
#t[baseline] del proyecto.

#posta[
  Leé la lista otra vez: la cuarta razón es «si vale la pena». Una
  estimación no es un trámite que se hace después de decidir; es una de
  las cosas con las que se decide. El que estima mal no se equivoca en un
  número: se equivoca en si había que hacer el proyecto.
]

== Los dos sentidos: macro y micro

- *De arriba hacia abajo* (_top-down_, macro): la hace alguien con
  experiencia o con información estadística —un gerente que conoce los
  procesos— por *analogía* con proyectos parecidos, por *consenso* del
  grupo o por *relaciones matemáticas* #diapo(8, 17) #diapo(8, 27).
- *De abajo hacia arriba* (_bottom-up_, micro): se estima cada elemento de
  la #t[WBS] —cada paquete de trabajo— y se suma. Sirve, además, *como
  comprobación* de la macro.

#clave[
  Los dos no compiten: van en secuencia, y la diferencia entre ellos es
  información #diapo(8, 28). Los pasos de la cátedra:
  + hacer una estimación gruesa de arriba hacia abajo;
  + desarrollar la WBS (y la OBS, la estructura de la organización que la
    va a ejecutar);
  + hacer la estimación de abajo hacia arriba;
  + desarrollar la planificación y el presupuesto;
  + *reconciliar la diferencia* entre las dos estimaciones.
]

#deduccion("por qué hace falta reconciliar, y no quedarse con la más precisa")[
  La de abajo hacia arriba parece la buena, porque suma cosas concretas.
  Pero suma *sólo lo que está en la WBS*: si una tarea no se pensó, no
  cuesta nada. La de arriba hacia abajo viene de proyectos enteros que ya
  pasaron, con sus sorpresas incluidas. Si la suma de los paquetes da
  mucho menos que la analogía, lo más probable no es que este proyecto sea
  más barato: es que a la WBS le falta trabajo. La diferencia apunta
  exactamente al hueco.
]

== Directrices para estimar tiempos

La diapositiva 19 da siete:

+ que estime gente familiarizada con esas tareas;
+ usar *varias personas independientes* y sacar la varianza, que es una
  evaluación del riesgo;
+ estimar en condiciones normales, con métodos eficientes y un nivel
  normal de recursos;
+ usar unidades de tiempo consistentes en todas las tareas;
+ tratar cada tarea como independiente;
+ *no hacer concesiones a las contingencias* en cada tarea;
+ agregar aparte una evaluación de riesgo que estime el efecto de las
  contingencias, para no sorprender a los interesados.

#cuidado[
  Las directrices 6 y 7 parecen contradecirse y no: las contingencias *no
  se esconden adentro de cada tarea* (cada uno inflaría la suya «por las
  dudas», y nadie sabría cuánto colchón hay en total), sino que se suman
  *aparte*, a la vista, como una reserva. Es la misma lógica de la
  gestión de márgenes del módulo #M("que-es-un-requerimiento-y-margenes"):
  el margen se declara y se administra, no se reparte en secreto.
]

== Estimar según la fase

La estimación cambia de grano a lo largo del ciclo de vida #diapo(8, 29):
en cada fase se hace una *estimación detallada* de la fase que se está por
ejecutar y *macro estimaciones* de las que vienen después. En la Pre-Fase
A todo el resto del proyecto es macro; a medida que se avanza, la franja
detallada va corriéndose hacia adelante.

Y el error que se tolera se achica en tres órdenes #diapo(8, 32):

#figure(
  table(
    columns: (1.5fr, 1.6fr, 0.8fr),
    align: (left, left, center),
    stroke: 0.4pt + luma(180),
    [*Momento*], [*Tipo de estimación*], [*Rango*],
    [Antes de lanzar el proyecto (carta de intención)], [Gruesa, macro: el #t[ROM] (_Rough Order of Magnitude_)], [±35 %],
    [Plan aprobado, se lanza el proyecto], [Basada en tareas (micro)], [±15 %],
    [Ejecutando], [Planificación del proyecto], [±10 %],
  ),
  caption: [Los órdenes de estimación (diapositiva 32).],
)

#posta[
  Un ±35 % no es una estimación mala: es una estimación honesta de
  Pre-Fase A. El problema es presentarla como si fuera de ±10 %. Para el
  MCR del trabajo práctico, el costo y el calendario son, como mucho, un
  ROM: decilo así, con su rango, y vas a sonar más profesional que con un
  número con centavos.
]

Las estimaciones se ajustan durante el proyecto #diapo(8, 31) porque *los
costos de interacción están escondidos* (la suma de las partes no cuenta
lo que cuesta que las partes se hablen), porque las condiciones normales
no siempre se cumplen, porque las cosas salen mal, y porque cambian el
alcance y los planes. A medida que los riesgos, los recursos y las
situaciones particulares se conocen mejor, se refinan.

== Tipos de costos y de recursos

#definicion("tipos de costos (directos, directos generales, generales y administrativos)")[
  *Directos:* claramente cargables a un paquete de trabajo específico
  (trabajo, materiales, equipamiento). *Directos generales del proyecto:*
  identificables con un entregable o paquete del proyecto (salarios,
  rentas, suministros, maquinaria especial). *Generales y
  administrativos:* costos de la organización relacionados sólo
  *indirectamente* con el paquete asignado al proyecto #diapo(8, 30).
]

#ejemplo("dónde cae cada costo en un satélite universitario")[
  Las celdas solares que se compran para el modelo de vuelo son un costo
  *directo* del paquete «panel solar». El alquiler del laboratorio donde
  trabaja todo el equipo del proyecto es *directo general*: se identifica
  con el proyecto, no con un paquete. La parte del sueldo de la
  administración de la facultad que procesa las compras es *general y
  administrativa*: existe con o sin satélite, y al proyecto le toca una
  porción. (Ejemplo del apunte, no de la lámina.)
]

Los recursos que se estiman son de cuatro categorías: *dinero,
materiales, máquinas y gente* #diapo(8, 33). Y las preguntas que la
cátedra manda hacer: ¿quién y qué se necesita?, ¿quién y qué puede hacer
el trabajo?, ¿quién y qué está disponible?, ¿qué nivel y competencias se
requieren?
