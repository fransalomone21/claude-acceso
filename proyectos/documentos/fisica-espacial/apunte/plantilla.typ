// =====================================================================
//  plantilla.typ — estilo del apunte de Física Espacial
//                  UNSAM · Ingeniería en Sistemas Espaciales
//  Compilar el documento principal (apunte.typ), no este archivo.
// =====================================================================

// La paleta vive en biblioteca/paleta.typ para que las figuras usen los
// mismos colores sin importar este archivo (sería un ciclo). Los imports
// de abajo re-exportan las figuras: cada módulo hace
// `#import "../plantilla.typ": *` y con eso ya tiene fig-*.
#import "biblioteca/paleta.typ": *
#import "biblioteca/figuras.typ": *

// ---------- Contadores propios ----------
#let cont-ej = counter("ejemplo")

// ---------- Caja genérica ----------
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
  #text(fill: color, weight: "bold", size: 9.5pt, tracking: 0.3pt)[#upper(titulo)]
  #v(-3pt)
  #cuerpo
]

// ---------- Cajas semánticas ----------
//
// Cada color quiere decir una cosa y sólo una. La lista está en la
// carátula, y es el contrato con el lector: si un cuadro ámbar apareciera
// alguna vez por algo que no es geometría, los otros veinte dejan de
// significar lo que dicen.

#let definicion(titulo, cuerpo) = caja([Definición — #titulo], c-azul, cuerpo)
#let clave(cuerpo) = caja([Idea clave], c-azul, cuerpo)

// El corazón del apunte: de dónde sale la fórmula que se acaba de usar.
#let deduccion(titulo, cuerpo) = caja([De dónde sale — #titulo], c-azul.darken(15%), cuerpo)

#let cuidado(cuerpo) = caja([Cuidado con esto], c-rojo, cuerpo)

// Lo que se pide explícitamente: dónde se pierde el planteo. Respecto de
// qué punto se toma el momento, qué versor es radial, qué ángulo entra en
// el seno, en qué sistema de referencia vale lo que se escribió.
#let geometria(cuerpo) = caja([Cuidado geométrico y vectorial], c-ambar, cuerpo)

// Los tres libros de la cátedra usan letras distintas para las mismas
// cantidades — Beer llama H al momento angular y L a la cantidad de
// movimiento, justo al revés que la cátedra. Eso no es un detalle: es una
// fuente de error de signo y de concepto en el parcial.
#let notacion(cuerpo) = caja([Ojo con la notación], c-teal, cuerpo)

#let guia(titulo, cuerpo) = caja([De la guía de la cátedra — #titulo], c-viole, cuerpo)

// ---------- Ejemplo resuelto (numerado por módulo) ----------
// `nivel` distingue el ejemplo que fija el mecanismo del que tiene el
// nivel de la guía. Cada módulo lleva por lo menos uno de cada uno.
#let ejemplo(titulo, cuerpo, nivel: "simple") = {
  cont-ej.step()
  let etiqueta = if nivel == "simple" { "Ejemplo" } else { "Ejemplo a fondo" }
  caja(
    context [#etiqueta #counter(heading).get().first().#cont-ej.get().first() — #titulo],
    c-verde,
    cuerpo,
  )
}

// ---------- Figura ----------
#let fig(cap, body) = figure(align(center, body), caption: cap, kind: "fig", supplement: [Figura])

// ---------- Divisor de parte ----------
#let parte(numero, titulo, bajada) = {
  pagebreak(weak: true)
  page(numbering: none, header: none, footer: none, margin: (x: 2.6cm, y: 3.4cm))[
    #align(center + horizon)[
      #text(size: 10.5pt, tracking: 2pt, fill: luma(110))[#upper[Parte #numero]]
      #v(0.25cm)
      #line(length: 32%, stroke: 0.6pt + luma(160))
      #v(0.9cm)
      #text(size: 27pt, weight: "bold", fill: c-azul)[#titulo]
      #v(0.5cm)
      #line(length: 100%, stroke: 1.5pt + c-azul)
      #v(1.1cm)
      #block(width: 90%, inset: 14pt, fill: c-gris, radius: 4pt)[
        #set text(size: 10pt)
        #set par(justify: true)
        #align(left)[#bajada]
      ]
    ]
  ]
}

// ---------- Apertura de módulo ----------
#let modulo(titulo, resumen) = {
  pagebreak(weak: true)
  cont-ej.update(0)
  counter(math.equation).update(0)
  counter(figure.where(kind: "fig")).update(0)
  counter(figure.where(kind: table)).update(0)
  heading(level: 1, titulo)
  block(
    width: 100%,
    fill: c-gris,
    stroke: (left: 2.5pt + c-azul),
    inset: (x: 11pt, y: 10pt),
    radius: (right: 3pt),
    below: 16pt,
  )[
    #text(size: 9.5pt, weight: "bold", fill: c-azul, tracking: 0.3pt)[QUÉ VAS A PODER HACER AL TERMINAR ESTE MÓDULO]
    #v(-2pt)
    #text(size: 9.5pt)[#resumen]
  ]
}

// ---------- Sección sin número (va ANTES de los módulos) ----------
// Un heading de nivel 1 con `numbering: none` no incrementa el contador de
// headings, así que el bloque de convenciones puede ir al frente sin correr
// la numeración de los módulos. La contrapartida: adentro no van headings
// de nivel 2 o 3, porque se numerarían "0.1".
#let seccion(titulo, resumen) = {
  pagebreak(weak: true)
  cont-ej.update(0)
  counter(math.equation).update(0)
  counter(figure.where(kind: "fig")).update(0)
  counter(figure.where(kind: table)).update(0)
  heading(level: 1, numbering: none, titulo)
  block(
    width: 100%,
    fill: c-gris,
    stroke: (left: 2.5pt + c-azul),
    inset: (x: 11pt, y: 10pt),
    radius: (right: 3pt),
    below: 16pt,
  )[
    #text(size: 9.5pt, weight: "bold", fill: c-azul, tracking: 0.3pt)[PARA QUÉ SIRVE ESTA SECCIÓN]
    #v(-2pt)
    #text(size: 9.5pt)[#resumen]
  ]
}

// ---------- Documento ----------
#let apunte(titulo: "", subtitulo: "", institucion: "", catedra: "", ciclo: "", body) = {
  set document(title: titulo, author: catedra)

  set page(
    paper: "a4",
    margin: (top: 2.6cm, bottom: 2.2cm, left: 2.3cm, right: 2.1cm),
    header: context {
      let n = counter(page).get().first()
      if n <= 1 { return }
      // .before(here()) deja afuera el título que arranca en ESTA misma
      // página —el encabezado se compone antes que el cuerpo— y el módulo
      // salía con el nombre del anterior. Se filtra por número de página.
      let pag = here().page()
      let previos = query(heading.where(level: 1)).filter(h => h.location().page() <= pag)
      let titulo-actual = if previos.len() > 0 {
        let h = previos.last()
        if h.numbering == none {
          h.body
        } else {
          let num = counter(heading).at(h.location()).first()
          [Módulo #num — #h.body]
        }
      } else [Apunte de la materia]
      set text(size: 8.5pt, fill: luma(105))
      grid(
        columns: (1fr, auto),
        align(left)[#titulo-actual],
        align(right)[Física Espacial — UNSAM],
      )
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

  set text(
    lang: "es",
    region: "ar",
    size: 10.5pt,
    font: ("Libertinus Serif", "Linux Libertine O", "Georgia", "Times New Roman"),
  )
  set par(justify: true, leading: 0.68em, spacing: 0.95em)
  set heading(numbering: "1.1.1")
  set math.equation(numbering: "(1)")
  // La coma decimal del castellano no debe llevar espacio detrás: por
  // defecto Typst la trata como separador y agrega uno ("15, 6" en vez de
  // "15,6").
  show math.equation: eq => {
    show ",": it => math.class("normal", it)
    eq
  }
  set enum(indent: 6pt, spacing: 0.8em)
  set list(indent: 6pt, spacing: 0.8em, marker: ([•], [–], [·]))
  set table(stroke: 0.4pt + luma(180))

  // Títulos
  show heading.where(level: 1): it => {
    let rotulo = if it.numbering == none [SECCIÓN PRELIMINAR] else [
      MÓDULO #counter(heading).display()
    ]
    block(above: 0pt, below: 14pt)[
      #text(size: 9pt, fill: c-azul, weight: "bold", tracking: 1.2pt)[#rotulo]
      #v(-6pt)
      #text(size: 19pt, fill: c-azul, weight: "bold")[#it.body]
      #v(-4pt)
      #line(length: 100%, stroke: 1.2pt + c-azul)
    ]
  }
  show heading.where(level: 2): it => block(above: 16pt, below: 8pt)[
    #text(size: 13pt, fill: c-azul, weight: "bold")[
      #counter(heading).display() #h(4pt) #it.body
    ]
  ]
  show heading.where(level: 3): it => block(above: 12pt, below: 6pt)[
    #text(size: 11pt, fill: c-azul.darken(10%), weight: "bold")[
      #counter(heading).display() #h(4pt) #it.body
    ]
  ]

  show raw.where(block: true): it => block(
    width: auto,
    fill: white,
    stroke: 0.5pt + luma(185),
    radius: 3pt,
    inset: 9pt,
    align(left, text(font: ("DejaVu Sans Mono", "Consolas"), size: 8pt, it)),
  )
  show raw.where(block: false): it => text(
    font: ("DejaVu Sans Mono", "Consolas"),
    size: 9pt,
    fill: c-azul.darken(15%),
    it,
  )

  show figure.where(kind: "fig"): set figure(numbering: "1")
  show figure.caption: set text(size: 9pt, fill: luma(90))
  show link: set text(fill: c-azul)
  show emph: set text(fill: black)

  // ---- Carátula ----
  page(numbering: none, margin: (x: 2.6cm, y: 3.2cm))[
    #align(center)[
      #v(1.2cm)
      #text(size: 10.5pt, tracking: 1.5pt, fill: luma(90))[#upper(institucion)]
      #v(0.2cm)
      #line(length: 45%, stroke: 0.6pt + luma(150))
      #v(1.8cm)
      #text(size: 13pt, fill: luma(80))[#subtitulo]
      #v(0.35cm)
      #par(justify: false)[#text(size: 31pt, weight: "bold", fill: c-azul)[#titulo]]
      #v(0.5cm)
      #line(length: 100%, stroke: 1.5pt + c-azul)
      #v(0.35cm)
      #text(size: 12pt, fill: luma(70))[#catedra #h(6pt) · #h(6pt) #ciclo]
      #v(2.0cm)
      #block(width: 92%, inset: 14pt, fill: c-gris, radius: 4pt)[
        #set text(size: 9.7pt)
        #set par(justify: true)
        #align(left)[
          *Cómo está escrito este apunte.* Con una regla sola: se deduce lo que
          cambia el entendimiento y se cita lo que sólo cambia el álgebra. Ninguna
          fórmula aparece de la nada —si se afirma que a cierta velocidad tangencial
          un satélite orbita sin caer, la cuenta que lleva hasta ahí está escrita—,
          y ningún despeje mecánico ocupa media página.

          *Los cuadros de colores no son adorno; cada color dice una cosa y sólo una:*

          #v(3pt)
          #set par(justify: false)
          #grid(
            columns: (auto, 1fr),
            row-gutter: 5pt,
            column-gutter: 8pt,
            text(fill: c-azul, weight: "bold")[Azul],
            [definiciones, ideas clave y las deducciones — de dónde sale cada fórmula.],

            text(fill: c-verde, weight: "bold")[Verde],
            [ejemplos resueltos. Cada módulo lleva al menos uno *simple*, que fija el
             mecanismo, y uno *a fondo*, del nivel de la guía de la cátedra.],

            text(fill: c-ambar, weight: "bold")[Ámbar],
            [cuidado geométrico y vectorial: respecto de qué punto, qué versor, qué
             ángulo, en qué sistema de referencia. Es donde se pierde el planteo.],

            text(fill: c-rojo, weight: "bold")[Rojo],
            [los errores que más se repiten.],

            text(fill: c-teal, weight: "bold")[Verde azulado],
            [choques de notación entre los libros. El Beer llama $H$ al momento
             angular y $L$ a la cantidad de movimiento: justo al revés que la cátedra.],

            text(fill: c-viole, weight: "bold")[Violeta],
            [el problema de la guía de la cátedra que ese tema resuelve.],
          )
        ]
      ]
      #v(1fr)
      #text(size: 8.7pt, fill: luma(120))[
        Material de estudio. Toda afirmación cita su fuente entre paréntesis, con
        sección y página impresa del libro.
      ]
    ]
  ]

  // ---- Índice ----
  page(numbering: none, header: none, footer: none)[
    #text(size: 20pt, weight: "bold", fill: c-azul)[Índice]
    #v(0.3cm)
    #line(length: 100%, stroke: 1pt + c-azul)
    #v(0.4cm)
    #show outline.entry.where(level: 1): it => {
      v(9pt, weak: true)
      strong(it)
    }
    #outline(title: none, depth: 2, indent: 1.1em)
  ]

  counter(page).update(1)
  body
}
