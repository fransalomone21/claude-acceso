// =====================================================================
//  plantilla.typ — el apunte de C de Software de Vuelo
//
//  Reusa la plantilla de la guía de IDEs (paleta, tipografía, marcas,
//  cajas y carátula: el formato de la casa, decisión del PDP del
//  2026-09-29) y le agrega dos cosas:
//    1. el MÓDULO: cada heading de nivel 1 arranca página y lleva rótulo;
//    2. el CÓDIGO: la función codigo con el nombre de un ejemplo muestra
//       ejemplos/<nombre>.c y, con salida: true, lo que imprimió DE VERDAD
//       (ejemplos/<nombre>.salida); `aviso` muestra el warning real de gcc
//       (ejemplos/<nombre>.warning). (Sin el numeral acá: el verificador
//       cuenta las citas y un comentario no es una cita.)
//
//  Ningún programa se escribe adentro del .typ. Vive en ejemplos/ como un
//  .c completo, y verificar-ejemplos.py lo compila con los flags de la
//  cátedra (-Wall -Wextra -std=c11, cero warnings), lo corre y compara su
//  salida con el .salida. Así el apunte no puede mostrar un programa que no
//  compila, ni una salida que el programa no imprime.
// =====================================================================

#import "../guia-ides/plantilla.typ": *

#let c-verde = rgb("#1E8449") // el código y lo que imprime

// ---------- Código de ejemplo ----------
#let codigo(nombre, salida: false, entrada: false, titulo: none) = {
  // La marca ESPERA-WARNING es para el verificador, no para el lector: va en la
  // ULTIMA línea del .c (así no corre la numeración que cita gcc) y no se imprime.
  let fuente = read("ejemplos/" + nombre + ".c").split("\n").filter(l => not l.contains("ESPERA-WARNING")).join("\n")
  let rotulo = [
    #text(size: 8pt, fill: c-verde, weight: "bold", tracking: 0.4pt)[
      #upper[#if titulo != none [#titulo — ]] #raw(nombre + ".c")
    ]
    #v(-6pt)
  ]
  // La plantilla común (../guia-ides/plantilla.typ) no deja partir un bloque de
  // código, para poder copiarlo entero. Uno de más de 55 líneas no entra en una
  // página y se saldría por abajo, pisando el número de página sin ningún aviso:
  // ése se muestra en DOS bloques, cortados en el renglón vacío más cercano a la
  // mitad. El rótulo va pegado al primero, y la página puede cortar entre los dos.
  let lineas = fuente.split("\n")
  let largo = lineas.len()
  if largo > 55 {
    let mitad = int(largo / 2)
    let vacios = range(largo).filter(k => lineas.at(k).trim() == "")
    let corte = if vacios.len() > 0 { vacios.sorted(key: k => calc.abs(k - mitad)).first() } else { mitad }
    block(breakable: false, above: 10pt, below: 4pt, width: 100%)[
      #rotulo
      #raw(lineas.slice(0, corte).join("\n"), lang: "c", block: true)
    ]
    block(breakable: false, above: 4pt, below: 4pt, width: 100%,
      raw(lineas.slice(corte + 1).join("\n"), lang: "c", block: true))
  } else {
    block(breakable: false, above: 10pt, below: 4pt, width: 100%)[
      #rotulo
      #raw(fuente, lang: "c", block: true)
    ]
  }
  // Lo que se "tipeó": el .entrada que verificar-ejemplos.py le pasa como stdin.
  if entrada {
    block(breakable: false, above: 2pt, below: 2pt, width: 100%,
      fill: luma(30), radius: 3pt, inset: 8pt)[
      #text(size: 7.5pt, fill: luma(170), weight: "bold", tracking: 0.4pt)[ENTRADA (lo que se tipeó; el verificador se lo pasa al programa)]
      #v(-4pt)
      #show raw: it => text(font: ("DejaVu Sans Mono", "Consolas"), size: 8pt, fill: rgb("#80D8FF"), it.text)
      #raw(read("ejemplos/" + nombre + ".entrada"))
    ]
  }
  if salida {
    let s = read("ejemplos/" + nombre + ".salida")
    block(breakable: false, above: 2pt, below: 10pt, width: 100%,
      fill: luma(30), radius: 3pt, inset: 8pt)[
      #text(size: 7.5pt, fill: luma(170), weight: "bold", tracking: 0.4pt)[SALIDA (copiada de la corrida real)]
      #v(-4pt)
      #show raw: it => text(font: ("DejaVu Sans Mono", "Consolas"), size: 8pt, fill: rgb("#B9F6CA"), it.text)
      #raw(s)
    ]
  }
}

// El warning que imprimió gcc de verdad (lo guarda verificar-ejemplos.py).
#let aviso(nombre) = block(breakable: false, width: 100%, fill: luma(30), radius: 3pt, inset: 8pt, above: 2pt, below: 10pt)[
  #text(size: 7.5pt, fill: luma(170), weight: "bold", tracking: 0.4pt)[LO QUE DICE GCC (copiado de la corrida real)]
  #v(-4pt)
  #show raw: it => text(font: ("DejaVu Sans Mono", "Consolas"), size: 7.5pt, fill: rgb("#FFD180"), it.text)
  #raw(read("ejemplos/" + nombre + ".warning"))
]

// La terminal: un comando que se tipea, con su prompt.
#let terminal(cuerpo) = block(breakable: false, width: 100%, fill: luma(30), radius: 3pt, inset: 8pt, above: 8pt, below: 10pt)[
  #text(font: ("DejaVu Sans Mono", "Consolas"), size: 8pt, fill: rgb("#E0E0E0"))[#cuerpo]
]

// ---------- El documento ----------
#let apunte(..args, body) = {
  show: guia.with(..args)
  // Cada módulo arranca en página nueva y lleva su rótulo.
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    block(above: 0pt, below: 14pt, sticky: true)[
      #text(size: 9pt, fill: c-azul, weight: "bold", tracking: 1.2pt)[MÓDULO #counter(heading).display("1")]
      #v(-6pt)
      #text(size: 19pt, fill: c-azul, weight: "bold")[#it.body]
      #v(-4pt)
      #line(length: 100%, stroke: 1.2pt + c-azul)
    ]
  }
  body
}

// Qué vas a poder hacer al terminar el módulo: va debajo del título.
#let objetivo(cuerpo) = block(width: 100%, fill: c-gris, stroke: (left: 2.5pt + c-azul),
  inset: (x: 11pt, y: 9pt), radius: (right: 3pt), below: 14pt)[
  #text(size: 9pt, weight: "bold", fill: c-azul, tracking: 0.3pt)[AL TERMINAR ESTE MÓDULO VAS A PODER]
  #v(-3pt)
  #text(size: 9.5pt)[#cuerpo]
]
