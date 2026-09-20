#import "../plantilla.typ": *

#modulo(
  "Por qué fallan los grandes proyectos, y el motor de la IS de NASA",
  [Explicar con el puente de Tacoma y el satélite FIA qué pasa sin
   coordinación de ingeniería de sistemas; enumerar las 17 actividades del
   #t[motor de la ingeniería de sistemas] de NASA en sus seis procesos; y
   listar los #t[atributos del ingeniero de sistemas] según Gentry Lee.],
  clave: "el-motor-de-la-is-nasa",
)

#lectura[
  Clase 4, diapositivas 89 a 124.
]

== Por qué los grandes proyectos espaciales luchan

Los proyectos grandes pelean, todo el tiempo, con la misma tríada: *costos,
planificación y desempeño técnico* — el #t[triángulo de hierro] de la unidad
1, otra vez — sumado a un problema estructural propio de la industria:
*envejecimiento de la fuerza de trabajo* y dificultad para retener personal
con las habilidades necesarias #diapo(4, 89) #diapo(4, 90).

#clave[
  Los sistemas espaciales nuevos hoy traen, todos juntos: desarrollo de
  tecnología nueva *y* uso de tecnología ya existente ("_off the shelf_",
  que parece simple y es difícil de integrar); equipos grandes con muchos
  expertos; muchos proveedores; socios institucionales; más interesados
  observando el proceso; y requerimientos ambiguos desde el arranque
  #diapo(4, 91) #diapo(4, 92). Más riesgo técnico es la consecuencia
  directa de sumar todo esto a la vez — no de cada ingrediente por separado.
]

=== El puente de Tacoma: coordinación técnica sin ingeniería de sistemas

#deduccion("qué pasa cuando cada disciplina trabaja bien pero nadie coordina el todo")[
  El puente de Tacoma se construyó con distintos grupos de *muy buenos*
  ingenieros — estructurales, mecánicos, mucho análisis técnico de cada
  disciplina por separado. Lo que faltó fue coordinación *entre* esas
  disciplinas y el grupo de manufactura: el factor del viento se consideró
  *en segundo orden* #diapo(4, 94). El resultado es el colapso que se ve en
  los videos históricos del puente oscilando hasta destruirse.
]

#cuidado[
  El patrón que se repite: construir un sistema con grupos de subsistemas
  *no coordinados* produce, casi siempre, un sistema *inútil* — falla en las
  interfaces, en el momento de integrar las piezas #diapo(4, 94). Y además
  sale más caro: "ahorrar" en coordinación temprana casi siempre termina en
  *retrabajar interfaces* después, que cuesta más que haberlas coordinado
  desde el principio #diapo(4, 94).
]

=== FIA: el satélite espía que se canceló

*Future Imagery Architecture* (FIA): un satélite de reconocimiento
presupuestado en US\$ 5.000 millones que, después de seis años y
US\$ 4.000 millones gastados, se canceló en 2005 #diapo(4, 98).

#figure(
  table(
    columns: (1.3fr, 1.3fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Fallas técnicas*], [*Fallas de proceso*]),
    [Análisis inadecuados], [Presupuesto no realista],
    [Cambios de diseño tardíos], [Cronograma no realista],
    [Ausencia de estimación de costos realista], [Inversión insuficiente en I+D],
    [Recortes en los ensayos de diseño], [Intromisión de interesados externos / contratista sin experiencia],
  ),
  caption: [Las fallas del FIA, agrupadas en dos familias que se retroalimentan entre sí #diapo(4, 99).],
)

#cuidado[
  La prensa lo resumió en una frase que la cátedra cita textual: *«otro
  factor fue una declinación de los expertos americanos en Ingeniería de
  Sistemas, la ciencia y el arte de dirigir proyectos de ingeniería
  complejos para sopesar riesgos, evaluar la viabilidad, ensayar componentes
  y asegurar que las piezas calzan perfectamente»* #diapo(4, 100). El
  diagnóstico no fue "faltó tecnología": fue *faltó ingeniería de sistemas*.
]

#posta[
  Tacoma y FIA son el mismo argumento del módulo anterior (Hubble), con una
  vuelta de tuerca: ahí una disciplina medía mal; acá, ninguna disciplina
  midió mal — lo que faltó fue alguien viendo el sistema *completo*, con
  autoridad para exigir presupuestos y cronogramas realistas. Es la
  necesidad de la IS, ahora vista desde el fracaso en vez del éxito
  (Saturno V).
]

== El motor de la ingeniería de sistemas de NASA

#definicion("motor de la ingeniería de sistemas")[
  El modelo de NASA con *17 actividades de proceso* para el diseño, la
  realización y la dirección de un sistema. #diapo(4, 103)
]

#clave[
  La idea central del diagrama: los *requerimientos* fluyen *hacia abajo*
  por la jerarquía del sistema (proceso de diseño), mientras los *productos*
  se realizan y fluyen *hacia arriba* (proceso de realización) — son dos
  direcciones simultáneas sobre la misma estructura, no dos fases sucesivas
  #diapo(4, 104).
]

#figure(
  table(
    columns: (1.5fr, 2fr),
    align: (left, left),
    stroke: 0.5pt + c-guia,
    inset: 7pt,
    table.header([*Proceso*], [*Actividades*]),
    [1. Definición de Requerimientos], [1. Definición de expectativas de los interesados · 2. Definición de requerimientos técnicos],
    [2. Definición de Soluciones Técnicas], [3. Descomposición lógica · 4. Definición de solución de diseño],
    [3. Realización de Producto], [5. Implementación del producto · 6. Integración del producto],
    [4. Evaluación], [7. Verificación del producto · 8. Validación del producto],
    [5. Transición del Producto], [9. Transición del producto],
    [6. Planificación Técnica], [10. Planificación técnica],
    [7. Control Técnico], [11. Gestión de requerimientos · 12. Gestión de interfaces · 13. Gestión de riesgo técnico · 14. Gestión de configuración · 15. Gestión de datos técnicos],
    [8. Evaluación Técnica], [16. Evaluación técnica],
    [9. Análisis de Decisión Técnica], [17. Análisis de decisión],
  ),
  caption: [Las 17 actividades del motor de NASA, agrupadas en nueve procesos. Los pasos 1-9 recorren el sistema una vez; los pasos 10-17 lo vigilan durante todo el proyecto #diapo(4, 104).],
)

=== Definir y descomponer: pasos 1 a 4

Se definen los requerimientos junto con el cliente desde el principio,
pensando en cómo tiene que *operar* el sistema — cuánta potencia debe
entregar el subsistema de energía, qué tipo de propulsión hace falta
#diapo(4, 106). La *descomposición* progresiva es crítica para tener partes
manejables que se puedan asignar a especialistas — eléctricos de potencia,
expertos en propulsión, en control de actitud #diapo(4, 106). Sólo después
de eso se definen soluciones técnicas concretas: qué batería, qué sistema de
propulsión #diapo(4, 107).

=== Construir y verificar: pasos 5 a 9

Se busca primero si el mercado ya tiene el producto que hace falta; si no,
hay que desarrollarlo #diapo(4, 114). Cada nivel de la #t[jerarquía del
sistema] se verifica *antes* de integrarlo al nivel de arriba — si se compra
una batería, se verifica que cumple sus requerimientos *antes* de ponerla en
el subsistema #diapo(4, 114).

=== Vigilar todo el proyecto: pasos 10 a 17

#cuidado[
  Los pasos 11 a 15 son *gestión técnica*, y valen la pena uno por uno
  porque cada uno tiene su propia forma de fallar si no está #diapo(4, 117)
  #diapo(4, 118):
  - *Gestión de interfaces* (12): descomponer el problema en partes que se
    asignan a grupos distintos obliga a cuidar *cómo se conectan* — un ICD
    (_Interface Control Document_) por cada conexión eléctrica, mecánica,
    térmica.
  - *Gestión de riesgo técnico* (13): ser proactivo — si hay riesgo de que
    una batería no llegue a tiempo, buscar alternativas *antes* de que pase.
  - *Gestión de configuración* (14): asegurar que todos trabajan sobre el
    mismo _baseline_ de requerimientos y de diseño — el defecto típico es
    que alguien actualice su propia copia de los planos en vez del
    _baseline_ compartido.
  - *Gestión de datos técnicos* (15): centralizar estudios, evaluaciones y
    lecciones aprendidas en un solo lugar, para cualquiera que los necesite
    después.
]

#posta[
  Los pasos 10 a 17, en una frase: *pensar la palabra "gestión"* (management)
  y no dejarse engañar por eso — no es trabajo administrativo ajeno a la
  ingeniería, *es* una función técnica que asegura que todo esté coordinado
  hasta tener un sistema maduro, listo para operar #diapo(4, 119).
]

== Los atributos del ingeniero de sistemas

#definicion("atributos del ingeniero de sistemas")[
  Según Gentry Lee: curiosidad intelectual; ver el _big picture_ y el
  detalle a la vez; hacer conexiones en un sistema grande (#t[tabla N²]);
  estar cómodo con el cambio, la incertidumbre y lo desconocido; ser un
  comunicador excepcional en las dos direcciones; *paranoia apropiada*
  ("esperar lo mejor, planificar para lo peor"); confianza en sí mismo y
  decisión ("comisión, no omisión"); apreciar el rigor de los procesos *y*
  saber dónde parar; ser fuerte como miembro de equipo *y* como líder; y
  tener habilidades técnicas diversas para aplicar juicio técnico.
  #diapo(4, 122)
]

#posta[
  La frase que cierra la clase, y vale como resumen de las cuatro unidades
  hasta acá: *«nunca ha habido un proyecto en la historia que cualquier
  conjunto de requerimientos haya cubierto el significado real de aquello
  que necesita ser hecho»* — los requerimientos son aproximaciones hechas con
  lenguaje, y siempre se interpretan #diapo(4, 123). Es el mismo argumento
  del #t[principio de ambigüedad] de la unidad 3, dicho por un ingeniero de
  sistemas con décadas de proyectos reales detrás.
]

== Resumen

#clave[
  La ingeniería de sistemas es un arte *y* un proceso de gestión
  disciplinado y estandarizado, para desarrollar sistemas complejos —
  espaciales o no— en un ambiente de cambio constante. Este módulo cerró el
  argumento que las unidades 2 y 3 armaron con vocabulario: por qué hace
  falta (Saturno V, Hubble), qué pasa sin ella (Tacoma, FIA), y el modelo
  formal —el motor de NASA— que existe para que esa falta no se repita.
  #diapo(4, 124)
]
