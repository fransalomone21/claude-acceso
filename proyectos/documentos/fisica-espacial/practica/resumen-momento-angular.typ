// =====================================================================
//  Resumen para el parcialito de momento angular -- 2026-10-14
//  La «Lista de temas Impulso angular (3)» (identica a la (1) y la (2)),
//  renglon por renglon: la idea, la formula y la trampa. Sale del modulo
//  `rotacion` del apunte (m17) y de `momento-angular` (m08); los criterios
//  de evaluacion, de catedras/fisica-espacial/CRITERIOS.md (ANI-20 a 52).
// =====================================================================
#import "estilo.typ": *
#import "figuras-parcial.typ" as fp

#show: documento.with(
  titulo: [Resumen — momento angular],
  subtitulo: [La lista de temas de impulso angular, renglón por renglón: la idea, la fórmula y la trampa],
  encabezado: [Resumen — momento angular],
)

#let posta(cuerpo) = caja([La posta], c-rosa, cuerpo)
#let tabla(cols, ..celdas) = {
  set par(justify: false)
  align(center, table(columns: cols, inset: (x: 6pt, y: 3.5pt), align: left,
    ..celdas.pos().map(c => text(size: 9.5pt, c))))
}

#caja([Cómo usar esto], c-azul)[
  Un tema por sección, en el orden de la lista (Sears vol. 1, caps. 9 y 10).
  Cada uno con *la idea* en palabras, *la fórmula* y *la trampa*. El
  desarrollo entero está en el apunte, módulo «Rotación alrededor de un eje
  fijo»; acá va lo que tenés que tener en la cabeza al entrar.

  *El parcialito es conceptual* (los tres anteriores no trajeron un solo
  número para operar): se corrige la cadena de razonamiento, y donde pide un
  dibujo, *el dibujo es la respuesta* — dirección, sentido y rótulos, no la
  escala.
]

#notacion[
  $bold(L)$ es el *momento angular*. La cátedra le dice *impulso angular*
  (y el Beer lo llama $bold(H)$): en el examen reconocé las tres. El impulso
  angular «de verdad» es $integral bold(tau) dif t = Delta bold(L)$, lo que
  un torque le cambia a $bold(L)$ en un rato — igual que $bold(F) Delta t =
  Delta bold(p)$. Y cuando el Sears dice *«razón de cambio»*, es *derivada
  respecto del tiempo*.
]

= 1. Velocidad angular: un número y un vector
#origen[S&Z §9.1, Fig. 9.9, ecs. 9.13 y 9.15 · Roederer pág. 58 h)]

*La idea.* En un rígido todos los puntos barren el *mismo ángulo* en el
mismo tiempo: un solo $omega$ para todo el cuerpo, pero cada punto con su
propia $v$. La cátedra pide tener clara *la parte escalar y la vectorial*:

- *Escalar:* $omega_z = d theta \/ d t$, con $theta$ en *radianes* y con
  signo (positivo si gira antihorario visto desde la punta de $z$).
- *Vectorial:* $bold(omega)$ va *sobre el eje*, con sentido por la *mano
  derecha*: los dedos acompañan el giro, el pulgar es $bold(omega)$.

$ v = r omega, quad a_"tan" = r alpha, quad a_"rad" = omega^2 r, quad quad bold(v) = bold(omega) times bold(r) $

con $r$ la distancia *al eje*. Versión Roederer, sin cuerpo rígido: para un
móvil visto desde $O$, $bold(omega) = bold(r) times bold(v) \/ r^2$ — la
velocidad angular *depende de desde dónde se mira*.

#trampa[
  Con el eje fijo el vector parece un lujo ($bold(omega) = omega_z
  hat(bold(k))$). Cuando el eje se mueve —el giróscopo— el único que sabe
  hacia dónde apunta la rotación es el vector. Y grados en vez de radianes
  es un error de $times 57,3$.
]

= 2. Energía de rotación: de ahí sale el momento de inercia
#origen[S&Z §9.4, ecs. 9.16 y 9.17, Tabla 9.2]

*La idea* (literal de la cátedra): «el momento de inercia aparece al escribir
la energía cinética de rotación». Nadie lo define porque sí: sumás la energía
de cada pedacito, cada uno con $v_i = r_i omega$ y *el mismo* $omega$, y lo
que queda adentro de la suma es cómo está repartida la masa respecto del eje.

$ K = sum_i 1/2 m_i (r_i omega)^2 = 1/2 underbrace((sum_i m_i r_i^2), I) omega^2 quad arrow.r.double quad I = sum_i m_i r_i^2, quad K = 1/2 I omega^2 $

$I$ es la «masa» de la rotación, con una diferencia que la masa no tiene:
*depende del eje*. La masa lejos del eje pesa $r^2$.

*Tabla 9.2: no se memoriza, se sabe buscar* (palabra de la cátedra). Las que
más aparecen:

#tabla((auto, auto, auto, auto),
  [varilla, por el centro], [$1/12 M L^2$], [aro / cilindro hueco], [$M R^2$],
  [varilla, por un extremo], [$1/3 M L^2$], [disco / cilindro macizo], [$1/2 M R^2$],
  [esfera maciza], [$2/5 M R^2$], [esfera hueca], [$2/3 M R^2$],
)

#trampa[
  $r_i$ es la distancia *al eje*, no al origen: con el eje en $z$, es
  $sqrt(x^2 + y^2)$. Y no se calculan momentos de inercia con integrales:
  «no es la idea», se va a la tabla.
]

= 3. Teorema de Steiner (ejes paralelos)
#origen[S&Z §9.5, ec. 9.19, y el resumen del capítulo]

*La idea.* La tabla da el $I$ por el centro de masa; Steiner da el de
*cualquier eje paralelo* sin volver a integrar:

$ I_P = I_"cm" + M d^2 $

con $d$ la distancia entre los dos ejes. Lo que tenés que saber decir: el eje
por el cm es el de *menor* $I$ de todos los paralelos (los términos cruzados
se anulan justo porque el origen es el cm). Control: varilla por la punta,
$1/12 M L^2 + M (L\/2)^2 = 1/3 M L^2$. Coincide con la tabla.

= 4. Torque (torca, cupla)
#origen[S&Z §10.1, ec. 10.3, Fig. 10.4 — «regla de mano derecha, muy importante!!»]

*La idea.* Lo que hace girar no es la fuerza: es la fuerza *por su distancia
al eje*. La puerta no se abre empujando al lado de las bisagras.

$ bold(tau) = bold(r) times bold(F), quad quad tau = r F sin phi = F l $

con $l = r sin phi$ el *brazo de palanca* (distancia de $O$ a la recta de
acción). Torque *cero* si la fuerza está aplicada en $O$ o apunta hacia $O$.

*Mano derecha:* dedos a lo largo de $bold(r)$, se cierran hacia $bold(F)$,
el pulgar da $bold(tau)$ — perpendicular al plano de $bold(r)$ y $bold(F)$,
sobre el eje alrededor del cual la fuerza quiere hacer girar.

#trampa[
  El torque depende del punto $O$ respecto del cual se toma. Decí siempre
  «respecto de qué punto». Y $bold(r) times bold(F) = - bold(F) times
  bold(r)$: el orden importa.
]

= 5. Rotación de un cuerpo rígido: $tau = I alpha$ y las analogías
#origen[S&Z §10.2–10.3, Figs. 10.11 y 10.12, ecs. 10.8, 10.12 y 10.13]

*La idea.* Cada pedacito cumple Newton; sumando con el peso $r_i^2$ sale la
misma ley en versión rotación (los torques internos se cancelan de a pares:
el cuerpo no se hace girar solo tirándose de los pelos):

$ sum tau_z = I alpha_z $

*La analogía que la cátedra pide observar* — la idea más rentable del tema:

#tabla((auto, auto, auto),
  [], [*Traslación*], [*Rotación (eje fijo)*],
  [lo que acelera], [fuerza $F$], [torque $tau$],
  [la inercia], [masa $m$], [momento de inercia $I$],
  [la aceleración], [$a$], [$alpha$],
  [la ley], [$F = m a$], [$tau = I alpha$],
  [cantidad de movimiento], [$p = m v$], [$L = I omega$],
  [energía cinética], [$1/2 m v^2$], [$1/2 I omega^2$],
)

*Si además se traslada* (rueda, yo-yo, cilindro en un plano):

$ K = 1/2 M v_"cm"^2 + 1/2 I_"cm" omega^2, quad sum bold(F)_"ext" = M bold(a)_"cm", quad sum tau_"cm" = I_"cm" alpha $

y si rueda *sin deslizar*, $v_"cm" = R omega$ (el punto de contacto está
quieto en ese instante; el de arriba va a $2 v_"cm"$).

= 6. Momento angular («impulso angular» para la cátedra)
#origen[S&Z §10.5, ecs. 10.28 y 10.29]

*La idea.* De una partícula, $bold(L) = bold(r) times m bold(v)$ (respecto
de un punto). De un cuerpo que gira, sumás todas y vuelve a aparecer $I$:

$ L = I omega quad "(S&Z 10.28)" quad quad quad sum bold(tau)_"ext" = (d bold(L))/(d t) quad "(S&Z 10.29)" $

#trampa[
  *«Ojo con esa ecuación, no es la más general»* (la cátedra, sobre la
  10.28). $bold(L) = I bold(omega)$ vale si el cuerpo gira alrededor de un
  *eje de simetría* (un eje principal). Para un cuerpo asimétrico,
  $bold(L)$ y $bold(omega)$ *no son paralelos*: la rueda mal balanceada
  vibra por eso. La que *sí* es general es la 10.29, $bold(tau) = d bold(L)
  \/ d t$: vale para cualquier cuerpo, rígido o no. $tau = I alpha$ es un
  caso particular de ella (eje fijo, $I$ constante).
]

= 7. Conservación del momento angular
#origen[S&Z §10.6, ec. 10.30 · Roederer pág. 120 e)]

*La idea.* Si el torque *externo* es cero, $bold(L)$ no cambia — en módulo
*y en dirección*. Un cuerpo que cambia de forma sólo puede repartirlo
distinto:

$ I_1 omega_1 = I_2 omega_2 $

Juntás la masa, girás más rápido (patinadora, clavadista hecho bolita, el
profesor del Sears con las mancuernas: $I$ baja de 13 a 2,6 kg·m² y $omega$
sube cinco veces).

#trampa[
  *Se conserva $L$, no la energía.* Con $L$ fijo, $K = L^2 \/ (2 I)$: si $I$
  baja cinco veces, $K$ se *quintuplica*. La energía extra la pone el que
  tira de las mancuernas hacia adentro. Es el distractor clásico de opción
  múltiple.
]

*Las dos aplicaciones que más se preguntan:*

- *Fuerza central* (gravedad): el torque respecto del centro es cero, así
  que el $bold(L)$ del satélite es constante → la órbita es plana y barre
  *áreas iguales en tiempos iguales*: $d A \/ d t = L \/ (2 m) = h\/2$. La
  2.ª ley de Kepler es esto mismo, y no hace falta que la fuerza sea $1\/r^2$:
  alcanza con que sea central.
- *La banqueta con la rueda:* alguien sentado en una banqueta giratoria, con
  una rueda girando con $bold(L)$ hacia arriba. Da vuelta la rueda ($-bold(L)$):
  como nada de afuera tuerce el sistema, la persona con la banqueta tiene que
  quedar con $+2 bold(L)$ y empieza a girar *en el sentido en que giraba la
  rueda*.

= 8. Giróscopos y precesión
#origen[S&Z §10.7, Figs. 10.32 a 10.34 — «primera aproximación, se ve más adelante en CR» · Kleppner §8.3–8.4 · Meriam 7/11]

*La idea, en dos casos con la misma ecuación* $d bold(L) = bold(tau) thin d t$:

- *Rueda quieta:* $bold(L)$ arranca en cero y crece en la dirección del
  torque → el eje cae. Péndulo.
- *Rueda girando rápido:* ya hay un $bold(L)$ grande sobre el eje, y el
  $d bold(L)$ que pone el torque del peso es *perpendicular* a $bold(L)$.
  Un cambio perpendicular le cambia la *dirección* y no el *módulo*: el eje
  no cae, *gira en el plano horizontal*. Eso es la precesión.

#grid(columns: (1fr, 1.05fr), gutter: 12pt,
  align(center + horizon, fp.fig-giroscopo-p(respuesta: true, rot-d: [$r$])),
  [
    $ Omega = tau / L = (M g r) / (I omega) $
    $ bold(tau) = bold(Omega) times bold(L) $
    *El sentido, sin adivinar* (Meriam): *la punta de $bold(L)$ persigue al
    torque*. Dibujá $bold(L)$, dibujá $bold(tau) = bold(r) times M bold(g)$
    (horizontal, perpendicular al eje) y mové la punta de $bold(L)$ hacia
    $bold(tau)$: ése es el giro del eje.
  ],
)

*Lo que la fórmula dice, para las predicciones sin datos:*

- *Más rápido gira la rueda, más lento precesa.* Si la fricción la frena, la
  precesión *se acelera* (el trompo al final).
- *La masa se cancela:* $M$ está en el torque y en $I$. Duplicás la masa del
  volante y $Omega$ no se entera.
- *No depende de la inclinación del eje:* el $sin phi$ aparece en el torque
  y en el $d bold(L)$, y se va (Kleppner Ej. 8.7).
- *Es una aproximación:* vale si $Omega lt.double omega$ (*precesión lenta*).
  El caso exacto es el de cuerpo rígido.
- *El pivote hace dos cosas:* la vertical es el peso (el cm no sube ni baja);
  la horizontal es la centrípeta $M Omega^2 r$, porque el cm da vueltas.

#trampa[
  *La pregunta correcta no es «por qué no se cae»* — eso es trivial: el
  pivote empuja hacia arriba con el peso. Es *por qué no oscila como un
  péndulo*, si el peso hace torque. Y la respuesta es la de arriba: con
  $bold(L)$ grande, el torque *dobla* a $bold(L)$, no lo hace crecer hacia
  abajo.
]

*La analogía con la órbita* (la pidió Aníbal explícitamente):

#tabla((auto, auto, auto),
  [], [*Satélite en órbita circular*], [*Giróscopo que precesa*],
  [se conserva en módulo], [la rapidez, $|bold(p)|$], [el giro, $|bold(L)|$],
  [lo empuja], [la gravedad $bold(F)$], [el torque del peso $bold(tau)$],
  [la geometría], [$bold(F) perp bold(p)$], [$bold(tau) perp bold(L)$],
  [lo que pasa], [$bold(p)$ gira: la órbita], [$bold(L)$ gira: la precesión],
  [velocidad angular], [$omega = F\/p = v\/r$], [$Omega = tau\/L$],
)

Por grande que sea la fuerza, si es perpendicular a la velocidad *sólo le
cambia la dirección*; por grande que sea el torque, si es perpendicular a
$bold(L)$, sólo le cambia la dirección al eje. El prejuicio que hay que matar
es el mismo en los dos: una fuerza no lleva las cosas hacia donde empuja, les
cambia la cantidad de movimiento *en esa dirección*.

*Actuador y sensor — la misma ecuación leída para los dos lados:*

- *Torque entra, giro sale* ($bold(tau) arrow.r bold(Omega)$): el peso tuerce
  y el giróscopo precesa. *Actuador*. En un satélite: el *CMG*, un rotor que
  gira siempre igual y al que un motor le gira el eje: da mucho torque con
  poca potencia.
- *Giro entra, torque sale* ($bold(Omega) arrow.r bold(tau)$): si le girás
  el eje a la fuerza, hace falta un torque $bold(Omega) times bold(L)$, y en
  las manos sentís la reacción. *Sensor*: el torque mide el giro (guiado
  inercial, girocompás). Es el *ventilador de Aníbal* y la *niña con la
  rueda*: girás el eje para un lado y te contesta *a 90°* — intentás subirlo
  y se te tuerce de costado.

*La Tierra también es un giróscopo:* achatada e inclinada 23,5°, el Sol y la
Luna tiran más fuerte del abultamiento más cercano → torque perpendicular a
$bold(L)$ → el eje precesa, una vuelta cada $~26 thin 000$ años (la
precesión de los equinoccios).

#posta[
  Todo el tema es una sola ecuación, $bold(tau) = d bold(L) \/ d t$, leída de
  tres maneras. Si $bold(tau) = 0$, $bold(L)$ se queda quieto (conservación:
  la patinadora, Kepler). Si $bold(tau) parallel bold(L)$, $bold(L)$ crece o
  se achica (la rueda que se frena, $tau = I alpha$). Si $bold(tau) perp
  bold(L)$, $bold(L)$ dobla sin cambiar de tamaño (el giróscopo, y la órbita
  con $bold(p)$). Mirá para dónde apunta el torque respecto de $bold(L)$ y ya
  sabés qué va a pasar antes de hacer una cuenta.
]

= Cómo pregunta Aníbal en un parcialito
#origen[Leído de los tres parcialitos anteriores (criterios inferidos, no dichos por él)]

- *Una cadena, no una cuenta:* preguntas cortas encadenadas («en base al
  punto anterior…»). Cada eslabón vale: no dejes uno en blanco porque te
  trabaste en el anterior.
- *El dibujo es la respuesta:* $bold(L)$, $bold(tau)$, $bold(Omega)$ con
  dirección, sentido y nombre. Mano derecha visible en el dibujo.
- *Opción múltiple con distractores de concepto:* «se conserva la energía»,
  «el giróscopo cae más lento», «$L = I omega$ siempre». La correcta suele
  ser la que el sentido común descarta.
- *Predicción sin datos* por proporcionalidad: ¿y si se duplica la masa?
  ($Omega$ igual) ¿y si gira el doble de rápido? ($Omega$ a la mitad) ¿y si
  junta los brazos? ($omega$ sube, $K$ sube).
- *Lo antiintuitivo desde una demostración de clase:* la rueda en las manos,
  el ventilador. Sostené la respuesta con $Delta bold(L) = bold(tau) Delta t$
  *dibujado*.
- *Las denominaciones:* impulso angular / momento angular / $bold(H)$;
  torca / torque / cupla. Y *dónde deja de valer* cada ecuación: $L = I
  omega$ sólo sobre un eje de simetría; la precesión, sólo si es lenta.

= Las fórmulas, juntas

#tabla((auto, auto),
  [velocidad angular], [$omega_z = d theta \/ d t, quad bold(v) = bold(omega) times bold(r), quad v = r omega, quad a_"tan" = r alpha, quad a_"rad" = omega^2 r$],
  [momento de inercia], [$I = sum m_i r_i^2, quad K = 1/2 I omega^2$],
  [Steiner], [$I_P = I_"cm" + M d^2$],
  [torque], [$bold(tau) = bold(r) times bold(F), quad tau = r F sin phi = F l$],
  [rotación], [$sum tau_z = I alpha_z$],
  [rodar], [$K = 1/2 M v_"cm"^2 + 1/2 I_"cm" omega^2, quad v_"cm" = R omega$],
  [momento angular], [$bold(L) = bold(r) times m bold(v), quad L = I omega$ (eje de simetría)],
  [ley general], [$sum bold(tau)_"ext" = d bold(L) \/ d t, quad integral bold(tau) dif t = Delta bold(L)$],
  [conservación], [$bold(tau)_"ext" = 0 arrow.r.double I_1 omega_1 = I_2 omega_2, quad K = L^2 \/ (2 I)$],
  [Kepler, 2.ª ley], [$d A \/ d t = L \/ (2 m) = "cte"$],
  [precesión], [$Omega = tau \/ L = M g r \/ (I omega), quad bold(tau) = bold(Omega) times bold(L), quad Omega lt.double omega$],
)
