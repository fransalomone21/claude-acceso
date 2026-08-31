#import "../plantilla.typ": *

#modulo("Propulsión: la ecuación del cohete")[
  Deducir el empuje de un motor a retropropulsión desde la conservación de la
  cantidad de movimiento, sin usar $bold(F) = m bold(a)$ donde no vale;
  escribir y resolver la ecuación de movimiento de un cohete que sube contra la
  gravedad; decidir si despega o no; calcular su velocidad final con la
  ecuación de Tsiolkovsky; y explicar —con números— por qué se usan etapas.
]

Este es el módulo que la cátedra pidió con más énfasis. Sobre la ecuación del
cohete escribió dos veces lo mismo: *«deducción de la fórmula»* y *«entender
esta ecuación»*. Y agregó, con cuatro signos de admiración, la advertencia que
más contradice a la intuición: *«¡el cohete puede comenzar con más peso que
empuje!»*.

Es también el primer sistema de la carrera cuya masa cambia mientras se mueve, y
por eso el primero donde la segunda ley, tal como se aprendió, no se puede
aplicar.

== Por qué acá no sirve $bold(F) = m bold(a)$

La tentación es escribir $bold(F) = d(m bold(v)) \/ d t = m bold(a) + dot(m) bold(v)$
y llamar $dot(m) bold(v)$ al empuje. *Está mal*, y conviene ver exactamente por
qué antes de hacer lo correcto.

#cuidado[
  $sum bold(F) = d bold(p) \/ d t$ vale para un *sistema cerrado*: un conjunto
  fijo de materia. El cohete —definido como «lo que todavía está adentro»— no
  lo es: pierde masa por la tobera. Cuando la masa que uno mira cambia, la
  derivada $d(m bold(v)) \/ d t$ mezcla dos cosas distintas: cuánto cambia la
  velocidad del sistema, y cuánta materia entró o salió del recuento. Sólo la
  primera es física.

  La prueba de que el término $dot(m) bold(v)$ está mal es que *depende del
  sistema de referencia*: cambiando $bold(v)$ por $bold(v) + bold(u)$ (otro
  observador inercial) el «empuje» cambiaría de valor. Un empuje que depende de
  quién lo mira no es un empuje.
]

El planteo correcto es el de siempre: se elige un sistema *cerrado* —el cohete
*más* el gas que va a expulsar— y se le aplica la conservación de la cantidad de
movimiento en un intervalo chico. Eso es lo que hace Roederer, §4-c, pág. 112.

== La deducción del empuje

#fig([Un intervalo $Delta t$ en la vida del cohete. Antes: una sola masa $M$ con
velocidad $bold(V)$. Después: un pedacito de gas $Delta m$ que sale con
velocidad $bold(v)$, y el resto, que quedó con $bold(V) + Delta bold(V)$. La
única cantidad que fija el motor es la velocidad *relativa*
$bold(v)_r = bold(v) - bold(V)$.], fig-cohete-elemento)

#deduccion("el empuje, desde la conservación de P")[
  *Antes* del intervalo, todo es una sola masa: $bold(P) = M bold(V)$.

  *Después*, hay dos pedazos: el gas $Delta m$ con velocidad $bold(v)$, y lo que
  quedó, $M - Delta m$, con velocidad $bold(V) + Delta bold(V)$:
  $ bold(P) = Delta m bold(v) + (M - Delta m)(bold(V) + Delta bold(V)) $
  El sistema es cerrado, así que los dos $bold(P)$ son iguales. Reemplazando
  $bold(v) = bold(v)_r + bold(V)$ y desarrollando:
  $ M bold(V) = Delta m bold(v)_r + M bold(V) + M Delta bold(V) - Delta m Delta bold(V) $
  El término $Delta m Delta bold(V)$ es un producto de dos cantidades chicas: es
  de segundo orden y se va al pasar al límite. Queda
  $ Delta bold(V) = - (Delta m) / M bold(v)_r $
  Dividiendo por $Delta t$ y tomando el límite, con
  $mu = d m \/ d t = - d M \/ d t$ el *caudal másico* (un número positivo, porque
  la masa del cohete disminuye):
  $ M bold(a) = bold(f) = - mu bold(v)_r $ <m4-empuje>
  Es la ec. (4.6) de Roederer, pág. 112.
]

#definicion("empuje")[
  $bold(f) = -mu bold(v)_r$ es la *fuerza de retropropulsión* o *empuje*. Su
  módulo es
  $ f = mu abs(bold(v)_r) $
  El signo menos dice lo único que hay que recordar de la dirección: *el empuje
  apunta al revés que el chorro*. Si el gas sale para atrás, el cohete se va
  para adelante.
]

#clave[
  En la @m4-empuje no aparece $bold(V)$ por ningún lado. Tres consecuencias, y
  las tres importan:

  1. *El empuje no depende de la velocidad del cohete.* Un cohete quieto y uno
     a 8 km/s con el mismo motor tienen el mismo empuje.
  2. *No depende del medio.* No hay contra qué empujar: el motor a
     retropropulsión es —dice Roederer, pág. 113— el único utilizable en el
     vacío, porque se trae su propio «medio» adentro.
  3. *Sólo dos números lo fijan*, y los dos los pone el motor: el caudal $mu$ y
     la velocidad de escape $abs(bold(v)_r)$.
]

=== Impulso específico

La cátedra listó el *impulso específico* con la aclaración de que va «en clase»:
no está ni en Roederer ni en S&Z. Es la forma en que la industria informa
$abs(bold(v)_r)$, dividida por $g_0 = 9,80665$ m/s²:

$ I_"sp" = abs(bold(v)_r) / g_0 quad ==> quad f = I_"sp" g_0 mu $

Se mide en *segundos*, y esa unidad rara tiene una lectura: es cuántos segundos
podría el motor sostener un empuje igual al peso terrestre de su propio
consumo. Sirve para comparar motores sin importar su tamaño — un químico ronda
los 300 s, uno iónico los 3000.

#notacion[
  S&Z llama $v_"esc"$ a lo que Roederer llama $abs(bold(v)_r)$ y Beer llama $u$;
  las tres son la misma velocidad de escape *relativa al cohete*. Y S&Z escribe
  el caudal como $-d m \/ d t$ (negativo, porque su $m$ es la del cohete), donde
  Roederer usa $mu > 0$. Cuidado con arrastrar el signo de un libro al otro: la
  ec. (8.38) de S&Z, pág. 259, es $F = -v_"esc" d m \/ d t$ y la (4.6) de
  Roederer es $f = -mu bold(v)_r$ — dicen lo mismo, con el menos en lugares
  distintos.
]

== Con gravedad: la ecuación de movimiento

Sumando las demás fuerzas exteriores $bold(f)_e$ (peso, resistencia del aire),
la @m4-empuje se convierte en la ecuación de movimiento del cohete (Roederer
ec. 4.7, pág. 113):

$ bold(a) = 1/M (d M)/(d t) bold(v)_r + bold(f)_e / M $ <m4-movimiento>

Para el caso que se usa siempre —ascenso vertical, $g$ constante, sin
resistencia, caudal constante— la masa es $M(t) = M_0 - mu t$ y queda una
ecuación escalar:

$ (d V)/(d t) = a = (mu abs(v_r)) / (M_0 - mu t) - g $ <m4-vertical>

#clave[
  *La aceleración crece con el tiempo aunque el empuje sea constante.* El
  numerador no cambia; el denominador sí, porque el cohete se está vaciando. Al
  final del quemado, con el tanque casi seco, la aceleración puede ser un orden
  de magnitud mayor que al despegar — y eso es lo que limita la estructura y a
  la tripulación, no el despegue.
]

#cuidado[
  *«¡El cohete puede comenzar con más peso que empuje!»* — textual de la
  cátedra, con los cuatro signos. La condición para despegar desde el reposo
  sale de pedir $a > 0$ en $t = 0$ en la @m4-vertical (Roederer, pág. 114):
  $ (mu abs(v_r)) / M_0 > g $
  Si no se cumple, el cohete *no arranca*. Pero —y esto es lo que la
  advertencia quiere decir— la condición puede fallar al principio y cumplirse
  después, porque $M_0 - mu t$ baja: un motor encendido con el vehículo
  todavía sujeto va aligerando hasta que el empuje gana. La desigualdad se
  evalúa en el instante que interesa, no una sola vez.
]

== La ecuación de Tsiolkovsky

#deduccion("integrar la ecuación del cohete")[
  La @m4-vertical se integra directo, porque el segundo miembro sólo depende de
  $t$:
  $ V(t) = V_0 + abs(v_r) integral_0^t (mu d t') / (M_0 - mu t') - g t
         = V_0 + abs(v_r) ln 1/(1 - mu t \/ M_0) - g t $
  La velocidad crece *logarítmicamente*: el último kilo de combustible aporta
  muchísimo menos que el primero, porque cuando se quema queda muy poca masa
  atrás para acelerar. Al agotarse el combustible ($t_f = m \/ mu$, con $m$ la
  masa total de combustible) se llega al máximo:
  $ V_f = V_0 + abs(v_r) ln (M_0) / (M_f) - g t_f $ <m4-tsiolkovsky>
  con $M_f = M_0 - m$. Es la ec. (4.8) de Roederer, pág. 114 — y la (8.40) de
  S&Z, pág. 260, que la escribe sin el término de gravedad porque plantea el
  cohete en el espacio libre.
]

#cuidado[
  *La ec. (4.8) tal como está impresa en Roederer, pág. 114, tiene una errata:
  le falta el factor $abs(v_r)$ delante del logaritmo.* El libro escribe
  $ V_f = V_0 + ln 1/(1 - m \/ M_0) - g m/mu quad "(así impreso, y está mal)" $
  Se ve sin hacer ninguna cuenta: el logaritmo es un número sin unidades, así
  que ese término no puede sumarse a una velocidad. Y la ecuación del renglón
  anterior —la de $V(t)$, en la misma página— sí lleva su $abs(v_r)$, igual que
  todas las de la pág. 115. *Es un error de imprenta, no de física.* La forma
  correcta es la @m4-tsiolkovsky.

  En la misma deducción, la pág. 115 arrastra un segundo desliz tipográfico: el
  paso intermedio del cohete de dos etapas suma dos veces $-g m \/ mu$, cuando
  las pérdidas de las dos etapas son $-g m_1 \/ mu$ y $-g m_2 \/ mu$, que juntas
  dan *una sola* vez $-g m \/ mu$. El resultado final que el libro escribe a la
  derecha del igual ya está bien.
]

#clave[
  De la @m4-tsiolkovsky se lee todo el diseño de un lanzador:

  - Lo que manda es la *razón de masas* $M_0 \/ M_f$, y entra por un logaritmo:
    para duplicar el aporte hay que *elevar al cuadrado* la razón. Por eso
    —observa Roederer— los cohetes grandes llevan cerca del $95%$ de su masa
    inicial en combustible.
  - El otro factor, $abs(v_r)$, entra *lineal*: mejorar el motor rinde mucho más
    que agrandar el tanque. Esa es la idea detrás de la propulsión iónica, que
    acepta un caudal ridículo a cambio de una velocidad de escape enorme.
  - El término $-g t_f$ es la *pérdida por gravedad*, y sólo depende de cuánto
    tarda el quemado. Un motor que entrega el mismo impulso total en menos
    tiempo pierde menos.
]

== Etapas

Roederer demuestra (pág. 114-115) que un cohete de dos etapas alcanza *siempre*
más velocidad final que uno de una sola etapa con el mismo peso total y el mismo
combustible. La razón es de una línea:

#clave[
  La masa muerta —tanques, estructura, motores ya apagados— se sigue acelerando
  hasta el final aunque ya no sirva para nada. Tirarla a mitad de camino mejora
  la razón $M_0 \/ M_f$ del tramo que queda, y es en esa razón donde vive el
  logaritmo.
]

#cuidado[
  La fórmula cerrada que Roederer obtiene para la ganancia
  ($abs(v_r) ln[1 \/ (1 - m_1 \/ M_0)]$) vale bajo *sus* hipótesis: que las dos
  etapas tengan el mismo $mu$, la misma $abs(v_r)$ y *la misma fracción de
  combustible sobre masa total*. Un cohete real lleva además una carga útil que
  no es combustible ni estructura de ninguna etapa, y eso rompe la última
  hipótesis. Lo que sobrevive es la conclusión, no el número: si hay carga útil,
  la ganancia se calcula tramo por tramo, como en el ejemplo a fondo de abajo.
]

#ejemplo("Aceleración al despegar y al apagarse")[
  _(Ej. 6 de la guía; Beer 14.94.)_ Un cohete de $1200$ kg, de los cuales
  $1000$ kg son combustible, lo consume a razón de $12,5$ kg/s y lo expulsa a
  $4000$ m/s relativos. Se lanza verticalmente desde el suelo. Determinar la
  aceleración *(a)* al ser lanzado y *(b)* al consumirse la última partícula de
  combustible.

  *El empuje, primero — es el mismo en los dos casos:*
  $ f = mu abs(v_r) = 12,5 dot 4000 = 50 000 " N" $

  *(a)* Al despegar, $M = 1200$ kg y el peso es
  $1200 dot 9,81 = 11 772$ N:
  $ a = (50 000 - 11 772) / (1200) = 31,9 " m/s"^2 $

  *(b)* Al final queda $M_f = 1200 - 1000 = 200$ kg, con peso $1962$ N:
  $ a = (50 000 - 1962) / (200) = 240 " m/s"^2 $

  *Ocho veces más*, con el mismo motor y sin tocar nada: es la @m4-vertical en
  acción. De paso, el control de despegue: $50 000 > 11 772$, así que este
  cohete sí arranca. Y $240$ m/s² son $24 g$ — un valor que ninguna estructura
  tripulada tolera, y la razón por la que un lanzador real *reduce* el empuje
  cerca del final en lugar de dejarlo constante.
]

#ejemplo("Una etapa contra dos, con los mismos kilos", nivel: "a fondo")[
  _(Ejercicios 7 y 8 de la guía; Beer 14.97 y 14.98.)_ Una nave de $540$ kg se
  monta sobre un cohete. En los dos casos $mu = 225$ kg/s y
  $abs(v_r) = 3600$ m/s, y el lanzamiento es vertical desde el suelo.

  #v(4pt)
  #fig-etapas
  #v(4pt)

  *(a)* Una sola etapa de $19$ Mg, que incluyen $17,8$ Mg de combustible.
  *(b)* Dos etapas $A$ y $B$ de $9,5$ Mg cada una, con $8,9$ Mg de combustible
  cada una; al agotarse $A$, su cubierta se desprende. Rapidez máxima que se le
  imparte a la nave en cada caso.

  #geometria[
    Antes de calcular, hay que ver que los dos casos son *comparables*: masa
    total $2 dot 9500 + 540 = 19540$ kg $= 19000 + 540$, y combustible
    $2 dot 8900 = 17800$ kg en los dos. Mismos kilos, mismo motor, mismo tiempo
    total de quemado. Si no fuera así, comparar las velocidades finales no
    diría nada sobre las etapas.
  ]

  *(a) Una etapa.* Masa inicial $M_0 = 19000 + 540 = 19540$ kg; final
  $M_f = 19540 - 17800 = 1740$ kg. Tiempo de quemado:
  $ t_f = (17 800) / (225) = 79,1 " s" $
  Con la @m4-tsiolkovsky y $V_0 = 0$:
  $ V_f = 3600 ln (19 540) / (1740) - 9,81 dot 79,1
        = 3600 dot 2,4186 - 776 = 8707 - 776 $
  $ V_f = 7,93 " km/s" $

  *(b) Dos etapas.* Se aplica la misma ecuación dos veces, y el truco está en
  llevar bien la cuenta de qué masa hay en cada tramo.

  _Tramo 1 — quema la etapa $A$._ Arranca con las dos etapas y la nave:
  $19540$ kg. Quema $8900$ kg, así que termina con $10 640$ kg. Tarda
  $t_1 = 8900 \/ 225 = 39,6$ s.
  $ V_1 = 3600 ln (19 540) / (10 640) - 9,81 dot 39,6 = 2188 - 388 = 1,80 " km/s" $

  _Se desprende la cubierta de $A$._ Pesaba $9500 - 8900 = 600$ kg. La masa cae
  de $10 640$ a $10 040$ kg *sin cambiar la velocidad*: soltar una masa que
  viaja con uno no impulsa nada.

  _Tramo 2 — quema la etapa $B$._ De $10 040$ kg a
  $10 040 - 8900 = 1140$ kg (los $600$ kg de cubierta de $B$ más los $540$ de la
  nave). Otra vez $t_2 = 39,6$ s, y ahora $V_0 = V_1$:
  $ V_f = 1800 + 3600 ln (10 040) / (1140) - 9,81 dot 39,6 = 1800 + 7832 - 388 $
  $ V_f = 9,24 " km/s" $

  *El resultado, y de dónde sale exactamente.* Las dos etapas ganan
  $9,24 - 7,93 = 1,31$ km/s: un $17%$ más de velocidad final con *los mismos
  kilos de combustible*. Y se puede ver de dónde sale cada mitad de la cuenta:

  #table(
    columns: (1fr, auto, auto),
    align: (left, center, center),
    table.header([], [*una etapa*], [*dos etapas*]),
    [razón de masas efectiva], [$11,23$], [$1,836 dot 8,807 = 16,17$],
    [aporte del logaritmo], [$8707$ m/s], [$10 020$ m/s],
    [pérdida por gravedad], [$-776$ m/s], [$-776$ m/s],
    [*velocidad final*], [$7,93$ km/s], [$9,24$ km/s],
  )

  *La pérdida por gravedad es idéntica en los dos casos* —los dos queman
  $79,1$ s en total—, así que la ganancia entera viene de la razón de masas: de
  $11,23$ a $16,17$. Y esa mejora es exactamente lo que se compró tirando
  $600$ kg de chapa vacía a mitad de camino.

  #clave[
    Es el argumento de Roederer con números: en una sola etapa, los $1200$ kg de
    estructura vacía se siguen acelerando hasta el último segundo. En dos, la
    mitad de esa chapa se abandona cuando todavía falta la mitad del impulso —
    y el logaritmo lo agradece.
  ]

  #cuidado[
    El error clásico en el tramo 2 es arrancar con $10 640$ kg (olvidar la
    cubierta) o con $9500 + 540 = 10 040$ kg (correcto) pero terminar en
    $540$ kg, olvidando que la cubierta de $B$ *no* se tira: no hay ninguna
    etapa más que soltar. Conviene escribir las cuatro masas —inicial y final
    de cada tramo— antes de tocar la calculadora, y controlar que la suma de
    todo lo que se fue ($17 800$ de combustible más $600$ de cubierta) más lo
    que queda ($1140$) dé la masa inicial: $17 800 + 600 + 1140 = 19 540$.
    #sym.checkmark
  ]
]

#guia("qué ejercicios cubre este módulo")[
  Los ejercicios *4 al 9* de la sección *Conservación de cantidad de
  movimiento*. El *6* y los *7–8* son los dos ejemplos de arriba. El *4* (la
  unidad de maniobras del astronauta, S&Z 8.61) es el empuje despejado al
  revés: de $a = 0,029$ m/s² y $M = 180$ kg sale $f = 5,22$ N, y de ahí
  $mu = f \/ abs(v_r) = 5,22 \/ 490 = 1,07 dot 10^(-2)$ kg/s, o sea $0,053$ kg
  en $5$ s. El *5* (S&Z 8.63) es la @m4-tsiolkovsky sin gravedad, despejando la
  razón de masas. El *9* (Beer 14.99) pide la *altura* del ejercicio 7: hay que
  integrar $V(t)$ otra vez, y ahí el logaritmo ya no se puede saltear.
]

== Lo que se usa después

1. *La @m4-tsiolkovsky.* En el módulo 11 es la que traduce cada maniobra —una
   transferencia de Hohmann, un cambio de plano— en kilos de combustible. El
   $Delta V$ que la mecánica orbital pide es exactamente el que esta ecuación
   cobra.

2. *El impulso específico.* Aparece en el ejercicio 1 de la sección de cuerpo
   rígido de la guía, donde un *thruster* de gas frío con $I_"sp" = 50$ s hace
   girar un satélite cúbico. Ahí el empuje no acelera: aplica una cupla.

3. *La idea de sistema cerrado.* Beer §14.12 trata la masa variable de la misma
   manera —la cátedra anotó al lado «ver Roederer, ecuación del cohete»—, y en
   el módulo 12 el mismo cuidado reaparece con otro disfraz: qué sistema de
   referencia se está usando cuando el que gira es el propio cuerpo.
