# Predicciones de (135c) — el parche 02 del coop (los disparadores del compañero en la unidad que pisa)

Escritas el 2026-10-31 **antes** de compilar y de correr. Fase PLAT-PreA (spike). Traza: L1-07, L1-06 (guion y
zonas para el jugador 2) y F-RED-1/F-RED-2 de `docs/24-fallos-coop.md`.

## Lo que se leyó antes (en frío)

- **El juego prueba las DOS listas de disparadores para su jugador.** El despachador `0x1E7FF0` (código generado del
  port, `generated/game/x86_recomp.51.cpp`, `__imp__sub_001E7FF0`) recorre `mgr+0x48` (cuenta `mgr+0`) **y**
  `mgr+0x4C` (cuenta `mgr+2`), sin mirar de qué unidad es cada una. El mod, para el compañero, sólo la lista cuya
  ranura tiene la unidad del anfitrión (`TestPartner`, `current`). *Leído.*
- **El registro de la corrida en red, releído:** a los 885 s el que cruzó primero fue **el anfitrión** («the advance to
  unit 6 waits for the partner»), y a los 890 avanzaron juntos a la 6. A los 911 la copia del compañero activó la 7
  («unit 7 activated, as the partner's»). Desde ahí **las dos copias siguen en la unidad 6** y no sale un solo
  disparador del compañero en 200 s, hasta que el anfitrión cae (1095). Lectura: el compañero caminaba la zona de la
  unidad 7 (activa, todavía sin «avanzar»), cuyos disparadores viven en la otra lista. Corrige a `docs/24`, que decía
  «el compañero entra primero a la 6».
- **Descartado lo trivial:** el mensaje del disparador tiene tope (`kProbeLines` = 1500) y el registro entero tiene
  803 líneas: el tope no se alcanzó. *Medido.*

## El parche

`parches-coop/02-disparadores-unidad-companero.patch`: `TestPartner` prueba las dos listas, como el despachador del
juego; el mensaje dice de qué unidad era la lista y en cuál está el anfitrión
(`trigger … fired at the partner, unit N's (this player's M)`). Entra limpio en el port (`git apply --check`) y
compila (`clang++ -fsyntax-only`, con su sabotaje en rojo).

## El ensayo (Fran, en la notebook, dos copias por 127.0.0.1)

City Streets desde el menú. **El anfitrión (ventana izquierda) se queda quieto en el arranque.** El compañero
(derecha) avanza solo hasta pasar donde se activa la unidad 2 (en la corrida en red, a los ~71 s) y sigue por esa
zona un par de minutos, sin volver. Después, salir al menú y **volver a entrar al nivel** (segunda carga) y repetir.

| # | Predicción | Con el parche | Control (release) |
|---|---|---|---|
| P1 | En `black.log` del anfitrión salen disparadores del compañero de la lista de la unidad siguiente con el anfitrión en la anterior: líneas `fired at the partner, unit N's (this player's M)` con N > M | ≥ 1 | — (el release no imprime la unidad) |
| P2 | En el anfitrión nacen enemigos de esa unidad (`npc+ … unit N`, N > la del anfitrión) mientras el anfitrión no se movió | ≥ 1 | 0 |
| P3 | Disparadores del compañero mientras está en la zona de la unidad siguiente y el anfitrión quieto | ≥ 1 | 0 |
| P4 | Ninguna caída en dos cargas seguidas (las dos copias abiertas hasta cerrarlas a mano) | 0 caídas | 0 caídas |
| P5 | Lo que ve cada uno: los enemigos que el compañero tiene delante en su ventana aparecen también en la del anfitrión cuando el anfitrión llega | sí | no (el anfitrión los ve recién al pisar él) |

**Lo que refuta:** con el parche, P1 y P2 en 0 con el compañero claramente adelante → la causa no es la lista (o la
zona de la unidad siguiente tiene sus disparadores en otra parte), y el parche no se usa para jugar.
**El riesgo que se mide:** el comentario original del mod dice que las salidas de la otra lista actúan sobre la
unidad actual. Si eso fuera así, P4 o P5 fallan (algo nace o se dispara en el lugar equivocado, o se cae). El juego
mismo las prueba para su jugador, así que la predicción es que no.

**Antes de jugarlo en red con Agustín:** un nivel entero de a dos con el parche, sin caídas.

## Resultados

(sin medir)
