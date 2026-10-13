#import "../plantilla.typ": *

#anexo(
  "A",
  "El trabajo práctico final (MCR): dónde está cada sección en el apunte",
  [La consigna del trabajo final pide un informe de _Mission Concept Review_
   de una misión satelital en órbita baja, en cinco secciones. Esta tabla
   dice, para cada cosa que pide, qué módulos del apunte la explican. No
   agrega contenido: apunta al que ya está.],
)

La consigna (2.º cuatrimestre de 2026) pide desarrollar conceptualmente una
misión satelital en *órbita terrestre baja* —de observación de la Tierra,
telecomunicaciones o ciencia—, «desde la identificación de la necesidad
hasta el MCR», con un informe en Arial 12, interlineado 1,15 y márgenes de
2,5 cm, que lleve portada, índice, lista de figuras, *lista de acrónimos*,
conclusiones y bibliografía. El MCR se hace ante *revisores externos*, y el
informe se entrega el día de la revisión.

#figure(
  table(
    columns: (1.5fr, 2fr, 1.6fr),
    align: (left, left, left),
    stroke: 0.4pt + luma(180),
    [*Sección de la consigna*], [*Qué pide*], [*Dónde está*],
    [Contexto: qué es un MCR], [la revisión que cierra la Pre-Fase A], [módulos #M("ciclo-de-vida-y-diagrama-en-v") y #M("ciclo-de-vida-a-fondo-y-modelos")],
    [1. Planteamiento de la misión], [el Ejercicio de Alcance, en orden: necesidad → metas → objetivos → hipótesis → misión → restricciones → autoridades → ConOps → requerimientos], [módulos #M("verificacion-validacion-y-alcance") y #M("el-alcance-en-la-practica"); un ejemplo completo en #M("el-ldcm")],
    [2. Desglose del sistema], [diagrama N² con interfaces internas y externas], [módulos #M("relaciones-n2-emergentes"), #M("el-diagrama-n2-aplicado") y #M("fase-a-a-fondo") (interfaces internas y externas)],
    [], [diagrama de bloques funcional y de subsistemas], [módulos #M("el-diagrama-funcional"), #M("el-ldcm") (plataforma y carga útil) y #M("el-pdr-de-un-rov")],
    [3. Ambiente de misión], [el entorno donde va a operar el sistema], [módulos #M("familia-de-requerimientos-y-trazabilidad") (requerimientos ambientales) y #M("el-diagrama-funcional") (el ambiente manda)],
    [], [consideraciones de lanzamiento], [módulos #M("lanzadores"), #M("plantilla-e-interfaces-externas") y #M("fase-c-a-fondo") (el lanzador que llega tarde)],
    [4. Requerimientos de la misión], [en «formato NASA»], [módulos #M("familia-de-requerimientos-y-trazabilidad") (niveles L0, L1…), #M("escribir-buenos-requerimientos") y #M("plantilla-e-interfaces-externas") (la plantilla de la cátedra)],
    [5. Planificación del proyecto], [WBS; Gantt hasta el MCR, con margen], [módulos #M("el-plan-de-trabajo") y #M("estimaciones")],
    [], [análisis y matriz de riesgos], [módulo #M("gestion-del-riesgo")],
    [La revisión], [presentar ante revisores externos], [módulo #M("el-pdr-de-un-rov") (qué cubrir y cómo presentar)],
  ),
  caption: [Cada sección de la consigna del trabajo final, con los módulos que la explican.],
)

#posta[
  El MCR es una revisión *de Pre-Fase A*: lo que se aprueba es la necesidad,
  el concepto y quiénes son los interesados. Los requerimientos son
  preliminares, el diagrama de bloques no lleva números de parte y el costo
  es, como mucho, una estimación gruesa con su rango. Poner diseño de detalle
  no suma: muestra que no sabés en qué fase estás.
]
