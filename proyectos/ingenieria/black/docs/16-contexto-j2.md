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

## Clase B, la IA (T2, (99) nube): el mundo de la IA es «J + 16 agentes», y J2 no está en ninguno de los dos

### Concepción — qué ES el blanco de un enemigo (`confirmado en frío`; datos `confirmado en volcado`)

Un enemigo **no apunta al jugador**: apunta a una **amenaza** de su lista (3 ranuras de `0x60` en `agente+0x150`,
la actual en `agente+0x270`), y cada amenaza es un **id del registro físico** (`*(0x0040F4D4)+0xFA8`: entradas
`{i, estado, personaje}` de `0xC`; el id del personaje vive en `personaje+0x380`). Es genérico: aliados y enemigos
usan la misma lista y se eligen por **bando** (`personaje+0x3A4`: 0 = los nuestros, 1 = los de ellos).

Las amenazas entran por **tres puertas**:

| Puerta | Quién | Qué le pregunta al mundo | ¿J2 entra? |
|---|---|---|---|
| **ver** | `FUN_0018FC18` → `FUN_0018FB88` (por agente, por cuadro): «¿a quién de otro bando, vivo y no anotado, veo?» | recorre **[J por el global] + las 16 ranuras de agentes** (`fisica+0x2B00`, paso `0x1FD0`) | **no**: J2 no es J ni un agente |
| **visibles** | `FUN_00190958` → `FUN_001908A0`: mantiene la máscara de visibles `agente+0x274` | el mismo recorrido | **no** |
| **daño** | `FUN_0013D388` → `FUN_00189550`: el que me pegó entra como amenaza, con peso = daño | el atacante, por su id | **sí** (`probable`: lo resuelve por el registro, donde J2 está) |
| (por defecto) | `FUN_0018A890`: sin amenaza, `FUN_00189740(agente, J, 1)` | J fijo | no (y está bien que el defecto sea uno) |

Además, con **J fijo** (no genéricos): el blanco del modo hostil `FUN_001848C0` (`p[3] = J`), la lista de
cercanía a 4 m `FUN_0018B190` (J + agentes), y seis lecturas de distancia a `J+0xA0` (`FUN_00176D18`,
`FUN_00180CD8`, `FUN_00186F40`, `FUN_00190C18`, `FUN_00197678`, `FUN_0019D6B8`: sin leer qué deciden).

**Los datos de J2 ya alcanzan** (`confirmado en volcado`, `ee-parpadeo-quieto/fuego-0`, con `FASE` = 2): la entrada 1
del registro es J2 (`0x0046CDF0`), `J2+0x380` = 1, bando 0 (el de J), vivo (`+0x38C` = 0), tipo 2. En esos volcados
ningún enemigo tiene el id 1 como amenaza (J2 estaba quieto: evidencia débil, pero coherente).

**Respuesta a N1:** los enemigos **no ven** a J2; sólo lo tomarían como blanco **después de que J2 les pegue**
(`probable`), y aun así no lo tendrían en la máscara de visibles, que es lo que la IA usa para decidir si le tira
(`hipótesis`). N2 depende de eso.

### Diseño — alternativas y elección

| Opción | Qué es | A favor | En contra |
|---|---|---|---|
| **1. J2 en «el mundo de la IA»** | en los dos recorridos (ver, visibles), donde el juego pregunta por J, preguntar **por J y por J2** | ataca la causa (la IA ya sabe manejar N personajes por id y bando); dos puntos de cambio; nada nuevo que mantener por cuadro | el costo por agente se duplica en esas dos preguntas (barato: una prueba de visibilidad más) |
| 2. J2 como agente 17 | darle una ranura de agente | la IA lo recorrería sola | una ranura de agente es un **cerebro** (`0x1FD0`): J2 pasaría a tener IA. Descartada |
| 3. sólo por daño | no tocar nada: J2 existe para el que le pega | cero cambios | la IA nunca **inicia** contra J2; los enemigos ignoran a quien no les disparó. No es coop |
| 4. conmutar «J» | cambiar el global del juego a J2 alrededor de la IA (como la clase A) | un solo gancho | la IA vería **sólo** a uno por vez: J2 o J, nunca los dos. Descartada |

**Elección: opción 1**, en dos lugares: el llamado con J dentro de `FUN_0018FC18` (sitio `0x0018FC4C`) y dentro de
`FUN_00190958` (sitio `0x0019098C`). Cada uno pasa a «hacé esto para J, y si J2 está armado (`FASE` = 2), también
para J2». El modo hostil (`FUN_001848C0`) y la cercanía de 4 m (`FUN_0018B190`) quedan **para después de la sonda**:
si con la opción 1 los enemigos ya le tiran a J2, no hacen falta; si no, son los siguientes candidatos. El defecto
(`FUN_0018A890`) queda en J.

**Invariante que el diseño tiene que cuidar:** una amenaza es un id; J2 tiene que conservar **su** id (1) toda la
partida y darse de baja del registro al desarmar el nivel (lo hace el desarme de (87)). Si el id quedara vivo en una
ranura de amenaza después del desarme, un enemigo del nivel siguiente apuntaría a una entrada vieja.

**Preguntas para Fran (decisión de valor, no de ingeniería):** (a) ¿los enemigos se reparten entre los dos, o
priorizan al más cercano? (la opción 1 deja que el juego decida con sus pesos de siempre: distancia, daño); (b) con
dos blancos el juego es **más fácil** para cada uno: ¿se compensa (N18)?

### Sonda en vivo (para la notebook, con la opción 1 instalada)

- **Qué se mira:** por cada agente activo (`fisica+0x2B00+i·0x1FD0`, `+0x78` ≠ 0): la máscara de visibles `+0x274`
  (bit 1 = J2) y las amenazas `+0x150/+0x1B0/+0x210` (id 1 = J2).
- **Predicción:** J quieto detrás de una pared, J2 camina hasta quedar a la vista de un enemigo: en menos de 2 s el
  bit 1 aparece en `+0x274` y el id 1 entra en una ranura de amenaza de ese enemigo; después, la vida de J2 baja
  (N2) sin que J2 haya disparado.
- **Control, en la misma corrida:** con el gancho apagado (la palabra original en los dos sitios), la misma escena:
  el bit 1 y el id 1 no aparecen hasta que J2 dispara (entonces entra por la puerta del daño, la tercera fila).
- **Negativo que refuta:** con el gancho prendido, J2 a la vista 10 s y ni el bit ni el id → la puerta «ver» tiene
  otra condición que J2 no cumple (candidato: `FUN_00185C38(agente+0x6F0)`, la percepción).

## Clase B, juntar (T3, (100) nube): la pregunta es de J, la respuesta es una sola, y el que la usa ya es cada jugador

### Concepción (`confirmado en frío`)

«Juntar» son **tres** cosas, y ninguna es un botón que mire al que lo aprieta:

| Qué | Pregunta (por cuadro) | Respuesta | Quién la usa |
|---|---|---|---|
| **activar** los recogibles cercanos (y la munición del arma en la mano, `FUN_00126F80`) | `FUN_00126328`: los 64 a < 20 m de `J+0xA0` | bandera `+0x152` bit 4 del recogible | el mundo físico |
| **tocar**: botiquín, munición, objeto de misión | la consulta espacial alrededor de J (`FUN_00273568(juego+0x4920, …, FUN_00127118)`) | se aplica **en el acto** a J (`FUN_0013C9D8(J)`, `FUN_001551C8(J+0x280)`, `J+0x294`) | — |
| **arma** (mantener □) | la misma consulta | **un solo candidato**: `pickups+0x5848` (la más cercana a J), borrado cada cuadro | el **control de cada jugador** (`FUN_0013F618`, acción `0xD`) → `FUN_0015C920` («¿no la tengo?») → `FUN_0015C1A8(su jugador+0x280)`; el cartel `FUN_001F5F58` |

Lo que viene después ya es **por jugador** (`probable`): `FUN_0015C3C8` suelta el arma vieja y carga la nueva por
`FUN_00143D90` → `FUN_001AC960` → el envoltorio de la ranura 3 (`0x001ACA84`), que (93s) ya diseñó para «cambio de
arma y levantar un arma de J2». **F2 (cambiar de arma) cuelga del mismo camino.**

**Lectura:** J2 apretando □ **junta el arma que está cerca de J**, esté donde esté J2 (predicción: si J está parado
sobre un arma y J2 lejos, J2 la levanta). J2 nunca toca botiquines ni munición (se aplican a J cuando J pasa).

### Las tres primitivas del diseño (salen de acá y valen para toda la clase B)

Medido con `censo_ab.py --conmutables` (cierre por llamadas directas; las indirectas no están: necesario, no
suficiente):

- **P1 — pasar a J2.** La pregunta recibe al jugador por parámetro: se la llama también con J2. Es la IA (T2), el
  control (`FUN_0013F618` ya lo hace), `FUN_0015C1A8`.
- **P2 — conmutar el juego.** La pregunta lee al jugador por el global: se la corre con `*(0x0040F4D0)` = `J2 − 0x30`
  (así `juego+0x30+x` = `J2+x`) y se restaura. Vale sólo si la pregunta **y todo lo que llama** leen el global dentro
  de `[0x30, 0x8F0)`, salvo una lista chica de campos que se copian a una **cabecera sombra** (`juego'+o` ← `juego+o`)
  antes de preguntar. Resultado: **disparadores `FUN_0016A4C0`/`FUN_0016A250`: conmutables limpios** (0 campos);
  **`FUN_00127118`: conmutable con sombra de `+0x20` y `+0x5AEC`** (los lee el sonido `FUN_001EED98`); `FUN_00126328`
  **no** (usa el mundo `+0x4920` y pasa el juego entero).
- **P3 — conmutar el contexto** (clase A, T4–T6): los punteros de `V`, HUD, efectos.

La cabecera sombra cae **dentro de la memoria del mod** (`J2 − 0x30 + 0x20` = `0x0046CDE0`, `+0x5AEC` = `0x004728AC`):
el plano de memoria de T7 tiene que reservar esas palabras y el verificador de `docs/14` exigirlo.

### Alternativas y elección para F1

| Opción | Qué | En contra |
|---|---|---|
| **1. preguntar también por J2, con respuesta propia** | por cuadro, después de la pregunta de J: activar y consultar alrededor de `J2+0xA0` con el callback **conmutado** (P2); el candidato de J2 se guarda aparte y se **intercambia** con `pickups+0x5848` sólo alrededor de la actualización de J2 | una réplica chica de la vuelta de `FUN_00126328` (no es conmutable) |
| 2. conmutar `FUN_00126328` entera | un gancho | **imposible**: `juego+0x4920` y `FUN_00129108(juego)` no son de J |
| 3. candidato compartido, el más cercano de los dos | un solo lugar | J con □ podría levantar el arma de al lado de J2: pelea por el mismo lugar |
| 4. botón propio del mod | simple | salta las reglas del juego (dos del mismo tipo, cartel, munición) |

**Elección: opción 1.** Orden por cuadro: (a) el juego pregunta por J (como siempre, borra y llena `+0x5848`);
(b) el mod guarda la respuesta de J, pregunta por J2 y deja la de J2 en `CAND2`, y repone la de J; (c) alrededor de
la actualización de J2 (el gancho por cuadro que ya existe), `+0x5848/+0x584C` ↔ `CAND2`. Botiquines y munición
salen solos con la opción 1 (se aplican al jugador conmutado). **El cartel «HOLD □» de J2** espera al HUD (F5).
**Pregunta para Fran:** ¿un botiquín lo toma el que pasa (como hoy), o se reparte?

### Sonda del concepto (vivo, sin instalar nada nuevo)

Sirve para confirmar la concepción **antes** de construir: *candidato compartido, consumidor por jugador*.
- **Predicción:** J parado sobre un arma que J no tiene y J2 a más de 20 m; J2 mantiene □ (mando falso 2,
  `mando_j2.py boton agarrar 1.0`): **J2 levanta el arma que está bajo J** (el arma de J2 cambia, `armas_j2.py`, y el
  recogible desaparece del piso) y J no cambia.
- **Control en la misma corrida:** J2 parado sobre otra arma y J lejos, J2 mantiene □: no pasa nada
  (`pickups+0x5848` = 0 al leerlo por PINE).
- **Refuta:** si en la predicción J2 no levanta nada, el control o `FUN_0015C920` miran algo más (candidato: el
  estado de agarre `ctrl+0xFB/+0xFC`).

## Clase A, `V` y el sonido (T4, (101) nube): el disparo de J2 no suena porque su sonido vive en `V`, y el mod le saltea `V`

### Concepción (`confirmado en frío`; tamaños y punteros `confirmado en volcado`)

- **`V` es la vista del arma en primera persona**: un objeto de `0x1C50` B que el arranque aloja una sola vez en el
  contexto de efectos (`X+0xC`, `X = *(0x0040F510+0xCBD8)`, `FUN_001E82A8`), con 6 sub-ranuras de `0x430` (vtables
  `0x003E2898`/`0x003E0910`). Es la **misma** en los cuatro volcados (`0x00657180`).
- **El sonido del disparo del jugador sale de `V`**: `FUN_001D6F90(V)` (el disparo) → pista de animación
  (`FUN_001F0678(V+0x1BE0)`) y, si `*(X+0x24)+0x1E54` = 0, `FUN_001D7020(V)`: alterna al azar dos muestras
  (`V+0x1C0C`/`+0x1C10`) y las crea (`FUN_00283E78`, evento `0x85C`) **en el emisor propio de `V`** (`V+0x40`), con
  volumen `V+0x1C48`. Los impactos son sonidos del mundo, aparte.
- **Quién usa `V`** (todos por el global `X+0xC`, ninguno por parámetro): el código de armas **del jugador que se está
  actualizando** (disparo `FUN_0011C5A8`, `FUN_00159198`, `FUN_00159938`, `FUN_0015A098`, `FUN_0015A400`; recarga
  `FUN_00158AE0`; cambio `FUN_00156F18`, `FUN_0015BF50`; `FUN_00156FD0`, `FUN_001575A8`; consultas `FUN_001435F8`,
  `FUN_00143700`), el callback de eventos de animación (`FUN_001E80C0`, (93m)), y **una máquina de estados de la vista**
  de cuatro estados (vtables `0x003E07B8`, `0x003E0800`, `0x003E0848`, `0x003E0890`; métodos `FUN_001EDC80`,
  `FUN_001EE0B0`, `FUN_001EE298`, `FUN_001EE678`, `FUN_001EDE98`…) que le cambia el modo desde afuera
  (candidatos, `hipótesis`: normal, mira con zoom (N8), muerte, cine).
- **Por qué J2 no suena (F4):** el aislador de (93l) hace que, mientras se actualiza J2, `FUN_001D6F90` vuelva sin hacer
  nada (15 de 15 disparos salteados, (96)). Con eso se va el sonido, el fogonazo y la animación de J2 **sobre `V`**. Lo
  que se oye de J2 son sólo sus impactos.
- **`V` no se puede clonar**: tiene **10 punteros a sí misma** (las 6 sub-ranuras y `+0x1BE0/+0x1BE8/+0x1BF0`) y unos
  **15 a objetos de animación del montón** (`0x0185xxxx–0x01ABxxxx`). Una copia compartiría esos objetos: es la trampa
  de la ranura compartida de (80)/(93n), otra vez.

### Alternativas y elección

| Opción | Qué | A favor | En contra |
|---|---|---|---|
| **1. `V2` propia + conmutar `X+0xC`** (P3) | construir una segunda vista con las funciones del juego (como la ranura 3); mientras se actualiza J2, `X+0xC` = `V2`; después, `V` | el camino entero del disparo de J2 corre **como el de J**: sonido, pista de animación, configuración por arma (`FUN_001D6E78` la hace el mismo cambio de arma, ya conmutado). **Reemplaza al aislador**, que deja de hacer falta | construir `V2` (la parte cara, T7); la máquina de estados de la vista actúa sobre el global: hay que decidir a quién le habla (abajo) |
| 2. aislador + sonido a mano | dejar el aislador y, cuando J2 dispara, crear el sonido con `FUN_00283E78` | chico | arregla F4 y nada más; el fogonazo y la animación de J2 siguen sin existir (F8) |
| 3. no aislar | sacar el aislador | cero código | vuelve lo de (93k): J2 recarga y **las dos mitades** recargan |

**Elección: opción 1**, y el aislador de (93l)/(93m) queda como **control**: prendido = el comportamiento de hoy.

**Lo que la opción 1 obliga a decidir en T7** (diseño, no código):
1. **Cuándo se arma `V2`**: `V` se arma una vez por arranque. Mismo criterio que la ranura 3: una vez por arranque,
   fuera del pnach, con su bandera (como `R3_ARMADA`).
2. **La máquina de estados de la vista** habla con `X+0xC` cuando cambia de estado. Si esos cambios los causa **un
   jugador** (el zoom, la muerte), tienen que correr con el contexto de ese jugador; si los causa **el juego** (pausa,
   cine), tienen que llegar a `V` **y** a `V2` (una primitiva nueva, **P4 difundir**). Se decide con T6 (zoom).
3. **Dónde suena** J2: el emisor de `V2+0x40` suena «en la cabeza» del oyente, que es J (N5): con Parsec los dos oyen
   lo mismo; prioridad baja, se acepta.

### Sonda del concepto (vivo, con lo que ya está instalado)

- **Predicción:** con el aislador **apagado** (`coop_mod.py poner --sin-aislar`, el control que ya existe), J2 dispara
  3 s y **su disparo suena** (`grabar_audio.py`: los picos del disparo aparecen), y vuelve el síntoma de (93k) (las dos
  mitades animan). Con el aislador **prendido**, en la misma corrida, J2 dispara 3 s: sólo impactos.
- **Refuta:** si con el aislador apagado J2 tampoco suena, el sonido no vive en `V` (o la bandera `*(X+0x24)+0x1E54`
  está en 1 mientras se actualiza J2) y la opción 1 no alcanza para F4.

## Clase A, la pasada 2 (T5, (102) nube): lo que se cuela entre mitades no es el puerto, es el modelo del arma compartido

### Concepción — qué se dibuja en cada pasada (`confirmado en frío`)

El modo dibuja **una** escena por pasada (`FUN_001297E0`, dos veces con la pantalla partida) y **después, una vez**, el
HUD y el menú (`FUN_001056C0`: `FUN_001F2618(hud)`, `FUN_0020B170(front-end)`). Dentro de la escena hay tres clases
de dibujo:

| Clase | Qué | ¿Se filtra por pasada? |
|---|---|---|
| **nodos del mundo** | el recorrido `FUN_00273A18(juego+0x4920, …, FUN_001297A0)`: personajes (y sus brazos FP con la ranura `+0x330`), objetos | **sí** (`ocultar`, (93b)) |
| **dibujos directos** | efectos del mundo (`0x0040F4D8`: `FUN_001C0518`, `FUN_001B1DC0`, `FUN_001BE4C0`, `FUN_001B1E00`), el doble búfer de unidades (`FUN_001D4F38`), la escena de RenderWare (`FUN_001C9088`), el tinte (`FUN_001B0AC8`), disparadores y depuración (`FUN_00166808`, `FUN_001ABE18` = **texto** de depuración) | **no**: salen en las dos mitades, cada una con su cámara |
| **después de la escena** | HUD, menú | una vez, pantalla completa |

`V` **no se dibuja**: ninguna función de la escena toca el contexto de efectos por llamada directa. `V` **anima** el
aparejo FP; el aparejo se dibuja desde el nodo del personaje.

### El mecanismo de F7 (y de E1, E5/F8, F9): la ranura 3 comparte el MODELO del arma con J

Una ranura FP (`0x240` B) tiene su **pose** propia y apunta en `+0x50` a un **sub**: la instancia del modelo del arma
para el índice `i` (`pers+0x398+i·0x6C`, construido por `FUN_001A8168` dentro de `FUN_001AC960`). En los cuatro
volcados, la ranura `i` de J tiene `+0x50` = `sub_i` (`confirmado en volcado`). La ranura 3 se carga con
`FUN_001A51C8(R3, J2, pers+0x398+i·0x6C)`, con `i` = el índice de J2 (`J2+0x2C3`): **R3 y la ranura `i` de J comparten el
sub** (`confirmado en frío` por construcción; `docs/15` ya lo anotaba como riesgo). Las **poses** están separadas
(medido en (96): 30/0 y 29/2 palabras), pero **lo que vive en el sub no**:

- **F7 «mergeada»**: J levanta la SPAS en el índice `i`; `FUN_001AC960` reconstruye `sub_i` con el modelo de la SPAS
  debajo de R3: J2 dibuja su pose con parte del modelo de J.
- **E1** (la recarga de J en la mitad de J2) y **E5/F8** (la recarga y el fogonazo de J2 en la mitad de J): las partes
  animadas del modelo (cargador, corredera, fogonazo si es del modelo) se mueven para los dos, en las dos direcciones.
- **Por qué «el puerto»** (hipótesis de (96)): **reemplazada**. La variable sería **el índice**: se ve cuando
  `J+0x2C3` = `J2+0x2C3`. En el video de Fran los dos arrancaron con el índice 0; en el fork, no se registró qué índice
  tenía cada uno (`hipótesis` a medir).

### Alternativas y elección

| Opción | Qué | En contra |
|---|---|---|
| **1. un sub propio para R3** (sub 3) | construir con las funciones del juego un tercer sub para el arma de J2, como se hizo con la ranura; R3 apunta a él | más memoria del montón de modelos (medir que entra, como el pool de 44 de (93n)) |
| 2. índices distintos | forzar que J2 use siempre el índice que J no usa | J cambia de arma y los choca; frágil |
| 3. aceptarlo | — | es lo que ve Fran |

**Elección: opción 1**, que termina el diseño de la ranura 3: J2 con pose **y** modelo propios.

### Sonda del concepto (vivo, con lo que ya está instalado)

- **Predicción A (RAM):** con el coop andando, `*(R3+0x50)` = `*(J+0x330+0x50)` cuando `J+0x2C3` = `J2+0x2C3`.
- **Predicción B (pantalla):** J con el arma de índice 0 (la misma que J2) recarga: la mitad de J2 muestra la recarga
  (E1). J cambia a su otra arma (índice 1) y recarga: la mitad de J2 queda quieta.
- **Control:** la misma corrida, en el orden inverso (primero índice 1, después 0), con J1 en el **mismo** puerto: si el
  puerto fuera la causa, las dos darían igual.
- **Refuta:** con índices distintos y la recarga de J visible igual en la mitad de J2 → no es el sub; se vuelve a
  «dibujos directos» de la tabla de arriba.
