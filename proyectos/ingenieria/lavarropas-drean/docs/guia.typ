#set page(
  paper: "a4",
  margin: (x: 2cm, y: 1.9cm),
  footer: context [
    #set text(8.5pt, fill: rgb("#777777"))
    #line(length: 100%, stroke: 0.4pt + rgb("#cccccc"))
    #v(-3pt)
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [Lavarropas Drean Next 6.06 ECO], [#counter(page).display("1") / #context counter(page).final().first()],
    )
  ],
)

#set text(font: ("Segoe UI", "Arial"), size: 10.5pt, lang: "es")
#set par(justify: true, leading: 0.68em, spacing: 1.0em)

#show heading.where(level: 1): it => [
  #v(0.7em)
  #block(
    width: 100%,
    fill: rgb("#1f3864"),
    inset: (x: 10pt, y: 7pt),
    radius: 3pt,
    text(fill: white, size: 13pt, weight: "bold", it.body),
  )
  #v(0.35em)
]

#show heading.where(level: 2): it => [
  #v(0.5em)
  #text(size: 11.5pt, weight: "bold", fill: rgb("#1f3864"), it.body)
  #v(0.15em)
]

#set table(stroke: 0.5pt + rgb("#bbbbbb"))
#show table.cell.where(y: 0): set text(weight: "bold", fill: white)

#let caja(color, titulo, cuerpo) = block(
  width: 100%,
  fill: color.lighten(88%),
  stroke: (left: 3pt + color),
  inset: (x: 10pt, y: 8pt),
  radius: 2pt,
  breakable: false,
  [#text(weight: "bold", fill: color.darken(15%), titulo) #linebreak() #cuerpo],
)

#let rojo = rgb("#c00000")
#let verde = rgb("#1e7a3c")
#let ambar = rgb("#b06000")

// ---------------------------------------------------------------- portada

#align(center)[
  #v(0.5em)
  #text(size: 23pt, weight: "bold", fill: rgb("#1f3864"))[
    Lavarropas Drean Next 6.06 ECO
  ]
  #v(0.2em)
  #text(size: 15pt)[Guía para encontrar el ruido y arreglarlo]
  #v(0.5em)
  #text(size: 10pt, fill: rgb("#666666"))[
    6 kg · 600 rpm · 220 V – 1700 W · carga frontal con correa
  ]
]

#v(0.8em)

#caja(verde)[Cómo se usa esta guía][
  Está en orden y no hay que saltear pasos. Lo primero son los *siete tests* de
  la página 2: 20 minutos, máquina desenchufada y *sin comprar nada*.
]

= 1. Lo que NO hay que hacer

Estas siete cosas son las que arruinan una reparación que iba bien.

#block(inset: (left: 2pt))[
  #set enum(numbering: "1.", spacing: 0.75em)
  + *No enchufar con la tapa de atrás sacada.* Adentro hay 220 V expuestos y
    una resistencia de unos 1500 W en la panza del tambor. Desenchufar
    #emph[y esperar 5 minutos] antes de meter la mano.
  + *No comprar los rulemanes antes de tener el viejo en la mano.* El número
    está grabado en el aro de la pieza. Comprar "por modelo" desde una
    publicación de internet es la forma más común de terminar con un repuesto
    que no entra.
  + *No hacer palanca con destornillador contra la polea.* La polea de esta
    máquina es *de plástico* y se parte. Sale con extractor o con golpes
    suaves de taco de madera, nunca con palanca.
  + *No pegarle al eje con el martillo directo.* Se aplasta la punta roscada y
    después no entra la polea. Siempre con taco de madera o punta de bronce.
  + *No poner aceite en los rulemanes.* Van con *grasa* para rodamientos. El
    aceite se escurre en una semana y vuelve el ruido.
  + *No cambiar sólo los rulemanes si el eje está picado.* Es el error caro:
    vuelve a perder agua en dos o tres meses. Ver paso F.
  + *No levantar el tambor de a uno.* Con los contrapesos pesa entre 25 y 30 kg
    y sale de golpe. Dos personas.
]

= 2. Qué sospechamos, y por qué

*Rulemanes del tambor comidos, por retén vencido.* Todavía es una sospecha:
confirmarla con las manos es lo que hacen los tests. Dos cosas la apoyan:

- *El ruido creció de a poco durante meses.* Lo que aparece de golpe es un
  objeto atrapado; lo que crece de a poco es un desgaste.
- *El óxido de la polea.* Alrededor del cubo y sobre las aspas hay óxido
  marrón tirado hacia afuera: es agua oxidada que sale del rodamiento y que el
  centrifugado despide.

#caja(ambar)[Cómo es la falla][
  El eje del tambor sale por un cubo. Ahí hay un *retén* (un anillo de goma que
  tapa el paso del agua) y detrás *dos rulemanes* que sostienen el eje. El retén
  se vence primero, el agua moja los rulemanes, les lava la grasa y los oxida —
  y ahí empiezan a rugir. *Por eso el retén se cambia siempre junto con los
  rulemanes:* cambiar sólo el rodamiento es dejar puesta la causa.
]

#pagebreak()

= 3. Los siete tests — 20 minutos, sin comprar nada

Máquina *desenchufada*, canilla cerrada, tapa de atrás sacada. La correa ya
está afuera, así que los tests 1 a 4 se pueden hacer directamente.

#table(
  columns: (auto, 1.35fr, 1.1fr, 1fr),
  align: (center + horizon, left, left, left),
  inset: (x: 7pt, y: 6pt),
  fill: (_, y) => if y == 0 { rgb("#1f3864") } else if calc.odd(y) { rgb("#f2f4f8") },
  table.header([*\#*], [*Qué se hace*], [*Qué se ve*], [*Qué significa*]),

  [*T1*], [*Girar el tambor a mano*, despacio y después rápido],
  [Rugido áspero, granulado, "como arena". Se siente en la mano],
  [*Rulemanes.* Sano = gira suave y en silencio],

  [*T2*], [Tomar el tambor *por el borde de adentro* y moverlo para arriba y para abajo],
  [Juego, un "clonk", o el tambor baja y sube],
  [*Rulemanes.* Sano = juego casi nulo],

  [*T3*], [Empujar el tambor *hacia adentro* y tirarlo *hacia afuera*],
  [Se mueve más de 1 o 2 mm],
  [*Rulemanes* (juego a lo largo del eje)],

  [*T4*], [Girar *el eje del motor* a mano (el motor está abajo)],
  [El ruido áspero está ahí y no en el tambor],
  [*Es el motor*, no el tambor],

  [*T5*], [Con la máquina cerrada: empujar una esquina para abajo y *soltar*],
  [Sigue oscilando 3 o 4 veces antes de frenar],
  [*Amortiguadores gastados.* Sanos = frena casi en el acto],

  [*T6*], [Linterna *entre el tambor de adentro y el de afuera*, girando el tambor despacio],
  [Moneda, aro de corpiño, clavo, botón, hebilla],
  [*Objeto atrapado* — el arreglo más barato que hay],

  [*T7*], [Mirar el *cubo central de la polea* y las aspas],
  [Óxido marrón tirado hacia afuera],
  [*Retén vencido*, y por lo tanto rulemanes mojados],
)

== Cómo leer los resultados

#table(
  columns: (1.1fr, 1fr, 1fr),
  align: (left, left, left),
  inset: (x: 7pt, y: 6pt),
  fill: (_, y) => if y == 0 { rgb("#1f3864") } else if calc.odd(y) { rgb("#f2f4f8") },
  table.header([*Cómo suena*], [*Cuándo aparece*], [*Causa más probable*]),

  [*Rugido, molinillo, avión* — crece con la velocidad],
  [Peor en el centrifugado; creció con los meses],
  [*Rulemanes* #sym.arrow.l es lo que describimos],

  [*Metálico, rasca, tintinea*], [Apareció de golpe, un día],
  [Objeto atrapado entre los dos tambores],

  [*Golpes secos*, la máquina camina], [Sólo en centrifugado, con poca carga],
  [Amortiguadores o resortes],

  [*Chillido agudo*, olor a goma], [Al arrancar el giro], [Correa gastada o floja],

  [*Chirrido agudo y chispas* en el motor], [Todo el ciclo],
  [Escobillas del motor gastadas],

  [*Ruido sólo al vaciar el agua*], [Sólo en el desagote],
  [Bomba de desagote con un objeto],
)

#v(0.4em)

#caja(rojo)[Antes de seguir: anotar en un papel qué dio cada test][
  Si T1 y T2 dan negativo — el tambor gira suave y no tiene juego — *los
  rulemanes no son*, y comprar el kit es plata tirada. Ese es todo el punto de
  esta página.
]

#pagebreak()

= 4. El desarme, paso a paso

Se entra *por atrás*. Dos personas. Sacar fotos con el celular en cada paso: es
lo único que después dice cómo volvía cada cable.

#block(inset: (left: 2pt))[
  #set terms(separator: [ — ], hanging-indent: 0pt, spacing: 0.8em)

  / *A. Preparar*: Desenchufar. Cerrar la canilla y sacar la manguera de
    entrada. Vaciar el agua que queda (el filtro está abajo adelante, detrás de
    la tapita: poner un trapo y una fuente, salen uno o dos litros). Sacar la
    tapa trasera con llave tubo de 8.

  / *B. Sacar la correa*: y marcarla con birome del lado que iba hacia afuera.

  / *C. Aflojar el centro de la polea*: En esta máquina el eje termina en *rosca
    macho* y la polea la aprieta una *tuerca* — no hay hueco allen. Primero
    *trabar el tambor* para que no gire: una madera entre dos radios de la polea
    apoyada contra el tambor de afuera, o una mano adentro del tambor. Dos avisos: si no
    cede con fuerza normal, *probar al revés antes de seguir forzando* — algunos
    lavarropas llevan rosca invertida ahí, y reventarla es el peor final
    posible. Y si no sale en frío, calor suave con secador de pelo ablanda el
    sellador verde de fábrica.

  / *D. Sacar la polea*: Con extractor de tres patas apoyado en el *cubo*, nunca
    en las aspas. Sin extractor: volver a enroscar la tuerca hasta que quede al
    ras de la punta del eje — así protege la rosca — y golpes suaves y
    alternados de taco de madera.
]

#v(0.3em)

#caja(ambar)[Qué hay adentro del cubo, y dónde está el retén][
  Sacando la polea *no aparece el retén*: aparece el rulemán de afuera. El orden
  de las piezas, desde donde estás mirando hacia el agua, es:

  #v(0.4em)
  #align(center)[
    #text(9.5pt)[
      tuerca #sym.arrow.r *polea* #sym.arrow.r rulemán chico (6203)
      #sym.arrow.r separador #sym.arrow.r rulemán grande (6204)
      #sym.arrow.r #text(fill: rojo, weight: "bold")[RETÉN] #sym.arrow.r cruceta del tambor
    ]
  ]
  #v(0.3em)

  El retén es *la última pieza, del lado del agua*. No se ve desde afuera y no
  se saca con el tambor puesto: para llegar hay que sacar el tambor de afuera y abrirlo
  (paso E). Sacar la polea es el 5% del trabajo — el resto es lo de abajo.
]

#v(0.3em)

#block(inset: (left: 2pt))[
  #set terms(separator: [ — ], hanging-indent: 0pt, spacing: 0.8em)

  / *E. Sacar el tambor de afuera y abrirlo*: Es el tacho de plástico donde va
    metido el tambor de chapa. Salen primero los contrapesos de hormigón, la
    manguera del cajón de jabón, los cables de la resistencia, las trabas del
    fuelle, los amortiguadores y los resortes de arriba. Sale entero por adelante
    o por arriba, entre dos. Después, mirar el perímetro donde se juntan las dos
    mitades:
]

#v(-0.3em)
#block(inset: (left: 18pt))[
  - *Hay una corona de tornillos o de grampas metálicas* #sym.arrow se abre, y
    el arreglo es el normal.
  - *La junta es lisa y continua, sin tornillos* #sym.arrow está soldado de
    fábrica. Ahí hay dos caminos: comprar el *tambor de afuera completo, con los
    rulemanes ya puestos* (bastante más caro, pero se resuelve en una tarde), o que un
    técnico lo *corte y lo vuelva a unir con bulones y sellador* — se hace y
    funciona, pero no es trabajo para la primera vez.
]

#v(0.3em)
#block(inset: (left: 2pt))[
  #set terms(separator: [ — ], hanging-indent: 0pt, spacing: 0.8em)

  / *F. Sacar el tambor de adentro y mirar el eje*: #text(fill: rojo, weight: "bold")[Este
    es el punto de decisión caro.] Con el de afuera abierto, el de adentro sale
    con su cruceta y su eje. Pasar la uña por el tramo de eje donde apoyaba el labio del
    retén:
]

#v(-0.3em)
#block(inset: (left: 18pt))[
  - *Eje liso* #sym.arrow cambiar retén y rulemanes, y listo. Es el caso bueno.
  - *Eje con surco, escalón o picado* #sym.arrow el retén nuevo va a perder
    igual, porque apoya sobre una superficie que ya no es lisa. Hay que cambiar
    la cruceta con eje, que es cara. *Si aparece esto, pedir presupuesto antes
    de comprar nada.*
]

#v(0.3em)
#block(inset: (left: 2pt))[
  #set terms(separator: [ — ], hanging-indent: 0pt, spacing: 0.8em)

  / *G. Sacar el retén y los rulemanes viejos*: El retén sale primero, del lado
    de adentro, haciendo palanca con un destornillador (total se tira). Los
    rulemanes salen a golpes desde el lado opuesto, con una varilla o un tubo
    apoyado en el aro #emph[exterior], dando vuelta alrededor y un poquito por
    vez. Nunca todo de un lado, porque se traba.

  / *H. Anotar el número grabado en cada rulemán*: Está marcado en el aro, tipo
    `6203-2RS` o `6204-2RS`. #text(weight: "bold")[Con eso se va a comprar], no
    con el modelo del lavarropas. Del retén, medir con calibre: diámetro
    interno, externo y espesor.

  / *I. Poner los nuevos*: Limpiar bien el alojamiento. Entran golpeando
    #emph[sólo el aro exterior] — con un tubo del diámetro justo, o usando el
    rodamiento viejo como taco — derechos y hasta que apoyen a fondo. El retén
    va último y con el labio hacia adentro (hacia el agua), con una película fina
    de grasa en el labio.

  / *J. Armar al revés*: con junta nueva o sellador en la unión del tambor de afuera, y la
    tuerca de la polea con trabaquímico nuevo.
]

= 5. Qué comprar

#caja(rojo)[Regla de oro][
  Se compra *después del paso H*, con el rulemán viejo en la mano. Los números
  de abajo son para saber cuánto va a salir, no para comprar a ciegas.
]

#v(0.5em)

#table(
  columns: (1.1fr, 1.4fr, auto),
  align: (left, left, right),
  inset: (x: 7pt, y: 6pt),
  fill: (_, y) => if y == 0 { rgb("#1f3864") } else if calc.odd(y) { rgb("#f2f4f8") },
  table.header([*Qué*], [*Detalle*], [*Precio aprox.*]),
  [*Kit rulemanes + retén*], [Lo venden armado], [\$18.000 – \$21.000],
  [Grasa para rodamientos], [Un pote chico alcanza y sobra], [\$3.000 – \$6.000],
  [Trabaquímico (Loctite)], [Para la tuerca de la polea], [\$4.000 – \$8.000],
)

#v(0.5em)

*Las medidas.* Los Drean de 6 y 7 kg llevan un *6203* y un *6204*; los de 8 kg
y más, un 6204 y un 6205 — no es este caso. Las medidas típicas del kit de 6 kg:

#block(inset: (left: 14pt))[
  - *6203-2RS* #sym.arrow 17 mm interno × 40 externo × 12 de alto
  - *6204-2RS* #sym.arrow 20 mm interno × 47 externo × 14 de alto
  - *Retén* #sym.arrow 25 × 47 × 8 / 11,5 mm
]

#caja(ambar)[Por qué igual hay que leer el número grabado][
  Esas medidas están publicadas para la línea *Drean Blue / Excellent 6.06*.
  Para el *Next 6.06* hay kits vendidos por modelo, pero no se pudo confirmar
  que las medidas sean las mismas. Llevar el rulemán viejo a la casa de
  repuestos es lo que convierte esto en seguro.
]

#v(0.5em)

*Dónde conviene comprarlo.* En una *casa de rulemanes* suele salir bastante
menos que el "kit para lavarropas": un 6203-2RS y un 6204-2RS de marca (SKF,
NSK, FAG) son rodamientos estándar de cualquier máquina. El único que conviene
comprar como repuesto específico de lavarropas es el retén.

== Lo que puede sumarse, según los tests

#table(
  columns: (1fr, 1.3fr),
  align: (left, left),
  inset: (x: 7pt, y: 6pt),
  fill: (_, y) => if y == 0 { rgb("#1f3864") } else if calc.odd(y) { rgb("#f2f4f8") },
  table.header([*Si dio positivo*], [*Qué se compra*]),
  [*T5* — sigue oscilando], [*Par de amortiguadores.* Se cambian de a dos, nunca uno],
  [Correa rajada, vidriosa o floja], [*Correa*, por lo que dice grabado en el lomo (tipo `1195 J5`)],
  [*Paso E* con el tambor de afuera soldado], [*Bidón completo con rulemanes*, o la mano de obra del técnico],
  [*Paso F* con eje picado], [*Cruceta con eje.* Acá conviene presupuestar antes de comprar],
)

== Herramientas

Llaves tubo de 8, 10 y 13 · destornilladores plano y Philips · juego de llaves
allen · pinza · martillo · un taco de madera dura · un tubo o caño del diámetro
del rulemán para calzarlo · calibre · linterna · trapos.

*Un extractor de poleas* es lo único que quizá haya que pedir prestado, y es lo
que evita romper la polea de plástico.

= 6. La prueba final

Con todo armado y *antes de poner la tapa*:

#block(inset: (left: 2pt))[
  #set enum(numbering: "1.", spacing: 0.75em)
  + *Girar el tambor a mano.* Tiene que girar suave y en silencio. Si sigue
    rugiendo, algo quedó mal puesto: no cerrar y seguir.
  + *Un ciclo corto, sin ropa, con la tapa puesta.* Escuchar el lavado y el
    centrifugado por separado.
  + *Después del ciclo, mirar el cubo de la polea con linterna.* Tiene que estar
    *seco*. Una gota ahí significa que el retén está perdiendo desde el día uno,
    y es mil veces más barato atenderlo ahora que en tres meses.
  + *Una carga normal de ropa.* El ruido y la vibración con carga son el test de
    verdad.
]

#caja(verde)[Y si el ruido se fue pero no sabemos qué lo arregló][
  Anotarlo igual. Un arreglo que no se puede explicar es una coincidencia que
  todavía no se descubrió — y vuelve.
]

= 7. Cuándo parar y llamar al técnico

Parar no es fracasar: es lo que evita convertir un arreglo de \$20.000 en un
lavarropas nuevo.

#block(inset: (left: 14pt))[
  - *El tambor de afuera está soldado* y no hay ganas de cortarlo y bulonarlo.
  - *El eje está picado* (paso F).
  - *La tuerca de la polea no afloja* ni con calor, y se empieza a redondear.
  - *Aparece agua donde no debería* — por ejemplo, si la máquina ya perdía y
    nadie sabía de dónde.
  - *El ruido resultó ser el motor* (T4). Las escobillas se cambian, pero un
    motor con el colector comido es otra historia.
]

Pedir *dos presupuestos*, y preguntarle a los dos exactamente lo mismo: si abre
el tambor de afuera, si cambia el retén además de los rulemanes, y si la mano de obra
incluye el desarme.

= 8. Para que no vuelva a pasar

Los rulemanes se comen porque el retén se vence, y el retén se vence antes
cuando la máquina trabaja forzada.

#block(inset: (left: 14pt))[
  - *No sobrecargar.* El tope son 6 kg, y es 6 kg de ropa #emph[seca]. Una carga
    desbalanceada castiga el eje en cada centrifugado.
  - *Nivelar la máquina.* Las cuatro patas apoyadas y firmes. Si una baila, el
    tambor trabaja torcido toda su vida.
  - *Un lavado a 60 °C vacío cada tanto*, para que no se acumule jabón y
    grasitud adentro.
  - *Dejar la puerta entreabierta* entre lavados.
]
