// =====================================================================
//  circuitos.typ — los esquemas de circuito del apunte
//
//  Una función por figura, nombrada `fig-<tema>`. El nombre es el
//  contrato: los módulos las llaman y no saben cómo están dibujadas.
//
//  Cómo agregar una: copiar la más parecida, cambiarle el nombre,
//  agregarla a `galeria.typ` y compilar la galería (segundos) en vez
//  del apunte entero. Detalle en docs/figuras.md.
//
//  Dentro de cada `esquema({ ... })` valen los símbolos de zap
//  (resistor, diode, npn, transformer…) y las primitivas de CeTZ
//  (cetz.draw.line, .content, .circle…). Las coordenadas son (x, y) en
//  unidades del lienzo; `(rel: (dx, dy))` es relativa a la anterior.
// =====================================================================

#import "estilo.typ": *

// ---------------------------------------------------------------
//  Módulo 1 — Mediciones
// ---------------------------------------------------------------

// Voltímetro en paralelo / amperímetro en serie.
#let fig-conexion-instrumentos() = paneles(
  (
    "Voltímetro: en paralelo",
    esquema({
      import zap: *
      vsource("V", (0, 0), (0, 2.1), label: $V$)
      wire((0, 2.1), (2.6, 2.1))
      resistor("R", (2.6, 2.1), (2.6, 0), label: (content: $R$, anchor: "west"))
      wire((2.6, 0), (0, 0))
      // derivación al voltímetro
      node("a", (2.6, 2.1))
      node("b", (2.6, 0))
      wire((2.6, 2.1), (4.4, 2.1))
      voltmeter("Vm", (4.4, 2.1), (4.4, 0))
      wire((4.4, 0), (2.6, 0))
    }),
  ),
  (
    "Amperímetro: en serie",
    esquema({
      import zap: *
      vsource("V", (0, 0), (0, 2.1), label: $V$)
      wire((0, 2.1), (0.7, 2.1))
      ammeter("Am", (0.7, 2.1), (2.1, 2.1))
      wire((2.1, 2.1), (2.8, 2.1))
      resistor("R", (2.8, 2.1), (2.8, 0), label: $R$)
      wire((2.8, 0), (0, 0))
    }),
  ),
)

// Expansión de rango de un amperímetro: shunt en paralelo.
#let fig-shunt() = esquema({
  import zap: *
  // entrada y salida de la corriente total
  wire((-1.3, 0), (0, 0))
  corriente((-1.2, 0.28), (-0.35, 0.28), $I$)
  node("e", (0, 0))
  node("s", (3.0, 0))
  wire((3.0, 0), (4.3, 0))
  corriente((3.35, 0.28), (4.2, 0.28), $I$)
  // rama del galvanómetro
  wire((0, 0), (0, 0.95))
  round-meter("G", (0, 0.95), (3.0, 0.95), measurand: "G", label: $R_m$)
  corriente((0.35, 1.28), (1.0, 1.28), $I_m$)
  wire((3.0, 0.95), (3.0, 0))
  // rama del shunt
  wire((0, 0), (0, -0.95))
  resistor("Rs", (0, -0.95), (3.0, -0.95), label: $R_S$)
  corriente((0.35, -1.45), (1.0, -1.45), $I_S$, ancla: "north")
  wire((3.0, -0.95), (3.0, 0))
})

// Expansión de rango de un voltímetro: multiplicadora en serie.
#let fig-multiplicadora() = esquema({
  import zap: *
  node("a", (0, 0), fill: false)
  // El rótulo automático de zap cae ARRIBA del símbolo, justo donde va la
  // flecha de corriente, y los dos textos se encimaban. Se apaga y se pone
  // $R_M$ a mano por debajo (la salida recomendada en docs/figuras.md).
  resistor("RM", (0.5, 0), (2.4, 0), label: none)
  cetz.draw.content((1.45, -0.28), text(size: letra-figura)[$R_M$], anchor: "north")
  round-meter("G", (2.9, 0), (4.3, 0), measurand: "G", label: $R_m$)
  corriente((1.05, 0.32), (1.75, 0.32), $I_m$)
  wire((0, 0), (0.5, 0))
  wire((2.4, 0), (2.9, 0))
  wire((4.3, 0), (4.8, 0))
  node("b", (4.8, 0), fill: false)
  // cota de la tensión que se mide
  cetz.draw.line(
    (0, -0.85),
    (4.8, -0.85),
    stroke: 0.5pt + c-guia,
    mark: (start: "straight", end: "straight", scale: 0.4),
  )
  cetz.draw.line((0, 0), (0, -0.85), stroke: punteado)
  cetz.draw.line((4.8, 0), (4.8, -0.85), stroke: punteado)
  cetz.draw.content((2.4, -0.85), text(size: letra-figura)[tensión a medir $V$], anchor: "north", padding: 3pt)
})

// Voltímetro multirrango: una multiplicadora por escala.
#let fig-multirrango() = esquema({
  import zap: *
  let entradas = ((1.5, $R_1$, $V_a$), (0, $R_2$, $V_b$), (-1.5, $R_3$, $V_c$))
  for (n, fila) in entradas.enumerate() {
    let (y, rot, v) = fila
    let id = str(n)
    node("t" + id, (0, y), fill: false)
    cetz.draw.content((0, y), text(size: letra-figura, v), anchor: "east", padding: 5pt)
    wire((0, y), (0.4, y))
    resistor("R" + id, (0.4, y), (2.3, y), label: rot)
    wire((2.3, y), (2.88, y))
    // contacto de la llave
    cetz.draw.circle((2.95, y), radius: 0.07, stroke: trazo-simbolo, fill: white)
  }
  // brazo de la llave selectora, apuntando al contacto de arriba
  cetz.draw.line((3.9, 0), (3.05, 1.44), stroke: trazo-simbolo)
  cetz.draw.circle((3.9, 0), radius: 0.07, fill: black, stroke: trazo-simbolo)
  cetz.draw.content((3.9, -0.42), text(size: letra-figura)[llave\ selectora], anchor: "north", padding: 2pt)
  // instrumento
  wire((3.9, 0), (4.7, 0))
  round-meter("G", (4.7, 0), (6.1, 0), measurand: "G", label: $R_m$)
  wire((6.1, 0), (6.6, 0))
  node("sal", (6.6, 0), fill: false)
})

// ---------------------------------------------------------------
//  Módulo 2 — Señales e instrumental
// ---------------------------------------------------------------

// Filtro pasa bajos RC.
#let fig-filtro-rc() = esquema({
  import zap: *
  node("in+", (0, 1.1), fill: false)
  node("in-", (0, -0.6), fill: false)
  resistor("R", (0, 1.1), (2.2, 1.1), label: $R$)
  node("m", (2.2, 1.1))
  capacitor("C", (2.2, 1.1), (2.2, -0.6), label: $C$)
  node("m2", (2.2, -0.6))
  wire((2.2, 1.1), (3.6, 1.1))
  wire((0, -0.6), (3.6, -0.6))
  node("out+", (3.6, 1.1), fill: false)
  node("out-", (3.6, -0.6), fill: false)
  cetz.draw.content((-0.15, 0.25), text(size: letra-figura, $V_"in"$), anchor: "east")
  cetz.draw.content((3.75, 0.25), text(size: letra-figura, $V_"sal"$), anchor: "west")
})

// ---------------------------------------------------------------
//  Módulo 3 — Transformadores
// ---------------------------------------------------------------

// Núcleo laminado: las dos barras verticales entre los bobinados.
#let _nucleo(x, y0, y1) = {
  cetz.draw.line((x, y0), (x, y1), stroke: trazo-simbolo + c-trazo)
  cetz.draw.line((x + 0.16, y0), (x + 0.16, y1), stroke: trazo-simbolo + c-trazo)
}

// Transformador reductor: primario, núcleo y secundario.
#let fig-transformador() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.3)
  inductor("L1", (0, ya), (0, yb))
  inductor("L2", (1.25, yb), (1.25, ya))
  _nucleo(0.52, -0.35, ya + 0.35)
  // terminales del primario
  wire((0, ya), (-1.0, ya))
  wire((0, yb), (-1.0, yb))
  node("p1", (-1.0, ya), fill: false)
  node("p2", (-1.0, yb), fill: false)
  // terminales del secundario
  wire((1.25, ya), (2.25, ya))
  wire((1.25, yb), (2.25, yb))
  node("s1", (2.25, ya), fill: false)
  node("s2", (2.25, yb), fill: false)
  // rótulos
  cetz.draw.content((-1.15, ya / 2), text(size: letra-figura)[220 V\ (CA)], anchor: "east")
  cetz.draw.content((2.4, ya / 2), text(size: letra-figura)[12 V\ (CA)], anchor: "west")
  cetz.draw.content((-0.2, ya + 0.55), text(size: letra-figura)[$N_1$ espiras], anchor: "east")
  cetz.draw.content((1.45, ya + 0.55), text(size: letra-figura)[$N_2$ espiras], anchor: "west")
  cetz.draw.content((0.6, -0.6), text(size: letra-figura, fill: luma(90))[núcleo], anchor: "north")
})

// Secundario con punto medio: dos tensiones en contrafase.
#let fig-transformador-punto-medio() = esquema({
  import zap: *
  let (yb, ym, ya) = (0, 1.15, 2.3)
  inductor("L1", (0, ya), (0, yb))
  _nucleo(0.52, -0.35, ya + 0.35)
  inductor("L2a", (1.25, ym + 0.08), (1.25, ya))
  inductor("L2b", (1.25, yb), (1.25, ym - 0.08))
  wire((1.25, ym - 0.08), (1.25, ym + 0.08))
  node("m", (1.25, ym))
  // primario
  wire((0, ya), (-1.0, ya))
  wire((0, yb), (-1.0, yb))
  node("p1", (-1.0, ya), fill: false)
  node("p2", (-1.0, yb), fill: false)
  cetz.draw.content((-1.15, ym), text(size: letra-figura)[220 V\ (CA)], anchor: "east")
  // tomas del secundario
  for (i, fila) in ((ya, $A$), (ym, $M$), (yb, $B$)).enumerate() {
    let (y, rot) = fila
    wire((1.25, y), (2.5, y))
    node("t" + str(i), (2.5, y), fill: false)
    cetz.draw.content((2.65, y), text(size: letra-figura, rot), anchor: "west")
  }
  cetz.draw.content((2.65, ym - 0.34), text(size: letra-figura, fill: luma(90))[(masa)], anchor: "west")
  // cotas de tensión
  cetz.draw.line((4.0, ya), (4.0, ym), stroke: 0.5pt + c-guia, mark: (start: "straight", end: "straight", scale: 0.35))
  cetz.draw.line((4.0, ym), (4.0, yb), stroke: 0.5pt + c-guia, mark: (start: "straight", end: "straight", scale: 0.35))
  cetz.draw.content((4.1, (ya + ym) / 2), text(size: letra-figura)[12 V], anchor: "west")
  cetz.draw.content((4.1, (ym + yb) / 2), text(size: letra-figura)[12 V], anchor: "west")
})

// ---------------------------------------------------------------
//  Módulo 4 — Diodos
// ---------------------------------------------------------------

// Un diodo en un lazo con la pila y una resistencia. `invertido`
// cambia el sentido del diodo sin tocar el resto del dibujo.
#let _lazo-diodo(invertido: false) = esquema({
  import zap: *
  let (a, b) = ((0.5, 2.0), (1.9, 2.0))
  cell("V", (0, 0), (0, 2.0), label: $V$)
  wire((0, 2.0), a)
  if invertido { diode("D", b, a, label: $D$) } else { diode("D", a, b, label: $D$) }
  wire(b, (2.7, 2.0))
  resistor("R", (2.7, 2.0), (2.7, 0), label: $R$)
  wire((2.7, 0), (0, 0))
  cetz.draw.content((-0.2, 1.5), text(size: letra-figura)[$+$], anchor: "east")
  cetz.draw.content((-0.2, 0.5), text(size: letra-figura)[$-$], anchor: "east")
})

#let fig-polarizacion-diodo() = paneles(
  ("Directa: conduce", _lazo-diodo()),
  ("Inversa: no conduce", _lazo-diodo(invertido: true)),
)

// LED con resistencia limitadora.
#let fig-led-limitadora() = esquema({
  import zap: *
  cell("V", (0, 0), (0, 2.2), label: $V_"cc"$)
  wire((0, 2.2), (0.5, 2.2))
  resistor("R", (0.5, 2.2), (2.1, 2.2), label: $R$)
  wire((2.1, 2.2), (2.9, 2.2))
  led("D", (2.9, 2.2), (2.9, 0.7), label: none)
  cetz.draw.content((2.5, 1.45), text(size: letra-figura)[LED\ $V_F$], anchor: "east")
  wire((2.9, 0.7), (2.9, 0))
  wire((2.9, 0), (0, 0))
  corriente((2.0, -0.32), (1.1, -0.32), $I_F$, ancla: "north")
})

// Caja genérica de carga, para lo que en el original era "[ ] circuito".
#let _caja-carga(x, y, alto: 1.2, ancho: 1.25, rotulo: [circuito\ protegido]) = {
  cetz.draw.rect(
    (x - ancho / 2, y - alto / 2),
    (x + ancho / 2, y + alto / 2),
    stroke: trazo-simbolo + c-trazo,
    fill: white,
  )
  cetz.draw.content((x, y), text(size: letra-figura - 0.5pt, rotulo))
}

#let fig-proteccion-polaridad() = paneles(
  (
    "En serie",
    esquema({
      import zap: *
      cell("V", (0, 0), (0, 2.0), label: $V$)
      wire((0, 2.0), (0.4, 2.0))
      diode("D", (0.4, 2.0), (1.8, 2.0), label: $D$)
      wire((1.8, 2.0), (2.7, 2.0))
      wire((2.7, 2.0), (2.7, 1.6))
      _caja-carga(2.7, 1.0)
      wire((2.7, 0.4), (2.7, 0))
      wire((2.7, 0), (0, 0))
    }),
  ),
  (
    "En paralelo, con fusible",
    esquema({
      import zap: *
      cell("V", (0, 0), (0, 2.0), label: $V$)
      wire((0, 2.0), (0.35, 2.0))
      fuse("F", (0.35, 2.0), (1.6, 2.0), label: [FUS])
      wire((1.6, 2.0), (2.1, 2.0))
      node("d", (2.1, 2.0))
      diode("D", (2.1, 0), (2.1, 2.0), label: $D$)
      node("d2", (2.1, 0))
      wire((2.1, 2.0), (3.4, 2.0))
      wire((3.4, 2.0), (3.4, 1.6))
      _caja-carga(3.4, 1.0)
      wire((3.4, 0.4), (3.4, 0))
      wire((3.4, 0), (0, 0))
    }),
  ),
)

// Rectificador de media onda.
#let fig-rectificador-media-onda() = esquema({
  import zap: *
  acvsource("V", (0, 0), (0, 2.2), label: $v_e$)
  wire((0, 2.2), (0.45, 2.2))
  diode("D", (0.45, 2.2), (1.95, 2.2), label: $D$)
  wire((1.95, 2.2), (2.9, 2.2))
  resistor("RL", (2.9, 2.2), (2.9, 0), label: $R_L$)
  wire((2.9, 0), (0, 0))
  node("a", (2.9, 2.2))
  node("b", (2.9, 0))
  wire((2.9, 2.2), (3.8, 2.2))
  wire((2.9, 0), (3.8, 0))
  node("s1", (3.8, 2.2), fill: false)
  node("s2", (3.8, 0), fill: false)
  cetz.draw.content((3.95, 1.1), text(size: letra-figura)[$v_s$], anchor: "west")
})

// Rectificador de onda completa con transformador de punto medio.
#let fig-rectificador-punto-medio() = esquema({
  import zap: *
  let (yb, ym, ya) = (0, 1.3, 2.6)
  inductor("L1", (0, ya), (0, yb))
  _nucleo(0.52, -0.3, ya + 0.3)
  inductor("L2a", (1.25, ym + 0.08), (1.25, ya))
  inductor("L2b", (1.25, yb), (1.25, ym - 0.08))
  wire((1.25, ym - 0.08), (1.25, ym + 0.08))
  node("m", (1.25, ym))
  wire((0, ya), (-0.8, ya))
  wire((0, yb), (-0.8, yb))
  node("p1", (-0.8, ya), fill: false)
  node("p2", (-0.8, yb), fill: false)
  cetz.draw.content((-0.95, ym), text(size: letra-figura)[220 V], anchor: "east")
  // diodos de las dos ramas
  wire((1.25, ya), (1.9, ya))
  diode("D1", (1.9, ya), (3.3, ya), label: $D_1$)
  wire((1.25, yb), (1.9, yb))
  diode("D2", (1.9, yb), (3.3, yb), label: (content: $D_2$, anchor: "south"))
  wire((3.3, ya), (4.1, ya))
  wire((4.1, ya), (4.1, yb))
  wire((3.3, yb), (4.1, yb))
  node("sal", (4.1, ym))
  // carga entre la salida de los diodos y el punto medio
  wire((4.1, ym), (5.0, ym))
  resistor("RL", (5.0, ym), (5.0, -1.4), label: $R_L$)
  wire((5.0, -1.4), (0.55, -1.4))
  wire((0.55, -1.4), (0.55, ym))
  wire((0.55, ym), (1.25, ym))
  cetz.draw.content((2.8, -1.5), text(size: letra-figura, fill: luma(90))[retorno por el punto medio], anchor: "north")
})

// Salto de cable: dos conductores que se cruzan SIN conectarse. El
// arquito es la convención inequívoca; el cruce a secas también vale
// (sin punto = sin conexión), pero acá conviene que no quede duda.
#let _salto(x, y, radio: 0.16) = {
  cetz.draw.arc(
    (x - radio, y),
    start: 180deg,
    stop: 0deg,
    radius: radio,
    stroke: trazo-cable + c-trazo,
    fill: white,
  )
}

// Puente rectificador de Graetz.
// El puente es el caso donde la fuente queda de un lado y la carga del
// otro: por geometría, dos conductores tienen que cruzarse. El cruce
// está dibujado con un salto y sin punto de unión.
#let fig-puente-graetz() = esquema({
  import zap: *
  let (iz, ar, de, ab) = ((1.9, 0), (3.4, 1.5), (4.9, 0), (3.4, -1.5))
  diode("D1", iz, ar, label: none)
  diode("D2", ar, de, label: none)
  diode("D3", ab, iz, label: none)
  diode("D4", ab, de, label: none)
  cetz.draw.content((2.15, 1.15), text(size: letra-figura, $D_1$), anchor: "east")
  cetz.draw.content((4.65, 1.15), text(size: letra-figura, $D_2$), anchor: "west")
  cetz.draw.content((2.15, -1.15), text(size: letra-figura, $D_3$), anchor: "east")
  cetz.draw.content((4.65, -1.15), text(size: letra-figura, $D_4$), anchor: "west")
  node("n-iz", iz)
  node("n-de", de)
  node("n-ar", ar)
  node("n-ab", ab)
  // entrada de alterna: una punta al vértice izquierdo, la otra al
  // derecho, rodeando el puente por abajo
  wire(iz, (0.3, 0))
  acvsource("V", (0.3, -2.7), (0.3, 0), label: (content: $v_e$, anchor: "east"))
  wire((0.3, -2.7), (6.0, -2.7))
  wire((6.0, -2.7), (6.0, 0))
  wire((6.0, 0), de)
  // salida continua sobre la carga
  wire(ar, (3.4, 2.5))
  wire((3.4, 2.5), (7.5, 2.5))
  wire((7.5, 2.5), (7.5, 0.9))
  resistor("RL", (7.5, 0.9), (7.5, -0.9), label: none)
  cetz.draw.content((7.25, 0), text(size: letra-figura, $R_L$), anchor: "east")
  wire((7.5, -0.9), (7.5, -1.95))
  // el retorno del negativo cruza el cable de la fuente
  wire((7.5, -1.95), (6.16, -1.95))
  wire((5.84, -1.95), (3.4, -1.95))
  _salto(6.0, -1.95)
  wire((3.4, -1.95), ab)
  cetz.draw.content((7.65, 1.75), text(size: letra-figura)[$+$], anchor: "west")
  cetz.draw.content((7.65, -1.75), text(size: letra-figura)[$-$], anchor: "west")
  cetz.draw.content((8.35, 0), text(size: letra-figura)[$v_s$], anchor: "west")
  cetz.draw.line((8.3, 1.6), (8.3, -1.6), stroke: 0.5pt + c-guia, mark: (start: "straight", end: "straight", scale: 0.35))
})

// ---------------------------------------------------------------
//  Bloques y flechas (diagramas que no son de componentes)
// ---------------------------------------------------------------

#let bloque(x, y, texto, ancho: 2.3, alto: 1.0, relleno: white) = {
  cetz.draw.rect(
    (x - ancho / 2, y - alto / 2),
    (x + ancho / 2, y + alto / 2),
    stroke: trazo-simbolo + c-trazo,
    fill: relleno,
    radius: 0.06,
  )
  cetz.draw.content((x, y), text(size: letra-figura - 0.5pt, weight: "bold", texto))
}

#let flecha(desde, hasta) = cetz.draw.line(
  desde,
  hasta,
  stroke: trazo-cable + c-trazo,
  mark: (end: "straight", scale: 0.4),
)

// Miniatura de forma de onda, para poner debajo de un bloque.
// `f` va de t en [0,1] a un valor en [-1,1].
#let mini-onda(x0, y0, f, ancho: 1.95, alto: 0.5, muestras: 90) = {
  cetz.draw.line((x0 - 0.1, y0), (x0 + ancho + 0.1, y0), stroke: 0.4pt + c-guia)
  let pts = range(muestras + 1).map(i => {
    let t = i / muestras
    (x0 + t * ancho, y0 + f(t) * alto)
  })
  cetz.draw.line(..pts, stroke: trazo-curva2 + c-dato)
}

// ---------------------------------------------------------------
//  Módulo 2 — Diagrama en bloques del osciloscopio
// ---------------------------------------------------------------

#let fig-bloques-osciloscopio() = esquema(
  escala: 0.85cm,
  {
    import zap: *
    bloque(2.4, 2.6, [A. AMPLIFICADOR\ Y ATENUADOR\ VERTICAL\ (Volts/Div)], ancho: 4.0, alto: 1.8)
    bloque(2.4, -0.2, [C. DISPARO\ (trigger)], ancho: 4.0, alto: 1.2)
    bloque(7.4, -0.2, [B. BASE DE TIEMPO\ (Time/Div)], ancho: 4.0, alto: 1.2)
    bloque(9.4, 2.6, [PANTALLA\ TRC / LCD], ancho: 2.8, alto: 1.8)
    // señal de entrada
    flecha((-0.6, 2.6), (0.4, 2.6))
    cetz.draw.content((-0.7, 2.6), text(size: letra-figura)[señal\ (BNC)], anchor: "east")
    // vertical a la pantalla: entra por las placas Y
    flecha((4.4, 2.6), (8.0, 2.6))
    cetz.draw.content((6.2, 2.72), text(size: letra-figura, fill: luma(100))[desvío vertical], anchor: "south")
    // vertical al disparo
    flecha((2.4, 1.7), (2.4, 0.4))
    // disparo a la base de tiempo
    flecha((4.4, -0.2), (5.4, -0.2))
    // base de tiempo a la pantalla: placas X
    cetz.draw.line((7.4, 0.4), (7.4, 1.2), stroke: trazo-cable + c-trazo)
    cetz.draw.line((7.4, 1.2), (9.4, 1.2), stroke: trazo-cable + c-trazo)
    flecha((9.4, 1.2), (9.4, 1.7))
    cetz.draw.content((8.4, 0.62), text(size: letra-figura, fill: luma(100))[barrido horizontal], anchor: "south")
  },
)


// ---------------------------------------------------------------
//  Módulo 5 — Fuentes de alimentación
// ---------------------------------------------------------------

#let fig-bloques-fuente() = esquema(
  escala: 0.8cm,
  {
    import zap: *
    let xs = (1.55, 4.55, 7.55, 10.55)
    let nombres = ([TRANSFOR-\ MADOR], [RECTIFI-\ CADOR], [FILTRO], [REGULADOR])
    for (i, x) in xs.enumerate() {
      bloque(x, 3.0, nombres.at(i), ancho: 2.3, alto: 1.3)
      cetz.draw.content((x, 2.05), text(size: letra-figura - 1pt, fill: luma(110))[(#{ i + 1 })], anchor: "north")
      if i < xs.len() - 1 { flecha((x + 1.15, 3.0), (x + 1.85, 3.0)) }
    }
    flecha((-0.5, 3.0), (0.4, 3.0))
    cetz.draw.content((-0.6, 3.0), text(size: letra-figura)[220 V∼\ 50 Hz], anchor: "east")
    flecha((11.7, 3.0), (12.6, 3.0))
    cetz.draw.content((12.7, 3.0), text(size: letra-figura)[CARGA], anchor: "west")
    // qué sale de cada etapa
    let ondas = (
      t => calc.sin(2 * calc.pi * 2 * t),
      t => calc.abs(calc.sin(2 * calc.pi * 2 * t)),
      t => {
        let u = calc.rem(t * 4, 1)
        if u < 0.22 { 0.72 + 0.16 * (u / 0.22) } else { 0.88 - 0.16 * ((u - 0.22) / 0.78) }
      },
      t => 0.8,
    )
    let pies = ([alterna], [un solo signo], [casi continua,\ con rizado], [continua estable])
    for (i, x) in xs.enumerate() {
      mini-onda(x - 0.97, 0.75, ondas.at(i))
      cetz.draw.content((x, -0.05), text(size: letra-figura - 1pt, fill: luma(100), pies.at(i)), anchor: "north")
    }
  },
)

// Filtro capacitivo a la salida del rectificador.
#let fig-filtro-capacitivo() = esquema({
  import zap: *
  acvsource("V", (0, 0), (0, 2.2), label: $v_e$)
  wire((0, 2.2), (0.45, 2.2))
  diode("D", (0.45, 2.2), (1.85, 2.2), label: $D$)
  wire((1.85, 2.2), (2.6, 2.2))
  node("c1", (2.6, 2.2))
  pcapacitor("C", (2.6, 2.2), (2.6, 0), label: (content: $C$, anchor: "south"))
  node("c2", (2.6, 0))
  wire((2.6, 0), (0, 0))
  wire((2.6, 2.2), (3.9, 2.2))
  node("r1", (3.9, 2.2))
  resistor("RL", (3.9, 2.2), (3.9, 0), label: $R_L$)
  node("r2", (3.9, 0))
  wire((3.9, 0), (2.6, 0))
  wire((3.9, 2.2), (4.8, 2.2))
  wire((3.9, 0), (4.8, 0))
  node("s1", (4.8, 2.2), fill: false)
  node("s2", (4.8, 0), fill: false)
  cetz.draw.content((4.95, 1.9), text(size: letra-figura)[$+$], anchor: "west")
  cetz.draw.content((4.95, 0.3), text(size: letra-figura)[$-$], anchor: "west")
  cetz.draw.content((5.35, 1.1), text(size: letra-figura)[$v_s$], anchor: "west")
  cetz.draw.line((5.3, 1.95), (5.3, 0.25), stroke: 0.5pt + c-guia, mark: (start: "straight", end: "straight", scale: 0.35))
})


// Regulador paralelo con diodo zener.
#let fig-regulador-zener() = esquema({
  import zap: *
  node("e1", (0, 2.3), fill: false)
  node("e2", (0, 0), fill: false)
  resistor("Rs", (0, 2.3), (1.9, 2.3), label: $R_S$)
  corriente((0.35, 1.75), (1.05, 1.75), $I_S$, ancla: "north")
  wire((1.9, 2.3), (2.6, 2.3))
  node("n1", (2.6, 2.3))
  // el zener va con el cátodo hacia arriba: trabaja en inversa
  zener("Dz", (2.6, 0), (2.6, 2.3), label: none)
  cetz.draw.content((2.78, 1.55), text(size: letra-figura, $D_Z$), anchor: "west")
  node("n2", (2.6, 0))
  wire((2.6, 2.3), (4.1, 2.3))
  node("n3", (4.1, 2.3))
  resistor("RL", (4.1, 2.3), (4.1, 0), label: $R_L$)
  node("n4", (4.1, 0))
  wire((4.1, 0), (0, 0))
  wire((4.1, 2.3), (5.0, 2.3))
  wire((4.1, 0), (5.0, 0))
  node("s1", (5.0, 2.3), fill: false)
  node("s2", (5.0, 0), fill: false)
  cetz.draw.content((-0.15, 1.15), text(size: letra-figura)[$V_"in"$\ (con rizado)], anchor: "east")
  cetz.draw.content((5.55, 1.15), text(size: letra-figura)[$V_"sal" = V_Z$], anchor: "west")
  cetz.draw.line((5.45, 1.95), (5.45, 0.35), stroke: 0.5pt + c-guia, mark: (start: "straight", end: "straight", scale: 0.35))
  corriente((2.2, 1.5), (2.2, 0.85), $I_Z$, ancla: "east")
  corriente((3.7, 1.5), (3.7, 0.85), $I_L$, ancla: "east")
})


// ---------------------------------------------------------------
//  Módulo 6 — Transistores y relés
// ---------------------------------------------------------------

// Símbolos del BJT con sus tres patas rotuladas.
#let _simbolo-bjt(tipo) = esquema(
  escala: 1.05cm,
  {
    import zap: *
    let arriba = if tipo == "npn" { 1 } else { -1 }
    if tipo == "npn" { npn("Q", (0, 0)) } else { pnp("Q", (0, 0)) }
    wire("Q.b", (-1.1, 0))
    wire("Q.c", (rel: (0, 0.75 * arriba), to: "Q.c"))
    wire("Q.e", (rel: (0, -0.75 * arriba), to: "Q.e"))
    cetz.draw.content((-1.15, 0), text(size: letra-figura)[B], anchor: "east")
    cetz.draw.content((rel: (0.14, 0.8 * arriba), to: "Q.c"), text(size: letra-figura)[C], anchor: "west")
    cetz.draw.content((rel: (0.14, -0.8 * arriba), to: "Q.e"), text(size: letra-figura)[E], anchor: "west")
  },
)

#let fig-simbolos-bjt() = paneles(
  ("NPN — la flecha sale del emisor", _simbolo-bjt("npn")),
  ("PNP — la flecha entra al emisor", _simbolo-bjt("pnp")),
)

// Etapa de conmutación con un NPN.
#let fig-conmutacion-npn() = esquema({
  import zap: *
  // Todo cuelga de las patas del transistor: los tres bornes del
  // símbolo no están alineados con su punto de inserción, así que las
  // coordenadas se toman relativas a "Q.c", "Q.b" y "Q.e", nunca a mano.
  npn("Q", (2.4, 1.5))
  let c-carga-inf = (rel: (0, 0.5), to: "Q.c")
  let c-carga-sup = (rel: (0, 2.1), to: "Q.c")
  let c-vcc = (rel: (0, 2.6), to: "Q.c")
  let e-masa = (rel: (0, -1.0), to: "Q.e")
  let b-int = (rel: (-1.0, 0), to: "Q.b")
  let b-ext = (rel: (-2.6, 0), to: "Q.b")
  wire("Q.c", c-carga-inf)
  resistor("RC", c-carga-inf, c-carga-sup, label: [carga])
  wire(c-carga-sup, c-vcc)
  vcc("Vcc", c-vcc)
  cetz.draw.content((rel: (0.2, 0.05), to: c-vcc), text(size: letra-figura)[$+V_"cc"$ (12 V)], anchor: "west")
  wire("Q.e", e-masa)
  ground("GND", e-masa)
  resistor("RB", b-ext, b-int, label: $R_B$)
  wire(b-int, "Q.b")
  node("ent", b-ext, fill: false)
  cetz.draw.content((rel: (-0.15, 0), to: b-ext), text(size: letra-figura)[$v_"in"$\ (0 V ó 5 V)], anchor: "east")
  corriente(
    (rel: (-1.9, -0.45), to: "Q.b"),
    (rel: (-1.2, -0.45), to: "Q.b"),
    $I_B$,
    ancla: "north",
  )
  corriente(
    (rel: (0.45, 1.55), to: "Q.c"),
    (rel: (0.45, 0.85), to: "Q.c"),
    $I_C$,
    ancla: "west",
  )
})

// Etapa completa con relé y diodo de rueda libre.
#let fig-rele-completo() = esquema({
  import zap: *
  npn("Q", (3.0, 1.5))
  let col = (rel: (0, 1.1), to: "Q.c") // nodo inferior de la bobina
  let sup = (rel: (0, 3.0), to: "Q.c") // riel de +12 V
  let e-masa = (rel: (0, -1.0), to: "Q.e")
  let b-int = (rel: (-1.0, 0), to: "Q.b")
  let b-ext = (rel: (-2.8, 0), to: "Q.b")
  // riel de alimentación
  wire("Q.c", col)
  node("inf", col)
  wire((rel: (-1.3, 0), to: col), (rel: (1.3, 0), to: col))
  wire((rel: (-1.3, 0), to: sup), (rel: (1.3, 0), to: sup))
  node("sup", sup)
  wire(sup, (rel: (0, 0.5), to: sup))
  vcc("Vcc", (rel: (0, 0.5), to: sup))
  cetz.draw.content((rel: (0.2, 0.55), to: sup), text(size: letra-figura)[$+12$ V], anchor: "west")
  // bobina del relé, y el diodo de rueda libre en paralelo con ella
  inductor("L", (rel: (1.3, 0), to: sup), (rel: (1.3, 0), to: col))
  cetz.draw.content((rel: (1.95, 2.05), to: "Q.c"), text(size: letra-figura)[bobina\ del relé], anchor: "west")
  diode("Dp", (rel: (-1.3, 0), to: col), (rel: (-1.3, 0), to: sup), label: none)
  cetz.draw.content((rel: (-1.85, 2.05), to: "Q.c"), text(size: letra-figura)[$D$\ 1N4007], anchor: "east")
  // transistor
  wire("Q.e", e-masa)
  ground("GND", e-masa)
  resistor("RB", b-ext, b-int, label: [1,5 kΩ])
  wire(b-int, "Q.b")
  node("ent", b-ext, fill: false)
  cetz.draw.content((rel: (-0.15, 0), to: b-ext), text(size: letra-figura)[$v_"in"$], anchor: "east")
  // contactos del relé: acoplados a la bobina, no conectados a ella
  let kx = 6.6
  let ky = 3.6
  cetz.draw.line(
    (rel: (1.55, 2.05), to: "Q.c"),
    (kx - 0.3, ky),
    stroke: (paint: luma(120), thickness: 0.6pt, dash: "dotted"),
  )
  cetz.draw.line((kx, ky), (kx + 0.95, ky + 0.5), stroke: trazo-simbolo + c-trazo)
  cetz.draw.circle((kx, ky), radius: 0.07, fill: black, stroke: trazo-simbolo)
  cetz.draw.circle((kx + 1.0, ky), radius: 0.07, stroke: trazo-simbolo, fill: white)
  cetz.draw.line((kx, ky), (kx, ky - 1.1), stroke: trazo-cable + c-trazo)
  cetz.draw.line((kx + 1.0, ky), (kx + 1.0, ky - 1.1), stroke: trazo-cable + c-trazo)
  node("k1", (kx, ky - 1.1), fill: false)
  node("k2", (kx + 1.0, ky - 1.1), fill: false)
  cetz.draw.content((kx + 0.5, ky + 0.8), text(size: letra-figura)[contactos NA], anchor: "center")
  cetz.draw.content((kx + 0.5, ky - 1.3), text(size: letra-figura, fill: luma(100))[a la carga\ de potencia], anchor: "north")
})


// ---------------------------------------------------------------
//  Anexos
// ---------------------------------------------------------------

// Código de colores: un resistor con sus cuatro bandas y qué es cada una.
#let fig-codigo-colores() = esquema(
  escala: 1.0cm,
  {
    import zap: *
    let (x0, x1, y) = (0.6, 4.4, 0)
    let alto = 0.62
    // patas
    cetz.draw.line((x0 - 0.9, y), (x0, y), stroke: trazo-cable + c-trazo)
    cetz.draw.line((x1, y), (x1 + 0.9, y), stroke: trazo-cable + c-trazo)
    // cuerpo
    cetz.draw.rect(
      (x0, y - alto),
      (x1, y + alto),
      stroke: trazo-simbolo + c-trazo,
      fill: rgb("#E8D6B3"),
      radius: 0.18,
    )
    // bandas: amarillo, violeta, rojo, dorado = 4700 ohm ± 5 %
    let bandas = (
      (1.15, rgb("#E8B21E"), [1.ª cifra\ *amarillo* = 4]),
      (1.85, rgb("#7D3C98"), [2.ª cifra\ *violeta* = 7]),
      (2.55, rgb("#C0392B"), [multiplicador\ *rojo* = ×100]),
      (3.95, rgb("#C9A227"), [tolerancia\ *dorado* = ±5 %]),
    )
    let ys = (-1.65, -2.65, -3.65, -4.65)
    for (i, b) in bandas.enumerate() {
      let (bx, color, rotulo) = b
      cetz.draw.rect(
        (bx - 0.17, y - alto),
        (bx + 0.17, y + alto),
        stroke: none,
        fill: color,
      )
      cetz.draw.line(
        (bx, y - alto),
        (bx, ys.at(i)),
        stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"),
      )
      cetz.draw.line((bx, ys.at(i)), (5.5, ys.at(i)), stroke: (paint: c-guia, thickness: 0.5pt, dash: "dashed"))
      cetz.draw.content((5.6, ys.at(i)), text(size: letra-figura, rotulo), anchor: "west")
    }
    cetz.draw.content(
      (2.5, 1.05),
      text(size: letra-figura, fill: luma(90))[la tolerancia va separada del resto: por ahí se empieza a leer],
      anchor: "south",
    )
    cetz.draw.content(
      (2.5, -5.5),
      text(size: letra-figura)[$47 times 100 = 4700 space Omega plus.minus 5 % = 4"k"7$],
      anchor: "north",
    )
  },
)

// Tabla de símbolos: los mismos que se usan en todo el apunte.
#let fig-tabla-simbolos() = {
  let celda(rotulo, dibujo) = block(width: 100%, breakable: false)[
    #align(center)[
      // alto fijo: si no, cada símbolo empuja su rótulo a otra altura y
      // la grilla queda con los pies desparejos
      #box(height: 1.15cm, align(horizon, dibujo))
      #v(1pt)
      #text(size: 8pt, fill: luma(85))[#rotulo]
    ]
  ]
  let s(cuerpo) = esquema(escala: 0.62cm, cuerpo)
  align(center, block(width: 96%, grid(
    columns: (1fr,) * 5,
    row-gutter: 13pt,
    column-gutter: 4pt,
    celda([resistor], s({ import zap: *; resistor("R", (0, 0), (2, 0)) })),
    celda([potenciómetro], s({ import zap: *; potentiometer("P", (0, 0), (2, 0)) })),
    celda([capacitor], s({ import zap: *; capacitor("C", (0, 0), (2, 0)) })),
    celda([capacitor electrolítico], s({ import zap: *; pcapacitor("C", (0, 0), (2, 0)) })),
    celda([bobina], s({ import zap: *; inductor("L", (0, 0), (2, 0)) })),
    celda([diodo], s({ import zap: *; diode("D", (0, 0), (2, 0)) })),
    celda([diodo zener], s({ import zap: *; zener("D", (0, 0), (2, 0)) })),
    celda([LED], s({ import zap: *; led("D", (0, 0), (2, 0)) })),
    celda([transistor NPN], s({
      import zap: *
      npn("Q", (1, 0))
      wire("Q.b", (0.1, 0))
      wire("Q.c", (rel: (0, 0.45), to: "Q.c"))
      wire("Q.e", (rel: (0, -0.45), to: "Q.e"))
    })),
    celda([transistor PNP], s({
      import zap: *
      pnp("Q", (1, 0))
      wire("Q.b", (0.1, 0))
      wire("Q.c", (rel: (0, 0.45), to: "Q.c"))
      wire("Q.e", (rel: (0, -0.45), to: "Q.e"))
    })),
    celda([fuente de continua], s({ import zap: *; cell("V", (0, 0), (2, 0)) })),
    celda([fuente de alterna], s({ import zap: *; acvsource("V", (0, 0), (2, 0)) })),
    celda([transformador], s({
      import zap: *
      inductor("L1", (0, 0.9), (0, -0.9))
      inductor("L2", (1.1, -0.9), (1.1, 0.9))
      _nucleo(0.45, -1.15, 1.15)
    })),
    celda([lámpara], s({ import zap: *; lamp("L", (0, 0), (2, 0)) })),
    celda([fusible], s({ import zap: *; fuse("F", (0, 0), (2, 0)) })),
    celda([llave], s({ import zap: *; switch("S", (0, 0), (2, 0)) })),
    celda([voltímetro], s({ import zap: *; voltmeter("V", (0, 0), (2, 0)) })),
    celda([amperímetro], s({ import zap: *; ammeter("A", (0, 0), (2, 0)) })),
    celda([galvanómetro], s({ import zap: *; round-meter("G", (0, 0), (2, 0), measurand: "G") })),
    celda([masa], s({
      import zap: *
      wire((0, 0.6), (0, 0))
      ground("M", (0, 0))
    })),
  )))
}
