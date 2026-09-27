# El programa BLACK — cómo se trabaja desde el 2026-09-26

Plan de gestión técnica del programa (un SEMP recortado, NASA §6.1). Dice
**cómo** se decide qué se hace. **Qué** se puede hacer está en
[`12-estudio-de-conceptos.md`](12-estudio-de-conceptos.md). El mapa del juego
está en `kb/subsistemas.json` y el catálogo en `kb/conceptos.json`; los dos los
mide `python herramientas/programa.py verificar`.

---

## 1. Por qué existe

**Lo que pasó, medido.** Entre el 2026-08-15 y el 2026-09-26 la bitácora sumó
61 entradas. El proyecto arrancó de una dirección (la vida del jugador) y subió
eslabón por eslabón: rutina de daño, tabla de armas, arma del enemigo,
descriptor, índice de módulos. **La función que construye todos los
subsistemas del juego (`FUN_001020c0`) se leyó por primera vez en la entrada
62.** Tiene 37 singletons. En 61 entradas se habían tocado **6**. Las dos
estructuras que deciden si el coop es viable (`jugadores[1]` y los dos mandos)
salieron de **una** sesión en frío.

**Ya había pasado una vez, y se arregló mal.** El 2026-08-23 (7e) se registró
la lección «antes de subir la cadena, buscar el índice». Era una regla de
búsqueda. El índice que apareció (el stream de módulos del nivel) seguía
siendo un detalle, y la falla se repitió un nivel más arriba. Un arreglo local
a una falla de estructura sube el volumen de la regla; no cambia la
estructura (pilar de Meadows).

**El handbook lo advierte, con estas palabras** (NASA SP-2016-6105 Rev2, p. 67):

> "there is always a danger that the top-down process cannot keep up with the
> bottom-up process. Therefore, system architecture issues need to be
> resolved early so that the system can be modeled with sufficient realism to
> do reliable trade studies."

Y el costo de no hacerlo está en la Figura 2.5-1 (p. 13): el costo de cambiar
la dirección del diseño crece 3–6×, 20–100× y 500–1000× a medida que avanza el
ciclo de vida.

## 2. BLACK es un programa, no un proyecto

Tiene al menos siete metas independientes (coop, desafío, novedad, contenido,
remaster, comodidad, estabilidad de los mods). Tratarlo como un proyecto con
fases numeradas por orden de descubrimiento (7a, 7b, 7c…) hizo que el plan
creciera como una cadena de subpreguntas: cada respuesta abría la pregunta de
abajo, y nada empujaba hacia los costados.

| Nivel | Qué es | Dónde vive |
|---|---|---|
| **Programa** | metas (NGOs), medidas de efectividad (MOEs), mapa de nivel 1, catálogo de conceptos, cartera de proyectos | este archivo, `kb/conceptos.json`, `kb/subsistemas.json` |
| **Proyecto** | un mod (coop, dificultad, randomizer…), con su propio ciclo de vida | una sección en `PDP.md` §4 por proyecto activo |
| **Desarrollo de tecnología** | subir la madurez (K) de un subsistema: es el reversing | lo **pide** un proyecto seleccionado; no arranca solo |

La tercera fila es la que cambia todo: **el reversing deja de ser un fin**. Se
hace porque un concepto elegido lo necesita, y sube la K de un nodo del mapa.
NASA p. 67 pide esa interacción:

> "It is imperative that there be a continual interaction between the
> technology development process, crosscutting processes such as human
> systems integration, and the design process to ensure that the design
> reflects the realities of the available technology and that overreliance on
> immature technology is avoided."

## 3. Refinamiento sucesivo: el mecanismo, que es más que una puerta

NASA Figura 4.4-2 (p. 67), *The Doctrine of Successive Refinement*: en cada
nivel de resolución se **identifican y cuantifican las metas, se crean
conceptos, se hacen trade studies y se elige**, y recién entonces se aumenta la
resolución. En BLACK hay cuatro niveles:

| Nivel | Qué se ve | Artefacto |
|---|---|---|
| **R0** | el juego entero, y lo que Fran quiere de él | NGOs, MOEs, ConOps |
| **R1** | los subsistemas: 37 del ejecutable, más disco y externos | `kb/subsistemas.json` |
| **R2** | las estructuras de un subsistema: clases, tablas, archivos | `kb/estructuras.json`, `kb/formatos-iso.json` |
| **R3** | campos y rutinas | `kb/mapa-memoria.json`, `kb/rutinas.json` |

Hasta hoy casi todo el trabajo vivió en R3 y el R1 no existía. Una puerta
sola («no bajar sin mapa») se habría salteado igual que se salteó la lección de
7e. Lo que hace que esta vez sea distinto son cinco piezas que se sostienen
entre sí:

1. **Un ciclo con productos, no un sí o no.** Cada nivel deja NGOs, conceptos,
   un trade study y una elección escrita (§4).
2. **El ancho se mide y se muestra al abrir cada sesión.** `abrir-sesion.ps1`
   imprime `programa.py resumen`: cuántos subsistemas hay en cada K y qué
   conceptos frena cada uno. Es el medidor a la vista en la entrada (Meadows),
   y no depende de acordarse.
3. **El desarrollo de tecnología lo tira un proyecto** (§2). Una sesión que
   baja a R3 sin concepto que lo pida lo declara en la bitácora como sonda de
   nivel 1, con su motivo.
4. **Hay revisiones con criterios de entrada y de éxito, y decide Fran** (§6).
5. **Traza en los dos sentidos:** concepto → NGO → función → subsistema, y lo
   verifica `programa.py verificar` (NASA p. 46, *bidirectional traceability*).

## 4. El ciclo de vida de cada proyecto

Adaptado de la Tabla 2.2-1 (p. 9) y de los recuadros de §3.3–3.8. Pre-Fase A
es del **programa**; de A a F es de **cada proyecto**.

| Fase | Propósito (NASA) | Qué produce en BLACK | Revisión y decisión |
|---|---|---|---|
| **Pre-A** | *"To produce a broad spectrum of ideas and alternatives for missions from which new programs/projects can be selected"* (p. 9) | NGOs y MOEs validadas, mapa R1, catálogo, trade study con los pesos de Fran, cartera | **MCR**, y en el KDP-A Fran elige la cartera |
| **A** | concepto y desarrollo de tecnología (p. 24) | ConOps del mod, requisitos con su método de verificación, habilitadores llevados a **K5**, un prototipo en RAM o por PINE que demuestre factibilidad | SRR/MDR recortada; KDP-B |
| **B** | diseño preliminar | diseño del mod (datos, pnach, PINE), sus interfaces con los otros mods, riesgos | PDR recortada |
| **C** | diseño final y fabricación | TOML, pnach y parche de ISO construidos y verificados de a uno | CDR (se funde con la PDR si el costo es S o M) |
| **D** | integración y prueba | la pila de mods junta; verificar contra los requisitos y **validar: Fran juega** (MOE) | ORR recortada |
| **E** | operación | se juega; los defectos van al registro | — |
| **F** | cierre | se retira o se archiva | — |

La fase A de NASA incluye, textual: *"Demonstrate that credible, feasible
design(s) exist"* (p. 24). En BLACK eso es un prototipo que anda en RAM o por
PINE **antes** de escribir una línea de MIPS.

**Tailoring** (NASA §3.11 y el rigor por aspecto de `PDP.md` §3): un concepto
de costo **S** con habilitadores en K ≥ 4 junta A, B y C en una sola fase con
una sola revisión. Un concepto **L** o **XL** las recorre todas.

## 5. La escala de madurez K, análoga al TRL

El handbook mide la madurez de una tecnología con los TRL (Apéndice G, p. 195):
*"TRLs range from 1, basic technology research, to 9, systems test, launch,
and operations."* Acá lo que madura no es hardware: es **cuánto sabemos de un
subsistema del juego**.

| K | Significa |
|---|---|
| 0 | no se sabe que existe, o no se sabe dónde vive |
| 1 | ubicado: se sabe qué global, archivo o proceso lo aloja |
| 2 | nombrado: hipótesis de propósito con evidencia |
| 3 | interfaz leída en frío |
| 4 | medido en volcados, con control positivo |
| 5 | efecto confirmado en RAM |
| 6 | efecto persistente (ISO o pnach), sobrevive al reinicio |
| 7 | validado: un mod jugado por Fran que cumple su MOE |

**Regla de transición A → B (decisión de este programa, no del libro):** los
habilitadores críticos del proyecto en **K5**. Se apoya en dos cosas que sí
dice el handbook. Una: *"Typically, a TRL of 6 (i.e., technology demonstrated
in a relevant environment) is required for a technology to be integrated into
an SE process"* (p. 195); K5 es efecto confirmado en el entorno real, que es
lo más parecido. La otra: el *Technology Development Plan* es *"A document
required for transition from Phase A to Phase B identifying technologies to
be developed"* (p. 194). En BLACK ese plan es la lista de subsistemas del
proyecto con su K actual, la K objetivo y la sonda que la sube.

## 6. Revisiones: quién decide y con qué

La autoridad de decisión es **Fran**. Cada revisión es un resumen de una
página más preguntas; su respuesta queda en `PDP.md` §6.

**MCR** (Tabla 6.7-1, p. 161): *"The MCR will affirm the mission need and
evaluates the proposed objectives and the concept for meeting those
objectives."*

- **Entrada:** mapa R1 completo (cada nodo con K, y los K0–K1 con su sonda);
  catálogo con al menos una alternativa en cada categoría; NGOs y MOEs en
  borrador; `programa.py verificar` en verde; las preguntas escritas.
- **Éxito:** NGOs validadas por Fran con sus palabras; pesos C1–C6 puestos
  por él (`kb/conceptos.json#pesos`, con fuente y fecha); trade study corrido
  con análisis de sensibilidad; cartera de **a lo sumo dos proyectos
  activos**, cada uno con su plan de desarrollo de tecnología; la decisión
  del KDP-A escrita en `PDP.md` §6.

**SRR/MDR recortada (fin de A):** requisitos del mod con método de
verificación; habilitadores en K5; prototipo que anduvo. **PDR/CDR
recortada:** el diseño nombra cada dirección y archivo que toca, y no se pisa
con otro mod. **ORR recortada:** la pila de mods arranca de cero y Fran jugó
una misión con el MOE medido.

## 7. Interfaces entre mods, y configuración

Con varios mods vivos, el riesgo nuevo son **dos mods que escriben la misma
dirección** (NASA §6.3, gestión de interfaces). Cada mod declara qué
direcciones y archivos escribe (concepto P4), y el compilador de pnach se
niega a juntar dos que se pisen. La **línea base** es el conjunto exacto que se
juega: ISO, pnach, texturas, ReShade, con su versión.

## 8. Costo: cómo se optimiza

Fran lo pidió el 2026-09-26: menos costo, aunque tarde más.

- **Modelo por tipo de trabajo, y esfuerzo declarado.** Opus para leer código
  y diseñar; Sonnet para ejecutar un plan ya decidido; Haiku para lo mecánico.
- **Sin fan-out.** Un hilo, en frío primero.
- **El emulador se abre en lote.** Su costo fijo es abrirlo y llegar al lugar:
  se juntan varias predicciones escritas y se prueban en la misma sesión.
- **A lo sumo dos proyectos activos.** Más trabajo en curso no termina nada
  antes, y cada uno reparte el contexto.
- **Chats cortos**, con mensaje de retome.

## 9. Trazabilidad en la bitácora

Desde la entrada (62), cada entrada declara **a qué concepto o proyecto
sirve y qué nodo del mapa toca** (ids de `kb/conceptos.json` y
`kb/subsistemas.json`). Una entrada sin concepto es desarrollo de tecnología
sin quién lo pida, y lo dice con su motivo.
