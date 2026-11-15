// =====================================================================
//  workflow.typ -- el workflow de un problema de cuerpo rigido
//
//  Pedido de Fran, 2026-11-15: «la guia completa de cuerpo rigido resuelta,
//  con la idea conceptual y el paso a paso, tipo workflow que marca Anibal»;
//  «el quiere que desarrollemos la capacidad de armar un workflow y de
//  plantear los problemas siempre, y saber todo lo conceptual con su
//  utilidad». El molde sale de la resolucion manuscrita del Problema 7 que
//  subio Anibal (Ej 7 CR, 2026-11-15): datos -> sistema en el CM -> H antes
//  -> impulso y H despues (constante) -> theta -> omega por componentes ->
//  gamma y directa/retrograda -> ley de los senos -> conclusiones.
//
//  Lo importan resueltos-cr.typ y resueltos-cr-extras.typ: los dos documentos
//  usan los MISMOS ocho pasos con los MISMOS nombres, para que el lector los
//  reconozca de un problema al otro. Un paso que no aplica no se saltea: se
//  escribe en una linea por que no aplica (eso tambien es plantear).
// =====================================================================
#import "estilo.typ": *

// Los ocho pasos. El numero y el nombre son fijos: se llaman con W(n).
#let pasos-w = (
  "Datos y qué se pide",
  "Sistema de referencia",
  "Qué actúa, y qué se conserva",
  "El momento angular, componente a componente",
  "La ecuación que manda",
  "La geometría: ángulos, conos y sentido",
  "Verificación por otro camino",
  "Conclusiones: qué pasa, y qué pasaría si…",
)

#let W(n) = block(above: 11pt, below: 4pt, sticky: true)[
  #box(fill: c-azul, inset: (x: 4pt, y: 2pt), radius: 2pt,
    text(fill: white, weight: "bold", size: 8.5pt)[W#n])
  #h(3pt)
  #text(fill: c-azul, weight: "bold")[#pasos-w.at(n - 1)]
]

// Qué clase de problema es (A a E, el mapa del capítulo del workflow) y qué
// pasos cargan el peso. Va antes de la primera cuenta.
#let tipo(clase, cuerpo) = caja([Qué tipo de problema es — clase #clase], c-viole, cuerpo)

// Cómo lo resolvió Aníbal, cuando subió su resolución: lo que hace igual y lo
// que hace distinto (sus letras, sus redondeos).
#let anibal(cuerpo) = caja([Cómo lo resolvió Aníbal], c-libro, cuerpo)

// Preguntas cortas como las de sus parcialitos, con la respuesta en una o dos
// líneas (ANI-33, 42, 56, 59, 64: «diga si depende de…», «¿y si…?»).
#let oral(..pares) = caja([Para el oral, y para el «discuta» del parcial], c-rosa)[
  #set par(justify: false)
  #for (i, p) in pares.pos().enumerate() [
    #text(weight: "bold")[#(i + 1). #p.at(0)] #h(2pt) #p.at(1) \
  ]
]
