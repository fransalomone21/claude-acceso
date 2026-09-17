# PDP — Plan de Desarrollo de Proyecto

> Plantilla. Copiar a `proyectos/<naturaleza>/<proyecto>/PDP.md` y llenar.
> Borrar estas citas al llenarlo. Lo que quede sin llenar se marca `PENDIENTE`,
> no se borra: un hueco visible vale más que una sección que parece completa.

**El PDP se escribe antes de la primera línea de trabajo y se corrige cuando
la realidad lo contradice.** No es un documento de arranque que después queda
viejo: es donde vive el criterio de salida de la fase en curso.

## El método: waterfall en las puertas, agile adentro

- **Waterfall entre fases.** Las fases son secuenciales y cada una tiene una
  **puerta**: un criterio de salida escrito *antes* de empezarla. No se pasa a
  la siguiente sin cerrar la anterior. Una fase abierta y una fase cerrada no
  se parecen en nada, y confundirlas es lo que hace que un proyecto quede
  "95% listo" semana tras semana.
- **Agile adentro de la fase.** Dentro de una fase se itera corto: se prueba,
  se mide el efecto, se ajusta. El plan de las fases *siguientes* se reescribe
  con lo aprendido — eso es lo que lo hace híbrido y no waterfall a secas.
- **El criterio de salida es un RESULTADO, nunca una cantidad de trabajo.**
  "Escribir tres herramientas" no cierra nada. "El valor escrito cambia lo que
  se ve en pantalla, y quedó registrado" sí.

---

## 1. El problema

<!-- Una o dos frases. Qué duele HOY, no qué sería lindo tener. -->

**Para quién es:** <!-- si sos vos, decilo: cambia el rigor -->

**Cómo sabremos que sirvió (validación):**
<!-- La pregunta es "¿construimos lo correcto?", no "¿lo construimos bien?".
     Se puede verificar perfecto y fallar acá. Es el modo de falla más caro. -->

## 2. Qué NO es

<!-- El alcance negativo. Lo que se decide NO hacer, para que no vuelva a
     discutirse en tres semanas. Esta seccion evita mas trabajo que la de arriba. -->

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` / `documentos` / `seguimiento` |

> La naturaleza dice **qué se lee siempre** en esta clase de proyecto (nivel 3
> de la cascada). Ya **no** decide el rigor: eso lo hace la tabla de abajo, y
> por una razón medida — el rigor no es una propiedad del dominio.

### El selector de rigor — dos ejes, una fila por aspecto

> **El tailoring se aplica por ASPECTO, no por proyecto.** NASA p. 39, sobre
> la Tabla 3.11-1: *"the tailoring approach may permit more tailoring for
> those aspects of the project that are simpler and more open to risk and less
> tailoring for those aspects where complexity and/or risk aversion
> dominate."* Clasificar el proyecto entero de un saque es la forma fácil y la
> equivocada: en un mismo proyecto el análisis se rehace gratis y el parche
> binario sin backup no se deshace nunca.

| Eje | La pregunta | De dónde sale |
|---|---|---|
| **Reversibilidad** | ¿Puedo volver a intentarlo, y cuánto cuesta? | NASA Tabla 3.11-1, criterio 8 (p. 38); pilar *el costo de deshacer* |
| **Incertidumbre** | ¿Se conocen los requisitos al empezar? | INCOSE SEH 5.ª ed., Tabla 2.2 (p. 34) y Fig. 4.3 (p. 222) |

| | Requisitos conocidos | Requisitos desconocidos |
|---|---|---|
| **Se rehace barato** | rigor mínimo: directo | iterar corto y medir el efecto |
| **Un solo tiro** | rigor pleno: nada se recorta | rigor pleno **y** prototipo antes, en blanco inocuo |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` | | | | |
| `b` | | | | |

> **El default es el rigor más bajo que los dos ejes permitan**, no el más
> alto. Elegir el más alto "por las dudas" es, palabra por palabra, la segunda
> de las cinco trampas del SEH (p. 218), y es la forma más rápida de que el
> rigor deje de significar algo.

## 4. Las fases

> Se escriben todas las que se ven hoy, pero **sólo la próxima lleva criterio
> de salida detallado**. Las de más adelante se reescriben cuando llegue su
> turno: escribirlas en detalle ahora es planificar con la información de hoy
> un trabajo que se hace con la de mañana.

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | | | | |
| 1 | | | | |

> **Estado** es uno de: `abierta` / `cerrada` / **`cancelada`**.

**Fase en curso:** <!-- numero y nombre -->

**Qué la cierra, exactamente:**
<!-- Un enunciado que se pueda contestar si o no. Si no podes escribir el test
     junto al criterio, el criterio todavia no esta listo. -->

**Cómo se certifica:**
<!-- EL COMANDO O LA MEDICION CONCRETA que contesta ese si o no, y quien la
     corre. Se escribe AHORA, antes de empezar la fase, no cuando haya que
     cerrarla. -->

> **Por qué este campo existe, y por qué va antes y no después.** Rechtin
> p. 398: *"define how an acceptance criterion is to be certified at the same
> time the criterion is established."* Un criterio sin su medidor no es un
> criterio: es una intención, y al llegar el momento de cerrar la fase el
> medidor se elige para que dé verde.
>
> **Y el medidor no puede ser invariante bajo el error que busca.** Una fase
> de `fisica-espacial` cerró en falso porque su medidor era un `grep` del
> nombre de la sección: daba verde con la sección vacía. Si no podés escribir
> cómo se ve ese medidor **en rojo**, todavía no es un medidor.

**La fase también puede CANCELARSE, y eso no es un fracaso.**

<!-- Si esta fase se cancela, ¿que se aprendio, y que fase siguiente deja de
     hacer falta? -->

> SEH p. 223: *"the outcome of stage activity may simply be valuable learned
> knowledge that aborts the need for producing artifacts of use in other
> stages."* Sin esta salida, toda fase tiene que cerrar produciendo un
> artefacto, y el sistema no tiene forma de decir *"aprendimos que la fase que
> viene no hace falta"* sin que parezca que algo salió mal. El resultado es
> que se produce el artefacto igual — que es trabajo real gastado en tapar un
> hueco del molde.

## 5. Riesgos

> Lo que hace útil a un registro de riesgos no es la lista: es que cada
> entrada tenga un **disparador observable** y un **dueño**.

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| | baja/media/alta | baja/media/alta | mitigar / aceptar / vigilar / evitar | "si pasa X, actuamos" |

## 6. Decisiones

> Vale tanto el registro de las **descartadas** como el de la elegida: es lo
> que evita volver a evaluarlas en tres meses.

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|

## 7. Verificación

**Cómo se verifica cada entregable** (¿lo construimos bien? — contra el
requisito escrito):

**Qué se registra de cada verificación:** identificación y versión de lo
verificado, en qué difiere el entorno de prueba del real, resultado por
requisito, y **la lista de deficiencias y límites detectados** — esa última
parte es la que siempre se omite y la que más vale después.

**El verificador, ¿alguna vez falló?** <!-- Un test que nunca se puso en rojo
esta sin verificar. Romperlo a proposito una vez, y anotar que se vio. -->

## 8. Matriz de cumplimiento

> **Qué es.** Las reglas del método, y qué hace este proyecto con cada una.
> Sale de la Tabla 3.11-3 del handbook NASA (p. 41). **Vive acá y no en un
> archivo aparte**: NASA p. 35 admite las dos formas —adjunta al SEMP, o
> dentro del plan cuando no hay SEMP stand-alone— y acá no hay SEMP, hay PDP.
> Es una aplicación directa de 3.11.4.2 (p. 37): el NPR no exige documentos
> stand-alone.
>
> **Las cuatro mecánicas que la hacen barata:**
>
> 1. **El default es silencio.** La justificación se llena **sólo cuando se
>    recorta**. Una matriz de un proyecto disciplinado es casi toda `cumple` y
>    no se lee; lo que se lee son las excepciones. Eso es lo que hace que
>    agregue información sin agregar lectura.
> 2. **La columna `Regla` es un ancla, no una copia.** Se apunta a
>    `archivo §sección #n`. Si transcribe el enunciado, en tres meses la matriz
>    dice una cosa y el archivo fuente otra.
> 3. **El recorte lleva la resta escrita.** La pregunta no es *"¿tengo
>    tiempo?"* sino **"¿qué riesgo compra esta regla, y qué riesgo crea el
>    tiempo que se lleva?"** (NASA p. 36). Si la resta no se puede escribir, no
>    es tailoring: es indisciplina. **Y esto lo mide un script**, así que un
>    recorte sin resta sale en rojo en el arranque siguiente:
>    `python perfil-global\herramientas\medir-matriz.py`
> 4. **Una fila por ASPECTO** (los de §3), no por proyecto. La misma regla
>    puede aparecer dos veces con estados distintos, y eso no es una
>    inconsistencia: es el punto.
>
> **Cuándo se llena y cuándo se revisa.** Al abrir el proyecto, y **se revisa
> al cerrar cada fase** — que es el único momento que ya está en el protocolo
> y no agrega un acto nuevo. El tailoring no es un acto de arranque único
> (NASA p. 35; SEH p. 215: *"should be continually monitored and adjusted"*).

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| | | `cumple` / `recortado` / `no aplica` | **vacío si cumple**; la resta escrita si se recorta |
