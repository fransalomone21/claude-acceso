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

## Paso 1 hecho: el censo A/B (98, nube)

> `herramientas/censo_ab.py` (con `--autotest`: control positivo sobre los disparadores de (73) y el alta de (82)).
> Lee el C de Ghidra y junta **toda lectura de «el jugador» que no cuelga de un J recibido por parámetro**: el
> global del juego con un desplazamiento dentro de `jugadores[0]` (`juego = *(0x0040F4D0)`; `juego+0x30+x` = `J+x`),
> `jugadores[k]` indexado y la cuenta `*(0x0040F0E0)+0x20208`. Resultado: **103 funciones**. Es una **cota
> inferior** (lo que Ghidra no nombró `DAT_0040f4d0` no sale; la lista completa por instrucciones es
> `lectores_global.py`). Grado: `confirmado en frío` que cada una lee lo que dice; la **clase** es mi lectura
> (`probable` donde leí el C, `hipótesis` donde sólo vi el patrón).

**Lo que J tiene adentro y el mundo lee por el global** (el mapa de `J+x` que usa el censo; `probable` salvo
donde dice): `+0xA0` posición (la fila 3 de la matriz `+0x70..+0xA0`), `+0x190` posición de los disparadores (73),
`+0x280` manejador de armas, `+0x294` banderas de objetos de misión (`hipótesis`), `+0x2A4` arma en la mano,
`+0x2E8` altura (1,65), `+0x2F8` vida, `+0x330` ranura FP, `+0x380` bit del registro físico, `+0x4E4` un contador
que la actualización de J descarga (`hipótesis`: aturdido/golpe), `+0x4F0` el control (`+0xF1` invertir Y, `+0xF2`
agachar alterno, `+0x30` **agachado**), `+0x8B2` muerto.

### El mapa grueso: quién pregunta por el jugador

| # | Lector (funciones) | Qué lee | Subsistema | Clase | Filas |
|---|---|---|---|---|---|
| B1 | **objetos del piso**: `FUN_00126328` (por cuadro, desde `FUN_00129360`) activa los 64 recogibles a < 20 m de `J+0xA0` y pide una consulta espacial alrededor de J (`FUN_00273568(juego+0x4920, …, FUN_00127118)`); `FUN_00127118` decide con `J+0xA0`, `J+0x2E8`, `J+0x2F8` (botiquín), `J+0x280` (munición), `J+0x294`; el **arma** candidata va a un solo lugar compartido, `pickups+0x5848` (la más cercana a J, distancia en `+0x584C`) | la posición, la altura, la vida y las armas **de J** | pickups `0x0040F4E4` | **B** | **F1**, **N9** |
| B1' | consumidores del arma candidata: `FUN_0013F618` (el **control de cada jugador**, acción `0xD` = agarrar) → `FUN_0015C1A8(jugador+0x280)`; `FUN_001F5F58` (el cartel del HUD) | `pickups+0x5848` | control / HUD | B (el control ya es por jugador: lee **su** `+0x7C`) | F1 |
| B2 | **disparadores**: `FUN_00165DF0` (por cuadro) → `FUN_0016A250`/`FUN_0016A4C0` (`J+0x190`, `J+0x2E8`), las otras formas de volumen `FUN_0016A5E8`, `FUN_00164548`, `FUN_00164BC0`, `FUN_001656F0`, `FUN_0016CB50`, `FUN_0018E680`; al entrar/salir, el método 2 de la clase `0x003DC010` = `FUN_00169D48` avisa a los objetos enlazados (`+0x1C`) o a la IA (`FUN_0018D698(ia+0xD10, zona)`); `FUN_0012E938`, `FUN_0014F380` (`FUN_00168618(…, J)`) | la posición y la altura **de J** | disparadores `0x0040F4F4` | **B** | **N3**, **N4** (la carga del nivel cuelga de los disparadores: ver abajo) |
| B3 | **IA propia de Criterion** (`0x0017xxxx–0x0019xxxx`, fuera de Kynapse): `FUN_00172830` (J tres veces), `FUN_0018A890` (`FUN_00189740(ia, J, 1)`), `FUN_0018B190`, `FUN_0018FC18`, `FUN_00190958`, `FUN_001848C0` (`ia[3] = J`); por posición `FUN_00176D18`, `FUN_00180CD8`, `FUN_00186F40`, `FUN_00190C18`, `FUN_00197678`, `FUN_0019D6B8`; `FUN_0018A678`, `FUN_00190A68` (`J+0x380`); `FUN_001944D8` (el arma de J) | J **como blanco** | ia | **B** | **N1**, **N2** (T2) |
| B4 | aparición en caliente `FUN_00165F30` (pasa J) y la elección del spawner `FUN_00139A70` (distancia a J) | J | spawn | B | N4 |
| B5 | muerte y estadísticas: `FUN_001064D8`, `FUN_00106CD8`, `FUN_00121688`, `FUN_00121808` (escriben `J+0x8B2` = 1, `FUN_0013C950(J, 1)`), `FUN_00121600`/`FUN_00121648` (`FUN_0013C950(J, 1/0)`), `FUN_0015CEF0` (¿el que mató es J?) | J | estadísticas / guion | B | F10 |
| B6 | cargador, alta, baja, desarme, entrar al modo: `FUN_00128480`, `FUN_0012BE80`, `FUN_0012BFC8`, `FUN_00129DE8`, `FUN_00105318`, `FUN_00106080`, `FUN_00106868`, `FUN_00106010`, `FUN_00213CA8` | la cuenta = 1 | juego / sesión | B, **ya resuelta** por el mod (envoltorio (86), desarme (87)) | — |
| A1 | **cámara**: `FUN_00110C90`, `FUN_00114238`, `FUN_001145D8` (la matriz y el ojo de J, `J+0x330`), `FUN_00137718`, `FUN_0016B7A0`; la **cámara de muerte** `FUN_001199D8` (J entero, `+0x7D0`, `+0x894`, `+0x8B2`) | la vista de J | cámara `0x0040F4BC` | **A** | (la pasada 2 ya trae su vista, (84)); F10 |
| A2 | **HUD**: `FUN_001F5F58` (armas, munición, carteles; `J+0x2A0/+0x2A4/+0x2C2`), `FUN_001F3AA0` (`J+0xA0`), `FUN_001F9EF8`, `FUN_001FA658` (`J+0x8A1`), `FUN_001FC188` (`J+0x280`), y **los que ya indexan `jugadores[k]`** con un `k` guardado en el objeto del HUD: `FUN_001F7C48` (`+0x12`), `FUN_001FD298`/`FUN_001FD440`/`FUN_001FD648` (`+0x2D8`), `FUN_001FBA78` (`+0x140`); desde la actualización de **cada** jugador: `FUN_001F2C98`/`FUN_001F2A60(comandos-ui, 0x14/0x18)` (vida baja) y `FUN_001F2CD0` (ícono de agachado) | el estado de J | HUD `0x0040F518`, comandos-ui `0x0040F51C` | **A** | **F5**, F6 (ícono) |
| A3 | **efectos y sonido del jugador**: el contexto de efectos `X = *(0x0040F510+0xCBD8)` (construido UNA vez al arrancar por `FUN_001E82A8`, el mismo en los 4 volcados: `0x00656000`; `X+0xC` = `V`, `X+0x30` = el emisor de los sonidos «del jugador»); `FUN_001E3FF8`, `FUN_001E42D0` (matriz de J; `FUN_00283E78` = crear sonido), `FUN_001EB4C0`, `FUN_001DC790`, `FUN_0014FBE8`, `FUN_001218B8` (sonido en `J+0xA0`), `FUN_001EEB00` (vida de J) | la matriz y la vida de J | audio `0x0040F510` | **A** | **F4**, **F8**, N5 |
| A4 | el contador `J+0x4E4`: `FUN_00121E28`, `FUN_00121F00`, `FUN_00122120` (por cuadro), `FUN_00133FA8`, `FUN_00140068` | J | comandos-ui | A (`hipótesis`) | — |
| A5 | **opciones del jugador** en el menú: `FUN_00206248` («Toggle Crouch»), `FUN_002066E0`, `FUN_00210450`, `FUN_002107D8`, `FUN_00210850` (`ctrl+0xF1/+0xF2` de J) | el control de J | front-end | A | N17 |
| C1 | **efectos del mundo** alrededor del jugador: `FUN_001B1CB8` (por cuadro, sobre `0x0040F4D8`) → `FUN_001B2710`, `FUN_001B3BD0`, `FUN_001B5FB0`, `FUN_001B8798`, `FUN_001B96B8`, `FUN_001BE960`, `FUN_001BCF50`; `FUN_0014E278` | J como centro de interés | «vista-fp» `0x0040F4D8` (553 KB: es más bien **efectos del mundo**) | **C** | (J2 lejos ve menos efectos; prioridad baja) |
| ? | sin leer: `FUN_00122478`, `FUN_00126F80`, `FUN_001A8F78`, `FUN_001A9538` (`FUN_00136B30(J)`), `FUN_00159198` (`FUN_00137E88(J)`), `FUN_00146000`, `FUN_0012FE58`, `FUN_001409C0`, `FUN_0013DD68`, `FUN_00100628`, el objeto `J+0x3C0` (`FUN_0016BEA8`…`FUN_0016C700`, `FUN_0016BEE0`: ¿el punto de control?, N12) | — | armas / guion | — | N12, N13 |

### Lo que el censo cambia del plan

1. **F6 no es un singleton**: el agachado es `ctrl+0x30` y lo escribe `FUN_0013F618` **del control de cada
   jugador** (acción `0xC`; `ctrl+0xF2` = modo alterno). Sólo el **ícono** es único (`FUN_001F2CD0` →
   `FUN_001F8528(*(hud+0x34), …)`). Que «se agachen los dos» pide otra explicación: la leo en T6.
2. **F1 es B puro, con un solo lugar compartido**: la consulta pregunta por J; el candidato vive en
   `pickups+0x5848` (uno solo). El control de J2 ya lee **su** jugador (`ctrl+0x7C`), así que J2 apretando □
   intentaría juntar **el arma cercana a J**. Diseño en T3.
3. **N3 y N4 son la misma pregunta**: los disparadores (73) prueban sólo `J+0x190`, y lo que hacen al entrar o
   salir (activar objetos enlazados, avisarle a la IA) es el guion. Las unidades `0x0040F534/538` son dos listas
   de animación por cuadro (`FUN_0012F408`, `FUN_0012EF68`), **no** una carga por distancia (`probable`).
4. **El HUD ya tiene índice de jugador en algunas funciones** (`jugadores[k]` con `k` en el objeto del HUD, (64)),
   pero J2 no está en `jugadores[]`: `0x0046CDF0` no es `juego+0x30+k·0x8C0` para ningún `k` entero (−577 cae en
   `0x0046D1F0`, (79)). Dato para T7.
5. **`V` cuelga de un contexto de efectos único**, construido al arrancar (`FUN_001D5828` → `FUN_001E82A8`), junto
   con el emisor de sonido del jugador (`X+0x30`). Eso es lo que T4 tiene que duplicar.
