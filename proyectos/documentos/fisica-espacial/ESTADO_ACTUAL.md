# Estado actual — Apunte de Física Espacial

**Fase 3 (Parte III: gravitación y órbitas) — CERRADA el 2026-08-31.**

**Fase 4 (Parte IV: cuerpo rígido, M12–M15) — ABIERTA el 2026-08-31.** El
mapeo de Beer (capítulos 15 y 18) contra páginas impresas está hecho y
escrito en el `HANDOFF.md`, las cinco figuras en imagen de la guía están
miradas, y los **módulos 12, 13 y 14 están escritos, compilados y verificados en
el render**. Falta M15. El apunte va por **98 páginas**.

| Qué | Estado |
|---|---|
| `apunte/apunte.pdf` | **98 páginas**, compila sin errores, cero huérfanos de caja |
| Plantilla, carátula, índice, encabezados | listos, no se tocan |
| Biblioteca de figuras (CeTZ) | **28 figuras**, todas miradas en la galería |
| Módulos 1 a 5 — Partes I y II | escritos y verificados (fases 1 y 2) |
| **Módulo 6 — Gravitación, peso y energía potencial** | **escrito y verificado en render** |
| **Módulo 7 — Momento angular y fuerzas centrales** | **escrito y verificado en render** |
| **Módulo 8 — Dos cuerpos y masa reducida** | **escrito y verificado en render** |
| **Módulo 9 — Potencial eficaz y ecuación de la órbita** | **escrito y verificado en render** |
| **Módulo 10 — Las leyes de Kepler** | **escrito y verificado en render** |
| **Módulo 11 — Maniobras: Hohmann y rendez-vous** | **escrito y verificado en render** |
| **Módulo 12 — Cinemática del cuerpo rígido y sistemas rotantes** | **escrito y verificado en render** |
| **Módulo 13 — Momento de inercia y ejes principales** | **escrito y verificado en render** |
| **Módulo 14 — Ecuaciones de Euler y el giróscopo** | **escrito y verificado en render** |
| Módulo 15 (Parte IV) | no empezado (el `include` sigue comentado en `apunte.typ`) |
| Anexos | no empezados |

## Lo que hay escrito en la Parte III

**Módulo 6 — Gravitación de Newton, peso y energía potencial** (9 pág.). La ley
de Newton con su signo y su versor; el teorema de la cáscara (citado, no
deducido); $mu = G M$ y por qué tiene letra propia; peso y $g$, con la cuenta
de Cavendish; **la deducción de $U = -mu m \/ r$ que el módulo 5 había dejado
prometida**, con el cero en el infinito explicado como la elección que hace que
el signo de $E$ signifique algo; el pozo de potencial y la tabla que clasifica
la órbita por el signo de $E$; velocidad de escape; y la órbita circular con
$v_"circ"$, $T$, $E = -mu m \/ 2r$ y $v_"esc" = sqrt(2) v_"circ"$. Ejemplos: el
Problema 0 (estimar la masa del Sol, $1,99 times 10^30$ kg) y el Problema 6 de
Beer (subir a la geosíncrona: $90,6$ y $208,3$ GJ), que adentro resuelve de
paso el Problema 3.

**Módulo 7 — Momento angular y fuerzas centrales** (7 pág.). $bold(L) = bold(r)
times m bold(v)$ como brazo de palanca, con el cuadro de por qué hay que
declarar siempre el punto; la tabla de traducción de notación Beer ↔ cátedra;
$sum bold(tau) = d bold(L)\/d t$; fuerza central y sus dos consecuencias —el
movimiento es plano y $r^2 dot(theta)$ es constante—; $h = r v cos gamma$ y por
qué en los ábsides se reduce a $h = r v$; y la segunda ley de Kepler deducida
de la conservación. Contesta la pregunta fina del Ej. 5 con la tabla de las
tres condiciones. Ejemplos: los Problemas 2 y 3 (las dos demostraciones) y el
Ejercicio 4 (el satélite de la figura).

**Módulo 8 — El problema de dos cuerpos y la masa reducida** (6 pág.). Saca la
suposición de que el cuerpo central está fijo; deduce
$bold(accent(r, dot.double)) = -mu bold(r)\/r^3$ con $mu = G(m_1+m_2)$ —y con
eso salva toda la Parte III sin rehacer nada—; las dos elipses semejantes
alrededor del CM; la masa reducida y el problema equivalente; y la tabla de
cuándo importa, con $q = m_2\/m_1$. Ejemplos: el Problema 0 rehecho (lo que se
midió fue $M_"Sol" + M_T$) y el sistema Tierra–Luna construido sobre los datos
del Problema 8 (CM a 4671 km, adentro de la Tierra; el mes da 27,28 días contra
27,45 si se ignora la Luna).

**Módulo 9 — El potencial eficaz y la ecuación de la órbita** (10 pág.). Es el
módulo central de la parte y hace las dos mitades. La cualitativa: sustituir
$dot(theta) = h\/r^2$ adentro de la energía cinética deja
$E = 1/2 m dot(r)^2 + U_"ef" (r)$, un problema de *una* variable al que se le
aplica tal cual el diagrama del módulo 5 — con la barrera centrífuga (por qué
la Luna no se cae), el fondo del pozo en $r_0 = h^2\/mu$ (que reproduce el
$E = -mu m\/2r$ del módulo 6 como *mínimo de una función*) y la clasificación
en cuatro casos por el signo de $E$. La cuantitativa: el cambio de variable
$t arrow.r theta$, $u = 1\/r$, la ecuación de Binet, y su solución
$r = p\/(1 + e cos nu)$; después el puente $e = sqrt(1 + 2 E h^2\/(mu^2 m))$,
que ata las dos mitades, y de ahí $E = -mu m\/(2a)$ y la **vis-viva**. Cierra
con los seis números de la elipse. Ejemplos: el satélite del Ej. 4 rehecho
desde la ecuación de la órbita —$h = 57 thin 172$ km²/s sale ahora de las dos
alturas solas, sin usar ninguna velocidad del dibujo— y el Problema 7 (Beer
13.100, frenar en Júpiter: $Delta v = 14,2$ km/s, y la cuenta de por qué
capturar solo cuesta $0,9$).

**Tres figuras nuevas**, las tres miradas en la galería antes de usarse:
`fig-potencial-eficaz` (la figura 4.1 de la cátedra, redibujada),
`fig-conicas` (las cuatro con el mismo $p$) y `fig-elipse-geometria`.

**Módulo 10 — Las leyes de Kepler** (6 pág.). Muestra que las tres leyes de
Kepler no son un agregado: la primera es la ecuación de la órbita del módulo 9
evaluada en $0<e<1$; la segunda es la conservación del momento angular del
módulo 7; y la tercera —lo único nuevo— sale de integrar la
velocidad areolar sobre el área de la elipse, $tau = 2 pi a b \/ h$ (Beer
ec. 12.45), y de reemplazar $b$ y $h$ hasta quedar en $tau = 2 pi a^(3\/2) \/
sqrt(mu)$: la misma fórmula del módulo 6 con $a$ en el lugar de $r$. El cuadro
rojo central: por qué la ley *exacta* no dice que $T^2\/a^3$ sea igual para
todos los planetas —$mu$ depende de las dos masas, módulo 8—. Ejemplos: el
Problema 4 (S&Z 13.67, el satélite del módulo 9: período $tau = 7907$ s y la
comparación de escape, $Delta v_p = 2,41$ contra $Delta v_a = 3,26$ km/s) y los
Problemas 8 y 9 juntos (el LEM del Apollo: sube por una transferencia tipo
Hohmann hasta encontrarse con el módulo de mando a $30$ m/s de relativa, y
después baja y se estrella a $79,2°$ de la vertical).

**Módulo 11 — Maniobras: Hohmann y rendez-vous** (7 pág.). Cierra la Parte
III. Deduce la transferencia de Hohmann —por qué la elipse tangente a las dos
circulares es la más barata, con la vis-viva del módulo 9 en cada ábside— y el
tiempo de vuelo como medio período de la elipse de transferencia (módulo 10
partido a la mitad); y el rendez-vous por *órbita de fasaje*, con la relación
$T' \/ T =
1 - Delta phi \/ 360°$ que reduce el problema del reencuentro a un cambio de
tamaño de órbita. Ejemplos: el Problema 5 (Hohmann a Marte: $258,8$ días de
viaje y $44,4°$ de ángulo de fase en el lanzamiento) y el Problema 10 —abierto
en la guía— resuelto con el método general más un caso numérico concreto
(rendez-vous geosíncrono a un cuarto de vuelta, $Delta v = 698$ m/s en una
sola vuelta de fasaje). Cierra con el Road Map de Curtis (ap. B) redibujado en
CeTZ: los once resultados de la Parte III, de las leyes de Newton hasta las
ecuaciones de Kepler, en un solo diagrama de flujo.

**Cuatro figuras nuevas**, las cuatro miradas en la galería antes de usarse:
`fig-hohmann`, `fig-rendezvous-phasing` y `fig-roadmap-curtis` (módulo 11), más
la reutilización de `fig-elipse-geometria` y `fig-satelite-guia` por
referencia en los ejemplos del módulo 10.

## Lo que hay escrito en la Parte IV

**Módulo 12 — Cinemática del cuerpo rígido y sistemas rotantes** (7 pág.).
Abre la parte y es la herramienta de la que dependen los otros tres módulos.
El teorema de Euler —todo movimiento con un punto fijo es una rotación
alrededor de un eje— con su demostración sobre la esfera; el eje instantáneo,
$bold(v) = bold(omega) times bold(r)$ y la aceleración con sus dos términos,
más la advertencia de que $bold(alpha)$ *no* va sobre el eje instantáneo
(cosa que en movimiento plano nunca pasa); la demostración de que las
velocidades angulares se suman como vectores aunque las rotaciones finitas
no; el cono espacial y el cono corporal; **la derivada de un vector en un
sistema que rota** —el resultado central, y el que en el módulo 14 produce
las ecuaciones de Euler—, con la observación de que los versores polares del
módulo 1 son ese mismo teorema en su caso más chico; la distinción entre la
velocidad angular del *sistema* y la del *cuerpo*, que es donde se pierde el
planteo; el movimiento general de dos puntos cualesquiera; y Coriolis en tres
dimensiones, con la comprobación de que la aceleración en polares del módulo
1 es exactamente esa fórmula término por término. Ejemplos: las mitades
cinemáticas de los Problemas 2 (el disco en la horquilla:
$bold(alpha) = omega_1 omega_2 hat(i)$ con las dos rapideces constantes) y 3
(el volante en el gimbal: $bold(alpha) = 50 hat(i)$ rad/s², que es el efecto
giroscópico visible antes de escribir una sola ecuación de la dinámica).

**Tres figuras nuevas**, las tres miradas en la galería antes de usarse:
`fig-vector-rotante` (los dos casos de la derivada en un sistema rotante),
`fig-suma-omegas` (el Problema 2, con el eje instantáneo) y `fig-conos` (el
cono espacial y el corporal). La última estaba anotada en `docs/figuras.md`
como «la figura más difícil del apunte, probablemente necesite proyección 3-D
de CeTZ»: **no la necesitó**. Salió con la sección axial más un helper nuevo
de `estilo.typ`, `circulo-escorzo`, que proyecta un círculo del espacio como
la elipse que se ve de costado. Los módulos 14 y 15 la reusan cambiándole los
dos semiángulos.

**Módulo 13 — Momento de inercia y ejes principales** (5 pág.). Extiende
$H_G = I omega$ del plano al espacio: la deducción por integrales de
$bold(H)_G = integral bold(r) times (bold(omega) times bold(r)) dm$, con la
identidad BAC-CAB, hasta llegar a los momentos y productos de inercia (ecs.
18.4 a 18.7); el tensor de inercia como matriz simétrica de $3 times 3$ (ec.
18.8) y la existencia de ejes principales donde diagonaliza (ec. 18.9,
citada del Beer, no deducida —la demostración vive en el volumen de Estática
que no está disponible); el cuadro central de por qué $bold(H)_G$ y
$bold(omega)$ no son paralelos salvo sobre un eje principal (ec. 18.10);
$bold(H)_O = bold(macron(r)) times m bold(macron(v)) + bold(H)_G$ (ec.
18.11); y la energía cinética deducida por triple producto escalar hasta
$T = 1/2 bold(omega) dot bold(H)_G$ (ecs. 18.16, 18.17, 18.20). Ejemplos: el
Problema 1 (el satélite cúbico: tensor isótropo, $bold(omega) = 0,2 hat(j) -
0,2 hat(k)$ rad/s tras el encendido, y por qué sigue girando para siempre) y
el Problema 2 punto 1 (el disco de la horquilla: $bold(H)_G$ no paralelo a
$bold(omega)$, demostrado en números con $I_z = 2 I_x$).

**Sin figuras nuevas.** Reusa `fig-suma-omegas` del módulo 12 —los mismos
ejes de la horquilla sirven para calcular $bold(H)_G$ que para calcular
$bold(omega)$—, con un nuevo epígrafe.

**Módulo 14 — Ecuaciones de Euler y el giróscopo** (4 pág.). Aplica la
@m12-derivada a $bold(H)_G$ y llega a la relación general $dot(bold(H))_G =
(dot(bold(H))_G)_(O x y z) + bold(Omega) times bold(H)_G$ (ecs. 18.22/18.23,
y su versión con punto fijo, ecs. 18.27/18.28); de ahí salen las ecuaciones
de Euler clásicas ($bold(Omega) = bold(omega)$, ec. 18.25) y, por el camino
que los dos ejemplos usan de verdad, el caso $bold(Omega) != bold(omega)$
—ejes que acompañan la simetría del cuerpo sin girar con su espín, la
recomendación que el módulo 12 ya había dejado picando—. Cierra con los
ángulos de Euler (φ precesión, θ nutación, ψ giro, §18.9) y la derivación de
la cupla que sostiene una precesión estable (ecs. 18.40–18.44), con el caso
particular $theta=90degree$ (ec. 18.45). Ejemplos: el Problema 2 punto 2 (la
cupla del disco, $dot(bold(H))_G = 1/2 m r^2 omega_1 omega_2 hat(i)$, la
misma dirección que el $bold(alpha)$ del módulo 12) y el Problema 3 completo
(el volante en el gimbal: $600$ N·m de torque dan sólo $20$ rad/s² de
aceleración del gimbal, porque $500$ N·m se gastan en sostener la dirección
de $bold(H)_O$). Sin figuras nuevas.

## Lo verificado contra las fuentes en esta fase

| Afirmación | Fuente, medida |
|---|---|
| Ley de Newton, $G$ | S&Z §13.1, ec. 13.1, pág. 399 |
| Peso, $g = G m_T \/ R_T^2$, peso a altura $r$ | S&Z ecs. 13.3, 13.4 y 13.5, pág. 403 |
| Teorema de la cáscara | S&Z §13.6, pág. 413–415 (citado) |
| $W_"grav"$, $F_r$, $U = -G m_T m \/ r$ | S&Z ecs. 13.6 a 13.9, pág. 405 |
| Velocidad de escape | S&Z ejemplo 13.5, pág. 406 |
| $v_"circ"$, $T$, $E = -mu m \/ 2r$, $v_"esc" = sqrt(2) v_"circ"$ | S&Z ecs. 13.10 a 13.13, pág. 407–409 |
| Velocidad areolar y 2.ª de Kepler | S&Z ecs. 13.14 a 13.16, pág. 410–411 |
| $bold(H)_O = bold(r) times m bold(v)$, $H_O = r m v sin phi$ | Beer §12.7, ecs. 12.12 y 12.13, pág. 721–722 |
| $H_O = m r^2 dot(theta)$, $sum bold(M)_O = dot(bold(H))_O$ | Beer ecs. 12.17 a 12.19, pág. 723 |
| Fuerza central, $bold(H)_O$ constante, movimiento plano | Beer §12.9, ecs. 12.23 y 12.24, pág. 724 |
| $r m v sin phi$ constante, $r^2 dot(theta) = h$, velocidad areolar | Beer ecs. 12.25 a 12.27, pág. 725 |
| Movimiento relativo, masa reducida, problema equivalente | apunte de clase 23/9 (escaneo manuscrito), pág. 1 y 2 |
| **Dos erratas de signo en el apunte de clase 23/9** | pág. 1, **confirmadas** ampliando el escaneo |
| Ecuaciones de movimiento en polares con fuerza central | Beer ecs. 12.31 y 12.32, pág. 736 |
| Cambio de variable $u = 1\/r$ y ecuación de Binet | Beer ecs. 12.35 a 12.37, pág. 736 |
| $u'' + u = mu\/h^2$, y su solución cónica | Beer ecs. 12.38 y 12.39, pág. 737 |
| Excentricidad y forma $r = p\/(1 + e cos nu)$ | Beer ecs. 12.40 y 12.39', pág. 737 |
| Clasificación por $e$ (hipérbola, parábola, elipse) | Beer §12.12, pág. 738 |
| $a = (r_p + r_a)\/2$, $b = sqrt(r_p r_a)$ | Beer ecs. 12.46 y 12.47, pág. 740 |
| $1\/r_p + 1\/r_a = 2 mu\/h^2$ | Beer, problema 12.102, citada en pág. 744 |
| Potencial eficaz, y su gráfico con los cuatro niveles | apunte de clase, `potencial eficaz.pdf` y `_2.pdf` |
| **Errata de signo delante de $U(r)$** | pág. 3 del escaneo del 23/9, **confirmada** a 300 dpi |
| **Errata $alpha = G M$ donde va $G M m$** | hoja `potencial eficaz.pdf`, **confirmada** |
| Los 40 enunciados de la guía | transcriptos en `fuentes/GUIA-ENUNCIADOS.md` |
| $tau = 2 pi a b \/ h$ (tercera ley de Kepler) | Beer ec. 12.45, pág. 739 |
| $a = (r_p+r_a)\/2$, $b = sqrt(r_p r_a)$, reusadas con período | Beer ecs. 12.46 y 12.47, pág. 740 (ya citadas en el módulo 9) |
| $mu_L = 0,01230 mu_T$ (masa de la Luna, Problema 8) | dato de la guía, coherente con el módulo 8 |
| El satélite del Problema 4 es el mismo del Ej. 4 (módulos 7 y 9) | verificado por los tres caminos (h, ecuación de la órbita, vis-viva) dando el mismo número |
| Ecuaciones de movimiento en polares, $u=1\/r$, Binet — reusadas para la transferencia de Hohmann | Beer ecs. 12.31 a 12.39, pág. 736–737 (ya citadas en el módulo 9) |
| El Road Map, fig. B.1 de Curtis, apéndice B | escaneo en `Downloads\Road Map.pdf`, renderizado a 250–400 dpi y leído entero, con la anotación manuscrita $mu=G(m_1+m_2)$ |
| Datos orbitales de Marte (apéndice F): $r=2,279 times 10^8$ km, $tau=686,98$ días | S&Z apéndice F |
| **Fase 4 — todo lo de abajo se leyó en el Beer en esta sesión** | offset medido: pág. impresa = pág. del PDF + 575 |
| Teorema de Euler; eje instantáneo; $bold(v)$ y $bold(a)$ de un punto | Beer §15.12, ecs. 15.37 a 15.39, pág. 988–989 |
| Cono espacial y cono corporal | Beer §15.12, fig. 15.33, pág. 989 |
| Las velocidades angulares se suman como vectores | Beer ec. 15.40, pág. 990–991 |
| Derivada de un vector en un sistema rotante | Beer §15.10, ec. 15.31, pág. 975–976 |
| Movimiento general de dos puntos del cuerpo | Beer ecs. 15.43 y 15.44, pág. 991 |
| Coriolis en tres dimensiones, y cuándo se anula | Beer ecs. 15.45 y 15.47, pág. 1002–1003 |
| Sistema de referencia en movimiento general | Beer ecs. 15.52 y 15.54, pág. 1004 |
| El sistema puede girar *menos* que el cuerpo ($bold(Omega) != bold(omega)$) | Beer §18.5, pág. 1170 |
| Mapa completo del capítulo 18 (ecuación a ecuación, con página impresa) | escrito en `HANDOFF.md`; leído por capa de texto |
| Las figuras en imagen de los Problemas 2, 3, 4, 7 y 9 de la guía | renderizadas de las pág. 15–18 del PDF de la guía, y miradas |
| **El enunciado del Problema 2 contradice a su figura** | el enunciado dice «eje vertical» y la figura muestra el eje del disco horizontal; se tomó la figura |
| $mu_"Sol" = 1,327 times 10^11$ km³/s² | S&Z apéndice F |

## Lo que NO está verificado todavía

Nada de los módulos 1 a 12 quedó sin fuente. Para los módulos 13 a 15 el
material está **leído y mapeado** —la tabla del capítulo 18 está en el
`HANDOFF.md`, con página impresa por ecuación— pero todavía no está escrito.

Dos cosas quedan medidas a medias y hay que cerrarlas cuando el módulo las
use, no antes:

- **Las coordenadas exactas de los cohetes A y B del Problema 7** (la cápsula
  espacial). La figura da el tronco de cono con sus tres medidas, pero las
  posiciones de A y B hay que volver a medirlas sobre la imagen: de ellas
  depende el brazo de palanca y con él todo el resultado.
- **Los ejes principales de inercia no están deducidos en el libro que hay.**
  El temario manda «Beer vol. 1, §§9.16 y 9.17», que es la *Estática*, y el
  PDF disponible es sólo la *Dinámica*. El §18.2 (pág. 1153) afirma que
  siempre existen pero no lo demuestra. Para el módulo 13 alcanza, porque la
  guía da todos los datos por radios de giro.

## Lo que sigue

**Fase 4, lo que queda: M15, el integrador de la parte.** Los módulos 12 a
14 dejaron todo el aparato armado: la @m12-derivada, el tensor de inercia y
sus ejes principales, y la ecuación de la cupla en precesión estable con su
caso particular $theta=90degree$. El módulo 15 la usa con $sum bold(M)_O =
0$ —el cuerpo simétrico libre de cuplas— y la notación $I$, $I'$ ya está
fijada:

| Módulo | Qué | Ejemplos de la guía |
|---|---|---|
| **15** — Peonza simétrica, precesión directa y retrógrada | cuerpo simétrico sin cuplas, $tan gamma = (I slash I') tan theta$, los dos conos | Problema 4 (el spacecraft que precesa) y Problema 6 (para qué $l slash r$ es directa) |

Los Problemas 5, 7, 8 y 9 son variantes de los mismos mecanismos y entran
como referencias cortas o como cierre del módulo 15, que es el integrador.

**Checkpoint por módulo, no por fase.** Es la decisión operativa de esta
sesión: `ESTADO_ACTUAL` + `HANDOFF` + commit + push al cerrar *cada* módulo.
