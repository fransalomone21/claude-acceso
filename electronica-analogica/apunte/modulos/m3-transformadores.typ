#import "../plantilla.typ": *

#modulo("Electromagnetismo y transformadores de CA", [
  Explicar por qué un transformador funciona con alterna y no con continua, calcular la
  relación de transformación y las tensiones y corrientes de ambos bobinados, distinguir
  potencia aparente de potencia real, y elegir el transformador adecuado para una fuente
  de alimentación.
])

== Del campo magnético a la tensión inducida

Todo lo que sigue se apoya en tres hechos experimentales.

+ Una corriente que circula por un conductor *genera un campo magnético* a su alrededor.
  Si el conductor se arrolla formando una bobina, los campos de cada espira se suman y el
  conjunto se comporta como un imán.
+ El *flujo magnético* $Phi$ mide cuánto campo atraviesa una superficie. Se mide en
  weber [Wb].
+ Si el flujo que atraviesa una bobina *cambia con el tiempo*, aparece en sus extremos una
  tensión inducida.

#definicion("Ley de Faraday y ley de Lenz")[
  La tensión inducida en una bobina de $N$ espiras es proporcional a la *rapidez con que
  cambia* el flujo magnético que la atraviesa:
  $ e = -N (dif Phi)/(dif t) $ <ec-faraday>
  El signo menos es la *ley de Lenz*: la tensión inducida tiene siempre el sentido que se
  opone a la causa que la produjo. La naturaleza no regala energía.
]

#clave[
  La @ec-faraday explica de una sola vez por qué un transformador *no funciona con
  corriente continua*. Con continua, el flujo es constante, $dif Phi \/ dif t = 0$, y la
  tensión inducida en el secundario es *cero*. Peor todavía: sin reactancia que la limite,
  la corriente del primario queda determinada solo por la resistencia del alambre, que es
  muy baja, y el bobinado se quema. Un transformador conectado a continua no es un
  transformador: es un cortocircuito con forma de transformador.
]

== El transformador

#definicion("Transformador")[
  Máquina eléctrica, sin partes móviles, capaz de transformar el valor pico (y por lo
  tanto el eficaz) de una tensión alterna en otro mayor o menor. La señal de salida sigue
  siendo alterna y *conserva la forma y la frecuencia* de la entrada: lo único que cambia
  es la amplitud. En un transformador ideal, la potencia de salida es igual a la de
  entrada.
]

Consta de dos bobinados sobre un mismo núcleo de hierro: el *primario* ($N_1$ espiras),
que recibe la energía, y el *secundario* ($N_2$ espiras), que la entrega. No hay conexión
eléctrica entre ellos: la energía pasa *por el campo magnético*. De ahí que el
transformador también sirva como *aislación galvánica*, que es una función de seguridad
tan importante como la de cambiar la tensión.

#circuito([Transformador reductor de 220 V a 12 V])[
```
         PRIMARIO          NÚCLEO          SECUNDARIO
                        ┌───────────┐
    o────┐              │███████████│              ┌────o
         │  )))))))     │███████████│     (((((((  │
  220 V  │  )))))))     │███████████│     (((((((  │  12 V
   (CA)  │  )))))))     │███████████│     (((((((  │  (CA)
         │              │███████████│              │
    o────┘              └───────────┘              └────o
           N1 espiras                  N2 espiras
              (muchas)                    (pocas)
```
]

=== Relación de transformación

En un transformador ideal el mismo flujo $Phi$ atraviesa ambos bobinados. Aplicando la
@ec-faraday a cada uno:

$ V_1 = N_1 (dif Phi)/(dif t) quad quad quad V_2 = N_2 (dif Phi)/(dif t) $

Dividiendo miembro a miembro, el término $dif Phi \/ dif t$ — que es el mismo para los
dos — se cancela:

$ V_1/V_2 = N_1/N_2 = n $ <ec-relacion>

donde $n$ es la *relación de transformación*. Si $n > 1$ el transformador es *reductor*;
si $n < 1$, *elevador*.

=== La corriente va al revés

Si el transformador es ideal, no disipa energía, así que toda la potencia que entra sale:

$ P_1 = P_2 quad arrow.r.double quad V_1 dot I_1 = V_2 dot I_2 $

y despejando:

$ I_2/I_1 = V_1/V_2 = N_1/N_2 = n $ <ec-corrientes>

#clave[
  Las tensiones y las corrientes van en sentidos *opuestos*: si el transformador baja la
  tensión 18 veces, *sube* la corriente 18 veces. Un transformador no crea energía, la
  reparte de otra manera. Esto tiene una consecuencia de laboratorio: el bobinado de baja
  tensión se hace con alambre *más grueso*, porque por él circula más corriente.
]

== Potencia aparente y potencia real

Los transformadores no se especifican en watts sino en *volt-ampere*, y la razón no es un
capricho comercial.

#definicion("Potencia aparente, activa y factor de potencia")[
  *Potencia aparente* $S = V_"ef" dot I_"ef"$, medida en *volt-ampere [VA]*: es el
  producto de lo que hay, sin importar si sirve o no.
  *Potencia activa o real* $P = V_"ef" dot I_"ef" dot cos phi$, medida en *watt [W]*: es
  la que efectivamente se convierte en trabajo o calor.
  El *factor de potencia* $cos phi$ vale 1 en una carga puramente resistiva y baja cuando
  la carga tiene componente inductiva o capacitiva.
]

$ P = S dot cos phi $ <ec-potencias>

El transformador se calienta por la corriente que circula por sus bobinados, y esa
corriente existe *aunque el factor de potencia sea malo y no se entregue trabajo útil*.
Por eso el límite del fabricante se expresa en VA y no en W: es lo que el cobre aguanta.

=== Rendimiento y pérdidas

Un transformador real no es ideal. Sus pérdidas son de dos tipos:

- *Pérdidas en el cobre* ($I^2 R$): calor disipado por la resistencia del alambre de los
  bobinados. Dependen de la carga: a mayor corriente, mayores pérdidas.
- *Pérdidas en el hierro*: por *histéresis* (la energía que cuesta magnetizar y
  desmagnetizar el núcleo en cada ciclo) y por *corrientes de Foucault* (corrientes
  parásitas inducidas dentro del propio núcleo). Son casi independientes de la carga.

#laboratorio[
  El núcleo de todo transformador de red está hecho de *chapas finas aisladas entre sí*, no
  de un bloque macizo. Esa laminación no es una comodidad de fabricación: obliga a las
  corrientes de Foucault a circular en caminos chicos y de alta resistencia, reduciendo
  muchísimo la pérdida. Un núcleo macizo se pondría al rojo.
]

$ eta = P_"salida"/P_"entrada" dot 100 $ <ec-rendimiento>

En transformadores chicos de laboratorio el rendimiento anda entre el 70 % y el 90 %.

== Transformador con punto medio (center tap)

Es el que permite armar una *fuente doble* ($+V$ y $-V$ respecto de masa), y el que pide
la parte 3 del TP N.º 7.

#circuito([Secundario con punto medio: dos tensiones en contrafase])[
```
                        ┌──────o  A     ─┐
                        │                │  12 V
              (((((((   │                │
   220 V      (((((((   ├──────o  M  ────┤  punto medio (masa)
    (CA)      (((((((   │                │
                        │                │  12 V
                        └──────o  B     ─┘

     Entre A y B: 24 Vef      Entre A y M: 12 Vef
                              Entre B y M: 12 Vef  (en contrafase con A)
```
]

El secundario es un solo bobinado con una derivación en la mitad exacta. Tomando ese punto
medio como referencia de masa, las tensiones de los dos extremos son *iguales en amplitud
y opuestas en fase*: cuando A está a $+17$ V de pico, B está a $-17$ V. De ahí salen las
dos ramas, positiva y negativa, de una fuente simétrica.

#atencion[
  Un secundario de "12 V con punto medio" es ambiguo si no se aclara *dónde se mide*.
  Puede significar 12 V entre cada extremo y el punto medio (24 V entre extremos) o 12 V
  entre extremos (6 V a cada lado). Antes de calcular una fuente, medir con el tester
  entre los tres bornes y anotar los tres valores. La consigna del TP N.º 7 especifica
  *12 V#sub[ef] en cada bobina secundaria*.
]

#ejercicio("Transformador reductor 220 V / 12 V")[
  Un transformador de red entrega 12 V#sub[ef] en el secundario, con una carga que consume
  1 A. El primario tiene $N_1 = 1100$ espiras. Calcular la relación de transformación, las
  espiras del secundario, la corriente del primario y la potencia aparente.

  *1. Relación de transformación*, con la @ec-relacion:
  $ n = V_1/V_2 = (220 "V")/(12 "V") = 18,33 $

  *2. Espiras del secundario*:
  $ N_2 = N_1/n = 1100/18,33 = 60 "espiras" $

  *3. Corriente del primario*, con la @ec-corrientes:
  $ I_1 = I_2/n = (1 "A")/(18,33) = 54,5 "mA" $
  Coherente: baja la tensión 18,33 veces y sube la corriente 18,33 veces.

  *4. Potencia aparente*:
  $ S = V_2 dot I_2 = 12 "V" dot 1 "A" = 12 "VA" $
  Verificación por el primario: $S = 220 "V" dot 54,5 "mA" = 12 "VA"$. Cierra, como debe
  ser en un transformador ideal.

  *5. Valor pico del secundario* — el dato que va a hacer falta en el Módulo 5:
  $ V_(2p) = V_(2"ef") dot sqrt(2) = 12 dot 1,4142 = 17 "V" $
]

#ejercicio("Elegir el transformador de una fuente")[
  Hay que alimentar un circuito que consume *500 mA a 12 V de continua*. ¿Qué
  transformador se compra?

  *1. El secundario no es la tensión de salida.* Después del rectificador y el filtro, la
  continua vale aproximadamente el valor pico del secundario menos las caídas de los
  diodos (Módulo 5). Para obtener 12 V de continua con un puente:
  $ V_p approx 12 "V" + 1,4 "V" = 13,4 "V" quad arrow.r.double quad
    V_"ef" = V_p/sqrt(2) = 9,5 "V" $
  Un secundario comercial de *9 V* o *12 V* sirve; con 12 V queda margen para la caída
  bajo carga y para el ripple, así que es la elección segura.

  *2. Corriente y potencia aparente.* Con un margen del 50 % sobre el consumo — el
  capacitor de filtro se carga en picos breves de corriente mucho mayores que la media:
  $ I_2 >= 1,5 dot 500 "mA" = 750 "mA" $
  $ S = 12 "V" dot 0,75 "A" = 9 "VA" $

  *3. Conclusión*: un transformador de *220 V / 12 V, 1 A (12 VA)*. Comprar uno de
  exactamente 500 mA sería un error: trabajaría al límite, se calentaría y su tensión
  caería bajo carga.

  *Por qué el margen*: en una fuente con filtro capacitivo la corriente del secundario no
  es senoidal sino a pulsos angostos y altos. El valor eficaz de esa corriente es bastante
  mayor que la continua entregada a la carga, y es esa corriente eficaz la que calienta el
  bobinado.
]

#tp("Vínculo con el TP N.º 7 — II Cuatrimestre")[
  Ninguna de las dos guías tiene un TP dedicado al transformador, pero *todo el TP N.º 7
  depende de este módulo*: la parte 3 usa un transformador con punto medio y pide calcular
  las tensiones continuas positiva y negativa. Sin la relación de transformación y sin
  entender la contrafase del center tap, ese punto no se puede resolver.
]
