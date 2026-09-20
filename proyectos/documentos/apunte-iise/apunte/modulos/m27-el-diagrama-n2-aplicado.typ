#import "../plantilla.typ": *

#modulo(
  "El diagrama N² aplicado: interfaces, lazos de realimentación y un caso real",
  [Aplicar la tabla N² de la unidad 2, ahora como herramienta genérica para
   alojar interfaces; identificar un lazo de realimentación en un diagrama
   N² ajeno; leer el diagrama N² real del TDRS; y dimensionar, con un
   ejemplo real de 17×17, cuán grande es un N² fuera del aula.],
  clave: "el-diagrama-n2-aplicado",
)

#lectura[
  Clase 7, diapositivas 46 a 53.
]

== La misma herramienta, ahora para interfaces

#clave[
  La unidad 2 ya definió la #t[tabla N² (diagrama N²)]: componentes o
  funciones en la diagonal de una matriz N×N, salidas en las filas, entradas
  en las columnas, celda en blanco = sin interfaz. Esta unidad no cambia esa
  definición — la aplica como la *herramienta genérica* para alojar
  requerimientos de interfaces, en vez de relaciones formales o
  funcionales.
]

#posta[
  El diagrama N² además *detalla dónde puede generarse conflicto* entre
  interfaces, y resalta las hipótesis de dependencia entre las entradas y
  salidas — no es sólo un mapa de qué se conecta con qué, es un mapa de
  *dónde mirar primero* si algo falla.
]

== Lazos de realimentación

#deduccion("cómo se ve un lazo de realimentación, y qué hacer con él")[
  Si hay flujo *bidireccional* entre dos funciones —la función 1 le manda
  algo a la función 2, y la función 2 le manda algo de vuelta a la función
  1— eso es un lazo de realimentación, y se ve en el N² como *dos celdas
  simétricas ocupadas* respecto de la diagonal. Cuando varias funciones
  forman un conjunto de acoplamientos así —incluyendo lazos de
  realimentación entre ellas— conviene *considerarlas combinadas* como
  candidatas a un mismo subsistema: agruparlas simplifica tanto el diseño
  del subsistema como sus interfaces hacia afuera.
]

#clave[
  Esto es exactamente la regla que la unidad 2 ya había dejado escrita para
  la tabla N² del circuito amplificador — un lazo de realimentación es un
  flujo bidireccional entre dos funciones, visible como dos celdas
  simétricas. Acá se usa ese mismo patrón como *criterio de agrupamiento*
  para decidir los límites de un subsistema candidato, no sólo para
  describir una interfaz ya decidida.
]

== Un caso real: el TDRS

#ejemplo("el diagrama N² del sistema de relevo satelital TDRS", nivel: "a-fondo")[
  El *Tracking and Data Relay Satellite* (TDRS) conecta a un satélite
  usuario con una estación de control terrestre a través de varias
  entidades intermedias: el propio TDRS, una estación de tierra remota, el
  sistema de datos y el control de relevo. El N² de este sistema muestra
  entradas y salidas reales entre esas entidades: pedidos de usuario y
  reportes de datos de usuario en un extremo; vectores, comandos, estado y
  rango del *spacecraft* fluyendo entre el satélite, el TDRS y el control en
  tierra; directivas, cronogramas y productos de datos completando el
  circuito. Todas las entidades físicas están, como siempre, sobre la
  diagonal.
]

#posta[
  Lo que hace valioso a este ejemplo no es la cantidad de flechas: es que
  muestra un N² con *entidades físicas reales* —un satélite, una estación
  remota, un centro de control— en vez de las funciones abstractas del
  ejercicio típico de aula. La herramienta es la misma; lo que cambia es
  que acá cada celda representa un enlace de comunicación que existe de
  verdad.
]

== Ejercicio: alojar las interfaces de un control remoto de TV

#clave[
  El ejercicio de la cátedra pide alojar los requerimientos de interfaces
  entre cinco entidades: el humano, la unidad de control remoto, el botón
  que se aprieta, la señal de RF, y el televisor (con su teclado, pantalla y
  salida de audio y video). El objetivo del ejercicio es identificar *en el
  N²*, y no en prosa, qué entidad interfacea con cuál — el mismo ejercicio
  que un equipo real hace con subsistemas de un *spacecraft*, a otra escala.
]

== La escala real: la matriz de diseño de un vehículo lanzador

#deduccion("de un ejercicio de cinco entidades a una matriz de diecisiete")[
  La cátedra cierra con la matriz N² real del diseño de un vehículo
  lanzador: *17 disciplinas* en la diagonal —configuración estructural,
  performance y trayectorias, propiedades de masa, aerodinámica,
  estructuras, térmico, guiado y control, materiales, propulsión,
  comunicaciones, potencia eléctrica, operaciones de tierra, operaciones de
  vuelo, manufactura, seguridad, confiabilidad y costo— con *cientos* de
  entradas y salidas reales entre ellas (geometría del vehículo, cargas de
  vibración, requerimientos de verificación, presupuestos de masa,
  perfiles de trayectoria, y muchas más).
]

#posta[
  Este es el N² real, no el de ejercicio: la matriz del control remoto de
  TV tiene 5 entidades; ésta tiene 17, con docenas de entradas y salidas
  por celda. La herramienta no cambia de forma al escalar — sigue siendo
  la misma diagonal, las mismas filas de salida y columnas de entrada—,
  pero el volumen de información que administra es el de un vehículo
  lanzador completo, no el de un aparato doméstico.
]

== Resumen: cuatro usos del N²

#clave[
  *(1)* Las interfaces externas del sistema se definen, distribuyen y
  gestionan junto con los demás requerimientos. *(2)* Las interfaces
  internas, creadas a medida que el sistema se descompone, pueden
  optimizarse agrupando funciones parecidas y usando interfaces estándar.
  *(3)* Como cada equipo se enfoca en su propio subsistema, toda interfaz
  corre el riesgo de quedar sin dueño — hay que explicitar el propietario de
  cada una. *(4)* El N² identifica la mayoría de las interfaces comunes:
  captura su existencia y naturaleza, resalta hipótesis y requerimientos de
  entrada/salida, muestra los lazos de realimentación, e identifica
  candidatos para alojar funcionalidad en cada subsistema.
]
