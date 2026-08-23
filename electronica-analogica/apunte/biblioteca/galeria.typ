// =====================================================================
//  galeria.typ — banco de pruebas de las figuras
//
//  NO forma parte del apunte. Renderiza TODAS las figuras juntas, con
//  su nombre de funcion arriba, para poder mirarlas sin compilar las
//  43 paginas del apunte:
//
//      typst compile biblioteca/galeria.typ biblioteca/galeria.pdf
//      typst watch   biblioteca/galeria.typ biblioteca/galeria.pdf
//
//  Toda figura nueva se agrega aca ADEMAS de en su modulo. Una figura
//  que no esta en la galeria no se mira nunca.
// =====================================================================

#import "circuitos.typ": *
#import "graficos.typ": *

#set page(paper: "a4", margin: 1.6cm, numbering: "1")
#set text(lang: "es", size: 10pt, font: ("Libertinus Serif", "Georgia", "Times New Roman"))

// La MISMA regla de la coma decimal que aplica plantilla.typ. Sin esto la
// galeria compone "53, 13" donde el apunte compone "53,13", y deja de ser un
// proxy fiel de lo que se va a publicar: se mira la galeria y se aprueba algo
// que en el apunte se ve distinto. Si cambia en plantilla.typ, cambia aca.
#show math.equation: eq => {
  show ",": it => math.class("normal", it)
  eq
}

#let muestra(nombre, fig) = block(width: 100%, breakable: false, above: 14pt, below: 14pt)[
  #block(width: 100%, fill: rgb("#EEF2F5"), inset: (x: 6pt, y: 4pt), radius: 2pt)[
    #text(size: 8pt, font: ("DejaVu Sans Mono", "Consolas"), fill: rgb("#1B4F72"))[#nombre]
  ]
  #v(4pt)
  #fig
]

#align(center)[
  #text(size: 16pt, weight: "bold")[Galeria de figuras]
  #v(-4pt)
  #text(size: 9pt, fill: luma(100))[banco de pruebas — no es parte del apunte]
]

= Modulo 1 — Mediciones
#muestra("fig-conexion-instrumentos()", fig-conexion-instrumentos())
#muestra("fig-shunt()", fig-shunt())
#muestra("fig-multiplicadora()", fig-multiplicadora())
#muestra("fig-multirrango()", fig-multirrango())

= Modulo 2 — Senales
#muestra("fig-filtro-rc()", fig-filtro-rc())
#muestra("graf-formas-de-onda()", graf-formas-de-onda())

= Modulo 4 — Diodos
#muestra("graf-curva-diodo()", graf-curva-diodo())

= Modulo 3 — Transformadores
#muestra("fig-transformador()", fig-transformador())
#muestra("fig-transformador-punto-medio()", fig-transformador-punto-medio())

= Modulo 4 — Diodos (circuitos)
#muestra("fig-polarizacion-diodo()", fig-polarizacion-diodo())
#muestra("fig-led-limitadora()", fig-led-limitadora())
#muestra("fig-proteccion-polaridad()", fig-proteccion-polaridad())
#muestra("fig-rectificador-media-onda()", fig-rectificador-media-onda())
#muestra("fig-rectificador-punto-medio()", fig-rectificador-punto-medio())
#muestra("fig-puente-graetz()", fig-puente-graetz())
#muestra("graf-media-onda()", graf-media-onda())
#muestra("graf-onda-completa()", graf-onda-completa())

= Modulo 2 — Osciloscopio y filtro
#muestra("fig-bloques-osciloscopio()", fig-bloques-osciloscopio())
#muestra("graf-respuesta-rc()", graf-respuesta-rc())

= Modulo 5 — Fuentes
#muestra("fig-bloques-fuente()", fig-bloques-fuente())
#muestra("fig-filtro-capacitivo()", fig-filtro-capacitivo())
#muestra("graf-rizado()", graf-rizado())
#muestra("fig-regulador-zener()", fig-regulador-zener())
#muestra("graf-curva-zener()", graf-curva-zener())

= Modulo 6 — Transistores
#muestra("fig-simbolos-bjt()", fig-simbolos-bjt())
#muestra("fig-conmutacion-npn()", fig-conmutacion-npn())
#muestra("fig-rele-completo()", fig-rele-completo())
#muestra("graf-recta-de-carga()", graf-recta-de-carga())

= Anexos
#muestra("fig-codigo-colores()", fig-codigo-colores())
#muestra("fig-tabla-simbolos()", fig-tabla-simbolos())

= Modulo 7 — Kirchhoff y topologia
#muestra("fig-nodos-y-mallas()", fig-nodos-y-mallas())
#muestra("fig-delta-estrella()", fig-delta-estrella())

= Modulo 8 — Nodal y mallas
#muestra("fig-nodal-basico()", fig-nodal-basico())
#muestra("fig-supernodo()", fig-supernodo())
#muestra("fig-mallas-basico()", fig-mallas-basico())
#muestra("fig-supermalla()", fig-supermalla())
#muestra("fig-nodal-controlada()", fig-nodal-controlada())

= Modulo 9 — Teoremas
#muestra("fig-fuentes-reales()", fig-fuentes-reales())

= Modulo 10 — Transitorios
#muestra("fig-rc-primer-orden()", fig-rc-primer-orden())

= Modulo 11 — Fasores
#muestra("fig-rlc-serie()", fig-rlc-serie())

= Modulo 12 — Respuesta en frecuencia
#muestra("fig-pasabajos-pasaaltos()", fig-pasabajos-pasaaltos())

= Modulo 13 — Cuadripolos y AO
#muestra("fig-cuadripolo()", fig-cuadripolo())
#muestra("fig-ao-inversor-no-inversor()", fig-ao-inversor-no-inversor())
#muestra("graf-diagrama-fasorial()", graf-diagrama-fasorial())
#muestra("graf-bode-amplificador()", graf-bode-amplificador())
