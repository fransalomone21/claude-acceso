#import "../plantilla.typ": *

#modulo(
  "El diagrama funcional, con los ROV de la cátedra; y 24 tornillos",
  [Leer y dibujar un diagrama funcional (de bloques) como lo pide la
   cátedra: bloques principales, subsistemas y entornos en cajas
   punteadas, y cada conexión con su tipo (dato, potencia, señal);
   reconocer el mismo sistema dibujado con distintos niveles de detalle;
   leer una tabla de especificaciones con su propósito al lado; y explicar,
   con el caso del NOAA-N′, por qué la gestión de configuración no es
   burocracia.],
  clave: "el-diagrama-funcional",
)

#lectura[
  Clase 8, diapositivas 77 a 97.
]

== Qué es, y para qué lo enseña la cátedra con submarinos

#definicion("diagrama funcional (diagrama de bloques funcional)")[
  El diagrama que muestra las funciones o bloques principales del sistema
  y las conexiones entre ellos, *distinguiendo el tipo de conexión* (dato,
  potencia, señal), con los subsistemas o entornos separados en cajas.
]

La cátedra no lo define con una frase: lo enseña con una docena de
ejemplos de vehículos sumergibles operados a distancia —ROV, _Remotely
Operated Vehicle_— #diapo(8, 77) #diapo(8, 79). El ROV es un buen sistema
de práctica: tiene un segmento «de tierra» (la superficie, con el
operador), un segmento «de vuelo» (el vehículo bajo el agua), un vínculo
entre los dos (el cable umbilical) y un ambiente hostil que manda sobre el
diseño. Es un satélite que se moja.

#clave[
  Lo que se pide de un diagrama funcional, según lo que la cátedra mostró
  y dijo en clase:
  - identifica los componentes del sistema con sus relaciones *formales y
    funcionales* y sus conexiones (el vocabulario del módulo
    #M("relaciones-n2-emergentes"));
  - usa *cajas punteadas* para separar los subsistemas o los entornos;
  - *no baja a componentes muy específicos*: busca reconocer las funciones
    y los subsistemas principales, al nivel de acercamiento que
    corresponde;
  - alcanza para ponerle un *título a cada subsistema*: la parte de
    potencia se reconoce porque están la batería y la conversión de
    tensión, juntas y separadas del resto;
  - incluye alguna *interfaz de comunicación* del sistema.
]

== El mismo ROV, con su leyenda

#figure(
  placement: auto,
  image("../figuras/c08-p080.png", width: 80%),
  caption: [Un ROV con sus dos cajas —superficie (izquierda) y vehículo (el trapecio)— y tres tipos de conexión en la leyenda: «Bi nivel – Tri», «Potencia» y «Dato» (diapositiva 80).],
)

El primer ejemplo #diapo(8, 80) tiene todo lo de la lista. A la
izquierda, la *superficie*: dos _joysticks_, un sensor de temperatura, una
pantalla, LED, interruptores, la fuente, una placa controladora y una PC.
A la derecha, el *vehículo*: una placa controladora de abajo, ocho
propulsores (verticales y horizontales), luces, sensores de temperatura y
de fugas, una unidad inercial, la cámara, el registro de datos y su
fuente. En el medio, *30 m de cable ethernet* que lleva los datos. Y una
leyenda que separa las conexiones por *tipo*: señales de nivel lógico,
potencia y datos.

#figure(
  placement: auto,
  image("../figuras/c08-p081.png", width: 72%),
  caption: [Otro ROV, más simple: «Land» con la fuente de 48 V y la laptop, un fusible de 40 A, y en «ROV» la cadena de potencia (48 V → 18,5 V → 5 V), la computadora de a bordo, dos Arduino, los puentes H, los propulsores, los sensores y la cámara (diapositiva 81).],
)

#deduccion("cómo se lee la potencia en la diapositiva 81 sin que nadie la rotule")[
  Seguí la tensión: 48 V salen de tierra, pasan un fusible de 40 A, bajan
  a 18,5 V para los puentes H y los propulsores, y vuelven a bajar a 5 V
  para la computadora y los Arduino. Esos cuatro bloques —fuente, fusible,
  dos convertidores— *son* el subsistema de potencia, aunque la lámina no
  lo encierre en una caja con ese nombre. Es exactamente el criterio de la
  cátedra: los bloques tienen que alcanzar para que el lector le ponga el
  título a cada subsistema. Y la protección (el fusible) está del lado de
  tierra, *antes* del cable: si el cable se daña en el agua, el corte pasa
  arriba.
]

#cuidado[
  En clase, a la pregunta de si un pendrive con un programa precargado
  sería una «interfaz con el humano», la respuesta fue que no: *es una
  conexión de datos entre dos recuadros*, el pendrive y el sistema. Y que
  no hace falta dibujar a la persona: el ROV de la clase muestra al
  operador, pero un diagrama pensado «en este momento estático», con el
  pendrive conectado, no lo necesita. Moraleja general: una interfaz se
  dibuja por *lo que fluye* (datos, energía, señal), no por *quién la
  enchufó*.
]

== El mismo sistema, con más o menos zoom

Las diapositivas 82 a 88 muestran otros equipos de ROV, cada uno
dibujado a su manera. Comparadas, enseñan algo que ninguna dice: *el
nivel de detalle es una decisión*.

- La 82 es un diagrama de interconexión de un equipo universitario: una
  línea punteada horizontal separa *superficie* de *ROV*, y debajo, el tubo
  de electrónica y el exterior del vehículo.
- La 83 es casi pura arquitectura: dos grandes cajas —sistema de control de
  superficie y sistema de control de a bordo— con sus módulos adentro y un
  solo vínculo de telemetría entre las dos.
- La 84 es un diagrama de integración de sistema, con cada cable: un
  extremo útil para el que arma el vehículo, un exceso para el que lo
  quiere entender.
- La 85 rotula *cada conexión con su tipo de interfaz*: el sensor de
  profundidad entra por tensión analógica, los de fugas por E/S digital,
  los acelerómetros y giróscopos por SPI, los propulsores salen por PWM y la
  superficie se conecta por ethernet.
- La 86 es el diagrama funcional *del software*: tareas con prioridades,
  colas entre ellas, la recepción de órdenes y la transmisión de datos.
- La 88 es un «mapa de hardware» con los sensores y los actuadores
  agrupados, y la 89, las *velocidades de comunicación* de cada vínculo
  (de 10 a 75 Hz según el enlace).

#posta[
  La 85 es la que más se parece a lo que tenés que entregar en una Pre-Fase
  A o una Fase A: pocos bloques, cada flecha con *qué* pasa por ella. La
  84 es lo que va a existir en la Fase C, cuando haya cables de verdad.
  Si en el trabajo práctico dibujás la 84, no demostraste más: demostraste
  que no sabés en qué fase estás.
]

== Especificaciones con su propósito

#figure(
  placement: auto,
  image("../figuras/c08-p087.png", width: 80%),
  caption: [Las especificaciones de un ROV sumergible, cada una con su propósito en la columna de la derecha (diapositiva 87).],
)

La diapositiva 87 es una tabla de especificaciones de un ROV de
investigación: tamaño (1,5 × 1 × 1 m), masa (140 kg), estabilidad (pasiva
en rolido y cabeceo), propulsión (propulsores eléctricos de 300 N por
eje), instrumentación de posición en seis grados de libertad a 5 Hz como
mínimo, computadora reprogramable a profundidad, video, brazo manipulador,
puerto de carga útil genérico y un umbilical de 10 kVA de potencia con
telemetría de datos y video en tiempo real.

#deduccion("la tercera columna es la rationale")[
  Cada fila tiene una tercera columna, «_Purpose_»: el *para qué* de la
  especificación («facilidad de manejo y despliegue», «investigación en
  navegación, dinámica y control»). Es la
  #t[rationale (de un requerimiento)] del módulo
  #M("escribir-buenos-requerimientos") puesta en la misma tabla. Una especificación sin su propósito no se puede
  discutir: nadie sabe si 140 kg es un capricho o un límite.
]

== El ambiente manda: la luz bajo el agua

La diapositiva 92 muestra cómo penetra la luz en el agua: el rojo
desaparece en los primeros metros y a 37,5 m (unos 125 pies) sólo queda
azul. Para un ROV con cámara es un requerimiento ambiental de manual:
el ambiente define si hacen falta luces propias y de qué color ve la
cámara.

#posta[
  Cambiá «agua» por «órbita baja» y es la sección 3 del trabajo práctico,
  *ambiente de misión*: radiación, vacío, ciclos térmicos de cada órbita,
  oxígeno atómico, basura espacial. El ambiente no es un capítulo de
  decoración: es una lista de requerimientos ambientales esperando a ser
  escritos.
]

== Un satélite en el piso: el NOAA-N′

#figure(
  placement: auto,
  image("../figuras/c08-p094.jpg", width: 75%),
  caption: [El NOAA-N′ después de caerse del carro de volteo, en la sala de integración (diapositiva 94).],
)

La clase 8 cierra con un caso real #diapo(8, 93) #diapo(8, 97). Mientras
el satélite meteorológico NOAA-N′ se pasaba de vertical a horizontal sobre
un *carro de volteo* (_turn over cart_), se resbaló del soporte y cayó:
un satélite de 18 pies, desde unos 3 pies de altura. Faltaban *24 bulones*
del soporte del carro. La cátedra le pegó a la foto un Homero Simpson con
cara de «¿yo?»; la investigación, menos graciosa, encontró a los
culpables sin necesidad de dibujos animados.

Hubo *dos errores*, y la lámina los separa:

+ técnicos de *otro programa* que usaba el mismo tipo de carro le sacaron
  los 24 bulones al carro del NOAA días antes, *sin documentarlo*;
+ el equipo del NOAA *no siguió el procedimiento de verificar la
  configuración* del carro antes de usarlo, porque lo había usado pocos
  días antes.

El impacto: daño severo por el golpe y la vibración, retrabajo y
reensayos significativos, sobre un satélite que estaba planificado para
lanzarse en 2008. La acción correctiva empezó por la seguridad —que no
rodara, descargar las baterías, despresurizar la propulsión—, siguió con
el satélite bajo custodia, los registros secuestrados y el personal
entrevistado, y recién después pasó a evaluar el daño.

#deduccion("por qué hicieron falta los dos errores, y por qué eso es una buena noticia")[
  Cualquiera de los dos solo no tiraba el satélite: con los bulones
  documentados, el equipo se habría enterado; con la configuración
  verificada, los habría encontrado. El accidente necesitó que fallaran
  *dos barreras independientes a la vez*. Esa es la buena noticia, y la
  idea de fondo de la gestión de configuración y de los procedimientos de
  verificación: no hace falta que nadie se equivoque nunca, alcanza con
  poner barreras que tengan que fallar juntas para que pase algo. Y el segundo error tiene la excusa más peligrosa de la
  ingeniería: *«si lo usamos hace unos días, está igual»*. La
  configuración de algo no se recuerda: se verifica.
]

#cuidado[
  Fijate la secuencia de la acción correctiva: primero *asegurar* (que el
  satélite no ruede, que las baterías y la propulsión no sumen otro
  accidente), después *preservar la evidencia* (custodia, registros,
  entrevistas) y recién después *evaluar el daño*. El impulso natural es
  el orden inverso —correr a ver qué se rompió— y es el que arruina la
  investigación.
]
