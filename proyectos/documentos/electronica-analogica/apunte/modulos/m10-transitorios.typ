#import "../plantilla.typ": *

#modulo("Capacitor, inductor y régimen transitorio", [
  Escribir las relaciones $v$–$i$ del capacitor y del inductor y saber *por qué* una
  tensión y una corriente no pueden saltar; dibujar la forma de onda de la tensión a
  partir de la de la corriente y al revés; hacer el balance de energía de un transitorio;
  usar las marcas de punto cuando dos bobinas están acopladas; encontrar las condiciones
  iniciales y finales de cualquier circuito conmutado; resolver de memoria todo circuito
  de primer orden con la fórmula de los tres datos; y clasificar la respuesta de un
  circuito de segundo orden en sobreamortiguada, crítica o subamortiguada sabiendo qué
  significa cada una en el osciloscopio.
])

Hasta acá todos los circuitos eran resistivos: la respuesta era instantánea y proporcional
a la excitación. El capacitor y el inductor rompen eso, porque *almacenan energía*, y la
energía almacenada no aparece ni desaparece de golpe. Ese es el origen de todo lo que
sigue: los transitorios, las constantes de tiempo, la respuesta en frecuencia y —al final
de la cadena— el filtrado.

Dicho de otra manera: un resistor *no tiene memoria*. Le llega una tensión y responde con
una corriente que depende sólo de lo que está pasando en ese instante. Un capacitor y un
inductor sí la tienen, porque su estado guarda lo que pasó antes. Todo el módulo es
aprender a leer esa memoria: cuál es la variable que la lleva, cómo se lee su valor, y
cuánto tarda en olvidarse.

== El capacitor

#definicion("Capacitor: relación constitutiva")[
  Un capacitor almacena carga proporcional a la tensión entre sus placas, $q = C v$.
  Derivando respecto del tiempo:
  $ i = C (dif v)/(dif t) quad quad "y su inversa" quad quad
    v(t) = v(t_0) + 1/C integral_(t_0)^t i(lambda) dif lambda $
  La capacidad $C$ se mide en farad $["F" = "C"\/"V"]$ —por Michael Faraday—, y la carga
  $q$ en coulomb, por Charles-Augustin de Coulomb. Las capacidades reales son de
  picofarad a milifarad: el farad es una unidad enorme.

  La $lambda$ de la integral es una *variable muda*: recorre el tiempo desde $t_0$ hasta
  $t$, y se escribe distinta de $t$ para no usar la misma letra como límite y como
  variable de integración.
]

De la relación sale todo lo demás:

- *En continua estacionaria*, $dif v \/ dif t = 0$, luego $i = 0$: *un capacitor en
  continua permanente es un circuito abierto*.
- *La tensión no puede saltar.* Un salto implicaría $dif v\/dif t$ infinita y por lo tanto
  corriente infinita. Como eso exigiría potencia infinita, no ocurre:
  $ v_C (0^+) = v_C (0^-) $ <ec-cont-vc>
- *La energía almacenada* sale de integrar la potencia:
  $ w_C = integral p dif t = integral v dot C (dif v)/(dif t) dif t
        = C integral_0^V v dif v = 1/2 C v^2 $ <ec-energia-c>
  Es energía *guardada en el campo eléctrico*, no disipada: el capacitor la devuelve.

=== Asociación

Como los capacitores en serie comparten la carga y en paralelo comparten la tensión, las
fórmulas salen *al revés* que las de los resistores:

$ 1/C_"serie" = sum_k 1/C_k quad quad quad C_"paralelo" = sum_k C_k $ <ec-asoc-c>

La deducción de las dos cabe en un renglón cada una, y conviene hacerla porque es la que
explica por qué van al revés:

- *En serie* circula la misma corriente por todos, así que todos acumulan la *misma
  carga* $q$. La tensión de cada uno es $v_k = q\/C_k$ y las tensiones se suman:
  $v = q sum 1\/C_k$, de donde $1\/C_"eq" = sum 1\/C_k$.
- *En paralelo* todos tienen la *misma tensión* $v$, y cada uno guarda $q_k = C_k v$. Las
  cargas se suman: $q = v sum C_k$, de donde $C_"eq" = sum C_k$.

#atencion[
  En un capacitor electrolítico, además del valor hay dos datos que matan si se ignoran:
  la *polaridad* (invertirla lo hace explotar) y la *tensión máxima de trabajo*, que
  debe superar cómodamente el pico —no el eficaz— de lo que va a soportar. En la fuente
  del Módulo 5, el capacitor de filtro ve el valor *pico* del secundario, no los volt
  eficaces que dice el transformador.

  Y en la asociación *en serie* hay una trampa que no está en la fórmula: la tensión se
  reparte *inversamente* con la capacidad, así que el capacitor más chico de la serie es
  el que más tensión soporta. Dos electrolíticos «iguales» en serie no reparten mitad y
  mitad, porque la tolerancia de un electrolítico es del orden del $20 %$.
]

== El inductor

#definicion("Inductor: relación constitutiva")[
  Un inductor concatena flujo magnético proporcional a la corriente, $phi = L i$. Por la
  ley de Faraday, la tensión inducida es la derivada del flujo:
  $ v = L (dif i)/(dif t) quad quad "y su inversa" quad quad
    i(t) = i(t_0) + 1/L integral_(t_0)^t v(lambda) dif lambda $
  La inductancia $L$ se mide en henry $["H" = "V" dot "s"\/"A"]$, por Joseph Henry, que
  llegó a la inducción al mismo tiempo que Faraday y del otro lado del Atlántico. La
  letra $L$ es por Heinrich Lenz, el de la ley del signo.
]

Todo es el dual exacto del capacitor:

- *En continua estacionaria*, $dif i\/dif t = 0$, luego $v = 0$: *un inductor en continua
  permanente es un cortocircuito*.
- *La corriente no puede saltar*:
  $ i_L (0^+) = i_L (0^-) $ <ec-cont-il>
- *Energía almacenada*, en el campo magnético:
  $ w_L = 1/2 L i^2 $ <ec-energia-l>
- *Asociación*: igual que los resistores, y por la misma razón —en serie circula la misma
  corriente y se suman las tensiones; en paralelo comparten la tensión y se suman las
  corrientes—.
  $ L_"serie" = sum_k L_k quad quad quad 1/L_"paralelo" = sum_k 1/L_k $ <ec-asoc-l>
  Con una condición que la fórmula no dice y que se trata más abajo: las bobinas tienen
  que estar *sin acoplar*. Si el campo de una atraviesa a la otra, la @ec-asoc-l no vale.

#clave[
  La consecuencia práctica de la @ec-cont-il es la razón por la que el diodo de rueda
  libre del Módulo 6 no es opcional. Al abrir la llave que alimenta un relé, la corriente
  del bobinado *tiene* que seguir circulando; si no encuentra camino, la única forma de
  cumplir $v = L thin dif i\/dif t$ con un $dif i$ enorme en un $dif t$ chiquísimo es
  generando cientos de volts, que perforan el transistor. El diodo le da el camino.

  Ese mismo fenómeno, buscado a propósito y no sufrido, es la bobina de encendido de un
  motor a explosión y el elevador de tensión de una fuente conmutada: se carga la bobina
  con corriente y se le corta el camino para cobrar la tensión.
]

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    table.header([], [*Capacitor*], [*Inductor*]),
    [Relación], [$i = C thin dif v\/dif t$], [$v = L thin dif i\/dif t$],
    [Variable de estado], [la *tensión* $v_C$], [la *corriente* $i_L$],
    [No puede saltar], [la *tensión*], [la *corriente*],
    [Sí puede saltar], [la corriente $i_C$], [la tensión $v_L$],
    [En continua permanente es], [circuito *abierto*], [*cortocircuito*],
    [Energía], [$1/2 C v^2$], [$1/2 L i^2$],
    [En serie], [$1\/C_"eq" = sum 1\/C_k$], [$L_"eq" = sum L_k$],
    [En paralelo], [$C_"eq" = sum C_k$], [$1\/L_"eq" = sum 1\/L_k$],
    [Constante de tiempo con $R$], [$tau = R C$], [$tau = L\/R$],
  ),
  caption: [Capacitor e inductor son duales término a término],
)

#clave[
  *La dualidad no es una curiosidad: es la mitad del trabajo ya hecho.* Cada resultado de
  este módulo vale dos veces. Se demuestra para uno de los dos y se traduce con el
  diccionario de la tabla ($v arrow.l.r i$, $C arrow.l.r L$, serie $arrow.l.r$ paralelo,
  abierto $arrow.l.r$ corto). Cuando aparezca una fórmula del inductor que no se recuerda,
  se busca la del capacitor y se traduce.
]

== Las relaciones $v$–$i$, vistas

Las dos relaciones constitutivas dicen *derivada* e *integral*, y eso en el papel se lee
rápido y en una forma de onda no se ve. La forma más barata de que se vea es imponer una
corriente conocida y dibujar todo lo demás. Es, además, el primer ejercicio de la guía de
la cátedra.

#circuito([Una bobina de 20 mH recorrida por un pulso triangular de corriente])[
#graf-pulso-en-bobina()
]

#ejercicio("La bobina y el pulso triangular")[
  Por una bobina de $L = 20$ mH se hace circular la corriente del gráfico: sube linealmente
  de $0$ a $2$ A en 2 ms, y después baja linealmente a $0$ en los 4 ms siguientes.

  *Tensión.* $v_L = L thin dif i \/ dif t$, y la derivada de una recta es su pendiente,
  que es *constante en cada tramo*:
  $ 0 < t < 2 "ms": quad (dif i)/(dif t) = (2 "A")/(2 "ms") = 1000 "A"\/"s"
    quad arrow.r quad v_L = "0,020" dot 1000 = 20 "V" $
  $ 2 < t < 6 "ms": quad (dif i)/(dif t) = (-2 "A")/(4 "ms") = -500 "A"\/"s"
    quad arrow.r quad v_L = "0,020" dot (-500) = -10 "V" $
  La tensión es *constante a tramos y salta* en cada quiebre: de $0$ a $20$ V en $t = 0$,
  de $20$ a $-10$ V en $t = 2$ ms. Eso no viola nada: lo que no puede saltar es $i_L$, y
  no salta.

  *Potencia.* $p = v_L thin i_L$, con la convención pasiva del principio del apunte.
  $ 0 < t < 2 "ms": quad p = 20 dot i quad arrow.r quad "de " 0 " a " 40 "W (positiva)" $
  $ 2 < t < 6 "ms": quad p = -10 dot i quad arrow.r quad "de −20 a 0 W (negativa)" $
  Positiva quiere decir que la bobina *absorbe*; negativa, que *entrega*. El cambio de
  signo cae exactamente en el pico de la corriente, que es donde la bobina deja de
  cargarse y empieza a devolver.

  *Energía.* $E_L = 1/2 L i^2$ depende sólo de la corriente en ese instante:
  $ E_L^max = 1/2 dot "0,020" dot 2^2 = "0,040" "J" = 40 "mJ" $
  y vuelve a cero al final, porque la corriente vuelve a cero. La bobina *no disipó nada*:
  guardó 40 mJ durante la subida y los devolvió durante la bajada. El área del primer
  tramo de la curva de potencia $(1/2 dot 40 "W" dot 2 "ms" = 40 "mJ")$ y la del segundo
  $(1/2 dot (-20) "W" dot 4 "ms" = -40 "mJ")$ son iguales y opuestas: ese es el control.

  *El control de lectura.* La tensión tiene que ser constante donde la corriente es una
  recta, y *cero* donde la corriente es constante. Si en la simulación aparece una tensión
  no nula sobre un tramo de corriente plana, el error está en el modelo de la fuente, no
  en la bobina.
]

El capacitor hace exactamente lo mismo con los papeles cambiados: se le impone una
corriente, y la tensión es su *integral* —el área acumulada—, no su derivada.

#circuito([Un capacitor de 0,25 µF excitado por un pulso de corriente])[
#graf-pulso-en-capacitor()
]

#clave[
  *El tramo del medio es el que enseña.* Entre 2 y 4 ms la corriente vale cero y la
  tensión *no vuelve a cero*: se queda en los 4 V que había acumulado. Ahí se ve la
  memoria. Con $i_C = 0$ la pendiente $dif v_C\/dif t$ es cero, y una pendiente nula no
  dice «sin tensión», dice «sin cambio de tensión».

  La pendiente de $v_C$ es $i_C \/ C$: con $i_C = "0,5"$ mA y $C = "0,25"$ µF da
  $2$ V/ms, que es lo que se mide en el gráfico. Y como toda integral, $v_C$ *no salta*
  ni siquiera cuando la corriente sí lo hace.
]

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([], [*Si se impone $i$…*], [*Si se impone $v$…*]),
    [En una *bobina*],
      [$v_L$ es la *pendiente* de $i$: constante a tramos, y salta en cada quiebre],
      [$i_L$ es el *área* acumulada de $v$: continua siempre, cambia de pendiente en cada
       quiebre],
    [En un *capacitor*],
      [$v_C$ es el *área* acumulada de $i$: continua siempre, cambia de pendiente en cada
       quiebre],
      [$i_C$ es la *pendiente* de $v$: constante a tramos, y salta en cada quiebre],
  ),
  caption: [Las cuatro lecturas que hay que poder hacer de un vistazo],
)

== Energía: quién la guarda y quién la quema

En un circuito con $R$, $L$ y $C$ hay dos clases de elementos y hay que separarlas antes
de hacer cualquier balance.

#definicion("Los dos destinos de la energía")[
  *El resistor disipa.* $p_R = R i^2 >= 0$ siempre: nunca devuelve. La energía que le
  entra se va en calor y no vuelve al circuito.

  *El capacitor y el inductor guardan.* $p$ cambia de signo: positiva mientras se cargan,
  negativa mientras se descargan. La energía queda en el campo ($1/2 C v^2$ en el
  eléctrico, $1/2 L i^2$ en el magnético) y sale entera si el elemento es ideal.

  *El balance.* En una red pasiva que arranca con energía almacenada y termina en reposo,
  toda la energía inicial *tiene* que aparecer disipada en los resistores:
  $ integral_0^infinity p_R (t) dif t = w_L (0) + w_C (0) $ <ec-balance>
  Es la única forma de cerrar la cuenta, y es el control más fuerte que hay sobre un
  transitorio: no depende de haber resuelto bien la ecuación diferencial.
]

#atencion[
  *La energía va con el cuadrado, y por eso decae al doble de velocidad.* Si la corriente
  de una descarga vale $i(t) = I_0 e^(-t\/tau)$, la energía almacenada es
  $ w_L (t) = 1/2 L i^2 = w_L (0) thin e^(-2 t \/ tau) $ <ec-energia-exp>
  con un $2$ en el exponente. La consecuencia práctica es que *el porcentaje de energía y
  el porcentaje de corriente no se alcanzan en el mismo instante*, y confundirlos es el
  error que la guía de la cátedra marca en tres problemas distintos.

  A $1 tau$ queda el $"36,8" %$ de la corriente pero sólo el $"13,5" %$ de la energía. Y
  para disipar una fracción $f$ de la energía inicial hace falta
  $ t = tau/2 ln 1/(1 - f) $
  que da $"0,80" tau$ para el $80 %$ y $"1,50" tau$ para el $95 %$.
]

#circuito([La corriente, la energía almacenada y la energía ya disipada, en una descarga])[
#graf-energia-descarga()
]

#ejercicio("Balance de energía de una descarga RL")[
  Una bobina de $L = 100$ mH quedó con $I_0 = "0,5"$ A y se descarga sobre
  $R = 8 thin Omega$. Se pide la energía total entregada al resistor y cuántas constantes
  de tiempo hacen falta para transferirle el $95 %$.

  *La constante de tiempo* y la corriente:
  $ tau = L/R = ("0,100")/(8) = "12,5" "ms" quad arrow.r quad
    i(t) = "0,5" thin e^(-t\/"12,5 ms") quad ["A"] $

  *La energía inicial*, que es toda la que hay en el circuito:
  $ w_L (0) = 1/2 L I_0^2 = 1/2 dot "0,100" dot "0,25" = "12,5" "mJ" $

  *La energía disipada*, por integración directa, sin usar la @ec-balance:
  $ integral_0^infinity R i^2 dif t = R I_0^2 integral_0^infinity e^(-2t\/tau) dif t
    = R I_0^2 dot tau/2 = 8 dot "0,25" dot ("0,0125")/(2) = "12,5" "mJ" $
  Coincide con la energía inicial, como tenía que pasar. Nótese que la cuenta no dependió
  de $R$ ni de $L$ por separado: el $R I_0^2 tau\/2$ se simplifica en $1/2 L I_0^2$
  cualquiera sea el valor de los dos.

  *El $95 %$.* La energía que *todavía queda* decae como $e^(-2t\/tau)$, así que
  $ e^(-2t\/tau) = "0,05" quad arrow.r quad t = tau/2 ln 20 = "1,50" tau = "18,7" "ms" $
  Es decir: *una constante y media*, no tres. Si uno se guía por la corriente, que a
  $"1,50" tau$ todavía vale el $22 %$ de $I_0$, la descarga parece lejos de terminada, y
  sin embargo el $95 %$ del calor ya se generó.
]

#clave[
  *Energía atrapada.* Hay circuitos donde el balance de la @ec-balance no cierra, y no es
  un error de cuentas: cuando dos capacitores quedan aislados del resto por una
  conmutación, la carga se reparte entre ellos y ahí se queda para siempre. El transitorio
  terminó, no circula más corriente, y sigue habiendo energía guardada.

  Se la llama *energía atrapada*, y el balance correcto es
  $ w(0) = integral_0^infinity p_R dif t + w_"atrapada" $
  Aparece siempre que un lazo de sólo capacitores, o un nodo de sólo inductores, queda
  desconectado de las fuentes. Antes de declarar «no cierra», hay que buscarla.
]

== Cuando dos bobinas se acoplan: la inductancia mutua

La @ec-asoc-l pide que las bobinas estén *sin acoplar*. Cuando el campo de una atraviesa
las espiras de la otra, aparece un término nuevo, y es el que explica el transformador
del Módulo 3 desde adentro.

#circuito([Dos bobinas acopladas, con sus marcas de punto])[
#fig-induccion-mutua()
]

#definicion("Inductancia mutua")[
  Si una corriente variable $i_1$ en la primera bobina induce tensión en la segunda, esa
  tensión es proporcional a la *rapidez* con que cambia $i_1$:
  $ v_2 = plus.minus M (dif i_1)/(dif t) quad quad quad
    v_1 = plus.minus M (dif i_2)/(dif t) $ <ec-mutua>
  El coeficiente $M$ es la *inductancia mutua*, se mide en henry como $L$, y es el mismo
  en los dos sentidos —resultado nada obvio que sale de la conservación de la energía—.
  Depende de la geometría, de la orientación relativa y del material que las une.

  El acoplamiento se mide con un número adimensional, el *coeficiente de acoplamiento*:
  $ k = M/sqrt(L_1 L_2), quad quad 0 <= k <= 1 $ <ec-acople>
  $k = 0$ es sin acoplar, $k = 1$ es acoplamiento perfecto —todo el flujo de una pasa por
  la otra—. Un transformador con núcleo de hierro llega a $k > "0,98"$; dos bobinas al
  aire, a $k$ de unas centésimas. La cota $|M| <= sqrt(L_1 L_2)$ no es un dato empírico:
  sale de exigir que la energía almacenada no pueda ser negativa.
]

#definicion("La convención de puntos")[
  El signo de la @ec-mutua no se puede leer del dibujo de las espiras, porque el sentido
  de bobinado casi nunca se dibuja. Se marca con un *punto* en un terminal de cada bobina,
  y la regla es una sola:

  - Si las *dos* corrientes entran por el terminal punteado, o las dos salen por él, el
    término mutuo lleva *el mismo signo* que el propio.
  - Si una entra por el punto y la otra sale, el término mutuo lleva *signo cambiado*.

  Con las dos corrientes entrando por punto, la tensión total de cada bobina es
  $ v_1 = L_1 (dif i_1)/(dif t) + M (dif i_2)/(dif t) quad quad
    v_2 = L_2 (dif i_2)/(dif t) + M (dif i_1)/(dif t) $
  El procedimiento no cambia nunca: primero se eligen y se dibujan las referencias de
  corriente y tensión, después se leen los puntos, y recién entonces se escriben las LKT.
  Elegir las referencias mirando el resultado que uno espera es la forma más rápida de
  equivocarse de signo.
]

#clave[
  *Dos bobinas acopladas en serie no suman.* Si el acoplamiento es *aditivo* —las dos
  corrientes entran por punto— la inductancia equivalente es
  $ L_"eq" = L_1 + L_2 + 2M $ <ec-leq-acoplada>
  y si es *sustractivo*, $L_"eq" = L_1 + L_2 - 2M$. Los dos valores se pueden medir con un
  inductómetro, y su diferencia da $M$ directamente:
  $ M = (L_"aditiva" - L_"sustractiva")/(4) $
  Es la forma estándar de medir $M$ en el laboratorio, y también la forma de descubrir
  que dos bobinas que uno creía independientes están acopladas: si al invertir una de las
  dos el valor medido cambia, hay $M$.
]

#clave[
  *Dónde estaba esto.* El transformador del Módulo 3 se explicó con la relación de
  transformación $V_1\/V_2 = N_1\/N_2$, que es el caso límite de la @ec-mutua con
  $k arrow.r 1$ y un núcleo ideal. Los *bornes homólogos* que allá se nombraron son
  exactamente estos puntos, y la razón por la que en el transformador con punto medio del
  rectificador de onda completa importa cuál extremo se conecta a cada diodo es esta regla
  de signo, no una convención de fábrica.
]

== Condiciones iniciales: cómo se leen

Todo problema de transitorios se reduce a contestar tres preguntas. Las dos primeras se
contestan con circuitos *resistivos*, que ya se saben resolver.

#definicion("El estado en tres instantes")[
  *En $t = 0^-$* (justo antes de conmutar, con el circuito en régimen desde hace mucho):
  se reemplaza cada capacitor por un *circuito abierto* y cada inductor por un
  *cortocircuito*, y se resuelve el circuito resistivo que queda. De ahí salen
  $v_C (0^-)$ e $i_L (0^-)$.

  *En $t = 0^+$* (justo después de conmutar): por continuidad, $v_C (0^+) = v_C (0^-)$ e
  $i_L (0^+) = i_L (0^-)$. Se reemplaza cada capacitor por una *fuente de tensión* de ese
  valor y cada inductor por una *fuente de corriente* de ese valor, y se resuelve el
  circuito resistivo con la topología *nueva*. De ahí sale cualquier otra variable en
  $0^+$ —que sí puede saltar, y de hecho salta.

  *En $t arrow.r infinity$* (régimen nuevo): otra vez capacitores abiertos e inductores en
  corto, con la topología nueva.
]

#circuito([El mismo circuito, con lo que se dibuja en cada uno de los tres instantes])[
#fig-tres-instantes()
]

#atencion[
  Lo único que se conserva a través de la conmutación es $v_C$ e $i_L$. *Todo lo demás
  salta*: la corriente por el capacitor, la tensión sobre el inductor, la corriente de
  cualquier resistor. Escribir "$i_R (0^+) = i_R (0^-)$" es el error clásico y no tiene
  ningún fundamento.

  Y el modelo de continua —capacitor abierto, inductor en corto— vale en $0^-$ y en
  $infinity$, *nunca durante el transitorio*. Usarlo en el medio es el segundo error
  clásico: da un resultado con las unidades bien y el valor equivocado, que es el peor
  tipo de resultado.
]

#ejercicio("Qué salta y qué no")[
  En el circuito de la figura anterior, con $V = 100$ V, $R_1 = 10 thin "k"Omega$,
  $R_2 = 40 thin "k"Omega$ y $C = "0,1"$ µF, la llave de la rama de $R_2$ *se cierra* en
  $t = 0$. Se pide $v_C$ e $i_(R 1)$ en $0^-$, en $0^+$ y en $infinity$.

  *En $0^-$.* La llave está abierta, así que por $R_2$ no circula nada; y el capacitor,
  en régimen, es un abierto, así que por $R_1$ tampoco. Sin corriente no hay caída en
  $R_1$:
  $ v_C (0^-) = 100 "V", quad quad i_(R 1)(0^-) = 0 $

  *En $0^+$.* La tensión del capacitor no salta, así que se lo reemplaza por una fuente de
  100 V y se resuelve el resistivo con la llave ya cerrada:
  $ v_C (0^+) = 100 "V", quad quad
    i_(R 1)(0^+) = (100 - 100)/(10 "k"Omega) = 0 $
  y la corriente por $R_2$, que en $0^-$ era cero, salta a $100\/40 "k"Omega = "2,5"$ mA.
  Toda esa corriente sale del capacitor: $i_C (0^+) = -"2,5"$ mA. La corriente del
  capacitor saltó de $0$ a $-"2,5"$ mA sin que la tensión se moviera un volt.

  *En $infinity$.* Capacitor abierto otra vez, con la llave cerrada: queda un divisor.
  $ v_C (infinity) = 100 dot (40)/(10 + 40) = 80 "V", quad quad
    i_(R 1)(infinity) = (100 - 80)/(10 "k"Omega) = 2 "mA" $

  *La lectura.* La variable de estado se movió despacio, de 100 a 80 V; las otras dos
  saltaron en el instante cero. Ese es el patrón de todo circuito conmutado, y es lo que
  hay que buscar en la pantalla del osciloscopio para saber si lo que se está mirando es
  lo que se calculó.
]

== Circuitos de primer orden

Un circuito con *un solo* elemento almacenador (o varios reducibles a uno) da una ecuación
diferencial de primer orden. Todos tienen la misma solución, y por eso conviene deducirla
una sola vez.

=== Respuesta natural del RC

Capacitor cargado a $V_0$, que se descarga sobre $R$ a partir de $t = 0$. LKC en el nodo:

$ C (dif v)/(dif t) + v/R = 0 quad arrow.r quad (dif v)/(dif t) = - v/(R C) $ <ec-ed-rc>

Separando variables e integrando:

$ integral_(V_0)^(v) (dif v)/v = - 1/(R C) integral_0^t dif t
  quad arrow.r quad ln v/(V_0) = - t/(R C) $

$ v(t) = V_0 e^(-t\/R C) = V_0 e^(-t\/tau), quad quad tau = R C $ <ec-natural-rc>

=== Respuesta natural del RL

El mismo camino, con LKT sobre la malla $R$–$L$:

$ L (dif i)/(dif t) + R i = 0 quad arrow.r quad
  i(t) = I_0 e^(-t\/tau), quad quad tau = L/R $ <ec-natural-rl>

#clave[
  *Se llama respuesta natural porque no hay ninguna fuente encendida.* Lo único que la
  produce es la energía que el elemento ya tenía guardada, y su forma —una exponencial
  decreciente— la fija el circuito, no la excitación. Por eso también se la llama
  *respuesta a entrada cero*, y por eso el exponente $-1\/tau$ es una propiedad del
  circuito: aparece igual cualquiera sea la manera de haberlo cargado.
]

=== Qué significa $tau$

#definicion("Constante de tiempo")[
  $tau$ es el tiempo en el que la respuesta cae al $e^(-1) = "36,8" %$ de su valor
  inicial. Geométricamente, es el tiempo que tardaría la respuesta en llegar a cero *si
  siguiera con la pendiente que tiene en el origen*.

  Se mide en segundos, y hay que verificarlo: $R C$ es $["V"\/"A"] dot ["A" dot
  "s"\/"V"] = ["s"]$, y $L\/R$ es $["V" dot "s"\/"A"] dot ["A"\/"V"] = ["s"]$. El número
  $e = "2,71828"…$ es el de Euler, y aparece acá por una sola razón: es la única función
  que es su propia derivada, que es exactamente lo que pide la @ec-ed-rc.
]

#circuito([La exponencial, normalizada, en las dos direcciones])[
#graf-tau-exponencial()
]

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center, center, center),
    table.header([*$t$*], [*Queda del salto ($e^(-t\/tau)$)*], [*Se completó*]),
    [$0$],      [100 %],  [0 %],
    [$1 tau$],  [36,8 %], [63,2 %],
    [$2 tau$],  [13,5 %], [86,5 %],
    [$3 tau$],  [5,0 %],  [95,0 %],
    [$4 tau$],  [1,8 %],  [98,2 %],
    [$5 tau$],  [0,7 %],  [99,3 %],
  ),
  caption: [La exponencial, en números],
)

#clave[
  *Regla de los cinco tau*: a los $5 tau$ el transitorio terminó a todos los efectos
  prácticos (queda menos del 1 %). Es el número que se usa para decidir cuánto esperar
  antes de medir, cuánto dura el arranque de una fuente, o a qué frecuencia máxima puede
  conmutar un circuito.
]

=== La fórmula general: el método de los tres datos

Cuando además hay una fuente, la solución es la natural más la forzada. No hace falta
volver a integrar: toda variable $x$ de un circuito de primer orden cumple

$ x(t) = x(infinity) + [x(0^+) - x(infinity)] e^(-t\/tau) $ <ec-tres-datos>

Se lee directo: *arranca en $x(0^+)$, termina en $x(infinity)$, y va de uno a otro
exponencialmente con constante $tau$*. Para usarla hacen falta exactamente tres números.

#clave[
  Y el tercero sale del Módulo 9: $tau = R_"th" C$ o $tau = L\/R_"th"$, donde $R_"th"$ es la
  *resistencia de Thévenin vista desde los bornes del elemento almacenador*, con la
  topología posterior a la conmutación y las fuentes independientes anuladas. Ese es el
  puente entre los dos módulos, y es lo que hace que el método sea mecánico.
]

=== Cómo se saca $R_"th"$ sin equivocarse

Es el paso donde se pierde la mitad de los ejercicios, y tiene un procedimiento fijo.

#definicion("Los cuatro pasos de la resistencia equivalente")[
  + *Retirar* el elemento almacenador y mirar hacia el resto del circuito desde sus dos
    bornes. No desde la fuente ni desde la carga: desde donde estaba el $C$ o la $L$.
  + *Anular las fuentes independientes*: cada fuente de tensión se reemplaza por un
    cortocircuito, cada fuente de corriente por un circuito abierto.
  + *Dejar activas las fuentes dependientes.* Una fuente controlada no es una fuente de
    energía autónoma: es parte del comportamiento de la red, y anularla cambia el
    circuito.
  + *Asociar* serie y paralelo hasta un solo valor. Si hay fuentes dependientes, la
    asociación no alcanza y hay que aplicar una fuente de prueba.
]

#circuito([La fuente de prueba: el único método que sigue valiendo con fuentes dependientes])[
#fig-req-prueba()
]

Se conecta entre los bornes una fuente de valor conocido —una de 1 V es la más cómoda—, se
calcula la corriente que entrega, y el cociente es la resistencia buscada:

$ R_"eq" = v_"pr"/i_"pr" $ <ec-req-prueba>

Da igual usar una fuente de tensión y medir la corriente, o una de corriente y medir la
tensión: el cociente es el mismo. El subíndice «pr» es por *prueba*, y la fuente no forma
parte del circuito: se pone, se calcula y se saca.

#circuito([Circuito RC de primer orden con fuente])[
#fig-rc-primer-orden()
]

#ejercicio("RC con fuente, por el método de los tres datos")[
  La llave se cierra en $t = 0$ con el capacitor descargado. $V = 20$ V,
  $R_1 = 5 "k"Omega$, $R_2 = 20 "k"Omega$, $C = 2 mu F$.

  *Dato 1 — $v_C (0^+)$.* El capacitor estaba descargado y la tensión no salta:
  $ v_C (0^+) = v_C (0^-) = 0 "V" $

  *Dato 2 — $v_C (infinity)$.* En régimen, el capacitor es un circuito abierto y queda un
  divisor:
  $ v_C (infinity) = 20 "V" dot (20)/(5 + 20) = 16 "V" $

  *Dato 3 — $tau$.* Se anula la fuente (corto) y se mira desde los bornes del capacitor:
  $R_1$ y $R_2$ quedan en paralelo.
  $ R_"th" = (5 dot 20)/(25) = 4 "k"Omega quad arrow.r quad
    tau = R_"th" C = 4 dot 10^3 dot 2 dot 10^(-6) = 8 "ms" $

  *Armar la respuesta* con la @ec-tres-datos:
  $ v_C (t) = 16 + (0 - 16) e^(-t\/8"ms") = 16 (1 - e^(-t\/8"ms")) quad ["V"] $

  *Leerla.* A los 8 ms el capacitor está en $16 dot "0,632" = "10,1"$ V. A los 40 ms
  ($5 tau$), en 15,9 V: terminó.

  *Una variable que sí salta.* La corriente por $R_1$ en $0^+$: con el capacitor
  reemplazado por una fuente de 0 V (un corto), $R_1$ ve los 20 V contra el paralelo de
  $R_2$ con ese corto, es decir contra 0:
  $ i_(R 1)(0^+) = (20 "V")/(5 "k"Omega) = 4 "mA" $
  mientras que en régimen vale $20\/25 = "0,8"$ mA. Saltó de 0 a 4 mA en el instante de
  cerrar la llave, y de ahí baja. Eso es la *corriente de irrupción*, y es la que hace
  que la protección de una fuente tenga que tolerar mucho más que la corriente nominal.

  *Y si después se abre la llave*: el capacitor queda solo con $R_2$, entonces
  $tau' = 20 "k"Omega dot 2 mu F = 40$ ms, y descarga desde 16 V hasta 0 según
  $v_C = 16 e^(-t\/40"ms")$. La misma fórmula, otros tres datos.
]

#circuito([El dual: un RL de primer orden con la misma llave])[
#fig-rl-primer-orden()
]

#ejercicio("RL con escalón: el mismo método, la otra variable")[
  La llave se cierra en $t = 0$ con la bobina descargada. $V = 24$ V, $R = 12 thin Omega$,
  $L = 60$ mH. Se piden $i_L (t)$ y $v_L (t)$.

  *Dato 1.* La corriente de la bobina no salta y valía cero: $i_L (0^+) = 0$.

  *Dato 2.* En régimen la bobina es un cortocircuito, y toda la tensión cae en $R$:
  $ i_L (infinity) = V/R = (24)/(12) = 2 "A" $

  *Dato 3.* Anulada la fuente, desde los bornes de la bobina se ve sólo $R$:
  $ tau = L/R_"th" = ("0,060")/(12) = 5 "ms" $

  *La respuesta*, con la @ec-tres-datos:
  $ i_L (t) = 2 + (0 - 2) e^(-t\/5"ms") = 2 (1 - e^(-t\/5"ms")) quad ["A"] $
  $ v_L (t) = L (dif i_L)/(dif t) = "0,060" dot 2 dot (1)/("0,005") e^(-t\/5"ms")
    = 24 thin e^(-t\/5"ms") quad ["V"] $

  *Los dos controles.* En $t = 0^+$ la corriente vale cero y toda la tensión de la fuente
  está sobre la bobina: $v_L (0^+) = 24$ V, que es lo que da la fórmula. En $t = infinity$
  pasa lo contrario: la corriente es máxima y la tensión de la bobina es cero. Y a
  $1 tau = 5$ ms la corriente vale $2 dot "0,632" = "1,264"$ A —el $"63,2" %$ del salto,
  como en cualquier primer orden—.

  *La comparación con el RC.* La bobina y el capacitor hacen lo mismo con las variables
  cambiadas: allá la *tensión* del capacitor arranca en cero y sube; acá es la *corriente*
  de la bobina. Y $tau$ va al revés: subir $R$ hace *más lento* al RC y *más rápido* al
  RL.
]

=== Entrada cero y estado cero: la otra forma de partir el problema

La @ec-tres-datos parte el problema por *instantes* —dónde arranca, dónde termina—. Hay
otra partición, que parte por *causas*, y es la que hace falta para entender el Módulo 12.

#definicion("Las dos respuestas")[
  Como el circuito es lineal, vale superposición, y las causas son dos: la energía
  almacenada y las fuentes. Se resuelve una vez con cada una y se suman.

  - *Respuesta a entrada cero* ($x_"ec"$): se apagan las fuentes y responde sólo la
    energía inicial. Es la respuesta natural.
  - *Respuesta a estado cero* ($x_"e0"$): se ponen las condiciones iniciales en cero y
    responde sólo la excitación.

  $ x(t) = x_"ec" (t) + x_"e0" (t) $ <ec-cero-cero>
]

#circuito([Las dos mitades y su suma, en un RC que arranca en 8 V y termina en 2 V])[
#graf-respuesta-completa()
]

#ejercicio("Un transitorio sin escribir la ecuación diferencial")[
  Un capacitor de $4$ µF tiene $8$ V justo antes de conmutar. Para $t > 0$ ve una red que,
  vista desde sus bornes, equivale a un Thévenin de $2$ V con $R_"th" = 25 thin "k"Omega$.
  Se piden $v_C (t)$ y $v_C ("0,1" "s")$.

  *Por los tres datos.* $v_C (0^+) = 8$ V por continuidad; $v_C (infinity) = 2$ V, que es
  la tensión de la fuente de Thévenin porque en régimen no circula corriente y no hay
  caída en $R_"th"$; y
  $ tau = R_"th" C = 25 dot 10^3 dot 4 dot 10^(-6) = "0,1" "s" $
  $ v_C (t) = 2 + (8 - 2) e^(-t\/"0,1") = 2 + 6 thin e^(-t\/"0,1") quad ["V"] $
  $ v_C ("0,1" "s") = 2 + 6 dot "0,368" = "4,21" "V" $

  *Por entrada cero y estado cero*, para ver que da lo mismo:
  $ v_"ec" = 8 thin e^(-t\/"0,1") quad quad
    v_"e0" = 2(1 - e^(-t\/"0,1")) $
  $ v_"ec" + v_"e0" = 8 e^(-t\/tau) + 2 - 2 e^(-t\/tau) = 2 + 6 e^(-t\/tau) quad
    checkmark $

  *Cuál conviene.* Para un problema de conmutación, los tres datos: son tres cuentas de
  circuito resistivo y no hay que resolver nada dos veces. La partición en entrada cero
  y estado cero conviene cuando la excitación *no* es constante —un pulso, una rampa, una
  senoidal— porque ahí el «valor final» no existe y la @ec-tres-datos no se puede aplicar.
]

#atencion[
  *Los cinco errores de primer orden*, en el orden en que aparecen:

  + Usar $x(0^-)$ como si fuera el valor final. Son los dos extremos del transitorio, no
    el mismo número.
  + Calcular $R_"th"$ sin anular bien las fuentes, o anulando también las dependientes.
  + Aplicar el modelo de continua —capacitor abierto, inductor en corto— *durante* el
    transitorio.
  + Olvidar el signo de $[x(0^+) - x(infinity)]$. Si el valor final es *menor* que el
    inicial, ese corchete es negativo y la exponencial baja; escribirlo al revés da una
    curva que sube y se va del gráfico.
  + Confundir $tau$ con el tiempo total de establecimiento. $tau$ es *una* constante; el
    transitorio dura unos $5 tau$.
]

#laboratorio[
  *Medir $tau$ en el osciloscopio, sin fórmulas.* Se excita la serie $R$–$C$ con una onda
  cuadrada de un generador, de período mucho mayor que $5 tau$ para que cada flanco sea un
  escalón completo. En la pantalla, cada semiciclo dibuja la @ec-tres-datos.

  + Medir la amplitud total del salto, $Delta$.
  + Buscar el instante en que la curva llegó al $"63,2" %$ del salto en la subida, o al
    $"36,8" %$ del valor inicial en la bajada. Ese tiempo *es* $tau$.
  + Contrastar con $R C$ medido con el multímetro. Una diferencia del orden del $10 %$ es
    normal (tolerancia del capacitor); una del $50 %$ es un error de medición o un
    componente mal identificado.
  + Despejar el valor que no se conoce: $C = tau\/R$ es la forma más práctica de medir un
    capacitor sin capacímetro.

  *Dos cuidados.* La punta del osciloscopio agrega su propia capacidad —del orden de
  100 pF, más el cable— y su resistencia de entrada de 1 MΩ queda en paralelo con el
  circuito: en un RC de valores altos, el instrumento cambia lo que está midiendo. Y la
  resistencia de salida del generador (típicamente 50 Ω) se suma a $R$: en un RC de pocos
  ohm, hay que contarla.
]

== Circuitos de segundo orden

Con *dos* elementos almacenadores que no se pueden reducir a uno (típicamente una $L$ y
una $C$) la ecuación es de segundo orden y aparece algo nuevo: la posibilidad de que el
circuito *oscile*.

La razón física es que ahora hay dos depósitos de energía que pueden intercambiársela: la
bobina le pasa la suya al capacitor, el capacitor se la devuelve, y el resistor le saca un
poco en cada vuelta. Si el resistor saca poco, el intercambio dura muchas vueltas y se ve
una oscilación; si saca mucho, no llega a haber ni una vuelta completa.

=== La ecuación

#circuito([RLC serie conmutado: el circuito de segundo orden del módulo])[
#fig-rlc-serie-conmutado()
]

Para el RLC serie, LKT sobre la malla con $v_C$ como incógnita, usando $i = C thin dif v_C\/dif t$:

$ L C (dif^2 v_C)/(dif t^2) + R C (dif v_C)/(dif t) + v_C = V $

Dividiendo por $L C$ y ordenando en la forma canónica:

$ (dif^2 v_C)/(dif t^2) + 2 alpha (dif v_C)/(dif t) + omega_0^2 v_C = omega_0^2 V $ <ec-ed-rlc>

#definicion("Los dos parámetros que gobiernan todo")[
  $ omega_0 = 1/sqrt(L C) quad ["rad"\/"s"] quad quad "frecuencia natural no amortiguada" $
  $ alpha = R/(2L) quad ["s"^(-1)] quad quad "coeficiente de amortiguamiento (serie)" $ <ec-alfa-serie>

  $omega_0$ es la pulsación a la que el circuito oscilaría *si no hubiera resistencia*, y
  no depende de $R$: es el intercambio puro entre $L$ y $C$. $alpha$ mide con qué rapidez
  se apaga esa oscilación, y su unidad, $"s"^(-1)$, se llama *neper por segundo*, por John
  Napier, el de los logaritmos: es el mismo neper de la atenuación.

  El cociente $zeta = alpha \/ omega_0$ es el *factor de amortiguamiento*, adimensional, y
  es el único número que decide la forma de la respuesta. Su inverso, hasta un factor 2,
  es el *factor de mérito*: $Q = omega_0 \/ (2 alpha) = 1\/(2 zeta)$. La letra $zeta$ es
  la zeta griega, y la $Q$ es por *quality*.
]

Las raíces de la ecuación característica $s^2 + 2 alpha s + omega_0^2 = 0$ son

$ s_(1,2) = - alpha plus.minus sqrt(alpha^2 - omega_0^2) $ <ec-raices>

y el signo de lo que hay bajo la raíz define los tres casos. La variable $s$ es la
*frecuencia compleja*, y se mide también en $"s"^(-1)$: su parte real es la velocidad a la
que decae el modo, y su parte imaginaria, la velocidad a la que oscila.

=== El RLC paralelo: la misma ecuación, otro $alpha$

#circuito([RLC paralelo, excitado por una fuente de corriente])[
#fig-rlc-paralelo()
]

Es el dual exacto. Se escribe LKC en el nodo de arriba, con $v$ como incógnita y
$i_L = (1\/L) integral v dif t$:

$ C (dif v)/(dif t) + v/R + 1/L integral v dif t = I $

y derivando una vez para sacarse la integral de encima, se llega a la misma forma canónica
de la @ec-ed-rlc con

$ omega_0 = 1/sqrt(L C) quad quad quad alpha = 1/(2 R C) $ <ec-alfa-par>

#atencion[
  *La $omega_0$ es la misma y la $alpha$ no.* Y no sólo cambia la fórmula: cambia el
  *sentido*. En el serie, $alpha = R\/2L$ crece con $R$: más resistencia amortigua más.
  En el paralelo, $alpha = 1\/2R C$ *decrece* con $R$: más resistencia amortigua *menos*,
  porque una resistencia grande en paralelo es un camino que casi no conduce, y por ahí
  casi no se pierde energía.

  Antes de escribir $alpha$, hay que decidir si el circuito es serie o paralelo *visto
  desde los elementos almacenadores*, no por cómo está dibujado. Confundir las dos
  fórmulas da un resultado que parece razonable y clasifica el régimen al revés.
]

=== Los tres casos

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, left, left),
    table.header([*Caso*], [*Condición*], [*Raíces*], [*Cómo se ve*]),
    [Sobreamortiguado], [$alpha > omega_0$ ($zeta > 1$)],
      [dos reales distintas], [llega despacio, sin pasarse],
    [Crítico], [$alpha = omega_0$ ($zeta = 1$)],
      [una real doble], [lo más rápido posible sin pasarse],
    [Subamortiguado], [$alpha < omega_0$ ($zeta < 1$)],
      [complejas conjugadas], [se pasa y oscila, amortiguándose],
  ),
  caption: [Los tres regímenes de un circuito de segundo orden],
)

Y la forma de la respuesta natural, en cada caso:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Caso*], [*Respuesta natural*], [*Las dos constantes*]),
    [Sobreamortiguado], [$x_n = A_1 e^(s_1 t) + A_2 e^(s_2 t)$], [$A_1$, $A_2$],
    [Crítico], [$x_n = (D_1 t + D_2) e^(-alpha t)$], [$D_1$, $D_2$],
    [Subamortiguado], [$x_n = e^(-alpha t)(B_1 cos omega_d t + B_2 sin omega_d t)$],
      [$B_1$, $B_2$],
  ),
  caption: [Las tres formas, cada una con dos constantes por determinar],
)

En el caso crítico la raíz es doble, y una sola exponencial no alcanza para dos condiciones
iniciales: la segunda solución independiente lleva el factor $t$ adelante. En el
subamortiguado la respuesta es una senoide dentro de una envolvente exponencial:

$ v(t) = V_infinity + e^(-alpha t) (B_1 cos omega_d t + B_2 sin omega_d t),
  quad quad omega_d = sqrt(omega_0^2 - alpha^2) $ <ec-subamort>

donde $omega_d$ es la *frecuencia de oscilación amortiguada*, siempre menor que $omega_0$.

#circuito([Los tres regímenes, normalizados: el mismo escalón y la misma $omega_0$])[
#graf-tres-regimenes()
]

=== Las dos constantes: de dónde salen

Un circuito de segundo orden necesita *dos* condiciones iniciales, y ahí se traba la mitad
de los ejercicios. Las dos existen siempre y son las dos variables de estado.

#definicion("Las dos condiciones, y cómo se usan")[
  Las dos que se leen directo del circuito son $i_L (0^+) = i_L (0^-)$ y
  $v_C (0^+) = v_C (0^-)$. Pero la solución está escrita para *una* variable $x$, así que
  hacen falta $x(0^+)$ y $dot(x)(0^+) = dif x\/dif t$ evaluada en $0^+$.

  - Si la incógnita es $v_C$: $v_C (0^+)$ sale por continuidad, y la derivada sale de la
    relación del capacitor, $ (dif v_C)/(dif t) bar.v_(0^+) = (i_C (0^+))/(C) $
    donde $i_C (0^+)$ se obtiene resolviendo el circuito resistivo de $0^+$.
  - Si la incógnita es $i_L$: $i_L (0^+)$ sale por continuidad, y
    $ (dif i_L)/(dif t) bar.v_(0^+) = (v_L (0^+))/(L) $
    con $v_L (0^+)$ del mismo circuito resistivo, escribiendo una LKT.

  Recién con esos dos números se plantea el sistema de dos ecuaciones que da las dos
  constantes de la tabla anterior.
]

=== Qué se mide en la pantalla

#circuito([El subamortiguado con lupa: de dónde salen los tres números que se miden])[
#graf-subamortiguado-detalle()
]

#definicion("Los tres números del régimen subamortiguado")[
  *Sobrepico.* Cuánto se pasa la respuesta del valor final, en fracción del salto:
  $ "SP" = e^(-pi zeta \/ sqrt(1 - zeta^2)) $ <ec-sobrepico>
  Depende *sólo* de $zeta$: dos circuitos con la misma $zeta$ y $omega_0$ distintas se
  pasan lo mismo, y tardan tiempos distintos en hacerlo.

  *Período amortiguado.* El tiempo entre dos picos consecutivos del mismo signo:
  $ T_d = (2 pi)/(omega_d) $ <ec-periodo-amort>
  Se mide con los cursores del osciloscopio y de ahí sale $omega_d$ directamente.

  *La envolvente.* Los picos caen sobre la curva $e^(-alpha t)$. Tomando dos picos
  separados un período, el cociente de sus alturas sobre el valor final da $alpha$:
  $ alpha = 1/T_d ln (x_1 - x_infinity)/(x_2 - x_infinity) $ <ec-decremento>
  Ese logaritmo se llama *decremento logarítmico*, y con $alpha$ y $omega_d$ medidos queda
  determinado todo: $omega_0 = sqrt(alpha^2 + omega_d^2)$ y $zeta = alpha\/omega_0$.
]

#clave[
  Las dos mediciones anteriores son el camino inverso del cálculo, y son la forma honesta
  de contrastar: se calcula $alpha$ y $omega_d$ a partir de $R$, $L$ y $C$; se los *mide*
  sobre la pantalla con el período y el decremento; y recién si los dos pares coinciden se
  puede decir que el modelo describe al circuito. Mirar la forma de la curva y decir
  «parece subamortiguada» no es una verificación: un sobreamortiguado con dos raíces muy
  distintas y un subamortiguado de $Q$ bajo se parecen bastante a ojo.
]

=== Diseño inverso: elegir el amortiguamiento

Hasta acá el circuito estaba dado y se preguntaba cómo responde. La pregunta de diseño va
al revés: se quiere una respuesta y hay que elegir el componente.

Fijados $L$ y $C$, la $omega_0$ ya quedó determinada y lo único libre es $R$. Pidiendo
$alpha = omega_0$ sale la resistencia que pone al circuito justo en el borde:

$ "serie": quad R_"crít" = 2 sqrt(L/C) quad quad quad
  "paralelo": quad R_"crít" = 1/2 sqrt(L/C) $ <ec-rcrit>

Las dos salen de despejar $R$ en la @ec-alfa-serie y en la @ec-alfa-par igualadas a
$1\/sqrt(L C)$, y son *inversas* una de la otra: en el serie hay que subir $R$ para
amortiguar, en el paralelo hay que bajarla.

#atencion[
  El $R_"crít"$ calculado es el del modelo ideal. En el circuito real hay que sumarle la
  resistencia del bobinado de la $L$ y la ESR del capacitor, que están *en serie* con
  ellos siempre: un RLC serie diseñado justo en el borde va a resultar levemente
  sobreamortiguado, y uno paralelo, levemente subamortiguado. Un diseño que dependa de
  estar exactamente en el crítico no es un diseño: la tolerancia de un capacitor
  electrolítico alcanza sola para cruzar el borde.
]

#ejercicio("Un RLC serie, en sus tres regímenes")[
  $L = 10$ mH y $C = 1 mu F$ fijos; se cambia solo $R$.

  *Frecuencia natural* (no depende de $R$):
  $ omega_0 = 1/sqrt(10 dot 10^(-3) dot 1 dot 10^(-6)) = 1/sqrt(10^(-8)) = 10^4 "rad"\/"s"
    quad arrow.r quad f_0 = (omega_0)/(2 pi) = 1592 "Hz" $

  *La resistencia crítica*, con la @ec-rcrit:
  $ R_"crít" = 2 sqrt(L/C)
    = 2 sqrt((10 dot 10^(-3))/(1 dot 10^(-6))) = 2 dot 100 = 200 Omega $

  *Caso A — $R = 500 Omega$:* $alpha = 500\/"0,02" = 25000 > omega_0$.
  *Sobreamortiguado*. Raíces reales: $s_1 = -2087$, $s_2 = -47913$ s#super[−1]. La
  respuesta es la suma de dos exponenciales; la lenta ($tau = 479 mu s$) domina, y a los
  pocos microsegundos la rápida ya no existe.

  *Caso B — $R = 200 Omega$:* $alpha = 10^4 = omega_0$. *Crítico*. Es el borde: llega al
  valor final lo más rápido que se puede sin pasarse ni un volt.

  *Caso C — $R = 40 Omega$:* $alpha = 2000 < omega_0$. *Subamortiguado*.
  $ omega_d = sqrt((10^4)^2 - 2000^2) = sqrt("9,6" dot 10^7) = 9798 "rad"\/"s"
    quad arrow.r quad f_d = 1559 "Hz" $
  $ zeta = (alpha)/(omega_0) = "0,2" quad arrow.r quad
    "SP" = e^(-pi dot "0,2" \/ sqrt(1 - "0,04")) = e^(-"0,641") = "0,53" $
  Es decir, la tensión sobre el capacitor *se pasa un $53 %$* del valor final antes de
  volver, y sigue oscilando a 1559 Hz mientras la envolvente $e^(-2000 t)$ la apaga con
  $tau = 500 mu s$. El período amortiguado es $T_d = 2 pi\/omega_d = 641 mu s$, y su
  factor de mérito, $Q = 1\/(2 dot "0,2") = "2,5"$.

  *Qué se hace con esto.* En una fuente conmutada o en un control, se busca $zeta approx
  "0,7"$: es el compromiso clásico entre velocidad y sobrepico (unos 4 % de sobrepico). En
  un filtro o un oscilador se busca lo contrario, $zeta$ chiquísimo y $Q$ alto, que es
  justamente la resonancia del Módulo 11.
]

#ejercicio("Un crítico, con sus dos constantes determinadas")[
  Un RLC *paralelo* con $L = 50$ mH, $C = "0,2"$ µF, y las condiciones iniciales
  $v_C (0^-) = 20$ V e $i_L (0^-) = 30$ mA. Se pide el $R$ que lo hace críticamente
  amortiguado y la expresión de $v_C (t)$ en la respuesta natural.

  *La resistencia*, con la @ec-rcrit del paralelo:
  $ R_"crít" = 1/2 sqrt(L/C) = 1/2 sqrt(("0,050")/(2 dot 10^(-7)))
    = 1/2 sqrt(250000) = 250 Omega $
  Control: $alpha = 1\/(2 R C) = 1\/(2 dot 250 dot 2 dot 10^(-7)) = 10^4$ s#super[−1], y
  $omega_0 = 1\/sqrt(L C) = 1\/sqrt("0,050" dot 2 dot 10^(-7)) = 10^4$ rad/s. Iguales:
  es el crítico. $checkmark$

  *La forma*, de la tabla de los tres casos:
  $ v_C (t) = (D_1 t + D_2) e^(-alpha t) $

  *Primera condición* — la tensión no salta:
  $ v_C (0^+) = 20 "V" quad arrow.r quad D_2 = 20 $

  *Segunda condición* — la derivada. En un nodo con las tres ramas en paralelo y sin
  fuente, la LKC en $0^+$ da $i_C = -(i_L + i_R)$:
  $ i_C (0^+) = -(i_L (0^+) + (v_C (0^+))/(R))
    = -("0,030" + (20)/(250)) = -"0,110" "A" $
  $ (dif v_C)/(dif t) bar.v_(0^+) = (i_C (0^+))/(C) = (-"0,110")/(2 dot 10^(-7))
    = -"5,5" dot 10^5 "V"\/"s" $

  *Despejar $D_1$.* Derivando la forma y evaluando en $t = 0$:
  $ dot(v)_C (0^+) = D_1 - alpha D_2 quad arrow.r quad
    D_1 = -"5,5" dot 10^5 + 10^4 dot 20 = -"3,5" dot 10^5 $

  *El resultado*, con $t$ en segundos:
  $ v_C (t) = (20 - "3,5" dot 10^5 thin t) thin e^(-10^4 t) quad ["V"] $

  *Los controles.* En $t = 0$ da 20 V $checkmark$. Cruza el cero en
  $t = 20\/("3,5" dot 10^5) = 57 mu s$, se hace negativa, alcanza un mínimo y vuelve a
  cero desde abajo: *una sola cruzada por cero*, que es lo máximo que puede hacer un
  crítico. Si la simulación mostrara dos cruces, el circuito no sería crítico y habría
  que revisar $R$.
]

== Los componentes reales

Todo lo anterior es el modelo ideal, y la guía de la cátedra pide una segunda pasada con
los parásitos puestos. No es un ejercicio de purista: hay circuitos donde el parásito
manda.

#circuito([Lo que hay adentro de una bobina y de un capacitor de verdad])[
#fig-no-idealidades()
]

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([*Parásito*], [*Qué es*], [*Qué arruina*]),
    [$R_L$ (DCR)],
      [Resistencia del alambre del bobinado. *DC Resistance*. Está siempre *en serie* con
       $L$ y se mide con el óhmetro.],
      [Una descarga «sin resistencia» igual se apaga, con $tau = L\/R_L$. Y en un RLC
       serie, $R_L$ se suma a $R$ y corre el punto crítico.],
    [$C_p$],
      [Capacidad entre espiras, en *paralelo* con la bobina.],
      [Por encima de su frecuencia de autorresonancia, la bobina se comporta como
       capacitor. Es el límite superior de uso de una $L$.],
    [ESR],
      [*Equivalent Series Resistance*: la resistencia del dieléctrico, las láminas y los
       terminales, en *serie* con $C$.],
      [Es la que calienta un capacitor de filtro y la que lo hace fallar. En un RLC serie
       se suma a $R$ igual que $R_L$.],
    [ESL],
      [*Equivalent Series Inductance*: la inductancia de los terminales y el bobinado
       interno.],
      [Le pone piso al tiempo de respuesta de un capacitor de desacople.],
    [$R_"fuga"$],
      [Resistencia finita del dieléctrico, en *paralelo* con $C$.],
      [Un capacitor cargado y desconectado se descarga solo, con
       $tau = R_"fuga" C$. En un electrolítico eso son minutos.],
    [$R_"out"$],
      [Resistencia de salida de la fuente o del generador (50 Ω típicos).],
      [Se suma a la $R$ del circuito y alarga $tau$ sin que nadie la haya puesto.],
  ),
  caption: [Los parásitos que hay que sumar en la segunda pasada],
)

#clave[
  *Cuál domina se decide comparando, no suponiendo.* La pregunta útil es siempre la
  misma: ¿cuánto vale el parásito *comparado con* el elemento del circuito que está en el
  mismo lugar? Un ESR de $"0,5" thin Omega$ es despreciable frente a una $R$ de
  $500 thin Omega$ y es *el* elemento dominante frente a una de $"0,1" thin Omega$. Por eso
  la segunda pasada de la guía se hace con números, y por eso hay que declarar los valores
  supuestos cuando no se tiene la hoja de datos.
]

== Dónde estaba esto en la Parte I

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([*Lo que se vio antes*], [*El transitorio que era*]),
    [El *rizado* del filtro capacitivo de la fuente (Módulo 5)],
      [Una descarga exponencial $e^(-t\/R_L C)$ interrumpida cada semiciclo por el
       rectificador. La aproximación lineal del rizado es el primer término de esa
       exponencial.],
    [El *tiempo de conmutación* del transistor (Módulo 6)],
      [La carga y descarga de las capacidades parásitas de las junturas: un RC de primer
       orden que fija la frecuencia máxima de conmutación.],
    [El *diodo de rueda libre* del relé (Módulo 6)],
      [La respuesta natural del RL: la corriente del bobinado no puede saltar y se apaga
       con $tau = L\/R$ a través del diodo.],
    [El *arranque* de una fuente],
      [Corriente de irrupción por los capacitores descargados, más los $5 tau$ que tarda
       la salida en estabilizarse.],
    [Los *bornes homólogos* del transformador (Módulo 3)],
      [Las marcas de punto de la inductancia mutua. La relación de transformación es el
       caso $k arrow.r 1$ de la @ec-acople.],
    [El *filtro pasa bajos* RC del TP N.º 5 (Módulo 2)],
      [El mismo RC de este módulo, mirado en frecuencia en vez de en el tiempo:
       $f_c = 1\/(2 pi R C) = 1\/(2 pi tau)$. Las dos caras del mismo componente.],
  ),
  caption: [Los transitorios que ya se habían visto sin nombre],
)

#tp("Con los TP N.º 5 y 7 — guías de la cátedra")[
  *TP N.º 7 (fuentes de alimentación).* El rizado que el práctico manda calcular y medir
  con el capacitor de 100 µF *es* este módulo: entre pulso y pulso del rectificador, el
  capacitor se descarga sobre la carga según $e^(-t\/R_L C)$. La fórmula lineal del rizado
  del Módulo 5 es el primer término del desarrollo de esa exponencial, y vale porque
  $T\/2$ es mucho menor que $tau$. Comparar la medición con el cálculo es comparar la
  aproximación con la exponencial real.

  *TP N.º 5 (manejo del osciloscopio).* Es el instrumento con el que este módulo se ve.
  Un generador de audio en onda cuadrada sobre una serie $R$–$C$ dibuja en la pantalla la
  @ec-tres-datos: cada flanco es un escalón, y medir el tiempo en que la curva llega al
  63 % del salto es *medir $tau$ directamente*. De ahí se despeja $C$ si se conoce $R$.
  Es el mismo circuito que, excitado con una senoidal y barrido en frecuencia, resulta
  el filtro pasa bajos del Módulo 12: las dos caras del mismo componente, una en el
  tiempo y otra en la frecuencia.

  *Y el que falta.* Todo lo de este módulo se puede contrastar con un simulador antes de
  tocar el laboratorio, y conviene hacerlo en ese orden: el Módulo 15 arma los seis
  circuitos —RC, RL y RLC, serie y paralelo, con y sin condición inicial— y muestra qué
  controlar en cada curva para no aceptar una simulación sólo porque «parece correcta».
]
