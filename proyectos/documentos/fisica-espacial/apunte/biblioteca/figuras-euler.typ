// =====================================================================
//  figuras-euler.typ -- los dibujos que un profesor haría en el pizarrón
//  desde los ángulos de Euler en adelante (2026-11-10, pedido de Fran:
//  «todos los dibujos útiles que usaría un profe para explicar estos temas
//  mejor»). Las usan los módulos `euler-giroscopo` y `peonza`.
//  Rótulos con HALO y en capa de arriba, como figuras-cmg.typ; los mide
//  practica/verificar-figuras.py sobre practica/galeria-euler.typ.
//
//  OJO (trampa 10 del HANDOFF): ninguna variable local se llama como una
//  letra griega (Typst resolvería $theta$ contra el número): th, ph, ps, ga.
//
//  La convención de ejes es la del Beer §18.9 y la del módulo:
//    N (línea de nodos, = f) = (cos ph, sin ph, 0)
//    k (eje de simetría)     = Z cos th + (N x Z) sin th  -- Z girado th sobre N
//    e = f x k, en el plano de Z y z, del lado opuesto a Z
// =====================================================================
#import "estilo.typ": *
#import "estilo.typ" as est
#import "perspectiva.typ": *

#let rotulo(pos, cuerpo, ..args) = cetz.draw.on-layer(2,
  est.rotulo(pos, box(fill: white, inset: (x: 1.2pt, y: 0.8pt), cuerpo), ..args))
#let rotulo3(v, p, cuerpo, ..args) = rotulo(p3(v, p), cuerpo, ..args)
#let flecha3r(v, a, b, nombre, color: c-dato, ancla: "west", ..args) = {
  flecha3(v, a, b, color: color, ..args)
  rotulo3(v, b, text(fill: color, nombre), ancla: ancla)
}
#let _dir(ang) = (calc.cos(ang * 1deg), calc.sin(ang * 1deg), 0)
#let _nodos(ph) = _dir(ph)
#let _eje(th, ph) = {
  let s = calc.sin(th * 1deg)
  (s * calc.sin(ph * 1deg), -s * calc.cos(ph * 1deg), calc.cos(th * 1deg))
}
#let _Z = (0, 0, 1)
#let _O = (0, 0, 0)

// Un anillo (un cardán): se dibuja en dos pasadas, la mitad de atrás antes
// del rotor y la de adelante después, así el rotor queda «adentro».
#let anillo3(v, c, n, R, color: c-verde, grosor: 2.2pt, parte: "atras") = {
  let pts = circulo3-pts(c, n, R, k: 120)
  let pc = prof3(v, c)
  let tramo = ()
  for p in pts {
    let adelante = prof3(v, p) >= pc
    if (parte == "adelante") == adelante {
      tramo.push(p3(v, p))
    } else {
      if tramo.len() > 1 { cetz.draw.line(..tramo, stroke: grosor + color) }
      tramo = ()
    }
  }
  if tramo.len() > 1 { cetz.draw.line(..tramo, stroke: grosor + color) }
}

// ---------------------------------------------------------------------
// 1. Los tres ángulos de Euler (Beer §18.9, fig. 18.15).
// ---------------------------------------------------------------------
#let fig-euler-angulos = esquema(escala: 1.0cm, {
  let v = vista3d(az: 28, el: 22)
  let th = 40
  let ph = 55
  let ps = 70
  let N = _nodos(ph)
  let k = _eje(th, ph)
  let xb = suma3(esc3(calc.cos(ps * 1deg), N), esc3(calc.sin(ps * 1deg), cruz3(k, N)))
  // el plano XY fijo
  linea3(v, circulo3-pts(_O, _Z, 2.3), color: c-guia, grosor: 0.5pt, punteada: true)
  // ejes fijos
  flecha3(v, _O, (2.9, 0, 0), color: luma(110), grosor: 0.6pt)
  rotulo3(v, (2.9, 0, 0), [$X$], ancla: "north")
  flecha3(v, _O, (0, 2.9, 0), color: luma(110), grosor: 0.6pt)
  rotulo3(v, (0, 2.9, 0), [$Y$], ancla: "west")
  flecha3(v, _O, (0, 0, 3.0), color: luma(110), grosor: 0.6pt)
  rotulo3(v, (0, 0, 3.0), [$Z$ (fijo)], ancla: "south")
  // el plano perpendicular a z por O
  linea3(v, circulo3-pts(_O, k, 1.45), color: c-aux.lighten(30%), grosor: 0.5pt, punteada: true)
  // la línea de nodos
  linea3(v, (esc3(-2.6, N), esc3(2.6, N)), color: c-verde, grosor: 1.0pt)
  rotulo3(v, esc3(2.6, N), text(fill: c-verde)[línea de nodos ($hat(f)$)], ancla: "west")
  // phi: de X a la línea de nodos, en el plano XY
  linea3(v, arco3-pts(_O, _Z, (1, 0, 0), 1.25, ph), color: c-verde, grosor: 0.9pt)
  rotulo3(v, esc3(1.5, _dir(ph / 2)), text(fill: c-verde)[$phi$], ancla: "north")
  // theta: de Z a z, girando sobre la línea de nodos
  linea3(v, arco3-pts(_O, N, _Z, 1.9, th), color: c-rojo, grosor: 0.9pt)
  rotulo3(v, esc3(2.15, unit3(suma3(_Z, k))), text(fill: c-rojo)[$theta$], ancla: "south-east")
  // el eje de simetría z
  flecha3(v, _O, esc3(3.0, k), color: c-dato, grosor: 1.1pt)
  rotulo3(v, esc3(3.0, k), text(fill: c-dato)[$z$ (eje del cuerpo, $hat(k)$)], ancla: "east")
  // psi: de la línea de nodos al eje x del cuerpo, en el plano perpendicular a z
  linea3(v, arco3-pts(_O, k, N, 1.0, ps), color: c-aux, grosor: 0.9pt)
  rotulo3(v, esc3(1.2, unit3(suma3(N, xb))), text(fill: c-aux)[$psi$], ancla: "north-west")
  flecha3(v, _O, esc3(1.45, xb), color: c-aux, grosor: 0.9pt)
  rotulo3(v, esc3(1.45, xb), text(fill: c-aux)[$x$ (pegado al cuerpo)], ancla: "south-west")
  masa3(v, _O, radio: 0.05)
  rotulo3(v, _O, [$O$], ancla: "north-east")
})

// ---------------------------------------------------------------------
// 2. El giróscopo en cardanes: un ángulo por articulación (ANI-62).
// `th`, `ph`: la orientación; `nombres`: si van los rótulos largos.
// ---------------------------------------------------------------------
#let _cardanes(th: 50, ph: -25, ps: 60, nombres: true, giros: true) = {
  let v = vista3d(az: 30, el: 18)
  let N = _nodos(ph)
  let k = _eje(th, ph)
  let R1 = 2.0
  let R2 = 1.5
  let n1 = cruz3(_Z, N)
  let n2 = if th == 0 { cruz3(N, _Z) } else { cruz3(N, k) }
  let zb = -R1 - 0.55
  // la base y el eje fijo
  caja3(v, (-1.1, -1.1, zb - 0.3), (2.2, 0, 0), (0, 2.2, 0), (0, 0, 0.3),
    tonos: (luma(225), luma(205), luma(238)))
  linea3(v, ((0, 0, zb), (0, 0, -R1)), grosor: 2.0pt)
  linea3(v, ((0, 0, R1), (0, 0, R1 + 0.3)), grosor: 2.0pt)
  linea3(v, ((0, 0, R1 + 0.3), (0, 0, R1 + 1.1)), color: c-guia, grosor: 0.5pt, punteada: true)
  // phi sobre la base: de X fijo a la línea de nodos
  linea3(v, ((0, 0, zb), (1.35, 0, zb)), color: c-guia, grosor: 0.5pt, punteada: true)
  linea3(v, (suma3((0, 0, zb), esc3(0, N)), suma3((0, 0, zb), esc3(1.35, N))), color: c-verde, grosor: 0.6pt, punteada: true)
  linea3(v, arco3-pts((0, 0, zb), _Z, (1, 0, 0), 0.95, ph), color: c-verde, grosor: 0.9pt)
  rotulo3(v, suma3((0, 0, zb), esc3(1.15, _dir(ph / 2))), text(fill: c-verde)[$phi$], ancla: "north")
  // mitades de atrás
  anillo3(v, _O, n1, R1, color: c-verde, parte: "atras")
  anillo3(v, _O, n2, R2, color: c-aux, parte: "atras")
  // pivotes del balancín interior, sobre la línea de nodos
  linea3(v, (esc3(R2, N), esc3(R1, N)), grosor: 2.0pt)
  linea3(v, (esc3(-R2, N), esc3(-R1, N)), grosor: 2.0pt)
  // el eje del rotor y el rotor
  linea3(v, (esc3(-R2, k), esc3(R2, k)), grosor: 1.2pt)
  cilindro3(v, _O, k, 0.95, 0.26, relleno: c-dato.lighten(70%), tapa: c-dato.lighten(84%))
  // una marca en la tapa de adelante: el eje x pegado al rotor
  let cara = if prof3(v, k) > 0 { esc3(0.13, k) } else { esc3(-0.13, k) }
  let xb = suma3(esc3(calc.cos(ps * 1deg), N), esc3(calc.sin(ps * 1deg), cruz3(k, N)))
  linea3(v, (cara, suma3(cara, esc3(0.9, xb))), color: c-dato, grosor: 1.3pt)
  // mitades de adelante
  anillo3(v, _O, n2, R2, color: c-aux, parte: "adelante")
  anillo3(v, _O, n1, R1, color: c-verde, parte: "adelante")
  masa3(v, esc3(R1, N), radio: 0.06)
  masa3(v, esc3(-R1, N), radio: 0.06)
  if th > 0 {
    // theta: de Z al eje del rotor, sobre la línea de nodos
    linea3(v, (esc3(R2, k), esc3(R1 + 0.7, k)), color: c-guia, grosor: 0.5pt, punteada: true)
    linea3(v, arco3-pts(_O, N, _Z, R1 + 0.45, th), color: c-rojo, grosor: 0.9pt)
    rotulo3(v, esc3(R1 + 0.6, unit3(suma3(_Z, k))), text(fill: c-rojo)[$theta$], ancla: "south")
  }
  if giros {
    giro3(v, (0, 0, R1 + 0.75), _Z, (1, 0, 0), 0.32, 290, color: c-verde)
    rotulo3(v, (0, 0.4, R1 + 0.75), text(fill: c-verde)[$dot(phi)$], ancla: "west")
    giro3(v, esc3(R1 + 0.35, N), N, _Z, 0.3, 290, color: c-aux)
    rotulo3(v, suma3(esc3(R1 + 0.35, N), (0, 0, -0.35)), text(fill: c-aux)[$dot(theta)$], ancla: "north")
    if th > 0 {
      giro3(v, esc3(-R2 - 0.4, k), k, N, 0.3, 290, color: c-dato)
      rotulo3(v, esc3(-R2 - 0.75, k), text(fill: c-dato)[$dot(psi)$], ancla: "north-east")
    }
  }
}
#let _leyenda-cardanes = align(center, block(width: 13cm, above: 4pt, {
  set text(size: 7.5pt)
  set par(justify: false)
  [#text(fill: c-verde)[*verde*: balancín exterior, gira $phi$ alrededor de $Z$ fijo] \
   #text(fill: c-aux)[*azul*: balancín interior, gira $theta$ alrededor de la línea de nodos] \
   #text(fill: c-dato)[*rojo*: rotor, gira $psi$ alrededor de su eje $z$]]
}))
#let fig-euler-cardanes = block({ esquema(escala: 0.78cm, _cardanes()); _leyenda-cardanes })

// ---------------------------------------------------------------------
// 3. Los ejes del Beer en el plano de Z y z: por qué la precesión aporta
// un menos sobre e. K = -sin th e + cos th k. f entra en la hoja.
// ---------------------------------------------------------------------
#let fig-euler-efk = esquema(escala: 1.0cm, {
  let th = 35
  let O = (0, 0)
  let L = 2.6
  let s = calc.sin(th * 1deg)
  let c = calc.cos(th * 1deg)
  let K = (0, L)
  let k = (L * s, L * c)
  let e = (L * 0.75 * c, -L * 0.75 * s)
  // eje Z y eje z
  flecha(O, (0, L + 0.5), color: luma(110), grosor: 0.6pt)
  rotulo((0, L + 0.5), [$Z$], ancla: "south")
  flecha(O, ((L + 0.5) * s, (L + 0.5) * c), color: c-dato, grosor: 0.6pt)
  rotulo(((L + 0.5) * s, (L + 0.5) * c), text(fill: c-dato)[$z$], ancla: "south-west")
  // phidot K, sobre Z
  flecha(O, K, color: c-verde, grosor: 1.3pt)
  rotulo((0, L * 0.8), text(fill: c-verde)[$dot(phi) bold(K)$], ancla: "east")
  // sus dos proyecciones: sobre k (positiva) y sobre e (negativa)
  let pk = (L * c * s, L * c * c)
  let pe = (-L * s * c, L * s * s)
  auxiliar(K, pk)
  auxiliar(K, pe)
  flecha(O, pk, color: c-verde.lighten(25%), grosor: 0.9pt)
  rotulo(pk, text(fill: c-verde)[$dot(phi) cos theta thin hat(k)$], ancla: "west")
  flecha(O, pe, color: c-verde.lighten(25%), grosor: 0.9pt)
  rotulo(pe, text(fill: c-verde)[$-dot(phi) sin theta thin hat(e)$], ancla: "east")
  // los versores
  flecha(O, (0.95 * s, 0.95 * c), color: c-dato, grosor: 1.1pt)
  rotulo((0.95 * s, 0.95 * c), text(fill: c-dato)[$hat(k)$], ancla: "north-west")
  flecha(O, (0.95 * c, -0.95 * s), color: c-aux, grosor: 1.1pt)
  rotulo((0.95 * c, -0.95 * s), text(fill: c-aux)[$hat(e)$], ancla: "west")
  // la recta de e, punteada, para ver que e pasa del otro lado
  cetz.draw.line(((-L * 0.85) * c, L * 0.85 * s), (L * 0.85 * c, -L * 0.85 * s), stroke: (paint: c-aux.lighten(40%), thickness: 0.5pt, dash: "dotted"))
  // f entra en la hoja
  cetz.draw.circle(O, radius: 0.16, stroke: 0.8pt + c-rojo, fill: white)
  cetz.draw.line((-0.11, -0.11), (0.11, 0.11), stroke: 0.8pt + c-rojo)
  cetz.draw.line((-0.11, 0.11), (0.11, -0.11), stroke: 0.8pt + c-rojo)
  rotulo((-0.15, -0.2), text(fill: c-rojo)[$hat(f)$ entra en la hoja (línea de nodos)], ancla: "north-east")
  // theta, dos veces: entre Z y z, y entre e y la horizontal
  angulo(O, 90 - th, 90, etiqueta: [$theta$], radio: 1.55, color: c-rojo)
  angulo(O, -th, 0, etiqueta: [$theta$], radio: 1.55, color: c-rojo)
  cetz.draw.line(O, (1.9, 0), stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
  recto(O, 90 - th, -th, lado: 0.3)
})

// ---------------------------------------------------------------------
// 4. El agujero de los ángulos de Euler: theta = 0 (bloqueo de cardán).
// ---------------------------------------------------------------------
#let fig-euler-bloqueo = paneles(
  ([$theta = 50 degree$: tres giros distintos], esquema(escala: 0.62cm, _cardanes(nombres: false))),
  ([$theta = 0$: $phi$ y $psi$ son el mismo giro], esquema(escala: 0.62cm, _cardanes(th: 0, nombres: false))),
)

// ---------------------------------------------------------------------
// 5. Precesión estable con el peso: el cono, la cupla sobre la línea de
// nodos y el H que la cupla arrastra.
// ---------------------------------------------------------------------
#let fig-precesion-estable = esquema(escala: 1.0cm, {
  let v = vista3d(az: 20, el: 25)
  let th = 45
  // la línea de nodos se elige para que el eje se incline hacia la derecha
  // de la hoja y la cupla salga oblicua (hacia atrás y a la izquierda)
  let ph = 20 + 180 + 35
  let N = _nodos(ph)
  let k = _eje(th, ph)
  let Lz = 3.2
  let cG = 1.6
  let G = esc3(cG, k)
  // el cono que barre el eje: la circunferencia de la punta
  let tope = esc3(Lz, k)
  let alto = Lz * calc.cos(th * 1deg)
  linea3(v, circulo3-pts((0, 0, alto), _Z, Lz * calc.sin(th * 1deg)), color: c-guia, grosor: 0.6pt, punteada: true)
  linea3(v, (_O, esc3(Lz, _eje(th, ph + 180))), color: c-guia, grosor: 0.4pt, punteada: true)
  // un pedacito de piso
  linea3(v, circulo3-pts(_O, _Z, 0.9), color: luma(170), grosor: 0.5pt)
  // Z
  flecha3(v, _O, (0, 0, 3.9), color: luma(110), grosor: 0.6pt)
  rotulo3(v, (0, 0, 3.9), [$Z$], ancla: "south")
  // theta
  linea3(v, arco3-pts(_O, N, _Z, 0.8, th), color: c-rojo, grosor: 0.9pt)
  rotulo3(v, (0, 0, 0.8), text(fill: c-rojo)[$theta$], ancla: "south-west")
  // el eje y el rotor
  linea3(v, (_O, tope), grosor: 1.3pt)
  cilindro3(v, G, k, 0.55, 0.24, relleno: c-dato.lighten(70%), tapa: c-dato.lighten(84%))
  rotulo3(v, tope, [$z$], ancla: "west")
  masa3(v, _O, radio: 0.07)
  rotulo3(v, _O, [$O$], ancla: "north-west")
  // el peso en G
  flecha3(v, G, suma3(G, (0, 0, -1.4)), color: c-trazo, grosor: 1.0pt)
  rotulo3(v, suma3(G, (0, 0, -1.4)), [$bold(W)$], ancla: "north")
  rotulo3(v, esc3(cG * 0.5, k), [$c$], ancla: "north-west")
  // la cupla del peso respecto de O: sobre +f, la línea de nodos
  flecha3r(v, _O, esc3(1.9, N), [$sum bold(M)_O = W c sin theta thin hat(f)$], color: c-rojo, ancla: "east")
  // H_O, casi sobre el eje (entre z y Z), y el cambio que le impone la cupla: también sobre f
  let H = suma3(esc3(2.9, k), esc3(-0.2, cruz3(N, k)))
  flecha3(v, _O, H, color: c-aux, grosor: 1.0pt)
  rotulo3(v, esc3(0.72, H), text(fill: c-aux)[$bold(H)_O$], ancla: "south-east")
  flecha3(v, H, suma3(H, esc3(0.75, N)), color: c-rojo, grosor: 0.8pt)
  rotulo3(v, suma3(H, esc3(0.75, N)), text(fill: c-rojo)[$dif bold(H)_O$], ancla: "south")
  // los dos giros
  giro3(v, (0, 0, 3.3), _Z, (1, 0, 0), 0.38, 290, color: c-verde)
  rotulo3(v, (0, 0.45, 3.3), text(fill: c-verde)[$dot(phi)$], ancla: "west")
  giro3(v, esc3(Lz - 0.25, k), k, N, 0.22, 290, color: c-dato)
  rotulo3(v, suma3(esc3(Lz - 0.25, k), (0, 0, -0.3)), text(fill: c-dato)[$dot(psi)$], ancla: "north-west")
})

// ---------------------------------------------------------------------
// 6. Las dos raíces de la cuadrática (giróscopo de mesa a 60°): la lenta,
// la rápida y el spin mínimo donde se juntan. Números del ejemplo de m20.
// ---------------------------------------------------------------------
#let fig-dos-raices = esquema(escala: 1.0cm, {
  let Ia = 0.0027
  let Io = 0.01635
  let Wc = 1.4715
  let a = (Io - Ia) * 0.5
  let psmin = 2 * calc.sqrt(a * Wc) / Ia
  let x0 = 0
  let xmax = 420
  let ymax = 170
  let W = 8.0
  let Hh = 4.6
  let X(x) = x / xmax * W
  let Y(y) = y / ymax * Hh
  // ejes
  cetz.draw.line((0, 0), (W + 0.2, 0), stroke: 0.7pt, mark: (end: "stealth", scale: 0.45, fill: black))
  cetz.draw.line((0, 0), (0, Hh + 0.2), stroke: 0.7pt, mark: (end: "stealth", scale: 0.45, fill: black))
  rotulo((W + 0.25, 0), [spin $dot(psi)$ (rad/s)], ancla: "west")
  rotulo((0, Hh + 0.2), [precesión $dot(phi)$ (rad/s)], ancla: "south-west")
  for xx in (100, 200, 300, 400) { marca-x(X(xx), [#xx]) }
  for yy in (50, 100, 150) { marca-y(Y(yy), [#yy]) }
  // las dos ramas
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
  // la aproximada de la lenta: Wc / (I psidot)
  let pts-a = range(0, n + 1).map(i => {
    let ps = 25 + (xmax - 35) * i / n
    (X(ps), Y(calc.min(ymax, Wc / (Ia * ps))))
  }).filter(p => p.at(1) < Y(ymax) - 0.01)
  cetz.draw.line(..pts-a, stroke: punteado-dato)
  // el spin mínimo
  cetz.draw.line((X(psmin), 0), (X(psmin), Y(Ia * psmin / (2 * a))), stroke: punteado)
  masa((X(psmin), Y(Ia * psmin / (2 * a))), radio: 0.07)
  flecha-nota((X(200), Y(40)), (X(psmin) + 0.08, Y(Ia * psmin / (2 * a)) + 0.02), [$dot(psi)_"mín" approx 74$ rad/s: las dos se juntan], ancla: "west")
  // el punto del ejemplo, a 300 rad/s
  masa((X(300), Y(116.8)), radio: 0.07, color: c-aux)
  rotulo((X(300), Y(116.8)), text(fill: c-aux)[la rápida: 117 rad/s], ancla: "north-west")
  masa((X(300), Y(1.845)), radio: 0.07, color: c-dato)
  rotulo((X(300), Y(1.845) + 0.05), text(fill: c-dato)[la lenta: 1,8 rad/s (la que se ve)], ancla: "south")
  flecha-nota((X(4), Y(105)), (X(32), Y(Wc / (Ia * 32)) + 0.05), text(fill: c-dato)[aproximada de la lenta,\ $W c \/ (I dot(psi))$], ancla: "south-west")
  rotulo((X(4), Y(168)), text(fill: luma(80), size: 7.5pt)[a la izquierda de $dot(psi)_"mín"$ no hay\ precesión estable: se cae], ancla: "north-west")
})

// ---------------------------------------------------------------------
// 7. El ladrillo y sus tres ejes principales: dos estables, uno no.
// ---------------------------------------------------------------------
#let fig-ladrillo-ejes = esquema(escala: 1.0cm, {
  let v = vista3d(az: 32, el: 22)
  let a = 2.0
  let b = 1.0
  let c = 0.5
  // ejes por detrás
  linea3(v, ((-a - 0.2, 0, 0), (0, 0, 0)), color: c-verde, grosor: 0.6pt, punteada: true)
  linea3(v, ((0, -b - 0.2, 0), (0, 0, 0)), color: c-rojo, grosor: 0.6pt, punteada: true)
  linea3(v, ((0, 0, -c - 0.25), (0, 0, 0)), color: c-verde, grosor: 0.6pt, punteada: true)
  caja3(v, (-a, -b, -c), (2 * a, 0, 0), (0, 2 * b, 0), (0, 0, 2 * c),
    tonos: (rgb("#E8D3C4"), rgb("#D9B9A3"), rgb("#F1E3D8")))
  // los tres ejes por G, con su giro
  flecha3(v, (a, 0, 0), (a + 1.3, 0, 0), color: c-verde, grosor: 1.1pt)
  giro3(v, (a + 0.85, 0, 0), (1, 0, 0), (0, 0, 1), 0.3, 290, color: c-verde)
  rotulo3(v, (a + 1.3, 0, 0), text(fill: c-verde)[$I$ mínimo: estable], ancla: "north")
  flecha3(v, (0, b, 0), (0, b + 1.4, 0), color: c-rojo, grosor: 1.1pt)
  giro3(v, (0, b + 0.9, 0), (0, 1, 0), (0, 0, 1), 0.3, 290, color: c-rojo)
  rotulo3(v, (0, b + 1.4, 0), text(fill: c-rojo)[$I$ intermedio: se da vuelta], ancla: "west")
  flecha3(v, (0, 0, c), (0, 0, c + 1.4), color: c-verde, grosor: 1.1pt)
  giro3(v, (0, 0, c + 0.9), (0, 0, 1), (1, 0, 0), 0.3, 290, color: c-verde)
  rotulo3(v, (0, 0, c + 1.4), text(fill: c-verde)[$I$ máximo: estable], ancla: "south")
})

// ---------------------------------------------------------------------
// 8. El Explorer 1: el mismo H, otra energía.
// ---------------------------------------------------------------------
#let _explorer(tumbo: false) = {
  let v = vista3d(az: 25, el: 14)
  let eje = if tumbo { (0, 1, 0) } else { (0, 0, 1) }
  let largo = 2.6
  // el cuerpo: un cilindro largo
  cilindro3(v, _O, eje, 0.28, largo, relleno: luma(205), tapa: luma(232))
  // las cuatro antenas de alambre, del medio del cuerpo, un poco dobladas
  let lado = if tumbo { ((1, 0, 0), (-1, 0, 0), (0, 0, 1), (0, 0, -1)) } else { ((1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0)) }
  for d in lado {
    let p0 = esc3(0.28, d)
    let p1 = suma3(esc3(1.0, d), esc3(0.12, eje))
    let p2 = suma3(esc3(1.6, d), esc3(-0.12, eje))
    linea3(v, (p0, p1, p2), color: luma(60), grosor: 0.6pt)
  }
  // H, igual en los dos paneles: vertical
  flecha3(v, (0, 0, 1.55), (0, 0, 2.6), color: c-aux, grosor: 1.2pt)
  rotulo3(v, (0, 0, 2.6), text(fill: c-aux)[$bold(H)_G$ (el mismo)], ancla: "south")
  // el giro: sobre el eje largo, o de punta a punta alrededor de H
  giro3(v, (0, 0, 1.75), _Z, (1, 0, 0), 0.45, 290, color: c-dato)
  if tumbo {
    rotulo3(v, (0, 0, -2.0), text(size: 7.5pt)[da tumbos de punta a punta:\ $I$ máximo, $T = H^2 \/ (2 I_"máx")$ mínima], ancla: "north")
  } else {
    rotulo3(v, (0, 0, -2.0), text(size: 7.5pt)[gira sobre su eje largo:\ $I$ mínimo, $T = H^2 \/ (2 I_"mín")$ máxima], ancla: "north")
  }
}
#let fig-explorer = paneles(
  ("al salir (1958)", esquema(escala: 0.85cm, _explorer())),
  ("horas después: tumbos", esquema(escala: 0.85cm, _explorer(tumbo: true))),
)

// ---------------------------------------------------------------------
// 9. Peonza libre: H_G y omega descompuestos contra el eje z. De ahí
// sale tan gamma = (I/I') tan theta. Cuerpo alargado (I/I' = 1/2).
// ---------------------------------------------------------------------
#let fig-peonza-componentes = esquema(escala: 1.0cm, {
  let th = 40
  let rel = 0.5
  let H = 3.0
  let O = (0, 0)
  // la base: z vertical en la hoja, la transversal horizontal
  cetz.draw.line(O, (0, 4.0), stroke: (paint: c-trazo, thickness: 0.7pt))
  rotulo((0, 4.0), [eje $z$ del cuerpo], ancla: "south")
  cetz.draw.line(O, (2.6, 0), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  rotulo((2.6, 0), text(fill: luma(80))[transversal], ancla: "west")
  // H_G
  let Hz = H * calc.cos(th * 1deg)
  let Ht = H * calc.sin(th * 1deg)
  flecha(O, (Ht, Hz), color: c-aux, grosor: 1.2pt)
  rotulo((Ht, Hz), text(fill: c-aux)[$bold(H)_G$ (fijo)], ancla: "south-west")
  auxiliar((Ht, Hz), (0, Hz))
  auxiliar((Ht, Hz), (Ht, 0))
  rotulo((0, Hz), text(fill: c-aux)[$H cos theta = I omega_z$], ancla: "east")
  rotulo((Ht, 0), text(fill: c-aux)[$H sin theta$], ancla: "north")
  // omega: misma idea, con I e I' distintos (escala de dibujo 0,5)
  let wz = 0.5 * Hz / rel
  let wt = 0.5 * Ht / 1.0
  flecha(O, (wt, wz), color: c-dato, grosor: 1.2pt)
  rotulo((wt, wz), text(fill: c-dato)[$bold(omega)$], ancla: "south-east")
  auxiliar((wt, wz), (wt, 0))
  rotulo((wt, -0.35), text(fill: c-dato)[$I' omega_"t" = H sin theta$], ancla: "north")
  // los ángulos contra z
  let a-H = 90 - th
  let a-w = calc.atan2(wt, wz) / 1deg
  angulo(O, a-H, 90, radio: 1.6, color: c-aux)
  rotulo((1.6 * calc.cos(a-H * 1deg), 1.6 * calc.sin(a-H * 1deg)), text(fill: c-aux)[$theta$], ancla: "north-west")
  angulo(O, a-w, 90, radio: 0.75, color: c-dato)
  rotulo((0.05, 0.95), text(fill: c-dato)[$gamma$], ancla: "south-west")
})

// ---------------------------------------------------------------------
// 10. La ley de los senos: phidot K + psidot k = omega, punta con cola.
// Directa: PR 18.6 (theta 38,5, gamma 17,7). Retrógrada: 18.127
// (theta 36,6, gamma 43,2): psidot sale para atrás.
// ---------------------------------------------------------------------
// Un arco de vértice V entre las direcciones a1 y a2 (grados), sin rótulo.
// Va siempre por el lado de menos de 180 grados: el ángulo interior.
#let _arco(V, a1, a2, r, color) = {
  let d = calc.rem(a2 - a1 + 540, 360) - 180
  cetz.draw.arc(V, start: calc.min(a1, a1 + d) * 1deg, stop: calc.max(a1, a1 + d) * 1deg,
    radius: r, anchor: "origin", stroke: 1.0pt + color)
}
#let _pol(a, b) = calc.atan2(b.at(0) - a.at(0), b.at(1) - a.at(1)) / 1deg
#let _triangulo(th, ph, ps, retro: false) = {
  let O = (0, 0)
  let k = (calc.sin(th * 1deg), calc.cos(th * 1deg))
  let P = (0, ph)
  let Q = (ps * k.at(0), ph + ps * k.at(1))
  // el eje z por O y el eje de precesión, punteados
  let Lz = 4.4
  cetz.draw.line(O, (Lz * k.at(0), Lz * k.at(1)), stroke: punteado)
  rotulo((Lz * k.at(0), Lz * k.at(1)), text(fill: luma(80))[eje $z$], ancla: "south")
  cetz.draw.line(O, (0, 4.6), stroke: punteado)
  rotulo((0, 4.6), text(fill: luma(80))[$bold(H)_G$: eje de precesión], ancla: "south")
  angulo(O, 90 - th, 90, radio: 0.55, color: luma(70))
  rotulo((0.55 * calc.cos((90 - th / 2) * 1deg), 0.55 * calc.sin((90 - th / 2) * 1deg)), text(fill: luma(60))[$theta$], ancla: "south-west")
  // los ángulos del triángulo, cada uno del color del lado que tiene enfrente
  _arco(O, 90, _pol(O, Q), 1.05, c-dato)
  _arco(Q, _pol(Q, O), _pol(Q, P), 0.8, c-verde)
  _arco(P, _pol(P, O), _pol(P, Q), 0.32, c-aux)
  // los tres lados
  flecha(O, P, color: c-verde, grosor: 1.3pt)
  rotulo((0, ph * 0.45), text(fill: c-verde)[$dot(phi) bold(K)$], ancla: if retro { "west" } else { "east" })
  flecha(P, Q, color: c-dato, grosor: 1.3pt)
  rotulo(Q, text(fill: c-dato)[$dot(psi) hat(k)$], ancla: if retro { "east" } else { "south-west" })
  flecha(O, Q, color: c-aux, grosor: 1.3pt)
  rotulo((Q.at(0) * 0.62, Q.at(1) * 0.62), text(fill: c-aux)[$bold(omega)$], ancla: if retro { "east" } else { "west" })
}
#let _leyenda-senos = align(center, block(width: 13cm, above: 4pt, {
  set text(size: 7.5pt)
  set par(justify: false)
  [Cada ángulo va del color del lado que tiene enfrente: frente a $dot(phi)$ (verde), $gamma$; frente a
   $dot(psi)$ (rojo), $theta - gamma$; frente a $omega$ (azul), $180 degree - theta$. Si el cuerpo es achatado,
   $theta - gamma < 0$ y $dot(psi)$ sale para atrás; los otros dos ángulos pasan a sus suplementos, que
   tienen el mismo seno.]
}))
#let fig-ley-senos = block({
  paneles(
    ("alargado: directa (PR 18.6)", esquema(escala: 0.8cm, _triangulo(38.5, 30.7 * 0.055, 36.0 * 0.055))),
    ("achatado: retrógrada (esquema)", esquema(escala: 0.8cm, _triangulo(36.6, 3.4, -1.3, retro: true))),
  )
  _leyenda-senos
})

// ---------------------------------------------------------------------
// 11. El PR 18.6: dos discos, el meteorito en C y el H_G que queda.
// ---------------------------------------------------------------------
#let fig-meteorito = esquema(escala: 1.0cm, {
  let v = vista3d(az: 35, el: 18)
  let a = 1.0
  // ejes del satélite
  linea3(v, ((0, 0, -2.0), (0, 0, 2.0)), color: c-guia, grosor: 0.5pt, punteada: true)
  linea3(v, ((0, 0, 0), (1.9, 0, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (1.9, 0, 0), text(fill: luma(80))[$x$], ancla: "north")
  linea3(v, ((0, 0, 0), (0, 1.9, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (0, 1.9, 0), text(fill: luma(80))[$y$], ancla: "west")
  // los dos discos y la barra
  cilindro3(v, (0, 0, -a), _Z, a, 0.08, relleno: luma(215), tapa: luma(238))
  linea3(v, ((0, 0, -a), (0, 0, a)), grosor: 1.6pt)
  cilindro3(v, (0, 0, a), _Z, a, 0.08, relleno: luma(215), tapa: luma(238))
  masa3(v, _O, radio: 0.05)
  rotulo3(v, _O, [$G$], ancla: "east")
  // el meteorito llega paralelo a z y pega en C
  let C = (0, a, a)
  flecha3(v, (0, a, a - 1.6), (0, a, a - 0.08), color: c-ambar, grosor: 1.0pt)
  masa3(v, (0, a, a - 1.6), radio: 0.06, color: c-ambar)
  rotulo3(v, (0, a, a - 1.6), text(fill: c-ambar)[meteorito, $m_0 bold(v)_0$], ancla: "west")
  masa3(v, C, radio: 0.05)
  rotulo3(v, C, [$C$], ancla: "south-west")
  // H_G antes, lo que agrega el meteorito, y después
  let Hz = 2.9
  let Hx = Hz * 0.796
  flecha3(v, (0, 0, a + 0.05), (0, 0, Hz), color: c-aux.lighten(35%), grosor: 0.9pt, punteada: true)
  rotulo3(v, (0, 0, Hz * 0.78), text(fill: c-aux)[antes: $I omega_0 hat(k)$], ancla: "west")
  flecha3(v, (0, 0, Hz), (Hx, 0, Hz), color: c-ambar, grosor: 0.9pt)
  rotulo3(v, (Hx * 0.5, 0, Hz), text(fill: c-ambar)[$+ m_0 v_0 a thin hat(i)$], ancla: "south")
  flecha3(v, esc3(a / Hz * 1.02, (Hx, 0, Hz)), (Hx, 0, Hz), color: c-aux)
  rotulo3(v, (Hx * 0.7, 0, Hz * 0.7), text(fill: c-aux)[después: $bold(H)_G$, fijo], ancla: "east")
  linea3(v, arco3-pts(_O, (0, 1, 0), _Z, 2.2, 38.5), color: c-rojo, grosor: 0.8pt)
  rotulo3(v, esc3(2.3, unit3((0.33, 0, 1))), text(fill: c-rojo)[$theta$], ancla: "south-west")
  // el giro inicial, abajo
  giro3(v, (0, 0, -a - 0.55), _Z, (1, 0, 0), 0.32, 290, color: c-dato)
  rotulo3(v, (0, -0.4, -a - 0.55), text(fill: c-dato)[$omega_0$], ancla: "east")
})

// ---------------------------------------------------------------------
// 12. El trompo con nutación: la punta del eje entre dos paralelos, con
// ondas, cúspides o rulos según cómo se larga.
// ---------------------------------------------------------------------
// Vista desde arriba (Z sale de la hoja): la punta del eje, proyectada,
// queda entre dos circunferencias, la de theta_1 (adentro, eje más
// parado) y la de theta_2 (afuera). En theta_1 la precesión vale
// phidot (1 - kk): kk < 1 ondas, kk = 1 cúspides, kk > 1 rulos.
#let _nutacion(kk, rotulos: false) = {
  let t1 = 28
  let t2 = 46
  let R = 2.0
  let r1 = R * calc.sin(t1 * 1deg)
  let r2 = R * calc.sin(t2 * 1deg)
  cetz.draw.circle((0, 0), radius: r1, stroke: punteado)
  cetz.draw.circle((0, 0), radius: r2, stroke: punteado)
  let n = 600
  let nn = 5
  let pts = range(0, n + 1).map(i => {
    let u = i / n * 360
    let tt = (t1 + t2) / 2 - (t2 - t1) / 2 * calc.cos(nn * u * 1deg)
    let pp = u - kk * calc.sin(nn * u * 1deg) * (180 / calc.pi) / nn
    let rr = R * calc.sin(tt * 1deg)
    (rr * calc.cos(pp * 1deg), rr * calc.sin(pp * 1deg))
  })
  cetz.draw.line(..pts, stroke: 0.9pt + c-dato)
  masa((0, 0), radio: 0.05)
  if rotulos {
    rotulo((0, 0), text(size: 7.5pt)[$Z$], ancla: "north-west")
    rotulo((r2 * 0.71, -r2 * 0.71), text(size: 7.5pt, fill: luma(80))[$theta_2$], ancla: "north-west")
    rotulo((r1 * 0.2, r1 * 0.2), text(size: 7.5pt, fill: luma(80))[$theta_1$], ancla: "south-west")
  }
}
#let fig-nutacion = paneles(
  ("se larga a favor", esquema(escala: 0.85cm, _nutacion(0.3, rotulos: true))),
  ("se larga quieto", esquema(escala: 0.85cm, _nutacion(1.0))),
  ("se larga en contra", esquema(escala: 0.85cm, _nutacion(2.6))),
)
