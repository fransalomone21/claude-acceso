#set page(
  paper: "a4",
  margin: (x: 1.9cm, y: 1.5cm),
  footer: context [
    #set text(8.5pt, fill: rgb("#777777"))
    #line(length: 100%, stroke: 0.4pt + rgb("#cccccc"))
    #v(-3pt)
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [Lavarropas Drean — desarme y armado],
      [#counter(page).display("1") / #context counter(page).final().first()],
    )
  ],
)

#set text(font: ("Segoe UI", "Arial"), size: 10.5pt, lang: "es")
#set par(justify: false, leading: 0.62em, spacing: 0.85em)

#let azul = rgb("#1f3864")
#let rojo = rgb("#c00000")
#let verde = rgb("#1e7a3c")
#let ambar = rgb("#b06000")

#show heading.where(level: 1): it => [
  #v(0.6em)
  #block(
    width: 100%, fill: azul, inset: (x: 10pt, y: 7pt), radius: 3pt,
    text(fill: white, size: 13pt, weight: "bold", it.body),
  )
  #v(0.3em)
]

#let caja(color, titulo, cuerpo) = block(
  width: 100%, fill: color.lighten(88%), stroke: (left: 3pt + color),
  inset: (x: 10pt, y: 8pt), radius: 2pt, breakable: false,
  [#text(weight: "bold", fill: color.darken(15%), titulo) #linebreak() #cuerpo],
)

#let n = counter("paso")
#let paso(titulo, cuerpo) = block(width: 100%, breakable: false, above: 0.7em, below: 0.3em)[
  #n.step()
  #grid(
    columns: (24pt, 1fr),
    gutter: 6pt,
    align: (right + top, left),
    text(weight: "bold", fill: azul, size: 11.5pt)[#context n.display()#text(fill: azul)[.]],
    [#text(weight: "bold")[#titulo] #linebreak() #cuerpo],
  )
]

// ------------------------------------------------------------------ portada

#align(center)[
  #text(size: 20pt, weight: "bold", fill: azul)[Cómo desarmarlo y volverlo a armar]
  #v(0.1em)
  #text(size: 12.5pt)[Lavarropas Drean Next 6.06 — para cambiarle los rulemanes]
]

#v(0.6em)

#caja(ambar)[Son dos tambores, uno adentro del otro][
  *El tambor de afuera* es el tacho blanco de plástico. No gira. Es el que
  aguanta el agua, y es el que hay que sacar y abrir.

  *El tambor de adentro* es el de chapa agujereada donde va la ropa. Ése gira, y
  su eje sale por el medio del de afuera. Ahí, en ese agujero, están los
  rulemanes.
]

#v(0.4em)

#caja(verde)[Desde dónde arrancan][
  La correa y la polea ya están afuera. Falta sacar el *tambor de afuera*,
  abrirlo, y cambiarle tres piezas: *los dos rulemanes y el retén* (un anillo de
  goma que tapa el paso del agua). Después se arma todo al revés.
]

#v(0.4em)

#caja(rojo)[Cuatro cosas que valen para todo el trabajo][
  #set enum(numbering: "1.", spacing: 0.4em)
  + *Siempre desenchufado.* Adentro hay 220 y una resistencia grande.
  + *Sacá una foto con el celu antes de desconectar cada cosa.* Después, cuando
    tengas veinte cables sueltos, esa foto es lo único que te salva.
  + *Entre dos.* El tambor de afuera con los contrapesos pesa como 30 kilos.
  + *Todo lo que sacás va a una caja*, y los tornillos de cada paso juntos.
]

= Para sacarlo

#paso[Sacale el agua que le queda][
  El filtro está abajo adelante, detrás de la tapita. Poné un trapo y una fuente
  porque salen uno o dos litros. Cerrá la canilla y sacale la manguera.
]

#paso[Sacá la tapa de arriba][
  Tiene dos tornillos atrás. Después la corrés *para atrás* y recién ahí se
  levanta.
]

#paso[Soltá la goma de la puerta][
  Es el fuelle. Lo agarra un *aro de alambre con un resorte*. Buscá el resorte,
  hacé palanca despacio con un destornillador chico y el aro sale entero.
  Después despegá la goma del frente y metela para adentro.
]

#paso[Sacá el contrapeso de arriba][
  Son bulones de 13. Ojo con el último, porque el bloque se suelta de golpe y es
  pesado. Los de los costados dejalos si no te molestan.
]

#paso[Desconectá todo lo que va al tambor de afuera][
  De a uno, y con foto de cada uno antes:
  #v(0.2em)
  #block(inset: (left: 10pt))[
    - la *manguera gruesa* que baja del cajón del jabón, arriba;
    - la *manguerita fina* que mide el nivel del agua, arriba;
    - los *cables de la resistencia*, abajo atrás;
    - la *manguera gorda* que va a la bomba, abajo;
    - el *cable de tierra*, el verde y amarillo.
  ]
]

#paso[Soltá los amortiguadores][
  Son los dos de abajo. Cada uno tiene un pasador o un bulón: sacá el de arriba
  nomás, el que va al tambor. El de abajo dejalo.
]

#paso[Sacá el tambor de afuera][
  Queda colgado de los *resortes de arriba*. Uno lo levanta para descolgar los
  resortes y el otro lo aguanta. Sale para adelante o para arriba, según cómo
  venga. Apoyalo en el piso sobre una manta.
]

#paso[Marcá las dos mitades con fibra][
  Una raya que cruce la unión, antes de abrirlo. *Son diez segundos y te ahorran
  una hora*, porque las dos mitades encajan en una sola posición y no te das
  cuenta cuál es hasta que las probaste todas.
]

#paso[Abrilo][
  Sacá los tornillos o las grampas que tiene alrededor de todo el borde. Si son
  grampas metálicas, se levantan con un destornillador plano. Separá las dos
  mitades de a poco y dando vuelta, nunca tirando de un solo lado.
]

#paso[Sacá el tambor de adentro][
  Sale con su araña de metal y el eje puestos. Apoyalo con el eje para arriba.
]

#v(0.6em)

#caja(ambar)[Lo que hay adentro del agujero del medio, en orden][
  Mirando desde afuera hacia el agua:
  #v(0.3em)
  #align(center)[
    #text(10pt)[
      polea #sym.arrow.r rulemán chico #sym.arrow.r arito separador
      #sym.arrow.r rulemán grande #sym.arrow.r
      #text(fill: rojo, weight: "bold")[RETÉN] #sym.arrow.r tambor de adentro
    ]
  ]
  #v(0.2em)
  *Esas tres piezas son las que se cambian*: los dos rulemanes y el retén.
]

#paso[Sacá el retén][
  Está del lado de adentro, el lado del agua. Hacele palanca con un
  destornillador plano y tiralo, total va a la basura. Tratá de no marcar el
  metal del agujero.
]

#paso[Sacá los dos rulemanes][
  Golpeá desde el otro lado con un caño o una varilla apoyada en *el borde de
  afuera* del rulemán. Y andá *dando vuelta alrededor, de a poquito*. Si pegás
  siempre en el mismo lugar, se pone torcido y se traba.
]

#paso[Mirale el eje — acá se decide todo][
  Pasale la uña al eje, justo donde apoyaba la gomita del retén:
  #v(0.2em)
  #block(inset: (left: 10pt))[
    - *Si está liso* #sym.arrow todo bien, seguí.
    - *Si tiene un surco o está picado* #sym.arrow #text(fill: rojo,
      weight: "bold")[pará acá.] El retén nuevo va a volver a perder en unos
      meses. Hay que cambiar la araña con el eje, y eso conviene preguntarlo
      antes de comprar nada.
  ]
]

#paso[Anotá lo que dice grabado en cada rulemán][
  En el borde dice algo tipo `6203-2RS` y `6204-2RS`. *Con eso comprás*, no con
  el modelo del lavarropas. Del retén, medilo con calibre. Y llevá las piezas
  viejas a la casa de repuestos: es lo más seguro.
]

= Para armarlo de nuevo

Todo al revés. Marqué las dos cosas que si salen mal te hacen desarmar otra vez.

#paso[Limpiá bien el agujero][
  Sacá todo el óxido y la grasa vieja de donde van los rulemanes, con lija fina o
  un trapo con desengrasante. Tiene que quedar liso. Un rulemán nuevo apoyado
  sobre óxido entra torcido.
]

#paso[Meté los rulemanes][
  *Primero el grande, del lado de adentro. Después el chico, del lado de afuera*,
  con el arito separador en el medio como estaba.

  Entran a golpes, pero *pegándole solamente al borde de afuera* — con un caño
  del diámetro justo, o usando el rulemán viejo como taco.
  #text(weight: "bold", fill: rojo)[Nunca le pegues al aro del medio]: la fuerza
  pasa por las bolillas y el rulemán nuevo se arruina antes de andar. Andá dando
  vuelta hasta que toque el fondo y te cambie el sonido.
]

#paso[Poné el retén, que va último][
  Del lado de adentro, con *la gomita mirando para el agua*, igual que estaba el
  viejo. Antes de meterlo, pasale un poquito de grasa a la gomita. Entra derecho,
  apretando parejo con los dedos o con un taco plano.
]

#paso[Meté el eje sin cortar la gomita][
  #text(weight: "bold", fill: rojo)[Ésta es la que más se arruina.] Engrasá el
  eje y metelo *derecho y girando*, nunca de costado ni a los golpes. Si la
  gomita se corta al entrar, el lavarropas pierde agua desde el primer lavado y
  no te enterás hasta que es tarde.
]

#paso[Cerrá el tambor de afuera][
  Junta nueva, o un cordón parejo de silicona neutra si la vieja está entera.
  Alineá con *la raya de fibra* que hiciste en el paso 8. Los tornillos se
  aprietan *en cruz* y en dos vueltas: primero todos flojitos, después todos
  firmes. Nunca uno a fondo y después el de al lado.
]

#paso[Colgalo de nuevo adentro del lavarropas][
  Entre dos. *Primero los resortes de arriba*, y recién con el tambor colgando
  ponés los amortiguadores de abajo.
]

#paso[Conectá todo de nuevo, mirando las fotos][
  Manguera del cajón del jabón, manguerita del nivel, cables de la resistencia,
  manguera de la bomba, cable de tierra. Las abrazaderas bien apretadas: una
  manguera floja te la encontrás recién cuando hay agua en el piso.
]

#paso[Goma de la puerta y aro][
  La goma vuelve a su canal en el frente, pareja en toda la vuelta. El aro de
  alambre va con el resorte en el mismo lugar que estaba (mirá la foto). Pasá el
  dedo por todo el borde para ver que quedó bien metida.
]

#paso[Contrapeso y polea][
  El contrapeso con sus bulones firmes. La polea va con *la tuerca y
  trabaquímico nuevo*. Para poder apretarla, *trabá el tambor*: una madera entre
  dos rayos de la polea, apoyada contra el tambor de afuera.
]

#paso[Poné la correa][
  Primero la calzás *en la polea grande*. Después la llevás a la del motor
  *girando la polea grande con la mano* mientras la empujás. Nunca con
  destornillador, que la cortás. Tiene que quedar centrada en las dos.
]

#paso[Tapa de arriba, tapa de atrás, manguera y enchufe][
  Recién ahora. Y antes de dejarlo en su lugar, emparejá las cuatro patas: que
  ninguna baile.
]

= Probarlo — en este orden, y si una falla pará ahí

#paso[Girá el tambor de adentro con la mano][
  Tiene que ir suave y callado. Si todavía hace ruido, algo quedó mal puesto: no
  cierres nada y revisá.
]

#paso[Un lavado cortito sin ropa][
  Mirando abajo con linterna mientras anda. No tiene que aparecer ni una gota.
]

#paso[Cuando termina, mirá el centro de la polea][
  Tiene que estar *seco*. Si hay una gota, la gomita del retén se lastimó al
  entrar — y es mil veces más barato arreglarlo ahora que en tres meses.
]

#paso[Un lavado normal con ropa][
  Con carga es cuando de verdad se escucha si quedó bien.
]

#v(0.5em)

*Si el ruido se fue pero no saben qué lo arregló, anótenlo igual.* Lo que se
arregla sin saber por qué, vuelve.
