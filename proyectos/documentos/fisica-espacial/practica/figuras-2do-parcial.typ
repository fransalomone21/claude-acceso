// =====================================================================
//  figuras-2do-parcial.typ -- los dibujos de los dos modelos del 2.o
//  parcial (2026-11-25, pedido de Fran: «con dibujos vectoriales
//  efectivos»). Cada sentido sale de cuentas_2do_parcial.py, no del ojo:
//    A1  H0 = (0;0;288), r_A x J = (0;120;-64), H = (0;120;224), omega en el
//        plano y-z; alargada (I < I'), theta 28,2 > gamma 13,4: directa.
//    A3  libre de cupla y achatada: (omega_x, omega_y) gira, visto desde el
//        cuerpo, en el MISMO sentido que omega_z (lambda > 0).
//    A4  L sobre +x (a la derecha de ella); levantar el extremo derecho pide
//        un torque sobre -y (hacia ella): Delta L va sobre -y.
//    B1  H0 = (0;0;900), r_C x p = (-600;0;0), H = (-600;0;900), omega =
//        (-1,5625;0;1,5); achatado, gamma 46,2 > theta 33,7: retrograda.
//    B   extra: h gira delta alrededor del eje del cardan; el satelite se
//        lleva -Delta h.
//  OJO (trampa 10 del HANDOFF del apunte): ninguna variable local se llama
//  como una letra griega; aca van te, ga, de, wv.
// =====================================================================
#import "../apunte/biblioteca/estilo.typ": *
#import "../apunte/biblioteca/estilo.typ" as est
#import "../apunte/biblioteca/perspectiva.typ": *
#import "figuras-cr-guia.typ": _libre

// Rotulos con halo y en la capa de arriba (lo que mide verificar-figuras.py).
#let rotulo(pos, cuerpo, ..args) = cetz.draw.on-layer(2,
  est.rotulo(pos, box(fill: white, inset: (x: 1.2pt, y: 0.8pt), cuerpo), ..args))
#let rotulo3(v, p, cuerpo, ..args) = rotulo(p3(v, p), cuerpo, ..args)
#let _nota(pos, cuerpo, ..args) = rotulo(pos, text(size: 7.5pt, fill: luma(60), cuerpo), ..args)
#let _p2(r, ang) = (r * calc.cos(ang * 1deg), r * calc.sin(ang * 1deg))

// ---------------------------------------------------------------------
// A1 -- la sonda alargada y el pulso del propulsor en A (enunciado).
// Mundo = ejes del cuerpo: z sobre el eje de la sonda, G en el origen.
// ---------------------------------------------------------------------
#let fig-a1-sonda = esquema(escala: 0.78cm, {
  let v = vista3d(az: 35, el: 18)
  let G = (0, 0, 0)
  cilindro3(v, G, (0, 0, 1), 0.8, 3.0)
  masa3(v, G, radio: 0.05)
  rotulo3(v, G, [$G$], ancla: "north-east")
  linea3(v, ((0, 0, 1.5), (0, 0, 2.3)), color: luma(70), grosor: 0.6pt)
  flecha3(v, (0, 0, 2.3), (0, 0, 3.2), color: luma(70))
  rotulo3(v, (0, 0, 3.25), [$z$], ancla: "south")
  giro3(v, (0, 0, 2.6), (0, 0, 1), (1, 0, 0), 0.35, 290, color: c-aux)
  rotulo3(v, (0, -0.45, 2.65), text(fill: c-aux)[$omega_0$], ancla: "east")
  flecha3(v, (0, 0.8, 0), (0, 2.6, 0), color: luma(70))
  rotulo3(v, (0, 2.65, 0), [$y$], ancla: "west")
  linea3(v, (G, (0, 0.8, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
  flecha3(v, G, (2.6, 0, 0), color: luma(70))
  rotulo3(v, (2.65, 0, 0), [$x$], ancla: "north-east")
  let A = (0, 0.8, 1.5)
  masa3(v, A, radio: 0.06, color: c-dato)
  rotulo3(v, A, [$A$], ancla: "south-west")
  flecha3(v, A, (1.9, 0.8, 1.5), color: c-dato, grosor: 1.2pt)
  rotulo3(v, (1.9, 0.8, 1.5), text(fill: c-dato)[$bold(J)$ (sobre $+x$)], ancla: "east")
  rotulo3(v, (0, 0.2, -2.0), [$bold(r)_A = (0; 0,80; 1,50)$ m respecto de $G$], ancla: "north")
})

// ---------------------------------------------------------------------
// A1 -- la suma H0 + r_A x J = H, en el plano y-z, A ESCALA (1 cm = 60
// kg·m²/s), con omega (que no va sobre H) y los dos angulos.
// ---------------------------------------------------------------------
#let fig-a1-suma = esquema(escala: 1.0cm, {
  let k = 1 / 60
  let H0 = (0, 288 * k)
  let H = (120 * k, 224 * k)
  let te = 28.18
  let ga = 13.39
  cetz.draw.line((-0.6, 0), (3.4, 0), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((3.45, 0), [$y$], ancla: "west")
  cetz.draw.line((0, -0.3), (0, 5.6), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((0, 5.65), [$z$ (eje de la sonda)], ancla: "south")
  rotulo((-0.15, -0.1), [$G$ ($x$ sale de la hoja)], ancla: "east")
  flecha((0, 0), H0, color: c-aux, grosor: 1.1pt)
  rotulo((-0.08, 4.0), text(fill: c-aux)[$bold(H)_0 = I omega_0 hat(k)$], ancla: "east")
  flecha(H0, H, color: c-rojo, grosor: 1.1pt)
  rotulo((1.0, 4.4), text(fill: c-rojo)[$bold(r)_A times bold(J)$], ancla: "south-west")
  flecha((0, 0), H, color: c-verde, grosor: 1.3pt)
  rotulo((2.05, 3.75), text(fill: c-verde)[$bold(H)_G$ (después: fijo)], ancla: "west")
  flecha((0, 0), _p2(3.3, 90 - ga), color: c-dato, grosor: 1.1pt)
  rotulo(_p2(3.35, 90 - ga), text(fill: c-dato)[$bold(omega)$], ancla: "south")
  angulo((0, 0), 90 - te, 90, radio: 2.2)
  rotulo(_p2(2.42, 90 - te / 2 + 3), [$theta$], ancla: "south")
  angulo((0, 0), 90 - ga, 90, radio: 1.3, color: c-dato)
  rotulo(_p2(1.5, 90 - ga / 2), text(fill: c-dato)[$gamma$], ancla: "south")
  _nota((1.2, -0.75), [a escala: 1 cm = 60 kg·m²/s; $theta > gamma$: $bold(omega)$ entre el eje y $bold(H)_G$], ancla: "north")
})

// A1 -- la precesion que sigue: alargada, directa (esquema, no a escala).
#let _largo(v, G, k) = cilindro3(v, G, k, 0.55, 2.0)
#let fig-a1-libre = esquema(escala: 0.9cm, _libre(576 / 1296, 28, _largo, largo-eje: 2.8))

// ---------------------------------------------------------------------
// A3 -- el polo que da vueltas, visto desde el cuerpo (plano x-y de los ejes
// del cuerpo, z hacia el lector). Achatado: lambda > 0, mismo sentido que el
// giro del cuerpo.
// ---------------------------------------------------------------------
#let fig-a3-polo = esquema(escala: 1.0cm, {
  let R = 1.6
  cetz.draw.line((-2.4, 0), (2.6, 0), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((2.65, 0), [$x$], ancla: "west")
  cetz.draw.line((0, -2.2), (0, 2.5), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((0, 2.55), [$y$], ancla: "south")
  cetz.draw.circle((0, 0), radius: R, stroke: punteado)
  cetz.draw.circle((0, 0), radius: 0.09, stroke: 0.6pt + c-trazo)
  cetz.draw.circle((0, 0), radius: 0.025, fill: c-trazo, stroke: none)
  rotulo((-0.15, -0.12), [$z$ ⊙ (eje de figura)], ancla: "north-east")
  flecha((0, 0), _p2(R, 40), color: c-dato, grosor: 1.2pt)
  rotulo(_p2(R + 0.1, 40), text(fill: c-dato)[$bold(omega)_perp = (omega_x; omega_y)$], ancla: "south-west")
  cetz.draw.arc((0, 0), start: 52deg, stop: 120deg, radius: R + 0.3, anchor: "origin",
    stroke: 0.9pt + c-aux, mark: (end: "stealth", scale: 0.45, fill: c-aux))
  rotulo(_p2(R + 0.45, 100), text(fill: c-aux)[$lambda = (I - I')\/I' thin omega_z$], ancla: "south-east")
  _nota((0, -2.3), [achatado ($I > I'$): $lambda > 0$, gira para el mismo lado que el cuerpo], ancla: "north")
})

// ---------------------------------------------------------------------
// A4 -- la estudiante y la rueda. x a la derecha de ella, y hacia adelante,
// z arriba. L sobre +x; para subir el extremo derecho haria falta Delta L
// sobre +z, pero ella aplica un torque sobre -y (hacia ella), y Delta L va
// sobre -y: el extremo derecho viene hacia ella, horizontal.
// ---------------------------------------------------------------------
#let fig-a4-rueda = esquema(escala: 0.95cm, {
  let v = vista3d(az: -30, el: 20)
  let O = (0, 0, 0)
  linea3(v, ((-1.6, 0, 0), (1.6, 0, 0)), grosor: 1.4pt)
  cilindro3(v, O, (1, 0, 0), 1.1, 0.14, relleno: luma(215), tapa: luma(240))
  masa3(v, O, radio: 0.05)
  flecha3(v, (1.6, 0, 0), (3.2, 0, 0), color: c-verde, grosor: 1.3pt)
  rotulo3(v, (3.25, 0, 0.12), text(fill: c-verde)[$bold(L) = I p hat(i)$], ancla: "south-west")
  giro3(v, (1.25, 0, 0), (1, 0, 0), (0, 0, 1), 0.38, 290, color: c-aux)
  rotulo3(v, (1.25, 0, -0.5), text(fill: c-aux)[$p$], ancla: "north")
  flecha3(v, O, (0, -1.9, 0), color: c-rojo, grosor: 1.1pt)
  rotulo3(v, (0, -1.95, -0.1), text(fill: c-rojo)[$bold(tau)$ (hacia ella)], ancla: "north")
  flecha3(v, (3.2, 0, 0), (3.2, -1.1, 0), color: c-rojo, grosor: 1.0pt)
  rotulo3(v, (3.2, -1.15, 0), text(fill: c-rojo)[$Delta bold(L) = bold(tau) Delta t$], ancla: "north-east")
  linea3(v, (O, (3.0, -1.03, 0)), color: c-verde, grosor: 0.6pt, punteada: true)
  linea3(v, ((3.2, 0, 0), (3.2, 0, 1.0)), color: luma(120), grosor: 0.6pt, punteada: true)
  rotulo3(v, (3.2, 0, 1.05), text(fill: luma(80), size: 7.5pt)[lo que ella intenta: subirlo], ancla: "south-west")
  rotulo3(v, (0, -2.6, -1.1), text(size: 7.5pt, fill: luma(60))[ella, del lado de $-y$], ancla: "north")
})

// ---------------------------------------------------------------------
// B1 -- el satelite achatado y el meteorito que entra en C (enunciado).
// ---------------------------------------------------------------------
#let fig-b1-satelite = esquema(escala: 0.9cm, {
  let v = vista3d(az: 30, el: 20)
  let G = (0, 0, 0)
  cilindro3(v, G, (0, 0, 1), 1.0, 0.8)
  masa3(v, G, radio: 0.05)
  flecha3(v, (0, 0, 0.4), (0, 0, 2.3), color: luma(70))
  rotulo3(v, (0, 0, 2.35), [$z$], ancla: "south")
  giro3(v, (0, 0, 1.55), (0, 0, 1), (1, 0, 0), 0.32, 290, color: c-aux)
  rotulo3(v, (0, -0.4, 1.6), text(fill: c-aux)[$omega_0$], ancla: "east")
  flecha3(v, (0, 1.0, 0), (0, 2.4, 0), color: luma(70))
  rotulo3(v, (0, 2.45, 0), [$y$], ancla: "west")
  flecha3(v, (1.0, 0, 0), (2.4, 0, 0), color: luma(70))
  rotulo3(v, (2.45, 0, 0), [$x$], ancla: "north-east")
  let C = (0, 1.0, 0.4)
  masa3(v, C, radio: 0.06, color: c-dato)
  rotulo3(v, C, [$C$], ancla: "north-west")
  flecha3(v, (0, 1.0, 2.1), (0, 1.0, 0.5), color: c-dato, grosor: 1.2pt)
  rotulo3(v, (0, 1.0, 2.15), text(fill: c-dato)[$bold(v)_m$ (paralela a $-z$)], ancla: "south-west")
  rotulo3(v, (0, 0.3, -1.5), [$bold(r)_C = (0; 1,00; 0,40)$ m respecto de $G$], ancla: "north")
})

// ---------------------------------------------------------------------
// B1 -- la suma H0 + r_C x p = H, en el plano x-z, A ESCALA (1 cm = 200
// kg·m²/s). x crece a la derecha; H y omega quedan del lado de -x.
// ---------------------------------------------------------------------
#let fig-b1-suma = esquema(escala: 1.0cm, {
  let k = 1 / 200
  let H0 = (0, 900 * k)
  let H = (-600 * k, 900 * k)
  let te = 33.69
  let ga = 46.17
  cetz.draw.line((-3.8, 0), (1.4, 0), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((1.45, 0), [$x$], ancla: "west")
  cetz.draw.line((0, -0.3), (0, 5.4), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((0, 5.45), [$z$ (eje del satélite)], ancla: "south")
  rotulo((0.1, -0.25), [$G$ ($y$ entra en la hoja)], ancla: "north-west")
  flecha((0, 0), H0, color: c-aux, grosor: 1.1pt)
  rotulo((0.1, 3.4), text(fill: c-aux)[$bold(H)_0 = I omega_0 hat(k)$], ancla: "west")
  flecha(H0, H, color: c-rojo, grosor: 1.1pt)
  rotulo((-1.5, 4.55), text(fill: c-rojo)[$bold(r)_C times bold(p)$], ancla: "south")
  flecha((0, 0), H, color: c-verde, grosor: 1.3pt)
  rotulo((-3.05, 4.5), text(fill: c-verde)[$bold(H)_G$], ancla: "south-east")
  flecha((0, 0), _p2(4.0, 90 + ga), color: c-dato, grosor: 1.1pt)
  rotulo(_p2(4.05, 90 + ga), text(fill: c-dato)[$bold(omega)$], ancla: "east")
  angulo((0, 0), 90, 90 + te, radio: 2.0)
  rotulo(_p2(2.25, 90 + te / 2), [$theta$], ancla: "south")
  angulo((0, 0), 90, 90 + ga, radio: 1.2, color: c-dato)
  rotulo(_p2(1.05, 90 + ga / 2 + 4), text(fill: c-dato)[$gamma$], ancla: "north-east")
  _nota((-1.2, -0.75), [a escala: 1 cm = 200 kg·m²/s; $gamma > theta$: $bold(H)_G$ entre el eje y $bold(omega)$], ancla: "north")
})

// B1 -- la precesion que sigue: achatado, retrograda (esquema).
#let _chato(v, G, k) = cilindro3(v, G, k, 1.05, 0.55)
#let fig-b1-libre = esquema(escala: 0.9cm, _libre(600 / 384, 34, _chato))

// ---------------------------------------------------------------------
// B3 -- las dos precesiones estables del trompo del modelo contra el spin:
// I = 1,2e-4, I' = 6,0e-4 (desde O), W c = 0,11772 N·m, theta = 60.
// (I' - I) cos(theta) phi'^2 - I psi' phi' + W c = 0.
// ---------------------------------------------------------------------
#let fig-b3-raices = esquema(escala: 1.0cm, {
  let Ia = 0.00012
  let Io = 0.0006
  let Wc = 0.11772
  let a = (Io - Ia) * 0.5
  let psmin = 2 * calc.sqrt(a * Wc) / Ia
  let xmax = 400
  let ymax = 100
  let W = 7.6
  let Hh = 4.2
  let X(x) = x / xmax * W
  let Y(y) = y / ymax * Hh
  cetz.draw.line((0, 0), (W + 0.2, 0), stroke: 0.7pt, mark: (end: "stealth", scale: 0.45, fill: black))
  cetz.draw.line((0, 0), (0, Hh + 0.2), stroke: 0.7pt, mark: (end: "stealth", scale: 0.45, fill: black))
  rotulo((W + 0.25, 0), [spin $dot(psi)$ (rad/s)], ancla: "west")
  rotulo((0, Hh + 0.25), [precesión $dot(phi)$ (rad/s)], ancla: "south-west")
  for xx in (100, 200, 300) { marca-x(X(xx), [#xx]) }
  for yy in (25, 50, 75) { marca-y(Y(yy), [#yy]) }
  let n = 160
  let pts-l = ()
  let pts-r = ()
  for i in range(0, n + 1) {
    let ps = psmin + (xmax - 10 - psmin) * calc.pow(i / n, 1.6)
    let d = calc.sqrt(calc.max(0, Ia * Ia * ps * ps - 4 * a * Wc))
    pts-l.push((X(ps), Y((Ia * ps - d) / (2 * a))))
    let yr = (Ia * ps + d) / (2 * a)
    if yr <= ymax { pts-r.push((X(ps), Y(yr))) }
  }
  cetz.draw.line(..pts-r, stroke: trazo-curva + c-aux)
  cetz.draw.line(..pts-l, stroke: trazo-curva + c-dato)
  cetz.draw.line((X(psmin), 0), (X(psmin), Y(Ia * psmin / (2 * a))), stroke: punteado)
  masa((X(psmin), Y(Ia * psmin / (2 * a))), radio: 0.07)
  rotulo((X(psmin) + 0.2, Y(26)), [$dot(psi)_"mín" approx 89$ rad/s], ancla: "west")
  masa((X(150), Y(67.76)), radio: 0.07, color: c-aux)
  rotulo((X(150) + 0.1, Y(67.76)), text(fill: c-aux)[la rápida: 67,8 rad/s], ancla: "west")
  masa((X(150), Y(7.239)), radio: 0.07, color: c-dato)
  rotulo((X(150) + 0.05, Y(7.239) + 0.12), text(fill: c-dato)[la lenta: 7,24 rad/s (la que se ve)], ancla: "south-west")
  _nota((X(230), Y(98)), [a la izquierda de $dot(psi)_"mín"$ no hay\ precesión estable], ancla: "north-west")
})

// ---------------------------------------------------------------------
// B extra -- el CMG visto desde el eje del cardan (z, hacia el lector). h
// arranca sobre x y el cardan lo gira delta = 30; el satelite se lleva lo
// opuesto a lo que cambio h: -Delta h, con una parte sobre -y (la maniobra)
// y una fuga sobre +x.
// ---------------------------------------------------------------------
#let fig-b-cmg = esquema(escala: 1.0cm, {
  let h = 3.2
  let de = 30
  let h1 = _p2(h, de)
  cetz.draw.line((-0.5, 0), (4.0, 0), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((4.05, 0), [$x$], ancla: "west")
  cetz.draw.line((0, -2.2), (0, 2.4), stroke: 0.5pt + luma(120), mark: (end: "stealth", scale: 0.4, fill: luma(120)))
  rotulo((0, 2.45), [$y$ (eje de la maniobra)], ancla: "south")
  rotulo((-0.12, -0.12), [eje del cardán ⊙], ancla: "north-east")
  flecha((0, 0), (h, 0), color: c-aux, grosor: 1.1pt)
  rotulo((2.1, -0.08), text(fill: c-aux)[$bold(h)$ antes], ancla: "north")
  flecha((0, 0), h1, color: c-verde, grosor: 1.2pt)
  rotulo(h1, text(fill: c-verde)[$bold(h)$ después], ancla: "south-west")
  flecha((h, 0), h1, color: c-rojo, grosor: 1.0pt)
  rotulo((3.35, 0.75), text(fill: c-rojo)[$Delta bold(h)$], ancla: "west")
  angulo((0, 0), 0, de, radio: 1.2)
  rotulo(_p2(1.4, de / 2), [$delta$], ancla: "west")
  let dh = (h1.at(0) - h, h1.at(1))
  flecha((0, 0), (-dh.at(0), -dh.at(1)), color: c-dato, grosor: 1.2pt)
  rotulo((-dh.at(0) + 0.05, -dh.at(1)), text(fill: c-dato)[$-Delta bold(h)$: al satélite], ancla: "north-west")
  _nota((1.6, -2.0), [la parte sobre $-y$ es la maniobra; la de $+x$, la fuga], ancla: "north")
})
