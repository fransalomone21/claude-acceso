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

// =====================================================================
//  Módulo 2 — Cantidad de movimiento, impulso y choques
// =====================================================================

// --- El impulso es el área bajo F(t) -----------------------------------
// La fuerza de un choque es un pico corto y de forma desconocida. Lo que
// se mide —y lo único que el teorema del impulso necesita— es el área.
#let fig-impulso-area = esquema({
  let t1 = 0.4
  let t2 = 4.6
  let f = t => 3.1 * calc.exp(-calc.pow(t - 2.5, 2) / 1.0)
  let n = 90
  let pts = range(0, n + 1).map(i => {
    let t = t1 + (t2 - t1) * i / n
    (t, f(t))
  })

  // El área sombreada: el impulso.
  cetz.draw.line(
    (t1, 0),
    ..pts,
    (t2, 0),
    close: true,
    fill: c-dato.lighten(87%),
    stroke: none,
  )
  cetz.draw.line(..pts, stroke: trazo-curva + c-dato)

  // Ejes
  flecha((0, 0), (5.9, 0), color: c-trazo, grosor: 0.6pt)
  flecha((0, 0), (0, 4.0), color: c-trazo, grosor: 0.6pt)
  rotulo((5.95, 0), $t$, ancla: "west")
  rotulo((0, 4.05), $F$, ancla: "south")

  // La fuerza media: el rectángulo de la MISMA área.
  cetz.draw.line(
    (t1, 1.30),
    (t2, 1.30),
    stroke: (paint: c-aux, thickness: 0.8pt, dash: "dashed"),
  )
  cetz.draw.line((t1, 0), (t1, 1.30), stroke: (paint: c-aux, thickness: 0.6pt, dash: "dashed"))
  cetz.draw.line((t2, 0), (t2, 1.30), stroke: (paint: c-aux, thickness: 0.6pt, dash: "dashed"))
  rotulo((4.72, 1.30), text(fill: c-aux)[$F_"med"$], ancla: "west")

  marca-x(t1, $t_1$)
  marca-x(t2, $t_2$)

  rotulo((0.25, 3.55), text(fill: c-dato)[
    área $= J = integral_(t_1)^(t_2) bold(F) d t = Delta bold(p)$
  ], ancla: "west")
  rotulo((2.5, -0.75), text(fill: luma(70), size: 8pt)[
    El rectángulo de $F_"med"$ tiene *la misma área*: eso es todo lo que
    $F_"med"$ significa.
  ], ancla: "north")
})

// --- El choque oblicuo de los asteroides (Ej. 2 de la guía) ------------
// Dos paneles: el dibujo del enunciado y el triángulo de cantidad de
// movimiento, que es lo que realmente resuelve el problema.
#let fig-choque-oblicuo = paneles(
  ("el choque", esquema({
    let O = (2.7, 0)
    cetz.draw.line((-0.7, 0), (4.6, 0), stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
    rotulo((4.7, 0), text(fill: luma(120), size: 8pt)[dirección\ original de $A$], ancla: "west")

    flecha((0, 0), (2.2, 0), etiqueta: [40 m/s], color: c-aux, lado: "north", pos: 50%)
    masa((0, 0), radio: 0.15)
    rotulo((0, -0.24), text(size: 8pt)[$A$, antes], ancla: "north")
    masa(O, radio: 0.15)
    rotulo((2.7, 1.9), text(size: 8pt)[$B$ arranca en reposo], ancla: "south")
    cetz.draw.line((2.7, 1.82), (2.7, 0.22), stroke: 0.45pt + luma(160), mark: (end: "straight", scale: 0.28))

    let PA = (O.at(0) + 1.85 * calc.cos(30deg), O.at(1) + 1.85 * calc.sin(30deg))
    let PB = (O.at(0) + 1.35 * calc.cos(-45deg), O.at(1) + 1.35 * calc.sin(-45deg))
    flecha(O, PA, color: c-dato)
    flecha(O, PB, color: c-verde)
    rotulo((PA.at(0) + 0.08, PA.at(1) + 0.06), text(fill: c-dato)[$v_A$], ancla: "west")
    rotulo((PB.at(0) + 0.08, PB.at(1) - 0.06), text(fill: c-verde)[$v_B$], ancla: "west")
    angulo(O, 0, 30, etiqueta: $30degree$, radio: 1.15)
    angulo(O, -45, 0, etiqueta: $45degree$, radio: 0.72)
  })),
  ("el triángulo de los impulsos", esquema({
    // p_total antes = p_A + p_B despues. Con masas iguales, los lados son
    // proporcionales a las rapideces: el triangulo se resuelve con senos.
    let O = (0, 0)
    let P = (3.6, 0)
    let LA = 3.6 * 29.28 / 40
    let Q = (LA * calc.cos(30deg), LA * calc.sin(30deg))

    flecha(O, P, color: c-aux)
    flecha(O, Q, color: c-dato)
    flecha(Q, P, color: c-verde)
    rotulo((1.8, -0.16), text(fill: c-aux)[$m dot 40$], ancla: "north")
    rotulo((0.95, 0.78), text(fill: c-dato)[$m v_A$], ancla: "south-east")
    rotulo((2.95, 1.05), text(fill: c-verde)[$m v_B$], ancla: "west")
    angulo(O, 0, 30, etiqueta: $30degree$, radio: 0.95)
    angulo(P, 135, 180, etiqueta: $45degree$, radio: 0.7)
    rotulo((1.8, -0.85), text(fill: luma(70), size: 8pt)[
      Que el triángulo cierre *es* $bold(p)_"antes" = bold(p)_"después"$.\
      Con masas iguales, los lados son las rapideces.
    ], ancla: "north")
  })),
)

// =====================================================================
//  Módulo 3 — Centro de masa y sistemas de partículas
// =====================================================================

// --- El centro de masa de dos cuerpos ----------------------------------
// Sobre la recta que los une, más cerca del pesado, con d1/d2 = m2/m1.
#let fig-cm-dos-cuerpos = esquema({
  let P1 = (0, 0)
  let P2 = (5.0, 0)
  let C = (3.5, 0) // m1 = 7/3 m2  ->  d1/d2 = 3.5/1.5

  cetz.draw.line((-0.6, 0), (5.6, 0), stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))

  cetz.draw.circle(P1, radius: 0.42, fill: c-orbe.lighten(72%), stroke: 0.7pt + c-orbe)
  cetz.draw.circle(P2, radius: 0.27, fill: c-orbe.lighten(82%), stroke: 0.7pt + c-orbe)
  rotulo((0, 0.5), text(fill: c-orbe)[$m_1$], ancla: "south")
  rotulo((5.0, 0.35), text(fill: c-orbe)[$m_2$], ancla: "south")

  // El CM: cruz sobre círculo, que es el símbolo de siempre.
  cetz.draw.circle(C, radius: 0.15, fill: white, stroke: 0.8pt + c-dato)
  cetz.draw.line((C.at(0) - 0.15, C.at(1)), (C.at(0) + 0.15, C.at(1)), stroke: 0.8pt + c-dato)
  cetz.draw.line((C.at(0), C.at(1) - 0.15), (C.at(0), C.at(1) + 0.15), stroke: 0.8pt + c-dato)
  rotulo((3.5, 0.32), text(fill: c-dato)[CM], ancla: "south")

  cetz.draw.line(
    (0, -0.75),
    (3.5, -0.75),
    stroke: 0.6pt + luma(70),
    mark: (start: "bar", end: "bar", scale: 0.3),
  )
  cetz.draw.line(
    (3.5, -0.75),
    (5.0, -0.75),
    stroke: 0.6pt + luma(70),
    mark: (start: "bar", end: "bar", scale: 0.3),
  )
  rotulo((1.75, -0.78), text(fill: luma(50))[$d_1$], ancla: "north")
  rotulo((4.25, -0.78), text(fill: luma(50))[$d_2$], ancla: "north")

  rotulo((2.6, 1.35), text(fill: luma(60))[
    $d_1 \/ d_2 = m_2 \/ m_1$ — inversa de las masas:\
    el CM está siempre más cerca del más pesado.
  ], ancla: "center")
})

// --- El mismo choque, en dos sistemas ----------------------------------
// En el laboratorio no hay simetría; en el sistema centro de masa los dos
// impulsos son opuestos antes y después, y todo el choque es un giro.
#let fig-choque-cm = paneles(
  ("sistema laboratorio", esquema({
    let O = (2.4, 0)
    flecha((0.2, 0), (2.1, 0), etiqueta: [40], color: c-aux, lado: "north", pos: 55%)
    masa(O, radio: 0.13)
    let PA = (O.at(0) + 1.55 * calc.cos(30deg), O.at(1) + 1.55 * calc.sin(30deg))
    let PB = (O.at(0) + 1.10 * calc.cos(-45deg), O.at(1) + 1.10 * calc.sin(-45deg))
    flecha(O, PA, etiqueta: [29,3], color: c-dato, lado: "south-east", pos: 100%)
    flecha(O, PB, etiqueta: [20,7], color: c-verde, lado: "north-west", pos: 100%)
    rotulo((2.0, -1.75), text(size: 8pt, fill: luma(80))[
      $B$ arranca quieto: no hay\
      ninguna simetría a la vista.
    ], ancla: "north")
  })),
  ("sistema centro de masa", esquema({
    let O = (2.0, 0)
    let ang = 69.9
    let L = 1.25
    // antes: opuestos sobre el eje x
    flecha(O, (O.at(0) + 1.55, 0), etiqueta: [20], color: c-aux, lado: "north", pos: 100%)
    flecha(O, (O.at(0) - 1.55, 0), etiqueta: [20], color: c-aux, lado: "north", pos: 100%)
    // despues: opuestos, girados
    let Q1 = (O.at(0) + L * calc.cos(ang * 1deg), O.at(1) + L * calc.sin(ang * 1deg))
    let Q2 = (O.at(0) - L * calc.cos(ang * 1deg), O.at(1) - L * calc.sin(ang * 1deg))
    flecha(O, Q1, color: c-dato)
    flecha(O, Q2, color: c-verde)
    rotulo((Q1.at(0) + 0.08, Q1.at(1)), text(fill: c-dato)[15,6], ancla: "west")
    rotulo((Q2.at(0) - 0.08, Q2.at(1)), text(fill: c-verde)[15,6], ancla: "east")
    angulo(O, 0, ang, etiqueta: $theta^*$, radio: 0.68)
    masa(O, radio: 0.1)
    rotulo((2.0, -1.75), text(size: 8pt, fill: luma(80))[
      Antes en azul, después en color.\
      Siempre $bold(p)_1 = -bold(p)_2$: el choque\
      es un *giro* de los dos impulsos.
    ], ancla: "north")
  })),
)

// =====================================================================
//  Módulo 4 — Propulsión: la ecuación del cohete
// =====================================================================

// --- El elemento de tiempo del cohete ----------------------------------
// El dibujo de Roederer (pág. 112): antes, un cuerpo de masa M; después,
// el gas expulsado y lo que queda. Todo el resto es álgebra.
#let fig-cohete-elemento = esquema({
  // --- ANTES ---
  cetz.draw.rect((0.6, 1.55), (2.9, 2.45), radius: 0.12, stroke: 0.7pt + c-trazo)
  rotulo((1.75, 2.0), $M$, ancla: "center")
  flecha((3.05, 2.0), (4.35, 2.0), etiqueta: $bold(V)$, color: c-aux, lado: "north", pos: 100%)
  rotulo((0.4, 2.0), text(fill: luma(90), size: 8pt)[antes], ancla: "east")

  // --- DESPUES ---
  cetz.draw.rect((1.35, 0.05), (2.9, 0.95), radius: 0.12, stroke: 0.7pt + c-trazo)
  rotulo((2.12, 0.5), $M - Delta m$, ancla: "center")
  flecha((3.05, 0.5), (4.55, 0.5), etiqueta: $bold(V) + Delta bold(V)$, color: c-aux, lado: "north", pos: 100%)

  cetz.draw.rect((0.62, 0.2), (1.16, 0.8), radius: 0.06, fill: c-dato.lighten(80%), stroke: 0.6pt + c-dato)
  rotulo((0.89, 0.5), text(fill: c-dato, size: 8pt)[$Delta m$], ancla: "center")
  flecha((0.5, 0.5), (-0.9, 0.5), etiqueta: $bold(v)$, color: c-dato, lado: "north", pos: 100%)

  // La velocidad relativa: lo único que el motor fija.
  cetz.draw.line(
    (-0.9, -0.55),
    (4.55, -0.55),
    stroke: 0.6pt + luma(70),
    mark: (start: "bar", end: "bar", scale: 0.3),
  )
  rotulo((1.8, -0.75), text(fill: luma(50))[
    $bold(v)_r = bold(v) - bold(V)$ — la fija el motor, no el movimiento del cohete
  ], ancla: "north")

  cetz.draw.line((-1.35, 1.25), (4.9, 1.25), stroke: (paint: luma(200), thickness: 0.4pt))
  rotulo((-1.35, 0.5), text(fill: luma(90), size: 8pt)[después], ancla: "east")
})

// --- Una etapa contra dos ----------------------------------------------
// Mismo peso total y mismo combustible: lo único que cambia es que la
// segunda tira la cubierta vacía a mitad de camino.
#let fig-etapas = esquema({
  let anchoB = 0.9
  // --- una etapa ---
  cetz.draw.rect((0, 0), (anchoB, 3.4), fill: c-dato.lighten(84%), stroke: 0.6pt + c-dato)
  cetz.draw.rect((0, 3.4), (anchoB, 3.75), fill: luma(225), stroke: 0.6pt + luma(120))
  cetz.draw.rect((0, 3.75), (anchoB, 4.05), fill: c-verde.lighten(78%), stroke: 0.6pt + c-verde)
  rotulo((anchoB / 2, 1.7), text(size: 8pt)[17,8 Mg\ combustible], ancla: "center")
  rotulo((anchoB + 0.15, 3.45), text(size: 8pt, fill: luma(90))[1,2 Mg de estructura], ancla: "west")
  rotulo((anchoB + 0.15, 3.95), text(size: 8pt, fill: c-verde)[540 kg de carga útil], ancla: "west")
  rotulo((anchoB / 2, -0.15), text(size: 8.5pt, weight: "bold", fill: c-azul)[una etapa], ancla: "north")

  // --- dos etapas ---
  let x0 = 5.6
  cetz.draw.rect((x0, 0), (x0 + anchoB, 1.7), fill: c-dato.lighten(84%), stroke: 0.6pt + c-dato)
  cetz.draw.rect((x0, 1.7), (x0 + anchoB, 1.82), fill: luma(225), stroke: 0.6pt + luma(120))
  cetz.draw.rect((x0, 1.82), (x0 + anchoB, 3.52), fill: c-dato.lighten(84%), stroke: 0.6pt + c-dato)
  cetz.draw.rect((x0, 3.52), (x0 + anchoB, 3.64), fill: luma(225), stroke: 0.6pt + luma(120))
  cetz.draw.rect((x0, 3.64), (x0 + anchoB, 3.94), fill: c-verde.lighten(78%), stroke: 0.6pt + c-verde)
  rotulo((x0 + anchoB / 2, 0.85), text(size: 8pt)[etapa $A$\ 8,9 Mg], ancla: "center")
  rotulo((x0 + anchoB / 2, 2.67), text(size: 8pt)[etapa $B$\ 8,9 Mg], ancla: "center")
  rotulo((x0 + anchoB / 2, -0.15), text(size: 8.5pt, weight: "bold", fill: c-azul)[dos etapas], ancla: "north")

  // La cubierta que se tira
  flecha((x0 - 0.15, 1.76), (x0 - 1.25, 1.76), color: luma(120), grosor: 0.7pt)
  rotulo((x0 - 1.3, 1.76), text(size: 8pt, fill: luma(90))[600 kg de\ cubierta vacía:\ *se tiran*], ancla: "east")

  rotulo((3.3, 5.0), text(fill: luma(60))[
    Misma masa total (19,54 Mg) y mismo combustible (17,8 Mg).\
    Lo único distinto es *qué masa se sigue empujando al final*.
  ], ancla: "center")
})

// =====================================================================
//  Módulo 5 — Trabajo y energía
// =====================================================================

// --- Por qué una fuerza central es conservativa ------------------------
// El desplazamiento se parte en radial y transversal; la fuerza central
// sólo tiene componente radial, así que sólo el pedazo dr trabaja.
#let fig-trabajo-central = esquema({
  let O = (0, 0)
  let ang = 52
  let R = 3.2
  let P = (R * calc.cos(ang * 1deg), R * calc.sin(ang * 1deg))

  cuerpo-central(O, radio: 0.34)

  // Un pedazo de trayectoria cualquiera: no hace falta que sea una órbita.
  cetz.draw.line(
    ..range(0, 60).map(i => {
      let t = 14 + i * 1.35
      let rr = 3.2 + 1.15 * calc.sin((t - 52) * 1.15 * 1deg)
      (rr * calc.cos(t * 1deg), rr * calc.sin(t * 1deg))
    }),
    stroke: (paint: c-guia, thickness: 0.9pt),
  )
  rotulo((3.35, 0.62), text(fill: luma(110), size: 8pt)[trayectoria], ancla: "west")

  flecha(O, P, etiqueta: $bold(r)$, color: c-trazo, lado: "south-east", pos: 30%)
  masa(P, radio: 0.09)

  // La fuerza: central, hacia el centro. Va del OTRO lado de la recta que
  // el rótulo de r, porque los dos viven sobre la misma dirección.
  let uF = 1.35
  let F = (P.at(0) - uF * calc.cos(ang * 1deg), P.at(1) - uF * calc.sin(ang * 1deg))
  flecha(P, F, color: c-dato, grosor: 1.0pt)
  rotulo((F.at(0) - 0.12, F.at(1) + 0.1), text(fill: c-dato)[$bold(F) = F(r) hat(r)$], ancla: "south-east")

  // El desplazamiento y sus dos pedazos
  let dl = 1.5
  let dir = ang + 50
  let Q = (P.at(0) + dl * calc.cos(dir * 1deg), P.at(1) + dl * calc.sin(dir * 1deg))
  let proyR = dl * calc.cos(50 * 1deg)
  let Rr = (P.at(0) + proyR * calc.cos(ang * 1deg), P.at(1) + proyR * calc.sin(ang * 1deg))
  flecha(P, Q, color: c-aux, grosor: 1.0pt)
  rotulo((Q.at(0) - 0.1, Q.at(1) + 0.05), text(fill: c-aux)[$d bold(l)$], ancla: "south-east")
  auxiliar(Rr, Q)
  flecha(P, Rr, color: c-verde, grosor: 0.8pt)
  rotulo((Rr.at(0) + 0.12, Rr.at(1) - 0.02), text(fill: c-verde)[$d r hat(r)$], ancla: "west")
  recto(Rr, ang, ang + 90, lado: 0.2)

  rotulo((3.6, 3.4), text(fill: luma(60))[
    $bold(F) dot d bold(l) = F(r) d r$:\
    el pedazo transversal $r d theta hat(theta)$\
    es perpendicular a $bold(F)$ y *no trabaja*.\
    Por eso el trabajo sólo depende de $r$.
  ], ancla: "west")
})

// --- El diagrama de energía --------------------------------------------
// La máquina que en el módulo 9 se aplica al potencial eficaz: la recta
// E corta a U(x) en los puntos de retorno, y K es la distancia vertical.
#let fig-diagrama-energia = esquema({
  let g = x => (x - 1.2) * (x - 2.6) * (x - 4.0) * (x - 5.4)
  let U = x => 0.45 * g(x)
  let xa = 0.98
  let xb = 5.60
  let n = 200
  let pts = range(0, n + 1).map(i => {
    let x = xa + (xb - xa) * i / n
    (x, U(x))
  })
  let E = 0.6
  let x1 = 1.126
  let x2 = 2.882

  // Ejes
  flecha((0.6, 0), (6.1, 0), color: c-trazo, grosor: 0.6pt)
  flecha((0.6, -2.2), (0.6, 2.9), color: c-trazo, grosor: 0.6pt)
  rotulo((6.15, 0), $x$, ancla: "west")
  rotulo((0.6, 2.95), $U$, ancla: "south")

  // La curva
  cetz.draw.line(..pts, stroke: trazo-curva + c-trazo)

  // La recta de energía total
  cetz.draw.line((0.72, E), (5.95, E), stroke: (paint: c-dato, thickness: 0.9pt, dash: "dashed"))
  rotulo((5.98, E), text(fill: c-dato)[$E$], ancla: "west")

  // Los puntos de retorno
  for x in (x1, x2) {
    cetz.draw.line((x, 0), (x, E), stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
    cetz.draw.circle((x, E), radius: 0.075, fill: c-dato, stroke: none)
  }
  marca-x(x1, $x_1$)
  marca-x(x2, $x_2$)

  // K = E - U, medida en el segundo pozo, que es donde no se pisa con nada:
  // en el primero cae encima del rótulo de x_2.
  let xm = 4.6
  cetz.draw.line(
    (xm, U(xm)),
    (xm, E),
    stroke: 0.7pt + c-verde,
    mark: (start: "bar", end: "bar", scale: 0.3),
  )
  rotulo((xm + 0.1, (U(xm) + E) / 2), text(fill: c-verde)[$K$], ancla: "west")

  // Equilibrios
  cetz.draw.circle((1.735, U(1.735)), radius: 0.08, fill: c-verde, stroke: none)
  cetz.draw.circle((4.865, U(4.865)), radius: 0.08, fill: c-verde, stroke: none)
  cetz.draw.circle((3.3, U(3.3)), radius: 0.08, fill: c-rojo, stroke: none)
  rotulo((3.3, U(3.3) + 0.14), text(fill: c-rojo, size: 8pt)[equilibrio inestable], ancla: "south")
  rotulo((1.735, U(1.735) - 0.14), text(fill: c-verde, size: 8pt)[estable], ancla: "north")
  rotulo((4.865, U(4.865) - 0.14), text(fill: c-verde, size: 8pt)[estable], ancla: "north")

  rotulo((6.35, 2.15), text(fill: luma(60))[
    Entre $x_1$ y $x_2$ la partícula queda *atrapada*:\
    para pasar la loma le falta energía.\
    La pendiente da la fuerza, $F_x = -d U \/ d x$;\
    la altura entre la recta y la curva es $K = E - U$.
  ], ancla: "west")
})


// --- El cañón de Newton -------------------------------------------------
// La respuesta a «¿por qué orbita sin caer?» dibujada: es la MISMA
// trayectoria de caída, con más velocidad horizontal. El corte lo hace
// `arco-conica` con r-min: las que tienen poco perigeo se interrumpen
// contra la superficie, que es exactamente lo que significa «caer».
#let fig-canon-newton = esquema(escala: 1.35cm, {
  let R = 1.0
  let rl = 1.28 // radio del punto de lanzamiento

  cuerpo-central((0, 0), radio: R, etiqueta: none)
  cetz.draw.content((0, -R - 0.06), text(size: letra-figura, fill: c-orbe)[Tierra], anchor: "north")

  // Las tres que caen: apogeo arriba (perigeo hacia abajo), perigeo dentro.
  for (rp, col) in ((0.35, c-guia), (0.62, c-guia), (0.88, c-guia)) {
    let e = (rl - rp) / (rl + rp)
    arco-conica((0, 0), rp * (1 + e), e, dir-perigeo: -90, r-min: R, color: col, grosor: 0.7pt)
  }

  // La circular.
  cetz.draw.circle((0, 0), radius: rl, stroke: trazo-curva + c-dato)

  // La elíptica cerrada: el lanzamiento pasa a ser el PERIGEO.
  let ra = 2.35
  let e2 = (ra - rl) / (ra + rl)
  arco-conica((0, 0), rl * (1 + e2), e2, dir-perigeo: 90, desde: -180, hasta: 180, color: c-aux, grosor: trazo-curva2)

  // La abierta: parábola, e = 1. Se corta antes de que domine el dibujo:
  // lo que hay que ver es que NO CIERRA, no cuán lejos llega.
  arco-conica((0, 0), 2 * rl, 1, dir-perigeo: 90, desde: -96, hasta: 96, color: c-verde, grosor: trazo-curva2)

  // El punto de lanzamiento y su velocidad horizontal.
  masa((0, rl), radio: 0.07, color: c-trazo)
  flecha((0, rl), (0.85, rl), etiqueta: $bold(v)$, color: c-dato, pos: 100%, lado: "south")
  rotulo((-0.12, rl + 0.1), text(size: 8pt, fill: luma(70))[se dispara desde acá], ancla: "south-east")

  // Los cuatro casos, en orden de velocidad creciente de abajo hacia arriba.
  rotulo((3.0, 1.35), text(fill: c-verde)[$v > v_"esc"$ — no vuelve], ancla: "west")
  rotulo((3.0, 0.62), text(fill: c-aux)[$v_"circ" < v < v_"esc"$ — elipse], ancla: "west")
  rotulo((3.0, -0.11), text(fill: c-dato)[$v = v_"circ"$ — círculo], ancla: "west")
  rotulo((3.0, -0.84), text(fill: luma(95))[$v < v_"circ"$ — cae], ancla: "west")
})

// --- El pozo gravitatorio -----------------------------------------------
// El diagrama de energía del módulo 5, con U(r) = -mu m / r. Lo único que
// hay que leer es el SIGNO de E: negativa, hay punto de retorno y el cuerpo
// queda ligado; cero o positiva, no hay corte y se va al infinito.
#let fig-pozo-gravitatorio = esquema(escala: 1.45cm, {
  let k = 1.5
  let U = r => -k / r
  let r0 = 0.42
  let rf = 5.2
  let n = 220
  let pts = range(0, n + 1).map(i => {
    let r = r0 + (rf - r0) * i / n
    (r, U(r))
  })

  flecha((0, 0), (5.7, 0), color: c-trazo, grosor: 0.6pt)
  flecha((0, -3.7), (0, 1.35), color: c-trazo, grosor: 0.6pt)
  rotulo((5.75, -0.02), $r$, ancla: "west")
  rotulo((0, 1.4), $U$, ancla: "south")
  rotulo((-0.12, 0.06), [0], ancla: "south-east")

  cetz.draw.line(..pts, stroke: trazo-curva + c-trazo)
  rotulo((2.15, U(2.15) - 0.12), text(fill: c-trazo)[$U(r) = -mu m \/ r$], ancla: "north-west")

  // E > 0: sobra energía en el infinito. Va primero para que las tres
  // rectas queden nombradas de arriba hacia abajo en el mismo margen.
  cetz.draw.line((0.05, 0.72), (4.95, 0.72), stroke: (paint: c-aux, thickness: 0.9pt, dash: "dashed"))
  rotulo((5.0, 0.72), text(fill: c-aux)[$E > 0$], ancla: "west")

  // E = 0: el caso justo, la velocidad de escape exacta.
  cetz.draw.line((0.05, 0), (4.95, 0), stroke: (paint: c-verde, thickness: 0.9pt, dash: "dashed"))
  rotulo((5.0, 0.26), text(fill: c-verde)[$E = 0$], ancla: "west")

  // E < 0: ligada, con su punto de retorno.
  let E1 = -0.5
  let rmax = k / 0.5
  cetz.draw.line((0.05, E1), (4.95, E1), stroke: (paint: c-dato, thickness: 0.9pt, dash: "dashed"))
  cetz.draw.circle((rmax, E1), radius: 0.075, fill: c-dato, stroke: none)
  cetz.draw.line((rmax, 0), (rmax, E1), stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
  marca-x(rmax, $r_"máx"$)
  rotulo((5.0, E1 - 0.06), text(fill: c-dato)[$E < 0$], ancla: "west")

  // K = E - U, medida donde no se pisa con el resto.
  let rm = 0.78
  cetz.draw.line((rm, U(rm)), (rm, E1), stroke: 0.7pt + c-viole, mark: (start: "bar", end: "bar", scale: 0.3))
  rotulo((rm + 0.08, (U(rm) + E1) / 2), text(fill: c-viole)[$K$], ancla: "west")
})

// =====================================================================
//  Módulo 7 — Momento angular y fuerzas centrales
// =====================================================================

// --- Qué es L, y respecto de qué punto ----------------------------------
// Dos paneles con la MISMA partícula, la MISMA velocidad y dos orígenes.
// El brazo de palanca cambia, y con él L: por eso «el momento angular», sin
// decir respecto de qué punto, no quiere decir nada.
//
// La geometría está elegida para que el brazo se VEA: si el origen queda
// casi sobre la recta de mv, la perpendicular mide dos milímetros y el
// dibujo no muestra lo único que tiene que mostrar.
#let _panel-L(O, marca-O, col, nota, phi: none) = esquema(escala: 1.05cm, {
  let P = (2.4, 1.2)
  let ang = 100 // dirección de mv, en grados
  let u = (calc.cos(ang * 1deg), calc.sin(ang * 1deg))
  let V = (P.at(0) + 1.75 * u.at(0), P.at(1) + 1.75 * u.at(1))
  // Pie de la perpendicular desde O a la recta de mv.
  let s = (O.at(0) - P.at(0)) * u.at(0) + (O.at(1) - P.at(1)) * u.at(1)
  let Q = (P.at(0) + s * u.at(0), P.at(1) + s * u.at(1))

  // La recta de acción de mv, prolongada para los dos lados.
  cetz.draw.line(
    (P.at(0) - 1.5 * u.at(0), P.at(1) - 1.5 * u.at(1)),
    (P.at(0) + 2.2 * u.at(0), P.at(1) + 2.2 * u.at(1)),
    stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"),
  )

  flecha(O, P, etiqueta: marca-O.at(1), color: c-trazo, lado: "south-east", pos: 55%)
  flecha(P, V, etiqueta: $m bold(v)$, color: c-dato, lado: "west", pos: 75%)

  cetz.draw.line(O, Q, stroke: (paint: col, thickness: 0.7pt, dash: "dashed"))
  rotulo(((O.at(0) + Q.at(0)) / 2, (O.at(1) + Q.at(1)) / 2 - 0.08), text(fill: col, marca-O.at(2)), ancla: "north")
  recto(Q, ang, calc.atan2(O.at(0) - Q.at(0), O.at(1) - Q.at(1)) / 1deg, lado: 0.22)

  if phi != none {
    // phi se mide desde la PROLONGACIÓN de r, no desde la dirección hacia O:
    // es el ángulo entre los vectores r y mv puestos con el mismo origen.
    let dir-r = calc.atan2(P.at(0) - O.at(0), P.at(1) - O.at(1)) / 1deg
    cetz.draw.line(
      P,
      (P.at(0) + 0.9 * calc.cos(dir-r * 1deg), P.at(1) + 0.9 * calc.sin(dir-r * 1deg)),
      stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"),
    )
    angulo(P, dir-r, ang, etiqueta: phi, radio: 0.5)
  }

  masa(P, radio: 0.085, color: c-trazo)
  masa(O, radio: 0.07, color: c-trazo, etiqueta: marca-O.at(0), hacia: "south-east")

  rotulo((-0.35, 3.3), text(fill: col, nota), ancla: "west")
})

#let fig-momento-angular = paneles(
  (
    "respecto de O",
    _panel-L((0, 0), ($O$, $bold(r)$, $d = r sin phi$), c-verde, [$L = m v d$ — brazo largo], phi: $phi$),
  ),
  (
    "respecto de O prima",
    _panel-L((1.2, 2.5), ($O'$, $bold(r)'$, $d'$), c-rojo, [$L' = m v d' eq.not L$]),
  ),
)

// --- La segunda ley de Kepler: áreas iguales en tiempos iguales ----------
// Los dos sectores tienen la misma área. Cerca del foco el radio es corto y
// el ángulo barrido grande; lejos, al revés. Eso ES r^2 theta-punto = cte.
#let fig-velocidad-areolar = esquema(escala: 1.15cm, {
  let a = 2.6
  let e = 0.4
  let p = a * (1 - e * e)
  let F = (0, 0)
  let radio(nu) = p / (1 + e * calc.cos(nu * 1deg))
  let punto(nu) = (radio(nu) * calc.cos(nu * 1deg), radio(nu) * calc.sin(nu * 1deg))

  // Un sector: el triángulo curvo entre dos anomalías.
  let sector(n1, n2, col) = {
    let pts = range(0, 25).map(i => punto(n1 + (n2 - n1) * i / 24))
    cetz.draw.line(F, ..pts, stroke: none, fill: col, close: true)
  }

  // Perigeo (derecha): mucho ángulo, poco radio.
  sector(-30, 30, c-dato.lighten(72%))
  // Apogeo (izquierda): poco ángulo, mucho radio. El 5,8 NO se eligió a ojo:
  // sale de igualar las dos áreas, integral 1/2 r^2 dnu mediante. Ésa es la
  // desproporción que la figura tiene que mostrar, y si el número está mal
  // la figura miente justo en lo que quiere enseñar.
  sector(180 - 5.8, 180 + 5.8, c-aux.lighten(72%))

  arco-conica(F, p, e, desde: -180, hasta: 180, color: c-trazo, grosor: trazo-curva2)
  cuerpo-central(F, radio: 0.28, etiqueta: none)

  for nu in (-30, 30, 180 - 5.8, 180 + 5.8) {
    cetz.draw.line(F, punto(nu), stroke: 0.5pt + c-guia)
  }

  rotulo((radio(0) * 0.55, 0), text(fill: c-dato)[$d A$], ancla: "center")
  rotulo((-radio(180) * 0.55, 0), text(fill: c-aux)[$d A$], ancla: "center")
  flecha(punto(30), (punto(30).at(0) + 0.1, punto(30).at(1) + 1.05), etiqueta: $bold(v)$, color: c-dato, pos: 100%, lado: "west")
  flecha(punto(180 + 5.8), (punto(180 + 5.8).at(0) - 0.04, punto(180 + 5.8).at(1) - 0.5), etiqueta: $bold(v)$, color: c-aux, pos: 100%, lado: "east")
})

// --- El satélite del Ejercicio 4 de la guía -----------------------------
// Escala: el radio terrestre vale 1, o sea todo dividido por 6378 km.
// Las dos posiciones intermedias están en las anomalías que salen de la
// figura de la cátedra (96,09 grados y -102,1 grados), y el apunte
// comprueba que ésas son justamente las que reproducen sus velocidades.
#let fig-satelite-guia = esquema(escala: 2.15cm, {
  let R = 1.0
  let e = 0.2098
  let p = 1.2858
  let F = (0, 0)
  let radio(nu) = p / (1 + e * calc.cos(nu * 1deg))
  let punto(nu) = (radio(nu) * calc.cos(nu * 1deg), radio(nu) * calc.sin(nu * 1deg))

  arco-conica(F, p, e, desde: -180, hasta: 180, color: c-aux, grosor: trazo-curva2)
  cuerpo-central(F, radio: R, etiqueta: none)

  // Los ábsides, sobre el eje horizontal. Perigeo a la derecha.
  let P = punto(0)
  let A = punto(180)
  cetz.draw.line(A, P, stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
  masa(P, radio: 0.07, color: c-trazo)
  masa(A, radio: 0.07, color: c-trazo)
  rotulo((P.at(0) + 0.12, -0.16), text(fill: c-trazo)[$P$], ancla: "west")
  rotulo((A.at(0) - 0.12, -0.16), text(fill: c-trazo)[$A$], ancla: "east")

  // En los ábsides la velocidad es PERPENDICULAR al radio: ése es el dato
  // que hace que ahí h = r v sin más.
  flecha(P, (P.at(0), 0.85), etiqueta: [8,435], color: c-dato, pos: 100%, lado: "west")
  flecha(A, (A.at(0), -0.75), etiqueta: [5,509], color: c-dato, pos: 100%, lado: "east")
  recto(P, 90, 180, lado: 0.16)
  recto(A, 270, 0, lado: 0.16)

  // Las dos posiciones intermedias, con su ángulo de trayectoria.
  let marcar(nu, vel, gam, lado) = {
    let Q = punto(nu)
    // La velocidad forma el ángulo gam con la perpendicular al radio.
    let perp = nu + 90
    let dir = perp - gam
    let pt = (Q.at(0) + 0.8 * calc.cos(dir * 1deg), Q.at(1) + 0.8 * calc.sin(dir * 1deg))
    let pp = (Q.at(0) + 0.62 * calc.cos(perp * 1deg), Q.at(1) + 0.62 * calc.sin(perp * 1deg))
    cetz.draw.line(Q, pp, stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
    cetz.draw.line(F, Q, stroke: 0.5pt + c-guia)
    flecha(Q, pt, etiqueta: vel, color: c-verde, pos: 100%, lado: lado)
    angulo(Q, dir, perp, etiqueta: $gamma$, radio: 0.5, color: c-verde)
    masa(Q, radio: 0.06, color: c-trazo)
  }
  marcar(96.09, [6,970], 12.05, "east")
  marcar(-102.1, [6,817], 12.11, "west")
})

// --- El problema de dos cuerpos y su equivalente ------------------------
// Izquierda: lo que pasa de verdad — los dos cuerpos recorren elipses
// SEMEJANTES alrededor del centro de masa común, siempre en lados opuestos.
// Derecha: el problema equivalente, un solo cuerpo de masa reducida a
// distancia r de un centro fijo. Las dos figuras describen el mismo
// movimiento; la de la derecha es la que se sabe resolver.
#let fig-dos-cuerpos = paneles(
  (
    "lo que pasa de verdad",
    esquema(escala: 1.0cm, {
      let e = 0.42
      let k = 3.0 // razón de masas m1/m2
      let p = 2.2 // parámetro de la órbita RELATIVA
      let p1 = p / (1 + k) // la del cuerpo pesado: más chica
      let p2 = p * k / (1 + k) // la del liviano: k veces más grande
      let CM = (0, 0)
      let nu = 55 // el instante que se dibuja

      let pos(pp, dir) = {
        let r = pp / (1 + e * calc.cos(nu * 1deg))
        ((r * calc.cos((nu + dir) * 1deg)), (r * calc.sin((nu + dir) * 1deg)))
      }
      let P1 = pos(p1, 180)
      let P2 = pos(p2, 0)

      arco-conica(CM, p1, e, desde: -180, hasta: 180, dir-perigeo: 180, color: c-dato, grosor: 0.7pt)
      arco-conica(CM, p2, e, desde: -180, hasta: 180, dir-perigeo: 0, color: c-aux, grosor: 0.7pt)

      cetz.draw.line(P1, P2, stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
      masa(P1, radio: 0.19, color: c-dato, etiqueta: $m_1$, hacia: "east")
      masa(P2, radio: 0.11, color: c-aux, etiqueta: $m_2$, hacia: "west")

      // El CM: no es ninguno de los dos cuerpos, y no se mueve.
      cetz.draw.line((-0.16, 0), (0.16, 0), stroke: 0.8pt + c-verde)
      cetz.draw.line((0, -0.16), (0, 0.16), stroke: 0.8pt + c-verde)
      rotulo((0.1, -0.22), text(fill: c-verde)[CM], ancla: "north-west")

    }),
  ),
  (
    "el problema equivalente",
    esquema(escala: 1.0cm, {
      let e = 0.42
      let p = 2.2
      let nu = 55
      let F = (0, 0)
      let r = p / (1 + e * calc.cos(nu * 1deg))
      let P = (r * calc.cos(nu * 1deg), r * calc.sin(nu * 1deg))

      arco-conica(F, p, e, desde: -180, hasta: 180, color: c-trazo, grosor: trazo-curva2)
      flecha(F, P, etiqueta: $bold(r)$, color: c-trazo, lado: "south-east", pos: 55%)
      masa(P, radio: 0.13, color: c-viole, etiqueta: $m_r$, hacia: "west")

      cetz.draw.circle(F, radius: 0.13, fill: c-verde, stroke: none)
      rotulo((0.16, -0.1), text(fill: c-verde)[fijo], ancla: "west")

    }),
  ),
)

// --- Galería: lista de (nombre, figura) para galeria.typ ----------------
#let catalogo = (
  ("fig-proyeccion", fig-proyeccion),
  ("fig-producto-vectorial", fig-producto-vectorial),
  ("fig-versores-polares", fig-versores-polares),
  ("fig-derivada-versor", fig-derivada-versor),
  ("fig-cohete-radar", fig-cohete-radar),
  ("fig-impulso-area", fig-impulso-area),
  ("fig-choque-oblicuo", fig-choque-oblicuo),
  ("fig-cm-dos-cuerpos", fig-cm-dos-cuerpos),
  ("fig-choque-cm", fig-choque-cm),
  ("fig-cohete-elemento", fig-cohete-elemento),
  ("fig-etapas", fig-etapas),
  ("fig-trabajo-central", fig-trabajo-central),
  ("fig-diagrama-energia", fig-diagrama-energia),
  ("fig-canon-newton", fig-canon-newton),
  ("fig-pozo-gravitatorio", fig-pozo-gravitatorio),
  ("fig-momento-angular", fig-momento-angular),
  ("fig-velocidad-areolar", fig-velocidad-areolar),
  ("fig-satelite-guia", fig-satelite-guia),
  ("fig-dos-cuerpos", fig-dos-cuerpos),
)
