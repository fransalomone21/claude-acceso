# Estado actual — Apunte de Física Espacial

**Fase 3 (Parte III: gravitación y órbitas) — ABIERTA, cuatro de seis módulos
escritos.** La cierran los seis módulos (M6 a M11) con sus doce ejemplos, el
Road Map de Curtis (ap. B) redibujado en CeTZ, y el PDF mirado. Van M6, M7, M8
y M9, los cuatro mirados página por página en el render.

**Fase 2 — CERRADA el 2026-08-31.**

| Qué | Estado |
|---|---|
| `apunte/apunte.pdf` | **68 páginas**, compila sin errores, cero huérfanos de caja |
| Plantilla, carátula, índice, encabezados | listos, no se tocan |
| Biblioteca de figuras (CeTZ) | **22 figuras**, todas miradas en la galería |
| Módulos 1 a 5 — Partes I y II | escritos y verificados (fases 1 y 2) |
| **Módulo 6 — Gravitación, peso y energía potencial** | **escrito y verificado en render** |
| **Módulo 7 — Momento angular y fuerzas centrales** | **escrito y verificado en render** |
| **Módulo 8 — Dos cuerpos y masa reducida** | **escrito y verificado en render** |
| **Módulo 9 — Potencial eficaz y ecuación de la órbita** | **escrito y verificado en render** |
| Módulos 10 a 15 | no empezados (los `include` están comentados en `apunte.typ`) |
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

## Lo que NO está verificado todavía

Nada de los módulos 1 a 9 quedó sin fuente. Para los módulos 10 a 15 el
material está localizado —el Road Map en `Downloads`, Beer §12.13 y cap. 18, y
las figuras de la sección de cuerpo rígido de la guía— pero **ninguna ecuación
de esos módulos fue leída todavía en su libro**, salvo las de Kepler y el
período orbital, que quedaron mapeadas de paso al leer el Beer para el módulo 9
(la tabla está en `HANDOFF.md`).

## Lo que sigue

**Módulo 10 — Kepler**: las tres leyes como consecuencia de la ecuación de la
órbita, el período $tau = 2 pi a b \/ h$ (Beer ec. 12.45, pág. 739) y la tercera
ley. Ejemplos: el *Problema 4* (S&Z 13.67, el mismo satélite del módulo 9, del
que ya están calculados $a$, $b$, $e$ y $h$ — falta sólo el período y la parte
(d), el escape desde perigeo contra apogeo) y los *Problemas 8 y 9*, el LEM del
Apollo, que van juntos como en el módulo 7 fueron juntos los problemas 2 y 3.

**Un cambio de plan de la fase, hecho a propósito y con motivo.** El plan de
sesión asignaba al módulo 10 los problemas 4, 7, 8 y 9 de la sección de
energía. El *Problema 7* (Júpiter) se movió al módulo 9: es el único de la guía
que usa la clasificación por cónicas —el dato «trayectoria parabólica» no se
puede usar sin $e = 1 <==> E = 0$—, mientras que su tema no tiene nada de
Kepler. Al módulo 10 le quedan tres problemas para dos ejemplos, que es lo que
corresponde.
