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
| Regla | punto 6 de `perfil-global/CLAUDE.md` | si se leyó el archivo |
| Hook `SessionStart` | `perfil-global/apertura-proyecto.md` | una vez por sesión |
| Hook `UserPromptSubmit` | `perfil-global/recordatorio-transversal.md` | **en cada prompt** |

El `UserPromptSubmit` es el que sostiene el "en toda respuesta"; el
`SessionStart` solo cubría la primera. Los dos archivos inyectados van en
**ASCII puro**: la consola de Windows los lee como cp1252 y los acentos salen
como mojibake.
