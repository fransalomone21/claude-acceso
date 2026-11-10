// =====================================================================
//  figuras-cmg.typ -- el CMG dibujado en 3D, con sus vectores (2026-11-10,
//  pedido de Fran: «imágenes del CMG así cuando vea uno lo entiendo, con
//  vectores y todo, como el giróscopo o la niña»). Las usan el módulo
//  `actitud` del apunte y practica/resumen-cmg.typ; viven acá por lo mismo
//  que figuras-precesion.typ: el apunte no importa de practica/.
//  Rótulos con HALO y en capa de arriba (lo mide practica/verificar-figuras.py
//  sobre practica/galeria-cmg.typ).
//
//  OJO (trampa 10 del HANDOFF): ninguna variable local se llama como una
//  letra griega: Typst resolvería $delta$ contra el número. Van de, be, al.
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

// ---------------------------------------------------------------------
// El CMG entero, en 3D. Satélite abajo (una placa), el cardán sobre g = k,
// el rotor sobre s, a un ángulo de del eje i del satélite. t = g x s.
// H_r = h s; su punta se mueve sobre t (h deltadot t); el satélite recibe
// la cupla opuesta, -h deltadot t.
// ---------------------------------------------------------------------
#let fig-cmg-3d = esquema(escala: 1.0cm, {
  // la cámara mira a 45 grados de s y de t, desde arriba: los dos se ven
  let v = vista3d(az: -15, el: 32)
  let de = 30
  let s = _dir(de)
  let t = _dir(de + 90)
  let g = (0, 0, 1)
  let O = (0, 0, 0)
  let R = 1.3
  let zp = -2.3
  // el satélite: una placa
  caja3(v, (-1.8, -1.6, zp - 0.25), (3.6, 0, 0), (0, 3.2, 0), (0, 0, 0.25),
    tonos: (rgb("#DCE8F2"), rgb("#C6D8E8"), rgb("#EAF2F8")))
  rotulo3(v, (1.8, -1.6, zp - 0.25), text(size: 7.5pt, fill: luma(60))[satélite], ancla: "north")
  // los ejes del satélite, a la altura del rotor
  linea3(v, (O, (2.6, 0, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (2.7, 0, 0), text(fill: luma(90))[$hat(i)$], ancla: "north")
  linea3(v, (O, (0, 2.4, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (0, 2.5, 0), text(fill: luma(90))[$hat(j)$], ancla: "west")
  // el motor del cardán y su eje
  caja3(v, (-0.3, -0.3, zp), (0.6, 0, 0), (0, 0.6, 0), (0, 0, 0.35))
  linea3(v, ((0, 0, zp + 0.35), (0, 0, -R)), grosor: 1.6pt)
  linea3(v, ((0, 0, R), (0, 0, R + 0.35)), grosor: 1.6pt)
  // el cardán: un anillo en el plano de g y s
  linea3(v, circulo3-pts(O, t, R), color: c-verde, grosor: 2.2pt)
  // el eje del rotor, de cojinete a cojinete del anillo
  linea3(v, (esc3(-R, s), esc3(R, s)), grosor: 1.0pt, color: c-trazo)
  // el rotor
  cilindro3(v, O, s, 0.85, 0.28, relleno: c-dato.lighten(70%), tapa: c-dato.lighten(82%))
  masa3(v, O, radio: 0.05)
  // el ángulo de cardán, en el plano del satélite
  linea3(v, arco3-pts(O, g, (1, 0, 0), 2.05, de), color: luma(40), grosor: 0.8pt)
  rotulo3(v, esc3(2.25, _dir(de / 2)), [$delta$], ancla: "north-west")
  // g y el giro del cardán
  flecha3r(v, (0, 0, R + 0.35), (0, 0, R + 1.2), $hat(g) = hat(k)$, color: c-verde, ancla: "west")
  giro3(v, (0, 0, R + 0.7), g, (1, 0, 0), 0.38, 290, color: c-verde)
  rotulo3(v, (-0.45, 0, R + 0.7), text(fill: c-verde)[$dot(delta)$], ancla: "east")
  // H_r sobre s, y el spin
  flecha3r(v, esc3(0.2, s), esc3(2.9, s), $bold(H)_r = h hat(s)$, color: c-dato, ancla: "north-west")
  giro3(v, esc3(1.75, s), s, g, 0.32, 290, color: c-dato)
  rotulo3(v, suma3(esc3(1.75, s), (0, 0, 0.45)), text(fill: c-dato)[$Omega_s$], ancla: "south")
  // la punta de H_r se va sobre t
  flecha3r(v, esc3(2.9, s), suma3(esc3(2.9, s), esc3(1.2, t)), $h dot(delta) hat(t)$, color: c-aux, ancla: "south")
  // la cupla sobre el satélite, opuesta, dibujada sobre la placa
  let base = (1.0, 1.1, zp)
  flecha3r(v, base, suma3(base, esc3(-1.3, t)), [sobre el satélite: $-h dot(delta) hat(t)$], color: c-rojo, ancla: "north-west")
})

// ---------------------------------------------------------------------
// La analogía de Aníbal: la fuerza central le gira la velocidad al satélite
// en órbita; la cupla del cardán le gira H al rotor. En los dos, el cambio
// es perpendicular: cambia la dirección y no el módulo.
// ---------------------------------------------------------------------
#let _par-vectores(nombre1, nombre2, dnombre, color) = {
  let L = 2.4
  let a1 = 70
  let a2 = 100
  let O = (0, 0)
  let P1 = (L * calc.cos(a1 * 1deg), L * calc.sin(a1 * 1deg))
  let P2 = (L * calc.cos(a2 * 1deg), L * calc.sin(a2 * 1deg))
  cetz.draw.arc(O, start: (a1 - 20) * 1deg, stop: (a2 + 20) * 1deg, radius: L, anchor: "origin",
    stroke: (paint: c-guia, thickness: 0.5pt, dash: "dotted"))
  flecha(O, P1, color: color.lighten(35%))
  flecha(O, P2, color: color)
  rotulo(P1, text(fill: color.lighten(20%))[#nombre1], ancla: "west")
  rotulo(P2, text(fill: color)[#nombre2], ancla: "east")
  flecha(P1, P2, color: c-aux, grosor: 0.9pt)
  rotulo(((P1.at(0) + P2.at(0)) / 2, (P1.at(1) + P2.at(1)) / 2 + 0.12), text(fill: c-aux)[#dnombre], ancla: "south")
}
#let fig-cmg-analogia = paneles(
  ("satélite en órbita", esquema(escala: 0.85cm, {
    _par-vectores($bold(v)$, $bold(v) + Delta bold(v)$, $Delta bold(v)$, c-dato)
    rotulo((0, -0.25), text(size: 7.5pt)[fuerza central $perp bold(v)$:\ $Delta bold(v)$ de costado, $|bold(v)|$ igual], ancla: "north")
  })),
  ("rotor de un CMG", esquema(escala: 0.85cm, {
    _par-vectores($bold(H)_r$, $bold(H)_r + Delta bold(H)_r$, $Delta bold(H)_r$, c-dato)
    rotulo((0, -0.25), text(size: 7.5pt)[cupla del cardán $perp bold(H)_r$:\ $Delta bold(H)_r$ de costado, $h$ igual], ancla: "north")
  })),
)

// ---------------------------------------------------------------------
// La silla y la rueda (la demostración de la niña con la rueda, al revés):
// la rueda gira con H horizontal; la persona le inclina el eje; el H de la
// rueda gana un DeltaH hacia arriba, y la silla gira con -DeltaH (de arriba,
// en sentido horario). Nadie de afuera tocó nada.
// ---------------------------------------------------------------------
#let fig-cmg-silla = esquema(escala: 1.0cm, {
  let v = vista3d(az: -30, el: 14)
  let Z = (0, 0, 1)
  let al = 28
  let a0 = (0, 1, 0)
  let a1 = (0, calc.cos(al * 1deg), calc.sin(al * 1deg))
  let W = (0.9, 0, -0.05)
  // la silla: pie, base y asiento
  cilindro3(v, (0, 0, -2.35), Z, 0.55, 0.08)
  cilindro3(v, (0, 0, -1.85), Z, 0.07, 0.9)
  cilindro3(v, (0, 0, -1.33), Z, 0.65, 0.14, relleno: luma(205), tapa: luma(232))
  // la persona: torso, cabeza, brazos
  linea3(v, ((0, 0, -1.25), (0, 0, 0.25)), grosor: 3.2pt, color: luma(90))
  esfera3(v, (0, 0, 0.62), 0.27, color: luma(150))
  let manoI = suma3(W, esc3(-0.55, a1))
  let manoD = suma3(W, esc3(0.55, a1))
  linea3(v, ((0, -0.25, 0.15), manoI), grosor: 2.0pt, color: luma(90))
  linea3(v, ((0, 0.25, 0.15), manoD), grosor: 2.0pt, color: luma(90))
  // la rueda, con el eje ya inclinado
  linea3(v, (suma3(W, esc3(-0.6, a1)), suma3(W, esc3(0.6, a1))), grosor: 1.2pt)
  cilindro3(v, W, a1, 0.75, 0.1, relleno: c-dato.lighten(70%), tapa: c-dato.lighten(85%))
  // H de la rueda: antes (horizontal, punteado) y después (inclinado)
  let L = 1.9
  flecha3(v, suma3(W, esc3(0.6, a0)), suma3(W, esc3(L, a0)), color: c-dato.lighten(40%), punteada: true)
  rotulo3(v, suma3(W, esc3(L, a0)), text(fill: c-dato.lighten(20%))[antes], ancla: "west")
  flecha3r(v, suma3(W, esc3(0.6, a1)), suma3(W, esc3(L, a1)), $bold(H)_"rueda"$, color: c-dato, ancla: "south-west")
  flecha3(v, suma3(W, esc3(L, a0)), suma3(W, esc3(L, a1)), color: c-aux)
  rotulo3(v, suma3(W, esc3(L * 1.03, unit3(suma3(a0, a1)))), text(fill: c-aux)[$Delta bold(H)$], ancla: "west")
  // la silla responde con -DeltaH: gira en sentido horario visto de arriba
  giro3(v, (0, 0, -1.33), (0, 0, -1), (1, 0, 0), 0.95, 300, color: c-rojo)
  flecha3r(v, (-1.3, 0, -1.0), (-1.3, 0, -2.0), [silla: $-Delta bold(H)$], color: c-rojo, ancla: "east")
})

// ---------------------------------------------------------------------
// Cuatro CMG de un cardán en pirámide (Lappas 2002, fig. 15): cada cardán
// es perpendicular a una cara (inclinada be respecto del piso); cada rotor
// gira su H en el plano de su cara. Se dibujan de atrás hacia adelante.
// ---------------------------------------------------------------------
#let fig-cmg-piramide = esquema(escala: 1.0cm, {
  let v = vista3d(az: 30, el: 24)
  let be = 54.74
  let b = 1.7
  let A = (0, 0, b * calc.tan(be * 1deg) * 0.62)
  let esq = ((b, b, 0), (-b, b, 0), (-b, -b, 0), (b, -b, 0))
  // la pirámide, en línea fina
  for i in range(4) {
    linea3(v, (esq.at(i), esq.at(calc.rem(i + 1, 4))), color: luma(150), grosor: 0.6pt)
    linea3(v, (esq.at(i), A), color: luma(170), grosor: 0.5pt, punteada: true)
  }
  let grados = (20, -35, 50, 0)
  let cmgs = range(4).map(i => {
    let az = i * 90
    let n = unit3(cruz3(resta3(esq.at(calc.rem(i + 3, 4)), A), resta3(esq.at(i), A)))
    let n = if n.at(2) < 0 { esc3(-1, n) } else { n }
    let m = esc3(1 / 3, suma3(suma3(esq.at(i), esq.at(calc.rem(i + 3, 4))), A))
    let tg = unit3(cruz3(n, (0, 0, 1)))
    let up = cruz3(tg, n)
    let d = grados.at(i)
    let h = suma3(esc3(calc.cos(d * 1deg), tg), esc3(calc.sin(d * 1deg), up))
    (prof3(v, m), m, n, h, i)
  }).sorted(key: x => x.at(0))
  for (_, m, n, h, i) in cmgs {
    let c = suma3(m, esc3(0.32, n))
    linea3(v, (m, c), grosor: 1.2pt, color: c-verde)
    cilindro3(v, c, h, 0.32, 0.12, relleno: c-dato.lighten(70%), tapa: c-dato.lighten(85%))
    flecha3(v, suma3(c, esc3(0.1, h)), suma3(c, esc3(0.95, h)), color: c-dato)
    flecha3(v, suma3(c, esc3(0.1, n)), suma3(c, esc3(0.75, n)), color: c-verde, grosor: 0.7pt)
    if i == 3 {
      rotulo3(v, suma3(c, esc3(0.95, h)), text(fill: c-dato)[$bold(H)_r$], ancla: "west")
      rotulo3(v, suma3(c, esc3(0.75, n)), text(fill: c-verde)[$hat(g)$], ancla: "south-west")
    }
  }
})
