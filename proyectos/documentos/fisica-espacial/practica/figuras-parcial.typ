// =====================================================================
//  figuras-parcial.typ -- las figuras de los modelos de parcial
//  Parametrizadas: la misma funcion dibuja la orbita de cualquier
//  ejercicio con SUS datos. Usa el vocabulario de dibujo del apunte
//  (flecha, rotulo, angulo, elipse-orbital...), importado entero.
//
//  OJO (trampa 10 del HANDOFF del apunte): ninguna variable local puede
//  llamarse como una letra griega (nu, gamma, mu, phi, omega, tau, pi...):
//  Typst resolveria $nu$ contra el NUMERO, no contra la letra.
// =====================================================================
#import "../apunte/biblioteca/estilo.typ": *

#let _pt(r, ang) = (r * calc.cos(ang * 1deg), r * calc.sin(ang * 1deg))
#let _suma(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
#let _esc(k, a) = (k * a.at(0), k * a.at(1))

// ---------------------------------------------------------------------
// Orbitas circulares concentricas, con (o sin) la media elipse de Hohmann.
//   r1, r2    : radios DIBUJADOS (no a escala real si se dice en el pie)
//   rot1/rot2 : rotulos de cada orbita
//   blanco    : angulo (grados) donde esta el blanco en el primer encendido
// ---------------------------------------------------------------------
#let fig-hohmann-p(r1, r2, rot1: none, rot2: none, transfer: true, blanco: none, rot-blanco: [estación],
  superficie: none, rot-sup: none, escala: 0.85cm) = esquema(escala: escala, {
  let O = (0, 0)
  if superficie != none {
    cetz.draw.circle(O, radius: superficie, fill: c-orbe.lighten(80%), stroke: 0.7pt + c-orbe)
    cetz.draw.circle(O, radius: 0.04, fill: c-orbe, stroke: none)
    if rot-sup != none { rotulo((0, -superficie * 0.45), text(fill: c-orbe)[#rot-sup], ancla: "center") }
  } else {
    cuerpo-central(O, radio: 0.3)
  }
  cetz.draw.circle(O, radius: r1, stroke: 0.7pt + c-trazo)
  cetz.draw.circle(O, radius: r2, stroke: (paint: c-trazo, thickness: 0.7pt, dash: "dashed"))
  if rot1 != none { rotulo(_pt(r1, -62), rot1, ancla: "north-west") }
  if rot2 != none { rotulo(_pt(r2, -40), rot2, ancla: "north-west") }
  if transfer {
    let et = (r2 - r1) / (r2 + r1)
    let pt = 2 * r1 * r2 / (r1 + r2)
    arco-conica(O, pt, et, desde: 0, hasta: 180, color: c-verde, grosor: trazo-curva)
    rotulo(_pt((r1 + r2) / 2 * 0.95, 95), text(fill: c-verde)[transferencia], ancla: "south")
    masa((r1, 0), radio: 0.07, color: c-dato)
    flecha((r1, 0), (r1, 0.75), color: c-dato, etiqueta: $Delta v_1$, lado: "west", pos: 100%)
    masa((-r2, 0), radio: 0.07, color: c-dato)
    flecha((-r2, 0), (-r2, -0.75), color: c-dato, etiqueta: $Delta v_2$, lado: "east", pos: 100%)
    rotulo((r1 + 0.05, -0.05), [$P$], ancla: "north-west")
    rotulo((-r2 - 0.05, 0.05), [$A$], ancla: "south-east")
  }
  if blanco != none {
    let B = _pt(r2, blanco)
    masa(B, radio: 0.08, color: c-aux)
    rotulo(_suma(B, (0.08, 0.05)), text(fill: c-aux)[#rot-blanco], ancla: "south-west")
    auxiliar(O, B)
    auxiliar(O, (r2, 0))
    angulo(O, 0, blanco, etiqueta: $phi.alt$, radio: 0.75, color: c-aux)
  }
})

// ---------------------------------------------------------------------
// Una elipse con la Tierra en el foco, el perigeo a la derecha, y puntos
// marcados. Cada punto es un diccionario:
//   (anom: grados, rot: [..], vel: true/false, gam: grados, rot-v: [..],
//    rot-r: [..], ver-anom: true/false)
// ---------------------------------------------------------------------
#let fig-orbita-p(ex, ad, puntos: (), rot-p: [$P$], rot-a: [$A$], radio-tierra: 0.45,
  dv-apsides: false, escala: 0.9cm, eje: true) = esquema(escala: escala, {
  let F = (0, 0)
  let pp = ad * (1 - ex * ex)
  elipse-orbital(F, ad, ex, giro: 180deg, grosor: 0.8pt)
  cuerpo-central(F, radio: radio-tierra)
  let rp = ad * (1 - ex)
  let ra = ad * (1 + ex)
  if eje { auxiliar((-ra, 0), (rp, 0)) }
  masa((rp, 0), radio: 0.06)
  rotulo((rp + 0.06, 0), rot-p, ancla: "west")
  masa((-ra, 0), radio: 0.06)
  rotulo((-ra - 0.06, 0), rot-a, ancla: "east")
  if dv-apsides {
    flecha((rp, 0), (rp, 0.8), color: c-dato, etiqueta: $Delta v_P$, lado: "west", pos: 100%)
    flecha((-ra, 0), (-ra, -0.8), color: c-aux, etiqueta: $Delta v_A$, lado: "east", pos: 100%)
  }
  for q in puntos {
    let an = q.anom
    let rr = pp / (1 + ex * calc.cos(an * 1deg))
    let Q = _pt(rr, an)
    flecha(F, Q, color: c-trazo, etiqueta: q.at("rot-r", default: $bold(r)$), lado: q.at("lado-r", default: "north-west"), pos: 60%, grosor: 0.6pt)
    masa(Q, radio: 0.07, color: c-dato)
    if q.at("rot", default: none) != none {
      rotulo(_suma(Q, q.at("desp", default: (0.1, -0.1))), q.rot, ancla: q.at("ancla", default: "north-west"))
    }
    if q.at("ver-anom", default: true) {
      angulo(F, 0, an, etiqueta: q.at("rot-anom", default: $nu$), radio: q.at("radio-anom", default: 0.75), color: c-aux)
    }
    if q.at("vel", default: false) {
      let g = q.at("gam-dib", default: q.at("gam", default: 0))
      let rh = (calc.cos(an * 1deg), calc.sin(an * 1deg))
      let th = (-calc.sin(an * 1deg), calc.cos(an * 1deg))
      let L = 1.6
      let dirv = _suma(_esc(calc.cos(g * 1deg), th), _esc(calc.sin(g * 1deg), rh))
      auxiliar(_suma(Q, _esc(-0.5, th)), _suma(Q, _esc(1.35, th)))
      flecha(Q, _suma(Q, _esc(L, dirv)), color: c-dato, etiqueta: q.at("rot-v", default: $bold(v)$), lado: "south-west", pos: 100%)
      // el arco de gamma, entre la horizontal local y v
      let ang-th = an + 90
      let ang-v = ang-th - g
      if g != 0 {
        angulo(Q, calc.min(ang-th, ang-v), calc.max(ang-th, ang-v), etiqueta: $gamma$, radio: 0.95, color: c-dato)
      }
    }
  }
})

// ---------------------------------------------------------------------
// Un cohete vertical, con las fuerzas. etapas: 1 o 2. baja: si la
// velocidad inicial apunta hacia abajo (el que llega desde afuera).
// ---------------------------------------------------------------------
#let fig-cohete-p(etapas: 1, baja: false, suelo: [Tierra], rot-y0: none, datos: none, escala: 0.9cm) = esquema(escala: escala, {
  let x0 = 0
  let base = if baja { 3.4 } else { 1.7 }
  let alto = if etapas == 2 { 3.2 } else { 2.4 }
  // suelo
  cetz.draw.line((-2.7, 0), (2.6, 0), stroke: 1pt + c-trazo)
  for i in range(0, 12) {
    let xx = -2.1 + i * 0.4
    cetz.draw.line((xx, 0), (xx - 0.2, -0.2), stroke: 0.4pt + c-guia)
  }
  rotulo((2.6, -0.05), suelo, ancla: "north-east")
  // cuerpo
  let w = 0.34
  cetz.draw.rect((x0 - w, base), (x0 + w, base + alto), fill: luma(236), stroke: 0.8pt + c-trazo)
  cetz.draw.line((x0 - w, base + alto), (x0, base + alto + 0.6), (x0 + w, base + alto), close: true,
    fill: luma(215), stroke: 0.8pt + c-trazo)
  if etapas == 2 {
    let corte = base + 1.6
    cetz.draw.line((x0 - w - 0.12, corte), (x0 + w + 0.12, corte), stroke: (paint: c-dato, thickness: 0.9pt, dash: "dashed"))
    rotulo((x0, base + 0.8), [*1*], ancla: "center")
    rotulo((x0, base + 2.4), [*2*], ancla: "center")
    rotulo((x0 - w - 0.15, corte), text(fill: c-dato)[desacople], ancla: "east")
  }
  // llama
  cetz.draw.line((x0 - 0.22, base), (x0, base - 0.55), (x0 + 0.22, base), close: true,
    fill: c-ambar.lighten(55%), stroke: 0.5pt + c-ambar)
  // empuje, peso, gases
  let cm = (x0, base + alto * 0.5)
  // el empuje, a la derecha y hacia arriba; el peso, a la izquierda y hacia abajo
  flecha((x0 + 0.75, base + 0.2), (x0 + 0.75, base + 1.5), color: c-dato, etiqueta: [empuje \ $mu v_r$], lado: "west", pos: 100%)
  flecha((x0 - 0.75, base + alto * 0.45), (x0 - 0.75, base + alto * 0.45 - 1.0), color: c-trazo, etiqueta: $M(t) g$, lado: "east", pos: 100%)
  flecha((x0 + 0.3, base - 0.35), (x0 + 0.3, base - 1.2), color: c-ambar, etiqueta: [gases], lado: "west", pos: 100%)
  // velocidad
  if baja {
    flecha((x0 - 2.3, base + alto), (x0 - 2.3, base + alto - 1.2), color: c-aux, etiqueta: $v_0$, lado: "east", pos: 100%)
  } else {
    flecha((x0 - 2.3, base + 1.0), (x0 - 2.3, base + 2.2), color: c-aux, etiqueta: $v$, lado: "east", pos: 100%)
  }
  // eje y
  flecha((2.2, 0), (2.2, base + alto + 0.9), color: luma(60), etiqueta: $y$, lado: "south", pos: 100%, grosor: 0.6pt)
  if rot-y0 != none {
    auxiliar((x0 + w, base), (2.2, base))
    rotulo((2.25, base), rot-y0, ancla: "west")
  }
  if datos != none { rotulo((2.9, base + alto * 0.55), datos, ancla: "west") }
})

// ---------------------------------------------------------------------
// Dos etapas que se separan en orbita circular (Ej. 1 del modelo 1).
// ---------------------------------------------------------------------
#let fig-separacion = esquema(escala: 1cm, {
  let O = (0, 0)
  cuerpo-central(O, radio: 0.8, etiqueta: [Tierra])
  cetz.draw.arc(O, start: -30deg, stop: 210deg, radius: 2.4, anchor: "origin", stroke: 0.7pt + c-trazo)
  rotulo(_pt(2.4, 200), [órbita circular \ a 300 km], ancla: "east")
  let S = (0, 2.4)
  // la 4.a etapa adelante (hacia -x, sentido antihorario visto desde arriba)
  cetz.draw.rect((-1.2, 2.28), (-0.6, 2.52), fill: luma(225), stroke: 0.7pt + c-trazo)
  rotulo((-0.9, 2.6), [4.ª: 200 kg], ancla: "south")
  cetz.draw.rect((0.2, 2.26), (1.1, 2.54), fill: luma(240), stroke: 0.7pt + c-trazo)
  rotulo((0.65, 2.6), [3.ª: 400 kg], ancla: "south")
  flecha((-1.2, 2.4), (-2.6, 2.4), color: c-dato, etiqueta: $v_4$, lado: "south", pos: 100%)
  flecha((0.2, 2.4), (-0.5, 2.4), color: c-aux, etiqueta: $v_3$, lado: "north", pos: 100%)
  rotulo((0, 1.95), text(fill: luma(70))[separación], ancla: "north")
})

// ---------------------------------------------------------------------
// Satelite con rueda de reaccion, visto desde el eje z (Ej. 6, modelo 1).
// ---------------------------------------------------------------------
#let fig-rueda-reaccion = esquema(escala: 1cm, {
  cetz.draw.rect((-1.6, -1.6), (1.6, 1.6), fill: luma(240), stroke: 0.8pt + c-trazo)
  cetz.draw.circle((0, 0), radius: 0.55, fill: c-aux.lighten(75%), stroke: 0.8pt + c-aux)
  cetz.draw.circle((0, 0), radius: 0.06, fill: c-trazo, stroke: none)
  rotulo((0, -0.62), text(fill: c-aux)[rueda, $I_w$], ancla: "north")
  rotulo((-1.55, 1.5), [satélite, $I_s$], ancla: "north-west")
  cetz.draw.arc((0, 0), start: 20deg, stop: 150deg, radius: 0.85, anchor: "origin",
    stroke: 0.9pt + c-aux, mark: (end: "stealth", scale: 0.5, fill: c-aux))
  rotulo((0.1, 0.9), text(fill: c-aux)[$omega_"rel"$], ancla: "south")
  cetz.draw.arc((0, 0), start: 200deg, stop: 320deg, radius: 2.1, anchor: "origin",
    stroke: 0.9pt + c-dato, mark: (start: "stealth", scale: 0.5, fill: c-dato))
  rotulo(_pt(2.15, 260), text(fill: c-dato)[$omega_s$ ?], ancla: "north")
  rotulo((1.75, 0), [eje $z$ saliendo \ de la hoja], ancla: "west")
})

// ---------------------------------------------------------------------
// Acople oblicuo de dos naves (Ej. 1 del modelo 2).
// ---------------------------------------------------------------------
#let fig-acople = paneles(
  ("antes", esquema(escala: 1cm, {
    let O = (0, 0)
    masa(O, radio: 0.08)
    rotulo((0.1, 0.1), [punto de acople], ancla: "south-west")
    cetz.draw.rect((-3.1, -0.25), (-2.3, 0.25), fill: luma(225), stroke: 0.7pt + c-trazo)
    rotulo((-2.7, 0.3), [$A$: 3000 kg], ancla: "south")
    flecha((-2.3, 0), (-0.9, 0), color: c-dato, etiqueta: [0,40 m/s], lado: "south")
    cetz.draw.rect((-0.3, -2.9), (0.3, -2.3), fill: luma(240), stroke: 0.7pt + c-trazo)
    rotulo((0.35, -2.6), [$B$: 1000 kg], ancla: "west")
    flecha((0, -2.3), (0, -1.0), color: c-aux, etiqueta: [0,30 m/s], lado: "west")
    flecha((-2.8, -2.6), (-2.0, -2.6), color: luma(80), etiqueta: $x$, lado: "south", pos: 100%, grosor: 0.5pt)
    flecha((-2.8, -2.6), (-2.8, -1.8), color: luma(80), etiqueta: $y$, lado: "west", pos: 100%, grosor: 0.5pt)
  })),
  ("después", esquema(escala: 1cm, {
    let O = (0, 0)
    cetz.draw.rect((-0.55, -0.25), (0.25, 0.25), fill: luma(225), stroke: 0.7pt + c-trazo)
    cetz.draw.rect((0.25, -0.3), (0.85, 0.3), fill: luma(240), stroke: 0.7pt + c-trazo)
    rotulo((0.15, -0.35), [$A + B$ unidos], ancla: "north")
    flecha((0.9, 0.1), (2.3, 0.45), color: c-verde, etiqueta: [$bold(v)_f$ ?], lado: "south-east", pos: 100%)
  })),
)

// ---------------------------------------------------------------------
// Lanzamiento vertical desde la Luna (Ej. 3 del modelo 2).
// ---------------------------------------------------------------------
#let fig-luna-vertical = esquema(escala: 1cm, {
  let C = (0, -4.6)
  cetz.draw.arc(C, start: 55deg, stop: 125deg, radius: 4.6, anchor: "origin",
    fill: luma(228), stroke: 0.8pt + c-trazo)
  rotulo((2.4, -0.5), [Luna, $R_L = 1740$ km], ancla: "west")
  masa((0, 0), radio: 0.08)
  flecha((0, 0.1), (0, 1.3), color: c-dato, etiqueta: [$v_0 = 2,0$ km/s], lado: "west", pos: 60%)
  auxiliar((0, 0), (0, 3.6))
  cetz.draw.line((-0.3, 3.6), (0.3, 3.6), stroke: 0.7pt + c-trazo)
  rotulo((0.35, 3.6), [altura máxima $h_"máx"$ ?], ancla: "west")

})

// ---------------------------------------------------------------------
// La banqueta y la rueda (Ej. 6 del modelo 2).
// ---------------------------------------------------------------------
#let _banqueta(sentido-rueda, con-omega) = esquema(escala: 0.85cm, {
  // la banqueta
  cetz.draw.line((0, 0), (0, 1.2), stroke: 1.4pt + c-trazo)
  cetz.draw.line((-0.6, 0), (0.6, 0), stroke: 1pt + c-trazo)
  circulo-escorzo((0, 1.25), 0.7, achatado: 0.25, color: c-trazo, grosor: 0.8pt, punteada: false)
  // la persona, esquematica
  cetz.draw.line((0, 1.3), (0, 2.9), stroke: 1.2pt + c-trazo)
  cetz.draw.circle((0, 3.2), radius: 0.28, stroke: 1pt + c-trazo)
  cetz.draw.line((0, 2.6), (0.55, 3.35), stroke: 1pt + c-trazo)
  cetz.draw.line((0, 2.6), (-0.55, 3.35), stroke: 1pt + c-trazo)
  // la rueda, horizontal, sobre la cabeza
  circulo-escorzo((0, 3.85), 0.95, achatado: 0.22, color: c-aux, grosor: 1.1pt, punteada: false)
  cetz.draw.line((0, 3.55), (0, 4.15), stroke: 0.8pt + c-trazo)
  if sentido-rueda > 0 {
    flecha((0, 4.15), (0, 5.3), color: c-aux, etiqueta: $bold(L)_r$, lado: "west", pos: 100%)
  } else {
    flecha((1.3, 3.85), (1.3, 2.7), color: c-aux, etiqueta: $-bold(L)_r$, lado: "west", pos: 100%)
  }
  if con-omega {
    cetz.draw.arc((0, 0.95), start: 200deg, stop: 340deg, radius: (0.95, 0.3), anchor: "origin",
      stroke: 0.9pt + c-dato, mark: (end: "stealth", scale: 0.5, fill: c-dato))
    rotulo((1.0, 0.6), text(fill: c-dato)[$Omega$ ?], ancla: "west")
  }
})
#let fig-banqueta = paneles(
  ("antes: todo quieto salvo la rueda", _banqueta(1, false)),
  ("después: la rueda dada vuelta", _banqueta(-1, true)),
)

// ---------------------------------------------------------------------
// La explosion en tres fragmentos (Ej. 1 del modelo 3). Con `triangulo`
// dibuja ademas el triangulo de las cantidades de movimiento.
// ---------------------------------------------------------------------
#let fig-explosion(triangulo: false) = {
  let estrella = esquema(escala: 0.95cm, {
    let O = (0, 0)
    masa(O, radio: 0.1)
    rotulo((-0.15, 0.15), [$O$], ancla: "south-east")
    flecha(O, _pt(2.4, 0), color: c-dato, etiqueta: [$A$: 20 kg, 30 m/s], lado: "south", pos: 70%)
    flecha(O, _pt(1.6, 120), color: c-aux, etiqueta: [$B$: 30 kg, 20 m/s], lado: "east", pos: 100%)
    flecha(O, _pt(1.2, 240), color: c-verde, etiqueta: [$C$: 50 kg, ?], lado: "east", pos: 100%, punteada: true)
    angulo(O, 0, 120, etiqueta: [$120°$], radio: 0.55)
  })
  if not triangulo { return estrella }
  let tri = esquema(escala: 0.95cm, {
    // p_A + p_B + p_C = 0: puestos uno detras del otro, cierran
    let P0 = (0, 0)
    let P1 = _pt(2.4, 0)
    let P2 = _suma(P1, _pt(2.4, 120))
    flecha(P0, P1, color: c-dato, etiqueta: $bold(p)_A$, lado: "north")
    flecha(P1, P2, color: c-aux, etiqueta: $bold(p)_B$, lado: "west")
    flecha(P2, P0, color: c-verde, etiqueta: $bold(p)_C$, lado: "east")
    rotulo((1.2, -0.55), [los tres de $600$ kg·m/s], ancla: "north")
  })
  paneles(("las velocidades", estrella), ("las cantidades de movimiento, en cadena", tri))
}

// ---------------------------------------------------------------------
// El giroscopo sobre un pivote, de costado. Con `respuesta` dibuja L, tau
// y el sentido de la precesion.
// ---------------------------------------------------------------------
#let fig-giroscopo-p(respuesta: false, rot-d: [$d = 4,0$ cm]) = esquema(escala: 0.8cm, {
  let P = (0, 2.4)
  let C = (2.5, 2.4)
  cetz.draw.line((-0.9, 0), (0.9, 0), stroke: trazo-cuerpo + c-trazo)
  cetz.draw.line((0, 0), P, stroke: 1.6pt + c-trazo)
  cetz.draw.line(P, (3.3, 2.4), stroke: 1.2pt + c-trazo)
  cetz.draw.circle(C, radius: (0.25, 1.0), fill: luma(225), stroke: trazo-cuerpo + c-trazo)
  masa(C, radio: 0.06)
  masa(P, radio: 0.07)
  rotulo((-0.15, 2.4), [pivote], ancla: "east")
  flecha(C, (2.5, 0.6), etiqueta: $m bold(g)$, lado: "east", pos: 100%)
  auxiliar(P, (0, 3.9))
  auxiliar((2.5, 3.5), (2.5, 3.9))
  cetz.draw.line((0, 3.8), (2.5, 3.8), stroke: 0.5pt + luma(80),
    mark: (start: "stealth", end: "stealth", scale: 0.35, fill: luma(80)))
  rotulo((1.25, 3.8), rot-d, ancla: "south")
  if respuesta {
    flecha((3.3, 2.4), (5.0, 2.4), color: c-aux, etiqueta: $bold(L)$, lado: "south", pos: 100%)
    // tau entra en la hoja: se dibuja como el simbolo "cruz en un circulo"
    cetz.draw.circle((-0.7, 3.25), radius: 0.22, stroke: 0.9pt + c-dato)
    cetz.draw.line((-0.85, 3.1), (-0.55, 3.4), stroke: 0.9pt + c-dato)
    cetz.draw.line((-0.85, 3.4), (-0.55, 3.1), stroke: 0.9pt + c-dato)
    rotulo((-0.95, 3.25), text(fill: c-dato)[$bold(tau)$ respecto del pivote: \ entra en la hoja], ancla: "east")
    rotulo((4.6, 1.9), text(fill: c-aux)[$bold(L)$ gira hacia \ adentro de la hoja], ancla: "north")
  } else {
    cetz.draw.arc((3.45, 2.4), start: 130deg, stop: 410deg, radius: (0.14, 0.4), anchor: "origin",
      stroke: 0.8pt + c-aux, mark: (end: "stealth", scale: 0.45, fill: c-aux))
    rotulo((3.65, 2.8), text(fill: c-aux)[giro propio $omega$: antihorario \ visto desde la derecha], ancla: "west")
  }
})

// ---------------------------------------------------------------------
// Particula libre y el punto O (Ej. 7 del modelo 1).
// ---------------------------------------------------------------------
#let fig-particula-libre = esquema(escala: 1cm, {
  let O = (0, 0)
  masa(O, radio: 0.08, etiqueta: [$O$], hacia: "north-east")
  cetz.draw.line((-2.6, 1.6), (3.6, 1.6), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  let Q1 = (-1.4, 1.6)
  let Q2 = (2.2, 1.6)
  masa(Q1, radio: 0.1, color: c-dato)
  masa(Q2, radio: 0.1, color: c-dato.lighten(35%))
  flecha(Q1, (-0.4, 1.6), color: c-dato, etiqueta: $bold(v)$, lado: "south")
  flecha(O, Q1, color: c-trazo, etiqueta: $bold(r)(t_1)$, lado: "east", grosor: 0.6pt)
  flecha(O, Q2, color: c-trazo, etiqueta: $bold(r)(t_2)$, lado: "west", grosor: 0.6pt)
  auxiliar(O, (0, 1.6), etiqueta: $d$, ancla: "east")
  recto((0, 1.6), 270, 0)
  rotulo((3.6, 1.7), [recta de la trayectoria], ancla: "south-east")
})

// ---------------------------------------------------------------------
// Dos particulas antiparalelas y dos origenes (Ej. 7 del modelo 2).
// ---------------------------------------------------------------------
#let fig-antiparalelas = esquema(escala: 1cm, {
  cetz.draw.line((-3, 1.2), (3, 1.2), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  cetz.draw.line((-3, -0.8), (3, -0.8), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  masa((-0.8, 1.2), radio: 0.1, color: c-dato)
  flecha((-0.8, 1.2), (0.4, 1.2), color: c-dato, etiqueta: $bold(v)$, lado: "south")
  rotulo((-0.8, 1.3), [1], ancla: "south")
  masa((1.2, -0.8), radio: 0.1, color: c-aux)
  flecha((1.2, -0.8), (0.0, -0.8), color: c-aux, etiqueta: $-bold(v)$, lado: "north")
  rotulo((1.2, -0.9), [2], ancla: "north")
  cetz.draw.line((2.6, 1.2), (2.6, -0.8), stroke: 0.5pt + luma(80),
    mark: (start: "stealth", end: "stealth", scale: 0.35, fill: luma(80)))
  rotulo((2.65, 0.2), [$d$], ancla: "west")
  masa((-2.2, -2.0), radio: 0.07, etiqueta: [$O$], hacia: "north-east")
  masa((1.8, 2.3), radio: 0.07, etiqueta: [$O'$], hacia: "west")
  flecha((-2.2, -2.0), (1.8, 2.3), color: luma(90), etiqueta: $bold(R)$, lado: "north-west", grosor: 0.5pt, punteada: true)
})

// ---------------------------------------------------------------------
// Tierra, geoestacionaria y la Luna, sin escala (Ej. 3 del modelo 3).
// ---------------------------------------------------------------------
#let fig-tierra-luna = esquema(escala: 1cm, {
  let O = (0, 0)
  cuerpo-central(O, radio: 0.35, etiqueta: [Tierra])
  cetz.draw.circle(O, radius: 1.3, stroke: (paint: c-aux, thickness: 0.7pt, dash: "dashed"))
  rotulo(_pt(1.3, 40), text(fill: c-aux)[geoestacionaria, $r_g$ ?], ancla: "south-west")
  cetz.draw.arc(O, start: -35deg, stop: 35deg, radius: 4.2, anchor: "origin", stroke: 0.7pt + c-trazo)
  masa(_pt(4.2, 0), radio: 0.14, color: luma(120))
  rotulo((4.4, 0), [Luna], ancla: "west")
  auxiliar(O, _pt(4.2, 0))
  rotulo((2.75, -0.1), [$r_L = 384 thin 400$ km], ancla: "north")
  rotulo((2.1, 1.6), text(fill: luma(80))[sin escala], ancla: "west")
})

// ---------------------------------------------------------------------
// Integrador: el cilindro con un propulsor en el borde, y el yo-yo.
// ---------------------------------------------------------------------
#let fig-cilindro-propulsor = esquema(escala: 0.9cm, {
  let R = 1.0
  let H = 3.0
  circulo-escorzo((0, 0), R, achatado: 0.3, color: c-trazo, grosor: 0.7pt, punteada: true)
  circulo-escorzo((0, H), R, achatado: 0.3, color: c-trazo, grosor: 0.8pt, punteada: false)
  cetz.draw.line((-R, 0), (-R, H), stroke: 0.8pt + c-trazo)
  cetz.draw.line((R, 0), (R, H), stroke: 0.8pt + c-trazo)
  cetz.draw.arc((0, 0), start: 180deg, stop: 360deg, radius: (R, 0.3), anchor: "origin", stroke: 0.8pt + c-trazo)
  flecha((0, H), (0, H + 1.4), color: luma(60), etiqueta: $z$, lado: "west", pos: 100%, grosor: 0.6pt)
  flecha((0, H * 0.5), (1.9, H * 0.5), color: luma(60), etiqueta: $x$, lado: "south", pos: 100%, grosor: 0.6pt)
  masa((0, H * 0.5), radio: 0.06, etiqueta: [$G$], hacia: "north-west")
  cetz.draw.arc((0, H + 0.9), start: 200deg, stop: 520deg, radius: (0.45, 0.13), anchor: "origin",
    stroke: 0.8pt + c-aux, mark: (end: "stealth", scale: 0.45, fill: c-aux))
  rotulo((0.5, H + 0.95), text(fill: c-aux)[$omega_0$], ancla: "west")
  // propulsor en el borde, a la altura del centro de masa, empujando en +z
  cetz.draw.rect((R, H * 0.5 - 0.15), (R + 0.3, H * 0.5 + 0.15), fill: c-dato.lighten(70%), stroke: 0.6pt + c-dato)
  flecha((R + 0.15, H * 0.5 + 0.2), (R + 0.15, H * 0.5 + 1.4), color: c-dato, etiqueta: [$F = 100$ N], lado: "west", pos: 100%)
  rotulo((-R - 0.1, H * 0.5), [$R = 1,0$ m \ alto $3,0$ m], ancla: "east")
})

#let fig-yoyo = esquema(escala: 0.85cm, {
  let O = (0, 0)
  cetz.draw.circle(O, radius: 1.0, fill: luma(235), stroke: 0.8pt + c-trazo)
  cetz.draw.circle(O, radius: 0.05, fill: c-trazo, stroke: none)
  masa((0.5, 0), radio: 0.1, color: c-dato)
  masa((-0.5, 0), radio: 0.1, color: c-dato)
  cetz.draw.line((0.5, 0), (3.0, 0), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  cetz.draw.line((-0.5, 0), (-3.0, 0), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  masa((3.0, 0), radio: 0.1, color: c-dato.lighten(50%))
  masa((-3.0, 0), radio: 0.1, color: c-dato.lighten(50%))
  rotulo((0.5, -0.15), [$0,5$ m], ancla: "north")
  rotulo((3.0, 0.15), [$3,0$ m], ancla: "south")
  rotulo((0, -1.05), [$I = 40$ kg·m²], ancla: "north")
  cetz.draw.arc(O, start: 30deg, stop: 150deg, radius: 1.35, anchor: "origin",
    stroke: 0.9pt + c-aux, mark: (end: "stealth", scale: 0.5, fill: c-aux))
  rotulo((0, 1.4), text(fill: c-aux)[60 rpm], ancla: "south")
})

// ---------------------------------------------------------------------
// v(t) del cohete de dos etapas (resolucion del Ej. 2 del modelo 2).
// Se calcula aca, con las mismas formulas del texto.
// ---------------------------------------------------------------------
#let fig-v-dos-etapas = {
  let g0 = 9.81
  let v1 = t => 2500 * calc.ln(30000 / (30000 - 300 * t)) - g0 * t
  let v1f = v1(60)
  let v2 = t => v1f + 3000 * calc.ln(9000 / (9000 - 60 * (t - 60))) - g0 * (t - 60)
  let pts1 = range(0, 61).map(t => (t, v1(t) / 1000))
  let pts2 = range(60, 161).map(t => (t, v2(t) / 1000))
  grafico({
    ejes-libro(tam: (8, 4.2), x-label: [$t$ (s)], y-label: [$v$ (km/s)],
      x-min: 0, x-max: 175, y-min: 0, y-max: 4.6,
      x-tick-step: 20, y-tick-step: 1, {
      plot.add(pts1, style: (stroke: trazo-curva + c-dato))
      plot.add(pts2, style: (stroke: trazo-curva + c-aux))
      plot.add(((60, 0), (60, 4.4)), style: (stroke: punteado))
    })
    rotulo((8 * 60 / 175 + 0.1, 3.9), [desacople, $t = 60$ s], ancla: "west")
    rotulo((8 * 12 / 175, 1.5), text(fill: c-dato)[etapa 1], ancla: "west")
    rotulo((8 * 110 / 175, 2.2), text(fill: c-aux)[etapa 2], ancla: "north-west")
  })
}
