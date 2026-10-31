# 20 — Requisitos del coop (re-línea base, delta SRR/PDR)

> Escrito el 2026-10-30 (sesión 130), **tramo 0** de la Fase C (PDP §4). El coop cruzó las fases A, B y C sin
> requisitos, sin alcance y sin plan de V&V (lo marcó Fran el 2026-10-12). Este documento es el papel que define el
> proyecto: lo ya fabricado se traza contra él (§7) y lo que falta se ordena contra él (PDP §4).
>
> **Fuentes de la forma:** `perfil-global/pilares/nucleo-ise.md` §3b-§4, `alcance-como-se-escribe.md`, GtWR
> (`incose-gtwr/reglas.md`), NASA SEH §4.2 y App. C, cátedra m17/m18/m21. **Fuera de una materia manda la forma de
> NASA**; igual el L0 queda sin números de desempeño, que bajan a L1.
>
> **Grados de cada «Hoy»:** *medido* (se intervino y se vio, con control), *leído* (código leído, sin probar),
> *sin medir*. **Estado de la línea base: ACORDADA por Fran el 2026-10-30** («Sí, acordada»; PDP §6). Un cambio
> desde acá se escribe en este documento con su motivo y su fecha. **El cambio de §10 (la plataforma) también está
> acordado**, el 2026-10-30 en (133): «acuerdo los requisitos»; sus efectos sobre §2-§4 ya están aplicados abajo.

## 1. Antecedentes

BLACK (Criterion, 2006) es un shooter en primera persona de un solo jugador, sin multijugador de ningún tipo. Corre
en PCSX2 en la PC y la notebook de Fran. Desde (76) un segundo jugador existe dentro del juego por un mod en el
pnach; desde (114) se fabrican sus piezas una por una. El motor viene de Burnout, que sí traía pantalla dividida, y
BLACK conserva restos de eso (el HUD de dos jugadores, la cuenta de jugadores, un modo vacío).

## 2. Alcance

| Elemento | Enunciado |
|---|---|
| **Necesidad** (N-01) | Fran quiere jugar la campaña entera de BLACK con otra persona sin que el juego pierda jugabilidad. |
| **Meta** (M-01) | Dos personas terminan la campaña de BLACK jugando juntas. |
| **Objetivo** (O-01) | Completar de a dos cada una de las 8 misiones de la campaña, arrancando desde el menú del juego. |
| **Objetivo** (O-02) | Jugar de a dos sin caídas del juego. |
| **Objetivo** (O-03) | Jugar de a dos con el ritmo de cuadros del juego de uno. |
| **Objetivo** (O-04) | Que cada jugador vea y maneje su propia partida: vista, vida, munición y arma. |
| **Criterio de éxito** | *Completa*: las 8 misiones terminadas de a dos desde el menú, sin caídas. *Mínima*: City Streets entera de a dos, desde el menú, sin caídas. |
| **Misión** | Un mod de la plataforma de BLACK que agrega un segundo jugador en pantalla dividida a la campaña de BLACK. |
| **Hipótesis** | ~~H-01: PCSX2 sigue siendo la plataforma del juego~~ (reemplazada por H-04 de §10, acordado 2026-10-30). H-02: el segundo jugador usa un mando propio conectado a la misma PC. H-03: la otra persona juega en la PC de Fran o por una sesión remota que le entrega a la PC un mando más (Parsec o Sunshine). |
| **Restricción** | RS-01: la versión del juego es la NTSC-U `SLUS-21376`, CRC `5C891FF1` (la impone el disco que tiene Fran). RS-02: el ISO original no se modifica (Fran, freno del repo). RS-03: el trabajo entra en el plan Pro de Claude de Fran (Fran; memoria `presupuesto-gana-sobre-ultracode`). |
| **Autoridad y responsabilidad** | Fran decide alcance, prioridades y pesos, y valida jugando. La sesión diseña, fabrica y verifica. |
| **ConOps** | Fran abre «JUGAR BLACK COOP» y el juego arranca con el coop activo; los dos eligen una misión desde el menú; cada uno juega en su mitad vertical con su mando; si uno muere pierden los dos y reintentan; la pausa es de J1; al terminar la misión pasan a la siguiente, o vuelven otro día desde el punto de control. No nominales: J2 se queda atrás en un cambio de zona o en un evento de guion; uno junta munición; se cae el juego; se juega a distancia por una sesión remota. |

**Entra en la v1:** los 8 niveles; pantalla vertical; HUD por mitad; IA a los dos; si muere uno pierden los dos;
cuerpo para cada uno; recogibles para el primero que llega; zonas y eventos de guion; continuar misión; el arma y el
sonido de cada uno; carteles en las dos mitades; zoom propio; jugar a distancia con un mando remoto.
**No entra:** reanimación; dificultad o balance para dos; PS2 real; red propia del juego; niveles de prueba
(índices 8-11 del selector).
(Decisiones de Fran: KDP-B, (106) y (114), en `docs/18`; KDP-C1 en el PDP §6.)

**Medidas de efectividad (MOE)**, del lado de Fran: MOE-1 misiones terminadas de a dos desde el menú (meta 8);
MOE-2 caídas por hora de juego de a dos (meta 0); MOE-3 cuadros por segundo contra el juego de uno.

## 3. Requisitos L0 (la misión)

El sujeto es **el mod coop**: el pnach del coop más su lanzador, tal como lo instala `coop_mod.py instalar`.

| ID | Requisito | Padre | Verificación | Hoy |
|---|---|---|---|---|
| L0-01 | El mod coop deberá incorporar un segundo jugador a cada misión de la campaña de BLACK. | N-01, O-01 | demostración | medido: J2 en 8 de 8 niveles por el selector |
| L0-02 | El mod coop deberá conservar la jugabilidad del juego de uno durante el juego de a dos. | N-01, O-02, O-03 | ensayo | sin medir de punta a punta |
| L0-03 | El mod coop deberá dar a cada jugador una partida propia en pantalla. | O-04 | demostración | medido en parte |
| L0-04 | El mod coop deberá llevar a los dos jugadores de una misión a la siguiente. | O-01 | demostración | sin medir |

## 4. Requisitos L1 (el sistema: qué y cuán bien)

**KDR** = *key driving requirement*: mueve costo o calendario más que el resto (NASA §4.2.1.2.3).

### Jugabilidad (de L0-02)

| ID | Requisito | Padre | Verificación | Hoy |
|---|---|---|---|---|
| L1-01 | Mientras dos personas juegan una misión, el mod coop deberá correr 60 minutos de juego sin caídas del juego. **KDR** | L0-02 | ensayo: suite de aguante (§6) | no: N27 cae con el pnach por defecto; R4 la tapa y está apagada |
| L1-02 | Mientras dos personas juegan City Streets, Wilderness, Town, Docks o Gulag, el mod coop deberá mantener al menos 28 cuadros por segundo. [TBR] | L0-02 | ensayo | medido ~30 (114) |
| L1-03 | Mientras dos personas juegan Steelworks, Asylum o City Bridge, el mod coop deberá mantener al menos 22 cuadros por segundo. [TBR] | L0-02 | ensayo | medido ~24 (114) |
| L1-04 | Cuando el jugador 1 pausa el juego, el mod coop deberá detener la partida de los dos jugadores. | L0-02 | demostración | medido (114) |
| L1-05 | Cuando el jugador 1 vuelve de la pausa, el mod coop deberá devolver a los dos jugadores al estado de antes de la pausa. **KDR** | L0-02 | ensayo | no: N27, R4 apagada |

### Avanzar por la campaña (de L0-01 y L0-04)

| ID | Requisito | Padre | Verificación | Hoy |
|---|---|---|---|---|
| L1-06 | Cuando la misión descarga la zona del jugador 2, el mod coop deberá ubicar al jugador 2 en la zona del jugador 1 dentro de 5 s. [TBR] **KDR** | L0-01 | ensayo | leído; el problema nunca se vio jugando |
| L1-07 | Cuando el guion de la misión dispara un evento, el jugador 2 deberá sobrevivir el evento en cada caso en que el jugador 1 lo sobrevive. **KDR** | L0-01 | ensayo | no: N21, una bomba del guion mató a J2 rezagado (114) |
| L1-08 | Cuando los jugadores eligen continuar la misión desde un punto de control, el mod coop deberá incorporar al jugador 2 en el punto de control. | L0-04 | ensayo | sin medir: el banco por selector no guarda puntos de control |
| L1-09 | Cuando el jugador 1 termina una misión, el mod coop deberá incorporar al jugador 2 en la misión siguiente. | L0-04 | demostración | sin medir desde el menú |
| L1-10 | Cuando muere uno de los dos jugadores, el juego deberá terminar la misión con la pantalla de misión fallida. | L0-01 | ensayo | medido (111) |

### Cada uno con su partida (de L0-03)

| ID | Requisito | Padre | Verificación | Hoy |
|---|---|---|---|---|
| L1-11 | El mod coop deberá asignar el control del jugador 2 al mando 2. | L0-03 | demostración | medido (82)-(88e); falta con el mando físico desde el menú |
| L1-12 | El mod coop deberá dibujar la escena desde la cámara de cada jugador en una mitad vertical de la pantalla. | L0-03 | inspección de captura | medido (84) |
| L1-13 | El mod coop deberá mostrar la vida del jugador de cada mitad en la mitad del jugador. | L0-03 | inspección de captura | medido (115) |
| L1-14 | El mod coop deberá mostrar la munición del jugador de cada mitad en la mitad del jugador. | L0-03 | inspección de captura | medido (115) |
| L1-15 | El mod coop deberá dibujar en cada mitad el arma en mano del jugador de la mitad. | L0-03 | ensayo con armas distintas | no: F7; la 2d lo arregla y está apagada |
| L1-16 | Cuando el jugador 2 dispara, el mod coop deberá reproducir el sonido del arma en mano del jugador 2. | L0-03 | ensayo | medido el disparo (119); el sonido de cada arma, sin medir |
| L1-17 | El disparo del jugador 2 deberá restar vida a los enemigos alcanzados. | L0-03 | ensayo | medido (85), (111) |
| L1-18 | La IA enemiga deberá elegir como blanco a cada uno de los dos jugadores. | L0-03 | ensayo | medido (111) |
| L1-19 | Cuando el jugador 2 pisa un recogible, el mod coop deberá entregar el recogible al jugador 2. | L0-03 | ensayo | no: J2 junta lo que está bajo J |
| L1-20 | El mod coop deberá dibujar el cuerpo del jugador 1 en la mitad del jugador 2. | L0-03 | inspección de captura | no: J sin cuerpo |
| L1-25 | El mod coop deberá dibujar el cuerpo del jugador 2 en la mitad del jugador 1. | L0-03 | inspección de captura | J2 en 5 de 8 niveles (títere) |
| L1-21 | El mod coop deberá mostrar cada cartel de la misión en las dos mitades. | L0-03 | inspección de captura | probable (120), sin control |
| L1-22 | Cuando un jugador apunta con la mira del arma, el mod coop deberá cambiar el campo visual de la mitad del jugador que apunta. | L0-03 | ensayo | leído |

### Entrega (de L0-01)

| ID | Requisito | Padre | Verificación | Hoy |
|---|---|---|---|---|
| L1-23 | Cuando Fran abre el acceso del coop, el mod coop deberá arrancar el juego con el coop activo con la plataforma de BLACK como único programa abierto. | L0-01 | demostración | medido en PCSX2 (88e); en la plataforma nueva, sin medir |
| ~~L1-24~~ | ~~El mod coop deberá correr con el mando 2 entregado por una sesión remota de Parsec.~~ **Fuera de la v1** (§10, acordado 2026-10-30). | — | — | — |

## 5. Requisitos del sistema habilitante: el banco de prueba (L2-BAN)

NASA llama *enabling product* a lo que hace falta para verificar el sistema sin ser parte de él. El banco es eso, y
su costo pesa en RS-03: cada corrida que la sesión lee gasta plan. Sujeto: **el banco coop**
(`herramientas/banco_coop.py`, a construir; diseño en `docs/21-lluvia-de-ideas-2026-10-30.md` §4).

| ID | Requisito | Padre | Verificación | Hoy |
|---|---|---|---|---|
| L2-BAN-01 | El banco coop deberá correr la suite de regresión de los 8 niveles sin intervención de una persona. | L1-01, RS-03 | demostración | `campana_coop.py` lo hace para la carga; no para pausa, zonas ni aguante |
| L2-BAN-02 | El banco coop deberá medir la precondición de cada escenario antes de medir el efecto del escenario. | L1-01 | inspección del código + sabotaje | sólo en tres bancos sueltos (`arma_pieza_banco`, `f7b_pausa`, `n27_banco`) |
| L2-BAN-03 | El banco coop deberá correr cada escenario de una pieza con la pieza apagada como control. | L1-01 | inspección del código + sabotaje | a mano, banco por banco |
| L2-BAN-04 | El banco coop deberá detectar una caída del juego dentro de los 10 s de ocurrida. | L1-01 | ensayo con una caída provocada | parcial: `ROJO_MUERTO` en un banco |
| L2-BAN-05 | El banco coop deberá clasificar cada escenario en uno de cinco veredictos: verde, rojo, muerto, sin precondición, reventado. | L1-01 | ensayo con un caso de cada veredicto | no |
| L2-BAN-06 | El banco coop deberá imprimir en la consola a lo sumo 40 líneas por corrida de la suite. | RS-03 | inspección de la salida | no: cada banco imprime su propio registro |
| L2-BAN-07 | El banco coop deberá decidir cada veredicto con datos leídos de la memoria del juego. | RS-03 | inspección del código | parcial |
| L2-BAN-08 | Mientras corre la suite de aguante, el banco coop deberá mover a los dos jugadores a la vez con entradas generadas desde una semilla. | L1-01, L1-02 | demostración | no: hoy se mueve a un jugador por vez |
| L2-BAN-09 | Cuando un escenario termina en rojo, el banco coop deberá guardar la semilla, la foto de estado de partida y el registro de entradas del escenario. | L1-01 | ensayo | no |
| L2-BAN-10 | El banco coop deberá terminar la suite de regresión dentro de 45 minutos de reloj. [TBR] | RS-03 | ensayo | la campaña por selector, ~40 min (93) |

## 6. Plan de verificación y validación

**Verificación** (¿cumple cada «deberá»?) = la columna «Verificación» de §3-§5, con su banco:

| Banco | Verifica | Estado |
|---|---|---|
| suite de regresión del banco coop: carga + pausa + dos cargas por nivel | L1-01 (parcial), L1-02, L1-03, L1-04, L1-05 | a construir sobre `campana_coop.py` y `n27_banco.py` |
| suite de aguante del banco coop: 10 min por misión, dos jugadores con semilla | L1-01, L1-02, L1-03 | a construir |
| escenarios de zona y guion (fotos de estado antes de cada cambio de zona y de cada evento) | L1-06, L1-07 | a construir: las fotos salen del trazador jugado |
| `hud_pieza_banco.py`, `sonido_pieza_banco.py`, `soporte2_banco.py`, `f7b_pausa.py`, `n27_banco.py` | L1-13, L1-14, L1-16, L1-15, L1-05 | existen; pasan a escenarios del banco coop |
| `pruebas/controles.py` | el plano (`coop_diseno.py`) contra el ELF | verde |

**Validación** (¿sirve para lo que Fran quería?) = jugarlo: el **trazador jugado** (tramo 2) y la Fase D. Lo valida
Fran con otra persona, no la sesión. Se graba con `lanzadores/grabar-gameplay.ps1` y se registra la memoria con
`v4_registro.py`; el registro (no el video) dice dónde se cayó, quién murió y en qué zona.

## 7. Traza de lo ya fabricado

| Pieza | Traza a | Estado |
|---|---|---|
| J2 en la carga, atado, con mando 2 (B3, (86)-(88e)) | L0-01, L1-11, L1-23 | prendida |
| Pantalla dividida (B1, (84)) | L1-12 | prendida |
| IA a los dos (B4, (111)) | L1-18 | prendida |
| Títere: cuerpo de J2 desde un aliado (B2, (88)) | L1-25 | prendida, 5 de 8 niveles |
| HUD doble (pieza 1, (115)) | L1-13, L1-14 | prendida |
| Sonido del disparo de J2 (pieza 2a, (119)) | L1-16 | prendida |
| Sub3 (pieza 2b, (120)-(123)) | L1-15 | apagada: no arregla F7 |
| Soporte propio de J2 (pieza 2d, (125)-(126)) | L1-15 | apagada: traba la pausa |
| Pausa en montón propio R4 ((128)) | L1-05, L1-01 | apagada hasta su regresión |
| Saltear videos con Start ((93w)) | ninguno: **huérfano**, comodidad del banco y de Fran; se queda porque no toca la partida | prendida |

## 8. Riesgos (con el triángulo: desempeño = jugabilidad y ritmo; costo = sesiones y plan; plazo)

| Riesgo | Toca | Disparador observable | Respuesta |
|---|---|---|---|
| N27: caída al cambiar J2 de arma después de una pausa | L1-01, L1-05 | la suite de regresión da muerto en la pausa | R4 por defecto (tramo 1) |
| N21: el guion mata a J2 rezagado | L1-07 | J2 muerto en un evento con J vivo | pieza 5 (tramo 3) |
| El tope de memoria del stub (93 de 96 y 111 de 112 palabras) | costo de cada pieza nueva | una pieza que no entra | P4: 128 MB de PCSX2 (spike) |
| F7b: el doble búfer del arma es de un jugador | L1-15, L1-16 | la mitad de J con el arma de J2 | tramo 6, después de P4 y del prototipo |
| El ritmo baja con cada pieza | L1-02, L1-03 | la suite mide menos de 28 / 22 | cada pieza se prende sólo si la suite no baja |
| Sesión remota sin mando 2 | L1-24 | Parsec no entrega un segundo mando a PCSX2 | Sunshine + Moonlight |
| El plan se gasta en bancos que la sesión lee | RS-03 | más de 40 líneas por corrida | L2-BAN-06 |

## 9. Lo que queda abierto en este documento

- [TBR] L1-02, L1-03: 28 y 22 cuadros por segundo salen de lo medido en (114) menos un margen de 2; los cierra la suite
  de regresión con su primera corrida (la sesión, tramo 1).
- [TBR] L1-06: 5 s salen de lo que tarda hoy el «traer» medido; lo cierra el primer escenario de zona.
- ~~[TBR] L1-24~~: fuera de la v1 (§10, acordado 2026-10-30).
- [TBR] L1-26: 1920×1080 en la notebook, 2560×1440 en la PC; lo cierra el spike S1 de (133) con el monitor medido.
- [TBR] L2-BAN-10: 45 min salen de la campaña por selector de (93); lo cierra la primera corrida de la suite.
- ~~El acuerdo de Fran sobre §2 y §3~~: acordado el 2026-10-30.

## 10. Cambio (132), 2026-10-30 — ACORDADO por Fran el 2026-10-30 (133)

> **KDP de plataforma dado** el 2026-10-30 (PDP §6: «Sí, XBERecomp»): H-04 deja de ser condicional. **El alcance del
> programa y los requisitos L0-05..L0-08 y L1-26..L1-30 quedan en línea base**: Fran, en (133), «acuerdo los
> requisitos». El banco L2-BAN sigue escrito para PCSX2 y se rehace sobre la plataforma nueva en la fase siguiente.

**Motivo:** la meta de Fran se amplió el 2026-10-30 («la mejor experiencia de BLACK, coop y no coop: gráficos,
jugabilidad y la mayor personalización y mods posibles; me da igual emulador o nativo en PC»), y el trade de
plataforma (`docs/22` §5) propone dejar PCSX2. Hasta el sí de Fran esto es **borrador**: la línea base de §2-§8 sigue
vigente. El sujeto nuevo es **la plataforma de BLACK**: el programa con el que Fran juega BLACK en su PC (el
ejecutable, sus ajustes y los mods que lleve).

**Alcance del programa** (encima del alcance del coop de §2, que pasa a ser uno de sus proyectos):

| Elemento | Enunciado |
|---|---|
| **Necesidad** (N-02) | Fran quiere jugar BLACK en su mejor versión, solo y de a dos. |
| **Meta** (M-02) | BLACK se ve mejor que en su consola original. |
| **Meta** (M-03) | BLACK se juega fluido y con los controles a gusto de cada jugador. |
| **Meta** (M-04) | BLACK se personaliza: texturas, reglas del juego y controles. |
| **Objetivo** (O-05) | Jugar la campaña a la resolución nativa del monitor de Fran, a 60 cuadros por segundo o más. |
| **Objetivo** (O-06) | Reemplazar texturas del juego por archivos propios. |
| **Objetivo** (O-07) | Cambiar reglas del juego (daño, munición, enemigos, armas) sin modificar los archivos originales del juego. |
| **Objetivo** (O-08) | Reasignar cada acción del juego a teclado, mouse o mando. |
| **Hipótesis** | H-04: la plataforma es el port BLACK-XBERecomp sobre la ISO Xbox USA de Fran (`docs/22`, si Fran da el sí); reemplaza a H-01. H-05: el coop de la misma PC sale de dos instancias del coop en red de un tercero o de una pantalla dividida propia; lo decide el primer spike en vivo. |
| **Restricción** | RS-04: el `default.xbe` de la ISO de Fran es el NTSC-U `df2739c3…68f6` (lo imponen los ports; medido en (132)). RS-02 y RS-03 siguen. |
| **No entra** | Niveles nuevos (Fran, 2026-10-30); jugar a distancia en la v1 (L1-24 queda fuera); Switch, macOS y Linux. |

**Requisitos L0 nuevos** (la misión del programa; sin números, que bajan a L1):

| ID | Requisito | Padre | Verificación |
|---|---|---|---|
| L0-05 | La plataforma de BLACK deberá correr la campaña completa de un jugador. | N-02, O-05 | demostración |
| L0-06 | La plataforma de BLACK deberá permitir modificar la imagen del juego. | M-02, O-06 | demostración |
| L0-07 | La plataforma de BLACK deberá permitir modificar las reglas del juego. | M-04, O-07 | demostración |
| L0-08 | La plataforma de BLACK deberá permitir reasignar los controles del juego. | M-03, O-08 | demostración |

**Requisitos L1 nuevos:**

| ID | Requisito | Padre | Verificación |
|---|---|---|---|
| L1-26 | Mientras un jugador juega la campaña, la plataforma deberá mantener al menos 60 cuadros por segundo a la resolución nativa del monitor de Fran. [TBR: 1920×1080 en la notebook, 2560×1440 en la PC] | L0-05, O-05 | ensayo: contador de cuadros, 10 minutos por misión |
| L1-27 | Mientras un jugador juega una misión, la plataforma deberá correr 60 minutos de juego sin caídas. | L0-05 | ensayo |
| L1-28 | La plataforma deberá dibujar una textura del juego desde un archivo PNG o DDS provisto por el usuario. | L0-06, O-06 | demostración: una textura de control pintada de un color plano |
| L1-29 | La plataforma deberá ejecutar una función propia en lugar de una función del juego elegida, sin modificar los archivos originales del juego. | L0-07, O-07 | demostración: un gancho de control que cambia el daño, con la función original como control |
| L1-30 | La plataforma deberá asignar cada acción del juego a la tecla, el botón del mouse o el botón del mando que elija el usuario. | L0-08, O-08 | demostración |

**Lo que cambia en §2-§8 si Fran da el sí:** la Misión de §2 («un mod de PCSX2…») pasa a «un mod de la plataforma de
BLACK…»; H-01 se reemplaza por H-04; L1-23 cambia «con PCSX2 como único programa abierto» por «con la plataforma de
BLACK»; L1-24 sale de la v1; el banco L2-BAN se rehace sobre la plataforma nueva (hoy es de PCSX2 por PINE). L0-01 a
L0-04 y L1-01 a L1-22 no cambian de enunciado: son del coop y valen en cualquier plataforma.

## 11. Sistema habilitante: poner la plataforma en la PC sin tipear (L2-INS), (134), 2026-10-30

**Motivo:** Fran, en el retome de (134): «control total de la PC desde la notebook, sin tipear nada en la PC». La PC
sólo tiene Ethernet, va por cable directo a la notebook (IP `169.254.x.x` sola, sin internet) y Fran no puede pasarle
texto. Sin esto, instalar la plataforma en la PC (L1-23) y después medirla ahí (L1-26, L1-27) depende de que Fran
tipee comandos largos. Es un *enabling product*, como el banco (§5): no es parte del juego.

**Lo que esto NO es, y por qué.** La primera lectura fue un agente de control remoto a medida en la PC (que ejecute
lo que la sesión le mande). Se descartó: es la opción de **más** trabajo y más riesgo de las tres del retome, código
sensible (ejecutar cualquier comando, servir archivos, autenticar) para algo que el transporte que ya existe resuelve
casi entero, y choca con «cambios mínimos» y «lo que se instala solo se desinstala solo». Lo que Fran rankeó primero
en su propio retome es el **pendrive con un `.bat` de doble clic que corre `TRAER`** — y eso ya deja la PC instalada,
con su calidad gráfica y los accesos, **sin que Fran tipee nada**. El sujeto es el instalador: el `.bat` que la PC
corre con un doble clic, encima de `TRAER.ps1`/`PAQUETE-PC.ps1`/`SERVIR-A-LA-PC.ps1`, que ya están probados en la
notebook ((133b)).

| ID | Requisito | Padre | Verificación | Hoy |
|---|---|---|---|---|
| L2-INS-01 | Cuando Fran hace doble clic en el instalador del pendrive en la PC, el instalador deberá copiar a la PC cada archivo de la plataforma con el mismo sha256 que en la notebook. | L1-23 | ensayo: corrida de `TRAER -SoloCopiar` contra un manifiesto, sha256 de los dos lados | `TRAER.ps1` lo hace; falta el `.bat` y la PC real |
| L2-INS-02 | Cuando termina de copiar, el instalador deberá dejar en la PC los accesos del juego y la calidad gráfica de esa máquina, sin pedir texto. | L1-23, L1-26 | demostración en la PC: accesos en el Escritorio | `TRAER` corre `PREPARAR`; falta la PC real |
| L2-INS-03 | Cuando una copia se corta, el instalador deberá retomar desde donde quedó al volver a correrlo. | L1-23 | ensayo: cortar y reanudar; sólo bajan los que faltan | `TRAER` saltea lo que ya coincide por sha256 |
| L2-INS-04 | El instalador deberá correr en la PC con sólo lo que trae Windows 10 y 11 (ni internet ni programas de terceros). | L1-23 | inspección: `curl.exe`/`powershell` de Windows; Python y pygame van en el paquete | el paquete los trae (`PAQUETE-PC`) |

**El control remoto en vivo queda como decisión de Fran, fuera de esta sesión.** Para (b) —poner todo en la PC— y (c)
—jugar el coop por red— el instalador alcanza: Fran hace doble clic, la PC queda lista, y después abre el acceso
«coop - unirse». Si en algún momento quiere manejar la PC en vivo (ver la pantalla, correr algo sin tocarla), sobre un
cable sin internet eso es **Escritorio remoto (RDP)** y sólo si la PC es **Windows Pro**: lo prende Fran en
Configuración → Sistema → Escritorio remoto, y la sesión se conecta con `mstsc` a la `169.254` de la PC. RDP **bloquea
la consola de la PC** mientras está conectado (no se puede jugar en la PC a la vez) y pide contraseña en la cuenta: por
eso no es el camino para jugar, sólo para administrar. Quick Assist / RustDesk / VNC quedan afuera: Quick Assist pide
internet (la PC no tiene); los otros, instalar un tercero y abrir el firewall.
