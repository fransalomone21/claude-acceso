// =====================================================================
//  figuras-omega.typ -- las velocidades angulares, los momentos angulares
//  y sus derivadas, dibujados (2026-11-11, pedido de Fran: «quiero ver los
//  omegas, los momentos angulares y sus derivadas», del módulo 20 en
//  adelante). Las usan `euler-giroscopo`, `peonza` y `actitud`.
//  Rótulos con HALO y en capa de arriba, como figuras-euler.typ; los mide
//  practica/verificar-figuras.py sobre practica/galeria-omega.typ.
//
//  OJO: ninguna variable local se llama como una letra griega (th, ph, ps).
//  Cada sentido sale de una cuenta escrita al lado (lección del 2026-11-10:
//  el verificador de rótulos no mira sentidos).
//
//  Mapeo de los ejes de la horquilla y del gimbal (m20, Problemas 2 y 3):
//    j (vertical, plataforma u horquilla) -> Z de la hoja
//    k (eje del disco o del volante)      -> X de la hoja
//    i = j x k                            -> Y de la hoja
//  (i, j, k) = (Y, Z, X) es derecha: Y x Z = X.
// =====================================================================
#import "estilo.typ": *
#import "estilo.typ" as est
#import "perspectiva.typ": *

#let rotulo(pos, cuerpo, ..args) = cetz.draw.on-layer(2,
  est.rotulo(pos, box(fill: white, inset: (x: 1.2pt, y: 0.8pt), cuerpo), ..args))
#let rotulo3(v, p, cuerpo, ..args) = rotulo(p3(v, p), cuerpo, ..args)
#let _O = (0, 0, 0)
#let _Z = (0, 0, 1)
#let _leyenda(cuerpo) = align(center, block(width: 13cm, above: 4pt, {
  set text(size: 7.5pt)
  set par(justify: false)
  cuerpo
}))
// az = 104: el eje k (X) queda casi en el plano de la hoja, hacia la
// izquierda, e i (Y) viene hacia el lector. Con H = 2k + j, la proyección de
// H queda perpendicular a la de i (cos az = -tan(el)/2): la derivada no se
// dibuja encimada sobre H.
#let _vista = vista3d(az: 104, el: 26)
#let _disco(v, R, alto: 0.16) = cilindro3(v, _O, (1, 0, 0), R, alto,
  relleno: c-dato.lighten(70%).transparentize(35%), tapa: c-dato.lighten(84%).transparentize(35%))

// ---------------------------------------------------------------------
// 1. El teorema del transporte sobre H: en dt, la punta de H se mueve por
// dos razones. Omega = Omega Z; H = (0,3; 1,55; 1,6):
//   Omega x H = Z x (0,3; 1,55; 1,6) = (-1,55; 0,3; 0): tangente al círculo.
// ---------------------------------------------------------------------
#let fig-omega-transporte = esquema(escala: 1.2cm, {
  let v = vista3d(az: 35, el: 30)
  let Hh = (0.3, 1.55, 0)
  let H = (0.3, 1.55, 1.6)
  let tr = esc3(0.95, (-1.55, 0.3, 0))
  let rel = (0.12, 0.45, 0.7)
  let P1 = suma3(H, tr)
  let P2 = suma3(P1, rel)
  let rr = calc.sqrt(prod3(Hh, Hh))
  flecha3(v, _O, (0, 0, 3.0), color: c-verde, grosor: 1.1pt)
  rotulo3(v, (0, 0, 3.0), text(fill: c-verde)[$bold(Omega)$: cómo giran los ejes], ancla: "south")
  giro3(v, (0, 0, 2.6), _Z, (1, 0, 0), 0.32, 290, color: c-verde)
  linea3(v, circulo3-pts((0, 0, 1.6), _Z, rr), color: c-guia, grosor: 0.5pt, punteada: true)
  linea3(v, ((0, 0, 1.6), H), color: c-guia, grosor: 0.4pt, punteada: true)
  flecha3(v, _O, H, color: c-aux, grosor: 1.3pt)
  rotulo3(v, esc3(0.5, H), text(fill: c-aux)[$bold(H)(t)$], ancla: "west")
  flecha3(v, H, P1, color: c-rojo, grosor: 1.1pt)
  rotulo3(v, suma3(H, esc3(0.5, tr)), text(fill: c-rojo)[$bold(Omega) times bold(H) thin dif t$], ancla: "north-east")
  flecha3(v, P1, P2, color: c-ambar, grosor: 1.1pt)
  rotulo3(v, suma3(P1, esc3(0.5, rel)), text(fill: c-ambar)[$(dif bold(H))_"rel"$], ancla: "east")
  flecha3(v, H, P2, color: c-dato, grosor: 0.8pt, punteada: true)
  flecha3(v, _O, P2, color: c-aux.lighten(40%), grosor: 0.8pt)
  rotulo3(v, P2, text(fill: c-aux)[$bold(H)(t + dif t)$], ancla: "south")
  masa3(v, _O, radio: 0.05)
  rotulo3(v, _O, [$G$], ancla: "north-east")
})
#let fig-omega-transporte-completa = block({
  fig-omega-transporte
  _leyenda[
    #text(fill: c-ambar)[*ámbar*: lo que cambia $bold(H)$ visto desde los ejes (sus componentes)] \
    #text(fill: c-rojo)[*rojo*: lo que lo cambia que los ejes giren, aunque las componentes no se muevan] \
    #text(fill: c-dato)[*punteado*: la suma, $dif bold(H)$ respecto del espacio, que es $sum bold(M)_G thin dif t$]
  ]
})

// ---------------------------------------------------------------------
// 2. Pelota y libro, en dos ejes principales: H = I omega componente a
// componente. omega = (wx; 0; wz) en (x, y, z). Hoja: x a la derecha, z
// arriba => y entra en la hoja.
//   omega x H = (0; (Ix - Iz) wx wz; 0): con Iz > Ix apunta a -y = SALE.
// ---------------------------------------------------------------------
#let _par-wh(rel) = {
  let O = (0, 0)
  let w = (1.9, 1.9)
  let H = (1.9 * 0.85, 1.9 * 0.85 * rel)
  cetz.draw.line(O, (3.0, 0), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  rotulo((3.0, 0), text(fill: luma(80))[$x$], ancla: "west")
  cetz.draw.line(O, (0, 3.3), stroke: (paint: c-guia, thickness: 0.6pt, dash: "dashed"))
  rotulo((0, 3.3), text(fill: luma(80))[$z$], ancla: "south")
  flecha(O, w, color: c-dato, grosor: 1.3pt)
  rotulo(w, text(fill: c-dato)[$bold(omega)$], ancla: "west")
  flecha(O, H, color: c-aux, grosor: 1.3pt)
  rotulo(H, text(fill: c-aux)[$bold(H)_G$], ancla: if rel > 1 { "south" } else { "north-west" })
  auxiliar(H, (H.at(0), 0))
  auxiliar(H, (0, H.at(1)))
  rotulo((H.at(0), 0), text(fill: c-aux)[$I_x omega_x$], ancla: "north")
  rotulo((0, H.at(1)), text(fill: c-aux)[$I_z omega_z$], ancla: "east")
  cetz.draw.circle(O, radius: 0.13, stroke: 0.7pt + luma(90), fill: white)
  cetz.draw.line((-0.09, -0.09), (0.09, 0.09), stroke: 0.7pt + luma(90))
  cetz.draw.line((-0.09, 0.09), (0.09, -0.09), stroke: 0.7pt + luma(90))
  rotulo((-0.12, -0.12), text(fill: luma(80))[$y$ entra], ancla: "north-east")
  if rel > 1 {
    let P = (2.75, 1.35)
    cetz.draw.circle(P, radius: 0.16, stroke: 0.9pt + c-rojo, fill: white)
    cetz.draw.circle(P, radius: 0.045, fill: c-rojo, stroke: none)
    rotulo((2.97, 1.35), text(fill: c-rojo)[$bold(omega) times bold(H)_G$ sale:\ $(I_x - I_z) omega_x omega_z$ sobre $hat(j)$], ancla: "west")
  } else {
    rotulo((1.0, 2.75), text(fill: c-rojo)[$bold(omega) times bold(H)_G = 0$], ancla: "west")
  }
}
#let fig-omega-pelota-libro = paneles(
  ([pelota: $I_x = I_z$], esquema(escala: 0.85cm, _par-wh(1.0))),
  ([libro: $I_z = 2 I_x$], esquema(escala: 0.85cm, _par-wh(2.0))),
)

// ---------------------------------------------------------------------
// 3. El disco en la horquilla (m20, Problema 2): omega1 sobre k (el disco),
// omega2 sobre j (la horquilla), H_G = 1/4 m r^2 omega2 j + 1/2 m r^2
// omega1 k, que no es paralelo a omega. Dibujo con omega1 = omega2.
//   Omega x H = omega2 j x (1/2 m r^2 omega1 k) = 1/2 m r^2 omega1 omega2 i
//   (j x k = i)  -> +Y de la hoja.
// ---------------------------------------------------------------------
#let fig-omega-horquilla = esquema(escala: 1.05cm, {
  let v = _vista
  // la horquilla: el eje vertical y los dos brazos que sostienen el disco
  linea3(v, ((0, 0, 0.95), (0, 0, 1.9)), grosor: 1.8pt)
  linea3(v, ((-0.35, 0, 0.95), (0.35, 0, 0.95)), grosor: 1.6pt)
  linea3(v, ((-0.35, 0, 0.95), (-0.35, 0, 0)), grosor: 1.6pt)
  linea3(v, ((0.35, 0, 0.95), (0.35, 0, 0)), grosor: 1.6pt)
  _disco(v, 0.6)
  let w1 = (2.4, 0, 0)
  let w2 = (0, 0, 2.4)
  flecha3(v, _O, w1, color: c-dato, grosor: 1.1pt)
  rotulo3(v, w1, text(fill: c-dato)[$omega_1 hat(k)$ (el disco)], ancla: "north-east")
  flecha3(v, (0, 0, 1.9), (0, 0, 2.9), color: c-verde, grosor: 1.1pt)
  rotulo3(v, (0, 0, 2.9), text(fill: c-verde)[$bold(Omega) = omega_2 hat(j)$ (la horquilla)], ancla: "south")
  giro3(v, (0, 0, 2.45), _Z, (1, 0, 0), 0.3, 290, color: c-verde)
  flecha3(v, _O, suma3(w1, w2), color: c-dato, grosor: 0.8pt, punteada: true)
  rotulo3(v, suma3(w1, w2), text(fill: c-dato)[$bold(omega)$], ancla: "south-east")
  // H_G: con omega1 = omega2, componentes 2 : 1 (k : j)
  let H = (2.8, 0, 1.4)
  flecha3(v, _O, H, color: c-aux, grosor: 1.3pt)
  rotulo3(v, H, text(fill: c-aux)[$bold(H)_G$], ancla: "east")
  linea3(v, circulo3-pts((0, 0, 1.4), _Z, 2.8), color: c-guia, grosor: 0.4pt, punteada: true)
  // la derivada, sobre +i (Y de la hoja), desde la punta de H
  let dH = (0, 1.6, 0)
  flecha3(v, H, suma3(H, dH), color: c-rojo, grosor: 1.2pt)
  rotulo3(v, suma3(H, dH), text(fill: c-rojo)[$dot(bold(H))_G = bold(Omega) times bold(H)_G$, sobre $hat(i)$], ancla: "north")
  linea3(v, (_O, (0, 2.0, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (0, 2.0, 0), text(fill: luma(80))[$hat(i)$], ancla: "north")
})
#let fig-omega-horquilla-completa = block({
  fig-omega-horquilla
  _leyenda[
    Con $omega_1 = omega_2$, $bold(omega)$ va a $45 degree$ pero $bold(H)_G$ no: la componente sobre el
    disco pesa el doble ($1/2 m r^2$ contra $1/4 m r^2$). El círculo punteado es el que barre la punta
    de $bold(H)_G$ arrastrada por la horquilla; $dot(bold(H))_G$ es su tangente, sobre $hat(i)$.
  ]
})

// ---------------------------------------------------------------------
// 4. Tres observadores, el mismo H_G (la tabla de la cátedra). Sentidos:
//   horquilla: (dH)_rel = 0; todo es Omega x H, sobre +i.
//   disco: H gira con -omega1 k: (-omega1 k) x (Hj j) = +omega1 Hj i.
//   inercial: H gira con +omega2 j: (omega2 j) x (Hk k) = +omega2 Hk i.
//   Los tres apuntan a +i: la derivada es la misma, repartida distinto.
// ---------------------------------------------------------------------
#let _observador(cual) = {
  let v = _vista
  let H = (2.0, 0, 1.0)
  let tip = suma3(H, (0, 2.2, 0))
  _disco(v, 0.42, alto: 0.12)
  linea3(v, (_O, (3.0, 0, 0)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (3.0, 0, 0), text(fill: luma(80))[$hat(k)$], ancla: "south-east")
  linea3(v, (_O, (0, 0, 2.1)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (0, 0, 2.1), text(fill: luma(80))[$hat(j)$], ancla: "south")
  flecha3(v, _O, H, color: c-aux, grosor: 1.3pt)
  rotulo3(v, H, text(fill: c-aux)[$bold(H)_G$], ancla: "east")
  if cual == "horquilla" {
    flecha3(v, H, tip, color: c-rojo, grosor: 1.0pt, punteada: true)
    rotulo3(v, tip, text(fill: c-rojo)[todo, transporte], ancla: "north")
    rotulo3(v, (0, 0, -0.75), text(size: 7.5pt)[la ve quieta], ancla: "north")
  } else if cual == "disco" {
    linea3(v, circulo3-pts((2.0, 0, 0), (1, 0, 0), 1.0), color: c-ambar, grosor: 0.6pt, punteada: true)
    giro3(v, (2.5, 0, 0), (-1, 0, 0), (0, 0, 1), 0.28, 290, color: c-ambar)
    flecha3(v, H, tip, color: c-ambar, grosor: 1.0pt)
    rotulo3(v, tip, text(fill: c-ambar)[la mitad], ancla: "north")
    rotulo3(v, (0, 0, -0.75), text(size: 7.5pt)[cono alrededor de $hat(k)$, con $-omega_1$], ancla: "north")
  } else {
    linea3(v, circulo3-pts((0, 0, 1.0), _Z, 2.0), color: c-ambar, grosor: 0.6pt, punteada: true)
    giro3(v, (0, 0, 1.7), _Z, (1, 0, 0), 0.28, 290, color: c-ambar)
    flecha3(v, H, tip, color: c-ambar, grosor: 1.0pt)
    rotulo3(v, tip, text(fill: c-ambar)[todo], ancla: "north")
    rotulo3(v, (0, 0, -0.75), text(size: 7.5pt)[cono alrededor de $hat(j)$, con $+omega_2$], ancla: "north")
  }
}
#let fig-omega-observadores = block({
  paneles(
    ("desde la horquilla", esquema(escala: 0.7cm, _observador("horquilla"))),
    ("desde el disco", esquema(escala: 0.7cm, _observador("disco"))),
    ("desde afuera", esquema(escala: 0.7cm, _observador("inercial"))),
    sep: 8pt,
  )
  _leyenda[
    #text(fill: c-ambar)[*ámbar*: lo que cada observador ve moverse a $bold(H)_G$ (la derivada relativa)];
    #text(fill: c-rojo)[*rojo*: lo que pone el transporte]. Las tres flechas de la punta apuntan a
    $hat(i)$ y suman lo mismo, $1/2 m r^2 omega_1 omega_2$: cambia el reparto, no la derivada.
  ]
})

// ---------------------------------------------------------------------
// 5. El volante en el gimbal (m20, Problema 3): H_O casi sobre k, la
// plataforma sobre j, y los 600 N m del torquer sobre i repartidos.
//   Omega x H = omega_p j x I_z omega_s k = omega_p I_z omega_s i = +500 i.
// ---------------------------------------------------------------------
#let _gimbal3d = {
  let v = _vista
  linea3(v, circulo3-pts(_O, (0, 1, 0), 1.0), color: c-verde, grosor: 1.8pt)
  linea3(v, ((0, 0, 1.0), (0, 0, 2.0)), grosor: 1.6pt)
  _disco(v, 0.75, alto: 0.24)
  linea3(v, ((0, -1.5, 0), (0, -1.0, 0)), grosor: 2.0pt)
  linea3(v, ((0, 1.0, 0), (0, 1.5, 0)), grosor: 2.0pt)
  rotulo3(v, (0, -1.5, 0), text(fill: luma(80), size: 7.5pt)[pivote del gimbal ($hat(i)$)], ancla: "south-west")
  // el spin, como giro alrededor de k
  giro3(v, (1.0, 0, 0), (1, 0, 0), (0, 0, 1), 0.4, 290, color: c-dato)
  rotulo3(v, (1.0, 0, -0.45), text(fill: c-dato)[$omega_s$], ancla: "north")
  flecha3(v, (0, 0, 2.0), (0, 0, 2.8), color: c-verde, grosor: 1.1pt)
  rotulo3(v, (0, 0, 2.8), text(fill: c-verde)[$omega_p hat(j)$ (plataforma)], ancla: "south")
  giro3(v, (0, 0, 2.4), _Z, (1, 0, 0), 0.3, 290, color: c-verde)
  // H_O: 1000 sobre k y 2,5 sobre j (j exagerado para que se vea)
  let H = (3.0, 0, 0.3)
  flecha3(v, _O, H, color: c-aux, grosor: 1.4pt)
  rotulo3(v, H, text(fill: c-aux)[$bold(H)_O approx I_z omega_s hat(k)$], ancla: "north-east")
  // sobre +i: el torquer y lo que se lleva el transporte (500 de 600)
  flecha3(v, (0, 1.5, 0.25), (0, 4.0, 0.25), color: c-rojo, grosor: 1.3pt)
  rotulo3(v, (0, 4.0, 0.25), text(fill: c-rojo)[$M_x = 600$ N·m (torquer)], ancla: "east")
  flecha3(v, (0, 1.5, -0.25), (0, 3.58, -0.25), color: c-ambar, grosor: 1.3pt)
  rotulo3(v, (0, 3.58, -0.25), text(fill: c-ambar)[$bold(Omega) times bold(H)_O = omega_p I_z omega_s = 500$], ancla: "north-west")
}
#let _barra-gimbal = {
  let u = 0.0105
  cetz.draw.rect((0, 0.9), (600 * u, 1.35), fill: c-rojo.lighten(60%), stroke: 0.6pt + c-rojo)
  rotulo((600 * u + 0.1, 1.12), text(fill: c-rojo)[aplicado: $600$], ancla: "west")
  cetz.draw.rect((0, 0), (500 * u, 0.45), fill: c-ambar.lighten(60%), stroke: 0.6pt + c-ambar)
  cetz.draw.rect((500 * u, 0), (600 * u, 0.45), fill: c-dato.lighten(60%), stroke: 0.6pt + c-dato)
  rotulo((250 * u, 0.22), text(fill: luma(30))[$500$: acompañar a la plataforma], ancla: "center")
  rotulo((600 * u + 0.1, 0.22), text(fill: c-dato)[$100 = I_x dot(Omega)_x$], ancla: "west")
  rotulo((0, -0.15), text(size: 7.5pt, fill: luma(80))[N·m sobre $hat(i)$; $dot(Omega)_x = 100 \/ 5 = 20$ rad/s², no $600 \/ 5 = 120$], ancla: "north-west")
}
#let fig-omega-gimbal = block({
  esquema(escala: 0.72cm, _gimbal3d)
  v(4pt)
  esquema(escala: 0.85cm, _barra-gimbal)
})

// ---------------------------------------------------------------------
// 6. La velocidad angular del giróscopo como suma de tres giros, punta con
// cola (Beer §18.9; ANI-71): omega = phidot K + thetadot f + psidot k.
// La base (K, f, k) no es ortonormal: K y k forman theta.
// Convención de figuras-euler.typ: N = (cos ph, sin ph, 0),
// k = (sin th sin ph, -sin th cos ph, cos th).
// ---------------------------------------------------------------------
#let fig-omega-suma-euler = esquema(escala: 1.25cm, {
  let v = vista3d(az: 28, el: 22)
  let th = 40
  let ph = 55
  let N = (calc.cos(ph * 1deg), calc.sin(ph * 1deg), 0)
  let s = calc.sin(th * 1deg)
  let k = (s * calc.sin(ph * 1deg), -s * calc.cos(ph * 1deg), calc.cos(th * 1deg))
  let a = (0, 0, 1.3)
  let b = suma3(a, esc3(1.0, N))
  let c = suma3(b, esc3(1.8, k))
  linea3(v, (_O, (0, 0, 3.6)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, (0, 0, 3.6), [$Z$ ($bold(K)$, fijo)], ancla: "south")
  linea3(v, (esc3(-1.4, N), esc3(2.0, N)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, esc3(2.0, N), text(fill: luma(80))[línea de nodos ($hat(f)$)], ancla: "west")
  linea3(v, (_O, esc3(3.5, k)), color: c-guia, grosor: 0.5pt, punteada: true)
  rotulo3(v, esc3(3.5, k), text(fill: luma(80))[$z$ (eje del rotor, $hat(k)$)], ancla: "east")
  linea3(v, arco3-pts(_O, N, _Z, 3.0, th), color: luma(80), grosor: 0.7pt)
  rotulo3(v, esc3(3.15, unit3(suma3(_Z, k))), text(fill: luma(70))[$theta$], ancla: "south")
  flecha3(v, _O, a, color: c-verde, grosor: 1.4pt)
  rotulo3(v, esc3(0.5, a), text(fill: c-verde)[$dot(phi) bold(K)$], ancla: "west")
  flecha3(v, a, b, color: c-aux, grosor: 1.4pt)
  rotulo3(v, b, text(fill: c-aux)[$dot(theta) hat(f)$], ancla: "west")
  flecha3(v, b, c, color: c-dato, grosor: 1.4pt)
  rotulo3(v, suma3(b, esc3(1.3, k)), text(fill: c-dato)[$dot(psi) hat(k)$], ancla: "west")
  flecha3(v, _O, c, color: luma(20), grosor: 1.6pt)
  rotulo3(v, c, [$bold(omega)$], ancla: "south-east")
  masa3(v, _O, radio: 0.05)
  rotulo3(v, _O, [$O$], ancla: "north-east")
})
