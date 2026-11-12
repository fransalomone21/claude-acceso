// =====================================================================
//  dudas.typ -- la duda primero, después con los dedos, y la burbuja
//
//  Pedido de Fran, 2026-11-12, sobre el cuerpo rígido (módulos 18 en
//  adelante) y la guía del parcialito de CMG: «antes de cualquier
//  explicación teórica, de cualquier nuevo concepto o caso, hacé la
//  explicación con los dedos», «primero generá las posibles dudas, y después
//  las explicaciones que abracen esas dudas», y «en el pie de las páginas,
//  como burbujitas, que te recuerde qué es cada cosa y en qué contexto».
//
//  Y enseguida, el mismo día: «quiero que cada tema lo vendas: que me
//  generes una curiosidad, para qué sirve, qué información te da, dónde hay
//  complejidad y dónde simplicidad; como un cuento, pero formal».
//
//  Las cuatro piezas, en este orden por tema, y por qué ninguna es una caja
//  (regla propia 8: los avisos cortos viven en la prosa con su entrada en
//  color, no en recuadros):
//
//  #gancho[...]  para qué sirve el tema, qué información da, qué
//                consecuencias tiene en un sistema de verdad y dónde está lo
//                complicado y lo simple. Narrado, formal, sin fórmulas. Rosa,
//                el color de la posta: es la misma voz.
//  #duda[...]    la pregunta que se haría el lector, en su voz y entre
//                comillas, ANTES de explicar nada. Violeta.
//  #dedos[...]   la explicación muy simple, sin fórmulas o con una sola, que
//                contesta esa duda. Recién después viene lo formal. Verde.
//  #burbuja[...] nota al pie, en un globito teal: qué es una letra, respecto
//                de qué punto, quién la mide y en qué ejes se escribe. Se
//                cuelga de un símbolo que vuelve a aparecer lejos de donde se
//                presentó. Es la hermana de #repaso() (que remite a una
//                deducción): ésta remite a un significado.
//
//  Vive en un solo archivo y la importan el apunte (plantilla.typ) y la
//  práctica (estilo.typ): un dato que vive en dos lados diverge.
// =====================================================================
#import "paleta.typ": *

// La duda es «sticky» y no se parte: nunca queda al pie de una página
// separada de lo que la contesta (medido en la guía de CMG: la duda al pie de
// la 10 y su respuesta arriba de la 11). El gancho NO: es un párrafo que se
// sostiene solo, y pegado a la duda arrastraba los dos a la página siguiente
// y dejaba cuartos de página en blanco (m19, 2026-11-12).
#let gancho(cuerpo) = block(width: 100%, breakable: true, above: 10pt, below: 8pt)[
  #text(fill: c-rosa, weight: "bold")[Para qué sirve:] #cuerpo
]

#let duda(cuerpo) = block(width: 100%, breakable: false, sticky: true, above: 11pt, below: 5pt)[
  #text(fill: c-viole, weight: "bold")[La duda:] #text(style: "italic")[«#cuerpo»]
]

#let dedos(cuerpo) = block(width: 100%, breakable: true, above: 5pt, below: 10pt)[
  #text(fill: c-verde, weight: "bold")[Con los dedos:] #cuerpo
]

// Ancho fijo, apenas menos que el renglón: así el número de la nota queda al
// lado del globito y no solo en un renglón arriba (pasaba con los largos).
#let burbuja(cuerpo) = footnote(box(
  width: 100% - 1.4em,
  fill: c-teal.lighten(90%),
  stroke: 0.5pt + c-teal.lighten(45%),
  radius: 5pt,
  inset: (x: 5pt, y: 2.5pt),
  baseline: 2.5pt,
)[#text(fill: c-teal, weight: "bold")[Recordá — ]#cuerpo])
