# PDP — dbz-niveles

> Abierto el 2026-11-20 desde el pedido de Fran del 2026-11-06 (retome en
> `../ps2-casa/HANDOFF.md`) y el del 2026-11-20 («ambos» caminos: PS2 y
> Sparking ZERO). **§1 y §2 (el alcance) quedan PENDIENTES** para la próxima
> sesión, escritos con sus fuentes (concepto `alcance` de la puerta).

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

> Escrito el 2026-11-20 con el concepto `alcance` abierto
> (`alcance-como-se-escribe.md`, SEH p. 47-49 y 55, cátedra M18 y M20). La
> forma copia los ejemplares del CEV y de Marte: un elemento por frase, el
> contexto antes.

**Antecedentes.** Fran tiene dos familias de Dragon Ball a mano: los mods de
PS2 sobre *Budokai Tenkaichi 3* (*Niveles de Poder 8.1*, *Tenkaichi 4*), que
sobre la jugabilidad del BT3 agregan personajes y cambian la fuerza, y el
*Sparking ZERO* de PC, que trae las formas nuevas y admite mods, entre ellos uno
que escala daño y vida por nivel (DP). En los juegos de fábrica una forma
superior pesa casi lo mismo que la de abajo: el combate se equilibra para que
todo personaje sea jugable, y eso es lo contrario de lo que Fran busca. En
2026-09-05 se probó portar la jugabilidad del BT3 al Sparking ZERO y no es un
mod (motores distintos).

**Necesidad.** Fran no tiene un Dragon Ball para jugar de a dos en el que cada
forma de Goku y Vegeta pese lo que pesa en la historia.

**Meta.** Jugar de a dos un Dragon Ball donde la diferencia de poder entre las
formas se sienta como en la serie.

**Objetivos** (trazan a la meta):

| ID | Objetivo |
|---|---|
| O-1 | Que las formas de Goku y Vegeta, de la base a Ultra Instinto y Ultra Ego, se puedan elegir. |
| O-2 | Que, entre dos jugadores de igual habilidad, la forma más alta en la escala de poder elegida gane la pelea, con una ventaja que crece con la distancia en la escala (la función exacta es TBR: la fija la tabla de la fase 0 con Fran). |
| O-3 | Que dos personas jueguen la misma pelea a la vez. |

**Criterios de éxito.** Mínimo: O-1 a O-3 con tres personajes de prueba (Goku
base, Goku SSJ Blue, Goku Ultra Instinto) en una sola computadora con dos
mandos. Completo: todas las formas de Goku y Vegeta, y cada jugador en su
computadora.

**Misión.** Un Dragon Ball modificado (un ISO de PS2 o un Sparking ZERO con
mods) cuya escala de daño y vida sigue la escala de poder elegida. Cuál de los
dos es la salida del trade de la fase 0, no de este párrafo.

**Hipótesis.**

- H-1: «realista» se lee como el **orden** de poder de la historia con saltos
  proporcionales entre formas, no como los números oficiales de las guías,
  porque las guías no publican números para las formas de *Super* (TBR: se le
  pregunta a Fran al mostrarle la tabla).
- H-2: los mods que hoy tiene la notebook alcanzan para O-1; no hace falta
  fabricar modelos ni animaciones.

**Restricciones** (con quién las impone):

- Las máquinas que hay: la notebook (RTX 4060 Laptop) y la PC de casa (RTX
  3090, C: con 6,4 GB libres); las impone el hardware de la casa.
- La versión del Sparking ZERO que hay (build de junio 2025, sin DLC); la
  impone la copia que Fran tiene.
- El repo es público: nada de la colección ni de los links va acá; lo impone
  `claude-acceso`.

**Autoridad y responsabilidad.** Fran decide el camino y la escala; la sesión
investiga, prepara los juegos y mide.

**Para quién es:** Fran, su hermano y sus amigos (Agustín). Es para uso de la
casa: el rigor se ajusta a eso (§3).

**Cómo sabremos que sirvió (validación):** Fran juega una pelea Goku base
contra Goku Ultra Instinto con otra persona y dice que la diferencia se siente
como en la serie. Se puede verificar perfecto la tabla de multiplicadores y
fallar acá si la escala elegida no le cierra.

## 2. Qué NO es

- **No es portar la jugabilidad del BT3 al Sparking ZERO** (probado el
  2026-09-05: motores distintos).
- **No es hacer personajes, modelos ni animaciones nuevos**: se usan los mods
  que existen y se ajustan sus números (H-2; si H-2 cae, se reabre con Fran).
- **No es un juego competitivo balanceado ni online con desconocidos**: el
  desbalance entre formas es justamente lo que se pide.
- **No es tocar los ISOs originales**: se trabaja sobre copias fechadas.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

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
| leer y diffear ISOs | se rehace barato | desconocidos | iterar corto | sólo lectura sobre copias |
| parchear un ISO | se rehace barato (copia fechada) | desconocidos | iterar corto y medir el efecto | el original no se toca |
| mods de Sparking ZERO | se rehace barato (los scripts apagan y prenden) | desconocidos | iterar corto | el save se respalda antes |

> **El default es el rigor más bajo que los dos ejes permitan**, no el más
> alto. Elegir el más alto "por las dudas" es, palabra por palabra, la segunda
> de las cinco trampas del SEH (p. 218), y es la forma más rápida de que el
> rigor deje de significar algo.

## 4. Las fases

> **Si el proyecto persigue varias metas independientes, es un programa**: su
> fase 0 es un estudio de conceptos (Pre-Fase A, NASA p. 22) que cierra con
> una revisión con el interesado, y cada meta elegida tiene después su propio
> ciclo. Y en cualquier proyecto de ingeniería, el nivel 1 del sistema va
> antes que el detalle. Ver `plantillas/naturalezas/ingenieria.md`, «De arriba
> hacia abajo».
>
> Se escriben todas las que se ven hoy, pero **sólo la próxima lleva criterio
> de salida detallado**. Las de más adelante se reescriben cuando llegue su
> turno: escribirlas en detalle ahora es planificar con la información de hoy
> un trabajo que se hace con la de mañana.

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | Pre-Fase A — estudio de conceptos | en este PDP: (a) el alcance (§1-2); (b) cómo hace *Niveles de Poder* para dar fuerza distinta (archivos/tablas, medido con diff contra BT3 y BT4); (c) qué mods del Sparking ZERO de la notebook arrancan y qué hace el de DP; (d) la tabla «personaje → nivel (fuente) → parámetro» para 3 personajes de prueba; (e) el camino elegido con Fran, con fecha | Fran lee la tabla y elige; el diff y el arranque se miden | abierta |
| 1 | PENDIENTE (se escribe al cerrar la 0) | | | |

> **Estado** es uno de: `abierta` / `cerrada` / **`cancelada`**.

**Fase en curso:** 0 — Pre-Fase A, estudio de conceptos (NASA Pre-Phase A, *Concept Studies*). No se hace: fabricar el ISO ni ajustar en serio los mods antes de elegir el camino.

**Qué la cierra, exactamente:** ¿está en §6 el camino elegido por Fran, con fecha, apoyado en la tabla «personaje → nivel (fuente) → parámetro» de 3 personajes?

**Cómo se certifica:** la fila en §6 con las palabras de Fran, y la tabla en `ESTADO_ACTUAL.md`. En rojo: §6 sin esa fila, o la tabla sin fuente por fila.

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
| los mods de 2026 cierran el Sparking ZERO de junio 2025 | alta | media | mitigar: prender por grupos (`bisectar-mods.ps1`) | el juego se cierra al arrancar |
| la escala de *Niveles* vive en el ejecutable y no en datos | media | alta | vigilar: el diff lo dice | el ELF de *Niveles* difiere del de BT3 en algo más que el serial |
| la PC de casa sin disco para copiar mods | alta | baja | mitigar: liberar zips ya instalados (con el sí de Fran) | C: de la PC con menos de 5 GB (hoy 6,4) |

## 6. Decisiones

> Vale tanto el registro de las **descartadas** como el de la elegida: es lo
> que evita volver a evaluarlas en tres meses.

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-11-20 | Fran: estudiar los dos caminos («ambos»), PS2 y Sparking ZERO | elegir uno ya | Fran lo pidió así; la elección final cierra la fase 0 |
| 2026-11-20 (noche) | Fran, textual: «pasá los juegos que sea en pantalla dividida en una sola pantalla allá, así se ve más grande y mejor […] si se puede jugar con las dos mejor, adaptando lo que sea». Entra como preferencia sobre O-3: **evitar la pantalla partida**; qué es «allá» y «las dos» (¿la pantalla grande de la PC? ¿las dos computadoras, una por jugador?) queda **TBR**, preguntado | — | sin interpretar: se le preguntó; cambia el criterio de éxito completo |
| 2026-11-20 (noche) | Fran: no abrir ni cerrar juegos sin coordinar entre sesiones; el Sparking ZERO abierto lo están jugando | — | regla operativa: el banco de arranque espera a que Fran cierre el juego |

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
