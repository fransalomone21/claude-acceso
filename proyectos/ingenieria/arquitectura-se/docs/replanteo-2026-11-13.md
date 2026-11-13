# Replanteo del método, de arriba hacia abajo — 2026-11-13

**Qué es.** La revisión de rumbo que la cascada pedía (16 sesiones desde la última lluvia; umbral 10) y que Fran pidió
el 2026-11-13: entender qué busca la arquitectura, replantearla desde el nivel más alto y dejar el plan hasta el más
bajo. Fase 7 (tipo D): un cambio de diseño vuelve a revisión; **esto es la propuesta para esa revisión, nada vivo se
tocó**. Motor: Fable 5.2, un solo hilo (regla 8 suspendida hasta el 16/11 sólo para esto).

Pedidos de Fran en la sesión (textuales, resumidos sin cambiar el sentido): maximizar el triángulo de hierro; que el
método se automejore; arquitectura portable, evolucionable, simple y robusta; que no haya divergencia entre sus
máquinas (método y proyectos al día en cualquiera); propuestas para optimizar todo lo demás que hace; guardar las
herramientas más efectivas; un retome para optimizar y ordenar su dispositivo.

## 1. Lo medido el 2026-11-13 (en la PC, con las herramientas del repo)

Instrumentos: `cascada_puerta.py --exige`, `--tronco`; `.claude/auditorias/uso-lecturas.jsonl` (58 muestras);
`defectos.py` (la vista); `verificar-sincronia.ps1`; el arranque de la sesión.

| Qué | Valor | Grado |
|---|---|---|
| Lectura obligatoria al entrar: fisica-espacial `materia` | 340 495 caracteres (~97 K tokens), 32 lecturas | confirmado |
| ídem malena / TP de IISE | 254 289 / 274 005 | confirmado |
| ídem BLACK `ingenieria-inversa` / telescopio `diseno` | 410 967 / 281 642 | confirmado |
| ídem ps2-casa `ninguna` (un proyecto chico) | 203 994, de los cuales 123 714 son tronco | confirmado |
| ídem arquitectura-se `metodo,diseno` (sin temas; con cuatro temas esta sesión leyó ~520 K) | 366 899 | confirmado |
| El tronco (libro + fuentes de requisitos y alcance) | 141 824 solo; 123 714 dentro de un proyecto | confirmado |
| **Uso declarado de lo exigido**, `proyecto:documentos` (40 muestras) | **75 de 1 297 lecturas: 6 %** | confirmado (sensor: lo que declara la sesión, DA-043) |
| ídem `proyecto:ingenieria` (16 muestras) | **52 de 412: 13 %** | ídem |
| Propuestas de retiro que el lazo de uso ya emitió y nadie decidió | 38 (documentos) + 28 (ingeniería) = 66 | confirmado |
| Defectos de arquitectura | 126: 86 abiertos, 40 arreglados, **0 validados** en un mes | confirmado |
| Requisitos del método con resultado (T16) | 0 verificados de 213 | confirmado |
| Rojos del arranque | 5, más 1 sin medir; saboteadores en rojo hace 25 días | confirmado |
| Sincronía de esta máquina | malena 13 commits atrás de origin | confirmado |
| Costo por agente que escribe (12/11) | 153-204 K tokens; el número impreso decía ~110 K | confirmado (4 muestras) |

## 2. El diagnóstico, por nivel de Meadows

**Paradigma (lo más alto).** El método controla **leyendo**: «la sesión no actúa hasta haber leído X». Eso es medir
una precondición, y la regla 3 del perfil dice que verificar es ver el efecto. Tres datos lo confirman: el uso de lo
leído es 6-13 %; el error que originó el tronco (el L0 del TP de IISE) ocurrió con el conocimiento en el repo y no
llegó **al momento de escribir**; y la lección propia del proyecto ya lo decía: «inyectar no es entregar» (2026-09-17).
T1 eligió bien para el chequeo de trabajo: **núcleo corto + la viñeta al paso**. T19 hizo lo contrario con los libros
(todo al entrar) como cobertura, y dejó escrita su propia salida: el lazo de uso, «lo que sobra sale con el sí de
Fran». El lazo ya midió. Recortar no contradice la decisión del 19/10: es su segunda mitad.

**Meta.** El pedido de Fran es desempeño > costo > plazo. Hoy el costo de entrar (60-117 K tokens antes de la primera
acción) ya degrada el desempeño por tres vías medidas: hace inviables las sesiones paralelas, empuja a delegar en
agentes que pasan sin puerta (DA-049) y cuyo texto nadie está obligado a revisar (DA-123), y tapa lo importante con
volumen. El costo dejó de ser sólo costo.

**Reglas y auto-organización.** El método sólo suma (DA-041): cada falla agrega un freno, un medidor o una lectura, y
cada arreglo se registra por **caso**. Resultado: 86 abiertos que son, en su mayoría, seis familias (§4). Y el lazo de
mejora no cierra: 0 de 126 validados, porque validar pide un paso manual que ninguna sesión corre.

**Flujos de información.** La alarma del arranque suena siempre (DA-089) y por eso ya no informa. El costo por agente
llega después de decidir (DA-122). La sincronía se mide en rojo y nadie la ejecuta; cuando la sesión quiere traer, la
puerta se lo niega (DA-098).

## 3. La arquitectura que propongo: nueve principios

Cada uno reemplaza mecanismo, no agrega (primero qué se saca).

| # | Principio | Qué se saca | Qué queda |
|---|---|---|---|
| A1 | **Se entrega al paso, no al entrar.** Al entrar: el contrato del proyecto, la vista del estado, el bloque de arriba del HANDOFF, el índice de lecciones y el libro de bolsillo (18 K). Todo lo demás cuelga de un disparador **por rol** | el tronco de fuentes al entrar (~106-124 K por sesión) y lo que el lazo de uso marca sin uso | los conceptos por rol que ya existen (`requisitos`, `alcance`, `freno`, `typst`) y los nuevos por fase (DA-073, DA-081) |
| A2 | **Se verifica el efecto, no la lectura.** Donde hay verificador de salida (lint de Typst, chequeo GtWR, consignas, citas), ése manda; la lectura obligatoria queda sólo donde no hay con qué medir el resultado | lecturas duplicadas por un verificador | los verificadores, con su saboteador |
| A3 | **La puerta decide por lo declarado y por la ruta tocada; una palabra sólo avisa** | la negación por señal en el pedido, en un comando o en un nombre de archivo (DA-056, 057, 072, 083, 118, 120) | la clasificación obligatoria (T19 A) y el freno por ruta |
| A4 | **Toda salida libera todo lo que no es su objeto**: la excepción libera también tronco y conceptos; reclasificar reemplaza; traer el remoto pasa siempre | DA-082, 086, 098, 117, 121 | el registro de cada salida en la caja negra |
| A5 | **Presupuestos con dientes, y uno entra si uno sale**: caracteres del arranque, de la entrada por clase, segundos de hooks. Rojo de verdad en `--verificar`, no TBR | L1-01 y L1-07 como metas sin fuerza | un medidor único de presupuestos con historia |
| A6 | **El lazo de mejora cierra solo**: la auditoría corre `validar` sobre lo elegible; los defectos se agrupan y se cierran por **familia** con un cambio estructural | el paso manual; el arreglo por caso | la exigencia de Fran (commit, prueba, saboteador, 3 sesiones) |
| A7 | **Un dueño por dato y sincronizar como primer y último acto, por hook** (§5) | el rojo de sincronía que nadie ejecuta | git como transporte; `verificar-sincronia` como medidor |
| A8 | **Lo delegado se revisa por construcción** (§6) | la confianza en el grado que el agente se pone | el guardia de fan-out, que sigue preguntando |
| A9 | **Una alarma que suena siempre se arregla o se muda**: cada rojo del arranque lleva edad; pasado el umbral va solo al registro con dueño y sale del cartel | «CHEQUEO CON N ROJOS» permanente | el cartel sólo con rojos nuevos |

Riesgo principal y su control: A1 puede repetir el error del TP de IISE si un disparador por rol no salta. Control: el
saboteador de cada concepto prueba el disparo con el artefacto real (ya existe para `requisitos` y `alcance`), y el
lazo inverso: una recurrencia de lección con su fuente retirada la devuelve sola a la entrada (como T18). Reversible:
el recorte es una clave del catálogo.

## 4. Las seis familias (de 86 abiertos, ~50 caen acá)

| Familia | Defectos | Un solo cambio | Efecto que se tiene que ver |
|---|---|---|---|
| F1 costo de entrada | DA-104, 126, 086, 121, 052, 097, 071, 016, 082 | A1 + A4 + `defectos.py ver <id>` | `--exige fisica-espacial --necesidad materia` ≤ ~120 K (hoy 340 K); una excepción no pide tronco |
| F2 disparo por palabra | DA-056, 057, 072, 083, 118, 120, 087 | A3 | un comando que nombra otro proyecto sin tocar su ruta pasa con un aviso |
| F3 paridad de máquinas | DA-022, 025, 084, 085, 098, 100, 103, 105, 110, 113, 115, 116 | A7 | abrir sesión en cualquier máquina deja todo repo presente al día o en rojo con el motivo |
| F4 delegación | DA-049, 123, 122, 048, 051 | A8 | un agente que edita sin contrato es negado; la auditoría da rojo si nadie leyó su diff; el costo sale antes de decidir |
| F5 el lazo no cierra | DA-089, 043, 019, 061, 111, 037 | A6 + A9 | validados > 0 sin que nadie se acuerde; el cartel del arranque con 0 rojos viejos |
| F6 productos de fase sin exigencia | DA-030, 031, 073, 081, 069, 119, 125 | conceptos por fase y por clase de tarea (A1) | abrir Pre-A exige la evidencia externa; mudar archivos trae sus dos reglas |

## 5. Cero divergencia entre máquinas (pedido del 2026-11-13; N-13, N-06)

Tres clases de estado, cada una con su dueño y su transporte:

| Estado | Dueño | Transporte | Hoy |
|---|---|---|---|
| El método y los proyectos | sus repos de GitHub (claude-acceso, perfil-global, los privados) | git | se mide (rojo), no se ejecuta; la puerta niega el pull (DA-098) |
| Lo instalado (`~/.claude`) | derivado de perfil-global | `install.ps1` / `traer-perfil.sh` | dos instaladores que divergen (DA-085, DA-100) |
| Lo que no va a git: memoria, fuentes, config de rclone, rutas locales, programas | espejo en perfil-global (memoria), Drive por MD5 (fuentes), `bootstrap.ps1` (programas) | cada uno su script | piezas sueltas, ninguna corre sola |

Diseño (una herramienta, dos hooks): `sincronizar.py`.
- **Al abrir** (hook `SessionStart` propio, con plazo interno): por cada repo del registro presente en el disco,
  `fetch`; atrás y limpio → `pull --ff-only`; atrás y sucio, o divergido → ROJO con el motivo, sin tocar nada;
  si perfil-global avanzó → instala; memoria en los dos sentidos con el manifiesto que ya existe. Un repo del
  registro ausente en la máquina se lista con el comando que lo trae. Sin red: SIN MEDIR.
- **Al cerrar cada turno** (el `Stop` que ya existe, `sin-guardar.py`): lo sin commitear y sin pushear de todos los
  repos, no sólo del proyecto declarado.
- **Un solo registro de repos** (`.claude/repos.json`), que lean `sincronizar`, `verificar-sincronia`, `regreso` y
  `estado-nube` (hoy cada uno arma su lista: por eso `regreso` no vio a malena).
- Lo que nunca se sincroniza se declara por máquina (qué programas hay, qué rutas locales existen) en un archivo local
  fuera del repo, y la cascada dice «esta máquina no puede X» en vez de fallar.
- Reversible: los hooks se desinstalan con `.claude\desinstalar-hooks.ps1`. `--ff-only` nunca reescribe ni pisa.

## 6. Delegación (DA-049, DA-123, DA-122)

- **Identidad**: la puerta lleva el estado por agente y no por sesión. `probable`: el harness pone `agent_id` en el
  evento de un hook que corre adentro de un subagente; **se confirma con un marcador antes de construir** (un hook
  temporal que guarda las claves del evento, y un agente mínimo). Si no viene, la alternativa es el `transcript_path`.
- **Contrato reducido para el agente**: el contrato del proyecto y su ficha de lecciones; el brief nombra el tema.
- **Revisión**: pregunta nueva de la auditoría (P14): qué archivos escribió cada agente (se lee de los transcripts de
  `subagents/`) y si el hilo principal leyó cada uno después (un Read o un `git diff` posterior en la caja negra).
  ROJO si hubo escritura delegada sin lectura posterior. Saboteador: un transcript sintético con un Edit delegado y
  sin Read.
- **Costo antes de decidir**: la línea Motor, cuando la sesión propone agentes o Fran pregunta, lleva «N agentes ×
  150-205 K (medido el 2026-11-12, agentes que escriben) = X % de la ventana». El número sale de un registro que se
  actualiza al medir (DA-048), no de una viñeta.
- Con F1 hecho, una sesión paralela cuesta un tercio y el agente deja de ser el atajo.

## 7. La caja de herramientas (pedido del 2026-11-13: guardar las más efectivas)

Ya existen y se quedan: `cascada`, la puerta, `auditar-sesion`, `defectos`, `aprender`, `uso-lecturas`, `retiro`,
`medir-costo`, `medir-arbol`, `divergencias`, `matriz-verificacion`, `lint-typst`, `verificar-sincronia`, `regreso`,
`fuentes`, `problemas`, `vigia` (sólo BLACK). Nueva en esta sesión: [`../medir-entrada.py`](../medir-entrada.py)
(lo exigido por clase y la tasa de uso, en un comando).

Por construir, en orden de apalancamiento:

| # | Herramienta | Qué compra | Familia |
|---|---|---|---|
| 1 | `sincronizar.py` (§5) | cualquier máquina al día sin acordarse | F3 |
| 2 | `presupuesto.py` | todos los presupuestos (arranque, entrada por clase, hooks, tasa de uso) con umbral y una línea de historia por sesión: la tendencia a la vista | F1, F5 |
| 3 | `defectos.py ver <id>` y `familia` | trabajar un defecto sin leer 115 K; cerrar por clase | F1, F5 |
| 4 | `retome.py <proyecto>` | el retome sale del HANDOFF, se valida (rutas que existen, comandos que corren en seco) y va al portapapeles: Fran no arma ni pega a mano (DA-021) | F5 |
| 5 | `checkpoint.ps1 <proyecto> "qué"` | los cuatro pasos de la regla 5 y la auditoría en un comando, agregando por ruta | F5 |
| 6 | `revisar-delegado.py` | qué escribió cada agente y qué diff falta leer (P14) | F4 |
| 7 | `plan.py` | cuánto costó cada sesión (hilo principal y agentes) por proyecto y clase; alimenta la línea Motor | F4 |
| 8 | `rotar-estado.py` | ESTADO y HANDOFF con techo: lo fechado viejo pasa a la bitácora en el checkpoint (DA-016; BLACK 145 K y 270 K) | F1 |
| 9 | `vigia.py` general | lo nuevo de afuera para cualquier proyecto de ingeniería (hoy sólo BLACK) | F6 |
| 10 | `mudanza.py` | mover archivos por permiso, con planilla y «lo nombrado por ruta no se mueve»; hoy vive fuera del repo, en `Desktop\_PLANO\herramientas` (DA-125) | F6 |
| 11 | `maquina.py` | inventario y salud del equipo con antes y después (disco, arranque, servicios, temperatura, batería, SMART); sirve en cada PC | — |

Regla para la caja (A5): una herramienta entra con su saboteador y su fila acá; si reemplaza a otra, la otra sale en el
mismo commit.

## 8. El orden, y qué necesita de Fran

| Tanda | Qué | Motor | Depende de Fran |
|---|---|---|---|
| 1 | F1: el recorte del tronco y de lo sin uso (clave del catálogo), la excepción que libera, `defectos.py ver` | Fable, hasta el 16/11 | **sí**: el recorte (DA-104) y el destino de las 66 propuestas |
| 2 | F3: `sincronizar.py`, el registro de repos, los dos hooks | Fable u Opus | no (es lo que pidió) |
| 3 | F4: el marcador de `agent_id`, la puerta por agente, P14, el costo en Motor | Fable u Opus | **sí**: qué pueden hacer los agentes |
| 4 | F2 y F5: la palabra sólo avisa; `validar` en la auditoría; los rojos con edad | Opus diseña, Sonnet ejecuta | no |
| 5 | F6 y el resto de la caja | Sonnet con runbook | no |

Cada arreglo: requisito L2 antes, prueba en rojo, `defectos.py arreglar`, y el efecto de §4 visto.

### Las decisiones de Fran (2026-11-13, por encuesta en la sesión; la opción elegida, textual)

| Pregunta | Respuesta | Qué fija |
|---|---|---|
| Cómo llegan las fuentes completas de requisitos y alcance (hoy al entrar, ~35 K tokens, uso 6-13 %) | **«Al momento de escribir»**: al entrar queda sólo el libro de bolsillo; las fuentes se exigen cuando la sesión va a escribir un requisito, un alcance o un diseño; vuelven solas si su falta produce un error | Reemplaza la fila del 2026-10-19 «qué es el tronco» de `t19-arbol-de-conocimiento.md` §4. El tronco del catálogo queda sin conceptos; los conceptos `requisitos` y `alcance` siguen disparando por rol (L1-19, L1-23) |
| Qué se hace con las 66 lecturas sin uso en 5 o más sesiones | **«Pasarlas al paso»**: dejan de exigirse al entrar y se exigen al tocar su tema; nunca salen el contrato, el estado, el HANDOFF, los criterios de cátedra ni las lecciones del proyecto | El sí de L1-28, en bloque y con piso. Se aplica en la tanda 1 y se registra con `uso-lecturas.py decidir` en el commit que lo aplica |
| Qué pueden hacer los subagentes | **«Investigan, yo escribo»**: leen, buscan y devuelven texto; sólo el hilo principal escribe en el repo | F4 se simplifica: la puerta niega la escritura de un agente sobre un proyecto (no hace falta contrato reducido); P14 queda como control de que no hubo escritura delegada |
| Pesos para optimizar la notebook | **Espacio en disco, velocidad del día a día, batería y temperatura** (juegos y emuladores, no marcado) | El retome de §10 |

## 9. Propuestas para lo demás que hace Fran

Sólo lo que esta sesión pudo observar o medir; cada una con su grado.

1. **Apagar en la cuenta de claude.ai los plugins y conectores que no usa** (`confirmado` que entran en cada sesión:
   el listado de esta trae SEO, Adobe, Unity, y los conectores de diseño y de transcripción; `probable` el ahorro:
   el 2026-10-02 SEO y Adobe solos medían 29 434 caracteres por sesión). Es de Fran: se apagan en su cuenta.
2. **Un «modo parcial» del 17 al 26/11**: nada de método; sesiones de materia con la entrada ya recortada; el
   Restablecimiento completo reservado, como ya decidió.
3. **Los mapas de temas de BLACK y del telescopio** (pendientes desde el 19/10, L2-VER-12): es lo que baja su entrada
   (BLACK 411 K) sin tocar ninguna regla.
4. **Decisiones suyas que siguen abiertas y frenan cosas**: los 6 accesos compartidos sin declarar en Drive (desde el
   05/11); vaciar la cuarentena de 136 GB (desde el 12/11).
5. **La auditoría fuera de la sesión**: que corra en un hook de cierre y le deje a Fran una línea, en vez de depender
   de que la sesión se audite y se lo cuente (DA-043).
6. **Sonnet para todo lo que ya tiene runbook** después del recorte; Opus sólo para la primera hipótesis y el diseño.
   Con la entrada a un tercio, el mismo plan rinde más sesiones.
7. **Una fuente de verdad para lo que Fran ejecuta** («Lo tuyo»): un archivo `PENDIENTES-FRAN.md` generado desde los
   HANDOFF, que el cuadro copie; hoy sus pendientes viven repartidos en N handoffs.

## 10. Retome para optimizar y ordenar el dispositivo

Guardado acá para que no dependa del chat (regla 12). Se pega en un chat nuevo.

```
Optimizar y ordenar esta máquina (la notebook), midiendo antes y después. Continúa el orden del 2026-11-12.

0. EL LIBRO PRIMERO. Abrir en C:\Users\frans\Desktop\claude-acceso. Comprobar que ~/.claude/CLAUDE.md empieza con
   «# Perfil global». Si no: perfil-global\install.ps1.

1. CLASIFICAR Y LEER. Primer comando, solo:
     .\cascada.ps1 -Suelta "mantenimiento y orden de la notebook: medir, planificar por permiso, nada se borra sin el OK de Fran"
   (no es ingeniería de sistemas: no se escribe ningún requisito; -Ingenieria cobra 40 K tokens de fuentes, DA-126).
   Leer, en este orden: la memoria orden-pc-notebook-2026-11.md y onedrive-sacar-escritorio.md; MAPA.md §1; lo que haya
   en Desktop\_PLANO\herramientas (las reglas por permiso y nombrados_por_el_repo.py); en chequeo-de-trabajo.md, las
   viñetas «Toda lista de EXCLUSION por enumeracion deja una afuera» y «Un ARBOL de carpetas no se mueve con Move-Item».
   NO leer: ningún proyecto.

2. QUÉ SE BUSCA, y qué cierra la sesión: un informe con números de antes y después (espacio libre por disco, tiempo de
   arranque, programas al inicio, RAM en reposo, temperatura y salud de batería y SSD) y cero programas rotos.
   Los pesos de Fran (2026-11-13): espacio en disco, velocidad del día a día, batería y temperatura. Juegos y
   emuladores no son objetivo: no se tocan ni se optimizan.

3. MOTOR: Sonnet, esfuerzo medio; es un runbook. Opus sólo si hay que decidir algo de riesgo (drivers, BIOS). Fable no
   (desde el 17/11 vuelve la regla 8). Sin agentes.

4. ESTADO DE LA MÁQUINA: hay una cuarentena por tipo de 136 GB esperando el OK final de Fran para vaciarse; juegos
   instalados y fotos no se tocan; cero OneDrive (ni carpeta ni servicio); PowerShell 5.1 (sin &&). Cambiar a GPU
   discreta la apaga sola: no es falla. El medidor de batería está descalibrado.

5. YA HECHO, NO REHACER: la mudanza del 2026-11-12 (99 ítems a cuarentena, 14 devueltos), el plano del Escritorio y
   Descargas como bandeja. Lo registrado en DA-125.

6. EL ORDEN: (a) medir todo, sin tocar, a un archivo; (b) plan por PERMISO (lista blanca de lo que se puede mover o
   apagar; lo que un programa o el repo nombra por ruta no se mueve); (c) mostrarle a Fran el plan con cuánto libera
   cada paso; (d) ejecutar lo reversible; lo que pide administrador, en UN .ps1 con ruta absoluta que Fran sólo corre;
   (e) medir de nuevo; (f) dejar la herramienta en el repo (maquina.py y mudanza.py: hoy están fuera).

7. LO QUE SE TIENE QUE VER: la tabla de antes y después con el mismo instrumento; la cuarentena vacía sólo con el sí
   escrito de Fran; `.\verificar-estructura.ps1` en verde al terminar.
```
