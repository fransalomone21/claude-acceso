// =====================================================================
//  Anexo B — Formulario
//  Las ecuaciones etiquetadas de los 21 módulos, TRAÍDAS de su módulo al
//  compilar: no hay una sola copiada acá. Lo mide verificar-anexos.py.
// =====================================================================

#import "../plantilla.typ": *

// `#ec(<clave>)[qué es]` busca la ecuación con esa etiqueta en el documento
// compilado y la vuelve a mostrar, con el número y la página que tiene en
// su módulo y un link que salta ahí. El cuerpo de la ecuación NO está
// escrito en este archivo: si alguien corrige la del módulo --la fase 11
// corrigió una enmarcada--, el formulario se corrige solo en la próxima
// compilación. Una copia hubiera divergido la primera vez.
//
// Una etiqueta que no existe no se imprime en blanco: `query(...).first()`
// sobre una lista vacía rompe la compilación, igual que `#M()`.
#let ec(clave, que) = context {
  let el = query(clave).first()
  let loc = el.location()
  let n = counter(math.equation).at(loc)
  let pag = counter(page).at(loc).first()
  block(breakable: false, width: 100%, above: 9pt, below: 9pt)[
    #grid(
      columns: (1fr, auto),
      column-gutter: 10pt,
      text(size: 9.5pt)[#que],
      link(loc, text(size: 8.5pt, fill: c-azul)[ec.~#numbering("(1)", ..n), pág.~#pag]),
    )
    #v(-6pt)
    #math.equation(block: true, numbering: none, el.body)
  ]
}

#let del-modulo(clave, titulo) = subtitulo-anexo[Módulo #M(clave) — #titulo]

#anexo("B", "Formulario", [
  Las ecuaciones con número de los veintiún módulos, en el orden en que
  aparecen, cada una con una línea que dice *qué es y cuándo vale*. No
  están copiadas: el formulario las trae de su módulo al compilar, así que
  no pueden quedar desactualizadas. El número de la derecha es un link a
  la ecuación en su lugar, con la deducción alrededor. Sirve para buscar,
  no para estudiar: una fórmula sin la hipótesis de la que sale es la
  manera más rápida de resolver bien el problema equivocado.
])

*Cómo se lee.* Cada entrada tiene a la derecha el número de la ecuación
*dentro de su módulo* y la página donde está; el módulo lo dice el
subtítulo. Todas las ecuaciones numeradas del apunte están acá salvo
catorce, que son *pasos intermedios* de una deducción —los renglones de
la esfera de influencia antes de llegar al exponente 2/5, las componentes
sueltas de los coeficientes de Lagrange— o, en un caso, el criterio
ingenuo de la esfera de influencia que el módulo #M("esfera-influencia")
presenta para demolerlo. Ponerlo en un formulario sería invitar a usarlo.
La lista de las catorce, con el motivo de cada una, está en
`verificar-anexos.py`, que es el que mide que no falte ninguna otra.

Los valores numéricos ($mu_T$, $R_T$, $G$…) están en el Anexo C, y las
letras que cada libro usa distinto que el apunte, en el Anexo D.

// ---------------------------------------------------------------------
#del-modulo("marcos", "Marcos de referencia")

#ec(<marcos-galileo>)[Transformación de Galileo: posición vista desde un
marco que se traslada con velocidad constante $bold(V)$.]

#ec(<marcos-inercia>)[Segunda ley en un marco que acelera en línea recta
con $bold(A)$, sin girar: aparece la fuerza ficticia $-m bold(A)$.]

#ec(<marcos-rotante>)[Aceleración vista desde un marco que gira con
$bold(Omega)$ *constante*: Coriolis más centrípeta.]

#ec(<marcos-rotante-f>)[La misma, como segunda ley en el marco rotante:
Coriolis y centrífuga pasan al lado de las fuerzas.]

// ---------------------------------------------------------------------
#del-modulo("cantidad-movimiento", "Cantidad de movimiento")

#ec(<cant-segunda-ley>)[Segunda ley escrita con la cantidad de movimiento
$bold(p) = m bold(v)$.]

// ---------------------------------------------------------------------
#del-modulo("centro-de-masa", "Centro de masa")

#ec(<cm-def>)[Posición del centro de masa.]

#ec(<cm-p>)[La cantidad de movimiento total es la de la masa total
moviéndose con el centro de masa.]

#ec(<cm-teorema>)[Teorema del centro de masa: sólo las fuerzas
*externas* lo aceleran.]

// ---------------------------------------------------------------------
#del-modulo("cohete", "Propulsión")

#ec(<coh-empuje>)[Empuje sin fuerzas externas: $mu$ es el caudal
másico y $bold(v)_r$ la velocidad de los gases *relativa al cohete*.]

#ec(<coh-movimiento>)[Ecuación de movimiento del cohete con fuerzas
externas $bold(f)_e$.]

#ec(<coh-vertical>)[Ascenso vertical con caudal constante y $g$
constante.]

#ec(<coh-tsiolkovsky>)[Tsiolkovsky con la pérdida por gravedad; sin
gravedad se borra el último término.]

// ---------------------------------------------------------------------
#del-modulo("trabajo-energia", "Trabajo y energía")

#ec(<ener-trabajo>)[Trabajo de una fuerza a lo largo de una trayectoria.]

#ec(<ener-teorema>)[Teorema trabajo–energía: el trabajo *total* es la
variación de la energía cinética.]

#ec(<ener-gradiente>)[La fuerza conservativa sale de la energía
potencial.]

// ---------------------------------------------------------------------
#del-modulo("gravitacion", "Gravitación")

#ec(<grav-newton>)[Ley de gravitación de Newton, en módulo.]

#ec(<grav-newton-vec>)[La misma, como vector: siempre hacia el cuerpo
que atrae.]

#ec(<grav-g>)[Aceleración de la gravedad en la superficie, con
$mu_T = G m_T$.]

#ec(<grav-U>)[Energía potencial gravitatoria, con el cero en el
infinito.]

#ec(<grav-vesc>)[Velocidad de escape desde una distancia $R$ al centro.]

#ec(<grav-vcirc>)[Velocidad de una órbita circular de radio $r$.]

#ec(<grav-T>)[Período de la órbita circular.]

#ec(<grav-E>)[Energía mecánica de la órbita circular: negativa, y la
mitad de la potencial.]

#ec(<grav-raiz2>)[El escape pide $sqrt(2)$ veces la velocidad circular a
la misma distancia.]

// ---------------------------------------------------------------------
#del-modulo("momento-angular", "Momento angular")

#ec(<angm-def>)[Momento angular de una partícula respecto de $O$.]

#ec(<angm-modulo>)[Su módulo: $d$ es el brazo, la distancia de $O$ a la
recta de la velocidad.]

#ec(<angm-tau>)[El torque respecto de $O$ cambia el momento angular
respecto del mismo $O$.]

#ec(<angm-conserva>)[Con fuerza central, $bold(L)_O$ se conserva:
movimiento plano.]

#ec(<angm-h>)[Momento angular específico $h = L\/m$; $gamma$ es el ángulo
de trayectoria, medido desde la horizontal local.]

#ec(<angm-areas>)[Velocidad areolar constante: la segunda ley de Kepler.]

// ---------------------------------------------------------------------
#del-modulo("dos-cuerpos", "Dos cuerpos")

#ec(<dosc-relativa>)[Movimiento relativo de dos cuerpos: ojo que acá
$mu = G(m_1 + m_2)$, no $G m_1$.]

#ec(<dosc-posiciones>)[Posiciones de cada cuerpo respecto del centro de
masa, a partir de la relativa.]

#ec(<dosc-reducida>)[Energía cinética del par vista desde el CM, y la
masa reducida.]

// ---------------------------------------------------------------------
#del-modulo("orbita-conicas", "La ecuación de la órbita")

#ec(<orb-E>)[Energía en polares: el término de $L$ se agrupa con $U$.]

#ec(<orb-Uef>)[Potencial eficaz.]

#ec(<orb-r0>)[Radio de la órbita circular: el mínimo del potencial
eficaz.]

#ec(<orb-Emin>)[La energía mínima posible para un $h$ dado: la de la
circular.]

#ec(<orb-binet>)[Ecuación de la órbita en $u = 1\/r$ y $theta$ (Binet).]

#ec(<orb-orbita>)[La órbita es una cónica, con $nu$ la anomalía verdadera
medida desde el periapsis.]

#ec(<orb-e-E>)[El puente entre energía y excentricidad: $E < 0$ si y
sólo si $e < 1$.]

#ec(<orb-visviva>)[Energía de la elipse, y la vis-viva: la velocidad en
cualquier punto sabiendo sólo $r$ y $a$.]

#ec(<orb-energia-especifica>)[Energía específica $epsilon = E\/m$.]

#ec(<orb-absides>)[Periapsis, apoapsis y la excentricidad a partir de
los dos.]

#ec(<orb-semiejes>)[Semiejes y semilado recto de la elipse.]

#ec(<orb-suma-inversos>)[La suma de las inversas de los ábsides sólo
depende de $h$.]

// ---------------------------------------------------------------------
#del-modulo("kepler", "Leyes de Kepler")

#ec(<kep-tau-ab>)[Período de la elipse como área sobre velocidad
areolar.]

#ec(<kep-periodo>)[Tercera ley: el período sólo depende de $a$.]

// ---------------------------------------------------------------------
#del-modulo("maniobras", "Maniobras")

#ec(<man-at>)[Semieje de la elipse de Hohmann entre dos circulares
coplanares.]

#ec(<man-deltav>)[Los dos encendidos de Hohmann; las primas son las
velocidades en la elipse de transferencia.]

#ec(<man-tv>)[Tiempo de vuelo de Hohmann: medio período de la elipse.]

#ec(<man-fase>)[Ángulo de fase al partir para encontrarse con un blanco
de movimiento medio $n_2$.]

#ec(<man-fasaje>)[Período de la órbita de fasaje para recuperar un
desfase $Delta phi$ en una vuelta.]

#ec(<man-fasaje-a>)[El mismo fasaje, traducido a semieje con la tercera
ley.]

// ---------------------------------------------------------------------
#del-modulo("hiperbola", "La hipérbola")

#ec(<hip-parabola>)[La parábola: $e = 1$, energía nula.]

#ec(<hip-vesc>)[En la parábola la velocidad es la de escape en todo
punto.]

#ec(<hip-nuinf>)[Anomalía verdadera de la asíntota.]

#ec(<hip-a>)[Semieje de la hipérbola, positivo con esta convención.]

#ec(<hip-rp>)[Periapsis, distancia al vértice de la otra rama y semieje
menor de la hipérbola.]

#ec(<hip-delta>)[Ángulo de desvío entre las dos asíntotas.]

#ec(<hip-energia>)[Energía de la hipérbola: positiva.]

#ec(<hip-vinf>)[Velocidad hiperbólica en exceso y $C_3$.]

#ec(<hip-vr>)[Componentes de la velocidad en cualquier cónica.]

#ec(<hip-gamma>)[Ángulo de trayectoria en cualquier cónica.]

// ---------------------------------------------------------------------
#del-modulo("esfera-influencia", "Esfera de influencia y cónicas parcheadas")

#ec(<soi-soi>)[Radio de la esfera de influencia de Laplace de un planeta
de masa $m_p$ a una distancia $R$ del Sol.]

#ec(<soi-pegado>)[Condición de pegado: la $v_oo$ de la hipérbola es la
velocidad *relativa* al planeta.]

#ec(<soi-e>)[Excentricidad de la hipérbola de salida a partir del
periapsis y de $v_oo$.]

#ec(<soi-vp>)[Velocidad en el periapsis de la hipérbola de salida.]

#ec(<soi-dv>)[Encendido de salida desde una órbita circular de
estacionamiento de velocidad $v_c$.]

// ---------------------------------------------------------------------
#del-modulo("perifocal-lagrange", "Marco perifocal y coeficientes de Lagrange")

#ec(<perif-r-orbita>)[Posición en el marco perifocal, con la ecuación de
la órbita adentro.]

#ec(<perif-v>)[Velocidad en el marco perifocal.]

#ec(<perif-tres>)[Los tres vectores que salen del estado: momento
angular, línea de nodos y excentricidad.]

#ec(<perif-elementos>)[Argumento del periapsis y anomalía verdadera
inicial, desde esos vectores.]

#ec(<perif-fg>)[Definición de los coeficientes de Lagrange.]

#ec(<perif-wronskiano>)[La identidad que los ata: sirve de control de
cuentas.]

#ec(<perif-fg-dnu>)[$f$ y $g$ en función de lo que giró la nave,
$Delta nu$.]

#ec(<perif-fgpunto-dnu>)[$dot(f)$ y $dot(g)$ en función de $Delta nu$.]

#ec(<perif-r-dnu>)[El radio después de girar $Delta nu$, sólo con el
estado inicial.]

#ec(<perif-serie>)[$g$ en serie de $Delta t$: vale para intervalos
cortos.]

// ---------------------------------------------------------------------
#del-modulo("tres-cuerpos", "Tres cuerpos y los puntos de Lagrange")

#ec(<tres-omega>)[Velocidad angular del marco que gira con los dos
primarios, con $mu = G(m_1 + m_2)$.]

#ec(<tres-pi>)[Posiciones de los primarios en ese marco, con las
fracciones de masa $pi_1$ y $pi_2$.]

#ec(<tres-r12>)[Posición de la nave respecto de cada primario.]

#ec(<tres-mov-x>)[Ecuación de movimiento en $x$ en el marco rotante.]

#ec(<tres-mov-y>)[En $y$.]

#ec(<tres-mov-z>)[En $z$: sin Coriolis ni centrífuga.]

#ec(<tres-l45>)[Posición de $L_4$ y $L_5$: los triángulos equiláteros.]

#ec(<tres-colineales>)[La ecuación de quinto grado de los tres
colineales; se resuelve numéricamente.]

#ec(<tres-hill>)[Radio de la esfera de Hill.]

#ec(<tres-razon>)[Hill contra Laplace: dependen casi igual de las
masas.]

#ec(<tres-estable>)[Condición de Routh para que $L_4$ y $L_5$ sean
estables.]

#ec(<tres-routh>)[La misma, como número y como fracción de masa.]

#ec(<tres-jacobi>)[Constante de Jacobi: la única integral del problema
restringido.]

#ec(<tres-potj>)[Potencial de Jacobi, y la constante escrita con él.]

#ec(<tres-prohibido>)[Dónde puede estar la nave: fuera de ahí, $v^2$
sería negativo.]

// ---------------------------------------------------------------------
#del-modulo("rotacion", "Rotación alrededor de un eje fijo")

#ec(<rot-omega>)[Velocidad angular alrededor del eje $z$.]

#ec(<rot-v>)[Velocidad y aceleraciones de un punto a distancia $r$ del
eje.]

#ec(<rot-energia>)[Momento de inercia respecto del eje, y la energía de
rotación.]

#ec(<rot-steiner>)[Steiner: el eje por $P$ paralelo al del centro de
masa, a distancia $d$.]

#ec(<rot-torque>)[Torque de una fuerza; $l$ es el brazo de palanca.]

#ec(<rot-tau-ialfa>)[Segunda ley de la rotación, con el eje fijo.]

#ec(<rot-traslacion>)[Rotación y traslación a la vez: energía y las dos
ecuaciones, con todo referido al centro de masa.]

#ec(<rot-l-iw>)[Momento angular sobre el eje de simetría. Fuera de un
eje de simetría $bold(L)$ no es paralelo a $bold(omega)$.]

#ec(<rot-tau-dl>)[Forma general: el torque externo cambia el momento
angular.]

#ec(<rot-conserva>)[Conservación con torque externo nulo.]

#ec(<rot-precesion>)[Velocidad de precesión del giróscopo, con el spin
mucho mayor que la precesión.]

// ---------------------------------------------------------------------
#del-modulo("cinematica-cr", "Cinemática del cuerpo rígido")

#ec(<cin-v>)[Velocidad de un punto de un cuerpo con un punto fijo.]

#ec(<cin-a>)[Su aceleración.]

#ec(<cin-suma>)[Las velocidades angulares se suman como vectores (las
rotaciones finitas, no).]

#ec(<cin-derivada>)[Derivada de un vector en el sistema fijo, a partir de
la derivada en uno que gira con $bold(Omega)$.]

#ec(<cin-vgen>)[Movimiento general: velocidad de $B$ desde la de $A$.]

#ec(<cin-agen>)[Aceleración de $B$ desde la de $A$.]

#ec(<cin-coriolis-v>)[Velocidad de una partícula que se mueve respecto de
un sistema que rota.]

#ec(<cin-coriolis-a>)[Su aceleración: con $dot(bold(Omega))$ y el
término de Coriolis.]

// ---------------------------------------------------------------------
#del-modulo("inercia", "Momento de inercia y ejes principales")

#ec(<iner-tensor>)[El tensor de inercia: los productos entran con signo
menos.]

#ec(<iner-diagonal>)[En ejes principales el tensor es diagonal.]

#ec(<iner-ho>)[Momento angular respecto de un punto cualquiera $O$.]

#ec(<iner-energia>)[Energía cinética del cuerpo rígido: König.]

// ---------------------------------------------------------------------
#del-modulo("euler-giroscopo", "Ecuaciones de Euler y giróscopo")

#ec(<euler-derivada-h>)[Derivada de $bold(H)_G$ con ejes que giran con
$bold(Omega)$.]

#ec(<euler-euler-clasicas>)[Ecuaciones de Euler en ejes principales; las
de $x$ y $y$ salen por permutación cíclica, y están arriba de ésta en el
módulo.]

#ec(<euler-precesion-estable>)[Precesión estable ($theta$,
$dot(phi)$ y $dot(psi)$ constantes) de un cuerpo con simetría axial;
$I$ transversal, $I'$ axial.]

#ec(<euler-precesion-90>)[El caso $theta = 90°$.]

// ---------------------------------------------------------------------
#del-modulo("peonza", "Peonza simétrica")

#ec(<peon-precesion-libre>)[Precesión libre de un cuerpo simétrico sin
cuplas; $I$ transversal.]

#ec(<peon-tan-gamma>)[Ángulo $gamma$ entre $bold(omega)$ y el eje de
simetría, contra el ángulo $theta$ de $bold(H)_G$.]
