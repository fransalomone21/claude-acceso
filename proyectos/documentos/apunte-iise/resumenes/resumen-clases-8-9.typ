// =====================================================================
//  Resumen para el parcialito del 14/10 -- IISE
//  La clase 8 hasta el LDCM (plan de trabajo, WBS, red y camino critico,
//  Gantt, estimaciones y costos, baselines, LDCM) y la Fase B de la clase 9.
//  Sale de los modulos del apunte (el-plan-de-trabajo, estimaciones,
//  ciclo-de-vida-y-diagrama-en-v, el-ldcm, fase-b-a-fondo, trl-irl-srl) y de
//  las laminas (fuentes/clases/clase-8.txt y -9, figuras c08-p014 y p034).
//  Los numeros de los ejemplos se verificaron contra la lamina el 14/10.
// =====================================================================
#import "estilo.typ": *

#show: documento.with(
  titulo: [Resumen — plan de trabajo, LDCM y Fase B],
  subtitulo: [Para el parcialito del 14/10: la clase 8 hasta el Landsat y la Fase B de la clase 9],
  encabezado: [Resumen — clases 8 y 9],
)

#caja([Cómo usar esto], c-azul)[
  Los cinco parcialitos anteriores fueron todos iguales: cinco o seis
  preguntas de *definición* —qué es X, cuáles son sus tipos, qué entrega, qué
  revisa— y ni una cuenta. Por eso cada tema trae primero *la definición con
  la palabra de la cátedra* (es lo que se escribe), después la idea en
  criollo, *el ejemplo de la clase contado de nuevo* y la trampa. Al final,
  *lo que puede caer*, con la respuesta en dos líneas, y las siglas.

  La palabra exacta pesa: la cátedra dice *requerimiento* y no «requisito»,
  *interesado* y no «stakeholder». El desarrollo completo, con la diapositiva
  de cada cosa, está en el apunte general, unidades 8 y 9.
]

= 1. El plan de trabajo: cuatro piezas, en orden
#origen[Clase 8, diapositivas 4 a 6 · apunte, módulo «El plan de trabajo»]

La clase 8 cambia de pregunta. Hasta acá la materia se ocupó de *qué* hay que
construir —necesidades, requerimientos, arquitectura—; ahora, de *cómo se
organiza el trabajo de construirlo*. El plan de trabajo tiene cuatro piezas, y
van en este orden porque cada una usa la anterior:

+ la *WBS*, el desglose del trabajo: *qué* hay que hacer;
+ el *diagrama de red*: en qué orden, y qué depende de qué;
+ el *camino crítico*: cuánto dura el proyecto y qué tareas no se pueden
  atrasar (sale de recorrer la red hacia adelante y hacia atrás, _forward
  and backward pass_);
+ el *diagrama de Gantt*: todo lo anterior puesto sobre el calendario.

Arriba de todo sigue el triángulo de hierro de la clase 1 —desempeño, costo
y planificación—, con la letra chica que agrega la diapositiva 5: *es de
hierro sólo si los tres lados están restringidos*. En el medio está el jefe de
proyecto, la autoridad máxima, que balancea los tres «dirigiendo y
controlando el riesgo» (diap. 6). El plan de trabajo es la herramienta para
que ese malabarista deje de hacerlo a ojo.

#posta[
  No hay Gantt honesto sin red, ni red sin saber cuáles son las tareas. Si te
  preguntan el orden de las piezas, es ése, y la razón es ésa.
]

= 2. La WBS: todo el trabajo, en un árbol
#origen[Clase 8, diapositivas 7-8, 20 a 26 y 34 a 37 · apunte, módulo «El plan de trabajo»]

#definicion[WBS, estructura de desglose de trabajo (NASA, diap. 22)][
  La subdivisión jerárquica, en forma de árbol, de *todo el trabajo* necesario
  para alcanzar el objetivo final: se empieza por el objetivo y se lo parte,
  nivel por nivel, en componentes manejables en tamaño y complejidad. Cada
  unidad lleva un *código* que dice dónde está en el árbol (1.0, 1.2, 1.2.1), y
  el nivel más bajo son los *paquetes de trabajo* (_Work Breakdown
  Structure_).
]

La imagen de la cátedra es un rompecabezas (diap. 7): el trabajo total es la
caja armada, el nivel 2 son las tareas y el nivel 3 las subtareas. Lo que la
imagen enseña y la definición no dice: *las piezas cubren todo el cuadro y no
se superponen*. Una tarea que no está en ningún casillero no la hace nadie;
una que está en dos la pagan dos veces.

== Cómo se arma

- *De abajo hacia arriba* (_bottom-up_): una lluvia de ideas con todas las
  actividades que se te ocurran, que después se agrupan en categorías. Es el
  método más apropiado cuando el proyecto usa métodos nuevos, no ensayados, o
  cuando el equipo *nunca hizo algo parecido* (diap. 8). Léase: un grupo de
  alumnos con su primer satélite.
- *De arriba hacia abajo* (_top-down_): desde el objetivo final,
  subdividiendo sucesivamente. Es la definición de NASA.

Los pasos para definir las tareas (diap. 21): *(1)* fijar el alcance y las
prioridades del proyecto; *(2)* decidir si las tareas se organizan *por
entregables*, *por procesos* (fases) o por una combinación; *(3)* crear la WBS,
con los niveles altos como las tareas generales y el más bajo como los
paquetes de trabajo. Casi todo proyecto aeroespacial *combina* las dos
organizaciones (diap. 20): el satélite es un entregable que se parte en piezas
que se hacen en paralelo, y a la vez el resultado de cada fase cambia las
tareas de la siguiente.

#definicion[paquete de trabajo (diap. 25)][
  La unidad del nivel más bajo de la WBS. Lleva la *descripción del trabajo*
  —con su tiempo planificado y sus entradas y salidas—, los *recursos y el
  costo* que necesita, y *la persona responsable* de completarlo. Sumando los
  paquetes hacia arriba sale el costo y el tiempo de cada unidad.
]

Las reglas de la estructura (diap. 24 a 26): es jerárquica (lo general arriba,
lo específico abajo); cada nivel se particiona en el siguiente; *es poco
probable bajar más del cuarto nivel* (muchas veces el 3 alcanza y el 4 ya son
los paquetes); cada unidad lleva su código. Y *cada subunidad es un
entregable* de alguna clase: un producto concreto (el sistema de potencia, un
módulo de _software_) o *lo que hace falta para salir de la fase actual*
(requerimientos de sistema, el ICD, resultados de ensayos).

*Para qué sirve* (diap. 23): identificar tareas, subtareas y unidades de
trabajo y sus relaciones; *aumentar la probabilidad de que cada requerimiento
sea tenido en cuenta*; organizar áreas de responsabilidad y autoridad; estimar
costos y planificación; seguir el costo de cada elemento; y monitorear el
avance.

#ejemplo[la WBS con estimaciones (diap. 34)][
  La lámina es la WBS de un curso universitario de globos estratosféricos
  (LaACES, de Luisiana), con un _CubeSat_ entre las cargas. Arriba hay ramas
  de nivel 1 —potencia, unidad de control de vuelo, archivo de datos,
  transmisor auxiliar, estructura, control térmico, integración y ensayo,
  gestión—. Bajemos por una sola:

  #tabla((auto, 1fr, auto, auto),
    [*Código*], [*Elemento*], [*Días*], [*Dólares*],
    [1.0], [Sistema de potencia], [155], [7560],
    [1.5], [#h(8pt) Alimentación del _CubeSat_], [45], [2450],
    [1.5.2], [#h(16pt) Interfaz de control con la unidad de vuelo], [14], [970],
    [1.5.2.1], [#h(24pt) Establecer requerimientos], [0,5], [20],
    [1.5.2.2], [#h(24pt) Diseñar la interfaz de control], [1,5], [50],
    [1.5.2.3], [#h(24pt) Prototipar y ensayar el diseño], [5], [300],
    [1.5.2.4], [#h(24pt) Completar el diseño], [2], [100],
    [1.5.2.5], [#h(24pt) Implementar y ensayar], [5], [500],
    [], [*Total del proyecto*], [*710*], [*27~010*],
  )

  Tres cosas para mirar. *Uno:* los números suben sumando. 0,5 + 1,5 + 5 + 2 +
  5 = 14 días y 20 + 50 + 300 + 100 + 500 = 970 dólares, exactamente lo que
  dice la 1.5.2; y así, rama por rama, hasta el total. *Dos:* los cinco
  paquetes de abajo —requerimientos, diseño, prototipo y ensayo, diseño final,
  implementación y ensayo— son el diagrama en V achicado al tamaño de una sola
  interfaz. La WBS no inventa un proceso: reparte el que ya conocés en cajitas
  con dueño, fecha y precio. *Tres:* la rama 8.0, integración y ensayo del
  sistema, cuesta 6000 dólares —la más cara después de potencia— y no es
  ninguna pieza: es *trabajo*. Ahí está la diferencia con la PBS, que viene
  enseguida.
]

#trampa[
  Los costos se suman siempre; *los días, no*. La suma da la duración del
  proyecto sólo si todo se hace en fila, una tarea detrás de la otra. Si la
  estructura y el control térmico se hacen en paralelo, el proyecto dura menos
  que la suma, y cuánto menos lo dice la *red de actividades*, no la WBS. La
  lámina no aclara si sus 710 días son de trabajo o de calendario; la duración
  del proyecto es la de su *camino crítico* (sección 3). Y si buscás el 5.0 en
  la lámina, no lo vas a encontrar: la numeración salta del 4.0 al 6.0. Hasta
  la WBS de ejemplo perdió una pieza del rompecabezas.
]

== WBS no es PBS

#definicion[PBS, estructura de desglose de producto (diap. 35)][
  El árbol de los *componentes* con los que se forma el sistema. Refleja el
  trabajo de *producir* cada componente; la WBS, además, el trabajo de
  *integrarlos* en un sistema.
]

#posta[
  La PBS contesta *¿de qué está hecho?*; la WBS, *¿qué hay que hacer?* La WBS
  contiene a la PBS y le agrega las ramas que no son piezas: gestión del
  proyecto, ingeniería de sistemas, integración y ensayo, soporte logístico.
  Si tu WBS se puede atornillar, es una PBS con otro nombre.
]

== La WBS estándar de NASA

NASA fija el *nivel 2* de la WBS de todo proyecto de vuelo espacial, con once
elementos y su código (diap. 36); el JPL la baja al nivel 3 (diap. 37):

#tabla((auto, 1fr, auto, 1fr),
  [01], [Gestión del proyecto], [07], [Operaciones de la misión],
  [02], [Ingeniería de sistemas], [08], [Vehículo lanzador y servicios],
  [03], [Seguridad y aseguramiento de la misión], [09], [Sistemas de tierra],
  [04], [Ciencia y tecnología], [10], [Integración y ensayo de sistemas],
  [05], [Carga útil], [11], [Educación y difusión],
  [06], [_Spacecraft_], [], [],
)

Fijate que gestión, ingeniería de sistemas, aseguramiento y difusión están en
el *mismo nivel* que el satélite: para NASA, ese trabajo pesa tanto como el
_hardware_. Para el TP final, esta lámina es media WBS regalada.

= 3. La red de actividades y el camino crítico
#origen[Clase 8, diapositivas 9 a 14 · apunte, módulo «El plan de trabajo»]

#definicion[diagrama de red (diap. 9)][
  Un diagrama de flujo que muestra *el orden* en que se hacen las tareas y *las
  dependencias* entre ellas. Tiene tres elementos: *eventos* o hitos
  (_milestones_: «comienzo del diseño», «borrador del informe aprobado»),
  *actividades* (el trabajo necesario para pasar de un evento al siguiente) y
  *duración* (el tiempo calendario real que lleva cada actividad).
]

La regla que hace andar todo (diap. 10): *todas las entradas de una actividad
tienen que estar completas antes de que empiece*. Con eso solo ya se puede
calcular cuánto dura el proyecto.

#definicion[camino crítico y holgura][
  El *camino crítico* es la secuencia de actividades, de punta a punta, que
  determina la duración total del proyecto: el camino *más largo* de la red.
  Una actividad fuera de él tiene *holgura* (_slack_): puede atrasarse ese
  tanto sin atrasar el proyecto. Las del camino crítico tienen holgura cero:
  cualquier atraso ahí es atraso del proyecto.
]

*Cómo se encuentra, con la red de la diapositiva 10.* Cinco actividades: la 1
(5) y la 3 (1) arrancan al comienzo; la 2 (1) espera a la 1; la 4 (3) espera a
la 3; la 5 (2) espera a la 1 *y* a la 4. Hay tres caminos:

#tabla((auto, auto, auto),
  [*Camino*], [*Duración*], [],
  [Comienzo → 1 → 2 → Fin], [5 + 1 = 6], [holgura 1],
  [Comienzo → 1 → 5 → Fin], [5 + 2 = *7*], [*crítico*],
  [Comienzo → 3 → 4 → 5 → Fin], [1 + 3 + 2 = 6], [holgura 1],
)

El proyecto dura *7*, y la 2, la 3 y la 4 se pueden atrasar una unidad cada
una sin que nadie se entere. Eso mismo es lo que hace el método de la lámina:
*hacia adelante*, cada actividad empieza apenas termina la *última* de sus
entradas (da la duración total); *hacia atrás*, desde el final, cada una
termina lo más tarde posible sin correr ese total. Lo tarde menos lo temprano
es la holgura.

#ejemplo[«Haciendo el té» (diap. 11 a 14)][
  Hay que servir té con leche en bandeja: trece actividades. Primero se llena
  la pava (10 s) y se la enciende (3 s); a partir de ahí la red se abre en dos
  ramas que se juntan recién al servir:

  #v(2pt)
  #set par(justify: false)
  *Rama de la pava:* #nodo[calentar el agua][180] #fl #nodo[calentar la tetera][10] #fl #nodo[recalentar][10] ∥ #nodo[saquitos][5] #fl #nodo[verter el agua][15] #fl #nodo[tetera a la bandeja][5] #fl #nodo[servir][20]

  *Rama de la bandeja:* #nodo(color: c-verde)[leche en la jarra][15] #fl #nodo(color: c-verde)[azúcar en el tazón][15] #fl #nodo(color: c-verde)[buscar la bandeja][10] #fl #nodo(color: c-verde)[todo a la bandeja][10] #fl #nodo(color: c-verde)[servir][20]
  #v(2pt)

  (∥ = en paralelo: de los dos, cuenta el más largo.) Sumando cada rama
  desde el principio, con los 13 s de la pava:

  #tabla((1.5fr, 1fr, 1fr),
    [*Camino*], [*Pava de siempre*], [*Pava «nueva tecnología»*],
    [Pava: 10 + 3 + agua + tetera + recalentar o saquitos + 15 + 5 + 20], [10 + 3 + 180 + 10 + 10 + 15 + 5 + 20 = *253 s* ← crítico], [10 + 3 + 10 + 10 + 5 + 15 + 5 + 20 = 78 s],
    [Bandeja: 10 + 3 + 15 + 15 + 10 + 10 + 20], [83 s (holgura: 170 s)], [*83 s* ← crítico],
  )

  *Con la pava de siempre*, el agua tarda tres minutos y manda: mientras
  hierve, te sobra tiempo para la leche, el azúcar, buscar la bandeja y
  ordenar la alacena. La rama de la bandeja tiene 170 segundos de holgura, y
  el té sale en *253 s*, que es el camino crítico (diap. 13).

  *Llega la «nueva tecnología»* (diap. 14): una pava que hierve en 10
  segundos —de esas que ni la NASA tiene— y un recalentado de 1 segundo. Si el
  camino crítico fuera fijo, el té saldría en 78 s. Sale en *83*: el agua dejó
  de mandar, y ahora el cuello de botella es el que busca la bandeja. *El
  camino crítico se mudó de rama.* Y un detalle fino de la misma lámina: en la
  bifurcación de la tetera, antes ganaba el recalentado (10 contra 5 de los
  saquitos); con la pava nueva gana el saquito (5 contra 1). El camino crítico
  se recalcula en todos los niveles, no sólo en el grande.
]

#posta[
  Mejoraste dieciocho veces una tarea (de 180 a 10~s) y el té salió apenas
  tres veces más rápido (de 253 a 83~s). *Acelerar una tarea del camino
  crítico achica el proyecto sólo hasta que otro camino pasa a ser el más
  largo.* Por eso, después de cada cambio, el camino crítico se vuelve a
  calcular: el cuello de botella de ayer no es el de mañana.
]

= 4. El diagrama de Gantt
#origen[Clase 8, diapositivas 15-16 (y la corrección de la 91) · apunte, módulo «El plan de trabajo»]

#definicion[diagrama de Gantt (diap. 15)][
  Herramienta, originada por *Henry Gantt*, para planificar y programar tareas
  a lo largo de un período determinado: reproduce gráficamente las tareas, su
  *duración* y su *secuencia* sobre el calendario general del proyecto, y
  permite el *seguimiento y control* del progreso de cada etapa.
]

La red dice *qué depende de qué*; el Gantt dice *qué pasa cada día*. En el
Gantt del té (diap. 16) la holgura se ve como lo que es: una franja rotulada
_SLACK_ en la que la rama de la bandeja puede correrse sin que nadie note el
atraso. Lo que el Gantt *no* muestra bien son las dependencias, y por eso se
arma *después* de la red, no en su lugar: un Gantt dibujado directo sobre el
calendario tiene barras prolijas y un camino crítico que nadie calculó.

#trampa[
  Más adelante en la misma clase, la cátedra muestra el Gantt real de un
  proyecto de ROV y le escribe abajo, en azul: *«No están aclaradas las
  Fases»* (diap. 91). Es una corrección por escrito, y vale para cualquier
  Gantt que hagas para la materia —el del TP final incluido—: las barras se
  agrupan por *fase* del ciclo de vida, con los hitos de cada revisión
  marcados, no como una lista plana de tareas.
]

= 5. Estimar: tiempo, costo y recursos
#origen[Clase 8, diapositivas 17 a 19 y 27 a 33 · apunte, módulo «Estimar tiempo, costo y recursos»]

#definicion[estimación (diap. 17)][
  El proceso de *pronosticar o aproximar los tiempos y costos de los
  entregables* de un proyecto. Permite balancear las expectativas de los
  interesados con las necesidades de control mientras el proyecto se ejecuta.
]

*Por qué importa* (diap. 18): para tomar y sostener buenas decisiones; para
planificar el trabajo; para saber cuánto debería costar y cuánto tardar; *para
decidir si el proyecto vale la pena*; para saber cuánta plata hace falta y
cuándo (el flujo de caja); para medir si el proyecto avanza bien; y para armar
el presupuesto por fases y fijar el _baseline_. Leé la cuarta otra vez: una
estimación no se hace *después* de decidir, es una de las cosas *con las que*
se decide. El que estima mal no se equivoca en un número: se equivoca en si
había que hacer el proyecto.

== Los dos sentidos, y en qué orden

#tabla((auto, 1fr, 1fr),
  [], [*De arriba hacia abajo* (macro, _top-down_)], [*De abajo hacia arriba* (micro, _bottom-up_)],
  [Cómo], [alguien con experiencia o con información estadística, por *analogía* con proyectos parecidos, por *consenso* del grupo o por *relaciones matemáticas*], [se estima cada elemento de la WBS —cada paquete de trabajo— y se suma],
  [Cuándo], [primero, con poca información], [cuando ya hay WBS],
  [Para qué], [la decisión gruesa], [además, *comprobar* la macro],
)

Los pasos de la cátedra (diap. 28): *(1)* estimación gruesa de arriba hacia
abajo; *(2)* desarrollar la WBS (y la OBS, la estructura de la organización
que la va a ejecutar); *(3)* estimación de abajo hacia arriba; *(4)*
planificación y presupuesto; *(5)* *reconciliar la diferencia* entre las dos.

#caja([Un ejemplo para entender el paso 5 (de este resumen, no de la lámina)], c-verde)[
  Por analogía con otros _CubeSat_ universitarios, la estimación macro de tu
  proyecto da unos 40~000 dólares. La suma de los paquetes de tu WBS da
  27~000. ¿Tu proyecto es un tercio más barato que todos los anteriores? Casi
  seguro que no: *a tu WBS le falta trabajo* —el ensayo de vibración que
  alguien tiene que pagar, los viajes, la documentación de las revisiones—. La
  suma de abajo hacia arriba sólo cuenta lo que se pensó; la analogía trae las
  sorpresas de proyectos enteros que ya pasaron. La diferencia entre las dos
  no se tira: *apunta exactamente al hueco*.
]

== Las directrices para estimar tiempos (diap. 19)

+ Que estime gente familiarizada con esas tareas.
+ Usar *varias personas independientes*, y sacar la varianza: es una
  evaluación del riesgo.
+ Estimar en condiciones normales, con métodos eficientes y un nivel normal de
  recursos.
+ Usar unidades de tiempo consistentes en todas las tareas.
+ Tratar cada tarea como independiente.
+ *No hacer concesiones a las contingencias* en cada tarea.
+ Agregar *aparte* una evaluación de riesgo que estime el efecto de las
  contingencias, para no sorprender a los interesados.

#trampa[
  La 6 y la 7 parecen contradecirse y no. Las contingencias *no se esconden
  adentro de cada tarea* —cada uno inflaría la suya «por las dudas» y nadie
  sabría cuánto colchón hay en total—: se suman *aparte, a la vista*, como una
  reserva. Es la gestión de márgenes de la clase 5: el margen se declara y se
  administra, no se reparte en secreto.
]

== Estimar según la fase, y cuánto error se tolera

En cada fase se hace una *estimación detallada* de la fase que se está por
ejecutar y *macro estimaciones* de las que vienen después (diap. 29). En la
Pre-Fase A todo el resto del proyecto es macro; a medida que se avanza, la
franja detallada se corre hacia adelante. Y el error tolerado se achica en
tres órdenes (diap. 32):

#tabla((1.4fr, 1.4fr, auto),
  [*Momento*], [*Tipo de estimación*], [*Rango*],
  [Antes de lanzar el proyecto (carta de intención)], [gruesa, macro: el *ROM* (_Rough Order of Magnitude_)], [*±35 %*],
  [Plan aprobado, se lanza el proyecto], [basada en tareas (micro)], [*±15 %*],
  [Ejecutando], [planificación del proyecto], [*±10 %*],
)

#posta[
  Un ±35 % no es una estimación mala: es la Pre-Fase A siendo honesta. Lo malo
  es presentarla con centavos. Para el MCR del TP, el costo y el calendario
  son, como mucho, un ROM: decilo así, con su rango.
]

Las estimaciones se *ajustan* durante el proyecto (diap. 31) porque los
*costos de interacción están escondidos* (la suma de las partes no cuenta lo
que cuesta que las partes se hablen), porque las condiciones normales no
siempre se cumplen, porque las cosas salen mal, y porque cambian el alcance y
los planes.

== Tipos de costos y de recursos

#definicion[tipos de costos (diap. 30)][
  *Directos:* claramente cargables a un paquete de trabajo específico
  (trabajo, materiales, equipamiento). *Directos generales del proyecto:*
  identificables con un entregable o paquete del proyecto (salarios, rentas,
  suministros, maquinaria especial). *Generales y administrativos:* costos de
  la organización relacionados sólo *indirectamente* con el paquete asignado
  al proyecto.
]

En un satélite universitario (ejemplo del apunte, no de la lámina): las celdas
solares que se compran para el modelo de vuelo son un costo *directo* del
paquete «panel solar»; el alquiler del laboratorio donde trabaja todo el
equipo es *directo general* (se identifica con el proyecto, no con un
paquete); y la parte del sueldo de la administración de la facultad que
procesa las compras es *general y administrativo*: existe con o sin satélite,
y al proyecto le toca una porción.

Los *recursos* que se estiman son de cuatro categorías: *dinero, materiales,
máquinas y gente* (diap. 33). Y las preguntas que manda hacer la cátedra:
¿quién y qué se necesita?, ¿quién y qué puede hacer el trabajo?, ¿quién y qué
está disponible?, ¿qué nivel y competencias se requieren?

= 6. Repaso de la clase 8: qué congela cada revisión
#origen[Clase 8, diapositivas 41-42 · apunte, módulo «Ciclo de vida y diagrama en V», sección «Qué congela cada revisión»]

Antes del LDCM, la clase repasa el ciclo de vida con dos láminas. La primera
pone, debajo de cada revisión, *el _baseline_ que deja congelado* (diap. 41);
la segunda, los *artefactos* que produce cada fase (diap. 42):

#grid(columns: (1fr, 1.25fr), gutter: 10pt,
  tabla((1.3fr, 1fr),
    [*Revisión*], [*Baseline*],
    [SRR], [de Requerimientos de Sistema],
    [SDR], [de Diseño del Sistema],
    [PDR], [*Alojado*],
    [CDR], [de Desarrollo],
    [ensayos de aceptación], [de Producto],
    [posterior al lanzamiento], [Operacional],
  ),
  tabla((auto, 1fr),
    [*Fase*], [*Artefactos*],
    [Pre-A], [problemas, conceptos, expectativas],
    [A], [ConOps, requerimientos de sistema, *plan de validación*],
    [B], [diseño preliminar, requerimientos de subsistemas, *plan de verificación*],
    [C], [especificaciones de diseño, construir según ellas, procedimientos de verificación],
    [D], [construir, verificado],
    [E], [desplegado, operado, anomalías],
  ),
)

El plan de *validación* aparece antes (A) que el de *verificación* (B), y
tiene lógica: validar es comparar contra lo que necesita el interesado, y eso
ya se sabe con el ConOps; verificar es comparar contra cada requerimiento, y
los de subsistema recién existen en la Fase B. No se puede planificar cómo se
verifica algo que todavía no está escrito.

#trampa[
  Los nombres de los _baselines_ no coinciden del todo entre clases (la clase 7
  dice que la MDR deja el baseline *Funcional*; acá la SDR deja el «de Diseño
  del Sistema»). La secuencia es la misma; si te preguntan, nombrá la revisión
  y lo que congela *con la palabra de la lámina por la que preguntan*. Y el
  dato que más rinde: *la PDR establece el baseline Alojado*.
]

= 7. El LDCM: una misión real de punta a punta
#origen[Clase 8, diapositivas 43 a 64 · apunte, módulo «Una misión real de punta a punta: el LDCM»]

El _Landsat Data Continuity Mission_ (LDCM, de NASA y el Servicio Geológico de
los Estados Unidos, USGS) es exactamente lo que pide el TP final, ya hecho:
una misión de observación de la Tierra en órbita baja. La cátedra la recorre
de la meta a la cofia, y conviene leerla como si fuera el informe de otro
grupo: qué pusieron en cada sección, con qué detalle y en qué orden.

#align(center)[#text(size: 9.5pt)[meta #fl objetivos #fl requerimientos de alto nivel #fl conceptos (Fase A) #fl plataforma + carga útil #fl ConOps #fl jerarquía de requerimientos #fl el satélite]]

== De la meta a los objetivos

*La meta* (diap. 44): continuar la adquisición, el archivo y la distribución de
imágenes multiespectrales globales de la superficie terrestre, con cobertura
sinóptica y repetitiva, a una escala en la que se puedan detectar,
diferenciar, caracterizar y monitorear los cambios naturales y los inducidos
por el hombre. De ahí salen *tres objetivos*:

+ colectar y archivar imágenes multiespectrales de *resolución moderada*
  (unos 30 m en tierra), cubriendo cada temporada toda la masa terrestre,
  durante *no menos de 5 años*;
+ que los datos sean *consistentes con los de los Landsat anteriores*
  (geometría, calibración, cobertura, espectro, calidad), para estudiar
  cambios de uso de la tierra a lo largo de *varias décadas*;
+ distribuir los productos al público general, sin discriminación y a un
  precio no mayor que el costo de atender al usuario.

#posta[
  El segundo objetivo no habla del satélite: habla de *los satélites
  anteriores*. La misión existe para que una serie de datos de cuarenta años
  no se corte. Ésa es la necesidad, y explica casi todas las decisiones que
  vienen: la órbita, el horario, la calibración. En tu TP, buscá la frase
  equivalente: el «para qué» que justifica todo lo demás.
]

== Los requerimientos de alto nivel (diap. 46)

Volar en órbita de *705 km*, casi polar y *heliosincrónica*; mantener las trazas
de la grilla heredada (WRS-2) con *cruce del ecuador a las 10:00*; colectar
imágenes en el visible, infrarrojo cercano, de onda corta y térmico a lo largo
de una pisada de «X km»; cubrir la masa terrestre en cada temporada con *400
escenas por día*; mantener una calibración rigurosa (*TBD*); archivar y
distribuir; dar acceso no discriminatorio y productos de nivel 1; y transmitir
directo a las estaciones terrenas internacionales con convenio con el USGS.

#trampa[
  Cada renglón de la lámina empieza con un «ID -» sin número, hay un «X km» y
  un «TBD». No es descuido: es un *borrador real* de Pre-Fase A o Fase A, con
  los huecos *declarados* que alguien tiene que llenar —o por lo menos
  estimar, con un TBR— antes de que la SRR los congele. Y «rigurosa» es justo
  la clase de palabra vaga que no se puede verificar. Detalle: la figura de la
  órbita (diap. 45) dice 9:45 y el requerimiento dice 10:00; si te preguntan
  por el *requerimiento*, es 10:00. La hora de cruce *es* un requerimiento
  porque fija la iluminación: dos fotos del mismo lugar con sombras distintas
  no se comparan bien.
]

== Cómo cambió el concepto durante la Fase A (diap. 47)

La lámina compara *tres conceptos* para el paquete del instrumento: volar en
un *satélite propio* (_free flyer_), 170 kg, 1,3 m³ y 400 W, a 705 km; o
viajar *alojado en la plataforma de otro programa* (NPOESS), con 250 kg o 400
kg según la variante, a 828 km. Las flechas de abajo —técnica, costo y
planificación— crecen de izquierda a derecha. Es un _trade study_ de Fase A
con números reales, contra los tres lados del triángulo de hierro. Ganó el
satélite propio a 705 km, que es lo que pedía el requerimiento de órbita.

== Plataforma y carga útil

#definicion[plataforma (bus) y carga útil (diap. 56 a 58)][
  Las dos grandes partes de un satélite. La *carga útil* es lo que cumple la
  misión; la *plataforma* o *bus* es todo lo que la sostiene y la sirve:
  estructura, potencia, control de actitud, comando y manejo de datos,
  comunicaciones, propulsión y control térmico. Las dos integradas forman el
  *observatorio*.
]

En el LDCM la carga útil son dos instrumentos: el *OLI* (genera imágenes en el
visible y el infrarrojo) y el *TIRS* (sensor infrarrojo térmico). Los
subsistemas de la plataforma, con sus números (diap. 56 y 58):

#tabla((auto, 1fr),
  [*C&DH*, comando y datos], [computadora RAD750; grabador de estado sólido de *3,1 Tbit*; hasta 265 Mbps del OLI y 26,2 Mbps del TIRS; descarga a *384 Mbps*],
  [*EPS*, potencia], [un ala solar de arseniuro de galio, 4300 W al final de la vida; batería de níquel-hidrógeno de 125 Ah; bus no regulado de 22 a 36 V],
  [*ACS*, actitud], [dos de tres seguidores de estrellas activos, unidad inercial, ruedas de reacción; estabilizado en tres ejes],
  [Estructura], [aluminio; campos de visión de los instrumentos despejados],
  [*TCS*, térmico], [pasivo, con calefactores y tubos de calor si hace falta],
  [Propulsión], [hidracina en _blow-down_, ocho propulsores redundantes de 22 N],
  [Comunicaciones], [banda S (con tierra y con TDRSS) para comando y telemetría; banda X a 384 Mbps para la ciencia],
)

*Los números se encadenan, y ahí está la ingeniería de sistemas.* La carga útil
produce hasta 265 + 26,2 Mbps mientras mira, pero sólo puede bajar datos
*mientras ve una estación*. El grabador existe para cubrir esa diferencia.
Contalo (la cuenta es de este resumen): diez minutos seguidos tomando imágenes
son 291 Mbps × 600 s ≈ 175 Gbit; el grabador de 3,1 Tbit guarda unas 17
pasadas así, y bajar cada una a 384 Mbps lleva unos 7,6 minutos de contacto.
Las 400 escenas por día deciden cuánto se graba; el tiempo de contacto con
tierra, cuánto se baja. La salida de un subsistema es la entrada que dimensiona
al siguiente: el diagrama N² hecho cuentas.

== La interfaz entre la plataforma y la carga útil (diap. 48)

Conviven dos flujos: el de *comando y telemetría*, angosto, por un bus 1553 y
que sale en *banda S*; y el de *datos de ciencia*, ancho, por buses de alta
velocidad (todavía con formato «TBD») hacia el grabador, y que sale en *banda
X*. El TIRS está dibujado *en línea punteada*, con la leyenda «si el TIRS se
confirma para el LDCM»: en ese momento el segundo instrumento todavía no estaba
decidido.

#posta[
  Ese «si se confirma» vale oro para el TP: un diagrama de Fase A *puede y
  debe* mostrar lo que todavía no está decidido, marcado como tal. Inventar
  una certeza que no tenés es peor que una caja punteada con un cartelito
  honesto.
]

== El ConOps: tres segmentos (diap. 49 y 52)

El de *vuelo* (el observatorio: OLI, TIRS, C&DH y las dos bandas de radio), el
de *tierra* (operaciones de vuelo, con las estaciones, el centro de operaciones
y la planificación de tomas; y procesamiento y archivo, con el portal de los
usuarios) y el de *lanzamiento*. Cada caja lleva el color de *quién la
provee*: NASA, el USGS o los dos. ¿Por qué importa quién paga cada caja?
Porque la frontera entre dos organizaciones es una *interfaz*, y de las más
caras: dos presupuestos, dos jefes y un documento de control de interfaz en el
medio. En tu N², las interfaces *externas* son en buena parte las flechas que
cruzan de un color a otro.

== La jerarquía de requerimientos (diap. 50)

#tabla((auto, 1fr),
  [*Nivel 1* — la sede de NASA], [la ley de política de sensado remoto, el memorando NASA-DOI-USGS y los requerimientos de nivel 1 del LDCM],
  [*Nivel 2* — el proyecto], [el documento de requerimientos de ciencia y misión, y *al lado* el ConOps],
  [*Nivel 3*], [los documentos de cada segmento, de cada instrumento y de cada interfaz],
  [*Nivel 4 y abajo*], [los del contratista],
)

Fijate qué está arriba de todo: *una ley y un memorando entre organismos*. La
familia de requerimientos no empieza en un ingeniero sino en quien tiene la
autoridad: es el eslabón «autoridades» del Ejercicio de Alcance hecho
documento. Y el ConOps está *al lado* del documento de requerimientos de
misión, no debajo: los dos salen juntos del nivel 1.

== Del papel al hangar (diap. 55 a 64)

Las últimas láminas son el satélite de verdad: la plataforma en el hangar, la
carga útil integrada con una grúa, el _spacecraft_ armado —*4565 libras*, unos
2070 kg con el combustible cargado, 19 pies de alto y un panel de 32— y el
observatorio metido en media cofia del lanzador. Hacé la cuenta: el paquete del
instrumento del concepto propio pesaba 170 kg, y el satélite armado ronda las
dos toneladas. La carga útil es la razón de ser de la misión y una fracción de
su masa; el resto es la plataforma que la mantiene viva, apuntada y hablando
con tierra.

= 8. Fase B: el diseño preliminar y la tecnología lista
#origen[Clase 9, diapositivas 9 a 19 y 28 a 34 · apunte, módulos «Fase B a fondo» y «TRL, IRL y SRL»]

#definicion[Fase B — Diseño Preliminar y Completar la Tecnología (diap. 11)][
  *La última fase de la Formulación.* Después viene el punto de decisión de la
  Aprobación y, del otro lado, la Implementación. En ella se:
  + *bajan los requerimientos* de alto nivel —fijados en la SRR— a
    requerimientos detallados, consistentes con los de arriba, en un *árbol
    trazable*;
  + establece un *diseño preliminar*: un diseño base capaz de cumplir los
    requerimientos de sistema;
  + *completa la maduración de las tecnologías*, para que todas estén listas
    cuando arranque la Implementación;
  + completan los planes de verificación y validación y se desarrollan los
    *planes detallados de implementación*, con costos y planificación
    actualizados.

  Al terminar, la idea es tener «un buen plan para la Fase C y D» (diap. 12).
]

Su propósito, en la versión de las puertas de control (diap. 31): definir el
proyecto con el detalle suficiente para establecer un *baseline inicial* capaz
de cumplir las necesidades de la misión. Eso incluye refinar el ConOps, *alojar
las funciones y los recursos* (por ejemplo, los márgenes de masa), definir el
*flujo de los requerimientos hasta el nivel de caja*, *desarrollar la matriz de
verificación*, establecer la solución de diseño y *demostrar que se completaron
los desarrollos tecnológicos*. Es la última oportunidad de cambiar algo grande
antes de empezar a cortar metal.

#ejemplo[el TESS (diap. 12 a 19)][
  El TESS es el satélite de NASA que busca planetas fuera del sistema solar
  mirando cómo baja el brillo de una estrella cuando un planeta le pasa por
  delante: un eclipse chiquito, a años luz. Satélite mediano, *4 años de
  desarrollo* y un ciclo de vida total de *10 a 15 años*. Su corazón son
  *cuatro cámaras iguales* —cada una con siete lentes, un mosaico de cuatro
  CCD, un campo de 24° × 24° y 16,8 megapíxeles—. La plataforma, en cambio, es
  *de catálogo* (la LEOStar-2): estabilizada en tres ejes, 400 W de panel,
  bajada de datos en banda Ka a 100 Mbps. Eso ya se sabe hacer.

  ¿Qué se hace entonces en la Fase B? Madurar *lo que no se sabe hacer*: la
  óptica y los detectores. Hay que saber si soportan las *vibraciones del
  lanzador* y las *temperaturas del espacio*, y eso se sabe ensayándolos, no
  calculándolos. Por eso la lámina lo dice sin anestesia: «debemos gastar
  dinero antes de construir el satélite para hacer madurar las tecnologías»
  (diap. 17). En la misma fase se resuelven los _trade-offs_ que quedaron
  abiertos —en el TESS, cómo proteger las cámaras de la luz y el calor del
  Sol: ¿un blindaje más alto u otra forma?— y se decide *qué se hace en casa y
  qué se compra* a fabricantes (diap. 28). «La Fase B es para resolver todos
  estos problemas, tenemos que optimizar.»
]

#posta[
  Si descubrís en la Fase D, con el satélite armado, que una lente se despega
  con la vibración, pagás el rediseño de la cámara, desarmar el satélite y el
  atraso del lanzamiento. Si lo descubrís en la Fase B, pagás una cámara de
  ensayo. La Fase B no produce un satélite a medio hacer: *produce menos
  incertidumbre*. Compra riesgo barato.
]

== El umbral: TRL 6

La medida de «tecnología lista» es la escala de *TRL* (nivel de madurez
tecnológica, clase 9, diap. 20 a 23), y la cátedra pone la marca en *TRL 6*: la
tecnología está lista para soportar el ambiente al que va a estar expuesta,
asegurado con ensayos en tierra o con equipos que ya tienen historia en el
espacio (diap. 28).

#tabla((auto, 1fr),
  [1 · 2], [principios básicos observados · concepto o aplicación formulada (papel y matemática)],
  [3 · 4], [prueba de concepto en laboratorio (_breadboard_) · componente validado en laboratorio],
  [5], [componente validado en un *ambiente relevante*],
  [*6*], [*modelo o prototipo de sistema o subsistema demostrado en un ambiente relevante*: viabilidad de ingeniería demostrada],
  [7], [prototipo del sistema demostrado en el ambiente operacional (espacial)],
  [8 · 9], [sistema completo «calificado para vuelo» · «probado en vuelo»],
)

#trampa[
  Hasta TRL 5 se valida un *componente*; en TRL 6, un *modelo de sistema o
  subsistema*. TRL 7 ya pide volar: es el último escalón que se puede subir
  sin construir el satélite. Las notas dicen, tajantes, «TRL menor a 6 no pasa
  a la Fase C»; la clase 10 le pone fuente (guías de NASA y de la GAO: TRL 6
  para las tecnologías críticas al completar la PDR) y un caso que no la
  cumplió y siguió con un plan de mitigación aprobado, el Mars 2020. Es una
  guía fuerte, no una ley: romperla se paga con un riesgo declarado.
]

== La PDR: la revisión técnica de la Fase B

#definicion[PDR — Revisión Preliminar del Diseño (diap. 31 y 34)][
  La revisión técnica primaria de la Fase B. Revisión *multidisciplinaria*
  que asegura que el sistema puede comenzar el *diseño de detalle* y cumplir
  los requerimientos de desempeño dentro del costo, la planificación, el
  riesgo y las demás restricciones. Revisa requerimientos, diseño y
  operaciones como _baseline_ para el diseño de detalle, y *establece el
  Baseline Alojado*.
]

Antes de la PDR hay revisiones más chicas, *de pares* y *de subsistemas*, que
muestran cómo llega cada parte (diap. 29). *Lo que se espera en la PDR* (diap.
29-30):

- los requerimientos detallados, las restricciones y las medidas de desempeño
  son *consistentes con el diseño preliminar* (¿los propulsores y las baterías
  dan lo que se necesita?);
- los requerimientos de alto nivel *bajaron a los niveles detallados*,
  completos y *trazables hasta los objetivos del sistema* (y hasta la Pre-Fase
  A);
- las *interfaces externas e internas* están definidas, a todo nivel;
- los requerimientos están en un *nivel aceptable de riesgo*, y la tecnología
  y el diseño están maduros para la implementación dentro del dinero y la
  planificación;
- *todas las actividades de maduración tecnológica terminaron con éxito*;
- las *acciones asignadas en la MDR* se revisan: resueltas, se cierran; si no,
  quedan abiertas.

#posta[
  Leela como el examen de la Fase B: cada viñeta es uno de sus productos.
  Trazabilidad completa, interfaces definidas, tecnología madura, riesgo
  aceptable, deudas de la revisión anterior cerradas. Cada revisión mira para
  atrás antes de mirar para adelante.
]

Para el ROV del curso (diap. 34), el equipo tiene que demostrar: que entiende
los requerimientos de misión; que sabe *alojar y derivar* los requerimientos de
sistema a subsistemas; el ConOps; una visión de conjunto del diseño preliminar
que los cumple; los resultados de sus estudios; los resultados (o la
identificación) del prototipado y los ensayos necesarios; el *presupuesto
preliminar* de las fases que siguen; y la *planificación detallada* del
desarrollo.

== La revisión de confirmación

#definicion[revisión de confirmación, NAR (diap. 31)][
  La revisión *independiente* (_Non-Advocate Review_ o _Confirmation Review_)
  que cierra la Fase B junto con la PDR. Pregunta si los diseños de la misión,
  del _spacecraft_ y de los instrumentos cumplen los requerimientos de ciencia
  y misión; si los procesos de gestión alcanzan para desarrollar y operar la
  misión; y si el costo, el control y la planificación indican que estará
  lista para lanzar *a tiempo y dentro del presupuesto*.
]

¿Por qué otra revisión, si ya está la PDR? En la PDR revisan el *diseño*
ingenieros que, en general, quieren que el proyecto siga. La de confirmación la
hace gente *sin interés en que se apruebe* —eso quiere decir
_non-advocate_— y mira al proyecto *como empresa*: ¿la plata, la gestión y el
calendario cierran? Es la última compuerta antes de la Implementación, donde el
gasto se dispara, y por eso se pide una mirada que no esté enamorada del
satélite.

== La matriz de funciones, con la columna de la Fase B

La clase 9 vuelve a mostrar la matriz de funciones clave de la ingeniería de
sistemas por fase, ahora con la *Fase B* resaltada (diap. 32). Lo que pasa en
esa columna:

#tabla((auto, 1fr),
  [*Completo*], [objetivos, arquitectura y diseño, requerimientos, ambiente de misión, plan de gestión de la ingeniería de sistemas (SEMP)],
  [*Refinado*], [el ConOps],
  [*Asigna métodos*], [la verificación y validación],
  [*Baseline*], [las interfaces y el presupuesto de recursos técnicos],
  [*Análisis*], [el riesgo, con FMEA, FTA y RBD],
  [*Gestión formal*], [la configuración],
)

Y dos reglas de las notas al pie (diap. 33): los *requerimientos de nivel 1 y
los criterios de éxito de la misión* tienen que estar completos al final de la
Fase B; y para los componentes de fabricación larga, los *borradores de los
ICD* se escriben ya en la Fase A.

#trampa[
  La lámina de siglas del ciclo de vida (diap. 10) trae dos errores que no
  conviene copiar: llama a la *TRR* «Tech. Readiness Review» —es la de
  alistamiento de los *ensayos*, _Test Readiness Review_— y le pone a la
  *PLAR* el nombre de la ORR, cuando es la evaluación posterior al lanzamiento
  (_Post-Launch Assessment Review_). Y las dos copias de la matriz en la clase
  no ubican igual la SRR. Para el parcial vale lo que la cátedra *explica*: la
  SRR y la MDR son las revisiones de la Fase A; la *PDR y la de confirmación,
  las de la Fase B*.
]

= Lo que puede caer
#origen[Inferido de la forma de los cinco parcialitos anteriores: preguntas de definición, tipos y entregables. No es un anuncio de la cátedra.]

#tabla((1fr, 2.3fr),
  [*¿Qué es la WBS?*], [La subdivisión jerárquica, en árbol, de todo el trabajo necesario para el objetivo final, en componentes manejables; cada unidad con código; el nivel más bajo son los paquetes de trabajo.],
  [*¿Qué diferencia hay entre WBS y PBS?*], [La PBS es el árbol de componentes (de qué está hecho); la WBS es todo el trabajo (qué hay que hacer): la contiene y le agrega gestión, ingeniería de sistemas, integración y ensayo, logística.],
  [*¿Qué es un paquete de trabajo?*], [El nivel más bajo de la WBS: descripción del trabajo (tiempo, entradas y salidas), recursos, costo y responsable.],
  [*¿Bottom-up o top-down?*], [Bottom-up: lluvia de ideas y agrupar; para proyectos nuevos o equipos sin experiencia. Top-down: desde el objetivo, subdividiendo.],
  [*¿Qué elementos tiene un diagrama de red?*], [Eventos (hitos), actividades y duración; una actividad empieza cuando están completas todas sus entradas.],
  [*¿Qué es el camino crítico?*], [El camino más largo de la red: fija la duración del proyecto; sus actividades tienen holgura cero. Se encuentra recorriendo la red hacia adelante y hacia atrás, y se recalcula tras cada cambio (el té).],
  [*¿Qué es un diagrama de Gantt?*], [Herramienta de Henry Gantt: las tareas como barras con duración y secuencia sobre el calendario; sirve para el seguimiento y control. Se arma después de la red, agrupado por fases.],
  [*¿Qué es estimar y por qué importa?*], [Pronosticar tiempos y costos de los entregables; sirve para decidir (incluso si el proyecto vale la pena), planificar, el flujo de caja, medir el avance y fijar el baseline.],
  [*¿Cómo se estima?*], [Primero macro (top-down: analogía, consenso, relaciones matemáticas), después micro (bottom-up sobre la WBS) y se reconcilia la diferencia.],
  [*¿Órdenes de estimación?*], [ROM ±35 % (antes de lanzar), basada en tareas ±15 % (plan aprobado), planificación ±10 % (ejecutando).],
  [*¿Tipos de costos?*], [Directos (cargables a un paquete), directos generales del proyecto (identificables con el proyecto o un entregable), generales y administrativos (de la organización, indirectos).],
  [*¿Qué es la Fase B?*], [Diseño Preliminar y Completar la Tecnología, la última de la Formulación: baja los requerimientos a un árbol trazable, diseño preliminar, madura la tecnología (TRL 6), completa planes de V&V e implementación.],
  [*¿Qué es la PDR?*], [La revisión técnica de la Fase B: que el sistema puede pasar al diseño de detalle dentro de costo, plazo y riesgo; establece el Baseline Alojado.],
  [*¿Qué es la revisión de confirmación?*], [La revisión independiente (non-advocate) que cierra la Fase B con la PDR: ¿el diseño cumple, la gestión alcanza, y llega a tiempo y dentro del presupuesto?],
  [*¿Qué es TRL? ¿Por qué el 6?*], [Nivel de madurez tecnológica, de 1 a 9. El 6 es un modelo de sistema o subsistema demostrado en un ambiente relevante: la tecnología probó que soporta su ambiente.],
  [*¿Partes de un satélite? ¿Segmentos del ConOps del LDCM?*], [Plataforma (bus) y carga útil = observatorio. Segmentos: vuelo, tierra (operaciones; procesamiento y archivo) y lanzamiento.],
)

= Siglas

#tabla((auto, 1fr, auto, 1fr),
  [WBS], [estructura de desglose de trabajo], [PDR], [revisión preliminar del diseño],
  [PBS], [estructura de desglose de producto], [NAR], [revisión independiente (de confirmación)],
  [OBS], [estructura de la organización], [SRR], [revisión de requerimientos de sistema],
  [ROM], [orden de magnitud aproximado (±35 %)], [MDR / SDR], [revisiones de definición (Fase A)],
  [LDCM], [Landsat Data Continuity Mission], [CDR], [revisión crítica del diseño],
  [USGS], [Servicio Geológico de EE. UU.], [ICD], [documento de control de interfaces],
  [OLI / TIRS], [los dos instrumentos del LDCM], [TRL], [nivel de madurez tecnológica],
  [C&DH], [comando y manejo de datos], [SEMP], [plan de gestión de la ingeniería de sistemas],
  [EPS / ACS / TCS], [potencia / actitud / térmico], [FMEA], [análisis de modos de falla y efectos],
  [WRS-2], [la grilla de referencia de Landsat], [FTA / RBD], [árbol de fallas / diagrama de bloques de confiabilidad],
)
