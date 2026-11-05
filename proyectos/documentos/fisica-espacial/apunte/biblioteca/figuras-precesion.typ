// =====================================================================
//  figuras-precesion.typ -- dos figuras del cap. 18 del Beer que usan el
//  apunte (modulos `peonza` y `euler-giroscopo`) y la guia del parcialito 5
//  de practica/. Viven aca, en la biblioteca del apunte, porque el apunte no
//  puede importar de practica/ (su raiz es apunte/) y practica/ si importa de
//  aca: una sola fuente, sin copias que diverjan. Se mudaron de
//  practica/figuras-cr3d.typ el 2026-11-05 (fase 18), sin cambiarles un trazo.
//
//  OJO (trampa 10 del HANDOFF): ninguna variable local se llama como una
//  letra griega: Typst resolveria $theta$ contra el numero. Van fi, te, be.
// =====================================================================
#import "estilo.typ": *
#import "estilo.typ" as est

// Rotulos con HALO en una capa de arriba, como en practica/figuras-cr3d.typ
// (lo mide practica/verificar-figuras.py). Pisan al rotulo de estilo.typ
// solo adentro de este archivo.
#let rotulo(pos, cuerpo, ..args) = cetz.draw.on-layer(2,
  est.rotulo(pos, box(fill: white, inset: (x: 1.2pt, y: 0.8pt), cuerpo), ..args))

#let _p2(r, ang) = (r * calc.cos(ang * 1deg), r * calc.sin(ang * 1deg))

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
