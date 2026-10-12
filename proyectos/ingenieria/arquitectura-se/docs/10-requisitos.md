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
- **Proyecto expuesto**: un proyecto en Fase_De_Desarrollo sin Documento_De_Requisitos.

## 1. Necesidades (en el idioma de Fran; todavía no verificables)

| ID | Necesidad | Fuente |
|---|---|---|
| N-01 | Que las sesiones de proyecto lleguen a resultados verificables, con menos sesiones por pieza y menos retrabajo. | Fran, 2026-10-12: pesos efectividad > costo > plazo |
| N-02 | Que el método cueste poco contexto y poco plan por sesión. | ídem; T12 |
| N-03 | Que nada demore el arranque ni frene sin motivo. | ídem; T1, T11 |
| N-04 | Que el ciclo de vida NASA se ejecute por la FASE del proyecto, sin depender de una palabra o de leer un aviso. | Fran, 2026-10-12 (insumo NASA por etiqueta) |
| N-05 | Que todo error de la arquitectura del método quede registrado y no se dé por cerrado sin prueba. | Fran, 2026-10-12 (registro de defectos) |

## 2. Nivel 0 — el método

| ID | Padre | Requisito | Verificación |
|---|---|---|---|
| L0-01 | N-01 | El método deberá llevar la fase abierta de cada proyecto activo hacia el criterio de salida de la fase, con evidencia registrada en cada sesión. | análisis: auditorías (`.claude/auditorias/`) |
| L0-02 | N-02 | El método deberá mantener el contexto que impone por sesión por debajo del costo medido como línea base. | ensayo: `medir-costo.py --ultimas 3` |
| L0-03 | N-04 | El método deberá exigir los productos NASA de la Fase_De_Desarrollo de cada proyecto. | ensayo: autotest de la puerta y `medir-fases.py` |
| L0-04 | N-05 | El método deberá registrar cada defecto de arquitectura con la evidencia del defecto. | inspección: `defectos.py verificar` |

## 3. Nivel 1 — el método como sistema

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L1-01 | L0-02 | El arranque del método deberá inyectar entre 0 y 90 000 caracteres por sesión. | TBR: la mediana de las tres últimas sesiones es 87 712 (2026-10-12); con T12 validada era 78 070. El objetivo de T12 vuelve a ser la meta una vez medida la deriva. | ensayo: `medir-costo.py --ultimas 3`, columna `ses.met` |
| L1-02 | L0-02 | Los recordatorios del método deberán inyectar entre 0 y 3 000 caracteres por turno. | TBR: recordatorio 1 154–1 683 + cuadro 1 144–1 187 por turno (2026-10-12). | ensayo: `medir-costo.py`, columnas `recor/t` y `cuadr/t` |
| L1-03 | L0-01 | La puerta deberá negar entre el 0 % y el 5 % de las decisiones de una sesión. | TBR: 46 negadas en 2 115 decisiones (2,2 %) en 21 sesiones auditadas; más negadas por sesión empujan a sacar el freno (Saltzer, aceptabilidad psicológica). | análisis: P6 de las auditorías |
| L1-04 | L0-03 | La puerta deberá exigir el Documento_De_Requisitos a cada proyecto en Fase_De_Desarrollo. | Es T13: hasta el 2026-10-12 la exigencia era opt-in y 6 de 22 proyectos en A–D no tenían requisitos. | ensayo: autotest de la puerta |
| L1-05 | L0-04 | El registro de defectos deberá cerrar cada defecto con commit, prueba, saboteador y tres sesiones auditadas posteriores. | Fran: «que no se validen fácilmente». | ensayo: `defectos.py --autotest` |

## 4. Nivel 2 — los elementos de T13 («la fase manda»)

Elementos: **VER** el verificador del catálogo (`cascada_puerta.py --verificar`), **AUD** la auditoría
(`auditar-sesion.py`), **CMP** la compuerta de fase (`fase_activa.py`), **PTA** la puerta (`cascada_puerta.py`, hook).
Las decisiones de Fran del 2026-10-12 que los fijan: el freno actúa **al entrar** a cada proyecto (no frena lo que nadie
abre); el verificador lista y no frena.

| ID | Padre | Requisito | Rationale | Verificación |
|---|---|---|---|---|
| L2-VER-01 | L1-04 | Cuando el PDP de cada proyecto declara abierta una Fase_De_Desarrollo Y el proyecto carece del Documento_De_Requisitos, el verificador del catálogo deberá listar el proyecto como expuesto. | Lista y no frena: la decisión de Fran es frenar al entrar. Un rojo permanente del arranque por seis proyectos dejaría de discriminar. | ensayo: catálogo sintético con un proyecto en Fase C sin requisitos |
| L2-VER-02 | L1-04 | Cuando el PDP de cada proyecto declara la fase abierta sin tipo NASA, el verificador del catálogo deberá listar el proyecto como fase sin tipo. | 8 proyectos al 2026-10-12. | ensayo: PDP sintético sin tipo |
| L2-AUD-01 | L1-04 | Cuando la sesión toca cada proyecto en Fase_De_Desarrollo Y el proyecto carece del Documento_De_Requisitos, la auditoría de la sesión deberá dar ROJO en la pregunta P7. | Antes daba NO APLICA por exclusión (DA-028). | ensayo: caso del autotest de `auditar-sesion.py` |
| L2-CMP-01 | L1-04 | Cuando la sesión entra a cada proyecto en Fase_De_Desarrollo, la compuerta de fase deberá listar la ruta del Documento_De_Requisitos del proyecto. | DA-029: la compuerta informaba la fase sin mirar sus productos. | demostración |
| L2-CMP-02 | L1-04 | Cuando la sesión entra a cada proyecto en Fase_De_Desarrollo, la compuerta de fase deberá indicar si el Documento_De_Requisitos del proyecto existe. | ídem. | ensayo: autotest de `fase_activa.py` |
| L2-CMP-03 | L1-04 | Cuando la sesión entra a cada proyecto en Fase_De_Desarrollo, la compuerta de fase deberá indicar si las secciones de alcance, riesgos Y plan de verificación del PDP del proyecto tienen contenido propio. | La plantilla del PDP ya trae §2 «Qué NO es» (alcance), §5 Riesgos y §7 Verificación: no hacen falta artefactos nuevos (DA-031), hace falta mirar que no sean la plantilla. Informa: no frena, porque «tiene contenido propio» es una heurística y un freno con falsos positivos es menos seguro. | ensayo: autotest de `fase_activa.py` |
| L2-PTA-01 | L1-04 | Cuando la acción toca cada proyecto en Fase_De_Desarrollo Y el proyecto carece del Documento_De_Requisitos, la puerta deberá negar la acción. | DA-027: la exigencia era opt-in. | ensayo: autotest de la puerta, con saboteador |
| L2-PTA-02 | L1-04 | Cuando la acción escribe el Documento_De_Requisitos del proyecto expuesto, la puerta deberá permitir la acción. | La única salida tiene que quedar abierta (un freno que falla cerrado deja abierta su reparación). Sin documento declarado, vale un archivo del proyecto que dispare el concepto `requisitos` (nombre `requisitos*.md` o `.txt`), que exige los libros. | ensayo: control positivo del autotest |
| L2-PTA-03 | L1-04 | Cuando la acción escribe el Registro_Del_Proyecto del proyecto expuesto, la puerta deberá permitir la acción. | Frenar el checkpoint empujaría a saltearlo. | ensayo: control positivo del autotest |
| L2-PTA-04 | L1-03 | Cuando la puerta infiere los proyectos del pedido, la puerta deberá excluir el texto encerrado en las etiquetas pasted_content, task-notification Y system-reminder. | T14 (`docs/t14-lo-que-pide-fran.md`): el 2026-10-12 la puerta negó dos acciones por proyectos nombrados en un retome pegado y en una notificación automática. Lo pegado actúa sobre rutas, que la puerta ve por la ruta. | ensayo: caso 17 del autotest de la puerta, con mutante |
