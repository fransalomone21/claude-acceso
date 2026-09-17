# PDP — arquitectura de ingeniería de sistemas

**Abierto:** 2026-09-16. **Naturaleza:** ingeniería.

## 1. El problema

La arquitectura de trabajo actual (cascada de 6 niveles, PDP, naturalezas,
cuadro de fase, frenos) creció por acumulación: cada pieza resolvió un fallo
real y quedó. Funciona, y las necesidades que la generaron **siguen vigentes y
no se negocian**. Pero nunca se la contrastó contra el cuerpo formal de
ingeniería de sistemas, y tiene huecos que se sienten sin poder nombrarse.

**El hueco que sí se pudo nombrar,** leyendo el handbook: no hay **matriz de
cumplimiento**. Las naturalezas (`ingenieria` / `documentos` / `seguimiento`)
tipifican el proyecto pero no declaran, producto por producto, qué se exige,
qué se tailorea y qué no aplica — ni con qué justificación. Es una etiqueta,
no un contrato. NASA resolvió exactamente esto en el cap. 3.11 (p. 34-42):
tipos A-F + Matriz de Cumplimiento con rationale por línea, adjunta al SEMP.

Y el mecanismo correcto **ya está inventado en este repo, dos veces**:
`.claude/datos-permitidos.json` y `.claude/apuntes-publicos.json` son
deny-by-default con excepción declarada y motivo al lado. Falta aplicárselo
al método mismo.

## 2. Qué se produce

1. La **ficha destilada** de cada fuente, con anclas verificables (capa 2 del
   protocolo de `perfil-global/pilares/README.md`).
2. El **pilar** foldeado de cada una: sólo lo que cambia una decisión.
3. La **arquitectura nueva**: matriz de cumplimiento del método, tipificación
   de proyectos, y el ciclo de vida con puertas y criterios de salida.
4. La **migración** de lo vivo (`CLAUDE.md`, `cascada.ps1`, plantillas,
   naturalezas) y sus medidores.

## 3. Qué NO se produce

- Ceremonia. El propio handbook manda tailorear (p. 34): aplicar esto entero a
  un proyecto de una persona es malinterpretarlo. Cada requisito que entre
  lleva escrita su justificación de por qué entra.
- MBSE / SysML. Es herramienta buscando problema hasta que la arquitectura
  esté decidida.
- Nada que no se pueda medir con un script.

## 3 bis. El rigor, POR ASPECTO

> **El tailoring se aplica por aspecto, no por proyecto** (NASA p. 39). Esta
> tabla reemplaza al campo «Criticidad» del molde viejo, que se declaraba una
> vez para el proyecto entero. Es la pieza **P3**.

| # | Aspecto | Reversibilidad | Incertidumbre | Rigor |
|---|---|---|---|---|
| **a** | Las fichas de lectura (`pilares/`) | se rehace: el libro sigue ahí | alta al empezar cada libro | iterar y medir |
| **b** | El diseño de la arquitectura (fase 5) | se rehace: no toca nada vivo | alta | iterar y medir |
| **c** | La migración (fase 6) | git revierte, pero un método roto se arrastra sesiones | baja: la matriz ya dice qué migrar | **pleno** |
| **d** | Las herramientas de medición (`verificar-*.py`) | se rehace | media | pleno en el saboteador, mínimo en el resto |

**El aspecto `c` es el único de rigor pleno, y es el que está en curso.** Eso
es P3 funcionando: el mismo proyecto no lleva el mismo rigor de punta a punta,
y el tramo que no perdona se declara antes de empezarlo, no después.

## 4. Las fases, y QUÉ CIERRA CADA UNA

El criterio de salida es un **resultado verificable**, nunca una cantidad de
trabajo hecho. Una fase por chat.

| # | Fase | Qué la cierra | Cómo se certifica | Estado |
|---|---|---|---|---|
| **0** | **Leer el handbook NASA** | **CERRADA 2026-09-16.** 15/17 tramos destilados con anclas en `perfil-global/pilares/nasa-seh/`, medidor de citas corriendo, 8 fuentes indexadas con MD5 | `verificar-citas.py` sobre los 17 destilados | `cerrada` |
| **1** | **Cerrar la base documental y medirla de verdad** | **CERRADA 2026-09-16.** 17/17 tramos; `verificar-citas.py` depurado (5 defectos suyos, hallados auditando 77 fallos a mano), saboteado con `probar-verificar-citas.ps1`, y re-medido: **1424/1437 (99,1%)**, con los 13 fallos que quedan clasificados uno por uno | `verificar-citas.py` ≥ 99 %, y `probar-verificar-citas.ps1` en verde | `cerrada` |
| **2** | **Requisitos: INCOSE GtWR** | **CERRADA 2026-09-16.** Ficha con las 41 reglas y las 14 características ancladas a página impresa (`pilares/incose-gtwr/reglas.md`, citas **74/74**), **y** el chequeo mecánico `verificar-requisito.py`: cubre **32 de las 41**, declara las 9 que no con el motivo (`--cobertura`), y su saboteador exige rojo regla por regla **más** cero falsos rojos sobre 17 ejemplos que el libro marca como aceptables | `verificar-requisito.py --cobertura` lista las 41, y `probar-verificar-requisito.ps1` exige rojo regla por regla | `cerrada` |
| **3** | **Marco e híbrido: INCOSE SEH 5.ª ed.** | **CERRADA 2026-09-17.** `pilares/incose-seh/mapeo-15288.md`: el mapeo de los 17 procesos de NASA contra los 30 del ISO/IEC/IEEE 15288 (2023), proceso por proceso, con **10 filas que no son 1:1** explicadas en las dos direcciones; y lo que INCOSE tiene y NASA no, con el ciclo iterativo/ágil en cuatro capas separadas. Citas **73/73**, ancla `impresa = PDF − 25` medida por **dos caminos** (321 encabezados + 41 de 41 entradas del índice), saboteador en verde | el medidor de citas sobre la ficha del SEH, y el ancla por **dos** caminos | `cerrada` |
| **4** | **Forma: Rechtin & Maier** | **CERRADA 2026-09-17.** `pilares/rechtin-maier/heuristicas.md`: las heurísticas de arquitectura que aplican a un sistema de trabajo de **una** persona, **cada una con su caso propio ya vivido** del repo — 10 tareas de la taxonomía del libro, más las 4 que el propio libro nombra como las más aplicables, más las meta-heurísticas de generación/aplicación contrastadas contra `lecciones.jsonl`, más la tabla de **las que NO entraron y por qué**. Citas **99/99** (87 por el medidor, 12 cortas a mano tras auditar el denominador), ancla `impresa = PDF − 27` **constante**, medida por **dos caminos** (422 encabezados sin excepción + 191 de 191 del índice), saboteador en verde | el medidor de citas sobre la ficha de Rechtin, y el ancla por **dos** caminos | `cerrada` |
| **5** | **Diseñar la arquitectura nueva** | **CERRADA 2026-09-17.** Los tres artefactos en `docs/`: [`arquitectura.md`](docs/arquitectura.md) (10 piezas P1-P10 contra **14** defectos medidos, cada pieza con su página de fuente y su medidor), [`trade-study.md`](docs/trade-study.md) (3 alternativas, **criterios mandatorios separados de los ponderados y escritos antes de puntuar**; la primera pasada salió inconclusa —610 contra 630— y se rehicieron las **definiciones**, no los pesos, según Rechtin p. 402 y NASA p. 169-170; resultado B 810 / A 430 / C 400, con el ranking probado robusto contra la incertidumbre dominante) y [`matriz-cumplimiento.md`](docs/matriz-cumplimiento.md) (molde + selector de rigor por aspecto + la instancia de este proyecto: 38 filas, 3 recortadas con su resta escrita). Ningún archivo vivo tocado. **D14 se descubrió midiendo**: `verificar-requisito.py` da 13 de 13 falsos positivos sobre requisitos en español | los tres archivos existen en `docs/` y `medir-matriz.py` lee la matriz sin filas sin resta | `cerrada` |
| 6 | **Migrar** | `chequeo-completo.ps1` en verde, **todos** los saboteadores corridos, y **un proyecto real ya migrado** a la matriz | `.\chequeo-completo.ps1` sale con código 0, y `medir-fase.py` cuenta al menos un PDP en `[OK]` | **`abierta`** |
| 7 | **Validar** (≠ verificar) | Una sesión real trabajada bajo la arquitectura nueva, con el costo medido contra la anterior | el medidor P10, que esta fase construye: *timely / affordable / predictable / comprehensive* (SEH p. 165-166), contra el costo por fase ya registrado en `ESTADO_ACTUAL.md` | `abierta` |

**Fase en curso:** 6 — Migrar.

**Qué la cierra, exactamente:** `chequeo-completo.ps1` sale con código 0 con
sus siete medidores, los diez saboteadores corren en verde, y al menos un
proyecto real tiene su matriz de cumplimiento en la sección 8 de su PDP.

**Cómo se certifica:** `.\chequeo-completo.ps1` (las dos capas) y
`python perfil-global\herramientas\medir-fase.py`, que tiene que contar al
menos un PDP en `[OK]`. Las corre la sesión, no Fran.

> **El medidor no es invariante bajo el error que busca, y está probado:**
> `probar-medidor-fase.ps1` lo pone en rojo con el campo vacío, con el
> comentario de la plantilla sin llenar y con una excusa en vez de un comando —
> y exige que **calle** ante un PDP todavía sin migrar. Sin esa última mitad,
> el chequeo nacería con ocho rojos que nadie puede arreglar hoy, y un chequeo
> que grita donde no corresponde se apaga.

**La fase también puede CANCELARSE, y eso no es un fracaso.**

Si la migración mostrara que la arquitectura nueva cuesta más por sesión que
la vieja, la fase 6 se cancela y **la fase 7 deja de hacer falta**: la
respuesta ya estaría medida, y sería volver al baseline. Eso es exactamente el
primer riesgo de la sección 5, y tenerlo como salida declarada es lo que
evita que se siga migrando para no dar el brazo a torcer.

**La fase 7 es la que hoy no existe en ninguna parte del método**, y es la
distinción más cara del handbook (p. 11): se puede verificar perfecto y fallar
la validación entera — construir con precisión la cosa equivocada. Todos los
verificadores del repo miden *cumplimiento con lo que escribimos*. Ninguno
mide *si sirvió*.

## 5. Riesgos, con disparador observable

| Riesgo | P×C | Disparador | Respuesta |
|---|---|---|---|
| La arquitectura nueva es más pesada que la vieja y se deja de usar | alta × alta | la fase 7 mide más costo por sesión que antes | volver al baseline; la matriz se recorta, no se explica mejor |
| El fan-out se come el límite del plan | **ya pasó** el 2026-09-16: 2,07 M tokens y un límite de 5 h en 6,6 min | cualquier propuesta de `Workflow` o `Agent` | de la fase 1 en adelante, **inline**. El fan-out se gastó donde el libro no entraba en una ventana; eso ya no vuelve a pasar |
| Destilados infieles, que se ven idénticos a los fieles | media × alta | `verificar-citas.py` por debajo de 90 % | no avanzar de fase hasta repararlo |
| Se reforma el método y se pierde lo que resolvía | media × alta | una necesidad vieja sin línea en la matriz nueva | cada freno actual entra a la matriz con su impacto original escrito, o no sale |

## 6. Fuentes

**Las diez**, con MD5, en `perfil-global/pilares/fuentes/INDICE.md`, y
`medir.py` las da **10/10 OK**. Douglass y Reinertsen, que faltaban cuando se
escribió esta sección, ya están —aunque todavía **sin leer**: la mitad *agile*
de la arquitectura se apoya, por ahora, sólo en el capítulo de INCOSE 5.ª ed.,
y eso está declarado.


## 8. Matriz de cumplimiento

> **Se mudó acá el 2026-09-17**, y estaba declarado: la instancia vivía en
> `docs/matriz-cumplimiento.md` con una excepción escrita —«la fase 5 no toca
> archivos vivos y el `PDP.md` de este proyecto lo es; se muda al `PDP.md` en
> la fase 6»—. Esta sección es esa excepción cerrada. **El molde, el selector
> de rigor y el porqué de cada mecánica siguen en
> [`docs/matriz-cumplimiento.md`](docs/matriz-cumplimiento.md)**: eso es
> documentación del método, y esto es la instancia de este proyecto.
>
> Lo mide `python perfil-global\herramientas\medir-matriz.py`: una fila
> `recortado` o `no aplica` sin su resta escrita sale en rojo en el arranque
> siguiente.

Reglas ancladas a su archivo fuente. Aspectos por la letra de §4.

### `~/.claude/CLAUDE.md` — las reglas del método

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| #1 evidencia con grado anotado | a, b, d | `cumple` | |
| #2 el éxito también se audita | a, d | `cumple` | |
| #3 toda alarma se prueba rompiéndola | d | `cumple` | |
| #3 toda alarma se prueba rompiéndola | b | **`cumple`** | **Era `recortado` y se pagó en la fase 6.** D14 arreglado: `verificar-requisito.py` tiene las listas del GtWR en español a la misma severidad, y los diez requisitos dan **0 VIOLA**. La condición de aceptación de dos mitades —y una tercera que apareció trabajando— quedó como control permanente de `probar-verificar-requisito.ps1`, así que no se puede volver a romper en silencio |
| #4 el repo es la memoria | a, b | `cumple` | |
| #5 checkpoint antes de parar | a, b | `cumple` | |
| #6 cambios mínimos | b | `cumple` | Ningún archivo vivo tocado en la fase 5 |
| #7 ubicar la intervención en la escala | b | `cumple` | La reforma es *regla* y *flujo de información*, no *parámetro* |
| #8 el modelo se enruta | a, b | `cumple` | |
| #9 el presupuesto del plan gana | b | `cumple` | |
| #9 el presupuesto del plan gana | a (**fase 0**) | **`recortado`, y se pagó** | La fase 0 gastó 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos. **La resta no se escribió en su momento** — se escribe ahora: compró la lectura de un libro que no entraba en una ventana de contexto, y costó una sesión de trabajo perdida. Las fases 1-4 se hicieron inline y no perdieron nada, así que **la resta salió negativa**: el recorte fue un error, no un tailoring. Fila de cierre: de la fase 1 en adelante, `cumple` |
| #10 cuadro PARA FRAN | b | `cumple` | |
| #11 cuadro de fase | b | `cumple` | |
| #12 mensaje de retome si el cuadro dice chat nuevo | b | `cumple` | |

### `CLAUDE.md` del repo — las cuatro reglas de la estructura

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| #1 un proyecto, una carpeta | b | `cumple` | |
| #2 un archivo, un repo dueño | a, b | `cumple` | `pilares/fuentes/` con los PDF gitignoreados, 10/10 medidos |
| #3 todo proyecto nace de un PDP | b | `cumple` | |
| #4 lo que el enrutador dice se verifica antes de repetirlo | b | `cumple` | La fila del enrutador se corrige en el mismo turno |

### `plantillas/naturalezas/ingenieria.md` — los cinco no negociables

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| #1 confirmado = intervine y vi el efecto | a, d | `cumple` | |
| #2 todo dato lleva su versión | a | `cumple` | Cinco libros, cinco anclas medidas, ninguna supuesta |
| #3 el repo es la memoria, se anota al confirmar | a, b | `cumple` | |
| #4 el éxito también se audita | a, d | `cumple` | |
| #5 nada de volcados crudos en el chat | a | `cumple` | |

### `plantillas/PDP.md` — el molde

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| §4 criterio de salida como resultado verificable | a, b | `cumple` | |
| §4 **cómo se certifica** el criterio | a, b | **`cumple`** | El campo existe en `plantillas/PDP.md` y este PDP lo usa. Pasó de `no aplica — todavía` a `cumple` el 2026-09-17, que es la transición que la fila anunciaba |
| §5 riesgos con disparador observable | b | `cumple` | |
| §6 decisiones, con las descartadas y por qué perdieron | b | `cumple` | [`trade-study.md`](docs/trade-study.md) §8 |
| §7 el verificador, ¿alguna vez falló? | d | `cumple` | Cuatro saboteadores, corridos hace 4 días, en verde |

### Las reglas que la arquitectura nueva agrega (P1-P10)

Se listan ahora para que la fase 6 no tenga que inventarlas, con el estado que
les corresponde **hoy**: ninguna está puesta, porque la fase 5 es de diseño.

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| P1 catálogo derivado, no copiado | b | **`no aplica` — todavía** | Diseñada y no construida. **La resta:** el catálogo compra que una regla no se pueda tailorear sin su porqué delante, y cuesta un generador que lea cuatro archivos fuente con formatos distintos. Se difiere porque las cuatro piezas que sí se instalaron esta fase (P2, P3, P4 y la mitad de P5) ya son el cambio más grande que el método recibió de una vez, y meter una quinta sin usar las otras sería medir una arquitectura que todavía no se usó — el mismo argumento que difiere P10 |
| P2 matriz por proyecto | b | `cumple` | **Este archivo.** Es la primera instancia |
| P3 rigor por aspecto | b | `cumple` | §4 de este archivo |
| P4 los dos campos del molde de fase | b | **`cumple`** | `plantillas/PDP.md` §4 tiene *Cómo se certifica* y la salida `cancelar`, y **este PDP los usa**: la fase 6 declaró su medidor antes de cerrarse. Lo cobra `medir-fase.py`, saboteado con `probar-medidor-fase.ps1` |
| P5 heurísticas pegadas a los pasos | b, d | **`recortado`** | **Puesta la mitad que entrega, diferida la que aliviana.** Está `hooks/guardia-escapes.ps1`: la heurística que llega **en el paso**, con su saboteador de 10 casos. **No** está la partición de `chequeo-de-trabajo.md`, que sigue pesando 95 KB. **La resta:** la mitad puesta es la que tiene el caso propio medido —la lección estaba inyectada en la línea 553 y el error se cometió cinco veces igual—; la mitad diferida cambia lo que se inyecta en **todas** las sesiones, y sacar 80 KB del arranque sin medir qué se pierde es justo lo que la regla del freno que nunca salta prohíbe. Criterio para la próxima: lo que se inyecta pesa menos, **y** la lección del paso en curso está adentro |
| P6 criterio de entrada al registro | b | **`cumple`** | `aprender.py agregar` exige `--opuesto` y lo **guarda**, igual que el triage: una decisión que no queda escrita no se puede auditar. **Se exige uno solo de los cinco**, el criterio 4, y la elección es el diseño: es el más filoso y el único mecanizable —los otros piden conocer el dominio, juzgar una longitud o esperar el paso del tiempo—, así que pedirlos por script sería hacer escribir «sí» cuatro veces, que es ceremonia sin medición. Los cinco se imprimen al fallar. Saboteado con tres casos en `probar-chequeo-lecciones.ps1` |
| P7 separación System 2 / System 3 | b | **`cumple`** | `perfil-global/README.md` traza la línea con la tabla de cuatro filas —artefactos, cadencia, quién lo toca y **la prueba** para decidir— y la regla operativa: si un dato es cierto para cualquier proyecto vive en el System 3, y **ante la duda gana el proyecto**. **No se reescribió la cascada**: la línea ya estaba insinuada entre los niveles 0-2 y 3-6, y volverla explícita cuesta una sección donde rehacerla costaba el criterio C3 entero |
| P8 revisión independiente | a, b, c, d | **`recortado`** | **No hay segundo par de ojos.** Los tres candidatos están medidos y ninguno lo es: el saboteador lo escribe el mismo que el medidor; el chat nuevo comparte método y sesgos (aunque funcionó: los cinco defectos de `verificar-citas.py` v1 los encontró otra sesión); un LLM externo dio 4 propuestas de las cuales 3 ya estaban implementadas. **La resta:** no hay recurso que comprarlo, así que la comparación no es entre dos riesgos sino entre tener el hueco escrito o tenerlo invisible. Se elige escrito |
| P9 elección del corte NASA 3/4 sobre INCOSE T4/T5 | b | `cumple` | Se elige NASA. **La resta:** compra trazabilidad a 17 destilados con ancla medida y citas al 99,1 %; cuesta que el vocabulario no sea el del 15288 que usa el resto del mundo, mitigado porque el mapeo de la fase 3 queda como traducción. Cumplir los dos cortes exigiría duplicar artefactos, que es lo que el tailoring evita |
| P10 medidor de validación | b | `no aplica` — **fase 7** | Diseñado y no construido, **a propósito**. **La resta:** construirlo ahora mediría una arquitectura que todavía no se usó, y el número saldría de una sola sesión — la de su propia construcción. Se difiere a la fase 7, que es la que tiene el material: el costo por fase ya registrado, fase por fase, en `ESTADO_ACTUAL.md` |

---
