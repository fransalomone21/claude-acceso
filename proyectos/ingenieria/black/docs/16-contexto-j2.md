# 16 — J2 con contexto propio: diseñar a J2 copiando cómo está armado J1

> Nació en (96), a pedido de Fran: «si entendés la estructura de J1, deberías poder diseñar la de J2», «out of the
> box y después into the box», «análisis en frío y todas las herramientas posibles». Es un **plan de frío**: nada de
> esto está medido todavía salvo lo que dice `confirmado`/`probable` con su entrada.

## Fuera de la caja: por qué salen los errores de a uno

BLACK es un juego de **un solo jugador local**. Todo lo que es «del jugador» y no vive adentro del objeto J vive
en **singletons**: la vista en primera persona (una sola, `V` = `*(*(*(0x0040F510)+0xCBD8)+0xC)`), el HUD, la
cámara, el oyente y los sonidos «del jugador», el estado de agachado, la muerte (el global `+0x21098`). J2 es una
**copia de J** (el constructor del juego con J de molde), así que J2 **comparte cada singleton que J usa**.

Hasta hoy el mod lo resolvió **al revés**: en vez de darle a J2 lo suyo, **lo aísla** de lo de J —
`aislar` saltea sus llamadas a `V` (15 de 15 disparos, 19 de 19 eventos: `prueba_aislar_j2.py`), `ocultar` lo saca
de la pasada de J, la ranura 3 le da brazos propios. Cada aislamiento tapa un síntoma y **le saca algo a J2**:

| Síntoma que ve Fran | Lectura estructural (hipótesis) |
|---|---|
| J2 dispara sin sonido; el impacto suena flojo | el sonido del disparo del jugador sale por el camino de `V` (`0x001D6F90` → `FUN_001d7020`, `FUN_001f0678`), que el mod saltea para J2 |
| la escopeta de J1 «mergeada» con la pistola de J2; la recarga de J1 en la mitad de J2 (con J1 en el puerto 2) | `V` (de J) se dibuja también en la pasada 2; hacerlo invisible para el nodo J **no alcanza** (refutado, (96)): lo dibuja otra cosa |
| el fogonazo y la recarga de J2 aparecen en la mitad de J1 (fork, recarga automática) | efectos de J2 que no son nodos del filtro (partículas, `V`) |
| un solo HUD | el HUD lee a J / `V` / el singleton de la cámara |
| agacharse agacha a los dos | el agachado vive en un singleton (cámara o control), no en J |
| la muerte de J2 terminaría la partida (B5) | el global de fin de partida no mira quién murió |

**La idea de fondo:** no aislar a J2, sino darle **su propio contexto** y **cambiar de contexto** alrededor de
todo lo que el juego hace «para el jugador»: antes de actualizar a J2 y antes de dibujar la pasada 2, los punteros
globales pasan a las copias de J2 (su `V2`, su HUD, su estado de cámara); después vuelven a los de J. Es como se
le agrega pantalla dividida a un motor de un jugador. Así el camino del disparo de J2 **corre entero** (sonido,
fogonazo, animación) sobre **su** `V2`, y la pasada 2 dibuja `V2` y no `V`: los síntomas de arriba dejan de ser
siete arreglos y pasan a ser **uno**.

## Dentro de la caja: qué hay que saber, en frío, antes de escribir código

1. **El censo de lo «por jugador»**: todo lo que el código de J lee que **no** cuelga de J. Herramientas que ya
   hay: `censo_subsistemas.py` (37 singletons), `perfil_singleton.py` (qué hace el código con cada uno),
   `decompilar.py c <dir>`, `xref.py`, `punteros_a.py`. Salida: una tabla singleton → quién lo escribe → quién lo
   lee por cuadro → si hay que duplicarlo, conmutarlo o dejarlo compartido.
2. **`V`**: cómo se construye (para armar `V2` con las funciones del juego, como la ranura 3), quién la dibuja
   (¿el pase de la cámara, fuera del recorrido del filtro?), y si el sonido del disparo sale de ahí
   (`FUN_001d7020` crea algo con el id `0x85C` por `FUN_00283e78`; `FUN_001f0678` empuja una pista de animación).
3. **El dibujo de la pasada 2**: qué se dibuja fuera de `FUN_001297A0` (el callback que filtra `ocultar`). Ahí está
   el arma de J en la mitad de J2.
4. **Por qué depende del puerto** (E1 sale con J1 en el puerto 2 y no en el 1): qué singleton se indexa por
   puerto o por control (`J+0x588`).
5. **HUD y agachado**: dónde vive el estado (el ícono de agachado sale en el HUD de J1 con el botón 11), y qué
   dibuja el HUD.
6. Recién con 1–5: el diseño del **cambio de contexto** (qué se conmuta, en qué ganchos, qué se duplica una vez
   por arranque y qué por nivel), con su verificador en el plano `docs/14` y su saboteador, **antes** de tocar el
   pnach.

## Herramientas nuevas de (96)

- `grabar_audio.py` + `grabar-gameplay.ps1`: el video sale también con **sonido** (`gameplay_audio.mp4`,
  WASAPI loopback de la salida por defecto; `pip install pyaudiowpatch`).
- `rafaga_vista.py`: video a 30 cuadros/s del fork mientras un jugador actúa (las capturas sueltas mienten).
- `prueba_pose_r3.py`, `prueba_aislar_j2.py`, `foto_coop.py` (foto de solo lectura del emulador de Fran).
