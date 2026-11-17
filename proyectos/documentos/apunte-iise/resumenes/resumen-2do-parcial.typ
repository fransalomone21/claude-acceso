// =====================================================================
//  Resumen del 2.o parcial de IISE (clases 7 a 13) -- fase 13, 2026-11-17
//  v2: TODOS los terminos del glosario controlado de las unidades 7 a 13
//  (fuentes/glosario.md, 63 entradas, definicion con la palabra de la
//  catedra) y todas las secciones de los modulos m24-m46, al grano.
//  Acompana al podcast resumen (mismo orden: una parte por clase).
//  Fuentes: el apunte; los 8 resumenes de los companeros de Fran (lo que
//  solo traen ellos va marcado).
// =====================================================================
#import "estilo.typ": *

#show: documento.with(
  titulo: [Resumen — segundo parcial],
  subtitulo: [Clases 7 a 13, completo y al grano: cada concepto de la cátedra con su definición, sus partes y la trampa. Para leer con el podcast resumen.],
  encabezado: [Resumen — 2.º parcial, clases 7 a 13],
)

#let acordate(cuerpo) = caja([Para no olvidarlo], c-rosa, cuerpo)
#let ejemplos(cuerpo) = caja([Ejemplos de la clase — ilustran, no son concepto], c-verde, cuerpo)

#caja([Cómo te evalúan, y cómo está armado esto], c-azul)[
  *El método de la cátedra*, medido en los cinco parcialitos tomados: cinco o
  seis preguntas *teóricas* por clase, sin cuentas, siempre de estas formas:
  *¿qué es X?* · *¿cuáles son sus tipos / enumerá* · *diferenciá X de Y* ·
  *¿en qué orden van?* · *explicá con un ejemplo*. La corrección marca *la
  palabra exacta* y *la lista completa* (a uno le marcaron la Fase F descripta
  como «operación»; a otro, que faltaba «al menos dos niveles»).

  Por eso cada tema trae, en este orden: la *definición* con la palabra de la
  cátedra (azul), *las partes o la lista*, y *la distinción* que se confunde
  (rojo). Los *ejemplos* van aparte, en verde, al final de cada parte: sirven
  para el «explicá con un ejemplo» y para entender, pero *no son la
  respuesta*. Están *todos los conceptos* de las clases 7 a 13 (cada término
  del glosario del apunte, unidades 7 a 13, y cada sección de los módulos 25
  a 47), en el mismo orden que el podcast.

  Léxico: *requerimiento* (no «requisito»), *interesado* (no
  «stakeholder»). Lo marcado _(compañeros)_ lo traen los resúmenes de los
  compañeros y el apunte no lo desarrolla.
]

#caja([El mapa de la materia en una tabla], c-verde)[
  #tabla((0.55fr, 1.6fr, 1.6fr, 1.2fr),
    [*Fase*], [*Para qué*], [*Revisiones (y qué fijan)*], [*Al salir*],
    [Pre-A], [concepto; factibilidad], [MCR], [KDP-A],
    [A], [desarrollo del concepto y la tecnología], [SRR (requerimientos de sistema) · MDR/SDR (funcional)], [KDP-B],
    [B], [diseño preliminar; TRL 6], [PDR (asignado) · confirmación/NAR], [KDP-C: implementación],
    [C], [diseño final y fabricación], [CDR (producto) · SIR], [KDP-D],
    [D], [ensamble, integración, ensayo y lanzamiento], [ORR · FRR (Go / No Go)], [KDP-E],
    [E / F], [operar y sostener / cerrar], [—], [desorbitado],
  )
  Pre-A, A y B son la *formulación*; C, D, E y F, la *implementación*.
]

// =====================================================================
= Parte 1 — Clase 7: arquitectura, Fase A, revisiones y N²
#origen[Apunte, módulos 25 a 28 · clase 7]

== Qué es una arquitectura
#definicion[Arquitectura — dos definiciones más][
  *INCOSE*: «la estructura fundamental y unificada del sistema, definida en
  términos de elementos del sistema, interfaces, procesos, restricciones y
  comportamientos». *DoD*: «la estructura de componentes, sus relaciones, y
  los principios y guías que gobiernan su diseño y su evolución en el
  tiempo». No compiten: es la misma idea en tres vocabularios.
]
#acordate[
  La arquitectura es el esqueleto de la casa antes de elegir los azulejos: dónde van las paredes, los caños y los cables, y por dónde se tocan. Los azulejos son diseño.
]
Operativamente, la arquitectura es el *puente* entre el análisis de
necesidades y alcance, por un lado, y el análisis funcional y el diseño, por
el otro: la primera descripción concreta de la estructura.

*Cómo se desarrolla, paso a paso* (es el comienzo del diseño; *recursivo*:
comparando candidatas puede cambiar el enunciado del problema):
+ requerimientos iniciales (análisis de necesidades, alcance, ConOps);
+ límites externos, restricciones, contexto, hipótesis y ambiente;
+ arquitecturas *candidatas*, en forma iterativa;
+ comparar cada candidata en beneficios, costos, riesgos y requerimientos,
  con los interesados.

#definicion[Síntesis y descubrimiento — las dos técnicas][
  *Síntesis*: modifica o combina sistemas existentes para necesidades nuevas
  (requiere lógica y conocer bien esos sistemas). *Descubrimiento*: usa el
  conocimiento de arquitecturas existentes para descubrir una nueva (requiere
  además abstracción, para reconocer un sistema análogo en otro dominio). Las
  dos se benefician de entender los sistemas heredados.
]
#acordate[
  *Síntesis* es un Frankenstein bien hecho: agarrás piezas que ya andan y las cosés para algo nuevo. *Descubrimiento* es ver que el sistema de turnos del dentista sirve para despachar colectivos: otra cosa, la misma idea de fondo.
]
#definicion[Métodos de creación de arquitectura][
  *Basados en ciencia (deductivos)*: *normativo* (reglas estrictas ya dadas;
  el éxito es seguirlas) y *racional* (soluciones derivadas de los objetivos,
  con técnicas formales y optimizadas). *Basados en arte (inductivos)*:
  *participativo* (consenso de grupos, con los interesados involucrados) y
  *heurístico* (reglas blandas de experiencia y lecciones aprendidas).
]
#acordate[
  Los cuatro en un edificio: el *reglamento* del consorcio (normativo), la *planilla con fórmulas* del administrador (racional), la *reunión de consorcio* donde opinan todos (participativo) y el *portero* que hace treinta años sabe que el caño del tercero pierde los jueves (heurístico).
]
#posta[
  El método no lo elige el gusto del arquitecto: lo determina cuánta
  estructura previa existe. Un estándar obligatorio impone el normativo; un
  dominio sin precedentes fuerza el heurístico.
]
#definicion[Factores de balance de la arquitectura][
  Lo que se equilibra al elegir entre candidatas: *requerimientos del sistema,
  función, forma*, sencillez, robustez, asequibilidad, complejidad,
  imperativos ambientales y factores humanos. Se elige un concepto de
  referencia (*baseline*) a pesar de incertidumbres grandes y prioridades
  ambiguas del cliente. La esencia: *estructurar, simplificar, comprometer y
  balancear*.
]
#acordate[
  Es armar el asado con la plata contada: más vacío es menos chori, más invitados es más chico el pedazo. No hay «el mejor asado»: hay el mejor para lo que hay.
]
*Arquitectura contra diseño.* La arquitectura establece el marco: restringe
el espacio de soluciones, respalda decisiones de hacer o comprar, discrimina
alternativas y *descubre los verdaderos requerimientos* del cliente. El
diseño desarrolla los componentes que cumplen los requerimientos y guía la
construcción.
#definicion[Descripciones de arquitectura (vistas)][
  Ningún diagrama solo captura la arquitectura: se usan varias vistas a la
  vez. *Renderings* y diagramas de bloques de subsistemas; diagramas de flujo
  de comunicación; diagramas de flujo funcionales; diagramas de interfaces
  (a menudo, el N²). Son los planos, cotas y planos de cableado de un
  edificio.
]
#acordate[
  Nadie entiende una casa con una sola foto: hace falta el plano, el corte, el plano de luz y el de cañerías. Cada vista contesta otra pregunta.
]

== La Fase A a fondo
#definicion[Fase A — desarrollo del concepto y la tecnología][
  Convierte el concepto elegido en la Pre-Fase A en una propuesta de sistema
  viable: refina los requerimientos de alto nivel, identifica tecnologías e
  interfaces críticas, estima costo y plazo, analiza riesgos y prepara los
  planes de ingeniería y de V&V, con el *SEMP* (Plan de Gestión de la
  Ingeniería de Sistemas, NPR 7123.1). Produce la *línea de base del
  concepto*: misión, arquitectura preliminar, requerimientos principales,
  estrategia tecnológica, costo del ciclo de vida y planificación.
]
#acordate[
  Pre-A es mirar casas en internet; la Fase A es elegir una, pedir el presupuesto en serio y *firmar la reserva*. La línea de base es esa reserva firmada: de ahí en más, cambiar de casa cuesta.
]
#caja([La lámina más repetida: funciones clave de la IS por fase], c-rojo)[
  Matriz con las *funciones clave* de la IS en las filas y las *fases* en las
  columnas (clase 7 diap. 4; dos veces más en la clase 9).
  - *Por fila*, cada función sube la misma escalera: *Concepto* (Pre-A) →
    *Baseline* (A) → *Completo* (B o C) → *Seguimiento de los cambios*. La
    V&V va atrasada a propósito (inicial en A, asignar métodos en B, planes en
    C, completa en D): no se planifica cómo verificar lo que no está diseñado.
    Interfaces y presupuesto de recursos técnicos, un paso atrás (inicial en
    A, baseline en B).
  - *Por columna*, el checklist de la fase. Fase A: en baseline, objetivos,
    ConOps, arquitectura y diseño, requerimientos de *alto nivel*, ambiente de
    misión y SEMP; en inicial, V&V, interfaces y presupuesto; riesgo con FTA y
    RBD; configuración = control de los requerimientos de nivel 1; hito, la
    MDR.
  - Ojo: en esa matriz la SRR aparece en la Fase B; para el parcial vale la
    Fase A (diap. 41 a 45 y ciclo de NASA).
]
*Herencia*: reusar un sistema que ya voló reduce *riesgo* (no sólo costo) y
ahorra estudios, si la herencia es real y medible. Una tecnología inmadura
*no entra al baseline*: se le aprueba un plan de maduración con fecha.

*Interfaces en la Fase A.* Al descomponer aparecen las *internas* (entre
subsistemas) y las *externas* (lanzador, segmento terreno, usuario,
ambiente). Las críticas se resuelven y documentan en el *ICD*, para que cada
equipo no tenga que renegociar la frontera. Una interfaz se elige *contra un
requerimiento*, y un requerimiento de interfaz preciso puede seguir siendo
*TBR*.
#trampa[
  *Interna o externa depende de dónde se pone el límite del sistema*, no de
  la pieza. Y no toda interfaz va al ICD.
]

== Las revisiones de la Fase A
Durante toda la fase se gestionan el riesgo y los recursos, y se comparan
alternativas de subsistema (¿cuál cumple mejor costo, desempeño y plazo?).
#definicion[SRR — Revisión de Requerimientos de Sistema][
  Primera revisión técnica de la Fase A, por un equipo externo. Confirma que
  los requerimientos de alto nivel están claros, ajustados a los objetivos de
  los interesados y bien bajados; que las interfaces internas y externas
  están definidas; que los riesgos tienen plan; y que existen el SEMP y un
  plan inicial de V&V. *Establece el baseline de Requerimientos de Sistema.*
]
#acordate[
  La SRR revisa la *lista del súper* antes de salir: ¿está todo lo que pidieron en casa, y se entiende qué es cada cosa? La MDR revisa el *carrito* antes de la caja: ¿lo que elegiste cumple la lista y te alcanza la plata?
]
#definicion[MDR — Revisión de Diseño de Misión (también SDR)][
  Segunda revisión de la Fase A. ¿El concepto baseline es razonable,
  alcanzable y completo? ¿Consistente con masa, potencia, costo y
  planificación? ¿Riesgos mayores con mitigación? ¿Maduración tecnológica en
  curso para terminar en la B? *Establece el baseline Funcional.*
]
Las *acciones abiertas* de una revisión se cierran antes de la siguiente:
cerrar una acción es actualizar el baseline del propio proceso de revisión.

== El diagrama N² aplicado
#definicion[Tabla N² (diagrama N²)][
  Matriz cuadrada con las entidades en la *diagonal*; las *salidas* van por
  la fila y las *entradas* por la columna. Casilla vacía: no hay interfaz.
  Además marca dónde puede haber conflicto y las hipótesis de dependencia.
]
#acordate[
  El N² es la planilla de quién le debe qué a quién en el grupo: los nombres en la diagonal, en cada casilla lo que uno le pasa al otro. Los que se deben en las dos direcciones (un lazo) terminan haciendo una vaquita juntos: un subsistema.
]
Tabla y diagrama son la *misma matriz dibujada de dos maneras*. Los *lazos
de realimentación* (flujo en los dos sentidos) agrupan funciones fuertemente
acopladas en un *subsistema candidato*: el N² dibuja los límites naturales
de los subsistemas. La herramienta no cambia al escalar.
#definicion[Los cuatro usos del N² (resumen de la cátedra)][
  (1) Las interfaces *externas* se definen y gestionan junto con los
  requerimientos. (2) Las *internas* se optimizan agrupando funciones y usando
  interfaces estándar. (3) *Toda interfaz necesita un dueño explícito*. (4) El
  N² captura existencia y naturaleza de las interfaces, hipótesis de entrada y
  salida, lazos de realimentación y candidatos a subsistema.
]

#ejemplos[
  *Mars 2020*: ConOps en un cuadro; heredó del Curiosity (herencia como menor
  riesgo); una tecnología de aterrizaje fuera del baseline, con plata para
  madurarla. *GLAST*: el satélite pide más de 4000 kg al adaptador y éste da
  7000 (interfaz elegida contra un requerimiento). *Falcon 9*: la interetapa
  es interna o externa según el límite. *TDRS*: un N² con entidades físicas
  reales. *Control remoto de TV*: ejercicio de alojar interfaces. *Matriz de
  17 disciplinas* de un lanzador.
]

// =====================================================================
= Parte 2 — Clase 8: plan de trabajo, estimaciones, LDCM, lanzadores
#origen[Apunte, módulos 29 a 33 · clase 8]

Cuatro piezas en orden, cada una usa la anterior: *WBS* (qué hacer) → *red*
(orden y dependencias) → *camino crítico* (cuánto dura) → *Gantt* (sobre el
calendario). Arriba, el triángulo de hierro (desempeño, costo, plazo), con el
jefe de proyecto balanceándolo.

#definicion[WBS — estructura de desglose de trabajo][
  Subdivisión jerárquica, en árbol, de *todo el trabajo* necesario para el
  objetivo final, partida en componentes manejables. Cada unidad lleva un
  *código* (1.0, 1.2, 1.2.1); rara vez se baja del cuarto nivel; el nivel más
  bajo son los *paquetes de trabajo*. Se arma *de abajo hacia arriba* (lluvia
  de ideas que después se agrupa: para métodos nuevos) o *de arriba hacia
  abajo*.
]
#acordate[
  La WBS es la lista de la mudanza: todo lo que hay que hacer, partido hasta que cada caja tiene dueño y fecha («vos embalás la cocina el sábado»). Lo que no está en la lista no lo hace nadie, y lo que está dos veces lo pagás dos veces.
]
_(Compañeros)_: MIL-HDBK-881, «árbol orientado al producto» (hardware,
software, servicios, datos, instalaciones); niveles de la cátedra:
asignaciones de trabajo, tareas, subtareas. Para NASA la gestión, la IS, el
aseguramiento de la misión y la difusión están al *mismo nivel* que el
satélite.
#definicion[PBS — estructura de desglose de producto][
  El árbol de los *componentes* del sistema. La WBS le agrega el trabajo de
  *integrarlos* y lo que no es producto: gestión, IS, integración y ensayo,
  soporte logístico.
]
#acordate[
  La PBS es la lista de muebles; la WBS es la mudanza entera: los muebles, el flete, embalar, desembalar y discutir con tu vieja dónde va el sillón.
]
#definicion[Paquete de trabajo][
  La unidad más baja de la WBS: *descripción del trabajo* (tiempo, entradas y
  salidas), *recursos y costo*, y *responsable*. Sumando hacia arriba sale el
  costo y el tiempo de cada unidad.
]
#definicion[Diagrama de red][
  Diagrama de flujo con el *orden* y las *dependencias* de las tareas. Tres
  elementos: *eventos* (hitos), *actividades* (el trabajo entre eventos) y
  *duración*. Regla: todas las entradas de una actividad completas antes de
  que empiece.
]
#definicion[Camino crítico y holgura][
  El camino más largo de punta a punta: *su tiempo es el del proyecto*. Fuera
  de él hay *holgura* (slack); en él, ninguna. Se calcula con la *pasada
  hacia adelante* (lo más temprano) y *hacia atrás* (lo más tarde).
]
#acordate[
  El camino crítico es el amigo que siempre llega tarde a la juntada: hasta que no llega él, no se arranca. Los demás tienen holgura: pueden pasar por el chino a comprar hielo sin atrasar a nadie.
]
#trampa[
  Acelerar una tarea crítica achica el proyecto sólo hasta que *otro camino
  pasa a ser el más largo*: el camino crítico se recalcula después de cada
  cambio.
]
#definicion[Diagrama de Gantt][
  Herramienta de Henry Gantt para planificar y programar tareas en el
  tiempo: una barra por tarea, con duración y secuencia sobre el calendario;
  sirve para seguir y controlar el avance. En el TP: con las fases y el margen
  visibles.
]

== Estimaciones
#definicion[Estimación][
  Pronosticar los tiempos y costos de los entregables. *De arriba hacia
  abajo* (macro): analogía, consenso, relaciones matemáticas o estadística,
  por alguien con experiencia. *De abajo hacia arriba* (micro): cada elemento
  de la WBS, sumado. Se usan las dos y *se reconcilia la diferencia*.
]
#acordate[
  *Macro*: un tipo re pijudo, que la tiene más clara que huevo de albino, mira el proyecto un minuto y dice «esto sale cuarenta palos y dos años», porque ya vio veinte parecidos. *Micro*: el contador obsesivo que suma tornillo por tornillo cada paquete de la WBS. Se hacen las dos; si no coinciden, se sientan a discutir quién se equivocó.
]
Para qué: decidir, planificar, saber cuánto cuesta y dura, *si vale la pena*,
el flujo de caja, el avance y el baseline. Directrices: gente con
experiencia, *varias estimaciones independientes*, condiciones normales,
unidades consistentes, tareas independientes, *sin contingencias adentro*
(el riesgo se evalúa aparte).
#definicion[ROM — orden de magnitud][
  La estimación macro previa al lanzamiento del proyecto: *±35 %*. Con el plan
  aprobado, por tareas: *±15 %*. Ejecutando: *±10 %*. Por fase: macro en
  Pre-A, primeras detalladas en A y B, costos reales en C y D, operación en E
  y F.
]
#acordate[
  ±35 % es «sale más o menos un auto». ±15 % es «un Gol usado». ±10 % es «el Gol 2015 con 80 mil kilómetros de la concesionaria de la vuelta».
]
#definicion[Tipos de costos][
  *Directos*: cargables a un paquete (trabajo, materiales, equipos).
  *Directos generales del proyecto*: identificables con un entregable
  (salarios, rentas, suministros). *Generales y administrativos*: de la
  organización, sólo indirectamente ligados al paquete.
]
#acordate[
  En una pizzería: la *harina* de esa pizza es directo; el *horno* que sólo usa esa línea es directo general; el *contador de toda la cadena* es general y administrativo.
]
Recursos a estimar además del tiempo: *dinero, materiales, máquinas, gente*.

== Satélite, lanzador y diagrama funcional
En la Fase A el *concepto puede cambiar*, y está bien que cambie ahí: se
comparan conceptos completos contra el triángulo de hierro.
#definicion[Plataforma (bus) y carga útil][
  *Carga útil*: lo que cumple la misión. *Plataforma*: lo que la sostiene y la
  sirve: estructura, potencia, control de actitud, comando y manejo de datos,
  comunicaciones, propulsión y control térmico. La carga útil es la razón de
  ser y una fracción de la masa.
]
#acordate[
  La carga útil es el cantante; la plataforma es el escenario, el sonido, las luces y los plomos. La gente paga por el cantante, pero sin plomos no hay show.
]
*Lanzadores.* El lanzador le impone al satélite ambiente, masa y volumen.
Tiene casi los subsistemas de un satélite más dos propios: *separarse a
propósito* y *autodestruirse* si se desvía (requerimiento de seguridad, de
la categoría «otros»). Un lanzador desechable es como un forro: se usa una vez y se tira; los reutilizables son la excepción, no la regla.
#definicion[Diagrama funcional][
  Las funciones o bloques principales y sus conexiones, *distinguiendo el
  tipo de conexión* (dato, potencia, señal), con subsistemas o entornos en
  cajas. Es una de las vistas de la arquitectura; el mismo sistema se puede
  mostrar con más o menos zoom.
]
#acordate[
  Es el dibujo del equipo de música con flechas que dicen «audio», «corriente», «control remoto»: no dice la marca del cable, dice qué pasa por él.
]
#trampa[
  El nivel de detalle va con la fase: en Pre-A o A, pocos bloques y cada
  flecha con lo que pasa por ella; el diagrama con cables reales es de la
  Fase C. Y el *ambiente* es una lista de *requerimientos ambientales*, no
  decoración.
]

#ejemplos[
  *El té*: la red y el camino crítico (acelerar el hervor de 180 a 10 s mejora
  el proyecto tres veces, no dieciocho). *LDCM* (continuidad de Landsat): la
  necesidad es que no se corte una serie de datos de cuarenta años; el
  concepto cambió en la Fase A a plataforma propia a 705 km; carga útil OLI y
  TIRS. *SZ* y *Falcon 9*: requerimientos, diagrama funcional y ciclo de vida
  de lanzadores reales. *ROV*: diagrama funcional con leyenda y la luz bajo el
  agua como ambiente. *NOAA-N′*: un satélite en el piso.
]

// =====================================================================
= Parte 3 — Clase 9: plantilla, Fase B, madurez y Fase C
#origen[Apunte, módulos 34 a 37 · clase 9]

*Plantilla de requerimientos* de la cátedra: ID, origen, enunciado con
«deberá», fuente y fecha, verificación, satisfacción/costo/riesgo (1 a 5),
relacionados o conflictivos, rationale, aprobaciones. Lo que no puede faltar:
*ID con nivel, «deberá», verificación y rationale*.
#definicion[Carga útil secundaria][
  Satélite que viaja en un lanzamiento de otro cliente, montado en la
  *estructura de empuje* entre el primario y el lanzador (anillo ESPA) o en un
  *rideshare*. Su interfaz externa principal es mecánica. La órbita la elige
  el pasajero principal: es una restricción.
]
#acordate[
  Es ir de acompañante en el auto de un amigo a la costa: viajás barato, pero la hora de salida y la ruta las elige él.
]
#definicion[Fase B — diseño preliminar][
  Última de la formulación: demuestra que la misión es técnica y
  programáticamente viable. Requerimientos detallados desde los de la SRR,
  árbol trazable completo, planes de V&V, matriz de verificación, márgenes
  asignados, plan de implementación con costo, cronograma y riesgos. Lo que
  produce es *menos incertidumbre*, no medio satélite.
]
#acordate[
  La Fase B es el ensayo general del casamiento: nadie se casó todavía, pero ya se probó que el salón, la música y el catering andan juntos, y se sabe cuánto va a salir.
]
#trampa[
  *TRL 6 al salir de la Fase B*: prototipo demostrado en un *ambiente
  relevante*. Si no llega, no pasa a la C. Alternativa: *hacer o comprar*.
]
#definicion[Hacer o comprar][
  Decisión que se cierra en la Fase B: qué se fabrica en casa y qué se compra
  (COTS, herencia, equipos calificados). Lo de fabricación larga se puede
  comprar *antes del CDR*, con aprobación de los interesados.
]
#acordate[
  ¿La torta la hacés o la comprás? Si la receta nunca te salió, comprala. Y si el pastelero bueno tarda tres meses, se la encargás antes de tener el menú cerrado: es apostar a que la torta no cambia.
]
#definicion[PDR — Revisión Preliminar del Diseño][
  La revisión de la Fase B: asegura que se puede empezar el *diseño de
  detalle* cumpliendo el desempeño dentro de costo, plazo y riesgo.
  Trazabilidad completa, interfaces definidas, tecnología madura, márgenes y
  acciones anteriores cerradas. *Establece el Baseline Asignado.* Antes, hay
  revisiones de pares y de subsistemas.
]
#acordate[
  La PDR es mostrar los planos aprobados antes de empezar a levantar paredes. La de confirmación no mira los planos: pregunta si te alcanza la plata y si la casa va a estar antes de que nazca el pibe.
]
#definicion[Revisión de confirmación (NAR)][
  Independiente (*Non-Advocate Review*): ¿los diseños cumplen la ciencia y la
  misión? ¿la gestión alcanza? ¿llega *a tiempo y dentro del presupuesto*? La
  PDR revisa el diseño; ésta, si el proyecto puede seguir. Con las dos se pasa
  el KDP-C.
]

== Madurez tecnológica
#definicion[TRL — nivel de madurez tecnológica][
  9 niveles; al subir, *baja el riesgo*. 1 principios básicos · 2 concepto
  formulado · 3 prueba de concepto · 4 validado en laboratorio · 5 validado
  en ambiente relevante · *6 prototipo demostrado en ambiente relevante* · 7
  prototipo en ambiente operacional espacial · 8 calificado para vuelo · 9
  probado en vuelo.
]
#acordate[
  TRL 1 es la idea en la servilleta del bar. TRL 6 es el prototipo que se bancó una prueba en condiciones parecidas a las de verdad. TRL 9 es la tostadora que ya anduvo mil mañanas seguidas.
]
#trampa[
  TRL alto no es «sofisticado»: es *viejo y probado*. Heredar es comprar
  madurez.
]
#definicion[IRL — preparación para la integración][
  Mide si la tecnología está lista para *integrarse* en un sistema. 5 niveles:
  1 análisis conceptual completo · 2 análisis de diseño detallado · 3 maqueta
  o prototipo ensayado en tierra · 4 prototipo en ambientes de vuelo
  representativos · 5 fabricado, lanzado y operando. TRL alto con IRL bajo:
  posible.
]
#acordate[
  Tener al mejor jugador del mundo (TRL 9) no garantiza que juegue bien en tu equipo: si nunca entrenó con los demás, su IRL es bajo.
]
#definicion[SRL — preparación del sistema][
  Combina madurez de tecnologías y de su integración para el sistema entero.
  Material de estudio (Yasseri y Bahai), de *0 a 7*, con sus propios TRL e IRL
  de 0 a 7: *no se mezcla* con la TRL de NASA (1-9) ni la IRL de la cátedra
  (1-5).
]
#definicion[Integración][
  Ensamblar el sistema desde sus componentes *y lograr que funcione* en su
  entorno, no sólo armarlo. Es la pendiente ascendente de la V: de la
  implementación a la V&V del sistema completo. _(Compañeros)_: «integrar no
  es armar».
]
#acordate[
  Armar es poner los muebles de Ikea. Integrar es que la cocina ande con todo enchufado a la vez sin que salte la térmica.
]

== La Fase C
#definicion[Fase C — diseño final y fabricación][
  Entrada a la implementación: diseño de detalle, fabricación de
  componentes, *verificación de componentes antes de integrar*, planes de
  AIT. La *curva del gasto* se dispara. Un cambio externo obliga a revisar el
  diseño.
]
#definicion[CDR — Revisión Crítica del Diseño][
  Revisión externa de todo el sistema: ¿el diseño detallado cumple *con
  margen adecuado y riesgo aceptable*? ¿interfaces y documentación maduras
  para fabricar, integrar y ensayar? ¿planes de V&V completos? Acciones del
  PDR cerradas. *Establece el baseline del producto.* Después se compra o
  fabrica el resto.
]
#acordate[
  Después de la CDR: «no se toca más, se manda a fabricar». Después de la SIR: «las piezas llegaron y andan solas; ahora se juntan».
]
#definicion[SIR — Revisión de Integración del Sistema][
  Segunda de la Fase C: planes y procedimientos de integración aprobados,
  *verificación de componentes* satisfactoria, flujo documentado, personal
  entrenado, acciones del CDR cerradas. Después empieza el AIT *del sistema*.
]
#definicion[AIT / AIV][
  Ensamble, integración y ensayos (o verificación): planes y actividades para
  armar, integrar y ensayar hasta el sistema. Los planes se hacen en la C; la
  ejecución sobre el sistema completo, en la D.
]

#ejemplos[
  *TESS*: llega a la PDR con la cámara ensayada, no armada; madurar cuesta
  plata y conviene gastarla temprano. *Curiosity → Mars 2020*: TRL comprado
  por herencia. *El propulsor*: se verifica el componente antes de integrar.
  *El lanzador que llega tarde*: lo externo mueve la Fase C. *Anillo ESPA*:
  montaje de carga útil secundaria.
]

// =====================================================================
= Parte 4 — Clase 10: forma y función, la PDR del ROV, riesgo
#origen[Apunte, módulos 38 a 40 · clase 10]

#definicion[Aprendizaje basado en proyectos (PjBL)][
  Complementario al *CDIO* (concebir, diseñar, implementar, operar): foco en
  la *formulación y el encare del problema* más que en la solución; centrado
  en el estudiante, grupos chicos, profesores como *coaches*, proyectos como
  vehículo, aprendizaje autodirigido.
]
#acordate[
  No te enseñan a nadar con un libro: te tiran a la pileta con el profe al costado y un salvavidas a mano. El profe no nada por vos.
]
_(Compañeros)_: los cuatro currículos: disciplinario estricto (puro «qué»),
*integrado* (el de CDIO: disciplinas aplicadas en proyectos), basado en
problemas, y de aprendiz (puro «cómo»).

*La arquitectura releída*: la asignación de la *función* a la *forma*,
mediada por el *concepto*. La *forma* es lo que existe o se construye, es
instrumental a la función y existe *antes* de que la función se ejecute. El
concepto lo crea el arquitecto, permite todas las funciones e implica una
tecnología. *Arquitectura*: elige concepto, descomposición y mapeo forma →
función (fija *qué variables* hay). *Diseño*: elige *los valores*.
#definicion[Ingeniería inversa][
  El camino inverso al diseño: se conoce la *forma* y se *infieren las
  funciones* y el concepto. Etapas: subsistemas y funciones internas →
  concepto → funciones externas entregadas (las dos últimas son las
  difíciles, por la emergencia).
]
#acordate[
  Es desarmar la licuadora del abuelo para entender cómo hicieron que no se trabe nunca.
]
También: el *lazo de los procesos de diseño* de NASA (requerimientos ↔
descomposición lógica ↔ solución de diseño): se itera, no se baja una vez.

== La revisión de diseño (PDR)
Metas de una revisión de diseño: *validar la definición del problema*,
dialogar sobre *tres o más diseños viables*, *acordar* el elegido. Se cubre:
lo aprendido, varios diseños con pros, contras y cómo se eligió, fondos y
costos, un plan con *tiempo de sobra para validar*, y los riesgos *contados
con honestidad*. Formato: 15 a 25 min de exposición y unos 40 de preguntas,
mucho dibujo, diapositivas numeradas, resumen impreso de 2-3 páginas.
#definicion[Trade study][
  Comparar diseños viables contra *criterios escritos antes, con su peso*:
  nota por criterio × peso, sumado. Los pesos los pone el *interesado*; si se
  eligen después de ver los números, cualquier diseño gana.
]
#acordate[
  Elegir celular con una tabla: cámara 40 %, batería 30 %, precio 30 %. Si cambiás los porcentajes después de ver cuál te gustaba, te estás haciendo trampa al solitario.
]
En la PDR se recorren las *funciones clave* (ambiente, masa, potencia,
datos, apuntamiento) y la *madurez tecnológica* de cada elemento.

== Gestión del riesgo
#definicion[Riesgo][
  Combinación de la *probabilidad* de un evento no deseado y su
  *consecuencia*; mide la incertidumbre de lograr el desempeño dentro de
  costo y plazo. *Tres componentes*: causa raíz futura, probabilidad,
  consecuencia. Técnico o programático (sobrecosto, atraso, accidente,
  ambiente, no lograr objetivos).
]
#acordate[
  «Puede llover en el asado»: la *causa raíz* es el frente frío que viene, la *probabilidad* es lo que dice el pronóstico, la *consecuencia* es que no hay techo y se moja el carbón.
]
Categorías: *técnico* (suele originar los otros), *de costo*, *de
cronograma*, y el *programático* que los combina; en capas, de lo que el
equipo controla (adentro) a lo político y el mercado (afuera). Con los tres
lados del triángulo restringidos, un problema en uno pasa a los otros dos.
#definicion[Gestión del riesgo técnico][
  Disciplina sistemática y *proactiva*. Ciclo: *identificar* (qué puede
  andar mal) → *analizar* (qué importa) → *planificar* → *seguir* →
  *controlar*, con *comunicación y documentos* en el centro. Se identifica
  con lluvia de ideas de todas las disciplinas.
]
#acordate[
  Es el amigo que, antes del viaje, anota todo lo que puede salir mal, arma el plan B para cada cosa, y en la ruta va chequeando. No es el que se preocupa: es el que se ocupa antes.
]
#definicion[Diagrama de riesgo (matriz probabilidad × impacto)][
  Cada riesgo con probabilidad e impacto en 5 niveles. En la versión *NASA de
  la cátedra, 1 es el peor* (probabilidad 1 = casi certeza; impacto 1 =
  catastrófico), con criterios técnicos, de costo y de plazo.
]
#trampa[
  Hay convenciones *al revés* (número alto = peor; total = severidad ×
  frecuencia): la escala se declara antes de la tabla, y cada número necesita
  su porqué.
]
#definicion[La seguridad como propiedad emergente (STAMP, STPA, CAST)][
  Componentes confiables pueden dar un sistema inseguro por cómo
  interactúan. *STAMP* (Leveson, MIT): el accidente es una *restricción de
  seguridad que el control no mantuvo*, no sólo una cadena de fallas. *STPA*:
  busca acciones de control inseguras *antes* del accidente (el FMEA busca qué
  pieza falla). *CAST*: el mismo enfoque *después* del accidente.
]
#acordate[
  Un semáforo perfecto y un conductor perfecto pueden chocar si el semáforo está tapado por un árbol: nada se rompió, falló el control. STPA poda el árbol antes; CAST explica el choque después.
]

#ejemplos[
  *Puente atirantado o colgante* (arquitectura) contra cuántos tirantes y de
  qué diámetro (diseño). *Akutan Zero*: el caza japonés capturado en 1942,
  ingeniería inversa. *La PDR del ROV*: tres diseños con trade study y
  presupuestos; su tabla de riesgos con la escala al revés y el X2 «pérdida
  del vehículo» con severidad 3, que no cierra. *Mars 2020*: madurez
  tecnológica en su PDR.
]

// =====================================================================
= Parte 5 — Clase 11: V&V del producto, modelos, ensayos, subsistemas
#origen[Apunte, módulos 41 a 44 · clases 11 A y 11 B]

#definicion[Verificación del sistema][
  *Construir el sistema correctamente* (_building the system right_): cumple
  sus requerimientos y su diseño. ¿Fue el producto realizado correctamente?
  Durante el desarrollo, sobre componentes y subsistemas.
]
#definicion[Validación del sistema][
  *Construir el sistema correcto* (_building the right system_): hace lo que
  tiene que hacer *en su ambiente* y satisface las *necesidades reales de los
  interesados*. ¿Fue correcto el producto alcanzado? Durante o después de la
  integración, en ambientes simulados o reales.
]
#acordate[
  *Verificar* es que la torta tiene los ingredientes de la receta. *Validar* es que al cumpleañero le guste. Podés seguir la receta perfecta y que el pibe sea celíaco.
]
#trampa[
  No confundir con la V&V *de requerimientos* (unidad 5): la validación de
  requerimientos va en la Fase B, idealmente antes de la SRR, y es analítica;
  la verificación del producto, en la D (rama que sube de la V). Cambiar un
  requerimiento tarde cuesta muchísimo.
]
*Proceso de verificación*: calificación del diseño, después aceptación de
cada unidad. Pasos _(compañeros)_: identificar los requerimientos a
verificar → criterios (método, nivel, modelo) → planes → acuerdo con el
cliente → documentos y controles → ejecución y cierre con evidencia →
aprobación final.
#definicion[Matriz de verificación][
  Vincula *cada requerimiento* con: su ID, los requerimientos de verificación
  *con criterio de éxito*, el método, el *nivel* (parte, componente,
  subensamble, ensamble, subsistema, sistema, vehículo), quién y dónde están
  los resultados. Preliminar al escribir los requerimientos; establecida en
  la *CDR*.
]
#acordate[
  Es la planilla de la VTV del auto: cada ítem, cómo se mira, en qué nivel (la rueda o el auto entero), quién lo firma y dónde queda el papel.
]
#definicion[Métodos de verificación][
  *Inspección*: examen visual de planos, datos o el ítem, sin equipo especial
  («tendrá el logo», «será blanco»). *Análisis*: modelos, simulación o
  similitud, cuando ensayar no es practicable («tendrá una probabilidad
  de»). *Demostración*: operar y observar, sin instrumentación elaborada
  («será accesible»). *Ensayo*: equipos e instrumentos en condiciones
  controladas, el preferido («proveerá 50 Hz»). La cátedra suma la *revisión
  de diseño*.
]
#acordate[
  Inspección: mirar que el auto es rojo. Análisis: calcular que el puente aguanta sin pasarle un camión. Demostración: abrir la puerta y ver que abre. Ensayo: medir con un instrumento cuánto frena.
]
#trampa[
  El análisis de los datos de un ensayo es parte del *ensayo*, no el método
  «análisis». Y si un requerimiento no encaja en ningún método, el problema
  es el requerimiento.
]
_(Compañeros)_: las revisiones como verificación (SCR, PRR, CoDR, PDR, CDR,
revisión de operaciones, pre-ambiental, pre-envío, FRR, SAR) y los métodos
para software (análisis de datos, inspección de código, ensayo, demostración
«pasa / no pasa»).

== Modelos y ensayos
#definicion[Calificación][
  Establece la *aptitud para el vuelo del diseño*, de los componentes y de
  los procesos. Sobre hardware igual al de vuelo que no vuela (QTM), a niveles
  y duraciones *más altos* que el vuelo.
]
#definicion[Aceptación][
  Verifica que *cada unidad producida* es conforme a los datos de la unidad
  calificada y libre de defectos de fabricación (_workmanship_). Niveles más
  bajos, con los procedimientos de aceptación (ATP).
]
#acordate[
  *Calificación* es el crash test: rompen un auto del modelo para probar el *diseño*. *Aceptación* es la revisión de cada auto que sale de la línea: que sea igual al que chocaron y esté bien armado.
]
#definicion[Filosofía de modelos][
  Cuántos modelos y cuáles, con compromiso entre desempeño, costo, plazo y
  riesgo. *Protoflight*: el mismo modelo se califica y vuela (menos costo,
  riesgo moderado). *Prototipo*: modelo de calificación aparte (diseños nuevos
  o complejos, riesgo muy bajo, permite paralelo). *Híbrido* entre los dos.
]
#acordate[
  Protoflight es el traje que te probás y usás el mismo día del casamiento: más barato, y rezás. Prototipo es mandarte a hacer uno de prueba, maltratarlo, y recién después el bueno.
]
#definicion[QTM y modelos de ingeniería][
  *QTM*: el prototipo de calificación, sin propósito de vuelo pero
  representativo, ensayado por encima del vuelo sin superar los márgenes del
  diseño. *EDM*: prueba principios de diseño, sin fidelidad a vuelo. *EM/ETM*:
  además procesos de manufactura, con forma, ajuste y función de vuelo.
]
#acordate[
  EDM es la maqueta de cartón para ver si la idea anda. EM ya tiene la forma y funciona. El QTM es el doble de riesgo de la película: igualito al actor, se come todos los golpes para que el actor (el modelo de vuelo) llegue entero.
]
_(Compañeros)_: *STM* (estructural-térmico: vibración y vacío térmico),
*EQM* (calificación completa), *PFM* (protovuelo), *FM* (vuelo), *BB*
(breadboard, fases B y C).
#definicion[Ensayos ambientales][
  En tierra se simulan el lanzamiento y el espacio, porque hay un solo
  camino. *Antes* del lanzamiento (transporte, manipulación, almacenamiento);
  *durante* (despresurización, térmica, acústica, aceleraciones, vibraciones,
  choque pirotécnico); *en órbita* (térmica, radiación, micrometeoritos).
  Típicos: vibración y choque, vacío térmico, EMI/EMC.
]
#acordate[
  Es hacerle al satélite el viaje en el 60 por la ruta con pozos (vibración), dejarlo en el baúl al sol y después en el freezer (térmico) y ponerle un parlante al lado (acústica), antes del viaje de verdad. Al espacio se va una vez y no hay service.
]
Papeles de la verificación: plan AIV (definición de ensayos, niveles,
configuración, instalaciones, instrumentación, seguridad, contaminación),
especificaciones, procedimientos e informes; la documentación tiene que
permitir construir otro sistema igual al calificado.

== El AIT de un subsistema
#definicion[Ensayos funcionales de un subsistema (AT, FT, CPT)][
  *De vida* (AT): hardware y redundante vivos, sin estímulo externo; chequeo
  rápido al encender o tras mover el satélite. *Funcional* (FT): estímulo
  externo, modo operacional mayor. *Desempeño abarcativo* (CPT): el más
  profundo, todos los modos, contingencia y redundancias.
]
#acordate[
  AT: «¿estás vivo?» — «sí». FT: «levantá la mano» — y la levanta. CPT: el chequeo médico completo, con análisis de sangre y electro.
]
Además: ensayos de fase de sensores y actuadores, *end-to-end* del sistema,
de modo orbital; especiales del control de actitud (fase, transición de
modos, detección de fallas, comunicación). Un subsistema se describe por sus
*funciones* (con verbos), no por la lista de sus cajas. _(Compañeros)_: en el
sitio de lanzamiento, fugas, CPT tras el transporte, umbilical, funcional en
la plataforma y ensayo general.

== Subsistemas, drivers y presupuestos
#definicion[Especificación][
  *Cómo está construido* el sistema: materiales, dimensiones, esquemáticos,
  planos, interfaz de usuario. El *requerimiento* dice *qué* tiene que hacer
  (funciones, cuán bien, automatización, compatibilidad).
]
#acordate[
  Requerimiento: «quiero una heladera que mantenga 4 grados con la puerta abriéndose veinte veces por día». Especificación: «acero inoxidable, 1,80 m, compresor tal».
]
Los *subsistemas de un spacecraft*: estructura, potencia, control térmico,
actitud, propulsión, comando y manejo de datos, comunicaciones, y la carga
útil.
#definicion[Drivers del sistema][
  Los parámetros que más condicionan el diseño (tamaño, masa en órbita,
  potencia, tasa de datos, comunicaciones, apuntamiento, cantidad de
  satélites, altitud, cobertura, operaciones), cada uno con *lo que lo
  limita* y *lo que él limita*.
]
#acordate[
  En un auto para la familia, la cantidad de asientos manda: limita el tamaño, y el tamaño limita dónde estacionás y cuánto gasta. Eso es un driver: lo que arrastra al resto.
]
La *batalla de los subsistemas*: cada uno pide masa, potencia y volumen; el
dilema del ingeniero es el triángulo de hierro como función (no se toca un
vértice sin pagar en otro). *Tres agencias, tres ciclos*: ESA (0, A a F),
NASA (Pre-A a E/F), DoD (hitos 0 a III); las letras se parecen, el contenido
no siempre.
#definicion[Presupuestos de recursos técnicos (budgets)][
  Resumen de parámetros por subsistema: masa (seca y húmeda), potencia
  (generada y necesaria por fase), apuntamiento, cobertura, enlace y tasa de
  datos, costo. Herramienta para trade-offs; con márgenes y hablando todos
  del mismo diseño.
]
#acordate[
  El presupuesto del viaje de egresados: plata, días, valijas. Si el que armó las valijas no habló con el que reservó el micro, no entran. Por eso todos los presupuestos hablan del mismo diseño.
]

#ejemplos[
  *Matriz de verificación*: «el primer modo natural del vehículo deberá ser
  mayor que 35 Hz» → ensayo en mesa vibradora, nivel vehículo, éxito si el
  modo medido supera 35 Hz. *SAC*: los ensayos del control de actitud de los
  satélites argentinos («determinar actitud», «distribuir potencia»).
]

// =====================================================================
#pagebreak(weak: true)
= Parte 6 — Clase 12: la Fase D
#origen[Apunte, módulo 45 · clase 12]

#definicion[Fase D — ensamble, integración, ensayos y lanzamiento][
  Los componentes verificados se juntan e interconectan según el plan AIT/AIV;
  el sistema se verifica, se valida y queda operando al final. Incluye
  ensayos ambientales, planes de puesta en marcha, entrenamiento de
  operadores y verificación de interfaces externas (sitio de lanzamiento,
  antenas). Se integra *también la tierra*.
]
#acordate[
  Es la semana del casamiento: llega todo, se arma el salón, se prueba el sonido, se ensaya la entrada, y el sábado se sale. La ORR pregunta si la cocina sabe cocinar en ese salón; la FRR, si se abren las puertas.
]
En la Fase D convergen los elementos de distintas organizaciones: el *ICD*
de la Fase B se prueba de verdad; hay que *leer la especificación de lo que
se compra*; y se *ensaya como se vuela*.
#definicion[ORR — Revisión de Alistamiento Operativo][
  ¿El sistema, con lo que hace posible operarlo, está listo? Lecciones
  aprendidas pasadas a operaciones, *waivers* abordados, anomalías
  documentadas, equipo, hardware, software, personal y procedimientos listos,
  acciones de la SIR cerradas.
]
#definicion[FRR — Revisión de Alistamiento para el Vuelo][
  La última, muy cerca del lanzamiento: hardware y software pasaron la V&V,
  restricciones operacionales identificadas, interfaces externas verificadas,
  ítems abiertos y waivers aceptados, riesgos residuales conocidos. Da el
  *Go / No Go*.
]
#definicion[Waiver (licencia o dispensa)][
  Aprobación formal para seguir con un requerimiento *no cumplido*, cuando el
  análisis confirma que la misión puede seguir; puede dejar restricciones
  documentadas para los operadores. No es «aprobar igual»: si había margen,
  entra; si no, lo paga el operador.
]
#acordate[
  Es el permiso para rendir aunque te faltó una asistencia: queda por escrito, se justifica y alguien firma que se hace cargo.
]

#ejemplos[
  *GPM*: un radar de JAXA en un satélite de NASA (el conector entra o no).
  *El tanque que se desintegra*: no leer la especificación de lo comprado.
  *JWST*: ensayar como se vuela. *Waiver*: propulsores que dan el 95 % del
  desempeño requerido.
]

// =====================================================================
= Parte 7 — Clase 13: interfaces, riesgo contra problema, Fase E
#origen[Apunte, módulos 46 y 47 · clase 13]

Las interfaces son el punto débil: el esfuerzo se va a los componentes
(funcionalidad, tolerancias, MTBF) y la falla aparece en la frontera. Se
identifican, se definen, se verifican; las *estándar* bajan la complejidad.
#definicion[Interfaces canónicas][
  Cuatro tipos: *conexión física* (siempre *simétrica*; se tocan, conexión
  reversible o unión permanente), *flujo de energía* (trabajo neto: eléctrico,
  térmico, RF, mecánico; P = dL/dt), *flujo de masa* (dm/dt, de fuente a
  sumidero) y *flujo de información* (siempre con *dirección*: telemetría
  baja, comandos suben).
]
#acordate[
  Conexión física: el enchufe en la pared (se tocan, y es de ida y vuelta). Energía: la corriente que pasa. Masa: el agua por la manguera. Información: el mensaje de WhatsApp, que va de uno al otro.
]
#posta[
  Para el N² del TP: cada casilla dice *qué tipo* de interfaz es y qué pasa.
  Un cable con potencia y datos son *dos* interfaces.
]
#definicion[DSM (matriz de estructura de diseño)][
  Matriz que captura la conectividad de los componentes, es decir la
  arquitectura («DSM o N²»): *simétrica* para conexiones físicas, *no
  simétrica* para flujos.
]
#definicion[Problema (riesgo materializado)][
  Evento que *está ocurriendo*, sin incertidumbre, a tratar ya. Un riesgo es
  un problema anticipado (0 % < p < 100 %); un problema es un riesgo que
  ocurrió, y puede crear riesgos nuevos.
]
#acordate[
  Riesgo: «puede que el profe tome el parcial difícil». Problema: «el parcial ya está en la mesa, y es difícil». Y el problema trae riesgos nuevos: el recuperatorio.
]
Riesgos de cualquier aspecto técnico: amenazas, madurez (*TRL, IRL, SRL*),
proveedores, madurez del diseño, plan contra desempeño. *La FRR por dentro*:
V&V completa, *ningún waiver pendiente*, riesgos residuales conocidos y
aceptables → cuenta regresiva.

*Dos maneras de mirar el fracaso.* A lo largo del ciclo la complejidad sube y
la creatividad y la ambigüedad caen. Kranz: «failure is not an option»; Musk:
«failure is an option here». Las dos valen en su lugar: la IS está en contra
de *fallar tarde*. En un accidente sin falla de componentes, el error humano
es el síntoma: faltaba el control.
#definicion[Fase E — operaciones y sostenimiento][
  Operaciones nominales y de contingencia para preservar la salud del
  spacecraft y capturar los datos durante la vida operativa aprobada, con su
  presupuesto. (La clase 13 la titula «Operaciones y Mantenimiento».) La
  Fase F la cierra: fin de vida y desorbitado.
]
#acordate[
  La Fase E es manejar el auto todos los días y hacerle el service. La F es venderlo o llevarlo al desarmadero, no «seguir manejándolo».
]
#trampa[
  La Fase E *opera*; la F *cierra*. Describir la F como «operación y
  mantenimiento» es un error que la cátedra ya marcó.
]

#ejemplos[
  *Piezas clase S*: si la entrega es dudosa, riesgo; si no llegaron,
  problema. *Kranz y Musk*: las dos frases sobre el fracaso.
]

// =====================================================================
#pagebreak(weak: true)
= Lo que puede caer, en dos líneas
#tabla((1.7fr, 2.3fr),
  [*Pregunta*], [*Respuesta*],
  [Dos técnicas y cuatro métodos para crear una arquitectura], [síntesis, descubrimiento; normativo y racional (deductivos), participativo y heurístico (inductivos)],
  [Arquitectura contra diseño], [la arquitectura fija qué variables hay; el diseño, sus valores],
  [¿Qué baseline fija la SRR? ¿y la MDR? ¿y la PDR? ¿y la CDR?], [requerimientos de sistema; funcional; asignado; producto],
  [¿Cómo se lee la matriz de funciones clave?], [por fila, la escalera concepto → baseline → completo → seguimiento; por columna, el checklist de la fase],
  [¿Qué marca un lazo en el N²?], [flujo en los dos sentidos: candidatos a un mismo subsistema],
  [WBS contra PBS], [WBS: todo el trabajo (incluye integrar y gestionar); PBS: de qué está hecho],
  [Camino crítico], [el más largo; holgura cero; fija la duración],
  [ROM y sus rangos], [±35 % antes; ±15 % con plan; ±10 % ejecutando],
  [Tres tipos de costos], [directos; directos generales del proyecto; generales y administrativos],
  [¿TRL al salir de la B? ¿y si no llega?], [6 (ambiente relevante); se madura o se compra],
  [TRL contra IRL], [madurez de la tecnología sola contra preparación para integrarse],
  [PDR contra confirmación], [el diseño; si el proyecto puede seguir a tiempo y en presupuesto],
  [Tres componentes del riesgo], [causa raíz, probabilidad, consecuencia],
  [Verificación contra validación], [el sistema correctamente (requerimientos); el sistema correcto (necesidades, en su ambiente)],
  [Cuatro métodos de verificación y sus frases], [inspección «será blanco»; análisis «probabilidad de»; demostración «será accesible»; ensayo «proveerá 50 Hz»],
  [Calificación contra aceptación], [el diseño, sobre encima del vuelo; cada unidad, sin defectos],
  [Protoflight contra prototipo], [una unidad califica y vuela; un modelo de calificación aparte],
  [AT, FT, CPT], [vida; funcional con estímulo; desempeño abarcativo en todos los modos],
  [Requerimiento contra especificación], [qué debe hacer; cómo está construido],
  [ORR contra FRR], [listo para operar; listo para volar (Go / No Go)],
  [¿Qué es un waiver?], [aprobación formal de un requerimiento no cumplido, con restricciones],
  [Cuatro interfaces canónicas], [conexión física (simétrica); energía, masa, información (dirigidos)],
  [Riesgo contra problema], [el riesgo puede pasar; el problema ya pasó],
)
