#import "../plantilla.typ": *

#modulo(
  "Cómo se crea una arquitectura: síntesis, descubrimiento y los factores de balance",
  [Distinguir síntesis de descubrimiento como las dos técnicas para crear
   una arquitectura; ubicar los cuatro métodos —normativo, racional,
   participativo, heurístico— dentro de esas dos técnicas; explicar los
   factores que se balancean al elegir una arquitectura candidata; y separar
   con precisión arquitectura de diseño.],
  clave: "crear-arquitecturas",
)

#lectura[
  Clase 7, diapositivas 6 a 15.
]

== Arquitectura: otras dos definiciones

La unidad 2 ya definió #t[arquitectura de sistema]. La cátedra agrega dos
definiciones más, de fuentes distintas, que no contradicen a la anterior
—la completan desde otro ángulo—:

#posta[
  *INCOSE:* "la estructura fundamental y unificada del sistema, definida en
  términos de elementos del sistema, interfaces, procesos, restricciones y
  comportamientos." *Departamento de Defensa de EE.UU. (DoD Architecture
  Framework v1.0):* "la estructura de componentes, sus relaciones, y los
  principios y guías que gobiernan su diseño y su evolución en el tiempo."
]

#clave[
  Las tres definiciones —la de la unidad 2, la de INCOSE y la del DoD—
  describen la misma cosa con tres vocabularios distintos: entidades y
  relaciones (unidad 2), elementos e interfaces (INCOSE), componentes y
  principios de evolución (DoD). Ninguna es más correcta que las otras — son
  la misma idea vista con tres énfasis.
]

== Cómo se desarrolla una arquitectura, paso a paso

#clave[
  Crear una arquitectura es el *comienzo* del proceso de diseño: establece
  el enlace entre los requerimientos y el diseño. La secuencia típica: *(1)*
  establecer los requerimientos iniciales por análisis de necesidades,
  alcance y ConOps; *(2)* definir límites externos, restricciones, contexto,
  hipótesis y ambiente; *(3)* desarrollar arquitecturas candidatas como
  parte de un proceso *iterativo*, usando esos requerimientos iniciales; y
  *(4)* comparar, para cada candidata, beneficios, costos, riesgos y
  requerimientos, considerando el ConOps y el desempeño de cada una.
]

#deduccion("por qué el proceso es recursivo, no lineal")[
  El desarrollo de arquitecturas candidatas se apoya en preguntas que
  retroalimentan al planteamiento del problema: ¿qué necesidades tratamos
  de llenar? ¿son insuficientes las soluciones actuales? ¿están completas
  las necesidades descritas? ¿qué tan distintos son los sistemas heredados
  en el uso? A medida que se comparan candidatas, trabajar con los
  interesados puede *modificar el enunciado del problema* — el flujo va de
  necesidades a ConOps a requerimientos funcionales a arquitecturas, y
  *vuelve* a las necesidades cuando una opción de solución revela algo que
  el planteamiento original no había capturado.
]

== Dos técnicas, cuatro métodos

#definicion("síntesis y descubrimiento (crear arquitecturas)")[
  Las dos técnicas primarias para crear una arquitectura de sistema, las
  dos beneficiadas por entender el desempeño y las limitaciones de los
  sistemas heredados. La *síntesis* modifica o combina sistemas existentes
  para satisfacer necesidades nuevas. El *descubrimiento* usa el
  conocimiento de arquitecturas existentes —con habilidad de abstracción—
  para descubrir una nueva.
]

#definicion("métodos de creación de arquitectura (normativo, racional, participativo, heurístico)")[
  Cuatro métodos que apoyan a la síntesis y al descubrimiento. *Basados en
  ciencia (deductivos):* *normativo* (reglas estrictas ya dadas) y
  *racional* (soluciones derivadas de objetivos, con técnicas formales y
  optimizadas). *Basados en arte (inductivos):* *participativo* (consenso
  de grupos, interesados involucrados) y *heurístico* (reglas blandas,
  manejadas por la experiencia y lecciones aprendidas).
]

#posta[
  No hay un método "correcto": un proyecto con reglas ya fijadas por una
  agencia (por ejemplo, un estándar de interfaz obligatorio) usa el método
  normativo aunque el equipo prefiera resolver todo desde cero; un dominio
  sin precedentes fuerza al heurístico, aunque nadie lo haya elegido a
  propósito. El método lo determina cuánta estructura previa *ya existe*,
  no la preferencia del arquitecto.
]

== Los factores que se balancean

#definicion("factores de balance de la arquitectura")[
  Los factores que la ingeniería de sistemas equilibra al elegir entre
  arquitecturas candidatas: *requerimientos del sistema*, *función*,
  *forma*, sencillez, robustez, asequibilidad, complejidad, imperativos
  ambientales y factores humanos.
]

#clave[
  *La esencia de la arquitectura, en una frase: estructurar, simplificar,
  comprometer y balancear.* La elección de un concepto de referencia
  (#t[baseline]) se hace *a pesar de* incertidumbres típicamente grandes y,
  a veces, de prioridades ambiguas de los clientes — no después de
  resolverlas.
]

== Arquitectura contra diseño, sin ambigüedad

Acá se cierra, con la #t[arquitectura de sistema] ya definida en la unidad
2, la comparación que esa unidad dejó pendiente.

#cuidado[
  *Arquitectura y diseño son dos funciones de la ingeniería de sistemas con
  usos distintos, no dos nombres para lo mismo.* La arquitectura se usa
  para: establecer el marco que restringe el espacio de soluciones del
  diseño posterior; respaldar decisiones de fabricar o comprar; discriminar
  entre alternativas; y "descubrir" los requerimientos o las prioridades
  verdaderas. El diseño se usa para: desarrollar componentes que cumplan
  los requerimientos y restricciones; construir el sistema; y entender el
  efecto dominó de un cambio de configuración sobre todo el sistema.
]

== Cómo se describe una arquitectura

#definicion("descripciones de arquitectura (vistas)")[
  Ninguna figura o diagrama, por sí solo, puede capturar la arquitectura
  completa de un sistema: hace falta usar varias vistas a la vez.
  Principales: *renderings* del *spacecraft* y diagramas de bloques de
  subsistemas; diagramas de flujo de comunicación; diagramas de flujo
  funcionales; y diagramas de interfaces de subsistemas —frecuentemente
  capturados con la #t[tabla N² (diagrama N²)]—.
]

#posta[
  La analogía que da la cátedra es exacta: estas vistas son a la
  arquitectura de un sistema espacial lo que los planos, cotas, elevaciones,
  plantas, presupuestos y planos de cableado son a un edificio, en la
  ingeniería civil. Nadie construye un edificio con un solo plano; nadie
  entiende un *spacecraft* con un solo diagrama.
]

== Resumen del módulo

#clave[
  Crear una arquitectura es una función de la ingeniería de sistemas, y es
  el primer paso para traducir un problema en una solución — un proceso
  *repetitivo e iterativo* que arranca planteando el problema, genera
  candidatas, evalúa sus méritos y elige una. No es determinista, pero
  entender sistemas heredados o análogos es un primer paso valioso. Ninguna
  vista sola la captura completa.
]
