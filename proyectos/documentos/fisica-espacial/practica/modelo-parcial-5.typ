// =====================================================================
//  Modelo de parcial 5 -- conceptual, al estilo de los parcialitos
//  Segundo modelo armado con los criterios ANI-30 a ANI-40 del repo
//  catedras (inferidos de los tres parcialitos de 2026). Mismos temas que
//  el 4, con otras preguntas: impulso y choques, el cohete en el vacio,
//  lo que cuesta subir un satelite, la segunda ley de Kepler, el
//  encuentro orbital y el rigido que despliega antenas. Los pocos numeros
//  tienen su control en validar.py.
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp
#import "../apunte/biblioteca/estilo.typ" as dib
#import "../apunte/biblioteca/figuras.typ" as figs

#show: documento.with(
  titulo: [Modelo de parcial 5 — conceptual],
  subtitulo: [El satélite que sale de la bodega, el cohete en el vacío, subir o acelerar, áreas iguales, alcanzar al de adelante y las antenas],
  encabezado: [Modelo de parcial 5 — conceptual],
)

#grid(columns: (2fr, 1fr), gutter: 8pt,
  [Nombre y apellido: #box(width: 1fr, line(length: 100%, stroke: 0.4pt))],
  [Nota: #box(width: 1fr, line(length: 100%, stroke: 0.4pt)) / 10],
)

#caja([Condiciones], c-gris.darken(40%))[
  Tiempo sugerido: *2 horas*. Casi no hay cuentas: las pocas que hay salen con
  una sola operación. Se corrige el *razonamiento*: toda respuesta se justifica,
  y donde se pide un dibujo, *el dibujo es la respuesta*. Use lápiz y goma. En
  las preguntas de opción múltiple, la letra sola no suma. Datos:
  $mu_T = 398 thin 600$ km³/s², $R_T = 6378$ km, $g_0 = 9,81$ m/s².
  *Notación:* $bold(L)$ es el momento angular (la guía lo llama *impulso
  angular*), $bold(tau)$ el torque, $bold(P)$ la cantidad de movimiento,
  $bold(J) = integral bold(F) dif t$ el impulso.
]

#mapa(
  ([1], [impulso, tercera ley, centro de masa, choques y König], [Adicional 2 y Ej. 2 de cantidad de movimiento]),
  ([2], [cohete: por qué anda en el vacío, masa variable, $I_"sp"$, pérdidas por gravedad], [Ej. 3 (S&Z 8.19) y Adicional 3 de cantidad de movimiento]),
  ([3], [energía potencial gravitatoria, escape, lo que cuesta poner un satélite en órbita], [Problemas 1, 4 y 6 de gravitación (S&Z 7.76 y 13.67, Beer 13.85)]),
  ([4], [segunda ley de Kepler, fuerza central, momento angular de la partícula libre], [Ej. 5 y Problemas 2 y 3 de impulso angular]),
  ([5], [maniobras: Hohmann y el encuentro con una nave adelantada], [Problemas 5 (S&Z 13.79) y 10 de gravitación]),
  ([6], [rígido: conservación de $bold(L)$, momento de inercia, Steiner, analogías], [Problemas 4 y 7 de impulso angular y la lista de cuerpo rígido]),
)

#ejercicio(1, [el satélite que sale de la bodega], [1,5])
#origen[Impulso, tercera ley, centro de masa, choques. Se apoya en el Adicional 2 (el transbordador de $90$ Mg que expulsa un satélite de $800$ kg) y en el Ej. 2 de cantidad de movimiento.]

El transbordador ($90$ Mg) expulsa un satélite de $800$ kg desde la bodega: el
mecanismo lo empuja durante $4$ s, hasta que se aleja a $0,3$ m/s respecto del
transbordador.

+ Compare el impulso que recibe el satélite con el que recibe el
  transbordador: módulo y sentido. ¿Cuál de los dos cambia más su velocidad,
  y cuántas veces más?
+ Durante la expulsión, el centro de masa del conjunto:
  (a) acelera hacia donde sale el satélite;
  (b) acelera hacia el otro lado;
  (c) sigue con la velocidad que tenía;
  (d) se frena.
+ Si el mecanismo empujara durante $8$ s en vez de $4$, hasta la misma
  velocidad relativa, ¿qué cambia y qué no?
+ Dos asteroides chocan y quedan pegados. ¿Qué se conserva en el choque, y
  qué no? Escriba la energía cinética del sistema como la del centro de masa
  más la relativa a él, y diga cuál de las dos partes se puede perder.
+ ¿Puede un choque dejar a los dos cuerpos quietos? ¿Bajo qué condición?

#ejercicio(2, [el cohete en el vacío], [2])
#origen[Propulsión, masa variable, impulso específico, pérdidas por gravedad. Se apoya en el Ej. 3 de cantidad de movimiento (el calamar, S&Z 8.19) y en el Adicional 3.]

+ Un compañero dice: «en el vacío un cohete no puede acelerar, porque no tiene
  contra qué empujar». Discuta.
+ El calamar del Ej. 3 de la guía se impulsa expulsando agua. ¿Qué tiene en
  común con un cohete?
+ Otro compañero escribe, para el cohete,
  $bold(F)_"ext" = dif (M bold(v)) \/ dif t = M dif bold(v) \/ dif t + bold(v) dif M \/ dif t$.
  ¿Qué está mal? Escriba la ecuación correcta.
+ ¿Por qué el impulso específico se mide en segundos? Los motores principales
  del transbordador tienen $I_"sp" = 455$ s: ¿a qué velocidad salen sus gases?
+ Dos cohetes iguales, con la misma masa inicial y final, queman todo el
  propelente: uno en $10$ s y el otro en $100$ s. ¿Cuál termina más rápido si
  están en el espacio, lejos de todo? ¿Y si despegan verticalmente de la
  Tierra (suponga que los dos despegan enseguida, sin aire)? ¿Cuánta
  diferencia hay?

#ejercicio(3, [subir o acelerar], [2])
#origen[Energía potencial gravitatoria, diagrama de energía, escape. Se apoya en los Problemas 1, 4 y 6 de gravitación (S&Z 7.76, S&Z 13.67 y Beer 13.85).]

+ Escriba la energía potencial gravitatoria de un satélite de masa $m$ a
  distancia $r$ del centro de la Tierra, y dibújela de manera cualitativa
  para $r >= R_T$. Marque la energía total de un satélite en órbita, la de uno
  que escapa justo y la de uno que escapa con sobra.
+ ¿Por qué esa energía es negativa? ¿De quién es: del satélite, de la Tierra
  o de los dos?
+ Para poner $1$ kg en órbita circular a $300$ km de altura, desde la
  superficie: ¿cuánta energía hace falta para *subirlo*, y cuánta para darle
  la *rapidez* de la órbita? ¿Qué es lo caro de llegar a órbita? (Ignore la
  rotación de la Tierra.)
+ ¿La velocidad de escape depende de la dirección en que se dispara? ¿Y de la
  masa de lo que se dispara?
+ Un satélite en órbita circular baja lentamente por el roce con la
  atmósfera, pasando por órbitas casi circulares cada vez más chicas. Su
  rapidez:
  (a) baja, porque el roce lo frena;
  (b) sube;
  (c) no cambia.
  Justifique con la energía.

#ejercicio(4, [áreas iguales], [1,5])
#origen[Velocidad areolar, fuerza central, momento angular de una partícula. Es el Ej. 5 de la sección de impulso angular de la guía (la «pregunta fina»: ahí el momento angular se llama impulso angular), con los Problemas 2 y 3.]

+ Formule la segunda ley de Kepler en términos de la velocidad areolar, y
  relaciónela con el momento angular.
+ Para que se cumpla hace falta que la fuerza:
  (a) sea central y vaya como $1\/r^2$;
  (b) sea central, nada más;
  (c) vaya como $1\/r^2$, nada más;
  (d) sea conservativa.
+ Una partícula libre se mueve en línea recta con velocidad constante, y $O$
  es un punto fuera de su recta. ¿Barre áreas iguales en tiempos iguales
  respecto de $O$? Muéstrelo con un dibujo. ¿Contradice al inciso anterior?
+ ¿Y respecto de un punto que está *sobre* su recta?
+ Dos partículas iguales avanzan con velocidades opuestas por rectas paralelas.
  ¿Por qué el momento angular del par es el mismo respecto de cualquier punto?
+ ¿En qué parte de su órbita va más rápido un planeta? Respóndalo sólo con la
  segunda ley.

#ejercicio(5, [alcanzar al de adelante], [1,5])
#origen[Transferencia de Hohmann y encuentro orbital. Se apoya en los Problemas 5 (S&Z 13.79) y 10 (rendez-vous) de gravitación.]

+ En un vuelo de la Tierra a Marte por Hohmann, ¿en qué dirección se
  encienden los motores al salir y al llegar: a favor del movimiento o en
  contra? ¿Y en un vuelo de Marte a la Tierra?
+ ¿Por qué el viaje dura exactamente medio período de la elipse de
  transferencia? Use la simetría.
+ Dos naves están en la misma órbita circular, y el blanco $B$ va un cuarto de
  órbita adelante de $C$, como en la figura. Para alcanzarlo, $C$ tiene que:
  (a) acelerar;
  (b) frenar;
  (c) cualquiera de las dos, da lo mismo;
  (d) cambiar de plano.

  #fp.fig-misma-orbita
+ Explique por qué la opción intuitiva aleja a $C$ en lugar de acercarlo.
+ Si $C$ quiere encontrar a $B$ después de *una* vuelta en su nueva órbita,
  ¿cuánto tiene que durar esa vuelta, comparada con la de la circular? ¿Qué
  semieje mayor tiene la órbita nueva, en términos del radio $r$ de la
  circular? Dibuje las dos órbitas.

#ejercicio(6, [el satélite que despliega antenas], [1,5])
#origen[Cuerpo rígido: misma velocidad angular para todos los puntos, momento de inercia, Steiner, conservación del momento angular. Se apoya en los Problemas 4 y 7 de la sección de impulso angular y en la lista de temas de cuerpo rígido.]

Un satélite gira sobre su eje de simetría con dos antenas largas plegadas
contra el cuerpo. Sin encender ningún motor, despliega las antenas.

+ ¿Qué se conserva durante el despliegue, y por qué? ¿Qué le pasa a la
  velocidad angular?
+ Si al desplegar el momento de inercia se triplica, ¿cuánto cambian la
  velocidad angular y la energía cinética? ¿Adónde fue la energía que falta?
+ Discuta, con el teorema de Steiner, por qué alejar una masa del eje
  aumenta tanto el momento de inercia.
+ Después del despliegue, ¿qué punto del satélite tiene mayor velocidad
  angular, y cuál mayor rapidez?
+ Complete la tabla de analogías entre traslación y rotación: fuerza, masa,
  aceleración, cantidad de movimiento, energía cinética, segunda ley.
+ ¿Por qué el momento de inercia aparece al escribir la energía cinética de un
  cuerpo que gira?

#pagebreak()

= Resolución

== Ejercicio 1 — el satélite que sale de la bodega

#notacion[
  $bold(J) = integral bold(F) dif t = Delta bold(p) = bold(F)_"med" Delta t$ es el
  impulso (no confundir con el *impulso angular* de la guía, que es el momento
  angular $bold(L)$). $K = 1/2 M v_"CM"^2 + K_"rel"$ es el teorema de König.
]

#idea[
  El mecanismo empuja al satélite y el satélite empuja al mecanismo, con la
  misma fuerza durante el mismo tiempo: los dos impulsos son iguales y
  opuestos. Lo que los diferencia es la masa que tiene que moverse.
]

+ Iguales en módulo y opuestos (tercera ley, mismo $Delta t$). Como
  $Delta v = J \/ m$, el transbordador cambia su velocidad $90 thin 000 \/ 800 = 112,5$
  veces menos que el satélite. En números: el satélite se lleva casi toda la
  velocidad relativa y el transbordador retrocede apenas $2,64$ mm/s.
+ *(c)*. Las fuerzas del mecanismo son internas al conjunto: el centro de
  masa no se entera.
+ El impulso es el mismo (lo fija el cambio de velocidad, que es el mismo),
  así que la velocidad final de cada uno no cambia. Lo que cambia es la fuerza
  media: con el doble de tiempo, la *mitad* de fuerza. Es la razón de los
  airbags y de los mecanismos de expulsión suaves.
+ Se conserva $bold(P)$: el choque dura poco y las fuerzas internas son
  enormes frente a las externas. La energía cinética no se conserva. Con
  $K = 1/2 M v_"CM"^2 + K_"rel"$: la primera parte no puede cambiar, porque
  $v_"CM" = P \/ M$ y $P$ se conserva; lo único que se puede perder es
  $K_"rel"$, y en un choque en que quedan pegados se pierde *entera*.
+ Sólo si $bold(P) = 0$: entonces $v_"CM" = 0$, toda la energía cinética es
  relativa, y un choque plástico la puede perder toda. Con $bold(P) != 0$, el
  centro de masa sigue moviéndose y algo tiene que moverse con él.

#trampa[
  «El transbordador recibe menos impulso porque es más pesado». El impulso es
  el mismo; lo que es menor es el *cambio de velocidad*.
]

#final[Impulsos iguales y opuestos; el transbordador cambia $112,5$ veces menos su velocidad; con $8$ s, la mitad de fuerza y la misma velocidad final; en un choque sólo se puede perder $K_"rel"$, y todo sólo si $bold(P) = 0$.]

== Ejercicio 2 — el cohete en el vacío

#notacion[
  $mu = -dif M \/ dif t$ el caudal, $v_r$ la velocidad de los gases respecto
  del cohete. $I_"sp" = v_r \/ g_0$. Beer §14.12 para la masa variable.
]

#idea[
  El cohete no empuja contra el aire ni contra nada de afuera: empuja contra
  *sus propios gases*. El sistema cohete + gases tiene cantidad de movimiento
  constante, y si los gases salen para atrás el cohete gana para adelante.
]

+ Es falso. El cohete empuja a los gases hacia atrás y los gases lo empujan a
  él hacia adelante (tercera ley); no hace falta ningún medio. En el vacío
  anda *mejor*: no hay aire que frene ni presión de afuera que reste empuje.
+ Lo mismo: el calamar expulsa agua para atrás y gana cantidad de movimiento
  para adelante; el sistema calamar + agua expulsada conserva $bold(P)$. La
  diferencia es que el calamar toma el agua del medio y el cohete lleva todo
  su propelente.
+ $dif (M bold(v)) \/ dif t = bold(F)_"ext"$ vale para un sistema de masa
  *fija*, y el cohete no lo es. Además, el término $bold(v) dif M \/ dif t$
  supone que la masa que sale se va con la velocidad del cohete, y se va con
  la del cohete *menos* $bold(v)_r$. Haciendo bien el balance entre $t$ y
  $t + dif t$ (cohete + gas expulsado):
  $ M (dif bold(v)) / (dif t) = bold(F)_"ext" - mu bold(v)_r, $
  donde $-mu bold(v)_r$ es el empuje, opuesto a la salida de los gases.
+ Porque $I_"sp" = v_r \/ g_0$ es una velocidad dividida por una aceleración:
  tiempo. Se lee como los segundos que un kilogramo de propelente puede
  sostener un empuje igual a su propio peso. Con $455$ s,
  $v_r = 455 dot 9,81 = 4464$ m/s.
+ En el espacio terminan *igual*: $Delta V = v_r ln (M_0 \/ M_f)$ no depende de
  cuánto tarda en quemarse. Despegando de la Tierra,
  $Delta V = v_r ln (M_0 \/ M_f) - g t_b$: el lento pierde
  $g dot 100 = 981$ m/s contra la gravedad y el rápido sólo $98,1$ m/s. El
  rápido termina $883$ m/s más rápido. Por eso los cohetes queman fuerte al
  principio; lo que lo limita en la realidad es la estructura (y la
  tripulación), que no aguanta aceleraciones enormes, y el aire.

#trampa[
  Usar Tsiolkovsky sin el término $-g t_b$ para un despegue, o creer que el
  ritmo de quemado importa en el espacio. Importa *sólo* cuando hay gravedad.
]

#final[Empuja contra sus gases; $M dif bold(v)\/dif t = bold(F)_"ext" - mu bold(v)_r$; $455$ s son $4464$ m/s; en el espacio da igual el ritmo, despegando gana el rápido por $883$ m/s.]

== Ejercicio 3 — subir o acelerar

#notacion[
  $U = -mu_T m \/ r$ con cero en el infinito; $E = K + U$. En km²/s², un
  número por kilogramo es directamente MJ/kg.
]

#idea[
  Llegar a órbita no es tanto cuestión de *altura* como de *velocidad*. La
  energía potencial cambia poco entre la superficie y $300$ km; la cinética de
  la órbita es enorme.
]

+ $U(r) = -G M_T m \/ r$: crece (se hace menos negativa) con $r$, y tiende a
  cero en el infinito. Una órbita tiene $E < 0$ (queda ligada: hay un $r$
  máximo); escapar justo es $E = 0$; escapar con sobra, $E > 0$:

  #figs.fig-pozo-gravitatorio
  #dib.pie-figura[El diagrama de energía del apunte (módulo de energía). La distancia vertical entre la recta $E$ y la curva es $K$.]
+ Es negativa porque el cero se eligió en el infinito, donde los cuerpos no
  interactúan, y acercarlos *libera* energía: hay que darles energía para
  separarlos. No es del satélite ni de la Tierra: es *una sola energía del
  par*, de la interacción (la opción correcta del parcialito 2). Se la anota
  «del satélite» sólo porque la Tierra casi no se mueve.
+ Subirlo: $Delta U = mu_T (1\/R_T - 1\/r) = 398 thin 600 (1\/6378 - 1\/6678) = 2,81$ MJ/kg.
  Darle la rapidez: $K = mu_T \/ (2 r) = 29,8$ MJ/kg. En total $32,6$ MJ/kg, y la
  rapidez cuesta $10,6$ veces más que la altura. *Lo caro es la velocidad
  horizontal*, no subir.
+ No depende de la dirección (mientras no apunte contra la Tierra): la
  energía es un escalar, y $E = 0$ se alcanza con el mismo módulo de
  velocidad en cualquier dirección. Tampoco de la masa: en $1/2 m v^2 = G M m \/ r$
  la $m$ se simplifica.
+ *(b)*. En una circular $K = mu_T m \/ (2 r)$ y $E = -mu_T m \/ (2 r)$. El roce
  saca energía, así que $E$ baja (se hace más negativa): $r$ disminuye. Y al
  disminuir $r$, $K$ *aumenta*. La energía que el satélite gana en $K$ sale de
  $U$, que baja el doble de lo que baja $E$: la gravedad hace más trabajo
  positivo que el trabajo negativo del roce. Es la «paradoja del arrastre».

#trampa[
  «El roce siempre frena». Frena *localmente*, en cada instante; pero al bajar
  la órbita la gravedad acelera al satélite más de lo que el roce lo frena.
]

#final[$U = -G M_T m\/r$, una energía del par; subir a $300$ km cuesta $2,81$ MJ/kg y la rapidez $29,8$ MJ/kg ($10,6$ veces más); el escape no depende de la dirección ni de la masa; con roce, la rapidez sube.]

== Ejercicio 4 — áreas iguales

#notacion[
  $dif A \/ dif t = abs(bold(r) times bold(v)) \/ 2 = L \/ (2 m) = h \/ 2$ es la
  velocidad areolar. La guía llama «impulso angular» al momento angular $bold(L)$.
]

#idea[
  El área que barre el radio en un $dif t$ es la mitad de
  $abs(bold(r) times bold(v) dif t)$. Áreas iguales en tiempos iguales es
  exactamente $bold(L)$ constante, y $bold(L)$ es constante cuando no hay
  torque.
]

+ El radio vector barre áreas iguales en tiempos iguales:
  $dif A \/ dif t = L \/ (2 m) = "cte"$. Es la conservación del momento angular
  dicha con geometría.
+ *(b)*. Alcanza con que la fuerza sea central: entonces el torque respecto
  del centro es cero, $bold(L)$ se conserva, y las áreas también. El $1\/r^2$
  decide la *forma* de la órbita (una cónica), no las áreas.
+ Sí: en tiempos iguales recorre tramos iguales de la recta, y los triángulos
  con vértice en $O$ tienen la misma base y la misma altura $d$, así que la
  misma área:

  #fp.fig-areas-particula
  #dib.pie-figura[Tres triángulos de igual base ($v Delta t$) e igual altura ($d$): igual área.]

  No contradice nada: una fuerza nula es, trivialmente, central respecto de
  cualquier punto. Es el Problema 2 de la guía: $bold(L) = m v d$ constante.
+ Respecto de un punto de la recta, $bold(r)$ y $bold(v)$ son paralelos: $bold(L) = 0$
  y no barre área. También constante, pero cero.
+ Al cambiar el origen en $bold(R)$, el momento angular cambia en
  $-bold(R) times bold(P)$. Con velocidades opuestas, $bold(P) = 0$, y el
  cambio es cero (Problema 3).
+ Cerca del perihelio: para barrer la misma área con un radio corto tiene que
  recorrer un arco más largo en el mismo tiempo.

#trampa[
  Elegir (a): Kepler encontró la segunda ley en órbitas de gravedad, pero la
  ley vale para cualquier fuerza central.
]

#final[$dif A\/dif t = L\/2m$; alcanza con fuerza central; la partícula libre barre áreas iguales respecto de cualquier punto fuera de su recta; con $bold(P) = 0$, $bold(L)$ no depende del origen; más rápido en el perihelio.]

== Ejercicio 5 — alcanzar al de adelante

#notacion[
  $T prop a^(3\/2)$ (tercera ley de Kepler). Nave $C$ = la que persigue
  (*chaser*), $B$ = el blanco. Los encendidos son impulsivos y tangenciales.
]

#idea[
  En órbita, ir «más rápido» no es dar la vuelta antes. Acelerar sube la
  órbita, y una órbita más grande tiene un período *más largo*. Para adelantar
  hay que frenar.
]

+ Tierra → Marte: los dos encendidos *a favor* del movimiento. El primero
  pasa de la circular de la Tierra a la elipse (más energía); el segundo, en
  el afelio de la elipse, donde la nave va más lento que Marte, la
  circulariza. Marte → Tierra: los dos *en contra*.
+ La transferencia va del perihelio al afelio: media elipse. Por la simetría
  respecto del eje mayor, y por la segunda ley (media área en medio período),
  tarda exactamente medio período.
+ *(b)*, frenar.
+ Si $C$ acelera, pasa a una elipse más grande (sube el apogeo), con período
  más largo: al volver al punto de partida llega *después* que antes, y $B$
  se le adelanta todavía más. Frenando, pasa a una elipse más chica con
  período más corto, y cada vuelta recupera terreno.
+ En una vuelta de $C$, $B$ tiene que recorrer $360° - 90° = 270°$, tres
  cuartos de su órbita: $T' = 3\/4 thin T$. Con $T prop a^(3\/2)$:
  $a' = r (3\/4)^(2\/3) = 0,825 r$. El punto del encendido queda como apogeo y
  el perigeo baja a $2 a' - r = 0,651 r$ (con una órbita baja, hay que
  chequear que no toque la atmósfera). Al volver, $C$ acelera la misma
  cantidad y vuelve a la circular, al lado de $B$:

  #figs.fig-rendezvous-phasing
  #dib.pie-figura[El caso de un cuarto de órbita, del apunte (módulo de maniobras).]

#trampa[
  Elegir (a), «para alcanzarlo hay que ir más rápido». Es la intuición del
  auto en la ruta, que en órbita sale al revés.
]

#final[Tierra→Marte: los dos a favor; medio período por simetría; para alcanzar al de adelante, frenar: $T' = 3\/4 thin T$, $a' = 0,825 r$, y acelerar al volver.]

== Ejercicio 6 — el satélite que despliega antenas

#notacion[
  $I = sum m_i r_i^2$ (no se calcula: se busca en la tabla, ANI-24);
  $L = I omega$; $K = 1/2 I omega^2 = L^2 \/ (2 I)$. Steiner:
  $I = I_"CM" + M d^2$.
]

#idea[
  Desplegar es interno: no hay torque externo y $L$ se conserva. Pero la
  misma $L$ con más $I$ quiere decir menos $omega$ (la patinadora que abre los
  brazos).
]

+ Se conserva $bold(L)$, porque las fuerzas del despliegue son internas y no
  hay torque externo. Como $L = I omega$ y el despliegue aumenta $I$, la
  velocidad angular *baja*.
+ $omega$ pasa a $omega \/ 3$. La energía, $K = L^2 \/ (2 I)$ con $L$ fija, pasa a
  $K \/ 3$: se pierden dos tercios. Al alejarse del eje, las antenas se mueven
  hacia afuera contra la fuerza centrípeta que las retiene (hacia adentro), y
  esa fuerza interna hace trabajo negativo; la energía termina en los
  amortiguadores y trabas del mecanismo, como calor. Si las antenas se
  plegaran de nuevo, el mecanismo tendría que *hacer* ese trabajo.
+ Una masa a distancia $d$ del eje aporta $M d^2$ (más su $I_"CM"$, que es
  chico): *cuadrático* en la distancia. Al doble de distancia, cuatro veces
  más. Por eso una antena larga y liviana cambia el $I$ del satélite mucho
  más de lo que su masa haría pensar.
+ Todos los puntos tienen la *misma* velocidad angular: es lo que define a un
  rígido. La mayor *rapidez* la tienen las puntas de las antenas, porque
  $v = omega r$.
+ Fuerza $bold(F)$ ↔ torque $bold(tau)$; masa $m$ ↔ momento de inercia $I$;
  aceleración $a$ ↔ aceleración angular $alpha$; cantidad de movimiento
  $bold(p) = m bold(v)$ ↔ momento angular $bold(L) = I bold(omega)$; energía
  cinética $1/2 m v^2$ ↔ $1/2 I omega^2$; $bold(F) = m bold(a)$ ↔
  $tau = I alpha$ (eje fijo).
+ Porque cada punto tiene rapidez $omega r_i$ con la *misma* $omega$:
  $K = sum 1/2 m_i (omega r_i)^2 = 1/2 (sum m_i r_i^2) omega^2$. La suma que
  queda entre paréntesis es $I$: aparece sola, como el «costo» de hacer girar
  el cuerpo, igual que $m$ en $1/2 m v^2$.

#trampa[
  Conservar la energía cinética en el despliegue y sacar $omega$ de ahí. Lo
  que se conserva es $L$; la energía *no*.
]

#final[$L$ se conserva; con $I$ triplicado, $omega\/3$ y $K\/3$ (el resto se disipa en el mecanismo); Steiner: $M d^2$, cuadrático en la distancia; $I$ aparece al escribir $K$ porque todos los puntos comparten $omega$.]
