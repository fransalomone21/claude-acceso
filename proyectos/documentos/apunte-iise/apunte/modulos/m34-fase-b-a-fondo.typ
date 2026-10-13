#import "../plantilla.typ": *

#modulo(
  "Fase B a fondo: el diseño preliminar y la tecnología lista",
  [Explicar qué produce la Fase B y por qué es la última de la
   Formulación; seguir el caso del TESS para ver qué significa «terminar
   de madurar la tecnología» y por qué cuesta plata antes de construir;
   decidir qué se hace y qué se compra; enumerar qué revisa la PDR y qué
   pregunta la revisión de confirmación; y leer la matriz de funciones de la
   ingeniería de sistemas con la columna de la Fase B marcada.],
  clave: "fase-b-a-fondo",
)

#lectura[
  Clase 9, diapositivas 9 a 19 y 28 a 34.
]

== Dónde está la Fase B, y qué la cierra

La Fase B —*Diseño Preliminar y Completar la Tecnología*— es *la última de
la Formulación* #diapo(9, 11). Después de ella viene el punto de decisión
de la Aprobación y, del otro lado, la Implementación (módulo
#M("ciclo-de-vida-y-diagrama-en-v")). Es la última oportunidad de cambiar
algo grande antes de que se empiece a cortar metal.

#clave[
  La Fase B hace cuatro cosas #diapo(9, 11):
  + *baja los requerimientos* de alto nivel —fijados en la SRR— a
    requerimientos detallados, consistentes con los de arriba, en un *árbol
    trazable*;
  + establece un *diseño preliminar*, un diseño base capaz de cumplir los
    requerimientos de sistema;
  + *completa la maduración de las tecnologías*, para que todas estén
    listas cuando arranque la Implementación;
  + completa los planes de verificación y validación y desarrolla los
    *planes detallados de implementación*, con los costos y la
    planificación actualizados.

  Al terminar, la idea es tener «un buen plan para la Fase C y D»
  #diapo(9, 12).
]

Su propósito, en la versión de las puertas de control #diapo(9, 31):
definir el proyecto con el suficiente detalle para establecer un
*baseline inicial* capaz de cumplir las necesidades de la misión. Eso
incluye refinar el ConOps, *alojar las funciones y los recursos* (por
ejemplo, los márgenes de masa), seguir refinando los requerimientos y
*definir su flujo hasta el nivel de caja*, *desarrollar la matriz de
verificación*, establecer la solución de diseño y demostrar que se
completaron los desarrollos tecnológicos.

#cuidado[
  La diapositiva de las siglas del ciclo de vida #diapo(9, 10) trae dos
  errores que no conviene copiar: llama a la *TRR* «Tech. Readiness
  Review» —es la revisión de alistamiento de los *ensayos*, _Test
  Readiness Review_, como dice el módulo
  #M("ciclo-de-vida-y-diagrama-en-v")— y define la *PLAR* con el mismo
  nombre que la ORR («Operational Readiness Review»), cuando en NASA es la
  revisión de evaluación posterior al lanzamiento (_Post-Launch Assessment
  Review_). La DR aparece una vez como _Decommissioning Review_ y otra
  como _Disposal Review_ #diapo(9, 33): es la del cierre, en la Fase F.
]

== El TESS: madurar la tecnología cuesta plata, y antes

El ejemplo de la clase es el TESS, el satélite de NASA que busca planetas
fuera del sistema solar mirando cómo baja el brillo de una estrella cuando
un planeta le pasa por delante #diapo(9, 13). Es un satélite mediano, con
*4 años de desarrollo* y un ciclo de vida total de *10 a 15 años*
#diapo(9, 12). Su corazón son *cuatro cámaras* idénticas, y en la Fase B
hay que desarrollarlas: la óptica y los detectores CCD.

#figure(
  placement: auto,
  image("../figuras/c09-p016.png", width: 62%),
  caption: [Una de las cuatro cámaras del TESS: el conjunto de siete lentes, el mosaico de cuatro CCD y la electrónica del plano focal (diapositiva 16).],
)

Los números de la lámina del observatorio #diapo(9, 17): cada cámara cubre
un campo de 24° × 24°, con una pupila de 100 mm, siete elementos ópticos,
una banda de 600 a 1000 nm y 16,8 megapíxeles; la plataforma es un modelo
de catálogo de un fabricante (la LEOStar-2 de Orbital ATK), estabilizada en
tres ejes, con 400 W de panel solar,
propulsión monopropelente y bajada de datos de ciencia en banda Ka a 100
Mbps.

#deduccion("por qué el proyecto gasta en las cámaras antes de tener satélite")[
  La lámina lo dice en una línea: «debemos gastar dinero antes de construir
  el satélite para hacer madurar las tecnologías» #diapo(9, 17). Hay que
  saber si la óptica y los CCD *soportan las vibraciones del lanzador y las
  temperaturas del ambiente espacial*, y eso se sabe ensayándolos, no
  calculándolos. Si se descubre en la Fase D, con el satélite armado, que
  una lente se despega con la vibración, el arreglo cuesta el rediseño de
  la cámara *más* desarmar el satélite *más* el atraso del lanzamiento. Es
  la curva del costo de cambiar tarde que ya apareció con el rover marciano
  de la unidad 4: la Fase B compra riesgo barato.
]

#posta[
  Lo que la Fase B produce no es «un satélite a medio hacer»: es *menos
  incertidumbre*. El jefe de proyecto del TESS no llega a la PDR con la
  cámara armada para mostrarla; llega con la cámara *ensayada* y con la
  prueba de que va a sobrevivir. La diferencia entre las dos cosas es la
  materia entera.
]

== El umbral: TRL 6, y hacer o comprar

La medida de «tecnología lista» es la escala
#t[TRL — nivel de madurez tecnológica] del módulo #M("trl-irl-srl"). La cátedra fija la marca en
*TRL 6*: la tecnología está lista para soportar el ambiente al que va a
estar expuesta, asegurado con ensayos en tierra o con equipos que ya tienen
historia en el espacio #diapo(9, 28).

#cuidado[
  Las notas de la presentación dicen que «TRL menor a 6 no pasa a la Fase
  C». La lámina dice algo más preciso y menos tajante: que en la Fase B hay
  que *completar* la maduración, y que TRL 6 es el nivel en el que la
  tecnología demostró que soporta su ambiente. La regla práctica es la
  misma —llegar a la Implementación con todo en TRL 6 o más—, pero lo que
  se rinde es el porqué: es el primer nivel en el que el prototipo se
  probó *en un ambiente relevante*, que es lo que la Fase C necesita
  suponer para diseñar el detalle.
]

En la misma fase se decide *qué se hace y qué se compra* #diapo(9, 28):
algunos componentes se fabrican en casa y otros se compran a distintos
fabricantes, y esa decisión se vuelve a tomar con la información nueva. Y
se resuelven los trade-offs que quedaron abiertos: en el TESS, por ejemplo,
el blindaje que protege a las cámaras de la luz y el calor del Sol —¿un
diseño más alto u otra forma de blindaje?—. «La Fase B es para resolver
todos estos problemas, tenemos que optimizar»: es tiempo de grandes
estudios de análisis y de maduración, para ir a la implementación «sin
grandes dificultades tecnológicas».

== La PDR: la revisión técnica de la Fase B

#definicion("PDR — Revisión Preliminar del Diseño")[
  La revisión técnica primaria de la Fase B. Revisión multidisciplinaria
  que asegura que el sistema puede comenzar el *diseño de detalle* y
  cumplir los requerimientos de desempeño dentro del costo, la
  planificación, el riesgo y las demás restricciones. Revisa
  requerimientos, diseño y operaciones como baseline para el diseño de
  detalle y *establece el Baseline Alojado* #diapo(9, 31) #diapo(9, 34).
]

Antes de la PDR hay una serie de revisiones más chicas, *de pares* y *de
subsistemas*, que dejan ver cómo llega cada parte a la revisión del
sistema #diapo(9, 29). Lo que se espera en la PDR #diapo(9, 29)
#diapo(9, 30):

- los requerimientos detallados, las restricciones y las medidas de
  desempeño son *consistentes con el diseño preliminar* (¿los propulsores
  y las baterías dan lo que se necesita?);
- los requerimientos de alto nivel *bajaron a los niveles detallados*,
  completos y *trazables hasta los objetivos del sistema* —y hasta lo
  definido en la Pre-Fase A—;
- las *interfaces externas e internas* están claramente definidas, a todo
  nivel, entre componentes;
- los requerimientos están en un *nivel aceptable de riesgo*, y los
  revisores evalúan si la tecnología y el diseño están maduros para ir a
  la implementación con ese riesgo, dentro del dinero y la planificación;
- *todas las actividades de maduración tecnológica terminaron con éxito*;
- las *acciones asignadas en la MDR* se revisan: resueltas, se cierran; si
  no, quedan abiertas.

#posta[
  Leela como el examen de la Fase B: cada viñeta es uno de sus productos.
  Trazabilidad completa, interfaces definidas, tecnología madura, riesgo
  aceptable, acciones de la revisión anterior cerradas. Es la misma
  mecánica de la SRR y la MDR del módulo #M("revisiones-de-la-fase-a"),
  con un escalón más de detalle: cada revisión mira para atrás antes de
  mirar para adelante.
]

=== Lo que tiene que mostrar un equipo de ROV en su PDR

La cátedra lo baja al proyecto del curso #diapo(9, 34). Los equipos de ROV
deberán demostrar: el entendimiento de los requerimientos de misión del
ROV; *alojar y derivar* los requerimientos de sistema a subsistemas; la
definición del ConOps del ROV; una visión de conjunto del diseño
preliminar que cumple los requerimientos; los resultados de los estudios
del diseño preliminar; los resultados (o la identificación) del
prototipado y los ensayos necesarios para cerrar el diseño preliminar; el
*presupuesto preliminar* de las fases que siguen; y la *planificación
detallada* del desarrollo.

== La revisión de confirmación

#definicion("revisión de confirmación (NAR)")[
  La revisión *independiente* (_Non-Advocate Review_ o _Confirmation
  Review_) que cierra la Fase B junto con la PDR. Pregunta si los diseños
  de la misión, del _spacecraft_ y de los instrumentos cumplen los
  requerimientos de ciencia y misión; si los procesos de gestión alcanzan
  para desarrollar y operar la misión; y si el costo, el control y la
  planificación indican que estará lista para lanzar *a tiempo y dentro del
  presupuesto* #diapo(9, 31).
]

#deduccion("por qué hace falta una revisión «no abogada» además de la PDR")[
  En la PDR revisan el *diseño* ingenieros que, en general, quieren que el
  proyecto siga. La revisión de confirmación la hace gente *sin interés en
  que el proyecto se apruebe* —eso quiere decir _non-advocate_— y mira al
  proyecto *como empresa*: ¿la plata, la gestión y el calendario cierran?
  Es la última compuerta antes de la Implementación, que es donde el gasto
  se dispara (lo muestra la curva de costos del módulo #M("fase-c-a-fondo")):
  equivocarse ahí es carísimo, y por eso se pide una mirada que no esté
  enamorada del satélite.
]

== El mapa, con la columna de la Fase B marcada

#figure(
  placement: auto,
  image("../figuras/c09-p032.png", width: 82%),
  caption: [La matriz de funciones clave de la ingeniería de sistemas con la columna de la Fase B resaltada (diapositiva 32).],
)

La clase 9 vuelve a mostrar la matriz de funciones de la ingeniería de
sistemas por fase, que el módulo #M("fase-a-a-fondo") leyó entera
#diapo(9, 32). Ahora con la columna de la *Fase B* resaltada en amarillo:
en ella, los objetivos, la arquitectura y el diseño, los requerimientos,
el ambiente de misión y el plan de gestión de la ingeniería de sistemas
pasan a *Completo*; el ConOps se *refina*; la V&V *asigna métodos*; las
interfaces y el presupuesto de recursos técnicos llegan a *Baseline*; el
riesgo se analiza con FMEA, FTA y RBD; y la configuración pasa a gestión
formal.

#cuidado[
  La misma matriz aparece dos veces en la clase, una con la Fase B marcada
  #diapo(9, 32) y otra con la Fase C #diapo(9, 49), y *las dos copias no
  coinciden en la fila de los hitos*: en la primera la SRR está en la
  columna de la Fase A, junto a la MDR; en la segunda, en la de la Fase B,
  junto a la SCR, la PDR y la CR. Ya pasaba con la versión de la clase 7.
  Para el parcial vale lo que la cátedra *explica*: la SRR y la MDR son las
  revisiones de la Fase A (módulo #M("revisiones-de-la-fase-a")), y la
  PDR y la de confirmación, las de la Fase B.
]

Las notas al pie de la matriz #diapo(9, 33) traen dos reglas que valen
oro: los *requerimientos de nivel 1 y los criterios de éxito de la misión*
tienen que estar completos al final de la Fase B; y, para los componentes
de largo plazo de fabricación y los instrumentos que se desarrollan antes
de que exista el proyecto, los *borradores de los ICD* se escriben ya en la
Fase A.
