#import "../plantilla.typ": *

#modulo(
  "El ciclo de vida de un proyecto: fases de NASA y el diagrama en V",
  [Enumerar las siete fases del ciclo de vida de NASA y ubicar ahí las
   revisiones técnicas y los KDP; leer el diagrama en V desde sus tres
   perspectivas (cliente, ingeniería de sistemas, contratista); y distinguir
   qué lado del diagrama es iterativo y cuál es serial.],
  clave: "ciclo-de-vida-y-diagrama-en-v",
)

#lectura[
  Clase 5, diapositivas 1 a 9.
]

== Por qué esta unidad empieza por acá

#posta[
  La cátedra abre la unidad con una pregunta incómoda a propósito: *¿cómo
  empezamos a diseñar algo si no sabemos exactamente qué se necesita?* Y la
  cita de Gentry Lee que la acompaña es la respuesta completa: *"nunca ha
  habido un proyecto en la historia que cualquier conjunto de requerimientos
  haya cubierto el significado real de aquello que necesita ser hecho"* — los
  requerimientos son aproximaciones hechas con lenguaje, y se interpretan.
  Esta unidad no resuelve esa tensión: da el vocabulario y el proceso para
  manejarla lo mejor posible.
]

== Las siete fases del ciclo de vida de NASA

#definicion("ciclo de vida de NASA")[
  Las siete fases con las que NASA organiza un proyecto, de la concepción al
  cierre: *Pre-Fase A* (Estudio Conceptual), *Fase A* (Desarrollo de Concepto
  y Tecnología), *Fase B* (Diseño Preliminar y Completar Tecnología), *Fase
  C* (Diseño Final y Fabricación), *Fase D* (AIT y Lanzamiento), *Fase E*
  (Operaciones y Sostenimiento) y *Fase F* (Cierre).
]

#cuidado[
  *El error que se cobra en esta pregunta es correr las dos últimas.* La
  *Fase E* es la que opera y mantiene el sistema —es la más larga de todas, y
  la única que produce el resultado por el que se construyó—; la *Fase F* no
  opera nada: desmantela, desorbita o dispone del sistema, y cierra los
  archivos del proyecto. Decir que la Fase F es «operación y mantenimiento»
  deja al proyecto sin cierre y a la operación contada dos veces.
]

#clave[
  La cátedra agrupa estas siete fases en tres bloques: *Formulación* llega
  hasta el final de la Fase B, *Aprobación* es el punto de decisión entre B
  y C, e *Implementación* cubre las fases C, D, E y F. La clase 6 lo
  confirma con un diagrama que marca el corte sobre el eje de #t[baseline]:
  Formulación termina con el *Allocated Baseline* (al cerrar la Fase B), e
  Implementación arranca con el *Product Baseline* (al cerrar la Fase C).
]

Cada fase termina en una *revisión técnica* —de pares, de subsistema, de
sistema— y en un *KDP* (Key Decision Point) que autoriza pasar a la
siguiente. Entre las siglas que aparecen: *MCR* (Mission Conceptual Review),
*SRR* (System Requirements Review), *MDR* (Mission Design Review), *PDR*
(Preliminary Design Review), *CDR* (Critical Design Review), *TRR* (Test
Readiness Review), *ORR* (Operational Readiness Review) y *FRR* (Flight
Readiness Review).

#clave[
  Esto es la misma idea que la #t[compuerta de control] de la unidad 3, ahora
  con nombre y sigla propios para cada punto de decisión del ciclo de vida
  de NASA. Una compuerta de control es el concepto general; un KDP es la
  compuerta de control *de NASA*, entre dos fases específicas.
]

== El ciclo de vida en clave CDIO

La misma secuencia de siete fases se puede leer con el #t[CDIO] de la unidad
1: *Imaginar* (necesidad, estrategia, plan de negocio) → *Diseñar* (metas,
funciones, conceptos, arquitectura, requerimientos, flujo descendente de
requerimientos) → *Desarrollar* (implementación de elementos, ensayo,
integración, refinamiento, certificación) → *Desplegar* (entrega,
operaciones, logística, mantenimiento, retiro).

#deduccion("otra vez el mismo patrón, con más detalle en el medio")[
  El bloque de *Diseñar* del CDIO es, acá, donde vive todo el contenido nuevo
  de esta unidad: *definición de requerimientos*, *desarrollo de modelos*,
  *flujo descendente de requerimientos*, *descomposición en detalles*,
  *interfaces* y *metas de verificación*. El #t[CDIO detallado] de la unidad
  4 (Necesitar, Requerir, Descomponer, Diseñar…) ya había anticipado esta
  apertura; acá se ve el contenido que llena esos pasos.
]

== El diagrama en V

#definicion("diagrama en V")[
  El modelo del ciclo de vida que dibuja, en el lado *descendente*
  (izquierdo), la descomposición desde el concepto de operación hasta el
  diseño de detalle, y en el lado *ascendente* (derecho), la verificación
  correspondiente a cada nivel —unidad, subsistema, sistema— en simetría con
  su contraparte de la izquierda.
]

#figure(
  image("../figuras/c05-p007.png", width: 97%),
  caption: [El diagrama en V tradicional, con lo que ninguna tabla conserva: la *simetría*. Cada caja de la izquierda tiene enfrente, a la misma altura, la que la verifica, y la línea punteada roja que las une es el plan de verificación correspondiente — escrito al bajar, ejecutado al subir. Abajo, las dos leyendas que explican por qué el V no es simétrico en el tiempo: *altamente iterativo* a la izquierda, *principalmente serial* a la derecha #diapo(5, 7).],
)

#figure(
  table(
    columns: (1.3fr, 2fr, 2fr),
    align: (left, left, left),
    stroke: 0.4pt + luma(180),
    [*Perspectiva*], [*Lado izquierdo (bajando)*], [*Lado derecho (subiendo)*],
    [Cliente / usuario], [Estudios de factibilidad, exploración de conceptos], [Validación del sistema],
    [Ingeniería de sistemas], [Concepto de operación, requerimientos de sistema, diseño de alto nivel], [Verificación de sistema y despliegue, verificación de subsistema],
    [Contratista], [Diseño de detalle], [Verificación de unidad (S/W y H/W), implementación en campo],
  ),
  caption: [Las tres perspectivas del diagrama en V, y qué hace cada una a cada lado del vértice (diapositivas 7 y 8).],
)

#clave[
  El vértice del diagrama es la *implementación*: ahí termina la
  descomposición de requerimientos y arranca la verificación. Cada nivel de
  descomposición del lado izquierdo tiene su *plan de verificación* propio
  del lado derecho —plan de verificación del sistema, plan de verificación
  del subsistema, plan de ensayos de unidad— generado *antes* de llegar al
  vértice, no después.
]

#cuidado[
  *El lado izquierdo es altamente iterativo; el lado derecho, una vez que
  arranca la implementación, es principalmente serial.* Cambiar de idea
  sobre un concepto en la exploración temprana es barato y esperable; una
  vez cruzado el vértice, cada paso de verificación depende de que el
  anterior haya cerrado — es el mismo argumento del costo de cambiar tarde
  que ya apareció con el rover marciano de la unidad 4.
]

== El mismo diagrama, aplicado a software

El desarrollo de software en el área espacial usa una versión más granular
del mismo diagrama en V: de los *Requisitos de Usuario* (URD) se baja a // lexico-ok: nombre propio del documento estándar (URD), no eleccion de palabra de la catedra
*Requisitos de Software* (SRD), de ahí al *Diseño de Arquitectura* (ADD) y // lexico-ok: nombre propio del documento estandar (SRD)
al *Diseño de Detalle* (DDD), hasta el *Código*; y se sube por *Ensayos
Unitarios*, *Ensayos de Integración*, *Ensayos del Software* y *Ensayos de
Aceptación* de hardware y software juntos.

#posta[
  Cada ensayo tiene su sigla de plan asociada (*SVVP*: Software Verification
  and Validation Plan, con sufijos *UT*, *IT*, *ST*, *AT* según el nivel). No
  hace falta memorizar cada sigla — lo que importa es reconocer que es *el
  mismo diagrama en V de arriba*, con más escalones, porque el software se
  integra en capas más finas que el hardware.
]
