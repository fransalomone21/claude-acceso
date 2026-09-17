# Trade study — la forma de la arquitectura nueva

**Fase 5, 2026-09-17.** Informe de análisis de decisión según NASA SP-2016-6105
cap. 6.8 (ficha `perfil-global/pilares/nasa-seh/datos-decision.md`, §3).

El handbook pide siete cosas en un informe de decisión (p. 164-165): *decisión a
tomar, criterios, alternativas, métodos de evaluación, proceso y resultados,
recomendación, decisión final*. Van las siete, en ese orden.

> **La regla que gobierna este documento:** "If trade results are inconclusive,
> then the wrong selection criteria were used." (Rechtin & Maier, p. 402).
> Por eso los criterios y sus pesos están escritos **antes** de puntuar, y por
> eso la §6 documenta que la primera pasada salió inconclusa y **qué se
> rehizo** — que fueron los criterios, no el estudio.

---

## 1. La decisión a tomar

**Qué forma tiene la arquitectura del método después de la reforma.**

No es "qué defectos arreglar" — ésos ya están medidos y listados (§2 del
documento de arquitectura). Es la pregunta de arriba: cuál es la **estructura**
que decide, para cada pieza de trabajo, cuánto rigor se aplica y cómo se sabe
si se aplicó.

### Por qué esta decisión justifica análisis formal

Las cuatro condiciones del handbook (p. 166-167), contestadas:

| Condición | ¿Se cumple? |
|---|---|
| **Complexity** — las ramificaciones son difíciles de ver sin análisis | Sí. Cada alternativa toca la cascada, el PDP, las naturalezas y los frenos a la vez |
| **Uncertainty** — la incertidumbre en las entradas cambia el ranking | Sí, y está identificada: el costo real por sesión de la alternativa B no se puede medir hasta la fase 7 |
| **Multiple Attributes** | Sí: seis criterios, ninguno dominante por sí solo |
| **Diversity of Stakeholders** | **No.** Hay una sola persona. Es la única de las cuatro que no aplica, y se declara |

> "Satisfaction of all of these conditions is not a requirement for initiating
> decision analysis. The point is, rather, that the need for decision analysis
> increases as a function of the above conditions." (p. 167)

Tres de cuatro. El análisis formal se justifica.

### Quién decide

El handbook pide que la autoridad de decisión se defina **antes** (p. 167). Acá
el arquitecto y el cliente son la misma persona, y eso no se disuelve: se
declara cuál de los dos roles decide qué (Rechtin, §5 de la ficha).

- **La forma de la arquitectura** la decide el rol *arquitecto* — esta sesión,
  con el trade study escrito.
- **Si la arquitectura sirve** lo decide el rol *cliente*, el que ejecuta el
  lunes, y **no puede decidirlo ahora**: lo decide la fase 7 con el costo por
  sesión medido contra el baseline.

Esa separación es la que hace que la recomendación de acá no sea también su
propia validación.

---

## 2. Los criterios — ESCRITOS ANTES DE PUNTUAR

Dos clases, y no se mezclan. El handbook es explícito (p. 168): *"Criteria may
be mandatory (i.e., 'shall have') or enhancing. An option that does not meet
mandatory criteria should be disregarded."* Un criterio obligatorio **descalifica,
no puntúa**: meterlo adentro de una matriz ponderada deja que una alternativa
compense el incumplimiento con puntaje en otro lado.

### 2.1 Criterios mandatorios (filtro — descalifican, no puntúan)

| # | Criterio | De dónde sale |
|---|---|---|
| **M1** | Lo que se instale tiene que poder desinstalarse solo | `CLAUDE.md` regla 6; pilar *el costo de deshacer* |
| **M2** | Cada freno actual entra a la arquitectura nueva **con su impacto original escrito**, o no sale | `PDP.md` §5, riesgo "se reforma el método y se pierde lo que resolvía"; pilar *el freno que nunca salta* |
| **M3** | Cada pieza nueva tiene un medidor, y el medidor se puede sabotear | `CLAUDE.md` regla 3 |

### 2.2 Criterios ponderados

Escala **1-3-9** (la que el handbook nombra en p. 169), con **definición
operacional** de cada nivel — porque *"the most important thing to remember is
to have operational definitions of the scale"* (p. 169).

| # | Criterio | Peso | 9 | 3 | 1 |
|---|---|---|---|---|---|
| **C1** | **Costo de operación por sesión** | 30 | la sesión lee **menos** que hoy en un arranque típico, y menos actos dependen de que se acuerde | lee lo mismo | lee más, o suma actos que dependen de memoria |
| **C2** | **Defectos medidos que cierra** | 25 | cierra 8 o más de los 13 defectos de §2 del doc. de arquitectura | cierra 4 a 7 | cierra 3 o menos |
| **C3** | **Costo de migración (fase 6)** | 15 | se migra un proyecto real en una sesión | dos o tres sesiones | reescribe los archivos vivos de raíz |
| **C4** | **Trazabilidad a las fuentes** | 10 | cada pieza tiene página y cita de uno de los cuatro libros | la mayoría la tiene | es invención propia con vocabulario prestado |
| **C5** | **Adopción graduable y reversible** | 10 | se adopta pieza por pieza y el estado "todavía no adoptado" no rompe nada | se adopta en bloques | es todo o nada |
| **C6** | **Detecta su propio desuso** | 10 | produce una señal contable cuando se la está dejando de usar | hay que mirar a mano | el desuso es invisible |

**Suma de pesos: 100. Máximo posible: 900.**

**C1 se lleva el peso más grande a propósito.** El riesgo de mayor probabilidad
× consecuencia del `PDP.md` §5 es *"la arquitectura nueva es más pesada que la
vieja y se deja de usar"*, y el SEH lo dibuja (Fig. 4.1, p. 215): demasiado poco
proceso sube el riesgo técnico, **demasiado proceso sube el costo**. Una
arquitectura que se abandona vale cero por buena que sea.

**C6 existe porque C1 no se puede medir hasta la fase 7.** Si la arquitectura no
puede avisar que se la dejó de usar, el riesgo #1 se materializa en silencio —
que es el modo de falla que este repo ya sufrió cuatro veces documentadas.

---

## 3. Las alternativas

> "These solutions should cover the full decision space as defined by the
> understanding of the decision and definition of the decision criteria."
> (p. 164)

El espacio de decisión es *cuánta estructura formal se adopta*. Las tres cubren
sus extremos y el medio.

### A — Evolución in situ ("parchar los moldes")

Se conserva todo: la cascada de seis niveles, las tres naturalezas por dominio,
el PDP, los frenos. Se le agregan a los moldes los campos que las cuatro fases
de lectura mostraron que faltan: *cómo se certifica* el criterio de salida, la
salida *cancelar*, y una matriz de cumplimiento por proyecto adjunta al PDP.

**Es el mínimo cambio que responde a los hallazgos.**

### B — Catálogo + matriz, con rigor por aspecto

Las reglas del método se vuelven un **catálogo numerado, derivado de sus
archivos fuente**, donde cada regla lleva su enunciado, **su porqué** y su
medidor. Cada proyecto declara una **matriz de cumplimiento por aspecto**
(no por proyecto entero) con tres estados: cumple / recortado con la resta
escrita / no aplica. El rigor deja de decidirlo la naturaleza y pasa a
decidirlo un selector de dos ejes (reversibilidad × incertidumbre). Las
naturalezas se conservan, con un trabajo más chico: decir **qué se lee**.

### C — Re-arquitectura por procesos

Se adopta la estructura de procesos de la fuente: los 17 procesos comunes de
NASA (o los 30 del ISO/IEC/IEEE 15288, ya mapeados en la fase 3) como esqueleto
del método, con tailoring formal proceso por proceso, entradas y salidas
declaradas, y el ciclo de vida por fases del handbook.

**Es la máxima fidelidad a la fuente**, y la referencia contra la cual se mide
cuánto se está recortando.

### Opciones consideradas y descartadas antes de puntuar

El handbook pide documentar que se consideraron (p. 168):

| Opción | Por qué no llegó a la matriz |
|---|---|
| **No hacer nada** | Es el caso degenerado de A con cero campos agregados. Queda cubierta: si A pierde, "no hacer nada" pierde por más |
| **Adoptar el perfil VSE `Entry` de ISO/IEC/IEEE 29110 tal cual** | El SEH lo nombra (p. 219) y el repo **es** una VSE `Entry`. Pero la norma no está entre las 10 fuentes medidas: adoptarla sería citar un libro que no se abrió — el defecto que esta misma fase le encontró a `ingenieria-de-sistemas.md`. Vuelve como candidata cuando la norma esté en `pilares/fuentes/` |
| **Delegar la decisión a un LLM externo** | Hay lección propia medida: de 4 propuestas, 3 ya estaban implementadas (`gemini-review-vs-source-fisica-espacial`). No es revisión independiente |

---

## 4. Método de evaluación

**Matriz ponderada.** El handbook la nombra entre los métodos típicos (p. 168) y
la trata como el método por defecto: *"Completing the decision matrix can be
thought of as a default evaluation method."* (p. 169).

Se eligió sobre las otras porque el criterio de la p. 168 es que *"the complexity
of the decision analysis should fit the complexity of the mission"*: para una
decisión de seis atributos y tres alternativas en un sistema de una persona, una
simulación o un prototipo cuestan más que la decisión.

**Limitación declarada:** los puntajes de C1 y C3 son **estimaciones del
arquitecto sin dato de campo**. El único que tiene medición previa es C2
(los 13 defectos están contados y anclados). Esto entra al análisis de
robustez de §7.

---

## 5. Primera pasada — y por qué no cerró

| | C1 (30) | C2 (25) | C3 (15) | C4 (10) | C5 (10) | C6 (10) | **Total** |
|---|---|---|---|---|---|---|---|
| **A** | 9 | 3 | 9 | 3 | 9 | 1 | **610** |
| **B** | 3 | 9 | 3 | 9 | 9 | 9 | **630** |
| **C** | 1 | 9 | 1 | 9 | 1 | 3 | **400** |

**A 610, B 630.** Tres coma tres por ciento de diferencia sobre un máximo de
900, con dos de los seis criterios estimados a ojo. Eso no es una victoria: es
un empate, y el libro dice qué hacer con un empate.

> "If trade results are inconclusive, then the wrong selection criteria were
> used." (Rechtin & Maier, p. 402)

Y el handbook dice **qué** se rehace, que es la parte que casi nadie hace:

> "If this occurs, the decision criteria should be reevaluated, not only the
> weights, but the basic definitions of what is being measured for each
> alternative." (p. 169-170)

---

## 6. Qué estaba mal — el defecto estaba en C1, y no era el peso

**C1 se puntuó midiendo cuánto cambia cada alternativa, no cuánto cuesta operar
la que resulte.** Son cosas distintas, y confundirlas hace que "no cambiar nada"
gane por construcción: cualquier criterio que premie la quietud le da 9 al statu
quo antes de mirar si el statu quo es caro de operar.

Y el statu quo **es** caro de operar, con dato medido en el arranque de esta
misma sesión: el hook de `chequeo-de-trabajo.md` inyectó **90,7 KB** (el archivo
fuente pesa 192 KB), y el propio archivo dice, en su **línea 19**, que "por
tamaño se lee en diagonal". Eso no es costo cero. Es costo pagado y
desperdiciado.

**La definición operacional corregida de C1** — la que quedó escrita en §2.2 y
la que se usa de acá en adelante:

> Un 9 es que la sesión **lea menos** que hoy en un arranque típico **y** que
> menos actos dependan de que alguien se acuerde. Un 1 es que lea más, o que
> sume actos que dependen de memoria.

Con esa definición, y sin tocar ningún peso:

- **A** baja de 9 a **3**: la cascada queda igual de pesada, `chequeo-de-trabajo`
  se sigue inyectando entero, y se **suma** una matriz para leer. Aplicar las
  reglas sigue dependiendo de acordarse.
- **B** sube de 3 a **9**: la matriz se lee **por excepción** —el default es
  silencio, y la justificación se llena sólo cuando se recorta (NASA p. 41)— y
  la pieza P5 saca de la inyección las lecciones que se pegan a los pasos.
- **C** queda en **1**: sin discusión.

---

## 7. Segunda pasada — el resultado

| | C1 (30) | C2 (25) | C3 (15) | C4 (10) | C5 (10) | C6 (10) | **Total** | % del máximo |
|---|---|---|---|---|---|---|---|---|
| **A** — evolución in situ | 3 | 3 | 9 | 3 | 9 | 1 | **430** | 48 % |
| **B** — catálogo + matriz | **9** | **9** | 3 | **9** | **9** | **9** | **810** | **90 %** |
| **C** — re-arquitectura por procesos | 1 | 9 | 1 | 9 | 1 | 3 | **400** | 44 % |

### Los tres pasan el filtro mandatorio

Ninguna se descalifica por M1, M2 o M3: las tres son instalables y
desinstalables, las tres pueden llevar el impacto original de cada freno, y las
tres admiten medidor. **El filtro no descartó a nadie, y eso también se
reporta** (p. 168: los criterios que no resultaron significativos se documentan
como considerados).

### Análisis de robustez

El handbook pide que la recomendación venga con *"an assessment of the robustness
of the ranking (i.e., whether the uncertainties are such that reducing them
could credibly change the ranking)"* (p. 169), y define el umbral (p. 165):

> "If there is enough uncertainty in the alternatives' performance that the
> decision might change if that uncertainty were to be reduced, then
> consideration needs to be given to reducing that uncertainty."

La incertidumbre grande es una sola: **C1 de B es una predicción, no una
medición.** Se prueba el caso peor:

- Si B resultara costar por sesión **lo mismo** que hoy (C1 = 3, no 9):
  B = 630, A = 430. **B sigue ganando por 200 puntos.**
- Si B resultara costar **más** que hoy (C1 = 1, el peor caso posible):
  B = 570, A = 430. **B sigue ganando por 140.**

**El ranking es robusto**: no hay valor de C1 que dé vuelta el resultado, porque
A pierde por C2, C4 y C6 aunque C1 empate. Por lo tanto, y aplicando el criterio
del handbook, **reducir esa incertidumbre ahora no es *net beneficial*** (p. 166):
medir el costo por sesión de una arquitectura que todavía no existe cuesta la
fase 6 entera y no cambiaría la elección.

**Dónde se paga:** esa incertidumbre no desaparece, se difiere a la fase 7, que
es la que la mide contra el baseline. Si ahí el costo sube, lo que se corrige es
el alcance de la matriz —se recorta— y no la elección de arquitectura: está
escrito así en el riesgo #1 del `PDP.md` §5.

---

## 8. Recomendación y decisión

**Recomendada y adoptada: la alternativa B — catálogo + matriz, con rigor por
aspecto.** Es la de mayor puntaje, y el handbook dice que ése es el caso normal
(p. 169): la explicación se debe cuando se recomienda una **más baja**, no ésta.

### Por qué perdió cada una

**A — evolución in situ (430/900).** Perdió por dos cosas, y ninguna es el
costo de migrar, que es donde gana:

1. **Cierra 3 de los 13 defectos.** Agrega campos a los moldes (D2, D3) y una
   matriz por proyecto (D1 parcial), pero deja intactos el selector de rigor por
   dominio (D4), el rigor por proyecto en vez de por aspecto (D5), la inyección
   en diagonal (D6), el criterio de entrada al registro (D7), la mezcla System
   2 / System 3 (D10) y la ausencia de validación (D11).
2. **El desuso le sigue siendo invisible (C6 = 1).** Un molde con un campo más
   no avisa cuando el campo se deja vacío sesión tras sesión. Y ése es
   exactamente el modo en que se perdieron las reglas anteriores: la regla 3 de
   la estructura se incumplió durante una sesión entera en 2026-08-28 y **nada lo
   notó**, porque el incumplimiento no dejaba rastro contable.

A es la alternativa que **se siente barata y no lo es**: paga el costo de tocar
los moldes y no compra la señal que hace falta para saber si sirvió.

**C — re-arquitectura por procesos (400/900).** Perdió por el criterio de mayor
peso, y la fuente misma lo advierte. Adoptar 17 o 30 procesos en un sistema de
una persona es, palabra por palabra, la segunda de las cinco trampas de
tailoring del SEH 5.ª ed. (p. 218):

> "Using all processes and activities 'just to be safe'"

Y Rechtin pone el límite del otro lado (p. 36): *"A complete process with
step-by-step designated models and transformation heuristics is not appropriate
for general systems architecting."* C obtiene 9 en fidelidad y en defectos
cerrados **en el papel** — y ése es el punto: una arquitectura que cierra todos
los defectos y no se usa los deja todos abiertos en la práctica.

C no se tira: **queda como la vara**. La matriz de cumplimiento mide contra los
17 procesos de NASA, así que cada vez que se recorta uno queda escrito cuánto se
está recortando respecto de C. Es el uso correcto de la alternativa perdedora:
referencia, no cajón.

### Lo que la decisión NO incluye

- **No se toca ningún archivo vivo.** La adopción es la fase 6.
- **La revisión independiente sigue sin respuesta.** Ninguna de las tres
  alternativas la resuelve; B la hace *visible* (entra a la matriz como fila
  recortada con su justificación), que no es lo mismo que resolverla.

---

## 9. Supuestos y limitaciones de este estudio

Lo que el handbook pide capturar (p. 170), sin adornos:

1. **Cuatro de los seis puntajes son juicio del arquitecto, no medición.** Sólo
   C2 tiene base contada (los 13 defectos están anclados a archivo y línea) y C4
   es verificable contra las fichas. C1, C3, C5 y C6 son estimaciones.
2. **El evaluador es el autor de la alternativa ganadora.** No hay revisión
   independiente de este trade study, por la misma razón por la que el hueco
   entra a la matriz. Lo más cerca que llega el repo es que otra sesión, en otra
   fase, lo relea — y hay caso propio de que eso funciona (los cinco defectos de
   `verificar-citas.py` v1 los encontró otra sesión, no la que lo escribió).
3. **La escala 1-3-9 comprime.** Una diferencia real chica entre dos
   alternativas se convierte en 3 contra 9. Se eligió igual porque el handbook
   la nombra y porque una escala más fina fingiría una precisión que estos
   puntajes no tienen.
4. **Los pesos no se validaron con análisis de sensibilidad completo**, sólo
   contra la incertidumbre identificada como dominante (C1). Un barrido de todos
   los pesos costaría más que la decisión.
5. **Dos alternativas del espacio quedaron fuera por falta de fuente medida**
   (el perfil VSE `Entry`), y eso es una limitación del estudio, no del método.

---

## 11. Un defecto apareció después de cerrado el estudio — y no lo reabre

Al medir los requisitos de la arquitectura (§9 del documento de arquitectura)
apareció **D14**: `verificar-requisito.py` es un chequeo de idioma inglés
aplicado a un repo que escribe en español, con falso rojo en el 100 % de los
enunciados y falsos verdes en las cuatro reglas léxicas que más rinden.

**No reabre el trade study, y la razón se escribe en vez de suponerse:** D14 es
un defecto de **herramienta**, no de **arquitectura**. Las tres alternativas lo
heredan igual porque ninguna toca el chequeo de requisitos. Re-puntuar C2 con 14
defectos en vez de 13 sube el denominador de las tres por igual y deja el
ranking donde está: B 810, A 430, C 400.

Queda anotado acá, y no borrado del historial, porque el handbook pide capturar
las *lessons learned* del propio proceso de decisión (p. 170). La lección es del
orden del trabajo: **los requisitos se midieron después de elegir la
arquitectura, y ése fue el momento en que apareció el defecto del medidor.**
Medirlos antes habría encontrado D14 antes — y no habría cambiado la elección,
pero lo barato no era el resultado: era saberlo antes de escribir §7.

---

## 10. Trazabilidad

| Pieza de este informe | Fuente | Página |
|---|---|---|
| Los siete contenidos del informe de decisión | NASA SP-2016-6105 | 164-165 |
| Las 4 condiciones que justifican análisis formal | NASA | 166-167 |
| Autoridad de decisión definida antes | NASA | 167 |
| Mandatorio descalifica, no pondera | NASA | 168 |
| Escala 1-3-9 y definiciones operacionales | NASA | 169 |
| Matriz ponderada como método por defecto | NASA | 168-169 |
| Documentar opciones consideradas y descartadas | NASA | 168 |
| Si gana una más baja, se explica; si empata, se rehacen las **definiciones** | NASA | 169-170 |
| Robustez del ranking y *net beneficial* | NASA | 165-166 |
| "If trade results are inconclusive, the wrong selection criteria were used" | Rechtin & Maier | 402 |
| Límite del proceso paso a paso completo | Rechtin & Maier | 36 |
| Las cinco trampas de tailoring | INCOSE SEH 5.ª ed. | 218 |
| Demasiado proceso sube costo y cronograma (Fig. 4.1) | INCOSE SEH 5.ª ed. | 215 |
| La matriz trae el porqué de cada requisito | NASA | 36 |
| Default silencio; justificación sólo al recortar | NASA | 41 |
