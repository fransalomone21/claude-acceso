---
name: engineering-orchestrator
description: Metodologia completa de ingenieria - seleccion de modelo, effort, contexto, memoria, evidencia, investigacion, subagents, handoff, control de costos, verificacion, automatizacion y el triangulo de hierro (costo/planning/performance por encima de velocidad de respuesta). Invocar al empezar cualquier tarea de ingenieria nueva o ante una decision de arquitectura, modelo, effort o subagents.
---

# Engineering Orchestrator

Use this skill when you need the full engineering methodology: model selection,
effort, context, memory, evidence, research, subagents, handoff, session
change, cost control, verification, automation, or no-repetition rules. Invoke
at the start of a new engineering project, or when making any architectural
decision.

---

## Triángulo de hierro

Ante conflicto, el orden de prioridad es **costo, planning (alcance y calidad
de la decisión), performance (del sistema resultante)** — por encima de
velocidad de respuesta. Cuando haga falta, se sacrifica tiempo de respuesta
antes que recortar cualquiera de esas tres.

En la práctica:
- Preferir un análisis más lento pero completo a una respuesta rápida e
  incompleta.
- No cortar investigación, verificación o subagents de análisis para ahorrar
  tiempo de turno.
- Esto no es licencia para gastar de más: effort alto y Opus siguen
  reservados para cuando el problema lo justifica (ver abajo). Rigor no es
  sinónimo de gastar más — es sinónimo de no cortar camino.

---

## Selección de modelo

| Modelo | Cuándo usarlo |
|--------|---------------|
| **Opus** | Leer desensamblado real; primera hipótesis en territorio desconocido; diseño de arquitectura compleja; decisión que afecta la estructura del proyecto. El pensamiento caro. Usarlo conscientemente con `/model`. |
| **Sonnet** | Escribir y refactorizar código; generar scripts y herramientas; cargar datos al `kb/`; documentación; tareas de implementación con dirección clara. El caballo de trabajo. |
| **Haiku** | Tareas puramente mecánicas: correr scripts y reportar salida, convertir formatos, renombrar, aplicar cambios repetitivos. Sin razonamiento real requerido. |

Regla práctica: empezá en Sonnet. Subí a Opus sólo cuando el problema
requiera razonamiento de primer principio o hay ambigüedad real sobre qué
hacer. Bajá a Haiku cuando la tarea es ejecutar, no decidir.

---

## Selección de effort

- **Alto**: Primera investigación de un dominio nuevo; decisiones de
  arquitectura; análisis de un ejecutable desconocido; cualquier cosa donde
  una conclusión equivocada cuesta horas.
- **Medio**: Implementación siguiendo un método ya establecido; refactoring;
  documentar hallazgos; debugging con hipótesis clara.
- **Bajo / mínimo**: Tareas mecánicas con pasos definidos; aplicar un parche
  ya diseñado; correr un script y reportar el resultado.

Ajustá con `--effort` o el equivalente en la sesión. No uses effort alto por
defecto; es caro y lento para tareas que no lo justifican.

---

## Optimización de contexto

- **Leé sólo lo que necesitás.** `CLAUDE.md` + `ESTADO_ACTUAL.md` primero.
  El resto, bajo demanda.
- **No pegues volcados crudos en el chat.** Los dumps de memoria, hexdumps,
  logs largos van a archivo y se referencian por ruta y offset.
- **`kb/` es la fuente de verdad**, no el chat ni los comentarios de código.
  Si hay contradicción, `kb/` gana y hay que actualizar lo que esté mal.
- **Un documento a la vez.** Leer los cuatro archivos "por las dudas" quema
  el contexto que hace falta para razonar el problema difícil.
- **Limpiá al final de turno.** Si el turno generó datos intermedios en el
  chat, resumilos en el archivo correcto antes de cerrar.

---

## Memoria

El repo es la única memoria real. El chat no persiste entre sesiones.

| Archivo | Función |
|---------|---------|
| `ESTADO_ACTUAL.md` | Estado operativo compacto. Se lee primero, entero, siempre. |
| `sesiones/HANDOFF.md` | Paquete de traspaso sesión a sesión. Se sobreescribe cada cierre. |
| `kb/*.json` | Verdad del proyecto: hechos confirmados, con evidencia y confianza. |
| `docs/bitacora.md` | Historia: cómo se llegó a cada cosa, qué no funcionó. |

Regla: si algo no está en alguno de esos archivos, no existe para la próxima
sesión. Anotar es parte de encontrar.

---

## Evidencia

- **`confirmado`** significa una sola cosa: se escribió el valor / aplicó el
  cambio y se vio el efecto en pantalla (o el output real). Nada más cuenta.
- **`hipotesis`** es una observación útil, no una afirmación.
  "Probablemente sea la vida máxima" → `hipotesis`. "Es la vida máxima" sin
  haberlo verificado → mentira que después cuesta horas desarmar.
- Toda entrada de `kb/` lleva `confianza` (confirmado / probable / hipotesis)
  y `evidencia` (cómo se verificó, link al commit o sesión).
- **Anotar las versiones.** NTSC-U y PAL no comparten direcciones. Sin
  `version_activa` en `kb/objetivo.json`, nada tiene sentido.

---

## Investigación

Protocolo para investigar algo desconocido:

```
OBJETIVO claro
↓
HIPÓTESIS mínima (la más simple que explica el síntoma)
↓
EXPERIMENTO controlado (un cambio a la vez)
↓
EVIDENCIA registrada (en archivo, no en el chat)
↓
CONCLUSIÓN: confirmado / refutado / ambiguo
↓
Si ambiguo: nueva hipótesis. Si confirmado: actualizar kb/.
```

Reglas adicionales:
- Una hipótesis a la vez. No probar dos cambios simultáneos.
- Documentar los fracasos con la misma precisión que los éxitos.
- No asumir que algo funciona porque "debería". Verificar.
- Si la herramienta da un resultado inesperado, entender por qué antes de
  descartar el resultado.

---

## Subagents

- **Explore**: búsqueda rápida en el codebase — patrones de archivo, símbolos,
  keywords. Úsalo antes de leer archivos a ciegas.
- **Agent (general)**: tareas independientes que no dependen del contexto
  actual — investigación paralela, análisis de un archivo grande, tarea
  larga que no necesita el hilo principal.
- **Plan**: diseño de implementación antes de empezar. Úsalo cuando la
  tarea tiene más de 3 archivos afectados o dependencias no obvias.

Reglas:
- No delegues síntesis. El subagent investiga; tú decidís.
- No dupliques trabajo: si delegaste la búsqueda, no la repitas tú también.
- Los subagents empiezan sin contexto de la conversación — el prompt tiene
  que ser autocontenido.
- Background por defecto. Foreground sólo cuando el próximo paso depende
  del resultado del subagent.
- **Perspectivas diversas.** Cuando hay más de un enfoque razonable para una
  decisión (arquitectura, estrategia de debugging, diseño de una función),
  lanzar 2-3 Agents en paralelo con el mismo problema en vez de decidir en
  base a una sola pasada. Comparar resultados y quedarte con la mejor
  combinación — no promediar ciegamente.

---

## Handoff

El handoff es el contrato entre esta sesión y la próxima. Sin él, la próxima
sesión arranca de cero.

`sesiones/HANDOFF.md` debe incluir siempre:

```
OBJECTIVE       — qué se estaba haciendo y por qué
CURRENT STATE   — dónde quedó exactamente
CONFIRMED FACTS — verdades ya establecidas (con referencias a kb/)
NEXT ACTION     — comando exacto o paso preciso para retomar
DO NOT REPEAT   — enfoques fallidos que no vale la pena reintentar
TOOLS/ENV       — qué herramientas y entorno se necesitan
MODEL REC       — qué modelo conviene para la próxima tarea
EFFORT REC      — effort recomendado
```

Se sobreescribe al final de cada sesión relevante. No es historial — para
eso está la bitácora.

---

## Cambio de sesión

Checklist antes de cerrar cualquier sesión:

1. `kb/` actualizado con todo lo que se averiguó.
2. Entrada nueva en `docs/bitacora.md` (fecha + qué se hizo + qué falló).
3. `ESTADO_ACTUAL.md` refleja el estado real.
4. `sesiones/HANDOFF.md` escrito o actualizado.
5. `git add` sólo los archivos relevantes (no binarios, no volcados).
6. `git commit` con mensaje descriptivo.
7. `git push`.

Sin esos 7 pasos, la próxima sesión pierde trabajo.

---

## Control de costos

- **Sonnet por defecto.** No pedir Opus sin razón concreta.
- **Contexto mínimo.** No cargar documentos "por las dudas".
- **Un modelo por tipo de tarea.** No cambiar de modelo en medio de una tarea
  mecánica.
- **Effort apropiado.** Effort alto consume más — usarlo sólo cuando el costo
  de equivocarse es alto.
- **Subagents con propósito.** Cada spawn tiene overhead — no spawnar para
  tareas que se resuelven con un Grep.
- **Checkpoint temprano.** Si la tarea es larga, definí un checkpoint mínimo
  y parás ahí. No intentar hacer todo en una sola sesión.

Patrón de checkpoint:
```
OBJETIVO → CAMBIOS MÍNIMOS → VERIFICACIÓN → COSTO → BENEFICIO → STOP
```

---

## Verificación

- Verificar en el entorno real, no sólo en revisión de código.
- Si la tarea afecta una herramienta, correrla y mirar el output.
- Si la tarea afecta comportamiento en vivo (PCSX2, PINE, debugger),
  confirmar en la máquina real — no asumir que el código es correcto.
- Type checking y test suites verifican correctitud de código, no
  correctitud de features. Si no podés correr la herramienta, decilo.
- Antes de declarar una tarea terminada:
  1. ¿El cambio hace lo que se pedía?
  2. ¿No rompió nada adyacente?
  3. ¿Está commiteado?

---

## No repetición

La sección `DO NOT REPEAT` del handoff es obligatoria cuando algo falló.

Principios:
- No re-derivar lo que ya está en `kb/` como confirmado.
- No re-intentar un enfoque que ya falló sin una razón nueva.
- No asumir lo que ya se documentó como falso suposición.
- Si algo "debería funcionar" pero no funcionó antes, buscar primero en la
  bitácora por qué.

Cuando algo falla, el trabajo no termina al constatar el fallo — termina
cuando se entiende la causa raíz y se documenta para que no vuelva a pasar.

---

## Automatización

Automatizar (dejar que un script, hook o subagent corra sin revisión humana
en el medio) sólo cuando se cumplen las dos condiciones a la vez:

- La tarea **no requiere criterio** ("taste") — es mecánica y el resultado
  correcto es objetivamente verificable.
- Un resultado **"80% bueno" es aceptable** si algo sale mal. Si una falla
  silenciosa cuesta caro (plata, datos, horas de debugging, un commit
  irreversible), no se automatiza sin un punto de revisión humana.

Si no se cumplen las dos, el camino correcto es **aumentar el proceso con
IA, no reemplazarlo**: la persona sigue decidiendo, Claude prepara el
terreno (borradores, análisis, opciones comparadas) pero no ejecuta la parte
que requiere criterio.

---

## Capturar aprendizajes como skill

Cuando una conversación resuelve un problema de un tipo que va a volver a
aparecer, convertirla en skill reusable con `skill-creator` en vez de repetir
la misma explicación a mano la próxima vez. Todo skill nuevo debe incluir una
sección de **gotchas** (errores encontrados durante el desarrollo y cómo se
evitaron) para que la próxima ejecución no los repita — ver el patrón de
"No repetición" arriba.
