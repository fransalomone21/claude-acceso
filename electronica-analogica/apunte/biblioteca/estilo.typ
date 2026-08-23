// =====================================================================
//  estilo.typ — base común de todas las figuras del apunte
//
//  Acá está lo que comparten los esquemas de circuito y los gráficos:
//  el motor de dibujo, los grosores de trazo, el tamaño de letra y los
//  dos envoltorios `esquema()` y `grafico()`.
//
//  Motor: CeTZ (dibujo vectorial) + zap (símbolos de circuito según
//  IEC/IEEE) + cetz-plot (ejes y curvas). Los tres corren dentro de
//  Typst: no hace falta LaTeX ni ninguna herramienta externa.
//  Documentación de por qué se eligieron: docs/figuras.md
// =====================================================================

#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": plot
#import "@preview/zap:0.6.0"

#import "paleta.typ": *

// ---------- Constantes de trazo ----------
// Un solo lugar para el grosor: si cambia acá, cambia en las 24 figuras.
#let trazo-simbolo = 0.7pt // cuerpo de los símbolos (resistor, diodo…)
#let trazo-cable = 0.6pt // conductores
#let trazo-curva = 1.1pt // la curva protagonista de un gráfico
#let trazo-curva2 = 0.9pt // curvas secundarias
#let trazo-guia = 0.5pt // líneas de construcción punteadas
#let punteado = (paint: c-guia, thickness: 0.5pt, dash: "dashed")

// Tamaño de letra dentro de las figuras. Más chico que el cuerpo del
// texto (10,5 pt) para que las etiquetas no compitan con el dibujo.
#let letra-figura = 8.5pt

// ---------- Envoltorio de esquema de circuito ----------
// `cuerpo` es un bloque de código con llamadas a los símbolos de zap.
// `escala` es el largo de una unidad del lienzo: subirla agranda la
// figura entera sin tocar ninguna coordenada.
#let esquema(cuerpo, escala: 0.95cm) = align(
  center,
  {
    set text(size: letra-figura)
    zap.circuit(
      length: escala,
      {
        cetz.draw.set-style(
          zap: (
            stroke: trazo-simbolo,
            wire: (stroke: trazo-cable),
            label: (distance: 6pt),
          ),
        )
        cuerpo
      },
    )
  },
)

// ---------- Envoltorio de gráfico ----------
#let grafico(cuerpo, escala: 1cm) = align(
  center,
  {
    set text(size: letra-figura)
    cetz.canvas(length: escala, cuerpo)
  },
)

// ---------- Ejes estilo "libro de texto" ----------
// El estilo `school-book` de cetz-plot dibuja los ejes cruzándose en el
// origen y con punta de flecha, que es como se dibujan las curvas
// características en cualquier libro de electrónica (y como las dibuja
// GeoGebra). Los ticks se apagan por defecto: en una curva cualitativa
// una escala numérica miente más de lo que informa; cuando el gráfico
// sí es cuantitativo se pasan `x-tick-step` / `y-tick-step`.
#let ejes-libro(
  cuerpo,
  tam: (7, 4.2),
  x-label: none,
  y-label: none,
  ..resto,
) = plot.plot(
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

// ---------- Ayudas de anotación dentro de un gráfico ----------
// Se usan adentro de `plot.annotate({ ... })`, donde las coordenadas
// son las del gráfico y no las del lienzo.

// Línea punteada de guía entre dos puntos (las del ejemplo del zener).
#let guia(desde, hasta) = cetz.draw.line(desde, hasta, stroke: punteado)

// Texto suelto anclado en un punto del gráfico.
#let nota(pos, cuerpo, ancla: "west", color: black, tam: letra-figura) = cetz.draw.content(
  pos,
  text(size: tam, fill: color, cuerpo),
  anchor: ancla,
  padding: 3pt,
)

// Texto con una flechita que apunta a un punto de la curva.
#let flecha-nota(desde, hasta, cuerpo, ancla: "west", color: black) = {
  cetz.draw.line(
    desde,
    hasta,
    stroke: 0.45pt + luma(140),
    mark: (end: "straight", scale: 0.3),
  )
  cetz.draw.content(desde, text(size: letra-figura, fill: color, cuerpo), anchor: ancla, padding: 3pt)
}

// Marca de un valor sobre un eje: tick corto + rótulo.
#let marca-x(x, cuerpo, y: 0, largo: 0.12) = {
  cetz.draw.line((x, y - largo), (x, y + largo), stroke: 0.6pt + black)
  cetz.draw.content((x, y - largo), text(size: letra-figura, cuerpo), anchor: "north", padding: 2pt)
}

#let marca-y(y, cuerpo, x: 0, largo: 0.12) = {
  cetz.draw.line((x - largo, y), (x + largo, y), stroke: 0.6pt + black)
  cetz.draw.content((x - largo, y), text(size: letra-figura, cuerpo), anchor: "east", padding: 2pt)
}

// ---------- Paneles lado a lado ----------
// Varias figuras chicas bajo una sola epigrafe, cada una con su rotulo.
// Se usa donde el original comparaba dos casos ("directa / inversa").
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

// Pie corto debajo de una figura, para la aclaracion que en el original
// iba suelta abajo del dibujo en ASCII.
#let pie-figura(cuerpo) = align(center, block(width: 88%, above: 6pt)[
  #set text(size: 8.5pt, fill: luma(80))
  #set par(justify: false)
  #align(center, cuerpo)
])

// ---------- Flecha de corriente sobre un conductor ----------
// zap trae el decorado `i:` para marcar corrientes, pero en la version
// 0.6.0 falla sobre un `wire` (panic: "Element 'symbol' does not have a
// border for anchor '0deg'"); sobre un simbolo de dos nodos anda bien.
// Para los cables se usa esta flecha, que ademas deja elegir donde cae.
// Se le pasan los dos extremos de la FLECHA, no los del cable.
#let corriente(desde, hasta, etiqueta, ancla: "south") = {
  cetz.draw.line(desde, hasta, stroke: 0.6pt + black, mark: (end: "straight", scale: 0.4))
  cetz.draw.content(
    (desde, 50%, hasta),
    text(size: letra-figura, etiqueta),
    anchor: ancla,
    padding: 3pt,
  )
}
