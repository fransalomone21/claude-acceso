#import "../plantilla.typ": *

#modulo(
  "Fase C a fondo: el diseño final, la fabricación, el CDR y la SIR",
  [Explicar qué hace la Fase C, primera de la Implementación; por qué la
   asignación del lanzador obliga a revisar el diseño; qué significa
   verificar un componente comprado (el ejemplo del propulsor) antes de
   integrar nada; leer la curva de gasto del proyecto; enumerar qué revisa
   el CDR y qué confirma la SIR; y distinguir la verificación de
   componentes de la integración del sistema.],
  clave: "fase-c-a-fondo",
)

#lectura[
  Clase 9, diapositivas 35 a 51.
]

== Entrar a la Implementación

Con la Fase C se cruza la línea: termina la Formulación y empieza la
*Implementación* #diapo(9, 37). Durante la Implementación el diseño se
completa, los componentes se construyen o se compran, el sistema se
integra y se ensaya, y después se opera. La Fase C tiene dos tareas
primarias: el *diseño final* y la *fabricación*. El foco está en completar
el diseño del sistema, construir o comprar el _hardware_ y el _software_
de los componentes, y *verificar que esos componentes cumplen los
requerimientos detallados*.

#clave[
  Su propósito, en la versión de las puertas de control #diapo(9, 50):
  diseñar el sistema —y sus subsistemas, incluidas las operaciones— de
  manera que cumpla sus requerimientos; demostrar que el diseño de detalle
  los cumple y que los planos están completos; *establecer el baseline del
  producto*; y comenzar la fabricación y los ensayos de los componentes de
  vuelo y de los subsistemas. Sus dos revisiones son el *CDR* (planos de
  diseño y planes de ensamble, integración y ensayo) y la *SIR*.
]

Lo que hay que hacer, en la lista de la cátedra #diapo(9, 40): desarrollar
los planes de ensamble, integración y ensayos (#t[AIT / AIV]); comprar o
construir los componentes de todos los subsistemas; *verificar las
capacidades y el desempeño de los componentes contra los requerimientos*;
*verificar sus interfaces contra las interfaces definidas*; preparar los
planes de operaciones y el _checkout_ en el sitio de lanzamiento; y
preparar los planes de las operaciones posteriores al lanzamiento.

== El lanzador llega tarde, y obliga a revisar

Un detalle de la cátedra que pocos libros subrayan: en muchos casos NASA
*no asigna el lanzador hasta que comienza la Implementación*
#diapo(9, 37). Muchos proyectos no lo tienen en cuenta en las primeras
fases y, al llegar acá, se encuentran con sobrecostos, atrasos o
evaluaciones técnicas que no se pueden completar, y con indecisión para
firmar el contrato con la empresa del lanzador.

Una vez establecido el lanzador, hay que revisar el diseño completo del
_spacecraft_: el diseño estructural frente al *ambiente del lanzador*
(vibraciones, acústica) y las interfaces #diapo(9, 38). Cada lanzador
genera su ambiente particular —«su firma»— y tiene sus propias interfaces
con el satélite: hay que *compatibilizar* el uno con el otro.

#deduccion("por qué conviene diseñar para una envolvente y no para un lanzador")[
  Si el lanzador se elige tarde, el satélite diseñado para *uno* en
  particular corre el riesgo de tener que rediseñarse para otro. La salida
  es diseñar desde temprano contra una *envolvente*: las cargas, la
  acústica y el volumen de cofia que cubren a los dos o tres candidatos
  razonables, con margen. Es el mismo mecanismo de la gestión de márgenes
  (módulo #M("que-es-un-requerimiento-y-margenes")) aplicado a una interfaz
  externa cuyo dueño todavía no existe. Y es otra razón para que el
  trabajo práctico, en Pre-Fase A, nombre *candidatos* de lanzador y no
  uno solo.
]

== Verificar componentes antes de integrar: el propulsor

La primera parte de la Fase C se enfoca en comprar o construir todos los
componentes, y en verificar *cada uno* al recibirlo #diapo(9, 38)
#diapo(9, 39). El ejemplo de la cátedra es un propulsor comprado:

- *desempeño y funcionalidad*: ¿es monopropelente o bipropelente, como se
  pidió?, ¿cuánto pesa? —hay que pesarlo—, ¿cuánto empuja? —hay que
  medirlo—;
- *interfaces*: el propulsor tiene una interfaz *eléctrica*, una
  *mecánica* y una *térmica* con el resto del sistema (potencia,
  estructura, control térmico) y se conecta al resto del subsistema de
  propulsión; tiene que cumplir los requerimientos de interfaz.

#cuidado[
  *En esta parte de la Fase C no se está integrando el satélite*
  #diapo(9, 39): se están obteniendo los componentes individuales y
  verificando que son los requeridos, en todo el espectro de los
  requerimientos detallados. «El satélite propiamente dicho vendrá un poco
  después.» Verificar un componente e integrar el sistema son dos
  actividades distintas, en dos momentos distintos, y la SIR es justamente
  la compuerta entre las dos.
]

#figure(
  placement: auto,
  image("../figuras/c09-p043.jpg", width: 60%),
  caption: [El tanque de propelente del Solar Dynamics Observatory durante su ensamble, con las cintas plateadas de los calefactores (diapositiva 43).],
)

Cuando la implementación arranca, todos los componentes tienen que
confluir a la integración *en el orden que establezca el plan de AIT*
#diapo(9, 42). El ejemplo es el tanque de propelente del _Solar Dynamics
Observatory_: se reciben los componentes del subsistema de propulsión y se
juntan con los de estructura y de control térmico —las cintas plateadas
son los calefactores—; se montan con sus tornillos (interfaz mecánica) y
sus conexiones (interfaz eléctrica). Esa unidad se somete a ensayos de
*vibración* (el lanzamiento) y de *enfriamiento y calentamiento* a los
niveles estimados para el espacio, y así se verifican los requerimientos
definidos en las Fases A y B.

== La curva del gasto

#deduccion("por qué la plata se dispara justo acá")[
  La cátedra lo cuenta con la curva de costo del ciclo de vida
  #diapo(9, 41): en la Fase A se gastó un mínimo; en la B, algo más, porque
  hicieron falta expertos y análisis de mayor fidelidad; y con la
  confirmación aprobada, en la Fase C *se ponen las compras* y el gasto
  del presupuesto sube de golpe. Por eso la revisión de confirmación del
  módulo #M("fase-b-a-fondo") es tan seria: es la última compuerta barata.
  Y por eso las compras y la manufactura externas, que llevan tiempos
  largos, tienen que estar en el calendario *lo más temprano posible*.
]

== CDR: la revisión crítica del diseño

#definicion("CDR — Revisión Crítica del Diseño")[
  La revisión técnica primaria de la Fase C. Revisión externa de todo el
  sistema, de los niveles más bajos al más alto: evalúa si el diseño
  detallado cumple los requerimientos *con margen adecuado y riesgo
  aceptable*, si las interfaces y la documentación están lo bastante
  maduras para fabricar, ensamblar, integrar y ensayar, si los planes de
  V&V están completos y si los recursos alcanzan; y revisa que las
  acciones del PDR estén cerradas #diapo(9, 44) #diapo(9, 45).
]

Lo que se espera en el CDR, punto por punto #diapo(9, 44):

- las *acciones asignadas en el PDR*, resueltas;
- el diseño detallado cumple los requerimientos con un *margen adecuado* y
  un nivel de riesgo aceptable;
- las interfaces están suficientemente maduras para la fabricación, el
  ensamble, la integración y los ensayos;
- la documentación del sistema permite proceder con esas actividades;
- los *planes de verificación y validación están completos*;
- existen los recursos técnicos y programáticos para completar el
  desarrollo dentro del presupuesto, la planificación y el riesgo
  asumido;
- los riesgos para el éxito de la misión están identificados y evaluados,
  con planes y recursos para gestionarlos.

Antes del CDR hay revisiones internas *de pares* y *de subsistemas*,
conducidas por los ingenieros de sistemas. Y en el CDR se mira, además, que
el presupuesto de masas y los momentos de inercia sean aceptables *para el
lanzador*, y los temas de seguridad, confiabilidad y calidad
#diapo(9, 45).

#posta[
  «El CDR es una revisión clave en el proyecto. Nos permite decir que
  podemos tomar todos los componentes que están bien definidos y comenzar a
  construir el satélite» #diapo(9, 46). Después del CDR se manda a comprar
  o fabricar *el resto* de los componentes. ¿Y los que tardan años en
  fabricarse? Se pueden comprar *antes* del CDR, como estrategia del
  proyecto, con la aprobación de todos los interesados: es apostar plata a
  que el diseño de esa pieza no va a cambiar.
]

#cuidado[
  Las notas de la presentación de la clase 8 dicen que el CDR es «la
  revisión de entrada a la Fase C». La clase 9 y el ciclo de vida de NASA
  dicen otra cosa, y es lo que vale: el CDR es la revisión técnica primaria
  *de adentro* de la Fase C, y la SIR viene después, todavía en la misma
  fase.
]

== SIR: la revisión de integración del sistema

#definicion("SIR — Revisión de Integración del Sistema")[
  La segunda revisión de la Fase C. Confirma que los planes y
  procedimientos de integración están completos y aprobados, que la
  *verificación de los componentes* dio resultados satisfactorios para
  proceder con la integración, que el flujo de trabajo está documentado,
  que el personal recibió el entrenamiento requerido y que las acciones
  del CDR se cerraron #diapo(9, 48).
]

Después de la SIR empieza el ensamble, la integración y los ensayos *del
sistema* #diapo(9, 48). La cátedra acompaña con videos de integración de
satélites —un satélite de comunicaciones de Airbus, un _timelapse_ de
integración— y recuerda que se hace en una _clean room_, un ambiente muy
limpio y cerrado, a veces con equipos muy pesados #diapo(9, 47).

#deduccion("las revisiones como una cadena, de la Fase A a la C")[
  Juntando lo de los módulos #M("revisiones-de-la-fase-a"),
  #M("fase-b-a-fondo") y este, la cadena queda así: la *SRR* congela los
  requerimientos de sistema; la *MDR* congela el concepto (el baseline
  funcional); la *PDR* congela el diseño preliminar (el baseline alojado) y,
  con la *revisión de confirmación*, autoriza la Implementación; el *CDR*
  congela el diseño de detalle (el baseline del producto) y autoriza
  fabricar; la *SIR* autoriza integrar. Cada una hereda las acciones
  abiertas de la anterior y no se cierra sin resolverlas. Si la escribís
  así en un parcial, con el «qué congela» y el «qué autoriza» al lado de
  cada sigla, no hay pregunta de revisiones que te agarre desprevenido.
]
