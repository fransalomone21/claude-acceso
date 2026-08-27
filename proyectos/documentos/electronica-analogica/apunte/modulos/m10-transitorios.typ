#import "../plantilla.typ": *

#modulo("Capacitor, inductor y régimen transitorio", [
  Escribir las relaciones $v$–$i$ del capacitor y del inductor y saber *por qué* una
  tensión y una corriente no pueden saltar; encontrar las condiciones iniciales y finales
  de cualquier circuito conmutado; resolver de memoria todo circuito de primer orden con
  la fórmula de los tres datos; y clasificar la respuesta de un circuito de segundo orden
  en sobreamortiguada, crítica o subamortiguada sabiendo qué significa cada una en el
  osciloscopio.
])

Hasta acá todos los circuitos eran resistivos: la respuesta era instantánea y proporcional
a la excitación. El capacitor y el inductor rompen eso, porque *almacenan energía*, y la
energía almacenada no aparece ni desaparece de golpe. Ese es el origen de todo lo que
sigue: los transitorios, las constantes de tiempo, la respuesta en frecuencia y —al final
de la cadena— el filtrado.

== El capacitor

#definicion("Capacitor: relación constitutiva")[
  Un capacitor almacena carga proporcional a la tensión entre sus placas, $q = C v$.
  Derivando respecto del tiempo:
  $ i = C (dif v)/(dif t) quad quad "y su inversa" quad quad
    v(t) = v(t_0) + 1/C integral_(t_0)^t i(lambda) dif lambda $
  La capacidad $C$ se mide en farad $["F" = "C"\/"V"]$. Las capacidades reales son de
  picofarad a milifarad: el farad es una unidad enorme.
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

#atencion[
  En un capacitor electrolítico, además del valor hay dos datos que matan si se ignoran:
  la *polaridad* (invertirla lo hace explotar) y la *tensión máxima de trabajo*, que
  debe superar cómodamente el pico —no el eficaz— de lo que va a soportar. En la fuente
  del Módulo 5, el capacitor de filtro ve el valor *pico* del secundario, no los volt
  eficaces que dice el transformador.
]

== El inductor

#definicion("Inductor: relación constitutiva")[
  Un inductor concatena flujo magnético proporcional a la corriente, $phi = L i$. Por la
  ley de Faraday, la tensión inducida es la derivada del flujo:
  $ v = L (dif i)/(dif t) quad quad "y su inversa" quad quad
    i(t) = i(t_0) + 1/L integral_(t_0)^t v(lambda) dif lambda $
  La inductancia $L$ se mide en henry $["H" = "V" dot "s"\/"A"]$.
]

Todo es el dual exacto del capacitor:

- *En continua estacionaria*, $dif i\/dif t = 0$, luego $v = 0$: *un inductor en continua
  permanente es un cortocircuito*.
- *La corriente no puede saltar*:
  $ i_L (0^+) = i_L (0^-) $ <ec-cont-il>
- *Energía almacenada*, en el campo magnético:
  $ w_L = 1/2 L i^2 $ <ec-energia-l>
- *Asociación*: igual que los resistores. $L_"serie" = sum L_k$,
  $1\/L_"paralelo" = sum 1\/L_k$.

#clave[
  La consecuencia práctica de la @ec-cont-il es la razón por la que el diodo de rueda
  libre del Módulo 6 no es opcional. Al abrir la llave que alimenta un relé, la corriente
  del bobinado *tiene* que seguir circulando; si no encuentra camino, la única forma de
  cumplir $v = L thin dif i\/dif t$ con un $dif i$ enorme en un $dif t$ chiquísimo es
  generando cientos de volts, que perforan el transistor. El diodo le da el camino.
]

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    table.header([], [*Capacitor*], [*Inductor*]),
    [Relación], [$i = C thin dif v\/dif t$], [$v = L thin dif i\/dif t$],
    [No puede saltar], [la *tensión*], [la *corriente*],
    [En continua permanente es], [circuito *abierto*], [*cortocircuito*],
    [Energía], [$1/2 C v^2$], [$1/2 L i^2$],
    [En serie], [$1\/C_"eq" = sum 1\/C_k$], [$L_"eq" = sum L_k$],
    [En paralelo], [$C_"eq" = sum C_k$], [$1\/L_"eq" = sum 1\/L_k$],
    [Constante de tiempo con $R$], [$tau = R C$], [$tau = L\/R$],
  ),
  caption: [Capacitor e inductor son duales término a término],
)

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

#atencion[
  Lo único que se conserva a través de la conmutación es $v_C$ e $i_L$. *Todo lo demás
  salta*: la corriente por el capacitor, la tensión sobre el inductor, la corriente de
  cualquier resistor. Escribir "$i_R (0^+) = i_R (0^-)$" es el error clásico y no tiene
  ningún fundamento.
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

=== Qué significa $tau$

#definicion("Constante de tiempo")[
  $tau$ es el tiempo en el que la respuesta cae al $e^(-1) = 36,8%$ de su valor inicial.
  Geométricamente, es el tiempo que tardaría la respuesta en llegar a cero *si siguiera
  con la pendiente que tiene en el origen*.
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

  *Leerla.* A los 8 ms el capacitor está en $16 dot 0,632 = 10,1$ V. A los 40 ms
  ($5 tau$), en 15,9 V: terminó.

  *Una variable que sí salta.* La corriente por $R_1$ en $0^+$: con el capacitor
  reemplazado por una fuente de 0 V (un corto), $R_1$ ve los 20 V contra el paralelo de
  $R_2$ con ese corto, es decir contra 0:
  $ i_(R 1)(0^+) = (20 "V")/(5 "k"Omega) = 4 "mA" $
  mientras que en régimen vale $20\/25 = 0,8$ mA. Saltó de 0 a 4 mA en el instante de
  cerrar la llave, y de ahí baja. Eso es la *corriente de irrupción*, y es la que hace
  que la protección de una fuente tenga que tolerar mucho más que la corriente nominal.

  *Y si después se abre la llave*: el capacitor queda solo con $R_2$, entonces
  $tau' = 20 "k"Omega dot 2 mu F = 40$ ms, y descarga desde 16 V hasta 0 según
  $v_C = 16 e^(-t\/40"ms")$. La misma fórmula, otros tres datos.
]

== Circuitos de segundo orden

Con *dos* elementos almacenadores que no se pueden reducir a uno —típicamente una $L$ y
una $C$— la ecuación es de segundo orden y aparece algo nuevo: la posibilidad de que el
circuito *oscile*.

=== La ecuación

Para el RLC serie, LKT sobre la malla con $v_C$ como incógnita, usando $i = C thin dif v_C\/dif t$:

$ L C (dif^2 v_C)/(dif t^2) + R C (dif v_C)/(dif t) + v_C = V $

Dividiendo por $L C$ y ordenando en la forma canónica:

$ (dif^2 v_C)/(dif t^2) + 2 alpha (dif v_C)/(dif t) + omega_0^2 v_C = omega_0^2 V $ <ec-ed-rlc>

#definicion("Los dos parámetros que gobiernan todo")[
  $ omega_0 = 1/sqrt(L C) quad ["rad"\/"s"] quad quad "frecuencia natural no amortiguada" $
  $ alpha = R/(2L) quad ["s"^(-1)] quad quad "coeficiente de amortiguamiento (serie)" $
  Para el RLC *paralelo*, $omega_0$ es la misma y $alpha = 1\/(2 R C)$.

  El cociente $zeta = alpha \/ omega_0$ es el *factor de amortiguamiento*, adimensional, y
  es el único número que decide la forma de la respuesta. Su inverso, hasta un factor 2,
  es el *factor de mérito*: $Q = omega_0 \/ (2 alpha) = 1\/(2 zeta)$.
]

Las raíces de la ecuación característica $s^2 + 2 alpha s + omega_0^2 = 0$ son

$ s_(1,2) = - alpha plus.minus sqrt(alpha^2 - omega_0^2) $ <ec-raices>

y el signo de lo que hay bajo la raíz define los tres casos.

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

En el caso subamortiguado la respuesta es una senoide dentro de una envolvente
exponencial:

$ v(t) = V_infinity + e^(-alpha t) (A cos omega_d t + B sin omega_d t),
  quad quad omega_d = sqrt(omega_0^2 - alpha^2) $ <ec-subamort>

donde $omega_d$ es la *frecuencia de oscilación amortiguada*, siempre menor que $omega_0$.
El *sobrepico* respecto del valor final vale

$ "SP" = e^(-pi zeta \/ sqrt(1 - zeta^2)) $ <ec-sobrepico>

#ejercicio("Un RLC serie, en sus tres regímenes")[
  $L = 10$ mH y $C = 1 mu F$ fijos; se cambia solo $R$.

  *Frecuencia natural* (no depende de $R$):
  $ omega_0 = 1/sqrt(10 dot 10^(-3) dot 1 dot 10^(-6)) = 1/sqrt(10^(-8)) = 10^4 "rad"\/"s"
    quad arrow.r quad f_0 = (omega_0)/(2 pi) = 1592 "Hz" $

  *La resistencia crítica* sale de pedir $alpha = omega_0$:
  $ R/(2L) = 1/sqrt(L C) quad arrow.r quad R_"crít" = 2 sqrt(L/C)
    = 2 sqrt((10 dot 10^(-3))/(1 dot 10^(-6))) = 2 dot 100 = 200 Omega $

  *Caso A — $R = 500 Omega$:* $alpha = 500\/0,02 = 25 000 > omega_0$.
  *Sobreamortiguado*. Raíces reales: $s_1 = -2087$, $s_2 = -47913$ s#super[−1]. La
  respuesta es la suma de dos exponenciales; la lenta ($tau = 479 mu s$) domina.

  *Caso B — $R = 200 Omega$:* $alpha = 10^4 = omega_0$. *Crítico*. Es el borde: llega al
  valor final lo más rápido que se puede sin pasarse ni un volt.

  *Caso C — $R = 40 Omega$:* $alpha = 2000 < omega_0$. *Subamortiguado*.
  $ omega_d = sqrt((10^4)^2 - 2000^2) = sqrt("9,6" dot 10^7) = 9798 "rad"\/"s"
    quad arrow.r quad f_d = 1559 "Hz" $
  $ zeta = (alpha)/(omega_0) = 0,2 quad arrow.r quad
    "SP" = e^(-pi dot "0,2" \/ sqrt(1 - "0,04")) = e^(-"0,641") = 0,53 $
  Es decir, la tensión sobre el capacitor *se pasa un 53 %* del valor final antes de
  volver, y sigue oscilando a 1559 Hz mientras la envolvente $e^(-2000 t)$ la apaga con
  $tau = 500 mu s$. Su factor de mérito es $Q = 1\/(2 dot "0,2") = 2,5$.

  *Qué se hace con esto.* En una fuente conmutada o en un control, se busca $zeta approx
  0,7$: es el compromiso clásico entre velocidad y sobrepico (unos 4 % de sobrepico). En
  un filtro o un oscilador se busca lo contrario, $zeta$ chiquísimo y $Q$ alto, que es
  justamente la resonancia del Módulo 11.
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
]
