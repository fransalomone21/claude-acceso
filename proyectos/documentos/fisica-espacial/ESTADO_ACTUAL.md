# Estado actual — Apunte de Física Espacial

**FASE 5 (Parte V: de la cónica al viaje real, M16–M19) — LOS CUATRO MÓDULOS
ESCRITOS el 2026-09-11.** Es la fase que la cátedra abrió sin querer: la lista
de temas de gravitación actualizada (`Lista de temas Gravitación (2).pdf`)
agrega «Todo — Curtis cap. 2» y los parámetros orbitales del Bate, y Fran
pidió además órbitas parcheadas, esfera de influencia y su relación con
Hohmann y con la gravedad de la Tierra. El plan de los cuatro módulos, con el
hueco medido contra los quince ya escritos, está en `PDP.md` §4 (fase 5).

| Módulo de la Parte V | Estado |
|---|---|
| **M16 — La hipérbola: escapar, y llegar con velocidad de sobra** | **escrito y verificado en render** (2026-09-07) |
| **M17 — La esfera de influencia y las órbitas parcheadas** | **escrito y verificado en render** (2026-09-07, sesión 2) |
| **M18 — Marco perifocal, vector de estado y coeficientes de Lagrange** | **escrito y verificado en render** (2026-09-08, sesión 3) |
| **M19 — Tres cuerpos restringido y puntos de Lagrange** | **escrito y verificado en render** (2026-09-11, sesión 4) |

**Lo que falta para cerrar la fase 5 es la sesión de cierre**, no un módulo:
las referencias cruzadas de la Parte V validadas contra el índice renderizado.
`docs/figuras.md` ya quedó al día en esta sesión.

**El apunte pasó de 106 a 149 páginas** y de 28 a 37 figuras. La Parte V
arranca en la página 107 y el M19 ocupa las páginas 133 a 145 (impresas).
`apunte.typ` ya no tiene ningún `#include` comentado salvo el de los anexos,
que es de la fase 6.

**Lo que el M16 cerró, además de su propio tema.** Las dos fórmulas que
faltaban para despejar $v_r$ y el ángulo de trayectoria de vuelo $gamma$
—$v_perp = h/r$, $v_r = (mu/h) e sin nu$, $tan gamma = v_r/v_perp$— entraron
en la sección 16.5. Con eso quedan resolubles los **ejercicios adicionales 1,
2, 4 y 5 de gravitación**, que hasta el 2026-09-07 figuraban en
`GUIA-ENUNCIADOS.md` como «el apunte no tiene esa fórmula despejada». El 5
está resuelto adentro del módulo como ejemplo simple ($e = 0,215$,
$nu = 63,8°$); el 1, el 2 y el 4 quedan como práctica, ahora sí con la
herramienta a mano.

**Y el enlace que Fran pidió está hecho, con números.** La sección 16.6
retoma el ejemplo de Marte del módulo 11 y muestra qué le faltaba: los
$2,94$ km/s que aquella cuenta llamaba $Delta v_1$ **no son** lo que el motor
tiene que dar, son $v_oo$ — la velocidad de sobra medida desde el Sol. Lo que
el motor da, desde una órbita de estacionamiento de 300 km, son $3,59$ km/s,
y la diferencia no es lineal porque las velocidades se suman en cuadrado. La
*licencia* para pegar los dos problemas (por qué se puede) **la dio el módulo
17 el mismo día, en la sesión 2**.

**Lo que el M17 cerró (2026-09-07, sesión 2).** La promesa del M16 está
cumplida y con auditoría: la esfera de influencia sale de comparar
perturbaciones —no fuerzas—, y el módulo muestra primero que el criterio
ingenuo («quién tira más fuerte») deja a la Luna afuera de la Tierra, que es
el absurdo que obliga a cambiar de pregunta. El ejemplo de Marte quedó cerrado
de punta a punta con dos números que el M16 no tenía: **$\beta = 29,2°$**, que
dice *dónde* se enciende, y **$\Delta m/m = 0,705$** con la ecuación del cohete
del módulo 4. Y hay una sección entera —la 17.6— dedicada a *medir el error
del método*: en la frontera la nave va a $3,086$ km/s y no a los $2,943$ que
el parcheo supone (4,9% de más), pero la dirección se acierta con $1,5°$. El
error es asimétrico, y eso es lo que decide que las misiones corrijan a mitad
de camino en vez de rediseñar.

**Lo que el M18 cerró (2026-09-08, sesión 3).** Las dos filas nuevas que la
cátedra agregó a la lista de gravitación —«todo Curtis cap. 2» y los
parámetros orbitales del Bate— quedan cubiertas: el marco perifocal
(Curtis §2.10 y Bate §2.2.4), los **seis elementos orbitales clásicos** con su
receta de obtención desde el vector de estado (Bate §2.3 y §2.4) y los
**coeficientes de Lagrange** (Curtis §2.11). Dos figuras nuevas.

Tres cosas que el módulo aporta y que no estaban en el plan:

- La deducción de los coeficientes de Lagrange se apoya en **un solo hecho
  geométrico**, dicho antes de cualquier cuenta: $bold(r)_0$ y $bold(v)_0$ son
  una base del plano de la órbita, porque si fueran paralelos $bold(h)$ sería
  cero. Con eso, que existan $f$ y $g$ deja de ser un resultado y pasa a ser
  obvio; la cuenta sólo dice cuánto valen.
- La identidad $f dot(g) - dot(f) g = 1$ se presenta como lo que es: **la
  conservación del momento angular**, o sea la segunda ley de Kepler escrita
  como un determinante igual a uno. Y sirve de control aritmético gratis, que
  el ejemplo a fondo usa.
- **Una tercera errata de Curtis**, confirmada por el resultado impreso del
  propio libro: el ejemplo 2.13 imprime $r_0 = 10 thin 861$ km donde va
  $10 thin 681$ (con $10 thin 861$ no sale el $h = 75 thin 366$ que el libro
  publica dos renglones más abajo, y el resto del ejemplo usa $10 thin 681$).
  Queda anotada en el apunte, en un `#cuidado` al lado del ejemplo.

**Lo que el M19 cerró (2026-09-11, sesión 4).** Cubre Curtis §2.12 entero —el
marco co-rotante, las tres ecuaciones de movimiento, los cinco puntos de
Lagrange, la estabilidad y la constante de Jacobi— y con eso la fila «todo
Curtis cap. 2» de la lista de la cátedra queda completa. Tres figuras nuevas.

Cuatro cosas que el módulo aporta y que no estaban en el plan:

- **La comparación Hill contra esfera de influencia, con su propia deducción**
  (sección 19.4). El radio de Hill se deduce desarrollando a primer orden la
  condición de equilibrio de $L_1$ —tres renglones— y da
  $r_"Hill" = r_12 (m_2\/3m_1)^(1\/3)$, que para la Luna vale $61 thin 524$ km
  contra los $58 thin 019$ medidos: 6% de más, que es el precio del primer
  orden. Y la razón entre las dos fronteras sale con **exponente $-1\/15$**,
  tan chico que las dos coinciden en casi todo el sistema solar — salvo
  donde importa: **$L_1$ y $L_2$ del par Sol–Tierra están AFUERA de la esfera
  de influencia de la Tierra** (1,5 millones de km contra 925.000), así que
  el SOHO y el James Webb viven en lugares que el método del M17 considera
  territorio del Sol. Esto es propio del apunte: Curtis no compara las dos.
- **El «potencial de Jacobi»**, nombre de este apunte (Curtis no lo bautiza),
  que deja la constante de Jacobi con la forma $C = K + U_J$ — el $E = K + U$
  del módulo 5 palabra por palabra. Con eso la figura del perfil se lee como
  un diagrama de energía y no hace falta el gráfico 2-D de curvas de
  velocidad cero de Curtis.
- **Por qué $L_4$ y $L_5$ salen exactos y los tres colineales no**: con
  $y != 0$ hay dos ecuaciones y son *lineales* en $1\/r_1^3$ y $1\/r_2^3$;
  sobre el eje queda una sola condición y es una quíntica. La deducción de
  los puntos triangulares no usa ninguna aproximación y no depende de las
  masas.
- **Una cuarta errata de Curtis**, en el ejemplo 2.17 y confirmada por el
  propio libro: imprime $x_1 = -pi_1 r_12 = -0,9878 dot 384 thin 400 =
  -4670,6$ km, donde el símbolo y el factor son de $pi_1$ y el resultado es
  de $pi_2$ ($0,9878 dot 384 thin 400 = 379 thin 700$). Lo correcto es
  $x_1 = -pi_2 r_12$, que es lo que dice su propia ec. (2.177a). En el mismo
  ejemplo hay otra transposición: $5,947 times 10^24$ donde va
  $5,974 times 10^24$.

**Todos los números del M19 están recalculados desde cero**, no copiados: las
tres raíces de la quíntica por bisección propia, las cuatro constantes de
Jacobi y las seis velocidades de apagado. Las cuatro constantes coinciden con
las que Curtis imprime en su figura 2.37 hasta la última cifra que el libro
muestra, lo cual es la verificación cruzada del cálculo entero.

**El Bate SÍ está en el disco**, contra lo que el HANDOFF de la sesión 2
suponía: `Roger R. Bate, Donald D. Mueller, Jerry E. White - Fundamentals of
astrodynamics-Dover Publications (1971).pdf`, en la misma carpeta que el
Curtis. Offset medido: **página impresa = página del PDF − 15**.

**Lo que el M18 NO hizo, a propósito.** No desarrolla la ecuación de Kepler
—no es su tema y da para un módulo entero—, así que **los 3,2 días de la
sección 17.6 siguen citados y no deducidos**. El M18 lo dice explícitamente en
su sección 18.5, de modo que la deuda queda declarada adentro del apunte y no
sólo acá.

**Fase 3 (Parte III: gravitación y órbitas) — CERRADA el 2026-08-31.**

**Fase 4 (Parte IV: cuerpo rígido, M12–M15) — CERRADA el 2026-08-31.** Los
quince módulos del apunte estaban escritos, compilados y verificados en el
render.

**2026-09-07 — tres ejercicios nuevos incorporados, sin abrir fase nueva.**
Fran trajo una versión ampliada de la guía de la cátedra (ver
`fuentes/RUTAS.md` y la nota al principio de `fuentes/GUIA-ENUNCIADOS.md`),
con dos bloques de «adicionales» que el original no tenía. Se incorporaron
tres —el resto queda anotado como práctica sin resolver, siguiendo la misma
decisión de curación que ya regía para los Problemas 5, 7, 8 y 9 de cuerpo
rígido (ver el `#guia` del módulo 15: no se agrega un ejercicio que no
enseña una técnica nueva, se anota para práctica):

- **Módulo 2** — Adicional 1 (separación de dos etapas de un cohete, el
  mismo mecanismo del Ej. 1 con las dos masas en movimiento) y Adicional 2
  (satélite expulsado del transbordador), que es el primer ejemplo del
  módulo que usa numéricamente $F_"prom" = Delta p \/ Delta t$ y no sólo la
  define.
- **Módulo 4** — Adicional 3: el mismo empuje y la misma definición de
  $I_"sp"$ aplicados a un cohete con varios motores encendidos a la vez (el
  transbordador, con sus dos SRB y sus tres SSME), que es el caso real de
  cualquier lanzador con etapas de refuerzo.
- **Módulo 10** — el Ejercicio adicional 3 de gravitación (excentricidad de
  una órbita polar a partir de su período): la tercera ley despejada al
  revés, sin momento angular ni energía.

Los otros siete adicionales no se tocaron entonces. *Actualizado el mismo
día, más tarde:* los ejercicios 1, 2, 4 y 5 de gravitación pedían anomalía
verdadera o ángulo de trayectoria de vuelo como *dato de salida*, y el apunte
no tenía esa fórmula despejada. **El módulo 16 la agregó** (sección 16.5), y el
**5 quedó resuelto ahí como ejemplo simple**; el 1, el 2 y el 4 siguen anotados en
`GUIA-ENUNCIADOS.md` como práctica, ahora con la herramienta a mano.

**Mismo día — nueva caja de estilo, `#posta`.** A pedido de Fran, el módulo 8
sumó dos cuadros técnicos (por qué funciona el problema equivalente, qué es
el "centro fijo") y, sobre eso, se creó una **tercera regla propia del
apunte** (ver `CLAUDE.md`): todo tema nuevo lleva, además de las cajas
técnicas, un cuadro rosa `#posta` con la misma idea en criollo. La función
vive en `plantilla.typ`, el color en `paleta.typ`, y la leyenda de la
carátula ya lo explica. **No se retrofitteó a los 15 módulos existentes** —
se aplica de acá en adelante.

**Mismo día — reordenado el módulo 8: el modelo se explica antes de la
figura, no después.** Fran reportó no entender "respecto de qué" estaba el
punto fijo del problema equivalente: la figura que lo mostraba aparecía
*antes* de que ninguna caja lo explicara. Se agregó una sección nueva al
principio del módulo, «8.1 La idea completa, antes de la primera ecuación»,
que cuenta el plan en criollo y en tres pasos y recién ahí muestra la
figura —movida desde su posición vieja, más abajo—; las cajas técnicas que
ya explicaban el punto fijo quedaron donde estaban, ahora como
profundización de algo ya presentado, no como primera exposición. Quedó
registrado como **cuarta regla propia** en `CLAUDE.md`: todo modelo o
entidad nueva se explica en palabras antes de la primera ecuación o figura
que lo use, con el `m8-nodos-mallas.typ` de Electrónica Analógica como
referencia de cómo se hace bien. Compilado y verificado en el render: cero
huérfanos de caja, **106 páginas**.

| Qué | Estado |
|---|---|
| `apunte/apunte.pdf` | **126 páginas**, compila sin errores, cero huérfanos de caja |
| Plantilla, carátula, índice, encabezados | listos, no se tocan |
| Biblioteca de figuras (CeTZ) | **32 figuras**, todas miradas en la galería |
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
| **Módulo 15 — Peonza simétrica, precesión directa y retrógrada** | **escrito y verificado en render** |
| **Módulo 16 — La hipérbola: escapar y llegar con velocidad de sobra** | **escrito y verificado en render** |
| **Módulo 17 — La esfera de influencia y las órbitas parcheadas** | **escrito y verificado en render** |
| **Módulo 18 — Marco perifocal, vector de estado y coeficientes de Lagrange** | **escrito y verificado en render** |
| **Módulo 19 — Tres cuerpos restringido y puntos de Lagrange** | **escrito y verificado en render** |
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

**Módulo 15 — Peonza simétrica, precesión directa y retrógrada** (4 pág.),
cierra la Parte IV. El caso sin cuplas: $sum bold(M)_G = 0 arrow.r
bold(H)_G$ constante, de donde $dot(phi) = H\/I$ (la precesión no depende de
$theta$); $tan gamma = (I\/I') tan theta$ (ec. 18.49, con la aclaración de
que el $gamma,theta$ de esta fórmula puntual no son el $theta$ de nutación
del módulo 14); y el criterio de signo $dot(psi)\/dot(phi) = ((I'-I)\/I')
cos theta$ que separa precesión directa ($I' > I$, achatado) de retrógrada
($I' < I$, alargado) —**corregido contra una nota de planificación previa
que tenía el criterio invertido**; verificado con dos formas independientes
(las ecuaciones de Euler sin cupla, y el ejemplo de la Tierra/bamboleo de
Chandler, que es achatada y de precesión directa—dato astronómico conocido).
Ejemplos: el Problema 4 (el satélite achatado, $I'\/I=16\/9$, período de
precesión $1,832$ s) y el Problema 6 (el cilindro de paredes delgadas, umbral
$ell\/r = sqrt(6)$ entre directa y retrógrada, con el caso límite isótropo
que recuerda al cubo del módulo 13). Reusa `fig-conos` del módulo 12 con un
nuevo epígrafe, apoyada en su tangencia externa para ilustrar el caso
directo. Cierra con un párrafo de síntesis de toda la Parte IV.

## Lo que hay escrito en la Parte V

**Módulo 16 — La hipérbola: escapar, y llegar con velocidad de sobra**
(11 pág., 107–117). Cierra la clasificación de cónicas que el módulo 9 dejó
en una fila de tabla. Seis secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con la receta en tres pasos («necesitás que llegue al infinito → necesitás
   que además le sobre velocidad → de las dos sale todo») y un `#posta`.
2. *La parábola* — $e = 1$, $E = 0$, $v = v_\text{esc}$, y el `#cuidado` de por
   qué no tiene semieje y por qué ninguna trayectoria real es una parábola.
3. *La geometría* — $\nu_\infty = \arccos(-1/e)$, $\beta$, la deducción del
   ángulo de giro $\delta = 2\arcsin(1/e)$, $a = (h^2/\mu)/(e^2-1)$,
   $r_p = a(e-1)$, y el radio de puntería $\Delta = b = a\sqrt{e^2-1}$.
   Figura nueva: `fig-hiperbola-geometria`.
4. *La energía* — $E = +\mu m/(2a)$ deducida de la @m9-e-E del módulo 9;
   $v_\infty = \sqrt{\mu/a}$; $v^2 = v_\text{esc}^2 + v_\infty^2$; $C_3$.
   Figura nueva: `fig-hiperbola-energia`. Cuadro `#notacion` sobre la
   convención $a < 0$, que es la de todo el software de astrodinámica.
5. *$v_r$ y el ángulo $\gamma$* — la caja de herramientas de Curtis (pág. 99)
   y el truco de cálculo (armar $e\sin\nu$ y $e\cos\nu$, elevar al cuadrado y
   sumar). Cierra los ejercicios adicionales 1, 2, 4 y 5 de gravitación.
6. *El enlace con Hohmann* — el ejemplo de Marte del módulo 11 rehecho: los
   $2,94$ km/s eran $v_\infty$, no el $\Delta v$ del motor; el encendido real
   desde 300 km de altura vale $3,59$ km/s.

Ejemplos: el **simple** es el ejercicio adicional 5 de la guía ($e = 0,215$,
$\nu = 63,8°$) y el **a fondo** es el ejemplo 2.10 de Curtis (pág. 100), que
mide una hipérbola entera —$h$, $e$, $\nu$, $r_p$, $a$, $C_3$, $\delta$,
$\Delta$— a partir de $r$, $v$ y $\gamma$. Los dos usan exactamente el mismo
planteo de cinco ecuaciones, uno con $e < 1$ y el otro con $e > 1$: es la
razón por la que están apareados.

**Módulo 17 — La esfera de influencia y las órbitas parcheadas** (9 pág.,
118–126). Es el núcleo de lo que Fran pidió: la *licencia* que el M16 prometió
y no dio. Ocho secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con el plan en tres pasos («hay que decidir de quién es la nave en cada
   tramo → el criterio obvio es el equivocado → con la frontera dibujada son
   tres problemas de dos cuerpos») y un `#posta`.
2. *Por qué «quién tira más fuerte» es la pregunta equivocada* — la frontera
   ingenua da 259.000 km, **adentro** de la órbita de la Luna. El
   `#cuidado` explica por qué la cuenta no está mal hecha sino que mide lo que
   no importa, y el `#posta` del ascensor lo dice en criollo.
3. *La cuenta que sí sirve* — la `#deduccion` central: los dos puntos de vista,
   $P_p/A_s = (m_p/m_s)(R/r)^2$ y $p_s/a_p = (m_s/m_p)(r/R)^3$, y de igualarlos
   $r_"SOI" = R (m_p/m_s)^{2/5}$. El `#clave` que sigue explica **por qué los
   exponentes son 2 y 3** (el término solar es una *diferencia*, o sea marea) y
   por qué el 5 es literalmente $2+3$ — con eso la fórmula no se memoriza.
4. *Cuánto mide, y las dos comparaciones* — figura nueva
   `fig-esfera-influencia` (a escala real las dos veces) y tabla de siete
   cuerpos, calculada con la fórmula y coincidente con la tabla A.2 de Curtis.
5. *El método de las cónicas parcheadas* — `#definicion`, figura nueva
   `fig-conicas-parcheadas`, el `#clave` del pegado de velocidades relativas, y
   el `#cuidado` de por qué **no sirve para la Luna** (17% contra 0,6%).
6. *Cuánto cuesta la mentira* — la auditoría, hecha con las herramientas del
   M16: en la frontera la nave va a $3,086$ km/s y no a $2,943$ (**4,9% de
   error en el módulo**) pero la dirección se acierta con $1,5°$ de error. El
   error no es simétrico, y eso decide cómo se corrige.
7. *El ejemplo completo* — el ejemplo 8.4 de Curtis: $e = 1,145$,
   $Delta v = 3,590$ km/s (el mismo del M16, ahora justificado), y las dos
   cosas nuevas: $beta = 29,2°$ —**dónde** se enciende— y $Delta m/m = 0,705$
   con la ecuación del cohete del módulo 4.
8. *Lo que se usa después* — incluye el círculo de perigeos posibles de radio
   $r_p sin beta = 3260$ km, que es de dónde salen las ventanas diarias.

**Módulo 18 — Marco perifocal, vector de estado y coeficientes de Lagrange**
(10 pág., 123–132). Es el módulo de *herramientas* de la Parte V: no agrega
física nueva, agrega la forma en que la física que ya está se escribe para una
computadora. Seis secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con el plan en tres pasos («elegir bien los ejes → contar los números →
   propagar sin resolver nada») y un `#posta` de tres ideas, la última de las
   cuales organiza el módulo entero: una órbita *son seis números*.
2. *El marco perifocal* — `#definicion` de $hat(p) hat(q) hat(w)$, figura nueva
   `fig-perifocal`, la posición leída sin deducir y la `#deduccion` de
   $bold(v) = (mu\/h)[-sin nu hat(p) + (e + cos nu) hat(q)]$, con el `#clave`
   de que sus componentes **no dependen de $r$**. Un `#notacion` por el choque
   Curtis ($theta$, $hat(p) hat(q) hat(w)$) contra Bate ($nu$, $P Q W$).
3. *Los seis números de una órbita* — `#definicion` de vector de estado, los
   seis elementos clásicos del Bate, y el `#clave` que los separa: **cinco son
   constantes y sólo el sexto corre**. Después la receta de los tres vectores
   $bold(h)$, $bold(n)$, $bold(e)$ y los seis cosenos, con dos `#cuidado`: el
   de la resolución de cuadrante y el de las **órbitas degeneradas** (circular
   y ecuatorial), que cierra con «una singularidad de las coordenadas no es una
   singularidad de la física».
4. *Los coeficientes de Lagrange* — el argumento de la base en un renglón,
   figura nueva `fig-lagrange-base`, la `#deduccion` completa, el `#clave` del
   determinante igual a uno, las cuatro fórmulas en función de $Delta nu$ y la
   receta en cinco pasos (algoritmo 2.3 de Curtis).
5. *Lo que falta: el tiempo* — la ecuación de Kepler nombrada y **no**
   desarrollada, la serie de $f$ y $g$ en $Delta t$, y el `#cuidado` del radio
   de convergencia (1700 s, un quinto del período del ejemplo de Curtis).
6. *Lo que se usa después.*

Ejemplos: el **simple** son los ejemplos 2.11 y 2.12 de Curtis apareados a
propósito —la misma órbita en las dos direcciones, y el segundo termina en una
hipérbola que los datos no dejaban ver—; el **a fondo** son los ejemplos 2.13
y 2.14, una propagación entera de $120°$ que corre sin saber en qué cónica
está, con el control $f dot(g) - dot(f) g = 1$ hecho a mitad de camino.

**Módulo 19 — El problema restringido de tres cuerpos y los puntos de
Lagrange** (13 pág., 133–145). Cierra la Parte V y el apunte. Siete secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con el plan en tres pasos («aceptar que no hay solución cerrada → cambiar
   de marco → preguntar dónde se puede estar quieto y a dónde no se puede
   llegar») y un `#posta` de tres ideas.
2. *El marco que gira con los dos cuerpos* — `#definicion` de las tres
   restricciones del nombre, figura nueva `fig-tres-cuerpos-marco`, las
   fracciones de masa $pi_1$ y $pi_2$ con un `#notacion` por el choque con el
   número $pi$ y con el $mu = G M$ del apunte, y la `#deduccion` de las tres
   ecuaciones de movimiento a partir de la fórmula de cinco términos del
   módulo 12. El `#clave` que sigue dice *por qué* no se resuelven: no
   linealidad más el acoplamiento de Coriolis.
3. *Los cinco puntos de Lagrange* — $z = 0$ en un renglón; la `#deduccion` de
   los dos triangulares (el sistema lineal en $1\/r_1^3$ y $1\/r_2^3$, sin
   ninguna aproximación); el `#clave` de por qué los tres colineales son una
   quíntica y no se despejan nunca; `#definicion` del método de bisección;
   figura nueva `fig-lagrange-puntos` (dos paneles) y el ejemplo simple con
   los cinco puntos del par Tierra–Luna.
4. *Dos fronteras para lo mismo: Hill contra la esfera de influencia* — la
   sección propia del apunte, con la `#deduccion` del radio de Hill, la tabla
   comparativa de las dos fronteras para la Luna y para la Tierra, el
   `#clave` del exponente $-1\/15$ y el `#cuidado` de que no hay que elegir
   una sino saber cuál contesta qué.
5. *Cuáles sirven para estacionar* — estabilidad, el criterio de Routh
   despejado ($k >= 24,96$, o $pi_2 <= 0,0385$), el `#cuidado` de que el Sol
   desestabiliza $L_4$ y $L_5$ del par Tierra–Luna, y un `#posta` sobre por
   qué las misiones reales están en los puntos *inestables*.
6. *La constante de Jacobi* — la `#deduccion` completa, el `#clave` de que
   Coriolis no aparece **porque no trabaja**, el potencial de Jacobi, figura
   nueva `fig-jacobi-perfil`, el `#clave` de las cuatro puertas en orden y el
   `#cuidado` doble (C no es la energía; permitido no es alcanzable).
7. *Lo que se usa después*, que cierra la Parte V entera.

Ejemplos: el **simple** es el 2.16 de Curtis (los cinco puntos del par
Tierra–Luna) y el **a fondo** es el 2.17 —las seis velocidades de apagado—,
cuyo resultado es el que justifica el módulo entero: **22 m/s separan «no
llego a la Luna» de «me escapo del sistema»**, sobre una velocidad de apagado
de casi 11 km/s.

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
| **Fase 5 — lo de abajo se leyó en el Curtis en esta sesión** | offset medido: pág. impresa = pág. del PDF − 8 |
| Índice completo del Curtis (378 entradas), para ubicar qué cubre el cap. 2 y dónde vive lo parcheado | leído del *outline* del PDF, no de la imagen del índice |
| Parábola: $r$, $v = \sqrt{2\mu/r}$, trayectoria de escape | Curtis §2.8, ecs. 2.89 a 2.91, pág. 90 |
| Hipérbola: $\nu_\infty$, $\beta$, $\delta$, $a$, $r_p$, $r_a$, $b$, $\Delta$ | Curtis §2.9, ecs. 2.96 a 2.107, pág. 93–96 |
| Energía hiperbólica: $\varepsilon = +\mu/2a$, $v_\infty$, $v^2 = v_\text{esc}^2 + v_\infty^2$, $C_3$ | Curtis §2.9, ecs. 2.110 a 2.115, pág. 97–98 |
| La convención $a < 0$ y la vis-viva única para las tres cónicas | Curtis §2.9, pág. 99 (el comentario que sigue a la caja de herramientas) |
| Caja de herramientas: $h$, $r$, $v_r$, $\tan\gamma$, y las de cada cónica | Curtis, pág. 99 |
| Ejemplo 2.10 rehecho número por número (los ocho apartados) | Curtis, pág. 100–101; coinciden todos dentro del redondeo |
| El enlace Hohmann ↔ hipérbola de escape ($v_\infty = 2,94$ km/s, $\Delta v = 3,59$ km/s desde 300 km) | calculado en esta sesión con los datos del apéndice F que el módulo 11 ya usaba |
| **Fase 5, sesión 2 — lo de abajo es del capítulo 8 de Curtis**, mismo offset (impresa = PDF − 8) | leído por capa de texto |
| Esfera de influencia: los dos puntos de vista, las dos razones de perturbación y $r_\text{SOI} = R(m_p/m_s)^{2/5}$ | Curtis §8.4, ecs. 8.18 a 8.34, pág. 390–394 |
| Radio de la esfera terrestre, 925.000 km = 145 $R_T$ | Curtis, ejemplo 8.3, pág. 394 |
| Método de las cónicas parcheadas, y por qué no sirve para la Luna | Curtis §8.5, pág. 394–395 |
| Partida planetaria: $e = 1 + r_p v_\infty^2/\mu$, $h$, $v_p$, $\Delta v$, $\beta$, el círculo de perigeos $r_p\sin\beta$ | Curtis §8.6, ecs. 8.35 a 8.43, pág. 395–397 |
| Ejemplo 8.4 rehecho entero ($v_\infty=2,943$; $\Delta v=3,590$; $\beta=29,2°$; $\Delta m/m=0,705$) | Curtis, pág. 399–401 |
| **Errata en Curtis, ejemplo 8.4(b)**: el denominador dice 368.600 donde va $\mu_T=398.600$ | el resultado impreso, 29,16°, sale con 398.600; con 368.600 daría otro número |
| **Errata en Curtis, ejemplo 8.3**: la fracción dice $1,989\times10^{24}$ donde va $10^{30}$ | el resultado impreso, 925.000 km, sale con $10^{30}$ |
| La tabla de siete esferas de influencia (Mercurio a Saturno, más la Luna) | **calculada en esta sesión** con la fórmula y los $\mu$ del apéndice F; los siete valores coinciden con la tabla A.2 de Curtis |
| El error del parcheo: $v=3,086$ km/s y $
u=149,3°$ en la frontera | **calculado en esta sesión** con la vis-viva y la ecuación de la órbita del apunte |
| El tiempo adentro de la esfera, 3,2 días de 259 | **calculado en esta sesión** con la ecuación de Kepler hiperbólica (que el apunte NO desarrolla: el número se cita, no se deduce) |
| **Fase 5, sesión 4 — lo de abajo es Curtis §2.12**, mismo offset (impresa = PDF − 8); la sección arranca en la pág. impresa 116 (PDF 124) | leído por capa de texto, y las páginas del ejemplo 2.17 miradas a 300 dpi |
| Marco co-rotante, $\Omega=\sqrt{\mu/r_{12}^3}$, $\pi_1$, $\pi_2$, y las tres ecuaciones de movimiento | Curtis §2.12, ecs. 2.173 a 2.192, pág. 116–120 |
| $z=0$ para los cinco puntos; $r_1=r_2=r_{12}$ para los triangulares; la quíntica $f(\pi_2,\xi)=0$ de los colineales | Curtis §2.12.1, ecs. 2.193 a 2.204, pág. 120–121 |
| Método de bisección (algoritmo 2.4) | Curtis, pág. 122–123 |
| Estabilidad: colineales inestables; $L_4$, $L_5$ estables si $m_1/m_2+m_2/m_1\ge 25$ | Curtis, pág. 126, citando a Battin (1987) |
| Constante de Jacobi y curvas de velocidad cero | Curtis §2.12.2, ecs. 2.207 a 2.216, pág. 126–128 |
| $\xi_1=0{,}83692$, $\xi_2=1{,}15568$, $\xi_3=-1{,}00506$ | **recalculadas en esta sesión** por bisección propia; coinciden con las del ejemplo 2.16 |
| $C_1=-1{,}6735$, $C_2=-1{,}6650$, $C_3=-1{,}5810$, $C_{4,5}=-1{,}5683$ | **recalculadas en esta sesión**; coinciden con las cuatro que Curtis imprime en su fig. 2.37 |
| Las seis velocidades de apagado del ejemplo 2.17 (10,8455 a 10,8676 km/s) | **recalculadas en esta sesión**; difieren de las impresas en menos de 0,3 m/s (redondeo de $\pi_2$) |
| $r_\text{Hill}=r_{12}(m_2/3m_1)^{1/3}$, y la razón $r_\text{Hill}/r_\text{SOI}=0{,}693\,(m_2/m_1)^{-1/15}$ | **deducidas y calculadas en esta sesión**; Curtis no las trae. Verificadas contra las raíces exactas: Hill queda entre $L_1$ y $L_2$ en los dos sistemas |
| $L_1$ y $L_2$ del par Sol–Tierra a 1.491.577 y 1.501.558 km de la Tierra | **calculados en esta sesión** con la misma quíntica; coherentes con el «about 1.5 million km» de Curtis, pág. 126 |
| **Cuarta errata de Curtis, ejemplo 2.17**: $x_1=-\pi_1 r_{12}=-0{,}9878\cdot384.400=-4670{,}6$ km | **confirmada mirando la página a 300 dpi**: el producto impreso da 379.700; lo correcto es $-\pi_2 r_{12}$, que es lo que dice su propia ec. (2.177a) |
| **Quinta errata, mismo ejemplo**: $m_1=5{,}947\times10^{24}$ donde va $5{,}974\times10^{24}$ | la división que el propio libro imprime dos símbolos después da 0,9878, que sale con 5,974 |

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

**La fase 5 está abierta y el orden de las sesiones está decidido.** Una
sesión por módulo, con checkpoint al cerrar cada una — la misma decisión
operativa de la fase 4, y por la misma razón: un módulo entra en una sesión,
cuatro no.

| Sesión | Módulo | Qué cierra la sesión |
|---|---|---|
| 1 · **hecha** (2026-09-07) | M16 — la hipérbola | escrito, compilado y mirado; el enlace numérico con Hohmann adentro |
| 2 · **hecha** (2026-09-07) | M17 — esfera de influencia y órbitas parcheadas | la deducción de $R_\text{SOI} = r\,(m/M)^{2/5}$, el método de las cónicas parcheadas, la partida planetaria completa (Curtis §8.4–8.6), y el ejemplo Tierra→Marte de punta a punta usando el $v_\infty$ del módulo 16 |
| 3 · **hecha** (2026-09-08) | M18 — marco perifocal y coeficientes de Lagrange | $\hat p$, $\hat q$, $\hat w$; el vector de estado y los seis elementos; $f$ y $g$ (Curtis §2.10–2.11) y los parámetros orbitales del Bate (pág. 53–74) |
| 4 · **hecha** (2026-09-11) | M19 — tres cuerpos restringido y puntos de Lagrange | los cinco puntos, la constante de Jacobi (Curtis §2.12), y la comparación medida entre la esfera de Hill y la esfera de influencia del M17 |
| 5 | cierre de fase | las referencias cruzadas de la Parte V validadas contra el índice renderizado. `docs/figuras.md` **ya quedó al día** en la sesión 4 |

**Por qué el M17 va segundo y no cuarto.** Es lo que Fran pidió
explícitamente, y su única precondición es el M16, que ya está. Los dos
módulos de herramientas (M18 y M19) no le hacen falta para nada.

**Lo que la fase 6 hereda.** Revisar las referencias cruzadas de texto plano
entre módulos (tabla en `HANDOFF.md`) y decidir si el apunte lleva anexos.
Ninguna de las dos es urgente: la paginación todavía puede cambiar, y el
`HANDOFF.md` ya explica por qué se dejaron para el final.

**Checkpoint por módulo, no por fase.** `ESTADO_ACTUAL` + `HANDOFF` + commit
+ push al cerrar *cada* módulo.
