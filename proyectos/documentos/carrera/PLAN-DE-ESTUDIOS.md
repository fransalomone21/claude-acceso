# Contenidos mínimos — Ingeniería en Sistemas Espaciales (UNSAM)

**Textual**, tal como lo pasó Fran el 2026-10-02 (pegado en el chat, sin
indicar el documento de origen: probablemente la resolución del plan de
estudios). No se resume ni se corrige: es la **línea de base oficial** de qué
tiene que cubrir cada materia. Lo que el profesor pide en su cursada vive en
el repo privado `catedras`; lo que cada materia **tiene** y **le falta**, en
[`MATERIAS.md`](MATERIAS.md).

**Para qué sirve:** es el piso, no el techo. Un apunte que cubre el programa
del profesor y deja afuera un contenido mínimo tiene un hueco; uno que agrega
lo que el profesor da y acá no figura, no (ej.: el amplificador de
instrumentación está en el programa de Sanca para TDC aunque acá figure en
ISE10).

Se busca por código: `ISE03`, `ISE10`…

---

## (ISE01) Introducción a la ingeniería de sistemas espaciales

Ingeniería de sistemas como el arte del manejo de la complejidad. Trabajo en equipo y liderazgo. Ciclo de vida de un proyecto. Descripción de cada fase. Hitos e instancias de revisión. Stakeholders de un proyecto. Iniciativa CDIO (Concebir, diseñar, implementar y operar). Conceptos de alcance y de operación. Requerimientos: tipos, trazabilidad, configuración. Fundamentos de diseño, interfaces internas y externas. Matriz N2, verificación y validación. Diagramas de Gantt, QFD, PERT.

## (ISE02) Física espacial

Vectores en el espacio. Operaciones con vectores. Vectores en la Física. Gravedad. Dinámica de Newton, problema de los dos cuerpos. Experimentos cruciales que dieron nacimiento a la Física cuántica. Radiación de un cuerpo negro. Efecto fotoeléctrico. Modelo atómico. Espectros atómicos y moleculares. Postulados de la Mecánica Cuántica. Función de onda y ecuación de Schrödinger. Momento angular intrínseco. Principio de exclusión de Pauli. Partículas subatómicas. Relatividad especial. Elementos de Física nuclear.

## (ISE03) Teoría de circuitos

Circuitos en corriente continua, leyes y teoremas de circuitos: nodos, mallas, Thévenin, Norton, máxima transferencia de energía. Circuitos en corriente alterna. Potencia y sistemas trifásicos. Cuadripolos: tipos más usuales. Respuesta en frecuencia: función transferencia en el dominio operacional. Diagramas de Bode. Amplificadores operacionales: amplificador de tensión, amplificador operacional ideal y filtros activos. Señales en el dominio del tiempo y de la frecuencia. Respuesta temporal: resolución de circuitos mediante la transformada de Laplace.

## (ISE04) Programación

Programación en C++ y en Python: planteo de diagramas de flujo y pseudocódigo, sintaxis del lenguaje, estructuras de datos y objetos, desarrollo de algoritmos, funciones, desarrollo de scripts y librerías, manejo de archivos, análisis y visualización de datos, modelado matemático, métodos numéricos; desarrollo integral de un simulador de un sistema espacial, presentación de resultados. Programación de un sistema embebido simple comunicado con sensores y actuadores con un objetivo definido.

## (ISE05) Proyecto integrador 1

Infraestructura para el aprendizaje activo entrelazando sus conocimientos básicos. Gestión del proyecto. Ingeniería de Sistemas. Trabajo en equipo. Habilidades de medición y ensayos. Desarrollo de habilidades de escritura de documentos y presentación oral y escrita. Implementación y Operación del sistema (CDIO, Concebir, diseñar, implementar y operar) en el nivel de desarrollo de las/los estudiantes. Durante el proyecto se promueve el aprendizaje activo (estándar 8 del CDIO). Revisiones estándar NASA: MCR (Mission Concept Review) PDR (Preliminary Design Review) CDR (Critical Design Review).

## (ISE06) Termodinámica

Calor y trabajo. Primer principio de la termodinámica. Gases ideales y reales. Transformaciones. Segundo principio de la termodinámica. Teoría cinética de los gases. Estadística de Maxwell-Boltzmann. Teorema de Carnot. Teorema de Clausius. Entropía. Transferencia de calor. Problemas de transporte. Ecuación de difusión del calor. Regla de las fases. Máquinas Térmicas. Clasificación. Ciclos ideales y límites.  Motores a explosión. Motores a compresión. Ciclos de vapor.  Turbinas de gas. Ciclos Combinados.

## (ISE07) Ciencia de materiales

Conceptos básicos de Ingeniería de los Materiales. Estructuras, propiedades mecánicas y manufactura. Prestaciones tecnológicas. Técnicas de optimización de los materiales, modificación de sus propiedades mediante tratamientos. Relación entre propiedades y microestructura. Propiedades eléctricas, magnéticas, térmicas y ópticas.

## (ISE08) Astrodinámica I

Ecuación de movimiento. Leyes de Kepler. Elementos orbitales clásicos. Órbitas circulares y elípticas. Trayectorias parabólicas e hiperbólicas. Tiempo de vuelo. Representación del estado de un satélite. Conversión de elementos orbitales a posición y velocidad. Modelos de Tierra. Tiempos: Solar, Universal, Sideral, Atómico, GPS. Transformaciones de coordenadas celestes y terrestres. Ecuación ideal del cohete. Maniobras. Transferencia de Hohmann. Rendez-vous. Observaciones de ángulos de elevación, azimut y rango. Fuerzas perturbadoras: campo gravitatorio, frenado atmosférico, perturbaciones de tercer cuerpo.

## (ISE09) Proyecto integrador 2

Se comienza a profundizar la fase de diseño, continuando con la implementación y operación del sistema producto acentuando en complejidad las fases y sus revisiones MCR (Mission Concept Review), PDR (Preliminary Design Review), CDR (Critical Design Review). Se continúa con el desarrollo de habilidades personales e interpersonales. Estas son parte del desarrollo progresivo de las competencias genéricas, su distinción de entendimiento y puesta en práctica.

## (ISE10) Circuitos electrónicos

Electrónica analógica y digital. Amplificador operacional real. Amplificador de diferencias, instrumentación, sensado de corriente, comparadores. Mediciones electrónicas. Multímetros, osciloscopios y generadores de funciones. El diodo ideal y real. Parámetros. Modelos de dispositivos. Tipos de análisis. Diseño y simulación de circuitos. Electrónica digital básica: programación de microcontroladores. Aspectos específicos del diseño de hardware y software electrónico para el espacio. Descripción de la topología de un circuito. Diseño de circuitos impresos: Circuitos esquemáticos. Librerías.

## (ISE11) Introducción a estructuras y resistencia de materiales

Sistemas de fuerzas. Equilibrio de cuerpos rígidos. Determinación e indeterminación estática. Sistemas reticulados isostáticos. Fuerzas internas en sistemas de alma llena. Momentos de inercia de áreas. Resistencia de los materiales - conceptos de tensión y deformación. Ley de Hooke. Coeficiente de Poisson. Transformación de esfuerzo y deformación. Circulo de Mohr. Coeficiente de seguridad. Carga axial, torsión, flexión y corte. Diagramas de esfuerzos característicos. Flujo de corte. Pandeo en columnas. Principio de los trabajos virtuales flexión y deformación en placas.

## (ISE12) Control térmico de vehículos espaciales

Transferencia de calor, cargas térmicas y balance térmico. Flujo solar, infrarrojo terrestre y de albedo solar absorbido e incidente. Ecuación diferencial de transferencia de calor. Hardware de control térmico pasivo y activo. Acabados superficiales / revestimientos, envejecimiento de las propiedades termo ópticas, mantas térmicas diferentes tipos, radiadores, calefactores, heat pipes, louvers / shutters, doublers, enfriadores termoeléctricos, materiales de cambio de fase. Análisis térmico. Determinación de las cargas térmicas externas. Método de diferencias finitas y de elementos finitos.

## (ISE13) Proyecto integrador 3.1

Comienza el recorrido completo del ciclo de vida de un proyecto de un sistema espacial durante los cuatro siguientes cuatrimestres. En contacto con los clientes el equipo de proyecto trabaja desde las necesidades de estos definiendo la arquitectura del sistema. Los requerimientos funcionales dan lugar a la selección de la forma concretándose en el desarrollo de los conceptos. Se evalúan las posibles tecnologías y el grado de su madurez. Se realizan las revisiones correspondientes.

## (ISE14) Manufacturas avanzadas

Fundamentos y aplicaciones de manufacturas convencionales y no convencionales. Técnicas y materiales de manufacturas aditivas: Foto polimerización; Fusión de lecho de polvo; Inyección de aglutinante; Inyección de material; Laminación de hojas; Extrusión de material; Deposición directa de energía. Procesos y herramientas de diseño. Estudio y optimización de topología y masa producto. Flujo de trabajo. Análisis y simulaciones estructurales por elementos finitos. Ingeniería inversa, escaneo 3D, nube de puntos y reconocimiento de operaciones.

## (ISE15) Telecomunicaciones espaciales

Fundamentos de Sistemas de Comunicación Espaciales, Unidades y medidas, medios de enlace y Espectro electromagnético, tipos de enlaces, segmentos y funciones (terrestre, espacial), identificación de requerimientos, criterios de selección de arquitecturas, los radioenlaces en las diferentes fases de una misión. Radio Enlaces: Propagación de ondas de radio, efectos atmosféricos, Polarización. Requerimientos y funciones de los diferentes tipos de enlaces, Diseño de enlace para diferentes fases de la misión, variación de enlace durante una pasada, segmento espacial, segmento de tierra. Antenas.

## (ISE16) Mecánica de fluidos

Cinemática de fluidos, vector torbellino, campo de velocidad y campo de aceleración, deformaciones en un fluido, tensor de deformación viscoso. Líneas de corriente trayectoria y flujo. Número de Reynolds. Capa límite laminar y turbulenta. Tensor de tensiones. Dinámica y teoremas de conservación de la dinámica, principio de conservación de la masa, conservación de la energía y conservación de la cantidad de movimiento. Análisis dimensional. Flujo viscoso incompresible interno, pérdida de carga en accesorios y cañerías.

## (ISE17) Proyecto integrador 3.2

En contacto con los clientes el equipo de proyecto trabaja desde sus necesidades definiendo la arquitectura del sistema. Los requerimientos funcionales dan lugar a la selección de la forma concretándose en el desarrollo de los conceptos. La evaluación de estos permite elegir los lineamientos del sistema. Se realizan las revisiones correspondientes con revisores externos del área. Desarrollo de habilidades personales e interpersonales y desarrollo progresivo de las competencias.

## (ISE18) Estructuras espaciales

Diseño estructural y criterios de dimensionamiento: conceptos y reglas del diseño. Estudios de configuración. Casos de carga. Factores de diseño y márgenes de seguridad. Análisis estático y dinámico: cargas ambientales dinámicas: aleatorias, acústicas, shock y sinusoidales. Elementos estructurales, modos de falla. Estructuras sándwich. Análisis dinámico preliminar.  Mecanismos: especificación y métodos de verificación.

## (ISE19) Aerodinámica

Flujo unidireccional isotrópico en régimen subsónico y supersónico. Flujo isoentrópico a través de conductos de sección variable y tobera de Laval. Performance de tobera convergente-divergente. Fenómenos de discontinuidad. Ondas de choque normales y oblicuas. Variación de la presión, temperatura a través de la expansión de Prandtl-Meyer. Energía interna y energía restituida por el fluido. Longitud máxima alcanzada hasta bloque sónico. Flujo viscoso externo. Capa límite con y sin transferencia de calor.

## (ISE20) Arquitectura de sistemas

Sistema de interés, actores, stakeholders, función. Convergencia multidisciplinaria. Creatividad y heurística. Liderazgo relacional. Requerimientos del Cliente vs. Requerimientos de Ingeniería, Reglas de escritura. Requerimientos a la par de V&V (Validación y verificación). Siete (7) Herramientas de convergencia. Necesidades del Cliente. Atributos de diseño. Métodos de captura de requerimientos.Ciclo de vida INCOSE (International Council On Systems Engineering) y NASA. Diferencia entre arquitectura, modelo y sistema.

## (ISE21) Proyecto integrador 4.1

Completando la fase A hacia la fase B. continúan aplicándose las mismas consignas que el PI anterior. Nuevamente revisores externos evalúan el proyecto y son los que habilitan la continuación a la fase siguiente. Se realizará un PDR con revisores externos y se continúa también con el desarrollo progresivo de las competencias genéricas, distinción entendimiento y puesta en práctica. Profesionales del área que corresponda serán parte del staff del proyecto dando módulos técnicos específicos necesarios.

## (ISE22) Ambiente espacial

El Sol: estructura. Ciclo solar, espectro. Emisiones en la cromosfera y la corona. Plasmas espaciales. Reconexión magnética. Ondas de plasma. Viento solar. El campo magnético interplanetario. Modelos de flujo de partículas (electrones, protones, rayos cósmicos galácticos). Concepto de dosis, dosis equivalente. Método de Monte Carlo. Programas de simulación: OMERE, SPENVIS. Interacción plasma-spacecraft. Magnetopausa. Magnetocola. Plasmasfera y Cinturones de Van Allen. Anomalía del Atlántico Sur. Endurecimiento y espacialización de componentes. Estándares NASA, ESA y MIL. Efectos por Radiación. Tipos de daño.

## (ISE23) Introducción al Control moderno

Ecuación de estado. Linealización. Desigualdades lineales matriciales (LMI). Solución de la ecuación de estado. Descomposición modal. Estabilidad de Lyapunov. Estabilidad externa. Controlabilidad y observabilidad. Descomposición de Kalman. Realimentación del vector estados. Filtro de Kalman. Control LQG. Inclusiones diferenciales. Sistemas politópicos. LQG vía LMIS. Ubicación de polos vía LMIS. Introducción a sistemas LPV. Introducción al control robusto de sistemas politópicos. Función de transferencia. Función de transferencia de lazo. Criterio de Nyquist. Análisis en el dominio de la frecuencia.

## (ISE24) Ingeniería de productos de la observación de la Tierra

Mercado Espacial. Observación de la Tierra. IoT (Internet of things). Upstream. Downstream. Desarrollo de Producto. Lean. Agile Scrum. Canvas. Modelos de negocio. Tecnologías. Procesamiento de imágenes; Ópticas, SAR (Radar de apertura sintética en inglés), otros sensores. Sistemas Geoespaciales. Cloud Computing, Edge Computing. Big Data, Inteligencia Artificial.

## (ISE25) Proyecto integrador 4.2

Cerrando el desarrollo del proyecto elegido se integrarán, ensayarán y verificarán los modelos de ingeniería y serán operados en un entorno simulado. Se utilizarán simuladores de las partes más onerosas y del entorno espacial de la puesta en órbita, implementando técnicas de Hardware in the Loop permitiendo recrear todo el sistema desarrollado de punta a punta (end to end). Llegaremos finalmente a las metas del desarrollo progresivo de las competencias genéricas, en su distinción, entendimiento y puesta en práctica.

## (ISE26) Modelado y simulación de vehículos espaciales

Marcos y sistemas de coordenadas. Tensor de rotación. Cinemática tensorial. Ecuaciones de actitud. Dinámica de traslación Tensorial. Transformaciones de Coriolis y Grubin. Implementación de simulaciones. Dinámica de traslación de sistemas de varios cuerpos. Tensor de inercia. Momentum angular. Ecuación de Euler tensorial. Dinámica de Actitud para Sistemas de varios cuerpos. Modelado de Subsistemas para la Simulación 3-dof.

## (ISE27) Sensores remotos

Cargas Útiles ópticas:  aspectos de un Sistema Óptico: Observación de la Tierra – Observación extraterrestre – Comunicaciones - Requerimientos – Interpretación: Ventanas Atmosféricas – FOV – Swath Resolución - Comunicaciones - Sensores y Tecnologías: CCD, INGAAS, Micro bolómetros, HgCdTe, CMOS. Materiales ópticos, tipos de Sistemas Ópticos. Alta resolución, Alta sensibilidad. Espectrómetros, Sensores con filtros pasa bandas (pros y contras), Ejemplos de algunos sistemas. Materiales Ópticos.  Cargas Útiles de RF: Transmisores y receptores. Ecuación de radar. Efectos de propagación.

## (ISE28) Sistemas de potencia

Batería primaria, celdas de combustible, nuclear-termoeléctrico, sistema fotovoltaico con batería secundaria. Paneles solares, baterías, regulador shunt. Tipos de arquitectura y modos de operación. Celda solar fotovoltaica: circuito eléctrico equivalente y curva característica. Distintas tecnologías. Generación de un módulo FV y estimación de degradación. Almacenamiento de energía: baterías, principio de funcionamiento, tipos de baterías y tecnologías asociadas. Ciclo de vida de baterías espaciales. EMI EMC (Interferencia y compatibilidad electromagnéticas), fuentes de interferencia electromagnética.

## (ISE29) Derecho, Política y Economía espacial

Conjunto de normas y relaciones jurídicas que surgen de la actividad espacial en el ámbito nacional e internacional. Corpus iuris spatialis: origen, desarrollo y estado actual. El derecho espacial como elemento para garantizar el desarrollo y la continuidad de proyectos estratégicos. El lugar del espacio en la geopolítica. Relaciones internacionales y política espacial. La dimensión de la economía política del espacio.

## (ISE30) Propulsión

Ecuación del empuje. Impulso específico y total. Velocidad de escape efectiva. Ley de Tsiolkovsky y aplicaciones. Fracción de masa inerte y de propelente. Proceso de diseño. Análisis de misión. Propulsor de gas frío. Termoquímica: energía de enlace, método del calor disponible y productos de combustión. Sistemas de propulsión con propelentes líquidos, sólidos, híbridos, nucleares y eléctricos. Balística de motor híbrido. Selección de propulsor eléctrico y potencia espacial.

## (CMP01) Higiene y seguridad ambiental y laboral

Aspectos normativos, legales y éticos. Legislación aplicable. Seguridad, elementos de protección. El ambiente laboral. El impacto ambiental de los establecimientos industriales. Conservación del medio ambiente y los recursos naturales. Normas de Gestión ambiental.

## (ISE31) Aviónica de sistemas espaciales

Funciones en lanzadores. Funciones en satélites. Actividades y tareas, Drivers de diseño, costos, estándares, disciplinas. Concepción desde AI&T (Assembly, integration and test). Mapeo de Pines, Harness y Sistemas de Gestión de Interfases eléctricas. Ingeniería del sistema eléctrico. Ensayos de calificación, aceptación y filosofía de modelos. Mantenibilidad, Disponibilidad, Safety. Redundancia. Confiabilidad.

## (ISE32) Práctica profesional supervisada

Realización de un trabajo en o para una empresa productora de bienes o servicios, laboratorio de investigación del sector espacial u organismo de investigación y/o desarrollo o de regulación o gestión, con la debida supervisión docente, con el objeto de dar oportunidad a la/el estudiante de realizar una tarea práctica que lo acerque a diversas características del ejercicio profesional.
