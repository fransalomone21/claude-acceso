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

## 3. Naturaleza y criticidad

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` / `documentos` / `seguimiento` |
| Criticidad | `critico` (se pierde trabajo irrecuperable o plata) / `importante` (cuesta horas) / `descartable` (se vuelve a correr) |
| Rigor que le corresponde | <!-- critico: revision humana obligatoria, sin automatizar. importante: test + evidencia registrada + reversible. descartable: directo, sin ceremonia --> |

> La mayor parte del trabajo es **descartable** y no debe pagar el costo de
> los otros dos. Marcar todo como crítico es la forma más rápida de que el
> rigor deje de significar algo.

## 4. Las fases

> Se escriben todas las que se ven hoy, pero **sólo la próxima lleva criterio
> de salida detallado**. Las de más adelante se reescriben cuando llegue su
> turno: escribirlas en detalle ahora es planificar con la información de hoy
> un trabajo que se hace con la de mañana.

| # | Fase | Criterio de salida (resultado verificable) | Estado |
|---|---|---|---|
| 0 | | | |
| 1 | | | |

**Fase en curso:** <!-- numero y nombre -->
**Qué la cierra, exactamente:**
<!-- Un enunciado que se pueda contestar si o no. Si no podes escribir el test
     junto al criterio, el criterio todavia no esta listo. -->

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
