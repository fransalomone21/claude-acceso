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

> **Se mudó a la sección 8 del [`PDP.md`](../PDP.md) el 2026-09-17**, y estaba
> declarado en la §2 de este archivo: la matriz **es una sección del PDP**
> (NASA p. 35 y 3.11.4.2, p. 37), y vivía acá sólo porque la fase 5 no tocaba
> archivos vivos.
>
> **No se deja una copia**, y eso es la regla, no una preferencia: un dato que
> vive en dos lados diverge. Es el defecto D12 —el `186` contra el registro—
> aplicado a la matriz misma, y sería el peor lugar donde tenerlo. Mientras
> estuvo duplicada, `medir-matriz.py` contó 76 filas donde hay 38.

## 6. Qué dice esta matriz leída entera

**Los números no se escriben acá.** Los cuenta `python perfil-global/herramientas/medir-matriz.py` sobre el `PDP.md`, y por la misma razón por la que la instancia se mudó: un conteo a mano diverge del que se mide. Al cerrar la fase 5 eran 38 filas, 3 recortadas y 7 `no aplica — todavía`, y el medidor lo confirmó fila por fila.

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
