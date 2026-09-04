// =====================================================================
//  graficos.typ — las curvas y formas de onda del apunte
//
//  Una función por figura, nombrada `graf-<tema>`. Mismo contrato que
//  `circuitos.typ`: el módulo la llama por nombre.
//
//  Los ejes son los de `ejes-libro` (estilo "school-book" de
//  cetz-plot): se cruzan en el origen y terminan en punta de flecha,
//  como los de cualquier libro de electrónica. Las anotaciones —líneas
//  punteadas, rótulos, cotas— van adentro de `plot.annotate(...,
//  resize: false)`, que dibuja en coordenadas del gráfico sin cambiar
//  el rango de los ejes.
//
//  OJO con las coordenadas de las anotaciones: son las del GRÁFICO, no
//  las del lienzo. Un `largo: 0.3` sobre un eje que va de 0 a 20 mA es
//  invisible, y sobre uno que va de 0 a 1 V tapa media figura. Cada
//  gráfico lleva sus propios valores.
// =====================================================================

#import "estilo.typ": *

// ---------------------------------------------------------------
//  Módulo 2 — Señales periódicas
// ---------------------------------------------------------------

// Una forma de onda con su Vp y su período marcados. `datos` es una
// función de t o una lista de puntos; t se mide en períodos, así que
// la onda va de 0 a 1,5 T.
#let _onda(datos) = grafico({
  ejes-libro(
    tam: (3.5, 2.2),
    x-label: $t$,
    y-label: $v$,
    x-min: -0.14,
    x-max: 1.72,
    y-min: -1.95,
    y-max: 1.55,
    {
      plot.add(
        datos,
        domain: (0, 1.5),
        samples: 200,
        style: (stroke: trazo-curva + c-dato),
      )
      plot.annotate(
        resize: false,
        {
          guia((0, 1), (0.9, 1))
          marca-y(1, $V_p$, largo: 0.07)
          marca-y(-1, $-V_p$, largo: 0.07)
          cetz.draw.line(
            (0, -1.62),
            (1, -1.62),
            stroke: 0.5pt + c-guia,
            mark: (start: "straight", end: "straight", scale: 0.35),
          )
          nota((0.5, -1.62), text(fill: luma(70))[$T$], ancla: "north")
        },
      )
    },
  )
})

#let graf-formas-de-onda() = paneles(
  ("Senoidal", _onda(t => calc.sin(2 * calc.pi * t))),
  ("Cuadrada", _onda(((0, 1), (0.5, 1), (0.5, -1), (1, -1), (1, 1), (1.5, 1)))),
  ("Triangular", _onda(((0, 0), (0.25, 1), (0.75, -1), (1.25, 1), (1.5, 0)))),
  sep: 8pt,
)

// ---------------------------------------------------------------
//  Módulo 4 — Diodos
// ---------------------------------------------------------------

// Curva característica del diodo: los dos cuadrantes en un solo
// gráfico. La rama inversa va con la escala exagerada — si fuese a
// escala, la fuga de µA sería una línea pegada al eje y no se vería
// nada. Eso está dicho adentro del propio dibujo.
// El marco se declara una vez: lo usan `ejes-libro` para el tamaño y
// `rotulo-marco` para ubicar los rótulos largos contra el borde.
#let _m-diodo = marco(-1.5, 1.15, -4.6, 23, tam: (8.2, 4.8))

#let graf-curva-diodo() = grafico({
  ejes-libro(
    tam: _m-diodo.tam,
    x-label: $v_D " [V]"$,
    y-label: $i_D " [mA]"$,
    x-min: -1.5,
    x-max: 1.15,
    y-min: -4.6,
    y-max: 23,
    {
      // Rama directa: exponencial, rodilla en 0,7 V
      plot.add(
        domain: (0, 0.86),
        samples: 180,
        style: (stroke: trazo-curva + c-dato),
        v => 1e-6 * calc.exp(v / 0.05),
      )
      // Rama inversa: corriente de fuga, exagerada, y ruptura
      plot.add(((-1.14, -0.5), (0, -0.02)), style: (stroke: trazo-curva + c-dato))
      plot.add(((-1.14, -0.5), (-1.18, -4.4)), style: (stroke: trazo-curva + c-dato))
      plot.annotate(
        resize: false,
        {
          // escala vertical: dos marcas alcanzan para dar la magnitud
          marca-y(10, [10], largo: 0.035)
          marca-y(20, [20], largo: 0.035)
          guia((0, 10), (0.79, 10))
          guia((0, 20), (0.845, 20))
          // umbral de conducción
          guia((0.7, 0), (0.7, 3.4))
          marca-x(0.7, [0,7 V], largo: 1.0)
        },
      )
    },
  )
  // Los rótulos largos van FUERA del plot, contra el marco (ver estilo.typ).
  // Adentro de plot.annotate cetz-plot los recorta y los encima en el centro.
  rotulo-marco(_m-diodo, "arriba-izq", text(fill: luma(100))[polarización inversa], tam: 8pt)
  // En dos renglones, no en una línea corrida a la izquierda: un solo
  // renglón de 20 caracteres no entra ni corrido — a la izquierda lo
  // bastante para no cruzar la rama exponencial (pegada al borde derecho),
  // ya cruza el eje $i_D$ del otro lado. Partido en dos, "polarización" es
  // angosto y entra completo en la franja libre entre el eje y la curva.
  rotulo-marco(_m-diodo, "arriba-der", text(fill: luma(100))[polarización\ directa], tam: 8pt, dx: -0.15)
  // Apunta más arriba en la propia rama de ruptura (-1,3 mA en vez de -2,4):
  // más abajo la guía terminaba metida en el rótulo de "corriente de fuga".
  rotulo-marco(_m-diodo, "izq", [tensión de ruptura $V_R$], hacia: (-1.148, -1.3), dy: -0.06)
  // A la izquierda del eje, no centrado: centrado el texto mide más que la
  // mitad izquierda del marco y termina cruzando el 0 y el 0,7 V del lado
  // derecho. En dos renglones y sin guía entra entero de ese lado: con guía,
  // el trazo hacia la curva viaja casi tan inclinado como la caja del rótulo
  // es ancha, y la atraviesa de punta a punta en vez de salir por un borde
  // (el mismo problema que "frecuencia de corte", ver más arriba).
  // dx corre todo el bloque a la derecha del tramo casi vertical de la
  // ruptura (que vive en v entre -1,18 y -1,14): pegado al borde izquierdo,
  // ese tramo le atravesaba las dos líneas.
  rotulo-marco(
    _m-diodo, "abajo-izq", [corriente de fuga $I_R$ \ (escala exagerada)],
    tam: 7.3pt, dx: 0.15, dy: -0.025,
  )
})

// Entrada senoidal contra salida rectificada. `salida` es la función
// que transforma la senoidal: media onda o valor absoluto.
#let _m-rect = marco(-0.1, 2.3, -1.55, 1.85, tam: (5.2, 2.1))

#let _rectificacion(salida, rotulo) = grafico({
  ejes-libro(
    tam: _m-rect.tam,
    x-label: $t$,
    y-label: $v$,
    x-min: -0.1,
    x-max: 2.3,
    y-min: -1.55,
    y-max: 1.85,
    {
      plot.add(
        domain: (0, 2),
        samples: 300,
        style: (stroke: (paint: c-guia, thickness: 0.8pt, dash: "dashed")),
        t => calc.sin(2 * calc.pi * t),
      )
      plot.add(
        domain: (0, 2),
        samples: 400,
        style: (stroke: trazo-curva + c-dato),
        t => salida(calc.sin(2 * calc.pi * t)),
      )
      plot.annotate(
        resize: false,
        {
          guia((0, 1), (2.25, 1))
          marca-y(1, $V_p$, largo: 0.05)
        },
      )
    },
  )
  // Antes iban con `nota` adentro del plot y cetz-plot los empujaba contra el
  // eje: "entrada" quedaba escrito encima de la línea del tiempo.
  rotulo-marco(_m-rect, "arriba-der", text(fill: c-dato)[#rotulo])
  // Sin guía: desde la esquina inferior derecha el texto crece hacia
  // arriba-izquierda, la misma dirección que una guía hacia la curva de
  // entrada — la guía terminaba dibujada encima de la palabra. La curva
  // punteada pasa lo bastante cerca del rótulo como para no necesitarla.
  rotulo-marco(_m-rect, "abajo-der", text(fill: luma(120))[entrada])
})

#let graf-media-onda() = _rectificacion(v => calc.max(v, 0), [salida: media onda])
#let graf-onda-completa() = _rectificacion(v => calc.abs(v), [salida: onda completa])

// ---------------------------------------------------------------
//  Módulo 2 — Respuesta del filtro RC
// ---------------------------------------------------------------

// Respuesta del filtro pasa bajos RC: la frecuencia de corte es donde
// la salida cae a 0,707 de la entrada (−3 dB).
#let _m-rc = marco(-0.25, 5.9, -0.12, 1.22, tam: (7.4, 3.4))

#let graf-respuesta-rc() = grafico({
  ejes-libro(
    tam: _m-rc.tam,
    x-label: $f slash f_c$,
    y-label: $V_"sal" slash V_"in"$,
    x-min: -0.25,
    x-max: 5.9,
    y-min: -0.12,
    y-max: 1.22,
    {
      plot.add(
        domain: (0, 5.2),
        samples: 260,
        style: (stroke: trazo-curva + c-dato),
        x => 1 / calc.sqrt(1 + x * x),
      )
      plot.annotate(
        resize: false,
        {
          guia((0, 0.707), (1, 0.707))
          guia((1, 0), (1, 0.707))
          marca-y(0.707, [0,707], largo: 0.07)
          marca-y(1, [1], largo: 0.07)
          marca-x(1, [$f_c$], largo: 0.045)
          nota((0.15, 0.35), text(fill: luma(90))[pasa], ancla: "west")
          nota((3.1, 0.32), text(fill: luma(90))[atenúa], ancla: "west")
        },
      )
    },
  )
  // 32 caracteres: no entra adentro de los ejes. Lo agarró el chequeo 5.
  // Sin guía: el punto ya está marcado adentro del plot con las dos líneas
  // punteadas y el tick de f_c; una guía desde la esquina superior derecha
  // viaja casi horizontal hacia ese punto y atraviesa el rótulo entero, que
  // es ancho y bajo (el caso contrario al de "tensión de ruptura", donde la
  // guía cae casi vertical y sale del rótulo enseguida).
  rotulo-marco(_m-rc, "arriba-der", [frecuencia de corte:\ cae a $-3$ dB])
})

// ---------------------------------------------------------------
//  Módulo 5 — Fuentes: rizado y zener
// ---------------------------------------------------------------

// El rizado: qué agrega el capacitor a la salida del rectificador.
// y-min baja hasta -0,5 (y no -0,22) a propósito: "sin capacitor" va debajo
// del eje, y con -0,22 el margen que le quedaba era de dos milésimas de
// unidad — tocaba el eje en cualquier redondeo de fuente.
#let _m-rizado = marco(-0.1, 2.55, -0.5, 1.55, tam: (7.6, 2.9))

#let graf-rizado() = grafico({
  ejes-libro(
    tam: _m-rizado.tam,
    x-label: $t$,
    y-label: $v_s$,
    x-min: -0.1,
    x-max: 2.55,
    y-min: -0.5,
    y-max: 1.55,
    {
      // sin capacitor: onda completa pelada
      plot.add(
        domain: (0, 2.4),
        samples: 400,
        style: (stroke: (paint: c-guia, thickness: 0.9pt, dash: "dashed")),
        t => calc.abs(calc.sin(calc.pi * 2 * t)),
      )
      // Con capacitor: se carga hasta el pico y después se descarga
      // sobre la carga hasta que la onda lo vuelve a alcanzar. Los picos
      // de |sin| caen en t = 0,25 + k/2: de ahí sale el corrimiento.
      plot.add(
        domain: (0, 2.4),
        samples: 700,
        style: (stroke: trazo-curva + c-dato),
        t => {
          let s = calc.abs(calc.sin(calc.pi * 2 * t))
          let u = calc.rem(t - 0.25 + 0.5, 0.5) / 0.5
          calc.max(s, calc.exp(-0.22 * u))
        },
      )
      plot.annotate(
        resize: false,
        {
          guia((0, 1), (2.5, 1))
          marca-y(1, [$V_p$], largo: 0.045)
          // cota del rizado, justo antes de un pico
          cetz.draw.line(
            (0.72, 0.803),
            (0.72, 1.0),
            stroke: 0.6pt + c-trazo,
            mark: (start: "straight", end: "straight", scale: 0.3),
          )
          // ΔV_r es marca corta y va adentro, pero corrida a la derecha de
          // la cota para no montarse sobre la curva.
          nota((0.79, 0.895), [$Delta V_r$], ancla: "west")
        },
      )
    },
  )
  rotulo-marco(_m-rizado, "arriba-der", text(fill: c-dato)[salida con capacitor])
  // Debajo del eje del tiempo no hay nada dibujado —la señal rectificada
  // nunca es negativa—, así que ahí el rótulo no pisa ni necesita guía.
  rotulo-marco(_m-rizado, "abajo-cen", text(fill: luma(120))[sin capacitor])
})

// Curva característica del zener. Es la del diodo común, pero acá el
// cuadrante que importa es el inverso: es donde el zener trabaja.
#let _m-zener = marco(-1.55, 1.1, -23, 19, tam: (8.6, 5.2))

#let graf-curva-zener() = grafico({
  ejes-libro(
    tam: _m-zener.tam,
    x-label: $v_D$,
    y-label: $i_D$,
    x-min: -1.55,
    x-max: 1.1,
    y-min: -23,
    y-max: 19,
    {
      // rama directa
      plot.add(
        domain: (0, 0.855),
        samples: 180,
        style: (stroke: trazo-curva + c-dato),
        v => 1e-6 * calc.exp(v / 0.05),
      )
      // rama inversa con el codo del zener
      plot.add(
        (
          (0, -0.05),
          (-0.6, -0.12),
          (-0.9, -0.25),
          (-0.96, -0.7),
          (-0.99, -2.0),
          (-1.005, -5.0),
          (-1.015, -10.0),
          (-1.02, -16.0),
          (-1.025, -21.5),
        ),
        line: "spline",
        style: (stroke: trazo-curva + c-dato),
      )
      plot.annotate(
        resize: false,
        {
          // la tensión de zener, arriba del eje para no pisar la curva
          nota((-1.0, 1.4), [$V_Z$], ancla: "center")
          // los dos límites de corriente. Los rótulos van al cuadrante de
          // abajo a la derecha, que es el único sin curva encima.
          guia((-1.5, -2.0), (1.05, -2.0))
          guia((-1.5, -20.0), (1.05, -20.0))
          nota((0.12, -4.0), [$I_(Z "mín")$], ancla: "west")
          nota((0.12, -6.8), text(fill: luma(110), size: 7.5pt)[$approx 10 %$ de $I_(Z "máx")$], ancla: "west")
          nota((0.12, -18.2), [$I_(Z "máx")$], ancla: "west")
          // "vértice" es marca corta: queda adentro, apuntando al codo.
          flecha-nota((-1.42, -7.0), (-1.04, -1.7), [vértice], ancla: "west")
          flecha-nota((0.62, 8.5), (0.79, 3.0), [0,7 V], ancla: "east")
        },
      )
    },
  )
  rotulo-marco(_m-zener, "arriba-izq", text(fill: luma(100))[región de\ polarización inversa], tam: 8pt)
  // Mismo problema que en graf-curva-diodo: el segundo renglón ("polarización
  // directa", 20 caracteres) es tan ancho como el primero, y a la altura de
  // ese renglón la rama directa ya subió pegada al borde derecho. En tres
  // renglones cortos entra en la franja libre entre el eje y la curva.
  // Tres renglones a 8pt llegaban justo hasta pisar "0,7 V"; a 7pt entran
  // con margen.
  rotulo-marco(_m-zener, "arriba-der", text(fill: luma(100))[región de\ polarización\ directa], tam: 7pt, dx: -0.15)
})

// ---------------------------------------------------------------
//  Módulo 6 — Transistores: recta de carga
// ---------------------------------------------------------------

// Curvas de salida del BJT con la recta de carga: los dos puntos que
// usa la conmutación son los extremos, corte y saturación.
#let graf-recta-de-carga() = grafico({
  ejes-libro(
    tam: (7.4, 4.2),
    x-label: $V_"CE" " [V]"$,
    y-label: $I_C " [mA]"$,
    x-min: -0.9,
    x-max: 14.5,
    y-min: -5.0,
    y-max: 31,
    {
      // familia de curvas de salida, una por cada IB
      for (i, sat) in (4, 9, 14, 19, 24).enumerate() {
        plot.add(
          domain: (0, 14),
          samples: 120,
          style: (stroke: 0.7pt + c-aux),
          v => sat * (1 - calc.exp(-v / 0.32)) * (1 + 0.012 * v),
        )
      }
      // recta de carga: de (Vcc, 0) a (0, Vcc/Rc)
      plot.add(
        ((0, 24), (12, 0)),
        style: (stroke: trazo-curva + c-dato),
      )
      plot.annotate(
        resize: false,
        {
          cetz.draw.circle((0.55, 22.9), radius: 0.16, fill: c-dato, stroke: none)
          cetz.draw.circle((12, 0), radius: 0.16, fill: c-dato, stroke: none)
          // Los rótulos van a la franja de arriba, que está vacía: adentro
          // de la familia de curvas no entra nada legible.
          flecha-nota((1.3, 28.5), (0.75, 23.8), [saturación], ancla: "west", color: c-dato)
          flecha-nota((5.4, 28.5), (4.2, 15.8), [recta de carga], ancla: "west", color: c-dato)
          // A la DERECHA de Vcc, no a la izquierda: del lado izquierdo el
          // rótulo caía pegado al eje y al tick de Vcc, con la guía
          // encimada a las dos cosas. A la derecha no hay nada más.
          flecha-nota((12.7, -2.6), (12.15, -0.4), [corte], ancla: "west", color: c-dato)
          nota((13.4, 29.5), text(fill: c-aux)[$I_B$ crece], ancla: "east")
          cetz.draw.line(
            (13.7, 6),
            (13.7, 25),
            stroke: 0.5pt + c-aux,
            mark: (end: "straight", scale: 0.3),
          )
          marca-x(12, [$V_"cc"$], largo: 1.1)
        },
      )
    },
  )
})


// ---------------------------------------------------------------
//  Módulo 11 — Diagrama fasorial
// ---------------------------------------------------------------

// El diagrama fasorial del RLC serie del Ejercicio 11.1, con la corriente
// como referencia horizontal.
//
// No lleva `ejes-libro` ni `plot.add`: no es una curva, son vectores, y
// cetz-plot no aporta nada acá salvo el recorte de las anotaciones. Los ejes
// se dibujan a mano, que son dos líneas.
//
// La construcción es de punta a cola, no todos los fasores desde el origen:
// V̄R y después (V̄L + V̄C) perpendicular, y V̄ cierra el polígono. Es lo que
// dice el texto del ejercicio, y es lo que hace evidente que 120 V sobre el
// inductor conviva con 100 V de fuente.

// Volts por unidad de lienzo. Un solo número: si la figura queda chica o
// grande se toca acá y no las once coordenadas.
#let _fasor-escala = 28.0
#let _fv(v) = v / _fasor-escala

#let graf-diagrama-fasorial() = grafico({
  let (vr, vl, vc, vx) = (_fv(60), _fv(120), _fv(40), _fv(80))
  let punta = (vr, vx)

  // --- ejes ---
  cetz.draw.line(
    (-0.5, 0),
    (4.0, 0),
    stroke: 0.6pt + c-trazo,
    mark: (end: "straight", scale: 0.4),
  )
  cetz.draw.line(
    (0, -1.8),
    (0, 5.0),
    stroke: 0.6pt + c-trazo,
    mark: (end: "straight", scale: 0.4),
  )
  rotulo((0.12, 4.95), [imaginario], ancla: "north-west", color: luma(100))
  rotulo((4.1, 0), [eje real\ (referencia $overline(I)$)], color: luma(100))

  // --- construcción punteada: el rectángulo que cierra el polígono ---
  cetz.draw.line((0, vx), punta, stroke: punteado)
  cetz.draw.line((0, vl), (vr + 0.35, vl), stroke: punteado)
  cetz.draw.line((0, -vc), (vr + 0.35, -vc), stroke: punteado)

  // --- los fasores ---
  let flecha(desde, hasta, color, grosor) = cetz.draw.line(
    desde,
    hasta,
    stroke: grosor + color,
    mark: (end: "straight", scale: 0.42),
  )

  // V̄R sobre el eje real: en serie, la corriente es la referencia
  flecha((0, 0), (vr, 0), c-aux, 1.0pt)
  // V̄L + V̄C, perpendicular, apoyada en la punta de V̄R
  flecha((vr, 0), punta, c-aux, 1.0pt)
  // la resultante cierra el polígono
  flecha((0, 0), punta, c-dato, 1.4pt)

  // V̄L y V̄C sueltos sobre el eje imaginario, para que se vea de dónde sale
  // la resta: 120 arriba, 40 abajo, y la diferencia es lo que quedó arriba.
  flecha((0, 0), (0, vl), c-aux, 1.0pt)
  flecha((0, 0), (0, -vc), c-aux, 1.0pt)

  // --- ángulo ---
  cetz.draw.arc(
    (0, 0),
    start: 0deg,
    stop: 53.13deg,
    radius: 0.9,
    anchor: "origin",
    stroke: 0.5pt + c-dato,
  )
  rotulo((1.0, 0.33), text(fill: c-dato)[53,13°])

  // --- rótulos ---
  rotulo((vr / 2, -0.14), [$overline(V)_R = 60$ V], ancla: "north", color: c-aux)
  rotulo((vr + 0.16, vx / 2), [$overline(V)_L + overline(V)_C = 80$ V], color: c-aux)
  rotulo((punta.at(0) + 0.2, punta.at(1) + 0.42), [$overline(V) = 100 angle 53,13 degree$ V], color: c-dato)
  rotulo((vr + 0.45, vl), [$overline(V)_L = 120$ V], color: c-aux)
  rotulo((vr + 0.45, -vc), [$overline(V)_C = 40$ V], color: c-aux)
})

// ---------------------------------------------------------------
//  Módulo 10 — Transitorios
// ---------------------------------------------------------------

// La exponencial, en las dos direcciones y normalizada. Es EL gráfico del
// módulo: todo circuito de primer orden se ve así, y los dos números que hay
// que reconocer de memoria —36,8 % y 63,2 %— están marcados sobre la curva.
// La tangente en el origen entra porque es la definición geométrica de tau,
// que es la que se usa para medirlo en el osciloscopio.
#let _m-tau = marco(-0.4, 6.0, -0.14, 1.28, tam: (5.4, 2.7))

#let _tau-panel(sube) = grafico({
  ejes-libro(
    tam: _m-tau.tam,
    x-label: $t\/tau$,
    y-label: $x\/x_0$,
    x-min: -0.4,
    x-max: 6.0,
    y-min: -0.14,
    y-max: 1.28,
    {
      plot.add(
        domain: (0, 5.7),
        samples: 240,
        style: (stroke: trazo-curva + c-dato),
        t => if sube { 1 - calc.exp(-t) } else { calc.exp(-t) },
      )
      // La tangente en el origen: cruza el valor final justo en t = tau.
      plot.add(
        if sube { ((0, 0), (1, 1)) } else { ((0, 1), (1, 0)) },
        style: (stroke: trazo-curva2 + c-aux),
      )
      plot.annotate(
        resize: false,
        {
          let y = if sube { 0.632 } else { 0.368 }
          guia((0, y), (1, y))
          guia((1, 0), (1, y))
          // La asintota horizontal solo existe en la carga: en la descarga el
          // valor final es cero y ya esta dibujado, que es el propio eje.
          if sube { guia((0, 1), (5.7, 1)) }
          marca-y(y, if sube { [0,632] } else { [0,368] }, largo: 0.06)
          marca-y(1, [1], largo: 0.06)
          marca-x(1, $tau$, largo: 0.05)
          marca-x(5, $5 tau$, largo: 0.05)
          nota(
            (1.35, if sube { 0.40 } else { 0.70 }),
            text(fill: c-aux)[tangente],
            ancla: "west",
          )
        },
      )
    },
  )
})

#let graf-tau-exponencial() = paneles(
  ("Descarga: se va el 63,2 %", _tau-panel(false)),
  ("Carga: se completa el 63,2 %", _tau-panel(true)),
  sep: 12pt,
)

// La relación v = L di/dt, vista. Una corriente triangular en una bobina de
// 20 mH: la tensión es la PENDIENTE de la corriente (constante a tramos, y
// salta), la potencia cambia de signo y la energía vuelve a cero.
// Los cuatro paneles comparten el eje de tiempo a propósito: lo que hay que
// leer es la alineación vertical de los quiebres.
#let _m-pulso = marco(-0.5, 7.2, 0, 1, tam: (7.0, 1.25))

// Marca de valor con el rotulo del lado DERECHO del eje. Hace falta en los
// paneles donde el cero cae en el medio: `marca-y` escribe a la izquierda y
// ahi ya esta el "0" del origen, y los dos se pisan. Medido en el render.
#let _marca-y-der(y, cuerpo, largo: 0.07) = {
  cetz.draw.line((-largo, y), (largo, y), stroke: 0.6pt + black)
  cetz.draw.content(
    (largo, y),
    text(size: letra-figura, cuerpo),
    anchor: "west",
    padding: 2pt,
  )
}

// Guías verticales en los dos quiebres, iguales en los cuatro paneles.
#let _quiebres(y0, y1) = {
  cetz.draw.line((2, y0), (2, y1), stroke: punteado)
  cetz.draw.line((6, y0), (6, y1), stroke: punteado)
}

#let _panel-pulso(
  y-label,
  y-min,
  y-max,
  trazos,
  extra: none,
  ejex: false,
  ticks: (2, 6),
) = grafico({
  ejes-libro(
    tam: _m-pulso.tam,
    x-label: if ejex { $t " [ms]"$ } else { none },
    y-label: y-label,
    x-min: -0.5,
    x-max: 7.2,
    y-min: y-min,
    y-max: y-max,
    {
      // Un trazo es una lista de puntos, o un diccionario (fn, dom) cuando
      // el tramo es una curva y no una recta. Las dos formas hacen falta:
      // la corriente y la tension van por tramos rectos, la energia no.
      for tr in trazos {
        if type(tr) == dictionary {
          plot.add(
            tr.fn,
            domain: tr.dom,
            samples: 120,
            style: (stroke: trazo-curva + c-dato),
          )
        } else {
          plot.add(tr, style: (stroke: trazo-curva + c-dato))
        }
      }
      plot.annotate(
        resize: false,
        {
          _quiebres(y-min, y-max)
          if extra != none { extra }
          if ejex {
            for t in ticks {
              marca-x(t, [#t], largo: (y-max - y-min) * 0.06)
            }
          }
        },
      )
    },
  )
})

#let graf-pulso-en-bobina() = paneles-columna(
  (
    "Corriente impuesta",
    _panel-pulso(
      $i_L " [A]"$,
      -0.3,
      2.5,
      (((-0.5, 0), (0, 0), (2, 2), (6, 0), (7.2, 0)),),
      extra: { marca-y(2, [2], largo: 0.07) },
    ),
  ),
  (
    "Tensión: la pendiente de la corriente",
    _panel-pulso(
      $v_L " [V]"$,
      -16,
      26,
      (
        ((-0.5, 0), (0, 0)),
        ((0, 20), (2, 20)),
        ((2, -10), (6, -10)),
        ((6, 0), (7.2, 0)),
      ),
      extra: {
        marca-y(20, [20], largo: 0.07)
        _marca-y-der(-10, [−10], largo: 0.32)
        cetz.draw.line((0, 0), (0, 20), stroke: punteado)
        cetz.draw.line((2, 20), (2, -10), stroke: punteado)
        cetz.draw.line((6, -10), (6, 0), stroke: punteado)
      },
    ),
  ),
  (
    "Potencia: absorbe y devuelve",
    _panel-pulso(
      $p_L " [W]"$,
      -28,
      48,
      (((-0.5, 0), (0, 0)), ((0, 0), (2, 40)), ((2, -20), (6, 0)), ((6, 0), (7.2, 0))),
      extra: {
        marca-y(40, [40], largo: 0.07)
        cetz.draw.line((2, 40), (2, -20), stroke: punteado)
        nota((2.6, 26), text(fill: c-aux)[$p > 0$], ancla: "west")
        nota((2.5, -24), text(fill: c-aux)[$p < 0$], ancla: "west")
      },
    ),
  ),
  (
    "Energía: entra y sale, no se disipa",
    _panel-pulso(
      $E_L " [mJ]"$,
      -6,
      50,
      (
        ((-0.5, 0), (0, 0)),
        (fn: t => 10 * t * t, dom: (0, 2)),
        (fn: t => 10 * calc.pow(3 - t / 2, 2), dom: (2, 6)),
        ((6, 0), (7.2, 0)),
      ),
      extra: { marca-y(40, [40], largo: 0.07) },
      ejex: true,
    ),
  ),
)

// El dual: i = C dv/dt, con un capacitor de 0,25 µF. El tramo del medio es
// el que enseña: con iC = 0 la tensión NO vuelve a cero, se queda donde
// estaba. Ahí se ve que el capacitor recuerda.
#let graf-pulso-en-capacitor() = paneles-columna(
  (
    "Corriente impuesta",
    _panel-pulso(
      $i_C " [mA]"$,
      -0.85,
      0.85,
      (
        ((-0.5, 0), (0, 0)),
        ((0, 0.5), (2, 0.5)),
        ((2, 0), (4, 0)),
        ((4, -0.5), (6, -0.5)),
        ((6, 0), (7.2, 0)),
      ),
      extra: {
        marca-y(0.5, [0,5], largo: 0.07)
        _marca-y-der(-0.5, [−0,5], largo: 0.32)
        cetz.draw.line((0, 0), (0, 0.5), stroke: punteado)
        cetz.draw.line((2, 0.5), (2, 0), stroke: punteado)
        cetz.draw.line((4, 0), (4, -0.5), stroke: punteado)
        cetz.draw.line((6, -0.5), (6, 0), stroke: punteado)
        cetz.draw.line((4, -0.85), (4, 0.85), stroke: punteado)
      },
    ),
  ),
  (
    "Tensión: la integral de la corriente",
    _panel-pulso(
      $v_C " [V]"$,
      -1.2,
      5.4,
      (((-0.5, 0), (0, 0), (2, 4), (4, 4), (6, 0), (7.2, 0)),),
      extra: {
        marca-y(4, [4], largo: 0.07)
        cetz.draw.line((4, -1.2), (4, 5.4), stroke: punteado)
        nota((2.2, 4.85), text(fill: c-aux)[se queda], ancla: "west")
      },
    ),
  ),
  (
    "Energía almacenada",
    _panel-pulso(
      $E_C " [µJ]"$,
      -0.6,
      2.7,
      (
        ((-0.5, 0), (0, 0)),
        (fn: t => 0.5 * t * t, dom: (0, 2)),
        ((2, 2), (4, 2)),
        (fn: t => 0.125 * calc.pow(4 - 2 * (t - 4), 2), dom: (4, 6)),
        ((6, 0), (7.2, 0)),
      ),
      extra: {
        marca-y(2, [2], largo: 0.07)
        cetz.draw.line((4, -0.6), (4, 2.7), stroke: punteado)
      },
      ejex: true,
      ticks: (2, 4, 6),
    ),
  ),
)

// Los tres regímenes de segundo orden, normalizados: el mismo escalón, el
// mismo omega_0, y sólo cambia zeta. Es la figura que hace que "sobre",
// "crítico" y "sub" dejen de ser tres palabras y pasen a ser tres curvas.
#let _m-regimenes = marco(-0.6, 13.0, -0.12, 1.78, tam: (8.0, 4.2))

// Respuesta al escalón normalizada de un sistema de segundo orden, en
// funcion de tau = omega_0 t. Una sola funcion para los tres casos: es la
// misma ecuacion, y verla escrita una vez sola es parte de lo que enseña.
#let _escalon2(z, t) = {
  if z < 1 {
    let wd = calc.sqrt(1 - z * z)
    1 - calc.exp(-z * t) * (calc.cos(wd * t) + z / wd * calc.sin(wd * t))
  } else if z == 1 {
    1 - (1 + t) * calc.exp(-t)
  } else {
    let r = calc.sqrt(z * z - 1)
    let (s1, s2) = (-z + r, -z - r)
    1 - (s2 * calc.exp(s1 * t) - s1 * calc.exp(s2 * t)) / (s2 - s1)
  }
}

#let graf-tres-regimenes() = grafico({
  ejes-libro(
    tam: _m-regimenes.tam,
    x-label: $omega_0 t$,
    y-label: $x\/x_infinity$,
    x-min: -0.6,
    x-max: 13.0,
    y-min: -0.12,
    y-max: 1.78,
    {
      plot.add(
        domain: (0, 12.6),
        samples: 300,
        style: (stroke: trazo-curva + c-dato),
        t => _escalon2(0.2, t),
      )
      plot.add(
        domain: (0, 12.6),
        samples: 300,
        style: (stroke: trazo-curva2 + c-azul),
        t => _escalon2(1, t),
      )
      plot.add(
        domain: (0, 12.6),
        samples: 300,
        style: (stroke: trazo-curva2 + c-aux),
        t => _escalon2(2, t),
      )
      plot.annotate(
        resize: false,
        {
          guia((0, 1), (12.6, 1))
          marca-y(1, [1], largo: 0.13)
        },
      )
    },
  )
  // La leyenda va contra el marco y no adentro: las tres curvas convergen a 1
  // y no hay ningun x donde esten las tres separadas y lejos del eje.
  rotulo-marco(
    _m-regimenes,
    "abajo-der",
    text(fill: c-dato)[$zeta = 0,2$ — subamortiguado],
    dy: 0.30,
  )
  rotulo-marco(
    _m-regimenes,
    "abajo-der",
    text(fill: c-azul)[$zeta = 1$ — crítico],
    dy: 0.19,
  )
  rotulo-marco(
    _m-regimenes,
    "abajo-der",
    text(fill: c-aux)[$zeta = 2$ — sobreamortiguado],
    dy: 0.08,
  )
})

// El subamortiguado con lupa: de dónde salen los tres números que se miden
// en el osciloscopio —sobrepico, período amortiguado y envolvente—.
#let _m-sub = marco(-0.7, 15.0, -0.15, 1.95, tam: (8.0, 4.0))

#let graf-subamortiguado-detalle() = grafico({
  let z = 0.15
  ejes-libro(
    tam: _m-sub.tam,
    x-label: $omega_0 t$,
    y-label: $x\/x_infinity$,
    x-min: -0.7,
    x-max: 15.0,
    y-min: -0.15,
    y-max: 1.95,
    {
      plot.add(
        domain: (0, 14.6),
        samples: 400,
        style: (stroke: trazo-curva + c-dato),
        t => _escalon2(z, t),
      )
      // Las dos envolventes: 1 ± e^(−zeta·omega_0·t) / sqrt(1−zeta²)
      let k = 1 / calc.sqrt(1 - z * z)
      plot.add(
        domain: (0, 14.6),
        samples: 200,
        style: (stroke: (paint: c-aux, thickness: 0.7pt, dash: "dashed")),
        t => 1 + k * calc.exp(-z * t),
      )
      plot.add(
        domain: (0, 14.6),
        samples: 200,
        style: (stroke: (paint: c-aux, thickness: 0.7pt, dash: "dashed")),
        t => 1 - k * calc.exp(-z * t),
      )
      plot.annotate(
        resize: false,
        {
          let wd = calc.sqrt(1 - z * z)
          let t1 = calc.pi / wd
          let t2 = 3 * calc.pi / wd
          let pico = _escalon2(z, t1)
          guia((0, 1), (14.6, 1))
          guia((t1, 1), (t1, pico))
          guia((t1, pico), (t2, pico))
          marca-y(1, [1], largo: 0.14)
          // cota del período amortiguado, entre dos máximos consecutivos
          cetz.draw.line(
            (t1, 1.86),
            (t2, 1.86),
            stroke: 0.5pt + c-guia,
            mark: (start: "straight", end: "straight", scale: 0.35),
          )
          nota(((t1 + t2) / 2, 1.86), text(fill: luma(70))[$T_d$], ancla: "south")
          nota((t1 + 0.15, (1 + pico) / 2), text(fill: c-dato)[SP], ancla: "west")
        },
      )
    },
  )
  rotulo-marco(
    _m-sub,
    "arriba-der",
    text(fill: c-aux)[envolvente $e^(-alpha t)$],
    dy: -0.02,
  )
})

// Por qué el 80 % de la energía no se va en el mismo tiempo que el 80 % de
// la corriente: la energía va con el CUADRADO, y por eso decae al doble de
// velocidad. Es el error que la guía de la cátedra marca dos veces.
#let _m-energia = marco(-0.25, 3.3, -0.09, 1.15, tam: (7.4, 3.6))

#let graf-energia-descarga() = grafico({
  ejes-libro(
    tam: _m-energia.tam,
    x-label: $t\/tau$,
    y-label: [fracción],
    x-min: -0.25,
    x-max: 3.3,
    y-min: -0.09,
    y-max: 1.15,
    {
      plot.add(
        domain: (0, 3.1),
        samples: 220,
        style: (stroke: trazo-curva + c-dato),
        t => calc.exp(-t),
      )
      plot.add(
        domain: (0, 3.1),
        samples: 220,
        style: (stroke: trazo-curva2 + c-aux),
        t => calc.exp(-2 * t),
      )
      plot.add(
        domain: (0, 3.1),
        samples: 220,
        style: (stroke: (paint: c-azul, thickness: 0.9pt, dash: "dashed")),
        t => 1 - calc.exp(-2 * t),
      )
      plot.annotate(
        resize: false,
        {
          guia((0, 0.368), (1, 0.368))
          guia((0, 0.135), (1, 0.135))
          guia((1, 0), (1, 0.368))
          marca-y(0.368, [0,368], largo: 0.045)
          marca-y(0.135, [0,135], largo: 0.045)
          marca-x(1, $tau$, largo: 0.035)
          // A 1,5 tau ya se disipo el 95 % de la energia, con la corriente
          // todavia en el 22 % de su valor inicial: es el numero que pide el
          // problema 7.8 de la guia, y el que separa las dos escalas.
          guia((1.498, 0), (1.498, 0.95))
          marca-x(1.498, [1,5 $tau$], largo: 0.035)
          nota((2.05, 0.86), text(fill: c-azul)[disipada], ancla: "west")
        },
      )
    },
  )
  // Sin `hacia`: la guía desde el borde hasta la curva cruzaba las otras dos,
  // y el gráfico se leía peor con la ayuda que sin ella.
  rotulo-marco(
    _m-energia,
    "der",
    text(fill: c-dato)[la corriente: $e^(-t\/tau)$],
    dy: 0.10,
  )
  rotulo-marco(
    _m-energia,
    "der",
    text(fill: c-aux)[la energía: $e^(-2t\/tau)$],
    dy: -0.06,
  )
})

// La descomposición del método: la respuesta completa es la suma de la que
// da la energía inicial sola y la que da la fuente sola. Los números son los
// del ejercicio del módulo, para que se pueda contrastar con la cuenta.
#let _m-completa = marco(-0.3, 5.4, -0.6, 9.4, tam: (7.4, 3.6))

#let graf-respuesta-completa() = grafico({
  ejes-libro(
    tam: _m-completa.tam,
    x-label: $t\/tau$,
    y-label: $v_C " [V]"$,
    x-min: -0.3,
    x-max: 5.4,
    y-min: -0.6,
    y-max: 9.4,
    {
      plot.add(
        domain: (0, 5.1),
        samples: 220,
        style: (stroke: trazo-curva + c-dato),
        t => 2 + 6 * calc.exp(-t),
      )
      plot.add(
        domain: (0, 5.1),
        samples: 220,
        style: (stroke: (paint: c-aux, thickness: 0.9pt, dash: "dashed")),
        t => 8 * calc.exp(-t),
      )
      plot.add(
        domain: (0, 5.1),
        samples: 220,
        style: (stroke: (paint: c-azul, thickness: 0.9pt, dash: "dotted")),
        t => 2 * (1 - calc.exp(-t)),
      )
      plot.annotate(
        resize: false,
        {
          guia((0, 2), (5.1, 2))
          marca-y(8, [8], largo: 0.05)
          marca-y(2, [2], largo: 0.05)

        },
      )
    },
  )
  // Las tres curvas se nombran contra el marco: en la mitad derecha ninguna
  // pasa de 2,5 V, así que arriba a la derecha no hay nada que tapar.
  rotulo-marco(
    _m-completa,
    "arriba-der",
    text(fill: c-dato)[completa: $2 + 6 e^(-t\/tau)$],
    dy: -0.02,
  )
  rotulo-marco(
    _m-completa,
    "arriba-der",
    text(fill: c-aux)[entrada cero: $8 e^(-t\/tau)$],
    dy: -0.15,
  )
  rotulo-marco(
    _m-completa,
    "arriba-der",
    text(fill: c-azul)[estado cero: $2(1 - e^(-t\/tau))$],
    dy: -0.28,
  )
})

// ---------------------------------------------------------------
//  Módulo 15 — Simulación
// ---------------------------------------------------------------

// El paso de integración elegido mal, y qué se ve cuando pasa: la curva
// gruesa NO es la señal, es lo que el simulador dibujó uniendo los puntos
// que calculó. Sin la curva fina al lado, «parece correcta».
#let _m-paso = marco(-1.0, 23.0, -0.85, 0.95, tam: (8.2, 3.2))

#let graf-paso-de-simulacion() = grafico({
  let f = t => calc.exp(-0.1 * t) * calc.sin(t)
  let ts = (0, 5.6, 11.2, 16.8, 22.4)
  ejes-libro(
    tam: _m-paso.tam,
    x-label: $t$,
    y-label: $v$,
    x-min: -1.0,
    x-max: 23.0,
    y-min: -0.85,
    y-max: 0.95,
    {
      plot.add(
        domain: (0, 22.4),
        samples: 400,
        style: (stroke: trazo-curva2 + c-guia),
        f,
      )
      plot.add(
        ts.map(t => (t, f(t))),
        style: (stroke: trazo-curva + c-dato),
        mark: "o",
        mark-style: (fill: c-dato, stroke: none),
        mark-size: 0.12,
      )
      plot.annotate(
        resize: false,
        {
          nota((6.0, 0.62), text(fill: c-guia)[la señal], ancla: "west")
          nota((12.5, -0.62), text(fill: c-dato)[lo simulado], ancla: "west")
        },
      )
    },
  )
  rotulo-marco(
    _m-paso,
    "arriba-der",
    [paso $= 0,9 T$: cinco puntos\ y ninguno cae en un pico],
    dy: -0.02,
  )
})

// ---------------------------------------------------------------
//  Módulo 12 — Bode con décadas reales
// ---------------------------------------------------------------

// La única figura del apunte que NO se dibuja adentro de Typst. El eje
// logarítmico de cetz-plot no da décadas parejas, y un Bode sin décadas no es
// un Bode: se genera con matplotlib y se incrusta el SVG.
//
// El SVG está commiteado, así que el apunte compila en una máquina sin Python.
// Para regenerarlo, desde `apunte/`:  python biblioteca/figuras/generar-bode.py
// El porqué de cada decisión está en el encabezado de ese script.
#let graf-bode-amplificador() = align(
  center,
  image("figuras/bode-amplificador.svg", width: 95%),
)
