// =====================================================================
//  hoja-formulas.typ -- la hoja de formulas de toda la materia
//
//  Una sola hoja (4 carillas) para tener al lado al resolver: por tema,
//  cada formula con lo que significa y las hipotesis bajo las que vale.
//  Las ecuaciones se copiaron de las ETIQUETADAS del apunte (el nombre de
//  la etiqueta va en gris al lado de cada una); las pocas sin etiqueta
//  salen del cuerpo del mismo modulo. Si el apunte cambia una formula,
//  esta hoja no se entera: se corrige a mano.
//    typst compile hoja-formulas.typ salida/hoja-formulas.pdf
// =====================================================================
#import "../apunte/biblioteca/paleta.typ": *

#set document(title: "Hoja de fórmulas — Física Espacial", author: "Apunte de Física Espacial — UNSAM")
#set page(
  paper: "a4",
  margin: (x: 1.3cm, top: 1.4cm, bottom: 1.3cm),
  columns: 2,
  footer: context {
    set text(size: 7.5pt, fill: luma(120))
    grid(columns: (1fr, auto),
      [Física Espacial — UNSAM 2026 · hoja de fórmulas],
      [#counter(page).display() / #counter(page).final().first()])
  },
)
#set columns(gutter: 14pt)
#set text(lang: "es", region: "ar", size: 8.6pt,
  font: ("Libertinus Serif", "Georgia", "Times New Roman"))
#set par(justify: false, leading: 0.5em, spacing: 0.6em)
#show math.equation: eq => {
  show ",": it => math.class("normal", it)
  eq
}

// --- piezas -----------------------------------------------------------
#let tema(n, titulo) = block(above: 9pt, below: 4pt, sticky: true, width: 100%,
  fill: c-azul, inset: (x: 6pt, y: 3.5pt), radius: 2pt,
)[#text(fill: white, weight: "bold", size: 9.5pt)[#n. #titulo]]

#let ctx(cuerpo) = block(above: 3pt, below: 5pt, width: 100%,
  fill: c-gris, inset: (x: 6pt, y: 4pt), radius: 2pt,
)[#text(size: 8pt)[#cuerpo]]

// f(nombre, ecuacion, hipotesis, etiqueta del apunte)
#let f(nombre, ec, hip, ..resto) = { let etq = resto.pos().at(0, default: none); block(above: 4pt, below: 4pt, breakable: false, width: 100%,
  stroke: (left: 1.5pt + c-azul.lighten(50%)), inset: (left: 6pt, y: 1pt),
)[
  #grid(columns: (1fr, auto),
    text(weight: "bold", fill: c-azul, size: 8.3pt)[#nombre],
    if etq != none { text(size: 6.5pt, fill: luma(150), font: "Consolas")[#etq] })
  #v(-2pt)
  #ec
  #v(-3pt)
  #text(size: 7.8pt, fill: luma(70))[_Vale si:_ #hip]
]}

#let ojo(cuerpo) = block(above: 3pt, below: 5pt, width: 100%,
  stroke: (left: 1.5pt + c-rojo), inset: (left: 6pt, y: 2pt),
)[#text(size: 7.8pt, fill: c-rojo, weight: "bold")[Ojo: ]#text(size: 7.8pt)[#cuerpo]]

// --- titulo -------------------------------------------------------------
#place(top, scope: "parent", float: true, block(width: 100%, below: 4pt)[
  #stack(spacing: 5pt,
    text(size: 8pt, fill: c-azul, weight: "bold", tracking: 1.2pt)[FÍSICA ESPACIAL · UNSAM · 2026],
    [#text(size: 18pt, fill: c-azul, weight: "bold")[Hoja de fórmulas] #h(6pt) #text(size: 9pt, fill: luma(80))[toda la materia, por tema, con las hipótesis de cada una]],
    line(length: 100%, stroke: 1.2pt + c-azul),
  )
  #text(size: 7.8pt, fill: luma(60))[
    Cada fórmula lleva debajo *cuándo vale*: muchos errores de parcial no son de
    cuenta, son de usar una fórmula fuera de sus hipótesis. En gris, a
    la derecha, el nombre de la ecuación en el apunte, para ir a buscar de dónde
    sale. Notación: $mu = G M$ (parámetro gravitatorio), $h = L\/m$ (momento
    angular por unidad de masa), $nu$ anomalía verdadera (ángulo desde el periapsis).
  ]
])

// =====================================================================
#tema(1)[Vectores, cinemática y marcos]
#ctx[La herramienta de todo lo que sigue: los versores polares *giran* con la
partícula, y eso hace aparecer términos que en cartesianas no existen.]

#f[Velocidad y aceleración en polares][
  $ bold(v) = dot(r) hat(r) + r dot(theta) hat(theta) $
  $ bold(a) = (dot.double(r) - r dot(theta)^2) hat(r) + (r dot.double(theta) + 2 dot(r) dot(theta)) hat(theta) $
][siempre (es cinemática pura, en el plano). $-r dot(theta)^2$ es la centrípeta; $2 dot(r) dot(theta)$, la de Coriolis.][vec-polares]
#ojo[$a_r != dot(v)_r$: la componente radial de la aceleración *no* es la derivada de la componente radial de la velocidad.]

#f[Marco que acelera en línea recta][
  $ m bold(a)' = bold(F) - m bold(A) $
][el marco se traslada (no gira) con aceleración $bold(A)$ respecto de uno inercial. $-m bold(A)$ es la fuerza de inercia.][marcos-inercia]

#f[Marco que gira][
  $ m bold(a)_"rel" = bold(F) - 2 m bold(Omega) times bold(v)_"rel" - m bold(Omega) times (bold(Omega) times bold(r)) $
][$bold(Omega)$ constante y origen común con el marco inercial. Si $bold(Omega)$ varía, se suma $-m dot(bold(Omega)) times bold(r)$ (ver 13).][marcos-rotante-f]

// =====================================================================
#tema(2)[Cantidad de movimiento, centro de masa, choques]
#ctx[Para *sistemas*: lo interno se cancela de a pares (3.ª ley) y sólo mueve el
centro de masa lo externo.]

#f[Segunda ley e impulso][
  $ sum bold(F) = (d bold(p))/(d t), quad quad bold(J) = integral_(t_1)^(t_2) sum bold(F) d t = Delta bold(p) = bold(F)_"med" Delta t $
][sistema cerrado (la masa no entra ni sale) y marco inercial.][cant-segunda-ley]

#f[Centro de masa y su teorema][
  $ bold(r)_"cm" = 1/M sum_i m_i bold(r)_i, quad quad bold(P) = M bold(v)_"cm", quad quad sum bold(F)_"ext" = M bold(a)_"cm" $
][siempre. Si $sum bold(F)_"ext" = 0$: $bold(P)$ se conserva y el CM va a velocidad constante.][cm-teorema]

#f[Choques][
  $ bold(P)_"antes" = bold(P)_"después" quad quad "(elástico, además: " K_"antes" = K_"después" ")" $
][el choque es corto: las fuerzas externas no alcanzan a dar impulso. La energía cinética sólo se conserva si es *elástico*.]

#f[Energía en el sistema CM (König)][
  $ K = 1/2 M v_"cm"^2 + K_"rel al CM" $
][siempre. La parte del CM no se puede gastar en un choque: lo que se pierde sale de $K_"rel"$.]

// =====================================================================
#tema(3)[El cohete]
#ctx[Masa variable: $bold(F) = m bold(a)$ no sirve. Se conserva $bold(P)$ del
cohete + gas expulsado. $mu = -d M\/d t > 0$ es el caudal, $bold(v)_r$ la velocidad del gas *relativa al cohete*.]

#f[Empuje][
  $ M bold(a) = bold(f) = -mu bold(v)_r, quad quad f = mu abs(bold(v)_r) = I_"sp" g_0 mu $
][$bold(v)_r$ medida desde el cohete (no desde el suelo). $I_"sp" = abs(bold(v)_r)\/g_0$ con $g_0 = 9,80665$ m/s².][coh-empuje]

#f[Movimiento vertical, con gravedad][
  $ (d V)/(d t) = (mu abs(v_r))/(M_0 - mu t) - g $
][vuelo vertical, $g$ constante, caudal $mu$ constante, sin arrastre.][coh-vertical]

#f[Tsiolkovsky][
  $ V_f = V_0 + abs(v_r) ln (M_0)/(M_f) - g t_f quad quad "(en el espacio: " Delta V = abs(v_r) ln (M_0)/(M_f) ")" $
][las mismas de arriba. Sin gravedad ni arrastre queda la del paréntesis. *Por etapas*: se aplica a cada etapa por separado y los $Delta V$ se suman.][coh-tsiolkovsky]

// =====================================================================
#tema(4)[Trabajo, energía y gravitación]

#f[Trabajo y teorema trabajo–energía][
  $ W = integral_(P_1)^(P_2) bold(F) dot d bold(l), quad quad W_"tot" = Delta K, quad quad bold(F) = -nabla U $
][el teorema vale siempre (con *todas* las fuerzas). $bold(F) = -nabla U$ sólo para fuerzas conservativas; toda fuerza central que dependa sólo de $r$ lo es.][ener-teorema]

#f[Ley de gravitación y $g$][
  $ bold(F)_g = -(G M m)/r^2 hat(r), quad quad g = (G m_T)/R_T^2 = mu_T/R_T^2 $
][masas puntuales o esferas con simetría esférica, y $r$ *fuera* de la esfera. $g$ así es sin la rotación de la Tierra.][grav-newton-vec]

#f[Energía potencial gravitatoria][
  $ U = -(G M m)/r $
][cero en el infinito. Cerca de la superficie, $m g y$ es su aproximación para $y << R_T$.]

#f[Circular y escape][
  $ v_"circ" = sqrt(mu/r), quad quad v_"esc" = sqrt((2 mu)/r) = sqrt(2) thin v_"circ" $
][$m << M$ (el central no se mueve). Escape: energía total justo cero, sin importar la dirección del disparo.][grav-vesc]

// =====================================================================
#tema(5)[Momento angular y fuerzas centrales]

#f[Momento angular y su ecuación][
  $ bold(L)_O = bold(r) times m bold(v), quad L_O = m v r sin phi, quad quad sum bold(tau)_O = (d bold(L)_O)/(d t) $
][$bold(L)$ y $bold(tau)$ respecto del *mismo* punto $O$, fijo en un marco inercial (o el CM).][angm-tau]

#f[Fuerza central: $bold(L)$ constante][
  $ h = L/m = r v_theta = r v cos gamma = "cte", quad quad (d A)/(d t) = h/2 $
][la fuerza apunta siempre a $O$ (torque nulo). Consecuencias: movimiento plano y 2.ª ley de Kepler. $gamma$ = ángulo de vuelo (de la velocidad con la horizontal local).][angm-h]
#ojo[Sirve para ir de periapsis a apoapsis sin nada más: allí $gamma = 0$, así que $r_p v_p = r_a v_a$.]

// =====================================================================
#tema(6)[El problema de dos cuerpos]
#ctx[Dos cuerpos aislados que se atraen: se parte en el movimiento del CM
(uniforme) y el de la separación $bold(r) = bold(r)_2 - bold(r)_1$, que es un problema de *un* cuerpo.]

#f[Movimiento relativo][
  $ dot.double(bold(r)) = -mu/r^3 bold(r), quad quad mu = G(m_1 + m_2) $
][sistema aislado, sólo la gravedad mutua, cuerpos puntuales o esféricos. Si $m_2 << m_1$, $mu approx G m_1$.][dosc-relativa]

#f[Masa reducida y posiciones desde el CM][
  $ m_r = (m_1 m_2)/(m_1 + m_2), quad quad bold(r)_1 = m_2/(m_1 + m_2) bold(r), quad bold(r)_2 = -m_1/(m_1 + m_2) bold(r) $
][origen en el CM. Cada cuerpo describe una cónica semejante a la relativa, escalada por su fracción de masa.][dosc-posiciones]

// =====================================================================
#tema(7)[La órbita: cónicas, energía y Kepler]
#ctx[Todas valen bajo *dos cuerpos ideales* (sección 6). La forma sale de $h$ y
$e$; el tamaño, de la energía. $e < 1$ elipse, $e = 1$ parábola, $e > 1$ hipérbola.]

#f[Ecuación de la órbita][
  $ r = p/(1 + e cos nu), quad quad p = h^2/mu $
][$nu$ medido desde el periapsis, en el sentido del movimiento.][orb-orbita]

#f[Energía específica y vis-viva][
  $ epsilon = v^2/2 - mu/r = -mu/(2a), quad quad v^2 = mu (2/r - 1/a) $
][elipse (y circular, con $a = r$). Para la hipérbola, con el $a > 0$ del apunte: $epsilon = +mu\/(2a)$ y $v^2 = mu(2\/r + 1\/a)$.][orb-visviva]

#f[Geometría de la elipse][
  $ r_p = p/(1+e), quad r_a = p/(1-e), quad e = (r_a - r_p)/(r_a + r_p) $
  $ a = (r_p + r_a)/2, quad b = sqrt(r_p r_a), quad p = a(1 - e^2) $
][elipse. $r$ se mide desde el *centro* del cuerpo central: altura + radio.][orb-semiejes]
#ojo[«Órbita a 500 km» es $r = R_T + 500$ km, no $500$ km.]

#f[Tercera ley de Kepler][
  $ tau = (2 pi a b)/h = (2 pi a^(3\/2))/sqrt(mu) $
][órbita cerrada (elipse o circular). El período depende *sólo* de $a$.][kep-periodo]

// =====================================================================
#tema(8)[Maniobras: Hohmann y rendez-vous]
#ctx[Encendidos *impulsivos* (instantáneos: cambia $v$, no $r$). Cada $Delta v$ se saca con vis-viva, antes y después.]

#f[Transferencia de Hohmann][
  $ a_t = (r_1 + r_2)/2, quad Delta v_1 = v_1' - v_1, quad Delta v_2 = v_2 - v_2', quad t_v = pi sqrt(a_t^3/mu) $
][órbitas inicial y final *circulares y coplanares*; encendidos tangentes en el periapsis y el apoapsis de la elipse de transferencia. $v_1'$, $v_2'$: velocidades en la elipse; $v_1$, $v_2$: circulares.][man-tv]

#f[Ángulo de fase al lanzar][
  $ phi = 180° - n_2 t_v, quad quad n_2 = 360° \/ tau_2 $
][Hohmann; $phi$ es cuánto tiene que ir *adelante* el destino en el momento del primer encendido.][man-fase]

#f[Órbita de fasaje (rendez-vous en la misma órbita)][
  $ T'/T = 1 - (Delta phi)/(360°), quad quad a' = r (T'/T)^(2\/3) $
][misma circular de radio $r$, blanco $Delta phi$ adelante, *una* vuelta en la órbita de fasaje. Se frena para quedar en una más chica (y más rápida en período).][man-fasaje-a]

// =====================================================================
#tema(9)[Hipérbola, escape y cónicas parcheadas]

#f[Hipérbola][
  $ a = p/(e^2 - 1), quad r_p = a(e - 1), quad nu_oo = arccos(-1/e), quad delta = 2 arcsin(1/e) $
][$e > 1$; $a > 0$ por convención del apunte. $nu_oo$: anomalía de la asíntota; $delta$: cuánto se tuerce la velocidad al pasar.][hip-delta]

#f[Velocidad de sobra y $C_3$][
  $ v_oo = sqrt(mu/a), quad quad v^2 = v_"esc"^2 + v_oo^2, quad quad C_3 = v_oo^2 $
][hipérbola. En la parábola ($e = 1$), $v = v_"esc"$ en todo punto y $v_oo = 0$.][hip-vinf]

#f[Componentes de la velocidad y ángulo de vuelo][
  $ v_perp = h/r, quad v_r = mu/h e sin nu, quad tan gamma = v_r/v_perp = (e sin nu)/(1 + e cos nu) $
][cualquier cónica. $gamma > 0$ mientras se aleja ($0 < nu < 180°$).][hip-gamma]

#f[Esfera de influencia][
  $ r_"SOI" = R (m_p/m_s)^(2\/5) quad quad "(Tierra: " approx 925 thin 000 " km)" $
][$m_p << m_s$; $R$ = distancia planeta–Sol. Adentro manda el planeta, afuera el Sol. Es un borde *aproximado*, no una frontera física.][soi-soi]

#f[Cónicas parcheadas: salir de una órbita de estacionamiento][
  $ bold(v)_oo = bold(V)_"nave" - bold(V)_"planeta", quad e = 1 + (r_p v_oo^2)/mu, quad v_p = sqrt(v_oo^2 + (2 mu)/r_p) $
  $ Delta v = v_p - v_c = v_c (sqrt(2 + (v_oo \/ v_c)^2) - 1) $
][se ignora la otra gravedad dentro de cada esfera y la SOI se toma como «infinito» del planeta. Encendido tangente en el periapsis, desde la circular $v_c = sqrt(mu\/r_p)$. $bold(v)_oo$ sale del Hohmann heliocéntrico.][soi-dv]

// =====================================================================
#tema(10)[Vector de estado, marco perifocal y coeficientes de Lagrange]
#ctx[Marco perifocal: $hat(p)$ hacia el periapsis, $hat(q)$ a 90° en el sentido del
movimiento, $hat(w) = hat(h)$. Seis números fijan la órbita: $bold(r)$ y $bold(v)$ en un instante.]

#f[Posición y velocidad en el marco perifocal][
  $ bold(r) = h^2/mu 1/(1 + e cos nu) (cos nu hat(p) + sin nu hat(q)), quad bold(v) = mu/h [-sin nu hat(p) + (e + cos nu) hat(q)] $
][dos cuerpos.][perif-v]

#f[Del estado a la órbita][
  $ bold(h) = bold(r) times bold(v), quad bold(n) = hat(k) times bold(h), quad bold(e) = 1/mu [(v^2 - mu/r) bold(r) - (bold(r) dot bold(v)) bold(v)] $
][dos cuerpos. $bold(e)$ apunta al periapsis; $bold(n)$, a la línea de nodos. Si $bold(r) dot bold(v) > 0$ se aleja (y $nu < 180°$).][perif-tres]

#f[Coeficientes de Lagrange][
  $ bold(r) = f bold(r)_0 + g bold(v)_0, quad bold(v) = dot(f) bold(r)_0 + dot(g) bold(v)_0, quad f dot(g) - dot(f) g = 1 $
  $ f = 1 - (mu r)/h^2 (1 - cos Delta nu), quad g = (r r_0)/h sin Delta nu, quad dot(g) = 1 - (mu r_0)/h^2 (1 - cos Delta nu) $
][dos cuerpos: propagan el estado un $Delta nu$ sin conocer los elementos. $r$ al final sale de la ecuación de la órbita.][perif-fg-dnu]

// =====================================================================
#tema(11)[Tres cuerpos restringido y puntos de Lagrange]
#ctx[Un cuerpo de masa despreciable ($m_3 << m_1, m_2$) entre dos primarios que
giran en *círculos* alrededor de su CM. Se trabaja en el marco que gira con ellos.]

#f[Velocidad angular y posiciones de los primarios][
  $ Omega = sqrt(mu\/r_(12)^3), quad x_1 = -pi_2 r_(12), quad x_2 = pi_1 r_(12), quad pi_i = m_i/(m_1 + m_2) $
][primarios en órbita circular; $mu = G(m_1+m_2)$; origen en el CM, eje $x$ por los dos.][tres-pi]

#f[Ecuaciones de movimiento (marco rotante)][
  $ dot.double(x) - 2 Omega dot(y) - Omega^2 x = -mu_1/r_1^3 (x + pi_2 r_(12)) - mu_2/r_2^3 (x - pi_1 r_(12)) $
  $ dot.double(y) + 2 Omega dot(x) - Omega^2 y = -(mu_1/r_1^3 + mu_2/r_2^3) y, quad dot.double(z) = -(mu_1/r_1^3 + mu_2/r_2^3) z $
][las del recuadro. Los términos en $2 Omega$ son Coriolis; los en $Omega^2$, centrífuga.][tres-mov-x]

#f[$L_4$, $L_5$ y radio de Hill][
  $ L_(4,5): x = r_(12)/2 - pi_2 r_(12), quad y = plus.minus sqrt(3)/2 r_(12); quad quad r_"Hill" = r_(12) (m_2/(3 m_1))^(1\/3) $
][$L_4$, $L_5$: triángulo equilátero con los primarios (exacto). Hill ≈ distancia a $L_1$, $L_2$ con $m_2 << m_1$. $L_1$–$L_3$ salen numéricos.][tres-hill]

#f[Estabilidad de $L_4$, $L_5$ (Routh)][
  $ m_1/m_2 + m_2/m_1 >= 25 quad <==> quad pi_2 <= 0,0385 $
][linealizando alrededor del punto. $L_1$, $L_2$, $L_3$ son *siempre* inestables.][tres-estable]

#f[Constante de Jacobi y zonas prohibidas][
  $ C = v^2/2 - (Omega^2 (x^2 + y^2))/2 - mu_1/r_1 - mu_2/r_2, quad quad C >= U_J (x, y, z) $
][$v$ medida *en el marco rotante*. Es la energía de ese marco; $C < U_J$ es región inaccesible.][tres-jacobi]

// =====================================================================
#tema(12)[Rotación alrededor de un eje fijo]
#ctx[Cuerpo rígido que gira alrededor de un eje de dirección fija. La
«masa» de la rotación es $I$, y depende del eje.]

#f[Cinemática y energía][
  $ v = r omega, quad a_"tan" = r alpha, quad a_"rad" = omega^2 r; quad quad I = sum m_i r_i^2, quad K = 1/2 I omega^2 $
][$r$ = distancia *al eje* (no al origen). $omega$ en rad/s.][rot-energia]

#f[Steiner][
  $ I_P = I_"cm" + M d^2 $
][los dos ejes *paralelos*, uno por el CM; $d$ la distancia entre ellos. Nunca entre dos ejes que no pasan por el CM.][rot-steiner]

#f[Dinámica de rotación][
  $ bold(tau) = bold(r) times bold(F), quad sum tau_z = I alpha_z, quad L = I omega, quad sum bold(tau)_"ext" = (d bold(L))/(d t) $
][eje fijo, o eje por el CM aunque el CM se mueva. $L = I omega$ como *vector* sólo si el eje es de simetría (principal).][rot-tau-ialfa]

#f[Rodar: traslación + rotación][
  $ K = 1/2 M v_"cm"^2 + 1/2 I_"cm" omega^2 $
][siempre (König). Rodar sin deslizar agrega $v_"cm" = R omega$.][rot-traslacion]

#f[Conservación del momento angular][
  $ I_1 omega_1 = I_2 omega_2 $
][torque externo nulo sobre ese eje. La energía cinética *no* se conserva (la bailarina hace trabajo al cerrar los brazos).][rot-conserva]

#f[Precesión del giróscopo][
  $ Omega = (M g r)/(I omega) $
][aproximación giroscópica: el espín $omega$ es mucho mayor que la precesión $Omega$, y el eje es horizontal. $r$: del apoyo al CM.][rot-precesion]

// =====================================================================
#tema(13)[Cuerpo rígido en 3D: cinemática, inercia, Euler]

#f[Velocidad y aceleración de un punto del cuerpo][
  $ bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B\/A), quad bold(a)_B = bold(a)_A + bold(alpha) times bold(r)_(B\/A) + bold(omega) times (bold(omega) times bold(r)_(B\/A)) $
][$A$ y $B$ del mismo cuerpo rígido. Las $bold(omega)$ se suman como vectores: $bold(omega) = bold(omega)_1 + bold(omega)_2$ (las rotaciones *finitas* no).][cin-agen]

#f[Derivada en un sistema que rota][
  $ (dot(bold(Q)))_"fijo" = (dot(bold(Q)))_"rotante" + bold(Omega) times bold(Q) $
][cualquier vector $bold(Q)$; $bold(Omega)$ la velocidad angular de los *ejes* (que puede no ser la del cuerpo).][cin-derivada]

#f[Coriolis en 3D][
  $ bold(a)_P = dot(bold(Omega)) times bold(r) + bold(Omega) times (bold(Omega) times bold(r)) + 2 bold(Omega) times (dot(bold(r)))_"rot" + (dot.double(bold(r)))_"rot" $
][origen del sistema rotante fijo. Es la general: con $dot(bold(Omega)) = 0$ vuelve a la del tema 1.][cin-coriolis-a]

#f[Tensor de inercia][
  $ mat(H_x; H_y; H_z) = mat(I_x, -I_(x y), -I_(x z); -I_(x y), I_y, -I_(y z); -I_(x z), -I_(y z), I_z) mat(omega_x; omega_y; omega_z) $
][ejes por $G$ (o por un punto fijo). En *ejes principales* los productos se anulan y $H_x = I_x omega_x$, etc. En general $bold(H)_G$ *no* es paralelo a $bold(omega)$.][iner-tensor]

#f[Momento angular respecto de otro punto, y energía][
  $ bold(H)_O = macron(bold(r)) times m macron(bold(v)) + bold(H)_G, quad quad T = 1/2 m macron(v)^2 + 1/2 bold(omega) dot bold(H)_G $
][siempre (barra = del centro de masa).][iner-energia]

#f[Ecuaciones de Euler][
  $ sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z quad "(y cíclicas)" $
][ejes *principales* y *solidarios al cuerpo*, con origen en $G$ o en un punto fijo. Si los ejes no son solidarios, se usa $dot(bold(H)) = (dot(bold(H)))_"rot" + bold(Omega) times bold(H)$.][euler-euler-clasicas]

#f[Precesión estable (cuerpo simétrico)][
  $ sum bold(M)_O = dot(phi) sin theta [I' dot(psi) + (I' - I) dot(phi) cos theta] hat(f) $
  $ "con" theta = 90°: quad sum bold(M)_O = I' dot(phi) dot(psi) hat(f) $
][cuerpo de revolución; $I'$ axial, $I$ transversal; $theta$ (nutación), $dot(phi)$ (precesión) y $dot(psi)$ (espín) *constantes*.][euler-precesion-estable]

#f[Movimiento libre de un cuerpo simétrico][
  $ dot(phi) = H\/I, quad quad tan gamma = I/I' tan theta $
][sin torque ($bold(H)_G$ fijo). Acá $gamma$ = ángulo entre $bold(H)_G$ y el eje de simetría, $theta$ = ángulo entre $bold(omega)$ y el eje (notación del Beer).][peon-tan-gamma]
#ojo[$I > I'$ (alargado, una varilla): precesión *directa*. $I < I'$ (achatado, un disco): *retrógrada*, espín y precesión giran para lados opuestos.]

// =====================================================================
#tema(14)[Constantes]
#table(columns: (auto, 1fr), stroke: none, inset: (x: 3pt, y: 2pt),
  [$G$], [$6,674 times 10^(-11)$ N·m²/kg²],
  [$mu_T$], [$398 thin 600$ km³/s² #h(4pt) $R_T = 6378$ km],
  [$mu_"Luna"$], [$4903$ km³/s² #h(4pt) (distancia Tierra–Luna $approx 384 thin 400$ km)],
  [$mu_"Sol"$], [$1,327 times 10^11$ km³/s² #h(4pt) (1 UA $= 149,6 times 10^6$ km)],
  [$g_0$], [$9,80665$ m/s² (para $I_"sp"$)],
)
#text(size: 7.3pt, fill: luma(110))[Los valores y sus fuentes, en el Anexo C del apunte.]
