// =====================================================================
//  galeria.typ — todas las figuras del apunte, una tras otra
//
//  Existe para mirar el render sin compilar el apunte entero: la regla
//  del proyecto es que ninguna sección se cierra sin ver su página, y
//  esperar el documento completo para mirar una flecha mal puesta hace
//  que la regla se saltee sola.
//
//      typst compile biblioteca/galeria.typ biblioteca/galeria.pdf
//      compilar.bat galeria
// =====================================================================

#import "figuras.typ": *
#import "paleta.typ": *

#set page(paper: "a4", margin: 2cm, numbering: "1")
#set text(lang: "es", size: 10pt, font: ("Libertinus Serif", "Georgia"))
#set par(justify: false)
// la misma coma decimal que el apunte (plantilla.typ): sin esto las figuras con
// "0,75" salen "0, 75" acá y no en el apunte, y el lint lo frena (T1)
#show math.equation: eq => { show ",": it => math.class("normal", it); eq }

#align(center)[
  #text(size: 17pt, weight: "bold", fill: c-azul)[Galería de figuras]
  #v(-4pt)
  #text(size: 9.5pt, fill: luma(90))[Apunte de Física Espacial — para mirar el render, no para incluir]
]
#v(0.5cm)

#for (nombre, figura) in catalogo {
  block(breakable: false, width: 100%, above: 14pt, below: 14pt)[
    #text(size: 9pt, weight: "bold", fill: c-azul, tracking: 0.4pt)[#upper(nombre)]
    #v(2pt)
    #line(length: 100%, stroke: 0.4pt + luma(190))
    #v(8pt)
    #figura
  ]
}
