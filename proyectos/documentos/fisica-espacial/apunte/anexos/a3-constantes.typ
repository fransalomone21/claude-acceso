// =====================================================================
//  Anexo C — Constantes
//  Cada valor numérico que usan los módulos y el Anexo A, con el libro y
//  la página de donde sale, MEDIDA en el PDF. Donde dos libros dan valores
//  distintos, van los dos. verificar-anexos.py exige "pág." en cada #cte.
// =====================================================================

#import "../plantilla.typ": *

// Una fila por VALOR, no por constante: si una constante tiene dos
// valores, son dos filas, y cada una lleva su propia fuente. Así el
// chequeo de "pág." es por valor y no alcanza con que una de dos la tenga.
#let cte(simbolo, que, valor, fuente) = block(breakable: false, above: 0pt, below: 0pt)[
  #set par(justify: false)
  #grid(
    columns: (1.5cm, 1fr, 4.7cm, 4.3cm),
    column-gutter: 8pt,
    inset: (y: 4.5pt),
    align: (left + horizon, left + horizon, left + horizon, left + horizon),
    text(size: 10pt)[#simbolo],
    text(size: 9pt)[#que],
    text(size: 9.5pt)[#valor],
    text(size: 8.5pt, fill: luma(70))[#fuente],
  )
  #line(length: 100%, stroke: 0.3pt + luma(200))
]

// El subtítulo y el encabezado van pegados a la primera fila (`sticky`):
// sin eso, "El Sol y Marte" quedó solo al pie de una página, con las
// filas en la siguiente. El `above` va en ESTE bloque: el del subtítulo,
// adentro, se pierde por ser lo primero del contenedor, y el título se
// montaba sobre el párrafo anterior.
#let grupo(titulo) = block(sticky: true, above: 18pt, below: 0pt)[
  #subtitulo-anexo(titulo)
  #v(-4pt)
  #grid(
    columns: (1.5cm, 1fr, 4.7cm, 4.3cm),
    column-gutter: 8pt,
    inset: (y: 3pt),
    ..([Símbolo], [Qué es], [Valor], [De dónde sale]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t]),
  )
  #line(length: 100%, stroke: 0.6pt + c-azul.lighten(30%))
]

#anexo("C", "Constantes", [
  Los números que usan los módulos y las fichas del Anexo A, cada uno con
  el libro y la página de donde sale. Cuando dos libros —o el mismo libro
  en dos lugares— dan valores distintos, van todos: la diferencia está en
  la cuarta cifra y casi nunca cambia un resultado, pero explica por qué
  la respuesta de un libro no coincide con la cuenta hecha con los datos
  del otro.
])

*Cómo se lee.* Las páginas son las *impresas* en el libro, no las del
PDF, y se midieron abriendo cada una. El Sears de la cátedra (S&Z) es el
volumen 1 de la edición 2018; «pág. A-7» es la numeración de sus
apéndices. En Curtis, las tablas del Apéndice A están en las páginas
737 y 738. Los valores de un ejemplo en particular —la masa de un satélite, la
altura de una órbita— no están acá: están en el enunciado del ejemplo.

Una advertencia que vale para toda la tabla: con cuatro cifras, $mu$ y
$G M$ *no* dan lo mismo. $mu_T$ se mide directamente de las órbitas y se
conoce con nueve cifras; $G$ y $M_T$ se conocen con cuatro cada una, así
que su producto trae el error de las dos. Por eso Curtis, que usa
$398 thin 600$ en todo el libro, en el ejemplo 2.16 calcula
$G m_1 = 398 thin 620$ y lo usa así: no es una errata, es otro camino.

#grupo[Constantes universales]
#cte($G$, [constante de gravitación], [$6,674 times 10^(-11)$ N·m²/kg²], [el valor que usa el apunte; S&Z lo usa así en un problema, pág. 430])
#cte([], [], [$6,673 thin 84 times 10^(-11)$ N·m²/kg²], [S&Z pág. 400, y pág. A-7])
#cte([], [], [$6,6742 times 10^(-20)$ km³/(kg·s²)], [Curtis pág. 14])
#cte([], [], [$6,672 thin 59 times 10^(-20)$ km³/(kg·s²)], [Curtis, ejemplo 2.16, pág. 128])
#cte($g$, [gravedad en la superficie terrestre], [$9,80$ m/s²], [S&Z pág. 50])
#cte([], [], [$9,806 thin 65$ m/s² (estándar)], [S&Z pág. A-7])
#cte([], [], [$9,81$ m/s²], [Beer págs. 618 y 726])
#cte($g_0$, [], [$9,807$ m/s²], [Curtis pág. 48])

#grupo[La Tierra]
#cte($R_T$, [radio], [$6,37 times 10^6$ m], [S&Z pág. A-8; Beer pág. 726])
#cte([], [], [$6378$ km], [Curtis, Tabla A.1, pág. 737])
#cte($M_T$, [masa], [$5,97 times 10^24$ kg], [S&Z pág. A-8])
#cte([], [], [$5,972 times 10^24$ kg], [S&Z pág. 403])
#cte([], [], [$5,974 times 10^24$ kg], [Curtis, Tabla A.1, pág. 737])
#cte($mu_T$, [parámetro gravitatorio, $G M_T$], [$398 thin 600$ km³/s²], [Curtis, Tabla A.2, pág. 738, y ec. 2.66, pág. 77])
#cte([], [], [$398 times 10^12$ m³/s² (sale de $g R^2$)], [Beer pág. 741])
#cte([], [], [$398 thin 620$ km³/s² (sale de $G m_1$)], [Curtis, ejemplo 2.16, pág. 128])
#cte([], [radio de la esfera de influencia], [$925 thin 000$ km], [Curtis, Tabla A.2, pág. 738])
#cte([], [radio de la órbita alrededor del Sol], [$1,50 times 10^11$ m], [S&Z pág. A-8])
#cte([], [], [$149,6 times 10^6$ km], [Curtis, Tabla A.1, pág. 737])
#cte([UA], [unidad astronómica], [$149 thin 597 thin 870,7$ km], [Curtis, Tabla A.3, pág. 738])

#grupo[La Luna]
#cte($M_L$, [masa], [$7,35 times 10^22$ kg], [S&Z pág. A-8])
#cte([], [], [$7,348 times 10^22$ kg], [Curtis, Tabla A.1, pág. 737])
#cte([], [], [$0,01230 thin M_T$], [Beer, problemas 12.85, pág. 733, y 13.101, pág. 806])
#cte($R_L$, [radio], [$1,74 times 10^6$ m], [S&Z pág. A-8])
#cte([], [], [$1737$ km], [Curtis, Tabla A.1, pág. 737])
#cte([], [], [$1740$ km], [Beer, problema 13.101, pág. 806])
#cte($mu_L$, [parámetro gravitatorio], [$4905$ km³/s²], [Curtis, Tabla A.2, pág. 738])
#cte([], [], [$4903$ km³/s²], [Curtis pág. 530; y $0,01230 thin mu_T$])
#cte([], [], [$4903,02$ km³/s²], [Curtis, ejemplo 2.16, pág. 128])
#cte([], [distancia media a la Tierra], [$3,84 times 10^8$ m], [S&Z pág. A-8])
#cte([], [], [$384 thin 400$ km], [Curtis, Tabla A.1, pág. 737])

#grupo[El Sol y Marte]
#cte($M_"Sol"$, [masa del Sol], [$1,99 times 10^30$ kg], [S&Z pág. A-8])
#cte([], [], [$1,989 times 10^30$ kg], [Curtis, Tabla A.1, pág. 737])
#cte($mu_"Sol"$, [parámetro gravitatorio del Sol], [$1,327 times 10^11$ km³/s²], [Curtis, Tabla A.2, pág. 738])
#cte([], [radio de la órbita de Marte], [$2,28 times 10^11$ m], [S&Z pág. A-8])
#cte([], [], [$227,9 times 10^6$ km], [Curtis, Tabla A.1, pág. 737])
#cte($tau_"Marte"$, [período de Marte], [$687,0$ días], [S&Z pág. A-8])
#cte([], [], [$1,881$ años], [Curtis, Tabla A.1, pág. 737])
#cte($M_"Marte"$, [masa de Marte], [$6,42 times 10^23$ kg], [S&Z pág. A-8])
#cte([], [], [$641,9 times 10^21$ kg], [Curtis, Tabla A.1, pág. 737])
#cte($mu_"Marte"$, [parámetro gravitatorio de Marte], [$42 thin 828$ km³/s²], [Curtis, Tabla A.2, pág. 738])
#cte([], [radio de la esfera de influencia de Marte], [$577 thin 000$ km], [Curtis, Tabla A.2, pág. 738])
