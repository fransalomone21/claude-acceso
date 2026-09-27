# Proyecto COOP — análisis en papel (Fase A, 2026-09-27)

Único proyecto activo del programa, por decisión del KDP-A (`PDP.md` §6). El
plan de desarrollo de tecnología (qué subsistema sube de qué K a qué K, y con
qué sonda) está en `PDP.md` §4, «Proyecto COOP». Lo que sigue es el
razonamiento que lo sostiene, hecho en la nube, sin el ELF ni el emulador.
**Nada acá subió de grado por escribirse:** cada afirmación lleva el que tenía.

## 1. Lo que ya se sabe (8c, en frío, 2026-09-26)

| Hecho | Grado | Fuente |
|---|---|---|
| `jugadores[i] = *(0x0040F4D0) + 0x30 + i*0x8C0`, compilado con N = 1 | probable | bitácora (61), `kb/superficies.json#R5` |
| `jugador+0x418` es el número de mando del jugador, y vale 0 | probable | ídem |
| el gestor de entrada `*(0x0040F0E8)` arma dos mandos (puertos 0 y 1, estado 4) | probable (K4) | tres volcados, bitácora (61) |
| `juego+0x8F0` está ocupado: un segundo jugador no entra en el mismo lugar | probable | ídem |
| la cámara no está ubicada | — (K0) | `kb/subsistemas.json` |
| el render (RenderWare dentro del ELF) está ubicado y nada más | — (K1) | ídem |

## 2. Qué forma de coop, y por qué

Fran (resp. 5): «pantalla dividida o cada uno en una computadora seria mejor,
quiero la que sea viable, que permita jugar de a dos». Y (resp. 7) la campaña
entera.

- **M1, una pantalla con una cámara, no sirve como entrega.** BLACK es en
  primera persona (subsistema `vista-fp`): con una cámara, el jugador 2 está
  en el mundo pero no tiene vista propia. Sirve como **paso del prototipo**
  (dos jugadores en el mundo antes de dos vistas). Grado: `probable`, porque
  es razonamiento sobre el género y no una medición.
- **M2, pantalla dividida, es la meta.** Pide dos cámaras y dibujar dos vistas
  por cuadro. Su riesgo es el `render` en K1: hoy no se sabe si el motor
  admite un segundo viewport. Hay una pista a favor que se puede mirar en
  frío: la mira telescópica (`/EXPORT/FRONTEND/WPNSCOPE`) y cualquier espejo o
  pantalla dentro del juego implican que el motor ya dibuja algo con otra
  cámara o con otro recorte. Grado: `hipótesis`.
- **«Cada uno en su computadora» es M6 encima de M2.** PCSX2 no trae juego en
  red (X2, descartado). Con Parsec o Remote Play la otra persona recibe la
  imagen y manda su mando a la PC que corre el juego; con pantalla dividida,
  cada uno mira su mitad. Cero reversing, y sólo existe si hay un coop local
  debajo.
- **M3, el jugador 2 maneja a un compañero de escuadra**, es el plan B si la
  pantalla dividida resulta inviable: no pide un jugador nuevo, pero depende
  de la IA (K2) y sigue sin dar vista propia.

## 3. Costo de rendimiento (resp. 8: «perder lo menor posible pero perder lo necesario»)

Dos vistas son, en el peor caso, el doble de trabajo del GS y del EE por
cuadro. La PC (R7 5700G + RTX 3090) sobra para el GS emulado; el cuello
probable es el **EE emulado**, que es un solo hilo. Lo que se puede resignar,
de menos a más: el pack de texturas HD, DLSS5 y ReShade, la escala interna y,
al final, la distancia de detalle (LOD) dentro del juego. Grado: `hipótesis`,
hasta medirlo con las dos vistas.

## 4. Las preguntas finas del coop, decididas por la sesión

Fran delegó («decide todo vos, primero el coop, despues vamos viendo»). Estas
decisiones se pueden revisar si Fran lo pide; cada una dice qué la
cambiaría.

| Pregunta | Decisión | Qué la cambia |
|---|---|---|
| ¿Qué personaje es el jugador 2? | un segundo soldado con el mismo modelo que el jugador 1; ninguno de la escuadra | si alojar un jugador nuevo resulta más caro que apropiarse de un compañero (sonda 5) |
| ¿División horizontal o vertical? | vertical (lado a lado): conserva el ancho de la mira en 16:9 | que la proyección no admita cambiar el aspecto (sonda 4) |
| ¿Qué pasa si muere uno? | reaparece en el siguiente punto de control; la misión falla sólo si mueren los dos | lo que permita el flujo de misión (`flujo`, K3) |
| ¿HUD del jugador 2? | fuera de la Fase A; después, una copia del HUD en su mitad | nada: es alcance, no factibilidad |
| ¿Dificultad en coop? | la misma que en solo; el ajuste queda para el proyecto de desafío | que Fran lo pida |
| ¿Cómo se prende? | un pnach aparte en el menú «BLACK - Parches», apagado por defecto (N7) | — |
| ¿Primer nivel? | el primero de la campaña, sin tocar el flujo | — |

## 5. Lo que se hace en la nube y lo que no

| Sonda (`PDP.md` §4) | Qué pide | ¿Nube? |
|---|---|---|
| 1. `entrada` K5: `jugador+0x418 = 1` | emulador y PINE | no |
| 2. `camara` K0 → K3, en frío | ELF, Ghidra o capstone, un volcado de RAM | **sí, si se suben el ELF y los volcados** |
| 3. `camara` K5 | emulador | no |
| 4. `render` K1 → K3, en frío | ELF, más `WPNSCOPE` del ISO | **sí, con el ELF y ese archivo** |
| 5. `juego`: quién itera `jugadores[]` | ELF | **sí, con el ELF** |
| 6. `codigo-nuevo`: memoria libre estable | ELF + volcado | **sí**, en su mitad en frío |
| 7. `spawn` fuera de la carga | ELF | **sí, con el ELF** |

Cómo llegar a eso, y qué hace falta subir: `sesiones/HANDOFF.md`, bloque
2026-09-27.
