#import "../plantilla.typ": *

#modulo("Filtros activos y el amplificador diferencial, en serio", [
  Traducir un pedido de filtrado a una plantilla de cuatro números, sacar de ahí el orden
  de un Butterworth, ubicar sus polos y armarlo con etapas de primer orden y Sallen-Key de
  ganancia unitaria, eligiendo los componentes. Y volver al amplificador diferencial del
  Módulo 14 con la pregunta que ahí quedó abierta: cuánto modo común deja pasar de
  verdad, por qué el apareo de los resistores lo decide todo, y por qué el de
  instrumentación lo arregla.
])

El Módulo 12 filtró con un resistor y un capacitor, y el Módulo 14 le puso un operacional
al mismo RC para que amplificara y no se cargara (el ejercicio «Filtro activo pasa bajos
de primer orden»). Los dos son de *primer orden*: caen $20$ dB por década pasado el corte, y
eso es poco. Si el pedido es «dejá pasar la voz hasta 1 kHz y bajá 40 dB el chillido de
5 kHz», con $20$ dB por década hacen falta dos décadas de distancia y hay apenas
$log_10 5 = 0,7$. Hace falta caer más rápido, y caer más rápido es tener más polos. Este
módulo es eso: cuántos polos, dónde ponerlos y con qué circuito.

La fuente es el *Nilsson*, capítulo 15 («Filtros activos», p. 730), que es el que la guía del
parcial cita para el tema; el amplificador diferencial vuelve sobre el Módulo 14 de este
apunte.

== El pedido escrito como plantilla

Un filtro no se pide con una fórmula: se pide con lo que tiene que dejar pasar y lo que
tiene que frenar. Esa traducción tiene forma fija, y se llama *plantilla*.

#definicion("Plantilla de un pasa bajos")[
  Cuatro números:
  - $f_p$, la *frecuencia de paso*: hasta ahí la señal tiene que pasar casi entera;
  - $A_"máx"$, la *atenuación máxima* tolerada en la banda de paso (en dB): cuánto se le
    permite al filtro morder lo que tiene que dejar pasar;
  - $f_s$, la *frecuencia de rechazo* (la $s$ es de *stop*): desde ahí la señal tiene que
    estar frenada;
  - $A_"mín"$, la *atenuación mínima* exigida en la banda de rechazo (en dB).
  Entre $f_p$ y $f_s$ queda la *banda de transición*, donde el filtro hace lo que puede.
]

La plantilla se dibuja como dos zonas prohibidas: la curva del filtro no puede meterse
abajo de $-A_"máx"$ antes de $f_p$, ni arriba de $-A_"mín"$ después de $f_s$. Diseñar es
encontrar la curva más barata —la de menor orden— que pase por el corredor.

== El Butterworth: el más plano que se puede

Hay varias familias de curvas para pasar por el corredor (Butterworth, Chebyshev, Bessel,
elíptico), y cada una compra algo distinto. La que pide el programa, y la que se usa
cuando no hay un motivo para otra, es la de Butterworth (Stephen Butterworth, un ingeniero
británico que la publicó en 1930): la que tiene la banda de paso *lo más plana posible*.

#definicion("Pasa bajos de Butterworth de orden n")[
  $ |H(j omega)|^2 = 1/(1 + (omega\/omega_c)^(2 n)) $ <ec-butter>
  donde $n$ es el *orden* (la cantidad de polos) y $omega_c$ la pulsación de corte. Tres
  cosas se leen directo:
  - en $omega = omega_c$ vale $1\/2$ en potencia (o sea $-3$ dB) *para cualquier $n$*;
  - por debajo de $omega_c$ el término $(omega\/omega_c)^(2 n)$ es chiquito y la curva es casi
    plana: tanto más plana cuanto más grande $n$;
  - por encima, cae a $-20 n$ dB por década: cada polo más suma $20$ dB por década.
]

#circuito([Butterworth de orden 1 a 4 y la plantilla del Ejercicio 17.1])[
#graf-butterworth()
#pie-figura[Todas pasan por $-3$ dB en la de corte y se separan después: el orden es la
  pendiente. Con $n = 2$ la curva todavía está a $-28$ dB en 5 kHz y se mete en la zona
  prohibida; con $n = 3$ pasa justo, a $-41,9$ dB.]
]

=== El orden que pide la plantilla

Con $omega_c = omega_p$ (se pone el corte justo en el borde de la banda de paso, lo que
gasta toda la tolerancia en $A_"máx" = 3$ dB), @ec-butter evaluada en $f_s$ tiene que dar
al menos $A_"mín"$. Despejando $n$ en el caso general (Nilsson §15.4, p. 749):

$ n >= log_10 ((10^(0,1 A_"mín") - 1)\/(10^(0,1 A_"máx") - 1)) / (2 log_10 (f_s\/f_p)) $ <ec-orden>

y $n$ se redondea *para arriba*: no existen los filtros de orden 2,86.

=== Dónde están los polos

Los polos de un Butterworth tienen una geometría limpísima: están sobre la circunferencia
de radio $omega_c$ en el semiplano izquierdo, repartidos a ángulos iguales —separados
$180 degree\/n$— y simétricos respecto del eje real. Se agrupan de a pares conjugados, y
cada par es un factor de segundo orden $s^2 + (omega_c\/Q) s + omega_c^2$ con su propio $Q$
(el del Módulo 16); si $n$ es impar sobra uno, real, en $-omega_c$. Normalizados a
$omega_c = 1$:

#figure(
  table(
    columns: (0.5fr, 3fr, 2fr),
    align: (center, left, left),
    table.header([*$n$*], [*Denominador normalizado*], [*$Q$ de cada par*]),
    [1], [$s + 1$], [—],
    [2], [$s^2 + 1,414 thin s + 1$], [$0,707$],
    [3], [$(s + 1)(s^2 + s + 1)$], [$1$],
    [4], [$(s^2 + 0,765 thin s + 1)(s^2 + 1,848 thin s + 1)$], [$1,307$ y $0,541$],
  ),
  caption: [Los polinomios de Butterworth hasta orden 4 (Nilsson §15.4). Para usarlos, $s$ se reemplaza por $s\/omega_c$],
)

#block(breakable: false)[#clave[
  *Diseñar un Butterworth de orden $n$ es armar una cascada*: una etapa de segundo orden
  por cada par de polos, con el $Q$ de la tabla, y una de primer orden si $n$ es impar.
  Como cada etapa tiene un operacional a la salida, las etapas no se cargan entre sí y
  las transferencias se *multiplican*. Ésa es la ventaja enorme de lo activo sobre lo
  pasivo: con RLC pasivos, agregar una etapa le cambia la curva a la anterior.
]]

== El Sallen-Key de ganancia unitaria

La etapa de segundo orden más usada es la de Sallen y Key (dos ingenieros del MIT, 1955):
un seguidor de tensión del Módulo 14 con dos resistores y dos capacitores adelante.

#circuito([Pasa bajos Sallen-Key de ganancia unitaria])[
#fig-sallen-key()
#pie-figura[El operacional es un seguidor: $v_o = v_B$. El filtro es la cadena $R$–$R$–$C_2$,
  y la trampa está en $C_1$, que no va a masa sino a la *salida*: es una realimentación
  positiva local que levanta la curva cerca del corte y le da el $Q$.]
]

La idea, antes de las cuentas. Sin $C_1$, el circuito sería dos RC en cascada que se cargan
entre sí, y dos RC pasivos en cascada nunca dan un $Q$ mayor que $0,5$: polos reales, curva
blanda. $C_1$ toma una muestra de la salida y la reinyecta en el medio de la cadena, justo
donde la señal se está perdiendo, y la sostiene. Cuanto más grande $C_1$ comparado con
$C_2$, más se sostiene y más alto el $Q$.

*La transferencia, por nodos* (el procedimiento del Módulo 14, con impedancias). Hay dos
nodos desconocidos: $A$, entre los dos resistores, y $B$, la entrada no inversora, que por
el seguidor vale $v_o$. Con los dos resistores iguales a $R$:

- LKC en $B$: lo que llega por $R$ se va por $C_2$, $(v_o - v_A)\/R + s C_2 v_o = 0$, de donde
  $v_A = v_o (1 + s R C_2)$.
- LKC en $A$: $(v_A - v_i)\/R + (v_A - v_o)\/R + s C_1 (v_A - v_o) = 0$.

Reemplazando la primera en la segunda y despejando:

$ H(s) = v_o/v_i = 1/(R^2 C_1 C_2 thin s^2 + 2 R C_2 thin s + 1) $ <ec-sk>

Comparado con la forma estándar $omega_0^2\/(s^2 + (omega_0\/Q) s + omega_0^2)$ del Módulo 16:

$ omega_0 = 1/(R sqrt(C_1 C_2)) quad quad quad Q = 1/2 sqrt(C_1/C_2) $ <ec-sk-diseno>

#clave[
  *Las dos perillas están separadas, y eso es lo que lo hace cómodo.* El $Q$ lo fija sólo
  el cociente de los capacitores; la frecuencia, el valor de $R$. La receta de diseño sale
  sola: se elige $C_2$ (un valor que haya en el cajón), se pone $C_1 = 4 Q^2 C_2$, y se
  calcula $R$ con la de $omega_0$. Y la ganancia en continua es $1$ siempre, que es lo que
  dice el nombre.
]

Para un *pasa altos* se intercambian los resistores con los capacitores:
la misma topología, con las mismas cuentas en espejo. Y si los valores que salen son
incómodos, se escala: se diseña el *prototipo* con $omega_c = 1$ rad/s y $R = 1 Omega$, y se
multiplica cada $R$ por un $k_m$ y se divide cada $C$ por $k_m k_f$, con $k_f = omega_c$ (la
receta de «cambio de escala» que trae la guía del parcial, Nilsson §15.2, p. 738).

#ejercicio("Un Butterworth diseñado desde la plantilla")[
  Se pide un pasa bajos que deje pasar hasta $f_p = 1$ kHz con no más de $3$ dB de
  atenuación, y que en $f_s = 5$ kHz atenúe al menos $40$ dB. Hay capacitores de $10$ nF.

  *1. El orden*, con @ec-orden:
  $ n >= log_10 ((10^4 - 1)\/(10^"0,3" - 1)) / (2 log_10 5) = (4,002)/(1,398) = 2,86
    quad arrow.r quad n = 3 $
  Con $n = 2$ no alcanza: en 5 kHz daría $10 log_10 (1 + 5^4) = 28$ dB.

  *2. Los polos.* El polinomio de la tabla es $(s + 1)(s^2 + s + 1)$ con $s arrow.r s\/omega_c$
  y $omega_c = 2 pi dot 1000 = 6283$ rad/s: un polo real en $-6283$ rad/s y un par
  complejo de $Q = 1$, sobre la circunferencia de radio $6283$, a $plus.minus 120 degree$.

  *3. La etapa de primer orden*: un RC seguido de un seguidor de tensión (para que la
  etapa siguiente no lo cargue). $R C = 1\/omega_c$, con $C = 10$ nF:
  $R = 1\/(6283 dot 10^(-8)) = 15,92 "k"Omega$.

  *4. La etapa de segundo orden*: un Sallen-Key con $Q = 1$. Con @ec-sk-diseno,
  $C_2 = 10$ nF y $C_1 = 4 dot 1^2 dot 10 = 40$ nF (dos de $20$ en paralelo, o el
  comercial de $39$, que mueve el $Q$ a $0,99$); y
  $R = 1\/(6283 dot sqrt(40 dot 10 dot 10^(-18))) = 1\/(6283 dot 2 dot 10^(-8)) = 7,96 "k"Omega$.

  *5. Lo que da*, con @ec-butter y $n = 3$: en 1 kHz, $10 log_10 2 = 3,0$ dB de atenuación,
  justo el borde; en 5 kHz, $10 log_10 (1 + 5^6) = 41,9$ dB, que cumple los 40 con
  $1,9$ dB de margen.

  *6. Segundo camino: el circuito resuelto por nodos*, sin la fórmula de Butterworth. Con
  los valores elegidos (los dos RC de la etapa 1 y los cuatro componentes del
  Sallen-Key), las ecuaciones de nodos del circuito completo resueltas como sistema
  lineal en $500$, $1000$, $2000$ y $5000$ Hz dan la misma atenuación que @ec-butter, y las
  tres raíces del denominador del circuito tienen módulo $6283$ rad/s: están sobre la
  circunferencia (`fase3-cuentas.py`, ejercicio 17.1).
]

#atencion[
  *La tolerancia de los componentes se come el margen.* Con capacitores al $10 thin %$ el
  $Q$ del Sallen-Key puede caer en cualquier lado entre $0,9$ y $1,1$, y la frecuencia
  moverse otro tanto: los $1,9$ dB de margen del ejercicio no son un lujo. En el banco se
  mide la curva —el barrido del Módulo 15 sirve igual en LTspice— antes de dar el filtro
  por bueno. Y el operacional tiene que tener ancho de banda de sobra: el control de
  realidad del ejercicio de primer orden del Módulo 14 vale acá también.
]

== El amplificador diferencial, visto desde el modo común

El Módulo 14 dedujo el restador: con los dos pares de resistores iguales, $v_o =
(R_2\/R_1)(v_2 - v_1)$, y todo lo que las dos entradas tienen en común desaparece. Quedó
dicho que eso «depende enteramente de que los dos pares sean iguales». Acá se pone en
números cuánto.

Dos tensiones cualesquiera se pueden escribir como un promedio más una diferencia:

#definicion("Modo diferencial y modo común")[
  $ v_d = v_2 - v_1 quad quad quad v_"cm" = (v_1 + v_2)/2 $
  La $v_d$ es la señal que interesa (la diferencia que mide un sensor); la $v_"cm"$, lo que
  las dos entradas tienen en común: el zumbido de 50 Hz que se acopla igual a los dos
  cables, o los 2,5 V de reposo de un puente alimentado con 5 V. Un amplificador lineal
  responde a cada una con su propia ganancia:
  $ v_o = A_d thin v_d + A_"cm" thin v_"cm" $
  y la *relación de rechazo de modo común* compara las dos:
  $ "CMRR" = |A_d \/ A_"cm"| quad quad "CMRR"_"dB" = 20 log_10 "CMRR" $ <ec-cmrr>
]

En el restador ideal $A_"cm" = 0$ y el CMRR es infinito. Con un solo resistor corrido una
fracción $epsilon$ de su valor, la cuenta (hecha abajo con números) da

$ "CMRR" approx (1 + R_2\/R_1)/epsilon $ <ec-cmrr-apareo>

#clave[
  *El CMRR de un restador lo fija el apareo, no el operacional.* Con resistores al
  $1 thin %$ y ganancia $10$, @ec-cmrr-apareo da $11\/0,01 = 1100$: unos $61$ dB, por más
  que el operacional traiga 90 dB en su hoja de datos. Por eso los diferenciales serios se
  compran con los resistores ya apareados adentro (Módulo 14, «Amplificador de
  instrumentación», la caja de laboratorio).
]

#ejercicio("Cuánto zumbido deja pasar un restador desapareado")[
  El restador del Módulo 14 con $R_1 = 10 "k"Omega$ y $R_2 = 100 "k"Omega$ en las dos ramas,
  salvo el $R_2$ que va de la entrada no inversora a masa, que salió de $101 "k"Omega$ (un
  $1 thin %$ alto). Se pide $A_d$, $A_"cm"$ y el CMRR; y qué cambia con un amplificador de
  instrumentación cuya primera etapa tiene ganancia $10$.

  *1. La salida general.* La entrada no inversora es un divisor:
  $v_y = k thin v_2$ con $k = 101\/(10 + 101) = 0,9099$. La LKC en el nodo inversor, igual
  que en el Módulo 14, da $v_o = v_y (1 + R_2\/R_1) - v_1 R_2\/R_1$, o sea
  $ v_o = 11 thin k thin v_2 - 10 thin v_1 $

  *2. Pasar a modos.* Con $v_1 = v_"cm" - v_d\/2$ y $v_2 = v_"cm" + v_d\/2$:
  $ A_"cm" = 11 k - 10 = 10,0090 - 10 = 0,0090 quad quad
    A_d = (11 k + 10)/2 = 10,005 $
  Con los resistores perfectos, $11 k$ habría dado justo $10$ y $A_"cm"$, cero.

  *3. El rechazo*, con @ec-cmrr: $"CMRR" = 10,005\/0,0090 approx 1110$, o sea $60,9$ dB. La
  aproximación @ec-cmrr-apareo daba $1100$: bien para estimar.

  *4. Qué significa.* Con $v_d = 10$ mV de señal y $v_"cm" = 1$ V de zumbido de 50 Hz, a
  la salida hay $100$ mV de señal y $9$ mV de zumbido: el zumbido entró casi entero en
  proporción a una señal chica. El circuito «resta», pero no resta bien.

  *5. Segundo camino: el circuito por nodos, sin la descomposición en modos.* Poniendo
  $v_1 = v_2 = 1$ V (modo común puro) y resolviendo el nodo inversor con el divisor, la
  salida da $0,0090$ V; con $v_1 = -0,5$ y $v_2 = +0,5$ (diferencial puro), $10,005$ V
  (`fase3-cuentas.py`, ejercicio 17.2).

  *6. El de instrumentación.* Su primera etapa (dos no inversores que comparten $R_G$, con
  $R_3 = 4,5 "k"Omega$ y $R_G = 1 "k"Omega$) tiene ganancia diferencial
  $G_1 = 1 + 2 R_3\/R_G = 10$ y ganancia de modo común $1$: si las dos entradas suben
  juntas, por $R_G$ no circula nada y las dos salidas copian la entrada. Entonces la señal
  llega al restador diez veces más grande y el zumbido igual que antes: el CMRR total
  mejora en el factor $G_1$, a $20 log_10 (10 dot 1110) = 80,9$ dB, *con el mismo restador
  desapareado*. Resuelto por nodos con los tres operacionales, da lo mismo.
]

#block(breakable: false)[#clave[
  *Por qué la instrumentación arregla lo que el restador no.* No es que sus resistores
  sean mejores: es que la ganancia se pone *antes* de la resta, en una etapa que no le da
  ganancia al modo común. Así la resta, que es la que se equivoca, trabaja con una señal
  ya grande. Es la misma idea de separar «lo que da ganancia» de «lo que da precisión» que
  el Módulo 14 nombró y acá tiene su número.
]]
