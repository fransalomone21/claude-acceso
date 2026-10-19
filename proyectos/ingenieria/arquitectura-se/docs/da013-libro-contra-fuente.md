# DA-013 ampliado: el libro de bolsillo contra sus fuentes

**2026-10-19.** Sesión lateral pedida por la sesión de arquitectura del mismo día (la de DA-065 a DA-070). Escalón 1
de `perfil-global/arquitectura/ORDEN-DE-ATAQUE.md`: *el conocimiento es correcto y llega al momento de usarlo*.

**Por qué.** El 2026-10-19 Santi marcó en la sección 1 del TP de IISE errores que el SEH ya decía. Los destilados
estaban medidos (99,1 % de citas contra el PDF), pero el **libro de bolsillo** —lo que la puerta hace leer
siempre— y la ficha del alcance eran paráfrasis **sin medidor contra su fuente**, y una paráfrasis infiel se ve
idéntica a una fiel. Esta tabla gradúa cada regla de los dos contra el libro de donde sale.

**Cómo se midió.** Cada cita contra el texto extraído del PDF (PyMuPDF, en el scratchpad de la sesión): NASA SEH
Rev2, su *Expanded Guidance*, el GtWR, el INCOSE SEH 5.ª, Rechtin & Maier, y las cinco fuentes de *Level 1*
(Leisner, TESS, Psyche, JWST, UNOOSA), que se copiaron a `perfil-global/pilares/fuentes/` y tienen ficha nueva
(`perfil-global/pilares/nasa-level1/`, 17/17 citas verificadas). Cada paráfrasis, contra el destilado y la página.
Lo de la cátedra, contra los módulos del apunte (m17, m18, m20, m21) y `catedras/*/CRITERIOS.md`.

**Grados.** `cita` = verbatim, medida · `fiel` = paráfrasis que dice lo que dice la fuente · `incompleta` = fiel
pero deja afuera algo que cambia cómo se aplica · `CAMBIABA` = paráfrasis que cambiaba el sentido (corregida) ·
`atribución` = la regla está bien y la fuente nombrada no era la que la dice (corregida) · `casa` = regla del
método (Fran, una lección), sin fuente externa y dicho así.

## 1. Resultado

| Grado (una fila con dos cuenta en el más grave) | `nucleo-ise.md` | `alcance-como-se-escribe.md` |
|---|---|---|
| cita | 2 | 6 |
| fiel | 31 | 8 |
| incompleta → completada | 4 | 0 |
| **CAMBIABA → corregida** | **6** | **1** |
| atribución → corregida | 2 | 0 |
| desactualizada → sacada | 1 | 0 |
| casa | 8 | 1 |
| **total de reglas** | **54** | **16** |

Ahora el libro cita en cursiva 18 pasajes y la ficha 7; **25 de 25 están en un destilado**, y ninguna cláusula de
escape queda sin quién (`perfil-global/herramientas/verificar-libro.py`, en la capa rápida de `chequeo-completo`,
con su autotest de 10 casos en la capa de saboteadores).

**Los seis que cambiaban el sentido, en una línea cada uno:**

1. **El orden de los procesos** (§1): «el orden no se saltea: 1 → 2 → 3 → 4» se leía como cascada; el SEH dice
   *«interdependent, highly iterative and recursive»* (p. 43) y el destilado lo subraya: un lazo, no una cascada.
2. **La necesidad «sin justificación debajo»** (§3b): se le atribuía al SEH, que admite un rationale *«where
   needed»* (p. 49). La regla queda, con quién la pone: la casa, sobre los ejemplares de la cátedra.
3. **Los niveles** (§4): el libro tenía L2 «segmento o elemento», L3 subsistema… L5 parte. La cátedra (diapo 5-38,
   M17) y el SEH (C.4) separan segmento y elemento: L2 segmento, L3 elemento, L4 subsistema, L5 componente, L6 parte.
4. **La solución en el requisito** (§4): el arreglo del 2026-10-19 dejó «sin excepción», pero los libros **sí**
   tienen una: GtWR R31 (*«unless there is rationale for constraining the design»*) y SEH p. 60 (*«If the
   requirement states a method of implementation, the rationale should state why…»*). Lo que la sesión del TP usó
   mal no fue la excepción sino su falta de **quién**: ahora el libro dice que la impone alguien de afuera (→
   restricción) o una decisión de diseño ya tomada arriba (→ derivado con rationale), y que en el tope no cabe.
5. **Los números en el tope** (§4): la regla de la cátedra (L0 sin números de desempeño) estaba escrita como
   general, y NASA como nota. NASA cuantifica en su *Level 1* la exactitud del resultado (Leisner p. 17) y el SEH
   escribe todo requisito en números (p. 192). Ahora: en una materia manda la cátedra; fuera, la forma de NASA.
6. **IRD e ICD cruzados** (§5): «IRD = entre dos que se desarrollan juntos» es del ICD. La *Expanded Guidance*
   §6.3.2 (p. 253-254): IRD = los requisitos en la frontera común; ICD = la solución física acordada entre las dos
   organizaciones; IDD = un diseño existente, de un solo lado. El SEH sólo los enumera (p. 137).
7. *(ficha)* **El orden de los elementos del alcance**: la tabla ponía la hipótesis antes que la misión; la cátedra
   los pide en cadena (M18: necesidad → meta → objetivo → misión → hipótesis → restricciones → autoridad → ConOps).

## 2. La tabla, regla por regla

### `nucleo-ise.md`

| # | Regla del libro | Fuente | Grado | Qué se hizo |
|---|---|---|---|---|
| 1.1 | 17 procesos en tres conjuntos; diseño baja, realización sube, gestión transversal | SEH p. 5-8 (`fundamentos.md` §3) | fiel | — |
| 1.2 | El orden 1 → 4 | SEH p. 43 (`stakeholders.md` §1) | **CAMBIABA** | «dependen en ese orden y se recorren en lazo», con la cita |
| 1.3 | Se baja hasta que se puede construir, comprar o reusar | SEH p. 6, *built, bought, or reused* | fiel | — |
| 1.4 | Recursivo ≠ iterativo | SEH p. 7 (NPR 7123.1) | fiel | — |
| 2.1 | Tabla de fases: para qué, qué produce, qué revisión | SEH §3.3-3.10 (`ciclo-vida.md`) | fiel | — |
| 2.2 | Pre-A: poca profundidad, horizonte completo | SEH, *through Operations and Disposal* (`ciclo-vida.md` l. 413) | fiel | — |
| 2.3 | El costo de cambiar: 3-6×, 20-100×, 500-1000× | SEH Fig. 2.5-1, p. 12-13 | cita | — |
| 2.4 | Cada fase cierra con un resultado verificable | Meadows (`pilares.md`) | casa | — |
| 2b.1 | Una fase se cruza con sus productos; delta SRR/PDR | Fran, 2026-10-12, sobre los productos del SEH | casa | — |
| 2b.2 | De la ambigüedad a lo bajo, con riesgo y triángulo de hierro | Fran, 2026-10-12 | casa | — |
| 2b.3 | Ágil para descubrir, con *spikes* | atribuido a INCOSE §4.2.2; *spike* tiene 0 apariciones en el SEH 5.ª | atribución | Fran + el enfoque ágil de INCOSE §4.2.2 (p. 221-224) |
| 3.1 | La cadena necesidad → … → validación | SEH (la V) | fiel | — |
| 3.2 | El documento de requisitos define el proyecto; una decisión sin traza es huérfana | Fran, 2026-10-07; SEH Tabla 4.2-1 | casa | — |
| 3.3 | Verificación ≠ validación; se valida temprano, con modelos | SEH p. 11 | fiel | — |
| 3b.1 | La necesidad es una frase y nada más | SEH p. 49 (cita); cátedra M17 | cita + **CAMBIABA** | «sin justificación» se atribuye a la casa; el SEH admite rationale *where needed* |
| 3b.2 | Meta: una frase amplia, evaluable aunque no sea numérica | SEH p. 49; Leisner p. 3 (*broad*) | fiel | — |
| 3b.3 | Objetivo: específico, medible, orientado al resultado, con criterios de éxito | SEH p. 49 (cuatro criterios); M18 | fiel | (falta «agresivo pero alcanzable»: está en la ficha del SEH) |
| 3b.4 | Las NGO no son requerimientos | SEH p. 48, *NGOs are not contractual requirements or designs* | fiel | — |
| 3b.5 | La forma se copia de ejemplares | lección del 2026-10-19 | casa | — |
| 4.1 | Necesidad → L0 … y los niveles | cátedra diapo 5-38 (M17); SEH C.4 | **CAMBIABA** | L2 segmento, L3 elemento … L6 parte, con la cita |
| 4.2 | El identificador dice el nivel (`L2-PLT-01`) | `auditar-sesion.py` | casa | — |
| 4.3 | Un requisito sin padre es huérfano | M17 (diapo 6-70); SEH C.4 | fiel | con la cita de C.4 (*If it is not necessary…*) |
| 4.4 | Asignado / derivado | SEH Fig. 4.2-3; M17 | incompleta | derivado: también por una restricción o algo implícito (M17) |
| 4.5 | `Cuando <condición>, el <sujeto> deberá…` | GtWR R1 (p. 51, ISO 29148) | fiel | — |
| 4.6 | Un «deberá» por oración, voz activa, sujeto del nivel | SEH p. 57 y C.2; GtWR R2-R3 | fiel | — |
| 4.7 | deberá / es / debería | SEH C.1; M17; M21 | fiel | — |
| 4.8 | Seis tipos, el sexto se olvida | M17 (diapo 5-60) | fiel | — |
| 4.9 | SMART | M21 | fiel | — |
| 4.10 | Cada número con unidad y tolerancia (el TVC) | SEH p. 56 y C.2; GtWR R6, R33 | fiel | — |
| 4.11 | Lo que no va en el enunciado | GtWR R7-R26; SEH C.2 y C.4 | incompleta | cada ítem con su regla; «al rationale» sólo R20 y R21 (lo dice el libro); se agregan operaciones y tareas (App. C) |
| 4.12 | Tampoco la solución | SEH App. C (cita); GtWR R31; SEH p. 60 | cita + **CAMBIABA** | la excepción de los libros, con quién la impone; ninguna en el tope |
| 4.13 | Tope: verbos de resultado, no de intención | Leisner p. 14-15 | incompleta | la lista verbatim (*study, investigate, perform, survey, search*; *determine, map*); «medir» por p. 15 |
| 4.14 | Tope sin instrumento, magnitud, plataforma ni componente | Leisner p. 10, 18; PET-47 | cita | — |
| 4.15 | Tope sin números de desempeño | M17; PET-12, 18; cohete REQ-L0-2 / Leisner p. 17; SEH p. 192 | **CAMBIABA** | quién manda: la cátedra en una materia, NASA fuera; la cita de Leisner omitía «and order 2» sin elisión |
| 4.16 | Una fecha límite puede ir arriba | M17 (Apollo, «antes de 1970») | fiel | — |
| 4.17 | Los criterios de éxito viven en los objetivos; un «debería» no es requerimiento | SEH C.1; TESS p. 5 | fiel | — |
| 4.18 | «Ojo: el cohete de M17 es el viejo» | M17 | desactualizada | M17 se corrigió (`bb1f565`); la sacó otra sesión (perfil `2fa6920`) |
| 4.19 | TBD / TBR | SEH C.3; M21 | incompleta | el TBR lleva quién lo cierra y para cuándo (C.3) |
| 4.20 | Atributos mínimos; método al escribir; KDR | SEH p. 57-59, Tabla 4.2-2 | fiel | — |
| 4.21 | Validar el conjunto; quién valida | SEH p. 60; M21 | fiel | se nombran las dos fuentes (M21: «no el mismo equipo») |
| 4.22 | El chequeo mecánico de la redacción | `verificar-requisito.py` | casa | — |
| 5.1 | Primero funcional, después física; los cinco campos | SEH p. 64 | fiel | — |
| 5.2 | IDD / IRD / ICD | atribuido al SEH (sólo los enumera, p. 137) / *Expanded Guidance* §6.3.2 | **CAMBIABA** + atribución | definiciones corregidas, con su fuente |
| 5.3 | Cada interfaz con dueño; el N² | SEH 6.3 (`req-interfaz.md`) | fiel | — |
| 5.4 | Partir para que las piezas sean independientes | Rechtin & Maier p. 32 | fiel | página agregada |
| 5.5 | Trade study: criterios antes, pesos del interesado, empate = criterios mal | SEH p. 167-170; Rechtin p. 402 | atribución | el empate es de Rechtin (cita); el SEH pide, con alternativas parejas, llevarlas todas al que decide |
| 5.6 | Simplificar; mantener las opciones abiertas | Rechtin & Maier p. 32-33 | fiel | página agregada |
| 6.1-6.6 | Las seis heurísticas | Rechtin & Maier p. 32, 398-401 | fiel | (verbatim en `heuristicas.md`) |
| 7 | Las cuatro primeras preguntas antes de cada acción | Fran, 2026-10-02 | casa | — |
| 7.5 | La quinta: ¿el procedimiento produce lo que la necesidad pide? Mal planteado, se corrige y se avisa; se pregunta cuando cambia lo que el interesado ejecuta o lo que se busca | Fran, 2026-10-19 (`t19-arbol-de-conocimiento.md` §3-4; L1-30, L2-LDB-01..03) | casa | el interesado es Fran |

### `alcance-como-se-escribe.md`

| # | Regla de la ficha | Fuente | Grado | Qué se hizo |
|---|---|---|---|---|
| A1 | La necesidad es una sola frase | M17, M18, M20 (ejemplares); SEH p. 49 | cita | — |
| A2 | El contexto va antes, como antecedentes | JWST (Gardner et al., p. 1) | fiel | — |
| A3 | Metas y objetivos: una frase; prosa sin rótulo | JWST p. 1 (cita); TESS; UNOOSA p. 12 | cita | «si hace falta» → «puede seguir prosa que la explica» (DA-066) |
| A4 | El rationale vive en los requerimientos | SEH p. 49, *where needed* | cita | — |
| A5 | Necesidad: el problema, nunca el sistema | M18; SEH p. 49 | fiel | — |
| A6 | Meta: verbos de progreso | Leisner p. 4 | fiel | la fuente queda en `nasa-level1/` |
| A7 | Objetivo: verbos de completitud, sin el cómo | Leisner p. 4; SEH p. 49 (cita) | cita | la tensión con M18 («cómo se alcanza la meta») ya estaba resuelta a favor del SEH, y dicha |
| A8 | Criterio de éxito: completa y mínima; plazos de la ciencia | TESS p. 5; Leisner p. 12 (cita) | cita | — |
| A9 | Misión: el tipo de producto, no las decisiones del trade | M18; IIS-45, 46 (inferido) | fiel | — |
| A10 | Hipótesis: un supuesto por frase | M18; IIS-52 | fiel | — |
| A11 | Restricción: externa, con quién la impone | SEH p. 48 (cita agregada) y p. 55 (cita); M18; PET-44; IIS-54 | cita | — |
| A12 | Autoridad y responsabilidad | M18; TESS p. 6 | fiel | — |
| A13 | ConOps: fases en orden, con lo no nominal | M18 | fiel | — |
| A14 | Requerimientos L0 | remite al libro §4 | fiel | alineado con 4.15 (quién manda con los números) |
| A15 | El orden de los elementos | M18 | **CAMBIABA** | la tabla en el orden de la cátedra |
| A16 | Los precedentes prueban factibilidad, no justifican | Santi, 2026-10-19; JWST p. 17 (cita) | casa | — |

## 3. DA-066: las cláusulas de escape del libro

Barrido de `nucleo-ise.md`, `alcance-como-se-escribe.md` y `plantillas/naturalezas/ingenieria.md` por «salvo»,
«excepto», «a menos que», «si hay una razón», «si hace falta», «cuando corresponda», «en lo posible», «unless»,
«except», «en general»:

| Dónde | Cláusula | Qué es | Destino |
|---|---|---|---|
| libro §4 (antes del 2026-10-19) | «tampoco la solución, salvo que haya una razón escrita» | escape que lo usa quien escribe | sacada el 2026-10-19; ahora, la excepción **de los libros** con su quién (fila 4.12) |
| libro §4 | «la barra / salvo en unidades» | excepción que pone el libro (GtWR R17) | queda, nombrada: «la excepción la pone el libro» |
| libro §4 | «un requisito sin padre … se evalúa si hace falta» | acción, no escape (M17 lo dice igual) | reescrita con su fuente: «o falta su padre, o sobra él» (SEH C.4) |
| ficha, punto 3 | «si hace falta, sigue prosa corriente» | escape sin dueño | reescrita: «puede seguir prosa que la explica» |

No quedan cláusulas de escape sin quién, y **ahora lo mide** `verificar-libro.py`: una cláusula de escape en la
prosa del libro (fuera de comillas y de código, porque adentro están los ejemplos de lo que no va) sin una marca de
quién la impone en la misma línea es rojo. Su autotest pone de vuelta la cláusula del 2026-10-19 («salvo que haya
una razón escrita») y exige el rojo por ella; y exige verde para la excepción con su quién y para el ejemplo
citado. Es un patrón por palabra, y por eso mira sólo dos archivos y frena sólo en el arranque, no al escribir
(«CUANDO PONES UN FRENO»: un patrón de texto frena también la prosa que habla de lo protegido). Su primera corrida
real encontró la R31 del GtWR (*«unless…»*, partida en dos renglones): era un defecto del escáner, que sacaba las
comillas por renglón; ahora las saca sobre el texto entero.

## 4. DA-065: cada sección de los destilados, contra el concepto que la hace leer

**El instrumento:** `mapa-lecturas.py` (raíz). Cada concepto de `.claude/cascada.json` declara `temas` (una regex
sobre el **título** de la sección: el rol) y `temas_fuera` (lo que cae en el tema y no va, con motivo; o
`lo_lee`, que se verifica). Una sección del tema fuera de todo rango del concepto y no declarada es huérfana: rojo.
También rojo una regex ciega, una exclusión muerta y un `lo_lee` mentiroso. Las carpetas de destilados entran
solas (todas las de `pilares/` salvo `fuentes/`): una carpeta nueva no queda fuera del censo.

**Medido antes de enganchar** (el prototipo, sobre el catálogo del 2026-10-19 a la mañana): **cinco huérfanas de
verdad**, todas la misma clase que el App. C en el glosario:

| Sección | Qué tenía | Ahora la lee |
|---|---|---|
| `nasa-seh/glosario.md` §2.2 | need → goal → objective → requirement, y *«Requirements are always stated in quantitative terms»* (p. 192) | requisitos y alcance |
| `nasa-seh/stakeholders.md` §3.8 | qué es una restricción (*«A "constraint" is a condition that is to be met»*, p. 48) y de dónde viene | alcance |
| `nasa-seh/stakeholders.md` §3.18 | NGO, criterios de éxito y *design drivers*; una órbita alternativa = un concepto propio (p. 52) | alcance |
| `nasa-seh/requisitos.md` §4 | la restricción no cambia por trade (p. 55-56): la leía alcance, no requisitos | requisitos y alcance |
| `nasa-level1/README.md` (nueva) | el *Level 1* de NASA: resultado, agnóstico, verbos | requisitos |

**Después:** requisitos 43 secciones del tema (22 las lee, 21 afuera con motivo), alcance 17 (6 y 11), **0
huérfanas**. Autotest: 7 casos (el catálogo real en verde; sin el App. C sale huérfana **esa** sección; una
exclusión borrada, una muerta, un `lo_lee` mentiroso, una regex ciega, ningún concepto con temas). En la capa
rápida y en la de saboteadores de `chequeo-completo`.

**Lo que el mapa NO cubre, y es la clase que sigue** (no se construyó acá: cada uno pide medir sus títulos antes,
como DA-064): **temas sin concepto**. El TP de IISE escribe, además del alcance y los requerimientos, un ConOps,
un trade de conceptos, una matriz de riesgos, un plan de verificación y lo que pide el MCR; para ninguno hay
concepto, así que sus destilados (`stakeholders.md` §3.14-3.17 y `conops-fase-e.md`; `datos-decision.md` §6.8;
`riesgo-config.md`; `verificacion.md`, `validacion.md`, `matrices.md`; `ciclo-vida.md`, las revisiones;
`req-interfaz.md` §6.3 y `planes.md` ap. L) se leen sólo si la sesión va a buscarlos con la tabla §8 del libro.
Es DA-065 un nivel más arriba: la lectura existe y nada la hace llegar al escribir.

## 5. DA-067 y DA-070: la puerta

**DA-067 — el concepto `requisitos` dispara por el rol.** Además del nombre (`requisitos*.md`), por un título de
sección de requerimientos en cualquier documento (`1.9. Requerimientos`, `== Requisitos`), que el Write trae, que
el Edit trae o que encierra lo editado; el registro (ESTADO_ACTUAL, HANDOFF) no dispara. Y `alcance` suma la
misión, las restricciones y la autoridad (elementos del alcance de M18). Medido antes sobre lo trackeado: 20
títulos caen en «requerimientos/requisitos», unos 15 son requerimientos de verdad (módulos del apunte, los diseños
de T7, T14, T20, BLACK, el libro §4); los falsos son un README de prerrequisitos, dos entradas del glosario del
apunte y un destilado, y cuestan una lectura por sesión. «Hipótesis» **no** entró: 6 de sus 8 títulos son
hipótesis de depuración (BLACK, la MSI). Al declarar `materia` o `diseno`, la cascada imprime ahora también el
concepto `requisitos` (DA-058: lo que la puerta va a exigir se dice antes). Autotest caso 21: 3 sabotajes, 3
controles (la prosa que nombra los requerimientos, el HANDOFF, el concepto ya leído) y 2 mutantes vistos.
**Efecto real en esta sesión:** un Write a un `.md` del scratchpad con `## 1.9. Requerimientos` fue negado pidiendo
el §2.2 del glosario; leído, pasó.

**DA-070 — un comando que toca dos proyectos exige los dos.** `proyectos_de()` devuelve todos los que la acción
toca (el árbol, el segmento de ruta, las carpetas locales), con el de siempre primero; la puerta exige declarar el
primero que falte y, si están todos, lo de cada uno. El mecanismo `probable` del registro quedó **confirmado**
leyendo el código: `proyecto_de()` cortaba en el primer `PATRON_PROY.search`. Autotest caso 22: el comando con dos
proyectos y uno liberado niega por el **otro**; con sólo el liberado pasa; con el segundo declarado y sin leer,
niega por **su** base; 2 mutantes vistos (uno por comando; sin exigir lo del segundo). **Efecto real:** un Bash que
nombraba `arquitectura-se/` (declarado) y `telescopio/` fue negado por telescopio; el mismo con sólo
arquitectura-se, pasó.

## 6. Lo que queda, dicho

- **La tabla la graduó la misma sesión que corrigió el libro** (DA-008, DA-043: no hay revisión independiente).
  Lo mecánico (las citas) lo mide `verificar-libro.py`; las paráfrasis, no: una paráfrasis infiel nueva no da rojo.
- Las citas de la cátedra y de `catedras/` (repo privado) van sin cursiva y no las mide nada.
- El concepto `typst` dispara por la **palabra** en el comando (`\btypst\b`): un grep que sólo la nombraba pidió
  leer la skill de PDF en esta sesión. Es la clase de DA-067 en otro concepto; queda registrado como defecto.
- El concepto `requisitos` pesa ~90 000 caracteres: con el disparo por rol lo va a pagar más gente. No se recortó
  (no era esta tarea); es candidato a partir por nivel (el tope / el resto).
