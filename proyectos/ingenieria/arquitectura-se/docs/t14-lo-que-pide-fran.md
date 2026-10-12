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
