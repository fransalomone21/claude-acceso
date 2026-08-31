#import "../plantilla.typ": *

#modulo("Gravitación de Newton, peso y energía potencial")[
  Escribir la fuerza gravitatoria con su signo y su versor bien puestos;
  entender por qué una esfera atrae como si toda su masa estuviera en el
  centro; deducir la energía potencial $U = -mu m \/ r$ en vez de aceptarla; y
  contestar, con una cuenta de dos renglones, las dos preguntas que abren la
  mecánica orbital: *¿con qué velocidad hay que ir para orbitar sin caer?* y
  *¿con cuál para no volver nunca?*
]

Este módulo abre la Parte III y es el que le pone fuerza a la máquina del
módulo 5. Ahí quedó demostrado que toda fuerza central $F(r)$ es conservativa y
que su diagrama de energía contesta la mitad de las preguntas sin resolver
ninguna ecuación diferencial. Acá se le pone la fuerza concreta —la de
Newton— y esa mitad se cobra entera.

== La ley de Newton de la gravitación

La ley, en palabras del propio libro (S&Z §13.1, pág. 398): toda partícula
atrae a toda otra con una fuerza proporcional al producto de las masas e
inversamente proporcional al cuadrado de la distancia (S&Z ec. 13.1,
pág. 399):

$ F_g = (G m_1 m_2) / r^2 $ <m6-newton>

con $G = 6,674 times 10^(-11)$ N·m²/kg². Escrita así es un módulo, y para
trabajar hace falta la forma vectorial. Si $bold(r)$ va *del cuerpo que atrae
al cuerpo atraído* y $hat(r) = bold(r) \/ r$:

$ bold(F)_g = - (G M m) / r^2 hat(r) $ <m6-newton-vec>

#geometria[
  *El menos no es decorativo y el versor no es cualquiera.* Los dos dicen la
  misma cosa una sola vez: $hat(r)$ apunta hacia *afuera* del cuerpo que atrae,
  y la fuerza va hacia adentro, así que la componente radial es negativa. Los
  dos errores clásicos son escribir la @m6-newton-vec sin el menos —y quedarse
  con una gravedad que repele— o poner $hat(r)$ apuntando del satélite a la
  Tierra y *además* dejar el menos, que es lo mismo con dos signos cambiados.

  La regla práctica: se elige el origen en el cuerpo central, $bold(r)$ es la
  posición del satélite *medida desde ahí*, y la @m6-newton-vec sale sola. En
  el módulo 8 se verá qué hacer cuando el cuerpo central no se puede considerar
  fijo.
]

La @m6-newton habla de *partículas*, y sin embargo se le aplica a la Tierra
entera. Eso no es una aproximación: es un teorema.

#clave[
  *Una distribución de masa con simetría esférica atrae, desde afuera,
  exactamente como si toda su masa estuviera concentrada en su centro*
  (S&Z §13.6, pág. 413–415, donde está la demostración por integración de
  cáscaras). Por eso en toda la Parte III el «radio de la órbita» se mide desde
  el *centro* de la Tierra y no desde su superficie, y por eso una montaña y un
  satélite obedecen la misma fórmula.

  Es un resultado fuerte y propio del exponente $2$: con cualquier otra
  potencia el teorema es falso. Se cita, no se deduce: la integral cambia el
  álgebra pero no cambia el entendimiento.
]

#notacion[
  En mecánica orbital casi nunca aparece $G M$ escrito así. Se lo llama
  *parámetro gravitacional estándar* y se lo escribe con una sola letra
  (Curtis §2.2; Bate §1.5):
  $ mu = G M $
  No es una abreviatura por comodidad: $G$ se conoce con cuatro cifras y la
  masa de la Tierra con cuatro, pero *$mu$ se mide directamente de las órbitas
  de los satélites y se conoce con nueve*. Para la Tierra,
  $ mu_T = 3,986 times 10^14 " m"^3\/"s"^2 = 398 thin 600 " km"^3\/"s"^2 $
  De acá en adelante el apunte usa $mu$. Cuidado con no confundirla con la
  masa reducida del módulo 8, que la mitad de los libros llama igual — ese
  choque de nombres se aclara allá.
]

== Peso, y cómo se pesa un planeta

El peso de un cuerpo en la superficie terrestre es la @m6-newton con
$r = R_T$ (S&Z ec. 13.3, pág. 403):

$ w = (G m_T m) / R_T^2 $

y como por definición $w = m g$, dividiendo por $m$ (S&Z ec. 13.4, pág. 403):

$ g = (G m_T) / R_T^2 = mu_T / R_T^2 $ <m6-g>

#deduccion("por qué g no depende de la masa del cuerpo, y de paso cómo se pesa la Tierra")[
  La masa $m$ aparece a los dos lados y se va. Eso ya se sabía desde Galileo,
  pero recién ahora se sabe *por qué*: la misma $m$ que multiplica la fuerza
  (masa gravitatoria) es la que resiste la aceleración (masa inercial).

  Y la @m6-g tiene una lectura mucho más útil, porque de sus cuatro cantidades
  se pueden medir tres sin salir de la Tierra: $g$ con un péndulo, $R_T$ con
  geometría, y $G$ con una balanza de torsión. Despejando la que falta:
  $ m_T = (g R_T^2) / G = ((9,80)(6,37 times 10^6)^2) / (6,674 times 10^(-11)) = 5,96 times 10^24 " kg" $
  Ése fue el resultado de Cavendish, y es la primera vez que se pesa un objeto
  sin ponerlo arriba de nada. El valor aceptado hoy es
  $5,972 times 10^24$ kg (S&Z pág. 403).
]

Por encima de la superficie, a una distancia $r$ del centro, el peso cae con el
cuadrado (S&Z ec. 13.5, pág. 403): $w = G m_T m \/ r^2$.

#cuidado[
  *La distancia que entra en la fórmula es al centro de la Tierra, no a su
  superficie.* Es el error que más veces cambia un resultado por un factor
  grande, porque las alturas típicas de un satélite son chicas comparadas con
  $R_T$: a 300 km de altura, $r = 6370 + 300 = 6670$ km, apenas un 5% más que
  $R_T$ — y quien use $r = 300$ km se equivoca por un factor de 500 en la
  fuerza. Todos los enunciados de la guía dan *altura*; todas las fórmulas
  piden *radio*. La primera línea de la resolución es siempre la misma:
  $r = R_T + h$.
]

== La energía potencial gravitatoria

Ahora sí, la deducción que el módulo 5 dejó prometida.

#deduccion("la energía potencial gravitatoria, y por qué el cero va en el infinito")[
  En el módulo 5 quedó demostrado que una fuerza central con módulo $F(r)$ es
  conservativa y que su energía potencial es $U(r) = -integral F(r) d r$. Sólo
  falta poner la fuerza y elegir el origen.

  La componente radial de la fuerza gravitatoria es negativa —apunta hacia
  adentro— así que (S&Z ec. 13.7, pág. 405) $F_r = -mu m \/ r^2$, y el trabajo
  al ir de $r_1$ a $r_2$ es (S&Z ecs. 13.6 y 13.8, pág. 405):
  $ W_"grav" = integral_(r_1)^(r_2) F_r d r = -mu m integral_(r_1)^(r_2) (d r)/r^2 = (mu m)/r_2 - (mu m)/r_1 $
  Comparando con $W = U_1 - U_2$ se lee la primitiva directamente:
  $ U(r) = - (mu m) / r + "constante" $
  y la constante se elige *cero*, que es lo mismo que decidir $U(oo) = 0$
  (S&Z ec. 13.9, pág. 405).
]

$ U(r) = - (mu m) / r, quad U(oo) = 0 $ <m6-U>

#cuidado[
  *$U$ es negativa en todos lados, y eso no significa nada raro.* El cero de
  una energía potencial siempre es una elección —en el módulo 5 quedó dicho que
  correr toda la curva hacia arriba o hacia abajo no cambia ninguna fuerza— y
  acá se eligió ponerlo *infinitamente lejos*. Con esa elección, todo punto a
  distancia finita está «más abajo» que el cero, y por eso $U < 0$.

  Por qué se elige así y no en la superficie, que sería más intuitivo: porque
  es la única elección que sirve para *todos* los cuerpos centrales a la vez.
  Con el cero en el infinito, la @m6-U vale igual para la Tierra, para Júpiter
  y para el Sol sin cambiar una constante por cada uno, y —lo que de verdad
  importa— el signo de $E$ pasa a significar algo físico, que es de lo que trata
  la sección siguiente.
]

#clave[
  *La @m6-U contiene a $U = m g y$ como caso particular.* Cerca de la
  superficie, con $r_1 = R_T$ y $r_2 = R_T + y$ y $y << R_T$:
  $ Delta U = mu m (1/R_T - 1/(R_T + y)) = (mu m y) / (R_T (R_T + y)) approx (mu m) / R_T^2 y = m g y $
  usando la @m6-g en el último paso (S&Z pág. 406). No son dos fórmulas: es la
  misma, mirada de cerca. Lo que se pierde al usar $m g y$ es exactamente lo
  que cambia cuando $y$ deja de ser chico frente a $R_T$ — es decir, todo lo
  que le pasa a un cohete después del primer minuto.
]

== El pozo de potencial, y la velocidad de escape

La @m6-U dibujada es el diagrama de energía del módulo 5 con una curva
concreta, y se lee con las mismas reglas.

#fig([El pozo gravitatorio. La curva es $U(r) = -mu m \/ r$; las rectas
horizontales son tres energías totales posibles. Si $E < 0$, la recta corta a
la curva y hay un $r_"máx"$: el cuerpo *está ligado*. Si $E gt.eq 0$ no hay
corte, y el cuerpo llega al infinito con $K gt.eq 0$: *escapa*. La distancia
vertical entre la recta y la curva es $K = E - U$.], fig-pozo-gravitatorio)

#clave[
  *El signo de la energía mecánica total decide si el cuerpo vuelve o no*, y no
  hace falta resolver ninguna ecuación de movimiento para saberlo:

  #table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Signo de $E$*], [*Qué pasa*]),
    [$E < 0$], [órbita *ligada*: hay un $r_"máx"$ donde $K = 0$ y el cuerpo vuelve. Circunferencia o elipse],
    [$E = 0$], [el caso justo: llega al infinito con velocidad nula. Parábola],
    [$E > 0$], [órbita *abierta*: llega al infinito y le sobra velocidad. Hipérbola],
  )

  Los nombres de las curvas todavía no están justificados —eso es el módulo 9—,
  pero la clasificación por el signo de $E$ ya está *demostrada* acá, y con eso
  alcanza para la mitad de los problemas de la guía.
]

De la fila del medio sale la velocidad de escape. Pedir $E = 0$ partiendo de la
superficie con rapidez $v_"esc"$ es pedir (S&Z ejemplo 13.5, pág. 406):

$ 1/2 m v_"esc"^2 - (mu m) / R = 0 ==> v_"esc" = sqrt((2 mu) / R) $ <m6-vesc>

#geometria[
  *La velocidad de escape no depende de la dirección en que se dispara ni de la
  masa del proyectil.* Las dos cosas salen de la cuenta de arriba: la $m$ se
  simplifica, y $v$ entra sólo por $v^2$, que es un escalar. Disparar hacia
  arriba, de costado o en diagonal da lo mismo *mientras no se choque contra
  algo* — la trayectoria cambia por completo, pero el «llega o no llega» no.

  Para la Tierra, $v_"esc"^2 = 2 mu \/ R = 2 (3,986 times 10^14) \/ (6,37 times 10^6) = 1,252 times 10^8$, o sea $v_"esc" = 11,2$ km/s.
]

== La órbita circular: por qué no cae

Ésta es la pregunta que abre la materia, y merece la deducción entera.

#deduccion("la velocidad de una órbita circular")[
  Un cuerpo en circunferencia de radio $r$ a rapidez constante tiene
  aceleración centrípeta $a = v^2 \/ r$, apuntando al centro. La única fuerza es
  la gravedad, que apunta al mismo lado y vale $mu m \/ r^2$. La segunda ley,
  proyectada sobre el radio, es un renglón (S&Z pág. 407):
  $ (mu m) / r^2 = (m v^2) / r $
  La masa se va de los dos lados y queda
]

$ v_"circ" = sqrt(mu / r) $ <m6-vcirc>

#clave[
  *Por qué «orbita sin caer», dicho de una vez.* El satélite *sí* cae: en cada
  instante su aceleración apunta al centro de la Tierra y vale exactamente
  $g(r)$. Lo que pasa es que mientras cae, *avanza*, y la Tierra se curva
  debajo de él a la misma tasa a la que él baja. La @m6-vcirc es precisamente
  la condición de que las dos curvaturas coincidan.

  Y hay una segunda mitad, que viene del módulo 5: como la gravedad es
  perpendicular a la velocidad en todo momento, *no le hace trabajo*, así que
  la rapidez no cambia nunca y la condición, una vez cumplida, se cumple para
  siempre. Sin esa segunda mitad la primera no alcanzaría: una órbita que se
  frenara sola dejaría de cumplir la @m6-vcirc en el instante siguiente.
]

#fig([El cañón de Newton. Todas las trayectorias son la *misma caída*; lo único
que cambia es la velocidad horizontal del disparo. Con poca, la trayectoria se
interrumpe contra la superficie —eso es «caer»—; con $v_"circ"$ el proyectil
nunca alcanza el suelo; con más, la órbita se abre en una elipse; con
$v_"esc"$, ya no vuelve.], fig-canon-newton)

De la @m6-vcirc salen las otras dos cantidades de una órbita circular. El
período es la vuelta dividida por la rapidez, $T = 2 pi r \/ v$ (S&Z ec. 13.11,
pág. 408), y sustituyendo (S&Z ec. 13.12, pág. 409):

$ T = (2 pi r^(3\/2)) / sqrt(mu) $ <m6-T>

y la energía mecánica total, usando la @m6-U y la @m6-vcirc (S&Z ec. 13.13,
pág. 409):

$ E = K + U = 1/2 m (mu / r) - (mu m) / r = - (mu m) / (2 r) $ <m6-E>

#clave[
  Tres lecturas de la @m6-E que se usan en todos los problemas de maniobras:

  + $E < 0$ siempre, como corresponde a una órbita ligada. Consistente con el
    cuadro de arriba.
  + $E$ es *la mitad de $U$*, y por lo tanto $K = -E = -U\/2$: la energía
    cinética de una órbita circular vale exactamente la mitad de la potencial,
    cambiada de signo.
  + *Órbita más grande, energía mayor* (menos negativa). Subir de órbita cuesta
    energía aunque la velocidad final sea *menor* — la @m6-vcirc dice que en
    una órbita más alta se va más despacio. Esa aparente contradicción es el
    ejemplo a fondo de este módulo, y es la razón de que un satélite que roza
    la atmósfera se acelere mientras se cae.
]

Y una relación que conviene tener de memoria, comparando la @m6-vesc con la
@m6-vcirc evaluadas en el mismo radio (S&Z pág. 409):

$ v_"esc" = sqrt(2) thin v_"circ" $ <m6-raiz2>

*Desde cualquier órbita circular, alrededor de cualquier planeta, hay que
multiplicar la rapidez por $sqrt(2)$ para escapar.* Un 41% más de velocidad, y
no depende de nada.

#ejemplo("Estimar la masa del Sol")[
  _(Problema 0 de la sección «Conservación de la Energía – Gravitación».)_
  Estime la masa del Sol.

  El enunciado no da ningún dato: los datos son los que uno se sabe. La Tierra
  da una vuelta al Sol en un año y está a una unidad astronómica:
  $ r = 1,496 times 10^11 " m", quad T = 1 "año" = 3,156 times 10^7 " s" $

  Tomando la órbita como circular —lo es con un error del 2%— la rapidez sale
  de la definición de período:
  $ v = (2 pi r) / T = (2 pi (1,496 times 10^11)) / (3,156 times 10^7) = 2,978 times 10^4 " m/s" approx 29,8 " km/s" $

  Y ahora se da vuelta la @m6-vcirc, que es lo único que hace falta: si
  $v^2 = mu \/ r$, entonces $mu = v^2 r$, y $M = mu \/ G$:
  $ M_"Sol" = (v^2 r) / G = ((2,978 times 10^4)^2 (1,496 times 10^11)) / (6,674 times 10^(-11)) = 1,99 times 10^30 " kg" $

  *Lo que este ejemplo enseña.* La misma cuenta con la que Cavendish pesó la
  Tierra pesa cualquier cuerpo central: alcanza con mirar *algo que le orbite*
  y medirle el radio y el período. Y notar qué *no* hizo falta: la masa de la
  Tierra no aparece por ningún lado, porque se simplificó en la @m6-vcirc. Se
  pesa el cuerpo central, nunca el que orbita.

  #cuidado[
    Que la masa del satélite no aparezca es también la razón por la que este
    método *no puede* pesar a la Tierra usando la Luna y después al Sol usando
    la Tierra y sumar. Cada medición pesa un solo cuerpo: el del centro. Para
    los casos en que las dos masas son comparables y ninguna está «en el
    centro», hace falta el módulo 8.
  ]
]

#ejemplo("Cuánto cuesta subir un satélite a la órbita geosíncrona", nivel: "a fondo")[
  _(Problema 6 de la guía; Beer 13.85.)_ Mientras describe una órbita circular
  a $300$ km sobre la Tierra, un vehículo espacial lanza un satélite de
  comunicaciones de $3600$ kg. Determine *(a)* la energía adicional que se
  requiere para ponerlo en una órbita geosíncrona a $35 thin 770$ km de altura,
  y *(b)* la energía requerida para ponerlo en esa misma órbita lanzándolo
  desde la superficie de la Tierra, sin incluir la resistencia del aire.

  *Los radios, primero* — y desde el centro de la Tierra, no desde la
  superficie:
  $ R_T = 6370 " km", quad r_1 = 6370 + 300 = 6670 " km" = 6,670 times 10^6 " m" $
  $ r_2 = 6370 + 35 thin 770 = 42 thin 140 " km" = 4,214 times 10^7 " m" $

  #clave[
    *De dónde sale el $35 thin 770$, que el enunciado regala.* Es el radio que
    hace $T = 1$ día sideral $= 23,934$ h $= 86 thin 162$ s. Despejando $r$ de
    la @m6-T:
    $ r = ((mu T^2) / (4 pi^2))^(1\/3) = (((3,986 times 10^14)(86 thin 162)^2) / (39,48))^(1\/3) = 4,215 times 10^7 " m" $
    o sea $42 thin 150$ km, que descontando $R_T$ da $35 thin 780$ km. *Con eso
    queda resuelto de paso el Problema 3 de la guía*, que pide exactamente esta
    altura y la velocidad correspondiente:
    $v^2 = mu \/ r = 9,456 times 10^6 ==> v = 3,08$ km/s.
  ]

  *(a) De una órbita circular a la otra.* Las dos son circulares, así que las
  dos energías salen de la @m6-E y la respuesta es la resta. Con
  $mu m = (3,986 times 10^14)(3600) = 1,435 times 10^18$:
  $ E_1 = - (mu m) / (2 r_1) = - (1,435 times 10^18) / (1,334 times 10^7) = -107,6 " GJ" $
  $ E_2 = - (mu m) / (2 r_2) = - (1,435 times 10^18) / (8,428 times 10^7) = -17,0 " GJ" $
  $ Delta E = E_2 - E_1 = -17,0 - (-107,6) = 90,6 " GJ" $

  *(b) Desde la superficie, en reposo.* Ahora el estado inicial no es una
  órbita: es un satélite quieto sobre el suelo, con $K = 0$ y sólo potencial:
  $ E_0 = -(mu m) / R_T = - (1,435 times 10^18) / (6,370 times 10^6) = -225,3 " GJ" $
  $ Delta E = E_2 - E_0 = -17,0 - (-225,3) = 208,3 " GJ" $

  Es *2,3 veces* lo del inciso (a): estar ya en una órbita baja es haber pagado
  más de la mitad del viaje, aunque en altura sea menos del 1%.

  #geometria[
    *El estado inicial de (b) no es «altura cero»: es $r = R_T$ y $K = 0$.* Dos
    errores gemelos aparecen acá. El primero es usar la @m6-E para el estado
    inicial —esa fórmula vale sólo para órbitas *circulares*, y un satélite en
    el suelo no está en órbita: su $K$ es cero, no $-E$. El segundo es poner
    $U = 0$ en la superficie «porque es donde empieza todo», que contradice la
    elección del cero en el infinito hecha para $E_2$. *Las dos energías de una
    resta tienen que estar medidas con el mismo cero*, y por eso conviene
    escribir siempre $E = K + U$ completo antes de simplificar nada.
  ]

  #cuidado[
    El enunciado dice «sin incluir la resistencia del aire», y hay que leer qué
    más queda afuera. Estos $208$ GJ son la energía *mecánica* que hay que
    agregarle al satélite, no el combustible del cohete: el módulo 4 mostró que
    el chorro se lleva casi toda la energía y el vehículo casi todo el
    provecho. Tampoco descuenta los $approx 465$ m/s que regala la rotación
    terrestre en el ecuador, que es exactamente por lo que los puertos
    espaciales están cerca de él.
  ]
]

#guia("qué ejercicios cubre este módulo")[
  De la sección *Conservación de la Energía – Gravitación*: el *Problema 0* es
  el ejemplo simple; el *Problema 6* es el ejemplo a fondo, y adentro queda
  resuelto el *Problema 3* (la altura y la velocidad geosíncronas), que pide lo
  mismo con otras palabras.

  El *Problema 2* (la sonda de Beer, de $A$ a $B$) se resuelve con la @m6-U y
  la conservación de la energía, pero necesita además el momento angular para
  saber la *dirección* de la velocidad en $B$: es el módulo 7. Los problemas
  *4*, *7*, *8* y *9* son órbitas elípticas, y esperan al módulo 10. El *5* es
  Hohmann y el *10* es *rendez-vous*: módulo 11.
]

== Lo que se usa después

1. *$U = -mu m \/ r$ y el signo de $E$.* En el módulo 9 esta curva se le suma
   al término centrífugo y se convierte en el *potencial eficaz*, que es la que
   de verdad decide la forma de la órbita. La lectura no cambia: sigue siendo
   dónde corta la recta.

2. *$v_"circ" = sqrt(mu \/ r)$ y $E = -mu m \/ 2r$.* Son las dos fórmulas con
   las que se calcula toda maniobra del módulo 11. Una transferencia de Hohmann
   es, entera, dos diferencias de velocidad entre una órbita circular y una
   elipse.

3. *$mu$ en vez de $G M$.* De acá en adelante todas las fórmulas del apunte la
   usan, y todos los datos tabulados de los planetas vienen en esa forma.
