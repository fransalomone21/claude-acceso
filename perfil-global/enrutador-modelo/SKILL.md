---
name: enrutador-modelo
description: Enrutado automatico de modelo por tipo de trabajo, sin preguntar. Define que corre en Opus, que en Sonnet y que en Haiku, como se enruta el trabajo delegado a subagentes con modelo fijado, y cuando el modelo del hilo principal tiene que cambiar de verdad. Invocar al empezar un tramo de trabajo nuevo, al notar que el modelo no corresponde, o si aparece la tentacion de preguntarle al usuario que modelo usar.
---

# Enrutador de modelo

**Se decide, no se pregunta.** Elegir el modelo es una llamada del rol de
ingeniero. Preguntarle al usuario "¿querés que use Opus?" le traslada una
decisión técnica que él delegó, y encima cuesta un turno.

## Regla cero: Fable está prohibido

**Nunca. Por ningún motivo. Ni para una prueba.** Consume créditos aparte del
plan y agota el presupuesto sin que se note dónde se fue. No es una
preferencia: es una restricción dura. Si algo parece pedir Fable, la respuesta
es Opus o replantear la tarea.

## La tabla

| tipo de trabajo | modelo | por qué |
|---|---|---|
| leer desensamblado, deducir layout de structs, primera hipótesis en territorio desconocido | **Opus** | es donde una hipótesis mala cuesta horas |
| decidir arquitectura, diseñar un experimento, interpretar un resultado que contradice lo anotado | **Opus** | el error caro es de criterio, no de ejecución |
| escribir y refactorizar herramientas, cargar el `kb/`, redactar documentación, tabular réplicas | **Sonnet** | el camino ya está decidido; falta ejecutarlo bien |
| correr un runbook ya escrito, convertir formatos, renombrar, reportar la salida de un script | **Haiku** | no hay juicio involucrado |

## Los dos mecanismos, y cuál es realmente automático

### 1. Delegado: automático de verdad

El trabajo que se delega **se enruta solo**, fijando el modelo en la llamada.
Esto no necesita al usuario y es lo que de hecho controla el gasto:

- Subagente mecánico (correr, volcar, reportar) → `model: "haiku"`
- Subagente de herramientas/documentación → `model: "sonnet"`
- Subagente de desensamblado o diseño → `model: "opus"`

En un workflow, lo mismo con `agent(prompt, {model, effort})`. **Nunca dejar el
modelo sin fijar en trabajo mecánico**: por defecto hereda el del hilo
principal, que suele ser el caro.

### 2. Hilo principal: no se puede cambiar solo, así que se avisa

El modelo del hilo principal **no** se puede cambiar desde adentro de la
sesión. Lo cambia el usuario con `/model`. Por eso el contrato es:

- El cuadro de fase declara el modelo **en toda respuesta**, no sólo al abrir.
- Cuando el tramo cambia de tipo (terminó el desensamblado, empieza a tabular),
  **se dice en el momento**, con una línea: *"esto que sigue es Sonnet"*.
- Si el tramo caro ya terminó y quedan tres turnos mecánicos, decirlo vale
  plata real. Callarlo por no interrumpir es el error caro.

## Autocalibración: cuando el enrutado por tipo de trabajo ya no alcanza

La tabla de arriba enruta por **tipo de trabajo**, que es lo que se sabe
*antes* de empezar. Falta la otra mitad: qué hacer cuando la evidencia dice
que el tramo no está saliendo, independientemente de lo que diga la tabla.

**El disparador es observable, no una sensación.** Cualquiera de estos tres:

- dos hipótesis seguidas refutadas sobre el mismo objetivo;
- una búsqueda que vuelve a dar el mismo conjunto de candidatos demasiado
  grande después de haberla afinado;
- un resultado que contradice algo ya anotado como confirmado.

**Y lo que se escala NO es el modelo primero.** Subir a Opus con el parámetro
equivocado compra una respuesta cara e igual de equivocada. El orden de
sospecha, de más barato y más probable a menos:

| # | Sospechá de | Cómo se descarta | Lección |
|---|---|---|---|
| 1 | el **parámetro** de la búsqueda | ¿este número lo vi o lo deduje? Observalo directo | 12 |
| 2 | el **instrumento** | control positivo conocido en la misma corrida | 14, 18 |
| 3 | la **métrica** | ¿por qué mecanismo la variable llega hasta ella? | 22 |
| 4 | el **modelo / effort** | recién acá: subir a Opus, o effort alto | — |

Los tres primeros cuestan minutos y matan la mayoría de los estancamientos.
El cuarto cuesta plata y no arregla ninguno de los tres.

Cuando el cuarto sí corresponde —territorio desconocido, hipótesis que
requiere leer desensamblado, decisión de arquitectura mal tomada— se dice en
la línea de modelo del cuadro, con el disparador que lo justificó: *"dos
refutaciones seguidas acá: esto es Opus"*. No se pregunta.

Y al revés, que es el que nadie avisa: **cuando el tramo caro termina, se
dice**. Tres turnos mecánicos corriendo en Opus por inercia es el gasto que
no se ve.

## Presupuesto: la señal que manda sobre todo lo demás

Si el usuario muestra que está cerca del límite del plan —o lo dice—, **eso
gana sobre cualquier instrucción de exhaustividad**, incluida `ultracode`.
Concretamente:

- **No abrir fan-out.** Cada subagente arranca en frío y re-deriva contexto que
  el hilo principal ya tiene cargado. Con el contexto caliente, hacerlo inline
  es más barato *y* más certero.
- **Asegurar el resultado antes de seguir investigando.** Un hallazgo sin
  commitear vale cero. Escribir al repo y pushear pasa al frente de la cola.
- **Cortar el análisis, no la documentación.** Lo que se pierde por no anotar
  se vuelve a pagar entero en la sesión siguiente.

## Cómo se ve aplicado

```
Fase     : 7 — arquitectura de entidades y de la IA. La cierra: ...
Modelo   : Opus para este tramo (leer layout y decidir qué escribir).
           Bajo a Sonnet apenas haya que tabular réplicas.
Contexto : seguir acá — 9% de ventana, sobra.
```

La línea de modelo lleva **el tramo y el disparador del cambio**, no sólo el
nombre del modelo. "Opus" solo no le dice a nadie cuándo dejar de pagarlo.
