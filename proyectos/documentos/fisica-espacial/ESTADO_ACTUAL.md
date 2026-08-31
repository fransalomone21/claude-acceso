# Estado actual — Apunte de Física Espacial

**Fase 1 (andamiaje y módulo piloto) — CERRADA el 2026-08-30.**
Lo que la cerraba: PDF compilando con carátula, índice, plantilla, biblioteca
de figuras con al menos tres figuras propias, y el Módulo 1 escrito entero y
**mirado en el render**. Las cuatro cosas están.

| Qué | Estado |
|---|---|
| `apunte/apunte.pdf` | **11 páginas**, compila sin errores |
| Plantilla, carátula, índice, encabezados | listos |
| Biblioteca de figuras (CeTZ) | 5 figuras, todas miradas en la galería |
| Módulo 1 — Vectores y cinemática en polares | **escrito y verificado en render** |
| Módulos 2 a 15 | no empezados (los `include` están comentados en `apunte.typ`) |
| Anexos | no empezados |

## Lo que hay escrito, sección por sección

**Módulo 1 — Vectores y cinemática en coordenadas polares** (7 páginas de
cuerpo). Siete secciones: componentes y cosenos directores; producto escalar y
proyección; producto vectorial y área; dobles productos y la trampa de la
asociatividad; derivada de un vector (con la demostración de dos renglones de
que la derivada de un vector de módulo constante es perpendicular a él);
velocidad y aceleración en polares deducidas de punta a punta; y el cierre que
dice qué tres resultados se usan después.

Tres ejemplos, todos calcados de la guía de la cátedra: cosenos directores y
proyección (Ej. 11, 12 y 14), versor perpendicular (Ej. 13), y **a fondo** el
cohete visto por el radar (Ej. 10), con su control cruzado contra $\dot y$.

Cuadros: 3 de deducción, 2 de cuidado, 3 de cuidado geométrico/vectorial, 1 de
notación (Beer $e_r$ vs. cátedra $\hat r$), 2 de idea clave, 1 de la guía.

## Lo verificado contra los libros

| Afirmación | Fuente, medida |
|---|---|
| $\dot{\hat r} = \dot\theta\,\hat\theta$ y $\dot{\hat\theta} = -\dot\theta\,\hat r$ | Beer §11.14, pág. impresa 668, ec. (11.42) — leída |
| $\mathbf v = \dot r\,\hat r + r\dot\theta\,\hat\theta$ | Beer ec. (11.43), pág. 668 |
| $\mathbf a = (\ddot r - r\dot\theta^2)\hat r + (r\ddot\theta + 2\dot r\dot\theta)\hat\theta$ | Beer ec. (11.44) y (11.46), pág. 669 |
| «$a_r$ no es la derivada de $v_r$» | advertencia textual de Beer, pág. 669 |

## Lo que NO está verificado todavía

Nada del módulo 1 quedó sin fuente. Para los módulos siguientes, el material
de la cátedra ya está transcripto en `fuentes/TEMARIO.md` y los seis libros
localizados en `fuentes/RUTAS.md`, pero **ninguna ecuación de los módulos 2 a
15 fue leída todavía en su libro**.

## Lo que sigue

Fase 2 — Parte II: los teoremas de conservación (módulos 2 a 5). Ver `PDP.md`
§4 para el criterio de salida.
