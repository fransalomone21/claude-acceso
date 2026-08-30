#import "../plantilla.typ": *

#modulo("El amplificador operacional", [
  Entender qué hace un operacional *antes* de aplicarle ninguna fórmula; saber de dónde
  sale el cortocircuito virtual, cuándo se puede usar y —sobre todo— cuándo no; resolver
  cualquier configuración con el análisis de nodos del Módulo 8 en lugar de memorizar
  ganancias; y reconocer las cinco limitaciones del operacional real que hacen que el
  circuito medido no dé lo calculado.
])

Este es el último componente del apunte y el primero que no se parece a ninguno de los
anteriores. El diodo, el transistor y el transformador se entienden mirando *lo que
tienen adentro*. El operacional no: adentro tiene unos veinte transistores, y saber
cuáles son no sirve para nada. Se entiende mirando *lo que hace*, y lo que hace se
resume en una sola frase que vale la pena leer despacio, porque todo el módulo sale de
ahí:

#clave[
  *El operacional mira la diferencia entre sus dos entradas y mueve la salida hasta que
  esa diferencia sea cero.*

  No hace nada más. No sabe qué resistores tiene colgando, no sabe qué circuito lo rodea
  y no sabe qué ganancia se supone que tiene que dar. Mira dos tensiones, y empuja.
]

Todo lo que sigue —las dos reglas, el cortocircuito virtual, las diez configuraciones—
es esa frase, aplicada. Y los tres casos donde el cortocircuito virtual *no vale* son
los tres casos donde esa frase no se puede cumplir.

== El componente, antes de cualquier fórmula

=== Un empleado con una sola obsesión

Conviene una imagen, y no es un adorno: es el modelo mental que después permite decidir
solo, en un circuito que no está en ninguna tabla, si el cortocircuito virtual se puede
usar o no.

#definicion("El operacional, contado como una persona")[
  Imaginate a alguien sentado frente a dos termómetros y con una perilla en la mano. Su
  única orden es: *«mirá los dos termómetros y movés la perilla hasta que marquen lo
  mismo»*. Nada más. No sabe qué calienta la perilla, no sabe si está conectada a algo,
  no sabe cuánto tiene que girarla.

  Los dos termómetros son las entradas $v_+$ y $v_-$. La perilla es la salida $v_o$.

  Y ahora la pregunta que decide todo: *¿girar la perilla cambia lo que marcan los
  termómetros?*

  - *Si la perilla calienta el ambiente del termómetro que va quedando frío* —o sea, si
    la salida tiene un camino de vuelta hacia la entrada— entonces la persona puede
    trabajar: gira, mira, corrige, y en algún momento los dos marcan igual. Ahí se
    queda, y ahí es donde $v_+ = v_-$.
  - *Si la perilla no está conectada a los termómetros*, la persona gira y gira y nunca
    pasa nada. Termina girando hasta el tope, y ahí se queda. Los termómetros marcan lo
    que marquen: nadie los igualó.
  - *Si la perilla calienta el termómetro que ya estaba caliente*, cada vuelta empeora la
    diferencia. La persona gira más fuerte, la diferencia crece más, y en dos parpadeos
    está contra el tope.

  Los tres casos existen y los tres se usan a propósito. El primero es la
  *realimentación negativa* y es de donde sale el cortocircuito virtual. El segundo es
  el *comparador*. El tercero es el *disparador de Schmitt*.
]

#atencion[
  La trampa de esta imagen —y la razón de contarla con tanto detalle— es que el
  cortocircuito virtual *no es una propiedad del componente*. Es el resultado de que el
  componente esté metido en un circuito que le devuelve su propia salida al lugar
  correcto. El mismo operacional, con los mismos veinte transistores adentro, cumple
  $v_+ = v_-$ en un circuito y no lo cumple ni de lejos en el de al lado.

  Por eso "el operacional tiene tierra virtual" es una frase mal armada. La tierra
  virtual la tiene el *circuito*, no el operacional.
]

=== Los cinco terminales

#circuito([El símbolo del operacional y sus cinco terminales])[
#fig-ao-terminales()
#pie-figura[La única variable que el operacional mira es $v_d = v_+ - v_-$. Los dos
  terminales de alimentación no aparecen en ninguna fórmula de ganancia, pero son los
  que fijan hasta dónde puede llegar $v_o$.]
]

El símbolo tiene tres terminales de señal y dos de alimentación:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Terminal*], [*Qué es*], [*Qué hay que recordar*]),
    [Entrada no inversora, $v_+$],
      [una de las dos que mira],
      [si $v_+$ sube, $v_o$ sube],
    [Entrada inversora, $v_-$],
      [la otra],
      [si $v_-$ sube, $v_o$ *baja*],
    [Salida, $v_o$],
      [lo único que el operacional mueve],
      [es una fuente de tensión: fija $v_o$ pase lo que pase con la carga],
    [$+V_"CC"$ y $-V_"CC"$],
      [la alimentación],
      [no entran en la ganancia, pero acotan $v_o$: fuera de ese rango, satura],
  ),
  caption: [Los cinco terminales del operacional],
)

#clave[
  *El operacional no tiene terminal de masa*, y esa ausencia confunde a todo el mundo la
  primera vez. La corriente que sale por $v_o$ hacia la carga entra por los terminales de
  alimentación: el camino de retorno pasa por la fuente, no por el símbolo.

  Consecuencia práctica: un circuito con operacionales *no funciona* si la masa de la
  señal y la de la alimentación no son la misma. Es el error de conexión número uno en el
  laboratorio, y no da una lectura rara: da cero, o da basura.
]

=== Lo que hace el operacional solo: la ganancia de lazo abierto

Antes de conectarle nada, el operacional cumple una sola ecuación:

$ v_o = A_"ol" (v_+ - v_-) = A_"ol" thin v_d $ <ec-ao-lazo-abierto>

donde $A_"ol"$ es la *ganancia de lazo abierto* —#emph[open loop]—, y para un
operacional real vale entre $10^5$ y $10^6$. Es un número enorme, y esa enormidad es
justamente el problema.

#circuito([El operacional solo, sin ningún camino de realimentación])[
#fig-ao-lazo-abierto()
#pie-figura[No hay ningún cable que vuelva de la salida a una entrada. Acá el
  cortocircuito virtual *no vale*, y la @ec-ao-lazo-abierto es la única ecuación
  disponible.]
]

#ejercicio("Por qué el operacional solo no sirve para amplificar")[
  Un operacional con $A_"ol" = 200.000$ y alimentación de $plus.minus 15$ V, con la
  entrada inversora a masa. Se le aplica una señal de audio de 10 mV de pico en la
  entrada no inversora. ¿Cuánto vale la salida?

  *1. Aplicar la única ecuación que hay.* Con $v_- = 0$, la @ec-ao-lazo-abierto da
  $ v_o = 200.000 dot 0,010 "V" = 2000 "V" $

  *2. Mirar el resultado y no creerle.* 2000 V con una fuente de 15 V es imposible: la
  salida no puede pasar de la alimentación. Lo que pasa de verdad es que la salida se va
  al tope y se queda ahí, en unos 14 V. La señal de audio ya no está: quedó una tensión
  constante.

  *3. Calcular cuál es la señal más grande que este circuito puede amplificar sin
  romperse.* Para que $v_o$ se quede adentro de $plus.minus 14$ V:
  $ |v_d| < (14)/(200.000) = "70 µV" $

  *4. La conclusión, que es el motivo del módulo entero.* El operacional solo amplifica
  linealmente señales de menos de 70 microvolts. Cualquier cosa más grande lo satura. Y
  además $A_"ol"$ no es un dato confiable: varía de una unidad a otra del mismo modelo,
  cambia con la temperatura y cae con la frecuencia. Nadie puede diseñar con eso.

  *5. Y sin embargo, esas dos cosas malas son las que lo hacen útil.* Una ganancia
  gigantesca e imprecisa, metida adentro de un lazo de realimentación negativa, produce
  un circuito de ganancia chica y *precisa*, fijada por dos resistores. Eso es lo que se
  deduce en la sección siguiente, y es una de las ideas más importantes de toda la
  electrónica.
]

== La realimentación negativa y el cortocircuito virtual

=== Qué cambia cuando la salida vuelve a la entrada

Un *camino de realimentación* es cualquier conexión —un cable, un resistor, un
capacitor, una red entera— que lleve algo de la salida de vuelta a una de las dos
entradas. Realimentar *no* es un adorno: cambia por completo qué ecuación gobierna el
circuito.

#definicion("Realimentación negativa y positiva")[
  *Negativa*: el camino de vuelta llega a la entrada *inversora* ($-$). Un aumento de
  $v_o$ hace subir $v_-$, lo que hace *bajar* $v_o$. El lazo se opone a su propio cambio,
  y por eso *converge*: termina en un punto de equilibrio y se queda ahí.

  *Positiva*: el camino de vuelta llega a la entrada *no inversora* ($+$). Un aumento de
  $v_o$ hace subir $v_+$, lo que hace *subir más* $v_o$. El lazo se refuerza a sí mismo,
  y por eso *diverge*: se va contra un riel de alimentación y se queda ahí.
]

#clave[
  *Lo único que hay que mirar en el dibujo es a cuál de las dos patas llega el cable que
  viene de la salida.* No importa por cuántos resistores pase, ni si en el medio hay un
  capacitor, ni cuántas vueltas dé el cable. Llega al $-$: negativa. Llega al $+$:
  positiva. No llega a ninguna: no hay realimentación.

  Es el gesto de lectura más rentable del módulo, y se hace en dos segundos.
]

=== De dónde sale el cortocircuito virtual

Acá está la deducción completa. No es larga y conviene hacerla una vez, porque es lo que
convierte el cortocircuito virtual de "una regla que hay que creer" en "una consecuencia
que se puede rehacer".

Partimos de lo único que el operacional cumple siempre, la @ec-ao-lazo-abierto, y la
damos vuelta:

$ v_d = v_+ - v_- = (v_o)/(A_"ol") $ <ec-ao-vd>

Esa igualdad es *exacta*: vale con realimentación y sin ella. Ahora se le pide una sola
cosa al circuito, y es la condición que hay que verificar cada vez:

#definicion("La condición que hace válido el cortocircuito virtual")[
  Que la salida $v_o$ esté *acotada*: que se quede en algún valor finito, dentro del
  rango de la alimentación.

  Si eso pasa, entonces en la @ec-ao-vd el numerador es un número normal (unos pocos
  volts) y el denominador es enorme. La diferencia entre las entradas es un número
  normal dividido por $10^5$:
  $ v_d = (v_o)/(A_"ol") approx (10 "V")/(10^5) = "100 µV" approx 0 $
]

Y la realimentación negativa es *exactamente* el mecanismo que acota la salida. Vale la
pena ver el lazo funcionando paso a paso, porque el argumento es circular sólo en
apariencia:

+ Supongamos que $v_-$ está 1 mV por debajo de $v_+$. Entonces $v_d = +1$ mV.
+ El operacional multiplica eso por $10^5$ y empuja la salida hacia arriba, fuerte.
+ Como hay un camino de vuelta a la entrada inversora, subir $v_o$ *sube $v_-$*.
+ Al subir $v_-$, la diferencia $v_d$ se achica.
+ El lazo se detiene cuando $v_d$ es tan chica que $A_"ol" v_d$ ya no manda a la salida
  más lejos. Y como $A_"ol"$ es gigante, "tan chica" significa microvolts.

#clave[
  *El cortocircuito virtual no es una hipótesis sobre el componente: es el punto de
  equilibrio del lazo.* El operacional no "sabe" que tiene que igualar sus entradas; es
  el único estado en el que deja de empujar.

  Y como $A_"ol"$ aparece dividiendo, cuanto *más impreciso y más grande* sea, mejor
  vale la aproximación. Que $A_"ol"$ sea $10^5$ en una unidad y $4 dot 10^5$ en la de al
  lado deja de importar: $10$ V sobre cualquiera de los dos sigue siendo prácticamente
  cero.
]

=== Las dos reglas

Con la condición verificada, todo el análisis se apoya en dos afirmaciones:

#definicion("Las dos reglas del operacional ideal realimentado")[
  *Regla 1 — cortocircuito virtual.* Las dos entradas están a la misma tensión:
  $ v_+ = v_- $ <ec-ao-regla1>
  No están unidas por ningún cable: es la salida la que se mueve hasta que se cumple. Se
  llama *virtual* por eso — se comporta como un cortocircuito para las tensiones, pero
  no conduce ninguna corriente entre las dos patas.

  *Regla 2 — corriente de entrada nula.* Por las patas de entrada no entra ni sale
  corriente:
  $ i_+ = i_- = 0 $ <ec-ao-regla2>
  Esta no depende de la realimentación: sale de que la impedancia de entrada del
  operacional es enorme —del orden de $10^12 thin Omega$ en uno de entrada FET— y vale
  siempre, incluso saturado.
]

#atencion[
  *Las dos reglas son de distinta clase, y confundirlas cuesta caro.*

  La Regla 2 es una propiedad del *componente*: vale siempre. La Regla 1 es una
  propiedad del *circuito*: vale sólo si hay realimentación negativa y la salida no está
  contra el riel.

  En un comparador saturado la Regla 2 sigue valiendo —no entra corriente por las
  patas— y la Regla 1 es falsa de punta a punta. Aplicarla ahí da resultados que parecen
  razonables y son inventados.
]

Cuando la entrada no inversora está conectada a masa, la Regla 1 pone la inversora en
0 V *sin que esté conectada a nada*. Ese caso particular tiene nombre propio:

#definicion("Tierra virtual")[
  Es el nodo del cortocircuito virtual cuando la otra entrada está a masa: un nodo que
  está a 0 V pero *no* es masa.

  La diferencia importa y se mide: por una masa de verdad puede circular toda la
  corriente que haga falta; por la tierra virtual, según la Regla 2, no circula
  *ninguna* hacia el operacional. Toda la corriente que llega por un lado tiene que
  salir por otro.

  Esa obligación —lo que entra por $R_i$ sale sí o sí por $R_f$— es la que resuelve el
  inversor, el sumador y el integrador en dos renglones.
]

=== El test de tres preguntas

Esta es la parte operativa del módulo y la que conviene tener a mano cada vez que
aparezca un circuito con operacionales. Son tres preguntas, en orden, y se contestan
*mirando el dibujo*, sin escribir ninguna ecuación.

#definicion("¿Vale acá el cortocircuito virtual?")[
  *Pregunta 1 — ¿hay algún camino de la salida a alguna entrada?*
  Se sigue el cable que sale del vértice del triángulo. Si no llega a ninguna de las dos
  patas, *no hay realimentación*: la Regla 1 no vale y el circuito es un comparador.

  *Pregunta 2 — ¿a cuál de las dos patas llega?*
  Si llega a la inversora ($-$), es negativa: la Regla 1 *puede* valer, seguí a la 3. Si
  llega a la no inversora ($+$), es positiva: no vale, y el circuito es un disparador
  con histéresis.

  *Pregunta 3 — ¿la salida que da la cuenta entra en la alimentación?*
  Se resuelve el circuito con la Regla 1 y se mira el resultado. Si $|v_o|$ da más que
  $V_"CC"$, la respuesta no es esa: el operacional está saturado, la Regla 1 no valía, y
  la salida real es el riel.

  *Las tres tienen que dar bien.* La tercera es la que más se saltea, porque exige
  resolver primero y verificar después.
]

#atencion[
  *El caso mixto: realimentación a las dos patas.* Existe, y no es raro —un oscilador de
  puente de Wien lo tiene—. Ahí no alcanza con mirar a dónde llega el cable: hay que
  comparar cuál de los dos caminos es más fuerte. Si la realimentación negativa domina,
  el circuito se estabiliza y la Regla 1 vale; si domina la positiva, oscila o se
  dispara.

  Para lo que cubre este apunte, alcanza con reconocer el caso y no aplicar la Regla 1 a
  ciegas.
]

== Cómo se resuelve un circuito con operacionales

=== El operacional en el método de nodos

Acá se juntan este módulo y el 8, y conviene decirlo explícitamente porque es lo que
evita aprender diez fórmulas sueltas: *un circuito con operacionales se resuelve con el
análisis nodal de siempre*. No hay un método nuevo. Lo único que hace el operacional es
agregar dos datos al planteo.

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([*Lo que el operacional aporta*], [*Cómo entra en el análisis nodal*]),
    [Regla 1: $v_+ = v_-$],
      [una *tensión de nodo que pasa a ser dato*, igual que cuando una fuente de tensión
       fija un nodo (Módulo 8)],
    [Regla 2: $i_- = 0$],
      [la pata inversora *no aporta ningún término* a la ecuación del nodo: se escribe la
       LKC como si esa rama no existiera],
    [La salida es una fuente de tensión ideal],
      [$v_o$ es una *incógnita* del sistema, y el nodo de salida *no se plantea*: por ahí
       entra toda la corriente que haga falta, así que su LKC no da información],
  ),
  caption: [Lo único que el operacional agrega al análisis nodal del Módulo 8],
)

#clave[
  *La tercera fila es la que más se equivoca.* Escribir la LKC en el nodo de salida del
  operacional es un error: ese nodo tiene una fuente ideal colgando, y la corriente que
  ella entrega es desconocida. Es exactamente la misma situación que la fuente de tensión
  del Módulo 8 —la que obligaba a inventar el supernodo—, y la salida se trata igual:
  como un nodo cuya tensión es incógnita pero cuya ecuación no se plantea.

  El nodo que *sí* se plantea, y del que sale todo, es el del cortocircuito virtual.
]

=== El procedimiento, en cinco pasos

#definicion("Cómo resolver cualquier circuito con operacionales")[
  + *Correr el test de tres preguntas.* Si la Regla 1 no vale, parar acá: el circuito no
    se resuelve con estas herramientas, se resuelve mirando contra qué riel está.
  + *Anotar la tensión del nodo del cortocircuito virtual.* Se mira la entrada que
    *no* tiene la realimentación —normalmente la no inversora—, se calcula su tensión
    (suele ser masa, o un divisor), y por la Regla 1 ese mismo número es la tensión del
    otro nodo. Ese nodo se llama $v_x$ en las figuras de este módulo.
  + *Escribir la LKC en ese nodo*, con las tres convenciones del Módulo 8: todas las
    corrientes salen, cada rama se escribe como $(v_x - v_"otro")\/R$, y la pata del
    operacional *no se escribe* porque por ahí no pasa corriente.
  + *Despejar $v_o$.* Es la única incógnita que quedó.
  + *Verificar la excursión*: comprobar que el $v_o$ que salió entra en la alimentación.
    Si no entra, el paso 1 estaba mal contestado.
]

=== Primero a mano: el inversor, sin usar ninguna fórmula

Igual que en el Módulo 8, conviene ver el procedimiento entero funcionando en el caso
más chico antes de generalizar. La fórmula del inversor es la más conocida de la
electrónica; la gracia acá es *no usarla* y llegar igual.

#circuito([El amplificador inversor])[
#fig-ao-inversor()
#pie-figura[$v_x$ es el nodo del cortocircuito virtual. Está a 0 V y *no* está
  conectado a masa: es tierra virtual.]
]

#ejercicio("El inversor, deducido con el método de nodos")[
  Datos: $R_i = 10 "k"Omega$, $R_f = 47 "k"Omega$, $v_i = 0,5$ V, alimentación
  $plus.minus 15$ V.

  *1. El test.* El cable de la salida sale del vértice, sube por $R_f$ y llega a la pata
  del $-$: hay realimentación, y es *negativa*. Las preguntas 1 y 2 dan bien; la 3 se
  contesta al final.

  *2. La tensión del nodo virtual.* La entrada no inversora está conectada a masa, así
  que $v_+ = 0$. Por la Regla 1:
  $ v_x = v_- = v_+ = 0 "V" $
  El nodo $v_x$ está a cero volts sin tocar la masa. Toda la resolución sale de acá.

  *3. La LKC en el nodo $v_x$.* Del nodo cuelgan tres cosas: $R_i$ hacia la fuente, $R_f$
  hacia la salida, y la pata del operacional. Por la Regla 2, la pata *no se escribe*.
  Con la convención de que todas las corrientes salen:
  $ underbrace((v_x - v_i)/(R_i), "sale hacia la fuente")
    + underbrace((v_x - v_o)/(R_f), "sale hacia la salida") = 0 $
  A la derecha va cero porque no hay ninguna fuente de corriente inyectando en el nodo.

  *4. Reemplazar $v_x = 0$ y despejar.*
  $ (0 - v_i)/(R_i) + (0 - v_o)/(R_f) = 0
    quad arrow.r quad - (v_i)/(R_i) = (v_o)/(R_f) $
  $ v_o = - (R_f)/(R_i) v_i $
  Que es la fórmula del inversor, deducida sin haberla sabido de antemano. Con los
  números: $v_o = -(47\/10) dot 0,5 = -2,35$ V.

  *5. Verificar la excursión.* $|-2,35| < 15$ V: la salida entra cómodamente. La
  pregunta 3 da bien y el resultado vale.

  *6. Leer el resultado.* El signo menos no es un detalle de cuentas: la salida está
  invertida respecto de la entrada, y con una senoidal eso significa 180° de desfasaje.
  Y la ganancia la fijan *dos resistores*, no el operacional: cambiando $R_f$ a
  100 kΩ la ganancia pasa a $-10$ sin tocar nada más.
]

#clave[
  *Mirá lo que acaba de pasar con la corriente.* Por $R_i$ circulan
  $0,5\/10.000 = 50 thin mu"A"$. Esa corriente llega al nodo $v_x$ y *no puede entrar al
  operacional* (Regla 2). Como tampoco hay otro camino, sale entera por $R_f$.

  Esa es la lectura física del inversor, y es la que conviene tener en la cabeza en lugar
  de la fórmula: *la misma corriente atraviesa los dos resistores*. Por eso la tensión de
  salida es la caída en $R_f$ de una corriente que fijó $R_i$, y por eso la ganancia es
  una relación entre los dos.
]

#atencion[
  *La impedancia de entrada del inversor es $R_i$, y nada más.* La fuente $v_i$ ve un
  resistor conectado a un nodo que está a 0 V: para ella, $R_i$ va a masa. Un inversor de
  ganancia 10 hecho con $R_i = 1 "k"Omega$ le pide a la fuente 10 veces más corriente que
  uno hecho con $R_i = 10 "k"Omega$, aunque los dos amplifiquen igual.

  Es la razón por la que "elegir los resistores" no es sólo elegir su cociente. La
  ganancia la fija la relación; la carga sobre la fuente la fija $R_i$ sola.
]

== Las configuraciones

Las nueve que siguen se deducen todas con el mismo procedimiento de cinco pasos. Están
en orden de dificultad creciente y cada una agrega exactamente una idea nueva; conviene
leerlas seguidas, porque la última no es más difícil que la primera: es la primera
aplicada tres veces.

*Ninguna de estas fórmulas hay que memorizarla.* La que hay que saber hacer es la
deducción, que en todos los casos entra en tres renglones. La tabla del final del módulo
está para consultar, no para estudiar.

=== Seguidor de tensión

#circuito([Seguidor de tensión, o #emph[buffer]])[
#fig-ao-seguidor()
#pie-figura[La realimentación es un cable pelado: toda la salida vuelve a la entrada
  inversora. No hay resistores, y por eso no hay nada que elegir.]
]

*La deducción, completa.* La realimentación llega al $-$, así que la Regla 1 vale. La
entrada no inversora está en $v_i$, y el nodo virtual está unido a la salida por un cable:

$ v_x = v_o quad "(por el cable)" quad quad quad v_x = v_i quad "(por la Regla 1)" $
$ v_o = v_i $ <ec-ao-seguidor>

Ganancia 1. Parece el circuito más inútil del apunte, y es de los más usados que hay.

#clave[
  *Lo que compra el seguidor no es ganancia: es aislamiento.* Su impedancia de entrada
  es la del operacional (del orden de $10^12 thin Omega$), así que no le saca
  prácticamente nada a la etapa anterior; y su impedancia de salida es de fracciones de
  ohm, así que la etapa siguiente no lo carga.

  Es la solución exacta de los tres problemas de carga que fueron apareciendo a lo largo
  de todo el apunte: el divisor resistivo que se derrumba cuando se le cuelga algo
  (Módulo 7), el voltímetro que altera la tensión que está midiendo (Módulo 1) y los
  filtros RC en cascada que se corren la frecuencia de corte entre sí (Módulo 12). Los
  tres se arreglan metiendo un seguidor en el medio.
]

#ejercicio("El divisor que se derrumba, y el seguidor que lo salva")[
  Un divisor de $10 "k"Omega$ y $10 "k"Omega$ sobre una fuente de 10 V tiene que
  alimentar una carga de $1 "k"Omega$.

  *1. Sin seguidor.* La carga queda en paralelo con el resistor de abajo:
  $ 10 "k" parallel 1 "k" = (10 dot 1)/(10 + 1) = 0,909 "k"Omega $
  $ v_"carga" = 10 dot (0,909)/(10 + 0,909) = 0,83 "V" $
  Se esperaban 5 V y hay 0,83 V. El divisor no está roto: está cargado.

  *2. Con un seguidor entre el divisor y la carga.* El seguidor no le pide corriente al
  divisor (Regla 2), así que el divisor entrega sus 5 V limpios; y el seguidor se los
  entrega a la carga sin caerse, porque su impedancia de salida es despreciable.
  $ v_"carga" = 5 "V" $

  *3. De dónde sale la corriente que ahora consume la carga.* De la fuente de
  alimentación del operacional, no del divisor. $5 "V" \/ 1 "k"Omega = 5$ mA, que salen
  por el terminal $+V_"CC"$. Ese es el trabajo que el seguidor hace y que el divisor solo
  no podía hacer.
]

=== Amplificador inversor

Deducido en la sección anterior. Se repite acá sólo el resultado, para que la tabla de
configuraciones tenga sus ecuaciones juntas:

$ v_o = - (R_f)/(R_i) thin v_i quad quad quad Z_"ent" = R_i $ <ec-ao-inversor>

Es la única configuración que puede tener ganancia *menor que 1* con signo cambiado
(basta con $R_f < R_i$), y la única cuya impedancia de entrada es baja y elegible.

=== Amplificador no inversor

#circuito([Amplificador no inversor])[
#fig-ao-no-inversor()
#pie-figura[La señal entra por la pata del $+$, que no toma corriente: la impedancia de
  entrada es la del operacional, enorme. $R_1$ va del nodo virtual a masa.]
]

#ejercicio("El no inversor, por el mismo camino")[
  *1. El test.* $R_f$ va de la salida a la pata del $-$: realimentación negativa. ✓

  *2. El nodo virtual.* La señal entra directamente por la no inversora, así que
  $v_+ = v_i$, y por la Regla 1:
  $ v_x = v_i $
  Notar la diferencia con el inversor: acá el nodo virtual *no* está a cero, está a
  $v_i$. No hay tierra virtual en este circuito.

  *3. La LKC en el nodo $v_x$.* Cuelgan $R_1$ hacia masa y $R_f$ hacia la salida:
  $ (v_x - 0)/(R_1) + (v_x - v_o)/(R_f) = 0 $

  *4. Reemplazar $v_x = v_i$ y despejar.* Multiplicando por $R_1 R_f$:
  $ v_i R_f + v_i R_1 - v_o R_1 = 0 quad arrow.r quad v_o R_1 = v_i (R_1 + R_f) $
  $ v_o = (1 + (R_f)/(R_1)) v_i $

  *5. Leer el resultado.* La ganancia es siempre *mayor o igual que 1* —el $1 +$ no se
  puede sacar— y del mismo signo que la entrada. Con $R_f = 0$ o $R_1 = infinity$ queda
  ganancia 1, que es el seguidor: el seguidor es el caso extremo de esta configuración,
  no una configuración aparte.
]

$ v_o = (1 + (R_f)/(R_1)) thin v_i quad quad quad Z_"ent" approx infinity $ <ec-ao-noinversor>

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([], [*Inversor*], [*No inversor*]),
    [Ganancia], [$-R_f\/R_i$, cualquier valor], [$1 + R_f\/R_1$, nunca menor que 1],
    [Signo], [invertido], [conservado],
    [Impedancia de entrada], [$R_i$ (baja, elegible)], [la del operacional (enorme)],
    [Tierra virtual], [sí: el nodo está a 0 V], [no: el nodo está a $v_i$],
    [Cuándo se elige],
      [cuando hace falta ganancia $< 1$, sumar señales, o invertir a propósito],
      [cuando la fuente es débil y no se le puede pedir corriente],
  ),
  caption: [Las dos configuraciones básicas, comparadas donde de verdad se diferencian],
)

=== Sumador inversor

#circuito([Sumador inversor de dos entradas])[
#fig-ao-sumador()
#pie-figura[Las dos ramas llegan al *mismo* nodo virtual. Como está a 0 V fijo, ninguna
  de las dos se entera de la otra.]
]

#ejercicio("El sumador, y por qué las entradas no se estorban")[
  *1 y 2.* Realimentación negativa; entrada no inversora a masa, así que $v_x = 0$: hay
  tierra virtual, igual que en el inversor.

  *3. La LKC en el nodo $v_x$*, ahora con tres ramas:
  $ (v_x - v_a)/(R_a) + (v_x - v_b)/(R_b) + (v_x - v_o)/(R_f) = 0 $

  *4. Con $v_x = 0$:*
  $ - (v_a)/(R_a) - (v_b)/(R_b) - (v_o)/(R_f) = 0
    quad arrow.r quad v_o = - R_f ((v_a)/(R_a) + (v_b)/(R_b)) $

  *5. Un caso concreto.* Con $R_a = R_b = R_f = 10 "k"Omega$ la salida es
  $-(v_a + v_b)$: la suma, invertida. Con $R_a = 10 "k"Omega$, $R_b = 20 "k"Omega$ y
  $R_f = 10 "k"Omega$ queda $-(v_a + 0,5 thin v_b)$: una suma *ponderada*, y los pesos
  los eligen los resistores de entrada por separado.
]

#clave[
  *La razón profunda por la que este circuito funciona es la tierra virtual.* Como el
  nodo $v_x$ está clavado en 0 V pase lo que pase, la corriente que aporta cada rama
  depende *sólo* de su propia fuente y su propio resistor: $v_a\/R_a$ no cambia si $v_b$
  se mueve.

  Sin operacional, ese mismo circuito —tres resistores a un nodo común— sí se estorba: la
  tensión del nodo depende de las tres fuentes a la vez y ninguna corriente es
  independiente. Lo que compra el operacional es *aislamiento entre las entradas*, y por
  eso se puede sumar cualquier cantidad de señales agregando ramas, sin recalcular nada.

  De ahí sale el conversor digital-analógico por red resistiva: cada bit entra por su
  rama con un resistor que vale el doble que el anterior, y la salida es el número.
]

=== Restador (amplificador diferencial)

#circuito([Amplificador diferencial, o restador])[
#fig-ao-restador()
#pie-figura[Los dos pares de resistores tienen que ser iguales entre sí. Esa simetría es
  la que hace que la salida sea la resta y no otra cosa.]
]

Esta es la primera configuración donde el nodo del cortocircuito virtual *no* está ni a
masa ni a la entrada: hay que calcularlo.

#ejercicio("El restador, en dos nodos")[
  *1 y 2. El nodo virtual, que ahora hay que calcular.* La entrada no inversora es la
  salida de un divisor formado por $R_1$ y $R_2$ desde $v_2$ hasta masa. Como por la pata
  no entra corriente (Regla 2), el divisor no está cargado:
  $ v_y = v_2 (R_2)/(R_1 + R_2) $
  y por la Regla 1, ese mismo valor es la tensión del nodo de la izquierda: $v_x = v_y$.

  *3. La LKC en el nodo $v_x$:*
  $ (v_x - v_1)/(R_1) + (v_x - v_o)/(R_2) = 0 $

  *4. Despejar $v_o$* y reemplazar $v_x$ por la expresión del paso 2:
  $ v_o = v_x (1 + (R_2)/(R_1)) - v_1 (R_2)/(R_1) $
  $ v_o = v_2 (R_2)/(R_1 + R_2) dot (R_1 + R_2)/(R_1) - v_1 (R_2)/(R_1) $
  $ v_o = (R_2)/(R_1) (v_2 - v_1) $

  *5. Leer el resultado.* La salida es la *diferencia* entre las dos entradas,
  amplificada por $R_2\/R_1$. Todo lo que las dos entradas tengan en común desaparece.
]

#clave[
  *Lo que este circuito hace de verdad es ignorar el ruido común.* Si las dos entradas
  tienen encima el mismo zumbido de 50 Hz —cosa habitual en un cable largo—, la resta lo
  cancela y sólo queda la señal. Esa capacidad tiene nombre: *rechazo de modo común*.

  Y depende enteramente de que los dos pares de resistores sean iguales. Con resistores
  al 5%, el desapareo deja pasar una fracción del modo común y el rechazo se desploma; por
  eso los diferenciales de verdad se hacen con resistores al 0,1% o con redes apareadas
  en el mismo encapsulado.
]

#atencion[
  *La impedancia de entrada del restador es baja y, peor, distinta para cada entrada.*
  $v_1$ ve $R_1$ contra un nodo que se mueve; $v_2$ ve $R_1 + R_2$ contra masa. Es el
  defecto grande de esta configuración, y es exactamente el que resuelve el amplificador
  de instrumentación de más abajo.
]

=== Integrador y derivador

#circuito([Integrador y derivador: el inversor con un capacitor])[
#fig-ao-integrador-derivador()
#pie-figura[Son el mismo circuito que el inversor, con un capacitor en lugar de uno de
  los dos resistores. Cuál de los dos decide si integra o deriva.]
]

Acá se usan las impedancias del Módulo 11 y la corriente del capacitor del Módulo 10
(la relación $i = C thin dif v \/ dif t$). La deducción es la misma de siempre, con esa
corriente en lugar de la de un resistor.

#ejercicio("El integrador, deducido con la corriente del capacitor")[
  *1 y 2.* Realimentación negativa, entrada no inversora a masa: $v_x = 0$, tierra
  virtual.

  *3. La LKC en el nodo $v_x$*, ahora con una rama capacitiva. La corriente que sale del
  nodo hacia la salida a través de $C$ vale $C thin dif(v_x - v_o)\/dif t$:
  $ (v_x - v_i)/(R) + C (dif (v_x - v_o))/(dif t) = 0 $

  *4. Con $v_x = 0$ y despejando:*
  $ - (v_i)/(R) - C (dif v_o)/(dif t) = 0
    quad arrow.r quad (dif v_o)/(dif t) = - (v_i)/(R C) $
  $ v_o (t) = - 1/(R C) integral v_i (t) thin dif t + v_o (0) $

  *5. Leer el resultado con una entrada concreta.* Con $v_i$ constante, la integral de
  una constante es una rampa: la salida baja linealmente. Un integrador con un escalón a
  la entrada es un *generador de rampas*, y ésa es su aplicación más común.

  *6. El problema que tiene y que no se ve en la fórmula.* La constante $v_o (0)$ dice que
  el integrador *acumula*: cualquier tensión de #emph[offset] del operacional, por chica
  que sea, se integra sin parar y termina llevando la salida contra un riel. Un integrador
  real siempre lleva un resistor grande en paralelo con $C$, que le pone un techo a la
  ganancia en continua y evita la deriva.
]

Para el derivador, con $C$ en la entrada, la misma cuenta da

$ v_o (t) = - R C (dif v_i)/(dif t) $ <ec-ao-derivador>

#atencion[
  *El derivador se usa poco, y no es por capricho.* Derivar amplifica lo que cambia
  rápido, y lo que más rápido cambia en un circuito real es el *ruido*. Un derivador toma
  un ruido de milivolts y lo convierte en picos de volts.

  Visto con las herramientas del Módulo 12: su ganancia crece $20$ dB por década sin
  techo, así que a frecuencias altas amplifica todo lo que le llegue. El integrador hace
  lo contrario —atenúa a frecuencia alta— y por eso es estable y se usa a cada rato.
]

=== Amplificador de instrumentación

#circuito([Amplificador de instrumentación de tres operacionales])[
#fig-ao-instrumentacion()
#pie-figura[Los dos operacionales de entrada son no inversores que comparten $R_G$; el
  tercero es el restador de la sección anterior. Toda la ganancia se ajusta con un solo
  resistor.]
]

Es la configuración más útil de todas las que hay acá y no tiene ninguna idea nueva: es
un restador con dos no inversores adelante. Se explica en tres pasos.

+ *Los dos operacionales de entrada resuelven la impedancia.* Cada señal entra por una
  pata del $+$, que no toma corriente. La fuente —un termopar, una celda de carga, un
  electrodo— no se entera de que está conectada a nada.
+ *$R_G$ es único y por eso la ganancia se ajusta con un solo componente.* Por la Regla 1,
  la tensión en los extremos de $R_G$ es $v_1$ de un lado y $v_2$ del otro; entonces por
  $R_G$ circula $(v_1 - v_2)\/R_G$, y esa misma corriente atraviesa los dos $R_3$
  (Regla 2). La ganancia de la primera etapa queda
  $ (v_"s1" - v_"s2")/(v_1 - v_2) = 1 + (2 R_3)/(R_G) $
+ *El tercer operacional hace la resta* y aporta su propia ganancia $R_5\/R_4$.

$ v_o = (R_5)/(R_4) (1 + (2 R_3)/(R_G)) (v_2 - v_1) $ <ec-ao-instrumentacion>

#clave[
  *Por qué esto es mejor que el restador solo, en una frase:* el rechazo de modo común ya
  no depende de que la *fuente* esté balanceada, y la ganancia se cambia girando un solo
  resistor sin tocar el apareo de los otros cuatro.

  En un restador simple, subir la ganancia obliga a cambiar dos resistores a la vez
  manteniéndolos apareados con los otros dos. Acá el apareo vive en $R_4$ y $R_5$, que se
  dejan fijos, y la ganancia vive en $R_G$, que es libre. Esa separación entre "lo que da
  precisión" y "lo que da ganancia" es la razón de existir del circuito, y es la misma
  idea de desacople que aparece en los filtros activos.
]

#laboratorio[
  Los amplificadores de instrumentación se compran hechos —INA126, AD620— con los cinco
  resistores integrados y apareados por construcción, y un par de patas para colgarle
  $R_G$. Armarlo con tres operacionales sueltos y resistores del cajón funciona para
  entender el circuito, pero el rechazo de modo común que se consigue así es del orden de
  40 dB, contra los 100 dB de un integrado. La diferencia no está en el esquema: está en
  el apareo.
]

=== Las que faltan, en una tabla

Las cinco de abajo se deducen exactamente igual y no agregan ninguna idea nueva; se
listan para que el catálogo esté completo.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Configuración*], [*Salida*], [*Idea*]),
    [Conversor corriente-tensión],
      [$v_o = - R_f thin i_"ent"$],
      [la corriente entra directo a la tierra virtual y sale por $R_f$; es como se lee un
       fotodiodo],
    [Conversor tensión-corriente],
      [$i_"carga" = v_i \/ R$],
      [la carga va en la realimentación: la corriente no depende de cuánto valga la carga],
    [Filtro activo pasa bajos],
      [$-(R_f\/R_i) \/ (1 + j omega R_f C)$],
      [un inversor con $C$ en paralelo con $R_f$; ganancia y corte se eligen por separado],
    [Amplificador logarítmico],
      [$v_o prop -ln(v_i)$],
      [un diodo en la realimentación; usa la curva exponencial del Módulo 4],
    [Fuente de tensión de referencia],
      [$v_o = v_"zener" (1 + R_f\/R_1)$],
      [un no inversor con un zener en la entrada: el zener no se carga (Módulo 5)],
  ),
  caption: [Cinco configuraciones más, con la idea que las explica],
)

#ejercicio("Filtro activo pasa bajos de primer orden")[
  Un inversor con $R_i = 10 "k"Omega$ a la entrada y, en la realimentación,
  $R_f = 100 "k"Omega$ *en paralelo* con $C = 1,59$ nF.

  *1. La impedancia de realimentación*, con las herramientas del Módulo 11:
  $ overline(Z)_f = R_f parallel 1/(j omega C) = (R_f)/(1 + j omega R_f C) $

  *2. La transferencia.* La deducción del inversor no usó en ningún momento que las dos
  ramas fueran resistores: vale igual con impedancias.
  $ overline(H)(j omega) = - (overline(Z)_f)/(R_i)
    = - (R_f\/R_i)/(1 + j omega R_f C) $
  Es la forma canónica del pasa bajos del Módulo 12, multiplicada por una ganancia.

  *3. Los dos números de diseño, que salen por separado.*
  $ "Ganancia en continua" = -(R_f)/(R_i) = -10 quad (20 "dB") $
  $ f_c = 1/(2 pi R_f C) = 1/(2 pi dot 10^5 dot 1,59 dot 10^(-9)) = 1000 "Hz" $

  *4. Por qué es mejor que el RC pasivo.* Amplifica en vez de atenuar; su impedancia de
  salida es casi nula, así que la etapa siguiente no le corre la frecuencia de corte; y
  $R_i$, $R_f$ y $C$ fijan *ganancia y corte por separado*, cosa que en el RC pasivo es
  imposible. Ese desacople es la razón de ser de los filtros activos.

  *5. El control de realidad.* Con un operacional de producto ganancia-ancho de banda
  $"GBW" = 1$ MHz, a ganancia 10 el ancho de banda disponible es $10^6\/10 = 100$ kHz.
  Como el filtro corta en 1 kHz, hay margen de sobra. Si se hubiera pedido ganancia 1000,
  el ancho de banda propio del operacional (1 kHz) se metería adentro de la banda de paso
  y el filtro no sería el que se diseñó.
]

== Los tres casos donde el cortocircuito virtual NO vale

Todo lo anterior descansa en una condición que se verificó cada vez con el test de tres
preguntas. Esta sección es la otra mitad: los tres circuitos donde la condición no se
cumple, qué los delata en el dibujo y con qué se los reemplaza.

*No son casos patológicos ni errores de diseño.* Los tres se construyen a propósito y
los tres son útiles. Lo que sí es un error es aplicarles la Regla 1.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header(
      [*Caso*], [*Cómo se reconoce en el dibujo*], [*Con qué se reemplaza la Regla 1*]),
    [Sin realimentación],
      [el cable de la salida no llega a ninguna pata],
      [$v_o = +V_"CC"$ si $v_+ > v_-$; $v_o = -V_"CC"$ si $v_+ < v_-$],
    [Realimentación positiva],
      [el cable de la salida llega a la pata del $+$],
      [lo mismo, más el cálculo de los dos umbrales],
    [Realimentación negativa pero saturado],
      [el cálculo da $|v_o| > V_"CC"$],
      [$v_o$ se queda pegado al riel; la entrada sigue subiendo y la salida no],
  ),
  caption: [Los tres casos donde la Regla 1 es falsa, y qué usar en su lugar],
)

=== Caso 1: sin realimentación — el comparador

#circuito([Comparador y disparador de Schmitt: los dos casos sin cortocircuito virtual])[
#fig-ao-comparador-schmitt()
#pie-figura[La diferencia entre los dos dibujos es *a qué pata llega el cable que viene
  de la salida*. En el de la izquierda no llega a ninguna; en el de la derecha, a la
  del $+$. En ninguno de los dos vale $v_+ = v_-$.]
]

Sin camino de vuelta, el operacional no tiene forma de igualar sus entradas: empuja con
toda su ganancia y llega al riel. La única ecuación disponible es la
@ec-ao-lazo-abierto, y su lectura práctica es una comparación:

$ v_o = cases(
  +V_"CC" quad & "si" v_+ > v_-,
  -V_"CC" quad & "si" v_+ < v_-,
) $ <ec-ao-comparador>

#ejercicio("Detector de nivel de luz")[
  Un LDR y un resistor forman un divisor cuya salida, con la luz de la habitación,
  vale 4 V y en la oscuridad sube a 9 V. Se quiere encender una alarma cuando oscurezca.
  Alimentación de 12 V, $V_"REF" = 6$ V en la entrada inversora.

  *1. Correr el test.* La salida no vuelve a ninguna pata: la pregunta 1 da que no. La
  Regla 1 no vale, y no hay que buscar ninguna ganancia.

  *2. Aplicar la @ec-ao-comparador.* Con luz, $v_+ = 4 < 6 = v_-$, así que la salida está
  contra el riel negativo. A oscuras, $v_+ = 9 > 6$, y la salida salta al positivo.

  *3. Leer lo que hace el circuito.* La salida sólo toma dos valores: es una señal
  *digital* sacada de una analógica. El operacional dejó de ser un amplificador y pasó a
  ser un decisor.

  *4. El problema que este circuito tiene.* Al anochecer, la tensión del divisor pasa por
  6 V despacio, y encima lleva ruido. Cada vez que el ruido la cruza, la salida conmuta.
  Durante el minuto que dura el crepúsculo la alarma prende y apaga decenas de veces. Eso
  se arregla con el circuito de la sección siguiente.
]

=== Caso 2: realimentación positiva — el disparador de Schmitt

El cable de la salida llega a la pata del $+$. Ahora subir la salida sube $v_+$, lo que
sube más la salida: el lazo se dispara y no hay equilibrio posible. La salida vive
pegada a un riel y salta al otro cuando la entrada cruza un umbral.

La gracia es que *el umbral depende de en qué riel está la salida*, y por eso son dos.
Con la salida en $+V_"CC"$, el divisor $R_1$–$R_2$ pone en la pata del $+$:

$ V_"UP" = +V_"CC" (R_1)/(R_1 + R_2) $ <ec-ao-schmitt-alto>

y con la salida en $-V_"CC"$, el mismo divisor pone $V_"DOWN" = -V_"CC" R_1\/(R_1 + R_2)$.

#clave[
  *Eso es la histéresis, y es la solución del problema del comparador.* La señal tiene
  que subir por encima de $V_"UP"$ para que conmute hacia un lado, y después bajar por
  debajo de $V_"DOWN"$ —que es *más bajo*— para que vuelva. Entre los dos umbrales hay una
  banda muerta donde el ruido no logra hacer conmutar nada.

  El ancho de esa banda se elige con $R_1$ y $R_2$: se la hace un poco más grande que el
  ruido esperado y el circuito deja de vibrar. Un termostato hace exactamente esto —por
  eso enciende a 19 °C y apaga a 21 °C en vez de traquetear alrededor de 20—.
]

#atencion[
  *Un Schmitt y un no inversor se dibujan casi igual*: mismo triángulo, mismos dos
  resistores, mismo divisor. Lo único que cambia es a cuál de las dos patas llega la
  realimentación y por cuál entra la señal.

  Y las respuestas son opuestas: uno amplifica linealmente, el otro sólo da dos valores.
  Es el argumento más fuerte a favor de correr el test de tres preguntas *antes* de
  escribir la primera ecuación, en vez de reconocer el circuito por su forma.
]

=== Caso 3: realimentación negativa, pero saturado

Este es el más traicionero de los tres, porque el test de las preguntas 1 y 2 da bien:
hay realimentación y es negativa. Falla la pregunta 3.

#ejercicio("El inversor que no amplifica: saturación")[
  Un inversor con $R_i = 1 "k"Omega$, $R_f = 100 "k"Omega$ y alimentación
  $plus.minus 12$ V. Se le aplica $v_i = 0,5$ V.

  *1 y 2.* Realimentación negativa. ✓

  *3. Aplicar la fórmula del inversor:*
  $ v_o = -(100)/(1) dot 0,5 = -50 "V" $

  *4. Correr la pregunta 3.* La alimentación es de 12 V: la salida no puede valer $-50$ V.
  El resultado del paso 3 es imposible, y por lo tanto la Regla 1 no valía.

  *5. Lo que pasa de verdad.* La salida se queda en unos $-10,5$ V —un LM741 no llega al
  riel— y ahí se detiene. Y como ya no puede moverse más, deja de poder igualar las
  entradas: el nodo $v_x$ *no está en 0 V*, y todo el análisis anterior se cae.

  *6. Cuál es la señal más grande que este circuito admite.* Para que $|v_o| < 10,5$ V:
  $ |v_i| < (10,5)/(100) = 105 thin "mV" $
  Con 0,5 V de entrada, este amplificador entrega una onda cuadrada de 21 V pico a pico
  en lugar de una senoidal. El circuito no está roto: está mal dimensionado.
]

#laboratorio[
  *Nueve de cada diez "el operacional no amplifica" son saturación.* El síntoma en el
  osciloscopio es inconfundible una vez que se sabe qué mirar: la senoidal sale con las
  dos puntas *aplanadas*, cortadas a la misma altura, y esa altura es la alimentación
  menos un volt y medio.

  El procedimiento de diagnóstico, en orden y en un minuto:

  + Medir la alimentación en las patas del integrado. No en la fuente: en las patas.
  + Bajar la amplitud de entrada hasta que la senoidal deje de estar aplanada. Si la
    forma se arregla, era saturación y no hay nada más que buscar.
  + Recién si con señal chica sigue mal, sospechar del circuito.

  Con un LM741 hace falta alimentación *simétrica* y su salida no llega a menos de 1,5 V
  de cada riel; con un LM358 o un TL072 se puede trabajar con fuente simple. Un
  operacional #emph[rail-to-rail] llega a milivolts del riel, y es lo que conviene cuando
  la alimentación es de 3,3 o 5 V y no sobra excursión.
]

== El operacional real

Todo lo anterior usó el operacional ideal. Las cinco limitaciones de abajo son la
distancia entre esa idealización y lo que se mide en el banco, y cada una tiene una
condición concreta en la que empieza a doler.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Limitación*], [*Qué significa*], [*Cuándo muerde*]),
    [Ganancia finita ($A_"ol" approx 10^5$)],
      [las dos reglas son una aproximación, no una identidad],
      [con ganancias de lazo cerrado muy altas, donde $A_"ol"$ deja de ser "infinita"
       comparada con ellas],
    [Producto ganancia-ancho de banda],
      [$G dot "BW" = "GBW"$, constante para cada modelo],
      [siempre: más ganancia es menos banda, y no se negocia],
    [#emph[Slew rate] ($approx 0,5 "V"\/mu"s"$ en un 741)],
      [velocidad máxima a la que la salida puede cambiar],
      [con señales grandes y rápidas: la senoidal sale triangular],
    [Tensión de #emph[offset] y corrientes de polarización],
      [la salida no da cero con entrada cero],
      [en continua y con ganancias altas; es lo que arruina un integrador],
    [Excursión de salida],
      [la salida no llega hasta la alimentación],
      [siempre: por eso satura antes de lo que dice la cuenta],
  ),
  caption: [Las cinco limitaciones que hacen que el circuito medido no dé lo calculado],
)

#ejercicio("Las dos que más sorprenden, con números")[
  *A. Producto ganancia-ancho de banda.* Un TL072 tiene $"GBW" = 3$ MHz. ¿Sirve para
  amplificar audio (20 kHz) con ganancia 200?
  $ "BW" = ("GBW")/(G) = (3 dot 10^6)/(200) = 15 "kHz" $
  No: los agudos por encima de 15 kHz se atenúan. La salida es armar *dos etapas de
  ganancia 14* en cascada, que dan $14 dot 14 approx 200$ con un ancho de banda de
  $3 dot 10^6\/14 = 214$ kHz cada una. Misma ganancia total, diez veces más banda, un
  operacional más de costo.

  *B. #emph[Slew rate].* El mismo TL072 tiene $"SR" = 13 thin "V"\/mu"s"$. ¿Cuál es la
  senoidal más rápida que puede entregar con 10 V de pico?

  La pendiente máxima de $v_o = V_p sin(omega t)$ es $omega V_p$, así que
  $ f_max = ("SR")/(2 pi V_p) = (13 dot 10^6)/(2 pi dot 10) = 207 "kHz" $
  Por encima de eso, la senoidal de 10 V sale *triangular*: la salida no llega a subir a
  tiempo. Y notar que el límite depende de la *amplitud* — la misma senoidal de 1 V de
  pico llega hasta 2 MHz.

  *La conclusión que conviene retener:* el ancho de banda del punto A vale para señales
  chicas; el #emph[slew rate] es un límite aparte que aparece con señales grandes. Un
  circuito puede estar cómodo en banda y estar limitado por #emph[slew rate], y el
  osciloscopio los distingue a simple vista: en el primer caso la senoidal sale más
  chica, en el segundo sale deformada.
]

== Cierre: qué quedó y con qué se conecta

#clave[
  *Si hay que llevarse una sola cosa de este módulo, es el orden de las preguntas.*

  Primero se mira el dibujo y se contesta si la Regla 1 vale. Recién después se escriben
  ecuaciones. Al revés —fórmula primero, verificación nunca— es como se llega a un
  resultado de $-50$ V en un circuito alimentado con 12, y a creerle.
]

Este módulo cierra el apunte, y conviene ver cuántas cosas de los anteriores volvieron a
aparecer acá, porque no es casualidad: el operacional es el componente que las usa todas.

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([*De dónde venía*], [*Dónde reapareció acá*]),
    [Módulo 1 — el voltímetro altera lo que mide],
      [el seguidor es la solución exacta a ese problema],
    [Módulo 4 — la curva exponencial del diodo],
      [el amplificador logarítmico, con un diodo en la realimentación],
    [Módulo 5 — el regulador con zener que se carga],
      [el zener en la pata del $+$, que no toma corriente],
    [Módulo 7 — el divisor que se derrumba al cargarlo],
      [el ejercicio del seguidor, con los 0,83 V contra los 5 V],
    [Módulo 8 — análisis nodal y sus tres convenciones],
      [*el método con el que se resolvieron las nueve configuraciones*],
    [Módulo 10 — la corriente del capacitor: $i = C thin dif v \/ dif t$],
      [el integrador y el derivador],
    [Módulo 11 — impedancias complejas],
      [el filtro activo: la deducción del inversor vale igual con $overline(Z)$],
    [Módulo 12 — pasa bajos, frecuencia de corte, dB por década],
      [el filtro activo y el producto ganancia-ancho de banda],
    [Módulo 13 — cuadripolos],
      [el operacional realimentado es un cuadripolo activo: entrada, salida, y cuatro
       números que lo describen sin mirar adentro],
  ),
  caption: [Lo que el operacional trajo de vuelta de cada módulo anterior],
)

La fila del Módulo 8 es la importante. Un apunte que presentara el operacional como una
lista de fórmulas para memorizar estaría desperdiciando lo mejor que tiene: es el
componente donde el método de análisis de circuitos —el mismo de siempre, con dos datos
más— resuelve en tres renglones lo que de otro modo serían diez casos sueltos.

Con esto queda cubierto el programa completo de *Teoría de Circuitos*: señales y
respuestas natural y forzada (Módulo 10), fasores y régimen permanente senoidal
(Módulo 11), diagramas de Bode y señales poliarmónicas (Módulo 12), resolución
sistemática de circuitos (Módulos 7 a 9), teoría de los cuadripolos (Módulo 13) y el
amplificador operacional con sus configuraciones y su filtrado activo (este módulo).

#clave[
  El hilo que atraviesa la Parte II, dicho en una línea: *todo circuito lineal se resuelve
  con Kirchhoff; elegir bien las incógnitas lo hace corto; los teoremas lo hacen
  reutilizable; los complejos lo extienden a la alterna; y el logaritmo lo extiende a todas
  las frecuencias a la vez.* Lo que sigue en la carrera —Señales y Sistemas, Electrónica
  Analógica, Control— reemplaza $j omega$ por la variable compleja $s$ y sigue exactamente
  desde acá.
]

