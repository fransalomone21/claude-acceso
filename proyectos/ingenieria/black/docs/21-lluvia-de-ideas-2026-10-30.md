# 21 — Segundo momento lluvia de ideas del coop (2026-10-30, sesión 130)

> **Por qué ahora.** Lo pidió Fran: «revisá el proyecto desde el alto nivel, mi necesidad hacia abajo, y redefiní los
> caminos donde bajamos a muy bajo nivel sin antes tomar la mejor decisión de arriba. No bajar a una cueva de silicio
> si lo que necesitaba para hacer una batería era darme cuenta de que la batería ya existía». Y: «el método de prueba
> del emulador y del juego, el tuyo automático, que sea el mejor en costo y con las herramientas más actuales».
> No reemplaza al primero (`docs/19`, 2026-10-12): lo continúa. Desde entonces la máquina no cambió (fork cerrado,
> pnach por defecto 1059) y el orden de (129) no se ejecutó.
>
> **Grados:** *medido*, *leído*, *fuente externa* (dicho por otro, sin verificar acá), *hipótesis*.

## 0. La meta y el estado contra ella

La meta no cambió: **dos personas juegan la campaña de BLACK juntas** (N-01 en `docs/20` §2). La tabla de `docs/19`
§0 sigue valiendo fila por fila: lo que decide si **se puede jugar** (estable, avanzar por zonas y guion, continuar,
munición para J2) sigue sin medir o roto; lo que se trabajó (el arma de cada uno) es fidelidad.

**Venimos:** 25–35 % de la Fase C (1 pieza y media de 5, sin la regresión ni «continuar»), y la D (jugarla de a dos)
sin empezar. Lo nuevo de hoy: **existe el documento de requisitos** (`docs/20`, 39 enunciados, 0 violaciones del
GtWR), con la traza de lo ya fabricado y el plan de V&V.

## 1. ¿Están claros los conceptos?

- **Requisitos: ahora sí** (`docs/20`), sin acordar todavía con Fran.
- **Qué es «terminado»:** la C cerraba «por pieza», con un banco propio por pieza. Contra los requisitos, terminado es
  **una suite que mide L1-01..L1-25 de un saque**. Eso no existe, y es la cueva más cara del proyecto (§4, P4).
- **El estado se volvió historia:** `ESTADO_ACTUAL.md` 148 KB, `sesiones/HANDOFF.md` 272 KB (medido hoy por la
  cascada). Sigue pendiente de una sesión de método.

## 2. ¿El reloj estaba puesto? — la batería que ya existía

**La que se pasó por alto: el prototipo del PROPIO BLACK.** La lluvia de (129) buscó símbolos en el pariente (Burnout
Dominator, Burnout 3) y nunca en las otras compilaciones del juego mismo. Existen (Hidden Palace, *fuente externa*,
página leída hoy):

| Compilación | Qué es | Dónde |
|---|---|---|
| **Black, prototipo del 16/08/2005** | disco interno PAL («BLACK Pal Disc# 1 M9 … INTERNAL USE ONLY»), 5 meses antes del final; «no arranca en PCSX2 salvo que se rearme la imagen» | Hidden Palace, liberado el 2020-09-03; **el enlace de bajada da «el archivo no existe»** (hoy) |
| Black, demo PS2 del 25/11/2005 y del 05/12/2005 | demos públicas previas al final | Hidden Palace (sin bajar) |
| Black, demo Xbox del 05/12/2005 | la otra plataforma | Hidden Palace (sin bajar) |

Por qué pesa más que Burnout: es **el mismo código**, cinco meses antes. Un disco interno de esa época suele traer el
ELF sin podar o un `.map` (*hipótesis*: la página no lo dice). Con símbolos del propio juego, el doble búfer del arma,
el cargador, el HUD, la pausa y el guion —donde se gastaron (116)–(128)— tendrían nombres, y Ghidra *Version
Tracking* los porta al ELF final función por función. Sin símbolos, igual sirve: un prototipo trae **menús de
depuración y comprobaciones** que el final saca.

**Búsqueda hecha hoy, con su parámetro:** archive.org por identificador (`BlackAug162005prototype`, el patrón de las
otras liberaciones del mismo grupo: `IndigoProphecyAug162005prototype`, `007FromRussiawithLoveAug162005prototype`) y
por texto: **cero**. Un cero acusa al parámetro: falta probar los espejos de Hidden Palace y su canal. La página de
TCRF de BLACK traía texto dirigido a agentes: se ignoró.

**Primer sondeo** (10 minutos con el archivo en mano): leer las secciones del ELF del prototipo (`.symtab`,
`.mdebug`, `.debug_*`) con el control positivo de siempre (`.text` y `.bss`). Si hay símbolos, Version Tracking.

**Lo que PCSX2 ya trae y el banco no usa** (*medido* en el disco hoy, salvo donde se dice):

- **El coop se aplica en modo continuo**: 1116 de 1117 líneas del pnach instalado son `patch=1` (se reescriben cada
  cuadro). Una foto de estado (savestate) tomada con una versión vieja del mod **vuelve a tener el código nuevo al
  cuadro siguiente**; lo único viejo son los datos del mod. Por eso las fotos sirven como precondición reutilizable.
- **Fotos de estado por PINE** (`pine.py cargarestado`/`guardarestado`): ya se usan, pero cada banco relanza el
  emulador entero (35 s fijos) en vez de recargar una foto.
- **Grabación de entradas de PCSX2** (`.p2m2`, en la versión principal desde 2019, pensada para TAS; *fuente
  externa*: blog de PCSX2): reproduce desde una foto, pero se desincroniza entre versiones. El mando falso por
  memoria (`sondas_coop.py`) ya hace lo mismo sin esa fragilidad: se queda el mando falso.

## 3. Lo que otros ya resolvieron

| Quién | Qué resolvió | Cómo | Qué nos dice |
|---|---|---|---|
| Los TAS de PCSX2 (tasvideos) | reproducir una partida igual cada vez | foto de estado + entradas grabadas | la precondición es **una foto**, no una receta de 40 s cada corrida |
| La práctica de QA de juegos (*hipótesis* de oficio, sin fuente acá) | encontrar caídas sin que nadie juegue | **pruebas de aguante**: bots con entradas al azar con semilla durante horas, y la semilla guardada cuando algo se cae | L1-01 (60 min sin caídas) se mide así, no con una prueba por pieza |
| Los proyectos de coop de `docs/19` §3 (sm64coopdx, Synergy, OpenCoop) | el coop de juegos de uno | jugarlo y arreglar lo que frena | el trazador jugado de (129) sigue siendo la validación más barata, y lleva 18 días sin hacerse |

## 4. Las palancas, de la más alta a la más baja

**P1 · Meta: validar jugando, ya.** El trazador jugado (tramo 2) es la prueba que más informa por unidad de costo:
una tarde de Fran con otra persona contesta de una las filas 6–9 de `docs/19` §0. Lleva 18 días esperando a que la C
termine piezas. Se hace **antes** de fabricar más, con el registro de memoria prendido. Se deshace: sí. Grado: el
valor es *hipótesis*, el costo es *medido* (una sesión de Fran).

**P2 · Flujo de información: los requisitos y el prototipo.** Los requisitos ya están (`docs/20`). El prototipo
(§2) es la otra mitad: nombres del propio juego en vez de inferirlos capa por capa.

**P3 · Regla: ninguna pieza se prende sin la suite verde, y ninguna pieza trae su banco propio.** Cada pieza pasa a
ser **escenarios** del banco coop, con su control. Lo que cambia: la próxima pieza no gasta una sesión en escribir y
depurar su banco.

**P4 · Estructura: el banco coop** (`herramientas/banco_coop.py`, requisitos L2-BAN-01..10 en `docs/20` §5). Hoy hay
**diez bancos sueltos** (`campana_coop`, `hud_pieza_banco`, `sonido_pieza_banco`, `arma_pieza_banco`,
`soporte2_banco`, `f7_soporte`, `f7b_pausa`, `n27_banco`, `s1_juntar`, `matar_sin_manos`), cada uno con su arranque,
sus esperas fijas, su precondición escrita a mano y su forma de imprimir. Tres construyen su precondición; los otros
la suponen (lección 336). La cueva fue esa: **cada pieza bajó a escribir su banco sin una arquitectura de prueba
decidida arriba.** El diseño, de lo alto a lo bajo:

| Parte | Qué hace | Por qué así (costo) |
|---|---|---|
| **Sesión de emulador larga** | un `lanzar()` por suite; entre escenarios, recarga una foto; relanza sólo si el veredicto fue «muerto» | 35 s por arranque contra ~3 s por foto |
| **Fotos de precondición** (`volcados/fotos/<escenario>.p2s` + `.json` al lado con el md5 del pnach, el nivel y lo que se midió al sacarla) | la precondición se construye **una vez** con la receta y se reusa; el banco mide la precondición al cargarla (L2-BAN-02) y la regenera si los datos del mod cambiaron de versión | `patch=1` reescribe el código; los datos del mod se revisan contra el sidecar |
| **Escenario = datos** | un diccionario: foto, pasos (entradas de **los dos** jugadores a la vez), observadores (direcciones), oráculo (predicado), pieza que controla | agregar una prueba es agregar una entrada, no un script |
| **Control** | la misma lista de escenarios con la pieza apagada, agrupada en una sola reinstalación del pnach | el control es obligatorio (L2-BAN-03) y caro: se agrupa |
| **Guardián** | el contador de J2 y el PC del EE muestreados cada 2 s; si no se mueven, «muerto» con su foto | L2-BAN-04; la lección del juego colgado leído como conducta (123) |
| **Veredicto** | cinco: verde, rojo, muerto, sin precondición, reventado; una línea por escenario; el JSON completo a disco | L2-BAN-05/06: la sesión lee ≤ 40 líneas; las capturas se guardan sólo en rojo y nadie las mira si el veredicto alcanza |
| **Suite de aguante** | 10 min por misión, los dos jugadores con entradas al azar desde una semilla (caminar, mirar, disparar, recargar, cambiar de arma, pausa de J1), reiniciando la misión al morir; mide caídas, muertes y cuadros por segundo con el contador de cuadros del juego contra el reloj | L1-01..03 sin que nadie juegue; con semilla, un rojo se reproduce (L2-BAN-09) |
| **En segundo plano** | se lanza con `run_in_background`; la sesión espera el aviso | cero tokens mientras corre |

Cómo se construye: **como trazador**, no en el aire. La primera suite es la regresión de R4 (tramo 1): carga +
pausa + vuelta + dos cargas en los 8 niveles, con su control sin R4. Si el esqueleto pasa eso, se le suman los
escenarios de las piezas existentes y después el aguante.

**P5 · Estructura: memoria de sobra (128 MB, la P4 de `docs/19`).** Sin cambios: spike corto antes de rediseñar el
arma (tramo 6).

**P6 · Estructura: el censo del jugador de arriba hacia abajo** (la P5 de `docs/19`). Si el prototipo trae símbolos,
el censo se arma con nombres y cuesta la mitad.

**P7 · Parámetros:** seguir con R1–R3 del arma. Techo puesto; espera a P5 y al prototipo.

**Consideradas y descartadas** (NASA 6.8):

- **Grabación de entradas de PCSX2 (`.p2m2`) como motor del banco**: se desincroniza entre versiones y sólo arranca
  desde una foto propia; el mando falso por memoria ya anda en pleno juego. Descartada.
- **Que la sesión mire video o capturas para decidir**: cada imagen cuesta del orden de mil tokens y el veredicto por
  memoria es más fino. Queda sólo para la validación con Fran y para un rojo sin explicación.
- **Manejar el emulador por MCP (PCSX2-MCP) durante la suite**: cada llamada pasa por la sesión y cuesta plan; la
  suite corre sin la sesión adentro. El MCP queda para depurar un rojo.
- **Acelerar el emulador en todas las pruebas**: el ritmo (L1-02/03) se mide a velocidad normal. Sólo el aguante
  puede ir acelerado, y recién después de medir que no cambia lo que se busca (*hipótesis*).

## 5. Lo que se deja de hacer

- **Bancos nuevos por pieza.** Desde hoy, escenarios del banco coop.
- **Relanzar el emulador por escenario** y las esperas fijas en segundos.
- **Leer capturas en las corridas normales.**
- **Fabricar piezas antes del trazador jugado**: hasta que Fran juegue City Streets, no se sabe qué frena de verdad.

## 6. El orden propuesto

1. **Hoy, hecho:** los requisitos (`docs/20`) y este documento.
2. **El banco coop como trazador con la regresión de R4** (tramo 1). Una sesión, sin Fran. Si R4 pasa 8/8 sin bajar
   el ritmo, se prende por defecto.
3. **El trazador jugado** (tramo 2): Fran y otra persona, City Streets desde el menú, con R4 prendida, grabando y
   con `v4_registro.py` + `guardado_auto.py`. Las fotos que deja son las precondiciones de los escenarios de zona y
   guion (L1-06, L1-07).
4. **En paralelo, el prototipo:** conseguir el archivo y leer sus secciones (§2). Si trae símbolos, Version
   Tracking antes de tocar el arma o el censo.
5. **La suite de aguante** sobre lo que deje el trazador; después, los tramos 3–6 del PDP §4 en su orden.

## 6b. (131) La búsqueda de las otras compilaciones, hecha — y lo que apareció en su lugar

Pedido de Fran (2026-10-30): «investigá bien si existe y bajá cualquier versión que hipotéticamente pueda ayudarnos
a lograr el coop». Todo lo bajado vive **fuera del repo**, en `C:\Users\frans\herramientas\referencias-black\`.

| Qué | Resultado, con su parámetro | Grado |
|---|---|---|
| Prototipo PS2 del 16/08/2005 | Hidden Palace: **404** el archivo, y también las dos demos PS2 y la demo Xbox (todos sus enlaces de BLACK; la página pide «no subir builds de PS2 directo»). archive.org: cero por identificador, por título y por fecha. Myrient: **cerró el 2026-03-31**. Redump.org: rechaza la conexión. Sin espejo público encontrado | confirmado (no está en esos 4 lugares) |
| Demo PS2 USA del 25/11/2005 (Redump 28438) | **Bajada** de archive.org (`BlackUSADemo`), md5 del 7z `b00cdb4f…060d` = el publicado. ELF `SLUS_291.80` (md5 `106a15a9…2c41`): **sin símbolos** (sin `.symtab`, `.mdebug.eabi64` de 0 bytes, `.debug_str` de 1); control positivo: `.text` 0x2616C8 y `.bss` se leen bien. Un nivel (LEVEL_00) | confirmado |
| Demo PS2 PAL del 05/12/2005 y demo Xbox | sólo en Hidden Palace (404) | — |
| **`black-pc`** (GitHub `Spark198rus/black-pc`, GPL-2.0, 2026-10-14, v0.3.0 del 24/10) | **port nativo a Windows de la versión XBOX**: `black.exe` carga el `default.xbe` propio y corre el código x86 original con HLE de Direct3D/DirectSound/entrada; «totalmente jugable», 60 fps, cualquier resolución, mouse, XInput, menú de opciones propio dentro del juego. Pide el disco Xbox **NTSC-U o PAL Europa** (SHA-256 del `default.xbe` en su README). Fuente y release bajados; **el .exe no se corrió** | confirmado que existe; jugable = *fuente externa* |
| **`ReBLACK-XBOX`** (GitHub `soldieg`) | reconstrucción en C/asm de las **13 676 funciones** del XBE, cada una igual byte a byte tras recolocar (dicen ellos), nombres `sub_XXXXXXXX`; sigue en `Project-ReBlack` | *fuente externa* |

**Lo que cambia decisiones — las estructuras de Xbox y de PS2 tienen los mismos offsets** (*probable*: cinco
coincidencias independientes, sin medir en vivo). `black-pc/NOTES.md` documenta el código Xbox con direcciones y
offsets, y cruzado contra `kb/estructuras.json`: estado del arma `+0xD8` (las dos), arma en la mano `jugador+0x2A4`
(las dos), `jugador+0x29C` puntero (las dos), cargador `u16 +0x18` (las dos), campo `+0x2E0` del jugador (las dos). Es
el mismo C++ de Criterion compilado para dos CPU de 32 bits: **las notas de Xbox sirven de piedra Rosetta para PS2**.
Ya traen resuelto, del lado Xbox, buena parte de lo que el coop necesita: la cadena de entrada (lectura de **cuatro
mandos** en entradas de 0x20 bytes, objeto canal por mando, tabla de acciones → canales), el controlador del jugador
(giro y cabeceo), el gestor de cámara con sus 14 controladores, el viewport que el juego pone cada cuadro, la
pausa, la máquina de estados del arma y el reloj del mundo.

**Dos caminos que esto abre** (decide Fran: es de valor, no técnico):

1. **Seguir en PS2 usando Xbox como piedra Rosetta.** Barato: leer `NOTES.md` y la reconstrucción en C antes de cada
   pieza; la función Xbox con nombre por rol + los mismos offsets acortan la búsqueda en el ELF MIPS. No cambia nada
   de lo fabricado.
2. **Hacer el coop sobre `black-pc`** (x86 en PC, ganchos en C++ con un depurador de verdad, los cuatro mandos ya
   leídos por el juego). Precio: el disco Xbox NTSC-U o PAL Europa **propio** y volcado a ISO (el port no trae el
   juego), un proyecto de terceros de dos semanas, y rehacer en x86 lo que hoy anda en PS2. Una copia retail bajada
   de internet no entra: la sesión no la baja.

**Primer sondeo de cualquiera de los dos** (en frío, sin Fran): tomar tres funciones ya identificadas en PS2 (la
máquina de estados del arma, la entrada del jugador, la pausa) y encontrar su par en `NOTES.md` por los offsets; si
las tres casan, la Rosetta pasa a *confirmado* y entra en `docs/02-metodologia.md`.

## 7. Las decisiones de Fran

1. **¿Acordás la línea base?** El alcance y los requisitos L0/L1 de `docs/20` (§2–§4): sí, o qué cambiás. Hasta tu sí
   son borrador (un requisito no acordado no es requisito).
2. **¿Cómo lo van a jugar en serio: los dos en tu PC con dos mandos, o cada uno en su casa por Parsec?** Decide si
   L1-24 entra en la v1 y cómo se valida (H-03).

## Fuentes

- Hidden Palace, Black (Aug 16, 2005 prototype): https://hiddenpalace.org/Black_(Aug_16,_2005_prototype)
- Hidden Palace, prototipos de PS2: https://hiddenpalace.org/Prototypes_by_system/PlayStation_2
- PCSX2, informe de progreso 2018–2019 (grabación de entradas): https://pcsx2.net/blog/2019/from-q2-2018-to-q2-2019
- PCSX2, PR de la grabación de entradas (`.p2m2`): https://github.com/PCSX2/pcsx2/pull/2412/files
- Unseen64, Black beta: https://www.unseen64.net/2010/02/02/black-ps2-xbox-beta/
- archive.org, Black (USA) (Demo): https://archive.org/details/BlackUSADemo
- black-pc (port nativo de la versión Xbox): https://github.com/Spark198rus/black-pc
- ReBLACK-XBOX (reconstrucción del XBE): https://github.com/soldieg/ReBLACK-XBOX ; Project-ReBlack: https://github.com/soldieg/Project-ReBlack
