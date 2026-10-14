// =====================================================================
//  estilo.typ -- los resumenes para parcialito de IISE
//  Mismos colores y tipografia que el apunte (la paleta se importa, no se
//  copia), sin la maquinaria de modulos: un resumen es corto. Sale del
//  estilo de los resumenes de Fisica Espacial (practica/estilo.typ).
// =====================================================================
#import "../apunte/biblioteca/paleta.typ": *

#let documento(titulo: "", subtitulo: "", encabezado: "", body) = {
  set document(title: titulo, author: "Apunte de IISE — UNSAM")
  set page(
    paper: "a4",
    margin: (top: 2.3cm, bottom: 2cm, left: 2cm, right: 2cm),
    header: context {
      if counter(page).get().first() <= 1 { return }
      set text(size: 8.5pt, fill: luma(105))
      grid(columns: (1fr, auto), align(left)[#encabezado], align(right)[IISE — UNSAM])
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
  show math.equation: eq => {
    show ",": it => math.class("normal", it)
    eq
  }
  set enum(indent: 6pt, spacing: 0.7em)
  set list(indent: 6pt, spacing: 0.7em)
  set table(stroke: 0.4pt + luma(180))
  show heading.where(level: 1): it => block(above: 18pt, below: 10pt, sticky: true)[
    #text(size: 16pt, fill: c-azul, weight: "bold")[#it.body]
    #v(-6pt)
    #line(length: 100%, stroke: 1pt + c-azul)
  ]
  show heading.where(level: 2): it => block(above: 13pt, below: 7pt, sticky: true)[
    #text(size: 12pt, fill: c-azul, weight: "bold")[#it.body]
  ]

  block(below: 14pt)[
    #text(size: 9pt, fill: c-azul, weight: "bold", tracking: 1.2pt)[INTRODUCCIÓN A LA INGENIERÍA DE SISTEMAS ESPACIALES · UNSAM · 2026]
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

// Qué clase y qué diapositivas, y qué módulo del apunte lo desarrolla.
#let origen(cuerpo) = block(above: 2pt, below: 6pt, text(size: 9pt, fill: luma(90), style: "italic", cuerpo))
// La definición con la palabra de la cátedra: lo que se escribe en el parcialito.
#let definicion(titulo, cuerpo) = caja([Definición — #titulo], c-azul, cuerpo)
// El ejemplo de la clase, contado de nuevo.
#let ejemplo(titulo, cuerpo) = caja([El ejemplo de la clase — #titulo], c-verde, cuerpo)
// El error que se paga.
#let trampa(cuerpo) = caja([Ojo], c-rojo, cuerpo)
// La idea en criollo.
#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)
// Tabla chica sin justificar, con letra un punto más chica.
#let tabla(cols, ..celdas) = {
  set par(justify: false)
  align(center, table(columns: cols, inset: (x: 6pt, y: 3.5pt), align: left,
    ..celdas.pos().map(c => text(size: 9.5pt, c))))
}
// Una caja de la red de actividades (el té): nombre y duración.
#let nodo(nombre, t, color: c-azul) = box(
  stroke: 0.7pt + color, fill: color.lighten(90%), radius: 2pt,
  inset: (x: 4pt, y: 3pt),
)[#text(size: 8pt)[#nombre] #text(size: 8pt, weight: "bold", fill: color)[#t]]
#let fl = text(size: 9pt, fill: luma(110))[ → ]
