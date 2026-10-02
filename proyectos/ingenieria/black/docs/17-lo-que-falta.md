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

## Cerrado o movido en (111), 2026-10-02 (detalle: bitácora (111), `sesiones/PREDICCIONES-111.md`)

- **N1 y N2 CERRADAS (confirmado con control):** con la IA (prendida por defecto) un enemigo elige a J2 y le baja la
  vida sin que J2 dispare; sin la IA, nunca. Límite: la amenaza actual es la primera percibida.
- **F10 CERRADA por daño real:** un disparo enemigo mata a J2 y sale «MISSION FAILED» con J vivo.
- **F4 confirmado con control y su sonda del concepto (S4) también:** con el aislador J2 no suena; sin él, como J.
  El arreglo es la `V2` propia (`docs/16`, clase A).
- **N4 con diseño y sonda del concepto:** traer a J2 junto a J en la descarga de la unidad vieja (`docs/16`, sección
  nueva; sitio `0x0012DDCC` en `coop-plan-b`). El teletransporte anda (confirmado); el síntoma sin arreglo, sin medir.
- **N12 a medias:** reiniciar misión anda (110); «continuar» no se pudo elegir sin punto de control alcanzado.
- **F1 (y N9) con su sonda del concepto confirmada:** J2 junta el arma que está bajo J, no la suya (`s1_juntar.py`);
  el diseño de `docs/16` (preguntar también por J2, `CAND2`) queda apoyado en algo medido. Construirlo es de la C.
- **F2 CERRADA:** J2 cambia de arma con su mando (confirmado con control).
- **F3 con su sonda del concepto confirmada:** un aliado copiando la matriz de J es el cuerpo de J en la mitad de J2.
- **F5 (HUD) cambia de receta:** el HUD es una lista de dibujo 2D reproducida por `FUN_00278EA0`; las páginas 1/2/6 no
  lo controlan (medido). Ver `docs/16`.
- **N14 medida:** con la pantalla partida, ~30 cuadros/s en cinco niveles y ~24 en Steelworks, Asylum y City Bridge.
- **N6 medida:** sólo J1 pausa y maneja los menús (Start y ✕ del mando 2 no hacen nada, con control). Política v1:
  se acepta; para la C, «difundir» Start de J2 al mando de J (una palabra en el falso) si con Parsec molesta.
- **F7 confirmado en pantalla con control, dirección J2 → J:** el arma que J2 tiene en la mano se dibuja en las dos
  mitades (el último que cambia manda). El arreglo sigue siendo el sub3 propio (B8).

## Lo que ya se vio (Fran o las sondas)

| ID | Qué falta, en criollo | Evidencia | Pista | Frío / vivo |
|---|---|---|---|---|
| F1 | **J2 no puede juntar armas** del piso (cuadrado mantenido, «HOLD □ TO PICK UP») | Fran, (97); J1 sí junta (96, `b1` = agarrar) | **(98) `confirmado en frío`:** la consulta es `FUN_00126328` → `FUN_00127118` y mide contra `J+0xA0` por el global del juego; el arma candidata vive en **un** lugar, `pickups+0x5848`, y el control de cada jugador (`FUN_0013F618`, acción `0xD`) la toma para **su** jugador: J2 juntaría el arma cercana a J. Diseño en T3 → **(100)**: elegida «preguntar también por J2 con respuesta propia» (P2, conmutar el juego, con cabecera sombra); sonda del concepto en `docs/16` | frío: buscar el texto «PICK UP» y quién lo pide; vivo: la sonda |
| F2 | J2 **cambiar de arma** (6/7) | sin probar: J2 arranca con una sola arma (93z) | (100) `probable`: el cambio y el levantar pasan por `FUN_00143D90` → `FUN_001AC960` → el envoltorio de la ranura 3 (93s), por jugador | vivo, cuando F1 ande |
| F3 | **J1 no tiene cuerpo** en la mitad de J2 | Fran, (97) | J2 tiene títere (un aliado del nivel que copia su matriz, (85)); J no. **(105)**: nivel 0 con 2 aliados vivos (4 volcados), nivel 1 con 0. Recomendado: un cuerpo por spawner para cada jugador (anda en los 8 niveles); decide Fran, junto con F11 | espera decisión de Fran |
| F4 | a J2 **no le suena el disparo**; sus impactos suenan flojos | Fran de oído (96); `probable`: el aislador `0x001D6F90` saltea el camino que lleva el sonido | clase A | **(101) `confirmado en frío`**: el sonido del disparo sale de `V` (`FUN_001D6F90` → `FUN_001D7020`, emisor `V+0x40`) y el aislador lo saltea. Elegida: `V2` propia construida con las funciones del juego + conmutar `X+0xC` alrededor de J2 (reemplaza al aislador). Sonda del concepto en `docs/16` |
| F5 | **HUD de J2** (vida, munición, arma, mira, ícono de agachado) | pendiente (d) desde (90) | **(103)**: un solo HUD, dibujado una vez después de la escena; el 2D se corre y recorta pero no se achica (`probable`). **(106) Fran: HUD separado, vida y munición propias, punto de mira funcional para cada uno. (108):** el HUD es una página del sistema de menús; elegido un HUD por jugador dibujado por el mod, retícula en el centro de cada mitad | frío: R5 (qué página tiene qué y cómo esconderla) |
| F6 | **agacharse agacha a los dos** | Fran (96); botón 11 | **(98): no es un singleton** — el agachado es `ctrl+0x30`, por jugador (`FUN_0013F618`, acción `0xC`); sólo el ícono es único. **(103)**: J2 tiene su propio control (`confirmado en volcado`) y la vista 2 sale de `J2+0x100`: nada leído explica «los dos». Sonda con tres hipótesis en `docs/16` T6 | vivo |
| F7 | **el arma de J1 se dibuja en la mitad de J2** («mergeada») | 2 videos de Fran (96); `C` = J refutado; depende del puerto (`hipótesis`) | no la dibuja el nodo J del filtro. **(102) `confirmado en frío` el mecanismo candidato:** R3 comparte el **sub** (el modelo del arma, `pers+0x398+i·0x6C`) con la ranura `i` de J; la variable sería el índice (`J+0x2C3` = `J2+0x2C3`), no el puerto (`hipótesis`). Elegido: un sub propio para R3 | vivo: la sonda de `docs/16` (índice 0 contra 1) |
| F8 | **fogonazo y recarga de J2 en la mitad de J1** (E5) | video del fork (96) | (102): el mismo sub compartido, en la otra dirección (`hipótesis`) | con la sonda de F7 |
| F9 | un arma chica **flotando** frente a la pared en la mitad de J2 (E4) | captura de Fran 15:01 (96) | (102): ¿el sub compartido? (`hipótesis`) | se mira con F7 |
| F10 | **si J2 muere, se termina la partida** (B5) | en frío (93u): `FUN_0013ffa0(ctrl, 5)` no mira quién es; en vivo no midió dos veces (95) | clase B + decisión de diseño. **(105)**: un solo punto de decisión (`FUN_0013FFA0` con el control de J2); cuatro opciones. **(106) Fran: pierden los dos. (108) diseño:** copiar `J+0x5F0` en `J2+0x5F0` en la ventana 1 (la muerte de J2 hace lo que haría la de J) | vivo: S5 con vigilante de escritura en `J+0x5F0` |
| F11 | en **3 de 8 niveles J2 no tiene cuerpo** (Wilderness, Steelworks, Gulag: no hay aliado) | (93i) | soldado de spawner con bando 0 y grupo 4 sirve (prototipo), gasta un spawner del guion | espera decisión de Fran |
| F12 | los **carteles centrados** caen sobre el corte de la pantalla | visto (96) | clase C | frío: quién dibuja el texto y con qué centro |

## Lo que se me ocurre y nadie midió todavía (todas `hipótesis`)

| ID | Qué podría faltar | Por qué lo sospecho | Frío / vivo |
|---|---|---|---|
| N1 | **¿los enemigos le apuntan a J2?** Si la IA sólo elige a J, J2 es invisible para ellos y el coop pierde la gracia | **(99) `confirmado en frío`:** el blanco es genérico (amenazas por id del registro y bando), pero las puertas «ver» y «visibles» recorren **J + 16 agentes**: J2 no está. Sólo entraría por daño (`probable`). Diseño elegido y sonda en `docs/16` («Clase B, la IA»). **(107): código escrito en frío** (`coop_ia.py`, cuatro sitios: ver y visibles con los dos, blancos por defecto y hostil al más cercano), sin instalar | vivo: integrar con `--con-ia` y la sonda |
| N2 | **¿los enemigos le pegan a J2?** (su vida en 0 se regenera (93f), pero el daño real nunca se midió) | ligado a N1; (99): aun tomado por daño, J2 no está en la máscara de visibles (`hipótesis`: no le tiran) | vivo, con la sonda de N1 |
| N3 | **disparadores del guion**: si J2 va adelante, ¿abre puertas, activa oleadas, cierra el nivel? | **(98) `confirmado en frío`**: los disparadores (`FUN_00165DF0` → `FUN_0016A4C0` y 6 formas más) prueban sólo `J+0x190`/`J+0x2E8`; al entrar o salir activan los objetos enlazados o le avisan a la IA (`FUN_00169D48`) | diseño: T8 |
| N4 | **separación**: si J2 se aleja, ¿el nivel se carga alrededor de J y a J2 le falta el mundo? ¿Una puerta que se cierra detrás de J deja a J2 encerrado? | **(98) `probable`**: no hay carga por distancia en las unidades (`0x0040F534/538` son listas de animación); lo que cambia el nivel son los **disparadores**, que prueban sólo a J (= N3). La aparición en caliente (`FUN_00165F30`) también pasa J | red de seguridad: traer a J2 junto a J con un botón |
| N5 | **el sonido se oye desde J**: los tiros de J2 suenan como si estuvieran al lado de J | un solo oyente | frío; con Parsec los dos oyen lo mismo igual, prioridad baja |
| N6 | **pausa**: sólo J1 pausa; ¿qué hace Start en el mando 2? (hoy saltea videos) | — | vivo |
| N7 | **granadas de J2** | BLACK tiene granadas; `b0`/`b10` sin nombre | vivo: nombrar el botón con J1 primero |
| N8 | **apuntar con mira (zoom) de J2**: si cambia el campo visual de la vista única, cambia la de J | clase A. **(103) `probable`**: el stub pone en la pasada 2 el cuaternión y el ojo de J2 pero **no el FOV** (sale de J). Elegido: P3 sobre el FOV (`FOV2`) | frío: qué campo de la cámara lleva el zoom (T7) |
| N9 | **munición y botiquines del piso** para J2 | (100) `confirmado en frío`: misma pregunta que F1 (`FUN_00127118`, tipos 0 y 1) y se aplica en el acto **a J** | sale con la opción 1 de F1 |
| N10 | **vibración** del mando 2 | clase A | vivo, prioridad baja |
| N11 | **cinemáticas en motor y cámara de cine al matar** con la pantalla partida | cortan a una cámara única | vivo |
| N12 | **morir y volver al punto de control / cargar partida**: ¿J2 reaparece bien? (tres cargas seguidas andan (87), pero nunca desde una muerte ni desde un guardado) | — | vivo |
| N13 | **auto-apuntado** de J2 (Fran lo juega apagado) | — | prioridad baja |
| N14 | **rendimiento** en niveles pesados: 64 cuadros/s medido sólo en City Streets | — | vivo: campaña con contador |
| N15 | **Parsec nunca se probó**: que el mando del amigo, remoto, llegue como puerto 2, y la demora | la META lo pide | vivo, **lo hace Fran con el amigo** |
| N16 | **prender y apagar el coop** sin cambiar de acceso (entrar/salir J2 en partida) | comodidad | después de B |
| N17 | **sensibilidad / invertir Y por jugador** (el mod le invierte Y a J2 por la convención de la matriz, (88)) | — | prioridad baja |
| N18 | **dificultad**: el juego está balanceado para uno | **(106) Fran: después**, cuando el coop esté perfecto | después |
| N19 | **la vida baja de J2 prende el efecto de vida baja del HUD único** (el de J1) | (98) `confirmado en frío` que la actualización de cada jugador (`FUN_0013A300`) llama `FUN_001F2C98`/`FUN_001F2A60(comandos-ui, 0x14/0x18)` con **su** vida; el efecto en pantalla, `hipótesis` | vivo: J2 con poca vida y J con toda; clase A (se arregla con el HUD, F5) |
| N20 | **los efectos del mundo se generan alrededor de J** (`FUN_001B1CB8` sobre `0x0040F4D8`) | (98) `confirmado en frío` que leen `J+0xA0`; lo que se nota, `hipótesis` | clase C, prioridad baja |

## Decisiones de Fran (106)

IA a los dos (el más cercano); los recogibles los toma el primero que los agarra; HUD separado con vida, munición y punto de mira propios (el ícono de agachado después); disparadores los maneja J1; si muere cualquiera pierden los dos (reanimación después); los dos jugadores con cuerpo de aliado. Detalle en `docs/16`, «Decisiones de Fran».

## Orden (se decide, y se revisa con Fran en la PDR)

1. **El censo A/B** (frío): destraba F1 F3 F4 F5 F6 F10 N1 N3 N4 N8 de una.
2. **Clase A — el contexto de J2** (`docs/16` pasos 2–6): F4 F5 F6 F7 F8 F9.
3. **Clase B — la IA y la cercanía**: N1 N2 F1 N9, después F10 N3 N4.
4. **Clase C — cuerpos**: F3 F11 (esta necesita decisión de Fran).
5. Lo de prioridad baja, al final: N5 N10 N13 N16 N17 N18.

Todo de B se diseña antes de construirse (COOP-B): lo vivo sólo confirma la predicción del diseño, con control.
