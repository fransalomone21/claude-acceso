# Estado actual — Apunte de Física Espacial

**Fase 2 (Parte II: los teoremas de conservación) — CERRADA el 2026-08-31.**
Lo que la cerraba: los cuatro módulos escritos, con sus ocho ejemplos (uno
simple y uno a fondo cada uno, calcados de la guía), y el PDF **mirado página
por página**. Las tres cosas están.

| Qué | Estado |
|---|---|
| `apunte/apunte.pdf` | **35 páginas**, compila sin errores |
| Plantilla, carátula, índice, encabezados | listos |
| Biblioteca de figuras (CeTZ) | **13 figuras**, todas miradas en la galería |
| Módulo 1 — Vectores y cinemática en polares | escrito y verificado (fase 1) |
| Módulo 2 — Cantidad de movimiento, impulso y choques | **escrito y verificado en render** |
| Módulo 3 — Centro de masa y sistemas de partículas | **escrito y verificado en render** |
| Módulo 4 — Propulsión: la ecuación del cohete | **escrito y verificado en render** |
| Módulo 5 — Trabajo y energía | **escrito y verificado en render** |
| Módulos 6 a 15 | no empezados (los `include` están comentados en `apunte.typ`) |
| Anexos | no empezados |

## Lo que hay escrito en la Parte II

**Módulo 2 — Cantidad de movimiento, impulso y choques** (5 pág.). De
$bold(F)=m bold(a)$ a $d bold(p)\/d t$ y por qué la segunda es más general; el
impulso como área bajo $F(t)$; la conservación de $bold(P)$ deducida de la
tercera ley; choques y su clasificación, con la velocidad relativa del choque
elástico. Ejemplos: la astronauta (Ej. 1 de la guía) y el **choque oblicuo de
asteroides** (Ej. 2), resuelto entero incluida la fracción disipada, $19,6%$.

**Módulo 3 — Centro de masa** (5 pág.). Definición y por qué el CM cae sobre la
recta que une los cuerpos con $d_1\/d_2 = m_2\/m_1$; $bold(P) = M bold(v)_"cm"$
y $sum bold(F)_"ext" = M bold(a)_"cm"$; el sistema centro de masa y el teorema
de König. Ejemplos: el Ej. 1 rehecho desde el CM, y el **Ej. 2 rehecho en el
sistema CM**, con la comprobación de que los impulsos salen opuestos y de que
lo disipado ($157m$) no depende del sistema de referencia.

**Módulo 4 — Propulsión** (7 pág.). Por qué $bold(F)=m bold(a)$ no se aplica a
masa variable, con la prueba de que el término $dot(m)bold(v)$ depende del
observador; la deducción del empuje desde $bold(P)$ (Roederer 4.6); impulso
específico; la condición de despegue; Tsiolkovsky; etapas. Ejemplos: Beer 14.94
(aceleración al despegar y al apagarse: $31,9$ y $240$ m/s²) y **Beer 14.97 vs
14.98** — una etapa contra dos con los mismos kilos: $7,93$ contra $9,24$ km/s.

**Módulo 5 — Trabajo y energía** (6 pág.). Trabajo de una fuerza variable;
teorema trabajo–energía; **la demostración de que toda fuerza central $F(r)$ es
conservativa**, que se apoya en la descomposición polar del módulo 1; $F=-nabla U$
y la lectura de diagramas de energía. Ejemplos: la energía del calamar (Ej. 3b) y
**S&Z 7.76** — el diagrama de energía completo, las siete partes.

## Lo verificado contra los libros en esta fase

| Afirmación | Fuente, medida |
|---|---|
| $sum bold(F) = d bold(p)\/d t$, impulso, conservación de $bold(P)$ | S&Z §8.1–8.2, ecs. 8.4 a 8.13, pág. 238–243 — leídas |
| Choque elástico y velocidad relativa | S&Z §8.4, ecs. 8.24 a 8.26, pág. 252 |
| Centro de masa y su teorema | S&Z §8.5, ecs. 8.28 a 8.36, pág. 254–258 |
| $d_1\/d_2 = m_2\/m_1$, sistema CM inercial, $bold(P)^*=0$ | Roederer pág. 110–111, ecs. 4.3 a 4.5a — páginas renderizadas y leídas |
| Deducción del empuje, $M bold(a) = -mu bold(v)_r$ | Roederer ec. 4.6, pág. 112 |
| Ecuación de movimiento del cohete y condición de despegue | Roederer ec. 4.7, pág. 113–114 |
| **Errata en Roederer ec. 4.8** — falta $abs(v_r)$ | pág. 114, **confirmada** contra la ecuación anterior de la misma página y contra toda la pág. 115 |
| **Segundo desliz en Roederer pág. 115** — el paso intermedio de dos etapas suma dos veces $-g m\/mu$ | pág. 115, confirmado: el miembro derecho del mismo renglón lleva uno solo |
| Propulsión de un cohete en S&Z | §8.6, ecs. 8.37 a 8.40, pág. 259–260 |
| Trabajo, teorema trabajo–energía, conservativas, $F=-d U\/d x$, diagramas | S&Z §6.1–6.3 y §7.3–7.5, pág. 173, 177, 187, 217, 221, 223, 225 |
| Enunciados de los ejercicios de la guía | renderizados con PyMuPDF: son imágenes, no texto |
| Datos del gráfico de S&Z 7.76 | **medidos por píxeles**, calibrando con los ticks del propio dibujo |

## Lo que NO está verificado todavía

Nada de los módulos 1 a 5 quedó sin fuente. Para los módulos 6 a 15, el
material de la cátedra está en `fuentes/TEMARIO.md` y los libros en
`fuentes/RUTAS.md`, pero **ninguna ecuación de esos módulos fue leída todavía
en su libro**.

## Lo que sigue

Fase 3 — Parte III: gravitación y mecánica orbital (módulos 6 a 11). Ver
`PDP.md` §4 para el criterio de salida.
