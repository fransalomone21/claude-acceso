// =====================================================================
//  plantilla.typ — guía para el cuestionario de Leandro.
//  Es la de la guía de IDEs (misma paleta, carátula y cajas) más cuatro
//  piezas de estudio: #gancho / #duda / #dedos (los cuatro tiempos de cada
//  tema, como en Física Espacial), #pregunta (cuestionario con respuesta),
//  #diapo (una figura recortada de las clases) y #nota (un rótulo escrito
//  encima de la figura, en coordenadas relativas).
//  Compilar guia.typ con --root en la carpeta del proyecto (software-de-vuelo).
// =====================================================================

#import "../guia-ides/plantilla.typ": *

#let c-verde = rgb("#1E8449") // con los dedos
#let c-viol2 = rgb("#5B2C6F") // la duda, en la voz del lector
#let c-naranja = rgb("#D35400") // rótulos escritos encima de las diapositivas

#let gancho(cuerpo) = marca([Para qué sirve:], c-rosa, cuerpo)
#let duda(cuerpo) = marca([La duda:], c-viol2, cuerpo)
#let dedos(cuerpo) = marca([Con los dedos:], c-verde, cuerpo)

// Una pregunta de cuestionario con su respuesta. No se parte entre páginas.
#let pregunta(p, r) = block(
  width: 100%, breakable: false, above: 8pt, below: 8pt,
  inset: (x: 9pt, y: 7pt), radius: 3pt, stroke: 0.5pt + luma(190),
)[
  #text(weight: "bold", fill: c-azul)[P. ] #p \
  #text(weight: "bold", fill: c-verde)[R. ] #r
]

// Un rótulo encima de una figura: (x, y) en fracciones del ancho y del alto.
#let nota(x, y, cuerpo) = place(top + left, dx: x * 100%, dy: y * 100%,
  box(fill: white.transparentize(8%), stroke: 0.8pt + c-naranja, radius: 2pt, inset: (x: 3pt, y: 2pt),
    text(size: 7.6pt, fill: c-naranja, weight: "bold", cuerpo)))

// Una figura de las clases de Leandro, con su origen en el epígrafe.
// `notas` es un arreglo de (x, y, contenido) que se escriben encima.
#let diapo(archivo, ancho: 100%, notas: (), origen) = figure(
  box(width: ancho)[
    #image("fig-catedra/" + archivo + ".png", width: 100%)
    #for (x, y, c) in notas { nota(x, y, c) }
  ],
  caption: text(size: 8.5pt)[#origen],
  kind: image,
  supplement: [Figura],
)
