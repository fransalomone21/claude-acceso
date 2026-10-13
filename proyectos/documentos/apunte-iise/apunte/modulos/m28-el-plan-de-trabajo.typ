#import "../plantilla.typ": *

#modulo(
  "El plan de trabajo: WBS, red de actividades, camino crítico y Gantt",
  [Armar la estructura de desglose de trabajo (WBS) de un proyecto, con sus
   niveles, sus códigos y sus paquetes de trabajo; distinguirla de la
   estructura de desglose de producto (PBS); dibujar una red de actividades
   y encontrar su camino crítico recorriéndola hacia adelante y hacia
   atrás, con la holgura de cada actividad; y pasar todo eso a un diagrama
   de Gantt. Es, punto por punto, lo que pide la sección 5 del trabajo
   práctico final.],
  clave: "el-plan-de-trabajo",
)

#lectura[
  Clase 8, diapositivas 4 a 16, 20 a 26 y 34 a 40.
]

== De qué se trata, antes de la primera herramienta

Hasta acá el apunte se ocupó de *qué* hay que construir: necesidades,
requerimientos, arquitectura. La clase 8 cambia de pregunta: *cómo se
organiza el trabajo de construirlo*. El triángulo de hierro del módulo
#M("proyecto") vuelve a aparecer en la diapositiva 5, con el mismo detalle
que ya se marcó ahí —es *de hierro* sólo si los tres lados están
restringidos— y con el jefe de proyecto en el medio, balanceando desempeño,
costos y planificación y «dirigiendo y controlando el riesgo»
#diapo(8, 6). El plan de trabajo es la herramienta con la que ese señor
deja de hacer malabares a ojo.

#clave[
  El plan de trabajo se arma con cuatro piezas, en este orden
  #diapo(8, 4): el *desglose del trabajo* (la #t[WBS]), el *diagrama de
  red* que ordena ese trabajo, el *camino crítico* que sale de recorrer la
  red, y el *diagrama de Gantt* que lo pone sobre un calendario. Cada pieza
  usa la anterior: no hay Gantt honesto sin red, ni red sin saber cuáles
  son las tareas.
]

== La WBS: partir todo el trabajo en un árbol

#definicion("WBS — estructura de desglose de trabajo")[
  La subdivisión jerárquica, en forma de árbol, de *todo el trabajo*
  necesario para alcanzar el objetivo final: se empieza por el objetivo y
  se lo parte en componentes manejables en tamaño y complejidad
  #diapo(8, 22). Cada unidad lleva un código que dice dónde está en el
  árbol (1.0, 1.2, 1.2.1), y el nivel más bajo son los *paquetes de
  trabajo* #diapo(8, 24).
]

La cátedra la presenta con la imagen de un rompecabezas
#diapo(8, 7): el trabajo total es la caja armada, el nivel 2 son las
tareas y el nivel 3 las subtareas. La imagen dice algo que la definición
deja implícito: *las piezas tienen que cubrir todo el cuadro y no
superponerse*. Una tarea que no está en ningún casillero no la hace nadie;
una que está en dos la pagan dos veces.

=== Cómo se arma: de abajo hacia arriba o de arriba hacia abajo

- *De abajo hacia arriba* (_bottom-up_): una lluvia de ideas con todas las
  actividades que se te ocurran, que después se agrupan en categorías. Es
  el método más apropiado cuando el proyecto usa métodos nuevos, no
  ensayados, o cuando el equipo *nunca hizo algo parecido*
  #diapo(8, 8) —léase: un grupo de alumnos con su primer satélite—.
- *De arriba hacia abajo* (_top-down_): partir del objetivo y bajar nivel
  por nivel. Es la definición de NASA: «desarrollar comenzando con el
  objetivo final requerido y sucesivamente subdividir» #diapo(8, 22).

Los pasos que da la cátedra para definir las tareas #diapo(8, 21): fijar
el alcance y las prioridades del proyecto; decidir si las tareas se
organizan *por entregables*, *por procesos* o por una combinación; y
recién ahí crear la WBS, con los niveles altos como las tareas más
generales y el nivel más bajo como los paquetes de trabajo.

#deduccion("por qué casi todo proyecto espacial organiza por las dos cosas a la vez")[
  Organizar *por entregables* sirve cuando el resultado es un objeto
  concreto —una represa, un satélite— que se parte en sub-entregables que
  se pueden hacer en paralelo. Organizar *por procesos o fases* sirve
  cuando el resultado de una fase cambia las tareas de la siguiente. Un
  proyecto espacial tiene las dos cosas: fases que van definiendo la
  innovación, y resultados tangibles —el _spacecraft_— que aparecen a mitad
  de camino #diapo(8, 20). Por eso la cátedra dice que «muchos proyectos
  aeroespaciales son realmente una combinación de estas dos estructuras».
]

=== Niveles, códigos y paquetes de trabajo

#definicion("paquete de trabajo")[
  La unidad del nivel más bajo de la WBS. Lleva la descripción del trabajo
  —con su tiempo planificado y sus entradas y salidas—, los recursos y el
  costo que necesita, y *la persona responsable* de que se complete. Un
  elemento bajo de la WBS puede necesitar varios paquetes, y sumándolos
  hacia arriba sale el costo y el tiempo de cada unidad #diapo(8, 25).
]

Las reglas prácticas de la diapositiva 24: la WBS es jerárquica (lo
general arriba, lo específico abajo), cada nivel se particiona en el
siguiente, *para la mayoría de los proyectos es poco probable bajar más
del cuarto nivel*, y cada unidad lleva su código. Muchas veces el nivel 3
alcanza y el 4 ya son los paquetes de trabajo #diapo(8, 26).

#cuidado[
  *Cada subunidad de la WBS es un entregable de alguna clase* #diapo(8, 25),
  y la cátedra da dos tipos: los productos concretos (el sistema de
  potencia, un módulo de _software_) y *lo que hace falta para salir de la
  fase actual*: requerimientos de sistema, el documento de control de
  interfaces (ICD), resultados de ensayos. Una WBS que sólo tiene «hardware»
  se olvidó de la mitad del trabajo, que es justamente el que se ve en las
  revisiones.
]

El ejemplo de la cátedra es un proyecto universitario chico, con un
_CubeSat_ entre sus cargas, ya con tiempos y costos en cada unidad
#diapo(8, 34): el sistema de potencia (1.0) se parte en fuente, las
alimentaciones de cada unidad y la integración y ensayo del sistema de
potencia (1.6); la alimentación del _CubeSat_ (1.5) baja hasta el nivel 4
—establecer requerimientos de control, diseñar la interfaz, prototipar y
ensayar, completar el diseño, implementar y ensayar—. Sumando todo, el
proyecto da *710 días y 27 010 dólares*.

#figure(
  placement: auto,
  image("../figuras/c08-p034.png", width: 58%),
  caption: [Una WBS con estimaciones: cada paquete del nivel 4 trae su duración y su costo, y la suma sube hasta el total del proyecto (diapositiva 34).],
)

#posta[
  Mirá dónde termina la rama 1.5.2: «establecer requerimientos», «diseñar»,
  «prototipar y ensayar», «completar el diseño», «implementar y ensayar».
  Es el diagrama en V del módulo #M("ciclo-de-vida-y-diagrama-en-v"),
  achicado al tamaño de una sola interfaz. La WBS no inventa un proceso
  nuevo: reparte el que ya conocés en cajitas con dueño, fecha y precio.
]

=== Para qué sirve

La diapositiva 23 lo enumera: identificar las tareas, subtareas y
unidades de trabajo; las relaciones entre ellas; *aumentar la
probabilidad de que cada requerimiento sea tenido en cuenta*; organizar
áreas de responsabilidad y autoridad; estimar costos y planificación;
seguir los costos de cada elemento; y monitorear el avance mostrando qué
tareas se completaron.

=== WBS no es PBS

#definicion("PBS — estructura de desglose de producto")[
  El árbol de los componentes con los que se forma el sistema. Refleja el
  trabajo de *producir* cada componente; la WBS, además, el trabajo de
  *integrarlos* en un sistema #diapo(8, 35).
]

#figure(
  placement: auto,
  image("../figuras/c08-p035.png", width: 80%),
  caption: [PBS y WBS sobre el mismo árbol: a la izquierda del corte, los subsistemas (el producto); a la derecha, gestión, ingeniería de sistemas, integración y ensayo, y soporte logístico, que no son partes del satélite pero son trabajo (diapositiva 35).],
)

#deduccion("dónde está la diferencia, en una línea")[
  La PBS contesta *¿de qué está hecho?*; la WBS contesta *¿qué hay que
  hacer?*. Por eso la WBS contiene a la PBS y le agrega las ramas que no
  son piezas: la gestión del proyecto, la ingeniería de sistemas, la
  integración, el ensayo y la verificación, la logística. Si tu WBS se
  puede atornillar, es una PBS con otro nombre.
]

=== Las WBS estándar de NASA y del JPL

NASA fija el *nivel 2* de la WBS de todo proyecto de vuelo espacial, con
once elementos y su código #diapo(8, 36): 01 gestión del proyecto, 02
ingeniería de sistemas, 03 seguridad y aseguramiento de la misión, 04
ciencia y tecnología, 05 carga útil, 06 _spacecraft_, 07 operaciones de la
misión, 08 vehículo lanzador y servicios, 09 sistemas de tierra, 10
integración y ensayo de sistemas, y 11 educación y difusión. El JPL baja
esa misma estructura al nivel 3 #diapo(8, 37).

#figure(
  placement: auto,
  image("../figuras/c08-p036.png", width: 68%),
  caption: [La WBS estándar de NASA para proyectos de vuelo espacial, nivel 2 (diapositiva 36).],
)

#posta[
  Para el trabajo práctico, esta lámina es media WBS regalada: los once
  casilleros de nivel 2 ya están, y lo que queda es bajar uno o dos niveles
  en los que le tocan a tu misión. Fijate que gestión, ingeniería de
  sistemas, aseguramiento de la misión y difusión están en el *mismo
  nivel* que el satélite: para NASA, ese trabajo pesa tanto como el
  _hardware_.
]

#cuidado[
  En la versión de la clase 8 publicada el 12/10, las diapositivas 38 a 40
  —una WBS de integración de sistemas de Northrop Grumman y un ejemplo de
  desglose y de descripción de paquetes de trabajo— *están ocultas*: no se
  proyectan en clase. La 40 es, de todos modos, un buen modelo de qué
  campos lleva un paquete de trabajo (título, responsable, evento de
  inicio y de fin, objetivos, entradas requeridas, tareas incluidas y
  salidas), que son los de la diapositiva 25 puestos en un formulario.
]

== La red de actividades: el orden y las dependencias

#definicion("diagrama de red (red de actividades)")[
  Un diagrama de flujo que muestra el orden en que se hacen las tareas y
  las dependencias entre ellas, con tres elementos: *eventos* (o hitos:
  «comienzo del diseño», «borrador del informe aprobado»), *actividades*
  (el trabajo para pasar de un evento a otro) y *duración* (el tiempo
  calendario de cada actividad) #diapo(8, 9).
]

La regla que hace funcionar todo: *todas las entradas de una actividad
tienen que estar completas antes de que empiece* #diapo(8, 10). Con eso
solo ya se puede calcular cuánto dura el proyecto.

#figure(
  placement: auto,
  image("../figuras/c08-p010.png", width: 70%),
  caption: [Una red de cajas con cinco actividades y su camino crítico marcado en rojo (diapositiva 10).],
)

#definicion("camino crítico (y holgura)")[
  La secuencia de actividades que determina la duración total del
  proyecto: el camino más largo de punta a punta. Una actividad fuera de él
  tiene *holgura* —puede atrasarse ese tanto sin atrasar el proyecto—; una
  del camino crítico no tiene ninguna.
]

La lámina nombra el método —«recorrer hacia adelante y hacia atrás»,
_forward and backward pass_ #diapo(8, 4)— y deja el camino marcado en rojo
sin hacer la cuenta. La cuenta es corta y es la que se toma, así que va
entera.

#deduccion("el camino crítico de la diapositiva 10, recorriendo la red")[
  *Hacia adelante:* cada actividad empieza lo más temprano posible, que es
  cuando terminó la *última* de sus entradas. La 1 y la 3 arrancan en 0.
  La 1 termina en 5; la 3, en 1; la 4 (que espera a la 3) va de 1 a 4; la 2
  (que espera a la 1) va de 5 a 6; la 5 espera a la 1 *y* a la 4, así que
  empieza en el mayor de los dos finales, 5, y termina en 7. El proyecto
  dura *7*.

  *Hacia atrás:* desde el fin, cada actividad termina lo más tarde posible
  sin correr el 7. La 5 tiene que terminar en 7, así que empieza a más
  tardar en 5; la 2, terminar en 7 y empezar en 6. La 1 alimenta a la 2 y
  a la 5: tiene que terminar antes del *menor* de sus comienzos tardíos,
  5, y entonces empezar en 0. La 4 tiene que terminar en 5 y empezar en 2;
  la 3, terminar en 2 y empezar en 1.

  *Holgura = comienzo tardío − comienzo temprano:*

  #align(center, table(
    columns: (1.4fr, 1fr, 1fr, 1fr),
    align: center,
    stroke: 0.4pt + luma(180),
    [*Actividad*], [*Temprano*], [*Tardío*], [*Holgura*],
    [1 ($t = 5$)], [0 → 5], [0 → 5], [*0*],
    [2 ($t = 1$)], [5 → 6], [6 → 7], [1],
    [3 ($t = 1$)], [0 → 1], [1 → 2], [1],
    [4 ($t = 3$)], [1 → 4], [2 → 5], [1],
    [5 ($t = 2$)], [5 → 7], [5 → 7], [*0*],
  ))

  Las de holgura cero son el camino crítico: Comienzo → 1 → 5 → Fin, *7
  unidades*, exactamente el rojo de la lámina. Los otros dos caminos (1 → 2
  y 3 → 4 → 5) duran 6.
]

=== «Haciendo el té»: el camino crítico se mueve

El ejemplo de la cátedra es servir té con leche en bandeja, con trece
actividades #diapo(8, 11). Hervir el agua lleva 180 segundos; todo lo
demás, entre 3 y 20. El camino crítico pasa por hervir el agua, calentar
la tetera, recalentar, verter y servir, y el total es *253 segundos*
#diapo(8, 13): 10 + 3 + 180 + 10 + 10 + 15 + 5 + 20. Mientras el agua
hierve, la otra rama —la leche, el azúcar, buscar la bandeja— tiene tiempo
de sobra.

Después viene la «nueva tecnología» #diapo(8, 14): una pava que hierve en
10 segundos y un recalentado de 1. Si el camino crítico fuera fijo, el
total bajaría a 78. *Baja a 83*: con el agua ya no tardando nada, la rama
de la bandeja (10 + 3 + 15 + 15 + 10 + 10 + 20 = 83) pasa a ser la más
larga, y *el camino crítico se mudó de rama*.

#figure(
  placement: auto,
  image("../figuras/c08-p014.png", width: 80%),
  caption: [El té con nueva tecnología: el agua ya no manda, y el camino crítico (en rojo) pasa por la leche, el azúcar y la bandeja: 83 segundos (diapositiva 14).],
)

#posta[
  La moraleja vale más que el té: *acelerar una tarea del camino crítico
  achica el proyecto sólo hasta que otro camino pasa a ser el largo*. De
  180 a 10 segundos es una mejora de 18 veces en una tarea, y el proyecto
  mejora apenas tres. Por eso, después de cada cambio, el camino crítico se
  recalcula: el cuello de botella de ayer no es el de mañana.
]

== El diagrama de Gantt: la red, sobre el calendario

#definicion("diagrama de Gantt")[
  Herramienta, originada por Henry Gantt, para planificar y programar
  tareas a lo largo de un período: dibuja cada tarea como una barra con su
  duración y su secuencia sobre el calendario del proyecto, y permite el
  seguimiento y control del avance de cada etapa #diapo(8, 15).
]

#figure(
  placement: auto,
  image("../figuras/c08-p016.png", width: 72%),
  caption: [El té en Gantt: la barra larga es el agua hirviendo, y la franja rotulada _SLACK_ es la holgura de la rama de la bandeja (diapositiva 16).],
)

#deduccion("qué agrega el Gantt que la red no tenía")[
  La red dice *qué depende de qué*; el Gantt dice *qué pasa cada día*. El
  Gantt de la diapositiva 16 muestra la holgura como lo que es: una franja
  de tiempo en la que esa rama puede correrse sin que nadie note el atraso.
  Lo que el Gantt *no* muestra bien son las dependencias, y por eso se
  arma *después* de la red, no en su lugar: un Gantt dibujado directo
  sobre el calendario, sin red, tiene barras prolijas y un camino crítico
  que nadie calculó.
]

#cuidado[
  En la clase 8 la cátedra muestra el Gantt real de un proyecto de ROV y le
  escribe abajo, en azul, *«No están aclaradas las Fases»*
  #diapo(8, 91). Es una corrección, y vale para tu Gantt: las barras se
  agrupan por *fase* del ciclo de vida, con los hitos de cada revisión
  marcados, no como una lista plana de tareas.
]
