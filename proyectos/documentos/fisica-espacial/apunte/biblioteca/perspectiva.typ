// =====================================================================
//  perspectiva.typ — dibujar en 3D con el mismo vocabulario de estilo.typ
//
//  Las escenas del módulo de rotación (la rueda en el pivote, el profesor
//  en la mesa giratoria, la puerta) son de tres dimensiones, y de costado se
//  pierde justo lo que importa: un torque que «entra en la hoja» no se ve.
//  Esto proyecta un punto (x, y, z) —z hacia arriba— sobre la hoja, con una
//  cámara que mira desde el acimut `az` y la elevación `el`, a distancia
//  `dist` (perspectiva central suave: lo cercano se ve un poco más grande).
//  Con az = 35 y el = 20: x viene hacia el lector por la izquierda, y va a
//  la derecha, z sube. Todo lo demás —flechas, rótulos, colores— es el
//  vocabulario 2D de estilo.typ aplicado a los puntos ya proyectados; el
//  orden de dibujo (lo de atrás primero) lo decide cada figura.
//
//  No hace falta ninguna herramienta externa: es CeTZ y tres productos
//  escalares. Probado mirando el render en la galería.
// =====================================================================
#import "estilo.typ": *

#let vista3d(az: 35, el: 20, dist: 16) = (az: az, el: el, dist: dist)

#let suma3(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1), a.at(2) + b.at(2))
#let resta3(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1), a.at(2) - b.at(2))
#let esc3(k, a) = (k * a.at(0), k * a.at(1), k * a.at(2))
#let prod3(a, b) = a.at(0) * b.at(0) + a.at(1) * b.at(1) + a.at(2) * b.at(2)
#let cruz3(a, b) = (
  a.at(1) * b.at(2) - a.at(2) * b.at(1),
  a.at(2) * b.at(0) - a.at(0) * b.at(2),
  a.at(0) * b.at(1) - a.at(1) * b.at(0),
)
#let unit3(a) = esc3(1 / calc.sqrt(prod3(a, a)), a)

// hacia la cámara, derecha de la hoja, arriba de la hoja
#let _cam3(v) = {
  let a = v.az * 1deg
  let e = v.el * 1deg
  (
    (calc.cos(e) * calc.cos(a), calc.cos(e) * calc.sin(a), calc.sin(e)),
    (-calc.sin(a), calc.cos(a), 0),
    (-calc.sin(e) * calc.cos(a), -calc.sin(e) * calc.sin(a), calc.cos(e)),
  )
}
// profundidad: mayor = más cerca del lector
#let prof3(v, p) = prod3(p, _cam3(v).at(0))
#let p3(v, p) = {
  let (d, e1, e2) = _cam3(v)
  let k = v.dist / (v.dist - prod3(p, d))
  (k * prod3(p, e1), k * prod3(p, e2))
}

// Un arco de círculo en el espacio: centro c, eje n, arranca en la
// dirección s (perpendicular a n) y gira `grados` según la mano derecha
// alrededor de n.
#let arco3-pts(c, n, s, r, grados, k: 48) = {
  let n = unit3(n)
  let s = unit3(s)
  let w = cruz3(n, s)
  range(0, k + 1).map(i => {
    let t = grados * i / k * 1deg
    suma3(c, suma3(esc3(r * calc.cos(t), s), esc3(r * calc.sin(t), w)))
  })
}
#let _perp3(n) = {
  let n = unit3(n)
  let a = if calc.abs(n.at(2)) < 0.9 { (0, 0, 1) } else { (1, 0, 0) }
  unit3(cruz3(a, n))
}
#let circulo3-pts(c, n, r, k: 72) = arco3-pts(c, n, _perp3(n), r, 360, k: k)

// La envolvente convexa (cadena monótona): el contorno de un cilindro
// visto en perspectiva es la envolvente de sus dos tapas.
#let envolvente(pts) = {
  let p = pts.sorted(key: q => q.at(0) * 1e4 + q.at(1))
  let giro(o, a, b) = (a.at(0) - o.at(0)) * (b.at(1) - o.at(1)) - (a.at(1) - o.at(1)) * (b.at(0) - o.at(0))
  let inf = ()
  for q in p {
    while inf.len() >= 2 and giro(inf.at(-2), inf.at(-1), q) <= 0 { let _ = inf.pop() }
    inf.push(q)
  }
  let sup = ()
  for q in p.rev() {
    while sup.len() >= 2 and giro(sup.at(-2), sup.at(-1), q) <= 0 { let _ = sup.pop() }
    sup.push(q)
  }
  inf.slice(0, -1) + sup.slice(0, -1)
}

#let linea3(v, pts, color: c-trazo, grosor: trazo-cuerpo, punteada: false) = {
  let st = if punteada { (paint: color, thickness: grosor, dash: "dashed") } else { grosor + color }
  cetz.draw.line(..pts.map(p => p3(v, p)), stroke: st)
}
#let flecha3(v, a, b, ..args) = flecha(p3(v, a), p3(v, b), ..args)
#let rotulo3(v, p, cuerpo, ..args) = rotulo(p3(v, p), cuerpo, ..args)
#let masa3(v, p, ..args) = masa(p3(v, p), ..args)

// Una flecha curva alrededor de un eje: el sentido de giro (mano derecha
// alrededor de n). Es el «los dedos acompañan el giro» dibujado.
#let giro3(v, c, n, s, r, grados, color: c-aux, grosor: 0.8pt) = {
  let pts = arco3-pts(c, n, s, r, grados).map(p => p3(v, p))
  cetz.draw.line(..pts, stroke: grosor + color, mark: (end: "stealth", scale: 0.45, fill: color))
}

// Un cilindro (disco con espesor, eje, varilla, torso): centro c, eje n,
// radio r, largo total `alto`. Se rellena la envolvente de las dos tapas y
// encima va la tapa que mira al lector.
#let cilindro3(v, c, n, r, alto, relleno: luma(222), tapa: luma(242), color: c-trazo, grosor: trazo-cuerpo) = {
  let n = unit3(n)
  let a = suma3(c, esc3(-alto / 2, n))
  let b = suma3(c, esc3(alto / 2, n))
  let ca = circulo3-pts(a, n, r)
  let cb = circulo3-pts(b, n, r)
  let casco = envolvente((ca + cb).map(p => p3(v, p)))
  cetz.draw.line(..casco, close: true, fill: relleno, stroke: grosor + color)
  let delante = if prof3(v, b) > prof3(v, a) { cb } else { ca }
  cetz.draw.line(..delante.map(p => p3(v, p)), close: true, fill: tapa, stroke: grosor + color)
}

// Una esfera: el círculo proyectado, con un brillo arriba a la izquierda.
#let esfera3(v, c, r, color: luma(150)) = {
  let k = v.dist / (v.dist - prod3(c, _cam3(v).at(0)))
  cetz.draw.circle(p3(v, c), radius: r * k,
    fill: gradient.radial(color.lighten(75%), color, center: (35%, 30%), radius: 75%),
    stroke: 0.5pt + color.darken(40%))
}

// Una caja (la puerta): esquina o y tres aristas a, b, c. Se dibujan sólo
// las caras que miran al lector, de la más lejana a la más cercana.
#let caja3(v, o, a, b, c, tonos: (luma(232), luma(212), luma(246)), color: c-trazo, grosor: trazo-cuerpo) = {
  let caras = (
    (o, a, b, cruz3(a, b), tonos.at(0)), (suma3(o, c), a, b, cruz3(a, b), tonos.at(0)),
    (o, b, c, cruz3(b, c), tonos.at(1)), (suma3(o, a), b, c, cruz3(b, c), tonos.at(1)),
    (o, c, a, cruz3(c, a), tonos.at(2)), (suma3(o, b), c, a, cruz3(c, a), tonos.at(2)),
  )
  let centro = suma3(o, esc3(0.5, suma3(a, suma3(b, c))))
  let vis = ()
  for (q, u, w, nrm, tono) in caras {
    let mitad = suma3(q, esc3(0.5, suma3(u, w)))
    let afuera = if prod3(nrm, resta3(mitad, centro)) < 0 { esc3(-1, nrm) } else { nrm }
    if prod3(afuera, _cam3(v).at(0)) > 0 {
      vis.push((prof3(v, mitad), (q, suma3(q, u), suma3(q, suma3(u, w)), suma3(q, w)), tono))
    }
  }
  for (_, pts, tono) in vis.sorted(key: x => x.at(0)) {
    cetz.draw.line(..pts.map(p => p3(v, p)), close: true, fill: tono, stroke: grosor + color)
  }
}
