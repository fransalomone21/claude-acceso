// =====================================================================
//  figuras-cr-guia.typ -- los dibujos de la guia de CR resuelta, del
//  Problema 4 al Adicional 2 (2026-11-16, pedido de Fran: «dibujos
//  originales y representaciones tuyas con todos los vectores»). Cada uno es
//  el cuerpo del problema con sus vectores en su lugar: H_G, omega, el eje,
//  los giros de precesion y de spin, los impulsos y las cuplas. Los sentidos
//  salen de la cuenta de resueltos-cr.typ, no del ojo.
//
//  OJO (trampa 10 del HANDOFF del apunte): ninguna variable local se llama
//  como una letra griega; aca van te, ga, fp, wv.
// =====================================================================
#import "../apunte/biblioteca/estilo.typ": *
#import "../apunte/biblioteca/estilo.typ" as est
#import "../apunte/biblioteca/perspectiva.typ": *

// Rotulos con halo y en la capa de arriba (lo que mide verificar-figuras.py).
#let rotulo(pos, cuerpo, ..args) = cetz.draw.on-layer(2,
  est.rotulo(pos, box(fill: white, inset: (x: 1.2pt, y: 0.8pt), cuerpo), ..args))
#let rotulo3(v, p, cuerpo, ..args) = rotulo(p3(v, p), cuerpo, ..args)
#let _nota(v, p, cuerpo, ..args) = rotulo3(v, p, text(size: 7.5pt, fill: luma(60), cuerpo), ..args)

// ---------------------------------------------------------------------
// El cuerpo simetrico libre (Problemas 4, 5 y 6). H_G fijo sobre Z; el eje
// de simetria k inclinado `te` grados hacia +x (exagerado); q = I / I'.
// psi' / phi' = (I' - I)/I cos te = (1/q - 1) cos te, y omega = phi' K +
// psi' k: si q > 1 omega queda del otro lado de H (retrograda, gamma >
// theta); si q < 1, entre el eje y H (directa).
// ---------------------------------------------------------------------
#let _libre(q, te, cuerpo, largo-eje: 2.6) = {
  let v = vista3d(az: -70, el: 14)
  let G = (0, 0, 0)
  let K = (0, 0, 1)
  let k = (calc.sin(te * 1deg), 0, calc.cos(te * 1deg))
  let rel = (1 / q - 1) * calc.cos(te * 1deg)
  let wv = unit3(suma3(K, esc3(rel, k)))
  let aw = calc.atan2(wv.at(2), wv.at(0)) / 1deg // angulo de omega desde Z, hacia +x
  let ny = (0, 1, 0)
  // el cuerpo, centrado en G con su eje sobre k
  cuerpo(v, G, k)
  // el cono que barre el eje alrededor de H_G
  let h = largo-eje * calc.cos(te * 1deg)
  let rr = largo-eje * calc.sin(te * 1deg)
  linea3(v, circulo3-pts((0, 0, h), K, rr), color: c-guia, grosor: 0.5pt, punteada: true)
  // el eje de simetria
  linea3(v, (esc3(-0.6, k), esc3(largo-eje, k)), color: luma(70), grosor: 0.6pt, punteada: true)
  rotulo3(v, esc3(largo-eje + 0.12, k), text(fill: luma(70))[$z$ (eje)], ancla: "south-west")
  // H_G fijo
  flecha3(v, G, (0, 0, 3.1), color: c-verde, grosor: 1.2pt)
  rotulo3(v, (0, 0, 3.15), text(fill: c-verde)[$bold(H)_G$ fijo $= bold(K)$], ancla: "south")
  // omega
  flecha3(v, G, esc3(2.3, wv), color: c-dato, grosor: 1.1pt)
  rotulo3(v, esc3(2.35, wv), text(fill: c-dato)[$bold(omega)$], ancla: if aw < 0 { "south-east" } else { "west" })
  // precesion: giro alrededor de K
  giro3(v, (0, 0, 2.55), K, (1, 0, 0), 0.42, 290, color: c-verde)
  rotulo3(v, (0.5, 0, 2.55), text(fill: c-verde)[$dot(phi)$], ancla: "west")
  // spin: giro alrededor de k, con el signo de psi'
  let ns = if rel < 0 { esc3(-1, k) } else { k }
  giro3(v, esc3(1.55, k), ns, (0, 1, 0), 0.32, 290, color: c-aux)
  rotulo3(v, suma3(esc3(1.55, k), (0.42, 0, 0)), text(fill: c-aux)[$dot(psi)$ #if rel < 0 [$< 0$] else [$> 0$]], ancla: "west")
  // theta (de K al eje) y gamma (del eje a omega)
  linea3(v, arco3-pts(G, ny, K, 1.0, te), color: luma(40), grosor: 0.7pt)
  rotulo3(v, esc3(1.18, unit3(suma3(K, k))), [$theta$], ancla: "south")
  let ini = calc.min(te, aw)
  let barr = calc.abs(te - aw)
  let s0 = (calc.sin(ini * 1deg), 0, calc.cos(ini * 1deg))
  linea3(v, arco3-pts(G, ny, s0, 1.55, barr), color: c-dato, grosor: 0.7pt)
  let med = (te + aw) / 2
  rotulo3(v, esc3(1.75, (calc.sin(med * 1deg), 0, calc.cos(med * 1deg))), text(fill: c-dato)[$gamma$], ancla: if aw < te { "south-east" } else { "south-west" })
  // el veredicto
  _nota(v, (0, 0, -1.55), if q > 1 [achatado: $gamma > theta$, retrógrada] else [alargado: $theta > gamma$, directa], ancla: "north")
}

// Problema 4: el spacecraft achatado (k_z / k = 720/540, I/I' = 16/9).
#let _disco(v, G, k) = cilindro3(v, G, k, 1.05, 0.55)
#let fig-p4 = esquema(escala: 0.95cm, _libre(16 / 9, 24, _disco))

// Problema 5: cinco esferas en un plano, I = 2 I'.
#let _cinco(v, G, k) = {
  let a = unit3(cruz3(k, (0, 1, 0)))
  let b = (0, 1, 0)
  let pts = (esc3(1.45, a), esc3(-1.45, a), esc3(1.45, b), esc3(-1.45, b))
  // las de atras primero
  let orden = pts.sorted(key: p => prof3(v, p))
  for p in orden.slice(0, 2) {
    linea3(v, (G, p), grosor: 1.6pt, color: luma(110))
    esfera3(v, p, 0.3)
  }
  esfera3(v, G, 0.36)
  for p in orden.slice(2) {
    linea3(v, (G, p), grosor: 1.6pt, color: luma(110))
    esfera3(v, p, 0.3)
  }
}
#let fig-p5 = esquema(escala: 0.95cm, _libre(2, 20, _cinco))

// Problema 6: el tubo de paredes delgadas, corto (l/r = 1,2) y largo (l/r = 4,8).
#let _tubo-corto(v, G, k) = cilindro3(v, G, k, 1.0, 1.2, tapa: white)
#let _tubo-largo(v, G, k) = cilindro3(v, G, k, 0.5, 2.4, tapa: white)
#let fig-p6 = paneles(
  ([a) corto, $ell \/ r = 1,2 < sqrt(6)$], esquema(escala: 0.8cm, _libre(1 / (0.5 + 1.44 / 12), 24, _tubo-corto))),
  ([b) largo, $ell \/ r = 4,8 > sqrt(6)$], esquema(escala: 0.8cm, _libre(0.25 / (0.125 + 2.4 * 2.4 / 12), 24, _tubo-largo, largo-eje: 2.9))),
)

// ---------------------------------------------------------------------
// La capsula de los Problemas 7 y 8: tronco de cono con la base de radio 2 a
// z = -1,25 y la tapa de radio 1,25 a z = 2 (las cotas de la figura). Mundo =
// ejes del cuerpo, z arriba; la camara mira casi desde +x.
// ---------------------------------------------------------------------
#let _vcap = vista3d(az: -25, el: 14)
#let _capsula(v) = {
  let Z = (0, 0, 1)
  let base = circulo3-pts((0, 0, -1.25), Z, 2.0)
  let tapa = circulo3-pts((0, 0, 2.0), Z, 1.25)
  let casco = envolvente((base + tapa).map(p => p3(v, p)))
  cetz.draw.line(..casco, close: true, fill: luma(235), stroke: 0.7pt + c-trazo)
  cetz.draw.line(..tapa.map(p => p3(v, p)), close: true, fill: luma(246), stroke: 0.7pt + c-trazo)
  linea3(v, base, color: c-guia, grosor: 0.5pt, punteada: true)
  masa3(v, (0, 0, 0), radio: 0.05)
  rotulo3(v, (0, 0, 0), [$G$], ancla: "north-east")
}
#let _ejes-cap(v) = {
  flecha3(v, (0, 0, 2.05), (0, 0, 3.0), etiqueta: $z$, color: luma(80), lado: "west", pos: 100%)
  flecha3(v, (0, 2.05, 0), (0, 2.9, 0), etiqueta: $y$, color: luma(80), lado: "west", pos: 100%)
  flecha3(v, (2.0, 0, 0), (3.1, 0, 0), etiqueta: $x$, color: luma(80), lado: "north", pos: 100%)
}

// Problema 7: cohete A en (0; 2; -1,25), 50 N·s sobre +x; H_G = (0; -62,5;
// -100) y omega = (0; -0,0625; -0,064): los dos hacia -y y -z, H mas cerca
// del eje (-z) que omega: theta = 32 grados, gamma = 44,3, retrograda.
#let fig-p7 = esquema(escala: 0.95cm, {
  let v = _vcap
  let G = (0, 0, 0)
  _capsula(v)
  _ejes-cap(v)
  let A = (0, 2.0, -1.25)
  masa3(v, A, radio: 0.07, color: c-rojo)
  rotulo3(v, A, text(fill: c-rojo)[$A$], ancla: "south-west")
  flecha3(v, G, A, color: c-aux, punteada: true)
  rotulo3(v, esc3(0.55, A), text(fill: c-aux)[$bold(r)_A$], ancla: "south")
  flecha3(v, A, suma3(A, (1.5, 0, 0)), color: c-rojo, grosor: 1.1pt)
  rotulo3(v, suma3(A, (1.5, 0, 0)), text(fill: c-rojo)[$bold(J)$], ancla: "west")
  // -z de referencia
  linea3(v, (G, (0, 0, -2.6)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (0, 0, -2.65), text(fill: luma(80))[$-z$], ancla: "north-west")
  let hu = unit3((0, -62.5, -100))
  let wu = unit3((0, -0.0625, -0.0640))
  flecha3(v, G, esc3(3.2, hu), color: c-verde, grosor: 1.2pt)
  rotulo3(v, esc3(3.25, hu), text(fill: c-verde)[$bold(H)_G$], ancla: "north")
  flecha3(v, G, esc3(2.9, wu), color: c-dato, grosor: 1.1pt)
  rotulo3(v, esc3(2.95, wu), text(fill: c-dato)[$bold(omega)$], ancla: "south-east")
  // theta y gamma, desde -z, girando hacia -y (eje -x)
  linea3(v, arco3-pts(G, (-1, 0, 0), (0, 0, -1), 1.2, 32.0), color: luma(40), grosor: 0.7pt)
  rotulo3(v, esc3(1.38, unit3((0, -0.27, -0.96))), [$theta$], ancla: "north-west")
  linea3(v, arco3-pts(G, (-1, 0, 0), (0, 0, -1), 1.75, 44.3), color: c-dato, grosor: 0.7pt)
  rotulo3(v, esc3(1.95, unit3((0, -0.38, -0.92))), text(fill: c-dato)[$gamma$], ancla: "north-west")
  // precesion alrededor de H_G y spin al reves
  giro3(v, esc3(2.25, hu), hu, (1, 0, 0), 0.32, 290, color: c-verde)
  rotulo3(v, suma3(esc3(2.25, hu), (0, -0.45, 0.1)), text(fill: c-verde)[$dot(phi)$], ancla: "east")
  giro3(v, (0, 0, 2.55), (0, 0, -1), (1, 0, 0), 0.32, 290, color: c-aux)
  rotulo3(v, (0, -0.45, 2.55), text(fill: c-aux)[$dot(psi) < 0$], ancla: "east")
})

// Problema 8: cohete B en (0; 1,25; 2); H_0 = (0; 20; 156,25), Delta H =
// (0; 100; -62,5) y H_G = H_0 + Delta H = (0; 120; 93,75); omega = (0; 0,12;
// 0,06). Escala de H: 0,012 por kg·m²/s.
#let fig-p8 = esquema(escala: 1.05cm, {
  let v = _vcap
  let G = (0, 0, 0)
  _capsula(v)
  _ejes-cap(v)
  let B = (0, 1.25, 2.0)
  masa3(v, B, radio: 0.07, color: c-rojo)
  rotulo3(v, B, text(fill: c-rojo)[$B$], ancla: "south-west")
  flecha3(v, B, suma3(B, (1.1, 0, 0)), color: c-rojo, grosor: 1.1pt)
  rotulo3(v, suma3(B, (1.1, 0, 0)), text(fill: c-rojo)[$bold(J)$], ancla: "north-west")
  let s = 0.0155
  let H0 = (0, 20 * s, 156.25 * s)
  let H = (0, 120 * s, 93.75 * s)
  flecha3(v, G, H0, color: c-guia, grosor: 1.0pt)
  rotulo3(v, H0, text(fill: luma(70))[$bold(H)_0$], ancla: "east")
  flecha3(v, H0, H, color: c-rojo, punteada: true)
  rotulo3(v, suma3(esc3(0.6, H0), esc3(0.4, H)), text(fill: c-rojo)[$Delta bold(H)$], ancla: "north-east")
  flecha3(v, G, H, color: c-verde, grosor: 1.2pt)
  rotulo3(v, H, text(fill: c-verde)[$bold(H)_G$], ancla: "south")
  let wu = unit3((0, 0.12, 0.06))
  flecha3(v, G, esc3(3.1, wu), color: c-dato, grosor: 1.1pt)
  rotulo3(v, esc3(3.15, wu), text(fill: c-dato)[$bold(omega)$], ancla: "west")
  linea3(v, arco3-pts(G, (-1, 0, 0), (0, 0, 1), 0.95, 52.0), color: luma(40), grosor: 0.7pt)
  rotulo3(v, esc3(0.75, unit3((0, 0.45, 0.89))), [$theta$], ancla: "center")
  linea3(v, arco3-pts(G, (-1, 0, 0), (0, 0, 1), 1.55, 63.4), color: c-dato, grosor: 0.7pt)
  rotulo3(v, esc3(1.3, unit3((0, 0.5, 0.86))), text(fill: c-dato)[$gamma$], ancla: "center")
})

// ---------------------------------------------------------------------
// Problema 9: el octogono. Eje de simetria = y del cuerpo, que en el dibujo
// va para arriba: w(x, y, z) = (x, -z, y) es una rotacion (derecha). La cara
// entre A y B mira hacia +z del cuerpo (hacia el lector).
// ---------------------------------------------------------------------
#let _w(p) = (p.at(0), -p.at(2), p.at(1))
#let fig-p9 = esquema(escala: 0.85cm, {
  let v = vista3d(az: -72, el: 20)
  let G = (0, 0, 0)
  let R = 1.2 / (2 * calc.sin(22.5deg))
  let vert(y) = range(8).map(i => _w((R * calc.cos((22.5 + 45 * i) * 1deg), y, R * calc.sin((22.5 + 45 * i) * 1deg))))
  let arr = vert(1.2)
  let aba = vert(-1.2)
  let casco = envolvente((arr + aba).map(p => p3(v, p)))
  cetz.draw.line(..casco, close: true, fill: luma(236), stroke: 0.7pt + c-trazo)
  let dc = prof3(v, G)
  for i in range(8) {
    let j = calc.rem(i + 1, 8)
    let atras = prof3(v, esc3(0.5, suma3(aba.at(i), aba.at(j)))) < dc - 0.2
    linea3(v, (aba.at(i), aba.at(j)), grosor: 0.5pt, punteada: atras)
    linea3(v, (aba.at(i), arr.at(i)), grosor: 0.5pt, punteada: prof3(v, aba.at(i)) < dc - 0.4)
  }
  cetz.draw.line(..arr.map(p => p3(v, p)), close: true, fill: luma(246), stroke: 0.7pt + c-trazo)
  masa3(v, G, radio: 0.05)
  rotulo3(v, G, [$G$], ancla: "north-east")
  // ejes del cuerpo
  flecha3(v, _w((0, 1.25, 0)), _w((0, 3.3, 0)), etiqueta: [$y$ (eje)], color: luma(80), lado: "east", pos: 100%)
  flecha3(v, _w((R, 0, 0)), _w((R + 1.0, 0, 0)), etiqueta: $x$, color: luma(80), lado: "west", pos: 100%)
  flecha3(v, _w((0, -1.2, 1.45)), _w((0, -1.2, 2.5)), etiqueta: $z$, color: luma(80), lado: "east", pos: 100%)
  // spin inicial omega_0 sobre y
  giro3(v, _w((0, 2.7, 0)), _w((0, 1, 0)), _w((1, 0, 0)), 0.32, 290, color: c-aux)
  rotulo3(v, _w((-0.45, 2.7, 0)), text(fill: c-aux)[$omega_0$ antes], ancla: "east")
  // los propulsores: el gas sube, al satelite lo empuja -J j
  let A = _w((-0.6, 1.2, 1.449))
  let B = _w((0.6, 1.2, 1.449))
  for (P, nom, an) in ((A, [$A$], "north-east"), (B, [$B$], "north-west")) {
    masa3(v, P, radio: 0.07, color: c-rojo)
    rotulo3(v, P, text(fill: c-rojo, nom), ancla: an)
    flecha3(v, P, suma3(P, (0, 0, 0.55)), color: c-guia, punteada: true)
    flecha3(v, P, suma3(P, (0, 0, -0.85)), color: c-rojo, grosor: 1.1pt)
  }
  rotulo3(v, suma3(A, (0, 0, 0.6)), text(fill: luma(80), size: 7.5pt)[gas hacia $+y$], ancla: "south-east")
  rotulo3(v, suma3(A, (0, 0, -0.9)), text(fill: c-rojo)[$-J hat(j)$], ancla: "east")
  // H y omega despues, en el plano x y
  let hu = _w(unit3((115.9, 150.8, 0)))
  let wu = _w(unit3((0.0579, 0.0628, 0)))
  flecha3(v, G, esc3(3.3, hu), color: c-verde, grosor: 1.2pt)
  rotulo3(v, esc3(3.35, hu), text(fill: c-verde)[$bold(H)$], ancla: "south-west")
  flecha3(v, G, esc3(3.6, wu), color: c-dato, grosor: 1.1pt)
  rotulo3(v, esc3(3.65, wu), text(fill: c-dato)[$bold(omega)$], ancla: "west")
  // theta y gamma desde y, hacia +x
  let ny = _w((0, 0, -1))
  let sy = _w((0, 1, 0))
  linea3(v, arco3-pts(G, ny, sy, 2.65, 37.5), color: luma(40), grosor: 0.7pt)
  rotulo3(v, esc3(2.85, _w(unit3((0.32, 0.95, 0)))), [$theta$], ancla: "south")
  linea3(v, arco3-pts(G, ny, sy, 3.05, 42.7), color: c-dato, grosor: 0.7pt)
  rotulo3(v, esc3(3.2, _w(unit3((0.52, 0.85, 0)))), text(fill: c-dato)[$gamma$], ancla: "west")
})

// ---------------------------------------------------------------------
// Adicional 1: los brazos telescopicos, vistos desde arriba (z sale de la
// hoja, la nave gira antihorario). Cada modulo que se aleja a r' necesita
// una fuerza de costado 2 m r' omega_0 hacia donde gira; el par de los
// propulsores (en +-1,1 m) es el que la pone.
// ---------------------------------------------------------------------
#let _arco-giro(c, r, ini, fin, color) = cetz.draw.arc(c, start: ini * 1deg, stop: fin * 1deg, radius: r,
  anchor: "origin", stroke: 0.8pt + color, mark: (end: "stealth", scale: 0.45, fill: color))
#let fig-ad1 = esquema(escala: 0.85cm, {
  let O = (0, 0)
  cetz.draw.circle(O, radius: 1.1, fill: luma(235), stroke: 0.7pt + c-trazo)
  masa((0, 0), radio: 0.05)
  rotulo((0.12, -0.12), [$G$, $z$ ⊙], ancla: "north-west")
  let r = 3.1
  cetz.draw.line((-r, 0), (-1.1, 0), stroke: 1.4pt + luma(120))
  cetz.draw.line((1.1, 0), (r, 0), stroke: 1.4pt + luma(120))
  for s in (1, -1) {
    let P = (s * r, 0)
    cetz.draw.circle(P, radius: 0.28, fill: luma(150), stroke: 0.5pt + luma(60))
    flecha((s * (r + 0.35), 0), (s * (r + 1.3), 0), color: c-aux)
    flecha((s * r, s * 0.35), (s * r, s * 1.55), color: c-ambar, grosor: 1.1pt)
  }
  rotulo((r + 1.3, 0), text(fill: c-aux)[$dot(r)$], ancla: "west")
  rotulo((-r - 1.3, 0), text(fill: c-aux)[$dot(r)$], ancla: "east")
  rotulo((r, 1.55), text(fill: c-ambar)[$2 m dot(r) omega_0$], ancla: "south")
  rotulo((-r, -1.55), text(fill: c-ambar)[$2 m dot(r) omega_0$], ancla: "north")
  rotulo((r + 0.3, -0.35), [$m$], ancla: "north")
  rotulo((-r - 0.3, 0.35), [$m$], ancla: "south")
  auxiliar((1.1, -0.55), (r, -0.55), etiqueta: [$r(t)$], ancla: "north")
  // los propulsores, en +-1,1 m: el par
  flecha((0, 1.1), (-1.3, 1.1), color: c-rojo, grosor: 1.1pt)
  rotulo((-1.3, 1.1), text(fill: c-rojo)[$T$], ancla: "east")
  flecha((0, -1.1), (1.3, -1.1), color: c-rojo, grosor: 1.1pt)
  rotulo((1.3, -1.1), text(fill: c-rojo)[$T$], ancla: "west")
  // el giro
  _arco-giro(O, 0.65, 200, 470, c-verde)
  rotulo((-0.15, 0.62), text(fill: c-verde)[$omega_0$], ancla: "south-east")
  rotulo((0, -2.3), text(size: 7.5pt, fill: luma(60))[$M_z = 2 (1,1) T = dif H_z \/ dif t = 4 m r dot(r) omega_0$], ancla: "north")
})

// ---------------------------------------------------------------------
// Adicional 2: la rueda de reaccion, desde arriba (z sale de la hoja). El
// motor le pone M a la rueda (antihorario) y -M a la nave (horario): la rueda
// gira para un lado y la nave para el otro, con el H_z total en cero.
// ---------------------------------------------------------------------
#let fig-ad2 = esquema(escala: 0.85cm, {
  let O = (0, 0)
  cetz.draw.rect((-1.9, -1.9), (1.9, 1.9), fill: luma(238), stroke: 0.7pt + c-trazo)
  rotulo((-1.85, 1.85), text(size: 7.5pt)[nave: $I - I_R$], ancla: "north-west")
  cetz.draw.circle(O, radius: 0.75, fill: luma(200), stroke: 0.7pt + c-trazo)
  masa(O, radio: 0.05)
  rotulo((0.1, -0.1), text(size: 7.5pt)[$z$ ⊙], ancla: "north-west")
  rotulo((0, 0.78), text(size: 7.5pt)[rueda: $I_R$], ancla: "south")
  // la rueda: M y su giro relativo, antihorario
  _arco-giro(O, 1.05, -60, 210, c-dato)
  rotulo((0, -1.15), text(fill: c-dato)[$+M$ y $omega_"rel"$], ancla: "north")
  // la nave: -M, horario
  _arco-giro(O, 2.45, 120, -60, c-rojo)
  rotulo((2.55 * calc.cos(30deg), 2.55 * calc.sin(30deg)), text(fill: c-rojo)[$-M$ y $omega_"nave" < 0$], ancla: "west")
  rotulo((0, -2.75), text(size: 7.5pt, fill: luma(60))[$(I - I_R) omega_"nave" + I_R (omega_"nave" + omega_"rel") = 0$: el par es interno], ancla: "north")
})

// ---------------------------------------------------------------------
// Los dos conos del cuerpo simetrico libre (Beer 18.11, figs. 18.24-18.25),
// en seccion axial: H_G vertical, el eje a te de H, omega a ga del eje.
// Directa (alargado, ga < te): omega entre el eje y H; conos tangentes por
// afuera. Retrograda (achatado, ga > te): H entre el eje y omega; el cono
// espacial queda adentro del corporal. Angulos exagerados a proposito.
// ---------------------------------------------------------------------
#let _conos(te, ga) = {
  let O = (0, 0)
  let L = 3.0
  let pp = (ang, r) => (r * calc.cos(ang * 1deg), r * calc.sin(ang * 1deg))
  let dH = 90
  let dk = 90 - te
  let dw = dk + ga // omega, a ga del eje, del lado de H
  let se = calc.abs(ga - te)
  let cono(eje, semi, color) = {
    cetz.draw.line(pp(eje - semi, L), O, pp(eje + semi, L), stroke: 0.7pt + color)
    circulo-escorzo(pp(eje, L * calc.cos(semi * 1deg)), L * calc.sin(semi * 1deg),
      dir: eje - 90, achatado: 0.30, color: color, grosor: 0.7pt, punteada: false)
  }
  cono(dk, ga, c-trazo)
  cono(dH, se, c-aux)
  cetz.draw.line(O, pp(dk, L + 0.55), stroke: (paint: luma(70), thickness: 0.6pt, dash: "dashed"))
  rotulo(pp(dk, L + 0.6), text(fill: luma(70))[eje ($C C'$)], ancla: "south-west")
  flecha(O, pp(dH, L + 0.75), color: c-verde)
  rotulo(pp(dH, L + 0.8), text(fill: c-verde)[$bold(H)_G$ fijo ($A A'$)], ancla: "south")
  flecha(O, pp(dw, L * 0.92), color: c-dato)
  rotulo(pp(dw, L * 0.92), text(fill: c-dato)[$bold(omega)$], ancla: "south-west")
  rotulo(pp(dH + se + 6, L * 0.62), text(fill: c-aux)[espacial], ancla: "east")
  rotulo(pp(dk - ga - 4, L * 0.7), text(fill: c-trazo)[corporal], ancla: "west")
  rotulo((0, -0.08), [$G$], ancla: "north")
}
#let fig-conos-libre = paneles(
  ([*Directa*: alargado, $I < I'$, $gamma < theta$], esquema(escala: 0.75cm, _conos(42, 20))),
  ([*Retrógrada*: achatado, $I > I'$, $gamma > theta$], esquema(escala: 0.75cm, _conos(22, 44))),
)
