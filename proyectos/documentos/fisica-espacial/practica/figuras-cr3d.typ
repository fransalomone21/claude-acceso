// =====================================================================
//  figuras-cr3d.typ -- las figuras del cap. 18 del Beer para la guia y el
//  modelo del parcialito 5 (2026-10-29). Redibujan lo que subio Anibal:
//  el giroscopo en cardanes (Beer figs. 18.15-18.16, su hoja 2), la
//  precesion estable (Beer fig. 18.17, su hoja 4), la figura suelta
//  «Precesiones» (cuerpo alargado y achatado libres de cupla) y el H_O de
//  su hoja 1; mas el disco torcido y el satelite del meteorito del modelo.
//
//  OJO (trampa 10 del HANDOFF del apunte): ninguna variable local se llama
//  como una letra griega (phi, theta, psi, omega, gamma, beta...): Typst
//  resolveria $theta$ contra el numero. Aca van fi, te, ps, ga, be.
// =====================================================================
#import "../apunte/biblioteca/estilo.typ": *
#import "../apunte/biblioteca/estilo.typ" as est
#import "../apunte/biblioteca/perspectiva.typ": *

// Todo rótulo de este archivo lleva HALO (un fondo blanco ajustado) y va en
// una capa de arriba: una línea que pasa por detrás no lo tapa. Es la regla
// de los mapas, y es lo que mide verificar-figuras.py (sólo cuenta como cruce
// una línea dibujada por ENCIMA del rótulo). Pisa a los rotulo y rotulo3 de
// la biblioteca adentro de este archivo.
#let rotulo(pos, cuerpo, ..args) = cetz.draw.on-layer(2,
  est.rotulo(pos, box(fill: white, inset: (x: 1.2pt, y: 0.8pt), cuerpo), ..args))
#let rotulo3(v, p, cuerpo, ..args) = rotulo(p3(v, p), cuerpo, ..args)
// Una flecha con el nombre en la punta, con halo.
#let flecha3r(v, a, b, nombre, color: c-dato, ancla: "west", ..args) = {
  flecha3(v, a, b, color: color, ..args)
  rotulo3(v, b, text(fill: color, nombre), ancla: ancla)
}

#let _p2(r, ang) = (r * calc.cos(ang * 1deg), r * calc.sin(ang * 1deg))

// ---------------------------------------------------------------------
// El giroscopo en dos cardanes (Beer figs. 18.15 y 18.16; hoja 2 de Anibal).
// Mundo: Z vertical (eje AA' del balancin exterior). El exterior gira fi
// alrededor de Z; su eje BB' (la linea de nodos, y del Beer) queda en
// n = (-sin fi, cos fi, 0). El interior gira te alrededor de n y lleva el
// eje del rotor CC' en k = cos te Z + sin te u, u = (cos fi, sin fi, 0).
// Con i = cos te u - sin te Z sale K = -sin te i + cos te k (la del Beer).
// `rotulos: false` deja el dibujo pelado para el enunciado.
// ---------------------------------------------------------------------
#let fig-cardanes(rotulos: true, escala: 1.0cm) = esquema(escala: escala, {
  let v = vista3d(az: 28, el: 16)
  let fi = 35
  let te = 40
  let Z = (0, 0, 1)
  let u = (calc.cos(fi * 1deg), calc.sin(fi * 1deg), 0)
  let n = (-calc.sin(fi * 1deg), calc.cos(fi * 1deg), 0)
  let k = suma3(esc3(calc.cos(te * 1deg), Z), esc3(calc.sin(te * 1deg), u))
  let ii = suma3(esc3(calc.cos(te * 1deg), u), esc3(-calc.sin(te * 1deg), Z))
  let O = (0, 0, 0)
  let R1 = 2.2
  let R2 = 1.75
  // ejes fijos X, Y, Z
  if rotulos {
    linea3(v, (O, (2.9, 0, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
    rotulo3(v, (3.0, 0, 0), text(fill: luma(90))[$X$], ancla: "north")
    linea3(v, (O, (0, 3.0, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
    rotulo3(v, (0, 3.1, 0), text(fill: luma(90))[$Y$], ancla: "west")
  }
  // los soportes A (abajo) y A' (arriba) y el eje AA'
  linea3(v, ((0, 0, -R1 - 0.55), (0, 0, -R1)), grosor: 1.4pt)
  linea3(v, ((0, 0, R1), (0, 0, R1 + 0.55)), grosor: 1.4pt)
  caja3(v, (-0.35, -0.35, -R1 - 0.65), (0.7, 0, 0), (0, 0.7, 0), (0, 0, 0.1))
  caja3(v, (-0.35, -0.35, R1 + 0.55), (0.7, 0, 0), (0, 0.7, 0), (0, 0, 0.1))
  rotulo3(v, (0, 0.55, -R1 - 0.6), [$A$], ancla: "west")
  rotulo3(v, (0, 0.55, R1 + 0.6), [$A'$], ancla: "west")
  // balancin exterior: plano de Z y n (normal u)
  linea3(v, circulo3-pts(O, u, R1), color: c-verde, grosor: 2.2pt)
  // eje BB' (linea de nodos), del exterior al interior
  linea3(v, (esc3(-R1, n), esc3(-R2, n)), grosor: 1.6pt, color: c-rojo)
  linea3(v, (esc3(R2, n), esc3(R1, n)), grosor: 1.6pt, color: c-rojo)
  rotulo3(v, suma3(esc3(R1 + 0.2, n), (0, 0, 0.12)), [$B'$], ancla: "south")
  rotulo3(v, suma3(esc3(-R1 - 0.2, n), (0, 0, -0.12)), [$B$], ancla: "north")
  // balancin interior: plano de n y k (normal i)
  linea3(v, circulo3-pts(O, ii, R2), color: c-rojo.lighten(25%), grosor: 1.8pt)
  // eje del rotor CC'
  linea3(v, (esc3(-R2, k), esc3(R2, k)), grosor: 1.0pt, color: c-aux)
  rotulo3(v, esc3(R2 + 0.1, k), [$C'$], ancla: "south-west")
  rotulo3(v, esc3(-R2 - 0.05, k), [$C$], ancla: "south-east")
  // el rotor
  cilindro3(v, O, k, 0.95, 0.24)
  masa3(v, O, radio: 0.05)
  if rotulos {
    // los ejes moviles x, y, z (pegados al balancin interior)
    flecha3(v, esc3(R2 + 0.35, k), esc3(R2 + 1.25, k), etiqueta: $z$, color: c-dato, lado: "west", pos: 100%)
    flecha3(v, esc3(R1, n), esc3(R1 + 0.9, n), etiqueta: $y$, color: c-dato, lado: "north", pos: 100%)
    flecha3(v, O, esc3(1.6, ii), etiqueta: $x$, color: c-dato, lado: "north", pos: 100%)
    // las tres velocidades de Euler
    flecha3(v, (0, 0, R1 + 0.7), (0, 0, R1 + 1.55), etiqueta: $dot(phi) bold(K)$, color: c-verde, lado: "east", pos: 100%)
    giro3(v, (0, 0, R1 + 1.05), Z, u, 0.35, 290, color: c-verde)
    flecha3(v, esc3(-R1 - 0.05, n), esc3(-R1 - 0.85, n), etiqueta: $dot(theta) hat(j)$, color: c-rojo, lado: "south", pos: 100%)
    giro3(v, esc3(-R1 - 0.45, n), n, u, 0.3, 290, color: c-rojo)
    giro3(v, esc3(0.55, k), k, n, 0.55, 290, color: c-aux)
    rotulo3(v, suma3(esc3(0.55, k), esc3(0.75, n)), text(fill: c-aux)[$dot(psi) hat(k)$], ancla: "west")
    // te: de Z al eje del rotor
    linea3(v, arco3-pts(O, n, Z, 1.45, te), color: luma(40), grosor: 0.8pt)
    rotulo3(v, esc3(1.62, unit3(suma3(Z, k))), [$theta$], ancla: "south-east")
    // fi: en el plano horizontal de O, afuera del balancin, de X a u
    linea3(v, (esc3(2.3, u), esc3(3.2, u)), color: c-guia, grosor: 0.5pt, punteada: true)
    linea3(v, arco3-pts(O, Z, (1, 0, 0), 3.05, fi), color: luma(40), grosor: 0.8pt)
    rotulo3(v, esc3(3.25, unit3(suma3((1, 0, 0), u))), [$phi$], ancla: "north-east")
  }
})

// ---------------------------------------------------------------------
// Precesion estable (Beer fig. 18.17; hoja 4 de Anibal), vista en el plano
// de K y k (el eje y sale de la hoja). Dos paneles:
//  (a) omega = fi' K + psi' k, y sus componentes en los ejes moviles:
//      omega_z k sobre el eje y -fi' sin te i de costado.
//  (b) te = 90: giro, par y precesion como triada derecha (la mano).
// ---------------------------------------------------------------------
#let _prec-a = esquema(escala: 1.05cm, {
  let te = 35
  let fp = 1.5
  let pp = 1.8
  let O = (0, 0)
  let dk = 90 - te // direccion del eje del rotor (grados)
  let di = -te // direccion de x
  let kk = _p2(1, dk)
  let K = (0, fp)
  let P = _p2(pp, dk)
  let W = (K.at(0) + P.at(0), K.at(1) + P.at(1))
  // el disco, de canto, perpendicular a k
  let c1 = _p2(0.42, dk + 90)
  let c2 = _p2(0.42, dk - 90)
  let e = _p2(0.09, dk)
  cetz.draw.line((c1.at(0) - e.at(0), c1.at(1) - e.at(1)), (c1.at(0) + e.at(0), c1.at(1) + e.at(1)),
    (c2.at(0) + e.at(0), c2.at(1) + e.at(1)), (c2.at(0) - e.at(0), c2.at(1) - e.at(1)), close: true,
    fill: luma(225), stroke: 0.6pt + c-trazo)
  // ejes
  cetz.draw.line(O, (0, 3.4), stroke: punteado)
  rotulo((0, 3.45), text(fill: luma(80))[$Z$ (eje de precesión)], ancla: "south")
  cetz.draw.line(O, _p2(3.6, dk), stroke: punteado)
  rotulo(_p2(3.7, dk), text(fill: luma(80))[$z$ (eje del rotor)], ancla: "south-west")
  cetz.draw.line(O, _p2(1.9, di), stroke: punteado)
  rotulo(_p2(2.0, di), text(fill: luma(80))[$x$], ancla: "west")
  rotulo((-0.2, -0.2), [$O$ ($y$ sale de la hoja)], ancla: "north-east")
  // la suma omega = fi' K + psi' k (paralelogramo)
  cetz.draw.line(K, W, stroke: punteado)
  cetz.draw.line(P, W, stroke: punteado)
  flecha(O, K, etiqueta: $bold(Omega) = dot(phi) bold(K)$, color: c-verde, lado: "east", pos: 100%)
  flecha(O, P, etiqueta: $dot(psi) hat(k)$, color: c-aux, lado: "north-west", pos: 75%)
  flecha(O, W, etiqueta: $bold(omega)$, color: c-dato, lado: "south-east", pos: 100%, grosor: 1.2pt)
  // componentes de omega en x y z
  let wz = pp + fp * calc.cos(te * 1deg)
  let wx = fp * calc.sin(te * 1deg)
  let Pz = _p2(wz, dk)
  flecha(O, Pz, etiqueta: none, color: c-rosa, punteada: true)
  rotulo((Pz.at(0) + 0.1, Pz.at(1) - 0.05), text(fill: c-rosa)[$omega_z hat(k)$], ancla: "west")
  let Px = _p2(wx, di + 180)
  flecha(O, Px, etiqueta: none, color: c-rosa)
  rotulo((Px.at(0) - 0.05, Px.at(1) + 0.05), text(fill: c-rosa)[$-dot(phi) sin theta thin hat(i)$], ancla: "south-east")
  angulo(O, dk, 90, etiqueta: none, radio: 0.9)
  rotulo(_p2(1.15, (dk + 90) / 2), [$theta$], ancla: "center")
})

#let _prec-b = esquema(escala: 1.05cm, {
  let v = vista3d(az: 32, el: 18)
  let O = (0, 0, 0)
  // poste
  linea3(v, ((0, 0, -1.6), O), grosor: 1.4pt)
  // eje del rotor horizontal (+X del dibujo) y el disco
  linea3(v, (O, (2.6, 0, 0)), grosor: 1.2pt)
  cilindro3(v, (1.9, 0, 0), (1, 0, 0), 0.8, 0.22)
  masa3(v, (1.9, 0, 0), radio: 0.05)
  flecha3(v, (1.9, 0, 0), (1.9, 0, -1.25), etiqueta: $bold(W)$, color: c-trazo, lado: "east", pos: 100%)
  // la triada
  flecha3(v, (2.6, 0, 0), (3.8, 0, 0), etiqueta: [$dot(psi) hat(k)$ (giro)], color: c-aux, lado: "north", pos: 100%)
  giro3(v, (3.1, 0, 0), (1, 0, 0), (0, 0, 1), 0.3, 290, color: c-aux)
  flecha3(v, O, (0, 1.9, 0), etiqueta: [$sum bold(M)_O$ (par)], color: c-dato, lado: "south-west", pos: 100%)
  flecha3(v, O, (0, 0, 1.7), etiqueta: [$dot(phi) bold(K)$ (precesión)], color: c-verde, lado: "west", pos: 100%)
  giro3(v, (0, 0, 1.15), (0, 0, 1), (1, 0, 0), 0.4, 290, color: c-verde)
  rotulo3(v, O, [$O$], ancla: "south-west")
})

#let fig-precesion-estable = paneles(
  ([a) $bold(omega)$ como suma de dos giros], _prec-a),
  ([b) $theta = 90degree$: giro, par, precesión], _prec-b),
)

// ---------------------------------------------------------------------
// «Precesiones», la figura suelta que subio Anibal: un cuerpo simetrico
// libre de cupla, alargado (I < I') y achatado (I > I'), con H_G vertical.
// En el plano de z, omega y H_G. Se dibuja con el Beer: tan ga =
// (I/I') tan te; ga entre omega y el eje, te entre H_G y el eje, y be =
// abs(te - ga) entre omega y H_G (el «beta» de la figura de Anibal).
// cociente = I/I'.
// ---------------------------------------------------------------------
// Flecha curva en escorzo alrededor de un eje dibujado en el plano: un arco
// de elipse (achatado 0.35) centrado en c, de radio r, con su eje mayor en la
// direccion `dir`; sentido +1 o -1.
#let _curva(c, r, dir, sentido, color) = {
  let cd = calc.cos(dir * 1deg)
  let sd = calc.sin(dir * 1deg)
  let pts = range(0, 41).map(i => {
    let t = (200 + sentido * i / 40 * 290) * 1deg
    let a = r * calc.cos(t)
    let b = r * 0.35 * calc.sin(t)
    (c.at(0) + a * cd - b * sd, c.at(1) + a * sd + b * cd)
  })
  cetz.draw.line(..pts, stroke: 0.8pt + color, mark: (end: "stealth", scale: 0.4, fill: color))
}

#let _libre(cociente, alargado, enunciado: false) = esquema(escala: 0.95cm, {
  let te = 35
  let ga = calc.atan(cociente * calc.tan(te * 1deg)) / 1deg
  let be = calc.abs(te - ga)
  let O = (0, 0)
  let dH = 90
  let dz = 90 + te
  let dw = dz - ga
  let L = 3.0
  // el cuerpo
  if alargado {
    let a = _p2(1.35, dz)
    let b = _p2(-1.35, dz)
    let s = _p2(0.5, dz + 90)
    cetz.draw.line((a.at(0) + s.at(0), a.at(1) + s.at(1)), (a.at(0) - s.at(0), a.at(1) - s.at(1)),
      (b.at(0) - s.at(0), b.at(1) - s.at(1)), (b.at(0) + s.at(0), b.at(1) + s.at(1)), close: true,
      fill: luma(232), stroke: 0.6pt + c-trazo)
  } else {
    let a = _p2(0.22, dz)
    let b = _p2(-0.22, dz)
    let s = _p2(1.45, dz + 90)
    cetz.draw.line((a.at(0) + s.at(0), a.at(1) + s.at(1)), (a.at(0) - s.at(0), a.at(1) - s.at(1)),
      (b.at(0) - s.at(0), b.at(1) - s.at(1)), (b.at(0) + s.at(0), b.at(1) + s.at(1)), close: true,
      fill: luma(232), stroke: 0.6pt + c-trazo)
  }
  // cono espacial: alrededor de H_G, semiangulo be
  cetz.draw.line(O, _p2(L, dH - be), stroke: 0.6pt + c-verde)
  cetz.draw.line(O, _p2(L, dH + be), stroke: 0.6pt + c-verde)
  circulo-escorzo(_p2(L * calc.cos(be * 1deg), dH), L * calc.sin(be * 1deg), dir: dH - 90,
    achatado: 0.3, color: c-verde, grosor: 0.6pt, punteada: false)
  // cono corporal: alrededor de z, semiangulo ga
  let Lc = if alargado { L } else { 2.3 }
  cetz.draw.line(O, _p2(Lc, dz - ga), stroke: 0.6pt + c-aux)
  cetz.draw.line(O, _p2(Lc, dz + ga), stroke: 0.6pt + c-aux)
  circulo-escorzo(_p2(Lc * calc.cos(ga * 1deg), dz), Lc * calc.sin(ga * 1deg), dir: dz - 90,
    achatado: 0.3, color: c-aux, grosor: 0.6pt, punteada: true)
  // los tres ejes
  flecha(O, _p2(L + 0.9, dH), etiqueta: none, color: c-verde, grosor: 1.3pt)
  rotulo(_p2(L + 0.95, dH), text(fill: c-verde)[$bold(H)_G$ ($Z$, fijo)], ancla: "south")
  cetz.draw.line(O, _p2(L + 0.7, dz), stroke: 0.8pt + c-aux)
  rotulo(_p2(L + 1.0, dz), text(fill: c-aux)[$z$ (eje)], ancla: "south-east")
  flecha(O, _p2(L + 0.45, dw), etiqueta: none, color: c-dato, grosor: 1.1pt)
  rotulo(_p2(L + 0.55, dw), text(fill: c-dato)[$bold(omega)$], ancla: if alargado { "south" } else { "south-west" })
  // angulos
  angulo(O, dH, dz, etiqueta: none, radio: 1.55, color: luma(60))
  rotulo(_p2(1.82, (dH + dz) / 2), text(fill: luma(60))[$theta$], ancla: "center")
  angulo(O, calc.min(dH, dw), calc.max(dH, dw), etiqueta: none, radio: 2.25, color: c-verde)
  rotulo(_p2(2.5, (dH + dw) / 2), text(fill: c-verde)[$beta$], ancla: "center")
  angulo(O, dw, dz, etiqueta: none, radio: if alargado { 1.1 } else { 0.85 }, color: c-aux)
  rotulo(_p2(if alargado { 1.3 } else { 1.05 }, (dw + dz) / 2), text(fill: c-aux)[$gamma$], ancla: "center")
  // giros: precesion alrededor de H_G y spin alrededor de z (flechas curvas
  // en escorzo; el spin al reves en el achatado)
  _curva(_p2(L + 0.35, dH), 0.42, dH - 90, 1, c-verde)
  rotulo((_p2(L + 0.35, dH).at(0) - 0.5, _p2(L + 0.35, dH).at(1)), text(fill: c-verde)[$dot(phi)$], ancla: "east", tam: 8.5pt)
  _curva(_p2(3.35, dz), 0.32, dz - 90, if alargado { 1 } else { -1 }, c-aux)
  rotulo((_p2(3.35, dz).at(0) - 0.42, _p2(3.35, dz).at(1)), text(fill: c-aux)[$dot(psi)$], ancla: "east", tam: 8.5pt)
  let pie = if enunciado {
    if alargado [$I < I_0$, $dot(psi) > 0$] else [$I > I_0$, $dot(psi) < 0$]
  } else {
    if alargado [$I < I'$: $dot(psi) > 0$, *directa*] else [$I > I'$: $dot(psi) < 0$, *retrógrada*]
  }
  rotulo((0, -1.9), pie, ancla: "north")
  masa(O, radio: 0.05)
  rotulo((0.15, -0.05), [$G$], ancla: "north-west")
})

// enunciado: true deja las letras de la figura de Aníbal (I_0) y no dice
// cuál es directa: eso es lo que se pregunta.
#let fig-precesiones(enunciado: false) = paneles(
  ([alargado (cilindro)], _libre(0.5, true, enunciado: enunciado)),
  ([achatado (disco)], _libre(2.0, false, enunciado: enunciado)),
  sep: 24pt,
)

// ---------------------------------------------------------------------
// H_O = r x m v + H_G (hoja 1 de Anibal; Beer ec. 18.11, fig. 18.26).
// ---------------------------------------------------------------------
#let fig-HO = esquema(escala: 1.0cm, {
  let v = vista3d(az: 30, el: 18)
  let O = (0, 0, 0)
  flecha3(v, O, (0, 0, 2.2), etiqueta: $Y$, color: luma(90), lado: "west", pos: 100%)
  flecha3(v, O, (0, 3.2, 0), etiqueta: $X$, color: luma(90), lado: "north", pos: 100%)
  flecha3(v, O, (2.4, 0, 0), etiqueta: $Z$, color: luma(90), lado: "north", pos: 100%)
  rotulo3(v, O, [$O$], ancla: "north-east")
  let G = (0.4, 2.2, 1.3)
  // el cuerpo: un elipsoide sugerido con dos circulos
  linea3(v, circulo3-pts(G, (0, 0, 1), 0.75), color: c-trazo, grosor: 0.7pt)
  linea3(v, circulo3-pts(G, (1, 0, 0), 0.75), color: c-guia, grosor: 0.5pt, punteada: true)
  masa3(v, G, radio: 0.06)
  rotulo3(v, G, [$G$], ancla: "north-west")
  flecha3(v, O, G, color: c-aux)
  rotulo3(v, esc3(0.5, G), text(fill: c-aux)[$overline(bold(r))$], ancla: "north-west")
  flecha3r(v, G, suma3(G, (0, 1.6, 0.2)), $m overline(bold(v))$, ancla: "west")
  flecha3(v, G, suma3(G, (0, 0.15, 1.3)), etiqueta: $bold(H)_G$, color: c-verde, lado: "west", pos: 100%)
  giro3(v, suma3(G, (0, 0.1, 0.95)), (0, 0.12, 1), (1, 0, 0), 0.22, 290, color: c-verde)
})

// ---------------------------------------------------------------------
// El disco torcido en su eje (modelo, ejercicio 10; Beer §18.8). Vista de
// costado, en el plano que contiene al eje y al eje del disco en ese
// instante: omega horizontal, el eje del disco a be del eje de giro, H_G
// entre los dos (mas cerca del eje del disco) y las fuerzas de los
// cojinetes, opuestas, que giran con el eje.
// ---------------------------------------------------------------------
#let fig-disco-torcido(respuesta: false) = esquema(escala: 1.0cm, {
  let be = 14 // exagerado para que se vea; el dato es 5 grados
  let O = (0, 0)
  cetz.draw.line((-3.6, 0), (3.6, 0), stroke: 1.6pt + c-trazo)
  for x in (-3.0, 3.0) {
    cetz.draw.rect((x - 0.25, -0.35), (x + 0.25, 0.35), fill: luma(200), stroke: 0.6pt + c-trazo)
  }
  rotulo((-3.0, -0.45), [$A$], ancla: "north")
  rotulo((3.3, -0.4), [$B$], ancla: "north-west")
  // el disco, de canto: perpendicular a su eje, que forma be con el eje de giro
  let a = _p2(1.5, 90 - be)
  let s = _p2(0.07, -be)
  cetz.draw.line((a.at(0) + s.at(0), a.at(1) + s.at(1)), (a.at(0) - s.at(0), a.at(1) - s.at(1)),
    (-a.at(0) - s.at(0), -a.at(1) - s.at(1)), (-a.at(0) + s.at(0), -a.at(1) + s.at(1)), close: true,
    fill: luma(215), stroke: 0.6pt + c-trazo)
  cetz.draw.line(_p2(-2.4, -be), _p2(2.4, -be), stroke: punteado)
  rotulo(_p2(-2.0, -be), text(fill: luma(80))[eje del disco], ancla: "south-west")
  flecha((0, 0), (2.2, 0), etiqueta: none, color: c-dato, grosor: 1.2pt)
  rotulo((2.2, 0.1), text(fill: c-dato)[$bold(omega)$], ancla: "south")
  angulo(O, -be, 0, etiqueta: none, radio: 1.2)
  rotulo(_p2(1.25, -be - 7), [$beta$], ancla: "north-west")
  if respuesta {
    flecha(O, _p2(2.1, -be / 2), etiqueta: none, color: c-verde)
    rotulo(_p2(2.15, -be / 2), text(fill: c-verde)[$bold(H)_G$], ancla: "north-west")
    flecha((-3.0, 0.35), (-3.0, 1.3), etiqueta: $bold(F)$, color: c-aux, lado: "east", pos: 100%)
    flecha((3.0, -0.35), (3.0, -1.3), etiqueta: $-bold(F)$, color: c-aux, lado: "east", pos: 100%)
    rotulo((0, -1.65), text(size: 7.5pt, fill: luma(80))[$bold(F)$ y $-bold(F)$ giran con el eje: es la cupla $dot(bold(H))_G = bold(omega) times bold(H)_G$], ancla: "north")
  } else {
    rotulo((0, -1.75), text(size: 7.5pt, fill: luma(80))[$beta$ exagerado en el dibujo; cojinetes separados 0,40 m], ancla: "north")
  }
})

// ---------------------------------------------------------------------
// El satelite achatado y el meteorito (modelo, ejercicio 6).
// ---------------------------------------------------------------------
#let fig-meteorito = esquema(escala: 1.0cm, {
  let v = vista3d(az: 30, el: 20)
  let G = (0, 0, 0)
  cilindro3(v, G, (0, 0, 1), 1.6, 0.7)
  masa3(v, G, radio: 0.05)
  flecha3(v, (0, 0, 0.35), (0, 0, 2.3), etiqueta: $z$, color: luma(70), lado: "west", pos: 100%)
  giro3(v, (0, 0, 1.6), (0, 0, 1), (1, 0, 0), 0.35, 290, color: c-aux)
  rotulo3(v, (0, -0.45, 1.6), text(fill: c-aux)[$omega_0$], ancla: "east")
  flecha3(v, G, (0, 2.5, 0), etiqueta: $y$, color: luma(70), lado: "north", pos: 100%)
  flecha3(v, G, (2.4, 0, 0), etiqueta: $x$, color: luma(70), lado: "north", pos: 100%)
  let C = (0, 1.2, 0.35)
  masa3(v, C, radio: 0.06, color: c-dato)
  rotulo3(v, C, [$C$], ancla: "south-east")
  flecha3(v, (0, 1.2, 2.0), (0, 1.2, 0.45), etiqueta: $bold(v)_0$, color: c-dato, lado: "west", pos: 0%)
  rotulo3(v, (0, 0.6, -1.1), [$C$ a 1,2 m del eje $z$], ancla: "north")
})
