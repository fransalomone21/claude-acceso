// =====================================================================
//  estilo.typ — base común de todas las figuras del apunte
//
//  Motor: CeTZ (dibujo vectorial) + cetz-plot (ejes y curvas). Los dos
//  corren dentro de Typst: no hace falta LaTeX ni ninguna herramienta
//  externa, y la figura vive en el fuente — se regenera y se corrige.
//
//  Lo que hay acá es el vocabulario que las figuras de FÍSICA necesitan
//  y que CeTZ no trae hecho: una flecha de vector rotulada, un arco de
//  ángulo, una masa puntual, un cuerpo central, una órbita cónica. Está
//  resuelto UNA vez y no figura por figura, porque cinco figuras que
//  inventan cada una su forma de dibujar un vector son cinco notaciones
//  distintas para la misma cosa.
// =====================================================================

#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": plot

#import "paleta.typ": *

// ---------- Constantes de trazo ----------
#let trazo-vector = 0.9pt // vectores
#let trazo-cuerpo = 0.7pt // contornos, cuerpos, ejes de figura
#let trazo-curva = 1.1pt // la curva protagonista de un gráfico
#let trazo-curva2 = 0.9pt // curvas secundarias
#let punteado = (paint: c-guia, thickness: 0.5pt, dash: "dashed")
#let punteado-dato = (paint: c-dato, thickness: 0.6pt, dash: "dashed")

// Tamaño de letra dentro de las figuras: más chico que el cuerpo (10,5 pt)
// para que las etiquetas no compitan con el dibujo.
#let letra-figura = 8.5pt

// ---------- Envoltorios de lienzo ----------
#let esquema(cuerpo, escala: 1cm) = align(center, {
  set text(size: letra-figura)
  cetz.canvas(length: escala, cuerpo)
})

#let grafico(cuerpo, escala: 1cm) = align(center, {
  set text(size: letra-figura)
  cetz.canvas(length: escala, cuerpo)
})

// ---------- Ejes estilo "libro de texto" ----------
// Se cruzan en el origen y terminan en punta de flecha. Los ticks se
// apagan por defecto: en una curva cualitativa una escala numérica miente
// más de lo que informa.
#let ejes-libro(cuerpo, tam: (7, 4.2), x-label: none, y-label: none, ..resto) = plot.plot(
  size: tam,
  axis-style: "school-book",
  x-label: x-label,
  y-label: y-label,
  x-tick-step: none,
  y-tick-step: none,
  x-grid: none,
  y-grid: none,
  ..resto,
  cuerpo,
)

// =====================================================================
//  El vocabulario de figuras de física
// =====================================================================

// ---------- Vector ----------
// La flecha rotulada. `lado` dice de qué lado del vector cae el nombre y
// `pos` a qué altura del vector: los dos se eligen a ojo mirando el render,
// no se calculan.
//
// `pos` existe porque el 55% por defecto es bueno para un vector largo y
// pésimo para uno corto: en un versor de largo 1 el nombre cae encima del
// vector vecino. Comprobado por render en la primera galería, con r̂ y θ̂
// pisándose. Para versores va 100% (el nombre en la punta).
#let flecha(
  desde,
  hasta,
  etiqueta: none,
  color: c-dato,
  lado: "north",
  pos: 55%,
  grosor: trazo-vector,
  punteada: false,
) = {
  let st = if punteada { (paint: color, thickness: grosor, dash: "dashed") } else { grosor + color }
  cetz.draw.line(desde, hasta, stroke: st, mark: (end: "stealth", scale: 0.45, fill: color))
  if etiqueta != none {
    cetz.draw.content(
      (desde, pos, hasta),
      text(size: letra-figura, fill: color, etiqueta),
      anchor: lado,
      padding: 4pt,
    )
  }
}

// ---------- Segmento auxiliar ----------
#let auxiliar(desde, hasta, etiqueta: none, ancla: "north", color: c-guia) = {
  cetz.draw.line(desde, hasta, stroke: (paint: color, thickness: 0.5pt, dash: "dashed"))
  if etiqueta != none {
    cetz.draw.content(
      (desde, 50%, hasta),
      text(size: letra-figura, fill: luma(80), etiqueta),
      anchor: ancla,
      padding: 3pt,
    )
  }
}

// ---------- Arco de ángulo ----------
// `centro` es el vértice; `ini` y `fin` son ángulos en grados, como NÚMEROS
// (42, no 42deg): en las figuras el mismo ángulo se usa para el arco y para
// calcular posiciones con calc.cos, y mezclar las dos formas obliga a
// escribir `42deg` en un lado y `42 * 1deg` en el otro. CeTZ sí quiere
// `angle` en `arc`, así que la conversión se hace acá adentro y una sola vez.
#let angulo(centro, ini, fin, etiqueta: none, radio: 0.55, color: luma(60)) = {
  cetz.draw.arc(
    centro,
    start: ini * 1deg,
    stop: fin * 1deg,
    radius: radio,
    anchor: "origin",
    stroke: 0.55pt + color,
  )
  if etiqueta != none {
    let med = (ini + fin) / 2
    cetz.draw.content(
      (
        centro.at(0) + (radio + 0.24) * calc.cos(med * 1deg),
        centro.at(1) + (radio + 0.24) * calc.sin(med * 1deg),
      ),
      text(size: letra-figura, fill: color, etiqueta),
    )
  }
}

// ---------- Ángulo recto ----------
// El cuadradito. `dir1` y `dir2` son ángulos en grados de los dos lados.
#let recto(centro, dir1, dir2, lado: 0.26, color: luma(90)) = {
  let p1 = (centro.at(0) + lado * calc.cos(dir1 * 1deg), centro.at(1) + lado * calc.sin(dir1 * 1deg))
  let p2 = (centro.at(0) + lado * calc.cos(dir2 * 1deg), centro.at(1) + lado * calc.sin(dir2 * 1deg))
  let p3 = (p1.at(0) + p2.at(0) - centro.at(0), p1.at(1) + p2.at(1) - centro.at(1))
  cetz.draw.line(p1, p3, p2, stroke: 0.5pt + color)
}

// ---------- Masa puntual ----------
#let masa(pos, etiqueta: none, radio: 0.13, color: c-trazo, hacia: "north-east") = {
  cetz.draw.circle(pos, radius: radio, fill: color, stroke: none)
  if etiqueta != none {
    cetz.draw.content(pos, text(size: letra-figura, etiqueta), anchor: hacia, padding: 5pt)
  }
}

// ---------- Cuerpo central (Tierra, Sol) ----------
#let cuerpo-central(pos, etiqueta: none, radio: 0.42, color: c-orbe) = {
  cetz.draw.circle(pos, radius: radio, fill: color.lighten(72%), stroke: 0.7pt + color)
  cetz.draw.circle(pos, radius: 0.045, fill: color, stroke: none)
  if etiqueta != none {
    cetz.draw.content(
      (pos.at(0), pos.at(1) - radio),
      text(size: letra-figura, fill: color, etiqueta),
      anchor: "north",
      padding: 3pt,
    )
  }
}

// ---------- Elipse orbital ----------
// Dibujada por puntos: CeTZ no trae elipse con foco, y lo que hace falta
// acá es justamente que el cuerpo central quede EN EL FOCO, no en el
// centro. `foco` es el foco ocupado; el centro geométrico queda a c = a·e
// en la dirección de `giro`, así que el perigeo cae del lado opuesto.
#let elipse-orbital(
  foco,
  a,
  e,
  giro: 0deg,
  color: c-trazo,
  grosor: trazo-cuerpo,
  n: 180,
  punteada: false,
) = {
  let c = a * e
  let cx = foco.at(0) + c * calc.cos(giro)
  let cy = foco.at(1) + c * calc.sin(giro)
  let b = a * calc.sqrt(1 - e * e)
  let pts = range(0, n + 1).map(i => {
    let t = i / n * 360deg
    let x = a * calc.cos(t)
    let y = b * calc.sin(t)
    (
      cx + x * calc.cos(giro) - y * calc.sin(giro),
      cy + x * calc.sin(giro) + y * calc.cos(giro),
    )
  })
  let st = if punteada { (paint: color, thickness: grosor, dash: "dashed") } else { grosor + color }
  cetz.draw.line(..pts, stroke: st, closed: true)
}

// ---------- Rótulo suelto ----------
#let rotulo(pos, cuerpo, ancla: "west", color: black, tam: letra-figura) = cetz.draw.content(
  pos,
  text(size: tam, fill: color, cuerpo),
  anchor: ancla,
  padding: 3pt,
)

// ---------- Rótulo con flechita ----------
#let flecha-nota(desde, hasta, cuerpo, ancla: "west", color: luma(70)) = {
  cetz.draw.line(desde, hasta, stroke: 0.45pt + luma(150), mark: (end: "straight", scale: 0.3))
  cetz.draw.content(desde, text(size: letra-figura, fill: color, cuerpo), anchor: ancla, padding: 3pt)
}

// ---------- Marcas sobre un eje ----------
#let marca-x(x, cuerpo, y: 0, largo: 0.12) = {
  cetz.draw.line((x, y - largo), (x, y + largo), stroke: 0.6pt + black)
  cetz.draw.content((x, y - largo), text(size: letra-figura, cuerpo), anchor: "north", padding: 2pt)
}
#let marca-y(y, cuerpo, x: 0, largo: 0.12) = {
  cetz.draw.line((x - largo, y), (x + largo, y), stroke: 0.6pt + black)
  cetz.draw.content((x - largo, y), text(size: letra-figura, cuerpo), anchor: "east", padding: 2pt)
}

// ---------- Rótulos largos contra el marco de un gráfico ----------
//
// Adentro de `plot.annotate` las coordenadas son las de DATOS, donde el
// mismo número mide distinto en cada gráfico, y cetz-plot además RECORTA
// la anotación contra el área del gráfico: dos rótulos largos pedidos en
// esquinas opuestas terminan encimados en el centro. Por eso estos
// ayudantes dibujan FUERA de `ejes-libro`, como hermanos suyos dentro del
// mismo `grafico({ ... })`, en coordenadas de lienzo.
//
// LA REGLA: adentro de los ejes, sólo marcas cortas. Todo texto de más de
// tres palabras va con `rotulo-marco`.

#let marco(x-min, x-max, y-min, y-max, tam: (7, 4.2)) = (
  x: (x-min, x-max),
  y: (y-min, y-max),
  tam: tam,
)

#let a-lienzo(m, p) = (
  (p.at(0) - m.x.at(0)) / (m.x.at(1) - m.x.at(0)) * m.tam.at(0),
  (p.at(1) - m.y.at(0)) / (m.y.at(1) - m.y.at(0)) * m.tam.at(1),
)

#let _esquinas = (
  "arriba-izq": (0, 1, "north-west"),
  "arriba-cen": (0.5, 1, "north"),
  "arriba-der": (1, 1, "north-east"),
  "izq": (0, 0.5, "west"),
  "der": (1, 0.5, "east"),
  "abajo-izq": (0, 0, "south-west"),
  "abajo-cen": (0.5, 0, "south"),
  "abajo-der": (1, 0, "south-east"),
)

#let rotulo-marco(m, donde, cuerpo, hacia: none, dx: 0, dy: 0, color: black, tam: letra-figura) = {
  let (fx, fy, ancla) = _esquinas.at(donde)
  let mx = if donde.ends-with("izq") { 0.01 } else if donde.ends-with("der") { -0.01 } else { 0 }
  let my = if donde.starts-with("arriba") { -0.02 } else if donde.starts-with("abajo") { 0.02 } else { 0 }
  let pos = ((fx + dx + mx) * m.tam.at(0), (fy + dy + my) * m.tam.at(1))
  if hacia != none {
    cetz.draw.line(pos, a-lienzo(m, hacia), stroke: 0.45pt + luma(150), mark: (end: "straight", scale: 0.28))
  }
  cetz.draw.content(pos, text(size: tam, fill: color, cuerpo), anchor: ancla, padding: 3pt)
}

// ---------- Paneles lado a lado ----------
#let paneles(..items, sep: 16pt) = {
  let its = items.pos()
  align(center, grid(
    columns: its.map(_ => auto),
    column-gutter: sep,
    align: center + top,
    ..its.map(it => block[
      #text(size: 8pt, weight: "bold", tracking: 0.5pt, fill: c-azul)[#upper(it.at(0))]
      #v(3pt)
      #it.at(1)
    ]),
  ))
}

// ---------- Pie corto debajo de una figura ----------
#let pie-figura(cuerpo) = align(center, block(width: 88%, above: 6pt)[
  #set text(size: 8.5pt, fill: luma(80))
  #set par(justify: false)
  #align(center, cuerpo)
])
