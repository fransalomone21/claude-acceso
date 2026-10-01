// =====================================================================
//  Modelo de parcial 4 -- conceptual, al estilo de los parcialitos
//  Armado con los criterios ANI-30 a ANI-40 del repo catedras (inferidos
//  de los tres parcialitos de 2026): cadenas de preguntas cortas, dibujo
//  cualitativo, opcion multiple con distractores de concepto, "discuta la
//  relacion" y una prediccion sin datos al final. Casi sin cuentas; las
//  pocas que hay tienen su control en validar.py.
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp
#import "../apunte/biblioteca/estilo.typ" as dib
#import "../apunte/biblioteca/figuras.typ" as figs

#show: documento.with(
  titulo: [Modelo de parcial 4 — conceptual],
  subtitulo: [La astronauta, el cohete más pesado que su empuje, la ingravidez, la elipse, Kepler y la rueda],
  encabezado: [Modelo de parcial 4 — conceptual],
)

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Tiempo sugerido: *2 horas*. Casi no hay cuentas: las pocas que hay salen con
  una sola operación. Se corrige el *razonamiento*: toda respuesta se justifica,
  y donde se pide un dibujo, *el dibujo es la respuesta* (dirección, sentido y
  rótulos, no la escala). Use lápiz y goma. En las preguntas de opción múltiple,
  la letra sola no suma. Datos: $R_T = 6378$ km, $G = 6,674 times 10^(-11)$
  N·m²/kg², 1 UA $= 1,496 times 10^11$ m. *Notación:* $bold(L)$ es el momento
  angular (la guía lo llama *impulso angular*), $bold(tau)$ el torque, $bold(P)$
  la cantidad de movimiento.
]

#caja([Por qué este modelo es distinto de los modelos 1 a 3], c-azul)[
  Los tres parcialitos de 2026 no traen un solo número para operar: piden
  escribir una ley en forma vectorial, dibujar vectores cualitativos, elegir
  entre opciones que son errores de concepto conocidos, «discutir la relación»
  de una magnitud con otra y cerrar con una predicción sin datos. Este modelo
  pregunta así. Es una lectura de *cómo pregunta* la cátedra (criterios
  inferidos, no dichos): si un parcial real la contradice, manda el parcial.
]

#mapa(
  ([1], [cantidad de movimiento de un sistema, centro de masa, energía interna], [Ej. 1 de cantidad de movimiento (la astronauta) y Adicional 1]),
  ([2], [cohete: ecuación de propulsión, más peso que empuje, Tsiolkovsky, etapas], [Ej. 6 (Beer 14.94) y Adicional 3 de cantidad de movimiento]),
  ([3], [gravitación vectorial, $g$ con la altura, pseudo-ingravidez], [Problemas 0 y 3 de gravitación; parcialito 2]),
  ([4], [la órbita dibujada: $bold(v)$, $bold(a)$, componentes, energía y momento angular], [Ej. 4 de impulso angular y Problema 4 de gravitación (S&Z 13.67); parcialito 1]),
  ([5], [de Newton a Kepler, la masa del Sol, escalas, geoestacionaria], [Problemas 0 y 3 de gravitación; parcialito 2]),
  ([6], [giróscopo: $Delta bold(L) = bold(tau) Delta t$, precesión, analogía con la órbita], [Problemas 4 y 7 de impulso angular (S&Z 10.51 y 10.53); parcialito 3]),
)

#ejercicio(1, [la astronauta y la llave], [1,5])
#origen[Cantidad de movimiento de un sistema, centro de masa, energía. Se apoya en el Ej. 1 de cantidad de movimiento y en el Adicional 1.]

Una astronauta flota quieta respecto de la estación espacial, lejos de
cualquier agarre, con una llave en la mano. Arroja la llave hacia adelante.

+ ¿Qué magnitud se conserva durante el lanzamiento, y por qué? Diga con
  precisión cuál es el sistema.
+ El centro de masa del sistema astronauta + llave:
  (a) se mueve junto con la llave;
  (b) se queda donde estaba;
  (c) se mueve junto con la astronauta;
  (d) avanza hasta que la llave se aleja y después se detiene.
+ La astronauta tiene veinte veces la masa de la llave. Establezca una relación
  entre las velocidades de las dos después del lanzamiento, y entre sus
  energías cinéticas. ¿Quién se lleva la mayor parte de la energía?
+ Antes del lanzamiento $bold(P) = 0$ y $K = 0$; después $bold(P) = 0$ y
  $K != 0$. ¿De dónde salió la energía? ¿Se violó alguna ley de conservación?
+ Suponga ahora que la llave estaba atada a la astronauta con una soga, que
  se tensa sin rebotar. ¿Qué pasa con las dos después del tirón? ¿Adónde fue
  la energía cinética?

#ejercicio(2, [el cohete que arranca más pesado que su empuje], [2])
#origen[Ecuación del cohete, fuerza de la plataforma, Tsiolkovsky, etapas. Se apoya en el Ej. 6 de cantidad de movimiento (Beer 14.94) y en el Adicional 3.]

Un cohete apoyado en la plataforma enciende el motor: quema propelente a
ritmo constante $mu$ y los gases salen hacia abajo a $v_r$ *respecto del
cohete*. En el instante del encendido, el empuje vale el $80$ % del peso.

#fp.fig-cohete-p()

+ Escriba la ecuación de movimiento del cohete en vuelo vertical y explique
  qué representa cada término. ¿Por qué se usa la velocidad de los gases
  respecto del cohete y no respecto del suelo?
+ Al encender, el cohete:
  (a) no despega nunca, porque el empuje no alcanza;
  (b) despega enseguida, pero despacio;
  (c) se queda apoyado un tiempo y después despega;
  (d) aprieta la plataforma cada vez más.
  ¿Qué fuerza falta en la ecuación del inciso 1 mientras está apoyado?
+ Exprese el instante $t^*$ del despegue en función de $M_0$, $mu$, $v_r$ y
  $g$. ¿Qué fracción de la masa inicial quemó hasta entonces?
+ Dibuje de manera cualitativa $a(t)$ y $v(t)$ desde el encendido hasta que
  se apaga el motor. ¿Por qué la aceleración crece, si el empuje es constante?
+ El cohete apaga con $M_0 \/ M_f = 4$. Para aumentar la velocidad final ideal,
  ¿qué conviene más: duplicar la velocidad de los gases o duplicar la relación
  de masas? Discútalo con la ecuación de Tsiolkovsky.
+ ¿Por qué los cohetes reales se construyen en etapas? Responda en palabras.

#ejercicio(3, [¿por qué flota la astronauta?], [1,5])
#origen[Ley de gravitación vectorial, $g$ con la altura, caída libre, pseudo-ingravidez. Se apoya en los Problemas 0 y 3 de gravitación y sigue la cadena del parcialito 2.]

La estación orbita a $400$ km de altura. Adentro, la astronauta del
ejercicio 1 flota.

+ Escriba en forma vectorial la fuerza que la Tierra hace sobre la astronauta,
  y dibújela junto con la que la astronauta hace sobre la Tierra.
+ ¿Qué fracción de su peso en la superficie tiene la astronauta a esa altura?
+ La astronauta flota porque:
  (a) en órbita no hay gravedad;
  (b) a $400$ km la gravedad es despreciable;
  (c) ella y la estación caen juntas, con la misma aceleración;
  (d) la fuerza centrífuga equilibra a la gravedad.
  Diga además cuál de las incorrectas es la más tentadora, y por qué no es la
  causa.
+ Si se para sobre una balanza dentro de la estación, ¿qué marca? ¿Y en un
  ascensor en caída libre en la Tierra? ¿Qué tienen en común las dos
  situaciones?
+ Establezca una relación entre la aceleración de la astronauta y la de la
  estación. ¿Por qué no depende de la masa de cada una?

#ejercicio(4, [la elipse, dibujada], [2])
#origen[Aceleración en una órbita, componentes tangencial y normal, trabajo, energía y momento angular. Se apoya en el Ej. 4 de impulso angular y en el Problema 4 de gravitación (S&Z 13.67), y sigue al parcialito 1.]

Un satélite describe la elipse de la figura alrededor de la Tierra, que está
en el foco $F$, en el sentido indicado. $P$ y $A$ son el perigeo y el apogeo;
$Q_1$ y $Q_2$ son simétricos respecto del eje mayor.

#fp.fig-elipse-aceleracion()

+ Dibuje de manera cualitativa la velocidad y la aceleración en $P$, $A$,
  $Q_1$ y $Q_2$.
+ En $Q_1$ y en $Q_2$, dibuje las componentes tangencial y normal de la
  aceleración. Use la simetría: ¿qué tienen igual y qué cambia? Interprete
  físicamente el sentido de la aceleración tangencial respecto de la velocidad.
+ ¿En qué tramo de la órbita la gravedad hace trabajo positivo? ¿Dónde es
  máxima la rapidez? Relaciónelo con la conservación de la energía.
+ Usando la conservación del momento angular, establezca una relación entre
  $v_P \/ v_A$ y las distancias al centro de la Tierra. ¿Cuánto vale para la
  órbita de la guía, con el perigeo a $400$ km y el apogeo a $4000$ km de altura?
+ ¿Por qué el inciso anterior sale tan directo con el momento angular, y no
  con la energía?
+ En $P$ se enciende el motor un instante, en la dirección de la velocidad.
  Entonces:
  (a) sube el perigeo;
  (b) sube el apogeo;
  (c) suben los dos por igual;
  (d) no cambia nada, la órbita está fijada por la Tierra.

#ejercicio(5, [de Newton a Kepler], [1,5])
#origen[Órbita circular, tercera ley de Kepler, masa del Sol, escalas, órbita geoestacionaria. Se apoya en los Problemas 0 y 3 de gravitación (Beer 12.80) y sigue la cadena del parcialito 2.]

+ Partiendo de la ley de gravitación, escriba la rapidez de un satélite en
  órbita circular de radio $r$. Discuta su relación con la masa del satélite
  y con el radio.
+ Deduzca una relación entre el período, el radio y los demás parámetros.
  ¿De qué ley muy conocida es un caso particular? ¿Quién la encontró, y cómo,
  si Newton todavía no había escrito la gravitación?
+ Estime la masa del Sol con datos que todos conocemos.
+ Si el Sol tuviera el doble de masa y la Tierra siguiera en la misma órbita,
  ¿cuánto duraría el año?
+ Una estación orbita a cuatro veces el radio de otra. ¿Cuántas veces más
  tarda en dar una vuelta? ¿Y cuántas veces más rápido va?
+ ¿Por qué todos los satélites geoestacionarios están a la misma altura, y
  todos sobre el ecuador?

#ejercicio(6, [la rueda que no se cae], [1,5])
#origen[Torque, $Delta bold(L) = bold(tau) Delta t$, precesión y la analogía con la órbita circular. Se apoya en los Problemas 4 y 7 de impulso angular (S&Z 10.51 y 10.53) y en la demostración de la rueda del parcialito 3.]

Una rueda de bicicleta gira rápido alrededor de su eje, que está horizontal y
apoyado en un pivote por un extremo, como en la figura. Nadie la sostiene.

#fp.fig-giroscopo-p(rot-d: [$d$])

+ Dibuje, en la vista de costado, el momento angular de la rueda, el peso, el
  torque del peso respecto del pivote y el cambio de $bold(L)$ en un intervalo
  corto.
+ La rueda:
  (a) se cae;
  (b) su eje gira alrededor del pivote en un plano horizontal;
  (c) su extremo libre sube;
  (d) se queda quieta.
  Justifique, y diga hacia dónde gira visto desde arriba.
+ Complete la analogía con un satélite en órbita circular: ¿qué juega el papel
  de la velocidad, y qué el de la fuerza? ¿Por qué ninguno de los dos «se
  cae»?
+ Discuta qué pasa con la precesión si la rueda gira el doble de rápido. ¿Y
  si no gira?
+ La estudiante de la demostración de clase sostiene ahora la rueda con las
  manos, el eje horizontal y $bold(L)$ apuntando desde ella hacia el extremo
  libre, y gira el eje hacia su izquierda sin inclinarlo, como quien dobla con
  un volante. ¿Qué tendencia registra en las manos?

#pagebreak()

= Resolución

== Ejercicio 1 — la astronauta y la llave

#notacion[
  $bold(P) = sum m_i bold(v)_i$ es la cantidad de movimiento del sistema (el
  Beer la llama $bold(L)$). $bold(v)_"CM" = bold(P) \/ M$ (Sears §8.5). Todo se
  mide desde la estación, que cae libremente igual que la astronauta: en ese
  marco no hay fuerza externa que importe.
]

#idea[
  Arrojar es una fuerza *interna*: la mano empuja la llave y la llave empuja
  la mano, con fuerzas iguales y opuestas. Lo interno no mueve al centro de
  masa ni cambia $bold(P)$; sí puede crear energía cinética, porque esa sale
  de los músculos.
]

+ Se conserva $bold(P)$ del sistema *astronauta + llave*, porque sobre él no
  actúa ninguna fuerza externa neta (la gravedad acelera igual a la estación,
  a la astronauta y a la llave). Sobre la llave sola *no* se conserva: la mano
  la empuja.
+ *(b)*. $bold(P) = 0$ antes, así que $bold(v)_"CM" = 0$ siempre: el centro de
  masa queda donde estaba. Ojo con la lectura absoluta: no está «fijo de
  manera absoluta» (el distractor del parcialito 2); lo general es que se
  mueva con velocidad constante, y acá esa constante es cero porque arrancó
  quieto. La (d) es la trampa: el CM no «sigue» a nadie.
+ $m_a bold(v)_a + m_l bold(v)_l = 0$, con $m_a = 20 m_l$: la astronauta sale
  para atrás a un veinteavo de la velocidad de la llave. Las cantidades de
  movimiento tienen el mismo módulo $p$, y $K = p^2 \/ 2m$: la llave tiene
  veinte veces la energía cinética de la astronauta. Del total, la llave se
  lleva $20\/21$, el $95$ %.
+ Salió de la energía química de los músculos: el brazo hace trabajo interno.
  No se viola nada: $bold(P)$ se conserva porque las fuerzas internas son de a
  pares; la energía *mecánica* no tiene por qué conservarse cuando hay
  trabajo interno, y la energía total sí se conserva (química → cinética).
+ Es un choque plástico visto desde el centro de masa. Como $bold(P) = 0$ y
  después del tirón se mueven juntas, $bold(v)_"final" = bold(P) \/ M = 0$:
  quedan las dos quietas. Toda la energía cinética se disipó en la soga, en
  el cuerpo y en calor. Es el único choque que puede perder *toda* la energía
  cinética: el que tiene $bold(P) = 0$.

#trampa[
  «Se conserva la cantidad de movimiento de la llave» o «el centro de masa se
  va con la llave». Lo que se conserva es la del *sistema*, y por eso hay que
  decir cuál es.
]

#final[$bold(P) = 0$ y el CM quieto; $v_a = v_l \/ 20$ hacia atrás; la llave se lleva el $95$ % de la energía, que viene de los músculos; con la soga, las dos quedan quietas.]

== Ejercicio 2 — el cohete que arranca más pesado que su empuje

#notacion[
  $mu = -dif M \/ dif t > 0$ es el caudal (Beer: $q$); $v_r$ es el módulo de la
  velocidad de los gases *respecto del cohete*; el empuje es $mu v_r$. $y$
  hacia arriba.
]

#idea[
  El empuje es constante, pero la masa que tiene que levantar baja todo el
  tiempo. Al principio no alcanza y la plataforma pone lo que falta; cuando el
  peso baja hasta igualar el empuje, el cohete despega. Es la frase de la
  cátedra: «el cohete puede comenzar con más peso que empuje».
]

+ En vuelo: $M(t) dif V\/dif t = mu v_r - M(t) g$, con $M(t) = M_0 - mu t$.
  El primer término es el empuje: la reacción de los gases que el motor
  expulsa, por unidad de tiempo $mu$, cada uno con cantidad de movimiento $v_r$
  respecto del cohete. El segundo, el peso del cohete *en ese instante*. Se
  usa $v_r$ respecto del cohete porque es lo que fija el motor: en $dif t$, la
  masa $mu dif t$ sale a $v_r$ de la tobera, y el balance de cantidad de
  movimiento del cohete más esa masa da el empuje $mu v_r$ sin importar a qué
  velocidad va el cohete respecto del suelo.
+ *(c)*. Mientras está apoyado, la ecuación lleva además la normal $N$ de la
  plataforma: $0 = mu v_r + N - M g$, o sea $N = M(t) g - mu v_r$, que *baja*
  con el tiempo (la (d) está al revés). Cuando $N$ llega a cero, despega.
+ $mu v_r = M(t^*) g$ da $M(t^*) = mu v_r \/ g$ y
  $ t^* = (M_0 - mu v_r \/ g) / mu. $
  Como el empuje es el $80$ % del peso inicial, $M(t^*) = 0,8 M_0$: quemó el
  $20$ % de la masa antes de moverse un milímetro.
+ Hasta $t^*$, $a = 0$ y $v = 0$. Después
  $a = mu v_r \/ M(t) - g$ arranca en cero y crece cada vez más rápido, porque
  el mismo empuje empuja una masa cada vez menor (y el peso también baja). La
  velocidad arranca con pendiente cero y es cóncava hacia arriba:

  #fp.fig-cohete-a-v
  #dib.pie-figura[Forma cualitativa, calculada con $M_0 \/ M_f = 4$ y empuje inicial igual al $80$ % del peso. $t_b$: se apaga el motor.]
+ $Delta V_"ideal" = v_r ln (M_0 \/ M_f)$. Con $M_0 \/ M_f = 4$:
  $ln 4 = 1,386$, o sea $1,386 v_r$. Duplicar $v_r$ duplica todo:
  $2,772 v_r$. Duplicar la relación de masas suma sólo un logaritmo de $2$:
  $ln 8 = 2,079$, $1,50$ veces lo de antes. *Conviene la velocidad de los
  gases*: la relación de masas entra adentro de un logaritmo, que crece cada
  vez más despacio.
+ Porque la masa muerta (tanques vacíos, motores de la primera parte) no se
  sigue acelerando: se la suelta y la etapa siguiente arranca con una $M_0$
  mucho menor, o sea con una relación de masas nueva. Los $Delta V$ de las
  etapas se suman, y cada uno sale de un logaritmo que no está castigado por
  arrastrar lo que ya no sirve.

#trampa[
  Decir que el cohete «no despega porque el empuje es menor que el peso».
  Eso vale en el encendido y nada más: el peso no es constante.
]

#final[Se queda apoyado hasta $t^* = (M_0 - mu v_r\/g)\/mu$, después de quemar el $20$ % de la masa; la aceleración arranca en cero y crece; duplicar $v_r$ (×2) gana a duplicar $M_0\/M_f$ (×1,50).]

== Ejercicio 3 — ¿por qué flota la astronauta?

#notacion[
  $hat(r)$ es el versor que va del centro de la Tierra a la astronauta;
  $mu_T = G M_T$. «Pseudo-ingravidez»: no es que no haya gravedad, es que no
  se la siente porque todo cae junto.
]

#idea[
  Lo que una persona siente como «peso» no es la gravedad: es la fuerza del
  piso que la frena. En órbita el piso cae con ella, no la frena, y la
  sensación desaparece aunque la gravedad sea casi la misma que en tierra.
]

+ $bold(F)_(T arrow.r a) = -(G M_T m)\/r^2 hat(r)$, apuntando al centro de la
  Tierra. La que la astronauta hace sobre la Tierra es
  $bold(F)_(a arrow.r T) = +(G M_T m)\/r^2 hat(r)$: mismo módulo, sentido
  opuesto, aplicada en la Tierra (tercera ley).
+ $g(r) \/ g_0 = (R_T \/ (R_T + h))^2 = (6378\/6778)^2 = 0,885$: tiene el $89$ %
  de su peso. A $400$ km la gravedad es casi la de la superficie.
+ *(c)*. La (a) y la (b) las desmiente el inciso 2. La más tentadora es la
  *(d)*: en el marco que gira con la estación sí aparece una fuerza centrífuga
  que «equilibra», pero es una fuerza ficticia de ese marco. Desde un marco
  inercial hay una sola fuerza, la gravedad, y no está equilibrada: es la que
  curva la trayectoria. La astronauta *cae* todo el tiempo, igual que la
  estación; las dos caen «de costado» lo suficiente como para no tocar nunca
  la Tierra.
+ Cero en los dos casos. La balanza mide la fuerza que hace para sostener a la
  persona, y si la balanza cae con la misma aceleración que la persona no
  tiene que sostener nada. Lo común: los dos están en *caída libre*.
+ $a = G M_T \/ r^2$ para las dos: en $m a = G M_T m \/ r^2$ la masa de cada
  una se simplifica. Por eso no se separan: caen con la misma aceleración, y
  la astronauta queda quieta respecto de la estación.

#trampa[
  «En el espacio no hay gravedad». Con el $89$ % del peso, la gravedad es lo
  que mantiene a la estación en órbita: sin ella seguiría en línea recta.
]

#final[$bold(F) = -G M_T m \/ r^2 hat(r)$; a $400$ km queda el $89$ % de $g$; flota porque cae junto con la estación (c), y la balanza marca cero.]

== Ejercicio 4 — la elipse, dibujada

#notacion[
  $bold(a) = bold(a)_t + bold(a)_n$: la tangencial va a lo largo de
  $bold(v)$ y cambia la rapidez; la normal es perpendicular a $bold(v)$ y
  cambia la dirección. $h = r v cos gamma$ es el momento angular por unidad de
  masa; en los ápsides, $gamma = 0$.
]

#idea[
  La aceleración apunta *siempre* a $F$, porque la única fuerza es la gravedad
  de la Tierra. Lo que cambia de un punto a otro es el ángulo entre esa
  aceleración y la velocidad, y ese ángulo dice si el satélite acelera o
  frena.
]

#fp.fig-elipse-aceleracion(respuesta: true)
#dib.pie-figura[La velocidad (azul) es tangente a la órbita; la aceleración (rojo) apunta a $F$, más larga cuanto más cerca. Largos cualitativos.]

+ En $P$ y en $A$ la velocidad es perpendicular al radio y la aceleración no
  tiene componente tangencial: toda es normal. En $P$ la velocidad es la
  mayor y la aceleración la mayor; en $A$, las dos son las menores.
+ En los dos puntos $abs(bold(a)_t)$ y $abs(bold(a)_n)$ son iguales: la
  simetría respecto del eje mayor lleva un punto en el otro, con la misma
  distancia a $F$. Lo que cambia es el sentido de $bold(a)_t$ *respecto de
  $bold(v)$*. En $Q_1$, que va de $P$ hacia $A$ alejándose de $F$,
  $bold(a)_t$ es *opuesta* a $bold(v)$: el satélite *frena*. En $Q_2$, que
  vuelve hacia $P$, $bold(a)_t$ va *a favor* de $bold(v)$: *acelera*.
+ Trabajo positivo de $A$ a $P$ (se acerca a $F$: la fuerza tiene componente
  a favor del movimiento); negativo de $P$ a $A$. Con $K + U$ constante y
  $U = -mu m \/ r$ mínima en $P$, la rapidez es máxima en $P$ y mínima en $A$.
+ En los ápsides $bold(r) perp bold(v)$, así que $h = r_P v_P = r_A v_A$ y
  $ v_P / v_A = r_A / r_P. $
  Con $r_P = 6378 + 400 = 6778$ km y $r_A = 6378 + 4000 = 10 thin 378$ km:
  $v_P \/ v_A = 1,531$. Es lo que dan las velocidades de la figura de la guía,
  $8,435$ y $5,509$ km/s.
+ El momento angular da una relación *lineal* entre $r$ y $v$ en los ápsides,
  sin ningún dato de la Tierra. La energía,
  $v_P^2 - v_A^2 = 2 mu (1\/r_P - 1\/r_A)$, necesita $mu$ y mezcla los
  cuadrados: sirve para los valores, no para la razón.
+ *(b)*. Después del encendido el satélite sigue en $P$ con la velocidad
  perpendicular al radio, así que $P$ sigue siendo el perigeo, a la misma
  distancia. Pero la energía aumentó, así que creció el semieje mayor
  $a$: el que sube es el punto opuesto, el apogeo.

#trampa[
  Dibujar la aceleración tangente a la órbita, como si fuera la velocidad. La
  aceleración apunta al foco ocupado, no al centro de la elipse ni a lo largo
  de la trayectoria.
]

#final[$bold(a)$ siempre hacia $F$; en $Q_1$ frena, en $Q_2$ acelera, con la misma $abs(bold(a)_t)$; $v_P\/v_A = r_A\/r_P = 1,531$; el encendido en $P$ sube el apogeo.]

== Ejercicio 5 — de Newton a Kepler

#notacion[
  $mu = G M$ del cuerpo central; $T$ el período. La tercera ley de Kepler es
  la de 1619 (*Harmonices Mundi*); los *Principia* de Newton son de 1687.
]

#idea[
  Para una órbita circular, la gravedad *es* la fuerza centrípeta. De esa sola
  igualdad sale todo el ejercicio: la rapidez, el período y por qué la masa
  del satélite no aparece nunca.
]

+ $G M m \/ r^2 = m v^2 \/ r$ da $v = sqrt(G M \/ r)$. No depende de la masa
  del satélite (se simplifica: la misma $m$ es la que la gravedad atrae y la
  que se resiste a acelerar). Con el radio, va como $1\/sqrt(r)$: más lejos,
  más lento.
+ $T = 2 pi r \/ v$, y reemplazando,
  $ T^2 = (4 pi^2)/(G M) r^3. $
  Es la *tercera ley de Kepler* para el caso circular. Kepler la encontró en
  1619 *a partir de las observaciones de Tycho Brahe*, buscando una regla
  entre los períodos y los tamaños de las órbitas de los planetas, sin saber
  por qué valía. Newton la *dedujo* casi setenta años después, y su deducción
  agrega lo que Kepler no tenía: que la constante es $4 pi^2 \/ G M$, y que
  depende sólo de la masa del Sol.
+ $M_"Sol" = 4 pi^2 r^3 \/ (G T^2)$, con $r = 1$ UA y $T = 1$ año
  $= 3,156 times 10^7$ s: $M_"Sol" = 1,99 times 10^30$ kg.
+ $T prop 1\/sqrt(M)$: el año duraría $1\/sqrt(2) = 0,707$ años, unos $258$
  días.
+ $T prop r^(3\/2)$: $4^(3\/2) = 8$ veces más. Y $v prop 1\/sqrt(r)$: va a la
  *mitad* de rapidez. Recorre una órbita cuatro veces más larga a la mitad de
  velocidad: tarda ocho veces más.
+ Tienen que dar una vuelta en un día sideral, y la tercera ley fija *un solo*
  radio para ese período ($42 thin 164$ km desde el centro). Y tienen que
  estar sobre el ecuador porque el plano de toda órbita pasa por el centro de
  la Tierra: uno inclinado, visto desde el suelo, oscilaría hacia el norte y
  hacia el sur una vez por día.

#trampa[
  Creer que un satélite más pesado tiene que ir más rápido para no caer. La
  masa del satélite no aparece en ninguna de estas relaciones: por eso la
  pregunta final del parcialito 2 se contesta sin datos (con la Tierra en la
  órbita de Júpiter, el año terrestre pasa a durar un año joviano).
]

#final[$v = sqrt(G M\/r)$ sin la masa del satélite; $T^2 = 4 pi^2 r^3 \/ G M$ (Kepler, 1619); $M_"Sol" = 1,99 times 10^30$ kg; con el doble de Sol, $258$ días; a cuatro veces el radio, ocho veces el período.]

== Ejercicio 6 — la rueda que no se cae

#notacion[
  $bold(L) = I bold(omega)$ a lo largo del eje (aproximación giroscópica: el
  giro propio domina). $bold(tau) = bold(r) times m bold(g)$ respecto del
  pivote. La precesión es $Omega = tau \/ L$. Regla de la mano derecha para
  todo (ANI-26).
]

#idea[
  El torque no tumba a la rueda: le agrega a $bold(L)$ un pedacito
  $Delta bold(L) = bold(tau) Delta t$, y ese pedacito es *perpendicular* a
  $bold(L)$. Un vector al que le sumás siempre algo perpendicular gira y no
  crece: el eje da vueltas en lugar de caerse.
]

#fp.fig-giroscopo-p(respuesta: true, rot-d: [$d$])
#dib.pie-figura[Con el giro del enunciado, $bold(L)$ apunta hacia afuera del pivote; el torque del peso entra en la hoja, y hacia allá se va la punta de $bold(L)$.]

+ $bold(L)$ a lo largo del eje, hacia afuera del pivote (giro antihorario
  visto desde la derecha). El peso, vertical hacia abajo en el centro de masa.
  $bold(tau) = bold(r) times m bold(g)$, horizontal y perpendicular al eje:
  con $bold(r)$ hacia la derecha y $m bold(g)$ hacia abajo, entra en la hoja.
  $Delta bold(L) = bold(tau) Delta t$, también hacia adentro de la hoja.
+ *(b)*. $bold(L) + Delta bold(L)$ tiene el mismo módulo y apunta un poco
  hacia adentro de la hoja: el eje gira en un plano horizontal. Visto desde
  arriba, en sentido antihorario. La (a) es la intuición, y es lo que pasa si
  la rueda no gira.
+ La velocidad del satélite ↔ $bold(L)$; la fuerza gravitatoria ↔ el torque.
  En el satélite la fuerza es perpendicular a $bold(v)$: le cambia la
  dirección y no el módulo, y por eso describe un círculo sin acercarse. En la
  rueda el torque es perpendicular a $bold(L)$: le cambia la dirección y no el
  módulo, y por eso el eje da vueltas sin bajar. Los dos «se caen» todo el
  tiempo hacia donde los empuja la fuerza o el torque, pero de costado.
+ $Omega = tau \/ L$ y el torque es el mismo: con el doble de giro, la
  precesión es la *mitad* de rápida. Si no gira, $bold(L)$ arranca en cero, y
  el $Delta bold(L)$ que agrega el torque ya no es perpendicular a nada: la
  rueda empieza a girar alrededor del eje del torque, o sea, *se cae*. La
  aproximación $Omega << omega$ deja de valer.
+ Para que $bold(L)$, que apunta hacia adelante, gire hacia su izquierda, el
  $Delta bold(L)$ tiene que apuntar a su izquierda, y entonces el torque que
  ella aplica apunta a su izquierda (horizontal). Ese torque, en una rueda que
  no girara, bajaría el extremo libre. Es decir: para doblar a la izquierda
  ella tiene que *empujar el extremo libre hacia abajo*, y lo que siente es la
  reacción: *la rueda tira el extremo libre hacia arriba*. Es la misma regla
  que en el parcialito 3, al revés: el eje responde a $90°$ de lo que uno
  intenta.

#trampa[
  Dibujar el torque vertical, «porque el peso es vertical». El torque es
  $bold(r) times bold(F)$: perpendicular a los dos, y acá queda horizontal.
]

#final[$Delta bold(L) = bold(tau) Delta t perp bold(L)$: el eje precesa en un plano horizontal, antihorario visto desde arriba; con el doble de giro, la mitad de precesión; doblando a la izquierda, la rueda le levanta el extremo libre.]
