// =====================================================================
//  Cuerpo rigido -- Problemas 1 a 4 de la guia, resueltos (2026-10-22)
//  Para la clase siguiente a la del 19/10, donde Anibal subio sus
//  resoluciones de los Ejercicios 1 y 2 («Ejercicio 1/2 CR 2026.pdf»), el
//  PDF de control de actitud de la Universidad de Sevilla y cuatro
//  animaciones. Lo que pidio: justificar cada aproximacion. Cada numero
//  tiene su cuenta en validar.py; las figuras de datos, en figuras-cr.py.
// =====================================================================
#import "estilo.typ": *
#import "../apunte/biblioteca/figuras.typ" as figs

#show: documento.with(
  titulo: [Cuerpo rígido — Problemas 1 a 4, resueltos],
  subtitulo: [La sección de cuerpo rígido de la guía, con lo que dejó Aníbal de la clase del 19/10 y cada supuesto dicho en voz alta],
  encabezado: [Cuerpo rígido — Problemas 1 a 4, resueltos],
)

#let figura(archivo, ancho, epigrafe) = figure(
  image("figuras-cr/" + archivo, width: ancho),
  caption: text(size: 9pt, epigrafe),
)
#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)
#let supuestos(..filas) = {
  set par(justify: false)
  table(
    columns: (1.2fr, 2.2fr, 0.9fr),
    inset: (x: 5pt, y: 4pt),
    table.header(..([Supuesto], [Por qué vale acá], [Cuánto pesa]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t])),
    ..filas.pos().flatten().map(c => text(size: 8.5pt, c)),
  )
}

#caja([De dónde sale cada cosa], c-viole)[
  Los cuatro son los Problemas 1 a 4 de la sección *Cuerpo rígido* de la guía
  de la cátedra (versión 2026, págs. 17 a 19 del PDF). Para la clase del
  *19/10* Aníbal pidió el capítulo 18 del *Beer* leído y subió sus
  resoluciones de los dos primeros, unas diapositivas de control de actitud
  de la Universidad de Sevilla (R. Vázquez, 2021) y cuatro animaciones. Lo
  que pidió en voz alta: *considerar las aproximaciones y justificarlas*. Por
  eso cada problema trae una tabla de supuestos antes de la primera cuenta.

  #mapa(
    ([1], [Satélite cúbico con un _thruster_ en un vértice: $Delta bold(H) = bold(tau) Delta t$ y tensor isótropo], [Guía, CR, Problema 1 · «Ejercicio 1 CR 2026» de Aníbal y `giro_satelite.gif` · Beer §18.2]),
    ([2], [Disco en la horquilla: el momento angular y su derivada con el teorema del transporte], [Guía, CR, Problema 2 · «Ejercicio 2 CR 2026» y las tres animaciones `anim_*.gif` · Beer §15.10 y §18.5; Curtis §1.6]),
    ([3], [Volante en el _gimbal_: por qué 600 N·m aceleran tan poco], [Guía, CR, Problema 3 (sin resolución de Aníbal) · Sevilla, diap. 10 y 14 (volantes y CMG) · Beer §18.5 y §18.6]),
    ([4], [_Spacecraft_ libre de torques que precesa: período y sentido del spin], [Guía, CR, Problema 4 · Sevilla, diap. 5 a 9 (precesión libre y regla del eje mayor) · Beer §18.9 y §18.11]),
  )
]

#notacion[
  La guía le dice «impulso angular» a $bold(L)_G$; acá es el *momento angular*
  $bold(H)_G$ (la letra del Beer y de las resoluciones de Aníbal: «ojo, $L$ es
  $H$ y $P$ es $L$»), y el impulso angular es lo que un torque le cambia en un
  intervalo, $integral bold(tau) dif t = Delta bold(H)$. $bold(omega)$ es la
  velocidad angular del *cuerpo*; $bold(Omega)$, la del *sistema de ejes* desde
  el que se deriva. No siempre son la misma, y los Problemas 2 y 3 viven de esa
  diferencia.
]

#caja([Dónde leerlo], c-libro)[
  *Beer, Dinámica, cap. 18* (Fran lo anotó «Curtis, Ver»: es el *Beer*). El
  capítulo 18 remite al 15 cada vez que tiene que derivar $bold(H)_G$: a la
  *§15.10* («Razón de cambio de un vector con respecto a un sistema de
  referencia en rotación», pág. 975, ec. 15.31) en la §18.5 (pág. 1169), y a la
  *§15.12* (cono espacial y cono corporal, pág. 988) en la §18.11 (pág. 1191).
  El «9» es el de la lista de temas: los ejes principales están en el Beer de
  *Estática*, §9.16 y §9.17. Y el *Curtis, §1.6* («Time derivatives of moving
  vectors», págs. 21 a 26) cuenta lo mismo con un dibujo mejor: su *Fig. 1.15*
  es un vector clavado a un cuerpo que gira alrededor del eje instantáneo.
]

= La herramienta de los cuatro: derivar un vector que gira

Antes de los problemas, la única fórmula nueva que usan, contada como la
cuenta el Curtis en su §1.6. Un vector $bold(A)$ de módulo fijo, *clavado* a
un cuerpo que en un instante gira con $bold(omega)$ alrededor de su eje
instantáneo: en un $dif t$ el cuerpo gira un ángulo $dif theta = abs(bold(omega)) dif t$
y la punta de $bold(A)$ recorre un arquito de radio $abs(bold(A)) sin phi$
($phi$ es el ángulo entre $bold(A)$ y el eje), perpendicular al plano de los
dos. Eso es exactamente un producto vectorial (Curtis ecs. 1.47 a 1.52, Fig. 1.15):

$ (dif bold(A))/(dif t) = bold(omega) times bold(A) quad "si " abs(bold(A)) "no cambia" $

Ahora un vector $bold(B)$ cualquiera, escrito en una terna $hat(i), hat(j),
hat(k)$ que gira con $bold(Omega)$. Al derivar $bold(B) = B_x hat(i) + B_y
hat(j) + B_z hat(k)$ aparecen dos cosas: lo que cambian las componentes (lo
que ve un observador montado en la terna) y lo que cambian los versores, que
son vectores de módulo fijo clavados a la terna: $dot(hat(i)) = bold(Omega)
times hat(i)$, y lo mismo $hat(j)$ y $hat(k)$. Juntando:

$ ((dif bold(B))/(dif t))_"inercial" = ((dif bold(B))/(dif t))_"rel" + bold(Omega) times bold(B) $

Es la ec. 1.56 del Curtis y la 15.31 del Beer (pág. 976), y en las
resoluciones de Aníbal se llama *teorema del transporte*: el segundo término
«transporta» el vector con la terna. Tres cosas que deciden si los problemas
salen o no:

+ *$bold(Omega)$ es la velocidad angular de la TERNA*, no la del cuerpo. Uno la
  elige, y conviene elegir la terna en la que las componentes de $bold(H)_G$
  queden constantes: entonces la derivada relativa es cero y sobrevive un solo
  producto vectorial.
+ La derivada relativa es la que se calcula «con los versores quietos»: se
  derivan los números, nada más.
+ La terna se elige *clavada a algo concreto* (la horquilla, el _gimbal_, el
  cuerpo) y se dice en voz alta cuál es. El Problema 2 la resuelve en dos
  ternas distintas y da lo mismo, como tiene que ser.

#figure(figs.fig-vector-rotante, caption: text(size: 9pt)[El teorema en dos casos (de la biblioteca del apunte, módulo de cinemática del cuerpo rígido). *Izquierda:* $bold(Q)$ clavado a la terna: su punta recorre un círculo y su derivada es $bold(Omega) times bold(Q)$, la Fig. 1.15 del Curtis vista de costado. *Derecha:* si además cambia dentro de la terna, las dos contribuciones se suman.])

#posta[
  El que va en la calesita ve el vector quieto; el de afuera lo ve dar
  vueltas; la diferencia entre los dos es $bold(Omega) times bold(B)$ y nada
  más. Los cuatro problemas son esta frase aplicada a $bold(H)_G$: lo único
  que cambia es qué calesita conviene elegir.
]

#pagebreak()
= Problema 1 — el satélite cúbico

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía de la cátedra 2026, sección Cuerpo rígido, Problema 1 (enunciado recortado tal como lo pegó Aníbal). El inciso 4 lo agregó él en «Ejercicio 1 CR 2026». Libro: Beer §18.2 ($bold(H)_G$ con el tensor de inercia) y §18.6.]
  #image("recortes/cr-1-1.pdf", width: 100%)
  4. *Addendum (Aníbal, 19/10):* ¿qué pasa con el desplazamiento?
]

#idea[
  El empuje no pasa por el centro de masa $G$. Una fuerza aplicada fuera de
  $G$ equivale a *la misma fuerza aplicada en $G$* —que traslada al satélite—
  *más un par* $bold(r) times bold(F)$ —que lo hace girar—. Y el cubo tiene una
  gracia: sus tres momentos principales son iguales, así que su tensor de
  inercia es un número por la identidad en *cualquier* terna por $G$. Para el
  cubo $bold(H)_G = I bold(omega)$ siempre, $bold(omega)$ sale paralela al
  torque y no hay términos giroscópicos: es la rotación de Física 1 con
  vectores.
]

#supuestos(
  ([Cubo homogéneo y rígido], [Lo da el dato $I = 1/6 m d^2$. Sin paneles, antenas ni combustible que chapotee: un satélite real los tiene, y la energía que pierden es la que hizo dar tumbos al Explorer 1 (Problema 4).], [define el problema]),
  ([Masa e inercia constantes durante el encendido], [En 4 s se queman $32,6$ g de 120 kg.], [$0,027$ %]),
  ([Empuje constante, encendido y apagado instantáneos], [No hay datos del transitorio de la válvula; un escalón de 4 s es lo que dice el enunciado.], [sin dato]),
  ([El empuje gira con el cuerpo], [Para la *rotación* no importa: el eje de giro es paralelo a $bold(tau)$, y $bold(tau)$ está clavado al cuerpo *sobre* ese eje, así que tampoco se mueve en el espacio y $Delta bold(H) = bold(tau) Delta t$ es exacto. Para la *traslación* sí importa: inciso 4.], [$1,4$ % en $Delta v$]),
  ([Sin torques externos después del encendido], [En órbita baja quedan el arrastre, la presión de radiación y el torque magnético residual, chiquitos. El gradiente de gravedad, que en cualquier otro satélite es el primero de la lista (Sevilla, diap. 12), en un cubo isótropo es *cero*: depende de las diferencias entre momentos de inercia.], [despreciable]),
  ([Se toman momentos respecto de $G$], [$sum bold(M)_G = dot(bold(H))_G$ vale aunque $G$ acelere: es la gracia del centro de masa (Beer §14.4 y §18.3).], [exacto]),
)

#paso(1, [el momento de inercia])
$ I = 1/6 m d^2 = 1/6 (120 " kg")(2 " m")^2 = 80 " kg·m²" $
igual para cualquier eje que pase por $G$ (el tensor es isótropo).

#paso(2, [el torque])
Origen en $G$, ejes paralelos a las aristas. El _thruster_ está en el vértice
$bold(r) = (1; 1; 1)$ m y empuja a lo largo de la arista paralela a $x$,
$bold(F) = (4; 0; 0)$ N:
$ bold(tau) = bold(r) times bold(F) = (1; 1; 1) times (4; 0; 0) = (0; 4; -4) " N·m", quad abs(bold(tau)) = 4 sqrt(2) = 5,66 " N·m" $
Es $F$ por un brazo de $sqrt(2)$ m: la distancia de la arista al centro, media
diagonal de cara. Fijate que $bold(tau)$ es perpendicular a $bold(F)$ *y* a la
diagonal del cubo que sale de ese vértice: apunta a lo largo de una diagonal
de cara.

#paso(3, [la velocidad angular (inciso 1)])
El torque es constante durante los 4 s, así que el impulso angular es
$ Delta bold(H)_G = bold(tau) Delta t = (0; 16; -16) " N·m·s" $
y como el cubo arranca quieto y es isótropo,
$ bold(omega) = (Delta bold(H)_G)/I = (0; 0,2; -0,2) " rad/s", quad abs(bold(omega)) = 0,2 sqrt(2) = 0,283 " rad/s" $
que son $16,2$ °/s, o $2,70$ vueltas por minuto: una vuelta cada $22,2$ s,
justo lo que muestra `giro_satelite.gif`. Durante el encendido la aceleración
angular es $abs(bold(tau))\/I = 0,0707$ rad/s², y el cubo alcanza a girar
$0,566$ rad ($32,4$ °) antes de que se apague el _thruster_.

#figura("cr1-cubo.svg", 62%)[El cubo con el _thruster_ en $(1; 1; 1)$: $bold(F)$ sobre $+x$, y $bold(tau)$ y $bold(omega)$ sobre la diagonal de cara $(0; 1; -1)$. En ámbar, el círculo que recorre el vértice alrededor del eje de giro.]

#paso(4, [el caudal másico (inciso 2)])
$ dot(m) = F_E/(I_"sp" g_0) = (4 " N")/((50 " s")(9,81 " m/s²")) = 8,16 times 10^(-3) " kg/s" $
O sea $8,16$ g/s, con una velocidad de eyección $v_e = I_"sp" g_0 = 490,5$
m/s. En los 4 s se van $32,6$ g, el $0,027$ % de la masa: el supuesto de masa
constante queda justificado con un número, que es como se justifica.

#paso(5, [cuánto gira (inciso 3)])
*Para siempre*, en el modelo. Apagado el _thruster_ no queda torque, así que
$bold(H)_G$ se conserva; y como el cubo es isótropo, $bold(omega) =
bold(H)_G \/ I$ también: gira a $0,283$ rad/s alrededor de un eje fijo en el
espacio, sin precesión ni nutación. Lo que lo frenaría en serio son los
torques chiquitos de la tabla, en escalas de horas a meses. Para pararlo hay
que *meterle el torque opuesto*: el mismo _thruster_ dado vuelta, o el del
vértice $(1; -1; -1)$ —la otra punta de la diagonal de esa cara— empujando
también hacia $+x$, que da $(1; -1; -1) times (4; 0; 0) = (0; -4; 4)$ N·m.
Como el eje de giro está fijo en el cuerpo y en el espacio, sirve en
cualquier momento, no hay que esperar a que el cubo «vuelva a su lugar».

#trampa[
  *El _thruster_ diametralmente opuesto no lo frena: lo acelera.* El del
  vértice $(-1; -1; -1)$ empujando hacia $-x$ da $(-1; -1; -1) times (-4; 0; 0)
  = (0; 4; -4)$ N·m, *el mismo torque*, con la fuerza contraria. Los dos juntos
  son un *par puro*: hacen girar sin trasladar, que es por qué los sistemas de
  control de actitud con toberas las montan de a pares.
]

#paso(6, [el desplazamiento (inciso 4, el de Aníbal)])
Además de girar, el satélite se traslada: el centro de masa acelera con
$bold(F)\/m$ *sin importar dónde* se aplique la fuerza. La resolución de
Aníbal da
$ Delta v = (F Delta t)/m = (4 dot 4)/120 = 0,133 " m/s" quad "en la dirección " +x $
y se mueve unos $0,267$ m durante el encendido, para seguir después a velocidad
constante. Esa cuenta tiene un supuesto adentro: que $bold(F)$ apunta siempre
hacia $+x$. No es así: el _thruster_ está clavado al cubo, y el cubo gira
$32,4$ ° mientras empuja. Sumando el empuje que gira, el impulso lineal real
es un poco más corto y está torcido: $Delta v = 0,131$ m/s, a $10,8$ ° de $x$,
en el plano perpendicular al eje de giro. La diferencia es de $1,4$ %, chica;
lo que no puede pasar es no saber que está.

#figura("cr1-empuje.svg", 78%)[El empuje, visto desde la punta de $bold(omega)$, segundo a segundo: gira $32,4$ ° en el encendido porque gira el cubo. La suma de esas flechas es el impulso lineal real (verde), un poco más corto y torcido que el de la cuenta con $bold(F)$ fijo (gris).]

#caja([La pregunta de Aníbal: ¿y si ya tenía momento angular?], c-azul)[
  Si el cubo ya giraba con $bold(omega)_0$, el impulso angular se *suma como
  vector*: $bold(H)_"final" = I bold(omega)_0 + integral bold(tau) dif t$. Con
  una salvedad que es la misma del inciso 4: si $bold(omega)_0$ no es paralela
  a $bold(tau)$, el cubo gira alrededor de otro eje, el _thruster_ (clavado al
  cuerpo) se mueve en el espacio y $integral bold(tau) dif t$ ya no es
  $bold(tau) Delta t$. Vale como aproximación si el encendido es corto frente
  a una vuelta. Lo que *no* cambia: el cubo es isótropo, así que después del
  encendido $bold(omega) = bold(H)\/I$ queda fija y no hay precesión. Si el
  satélite fuera un prisma, con momentos distintos, el mismo pulso daría un
  $bold(H)$ en la dirección del torque pero un $bold(omega)$ que *no* le es
  paralelo, y $bold(omega)$ empezaría a precesar alrededor de $bold(H)$: es el
  Problema 4. Y es por qué la resolución de Aníbal cierra con las ecuaciones
  de Euler: en el cubo los términos $(I_k - I_j) omega_j omega_k$ son cero, y en
  cualquier otro cuerpo no.
]

#final[$I = 80$ kg·m²; $bold(omega) = (0; 0,2; -0,2)$ rad/s, de módulo $0,283$ rad/s, sobre una diagonal de cara; $dot(m) = 8,16$ g/s; gira para siempre (para frenarlo, el torque opuesto); el centro de masa sale a unos $0,13$ m/s.]

= Problema 2 — el disco en la horquilla

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía de la cátedra 2026, sección Cuerpo rígido, Problema 2 (la figura es del Beer). Resolución de Aníbal: «Ejercicio 2 CR 2026», con las animaciones `anim_horquilla.gif`, `anim_disco.gif` y `anim_inercial.gif`. Libro: Beer §15.10 y §18.5; Curtis §1.6.]
  #image("recortes/cr-2-1.pdf", width: 100%)
]

#nota[«impulso angular $bold(L)_G$» es el momento angular $bold(H)_G$. Y el texto dice «eje vertical» pero la figura muestra el eje del disco *horizontal* (sobre $z$) y la horquilla girando alrededor de la vertical ($y$): se resuelve con la figura, como lo hace Aníbal.]

#idea[
  El disco hace dos giros a la vez: el suyo, $omega_1$, sobre su eje, y el de
  la horquilla, $omega_2$, sobre la vertical. Las velocidades angulares se
  suman, pero el momento angular *no* sale paralelo a la suma, porque el disco
  tiene más inercia sobre su eje que sobre un diámetro. Y aunque las dos
  rapideces sean constantes, $bold(H)_G$ da vueltas con la horquilla: su
  derivada no es cero. Esa derivada es la cupla que la horquilla le tiene que
  hacer al disco para obligarlo a dar vueltas así.
]

#supuestos(
  ([Disco delgado y homogéneo], [Da $I_z = 1/2 m r^2$ e $I_x = I_y = 1/4 m r^2$. Con un espesor de 1 cm en un disco de 10 cm de radio, $I_x$ crece un $0,33$ %.], [$< 1$ %]),
  ([$omega_1$ y $omega_2$ constantes], [Lo dice el enunciado: algo (un motor, la mano) los sostiene. Esa cupla de sostén es justamente lo que se pide.], [define el problema]),
  ([$G$ fijo], [El eje vertical de la horquilla pasa por el centro del disco.], [exacto]),
  ([El peso no entra], [Actúa en $G$: no hace torque respecto de $G$.], [exacto]),
  ([Se pide el momento angular del *disco*], [La masa de la horquilla no interviene.], [—]),
)

#paso(1, [tres sistemas de referencia, todos con origen en $G$ (como en la resolución de Aníbal)])
- $G X Y Z$, *inercial*.
- $G x y z$, *clavado a la horquilla*: $z$ sobre el eje del disco, $y$ sobre la
  varilla vertical, $x = y times z$. Gira con $bold(Omega) = omega_2 hat(j)$.
- $G x'' y'' z''$, *clavado al disco*: comparte $z$ con el de la horquilla y
  además gira con $omega_1$. Gira con $bold(Omega) = bold(omega)$.

#paso(2, [la velocidad angular del disco y su momento angular (inciso 1)])
$ bold(omega) = omega_2 hat(j) + omega_1 hat(k) $
Los ejes de la horquilla son principales del disco en todo instante ($z$ es su
eje de simetría; $x$ e $y$, diámetros). Componente por componente:
$ bold(H)_G = I_y omega_2 hat(j) + I_z omega_1 hat(k) = 1/4 m r^2 (omega_2 hat(j) + 2 omega_1 hat(k)) $
La razón de componentes en $bold(omega)$ es $omega_2\/omega_1$; en $bold(H)_G$,
$omega_2\/(2 omega_1)$: el momento angular está más pegado al eje del disco que
la velocidad angular, porque ahí la inercia pesa el doble.

#paso(3, [la derivada, en la terna de la horquilla (inciso 2)])
Con el teorema del transporte y $bold(Omega) = omega_2 hat(j)$:
$ dot(bold(H))_G = underbrace(((dif bold(H)_G)/(dif t))_(G x y z), = 0) + bold(Omega) times bold(H)_G $
La derivada relativa es cero porque en $G x y z$ los componentes de
$bold(H)_G$ no cambian: $omega_1$ y $omega_2$ son constantes, y los momentos de
inercia tampoco cambian aunque la terna no gire con el disco, porque el disco
es redondo alrededor de $z$. Queda sólo el transporte:
$ dot(bold(H))_G = omega_2 hat(j) times 1/4 m r^2 (omega_2 hat(j) + 2 omega_1 hat(k)) = 1/2 m r^2 omega_1 omega_2 (hat(j) times hat(k)) = 1/2 m r^2 omega_1 omega_2 hat(i) $
La parte $omega_2 hat(j)$ de $bold(H)_G$ es paralela a $bold(Omega)$ y no
aporta: sólo la parte del spin, $1/2 m r^2 omega_1 hat(k)$, gira con la
horquilla. Es el mismo mecanismo de la precesión giroscópica.

#figura("cr2-disco.svg", 100%)[*(a)* $bold(omega)$ y $bold(H)_G$ en el plano de la horquilla: no son paralelos. Con $hat(k)$ a la derecha y $hat(j)$ hacia arriba, $hat(i) = hat(j) times hat(k)$ entra en la hoja, y ahí apunta $dot(bold(H))_G$. *(b)* El mismo $bold(H)_G$ visto desde afuera: una componente vertical fija y una horizontal que gira con la horquilla, así que barre un cono alrededor de $Y$, y $dot(bold(H))_G$ es tangente al cono. Es un cuadro de `anim_inercial.gif`.]

#paso(4, [la misma derivada, en la terna del disco (la parte «opcional» de Aníbal)])
Con $phi.alt = omega_1 t$ el ángulo girado por el disco, $hat(j) = sin phi.alt
hat(i)'' + cos phi.alt hat(j)''$, así que
$ bold(H)_G = 1/4 m r^2 (omega_2 sin phi.alt hat(i)'' + omega_2 cos phi.alt hat(j)'' + 2 omega_1 hat(k)'') $
Ahora los componentes dependen de $phi.alt$ y la derivada relativa *no* se
anula: vale $1/4 m r^2 omega_1 omega_2 (cos phi.alt hat(i)'' - sin phi.alt
hat(j)'')$. El término de transporte, con $bold(Omega) = bold(omega)$, da
exactamente lo mismo, y sumando
$ dot(bold(H))_G = 1/2 m r^2 omega_1 omega_2 (cos phi.alt hat(i)'' - sin phi.alt hat(j)'') = 1/2 m r^2 omega_1 omega_2 hat(i) $
porque $cos phi.alt hat(i)'' - sin phi.alt hat(j)''$ es justamente el $hat(i)$ de
la horquilla. Mismo resultado, más cuentas: elegir la terna de la horquilla
no es un truco, es no pagar senos y cosenos que se cancelan al final.

#block(breakable: false, caja([Las tres miradas (la tabla de Aníbal, con las tres animaciones)], c-azul)[
  #set par(justify: false)
  #table(
    columns: (0.9fr, 1.6fr, 1.5fr, 1.5fr),
    inset: (x: 5pt, y: 4pt),
    table.header(..([Observador], [Qué hace $bold(H)_G$], [Derivada relativa], [Transporte]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t])),
    ..(
      ([Horquilla], [queda *quieto*], [$0$], [$omega_2 hat(j) times bold(H)_G$: todo]),
      ([Disco], [cono alrededor del eje del disco, $tan alpha = omega_2\/(2 omega_1)$, girando con $-omega_1$], [$-omega_1 hat(k)'' times bold(H)_G$: la mitad], [$bold(omega) times bold(H)_G$: la otra mitad]),
      ([Inercial], [cono alrededor de la vertical, $tan beta = 2 omega_1\/omega_2$, girando con $+omega_2$], [es la derivada entera], [$0$]),
    ).flatten().map(c => text(size: 8.5pt, c)),
  )
  En los tres casos la suma da $1/2 m r^2 omega_1 omega_2 hat(i)$. Cada
  observador ve una película distinta de $bold(H)_G$ y el teorema del
  transporte es el traductor. El que va montado en el disco ve pasar la
  horquilla —y con ella a $bold(H)_G$— para el lado contrario al spin: por eso
  su cono gira con $-omega_1$.
])

#paso(5, [qué significa, y con números])
Como $sum bold(M)_G = dot(bold(H))_G$, el resultado es *la cupla que la
horquilla le hace al disco* a través del eje: horizontal y perpendicular al
eje del disco, $hat(i)$. Se manifiesta como un par de fuerzas verticales de los
dos brazos de la horquilla sobre el eje, una para arriba y otra para abajo.
Para ponerle números (los números son *nuestros*, no del enunciado): un disco
de 2 kg y 10 cm de radio, girando a 100 rad/s, en una horquilla que da 2 rad/s,
necesita $1/2 (2)(0,1)^2 (100)(2) = 2,00$ N·m. Con los dos brazos a 5 cm uno
del otro, cada uno empuja $40$ N, el doble del peso del disco: un giróscopo
que precesa le pide a su soporte bastante más de lo que uno calcularía con la
balanza.

#trampa[
  Usar en el transporte la velocidad angular del *disco* con los ejes de la
  *horquilla*: $bold(omega) times bold(H)_G$ con la derivada relativa en cero
  suma un término de más, $omega_1 hat(k) times 1/4 m r^2 omega_2 hat(j) = -1/4
  m r^2 omega_1 omega_2 hat(i)$, y el resultado sale *la mitad*. En el
  transporte va la $bold(Omega)$ *de la terna desde la que se deriva*, siempre;
  con la terna del disco la derivada relativa deja de ser cero y repone esa
  mitad (paso 4).
]

#final[$bold(H)_G = 1/4 m r^2 (omega_2 hat(j) + 2 omega_1 hat(k))$, no paralelo a $bold(omega) = omega_2 hat(j) + omega_1 hat(k)$; $dot(bold(H))_G = 1/2 m r^2 omega_1 omega_2 hat(i)$, horizontal y perpendicular al eje del disco: es la cupla que la horquilla le hace al disco.]

= Problema 3 — el volante en el _gimbal_

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía de la cátedra 2026, sección Cuerpo rígido, Problema 3 (figura de un libro en inglés, no identificado). Aníbal no subió resolución de éste. Material de apoyo: Sevilla, diap. 10 (efecto de una rueda en la dinámica rotacional) y 14 (satélites ágiles con CMG). Libro: Beer §18.5 y §18.6.]
  #image("recortes/cr-3-1.pdf", width: 100%)
]

#nota[«Kg/m²» es una errata: los momentos de inercia van en kg·m². Y los ejes $x y z$ están *clavados al gimbal*, lo dice la figura: no al volante ni a la plataforma.]

#idea[
  El volante gira rápido, así que tiene un $bold(H)$ enorme sobre $z$: $I_z
  omega_s = 1000$ kg·m²/s. La plataforma lo obliga a dar vueltas alrededor de
  $y$, y hacer girar un vector enorme cuesta: hace falta una cupla $bold(Omega)
  times bold(H)$ *sólo para eso*, aunque nada acelere. Cuando el torquer aplica
  600 N·m sobre $x$, una parte se va en ese peaje y sólo lo que sobra acelera al
  _gimbal_. Es el «no reacciona intuitivamente» de la diapositiva 5 de
  Sevilla: un cuerpo que gira, sometido a un momento, no hace lo que uno
  espera.
]

#supuestos(
  ([_Gimbal_ sin masa], [Lo dice el enunciado. Toda la inercia es la del volante.], [dato]),
  ([$omega_s$ constante respecto del _gimbal_], [«Gira a velocidad angular constante»: un motor lo sostiene. En el instante inicial no hace falta cupla sobre $z$ (se ve abajo).], [dato]),
  ([$omega_p$ constante], [La plataforma la impone un motor: cualquier cupla sobre $y$ la pone ella.], [dato]),
  ([Se pide el instante inicial], [«Inicialmente quieto respecto a la plataforma»: $Omega_x = 0$, pero su *derivada* no. Más tarde $Omega_x != 0$ y las cuentas cambian.], [define el problema]),
  ([El centro del volante, fijo], [Ahí se cruzan los dos ejes de giro; se toman momentos respecto de ese punto $O$.], [exacto]),
  ([Ejes del _gimbal_ principales del volante], [El volante es de revolución sobre $z$: cualquier par de ejes transversales es principal, gire o no con él.], [exacto]),
)

#paso(1, [las dos velocidades angulares, que no son la misma])
La terna del _gimbal_ gira con la plataforma y, cuando actúa el torquer,
empieza a girar respecto de ella sobre $x$; el volante, además, gira sobre $z$:
$ bold(Omega) = Omega_x hat(i) + omega_p hat(j), quad quad bold(omega) = Omega_x hat(i) + omega_p hat(j) + omega_s hat(k) $
con $Omega_x = 0$ al principio. Lo que se busca es $dot(Omega)_x$.

#paso(2, [el momento angular])
$ bold(H)_O = I_x Omega_x hat(i) + I_y omega_p hat(j) + I_z omega_s hat(k) = 5 Omega_x hat(i) + 2,5 hat(j) + 1000 hat(k) " kg·m²/s" $

#paso(3, [la ecuación de momentos, componente $x$])
Teorema del transporte con la $bold(Omega)$ del _gimbal_; la componente $x$ de
$bold(Omega) times bold(H)$ es $Omega_y H_z - Omega_z H_y$:
$ M_x = I_x dot(Omega)_x + (Omega_y H_z - Omega_z H_y) = 5 dot(Omega)_x + (0,5)(1000) - 0 $
$ 600 = 5 dot(Omega)_x + 500 quad ==> quad dot(Omega)_x = 20 " rad/s²" $
Las otras dos componentes, en el instante inicial: $M_y = Omega_z H_x - Omega_x
H_z = 0$ y $M_z = Omega_x H_y - Omega_y H_x = 0$. Al arrancar sólo trabaja el
torquer; apenas el _gimbal_ empieza a girar ($Omega_x != 0$), la plataforma
tiene que poner $M_y = -Omega_x H_z$.

#figura("cr3-gimbal.svg", 100%)[*(a)* Los vectores del instante inicial: $bold(H)$ enorme sobre $z$, $bold(Omega)$ sobre $y$, y $bold(Omega) times bold(H)$ sobre $x$, justo donde actúa el torquer. *(b)* Dónde se van los 600 N·m: 500 en hacer girar $bold(H)$ con la plataforma, 100 en acelerar al _gimbal_.]

#trampa[
  *Dividir cupla por inercia:* $600\/5 = 120$ rad/s² ignora el término
  giroscópico y da seis veces de más. Y el error de planteo que lo produce
  casi siempre es meter el spin adentro de $bold(Omega)$: la terna es la del
  _gimbal_, que *no* gira con $omega_s$.
]

#caja([Ejemplos: el mismo volante, cambiando una cosa por vez], c-verde)[
  La fórmula es $dot(Omega)_x = (M_x - omega_p I_z omega_s)\/I_x$, y cada
  ejemplo cambia un número para ver qué hace el término giroscópico.

  - *Sin plataforma* ($omega_p = 0$), o *con el volante quieto* ($omega_s = 0$):
    no hay nada que transportar y $dot(Omega)_x = 600\/5 = 120$ rad/s². Es la
    rotación de Física 1, y la respuesta que el problema está esperando que
    alguien dé para poder corregirla.
  - *¿Qué cupla deja quieto al _gimbal_?* $M_x = omega_p I_z omega_s = 500$
    N·m: la *cupla giroscópica*. Es lo que el soporte siente cuando la
    plataforma gira con el volante adentro, la misma cupla del Problema 2.
  - *Volante a 120 rad/s:* $omega_p I_z omega_s = 600$ N·m, se lleva toda la
    cupla y el _gimbal_ *no se mueve*, aunque le estén aplicando 600 N·m.
  - *Volante a 200 rad/s:* $dot(Omega)_x = -80$ rad/s²: el _gimbal_ acelera
    *para el lado contrario* al torque aplicado. Lo que hace falta para
    acompañar a la plataforma es más de lo que se le da, y la diferencia la
    paga el _gimbal_.
]

#figura("cr3-barrido.svg", 74%)[La aceleración angular del _gimbal_ en función de la velocidad del volante, con el resto de los datos del problema: una recta que arranca en 120 (sin giróscopo), pasa por 20 (el problema) y se hace cero en $omega_s = 120$ rad/s.]

#caja([La lectura al revés: así giran los satélites ágiles], c-libro)[
  Las diapositivas de Sevilla (10 y 14) cuentan la otra cara de este
  problema. Un volante de $bold(H)$ grande y velocidad fija al que un motor le
  *gira el eje* —un CMG, _control moment gyroscope_— produce sobre lo que lo
  sostiene una cupla $bold(Omega) times bold(H)$: con este volante, girar el
  _gimbal_ a $0,5$ rad/s da 500 N·m, con un motorcito que sólo tiene que mover
  el eje. Así maniobran rápido los satélites ágiles de observación (los
  Pléiades, en la diapositiva 14), y por eso las diapositivas lo llaman «el
  ejemplo más extremo» de usar una rueda. El Problema 3, leído desde el satélite, es un CMG.
]

#final[$dot(Omega)_x = 20$ rad/s² en el instante inicial: de los 600 N·m, 500 se van en hacer girar el $bold(H) = 1000 hat(k)$ kg·m²/s con la plataforma y sólo 100 aceleran al _gimbal_.]

= Problema 4 — el _spacecraft_ que precesa

#consigna[
  #heading(level: 2)[Enunciado]
  #origen[Guía de la cátedra 2026, sección Cuerpo rígido, Problema 4. No está en el Beer del disco; como el Problema 5 de la guía es el «M 7.99», es probable que salga del Meriam (hipótesis, sin confirmar). Material de apoyo: Sevilla, diap. 5 a 9. Libro: Beer §18.9 (ángulos de Euler) y §18.11 (cuerpo simétrico sin cuplas).]
  #image("recortes/cr-4-1.pdf", width: 100%)
]

#nota[«impulso angular ($bold(H)_G$)» es el momento angular. Y «velocidad angular de spin» se lee como $dot(psi)$, la del Beer con ángulos de Euler (la rotación del cuerpo *respecto de la terna que precesa*), no como la componente de $bold(omega)$ sobre $z$. Con la otra lectura la respuesta cambia; está al final.]

#idea[
  Nada toca al satélite, así que $bold(H)_G$ queda fijo en el espacio: es el
  único «eje del mundo» que tiene. Si el satélite no gira exactamente sobre un
  eje principal, su eje de simetría $z$ da vueltas alrededor de $bold(H)_G$
  —la *precesión libre*, «la solución más simple de las ecuaciones de Euler»,
  dice la diapositiva 5 de Sevilla— sin que nadie la sostenga. Lo que hay que
  saber es con qué rapidez y para qué lado, y eso lo decide una sola cosa: si
  el cuerpo es achatado o alargado.
]

#supuestos(
  ([Sin torques externos], [Gradiente de gravedad, arrastre y radiación, despreciados. En un satélite no isótropo el gradiente de gravedad *no* es cero (Sevilla, diap. 12), pero sobre una vuelta de precesión de 2 s no llega a hacer nada.], [despreciable]),
  ([Simétrico alrededor de $z$], [Lo dice el enunciado: los dos radios de giro transversales son iguales.], [dato]),
  ([Rígido, sin disipación], [Sin combustible que chapotee ni antenas que vibren. Con disipación el ángulo de 2° no se mantendría: ver la regla del eje mayor, abajo.], [define el problema]),
  ([Los momentos salen de los radios de giro], [$I = m k^2$: la masa no hace falta, porque sólo entra el cociente.], [exacto]),
)

#paso(1, [el cociente de inercias])
Con $I_z = m k_z^2$ (axial) e $I_perp = m k^2$ (transversal):
$ I_z/I_perp = (720/540)^2 = 16/9 > 1 $
El momento axial es el mayor: el satélite es *achatado* respecto de su eje, y
gira sobre su *eje mayor de inercia*.

#paso(2, [la relación entre spin y precesión])
Ángulos de Euler (Beer §18.9): $dot(phi)$ es la precesión alrededor de
$bold(H)_G$ (el eje fijo), $dot(psi)$ el spin alrededor de $z$, y $theta = 2°$ el
ángulo entre los dos. La velocidad angular es $bold(omega) = dot(phi) hat(K) +
dot(psi) hat(k)$; sus componentes transversal y axial son $dot(phi) sin theta$ y
$dot(phi) cos theta + dot(psi)$. Que $bold(H)_G$ esté sobre $hat(K)$ obliga a que
el cociente de las componentes de $bold(H)_G$ sea $tan theta$:
$ (I_perp dot(phi) sin theta)/(I_z (dot(phi) cos theta + dot(psi))) = (sin theta)/(cos theta) quad ==> quad dot(psi) = (I_perp - I_z)/I_z dot(phi) cos theta $
(Beer §18.11, pág. 1190–1191.) Y la componente transversal da además
$dot(phi) = H\/I_perp$, positiva: la precesión gira siempre en el sentido de
$bold(H)_G$.

#paso(3, [el período de precesión])
Con $(I_perp - I_z)\/I_z = 9\/16 - 1 = -7\/16$:
$ dot(phi) = (dot(psi))/((I_perp - I_z)/I_z cos theta) = (1,5)/((-7/16)(cos 2°)) quad ==> quad abs(dot(phi)) = 3,431 " rad/s" $
$ T = (2 pi)/abs(dot(phi)) = 1,832 " s" $
Los 2° casi no pesan ($cos 2° = 0,9994$): lo que manda es el cociente de
inercias.

#paso(4, [el sentido del spin])
$dot(phi) > 0$ y $(I_perp - I_z)\/I_z < 0$, así que $dot(psi) < 0$: *el vector
del spin apunta hacia $-z$*. Spin y precesión giran para lados opuestos, que
es la *precesión retrógrada* de los cuerpos achatados (Beer fig. 18.24, pág.
1191: «la precesión y el giro tienen sentidos opuestos»).

#trampa[
  *Que $dot(psi)$ sea negativo no quiere decir que el satélite gire «para
  atrás».* La componente de $bold(omega)$ sobre $z$ es $dot(phi) cos theta +
  dot(psi) = 3,429 - 1,5 = 1,929$ rad/s, positiva: el cuerpo gira hacia
  adelante sobre su eje. Lo negativo es el giro *respecto de la terna que
  precesa*, que va más rápido que él. Por eso la pregunta tiene trampa, y por
  eso hay que decir qué se entiende por «spin» antes de contestarla.
]

#figura("cr4-conos.svg", 96%)[Los conos de Beer §15.12 (ángulos exagerados). *(a)* Este satélite: $bold(H)_G$ queda entre $z$ y $bold(omega)$ ($bold(omega)$ está a $3,55$° de $z$), y el cono espacial queda *adentro* del corporal: retrógrada. *(b)* El mismo satélite con los radios de giro al revés: alargado, conos que se tocan por afuera, precesión directa.]

#caja([Para qué sirve saberlo: la regla del eje mayor (Sevilla, diap. 6 a 9)], c-libro)[
  Un cuerpo rígido que gira sobre su eje mayor o su eje menor de inercia es
  estable, y sobre el intermedio no (es el «ladrillo» del apunte). Pero con
  disipación de energía —que en un satélite real siempre hay— *sólo el eje
  mayor* es estable: el giro sobre el eje menor termina pasando al mayor. El
  Sputnik giraba sobre su eje mayor; el Explorer 1, alargado y con antenas
  flexibles, sobre el menor, y en unas horas estaba dando tumbos. El satélite
  del Problema 4 gira sobre su eje mayor ($I_z > I_perp$): está del lado
  bueno, y la disipación, en vez de agrandarle el cono de 2°, se lo cerraría.
  Si fuera alargado —los radios al revés— precesaría en forma directa, con
  $dot(phi) = 1,930$ rad/s y un período de $3,256$ s, y sería un Explorer 1
  esperando su turno.
]

#caja([Con la otra lectura de «spin»], c-ambar)[
  Si los $1,5$ rad/s fueran la componente total de $bold(omega)$ sobre $z$, de
  $omega_z = (I_perp\/I_z) dot(phi) cos theta$ sale $dot(phi) = 2,668$ rad/s y
  un período de $2,355$ s. Se resuelve con la lectura del Beer porque la
  figura y la pregunta por el sentido del spin son las de su §18.11, pero en un
  examen conviene escribir cuál se usó.
]

#final[$abs(dot(phi)) = 3,431$ rad/s, período de precesión $1,832$ s; el spin apunta hacia $-z$: el satélite es achatado ($I_z\/I_perp = 16\/9$) y la precesión es retrógrada.]

= Lo que se llevan los cuatro

+ *Derivar en la terna que conviene*, y en el transporte poner la $bold(Omega)$
  *de esa terna*: la horquilla en el 2, el _gimbal_ en el 3.
+ *$bold(H)_G$ es paralelo a $bold(omega)$ sólo en casos especiales*: un cuerpo
  isótropo (el cubo del 1) o un giro sobre un eje principal. En todos los
  demás, $bold(omega)$ precesa (el 4) o hace falta una cupla para que no lo
  haga (el 2 y el 3).
+ *Un torque perpendicular a un $bold(H)$ grande le cambia la dirección, no el
  módulo*: es la analogía giróscopo ↔ órbita que pide Aníbal, y en el 3 se ve
  en números: la mayor parte de la cupla se va en girar $bold(H)$.
+ *Cada supuesto se dice y, si se puede, se mide*: el $0,027$ % de masa del 1,
  el $1,4$ % del empuje que gira, el $0,33$ % del espesor del disco. Un supuesto
  sin número es una esperanza.
