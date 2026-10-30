# Predicciones de (133) — escritas ANTES de medir

Sesión (133), 2026-10-30, **notebook** (MSI Sword 15, RTX 4060 Laptop, monitor 1920×1080 a 144 Hz, medido; el
retome decía «en la PC»). Fase PLAT-PreA (NASA Pre-Phase A). Es el primer spike en vivo sobre la plataforma elegida
(BLACK-XBERecomp). Cada predicción con su control; el resultado va abajo de cada una, en el mismo lugar, y si la
medición la contradice se corrige acá diciendo que se corrigió.

## Lo que cambió el plan antes de medir (leído en frío, grado *leído*)

- **El release de `black-seamless-coop` es el port entero con el coop adentro** (`BLACK.exe` de 15 MB, zip
  `BLACK-Seamless-Coop-8226900.zip`, 7 011 432 B, sha256 `7FABD5C6…9D21`, release v2026.10.18.2). Se instala una
  sola copia: sirve para S1 (sin `--coop`, un jugador) y para S2.
- **Dos copias en una PC: la que no tiene el foco NO lee ningún mando**, a propósito
  (`patches/upstream.patch`, `CoopBackground()`: «two co-op copies on one PC share the controllers: the one in the
  background neither reads nor drives them»). Tal como viene, dos personas no pueden jugar a la vez en una PC.
- **La salida está en el mismo código:** con `--coop-control <puerto>` la copia toma su mando del canal de control
  (UDP en 127.0.0.1), «in front or not» (`coop_control.cpp`, `Override`), y además no se pausa al perder el foco.
  El canal acepta `pad a,rt <ms>` / `hold`, `stick lx ly rx ry <ms>` (−1..1), `release` y `state`. Sin teclado ni
  mouse en esa copia.
- **El puente de mandos** (`herramientas/puente_mandos.py`, escrito en esta sesión): lee los dos mandos físicos con
  SDL (pygame) y le manda a cada copia el suyo por su canal. Los gatillos y los botones analógicos pasan como
  todo-o-nada (el canal los pone en 0xFF): suficiente para disparar y apuntar; riesgo anotado.

## S1 — el port corre con la ISO de Fran (L1-26 parcial, L1-27 parcial)

- **Predicción:** con `Black (USA).iso` en `assets`, la primera vez compila el código (minutos) y llega al menú; la
  primera misión corre a **≥ 60 cuadros por segundo** a 1920×1080 en esta notebook, medido con el contador del port
  (`fps_counter = true`) en 10 minutos de juego, sin caídas.
- **Control:** el `default.xbe` de la ISO es el NTSC-U `df2739c3…68f6` (`herramientas/xbe_de_iso.py`), y el log
  (`logs\black.log`) nombra la ISO y termina sin error.
- **Si falla:** si no compila, se lee el log antes de culpar a la plataforma; si da < 60, se mide con `fps_cap` y la
  resolución bajada antes de concluir nada sobre la notebook.

### Resultado de S1
*(pendiente: lo corre Fran con `lanzadores\PROBAR-PLATAFORMA-S1.ps1`)*

## S2 — dos personas en la misma PC, cada una con su mando (L1-11, L1-12 en la plataforma nueva)

- **S2a, el control (sin puente):** dos copias (`--instance 1 --coop host`, `--instance 2 --coop join --join
  127.0.0.1`), ventana cada una. **Predicción:** se conectan y entran a la misma misión, pero **sólo la copia con
  el foco responde a los mandos** (lo que dice el código). Es el control que muestra que el puente hace falta.
- **S2b, con el puente:** las dos copias con `--coop-control` (45501 y 45502) y `puente_mandos.py`.
  **Predicción:** cada mando mueve **sólo** su copia, con las dos ventanas a la vez y sin importar el foco; los
  dos jugadores en la misma misión; cada copia ≥ 30 cuadros por segundo (dos juegos a la vez en una laptop).
  **Control:** el mismo puente con los mandos cruzados (`--cruzar`) mueve la otra copia; y con el puente cortado,
  ninguna copia se mueve (el canal se come el mando físico).
- **Testigo que no depende de la vista:** `state` por el canal de cada copia (posición y estado del jugador) antes
  y después de mover un solo mando: cambia la copia de ese mando y no la otra.

### Resultado de S2
*(pendiente: lo corre Fran con `lanzadores\PROBAR-COOP-PC.ps1`)*
