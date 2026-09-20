#import "../plantilla.typ": *

#modulo(
  "El proceso de punta a punta: Space Shuttle y un rover marciano",
  [Aplicar la #t[jerarquía del sistema] y el #t[CDIO detallado] para
   descomponer un problema; recorrer el proceso completo —de la necesidad a
   la operación— en dos ejemplos reales; y calcular cuántos niveles de
   descomposición necesita un sistema según su cantidad de partes.],
  clave: "el-proceso-de-punta-a-punta",
)

#lectura[
  Clase 4, diapositivas 41 a 88 y 108 a 112.
]

== Cómo se parte un problema grande: dos descomposiciones

Frente a un proyecto complejo, la ingeniería de sistemas lo divide de dos
maneras distintas y complementarias — dividir y conquistar, la vieja
estrategia #diapo(4, 41).

#definicion("jerarquía del sistema")[
  La notación NASA para descomponer un *producto* en piezas cada vez más
  chicas: *Sistema → Segmento → Elemento → Subsistema → Componente → Sub
  ensamble → Parte*. #diapo(4, 41)
]

#cuidado[
  El nivel es *relativo al proyecto, no absoluto*: *"el sistema de un
  proyecto es el componente de otro"* #diapo(4, 111). Es la misma idea que el
  principio de los niveles de la unidad 1 (sistema N+1 / N / N-1), ahora con
  siete escalones con nombre propio en vez de tres genéricos. Para un
  proyecto de satélite completo, "sistema" es el satélite entero; para el
  equipo que sólo diseña la batería, "sistema" es la batería, y el satélite
  es su contexto.
]

#definicion("CDIO detallado")[
  La versión de ocho pasos del ciclo de vida de un proyecto: *Necesitar,
  Requerir, Descomponer, Diseñar, Integrar, Verificar, Operar y Disponer*.
  #diapo(4, 41)
]

#clave[
  Esto es #t[CDIO] —Concebir, Diseñar, Implementar, Operar— *pero más
  detallado*, la cátedra lo dice de manera explícita #diapo(4, 41): Necesitar
  y Requerir se abren dentro de Concebir; Descomponer y Diseñar dentro de
  Diseñar; Integrar y Verificar dentro de Implementar; y Operar y Disponer
  dentro de Operar. Son la misma secuencia vista con más resolución — no dos
  modelos distintos que memorizar por separado.
]

== Ejemplo 1: el Space Shuttle

=== De la necesidad al concepto

La necesidad del cliente: llevar toda la carga útil (peso, volumen) con
*siete tripulantes* a órbita baja y traerlos de vuelta, con un vehículo
*íntegramente reusable* (IRLV) #diapo(4, 43). A eso se sumaban otras
necesidades — soporte logístico a estaciones espaciales, lanzamiento y
retiro de satélites, entrega de cargas y propelente en órbita, servicio a
satélites, misiones tripuladas cortas.

#clave[
  De estas necesidades salen los *requerimientos de alto nivel*
  #diapo(4, 43) — el mismo patrón necesidad → requerimiento que se repite en
  el rover marciano más abajo, y que se va a formalizar del todo en la
  unidad 5.
]

La tarea del arquitecto es generar *alternativas de diseño conceptual*
#diapo(4, 42). Y no fueron pocas:

#figure(
  image("../figuras/c04-p045.png", width: 85%),
  caption: [Catorce familias de conceptos distintos, propuestos en Pre Fase A para el Space Shuttle, antes de elegir uno #diapo(4, 45).],
)

#posta[
  Esta imagen vale más que cualquier definición de "creatividad
  estructurada" de la unidad 2: *catorce* familias de conceptos, cada una
  con varias variantes, evaluadas *antes* de seleccionar una. La selección
  final —el orbitador alado reusable con dos boosters sólidos— fue *una*
  entre docenas de alternativas serias, no la única opción obvia
  #diapo(4, 46) #diapo(4, 47) #diapo(4, 48) #diapo(4, 49).
]

=== Requerimientos de alto nivel, ya escritos

Una vez elegida y evolucionada la alternativa (Fase A, #diapo(4, 50)), las
necesidades del cliente se convirtieron en requerimientos concretos y
medibles #diapo(4, 51):

- Transportar carga a órbita baja terrestre (LEO), entre 185 y 401 km de
  altura, en una bodega de 4,57 m de diámetro por 18,28 m de longitud.
- El orbitador y los dos boosters sólidos deben ser *reusables* —el
  requerimiento mayor del sistema.
- Tripulación de hasta ocho personas (diez en emergencia).
- Misión básica de siete días en el espacio.
- Aceleración máxima de 3g, sin trajes de protección ambiental.
- Capacidad de maniobra de 2.037 km en el reingreso.

=== Qué pasó después: ciclo de vida completo, y por qué costó tanto

El Shuttle operó de 1977 a 2011: 135 lanzamientos, *US\$ 192.000 millones*
en total #diapo(4, 54).

#cuidado[
  La visión era un vehículo *parcialmente reusable* con alistamiento y
  salida rápidos al próximo vuelo. El resultado real fue un vehículo
  *complejo y frágil*, con un costo promedio de *US\$ 1.500 millones* por
  lanzamiento (20.000 horas-hombre). Las razones que da la cátedra
  #diapo(4, 54):
  - *Optimismo exagerado* en las estimaciones iniciales.
  - El Congreso topeó el financiamiento de I+D e ingeniería en
    US\$ 85.150M (1971).
  - El foco estuvo puesto en *alcanzar desempeño*, no en el costo total.
  - El *mantenimiento no se pensó desde el principio* — el sistema no se
    diseñó *para* ser mantenido barato.
  - Se optimizó el ciclo de vida por *costo/valor*, pero de manera *poco
    realista*.
]

#deduccion("la lección que conecta con el triángulo de hierro")[
  Cada una de estas cinco razones es, en el fondo, la misma falla: se fijó
  el *desempeño* como variable dura y se dejó flotar el *costo del ciclo de
  vida completo* sin un análisis realista — exactamente lo que el
  #t[triángulo de hierro] de la unidad 1 advierte que pasa cuando las tres
  variables (desempeño, costo, planificación) no se balancean a propósito,
  sino que una se impone por default.
]

== Ejemplo 2: un nuevo rover para Marte

=== De la ciencia a la ingeniería

Las necesidades del cliente, esta vez de una comunidad científica: estudiar
el clima y la geología de Marte; evaluar si las condiciones ambientales
pudieron sostener vida microbacteriana; investigar el rol del agua en la
historia de Marte; preparar la exploración humana futura #diapo(4, 58).

#clave[
  El primer paso de la ingeniería de sistemas frente a una necesidad nueva
  *no es diseñar*: es preguntar si ya existe una herramienta que la resuelva
  #diapo(4, 59). Los rovers anteriores —Sojourner, Spirit y Opportunity,
  Curiosity— no podían hacer la ciencia que esta nueva misión pedía. Recién
  ahí se justifica un diseño nuevo.
]

=== Trade studies, modelos de ingeniería, y el costo de cambiar tarde

Con la necesidad de un rover nuevo confirmada, la ingeniería de sistemas hace
*trade studies* — análisis de alternativas, de costo-beneficio, de qué
tecnologías nuevas hacen falta y qué riesgo de madurez tienen (TRL) para los
tiempos de la misión #diapo(4, 69). De conceptos dibujados se pasa a diseño
preliminar, y de ahí a *modelos de ingeniería* — prototipos que se someten a
ensayo antes de construir el modelo de vuelo #diapo(4, 73) #diapo(4, 74).

#cuidado[
  *El costo de un cambio depende de CUÁNDO se hace.* En diseño conceptual,
  cambiar algo cuesta casi nada — son dibujos. Una vez que el vehículo se
  está *construyendo*, cualquier cambio porque no cumple un requerimiento
  implica ir para atrás, rehacer planos y re-manufacturar — con un efecto
  dominó sobre programación y presupuesto #diapo(4, 76). Es el mismo
  argumento, con otro ejemplo, del ciclo de vida del Shuttle de arriba: el
  momento del cambio importa tanto como el cambio en sí.
]

Después de construir e integrar, el vehículo se somete a ensayos que
reproducen su ambiente real — cámaras de vacío térmico que simulan la
temperatura y la presión de Marte #diapo(4, 79) #diapo(4, 80) #diapo(4, 81).

#posta[
  Ahí aparece, por primera vez con nombre propio, la distinción entre
  *verificar* —¿este requerimiento puntual (masa, potencia, órbita) se
  cumple?— y *validar* —¿el sistema completo hace lo que el cliente y los
  interesados necesitan que haga? #diapo(4, 57). La unidad 5 desarrolla la
  verificación y validación (V&V) a fondo; acá alcanza con tenerlas
  distinguidas.
]

El proyecto recorre las fases estándar de NASA —Pre-A, A, B, C, D, E, F—
donde la Fase D construye el _spacecraft_ y la Fase E lo opera
#diapo(4, 81). La ingeniería de sistemas acompaña al vehículo *hasta el final
de su vida*.

== Cuántos niveles de descomposición hacen falta

#deduccion("la fórmula de niveles")[
  La mente humana no razona con solvencia más de tres niveles de
  descomposición a la vez — la misma limitación de *7 ± 2 elementos* de la
  unidad 2 #diapo(4, 110). Un destornillador tiene unas 3 partes; un
  automóvil, del orden de 10.000; un avión de línea, cientos de miles. La
  cátedra da la fórmula que conecta cantidad de partes con niveles
  necesarios:

  $ "número de niveles" = log("número de partes") / log(7) $

  Con 7 como base porque cada nivel se organiza, otra vez, en grupos
  manejables de alrededor de 7 elementos. Un sistema de 10.000 partes
  necesita del orden de 5 niveles de descomposición para que cada nivel siga
  siendo comprensible.
]

#clave[
  La #t[jerarquía del sistema] no es burocracia: es la aplicación directa de
  esta fórmula. Un satélite completo tiene demasiadas partes para pensarlas
  de una — Sistema, Segmento, Elemento, Subsistema, Componente, Sub
  ensamble, Parte son, literalmente, los *siete niveles* que la fórmula
  predice para un sistema de esa escala, cada uno asignable a un grupo de
  ingenieros que puede razonar sobre su porción sin perder de vista el todo.
]
