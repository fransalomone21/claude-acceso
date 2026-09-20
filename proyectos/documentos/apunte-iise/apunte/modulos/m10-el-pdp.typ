#import "../plantilla.typ": *

#modulo(
  "El PDP: de cuatro empresas distintas a un marco genérico",
  [Definir el #t[PDP]; comparar cuatro procesos reales (NASA, una empresa de
   helicópteros, una de cámaras, Agile) para separar diferencias
   superficiales de sustanciales; ubicar el #t[dominio principal del
   arquitecto] dentro del PDP genérico; y leer las tres vistas anidadas del
   PDP global, con las #t[las preguntas W canónicas] en el centro.],
  clave: "el-pdp",
)

#lectura[
  Clase 3, diapositivas 18 a 39.
]

== Qué es un PDP, y para qué sirve

#definicion("PDP — proceso de desarrollo de producto")[
  El *marco empresarial* que captura la metodología de desarrollo de
  productos —terminología, fases, hitos, cronogramas, listas de tareas y
  *resultados*— con la intención de capturar la sabiduría de los esfuerzos de
  desarrollo anteriores. #diapo(3, 18)
]

#cuidado[
  *⚠ La corrección del parcialito 3, otra vez:* «resultados de procesos ≠
  tareas». Definir el PDP como «una lista de tareas, cronogramas e hitos» es
  la respuesta que se corrige — el PDP es el *marco* que organiza esas cosas
  y define *qué resultado* produce cada fase, no la lista en sí.
]

Una de las principales ventajas del PDP es que reduce la ambigüedad
*definiendo tareas y responsabilidades* #diapo(3, 18).

#cuidado[
  Es tentador pensar que el PDP resuelve, paso a paso, toda la ambigüedad
  ascendente, dejando al arquitecto con una comprensión clara de estrategia,
  mercado, necesidades y tecnología. *Eso es sólo parcialmente cierto*: el
  PDP puede *perjudicar* al arquitecto si supone más certeza de la que
  realmente hay #diapo(3, 18).
]

== Cuatro PDP reales, y qué tienen en común

La cátedra compara cuatro procesos para separar lo *superficial* de lo
*sustancial* — la pregunta que hay que hacerse de cada diferencia es si
alguien la diseñó a propósito para reflejar su sector, o si es sólo estilo
#diapo(3, 26).

=== NASA: lineal, con compuertas formales

El PDP de la NASA procede *linealmente* de la factibilidad a las operaciones,
sin iteración explícita, y pone un énfasis fuerte en la *trazabilidad de
requerimientos* y en revisiones formales #diapo(3, 20). Tiene sentido para
sus productos: sistemas espaciales costosos y de bajo volumen, que *no se
pueden probar in situ* antes de operar ni reparar fácilmente, con un alto
costo percibido por el fracaso público #diapo(3, 20).

#definicion("compuerta de control (control gate)")[
  El punto de decisión que habilita el *cambio de fase*. #diapo(3, 21)
]

#figure(
  table(
    columns: (0.8fr, 1.9fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 6pt,
    table.header([*Compuerta*], [*Qué habilita*]),
    [SRR — _System Requirements Review_], [Pasar de la definición de requerimientos al diseño preliminar.],
    [PDR — _Preliminary Design Review_], [Pasar del diseño preliminar al diseño de detalle.],
    [CDR — _Critical Design Review_], [Pasar del diseño de detalle a la producción y certificación.],
    [SAR — _System Acceptance Review_], [Aceptar el sistema producido.],
    [FRR — _Flight Readiness Review_], [Habilitar el despliegue / vuelo.],
    [EMR — _End of Mission Review_], [Cerrar la operación.],
  ),
  caption: [Las compuertas de control del PDP de la NASA, entre fases del ciclo de vida #diapo(3, 21).],
)

#cuidado[
  *No confundir una compuerta de control con las revisiones técnicas ni con
  los KDP de NASA* (que se desarrollan en la unidad 5): acá lo que importa es
  que cada compuerta es un *punto de decisión*, no un trámite — habilita o no
  el paso a la fase siguiente.
]

=== Helicopter Inc.: con bucles de iteración explícitos

#deduccion("qué agrega el ejemplo de Helicopter Inc.")[
  El PDP de esta empresa (nombre enmascarado por la cátedra) fabrica
  helicópteros para uso militar y civil, en un mercado muy regulado. A
  diferencia del de la NASA, sus bucles de iteración están *destacados
  explícitamente* en el diagrama #diapo(3, 20): reconoce que incluso en un
  entorno aeroespacial similar al de la NASA, la iteración es *inevitable* y
  no está reñida con un proceso sincronizado por fases. El proceso se
  organiza alrededor de un evento regulatorio —la certificación de la
  FAA— pero esa certificación es, en última instancia, un instrumento de lo
  que más importa: las *ventas*.
]

#figure(
  image("../figuras/c03-p022.png", width: 92%),
  caption: [Figura 9.2 de la cátedra: el PDP de Helicopter Inc., con las cuatro fases genéricas superpuestas en rojo y las compuertas PDR, CDR y la certificación FAA marcando el paso entre ellas #diapo(3, 20).],
)

=== Camera Co.: la fabricación antes que el desarrollo

En Camera Co. (cámaras y películas), el proceso de desarrollo de fabricación
*precede* al desarrollo del producto — es una industria basada en procesos
#diapo(3, 25). Muestra explícitamente estrategia ascendente, voz del cliente
e I+D como parte de la fase de concepción, con la voz del cliente
*precediendo* a la I+D — lo que abre la pregunta de si eso refleja el proceso
real o es un intento de influir en una compañía tradicionalmente centrada en
tecnología #diapo(3, 25).

=== Agile: iterativo e incremental

Agile enfatiza el desarrollo iterativo e incremental: equipos colaborativos
evolucionan requerimientos y soluciones interactuando, priorizando el código
real sobre documentación, negociación y planificación extensas
#diapo(3, 25). Nació en la creación rápida de prototipos de software, y se
usó después como vocablo para agitar procesos de desarrollo en industrias más
intensivas en capital.

#posta[
  La comparación entre Waterfall y Agile deja ver la diferencia de raíz:
  Waterfall recorre *Plan → Diseño → Build → Test → Corrección → Test →
  Deploy* una sola vez, de punta a punta; Agile repite un ciclo corto
  *Analizar → Planificar → (Diseñar–Construir–Probar) → Desplegar* varias
  veces, entregando en cada vuelta. Ninguno de los dos es "el PDP" — son dos
  formas distintas de recorrer las mismas cuatro fases genéricas que siguen
  abajo.
]

=== Qué es superficial y qué es sustancial

Diferencias como el *número de fases* o cómo se representa la voz del
cliente son, en general, superficiales. Lo que puede ser sustancial: la
existencia y el grado de formalidad de las revisiones, cuándo se compromete
capital, los requerimientos de conformidad regulatoria, el grado de
iteración, la cantidad de prototipos, el esfuerzo de validación, y cuándo
entra el proveedor al proceso #diapo(3, 26) #diapo(3, 28).

== El PDP genérico

#clave[
  Las cuatro actividades comunes a casi todos los PDP completos —y la base
  del PDP genérico de la cátedra— son *Concebir* (determinar qué se
  construirá, según necesidades de mercado y tecnología disponible),
  *Diseñar* (la representación que define qué se va a implementar),
  *Implementar* (convertir el diseño en realidad — código, fabricación o
  integración, deliberadamente las tres a la vez) y *Operar* (operar el
  sistema para entregar valor, terminando en el retiro). #diapo(3, 23)
  #diapo(3, 29)
]

#deduccion("por qué el PDP genérico se parece tanto al CDIO")[
  Concebir–Diseñar–Implementar–Operar es, letra por letra, la misma
  secuencia que #t[CDIO] de la unidad 1 — *Concebir, Diseñar, Implementar,
  Operar*. No es coincidencia: la cátedra lo señala explícitamente
  #diapo(3, 23), y son la misma estructura vista desde dos lugares distintos.
  CDIO nació como metodología de *enseñanza* de ingeniería, corrigiendo el
  desbalance de un currículum sobre-especializado; el PDP genérico es la
  misma secuencia aplicada como marco de *proceso* para desarrollar un
  producto real. Reconocer la analogía ahorra memorizar dos listas donde hay
  una sola idea.
]

Estas cuatro no deben leerse como *etapas secuenciales*: representaciones
lineales del proceso de diseño tienen fallas profundas — no representan
iteración ni retroalimentación, suponen un flujo lineal de tiempo, y pueden
enmascarar la inmadurez de un diseño cuando se fuerzan los criterios de una
compuerta #diapo(3, 29).

#cuidado[
  El PDP genérico también marca el *dominio principal del arquitecto*: suele
  involucrarse después de algunas actividades ascendentes (decisiones de
  estrategia funcional), y para tener éxito debe participar *plenamente* en
  las actividades de ese dominio #diapo(3, 29). Uno de sus roles es mover
  información *hacia abajo* (de vuelta a la fase de arquitectura) — mover
  restricciones hacia arriba es fácil; lo difícil es saber qué información
  diferencia significativamente entre arquitecturas #diapo(3, 31).
]

== El PDP global: tres vistas anidadas

Para comparar distintos PDP entre sí, la cátedra construye un *PDP global*
con tres vistas cada vez más amplias, centradas en identificar influencias
ascendentes y descendentes de la arquitectura.

=== Vista 1 — la arquitectura del producto y las preguntas W

#figure(
  image("../figuras/c03-p033.png", width: 92%),
  caption: [Figura 9.6 de la cátedra: el marco holístico de los siete atributos del producto/sistema. Los dos nodos sombreados —función y forma— son la arquitectura, en el centro #diapo(3, 33).],
)

#definicion("las preguntas W canónicas")[
  Los siete atributos del producto o sistema: *por qué* (necesidad/
  oportunidad), *qué* (metas/desempeño), *cómo* (función/interacción),
  *dónde* (forma/estructura), *cuándo* (comportamiento/dinámica), *quién*
  (operador/usuario) y *cuánto* (costo/gasto). #diapo(3, 32)
]

#clave[
  La Figura 9.6 hace visible algo que el resto de la unidad 2 dejaba
  implícito: *la arquitectura es, literalmente, el centro de las siete
  preguntas.* De las siete, #t[función] responde *cómo* y #t[forma] responde
  *dónde* — porque la forma existe y por lo tanto tiene ubicación
  #diapo(3, 32) — y son los dos nodos resaltados en el centro del diagrama.
  Las interacciones son *bidireccionales*: el flujo de izquierda a derecha
  no está implícito, aunque el dibujo se lea así.
]

#deduccion("de dónde salen las preguntas W")[
  Comparten un ancestro lingüístico común, la raíz indoeuropea *quo*: el
  francés usa "qu" (qui, quoi, quand...), el hindi usa "k" (kab, kya,
  kyon...), y el retórico griego antiguo Hermágoras ya definía siete
  circunstancias equivalentes — quis, quid, quando, ubi, cur, quem ad modum,
  quibus adminiculis #diapo(3, 32). La cátedra lo usa como evidencia de que
  la lista no es una convención de este libro: es una estructura recurrente
  para pensar cualquier cosa de manera holística.
]

=== Vista 2 — diseño e implementación en paralelo

La segunda vista agrega las actividades de *diseño* e *implementación*, cada
una con su propia instanciación de las preguntas W #diapo(3, 34). El proceso
de diseño tiene sus propias formas —herramientas de diseño— que limitan la
forma del sistema disponible: un dibujante con una regla fija produce
representaciones distintas de uno con una curva francesa. Y una política de
la empresa —por ejemplo, dividir el costo de diseño (NRE) por igual entre
vehículos de una misma plataforma— no aparece en ninguna revisión técnica,
pero *sí* pertenece al PDP genérico porque impacta en la capacidad de una
variante de entregar valor #diapo(3, 34).

#posta[
  Cualquier PDP o método nuevo de diseño se puede evaluar críticamente
  comparándolo contra las 21 preguntas implícitas en esta vista (7 W × 3
  actividades). Pocos métodos responden las 21: el propósito no es que un
  marco las conteste todas, sino entender *en qué áreas* es más sólido
  #diapo(3, 34).
]

=== Vista 3 — el PDP en el contexto de la empresa

La tercera vista ubica al PDP dentro de las actividades generales de la
empresa: I+D y funciones corporativas son mayormente ascendentes; relaciones
públicas, ventas y distribución son mayormente descendentes; habilidades
humanas, sistemas de información y herramientas de ingeniería atraviesan
todo el diagrama #diapo(3, 35). Al margen de la empresa aparecen actores y
atributos externos — disponibilidad de capital, competencia, impacto social.

#clave[
  El propósito de esta vista es recordarle al arquitecto que *entender el
  contenido del PDP no alcanza*: hace falta entender también el contexto
  empresarial más amplio en el que ese PDP corre #diapo(3, 35).
]

== El principio de las tensiones de la práctica moderna

#definicion("principio de las tensiones de la práctica moderna")[
  El proceso moderno de desarrollo de producto —con concurrencia, equipos
  distribuidos y proveedores comprometidos desde temprano— pone *aún más
  énfasis* en tener una buena arquitectura. Tres consecuencias: acelerar el
  desarrollo con concurrencia aumenta la importancia de las decisiones
  conceptuales iniciales; empoderar la toma de decisiones a nivel bajo y usar
  equipos distribuidos aumenta la importancia de una guía de diseño de alto
  nivel bien coordinada; e involucrar proveedores temprano aumenta la
  importancia de tener un concepto y una línea de base arquitectónica claros
  — los proveedores pueden llegar a *definir o desafiar* la descomposición.
  #diapo(3, 39)
]

== Resumen

#posta[
  Aunque los cuatro PDP reales de este módulo parecen distintos —NASA
  lineal y formal, Helicopter Inc. con bucles explícitos, Camera Co.
  invirtiendo fabricación y desarrollo, Agile iterando en ciclos cortos—
  todos comparten las mismas cuatro actividades genéricas: *Concebir,
  Diseñar, Implementar, Operar*. La habilidad que se pide al arquitecto no es
  memorizar un PDP: es poder *discernir* qué segmento de cualquier PDP nuevo
  está vinculado a su rol, y evaluar métodos como Lean, Agile o Six Sigma sin
  adoptarlos más allá del contexto para el que fueron creados #diapo(3, 40).
]
