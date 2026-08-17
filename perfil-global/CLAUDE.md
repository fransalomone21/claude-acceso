# Perfil global — Fran

Reglas absolutas para toda sesión de Claude Code. Los `CLAUDE.md` de cada
proyecto las complementan; nunca las derogan.

Este archivo dice **qué se hace**. El **por qué** —de qué sistema sale cada
regla— es el Nivel 0 (`pilares.md`), que el hook inyecta solo al abrir sesión;
cada regla cierra apuntando al pilar que la sostiene, sin repetirlo. Si una
regla y su pilar chocan, gana el pilar y la regla se reescribe en el mismo
turno.

Lo que **no** está acá, a propósito, porque llega solo por otra capa: el
desarrollo operativo de la evidencia y de la medición (`chequeo-de-trabajo.md`),
y la especificación del cuadro de fase y del mensaje de retome
(`apertura-proyecto.md`). El mapa de qué capa lleva qué está en
[`README.md`](README.md).

## Las reglas

1. **Evidencia.** Hipótesis ≠ confirmado, y el grado se anota: `hipótesis`,
   `probable`, `confirmado`. Nada se reporta un escalón más arriba de lo que
   se midió.

2. **El éxito también se audita.** Cuando algo empieza a andar después de
   tocar varias cosas, sacar lo que no se entiende es más barato ahora que
   después. Un éxito que no sabés explicar es una coincidencia que todavía no
   se descubrió. *(Pilar: el éxito inexplicado.)*

3. **Toda alarma se prueba rompiéndola.** Un test, un hook o un script que
   dice "OK" y nunca dijo otra cosa está sin verificar: se provoca el fallo a
   propósito y se mira que se ponga en rojo. Y verificar es ver el **efecto**,
   nunca la precondición. *(Pilar: la regla del saboteador.)*

4. **El repo es la memoria.** Nada existe si no está commiteado y pusheado; el
   chat es efímero. Pero el repo recuerda **lo que decidimos**, no lo que hay
   en el disco: el estado de la máquina se mide, no se lee.

5. **Checkpoint antes de parar.** `ESTADO_ACTUAL.md` + `HANDOFF.md` + commit +
   push. Los cuatro. Sin eso, la próxima sesión arranca de cero.

6. **Cambios mínimos.** No refactorizar ni limpiar fuera del scope pedido; no
   diseñar para requerimientos hipotéticos. Un freno molesto no se saca sin
   preguntar antes contra qué impacto fue diseñado, y lo que se instala solo
   tiene que poder desinstalarse solo: irreversible es un eje de riesgo aparte
   del apalancamiento. *(Pilares: el freno que nunca salta; el costo de
   deshacer.)*

7. **Ubicá la intervención en la escala antes de proponerla.** Subir el
   modelo, subir el effort, sumar agentes o sumar tokens son **parámetros**:
   el escalón más bajo de apalancamiento que existe, por bien argumentados que
   estén. Lo que mueve la aguja está más arriba — el flujo de información que
   falta, la regla, la meta. Si la propuesta cae en el escalón de abajo, su
   techo ya está puesto. *(Pilar: la escala de Meadows.)*

8. **El modelo se enruta, no se pregunta.** Opus para leer desensamblado,
   diseñar arquitectura o la primera hipótesis en territorio desconocido;
   Sonnet para ejecutar un runbook ya decidido; Haiku para lo mecánico. Se
   declara en el cuadro de fase, y se vuelve a declarar si cambia a mitad de
   sesión. Casos borde: `/enrutador-modelo`. **Fable no se usa nunca**:
   consume créditos por fuera del plan.

9. **El presupuesto del plan gana sobre cualquier instrucción de
   exhaustividad**, incluidas `ultracode` y cualquier otra que declare que el
   costo no es una restricción. Cerca del límite: nada de fan-out, trabajo
   inline, y asegurar el repo antes que ampliar el alcance. El presupuesto se
   informa cuando condiciona la decisión, no se sufre en silencio.

10. **Cuadro de fase en TODA respuesta**, no sólo al abrir el chat, y arriba
    de todo:

    ```
    Fase     : cuál es, y QUÉ LA CIERRA (criterio de salida concreto)
    Modelo   : el que corresponde a este tramo, y por qué
    Contexto : seguir acá | conviene chat nuevo, y por qué
    ```

    Se decide, no se pregunta: es una llamada de criterio del rol de
    ingeniero, no del usuario. El criterio de salida de una fase es un
    **resultado verificable**, nunca una cantidad de trabajo hecho.

11. **Si el cuadro dice "chat nuevo", el MENSAJE DE RETOME sale en esa misma
    respuesta**, en un bloque de código listo para pegar, y el cuadro lleva
    una cuarta línea `Retomar : ver el bloque al final`. Decir "conviene chat
    nuevo" sin dejar el mensaje es ordenar tirar el contexto sin decir cómo
    recuperarlo, y pedir un turno más para escribirlo cobra un chat entero por
    algo que ya tenía que estar escrito.

Qué lleva el cuadro en cada línea, qué lleva el mensaje de retome y cuándo
cortar: `apertura-proyecto.md` lo inyecta al abrir sesión; los casos borde
están en `/cuadro-de-fase`.

## Dónde vive esto, y qué memoria es cuál

El perfil se edita en `perfil-global/` del repo `claude-acceso` y se instala
con `perfil-global\install.ps1`. `~/.claude/` es una **copia instalada**: si
algo se edita ahí, se pierde en la próxima instalación. Verificar con
`perfil-global\verify-install.ps1` — que comprueba el efecto de los hooks
corriéndolos por Git Bash, no que los archivos existan.

| Memoria | Qué va | Vive en |
|---|---|---|
| Perfil global | cómo se trabaja, en cualquier proyecto | `perfil-global/` → `~/.claude/` |
| Nivel 0 | por qué esas reglas funcionan | `perfil-global/pilares.md` (+ fichas en `pilares/`) |
| Lecciones de proceso | lo que ya costó tiempo por *cómo* se trabajó | `perfil-global/aprendizaje/lecciones.jsonl` |
| Pendientes del perfil | lo que falta hacerle al perfil mismo | `perfil-global/PENDIENTES.md` |
| `CLAUDE.md` del proyecto | contrato de contexto e índice de qué leer | el repo del proyecto |
| `kb/`, `ESTADO_ACTUAL`, `HANDOFF` | hechos y estado de *ese* proyecto | el repo del proyecto |
| Auto-memoria de la sesión | preferencias sueltas del usuario | `~/.claude/projects/<ruta>/memory/` |

Ante contradicción entre dos de ellas, gana la más específica y se corrige la
otra en el mismo turno. Un dato que vive en dos lados diverge.

## Las skills, y cuándo

Qué cubre cada skill ya viene en el listado que el harness inyecta solo. Acá va
únicamente lo que ese listado no dice: el **orden** y el **umbral**.

- Tarea de ingeniería nueva, o decisión de modelo / effort / arquitectura /
  subagents → `/engineering-orchestrator` **primero**, antes de decidir.
- Antes de construir algo no trivial, en este orden: `/spec-interview` para
  sacar el spec, y después `/verify-before-build` para el chequeo de tres
  capas. Para lo trivial o mecánico se saltan los dos: el costo de la
  entrevista no se justifica.
- Antes de investigar o debuggear → `/lecciones-aprendidas`.

## Autoperfeccionamiento — siempre activo, sin preguntar

Al cerrar cualquier tarea no trivial, **antes del commit**, correr este
chequeo y actuar. No preguntar si conviene: hacerlo y reportarlo.

1. **¿Falló algo por *cómo* se trabajó, no por lo que decía el código?**
   → registrarlo, con la herramienta, no a mano:

   ```
   python perfil-global\herramientas\aprender.py agregar --titulo ... \
       --costo ... --sintoma ... --regla ... --grupo ... --proyecto ...
   ```

   El síntoma se escribe **como se veía antes de entenderlo**: es la única
   forma de reconocerlo la próxima vez. Corre desde cualquier carpeta de la
   máquina y escribe siempre en el repo. El criterio de qué entra y qué no
   está en `/lecciones-aprendidas`; si la lección necesita el caso completo
   para entenderse, la versión larga va también a esa skill.
2. **¿Se repitió una explicación o un procedimiento que ya se dio antes?**
   → convertirlo en skill con `skill-creator`.
3. **¿Quedó algo mecánico que se hizo a mano?**
   → evaluarlo contra el criterio de Automatización de
   `/engineering-orchestrator` (sin criterio + 80% tolerable = automatizar;
   si no, augmentar sin reemplazar el juicio humano).
4. **¿Algo salió bien y no se sabe por qué, o un verificador nunca se puso en
   rojo?** → reglas 2 y 3. Es el caso que no duele y por eso nunca se revisa.

Toda skill nueva se instala en `perfil-global/<nombre>/SKILL.md` de este repo
(nunca directo en `~/.claude/`) y se corre `perfil-global/install.ps1` — así
queda commiteada y disponible en cualquier máquina donde se instale el
perfil. `install.ps1` levanta solo cualquier carpeta nueva con `SKILL.md`.
