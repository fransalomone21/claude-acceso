# Arquitectura del método — diseño de la reforma

**Fase 5, 2026-09-17.** Diseño. **No toca ningún archivo vivo**: la migración
es la fase 6.

Este documento dice **qué forma tiene** la arquitectura nueva y **por qué cada
pieza está donde está**. La elección entre alternativas está en
[`trade-study.md`](trade-study.md); las filas concretas de este proyecto están
en [`matriz-cumplimiento.md`](matriz-cumplimiento.md).

Las entradas son las cuatro fichas de lectura cerradas en las fases 1-4:
`nasa-seh/` (17 tramos), `incose-gtwr/reglas.md`, `incose-seh/mapeo-15288.md`,
`rechtin-maier/heuristicas.md`. Cada afirmación de acá que venga de un libro
lleva su página.

---

## 1. El hallazgo que manda la reforma

**Una organización elige qué reglas de su método cumple, y lo escribe.** Tres
fuentes confirmadas, independientes:

| Fuente | Dónde | Qué dice |
|---|---|---|
| NASA SP-2016-6105, cap. 3.11 | p. 34-42 | Tailoring, tipos A-F y la **Compliance Matrix**: "documents the program/project's compliance or intent to comply with the requirements of the NPR **or justification for tailoring**" (p. 35) |
| SEMP §9.0 | p. 232 | La matriz se adjunta al plan |
| INCOSE GtWR, R39 | p. 84 | Lo mismo, del lado de los requisitos |

El SEH 5.ª ed. **no la agrega**, y eso también es un dato: aporta el *proceso*
de tailoring con entradas y salidas (p. 216-218) y las **cinco trampas**
(p. 218), de las cuales cuatro describen errores ya cometidos en este repo.

**Lo que esto cambia.** Hoy una regla del método se cumple o se incumple; no hay
tercer estado. El incumplimiento, por lo tanto, es **silencioso**: no deja
rastro. La matriz ofrece el tercer estado —*recortado, con justificación
escrita*— y convierte el silencio en una excepción declarada, que es auditable.

Y hay caso propio, del 2026-08-28: la regla 3 de la estructura ("todo proyecto
nuevo nace de un PDP y nace acá adentro") se incumplió durante una sesión
entera y **nada lo notó**. No fue indisciplina: las cuatro reglas miraban
adentro de `proyectos/`, y un proyecto que nace en el Escritorio era invisible
por construcción.

---

## 2. Los 14 defectos medidos de la arquitectura actual

Cada uno con su fuente y, cuando lo hay, su caso propio ya vivido. Esta lista es
el denominador de C2 en el trade study.

| # | Defecto | Fuente | Caso propio |
|---|---|---|---|
| **D1** | No existe el tercer estado: una regla se cumple o se incumple, y el incumplimiento es invisible | NASA 3.11.3 p. 35; SEMP 9.0 p. 232; GtWR R39 p. 84 | La regla 3 de la estructura, 2026-08-28 |
| **D2** | El molde de fase pide el criterio de salida y **no pide el medidor** | Rechtin p. 398: "define how an acceptance criterion is to be certified at the same time the criterion is established" | Una fase de `fisica-espacial` cerrada en falso por un `grep` que medía si la palabra estaba, no el contenido |
| **D3** | Una fase sólo puede cerrar produciendo un artefacto; no existe la salida **cancelar la siguiente** | SEH p. 223 | — |
| **D4** | Las naturalezas clasifican por **dominio**; el rigor lo decide la **incertidumbre** | SEH Fig. 4.3 p. 222; Tabla 2.2 p. 34 | — |
| **D5** | El rigor se gradúa por **proyecto entero** (`PDP.md` §3, criticidad) | NASA p. 39: "the tailoring approach may permit more tailoring for those aspects of the project that are simpler" | Un mismo proyecto de BLACK: el análisis se rehace en una tarde, el parche binario sin backup no |
| **D6** | `chequeo-de-trabajo.md` se inyecta entero: es la forma 1 de Rechtin a escala | Rechtin p. 35, tres formas de usar heurísticas; límite en p. 36 | 90,7 KB inyectados en este arranque; el archivo dice en su línea 19 que "se lee en diagonal" |
| **D7** | El registro de lecciones tiene criterio de **salida** (`--triage`) y no de **entrada** | Rechtin p. 33-34, los cinco criterios de selección | — |
| **D8** | No hay revisión independiente | Rechtin §3.7 de la ficha | De un LLM externo: 4 propuestas, 3 ya estaban implementadas |
| **D9** | El corte NASA 3/4 (lógico/físico) y el INCOSE T4/T5 (arquitectura/diseño) no se pueden cumplir a la vez sin duplicar artefactos | `mapeo-15288.md` §3.1 | — |
| **D10** | `perfil-global` (System 3) y el repo (System 2) viven mezclados en la misma cascada | SEH p. 223 | — |
| **D11** | Todos los verificadores miden **cumplimiento con lo que escribimos**; ninguno mide **si sirvió** | NASA p. 11, verificación ≠ validación | — |
| **D12** | Números escritos a mano que divergen del registro que describen | Rechtin p. 401: "Constants aren't and variables don't." | `chequeo-de-trabajo.md:19` y `aprender.py:243` dicen 186; el registro tiene **204** al cerrar esta sesión. Ya había pasado: decía 45, había 76 |
| **D13** | `ingenieria-de-sistemas.md` resume el handbook **sin haber abierto el libro** | §8 de este documento | — |
| **D14** | `verificar-requisito.py` es un medidor de idioma inglés sobre un repo que escribe en español: falso rojo en el 100 % y falsos verdes en las cuatro reglas léxicas | §9 de este documento, medido hoy | 13 de 13 hallazgos falsos sobre A1-A10 |

**D14 apareció DESPUÉS del trade study**, midiendo los requisitos de §7 con la
herramienta del propio repo. No cambia el ranking y está explicado en
[`trade-study.md`](trade-study.md) §11: ninguna de las tres alternativas lo
cierra, porque es un defecto de herramienta y no de arquitectura.

**D12 es el más barato de entender y el que más veces volvió.** Está medido hoy:
`wc -l lecciones.jsonl` da 204 al cerrar esta sesión —eran 201 al abrirla— y los
dos archivos siguen diciendo 186. **La divergencia crece sola**, que es la prueba
de que el número no puede vivir escrito a mano. **No se arregla en esta fase**, y
la razón es de diseño: poner 204 vuelve a diverger mañana. El arreglo es
derivarlo del registro, y eso toca una herramienta viva → fase 6.

---

## 3. La arquitectura nueva — las diez piezas

La alternativa ganadora (B) se descompone en diez piezas. Cada una dice de dónde
sale, qué defecto cierra y **cómo se sabrá que está puesta** — ese último campo
existe por D2: un criterio sin medidor no es un criterio.

### P1 — El catálogo de reglas, **derivado** de sus fuentes

**Qué es.** Un índice numerado (`R1..Rn`) de todas las reglas del método, hoy
dispersas en cuatro lugares: `~/.claude/CLAUDE.md` (12 reglas), el `CLAUDE.md`
del repo (4 de estructura + los frenos), las tres naturalezas (5 "no
negociables" cada una) y el molde del PDP. Cada entrada lleva tres campos:
**enunciado**, **por qué existe** y **cómo se verifica**.

**Por qué el porqué es obligatorio.** NASA p. 36: *"The Compliance Matrix
provides rationales for each of the NPR requirements to assist in
understanding."* Una regla sin su razón escrita **no se puede tailorear**,
porque no hay contra qué comparar el costo de sacarla. Una regla huérfana de
razón sólo admite obediencia o desobediencia, que son las dos peores opciones.

**La decisión de diseño que evita repetir D12: el catálogo no copia, deriva.**
Si el catálogo transcribe los enunciados, en tres meses dice una cosa y el
archivo fuente otra — que es exactamente 186 contra 204, otra vez y más grande.
El catálogo se **genera** de los archivos fuente con ancla a archivo y línea; lo
único que se escribe a mano es el **porqué** y el **medidor**, que no viven en
ningún otro lado.

**Cierra:** D1 (parcial), D12 (el patrón, no la instancia).
**Se sabrá que está puesta si:** cambiar el enunciado de una regla en su archivo
fuente cambia el catálogo sin que nadie lo edite.

### P2 — La matriz de cumplimiento, por proyecto

**Qué es.** Una tabla adjunta al PDP con las columnas de la Tabla 3.11-3 (p. 41),
traducidas en §11.1 de la ficha de tailoring:

`Regla | Aspecto | Estado | Justificación`

Tres estados: **cumple** / **recortado** / **no aplica**.

**La mecánica que la hace barata: el default es silencio.** La justificación se
llena **sólo cuando se recorta** (NASA p. 41). Una matriz de un proyecto
disciplinado es casi toda "cumple" y no se lee; lo que se lee son las
excepciones. Eso es lo que hace que agregue información sin agregar lectura.

**El recorte lleva la resta escrita.** NASA p. 36, forma 2 de tailorear:
*"when the cost of implementing the requirement adds more risk to the project by
diverting resources than the risk of not complying"*. La pregunta antes de
saltear un paso no es "¿tengo tiempo?" sino **"¿qué riesgo compra este paso, y
qué riesgo crea el tiempo que se lleva?"**. Si la resta no se puede escribir, no
es tailoring: es indisciplina.

**Dónde vive.** NASA p. 35 admite las dos formas: adjunta al SEMP, o dentro del
plan si no hay SEMP stand-alone. Acá no hay SEMP: hay PDP. **La matriz es una
sección del PDP**, no un archivo aparte — y ésa es una aplicación directa de
3.11.4.2 (p. 37), que dice que el NPR no exige documentos stand-alone.

**Cierra:** D1, D8 (lo hace visible, no lo resuelve).
**Se sabrá que está puesta si:** un proyecto tiene al menos una fila `recortado`
con su resta escrita, y la fila se puede contar por script.

### P3 — El selector de rigor: dos ejes, y **por aspecto**

**Qué reemplaza.** El campo "Criticidad" del `PDP.md` §3
(`crítico`/`importante`/`descartable`), que hoy se declara **una vez para el
proyecto entero**.

**Por qué está mal.** NASA p. 39, la advertencia sobre la Tabla 3.11-1:

> "Many projects will have characteristics of multiple types, so the tailoring
> approach may permit more tailoring for those aspects of the project that are
> simpler and more open to risk and less tailoring for those aspects of the
> project where complexity and/or risk aversion dominate."

**El tailoring se aplica por aspecto.** Clasificar el proyecto entero de un
saque es la forma fácil y la equivocada.

**Los dos ejes:**

| Eje | La pregunta | De dónde sale |
|---|---|---|
| **Reversibilidad** | ¿Puedo volver a intentarlo, y cuánto cuesta? | NASA Tabla 3.11-1, criterio 8 (*alternative research or re-flight opportunities*) — el que más se traslada fuera del dominio espacial; pilar *el costo de deshacer* |
| **Incertidumbre** | ¿Se conocen los requisitos al empezar? | SEH Tabla 2.2 p. 34; el eje `certain/uncertain × static/dynamic` de la Fig. 4.3 p. 222 |

Ejemplos ya vividos, de las fichas: en BLACK, el **análisis** es barato de
rehacer (recorte agresivo) y el **parche binario sin backup** es irreversible
(cumplimiento pleno). En un apunte, la **redacción** se rehace y la
**publicación a Drive para compañeros** no se despublica. En el telescopio, el
**CAD** se itera y el **corte de la pieza** es de un solo tiro.

**Qué pasa con las tres naturalezas: se quedan, con un trabajo más chico.** Hoy
hacen dos cosas a la vez —decir qué se lee y decir cuánto rigor va— y la segunda
la hacen por dominio, que es el eje equivocado. Pasan a hacer **sólo la
primera**: son el nivel 3 de la cascada y dicen qué se lee siempre en esa clase
de proyecto. Sus "cinco cosas que no se negocian" **no se tiran**: entran al
catálogo P1 como reglas con su porqué, y de ahí a la matriz.

Esto es lo que M2 exige: *cada freno actual entra con su impacto original
escrito, o no sale*.

**Cierra:** D4, D5.
**Se sabrá que está puesto si:** un mismo proyecto tiene dos aspectos con rigor
distinto declarado, y la diferencia se justifica por uno de los dos ejes.

### P4 — El molde de fase, con dos campos nuevos

**Campo nuevo 1: `Cómo se certifica`.** Rechtin p. 398: *"define how an
acceptance criterion is to be certified at the same time the criterion is
established"*. Hoy el PDP pide el criterio de salida y no pide el medidor.

Y lleva una exigencia que el caso propio hace obligatoria: **el medidor no puede
ser invariante bajo el error que busca**. La fase de `fisica-espacial` cerró en
falso porque el medidor era un `grep` del nombre de la sección: daba verde con
la sección vacía. Un medidor que no puede ponerse en rojo por el error que
vigila no es un medidor.

**Campo nuevo 2: la salida `cancelar`.** SEH p. 223: *"the outcome of stage
activity may simply be valuable learned knowledge that aborts the need for
producing artifacts of use in other stages"*. Hoy toda fase cierra produciendo
un artefacto, y por eso el sistema no tiene forma de decir "aprendimos que la
fase que viene no hace falta" sin que parezca un fracaso.

**Cierra:** D2, D3.
**Se sabrá que está puesto si:** el molde tiene los dos campos y una fase real
cerró con `certificación` escrita antes de empezarla.

### P5 — Las heurísticas pegadas a los pasos (la forma 3 de Rechtin)

**El diagnóstico.** Rechtin p. 35 da tres formas de usar heurísticas: (1)
escanear la lista cuando hay un problema difícil, (2) codificar la experiencia,
(3) **pegarlas a los pasos de un proceso**. Este repo usa la 1 y la 2. La 1 a
escala es `chequeo-de-trabajo.md`: 90,7 KB inyectados en cada arranque, que el
propio archivo reconoce que "se lee en diagonal". El libro lo describe como
hojear una ferretería.

**El diseño.** Cada lección con `triage: propia` se ancla al **paso** donde se
aplica: *abrir proyecto* / *escribir un requisito* / *medir* / *cerrar fase* /
*publicar*. Lo que se inyecta en un arranque es el paso que corresponde, no el
catálogo entero.

**El límite, declarado ahora y no cuando duela.** El propio libro se lo pone
(p. 36): *"A complete process with step-by-step designated models and
transformation heuristics is not appropriate for general systems architecting.
There is simply too much variation from domain to domain."* **Sólo se pegan las
que no dependen del dominio.** Las de dominio se quedan donde están: en las
fichas por tema, buscables por síntoma con `aprender.py buscar`.

**Cierra:** D6.
**Se sabrá que está puesta si:** lo que se inyecta en un arranque típico pesa
menos que hoy, medido en KB, y la lección que corresponde al paso en curso está
adentro.

### P6 — El criterio de **entrada** al registro de lecciones

**Qué falta.** `aprender.py` exige `--triage`, que es la decisión de **salida**
(línea propia / foldeada / fuera). No tiene criterio de **entrada**: los cinco
de Rechtin p. 33-34, establecidos para *"eliminate unsubstantiated assertions,
personal opinions, corporate dogma, anecdotal speculation"*.

| # | Criterio (p. 33-34) |
|---|---|
| 1 | Tiene sentido en su dominio original |
| 2 | El sentido general aplica **más allá** del contexto original |
| 3 | Se racionaliza en unos minutos o en menos de una página |
| 4 | **El enunciado opuesto tiene que sonar tonto** |
| 5 | La lección, aunque no su formulación, resistió el paso del tiempo |

**El 4 es el más filoso y el más barato.** El libro lo ejemplifica con Murphy:
el opuesto de *si puede fallar, fallará* es *si puede fallar, no fallará*, que
es un disparate evidente. Una "lección" cuyo opuesto suena razonable no es una
lección: es una preferencia.

**El diseño mínimo:** `aprender.py agregar` imprime los cinco y exige contestar
el 4. No se automatiza el juicio; se obliga a emitirlo.

Y hay un hallazgo que va con esto: el criterio 2 —*el sentido general aplica más
allá del contexto original*— es **exactamente** la distinción que el campo
`triage` ya hace, sin tener el criterio escrito.

**Cierra:** D7.
**Se sabrá que está puesto si:** una lección agregada sin contestar el criterio
4 no entra al registro.

### P7 — La separación System 2 / System 3

**Qué dice la fuente.** SEH p. 223, modelo de tres sistemas anidados:
`perfil-global` es el **System 3** —el que "learns, configures, and matures
System-2", con responsabilidad de *situational awareness, evolution and
knowledge management*— y el repo de proyectos es el **System 2**, el que produce
el trabajo.

**Qué cambia.** Hoy los dos viven en la misma cascada de seis niveles, y eso
hace que una pregunta simple no tenga respuesta simple: *¿esto que estoy por
escribir, es del método o del proyecto?* Con la línea trazada:

| | System 3 — `perfil-global` | System 2 — el repo de proyectos |
|---|---|---|
| Artefactos | el catálogo P1, las lecciones, las fichas, los pilares | el PDP, la matriz P2, `ESTADO_ACTUAL`, `HANDOFF` |
| Cadencia | cambia entre proyectos | cambia dentro de un proyecto |
| Quién lo toca | la sesión que reforma el método | la sesión que hace el trabajo |

**La cascada ya insinúa la línea** —niveles 0-2 contra 3-6— y lo que hace esta
pieza es hacerla explícita en vez de inventar una estructura nueva. Eso es
deliberado: C3 (costo de migración) penaliza reescribir lo que ya funciona.

**Cierra:** D10.
**Se sabrá que está puesta si:** el catálogo P1 vive del lado del System 3 y
ninguna matriz de proyecto contiene reglas que no estén en él.

### P8 — La revisión independiente: sin respuesta, **declarada**

No se inventa una solución. Los tres candidatos más cercanos están evaluados y
ninguno lo es:

| Candidato | Por qué no es revisión independiente |
|---|---|
| El saboteador | Lo escribe el mismo que escribe el medidor. Prueba que la alarma suena; no que la alarma sea la correcta |
| Chat nuevo al cambiar de fase | Es lo más cerca que llega, y hay caso propio a favor: los cinco defectos de `verificar-citas.py` v1 los encontró **otra sesión en otra fase**. Pero comparte el método y los sesgos: es reemplazo de *equipo*, no de *criterio* |
| Un LLM externo | Medido: de 4 propuestas sobre `fisica-espacial`, **3 ya estaban implementadas** |

**El diseño es no tener diseño, y que eso ocupe una fila.** Entra a la matriz
como `recortado`, con la justificación escrita. Es el uso exacto de la matriz:
un hueco declarado se puede auditar; un hueco silencioso, no.

**Cierra:** D8, en el único sentido en que se puede cerrar hoy.

### P9 — El desacople D9 se resuelve **eligiendo**, y se declara

El corte de NASA entre el proceso 3 (descomposición lógica) y el 4 (definición
de la solución de diseño) y el corte de INCOSE entre T4 (arquitectura) y T5
(diseño) **no se pueden cumplir a la vez sin duplicar artefactos**.

**Se elige NASA.** La resta, escrita:

- **Lo que compra:** los 17 destilados del repo son de NASA, con ancla medida
  (`impresa = PDF + 10`) y citas al 99,1 %. El mapeo contra los 30 procesos del
  15288 ya está hecho (fase 3) y sigue siendo consultable, así que elegir NASA
  no pierde a INCOSE: lo deja como traducción.
- **Lo que cuesta:** el vocabulario del 15288 es el que usa el resto del mundo.
  Un documento del repo que diga "descomposición lógica" no se entiende afuera
  sin el mapeo al lado.
- **Por qué gana:** duplicar artefactos es precisamente lo que el tailoring
  existe para evitar, y la duplicación es lo único que permitiría cumplir los
  dos cortes.

**Cierra:** D9.
**Se sabrá que está puesto si:** la matriz tiene la fila con la elección y su
resta, y ningún artefacto existe en las dos particiones a la vez.

### P10 — El medidor que le falta a la fase 7 (validar ≠ verificar)

**El defecto D11 es el más caro del handbook** (p. 11): se puede verificar
perfecto y fallar la validación entera — construir con precisión la cosa
equivocada. Todos los verificadores de este repo miden *cumplimiento con lo que
escribimos*. Ninguno mide *si sirvió*.

**Las candidatas están identificadas:** las cuatro métricas de agilidad del SEH
(p. 165-166) — *timely, affordable, predictable, comprehensive*. Miden
**respuesta**, no cumplimiento.

**Esta pieza se diseña acá y NO se construye acá.** El criterio de salida de la
fase 5 es diseño; construir el medidor de validación es la fase 7, y hacerlo
antes sería medir una arquitectura que todavía no se usó. Queda declarado como
la entrada de esa fase, que es lo que corresponde.

**Cierra:** D11, como diseño. No como implementación.

---

## 4. Las cinco trampas de tailoring, contestadas una por una

El SEH 5.ª ed. (p. 218) lista cinco formas de tailorear mal. **Cuatro describen
errores ya cometidos en este repo**, así que no son advertencias teóricas: son
el historial.

| Trampa (p. 218) | Cómo la evita la arquitectura nueva |
|---|---|
| "Reuse of a tailored baseline from another system without repeating the tailoring process" | La matriz es **por proyecto** y sus filas son por **aspecto**. `nuevo-proyecto.ps1` puede copiar el molde, nunca las decisiones |
| "Using all processes and activities 'just to be safe'" | Es por lo que perdió la alternativa C. El default del selector P3 es el rigor más bajo que los dos ejes permitan, no el más alto |
| "Assuming there is a single set of measures, risks, or other controls that apply to all projects without tailoring" | Es D5, y lo cierra P3: el rigor se gradúa por aspecto |
| "Using a pre-established tailored baseline" | Las naturalezas eran justo eso: un baseline pre-tailoreado por dominio. P3 les saca esa función |
| "Failure to include relevant stakeholders" | La única que **no** aplica: hay una persona. Se declara, no se finge |

Y el balance que la Fig. 4.1 (p. 215) pone en un gráfico: poco proceso sube el
riesgo técnico, **demasiado proceso sube el costo y el cronograma**. Con la
frase que hace que la matriz no sea un acto de arranque único:

> "Tailoring occurs dynamically over the system life cycle depending on risk and
> the situational environment. Therefore, it should be continually monitored and
> adjusted as needed."

---

## 5. Lo que NO baja, ni en el proyecto más chico

De la Tabla 3.11-2 (p. 39-40): ni en el tipo F —el más simple— caen a *Not
Applicable* los requisitos, la documentación de diseño, el SEMP, el plan de
V&V, el plan de configuración ni el plan de lecciones aprendidas. **Bajan a
`Tailor`, nunca a "no existe".**

Traducido al piso de un proyecto de una persona: **que exista escrito qué
querías, qué decidiste, cómo se verifica, qué versión es y qué aprendiste.**
Todo lo demás es negociable.

Eso es, casualmente, lo que el repo ya tiene: PDP §1 (qué querías), PDP §6
(decisiones), PDP §7 (verificación), git (versión) y `lecciones.jsonl` (qué
aprendiste). **El piso ya estaba puesto.** La reforma no lo agrega: le pone
nombre y lo vuelve auditable.

---

## 6. Lo que la arquitectura nueva NO cambia

Lo más importante de un diseño es su alcance negativo. Nada de esto se toca:

- **La cascada de seis niveles.** Funciona, `cascada.ps1` la mide contra el
  disco y no tiene ninguna lista propia. Lo único que cambia es que el nivel 3
  hace menos cosas (P3).
- **Las tres naturalezas.** Se quedan, con menos trabajo. Sus quince "no
  negociables" entran enteros al catálogo.
- **Las cuatro reglas de la estructura** y sus siete bloques de medición.
- **Las tres capas de frenos** (ReadOnly, hook `PreToolUse`, integridad medida)
  y los cuatro saboteadores.
- **Los dos cuadros** y sus topes duros.
- **El enrutado de modelo y esfuerzo.**

Cada una de éstas es un freno diseñado contra un impacto concreto, y M2 exige
que entre con ese impacto escrito o no salga. Ninguna sale.

---

## 7. Los requisitos de la arquitectura nueva

Escritos como requisitos, para poder medirlos con la herramienta del propio
repo (`incose-gtwr/verificar-requisito.py`, fase 2).

| # | Requisito |
|---|---|
| **A1** | El catálogo de reglas debe derivarse de los archivos fuente de cada regla, sin transcribir su enunciado. |
| **A2** | Cada regla del catálogo debe llevar escrito el impacto contra el que fue diseñada. |
| **A3** | Cada proyecto debe declarar una matriz de cumplimiento adjunta a su PDP. |
| **A4** | Cada fila recortada de la matriz debe llevar escrita la comparación entre el riesgo que evita la regla y el riesgo que crea el tiempo de cumplirla. |
| **A5** | La matriz debe dejar vacía la justificación de cada fila que cumple. |
| **A6** | El rigor debe declararse por aspecto del proyecto y no por proyecto. |
| **A7** | El molde de fase debe pedir cómo se certifica el criterio de salida antes de abrir la fase. |
| **A8** | El molde de fase debe admitir el cierre por cancelación de la fase siguiente. |
| **A9** | El registro de lecciones debe rechazar una lección cuyo enunciado opuesto no sea absurdo. |
| **A10** | El arranque de sesión debe inyectar menos bytes que el arranque medido el 17 de septiembre de 2026. |

**La medición de estos requisitos está en §9.** El resultado tiene una trampa
que hubo que medir antes de creerle.

---

## 8. El contraste de `ingenieria-de-sistemas.md` contra los libros

`perfil-global/engineering-orchestrator/referencias/ingenieria-de-sistemas.md`
(267 líneas) **se escribió sin abrir el handbook**. Contrastarlo es parte de
esta fase. Va el resultado, en tres grupos.

### 8.1 Lo que está bien — confirmado contra las fichas

- **Los 17 procesos, su agrupación 1-4 / 5-9 / 10-17 y el "baja y sube".**
  Correcto.
- **Verificación ≠ validación** (§2). Correcto, y es la distinción de la p. 11.
- **Riesgo = probabilidad × consecuencia, con disparador observable y dueño**
  (§4). Correcto.
- **Márgenes y reservas** (§5). Correcto en espíritu, y la traducción al
  presupuesto de contexto es propia y buena.
- **Revisiones como puertas con criterio de salida** (§6). Correcto.

### 8.2 Lo que está mal o mal atribuido — cuatro cosas

1. **§9 atribuye el tailoring a NPR 7150.2, clases A-F de *software*.** El
   tailoring del método está en NPR 7123.1 / handbook **cap. 3.11**, y sus tipos
   A-F son de **proyecto**, con otros criterios (los 8 de p. 35 más los 2
   agregados de la Tabla 3.11-1). **Son dos taxonomías distintas con las mismas
   letras**, y el documento las cruza.
2. **Falta la Compliance Matrix entera.** Un resumen del handbook que omite
   3.11.3 — que resultó ser, tres fases después, **el hallazgo que manda la
   reforma**. Es el costo concreto de resumir sin abrir el libro: no se pierde
   precisión, se pierde una sección.
3. **§6 omite la distinción tailor / customize** (p. 37): fusionar dos
   revisiones es gratis mientras se cumpla el propósito de las dos; saltear una
   exige waiver. Es la distinción más usable del capítulo y separa "trabajar
   rápido" de "trabajar sin red".
4. **§9 gradúa el rigor por proyecto** (la tabla crítico / importante /
   descartable) cuando el handbook lo gradúa **por aspecto** (p. 39). Es D5, y
   de acá salió: esa tabla es la que el `PDP.md` §3 copió.

### 8.3 Lo que no se puede confirmar, y se declara

**§10 (las *Power of Ten* de Holzmann), las referencias a NPR 7150.2, a swehb y
a SWE-030 no se verificaron contra fuente**: ninguna de esas cuatro está entre
las 10 fuentes de `pilares/fuentes/`. No se declaran erradas — se declaran **no
medidas**, que es distinto y es la regla 1.

### 8.4 Qué se hace con el archivo

**No se toca ahora.** Es un archivo vivo del perfil y la fase 5 no toca archivos
vivos. Entra a la fase 6 con esta lista, y con la pregunta que el contraste deja
abierta: si el documento se reescribe contra las fichas, ¿sigue haciendo falta,
o el catálogo P1 más las cuatro fichas ya lo reemplazan?

---

## 9. Medición de los diez requisitos — y el defecto D14, que apareció midiendo

Los requisitos A1-A10 están en [`requisitos.txt`](requisitos.txt) y se pasaron
por `verificar-requisito.py` (fase 2, 32 de las 41 reglas del GtWR).

```powershell
python perfil-global\pilares\incose-gtwr\verificar-requisito.py `
       proyectos\ingenieria\arquitectura-se\docs\requisitos.txt
```

**El resultado: 10 VIOLA y 3 REVISAR sobre 10 requisitos.** Y antes de reportar
eso como "los requisitos están mal escritos" hubo que mirar **qué** encontró:

| Hallazgo | Veces | Qué dice | Qué es en realidad |
|---|---|---|---|
| R1 VIOLA | **10 / 10** | "no hay verbo obligatorio (`shall`)" | Los diez dicen **«debe»**. R1 busca el literal inglés |
| R5 REVISAR | 1 | artículo indefinido `"a su"` | «a su PDP» — la preposición española *a* |
| R6 REVISAR | 1 | la cantidad `2026` no trae unidad | Es un año, no una cantidad |
| R33 REVISAR | 1 | valor de un solo punto sin tolerancia | El mismo 2026 |

**Los 13 hallazgos son falsos positivos de idioma. Señal útil: cero.**

### El control positivo, que es lo que lo confirma

El mismo requisito A7, traducido al inglés:

> *The phase template shall state how the exit criterion is certified before the
> phase opens.* → **0 VIOLA**, 1 REVISAR (R35, una palabra temporal que el
> propio chequeo declara que decide una persona).

El requisito no cambió de calidad al traducirse. Cambió de idioma.

### Y del otro lado: lo que en español no ve

Un enunciado deliberadamente malo, en los dos idiomas:

| Idioma | Violaciones |
|---|---|
| *El método debe permitir recortar cualquier regla apropiada si es necesario, etc.* | **2** (R1 por «debe», R9 por «etc.») |
| *The method shall allow tailoring of any appropriate rule if necessary, etc.* | **6** (R7 ×2 vagos, R8 escape, R9, R24 pronombre, R32 cuantificador) |

### D14 — el defecto que esto agrega a la lista

> **`verificar-requisito.py` es un medidor de idioma inglés aplicado a un repo
> que escribe en español. Sobre requisitos en español su señal es nula en las
> dos direcciones: un falso rojo constante (R1 en el 100 % de los enunciados) y
> falsos verdes en las cuatro reglas léxicas que más rinden (R7, R8, R24, R32).**

Es la tercera vez que aparece la misma clase de defecto —fase 1: un regex de
comillas miraba el 27 % del corpus; fase 4: el denominador del medidor de citas
descartaba 19 spans— y las tres veces se encontró **auditando lo que el medidor
no mira**, nunca leyendo su salida. La cabecera del propio script ya nombra el
modo de falla: *"un chequeo que grita donde no corresponde se apaga — que es la
forma en que mueren los frenos"*. R1 grita en el 100 % de los casos.

**Qué pasa con A1-A10 mientras tanto.** Quedan **sin verificar mecánicamente**,
y así se declaran. No se marcan en verde ni en rojo: el medidor disponible no
puede pronunciarse sobre ellos. Eso es la regla 1 — no reportar un escalón más
arriba de lo que se midió.

**El arreglo, y por qué NO es traducir los requisitos.** Escribirlos en inglés
compraría las cuatro reglas léxicas y costaría que el documento normativo del
método esté en un idioma que no es el del resto del repo; mantener las dos
versiones reintroduce D12, que es el defecto que esta arquitectura existe para
no repetir. **El arreglo es del lado del medidor**: agregarle las listas del
GtWR en español —el verbo obligatorio «debe/deberá», los términos vagos, las
cláusulas de escape— con la misma estructura de dos severidades que ya tiene, y
su saboteador. No es traducir el libro: es agregar el idioma en que se escribe.

**Va a la fase 6** con una condición de aceptación escrita ahora, porque toca
una herramienta viva: el chequeo en español tiene que dar **0 VIOLA sobre
A1-A10** y seguir dando **6 VIOLA** sobre el enunciado malo de la tabla de
arriba. Las dos mitades: sin la segunda, el arreglo puede ser apagar R1.

---

## 10. Trazabilidad — cada pieza contra su fuente

| Pieza | Fuente | Página |
|---|---|---|
| P1 — el catálogo lleva el porqué de cada regla | NASA | 36 |
| P2 — la Compliance Matrix, columnas y default silencio | NASA | 35, 41 |
| P2 — la resta del recorte (forma 2 de tailorear) | NASA | 36 |
| P2 — matriz adjunta al plan si no hay SEMP stand-alone | NASA | 35, 37 |
| P3 — tailoring por aspecto, no por proyecto | NASA | 39 |
| P3 — eje de reversibilidad (re-flight opportunities) | NASA Tabla 3.11-1 | 38 |
| P3 — eje de incertidumbre | INCOSE SEH 5.ª ed. | 34, 222 |
| P4 — certificar el criterio al establecerlo | Rechtin & Maier | 398 |
| P4 — una fase puede cerrar cancelando la siguiente | INCOSE SEH 5.ª ed. | 223 |
| P5 — las tres formas de usar heurísticas, y su límite | Rechtin & Maier | 35, 36 |
| P6 — los cinco criterios de selección | Rechtin & Maier | 33-34 |
| P7 — System 2 / System 3 | INCOSE SEH 5.ª ed. | 223 |
| P9 — el corte NASA 3/4 contra INCOSE T4/T5 | `mapeo-15288.md` §3.1 | — |
| P10 — las cuatro métricas de agilidad | INCOSE SEH 5.ª ed. | 165-166 |
| §4 — las cinco trampas de tailoring | INCOSE SEH 5.ª ed. | 218 |
| §4 — el balance de la Fig. 4.1 | INCOSE SEH 5.ª ed. | 215 |
| §5 — lo que no baja ni en tipo F | NASA Tabla 3.11-2 | 39-40 |
| §7 — los requisitos y su chequeo | INCOSE GtWR v3 | — |
| §2 D11 — verificación ≠ validación | NASA | 11 |
| §2 D12 — "Constants aren't and variables don't." | Rechtin & Maier | 401 |
