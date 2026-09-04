#import "../plantilla.typ": *

#modulo("Simulación de circuitos: SPICE", [
  Escribir un circuito como netlist y leer el netlist de otro; elegir el análisis que
  corresponde a la pregunta; describir una excitación con `PULSE` y con `PWL` sabiendo qué
  significa cada parámetro; imponer condiciones iniciales; elegir el paso de integración
  con un criterio y no a ojo; barrer un componente con `.step`; medir sobre la curva; y
  —sobre todo— contrastar la simulación con el cálculo en vez de aceptarla porque «se ve
  bien».
])

Un simulador no reemplaza al cálculo ni al laboratorio: es un *tercer testigo*. El cálculo
dice qué debería pasar según el modelo, el laboratorio dice qué pasa de verdad, y la
simulación dice qué pasa según el modelo *cuando el modelo es demasiado grande para
resolverlo a mano*. Los tres tienen que converger, y cuando no convergen, la discrepancia
es el resultado más valioso de los tres.

De ahí sale la regla de este módulo, que es la misma del apunte entero: *una curva
simulada no es evidencia hasta que se le controlaron los números*. Una curva que «parece
correcta» es exactamente lo que produce un modelo mal armado, porque el simulador dibuja
con la misma prolijidad lo que está bien y lo que está mal.

== De dónde sale SPICE

#definicion("SPICE")[
  *SPICE* es la sigla de *Simulation Program with Integrated Circuit Emphasis*. Nació en
  1973 en la Universidad de California en Berkeley, escrito por Laurence Nagel bajo la
  dirección de Donald Pederson, como sucesor de un programa anterior llamado CANCER. Se
  liberó al dominio público, y ésa es la razón de que hoy todos los simuladores de
  circuitos —LTspice, PSpice, ngspice, Micro-Cap, el simulador de Multisim, los que traen
  los entornos de diseño de placas— sean SPICE por dentro y compartan la sintaxis.

  Lo que hace es resolver, paso de tiempo por paso de tiempo, el mismo sistema de
  ecuaciones del Módulo 8: *análisis nodal modificado*, que es el nodal de siempre con
  filas extra para las fuentes de tensión y para las variables que el nodal puro no puede
  escribir. En un circuito con diodos o transistores el sistema es no lineal y lo resuelve
  por iteraciones sucesivas —el método de Newton-Raphson—; en un transitorio, además,
  reemplaza las derivadas por diferencias finitas con una regla de integración
  (LTspice usa por defecto una trapezoidal modificada).

  Todo lo que aparece más abajo es *eso*: formas de decirle cuál es la red, cuáles son las
  excitaciones, desde qué estado arranca y con qué finura hay que avanzar el tiempo.
]

== El netlist: el circuito escrito

Debajo de cualquier esquema dibujado hay un archivo de texto: el *netlist*. Es la lista de
los componentes, y de cada uno dice a qué nodos está conectado y cuánto vale. Poder leerlo
y escribirlo importa por dos razones prácticas: es lo que se puede pegar en un informe, y
es donde se ve el error cuando el dibujo engaña.

#circuito([El primer circuito de la guía, con los nombres de nodo del netlist])[
#fig-spice-rc()
]

```
* RC de carga -- 01_RC_carga
V2   in  0   PULSE(0 5 10u 1p 0 100u)
R1   in  out 100
C1   out 0   100n
.tran 0 100us 0 1n
.end
```

Cada línea de componente sigue siempre el mismo orden:

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.header([*Nombre*], [*Nodo +*], [*Nodo −*], [*Valor*]),
    [`R1`], [`in`], [`out`], [`100` (ohm)],
    [`C1`], [`out`], [`0`], [`100n` (farad)],
    [`L1`], [`out`], [`0`], [`1m` (henry)],
    [`V2`], [`in`], [`0`], [`PULSE(...)` o un número],
    [`I1`], [`a`], [`b`], [`PWL(...)` o un número],
  ),
  caption: [La línea de un elemento: nombre, dos nodos y valor],
)

#definicion("Las tres reglas del netlist")[
  + *La primera letra del nombre dice qué es.* `R` resistor, `C` capacitor, `L` inductor,
    `V` fuente de tensión, `I` fuente de corriente, `D` diodo, `Q` bipolar, `M` MOSFET.
    No es una convención de estilo: el programa la usa para saber qué ecuación escribir.
  + *El nodo `0` es la referencia*, y tiene que existir. Es el mismo nodo de referencia del
    Módulo 8 y de las convenciones del apunte: todas las tensiones se informan contra él.
    Un circuito sin nodo `0` no tiene solución, porque el sistema queda con una incógnita
    de más.
  + *El primer nodo es el `+`.* De eso depende el signo de la tensión informada y —con la
    convención pasiva— el signo de la potencia. Un elemento con los nodos al revés no da
    error: da el resultado con el signo cambiado, que es peor.
]

#atencion[
  *Todo nodo tiene que tener al menos dos elementos, y todo nodo tiene que tener camino de
  continua a la referencia.* Un nodo colgado de un solo componente, o un nodo que sólo se
  conecta al resto a través de capacitores, deja el sistema sin solución. El error típico
  de LTspice es «This node is floating» o «Timestep too small», y casi nunca dice cuál es
  el nodo culpable: se busca a mano, y suele ser un cable que no llegó a tocar el pin.
]

== Los cuatro análisis

Cada pregunta tiene su análisis, y elegir el que no es cuesta media hora.

#figure(
  table(
    columns: (auto, 1fr, auto),
    align: (left, left, left),
    table.header([*Directiva*], [*Qué contesta*], [*Módulo*]),
    [`.op`],
      [El punto de reposo: todas las tensiones y corrientes en continua permanente, con
       capacitores abiertos e inductores en corto.],
      [10],
    [`.dc`],
      [Barre una fuente de continua y dibuja la característica resultante — la curva del
       diodo, la recta de carga de un transistor.],
      [4 y 6],
    [`.tran`],
      [La respuesta en el *tiempo*: transitorios, conmutación, formas de onda. Es el
       análisis de este bloque.],
      [10],
    [`.ac`],
      [La respuesta en *frecuencia*: módulo y fase contra frecuencia, o sea el diagrama de
       Bode, calculado con fasores.],
      [11 y 12],
  ),
  caption: [Qué análisis contesta cada pregunta],
)

La directiva de transitorio se escribe

```
.tran  <tstep>  <tstop>  <tstart>  <tmax>
```

y en la práctica se usa casi siempre con `tstep = 0` —dejando que el programa elija cuánto
guardar— y con los otros tres puestos a mano. En `.tran 0 100us 0 1n`: simular hasta
100 µs, empezar a guardar desde 0, y *no dar nunca un paso más largo que 1 ns*. El último
número es el que importa y es el que se discute más abajo.

== Las fuentes que hacen falta acá

#definicion("PULSE: el escalón y la onda cuadrada")[
  ```
  PULSE(V1  V2  Tdelay  Trise  Tfall  Ton  Tperiod  Ncycles)
  ```
  - `V1` valor inicial, `V2` valor al que salta.
  - `Tdelay` cuánto espera antes del primer flanco.
  - `Trise` y `Tfall` duración de los flancos. *Nunca cero* en un circuito con inductores:
    un flanco perfectamente vertical es una derivada infinita y el simulador se atraganta.
  - `Ton` cuánto se queda en `V2`.
  - `Tperiod` el período. *Si se omite, hay un solo pulso*, y eso es lo que se quiere para
    estudiar un escalón.
  - `Ncycles` cuántos pulsos; vacío es «para siempre».

  El primer archivo de la guía usa `PULSE(0 5 10u 1p 0 100u)`: un salto de 0 a 5 V a los
  10 µs, con un flanco de 1 ps y sin período, o sea *un escalón*. Los 10 µs de espera no
  son decorativos: sirven para ver la línea de base antes del evento y para que el punto
  de operación quede establecido.
]

#definicion("PWL: la forma de onda dibujada a mano")[
  ```
  PWL(t1 v1  t2 v2  t3 v3  ...)
  ```
  *Piece-Wise Linear*, lineal por tramos: se dan los vértices y el programa une con rectas.
  Es la manera de meter en el simulador el pulso triangular del Módulo 10, o cualquier
  forma de onda medida.

  El pulso triangular de corriente de aquel ejercicio —sube a 2 A en 2 ms y baja a cero en
  4 ms— se escribe:
  ```
  I1  0  n1  PWL(0 0  2m 2  6m 0)
  ```
  y con eso la bobina queda excitada exactamente por la corriente del gráfico. Vale la
  misma advertencia que con `PULSE`: dos puntos con el mismo tiempo y distinto valor
  piden un salto vertical, que en una fuente de corriente sobre una bobina es una tensión
  infinita.
]

Para el régimen permanente senoidal del Módulo 11 se usa `SIN(Voffset Vamp Freq ...)`, y
para el barrido en frecuencia del Módulo 12 basta con poner `AC 1` en la fuente y pedir
un `.ac`.

== Las condiciones iniciales

Es el punto donde la simulación y el método de los tres datos se tocan.

#definicion("Qué hace SPICE si no se le dice nada")[
  Antes del transitorio, el programa calcula el *punto de operación*: resuelve el circuito
  en continua permanente, con capacitores abiertos e inductores en corto. Ése es el estado
  del que arranca. Es decir: por omisión, SPICE arranca en el $t = 0^-$ del Módulo 10, y
  lo calcula solo.

  Para imponer otro estado hay dos herramientas:
  ```
  .ic V(vc)=3V              impone la tension inicial de un capacitor
  .ic I(L1)=50mA            impone la corriente inicial de un inductor
  ```
  y, en la propia directiva, la palabra `uic` —*use initial conditions*— que le dice que
  *no* calcule el punto de operación y arranque con lo que se le dio.
]

Los archivos 02 y 04 de la guía son justamente eso: un RC y un RL *sin fuente*, cuya única
excitación es la energía inicial. Son la respuesta natural del Módulo 10 —la exponencial pura,
sin fuente— medida por el simulador, y son el caso más limpio para comprobar $tau$.

#clave[
  *Cuál de las dos formas usar.* Si el enunciado describe un circuito que estuvo en régimen
  con una llave en una posición y conmuta en $t = 0$, lo natural es dibujar el estado
  previo y dejar que el programa calcule el punto de operación: eso reproduce el problema
  tal cual. Si el enunciado da directamente $v_C (0)$ o $i_L (0)$ —o si armar el estado
  previo es más trabajo que la cuenta—, se calcula el valor a mano y se lo impone con
  `.ic`. Las dos son legítimas; lo que no vale es imponer una condición inicial *y además*
  dejar el circuito previo, porque entonces no se sabe cuál de las dos ganó.
]

== El paso de integración: la trampa

El simulador no resuelve la ecuación diferencial: la reemplaza por una cuenta a pasos
finitos y va calculando punto por punto. Si los pasos son demasiado largos, el resultado
*no es una versión menos precisa* de la curva: es otra curva.

#circuito([La misma señal, calculada con un paso demasiado largo])[
#graf-paso-de-simulacion()
]

En el gráfico, la curva fina es la señal y los puntos son lo que el simulador calculó con
un paso de $0,9$ períodos. La poligonal que los une es lo que se ve en la pantalla, y no
tiene *nada* que ver con la señal: no oscila, no cruza por cero donde debe, y su
«amortiguamiento» es un artefacto. Nadie que mire sólo la curva gruesa sospecharía nada.

#definicion("El criterio de paso — el de la guía de la cátedra")[
  + *En primer orden*: paso máximo no mayor que $tau \/ 100$.
  + *En segundo orden subamortiguado*: además, al menos *100 puntos por período
    amortiguado*, o sea paso máximo $<= T_d \/ 100$, con $T_d = 2 pi \/ omega_d$.
  + Y el `tstop` tiene que llegar a $5 tau$ como mínimo (mejor $8 tau$) para ver el estado
    final, no sólo el transitorio.

  Los dos primeros se calculan *antes* de simular, con los valores de los componentes. No
  se ajustan mirando la curva hasta que «se ve bien»: ése es el procedimiento que produce
  curvas que se ven bien y están mal.
]

#atencion[
  *El paso máximo no es lo mismo que el paso de guardado.* El cuarto número de `.tran` es
  `tmax`, el paso *máximo de cálculo*: le pone un techo al avance del tiempo. El primero,
  `tstep`, sólo dice cada cuánto guardar para el gráfico. Aumentar el segundo hace el
  archivo más grande y no mejora la exactitud; el que hay que apretar es el cuarto.

  Y hay un control gratis: el archivo de registro del simulador informa `tranpoints`
  (cuántos puntos calculó), `accept` y `rejected` (cuántos pasos aceptó y cuántos tuvo que
  rehacer por no converger). Muchos pasos rechazados es la señal de que el modelo tiene
  una discontinuidad —un flanco de duración cero, típicamente— y no de que el paso sea
  chico.
]

== Barrer un parámetro: `.step`

Comparar tres regímenes de un RLC no se hace con tres archivos: se hace con uno y una
lista de valores.

#circuito([El RLC serie de la guía: un solo archivo, cuatro valores de $R$])[
#fig-spice-rlc()
]

```
V1  in  0   PULSE(0 5 10u 100n 100n 2m 4m)
R   in  a   {R}
L   a   vc  1m
C   vc  0   100n
.step param R list 10 100 632.46 2k
.tran 0 100u 0 50n
```

Las llaves de `{R}` dicen «acá va el parámetro», y `.step param R list …` corre la
simulación una vez por cada valor de la lista, superponiendo las curvas. Es la forma
correcta de mostrar los tres regímenes del Módulo 10: *lo único que cambia entre las
curvas es el número que se está estudiando*.

#atencion[
  *A un valor de una lista ajena se le hacen las cuentas antes de usarlo.* Con los valores
  que tiene ese mismo archivo ($L = 1$ mH y $C = 100$ nF), la resistencia crítica del RLC
  serie vale
  $ R_"crít" = 2 sqrt(L/C) = 2 sqrt((10^(-3))/(10^(-7))) = 2 dot 100 = 200 thin Omega $
  y no $632,46 thin Omega$. Ese $632,46$ es exactamente $2 sqrt(L\/C)$ para
  $L = 10$ mH —la inductancia del archivo *paralelo*, no la de éste—, así que en la
  simulación tal como está, ese caso sale *sobreamortiguado* con $zeta = "3,16"$, no
  crítico.

  El circuito paralelo de la guía sí está bien: con $L = 10$ mH y $C = 100$ nF,
  $R_"crít" = 1/2 sqrt(L\/C) = "158,11" thin Omega$, que es el valor de su lista.

  No hace falta creerle a este párrafo: se recalculan las dos y se mira si la curva de
  $632,46 thin Omega$ se pasa del valor final o no. Ése es el punto —*el control se hace
  siempre, incluso sobre un archivo que viene funcionando*—, y es la razón por la que este
  módulo existe.
]

== Medir sobre la curva

Mirar no alcanza; hay que sacar números. Hay dos caminos y conviene usar los dos.

*Los cursores.* Se pinchan sobre la curva y dan el par $(t, v)$ de cada uno más la
diferencia entre ambos. Es lo que se usa para medir $T_d$ entre dos picos, o el instante
en que la respuesta llega al $63,2 %$ del salto. Es rápido y es suficiente para el informe.

*La directiva `.meas`.* Le pide al programa que mida y escriba el resultado en el archivo
de registro, sin intervención de la mano:

```
.meas TRAN vfinal  FIND V(out)  AT 500u
.meas TRAN vpico   MAX V(out)
.meas TRAN t63     WHEN V(out)=3.16
.meas TRAN Edis    INTEG V(out)*I(R1)
```

La última es la más útil de este bloque: `INTEG` integra en el tiempo, así que
`V(R)*I(R)` integrado *es* la energía disipada en el resistor, que es el lado izquierdo del balance de energía
del Módulo 10. Comparar ese número con $1/2 L I_0^2$ es el control de energía hecho por
el propio simulador, y es el que la guía pide en tres problemas.

#clave[
  *Cómo se grafican potencia y energía en LTspice.* Con `Alt` + clic sobre el cuerpo de un
  componente, el programa muestra su potencia instantánea. Y con clic derecho sobre el
  rótulo de una traza se puede escribir cualquier expresión de las señales disponibles: con
  eso se grafica $1/2 L thin I("L1")^2$ y se ve la energía almacenada directamente, que es
  lo que pide el problema del pulso triangular.
]

== Cómo se contrasta con el cálculo

#definicion("Los cinco controles de un transitorio simulado")[
  Antes de aceptar una curva, se verifican estos cinco números *contra el cálculo hecho a
  mano*, no contra la impresión visual:

  + *$x(0^+)$* — el valor inmediatamente después de la conmutación. Con los cursores
    puestos justo antes y justo después del evento se ve además qué saltó y qué no.
  + *$x(infinity)$* — el valor final, medido con el `tstop` bien largo.
  + *$tau$*, o *$alpha$ y $omega_d$* si es de segundo orden. En primer orden, el punto del
    $63,2 %$ o del $36,8 %$; en segundo, el período entre picos y el decremento
    logarítmico.
  + *La continuidad* — que $i_L$ y $v_C$ no salten, y que las otras variables sí lo hagan
    donde corresponde.
  + *El balance de energía* — la integral de $p_R$ contra la energía inicial almacenada.
]

#atencion[
  *«Parece correcta» no es un control.* Todas estas curvas se ven razonables: una
  exponencial con el $tau$ equivocado, un sobreamortiguado que debía ser crítico, una
  oscilación con el signo cambiado, una respuesta cuyo valor final es el del circuito
  *anterior* a la conmutación. Ninguna de las cuatro se detecta mirando la forma; las
  cuatro se detectan con los cinco números de arriba.

  Cuando un número no coincide, la discrepancia es información, no un fracaso: casi siempre
  apunta a un nodo mal conectado, a una condición inicial que no se aplicó, o a un modelo
  que tiene un parásito que el cálculo no tenía.
]

#ejercicio("Del enunciado al netlist, y del netlist al control")[
  Se pide simular la *respuesta natural* de un RL con $L = 1$ mH, $R = 100 thin Omega$ e
  $i_L (0) = 50$ mA —el archivo `04` de la guía— y dejar por escrito qué se va a controlar
  antes de mirar la pantalla.

  *Paso 1: la predicción, a mano.*
  $ tau = L/R = (10^(-3))/(100) = 10 thin mu s $
  $ i_L (0^+) = 50 "mA" quad ("no salta") quad quad i_L (infinity) = 0 $
  $ v_L (0^+) = -R thin i_L (0^+) = -100 dot "0,050" = -5 "V" $
  El signo menos no es un error: sin fuente, la bobina *entrega* y la polaridad de $v_L$
  se invierte respecto de la de carga para sostener la corriente.
  $ w_L (0) = 1/2 L I_0^2 = 1/2 dot 10^(-3) dot ("0,050")^2 = "1,25" thin mu J $

  *Paso 2: el netlist.* Sin fuente, con la corriente inicial impuesta:
  ```
  L1  a  0   1m
  R1  a  0   100
  .ic I(L1)=50mA
  .tran 0 100u 0 50n
  .end
  ```
  El `tstop` de 100 µs son $10 tau$, más que suficiente para ver el estado final. El paso
  máximo de 50 ns es $tau\/200$: la mitad de lo que exige el criterio, que pide
  $tau\/100 = 100$ ns.

  *Paso 3: los cinco controles*, escritos antes de simular.
  + $i_L$ arranca en 50 mA y *no salta* en $t = 0$.
  + $i_L (infinity) = 0$, alcanzado a $5 tau = 50 thin mu s$.
  + A $10 thin mu s$ la corriente vale $50 dot "0,368" = "18,4"$ mA.
  + $v_L (0^+) = -5$ V, y decae con el mismo $tau$.
  + `.meas TRAN Edis INTEG V(a)*I(R1)` tiene que dar $"1,25" thin mu J$.

  *Qué se hace si el quinto no da.* Es el control más sensible de los cinco, porque
  acumula: si la energía disipada sale menor que $1,25 thin mu J$, el `tstop` es corto y
  la integral se cortó antes de tiempo; si sale mayor, hay una fuente encendida que no
  debería estarlo, o la condición inicial no se aplicó y el simulador arrancó de su propio
  punto de operación.
]

== Los parásitos en el modelo

La segunda pasada que pide la guía —volver a simular con componentes reales— no se hace
agregando resistores al dibujo: los propios elementos los tienen adentro.

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Elemento*], [*Atributo*], [*Qué modela*]),
    [Inductor], [`Rser`], [la resistencia del bobinado (DCR)],
    [Inductor], [`Cpar`], [la capacidad entre espiras],
    [Capacitor], [`RSer`], [la ESR],
    [Capacitor], [`Rpar`], [la resistencia de fuga del dieléctrico],
    [Capacitor], [`Lser`], [la ESL de los terminales],
    [Fuente], [`Rser`], [la resistencia de salida del generador],
  ),
  caption: [Dónde se ponen los parásitos del Módulo 10 en el simulador],
)

En el netlist se escriben pegados al valor: `L1 a b 1m Rser=0.8`. Y si no se tiene la hoja
de datos, se declara el valor supuesto: una simulación con un parásito inventado y
declarado es honesta; una con un parásito inventado y callado, no.

#clave[
  *Qué se hace con la diferencia.* La comparación útil no es «da distinto», sino *cuál* de
  los cinco números cambió y *cuánto*. Un $tau$ más largo que el calculado apunta a una
  resistencia de más —`Rser` de la fuente, DCR de la bobina—; un valor final más bajo, a
  una caída en algo que el modelo ideal no tenía; un amortiguamiento mayor que el
  calculado, otra vez a las resistencias serie. Con eso se puede *proponer una medición*:
  si se sospecha del DCR, se mide la bobina con el óhmetro y se ve si el número explica la
  diferencia.
]

== Los seis circuitos de la guía

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Archivo*], [*Qué es*], [*Qué hay que controlar*]),
    [`01_RC_carga`],
      [RC con escalón. $R = 100 thin Omega$, $C = 100$ nF],
      [$tau = R C = 10 thin mu s$; el $63,2 %$ a $1 tau$; $v_C (infinity) = 5$ V; el salto
       de $i_C$ en el flanco.],
    [`02_RC_condicion_inicial`],
      [RC sin fuente, con `.ic V(vc)=3V`],
      [Respuesta natural: arranca en 3 V, el mismo $tau = 10 thin mu s$, y a $5 tau$ está
       en cero.],
    [`03_RL_carga`],
      [RL con escalón. $R = 100 thin Omega$, $L = 1$ mH],
      [$tau = L\/R = 10 thin mu s$; $i_L (infinity) = 50$ mA; $v_L (0^+) = 5$ V y decae.],
    [`04_RL_condicion_inicial`],
      [RL sin fuente, con `.ic I(L1)=50mA`],
      [$i_L$ arranca en 50 mA y no salta; $v_L (0^+) = -R I_0 = -5$ V; la energía
       $1/2 L I_0^2 = "1,25" thin mu J$ tiene que aparecer entera en el resistor.],
    [`05_RLC_serie`],
      [RLC serie con `.step` de cuatro valores de $R$],
      [$omega_0 = 10^5$ rad/s $arrow.r f_0 = "15,9"$ kHz; $R_"crít" = 200 thin Omega$;
       clasificar los cuatro casos antes de mirar las curvas.],
    [`06_RLC_paralelo`],
      [RLC paralelo con `.step` de tres valores de $R$],
      [$omega_0 = 31623$ rad/s $arrow.r f_0 = "5,03"$ kHz;
       $R_"crít" = "158,11" thin Omega$; verificar que $R$ *chica* amortigua más.],
  ),
  caption: [Los seis archivos, con el control que hay que hacerle a cada uno],
)

#laboratorio[
  *El orden que ahorra tiempo.* Calcular, simular, medir — en ese orden y sin saltear.

  + *Calcular primero, y escribir el número.* $tau$, o $alpha$ y $omega_d$, más los
    valores inicial y final. En un papel, antes de abrir el simulador. Una predicción
    escrita después de ver la curva no es una predicción.
  + *Simular y controlar los cinco números.* Si alguno no da, se arregla el modelo, no la
    predicción.
  + *Medir en el laboratorio.* Ahí aparecen los parásitos de verdad, y la comparación
    contra la simulación ideal dice cuál domina.

  El paso 1 es el que se saltea siempre, y es el único que hace que los otros dos sirvan
  de algo: sin un número escrito de antemano, cualquier curva confirma cualquier cosa.
]

#tp("Con el Módulo 10 y con los TP N.º 5 y 7")[
  Este módulo no tiene TP propio: es la herramienta con la que se hacen los otros. Los seis
  archivos de arriba son el Módulo 10 entero, medido; y el mismo `.tran` sobre la fuente
  del TP N.º 7 dibuja el rizado que allá se calcula con la fórmula lineal, con lo que se
  puede ver de una sola mirada cuánto se aparta la aproximación de la exponencial real.

  Para el TP N.º 5, la simulación sirve de banco de pruebas del instrumento: se simula el
  RC excitado con onda cuadrada, se mide $tau$ sobre la curva simulada con los cursores
  igual que se haría en la pantalla del osciloscopio, y recién después se va al
  laboratorio a hacer la misma medición sobre el circuito real. Las tres mediciones
  —fórmula, simulador, osciloscopio— tienen que dar lo mismo dentro de la tolerancia de
  los componentes; si una se sale, es la que hay que explicar.
]
