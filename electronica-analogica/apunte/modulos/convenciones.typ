#import "../plantilla.typ": *

#seccion("Convenciones y notación", [
  Todo lo que hay que fijar *antes* de escribir la primera ecuación: cómo se leen las
  letras, hacia dónde apuntan las flechas, dónde está el cero de las tensiones, en qué
  valor se expresa un fasor, y cómo se escriben los números y las unidades. Nada de
  esto se demuestra: son acuerdos. No hay una elección correcta, hay una elección
  *declarada*. El apunte entero respeta la que sigue, y las dos veces que se aparta lo
  dice en el lugar.
])

// Sub-apartados: van como texto destacado y no como heading, porque esta
// seccion no numera y un heading de nivel 2 acá saldria numerado "0.1".
#let apartado(n, titulo) = block(above: 17pt, below: 7pt)[
  #text(size: 12pt, fill: c-azul, weight: "bold")[#n #h(5pt) #titulo]
]

#apartado[A][Mayúsculas, minúsculas y barras]

La misma letra dice cosas distintas según cómo esté escrita, y esa es toda la
información que hay que leer antes de operar.

#figure(
  table(
    columns: (auto, 1fr, auto),
    align: (center, left, left),
    table.header([*Cómo se escribe*], [*Qué significa*], [*Ejemplo*]),

    [$v$, $i$, $p$ \ #text(size: 8.5pt)[minúscula]],
    [Valor *instantáneo*: es una función del tiempo, y vale lo que valga en ese
     instante.],
    [$v(t) = 311 cos(314 t)$],

    [$V$, $I$, $P$ \ #text(size: 8.5pt)[mayúscula]],
    [Valor *constante*: o es continua, o es un valor característico ya calculado de una
     alterna (medio, eficaz, de pico).],
    [$V_"cc" = 12$ V],

    [$V_m$, $I_m$],
    [*Amplitud*, o valor de pico, de una senoidal. Es exactamente el $V_p$ de la Parte I:
     dos nombres del mismo número, por seguir a la cátedra en una parte y a la
     bibliografía de la otra.],
    [$V_m = 311$ V],

    [$V_"ef"$, $I_"ef"$],
    [Valor *eficaz* o RMS: el valor cuadrático medio a lo largo de un período
     (Módulo 2). Para la senoidal, $V_"ef" = V_m \/ sqrt(2)$.],
    [$V_"ef" = 220$ V],

    [$overline(V)$, $overline(I)$, $overline(Z)$ \ #text(size: 8.5pt)[con barra]],
    [Un *número complejo*: un fasor, o una impedancia. La barra es lo único que
     distingue $overline(Z)$ de su módulo $|Z|$.],
    [$overline(V) = 311 angle 0 degree$ V],

    [$|Z|$, $|overline(V)|$],
    [*Módulo* del complejo. Es un número real y positivo.],
    [$|Z| = 50 thin Omega$],

    [$overline(I)^*$],
    [*Conjugado*: mismo módulo, ángulo cambiado de signo.],
    [$(2 angle 30 degree)^* = 2 angle ang("−30°")$],

    [$bold(R)$, $bold(Z)$, $bold(i)$ \ #text(size: 8.5pt)[negrita]],
    [*Matriz* o *vector columna* del sistema de ecuaciones de nodos o de mallas.],
    [$bold(R) bold(i) = bold(v)$],
  ),
  caption: [Cómo se lee cada forma de escribir una magnitud],
)

*Los subíndices también tienen regla*: los que son *palabras* van en redonda y entre
comillas en el fuente —$V_"cc"$, $V_"ef"$, $R_"th"$, $f_"c"$—; los que son *índices* o
*variables* van en itálica —$v_1$, $i_k$, $R_S$, $overline(Z)_L$—. No es cosmética: en
$V_"m"$ la «m» sería la palabra *medio*, y en $V_m$ es la amplitud.

#apartado[B][La convención de signos pasiva]

#definicion("Convención pasiva — vale en todo el apunte")[
  La flecha de la corriente se dibuja *entrando por el terminal marcado* $+$ de la
  tensión. Con esa elección, y solo con esa, $p = v i$ es la potencia *absorbida* por el
  elemento:

  - $p > 0$ $arrow.r$ el elemento *consume* (se calienta, almacena o entrega trabajo);
  - $p < 0$ $arrow.r$ el elemento *entrega* energía al resto del circuito.

  Una fuente que alimenta al circuito da $p < 0$, y eso es lo correcto: no hay que
  cambiarle el signo «porque es una fuente». Se desarrolla en el Módulo 7.
]

#atencion[
  *Las polaridades y los sentidos que uno dibuja son supuestos, no verdades.* Se eligen
  antes de resolver y se respetan hasta el final. Si un resultado da negativo, no hay
  nada que corregir: significa que la magnitud real va al revés de la flecha dibujada.
  Volver atrás a «arreglar» el dibujo y recalcular es la forma más rápida de
  equivocarse, porque el error de signo se mete en las ecuaciones que ya estaban bien.

  El control final es siempre el mismo: la suma de las potencias *absorbidas* por todos
  los elementos tiene que dar cero — el teorema de Tellegen del Módulo 7. Si no cierra, hay un error, por
  razonables que parezcan las tensiones.
]

#apartado[C][El nodo de referencia]

#definicion("Nodo de referencia")[
  Un nodo del circuito se elige como *referencia* y se le asigna, por definición,
  $v = 0$. Se marca con el símbolo de tierra. Todo lo demás se mide contra él.

  - *Tensión de nodo*: $v_a$, siempre respecto de la referencia. Un subíndice.
  - *Tensión de rama*: entre dos nodos cualesquiera, $v_(a b) = v_a - v_b$, con el $+$
    en el primer subíndice. Dos subíndices.
]

#clave[
  La referencia es una *elección*, no un lugar físico privilegiado: cualquier nodo
  sirve, y las tensiones de rama —que son las que se miden con el voltímetro— dan
  igual con cualquiera de ellas. Lo único que cambia es cuánta cuenta hay que hacer.
  El criterio práctico, que se justifica en el Módulo 8: elegir el nodo con *más ramas
  concurrentes*, y entre ésos, el que sea *borne común de las fuentes de tensión* —cada
  fuente con un terminal en la referencia convierte una incógnita en un dato—.
]

#apartado[D][El sentido de las corrientes de malla y del recorrido]

#clave[
  *Todas* las corrientes de malla se definen en el mismo sentido, y en este apunte ese
  sentido es el *horario*. La LKT de cada malla se escribe recorriéndola en ese mismo
  sentido horario. Dos consecuencias, y son la razón de la regla:

  - La matriz $bold(R)$ (o $bold(Z)$ en alterna) queda *simétrica*, con la suma de las
    impedancias de la malla en la diagonal y *menos* la impedancia compartida fuera de
    ella. Se escribe por inspección, sin plantear nada.
  - Una rama compartida por las mallas $A$ y $B$ es recorrida por las dos en sentidos
    opuestos, así que por ella circula $i_A - i_B$. Nunca la suma.

  Mezclar sentidos *funciona* —el resultado sale igual— pero se pierde la regla por
  inspección y hay que deducir cada signo a mano. No vale la pena.
]

#apartado[E][El fasor va en valor de pico]

Es la convención que más se nota y la que más se presta a error, porque las dos partes
del apunte trabajan con valores distintos y las dos tienen razón para hacerlo.

#definicion("Convenio de fasor de este apunte")[
  Para una senoidal escrita como coseno,
  $ v(t) = V_m cos(omega t + phi) $
  el fasor es $ overline(V) = V_m angle phi $
  es decir, *el módulo del fasor es la amplitud*, no el valor eficaz.

  Es el convenio de los cuatro libros de la cátedra de Teoría de Circuitos
  —Nilsson-Riedel, Alexander-Sadiku, Hayt-Kemmerly y Dorf-Svoboda— y el que se usa en
  toda la Parte II.
]

#clave[
  *Por qué el coseno y no el seno.* Porque $"Re"{e^(j omega t)} = cos omega t$: con el
  coseno como referencia, el fasor sale de la identidad de Euler sin arrastrar un
  desfasaje de 90°. Una señal dada como seno se pasa a coseno primero, con
  $sin alpha = cos(alpha - 90 degree)$.
]

#definicion("Equivalencia con el valor eficaz")[
  La Parte I trabaja en *eficaz*, porque es lo que mide el multímetro en CA y lo que
  dice la chapa de cualquier aparato. La conversión entre las dos formas es un solo
  factor, $V_"ef" = V_m \/ sqrt(2)$, y aparece siempre en el mismo lugar:

  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    table.header([], [*En pico* (Parte II)], [*En eficaz* (Parte I)]),

    [Fasor de $V_m cos(omega t + phi)$],
      [$overline(V) = V_m angle phi$], [$overline(V) = (V_m\/sqrt(2)) angle phi$],
    [El módulo del fasor es], [lo que se lee en el osciloscopio],
      [lo que marca el multímetro],
    [Potencia activa], [$P = 1/2 V_m I_m cos theta$], [$P = V_"ef" I_"ef" cos theta$],
    [Potencia reactiva], [$Q = 1/2 V_m I_m sin theta$], [$Q = V_"ef" I_"ef" sin theta$],
    [Potencia aparente], [$S = 1/2 V_m I_m$], [$S = V_"ef" I_"ef"$],
    [Potencia compleja], [$overline(S) = 1/2 overline(V) thin overline(I)^*$],
      [$overline(S) = overline(V) thin overline(I)^*$],
    [Máxima transferencia], [$P_"máx" = (V_(m,"th")^2)/(8 R_"th")$],
      [$P_"máx" = (V_("ef","th")^2)/(4 R_"th")$],
    [$overline(Z)$, $overline(H)$, f.d.p., $Q$, BW, $|H|$ en dB],
      table.cell(colspan: 2, align: center)[*idénticos en las dos*: son cocientes, y el
        $sqrt(2)$ se cancela arriba y abajo],
  )

  *La regla para no equivocarse es una sola*: el factor $1\/2$ aparece exactamente
  donde se multiplican *dos amplitudes*, y no aparece nunca en un cociente. Por eso
  las impedancias, las funciones de transferencia, el factor de potencia, el factor de
  mérito y el ancho de banda no dependen del convenio, y las potencias sí.
]

#atencion[
  *Un dato de línea siempre viene en eficaz*, aunque el apunte trabaje en pico: «220 V»,
  «12 V de un transformador», «$V_"in" = 12 thin V_"ef"$ del TP N.º 7» son todos valores
  eficaces. Para llevarlos al fasor de la Parte II hay que multiplicar por $sqrt(2)$:

  $ 220 thin "V"_"ef" quad arrow.r quad overline(V) = 220 sqrt(2) angle 0 degree
    = 311 angle 0 degree "V" $

  Y al revés para informar un resultado que se va a medir con el multímetro. Lo que
  *nunca* se puede hacer es mezclar: un fasor en pico dividido por una impedancia da
  una corriente en pico, y meter esa corriente en $P = V I cos theta$ sin el $1\/2$ da
  el doble de la potencia real.
]

#apartado[F][Números, unidades y ángulos]

- *Coma decimal*, como corresponde al castellano: $0,707$, no $0.707$. El separador de
  miles no se usa: $16 thin 970$ se escribe $16970$.
- *Unidades del SI*, y siempre el símbolo, no el nombre: 50 Ω, 10 mH, 100 µF,
  1592 Hz. El del ohm es Ω y el del micro es µ, nunca «u». Adentro de una fórmula
  Typst las pega al número —$50 Omega$— y así quedan en todo el apunte; en el texto
  corrido van separadas.
- *Prefijos*: p, n, $mu$, m, k, M, G. En los cálculos se pasa todo a unidades base
  antes de operar —10 mH $= 10^(-2)$ H, 1 µF $= 10^(-6)$ F— y se vuelve al
  prefijo recién en el resultado. La mitad de los errores de orden de magnitud salen
  de no hacerlo.
- *Frecuencia y pulsación*: $f$ en hertz, $omega = 2 pi f$ en radián por segundo. En
  las fórmulas va $omega$; en los enunciados y en el generador, $f$.
- *Ángulos*: los resultados se informan en *grados* —$50 angle 53,13 degree$— porque
  es como se leen en el osciloscopio y en el diagrama fasorial, aunque $omega t$ esté
  en radianes. Las dos escalas conviven, y la conversión está en el Módulo 2.
- *Cifras significativas*: los resultados van con tres o cuatro, que es lo que
  justifica la tolerancia de los componentes. Un resistor del $5 %$ no habilita a
  informar seis dígitos.

#clave[
  *Cómo se lee un resultado antes de darlo por bueno.* Tres preguntas, en orden:
  ¿la unidad es la que corresponde?; ¿el orden de magnitud es razonable para el
  circuito que se está mirando?; ¿el signo dice lo que uno esperaba, y si no, qué
  significa que vaya al revés? Las tres se contestan sin rehacer la cuenta, y las tres
  agarran errores que una segunda pasada por la calculadora no agarra.
]
