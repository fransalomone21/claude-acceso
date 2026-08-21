// =====================================================================
//  plantilla.typ — estilo del apunte de Aplicaciones de Electronica
//                  Analogica (4to Ano) - E.E.S.T. N1 Vicente Lopez
//  Compilar el documento principal, no este archivo.
// =====================================================================

// ---------- Paleta ----------
#let c-azul   = rgb("#1B4F72")   // titulos y definiciones
#let c-verde  = rgb("#1E8449")   // ejercicios resueltos
#let c-rojo   = rgb("#922B21")   // seguridad / errores frecuentes
#let c-ambar  = rgb("#B9770E")   // notas de laboratorio
#let c-viole  = rgb("#6C3483")   // vinculo con los TPs de la catedra
#let c-gris   = rgb("#F4F6F7")

// ---------- Contadores propios ----------
#let cont-ej = counter("ejercicio")

// ---------- Caja generica ----------
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

// ---------- Cajas semanticas ----------
#let definicion(titulo, cuerpo) = caja([Definicion — #titulo], c-azul, cuerpo)
#let atencion(cuerpo)           = caja([Cuidado con esto], c-rojo, cuerpo)
#let laboratorio(cuerpo)        = caja([En el laboratorio], c-ambar, cuerpo)
#let tp(titulo, cuerpo)         = caja([TP relacionado — #titulo], c-viole, cuerpo)
#let clave(cuerpo)              = caja([Idea clave], c-azul, cuerpo)

// ---------- Ejercicio resuelto (numerado por modulo) ----------
#let ejercicio(titulo, cuerpo) = {
  cont-ej.step()
  caja(
    context [Ejercicio resuelto #counter(heading).get().first().#cont-ej.get().first() — #titulo],
    c-verde,
    cuerpo,
  )
}

// ---------- Circuito en ASCII ----------
#let circuito(cap, body) = figure(
  align(center, body),
  caption: cap,
  kind: "circuito",
  supplement: [Figura],
)

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

// ---------- Apertura de modulo ----------
#let modulo(titulo, resumen) = {
  pagebreak(weak: true)
  cont-ej.update(0)
  counter(math.equation).update(0)
  counter(figure.where(kind: "circuito")).update(0)
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
    #text(size: 9.5pt, weight: "bold", fill: c-azul, tracking: 0.3pt)[QUE VAS A PODER HACER AL TERMINAR ESTE MODULO]
    #v(-2pt)
    #text(size: 9.5pt)[#resumen]
  ]
}

// ---------- Documento ----------
#let apunte(
  titulo: "",
  subtitulo: "",
  institucion: "",
  catedra: "",
  ciclo: "",
  body,
) = {
  set document(title: titulo, author: catedra)

  set page(
    paper: "a4",
    margin: (top: 2.6cm, bottom: 2.2cm, left: 2.3cm, right: 2.1cm),
    header: context {
      let n = counter(page).get().first()
      if n <= 1 { return }
      // .before(here()) deja afuera el titulo que arranca en ESTA misma pagina — el
      // encabezado se compone antes que el cuerpo — y el modulo salia con el nombre del
      // anterior. Se filtra por numero de pagina en su lugar.
      let pag = here().page()
      let previos = query(heading.where(level: 1)).filter(h => h.location().page() <= pag)
      let titulo-actual = if previos.len() > 0 {
        let h = previos.last()
        let num = counter(heading).at(h.location()).first()
        [Modulo #num — #h.body]
      } else [Apuntes de la materia]
      set text(size: 8.5pt, fill: luma(105))
      grid(
        columns: (1fr, auto),
        align(left)[#titulo-actual],
        align(right)[Aplicaciones de Electronica Analogica — 4to Ano],
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
  // La coma decimal del castellano no debe llevar espacio detras: por defecto
  // Typst la trata como separador y agrega un espacio ("15, 6" en vez de "15,6").
  show math.equation: eq => {
    show ",": it => math.class("normal", it)
    eq
  }
  set enum(indent: 6pt, spacing: 0.8em)
  set list(indent: 6pt, spacing: 0.8em, marker: ([•], [–], [·]))
  set table(stroke: 0.4pt + luma(180))

  // Titulos
  show heading.where(level: 1): it => {
    block(above: 0pt, below: 14pt)[
      #text(size: 9pt, fill: c-azul, weight: "bold", tracking: 1.2pt)[
        MODULO #counter(heading).display()
      ]
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

  // Codigo / circuitos ASCII
  show raw.where(block: true): it => block(
    width: auto,
    fill: white,
    stroke: 0.5pt + luma(185),
    radius: 3pt,
    inset: 9pt,
    align(left, text(font: ("DejaVu Sans Mono", "Consolas"), size: 8pt, it)),
  )
  show raw.where(block: false): it => text(
    font: ("DejaVu Sans Mono", "Consolas"), size: 9pt, fill: c-azul.darken(15%), it,
  )

  show figure.where(kind: "circuito"): set figure(numbering: "1")
  show figure.caption: set text(size: 9pt, fill: luma(90))
  show link: set text(fill: c-azul)
  show emph: set text(fill: black)

  // ---- Caratula ----
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
      #v(2.4cm)
      #block(width: 88%, inset: 14pt, fill: c-gris, radius: 4pt)[
        #set text(size: 10pt)
        #set par(justify: true)
        #align(left)[
          *Como usar este apunte.* Sirve para dos cosas: preparar la clase y
          estudiarla. Cada modulo abre con lo que hay que poder hacer al terminarlo,
          desarrolla la teoria con las deducciones completas — de donde sale cada
          formula, no solo cual es — y cierra con los trabajos practicos de la
          catedra que la ponen a prueba.

          Las *cajas verdes* son ejercicios resueltos paso a paso, analogos a los TPs
          y con sus mismos numeros: son modelo de resolucion, no reemplazan al
          practico. Las *cajas azules* son definiciones e ideas clave, el nucleo que
          hay que saber explicar. Las *cajas rojas* marcan los errores que mas se
          repiten en el laboratorio y en las evaluaciones. Las *cajas amarillas* son
          practica de banco: como conectar, que escala usar, que no tocar. Las
          *cajas violetas* atan cada tema con el TP correspondiente de la guia.

          El apunte tiene *dos partes*. La *Parte I* (modulos 1 a 6) sigue el temario y
          las guias de la catedra. La *Parte II* (modulos 7 a 13) desarrolla los
          fundamentos de analisis de circuitos —Kirchhoff, nodos y mallas, teoremas,
          transitorios, fasores, Bode y filtrado, cuadripolos y operacional— en el orden
          de la materia Teoria de Circuitos de la UNSAM. El anexo trae el formulario
          completo y las dos secuencias de lectura posibles.
        ]
      ]
      #v(1fr)
      #text(size: 9pt, fill: luma(120))[
        Material de estudio y de catedra. Los trabajos practicos citados
        corresponden a las guias de la materia (Prof. Guillermo Ruisi).
      ]
    ]
  ]

  // ---- Indice ----
  page(numbering: none, header: none, footer: none)[
    #text(size: 20pt, weight: "bold", fill: c-azul)[Indice]
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
