// =====================================================================
//  hoja-formulas.typ -- las hojas de formulas de la materia, DOS desde
//  este mismo archivo (un dato en dos archivos diverge):
//
//    --input version=parcial   -> UNA carilla A4 para el parcial: sin tres
//                                 cuerpos, sin coeficientes de Lagrange y
//                                 sin cuerpo rigido en 3D (Fran, 2026-10-01)
//    (sin --input)             -> la definitiva de toda la materia: la
//                                 misma primera carilla y, atras, lo que
//                                 la del parcial deja afuera
//
//  SOLO formulas y el titulo de cada tema: nada de subtitulos ni notas que
//  expliquen (Fran, 2026-10-01: «el profe no lo va a querer, son muy
//  ayudadores»). Las condiciones que son parte de una formula (el
//  cuadrante de un angulo) van en matematica, no en palabras. Varias
//  formas de calcular lo mismo donde las hay. Fuentes: el apunte, la clase
//  de Valenti sobre elementos orbitales y las fotocopias del Bate
//  (§2.2-2.4), el 13.79 resuelto en clase y la hoja de un companero. Si el
//  apunte cambia una formula, esta hoja no se entera: se corrige a mano.
//
//  LA COMPAGINACION ES A MANO (Fran, 2026-10-01: «que no quede dividido en
//  trozos»): ningun tema se parte, cada columna tiene sus temas fijos y
//  separados por #colbreak(), y el aire que sobra en cada columna se
//  reparte parejo entre sus temas (#aire = v(1fr)). Si un tema crece y no
//  entra, la carilla pasa a ser dos: por eso compilar.ps1 exige 1 pagina
//  para la del parcial.
//
//  OJO: una ecuacion en bloque NO se parte sola; si no entra en la columna
//  se pisa con la de al lado sin dar error. Cada renglon va corto, y lo
//  mide verificar-hoja.py.
//
//    typst compile --root .. hoja-formulas.typ salida/hoja-formulas.pdf
//    typst compile --root .. --input version=parcial hoja-formulas.typ salida/hoja-formulas-parcial.pdf
// =====================================================================
#let completa = sys.inputs.at("version", default: "completa") != "parcial"

#set document(
  title: if completa { "Hoja de fórmulas — Física Espacial" } else { "Hoja para el parcial — Física Espacial" },
  author: "Apunte de Física Espacial — UNSAM")
#set page(paper: "a4", margin: (x: 0.8cm, y: 0.75cm), columns: 3)
#set columns(gutter: 11pt)
#set text(lang: "es", region: "ar", size: 8.6pt,
  font: ("Libertinus Serif", "Georgia", "Times New Roman"))
#set par(justify: false, leading: 0.42em, spacing: 0.42em)
#show math.equation: eq => {
  show ",": it => math.class("normal", it)
  eq
}
#show math.equation.where(block: true): set block(above: 3pt, below: 3pt)
#show math.equation.where(block: true): set align(left)

#let acento = rgb("#1f3a5f")

// Un tema: titulo con su raya y las formulas, en un bloque que no se parte.
#let tema(titulo, cuerpo) = block(breakable: false, above: 0pt, below: 0pt, width: 100%)[
  #block(above: 0pt, below: 3.5pt, width: 100%, inset: (bottom: 1.5pt),
    stroke: (bottom: 0.5pt + acento.lighten(40%)),
  )[#text(weight: "bold", size: 8.4pt, fill: acento)[#upper(titulo)]]
  #cuerpo
]
// El aire entre temas de una misma columna: lo que sobra, repartido parejo,
// con un minimo para que dos temas nunca queden pegados.
#let aire = { v(7pt); v(1fr) }

// --- titulo -------------------------------------------------------------
#place(top, scope: "parent", float: true, block(width: 100%, below: 4pt)[
  #grid(columns: (auto, 1fr), align: (left + bottom, right + bottom), column-gutter: 8pt,
    text(size: 12.5pt, weight: "bold", fill: acento)[Física Espacial — fórmulas],
    text(size: 8.6pt)[$mu = G M, quad h = L\/m$],
  )
  #v(-3pt)
  #line(length: 100%, stroke: 0.8pt + acento)
])

// =====================================================================
//  COLUMNA 1 -- dinamica: cantidad de movimiento, cohete, energia, L, rotacion
// =====================================================================
#tema[Cantidad de movimiento y choques][
$ bold(p) = m bold(v), quad sum bold(F) = (d bold(p))/(d t) $
$ bold(J) = integral bold(F) d t = Delta bold(p) = bold(F)_"med" Delta t $
$ bold(r)_"cm" = (sum m_i bold(r)_i)/M, quad bold(P) = M bold(v)_"cm" $
$ sum bold(F)_"ext" = M bold(a)_"cm", quad sum bold(F)_"ext" = 0 arrow.r.double bold(P) = "cte" $
$ m_1 bold(v)_1 + m_2 bold(v)_2 = m_1 bold(v)'_1 + m_2 bold(v)'_2 $
$ bold(v)'_1 = bold(v)'_2 = bold(P)/M, quad K_"perd" = 1/2 m_r v_"rel"^2 $
$ m_r = (m_1 m_2)/(m_1 + m_2), quad bold(v)_"rel" = bold(v)_A - bold(v)_B $
$ K = 1/2 M v_"cm"^2 + K_"rel", quad K = p^2/(2 m) $
]
#aire
#tema[Cohete][
$ mu = -(d M)/(d t), quad f = mu abs(v_r) = I_"sp" g_0 mu, quad I_"sp" = abs(v_r)/g_0 $
$ M (d V)/(d t) = mu abs(v_r) - M g, quad M(t^*) = (mu abs(v_r))/g $
$ M(t) = M_0 - mu t, quad a(t) = (mu abs(v_r))/(M_0 - mu t) - g $
$ V(t) = V_0 + abs(v_r) ln (M_0)/(M(t)) - g t $
$ y(t) = y_0 + V_0 t - 1/2 g t^2 $
$ #h(2.6em) + abs(v_r) [t - (M(t))/mu ln (M_0)/(M(t))] $
$ Delta V = abs(v_r) ln (M_0)/(M_f), quad (M_0)/(M_f) = exp((Delta V)/abs(v_r)) $
$ Delta V_"tot" = sum Delta V_i, quad bold(F)_"ext" = (d (M bold(v)))/(d t) $
]
#aire
#tema[Trabajo y energía][
$ W = integral bold(F) dot d bold(l), quad W_"tot" = Delta K, quad P = bold(F) dot bold(v) $
$ bold(F) = -nabla U, quad E = K + U, quad W_"no cons" = Delta E $
]
#aire
#tema[Momento angular][
$ bold(L)_O = bold(r) times m bold(v), quad L = m v r sin phi = m v d $
$ sum bold(tau)_O = (d bold(L)_O)/(d t), quad integral bold(tau) d t = Delta bold(L) $
$ h = r v_perp = r v cos gamma = r^2 dot(theta) = "cte", quad (d A)/(d t) = h/2 $
$ r_P v_P = r_A v_A $
]
#aire
#tema[Rotación y giróscopo][
$ v = omega r, quad a_t = alpha r, quad a_"rad" = omega^2 r, quad K = 1/2 I omega^2 $
$ I = sum m_i r_i^2, quad I_P = I_"cm" + M d^2 $
#table(columns: (auto, auto, auto, auto), stroke: none, inset: (x: 2pt, y: 1.2pt),
  [varilla (cm)], [$M L^2 \/ 12$], [aro], [$M R^2$],
  [varilla (ext)], [$M L^2 \/ 3$], [disco], [$M R^2 \/ 2$],
  [esfera], [$2 M R^2 \/ 5$], [esf. hueca], [$2 M R^2 \/ 3$],
)
$ tau = r F sin phi, quad sum tau_z = I alpha_z, quad L = I omega $
$ sum bold(tau)_"ext" = (d bold(L))/(d t) $
$ sum bold(tau)_"ext" = 0 arrow.r.double sum I_i omega_i = "cte" $
$ K = 1/2 M v_"cm"^2 + 1/2 I_"cm" omega^2, quad v_"cm" = R omega $
$ Delta bold(L) = bold(tau) Delta t, quad Omega = tau/L = (M g r)/(I omega) $
]

#colbreak()
// =====================================================================
//  COLUMNA 2 -- gravitacion y conicas: gravitacion, dos cuerpos, orbitas,
//  hiperbola
// =====================================================================
#tema[Gravitación][
$ bold(F)_g = -(G M m)/r^2 hat(r), quad U = -(G M m)/r $
$ g_0 = (G M)/R^2 = mu/R^2, quad g(h) = g_0 (R/(R + h))^2 $
$ v_c = sqrt(mu/r), quad v_"esc" = sqrt((2 mu)/r) = sqrt(2) thin v_c, quad T = (2 pi r)/v_c $
$ Delta E_(R arrow.r r) = mu m (1/R - 1/(2 r)) $
$ Delta E_(r_1 arrow.r r_2) = (mu m)/2 (1/r_1 - 1/r_2) $
]
#aire
#tema[Dos cuerpos][
$ dot.double(bold(r)) = -mu/r^3 bold(r), quad mu = G(m_1 + m_2) approx G m_1 $
$ bold(r) = bold(r)_1 - bold(r)_2, quad bold(r)_1 = m_2/M bold(r), quad bold(r)_2 = -m_1/M bold(r) $
$ E = 1/2 m dot(r)^2 + L^2/(2 m r^2) + U(r), quad U_"ef" = U + L^2/(2 m r^2) $
]
#aire
#tema[Órbitas][
$ r = p/(1 + e cos nu), quad p = h^2/mu = a(1 - e^2) $
$ cos nu = 1/e (p/r - 1), quad e sin nu = (h v_r)/mu $
$ epsilon = v^2/2 - mu/r = -mu/(2 a), quad v^2 = mu (2/r - 1/a) $
$ e = sqrt(1 + (2 epsilon h^2)/mu^2) = (r_A - r_P)/(r_A + r_P) = (r_P v_P^2)/mu - 1 $
$ e^2 = (p/r - 1)^2 + ((h v_r)/mu)^2 $
$ e = (r_2 - r_1)/(r_1 cos nu_1 - r_2 cos nu_2) $
$ h = r v cos gamma = r_P v_P = sqrt(mu p) = sqrt(mu a (1 - e^2)) $
$ r_P = a(1 - e) = p/(1 + e), quad r_A = a(1 + e) = p/(1 - e) $
$ a = (r_P + r_A)/2, quad b = a sqrt(1 - e^2) = sqrt(r_P r_A) $
$ 1/2 v_P^2 - mu/r_P = 1/2 v_A^2 - mu/r_A $
$ v_P = sqrt((2 mu r_A)/(r_P (r_P + r_A))), quad v_A = r_P/r_A v_P $
$ v_P = sqrt(mu/a (1 + e)/(1 - e)), quad v_A = sqrt(mu/a (1 - e)/(1 + e)) $
$ v_perp = h/r = mu/h (1 + e cos nu), quad v_r = mu/h e sin nu $
$ tan gamma = v_r/v_perp = (e sin nu)/(1 + e cos nu) $
]
#aire
#tema[Hipérbola y escape][
$ e = 1: quad epsilon = 0, quad v = v_"esc" = sqrt((2 mu)/r) $
$ epsilon = v_oo^2/2 = mu/(2 a), quad v^2 = v_"esc"^2 + v_oo^2, quad C_3 = v_oo^2 $
$ a = p/(e^2 - 1) = mu/v_oo^2, quad r_P = a(e - 1) $
$ e = 1 + (r_P v_oo^2)/mu $
$ nu_oo = arccos(-1/e), quad delta = 2 arcsin(1/e) $
$ Delta v_"esc" = sqrt((2 mu)/r) - v $
]

#colbreak()
// =====================================================================
//  COLUMNA 3 -- Kepler, maniobras, elementos orbitales, constantes
// =====================================================================
#tema[Kepler][
$ T = 2 pi sqrt(a^3/mu) = (2 pi a b)/h, quad n = (2 pi)/T = sqrt(mu/a^3) $
$ tan E/2 = sqrt((1 - e)/(1 + e)) tan nu/2, quad cos E = (e + cos nu)/(1 + e cos nu) $
$ M_e = E - e sin E = n (t - t_P) $
$ r = a(1 - e cos E) $
$ T_"sid" = 24 "h" dot (360°)/(360,986°) = 23,934 "h" $
]
#aire
#tema[Maniobras][
$ v_P = [2 mu r_A/r_P dot 1/(r_A + r_P)]^(1\/2), quad v_A = r_P/r_A v_P $
$ v_(c P) = sqrt(mu/r_P), quad v_(c A) = sqrt(mu/r_A) $
$ Delta v_1 = v_P - v_(c P), quad Delta v_2 = v_(c A) - v_A $
$ v_P > v_(c P) arrow.l.r.double r_A/(r_A + r_P) > 1/2 $
$ a_t = (r_P + r_A)/2, quad t_v = T_t/2 = pi sqrt(a_t^3/mu) $
$ phi = 180° - n_A t_v, quad n_A = 360° \/ T_A $
$ T'/T = 1 - (Delta phi)/(360°), quad a' = r (T'/T)^(2\/3) $
$ r_P' = 2 a' - r $
]
#aire
#tema[Elementos orbitales][
$ (bold(r), bold(v)) arrow.l.r (a, thin e, thin i, thin Omega, thin omega, thin nu_0) $
$ bold(A) times bold(B) = mat(delim: "|", hat(I), hat(J), hat(K); A_I, A_J, A_K; B_I, B_J, B_K) $
$ = (A_J B_K - A_K B_J) hat(I) - (A_I B_K - A_K B_I) hat(J) $
$ #h(1em) + (A_I B_J - A_J B_I) hat(K) $
$ abs(bold(A) times bold(B)) = A B sin alpha, quad bold(A) times bold(B) = -bold(B) times bold(A) $
$ hat(I) times hat(J) = hat(K), quad hat(J) times hat(K) = hat(I), quad hat(K) times hat(I) = hat(J) $
$ bold(A) dot bold(B) = A_I B_I + A_J B_J + A_K B_K = A B cos alpha $
$ bold(r) dot bold(v) = r v_r = r v sin gamma $
$ bold(h) = bold(r) times bold(v), quad bold(n) = hat(K) times bold(h) = (-h_J, thin h_I, thin 0) $
$ bold(e) = 1/mu [(v^2 - mu/r) bold(r) - (bold(r) dot bold(v)) bold(v)] $
$ p = h^2/mu, quad e = abs(bold(e)), quad a = p/(1 - e^2) = -mu/(2 epsilon) $
$ cos i &= h_K/h \
  cos Omega &= n_I/n && quad (n_J < 0 arrow.r.double Omega > 180°) \
  cos omega &= (bold(n) dot bold(e))/(n e) && quad (e_K < 0 arrow.r.double omega > 180°) \
  cos nu_0 &= (bold(e) dot bold(r))/(e r) && quad (bold(r) dot bold(v) < 0 arrow.r.double nu_0 > 180°) $
$ Pi &= Omega + omega && quad (i = 0) \
  u_0 &= omega + nu_0 && quad (e = 0) \
  l_0 &= Omega + omega + nu_0 && quad (i = e = 0) $
$ cos Pi &= e_I/e && quad (e_J < 0 arrow.r.double Pi > 180°) \
  cos u_0 &= (bold(n) dot bold(r))/(n r) && quad (r_K < 0 arrow.r.double u_0 > 180°) \
  cos l_0 &= r_I/r && quad (r_J < 0 arrow.r.double l_0 > 180°) $
$ bold(r) = r cos nu thin hat(P) + r sin nu thin hat(Q) $
$ bold(v) = mu/h [-sin nu thin hat(P) + (e + cos nu) hat(Q)] $
]
#aire
#tema[Constantes][
#table(columns: (auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.2pt),
  [$G$], [$6,674 times 10^(-11)$ N·m²/kg²],
  [$mu_T$, $R_T$], [$398 thin 600$ km³/s², $6378$ km],
  [$g_0$], [$9,80665$ m/s²],
  [$mu_"Luna"$], [$4903$ km³/s², $d_"T–L" approx 384 thin 400$ km],
  [$mu_"Sol"$], [$1,327 times 10^11$ km³/s²],
  [1 UA], [$149,6 times 10^6$ km],
)
]

// =====================================================================
//  CARILLA 2 (solo la definitiva) -- lo que la del parcial deja afuera
// =====================================================================
#if completa [
#pagebreak()

#tema[Marcos no inerciales][
$ bold(v) = dot(r) hat(r) + r dot(theta) hat(theta) $
$ bold(a) = (dot.double(r) - r dot(theta)^2) hat(r) + (r dot.double(theta) + 2 dot(r) dot(theta)) hat(theta) $
$ m bold(a)' = bold(F) - m bold(A) $
$ m bold(a)_"rel" = bold(F) - 2 m bold(Omega) times bold(v)_"rel" $
$ #h(3em) - m bold(Omega) times (bold(Omega) times bold(r)) - m dot(bold(Omega)) times bold(r) $
]
#v(7pt)
#tema[Esfera de influencia y cónicas parcheadas][
$ r_"SOI" = R (m_p/m_s)^(2\/5), quad r_"SOI,T" approx 925 thin 000 "km" $
$ bold(v)_oo = bold(V)_"nave" - bold(V)_"planeta" $
$ v_P = sqrt(v_oo^2 + (2 mu)/r_P), quad v_c = sqrt(mu\/r_P) $
$ e = 1 + (r_P v_oo^2)/mu $
$ Delta v = v_P - v_c = v_c (sqrt(2 + (v_oo \/ v_c)^2) - 1) $
]
#v(7pt)
#tema[Coeficientes de Lagrange][
$ bold(r) = f bold(r)_0 + g bold(v)_0, quad bold(v) = dot(f) bold(r)_0 + dot(g) bold(v)_0 $
$ f dot(g) - dot(f) g = 1 $
$ f = 1 - (mu r)/h^2 (1 - cos Delta nu), quad g = (r r_0)/h sin Delta nu $
$ dot(g) = 1 - (mu r_0)/h^2 (1 - cos Delta nu) $
]

#colbreak()
#tema[Tres cuerpos restringido][
$ Omega = sqrt(mu\/r_(12)^3), quad pi_i = m_i/(m_1 + m_2) $
$ x_1 = -pi_2 r_(12), quad x_2 = pi_1 r_(12) $
$ dot.double(x) - 2 Omega dot(y) - Omega^2 x = -mu_1/r_1^3 (x + pi_2 r_(12)) $
$ #h(7.5em) - mu_2/r_2^3 (x - pi_1 r_(12)) $
$ dot.double(y) + 2 Omega dot(x) - Omega^2 y = -(mu_1/r_1^3 + mu_2/r_2^3) y $
$ L_(4,5): (r_(12)/2 - pi_2 r_(12), plus.minus sqrt(3)/2 r_(12)) $
$ r_"Hill" = r_(12) (m_2/(3 m_1))^(1\/3), quad m_1/m_2 + m_2/m_1 >= 25 $
$ C = v^2/2 - (Omega^2 (x^2 + y^2))/2 - mu_1/r_1 - mu_2/r_2 $
]

#colbreak()
#tema[Cuerpo rígido en 3D][
$ bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B\/A) $
$ bold(a)_B = bold(a)_A + bold(alpha) times bold(r)_(B\/A) + bold(omega) times (bold(omega) times bold(r)_(B\/A)) $
$ (dot(bold(Q)))_"fijo" = (dot(bold(Q)))_"rot" + bold(Omega) times bold(Q) $
$ mat(H_x; H_y; H_z) = mat(I_x, -I_(x y), -I_(x z); -I_(x y), I_y, -I_(y z); -I_(x z), -I_(y z), I_z) mat(omega_x; omega_y; omega_z) $
$ bold(H)_O = macron(bold(r)) times m macron(bold(v)) + bold(H)_G, quad T = 1/2 m macron(v)^2 + 1/2 bold(omega) dot bold(H)_G $
$ sum M_x &= I_x dot(omega)_x - (I_y - I_z) omega_y omega_z \
  sum M_y &= I_y dot(omega)_y - (I_z - I_x) omega_z omega_x \
  sum M_z &= I_z dot(omega)_z - (I_x - I_y) omega_x omega_y $
$ sum bold(M)_O = dot(phi) sin theta [I' dot(psi) + (I' - I) dot(phi) cos theta] hat(f) $
$ theta = 90°: quad sum bold(M)_O = I' dot(phi) dot(psi) hat(f) $
$ dot(phi) = H\/I, quad tan gamma = I/I' tan theta $
]
]
