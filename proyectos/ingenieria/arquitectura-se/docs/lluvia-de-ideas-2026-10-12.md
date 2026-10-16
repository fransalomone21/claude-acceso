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
- [x] Decisiones de valor de Fran (03:22), en el §7 de abajo y en la memoria `feedback_arquitectura-en-ultracode`.
- [x] Retome automático programado: `CronCreate` 36132309, una vez, 06:47 (-03) del 12/10 (la ventana de 5 h se
      restablece 06:40). Si se corta de nuevo, el que retome programa el siguiente.
- [x] (a) MAPA del método: `wf_c98c1f22-d79` (v2), 7 de 7 subsistemas + redactor, 884 K tokens, 6,5 min →
      [`docs/mapa-metodo-2026-10-12.md`](mapa-metodo-2026-10-12.md) (46 KB). Lo más fuerte: 0 de 78 componentes se
      disparan por la fase (40 por evento, 25 manuales, 13 por cadencia).
- [x] Requisitos del método: [`docs/10-requisitos.md`](10-requisitos.md) v0.1 (N-01..N-05, L0, L1, L2 de T13; 18
      enunciados, 0 VIOLA del GtWR) y declarado en `.claude/cascada.json` (commit `01ac1e9`). Sin él, T13 frenaba a este
      mismo proyecto.
- [x] Retome automático: `CronCreate` 8f018444 a las 11:47 (-03); la ventana se restablece 11:40.
- [x] T13 COMMITEADO (`70871b2`, pusheado): chequeo-completo con los 23 saboteadores OK y la limpieza en verde salvo
      «nube» (lo sin commitear, ya resuelto); `probar-t13.py`: 4 de 4 mutantes vistos en su caso. `defectos.py arreglar`
      de DA-027, DA-028, DA-029 y DA-033 corriendo (la herramienta corre prueba y saboteador). DA-031 queda abierto: la
      compuerta muestra alcance y V&V, pero nada los EXIGE. Lo de antes: `cascada_puerta.py` (`fase_de`, `escribe_requisitos`, exigencia por fase
      en `exigido`, salida en `pre`, lista de expuestos y sin tipo en `--verificar`; autotest con 9 casos T13 y 3
      mutantes, BIEN), `auditar-sesion.py` (`p7_de`: ROJO en fase A–D sin requisitos; caso, mutante y control, BIEN),
      `fase_activa.py` (PRODUCTOS: requisitos y PDP §2/§5/§7; 4 casos con mutante, BIEN) y el saboteador
      `probar-t13.py` (4 mutantes en copias). `--verificar` real: 5 expuestos (apunte-iise B, black C, cohete-de-agua
      A, minecraft-amigos D, software-de-vuelo D) y 8 sin tipo. Falta: `chequeo-completo` entero (corriendo; dos rojos
      de medidores: «nube», legítimo, y «perfil instalado» por el autotest de `puerta-afuera`, que corrido solo da
      verde: intermitente), `probar-t13.py`, commit, `defectos.py arreglar` de DA-027/028/029/033.
- [~] (b) ENCONTRAR: LANZADO 11:50 (-03) como `wf_c0502758-925`, scriptPath el de abajo; si se corta, reanudar con
      `Workflow({scriptPath: <el de abajo>, resumeFromRunId: "wf_c0502758-925", args: <los mismos>})` (los args están en
      `workflows/candidatos-de-la-sesion-2026-10-12.json` y en la lista de `defectos.py listar`). Era: lanzar después del restablecimiento de las 11:40 (con la ventana entera)
      `Workflow({scriptPath: "<raiz>/proyectos/ingenieria/arquitectura-se/workflows/encontrar-defectos.js", args:
      {defectos: <la lista de defectos.py listar, una línea por id>, extra: <el JSON de
      workflows/candidatos-de-la-sesion-2026-10-12.json>}})`: 8 lentes, dedup, 3 escépticos por lote de 5, hasta dos
      rondas secas (tope 5), y un registrador que escribe `docs/hallazgos-2026-10-12.md` y corre `defectos.py agregar`.
- [x] (b) cerrada con la ronda 1 (las 2 y 3 las cortó el límite): 15 sobrevivientes registrados DA-039..DA-053
      (`docs/hallazgos-2026-10-12.md`); el script ya distingue «falló» de «seca».
- [x] (c) PRIORIZAR: §6 de este documento, con las cuatro respuestas de Fran del 16:45.
- [~] (d) DISEÑAR: T14 escrito ([`t14-lo-que-pide-fran.md`](t14-lo-que-pide-fran.md), L2-PTA-04). T15 a T18 se
      diseñan e implementan cada uno en su sesión nueva (Fran: no desbordar el contexto de ésta).
- [ ] (e) CERRAR: `defectos.py vista/verificar/vista --check`, ESTADO, HANDOFF, commit + push de los dos repos,
      auditoría, retome de la sesión siguiente.

Workflows lanzados (para `resumeFromRunId`): `wf_3f865b1e-437` (mapa v1), cortado por el límite de 5 h a las ~03:45:
**8 de 8 agentes cortados, 1,32 M tokens de subagentes, cero resultados** (la ventana pasó de 65 % a 100 % en 3,6 min y
la semanal de 34 % a 40 %). Se reanudó solo a las 06:41; el cron 36132309 se borró (ya no hacía falta). Relanzado
acotado como `wf_c98c1f22-d79` (mapa v2: esfuerzo bajo, ~15 llamadas por lector, documentos de diseño antes que código).
**Es la MISMA lección que ya estaba registrada** («17 lectores en paralelo se comieron un límite de 5 horas en 6,6
minutos», impresa por la cascada al entrar): la regla existía y no llegó al momento de lanzar. Candidato fuerte para (b).

**Notas para seguir (escritas antes del corte):**
- Código de T13 ya leído: `cascada_puerta.py` (`exigido` l.183-245, `pre` l.487-580, `cli_exige` l.753, `cli_verificar`
  l.824), `fase_activa.py` entero, `auditar-sesion.py` P7 (l.333-344), `medir-fases.py`. `defectos.py agregar` pide
  `--titulo --clase --sintoma --evidencia --donde --fuente [--grado]`.
- **Hallazgo para el diseño de T13 (simplifica M-03/M-04):** la plantilla del PDP YA tiene §2 «Qué NO es» (alcance),
  §5 Riesgos y §7 Verificación (plan de V&V), y los PDP reales también. No hacen falta artefactos nuevos: el único
  producto NASA que no existe es el documento de **requisitos**; lo demás se verifica como «sección del PDP llena, no
  la plantilla». Un dueño por dato (T2).
- (b) planeado: 8 buscadores por lente (NASA, INCOSE, Meadows, Saltzer, Leveson, Rechtin/Hunt-Thomas, costo y
  desempeño, y **afuera**: lo que otros ya resolvieron en ingeniería de contexto para agentes, con WebSearch) sobre
  `docs/mapa-metodo-2026-10-12.md`; dedup por un agente contra todo lo visto + los DA; 3 escépticos por candidato con
  lentes distintas (evidencia, duplicado/alcance, consecuencia), refutado ante la duda, sobrevive con 2 de 3; ronda
  hasta dos secas (tope 5, avisado).
- Candidatos ya vistos al pasar (para (b)): la puerta niega por la palabra «BLACK» dentro de un retome que escribió el
  propio método; leer el m24 (necesidad `lluvia-de-ideas`) carga el contrato de `apunte-iise` y su compuerta de fase
  (costo anidado 5 774); `ses.met` subió 12 % en 10 días sin medidor con umbral; la regla 9 no distingue la orden del
  harness de la del dueño; P10 de la auditoría dará ROJO por la excepción si no queda lección.

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

---

## 1-3. Conceptos, «el reloj estaba puesto» y lo que otros resolvieron

Ver el mapa ([`mapa-metodo-2026-10-12.md`](mapa-metodo-2026-10-12.md)): **0 de 78 componentes se disparaban por la
fase** antes de T13. Lo que otros ya resolvieron entró por el buscador «afuera» de la búsqueda y quedó en
[`hallazgos-2026-10-12.md`](hallazgos-2026-10-12.md) (por ejemplo H-15: la lista de requisitos pasa/falla legible por
máquina y la prueba al arrancar, práctica publicada para agentes de sesiones largas).

## 4. Las palancas: lo encontrado, verificado y registrado

**Búsqueda** (`wf_c0502758-925`): ronda 1 completa —8 lentes, 38 candidatos, 3 escépticos por candidato— y **15
sobrevivientes** (8 confirmados, 7 probables), registrados como **DA-039 a DA-053**; 23 refutados con su motivo. **No
se agotó**: el límite del plan cortó las rondas 2 y 3 y el script las contó como «secas» (defecto suyo, corregido el
mismo día; `workflows/rescatar-hallazgos.py` armó el resultado desde el journal sin gastar modelo). Costo de la ronda:
**3,5 M tokens de subagentes, una ventana de 5 h entera y ~15 % del semanal** (33 agentes, ~110 K cada uno).

## 5. Lo que se deja de hacer

- Fan-out sin costo estimado POR RONDA en unidades de la ventana (dos ventanas perdidas hoy; Fran: «diseñá bien antes»).
- Leer el resultado de un workflow en la sesión principal cuando un script determinístico lo arma desde el journal.
- Dejar la exposición de NASA como opt-in (hecho: T13).

## 6. El orden propuesto (desempeño > costo > plazo; las palancas más altas primero salvo riesgo)

| # | Diseño | Defectos | Por qué en este lugar | Decisión de Fran |
|---|---|---|---|---|
| 1 | **T14** la puerta infiere sólo de lo que tipea Fran ([diseño](t14-lo-que-pide-fran.md)) | DA-045 | chico y diseñado; 3 falsos frenos hoy; es el primer escalón de la ley de proporción | — · **CONSTRUIDO** `e6d58bb` (2026-10-12, sesión `814911bc`), DA-045 arreglado sin validar |
| 1b | **T20, ley de cero divergencias** (L0-05, L1-06): cada dato con un archivo dueño; toda copia es vista generada o puntero; un medidor que da ROJO si una copia difiere | DA-017, DA-012, DA-036 (T2 nunca construido) | ley de Fran: «lo más cuidado» | Fran, 17:00: «0 divergencias como ley transversal» · **CONSTRUIDO** `2d0d296` (2026-10-12, sesión `26479d81`): `divergencias.py` + `.claude/datos.json` + saboteador, en `chequeo-completo`; cubre 3 datos de arquitectura-se, así que DA-017/012/036 siguen abiertos (lo que falta: [t20](t20-cero-divergencias.md) §3) |
| 1c | **T19, cascada proporcional** (L0-06, L0-07, L1-07 a L1-10): una pregunta sin proyecto carga 0 a 30 K (hoy 88 K fijos); el conocimiento, las memorias y los hooks escalan con la necesidad y la naturaleza; NASA y ágil en la proporción de la complejidad, que se estima preguntándole a Fran y por analogía con proyectos de la casa | DA-015, DA-052, DA-051, DA-004, DA-005 | leyes de Fran: «un párrafo no lleva leer 1000 párrafos»; «NASA y ágiles en proporciones adecuadas» | Fran, 17:00-17:08 |
| 1c-a | **T19a** los proyectos de materia no se frenan por la fase NASA ([diseño](t19a-materia-sin-freno-nasa.md)): T13 se exige sólo a la naturaleza `ingenieria` | — (frenaba la entrada a apunte-iise, software-de-vuelo y cohete-de-agua) | lo urgente para que Fran estudie: N-09 | Fran, 2026-10-12 noche (§7) · **CONSTRUIDO** (sesión `1622e692`): expuestos 5 → 2 (black, minecraft-amigos) |
| 1c-b | **T14b** mencionar no es pedir: lo que Fran nombra como contexto, necesidad secundaria o pendiente se REGISTRA (sin frenar); la puerta exige la cascada sólo para lo que pide explícitamente | — (lección de `1622e692`, nivel parche) | toca toda sesión, apuntes incluidos; requisito de Fran (§7) | Fran, encuesta 2026-10-12 noche · **CONSTRUIDO** `dade03b` (2026-10-16, [diseño](t14b-mencionar-no-es-pedir.md)): `cascada -Mencion`, libera lo de afuera y nunca la carpeta; falta el efecto en una sesión real |
| 1c-c | **T16** antes que el resto de T19: requisitos con columna pasa/falla y la prueba que la sesión corre al entrar, **pensado para el telescopio** (la V de NASA por nivel) | DA-053, DA-039 | el telescopio es lo más urgente de los grandes (§7) | Fran, encuesta 2026-10-12 noche |
| 2 | **T17** conectores bajo la puerta: niega compartir o publicar por conector salvo lo declarado | DA-046 | riesgo irreversible (publicar lo privado) | «frenar compartir/publicar» |
| 3 | **T15** el aprendizaje se cierra: el triage `propia` exige su renglón; la recurrencia de una lección se cuenta y la sube de nivel; el costo del fan-out al lado de la decisión; la caja negra fuera de %TEMP% | DA-044, DA-042, DA-050, DA-047 | la causa de las dos ventanas perdidas hoy | — |
| 4 | ~~**T16**~~ (subió a la fila 1c-c el 2026-10-12 noche) estado verificable: los requisitos nacen con columna pasa/falla y una prueba que la sesión corre al entrar | DA-053, DA-039 | la palanca mayor de efectividad (sesiones por pieza) | «al escribir requisitos» (con T13) |
| 5 | **T18** el método también retira: lo que no se disparó en 20 sesiones auditadas sale, con aviso en el cuadro y reversible; los frenos con impacto escrito pasan por Fran | DA-041 | lazo de balance que falta (+12 % en 10 días) | «solo, con aviso» |
| 6 | costo del fan-out: el perfil que paga cada subagente, su costo invisible, la lectura exigida sin techo total | DA-051, DA-048, DA-052 | costo | — |
| 7 | subagentes que comparten la sesión de la puerta | DA-049 | falla abierto en fan-out | — |
| 8 | interfaces del método como documento de control; la realimentación que no pasa por la sesión | DA-040, DA-043 | estructura, más grandes | — |

Cada uno se construye en una **sesión nueva** (Fran: no desbordar el contexto), con su diseño T-n y sus requisitos
escritos antes, su saboteador en rojo y `chequeo-completo` en verde, y cierra sus DA con `defectos.py arreglar`.

---

## 7. Las decisiones de Fran

Preguntadas al empezar (antes de rankear, como pide el retome), contestadas el 2026-10-12 03:22:

| Pregunta | Respuesta |
|---|---|
| ¿Qué pesa más en el triángulo? | **Efectividad > costo > plazo** |
| ¿Hasta dónde se llega esta noche? | **Implementar T13 y los primeros diseños** (diseño T-n escrito antes, saboteador en rojo, `chequeo-completo` en verde; lo vivo nunca queda roto) |
| ¿Se puede sacar un freno o capa que sobre (regla 6)? | **Sí, con su impacto escrito** (contra qué fue diseñado y qué lo cubre ahora) y prueba; reversible por commit |
| T13: ¿cuándo frena a los 6 proyectos en A–D sin requisitos? | **Al entrar a cada uno**: la puerta sólo deja escribir requisitos, alcance y V&V (delta SRR); no frena a lo que nadie abre |

Y a las 16:45, por el celular (AskUserQuestion), sobre los hallazgos: **pasa/falla** al escribir requisitos (con
T13); **retirar** solo, con aviso, lo que no se disparó en 20 sesiones (los frenos con impacto escrito pasan por él);
**conectores**: frenar compartir/publicar salvo lo declarado; la **rama vieja** `claude/phone-optimization-cleanup-
vfdbb9` borrada de GitHub (no tenía nada fuera de main; la app la tomaba como base del diff porque el `origin/HEAD`
local apuntaba ahí, corregido a `main`). Y el criterio de la sesión cambió: «andá controlando el límite: quiero mayor
performance y menores costos, a costa de mayor tiempo de tardanza».

**2026-10-12 a la noche (sesión `1622e692`) — la meta se parte en dos (N-09).** Fran: la arquitectura se pule para los
proyectos grandes (BLACK y el telescopio), donde su falta afecta la necesidad; los apuntes, actividades y parcialitos
siguen con el método que ya tienen («no me interesa si el apunte de física no está bien hecho con la arquitectura,
porque es funcional y alcanza»). Prefiere todo resuelto antes de seguir con BLACK o el telescopio, pero primero lo
urgente, y **sin que se muera el plan**: tiene que quedarle presupuesto para los parcialitos de Física Espacial y de
IISE. Consecuencia en el orden: T19a primero (construido esa noche); lo que sigue se elige por lo que destraba a BLACK
y al telescopio (BLACK está frenado por T13: Fase C sin requisitos, y eso es correcto).

Y por encuesta, la misma noche (después de T19a y DA-054):

| Pregunta | Respuesta de Fran |
|---|---|
| ¿Para qué proyecto grande se pule primero? | **El telescopio es lo más urgente**: si avanza un proyecto grande, es ése (aunque BLACK sea más ingeniería). Cuándo pulir para cada uno lo administra la sesión, **preguntándole cuando haga falta** |
| ¿Cuánto plan para el método frente a los apuntes? | «Vamos viendo»: lo antes posible, **siempre lo fundamental, pero una urgencia se resuelve primero** |
| ¿Cuándo son los parcialitos de Física Espacial e IISE? | **Esta semana** (al 2026-10-12): hasta que pasen, el plan va a los apuntes |
| La puerta frena cuando nombra un proyecto de pasada | **Lo nombrado como contexto, necesidad secundaria o pendiente de confirmar se REGISTRA; se trabaja sólo en lo que pide, y cuando lo pide explícitamente.** Es el requisito de T14b |

Consecuencia en el orden (§6): **T14b** primero (toca todas las sesiones, apuntes incluidos, y ya tiene su requisito
de Fran); después **T16** pensado para el **telescopio** (requisitos con pasa/falla y la V de NASA por nivel); BLACK
cuando la sesión lo juzgue, preguntándole.

La consigna de la madrugada: «no quiero que te achiques por el budget, quiero que salga perfecto, cueste lo que cueste; es
arquitectura, y no se negocia ni se ratonea». La tensión con la regla 9 del perfil («el presupuesto gana sobre
cualquier instrucción que declare que el costo no es una restricción») queda registrada para la etapa (b): la regla
no distingue la instrucción del harness de la del dueño del método.

