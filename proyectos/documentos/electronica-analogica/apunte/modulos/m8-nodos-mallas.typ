#import "../plantilla.typ": *

#modulo("Resolución sistemática: nodos, supernodos, mallas y supermallas", [
  Resolver cualquier red lineal por el camino corto: elegir el método que menos
  ecuaciones plantea, escribir el sistema *por inspección* sin recorrer lazos a mano,
  tratar las fuentes que rompen el método con supernodo o supermalla, incorporar fuentes
  controladas, y verificar el resultado resolviendo el mismo circuito por el otro camino.
])

El Ejercicio 7.2 resolvió un circuito de dos mallas con tres ecuaciones. Se puede hacer
mejor. La idea de este módulo es una sola y es profunda: *cambiar las incógnitas*. En vez
de buscar las $b$ corrientes de rama, se busca un conjunto más chico de variables a
partir del cual todo lo demás se calcula. Según cuál se elija, sale un método u otro.

#clave[
  - Si las incógnitas son las *tensiones de los nodos*, la LKT queda satisfecha
    automáticamente (la tensión de una rama es siempre la diferencia de dos tensiones de
    nodo, y toda vuelta cerrada da cero solo). Queda escribir LKC: *análisis de nodos*,
    $n - 1$ ecuaciones.
  - Si las incógnitas son las *corrientes de malla*, la LKC queda satisfecha
    automáticamente (cada corriente de malla entra y sale de cada nodo que toca). Queda
    escribir LKT: *análisis de mallas*, $b - n + 1$ ecuaciones.

  Cada método paga una ley por adelantado para no tener que escribirla.
]

== Análisis de nodos

=== El nodo de referencia

Se elige *un* nodo y se le asigna, por definición, $v = 0$. Todas las demás tensiones de
nodo se miden respecto de él. La elección es libre y no cambia el resultado (las
diferencias de tensión son las mismas), pero sí cambia cuánto trabajo cuesta:

#laboratorio[
  Elegir como referencia el nodo *con más ramas concurrentes*, y si hay fuentes de
  tensión conectadas a masa, el nodo al que están conectadas: cada fuente de tensión con
  un terminal en la referencia elimina una incógnita del sistema, porque la tensión del
  otro nodo pasa a ser *dato*. En un circuito real, la referencia es casi siempre el
  chasis o el terminal negativo de la fuente.
]

=== La ecuación de un nodo

Sea el nodo $k$ con tensión $v_k$, conectado por conductancias $G_(k j)$ a otros nodos
$j$, y con fuentes de corriente que le inyectan $I_k$ en total. La corriente que sale de
$k$ hacia $j$ vale, por la ley de Ohm,

$ i_(k j) = G_(k j) (v_k - v_j) $ <ec-rama-nodal>

y la LKC en el nodo $k$ dice que todo lo que sale es igual a lo que entra:

$ sum_j G_(k j) (v_k - v_j) = I_k $ <ec-nodo>

Reagrupando, esa ecuación es
$ (sum_j G_(k j)) v_k - sum_j G_(k j) v_j = I_k $,
y de ahí sale la regla que evita tener que deducirla cada vez.

#definicion("El sistema nodal por inspección")[
  Para una red *sin fuentes de tensión ni fuentes controladas*, el sistema
  $bold(G) bold(v) = bold(i)$ se escribe mirando el dibujo:

  - *Diagonal* $G_(k k)$: la suma de *todas* las conductancias conectadas al nodo $k$.
    Siempre positiva.
  - *Fuera de la diagonal* $G_(k j)$: la suma de las conductancias conectadas *entre* el
    nodo $k$ y el nodo $j$, cambiada de signo. Siempre negativa o cero.
  - *Término independiente* $i_k$: la suma algebraica de las corrientes de las fuentes
    que *entran* al nodo $k$.

  La matriz $bold(G)$ resulta *simétrica* ($G_(k j) = G_(j k)$): es una consecuencia de
  que los resistores son elementos recíprocos, y es el primer control de que el sistema
  está bien escrito. Si no es simétrica, hay un error — o hay una fuente controlada,
  que es la única que la rompe legítimamente.
]

#circuito([Circuito para el análisis nodal])[
#fig-nodal-basico()
]

#ejercicio("Análisis nodal de dos nodos")[
  Datos: $I_A = 6$ A entrando al nodo 1, $I_B = 2$ A entrando al nodo 2,
  $R_1 = 2 Omega$, $R_2 = 4 Omega$, $R_3 = 4 Omega$.

  *1. Contar.* Nodos esenciales: 3 (incluida la referencia) $arrow.r.double$ $n - 1 = 2$
  ecuaciones. Por mallas serían $b - n + 1 = 4 - 3 + 1 = 2$: empatan, pero como todas las
  fuentes son de corriente, nodos es el camino natural.

  *2. Escribir por inspección.* Conductancias: $G_1 = 0,5$ S, $G_2 = 0,25$ S,
  $G_3 = 0,25$ S.
  $ mat(G_1 + G_2, -G_2; -G_2, G_2 + G_3) vec(v_1, v_2) = vec(I_A, I_B) $
  $ mat("0,75", -"0,25"; -"0,25", "0,50") vec(v_1, v_2) = vec(6, 2) $

  *3. Resolver.* Multiplicando ambas filas por 4 para sacar los decimales:
  $ 3 v_1 - v_2 = 24 quad (1) $
  $ - v_1 + 2 v_2 = 8 quad (2) $
  De (2), $v_1 = 2 v_2 - 8$. En (1): $3(2 v_2 - 8) - v_2 = 24 arrow.r 5 v_2 = 48$.
  $ v_2 = 9,6 "V" quad quad v_1 = 11,2 "V" $

  *4. Bajar a las corrientes de rama* con la @ec-rama-nodal:
  $ i_(R 1) = (11,2)/(2) = 5,6 "A", quad
    i_(R 2) = (11,2 - 9,6)/(4) = 0,4 "A", quad
    i_(R 3) = (9,6)/(4) = 2,4 "A" $

  *5. Controlar.* LKC en el nodo 1: $6 = 5,6 + 0,4$ ✓. En el nodo 2:
  $0,4 + 2 = 2,4$ ✓.
  Potencias: las fuentes entregan $6 dot 11,2 + 2 dot 9,6 = 86,4$ W; los resistores
  disipan $"5,6"^2 dot 2 + "0,4"^2 dot 4 + "2,4"^2 dot 4 = 62,72 + 0,64 + 23,04 = 86,4$ W.
  Tellegen cierra ✓.
]

== Supernodo: la fuente de tensión que rompe el método

El método nodal escribe, para cada nodo, la corriente de cada rama *en función de las
tensiones*. Con una fuente de tensión eso no se puede: la corriente que circula por una
fuente de tensión ideal *no está determinada por su tensión*. Es la incógnita que el
método no sabe expresar.

Hay dos casos y solo el segundo necesita maquinaria nueva.

=== Caso fácil: un terminal en la referencia

Si la fuente $V_s$ va del nodo $k$ a la referencia, entonces $v_k = V_s$ y listo: ese
nodo deja de ser incógnita. No se escribe su ecuación de LKC —no hace falta, y además
sería la que contiene la corriente desconocida— y el sistema queda con una incógnita
menos. Es la razón por la que conviene poner la referencia donde están las fuentes.

=== Caso general: el supernodo

Si la fuente va entre dos nodos $k$ y $j$ y *ninguno* es la referencia, se usa la versión
ampliada de la LKC del Módulo 7: la ley vale para cualquier superficie cerrada.

#definicion("Supernodo")[
  Un *supernodo* es una superficie cerrada que encierra a la fuente de tensión y a los
  dos nodos que une, tratándolos como uno solo. Aporta *dos* ecuaciones:

  1. *LKC del supernodo*: la suma de las corrientes de todas las ramas que *cruzan* la
     superficie es cero. La corriente de la fuente no aparece: queda adentro.
  2. *Ecuación de restricción*: $v_k - v_j = V_s$, que es el dato que la fuente impone.

  Dos ecuaciones para dos incógnitas: el conteo cierra igual que siempre.
]

#circuito([Supernodo: la fuente de 12 V queda encerrada])[
#fig-supernodo()
#pie-figura[El borde punteado corta los dos conductores que bajan a $R_1$ y a
  $R_2$: por ahí es por donde se escribe la única ecuación de corrientes del
  supernodo.]
]

#ejercicio("Circuito con supernodo")[
  Datos: fuente de 4 A entrando al nodo 1, fuente de 12 V entre el nodo 1 (terminal $-$)
  y el nodo 2 (terminal $+$)... con la polaridad del dibujo, $v_1 - v_2 = 12$ V.
  $R_1 = 2 Omega$ del nodo 1 a masa, $R_2 = 6 Omega$ del nodo 2 a masa.

  *1. LKC del supernodo.* Las ramas que cruzan la superficie son: la fuente de 4 A (entra),
  $R_1$ (sale hacia masa) y $R_2$ (sale hacia masa).
  $ v_1/2 + v_2/6 = 4 $

  *2. Restricción de la fuente.*
  $ v_1 - v_2 = 12 quad arrow.r quad v_1 = v_2 + 12 $

  *3. Resolver.* Reemplazando:
  $ (v_2 + 12)/(2) + v_2/6 = 4 quad arrow.r quad v_2/2 + 6 + v_2/6 = 4 $
  $ v_2 (1/2 + 1/6) = -2 quad arrow.r quad v_2 dot 2/3 = -2 quad arrow.r quad v_2 = -3 "V" $
  $ v_1 = -3 + 12 = 9 "V" $

  *4. Interpretar el signo.* $v_2$ negativa significa que el nodo 2 está *por debajo* de
  masa. Nada raro: es lo que la fuente de 12 V impone dado que el nodo 1 quedó en 9 V.

  *5. Controlar.* $i_(R 1) = 9\/2 = 4,5$ A saliendo; $i_(R 2) = -3\/6 = -0,5$ A saliendo,
  es decir, 0,5 A *entrando*. Suma de lo que sale del supernodo: $4,5 - 0,5 = 4$ A,
  igual a lo que inyecta la fuente ✓.

  *6. La corriente de la fuente de 12 V*, que el método "no sabía", sale ahora de la LKC
  de un nodo individual: en el nodo 1, entran 4 A de la fuente de corriente, salen 4,5 A
  por $R_1$, así que por la fuente de tensión entran $0,5$ A desde el nodo 2.
]

#atencion[
  El error más común con supernodos es escribir la LKC del supernodo *y además* la de
  uno de los nodos que encierra. Eso duplica información y deja el sistema mal
  planteado. La regla es: el supernodo reemplaza a las dos ecuaciones de nodo, y la
  segunda ecuación que falta es *siempre* la restricción de la fuente, nunca otra LKC.
]

== Análisis de mallas

=== La corriente de malla

Es una variable *ficticia*: una corriente que se imagina circulando por todo el perímetro
de una malla. No se mide con un amperímetro. Lo que sí es real es la corriente de rama,
que se obtiene como suma algebraica de las corrientes de malla que pasan por ella:

- En una rama *exterior* (perteneciente a una sola malla), la corriente de rama es la
  corriente de esa malla.
- En una rama *compartida* por dos mallas, la corriente de rama es la *diferencia* de las
  dos corrientes de malla.

#clave[
  Definir *todas* las corrientes de malla en el mismo sentido — por convención, horario.
  Con esa disciplina, la corriente de una rama compartida entre las mallas $A$ y $B$ es
  siempre $i_A - i_B$ vista desde $A$, y la matriz del sistema sale simétrica y con la
  diagonal positiva. Mezclar sentidos funciona, pero pierde la regla por inspección y
  con ella la mitad de la ventaja del método.
]

=== La ecuación de una malla

Recorriendo la malla $k$ y aplicando LKT, cada resistor de la malla aporta un término
$R (i_k - i_j)$ si es compartido con la malla $j$, y $R i_k$ si no lo es. Ordenando:

$ (sum_(R in k) R) i_k - sum_j (sum_(R in k inter j) R) i_j = V_k $ <ec-malla>

#definicion("El sistema de mallas por inspección")[
  Para una red *sin fuentes de corriente ni fuentes controladas*, con todas las mallas
  recorridas en sentido horario, el sistema $bold(R) bold(i) = bold(v)$ se escribe
  mirando el dibujo:

  - *Diagonal* $R_(k k)$: la suma de *todas* las resistencias del perímetro de la malla
    $k$. Siempre positiva.
  - *Fuera de la diagonal* $R_(k j)$: la suma de las resistencias *compartidas* entre las
    mallas $k$ y $j$, cambiada de signo. Siempre negativa o cero.
  - *Término independiente* $v_k$: la suma algebraica de las fuentes de tensión de la
    malla $k$, contando *positiva* la que empuja corriente en el sentido de recorrido
    (se entra por el $-$ y se sale por el $+$) y negativa la que se opone.

  La matriz $bold(R)$ también resulta *simétrica*, por la misma razón que $bold(G)$.
]

#circuito([El circuito del Ejercicio 7.2, ahora por mallas])[
#fig-mallas-basico()
#pie-figura[$R_2$ es la rama compartida y la recorren las dos corrientes de
  malla en sentidos opuestos: por ella circula $i_A - i_B$.]
]

#ejercicio("El mismo circuito del 7.2, con dos ecuaciones en vez de tres")[
  *1. Escribir por inspección.* Malla $A$: perímetro $R_1 + R_2 = 6 Omega$. Malla $B$:
  perímetro $R_2 + R_3 = 10 Omega$. Compartida: $R_2 = 4 Omega$.
  La fuente $V_1$ empuja en sentido horario en la malla $A$ ($+12$); la fuente $V_2$ se
  opone al sentido horario de la malla $B$ ($-6$).
  $ mat(6, -4; -4, 10) vec(i_A, i_B) = vec(12, -6) $

  *2. Resolver.* De la primera fila, $i_A = (12 + 4 i_B)\/6 = 2 + (2 i_B)/(3)$. En la
  segunda:
  $ -4(2 + (2 i_B)/(3)) + 10 i_B = -6 quad arrow.r quad -8 - (8 i_B)/(3) + 10 i_B = -6 $
  $ (22 i_B)/(3) = 2 quad arrow.r quad i_B = 0,273 "A" quad arrow.r quad i_A = 2,18 "A" $

  *3. Bajar a las corrientes de rama.*
  $ i_(R 1) = i_A = 2,18 "A", quad
    i_(R 2) = i_A - i_B = 1,91 "A", quad
    i_(R 3) = i_B = 0,273 "A" $

  *4. Comparar con el 7.2.* Idénticas. Allá salieron de tres ecuaciones armadas a mano
  recorriendo lazos; acá, de una matriz de $2 times 2$ escrita mirando el dibujo. Y en la
  sección 8.6 el mismo circuito sale con *una sola* ecuación.
]

== Supermalla: la fuente de corriente que rompe el método

Simétricamente al caso anterior: el método de mallas escribe la tensión de cada elemento
en función de las corrientes. Con una fuente de corriente ideal eso no se puede, porque
*su tensión no está determinada por su corriente*.

=== Caso fácil: la fuente en una rama exterior

Si la fuente de corriente $I_s$ pertenece a una sola malla, entonces esa corriente de
malla es dato: $i_k = plus.minus I_s$ según el sentido. La incógnita desaparece y no se
escribe la ecuación de esa malla.

=== Caso general: la supermalla

#definicion("Supermalla")[
  Cuando una fuente de corriente es *compartida* por dos mallas, se forma una *supermalla*:
  el lazo que resulta de unir las dos mallas y *eliminar del recorrido la rama que
  contiene la fuente*. Aporta *dos* ecuaciones:

  1. *LKT de la supermalla*, recorriendo el perímetro exterior. La tensión de la fuente
     no aparece: la rama quedó fuera del camino.
  2. *Ecuación de restricción*: $i_k - i_j = I_s$, con el signo que corresponda al sentido
     de la fuente.
]

#circuito([Supermalla: la rama de la fuente de 4 A se saltea en el recorrido])[
#fig-supermalla()
#pie-figura[Recorrido de la supermalla: 20 V $arrow.r R_1 arrow.r$ (saltea la
  fuente) $arrow.r R_2 arrow.r$ vuelta. La ecuación que falta la aporta la
  fuente: $i_A - i_B = 4$ A.]
]

#ejercicio("Circuito con supermalla")[
  Datos: $V = 20$ V y $R_1 = 2 Omega$ en la malla $A$; $R_2 = 6 Omega$ en la malla $B$;
  fuente de 4 A en la rama compartida, en el sentido que corresponde a $i_A - i_B = 4$ A.

  *1. LKT de la supermalla* (horario, salteando la rama de la fuente):
  $ -20 + 2 i_A + 6 i_B = 0 quad arrow.r quad 2 i_A + 6 i_B = 20 $

  *2. Restricción.*
  $ i_A - i_B = 4 quad arrow.r quad i_A = i_B + 4 $

  *3. Resolver.*
  $ 2(i_B + 4) + 6 i_B = 20 quad arrow.r quad 8 i_B = 12 quad arrow.r quad i_B = 1,5 "A" $
  $ i_A = 5,5 "A" $

  *4. La tensión de la fuente de corriente*, que el método "no sabía", sale ahora de la
  LKT de una malla individual. En la malla $A$: $-20 + 2 dot 5,5 + v_"fuente" = 0$, de
  donde $v_"fuente" = 9$ V. Control con la malla $B$: $-9 + 6 dot 1,5 = 0$ ✓.

  *5. Balance de potencias.* La fuente de 20 V entrega $20 dot 5,5 = 110$ W. Los
  resistores disipan $"5,5"^2 dot 2 + "1,5"^2 dot 6 = 60,5 + 13,5 = 74$ W. La diferencia,
  36 W, la *absorbe* la fuente de corriente ($4 "A" dot 9 "V"$).

  *Lección*: una fuente no siempre entrega. Acá la de corriente está funcionando como
  carga, y eso solo se ve haciendo el balance. Es el mismo fenómeno que una batería
  cargándose.
]

#atencion[
  Igual que con el supernodo: la LKT de la supermalla *reemplaza* a las de las dos mallas
  que la forman. Escribir la supermalla y además una de las mallas originales —cuya
  ecuación contiene la tensión desconocida de la fuente— es el error típico.
]

== Fuentes controladas en los dos métodos

La receta es la misma y es corta:

+ Escribir el sistema *tratando a la fuente controlada como si fuera independiente*, con
  su símbolo ($mu v_x$, $beta i_x$, lo que sea) en el término independiente.
+ Agregar una ecuación que exprese la *variable de control* ($v_x$ o $i_x$) en función de
  las incógnitas del método (tensiones de nodo, o corrientes de malla).
+ Sustituir y pasar todo al lado izquierdo.

El sistema sigue teniendo tantas ecuaciones como incógnitas, pero *la matriz pierde la
simetría*: los términos que se mudaron del lado derecho al izquierdo caen fuera de la
diagonal sin su pareja. Eso es esperable y no es un error.

#circuito([Nodal con una fuente controlada por corriente])[
#fig-nodal-controlada()
]

#ejercicio("Análisis nodal con una fuente controlada (CCCS)")[
  Datos: 2 A entrando al nodo 1; $R_1 = 3 Omega$ del nodo 1 a masa, recorrido hacia abajo
  por $i_x$; $R_2 = 6 Omega$ entre los nodos 1 y 2; $R_3 = 3 Omega$ del nodo 2 a masa; una
  fuente de corriente controlada de valor $2 i_x$ entrando al nodo 2.

  *1. Ecuación de control.*
  $ i_x = v_1/3 $

  *2. LKC en el nodo 1* (lo que sale, igual a lo que entra):
  $ v_1/3 + (v_1 - v_2)/(6) = 2 quad arrow.r.double quad 3 v_1 - v_2 = 12 $

  *3. LKC en el nodo 2*, con la fuente controlada entrando:
  $ (v_2 - v_1)/(6) + v_2/3 = 2 i_x = (2 v_1)/(3) $
  Multiplicando por 6: $v_2 - v_1 + 2 v_2 = 4 v_1 quad arrow.r quad 5 v_1 - 3 v_2 = 0$.

  *4. El sistema ya no es simétrico* — como estaba anunciado:
  $ mat(3, -1; 5, -3) vec(v_1, v_2) = vec(12, 0) $

  *5. Resolver.* De la segunda, $v_2 = (5 v_1)\/3$. En la primera:
  $ 3 v_1 - (5 v_1)/(3) = 12 quad arrow.r quad (4 v_1)/(3) = 12 quad arrow.r quad v_1 = 9 "V" $
  $ v_2 = 15 "V" quad quad i_x = 3 "A" $

  *6. Controlar.* La corriente por $R_2$, tomada del nodo 1 hacia el nodo 2, vale
  $(9-15)\/6 = -1$ A: circula al revés, del 2 hacia el 1.
  Nodo 1: entran 2 A de la fuente y 1 A por $R_2$; sale $i_x = 3$ A por $R_1$. $3 = 3$ ✓.
  Nodo 2: entran $2 i_x = 6$ A de la fuente controlada; salen 1 A por $R_2$ y
  $15\/3 = 5$ A por $R_3$. $6 = 6$ ✓.

  *7. Notar lo importante*: el nodo 2 está *más alto* que el nodo 1 aunque la única fuente
  independiente inyecta en el nodo 1. La fuente controlada está bombeando 6 A, tres veces
  lo que entra al circuito. Eso es *ganancia*, y es exactamente lo que hace un transistor.
]

== Qué método conviene

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([], [*Nodos*], [*Mallas*]),
    [Cantidad de ecuaciones], [$n - 1$], [$b - n + 1$],
    [Se lleva bien con], [fuentes de *corriente*], [fuentes de *tensión*],
    [Necesita maquinaria extra con], [fuentes de tensión flotantes (supernodo)],
      [fuentes de corriente compartidas (supermalla)],
    [Da directamente], [las *tensiones*], [las *corrientes*],
    [Sirve en circuitos no planares], [*sí*], [no],
    [Se generaliza a alterna], [sí, con $bold(Y)$], [sí, con $bold(Z)$],
  ),
  caption: [Criterios de elección entre los dos métodos],
)

#clave[
  El criterio de decisión, en orden:
  + *Contar*: $n-1$ contra $b-n+1$. Gana el número más chico.
  + *Mirar las fuentes*: muchas de tensión con un terminal a masa empujan hacia nodos
    (cada una borra una incógnita); muchas de corriente en ramas exteriores empujan hacia
    mallas (ídem).
  + *Mirar qué piden*: si el enunciado pide la corriente de una rama, mallas la da sin
    intermediarios; si pide una tensión, nodos.
  + Si el circuito *no es planar*, no hay elección: nodos.
]

== El mismo circuito, por los tres caminos

#ejercicio("Kirchhoff puro, mallas y nodos sobre el circuito del 7.2")[
  El circuito del Ejercicio 7.2 tiene $n = 2$ nodos esenciales y $b = 3$ ramas
  esenciales. Entonces:

  - *Kirchhoff a mano*: $b = 3$ ecuaciones. Fue el Ejercicio 7.2.
  - *Mallas*: $b - n + 1 = 2$ ecuaciones. Fue el Ejercicio 8.3.
  - *Nodos*: $n - 1 = 1$ ecuación. Es esto.

  Con la referencia en el nodo $(b)$, la única incógnita es $v_a$. Las dos fuentes tienen
  un terminal en la referencia, así que sus nodos superiores valen 12 V y 6 V y son dato.
  La LKC en el nodo $(a)$:

  $ (v_a - 12)/(2) + v_a/4 + (v_a - 6)/(6) = 0 $

  Multiplicando por 12:
  $ 6(v_a - 12) + 3 v_a + 2(v_a - 6) = 0 $
  $ 6 v_a - 72 + 3 v_a + 2 v_a - 12 = 0 quad arrow.r quad 11 v_a = 84 $
  $ v_a = 7,64 "V" $

  Y las tres corrientes salen de una resta cada una:
  $ i_1 = (12 - 7,64)/(2) = 2,18 "A", quad
    i_2 = (7,64)/(4) = 1,91 "A", quad
    i_3 = (6 - 7,64)/(6) = -0,273 "A" $

  Las mismas tres corrientes que costaron un sistema de $3 times 3$ en el Módulo 7.

  *Conclusión operativa*: antes de escribir la primera ecuación, contar. Treinta segundos
  de conteo ahorran media carilla de álgebra y, sobre todo, ahorran los errores de signo
  que aparecen cuando hay muchas ecuaciones.
]

== Nota sobre redes no planares

Un circuito es *planar* si puede dibujarse en una hoja sin que dos ramas se crucen. El
concepto de malla solo existe ahí: en una red no planar no hay "lazos sin nada adentro"
bien definidos. El análisis de nodos, en cambio, no usa para nada la geometría del
dibujo: solo usa la lista de qué está conectado con qué.

#clave[
  El análisis de nodos es *siempre* aplicable; el de mallas, solo a redes planares. Esa es
  la razón de fondo por la que todo simulador de circuitos —SPICE incluido, y por lo tanto
  LTspice, Multisim o Falstad— resuelve internamente por *análisis nodal modificado*
  (MNA), que es este mismo método con el agregado de tratar las fuentes de tensión y los
  elementos que no admiten conductancia mediante incógnitas de corriente adicionales.
]

#tp("Con el Anexo 1 — guía de TPs del I Cuatrimestre")[
  El anexo de la PT100 es el ejercicio integrador natural de este módulo. Su circuito
  —20 V alimentando dos ramas de 220 $Omega$, con la PT100 de 100 $Omega$ y sus dos cables
  en una de ellas y una $R_3$ de 50 $Omega$ en la otra— es un puente, y un puente cargado no
  se resuelve con serie ni con paralelo. Hay exactamente tres caminos: transformación
  $Delta$–Y (Módulo 7), análisis nodal (dos nodos, dos ecuaciones), o el equivalente de
  Thévenin visto desde la diagonal, que es el Módulo 9 y el más corto de los tres.
]
