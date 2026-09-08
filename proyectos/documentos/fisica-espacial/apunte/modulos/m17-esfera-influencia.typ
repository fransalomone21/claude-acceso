#import "../plantilla.typ": *

#modulo("La esfera de influencia y las órbitas parcheadas")[
  Dar la licencia que el módulo 16 prometió y no dio: por qué está permitido
  resolver un viaje interplanetario como tres problemas de dos cuerpos
  pegados uno atrás del otro, en vez de como el problema de tres cuerpos que
  en realidad es. Sacar la frontera donde se hace el pegado —la esfera de
  influencia— de una comparación que no es la que uno inventaría solo, y
  medirla: para la Tierra son $925 thin 000$ km, que desde la Tierra es
  enorme y desde el Sol es un punto. Y cerrar el ejemplo de Marte diciendo
  además *dónde* hay que encender el motor y cuánto combustible se lleva.
]

Todo lo que se hizo desde el módulo 6 hasta acá supone *dos* cuerpos: uno
central que atrae y uno chico que se mueve. El módulo 8 fue explícito al
respecto —el problema de dos cuerpos se convierte en el de uno solo alrededor
de un centro fijo— y de ahí salieron las cónicas, Kepler, Hohmann y la
hipérbola de escape.

Pero una nave que va de la Tierra a Marte nunca está en un problema de dos
cuerpos. Cuando sale, la Tierra y el Sol la tiran a la vez; en el medio la
tira el Sol y, de lejos, todos los planetas; cuando llega, la tiran Marte y
el Sol. Son tres cuerpos, y el problema de tres cuerpos no tiene solución
cerrada: no hay una fórmula que dé la posición en función del tiempo.

Y sin embargo el módulo 11 calculó la transferencia a Marte con una elipse, y
el módulo 16 calculó el encendido de salida con una hipérbola, y los dos
números son los que usa la industria. *Ese* es el tema de este módulo: no
cómo se hacen esas cuentas —ya están hechas— sino por qué están permitidas.

== La idea completa, antes de la primera ecuación

Todavía no hay ninguna cuenta hecha. Lo que sigue es el plan, en tres pasos,
para tenerlo en la cabeza antes de la primera ecuación.

+ *Hay que decidir de quién es la nave en cada tramo.* La idea es partir el
  viaje en pedazos y, en cada pedazo, quedarse con *un solo* cuerpo central y
  tratar al otro como si no existiera. Para eso hace falta un criterio que
  diga, en cada punto del espacio, cuál de los dos cuerpos manda.
+ *El criterio obvio —quién tira más fuerte— es el equivocado*, y se ve
  enseguida que lo es porque da un resultado absurdo. El que sirve compara
  otra cosa: no quién tira más, sino quién *estorba menos* el problema del
  otro. Esa comparación da una distancia, y esa distancia es la frontera.
+ *Con la frontera dibujada, el viaje son tres problemas de dos cuerpos.*
  Adentro de la frontera de la Tierra, dos cuerpos con la Tierra: la
  hipérbola del módulo 16. Afuera de toda frontera, dos cuerpos con el Sol:
  la elipse del módulo 11. Adentro de la frontera de Marte, dos cuerpos con
  Marte: otra hipérbola. Los tres tramos son cónicas, y se pegan en las
  fronteras. De ahí el nombre: *cónicas parcheadas*.

#posta[
  La posta de este módulo es que el viaje interplanetario *no se resuelve*:
  se hace de vista. Nadie integra las ecuaciones de tres cuerpos para
  planificar una misión — lo que se hace es partir el viaje en tres pedazos,
  y en cada pedazo mentir a propósito diciendo que hay un solo cuerpo
  tirando.

  Y la mentira funciona por una razón muy concreta: la frontera de la Tierra
  está a $925 thin 000$ km, que es *el 0,6%* de lo que la nave va a recorrer
  hasta Marte. O sea que la parte del viaje donde la mentira podría hacer
  daño es una pizca del total, y en esa pizca la Tierra tira tanto más fuerte
  que el Sol que el error no llega a acumularse.

  Lo único que hay que entender bien es *dónde* poner la frontera, y ahí está
  la sorpresa: no va donde los dos tiran igual. Va mucho más lejos.
]

#clave[
  *El plan del módulo, en cuatro pasos:*
  + Descartar la frontera ingenua —donde el Sol y el planeta tiran igual— con
    un solo número que muestra que no puede ser esa.
  + Sacar la que sirve, comparando *perturbaciones* en vez de fuerzas: la
    esfera de influencia, $r_"SOI" = R (m_p \/ m_s)^(2\/5)$.
  + Medirla, y hacer las dos comparaciones que le dan sentido: contra el
    planeta y contra la órbita.
  + Pegar las tres cónicas, y —esto es lo que casi nunca se hace— *medir
    cuánto cuesta la mentira* antes de darla por buena.
]

== Por qué «quién tira más fuerte» es la pregunta equivocada

La frontera que uno inventaría solo es la superficie donde el Sol y el
planeta tiran de la nave con la misma fuerza. Sale de igualar las dos leyes
de Newton del módulo 6. Con la nave a distancia $r$ del planeta y el planeta
a distancia $R$ del Sol, y suponiendo $r << R$ para que la distancia al Sol
sea $R$ y no $R - r$,

$ (G m_p m_v)/r^2 = (G m_s m_v)/R^2 quad ==> quad r/R = sqrt(m_p/m_s) $ <m17-ingenua>

Para la Tierra, con $m_p \/ m_s = mu_T \/ mu_"Sol" = 398 thin 600 \/ (1,327
times 10^11) = 3,004 times 10^(-6)$,

$ (r/R)^2 = 3,004 times 10^(-6) quad ==> quad r/R = 1,733 times 10^(-3) $

$ r = 1,733 times 10^(-3) dot 149,6 times 10^6 = 259 thin 000 " km" $

#cuidado[
  *Ese número deja a la Luna afuera de la Tierra.* La Luna orbita a
  $384 thin 400$ km, o sea *más lejos* que los $259 thin 000$ km que la
  @m17-ingenua devuelve. Si la frontera fuera esa, la Luna pertenecería al
  Sol y no a la Tierra, y habría que calcular su órbita como una órbita
  heliocéntrica perturbada por la Tierra.

  Lo curioso es que, en el sentido literal de la @m17-ingenua, eso es
  *cierto*: el Sol le tira a la Luna más fuerte que la Tierra, por un factor
  de más de dos, y por eso la órbita de la Luna alrededor del Sol es siempre
  cóncava hacia el Sol — nunca hace rulos. Y sin embargo la Luna le da
  vueltas a la Tierra hace cuatro mil millones de años y no se va.

  La conclusión no es que la cuenta esté mal hecha: es que *mide lo que no
  importa*. Que el Sol tire más fuerte no dice nada, porque el Sol tira de la
  Luna *y de la Tierra casi igual*, y lo que decide la órbita relativa de
  una respecto de la otra es la *diferencia*, no la fuerza.
]

Ahí está el error, y vale la pena decirlo de frente porque es la idea entera
del módulo. El problema de la Luna alrededor de la Tierra ya está planteado
*en el sistema de la Tierra*, que es un sistema acelerado — el módulo 8 hizo
exactamente eso para dos cuerpos. En un sistema acelerado, un tirón que actúa
por igual sobre el centro y sobre el cuerpo que orbita no se nota: se cancela
al restar. Lo único que sobrevive es lo que el tirón tiene de *distinto* entre
los dos puntos.

#posta[
  Traducido: si vas en un ascensor que cae y adentro tenés una pelota
  flotando, la gravedad de la Tierra les está pegando a los dos —a vos y a la
  pelota— con toda su fuerza, y la pelota igual queda quieta frente a tuyo.
  Que la fuerza sea grande no importa: importa que sea *la misma*.

  Con el Sol y el par Tierra–Luna pasa lo mismo. El Sol es una bestia, pero
  le pega casi igual a la Tierra y a la Luna, así que casi todo su tirón se
  va en arrastrar al par entero alrededor del Sol y no en separarlos. Lo que
  puede separarlos es sólo la pizca de diferencia, y esa pizca es chiquita
  justamente porque la Luna está *cerca* de la Tierra comparada con lo lejos
  que está el Sol.
]

== La cuenta que sí sirve: quién perturba menos

Hay dos maneras de plantear el movimiento de la nave, y el criterio sale de
compararlas. En las dos, el término que domina se llama *aceleración
principal* y el que sobra, *perturbación*.

#definicion("perturbación")[
  En un problema planteado alrededor de un cuerpo central, la *perturbación*
  es la parte de la aceleración que no proviene de ese cuerpo central. Si la
  perturbación fuera cero, la trayectoria sería exactamente la cónica del
  módulo 9; cuanto mayor sea el cociente entre perturbación y aceleración
  principal, más se aparta la trayectoria real de esa cónica.

  El cociente es lo que se compara — no la perturbación sola. Una
  perturbación grande al lado de una aceleración principal más grande todavía
  deforma poco.
]

Con el Sol de masa $m_s$, el planeta de masa $m_p$ y la nave de masa $m_v$,
sean $bold(R)$ la posición del planeta desde el Sol, $bold(R)_v$ la de la
nave desde el Sol, y $bold(r)$ la de la nave *desde el planeta*, de modo que

$ bold(R)_v = bold(R) + bold(r) $ <m17-suma>

y en todo lo que sigue vale $r << R$: la nave está mucho más cerca del
planeta que el planeta del Sol, así que $R_v approx R$.

#notacion[
  *Mayúsculas para lo heliocéntrico, minúsculas para lo planetocéntrico.* Es
  la convención de Curtis en todo el capítulo 8 y conviene adoptarla acá,
  porque este módulo es el único del apunte donde conviven los dos orígenes
  en la misma ecuación: $bold(R)$, $bold(V)$, $mu_"Sol"$ están medidos desde
  el Sol; $bold(r)$, $bold(v)$, $mu_T$, desde el planeta. El $v_oo$ del
  módulo 16 es *minúscula*: es una velocidad relativa al planeta.
]

#deduccion("la esfera de influencia, de comparar dos perturbaciones")[
  *Punto de vista 1: la nave alrededor del Sol.* La segunda ley con las dos
  atracciones da

  $ dot.double(bold(R))_v = underbrace(-(G m_s)/R_v^3 bold(R)_v, bold(A)_s)
    underbrace(- (G m_p)/r^3 bold(r), bold(P)_p) $ <m17-vista1>

  con $bold(A)_s$ la aceleración principal (el Sol) y $bold(P)_p$ la
  perturbación (el planeta). Usando $R_v approx R$, sus módulos son
  $A_s = G m_s \/ R^2$ y $P_p = G m_p \/ r^2$, y el cociente

  $ P_p/A_s = (m_p/m_s) (R/r)^2 $ <m17-razon1>

  *Punto de vista 2: la nave alrededor del planeta.* Acá hay un paso más, y
  es el paso importante. La posición de la nave *desde el planeta* es
  $bold(r) = bold(R)_v - bold(R)$, así que su aceleración se obtiene
  restando la del planeta. La del planeta, despreciando el tirón de la nave
  sobre él ($m_v << m_p$), es $dot.double(bold(R)) = -(G m_s \/ R^3)bold(R)$.
  Restando:

  $ dot.double(bold(r)) = dot.double(bold(R))_v - dot.double(bold(R))
    = underbrace(-(G m_p)/r^3 bold(r), bold(a)_p)
      underbrace(- G m_s [(bold(R)_v)/R_v^3 - (bold(R))/R^3], bold(p)_s) $ <m17-vista2>

  El corchete es la clave de todo el módulo: *es una diferencia*. El Sol no
  aparece con toda su fuerza sino sólo con lo que su tirón cambia entre la
  posición de la nave y la del planeta. Con $R_v approx R$ y la @m17-suma,

  $ (bold(R)_v)/R_v^3 - (bold(R))/R^3 approx (bold(R) + bold(r))/R^3
    - (bold(R))/R^3 = (bold(r))/R^3 $

  y entonces $p_s = (G m_s \/ R^3) r$, que comparado con
  $a_p = G m_p \/ r^2$ da

  $ p_s/a_p = (m_s/m_p) (r/R)^3 $ <m17-razon2>

  *La frontera.* Adentro de la esfera conviene el punto de vista 2 —el
  problema planetocéntrico está menos perturbado que el heliocéntrico—, y
  afuera conviene el 1. La frontera es donde los dos cocientes se igualan:

  $ (m_s/m_p) (r/R)^3 = (m_p/m_s) (R/r)^2
    quad ==> quad (r/R)^5 = (m_p/m_s)^2 $

  $ r_"SOI" = R (m_p/m_s)^(2\/5) $ <m17-soi>
]

#clave[
  *Todo el módulo está en la diferencia de exponentes: 2 de un lado, 3 del
  otro.* Y no es un accidente algebraico.

  El planeta perturba el problema heliocéntrico con su fuerza *entera*: la
  nave siente al planeta y el Sol no, así que el término perturbador va como
  $1 \/ r^2$ — de ahí el 2 de la @m17-razon1.

  El Sol perturba el problema planetocéntrico sólo con la *diferencia* de su
  tirón entre la nave y el planeta, porque el planeta es el origen del
  sistema y lo que le pasa al origen se resta. Esa diferencia va como
  $r \/ R^3$ — de ahí el 3 de la @m17-razon2. Es el mismo mecanismo por el
  que las mareas van con el cubo de la distancia y no con el cuadrado.

  El $5$ del exponente de la @m17-soi es literalmente $2 + 3$, y el $2 \/ 5$
  es su inverso multiplicado por el 2 que quedó de un lado. Sabiendo eso, la
  fórmula no hay que memorizarla: se rearma en dos renglones.
]

#cuidado[
  *La esfera de influencia no es una superficie física, y ni siquiera es
  exactamente una esfera.* Es un criterio de conveniencia de cálculo: no pasa
  absolutamente nada cuando la nave la cruza, no hay ningún cambio en las
  fuerzas, y el radio que la @m17-soi devuelve depende de haber elegido
  «que los dos cocientes de perturbación se igualen» como definición. Otra
  definición razonable daría otro número, del mismo orden.

  Además la condición exacta —sin la aproximación $R_v approx R$— no da una
  esfera sino una superficie ligeramente achatada en la dirección del Sol.
  La diferencia es de pocos por ciento y no se usa: para lo que sirve la
  frontera, la esfera alcanza.
]

== Cuánto mide, y las dos comparaciones que hay que hacer

Con la @m17-soi y los datos del apéndice de Curtis, la frontera de la Tierra
queda en

$ r_"SOI" = 149,6 times 10^6 dot (3,004 times 10^(-6))^(2\/5)
  = 925 thin 000 " km" $ <m17-soi-tierra>

que son casi *cuatro veces* los $259 thin 000$ km de la frontera ingenua. Y
esos $925 thin 000$ km ya dejan a la Luna cómodamente adentro, que era lo
mínimo que había que pedirle al criterio para tomárselo en serio.

#fig([La misma esfera de influencia de la Tierra, mirada desde los dos lados,
y las dos veces a escala real — nada está agrandado. Desde la Tierra (panel
izquierdo) la esfera es enorme: la Tierra misma es el punto del centro y la
órbita de la Luna entra dos veces y media adentro. Desde el Sol (panel
derecho) la esfera entera es el punto rojo del extremo de la barra, y el Sol
—dibujado también a escala— es el punto naranja del otro extremo. Las dos
imágenes son verdaderas a la vez, y la segunda es la que hace que el método
de este módulo funcione.], fig-esfera-influencia)

#table(
  columns: (1fr, auto, auto, auto),
  align: (left, right, right, right),
  table.header([*Cuerpo*], [*$R$ (millones de km)*], [*$r_"SOI"$ (km)*], [*$r_"SOI" \/ R$*]),
  [Mercurio], [57,9], [112 400], [0,19%],
  [Venus], [108,2], [616 000], [0,57%],
  [Tierra], [149,6], [925 000], [0,62%],
  [Marte], [227,9], [577 000], [0,25%],
  [Júpiter], [778,6], [48 200 000], [6,2%],
  [Saturno], [1433,5], [54 800 000], [3,8%],
  [Luna (respecto de la Tierra)], [0,3844], [66 200], [17,2%],
)

Los números están calculados con la @m17-soi a partir de los $mu$ del
apéndice F y coinciden con la tabla A.2 de Curtis. La última fila usa la
misma fórmula con la Tierra en el papel del Sol y la Luna en el del planeta.

Las dos comparaciones que le dan sentido al número de la Tierra son opuestas,
y las dos importan:

- *Contra el planeta:* $925 thin 000$ km son *145 radios terrestres*, y
  dos veces y media la órbita de la Luna. Desde adentro, la frontera está
  lejísimos — tan lejos que, para una nave que sale desde 300 km de altura,
  se parece bastante al infinito.
- *Contra la órbita:* son el *0,62%* del radio de la órbita de la Tierra.
  Desde afuera, la frontera —y el planeta entero con ella— es un punto.

#posta[
  Las dos comparaciones son las dos mentiras que el método necesita, y son
  simétricas:

  - Desde adentro decimos *«la frontera está en el infinito»*, y por eso se
    puede usar $v_oo$ —la velocidad de sobra *en el infinito* del módulo
    16— como la velocidad con la que la nave sale de verdad. Vale porque 145
    radios terrestres es prácticamente el infinito para la gravedad de la
    Tierra.
  - Desde afuera decimos *«la frontera es un punto»*, y por eso el módulo 11
    pudo tratar a la Tierra como un punto sobre la elipse de Hohmann. Vale
    porque 0,6% no se ve en un dibujo del sistema solar.

  Lo lindo es que las dos son mentiras *en direcciones contrarias* —una dice
  que es infinito, la otra que es cero— y las dos se aplican al mismo objeto.
  No se contradicen porque cada una se usa en el problema donde es buena.
]

== El método de las cónicas parcheadas

Con la frontera puesta, el viaje queda partido en tres tramos, y en cada uno
vale exactamente lo que ya está deducido en los módulos anteriores.

#definicion("método de las cónicas parcheadas")[
  Resolver un viaje interplanetario como una secuencia de problemas de dos
  cuerpos:

  + *Adentro de la esfera de influencia del planeta de partida:* dos cuerpos
    con el planeta. La trayectoria es una *hipérbola* (módulo 16), porque la
    nave tiene que llegar a la frontera con velocidad de sobra.
  + *Afuera de toda esfera de influencia:* dos cuerpos con el Sol. La
    trayectoria es una *elipse* heliocéntrica — la transferencia de Hohmann
    del módulo 11, o la que corresponda.
  + *Adentro de la esfera de influencia del planeta de llegada:* dos cuerpos
    con ese planeta, y otra *hipérbola*.

  El pegado se hace en las fronteras, y la magnitud que se pasa de un
  problema al siguiente es la *velocidad relativa*: la velocidad
  heliocéntrica de la elipse menos la del planeta es el $v_oo$ de la
  hipérbola.
]

#fig([Las tres cónicas del método, y dónde se pegan: la nave es de la Tierra
hasta el primer círculo hueco, del Sol entre los dos, y de Marte del segundo
en adelante. El cuerpo central cambia ahí y en ningún otro lado del viaje.],
fig-conicas-parcheadas)

#clave[
  *El pegado es de velocidades relativas, y ésa es la única cuenta del
  método.* En el punto de salida:

  $ bold(v)_oo = bold(V)_"nave" - bold(V)_"planeta" $ <m17-pegado>

  con las dos velocidades del lado derecho medidas desde el Sol. Para una
  transferencia de Hohmann hacia afuera las dos son paralelas y del mismo
  sentido, así que la resta es directa: $v_oo = V_"perihelio" - V_T$, que es
  exactamente el $Delta v_1$ que el módulo 11 calculó — y el módulo 16 ya
  avisó que *ése no era el $Delta v$ del motor*. Ahora se ve por qué: era el
  $v_oo$ del pegado.
]

#cuidado[
  *Para la Luna el método no sirve, y la tabla dice por qué.* La esfera de
  influencia de la Luna mide $66 thin 200$ km y la Luna orbita a
  $384 thin 400$ km: la frontera es el *17%* de la distancia, no el 0,6%.
  Ninguna de las dos mentiras se sostiene — ni «es un punto» ni «está en el
  infinito» —, y encima la Tierra y la Luna tienen masas comparables, así que
  el centro de masa del par no está ni cerca del centro de la Tierra (el
  módulo 8 ya lo había calculado).

  Un viaje a la Luna se plantea con el *problema restringido de tres
  cuerpos*, que es el módulo 19.
]

== Cuánto cuesta la mentira

Que el método funcione no exime de medir el error, y el error se mide con
las herramientas del módulo 16 y nada más. Se toma la hipérbola de salida
hacia Marte —la del ejemplo de abajo, con $v_oo = 2,943$ km/s y
$r_p = 6678$ km— y se pregunta qué pasa *en la frontera* en vez de en el
infinito.

*La velocidad.* En la frontera, a $r_"SOI" = 924 thin 700$ km, la velocidad
de escape todavía no es cero:

$ v_"esc"^2 = (2 mu_T)/r_"SOI" = (2 dot 398 thin 600)/(924 thin 700) = 0,862
  quad ==> quad v_"esc" = 0,929 " km/s" $

y con la relación $v^2 = v_"esc"^2 + v_oo^2$ del módulo 16,

$ v^2 = 0,862 + 8,661 = 9,523 quad ==> quad v = 3,086 " km/s" $

contra los $2,943$ km/s que el método le atribuye. *La nave cruza la frontera
un 4,9% más rápido de lo que la elipse heliocéntrica supone.*

*La dirección.* La anomalía verdadera de la asíntota es
$nu_oo = arccos(-1 \/ e) = arccos(-1 \/ 1,145) = 150,8°$, y en la frontera la
ecuación de la órbita del módulo 9 da

$ 1 + e cos nu = h^2/(mu_T r_"SOI") = (14 thin 325)/(924 thin 700) = 0,01549
  quad ==> quad nu = 149,3° $

o sea $1,5°$ antes de la asíntota. *La dirección de salida está bien casi
exactamente*, mucho mejor que el módulo.

#clave[
  *El error del método no es simétrico, y eso decide cómo se corrige.* La
  dirección se acierta con un error de grado y medio; el módulo de la
  velocidad se erra por casi 5%. Eso es lo esperable: la geometría de la
  hipérbola converge a su asíntota mucho antes que la velocidad converge a
  $v_oo$, porque la velocidad arrastra la raíz de un término que se anula
  recién en el infinito.

  Por eso las misiones reales no usan el resultado del parcheo como final:
  lo usan como *primera aproximación* y lo corrigen con maniobras a mitad de
  camino, que son baratas en combustible justamente porque el error es chico.
  Y por eso también, aunque el tramo adentro de la esfera dure poco —una
  cuenta que necesita la ecuación de Kepler para hipérbolas, que este apunte
  no desarrolla, da $3,2$ días de los $259$ que tarda el viaje entero, o sea
  el 1,2%—, el efecto sobre el punto de llegada no es despreciable.
]

#posta[
  Que quede claro qué se está diciendo, porque es fácil leerlo al revés: el
  método de las cónicas parcheadas *no da el resultado exacto*. Da un
  resultado con unos pocos por ciento de error, con cuentas que se hacen a
  mano en media hora, y sobre todo da el *diseño*: cuánto $Delta v$ hace
  falta, cuándo hay que salir, adónde se llega. Después una computadora
  integra las ecuaciones de verdad partiendo de ahí.

  Cambiar «esto es exacto» por «esto es una primera aproximación buena, y sé
  de qué tamaño es el error» es exactamente lo que separa una cuenta de
  ingeniería de una cuenta de examen.
]

== El ejemplo completo: Tierra a Marte, con la licencia ya dada

El módulo 16 dejó calculado el encendido de salida hacia Marte pero sin
justificar por qué se podía pegar con la elipse del módulo 11. Con la
licencia dada, el ejemplo se cierra y aparecen las dos cosas que faltaban:
*dónde* se enciende y *cuánto combustible* se lleva.

Antes hacen falta dos formas de las ecuaciones del módulo 16 que ahí no se
escribieron, porque recién acá se conoce el dato de entrada. En una
hipérbola de salida el dato es el par $v_oo$ y $r_p$ — el $v_oo$ lo fija la
misión y el $r_p$ lo fija la órbita de estacionamiento — y de ese par sale
todo lo demás.

#deduccion("la excentricidad y el encendido, a partir de la velocidad de sobra y del radio de estacionamiento")[
  Del módulo 16, $v_oo^2 = mu \/ a$ y $r_p = a(e - 1)$. Despejando $a$ de la
  primera y metiéndola en la segunda:

  $ r_p = mu/v_oo^2 (e - 1) quad ==> quad e = 1 + (r_p v_oo^2)/mu $ <m17-e>

  La velocidad en el perigeo sale de la misma relación
  $v^2 = v_"esc"^2 + v_oo^2$ del módulo 16, evaluada en $r_p$:

  $ v_p = sqrt(v_oo^2 + (2 mu)/r_p) $ <m17-vp>

  y como en la órbita de estacionamiento la nave ya viaja a
  $v_c = sqrt(mu \/ r_p)$ (módulo 6), sacando factor común $v_c$ queda el
  encendido en la forma en que conviene mirarlo:

  $ Delta v = v_p - v_c = v_c (sqrt(2 + (v_oo/v_c)^2) - 1) $ <m17-dv>

  El paréntesis dice todo: si $v_oo = 0$ el encendido es
  $(sqrt(2) - 1) v_c$, que es el escape justo del módulo 6; y la velocidad de
  sobra entra *al cuadrado y sumada al 2*, no sumada afuera. Ésa es la razón
  algebraica de que salir con sobra cueste tan poco más que salir justo.
]

Y falta *dónde* encender. La @m17-pegado obliga a que $bold(v)_oo$ sea
paralelo a la velocidad de la Tierra alrededor del Sol; el módulo 16 mostró
que la asíntota forma un ángulo $beta = arccos(1 \/ e)$ con la línea de
ábsides. Juntando las dos cosas: *el perigeo de la hipérbola —el punto donde
se enciende— está a $beta$ de la dirección de la velocidad orbital de la
Tierra*, y eso fija el punto de la órbita de estacionamiento donde tiene que
ocurrir el encendido.

#ejemplo("Partida a Marte desde una órbita de estacionamiento de 300 km", nivel: "a fondo")[
  *Datos:* $mu_T = 398 thin 600 " km"^3"/s"^2$,
  $mu_"Sol" = 1,327 times 10^11 " km"^3"/s"^2$,
  $R_T = 149,6 times 10^6$ km, $R_M = 227,9 times 10^6$ km, órbita de
  estacionamiento de $300$ km de altura ($r_p = 6678$ km), impulso específico
  del motor $I_"sp" = 300$ s. (Curtis, ejemplo 8.4, pág. 401.)

  *(a) El $v_oo$ que la misión pide.* Sale del pegado, y es la cuenta del
  módulo 11 leída con el nombre correcto: la velocidad de la Tierra menos la
  del perihelio de la transferencia,

  $ v_oo = sqrt(mu_"Sol"/R_T) (sqrt((2 R_M)/(R_T + R_M)) - 1) = 29,78 dot
    (1,0988 - 1) = 2,943 " km/s" $

  *(b) La hipérbola de salida*, con la @m17-e:

  $ e = 1 + (6678 dot 8,661)/(398 thin 600) = 1,145 $

  y con la @m17-vp, $v_p^2 = 8,661 + (2 dot 398 thin 600) \/ 6678 = 128,1$,
  o sea $v_p = 11,32$ km/s.

  *(c) El encendido*, con la @m17-dv y
  $v_c = sqrt((398 thin 600) \/ 6678) = 7,726$ km/s:

  $ Delta v = 7,726 (sqrt(2 + (2,943 \/ 7,726)^2) - 1) = 7,726 dot 0,4646
    = 3,590 " km/s" $

  que es el número que el módulo 16 ya había obtenido restando $v_p - v_c$:
  la @m17-dv no es una fórmula nueva sino la misma resta ordenada.

  *(d) Dónde se enciende.*

  $ beta = arccos(1/e) = arccos(1/(1,145)) = 29,2° $

  El perigeo —y con él el encendido— está a $29,2°$ de la dirección en la que
  la Tierra se mueve alrededor del Sol. Como la órbita de estacionamiento
  suele recorrerse de oeste a este, el encendido cae del lado nocturno de la
  Tierra.

  *(e) Cuánto combustible.* Con la ecuación del cohete del módulo 4, en la
  forma que ahí se dedujo, la fracción de masa que hay que quemar es

  $ (Delta m)/m = 1 - exp(-Delta v \/ (I_"sp" g_0))
    = 1 - exp(-3,590 \/ (300 dot 9,81 times 10^(-3))) = 0,705 $

  (acá $exp$ va escrito así y no como $e$ elevado a algo, para que no se
  confunda con la excentricidad, que en este módulo también se llama $e$).

  *El 70% de la masa de la nave, antes del encendido, es combustible* — y eso
  para el viaje de ida solamente, sin frenar en Marte y sin volver.

  #clave[
    *Los cinco resultados salieron de dos números: $v_oo$ y $r_p$.* Y el
    reparto de trabajo es el que este módulo vino a justificar: el
    $v_oo = 2,943$ km/s lo produce el problema *heliocéntrico* (módulo 11) y
    lo consume el problema *planetocéntrico* (módulo 16), sin que ninguno de
    los dos sepa nada del otro. El único punto de contacto entre los dos
    problemas es ese número, pasado en la frontera.

    Y el apartado (e) es la razón por la que todo esto importa:
    $0,7 " km/s"$ de diferencia en el diseño de la trayectoria son decenas de
    toneladas de combustible. Por eso se calcula con cuidado un $Delta v$ que
    después dura ocho minutos.
  ]
]

== Lo que se usa después

1. *La frontera, como criterio de cuándo cambiar de cuerpo central.* Es lo
   único que hay que recordar del módulo: adentro manda el planeta, afuera
   manda el Sol, y el número que cruza la frontera es $v_oo$.

2. *La excentricidad y el encendido, en función de $v_oo$ y $r_p$.* La
   @m17-e y la @m17-dv son las dos ecuaciones con las que se diseña cualquier
   partida planetaria, y las dos toman como entrada lo que la misión fija de
   verdad: la velocidad de sobra y la altura de la órbita de estacionamiento.

3. *El ángulo $beta$.* Da el punto de encendido, y con él la geometría del
   lanzamiento: la hipérbola de salida puede girar alrededor del eje paralelo
   a $bold(v)_oo$ que pasa por el centro del planeta, así que los perigeos
   posibles forman un círculo de radio $r_p sin beta$ — para el ejemplo de
   arriba, $6678 dot sin 29,2° = 3260$ km. De ahí salen las ventanas de
   lanzamiento diarias.

4. *La llegada, que es el mismo método al revés.* La nave entra a la esfera
   de influencia de Marte con un $v_oo$ dado por la misma resta de
   velocidades, recorre una hipérbola, y ahí hay dos opciones: frenar en el
   perigeo para quedar capturada en una elipse, o no frenar y salir con la
   misma rapidez pero girada un ángulo $delta$ — que es la *asistencia
   gravitatoria* que el módulo 16 anticipó.

5. *El caso en que el método no vale.* Cuando la esfera de influencia no es
   ni un punto ni el infinito —la Luna— hay que resolver de verdad el
   problema de tres cuerpos, y eso es el módulo 19.
