#import "../plantilla.typ": *

#modulo("Cuadripolos y amplificador operacional", [
  Describir un circuito completo como una caja de cuatro terminales mediante sus
  parámetros $z$, $y$, $h$ o $A B C D$, y saber cuál conviene en cada caso; reconocer los
  parámetros $h$ como el modelo lineal del transistor del Módulo 6; y usar el amplificador
  operacional —las dos reglas de oro, la tierra virtual— para armar y calcular las
  configuraciones básicas, incluido un filtro activo.
])

Este módulo cierra la Parte II y el programa de Teoría de Circuitos. La idea que lo
gobierna es la misma que la de Thévenin, llevada un paso más lejos: si una red de dos
terminales se resume en dos números ($V_"th"$ y $R_"th"$), una red de *cuatro* terminales
—una entrada y una salida— se resume en cuatro. Y con esos cuatro números se puede
conectar la caja a otras cajas sin volver a mirar jamás lo que tiene adentro.

== El cuadripolo

#definicion("Cuadripolo (red de dos puertos)")[
  Es una red con dos pares de terminales: el *puerto de entrada* ($overline(V)_1$,
  $overline(I)_1$) y el *puerto de salida* ($overline(V)_2$, $overline(I)_2$), con la
  condición de puerto —la corriente que entra por un terminal del par sale por el otro—.

  De las cuatro variables, *dos son independientes y dos dependientes*. Elegir cuáles es
  lo que da los distintos juegos de parámetros. La red se supone lineal y sin fuentes
  independientes internas.
]

#circuito([El cuadripolo y sus cuatro variables])[
```
              I1  →                    ←  I2
         o────────────┬───────────────────────o
                      │                       │
      +               │      CUADRIPOLO       │              +
     V1               │    (lineal, sin       │             V2
      -               │  fuentes internas)    │              -
                      │                       │
         o────────────┴───────────────────────o

    Convención: las dos corrientes se dibujan ENTRANDO al cuadripolo.
```
]

=== Los cuatro juegos de parámetros

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Juego*], [*Ecuaciones*], [*Cuándo se usa*]),
    [Impedancia $z$ $["ohm"]$],
      [$V_1 = z_11 I_1 + z_12 I_2$ \ $V_2 = z_21 I_1 + z_22 I_2$],
      [redes en $T$; conexión *serie* de cuadripolos],
    [Admitancia $y$ $["siemens"]$],
      [$I_1 = y_11 V_1 + y_12 V_2$ \ $I_2 = y_21 V_1 + y_22 V_2$],
      [redes en $Pi$; conexión *paralelo*; análisis nodal],
    [Híbridos $h$ (mixtos)],
      [$V_1 = h_11 I_1 + h_12 V_2$ \ $I_2 = h_21 I_1 + h_22 V_2$],
      [*transistores*: es el juego que los fabricantes publican],
    [Transmisión $A B C D$],
      [$V_1 = A V_2 - B I_2$ \ $I_1 = C V_2 - D I_2$],
      [líneas y etapas en *cascada*: se multiplican las matrices],
  ),
  caption: [Los cuatro juegos de parámetros de un cuadripolo],
)

=== Cómo se miden

Cada parámetro se obtiene anulando una variable, y anularla significa un ensayo concreto:

$ z_11 = lr((V_1)/(I_1) |)_(I_2 = 0) quad quad z_12 = lr((V_1)/(I_2) |)_(I_1 = 0) $ <ec-z>

*$I = 0$ es dejar el puerto en vacío* (circuito abierto) y *$V = 0$ es ponerlo en
cortocircuito*. Por eso a los $z$ se los llama parámetros "de circuito abierto" y a los
$y$, "de cortocircuito": son literalmente el protocolo de medición.

#clave[
  En una red *recíproca* (hecha solo de $R$, $L$, $C$ y transformadores, sin fuentes
  controladas) se cumple $z_12 = z_21$ y $y_12 = y_21$. Es la misma simetría de matriz que
  apareció en el Módulo 8, y por la misma razón. Un cuadripolo con transistores adentro
  *no* es recíproco: $h_12$ y $h_21$ no tienen nada que ver entre sí, y menos mal —si lo
  fueran, no habría amplificación.
]

#ejercicio("Parámetros z de una red en T")[
  Red en T: $Z_a = 10 Omega$ en serie en la rama de entrada, $Z_b = 20 Omega$ en serie en
  la rama de salida, y $Z_c = 30 Omega$ derivada al terminal común.

  *$z_11$* — salida en vacío ($I_2 = 0$): la corriente $I_1$ recorre $Z_a$ y $Z_c$ (por
  $Z_b$ no circula nada):
  $ z_11 = Z_a + Z_c = 40 Omega $

  *$z_21$* — misma condición: la tensión de salida es la que cae en $Z_c$, porque $Z_b$ no
  tiene caída:
  $ z_21 = (V_2)/(I_1) = (I_1 Z_c)/(I_1) = Z_c = 30 Omega $

  *$z_22$ y $z_12$* — por simetría, con la entrada en vacío:
  $ z_22 = Z_b + Z_c = 50 Omega quad quad z_12 = Z_c = 30 Omega $

  *Resultado.*
  $ bold(z) = mat(40, 30; 30, 50) Omega $
  Simétrica, como corresponde a una red puramente resistiva. Y la lectura es directa: *los
  parámetros de la diagonal son las impedancias "propias" de cada puerto y los de fuera de
  la diagonal, la impedancia que comparten* — el mismo patrón que la matriz de mallas.
]

== Los parámetros $h$ del transistor

Los $h$ se ganaron su lugar porque son los únicos cuatro números que se pueden medir con
comodidad en un transistor y porque tienen sentido físico inmediato. En emisor común:

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, left, center, left),
    table.header([*Parámetro*], [*Qué es*], [*Unidad*], [*Orden típico (BC548)*]),
    [$h_(i e)$], [resistencia de entrada, con la salida en corto], [$Omega$], [1 a 5 k$Omega$],
    [$h_(r e)$], [realimentación inversa de tensión], [—], [$10^(-4)$ (casi siempre se desprecia)],
    [$h_(f e)$], [*ganancia de corriente* — es el $beta$ del Módulo 6], [—], [110 a 800],
    [$h_(o e)$], [admitancia de salida], [S], [$10^(-5)$ a $10^(-4)$ S],
  ),
  caption: [Parámetros híbridos del transistor bipolar en emisor común],
)

#clave[
  Acá se cierra el arco de toda la Parte II. El $beta = h_(f e)$ que en el Módulo 6 era "un
  número que dice el fabricante" es, formalmente, *el parámetro $h_21$ de un cuadripolo*, y
  la fuente controlada que lo representa es la CCCS que se presentó en el Módulo 7. El
  transistor no es un caso aparte: es un cuadripolo no recíproco, y una vez modelado así
  se lo analiza con el análisis nodal del Módulo 8 como a cualquier otra cosa.
]

=== Interconexión

La ventaja operativa de los cuadripolos es que se combinan con álgebra de matrices, sin
volver a mirar el interior:

- *Serie* (entradas en serie y salidas en serie): se suman las matrices $bold(z)$.
- *Paralelo*: se suman las matrices $bold(y)$.
- *Cascada* (la salida de uno es la entrada del siguiente): se *multiplican* las matrices
  $A B C D$, en orden.

#atencion[
  La regla de la cascada es la razón por la que existe la matriz $A B C D$, y también
  explica la advertencia del Módulo 12 sobre poner filtros en cascada: al conectarlos, la
  impedancia de entrada de la segunda etapa carga a la primera y le cambia la respuesta.
  El álgebra de cuadripolos *lo tiene en cuenta automáticamente*; la multiplicación
  ingenua de transferencias, no. Salvo que entre las etapas haya un buffer de impedancia
  de entrada infinita, que es lo que viene ahora.
]

== El amplificador operacional

#definicion("Amplificador operacional ideal")[
  Es un amplificador diferencial con dos entradas —la *no inversora* ($+$) y la *inversora*
  ($-$)— y una salida, que idealmente cumple:

  - *Ganancia en lazo abierto infinita*: $v_"sal" = A_"ol" (v_+ - v_-)$ con
    $A_"ol" arrow.r infinity$.
  - *Impedancia de entrada infinita*: no toma corriente por ninguna de las dos entradas.
  - *Impedancia de salida nula*: la tensión de salida no depende de la carga.
  - Ancho de banda infinito y sin offset.
]

=== Las dos reglas de oro

Si el operacional está en *realimentación negativa* —hay un camino de la salida a la
entrada inversora— y no está saturado, entonces:

$ v_"sal" = A_"ol" (v_+ - v_-) quad arrow.r quad
  v_+ - v_- = (v_"sal")/(A_"ol") arrow.r 0 quad "cuando" quad A_"ol" arrow.r infinity $

#clave[
  *Regla 1 — cortocircuito virtual*: $v_+ = v_-$. Las dos entradas están a la misma
  tensión. No están unidas: el circuito *se encarga* de igualarlas, moviendo la salida
  hasta que lo estén.

  *Regla 2 — corriente de entrada nula*: $i_+ = i_- = 0$.

  Cuando la entrada $+$ está a masa, la Regla 1 pone la entrada $-$ a $0$ V sin estar
  conectada a nada: eso es la *tierra virtual*, y es lo que hace que las cuentas salgan en
  dos líneas.
]

#atencion[
  Las dos reglas valen *solo* con realimentación negativa y *solo* mientras la salida esté
  dentro del rango de alimentación. Si la realimentación es positiva, el circuito no
  iguala nada: se va a un extremo y ahí se queda, que es como se construye un *comparador*
  con histéresis. Y si la salida pega contra la alimentación, el operacional *satura* y la
  Regla 1 deja de valer: $v_+ != v_-$ y la fórmula de ganancia miente. Es el error número
  uno al medir un circuito con operacionales en el laboratorio.
]

=== Las configuraciones básicas

#circuito([Amplificador inversor y amplificador no inversor])[
```
                     INVERSOR

                    R2
            ┌────[/////]──────┐
            │                 │
      R1    │    |\           │
Ve ──[/////]┴────|−\          │
                 |  \         │
                 |   \────────┴───o  Vs
                 |   /
        ┌────────|+ /
        │        | /
        │        |/
       ─┴─
       GND                              Vs = −(R2/R1)·Ve


                   NO INVERSOR

                    R2
            ┌────[/////]──────┐
            │                 │
            │    |\           │
            ├────|−\          │
      R1    │    |  \         │
   ┌─[/////]┘    |   \────────┴───o  Vs
   │             |   /
   │   Ve ───────|+ /
  ─┴─            | /
  GND            |/                     Vs = (1 + R2/R1)·Ve
```
]

*Inversor.* Con la entrada $+$ a masa, la Regla 1 pone el nodo $-$ en 0 V. Entonces la
corriente por $R_1$ vale $v_e \/ R_1$, y por la Regla 2 esa misma corriente tiene que
seguir por $R_2$ (no se desvía hacia el operacional). La caída en $R_2$ va de 0 V a
$v_s$:

$ (v_e)/(R_1) = - (v_s)/(R_2) quad arrow.r quad
  v_s = - (R_2)/(R_1) v_e $ <ec-inversor>

*No inversor.* Ahora $v_+ = v_e$, y por la Regla 1, $v_- = v_e$. Pero $v_-$ es la salida
vista por un divisor de $R_1$ y $R_2$ (que no carga nada, por la Regla 2):

$ v_e = v_s (R_1)/(R_1 + R_2) quad arrow.r quad
  v_s = (1 + (R_2)/(R_1)) v_e $ <ec-noinversor>

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    table.header([*Configuración*], [*Salida*], [*Para qué sirve*]),
    [Inversor], [$-(R_2\/R_1) v_e$], [amplificar e invertir; ganancia $< 1$ posible],
    [No inversor], [$(1 + R_2\/R_1) v_e$], [amplificar sin invertir; entrada de altísima impedancia],
    [Seguidor], [$v_e$], [*buffer*: aísla etapas, no carga a la anterior],
    [Sumador], [$-R_f (v_1\/R_1 + v_2\/R_2 + dots)$], [mezclar señales; conversor D/A por red resistiva],
    [Restador], [$(R_2\/R_1)(v_2 - v_1)$], [medir diferencias; salida de un puente],
    [Integrador ($C$ en lugar de $R_2$)], [$-(1\/R C) integral v_e dif t$], [rampas, filtros, control],
    [Derivador ($C$ en lugar de $R_1$)], [$-R C thin dif v_e \/ dif t$], [detectar flancos (ruidoso: se usa poco)],
  ),
  caption: [Las configuraciones que hay que saber de memoria],
)

#clave[
  El *seguidor* —salida conectada directamente a la entrada $-$, señal en la $+$— tiene
  ganancia 1 y parece inútil. Es de las cosas más útiles que hay: su impedancia de entrada
  es enorme y la de salida, casi cero. Es la solución exacta a los tres problemas de carga
  que aparecieron a lo largo de todo el apunte: el divisor que se derrumba (Ejercicio 7.1),
  el voltímetro que altera lo que mide (Módulo 1) y los filtros en cascada que se cargan
  entre sí (Módulo 12).
]

#ejercicio("Filtro activo pasa bajos de primer orden")[
  Un inversor con $R_1 = 10 "k"Omega$ a la entrada y, en la realimentación,
  $R_2 = 100 "k"Omega$ *en paralelo* con $C = 1,59$ nF.

  *1. La impedancia de realimentación*, con las herramientas del Módulo 11:
  $ overline(Z)_2 = R_2 parallel 1/(j omega C) = (R_2)/(1 + j omega R_2 C) $

  *2. La transferencia*, reemplazando en la @ec-inversor:
  $ overline(H)(j omega) = - (overline(Z)_2)/(R_1)
    = - (R_2\/R_1)/(1 + j omega R_2 C) $
  Que es *exactamente* la forma canónica del pasa bajos de la @ec-pb-modfase, multiplicada
  por una ganancia.

  *3. Los dos números de diseño.*
  $ "Ganancia en continua" = -(R_2)/(R_1) = -10 quad (20 "dB") $
  $ f_c = 1/(2 pi R_2 C) = 1/(2 pi dot 10^5 dot 1,59 dot 10^(-9)) = 1000 "Hz" $

  *4. Por qué es mejor que el RC pasivo.* Amplifica en vez de atenuar; su impedancia de
  salida es casi nula, así que la etapa siguiente no le corre la frecuencia de corte; y
  $R_1$, $R_2$ y $C$ fijan *ganancia y corte por separado*, cosa que en el RC pasivo es
  imposible. Ese desacople de los parámetros de diseño es la razón de ser de los filtros
  activos.

  *5. El control de realidad.* Con un operacional de producto ganancia-ancho de banda
  $"GBW" = 1$ MHz, a ganancia 10 el ancho de banda disponible es $10^6\/10 = 100$ kHz.
  Como el filtro corta en 1 kHz, hay margen de sobra. Si se hubiera pedido ganancia 1000,
  el ancho de banda propio del operacional (1 kHz) se metería adentro de la banda de paso
  y el filtro no sería el que se diseñó.
]

=== El operacional real

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Limitación*], [*Qué significa*], [*Cuándo muerde*]),
    [Ganancia finita ($A_"ol" approx 10^5$)],
      [las reglas de oro son una aproximación], [con ganancias de lazo cerrado muy altas],
    [Producto ganancia-ancho de banda], [$G dot "BW" = "GBW"$, constante],
      [siempre: más ganancia es menos banda],
    [#emph[Slew rate] ($approx 0,5 "V"\/mu s$ en un 741)],
      [velocidad máxima de cambio de la salida], [con señales grandes y rápidas: la senoidal sale triangular],
    [Tensión de #emph[offset] y corrientes de polarización],
      [la salida no es cero con entrada cero], [en continua y con ganancias altas],
    [Excursión de salida],
      [la salida no llega a la alimentación (salvo los #emph[rail-to-rail])],
      [siempre: por eso satura antes de lo esperado],
  ),
  caption: [Las cinco limitaciones que hacen que un circuito real no dé lo calculado],
)

#laboratorio[
  Con un LM741 hace falta alimentación *simétrica* ($plus.minus 12$ V, por ejemplo) y su
  salida no llega a menos de 1,5 V de cada riel. Con un LM358 o un TL072 se puede trabajar
  con fuente simple. Antes de culpar al circuito de un resultado raro, medir con el
  osciloscopio la *salida* y verificar que no esté chocando contra la alimentación: nueve
  de cada diez "el operacional no amplifica" son saturación.
]

== Cierre de la Parte II

Con esto queda cubierto el programa completo de *Teoría de Circuitos*: señales y
respuestas natural y forzada (Módulo 10), fasores y régimen permanente senoidal
(Módulo 11), diagramas de Bode y señales poliarmónicas (Módulo 12), resolución sistemática
de circuitos (Módulos 7 a 9), teoría de los cuadripolos y una introducción al amplificador
operacional y al filtrado (este módulo).

#clave[
  El hilo que atraviesa la Parte II, dicho en una línea: *todo circuito lineal se resuelve
  con Kirchhoff; elegir bien las incógnitas lo hace corto; los teoremas lo hacen
  reutilizable; los complejos lo extienden a la alterna; y el logaritmo lo extiende a todas
  las frecuencias a la vez.* Lo que sigue en la carrera —Señales y Sistemas, Electrónica
  Analógica, Control— reemplaza $j omega$ por la variable compleja $s$ y sigue exactamente
  desde acá.
]
