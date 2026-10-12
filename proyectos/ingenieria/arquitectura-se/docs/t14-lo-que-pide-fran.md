# T14 — la puerta infiere el proyecto sólo de lo que escribe Fran

**Diseño, 2026-10-12** (sesión de arquitectura `de44da9d`). Fase 7, tipo D: el cambio queda escrito antes de tocar
la puerta. Se construye **después** de que la búsqueda de defectos (`docs/hallazgos-2026-10-12.md`) lo confirme y la
priorización lo ponga primero; si los escépticos lo refutan, este documento queda como descartado y dice por qué.

## 1. El problema, medido

La puerta (`.claude/hooks/cascada_puerta.py`, `prompt()` e `inferidos_de()`) busca las señales de cada proyecto en
el texto ENTERO del pedido. En la sesión `de44da9d` negó dos veces una acción de este proyecto por un proyecto que
Fran nunca pidió:

| Hora | Texto que disparó | De dónde venía | Salida |
|---|---|---|---|
| 03:1x | «BLACK» | el retome pegado de esta sesión, escrito por el propio método (`RETOME.md` nombra BLACK como dato de línea de base) | `-Excepcion` registrada |
| 09:3x | «telescopio» | la notificación automática del workflow del mapa (`<task-notification>`) | `-Excepcion` registrada |

**Lo que recibe el hook, medido por el transcript** (`probable`: el hook recibe el mismo texto que guarda el
transcript): el mensaje de Fran guarda lo pegado entre `<pasted_content id="…">…</pasted_content>` (5 apariciones en
el transcript de esta sesión) y las notificaciones entre `<task-notification>…</task-notification>` (11).

## 2. La corrección

**Modificar, no agregar** (Saltzer, economía de mecanismo): antes de buscar señales, `prompt()` saca del texto los
bloques entre las etiquetas `pasted_content`, `task-notification` y `system-reminder`. Nada más cambia: las señales,
la regla de las débiles (lección 372) y la persistencia de lo inferido quedan iguales.

**Por qué alcanza:** lo pegado (un retome) actúa sobre rutas del proyecto, y la puerta las ve por la RUTA (`directo`),
no por la palabra; lo automático no es un pedido de Fran. Lo que la inferencia por pedido existe para atajar —el caso
de la lección 331, un ejercicio tipeado sin ruta y guardado en Documentos— es texto tipeado, y sigue cubierto.

**Riesgo que queda, declarado:** Fran pega el retome de un proyecto y la primera acción de la sesión cae FUERA de las
carpetas del proyecto y de sus carpetas locales. Lo cubre el propio retome (su paso 1 es `cascada.ps1`) y la
auditoría (P2 da rojo si se actuó sin declarar). Lo que no se hace: vencer lo inferido por turno (abriría el caso 331
entre turnos).

## 3. Requisito

L2-PTA-04 en `docs/10-requisitos.md`.

## 4. Verificación planeada

- **Autotest de la puerta, caso 17:** pedido con una señal FUERTE adentro de `<pasted_content>` + Write fuera de todo
  proyecto → pasa; la misma señal adentro de `<task-notification>` → pasa; la misma señal TIPEADA fuera de las
  etiquetas → deny (el 331 sigue frenando); la señal fuera Y adentro → deny (lo tipeado manda).
- **Mutante:** sin el recorte, el caso pegado vuelve a negar; tiene que verse en SU caso.
- **Efecto real:** la próxima notificación automática que nombre un proyecto no deja un evento `infiere` en el estado
  de la sesión (`cascada_puerta.py --estado <sid>`).

## 5. Construido y medido (2026-10-12, sesión `814911bc`)

**Commit `e6d58bb`** (claude-acceso); DA-045 **arreglado** con `defectos.py` (`f684f73` en perfil-global), falta
validarlo con 3 sesiones auditadas.

- **Lo que cambió:** `AJENO` y `sin_ajeno()` en `.claude/hooks/cascada_puerta.py`; `prompt()` infiere sobre
  `sin_ajeno(prompt)`. Un bloque **sin cierre no se recorta** (falla cerrado: frena de más, nunca de menos). Y
  `python …fase_activa.py <ruta>` entró a `LECTURA` (sólo con un argumento que no empiece con `-`: sin argumento lee
  stdin y con `--autotest` escribe temporales).
- **Autotest, caso 17:** 3 controles (señal fuerte en `pasted_content`, `task-notification`, `system-reminder` → pasa),
  3 sabotajes (tipeada → deny, el 331 sigue; tipeada y pegada → deny; bloque sin cierre → deny), 2 mutantes vistos en
  su caso (sin el recorte; recortar sin cierre) y la compuerta como lectura pura (con su sabotaje encadenado). Autotest
  entero **BIEN**. Un primer rojo del segundo mutante era del **autotest**, no de la puerta: el mutante reusaba la
  sesión del caso real, que ya tenía el proyecto inferido (el estado persiste); cada script corre ahora en su sesión.
- **Saboteador** [`probar-t14.py`](../probar-t14.py): 3 mutantes en copia (el recorte, la etiqueta `task-notification`,
  la compuerta en `LECTURA`), cada uno visto en su caso.
- **Efecto real:** en esta sesión, un comando en segundo plano cuya descripción nombraba al telescopio; llegó su
  notificación y `--estado` no muestra `telescopio` en `inferidos`. Control: el mismo texto sin recortar infiere
  `telescopio` (`inferidos_de` directo). `probable` que el hook recibió ese texto exacto (lo que guarda el transcript).
- **`chequeo-completo`:** un solo rojo, «listo para la nube», por los dos archivos sin commitear; verde al commitear.

**Lo que T14 NO cubre, medido al abrir esta misma sesión:** la puerta la frenó por `puntero` (señal **débil** de
software-de-vuelo) en el retome que Fran mandó como mensaje, no como bloque pegado. No cedió porque **arquitectura-se no
tiene señal fuerte en el catálogo** (5 de 22 proyectos sin ninguna): si la tuviera, la débil cedería ante su nombre
(lección 372). Salida de hoy: `-Excepcion` con motivo. Darle una señal fuerte es cambiar un freno (regla 6): queda para
decisión de Fran, en el HANDOFF.
