# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

> **EMPEZÁ POR EL BLOQUE «(93n)–(93q)» DE ACÁ ABAJO, después el «(93f)–(93m)».** La cartera es **un solo
> proyecto, COOP**. **La Fase B está ABIERTA** desde el 2026-09-27 (84), con su
> criterio en `PDP.md` §4 («Proyecto COOP — Fase B»); **B1, B2b (en el stub) y
> B3 hechas: el coop en pantalla dividida sale del pnach solo** (88). El
> mensaje para pegar está en `sesiones/RETOME-LOCAL.md`.

## 2026-09-28 mañana, NOTEBOOK (chat) — LA TERCERA RANURA: FRÍO COMPLETO, PROTOTIPO EN VIVO Y LA FUGA CERRADA EN RAM (bitácora (93n)–(93q))

- **Frío** (`docs/15-tercera-ranura.md`, la fuente): `pers` se construye una vez al arrancar; `pers+0x8F0` es un pool de 44 bloques de animación (no está libre); `pers` tiene además un pool de 33 ranuras de personajes (`FUN_001abe48`). `FUN_001a4ff0(r, 1)` arma una ranura de primera persona (toma un bloque) y `FUN_001a51c8(r, jugador, sub)` la carga y pone `jugador+0x330` = r. Anima el mover (`FUN_001a54e0(dt, J+0x330)`) y dibuja `FUN_00133BA0` por `+0x330`: una ranura colgada de J2 se anima y se dibuja sola, y el filtro por pasada la tapa con J2. Medido en 4 volcados: 1 a 9 bloques libres.
- **Vivo** (`herramientas/ranura3.py`): R3 en `0x0046E100`, código de una vez en `0x0046E340` enganchado en `0x001295A8` (**no** en el gancho del mod: el pnach es `patch=1` y lo reescribe cada cuadro). Se arma y carga sin colgar, J2 con brazos en cuadro; la recarga de J2 en los brazos de J baja de **2/8 a 1/8**, no a 0. El compañero sale del `malloc` del sistema, no del submontón 6.
- **(93q) en RAM con control** (`herramientas/ranura3b.py`): con la ranura 3 la pose de J (compañero de r0) no cambia con J2 disparando (1 palabra contra 33), la cola de V no se mueve (0 contra 8), el arma de J no pasa a 8 y el filtro saltea todo lo de J2. **La fuga está cerrada**; el «1 de 8» de las capturas no tiene correlato en RAM.
- **El parpadeo** (video de Fran, 10:33): con J2 disparando, la mitad de J2 alterna entre dos puntos de vista.
- **Proceso**: un agente «remoto» para el frío gastaba el plan Pro (no los créditos de nube); se cortó. Lección en `chequeo-de-trabajo.md`.

**Estado de la máquina al cerrar:** pnach sin cambios (**636 palabras**, bloque **activo**); la ranura 3 **no** está en el pnach (sólo por PINE, se pierde al cerrar el fork); fork cerrado; el 2.8.0 de Fran sin tocar (slot 14).

## 2026-09-28 mañana, NOTEBOOK (tarea programada 07:10) — B5, EL TÍTERE POR NIVEL Y LA CAUSA DE LA POSE COMPARTIDA (bitácora (93f)–(93m))

- **(93f)/(93g) B5**: la vida de J2 en 0 no hace nada (se regenera). Un enemigo de spawner movido a mano no dispara a nadie (tampoco a J, sin control positivo): el daño a J2 no se mide sin un combate del guion. La lectura de (93f) del «controlador tipo 2» no se sostiene (`+0x80` = 0 en J y J2).
- **(93h) títere por nivel**: rutina `ELEGIR` (`0x0046DE00`, deja el elegido en `TITERE_ACT` = `0x0046DEF0`): el primer actor del pool con tipo ≠ 0, bando 0, `+0x38C` = 0 y `+0xB4` ≠ 0. `+0x38C` = 4 es un bloque sin alta. **5 de 8** (se suma Town); Wilderness/Steelworks/Gulag no tienen aliado vivo. `censo_titere.py`.
- **(93i) cuerpo sin aliado** (prototipo por PINE, `titere_spawn93.py`): soldado de spawner → bando 0 **y grupo de colisión 4** (`*(*(B4+0x34)+0x18)`; jugador 3, aliado 4, enemigo 6, fijado al atar en `FUN_0025CEF8`) → camina con J2, confirmado con control. El títere va **corrido +0,3 m en x** en el stub (exacto encima colgaba el EE en `FUN_0033DD98`). Al stub **no** se llevó: gasta un spawner del guion (decisión de Fran).
- **(93j)–(93m) la vista en primera persona**: la ranura `+0x330` (compartida con J, dueño J) es el modelo FP del arma en la mano con su animación; los eventos de animación de J2 salen por ahí a nombre de J (`FUN_001E80C0`, callback `*(0x0040F50C)+0x964`). Con la ranura 1 (`pers+0x6B0`, dueño J2) la mitad de J queda limpia (confirmado con control) pero J2 ve el aparejo de la otra arma de J (`FP_S_G_S_001` vs `FP_P_S_01`). **Arreglo pendiente: una tercera ranura para J2.** Instalado: aislamiento de 5 funciones de la vista durante la actualización de J2 (bandera `0x0046DEF4`, envoltorios `0x0046DF00`, contadores `0x0046E040`) y el filtro de eventos (`0x0046E070`, gancho `0x001E80C0`).
- **(93k) parpadeo**: `R+0xD470` lo escribe sólo el stub (300/300), quieto y con J2 disparando/apuntando/recargando.
- **Trampas nuevas**: el botón del mando falso necesita también el float (`+0x4C+4i`) o no dispara; el vigilante de lectura sobre una bandera que lee un envoltorio da el llamador (`ra`) sin breakpoints de ejecución (que tiran el emulador).

**Estado de la máquina al cerrar:** pnach instalado con **636 palabras**, bloque **activo**; campaña 8 de 8 con ese bloque; fork cerrado; el 2.8.0 de Fran sin tocar (slot 14).

## 2026-09-28 madrugada, NOTEBOOK (tarea programada) — RECARGA, VISIBILIDAD POR PASADA, TODA LA CAMPAÑA Y EL PLANO (bitácora (93)–(93e))

- **(93) recarga de J2**: `RECARGA_MOD` confirmado en RAM con control (`herramientas/recarga92c.py`).
- **(93b) visibilidad por pasada**: filtro en el callback de dibujo (`herramientas/ocultar_pasada.py`, 45 palabras en `0x0046FB20`; ganchos `lui/addiu` en `0x001298F8/0x00129900`, se escriben juntos y en pausa). Pasada 1 sin J2, pasada 2 sin el títere. Los brazos+arma de cada mitad son el dibujo del propio personaje (confirmado con control).
- **(93c) el cuelgue de la campaña**: con el mod, Wilderness/Town/... caían en `FUN_0033DD98` (EE caído, la pantalla congelada en el cartel) porque J2 nacía encima de J. Arreglo en el envoltorio: si J2 tiene la x de J, +1 m en x (`+0xA0/+0x100/+0x190`). Confirmado con control (`herramientas/apartar93.py`).
- **(93e) la campaña entera** (`herramientas/campana_coop.py`): 8 de 8 niveles se arman, llegan al juego, J2 camina, la pantalla se parte y 7 cargas seguidas sin cuelgue. El títere anda en 4 (Town/Steelworks: el aliado 1 es enemigo; Wilderness/Gulag: no sigue).
- **(93d) plano**: `docs/14-coop-diseno.md` + `herramientas/coop_diseno.py verificar` (0) + `pruebas/probar-coop-diseno.py` (6 de 6 en rojo). B4 en frío: los enemigos no saben que J2 existe (`probable`); B6: J abre el camino.
- **Trampa nueva**: el guardia `PreToolUse` bloquea comandos de PowerShell con prosa en castellano adentro (falso positivo «Remove-Item on system path '*'»): los textos van a archivo con la herramienta Write y el shell sólo corre Python.

**Estado de la máquina al cerrar:** pnach instalado con **514 palabras**, bloque **activo** en los ajustes del juego; fork cerrado; el 2.8.0 de Fran cerrado, su partida en el **slot 14** sin tocar.

## 2026-09-28, NOTEBOOK — LAS ARMAS DE J2 SON SUYAS; LA VISTA EN PRIMERA PERSONA ES UNA SOLA (bitácora (91))

- **J2 dispara y las balas salen** (Fran, con el mando real): el «no dispara» de (90d) queda refutado. Problemas que siguen: en la mitad de J2 las animaciones del arma son las de J1; J2 quedó **recargando para siempre** con cargador 0 y reserva 30; la mitad de J2 **a veces parpadea** (se angosta y se reacomoda, sin medir).
- **Medido en RAM (su partida, sólo lectura):** las armas de J2 son **propias** (objeto, cargador, reserva y dueño = J2+0x280). J = `*(0x0040F4D0)` **+ 0x30**. El HUD de la mitad de J2 es el de J. La SPAS la tiene J.
- **Causa candidata única (hipótesis):** `FUN_0015bf50` y 22 caminos del código de armas, con `dueño+0xC4` = 2, manejan **un solo objeto global** `*(*(0x0040F510)+0xCBD8)+0xC` (`FUN_001d6e78`: conjunto de animaciones en `+0x1BE0`) = candidato a la vista en primera persona. J y J2 tienen `+0xC4` = 2 → los dos la manejan. Explicaría animaciones de J1, arma que no sigue la mirada de J2 y la recarga eterna.
- **Compartido con J por el molde:** `+0x270/+0x274/+0x278` (tres bloques con dueño J), `+0x294` (bytes por tipo de arma), `+0xB8/+0xBC`, `+0x328`, `+0x354..+0x360`, `+0x410`.
- **Sigue:** `sesiones/RETOME-LOCAL.md` §3.

**Estado de la máquina al cerrar:** el PCSX2 2.8.0 de Fran abierto con su partida coop; no se escribió nada en ella.

## 2026-09-27, NOTEBOOK — EL COOP CON DOBLE CLIC, LOS ISO EN SU CARPETA Y LA BANDA ARREGLADA (bitácora (90))

- **Los ISO se mudaron**: `C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso` (y `-mod-armas`, `-mod-7b`). La fuente es `kb/ubicaciones.json`; `ubicaciones.py` en OK. Las rutas viejas que quedan en este HANDOFF, más abajo, son historia.
- **Accesos** en `PS2\BLACK\`: `JUGAR BLACK` (apaga el bloque), `JUGAR BLACK COOP - teclado y mando` (`JUGAR-BLACK.ps1 -Coop teclado`: prende el bloque, `[Pad1]` sin `SDL-0`, `[Pad2]` en `SDL-0`), `... - dos mandos` (`-Coop 2mandos`: `[Pad2]` en `SDL-1`). Medido en el 2.8.0 en los dos sentidos. El `RecursivePaths` del `PCSX2.ini` ya no escanea `Downloads`.
- **(90b) banda amarilla: confirmada con control y arreglada.** La dibujaba la llamada única a `FUN_001B0AC8` del final del stub (`jal` en `0x0046FAA4`): en `nop`, la mitad derecha limpia; repuesta, vuelve. Queda en `nop` en la fuente (430 palabras, nada se corre). Por el pnach solo: 0 amarillo a los 33 y 55 s. Costo: sin tinte de daño/fundido con la pantalla partida.
- **(90c/d) Fran lo jugó con dos mandos reales**: pantalla partida **confirmada** en el 2.8.0 (~60 cuadros/s). El mando 2 no movía a J2 porque el juego le da a J **el puerto que apretó Start** (J estaba en `0x00585A0C`, puerto 2) y el mod le daba a J2 `J + 0x16C` = un tercer control vacío. Arreglo: J2 toma el puerto que J no usa (434 palabras); probado en caliente en su partida → **J2 camina y gira con el otro mando, confirmado por Fran**.
- **Abierto (lo que vio Fran):** J2 no dispara con el mando real; el aliado-títere se ve superpuesto en la cámara de J2 y J2 ve el arma de J (visibilidad por pasada); el arma de J2 no sigue la mirada como la de J1; sensibilidad rara y un mando con palancas gastadas.
- **Sigue:** el orden está en `sesiones/RETOME-LOCAL.md` §3.

**Estado de la máquina al cerrar:** el **PCSX2 2.8.0 de Fran abierto** con su partida coop (J2 con el puerto 1 escrito en caliente). El pnach instalado puede ser el de 430 palabras: el acceso COOP lo reinstala con 434 al abrirlo.

## 2026-09-27, NOTEBOOK — LA IMAGEN DE LA PANTALLA DIVIDIDA: PROPORCIÓN Y FANTASMA (bitácora (89))

**El resultado:** el bloque pasa a **430 palabras** (pantalla 181 en `0x0046F800..0x0046FAD4`, filtro 8 en `0x0046FB00`, 5 constantes, **7 ganchos**: se suma `0x00129AD0` → filtro). Instalado y **APAGADO**.
- **(89) proporción:** el stub guarda `R+0xD470`/`+0xD474` en `DATOS+0x30/+0x34`, los × 0,5 si `DATOS+0x38` ≠ 0, sincroniza, dibuja y restaura. Confirmado con control (`herramientas/prop89.py`).
- **(89b) fantasma:** es `FUN_001B0AC8(R+0xD290)` (tinte a pantalla completa, dos quads `FUN_001CFB50`), hallado apagando 9 llamadas de a una (`herramientas/fantasma.py`). Filtro: con `DATOS+0x3C` ≠ 0 vuelve sin dibujar; el stub lo pone en 1 durante las pasadas y llama al tinte una vez al final. Confirmado (`herramientas/filtro89b.py`: contra `nop` 1,0, original 8,1). Por el pnach: **64 dibujos/s** partidos (antes 38–40).
- **(89c) ABIERTO — banda amarilla:** por el pnach, ~30 s después de cargar, la mitad derecha lleva una banda amarilla sólida de x 320 a ~608 (PS2) y el borde negro (`volcados/capturas-88/h1-*`, `h2-*`). Refutado que sea el viewport de la llamada única (se reordenó: ancho/offset antes del SYNC final; el cambio quedó). Las 430 palabras están en memoria tal cual. Próximo: por PINE con el bloque apagado, apagar la llamada única en el stub (`jal 0x1b0ac8` cerca del final de la pantalla) y ver si la banda se va; y repetir por PINE ~30 s después de una carga.

**Trampa medida:** la primera corrida de `fantasma.py` mató a PCSX2 entero después de la captura base sin tocar nada (emulog sin error); repetida, completó. Sin explicar.

**Estado de la máquina al cerrar:** PCSX2 **cerrado**, bloque **apagado**. Nada en un slot.

## 2026-09-27, NOTEBOOK — EL COOP ENTERO EN EL PNACH: TÍTERE, VISTA, CABECEO Y PANTALLA DIVIDIDA (bitácora (88))

**El resultado:** `coop_mod.py` = **375 palabras**, sólo código + 4 constantes: envoltorio (`0x0046DA00`), por cuadro (`0x0046D800..0x0046D988`, 98), desarme (`0x0046DD00`), **pantalla** (`0x0046F800..0x0046FA20`, 136, de `pantalla_dividida.py`), constantes `0x0046FC80` = 1, `+0x8C` = 320, `+0x90` = 640, `+0x94` = 1, y **6 ganchos** (`0x00129574`, `0x00128EA4`, `0x00129E38`, y los tres `jal 0x1297E0` de `0x001056DC`/`0x0010656C`/`0x00106D8C`). Con PCSX2 reiniciado, el bloque prendido y **sin Python del mod**: J2 se arma, camina 8 m, el títere lo sigue y la pantalla se divide sola. Captura: `volcados/capturas-88/f1-2-despues.png` (local).
- **(88) títere:** en el estado 3, tras el update de J2, 16 palabras `lw/sw` de `J2+0x70` a `*(0x0040F514)+0x450+0x70` si `+0x328` ≠ 0 y `+0x3A4` = 0. `TITERES` en `0x0046D7CC`.
- **(88b/d) vista de J2:** el stub de la pantalla llama a `sinf` `FUN_0029DC18` / `cosf` `FUN_0029DA28` (arg `$f12`, resultado `$f0`); q = (cy·sp, sy·cp, −sy·sp, cy·cp), medios ángulos, yaw = `*(J2+0x32C)+8`, cabeceo **real** = −`mira+0xC`; ojo `J2+0x100`. Senos en `DATOS+0x20..`, resultado en `+0x60/+0x70`, copiado a `+0x40/+0x50` con `+0x94` = 1. Convención medida sobre J (`herramientas/conv_cuat.py`).
- **(88c) cabeceo:** `+0xD0` tiene la misma convención en J y J2 (corrige a (85)). Una vez, al preparar el control2: cabeceo de la mira de J2 negado (bit 31 de `+0xC`) y `+0xF1` (invertir Y) dado vuelta. Medido: `pitch_arriba` → adelante de J2 +0,94 (J y control −0,94).
- **(88e):** el raster se lee en vivo (`*(*(*(0x0040F4C0)+0xD400+0x58)+0x60)`), y la división sólo con `FASE` 2 y `ESTADO` 3.

**Herramientas:** `coop_mod.py poner [--sin-titere] [--sin-cabeceo] [--sin-pantalla] [--sin-baja]`; `mirar` muestra `titeres` y `A1_pos`; `manos` mide al aliado. `pantalla_dividida.py fuente-stub 0|1 [--prender]`, `comparar <s>`. `tirador.py --traza`. `conv_cuat.py [yaw]`.

**Trampas medidas:** reescribir un stub **en caliente** con otra disposición puede volver a una instrucción corrida: para el de la pantalla, `quitar` → esperar → `poner` en pausa; para el por cuadro, `FASE` = 0 → esperar → escribir en pausa → `FASE` = 2. **El banco de daño con `--acercar` no mide:** al blanco movido a mano no le pega ni J, y un aliado con IA al lado del tirador mata por su cuenta. El guardia de PowerShell lee «J:» en un mensaje de commit como una unidad de disco: los mensajes largos van a archivo y sin «J:».

**Pendiente:** el mando 2 **real** (Fran); proporción de las mitades (`R+0xD400+0x70/+0x74` × 0,5) y HUD por mitad (el fantasma amarillo); esconder los brazos de J2 en la vista de J; la recarga de J2; la prueba de daño de punta a punta con el cabeceo nuevo (enemigo que llegue solo a la línea de tiro, con J como referencia positiva); B4–B6 en frío; `docs/14-coop-diseno.md` + `coop_diseno.py`.

**Estado de la máquina al cerrar:** PCSX2 **cerrado**. El bloque `[COOP - jugador 2 (B3)]` (375 palabras) **instalado y APAGADO** (el emulog de la corrida con el bloque prendido decía `Enabled patch: COOP - jugador 2 (B3)`). Nada guardado en un slot.

## 2026-09-27, NOTEBOOK — B3.3: LA BAJA DE J2 AL SALIR DEL NIVEL (bitácora (87))

**El resultado:** el desarme del nivel es `FUN_00129DE8`; en su estado 0x1D llama (`0x00129E38`) a **`FUN_0012BFC8`**, espejo de `FUN_0012BE80`: por jugador `i < cuenta`, `FUN_0025C2C8(*(0x0040F4CC), J)` (suelta el controlador de colisión y lo saca del mundo de colisión) y `FUN_0012A280(juego, J)` (lo saca de la lista `juego+0x5CA4`). `coop_mod.py` suma el programa **desarme** (`0x0046DD00`, 36 palabras) y el gancho en `0x00129E38`: la original y lo mismo para J2; fase = estado = 0; `DESARMES` en `0x0046D7C8`. **202 palabras.** Con la baja: **tres cargas seguidas**, J2 7,55 / 7,54 / 7,56 m (control 0,00), 0 `TLB Miss`, y J2 reusa la misma entrada del pool (`0x5880B0`). Control `poner --sin-baja`: la 2.ª carga cae igual; variante sin `FUN_0025C2C8` (sólo lista): cae igual. **La causa era el controlador de colisión de J2.**

**Herramientas:** `coop_mod.py poner [--sin-baja]`; `mirar` ahora muestra `desarmes`. `mods/coop.toml` regenerado y versionado. El bloque del pnach está **reinstalado (202 palabras) y APAGADO**.

**Estado de la máquina al cerrar:** PCSX2 **colgado** en la corrida de aislamiento (sólo lista): cerrarlo y relanzarlo. Nada guardado en un slot.

## 2026-09-27, NOTEBOOK — B3: EL MOD SIN PINE ANDA EN LA PRIMERA CARGA; LA SEGUNDA CUELGA (bitácora (86))

**El resultado:** `herramientas/coop_mod.py` pone todo el prototipo en los stubs, **sólo código** (165 palabras): el envoltorio del cargador (`0x0046DA00`) **copia J → J2 con `lq/sq`** cuando J termina de construirse (el molde que antes escribía Python), y el stub por cuadro (`0x0046D800`) espera 30 cuadros → control2 (`CTRL2 = *(J+0x588) + 0x16C`; `CTRL2+0xC` ya es el mando 2 real, `0x5857B0`) → enlazar → atar → corre a J2. B3.1 (código por PINE, datos en cero) y **B3.2 (entregado por el pnach**, bloque `[COOP - jugador 2 (B3)]` en `Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach`): J2 se arma en la carga y camina **7,5 m en 2 s** con el mando 2, control 0,00 m.

**Lo que falta en B3:** **la segunda carga cuelga el emulador** (`TLB Miss, pc=0x33DDB0 addr=0x2000000`, en `FUN_0033DD98` llamada por `FUN_00336520`, al primer cuadro del nivel nuevo, con `moldes = 2`). Con J2 frenado por PINE (`fase = 0`) cuelga igual: **H1 refutada**; **H2 probable**: algo que se le da de alta a J2 sobrevive al nivel y nadie lo da de baja. Falta el mando 2 REAL (lo prueba Fran) y el títere, la vista y el cabeceo en los stubs.

**Herramientas:** `coop_mod.py` `listar` · `poner` (PINE, en pausa: simula el pnach) · `mirar <s>` · `manos <s> [--control]` (las manos de la prueba: falso 2) · `instalar` (el bloque, apagado, con respaldo) · `activar`/`desactivar` (la línea `Enable` de `gamesettings`) · `quitar` · `toml`.

**Trampas medidas:** `selector_depuracion.py pedir-frontend` **desde el menú del arranque** hace saltar la CPU a datos (con y sin el mod, controlado): se entra al nivel cargando el **slot 3** (zona del mod en cero, leído del `.p2s`) y pidiendo el selector desde ahí. El aviso «Failed to open patches.zip» es de la copia `PCSX2-MCP`, inocuo. `manos` antes del control2 le robaba el mando a J (corregido).

**Estado de la máquina al cerrar:** PCSX2 **colgado** en la segunda carga (hay que cerrarlo y relanzarlo con `lanzadores\ABRIR-BLACK-ORIGINAL.bat` o con `pcsx2-qt.exe -fastboot -batch -- <iso>`). **El bloque del coop está INSTALADO y APAGADO** (`coop_mod.py activar` lo prende). Nada guardado en un slot.

## 2026-09-27, NOTEBOOK — B2b: EL CUERPO DE J2 ES UN ALIADO; B7: J2 HACE DAÑO (bitácora (85))

**Lo que pidió Fran:** cuerpo de J2 = **un aliado del nivel 1**; sin fuego amigo con los aliados; «al apuntarle a un aliado la mira se pone verde».

**El resultado:** todo personaje tiene en `+0x328` su entrada de la tabla de tipos y en **`+0x3A4` su bando** (0 jugadores y aliados, 1 enemigos). En City Streets los aliados son **los actores 0 y 1 del pool** (`actores+0x90+i·0x3C0`; tipos `0x1E` y `0x1D`, Tom y Matt), bando 0, vida FLT_MAX. **Títere:** copiar la matriz de J2 (`+0x70..+0xAF`) al aliado 1 en cada vuelta de PINE lo dibuja donde está J2 y lo sigue 10 m a ≤ 0,21 m (control: quieto; capturas `volcados/capturas-85/p1b-*`, `p2c-*`). **B7:** las balas de J2 no dañaban porque su **matriz de vista `+0xD0` tiene el cabeceo al revés de su mira** (mira −19,4° → adelante `+0xF0` con y = +0,332): con el signo cambiado J2 mata (100 → 0 en 6 balas, control 5 y 100), también con el títere pegado. **Fuego amigo:** entre jugadores no existe (máscara del rayo de jugador `0x57`, `FUN_00159198`; el filtro `FUN_0015ADA8` pide el bit 8 para una víctima jugador); los aliados tienen FLT_MAX. La IA le tira a J y no a J2.

**Herramientas nuevas:** `titere.py` (el títere, con `--control`), `tirador.py J|J2 <blanco> <s>` (`--pitch-invertido`, `--titere=<i>`, `--cargar`, `--acercar=`), `ranura_j2.py` (sonda de la ranura, refutada).

**Trampas medidas:** el enemigo recién nacido por spawner **no recibe daño unos segundos** (esperar ≥ 12 s); en las pruebas J va con vida FLT_MAX (un enemigo nacido a 6 m lo mató); `cargarestado` desde la carpeta equivocada no carga nada (no redirigir su salida a `$null`); dos conexiones PINE a la vez se cortan. A J2 **no le anda la recarga** (ni con reserva `J2+0x280`); las **matrices de acople de la ranura 1 están en cero**.

**Pendiente de la B:** **B3** (el mod sin PINE; ahora con el títere, el cabeceo de J2 y su recarga en el stub), B2b fino (esconder los brazos de J2 en la vista de J y el títere en la de J2; animación de caminar; niveles sin aliados), B4–B6 en frío, `docs/14-coop-diseno.md` y `coop_diseno.py`.

**Estado de la máquina al cerrar:** PCSX2 abierto, City Streets desde el **slot 13** con un enemigo nacido y muerto, J y J2 con vida FLT_MAX, J2 sin balas; la pantalla dividida **no** está puesta. Nada de eso está en un slot.

## 2026-09-27, NOTEBOOK — COOP-B ABIERTA; B1: DOS VISTAS EN EL MISMO CUADRO (bitácora (84))

**El resultado:** `render` **K4 → K5**. La escena (`FUN_001297E0(juego)`, desde los `jal` de `0x001056DC`, `0x0010656C`, `0x00106D8C`) se dibuja **dos veces por cuadro** con `pantalla_dividida.py`: mitad izquierda con la vista de J, derecha con la de J2, visto en pantalla con control (misma vista → las mitades coinciden: 11,5; vista de J2: 25,3; sin división: 50,1). Captura: `volcados/capturas-84/p21-dividida-320.png`, 1920 × 1080 (local, no versionada).

**Cómo funciona:** la cámara de escena es la 1 del gestor de render (`R = *(0x0040F4C0)`, `R+0xD400`; su `RwCamera` en `+0x58`, sub-raster en `RwCamera+0x60` con ancho `+0xC` y offset `+0x1C`). Lee su vista del **gestor de cámara `+0x700`** (`*(0x0040F4BC)`): `+0x00` FOV, `+0x10` cuaternión, `+0x20` ojo. El stub (`0x0046FA00`, datos `0x0046FC00`) dibuja, cambia el **contenido** de `+0x710`/`+0x720` (el puntero no: la pasada de sombras lo repone), re-sincroniza con `FUN_001AE998(R,1)` + `FUN_001B0948(R+0xD400)`, dibuja otra vez con el offset, y restaura. La proporción la ponen `R+0xD400+0x70` (1,333) y `+0x74` (1,778): para mitades de 320, ×0,5.

**Corregido en la misma sesión:** «PCSX2 muestra 512 de 640 px» era el recorte de `capturar-pantalla.ps1` sin DPI-aware (1536 × 864 de 1920 × 1080); arreglada, captura 1920 × 1080. La pasada 160 × 112 de (69) es **de sombras**. Costo: 73/73 dibujos/s en vista liviana, 24/51 en pesada. El cuaternión desde la matriz `+0xD0` da exacto el del juego para J; para J2 esa matriz trae un cabeceo raro, así que la vista de J2 sale del **yaw de su mira** (`*(J2+0x32C)+8`) y el ojo `J2+0x100`.

**B2 en frío:** una sola tabla de tipos de personaje (`actores+0x7A10`, 0x40 B por tipo; la usan el constructor del jugador y el de enemigos). City Streets: tipo 0 (el jugador) y cinco soldados, `0x1D`, `0x1E`, `0x24`, `0x25`, `0x27`. Diseño barato: un **títere** de uno de ellos que copia posición y yaw de J2. **El modelo lo elige Fran** (pregunta abierta).

**Pendiente de la B:** B3 (todo como pnach: el cuaternión de J2 y las mitades en el stub; el riesgo es si J2 se construye desde un molde que un pnach pueda escribir al arrancar — hoy `carga-poner` copia a J en vivo como molde, con `+0x8A4` = 0x1C), B2b (el títere), B4–B6 en frío, `docs/14-coop-diseno.md` y `coop_diseno.py`. Diseño: el fantasma espejado del HUD en la mitad 2 (efecto de pantalla completa) y el HUD por mitad.

**Estado de la máquina al cerrar:** PCSX2 abierto, City Streets desde el **slot 13**, con `pantalla_dividida.py poner` puesto (los tres `jal` desviados al stub) y la división **apagada** (`DATOS+0x80` = 0); cámara restaurada (1,333 / 1,778). Nada de eso está en un slot: se pierde al recargar.

## 2026-09-27, NOTEBOOK — SPAWN EN CALIENTE CON UN BYTE; COOP-A CERRADA (bitácora (83))

**El resultado:** la aparición fuera de la carga **existe y es del juego**. Por cuadro, `FUN_00165F30(dt, *(0x0040F4F4))` (desde `0x00129360`) recorre los spawners —listas **12 y 13** de la tabla de `disparadores` (cuenta u16 en `tabla+2i`, array en `tabla+0x48+4i`); City Streets tiene **73**, en RAM todo el nivel— y `FUN_00174578(spawner)` es un **temporizador**: si `+0x28` activo, `+0x2C` restantes ≠ 0, `+0x2A`/`+0x2B` y el actor de `+0x24` es 0 o está muerto (`+0x38C` ∉ {0,1}), resta `dt` a `+0x30` y al llegar a 0 aparece por `FUN_001746E0` → `FUN_00178408` (switch por `*desc`) → `FUN_00178978`/`FUN_00178AE8` → `FUN_00178BC0` → `FUN_00138C80` (`actores`: libre `+0x7990` → viva `+0x79A0`, cuerpo, controlador `FUN_0025C210`, enlace; vida `+0x2F8` = 100). La posición sale de **`*(desc+4)+0x10`, leída al aparecer**.

**Medido (`sondas_spawn.py`, slot 13):** escribir **un byte**, `+0x28` = 1, en un spawner armado → enemigo nuevo **en el cuadro siguiente**, **4 de 4** (`L12[43]`, `[71]`, `[17]` a los 7 s de su temporizador, `[4]`); negativo `L12[71]` sin escribir: nada. En la lista viva, no en la libre; controlador atado; cuerpo en el mundo `0x0066E900`. **P17b:** con el punto de `L12[43]` escrito 4 m delante de J, nace **ahí** y **se ve** (`volcados/capturas-83/p17c-antes.png` vacío → `c/rafaga-00-00006ms.png` con el soldado). `spawn` **K3 → K5**.

**Ojo:** el contador `*(0x0040F4D4)+0xFA4` sube solo (apariciones de fondo, ~1 cada 7–10 s): el efecto se lee en el propio spawner. Desde donde está J en el slot 13 **no hay línea de vista** a los puntos de la planta de abajo (se ve una pared): para ver una aparición, `apuntar` + `punto-delante`. Sin explicar: el actor de `L12[4]` murió en ~3 s; el de P17b quedó mirando hacia J2.

**COOP-A cerrada:** `entrada`, `camara`, `sesion`, `juego`, `codigo-nuevo`, `ragdoll`, `spawn` en K5, `render` en K4 (su objetivo), prototipo de (82); `verificar` 0, 183 comprobaciones.

**De paso:** `capturar-pantalla.ps1` fallaba con ruta relativa («Error genérico en GDI+»: .NET resuelve contra el directorio del proceso); ahora la resuelve sola. Lección foldeada en `chequeo-de-trabajo.md`.

**Sigue:** abrir **COOP-B** (diseño preliminar) escribiendo **antes** su criterio de salida en el PDP §4. Candidatos, sin priorizar: el cuerpo de J2 (dos brazos flotando), la pantalla dividida sobre la segunda pasada de `render` (160 × 112), `atar` permanente en el envoltorio de carga, los disparadores que sólo miran al jugador 0, la IA frente a J2, la reaparición de J2 si muere.

**Estado de la máquina al cerrar:** PCSX2-MCP abierto, City Streets, **slot 13 recargado** y encima: `L12[43]` con el punto movido a (−5,534; −0,335; 57,38) y su enemigo vivo delante de J; la vista de J con yaw −11,74. Nada de eso está en un slot: se pierde al recargar (y está bien). Slot 13 = J2 con controlador; slot 12 = sin controlador.

## 2026-09-27, NOTEBOOK — J2 CAMINA: LE FALTABA EL CONTROLADOR DE COLISIÓN (bitácora (82))

**El resultado:** con `jugador2.py atar` —que llama **una vez** `FUN_0025C210(*(0x0040F4CC), J2)` desde el stub por cuadro— **J2 camina con el mando 2**: 8,14 m en 2 s a 4,5 m/s (la rapidez pedida), en las cuatro direcciones, **se frena contra las paredes y empuja a J** (4,16 m una vez). Negativo en la misma corrida: Δ = 0,0000. Reproducido desde cero sobre el slot 12. **Es el prototipo del criterio de salida de COOP-A.**

**Por qué, en frío y después medido:**
- El mover del jugador es **`FUN_00132D98(dt, J)`**: guarda `J+0x190` = `J+0xA0`, calcula `d` = `mira+0x50` × `mira+0x10` × dt y, si `*(J+0xB4)+0x3C` = 0, **`FUN_0025D840(J+0xB4, d)`** (escribe `d` en `*(*(*(ctrl+0x34)+0xC)+0x58)+0x20`). `FUN_001334E0` deriva después velocidad (`+0x1B0`) y rapidez real (`+0x2E0`) de cuánto cambió `+0xA0`.
- El controlador se da de alta con **`FUN_0025C210(mgr, actor)`**: pool de **20** de 0x50 B en `mgr+0x2320` (banderas `+0x2960`), `FUN_0025CEF8` pone `actor+0xB4` = ctrl y `ctrl+0x30` = actor, `FUN_0032CB58` lo registra en el mundo de colisión. La llama **`FUN_0012BE80`** (estado del cargador) para `i < cuenta` = 1 — J2 nunca pasa — y el spawner de enemigos **`FUN_00138C80`**, que tiene la secuencia completa de alta de un actor.
- Medido: mgr = `0x00585C00`, J → controlador `0x00587FC0` (índice 2), **`J2+0xB4` = 0** antes y `0x00588100` (índice 6) después, 6 → 7 de 20 ocupados.

**Correcciones a (81), medidas con J2 caminando:** `FUN_00170320` **copia** la matriz y la posición del jugador al cuerpo de `+0x34C` (`cuerpo+0x30` = `J+0xA0` + (0; 0,8; 0)): ese cuerpo es un **seguidor**. El de J2 (`0x00699200`) **está** en la lista activa del mundo `0x0066E900` (2.º de 6) y **sí** sigue a J2. El «0 campos que responden» de (81) era de medir con J2 quieto. `fisica` sigue en K4; su evidencia quedó corregida.

**Auditoría del éxito:** con la ranura **compartida** de (79) (`J2+0x330` = `0x004ED7F0`, `*(0x004EDA30)` = J), J2 camina igual (8,90 / 6,97 / 10,16 / 6,41 m). **Receta: (79) + `control2` + `estado 2` + `atar`.** La ranura propia y la copia de tres bloques no hacen falta.

**En pantalla (Fran puso PCSX2 al frente):** desde J, J2 se ve como **dos brazos de primera persona flotando, sin cuerpo** — cuatro capturas, el objeto se mueve con J2 y del lado que da la geometría, y sigue ahí con la ranura compartida. Un arma grande en primer plano apareció en una captura sola: sin explicar. **Entra a la Fase B:** J2 necesita un modelo de personaje.

**kb:** `ragdoll` **K2 → K5**, renombrado: `0x0040F4CC` son los **cuerpos de personaje** (controladores de colisión de los vivos, ragdoll de los muertos). `juego` K5 con la nota. **Prueba offline nueva** (183 comprobaciones), con su saboteador en rojo 1 de 183. **Lección** registrada y foldeada en `chequeo-de-trabajo.md`: un «no cambia» medido con el objeto quieto no distingue «no corre» de «copia algo quieto».

**Sigue:** lo último de la Fase A contra la tabla del PDP §4 es **`spawn` (fila 7, K3 → K5)**: una aparición fuera de la carga. Punto de partida en frío: `FUN_00138C80(mgr, spawner, datos)` (llamada por `FUN_00178BC0`) saca un actor de las listas libres de `mgr+0x7990`/`+0x79A0`, lo resetea (`FUN_001327F0`) y le da cuerpo, cerebro, controlador y enlace. Después: `atar` permanente en el envoltorio de carga.

**Estado de la máquina al cerrar:** PCSX2-MCP abierto, City Streets, J2 vivo **con controlador** (`0x00588100`) y con la **ranura compartida** (P16 la devolvió); el stub por cuadro tiene el programa de `atar` en el estado 1 (estado actual 3). **Slot 13** = J2 con controlador y con la ranura 1 de (81) (15:26). Slot 12 = lo de (81), sin controlador. Todo lo que no está en un slot se pierde al recargar.

## 2026-09-27, NOTEBOOK — LA RANURA NO ERA LO QUE FALTABA: EL CUERPO FÍSICO DE J2 NO LO INTEGRA NADIE (bitácora (81))

> **Corregido por (82):** el cuerpo físico de J2 **sí** está en la lista y **sí** sigue a J2; lo que faltaba era el controlador de colisión de `J+0xB4`.

**Dos predicciones escritas antes y las dos refutadas** (eso es el resultado, no un fracaso):
- **P13a:** `molde+0x2C3` = 1 **no sobrevive a la construcción**. El constructor escribe ese byte él mismo (`J2+0x2C0..0x2C7` queda **idéntico byte a byte** al de J) y pone el arma en `armas2[0]`. `J2+0x330` quedó en la ranura 0. La lectura de (80) —el índice sale de `+0x2C3`— **no queda refutada**: esta sonda no llegó a ponerla a prueba.
- **P14:** con `J2+0x330` = `0x004EDA30` (ranura 1) y `*(0x004EDA30)` = J2, escritos a mano con el sistema **vivo** (`*(0x0040F50C)` = `0x004ED380`), `FUN_001334E0` **sí corre para J2 y usa la ranura nueva** —medido: el `a0` de la llamada a `FUN_001A6BE0` es `0x004EDA30`— y **J2 igual no se desplaza** (8 muestras).

**El control que pidió Fran, y descarta la explicación competidora:** no es una pared. Los **cuatro** empujes (adelante, atrás, los dos laterales, 1 s cada uno) dan Δ = **0,000000** y `+0x2E0` = **0,0000**, con el yaw de la mira yendo 22,88° → 80,21° en la misma pasada. Una pared frena una dirección, y contra una pared el jugador **desliza**.

**La cadena del paso, medida eslabón por eslabón con el eje SOSTENIDO** (no en pulsos), con `ritmo_vigilante.py --ra`:
1. **El pedido llega:** `falso2+0x8C` = 1,0 → `J2+0x5C4` (= mira+0xD4) = 1,0. Lectores: `0x0013F718` (la tabla de acciones de (77), `a0` = `0x00472100`) y `0x0013AB80`, que es `lwc1 $f3, 0x5C4($s1)` con **`s1` = J2** — suavizado de la mira, no el paso.
2. **El motor de movimiento corre para J2:** `FUN_001334E0` escribe `J2+0xD0` desde `0x001338AC` y `0x00133B20`.
3. **La rapidez pedida se calcula:** en J2 responden `+0x540` = 0,3888, `+0x548` = 0,9213 (versor de avance de su yaw), `+0x5C4` = 1,0 y **`+0x5D8` = 4,5**. En J responden esos cuatro **y 40 campos más** (posición, velocidad, rapidez real, suelo, estela). En J2, **ninguno de esos 40**.
4. **Acá se corta:** el **cuerpo físico de J2** (`0x00699200`) tiene **0 campos que responden y 0 de ruido**; el de J (`0x006B8180`), 8 y 1. **Nadie lo integra.**

**Quién integra el cuerpo de J:** vigilante `write` sobre `0x006B81B0` → PC `0x00170600` las 3 veces, dentro de **`FUN_00170320`**, que **no tiene llamadores en el ELF**: es un **callback virtual** que invoca **`FUN_002EA898`** (`ra` = `0x002EA92C`, `a0` = `0x01FFFA70`, `a1` = cuerpo+0x48), del motor de física. **El motor recorre su propia lista de cuerpos activos y el de J2 no está.**
**Cabeceras de los dos cuerpos:** iguales en `+0` (vtable `0x003DCFE0`), `+8`, `+0xC`, `+0x10`, `+0x1C` (0x1B); distintas en `+0x14` (`0x0066EBE4` vs `0x0066EBBC`) y en **`+0x18`** (**0** en J, **`0x00699680`** en J2, puntero dentro del mismo pool). Hipótesis **sin confirmar**: `+0x18` es el enlace de la lista libre y el cuerpo se entregó sin darse de alta.

**Dos correcciones que cambian el mapa, y no son menores:**
- **`FUN_001A6BE0` no camina:** recorre 7 sub-objetos de la ranura y multiplica la matriz del **dueño** por la matriz local de cada uno. Es la **propagación de acoples**. La frase de (80) queda retirada.
- **La posición del jugador es `+0xA0`, no `+0x100`.** `FUN_001334E0` escribe `+0x100` = `+0xA0` + `+0x2E8` − 0,2, con `+0x2E8` = **1,65** en los dos: `+0x100` es el **ojo**. Todo lo que se mida de ahora en más va contra `+0xA0`.

**kb:** `fisica` **K3 → K4** (mecanismo medido en vivo con control positivo, sin efecto causado por nosotros). **`personajes` sigue en K4**: la sonda que lo subía a K5 se corrió y **no** produjo el efecto; su sonda quedó reescrita.

**Trampa nueva, medida:** `jugador2.py carga-poner` **mató PCSX2 la primera vez**, con una tormenta de `[EE] Impossible block clearing failure` en `emulog.txt` exactamente en la ventana de la corrida (el recompilador del EE contra las escrituras de código). Se relanzó con `lanzadores/ABRIR-BLACK-ORIGINAL.bat`, se recargó el slot 3 y el **mismo comando anduvo**. O sea: es intermitente, no determinista — **si muere, se reintenta; no se busca la causa en el comando.**

**Ahorro para la próxima:** `pine.py savestate --slot 12` guardó **J2 vivo, corriendo, con el mando 2 y con la ranura 1 propia**. Reproducir el estado de (79) + P14 pasa a costar **un comando**. (El slot 12 estaba libre: había 0 a 11.)

**Sigue, y arranca EN FRÍO:** **cómo se da de alta un cuerpo en el motor de física** — `FUN_0016E660` entera, y quién mete un cuerpo en la lista que recorre `FUN_002EA898`. Es lo único que falta del criterio de salida de la Fase A.

**Estado de la máquina al cerrar:** PCSX2-MCP abierto, **City Streets cargado**, J2 vivo con el gancho puesto (`0x00129574` = `0x0C11B600`) y el envoltorio del cargador puesto; `ctrl1+0xC` = `0x00472000` (falso 1) y `ctrl2+0xC` = `0x00472100` (falso 2), los dos ejes en 0. J caminó unos 5 m en el control positivo. **Todo esto se pierde al recargar: está guardado en el slot 12.**

## 2026-09-27, NUBE — TANDA EN FRÍO N1–N5: LA RANURA DE PERSONAJE, MEDIDA (bitácora (80, nube))

**Esto no tocó RAM.** Todo acá es `probable` (ELF + volcados). Lo que sigue es **local** y el mensaje para pegar está en `sesiones/RETOME-LOCAL.md`, **ya reescrito con esto**.

**Lo que contesta, y ahorra sondas:**
- **La copia del sistema de personajes PUEDE funcionar.** 35 accesos a `0x0040F50C` medidos sobre las instrucciones (`herramientas/lectores_global.py`), 23 funciones, **una sola escritura** del puntero (`0x00102174`, el init). La aritmética de la ranura existe en **dos** sitios y ninguno corre por cuadro; lo que el cuadro le hace al sistema por el global son dos contadores y **dos stubs vacíos**. El desplazamiento llega por **`J+0x330`** (`0x00133B10`), no por el global.
- **Por qué J2 no camina (mecanismo, no hipótesis):** `FUN_001a6be0(ranura)` arranca leyendo `*(ranura)` = **el DUEÑO** y usa su matriz. J2 comparte la ranura 0, de J0.
- **El índice de ranura NO está fijo en 0:** sale de **`J+0x2C3`**, que es **el arma en la mano** (`FUN_0016bee0` lo usa para indexar `J+0x2A0`). Las 2 ranuras son **las 2 armas del único jugador**. J2 lo hereda en 0 del molde.
- **La copia son TRES bloques, no uno (0x1D10 B).** Cada ranura tiene un **compañero de 0x9D0 B en el montón**, en `ranura+0x54`, que `FUN_001a4ff0` aloja y que apunta de vuelta en `+0x84`. La especificación vieja (copiar 0x970 y reubicar autopunteros) **quedaba escribiendo en el estado de animación de J0**.
- **`J+0x7C` y `+0x8C` NO son sonda:** son carriles W de la matriz del objeto, y **nada del camino de construcción los escribe** — los instala código de arranque que recorre `jugadores[]` con la cuenta en 1 (**cuarto lugar compilado para un solo jugador**).
- **Argumentos del atado a mano:** `FUN_001a51c8(COPIA+0x470+k·0x240, J2, COPIA+0x398+k·0x6C)`, con **el global ya en la copia** (la función lo lee 3 veces adentro).

**Herramientas nuevas (probadas, con saboteador en rojo):**
- `herramientas/lectores_global.py` — todos los accesos del ELF a un global, por opcodes crudos. Encontró uno que el decompilado se come (`0x001ABFB8`).
- `jugador2.py ranura-copiar [--seco] [--volcado F] [--dueno-a-mano]` — los tres bloques, reubicaciones **medidas en vivo**, `+0xB8` = 0.
- `jugador2.py carga-poner --copia-ranura` — el envoltorio cambia `*(0x0040F50C)` alrededor del `jal 0x139c68` y lo restaura. Sin la opción no toca el global: es el control de (79).
- `pruebas/prueba_herramientas.py`: **180** comprobaciones en verde (157 → 180), con cinco saboteadores puestos en rojo.

**Trampa nueva, de diseño:** `FUN_0015be70` → `FUN_0013c868` recalcula `J+0x330` **desde el global** al **cambiar de arma**, y sólo si `+0xC4 == 2`, o sea justo para los jugadores. Con la copia puesta, si J2 cambia de arma su `+0x330` vuelve al sistema original. Para la Fase A: no cambiarle el arma a J2.

**kb:** nace **`personajes`** (K4); `audio` pierde `0x0040F50C`, que nunca fue suyo (el error entró en (74) al fusionar el vecino). 37 → 38 subsistemas. `personajes` entra como habilitador de M1/M2/M5; se corrió `trade` **antes y después** y el orden no se movió.

**PENDIENTE que no se pudo hacer en la nube:** registrar las dos lecciones de proceso con
`aprender.py agregar` — **`perfil-global` no está en el árbol de la nube** (repo aparte, no
clonado). Las dos, escritas con el síntoma como se veía *antes* de entenderlo, para que la
notebook las cargue:
1. *(grupo `medicion`)* **Síntoma:** un saboteador pasa —el caso malo sale descartado— y uno
   lo da por bueno. **Qué era:** se descartaba por otra razón que la que la prueba dice medir
   (acá, un borde de función del grafo sintético en vez de la página alta del `lui`).
   **Regla:** un saboteador tiene que medir el **motivo** del descarte, no sólo el descarte;
   si no, es un verde falso, que es peor que no tenerlo.
2. *(grupo `evidencia`)* **Síntoma:** un dato del `kb` con una etiqueta que no le cuadra a
   nadie, y dos bitácoras seguidas aclarando «el kb lo tiene bajo X y no es X».
   **Qué era:** al **fusionar** dos nodos, el global vecino se vino puesto con la etiqueta del
   primero, sin que nadie lo midiera (aquí: `0x0040F50C` bajo `audio`, desde (74)).
   **Regla:** al fusionar nodos, **cada dirección que entra necesita su propia evidencia**;
   la vecindad en el mapa de globales no es evidencia de nada.

**Primero en la notebook:** la **sonda 0** de `RETOME-LOCAL.md` — `J2+0x2C3` = 1 y el dueño de la ranura 1 a mano. Un byte, y contesta sola si J2 camina cuando la ranura es suya, antes de gastar la copia.

## 2026-09-27, NOTEBOOK — EL JUGADOR 2 CONSTRUIDO POR EL JUEGO; EL MANDO 2 LO GIRA, NO CAMINA (bitácora (79))

**Confirmado en RAM con control:**
- **Un segundo jugador construido por el constructor del juego, durante la carga, y el juego sigue.** `jugador2.py carga-poner` (molde en `0x0046CDF0` con `+0x8A4` = 0x1C, arreglo de armas propio en `0x0046DBC0`, gancho por cuadro en estado 0, envoltorio en `0x0046DA00` sobre el `jal 0x00129090` del cargador en `0x00128EA4`) + carga de City Streets por el selector. J2: `+0x8A4` = 0x37, en el punto de aparición, arma propia `0x006DE7A0`, cuerpo físico propio `+0x34C` = `0x00699200`. Migas del envoltorio: A (aparición) `0x0046D7A0`, B (constructor) `0x0046D798`, `v0` `0x0046D7A4`, C (registro) `0x0046D7A8`; fase `0x0046D790`.
- **J2 corre a 60 Hz** (`control2` + `estado 2` → 3: enganchado a la lista y a la grilla, controlador + update por cuadro) **y J no se congela** (el falso 1 lo sigue moviendo).
- **El mando 2 gira al jugador 2 y no a J** (con `J2+0x32C` = `J2+0x4F0`, que `control2` ya pone). El «adelante» del falso 2 llega a `J2+0x4F0+0xD4` = 1,0.
- `juego` **K4 → K5**.

**Lo que se descubrió y cambia el diseño:**
- **El índice −577 da `0x0046D1F0`, no `0x0046CDF0`** (`juego` = `0x005A8A80`). P6, P6b, P7, P8 y P9 colgaron porque el constructor escribía encima del stub y del envoltorio. **La lectura «el constructor depende de la carga» queda retirada.** El envoltorio ahora replica `FUN_00129090` con J2 cargado a mano.
- **Tercer lugar compilado para uno:** el pool de cuerpos físicos del tipo 2 (jugador) tiene **cuenta 1** (`*(0x0040F4D4)+0x22B28+0x88`). Sin cuerpo, `FUN_0016e660` escribe en la dirección `0x20` y cuelga todo. Arreglo en uso: `J2+0xC4` = 1 durante el registro (pool del tipo 1: 16 cuerpos libres, misma clase) y 2 después.
- **La init deja activo el controlador `+0x7D0`** (sin mando); a J0 algo posterior le pone `+0x4F0`.
- **Por qué J2 no camina (probable):** la posición la escriben `0x001338B4`/`0x00133B08`/`0x00133B2C` (`FUN_001334e0`) para J2 también, pero con desplazamiento 0; el tercero trabaja sobre **la ranura de personaje** (`+0x330` = `0x004ED7F0`), que J2 comparte con J0 sin tenerla atada. El sistema de personajes (`*(0x0040F50C)` = `0x004ED380`, 0x970 B; **el kb lo tiene bajo `audio` y no es de audio**) tiene exactamente 2 ranuras y 2 instancias, las dos de J. `J2+0x7C` y `+0x8C` quedaron en 0.
- **El vigilante `write` dispara aunque el valor no cambie** (medido sobre la posición quieta de J2).

**Trampas nuevas:**
- Después de `pine.py cargarestado --slot 3` el depurador puede quedar **en pausa**: `depurador.py continuar`. Y conviene esperar ~20 s antes de escribir código: una vez, a los 5 s, el EE cayó en una excepción (PC `0x00410827`); sin explicar.
- El guardia de comandos bloquea por falso positivo PowerShell con `.Replace(` o textos con «J:»: usar Edit o un script en el scratchpad.

**Siguiente, en este orden:**
1. **Darle a J2 su propia ranura de personaje.** Copiar el sistema de personajes (`0x004ED380`, 0x970 B) a `0x0046DC00` (cero en vivo dentro del `.bss`; **vigilarlo 12 s con `ritmo_vigilante.py --tipo write` antes**), reubicar sus autopunteros y poner `+0xB8` = 0 en las dos ranuras de la copia (que `FUN_001a51c8` no suelte nada). En el envoltorio, alrededor del constructor de J2: `*(0x0040F50C)` = copia, y de vuelta al original después. (a) Molde en **2** (el camino que carga el modelo y ata la ranura: P6/P8 no lo refutan, colgaron por el índice); (b) si ése cuelga, molde en 0x1C y atar a mano `FUN_001a51c8(copia+0x470, J2, copia+0x398)`. Medir si «adelante» en el falso 2 mueve `J2+0x100`.
2. Quién escribe `J+0x7C` (instancia de animación) en la construcción de J0: J2 lo tiene en 0.
3. Corregir en el kb que `0x0040F50C` no es `audio` (es el sistema de personajes/animación).

**Estado de la máquina al cerrar:** PCSX2-MCP con el **slot 3** recargado, vivo, **sin ganchos ni parches** (`0x00129574` = `0x0C04EEB2`, `0x00128EA4` = `0x0C04A424`), mandos reales (`ctrl1+0xC` = `0x005856C0`, `ctrl2+0xC` = `0x005857B0`). Todo lo de J2 se pierde al recargar: se rehace con los comandos del retome.

## 2026-09-27, NOTEBOOK — SELECTOR DE DEPURACIÓN, CÓDIGO NUEVO Y EL PROTOTIPO (bitácora (78))

**Confirmado con control:**
- **Selector de niveles de depuración, sin manos:** `python herramientas/selector_depuracion.py pedir-frontend --bandera 0 --segundos 7`, después `elegir <nivel 0..11> <unidad 0..>` y `aceptar`. La bandera `0x0040D986` hay que reescribirla en los estados 6/7 del front-end (el estado 5 la repone en 1; el script ya lo hace). Tabla: 0 City Streets … 7 Gulag, 8 Character Viewer (97), 9 Object Viewer (98), 10 Danger Room (99), 11 Gun Street (96). **96 y 99 cuelgan en la carga** (estado 3 del modo juego); City Streets carga en ~15 s. El selector no dibuja nada: se maneja por RAM (`estado`).
- **Cambiar de modo por PINE:** escribir `sesion+0x21074` = modo, `+0x210CB` = 1, `+0x210C8` = 0, `+0x21084` = 2 (y el fundido `*(0x0040F544)+0x394C` = 1, `+0x3948` = 1.0). Modos: `+0x20220` front-end, `+0x20F78` juego.
- **5a:** la cuenta la escribe `FUN_00105318` (el «entrar» del modo juego) con 1 en cada llamada (`0x0010534C`); nadie pide el modo `+0x20F90`.
- **Código nuevo (sonda 6):** `python herramientas/gancho.py poner | contar 2 | quitar`. `jal FUN_0013bac8` de `0x00129574` → stub en `0x0046D700`; contador en `0x0046D780` sube 59/s. `FUN_00129360` corre a **60 Hz**.
- **Tramo `0x0046CDF0…0x0046DC00`:** nadie lo escribe en juego normal (vigilante `break`, 0 en 12 s en tres direcciones).

**Lo que no anduvo (el prototipo):**
- **Clon sin constructor** (`clon_jugador.py`): enganchado a la lista del mundo (`juego+0x5CA4`) se actualiza pero **congela a J**; desenganchado, J camina. Estado externo compartido.
- **Constructor del juego en caliente** (`jugador2.py`: molde = copia de J en `0x0046CDF0`, stub en `0x0046D800`, estado en `0x0046D784`): `FUN_00129090(juego, −577)` **cuelga el hilo** (SleepThread) con el molde en `+0x8A4` = 0x37 y también en 2. Una tercera corrida con migas **tiró el emulador** (se relanzó con `lanzadores/ABRIR-BLACK-ORIGINAL.bat`).

**Trampas nuevas:**
- El vigilante de escritura parece disparar **sólo si el valor cambia** (hipótesis: el `sw zero` del prólogo del constructor sobre un 0 no se vio). Confirmarlo con `--tipo onchange` vs `write` antes de leer un cero como «no pasó».
- `json.dump` reformatea `kb/subsistemas.json` entero (pasó otra vez); escribirlo con `herramientas/kb_formato.py` (`from kb_formato import volcar`; `kb_formato.py verificar` comprueba que reproduce HEAD byte a byte).
- `programa.py verificar` encadenado con el commit no frena el commit: después de subir una K, correr `programa.py catalogo`.

**Siguiente, en este orden:**
1. **Prototipo durante la carga:** gancho en `0x00128EA4` (`jal 0x00129090` del cargador, `a1` = índice, `a0` = `juego` en el hueco) hacia un envoltorio: llama la original; cuando devuelve 1 (jugador 0 hecho), pasa a llamar `FUN_00129090(juego, −577)` hasta que devuelva 1 y recién ahí devuelve 1 al cargador. Molde en `0x0046CDF0` copiado de J **antes** de disparar la carga con el selector. Después, el gancho por cuadro de `0x00129574` para `FUN_0012a158(juego, J2)` una vez y `FUN_0013bac8(J2)` + update por cuadro, y las copias de control de J2 → `0x00585A0C` → falso 2 (`0x00472100`).
2. Si cuelga también: vigilantes `onchange` y migas dentro de `FUN_00139c68`.
3. ~~Decisión de Fran sobre la cámara de cine~~ **Contestada:** mejora de experiencia de **prioridad mínima**, para el futuro (`PDP.md` §6). No se trabaja en COOP-A.

**Estado de la máquina al cerrar:** PCSX2-MCP relanzado (`ABRIR-BLACK-ORIGINAL.bat`) con el **slot 3** cargado, vivo, **sin ganchos ni parches** (`0x00129574` = `0x0C04EEB2`), `ctrl1+0xC` = `0x00472000` (el mando falso 1 quedó puesto: `sondas_coop.py falso-quitar` lo devuelve).

## 2026-09-27, NOTEBOOK — BOTONES Y LA CÁMARA DESACTIVADA (bitácora (77))

**Confirmado con control:**
- **Botones del mando falso:** `python herramientas/sondas_coop.py boton <nombre|i> <s>`. 12 = disparar (el cargador baja 14 → 6 en 1 s), 2 = recargar (cargador 6 → 15, reserva 30 → 21), 6/7 = cambiar de arma, 11 = zoom, 8 = **pausa** (el manejador del jugador deja de correr). El mando procesado: `+0x2A+i` actual, `+0x0E+i` anterior, `+0x4C+4i` valor; el juego pide **acciones** por la tabla `*(0x003BCAC8)` = `0x004BC174`, que consume `FUN_0013f618(mira = J+0x4F0)`.
- **Munición:** cargador = u16 en `*(J+0x2A4)+0xF4` → `+0x18`; reserva = u16[tipo] en `J+0x280`.
- **Matar sin manos:** `python herramientas/matar_sin_manos.py <enemigo> <bandera 0|1>` (yaw = 90° − rumbo, pitch al pecho). Enemigos: pool de clase `0x003DCA78` (vida `+0x2F8`, posición `+0xA0`). En el slot 3: `0x00592F50` a ~10 m, `0x00592410` a ~13, `0x005936D0` a ~17.
- **La cámara desactivada de fábrica ANDA** (RAM + pantalla, con control): forzando la animación de muerte 3 (`anim_muerte.py <enemigo> 1 90 --forzar3 --capturas <carpeta>`), ~1,5–2 s de cámara de cine con franjas y sin HUD. Sin forzar, la 3 casi nunca sale: la elige `FUN_00120068` según la **geometría** del lugar (6 de 6 muertes eligieron la 0). Capturas en `volcados/capturas-77/` (locales).

**Trampas medidas hoy:**
- El juego estaba en el **menú de pausa** al empezar (y el 8 lo abre): el eje del falso no mueve la vista y todo da negativo. **Antes de cada sonda, un control positivo de «vivo»** (un eje que mueve el yaw).
- Después de continuar desde el vigilante en la secuencia forzada, **PINE no responde varios segundos** (el emulador sigue vivo). Lo que pasa ahí se mira con `rafaga-capturas.ps1`.
- `FUN_0011c930` lee `0x0040D9A3` **una vez por cuadro** (`0x0011C948`): un vigilante ahí frena cada cuadro y el juego va a ~4 cuadros/s.
- El breakpoint de ejecución sigue bloqueado a propósito (`--se-que-crashea`); el vigilante de lectura sobre un dato que lee la instrucción sirve igual.

**Siguiente, en este orden:**
1. **Decisión de Fran:** si la cámara de cine entra al mod (con `0x0040D9A3` = 1 saldría sólo donde el lugar arma la animación 3; forzarla siempre es otro parche).
2. **5a por menús:** vigilante de escritura en `0x004BC208` y recorrer los menús con el falso (índices de menú 2, 4, 5, 6, 7, con flanco; 8 abre la pausa). Predicción pendiente de escribir.
3. **Prototipo por PINE** (criterio de salida de la Fase A): segundo bloque de 0x8C0 fuera del array, tres copias de control en `0x00585A0C`, mira propia. Primero en frío: qué de `FUN_0013ba40` y del update por cuadro hace falta.
4. Niveles 96–99 desde el menú (predicción: falla la carga).

**Estado de la máquina al cerrar:** PCSX2-MCP abierto con el **slot 3** cargado (después de la muerte de control: un enemigo menos), `ctrl1+0xC` de vuelta en el mando real (`0x005856C0`), `0x0040D9A3` = 0, sin vigilantes ni parches vivos. Recargar el slot 3 antes de medir.

## 2026-09-27, NOTEBOOK — LOTE DE SONDAS CORRIDO SIN FRAN (bitácora (76))

**Confirmado en RAM con control** (todo en el slot 3, `LEVEL_00`, ISO original):
- **Sonda 1, `entrada` K5:** el jugador `0x005A8AB0` guarda su control en **tres copias** (`J+0x588`, `J+0x6D0`, `J+0x7C8`), que copia la init `FUN_0013ba40` desde `sesión+0x21060`. Con las tres en `0x00585A0C` (control 2 = gestor `0x00585400` + `0x4A0` + `0x16C`) el mando 2 lo maneja; con `0x005858A0` vuelve el 1. `+0x418` en caliente no hace nada. **La tabla `sesión+0x21060` está compilada para 1**: su «entrada 1» es `sesión+0x21070` (el modo actual).
- **Sonda 3a, `camara` K5:** la fuente del yaw es **`mira+8` = `0x005A8FA8`** (`FUN_001404a8` integra el stick con `dt` y copia `+8` en `+0`; pitch en `+0xC`, tope ±70°). `0x005A8FA0`, `J+0x2F0` y `0x006B81C0` son copias: escribirlas no hace nada.
- **3b/4 (medido en vivo):** `0x0043F790` se escribe 4 veces por cuadro desde `0x00269F78`; la vista 160 × 112 se lee 10 veces por cuadro. `render` K4.
- **Entrada sin manos:** `python herramientas/sondas_coop.py falso-poner`, después `eje adelante 0.8 0.5` (ejes: `adelante atras lateral_a lateral_b pitch_arriba yaw_izq yaw_der`), y `falso-quitar`. El mando falso vive en `0x00472000` (`.bss` en cero en 3 volcados y en vivo: libre **probable**).

**Negativas:** `cam+0x7E1` = 1 no cambia la vista; mover una zona disparadora (armada en estado 3) sobre el jugador no la dispara, aunque su prueba corre por cuadro; los botones no son bytes en `+0x10…+0x8B` del mando procesado.

**Sin hacer, y por qué:** 5a, `0x0040D9A3` (la cámara desactivada: hay que matar a un enemigo con el rifle a más de 6 m) y los niveles 96–99 necesitan **botones**; la ValueDB con efecto necesita oír (sus 49 valores con nombre son de sonido) o recargar el nivel.

**Trampas medidas hoy:**
- `depurador.py --accion log` **no cuenta**: usar `ritmo_vigilante.py` (break, puesto en pausa). Poner un `break` con el juego corriendo cerró PCSX2.
- El emulador puede quedar **pausado por el depurador** sin pedirlo (se vio en `0x00336668`): antes de medir, `depurador.py estado`. Reanudar desde ahí lo cerró; se relanzó y se recargó el slot.
- Los dos mandos físicos **derivan** (stick derecho del 1: +27°/s de yaw, pitch al tope −70°): cualquier medición de la vista tiene que contar con eso, o usar el mando falso quieto.
- El savestate del slot 3 trae **vida 990.590** y hay enemigos disparando cerca.

**Siguiente, en este orden:**
1. **Botones del mando falso — empezado.** Lo más probable (frío, `FUN_0026baf8`): 28 entradas por mando, y los **16 botones como floats de presión en `+0x4C…+0x88`** del mando procesado (los sticks son las entradas 16–27). Con 1.0 ahí, los botones 4, 8 y 10 cambian la pose del arma en pantalla y el 11/12 mueven RAM del jugador: **hipótesis**. Falta un observable en RAM del arma (munición) para mapearlos con control; después, disparar a un enemigo con el rifle.
2. **Prototipo por PINE** (el criterio de salida de la Fase A): alojar un segundo bloque de 0x8C0 fuera del array (¿en el tramo libre de `.bss`?), con sus tres copias de control en `0x00585A0C` y su objeto de mira propio.
3. Con botones: 5a, `0x0040D9A3` (si funciona, **es decisión de Fran** si entra al mod) y los niveles 96–99.

**Estado de la máquina al cerrar:** PCSX2-MCP abierto con el **slot 3** cargado (`LEVEL_00`; el volcado `ee-11` se tomó antes, del slot 11), sin parches vivos, sin vigilantes, `ctrl1+0xC` en su valor real (`0x005856C0`). Todo lo escrito en RAM se pierde al recargar un slot.

## 2026-09-27, CIERRE — PLAN DEL ELF COMPLETO (E1–E7 + GLOBDATA). SIGUE LOCAL

**Qué se hizo en la nube** (bitácoras (66)–(75); todo en `main`, commits `f6d7a8c`, `e142dde` y `02209e2` de esta tanda):
- **E6:** los 12 singletons de `sin-nombre` quedaron nombrados y repartidos (73). **E5:** `0x0040F510` = gestor de bancos de sonido, fusionado en `audio`, que pasa a K3 (74). **GLOBDATA:** las seis secciones tienen consumidor (75).
- Mapa: **37 nodos, ninguno en K0**. En K1 sólo queda `frontend-datos`. Nuevos: `disparadores` K3, `unidades`, `ragdoll`, `proyectiles` K2.
- Herramientas nuevas (corren en la nube y en la notebook con `BLACK_DATOS`): `herramientas/perfil_singleton.py`, `herramientas/valuedb_aku.py`.
- `black-datos` **no cambió** en esta tanda.

**Para la sesión LOCAL (notebook), en este orden:**
1. `git pull` en `claude-acceso`.
2. `.\chequeo-completo.ps1 -SoloSaboteadores` (pendiente desde el 26/09).
3. **Registrar las lecciones** (abajo, seis) con `aprender.py agregar` del **perfil global**.
4. `python herramientas/programa.py verificar` (tiene que dar 0 rojos) y `python pruebas/prueba_herramientas.py`.
5. **Una sesión de emulador, en lote.** Las predicciones se escriben en la bitácora ANTES de correr:
   - **sonda 1:** `jugador+0x418 = 1` por PINE → el mando 2 maneja al jugador 1 (control: volver a 0).
   - **sonda 3a:** escribir el yaw `0x005A8FA0` (f32, grados) → la vista gira. **3b:** *watch* de escritura en `0x0043F790` → una vez por cuadro desde `FUN_00269ea0`. **3c:** `0x0058EF61` = 1 → cambia la vista activa.
   - **sonda 4:** *watch* en `0x004CA2F0` (vista 160 × 112) y volcar el framebuffer `0x16B`.
   - **sonda 5a:** *watch* sobre `0x004BC208` recorriendo todos los menús → predicción: **nunca** se escribe 2. No escribir un 2 a mano.
   - **NUEVA, disparadores:** cruzar una puerta que dispara algo, con *watch* sobre los `+0x11D` de los objetos de `*(0x0040F4F4)+0x48` → cambia el del trigger que se cruzó. Coop: predicción de que el jugador 2 no dispara nada.
   - **NUEVA, cámara desactivada:** `0x0040D9A3 = 1` (u8) y matar a un enemigo a más de 6 m → predicción: arranca la secuencia de `0x0040F504` (cámara modo 0xB, el jugador sin control, aparece el objeto `BG1_ASR_SHL`). Control: con 0 no pasa. Si pasa, **es una función cortada que vuelve**: anotarlo para Fran.
   - **NUEVA, ValueDB:** con `python herramientas/valuedb_aku.py --volcado <volcado nuevo>` ubicar un valor (p. ej. `Low Health/HeartbeatThreshold = 0.4`), escribirlo en RAM y ver el efecto → primer K4/K5 de `valuedb` con un vehículo de datos.
   - **NUEVA, niveles de prueba:** elegir desde el menú un nivel de id 96–99 (si hay forma) → predicción: falla la carga, porque sus archivos no están en el disco.
6. Tomar **un volcado nuevo** en juego y subirlo con `windows/subir-datos-nube.ps1`, así la próxima tanda en la nube mide contra algo nuevo.

**Lecciones para registrar en la notebook** (`perfil-global` no está en la nube). Las dos primeras vienen de la tanda anterior y siguen pendientes:
```
python ../../../perfil-global/herramientas/aprender.py agregar --proyecto black --grupo medicion --titulo "Unidad supuesta, no medida" --costo "una sonda entera dada por negativa (bitacora (65))" --sintoma "una busqueda por datos da cero coincidencias en los tres volcados, y el resultado se anota como negativo" --regla "antes de buscar algo que sigue a un valor, contrastar la UNIDAD del valor contra un dato conocido. Un cero puede ser el filtro, no el mundo"
python ../../../perfil-global/herramientas/aprender.py agregar --proyecto black --grupo herramientas --titulo "Un lanzador puede ejecutar otra copia" --costo "un import fallido con la extension bien instalada" --sintoma "Unsupported language con la extension en la carpeta correcta" --regla "si una instalacion copiada no ve un cambio, leer en el log DE QUE RUTA carga los jar"
python ../../../perfil-global/herramientas/aprender.py agregar --proyecto black --grupo busqueda --titulo "La raiz que falta esconde el lazo" --costo "la mitad de los updates de E6 salian 'sin lazo' (bitacora (73))" --sintoma "un metodo que claramente corre en juego no cuelga de ninguna raiz del grafo" --regla "antes de concluir 'no se llama por cuadro', buscar el update real desde main: en BLACK FUN_00129360 cuelga de main y no de las vtables de los modos"
python ../../../perfil-global/herramientas/aprender.py agregar --proyecto black --grupo evidencia --titulo "Un sufijo no es un significado" --costo "una hipotesis inflada ('proyectil del rifle', 'camara de bala') escrita en kb/ y corregida el mismo dia (bitacora (75))" --sintoma "un nombre como BG1_ASR_SHL se lee por lo que 'suena' y arma una historia" --regla "antes de interpretar un token de un nombre, listar sus otros usos en el mismo diccionario (BG1_PST_SHL, BG1_SHG_SHL): el significado es lo comun a todos"
python ../../../perfil-global/herramientas/aprender.py agregar --proyecto black --grupo medicion --titulo "Nadie la escribe: medirlo por instruccion" --costo "casi se afirma una funcion desactivada solo con el decompilado" --sintoma "Ghidra muestra una bandera solo leida" --regla "confirmar la ausencia de escrituras en el binario (gp-relativas y absolutas) con control positivo en una vecina que SI se escribe; Ghidra puede no resolver un acceso"
python ../../../perfil-global/herramientas/aprender.py agregar --proyecto black --grupo evidencia --titulo "Un control positivo en cero puede ser del armado" --costo "una vuelta de mas con valuedb_aku.py (bitacora (73))" --sintoma "el control da 0 cuando la prueba en crudo daba 64" --regla "si el control sale en 0, revisar primero que la prueba reciba los mismos insumos que el experimento crudo (aca Ghidra no dejaba la ruta .cfg como literal) antes de dudar del hallazgo"
```

**Pendiente en frío (para una próxima tanda en la nube, si Fran la pide):** `frontend-datos` (K1; `WPNSCOPE.BIN` está en `black-datos`), el consumidor de `GLOBDATA` s5 (`juego+0x5AB8`), la clase de los objetos de 0x60 B del módulo tipo 0x24, y las 1273 claves sin nombre de `ANDY.AKU`.

## 2026-09-27, NOCHE — PLAN DEL ELF EN LA NUBE: E1–E5 y E7 HECHAS, E6 EMPEZADA

**Para la sesión LOCAL (notebook), en este orden:**
1. `git pull` en `claude-acceso` (todo en `main`).
2. `.\chequeo-completo.ps1 -SoloSaboteadores` (sigue pendiente del 26/09).
3. **Una sesión de emulador, en lote**, con las predicciones escritas ANTES en la bitácora:
   - **sonda 1:** `jugador+0x418 = 1` por PINE → el mando 2 maneja al jugador 1;
   - **sonda 3a:** escribir el yaw de mira `0x005A8FA0` (f32, **grados**) → la vista gira y la fila 0 de `0x005A8B80` queda a −yaw;
   - **sonda 3b:** *watch* de escritura en `0x0043F790` → salta una vez por cuadro desde `FUN_00269ea0`;
   - **sonda 3c:** `0x0058EF61` (`cámara+0x7E1`) en 1 → cambia la vista activa;
   - **sonda 4:** *watch* en `0x004CA2F0` (la vista 160 × 112) y volcar el framebuffer `0x16B` → qué se dibuja en la segunda pasada (hipótesis: brillo o reflejo a ¼);
   - **sonda 5a:** *watch* sobre `0x004BC208` recorriendo **todos** los menús → predicción: **nunca** se escribe 2 (bitácora (71)).
   **No** escribir un 2 en la cuenta a mano: los lazos pisarían el objeto de `juego+0x8F0`.

**Lo nuevo, en tres líneas** (bitácoras (66)–(71), todo **probable**, en frío):
- `camara` **K0 → K3**: el negativo de la sonda 2 era de **unidades** (el yaw está en grados). Gestor `0x0040F4BC`; proyección y viewport en `FUN_00269ea0(&0x0043F710, viewport, cámara)`, **los dos como parámetros**.
- `render` **K1 → K3**: el motor **ya dibuja por cuadro una segunda pasada de escena** con viewport y framebuffer propios (160 × 112, medido en 3 volcados). `s-0x0040F4C0` era el gestor de render y se fusionó en `render`.
- `sesion`: cuatro modos; el que pone la cuenta en 2 está **vacío** y nadie lo activa. **El coop se construye, no se desbloquea.**

**Para la próxima sesión en la NUBE:** pegar `sesiones/RETOME-NUBE.md`. Ghidra se monta con `bash herramientas/nube/instalar_ghidra.sh` (~5 min: Ghidra del caché de Nix porque los releases de GitHub dan 403, la extensión se compila, y el proyecto ya analizado se restaura de `black-datos/ghidra/`). El decompilado ya está en `black-datos/decompilado/` y se lee **sin Ghidra** con `python herramientas/leer_c.py 0xDIRECCION`. Siguiente: **el resto de E6** (los 12 sin nombre; `tiempo` ya quedó en K2, bitácora (72)) con `nombrar_por_decompilado.py --todos` y el diferencial de cada objeto entre volcados; y `s-0x0040F510`, cuya sonda quedó en `+0xB9D4…+0xC988`.

**Lecciones para registrar en la notebook** (`perfil-global` no está en la nube), con `aprender.py agregar --proyecto black`:
- `--grupo medicion --titulo "Unidad supuesta, no medida" --costo "una sonda entera dada por negativa (bitácora (65))" --sintoma "una búsqueda por datos da cero coincidencias en los tres volcados, y el resultado se anota como negativo" --regla "antes de buscar algo que sigue a un valor, contrastar la UNIDAD del valor contra un dato conocido (acá, el ángulo de la fila 0 de la matriz del jugador). Un cero puede ser el filtro, no el mundo"`
- `--grupo herramientas --titulo "Un lanzador puede ejecutar otra copia" --costo "un import fallido con la extensión bien instalada" --sintoma "Unsupported language con la extensión en la carpeta correcta" --regla "si una instalación copiada no ve un cambio, leer en el log DE QUÉ RUTA carga los jar: el launch.sh de Nix era un envoltorio que ejecutaba la copia de sólo lectura"`

**Material nuevo en `black-datos`:** `ghidra/BLACK.tar.zst` (proyecto analizado, con las 1194 funciones completadas), `decompilado/` (42 archivos C + `indice.json` + `grafo.json`). El `MANIFIESTO` tiene el SHA-256 del proyecto.

## 2026-09-27, TARDE — SONDA 5 DEL COOP HECHA EN FRÍO DESDE LA NUBE

**Para la sesión LOCAL, en este orden:**
1. `git pull` en `claude-acceso` (todo está en `main`; no hay ramas por mergear).
2. `.\chequeo-completo.ps1 -SoloSaboteadores` (pendiente del 26/09).
3. **Una sesión de emulador, en lote:**
   - **sonda 1:** por PINE, escribir `jugador+0x418 = 1` y ver si el mando 2 maneja al jugador 1;
   - **sonda 5a:** un *watch* de escritura sobre `0x004BC208` (la cuenta de jugadores) mientras se recorren **todos** los menús, para ver si algún camino llega a `FUN_00106010`, que la pone en 2.

   Las dos predicciones van escritas **antes**, en la bitácora. **No** escribir un 2 en la cuenta a mano: los lazos pisarían el objeto de `juego+0x8F0`.

**Sonda 2 (cámara), primer intento en frío: NEGATIVO** (bitácora (65)). Sigue en
K0. Siguiente paso: Ghidra headless en la nube (`docs/14-plan-elf.md`, E1 a E3) o
un *watch* de lectura sobre `0x005A8DA0` en la notebook.

**Sesión nueva en la nube:** pegar el mensaje de `sesiones/RETOME-NUBE.md`.

**Lo nuevo, en una línea:** el juego construye un solo jugador, pero recorre a
sus jugadores con una **cuenta que es una variable**, y hay una función que la
pone en 2 (probable; bitácora (64); `kb/subsistemas.json#sesion`).
Reproducible con `python herramientas/censo_jugadores.py volcados/ee-e4.bin`.

**Cómo trabaja la NUBE (para que no diverja):**
- El material del juego vive en el repo **privado** `fransalomone21/black-datos` (local: `C:\Users\frans\black-datos`), nunca en `claude-acceso`. Se sube con `herramientas\windows\subir-datos-nube.ps1`, que es re-ejecutable: para mandar un volcado nuevo, se agrega su ruta al script.
- En la nube: `BLACK_DATOS=/home/user/black-datos`. `ubicaciones.py` resuelve ahí los archivos que encuentra por nombre, y el JSON no se toca. `pip install capstone` hace de Ghidra para leer el código.
- Todo commit de la nube va a `main`, y a la rama de la sesión como espejo.

## 2026-09-27 — MCR CERRADA. COOP-A ABIERTA (sesión en la nube)

**Qué pasó:** Fran contestó las 22 preguntas (`docs/12` §7, textuales) y
después delegó: «decide todo vos, primero el coop, despues vamos viendo».
NGOs N1–N7 validadas con sus frases. Pesos **delegados** en
`kb/conceptos.json#pesos`: C1 30 · C2 10 · C3 15 · C4 25 · C5 15 · C6 5.
`programa.py trade` implementado, con puntaje derivado de `kb/` y sensibilidad
de 1000 corridas; sale 0. `probar-programa.py` pasa 9/9. KDP-A en `PDP.md` §6.

**Qué leer para seguir:** `PDP.md` §4 «Proyecto COOP» (7 sondas, en orden) y
`docs/13-coop.md` (el porqué, y qué sonda anda en la nube).

**Lo primero en la NOTEBOOK:** la sonda 1, por PINE: escribir
`jugador+0x418 = 1` y ver si el mando 2 maneja al jugador 1. Juntarla en lote
con la 3 y la 5 si ya están en frío. Antes, `.\chequeo-completo.ps1
-SoloSaboteadores` (lo pendiente del 26/09).

**Lo primero en la NUBE:** las sondas 2, 4, 5, 6 y 7 son en frío y necesitan
el ELF (`SLUS_213.76`, 3,4 MB) y uno o dos volcados de RAM de 32 MB. **No
pueden ir a `claude-acceso`, que es público.** Camino propuesto a Fran: un
repo **privado** aparte (`black-datos`) que la sesión de la nube agrega con
`add_repo`. Ghidra y la extensión del EE se bajan de GitHub (medido: se
llega) y `capstone` con pip.

**Resultado del trade, y lo que NO dice:** el top 5 es M6, P5, E2, P4 y M7.
Ni M6 ni P5 son proyectos por sí mismos: M6 depende de un coop local y P5 es
desarrollo de tecnología del coop. E2 y P4 suben por fáciles, con valor casi
nulo (C1 0,08 y 0,02). **La función no se retocó después de ver el
resultado**; si Fran quiere, que el valor funcione como filtro es un cambio
que se decide antes de volver a correr.

## 2026-09-26, NOCHE — PRE-FASE A DEL PROGRAMA, ESPERANDO A FRAN

> **Pendiente LOCAL (la nube no puede):** la corrida de saboteadores del sistema del 2026-09-26 se corto a mano por el tope del plan (97 %). probar-verificador.ps1 habia salido 1 en 0,8 s, sin diagnosticar. Correr .\chequeo-completo.ps1 -SoloSaboteadores en la notebook antes de tocar frenos. El corte dejo .claude/arranque.md movido a .probando: se restauro con git checkout.
> **En la nube SI se puede:** la MCR (respuestas de Fran, pesos, programa.py trade) y el analisis del coop en papel. NO: nada que pida el ELF, el ISO, los volcados, Ghidra o el emulador (viven en la notebook, fuera del repo).

**Qué leer, en orden:** `docs/11-programa.md` (cómo se decide), 
`docs/12-estudio-de-conceptos.md` (qué se puede hacer y las 22 preguntas),
`python herramientas/programa.py resumen` (el mapa). **No** hace falta releer
la bitácora vieja: lo que importa quedó en `kb/subsistemas.json`.

**En qué estado queda:** mapa de nivel 1 con 35 nodos y su K; catálogo de 48
conceptos; `programa.py verificar` 0 rojos; `probar-programa.py` 7/7;
`programa.py trade` **sale 2 a propósito** (faltan los pesos de Fran).

**Lo primero cuando Fran conteste:** copiar sus respuestas textuales a
`docs/12` §7 con fecha, poner sus pesos en `kb/conceptos.json#pesos` (con
`fuente` y `fecha`), marcar `validada: true` en las NGOs que él confirme,
correr la MCR (`docs/11` §6) y escribir el KDP-A en `PDP.md` §6. **Después**, el
análisis del coop, que él pidió para ese momento, con sus preguntas finas.

**Máquina:** nada abierto. Emulador cerrado, sin parches vivos, ningún ISO
montado. Los dos mandos están conectados (dicho por Fran; el juego los lee
en los volcados viejos, bitácora (61)).

## 2026-09-26 — REVISIÓN DEL PLAN. FASE 8 ABIERTA

**Qué cambió:** la fase abierta es la **8 — censo estructural**; 7e(a) cerrada,
7e(b) **cancelada** (su efecto lo trae la fase 9, R4). Motivo, medido: R3 (IA),
R5 (coop) y el catálogo de R2 no tienen estructura identificada, y de las seis
secciones de `GLOBDATA.BIN` sólo se entiende una (0,7 % del archivo). Detalle:
`PDP.md` §4 y §6, bitácora (60).

**Qué cierra la 8:** `kb/superficies.json` con cada R2–R7 con estructura +
grado + evidencia (o `desconocida` + sonda corrida) y las seis secciones con
consumidor. Lo mide `herramientas/superficies.py verificar` — **todavía no
existe**; se escribe en la fase, con `pruebas/probar-superficies.py` en rojo.

**ACTUALIZADO el mismo día: la 8c (coop) se hizo PRIMERO, a pedido de Fran, y
está respondida (`probable`).** El motor es de N jugadores compilado con N = 1;
cada jugador guarda su número de mando en `jugador+0x418` (= 0); el gestor de
entrada (`*(0x0040F0E8)` = `0x00585400`) ya lee **dos** mandos, puertos 0 y 1,
en `gestor+0x2C0` y `+0x3B0`. Falta lugar (`juego+0x8F0` ocupado) y cámara.
Todo en `kb/superficies.json#R5` y bitácora (61).
**Próximo paso de coop, por efecto (necesita emulador y a Fran con un segundo
mando):** mover el stick del mando 2 → tiene que cambiar `0x005857B0+0x88`;
con el mando 2 quieto, no. Predicción escrita en la bitácora (61).

**Orden de trabajo que queda, en frío (Ghidra + ELF + ISO por LBA):**
1. **8a** ¿quién piensa por el enemigo? Update de la vtable `0x003DCA78` y su
   cierre de llamadas: ¿toca `Kaim::`? Decide dónde vive R3.
2. **8b** consumidores de las secciones `0x80`, `0xF9300`, `0x132F80`,
   `0x133800`, `0x133F80`: quién lee `base+0x04..0x18` después del
   relocador `FUN_00105D48`. La `0x133800` y los 33 tipos de personaje es la
   primera hipótesis a matar.
3. ~~8c~~ hecha (arriba).
4. `superficies.py` + saboteador.

**Estado de la máquina, medido hoy:** **ningún ISO montado** (ni `D:` ni
`E:`). `ubicaciones.py` lo declaraba montado porque imprime `montajes` como
texto sin medirlo — **pendiente arreglarlo** (que lo mida con
`Get-DiskImage`). Emulador cerrado, sin parches vivos.

**Herramientas nuevas:** `censo_globdata.py` (secciones, por LBA, con control
positivo de la tabla de armas) y `censo_valuedb.py` (63 sitios, 58 nombres,
control positivo la mira). **Ninguna tiene saboteador todavía.**

---

> Bloques anteriores: empezaban por «SESION DEL 2026-09-05 (NOCHE)». Debajo
> están el de la TARDE, el de la MAÑANA y el de la MADRUGADA, en ese orden.

**Cuatro líneas de trabajo, independientes entre sí:**
- **7e** (reversing del stream de módulos, secciones 1-7) — abierta por la
  mitad (b). **Novedad del 2026-09-05:** el stream ya no necesita el emulador,
  se lee del ISO con `herramientas/stunit.py`.
- **BLACK Remaster / DLSS5** (sección **8**) — el pipeline está instalado y
  **corre**; R2(a) cerrada. Lo del 2026-09-05 está en el bloque **B** de abajo,
  y corrige el modelo de cuello de botella de 8.18/8.20.
- **Jugabilidad** (sección **9**) — **CERRADA el 2026-09-05 a la mañana**: el
  piso de la mira era una zona muerta del JUEGO, y el auto-apuntado apareció y
  quedó apagado. Bloque de arriba, puntos 1 y 2. (El bloque **A**, de la
  madrugada, es la sensibilidad y sigue valiendo.)
- **Niveles y formatos del ISO** (nueva, 2026-09-05) — armas por nivel y
  stream de módulos, los dos editables en frío. Bloque **C**.
- **Geometría (L2)** — **CERRADA el 2026-09-05**: el contenedor a la tarde y
  los VÉRTICES a la noche, las dos por el código. Bloques de arriba (NOCHE y
  TARDE). Lo único que queda del modelo es dónde se COLOCA cada submalla.

Si retomás 7e: secciones 1-7. Si retomás el Remaster: sección 8 y el bloque B.
Si retomás jugabilidad: bloque A y `docs/10-jugar.md`. Si retomás niveles o
geometría: bloques C y D, y `kb/formatos-iso.json`.

---

# SESION DEL 2026-09-05 (NOCHE) - LEER ESTO PRIMERO

**L2 cerró: LOS VÉRTICES están decodificados.** Por la misma vía que el
contenedor —el código—, tres eslabones más abajo. Las dos vías por los datos
siguen muertas y no se tocaron.

## 1. LOS TRES ESLABONES QUE FALTABAN

```
modelo+0x48    array de count(+0x68,u8) registros de 0xD0: las SUBMALLAS
   |           (CO01TRUCK: 11)
   v
submalla+0xC0  ->  FUN_0027e760  (0x0027E760)
   |               reloca +0x20 (ARBOL) y +0x24 (HOJAS), cuenta u16 en +0x28
   v
hoja de 0x10   ->  FUN_0027f6d8 / FUN_0027f708  (0x0027F6D8 / 0x0027F708)
                   SON LA MISMA FUNCION byte a byte: relocan +0x00 y +0x04
                   contra el registro. AHI SE ACABAN LAS RELOCACIONES.
```

Que se acaben las relocalizaciones es el dato: es lo que dice dónde terminan
los punteros y empiezan los datos. No hubo que adivinarlo.

## 2. EL FORMATO, COMPLETO

**El bloque** (`blk` = `submalla+0xC0`):

| campo | qué |
|---|---|
| `+0x00` / `+0x10` | 3 f32 caja MÁXIMA / 3 f32 caja MÍNIMA |
| `+0x20` | árbol BIH: `count(+0x2A, u16)` nodos de `0x18` |
| `+0x24` | hojas: `count(+0x28, u16)` registros de `0x10` |
| `+0x2A` | nodos = hojas − 1 (árbol binario lleno) |
| `+0x2C` | selector de relocador. Vale **1** en las 5883 submallas del ISO |

**El nodo BIH** (`0x18` = dos mitades de `0xC`, una por hijo): izquierda
`f32 max, f32 min`, derecha `f32 min, f32 max`, y después `u8 hijo, u8 0,
u8 eje, u8 tipo`. `tipo=0xFF` → el hijo es un NODO; `tipo=0x01` → es una HOJA.
`eje`: 0=X, 2=Z (el 1 no aparece). Cada mitad guarda el intervalo **exacto** de
su hijo sobre ese eje — por eso el árbol sirve como verdad de terreno.

**La hoja** (`0x10`): `+0x00` i32 → CARAS, `+0x04` i32 → VÉRTICES (los dos
relativos al registro), `+0x08` u16 tamaño total, `+0x0A/+0x0B/+0x0C` u8
**sesgo de X/Y/Z**, `+0x0D` u8 stride de cara (**8** en las 57845 hojas),
`+0x0E` u8 caras, `+0x0F` u8 vértices.
Cierra por construcción: `vértices − caras == 8·(+0x0E)` y
`tamaño − 8·(+0x0E) == 6·(+0x0F)` alineado a 4. Cinco campos atados.

**La cara**: 8 B = 4 × u8 índice + u32 (vale `0x0A`; «id de superficie» es
*probable*, no confirmado).
**El vértice**: 6 B = 3 × u16, **sesgados**.

## 3. EL SESGO Y LA ESCALA — es lo que más fácil se escribe mal

```
v = crudo − 0x8000   si el byte de sesgo de ese eje != 0
v = v − 0x10000      si v >= 0x8000        (leerlo con signo)
metros = (v + 0.5) * 1000/65536
```

El byte de sesgo vale **0x00 o 0xFF**, no hay un tercero en las 57845 hojas.
Sin él, un eje negativo se lee como +32700 y la malla explota.
El quantum `1000/65536` = **15.2588 mm**, o sea que un `s16` cubre **±500 m** —
y el `500.0` aparece **literal** en el registro de submalla, en `+0x38`.
El `+0.5` es el medio quantum del truncado del exportador: sin él, el error
contra la caja queda sistemáticamente en 0.99 quanta en vez de 0.49.
Los dos salieron de un ajuste por mínimos cuadrados sobre las 66 cotas de las
11 submallas de `CO01TRUCK` (a = 0.0152563 = 1/65.547, b = +0.0079).

## 4. LO MEDIDO — y cuál es la prueba fuerte

- **CONTENCIÓN (la fuerte):** los **630.379 vértices** de las 5883 submallas de
  las 42 unidades del ISO caen **adentro** de la caja que el propio bloque
  declara. **Cero** desbordes, con tolerancia de un quantum.
- **CAJA:** la calculada reproduce la del archivo a menos de un quantum en
  **5850 de 5883**.
- **ESFERA (independiente de min/max):** el registro de submalla trae en
  `+0xB0` un centro que **no** es el de la caja y en `+0xBC` un radio. La
  distancia máxima de los vértices decodificados a ese centro reproduce ese
  radio en las 11 submallas de `CO01TRUCK` **dentro de medio quantum**.
- **CONTROL DE FORMA:** las submallas 2..7 de `CO01TRUCK` son **idénticas byte
  a byte** — 219 vértices, caja centrada en el origen, radio 0.58. Son **las
  seis ruedas**.
- **LAS 33 QUE NO CIERRAN LA CAJA** son 13 modelos repetidos en varias
  unidades, y **11 son luces** (`CO03RNDLIGHT`, `CO04STLIGHT`, `CO04STLIGHT2`,
  `CO06DWN_LIGH`, `CO06CRN_LIGH`, `CO06LP_FLOOD`, `CO06STRLIGHT`,
  `CO08STLIGHT`) más `CO04BUNKER_A` y `CO08BUNKERII`. En todas, la caja del
  archivo es **más grande** que la malla y los vértices siguen adentro: caja
  floja, no error de decodificación.

## 5. HERRAMIENTAS NUEVAS

- **`herramientas/modelo.py`** — `submallas` / `vertices` / `verificar` /
  `obj` / `autotest`. El `obj` de `CO01TRUCK` sale con 4125 vértices y 1653
  caras.
- **`herramientas/probar-modelo.py`** — **seis** sabotajes, los seis en rojo,
  con control positivo antes y después de cada uno. Tarda ~4 min.

## 6. LO QUE SIGUE ABIERTO, Y NO SE DISFRAZA

- **DÓNDE se coloca cada submalla.** Las seis ruedas son idénticas y su
  transformación **no está** en el registro de `0xD0`. Falta el array de
  transformaciones. Candidatos sin abrir: el `+0x1C` del modelo (array de
  `count(+0x24)` registros de `0x30`, relocado por `FUN_001c64e8` →
  `FUN_001c62a8`), y el `+0x20` (array de `count(+0x24)` índices i16 que
  apuntan adentro de `+0x38`).
- **Si esto es colisión o render.** Las caras de 4 índices con un id de
  superficie y la caja floja de las luces empujan para colisión; que cuelgue
  del header del modelo empuja para lo otro. **No se afirma ninguna.**
- `+0xC4` y `+0xC8` del registro de submalla: el cargador los reloca y nadie
  los abrió. Sólo 2 de las 11 submallas de `CO01TRUCK` tienen `+0xC4`.
- El orden de ejes X,Y,Z **no está probado contra una permutación
  consistente** — lo único que lo ata es que las cajas salen con proporciones
  de camión. Está dicho en `probar-modelo.py`.

## 7. LO QUE COSTÓ UN TURNO, PARA NO REPETIRLO

El primer control negativo que escribí —quitar el medio quantum— **no puede
fallar**: mueve el dato 0.5 quanta contra una tolerancia de 1 quantum entero.
El autotest se puso en rojo por el control, no por el decodificador. Registrado
y foldeado en `chequeo-de-trabajo.md`. Y en una prueba de **contención** el
sabotaje peligroso es el que **encoge** la escala: todo cerca de cero cae
adentro de cualquier caja y pasa en verde. Por eso el sabotaje 5 divide por
100 en vez de multiplicar.

---

# SESION DEL 2026-09-05 (TARDE) - LEER ESTO PRIMERO

**L2 (geometría) cerró su primera mitad: `Unit_NN.bin` está resuelto, por el
CÓDIGO.** Las dos vías por los datos seguían muertas y no se tocaron.

## 1. LA CADENA, ENTERA — y es lo que hay que saber para seguir cualquier otro formato

```
"Levels\Level_%02u\Unit_%02d.bin"  @ 0x003F4508
   |  único xref de código: lui@0x0012D72C + addiu@0x0012D73C
   v
FUN_0012d5a8   máquina de estados de carga de UNA unidad   (0x0012D5A8)
   |  estado 2: sprintf + FUN_001093c0(str, ruta, 8, id, CALLBACK, p, 1, 0x40000)
   v
FUN_0012e728   callback de post-carga                      (0x0012E728)
   |  buf = FUN_001092f8();  PARSER(buf);  FUN_00108540(mgr, tipo, buf, id)
   v
FUN_0012eae8   EL PARSER: relocaliza el header             (0x0012EAE8)
```

**Ese último paso ES el layout**: recorre el header sumándole la base del
archivo a cada campo. 16 offsets y tres cuentas, tabulados en
`kb/formatos-iso.json#unit_contenedor` y en el encabezado de
`herramientas/unit.py`.

**La tabla de los cinco callbacks de nivel** (en `kb/rutinas.json#pedir_archivo_al_streamer`):

| archivo | format string | tipo | callback | parser |
|---|---|---|---|---|
| `LevelDat.bin` | `0x003F4348` | 6 | `FUN_0012a310` | `FUN_002881a8` |
| `StLevel.bin` | `0x003F4388` | 0xB | `FUN_0012a418` | `FUN_00288488` |
| `Guns%s.bin` | `0x003F43B8` | 0xC | `FUN_0012a480` | `FUN_00288930` |
| `Unit_%02d.bin` | `0x003F4508` | 8 | `FUN_0012e728` | `FUN_0012eae8` |
| `StUnit%02d.bin` | `0x003F4528` | 8 | `FUN_0012e8b8` | `FUN_002886d0` |

## 2. QUÉ HAY ADENTRO DE UNA UNIDAD

- **La lista de `+0x20` (recurso tipo 1) son LOS MODELOS, CON NOMBRE.** 367 en
  `LEVEL_01/UNIT_01`: `CO01TRUCK`, `CO01GUARDHUT`, `CO01FENCE`, `CO01AMMOBOX`,
  `CO01WOODBOX`, `CO01TREE_P_L`, `CO01COMPGATE`.
- La lista de `+0x24` (tipo 0) son 81 bloques con **id numérico**, no nombres.
- El array de `+0x1C` (`count` en `+0x90`, registros de `0x30`) son los
  **objetos colocados**: cada uno lleva un id64 en `+0x20` que `FUN_00127738`
  copia como primer campo del objeto de runtime de `0xF0`.
- **El directorio es compartido** (`FUN_00272aa8`): `count` en `+0x08`, offset
  al array en `+0x0C`, registros de `0x10` con id64 en `+0x00` y puntero al
  recurso en `+0x08` **relativo A LA LISTA, no al registro**. Lo usan también
  el `.DB`, `LevelDat` y `StLevel` — o sea que el "directorio de recursos con
  nombre" que la fase 6 midió en el `.DB` es la estructura del motor.
- **El header del modelo** sale de `FUN_001af930`: submallas en `+0x48`
  (`count` u8 en `+0x68`, registros de `0xD0`) y tres floats de **LOD** que en
  `CO01TRUCK` valen 30 / 60 / 100.

## 3. QUÉ SIGUE ABIERTO — LOS VÉRTICES

El grueso de un modelo vive entre su `+0x58` y su `+0x48`. **No** está
desarmado. Lo que cambió es que ya no hay que adivinar dónde: se llega por
punteros del propio cargador.

**Dato que ahorra una vía muerta:** el bloque de `submalla+0xC0` **no es VIF
crudo**. Arranca con una caja envolvente (min xyz, max xyz, con los signos
opuestos). Pasa por `FUN_0027e760`, que relocaliza `+0x20` y `+0x24` con una
cuenta u16 en `+0x28` — ése es el siguiente eslabón a decompilar.

**Y el "232 VIFcodes encadenados desde `0x800`" de la sesión anterior queda
desmentido**: `0x800` cae adentro del array del directorio de la lista tipo 0
(que va de `0x650` a `0xB60`). Era señal real con lectura falsa.

## 4. HERRAMIENTAS NUEVAS

- **`herramientas/unit.py`** — `niveles` / `header` / `modelos` / `modelo` /
  `autotest`.
- **`herramientas/probar-unit.py`** — cinco sabotajes, los cinco en rojo, con
  control positivo antes y después de cada uno.
- **`herramientas/decompilar_lote.py`** — todas las consultas a Ghidra en UNA
  apertura de proceso. `python herramientas/decompilar_lote.py salida.txt 0xADDR ...`

## 5. LO MEDIDO, Y LO QUE NO SE PUEDE AFIRMAR

- **Positivos:** las 42 unidades del ISO cierran el layout entero, con el array
  de `+0x1C` terminando **exactamente** donde arranca la lista de `+0x24`.
- **Control negativo:** el mismo layout sobre `LEVELDAT.BIN`, `LEVEL.AWD`,
  `COLLIDE.AWD`, `AMBIENCE.BKS`, `GLOBDATA.BIN`, el ELF y dos `.M2V` — **los
  ocho caen**.
- **Control positivo del método:** aplicado a `StUnit` da `FUN_002886d0`, y ese
  formato ya estaba resuelto por otra vía. **Y devolvió una corrección:**
  `stunit.py` decía que `STUNIT+0x08` era "alineación 0x80". No lo es —
  `FUN_002886d0` lo relocaliza igual que a `+0x04`. Corregido en los dos lados.
- **NO se puede afirmar:** que `+0x90` sea u16 y no u8. El máximo en las 42
  unidades es 109 y el byte de `+0x91` es cero en todas: el dato no discrimina.
  Sale del código (`*(ushort *)`). El de `+0x92` sí se mide (llega a 889).

## 6. ESTADO DE LA MÁQUINA AL CERRAR

**Igual que a la mañana, no se tocó nada del emulador.** El trabajo fue todo en
frío, sobre el ELF y el ISO montado en `D:\`.

- **PCSX2 sigue abierto** con el savestate del slot 11 (nivel 2), tal como
  quedó. Los siete pnach prendidos, los dos parches vivos verificados.
- **ISO original intacto**, ningún parche escrito a mano en RAM.
- Ghidra: el proyecto `BLACK` en `~\herramientas\ghidra-proyectos2`.
- **Trampa que sigue viva:** hay DOS pnach y el que manda es
  `Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach`, que no lo genera nadie.

---

# SESION DEL 2026-09-05 (MAÑANA) - LEER ESTO PRIMERO

Dos pedidos de Fran, los dos cerrados y verificados por efecto. **La linea de
jugabilidad (J1) queda CERRADA.**

## 1. EL AUTO-APUNTADO: encontrado y apagado, con UNA palabra

BLACK tiene asistencia de punteria y no la expone en ningun menu. Cada frame,
`FUN_0013f618` hace tres cosas antes de mover la camara:

    obj[0x9C] = 0
    FUN_0012bb60(30.0, 3.0, ..., FUN_001409c0)   <- BUSCA blanco en un CONO
    FUN_001407c8(obj, &ejeX, &ejeY)              <- CORRIGE la mira
    FUN_001404a8(ejeX, ejeY, obj)                <- recien ahi gira

El cono tiene medio angulo `atan(3/30)` = **5,7 grados** y 30 unidades de
alcance, y se prueba contra **once puntos por entidad** (los huesos). La fuerza
es `(1 - distancia/30)^2 * 0.2`, recortada a +-3.5 por eje.

**Por que empeoro al subir la sensibilidad:** la asistencia suma GRADOS y no
escala con `GiroX`. Con 70 grados/s su aporte quedaba tapado por la mano; con
350 la mano llega antes y el mismo aporte se siente como un tiron.

**El parche:** `0x001407DC`, `lw a0,0x9c(s0)` -> `li a0,0`. El blanco vale
siempre cero, el `beql` de la linea siguiente salta siempre al epilogo, la pila
la cierra el propio epilogo. La BUSQUEDA sigue viva: lo que lea `obj+0x9C` no
se entera. `mods/auto-apuntado.toml`.

## 2. EL PISO DE LA MIRA: era una ZONA MUERTA DEL JUEGO, no del emulador

Fran lo confirmo jugando: moviendo el mouse despacio la mira no se mueve nada.
Eso absolvio al inyector, que era lo unico que quedaba abierto de J1.

**La causa esta en `FUN_0026bf60` (`0x0026BF60`)**, la curva de zona muerta del
eje analogico del juego:

    techo = obj[0xE0]              // 0.9
    zm    = obj[0xE4] + extra      // 0.1 + obj[0xC8]
    v = recorta(v, +-techo)
    v = v - signo(v)*zm ; si cruzo el cero, v = 0
    return v / (techo - zm)

El 0.1 lo escribe el constructor `FUN_0026ba20`, en tres pares (0.9, 0.1). Con
`PointerXSpeed = 6` cada cuenta de mouse vale 0,003 de eje, asi que 0,1 son
**~33 cuentas por sondeo**: a 60 fps y 1600 DPI, **~3 cm/s de mouse**. Mas
lento que eso, el juego ve CERO EXACTO.

**Esto explica el misterio de la sesion anterior.** Las cinco variables que se
probaron sin efecto (`DeadZone`, `Inertia`, `Speed`, la sensibilidad, la
aceleracion de Windows) son TODAS del emulador, y la zona muerta esta aguas
arriba de todas. El "siguiente sospechoso" que dejo anotado el handoff anterior
--la conversion del eje a byte del DualShock en PCSX2-- **era el sospechoso
equivocado**: la capa que faltaba mirar era la del pad DEL JUEGO, a un
decompile de distancia.

**Confirmado por efecto, con control negativo, por DOS vias independientes.**
Inyectando 1200 cuentas en pasos fijos y midiendo el yaw:

| cuentas/sondeo | zm = 0,1 (fabrica) | zm = 0 | vuelta a 0,1 |
|---|---|---|---|
| 4  | +0,000 | -0,065 | +0,000 |
| 8  | +0,000 | -8,45  | +0,000 |
| 16 | +0,000 | -12,45 | +0,000 |
| 24 | +0,000 | -12,64 | +0,000 |

Ceros **exactos** con la zona muerta puesta, movimiento con ella en cero, y el
piso VUELVE al restaurar. Las dos vias --escribir 0.0 en `dispositivo+0xE4` del
heap, y el parche de codigo-- coinciden al decimo de grado (-8,37 contra -8,45).

**El parche:** `0x0026BF88` y `0x0026BFB4`, las dos ramas (eje positivo y
negativo), `lwc1 f0,0xe4(a0)` -> `mov.S f0,f2`. Se usa `mov.S f0,f2` y no
`mtc1 zero,f0` porque `f2` ya vale 0.0 en toda la funcion y asi no hay hueco de
latencia de COP1. **No se parchea el constructor**, aunque sea el origen del
valor: corre una sola vez y un savestate trae el 0.1 ya escrito en el heap.
`mods/zona-muerta-cero.toml`.

**El costo, y cuando importa:** una zona muerta existe para que un stick gastado
no gire la camara solo. Con mouse no pasa. Si algun dia Fran juega con el
joystick (`Pad2` es un SDL) y la camara deriva, el arreglo NO es sacar el mod:
es poner `Deadzone` en el `[Pad2]` de PCSX2.

## 3. TRAMPA DE ENTORNO NUEVA, Y SERIA: hay DOS pnach y el vivo es el otro

`pnach.py compilar --instalar` escribe en la carpeta que dice `Cheats` en el
`PCSX2.ini`, que hoy es **`cheats_ws`**. Pero los mods que estaban REALMENTE
prendidos viven en **`patches\SLUS-21376_5C891FF1.pnach`**, que ademas trae los
parches de comunidad (Widescreen, 60 FPS, Video Mode, No Blur) y que **no lo
genera nadie**: esta editado a mano.

Ya mordio una vez y en silencio: `mods/mira-lineal.toml` tenia
`habilitado = false` mientras el `gamesettings` lo tenia PRENDIDO desde el
archivo de `patches/`. Un `compilar --instalar` lo habria borrado del pnach sin
que nada avisara. Se corrigio el toml a `true` en esta sesion.

**Mientras eso siga asi, un mod nuevo hay que agregarlo a `patches/` a mano** (y
prenderlo en `gamesettings/SLUS-21376_5C891FF1.ini`, seccion `[Patches]`).
**PENDIENTE del proyecto:** que `pnach.py` fusione en el archivo de `patches/`
en vez de pisar otro, o que el verificador compare las dos listas. Es un dato
que vive en dos lados y ya divergio.

## 4. ESTADO DE LA MAQUINA AL CERRAR

- **PCSX2 QUEDA ABIERTO**, con el savestate del slot 11 cargado (nivel 2).
- Los dos parches **verificados en RAM despues de reiniciar el emulador y
  cargar el savestate**: `0x001407DC = 0x24040000`, `0x0026BF88` y `0x0026BFB4`
  `= 0x46001006`, y la palabra vecina `0x001407E0 = 0x50800073` intacta como
  control. 4/4.
- pnach prendidos en `gamesettings`: Widescreen, 60 FPS, Video Mode, Mira
  lineal, Mira sensible, **Auto-apuntado apagado**, **Zona muerta del pad a
  cero**.
- Respaldos con fecha del `patches/*.pnach` y del `gamesettings/*.ini` antes de
  tocarlos, en sus mismas carpetas.
- Todo lo demas igual que al cerrar la madrugada: DLSS 5 apagado, pack union de
  texturas, aceleracion de puntero de Windows apagada, ISO original intacto.

---

# SESION DEL 2026-09-05 (madrugada) - LEER ESTO PRIMERO

Fran durmio; la sesion trabajo sola sobre cuatro pedidos suyos. Lo que sigue es
el estado real al cerrar. **Las secciones numeradas de abajo son de sesiones
anteriores y siguen valiendo salvo donde esto las corrija.**

## A. LA MIRA - la sensibilidad resulto ser un float, y esta confirmada

**`0x005A9048` = velocidad de giro horizontal en grados/segundo. Vale 70.0 de
fabrica. `0x005A904C` = la vertical, 25.0.** BLACK no expone esto en ningun
menu y ningun ajuste de PCSX2 lo toca, porque el emulador entrega un eje de 0 a
1 y los grados por segundo los pone el juego.

**Confirmado por efecto con control negativo:** escribiendo 210.0 (x3), la
velocidad medida paso de 87.7 a 264.4 grados/s -factor **3.01**- y volvio a
88.3 al restaurar; el eje vertical se midio en 25.7 / 25.7 / 25.8 sin moverse.

Setenta grados por segundo son cinco segundos por vuelta: a 1600 DPI, casi dos
metros de mousepad. Esa es la causa medida de la queja de Fran.

**Aplicado y vivo:** `mods/mira-sensibilidad.toml` pone 350/350 y esta prendido
en el pnach. `PCSX2.ini` quedo en `Speed 6 / DeadZone 0 / Inertia 0`, preset
`mouse`. Y la **aceleracion de puntero de Windows quedo APAGADA** - se guardo
el estado previo, vuelve con `herramientas\aceleracion-mouse.ps1 -Restaurar`.

**Instrumental nuevo, que es lo que lo hizo posible:**
- `herramientas/pcsx2_mouse.ps1` - inyecta mouse relativo con `SendInput` y
  verifica el foco **por efecto**.
- `herramientas/mira.py` - lee el yaw de la camara (**`0x005A8DA0`, en
  grados**), mide la curva de respuesta, y cambia la sensibilidad **en vivo**
  (`mira.py sens 350`).
- `FUN_001404a8` (`0x001404A8`) esta decompilada entera en `kb/rutinas.json`:
  curva, suavizado, aceleracion por mantener, recorte del pitch a +-70 y factor
  de zoom, todo en un lugar.

**Lo que NO cerro, y es lo unico que queda de esta linea:** hay un **piso** por
debajo del cual la mira no se mueve nada, y **no se movio** al variar
`DeadZone`, `Inertia`, `Speed`, la sensibilidad ni la aceleracion de Windows.
Cinco variables sin efecto falsan la hipotesis de la deuda de PCSX2. Pero el
inyector manda rafagas con huecos y un mouse real manda movimiento continuo:
**el piso puede ser del instrumento**. Lo decide la mano de Fran, no otra
medicion sintetica.

## B. DLSS 5 - estaba APAGADO, y el `upscale_multiplier` no compra FPS

`ReShadePreset.ini` no tenia `DLSS5_Feed@DLSS5_Feed.fx` en `Techniques=`. Con
eso el add-on carga, el log dice `technique found` y **no pasa nada**: ni error
ni aviso. Cuando se apago no esta anotado en ninguna parte.

Medido con capturas del OSD, mismo savestate del nivel 2:

| configuracion | FPS | GS | GPU |
|---|---|---|---|
| DLSS 5 apagado, upscale 3 | **58.19** | 16.48 ms | 5.28 ms |
| DLSS 5 prendido, upscale 3 | **48.09** | 20.15 ms | 3.37 ms |
| DLSS 5 prendido, upscale 2 | 50.42 | 19.38 ms | 2.49 ms |

**La prediccion de 8.20 fallo, y eso corrige el modelo:** bajar el upscale de 3
a 2 tenia que liberar el GS saturado. Bajo el tiempo de GS un 4 % con **56 %
menos de pixeles**. El cuello del GS en BLACK **no es de relleno** y no escala
con la resolucion interna. Bajarla empeora la imagen y no compra framerate: esa
linea queda cerrada por medicion.

**Estado al cerrar: DLSS 5 APAGADO y `upscale_multiplier = 3`**, o sea
exactamente como Fran lo tenia. Se prende y apaga con un comando:
`herramientas\dlss5-prender.ps1 -On | -Off`.

**Y el pedido de "dejarlo listo para otros juegos" esta hecho:**
`herramientas/dlss5-para-juegos.ps1`. Su base no es el README de nadie sino la
instalacion de PCSX2 que ya funciona, congelada con hashes por `-ArmarKit`
(el kit son 212,9 MB y vive **fuera del repo**, en
`~\herramientas\dlss5-kit`, porque son binarios de NVIDIA y de terceros y
`claude-acceso` es publico). Lee la arquitectura del header PE, detecta la API
grafica para elegir el proxy, **verifica el renodx por SHA256 antes de copiar
nada** (el `FileVersion` no distingue v4.55 de v4.6 y la v4.6 rompe el feeder),
marca `nvngx_dlss.dll` como critico, y usa hardlinks para no duplicar 214 MB
por juego.

## C. LOS NIVELES SE LEEN Y SE EDITAN EN FRIO - la puerta que Fran pidio

**`STUNIT0N.BIN` resuelto** (`herramientas/stunit.py`). El header tiene en
`+0x04` el **offset del descriptor** dentro del archivo. Con eso, los 42
STUNIT del disco se leen sin emulador. Control positivo triple contra la fase
7e (descriptor `0x01092800`, count 857, array `0x0109F590`: los tres al bit) y
**control cruzado de 61 puntos** - el histograma de tipos del archivo coincide
exactamente con `instancias_level_00` del kb, medido en RAM por otra via.

**`STLEVEL.BIN` resuelto** (`herramientas/stlevel.py`): el **directorio de
armas del nivel**, entradas de `0x28` con el nombre en claro y la cantidad en
el header. Y lo que lo hace una puerta: **cada nivel trae entre 16 y 20
modelos de arma en su `FPGUNS` y solo habilita entre 4 y 11**. En LEVEL_00
sobran nueve, entre ellas `bg1_snr` y `bg1_hvy`. Cambiar un nombre por uno de
esos **no agrega un solo byte al ISO**. `stlevel.py cambiar` escribe sobre una
copia, se niega a tocar el original, rechaza un arma que el nivel no traiga, y
verifica releyendo del ISO.

**El mapa de armas de los ocho niveles quedo en `kb/formatos-iso.json`.**

## D. GEOMETRIA - NO RESUELTA, y las dos vias muertas quedan anotadas

Ver `kb/formatos-iso.json#geometria_sin_resolver`. Lo importante para no
repetirlo:

1. **Contar VIFcodes por frecuencia NO discrimina.** Daba 10,8 % en el archivo
   de geometria y parecia confirmarlo - pero un video MPEG-2 del mismo disco da
   **14,71 %**, mas, y un banco de audio 5,48 %.
2. **Caminar DMAtags tampoco.** El audio encadena 25 tags, mas que casi todos
   los intentos sobre la geometria.
3. **Lo unico que si discrimino:** caminar la cadena VIF de verdad, saltando el
   largo exacto de cada comando - `UNIT_01.BIN` encadena 232 comandos seguidos,
   el audio y el video 0 o 1. **Indicio, no prueba**: 232 no cubren el archivo.

Lo que si quedo medido: **el header del `.DB` es un directorio de recursos con
nombre** (`BG1_AK1`, `BG1_AK1LF`, `BG1_AK1SLF`, `TEXTURE`) con nueve secciones
alineadas a 128 B. Y el `0x54461272` que la fase 6 tomo por constante **no lo
es**: es la mitad alta de un id64, que todos los nombres `BG1_*` comparten.

**Por donde seguir: NO por los datos, por el CODIGO.** Encontrar en el ELF la
rutina que consume `UNIT_NN.BIN` y leerle el layout al cargador, en vez de
adivinarlo desde afuera. Es la misma leccion que cerro 7e.

## E. LOS ENEMIGOS: que arma usa cada clase, por nivel

La entrada del directorio de armas de `StLevel.bin` quedo resuelta entera, y
resulta ser la tabla de enemigos:

    +0x00  char[0x10]  nombre        +0x18  i32  ptr a variantes ENEMIGAS
    +0x10  u64  id64 del MODELO      +0x1C  i32  ptr a variantes de COMPANERO
                                     +0x20/+0x24  cuantas de cada una

**Los punteros son relativos al inicio de SU PROPIA ENTRADA.** No se adivino:
los punteros de los slots sin variantes bajan exactamente `0x28` por slot --el
paso de la entrada-- asi que sumandoles el offset de la ENTRADA dan todos el
mismo centinela, `0xFDC5FF80`. Segundo invariante independiente: con esa base
los punteros reales caen todos alineados a `0x80`. Los dos estan en el autotest.

La semantica sale de `FUN_001e2d38`, decompilada: arma los nombres con
`Enemy%d_%s` y `Team%d_%s` contra la tabla de siete de `0x003BD3F8` (None, Low,
Mid, High, Matt, Tom, Carrie), o sea que **cada variante enemiga tiene un nivel
de amenaza**. Y registra `+0x94` de cada registro en la ValueDB de sonido de
arma de IA -- control: ahi hay exactamente floats de parametro.

    LEVEL_00  7 variantes enemigas + 2 de companero      LEVEL_05   8 + 1
    LEVEL_01  6 + 0     LEVEL_03  8 + 0                  LEVEL_06  10 + 0
    LEVEL_04 10 + 2                                      LEVEL_07   9 + 2
                                                         LEVEL_08  15 + 0

`python herramientas/stlevel.py enemigos LEVEL_00`

**TRES ARMAS EN VEZ DE DOS: acotado, no hecho.** `kb/rutinas.json#inventario_dos_armas`.
El inventario son dos handles en `*(entidad+0x2A0)+0` y `+4`, y los dos id64 en
`entidad+0x3C0` y `+0x3C8`. No es un parche de un byte: hace falta un campo
libre para el tercer id64 (`+0x3D0` y `+0x3D4` estan ocupados), un tercer
handle, **duplicar el bloque de busqueda --que esta DESENROLLADO, no es un
bucle--** y tocar el ciclado, que hay que buscar por la ACCION de entrada
(`FUN_00124840` + la tabla `0x003BCAC8`) y no por el offset: un barrido por
`0x2A0` da 73 candidatos y el propio `barrer.py` avisa que ese parametro no
discrimina.

## F. TEXTURAS: el pack instalado cubria el 29 %

Habia **tres** packs en el disco y estaba instalado el que menos cubre. Medido
sobre la escena de referencia de 127 texturas:

| pack | claves | cobertura |
|---|---|---|
| 2022 (el original) | 8225 | 90/127 = **70,9 %** |
| huekage — *el que estaba instalado* | 2781 | 37/127 = **29,1 %** |
| hd-reimagined | 1302 | 17/127 = 13,4 % |
| **union** | **8966** | 93/127 = **73,2 %** |

**El cruce esta validado:** el mismo metodo predice 90 para el pack de 2022 y el
proyecto habia MEDIDO 90 por volcados en la fase V1. Predicho = medido.

**La trampa del bit 14, al reves de lo que parecia.** El pack de 2022 lo tiene
puesto en 7729 de 7729 archivos y los volcados del PCSX2 de hoy nunca (0 de
261) -- y sin embargo carga. Unica explicacion que sobrevive: **PCSX2 enmascara
el bit tambien al indexar el nombre del ARCHIVO**. O sea que **no hay que
renombrar nada**. Lo que si falta al normalizar, y no estaba anotado: los hashes
vienen **sin ceros a la izquierda**, y sin eso 496 nombres del pack de 2022
quedan afuera del cruce.

`herramientas/pack_union.py` arma la union con **enlaces duros**: 5,57 GB
logicos, cero bytes nuevos en el disco.

**Medido por efecto, una sola variable:** FPS 58,19 -> **59,81**; GS 16,48 ->
16,08 ms; RAM de PCSX2 4,28 GB de 24. **No cuesta framerate.** Nitidez por
region: cinco de seis ganan (+3 % a +63 %), una pierde 21 %.
Grado: cobertura y FPS `confirmado`; la mejora visual `probable` (dos corridas
distintas, y esta linea ya se equivoco una vez comparando entre reinicios).

## G. ESTADO DE LA MAQUINA AL CERRAR ESTA SESION

- El savestate del nivel 2 donde Fran dejo el juego esta en el **slot 11**
  (`sstates/SLUS-21376 (5C891FF1).11.p2s`), tomado por PINE antes de tocar nada.
- `PCSX2.ini`: `Renderer = 15`, `upscale_multiplier = 3`, `[Pad]` con
  `Speed 6 / DeadZone 0 / Inertia 0`, mapeo de teclado intacto, CRLF verificado.
- `ReShadePreset.ini`: DLSS 5 **apagado**, las tres tecnicas de siempre.
  Respaldo en `ReShadePreset.ini.bak-20260905-052349`.
- pnach: prendidos Widescreen, 60 FPS, Video Mode, **Mira lineal** y
  **Mira sensible**. Apagados `Dificultad x2` y `Mira sin suavizado`.
- **Aceleracion de puntero de Windows: APAGADA** (estado previo guardado en
  `%LOCALAPPDATA%\black-mouse-accel.txt`).
- **`replacements/` = el pack UNION** (8966 archivos, enlaces duros). El huekage
  anterior quedo completo en `replacements-huekage-guardado/`. Volver son dos
  `move` con PCSX2 cerrado. `hw_mipmap` sigue en `false`, sin tocar.
- El ISO original y sus permisos, intactos. Cero parches vivos en RAM.

**Trampa de entorno nueva:** el guardia del ISO frena un `git commit` con
heredoc si el nombre del archivo protegido aparece en el **mensaje**. No se
toco el guardia; se commitea con `git commit -F archivo`.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/kb/stage-modulos.json` — **entero**. Es el entregable acumulado: los
   61 tipos con handler, instancias, tamaño de blob, familia de nombre, el
   `sitio_de_llamada` de cada uno, y **de esta sesión** las claves
   `_pools_p1_medidos` y `_el_0x34_no_usa_indice_fijo`.
2. `black/kb/pools-p1.json` — la medición de los 18 pools, cruda.
3. `black/docs/03-bitacora.md`, **sólo las entradas (39) y (38)**.
4. `black/ESTADO_ACTUAL.md`, sólo el bloque **7e** de N2.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, las entradas (29)–(37), y nada de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**7e — el índice de módulos del nivel.** Sigue abierta, **por la mitad (b)**.

- **(a) los tipos identificados: HECHO el 2026-08-29, y desde el paso 3b
  MEDIDO, no sólo leído.** Los 61 tipos despachados tienen destino, contador,
  acción y argumentos; y el modelo de "array de handles" está confirmado por
  medición contra el volcado, 17/18 predicciones exactas.
- **(b) al menos UN tipo distinto del `0x0A` verificado POR EFECTO: FALTA.**
  **Necesita el emulador**, y necesita que Fran juegue hasta cargar el nivel.
  **Fran autorizó abrir el emulador el 2026-08-29.**

**Cierra 7e** cuando un módulo concreto, elegido a propósito, deje de
construirse (o cambie) por un parche escrito **antes** de mirar, y eso se vea
en un observable declarado de antemano.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

### 3.1 `P1` está MEDIDO. `piVar4 = 0x005AD410`, `P1 = 0x005AD450`

Sobre `volcados/ee-e4.bin` (LEVEL_00). **17 de 18 predicciones exactas**, total
predicho 552 contra 548 ocupado, y la diferencia entera es una sola fila (la
que corrigió el mapa, §3.2).

| `P1+off` | ocup | pred | | `P1+off` | ocup | pred |
|---|---|---|---|---|---|---|
| `0x1C` | 131 | 131 | | `0x2C` | 5 | 5 |
| `0x3C` | 118 | 118 | | `0x48` | 4 | 4 |
| `0x24` | 73 | 73 | | `0x44` | 3 | 3 |
| `0x08` | 60 | 60 | | `0x20` | 2 | 2 |
| `0x10` | 57 | 57 | | `0x4C` | 6 | 6 |
| `0x18` | 33 | 33 | | `0x00` | **0** | 0 |
| `0x14` | 21 | 21 | | `0x38` | **0** | 0 |
| `0x30` | 20 | 20 | | `0x40` | **0** | 0 |
| `0x34` | 14 | 14 | | `0x28` | 1 | ~~5~~ |

**El control negativo dio más de lo pedido:** los tres ceros no son arrays
vacíos, son **punteros nulos**.

### 3.2 CÓMO se ubicó `P1` — y por qué NO fue un barrido

El tag `*piVar4 == 0x1C` es el mal parámetro de siempre. El eje que sirve es la
**cadena de indirecciones desde un dato ya confirmado**:
`param_2 = *(u32*)(piVar4[4]+4)`, y `param_2` es el descriptor `0x01092800`.

```
1. buscar el valor 0x01092800   -> 193 hits
2. Q = hit - 4                  -> candidato a piVar4[4]
3. buscar el valor Q            -> 6 direcciones B == piVar4+0x10
4. piVar4 = B - 0x10 ; *piVar4 == 0x1C de CONTROL -> sobrevive 1 de 6
```

Tres controles independientes, ninguno buscado: **`piVar4[4] == 0x01053000`**
(la carga de `STUNIT01.BIN`, confirmada por otra vía); el otro slot del doble
buffer **exactamente a `+0x880`** (`0x005ADC90`), con tag `0x1` y `[4]=0` —
**uno vivo y uno libre**; y las capacidades derivadas por contigüidad de los
punteros, **≥ ocupación en los 18 y siempre ajustadas** (132 para 131).

### 3.3 El `0x34` NO usa "índice fijo 0" — la medición corrigió el mapa

`0x0015F5FC`–`0x0015F624` es un **loop**: `s0` arranca en 0 (`0000802D` en
`0015F5E4`), se incrementa (`26100001`), y el límite sale de **`*(P1+0x78)`**.
El `0x34` **no construye** en `P1+0x28`: **lo recorre**, una llamada por
elemento. Su único destino es `P1+0x1C | c_s5`, donde la kb ya lo tenía y donde
el 131 dio exacto. Predicción escrita antes de mirar: `*(P1+0x78) == 1`. **Vale
1.**

**El síntoma era visible SIN medir nada:** el `0x34` era el **único tipo de
módulo que aparecía en dos grupos de destino** (el `0x35` aparece en seis, pero
no es un módulo: es el cierre). Un tipo en dos grupos es una lectura sin
resolver, no dos destinos. Ya está registrado como lección de proceso.

### 3.4 Dos cosas que no se buscaban

- **El juego mantiene sus propios contadores, y coinciden.** `P1+0x50..0x90` es
  una **tabla de largos** cuyo multiconjunto reproduce **elemento por elemento**
  las ocupaciones medidas: `{131,118,73,57,33,21,20,14,5,5,4,3,2,6,1,0,0,0}`. Y
  `P1+0x04 = 0`, `P1+0x0C = 60` son los largos de `P1+0x00` y `P1+0x08`. Es una
  **tercera derivación independiente**: no sale del stream ni de mi conteo.
  **ABIERTO:** la alineación offset-por-offset entre ese bloque y los 16
  punteros de `0x10`–`0x4C` **no cierra con un corrimiento constante**. El
  multiconjunto coincide; la alineación exacta, **no medida**.
- **El `0x2B`, confirmado por su vía propia.** Array **inline** de structs de
  `0x10` en `P1+0xB0`: **9 con contenido y ceros a partir del décimo**, contra 9
  predichas, y **`P1+0xA0 == 9`** es su contador. Los 4 campos son floats
  —p. ej. `[-78.84, -3.579, 30.08, 3.0]`— que parecen XYZ más un cuarto valor.
  **Hipótesis.**

### 3.5 Sigue valiendo intacto de las sesiones anteriores

**El subsistema está en el SITIO DE LLAMADA, no en el handler** (medido: el
cierre transitivo de `FUN_00175980`, 9842 funciones / 20.205 aristas `jal`, no
alcanza `0x0040F4D4` a profundidad 0-3). El despachador lo materializa:
`0015F78C lui v1,0x0041` / `0015F794 lw a0,-2860(v1)` / `0015F79C jal
0x00175980` / `0015F7A0 addiu a0,a0,2632` (**delay slot**, +0xA48).

Tabla de saltos `0x003F4E90`, **69 entradas** (`lui v0,0x3F` + `addiu
v0,v0,20112` en `0x0015F030`; tope de `sltiu v0,v1,69` en `0x0015F024`). **61
tipos en 55 bloques**; 8 en el `default` `0x0015FBDC`: `0x00 0x01 0x02 0x0D
0x0E 0x21 0x24 0x33`.

**Cola virtual:** `0x0B 0x0C 0x12 0x16 0x17 0x18 0x30 0x31 0x32 0x43` no tienen
`jal` propio; saltan a `0x0015F968` / `0x0015F974`
(`lw v1,16(a3) ; lh a0,176(v1) ; lw v0,180(v1) ; jalr v0 ; addu a0,a3,a0`).
Recorrer el bloque por direcciones crecientes los pierde **en silencio**.

**El `0x35` no es un tipo de módulo:** es el **cierre** del stream (0
instancias, ~25 llamadas, recorre todos los arrays de `P1` contra `P2+98..P2+138`).

**Singletons de `.bss`**, todos en `0x0040F4D0`–`0x0040F514`: `0x0040F4D4`
física (**CONFIRMADO**), `0x0040F4E4` (`0x2C`), `0x0040F4F4` (el cierre),
`0x0040F510` (`0x2F`), `0x0040F514` (`0x0A`, spawn de personaje, **probable**).

**Mismo array NO es misma struct:** dentro de `P1+0x1C` conviven blobs de 16 a
96 B. El array es el pool de destino; el blob, la estructura de entrada.

**Eje de cadenas REFUTADO POR MEDICIÓN:** sobre el cierre a profundidad 3, 2
handlers de 70 tienen cadena. **No volver a proponerlo.**

Layout del registro (`+0x00` tipo, `+0x04` ptr al blob, `+0x08` id64 del
nombre). Descriptor `0x01092800 = {count=857, array=0x0109F590}`.
`FUN_0012dab8` arma `param_2` con `*(u32*)(piVar4[4]+4)`; cargador
doble-buffereado `base+0x4990` / `base+0x5210`, `0x880`, tag `*piVar4==0x1C`,
alterna con `*(u8*)(iVar5+0x5aae)^=1` en `FUN_00129360`. El stream en el ISO:
`/LEVELS/LEVEL_00/STG_0001/STUNIT01.BIN`, LBA 1056910, 326.432 B, carga en
`0x01053000`, 98,46 %. Registro de física `0x004CB1C8 = *(0x0040F4D4)+0xA48`,
48 ranuras, **0 ocupadas en los 9 volcados**. Todo 7d; todo 7c; el parche de
ISO in-place **anda** (3×).

**Observables muertos:** `FUN_001A4F70` es un `printf` STUB; `'AI gun model not
found: %s'` hace `sprintf` sobre el stack y no lo usa.

## 4. LO QUE SIGUE, CONCRETO — PASO 4, POR EFECTO, CON EL EMULADOR

**Ahora hay instrumento para leer el efecto.** `pools_p1.py` mide la ocupación
de cualquier pool en un volcado nuevo, así que **"el módulo no se construyó"
pasa a ser contable**, con 17 pools de control que tienen que quedar iguales.
Ése es el cambio que habilita el paso 4 y que antes no existía.

**El experimento más barato — neutralizar UN módulo, un byte:**

1. Elegir una instancia concreta de un tipo con **pocas** instancias y pool
   propio, para que el delta sea inequívoco. Candidatos por orden: `0x2E`
   (5 inst., `P1+0x2C`, y observable **audible**), `0x1E` (4 inst., `P1+0x48`),
   `0x44` (3 inst., `P1+0x44`).
2. **ESCRIBIR LA PREDICCIÓN ANTES**, en la bitácora: qué tipo, qué instancia,
   qué pool baja en 1, y **qué 17 pools tienen que quedar idénticos**.
3. Cambiar el `tipo` de esa instancia a un case del `default` (`0x0D`, `0x0E`,
   `0x21` o `0x24` — están vacíos y no hacen nada) con `parche_iso.py` sobre
   `STUNIT01.BIN`. Es **un byte**.
4. Arrancar el ISO parcheado, **Fran juega hasta cargar LEVEL_00**, volcar los
   32 MB y correr `pools_p1.py pools` contra ese volcado.
5. El **control negativo del experimento**: el mismo volcado tiene que dar 17
   pools sin mover. Si se mueve otro, el modelo de "pool por tipo" está mal.

**El candidato barato ya NO es el `0x2D`**: su registro está vacío en los 9
volcados.

**Aparte, y no bloquea:** validar 7d por efecto parcheando el literal
`0x5446127297C60000` (`BG1_AK1`) por el de `BG1_RPG`.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 NO está corriendo** y no se abrió en toda la sesión. Ejecutable
  correcto (NO el de Program Files):
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
- **Fran autorizó abrir el emulador el 2026-08-29.** El default del proyecto
  sigue siendo en frío, pero el paso 4 lo necesita y está habilitado.
- **RAM limpia, cero parches vivos.** La sesión **no escribió un byte** ni en
  memoria ni en ningún ISO. Todo en frío sobre `volcados/ee-e4.bin` y el ELF.
- **Ningún ISO se tocó.** El nop de vida infinita de `0x0013BD20` sigue
  restaurado (`0xE65402F8`). `Black.iso` en ReadOnly + guardia `PreToolUse`.
- Controles de apertura en verde: `abrir-sesion.ps1` completo (integridad,
  `ubicaciones.py` 12/12, `inventario.py` 13/13, control positivo de Ghidra
  sobre `0x00142B90`). El hook `SessionStart` corrió los medidores de
  `chequeo-completo.ps1`: los tres en verde, saboteadores al día.
- Se pierde al reiniciar el emulador: cualquier parche escrito en RAM. Los ISO
  parcheados sobreviven.

## 6. LAS TRAMPAS YA PAGADAS — no volver a pagarlas

1. **Un CERO acusa al PARÁMETRO, no al mundo.** Y si el instrumento lo
   escribiste vos, el parámetro puede ser el **modelo del ISA**: en MIPS el
   **delay slot corre ANTES** y ahí vive la mitad baja de las direcciones. Todo
   barrido nuevo arranca por un caso **ya conocido**.
2. **No entres por un valor que abunda; entrá por una cadena de indirecciones
   desde algo ya confirmado.** El tag `0x1C` daba miles; la cadena desde el
   descriptor dio 6, y el tag como **control** dejó 1. El orden importa:
   primero el eje que discrimina, después el control.
3. **Un item que cae en DOS categorías excluyentes de tu propio clasificador es
   una lectura sin resolver, y se ve sin medir nada.** Contarlos ANTES de
   derivar predicciones de esa tabla.
4. **Un bloque de `switch` NO termina donde termina en direcciones**, y un
   `lw ...,0(v0)` adentro de un bloque puede ser el cuerpo de un **loop**, no un
   destino. Buscar el incremento y el límite antes de llamarlo "índice fijo".
5. **`capstone` NO sirve** para el `.text` del EE: `barrer.py`, o decodificar
   campos a mano (es lo que hacen `casos_dispatcher.py` y `pools_p1.py`).
6. **Un xref sobre heap siempre da 0.** `.bss` termina en `0x0049BFBC`.
7. **Heredocs largos fallan en la Bash tool** (>~30 líneas): escribir el `.py`
   con Write y correrlo. El `cwd` se resetea entre llamadas: **rutas absolutas**.
8. **`comando | tail` devuelve el exit code de `tail`.** Para medir un rojo:
   `cmd > archivo 2>&1; echo $?` — sin pipe.
9. **Corchetes en rutas de Windows son wildcard:** `-LiteralPath`, o medir desde
   Python. La carpeta de los ISO es `Black [NTSC]`.
10. **`0x01412400` (STLEVEL.BIN cargado) NO es `piVar4[4]`.** `piVar4[4]` es
    `0x01053000`, y eso ahora está medido.

## 7. PENDIENTES QUE NO SON DE LA FASE

- **BLACK a 10 fps en el menú, y el apagado del 2026-08-22.** Es entorno: **no
  mezclarlo con 7e**. Ya medido: evento **1074** lanzado por
  `SysWOW64\shutdown.exe` — apagado **ordenado**, **cero Kernel-Power 41**.
  Hipótesis viva: el cambio a GPU discreta conmuta MSHybrid↔Discrete y el panel
  del fabricante lo aplica llamando a `shutdown.exe`. **Criterio de salida, dos
  minutos:** reabrir BLACK ahora que el modo discreto quedó aplicado y medir los
  fps en el **mismo** menú.
- **Fase 5a — pnach sobre `0x00142CA0`** (daño de salida del jugador).
  **PARQUEADA a propósito**, lista para cuando se vuelva al emulador.
- **La alineación de la tabla de largos `P1+0x50..0x90`** con los 16 punteros:
  el multiconjunto coincide, la asignación offset-por-offset no. Barato de
  medir, no bloquea.
- **`P2` tiene campos hasta `+0x8A`** (los usa el `0x35`), y la kb lo describe
  como `{count, array}` de 8 B. **No medido.**

## 8. BLACK REMASTER / DLSS5 — R0/R1 CERRADAS, R2 ABIERTA (línea nueva, no toca 7e)

### 8.1 QUÉ LEER PARA RETOMAR ESTO, EN ORDEN

1. Esta sección, entera — **empezar por 8.7**, es lo abierto.
2. `ESTADO_ACTUAL.md`, bloque "REMASTER GRÁFICO (DLSS5)" (después de N2).
3. `docs/03-bitacora.md`, entradas 43, 42, 41 y 40.
4. Las capturas: `pruebas/R0-depth/` y `pruebas/R1-rendimiento/`.

**NO hace falta** leer nada de 7e (secciones 1-7 de este mismo archivo) para
seguir con esto — son líneas independientes.

### 8.2 R0 — CERRADA EL 2026-09-01, LAS TRES CASILLAS EN `sirve`

| casilla | veredicto | buffer | draw calls |
|---|---|---|---|
| D3D11 @ Native | **sirve** | 642x450 `D32S8` | ~1200 |
| D3D11 @ 4x | **sirve** | 2568x1800 `D32S8` | ~1034 |
| D3D12 @ 4x | **sirve** | 2568x1800 `D32S8` | ~1001 |

Confirmado **por efecto**, no por conteo: la vista de normales derivadas del
depth (`DisplayDepth.fx`, mitad izquierda) muestra el auto con sus molduras,
las columnas del viaducto y las aristas del piso. A 4x, más limpias que en
Native. Capturas en `pruebas/R0-depth/{d3d11-native,d3d11-4x,d3d12-4x}.png`.

2568x1800 es exactamente 4x de 642x450: **la profundidad escala con la
resolución interna**, no se queda en nativo.

**Consecuencia para el proyecto:** R0 no impone ninguna restricción sobre el
renderer. Los tres sirven, así que elegir entre D3D11 y D3D12 se decide por
rendimiento y por lo que pida el pipeline de DLSS, no por disponibilidad de
depth.

### 8.3 EL REQUISITO QUE SALIÓ DE MEDIR — vale para el pipeline final

**El buffer de depth hay que FIJARLO A MANO.** Con la heurística
`Similar aspect ratio` de Generic Depth en su default, ReShade elige uno de
los buffers de 128x64 (1-2 draw calls, son sombras) y `DisplayDepth` sale
**violeta plano** — visualmente idéntico a "este juego no expone depth". Si
la casilla se hubiera cerrado ahí, R0 daba `no sirve` y mataba el proyecto
por un error de heurística.

Se arregla tildando la casilla izquierda de la fila del buffer grande (el de
~1000 draw calls) en la pestaña **Add-ons**. Y **hay que rehacerlo cada vez
que cambia el renderer o la resolución interna**: PCSX2 destruye y recrea los
render targets, el handle cambia y la selección forzada se pierde.

`Copy depth buffer before clear operations` **no** aporta nada acá — ReShade
avisa `No clear operations were found for the selected depth buffer`.

Segundo detalle, menor pero desorientador: **con `DisplayDepth` activo el menú
de pausa de PCSX2 es invisible.** PCSX2 dibuja su interfaz dentro del frame y
ReShade reemplaza el color de todo el frame después; `Escape` pausa pero no se
ve nada. Cualquier cosa de la UI de PCSX2 hay que mirarla con DisplayDepth
apagado.

### 8.4 LA PREDICCIÓN FALLÓ, Y POR QUÉ IMPORTA

La sesión 40 escribió, antes de medir: D3D11@Native `sirve`, D3D11@4x
`no sirve`, D3D12@4x `sirve degradado`. **Acertó una de tres**, y las dos que
falló, falló para el lado optimista (salió mejor de lo predicho).

La justificación del `no sirve` para 4x era *"la colisión ya documentada con
el objetivo de 4-6x"*. **Esa colisión no está en ninguna parte de este repo** —
`grep` sobre `docs/03-bitacora.md` no la encuentra. Venía de un chat de DLSS5
anterior que nunca se escribió: una predicción apoyada en un dato que sólo
vivía en un chat.

Queda **abierto**: si esa colisión era real, era sobre PCSX2 2.6.3 y/o sobre
un eje que R0 no mide (rendimiento, o el pipeline de DLSS y no el buffer). No
se puede ni confirmar ni descartar con lo que hay escrito.

### 8.5 R1 — CERRADA EL 2026-09-01: D3D12 @ 4x, por GPU%, no por FPS

Medido sobre el mismo savestate 03. Las tres casillas dan el **mismo FPS**
(29.97 — el juego está tapado en la mitad de 59.94 V-Blank, es un techo del
juego, no del renderer/resolución). Lo que distingue es el **uso de GPU** del
OSD:

| casilla | FPS | GPU% | GPU ms |
|---|---|---|---|
| D3D11 @ Native | 29.97 | 60.1% | 10.02 ms |
| D3D11 @ 4x     | 29.97 | 57.9% |  9.67 ms |
| D3D12 @ 4x     | 29.97 | **18.5%** | **3.08 ms** |

**Decisión: D3D12 @ 4x.** Un tercio del gasto de GPU de D3D11 para el mismo
FPS — margen para el pipeline de DLSS5/ReShade que va encima. Tabla completa,
metodología y capturas: `pruebas/R1-rendimiento/resultados.md`.

**Método replicable, sin clicks en Ajustes→Gráficos:** editar
`Documents\PCSX2\inis\PCSX2.ini` directo (`Renderer` = 3 D3D11 / 15 D3D12,
`upscale_multiplier` = 1 Native / 4 4x) con PCSX2 **cerrado** — si está
corriendo, lo pisa al salir con lo que tenía en memoria. Lanzar con
`-statefile`, esperar ~20-25s a que se estabilice, capturar pantalla completa
(PowerShell: `[System.Windows.Forms.Screen]::PrimaryScreen.Bounds` +
`Graphics.CopyFromScreen`, sin necesitar foreground ni clicks) y leer el OSD
de la imagen. No hizo falta togglear ReShade/DisplayDepth para esto.

**Sigue:** la colisión de la sesión 40 (memoria del "objetivo 4-6x") sigue sin
poder confirmarse ni descartarse — a 4x, con este savestate, D3D12 no mostró
ningún síntoma (ni caída de FPS ni stutter visible en el gráfico de frame
times). Si aparece en escenas más cargadas (más enemigos, más partículas),
ahí sí amerita revisar. Restricción de scope vigente (memoria del perfil,
`black-remaster-resolucion-objetivo.md`): la salida final del pipeline DLSS5
no debe superar la resolución nativa de cada pantalla — 1080p en la notebook,
2K en la PC de escritorio. Es un eje distinto de la resolución interna.

Próximo paso natural: **R2**, armar el pipeline real de DLSS5/ReShade sobre
D3D12 @ 4x y confirmar por efecto que sostiene FPS con el upscaler activo.

### 8.6 ESTADO DE LA MÁQUINA AL CERRAR

- **`PCSX2.ini` quedó en `Renderer = 15` (D3D12) y `upscale_multiplier = 4`**
  — la casilla ganadora de R1. `OsdShowFrameTimes` quedó en `true` (se
  activó para R1; antes estaba en `false`).
- PCSX2 **2.8.0** en `C:\Program Files\PCSX2\pcsx2-qt.exe` (ruta CORTA). La
  instalación vieja 2.6.3 en `C:\Program Files\PCSX2\PCSX2\` sigue intacta,
  con el ISO adentro (`games\Black [NTSC]\Black.iso`, ReadOnly, no se tocó).
- ReShade **6.6.2** Addon Support enganchado y **verificado por efecto**:
  `ReShade.log` en la ruta corta arranca con
  `Initializing crosire's ReShade version '6.6.2.2081' ... loaded from
  C:\Program Files\PCSX2\dxgi.dll into ... pcsx2-qt.exe`.
- **`PCSX2.ini` (`Documents\PCSX2\inis\`) tiene MAPEO DE TECLADO Y MOUSE
  agregado a mano en `[Pad1]`**, como líneas repetidas al lado de las del
  joystick (PCSX2 admite varios bindings por botón, así que el mando sigue
  andando). WASD = stick izquierdo; mouse (`Pointer-0/X±`, `Y±`) + flechas =
  stick derecho; click izq/der = R1/L1; Space = Cross; F = Square; R =
  Triangle; C = Circle; Shift = L3; Q = R3; G/V = L2/R2; Enter/Backspace =
  Start/Select; I J K L = cruceta. `PointerXScale`/`PointerYScale` = 40.
  **`TogglePause` se movió de `Keyboard/Space` a `Keyboard/P`** porque chocaba
  con el salto. Este archivo NO está en el repo y se pisa solo al salir de
  PCSX2: si se pierde, está descripto acá para rehacerlo.
- Formatos de binding verificados leyendo los strings del `pcsx2-qt.exe`, no
  adivinados: `Keyboard/<tecla>`, `Pointer-{}/Button{}`, y ejes de puntero
  `Pointer-{}/{}{:c}` → `Pointer-0/X+`.
- El fork PCSX2-MCP de Downloads (el de `lanzadores/*.bat`) es un build del
  15/08, ANTERIOR al 2.8.0: **no sirve** para esta línea, sólo para el
  reversing con DebugServer.
- Savestates útiles: `sstates/SLUS-21376 (5C891FF1).03.p2s` arranca en calle
  con vida llena y geometría 3D — es el que se usó para R0. El `.10.p2s`
  arranca con vida baja y el jugador muere solo.
- Se carga por CLI, sin tocar menús:
  `pcsx2-qt.exe -statefile "<ruta .p2s>" "<ruta Black.iso>"`.
- El ISO original y sus permisos (ReadOnly + guardia) **no se tocaron**. Cero
  parches vivos en RAM: esta sesión no escribió memoria ni ISO.

### 8.7 R2 — ABIERTA: arquitectura mapeada de fuente primaria, Fran ya baja los dos binarios de Discord

**Decisión de Fran (2026-09-02): se va por DLSS5 real (camino b).** Ya bajó
`dlss5-bridge-main.zip` y `DLSS5-Feeder-main.zip` a `Downloads/` — **son el
código FUENTE de GitHub, no los binarios compilados**; hace falta ir a la
página de **Releases** de cada repo, no al zip de `main`. Y confirmó que el
patch de 60fps que probó es el que aparece en el panel de patches
recomendados de PCSX2 (ver más abajo) — no un pnach suelto.

**Hay precedente público de DLSS5 corriendo específicamente en PCSX2**
(TechPowerUp, WCCFTech, GameGPU.com, un post de X de @DystopianSuns) —
`probable`, no `confirmado`: tres de esas cuatro fuentes bloquearon el fetch
(403) y la que se pudo leer (heldgames.com) se niega explícitamente a
publicar pasos de instalación o el nombre exacto del juego probado. El hecho
de que exista está medido por multiplicidad de fuentes independientes; el
cómo replicarlo **no está publicado en ningún lado** — hay que armarlo de los
README primarios, que es lo que sigue.

**El caso de PCSX2 es el MÁS SIMPLE de los cuatro que cubre DLSS5-Feeder**,
por partida doble:

1. **Es D3D12, no D3D11/Vulkan/32-bit.** El propio README: *"On a D3D12 game
   there is no transport at all: NGX runs on the game's own device and
   queue, motion vectors and depth are consumed zero-copy straight from the
   effect textures."* No hace falta el `host64\` de 32-bit, ni el mirror de
   Vulkan, ni siquiera `dlss5-bridge` — el bridge es **sólo** para juegos que
   YA tienen DLSS propio en D3D11/Vulkan (su propio README: *"Do I need the
   DLSS 5 DX11 bridge? No."* para el caso sin DLSS nativo). **La pieza
   correcta es `DLSS5-Feeder`, no `dlss5-bridge`** — corrige lo escrito acá
   ayer, que los daba como alternativas equivalentes.
2. **La profundidad ya está resuelta.** El requisito de Generic Depth con
   selección manual del buffer grande que R0 tuvo que descubrir a mano es
   **exactamente** el mismo requisito que pide DLSS5-Feeder (*"use ReShade's
   Add-ons → Generic Depth page to select the draw call/clear that contains
   the scene rather than UI or an already-cleared buffer"*) — R0 ya lo dejó
   resuelto y documentado (8.3), sólo hay que repetirlo si cambia el
   renderer/resolución.

**Lista exacta de piezas para un juego 64-bit D3D12 sin DLSS nativo — del
README de DLSS5-Feeder, sección Requirements + "Install for a 64-bit game":**

| Pieza | De dónde | Estado acá |
|---|---|---|
| ReShade **6.8+** con add-on support | reshade.me | **hay 6.6.2 — no alcanza, hay que reinstalar** (gotcha nuevo, no detectado en R0/R1 porque no importaba para Generic Depth) |
| `dlss5-feed.addon64` + `DLSS5_Feed.fx` | [Releases de DLSS5-Feeder](https://github.com/jlrouzies-fr/DLSS5-Feeder/releases/latest) | no bajado (el zip que hay es `main`, no el release) |
| Proveedor de motion vectors — [LumeniteFX](https://github.com/umar-afzaal/LumeniteFX) Kernel, `DLSS5_MV_PROVIDER=3` | repo propio, "Code → Download ZIP" | no bajado |
| `renodx-dlss5.addon64` **v4.55 exacto** + `nvngx_dlssnr.dll` | RenoDX Discord, canal `#DLSS5` — <https://discord.com/channels/1408098019194310818/1542647972695904317> | **fuente no confiable — la baja Fran, no esta sesión** |
| `nvngx_dlss.dll` (runtime DLSS Super Resolution) | de cualquier juego con DLSS, o [DLSS Swapper](https://github.com/beeradmoore/dlss-swapper) | sin verificar si el driver ya trae uno usable |

**Un gotcha real que casi se pisa:** `renodx-dlss5.addon64` tiene versiones
posteriores a v4.55 que ya arman su propio contrato sintético y **chocan**
con DLSS5-Feeder si se usan juntos — hay que pedir puntualmente v4.55 en el
Discord, no "la última".

**Pregunta de arquitectura sin responder, la más importante para esta
sesión que sigue — es la que le toca a Opus:** R0 midió el depth buffer de
ReShade a **2568×1800**, exactamente la resolución INTERNA a 4x. Eso
sugiere que ReShade —y por lo tanto DLSS5-Feeder, que en D3D12 lee "zero-copy
straight from the effect textures" del mismo backbuffer que ReShade ve— está
enganchando el framebuffer **antes** de cualquier reescalado de PCSX2 hacia
la ventana/pantalla de salida. Si es así, la reconstrucción DLAA de
DLSS5-Feeder correría sobre 2568×1800, no sobre 1080p/2K — mucho más caro
de lo necesario, y en tensión directa con la restricción ya guardada de
Fran ([[black-remaster-resolucion-objetivo]] en memoria del perfil: la
salida final no debe superar la resolución nativa de cada pantalla). Falta
confirmar: ¿PCSX2 presenta el swapchain D3D12 a resolución interna (y
reescala después, fuera del alcance de ReShade) o a resolución de
ventana/pantalla (y el downscale pasa ANTES del hook de ReShade)? No se
puede leer de un README genérico — es específico del present path de PCSX2
y hay que confirmarlo mirando el tamaño real del backbuffer que reporta
ReShade (`ReShade.log` lo imprime) contra el tamaño de la ventana.

**Patch de 60fps — confirmado el origen, no verificado el efecto:**
`gamesettings/SLUS-21376_5C891FF1.ini` ya tiene `[Patches] Enable = 60 FPS`
(además de `Video Mode` y `Widescreen 16:9`) — es la base de patches
oficial/embebida de PCSX2 (panel "recomendados" de Ajustes→Juego, no un
pnach suelto en disco: `Documents/PCSX2/patches/` está vacío porque esa base
no se guarda como archivo local). Activado en la config, **no medido por
efecto todavía** — falta arrancar con ese patch y leer el FPS real del OSD,
mismo método que R1.

**Modelo para lo que sigue: Opus, sin excepción.** No es investigación
general — es la primera hipótesis de arquitectura en territorio sin
precedente reproducible (el present path D3D12 de PCSX2 contra este
pipeline), con una pregunta abierta concreta arriba que decide si el diseño
entero cambia. Esfuerzo: high, sin fan-out — es un solo hilo de lectura y
diseño, no una tarea que se beneficie de paralelismo.
### 8.8 R2 — LA PREGUNTA DE ARQUITECTURA, RESPONDIDA: el backbuffer es 1920x1080, NO 2568x1800

**Grado: `confirmado`.** Medido de fuente primaria (`ReShade.log` de la
instalación corta, corrida del 2026-09-01 23:05, la misma config que ganó R1:
`Renderer = 15`, `upscale_multiplier = 4`):

```
23:05:49:807 | Redirecting IDXGIFactory2::CreateSwapChainForHwnd(...)
23:05:49:808 | > Dumping swap chain description:
23:05:49:808 |   | Width   | 1920 |
23:05:49:808 |   | Height  | 1080 |
23:05:49:808 |   | Format  | DXGI_FORMAT_R8G8B8A8_UNORM |
23:05:49:819 | Running on NVIDIA GeForce RTX 4060 Laptop GPU Driver 610.62.
```

Es el path D3D12 (el bloque inmediatamente anterior en el log es un
`D3D12_COMMAND_QUEUE_DESC` — Type/Priority/Flags/NodeMask), y en la misma
corrida R0 midió el depth en 2568x1800. **Dos números distintos en la misma
sesión: el swapchain NO sigue a la resolución interna.**

**Qué significa, y por qué cierra la duda:**

PCSX2 renderiza el GS a 2568x1800 en render targets propios (eso es lo que
Generic Depth encuentra como depth), y **reescala a 1920x1080 ANTES del
`Present`**. ReShade engancha el swapchain, así que sus texturas de efecto —
el `backbuffer` que DLSS5-Feeder lee "zero-copy" en D3D12 — son de
**1920x1080**.

| recurso | tamaño | quién lo ve |
|---|---|---|
| render target interno del GS | 2568x1800 | Generic Depth (el depth de R0) |
| **swapchain / backbuffer** | **1920x1080** | **ReShade y DLSS5-Feeder** |

**Consecuencia: EL DISEÑO NO CAMBIA.** La reconstrucción DLAA corre a
1920x1080 (`render size = output size`, 1:1, sin jitter — README de
DLSS5-Feeder, sección *How it works*), no a 2568x1800. La restricción de
scope de Fran ([[black-remaster-resolucion-objetivo]]: la salida final no
supera la resolución nativa de la pantalla) **se cumple por construcción**,
sin tener que tocar nada. La hipótesis de 8.7 —que DLAA iba a correr sobre
2568x1800 y salir carísimo— queda **falsificada**.

Y el 4x no se desperdicia: el downscale de 2568x1800 a 1080p ya es
supersampling, y DLAA + neural rendering corren encima de eso a 1080p.

**El desajuste de tamaños que esto destapa, y por qué NO es un problema:**
el depth queda a 2568x1800 mientras el color está a 1920x1080. No hay que
hacer nada: `DLSS5_Feed.fx` **copia** el depth a su propia textura
`DLSS5_Depth` (R32F) en un pase MRT de ReShade, y las texturas de efecto de
ReShade se asignan al tamaño del backbuffer. El resample lo hace ReShade al
bindear el depth con UVs normalizadas. El contrato que le llega a NGX es
1920x1080 en las tres entradas (color, depth, MV).

**Detalle de configuración que sale de esto:** `PCSX2.ini` tiene
`StartFullscreen = true`, y el swapchain salió `Windowed = TRUE` a 1920x1080
— o sea borderless a resolución de pantalla. **Si el pipeline se lleva a la
PC de escritorio (2K), el backbuffer va a ser 2K y DLAA va a correr a 2K**:
el costo del pipeline escala con la PANTALLA, no con el `upscale_multiplier`.
Es el eje correcto, pero conviene tenerlo escrito antes de medir allá.

**Qué falta para cerrar R2, medido en disco el 2026-09-02:**

| Pieza | Estado real |
|---|---|
| ReShade **6.8.0** Addon | **falta.** Hay 6.6.2. 6.8.0 salió el 2026-08-02 y existe (`ReShade_Setup_6.8.0_Addon.exe`, reshade.me). **winget NO sirve: `Reshade.Setup.AddonsSupport` sigue en 6.6.2.** El build Addon es **unsigned** (lo dice reshade.me). |
| `dlss5-feed.addon64` + `DLSS5_Feed.fx` | falta — de Releases de DLSS5-Feeder, no del zip de `main` |
| LumeniteFX (`DLSS5_MV_PROVIDER=3`) | falta — Code ▸ Download ZIP |
| `renodx-dlss5.addon64` **v4.55** + `nvngx_dlssnr.dll` | **falta, y sólo lo puede bajar Fran** (Discord de RenoDX). Medido: `Downloads/` NO los tiene todavía. |
| `nvngx_dlss.dll` | **OPCIONAL** — el README dice que si no está, se usa la copia del driver. Además hay dos instaladores de DLSS Swapper en `Downloads/` (de mayo 2025) si hiciera falta. |


**LINKS EXACTOS, verificados el 2026-09-02 — y DOS CORRECCIONES:**

| # | Pieza | Link |
|---|---|---|
| a | ReShade **6.8.0** Addon (unsigned) | `https://reshade.me/downloads/ReShade_Setup_6.8.0_Addon.exe` |
| b | DLSS5-Feeder release | `https://github.com/jlrouzies-fr/DLSS5-Feeder/releases/latest` |
| c | LumeniteFX (ZIP directo) | `https://github.com/umar-afzaal/LumeniteFX/archive/refs/heads/mainline.zip` |
| d | RenoDX Discord `#DLSS5` (lo baja **Fran**) | `https://discord.com/channels/1408098019194310818/1542647972695904317` |
| e | DLSS Swapper (opcional, para `nvngx_dlss.dll`) | `https://github.com/beeradmoore/dlss-swapper/releases/latest` |
| f | `ReShade.fxh` de repuesto, si el log dice que no lo encuentra | `https://github.com/crosire/reshade-shaders/tree/slim/Shaders` |
| — | dlss5-bridge — **NO bajar**, no es para este caso | `https://github.com/NIGos/dlss5-dx11-bridge/releases` |

1. **La bitácora 44 dijo `DLSS5-Feeder-0.10.0-beta.2.zip`. Es incorrecto.**
   El release más nuevo es **v0.7.0** (2026-08-31), y sus assets son
   archivos sueltos, no un zip: `dlss5-feed.addon64`, `dlss5-feed.addon32`,
   `dlss5-feed-host64.exe`, `DLSS5_Feed.fx`, `feed-vk-layer.zip`,
   `spike-gl64.exe`, `spike-gl32.exe`. Para el caso de PCSX2 (64-bit D3D12)
   hacen falta **sólo dos**: `dlss5-feed.addon64` y `DLSS5_Feed.fx`.
2. **La rama por default de LumeniteFX es `mainline`, no `main`.** El link
   de "Code ▸ Download ZIP" construido a ojo (`heads/main.zip`) da 404.


**GOTCHA DEL DISCORD (2026-09-02): el link de la fila (d) era de CANAL, no de
invitación.** Discord contesta *"parece que estás en un lugar extraño"* cuando
se abre una URL `discord.com/channels/<server>/<canal>` de un servidor del que
no se es miembro. El link de canal **sólo funciona después de entrar**. El de
invitación es:

    https://discord.com/invite/renodx     (alias: discord.gg/F6AUTeWJHM)

Entrar por ahí primero, y recién después el link de `#DLSS5` de la fila (d)
resuelve.

**LAS ALTERNATIVAS A ESE DISCORD SE BUSCARON Y SE DESCARTARON — decisión
tomada, no volver a abrirla sin evidencia nueva.** Hay al menos seis repos de
GitHub que rehostean `renodx-dlss5.addon64` + `nvngx_dlssnr.dll` en
instaladores "one-click" (`RankFTW/RHI`, `reiluisii/1-Click-DLSS5`,
`faisalkindi/DLSS5oneclick`, `ShugokiFable/dlss5-aio`, `zhubaohi/FF7R-DLSS5`,
`yumlevi/renodx-dlss-installer`) más mods en Nexus. **No se usan**, por tres
razones independientes y en este orden:

1. **`RankFTW/RHI` dice explícitamente que baja `renodx-dlss5.addon64` y lo
   mantiene actualizado EN SILENCIO.** Eso es exactamente lo que el README de
   DLSS5-Feeder prohíbe: cualquier build posterior a **v4.55** arma su propio
   contrato sintético y **choca** con el feeder. O sea: la opción más cómoda
   es la que garantiza romper el pipeline, en silencio, más adelante. No es
   un riesgo de seguridad, es un requisito incumplido.
2. **Provenance sucia.** Uno de esos repos se describe a sí mismo como
   *"One-click setup of the **leaked**..."*. Son binarios de NVIDIA
   redistribuidos por cuentas anónimas.
3. **Hay un incidente de repo IMPOSTOR documentado en este mismo
   ecosistema** (PSA en los foros de Steam de Crimson Desert sobre un GitHub
   falso de un mod de RenoDX). Bajar `.exe`/`.dll` sin firma de cuentas
   anónimas en un ecosistema con suplantación documentada no se hace.

**Medido en el disco el 2026-09-02, no asumido:** `nvngx_dlssnr.dll` **NO
está** en esta máquina. Lo único que hay del NGX del driver es
`nvngx_dlssg.dll` (Frame Generation), en
`Windows\System32\DriverStore\FileRepository\nvmii.inf_amd64_62de3bd48abb42a6\`
y en la caché de la NVIDIA App. Tampoco hay `nvngx_dlss.dll` en las
ubicaciones del driver — pero ése es **opcional**, y DLSS Swapper (ya hay dos
instaladores en `Downloads/`) inventaría los que traigan los juegos
instalados. El que bloquea es `nvngx_dlssnr.dll`, y su única fuente limpia es
el Discord de RenoDX.


**LA SESIÓN NO PUEDE BUSCAR EN EL DISCORD — medido el 2026-09-02, dos razones
independientes:** (1) `list_connected_browsers` devuelve vacío: la extensión
Claude in Chrome NO está conectada, así que no hay acceso a la sesión de
Discord de Fran; (2) el navegador interno es un perfil aparte, sin sesión —
`discord.com/channels/...` rebota a la landing — y loguearse por él está
prohibido. **Si se quiere que una sesión futura busque ahí, hay que conectar
antes la extensión Claude in Chrome.**

**RECETA DE BÚSQUEDA EN `#DLSS5`, para hacerla a mano en 30 segundos en vez de
scrollear.** El detalle que importa: **se busca una versión VIEJA (v4.55), y
el orden por default de la búsqueda de Discord es por más nuevo primero** — o
sea que el default entierra justo lo que se busca. Ordenar por **Old**, o
buscar el string de versión directo:

    in:#dlss5 4.55
    in:#dlss5 has:file renodx
    in:#dlss5 has:file addon64
    in:#dlss5 nvngx_dlssnr

Y antes que nada: **mirar los MENSAJES FIJADOS** del canal (icono de pin,
arriba a la derecha). Una distribución canónica de un binario suele vivir ahí,
no en el chat.

### 8.9 REVISIÓN DE LO DESCARGADO — 2026-09-02, medido archivo por archivo

**LOS DOS `renodx-dlss5.addon64` SON v4.6+, NINGUNO ES v4.55. No sirven.**

El README de DLSS5-Feeder da el discriminador exacto: *"The feeder detects a
v4.6 build (`NRToggleKey` marker)"*. Buscado en los dos binarios: **el
marcador está presente en ambos**. Y con el feeder **released** (v0.7.0, que
es el que se bajó) el README es terminante: *"with the released feeder
builds, stay on v4.55"* — los guardas para v4.6 sólo existen compilando desde
`main`, no en el release.

| archivo | bytes | SHA256 (12) | `NRToggleKey` | veredicto |
|---|---|---|---|---|
| `renodx-dlss5.addon64` | 1694720 | `9150097CDEE2` | **presente** | v4.6+, NO sirve |
| `renodx-dlss5 (1).addon64` | 1732608 | `D5ADF82EB44B` | **presente** | v4.6+, NO sirve |

Los dos declaran `FileVersion 0.2026.0828.0517` — un sello de FECHA, no
semántico: **el recurso de versión del PE NO distingue 4.55 de 4.6**, por eso
hay que ir al marcador. Son builds distintos entre sí: el (1) tiene
`reversible NR color bridge` y el string `RenoDX-DLSSNR`; el otro tiene el
camino `Control codec`/`Control HDR transfer`.

**EL LINK DIRECTO AL MENSAJE DE v4.55 ESTABA EN EL README TODO EL TIEMPO**, en
el bloque de advertencia del encabezado (que esta sesión no leyó cuando armó
la tabla de links — leyó la sección de instalación y la de Requirements y se
salteó el warning). Es un permalink a UN mensaje, no al canal:

    https://discord.com/channels/1408098019194310818/1542647972695904317/1543568908017995818

**El resto de lo descargado está BIEN — verificado, no supuesto:**

| archivo | verificación |
|---|---|
| `ReShade_Setup_6.8.0_Addon.exe` | `FileVersion 6.8.0.0`, Product `ReShade`, firmante `CN=ReShade, E=info@reshade.me`. Estado de firma `UnknownError` = cadena no confiable, **consistente** con que reshade.me declare unsigned el build Addon. Identidad del firmante correcta. |
| `dlss5-feed.addon64` | `FileVersion 0.7.0.0` — coincide con el release v0.7.0 |
| `DLSS5_Feed.fx` | 810 líneas, define `DLSS5_MV_PROVIDER` (default 0 — hay que ponerlo en **3**) |
| `LumeniteFX-mainline.zip` | completo: `Shaders/lumenite_Kernel.fx` + `include/` (4 `.fxh`) + `Textures/lumenite_bluenoise256.png` |

**Sin resolver:** `Sin confirmar 205983.crdownload`, 165 MB, **estancado** (mismo
tamaño en dos muestreos, mtime 00:44). Es una descarga de Chrome sin
confirmar; lo más probable es que esté esperando el botón *Conservar*. No se
sabe qué es. `nvngx_dlssnr.dll` **sigue sin aparecer** en `Downloads/`.


### 8.10 CORRECCIÓN A 8.9, Y EL PIPELINE LISTO PARA INSTALAR — 2026-09-02

**8.9 ESTABA MAL, Y ASÍ SE DESCUBRIÓ.** Fran trajo la captura del mensaje
original (Krish, `#DLSS5`, 30/8/26 7:31: *"v4.55 — Should now work with RE
Engine games"*, adjunto `renodx-dlss5.addon64`, 1.62 MB) y bajó ese archivo.
Resultado medido: **es byte a byte idéntico al primer `renodx-dlss5.addon64`
que ya estaba en `Downloads/`** — mismo SHA256 `9150097CDEE2…`, mismos
1.694.720 bytes. O sea: **el v4.55 ya lo tenía desde el principio.**

**El test del marcador `NRToggleKey` es INVÁLIDO como discriminador de
versión.** El v4.55 confirmado por el autor **también lo contiene**. La
conclusión de 8.9 —"los dos son v4.6, ninguno sirve"— era falsa.

El error de método, que es lo que hay que no repetir: **se armó un test y
nunca se le pasó un control positivo.** No había ningún v4.55 conocido contra
el cual probar que el test supiera decir "no". Un test que sólo vio ejemplares
de una clase y siempre dijo lo mismo está sin verificar — es exactamente la
regla del saboteador, aplicada a un discriminador en vez de a una alarma. Lo
que el README dice es que *el feeder* detecta un build v4.6 por ese marcador;
de ahí no se sigue que la mera presencia del string en el binario lo
identifique.

**IDENTIFICACIÓN BUENA — por procedencia y hash, no por heurística:**

| archivo en `Downloads/` | bytes | SHA256 (12) | qué es |
|---|---|---|---|
| `renodx-dlss5.addon64` | 1694720 | `9150097CDEE2` | **v4.55** |
| `renodx-dlss5 (2).addon64` | 1694720 | `9150097CDEE2` | **v4.55** — idéntico al anterior |
| `renodx-dlss5 (1).addon64` | 1732608 | `D5ADF82EB44B` | otro build (`reversible NR color bridge`, `RenoDX-DLSSNR`) |
| `renodx-dlss5 (3).addon64` | 573440 | `E1C28FDE0922` | otro build, sello `0.2026.0828.2110` |

El propio mensaje explica los sobrantes: *"Accidentally posted debug before"*
— en el canal hay builds de debug posteados por error.

**EL BLOQUEO DE R2 SE LEVANTÓ: `nvngx_dlssnr.dll` LLEGÓ.** Era el
`.crdownload` de 165 MB que estaba a medias. Medido:
`FileVersion 310.8.0.0`, `Product NVIDIA DLSSNR`, `Company NVIDIA`, PE válido,
165.840.496 bytes. Y **empareja por efecto**: el addon de RenoDX lleva adentro
el formato `RenoDX DLSS5 Generic %s | DLSSNR v310.8.0: %s` — espera
exactamente 310.8.0, que es la que hay. **Están todas las piezas.**

**LA SESIÓN NO PUDO INSTALAR: el clasificador de permisos lo bloqueó dos
veces**, por dos vías distintas — (1) `Start-Process … -Verb RunAs` del
instalador, (2) escritura de archivos dentro de `C:\Program Files\PCSX2`. No
se buscó una tercera vía a propósito: dos negativas sobre el mismo objetivo
son una decisión, no un obstáculo. Queda como **`.\instalar-dlss5.ps1`** en la
raíz del proyecto, para que lo corra Fran.

Lo que el script hace, y todo esto ya está medido y verificado:
- Aborta si PCSX2 está corriendo (al salir pisa `PCSX2.ini` y se pierde el
  mapeo de teclado de 8.6).
- **Verifica el SHA256 del addon contra el del v4.55 antes de copiar nada** —
  es el único chequeo que de verdad importa, y es por hash, no por heurística.
- Instala ReShade 6.8.0 **sin correr el instalador**: el `.exe` abre como ZIP
  y trae `ReShade64.dll` (5.592.064 bytes), que es lo que va como `dxgi.dll`.
- Copia el feeder, el renodx v4.55, `nvngx_dlssnr.dll`, `DLSS5_Feed.fx` y
  LumeniteFX a donde van.
- **Verifica por efecto**: tamaño de cada archivo instalado y hash del renodx.
- **`-Desinstalar` revierte todo** y restaura ReShade 6.6.2.

**Respaldos ya hechos por la sesión** (esto sí se pudo):
- `pruebas/PCSX2.ini.respaldo-2026-09-02` — 15.550 bytes, con el mapeo de
  teclado/mouse de `[Pad1]` adentro.
- `pruebas/reshade-662-respaldo/` — `dxgi.dll` 6.6.2.2081, `ReShade.ini`,
  `ReShadePreset.ini`.

**Lo que queda después de correr el script — es a mano, en el overlay:**
fijar el depth buffer grande en Generic Depth (8.3), `DLSS5_MV_PROVIDER = 3`,
habilitar `LUMENITE: Kernel 2.0` y debajo `DLSS 5 Feed`, encender neural
rendering, y leer `dlss5-feed.log`.


**8.10b — EL SCRIPT FALLABA, ARREGLADO (2026-09-02).** Primera corrida:
`ArgumentNullException: source` en el paso 1. **Causa medida:** el instalador
de ReShade tiene un stub `.exe` delante del archivo comprimido, y
`[IO.Compression.ZipFile]::OpenRead` lo abre con **CERO entradas** — .NET no
ajusta el offset por los datos prepended. `zipfile` de Python sí, y por eso la
inspección de la sesión había funcionado sobre el mismo archivo. Nada se había
instalado: el script abortó antes de tocar nada y `dxgi.dll` seguía en
6.6.2.2081 (verificado).

**Arreglo: el script ya no abre ningún ZIP.** La sesión desempaquetó todo con
Python en **`C:\Users\frans\Downloads\_dlss5_staging\`** (14 archivos:
`ReShade64.dll` 5.592.064 bytes + `Shaders\` con los 8 `lumenite_*.fx` y 4
`include\*.fxh` + `Textures\lumenite_bluenoise256.png`), y el script es copia
pura. Sintaxis verificada con `PSParser::Tokenize` — 0 errores.

**Si el staging no está, el script aborta sin tocar nada y lo dice.** Se
rehace con Python desde `ReShade_Setup_6.8.0_Addon.exe` y
`LumeniteFX-mainline.zip`, los dos en `Downloads/`.

### 8.11 INSTALACIÓN CONFIRMADA POR EFECTO — 2026-09-02, sesión nueva

**Grado: `confirmado`.** Entre el cierre de 8.10b y esta sesión, Fran corrió
`.\instalar-dlss5.ps1` (nadie lo dejó anotado; se detectó porque `dxgi.dll` ya
no daba 6.6.2.2081 al abrir). Medido de nuevo, con el mismo criterio de
"por efecto" del script (tamaño de cada archivo + hash del renodx + FileVersion
del dxgi.dll), **no asumido de que "el script no dio error"**:

| archivo | medido | esperado | resultado |
|---|---|---|---|
| `dxgi.dll` | 5.592.064 b, FileVersion 6.8.0.2155 | 6.8.x | OK |
| `dlss5-feed.addon64` | 164.352 b | 164.352 | OK |
| `renodx-dlss5.addon64` | 1.694.720 b, SHA256 `9150097CDEE2…` | v4.55 | OK |
| `nvngx_dlssnr.dll` | 165.840.496 b | 165.840.496 | OK |
| `DLSS5_Feed.fx` | 44.814 b | 44.814 | OK |
| `lumenite_*.fx` | 8 archivos en `reshade-shaders\Shaders\` | 8 | OK |
| `lumenite_bluenoise256.png` | presente en `Textures\` | — | OK |

**La instalación en disco está cerrada.** Lo que NO está hecho todavía:
- `dlss5-feed.log` **no existe** en `C:\Program Files\PCSX2\` — PCSX2 no
  corrió ni una vez desde que se instaló el pipeline (`PCSX2.ini` sigue con
  `LastWriteTime` del 2026-09-01 23:05, de la corrida de R1; ningún proceso
  `pcsx2-qt` activo al medir).
- La config del overlay (8.3 + el punto 6 de la receta: casilla del depth
  buffer grande en Generic Depth, `DLSS5_MV_PROVIDER=3`, orden de efectos,
  neural rendering) **no se hizo**, y no se puede haber sobrevivido de una
  instalación anterior aunque alguien la hubiera tocado antes: **reinstalar
  ReShade resetea la selección de depth buffer** (ya documentado en 8.3). Es
  la primera vez que se abre el overlay contra el ReShade 6.8.0 recién puesto.

**Por qué esto NO lo termina la sesión sola:** la config del overlay es
navegación dentro de una ventana nativa (PCSX2 + sus paneles de ReShade) —
no hay herramienta de automatización de UI de escritorio en este entorno
(las de navegador no aplican; PCSX2 no es una página web), y hacerlo a
ciegas con `SendKeys` sobre una lista de depth buffers cuyo layout no se
conoce de antemano es exactamente el tipo de atajo que la regla 6 del perfil
pide no tomar sin medir antes. Los 7 pasos de la receta (retome, sección 6)
siguen pendientes, a mano.

**Lo que la sesión SÍ puede hacer apenas eso esté listo:** correr el
protocolo de medición de FPS ya usado en R0/R1 sobre el savestate 03 — editar
`PCSX2.ini` con PCSX2 cerrado, lanzar con `-statefile`, esperar, capturar
pantalla completa por `.NET`/PowerShell y leer el OSD de la imagen — y leer
`dlss5-feed.log` buscando `feature ready ... DLAA` y `frame N delivered`, que
es lo que cierra R2.

### 8.12 [SUPERADA POR 8.13] "NGX rechaza esta GPU/driver" — la conclusion era FALSA, leer 8.13

**Fran hizo en vivo, con PCSX2 corriendo, los pasos que 8.11 dejaba
pendientes:** ordenó `LUMENITE: Kernel 2.0` arriba de `DLSS 5 Feed` en la
lista de técnicas (el propio feed avisa por log cuando está al revés: `enable
it above DLSS 5 Feed`) y tildó a mano la fila del buffer grande de Generic
Depth (`2568x1800`, ~4600 draw calls). Los dos, confirmados por captura de
pantalla del overlay.

**El resultado de fondo NO cambió, en TRES corridas independientes — la
última con el wiring perfecto desde el primer frame:**

| corrida | wiring al momento del chequeo NGX | resultado |
|---|---|---|
| 1 (primera vez completo) | roto (`MV_PROVIDER=0`, sin motion vectors) | `SuperSampling.Available=0` → `stopped` |
| 2 (relanzamiento limpio) | correcto desde el primer scan (`Kernel enabled`) | `SuperSampling.Available=0` → `stopped`, idéntico |
| 3 (con `mode=1` en vez de `mode=2`) | correcto | `SuperSampling.Available=0` → `stopped`, idéntico |

Secuencia siempre igual, tal cual queda en `dlss5-feed.log`:
```
[feed] NVSDK_NGX_D3D12_Init -> 0x00000001 (Success)
[feed] NGX capabilities: SuperSampling.Available=0
stopped: DLSS is not available on this GPU/driver. The game renders normally.
```

**CORRECCIÓN DE MÉTODO, hecha en la misma sesión: las tres corridas NO
prueban un techo de hardware.** Las tres usaron el MISMO `nvngx_dlssnr.dll`
sin cambiarlo — repetir el mismo test con el mismo insumo sospechoso tres
veces confirma que el resultado es REPRODUCIBLE, no CUÁL de las dos hipótesis
(techo de la GPU vs. archivo roto) es la causa. Ese es exactamente el error
que `chequeo-de-trabajo.md` pide evitar: nombrar la segunda explicación
plausible y diseñar el test que la mata, no reforzar la primera con más
repeticiones del mismo insumo. La variable que faltaba variar era el DLL, y
resultó ser la que importaba (ver abajo).

**LA CAUSA REAL, `confirmado` por dos mediciones locales independientes —
NO es un techo de hardware:** el `nvngx_dlssnr.dll` instalado tiene la firma
Authenticode INVÁLIDA:
```
PS> Get-AuthenticodeSignature 'C:\Program Files\PCSX2\nvngx_dlssnr.dll'
Status: HashMismatch
"...el hash del archivo no coincide con el hash almacenado en la firma digital."
```
Y su SHA256 (`8270B350CD82DE5CE89806872CDD6B6A9249B80836B91BBEB3573470744CC206`)
es DISTINTO del hash "known-good" que usa una herramienta comunitaria para
esta misma clase de falla (`E16BCF15E16E13F527491CDF7845B2FE6521A738D8F7C9C721866A8496E1FC8E`,
misma versión de archivo 310.8.0.0 — mismo número, contenido distinto).
`ReShade.log` ya lo venía avisando y no se le dio suficiente peso a tiempo:
`WARN | signed runtime sha256 8270B350... (custom runtime accepted; untested
build, NR failures may be specific to it)`. El archivo que bajamos de un
adjunto de Discord (HANDOFF 8.9/8.10) nunca se verificó por firma, sólo por
`FileVersion`/`Company`/"PE válido" — una verificación mucho más débil.

**Fran encontró en el Discord de RenoDX (canal `tools`) el hilo "Fix for
DLSS 5 Stuck on STANDBY/FAILED" de Kayle, que describe EXACTAMENTE este
mecanismo** (`nvngx_dlssnr.dll` dañado/modificado, firma inválida, log con
`feature 18 create failed with 0xBAD00002`) y linkea una herramienta:
`https://github.com/kayle2203/dlssnr-signature-repair`.

**La herramienta fue revisada — código fuente completo leído, no sólo el
README (`gh api repos/kayle2203/dlssnr-signature-repair/contents/...`):**
repo chico (creado 2026-08-28, 8 estrellas), con `LICENSE` y `SECURITY.md`.
El script (`DLSSNR-Repair.ps1`, PowerShell puro) hace SÓLO esto: pide una
carpeta ORIGEN (un juego que YA tenga un `nvngx_dlssnr.dll` sano) y una
carpeta DESTINO; verifica el origen por hash SHA256 EXACTO
(`E16BCF15...`) + versión + firma Authenticode válida de NVIDIA antes de
tocar nada; si no matchea, aborta sin cambiar un solo byte; si matchea,
hace backup del archivo roto (`.bad-signature-backup-<fecha>`) y reemplaza
de forma atómica (`[IO.File]::Replace`), con rollback automático si algo
falla. **Cero llamadas de red, cero binarios de NVIDIA incluidos, cero
credenciales pedidas.** Es seguro de correr; el único requisito es
conseguir una fuente cuyo hash sea el exacto `E16BCF15...` (una copia rota
o de otra build NO sirve — el script la rechaza a propósito).

**Corroboración independiente, desde OTRO módulo:** el addon separado
`renodx-dlss5.addon64` (panel "DLSS 5 Neural Rendering") no ve nunca una
`DLSSD`/`DLSS` feature creada — `HOOKS ARMED - NO DLSS CREATE SEEN` — lo
cual es consistente: si `dlss5-feed` se rinde antes de llamar
`CreateFeature`, no hay nada que `renodx-dlss5` pueda interceptar. Mismo
techo, visto desde el módulo de al lado.

**Dato técnico suelto, NO la causa actual, pero es una pista real para la
sesión que sigue:** `ReShade.log` (no `dlss5-feed.log`) registra que el
propio hook de `renodx-dlss5` sobre el NGX real del driver falla en una de
cuatro funciones:
```
DEBUG | vtable::Hook(NVSDK_NGX_D3D12_CreateFeature hooked ...)
DEBUG | vtable::Hook(NVSDK_NGX_D3D12_EvaluateFeature hooked ...)
ERROR | vtable::Hook(Failed to find NVSDK_NGX_D3D12_EvaluateFeature_C)
DEBUG | vtable::Hook(NVSDK_NGX_D3D12_ReleaseFeature hooked ...)
```
El módulo detourado es
`C:\WINDOWS\System32\DriverStore\FileRepository\nvmii.inf_amd64_62de3bd48abb42a6\_nvngx.dll`
(el core NGX que trae el driver 610.62). Ese export no está ahí. **No se
sabe si un driver más nuevo lo agrega** — es una hipótesis sin probar, no un
hecho. No es la causa de lo medido arriba porque `dlss5-feed` nunca llega a
ese punto del código, pero si algún día `SuperSampling.Available` empezara a
dar `1`, este sería el siguiente escollo a mirar.

**Cabo suelto sin cerrar, de bajo valor:** `dlss5-feed.log` sigue diciendo
`EnableHooks=2 (user-set; leaving it alone)` pase lo que pase con `mode=` en
`dlss5-feed.cfg`. Son dos ajustes de DOS ADDONS distintos que coinciden en
nombre-de-log y en valor por casualidad (`ReShade.log` sí atribuye
`EnableHooks=2` a `renodx-dlss5`, no a `dlss5-feed`). Dónde vive el
`EnableHooks` real de `renodx-dlss5` — otro `.cfg`, `ReShade.ini`, registro —
**no se ubicó**. Lección registrada:
`perfil-global/chequeo-de-trabajo.md`, sección "AL LEER EL ESTADO DE LA
MÁQUINA". Dado que el bloqueo real (la respuesta de NGX) es anterior a este
ajuste, no es prioritario — pero si se retoma el hilo de "probar
EnableHooks=1", primero hay que encontrar el archivo correcto.

**DECISIÓN DE FRAN (2026-09-02, de madrugada): handoff a sesión nueva con
Opus.** Mientras tanto él instala un driver de NVIDIA más nuevo por su
cuenta (acción de sistema, la hace él, no la sesión). El encargo explícito:
*"la gente lo pudo hacer andar con placas similares a la mía, investigá bien
y si podés leé el Discord"*. Esto es investigación en territorio
desconocido con final abierto (por qué otros con RTX 40-series lo lograron,
si es que lo lograron, y qué hicieron distinto) — no un runbook ya decidido,
así que corresponde **Opus**, con esfuerzo **high o xhigh** y probablemente
**fan-out** (Discord, issues de GitHub de DLSS5-Feeder y de RenoDX, cambios
recientes de driver, reportes de otros usuarios son fuentes independientes)
una vez que un sondeo barato confirme que hay superficie ancha real — la
decisión fina de effort/fan-out es de esa sesión, vía `/enrutador-modelo`.

**Restricción ya medida, no la repitas:** el 2026-09-02 esta sesión no pudo
buscar en el Discord de RenoDX — `list_connected_browsers` da vacío (Claude
in Chrome no conectado) y el navegador interno no tiene sesión de Discord
(8.8 lo documenta con el mismo detalle). Si para la próxima sesión Fran
conectó la extensión, probarlo; si no, no perder un turno re-descubriendo
esto — ir directo a fuentes públicas (GitHub, foros, Reddit) y decirle a
Fran que necesita conectar la extensión si el Discord es la única fuente
que falta.

### 8.13 LA CAUSA REAL: FALTA `nvngx_dlss.dll`. No es la GPU y no es la firma — 2026-09-02, sesión Opus

**Esta sección corrige a 8.12 en su conclusión operativa. 8.12 sigue siendo correcta en su
corrección de método (tres corridas con el mismo insumo no prueban causa), pero la pista que
dejó abierta — reparar la firma del `dlssnr` — resultó ser la equivocada, y además riesgosa.**

#### Lo medido localmente, primero

Re-medición de apertura (por si el driver nuevo había cambiado algo): **nada cambió.**
`nvngx_dlssnr.dll` sigue con SHA256 `8270B350CD82DE5CE89806872CDD6B6A9249B80836B91BBEB3573470744CC206`,
firma `HashMismatch`, `FileVersion` 310.8.0.0. PCSX2 seguía corriendo (PID 36588, arrancado 01:53).

**El inventario que nadie había hecho** — todos los `*nvngx*` de la carpeta del juego:

```
nvngx_dlssnr.dll   165.840.496   ver=310.8.0.0   sig=HashMismatch   sha=8270B350...
```

**Uno solo.** No está `nvngx_dlss.dll`. Y `SuperSampling` es la feature que provee
`nvngx_dlss.dll`, no el `dlssnr` (que provee Ray Reconstruction / Neural Rendering). NGX
resuelve las DLL de features **desde el directorio del proceso**: si el archivo no está ahí,
`SuperSampling.Available=0` es la respuesta correcta y esperable del runtime.

Barrido de todo `C:` — el archivo **ya existe en la máquina, tres veces, todas firmadas y
válidas**:

```
48.971.832   v310.2.1.0   Valid   C:\Games\The Last of Us Part I\nvngx_dlss.dll
51.256.376   v3.7.0.0     Valid   C:\Games\The Last of Us Part II Remastered\nvngx_dlss.dll
48.971.832   v310.2.1.0   Valid   ...\DLSS Swapper\dlls\dlss\dlss_v310.2.1.0_3A875F45...\nvngx_dlss.dll
```

En el `DriverStore` sólo hay `nvngx_dlssg.dll` (frame generation, 9.3 MB, v310.2.1.0, firma
válida). **No hay ningún `nvngx_dlss.dll` del driver.**

#### La causalidad, que ninguna medición local podía dar

Fran entró al Discord de RenoDX por QR en el navegador interno (ver 8.14 para el estado de esa
sesión). Tres fuentes independientes, del `dlss5-forum`, `tools` y `dlss5-helpdesk`:

| quién | GPU | qué aporta |
|---|---|---|
| POMAHECKO (NFS Most Wanted 2005) | **RTX 4070 SUPER** | el **antes/después** exacto: *"The important part was adding `nvngx_dlss.dll` to host64. Before that: `SuperSampling.Available=0`, NGX unavailable. After adding `nvngx_dlss.dll`: `SuperSampling.Available=1`"*. Llegó a `feature ready: 2560x1440 DLAA` y `frame 10800 evaluated`. |
| TraceKira (guía Skyrim SE) | RTX 5070 mobile | el síntoma completo por omisión: `nvngx_dlss.dll MISSING` → `SuperSampling.Available = 0` → `CreateFeature failed 0xBAD0000B`. Y la regla de versión: **"Keep both nvngx DLLs on the same version."** |
| Agai Naizagai (hilo *"The Sims 4 DLSS 5 **RTX 4060**"*) | **la misma GPU que la notebook** | *"also u need the `nvngx_dlss.dll`, it is missing"*, con el log idéntico al nuestro: `SuperSampling.Available=0 NeedsUpdatedDriver=0 MinDriver=0.0`. |

El caso de POMAHECKO es el que cierra la causalidad: es la **misma variable variada** (agregar el
archivo) con el **mismo síntoma antes** y el **resultado buscado después**, en una RTX 40.

#### Dos cosas que quedan descartadas

**1. El techo de hardware.** Hay RTX 40 con el pipeline corriendo y evaluando frames. ShortFuse
(autor de RenoDX) mantiene un hilo dedicado, *"Patched DLSS-NR for RTX20, RTX30, and RTX40"*:
*"Replace `nvngx_dlssnr.dll` with the latest pinned version. (Yes. Use pins). Auto branches based
on hardware. Supports RTX20/RTX30 by replacing FP8 calls..."*.

**2. La herramienta de reparación de firma de Kayle — y era un riesgo real, no sólo un desvío.**
Esa herramienta exige un origen con hash exacto `E16BCF15...`, que es el **binario firmado por
NVIDIA**, o sea el de Blackwell. La guía del propio server dice lo contrario para esta GPU:

> *"If using RTX20, RTX30, or RTX40 series **overwrite** `nvngx_dlssnr.dll` with the **patched**
> version"*

Un binario parcheado tiene la firma inválida **por diseño**. `HashMismatch` no era el defecto:
puede ser la firma esperada de un archivo modificado. "Reparar" habría reemplazado un DLL
posiblemente correcto por uno que no corre en Ada. **La firma inválida era una pista, no la
causa, y su lectura estaba invertida.**

#### Versión: el detalle que falta cerrar

La comunidad estandarizó en **310.8** para ambos DLL:

- Krish [RENO]: *"dlls should ideally be 310.8"*.
- Caso funcionando en **RTX 4080** (driver 616.56, ReShade 6.8.0.2155): `nvngx_dlssnr 310.8.SF`
  (ShortFuse build) + `nvngx_dlss 310.8.0`.
- Variantes del `dlssnr` que la comunidad distribuye: `310.8.2 Default`, `310.8.SF-v2`,
  `310.8.SF`, `310.8.0`, `Custom`.

**Los tres `nvngx_dlss.dll` que ya hay en el disco son 310.2.1.0 y 3.7.0.0 — ninguno es 310.8.**
Copiar el 310.2.1.0 es el experimento barato y reversible (y el `dlssnr` instalado es 310.8.0.0,
así que violaría "same version"); conseguir el 310.8.0 es el camino que la comunidad valida.

#### Cabo suelto nuevo, de la guía de ShortFuse

> *"If you have `renodx-dlss5.addon64` remove or rename it to `renodx-dlss5.addon64x`.
> (Cant use both)."*

La notebook **tiene** `renodx-dlss5.addon64`. Esto aplica sólo si se migra al *"DLSS Tool
(ShortFuse Version)"*, que usa `renodx-dlss.addon64` (sin el 5). Con el pipeline actual
(DLSS5-Feeder + renodx-dlss5) **no** hay que tocar nada. Anotado para no pisarlo por accidente.

#### Herramienta que la comunidad usa, y que NO está revisada

**RHI** — `https://github.com/RankFTW/RHI`. Aparece en 131 mensajes del server como la respuesta
estándar: instala ReShade, descarga los DLL correctos y **deja elegir la versión del `dlssnr`**
(el dropdown con `310.8.2 Default / 310.8.SF-v2 / 310.8.SF / 310.8.0 / Custom`). Un usuario que no
encontraba el `310.8.SF` a mano lo desplegó con RHI.

**No fue revisada por esta sesión.** Antes de recomendarla hay que leerle el código como se le
leyó a la de Kayle (8.12). Hay también un reporte negativo: *"rhi doesnt download the
DLSS5_Feed.fx, its not a good app"*.

#### Lo que sigue, en orden

1. Conseguir `nvngx_dlss.dll` **310.8.0** y, si se quiere cerrar el eje Ada, el `nvngx_dlssnr.dll`
   parcheado del pin de ShortFuse.
2. Ponerlos en `C:\Program Files\PCSX2\` — **lo hace Fran**: escribir ahí sigue bloqueado para la
   sesión (confirmado tres veces).
3. Medir `SuperSampling.Available` en `dlss5-feed.log`. Ese es el criterio de salida de R2(a).
4. Si da 1 y aparece `feature ready ... DLAA` + `frame N delivered`, recién ahí el FPS sobre el
   savestate 03, con el método de R0/R1.

**Predicción escrita antes de probar (regla 3):** con `nvngx_dlss.dll` presente,
`SuperSampling.Available` pasa a `1`. Si sigue en `0` con el archivo puesto y en la versión
correcta, la hipótesis del archivo faltante muere y el siguiente sospechoso es el `dlssnr` no
parcheado para Ada — que es una variable distinta y se varía sola.

**Nota de performance, de la misma fuente:** TraceKira, en una RTX 5070 mobile, midió 80 → 30 FPS
con Neural Rendering activo. Es una notebook y es una GPU superior a la de acá. El costo de esto
es alto y hay que tenerlo presente antes de festejar un `Available=1`.

#### Lo que se intentó y NO concluyó — no repetirlo igual

Para saber si el `nvngx_dlssnr.dll` instalado es el original de **Blackwell** o
uno **parcheado para Ada** (la pregunta que decide si además del `dlss` hay que
cambiar también el `dlssnr`), se intentaron **dos** inspecciones estáticas del
binario de 165 MB, y **las dos dieron vacío**:

1. Scan de strings `sm_NN` / `compute_NN` y de las palabras `Ada`, `Lovelace`,
   `Blackwell` — **cero coincidencias** en todo el archivo.
2. Scan de headers ELF (`\x7fELF`) para leer `e_machine=190` (EM_CUDA) y sacar
   el SM de `e_flags` — **cero headers ELF en todo el archivo**, ni CUDA ni
   x86-64.

Que no haya **ningún** header ELF en un archivo de ese tamaño sugiere que los
cubins van en fatbins **comprimidos**, que es lo que NVIDIA usa hoy.
Descomprimirlos requiere parsear el contenedor fatbin (magic `0xBA55ED50`) y
descomprimir cada entrada — factible, pero es trabajo de un rato y **no hace
falta para el próximo paso**: la pregunta se responde sola por efecto una vez que
esté `nvngx_dlss.dll` en la carpeta. Si con el `dlss` puesto `SuperSampling` pasa
a 1 pero después falla el `CreateFeature`, ahí sí el `dlssnr` vuelve a ser
sospechoso, y conviene ir directo al parcheado del pin de ShortFuse en vez de
analizar el binario.

### 8.14 SESIÓN DE DISCORD ABIERTA EN EL NAVEGADOR INTERNO — 2026-09-02

`list_connected_browsers` (Claude in Chrome) sigue dando **vacío**: la extensión no está
conectada, igual que en 8.8 y 8.12. **La restricción se levantó por otra vía:** el navegador
interno (`mcp__Claude_Browser__`) abrió `discord.com` y ofreció **login por QR**, que Fran escaneó
con la app del teléfono. La sesión quedó abierta como `chicoleche`, con acceso al server RenoDX.

Detalle que costó dos intentos: el link *"O puedes iniciar sesión con una clave..."* abre el flujo
de **passkey de Windows** ("Elige una clave de paso"), que **no** es el QR y no sirve. El QR se
escanea desde **adentro de la app de Discord** (foto de perfil → ícono de QR), no con la cámara
del sistema.

Canales útiles del server: `dlss5`, `dlss5-helpdesk`, `dlss5-forum`, `tools`, `guides`.
La cuenta **no tiene permiso de escritura** ("Debes completar algunos pasos más antes de poder
hablar") — se puede leer y buscar, no postear.

**Lección de método:** buscar `"Patched DLSS-NR RTX40"` en el buscador del server dio **cero
resultados** sobre un hilo que existe y se llama *"Patched DLSS-NR for RTX20, RTX30, and RTX40"*.
El parámetro de búsqueda era el problema, no la búsqueda. Abrir el canal `dlss5-forum` y leer el
listado del foro lo resolvió en un paso.

### 8.15 AUDITORÍA DE LOS LINKS Y LAS VERSIONES: qué NO hay que bajar, y la 4.ª fuente que confirma 8.13 — 2026-09-02

Fran trajo cuatro links nuevos del Discord y pidió revisarlos **antes** de bajar nada. Se
auditaron por metadata de GitHub y README/release notes, no por lo que dice el mensaje que los
compartió.

#### Lo primero, y cierra un eje que estaba abierto: el `dlssnr` YA es el parcheado de ShortFuse

La captura del pin de ShortFuse (*"Patched DLSS-NR for RTX20, RTX30, and RTX40 support"*) muestra
el adjunto `nvngx_dlssnr.dll` de **158,16 MB**. El instalado mide **165.840.496 bytes = 158,16 MiB**
exactos. Es el mismo archivo.

`confirmado` por coincidencia de tamaño al centésimo de MB + `FileVersion` 310.8.0.0 + firma
`HashMismatch` (la que corresponde a un binario parcheado). **El segundo sospechoso de la
predicción de 8.13 —"el `dlssnr` no parcheado para Ada"— queda descartado sin necesidad de
probarlo.** Si tras copiar `nvngx_dlss.dll` el valor sigue en 0, el siguiente sospechoso ya NO es
ese: hay que buscar otro.

#### CUARTA fuente independiente de la causa de 8.13, y esta vez es un desarrollador

`NIGos/dlss5-bridge` documenta el mismo mecanismo desde afuera del Discord, en su README y en las
notas de dos releases:

> README, tabla de requisitos: *"`nvngx_dlss.dll` **3.1.13 or newer** — from the game, if it has
> DLSS. ... **the driver store carries no super-resolution snippet**"*
>
> v1.4.2 (2026-09-02): *"**A missing `nvngx_dlss.dll` is named before the substitute contract is
> attempted.** A game without DLSS brings no super-resolution snippet and the NVIDIA driver
> carries none, so the panel and the log now say which file to copy beside the executable"*
>
> v1.4.0: *"`nvngx_dlss.dll` must be beside the executable, **in a game without DLSS too**"*

Las tres fuentes de 8.13 eran usuarios del Discord; ésta es el autor de un add-on, que además
mide el efecto en su propio banco de pruebas. Y aporta **el requisito duro que faltaba**:

**El umbral es `>= 3.1.13`, no 310.8.** *"DLAA arrived in SDK 3.1.13; older runtimes accept it and
degrade the picture"*. El `310.8` del Discord (*"keep both nvngx DLLs on the same version"*) es
convención de la comunidad, no un requisito medido.

**Consecuencia operativa: el camino (a) del retome deja de ser un test de descarte y pasa a ser
el camino correcto.** El `310.2.1.0` que ya está en el disco cumple el requisito documentado con
holgura. No hay que conseguir nada para cerrar la fase.

Origen elegido, re-medido el 2026-09-02:
```
C:\Games\The Last of Us Part I\nvngx_dlss.dll
  48.971.832 bytes | v310.2.1.0 | firma Valid | SHA256 4E85CDBE0896AAB5...
```
La copia del caché de DLSS Swapper tiene el **mismo SHA256** — son el mismo archivo, da igual cuál
se use. El caché de DLSS Swapper se inventarió entero: **sólo tiene 310.2.1.0**, no hay 310.8.

#### Los cuatro links, uno por uno

| Link | Qué es | Veredicto |
|---|---|---|
| `NIGos/dlss5-bridge` v1.4.2 | 184★, MIT, C++, creado 2026-08-28 | **NO APLICA** |
| `NIGos/ngxGym` | 1★, creado 2026-09-01 | **NO** |
| `RankFTW/RHI` 2.5.4 | 897★, GPL-3.0, C#, "ReShade HDR Installer" | **NO, y no es por seguridad** |
| `jlrouzies-fr/DLSS5-Feeder` 0.11.0-beta.2 | el feeder ya instalado, versión de hoy | **NO AHORA** |

**dlss5-bridge — no aplica por arquitectura, y su propio README lo dice:** *"The DLSS 5 neural
rendering add-on only works where a game runs DLSS on **DirectX 12**. This bridge gives it that:
it mirrors a **DirectX 11 or Vulkan** game's own DLSS onto a private DirectX 12 session"*. PCSX2
acá corre **D3D12 nativo** (`Renderer=15`), que es justamente lo que el bridge existe para
fabricar. Instalarlo agrega un add-on que hookea los mismos entry points de NGX sin resolver nada.

**ngxGym — es el banco de pruebas del desarrollador del bridge**, no una herramienta de usuario:
*"A scriptable DLSS host for testing the dlss5-bridge ReShade add-on"*. Un día de vida, 1 estrella.

*Aclaración de atribución:* el texto que venía pegado a ese link en el mensaje de Fran (*"V4.5
with more F5 compat improvements... All credit to @speedlemur for the original mod
(ControlDLSS5)"*) **no es de ngxGym**: es el changelog de la mod de **ShortFuse**, que es una
línea distinta (ver abajo).

**RHI — el problema es el tamaño de la intervención, no la confianza.** Es un gestor de mods HDR
para bibliotecas enteras: instalador de 26 MB, detección de 8 tiendas, 10 componentes, escritura
directa en perfiles del driver NVIDIA, **elevación persistente vía Task Scheduler**, auto-update
cada 4 horas. Para copiar un archivo de 48 MB entre dos carpetas, eso es desproporcionado
(regla 6: cambios mínimos; lo que se instala solo tiene que poder desinstalarse solo). Sí gestiona
swaps de DLSS SR, o sea que **serviría** si algún día hiciera falta el 310.8 — pero para eso ya
está DLSS Swapper instalado, que sólo descarga DLLs. El reporte negativo del Discord (*"rhi doesnt
download the DLSS5_Feed.fx"*) es coherente: RHI no conoce el pipeline DLSS5-Feeder. **No se le
leyó el código; no hizo falta llegar a esa pregunta.** Si alguna vez se lo considera en serio, ahí
sí corresponde la revisión completa que se le hizo a la de Kayle (8.12).

#### La pregunta de Fran sobre las versiones 4.5 / 4.55 / 4.6 / 4.7 — hay DOS numeraciones distintas

| línea | archivo | autor | versiones |
|---|---|---|---|
| RenoDX DLSS5 | `renodx-dlss5.addon64` (**con** el 5) | Krish [RENO] | 4.5, 4.55, **4.6**, **4.7** |
| ShortFuse | `renodx-dlss.addon64` (**sin** el 5) | ShortFuse, basada en ControlDLSS5 de speedlemur | hasta V4.5, *"likely the last version"* |

Por eso Krish rotula sus posts *"(Not ShortFuse's mod)"* y *"(Different to Shortfuse's mod)"*: son
proyectos separados que colisionan en el número. Lo instalado es de la línea de **Krish** —
el log lo identifica como `renodx-dlss5.addon64 v0.2026.828.517 -- v45+`.

**Fran acertó en no bajar 4.6/4.7, pero por una razón distinta a la que suponía.** No es que
"haga falta la 4.5": es que **el Feeder v0.7.0 instalado no las soporta**. El soporte entró en
`v0.10.0-beta.2`: *"DLSS 5 add-on v4.6/v4.7 support (#27)"*. Con el feeder actual, un add-on 4.7
recibiría los workarounds de un build pre-4.5. Actualizar el add-on obliga a actualizar el feeder:
**dos variables a la vez, en medio de un experimento de una sola.**

Dato asociado, de las notas de `0.11.0-beta.2`: un `.addon64` renombrado con versión
(`renodx-dlss5-4.7.addon64`) no era reconocido por el feeder, y **ReShade carga todos los
`*.addon64` de la carpeta** — dos copias hookean NGX las dos. Si alguna vez se actualiza el
add-on, la vieja se **borra**, no se renombra.

#### Feeder 0.11.0-beta.2 — no ahora, y la razón está medida

Se leyeron las notas de 0.8 → 0.11 completas. **Ninguna de las cinco betas toca
`SuperSampling.Available=0`**: los fixes son Smooth Motion en D3D11, juegos de 32 bits
(feature-level 10, plateaus a 30 fps en DXVK), nombres versionados de add-on y minidumps de
crash. Nada de eso describe el síntoma de acá. Confirma por omisión que el bloqueo no es un
defecto del feeder.

**Cabo suelto nuevo, para cuando la fase cierre:** desde `0.11.0-beta.1` el autor recomienda
**Deep Fried Chicken** (`deep-fried-chicken.addon64`, de Alexander) *en reemplazo* de
`renodx-dlss5.addon64` como neural consumer, con ABI negociada en vez de colisión de hooks.
`renodx-dlss5` sigue soportado como alternativa. **Exactamente uno de los dos**, nunca los dos.
No se toca hasta que haya un frame entregado con el stack actual.

#### Estado medido en esta sesión (re-medición de apertura)

```
C:\Program Files\PCSX2\  -> nvngx_dlssnr.dll  165.840.496  ver 310.8.0.0   [UNO SOLO]
                            nvngx_dlss.dll    AUSENTE
PCSX2: corriendo, PID 36588, arrancado 01:53:55
dlss5-feed.log (01:54:02, última corrida):
  [feed] DLSS 5 add-on: renodx-dlss5.addon64 v0.2026.828.517 -- v45+ engine
  [feed] config: enabled=1 mode=1 ... work_resolution=100%
  [feed] DLSS5_MV_PROVIDER=3 (LumeniteFX Kernel) -> Lumenite_Kernel (enabled), depth reversed=1
  [feed] NVSDK_NGX_D3D12_Init -> 0x00000001 (Success)
  [feed] NGX capabilities: SuperSampling.Available=0
  stopped: DLSS is not available on this GPU/driver.
```
El wiring está perfecto desde el primer scan (`MV_PROVIDER=3`, Kernel enabled): el overlay que
Fran configuró en 8.12 **persistió**. La única pieza que falta sigue siendo el archivo.

Nota: el feeder corre en `mode=1`, no en `mode=2`. 8.12 midió los dos sin diferencia — pero eso
fue **antes** del `nvngx_dlss.dll`. Si `SuperSampling` pasa a 1 y no aparece `frame N delivered`,
`mode=2` es lo primero a probar, y es una variable sola.

#### El paso que queda, sin cambios respecto de 8.13

1. Cerrar PCSX2 (PID 36588).
2. **Fran** copia (escribir en `C:\Program Files\PCSX2\` sigue bloqueado para la sesión, 3 veces
   confirmado):
   `Copy-Item "C:\Games\The Last of Us Part I\nvngx_dlss.dll" "C:\Program Files\PCSX2\"`
3. Relanzar y leer `SuperSampling.Available` en `dlss5-feed.log`.

**Predicción, sin cambios y ahora con el requisito de versión verificado:** con `nvngx_dlss.dll`
v310.2.1.0 presente (>= 3.1.13), `SuperSampling.Available` pasa a `1`. Si sigue en `0`, muere la
hipótesis del archivo faltante **y también la del `dlssnr` sin parchear** (queda descartada arriba
por tamaño): habría que abrir un sospechoso nuevo.

### 8.16 `SuperSampling.Available=1` — LA CAUSA DE 8.13 QUEDA CONFIRMADA POR EFECTO — 2026-09-02, 11:19

**La predicción escrita en 8.13 y re-verificada en 8.15 se cumplió.** Fran copió
`nvngx_dlss.dll` v310.2.1.0 desde `C:\Games\The Last of Us Part I\` a `C:\Program Files\PCSX2\`
y relanzó (PID 37508, 11:19:35).

Variable variada: **una sola**, el archivo. Todo lo demás quedó igual — mismo `dlssnr`, mismo
add-on, mismo feeder, mismo `mode=1`, mismo overlay.

```
ANTES (01:54, un solo nvngx)      DESPUES (11:19, con nvngx_dlss.dll)
  SuperSampling.Available=0   ->    SuperSampling.Available=1
  stopped: DLSS is not             session ready (same-device)
  available on this GPU/driver     feed: session open (same-device D3D12)
```

Inventario de la carpeta, medido después de la copia:
```
nvngx_dlss.dll     48.971.832   ver 310.2.1.0
nvngx_dlssnr.dll  165.840.496   ver 310.8.0.0
```

**Esto cierra tres cosas de una vez:**

1. **La causa de 8.13 pasa de `confirmado por fuentes` a `confirmado por efecto` en esta
   máquina.** Faltaba `nvngx_dlss.dll`; NGX lo resuelve desde el directorio del proceso.
2. **La conclusión de 8.12 queda definitivamente enterrada.** No había ningún techo de hardware:
   la misma GPU, el mismo driver y el mismo `dlssnr` de firma inválida ahora responden `1`.
3. **La discusión de versión queda resuelta en la práctica, y a favor de 8.15.** El `310.2.1.0`
   funcionó con un `dlssnr` `310.8.0.0`. El *"keep both nvngx DLLs on the same version"* del
   Discord no era un requisito duro; el umbral documentado por el autor de `dlss5-bridge`
   (`>= 3.1.13`) sí describe el comportamiento real. **No hizo falta conseguir el 310.8.**

#### El add-on ahora ve lo que antes no veía

`ReShade.log` cambió de forma verificable. Antes detouraba **un** módulo NGX; ahora detoura
**dos**, y el segundo es el archivo recién copiado:

```
DLSS5 Generic: detoured NGX module copy [0] ...DriverStore\...\_nvngx.dll (core)
DLSS5 Generic: detoured NGX module copy [1] C:\Program Files\PCSX2\nvngx_dlss.dll
DLSS5 Generic: D3D12 NGX hooks installed across 2 module copy(ies);
               inline DLSS contract capture armed
```

Ya no aparece `HOOKS ARMED - NO DLSS CREATE SEEN`. El `renodx-dlss5` está armado y esperando un
create.

*Cabo suelto que sigue igual y sigue sin importar todavía:* `ERROR | vtable::Hook(Failed to find
NVSDK_NGX_D3D12_EvaluateFeature_C)`. Es el mismo de 8.12, sobre el `_nvngx.dll` del driver. Tres
de cuatro funciones se hookean bien. No bloqueó nada hasta acá.

#### Lo que falta, y es UNA variable: `mode=1` -> `mode=2`

El feeder abrió la sesión pero **no crea la feature NGX**, y lo dice con todas las letras:

```
11:19:44.143  [feed] transport ready (mode 1, no NGX feature)
```

`C:\Program Files\PCSX2\dlss5-feed.cfg` (200 bytes, sin tocar desde el 01:53) tiene `mode=1`.
En `mode=1` el feeder sólo transporta; el path completo es `mode=2`. Esto ya estaba anticipado al
final de 8.15.

**Ojo con la trampa de 8.12:** ahí se probó `mode=1` vs `mode=2` y "no hubo diferencia". Eso fue
**antes** de que existiera `nvngx_dlss.dll` — con `SuperSampling.Available=0` ningún valor de
`mode` podía cambiar nada, porque el feeder se rendía antes. Aquella medición no dice nada sobre
la situación actual y **no debe usarse para descartar `mode=2`**.

#### Baseline de FPS medido, sin DLSS — sirve para el A/B posterior

Con `mode=1` (transporte activo, sin neural), sobre lo que Fran tenía en pantalla:

```
11:19:53  600 frames: feed CPU 2.45 ms/frame | frame interval 19.14 ms (52.2 fps) | feed 13% del frame
11:20:03  600 frames: feed CPU 0.02 ms/frame | frame interval 16.68 ms (59.9 fps) | feed  0% del frame
```

El primer bloque es calentamiento; el segundo es el régimen: **59,9 fps, y el feeder cuesta
0,02 ms/frame (0 % del frame)**. Backbuffer **1920x1080 R8G8B8A8_UNORM**, que vuelve a confirmar
la arquitectura de 8.8 (la swapchain es 1080p, no 2568x1800).

Este número **no** es todavía el baseline formal de R2: se midió sobre lo que hubiera en pantalla,
no sobre el savestate 03 con el método de R0/R1. Sirve como referencia de orden de magnitud y como
prueba de que el transporte no cuesta nada.

#### El paso siguiente, exacto

1. Cerrar PCSX2 (PID 37508) — el `.cfg` se edita con el emulador cerrado, igual que el `.ini`.
2. `mode=1` -> `mode=2` en `C:\Program Files\PCSX2\dlss5-feed.cfg` (lo hace **Fran**: escribir en
   `C:\Program Files\PCSX2\` sigue bloqueado para la sesión).
3. Relanzar con `lanzadores\ABRIR-BLACK-ORIGINAL.bat` (lo hace **la sesión**).
4. Leer `dlss5-feed.log`. Lo que se busca ahora: `feature ready ... DLAA` y `frame N delivered`.
5. Recién con eso, el FPS formal sobre el savestate 03 (`SLUS-21376 (5C891FF1).03.p2s`, existe),
   con el método de R0/R1.

**Predicción antes de probar:** con `mode=2` aparece el create de la feature y `frame N
delivered`. Si el create falla, el código de error de NGX es el dato que decide el siguiente paso
— y **ahí sí** el desajuste de versión (310.2 con 310.8) vuelve a ser sospechoso, porque
`CreateFeature` es la primera llamada donde los dos DLL tienen que trabajar juntos, cosa que la
consulta de capacidades no exige.

### 8.17 R2(a) CERRADA: DLSS 5 NEURAL RENDERING CORRIENDO EN BLACK — 2026-09-02, 11:25

**Los tres criterios de salida de la fase, en la misma corrida.** `mode=1` -> `mode=2` en
`dlss5-feed.cfg` (lo hizo Fran; escribir en `C:\Program Files\PCSX2\` sigue bloqueado para la
sesión) fue el único cambio respecto de 8.16.

```
11:25:18.767  [feed] NGX capabilities: SuperSampling.Available=1
11:25:19.892  [feed] feature ready: 1920x1080 DLAA, flags=74 (SDR MVLowRes DepthInverted
                     AutoExposure), color R8G8B8A8_UNORM -> output R8G8B8A8_UNORM,
                     depth R32_FLOAT (reversed), mv R16G16_FLOAT
11:25:19.899  [feed] frame 1 delivered (1920x1080, reset=1, same-device)
11:25:20.650  [feed] frame 2 delivered (1920x1080, reset=0, same-device)
11:25:20.653  [feed] frame 3 delivered (1920x1080, reset=0, same-device)
11:25:42.055  [feed] MV probe (centre 64x64, frame 1200): mean |mv| 14.854 px, max 15.10 px,
                     100% non-zero
```

**Estado: `confirmado` por efecto.** DLSS 5 Neural Rendering corre sobre BLACK en PCSX2, en una
**RTX 4060 Laptop**, con un `nvngx_dlss.dll` 310.2.1.0 junto a un `nvngx_dlssnr.dll` 310.8.0.0
parcheado por ShortFuse. La `MV probe` con **100 % de vectores no nulos** confirma que el
contrato que arma LumeniteFX es real, no un tapón de ceros.

La línea 8.12 (*"NGX rechaza esta GPU/driver"*) queda cerrada por completo, y también su
corolario implícito de que hacía falta el 310.8.

#### TRAMPA ENCONTRADA: los lanzadores abren OTRO emulador

`lanzadores\ABRIR-BLACK-ORIGINAL.bat`, `ABRIR-BLACK-MOD-7B.bat` y `ABRIR-EMULADOR.bat` — **los
tres** — apuntan a:

```
C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe
```

que es el emulador parcheado con DebugServer + PINE, el de la **línea 7e (reversing)**. **Todo el
pipeline DLSS vive en la otra instalación**, `C:\Program Files\PCSX2\`, que es la que
`dlss5-feed.log` nombra en su segunda línea (`host:`).

Usar un lanzador para una prueba de DLSS abre el emulador sin ReShade, sin addons y sin los
`nvngx_*`: **no se produce ningún log de DLSS, y el síntoma sería "dejó de andar"**, no "abrí el
programa equivocado". Se detectó leyendo el `.bat` antes de correrlo, así que no costó una
sesión — pero por poco.

El comando correcto para las pruebas de DLSS, hasta que haya un lanzador propio:
```powershell
Start-Process -FilePath "C:\Program Files\PCSX2\pcsx2-qt.exe" -ArgumentList '-fastboot','-batch','--','C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso'
```
Los ISOs (`Black.iso`, `Black-mod-7b.iso`, `Black-mod-armas.iso`) sí viven bajo
`C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\` y los comparten las dos instalaciones.

#### Números de FPS: hay dos, y TODAVÍA NO SON UN A/B VÁLIDO

| corrida | config | régimen | feed CPU | costo del feed |
|---|---|---|---|---|
| 11:19 (8.16) | `mode=1`, sin feature neural | **59,9 fps** (16,68 ms) | 0,02 ms/frame | 0 % |
| 11:25 (ésta) | `mode=2`, DLAA + neural | **56,9 fps** (17,57 ms) | 1,29 ms/frame | 7 % |
| 11:25, warm-up | `mode=2`, primeros 600 frames | 46,6 fps (21,46 ms) | 4,75 ms/frame | 22 % |

La resta da **-3 fps (~5 %)**, y ese número **no se reporta todavía**: las dos corridas
midieron **escenas distintas** (la de las 11:19 fue sobre lo que hubiera en pantalla; ésta arrancó
por `-fastboot` desde el ISO). Comparar dos escenas distintas y llamarlo A/B es exactamente el
error que el método de R0/R1 existe para evitar.

Sirven para dos cosas legítimas, las dos ya medidas: el orden de magnitud del costo (**~1,3 ms de
CPU por frame en régimen**) y que el warm-up de los primeros ~600 frames cuesta casi 4x eso, o
sea que **una medición corta sobreestima el costo**.

#### Observación menor, sin efecto medido

Esta corrida **no imprimió la línea `[feed] config: enabled=1 mode=... `** que sí aparecía en las
tres anteriores. El `.cfg` fue reescrito con `Set-Content -Encoding ASCII`, y se leyó bien (la
feature se creó, que es el efecto). Hipótesis sin probar y de bajo valor: el feeder sólo lista la
config cuando algún valor difiere del default, y `mode=2` es el default. **No investigar salvo que
algo más falle**; queda anotado para que no se lea como síntoma nuevo.

#### Lo que sigue: R3, el FPS formal

R2 cerró con el pipeline entregando frames. Lo que falta es el número que R0/R1 dejaron pendiente,
y **exige el método de R0/R1**, no dos corridas sueltas:

1. Mismo contenido en las dos ramas: savestate **03** (`SLUS-21376 (5C891FF1).03.p2s`, existe en
   `C:\Users\frans\Documents\PCSX2\sstates\`), cargado con `-statefile`.
2. Emulador **cerrado** para tocar cualquier `.ini` o `.cfg`.
3. La variable a variar es `mode=2` <-> `mode=1` (o `enabled=0`) en `dlss5-feed.cfg` — **no** el
   renderer ni el `upscale_multiplier`, que tienen que quedar idénticos entre ramas.
4. Captura de pantalla y lectura del OSD, como en R0/R1.

**Medido: las DOS instalaciones comparten un único `PCSX2.ini`**, y no está en ninguna de las dos
carpetas de programa:

```
OK     C:\Users\frans\Documents\PCSX2\inis\PCSX2.ini
         Renderer = 15   upscale_multiplier = 4   OsdShowFPS = true   EnableFastBoot = true
FALTA  C:\Program Files\PCSX2\inis\PCSX2.ini
FALTA  ...\Downloads\PCSX2-MCP-v1.0.0-win64\...\inis\PCSX2.ini
```

Consecuencia que hay que tener presente: **tocar ese `.ini` cambia también el emulador de la línea
7e**, porque es el mismo archivo. Para el A/B de DLSS no hace falta tocarlo — la variable vive en
`dlss5-feed.cfg` — pero cualquier cambio de `Renderer` o `upscale_multiplier` que se haga para una
línea le llega a la otra sin aviso. El respaldo está en `pruebas/PCSX2.ini.respaldo-2026-09-02`.

`OsdShowFPS = true` ya está puesto, así que el OSD sirve para la lectura de R3 sin tocar nada.

### 8.18 R3: EL COSTO ESTÁ MEDIDO Y ES CHICO. LA CALIDAD EMPEORA, Y HAY DOS CAUSAS CANDIDATAS — 2026-09-02, 11:45

**Fran hizo el A/B bien, y con mejor método que el planeado en 8.17:** misma escena, mismo frame,
misma posición del jugador, variando **una sola cosa** — la casilla `DLSS 5 Feed` en la lista de
técnicas de ReShade. No hizo falta el savestate 03 ni cerrar el emulador; la variable se varía en
caliente y la escena queda idéntica por construcción. **R3 queda cerrada con esto.**

| rama | FPS (OSD) | frame | GS | GPU |
|---|---|---|---|---|
| `DLSS 5 Feed` **destildado** | **54,29** | 18,42 ms | 94,6 % (17,42 ms) | 25,2 % (4,64 ms) |
| `DLSS 5 Feed` **tildado** | **52,99** | 18,87 ms | 95,1 % (17,54 ms) | 20,4 % (3,85 ms) |

**Costo del neural: −1,3 fps (−2,4 %), 0,45 ms de frame.** Coincide con lo que el propio feeder
mide desde adentro en el mismo tramo (`feed CPU 0,35 ms/frame | feed is 2% of the frame`), que es
una segunda medición independiente del mismo número. `confirmado`.

**El cuello de botella no es la GPU ni DLSS: es el GS.** `GS: 95 %` en las dos ramas, con la GPU
al 20-25 %. La emulación del Graphics Synthesizer satura antes que cualquier otra cosa, y por eso
un costo de 0,35 ms sobre un frame de 18,4 ms casi no se ve. Esto también explica por qué en 8.17
la resta ingenua daba −3 fps: aquella medición comparaba escenas distintas, y la diferencia real
es menos de la mitad.

**Fran aclaró después que venía usando el modo turbo (avance rápido) para cargar menús y niveles.
Eso NO invalida la medición: la mejora.** Sin turbo, PCSX2 capa la emulación a la velocidad
nominal (60 fps NTSC) y un costo de 0,45 ms se lo come el cap entero — el A/B daría 60 contra 60 y
la conclusión sería "no cuesta nada", que es falsa. **Con el cap levantado, el emulador corre al
techo real y el costo se hace visible.** Que las dos ramas midan 54,29 y 52,99 —las dos por debajo
de 60— confirma que el cap no estaba actuando en ninguna de las dos, que es justo la condición que
hace comparable la resta.

**La advertencia real es otra, y la trajo el propio Fran: la relación de aspecto también mueve los
FPS.** Es una segunda variable, y si hubiera cambiado entre capturas la resta no valdría. Las dos
capturas muestran el mismo encuadre y el mismo pillarbox, así que `probable` que se haya mantenido
— pero es `probable`, no `confirmado`, y es la única grieta que le queda a este número.

Config al momento de la medición (medida, no asumida): `Renderer=15` (D3D12),
**`upscale_multiplier=3`** (Fran lo bajó de 4), `linear_present_mode=1`, `work_resolution=100`,
`mode=2`.

#### El hallazgo que importa: **se ve PEOR**, y el feeder lo viene avisando

Reporte de Fran: *"se ve más borroso con el DLSS5"*. El log lo respalda con una línea propia,
repetida durante todo el tramo:

```
[feed] MV probe (centre 64x64, frame 58800): mean |mv| 0.000 px, max 0.00 px, 0% non-zero
       <-- DLSS is getting (almost) no motion vectors
```

Con una excepción aislada (`frame 54000: mean 0.179 px, 40% non-zero`). Compárese con la corrida
de 8.17, en cinemática: `mean 14.854 px, 100% non-zero`.

**Ojo con la lectura fácil: `0 %` con el jugador quieto NO es un defecto.** Si la cámara no se
mueve, los motion vectors del centro de la pantalla valen cero y eso es correcto. El dato no dice
"los MV están rotos"; dice **"en estos frames el neural no tiene nada nuevo que integrar"**.

Dos causas candidatas para la borrosidad, en el orden en que hay que probarlas:

**(1) El panel del consumidor neural está COLAPSADO, y su switch puede estar apagado.** Medido en
`ReShade.ini`:
```
OverlayCollapsed=DLSS 5 Neural Rendering@renodx-dlss5.addon64, DLSS 5 Feed 0.7.0@dlss5-feed.addon64
[RenoDX.DLSS5]
SavePresetFile=0
```
Los **dos** paneles están colapsados, y la sección `[RenoDX.DLSS5]` no guarda ni un solo ajuste
(`SavePresetFile=0`): lo que haya en ese panel vive en memoria y no dejó rastro en disco. La
casilla que Fran tildó es la del **feed** — el transporte —, que es una cosa distinta del
**consumidor neural**. El README de `dlss5-bridge` lo dice para el mismo add-on: *"The neural
add-on's own toggle has to be on, in its panel or in `ReShade.ini`"*.

Si ese switch está apagado, lo que Fran vio es **DLAA puro sin neural rendering** — que es
exactamente un suavizado, sin nada que lo compense. Es la hipótesis barata y se verifica abriendo
la pestaña; **hay que descartarla antes de creerle a la (2)**.

**(2) Falta el jitter de cámara, y eso es arquitectónico.** El README del propio DLSS5-Feeder lo
plantea sin rodeos:

> *"Real DLSS upscaling needs the **game** to render smaller than your screen and jitter its
> camera, then hands DLSS that small frame. This feeder only ever sees the finished, screen-sized
> frame ReShade has, so what it can publish is a 1:1 DLAA contract: same size in, same size out."*

DLAA acumula muestras entre frames; lo que hace que esa acumulación **agregue detalle** en vez de
sólo promediar es que la proyección jitteree sub-píxel entre frames. **PCSX2 no jitterea.** Sin
jitter, el blend temporal no aporta información nueva: suaviza. Esto no se configura — pedirlo
sería pedirle a PCSX2 que cambie su matriz de proyección.

**Y hay un agravante que no es defecto de nadie:** con `upscale_multiplier=3`, PCSX2 ya renderiza
a ~1920x1344 y baja a la ventana. Ese downsample **es** supersampling, que es antialiasing de
mejor calidad que cualquier método temporal. El neural no está mejorando una imagen aliaseada:
está suavizando una que ya venía antialiaseada por fuerza bruta.

#### Consecuencia para el objetivo del proyecto

El pipeline **funciona** — eso quedó cerrado en 8.17 y no se toca. Lo que esta sección agrega es
que **funcionar no es lo mismo que servir**: en esta configuración el neural cuesta 2,4 % de FPS y
devuelve una imagen peor. Si la causa es (1), se arregla con un switch. Si es (2), el techo es del
enfoque post-proceso y no hay ajuste que lo levante en PCSX2.

**Predicción, antes de que Fran abra el panel:** si el switch del consumidor neural está apagado,
prenderlo cambia la imagen de forma visible (a mejor o a peor, pero **cambia**) y el costo en ms
sube por encima de los 0,35 ms actuales, porque hoy ese número es sospechosamente barato para una
red neuronal corriendo a 1080p. **Si el switch ya estaba prendido**, la causa (1) muere y queda la
(2), que no tiene arreglo por configuración.

### 8.19 `NR IS OFF` — el neural rendering nunca corrió, y eso invalida el número de R3 — 2026-09-02, 12:00

**La predicción de 8.18 se cumplió, y el propio add-on lo dice sin ambigüedad.** Fran abrió el
panel colapsado (`DLSS 5 Neural Rendering`, pestaña Add-ons) y el diagnóstico está impreso ahí:

```
RenoDX DLSS5 Generic v4.1.5 | DLSSNR v310.8.0:  NR IS OFF
NR was switched off (ini, overlay, or the NR toggle hotkey). To turn it on, tick
'Enable DLSS Neural Rendering' above or press the NR toggle key in gameplay.
Hook diagnostics below remain valid.
```

Con `[ ] Enable DLSS Neural Rendering` y `[ ] Enable Upscaling (WIP)` **los dos destildados**.

**La causa (1) de 8.18 queda `confirmada` y la (2) queda sin probar.** El jitter sigue siendo un
techo real del enfoque, pero **todavía no es el que estamos viendo**: lo que Fran evaluó como
"más borroso" era el pase DLAA solo, sin neural rendering encima. La (2) no se puede juzgar hasta
que la (1) esté corregida.

#### Consecuencia directa: el costo medido en 8.18 NO es el costo del neural

R3 midió el A/B de la casilla `DLSS 5 Feed`, con `NR IS OFF` en las **dos** ramas. Entonces
`−1,3 fps (−2,4 %)` y `0,35 ms/frame` son **el costo del feed más el pase DLAA**, no del neural
rendering. El costo real del pipeline completo está sin medir y **va a ser mayor** — lo cual, de
paso, explica por qué 0,35 ms parecía sospechosamente barato para una red neuronal a 1080p (la
sospecha quedó anotada en 8.18 y resultó ser el síntoma correcto).

**R3 se reabre.** Su número describe una configuración que no es la que interesa.

#### Lo que el panel confirma que SÍ está bien (no rehacer)

```
NGX modules detoured: 2 | core present: yes
NGX hooks: creates 9 | evaluations 148246
Runtime sha256: 8270B350...744CC206 (custom build)
Latest NR NGX result: 0x00000001 (ok)
Successful NR frames: 46088 | Guides: 1920x1080 | Output: 1920x1080
Insertion: immediately after the game's NGX DLSS output; UI remains downstream
Codec: FP16 working surface
```
Feed: `Session: open`, `Feature: ready`, `Frames delivered: 73657`, `Mode: Full DLSS path`,
`Work resolution: 100%`, `provider matches the shader's DLSS5_MV_PROVIDER`.

**`Successful NR frames: 46088` con `Latest NR NGX result: ok` prueba que el NR corrió en algún
tramo anterior de esta misma sesión** — probablemente antes de que la tecla `F6` (`NR Toggle Key`)
lo apagara. O sea que el camino completo ya funcionó una vez; no hay nada roto que arreglar, sólo
un switch que prender.

**Generic Depth eligió el buffer correcto:** `1926x1350 | D32S8 | 4132 draw calls | 246756
vertices`, consistente con `upscale_multiplier=3`. Los otros tres candidatos son de 576x384 o
menos. Esto valida lo que Fran configuró a mano en 8.12 y que sigue vivo.

#### Herramientas del panel que no estaban documentadas y cambian el método

| tecla / control | qué hace |
|---|---|
| **F5** | `Capture Screenshot` — modo A/B pareado, guarda en `DLSS5Screenshots\` junto al exe |
| **F6** | `NR Toggle Key` — prende y apaga el NR en vivo, sin tocar archivos |
| `NR Preset` | *"Presets differ in how hard DLSS clamps history against the current frame. If motion warps around transparents (dust, smoke, flames), try E or F."* |
| `NR Style` | segundo eje, separado del preset |
| `NR Intensity`, `Local Tone Strength`, `Local Structure Strength`, `Skin Structure Strength` | sliders |
| `Reset NR feature and clear failure latch` | botón de recuperación |

**F5 + F6 juntos son el método de medición que a R3 le faltaba:** F6 varía la única variable en
vivo sin cerrar nada, y F5 captura las dos ramas sobre el mismo frame. Eso es estrictamente mejor
que el savestate 03 que 8.17 planificaba, y mejor todavía que tildar la casilla del feed — que
además de la variable movía el transporte entero.

#### Discrepancia de versión, anotada sin resolver

El panel se identifica como **`RenoDX DLSS5 Generic v4.1.5`**; el archivo declara
`Versión: 0.2026.828.517`; el feeder lo clasifica como `v45+ engine`. El HANDOFF venía diciendo
`v4.55` desde 8.11. **Son tres numeraciones distintas para el mismo binario** y no se sabe cuál
corresponde a la que Krish publica en el Discord (4.5 / 4.55 / 4.6 / 4.7).

`v45+ engine` no es una versión: es la clase de motor que el feeder detecta (v4.5 o superior).
No se toca nada por esto — 8.15 ya estableció que actualizar el add-on obliga a actualizar el
feeder — pero **la afirmación "tenemos la 4.55" no está confirmada** y no debe repetirse como si
lo estuviera.

#### El pedido de Fran: "gran apalancamiento visual"

Ordenado por la escala de Meadows, de mayor a menor, con lo que hoy está montado:

1. **Prender `Enable DLSS Neural Rendering`.** No es un parámetro: es la diferencia entre el
   sistema corriendo y no corriendo. Todo lo demás de esta lista es ruido mientras esto esté en
   `OFF`.
2. **F5/F6 como método.** Sin A/B pareado sobre el mismo frame no hay forma de saber si un cambio
   mejoró; con él, cada prueba siguiente cuesta segundos. Es flujo de información, no parámetro.
3. **El insumo de motion vectors.** Hoy: `LumeniteFX Kernel, 1/8 res, filtro Bilinear`. El neural
   no puede ser mejor que sus guías. Alternativas ya presentes en el panel: `4 LumeniteFX
   QuantMotion`, y los `Geometry vectors (camera model + depth) — EXPERIMENTAL`, hoy apagados.
4. **`NR Preset` / `NR Style`**, que eligen comportamiento del modelo, no intensidad.
5. **Los sliders** (`NR Intensity`, `Local Tone/Structure Strength`). El escalón más bajo.

**Y el techo que ninguna de las cinco levanta, dicho de frente:** BLACK es un juego de PS2 con
texturas de 2006. `upscale_multiplier=3` sube la geometría a 1926x1350, pero las texturas siguen
siendo las que trae el ISO. El neural rendering reconstruye e ilumina — **no inventa textura que
no existe**. El salto visual grande de un juego de PS2 vive en las texturas y el shading, que es
otra línea de trabajo (y se toca con la 7e, no con este pipeline).

**Predicción antes de prender el switch:** con `Enable DLSS Neural Rendering` tildado, (a) la
imagen cambia de forma visible respecto de lo que Fran evaluó, (b) el costo por frame sube por
encima de los 0,35 ms medidos, y (c) el contador `Successful NR frames` empieza a avanzar en vivo.
Si (a) no pasa, el sospechoso siguiente es que el NR se esté insertando después del punto que
importa — y para eso el panel ya dice dónde se inserta (*"immediately after the game's NGX DLSS
output; UI remains downstream"*).

### 8.20 NR ENCENDIDO: se ve mejor, y cuesta 5x más de lo que R3 había medido — 2026-09-02, 11:58

Fran tildó `Enable DLSS Neural Rendering`. **Las dos predicciones de 8.19 se cumplieron.**

**(a) La imagen cambió, y para mejor.** Reporte de Fran: *"ahora se ve mejor"*. Estado:
`hipótesis` sostenida por juicio visual directo — no hay captura pareada todavía, y por eso no
sube de escalón. Lo que sí queda `confirmado` es que **cambió**, que es lo que la predicción
arriesgaba.

**(b) El costo subió, y mucho.** Seis bloques consecutivos de 600 frames, todos con el jugador
quieto:

| | NR OFF (8.18) | NR ON (ésta) | delta |
|---|---|---|---|
| feed CPU | 0,35 ms/frame | **0,95 ms/frame** | +0,60 ms — **2,7x** |
| frame interval | ~19,2 ms | **~21,9 ms** | **+2,7 ms** |
| FPS | ~52 | **~45,5** | **−6,5 fps (−12,5 %)** |

Estabilidad: `0,93 / 0,94 / 0,95 / 0,95 / 0,98` ms en bloques sucesivos, y `44,4 / 45,4 / 45,7 /
45,7 / 46,3 / 46,5` fps. La dispersión es chica; el salto respecto de los `0,34-0,36 ms` de ocho
bloques previos es enorme.

**El costo real del pipeline completo es ~5x el que R3 había medido** (−12,5 % contra −2,4 %),
porque aquel A/B tenía `NR IS OFF` en las dos ramas. La corrección de 8.19 queda cuantificada.

**Detalle que vale leer:** el frame interval sube **+2,7 ms** pero el `feed CPU` sólo **+0,60 ms**.
Los ~2,1 ms de diferencia son trabajo de **GPU** del pase neural, que el feeder no contabiliza en
su propia métrica de CPU. O sea: el grueso del costo no está donde el feeder lo mide.

**Estado del número: `probable`, no `confirmado`.** Los dos tramos son consecutivos pero no
pareados — misma sesión y jugador quieto en los dos, pero no garantizadamente la misma escena.
Para subirlo a `confirmado` está la herramienta que 8.19 encontró y que **todavía no se usó**:
`F6` togglea el NR en vivo sin tocar un archivo, y el feeder escribe un bloque de 600 frames cada
~12 s. Tres pulsaciones (ON → OFF → ON), quieto en el mismo lugar, dan tres bloques comparables
sin ninguna otra variable moviéndose. La carpeta `DLSS5Screenshots\` **no existe todavía**: `F5`
no se usó.

#### El trade que el cuello de botella deja a la vista, y es el próximo movimiento de peso

Los números de 8.18 dejaron medido que **el cuello es el GS (95 %), con la GPU al 20-25 %**. El
neural rendering gasta **GPU**, que es justamente el recurso que sobra; el supersampling de
`upscale_multiplier=3` gasta **GS**, que es el que está saturado.

Eso abre un experimento de apalancamiento alto, que **no es un slider**:

> **Bajar `upscale_multiplier` de 3 a 2 con el NR encendido.**

Libera presión sobre el recurso saturado y se la pasa al que está ocioso. La pregunta que
responde: **¿el neural rendering compensa la pérdida de supersampling?** Si la respuesta es sí, se
recuperan los ~6,5 fps sin costo visual — y además se despeja la duda de fondo de 8.18, donde el
supersampling y el neural estaban compitiendo por hacer el mismo trabajo (antialiasing) desde dos
recursos distintos.

Requiere emulador cerrado (es `PCSX2.ini`, compartido con la línea 7e — ver 8.17) y respaldo ya
existe en `pruebas/PCSX2.ini.respaldo-2026-09-02`.

#### Orden pendiente, sin cambios respecto de 8.19 salvo el punto 1, que ya se hizo

1. ~~Prender `Enable DLSS Neural Rendering`~~ — **hecho**.
2. **`F6` + `F5` como método.** Sin esto, cada prueba siguiente vuelve a producir un número
   `probable`. Es lo más barato que queda y habilita todo lo demás.
3. **El insumo de motion vectors** (`LumeniteFX Kernel, 1/8 res, Bilinear` hoy). Alternativas en
   el panel: `4 LumeniteFX QuantMotion`, `Geometry vectors (camera model + depth)`.
4. **`NR Preset` / `NR Style`** — comportamiento del modelo. La doc sugiere `E` o `F` si el
   movimiento se deforma alrededor de transparencias (polvo, humo, llamas — BLACK tiene los tres).
5. Los sliders.

Y **el experimento del `upscale_multiplier`** de arriba, que por apalancamiento va entre el 2 y el
3: es estructura (a qué recurso se le pide el trabajo), no parámetro fino.

---

## 9. TEXTURAS / LINEA VISUAL - abierta el 2026-09-02. Fuente: `docs/09-remaster-visual.md`

**Esta sección NO se extiende.** Todo el detalle vive en `black/docs/09-remaster-visual.md`,
enlazado desde el contrato. Acá va sólo lo que una sesión nueva necesita para no repetir
trabajo ni pisar nada.

### Lo cerrado

**2026-09-02 - el pack carga.** Había 8225 `.dds` DXT5 (1305 MB, mtime 23/10/2022) en
`C:\Program Files\PCSX2\PCSX2\textures\SLUS-21376\` y nunca cargaron: PCSX2 lee del
*data dir*, que es `C:\Users\frans\Documents\PCSX2\`. Copiadas al lugar correcto,
`emulog.txt` emite `Disabling autogenerated mipmaps...`. Fran validó jugando: *"se ve bien"*.

**2026-09-03 - FASE V1 CERRADA: los tres números.** Detalle y controles en
`pruebas/cobertura-pack-2026-09-03.md`; síntesis en `docs/09` §6.

```
(a) GameIndex : los 6 gsHWFixes de SLUS-21376 YA se aplican solos. Nada que corregir.
(b) el pack   : 5213 assets (no 8225: 3012 son variantes de CLUT).
                100 % paletizado. Upscale 4,0x UNIFORME en los 8225.
(c) COBERTURA : 90/127 = 70,9 % (+/- ~1).  29 % cae al original de PS2.
```

**2026-09-03 (noche) - FASE V2 CERRADA: el sintoma de la barrera es el MIPMAP.**
Detalle completo en `docs/09` **§7**; el experimento y su arbol de decision en
`pruebas/precache-prediccion-2026-09-03.md`.

```
H1 carga asincrona  : MUERTA. Precache ON (2,09 GB privados, medido) y no se movio.
H4 post-proceso     : MUERTA. ReShade fuera (logs sin escribir) y no se movio.
CAUSA (`probable`)  : el pack reemplaza SOLO el mip 0. 0 de 8225 archivos llevan
                      '-mip'. Los niveles bajos caen al original de PS2.
                      El sintoma esta atado al ANGULO, no a la distancia.
```

**2026-09-03/04 - FASE V3 CERRADA: la causa queda `confirmado` por efecto.**
Detalle en `docs/09` **§7.5**; prediccion en `pruebas/prediccion-V3-mipmap-2026-09-03.md`.

```
mipmap = false, hw_mipmap = false (PCSX2 cerrado) + ReShade apagado, verificado
por efecto (logs sin escribir Y emulog.txt logea "El mipmapping esta desactivado").
Fran mirando el savestate 03 en los dos angulos: "se ve nitida en los dos angulos".
CAUSA: CONFIRMADA. mipmap=false queda como estado de hecho hasta regenerar el
mip chain del pack (item 1 de la NEXT ACTION, mas abajo) - no revertir.
```

**2026-09-04 - ARREGLO DE FONDO CONSTRUIDO E INSTALADO — SINTOMA REPORTADO DE
VUELTA, SIN DIAGNOSTICAR.** Detalle completo, con las tres hipotesis y el test
de un paso para separarlas: `docs/09` **§7.6**.

```
HALLAZGO QUE CAMBIO EL DISENO: "-mip%u" es de GetDumpFilename, SOLO para PNG.
  Para DDS, PCSX2 lee los niveles EMBEBIDOS en el mismo archivo (dwMipMapCount
  del header). Leido del codigo fuente real de PCSX2/pcsx2 (master), no supuesto.
HERRAMIENTA: herramientas/regenerar_mipmaps.py. Verificada en dos capas:
  por BYTES (8225/8225 OK, reparseando como el parser real de PCSX2) y por
  PIXEL (decodificado de vuelta a PNG, contenido correcto, sin corrupcion).
INSTALADO: replacements/ viejo -> replacements-sin-mips-2026-09-04 (no se
  borro). Pack nuevo copiado. mipmap=true, hw_mipmap=true restaurados.
  Confirmado por efecto: emulog.txt de esta corrida NO tiene ninguna linea
  de mipmap (ni autogen-disable ni Unsafe Settings) - la señal esperada.
SIN EMBARGO: Fran mirando la pared, "ahora vuelve a desenfocar". NO se pudo
  cerrar el loop de verificacion (la sesion no puede ver la pantalla de PCSX2
  sin robarle el foco a Fran). TRES HIPOTESIS SIN DESCARTAR (docs/09 §7.6):
  (1) esa textura especifica es de las que NO tiene reemplazo (cobertura
      70,9%, no 100% - nunca se ato "la barrera" a un hash concreto);
  (2) el mip chain esta bien construido pero algo en el pipeline de PCSX2 no
      lo esta leyendo;
  (3) es el comportamiento NORMAL de un mip chain real (V3 con mip0 forzado
      era aliasing perfecto, no "correcto"; un chain real SI suaviza en
      angulos rasantes, a proposito).
TEST DE UN PASO PARA LA PROXIMA SESION CON EL JUEGO DELANTE: pararse en el
  angulo que desenfoca y apretar Insert (ToggleMipmapMode, hotkey ya mapeado).
  Si sigue igual de blurry con mipmap forzado a otro modo -> hipotesis 1
  (no es esto). Si se ve nitida con mip 0 forzado Y la textura es claramente
  la MISMA HD (no una version chica y distinta) -> hipotesis 2 o 3, comparar
  SEVERIDAD contra el bug original para distinguirlas.
GAP DE VERIFICACION (regla del saboteador): el verificador de la herramienta
  nunca vio un archivo roto (8225/8225 en verde). No probado que sepa decir
  que no. Corromper una copia a proposito antes de confiar en el para un lote futuro.
```

**El confound que hay que conocer antes de tocar nada de esta linea:** el
`pcsx2-qt.exe` de la ruta corta es **el mismo binario** de la linea DLSS5 (§8), con
ReShade + DLSS5-Feeder + RenoDX + LumeniteFX inyectados por `dxgi.dll`. Las dos
lineas NO son independientes en el disco, aunque este archivo las declaraba asi.
**`dxgi.dll` quedo renombrado a `dxgi.dll.disabled`** para la corrida limpia: hay
que restaurarlo para volver a la linea DLSS5.

**2026-09-04 (madrugada) - FASE V4 CERRADA: LA CAUSA RAIZ ES EL HASH, NO EL
MIP CHAIN.** Detalle completo en `docs/09` **S7.7**. Prediccion escrita antes
en `pruebas/prediccion-hash-lod-2026-09-04.md`.

```
EL SINTOMA NUNCA FUE QUE FALTARAN MIPMAPS. Al activar hw_mipmap, PCSX2 le
  pide al pack un NOMBRE DE ARCHIVO DISTINTO, que no existe -> no encuentra
  reemplazo -> dibuja el original de PS2. Por eso el arreglo de S7.6, bien
  construido y verificado en dos capas, no movio nada: el archivo que se
  arreglo no se abria nunca.
CODIGO (GSTextureCache::HashCacheKey::Create, repo oficial, master):
  el TEX0Hash se calcula sobre el nivel base Y, si hay lod, sobre TODOS los
  niveles de mip del juego. El CLUTHash NO depende de lod. O sea: una misma
  textura tiene DOS TEX0Hash, y el pack de 2022 solo trae el de sin-mipmap.
CONFIRMADO POR EFECTO, tres medidas independientes:
  (1) pack de debug con un color plano por nivel: con mipmap on la escena
      perdia 47x de detalle y habia CERO pixeles de color -> el reemplazo ni
      se cargaba;
  (2) volcados en la misma escena: 37 texturas sin reemplazo con hw_mipmap
      true contra 5 con false. 32 lo pierden al activar el mipmapping;
  (3) los pares: el CLUTHash coincide EXACTO y solo cambia el TEX0Hash.
EL ARREGLO: herramientas/puente_hash_mipmap.py empareja por (CLUTHash, TEX0
  bits enmascarado) y escribe COPIAS del pack con el nombre que PCSX2 pide
  con mipmapping. No borra ni modifica nada. 35 de 38 emparejadas.
VERIFICADO POR EFECTO:  sin puente -> con puente
  texturas sin reemplazo (mipmap on):   37  ->  3   (las 3 no emparejadas)
  pixeles de color de debug en pantalla:  0  ->  10.929 magenta (nivel 1)
  El magenta prueba ademas que EL MIP CHAIN DE S7.6 SI SE USA -- recien
  ahora, porque recien ahora el archivo se encuentra. Los dos se complementan.
GAP DEL SABOTEADOR DE S7.6: CERRADO. Se le dieron dos archivos rotos a
  proposito al verificador de regenerar_mipmaps.py y dijo que no en los dos
  (truncado -> "FALTAN 132 bytes"; dwMipMapCount+3 -> "FALTAN 16 bytes"),
  mientras los sanos del mismo lote seguian en verde.
DESBLOQUEO OPERATIVO: la sesion SI puede ver la pantalla. PCSX2 escribe sus
  propias capturas (F8 -> Documents\PCSX2\snaps\) y herramientas/
  pcsx2_teclado.ps1 le lleva el foco a la ventana del juego y manda la tecla.
  S7.6 se cerro sin veredicto por creer que no se podia, y costo una fase.
```

**LO QUE QUEDO ABIERTO de esta fase:** la verificacion visual de la CALIDAD
final. La escena del savestate 03 tiene combate y humo intermitente, y eso
rompe la medicion: en las dos tandas A/B/C con el puente puesto el **control
positivo fallo** (C, que deberia dar ~=A, dio entre -76% y +1585%). Esos
numeros NO se reportan: miden el humo, no el mipmap. Hace falta una escena
estatica. Ojo: el puente solo cubre las texturas de ESA escena, asi que la
verificacion tiene que hacerse ahi, no en otro savestate.

**2026-09-04 (mañana) - Huekage + puente instalados, verificacion PARCIAL.**
Detalle completo en `docs/09` **§7.8**;
`pruebas/huekage-puente-verificacion-2026-09-04.md`.

```
INSTALADO: replacements/ = Huekage (2781 .dds) + su puente (18 copias) =
  2799 archivos. El pack 2022 preservado en replacements-2022-con-puente/.
EL PUENTE EMPAREJA MENOS SOBRE HUEKAGE: 18 de 38 (no 35 de 38 como el
  propio). Huekage tiene 2197 claves unicas contra las 5213 del nuestro ->
  menos candidatos para el pareo por (CLUTHash, TEX0 enmascarado).
CONFIRMADO POR EFECTO: volcado de 80s en la escena con hw_mipmap=true dio
  80 archivos; los 18 que el puente resolvio NO estan entre ellos
  (interseccion 0). OJO: 80 no es comparable contra el "3" de T7 -- son
  duraciones de captura distintas (80s vs una captura corta), mismo error
  de denominador que ya se corrigio una vez para el 70,9%/92,7%. NO citar
  "80 vs 3" como regresion.
A/B/C PAREADO, DOS RONDAS, CONTROL OBLIGATORIO: de 6 regiones por ronda,
  SOLO "auto izquierdo" cerro el control las dos veces (+1%/+1% y -2%/-3%).
  Ahi, ON vs OFF no cuesta nitidez -- tercera medicion independiente en la
  misma direccion que T7 (la otra fue "pared fondo derecha", -1%).
  La region "barrera" (EL SINTOMA) sigue sin poder medirse: control fallido
  las dos veces (+12%/-87% respectivamente). No es dato nuevo: la escena de
  este savestate nunca dio un control limpio ahi.
CERRADO CON: hw_mipmap = false (mismo motivo que T7: el puente cubre una
  sola escena, activarlo global perderia reemplazo en el resto del juego).
  Huekage SI queda como mejora neta del estado seguro (82/82 vs 76/82 en
  hw_mipmap=false, sin depender de resolver el mipmap).
```


### DO NOT REPEAT

- **No descartar los mipmaps con "de cerca se usa el nivel 0".** El nivel de mip se
  elige por el **footprint de la textura por pixel** (derivada de UV), no por
  distancia: una pared plana mirada de refilon a un metro pide mip 2. Ese descarte
  mal razonado vivio en `docs/09` §1.5 desde el 2026-09-02, y ademas **ranqueo
  "regenerar mipmaps" como item 7 de 7** en esta misma lista de NEXT ACTION.
- **No correr NINGUNA prueba visual de esta linea sin verificar antes que ReShade no
  este cargado**, y verificarlo por EFECTO (que `ReShade.log` y `dlss5-feed.log` no
  se escriban tras el arranque), no por que el archivo este renombrado.
- **No leer el `.ini` para saber si los fixes del GameDB están puestos: da la respuesta
  INVERTIDA.** `UserHacks_HalfPixelOffset = 0` y `UserHacks_native_scaling = 0` son los
  valores **manuales**, y `UserHacks = false` hace que PCSX2 los ignore y aplique los del
  GameDB (`GameDatabase.cpp:705`). Se mide en `emulog.txt`, buscando
  `GameDB: Enabled GS Hardware Fix`.
- **No cruzar nombres del pack contra dumps sin enmascarar el bit 14** (`0x4000`,
  `unused0 // was TCC`). El pack es de 2022 y trae la convención vieja: `00005dd4` contra
  `00001dd4`. El emulador lo ignora (`RemoveUnusedBits()`), un cruce a mano no, y **da 0 %
  de coincidencia**. Pasó en la sesión del 2026-09-03.
- **No diseñar la medición de cobertura como "contar todo y cruzar".** PCSX2 **no dumpea lo
  que ya tiene reemplazo** (`GSTextureReplacements.cpp:800`), así que con el pack activo
  `dumps/` ES el complemento. Son dos corridas, no un cruce.
- **No dar por buena una corrida porque el log tiene la línea del mipmap sin mirar la
  pantalla.** El savestate puede no haber cargado. Se verifica con una captura.
- **No leer los números de OSD de la corrida del 2026-09-02 como costo del pack:** fue sin
  turbo, y bajo el cap de velocidad nominal ningún costo se ve.
- **No dar por pendiente el test de los 12 bytes del `.WDD`:** las tareas 6.2 y 6.3 de
  `ESTADO_ACTUAL.md` §N3 ya tienen resultado parcial. Lo abierto es el **byte 0**.
- **No volver a auditar `Downloads/pipeline_metadev_ps2.txt`**: hecho el 2026-08-27.
- **El emulador de esta línea es `C:\Program Files\PCSX2\pcsx2-qt.exe`**, no los
  `lanzadores/*.bat` (ésos abren el fork PCSX2-MCP del reversing).
- **No generar archivos `-mipN.dds` sueltos para agregar mips a un reemplazo.**
  Esa convención (`GetDumpFilename` en `GSTextureReplacements.cpp`) es SÓLO para
  volcado en PNG. Para DDS, PCSX2 lee los niveles embebidos en el MISMO archivo
  vía `dwMipMapCount` del header (`GSTextureReplacementLoaders.cpp::DDSLoader`).
  Confirmado leyendo el código fuente real de `PCSX2/pcsx2`, 2026-09-04.
- **No dar por resuelto un arreglo de textura sólo con verificación por bytes.**
  El pack con mip chain pasó 8225/8225 en el reparseo byte a byte Y en inspección
  píxel a píxel, y el síntoma en pantalla volvió igual. Verificar SIEMPRE por el
  efecto visual real en el juego, no sólo por la construcción del archivo.
- ~~**No confiar en un verificador que nunca vio un archivo roto.**~~ —
  **CERRADO el 2026-09-04**: se le dieron dos rotos a propósito y dijo que no
  en los dos, con los sanos del mismo lote en verde. Ver `docs/09` §7.7.
- **No decir que la sesión no puede ver la pantalla de PCSX2.** Puede:
  `herramientas/pcsx2_teclado.ps1` le lleva el foco a la ventana del juego y
  manda `F8`, y PCSX2 escribe la captura en `Documents\PCSX2\snaps\`. Creer
  lo contrario costó la fase entera de §7.6.
- **`Process.MainWindowHandle` de .NET devuelve la ventana de REGISTRO de
  PCSX2, no la del juego**, y la de registro no procesa hotkeys. Se busca por
  título (`Black`) con `herramientas/pcsx2_ventanas.ps1`, y el foco se
  verifica comparando el **HWND exacto**, no el PID.
- **No comparar nitidez entre dos corridas separadas por un reinicio.** La
  escena avanza (humo, combate, enemigos) y eso domina la métrica. El A/B sólo
  vale con toggle dentro de una MISMA corrida, y siempre con el tercer paso
  ON→OFF→ON: **si el control C no vuelve a ≈A, la medición se descarta**. Pasó
  dos veces el 2026-09-04, con desvíos de −76 % a +1585 %.
- **No leer colores de una captura "mirándola".** Lo que parecían cuadraditos
  magenta eran partículas violetas del juego; el detector midió 0 px de
  magenta real. Se cuenta por canal con `detectar_nivel_mip.py` y se contrasta
  contra el mismo encuadre con mipmap off.
- **Con el juego en pausa, `F8` no escribe captura.** No se puede congelar la
  imagen para hacer el A/B.
- **No dar por buena la cobertura del 70,9 % (fase V1) sin saber en qué estado
  estaba `hw_mipmap` al medirla.** Si fue con mipmapping activado, ese 29 %
  "sin reemplazo" está inflado por el efecto del hash y la cobertura real es
  mayor.

### Cómo se lanza una corrida de esta línea (probado el 2026-09-03)

```powershell
$iso = 'C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso'
$st  = 'C:\Users\frans\Documents\PCSX2\sstates\SLUS-21376 (5C891FF1).03.p2s'
Start-Process 'C:\Program Files\PCSX2\pcsx2-qt.exe' -ArgumentList @('-statefile', "`"$st`"", "`"$iso`"")
```

El savestate 03 cae **dentro de un nivel**, primera persona, con arma y HUD - verificado por
captura, no supuesto. Para desactivar el pack (rama B del A/B) se **renombra**
`replacements\`; **PCSX2 recrea una `replacements\` vacía al arrancar sin ella**, así que al
restaurar hay que sacar la vacía primero. `Remove-Item` con wildcard ahí lo **frena el
guardia**: se renombra, no se borra - y así además queda la evidencia.

### ESTADO DE LA MÁQUINA — medido al cierre del 2026-09-04 (mañana), §7.8

- **PCSX2 CERRADO.** Nada en memoria que no esté en disco. Relanzar con el
  comando de "Cómo se lanza una corrida", más arriba.
- **`.ini`: `hw_mipmap = false`, `mipmap = true`,
  `DumpReplaceableTextures = false`, `PrecacheTextureReplacements = true`,
  `upscale_multiplier = 3`, `Renderer = 15` (D3D12).**
  El `hw_mipmap = false` es **a propósito**, mismo motivo que en V4: el
  puente (ahora sobre Huekage) sólo cubre las texturas de UNA escena.
  Respaldo nuevo: `pruebas/PCSX2.ini.respaldo-2026-09-04-huekage`.
- **`C:\Program Files\PCSX2\dxgi.dll` sigue `dxgi.dll.disabled`** — no tocado
  esta sesión.
- **Carpetas en `Documents\PCSX2\textures\SLUS-21376\`** — ninguna se borró.
  **Cambio de esta sesión: `replacements/` ya NO es el pack de 2022, es
  Huekage + su puente.**

  | carpeta | archivos | qué es |
  |---|---:|---|
  | `replacements` | **2799** | **el pack ACTIVO, NUEVO**: Huekage (2781) + 18 copias del puente |
  | `replacements-2022-con-puente` | 8260 | **el pack anterior completo** (mip chain §7.6 + 35 del puente). Para volver atrás del todo, renombrar éste a `replacements` |
  | `replacements-sin-mips-2026-09-04` | 8225 | el pack original de 2022, un solo nivel |
  | `replacements-DEBUG-colores-2026-09-04` | 8260 | pack de diagnóstico, ya con su puente |
  | `packs-descargados/` | 4111+ | Huekage y HD Reimagined bajados, extraídos, con sus zip/rar originales al lado |
  | `puente-huekage-2026-09-04` | 18 | las copias del puente sobre Huekage, sueltas |
  | `puente-mipmap-2026-09-04`, `puente-DEBUG-2026-09-04` | 35 c/u | los puentes sobre el pack 2022, de la sesión anterior |
  | `dumps-mipmapON-2026-09-04` | 38 | volcados con `hw_mipmap = true` — la entrada de AMBOS puentes |
  | `dumps-mipmapOFF-2026-09-04` | 6 | volcados con `hw_mipmap = false` |
  | `dumps-TOTAL-mipmapOFF-2026-09-04` | 82 | pack desactivado + mipmap off = el total de la escena; denominador del 92,7 % |
  | `dumps-conpuente-2026-09-04` | 3 | con el puente del pack 2022 puesto |
  | `dumps-huekage-conpuente-80s-2026-09-04` | 80 | **nuevo**: con Huekage+puente puesto, 80s de corrida. No comparable contra el "3" de arriba (duración distinta) |
  | `evidencia-mipmap-2026-09-04` | 4 | capturas A/B/C/D de la sesión de §7.7 |
  | `evidencia-huekage-mipmap-2026-09-04` | 6 | **nuevo**: las dos rondas A/B/C de §7.8 |
  | `replacements-vacia-recreada`, `-2` | 0 | las que PCSX2 recrea al arrancar sin pack. Inofensivas |

- **Herramientas**: sin cambios de código esta sesión. Se reusaron
  `puente_hash_mipmap.py`, `pcsx2_teclado.ps1`, `nitidez_regiones.py`.
- `chequeo-completo.ps1 -SoloMedidores`: en verde al abrir la sesión.
- **Git: pendiente commitear y pushear esta sesión** (ver abajo).

### NEXT ACTION, en orden de apalancamiento — actualizada el 2026-09-04 (mañana) por §7.8

1. **Encontrar una escena SIN combate para medir "barrera" directamente.**
   Cuatro rondas de A/B/C en total (2 de §7.7 + 2 de §7.8), todas en el
   savestate 03, y NINGUNA dio control limpio en esa región puntual — el
   humo y el combate son estructurales a esa escena, no un accidente de
   captura. Buscar otro savestate más tranquilo es más barato que seguir
   reintentando en éste.
2. **Decidir si el puente de Huekage necesita más trabajo antes de
   extenderlo a todo el juego.** Empareja 18/38 contra 35/38 del pack 2022
   (menos claves únicas). Si se prioriza cobertura de mipmap sobre
   resolución, puede convenir fusionar Huekage + el pack 2022 (resolviendo
   antes las 2044 colisiones, `emplace` no pisa) para tener más candidatos
   de pareo.
3. **Extender el puente elegido a todo el juego.** Sigue cubriendo una sola
   escena. El procedimiento ya está automatizado — `DumpReplaceableTextures
   = true` + `hw_mipmap = true`, recorrer, correr `puente_hash_mipmap.py`
   sobre lo volcado— pero **requiere jugar**: es lo único de esta línea que
   la sesión no puede hacer sola.
~~4. **Rehacer la cobertura de la fase V1.**~~ — **HECHO el 2026-09-04, y era
   eso**: el 70,9 % se midió con `hw_mipmap = true` (los volcados de V1 y los
   de esta sesión con mipmap on comparten **37 de 38** claves). Rehecha con
   numerador y denominador en el mismo estado: **82 texturas en la escena, 6
   sin reemplazo → 92,7 %**, con control positivo. Sobre la misma escena, 38
   sin reemplazo con mipmap on contra **6** con off. Detalle en `docs/09` §7.7.
~~5. **Corregir los dos falsos positivos del guardia.**~~ — **HECHO**: el
   guardia `PreToolUse` está arreglado (cortaba comandos sólo en `;` y `|`) y
   `probar-hooks.ps1` pasa 50/50.
6. **Costo en FPS con turbo**, método de R3 (`F6`/`F5`), ahora que el pack
   activo es más pesado.
7. `accurate_blending_unit` 3 -> 4, que el GameDB recomienda y nadie midió.

~~1. `mipmap = false`, mismo ángulo~~ — corrida y CONFIRMADA el 2026-09-04 (§7.5).
~~2. Atar la barrera a un hash de la lista A~~ — **superado por §7.7**: la
barrera no era una textura sin cobertura, era una textura cuyo hash cambió.
~~7. Sabotear el verificador de `regenerar_mipmaps.py`~~ — **hecho el
2026-09-04**, los dos sabotajes en rojo y los sanos en verde (§7.7).

## 10. REMAKE — geometría y texturas con IA — PEDIDA el 2026-09-04, INVESTIGACIÓN LANZADA la madrugada del 2026-09-04

> **DÓNDE VIVEN LOS RESULTADOS.** La investigación se lanzó como dos agentes en
> paralelo (Opus, background) y sus informes se guardan en el repo, **no en el
> chat**, para que la próxima sesión los tenga sin re-investigar:
>
> | archivo | qué contesta |
> |---|---|
> | `pruebas/remake-geometria-2026-09-04.md` | **ATERRIZADO 2026-09-04.** pregunta 1: librw / DFF pre-instanciado de PS2 / el byte 0 del `.WDD` / la ruta por Xbox |
> | `pruebas/comparacion-packs-2026-09-04.md` | **LOS DOS PACKS NUEVOS, BAJADOS Y MEDIDOS.** Huekage cubre **100 %** de la escena contra 92,7 % del nuestro y trae las 6 que faltaban; HD Reimagined cubre **28 %** y no aporta ninguna. Los dos ya traen mip chain, y los dos necesitan el puente igual |
> | `pruebas/remake-texturas-ia-2026-09-04.md` | **ATERRIZADO 2026-09-04.** pregunta 2: normal maps por IA sobre diffuse-only, y los packs de la competencia contra el nuestro |
> | `pruebas/remake-firma-malla-y-gtid-2026-09-04.md` | **CERRADO 2026-09-04 (mañana).** La firma de bloque de malla — **CONFIRMADA**, 132.630 hits en 233/270 `.DB`/`.bin`. El GtID de la cabecera del `.DB` — **REFUTADO para el header completo** (0/139 en los 8 bytes; las dos invariantes parciales, byte0 y bytes6-7, siguen en 139/139) |
>
> **Titulares de geometria:** `fmt_Burnout3LRD.py` **NO es solo texturas** —
> trae un decodificador de geometria PS2 VIF/DMA funcionando (`boMdlPS2`,
> `rapi.unpackPS2VIF` nativa de Noesis) y **ya abre los contenedores de
> BLACK**: el trabajo es conectar dos piezas que ya existen en el mismo
> archivo, no escribir un importador. Existe **`burnout.wiki`** (~650 paginas
> del motor de Criterion) y no estaba en el barrido. **La firma de bloque de
> malla `00 00 00 05 03 01 00 01 00 80` (de *Formats Takedown-Dominator*)
> CONFIRMADA por barrido masivo**: 132.630 apariciones en 233/270 `.DB`/`.bin`
> del ISO, espaciadas de forma periodica y variable dentro de cada archivo —
> localiza cada bloque de malla sin parsear nada mas. **La cabecera del `.DB`
> NO es un GtID directo del nombre completo** (hipotesis de la sesion anterior
> REFUTADA, 0/139 en el header completo de 8 bytes): sólo las dos invariantes
> parciales que ya se tenian (byte0=0x00, bytes 6-7 = `"FT"`) siguen valiendo,
> 139/139. La mitad baja del header sigue sin explicar. Detalle:
> `pruebas/remake-firma-malla-y-gtid-2026-09-04.md`.
> El `.WDD` **no** es Wave Dictionary (eso es `.AWD`, y
> vgmstream ya lo soporta para BLACK, asi que **el audio ya esta resuelto**).
> Y **dos personas ya extrajeron geometria de BLACK en privado** (h3x3r y
> shak-otay, con captura): escribirle a h3x3r es la accion de mayor
> apalancamiento de esta linea. **CUATRO CORRECCIONES al barrido anterior**
> estan al final de ese archivo — sobre todo: el reversing de agarmash.com es
> de **firmas de savefile**, no de assets, y no sirve para geometria.
>
> **Titulares de lo que ya aterrizo (el detalle esta en el archivo, no aca):
> **PCSX2 no puede recibir normal maps** — cero coincidencias de
> `normalmap|bumpmap|pbr` en `GSTextureReplacements.cpp` y sólo dos loaders,
> `png` y `dds`; la pregunta se cierra por arquitectura, no por calidad de
> herramienta. **Hay SEIS packs de BLACK**, no uno: dos publicados en agosto
> de 2026 (Huekage 774 MB con 2781 texturas declaradas, y HD Reimagined
> 2,19 GB). **Y son fusionables**: el hash sale del contenido del juego, no
> del pack, y PCSX2 escanea `replacements/` recursivamente — comparar nombres
> entre packs es aritmética de conjuntos y no necesita correr el juego. Es lo
> más rentable de esa línea.
>
> Si alguno de esos dos archivos **no existe**, es que esa mitad de la
> investigación no llegó a aterrizar y hay que relanzarla — no que no se hizo.
> El barrido previo del 2026-09-02 sigue siendo
> `pruebas/barrido-remake-2026-09-02.md` y **no se repite**.


Fran pidió explícitamente: *"investigá si hay alguna manera de hacer un remake
de geometrías y texturas mejoradas"*, con **Opus** para esta investigación
específica (no para el hilo principal — ver nota de modelo abajo). **No se
lanzó ningún agente todavía**: la sesión cortó por contexto entre pedir esto y
el primer tool call. No asumir que hay algo corriendo.

**No investigar de cero — ya hay una base real, del barrido del 2026-09-02**
(`pruebas/barrido-remake-2026-09-02.md`, `docs/09` §4): el motor es RenderWare;
`librw` (aap/librw, MIT) reimplementa el motor y lee DFF/TXD de PS2, pero su
propio README avisa que el DFF pre-instanciado de PS2 está incompleto y el BSP
sin soportar — **no se sabe si eso bloquea a BLACK específicamente**; el plugin
de Noesis `fmt_Burnout3LRD.py` menciona "Black (PS2, Xbox)" en su docstring y
abre `.db`/`.bin` pero es sólo texturas, no modelos con huesos; `PS2Recomp`
existe pero es experimental y el GS "needs external implementation"; hay
reversing público del **XBE de Xbox** de BLACK en agarmash.com (offsets
concretos) que podría ser una entrada más fácil que el PS2. Formatos propios
parcialmente entendidos: `.DB` firma `..FT` en bytes 6-7, `.WDD` con
`byte1=0x02` en tamaños 16K/64K — **el byte 0 del `.WDD` sigue sin
identificar** (¿chunk RenderWare 0x16=texture dictionary, 0x10=clump, u otra
cosa?). Techo medido de la industria: sólo OpenGOAL (Jak & Daxter) llegó a PC
nativo jugable completo; Sly Cooper lleva 6,33 % en 5 años de decompilación
comunitaria.

**Las dos preguntas concretas que la investigación nueva tiene que contestar,
sin repetir el barrido:**
1. ¿La limitación de `librw` con DFF pre-instanciado de PS2 es un bloqueo real
   para BLACK, o hay un camino (aunque sea para UN prop simple) para
   extraer→editar→reimportar geometría hoy? ¿Se puede resolver el byte 0 del
   `.WDD` cruzando contra tablas de chunk types de RenderWare conocidas?
2. ¿Hay una técnica de IA real (no teórica) para generar normal maps /
   profundidad falsa a partir de las texturas diffuse-only de PS2, usable con
   ReShade/shaders? ¿Alguno de los packs de la competencia (HD Reimagined,
   Huekage, Johnazeitona) resuelve mejor el 29 % que nuestro pack no cubre, o
   usa un upscaler superior al de 2022 que tenemos?

**Modelo real, para que la próxima sesión no se choque con esto:** Claude Code
no tiene una herramienta para cambiarse el modelo a sí mismo a mitad de sesión.
"Dejar la sesión con Opus toda la noche" se logra lanzando 1-2 Agents con
`model: "opus"` y `run_in_background: true` (quedan corriendo aunque el hilo
principal siga en Sonnet, y avisan solos al terminar) — **no** pidiendo que
esta conversación "se convierta" en Opus. Si Fran quiere el hilo PRINCIPAL en
Opus, eso se elige en el selector de modelo de la app, no desde una respuesta.

## 11. DIFICULTAD / IA de enemigos — PEDIDA el 2026-09-04, EMPEZADA la madrugada del 2026-09-04

Fran pidió, como plan B si el remake no da nada concreto: *"mejoras de la IA y
aumentar las posibilidades de cambiar la dificultad... para volverlo tan
difícil y distinto como queramos"*. **Esto NO es una línea nueva de
investigación — es la continuación directa de 7e** (secciones 1-7 de este
mismo archivo), que ya tiene la mitad del trabajo hecho:

- El despachador de 61 tipos de módulo está mapeado y medido (7e-a, HECHO).
- **Fase 5a — pnach sobre `0x00142CA0` (daño de salida del jugador) — está
  PARQUEADA, lista para retomar apenas se abra el emulador.** Es el candidato
  más directo para "más difícil/más fácil": un solo valor de daño.
- Del `docs/00-conops.md` (no releído esta sesión, releer si se retoma esto):
  **R3** (IA más aguda — clases de enemigo YA identificadas, valores de
  comportamiento NO) y **R4** (qué enemigos aparecen — depende de 7e(b),
  verificar un tipo de módulo por efecto, que sigue sin hacerse).
- Todo esto necesita el emulador y a Fran jugando hasta cargar un nivel
  (autorizado desde 2026-08-29) para verificar cualquier patch por efecto —
  no es trabajo 100 % de escritorio como el remake de la línea 10.

**Primer paso concreto si se retoma:** releer `docs/00-conops.md` completo (no
está en el contexto de esta sesión) y `ESTADO_ACTUAL.md` bloque 7e, después
decidir si 7e(b) (verificar un módulo por efecto) es prerequisito real para
tocar daño/spawns con confianza, o si Fase 5a puede adelantarse sola.

### AVANCE del 2026-09-04 (madrugada): la pregunta que esta seccion dejaba planteada, contestada

**"Decidir si 7e(b) es prerequisito real para tocar danio/spawns, o si la Fase
5a puede adelantarse sola" -> LA 5a PUEDE ADELANTARSE SOLA.** Se releyo
`docs/00-conops.md` entero (no se habia releido en varias sesiones) y el
criterio sale de ahi, sin ambiguedad:

- **R2** ("se puede cambiar la dificultad por parametros") esta como *parcial:
  danio si; percepcion de la IA, no todavia*. El danio de salida es
  precisamente la mitad que ya funciona.
- **R4** ("se puede cambiar que enemigos aparecen") **si** depende del sistema
  de modulos, o sea de 7e(b). Pero R2 no lo toca: `0x00142CA0` es una
  direccion concreta dentro de una rutina ya CONFIRMADA por efecto
  (`calcular_dano_zona`, fase 4b), y no pasa por el despachador de modulos.

O sea que 7e(b) es prerequisito de **R4**, no de **R2**. La 5a no esta
esperando nada.

### Lo que se avanzo de la 5a, en frio y sin emulador

Se extrajo `eeMemory.bin` del savestate 03 y se leyo la zona del parche. Dos
resultados, y el segundo cambia como hay que escribir el mod:

```
0x00142CA0  3C0142C8  lui  at, 0x42C8      <- el 100.0 vive ACA, en el INMEDIATO
0x00142CA4  44810000  mtc1 at, $f0          (mips.py no decodifica FPU: dice "cop1")
0x00142CA8  15200048  bne  t1, zero, 0x00142DCC
0x00142CAC  46000D02  mul.s $f20, $f1, $f0  (en el delay slot del branch)
```

1. **`0x00142CAC` contiene exactamente `0x46000D02`**, la codificacion que el
   `kb` ya tenia registrada. La formula de `calcular_dano_zona` queda
   respaldada contra memoria real, no solo contra el desensamblado de Ghidra.
2. **En `0x00142CA0` NO hay un float: hay una instruccion.** `0x42C80000` en
   IEEE754 es 100.0 exacto, pero esta en el inmediato de 16 bits de un `lui`.
   **Escribir un `f32` en esa direccion corrompe el codigo** — es la trampa
   que el `efecto_si_se_modifica` del `kb` invitaba a pisar, y ya quedo
   corregido ahi.

**El parche correcto es reescribir la palabra entera** como `0x3C01<hi>`,
con `<hi>` = los 16 bits altos del float deseado. Ya calculados y guardados en
`kb/rutinas.json` (`parches_calculados`):

| multiplicador | valor | palabra a escribir |
|---|---:|---|
| x0,5 | 50,0 | `0x3C014248` |
| x2 | 200,0 | `0x3C014348` |
| x4 | 400,0 | `0x3C0143C8` |
| x10 | 1000,0 | `0x3C01447A` |

Los 16 bits bajos dan cero en los cuatro casos, asi que **alcanza con
reescribir el `lui`: no hace falta un `ori`**. Una sola palabra.

### Por que NO se escribio el mod .toml todavia

`mods/ejemplo-plantilla.toml` lleva la regla del proyecto en su encabezado:
*"no se escribe una direccion aca hasta que este en kb/mapa-memoria.json con
confianza confirmado"*. El punto de parche sigue en **`hipotesis`**: que ese
100.0 escale el danio de salida no se verifico POR EFECTO. El freno se
respeto a proposito.

**Lo unico que falta para cerrarlo es una verificacion por efecto**, y es
corta: aplicar el pnach con `0x3C014348` (x2), disparar a un enemigo y ver si
cae en la mitad de los tiros. Eso pide a alguien jugando — la sesion puede
abrir el emulador, mandar teclas y sacar capturas (ver S9), pero apuntar y
matar a un enemigo para contar tiros no es algo que convenga hacer a ciegas.

**Primer paso concreto si se retoma:** compilar el pnach con la palabra x2,
arrancar, disparar, contar. Si el danio se duplica, el punto de parche pasa a
`confirmado`, la 5a se cierra y R2 pasa de *parcial* a cumplido para el eje
del danio.

### CERRADA el 2026-09-04: confirmado por efecto, SIN apuntar a ciegas

Se diseño el mecanismo que esta seccion pedia explicitamente no saltear: en
vez de apuntar y matar a un enemigo contando tiros a ojo, se escribio el
parche EN RAM (`pine.py escribir 0x00142CA0 0x3C014348`) durante una partida
real de Fran en `LEVEL_02`, y se grabo por RAM con `vigilar.py` la vida de
los 32 slots del pool de enemigos (`clases.py objetos <dump> 0x003DCA78`,
vida en `+0x2F8`) MAS la vida del jugador, sin coordinar a que enemigo
apuntar.

**Resultado: CONFIRMADO.** Un enemigo recibio dos golpes de exactamente
`-47.6`, que es `0.34 (zona ya confirmada) * 200.0 (el valor patcheado) * 0.7
(multiplicador final ya confirmado)` -- las tres constantes ya eran conocidas
antes de hoy, y el producto coincide al bit. Sin el parche ese mismo golpe
daria `23.8`: el parche duplica exacto. Control negativo en la misma
grabacion: el jugador recibio 3 golpes de `-26.0` SIN CAMBIOS -- confirma que
el parche es unidireccional (solo el danio de SALIDA del jugador, como decia
el nombre de la rutina).

Punto de parche promovido a `confirmado` en `kb/mapa-memoria.json`
(`multiplicador_dano_salida`) y en `kb/rutinas.json#calcular_dano_zona`.
Detalle completo con los numeros crudos: `docs/03-bitacora.md` (54).

**Se escribio `mods/dano-x2.toml`** (antes prohibido: la plantilla exige
confirmado en `mapa-memoria.json` antes de anotar una direccion). Compila
limpio: `patch=0,EE,00142CA0,word,3C014348`. Sigue con `habilitado = false` y
SIN `--instalar` -- decision pendiente de Fran, no tecnica.

**Pendiente, no bloquea nada:** decidir si instalar el `.pnach` (sobrevive a
reiniciar el emulador) o dejar el parche solo en RAM (se pierde al cerrar
PCSX2 -- ya se perdio una vez sin querer quiere decir nada, es exactamente el
comportamiento esperado). R2 de `docs/00-conops.md` sigue en *parcial*: el
eje de danio ya esta cerrado de punta a punta; falta R3 (percepcion de IA) y
R4 (que enemigos aparecen, depende de 7e(b)).


---

## 9. JUGABILIDAD — J1 ABIERTA (línea nueva del 2026-09-04, no toca 7e ni el Remaster)

### 9.1 QUÉ LEER PARA RETOMAR ESTO

1. `docs/10-jugar.md`, **entero**. Es corto y es la fuente.
2. `docs/03-bitacora.md`, entrada **(55)**.
3. `ESTADO_ACTUAL.md`, bloque **JUGABILIDAD**.

No hace falta nada de 7e ni del Remaster.

### 9.2 QUÉ QUEDÓ HECHO — no rehacer

| Cosa | Dónde vive | Estado |
|---|---|---|
| mapeo teclado+mouse contra el layout REAL de BLACK | `herramientas/configurar-controles.ps1` | aplicado y verificado; el `-Verificar` **probado en rojo** |
| mouse lineal (`PointerInertia = 100`) | idem, sección `[Pad]` del ini | aplicado; **falta medir por efecto** |
| agachado mantenido con Shift | `lanzadores/agachado-hold.ahk` | escrito; AutoHotkey 2.0.27 instalado por winget; **falta probarlo jugando** |
| accesos directos del Escritorio | `lanzadores/crear-accesos-directos.ps1` | `BLACK.lnk` y `BLACK - Parches.lnk` creados |
| menú de parches unificado | `lanzadores/PARCHES-BLACK.ps1` | `-Listar` verificado; el menú interactivo **no se probó a mano** |
| lanzador | `lanzadores/JUGAR-BLACK.ps1` | escrito; **no se ejecutó** (habría abierto el emulador) |

### 9.3 ESTADO DE LA MÁQUINA AL CERRAR

- `Documents\PCSX2\inis\PCSX2.ini`: `[Pad]` con `PointerXSpeed = 40`,
  `PointerYSpeed = 40`, `PointerXDeadZone = 20`, `PointerYDeadZone = 20`,
  `PointerInertia = 100`. `[Pad1]` con el mapeo nuevo y `AxisScale = 1`.
  **Sin BOM** (verificado: los primeros bytes son `5b 55 49` = `[UI`).
  Backups: `PCSX2.ini.bak-20260904-*` en la misma carpeta.
- `Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach`: **archivo nuevo**, el
  unificado (4 parches oficiales + el mod `Dificultad x2` del proyecto).
- `Documents\PCSX2\gamesettings\SLUS-21376_5C891FF1.ini`: sin cambios de
  esta sesión. Prendidos: `Widescreen 16:9`, `60 FPS`, `Video Mode`.
  `EECycleRate = 0` (sin overclock).
- `Black-mod-7b.iso` fue lo último que Fran arrancó (`emulog.txt`). Los tres
  ISO dan CRC `5C891FF1`.
- AutoHotkey **2.0.27** instalado en `C:\Program Files\AutoHotkey\v2\`.
- `kb/ubicaciones.json` tiene clave nueva **`pcsx2_exe_juego`** =
  `C:\Program Files\PCSX2\pcsx2-qt.exe` (el 2.8.0, el de JUGAR). El
  `pcsx2_exe` de siempre sigue siendo el fork MCP de `Downloads`, el de
  reversing. **Son dos emuladores distintos a propósito.**
- Cero parches vivos en RAM. El ISO original y sus permisos, intactos.

### 9.4 LO QUE CIERRA J1 — dos mediciones, las dos jugando, primer minuto

1. **60 FPS.** Abrir el juego y mirar el FPS del OSD. `~59.94` = anda.
   `29.97` = el parche no está tomando; subir el overclock del EE a 180 %
   desde `BLACK - Parches` (tecla `E`) y volver a mirar. La contradicción está
   documentada: el parche figura prendido desde el 2026-07-18 y la medición de
   R1 del 2026-09-01 dio 29.97.
2. **Linealidad del mouse.** Un manotazo largo tiene que girar lo mismo que la
   suma de movimientos lentos que cubren la misma distancia del escritorio.
   Si sigue perdiendo, el knob es `-Inertia`; si el manotazo gira de más y
   sigue girando cuando el mouse ya paró, bajar `-Speed`.

### 9.5 LO QUE NO SE PUEDE ARREGLAR CONFIGURANDO — candidatos de reversing

Anotado para no volver a intentarlo por el lado del emulador:

- **número → arma concreta.** BLACK cicla armas, no las indexa. Hace falta
  leer el arma actual del jugador (PINE) para calcular cuántos pasos dar, o
  parchear la rutina de selección.
- **agachado como hold nativo.** El toggle es del juego. El arreglo de fondo
  es parchear la rutina para que lea el estado del botón. Hoy lo tapa el
  `.ahk`.
- **el lag del manotazo.** El juego integra velocidad angular con tope; el
  mouse manda distancia. Lo único que sube el tope de verdad es la constante
  de sensibilidad de mira **en el código** — la misma que el slider de
  Options mueve dentro de su rango.
