// =====================================================================
//  biblioteca/figuras.typ — figuras propias del apunte de IISE
//
//  Existe porque `plantilla.typ` lo importa y re-exporta: así un módulo
//  que hace `#import "../plantilla.typ": *` ya tiene las figuras sin
//  importar dos archivos. Hoy está casi vacío a propósito.
//
//  IISE es una materia de diapositivas, no de dibujos: casi todo lo que
//  el apunte necesita mostrar es una TABLA (la N², los tipos de
//  emergente, el triángulo de hierro) y eso se escribe en el módulo.
//  Lo que sí se dibuja acá es lo que se repite en más de un módulo.
// =====================================================================

#import "paleta.typ": *

// ---------- El triángulo de hierro ----------
//
// Los tres ejes restringidos, con el riesgo en el centro. Se usa en M02
// y se vuelve a nombrar en la unidad 5 (márgenes), así que vive acá y no
// adentro de un módulo.
// El desplazamiento vertical `sube` existe porque los rótulos del vértice
// superior y de la base se montaban sobre el trazo del triángulo: se vio en
// la página compilada, no en la compilación, que daba verde igual.
#let fig-triangulo-hierro(ancho: 8.4cm) = {
  let h = ancho * 0.87
  let sube = 0.62cm
  box(width: ancho, height: h + sube + 0.75cm)[
    #place(center + top, dy: sube)[
      #polygon(
        fill: c-azul.lighten(88%),
        stroke: 1.2pt + c-azul,
        (ancho / 2, 0cm),
        (ancho, h),
        (0cm, h),
      )
    ]
    #place(center + top, dy: 0cm)[
      #align(center)[
        #text(size: 9pt, weight: "bold", fill: c-azul)[Desempeño]
        #linebreak()
        #text(size: 7.6pt, fill: c-azul)[(performance)]
      ]
    ]
    #place(left + top, dy: h + sube + 0.10cm, dx: -0.15cm)[
      #text(size: 9pt, weight: "bold", fill: c-azul)[Costos]
    ]
    #place(right + top, dy: h + sube + 0.10cm, dx: 0.15cm)[
      #text(size: 9pt, weight: "bold", fill: c-azul)[Planificación]
    ]
    #place(center + top, dy: h * 0.52 + sube)[
      #box(
        fill: c-rojo.lighten(85%),
        stroke: 1pt + c-rojo,
        radius: 3pt,
        inset: (x: 7pt, y: 5pt),
      )[#text(size: 9pt, weight: "bold", fill: c-rojo)[RIESGO]]
    ]
  ]
}

// ---------- El principio de los niveles: N+1 / N / N-1 ----------
//
// Tres cajas concéntricas. Es la figura de la diapositiva 29 de la clase
// 1, y es la misma idea que en la unidad 4 se abre en la jerarquía NASA
// completa: por eso conviene que las dos la dibujen igual.
#let fig-niveles(ancho: 9cm) = {
  let paso = 0.72cm
  box(width: ancho, height: 3.9cm)[
    #place(center + horizon)[
      #box(
        width: ancho,
        height: 3.7cm,
        fill: c-azul.lighten(93%),
        stroke: 1pt + c-azul,
        radius: 4pt,
      )[
        #place(left + top, dx: 6pt, dy: 4pt)[
          #text(size: 8.4pt, weight: "bold", fill: c-azul)[Sistema #sym.space N+1 #h(4pt) #text(weight: "regular", style: "italic")[suprasistema]]
        ]
      ]
    ]
    #place(center + horizon, dy: 0.18cm)[
      #box(
        width: ancho - 2 * paso,
        height: 2.5cm,
        fill: c-azul.lighten(80%),
        stroke: 1pt + c-azul,
        radius: 4pt,
      )[
        #place(left + top, dx: 6pt, dy: 4pt)[
          #text(size: 8.4pt, weight: "bold", fill: c-azul)[Sistema #sym.space N #h(4pt) #text(weight: "regular", style: "italic")[el que se está mirando]]
        ]
      ]
    ]
    #place(center + horizon, dy: 0.45cm)[
      #box(
        width: ancho - 4 * paso,
        height: 1.25cm,
        fill: c-azul.lighten(62%),
        stroke: 1pt + c-azul,
        radius: 4pt,
      )[
        #place(center + horizon)[
          #text(size: 8.4pt, weight: "bold", fill: white)[Sistema #sym.space $N-1$ #h(3pt) #text(weight: "regular", style: "italic")[subsistema]]
        ]
      ]
    ]
  ]
}
