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

// ---------- Rótulos largos: FUERA del plot, en coordenadas de lienzo ----------
//
// El problema que esto resuelve, en dos capas:
//
// 1. `nota` y `flecha-nota` ubican el texto en coordenadas de DATOS, donde el
//    mismo número mide distinto en cada gráfico (en la curva del diodo, 1 mA
//    vertical son 3,5 pt y 0,1 V horizontal son 3 mm). El texto no sabe cuánto
//    mide, así que un rótulo largo cruza el eje sin que nadie se entere.
//
// 2. Y adentro de `plot.annotate(resize: false)` no alcanza con calcular bien
//    la posición: cetz-plot RECORTA la anotación contra el área del gráfico, y
//    cuanto más largo es el texto más lo empuja hacia adentro. Dos rótulos
//    largos pedidos en esquinas opuestas terminan encimados en el centro.
//    Comprobado por render con las etiquetas IZQUIERDA/DERECHA.
//
// Por eso estos ayudantes dibujan FUERA de `ejes-libro`, como hermanos suyos
// dentro del mismo `grafico({ ... })`, donde las coordenadas son las del
// lienzo —las mismas unidades de `tam`— y no las toca nadie.
//
// LA REGLA: adentro de los ejes, sólo marcas cortas — un número, una letra,
// "0,7 V". Todo texto de más de tres palabras va con `rotulo-marco`.

// Descripción del rectángulo visible: los mismos números que se le pasan a
// `ejes-libro`, escritos UNA vez por figura.
#let marco(x-min, x-max, y-min, y-max, tam: (7, 4.2)) = (
  x: (x-min, x-max),
  y: (y-min, y-max),
  tam: tam,
)

// Dato -> lienzo. Es la única conversión de escala del sistema, y está en un
// solo lugar a propósito.
#let a-lienzo(m, p) = (
  (p.at(0) - m.x.at(0)) / (m.x.at(1) - m.x.at(0)) * m.tam.at(0),
  (p.at(1) - m.y.at(0)) / (m.y.at(1) - m.y.at(0)) * m.tam.at(1),
)

// Las nueve posiciones, cada una con el ancla que hace crecer el texto HACIA
// ADENTRO del gráfico: anclado por la esquina que mira al borde, el texto no
// se escapa por ese lado por más largo que sea.
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

// Rótulo largo contra el marco. `hacia` es un punto en coordenadas de DATO:
// si se lo pasa, tira una guía fina desde el rótulo hasta ahí.
// `dx`/`dy` corren el rótulo en FRACCIÓN del lado, no en unidades de dato, así
// el mismo número significa lo mismo en los ocho gráficos.
#let rotulo-marco(
  m,
  donde,
  cuerpo,
  hacia: none,
  dx: 0,
  dy: 0,
  color: black,
  tam: letra-figura,
) = {
  let (fx, fy, ancla) = _esquinas.at(donde)
  // Margen para despegar el texto del borde y de la punta de flecha del eje.
  let mx = if donde.ends-with("izq") { 0.01 } else if donde.ends-with("der") { -0.01 } else { 0 }
  let my = if donde.starts-with("arriba") { -0.02 } else if donde.starts-with("abajo") { 0.02 } else { 0 }
  let pos = (
    (fx + dx + mx) * m.tam.at(0),
    (fy + dy + my) * m.tam.at(1),
  )
  if hacia != none {
    cetz.draw.line(
      pos,
      a-lienzo(m, hacia),
      stroke: 0.45pt + luma(150),
      mark: (end: "straight", scale: 0.28),
    )
  }
  cetz.draw.content(pos, text(size: tam, fill: color, cuerpo), anchor: ancla, padding: 3pt)
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

// ---------- Paneles apilados ----------
// Lo mismo que `paneles`, pero en columna y con el rotulo a la izquierda.
// Va donde las figuras COMPARTEN el eje horizontal —las formas de onda de un
// mismo transitorio, medidas todas contra el mismo tiempo— y lo que hay que
// poder leer es la alineacion vertical: que el quiebre de la corriente caiga
// justo encima del escalon de la tension. Lado a lado esa lectura se pierde,
// y es exactamente lo que el grafico tiene que mostrar.
#let paneles-columna(..items, sep: 7pt) = {
  let its = items.pos()
  align(center, grid(
    columns: 1,
    row-gutter: sep,
    align: center,
    ..its.map(it => block[
      #text(size: 8pt, weight: "bold", tracking: 0.5pt, fill: c-azul)[#upper(it.at(0))]
      #v(-1pt)
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

// ---------- Notación de los métodos de análisis (Parte II) ----------
//
// Los circuitos de los módulos 7 y 8 no se dibujan solos: llevan encima la
// notación del método —el número del nodo, el giro de la corriente de malla,
// el recuadro del supernodo—. Eso no existe en la Parte I.
//
// Está resuelto UNA vez acá, y no figura por figura, por la razón de siempre:
// cinco figuras que inventan cada una su forma de marcar un nodo son cinco
// notaciones distintas para la misma cosa, y el alumno las lee como si
// significaran cosas distintas.

// Las ocho direcciones en las que puede salir un rótulo desde un punto.
// Las diagonales van normalizadas para que el rótulo quede a la misma
// distancia del punto en las ocho.
#let _rumbos = (
  "n": (0, 1),
  "s": (0, -1),
  "e": (1, 0),
  "o": (-1, 0),
  "ne": (0.71, 0.71),
  "no": (-0.71, 0.71),
  "se": (0.71, -0.71),
  "so": (-0.71, -0.71),
)

// Nodo rotulado: el punto de unión, más su número adentro de un círculo.
// El círculo distingue al rótulo del nodo de cualquier otro texto de la
// figura, que es justo lo que el paréntesis del ASCII trataba de hacer.
#let marca-nodo(
  pos,
  etiqueta,
  hacia: "n",
  sep: 0.52,
  color: c-azul,
  punto: true,
) = {
  let (ux, uy) = _rumbos.at(hacia)
  let centro = (pos.at(0) + ux * sep, pos.at(1) + uy * sep)
  if punto {
    cetz.draw.circle(pos, radius: 0.075, fill: c-trazo, stroke: none)
  }
  cetz.draw.circle(centro, radius: 0.2, fill: white, stroke: 0.55pt + color)
  cetz.draw.content(centro, text(size: letra-figura - 0.5pt, fill: color, etiqueta))
}

// Nodo de referencia: el mismo rótulo, más el símbolo de tierra colgando.
// `sep-tierra` es cuánto baja el símbolo respecto del nodo.
// `hacia` sale en diagonal por defecto: el nodo de referencia tiene el cable
// horizontal de la rama y el vertical de la tierra, y un rotulo en "e" o en "s"
// cae justo encima de uno de los dos.
#let nodo-referencia(
  pos,
  etiqueta: [0],
  nombre: "ref",
  hacia: "se",
  sep-tierra: 0.55,
  color: c-azul,
) = {
  let pie = (pos.at(0), pos.at(1) - sep-tierra)
  cetz.draw.line(pos, pie, stroke: trazo-cable + c-trazo)
  zap.ground(nombre, pie)
  marca-nodo(pos, etiqueta, hacia: hacia, color: color)
}

// Corriente de malla: la flecha circular que se dibuja en el hueco de la
// malla, con su nombre en el centro. Horaria por defecto, que es la
// convención que usa el apunte y la que hace que la resistencia compartida
// entre en las dos ecuaciones con signo menos.
#let giro-malla(
  centro,
  etiqueta,
  radio: 0.44,
  sentido: "horario",
  color: c-viole,
) = {
  let (ini, fin) = if sentido == "horario" { (125deg, -145deg) } else { (55deg, 325deg) }
  cetz.draw.arc(
    centro,
    start: ini,
    stop: fin,
    radius: radio,
    anchor: "origin",
    stroke: 0.6pt + color,
    mark: (end: "straight", scale: 0.35),
  )
  cetz.draw.content(centro, text(size: letra-figura, fill: color, etiqueta))
}

// Recuadro punteado que encierra una región del circuito: el supernodo
// (la fuente de tensión con sus dos nodos adentro) y la supermalla (las dos
// mallas que comparten la rama de la fuente de corriente). Es la misma
// marca para las dos cosas a propósito: las dos dicen "esto de acá adentro
// se trata como una sola ecuación".
#let _bordes-recuadro = (
  "n": (0.5, 1, "south"),
  "s": (0.5, 0, "north"),
  "e": (1, 0.5, "west"),
  "o": (0, 0.5, "east"),
  "ne": (1, 1, "south-west"),
  "no": (0, 1, "south-east"),
)

#let recuadro-super(
  a,
  b,
  etiqueta,
  donde: "n",
  color: c-viole,
  radio: 0.2,
) = {
  cetz.draw.rect(
    a,
    b,
    stroke: (paint: color, thickness: 0.65pt, dash: "dashed"),
    radius: radio,
  )
  let (x0, x1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)))
  let (y0, y1) = (calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  let (fx, fy, ancla) = _bordes-recuadro.at(donde)
  let pos = (x0 + fx * (x1 - x0), y0 + fy * (y1 - y0))
  cetz.draw.content(pos, text(size: letra-figura, fill: color, etiqueta), anchor: ancla, padding: 3pt)
}

// ---------- Rótulos puestos a mano en un esquema ----------
// El rótulo automático de zap cae mal cada vez que el símbolo está rotado o el
// texto es largo (docs/figuras.md, sección 6). La salida es apagarlo con
// `label: none` y poner el texto acá, en coordenadas del lienzo.
#let rotulo(pos, cuerpo, ancla: "west", color: black, tam: letra-figura) = cetz.draw.content(
  pos,
  text(size: tam, fill: color, cuerpo),
  anchor: ancla,
  padding: 3pt,
)

// Nombre y valor de un componente, en dos renglones. Un `$R_2 = 4 Omega$` al
// lado de un resistor vertical mide más de una unidad de lienzo y se lleva por
// delante lo que tenga al lado; apilado mide menos de la mitad y entra.
#let valor(pos, nombre, val, ancla: "west") = rotulo(pos, [#nombre\ #val], ancla: ancla)
