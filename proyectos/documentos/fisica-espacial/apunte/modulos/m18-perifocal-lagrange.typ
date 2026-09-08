#import "../plantilla.typ": *

#modulo("Marco perifocal, vector de estado y coeficientes de Lagrange")[
  Escribir una órbita en *vectores*, que es como la escribe cualquier
  computadora de vuelo y cualquier radar. Elegir el sistema de ejes en el que
  eso se hace sin esfuerzo —el perifocal, clavado a la propia órbita— y
  escribir ahí $bold(r)$ y $bold(v)$ en dos renglones. Contar los seis números
  que hacen falta para fijar una órbita y una nave adentro de ella, y pasar de
  las seis coordenadas del *vector de estado* a los seis *elementos
  orbitales*, que son los mismos seis números en la otra moneda. Y propagar la
  órbita —dónde está y a qué velocidad va después de girar $Delta nu$— sin
  recalcular nada, con cuatro coeficientes.
]

Todo lo que la Parte III y la Parte V hicieron hasta acá está escrito con
*escalares*: $r$, $nu$, $h$, $e$, $a$. Alcanzó para deducir las cónicas, para
Kepler, para Hohmann y para la hipérbola de escape, y va a seguir alcanzando
para entender cualquier órbita.

Lo que no alcanza es para *operar* una. Un radar no entrega $r$ y $nu$:
entrega tres números de posición y tres de velocidad, en los ejes que ese
radar usa. Un integrador numérico no acepta «una elipse de excentricidad
$0,3$»: acepta $bold(r)_0$ y $bold(v)_0$ y devuelve $bold(r)$ y $bold(v)$. Y
un catálogo de satélites no guarda trayectorias: guarda seis números por
objeto. Este módulo es el puente entre las dos formas de decir lo mismo.

== La idea completa, antes de la primera ecuación

Todavía no hay ninguna cuenta hecha. Lo que sigue es el plan, en tres pasos.

+ *Elegir bien los ejes.* Un vector no cambia porque uno cambie de ejes —lo
  único que cambia son los tres números con los que se escribe—, así que
  conviene elegir los ejes donde esos números salgan solos. Para una órbita
  ese sistema existe y es uno solo: el que tiene un eje apuntando al perigeo y
  el otro a $90°$ en el plano de la órbita. Se llama *marco perifocal*, y en
  él la posición se lee directamente de la ecuación de la órbita del módulo 9.

+ *Contar los números.* Una órbita con una nave adentro queda fija con *seis*
  números, ni más ni menos, y hay dos maneras de darlos. Una es el *vector de
  estado*: las tres componentes de $bold(r)$ y las tres de $bold(v)$ en un
  instante. La otra son los *seis elementos orbitales*: tamaño, forma, tres
  ángulos de orientación y la posición sobre la órbita. Las dos contienen
  exactamente la misma información —se pasa de una a la otra sin perder ni
  agregar nada— pero se usan para cosas distintas, y la razón es una sola: en
  el vector de estado los seis números cambian todo el tiempo; en los
  elementos, *cinco están clavados y sólo uno corre*.

+ *Propagar sin resolver nada.* La última pregunta es la de siempre: dado el
  estado ahora, ¿cuál es el estado después? Y tiene una respuesta que parece
  demasiado barata: la posición futura es una *mezcla* de la posición y la
  velocidad de ahora, con dos números por delante. Esos números son los
  *coeficientes de Lagrange*.

#posta[
  La posta de este módulo son dos ideas, y ninguna de las dos es una cuenta.

  La primera: *cambiar de ejes no cambia nada físico*. La órbita es la que es;
  los ejes son una decisión tuya. Lo único que cambia al elegirlos bien es
  cuánto trabajo cuesta escribir el problema — y el marco perifocal lo baja a
  dos renglones porque le regala a la órbita los ejes que ella misma define:
  uno al perigeo, otro a noventa grados.

  La segunda: para saber dónde va a estar la nave *no hace falta volver a
  averiguar en qué órbita está*. Lo que hay que descubrir ya está adentro de
  $bold(r)_0$ y $bold(v)_0$, y todo punto futuro se arma sumando esos dos
  vectores con dos coeficientes. Eso es lo que hace un propagador de verdad:
  no vuelve a calcular $e$ ni $a$ ni $nu$ en cada paso, multiplica y suma.

  Y hay una tercera que conviene tener antes de empezar, porque es la que
  organiza el módulo entero: una órbita *son seis números*. Cualesquiera seis
  que la fijen sirven; el resto es en qué moneda te conviene tenerlos.
]

#clave[
  *El plan del módulo, en cuatro pasos:*
  + Armar el marco perifocal y escribir ahí $bold(r)$ y $bold(v)$.
  + Contar los seis números, en las dos monedas, y dar la receta para pasar de
    una a la otra.
  + Deducir los coeficientes de Lagrange a partir de un solo hecho geométrico:
    $bold(r)_0$ y $bold(v)_0$ son una base del plano de la órbita.
  + Decir qué falta —el tiempo— y hasta dónde llega lo que sí tenemos.
]

== El marco perifocal

#definicion("el marco perifocal")[
  Es el sistema cartesiano *fijo en el espacio* y centrado en el foco ocupado
  de la órbita, con sus ejes definidos por la órbita misma:

  - $hat(p)$ apunta del foco al *perigeo*, o sea a lo largo de la línea de
    ábsides. Es el eje $x$.
  - $hat(q)$ está en el plano de la órbita, a $90°$ de $hat(p)$ *en el sentido
    en que la nave se mueve*. Es el eje $y$, y es la dirección de la anomalía
    verdadera $nu = 90°$.
  - $hat(w) = bold(h) \/ h$ completa la terna derecha y sale del plano de la
    órbita, en la dirección del momento angular del módulo 7.

  Los tres son constantes: el plano de la órbita no se mueve y la línea de
  ábsides tampoco, así que *derivar en este marco es derivar sólo las
  componentes*.
]

#fig([El marco perifocal, y por qué se lo llama el marco natural de una
órbita. El origen es el foco ocupado —donde está el cuerpo que atrae—,
$hat(p)$ apunta al perigeo y $hat(q)$ a $90°$ en el sentido del movimiento;
$hat(w)$ sale de la hoja y por eso se dibuja como un círculo con un punto. La
posición del satélite se lee como dos números sobre esos ejes,
$x = r cos nu$ e $y = r sin nu$, sin ninguna cuenta intermedia: la única
información que hace falta es $r$, que la da la ecuación de la órbita, y
$nu$, que es el ángulo que ya se venía usando desde el módulo 9. La velocidad
$bold(v)$ es tangente a la órbita, y sus dos componentes en este marco
—ésa es la sorpresa de la sección— no dependen de dónde esté la
nave.], fig-perifocal)

Con la anomalía verdadera $nu$ medida desde $hat(p)$, que es exactamente desde
donde se la venía midiendo, la posición no necesita deducirse: se lee.

$ bold(r) = x hat(p) + y hat(q), quad quad x = r cos nu, quad y = r sin nu $ <m18-r>

y como el módulo $r$ lo da la ecuación de la órbita del módulo 9
(@m9-orbita), queda todo junto:

$ bold(r) = h^2/mu 1/(1 + e cos nu) (cos nu hat(p) + sin nu hat(q)) $ <m18-r-orbita>

#deduccion("la velocidad en el marco perifocal")[
  Se deriva la @m18-r respecto del tiempo. Los versores son constantes, así
  que sólo se derivan las componentes:

  $ bold(v) = dot(x) hat(p) + dot(y) hat(q), quad quad
    cases(
      dot(x) = dot(r) cos nu - r dot(nu) sin nu,
      dot(y) = dot(r) sin nu + r dot(nu) cos nu
    ) $

  Y las dos derivadas que aparecen ahí ya están despejadas de antes. $dot(r)$
  es la velocidad radial, que es la $v_r$ que el módulo 16 sacó (@m16-vr), y
  $r dot(nu)$ es la velocidad transversal $v_perp = h \/ r$ del mismo módulo,
  reescrita con la ecuación de la órbita:

  $ dot(r) = mu/h e sin nu, quad quad r dot(nu) = v_perp = h/r = mu/h (1 + e cos nu) $

  Reemplazando y agrupando, los dos $cos nu sin nu$ se cancelan en la primera
  y los dos $cos^2 nu + sin^2 nu$ se juntan en la segunda:

  $ dot(x) = mu/h (e sin nu cos nu - sin nu - e cos nu sin nu) = - mu/h sin nu $

  $ dot(y) = mu/h (e sin^2 nu + cos nu + e cos^2 nu) = mu/h (e + cos nu) $
]

$ bold(v) = mu/h [-sin nu hat(p) + (e + cos nu) hat(q)] $ <m18-v>

#clave[
  *Las componentes de la velocidad no dependen de $r$.* En la @m18-v aparecen
  $mu$, $h$, $e$ y $nu$, y ninguna distancia. Eso no es una casualidad de
  escritura: dice que en el marco perifocal la velocidad está determinada por
  *dónde está la nave sobre la órbita* y no por cuán lejos está — que es la
  forma vectorial de algo que el módulo 9 ya sabía en escalares, porque $r$ y
  $nu$ tampoco son independientes.

  Y tiene dos lecturas inmediatas. En el perigeo, $nu = 0$ y queda
  $bold(v) = (mu \/ h)(1 + e) hat(q)$: perpendicular a $bold(r)$, como tenía
  que ser en un ábside. Y $mu \/ h$ es el factor común de toda la velocidad de
  una órbita: lo que cambia con $nu$ es sólo el corchete, que se mueve entre
  $1 - e$ y $1 + e$ en la componente transversal.
]

#notacion[
  *Los dos libros que la cátedra pide usan nombres distintos para lo mismo.*
  Curtis (§2.10) llama $theta$ a la anomalía verdadera y $hat(p) hat(q)
  hat(w)$ a los versores; el Bate (§2.2.4) la llama $nu$ y a los versores los
  llama $bold(P)$, $bold(Q)$, $bold(W)$, con ejes $x_w$, $y_w$, $z_w$. Son
  exactamente el mismo sistema, con las mismas dos fórmulas: la @m18-r es la
  ec. (2.5-1) del Bate y la @m18-v es su ec. (2.5-4).

  Este apunte usa $nu$ para la anomalía —que es lo que viene usando desde el
  módulo 9— y los versores en minúscula con sombrero.
]

#ejemplo("del marco perifocal a los vectores, y de los vectores al marco")[
  Las dos direcciones del mismo problema, que es lo que conviene practicar
  junto. (Curtis, ejemplos 2.11 y 2.12, pág. 104.)

  *(a) De la órbita a los vectores.* Una órbita terrestre tiene $e = 0,3$,
  $h = 60 thin 000 " km"^2"/s"$ y está en $nu = 120°$. Con la @m18-r-orbita, y
  usando $h^2 \/ mu = (60 thin 000)^2 \/ (398 thin 600) = 9031,6$ km:

  $ r = (9031,6)/(1 + 0,3 dot (-0,5)) = (9031,6)/(0,85) = 10 thin 625 " km" $

  $ bold(r) = 10 thin 625 (cos 120° hat(p) + sin 120° hat(q))
    = -5312,7 hat(p) + 9201,9 hat(q) quad ["km"] $

  y con la @m18-v, donde $mu \/ h = (398 thin 600) \/ (60 thin 000) = 6,6433$:

  $ bold(v) = 6,6433 [-sin 120° hat(p) + (0,3 + cos 120°) hat(q)]
    = -5,7533 hat(p) - 1,3287 hat(q) quad ["km/s"] $

  El signo de la segunda componente dice que la nave ya viene *bajando* hacia
  el perigeo, cosa que $nu = 120°$ ya anticipaba.

  *(b) De los vectores a la órbita.* Ahora al revés: dados

  $ bold(r) = 7000 hat(p) + 9000 hat(q), quad quad
    bold(v) = -3,3472 hat(p) + 9,1251 hat(q) $

  hay que sacar $h$, $nu$ y $e$. El momento angular sale del producto
  vectorial del módulo 7, y como los dos vectores están en el plano
  $hat(p) hat(q)$ el resultado es puro $hat(w)$:

  $ bold(h) = bold(r) times bold(v) = [7000 dot 9,1251 - 9000 dot (-3,3472)] hat(w)
    = 94 thin 000 hat(w) quad ["km"^2"/s"] $

  La anomalía se mide desde $hat(p)$, así que sale de un producto escalar —es
  la proyección del módulo 1—, con $r = 11 thin 402$ km:

  $ cos nu = (bold(r) dot hat(p))/r = (7000)/(11 thin 402) = 0,61394
    quad ==> quad nu = 52,1° $

  y de las dos soluciones se elige la del primer cuadrante porque la
  componente en $hat(q)$ de $bold(r)$ es positiva, o sea $sin nu > 0$.
  Finalmente, la excentricidad de la ecuación de la órbita:

  $ 11 thin 402 = (94 thin 000^2 \/ (398 thin 600))/(1 + e cos 52,1°)
    quad ==> quad e = 1,538 $

  *Es una hipérbola*, y eso no se veía en los datos: dos vectores de aspecto
  inocente pueden ser una trayectoria de la que no se vuelve. Es el primer
  aviso de lo que la sección que sigue va a decir con todas las letras — que
  los seis números del estado *no se leen*, se traducen.
]

== Los seis números de una órbita

#definicion("vector de estado")[
  El *vector de estado* de una nave en un instante es el par
  $(bold(r), bold(v))$ referido a un sistema inercial: seis números. Con esos
  seis y la ley de gravitación queda determinado todo el pasado y todo el
  futuro del movimiento, porque la ecuación del problema de dos cuerpos del
  módulo 8 es de segundo orden y necesita exactamente dos condiciones
  iniciales vectoriales.
]

Seis es el número, y no hay forma de bajarlo. Lo que sí hay es *otra manera de
elegir cuáles seis*, y ésa es la lista que la cátedra pide del Bate (§2.3):
los *elementos orbitales clásicos*.

- $a$ — el semieje mayor: el *tamaño* de la órbita. (Se lo puede reemplazar
  por $p$, o por $r_p$; da lo mismo, son la misma información en otra forma,
  como mostró el módulo 9 con la @m9-semiejes.)
- $e$ — la excentricidad: la *forma*. Con $a$ y $e$ la cónica queda dibujada,
  pero todavía flotando en el espacio.
- $i$ — la *inclinación*: el ángulo entre $hat(k)$ y el vector $bold(h)$. O
  sea, cuánto está volcado el plano de la órbita respecto del plano de
  referencia (el ecuador, para un satélite terrestre).
- $Omega$ — la *longitud del nodo ascendente*: medido en el plano de
  referencia, el ángulo desde una dirección fija —$hat(i)$, que apunta al
  punto vernal— hasta el punto donde la órbita cruza ese plano subiendo. Con
  $i$ y $Omega$ el plano de la órbita queda fijo.
- $omega$ — el *argumento del perigeo*: ya adentro del plano de la órbita, el
  ángulo desde el nodo ascendente hasta el perigeo. Es lo que le faltaba a la
  cónica para dejar de poder girar sobre su propio plano.
- $nu_0$ — la *anomalía verdadera en la época* $t_0$: dónde está la nave. (Se
  lo puede reemplazar por $T$, el instante de paso por el perigeo.)

#clave[
  *Los primeros cinco son constantes; sólo el sexto corre.* Ésa es toda la
  diferencia entre las dos monedas, y es la razón por la que existen las dos.

  En el vector de estado los seis números cambian a cada segundo, y ninguno
  significa nada por sí solo: $bold(r) = 7000 hat(i) + 9000 hat(j)$ no dice si
  la órbita es una elipse o una hipérbola —el ejemplo de la sección anterior lo
  mostró—, ni si es alta o baja. En los elementos, en cambio, cinco de los
  seis *no cambian nunca* mientras valga el problema de dos cuerpos, y cada
  uno significa una cosa sola: tamaño, forma, vuelco, giro del plano, giro
  adentro del plano, y posición.

  Por eso un integrador numérico usa el estado —es lo que la ecuación
  diferencial pide— y un catálogo usa los elementos: guardar seis números de
  los cuales cinco son constantes es guardar una órbita; guardar el estado es
  guardar una foto que vence enseguida.
]

#posta[
  Son la misma plata en dos monedas. El vector de estado es lo que *mide* un
  instrumento y lo que *come* una computadora; los elementos orbitales son lo
  que se *entiende* y lo que se *anota*. Ninguna de las dos tiene información
  que la otra no tenga —si tuviera, la traducción no sería posible en las dos
  direcciones—, y la traducción es esta sección.

  Y si te quedás con una sola frase, que sea la del Bate: *un cambio de
  coordenadas no le cambia nada al vector* — ni el módulo, ni la dirección, ni
  lo que representa. Sólo cambia con qué tres números lo escribís. Esa frase
  es la que evita el error más común de todo el tema, que es creer que pasar a
  perifocal «transformó» la órbita.
]

=== Cómo se pasa del estado a los elementos

El Bate (§2.4) lo arma con *tres vectores* y después nada más que ángulos
entre pares de vectores. Los tres:

$ bold(h) = bold(r) times bold(v), quad quad
  bold(n) = hat(k) times bold(h), quad quad
  bold(e) = 1/mu [(v^2 - mu/r) bold(r) - (bold(r) dot bold(v)) bold(v)] $ <m18-tres>

y cada uno tiene una lectura geométrica que conviene tener antes que la
fórmula. $bold(h)$ es perpendicular al plano de la órbita, así que fija ese
plano. $bold(n)$, por ser perpendicular a $hat(k)$ *y* a $bold(h)$, está en la
intersección de los dos planos: apunta al nodo ascendente, que es justo la
dirección desde la que se mide $omega$. Y $bold(e)$ —el *vector
excentricidad*, que el módulo 9 obtuvo al integrar la ecuación de la órbita—
apunta del foco al perigeo y tiene módulo $e$: fija la línea de ábsides y la
forma de un saque.

Con esos tres, los seis elementos son seis cosenos. El ángulo entre dos
vectores sale del producto escalar del módulo 1, $cos alpha = (bold(A) dot
bold(B)) \/ (A B)$:

$ p = h^2/mu, quad quad e = abs(bold(e)), quad quad
  cos i = h_z/h, quad quad
  cos Omega = n_x/n $

$ cos omega = (bold(n) dot bold(e))/(n e), quad quad
  cos nu_0 = (bold(e) dot bold(r))/(e r) $ <m18-elementos>

#cuidado[
  *Un coseno no da un ángulo: da dos.* Cada uno de los cuatro ángulos de
  arriba tiene dos soluciones entre $0°$ y $360°$, y cuál es la buena lo
  decide un dato *que está en el problema*, no en el coseno. Las tres reglas,
  del Bate:

  - $Omega < 180°$ si $n_y > 0$. (Si el nodo tiene componente $hat(j)$
    positiva, está en la primera mitad de la vuelta.)
  - $omega < 180°$ si $e_z > 0$. (Si el perigeo está por encima del plano de
    referencia, la órbita subió antes de llegar a él.)
  - $nu_0 < 180°$ si $bold(r) dot bold(v) > 0$.

  La tercera es la que más se usa y la que tiene el significado más limpio:
  $bold(r) dot bold(v) = r dot(r)$, así que su signo es el signo de la
  velocidad radial. *Positivo quiere decir que la nave se está alejando*, o
  sea que va del perigeo al apogeo, o sea $nu$ entre $0°$ y $180°$. Es el
  mismo criterio con el que el módulo 16 elegía el signo de $gamma$.

  La inclinación no necesita chequeo porque, por definición, $i$ siempre está
  entre $0°$ y $180°$.
]

#cuidado[
  *Hay órbitas para las que algunos de los seis elementos no existen.* No es
  una patología rara: son los dos casos más lindos que hay.

  - *Órbita ecuatorial* ($i = 0$): el plano de la órbita y el de referencia
    son el mismo, no se cruzan en una recta, y *no hay nodo ascendente*.
    Entonces $Omega$ y $omega$ quedan indefinidos —la @m18-tres da
    $bold(n) = bold(0)$, y los dos cosenos que lo tienen en el denominador
    dividen por cero—.
  - *Órbita circular* ($e = 0$): no hay perigeo, así que $omega$ y $nu_0$
    quedan indefinidos, y $bold(e) = bold(0)$.

  En los dos casos la órbita existe perfectamente y el vector de estado la
  describe sin problema: lo que falla es la *moneda*, no el dinero. Se
  arreglan cambiando de elemento —el Bate define el argumento de latitud
  $u_0 = omega + nu_0$ para el caso circular y la longitud verdadera
  $ell_0 = Omega + omega + nu_0$ para el ecuatorial y circular a la vez—, y
  eso es exactamente lo que hace el software real. *Una singularidad de las
  coordenadas no es una singularidad de la física.*
]

== Los coeficientes de Lagrange

Acá hay una sola idea, y se dice en un renglón antes de cualquier cuenta.

El movimiento es plano: el módulo 7 mostró que $bold(h)$ se conserva y que por
eso la órbita entera vive en un plano. Y en ese plano, $bold(r)_0$ y
$bold(v)_0$ son *dos vectores que no son paralelos* —si lo fueran,
$bold(r)_0 times bold(v)_0 = bold(h)$ sería cero y la trayectoria sería una
caída en línea recta—, o sea que son una *base*. Cualquier otro vector del
plano se escribe como combinación de esos dos. Y $bold(r)$ y $bold(v)$ en
cualquier instante posterior están en el mismo plano.

Eso es todo. No hace falta ninguna cuenta para saber que existen cuatro
números $f$, $g$, $dot(f)$, $dot(g)$ tales que

$ bold(r) = f bold(r)_0 + g bold(v)_0, quad quad
  bold(v) = dot(f) bold(r)_0 + dot(g) bold(v)_0 $ <m18-fg>

La cuenta sirve para averiguar *cuánto valen*, no para saber que existen.

#fig([Por qué los coeficientes de Lagrange tienen que existir. Lo que hay que
sacar del dibujo es que la posición nueva $bold(r)$ es la *diagonal* de un
paralelogramo cuyos dos lados están sobre los dos vectores que ya se conocían,
y que el único paso conceptual del asunto es tener que *trasladar*
$bold(v)_0$ al foco para poder dibujar el segundo lado: ahí $bold(v)_0$ deja
de ser la velocidad de alguien y pasa a ser el vector de una base. Con los
valores de la figura, $f = 0,45$ y $g = 1,87$.], fig-lagrange-base)

#deduccion("los coeficientes de Lagrange")[
  Se trabaja en el marco perifocal, que es donde $bold(r)$ y $bold(v)$ ya
  están escritos. De la @m18-r, y las mismas dos evaluadas en $t_0$:

  $ bold(r) = x hat(p) + y hat(q), quad quad bold(r)_0 = x_0 hat(p) + y_0 hat(q) $
  $ bold(v) = dot(x) hat(p) + dot(y) hat(q), quad quad bold(v)_0 = dot(x)_0 hat(p) + dot(y)_0 hat(q) $

  El momento angular, calculado con las condiciones iniciales, da una relación
  que se va a usar dos veces:

  $ bold(h) = bold(r)_0 times bold(v)_0 = (x_0 dot(y)_0 - y_0 dot(x)_0) hat(w)
    quad ==> quad h = x_0 dot(y)_0 - y_0 dot(x)_0 $ <m18-h-inicial>

  Ahora se hace lo que el enunciado geométrico pedía: *despejar $hat(p)$ y
  $hat(q)$ en función de $bold(r)_0$ y $bold(v)_0$*. Son dos ecuaciones
  lineales con dos incógnitas —los dos versores—, y resolverlas usando la
  @m18-h-inicial da

  $ hat(p) = dot(y)_0/h bold(r)_0 - y_0/h bold(v)_0, quad quad
    hat(q) = - dot(x)_0/h bold(r)_0 + x_0/h bold(v)_0 $

  Reemplazando esos dos en $bold(r) = x hat(p) + y hat(q)$ y agrupando por
  $bold(r)_0$ y $bold(v)_0$ aparecen, ya sin nada que despejar, los cuatro
  coeficientes:

  $ f = (x dot(y)_0 - y dot(x)_0)/h, quad quad g = (-x y_0 + y x_0)/h $
  $ dot(f) = (dot(x) dot(y)_0 - dot(y) dot(x)_0)/h, quad quad
    dot(g) = (-dot(x) y_0 + dot(y) x_0)/h $ <m18-coefs-xy>

  Los cuatro son el mismo determinante de dos por dos con distintas filas.
]

#clave[
  *Los cuatro coeficientes no son independientes: cumplen $f dot(g) - dot(f) g
  = 1$, y eso es la conservación del momento angular.* Sale de calcular
  $bold(h) = bold(r) times bold(v)$ con la @m18-fg: los términos
  $bold(r)_0 times bold(r)_0$ y $bold(v)_0 times bold(v)_0$ se anulan, queda
  $bold(h) = (f dot(g) - dot(f) g)(bold(r)_0 times bold(v)_0)$, y como
  $bold(h)$ es el mismo de antes y no puede ser cero,

  $ f dot(g) - dot(f) g = 1 $ <m18-wronskiano>

  Tiene dos usos, uno práctico y uno conceptual. El práctico: *conocidos tres,
  el cuarto sale de acá* —así se calcula $dot(f)$, que es el más feo de los
  cuatro— y, sobre todo, es un control barato: si al final de una cuenta la
  @m18-wronskiano no da $1$, hay un error, y no hace falta saber dónde para
  saber que existe.

  El conceptual: esa expresión es el determinante de la matriz que lleva
  $(bold(r)_0, bold(v)_0)$ a $(bold(r), bold(v))$. Que valga exactamente $1$
  significa que la transformación *conserva áreas* en ese plano — que es la
  segunda ley de Kepler del módulo 7 escrita en otro idioma.
]

Poniendo en la @m18-coefs-xy las componentes de la @m18-r y de la @m18-v,
usando $cos(nu - nu_0) = cos nu cos nu_0 + sin nu sin nu_0$ y llamando
$Delta nu = nu - nu_0$ a lo que la nave giró, los cuatro quedan escritos con
una sola variable:

$ f = 1 - (mu r)/h^2 (1 - cos(Delta nu)), quad quad
  g = (r r_0)/h sin(Delta nu) $ <m18-fg-dnu>

$ dot(f) = mu/h (1 - cos(Delta nu))/sin(Delta nu)
    [mu/h^2 (1 - cos(Delta nu)) - 1/r_0 - 1/r], quad quad
  dot(g) = 1 - (mu r_0)/h^2 (1 - cos(Delta nu)) $ <m18-fgpunto-dnu>

donde el $r$ que aparece es el radio *de llegada*, y se obtiene de la ecuación
de la órbita reescrita para que tampoco necesite $nu_0$ ni $e$:

$ r = h^2/mu 1/(1 + (h^2/(mu r_0) - 1) cos(Delta nu) - (h thin v_(r 0))/mu sin(Delta nu)) $ <m18-r-dnu>

#clave[
  *En ninguna de las tres ecuaciones aparece $e$, y eso es lo que hace útil al
  método.* Los coeficientes de Lagrange no preguntan si la órbita es una
  elipse, una parábola o una hipérbola: funcionan igual en las tres, porque
  toda la información sobre la forma ya viaja adentro de $h$, $r_0$ y
  $v_(r 0)$.

  Es exactamente lo contrario de lo que se venía haciendo en el apunte, donde
  cada cónica tenía su fórmula —$a$ positivo o negativo, $nu_oo$ que existe o
  no—. Acá hay *un* juego de ecuaciones para las tres, y ése es el motivo por
  el que un propagador real las usa: el mismo código sirve para un satélite en
  órbita baja y para una sonda de escape, sin un solo `if`.
]

#definicion("la receta para propagar por ángulo")[
  Dados $bold(r)_0$, $bold(v)_0$ y el giro $Delta nu$, el estado nuevo sale en
  cinco pasos. (Es el algoritmo 2.3 de Curtis, pág. 110.)

  + $r_0 = abs(bold(r)_0)$ y $v_0 = abs(bold(v)_0)$.
  + La velocidad radial inicial, proyectando $bold(v)_0$ sobre la dirección de
    $bold(r)_0$: $v_(r 0) = (bold(r)_0 dot bold(v)_0) \/ r_0$.
  + El momento angular, con la parte transversal de la velocidad:
    $h = r_0 sqrt(v_0^2 - v_(r 0)^2)$.
  + El radio de llegada $r$, con la @m18-r-dnu; después $f$, $g$, $dot(f)$ y
    $dot(g)$ con la @m18-fg-dnu y la @m18-fgpunto-dnu.
  + $bold(r) = f bold(r)_0 + g bold(v)_0$ y
    $bold(v) = dot(f) bold(r)_0 + dot(g) bold(v)_0$.

  El paso 3 merece un renglón: es el teorema de Pitágoras sobre la velocidad.
  La velocidad se parte en radial y transversal, la transversal es la única
  que hace momento angular, y el momento angular es $r_0$ por ella. Es la
  @m16-vr del módulo 16 leída al revés.
]

#ejemplo("propagar 120° de anomalía, y recién después preguntar en qué órbita estábamos", nivel: "a fondo")[
  Un satélite terrestre está, en $t_0$, en

  $ bold(r)_0 = 8182,4 hat(i) - 6865,9 hat(j) quad ["km"], quad quad
    bold(v)_0 = 0,47572 hat(i) + 8,8116 hat(j) quad ["km/s"] $

  y se pide su estado después de girar $Delta nu = 120°$. (Curtis, ejemplos
  2.13 y 2.14, pág. 111.)

  *Pasos 1 a 3 — lo que sale de los datos, sin saber nada de la órbita.*

  $ r_0 = 10 thin 681 " km", quad quad v_0 = 8,8244 " km/s" $

  $ v_(r 0) = (bold(r)_0 dot bold(v)_0)/r_0
    = (8182,4 dot 0,47572 - 6865,9 dot 8,8116)/(10 thin 681) = -5,2996 " km/s" $

  El signo negativo ya dice algo antes de calcular nada: la nave se está
  *acercando* al perigeo. Y con la parte transversal,
  $v_0^2 - v_(r 0)^2 = 77,87 - 28,09 = 49,78$, o sea $7,0557$ km/s:

  $ h = 10 thin 681 dot 7,0557 = 75 thin 366 " km"^2"/s" $

  *Paso 4 — el radio de llegada y los cuatro coeficientes.* Con la
  @m18-r-dnu, $h^2 \/ mu = 14 thin 250$ km y $Delta nu = 120°$:

  $ r = (14 thin 250)/(1 + (14 thin 250\/(10 thin 681) - 1)(-0,5)
    - ((75 thin 366)(-5,2996))/(398 thin 600) dot 0,86603) = 8378,8 " km" $

  y de ahí, con la @m18-fg-dnu y la @m18-fgpunto-dnu,

  $ f = 1 - ((398 thin 600)(8378,8))/(75 thin 366^2) dot 1,5 = 0,11802 $

  $ g = ((8378,8)(10 thin 681))/(75 thin 366) dot 0,86603 = 1028,4 " s" $

  $ dot(g) = 1 - ((398 thin 600)(10 thin 681))/(75 thin 366^2) dot 1,5 = -0,12435 $

  $ dot(f) = -9,8666 times 10^(-4) " s"^(-1) $

  *Control barato antes de seguir*, con la @m18-wronskiano:
  $f dot(g) - dot(f) g = 0,11802 dot (-0,12435) + 9,8666 times 10^(-4) dot
  1028,4 = -0,01468 + 1,01468 = 1,000$. #sym.checkmark

  *Paso 5 — el estado nuevo.*

  $ bold(r) = 0,11802 bold(r)_0 + 1028,4 bold(v)_0
    = 1455 hat(i) + 8252 hat(j) quad ["km"] $

  $ bold(v) = -9,8666 times 10^(-4) bold(r)_0 - 0,12435 bold(v)_0
    = -8,1324 hat(i) + 5,6785 hat(j) quad ["km/s"] $

  *Y recién ahora, la órbita.* Nada de lo anterior necesitó saber qué cónica
  era. Si igual se la quiere, salen $e$ y $nu_0$ del sistema de dos ecuaciones
  que arman entre los dos el módulo 9 —la ecuación de la órbita, @m9-orbita—
  y el módulo 16 —la velocidad radial, @m16-vr—, evaluadas en $t_0$:

  $ e cos nu_0 = h^2/(mu r_0) - 1 = 0,3341, quad quad
    e sin nu_0 = (h thin v_(r 0))/mu = -1,002 $

  Elevando al cuadrado y sumando —el truco del módulo 16, otra vez—,
  $e^2 = 1,1157$ y

  $ e = 1,0563 quad ==> quad "es una hipérbola" $

  y como $cos nu_0 = 0,3341 \/ 1,0563 = 0,3163$ con $bold(r)_0 dot bold(v)_0 <
  0$, el chequeo de cuadrante manda: $nu_0 = 288,4°$ y no $71,6°$. La nave
  venía hacia el perigeo, como el signo de $v_(r 0)$ había avisado en el
  primer paso.

  #clave[
    *La propagación se hizo sin saber que la órbita era una hipérbola.* Ése es
    el resultado del ejemplo, más que los números: los cinco pasos de la
    receta corrieron enteros con $bold(r)_0$, $bold(v)_0$ y $Delta nu$, y la
    excentricidad apareció al final como una *consecuencia*, no como un dato.

    Y aparece un detalle que vale por el ejemplo entero: $f = 0,118$ es un
    número chico y $g = 1028$ s es grande. Eso quiere decir que, después de
    $120°$ de giro, la posición nueva es *casi toda* velocidad vieja y casi
    nada de posición vieja. No hay nada raro en eso —$f$ y $g$ no tienen las
    mismas unidades, $g$ es un tiempo— pero explica por qué la cuenta se hace
    con vectores y no a ojo.
  ]
]

#cuidado[
  *El ejemplo 2.13 de Curtis imprime $r_0 = 10 thin 861$ km, y el valor
  correcto es $10 thin 681$.* Es una transposición de dos cifras, y se
  confirma con el resultado que el propio libro imprime dos renglones más
  abajo: con $10 thin 681$ sale $h = 75 thin 366 " km"^2"/s"$, que es lo que
  el libro publica; con $10 thin 861$ saldría $76 thin 630$. El resto del
  ejemplo —incluidos los pasos (b), (d) y (e) del mismo Curtis— usa
  $10 thin 681$. Este apunte usa el valor correcto en todos lados.
]

#posta[
  Lo que hay que llevarse de esta sección no son las cuatro fórmulas: son
  feas, están en el libro y nadie las escribe de memoria. Lo que hay que
  llevarse es *por qué existen*, que se dice en una línea: la órbita es plana,
  y dos vectores no paralelos de un plano alcanzan para escribir cualquier
  otro. Todo lo demás es despejar.

  Y la consecuencia práctica: propagar una órbita *no es* volver a
  resolverla. El propagador no se pregunta cada vez si esto es una elipse; ya
  tiene los cuatro números y multiplica. Ésa es la diferencia entre entender
  una órbita y correrla.
]

== Lo que falta: el tiempo

Hay un agujero, y conviene decirlo de frente porque es el que abre el próximo
tema de la materia. Todo lo de arriba propaga la órbita *por ángulo*: se le da
$Delta nu$ y devuelve el estado. Pero nadie pregunta «¿dónde está la nave
después de girar $120°$?»; la pregunta real es «¿dónde está dentro de dos
horas?».

Pasar de $Delta t$ a $Delta nu$ es un problema aparte —la *ecuación de
Kepler*—, y no es un despeje: la ecuación que los liga no se puede invertir en
forma cerrada. Es el capítulo 3 de Curtis, y este apunte no lo desarrolla.

Lo que sí se puede hacer, y es barato, es escribir $f$ y $g$ *directamente en
función del tiempo* para intervalos cortos, desarrollando $bold(r)(t)$ en
serie de Taylor alrededor de $t_0$ y usando la ecuación de dos cuerpos
$dot.double(bold(r)) = -(mu \/ r^3) bold(r)$ del módulo 8 para reemplazar cada
derivada. Hasta cuarto orden queda

$ f = 1 - mu/(2 r_0^3) Delta t^2 + mu/2 (bold(r)_0 dot bold(v)_0)/r_0^5 Delta t^3 + ... $
$ g = Delta t - mu/(6 r_0^3) Delta t^3 + mu/4 (bold(r)_0 dot bold(v)_0)/r_0^5 Delta t^4 + ... $ <m18-serie>

y ahí se ve, de paso, por qué $g$ tiene unidades de tiempo: su primer término
*es* $Delta t$.

#cuidado[
  *La serie tiene un radio de convergencia, y agregar términos no lo corre.*
  Para la órbita del ejemplo 2.15 de Curtis —$e = 0,2$, perigeo a $7000$ km—
  la serie empieza a despegarse de la solución exacta a los diez minutos, y el
  radio de convergencia es de $1700$ s: *un quinto del período*. Más allá de
  ese punto la serie diverge por más términos que se sumen, porque el
  problema no es la truncación sino la convergencia.

  O sea que la serie sirve para un paso corto de integración, no para
  propagar una órbita entera. Para eso hace falta la forma cerrada de $f$ y
  $g$, que necesita la ecuación de Kepler.
]

Y hay una deuda concreta que este módulo *no* salda: los $3,2$ días que el
módulo 17 le atribuye a la travesía de la esfera de influencia de la Tierra
siguen citados y no deducidos. Para deducirlos hace falta la ecuación de
Kepler hiperbólica, que —por lo dicho arriba— no está acá.

== Lo que se usa después

1. *El marco perifocal, como paso obligado.* Toda conversión entre elementos
   orbitales y vectores pasa por él: se arma $bold(r)$ y $bold(v)$ en
   perifocal con la @m18-r y la @m18-v, y después se los gira a los ejes que
   uno quiera con los tres ángulos $i$, $Omega$, $omega$. Ese giro —tres
   matrices de rotación, una por ángulo— es el capítulo 4 de Curtis y la
   §2.6 del Bate, y es mecánico: no agrega ninguna idea nueva a lo de acá.

2. *Los seis números.* Es lo que hay que recordar del módulo aunque se olvide
   todo lo demás: una órbita son seis números, hay dos monedas para darlos, y
   la elección entre las dos depende de si se va a integrar (estado) o a
   entender y archivar (elementos).

3. *Los coeficientes de Lagrange*, en las dos versiones. La de $Delta nu$
   —@m18-fg-dnu y @m18-fgpunto-dnu— es exacta y sirve para cualquier cónica.
   La serie en $Delta t$ —@m18-serie— es aproximada y sólo para pasos cortos.
   Las dos vuelven a aparecer, además, en el problema de determinar una órbita
   a partir de dos posiciones y el tiempo entre ellas (el problema de Lambert,
   que es cómo se diseñan de verdad las transferencias interplanetarias del
   módulo 17 cuando la ventana no es la de Hohmann).

4. *El control $f dot(g) - dot(f) g = 1$.* Es gratis y atrapa cualquier error
   aritmético de la propagación. Vale la pena hacerlo siempre.

5. *La ecuación de Kepler*, que es lo único que falta para cerrar el problema
   de dos cuerpos completo, y que el módulo 19 tampoco va a dar: el módulo 19
   se ocupa de qué pasa cuando la aproximación de dos cuerpos deja de valer.
