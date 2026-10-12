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

1. **Dato vigente**: dice cómo está el mundo AHORA («Fase 7 abierta», «sigue T20», «48 abiertos»). Tiene **un dueño**;
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

**Saboteador** (`probar-divergencias.py`): árbol sintético con (a) copia vista divergente → ROJO en su caso; (b) puntero
que copia el valor → ROJO; (c) extractor que no encuentra al dueño → ROJO; (d) control positivo parecido al real: un
retome lleno de mediciones fechadas y punteros → verde; (e) mutante sin la comparación → (a) da verde y se ve.

## 5. Requisitos L2 propuestos (elemento DIV)

Borrador: entran a `docs/10-requisitos.md` en la sesión de construcción, que lee el concepto `requisitos` de la
puerta; desde ahí esta sección queda como puntero.

| ID | Padre | Requisito | Verificación |
|---|---|---|---|
| L2-DIV-01 | L1-06 | Cuando cada copia vista declarada difiere del valor del dueño, el verificador de divergencias deberá dar ROJO con el dato, el dueño y la copia. | ensayo: caso (a) del saboteador |
| L2-DIV-02 | L1-06 | Cuando cada copia puntero declarada contiene el valor del dueño, el verificador de divergencias deberá dar ROJO. | ensayo: caso (b) |
| L2-DIV-03 | L1-06 | Cuando el extractor del dueño devuelve un resultado vacío, el verificador de divergencias deberá dar ROJO. | ensayo: caso (c) |
| L2-DIV-04 | L1-06 | Cuando cada línea fuera del dueño coincide con el patrón de cada dato vigente sin fecha ni sesión, el verificador de divergencias deberá listar la línea como copia ausente del registro. | ensayo: caso del saboteador con control positivo (d) |
| L2-DIV-05 | L0-05 | El registro de datos deberá asignar a cada dato vigente un único archivo dueño. | inspección: el verificador da ROJO ante dos dueños |

## 6. Riesgo y lo que no se hace

- **Riesgo:** el registro mismo es un mecanismo compartido (Saltzer, *least common mechanism*): se chequea antes de
  que el medidor lo lea, y falla cerrado.
- **No se hace:** reescribir las copias a mano (escalón de parámetro); vencer las mediciones fechadas; frenar por
  copias no declaradas (heurística).
- **Orden de construcción:** primero lo que se saca (§3), después el medidor con su saboteador en rojo, después el
  registro con los datos de §1; `chequeo-completo` en verde; `defectos.py arreglar` DA-017, DA-012, DA-036.
