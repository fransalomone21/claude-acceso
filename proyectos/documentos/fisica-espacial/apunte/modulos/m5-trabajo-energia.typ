#import "../plantilla.typ": *

#modulo("Trabajo y energía")[
  Calcular el trabajo de una fuerza que cambia a lo largo de un camino curvo;
  usar el teorema trabajo–energía en vez de integrar la ecuación de movimiento;
  decidir si una fuerza admite energía potencial —y demostrar que *toda* fuerza
  central lo hace—; y leer un diagrama de energía: dónde está el equilibrio,
  hasta dónde llega la partícula y dónde va más rápido, sin resolver ninguna
  ecuación diferencial.
]

Este módulo cierra la Parte II, y es el que más rinde en la Parte III. La razón
es concreta: la ecuación de movimiento de una órbita no se puede integrar de
cabeza, pero la conservación de la energía se escribe en un renglón y ya
contesta la mitad de las preguntas — si la órbita es cerrada o abierta, cuánto
vale la velocidad en el perigeo, cuánto cuesta escapar. La máquina que se arma
acá —el *diagrama de energía*— es literalmente la misma que en el módulo 9 se
aplica al potencial eficaz.

== El trabajo de una fuerza

Para una fuerza constante y un desplazamiento rectilíneo $bold(s)$ (S&Z §6.1,
ec. 6.2 y 6.3, pág. 173):

$ W = bold(F) dot bold(s) = F s cos phi $

El producto escalar del módulo 1, otra vez, y con el mismo significado: lo que
cuenta es *la componente de la fuerza en la dirección del movimiento*. Para una
fuerza que cambia a lo largo de un camino curvo hay que sumar pedacito a
pedacito (S&Z §6.3, ec. 6.14, pág. 187):

$ W = integral_(P_1)^(P_2) bold(F) dot d bold(l) $ <m5-trabajo>

#clave[
  *Una fuerza perpendicular a la velocidad no trabaja nunca.* Sale directo de
  la @m5-trabajo, porque $d bold(l)$ va siempre en la dirección de $bold(v)$ y
  el producto escalar da cero. Tres casos que se usan todo el tiempo:

  - La *normal* de un vínculo — por eso una cuenta ensartada en un alambre liso
    conserva la energía aunque el alambre la empuje todo el tiempo.
  - La fuerza *magnética* sobre una carga.
  - La fuerza *centrípeta* en una órbita circular: la gravedad no le hace
    trabajo a un satélite en órbita circular, y por eso su rapidez no cambia.
    Ese es medio argumento de por qué «orbita sin caer»; el otro medio está en
    el módulo 6.
]

== El teorema trabajo–energía

#deduccion("de la segunda ley al teorema, en tres renglones")[
  Partiendo de la @m5-trabajo con la fuerza *neta*, y usando
  $bold(F) = m d bold(v) \/ d t$ y $d bold(l) = bold(v) d t$:
  $ W_"tot" = integral m (d bold(v))/(d t) dot bold(v) d t = integral m bold(v) dot d bold(v) $
  Y como $bold(v) dot d bold(v) = 1/2 d(bold(v) dot bold(v)) = 1/2 d(v^2)$:
  $ W_"tot" = integral_(v_1)^(v_2) 1/2 m d(v^2) = 1/2 m v_2^2 - 1/2 m v_1^2 = Delta K $
  (S&Z §6.2, ec. 6.6, pág. 177.) La identidad del medio es la misma de dos
  renglones del módulo 1: derivar un producto escalar de un vector consigo
  mismo.
]

$ W_"tot" = Delta K, quad K = 1/2 m v^2 $ <m5-teorema>

#clave[
  El valor del teorema es que *pasa por alto el tiempo y el camino*. No hace
  falta saber cuánto tardó ni por dónde fue: si se conoce el trabajo total, se
  conoce el cambio de rapidez. Esa es la misma economía que hace útil a la
  conservación de $bold(P)$, y la razón por la que los tres teoremas de
  conservación se estudian juntos.
]

#cuidado[
  $K$ es un *escalar* y no tiene dirección ni signo: $K = 1/2 m v^2 gt.eq 0$
  siempre, incluso si la partícula va para atrás. La que puede ser negativa es
  $Delta K$, y el que puede ser negativo es $W$ — cuando la fuerza frena. Sumar
  energías cinéticas «con signo según el sentido» es un error que aparece
  apenas hay más de un cuerpo.
]

== Fuerzas conservativas y energía potencial

Para algunas fuerzas, el trabajo entre dos puntos *no depende del camino*.
Cuando eso pasa se puede definir una función $U$ de la posición sola, y escribir
el trabajo como una diferencia (S&Z §7.3, pág. 217):

$ W_"cons" = -Delta U = U_1 - U_2 $

Las tres condiciones siguientes son equivalentes, y conviene tener las tres a
mano porque cada problema hace obvia una distinta:

+ El trabajo entre dos puntos es el mismo por cualquier camino.
+ El trabajo a lo largo de cualquier circuito cerrado es cero.
+ Existe una función $U(bold(r))$ tal que $W = -Delta U$.

#deduccion("toda fuerza central que dependa sólo de r es conservativa")[
  Es el resultado que sostiene toda la Parte III, y sale del módulo 1 sin
  cuentas nuevas. Sea $bold(F) = F(r) hat(r)$. El desplazamiento, escrito en
  polares, es $d bold(l) = d r hat(r) + r d theta hat(theta)$. Entonces
  $ bold(F) dot d bold(l) = F(r) hat(r) dot (d r hat(r) + r d theta hat(theta)) = F(r) d r $
  porque $hat(r) dot hat(r) = 1$ y $hat(r) dot hat(theta) = 0$. Y por lo tanto
  $ W = integral_(r_1)^(r_2) F(r) d r $
  que depende *sólo de $r_1$ y $r_2$*: el camino se fue de la cuenta. La energía
  potencial es la primitiva cambiada de signo,
  $ U(r) = - integral F(r) d r $
]

#fig([Por qué una fuerza central es conservativa. El desplazamiento se parte en
un pedazo radial y uno transversal; el transversal es perpendicular a la fuerza
y no trabaja. Lo que queda depende sólo de $r$.], fig-trabajo-central)

#clave[
  Lo que hace conservativa a la fuerza es que sea *central* y que su módulo
  dependa *sólo de $r$*. No hace falta que sea $1 \/ r^2$: la gravedad y el
  resorte tridimensional entran por la misma puerta, y cualquier otra $F(r)$
  también.

  Esto contesta —por adelantado— media pregunta fina que la guía plantea en el
  Ej. 5 de la sección de impulso angular: *¿hace falta que el potencial sea
  $1 \/ r$, o alcanza con que la fuerza sea central?* Para la energía, alcanza
  con central y $F = F(r)$. Para el momento angular alcanza con *central* a
  secas, y eso se ve en el módulo 7. La forma $1 \/ r^2$ no hace falta para
  ninguna de las dos conservaciones: hace falta para que la órbita cierre en
  una elipse, que es otra cosa y es el módulo 9.
]

Cuando además de las conservativas hay otras fuerzas (rozamiento, empuje de un
motor), el teorema toma la forma que se usa en los problemas (S&Z ec. 7.14,
pág. 214):

$ K_1 + U_1 + W_"otras" = K_2 + U_2, quad "o bien" quad W_"otras" = Delta E $

con $E = K + U$ la *energía mecánica*. Si $W_"otras" = 0$, $E$ se conserva.

== De la energía potencial a la fuerza, y los diagramas

La relación se puede dar vuelta. En una dimensión (S&Z §7.4, ec. 7.16,
pág. 221) y en tres (ec. 7.18, pág. 223):

$ F_x = - (d U)/(d x), quad bold(F) = -nabla U $ <m5-gradiente>

*La fuerza es menos la pendiente del potencial.* Con eso, una curva $U(x)$
dibujada en un papel contiene toda la dinámica del problema, y se lee sin
resolver nada (S&Z §7.5, pág. 225):

#fig([Cómo se lee un diagrama de energía. La recta horizontal es $E$, que no
cambia; la distancia vertical hasta la curva es $K$; donde se cortan, $K = 0$ y
la partícula *se da vuelta*. La pendiente da la fuerza.], fig-diagrama-energia)

#table(
  columns: (auto, 1fr),
  align: (left, left),
  table.header([*En el gráfico*], [*Qué significa*]),
  [distancia vertical de $E$ a $U$], [la energía cinética, $K = E - U$],
  [$U$ baja al avanzar ($d U \/ d x < 0$)], [$F_x > 0$: la fuerza empuja hacia $+x$],
  [$U$ sube], [$F_x < 0$: la fuerza empuja hacia $-x$],
  [la recta $E$ corta a la curva], [*punto de retorno*: $K = 0$, la partícula se detiene y vuelve],
  [un *mínimo* de $U$], [equilibrio *estable*: $F = 0$ y cualquier corrimiento la trae de vuelta],
  [un *máximo* de $U$], [equilibrio *inestable*: $F = 0$ pero cualquier corrimiento la aleja],
  [un pozo entre dos cortes], [la partícula queda *atrapada*: oscila entre los dos retornos],
)

#geometria[
  *El equilibrio es donde la pendiente es cero, no donde $U$ vale cero.* El
  cero de $U$ es una elección de origen —se puede correr toda la curva hacia
  arriba o hacia abajo sin cambiar ninguna fuerza—, mientras que la pendiente
  no depende de esa elección. Por la misma razón, un $U$ negativo no significa
  nada raro: en la Parte III el potencial gravitatorio se elige negativo en
  todos lados justamente porque el cero se pone en el infinito.
]

#ejemplo("De dónde sale la energía del calamar")[
  _(Ej. 3 de la guía, parte (b); S&Z 8.19.)_ Un calamar de $6,50$ kg —incluyendo
  $1,75$ kg de agua en su cavidad— está en reposo y expulsa el agua para
  escapar a $2,50$ m/s. *(a)* ¿Con qué rapidez debe expulsarla? *(b)* ¿Cuánta
  energía cinética genera con esa maniobra?

  *(a)* Es el módulo 2: $bold(P) = bold(0)$ antes, y el cuerpo del calamar sin
  el agua pesa $6,50 - 1,75 = 4,75$ kg.
  $ 0 = 4,75 dot 2,50 - 1,75 dot v_"agua" ==> v_"agua" = (11,875) / (1,75) = 6,79 " m/s" $

  *(b)* La energía cinética generada es la de los *dos* pedazos, no la del
  calamar sola:
  $ K = 1/2 (4,75)(2,50)^2 + 1/2 (1,75)(6,786)^2 = 14,8 + 40,3 = 55,1 " J" $

  *Lo que este ejemplo enseña.* La cantidad de movimiento se conservó
  exactamente —vale cero antes y después— y la energía cinética pasó de $0$ a
  $55,1$ J. No hay contradicción: $bold(P)$ y $K$ son cantidades independientes,
  y una fuerza interna puede crear energía cinética (sacándola de otro lado, acá
  el músculo del calamar) sin tocar el $bold(P)$ total.

  Y notar de dónde viene el grueso: $40$ de los $55$ J se los lleva *el agua*,
  no el calamar. Es lo mismo que en el módulo 4 — el chorro se lleva casi toda
  la energía y el vehículo casi todo el provecho.

  #clave[
    En el lenguaje del módulo 3: como $bold(v)_"cm" = bold(0)$, esos $55,1$ J
    son *todos* $K^*$, la energía interna del sistema. Es la misma cantidad que
    en un choque se disipa; acá la maniobra la recorre al revés, creándola.
  ]
]

#ejemplo("Leer un diagrama de energía de punta a punta", nivel: "a fondo")[
  _(Problema 1 de la sección «Conservación de la Energía» de la guía; S&Z
  7.76.)_ Una partícula se mueve sobre el eje $x$ bajo una única fuerza
  conservativa paralela a $x$, cuya energía potencial es la de la figura P7.76
  de la guía. *La partícula se suelta del reposo en $A$.*

  *Los datos que hay que leer del gráfico primero*, con la única cifra que el
  gráfico da:

  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    table.header([*Punto*], [$x$ (m)], [$U$ (J)]),
    [$A$ (de donde se suelta)], [$approx 0,25$], [$approx +3,0$],
    [primer mínimo], [$approx 0,75$], [$approx -2,7$],
    [$B$], [$approx 1,0$], [$approx -1,2$],
    [$C$ (máximo local)], [$approx 1,4$], [$approx +2,5$],
    [segundo mínimo], [$approx 1,9$], [$approx -1,2$],
    [pared derecha, donde $U$ vuelve a $3,0$ J], [$approx 2,2$], [$+3,0$],
  )

  Como se suelta del reposo en $A$, $K_A = 0$ y la energía total queda fijada
  para todo el movimiento:
  $ E = K_A + U_A = 0 + 3,0 = 3,0 " J" $
  Esa recta horizontal es la que hay que dibujar mentalmente sobre la figura: de
  ella sale todo lo demás.

  *(a) Dirección de la fuerza en $A$.* En $A$ la curva *baja* al avanzar, o sea
  $d U \/ d x < 0$, y por la @m5-gradiente $F_x = -d U \/ d x > 0$: *hacia $+x$*.
  La partícula arranca yendo hacia la derecha.

  *(b) Y en $B$.* $B$ está a la derecha del primer mínimo, sobre el tramo que
  *sube*: $d U \/ d x > 0$, así que $F_x < 0$, *hacia $-x$*. La fuerza la está
  frenando y la va a devolver al pozo.

  *(c) Dónde es máxima $K$.* Como $K = E - U$ y $E$ no cambia, $K$ es máxima
  donde $U$ es *mínima*. El mínimo más profundo es el primero:
  $ x approx 0,75 " m", quad K_"máx" = 3,0 - (-2,7) = 5,7 " J" $
  El segundo pozo también es un mínimo, pero menos profundo ($-1,2$ J), así que
  ahí $K$ vale $4,2$ J. La pregunta es por el máximo absoluto.

  *(d) Fuerza en $C$.* $C$ es un máximo local: la tangente es horizontal,
  $d U \/ d x = 0$, y entonces $F_x = 0$. *La fuerza es nula.*

  *(e) Hasta dónde llega.* Se busca dónde la curva vuelve a valer $E = 3,0$ J
  yendo hacia la derecha. La partícula:
  - baja al primer pozo ganando rapidez,
  - sube hacia $C$ y *lo pasa*, porque $U_C approx 2,5 " J"$ es menor que los
    $3,0$ J disponibles y le quedan $0,5$ J de energía cinética en la cima,
  - vuelve a bajar al segundo pozo,
  - y trepa la pared de la derecha hasta que $U = 3,0$ J.

  $ x_"máx" approx 2,2 " m" $

  Ahí $K = 0$, se detiene y vuelve. El movimiento es una oscilación entre
  $x approx 0,25$ m y $x approx 2,2$ m, con dos pozos adentro.

  *(f) Equilibrio estable.* Los *mínimos*: $x approx 0,75$ m y
  $x approx 1,9$ m.

  *(g) Equilibrio inestable.* El *máximo*: $x approx 1,4$ m, el punto $C$.

  #geometria[
    La respuesta a *(e)* depende de una comparación y de una sola: $U_C$ contra
    $E$. Si la partícula se hubiera soltado desde un punto con
    $E < U_C approx 2,5$ J, no habría pasado la loma y habría quedado atrapada
    oscilando en el primer pozo — y $x_"máx"$ sería el corte contra la subida
    hacia $C$, alrededor de $1,2$ m. *Antes de contestar «hasta dónde llega»
    hay que comparar $E$ con cada máximo que haya en el camino.*
  ]

  #cuidado[
    Los valores de arriba se *leen de un gráfico*, así que tienen una cifra
    significativa y punto: no tiene sentido informar $K_"máx" = 5,73$ J. Lo que
    el problema evalúa no son los números sino las seis lecturas cualitativas —
    signo de la fuerza, dónde es máxima $K$, dónde hay equilibrio y de qué tipo,
    hasta dónde llega—, y esas no dependen de la precisión con que se lea la
    escala.
  ]

  #clave[
    Este ejercicio es el módulo 9 disfrazado. Ahí la curva no será dibujada sino
    calculada —el *potencial eficaz*
    $U_"ef" (r) = -mu m \/ r + L^2 \/ (2 m r^2)$—, la variable no será $x$ sino
    $r$, y las preguntas serán las mismas exactamente: dónde está el equilibrio
    (la órbita circular), entre qué dos radios queda atrapada la partícula
    (perigeo y apogeo), y con qué energía deja de estar atrapada (la escape).
    Vale la pena hacer este problema bien ahora, porque después se hace tres
    veces más.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  De la sección *Conservación de la Energía – Gravitación*, el *Problema 1* es
  el ejemplo a fondo de arriba, y es el único que se resuelve sin gravitación.
  Los problemas *0* y *2 al 10* necesitan la energía potencial gravitatoria
  $U = -G M m \/ r$, que se deduce en el módulo 6: se resuelven ahí y en el 10.
  De la sección de cantidad de movimiento, la parte (b) del *3*, que es el
  primer ejemplo.
]

== Lo que se usa después

1. *$W = integral bold(F) dot d bold(l)$ aplicado a una fuerza central.* En el
   módulo 6 se le pone $F = -G M m \/ r^2$ y sale, en dos renglones,
   $U(r) = -G M m \/ r$ — con el menos y el cero en el infinito ya explicados.

2. *$bold(F) = -nabla U$ y el diagrama de energía.* Es la máquina entera del
   módulo 9: el potencial eficaz, las órbitas ligadas y abiertas, la velocidad
   de escape y la órbita circular como fondo del pozo.

3. *«Una fuerza perpendicular a la velocidad no trabaja.»* Es la mitad del
   argumento de por qué un satélite en órbita circular no pierde ni gana
   rapidez, y reaparece en el módulo 7 como la razón de que una fuerza central
   no cambie el momento angular — el mismo producto escalar nulo, con el
   vectorial en su lugar.
