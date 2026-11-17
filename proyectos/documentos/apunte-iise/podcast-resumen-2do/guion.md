# Podcast RESUMEN para el 2.° parcial de IISE (clases 7 a 13)

Fase 13 (2026-11-17). Versión corta del podcast de la fase 12: **una definición y a lo sumo un
ejemplo por concepto**, en el orden del apunte (`apunte/modulos/m24` a `m46`, impresos como
módulos 25 a 47). Cada parte abre diciendo qué módulos cubre. Formato igual que el de la fase 12
(`CARO:` / `MARTIN:` por renglón, `[PAUSA n]`, renglón en blanco = parte nueva); lo sintetiza
`../podcast-2do-parcial/sintetizar-local.py --guion` (o `sintetizar-qwen.py --guion`).

**Fuentes.** El apunte manda. Los ocho resúmenes de los amigos de Fran (Clase 8, Fase B, Ciclo de
vida NASA, Clases 10, 11 A, 11 B, 12 y 13; PDF en Descargas, 2026-11-17) se usaron para elegir
qué es lo esencial de cada clase. Lo que traen ellos y el apunte NO tiene (medido por grep sobre
m24-m46): la definición de WBS del MIL-HDBK-881, los tres niveles de la WBS (asignaciones de
trabajo, tareas, subtareas), los ensayos en el sitio de lanzamiento, los modelos ESTM y EQM con
esos nombres. Entran marcados en el guion con «en los resúmenes de los chicos».

**Fonética.** La letra sola de una fase se escribe «Fase a / be / ce / de / e» (la «C» sola sonaba
«sexo», fase 12). Las siglas nuevas, en `PRONUNCIA` de `sintetizar-local.py`.

## Guion

CARO: Bueno, versión resumen. Del segundo parcial de IISE, clases siete a trece, lo que hay que saber y nada más: una definición, un ejemplo, y a la siguiente.
MARTIN: Sin el tour completo por cada arista. Si querés el paseo largo, está el otro podcast. Este es el que escuchás la noche antes, con el mate frío.
CARO: Clase siete. Módulos veinticinco a veintiocho del apunte: arquitectura, la Fase a, sus revisiones y el diagrama ene cuadrado.
MARTIN: Arquitectura, según INCOSE: la estructura fundamental y unificada de un sistema, en términos de elementos, interfaces, procesos, restricciones y comportamientos. Es el puente entre las necesidades y el diseño.
CARO: Se crea en cuatro pasos: requerimientos iniciales con el análisis de necesidades, el alcance y el ConOps; después límites, restricciones, contexto, hipótesis y ambiente; después varias arquitecturas candidatas; y al final se comparan por beneficios, costos, riesgos y requerimientos. Y es iterativo: comparando candidatas puede cambiar el problema mismo.
MARTIN: Pregunta fija: dos técnicas y cuatro métodos. Técnicas: síntesis, que combina o modifica sistemas que ya existen, y descubrimiento, que abstrae patrones de arquitecturas conocidas para crear una nueva.
CARO: Métodos: deductivos, que son el normativo, reglas impuestas por una autoridad, y el racional, que deriva la solución de los objetivos con modelos formales. E inductivos: el participativo, por consenso con los interesados, y el heurístico, por experiencia y lecciones aprendidas.
MARTIN: Ejemplo de cuatro métodos en uno: el reglamento del consorcio, la planilla con fórmulas, la reunión de consorcio, y el portero que sabe que el caño del tercero pierde los jueves.
CARO: Arquitectura contra diseño. La arquitectura elige el concepto y la descomposición, y fija qué variables de diseño hay. El diseño elige los valores de esas variables. La arquitectura dice que el auto tiene motor adelante; el diseño, cuántos caballos.
MARTIN: Y no hay un único dibujo de la arquitectura: se describe con varias vistas. Diagrama de bloques de subsistemas, flujo de comunicaciones, flujo funcional y diagrama de interfaces.
CARO: Fase a: desarrollo del concepto y la tecnología. Toma el concepto que ganó en la pre fase a y lo convierte en una propuesta de sistema viable: refina los requerimientos de alto nivel, identifica tecnologías e interfaces críticas, estima costo y plazo, analiza riesgos y arma el SEMP, el plan de gestión de la ingeniería de sistemas.
MARTIN: El producto central es la línea de base del concepto: misión, arquitectura preliminar, requerimientos principales, estrategia tecnológica, costo del ciclo de vida y planificación. Una referencia común para que todos hablen del mismo sistema.
CARO: El ejemplo de la cátedra es el Mars 2020: heredó casi todo del Curiosity. Heredar es bajar riesgo y costo, siempre que el ambiente y la misión no cambien demasiado.
MARTIN: Al partir el sistema aparecen las interfaces. Internas, entre subsistemas, y externas, con el lanzador, el segmento terreno, el usuario y el ambiente. Las críticas se documentan en el ICD, el documento de control de interfaces, así cada equipo trabaja tranquilo sin renegociar la frontera todos los días.
CARO: Las dos revisiones de la Fase a. La ese erre erre, revisión de requerimientos del sistema: ¿los requerimientos de alto nivel son claros, coherentes con los interesados, y están bien descompuestos y asignados? Establece la línea de base de requerimientos.
MARTIN: Y la eme de erre, o ese de erre, revisión de definición de la misión: ¿el concepto es razonable, alcanzable y completo para entrar a la Fase be? Masa, potencia, costo y calendario dentro de lo disponible. Establece la línea de base funcional.
CARO: Y entre revisión y revisión, las acciones abiertas se cierran antes de seguir. Lo que la ese erre erre dejó pendiente, la eme de erre lo controla.
MARTIN: El diagrama ene cuadrado: una matriz cuadrada con los elementos en la diagonal. Las salidas de cada elemento van por su fila y las entradas por su columna. Casilla vacía, no hay interfaz; casilla llena, hay flujo.
CARO: Y lo más preguntado: los lazos de realimentación. Si dos elementos se pasan cosas en los dos sentidos, hay un lazo. Los que tienen muchos lazos entre sí conviene agruparlos en un mismo subsistema. Así el ene cuadrado te dibuja los límites naturales de los subsistemas.
MARTIN: Ejemplo: el control remoto de la tele del apunte. Botones, procesador, emisor infrarrojo. Ves al toque quién le habla a quién.
CARO: Te tiro una. ¿Qué revisión fija la línea de base funcional?
[PAUSA 3]
MARTIN: La eme de erre. La ese erre erre fija la de requerimientos.

CARO: Clase ocho. Módulos veintinueve a treinta y tres: plan de trabajo, estimaciones, el LDCM, lanzadores y diagrama funcional.
MARTIN: El plan de trabajo arranca con la WBS, la estructura de desglose del trabajo: un árbol que parte todo el trabajo del proyecto en partes manejables y asignables. Cada nodo es un entregable, y las hojas son los paquetes de trabajo, con su descripción, sus recursos y su responsable.
CARO: En los resúmenes de los chicos aparece también la definición del estándar militar ochocientos ochenta y uno: un árbol orientado al producto, con hardware, software, servicios, datos e instalaciones. Y tres niveles: asignaciones de trabajo, tareas y subtareas.
MARTIN: Se arma de arriba hacia abajo, partiendo el sistema, o de abajo hacia arriba, con una lluvia de ideas de todas las tareas que después se agrupan. La de abajo hacia arriba sirve cuando la tecnología es nueva y no tenés un proyecto parecido para copiar.
CARO: Ojo con la trampa clásica: WBS no es PBS. La PBS, desglose del producto, dice de qué está hecho el satélite. La WBS dice qué hay que hacer para construirlo. La PBS es la lista de piezas del Lego; la WBS, el instructivo.
MARTIN: Después, la red de actividades: hitos, actividades entre hitos, y duraciones. Con la pasada hacia adelante sacás las fechas más tempranas; con la pasada hacia atrás, las más tardías. La diferencia es la holgura.
CARO: Y el camino crítico es la secuencia más larga de tareas: la que fija la duración total. Holgura cero. Si se atrasa una tarea del camino crítico, se atrasa todo el proyecto.
MARTIN: Ejemplo de la cátedra: hacer un té. Calentar el agua es el camino crítico; sacar la taza tiene holgura, la podés sacar cuando quieras mientras hierve.
CARO: El Gantt es la misma red sobre el calendario: una barra por tarea. Sirve para comunicar y seguir el avance, y en el TP la cátedra pide que se vean las fases y el margen.
MARTIN: Estimar es predecir tiempo y costo de los entregables. Dos sentidos. Macro, de arriba hacia abajo: por analogía con proyectos parecidos o juicio de expertos, al principio, cuando hay poca información. Micro, de abajo hacia arriba: sumando cada paquete de la WBS, más preciso y más caro de hacer.
CARO: Y la estimación madura con las fases: en la pre fase a es gruesa, con mucha incertidumbre; en la ce y la de ya se ajusta con costos reales. Directriz que cae: varias personas independientes estiman, y no se meten contingencias adentro de cada tarea; el riesgo se evalúa aparte.
MARTIN: Recursos a estimar, además del tiempo: dinero, materiales, máquinas y gente. Y costos: directos, cargables a un paquete; directos generales del proyecto; y generales y administrativos de la organización.
CARO: El LDCM, la continuidad de Landsat, es el ejemplo de Fase a de punta a punta: de la meta a los objetivos, los requerimientos de alto nivel, y un concepto que cambió durante la fase, de instrumentos en otro satélite a plataforma propia. La lección: el concepto se mueve en la Fase a, y está bien que se mueva ahí y no después.
MARTIN: Lanzadores: un satélite mira el lanzador porque el lanzador le impone el ambiente, la masa y el volumen. El Falcon nueve es el ejemplo de perfil de misión y operación en tierra.
CARO: Y el diagrama funcional: bloques con las funciones y flechas con los flujos, con leyenda para cada tipo de conexión, datos, potencia, mecánico. La cátedra lo enseña con el ROV, el submarino, y el mismo sistema se puede mostrar con más o menos zoom.
MARTIN: La pregunta de esta parte. ¿Qué tiene de especial el camino crítico?
[PAUSA 3]
CARO: Holgura cero: es la secuencia más larga y fija la duración del proyecto.

MARTIN: Clase nueve. Módulos treinta y cuatro a treinta y siete: la plantilla de requerimientos, la Fase be, la madurez tecnológica y la Fase ce.
CARO: La plantilla de requerimientos de la cátedra: identificador, origen, enunciado con deberá, fuente y fecha, método de verificación, satisfacción, costo y riesgo, relacionados, rationale y aprobaciones. Y las interfaces externas con el lanzador: mecánicas, eléctricas y de ambiente.
MARTIN: Fase be: diseño preliminar. Es la última de la formulación, y demuestra que la misión es técnica y programáticamente viable. Termina el árbol de requerimientos trazable, desarrolla los planes de verificación y validación, y deja un plan de implementación con costo, cronograma y riesgos.
CARO: El umbral que hay que saber: toda tecnología crítica tiene que llegar a TRL seis antes de salir de la Fase be. TRL seis es un prototipo demostrado en un ambiente relevante, no en el laboratorio. Si no llega, no pasa a la ce: o se madura, o se compra algo que ya vuele.
MARTIN: Esa es la decisión de hacer o comprar, y se documenta en la línea de base del diseño preliminar. El ejemplo del apunte es el TESS: madurar tecnología cuesta plata, y conviene gastarla temprano.
CARO: La escala TRL, nueve niveles: uno, principios básicos observados; tres, prueba de concepto; cuatro, validado en laboratorio; cinco, validado en ambiente relevante; seis, prototipo demostrado en ambiente relevante; siete, prototipo en ambiente operativo; ocho, calificado para la misión; nueve, probado en misión.
MARTIN: El IRL mide lo que el TRL no ve: si la pieza está lista para integrarse con las demás. Podés tener una cámara con TRL nueve y un IRL bajo porque nunca la enchufaste a tu satélite. Integrar no es armar.
CARO: Y el SRL junta los dos, para la madurez del sistema entero. Es material de estudio, menos preguntado.
MARTIN: La revisión de la Fase be es la pe de erre, revisión de diseño preliminar: ¿el diseño cumple todos los requerimientos, trazables, completos y verificables, con márgenes de masa, potencia y temperatura, y con las tecnologías en el TRL pedido? Establece la línea de base asignada.
CARO: Y después viene la revisión de confirmación, independiente: ¿la misión cumple la ciencia, la gestión alcanza, y el costo y el calendario dan para llegar a tiempo? Con eso se pasa el ka de pe ce y empieza la implementación.
MARTIN: Fase ce: diseño final y fabricación. Se hace el diseño de detalle, se fabrican y verifican los componentes antes de integrar, y es la fase donde la curva del gasto se dispara.
CARO: Sus revisiones: la ce de erre, revisión crítica de diseño, que dice que el diseño de detalle está completo y listo para fabricar. Y la ese i erre, revisión de integración del sistema, que dice que todo está listo para empezar a integrar.
MARTIN: Ejemplo del apunte: el lanzador que llega tarde y obliga a revisar el diseño. Lo externo también mueve la Fase ce.
CARO: Te pregunto. ¿Qué TRL hay que tener al salir de la Fase be, y por qué?
[PAUSA 3]
MARTIN: Seis: probado en un ambiente relevante, así en la ce ya no hay sorpresas de tecnología.

CARO: Clase diez. Módulos treinta y ocho a cuarenta: forma, función e ingeniería inversa, la pe de erre del ROV y la gestión del riesgo.
MARTIN: Arquitectura es la asignación de la función a la forma, mediada por el concepto. Función: lo que el sistema hace. Forma: lo que el sistema es, lo que se construye, hardware, software, y existe antes de que la función se ejecute. Concepto: la idea que une las dos.
CARO: La ingeniería inversa es la arquitectura al revés: partís de la forma que existe y deducís las funciones y el concepto. Lo que hacés con BLACK, sin el código fuente.
MARTIN: Y la materia es un proyecto por la metodología ce de i o: concebir, diseñar, implementar y operar. Se centra en formular el problema más que en la solución, y usa un currículum integrado: las disciplinas siguen, pero se aplican en proyectos.
CARO: La pe de erre, contada con el ROV: tres metas. Validar la definición del problema, discutir tres o más diseños viables con sus pros y contras, y acordar el elegido. Y en la presentación: lo aprendido, los diseños, el costo, un plan con tiempo de sobra para validar, y los riesgos contados con honestidad.
MARTIN: Riesgo: la combinación de la probabilidad de un evento no deseado y su consecuencia. Tiene tres componentes: causa raíz, probabilidad y consecuencia. Y el evento puede ser técnico o programático: sobrecosto, atraso, seguridad, ambiente.
CARO: Categorías: técnico, de costo y de cronograma, y el programático que los combina. El técnico suele ser el origen: un problema técnico te sube el costo y te atrasa. Y en capas: adentro, lo que el equipo controla; afuera, lo político y el mercado, que casi no podés tocar.
MARTIN: La gestión del riesgo es un ciclo: identificar, analizar, planificar, seguir, controlar, comunicar y documentar. La identificación se hace con una lluvia de ideas con todas las disciplinas.
CARO: Y la matriz de NASA: probabilidad contra consecuencia, cada una de uno a cinco. Arriba a la derecha, rojo: se trata ya. Ojo que la escala se declara antes, porque la cátedra mostró convenciones al revés.
MARTIN: Y el cierre filosófico: la seguridad es una propiedad emergente. Componentes confiables pueden dar un sistema inseguro por cómo interactúan. Por eso existe STAMP, de Nancy Leveson: el accidente es una restricción de seguridad que el control no supo mantener, no sólo una cadena de fallas.
CARO: Su técnica es STPA, que busca acciones de control inseguras antes del accidente, a diferencia del efe eme e a, que busca qué pieza puede fallar. Y CAST es el mismo enfoque aplicado después del accidente.
MARTIN: Pregunta. ¿Cuáles son los tres componentes de un riesgo?
[PAUSA 3]
CARO: Causa raíz, probabilidad y consecuencia.

MARTIN: Clase once. Módulos cuarenta y uno a cuarenta y cuatro: verificación del producto, modelos y ensayos, el AIT de un subsistema, y subsistemas con presupuestos.
CARO: Verificación: ¿construimos el sistema correctamente? Compara contra los requerimientos. Validación: ¿construimos el sistema correcto? Compara contra la necesidad del interesado. Se puede verificar todo perfecto y fallar la validación.
MARTIN: La validación de requerimientos va temprano, en la Fase be, idealmente antes de la ese erre erre. La verificación del producto va en la Fase de, en la rama que sube de la V. Pero el plan se arma desde que se escribe cada requerimiento: la matriz de verificación preliminar.
CARO: La matriz de verificación conecta cada requerimiento con su método, su nivel, el criterio de éxito, quién lo hace y la evidencia. Ejemplo: la frecuencia natural del vehículo deberá ser mayor que treinta y cinco hercios; se verifica por ensayo en mesa vibradora, a nivel vehículo.
MARTIN: Los cuatro métodos, y la frase que los delata. Inspección: mirar, pesar, medir sin equipo especial; tendrá el logo, será blanco. Análisis: cálculo o simulación cuando ensayar no se puede; será diseñado para, tendrá una probabilidad de.
CARO: Demostración: operarlo y observar, sin instrumentación elaborada; será accesible. Y ensayo: equipo e instrumentos especiales, condiciones controladas, el preferido; proveerá cincuenta hercios.
MARTIN: La filosofía de modelos dice cuántos modelos se construyen. Prototipo: varios modelos, uno de calificación y otro de vuelo; más caro, menos riesgo. Protovuelo: una sola unidad que se califica y vuela; más barato, más riesgo. E híbrida: calificación para lo crítico, protovuelo para el resto.
CARO: Calificación contra aceptación. La calificación prueba el diseño, con niveles más altos que los de vuelo, sobre un modelo que no vuela. La aceptación prueba cada unidad fabricada: que sea idéntica a la calificada y sin defectos de fabricación.
MARTIN: Ensayos ambientales: se simula el antes del lanzamiento, transporte y manipulación; el lanzamiento, vibración, acústica, aceleración, choque pirotécnico y despresurización; y la órbita, vacío térmico y radiación. Son la parte más grande de la campaña.
CARO: Los ensayos de un subsistema, del más rápido al más profundo: el de vida, que sólo mira que prenda y responda la telemetría; el funcional, con estímulo externo en el modo principal; y el de desempeño abarcativo, todos los modos, incluidos los de contingencia y los redundantes. Ejemplo del apunte: el control de actitud de los satélites SAC.
MARTIN: En los resúmenes de los chicos están también los del sitio de lanzamiento: la prueba de fugas, el desempeño abarcativo repetido después del transporte, la verificación del umbilical y el ensayo general de la misión.
CARO: Y el cierre de la clase: requerimiento no es especificación. El requerimiento dice qué debe hacer el sistema y cuán bien. La especificación dice cómo está construido: materiales, dimensiones, planos.
MARTIN: Los subsistemas compiten por masa, potencia y volumen, y por eso la ingeniería se hace con presupuestos: masa, potencia, datos, enlace, costo, con margen, y todos hablando del mismo diseño.
CARO: Te la tiro. ¿Qué método de verificación delata la frase «tendrá una probabilidad de»?
[PAUSA 3]
MARTIN: Análisis. No podés ensayar una probabilidad: la calculás.

CARO: Clase doce. Módulo cuarenta y cinco: la Fase de.
MARTIN: Fase de: ensamble, integración, ensayo y lanzamiento. Los componentes verificados se integran según el plan AIT, el sistema integrado se verifica y se valida, se entrenan los operadores, y al final se integra al lanzador y se lanza.
CARO: Y se integra también la tierra: el manejo de datos, las antenas, los procedimientos de los operadores. Todo eso se ensaya antes del lanzamiento. Ejemplo del apunte: el JWST, ensayar como se vuela.
MARTIN: Primera revisión: la o erre erre, revisión de preparación operativa. ¿El sistema, la gente, el hardware, el software y los procedimientos están listos para operar? Y los waivers: las dispensas firmadas cuando algo no cumple pero la misión puede seguir. Si el propulsor da el noventa y cinco por ciento, se analiza, se firma y se le avisa al operador.
CARO: Segunda: la efe erre erre, revisión de alistamiento para el vuelo, la última antes del lanzamiento. Todo verificado y validado, las restricciones operativas conocidas, las interfaces externas verificadas. Decide el Gou o Nou Gou.

MARTIN: Clase trece. Módulos cuarenta y seis y cuarenta y siete: interfaces y riesgo otra vez, con la Fase e.
CARO: Las interfaces son el punto débil típico: el esfuerzo se va a los componentes y la falla aparece en la frontera. Por eso se identifican, se definen y se verifican, y se usan interfaces estándar.
MARTIN: Los cuatro tipos canónicos. Conexión física, siempre simétrica: si A toca a B, B toca a A; un tornillo con su tuerca. Flujo de energía: intercambio neto de trabajo, eléctrico, térmico, de radiofrecuencia o mecánico.
CARO: Flujo de masa: materia que pasa de una fuente a un sumidero, como el combustible al motor. Y flujo de información, siempre con dirección: la telemetría baja del satélite al operador, y los comandos suben.
MARTIN: Riesgo contra problema. Un riesgo es futuro, con probabilidad entre cero y cien por ciento. Un problema ya pasó: probabilidad cien. Si la entrega de piezas clase ese es dudosa, es un riesgo; si no llegaron, es un problema. Y un problema genera riesgos nuevos.
CARO: La efe erre erre por dentro: confirma que toda la verificación y validación terminó, que no quedan dispensas pendientes y que los riesgos residuales son conocidos y aceptables. Recién ahí arranca la cuenta regresiva.
MARTIN: Y la Fase e: operar. El sistema hace la misión, se mantiene, y se cierra en la Fase efe con el fin de vida y el desorbitado.
CARO: Última. ¿Cuál es la diferencia entre riesgo y problema?
[PAUSA 3]
MARTIN: El riesgo puede pasar; el problema ya pasó. Y con eso, cerramos. Suerte en el parcial.
