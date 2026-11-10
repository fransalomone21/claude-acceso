// Galeria de apunte/biblioteca/figuras-cmg.typ: una figura por pagina, para
// mirarlas solas y para verificar-figuras.py (rotulos pisados o tachados).
#import "../apunte/biblioteca/figuras-cmg.typ": *
#set page(width: auto, height: auto, margin: 8pt)
#set text(lang: "es")
#show math.equation: eq => { show ",": it => math.class("normal", it); eq }
#fig-cmg-3d
#pagebreak()
#fig-cmg-analogia
#pagebreak()
#fig-cmg-silla
#pagebreak()
#fig-cmg-piramide
