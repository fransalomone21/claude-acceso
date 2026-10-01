// =====================================================================
//  hoja-formulas.typ -- la hoja de formulas de toda la materia, en UNA
//  carilla A4: solo las formulas, agrupadas por tema, sin hipotesis ni
//  comentarios (esos estan en el apunte, y en la version de 4 carillas
//  del commit 72727fa). Orden: primero lo que entra en la primera
//  evaluacion (cantidad de movimiento, cohete, energia, gravitacion,
//  orbitas, maniobras, momento angular, rotacion), despues el resto.
//  Las ecuaciones salen de las etiquetadas del apunte; si el apunte
//  cambia una, esta hoja no se entera: se corrige a mano.
//  Las ecuaciones en bloque NO se parten solas: una que no entra en la
//  columna se pisa con la de al lado. Por eso cada renglon es corto.
//    typst compile --root .. hoja-formulas.typ salida/hoja-formulas.pdf
// =====================================================================
#set document(title: "Hoja de fórmulas — Física Espacial", author: "Apunte de Física Espacial — UNSAM")
#set page(paper: "a4", margin: (x: 0.9cm, y: 0.85cm), columns: 3)
#set columns(gutter: 12pt)
#set text(lang: "es", region: "ar", size: 9pt,
  font: ("Libertinus Serif", "Georgia", "Times New Roman"))
#set par(justify: false, leading: 0.45em, spacing: 0.45em)
#show math.equation: eq => {
  show ",": it => math.class("normal", it)
  eq
}
#show math.equation.where(block: true): set block(above: 3.4pt, below: 3.4pt)
#show math.equation.where(block: true): set align(left)

#let acento = rgb("#1f3a5f")

#let tema(titulo, cuerpo) = block(breakable: false, above: 8pt, below: 0pt, width: 100%)[
  #block(below: 4pt, width: 100%, inset: (bottom: 2pt),
    stroke: (bottom: 0.4pt + acento.lighten(50%)),
  )[#text(weight: "bold", size: 8.4pt, fill: acento)[#upper(titulo)]]
  #cuerpo
]

// --- titulo -------------------------------------------------------------
#place(top, scope: "parent", float: true, block(width: 100%, below: 2pt)[
  #grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
    text(size: 13pt, weight: "bold", fill: acento)[Física Espacial — fórmulas],
    text(size: 7.5pt, fill: luma(110))[UNSAM 2026 · $mu = G M$ · $h = L\/m$ · $nu$ desde el periapsis · $r$ desde el centro del cuerpo],
  )
  #v(-2pt)
  #line(length: 100%, stroke: 0.8pt + acento)
])

// =====================================================================
#tema[Cantidad de movimiento y choques][
$ sum bold(F) = (d bold(p))/(d t), quad bold(J) = integral sum bold(F) d t = Delta bold(p) $
$ bold(r)_"cm" = 1/M sum m_i bold(r)_i, quad bold(P) = M bold(v)_"cm" $
$ sum bold(F)_"ext" = M bold(a)_"cm" $
$ bold(P)_"antes" = bold(P)_"desp", quad K_"antes" = K_"desp" " (elástico)" $
$ K = 1/2 M v_"cm"^2 + K_"rel al CM" $
]

#tema[Cohete][
$ mu = -(d M)/(d t), quad f = mu abs(v_r) = I_"sp" g_0 mu $
$ M bold(a) = -mu bold(v)_r $
$ (d V)/(d t) = (mu abs(v_r))/(M_0 - mu t) - g $
$ V_f = V_0 + abs(v_r) ln (M_0)/(M_f) - g t_f $
$ Delta V = abs(v_r) ln (M_0)/(M_f), quad Delta V_"tot" = sum_"etapas" Delta V_i $
]

#tema[Trabajo y energía][
$ W = integral bold(F) dot d bold(l), quad W_"tot" = Delta K, quad P = bold(F) dot bold(v) $
$ bold(F) = -nabla U, quad W_"no cons" = Delta (K + U) $
]

#tema[Gravitación][
$ bold(F)_g = -(G M m)/r^2 hat(r), quad U = -(G M m)/r, quad g = mu_T/R_T^2 $
$ v_"circ" = sqrt(mu/r), quad v_"esc" = sqrt((2 mu)/r) = sqrt(2) thin v_"circ" $
]

#tema[Momento angular (partícula)][
$ bold(L)_O = bold(r) times m bold(v), quad L = m v r sin phi $
$ sum bold(tau)_O = (d bold(L)_O)/(d t) $
$ h = r v_theta = r v cos gamma = "cte", quad (d A)/(d t) = h/2 $
$ r_p v_p = r_a v_a $
]

#tema[Dos cuerpos][
$ dot.double(bold(r)) = -mu/r^3 bold(r), quad mu = G(m_1 + m_2) $
$ m_r = (m_1 m_2)/(m_1 + m_2) $
$ bold(r)_1 = m_2/(m_1 + m_2) bold(r), quad bold(r)_2 = -m_1/(m_1 + m_2) bold(r) $
]

#tema[Órbita: cónicas y Kepler][
$ r = p/(1 + e cos nu), quad p = h^2/mu = a(1 - e^2) $
$ epsilon = v^2/2 - mu/r = -mu/(2 a) $
$ v^2 = mu (2/r - 1/a) $
$ r_p = a(1 - e), quad r_a = a(1 + e) $
$ a = (r_p + r_a)/2, quad e = (r_a - r_p)/(r_a + r_p), quad b = sqrt(r_p r_a) $
$ tau = (2 pi a b)/h = 2 pi sqrt(a^3/mu) $
$ v_perp = h/r, quad v_r = mu/h e sin nu $
$ tan gamma = v_r/v_perp = (e sin nu)/(1 + e cos nu) $
]

#tema[Maniobras: Hohmann y fasaje][
$ a_t = (r_1 + r_2)/2, quad t_v = pi sqrt(a_t^3/mu) $
$ Delta v_1 = sqrt(mu/r_1) (sqrt((2 r_2)/(r_1 + r_2)) - 1) $
$ Delta v_2 = sqrt(mu/r_2) (1 - sqrt((2 r_1)/(r_1 + r_2))) $
$ phi = 180° - n_2 t_v, quad n_2 = 360° \/ tau_2 $
$ T'/T = 1 - (Delta phi)/(360°), quad a' = r (T'/T)^(2\/3) $
]

#tema[Hipérbola, escape y SOI][
$ a = p/(e^2 - 1), quad r_p = a(e - 1), quad epsilon = mu/(2 a) $
$ nu_oo = arccos(-1/e), quad delta = 2 arcsin(1/e) $
$ v_oo = sqrt(mu/a), quad v^2 = v_"esc"^2 + v_oo^2, quad C_3 = v_oo^2 $
$ r_"SOI" = R (m_p/m_s)^(2\/5) $
$ bold(v)_oo = bold(V)_"nave" - bold(V)_"planeta", quad v_c = sqrt(mu\/r_p) $
$ e = 1 + (r_p v_oo^2)/mu, quad v_p = sqrt(v_oo^2 + (2 mu)/r_p) $
$ Delta v = v_p - v_c = v_c (sqrt(2 + (v_oo \/ v_c)^2) - 1) $
]

#tema[Rotación alrededor de un eje fijo][
$ v = r omega, quad a_"tan" = r alpha, quad a_"rad" = omega^2 r $
$ I = sum m_i r_i^2, quad K = 1/2 I omega^2 $
$ bold(tau) = bold(r) times bold(F), quad sum tau_z = I alpha_z, quad L = I omega $
$ sum bold(tau)_"ext" = (d bold(L))/(d t), quad I_1 omega_1 = I_2 omega_2 $
$ K = 1/2 M v_"cm"^2 + 1/2 I_"cm" omega^2, quad v_"cm" = R omega $
$ I_P = I_"cm" + M d^2, quad Omega_"prec" = (M g r)/(I omega) $
#v(1pt)
#table(columns: (auto, auto, auto, auto), stroke: none, inset: (x: 2pt, y: 1.5pt),
  column-gutter: (0pt, 6pt, 0pt),
  [varilla (cm)], [$M L^2 \/ 12$], [aro], [$M R^2$],
  [varilla (ext)], [$M L^2 \/ 3$], [disco], [$M R^2 \/ 2$],
  [esfera], [$2 M R^2 \/ 5$], [esf. hueca], [$2 M R^2 \/ 3$],
)
]

#tema[Cuerpo rígido en 3D][
$ bold(v)_B = bold(v)_A + bold(omega) times bold(r)_(B\/A) $
$ bold(a)_B = bold(a)_A + bold(alpha) times bold(r)_(B\/A) + bold(omega) times (bold(omega) times bold(r)_(B\/A)) $
$ (dot(bold(Q)))_"fijo" = (dot(bold(Q)))_"rot" + bold(Omega) times bold(Q) $
$ mat(H_x; H_y; H_z) = mat(I_x, -I_(x y), -I_(x z); -I_(x y), I_y, -I_(y z); -I_(x z), -I_(y z), I_z) mat(omega_x; omega_y; omega_z) $
$ bold(H)_O = macron(bold(r)) times m macron(bold(v)) + bold(H)_G $
$ T = 1/2 m macron(v)^2 + 1/2 bold(omega) dot bold(H)_G $
$ sum M_x = I_x dot(omega)_x - (I_y - I_z) omega_y omega_z quad "(y cícl.)" $
$ sum bold(M)_O = dot(phi) sin theta [I' dot(psi) + (I' - I) dot(phi) cos theta] hat(f) $
$ theta = 90°: quad sum bold(M)_O = I' dot(phi) dot(psi) hat(f) $
$ "libre:" quad dot(phi) = H\/I, quad tan gamma = I/I' tan theta $
]

#tema[Vector de estado y Lagrange][
$ bold(r) = h^2/mu 1/(1 + e cos nu) (cos nu hat(p) + sin nu hat(q)) $
$ bold(v) = mu/h [-sin nu hat(p) + (e + cos nu) hat(q)] $
$ bold(h) = bold(r) times bold(v), quad bold(n) = hat(k) times bold(h) $
$ bold(e) = 1/mu [(v^2 - mu/r) bold(r) - (bold(r) dot bold(v)) bold(v)] $
$ bold(r) = f bold(r)_0 + g bold(v)_0, quad bold(v) = dot(f) bold(r)_0 + dot(g) bold(v)_0 $
$ f = 1 - (mu r)/h^2 (1 - cos Delta nu), quad g = (r r_0)/h sin Delta nu $
$ dot(g) = 1 - (mu r_0)/h^2 (1 - cos Delta nu), quad f dot(g) - dot(f) g = 1 $
]

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

#tema[Marcos no inerciales][
$ bold(v) = dot(r) hat(r) + r dot(theta) hat(theta) $
$ bold(a) = (dot.double(r) - r dot(theta)^2) hat(r) + (r dot.double(theta) + 2 dot(r) dot(theta)) hat(theta) $
$ m bold(a)' = bold(F) - m bold(A) $
$ m bold(a)_"rel" = bold(F) - 2 m bold(Omega) times bold(v)_"rel" $
$ #h(3em) - m bold(Omega) times (bold(Omega) times bold(r)) - m dot(bold(Omega)) times bold(r) $
]

#tema[Constantes][
#table(columns: (auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.5pt),
  [$G$], [$6,674 times 10^(-11)$ N·m²/kg²],
  [$mu_T$], [$398 thin 600$ km³/s²],
  [$R_T$], [$6378$ km],
  [$mu_"Luna"$], [$4903$ km³/s²],
  [$d_"T–L"$], [$384 thin 400$ km],
  [$mu_"Sol"$], [$1,327 times 10^11$ km³/s²],
  [1 UA], [$149,6 times 10^6$ km],
  [$g_0$], [$9,80665$ m/s²],
)
]
