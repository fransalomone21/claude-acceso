# Estado actual — Apunte de Física Espacial

**Fase 3 (Parte III: gravitación y órbitas) — ABIERTA, tres de seis módulos
escritos.** La cierran los seis módulos (M6 a M11) con sus doce ejemplos, el
Road Map de Curtis (ap. B) redibujado en CeTZ, y el PDF mirado. Van M6, M7 y
M8, los tres mirados página por página en el render.

**Fase 2 — CERRADA el 2026-08-31.**

| Qué | Estado |
|---|---|
| `apunte/apunte.pdf` | **58 páginas**, compila sin errores, cero huérfanos de caja |
| Plantilla, carátula, índice, encabezados | listos, no se tocan |
| Biblioteca de figuras (CeTZ) | **19 figuras**, todas miradas en la galería |
| Módulos 1 a 5 — Partes I y II | escritos y verificados (fases 1 y 2) |
| **Módulo 6 — Gravitación, peso y energía potencial** | **escrito y verificado en render** |
| **Módulo 7 — Momento angular y fuerzas centrales** | **escrito y verificado en render** |
| **Módulo 8 — Dos cuerpos y masa reducida** | **escrito y verificado en render** |
| Módulos 9 a 15 | no empezados (los `include` están comentados en `apunte.typ`) |
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
| Los 40 enunciados de la guía | transcriptos en `fuentes/GUIA-ENUNCIADOS.md` |

## Lo que NO está verificado todavía

Nada de los módulos 1 a 8 quedó sin fuente. Para los módulos 9 a 15 el material
está localizado —el potencial eficaz en la pág. 3 del mismo escaneo de clase,
el Road Map en `Downloads`, y Beer cap. 12 y 18— pero **ninguna ecuación de
esos módulos fue leída todavía en su libro**.

## Lo que sigue

Módulo 9 — la ecuación de la órbita, las cónicas y el potencial eficaz. Es el
módulo central de la fase y el más difícil: ver `HANDOFF.md`, que dice qué está
medido y qué falta medir.
