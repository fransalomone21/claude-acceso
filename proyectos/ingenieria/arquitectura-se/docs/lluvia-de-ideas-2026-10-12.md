# Lluvia de ideas del método — sesión de arquitectura creativa (2026-10-12)

Sesión `de44da9d` (Opus 5.5, esfuerzo alto, ultracode). Pedido de Fran: encontrar, registrar y arreglar los
defectos **conceptuales** de la arquitectura del método; «no quiero que te achiques por el budget, quiero que salga
perfecto, cueste lo que cueste: es arquitectura, y no se negocia ni se ratonea». Fase 7 (NASA Phase D): esto es
**insumo** de la validación; nada vivo se toca sin un diseño T-n escrito antes.

Este documento es a la vez el **producto** de la lluvia (las ocho secciones de `/lluvia-de-ideas`) y el **punto de
retome** de la sesión si el límite de 5 h la corta: la sección «Progreso» dice qué está hecho y por dónde seguir.

---

## Progreso (checkpoint para el retome automático)

Si esta sesión se reanuda sola después del límite: leer esta sección, no rehacer lo marcado `[x]`, y seguir por el
primer `[ ]`. Un workflow cortado se reanuda con `Workflow({scriptPath, resumeFromRunId})` (los agentes ya
terminados devuelven su resultado en caché). Antes de cada workflow pesado: `get_usage` y, si va a cruzar el
límite, dejar programado con `CronCreate` (una vez) el retome para `resetsAt + 7 min`.

- [x] Puerta: `metodo,lluvia-de-ideas` declarada y sus 14 rangos leídos; excepción registrada para `black` (sólo
      aparece como dato en el retome).
- [x] §0 línea de base medida (abajo) y copiada al HANDOFF.
- [ ] (a) MAPA del método: workflow, un agente por subsistema → §M.
- [ ] (b) ENCONTRAR: lentes + 3 escépticos por candidato, hasta dos rondas secas → `defectos.py agregar`.
- [ ] (c) PRIORIZAR: palanca, costo de esperar, riesgo; la pregunta de valor a Fran (qué pesa más).
- [ ] (d) DISEÑAR: panel de alternativas por defecto (primero ELIMINAR) → diseños T-n con requisitos.
- [ ] (e) CERRAR: `defectos.py vista/verificar/vista --check`, ESTADO, HANDOFF, commit + push de los dos repos,
      auditoría, retome de la sesión siguiente.

Workflows lanzados (para `resumeFromRunId`): ninguno todavía.

---

## 0. La meta y el estado medido: la línea de base

**La meta del método:** que las sesiones de proyecto lleguen a resultados verificables (efectividad), pagando lo
menos posible de contexto y de plan (costo), sin frenos ni arranques que demoren (plazo). Todo lo que salga de esta
sesión se juzga contra esta tabla: un defecto se cierra si **baja un costo o sube una efectividad, medido**.

Medido el 2026-10-12 03:15 (-03), al entrar.

### Efectividad

| Medida | Valor | Fuente / grado |
|---|---|---|
| Sesiones por pieza (caso de base) | BLACK pieza 2 del coop = **13 sesiones** bajando capa por capa del mismo defecto | `black/docs/19-lluvia-de-ideas-2026-10-12.md`; leído |
| Defectos de arquitectura validados | **0 de 38** (37 abiertos, 1 arreglado sin validar: DA-034) | `defectos.py resumen`; medido |
| Proyectos en fases A–D sin requisitos | **6 de 22**; 8 fases abiertas sin tipo NASA | `medir-fases.py` (sale 1; control positivo OK); medido |
| Sesiones auditadas con ROJO | **2 de 21** (las dos P3, el libro; la de d7be1e49 es falsa por DA-038) | `.claude/auditorias/`, 2026-10-07 a 10-12; medido |
| Lecciones de proceso acumuladas | 379 | `lecciones.jsonl`; medido |

### Costo (caracteres, salvo donde dice)

| Medida | Valor | Fuente / grado |
|---|---|---|
| Lo que paga el método al abrir (`ses.met`, mediana de 3) | **87 712** (con T12 validada era 78 070: **+12 % en 10 días**) | `medir-costo.py --ultimas 3`; medido |
| Lo que paga el harness (`ses.harn`) | 243 194 (no es del método; los plugins de SEO y Adobe ~29 K siguen prendidos) | ídem |
| Por turno: recordatorio / cuadro | 1 154–1 683 / 1 144–1 187 | ídem |
| Lectura que exige la puerta por entrada | esta sesión **105 697** (~30 K tokens, 14 rangos, `metodo,lluvia-de-ideas`); d7be1e49 **448 352** (BLACK con tres necesidades + método) | ídem |
| CLAUDE.md anidados cargados | 5 774 (leer el m24 de la cátedra carga el contrato de `apunte-iise` y dispara su `fase_activa`) | ídem |
| Plan | ventana de 5 h al **65 %** a los ~10 min de esta sesión (la ventana viene de d7be1e49); semanal **34 %** | `get_usage`; medido |

### Plazo

| Medida | Valor | Fuente / grado |
|---|---|---|
| Arranque: medidores de la capa rápida | 12 medidores, de 0,7 a 28,2 s cada uno, **109,7 s sumados**; el tiempo de pared, a medir en el mapa | hook `SessionStart` de esta sesión; medido (suma) |
| Frenos negados por sesión | **46 negadas en 2 115 decisiones (2,2 %)** en 21 sesiones auditadas; mediana 1, máximo 7; 0 caídas de la puerta | P6 de las auditorías; medido |
| Esta sesión, al entrar | 1 negada: falso positivo por la palabra «BLACK» dentro del retome que el propio método escribió; se salió con `-Excepcion` | caja negra de la puerta; medido |

