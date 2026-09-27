// =====================================================================
//  estilo.typ -- lo comun a la guia completa y a los modelos de parcial
//  Mismos colores y tipografia que el apunte (la paleta se importa, no se
//  copia), pero sin la maquinaria de modulos: estos documentos son cortos.
// =====================================================================
#import "../apunte/biblioteca/paleta.typ": *

#let documento(titulo: "", subtitulo: "", encabezado: "", body) = {
  set document(title: titulo, author: "Apunte de Física Espacial — UNSAM")
  set page(
    paper: "a4",
    margin: (top: 2.3cm, bottom: 2cm, left: 2cm, right: 2cm),
    header: context {
      if counter(page).get().first() <= 1 { return }
      set text(size: 8.5pt, fill: luma(105))
      grid(columns: (1fr, auto), align(left)[#encabezado], align(right)[Física Espacial — UNSAM])
      v(-5pt)
      line(length: 100%, stroke: 0.4pt + luma(190))
    },
    footer: context {
      set text(size: 8.5pt, fill: luma(105))
      align(center)[#counter(page).display()]
    },
  )
  set text(lang: "es", region: "ar", size: 10.5pt,
    font: ("Libertinus Serif", "Georgia", "Times New Roman"))
  set par(justify: true, leading: 0.65em, spacing: 0.9em)
  // coma decimal sin espacio detras (mismo arreglo que el apunte)
  show math.equation: eq => {
    show ",": it => math.class("normal", it)
    eq
  }
  set enum(indent: 6pt, spacing: 0.7em)
  set list(indent: 6pt, spacing: 0.7em)
  set table(stroke: 0.4pt + luma(180))
  show heading.where(level: 1): it => block(above: 18pt, below: 10pt)[
    #text(size: 16pt, fill: c-azul, weight: "bold")[#it.body]
    #v(-6pt)
    #line(length: 100%, stroke: 1pt + c-azul)
  ]
  show heading.where(level: 2): it => block(above: 14pt, below: 7pt, sticky: true)[
    #text(size: 12pt, fill: c-azul, weight: "bold")[#it.body]
  ]

  block(below: 14pt)[
    #text(size: 9pt, fill: c-azul, weight: "bold", tracking: 1.2pt)[FÍSICA ESPACIAL · UNSAM · 2026]
    #v(-4pt)
    #text(size: 22pt, fill: c-azul, weight: "bold")[#titulo]
    #v(-8pt)
    #text(size: 11pt, fill: luma(80))[#subtitulo]
    #v(-4pt)
    #line(length: 100%, stroke: 1.4pt + c-azul)
  ]
  body
}

#let caja(titulo, color, cuerpo) = block(
  width: 100%, breakable: true,
  fill: color.lighten(92%), stroke: (left: 2.5pt + color), radius: (right: 3pt),
  inset: (x: 10pt, y: 8pt), above: 8pt, below: 8pt,
)[
  #if titulo != none {
    block(sticky: true, above: 0pt, below: 5pt)[
      #text(fill: color, weight: "bold", size: 9pt, tracking: 0.3pt)[#upper(titulo)]
    ]
  }
  #cuerpo
]

#let tip(cuerpo) = block(above: 6pt, below: 4pt)[
  #text(fill: c-azul, weight: "bold", size: 9.5pt)[Tip: ]#text(size: 9.5pt)[#cuerpo]
]
#let resultado(cuerpo) = block(above: 4pt, below: 4pt)[
  #text(fill: c-verde.darken(10%), weight: "bold", size: 9.5pt)[Resultado: ]#text(size: 9.5pt)[#cuerpo]
]
#let nota(cuerpo) = block(above: 4pt, below: 4pt)[
  #text(fill: c-teal, weight: "bold", size: 9.5pt)[Ojo con el enunciado: ]#text(size: 9.5pt)[#cuerpo]
]
