# 17 — Lo que le falta al coop: el registro entero

> Nació el 2026-09-28 (97), a pedido de Fran: «registrá todo lo que falta y pensá en cosas nuevas que falten».
> Es la **lista de trabajo** de COOP-B; el **plan** para atacarla es `docs/16-contexto-j2.md`. Cada fila lleva su
> grado de evidencia y si se puede avanzar **en frío** (nube: decompilado, ELF, volcados) o necesita **vivo**
> (notebook: emulador, mandos, Fran jugando). Cuando una fila se cierra, se anota la entrada de la bitácora que
> la cierra; no se borra.

## Fuera de la caja: son tres preguntas, no treinta arreglos

BLACK se escribió para **un** jugador. Todo lo que falta cae en una de tres clases, y cada clase tiene **un**
arreglo de arquitectura, no uno por síntoma:

| Clase | Qué es | Arreglo de fondo | Filas |
|---|---|---|---|
| **A. Lo que el jugador TIENE** | vista en primera persona, HUD, sonido «del jugador», cámara, agachado: singletons que J usa y J2 comparte | **contexto propio de J2 + conmutarlo** alrededor de su actualización y de la pasada 2 (`docs/16`) | F4 F5 F6 F7 F8 F9 N5 N8 N10 |
| **B. Lo que el mundo le PREGUNTA al jugador** | a quién apunta la IA, quién junta un arma, quién pisa un disparador del guion, alrededor de quién se carga el nivel, quién muere | que la pregunta **recorra a los dos** (o elija el más cercano) donde hoy lee «el jugador» | F1 F10 N1 N2 N3 N4 N9 N12 |
| **C. Lo que se VE del otro** | el cuerpo de cada uno en la mitad del otro, los carteles | títeres y filtro por pasada (lo que ya hay, extendido) | F3 F11 F12 N11 |

La pregunta de frío que separa A de B es la misma: **cada lectura de «el jugador» en el código** (el puntero
global, `jugadores[0]`, la cuenta = 1) — ¿es algo que J **tiene** (conmutar) o algo que el mundo **pregunta**
(generalizar)? Ese censo es la tarea 1 de la nube.

## Lo que ya se vio (Fran o las sondas)

| ID | Qué falta, en criollo | Evidencia | Pista | Frío / vivo |
|---|---|---|---|---|
| F1 | **J2 no puede juntar armas** del piso (cuadrado mantenido, «HOLD □ TO PICK UP») | Fran, (97); J1 sí junta (96, `b1` = agarrar) | **(98) `confirmado en frío`:** la consulta es `FUN_00126328` → `FUN_00127118` y mide contra `J+0xA0` por el global del juego; el arma candidata vive en **un** lugar, `pickups+0x5848`, y el control de cada jugador (`FUN_0013F618`, acción `0xD`) la toma para **su** jugador: J2 juntaría el arma cercana a J. Diseño en T3 | frío: buscar el texto «PICK UP» y quién lo pide; vivo: la sonda |
| F2 | J2 **cambiar de arma** (6/7) | sin probar: J2 arranca con una sola arma (93z) | mismo camino que F1 después de juntar | vivo, cuando F1 ande |
| F3 | **J1 no tiene cuerpo** en la mitad de J2 | Fran, (97) | J2 tiene títere (un aliado del nivel que copia su matriz, (85)); J no | frío: cuántos aliados vivos hay por nivel, si dos títeres entran; alternativa: soldado de spawner (93i) |
| F4 | a J2 **no le suena el disparo**; sus impactos suenan flojos | Fran de oído (96); `probable`: el aislador `0x001D6F90` saltea el camino que lleva el sonido | clase A | frío: `FUN_001d7020`, `FUN_00283e78` id `0x85C` |
| F5 | **HUD de J2** (vida, munición, arma, mira, ícono de agachado) | pendiente (d) desde (90) | clase A: el HUD lee a J / `V` | frío: quién dibuja el HUD y de dónde lee |
| F6 | **agacharse agacha a los dos** | Fran (96); botón 11 | **(98): no es un singleton** — el agachado es `ctrl+0x30`, por jugador (`FUN_0013F618`, acción `0xC`); sólo el ícono es único. La causa de «los dos» queda para T6 | frío |
| F7 | **el arma de J1 se dibuja en la mitad de J2** («mergeada») | 2 videos de Fran (96); `C` = J refutado; depende del puerto (`hipótesis`) | no la dibuja el nodo J del filtro | frío: qué se dibuja fuera de `FUN_001297A0`; por qué el puerto (`J+0x588`) |
| F8 | **fogonazo y recarga de J2 en la mitad de J1** (E5) | video del fork (96) | partículas: no son nodos del filtro | frío: el emisor del fogonazo, qué pasada lo dibuja |
| F9 | un arma chica **flotando** frente a la pared en la mitad de J2 (E4) | captura de Fran 15:01 (96) | ¿F7? | se mira con F7 |
| F10 | **si J2 muere, se termina la partida** (B5) | en frío (93u): `FUN_0013ffa0(ctrl, 5)` no mira quién es; en vivo no midió dos veces (95) | clase B + decisión de diseño | frío: diseño «caído / reaparece junto a J»; vivo: la sonda sin aliado |
| F11 | en **3 de 8 niveles J2 no tiene cuerpo** (Wilderness, Steelworks, Gulag: no hay aliado) | (93i) | soldado de spawner con bando 0 y grupo 4 sirve (prototipo), gasta un spawner del guion | espera decisión de Fran |
| F12 | los **carteles centrados** caen sobre el corte de la pantalla | visto (96) | clase C | frío: quién dibuja el texto y con qué centro |

## Lo que se me ocurre y nadie midió todavía (todas `hipótesis`)

| ID | Qué podría faltar | Por qué lo sospecho | Frío / vivo |
|---|---|---|---|
| N1 | **¿los enemigos le apuntan a J2?** Si la IA sólo elige a J, J2 es invisible para ellos y el coop pierde la gracia | **(99) `confirmado en frío`:** el blanco es genérico (amenazas por id del registro y bando), pero las puertas «ver» y «visibles» recorren **J + 16 agentes**: J2 no está. Sólo entraría por daño (`probable`). Diseño elegido y sonda en `docs/16` («Clase B, la IA») | vivo: la sonda de `docs/16` |
| N2 | **¿los enemigos le pegan a J2?** (su vida en 0 se regenera (93f), pero el daño real nunca se midió) | ligado a N1; (99): aun tomado por daño, J2 no está en la máscara de visibles (`hipótesis`: no le tiran) | vivo, con la sonda de N1 |
| N3 | **disparadores del guion**: si J2 va adelante, ¿abre puertas, activa oleadas, cierra el nivel? | **(98) `confirmado en frío`**: los disparadores (`FUN_00165DF0` → `FUN_0016A4C0` y 6 formas más) prueban sólo `J+0x190`/`J+0x2E8`; al entrar o salir activan los objetos enlazados o le avisan a la IA (`FUN_00169D48`) | diseño: T8 |
| N4 | **separación**: si J2 se aleja, ¿el nivel se carga alrededor de J y a J2 le falta el mundo? ¿Una puerta que se cierra detrás de J deja a J2 encerrado? | **(98) `probable`**: no hay carga por distancia en las unidades (`0x0040F534/538` son listas de animación); lo que cambia el nivel son los **disparadores**, que prueban sólo a J (= N3). La aparición en caliente (`FUN_00165F30`) también pasa J | red de seguridad: traer a J2 junto a J con un botón |
| N5 | **el sonido se oye desde J**: los tiros de J2 suenan como si estuvieran al lado de J | un solo oyente | frío; con Parsec los dos oyen lo mismo igual, prioridad baja |
| N6 | **pausa**: sólo J1 pausa; ¿qué hace Start en el mando 2? (hoy saltea videos) | — | vivo |
| N7 | **granadas de J2** | BLACK tiene granadas; `b0`/`b10` sin nombre | vivo: nombrar el botón con J1 primero |
| N8 | **apuntar con mira (zoom) de J2**: si cambia el campo visual de la vista única, cambia la de J | clase A | frío |
| N9 | **munición y botiquines del piso** para J2 | misma prueba de cercanía que F1 (`hipótesis`) | con F1 |
| N10 | **vibración** del mando 2 | clase A | vivo, prioridad baja |
| N11 | **cinemáticas en motor y cámara de cine al matar** con la pantalla partida | cortan a una cámara única | vivo |
| N12 | **morir y volver al punto de control / cargar partida**: ¿J2 reaparece bien? (tres cargas seguidas andan (87), pero nunca desde una muerte ni desde un guardado) | — | vivo |
| N13 | **auto-apuntado** de J2 (Fran lo juega apagado) | — | prioridad baja |
| N14 | **rendimiento** en niveles pesados: 64 cuadros/s medido sólo en City Streets | — | vivo: campaña con contador |
| N15 | **Parsec nunca se probó**: que el mando del amigo, remoto, llegue como puerto 2, y la demora | la META lo pide | vivo, **lo hace Fran con el amigo** |
| N16 | **prender y apagar el coop** sin cambiar de acceso (entrar/salir J2 en partida) | comodidad | después de B |
| N17 | **sensibilidad / invertir Y por jugador** (el mod le invierte Y a J2 por la convención de la matriz, (88)) | — | prioridad baja |
| N18 | **dificultad**: el juego está balanceado para uno | decisión de Fran, no de ingeniería | preguntar |
| N19 | **la vida baja de J2 prende el efecto de vida baja del HUD único** (el de J1) | (98) `confirmado en frío` que la actualización de cada jugador (`FUN_0013A300`) llama `FUN_001F2C98`/`FUN_001F2A60(comandos-ui, 0x14/0x18)` con **su** vida; el efecto en pantalla, `hipótesis` | vivo: J2 con poca vida y J con toda; clase A (se arregla con el HUD, F5) |
| N20 | **los efectos del mundo se generan alrededor de J** (`FUN_001B1CB8` sobre `0x0040F4D8`) | (98) `confirmado en frío` que leen `J+0xA0`; lo que se nota, `hipótesis` | clase C, prioridad baja |

## Orden (se decide, y se revisa con Fran en la PDR)

1. **El censo A/B** (frío): destraba F1 F3 F4 F5 F6 F10 N1 N3 N4 N8 de una.
2. **Clase A — el contexto de J2** (`docs/16` pasos 2–6): F4 F5 F6 F7 F8 F9.
3. **Clase B — la IA y la cercanía**: N1 N2 F1 N9, después F10 N3 N4.
4. **Clase C — cuerpos**: F3 F11 (esta necesita decisión de Fran).
5. Lo de prioridad baja, al final: N5 N10 N13 N16 N17 N18.

Todo de B se diseña antes de construirse (COOP-B): lo vivo sólo confirma la predicción del diseño, con control.
