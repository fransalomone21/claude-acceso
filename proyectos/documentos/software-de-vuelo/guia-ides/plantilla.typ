// =====================================================================
//  plantilla.typ — estilo de las guías de Software de Vuelo
//                  UNSAM · Ingeniería en Sistemas Espaciales
//
//  Es el formato de los apuntes (el de Física Espacial: misma paleta,
//  tipografía, títulos, marcas en el texto y cajas), recortado para una
//  guía corta: sin módulos, sin anexos, sin salto de página por sección.
//  Compilar el documento (guia-ides.typ), no este archivo.
// =====================================================================

// ---------- Paleta ----------
// Copiada de fisica-espacial/apunte/biblioteca/paleta.typ, para que las dos
// materias se vean iguales. Cada color dice una cosa y sólo una: la lista
// está en la carátula, y es el contrato con el lector.
#let c-azul = rgb("#1B4F72") // títulos e ideas clave
#let c-rojo = rgb("#922B21") // errores frecuentes
#let c-viole = rgb("#6C3483") // lo que pide la cátedra, textual
#let c-teal = rgb("#117A65") // mejoras: lo que NO es de la cátedra
#let c-rosa = rgb("#C2185B") // la posta -- la idea en criollo
#let c-gris = rgb("#F4F6F7") // fondo de cajas neutras

// ---------- Caja genérica ----------
// El título va en un block(sticky: true) para que no quede huérfano al pie
// de una página (aprendido en Física Espacial).
#let caja(titulo, color, cuerpo) = block(
  width: 100%,
  breakable: true,
  fill: color.lighten(92%),
  stroke: (left: 2.5pt + color),
  radius: (right: 3pt),
  inset: (x: 10pt, y: 9pt),
  above: 12pt,
  below: 12pt,
)[
  #block(sticky: true, above: 0pt, below: 5pt)[
    #text(fill: color, weight: "bold", size: 9.5pt, tracking: 0.3pt)[#upper(titulo)]
  ]
  #cuerpo
]

// ---------- Marcas en el texto (sin caja) ----------
// Los avisos cortos van en la prosa, con la entrada en su color: como lo
// diría un profesor en el pizarrón, sin parar la clase para enmarcarlo.
#let marca(entrada, color, cuerpo) = block(width: 100%, breakable: true, above: 10pt, below: 10pt)[
  #text(fill: color, weight: "bold")[#entrada] #cuerpo
]
#let idea(cuerpo) = marca([La idea:], c-azul, cuerpo)
#let ojo(cuerpo) = marca([Ojo:], c-rojo, cuerpo)

// ---------- Cajas ----------
#let catedra(titulo, cuerpo) = caja([Lo que pide la cátedra — #titulo], c-viole, cuerpo)
#let mejora(titulo, cuerpo) = caja([Mejora, no es de la cátedra — #titulo], c-teal, cuerpo)
#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)

#let tabla(..args) = table(
  inset: 6pt,
  stroke: 0.4pt + luma(180),
  fill: (_, y) => if y == 0 { c-gris },
  ..args,
)

// ---------- Documento ----------
#let guia(titulo: "", subtitulo: "", institucion: "", materia: "", ciclo: "", version: "", presentacion: [], body) = {
  set document(title: titulo, author: "Franco Salomone")
  set page(
    paper: "a4",
    margin: (top: 2.4cm, bottom: 2.1cm, left: 2.3cm, right: 2.1cm),
    header: context {
      let n = counter(page).get().first()
      if n <= 1 { return }
      // Sin salto de página por sección, una página puede empezar con el
      // final de una sección y seguir con otra. Manda la que ARRANCA en esta
      // página (la primera); si no arranca ninguna, la que venía de antes.
      let pag = here().page()
      let todos = query(heading.where(level: 1))
      let aca = todos.filter(h => h.location().page() == pag)
      let previos = todos.filter(h => h.location().page() < pag)
      let actual = if aca.len() > 0 { aca.first().body } else if previos.len() > 0 { previos.last().body } else [#titulo]
      set text(size: 8.5pt, fill: luma(105))
      grid(columns: (1fr, auto), align(left)[#actual], align(right)[Software de Vuelo — UNSAM])
      v(-5pt)
      line(length: 100%, stroke: 0.4pt + luma(190))
    },
    footer: context {
      let n = counter(page).get().first()
      if n <= 1 { return }
      set text(size: 8.5pt, fill: luma(105))
      align(center)[#n]
    },
  )
  set text(lang: "es", region: "ar", size: 10.5pt,
    font: ("Libertinus Serif", "Georgia", "Times New Roman"))
  set par(justify: true, leading: 0.68em, spacing: 0.95em)
  set heading(numbering: "1.1")
  set enum(indent: 6pt, spacing: 0.75em)
  set list(indent: 6pt, spacing: 0.75em, marker: ([•], [–], [·]))

  show heading.where(level: 1): it => block(above: 18pt, below: 12pt, sticky: true)[
    #text(size: 9pt, fill: c-azul, weight: "bold", tracking: 1.2pt)[SECCIÓN #counter(heading).display("1")]
    #v(-6pt)
    #text(size: 17pt, fill: c-azul, weight: "bold")[#it.body]
    #v(-4pt)
    #line(length: 100%, stroke: 1.2pt + c-azul)
  ]
  show heading.where(level: 2): it => block(above: 14pt, below: 8pt, sticky: true)[
    #text(size: 12.5pt, fill: c-azul, weight: "bold")[#counter(heading).display() #h(4pt) #it.body]
  ]
  // Un bloque de código partido entre dos páginas no se puede copiar entero.
  show raw.where(block: true): it => block(
    breakable: false, width: 100%, fill: white, stroke: 0.5pt + luma(185), radius: 3pt, inset: 9pt,
    align(left, text(font: ("DejaVu Sans Mono", "Consolas"), size: 8pt, it)),
  )
  show raw.where(block: false): it => text(font: ("DejaVu Sans Mono", "Consolas"), size: 9pt, fill: c-azul.darken(15%), it)
  show link: set text(fill: c-azul)
  // En una celda angosta, justificar estira los renglones con código.
  show table: set par(justify: false)

  // ---- Carátula, con la leyenda y el índice en la misma página ----
  page(numbering: none, header: none, footer: none, margin: (x: 2.4cm, y: 2.4cm))[
    #align(center)[
      #text(size: 10pt, tracking: 1.5pt, fill: luma(90))[#upper(institucion)]
      #v(0.15cm)
      #line(length: 45%, stroke: 0.6pt + luma(150))
      #v(1.1cm)
      #text(size: 12.5pt, fill: luma(80))[#subtitulo]
      #v(0.25cm)
      #par(justify: false)[#text(size: 23pt, weight: "bold", fill: c-azul)[#titulo]]
      #v(0.35cm)
      #line(length: 100%, stroke: 1.5pt + c-azul)
      #v(0.25cm)
      #text(size: 11pt, fill: luma(70))[#materia #h(6pt) · #h(6pt) #ciclo]
      #v(0.1cm)
      #text(size: 8.5pt, fill: luma(110))[#version]
    ]
    #v(0.8cm)
    #block(width: 100%, inset: 13pt, fill: c-gris, radius: 4pt)[
      #set text(size: 9.6pt)
      #presentacion
      #v(3pt)
      *Los colores no son adorno: cada uno dice una cosa y sólo una.*
      #v(2pt)
      #set par(justify: false)
      #grid(columns: (auto, 1fr), row-gutter: 5pt, column-gutter: 8pt,
        text(fill: c-azul, weight: "bold")[Azul], [en el texto, *La idea:* — lo que no hay que perder.],
        text(fill: c-rojo, weight: "bold")[Rojo], [en el texto, *Ojo:* — donde se traba casi todo el mundo.],
        text(fill: c-viole, weight: "bold")[Violeta], [lo que pide la cátedra, sacado de sus clases y de sus TP.],
        text(fill: c-teal, weight: "bold")[Verde azulado], [una *mejora*: algo que agregamos nosotros y *no* es de la cátedra. Se puede saltear.],
        text(fill: c-rosa, weight: "bold")[Rosa], [la posta: lo mismo, dicho en criollo y sin vueltas.],
      )
    ]
    #v(0.7cm)
    #text(size: 13pt, weight: "bold", fill: c-azul)[Índice]
    #v(-6pt)
    #line(length: 100%, stroke: 0.8pt + c-azul)
    #show outline.entry.where(level: 1): it => { v(6pt, weak: true); strong(it) }
    #outline(title: none, depth: 2, indent: 1.1em)
  ]
  counter(page).update(1)
  body
}
