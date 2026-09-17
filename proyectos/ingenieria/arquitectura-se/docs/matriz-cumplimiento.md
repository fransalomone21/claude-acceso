# Matriz de cumplimiento

**Fase 5, 2026-09-17.** Dos cosas en un archivo: el **molde** (§1-§3), que es lo
que se copia a cualquier proyecto, y la **instancia llenada de este proyecto**
(§4-§6), que es la prueba de que el molde funciona sobre un caso real.

Diseño: [`arquitectura.md`](arquitectura.md) §3, pieza **P2**.
Fuente: NASA SP-2016-6105 cap. 3.11.3 (p. 35-36) y Tabla 3.11-3 (p. 41).

---

## 1. Qué es, y qué problema resuelve

Hoy una regla del método se **cumple** o se **incumple**, y no hay tercer
estado. El incumplimiento, por lo tanto, no deja rastro: es invisible. La matriz
agrega el tercer estado —**recortado, con justificación escrita**— y convierte
el silencio en una excepción declarada.

> "The Compliance Matrix documents the program/project's compliance or intent to
> comply with the requirements of the NPR **or justification for tailoring**."
> (NASA, p. 35)

Y su segundo uso, que es el menos obvio (p. 35): la matriz registra también
**cómo** se va a hacer lo que se deja — no sólo lo que se saca.

---

## 2. El molde

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| ancla a archivo y regla, **nunca el enunciado transcripto** | a qué parte del proyecto se aplica | `cumple` / `recortado` / `no aplica` | **vacío si cumple**; la resta escrita si se recorta |

### Las cuatro mecánicas que la hacen funcionar

**1. El default es silencio.** La justificación se llena **sólo cuando se
recorta** (NASA p. 41). Una matriz de un proyecto disciplinado es casi toda
`cumple` y no se lee; lo que se lee son las excepciones. Eso es lo que hace que
agregue información sin agregar lectura.

**2. La columna `Regla` es un ancla, no una copia.** Si transcribe el enunciado,
en tres meses la matriz dice una cosa y el archivo fuente otra — que es
exactamente el defecto D12 (`186` contra `201`), más grande. Se apunta a
`archivo §sección #n`.

**3. El recorte lleva la resta escrita.** NASA p. 36, forma 2 de tailorear:

> "Eliminating a requirement that is overly burdensome (i.e., when the cost of
> implementing the requirement adds more risk to the project by diverting
> resources than the risk of not complying with the requirement)."

La pregunta no es *"¿tengo tiempo?"* sino **"¿qué riesgo compra esta regla, y
qué riesgo crea el tiempo que se lleva?"**. Si la resta no se puede escribir, no
es tailoring: es indisciplina.

**4. Una fila por ASPECTO, no por proyecto.** NASA p. 39: un mismo proyecto
puede ir con rigor pleno en la parte que no perdona y recortado en la parte que
se rehace en una tarde. La misma regla puede aparecer dos veces con estados
distintos, y eso no es una inconsistencia: es el punto.

### Dónde vive

**Es una sección del `PDP.md`, no un archivo aparte.** NASA p. 35 admite las dos
formas —adjunta al SEMP, o dentro del plan si no hay SEMP stand-alone— y acá no
hay SEMP: hay PDP. Es una aplicación directa de 3.11.4.2 (p. 37), que dice que
el NPR no exige documentos stand-alone.

> **Excepción declarada para este proyecto:** acá vive en `docs/` porque la
> fase 5 **no toca archivos vivos** y el `PDP.md` de este proyecto lo es. Se
> muda al `PDP.md` en la fase 6. Esta nota es, ella misma, una fila de matriz.

### Cuándo se llena, y cuándo se revisa

El tailoring **no es un acto de arranque único** (NASA p. 35: "can occur at any
time in the program or project's life cycle"), y el SEH lo refuerza (p. 215):

> "Tailoring occurs dynamically over the system life cycle depending on risk and
> the situational environment. Therefore, it should be continually monitored and
> adjusted as needed."

Se llena al abrir el proyecto y **se revisa al cerrar cada fase**, que es el
único momento que ya está en el protocolo y no agrega un acto nuevo.

---

## 3. El selector de rigor — dos ejes, por aspecto

Antes de llenar una fila hay que saber qué rigor le corresponde al aspecto.
Pieza **P3**:

| Eje | La pregunta | Fuente |
|---|---|---|
| **Reversibilidad** | ¿Puedo volver a intentarlo, y cuánto cuesta? | NASA Tabla 3.11-1, criterio 8 (p. 38) |
| **Incertidumbre** | ¿Se conocen los requisitos al empezar? | INCOSE SEH 5.ª ed., Tabla 2.2 (p. 34) y Fig. 4.3 (p. 222) |

| | Requisitos conocidos | Requisitos desconocidos |
|---|---|---|
| **Se rehace barato** | rigor mínimo: directo | iterar corto y medir el efecto |
| **Un solo tiro** | rigor pleno: nada se recorta | rigor pleno **y** prototipo antes en blanco inocuo |

**El default es el rigor más bajo que los dos ejes permitan**, no el más alto.
Elegir el más alto "por las dudas" es, palabra por palabra, la segunda de las
cinco trampas del SEH (p. 218).

---

## 4. Instancia — los aspectos de `arquitectura-se`

| # | Aspecto | Reversibilidad | Incertidumbre | Rigor |
|---|---|---|---|---|
| **a** | Las fichas de lectura (`pilares/`) | se rehace: el libro sigue ahí | alta al empezar cada libro | iterar y medir |
| **b** | El diseño de la arquitectura (fase 5) | se rehace: no toca nada vivo | alta | iterar y medir |
| **c** | La migración (fase 6) | git revierte, pero un método roto se arrastra sesiones | baja: la matriz ya dice qué migrar | **pleno** |
| **d** | Las herramientas de medición (`verificar-*.py`) | se rehace | media | pleno en el saboteador, mínimo en el resto |

**El aspecto `c` es el único de rigor pleno, y es el único que todavía no
empezó.** Eso es P3 funcionando: el mismo proyecto no lleva el mismo rigor de
punta a punta.

---

## 5. Instancia — la matriz

Reglas ancladas a su archivo fuente. Aspectos por la letra de §4.

### `~/.claude/CLAUDE.md` — las reglas del método

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| #1 evidencia con grado anotado | a, b, d | `cumple` | |
| #2 el éxito también se audita | a, d | `cumple` | |
| #3 toda alarma se prueba rompiéndola | d | `cumple` | |
| #3 toda alarma se prueba rompiéndola | b | **`recortado`** | Los requisitos A1-A10 **no tienen alarma que los pueda mirar**: `verificar-requisito.py` da 13 de 13 falsos positivos de idioma (D14). Se declaran **sin verificar** en vez de aceptar su verde. **La resta:** escribir el chequeo en español hoy cuesta la fase 5 entera y mide un documento de diseño que todavía no se aplicó; declararlo sin verificar cuesta que A1-A10 entren a la fase 6 sin chequeo mecánico, con la condición de aceptación ya escrita (`arquitectura.md` §9) |
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
| §4 **cómo se certifica** el criterio | a, b | **`no aplica` — todavía** | El campo **no existe** en el molde vivo: es la pieza P4 que esta fase diseña. No se puede cumplir una regla que se está escribiendo. Pasa a `cumple` en la fase 6 |
| §5 riesgos con disparador observable | b | `cumple` | |
| §6 decisiones, con las descartadas y por qué perdieron | b | `cumple` | [`trade-study.md`](trade-study.md) §8 |
| §7 el verificador, ¿alguna vez falló? | d | `cumple` | Cuatro saboteadores, corridos hace 4 días, en verde |

### Las reglas que la arquitectura nueva agrega (P1-P10)

Se listan ahora para que la fase 6 no tenga que inventarlas, con el estado que
les corresponde **hoy**: ninguna está puesta, porque la fase 5 es de diseño.

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| P1 catálogo derivado, no copiado | b | `no aplica` — todavía | Diseñada, no construida. Fase 6 |
| P2 matriz por proyecto | b | `cumple` | **Este archivo.** Es la primera instancia |
| P3 rigor por aspecto | b | `cumple` | §4 de este archivo |
| P4 los dos campos del molde de fase | b | `no aplica` — todavía | Fase 6 |
| P5 heurísticas pegadas a los pasos | b | `no aplica` — todavía | Fase 6 |
| P6 criterio de entrada al registro | b | `no aplica` — todavía | Fase 6 |
| P7 separación System 2 / System 3 | b | `no aplica` — todavía | Fase 6 |
| P8 revisión independiente | a, b, c, d | **`recortado`** | **No hay segundo par de ojos.** Los tres candidatos están medidos y ninguno lo es: el saboteador lo escribe el mismo que el medidor; el chat nuevo comparte método y sesgos (aunque funcionó: los cinco defectos de `verificar-citas.py` v1 los encontró otra sesión); un LLM externo dio 4 propuestas de las cuales 3 ya estaban implementadas. **La resta:** no hay recurso que comprarlo, así que la comparación no es entre dos riesgos sino entre tener el hueco escrito o tenerlo invisible. Se elige escrito |
| P9 elección del corte NASA 3/4 sobre INCOSE T4/T5 | b | `cumple` | Se elige NASA. **La resta:** compra trazabilidad a 17 destilados con ancla medida y citas al 99,1 %; cuesta que el vocabulario no sea el del 15288 que usa el resto del mundo, mitigado porque el mapeo de la fase 3 queda como traducción. Cumplir los dos cortes exigiría duplicar artefactos, que es lo que el tailoring evita |
| P10 medidor de validación | b | `no aplica` — todavía | Diseñado acá, se construye en la fase 7. Construirlo antes sería medir una arquitectura que no se usó |

---

## 6. Qué dice esta matriz leída entera

**Filas totales: 38. Recortadas: 3. Con `no aplica — todavía`: 7. Cumple: 28.**

Las tres recortadas son lo que la matriz existe para mostrar, y ninguna de las
tres era visible antes de escribirla:

1. **La regla 3 sobre los requisitos A1-A10** — un hueco que apareció *midiendo*,
   no leyendo. Sin la fila, A1-A10 habrían quedado escritos como si estuvieran
   verificados.
2. **El gasto de la fase 0** — un incumplimiento que ya estaba contado en el
   `PDP.md` §5 como riesgo *"ya pasó"*, pero sin la resta. Escribirla ahora dio
   el resultado más incómodo de esta fase: **la resta sale negativa**, o sea que
   aquello no fue tailoring sino un error. La diferencia entre las dos cosas es
   justamente lo que la columna de justificación obliga a decidir.
3. **La revisión independiente** — el hueco más grande que encontró la fase 4, y
   el que sigue sin respuesta.

**Los siete `no aplica — todavía` son el plan de la fase 6**, y están en la
matriz en vez de en una lista aparte a propósito: una lista de pendientes se
lee una vez y se olvida; una matriz que se revisa al cerrar cada fase los pone
adelante cada vez.

### La señal de desuso

Ese es el criterio C6 del trade study, y acá se ve cómo se cobra: **si dentro de
tres meses esta matriz tiene diez filas `recortado` con la justificación vacía,
la arquitectura se está dejando de usar y el conteo lo dice**. Hoy, con el
método viejo, eso no dejaría rastro de ninguna clase.

Es contable por script, y ése es el medidor que la fase 6 tiene que escribir:
filas `recortado` sin justificación = rojo.
