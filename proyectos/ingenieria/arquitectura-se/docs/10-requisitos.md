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
