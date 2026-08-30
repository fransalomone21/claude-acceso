#import "../plantilla.typ": *

#modulo("Cuadripolos", [
  Describir un circuito completo como una caja de cuatro terminales mediante sus
  parámetros $z$, $y$, $h$ o $A B C D$, y saber cuál conviene en cada caso; reconocer los
  parámetros $h$ como el modelo lineal del transistor del Módulo 6; y saber cuándo la
  conexión de dos cuadripolos en cascada se puede resolver multiplicando matrices y
  cuándo no.
])

La idea que gobierna este módulo es la misma que la de Thévenin, llevada un paso más
lejos: si una red de dos terminales se resume en dos números ($V_"th"$ y $R_"th"$), una
red de *cuatro* terminales —una entrada y una salida— se resume en cuatro. Y con esos
cuatro números se puede conectar la caja a otras cajas sin volver a mirar jamás lo que
tiene adentro.

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
#fig-cuadripolo()
#pie-figura[Convención: las dos corrientes se dibujan *entrando* al cuadripolo.]
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

== El buffer que falta, y el módulo que viene

El párrafo de arriba deja planteado un problema y no lo resuelve: para poner dos
cuadripolos en cascada sin que el segundo cargue al primero hace falta un componente de
impedancia de entrada infinita y de salida nula. Ese componente es el *amplificador
operacional*, y tiene módulo propio —el 14— por dos razones.

La primera es de tamaño: sus configuraciones, la deducción del cortocircuito virtual y
los tres casos donde ese cortocircuito *no* vale no entran como apéndice de otro tema.
La segunda es de método: el operacional no se resuelve con el álgebra de cuadripolos
sino con el análisis nodal del Módulo 8, así que pertenece a otra familia de
herramientas aunque sea, formalmente, un cuadripolo activo.
