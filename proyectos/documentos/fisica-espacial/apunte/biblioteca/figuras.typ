// =====================================================================
//  figuras.typ — las figuras del apunte, una función por figura
//
//  Nombradas `fig-<tema>`. El módulo la llama por nombre; acá no se sabe
//  nada del texto que la rodea. Para verlas todas sin compilar el apunte
//  entero: `compilar.bat galeria` (segundos, no minutos).
//
//  El vocabulario que usan —flecha, ángulo, masa, elipse-orbital— está en
//  estilo.typ. Si una figura necesita algo que no está ahí, va ahí, no acá.
//
//  REGLA DE RÓTULOS, pagada mirando el render: el nombre de un vector CORTO
//  (un versor, una componente) va en la PUNTA (`pos: 100%`) o con `rotulo`
//  suelto. Al 55% cae encima del vector de al lado.
// =====================================================================

#import "estilo.typ": *

// =====================================================================
//  Módulo 1 — Vectores y cinemática
// =====================================================================

// --- Proyección de un vector sobre otro ---------------------------------
// El dibujo que explica por qué el producto escalar mide "cuánto de B va
// en la dirección de A": la sombra de B sobre la recta de A.
#let fig-proyeccion = esquema({
  let O = (0, 0)
  let A = (4.4, 0)
  let B = (2.5, 2.1)
  let P = (2.5, 0)

  flecha(O, A, etiqueta: $bold(A)$, color: c-aux, lado: "north", pos: 88%)
  flecha(O, B, etiqueta: $bold(B)$, color: c-dato, lado: "east", pos: 70%)
  auxiliar(B, P)
  recto(P, 90, 180)
  angulo(O, 0, 40, etiqueta: $theta$, radio: 0.8)

  cetz.draw.line(
    (0, -0.6),
    (2.5, -0.6),
    stroke: 0.6pt + luma(70),
    mark: (start: "bar", end: "bar", scale: 0.3),
  )
  rotulo((1.25, -0.6), text(fill: luma(50))[$B cos theta$], ancla: "north")
  rotulo((4.55, 0), text(fill: c-aux)[dirección de $bold(A)$], ancla: "west")
  rotulo((2.6, 1.05), text(fill: luma(90))[la sombra de $bold(B)$ sobre $bold(A)$], ancla: "west")
})

// --- Producto vectorial: área y mano derecha ----------------------------
#let fig-producto-vectorial = esquema({
  let O = (0, 0)
  let A = (3.8, 0)
  let B = (1.7, 2.3)
  let S = (5.5, 2.3) // A + B

  // Paralelogramo sombreado: su área ES el módulo del producto.
  cetz.draw.line(O, A, S, B, close: true, fill: c-aux.lighten(88%), stroke: none)
  auxiliar(A, S)
  auxiliar(B, S)

  flecha(O, A, etiqueta: $bold(A)$, color: c-aux, lado: "north", pos: 85%)
  flecha(O, B, etiqueta: $bold(B)$, color: c-dato, lado: "east", pos: 95%)
  angulo(O, 0, 53, etiqueta: $theta$, radio: 0.78)

  // La altura del paralelogramo es B·sen θ: eso es lo que multiplica a A.
  auxiliar((1.7, 0), B)
  recto((1.7, 0), 90, 0)
  rotulo((1.82, 0.75), text(fill: luma(50))[$B sin theta$], ancla: "west")

  rotulo((3.55, 1.55), text(fill: luma(60))[área $= |bold(A) times bold(B)|$], ancla: "center")

  // El resultado sale de la hoja: se dibuja como la punta de la flecha
  // vista de frente, que es la convención de todos los libros.
  cetz.draw.circle((7.0, 1.3), radius: 0.28, stroke: 0.7pt + c-verde, fill: white)
  cetz.draw.circle((7.0, 1.3), radius: 0.075, fill: c-verde, stroke: none)
  rotulo((7.0, 0.9), text(fill: c-verde)[$bold(A) times bold(B)$\ sale de la hoja], ancla: "north")
})

// --- Los versores polares en un punto de la trayectoria -----------------
#let fig-versores-polares = esquema({
  let O = (0, 0)
  let ang = 42
  let R = 3.0
  let P = (R * calc.cos(ang * 1deg), R * calc.sin(ang * 1deg))
  let u = 1.25
  let er = (P.at(0) + u * calc.cos(ang * 1deg), P.at(1) + u * calc.sin(ang * 1deg))
  let et = (P.at(0) - u * calc.sin(ang * 1deg), P.at(1) + u * calc.cos(ang * 1deg))

  // Ejes
  flecha(O, (4.8, 0), color: c-trazo, grosor: 0.6pt)
  flecha(O, (0, 4.3), color: c-trazo, grosor: 0.6pt)
  rotulo((4.85, 0), $x$, ancla: "west")
  rotulo((0, 4.35), $y$, ancla: "south")

  // Una trayectoria cualquiera que pasa por P: no es una circunferencia
  // a propósito — los versores polares no necesitan que lo sea.
  cetz.draw.line(
    ..range(0, 46).map(i => {
      let t = 8 + i * 1.5
      let rr = 3.0 + 0.75 * calc.sin((t - 42) * 1.7 * 1deg)
      (rr * calc.cos(t * 1deg), rr * calc.sin(t * 1deg))
    }),
    stroke: (paint: c-guia, thickness: 0.9pt),
  )

  flecha(O, P, etiqueta: $bold(r)$, color: c-trazo, lado: "south-east", pos: 60%)
  angulo(O, 0, ang, etiqueta: $theta$, radio: 0.9)
  masa(P, radio: 0.09)

  flecha(P, er, color: c-dato)
  flecha(P, et, color: c-aux)
  rotulo((er.at(0) + 0.1, er.at(1)), text(fill: c-dato)[$hat(r)$], ancla: "west")
  rotulo((et.at(0) - 0.1, et.at(1)), text(fill: c-aux)[$hat(theta)$], ancla: "east")
  recto(P, ang, ang + 90, lado: 0.24)

  rotulo((2.55, 3.55), text(fill: luma(80))[trayectoria], ancla: "west")
  cetz.draw.line((2.5, 3.5), (2.15, 3.05), stroke: 0.45pt + luma(150), mark: (end: "straight", scale: 0.28))
})

// --- Por qué la derivada de un versor es perpendicular a él -------------
// El triangulito de Δr̂: dos versores de módulo 1 separados un ángulo Δθ.
// Como los dos miden 1, la cuerda que los une mide Δθ y —en el límite— es
// perpendicular a los dos. De ahí sale d(r̂)/dt = θ̇ θ̂, y de ahí toda la
// cinemática en polares.
#let fig-derivada-versor = esquema({
  let O = (0, 0)
  let a1 = 18
  let a2 = 55
  let L = 2.9
  let P1 = (L * calc.cos(a1 * 1deg), L * calc.sin(a1 * 1deg))
  let P2 = (L * calc.cos(a2 * 1deg), L * calc.sin(a2 * 1deg))

  cetz.draw.arc(
    O,
    start: a1 * 1deg,
    stop: a2 * 1deg,
    radius: L,
    anchor: "origin",
    stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"),
  )

  flecha(O, P1, color: c-trazo)
  flecha(O, P2, color: c-trazo)
  flecha(P1, P2, color: c-dato)
  angulo(O, a1, a2, etiqueta: $Delta theta$, radio: 1.05)

  rotulo((P1.at(0) + 0.12, P1.at(1) - 0.06), $hat(r)(t)$, ancla: "north-west")
  rotulo((P2.at(0) + 0.12, P2.at(1) + 0.06), $hat(r)(t + Delta t)$, ancla: "south-west")
  rotulo(
    ((P1.at(0) + P2.at(0)) / 2 - 0.12, (P1.at(1) + P2.at(1)) / 2),
    text(fill: c-dato)[$Delta hat(r)$],
    ancla: "east",
  )

  rotulo((3.35, 1.6), text(fill: luma(60))[
    Los dos miden 1, así que $|Delta hat(r)| approx Delta theta$;\
    y cuando $Delta theta -> 0$ la cuerda queda\
    perpendicular a $hat(r)$ — que es
    la dirección de $hat(theta)$.
  ], ancla: "west")
})

// --- El cohete visto por el radar (Ej. 10 de la guía) -------------------
#let fig-cohete-radar = esquema({
  let A = (0, 0) // radar
  let B = (3.6, 0) // plataforma de lanzamiento
  let ang = 52
  let C = (3.6, 3.6 * calc.tan(ang * 1deg)) // cohete

  // Suelo
  cetz.draw.line((-0.6, 0), (4.6, 0), stroke: 0.7pt + c-trazo)
  for i in range(0, 11) {
    let x = -0.5 + i * 0.5
    cetz.draw.line((x, 0), (x - 0.18, -0.18), stroke: 0.4pt + luma(150))
  }

  // Trayectoria vertical
  cetz.draw.line(B, (3.6, 5.6), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))

  masa(C, radio: 0.11)

  flecha(A, C, etiqueta: $r$, color: c-dato, lado: "north-west", pos: 50%)
  angulo(A, 0, ang, etiqueta: $theta$, radio: 1.0)
  recto(B, 0, 90, lado: 0.24)

  cetz.draw.line(
    (0, -0.68),
    (3.6, -0.68),
    stroke: 0.6pt + luma(70),
    mark: (start: "bar", end: "bar", scale: 0.3),
  )
  rotulo((1.8, -0.68), text(fill: luma(50))[$b$ (fijo)], ancla: "north")

  rotulo((-0.08, 0.05), text(fill: luma(40))[$A$: radar], ancla: "south-east")
  rotulo((3.66, -0.12), text(fill: luma(40))[$B$], ancla: "north-west")

  // Las dos componentes de la velocidad en polares. Los rótulos van en la
  // punta y hacia afuera: en el vértice del ángulo recto se pisan.
  let u = 1.15
  let er = (C.at(0) + u * calc.cos(ang * 1deg), C.at(1) + u * calc.sin(ang * 1deg))
  let et = (C.at(0) - u * calc.sin(ang * 1deg), C.at(1) + u * calc.cos(ang * 1deg))
  flecha(C, er, color: c-aux, grosor: 0.75pt)
  flecha(C, et, color: c-verde, grosor: 0.75pt)
  rotulo((er.at(0) + 0.1, er.at(1)), text(fill: c-aux)[$dot(r) hat(r)$], ancla: "west")
  rotulo((et.at(0) - 0.18, et.at(1) + 0.06), text(fill: c-verde)[$r dot(theta) hat(theta)$], ancla: "east")
  rotulo((3.75, C.at(1) - 0.25), text(fill: luma(40))[cohete], ancla: "north-west")
})

// --- Galería: lista de (nombre, figura) para galeria.typ ----------------
#let catalogo = (
  ("fig-proyeccion", fig-proyeccion),
  ("fig-producto-vectorial", fig-producto-vectorial),
  ("fig-versores-polares", fig-versores-polares),
  ("fig-derivada-versor", fig-derivada-versor),
  ("fig-cohete-radar", fig-cohete-radar),
)
