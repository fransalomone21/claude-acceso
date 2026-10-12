# 19 — Momento lluvia de ideas del coop (2026-10-12, sesión 129)

> **Qué es.** La primera instancia de la necesidad transversal **`lluvia-de-ideas`** (pedida por Fran el
> 2026-10-12): frenar la ejecución, mirar el proyecto desde arriba y redireccionarlo hacia las decisiones creativas
> ganadoras **antes de raspar el fondo de la olla**. Se ordena **de lo fundamental a lo específico**; lo específico
> que aparezca antes lleva su justificación escrita.
>
> **Por qué ahora.** La Fase C abrió en (114). La pieza 1 (HUD) se hizo en una sesión; la pieza 2 (el arma de J2)
> lleva **13 sesiones, (116)–(128), y sigue abierta**: sonido hecho, modelo no, y en el camino aparecieron cinco
> capas del mismo defecto (sub3, soporte, accesorios, doble búfer, montón del menú). Hunt & Thomas: «esto cuesta mucho
> más de lo que debería» es un disparador, no una queja.
>
> **Método** (el que implementamos): la cátedra, `apunte-iise/.../m24-crear-arquitecturas.typ` (síntesis y
> descubrimiento a partir de sistemas heredados y análogos; métodos normativo, racional, participativo y heurístico;
> factores de balance; el proceso vuelve a las necesidades); NASA SEH §4.4 (crear alternativas, refinamiento
> sucesivo, el sesgo del autor, la trampa del *heritage*) y §6.8.1.2.2 (alternativas por *brainstorming* con quien
> conoce el contexto y por búsqueda de sistemas relacionados); INCOSE §4.2.2 ágil (conciencia situacional continua;
> una etapa puede cerrar con conocimiento que cancela la siguiente); Meadows (la escala de palancas).
>
> **Grados:** *medido* (se intervino y se vio), *leído* (código o página leída, sin probar), *fuente externa* (dicho
> por otro, sin verificar acá), *hipótesis*.

---

## 0. La meta, y dónde estamos contra ella (lo fundamental)

**La meta** (`docs/00-conops.md` R5, `PDP.md` §4): *dos personas juegan la campaña de BLACK juntas*, en pantalla
dividida, en PCSX2; después, a distancia con Parsec. La validación es una sola: que dos personas la jueguen.

| # | Capacidad que la meta necesita, de la más básica a la más fina | Hoy | Grado |
|---|---|---|---|
| 1 | J2 existe en cada nivel, camina, mira, dispara, hace daño | sí | medido (A, B) |
| 2 | Cada uno con su vista (pantalla partida) | sí, ~30 c/s; ~24 en tres niveles | medido |
| 3 | El mundo lo trata como jugador: la IA le tira; si muere uno pierden los dos | sí | medido (111) |
| 4 | Cada uno ve su vida y su munición (HUD por mitad) | sí | medido (115) |
| 5 | El disparo de J2 suena | sí | medido (119) |
| 6 | **Estable: una partida no se cae** | **no**: N27 cae con el pnach por defecto (pausa + cambio de arma de J2); R4 la tapa y está apagada | medido (128) |
| 7 | **Avanzar: zonas y eventos de guion con J2 adentro** | **sin medir**: el problema nunca se vio jugando de punta a punta; N21, las bombas del guion matan a J2 rezagado → «MISSION FAILED» | medido una vez (114) |
| 8 | **Seguir otro día: «continuar misión»** | **sin medir** desde (114) (el banco de depuración no guarda puntos de control) | — |
| 9 | **Sostener la pelea: J2 junta munición y botiquines** | **no**: J2 junta lo que está bajo J | medido (B) |
| 10 | Ver al otro: un cuerpo para cada uno | J2 en 5 de 8 niveles; J sin cuerpo en la mitad de J2 | medido |
| 11 | Ver tu propia arma en tu mitad (F7) | no: el que cambió último se dibuja en las dos; la 2d lo arregla y está apagada | medido (124)–(126) |
| 12 | Carteles en las dos mitades, zoom propio | parcial / no | leído |
| 13 | Jugar a distancia (Parsec) | nunca probado | — |

**Venimos.** La Fase C se cierra con 5 piezas + la regresión 8/8 + «continuar misión». Hay 1 pieza entera y media
(la 2a): **25–35 % de la C**, y la D (que lo jueguen dos personas) no empezó. Al ritmo de la pieza 2, lo que falta son
**20–50 sesiones**. Ese número, no un síntoma, es lo que pide esta revisión.

**Lo que dice la tabla:** las filas 6 a 9 son las que deciden si **se puede jugar la campaña**; las 10 a 12, si
**se ve perfecto**. La C viene trabajando la 11 (fidelidad) con las 6–9 abiertas. No es un error de ejecución: es el
orden que se aprobó en la PDR (114) («lo más visible primero»), cuando no se sabía que la pieza 2 costaba 13 sesiones.

## 1. ¿Están claros los conceptos? Diagnóstico

Lo que está bien claro: el método de cada pieza (predicción, control, dos cargas), el mapa de madurez K, la PDR.
Lo que **no**:

1. **No hay documento de requisitos del coop.** La cascada lo marca («DISEÑO SIN REQUISITOS»): R5 es una línea del
   ConOps y los requisitos del mod viven repartidos entre `docs/14`, el `PDP` §4 y `docs/18`. Sin ese papel, el orden
   de las piezas no se puede justificar contra nada: sólo contra el orden en que se aprobaron.
2. **El modelo del jugador no está en un solo lugar.** Qué estado es *del jugador* y qué es *del mundo* vive repartido
   en `docs/16` (145 KB, escrito por sesión: (101)…(128), cada una corrige a las anteriores), en `clon_comparte.py`
   (los 21 punteros que J2 hereda de J) y en `censo_ab.py` (quién pregunta por «el jugador» por el global). La clase
   de defecto «lo de uno se ve en el otro» se descubrió **cinco veces por síntoma**. El doble búfer del arma no lo
   vio ningún censo porque **no pregunta por el jugador**: es un único recurso que el juego da por de uno. Falta el
   censo hecho de arriba hacia abajo.
3. **El estado dejó de ser estado.** `ESTADO_ACTUAL.md` mide 145 KB y `sesiones/HANDOFF.md` 270 KB: se volvieron
   historia apilada (la puerta lee el comienzo). La última foto de «qué anda y qué no» es `docs/18` §1, del 2026-10-02.
   La tabla del §0 de acá la reemplaza.
4. **Vocabulario propio sin glosario** (J, J2, molde, `pers`, sub, soporte, `V`, montón, búfer, ranura, envoltorio,
   reserva…). `docs/90` es sólo del EE.

## 2. ¿El reloj estaba puesto? Un archivo con todas las estructuras

**En BLACK, no** (medido hoy, con control positivo): el ELF tiene 105 secciones y ninguna de símbolos (`.symtab`,
`.mdebug`, `.stab`); `.debug_str` mide 1 byte; cero rutas de fuente. El control: `.text` en `0x00100000` y `.bss` en
`0x0040EC80`, como dice `docs/05`. Lo único con nombres ya se usó: el RTTI de Kynapse (biblioteca muerta) y la ValueDB
por CRC.

**En los parientes del motor, probablemente sí** (síntesis, m24: «entender sistemas heredados o análogos»). BLACK sale
del motor de Burnout: el mismo script de Noesis abre los dos (`fmt_Burnout3LRD.py`, `docs/09`). Y hay builds de
Burnout con símbolos:

- **Burnout Dominator (PS2), build de depuración «PRODUCTION 10 Preview», 31/01/2007**: el ejecutable «lleno de
  símbolos de depuración», 34 MiB (TCRF; *fuente externa*: la página no se pudo leer directo y traía texto dirigido a
  agentes, ignorado).
- **Burnout 3: Takedown, prototipo del 8/6/2004** (Hidden Palace, *leído*): «Has a map file for the used .elf», más
  restos de ELF de builds internos y de depuración.

**Por qué importa más de lo que parece:** Burnout trae **pantalla dividida de dos jugadores de fábrica**, y BLACK
conserva los restos (el HUD de dos jugadores ya armado, la función que pone la cuenta en 2, un modo vacío sin
entrada: medidos en (64), (71), (112)). Con los símbolos de Dominator, lo compartido del motor (montones, cargador,
recursos, menú/HUD, cuadro y DMA: justo donde se gastaron (126)–(128)) tendría **nombres y tipos**, y se vería cómo el
motor arma su modo de dos. Cómo: Ghidra (Function ID o BSim) entre el ELF con símbolos y el de BLACK; se importan
nombres y tipos de lo que coincide. *Hipótesis* de rendimiento: lo del motor coincide; lo propio de BLACK (armas,
IA, guion) no. Primer sondeo, que puede dar cero: cadenas de `.rodata` compartidas. Cuesta bajar la imagen (decisión
de Fran: es material no publicado que circula por grupos de preservación) y una sesión en frío.

Otras fuentes, de menor valor: el SDK de RenderWare 3.10 PS2 (archive.org, `docs/06`); la versión de Xbox (reversing
publicado del XBE; «formatos más simples» según ResHax); los builds de depuración de *Black 2* (Xbox 360, otra
plataforma).

## 3. Lo que otros ya resolvieron (descubrimiento)

| Proyecto | Qué resolvió | Cómo | Qué nos dice |
|---|---|---|---|
| **sm64coopdx** (Super Mario 64 en coop) | un juego de uno, jugado por hasta 16 | el estado del jugador pasó a ser un **arreglo por jugador** (`gMarioStates[]`) y la lógica corre una vez por jugador con su estado (*fuente externa*: su documentación de Lua) | el estado por jugador se convierte **de una vez, por censo**, no por síntoma |
| **Super Mario Sunshine / Galaxy Multiplayer** (Dolphin) | segundo jugador con pantalla dividida en juegos de uno, en emulador | sin documentación técnica pública | prueba de existencia: se hace, y en emulador |
| **Synergy / Lambda** (la campaña de Half-Life 2 en coop) | avanzar juntos por una campaña lineal | checkpoints dinámicos; Lambda rehízo escenas con checkpoints para no teletransportar a nadie a la fuerza | para la pieza 5 hay dos políticas conocidas: traer al rezagado (la nuestra) o puntos de reunión |
| **OpenCoop** (Doom 3) | la campaña de Doom 3 en coop | las cinemáticas esperan a que estén todos; los eventos con guion eran lo que más rompía | N21 (bombas del guion) es la clase de problema conocida: se ataca antes de jugar campañas largas |
| **Jak and Daxter en PCSX2 de 128 MB** | el modo desarrollador del juego | el juego lo prende si arranca con memoria extra (*fuente externa*: wikis de Jak) | código de un juego real usa memoria de más de 32 MB en PCSX2 |
| **PS2Recomp** | PS2 recompilado a PC nativo | traducción estática del R5900 a C++ | experimental, sin juegos jugables a 2026: alternativa de largo plazo, no hoy |
| **Nucleus Co-op** | pantalla dividida en PC | dos copias del juego unidas por su red | no aplica: BLACK no tiene red |

## 4. Las palancas, de la de más arriba a la de más abajo (Meadows)

**P1 · La meta: medir el avance por validación, no por piezas.** Hoy el proyecto mide verificación (predicción,
control, dos cargas) y produce verificación. Propuesta: una medida de efectividad nueva, **misiones terminadas en coop
por dos personas, arrancando desde el menú**. No reemplaza al método de las piezas: lo ordena.

**P2 · El flujo que falta: un trazador jugado ya.** Fran (con un amigo, o con dos mandos) juega **City Streets de
punta a punta desde el menú**, con el pnach por defecto y R4 prendida, grabando (`lanzadores/grabar-gameplay.ps1`).
Lo que lo frena es la lista de prioridades real (NASA y `docs/00`: validar temprano, con productos parciales). Cuesta
una sesión de Fran; reversible; contesta de una las filas 6–9 del §0.

**P3 · La regla: el orden de la C, de lo fundamental a lo específico.** (a) **estable**: R4 por defecto después de su
regresión (es la única caída medida del pnach por defecto); (b) **avanzar**: la pieza 5 (zonas y eventos de guion,
N21) y «continuar misión»; (c) **sostener**: la pieza 3 (munición y botiquín para J2); (d) **ver al otro**: la pieza
4 (cuerpos); (e) **fidelidad**: el arma de cada uno (2d + F7b), carteles, zoom. Es decisión de Fran: el orden viejo
lo aprobó él en (114).

**P4 · La estructura: memoria de sobra.** PCSX2 trae «Enable 128MB RAM (Dev Console)» (medido hoy: la opción está en
los dos `pcsx2-qt.exe` de la máquina). Si el mod puede usar `0x02000000`–`0x07FFFFFF`:

- se terminan los topes del stub (93 de 96 palabras, 111 de 112, las reservas corridas a mano);
- R4 deja de sacarle memoria al arena del juego (hoy `malloc` le da `0x01F29390`, contra la cima de los 32 MB);
- **vuelve la alternativa A de F7b** —darle a J2 su propio doble búfer—, descartada **«por memoria»** en (127). Es la
  más simple: cada jugador con sus recursos, sin reglas de dueño (D').

*Hipótesis*, con tres riesgos que se miden antes de diseñar nada encima: que BLACK mida la RAM al armar su arena (y
entonces **todas** las direcciones de heap del `kb` se corren), que el DMA desde más de 32 MB no ande, y que el mod
quede atado a esa opción (sólo emulador, no PS2 real). Sondeo: en frío, cómo calcula BLACK la cima de su arena; en
vivo, con la opción prendida: ¿las direcciones del `kb` son las mismas? ¿PINE escribe y lee `0x02000000`? ¿un bloque
del stub ahí corre? ¿un dibujo con datos ahí sale en pantalla?

**P5 · La estructura: el censo del jugador, de arriba hacia abajo.** Todos los globales y singletons que tocan los
caminos del jugador (actualizar, dibujar la primera persona, cargar y soltar recursos), clasificados en *del mundo*,
*del jugador* y *del jugador pero único* (como el doble búfer). Se arma con lo que ya existe (`censo_ab.py`,
`clon_comparte.py`, `perfil_singleton.py`, `censo_subsistemas.py`). Da la lista de lo que va a romper **antes** de que
rompa, y es el modelo vigente que reemplaza a las secciones por sesión de `docs/16`.

**P6 · La información: los nombres del motor** (§2). Pide el ok de Fran para bajar.

**P7 · La forma de J2: conmutar el contexto entero.** Con P4 y P5: J2 tiene su copia de cada recurso «del jugador» y
el mod conmuta los punteros globales alrededor de cada tramo de J2 (actualizarse, dibujar su mitad, cargar su arma).
Es lo que sm64coopdx hizo con arreglos. *Hipótesis de diseño*: se compara en frío contra D' cuando P4 y P5 tengan
resultado.

**P8 · Los parámetros (el escalón de abajo).** Seguir con R1–R3 como están, más sesiones. Es el camino por defecto, y
su techo ya está puesto: cada capa nueva del arma aparece por síntoma.

**Consideradas y descartadas** (NASA 6.8: se documenta lo considerado): una pantalla compartida (M1, no da vista a J2);
J2 como compañero de escuadra (M3; ya no hace falta, B1 pasó); cuadros alternados (30 Hz por jugador); dos instancias
del juego (BLACK no tiene red); recompilar (PS2Recomp, inmaduro); entregar por ELF o ISO en vez de pnach (cambia el CRC
y rompe savestates y parches: el pnach sigue siendo lo correcto).

## 5. Lo que se deja de hacer

- **Se pausa la línea del arma** (la 2d y R1–R3 de F7b) hasta que P4 y P5 contesten: con memoria, la alternativa A
  puede reemplazarla entera. Lo que se pierde por esperar: nada que impida jugar (la fila 11 es fidelidad).
- **No más secciones por sesión en `docs/16`**: el modelo se consolida con P5.
- **`ESTADO_ACTUAL` y `HANDOFF` vuelven a ser fotos**: la historia ya está en la bitácora. Propuesta para una sesión
  de método, no para hoy.

## 6. El orden que se propone

1. **La regresión de R4 y prenderla** (el (a) del retome): estabilidad, lo más fundamental. Una sesión, sin Fran.
2. **El trazador jugado (P2)**, con R4 prendida. Una sesión de Fran.
3. **En frío: P4 (memoria) y P5 (censo del jugador)**. Una o dos sesiones; P4 con un sondeo corto en vivo.
4. **KDP con Fran:** ¿A con memoria o D'? y el orden de las piezas según lo que frenó el trazador.
5. **P6 (símbolos)**, si Fran da el ok, en paralelo con el 3.

**Lo que NO va ahora:** el (b) del retome (R1–R3 en frío) espera al paso 4.

## 7. Las decisiones que son de Fran

1. **El orden de la C:** ¿primero que se pueda jugar la campaña (estable, avanzar, munición, continuar) y después que
   se vea perfecto (el arma de cada uno, carteles, zoom)?
2. **La memoria:** ¿el coop puede depender de una opción de PCSX2 (128 MB, sólo emulador; en una PS2 real no
   correría)?
3. **Los símbolos:** ¿se bajan el build de depuración de Burnout Dominator y el prototipo de Burnout 3 (material no
   publicado, de grupos de preservación) para sacar los nombres del motor?

**Las respuestas de Fran (2026-10-12, en el chat; KDP-C1 en el `PDP` §6):** «haz todo lo que apunte a conseguir el
coop de todo BLACK, sin perder jugabilidad, coop funcional bueno quiero. Bajá cualquier herramienta oficial o no,
para eso es la investigación también. Que corra en PCSX2 o en un osciloscopio si es necesario». **1 sí** (el orden
nuevo, con «sin perder jugabilidad» como condición de cada tramo: `PDP` §4, tramos 0–6), **2 sí** (puede depender de
PCSX2), **3 sí** (se baja lo que sirva). Y pidió seguir investigando herramientas: §8.

## 8. Herramientas para darle a BLACK en el blanco

| Herramienta | Para qué | Estado (2026-10-12) |
|---|---|---|
| PCSX2, «Enable 128MB RAM (Dev Console)» (`ExtraMemory`) | memoria de sobra para el mod (P4) | en los dos `pcsx2-qt.exe` (medido). El código de PCSX2 (`pcsx2/Memory.cpp`, master, *leído*): con la opción, la RAM expuesta pasa de 32 MB al total y se mapea desde `0x00000000`; los espejos `0x80000000` y `0xA0000000` cubren 512 MB del físico 0. Sin verificar: el acceso por `kuseg` (depende de la TLB del BIOS) y el DMA desde más de 32 MB |
| ghidra-emotionengine-reloaded, *STABS Analyzer* | recupera tipos, funciones y globales de un ELF con `.mdebug` (el de Dominator, si los trae así) | instalado (`ubicaciones.py`: `ghidra_ext_ee`) |
| Ghidra *Version Tracking* y *BSim* | portar nombres y tipos de un build con símbolos a BLACK por coincidencia de funciones (BSim tolera código que cambió entre juegos) | vienen con Ghidra 12.1.2 (instalado). Guía: el flujo de CHDK |
| Burnout 3, prototipo del 8/6/2004 (con el `.map` de su ELF) | nombres del motor | archive.org `Burnout3TakedownJun82004prototype`, 158 007 378 B, SHA-1 `13c8ca88be00cf810d5f4c9f28685a3049886f2f`; la primera bajada dio 500/502 (archive.org), reintento en `C:\Users\frans\herramientas\referencias-burnout\b3-jun8-2004\` |
| Burnout Dominator PS2, debug «PRODUCTION 10 Preview» (31/01/2007, ELF de 34 MiB con símbolos) | nombres **y tipos** del motor | sin fuente de descarga encontrada (TCRF lo documenta; Hidden Palace y archive.org, sin resultado por buscador) |
| SDK de RenderWare 3.10 PS2 (archive.org, `docs/06`) | los headers con las estructuras de RenderWare | por bajar: sólo headers, nada se instala ni se ejecuta |
| GhydraMCP | manejar Ghidra desde la sesión (decompilar, renombrar, referencias) | opcional: hoy `decompilar.py` (pyghidra) alcanza |
| mcp-pine | PINE por MCP | no hace falta: `pine.py` |
| Sunshine + Moonlight | alternativa abierta a Parsec para jugar a distancia | para la D |

## Fuentes

- TCRF, Burnout Dominator (PS2) prototipo: https://tcrf.net/Proto:Burnout_Dominator_(PlayStation_2)
- Hidden Palace, Burnout 3: Takedown (Jun 8, 2004 prototype): https://hiddenpalace.org/Burnout_3:_Takedown_(Jun_8,_2004_prototype)
- sm64coopdx: https://en.wikipedia.org/wiki/Super_Mario_64_Coop_Deluxe
- Super Mario Sunshine Multiplayer: https://allreds.itch.io/super-mario-sunshine-multiplayer
- Synergy: https://developer.valvesoftware.com/wiki/Synergy · Lambda: https://github.com/ZehMatt/Lambda
- OpenCoop (Doom 3): https://www.fileplanet.com/archive/p-45635/DOOM-3-OpenCoop-v1-1
- Jak, modo desarrollador con 128 MB: https://wiki.jakspeedruns.com/Developer_Mode
- PCSX2, pedido de 64/128 MB: https://github.com/PCSX2/pcsx2/issues/9909
- PS2Recomp: https://www.timeextension.com/news/2026/01/native-pc-ports-of-ps2-games-could-be-on-the-way-thanks-to-new-recompilation-experiment
- Nucleus Co-op: https://github.com/nucleuscoop/nucleuscoop/blob/master/README.md
- ps2tek (mapa de memoria del EE): https://psi-rockin.github.io/ps2tek/
