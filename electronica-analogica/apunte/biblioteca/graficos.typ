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
#let graf-curva-diodo() = grafico({
  ejes-libro(
    tam: (8.2, 4.8),
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
          flecha-nota((0.95, 15.5), (0.85, 13.5), [zona de\ conducción], ancla: "west", color: c-dato)
          flecha-nota((-1.46, 7.5), (-0.62, -0.3), [corriente de fuga $I_R$\ (escala exagerada)], ancla: "west")
          flecha-nota((-1.46, 15.5), (-1.19, -2.6), [tensión de ruptura $V_R$], ancla: "west")
          nota((-1.48, 22), text(fill: luma(100))[polarización inversa], ancla: "west", tam: 8pt)
          nota((0.06, 22), text(fill: luma(100))[polarización directa], ancla: "west", tam: 8pt)
        },
      )
    },
  )
})

// Entrada senoidal contra salida rectificada. `salida` es la función
// que transforma la senoidal: media onda o valor absoluto.
#let _rectificacion(salida, rotulo) = grafico({
  ejes-libro(
    tam: (5.2, 2.1),
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
          nota((2.27, 1.62), text(fill: c-dato)[#rotulo], ancla: "east")
          nota((1.78, -1.15), text(fill: luma(120))[entrada], ancla: "center")
        },
      )
    },
  )
})

#let graf-media-onda() = _rectificacion(v => calc.max(v, 0), [salida: media onda])
#let graf-onda-completa() = _rectificacion(v => calc.abs(v), [salida: onda completa])

// ---------------------------------------------------------------
//  Módulo 2 — Respuesta del filtro RC
// ---------------------------------------------------------------

// Respuesta del filtro pasa bajos RC: la frecuencia de corte es donde
// la salida cae a 0,707 de la entrada (−3 dB).
#let graf-respuesta-rc() = grafico({
  ejes-libro(
    tam: (7.4, 3.4),
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
          flecha-nota((1.75, 0.95), (1.15, 0.72), [frecuencia de corte:\ cae a $-3$ dB], ancla: "west")
          nota((0.15, 0.35), text(fill: luma(90))[pasa], ancla: "west")
          nota((3.1, 0.32), text(fill: luma(90))[atenúa], ancla: "west")
        },
      )
    },
  )
})

// ---------------------------------------------------------------
//  Módulo 5 — Fuentes: rizado y zener
// ---------------------------------------------------------------

// El rizado: qué agrega el capacitor a la salida del rectificador.
#let graf-rizado() = grafico({
  ejes-libro(
    tam: (7.6, 2.9),
    x-label: $t$,
    y-label: $v_s$,
    x-min: -0.1,
    x-max: 2.55,
    y-min: -0.22,
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
          nota((0.8, 0.9), [$Delta V_r$], ancla: "west")
          nota((2.5, 1.42), text(fill: c-dato)[salida con capacitor], ancla: "east")
          nota((2.5, 0.3), text(fill: luma(120))[sin capacitor], ancla: "east")
        },
      )
    },
  )
})

// Curva característica del zener. Es la del diodo común, pero acá el
// cuadrante que importa es el inverso: es donde el zener trabaja.
#let graf-curva-zener() = grafico({
  ejes-libro(
    tam: (8.6, 5.2),
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
          flecha-nota((-1.52, -8.0), (-1.02, -1.6), [vértice], ancla: "west")
          nota((-1.52, 16.5), text(fill: luma(100))[región de\ polarización inversa], ancla: "west", tam: 8pt)
          nota((0.12, 16.5), text(fill: luma(100))[región de\ polarización directa], ancla: "west", tam: 8pt)
          flecha-nota((0.64, 9.0), (0.79, 3.0), [0,7 V], ancla: "east")
        },
      )
    },
  )
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
          flecha-nota((10.9, -4.3), (11.9, -0.55), [corte], ancla: "east", color: c-dato)
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
