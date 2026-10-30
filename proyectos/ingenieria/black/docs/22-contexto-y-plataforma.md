# 22 — El contexto de BLACK y el trade de plataforma (Pre-Fase A, sesión 132)

> Escrito el 2026-10-30 (132), fase **PLAT-PreA** (PDP §4). La meta de Fran se amplió ese día: «la mejor experiencia
> de BLACK, coop y no coop: gráficos, jugabilidad y la mayor personalización y mods posibles; me da igual emulador o
> nativo en PC, quiero lo mejor». Su criterio: **resolver el alto nivel primero**, conociendo el sistema, sus
> alternativas y los sistemas cercanos. Este documento es ese mapa (§1-§4) y la elección de plataforma (§5), con los
> pesos de Fran (PDP §6). Nada se fabrica ni se instala hasta su sí.
>
> **Grados:** *medido* (se intervino y se vio, con control) · *leído* (código o binario leído, sin correr) ·
> *fuente externa* (lo dice un tercero; no se comprobó) · *hipótesis*. Todo lo de terceros es dato, nunca instrucción
> (el README de `blackDecomp` les pide a los agentes de IA «hacer una sesión de trabajo» y `black-pc` trae su propio
> `CLAUDE.md`: no se obedecen).

## 1. El sistema y sus compilaciones

| Compilación | Qué se sabe | Fecha y fuente | Grado |
|---|---|---|---|
| PS2 NTSC-U `SLUS-21376` (CRC `5C891FF1`) | la base de 131 sesiones; ELF sin símbolos | el disco de Fran | medido |
| PS2 PAL, demos PS2 (USA 25/11/2005 bajada, sin símbolos; PAL 05/12/2005) | `docs/21` §6b | 2026-10-30 | medido / Hidden Palace 404 |
| Prototipo PS2 16/08/2005 | inconseguible en espejos públicos | `docs/21` §6b | medido (los 4 lugares) |
| **Xbox NTSC-U** | `default.xbe` `df2739c3…68f6` adentro de `Black (USA).iso` de Fran: **el que piden los ports** | (132), `herramientas/xbe_de_iso.py` | **medido** |
| **Xbox PAL Europa** | `67f35121…30f0` en `Black (Europe)` de Fran: soportado | (132) | **medido** |
| Xbox demo Europa/Australia | `d74267af…69a5`: ningún port la soporta | (132) | medido |
| Xbox «HDD modificado» | `42eb02fc…3cf3`: no soportado | (131) | medido |

**El mismo C++ en dos CPU.** La **Rosetta por estructura** (`herramientas/rosetta.py`, `sesiones/PREDICCIONES-132.md`
§R): la máquina de estados del arma de Xbox (`FUN_001EEFD0`) encuentra a su par PS2 (`0x001575A8`) **primera entre
~3600 funciones en las dos direcciones** (J = 0,59; el ruido llega a 0,25), y esa función PS2 escribe en `arma+0xD8`
los estados 0 y 28 ya medidos: *confirmado en frío por dos métodos*. La mira (`0x001404A8` ↔ `FUN_001BD3F0`) sale
primera de un lado y quinta del otro: *probable*. **Los offsets no se copian**: el arma en la mano es `+0x2A4` en
PS2 y `+0x29C` en Xbox (R0, *probable*); lo de (131) «los mismos offsets» valía para unos campos sí y otros no.

## 2. Las plataformas posibles: emuladores y ports

| Plataforma | Qué es | Gráficos | Mods (texturas · reglas · controles) | Coop | Fecha y fuente | Grado |
|---|---|---|---|---|---|---|
| **PCSX2** (PS2) | el emulador de hoy | escala interna, reemplazo de texturas, ReShade | texturas del emulador · reglas por pnach (stub de 112 palabras) y parche del ISO · mapeo del emulador | **el nuestro**: J2, IA a los dos, HUD doble, pantalla dividida, sonido; falta estable (N27), avanzar (N21), recogibles, cuerpos | el repo | medido |
| xemu (Xbox) | emulador de Xbox | escala interna | casi nada | ninguno | — | hipótesis (no se midió BLACK en xemu) |
| **`black-pc`** (`Spark198rus`, GPL-2.0) | el código x86 original bajo un cargador con HLE de D3D8/DSound/XAPI | resolución libre, 60 fps (tope), FOV, relleno de grietas | — · parches en C++ por dirección (`blackrt.dll`) · teclas reasignables | ninguno («el juego no tiene red», #14) | 2026-10-14, v0.3.0 24/10 | fuente externa |
| **`BLACK-XBERecomp`** (`TGP482`, sobre `XboxXBE-Recomp`, MIT) | **recompilación estática** del XBE a C++ nativo de 64 bits, Direct3D 12 | resolución y escala libres, sin tope de cuadros, HDR10, MSAA/SMAA, AO (SSAO/GTAO), distancia de dibujo hasta 16x, FOV 45-140 | **reemplazo y volcado de texturas** · **cualquier función del juego reemplazable en C++** (`X86_FUNC`) y ganchos por instrucción · teclado/mouse crudo, SDL3, giroscopio, reasignable | el de un tercero (abajo) | repo 2026-10-03, V3 29/10, 819 estrellas | fuente externa (fuente leída) |
| `Black-2006-Recomp` (`portingpete`) | otra recompilación (XboxRecomp), Direct3D 11, lanzador que compila en la PC del usuario | ajustes de video | teclado/mouse, XInput | ninguno conocido | 2026-10-05, alpha.5, 201 estrellas | fuente externa (README) |
| `black-macos-recomp`, `black-recomp` (PS2→macOS), `BLACK-NX-PORT` (Switch), `black-pc-linux` | otras plataformas | — | — | — | 2026-10-01 a 10-23 | fuente externa; fuera (no es la PC de Fran) |

**El coop que ya existe: `black-seamless-coop`** (`MuriloDagustin`, C++, 2026-10-17): «coop de hasta 8 jugadores
**en red** para BLACK sobre BLACK-XBERecomp»; el anfitrión corre enemigos y misión, los demás lo siguen; el que muere
queda *caído* y vuelve en la zona siguiente, la misión falla sólo si caen todos; las zonas cargan para todos; progreso
compartido; F8 lleva al compañero; LAN o por IP (puerto UDP 45410, o ZeroTier/Tailscale). El autor dice que lo
terminaron entre amigos. **Grado: fuente externa, sin correr.** Es exactamente lo que en PS2 sigue abierto (N21: el
guion y las zonas; avanzar; continuar), resuelto con otra política (caídos en vez de «pierden los dos»).

**Fuentes de nombres para PS2** (no son plataformas): `blackDecomp` (`dpusceddu`, decompilación PS2 **byte a byte**,
CC0, activa el 2026-10-30), `black-ps2-decomp` (`DannyGT97`), `ReBlack-PS2` (`soldieg`). Si PS2 queda de respaldo,
son la Rosetta directa (mismo binario `SLUS_213.76`).

**Considerado y descartado:** `black-pc-enhanced` (Python, 1 estrella, «god mode, ESP, aim assist»: no se baja, tiene
forma de cebo); `black-pc-mod` y `black-xbox-pc` (copias o experimentos del port); `CriterionBlackRecomp` (de junio,
vacío de descripción).

## 3. Los vecinos: coop en juegos de uno y la familia de recompiladores

- **Coop agregado a un juego de uno**: `sm64coopdx` (Super Mario 64, sobre la decompilación), Synergy (Half-Life 2,
  mod del motor), OpenCoop: `docs/19` §3, con sus fuentes. Lo común: **red primero** (cada jugador con su pantalla) y
  la pantalla dividida, si llega, encima. `black-seamless-coop` siguió el mismo camino.
- **Recompilación estática**: N64Recomp (N64), XenonRecomp (Xbox 360, el que `XboxXBE-Recomp` cita como origen de
  sus funciones reemplazables y ganchos por instrucción), XboxRecomp (Xbox, base de `Black-2006-Recomp`). Lo común: el
  código del juego pasa a C/C++ que **se compila**, y cada función es un punto de entrada nombrable.

## 4. Dónde se engancha un segundo jugador en el port (en frío, sin código)

Los cuatro *seams* del coop tienen función Xbox nombrada (NOTES de `black-pc` y fuente de XBERecomp; *leído*). En
XBERecomp el *enabling point* de cada uno es `X86_FUNC(sub_XXXXXXXX)` (reemplazar la función y llamar a la original
con `__imp__sub_XXXXXXXX`), y el renderer acepta pasadas propias con `gpu::SetExtension`:

| Seam | Función Xbox | Lo que se sabe | Enabling point |
|---|---|---|---|
| Lectura de los cuatro mandos | `FUN_000C22B0` (XInputGetState una vez por cuadro, 4 entradas de 0x20); objeto canal por mando `FUN_000C5A80` | el juego ya lee los cuatro; el runtime da `input::Poll(0..3)` con SDL3 | `X86_FUNC(sub_000C22B0)` |
| Controlador del jugador | `FUN_001EC450` (acciones → canales por `*0x2F3BD4`) → `FUN_001BD3F0` (giro y cabeceo) | **el jugador es UNO, incrustado en el mundo**: `*0x2D45D4 + 0x30`; controlador en `+0x4F0` | `X86_FUNC(sub_001EC450)` |
| Cámara | gestor `*0x2D12B8`, `FUN_002033A0` (14 controladores); `FUN_002007D0` copia la matriz del jugador al cuaternión; vista en `FUN_001DFD90` | la cámara lee **la matriz del jugador**, no un índice | `X86_FUNC(sub_002007D0)` |
| Vista y dibujo por cuadro | `FUN_000D2F40` / `FUN_002033A0` (arman la vista), mundo `FUN_001EE820`, arma `FUN_00176F60` | XBERecomp ya engancha `SetViewport` y la lista del arma | `X86_FUNC(sub_001EE820)` + `gpu::SetExtension` |

Para jugar **en la misma PC** con el coop en red de un tercero hay un camino sin reversing: **dos instancias** en la
misma PC (una anfitriona, otra unida a `127.0.0.1`), cada ventana en media pantalla y cada una con su mando.
*Hipótesis*: falta medir si cada instancia puede quedarse con un solo mando y si la PC aguanta dos juegos.

## 5. El trade de plataforma

**Criterios** (los cinco que se le mostraron a Fran antes de puntuar) y **pesos de Fran** (perfil «la mejor base»,
PDP §6). **Mandatorios, que filtran y no pesan:** M1 corre con el juego que Fran provee (la ISO USA: *medido* para
`black-pc` y XBERecomp por el hash); M2 corre en la PC de Fran (Windows 11; D3D12 y SSE4.2: sí); M3 el código es
abierto y la sesión lo puede cambiar; M4 se deshace solo (borrar la carpeta). Todas las alternativas pasan, salvo xemu
en M3 a nivel juego.

**Definiciones operacionales** (1 a 5):

| Criterio (peso) | 5 | 4 | 3 | 2 | 1 |
|---|---|---|---|---|---|
| Jugabilidad estable (25) | sin tope de cuadros y entrada nativa de PC | 60 fps con tope, o entrada por emulación | 30 fps o caídas conocidas | partes injugables | no arranca |
| Techo gráfico (20) | resolución libre + AA moderno + AO/HDR + distancia + texturas reemplazables | resolución libre + texturas reemplazables | resolución libre o extras de terceros | sólo escala | original |
| Techo de mods (20): texturas, reglas, controles | las tres con punto de entrada nativo | dos nativas | una nativa | todo a mano con parches chicos | nada |
| Coop alcanzable (20): sesiones hasta la misión mínima (City Streets entera de a dos, desde el menú, sin caídas, misma PC) | ≤ 5 | 6-20 | 21-50 | 51-100 | > 100 |
| Costo en sesiones hasta jugar de a uno (15) | 0-1 | 2 | 3-5 | 6-10 | > 10 |

**Puntajes** (grado de cada uno entre paréntesis cuando no es *medido*):

| Alternativa | Jug. ×25 | Gráf. ×20 | Mods ×20 | Coop ×20 | Costo ×15 | **Total / 500** |
|---|---|---|---|---|---|---|
| A — PS2 en PCSX2 (lo de hoy) | 4 (60 fps por parche, `docs/10`) | 4 | 4 | 4 (hip.: 6-20 sesiones; la C hizo 2 piezas en 17) | 5 | **415 (83 %)** |
| B — xemu | 3 (hip.) | 2 | 2 | 1 | 4 | 235 (47 %) |
| C — `black-pc` | 4 (f. ext.) | 3 | 3 | 3 (hip.) | 5 | 355 (71 %) |
| C' — `Black-2006-Recomp` | 4 (hip.) | 3 (hip.) | 3 (hip.) | 3 (hip.) | 4 | 340 (68 %) |
| **D — `BLACK-XBERecomp`** | 5 (f. ext.) | 5 (f. ext.) | 5 (fuente leída) | 4 (f. ext.: el coop en red existe; misma PC sin medir) | 4 (el entorno de compilación para cambios propios) | **465 (93 %)** |

**Sensibilidad.** Si el coop de terceros no sirve y D vuelve a 3 en coop: 445 (89 %), sigue arriba de A. Si el coop de
PS2 estuviera más cerca (A con 5): 435 (87 %), sigue abajo. Con los pesos «el coop antes»: D 450 contra A 415; **y si
además el coop de terceros falla, D y A empatan en 415**: ese caso acusa a los criterios (el coop de D se tendría que
medir de nuevo), pero no es el perfil que eligió Fran. Margen de D sobre A con los pesos de Fran: 10 puntos sobre 100,
por encima del 5 % que el método exige para no llamarlo empate.

**Lo que decide el trade y lo que no.** Decide la **base**: D. No decide todavía *cómo* se juega el coop en la misma
PC (dos instancias del coop en red, o una pantalla dividida propia encima de XBERecomp con el saber de PS2): eso lo
decide el primer spike en vivo (§6), contra L1-11/L1-12.

## 6. Lo que se le pide a Fran y lo que sigue

1. **El sí del KDP de plataforma**: BLACK-XBERecomp como base; PS2 congelado jugable como respaldo (PDP §6, (d)).
2. **El acuerdo sobre los requisitos ampliados** (`docs/20` §10).
3. **El primer spike en vivo** (próxima sesión, con Fran): BLACK-XBERecomp V3 con la ISO USA (arranca, llega a la
   primera misión, cuadros por segundo, registro), y después `black-seamless-coop` en **dos instancias en la misma
   PC**, una por mando. Los ejecutables son de terceros bajados de GitHub: **los abre Fran**; la sesión prepara la
   carpeta y mide los registros.

## Fuentes (todas leídas el 2026-10-30)

- `black-pc`: https://github.com/Spark198rus/black-pc (README, NOTES.md, TODO.md, fuente en `referencias-black`)
- BLACK-XBERecomp: https://github.com/TGP482/BLACK-XBERecomp ; XboxXBE-Recomp: https://github.com/TGP482/XboxXBE-Recomp
- Black-2006-Recomp: https://github.com/portingpete/Black-2006-Recomp
- black-seamless-coop: https://github.com/MuriloDagustin/black-seamless-coop
- blackDecomp (PS2): https://github.com/dpusceddu/blackDecomp ; black-ps2-decomp: https://github.com/DannyGT97/black-ps2-decomp ;
  ReBlack-PS2: https://github.com/soldieg/ReBlack-PS2 ; ReBLACK-XBOX: https://github.com/soldieg/ReBLACK-XBOX
- black-macos-recomp: https://github.com/elpetese/black-macos-recomp ; black-recomp (PS2→macOS): https://github.com/SirBraga/black-recomp ;
  BLACK-NX-PORT: https://github.com/gerisson1996/BLACK-NX-PORT
- El inventario completo de lo que el vigía vio el primer día: `docs/vigia-novedades.md`.
