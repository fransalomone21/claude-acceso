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
  // Más separado del símbolo: a 2,5 el rótulo quedaba pegado al vértice del
  // triángulo del LED.
  cetz.draw.content((2.15, 1.45), text(size: letra-figura)[LED\ $V_F$], anchor: "east")
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
  // D2 va de `de` a `ar`: ANODO en el borne derecho de la fuente, CATODO en
  // el vertice positivo de salida. Al reves (ar -> de) queda en serie y en
  // directa con D1 durante el semiciclo positivo, y los dos juntos cortocircuitan
  // la fuente por un camino de menor resistencia que R_L.
  diode("D2", de, ar, label: none)
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
  // El rotulo va con el anclaje por defecto: forzando "east" queda sobre el
  // borde del circulo y la "e" del subindice se pierde adentro del simbolo.
  acvsource("V", (0.3, -2.7), (0.3, 0), label: $v_e$)
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
    // A la derecha del tramo vertical que sube a la pantalla, no centrado
    // sobre él: centrado, el texto (más ancho que el hueco entre las dos
    // patas verticales) quedaba con la pata izquierda atravesándolo.
    cetz.draw.content((9.55, 1.45), text(size: letra-figura, fill: luma(100))[barrido horizontal], anchor: "west")
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


// ---------------------------------------------------------------
//  Módulo 7 — Kirchhoff y topología
// ---------------------------------------------------------------
//
//  De acá en adelante las figuras llevan encima la NOTACIÓN del método
//  —el número del nodo, el giro de la malla, el recuadro del supernodo—.
//  Los ayudantes que la dibujan (marca-nodo, nodo-referencia, giro-malla,
//  recuadro-super) están en estilo.typ, resueltos una sola vez.
//
//  Dos cosas verificadas por render que no son obvias:
//
//  - Las fuentes de corriente van con variant "ieee". El símbolo IEC de zap
//    es un círculo con una raya y NO muestra hacia dónde va la corriente,
//    que es justo el dato con el que se plantea la ecuación de nodos.
//
//  - Los valores de un resistor vertical van con `valor(...)` en dos
//    renglones y nunca con el `label:` de zap: el rótulo automático de un
//    símbolo rotado cae sobre una punta, y un `$R = 4 Omega$` en una sola
//    línea mide más de una unidad de lienzo y pisa al vecino.

// El circuito de dos nodos esenciales y dos mallas, con la topología marcada.
#let fig-nodos-y-mallas() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.4)
  vsource("V1", (0, yb), (0, ya), label: none)
  rotulo((-0.45, 1.62), $+$, ancla: "east")
  rotulo((-0.45, 0.78), $-$, ancla: "east")
  rotulo((-0.75, 1.2), $V_1$, ancla: "east")
  wire((0, ya), (0.6, ya))
  resistor("R1", (0.6, ya), (2.0, ya), label: $R_1$)
  wire((2.0, ya), (2.6, ya))
  resistor("R2", (2.6, ya), (2.6, yb), label: none)
  rotulo((3.02, 1.2), $R_2$)
  wire((2.6, ya), (3.2, ya))
  resistor("R3", (3.2, ya), (4.6, ya), label: $R_3$)
  wire((4.6, ya), (5.2, ya))
  isource("I1", (5.2, yb), (5.2, ya), label: none, variant: "ieee")
  rotulo((5.8, 1.2), $I_1$)
  wire((0, yb), (5.2, yb))
  giro-malla((1.3, 1.2), [1])
  giro-malla((4.1, 1.2), [2])
  marca-nodo((2.6, ya), [a], hacia: "n")
  nodo-referencia((2.6, yb), etiqueta: [b], nombre: "gb")
})

// Las dos redes de tres terminales del teorema de Kennelly.
#let fig-delta-estrella() = paneles(
  (
    "Triángulo (Δ)",
    esquema({
      import zap: *
      let (a, b, c) = ((1.65, 3.2), (0, 0), (3.3, 0))
      resistor("Rc", b, a, label: $R_c$)
      resistor("Rb", a, c, label: $R_b$)
      resistor("Ra", b, c, label: $R_a$)
      marca-nodo(a, [a], hacia: "n")
      marca-nodo(b, [b], hacia: "so")
      marca-nodo(c, [c], hacia: "se")
    }),
  ),
  (
    "Estrella (Y)",
    esquema({
      import zap: *
      let (a, n, b, c) = ((1.65, 3.2), (1.65, 1.45), (0, 0), (3.3, 0))
      resistor("R1", a, n, label: none)
      rotulo((1.88, 2.32), $R_1$)
      resistor("R2", n, b, label: $R_2$)
      resistor("R3", n, c, label: $R_3$)
      marca-nodo(a, [a], hacia: "n")
      marca-nodo(b, [b], hacia: "so")
      marca-nodo(c, [c], hacia: "se")
      // El nodo central tiene tres ramas encima: las unicas direcciones libres
      // son el este y el oeste, y el este lo ocupa el rotulo de R3.
      marca-nodo(n, [n], hacia: "o", sep: 0.9)
    }),
  ),
)

// ---------------------------------------------------------------
//  Módulo 8 — Análisis nodal y de mallas
// ---------------------------------------------------------------

// El PRIMER circuito nodal del modulo: un solo nodo incognita. Las dos
// flechas de corriente salen del nodo 1 a proposito -- son la convencion con
// la que se escribe la ecuacion, no el sentido real: i_1 va a dar negativa.
// Sin las flechas dibujadas, la convencion se cuenta y no se ve, que es
// justamente lo que costaba entender.
#let fig-nodal-primero() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.4)
  let x1 = 2.9
  vsource("V", (0, yb), (0, ya), label: none)
  rotulo((-0.45, 1.62), $+$, ancla: "east")
  rotulo((-0.45, 0.78), $-$, ancla: "east")
  rotulo((-0.75, 1.2), [12 V], ancla: "east")
  wire((0, ya), (0.6, ya))
  resistor("R1", (0.6, ya), (2.0, ya), label: $R_1 = 4 Omega$)
  wire((2.0, ya), (x1, ya))
  resistor("R2", (x1, ya), (x1, yb), label: none)
  valor((x1 + 0.42, 1.2), $R_2$, $2 Omega$)
  wire((x1, ya), (4.8, ya))
  isource("Is", (4.8, yb), (4.8, ya), label: none, variant: "ieee")
  rotulo((5.5, 1.2), [3 A])
  wire((0, yb), (4.8, yb))
  corriente((2.62, ya + 0.40), (2.05, ya + 0.40), $i_1$)
  corriente((x1 - 0.42, 1.62), (x1 - 0.42, 0.78), $i_2$, ancla: "east")
  marca-nodo((0, ya), [A], hacia: "no")
  marca-nodo((x1, ya), [1], hacia: "ne")
  nodo-referencia((3.85, yb), etiqueta: [0], nombre: "g0")
})

// Dos nodos incógnita entre dos fuentes de corriente: el caso base del nodal.
#let fig-nodal-basico() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.3)
  let (x1, x2) = (1.7, 5.2)
  let yc = 1.15
  isource("Ia", (0, yb), (0, ya), label: none, variant: "ieee")
  rotulo((-0.7, yc), [6 A], ancla: "east")
  wire((0, ya), (x1, ya))
  resistor("R1", (x1, ya), (x1, yb), label: none)
  valor((x1 + 0.42, yc), $R_1$, $2 Omega$)
  wire((x1, ya), (2.3, ya))
  resistor("R2", (2.3, ya), (4.6, ya), label: $R_2 = 4 Omega$)
  wire((4.6, ya), (x2, ya))
  resistor("R3", (x2, ya), (x2, yb), label: none)
  valor((x2 + 0.42, yc), $R_3$, $4 Omega$)
  wire((x2, ya), (6.9, ya))
  isource("Ib", (6.9, yb), (6.9, ya), label: none, variant: "ieee")
  rotulo((7.6, yc), [2 A])
  wire((0, yb), (6.9, yb))
  marca-nodo((x1, ya), [1], hacia: "n")
  marca-nodo((x2, ya), [2], hacia: "n")
  nodo-referencia((3.45, yb), etiqueta: [0], nombre: "g0")
})

// Fuente de tensión entre dos nodos incógnita: no se le puede escribir la
// corriente que la atraviesa, así que los dos nodos y la fuente se envuelven
// en un supernodo y se les escribe UNA sola ecuación de corrientes.
//
// La geometría de acá está atada: el borde de abajo del recuadro tiene que
// pasar por los conductores que bajan a los resistores —ahí es donde se
// escribe la LKC— sin cortar ni el cuerpo del resistor ni el círculo de la
// fuente. Por eso la barra de arriba está a 2,9 y no a 2,3.
#let fig-supernodo() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.9)
  let (x1, x2) = (1.7, 5.4)
  let yc = 1.45
  isource("Ia", (0, yb), (0, ya), label: none, variant: "ieee")
  rotulo((-0.7, yc), [4 A], ancla: "east")
  wire((0, ya), (x1, ya))
  resistor("R1", (x1, ya), (x1, yb), label: none)
  valor((x1 + 0.42, yc), $R_1$, $2 Omega$)
  wire((x1, ya), (2.6, ya))
  vsource("V12", (2.6, ya), (4.5, ya), label: none)
  rotulo((2.9, ya + 0.38), $-$, ancla: "south")
  rotulo((4.2, ya + 0.38), $+$, ancla: "south")
  rotulo((3.55, ya + 0.38), [12 V], ancla: "south")
  wire((4.5, ya), (x2, ya))
  resistor("R2", (x2, ya), (x2, yb), label: none)
  valor((x2 + 0.42, yc), $R_2$, $6 Omega$)
  wire((x2, ya), (6.6, ya))
  wire((6.6, ya), (6.6, yb))
  wire((0, yb), (6.6, yb))
  marca-nodo((x1, ya), [1], hacia: "no")
  marca-nodo((x2, ya), [2], hacia: "ne")
  nodo-referencia((3.3, yb), etiqueta: [0], nombre: "g0")
  recuadro-super((1.15, 2.25), (6.2, 3.82), [supernodo], donde: "n")
})

// El mismo circuito del nodal, resuelto ahora por corrientes de malla.
#let fig-mallas-basico() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.4)
  vsource("V1", (0, yb), (0, ya), label: none)
  rotulo((-0.45, 1.62), $+$, ancla: "east")
  rotulo((-0.45, 0.78), $-$, ancla: "east")
  rotulo((-0.75, 1.2), [$V_1 = 12$ V], ancla: "east")
  wire((0, ya), (0.6, ya))
  resistor("R1", (0.6, ya), (2.0, ya), label: $R_1 = 2 Omega$)
  wire((2.0, ya), (2.9, ya))
  resistor("R2", (2.9, ya), (2.9, yb), label: none)
  valor((3.32, 1.2), $R_2$, $4 Omega$)
  wire((2.9, ya), (3.9, ya))
  resistor("R3", (3.9, ya), (5.3, ya), label: $R_3 = 6 Omega$)
  wire((5.3, ya), (5.9, ya))
  vsource("V2", (5.9, yb), (5.9, ya), label: none)
  rotulo((6.35, 1.62), $+$)
  rotulo((6.35, 0.78), $-$)
  rotulo((6.65, 1.2), [$V_2 = 6$ V])
  wire((0, yb), (5.9, yb))
  giro-malla((1.45, 1.2), $i_A$)
  giro-malla((4.55, 1.2), $i_B$)
  marca-nodo((2.9, ya), [a], hacia: "n")
  marca-nodo((2.9, yb), [b], hacia: "s")
})

// Fuente de corriente compartida por dos mallas: el recorrido la saltea, y las
// dos mallas pasan a ser una sola. El recuadro se lleva adentro también los
// rótulos de la fuente: si el borde punteado pasa por el medio de un signo
// menos, lo convierte en un más. Pasó, y se vio en el render.
#let fig-supermalla() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.4)
  let xm = 3.2
  vsource("V", (0, yb), (0, ya), label: none)
  rotulo((-0.45, 1.62), $+$, ancla: "east")
  rotulo((-0.45, 0.78), $-$, ancla: "east")
  rotulo((-0.72, 1.2), [20 V], ancla: "east")
  wire((0, ya), (0.7, ya))
  resistor("R1", (0.7, ya), (2.1, ya), label: $R_1 = 2 Omega$)
  wire((2.1, ya), (xm, ya))
  isource("I4", (xm, yb), (xm, ya), label: none, variant: "ieee")
  rotulo((xm + 0.68, 1.2), [4 A])
  wire((xm, ya), (4.3, ya))
  resistor("R2", (4.3, ya), (5.7, ya), label: $R_2 = 6 Omega$)
  wire((5.7, ya), (6.4, ya))
  wire((6.4, ya), (6.4, yb))
  wire((0, yb), (6.4, yb))
  giro-malla((1.6, 1.2), $i_A$)
  giro-malla((4.95, 1.2), $i_B$)
  recuadro-super((-1.75, -0.55), (7.0, ya + 0.9), [supermalla], donde: "n")
})

// Nodal con una fuente controlada: la corriente de control se marca sobre la
// rama de donde sale, porque la ecuación de vínculo la necesita nombrada.
#let fig-nodal-controlada() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.3)
  let (x1, x2) = (1.7, 5.2)
  let yc = 1.15
  isource("Ia", (0, yb), (0, ya), label: none, variant: "ieee")
  rotulo((-0.7, yc), [2 A], ancla: "east")
  wire((0, ya), (x1, ya))
  resistor("R1", (x1, ya), (x1, yb), label: none)
  valor((x1 - 0.42, yc), $R_1$, $3 Omega$, ancla: "east")
  corriente((x1 + 0.42, 1.5), (x1 + 0.42, 0.8), $i_x$, ancla: "west")
  wire((x1, ya), (2.3, ya))
  resistor("R2", (2.3, ya), (4.6, ya), label: $R_2 = 6 Omega$)
  wire((4.6, ya), (x2, ya))
  resistor("R3", (x2, ya), (x2, yb), label: none)
  valor((x2 + 0.42, yc), $R_3$, $3 Omega$)
  wire((x2, ya), (7.0, ya))
  disource("Ib", (7.0, yb), (7.0, ya), label: none, variant: "ieee")
  rotulo((7.7, 1.4), $2 i_x$)
  rotulo((7.7, 0.9), text(fill: c-viole)[CCCS])
  wire((0, yb), (7.0, yb))
  marca-nodo((x1, ya), [1], hacia: "n")
  marca-nodo((x2, ya), [2], hacia: "n")
  nodo-referencia((3.45, yb), etiqueta: [0], nombre: "g0")
})


// ---------------------------------------------------------------
//  Módulo 9 — Teoremas de redes
// ---------------------------------------------------------------

// Las dos fuentes reales de la transformación de fuentes.
#let fig-fuentes-reales() = paneles(
  (
    "Modelo de tensión",
    esquema({
      import zap: *
      vsource("Vs", (0, 0), (0, 2.2), label: none)
      rotulo((-0.45, 1.52), $+$, ancla: "east")
      rotulo((-0.45, 0.68), $-$, ancla: "east")
      rotulo((-0.75, 1.1), $V_s$, ancla: "east")
      wire((0, 2.2), (0.6, 2.2))
      resistor("Rs", (0.6, 2.2), (2.0, 2.2), label: $R_s$)
      wire((2.0, 2.2), (2.8, 2.2))
      wire((0, 0), (2.8, 0))
      node("a", (2.8, 2.2), fill: false)
      node("b", (2.8, 0), fill: false)
      rotulo((3.0, 2.2), $a$)
      rotulo((3.0, 0), $b$)
    }),
  ),
  (
    "Modelo de corriente",
    esquema({
      import zap: *
      isource("Is", (0, 0), (0, 2.2), label: none, variant: "ieee")
      rotulo((-0.7, 1.1), $I_s$, ancla: "east")
      wire((0, 2.2), (1.5, 2.2))
      resistor("Rp", (1.5, 2.2), (1.5, 0), label: none)
      rotulo((1.92, 1.1), $R_p$)
      wire((1.5, 2.2), (2.8, 2.2))
      wire((0, 0), (2.8, 0))
      node("a", (2.8, 2.2), fill: false)
      node("b", (2.8, 0), fill: false)
      rotulo((3.0, 2.2), $a$)
      rotulo((3.0, 0), $b$)
    }),
  ),
)

// ---------------------------------------------------------------
//  Módulo 10 — Transitorios
// ---------------------------------------------------------------

// RC de primer orden con fuente y llave: el circuito del método de los tres datos.
#let fig-rc-primer-orden() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.4)
  vsource("V", (0, yb), (0, ya), label: none)
  rotulo((-0.45, 1.62), $+$, ancla: "east")
  rotulo((-0.45, 0.78), $-$, ancla: "east")
  rotulo((-0.75, 1.2), [20 V], ancla: "east")
  wire((0, ya), (0.5, ya))
  switch("S", (0.5, ya), (1.7, ya), label: none)
  rotulo((1.1, ya + 0.5), $t = 0$, ancla: "south")
  rotulo((1.1, ya - 0.18), $S$, ancla: "north")
  wire((1.7, ya), (2.2, ya))
  resistor("R1", (2.2, ya), (3.6, ya), label: $R_1 = 5 "k"Omega$)
  wire((3.6, ya), (4.4, ya))
  capacitor("C", (4.4, ya), (4.4, yb), label: none)
  valor((4.82, 1.2), $C$, $2 "µF"$)
  wire((4.4, ya), (6.0, ya))
  resistor("R2", (6.0, ya), (6.0, yb), label: none)
  valor((6.42, 1.2), $R_2$, $20 "k"Omega$)
  wire((0, yb), (6.0, yb))
})

// ---------------------------------------------------------------
//  Módulo 11 — Fasores
// ---------------------------------------------------------------

// RLC serie alimentado por una fuente senoidal.
#let fig-rlc-serie() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.4)
  acvsource("V", (0, yb), (0, ya), label: none)
  rotulo((-0.7, 1.2), [$overline(V) = 100 angle 0 degree$ V\ $omega = 1000$ rad/s], ancla: "east")
  wire((0, ya), (0.6, ya))
  resistor("R", (0.6, ya), (2.0, ya), label: $R = 30 Omega$)
  corriente((0.15, ya - 0.4), (0.95, ya - 0.4), $overline(I)$, ancla: "north")
  wire((2.0, ya), (2.7, ya))
  inductor("L", (2.7, ya), (4.1, ya), label: [$L = 60$ mH])
  wire((4.1, ya), (4.8, ya))
  capacitor("C", (4.8, ya), (6.2, ya), label: $C = 50 "µF"$)
  wire((6.2, ya), (6.9, ya))
  wire((6.9, ya), (6.9, yb))
  wire((0, yb), (6.9, yb))
})

// ---------------------------------------------------------------
//  Módulo 12 — Respuesta en frecuencia
// ---------------------------------------------------------------

// El mismo RC, con la salida tomada en dos lugares distintos.
#let _celda-rc(alto: false) = esquema({
  import zap: *
  let (yb, ya) = (-0.6, 1.1)
  node("in+", (0, ya), fill: false)
  node("in-", (0, yb), fill: false)
  if alto {
    capacitor("C", (0, ya), (2.2, ya), label: $C$)
    node("m", (2.2, ya))
    resistor("R", (2.2, ya), (2.2, yb), label: none)
    rotulo((2.62, 0.25), $R$)
  } else {
    resistor("R", (0, ya), (2.2, ya), label: $R$)
    node("m", (2.2, ya))
    capacitor("C", (2.2, ya), (2.2, yb), label: none)
    rotulo((2.62, 0.25), $C$)
  }
  node("m2", (2.2, yb))
  wire((2.2, ya), (3.6, ya))
  wire((0, yb), (3.6, yb))
  node("out+", (3.6, ya), fill: false)
  node("out-", (3.6, yb), fill: false)
  rotulo((-0.15, 0.25), $overline(V)_e$, ancla: "east")
  rotulo((3.75, 0.25), $overline(V)_s$)
})

#let fig-pasabajos-pasaaltos() = paneles(
  ("Pasa bajos: salida sobre C", _celda-rc()),
  ("Pasa altos: salida sobre R", _celda-rc(alto: true)),
)

// ---------------------------------------------------------------
//  Módulo 13 — Cuadripolos y amplificador operacional
// ---------------------------------------------------------------

// La caja de dos puertos con sus cuatro variables. Las dos corrientes entran:
// es la convención del apunte y la que hace simétricas las cuatro matrices.
#let fig-cuadripolo() = esquema({
  import zap: *
  let (yb, ya) = (0, 2.2)
  let (xi, xd) = (1.1, 5.1)
  cetz.draw.rect(
    (xi, yb - 0.25),
    (xd, ya + 0.25),
    stroke: trazo-simbolo + c-trazo,
    fill: white,
  )
  // El texto va en una caja de ancho FIJO y centrada. Sin ancho, cetz lo deja
  // crecer en una sola linea y se sale del rectangulo por los dos lados.
  cetz.draw.content(
    ((xi + xd) / 2, (ya + yb) / 2),
    box(width: 3.3cm)[
      #set text(size: letra-figura)
      #set par(justify: false, leading: 0.5em)
      #align(center)[CUADRIPOLO\ (lineal, sin fuentes\ independientes internas)]
    ],
  )
  wire((0, ya), (xi, ya))
  wire((0, yb), (xi, yb))
  wire((xd, ya), (5.8, ya))
  wire((xd, yb), (5.8, yb))
  node("e1", (0, ya), fill: false)
  node("e2", (0, yb), fill: false)
  node("s1", (5.8, ya), fill: false)
  node("s2", (5.8, yb), fill: false)
  corriente((0.35, ya + 0.35), (1.05, ya + 0.35), $overline(I)_1$)
  corriente((5.45, ya + 0.35), (4.75, ya + 0.35), $overline(I)_2$)
  // Cotas de las dos tensiones de puerto.
  rotulo((-0.18, ya - 0.25), $+$, ancla: "east")
  rotulo((-0.18, yb + 0.25), $-$, ancla: "east")
  rotulo((-0.6, (ya + yb) / 2), $overline(V)_1$, ancla: "east")
  rotulo((5.98, ya - 0.25), $+$)
  rotulo((5.98, yb + 0.25), $-$)
  rotulo((6.4, (ya + yb) / 2), $overline(V)_2$)
})

// ---------------------------------------------------------------
//  Módulo 14 — El amplificador operacional
//
//  Geometría común de las diez figuras. Estas constantes NO son números
//  elegidos a ojo: son las medidas del símbolo `opamp` de zap —1,8 × 1,75,
//  con las dos entradas a ±0,45 del centro sobre el borde izquierdo—. Si el
//  símbolo cambia de tamaño, cambian acá y las diez figuras siguen cerrando.
//
//  El opamp va con variant "ieee": el símbolo IEC de zap es un rectángulo con
//  los signos adentro, y el triángulo es el que ve el alumno en todos lados.
//  Los resistores y las fuentes quedan en el default de zap, que es el que ya
//  usan las otras treinta figuras del apunte.
//
//  Tres reglas de dibujo, las tres pagadas con una vuelta de render:
//    · EL LARGO MÍNIMO DE UN RESISTOR ES 1,7. El cuerpo del símbolo mide 1,41
//      unidades y es FIJO: un tramo más corto no lo comprime, lo hace
//      DESBORDAR sus propios terminales, y el pico que se sale parece un
//      componente más;
//    · dos tramos rectos del mismo nodo no pueden compartir la recta, o el
//      dibujo muestra un cable donde hay dos;
//    · un rótulo va donde no haya otro rótulo, no donde haya lugar.
// ---------------------------------------------------------------

// El centro es 3,4 y no 3,0 por una razón medida en el render: con 3,0 el nodo
// del cortocircuito virtual queda a 0,4 unidades del borde del triángulo y su
// rótulo sale estrangulado contra el símbolo. Correr el AO a la derecha da 0,8
// y arregla las SEIS figuras de una vez, que es justamente para lo que estas
// medidas son constantes y no números repetidos figura por figura.
#let ao-cx = 3.4 // centro del AO
#let ao-cy = 2.0
#let ao-xin = ao-cx - 0.9 // borde de entrada (x de las dos patas)
#let ao-xout = ao-cx + 0.9 // vértice de salida
#let ao-ym = ao-cy + 0.45 // entrada inversora  (−)
#let ao-yp = ao-cy - 0.45 // entrada no inversora (+)
#let ao-yfb = 4.5 // altura del camino de realimentación
#let ao-xfb = 5.1 // bajada de la realimentación hasta la salida
#let ao-xo = 5.9 // terminal de salida

// El AO con sus dos rieles de alimentación. Los rieles salen de los bordes
// inclinados del triángulo y terminan en un círculo abierto: es un terminal de
// alimentación, no un nodo de la señal. Se dibujan SIEMPRE, aunque no entren en
// ninguna cuenta, porque son los que fijan el techo y el piso de la salida — y
// el alumno que no los ve dibujados es el que después no entiende la saturación.
#let _ao-ideal(rieles: true) = {
  import zap: *
  opamp("A", (ao-cx, ao-cy), variant: "ieee")
  if rieles {
    wire((ao-cx, ao-cy + 0.52), (ao-cx, ao-cy + 1.2))
    node("vcc", (ao-cx, ao-cy + 1.2), fill: false)
    rotulo((ao-cx + 0.14, ao-cy + 1.2), $+V_"CC"$)
    wire((ao-cx, ao-cy - 0.52), (ao-cx, ao-cy - 1.2))
    node("vee", (ao-cx, ao-cy - 1.2), fill: false)
    rotulo((ao-cx + 0.14, ao-cy - 1.2), $-V_"CC"$)
  }
}

// El terminal de salida: cable, círculo abierto y rótulo.
#let _ao-salida(etiqueta: $v_o$) = {
  import zap: *
  wire((ao-xout, ao-cy), (ao-xo, ao-cy))
  node("s", (ao-xo, ao-cy), fill: false)
  rotulo((ao-xo + 0.15, ao-cy), etiqueta)
}

// Rótulo de una fuente vertical, a la izquierda de su círculo. El 0,55 no es
// estético: el círculo de zap tiene radio 0,4 y el texto necesita salir de ahí;
// con menos, el subíndice queda apoyado sobre el trazo.
#let _ao-rot-fuente(x, y0, y1, cuerpo) = rotulo(
  (x - 0.55, (y0 + y1) / 2),
  cuerpo,
  ancla: "east",
)

// El rótulo del nodo del cortocircuito virtual. Va ENCIMA del tramo que une el
// nodo con la pata inversora, que es el único lugar que lo vuelve inequívoco:
// arriba y a la izquierda se pega al rótulo del resistor de entrada y se lee
// "R_1 v_x"; colgado abajo, en el seguidor queda sobre el cable de la entrada NO
// inversora, que es justo el nodo que no es.
#let _ao-rot-v(x) = rotulo((x + 0.2, ao-ym + 0.12), $v_x$, ancla: "south")

// --- 1. Anatomía del símbolo -----------------------------------------
// Las cinco patas rotuladas y nada más. Es la única figura del módulo donde el
// AO no está conectado a nada: se mira el componente, no un circuito.
#let fig-ao-terminales() = esquema({
  import zap: *
  _ao-ideal()
  wire((ao-xin, ao-ym), (1.1, ao-ym))
  node("em", (1.1, ao-ym), fill: false)
  rotulo((0.92, ao-ym), $v_-$, ancla: "east")
  wire((ao-xin, ao-yp), (1.1, ao-yp))
  node("ep", (1.1, ao-yp), fill: false)
  rotulo((0.92, ao-yp), $v_+$, ancla: "east")
  _ao-salida()
  // la diferencia de entrada, que es lo único que el AO mira
  cetz.draw.line(
    (1.55, ao-ym - 0.08),
    (1.55, ao-yp + 0.08),
    stroke: punteado,
    mark: (start: "straight", end: "straight", scale: 0.35),
  )
  rotulo((1.42, ao-cy), $v_d$, ancla: "east", color: c-azul)
})

// --- 2. Lazo abierto --------------------------------------------------
// El AO SIN realimentación: no hay ningún camino de la salida a la entrada.
// Es la figura de referencia de "acá NO vale el cortocircuito virtual".
#let fig-ao-lazo-abierto() = esquema({
  import zap: *
  _ao-ideal()
  // la señal, sobre la entrada no inversora
  vsource("Vi", (1.0, 0.5), (1.0, ao-yp), label: none)
  ground("Gi", (1.0, 0.5))
  _ao-rot-fuente(1.0, 0.5, ao-yp, $v_i$)
  wire((1.0, ao-yp), (ao-xin, ao-yp))
  // la inversora, a masa. Baja por la izquierda, como en el inversor: una masa
  // dibujada hacia arriba sale con el triángulo invertido y se lee como otra
  // cosa. El aviso de que acá no hay realimentación va en el pie de la figura,
  // no adentro del dibujo, donde caía encima de la tierra de la fuente.
  // La bajada va en x = −0,3 y no en 0,2: el rótulo de la fuente sale a la
  // izquierda de su círculo, hasta x ≈ 0,15, y le pasaba por encima al cable.
  wire((ao-xin, ao-ym), (-0.3, ao-ym))
  wire((-0.3, ao-ym), (-0.3, 0.9))
  ground("Gm", (-0.3, 0.9))
  _ao-salida()
})

// --- 3. Seguidor de tensión -------------------------------------------
// La salida vuelve entera a la inversora: no hay resistores.
#let fig-ao-seguidor() = esquema({
  import zap: *
  _ao-ideal()
  vsource("Vi", (0.5, 0.5), (0.5, ao-yp), label: none)
  ground("Gi", (0.5, 0.5))
  _ao-rot-fuente(0.5, 0.5, ao-yp, $v_i$)
  wire((0.5, ao-yp), (ao-xin, ao-yp))
  _ao-salida()
  // realimentación total: cable desnudo de la salida a la inversora
  node("r", (ao-xfb, ao-cy))
  wire((ao-xfb, ao-cy), (ao-xfb, ao-yfb))
  wire((ao-xfb, ao-yfb), (1.4, ao-yfb))
  wire((1.4, ao-yfb), (1.4, ao-ym))
  wire((1.4, ao-ym), (ao-xin, ao-ym))
  _ao-rot-v(1.4)
})

// --- 4. Inversor ------------------------------------------------------
// La señal entra por Ri a la inversora; la no inversora va a masa.
// El cable de 0,5 entre la fuente y el resistor NO es decorativo: el círculo de
// la fuente tiene radio 0,4 y el cuerpo del resistor empieza a 0,15 de su primer
// terminal, así que pegados se superponen y el dibujo muestra un símbolo raro.
#let fig-ao-inversor() = esquema({
  import zap: *
  _ao-ideal()
  vsource("Vi", (-0.8, 0.85), (-0.8, ao-ym), label: none)
  ground("Gi", (-0.8, 0.85))
  _ao-rot-fuente(-0.8, 0.85, ao-ym, $v_i$)
  wire((-0.8, ao-ym), (-0.3, ao-ym))
  resistor("Ri", (-0.3, ao-ym), (1.7, ao-ym), label: $R_i$)
  wire((1.7, ao-ym), (ao-xin, ao-ym))
  node("V", (1.7, ao-ym))
  _ao-rot-v(1.7)
  wire((1.7, ao-ym), (1.7, ao-yfb))
  resistor("Rf", (1.7, ao-yfb), (3.4, ao-yfb), label: $R_f$)
  wire((3.4, ao-yfb), (ao-xfb, ao-yfb))
  wire((ao-xfb, ao-yfb), (ao-xfb, ao-cy))
  node("r", (ao-xfb, ao-cy))
  _ao-salida()
  wire((ao-xin, ao-yp), (1.3, ao-yp))
  wire((1.3, ao-yp), (1.3, 0.85))
  ground("Gp", (1.3, 0.85))
})

// --- 5. No inversor ---------------------------------------------------
// La señal entra por la no inversora; R1 va del nodo del cortocircuito
// virtual a masa. R1 sale hacia la IZQUIERDA y baja: así no cruza el cable
// de la señal, que entra más abajo.
#let fig-ao-no-inversor() = esquema({
  import zap: *
  _ao-ideal()
  resistor("R1", (-0.3, ao-ym), (1.4, ao-ym), label: $R_1$)
  wire((-0.3, ao-ym), (-1.0, ao-ym))
  wire((-1.0, ao-ym), (-1.0, 1.1))
  ground("G1", (-1.0, 1.1))
  wire((1.4, ao-ym), (ao-xin, ao-ym))
  node("V", (1.4, ao-ym))
  _ao-rot-v(1.4)
  wire((1.4, ao-ym), (1.4, ao-yfb))
  resistor("Rf", (1.4, ao-yfb), (3.2, ao-yfb), label: $R_f$)
  wire((3.2, ao-yfb), (ao-xfb, ao-yfb))
  wire((ao-xfb, ao-yfb), (ao-xfb, ao-cy))
  node("r", (ao-xfb, ao-cy))
  _ao-salida()
  vsource("Vi", (0.6, 0.5), (0.6, ao-yp), label: none)
  ground("Gi", (0.6, 0.5))
  _ao-rot-fuente(0.6, 0.5, ao-yp, $v_i$)
  wire((0.6, ao-yp), (ao-xin, ao-yp))
})

// --- 6. Sumador inversor ----------------------------------------------
// Dos ramas de entrada, Ra y Rb, sobre el mismo nodo. Ra baja en x = 1,0 y Rf
// sube en x = 1,7: si bajaran y subieran por la misma vertical, los dos tramos
// quedarían uno encima del otro y el dibujo mostraría un cable donde hay dos.
#let fig-ao-sumador() = esquema({
  import zap: *
  let ya = 3.4 // altura de la rama de Va
  let xsum = 1.0 // donde la rama de Va se une a la de Vb
  let xv = 1.7 // el nodo del cortocircuito virtual
  _ao-ideal()
  vsource("Va", (-2.6, 1.3), (-2.6, ya), label: none)
  ground("Ga", (-2.6, 1.3))
  _ao-rot-fuente(-2.6, 1.3, ya, $v_a$)
  resistor("Ra", (-2.6, ya), (xsum, ya), label: $R_a$)
  wire((xsum, ya), (xsum, ao-ym))
  vsource("Vb", (-1.4, 0.85), (-1.4, ao-ym), label: none)
  ground("Gb", (-1.4, 0.85))
  _ao-rot-fuente(-1.4, 0.85, ao-ym, $v_b$)
  wire((-1.4, ao-ym), (-0.9, ao-ym))
  // El rótulo de Rb va DEBAJO: arriba queda estrangulado entre el cable de Ra
  // y su propio cuerpo, y eso sólo se ve ampliando la figura.
  resistor("Rb", (-0.9, ao-ym), (xsum, ao-ym), label: none)
  rotulo((0.05, ao-ym - 0.30), $R_b$, ancla: "north")
  node("suma", (xsum, ao-ym))
  wire((xsum, ao-ym), (xv, ao-ym))
  node("V", (xv, ao-ym))
  wire((xv, ao-ym), (ao-xin, ao-ym))
  _ao-rot-v(xv)
  wire((xv, ao-ym), (xv, ao-yfb))
  resistor("Rf", (xv, ao-yfb), (3.4, ao-yfb), label: $R_f$)
  wire((3.4, ao-yfb), (ao-xfb, ao-yfb))
  wire((ao-xfb, ao-yfb), (ao-xfb, ao-cy))
  node("r", (ao-xfb, ao-cy))
  _ao-salida()
  wire((ao-xin, ao-yp), (1.35, ao-yp))
  wire((1.35, ao-yp), (1.35, 0.9))
  ground("Gp", (1.35, 0.9))
})

// --- 7. Restador (amplificador diferencial) ---------------------------
// Las dos entradas llegan por su resistor. La de abajo NO va a masa: va a masa
// a través de R2, y esa es la simetría que hace que la ganancia sea la resta.
// Las dos fuentes NO pueden compartir la vertical: apiladas en la misma x se
// leen como una sola rama en serie, y el cable de la de abajo cruza el símbolo
// de la de arriba. v1 baja por x = −2,4 y v2 sube por x = −1,5.
#let fig-ao-restador() = esquema({
  import zap: *
  _ao-ideal()
  // rama inversora: v1 por R1 al nodo del cortocircuito virtual
  vsource("V1", (-2.4, 1.0), (-2.4, ao-ym), label: none)
  ground("G1", (-2.4, 1.0))
  _ao-rot-fuente(-2.4, 1.0, ao-ym, $v_1$)
  resistor("R1a", (-2.4, ao-ym), (1.4, ao-ym), label: $R_1$)
  wire((1.4, ao-ym), (ao-xin, ao-ym))
  node("V", (1.4, ao-ym))
  _ao-rot-v(1.4)
  wire((1.4, ao-ym), (1.4, ao-yfb))
  resistor("Rf", (1.4, ao-yfb), (3.4, ao-yfb), label: $R_2$)
  wire((3.4, ao-yfb), (ao-xfb, ao-yfb))
  wire((ao-xfb, ao-yfb), (ao-xfb, ao-cy))
  node("r", (ao-xfb, ao-cy))
  _ao-salida()
  // rama no inversora: v2 por su R1, y R2 de ahí a masa. Es la misma pareja de
  // valores que la de arriba, y esa simetría es la que hace que la salida sea
  // la resta: si se rompe, aparece ganancia de modo común.
  vsource("V2", (-1.5, -1.9), (-1.5, -0.45), label: none)
  ground("G2", (-1.5, -1.9))
  _ao-rot-fuente(-1.5, -1.9, -0.45, $v_2$)
  wire((-1.5, -0.45), (-1.5, ao-yp))
  // El rótulo de este R1 va DEBAJO. Arriba cae a menos de un renglón del R1 de
  // la rama de v1 —los dos resistores están casi en la misma x— y los dos
  // rótulos se leen como uno solo partido en dos.
  resistor("R1b", (-1.5, ao-yp), (0.6, ao-yp), label: none)
  rotulo((-0.45, ao-yp - 0.30), $R_1$, ancla: "north")
  wire((0.6, ao-yp), (ao-xin, ao-yp))
  node("P", (1.5, ao-yp))
  rotulo((1.62, ao-yp + 0.13), $v_y$, ancla: "south-west")
  wire((1.5, ao-yp), (1.5, 0.4))
  resistor("R2b", (1.5, 0.4), (1.5, -1.3), label: (content: $R_2$, anchor: "west"))
  ground("Gp", (1.5, -1.3))
})

// --- 8. Integrador y derivador ----------------------------------------
// Son el inversor con un capacitor en lugar de uno de los dos resistores: la
// figura los pone al lado justo para que se vea que es el MISMO circuito.
#let _ao-integrador() = esquema(escala: 0.82cm, {
  import zap: *
  _ao-ideal(rieles: false)
  vsource("Vi", (-0.8, 0.85), (-0.8, ao-ym), label: none)
  ground("Gi", (-0.8, 0.85))
  _ao-rot-fuente(-0.8, 0.85, ao-ym, $v_i$)
  wire((-0.8, ao-ym), (-0.3, ao-ym))
  resistor("Ri", (-0.3, ao-ym), (1.7, ao-ym), label: $R$)
  wire((1.7, ao-ym), (ao-xin, ao-ym))
  node("V", (1.7, ao-ym))
  _ao-rot-v(1.7)
  wire((1.7, ao-ym), (1.7, ao-yfb))
  capacitor("Cf", (1.7, ao-yfb), (3.4, ao-yfb), label: $C$)
  wire((3.4, ao-yfb), (ao-xfb, ao-yfb))
  wire((ao-xfb, ao-yfb), (ao-xfb, ao-cy))
  node("r", (ao-xfb, ao-cy))
  _ao-salida()
  wire((ao-xin, ao-yp), (1.3, ao-yp))
  wire((1.3, ao-yp), (1.3, 0.85))
  ground("Gp", (1.3, 0.85))
})

#let _ao-derivador() = esquema(escala: 0.82cm, {
  import zap: *
  _ao-ideal(rieles: false)
  vsource("Vi", (-0.8, 0.85), (-0.8, ao-ym), label: none)
  ground("Gi", (-0.8, 0.85))
  _ao-rot-fuente(-0.8, 0.85, ao-ym, $v_i$)
  wire((-0.8, ao-ym), (-0.3, ao-ym))
  capacitor("Ci", (-0.3, ao-ym), (1.7, ao-ym), label: $C$)
  wire((1.7, ao-ym), (ao-xin, ao-ym))
  node("V", (1.7, ao-ym))
  _ao-rot-v(1.7)
  wire((1.7, ao-ym), (1.7, ao-yfb))
  resistor("Rf", (1.7, ao-yfb), (3.4, ao-yfb), label: $R$)
  wire((3.4, ao-yfb), (ao-xfb, ao-yfb))
  wire((ao-xfb, ao-yfb), (ao-xfb, ao-cy))
  node("r", (ao-xfb, ao-cy))
  _ao-salida()
  wire((ao-xin, ao-yp), (1.3, ao-yp))
  wire((1.3, ao-yp), (1.3, 0.85))
  ground("Gp", (1.3, 0.85))
})

#let fig-ao-integrador-derivador() = paneles(
  ("Integrador: C en la realimentación", _ao-integrador()),
  ("Derivador: C en la entrada", _ao-derivador()),
  sep: 18pt,
)

// --- 9. Comparador y Schmitt ------------------------------------------
// Los dos casos donde el cortocircuito virtual NO vale, uno al lado del otro:
// sin realimentación, y con realimentación POSITIVA. La diferencia con las
// figuras 3 a 8 se ve de un vistazo — dónde llega el cable de la salida.
// Las dos fuentes cuelgan de masa hacia arriba, como todas las del apunte: una
// fuente dibujada colgando del techo sale con la tierra invertida y se lee como
// un símbolo distinto.
#let _ao-comparador() = esquema(escala: 0.82cm, {
  import zap: *
  _ao-ideal()
  vsource("Vi", (1.5, 0.3), (1.5, ao-yp), label: none)
  ground("Gi", (1.5, 0.3))
  _ao-rot-fuente(1.5, 0.3, ao-yp, $v_i$)
  wire((1.5, ao-yp), (ao-xin, ao-yp))
  // la referencia, en la inversora: sube por la izquierda hasta el nivel de la
  // pata, sin cruzar la rama de la señal. Va en x = −1,2 y no más cerca: el
  // rótulo de v_i sale a la izquierda de SU círculo y caía sobre éste.
  wire((ao-xin, ao-ym), (-1.2, ao-ym))
  wire((-1.2, ao-ym), (-1.2, 1.5))
  vsource("Vr", (-1.2, 0.1), (-1.2, 1.5), label: none)
  _ao-rot-fuente(-1.2, 0.1, 1.5, $V_"REF"$)
  ground("Gr", (-1.2, 0.1))
  _ao-salida()
})

// El único circuito del módulo donde el cable de la salida termina en la pata
// del MÁS. Todo el resto del dibujo es igual al de un no inversor a propósito:
// lo que hay que aprender a mirar es a cuál de las dos patas llega, y eso sólo
// se ve si lo demás no distrae. El divisor va ortogonal, por abajo.
#let _ao-schmitt() = esquema(escala: 0.82cm, {
  import zap: *
  let ydiv = -0.7 // la recta por donde corre el divisor
  _ao-ideal()
  // la señal entra por la INVERSORA
  vsource("Vi", (0.9, 1.1), (0.9, ao-ym), label: none)
  ground("Gi", (0.9, 1.1))
  _ao-rot-fuente(0.9, 1.1, ao-ym, $v_i$)
  wire((0.9, ao-ym), (ao-xin, ao-ym))
  _ao-salida()
  // realimentación POSITIVA: el divisor R1–R2 desde la salida a la pata del +
  node("r", (ao-xfb, ao-cy))
  wire((ao-xfb, ao-cy), (ao-xfb, ydiv))
  resistor("R2", (ao-xfb, ydiv), (2.4, ydiv), label: $R_2$)
  wire((2.4, ydiv), (1.7, ydiv))
  node("P", (1.7, ydiv))
  wire((1.7, ydiv), (1.7, ao-yp))
  wire((1.7, ao-yp), (ao-xin, ao-yp))
  resistor("R1", (1.7, ydiv), (0.0, ydiv), label: $R_1$)
  wire((0.0, ydiv), (-0.5, ydiv))
  wire((-0.5, ydiv), (-0.5, -1.3))
  ground("G1", (-0.5, -1.3))
})

#let fig-ao-comparador-schmitt() = paneles(
  ("Comparador: sin realimentación", _ao-comparador()),
  ("Schmitt: realimentación positiva", _ao-schmitt()),
  sep: 18pt,
)

// --- 10. Amplificador de instrumentación ------------------------------
// Tres AO: los dos de entrada son no inversores que comparten R_G, y el tercero
// es exactamente el restador de la figura 7.
//
// Ni un solo tramo en diagonal, y no por estética: la primera versión llevaba
// los cuatro resistores del medio en diagonal y los rótulos caían unos sobre
// otros, con dos "R_3" superpuestos que a tamaño de página se leían como uno.
// En un dibujo con tres triángulos, la única forma de que el ojo separe las
// ramas es que todas corran por horizontales y verticales.
#let fig-ao-instrumentacion() = esquema(escala: 0.78cm, {
  import zap: *
  let (ya, yb) = (6.0, 0.2) // centros de A1 (arriba) y A2 (abajo)
  let xred = 0.6 // la vertical de R3–RG–R3
  let (y3, y3b) = (0.8, 4.9) // A3: centro y su nodo de realimentación
  opamp("A1", (2.6, ya), variant: "ieee")
  opamp("A2", (2.6, yb), variant: "ieee")
  // las dos entradas, cada una a la pata del + de su amplificador
  wire((0.0, ya - 0.45), (1.7, ya - 0.45))
  node("e1", (0.0, ya - 0.45), fill: false)
  rotulo((-0.18, ya - 0.45), $v_1$, ancla: "east")
  wire((0.0, yb - 0.45), (1.7, yb - 0.45))
  node("e2", (0.0, yb - 0.45), fill: false)
  rotulo((-0.18, yb - 0.45), $v_2$, ancla: "east")
  // la red R3–RG–R3 entre las dos patas del −. R_G es UNO SOLO y es el que
  // fija toda la ganancia de la etapa: por eso es el que sale al panel.
  // Los tres rótulos van a la DERECHA de la vertical, y por eso los triángulos
  // están en 2,6 y no en 2,2: con 1,1 unidades entre la red y las patas, el
  // "R_3" de abajo caía sobre el borde inclinado del triángulo de A2.
  wire((1.7, ya + 0.45), (xred, ya + 0.45))
  wire((xred, ya + 0.45), (xred, ya + 0.1))
  resistor("R3a", (xred, ya + 0.1), (xred, 4.4), label: (content: $R_3$, anchor: "east"))
  resistor("RG", (xred, 4.4), (xred, 2.7), label: (content: $R_G$, anchor: "east"))
  resistor("R3b", (xred, 2.7), (xred, yb + 0.8), label: (content: $R_3$, anchor: "east"))
  wire((xred, yb + 0.8), (xred, yb + 0.45))
  wire((xred, yb + 0.45), (1.7, yb + 0.45))
  node("n1", (xred, ya + 0.45))
  node("n2", (xred, yb + 0.45))
  // realimentación de A1 y de A2, cada una por afuera: A1 por arriba, A2 por
  // abajo. Bajan en x = −0,7, que es a la izquierda de todo lo demás.
  wire((3.5, ya), (4.0, ya))
  node("s1", (4.0, ya))
  wire((4.0, ya), (4.0, ya + 1.3))
  wire((4.0, ya + 1.3), (-0.7, ya + 1.3))
  wire((-0.7, ya + 1.3), (-0.7, ya + 0.45))
  wire((-0.7, ya + 0.45), (xred, ya + 0.45))
  wire((3.5, yb), (4.0, yb))
  node("s2", (4.0, yb))
  wire((4.0, yb), (4.0, yb - 1.3))
  wire((4.0, yb - 1.3), (-0.7, yb - 1.3))
  wire((-0.7, yb - 1.3), (-0.7, yb + 0.45))
  wire((-0.7, yb + 0.45), (xred, yb + 0.45))
  // El restador de salida: A3, con las dos ramas horizontales. Las dos salidas
  // NO bajan por la misma vertical —4,4 y 4,6— porque dos tramos rectos sobre
  // la misma recta se leen como un solo cable partido.
  let cx3 = 7.8
  let (ym3, yp3) = (y3 + 2.75, y3 + 1.85)
  opamp("A3", (cx3, y3 + 2.3), variant: "ieee")
  wire((4.0, ya), (4.4, ya))
  wire((4.4, ya), (4.4, ym3))
  resistor("R4a", (4.4, ym3), (6.3, ym3), label: $R_4$)
  node("V3", (6.3, ym3))
  wire((6.3, ym3), (cx3 - 0.9, ym3))
  wire((4.0, yb), (4.6, yb))
  wire((4.6, yb), (4.6, yp3))
  resistor("R4b", (4.6, yp3), (6.3, yp3), label: none)
  rotulo((5.45, yp3 - 0.18), $R_4$, ancla: "north")
  node("P3", (6.3, yp3))
  wire((6.3, yp3), (cx3 - 0.9, yp3))
  // realimentación de A3 y su terminal de salida
  wire((6.3, ym3), (6.3, y3b))
  resistor("R5a", (6.3, y3b), (8.3, y3b), label: $R_5$)
  wire((8.3, y3b), (9.6, y3b))
  wire((9.6, y3b), (9.6, y3 + 2.3))
  node("r3", (9.6, y3 + 2.3))
  wire((cx3 + 0.9, y3 + 2.3), (10.4, y3 + 2.3))
  node("so", (10.4, y3 + 2.3), fill: false)
  rotulo((10.55, y3 + 2.3), $v_o$)
  // R5 de la pata del + de A3 a masa
  wire((6.3, yp3), (6.3, 1.4))
  resistor("R5b", (6.3, 1.4), (6.3, -0.3), label: (content: $R_5$, anchor: "west"))
  ground("Gg3", (6.3, -0.3))
})
