# Requisitos del método — borrador

**Versión 0.1, 12 de octubre de 2026** (sesión de arquitectura `de44da9d`). Estado: **borrador**: no está en línea
base. Lo pone en línea base una revisión de requisitos con Fran como interesado, con los TBR resueltos.

Por qué existe: el método (System 3, el que mejora a los proyectos) exigía requisitos a los proyectos y no tenía los
suyos. Los 38 defectos de arquitectura del 2026-10-12 se juzgaban contra nada escrito, y T13 («la fase manda»)
frena a todo proyecto en fase A–D sin este papel, incluido éste (fase 7, tipo D). Escrito con los libros abiertos:
`perfil-global/pilares/nucleo-ise.md` §4, el GtWR (`incose-gtwr/reglas.md`), la cátedra (m17, m21) y NASA
(`nasa-seh/requisitos.md` §5-14). Chequeo mecánico: `verificar-requisito.py <archivo> --idioma es`.

**Términos definidos** (R4 del GtWR):

- **Fase_De_Desarrollo**: una fase de PDP cuyo tipo NASA es A, B, C o D (lo tipa `.claude/hooks/fase_activa.py`).
- **Documento_De_Requisitos**: el archivo que el proyecto declara en `"requisitos"` de `.claude/cascada.json` y que
  existe en el disco.
- **Registro_Del_Proyecto**: el `ESTADO_ACTUAL.md`, el `HANDOFF.md` y el `PDP.md` del proyecto.
- **Proyecto_Con_Ciclo_NASA**: un proyecto que vive bajo `proyectos/ingenieria/` (lo lee `NATURALEZAS_NASA` de
  `.claude/hooks/cascada_puerta.py`). Los de `documentos/` y `seguimiento/` quedan afuera por N-09.
- **Proyecto expuesto**: un Proyecto_Con_Ciclo_NASA en Fase_De_Desarrollo sin Documento_De_Requisitos.

## 1. Necesidades (en el idioma de Fran; todavía no verificables)

| ID | Necesidad | Fuente |
|---|---|---|
| N-01 | Que las sesiones de proyecto lleguen a resultados verificables, con menos sesiones por pieza y menos retrabajo. | Fran, 2026-10-12: pesos efectividad > costo > plazo |
| N-02 | Que el método cueste poco contexto y poco plan por sesión. | ídem; T12 |
| N-03 | Que nada demore el arranque ni frene sin motivo. | ídem; T1, T11 |
| N-04 | Que el ciclo de vida NASA se ejecute por la FASE del proyecto, sin depender de una palabra o de leer un aviso. | Fran, 2026-10-12 (insumo NASA por etiqueta) |
| N-05 | Que todo error de la arquitectura del método quede registrado y no se dé por cerrado sin prueba. | Fran, 2026-10-12 (registro de defectos) |
| N-06 | **Cero divergencias, como ley transversal**: que ningún dato del método ni de un proyecto viva en dos lugares que puedan contradecirse; «debe ser lo más cuidado». | Fran, 2026-10-12 17:00 |
| N-08 | **NASA y ágil en la proporción que pide cada proyecto**: «saber usar NASA y ágiles en proporciones adecuadas a la complejidad del proyecto o necesidades». | Fran, 2026-10-12 17:05 |
| N-09 | **El rigor completo, para los proyectos grandes**: la arquitectura se pule para los proyectos de ingeniería donde su falta afecta la necesidad (BLACK, el telescopio); los de materia —apuntes, actividades, parcialitos— siguen con el método que ya tienen y no se frenan por la arquitectura. | Fran, 2026-10-12 noche: «no me interesa si el apunte de física no está bien hecho con la arquitectura, porque es funcional y alcanza» |
| N-10 | **Que nada salga a quien Fran no eligió**: compartir o publicar por un conector sólo lo declarado. | Fran, 2026-10-12 16:45 (lluvia §7: «frenar compartir/publicar salvo lo declarado»); `CLAUDE.md` raíz: el repo es público y lo personal vive aparte |
| N-07 | **Que el costo escale con la necesidad**: una pregunta que no es de un proyecto se contesta en un párrafo sin leer «1000 párrafos»; la cascada escala conocimiento, memorias, hooks y complejidad según el proyecto, la necesidad y su naturaleza. | Fran, 2026-10-12 17:00 |

## 2. Nivel 0 — el método

| ID | Padre | Requisito | Verificación |
|---|---|---|---|
| L0-01 | N-01 | El método deberá llevar la fase abierta de cada proyecto activo hacia el criterio de salida de la fase, con evidencia registrada en cada sesión. | análisis: auditorías (`.claude/auditorias/`) |
| L0-02 | N-02 | El método deberá mantener el contexto que impone por sesión por debajo del costo medido como línea base. | ensayo: `medir-costo.py --ultimas 3` |
| L0-03 | N-04, N-09 | El método deberá exigir los productos NASA de la Fase_De_Desarrollo de cada Proyecto_Con_Ciclo_NASA. | ensayo: autotest de la puerta y `medir-fases.py` |
| L0-04 | N-05 | El método deberá registrar cada defecto de arquitectura con la evidencia del defecto. | inspección: `defectos.py verificar` |
| L0-05 | N-06 | El método deberá asignar a cada dato un único archivo dueño. | ensayo: medidor de divergencias (a diseñar, T20) |
| L0-06 | N-07 | El método deberá imponer a cada sesión un costo de contexto proporcional a la necesidad declarada. | ensayo: `medir-costo.py` por tipo de sesión (a extender, T19) |
| L0-08 | N-10 | El método deberá limitar la audiencia de cada objeto que la sesión comparte o publica a la audiencia declarada del objeto. | ensayo: autotest de la puerta (caso 19) y demostración en una sesión real |
| L0-07 | N-08 | El método deberá graduar el rigor NASA y el ritmo ágil de cada proyecto según la complejidad y la incertidumbre del proyecto. | inspección: la matriz de cumplimiento y el selector de rigor del PDP (P2, P3; DA-004, DA-005) |

## 3. Nivel 1 — el método como sistema

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L1-01 | L0-02 | El arranque del método deberá inyectar entre 0 y 90 000 caracteres por sesión. | TBR: la mediana de las tres últimas sesiones es 87 712 (2026-10-12); con T12 validada era 78 070. El objetivo de T12 vuelve a ser la meta una vez medida la deriva. | ensayo: `medir-costo.py --ultimas 3`, columna `ses.met` |
| L1-02 | L0-02 | Los recordatorios del método deberán inyectar entre 0 y 3 000 caracteres por turno. | TBR: recordatorio 1 154–1 683 + cuadro 1 144–1 187 por turno (2026-10-12). | ensayo: `medir-costo.py`, columnas `recor/t` y `cuadr/t` |
| L1-03 | L0-01 | La puerta deberá negar entre el 0 % y el 5 % de las decisiones de una sesión. | TBR: 46 negadas en 2 115 decisiones (2,2 %) en 21 sesiones auditadas; más negadas por sesión empujan a sacar el freno (Saltzer, aceptabilidad psicológica). | análisis: P6 de las auditorías |
| L1-04 | L0-03 | La puerta deberá exigir el Documento_De_Requisitos a cada Proyecto_Con_Ciclo_NASA en Fase_De_Desarrollo. | Es T13: hasta el 2026-10-12 la exigencia era opt-in y 6 de 22 proyectos en A–D no tenían requisitos. Acotado por N-09 (T19a, 2026-10-12 noche): frenaba la entrada a tres proyectos de materia (apunte-iise, software-de-vuelo, cohete-de-agua), donde el papel que manda es el criterio de la cátedra. | ensayo: autotest de la puerta |
| L1-05 | L0-04 | El registro de defectos deberá cerrar cada defecto con commit, prueba, saboteador y tres sesiones auditadas posteriores. | Fran: «que no se validen fácilmente». | ensayo: `defectos.py --autotest` |
| L1-06 | L0-05 | Cuando un dato aparece en más de un archivo, el verificador de divergencias deberá dar ROJO si la copia difiere del archivo dueño del dato. | Fran, ley de cero divergencias. Antecedentes: DA-012, DA-017, DA-036 y T2 (un dueño por dato, diseñado en el diagnóstico del 2026-09-28 y nunca construido). Una copia sólo es aceptable como vista GENERADA del dueño o como puntero. | ensayo: copia sintética divergente en rojo; saboteador |
| L1-07 | L0-06 | Cuando la sesión responde una pregunta sin proyecto, el método deberá inyectar entre 0 y 30 000 caracteres. | TBR: hoy entran unos 88 000 fijos en TODA sesión (perfil, enrutador, memoria, pilares, núcleo del chequeo, apertura), sea cual sea la pregunta (mapa, subsistema de inyección). El valor lo fija el diseño T19 contra lo que la regla 16 exige que llegue siempre. | ensayo: `medir-costo.py` sobre una sesión sin proyecto |
| L1-09 | L0-07 | Cuando un proyecto escribe el Documento_De_Requisitos, el PDP del proyecto deberá declarar el rigor elegido para los requisitos con la complejidad y la incertidumbre que lo justifican. | Fran: NASA y ágil en proporción. T13 exige que el documento EXISTA; su tamaño escala con el proyecto (cinco requisitos con su verificación valen para un proyecto chico). Lo que no se sabe se descubre con spikes (nucleo-ise §2b). | inspección: `medir-matriz.py` sobre el PDP |
| L1-10 | L0-07 | Cuando la sesión abre una fase de un proyecto, la sesión deberá estimar la complejidad del proyecto con preguntas a Fran Y con referencias a proyectos anteriores o vigentes de la casa. | Fran, 2026-10-12 17:08: «tomar la complejidad preguntándome y de referencias de proyectos anteriores o vigentes». Es estimación por analogía (NASA 6.8: búsqueda de sistemas relacionados) más el juicio del interesado; la complejidad elegida alimenta L1-09. | inspección: el PDP §3 nombra las preguntas hechas y los proyectos de referencia |
| L1-08 | L0-06 | Cuando la sesión declara una necesidad de un proyecto, la puerta deberá exigir la lectura que corresponde a esa necesidad y a la naturaleza del proyecto. | La escalera de Fran: conocimiento, memorias, hooks y complejidad crecen con el proyecto y la necesidad, no con la palabra suelta (T14) ni con un piso fijo. | ensayo: autotest de la puerta |

## 4. Nivel 2 — los elementos de T13 («la fase manda»)

Elementos: **VER** el verificador del catálogo (`cascada_puerta.py --verificar`), **AUD** la auditoría
(`auditar-sesion.py`), **CMP** la compuerta de fase (`fase_activa.py`), **PTA** la puerta (`cascada_puerta.py`, hook).
Las decisiones de Fran del 2026-10-12 que los fijan: el freno actúa **al entrar** a cada proyecto (no frena lo que nadie
abre); el verificador lista y no frena.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L2-VER-01 | L1-04 | Cuando el PDP de cada Proyecto_Con_Ciclo_NASA declara abierta una Fase_De_Desarrollo Y el proyecto carece del Documento_De_Requisitos, el verificador del catálogo deberá listar el proyecto como expuesto. | Lista y no frena: la decisión de Fran es frenar al entrar. Un rojo permanente del arranque por seis proyectos dejaría de discriminar. | ensayo: catálogo sintético con un proyecto en Fase C sin requisitos |
| L2-VER-02 | L1-04 | Cuando el PDP de cada proyecto declara la fase abierta sin tipo NASA, el verificador del catálogo deberá listar el proyecto como fase sin tipo. | 8 proyectos al 2026-10-12. | ensayo: PDP sintético sin tipo |
| L2-AUD-01 | L1-04 | Cuando la sesión toca cada Proyecto_Con_Ciclo_NASA en Fase_De_Desarrollo Y el proyecto carece del Documento_De_Requisitos, la auditoría de la sesión deberá dar ROJO en la pregunta P7. | Antes daba NO APLICA por exclusión (DA-028). | ensayo: caso del autotest de `auditar-sesion.py` |
| L2-CMP-01 | L1-04 | Cuando la sesión entra a cada proyecto en Fase_De_Desarrollo, la compuerta de fase deberá listar la ruta del Documento_De_Requisitos del proyecto. | DA-029: la compuerta informaba la fase sin mirar sus productos. | demostración |
| L2-CMP-02 | L1-04 | Cuando la sesión entra a cada proyecto en Fase_De_Desarrollo, la compuerta de fase deberá indicar si el Documento_De_Requisitos del proyecto existe. | ídem. | ensayo: autotest de `fase_activa.py` |
| L2-CMP-03 | L1-04 | Cuando la sesión entra a cada proyecto en Fase_De_Desarrollo, la compuerta de fase deberá indicar si las secciones de alcance, riesgos Y plan de verificación del PDP del proyecto tienen contenido propio. | La plantilla del PDP ya trae §2 «Qué NO es» (alcance), §5 Riesgos y §7 Verificación: no hacen falta artefactos nuevos (DA-031), hace falta mirar que no sean la plantilla. Informa: no frena, porque «tiene contenido propio» es una heurística y un freno con falsos positivos es menos seguro. | ensayo: autotest de `fase_activa.py` |
| L2-PTA-01 | L1-04 | Cuando la acción toca cada Proyecto_Con_Ciclo_NASA en Fase_De_Desarrollo Y el proyecto carece del Documento_De_Requisitos, la puerta deberá negar la acción. | DA-027: la exigencia era opt-in. | ensayo: autotest de la puerta, con saboteador |
| L2-PTA-02 | L1-04 | Cuando la acción escribe el Documento_De_Requisitos del proyecto expuesto, la puerta deberá permitir la acción. | La única salida tiene que quedar abierta (un freno que falla cerrado deja abierta su reparación). Sin documento declarado, vale un archivo del proyecto que dispare el concepto `requisitos` (nombre `requisitos*.md` o `.txt`), que exige los libros. | ensayo: control positivo del autotest |
| L2-PTA-03 | L1-04 | Cuando la acción escribe el Registro_Del_Proyecto del proyecto expuesto, la puerta deberá permitir la acción. | Frenar el checkpoint empujaría a saltearlo. | ensayo: control positivo del autotest |
| L2-PTA-04 | L1-03 | Cuando la puerta infiere los proyectos del pedido, la puerta deberá excluir el texto encerrado en las etiquetas pasted_content, task-notification Y system-reminder. | T14 (`docs/t14-lo-que-pide-fran.md`): el 2026-10-12 la puerta negó dos acciones por proyectos nombrados en un retome pegado y en una notificación automática. Lo pegado actúa sobre rutas, que la puerta ve por la ruta. | ensayo: caso 17 del autotest de la puerta, con mutante |

## 5. Nivel 2 — el elemento de T20 («cero divergencias»)

Elementos: **DIV** el verificador de divergencias y su Registro_De_Datos. Diseño: `docs/t20-cero-divergencias.md`
(§2 la distinción de las tres clases, §4 el medidor). Términos definidos (R4):

- **Dato_Vigente**: un dato que dice cómo está el mundo ahora (la fase en curso, el orden de lo que sigue).
- **Archivo_Dueño**: el único archivo donde se escribe un Dato_Vigente.
- **Registro_De_Datos**: el archivo que declara cada Dato_Vigente con su Archivo_Dueño, su extractor y sus copias.
- **Copia_Vista**: una aparición declarada de un Dato_Vigente fuera del Archivo_Dueño que repite el valor.
- **Copia_Puntero**: una aparición declarada que nombra el Archivo_Dueño en lugar del valor.
- **Medición_Fechada**: una línea que lleva la fecha o la sesión en que se midió el valor; es historia y no diverge.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L2-DIV-01 | L1-06 | Cuando cada Copia_Vista difiere del valor del Archivo_Dueño, el verificador de divergencias deberá dar ROJO con el dato, el Archivo_Dueño y la copia. | La forma de la ley de Fran (N-06). El ROJO trae los tres nombres porque un rojo sin explicación cuesta un viaje entero (chequeo-de-trabajo, «CUANDO PONES UN FRENO»). | ensayo: caso (a) del saboteador, con mutante sin la comparación (caso e) |
| L2-DIV-02 | L1-06 | Cuando cada Copia_Puntero contiene el valor del Archivo_Dueño, el verificador de divergencias deberá dar ROJO. | Un puntero que copia el valor es una Copia_Vista sin declarar: la próxima vez que el dueño cambie, diverge. | ensayo: caso (b) del saboteador |
| L2-DIV-03 | L1-06 | Cuando el extractor del Archivo_Dueño devuelve un resultado vacío, el verificador de divergencias deberá dar ROJO. | Falla cerrado (Saltzer): un dato que se mudó o un extractor viejo darían verde comparando vacío contra vacío. El Registro_De_Datos que no parsea es el mismo caso. | ensayo: caso (c) del saboteador |
| L2-DIV-04 | L1-06 | Cuando cada línea fuera del Archivo_Dueño coincide con el patrón de cada Dato_Vigente sin fecha ni sesión, el verificador de divergencias deberá listar la línea como copia ausente del Registro_De_Datos. | Las copias no declaradas no se pueden enumerar (universo abierto). El patrón es una heurística: lista y no frena, como L2-CMP-03, porque un freno con falsos positivos se apaga. La Medición_Fechada queda afuera por construcción. | ensayo: control positivo (d) del saboteador, un retome real lleno de Medición_Fechada |
| L2-DIV-05 | L0-05 | El Registro_De_Datos deberá asignar a cada Dato_Vigente un único Archivo_Dueño. | Dos dueños es la divergencia misma, escrita en el registro. El registro es un mecanismo compartido: se chequea antes de que el verificador lo use (t20 §6). | inspección: el verificador da ROJO ante dos dueños |

## 6. Nivel 2 — los elementos de T14b («mencionar no es pedir»)

Elementos: **PTA** la puerta (`cascada_puerta.py`, hook) y **AUD** la auditoría (`auditar-sesion.py`). Diseño:
`docs/t14b-mencionar-no-es-pedir.md`. Términos definidos (R4):

- **Proyecto_Inferido**: un proyecto que la puerta reconoce por una señal del catálogo en lo que tipea Fran.
- **Mención**: el registro, hecho por la sesión con su motivo, de que el pedido nombra un Proyecto_Inferido como
  contexto y pide trabajo de otro proyecto o del método.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L2-PTA-05 | L1-03 | Cuando la sesión registra la Mención de cada Proyecto_Inferido, la puerta deberá permitir cada acción fuera de la ruta del Proyecto_Inferido. | Fran, 2026-10-12 noche: lo nombrado como contexto se registra y se trabaja sólo en lo pedido (lluvia §7). Medido el 2026-10-16: de 10 excepciones desde el 2026-10-12 20:00, 8 eran un proyecto nombrado sin pedirlo (5 como contexto u otra sesión, 3 por una palabra suelta); la salida era la Excepción, que pinta P2 y P5 de AMARILLO. | ensayo: caso 18 del autotest de la puerta, con mutante |
| L2-PTA-06 | L1-08 | Cuando la acción toca la ruta de cada Proyecto_Inferido con Mención Y sin necesidad declarada, la puerta deberá negar la acción. | La Mención tapa el caso de la lección 331 sólo para lo que cae afuera del proyecto; trabajar en el proyecto mencionado sigue exigiendo su cascada. Es lo que la separa de la Excepción. | ensayo: sabotaje del caso 18 del autotest |
| L2-AUD-02 | L1-03 | Cuando la sesión registra cada Mención, la auditoría de la sesión deberá excluir la Mención del conteo de excepciones de la pregunta P5. | Un canal de excepciones con 8 de 10 menciones dejó de discriminar las salidas de verdad (chequeo-de-trabajo: un aviso que salta siempre). La Mención se informa en P5 como dato, sin color. | ensayo: caso del autotest de `auditar-sesion.py` |

## 7. Nivel 2 — los elementos de T16 («el estado se prueba»)

Elementos: **MVR** el medidor de verificación (`matriz-verificacion.py`) y **CAS** la cascada (`cascada.ps1`). Diseño:
`docs/t16-estado-verificable.md`. El padre es un L1 nuevo (abajo), hijo de L0-01: hasta acá el método exigía que el
requisito EXISTIERA (T13) y que el commit lo CITARA (P7), y nada decía si se cumplía (DA-039, DA-053). Términos
definidos (R4):

- **Requisito_Del_Proyecto**: cada fila con ID de nivel L0 a L5 del Documento_De_Requisitos (las necesidades N no se
  verifican: se validan).
- **Prueba_De_Requisitos**: cada comando que el proyecto declara en `"pruebas"` de `.claude/cascada.json`; corre desde
  la carpeta del proyecto.
- **Línea_De_Resultado**: una línea `REQ <ID> PASA|FALLA <detalle>` que imprime una Prueba_De_Requisitos.
- **Registro_De_Evidencias**: el archivo `verificaciones.jsonl` al lado del Documento_De_Requisitos; cada entrada lleva
  ID, resultado, fecha y evidencia (la columna *Results* de NASA, apéndice D: un puntero a la evidencia objetiva).
- **Resultado_Verificado**: el resultado obtenido por el método de verificación del propio requisito.
- **Resultado_Predicho**: el resultado que la Prueba_De_Requisitos calcula para un requisito cuyo método de
  verificación difiere de análisis (una cuenta del diseño no es un ensayo).
- **Matriz_De_Verificación**: el archivo `matriz-verificacion.md` al lado del Documento_De_Requisitos, generado por el
  medidor de verificación con un renglón por Requisito_Del_Proyecto.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L1-11 | L0-01 | Cuando la sesión declara la necesidad de cada Proyecto_Con_Ciclo_NASA con Documento_De_Requisitos, el método deberá informar el resultado de verificación de cada Requisito_Del_Proyecto. | Fran, encuesta 2026-10-12 noche: requisitos con pasa/falla y una prueba que la sesión corre al entrar, pensado para el telescopio. Medido al diseñar: el telescopio tiene 76 requisitos (15 L0, 30 L1, 31 L2) con columna Verificación y ningún lugar que diga cuáles se cumplen; su modelo pasó de v9 a v10.5 en cuatro días sin que nada re-verificara los requisitos de análisis. | demostración: la cascada sobre el telescopio |
| L2-MVR-01 | L1-11 | Cuando el método de verificación de cada Requisito_Del_Proyecto es análisis, el medidor de verificación deberá registrar la Línea_De_Resultado del requisito como Resultado_Verificado. | Para un requisito de análisis, la cuenta ES la verificación (NASA, Tabla 4.2-2: el método se decide al escribirlo). | ensayo: caso del autotest de `matriz-verificacion.py` |
| L2-MVR-02 | L1-11 | Cuando el método de verificación de cada Requisito_Del_Proyecto difiere de análisis, el medidor de verificación deberá registrar la Línea_De_Resultado del requisito como Resultado_Predicho. | La falla que evita: dar por verificado un ensayo con una cuenta del modelo (confirmado = intervine y vi el efecto). El grado del perfil: verificado = `confirmado`, predicho = `probable`. | ensayo: caso del autotest, con mutante que trata todo como análisis |
| L2-MVR-03 | L1-11 | Cuando el Registro_De_Evidencias trae una entrada de cada Requisito_Del_Proyecto, el medidor de verificación deberá registrar la entrada más reciente del requisito como Resultado_Verificado. | Lo que ejecuta Fran (la prueba de foco, el vuelco, la deriva) entra por acá, con su evidencia. Gana sobre la Línea_De_Resultado: una medición del objeto pesa más que una cuenta. | ensayo: caso del autotest |
| L2-MVR-04 | L1-11 | Cuando una Línea_De_Resultado nombra un ID ausente del Documento_De_Requisitos, el medidor de verificación deberá dar ROJO. | La traza en los dos sentidos (NASA, Tabla 4.2-2, *Traced from*): un resultado de un requisito que no existe es un huérfano, o un ID que se renombró. | ensayo: caso del autotest, con mutante sin el chequeo |
| L2-MVR-05 | L1-11 | Cuando una entrada del Registro_De_Evidencias nombra un ID ausente del Documento_De_Requisitos, el medidor de verificación deberá dar ROJO. | Ídem, para la evidencia a mano. | ensayo: caso del autotest |
| L2-MVR-06 | L1-11 | Cuando una entrada del Registro_De_Evidencias carece de evidencia, el medidor de verificación deberá dar ROJO. | Un resultado sin puntero a la evidencia es un registro de lo que alguien dijo, no de lo que quedó (NASA, apéndice D, *Results*). | ensayo: caso del autotest |
| L2-MVR-07 | L1-11 | Cuando cada Prueba_De_Requisitos termina con un código distinto de 0, el medidor de verificación deberá dar ROJO. | Falla cerrado (Saltzer): una prueba que revienta deja a sus requisitos sin resultado, y eso se ve igual que «todavía no se probó». Una FALLA de diseño sale con código 0: es información, no un freno (en Pre-Fase A un diseño incumple requisitos legítimamente). | ensayo: caso del autotest, con mutante que ignora el código |
| L2-MVR-08 | L1-11 | Cuando cada Prueba_De_Requisitos termina sin una Línea_De_Resultado, el medidor de verificación deberá dar ROJO. | Una prueba muda da verde comparando nada contra nada. | ensayo: caso del autotest |
| L2-MVR-09 | L1-11 | El medidor de verificación deberá contar los Requisito_Del_Proyecto con Resultado_Verificado, con Resultado_Predicho Y sin resultado en cada nivel del Documento_De_Requisitos. | La V de NASA: cada nivel se verifica contra sus propios requisitos al subir, y el verde de L2 no certifica L1. El conteo por nivel es el criterio de salida contable que DA-039 pedía. | ensayo: caso del autotest |
| L2-MVR-10 | L1-11 | Cuando el resultado de cada Requisito_Del_Proyecto difiere del resultado escrito en la Matriz_De_Verificación, el medidor de verificación deberá listar el requisito con los dos resultados. | Lo que cambió desde la última vez que se escribió la matriz: un cambio de diseño que rompe un requisito se ve al entrar, no en la revisión. La matriz es una vista generada (T20): nunca se edita a mano. | ensayo: caso del autotest |
| L2-CAS-01 | L1-11 | Cuando la sesión declara la necesidad de cada Proyecto_Con_Ciclo_NASA con Documento_De_Requisitos, la cascada deberá imprimir el conteo por nivel del medidor de verificación. | El flujo de información que faltaba (DA-053): el arranque medía el método, nunca el producto. | demostración: la cascada sobre el telescopio |
| L2-CAS-02 | L1-11 | Cuando la sesión declara la necesidad de cada Proyecto_Con_Ciclo_NASA con Documento_De_Requisitos, la cascada deberá imprimir cada Requisito_Del_Proyecto con resultado FALLA. | Lo que falla es lo que decide la sesión; el resto entra en el conteo. | demostración: la cascada sobre el telescopio |

## 8. Nivel 2 — los elementos de T17 («los conectores bajo la puerta»)

Elementos: **PTA** la puerta (`cascada_puerta.py`, hook) y **VER** su verificador (`cascada_puerta.py --verificar`).
Diseño: `docs/t17-conectores-bajo-la-puerta.md`. El padre es un L1 nuevo, hijo de un L0 nuevo (L0-08, de N-10): hasta
acá la estructura de control cubría una lista cerrada de actuadores (Bash, PowerShell, Write, Edit) y todo conector
entraba sin pasar por ningún freno (DA-046). Términos definidos (R4):

- **Conector**: un servidor MCP de claude.ai; el harness nombra cada herramienta del Conector
  `mcp__<id>__<herramienta>`, con un id de cinco grupos hexadecimales de 8, 4, 4, 4 y 12 cifras (medido el 2026-10-16:
  Google Drive, Claude Docs y visualize).
- **Catálogo_De_Conectores**: el archivo `.claude/conectores.json`, que declara cada Conector por su id y la clase de
  cada herramienta: lectura, privado, comparte, ubica o papelera.
- **Declaración_De_Audiencia**: el archivo `.claude/estructura-drive.json`: cada par objeto-destinatario de
  `compartido-con-nombre` con el id del objeto, el hash del destinatario y su rol, y cada carpeta de
  `destinos-del-conector` con su id.
- **Llamada_Que_Comparte**: la llamada a una herramienta de clase comparte; agrega un destinatario a un objeto.
- **Llamada_Que_Ubica**: la llamada a una herramienta de clase ubica con carpeta destino; el objeto hereda la audiencia
  de la carpeta.
- **Carpeta_Pública**: la carpeta que la Declaración_De_Audiencia declara en `carpeta-publica`.
- **Registro_De_Hooks**: el archivo `.claude/settings.json`, que engancha cada hook a sus herramientas por matcher.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L1-12 | L0-08 | Cuando la sesión llama a cada herramienta de un Conector, la puerta deberá decidir la llamada en el evento PreToolUse. | DA-046 (Leveson: camino de control no modelado): el conector de Drive tiene `share_file`, `create_file`, `copy_file` y `update_file`, y ningún hook se enteraba. Uso real medido: el 2026-10-13 una sesión creó y compartió por el conector la carpeta del TP4 de Software de Vuelo, a pedido de Fran. La decisión va antes de la ejecución porque compartir es irreversible en la práctica: el destinatario ya vio el objeto, y mudarlo no lo despublica (`CLAUDE.md` raíz, Drive). | demostración: una sesión real, con la caja negra (`cascada_puerta.py --estado`) |
| L2-PTA-07 | L1-12 | Cuando la herramienta llamada pertenece a un Conector ausente del Catálogo_De_Conectores, la puerta deberá negar la llamada. | Por permiso, no por exclusión (Saltzer): un conector nuevo (Gmail, Notion) entra frenado hasta clasificar sus herramientas. El falso positivo es visible y se arregla en un archivo; el agujero de la lista negra no se ve. | ensayo: caso 19 del autotest de la puerta, con mutante |
| L2-PTA-08 | L1-12 | Cuando la herramienta llamada carece de clase en la entrada del Conector de la herramienta, la puerta deberá negar la llamada. | Ídem para una herramienta nueva de un conector conocido. | ensayo: caso 19 del autotest |
| L2-PTA-09 | L1-12 | Cuando la herramienta llamada tiene la clase lectura O la clase privado, la puerta deberá permitir la llamada. | Control positivo: leer no cambia quién ve nada, y lo privado (Claude Docs, visualize) no tiene herramienta que comparta (medido el 2026-10-16 en la guía de Claude Docs: compartir es un botón de Fran en claude.ai). Un freno con falsos positivos es menos seguro. | ensayo: caso 19 del autotest |
| L2-PTA-10 | L1-12 | Cuando la Llamada_Que_Comparte nombra un par objeto-destinatario ausente de la Declaración_De_Audiencia, la puerta deberá negar la llamada. | La lista blanca de Fran. El destinatario se compara por hash (sha256 del mail en minúsculas, 16 cifras: la regla de `verificar-drive.ps1`), porque el repo es público y los mails son de terceros. Una Declaración_De_Audiencia ilegible deja la lista vacía: niega. | ensayo: caso 19 del autotest, con mutante |
| L2-PTA-11 | L1-12 | Cuando la Llamada_Que_Comparte pide un rol mayor que el rol declarado del par objeto-destinatario, la puerta deberá negar la llamada. | `share_file` sube el rol de quien ya tiene acceso: declarado lector, pedido editor, es otra audiencia de escritura. Orden: lector < comentarista < editor. | ensayo: caso 19 del autotest |
| L2-PTA-12 | L1-12 | Cuando la Llamada_Que_Comparte nombra un par objeto-destinatario declarado con un rol igual o mayor que el pedido, la puerta deberá permitir la llamada. | Control positivo: lo declarado pasa (el TP4 del 2026-10-13 hubiera pasado con su entrada). | ensayo: caso 19 del autotest; demostración en la sesión real |
| L2-PTA-13 | L1-12 | Cuando la Llamada_Que_Ubica nombra la Carpeta_Pública, la puerta deberá negar la llamada. | El único camino a lo público es `publicar-apuntes.ps1`, con su lista (`apuntes-publicos.json`) y su comparación por MD5; un segundo camino por conector es el camino paralelo de DA-046. Un archivo creado ahí hereda «cualquiera con el link». | ensayo: caso 19 del autotest, con mutante |
| L2-PTA-14 | L1-12 | Cuando la Llamada_Que_Ubica nombra una carpeta ausente de la Declaración_De_Audiencia, la puerta deberá negar la llamada. | La puerta ve el id de la carpeta, no su audiencia, y no puede preguntarle a Drive sin demorar cada llamada (lo que tiene que llegar siempre no comparte proceso con lo que puede tardar). Las subcarpetas de la pública tienen otro id: sin la lista blanca, pasarían. | ensayo: caso 19 del autotest |
| L2-PTA-15 | L1-12 | Cuando la Llamada_Que_Ubica nombra una carpeta declarada en la Declaración_De_Audiencia distinta de la Carpeta_Pública, la puerta deberá permitir la llamada. | Control positivo: un destino privado declarado o una carpeta compartida con nombre declarada (su audiencia ya fue elegida). | ensayo: caso 19 del autotest; demostración en la sesión real |
| L2-PTA-16 | L1-12 | Cuando la lectura del Catálogo_De_Conectores falla, la puerta deberá negar la llamada. | Falla cerrado (Saltzer), como el catálogo de la cascada. | ensayo: caso 19 del autotest |
| L2-PTA-17 | L1-12 | Cuando la puerta decide cada llamada a un Conector, la puerta deberá registrar la herramienta, el veredicto Y el motivo en el estado de la sesión. | La caja negra que lee la auditoría; el destinatario entra como hash, nunca en claro. | ensayo: caso 19 del autotest; inspección de `--estado` en la sesión real |
| L2-VER-03 | L1-12 | Cuando el Registro_De_Hooks carece del matcher de los Conectores en el evento PreToolUse, el verificador del catálogo deberá dar ROJO. | Dejar de actuar (Leveson): una puerta desenganchada no avisa sola. El verificador corre en cada arranque. | ensayo: saboteador `probar-t17.py` |

## 9. Nivel 2 — los elementos de T15 («el aprendizaje se cierra»)

Elementos: **APR** el registro de lecciones (`perfil-global/herramientas/aprender.py`, con su medidor `sin-triage`),
**GFO** el guardia de fan-out (`perfil-global/hooks/guardia-fanout.ps1`), **PTA** la puerta, **LAN** su lanzador
(`.claude/hooks/puerta-lanzador.py`) y **AUD** la auditoría. Diseño: `docs/t15-el-aprendizaje-se-cierra.md`. Los padres
son cuatro L1 nuevos, uno por defecto: DA-044 (la lección `propia` que no llega), DA-042 (la recurrencia invisible),
DA-050 (el fan-out sin su costo) y DA-047 (la caja negra en %TEMP%). Términos definidos (R4):

- **Lección_Registrada**: cada línea de `perfil-global/aprendizaje/lecciones.jsonl` sin tipo `exito`.
- **Chequeo_De_Trabajo**: el archivo `perfil-global/chequeo-de-trabajo.md`, cuyo núcleo se inyecta al abrir sesión.
- **Renglón_De_Chequeo**: el comienzo de una viñeta del Chequeo_De_Trabajo, de 25 caracteres o más, guardado en el
  campo `renglon` de la Lección_Registrada; se compara en minúsculas y con los espacios colapsados.
- **Lección_Heredada**: una Lección_Registrada con triage `propia` o `foldeada`, sin Renglón_De_Chequeo y con fecha
  anterior al 2026-10-17 (T15 entró el 2026-10-16: las de ese día son anteriores al freno).
- **Tope_De_Heredadas**: la cuenta de Lección_Heredada medida al construir T15, escrita en el registro de lecciones;
  sólo baja.
- **Recurrencia**: la entrada de una Lección_Registrada que registra que la clase de error de la lección volvió a
  ocurrir, con fecha, proyecto, evidencia y costo.
- **Nivel_Exigido**: el nivel de arreglo que sigue al nivel de la Lección_Registrada en el orden parche, herramienta,
  regla, flujo, meta; una lección sin nivel cuenta como parche.
- **Herramienta_De_Fan_Out**: cada una de las herramientas Workflow, Agent y Task.
- **Costo_Por_Agente**: entre 4 % y 6 % de la ventana de 5 horas del plan Pro por agente (TBR).
- **Caja_Negra**: cada archivo `<sesión>.jsonl` donde la puerta registra lo que la sesión declaró, leyó y decidió.
- **Directorio_De_Caja_Negra**: la carpeta `~/.claude/caja-negra/` del usuario.
- **Directorio_Legado**: la carpeta `claude-cascada` del directorio temporal del sistema operativo.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L1-13 | L0-01 | Cuando la sesión registra una Lección_Registrada con triage `propia` O `foldeada`, el registro de lecciones deberá exigir el Renglón_De_Chequeo de la lección. | DA-044: `sin-triage` medía el rótulo del destino, no la llegada. Medido el 2026-10-16 por 4-gramas de la regla contra las 222 viñetas: 16 de 162 `propia` y 43 de 199 `foldeada` comparten menos de 3 con cualquier viñeta. El chequeo es síntesis reescrita: el solapamiento textual no prueba la llegada, el ancla escrita sí. | ensayo: autotest de `aprender.py` |
| L1-14 | L0-01 | Cuando una Lección_Registrada vuelve a ocurrir, el registro de lecciones deberá exigir un arreglo de nivel mayor que el nivel de la lección. | DA-042 y la regla 15: una lección que se repite con su regla impresa probó que su nivel no alcanzaba. Caso: «17 lectores en paralelo» (2026-09-16) y el workflow de 8 agentes cortados (2026-10-12), sin vínculo entre sí. | ensayo: autotest de `aprender.py`; demostración: una Recurrencia real en esta sesión |
| L1-15 | L0-02 | Cuando la sesión llama a cada Herramienta_De_Fan_Out, el guardia de fan-out deberá mostrar el costo estimado de la llamada en porcentaje de la ventana de 5 horas. | DA-050: el guardia preguntaba con texto fijo y Fran aprobó un workflow que llevó la ventana del 65 % al 100 % en 3,6 minutos. El medidor va en el punto de decisión (Meadows). El hook no ve el uso del plan: muestra el costo, no lo que queda. | ensayo: saboteador del guardia |
| L1-16 | L0-01 | La caja negra de la puerta deberá conservar la Caja_Negra de cada sesión después de un reinicio de la máquina. | DA-047: la evidencia que lee la auditoría vivía en %TEMP%, purgable. En la nube la carpeta del usuario muere con el contenedor: ahí lo que persiste es el informe de la auditoría, commiteado (límite declarado). | ensayo: autotest de la puerta; demostración: la auditoría de esta sesión con el Directorio_Legado vacío |
| L2-APR-01 | L1-13 | Cuando la sesión agrega una Lección_Registrada con triage `propia` O `foldeada` sin Renglón_De_Chequeo, el registro de lecciones deberá rechazar la lección. | Invierte el orden: la viñeta se escribe primero y la lección la cita. Antes, el script avisaba «falta el paso» y el paso dependía de acordarse. | ensayo: autotest, con mutante sin el chequeo |
| L2-APR-02 | L1-13 | Cuando el Renglón_De_Chequeo de la lección agregada difiere del comienzo de cada viñeta del Chequeo_De_Trabajo, el registro de lecciones deberá rechazar la lección. | Un renglón inventado da la llegada por cumplida sin la viñeta. | ensayo: autotest |
| L2-APR-03 | L1-13 | Cuando el Renglón_De_Chequeo de cada Lección_Registrada difiere del comienzo de cada viñeta del Chequeo_De_Trabajo, el medidor de lecciones deberá dar ROJO con la lección Y el renglón. | La viñeta puede borrarse o reescribirse después: el medidor mide la llegada hoy, no la de cuando se registró. Corre en la capa rápida de `chequeo-completo`. | ensayo: autotest, con mutante sin la comparación |
| L2-APR-04 | L1-13 | Cuando la cuenta de Lección_Heredada supera el Tope_De_Heredadas, el medidor de lecciones deberá dar ROJO. | Las heredadas no se pueden anclar por script sin inventar llegadas: quedan como deuda declarada con umbral. Un medidor sin umbral da OK sobre el defecto. | ensayo: autotest |
| L2-APR-05 | L1-13 | Cuando la sesión cambia el triage de una Lección_Registrada a `propia` O `foldeada` sin Renglón_De_Chequeo, el registro de lecciones deberá rechazar el cambio. | El comando `triage` es la segunda entrada al mismo campo. | ensayo: autotest |
| L2-APR-06 | L1-14 | Cuando la sesión registra una Recurrencia de cada Lección_Registrada, el registro de lecciones deberá guardar la Recurrencia con fecha, proyecto, evidencia Y costo. | Contar las repeticiones es el sensor que le faltaba al lazo (DA-042). La evidencia es un puntero, como en el Registro_De_Evidencias de T16. | ensayo: autotest |
| L2-APR-07 | L1-14 | Cuando la sesión registra una Recurrencia de cada Lección_Registrada, el registro de lecciones deberá fijar el Nivel_Exigido de la lección. | La subida es automática: la sesión no decide si sube, decide cómo. Una lección en `meta` que se repite exige `meta` otra vez, y la meta es de Fran. | ensayo: autotest, con mutante que no sube |
| L2-APR-08 | L1-14 | Cuando el nivel de cada Lección_Registrada es menor que el Nivel_Exigido de la lección, el medidor de lecciones deberá dar ROJO con la lección Y el Nivel_Exigido. | Sin el rojo, la subida es una anotación más. | ensayo: autotest |
| L2-APR-09 | L1-14 | Cuando la sesión sube el nivel de cada Lección_Registrada a un nivel menor que el Nivel_Exigido de la lección, el registro de lecciones deberá rechazar la subida. | El arreglo se registra con su evidencia: un commit o una ruta. | ensayo: autotest |
| L2-APR-10 | L1-14 | Cuando la sesión agrega una lección con el título de una Lección_Registrada, el registro de lecciones deberá mostrar el comando que registra la Recurrencia de la Lección_Registrada del título. | Antes decía «no se duplica» y salía: la repetición moría en el rechazo (DA-042). | ensayo: autotest |
| L2-APR-11 | L1-14 | Cuando la sesión agrega una lección, el registro de lecciones deberá listar como posible Recurrencia hasta 3 Lección_Registrada con similitud tf-idf de 0,12 a 1,00 contra la lección agregada. | TBR. Medido el 2026-10-16 sobre título, síntoma y regla: los pares conocidos dan 0,28 (#381 con #192) y 0,13 (#28 con #192), y cada uno sale primero en su lista. Por 4-gramas del síntoma los dos pares dan 0: ese detector nacía ciego. Informa y no frena: «es la misma clase» es un juicio, y un freno con falsos positivos se apaga. | ensayo: autotest con los dos pares conocidos |
| L2-GFO-01 | L1-15 | Cuando la sesión llama a Workflow con un script legible, el guardia de fan-out deberá mostrar la cuenta de llamadas a agentes del script. | Es un piso: un `agent()` adentro de un `map` corre N veces. El guardia lo dice como «al menos». | ensayo: saboteador del guardia |
| L2-GFO-02 | L1-15 | Cuando el guardia de fan-out muestra la cuenta de agentes, el guardia de fan-out deberá mostrar el producto de la cuenta por el Costo_Por_Agente. | Las unidades de la ventana, que es lo que Fran mira en la app (la lección del fan-out por ronda). | ensayo: saboteador del guardia |
| L2-GFO-03 | L1-15 | Cuando el guardia de fan-out muestra el costo estimado, el guardia de fan-out deberá mostrar las mediciones de las que sale el Costo_Por_Agente. | Un número sin su base no se puede auditar ni recalibrar. | ensayo: saboteador del guardia |
| L2-GFO-04 | L1-15 | Cuando el guardia de fan-out carece de un script legible, el guardia de fan-out deberá mostrar la cuenta de agentes como desconocida. | Un workflow guardado por nombre no trae el script en la llamada: el costo desconocido se dice, no se calla. | ensayo: saboteador del guardia |
| L2-GFO-05 | L1-15 | Cuando la sesión llama a cada Herramienta_De_Fan_Out, el guardia de fan-out deberá devolver la decisión `ask`. | T15 agrega información al freno y no cambia su decisión (regla 6): este requisito lo fija. | ensayo: saboteador del guardia |
| L2-PTA-18 | L1-16 | La puerta deberá escribir cada Caja_Negra en el Directorio_De_Caja_Negra. | Fuera de %TEMP% y fuera del repo: la Caja_Negra guarda comandos completos y el repo es público. | ensayo: autotest de la puerta, con mutante en el directorio temporal |
| L2-PTA-19 | L1-16 | Cuando la Caja_Negra de la sesión falta en el Directorio_De_Caja_Negra Y existe en el Directorio_Legado, la puerta deberá copiar la Caja_Negra del Directorio_Legado antes de leerla. | Un freno vivo se edita en un orden que nunca lo deja roto: la sesión que instala T15 declaró y leyó en el Directorio_Legado, y sin la copia la puerta negaría todo. | ensayo: autotest de la puerta |
| L2-LAN-01 | L1-16 | El lanzador de la puerta deberá anotar cada reventón de la puerta en el Directorio_De_Caja_Negra. | El lanzador no puede importar la puerta, que puede estar rota: repite la ruta y su autotest la compara con la de la puerta. | ensayo: autotest del lanzador |
| L2-AUD-03 | L1-16 | La auditoría de la sesión deberá leer la Caja_Negra de la sesión auditada con la regla de ubicación de la puerta. | Una sola regla de ubicación: la auditoría ya carga la puerta, y antes armaba la ruta por su cuenta. | ensayo: autotest de `auditar-sesion.py` |

## 10. Nivel 2 — los elementos de T18 («el método también retira»)

Elementos: **RET** la herramienta de retiro (`perfil-global/herramientas/retiro.py`: el sensor de uso, la pasada y el
medidor de retiro) y **NUC** el generador del Núcleo (`perfil-global/herramientas/nucleo-chequeo.py`). Diseño:
`docs/t18-el-metodo-retira.md`. Los padres son dos L1 nuevos, hijos de L0-02: hasta acá todo lo que el método agrega se
queda (DA-041) y el núcleo inyectado crece con cada lección. Decisión de Fran del 2026-10-17 (encuesta): la primera
versión pone sensor de uso a las viñetas y retira del núcleo lo que pasa 20 sesiones auditadas sin uso; el aviso va en
el cuadro; un freno con impacto escrito nunca sale solo. Términos definidos (R4):

- **Viñeta**: cada viñeta del Chequeo_De_Trabajo según el parser de `nucleo-chequeo.py`.
- **Huella_De_Viñeta**: los primeros 58 caracteres de la Viñeta, en minúsculas y con los espacios colapsados. Medido
  el 2026-10-17: la primera línea más corta de una viñeta tiene 59, así que una búsqueda que muestra sólo esa línea
  entrega la huella entera.
- **Clave_De_Viñeta**: los primeros 40 caracteres de la Huella_De_Viñeta (únicos entre las 222 viñetas, medido). Es lo
  único de la Viñeta que el Registro_De_Retiro y la herramienta de retiro escriben: más corta que la huella, su propia
  salida no cuenta como Uso_De_Viñeta.
- **Núcleo**: el archivo `chequeo-nucleo.md`, generado del Chequeo_De_Trabajo, que se inyecta al abrir cada sesión.
- **Transcript**: cada archivo `.jsonl` de `~/.claude/projects/`, donde el harness guarda lo que recibió una sesión.
- **Uso_De_Viñeta**: la aparición de la Huella_De_Viñeta en el resultado de una herramienta o en el contexto que
  agrega un hook PreToolUse en un Transcript, salvo una lectura del Núcleo; o la fecha de cada Recurrencia de la
  Lección_Registrada cuyo Renglón_De_Chequeo abre la Viñeta.
- **Registro_De_Usos**: el archivo `~/.claude/aprendizaje/usos.json`, con la fecha de inicio y los Uso_De_Viñeta de
  cada Transcript que la herramienta de retiro leyó.
- **Sesión_Auditada**: cada sesión con informe en `.claude/auditorias/` y Transcript leído, en el disco o en el
  Registro_De_Usos.
- **Referencia_De_Viñeta**: la fecha más reciente entre el último Uso_De_Viñeta, la fecha de alta de la Viñeta (la
  fecha de autor de su primera línea según `git blame`) y la última vuelta de la Viñeta.
- **Ventana_De_Retiro**: 20 Sesión_Auditada (Fran, 2026-10-12 y 2026-10-17).
- **Viñeta_Vencida**: una Viñeta sin retirar con la Ventana_De_Retiro o más de Sesión_Auditada posteriores a su
  Referencia_De_Viñeta.
- **Registro_De_Retiro**: el archivo `perfil-global/aprendizaje/retiradas.jsonl`, un evento por línea: retiro,
  vuelta o pasada.
- **Viñeta_Retirada**: una Viñeta cuyo último evento en el Registro_De_Retiro es un retiro.
- **Pasada_De_Retiro**: cada corrida de `retiro.py pasar`.
- **Tope_Por_Pasada**: 10 Viñeta por Pasada_De_Retiro (TBR).

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L1-17 | L0-02 | Cuando cada Viñeta pasa a Viñeta_Vencida, el método deberá sacar la Viñeta del Núcleo. | DA-041: lecciones, capas y medidores sólo entran. Medido el 2026-10-17 sobre 130 Transcript: de las 222 viñetas del núcleo (28 505 caracteres por sesión), 17 nunca le llegaron enteras a ninguna sesión. El spike contó además «95 con 20 sesiones auditadas sin uso», pero sobre los 36 informes; sólo 18 de esas sesiones tienen Transcript (la app borra los demás, L2-RET-11), así que con el denominador medible la cuenta todavía no existe (lección 193, repetida). El costo es de contexto (N-02) y de efectividad (N-01): cada renglón diluye a los demás (la lección del fan-out estaba impresa y no se vio). | demostración: la Pasada_De_Retiro de la sesión que construye T18 |
| L1-18 | L0-02 | Cuando una Viñeta_Retirada registra un Uso_De_Viñeta posterior al retiro de la Viñeta, el método deberá devolver la Viñeta al Núcleo. | El sensor no ve la prevención silenciosa: un renglón que evita el error sin que nadie lea la viñeta entera parece sin uso (Meadows: el freno que nunca salta). La vuelta automática hace del retiro un experimento reversible (Hunt y Thomas: el costo de deshacer), y la Recurrencia de T15 es su detector. La viñeta retirada sigue en el Chequeo_De_Trabajo: se encuentra con Grep y la sigue trayendo el hook al paso. | ensayo: autotest de `retiro.py` |
| L2-RET-01 | L1-17 | Cuando la Pasada_De_Retiro encuentra cada Viñeta_Vencida, la herramienta de retiro deberá registrar el retiro de la Viñeta en el Registro_De_Retiro con la Clave_De_Viñeta, la fecha, el último Uso_De_Viñeta Y la cuenta de Sesión_Auditada sin uso. | Un retiro sin su base no se puede auditar ni deshacer con criterio. El registro es de eventos y sólo se agrega: el estado sale de releerlo, y el diff de cada commit muestra qué salió. | ensayo: autotest, con mutante |
| L2-RET-02 | L1-17 | La herramienta de retiro deberá retirar entre 0 y 10 Viñeta_Vencida en cada Pasada_De_Retiro. | TBR. En un sistema con retardo se aplica una fracción de la corrección (Meadows): sacar las 95 de una vez haría imposible atribuir una recurrencia a un retiro. Con una pasada por sesión, la deuda baja en unas 10 sesiones. | ensayo: autotest |
| L2-RET-03 | L1-17 | Cuando las Viñeta_Vencida de la Pasada_De_Retiro superan el Tope_Por_Pasada, la herramienta de retiro deberá elegir las Viñeta_Vencida con más Sesión_Auditada sin uso. | Lo más viejo sin uso es lo de menor riesgo de retirar. | ensayo: autotest |
| L2-RET-04 | L1-17 | Cuando la Pasada_De_Retiro registra cada retiro, la herramienta de retiro deberá imprimir la Clave_De_Viñeta con el comando de vuelta de la Viñeta. | El aviso de Fran: la sesión lo copia en la línea «Hice» del cuadro. | ensayo: autotest |
| L2-RET-05 | L1-18 | Cuando cada Viñeta_Retirada tiene un Uso_De_Viñeta posterior al retiro de la Viñeta, la herramienta de retiro deberá registrar la vuelta de la Viñeta en el Registro_De_Retiro. | La vuelta no tiene tope: devolver es siempre seguro. | ensayo: autotest, con mutante, sobre una Recurrencia |
| L2-RET-06 | L1-17 | Cuando la herramienta de retiro lee menos Sesión_Auditada que la Ventana_De_Retiro O 0 Uso_De_Viñeta, la herramienta de retiro deberá retirar 0 Viñeta en la Pasada_De_Retiro. | Falla cerrado (Saltzer): un sensor ciego ve todo sin uso y retiraría el núcleo entero. En la nube sólo está el Transcript de la sesión viva: ahí no se retira nada (límite declarado, como L1-16). | ensayo: autotest, con mutante |
| L2-RET-07 | L1-17 | Cuando existe una Viñeta_Vencida Y la última Pasada_De_Retiro es anterior a la última Sesión_Auditada, el medidor de retiro deberá dar ROJO. | El retiro no depende de acordarse: el arranque lo pide, una vez por sesión auditada. Sin Viñeta_Vencida, nada que pedir. | ensayo: autotest |
| L2-RET-08 | L1-18 | Cuando una Viñeta_Retirada tiene un Uso_De_Viñeta posterior al retiro de la Viñeta, el medidor de retiro deberá dar ROJO. | La vuelta pendiente no espera a la próxima sesión auditada: la regla que volvió a hacer falta tiene que estar en el próximo arranque. | ensayo: autotest |
| L2-RET-09 | L1-17 | Cuando la herramienta de retiro lee la Ventana_De_Retiro de Sesión_Auditada Y 0 Uso_De_Viñeta, el medidor de retiro deberá dar ROJO. | El sensor ciego en la PC (un cambio de formato del Transcript) se dice, no se calla: un medidor clavado en «nada vencido» se ve igual que uno sano. | ensayo: autotest, con mutante |
| L2-RET-10 | L1-18 | Cuando la sesión pide la vuelta de una Viñeta_Retirada, la herramienta de retiro deberá registrar la vuelta de la Viñeta en el Registro_De_Retiro. | Lo que se instala solo se desinstala solo (regla 6): el retiro se deshace con un comando. La vuelta cuenta como Referencia_De_Viñeta, así que no vuelve a salir en la pasada siguiente. | ensayo: autotest |
| L2-RET-11 | L1-17 | Cuando un Transcript leído desaparece del disco, la herramienta de retiro deberá conservar la fecha de inicio y los Uso_De_Viñeta del Transcript en el Registro_De_Usos. | Medido al construir T18 (2026-10-17): la app de escritorio borra el Transcript de cada sesión eliminada (153 marcados `desktop-released`, motivo `delete`) y 18 de las 36 sesiones auditadas ya no lo tenían. Sin conservarlo, la ventana se llena con la mitad de la historia o no se llena nunca. El medidor corre en cada arranque, así que la sesión siguiente lee la anterior antes de que se borre; lo que se borró antes del 2026-10-17 se perdió (límite declarado). | ensayo: autotest, con mutante |
| L2-NUC-01 | L1-17 | El generador del Núcleo deberá omitir cada Viñeta_Retirada. | El Núcleo es una vista del Chequeo_De_Trabajo (T20): el retiro cambia la vista, nunca la fuente. | ensayo: autotest de `retiro.py` sobre el generador real |
| L2-NUC-02 | L1-17 | Cuando el Núcleo omite una Viñeta_Retirada, el generador del Núcleo deberá imprimir en el Núcleo la cuenta de Viñeta_Retirada Y el comando de la lista de Viñeta_Retirada. | La sesión sabe que hay reglas fuera del núcleo y cómo llegar: el retiro no las borra de la vista de nadie. | ensayo: autotest |
| L2-NUC-03 | L1-17 | Cuando el Registro_De_Retiro es ilegible, el generador del Núcleo deberá terminar con un código distinto de 0. | Falla ruidoso: ignorar el registro roto devolvería en silencio todo lo retirado, y descartarlo entero ocultaría el defecto. `install.ps1` y `nucleo-chequeo.py --verificar` lo muestran en rojo. | ensayo: autotest |

## 11. Nivel 2 — el concepto `alcance` de la puerta (DA-064)

Elementos: **PTA** la puerta (`cascada_puerta.py`, hook), **VER** su verificador (`--verificar`) y **CAS** la cascada
(`cascada.ps1`). Diseño: `docs/da064-concepto-alcance.md`. Los padres son un L0 y un L1 nuevos: hasta el 2026-10-19 la
puerta llevaba los libros al momento de escribir un requisito (concepto `requisitos`, 2026-10-07) y no al de escribir
el alcance, que es el producto anterior de la cadena (`nucleo-ise.md` §3b). Términos definidos (R4):

- **Título_De_Alcance**: una línea de título de Markdown (`#`) o de Typst (`=`) cuyo texto, sin la numeración ni el
  artículo, empieza con necesidad, meta, objetivo, alcance, need, goal, objective o NGO; en un archivo `PDP.md`,
  también el título «El problema» y el título «Qué NO es».
- **Sección_De_Alcance**: las líneas de un archivo entre un Título_De_Alcance y el título siguiente.
- **Escritura_De_Alcance**: un Write cuyo contenido trae un Título_De_Alcance, un Edit cuyo texto viejo o nuevo trae
  un Título_De_Alcance, o un Edit cuyo texto viejo cae en una Sección_De_Alcance del archivo editado.
- **Lecturas_De_Alcance**: la ficha `perfil-global/pilares/alcance-como-se-escribe.md`, las secciones 3.11 a 3.13 de
  `perfil-global/pilares/nasa-seh/stakeholders.md` (SEH p. 48-49) y, del apunte de IISE, los elementos del alcance
  con el CEV (m18) y el Ejercicio de Alcance de Marte (m20).

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L0-09 | N-01 | El método deberá exigir la lectura de los ejemplares de la forma del alcance Y de los requisitos antes de que la sesión escriba cada uno. | La forma de un tipo de documento se copia de ejemplares reales, no se deduce de su definición (`chequeo-de-trabajo.md`, viñeta del 2026-10-19). Para los requisitos ya lo hacía el concepto `requisitos`. | inspección: los conceptos de `.claude/cascada.json` |
| L1-19 | L0-09 | Cuando la sesión hace una Escritura_De_Alcance, la puerta deberá exigir las Lecturas_De_Alcance. | DA-064 (2026-10-18/19, TP final de IISE): con el SEH destilado desde hace meses, la necesidad salió como tres párrafos de contexto y después con un rótulo «Justificación» inventado; ningún concepto exigía `stakeholders.md`. El disparador es el ROL del texto (el título de una sección del alcance), no una palabra del pedido ni una necesidad declarada (insumo NASA por etiqueta): un proyecto de materia escribe un alcance igual que uno de ingeniería, y N-09 lo deja fuera del freno por fase. | ensayo: caso 20 del autotest de la puerta |
| L2-PTA-20 | L1-19 | Cuando el contenido de un Write trae un Título_De_Alcance, la puerta deberá exigir las Lecturas_De_Alcance. | Escribir el documento entero: la sección 1 de un informe, un PDP nuevo, un documento de requisitos con sus necesidades. | ensayo: caso 20 del autotest, con mutante |
| L2-PTA-21 | L1-19 | Cuando el texto viejo de un Edit cae en una Sección_De_Alcance del archivo editado, la puerta deberá exigir las Lecturas_De_Alcance. | El caso de DA-064: reescribir la frase de la necesidad sin tocar su título (de la v02 a la v03). El título que encierra el texto se busca en el archivo, porque el Edit no lo trae. | ensayo: caso 20 del autotest, con mutante |
| L2-PTA-22 | L1-19 | Cuando el texto viejo O el texto nuevo de un Edit trae un Título_De_Alcance, la puerta deberá exigir las Lecturas_De_Alcance. | Agregar, renombrar o borrar una sección del alcance. | ensayo: caso 20 del autotest |
| L2-PTA-23 | L1-19 | Cuando una acción sobre un archivo difiere de cada Escritura_De_Alcance, la puerta deberá permitir la acción sin las Lecturas_De_Alcance. | El control positivo contra el disparo por palabra: la prosa que nombra «la necesidad» o «los objetivos» no escribe un alcance. Un guardia por patrón de texto frena también el texto que sólo habla de lo protegido, y un freno con falsos positivos se termina sacando (Saltzer, aceptabilidad psicológica). Medido el 2026-10-19 sobre lo trackeado (fuera de los `PDP.md`): 12 títulos caen en la definición y 7 son alcances de verdad; los otros 5 son tres definiciones del glosario de IISE, el objetivo de una sesión en un HANDOFF y el alcance temático de una guía, y cuestan una lectura por sesión, no un freno permanente. | ensayo: caso 20 del autotest |
| L2-VER-04 | L1-19 | Cuando el patrón de cada título de un concepto del catálogo falla al compilar, el verificador del catálogo deberá dar ROJO. | Un patrón roto hace reventar la puerta en cada Edit y el lanzador niega todo menos la reparación: se tiene que ver en el arranque, no a mitad de sesión. | ensayo: saboteador `probar-da064.py` |
| L2-CAS-03 | L1-19 | Cuando la sesión declara la necesidad diseno, materia O lluvia-de-ideas, la cascada deberá imprimir las Lecturas_De_Alcance. | DA-058: lo que la puerta va a exigir se imprime al declarar; si lo nombra recién la primera negación, las ediciones en paralelo se niegan todas. Son las tres necesidades que escriben un alcance (el PDP y los requisitos, el informe de una materia, la meta de una lluvia de ideas). | demostración: `cascada.ps1 telescopio -Necesidad diseno` |
| L2-CAS-04 | L1-19 | Cuando el Documento_De_Requisitos del proyecto declarado trae un Título_De_Alcance, la cascada deberá imprimir las Lecturas_De_Alcance junto al concepto del Documento_De_Requisitos. | Las necesidades (N-xx) viven en el documento de requisitos de arquitectura-se y del telescopio: editar esa sección es escribir un alcance. | demostración: `cascada.ps1 arquitectura-se -Necesidad metodo` |

## 12. Nivel 2 — el libro contra sus fuentes, el mapa de lecturas y la puerta por rol (DA-013, 065, 066, 067, 070)

Elementos: **LIB** el medidor del libro (`perfil-global/herramientas/verificar-libro.py`), **MAP** el mapa de lecturas
(`mapa-lecturas.py`), **PTA** la puerta y **CAS** la cascada. Diseño y medición: `docs/da013-libro-contra-fuente.md`.
Los padres son un L0 nuevo (de N-01) y cuatro L1: hasta el 2026-10-19 los destilados se medían contra el PDF y el
libro que la puerta hace leer siempre no (DA-013); una lectura destilada en la ficha equivocada no llegaba al escribir
(DA-065); el concepto `requisitos` disparaba por el nombre del archivo (DA-067); y la puerta veía un proyecto por
comando (DA-070). Términos definidos (R4):

- **Libro_De_Bolsillo**: los archivos `perfil-global/pilares/nucleo-ise.md` y `perfil-global/pilares/alcance-como-se-escribe.md`.
- **Cita_Del_Libro**: un texto del Libro_De_Bolsillo entre comillas angulares y en cursiva.
- **Carpeta_De_Pilares**: la carpeta `perfil-global/pilares`.
- **Destilado**: cada archivo `.md` bajo la Carpeta_De_Pilares fuera del Libro_De_Bolsillo.
- **Cláusula_De_Escape**: una frase de la prosa del Libro_De_Bolsillo, fuera de comillas y de código, que abre una
  excepción («salvo que», «excepto», «a menos que», «si hace falta», «si es posible», «unless»).
- **Sección_Del_Tema**: una sección de un Destilado cuyo título coincide con los `temas` de un concepto de `.claude/cascada.json`.
- **Título_De_Requerimientos**: un título de Markdown (`#`) o de Typst (`=`) cuyo texto, sin la numeración ni el
  artículo, empieza con requerimiento, requisito o requirement.
- **Título_De_Elemento_Del_Alcance**: un título cuyo texto, sin la numeración ni el artículo, empieza con misión,
  mission, restricción, constraint o autoridad.
- **Proyecto_Tocado**: cada proyecto que la ruta o el comando de una acción nombra.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L0-10 | N-01 | El método deberá mantener el Libro_De_Bolsillo fiel a las fuentes que el Libro_De_Bolsillo cita. | DA-013 (2026-10-19): de 70 reglas del libro y la ficha, 7 cambiaban el sentido de su fuente (los niveles, la excepción de la solución, los números del tope, IRD/ICD, el orden del alcance) y ningún medidor lo veía. | inspección: la tabla de `docs/da013-libro-contra-fuente.md` |
| L1-20 | L0-10 | Cuando una Cita_Del_Libro falta en cada Destilado, el medidor del libro deberá dar ROJO con el archivo, la línea Y la cita. | Los Destilados ya se miden contra el PDF (`verificar-citas.py`, 99,1 %): con la Cita_Del_Libro en un Destilado, la cadena hasta el libro queda medida. Una cita sin Destilado es una fuente sin ficha, y se arregla con la ficha (así nació `pilares/nasa-level1/`). | ensayo: autotest de `verificar-libro.py`, casos 2 y 7 |
| L1-21 | L0-10 | Cuando la prosa del Libro_De_Bolsillo trae una Cláusula_De_Escape en una línea sin quién impone la excepción, el medidor del libro deberá dar ROJO. | DA-066: «salvo que haya una razón escrita» la usó el mismo que la escribía. La excepción de los libros nombra quién la impone (GtWR R31, SEH p. 60). Mira sólo el Libro_De_Bolsillo y frena en el arranque: un patrón por palabra sobre todo el repo frenaría la prosa que habla de excepciones. | ensayo: autotest de `verificar-libro.py`, casos 8 y 9 |
| L2-LIB-01 | L1-20 | Cuando un archivo del Libro_De_Bolsillo trae menos Cita_Del_Libro que el piso del archivo, el medidor del libro deberá dar ROJO. | Falla cerrado: con otra convención de comillas el extractor vería cero citas y daría verde. | ensayo: caso 4 |
| L2-LIB-02 | L1-20 | Cuando la carpeta de Destilados está vacía, el medidor del libro deberá dar ROJO. | Falla cerrado: cero comparaciones no son un verde. | ensayo: caso 6 |
| L1-22 | L0-09 | Cuando una Sección_Del_Tema de un concepto cae fuera de cada rango de lectura del concepto Y de cada exclusión declarada del concepto, el mapa de lecturas deberá dar ROJO con la sección. | DA-065: el App. C estaba entero en `glosario.md` y el concepto `requisitos` leía `requisitos.md`. Medido el 2026-10-19: cinco huérfanas de la misma clase (glosario §2.2, stakeholders §3.8 y §3.18, requisitos.md §4, la ficha nueva de Level 1), hoy enganchadas. | ensayo: autotest de `mapa-lecturas.py`, caso 1 |
| L2-MAP-01 | L1-22 | Cuando una exclusión declarada de un concepto coincide con 0 Sección_Del_Tema, el mapa de lecturas deberá dar ROJO. | Una excepción que sobrevive a su caso tapa el próximo. | ensayo: caso 3 |
| L2-MAP-02 | L1-22 | Cuando una exclusión declarada nombra un segundo concepto como lector Y el segundo concepto deja la sección fuera de cada rango, el mapa de lecturas deberá dar ROJO. | El `lo_lee` es una afirmación sobre otro concepto: se mide, no se cree. | ensayo: caso 4 |
| L2-MAP-03 | L1-22 | Cuando los `temas` de un concepto coinciden con 0 Sección_Del_Tema, el mapa de lecturas deberá dar ROJO. | Una regex ciega da verde de cero secciones. | ensayo: caso 5 |
| L2-MAP-04 | L1-22 | El mapa de lecturas deberá leer cada subcarpeta de la Carpeta_De_Pilares distinta de la subcarpeta fuentes. | Un verificador sólo ve donde vive: una carpeta de Destilados nueva entra sola al censo. | inspección: `destilados()` |
| L1-23 | L0-09 | Cuando la sesión escribe bajo un Título_De_Requerimientos de cada documento, la puerta deberá exigir las lecturas del concepto requisitos. | DA-067: la tabla de L0 del TP se escribió en `informe/seccion-1.md` bajo «1.9 Requerimientos» y el concepto sólo miraba archivos `requisitos*.md`. Medido el 2026-10-19 sobre lo trackeado: 20 títulos, unos 15 son requerimientos; los falsos cuestan una lectura por sesión. | ensayo: caso 21 del autotest de la puerta |
| L2-PTA-24 | L1-23 | Cuando el contenido de un Write O el texto de un Edit trae un Título_De_Requerimientos, la puerta deberá exigir las lecturas del concepto requisitos. | Escribir la sección entera o agregar el título. | ensayo: caso 21, con mutante |
| L2-PTA-25 | L1-23 | Cuando el texto viejo de un Edit cae bajo un Título_De_Requerimientos del archivo editado, la puerta deberá exigir las lecturas del concepto requisitos. | El caso del TP: corregir una fila de la tabla sin tocar el título. | ensayo: caso 21 |
| L2-PTA-26 | L1-23 | Cuando el archivo de la acción es el `ESTADO_ACTUAL.md` O el `HANDOFF.md` de un proyecto, la puerta deberá permitir la acción bajo un Título_De_Requerimientos sin las lecturas del concepto requisitos. | El registro anota qué falta; frenarlo empujaría a saltear el checkpoint (L2-PTA-03). | ensayo: caso 21, con mutante |
| L2-PTA-27 | L1-19 | Cuando la acción escribe bajo un Título_De_Elemento_Del_Alcance, la puerta deberá exigir las Lecturas_De_Alcance. | La misión, las restricciones y la autoridad son elementos del alcance (cátedra, M18). La hipótesis no entra: medido, 6 de sus 8 títulos del repo son hipótesis de depuración. | ensayo: caso 21 |
| L2-CAS-05 | L1-23 | Cuando la sesión declara la necesidad diseno O materia, la cascada deberá imprimir las lecturas del concepto requisitos. | DA-058: lo que la puerta va a exigir se dice al declarar, no en la primera negación. | demostración: `cascada.ps1 telescopio -Necesidad diseno` |
| L2-PTA-28 | L1-08 | Cuando un Proyecto_Tocado de la acción carece de necesidad declarada Y de Excepción, la puerta deberá negar la acción nombrando ese Proyecto_Tocado. | DA-070: un comando con un proyecto liberado y otro no pasaba; `proyecto_de()` cortaba en el primero. | ensayo: caso 22 del autotest de la puerta, con mutante |
| L2-PTA-29 | L1-08 | Cuando cada Proyecto_Tocado de la acción tiene necesidad declarada, la puerta deberá exigir la lectura de la necesidad de cada Proyecto_Tocado. | El segundo proyecto declarado y sin leer pasaba igual. | ensayo: caso 22, con mutante |
