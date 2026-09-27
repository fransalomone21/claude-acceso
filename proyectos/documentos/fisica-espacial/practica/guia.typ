// =====================================================================
//  guia.typ -- la guia completa de la catedra, ejercicio por ejercicio
//
//  Una sola fuente para las dos versiones:
//    typst compile guia.typ --input resultados=si   (enunciado + tip + resultado)
//    typst compile guia.typ --input resultados=no   (enunciado + tip)
//  Los datos viven en ejercicios.toml; los recortes los hace recortar.py.
// =====================================================================
#import "estilo.typ": *

#let con-resultados = sys.inputs.at("resultados", default: "si") == "si"
#let datos = toml("ejercicios.toml")
#let mk(s) = eval(s, mode: "markup")

#show: documento.with(
  titulo: if con-resultados [Guía completa, con tips y resultados] else [Guía completa, sin resultados],
  subtitulo: [Los ejercicios de la guía de la cátedra (versión 2026, 21 páginas), tal como los pegó Aníbal],
  encabezado: if con-resultados [Guía completa — con resultados] else [Guía completa — sin resultados],
)

#if con-resultados [
  Cada ejercicio está recortado de la guía de la cátedra, con sus figuras. Abajo
  va un *tip* de una oración —qué plantear, no la cuenta— y el *resultado*.
  Todos los resultados numéricos se volvieron a calcular desde cero con un
  script (`practica/validar.py` del repo del apunte), que también compara cada
  número impreso acá contra su cuenta: si uno no coincide, el PDF no se publica.
  Los desarrollos completos de la mayoría están en los ejemplos del apunte.
] else [
  Cada ejercicio está recortado de la guía de la cátedra, con sus figuras, y
  lleva un *tip* de una oración: qué plantear, no la cuenta. Los resultados,
  verificados, están en la versión *con resultados*, en la carpeta de al lado.
]

*Una aclaración de nombres.* La guía llama «impulso angular» a
$bold(L) = bold(r) times bold(p)$. Acá se le dice *momento angular*, que es lo
que es; el *impulso angular* es $integral bold(tau) dif t = Delta bold(L)$, lo
que un torque le cambia al momento angular en un intervalo. Donde un enunciado
usa el otro nombre, se aclara debajo.

#for sec in datos.seccion {
  heading(level: 1, sec.titulo)
  text(size: 9.5pt, fill: luma(70), mk(sec.bajada))
  for ej in datos.ej.filter(e => e.seccion == sec.id) {
    // Un ejercicio entero en una pagina salvo que no entre: el `sticky` solo
    // no alcanzo (el tip del Ej. 10 quedaba huerfano arriba de la pagina).
    // Alto de los recortes, en puntos de la guia; la pagina util es ~720.
    let alto = ej.recortes.map(r => r.at(2) - r.at(1)).sum()
    block(breakable: alto > 560, above: 14pt, below: 6pt)[
      #block(sticky: true, below: 4pt)[
        #text(fill: c-viole, weight: "bold", size: 11pt)[#mk(ej.titulo)]
      ]
      #let n = ej.recortes.len()
      #for (k, _) in ej.recortes.enumerate() {
        // el ultimo recorte queda pegado al tip y al resultado: que el
        // resultado no quede solo arriba de la pagina siguiente
        block(breakable: false, sticky: k == n - 1, above: 2pt, below: 2pt,
          image("recortes/" + ej.id + "-" + str(k + 1) + ".pdf", width: 100%))
      }
      #block(breakable: false, above: 2pt, below: 0pt)[
        #if "nota" in ej { nota(mk(ej.nota)) }
        #tip(mk(ej.tip))
        #if con-resultados { resultado(mk(ej.resultado)) }
      ]
    ]
    line(length: 100%, stroke: 0.3pt + luma(200))
  }
}
