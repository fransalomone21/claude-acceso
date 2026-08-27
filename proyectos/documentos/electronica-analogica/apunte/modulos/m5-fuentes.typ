#import "../plantilla.typ": *

#modulo("Fuentes de alimentación lineales", [
  Reconocer cada etapa de una fuente y qué le hace a la señal, deducir y calcular el
  rizado de un filtro capacitivo, elegir el capacitor para un ripple dado, y diseñar una
  etapa reguladora con diodo zener verificando corrientes y potencias.
])

== Anatomía de una fuente lineal

La red entrega 220 V eficaces de alterna a 50 Hz. Un circuito electrónico necesita, por
ejemplo, 5 V de continua estables. Entre una cosa y la otra hay cuatro etapas, y cada una
resuelve *un solo* problema.

#circuito([Diagrama en bloques de una fuente de alimentación lineal])[
#fig-bloques-fuente()
]

+ *Transformador*: baja el valor pico de 311 V a algo manejable, y aísla galvánicamente el
  circuito de la red. Módulo 3.
+ *Rectificador*: convierte la alterna en una señal de un solo signo. Módulo 4.
+ *Filtro*: rellena los valles entre pulsos y deja una continua con un rizado pequeño.
+ *Regulador*: fija la salida en un valor exacto, independiente de la carga y del rizado
  que quedó.

#atencion[
  Las etapas 1 y 2 trabajan con la *red*. Al armar la fuente en el protoboard, el
  primario del transformador y sus conexiones son *220 V que matan*. Se conecta con el
  transformador desenchufado, se revisa, se aleja la mano, y recién ahí se enchufa. Nunca
  se toca el primario con la fuente energizada.
]

== El filtro capacitivo

Después del rectificador la señal tiene el signo correcto, pero cae a cero entre pulso y
pulso. Un capacitor en paralelo con la carga resuelve eso funcionando como un *reservorio*:
se carga hasta el pico cuando el rectificador entrega, y alimenta a la carga con esa
energía mientras el rectificador no entrega nada.

#circuito([Filtro capacitivo a la salida del rectificador])[
#fig-filtro-capacitivo()
#v(6pt)
#graf-rizado()
]

=== Deducción del rizado

Mientras el capacitor alimenta solo a la carga, se descarga. La corriente en un capacitor
vale

$ i = C (dif v)/(dif t) $

Como la descarga entre pulsos es una porción muy chica de la exponencial, se la aproxima
por una *recta*, lo que permite pasar de derivadas a incrementos:

$ I_"cc" = C (Delta V_r)/(Delta t) $

Falta saber cuánto dura esa descarga. El capacitor se recarga *una vez por cada pulso del
rectificador*, así que $Delta t = 1\/f_r$, donde $f_r$ es la frecuencia del ripple.
Reemplazando y despejando:

$ Delta V_r = I_"cc" / (f_r dot C) $ <ec-ripple>

Y de la misma expresión sale el capacitor necesario para un rizado deseado:

$ C = I_"cc" / (f_r dot Delta V_r) $ <ec-capacitor>

Como la tensión oscila entre $V_p$ y $V_p - Delta V_r$, el valor continuo de salida es el
promedio:

$ V_"cc" = V_p - (Delta V_r) / 2 $ <ec-vcc-filtro>

Y el rizado relativo, que es la cifra de mérito de la fuente:

$ r% = (Delta V_r) / V_"cc" dot 100 $ <ec-ripple-pct>

#clave[
  En la @ec-ripple, $f_r$ *no es la frecuencia de la red*: es la frecuencia con que el
  rectificador entrega pulsos. Vale *50 Hz en media onda* y *100 Hz en onda completa*
  (punto medio o puente). Ahí está la ventaja decisiva del puente: al duplicarse $f_r$, el
  rizado se reduce a la mitad con el mismo capacitor — o alcanza *un capacitor la mitad de
  grande* para el mismo rizado. Es el error más frecuente del módulo: usar 50 Hz en un
  puente.
]

#laboratorio[
  Los capacitores de filtro son *electrolíticos* y tienen *polaridad*: la banda con el
  signo menos va al negativo. Conectado al revés, un electrolítico se calienta y explota,
  literalmente. También tienen una tensión máxima impresa: para un pico de 17 V, se usa
  uno de 25 V o 35 V, nunca de 16 V.
]

#ejercicio("Rizado de un puente y de una media onda, comparados")[
  Entrada de 12 V#sub[ef], carga $R_L = 1$ k$Omega$, capacitor de filtro $C = 100 mu$F.
  Calcular la salida y el rizado con un puente de Graetz, y compararlo con media onda.
  (Es el corazón del TP N.º 7, partes 1 y 2.)

  *— Puente de Graetz —*

  *1. Valor pico, descontando los dos diodos del puente*:
  $ V_p = 12 dot sqrt(2) = 17 "V" quad arrow.r.double quad V_p' = 17 - 1,4 = 15,6 "V" $

  *2. Corriente continua de carga* (primera aproximación, $V_"cc" approx V_p'$):
  $ I_"cc" = V_p'/R_L = (15,6 "V")/(1000 Omega) = 15,6 "mA" $

  *3. Frecuencia del ripple*: puente $arrow.r$ $f_r = 2 dot 50 = 100$ Hz.

  *4. Rizado*, con la @ec-ripple:
  $ Delta V_r = I_"cc"/(f_r dot C) = (15,6 dot 10^(-3))/(100 dot 100 dot 10^(-6))
    = (15,6 dot 10^(-3))/(10^(-2)) = 1,56 "V" $

  *5. Tensión continua de salida*, con la @ec-vcc-filtro:
  $ V_"cc" = 15,6 - (1,56)/2 = 14,8 "V" $

  *6. Rizado porcentual*: $r% = 1,56\/14,8 dot 100 = 10,5%$.

  *— Media onda, mismo circuito —*

  Un solo diodo: $V_p' = 17 - 0,7 = 16,3$ V, y $f_r = 50$ Hz.
  $ I_"cc" = (16,3 "V")/(1000 Omega) = 16,3 "mA" quad arrow.r.double quad
    Delta V_r = (16,3 dot 10^(-3))/(50 dot 100 dot 10^(-6)) = 3,26 "V" $
  $ V_"cc" = 16,3 - 1,63 = 14,7 "V" quad arrow.r.double quad r% = 22,2% $

  *Conclusión*: con *el mismo capacitor y la misma carga*, el puente tiene *la mitad del
  rizado* que la media onda (10,5 % contra 22,2 %). No es por los diodos: es porque
  recarga el capacitor el doble de veces por segundo. Comparar con el Ejercicio 4.2, donde
  la misma media onda *sin capacitor* daba 5,2 V: el filtro subió la salida de 5,2 V a
  14,7 V. El capacitor no solo alisa, también *eleva* la tensión continua, porque la lleva
  del valor medio al valor de pico.
]

#ejercicio("Elegir el capacitor para un rizado dado")[
  Se quiere una fuente con puente de Graetz de 15 V y 500 mA, con un rizado *menor al 5 %*.
  ¿Qué capacitor hace falta?

  *1. Rizado admisible en volts*, de la @ec-ripple-pct:
  $ Delta V_r = (5%)/100 dot 15 "V" = 0,75 "V" $

  *2. Capacitor necesario*, con la @ec-capacitor ($f_r = 100$ Hz por ser puente):
  $ C = I_"cc"/(f_r dot Delta V_r) = (0,5 "A")/(100 "Hz" dot 0,75 "V")
    = (0,5)/(75) = 6,67 dot 10^(-3) "F" = "6667 µF" $

  *3. Valor comercial*: se elige el inmediato superior de la serie, *6800 µF*, o
  directamente *10 000 µF* si hay lugar. Nunca uno menor: el rizado quedaría por encima
  del pedido.

  *4. Tensión del capacitor*: el pico es de unos 16,5 V, así que se usa uno de *25 V*
  como mínimo.

  *Observación de diseño*: si la misma fuente fuera de media onda, con $f_r = 50$ Hz haría
  falta *el doble*: 13 300 µF. Los capacitores electrolíticos grandes son caros,
  voluminosos y de vida limitada. Ese es el argumento económico que decide el puente.
]

== El regulador con diodo zener

Después del filtro la tensión todavía tiene rizado, y además *cambia cuando cambia la
carga*. El regulador resuelve las dos cosas.

#definicion("Diodo zener")[
  Un zener es un diodo diseñado para trabajar *en polarización inversa*, en su zona de
  ruptura. En esa zona mantiene entre sus bornes una tensión prácticamente constante — la
  *tensión de zener* $V_Z$ — aunque la corriente que lo atraviesa varíe mucho. Se lo
  fabrica con valores normalizados: 3,3 V; 4,7 V; 5,1 V; 6,2 V; 9,1 V; 12 V…
]

#circuito([Curva característica del zener: el codo inverso es su zona de trabajo])[
#graf-curva-zener()
#pie-figura[Pasado el vértice, la tensión queda clavada en $V_Z$ aunque la corriente
  cambie muchísimo: eso es lo que regula. Hay que quedarse entre $I_(Z "mín")$ —por
  debajo la regulación se pierde— e $I_(Z "máx")$ —por encima se quema.]
]

#circuito([Regulador paralelo con diodo zener])[
#fig-regulador-zener()
#pie-figura[$I_S = I_Z + I_L$. El zener va con el cátodo hacia arriba: trabaja
  en polarización inversa.]
]

El zener va *en paralelo* con la carga, y una resistencia $R_S$ *en serie* limita la
corriente total. El mecanismo de regulación es el reparto: si la carga pide más corriente,
el zener cede parte de la suya; si la carga pide menos, el zener absorbe el sobrante. La
suma se mantiene, y con ella la tensión.

Las tres ecuaciones del circuito son:

$ I_S = I_Z + I_L quad quad quad
  I_L = V_Z / R_L quad quad quad
  R_S = (V_"in" - V_Z) / I_S $ <ec-zener>

=== Criterio de diseño

$R_S$ tiene que cumplir dos condiciones simultáneas, y hay que verificar las dos:

+ *En el peor caso de mínima*, con $V_"in"$ en su valor más bajo (el valle del ripple) y
  la carga consumiendo el máximo, tiene que sobrar corriente para que el zener siga
  regulando: $I_Z >= I_(Z "mín")$, típicamente 5 mA. Esto fija el *valor máximo* de $R_S$.
+ *En el peor caso de máxima*, con $V_"in"$ en su valor más alto y *sin carga*, toda la
  corriente pasa por el zener. Hay que verificar que no supere su potencia:
  $P_Z = V_Z dot I_Z <= P_(Z "máx")$.

$ R_(S "máx") = (V_("in mín") - V_Z) / (I_(Z "mín") + I_(L "máx")) $ <ec-rs>

#atencion[
  Si $R_S$ es *demasiado grande*, en el peor caso no queda corriente para el zener, el
  zener sale de la zona de ruptura y *la regulación desaparece*: la salida cae y sigue el
  ripple. Si $R_S$ es *demasiado chica*, en vacío el zener recibe toda la corriente y *se
  quema*. Las dos verificaciones son obligatorias; hacer solo una es el error típico.
]

#ejercicio("Fuente regulada con zener 1N4733")[
  Diseñar la etapa reguladora del TP N.º 8: salida de 5,1 V con zener *1N4733*
  ($V_Z = 5,1$ V, $P_(Z "máx") = 1$ W), carga $R_L = 1$ k$Omega$, alimentada por la fuente
  sin regular del ejercicio anterior ($V_"cc" = 14,8$ V con $Delta V_r = 1,56$ V).

  *1. Corriente de carga*:
  $ I_L = V_Z/R_L = (5,1 "V")/(1000 Omega) = 5,1 "mA" $

  *2. Peor caso de entrada mínima* — el valle del ripple:
  $ V_("in mín") = V_"cc" - (Delta V_r)/2 = 14,8 - 0,78 = 14,0 "V" $

  *3. Máxima $R_S$ admisible*, con la @ec-rs y $I_(Z "mín") = 5$ mA:
  $ R_(S "máx") = (14,0 - 5,1)/((5 + 5,1) dot 10^(-3)) = (8,9)/(10,1 dot 10^(-3)) = 881 Omega $

  *4. Valor comercial adoptado*: $R_S = 820 Omega$ (el valor E24 inmediato inferior;
  tomar uno mayor violaría la condición).

  *5. Verificación en el peor caso de máxima* — cresta del ripple y carga desconectada:
  $ V_("in máx") = V_"cc" + (Delta V_r)/2 = 15,6 "V" $
  $ I_(Z "máx") = (V_("in máx") - V_Z)/R_S = (15,6 - 5,1)/(820) = 12,8 "mA" $
  $ P_Z = V_Z dot I_(Z "máx") = 5,1 "V" dot 12,8 "mA" = 65 "mW" $
  Contra 1 W admisible: *sobra muchísimo*. El zener está seguro.

  *6. Potencia disipada en $R_S$*:
  $ P_(R_S) = (V_("in máx") - V_Z)^2/R_S = (10,5)^2/820 = 134 "mW" $
  Una resistencia de 1/4 W (250 mW) alcanza, pero queda al 54 % de su límite y se va a
  calentar. *Se elige una de 1/2 W*, que trabaja holgada.

  *7. Verificación de la condición mínima, ya con el valor adoptado*:
  $ I_S = (14,0 - 5,1)/820 = 10,9 "mA" quad arrow.r.double quad
    I_Z = I_S - I_L = 10,9 - 5,1 = 5,8 "mA" $
  Es mayor que los 5 mA mínimos: *el zener regula durante todo el ciclo*, incluso en el
  valle del ripple. Diseño verificado en ambos extremos.

  *Resultado esperado en el laboratorio*: en el punto 2 (antes del zener) el osciloscopio
  debe mostrar 14,8 V con 1,56 V#sub[pp] de rizado; en el punto 3 (después del zener),
  5,1 V con un rizado de apenas algunas decenas de milivolts. Esa reducción es la
  demostración de que la etapa regula.
]

== Reguladores integrados

En la práctica moderna el zener se reemplaza por un *regulador integrado de tres patas*:
la familia *78xx* para tensiones positivas (7805 = 5 V, 7812 = 12 V) y la *79xx* para
negativas. Internamente contienen un zener de referencia, un amplificador de error y un
transistor de paso, y agregan protección contra cortocircuito y contra sobretemperatura.

Se conectan con la entrada al filtro, la salida a la carga, la pata del medio a masa, y un
capacitor cerámico de 100 nF a cada lado. Requieren unos 2 V de diferencia entre entrada y
salida para funcionar. La fuente doble del TP N.º 7, parte 3, con un 7812 y un 7912, es la
forma industrial del mismo problema.

#tp("TP N.º 7 y 8 — II Cuatrimestre")[
  - *TP 7, parte 1 (media onda)*: Ejercicio 4.2 para el cálculo sin filtro, y el Ejercicio
    5.1 para el rizado con 100 µF.
  - *TP 7, parte 2 (puente)*: Ejercicio 5.1, primera mitad. La comparación medida contra
    calculada debe dar diferencias de menos del 10 %; si da más, revisar la tensión real
    del secundario con el tester, que casi nunca es exactamente 12 V.
  - *TP 7, parte 3 (fuente doble con punto medio)*: se calcula cada rama por separado,
    exactamente igual que el puente, y la rama negativa da los mismos números con signo
    opuesto. El punto medio es la masa de referencia.
  - *TP 8 (regulador zener)*: es el Ejercicio 5.3 completo. Prestar atención a la consigna
    "verificar que la corriente mínima de mantenimiento se cumpla *en todo momento*": eso
    significa verificar en el valle del ripple, no en el valor medio.
]
