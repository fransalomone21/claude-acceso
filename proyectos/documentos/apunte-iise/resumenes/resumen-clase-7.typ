// Resumen de una página de la clase 7 de IISE.
// Fuente: los módulos M24-M27 del apunte (ya contrastados contra las
// láminas de la clase 7). Las diapositivas se citan como «d. N».

#import "../apunte/biblioteca/paleta.typ": *

#set page(paper: "a4", margin: (x: 1.4cm, top: 1.2cm, bottom: 1.1cm))
#set text(font: ("Libertinus Serif", "New Computer Modern"), size: 9.7pt, lang: "es")
#set par(justify: true, leading: 0.55em, spacing: 0.6em)

#let titulo(t) = text(fill: c-azul, weight: "bold", size: 11pt, t)
#let marca(color, entrada, cuerpo) = [#text(fill: color, weight: "bold", entrada) #cuerpo]
#let caja(color, titulo, cuerpo) = block(
  width: 100%, inset: 6pt, radius: 3pt, stroke: (left: 2.5pt + color),
  fill: color.lighten(92%),
  [#text(fill: color, weight: "bold", titulo) \ #cuerpo],
)

// ---------------------------------------------------------------- título
#align(center)[
  #text(fill: c-azul, weight: "bold", size: 15pt)[Clase 7 — Crear la arquitectura y cerrar la Fase A] \
  #text(fill: c-libro, size: 8.5pt)[IISE · UNSAM 2026 · resumen de una página · sale de los módulos de la unidad 7 del apunte]
]

#v(2pt)
#caja(c-rosa, [La posta])[
  La Pre-Fase A te deja un *concepto* factible. La Fase A lo convierte en *una sola
  arquitectura en baseline*: requerimientos de alto nivel fijados, interfaces definidas y
  dos revisiones externas que lo certifican (SRR y MDR). Al terminar ya sabés *qué
  comprar*: qué tanque, qué baterías, cuánta energía en eclipse.
]

// ---------------------------------------------------------------- el flujo
#v(2pt)
#titulo[El flujo: qué se hace y para qué]
#v(1pt)
#let paso(n) = box(fill: c-azul, inset: (x: 4pt, y: 2pt), radius: 2pt, text(fill: white, weight: "bold", str(n)))
#table(
  columns: (0.35fr, 2.3fr, 2fr),
  stroke: 0.4pt + c-guia, inset: 4.5pt, align: (center + horizon, left, left),
  table.header([], text(fill: c-azul, weight: "bold")[Qué se hace], text(fill: c-azul, weight: "bold")[Para qué]),
  paso(1), [Analizar necesidades, alcance y ConOps → *requerimientos iniciales*],
           [saber qué hay que cumplir antes de dibujar nada],
  paso(2), [Fijar *límites*, restricciones, contexto, hipótesis y ambiente],
           [acotar el espacio de soluciones],
  paso(3), [Generar *arquitecturas candidatas*: por *síntesis* (combinar sistemas existentes) o *descubrimiento* (abstraer de otros); métodos normativo, racional (ciencia) o participativo, heurístico (arte)],
           [tener entre qué elegir; aprovechar lo heredado],
  paso(4), [*Comparar y balancear* beneficios, costos, riesgos y desempeño contra el ConOps],
           [elegir una *a pesar* de la incertidumbre, no después de resolverla],
  paso(5), [Dejar en baseline los requerimientos de alto nivel y el concepto; *definir las interfaces* (IDD/IRD/ICD, diagrama N²)],
           [que cada equipo trabaje en lo suyo sin pisarse],
  paso(6), [*SRR* → baseline de Requerimientos de Sistema. *MDR* → baseline Funcional (revisa antes las acciones abiertas de la SRR)],
           [que alguien de afuera certifique antes de pasar a la Fase B],
)
#v(1pt)
#text(size: 9.2pt)[#marca(c-azul, [La idea:])[no es lineal. Comparar candidatas con los interesados puede *cambiar el enunciado del problema* y volver al paso 1 (d. 9).]]

// ---------------------------------------------------------------- conceptos
#v(3pt)
#grid(
  columns: (1fr, 1fr), column-gutter: 12pt,
  [
    #titulo[Los conceptos que se preguntan]
    - *Arquitectura vs. diseño.* La arquitectura restringe el espacio de soluciones,
      decide fabricar o comprar, discrimina alternativas y descubre los requerimientos
      verdaderos. El diseño desarrolla los componentes, construye el sistema y mide el
      efecto dominó de un cambio.
    - *La esencia:* estructurar, simplificar, comprometer y balancear.
    - *Factores de balance:* requerimientos, función, forma, sencillez, robustez,
      asequibilidad, complejidad, ambiente y factores humanos.
    - *Vistas:* ningún diagrama solo captura la arquitectura, igual que un edificio
      no se construye con un solo plano.
    - *Matriz de funciones por fase* (d. 4): cada función sube
      *Concepto* (Pre-A) → *Baseline* (A) → *Completo* (B/C) → seguimiento de cambios.
      La V&V va atrasada a propósito: no se verifica lo que no está diseñado.
  ],
  [
    #titulo[Interfaces y N²]
    - *Externa* si cruza el límite del sistema; *interna* si une partes del mismo.
      Depende de dónde ponés el límite: la interetapa del Falcon 9 es interna o
      externa según el sistema (d. 28).
    - *No toda interfaz va al ICD:* adentro de una caja la define el subsistema (d. 27).
    - *N²:* entidades en la diagonal, salidas en las filas, entradas en las columnas.
      Dos celdas simétricas ocupadas = *lazo de realimentación* → candidatas a un
      mismo subsistema.
    - *Toda interfaz necesita un dueño escrito*, o queda huérfana entre equipos.

    #titulo[Ejemplos para citar]
    - *Mars 2020:* ConOps en 4 fases; hereda del Curiosity (US\$ 1.500~M, misma
      envolvente); la TRN, financiada sólo hasta el PDR.
    - *GLAST:* IRD con números reales (28~V~±~6~V; 70~Mbps; 3.000~kg) y aun así con TBR.
    - *Adaptador:* satélite de \~4.000~kg → el PAS 1194VS aguanta 7.000~kg.
  ],
)

// ---------------------------------------------------------------- ojo
#v(3pt)
#caja(c-rojo, [Ojo en el parcial])[
  La matriz de la d. 4 pone la SRR en la Fase B, pero la clase la explica en la *Fase A*
  (d. 41-45), y esa es la que vale. *SDR* y *MDR* son la misma revisión con dos siglas. El
  plan de V&V que pide la SRR es *inicial*, no completo.
]
