---
name: cuadro-de-fase
description: El cuadro de tres lineas (Fase / Modelo / Contexto) que abre TODA respuesta en un proyecto de ingenieria, no solo la primera del chat. Como completar cada linea, que cuenta como criterio de salida, cuando cambiar de modelo a mitad de sesion y cuando cortar el chat. Invocar si el cuadro se dejo de poner, si no se sabe que escribir en alguna linea, o al arrancar un proyecto nuevo que todavia no tiene fases definidas.
---

# El cuadro de fase

Tres líneas, arriba de todo, **en toda respuesta** de una sesión de proyecto.
No al final, no "si sobra lugar", no sólo en el primer mensaje del chat.

```
Fase     : cuál es, y QUÉ LA CIERRA (criterio de salida concreto)
Modelo   : el que corresponde a este tramo, y por qué
Contexto : seguir acá | conviene chat nuevo, y por qué
```

Cuestan cuatro renglones y evitan el modo de falla caro: una sesión entera
gastada en la fase equivocada, con el modelo equivocado, en un chat que ya
no tenía lugar para pensar el problema difícil.

**Y una cuarta línea cuando el contexto dice chat nuevo:**

```
Retomar  : ver el bloque al final de esta respuesta
```

Ver *El mensaje de retome*, más abajo. Es obligatorio: sin él, "chat nuevo"
es una orden de tirar el contexto sin decir cómo recuperarlo.

## Por qué en TODA respuesta y no una vez

Porque las tres variables cambian **dentro** de una misma sesión, no entre
sesiones:

- la fase se cierra a mitad de chat y hay que decir que se cerró;
- el tipo de trabajo cambia de leer desensamblado a correr un runbook, y con
  él el modelo que corresponde;
- el contexto se consume y en algún punto conviene cortar.

Un cuadro que sólo aparece al abrir el chat describe el estado de hace veinte
mensajes. Ese es exactamente el reclamo que originó esta skill: *"lo aplicás
al principio y después lo dejás de hacer"*.

## Fase

Nombrar la fase **y su criterio de salida**, que tiene que ser un hecho
observable, no una sensación de avance.

- Bien: *"Fase 4b — el daño de salida del jugador. Cierra cuando se pueda
  cambiar el daño y verlo: un enemigo que muere en una bala en vez de cuatro,
  medido sobre el pool."*
- Mal: *"Fase 4b — investigando el daño."* No dice cuándo termina, así que no
  termina nunca.

Reglas:

- **Si la fase anterior no quedó cerrada, decirlo ANTES de empezar otra.** Una
  fase abierta que se arrastra en silencio es deuda que se paga tres sesiones
  después.
- Una fase se cierra por **efecto visto**, no por análisis convincente. Es la
  regla 1 del perfil aplicada a la planificación.
- Si el criterio de salida requiere al usuario (disparar, mirar la pantalla,
  aprobar), decirlo en la línea: es la única clase de bloqueo legítimo.

## Modelo

El que corresponde **a este tramo**, con la razón. Y se avisa también **a
mitad de sesión**, cuando cambia el tipo de trabajo:

| Trabajo | Modelo |
|---|---|
| leer desensamblado, formar hipótesis nuevas, decidir arquitectura | Opus |
| escribir o refactorizar herramientas, cargar datos, documentar | Sonnet |
| mecánico: correr un script y reportar la salida, convertir formatos | Haiku |

No se pregunta "¿querés que cambie de modelo?". Se dice cuál corresponde y
por qué, se instruye el `/model` como hecho consumado de la recomendación, y
se sigue trabajando con el mejor criterio disponible mientras tanto.

## Contexto

`seguir acá` o `conviene chat nuevo`, con la razón. Chat nuevo cuando:

- **cambia la fase**, o
- el contexto pasó **~50%**, o
- lo que sigue **no necesita nada** de lo hablado.

El motivo de fondo: un resumen degrada primero los datos que no se pueden
aproximar — direcciones, offsets, versiones, valores de registros. Justo los
que cuestan una sesión entera de recuperar. Por eso el corte se hace **antes**
de necesitarlo, y el handoff se apoya en el repo (`ESTADO_ACTUAL.md`,
`HANDOFF.md`, `kb/`), nunca en el historial del chat.

## El mensaje de retome

Cuando el cuadro dice **chat nuevo**, la respuesta termina con un bloque de
código listo para copiar y pegar como primer mensaje del chat siguiente.

**Por qué es obligatorio y no un lujo.** Un `HANDOFF.md` en el repo contesta
"qué sigue"; el mensaje de retome contesta "**qué le digo al chat nuevo para
que lo lea**". Sin él, el usuario abre un chat vacío y tiene que reconstruir
de memoria qué archivos importan — que es exactamente el trabajo que el
handoff venía a evitar. El síntoma es conocido: la sesión nueva arranca
preguntando cosas que estaban escritas.

### Las seis cosas que lleva, siempre

1. **Qué leer, en orden, y qué NO leer.** Rutas exactas. El "qué no" importa
   tanto como el "qué": leer los cuatro documentos por las dudas quema el
   contexto que después falta.
2. **La fase que se abre y su criterio de salida.** El mismo criterio
   observable del cuadro, no una versión aguada.
3. **El modelo, y por qué.** Si el tramo cambia de modelo a mitad, decir
   dónde está el corte.
4. **El estado de la máquina.** Qué está instalado y **en qué ruta**, qué hay
   montado, qué parches viven sólo en memoria y se pierden al recargar el
   emulador, qué servicios tienen que estar levantados. Esto no está en el
   repo porque no es del proyecto: es de la máquina, y es lo primero que se
   pierde.
5. **Lo que ya está resuelto y no hay que rehacer.** Las direcciones
   confirmadas, los callejones cerrados.
6. **El primer comando concreto.** Uno, ejecutable, que deje ver enseguida si
   el entorno está sano. Ideal: el que corre un control positivo.

### Cómo se escribe

- **Literal, no descriptivo.** "Leé `black/ESTADO_ACTUAL.md`", no "ponete al
  día con el estado".
- **No se resume.** Si una ruta, un offset o un hash no entra cómodo, entra
  igual. Un mensaje de retome largo cuesta unos miles de tokens; recuperar un
  offset perdido cuesta una sesión.
- **No se pega el chat anterior.** El historial no es el handoff: el `kb/` y
  la bitácora sí.
- **Va al final de la respuesta**, no en el medio, para que se copie de una.

## Decidir, no preguntar

El cuadro es una **decisión anunciada**, no un menú. No terminar un turno con
"¿seguimos o preferís que pare?" cuando la respuesta es una llamada de
criterio técnico: si hay presupuesto de contexto y una tarea concreta
pendiente, se sigue. Se frena, diciendo por qué, sólo cuando el contexto está
genuinamente agotado o la tarea **estructuralmente** requiere al usuario.

## Antes de cerrar la sesión

`ESTADO_ACTUAL.md` + `HANDOFF.md` + commit + push. Los cuatro. Sin ellos la
próxima sesión arranca de cero y el cuadro de la primera respuesta va a estar
inventado.

## Dónde está cableado

Por qué esta skill existe además de la regla escrita: una regla que depende de
recordarla no es una regla (lección 11). El cuadro está en tres niveles:

| Nivel | Dónde | Dispara |
|---|---|---|
| Regla | puntos **6 y 7** de `perfil-global/CLAUDE.md` | si se leyó el archivo |
| Hook `SessionStart` | `perfil-global/apertura-proyecto.md` | una vez por sesión |
| Hook `UserPromptSubmit` | `perfil-global/recordatorio-transversal.md` | **en cada prompt** |

El mensaje de retome está cableado en los tres niveles, igual que el cuadro:
el punto 7 de `CLAUDE.md`, y el bloque "SI EL CUADRO DICE CHAT NUEVO" de los
dos archivos inyectados.

El `UserPromptSubmit` es el que sostiene el "en toda respuesta"; el
`SessionStart` solo cubría la primera. Los dos archivos inyectados van en
**ASCII puro**: la consola de Windows los lee como cp1252 y los acentos salen
como mojibake.
