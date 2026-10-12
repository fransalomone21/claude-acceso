# T20 — la ley de cero divergencias: cada dato con un dueño

**Diseño, 2026-10-12** (sesión de T14). Fase 7, tipo D: el cambio queda escrito antes de tocar nada vivo; se
construye en la sesión siguiente. Padres: **L0-05** y **L1-06** de `docs/10-requisitos.md` (N-06, Fran: «0 divergencias
como ley transversal»; «debe ser lo más cuidado»). Retoma **T2** del diagnóstico del 2026-09-28 §3 («un dueño por
dato»), diseñado y nunca construido. Defectos: **DA-017** (un dato en N lugares), **DA-012** (números a mano),
**DA-036** (identificadores que colisionan).

## 1. El problema, medido

| Dato | Dónde vive hoy | Divergencia medida |
|---|---|---|
| Orden de lo que sigue (T-n) | `docs/lluvia-de-ideas-2026-10-12.md` §6, `ESTADO_ACTUAL.md`, `RETOME.md`, `HANDOFF.md`, `docs/diagnostico-2026-09-28.md` §3 | **viva al abrir esta sesión**: ESTADO dice T14 → T17 → T15…, la lluvia §6 dice T14 → T20 → T19 → T17…; el diagnóstico todavía tiene T2 en el camino crítico (hoy T20) |
| Fase en curso | `PDP.md` §4 («Fase en curso»), su fila de la tabla, la primera línea de `ESTADO_ACTUAL.md`, retomes | medida el 2026-09-28: el PDP decía 6 y el ESTADO 7; el hook leía el PDP (A3) |
| Estado de cada proyecto | fila del enrutador, ESTADO, HANDOFF, PDP, bitácora, retomes | 11 proyectos atrasados por git el 2026-09-28 (A3); la fila del enrutador ya no copia la fase (T12) |
| Conteos (lecciones, defectos, expuestos) | prosa de ESTADO, HANDOFF, retomes, insumos; las herramientas | DA-012: «186 lecciones» con 204; «45 contra 76». Los defectos ya son vista generada (`DEFECTOS-ARQUITECTURA.md`) |
| Qué es un PDP válido / el tipo de fase | `fase_activa.py` y `medir-fase.py` | dos definiciones que no coinciden (A3); la puerta ya importa la de `fase_activa` (T13) |
| Rutas locales | contratos, `fuentes/RUTAS.md`, `"locales"` del catálogo | insumo 2026-09-29 (4): cuatro documentos en tres repos, una ya mal antes de la mudanza; ningún medidor las ejecuta |
| Identificadores | «A1» del diagnóstico y «A1» de `arquitectura.md` | DA-036 |
| (el mismo orden, otra vez) | el contrato del proyecto, al indexar la lluvia | **cometida al escribir este diseño**: el índice copió el orden entre paréntesis y se corrigió a puntero en el mismo turno. Sin medidor, la ley depende de que la sesión se dé cuenta |

## 2. La distinción que hace medible la ley

No toda repetición es una divergencia. Tres clases, y la ley se aplica distinto a cada una:

1. **Dato vigente**: dice cómo está el mundo AHORA («Fase N abierta», «sigue T-n», «N abiertos»). Tiene **un dueño**;
   cualquier otra aparición es **vista generada** del dueño o **puntero** al dueño (nombra el lugar, no el valor).
2. **Medición fechada**: dice cómo estaba en un momento («al cerrar de44da9d: 48 abiertos»). Es historia, no
   diverge con el tiempo: va con su fecha o su sesión pegada, y vive en bitácora, HANDOFF o el insumo.
3. **Cita de un ID**: nombra un dato por su identificador (`L2-PTA-04`, `DA-045`). Es puntero por construcción; lo que
   se mide es que el ID **exista** en su dueño (ya lo hace la auditoría con los requisitos) y que no colisione.

Sin esta distinción el medidor da rojo sobre cada retome (los retomes están hechos de mediciones fechadas), y un
freno con falsos positivos es menos seguro: se apaga.

## 3. Primero qué se SACA

| Copia | Qué pasa a ser | Dueño |
|---|---|---|
| Primera línea de `ESTADO_ACTUAL.md` con la fase | se saca: la fase la inyecta la compuerta al leer el proyecto | `PDP.md` §4, «Fase en curso» |
| Orden de T-n en ESTADO, HANDOFF y RETOME | puntero («el orden: lluvia §6») | `docs/lluvia-de-ideas-2026-10-12.md` §6 |
| Camino crítico del diagnóstico §3 | nota de reemplazo al pie de la tabla: «vigente: lluvia §6; T2 es T20» | ídem |
| Conteos sin fecha en prosa | medición fechada («al cerrar X: …») o puntero al comando | la herramienta que cuenta |
| `medir-fase.py` con su tabla de tipos | importa la de `fase_activa.py` | `fase_activa.py` |
| Rutas locales escritas en N documentos | TBR: inventario en la sesión de construcción; candidato a dueño, `"locales"` del catálogo, que la puerta ya lee | — |
| Prefijo `A` de `arquitectura.md` | renombrar con prefijo propio (DA-036) | — |

**Lo que la construcción encontró (2026-10-12, sesión de construcción), antes de tocar nada vivo:**

- **La línea de fase del ESTADO tiene un lector:** `cascada.ps1` (bloque «ESTADO — las dos fuentes») la busca para
  imprimir `proyecto :`. Sacarla sola deja ese contraste ciego (imprimiría la primera línea que diga «fase»). Cambio:
  `cascada.ps1` toma la fase del **dueño** llamando a `fase_activa.py <ruta>` (la misma pieza que la compuerta; un
  tercer parser de `**Fase en curso:**` sería otra copia de la definición) y cae a la heurística del ESTADO sólo si
  el PDP no declara la fase. Si las dos dicen cosas distintas, manda el PDP. Caso nuevo en `probar-cascada.ps1`,
  visto en rojo con el `cascada.ps1` viejo.
- **`medir-fase.py` no tiene tabla de tipos** (medido: sólo mide el campo «Cómo se certifica» de P4). La copia de la
  tabla que el diagnóstico de A3 veía ya no existe: la puerta (T13) y `medir-fases.py` importan `fase_activa`. Lo que
  queda es su criterio de «esto es un PDP» (`Las fases` o `**Fase en curso`), que mide otra cosa (P4, migración del
  molde) y no se toca: cambiarlo cambia qué PDP cuenta, no saca una copia.
- **Rutas locales, inventario (el TBR):** medido el 2026-10-12 con Grep sobre `*.md` y `*.json` de claude-acceso: 150
  rutas absolutas del usuario en 53 archivos y 28 con `~/Desktop` en 18. La mayoría son fechadas (auditorías,
  bitácoras, predicciones, HANDOFF) o propias de otro proyecto (`black/kb/ubicaciones.json` es dueño de las suyas).
  Las vigentes con más de una copia son las carpetas de materia: `"locales"` del catálogo (6 entradas), los
  `fuentes/RUTAS.md` (física espacial 16, taller 1) y los contratos (apunte-iise 7, minecraft 3, software de vuelo
  1). Dueño propuesto: `"locales"` del catálogo; los otros, punteros. **No se migra en esta sesión**: toca contratos
  de otros proyectos (cada uno con su puerta) y lo que falta primero es un medidor que **ejecute** las rutas
  (existen en el disco), que hoy no existe. Queda TBR, con el inventario hecho.

## 4. El medidor

`herramientas/divergencias.py` (nombre TBR) sobre un registro `datos.json`: cada dato vigente con su **dueño**
(archivo + extractor) y sus **copias declaradas** (archivo + extractor + clase: vista o puntero).

- **Vista**: el valor extraído de la copia tiene que ser igual al del dueño → si difiere, **ROJO** con los dos valores.
- **Puntero**: la copia no puede contener el valor, sólo el nombre del lugar → si lo contiene, **ROJO**.
- **Falla cerrado**: un extractor que no encuentra nada en el dueño es ROJO (el dato se mudó o el extractor está
  viejo), nunca verde. El registro que no parsea es ROJO.
- **Las copias no declaradas** (el universo es abierto: no se pueden enumerar) se buscan por **patrón del dato
  vigente** fuera de su dueño (p. ej. «Fase \d+ ABIERTA»), salvo que la línea lleve fecha o sesión (medición
  fechada). Esto es una heurística: **informa, no frena**, igual que L2-CMP-03.
- Corre en la capa rápida de `chequeo-completo` y en el arranque; el ROJO sale con el dato, el dueño y la copia.

**Precisiones de la construcción (2026-10-12), escritas antes del código:**

- **Dónde:** `divergencias.py` en la raíz de claude-acceso (al lado de `auditar-sesion.py`) y el registro en
  `.claude/datos.json` (al lado del catálogo de la puerta). Los datos que mide viven en este repo, no en el perfil.
- **Qué es «fechado», medible:** el markdown se escribe en párrafos envueltos a ancho fijo, así que la fecha va en la
  primera línea del párrafo y no en cada línea. Un **bloque** (líneas seguidas sin renglón vacío) es Medición_Fechada
  si su primera línea lleva una fecha (`2026-10-12`, `12/10`) o una sesión o commit (7-8 hexadecimales con al menos
  un dígito y una letra, con o sin comillas invertidas). Un título con fecha (`## 2026-09-28 — …`) fecha su sección
  hasta el próximo título de su nivel o más alto. Un archivo con fecha en el nombre (`diagnostico-2026-09-28.md`) es
  fechado entero. (Primera corrida sobre el ESTADO real: tres rojos; uno estaba bajo un título fechado —de ahí esta
  regla— y los otros dos eran copias vigentes viejas de verdad: «Siguiente: T2» y la sección «Lo que FALTA».)
- **El puntero tiene que nombrar al dueño:** una Copia_Puntero que ya no nombra el Archivo_Dueño es ROJO (el registro
  quedó viejo: falla cerrado), igual que una copia declarada cuyo archivo no existe.
- **El extractor de la fase no es un regex nuevo:** es `fase_activa.fase_abierta` importado (la misma definición que la
  compuerta, la puerta y `medir-fases.py`).
- **ROJO** sale como línea `[FAIL]`, que es lo que `chequeo-completo` copia al tablero; la heurística de L2-DIV-04 sale
  como `[aviso]` y no cambia el código de salida. Tres resultados: 0 verde, 1 rojo, 2 reventó.

**Saboteador** (`probar-divergencias.py`): árbol sintético con (a) copia vista divergente → ROJO en su caso; (b) puntero
que copia el valor → ROJO; (c) extractor que no encuentra al dueño → ROJO; (d) control positivo parecido al real: un
retome lleno de mediciones fechadas y punteros → verde; (e) mutante sin la comparación → (a) da verde y se ve.

## 5. Requisitos L2 (elemento DIV)

Viven en su dueño: [`10-requisitos.md`](10-requisitos.md) §5, L2-DIV-01 a L2-DIV-05, con sus términos definidos y su
rationale (pasados en la sesión de construcción, que leyó el concepto `requisitos`). Acá no se copian.

## 6. Riesgo y lo que no se hace

- **Riesgo:** el registro mismo es un mecanismo compartido (Saltzer, *least common mechanism*): se chequea antes de
  que el medidor lo lea, y falla cerrado.
- **No se hace:** reescribir las copias a mano (escalón de parámetro); vencer las mediciones fechadas; frenar por
  copias no declaradas (heurística).
- **Orden de construcción:** primero lo que se saca (§3), después el medidor con su saboteador en rojo, después el
  registro con los datos de §1; `chequeo-completo` en verde; `defectos.py arreglar` DA-017, DA-012, DA-036.
