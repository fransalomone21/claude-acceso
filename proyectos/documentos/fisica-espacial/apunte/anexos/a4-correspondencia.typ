// =====================================================================
//  Anexo D — Correspondencia de notación
//  Una fila por símbolo o nombre que cambia entre este apunte, la cátedra
//  y los libros. Cada fila sale de una marca "Ojo con la notación" de un
//  módulo (o de una página medida de un libro), y dice en qué módulo está
//  explicada: el anexo junta, no explica.
// =====================================================================

#import "../plantilla.typ": *

#anexo("D", "Correspondencia de notación", [
  Las letras que cambian de un libro a otro, en una sola tabla. Cada libro
  eligió las suyas sin consultar a los otros, y la cátedra, en la hoja de
  clase, eligió las propias sin consultar a ninguno. El resultado es que la
  misma ecuación aparece con tres caras, y una fórmula copiada del Beer con
  la letra del Sears da una ecuación que parece correcta y es otra cosa.
  La columna de la derecha dice en qué módulo está explicado cada caso.
])

*Cómo se lee.* La primera columna es *qué es*; la segunda, la letra que
usa este apunte —que es la de la cátedra salvo donde se dice—; la
tercera, cómo aparece en otro lado. Si un símbolo no está acá, es porque
todos los libros de la bibliografía lo escriben igual. Los dos choques más
caros son los primeros: el Beer da vuelta $bold(L)$ y $bold(H)$, y $mu$
quiere decir cuatro cosas distintas según quién la escriba.

#let fila(que, apunte, otros, clave) = (
  text(size: 9pt)[#que],
  align(center, text(size: 10pt)[#apunte]),
  text(size: 9pt)[#otros],
  align(center, text(size: 9pt)[#M(clave)]),
)

// Sin justificar: en celdas angostas, el justificado abre huecos de medio
// renglón ("caudal     másico     del").
#set par(justify: false)

#table(
  columns: (2.8cm, 3.9cm, 1fr, 1.0cm),
  inset: (x: 5pt, y: 5pt),
  align: horizon,
  table.header(
    ..([Qué es], [Este apunte], [En otro lado], [Mód.]).map(t => text(size: 8.5pt, weight: "bold", fill: c-azul)[#t]),
  ),
  ..fila([cantidad de movimiento lineal], [$bold(P)$, $bold(p) = m bold(v)$],
    [Beer: $bold(L)$. Roederer: $bold(p)$, pero la llama *impulso* (pág. 111).
    La cátedra, con tres signos de admiración: «ojo!!! Notación L es H y P
    es L».],
    "cantidad-movimiento"),
  ..fila([momento angular (la cátedra también dice *impulso angular*)],
    [$bold(L)$, $bold(L)_O$],
    [Beer: $bold(H)_O$, y para un cuerpo rígido $bold(H)_G$ — que el apunte
    adopta desde el módulo #M("inercia") en adelante, porque ahí se trabaja
    con el Beer.], "momento-angular"),
  ..fila([impulso], [$integral bold(F) thin d t$],
    [Roederer usa la palabra para $m bold(v)$. La cátedra la reserva para
    la fuerza por el tiempo, y el apunte también.], "cantidad-movimiento"),
  ..fila([momento de una fuerza (torque)], [$bold(tau)$, $bold(tau)_O$],
    [Beer: $bold(M)_O$, y así lo escribe el apunte en las ecuaciones de
    Euler.], "momento-angular"),
  ..fila([«razón de cambio»], [$d \/ d t$],
    [Beer, en castellano: *razón de cambio* quiere decir derivada respecto
    del tiempo. No hay ningún cociente escondido.], "momento-angular"),
  ..fila([parámetro gravitatorio], [$mu = G(m_1 + m_2)$],
    [Curtis y Bate: igual. Roederer, Landau y Goldstein: $mu$ es la *masa
    reducida*. La hoja de clase escribe $alpha$ (ver la fila de $U$).],
    "dos-cuerpos"),
  ..fila([masa reducida], [$m_r = (m_1 m_2) / (m_1 + m_2)$],
    [Roederer y la mecánica clásica: $mu$. La cátedra lo marcó con una
    flecha: «no confundir con masa reducida».], "dos-cuerpos"),
  ..fila([fracciones de masa], [$mu_1 = m_1 \/ M$ \ $mu_2 = m_2 \/ M$],
    [Roederer: las mismas letras, pero las llama *masas reducidas* (pág.
    110), y no lo son: son números sin unidades. Curtis, en tres cuerpos:
    $pi_1$, $pi_2$.], "centro-de-masa"),
  ..fila([caudal másico del cohete], [$mu > 0$],
    [Roederer: igual. S&Z: $-d m \/ d t$, con el signo adentro. Sí: otra
    $mu$ más.], "cohete"),
  ..fila([velocidad de los gases relativa al cohete], [$bold(v)_r$],
    [S&Z: $v_"esc"$. Beer: $u$. Roederer: $abs(bold(v)_r)$.], "cohete"),
  ..fila([versores polares], [$hat(r)$, $hat(theta)$],
    [Beer: $bold(e)_r$, $bold(e)_theta$. Curtis y Bate: $hat(u)_r$, y el
    manuscrito de clase a veces también.], "vectores"),
  ..fila([energía potencial, eficaz y total], [$U$, $U_"ef"$, $E$],
    [Hoja de clase: $V_g$, $V_"eff"$, $E_M$, con $V_g = -alpha \/ r$. Para
    que sea una energía, $alpha = G M m$, no $G M$ como está anotado.],
    "orbita-conicas"),
  ..fila([momento angular, en la hoja del potencial eficaz], [$L$],
    [Hoja de clase: $ell$.], "orbita-conicas"),
  ..fila([energía por unidad de masa], [$epsilon = E \/ m$],
    [La cátedra y Curtis escriben la energía por unidad de masa, sin la $m$,
    y la llaman *energía específica*.], "orbita-conicas"),
  ..fila([momento angular específico], [$h = L \/ m$],
    [Curtis y Beer: $h$, lo mismo. Ojo que el Beer usa $bold(H)$ para el
    momento angular *total*.], "momento-angular"),
  ..fila([parámetro de la órbita], [$p$],
    [Curtis: *parameter* y *semilatus rectum*. Bate: *semi-latus rectum*,
    en todo el capítulo 1.], "orbita-conicas"),
  ..fila([anomalía verdadera], [$nu$],
    [Curtis: $theta$ (y también en el mapa del Apéndice B). Bate: $nu$,
    igual que acá.], "maniobras"),
  ..fila([versores del marco perifocal], [$hat(p)$, $hat(q)$, $hat(w)$],
    [Curtis: igual. Bate: $bold(P)$, $bold(Q)$, $bold(W)$, con ejes $x_omega$,
    $y_omega$, $z_omega$.], "perifocal-lagrange"),
  ..fila([semieje de la hipérbola], [$a > 0$],
    [Curtis: igual, con el signo puesto a mano en la energía. Otros libros y
    todo el software: $a < 0$, y entonces la vis-viva de la elipse vale sin
    cambios.], "hiperbola"),
  ..fila([posición y velocidad, en las cónicas parcheadas],
    [$bold(R)$, $bold(V)$ \ $bold(r)$, $bold(v)$],
    [Convención de Curtis en el capítulo 8: mayúsculas desde el Sol,
    minúsculas desde el planeta.], "esfera-influencia"),
  ..fila([fracciones de masa del problema restringido], [$pi_1$, $pi_2$],
    [Curtis. No tienen nada que ver con el número $pi$.], "tres-cuerpos"),
  ..fila([potencial de Jacobi], [$U_J$],
    [El nombre es de este apunte. Curtis escribe la misma agrupación sin
    nombrarla.], "tres-cuerpos"),
  ..fila([momentos de inercia de un cuerpo con simetría axial],
    [$I$ transversal \ $I'$ axial],
    [Beer: igual. Curtis (§11.8, pág. 583): $A$ transversal y $C$ axial.
    Lo único que decide directa o retrógrada es el signo de $I - I'$, así que
    confundir las dos da vuelta el resultado.], "peonza"),
)
