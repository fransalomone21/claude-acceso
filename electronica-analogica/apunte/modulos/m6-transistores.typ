#import "../plantilla.typ": *

#modulo("Transistores BJT y etapas de conmutación", [
  Explicar las tres zonas de trabajo de un transistor bipolar y por qué en conmutación
  solo se usan dos, diseñar desde cero la resistencia de base de una etapa ON/OFF con
  criterio de saturación forzada, comandar un relé con la protección correcta, y leer una
  hoja de datos eligiendo el peor caso en vez del típico.
])

== El transistor bipolar

Un BJT (#emph[Bipolar Junction Transistor]) son tres capas de semiconductor dopadas
alternadamente, con tres terminales: *base* (B), *colector* (C) y *emisor* (E). Hay dos
tipos, NPN y PNP, que funcionan igual pero con las polaridades invertidas.

#circuito([Símbolos y polaridades del transistor bipolar])[
#fig-simbolos-bjt()
#pie-figura[En el NPN, $V_C > V_B > V_E$: la corriente entra por el colector y
  sale por el emisor. En el PNP es al revés, $V_E > V_B > V_C$.]
]

La ley que gobierna las corrientes es la primera de Kirchhoff aplicada al componente:

$ I_E = I_B + I_C $ <ec-corrientes-bjt>

y la ganancia de corriente, que es lo que hace útil al transistor:

$ beta = h_"FE" = I_C / I_B $ <ec-beta>

Una corriente chica en la base controla una corriente grande en el colector. Un $beta$ de
200 significa que 1 mA de base habilita 200 mA de colector.

=== Las tres zonas de trabajo

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.header([*Zona*], [*Condición*], [*Comportamiento*], [*Potencia disipada*]),
    [*Corte*], [$V_"BE" < 0,7$ V, $I_B = 0$],
    [$I_C approx 0$. El transistor es una *llave abierta*.],
    [$P = V_"CE" dot I_C approx 0$ (porque $I_C approx 0$)],
    [*Activa*], [$I_C = beta dot I_B$],
    [Amplificador lineal. La salida sigue a la entrada.],
    [*Alta*: hay tensión y corriente al mismo tiempo],
    [*Saturación*], [$I_B$ excesiva, $V_"CE" approx 0,2$ V],
    [$I_C$ lo fija la carga, no $beta$. Es una *llave cerrada*.],
    [$P = 0,2 "V" dot I_C approx 0$ (porque $V_"CE" approx 0$)],
  ),
  caption: [Zonas de trabajo del transistor bipolar],
)

#clave[
  *Por qué en conmutación se usan solo corte y saturación.* La potencia que un transistor
  disipa es $P = V_"CE" dot I_C$. En corte la corriente es cero; en saturación la tensión
  es casi cero. En ambos casos el producto es despreciable y el transistor se mantiene
  frío. En la zona activa, en cambio, hay tensión *y* corriente simultáneamente, y el
  transistor se calienta. Trabajar como llave permite manejar corrientes grandes con un
  transistor chico; trabajar en zona activa, no. Por eso las etapas ON/OFF *cruzan* la
  zona activa lo más rápido posible en vez de quedarse en ella.
]

#circuito([Curvas de salida y recta de carga: la conmutación usa solo los extremos])[
#graf-recta-de-carga()
#pie-figura[Cada curva azul es un valor de $I_B$. La recta roja son los puntos que
  permite el circuito exterior ($V_"cc"$ y la carga). El transistor trabaja donde se
  cruzan: arriba a la izquierda en saturación, abajo a la derecha en corte, y en la
  conmutación no se queda en el medio.]
]

=== Los valores de trabajo que hay que memorizar

- $V_(upright("BE")(upright("on")))approx 0,7$ V — la base es una juntura PN como cualquier diodo.
- $V_(upright("CE")(upright("sat")))approx 0,2$ V — lo que queda entre colector y emisor con la llave "cerrada".
- $I_C = beta dot I_B$ *solo en zona activa*. En saturación esa igualdad ya no vale.

== Diseño de una etapa de conmutación

Este es el procedimiento completo, y se hace *siempre en este orden*: de la carga hacia
la base, nunca al revés.

#circuito([Etapa de conmutación con transistor NPN])[
#fig-conmutacion-npn()
]

*Paso 1 — La carga fija $I_C$.* Se calcula la corriente que la carga necesita:
$I_C = V_"cc" \/ R_"carga"$, o se la lee de la hoja de datos del relé.

*Paso 2 — Elegir el transistor.* Se verifica en el datasheet que $I_(C "máx")$ del
transistor sea *cómodamente mayor* que la $I_C$ calculada, y que $V_"CEO"$ supere la
tensión de alimentación.

*Paso 3 — Forzar la saturación.* Acá está el criterio central del módulo. No se usa el
$beta$ real del transistor, sino uno *forzado*, mucho más chico:

$ I_B = I_C / beta_"forzado" quad quad "con" quad beta_"forzado" = 10 " (típico)" $ <ec-beta-forzado>

*Paso 4 — Calcular $R_B$.* Recorriendo la malla de entrada, la tensión de comando se
reparte entre la resistencia y la juntura base-emisor:

$ V_"in" = I_B dot R_B + V_"BE" quad arrow.r.double quad
  R_B = (V_"in" - V_"BE") / I_B $ <ec-rb>

*Paso 5 — Adoptar el valor comercial y reverificar.* Se toma el valor E24 más cercano
*por debajo* (para que $I_B$ no baje) y se recalculan $I_B$ y $beta_"forzado"$ reales.

#atencion[
  *Por qué no se usa el $beta$ del datasheet.* El $h_"FE"$ de un BC547 puede valer entre
  110 y 800 según el ejemplar, la temperatura y la corriente: un factor 7 de dispersión
  entre dos transistores de la misma bolsa. Si se dimensiona $R_B$ con el $beta$ típico,
  el ejemplar que salga con $beta$ bajo *no llega a saturar*, queda en zona activa, disipa
  potencia y se calienta. Sobreexcitando la base entre 3 y 10 veces, *cualquier* ejemplar
  satura. Se desperdicia un poco de corriente de base a cambio de que el circuito funcione
  siempre. Es un criterio de ingeniería, no una fórmula.
]

== El relé

#definicion("Relé")[
  Interruptor accionado eléctricamente. Una *bobina* genera un campo magnético que atrae
  una armadura mecánica, y esa armadura cierra o abre unos *contactos* que están
  eléctricamente aislados de la bobina. Permite que un circuito de baja tensión y baja
  potencia comande otro de alta tensión y alta potencia, sin ningún contacto eléctrico
  entre ambos.
]

Sus contactos se denominan *NA* (normalmente abierto: se cierra al activar la bobina),
*NC* (normalmente cerrado: se abre al activar) y *común*. Sus dos especificaciones
críticas son la *tensión y corriente de bobina* — lo que el transistor debe manejar — y la
*capacidad de los contactos* — lo que el relé puede conmutar, típicamente algo como
"10 A / 250 V~".

=== El diodo volante: no es opcional

#circuito([Etapa completa con relé y diodo de protección])[
#fig-rele-completo()
]

La bobina del relé es un *inductor*: almacena energía en su campo magnético. Cuando el
transistor corta, la corriente de la bobina intenta seguir circulando, y por la ley de
Faraday del Módulo 3 aparece una tensión inducida enorme — cientos de volts — con
polaridad *opuesta*. Esa tensión aparece sobre el colector y *perfora el transistor*.

El *diodo volante* (o de recirculación, o #emph[flyback]) se coloca en antiparalelo con la
bobina: en funcionamiento normal está en inversa y no hace nada, pero al cortar queda
directamente polarizado por la tensión inducida y le ofrece a la corriente un camino
cerrado por donde extinguirse suavemente.

#atencion[
  El diodo va *en paralelo con la bobina*, con el *cátodo (la banda) hacia el positivo*.
  Al revés queda en directa permanentemente: cortocircuita la fuente y quema todo apenas
  se enciende. Es el error de armado más frecuente de este módulo, y el más caro.
]

#ejercicio("Comandar un relé de 12 V desde una salida de 5 V")[
  Diseñar la etapa que active un relé de 12 V cuya bobina tiene 400 $Omega$, comandado
  desde una salida lógica de 5 V, usando un BC547.

  *1. Corriente de colector — la fija la carga*:
  $ I_C = V_"cc"/R_"bobina" = (12 "V")/(400 Omega) = 30 "mA" $

  *2. Verificar el transistor.* El BC547 admite $I_(C "máx") = 100$ mA y
  $V_"CEO" = 45$ V. Con 30 mA y 12 V trabaja al 30 % de su corriente máxima y a un cuarto
  de su tensión: *elección correcta*, con margen.

  *3. Corriente de base con saturación forzada*, con la @ec-beta-forzado:
  $ I_B = I_C/beta_"forzado" = (30 "mA")/10 = 3 "mA" $

  *4. Resistencia de base*, con la @ec-rb:
  $ R_B = (V_"in" - V_"BE")/I_B = (5 "V" - 0,7 "V")/(3 "mA") = (4,3)/(3 dot 10^(-3)) = 1433 Omega $

  *5. Valor comercial*: se adopta *1,5 k$Omega$* (E24). Reverificando:
  $ I_B = (5 - 0,7)/1500 = 2,87 "mA" quad arrow.r.double quad
    beta_"forzado" = (30 "mA")/(2,87 "mA") = 10,5 $
  Sigue en el criterio de diseño.

  *6. Verificar que realmente satura.* El $h_"FE"$ *mínimo* del BC547 a esta corriente es
  110. Con $I_B = 2,87$ mA, la corriente que el transistor *podría* conducir en zona activa
  sería:
  $ I_(C "posible") = 110 dot 2,87 "mA" = 316 "mA" $
  Como la carga solo deja pasar 30 mA, el transistor no puede llegar a esos 316 mA:
  *queda saturado*, que es exactamente lo buscado. Y esto vale incluso para el peor
  ejemplar de la bolsa.

  *7. Potencia disipada en el transistor*:
  $ P = V_(upright("CE")(upright("sat"))) dot I_C = 0,2 "V" dot 30 "mA" = 6 "mW" $
  Contra 500 mW admisibles: el transistor ni se entibia. Ese es el premio de trabajar en
  conmutación y no en zona activa.

  *8. Protección*: un *1N4007 en antiparalelo con la bobina*, cátodo al +12 V.

  *Resumen del diseño*: BC547, $R_B = 1,5$ k$Omega$, diodo 1N4007 sobre la bobina.
]

#ejercicio("Cuando el transistor chico no alcanza")[
  Ahora hay que comandar una lámpara de 12 V que consume *500 mA*, desde la misma salida
  lógica de 5 V. ¿Sirve el BC547?

  *1. No sirve, y hay que decir por qué*: $I_C = 500$ mA supera los 100 mA máximos del
  BC547. Se destruye apenas se enciende.

  *2. Transistor de potencia.* Un *TIP31C* admite $I_C = 3$ A y $V_"CEO" = 100$ V. Sirve,
  pero su $h_"FE"$ mínimo es apenas *25* a corrientes altas — los transistores de potencia
  tienen mucha menos ganancia que los de señal.

  *3. Corriente de base necesaria*, con $beta_"forzado" = 10$:
  $ I_B = (500 "mA")/10 = 50 "mA" $

  *4. Acá aparece el problema real*: una salida lógica típica entrega como máximo 20 mA.
  *No puede dar 50 mA.* El cálculo de $R_B$ daría
  $R_B = (5 - 0,7)\/50 "mA" = 86 Omega$, pero esa corriente no existe.

  *5. Dos soluciones válidas*:
  - *Etapa en cascada*: un BC547 excita al TIP31. La salida lógica maneja los pocos
    miliampere del BC547, y este entrega los 50 mA de base del TIP31.
  - *Transistor Darlington* (TIP120): son dos transistores integrados en el mismo
    encapsulado, con $beta$ total del orden de 1000. Con $beta_"forzado" = 10$ bastarían
    $I_B = 0,5$ mA, perfectamente al alcance de la salida lógica. El precio es una caída
    $V_"CE(sat)"$ mayor, de aproximadamente 1 V en vez de 0,2 V, y por lo tanto más calor:
    $P = 1 "V" dot 0,5 "A" = 0,5$ W, que ya exige *disipador*.

  *Conclusión*: el diseño de la etapa de base no se decide solo con las fórmulas. Hay que
  verificar que *quien comanda* pueda entregar la corriente que el cálculo pide. Es la
  misma lógica del efecto de carga del Módulo 1: el instrumento — o la salida lógica —
  también tiene sus límites.
]

== Leer el datasheet

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    table.header([*Parámetro*], [*BC547 / TIP31C*], [*Qué decide*]),
    [$I_(C "máx")$ — corriente de colector máxima], [100 mA / 3 A],
    [Si el transistor sirve para la carga. Es el *primer* filtro de la elección.],
    [$V_"CEO"$ — tensión colector-emisor máxima], [45 V / 100 V],
    [Debe superar $V_"cc"$, y con margen si hay cargas inductivas.],
    [$h_"FE"$ — ganancia de corriente], [110–800 / 25 mín],
    [La corriente de base necesaria. *Se usa siempre el valor mínimo*, nunca el típico.],
    [$V_"CE(sat)"$ — tensión de saturación], [0,2 V / 1,2 V],
    [La potencia disipada al conducir, y por lo tanto si hace falta disipador.],
    [$V_"BE(on)"$ — tensión base-emisor], [≈ 0,7 V],
    [Entra directo en el cálculo de $R_B$.],
    [$P_"tot"$ — potencia total disipable], [500 mW / 40 W],
    [El límite térmico. Los 40 W del TIP31 son *con disipador*; sin él, mucho menos.],
    [Encapsulado], [TO-92 / TO-220],
    [Cómo se monta y si admite disipador. En TO-92 el orden de patas *varía según el
     fabricante*: verificarlo siempre en la hoja de datos, no de memoria.],
  ),
  caption: [Parámetros de datasheet que se usan al diseñar una etapa de conmutación],
)

#clave[
  La regla que atraviesa todo el módulo: *para diseñar se usa siempre el peor caso, no el
  típico*. $h_"FE"$ mínimo, tensión de alimentación mínima, corriente de carga máxima,
  temperatura máxima. Un circuito diseñado con valores típicos funciona en el banco con
  el transistor que uno tiene puesto, y falla en la mitad de los equipos fabricados. Es la
  misma idea que en el Módulo 1 con las tolerancias: no interesa el valor nominal,
  interesa el intervalo.
]

#tp("Sin TP en las guías — pero sí en la evaluación")[
  Ninguna de las dos guías tiene un trabajo práctico de transistores, y el apunte de la
  cátedra tiene el capítulo sin desarrollar. Aun así, el diseño de un control ON/OFF con
  relé es contenido del programa. Práctica sugerida para el banco: armar el Ejercicio 6.1
  completo, medir $V_"BE"$ y $V_"CE"$ con el transistor conducido y cortado, y comprobar
  con el osciloscopio el pico de tensión inductiva al cortar *quitando el diodo volante*
  — con la fuente en baja tensión y por un instante. Ver ese pico en la pantalla es lo que
  convence de que el diodo no es opcional.
]
