# Fallos del coop por red (black-seamless-coop v2026.10.18.2) — sesión (135b), 2026-10-31

Lo que Fran y Agustín vieron jugando en red (notebook anfitriona, PC unida por el cable directo), con la evidencia
y la causa leída en el código del mod. Registro de la corrida: `volcados/plataforma/20261031-010335-red-anfitriona/`
(`logs-en-vivo/black.log`, copiado con el juego abierto; el lanzador copia el final al cerrar).

## F-RED-1: desde un momento, el compañero deja de ver lo mismo que el anfitrión

**Reporte (Fran):** al principio veían los mismos enemigos; a partir de un momento, había enemigos que el anfitrión
veía y Agustín no.

**Evidencia (registro del anfitrión):** los disparadores del compañero («trigger … fired at the partner») salen de
corrido mientras van juntos: 47 entre el segundo 63 y el 844, y **ninguno después**. ~~Desde el 885 el compañero entra
primero a la unidad 6~~ **Corregido en (135c), releyendo el registro:** a los 885 s el que cruzó primero fue el
anfitrión («the advance to unit 6 waits for the partner») y a los 890 avanzaron juntos a la 6; a los 911 la copia del
compañero activó la 7 («unit 7 activated, as the partner's»). Desde ahí las dos copias siguen en la 6 y el compañero
camina la zona de la 7 (activa, sin «avanzar»), cuyos disparadores viven en la otra lista. El tope de esos mensajes
(1500 líneas) no se alcanzó: el registro tiene 803.

**Causa (`src/game/coop_world.cpp`, `TestPartner`, líneas 1403-1451 en HEAD):** el anfitrión prueba los disparadores
del compañero **sólo en la lista de su PROPIA unidad actual** (`current`: la lista cuyo slot tiene
`unit == world+kWorldUnit`, la del jugador del anfitrión). Si el compañero va una unidad adelante, sus disparadores de
esa unidad no se prueban nunca: no nacen las oleadas, no corren los eventos, y los dos mundos se separan. El propio
comentario del mod lo admite para las unidades («the streaming follows this copy's player»).

Grado: **probable** (el código y el registro coinciden; falta la prueba que lo mata: el compañero adelantado una
unidad con el anfitrión quieto, y ver que el disparador de esa unidad no sale; y el control, los dos juntos).

## F-RED-2: con el anfitrión caído, el compañero solo no dispara la pelea final

**Reporte (Fran):** nivel 3; el anfitrión murió y Agustín, solo, no pudo activar la aparición de enemigos de la pelea
final ni la música final.

**Evidencia:** «coop: down in unit 6, waiting for the team's checkpoint» (1095 s) con el compañero ya en la 7. Después
de caer el anfitrión nacen 2 enemigos (contra 110 antes) y no sale ningún disparador. El nivel igual se completó
(«the partner's level complete here too», 1299 s).

**Causa:** la misma de F-RED-1. Caído, el anfitrión queda clavado en su unidad (6): todo lo que el compañero pisa en
la 7 no se prueba. Y el caído vuelve «en el próximo checkpoint del equipo», que en la última unidad no existe.

## Qué hacer mientras no esté arreglado (regla de juego)

**El anfitrión va adelante** (o los dos juntos): que nadie entre a una zona nueva antes que el anfitrión. Si el
anfitrión cae, el compañero no avanza a una zona nueva hasta que vuelva. Vale para todos los niveles: el defecto no
depende del nivel sino de quién está en qué unidad.

## El arreglo (135c): escrito, compila; falta la prueba en vivo

**El juego prueba las dos listas para su jugador** (el despachador `0x1E7FF0` recorre `mgr+0x48` y `mgr+0x4C`, leído en
el código generado del port); el mod, para el compañero, sólo la de la unidad del anfitrión. El parche
`parches-coop/02-disparadores-unidad-companero.patch` hace lo mismo que el juego: prueba las dos, y el mensaje dice de
qué unidad era la lista. Entra limpio en el port y compila (sintaxis con `clang++`, sabotaje en rojo). Se compila con
`lanzadores/COMPILAR-COOP.ps1` y se prueba con `lanzadores/PROBAR-PARCHE-COOP.ps1` (y `-Control`), con las
predicciones de `sesiones/PREDICCIONES-135c.md`, antes de usarlo para jugar. Grado del diagnóstico: **probable** hasta
esa prueba.

## F-RED-3 (136), 2026-11-06: el compañero como fantasma

**Reporte (Fran, de memoria: hipótesis):** en el nivel de los francotiradores, Fran (anfitrión, notebook) entró a una
zona antes que Agustín; desde ahí los enemigos de las dos copias divergieron, Agustín veía cosas que Fran no y terminó
«ignorado, como un fantasma».

**Medido en el registro del anfitrión** (`C:\Games\BLACK\coop\logs\black.log`, 31/10 02:23-03:23, el exe con 01+02,
fotos en `volcados/plataforma/20261031-022336-red-anfitriona/`):
- **El parche 02 anda en red real:** 120 disparadores probados en el compañero, **32 de la lista de la unidad de
  adelante** (`unit N's (this player's M)` con N > M). P1 y P3 de `PREDICCIONES-135c.md` cumplidas jugando; P2, P4 y P5
  sin medir con el ensayo.
- El cuerpo de Agustín existió en el anfitrión toda la partida (se suelta sólo en las cargas).
- El anfitrión cruzó primero dos avances de unidad (885 s y 3421 s, «waits for the partner (crossed -1)»).
- **Lo que le pasa a la copia de Agustín no está en este registro:** está en el `black.log` de la PC (si no se pisó).

**Leído en el código del mod (`coop_npcs.cpp`, *probable*):** en la copia que se une, cada enemigo es un **títere** del
anfitrión, y sus spawners propios no hacen nada mientras el anfitrión se oye.
- **H1, el anfitrión adelante:** el títere sólo nace si **su spawner está cargado en la copia de Agustín**
  (`Spawner(name)` = 0: «its unit is not here yet»). Los enemigos de la zona a la que Fran entró primero no existen para
  Agustín hasta que su copia carga esa unidad; y el registro **no lo dice** (ceguera: la tapa el parche 03).
- **H2, estados viejos:** si los estados del anfitrión tienen más de 1,5 s, son de otro nivel o el anfitrión no está en
  juego (pausa, menú, caído), los títeres **se quedan parados**: enemigos que no disparan ni se mueven. Y si el anfitrión
  deja de oírse, la copia de Agustín vuelve a manejar sus propios enemigos: dos mundos distintos.
- **H3, disparadores que nunca prueban al compañero** (aun con el 02): los de entrar y salir (modos 1 y 2), las zonas de
  visibilidad (modo 4) y los de tipo 12 (`TestPartner`). Si una oleada cuelga de uno de esos, cuando Agustín entra
  primero no pasa nada hasta que llega Fran.

**El registro de la copia de Agustín (traído de la PC en (136b): `volcados/plataforma/20261031-pc-companero/`)
apoya H1, *probable*:** en `black.prev.log`, a los 1110 s «the partner went through the advance to unit 5» (Fran
cruzó) y la copia de Agustín se queda en la unidad 4 **92 s**, hasta que él usa «get me out of here» (1202 s: «advance
to unit 5, the partner's way»); después lo aprieta **11 veces en 5 s** (1217-1222 s, siempre puesto al lado de Fran) y
dos más. Nunca «the host is not heard» (H2 por red, descartada esa noche). Ninguna línea dice cuántos enemigos del
anfitrión no pudo hacer en esos 92 s: es la ceguera que tapa el 03. **El arreglo que se desprende:** cuando el
anfitrión cruza un avance, la copia que se une carga esa unidad (como hace el rescate, sin mover al jugador), así
sus títeres existen; se diseña con el 03 midiendo.

**(137), 2026-11-06, el cruce de los DOS registros de esa noche: H1 no aparece; el parche 04 como estaba pensado no
se escribe.** Apareció el registro del anfitrión de la misma partida (`C:\Games\BLACK\coop-v2\logs\black.log`, 02:23:36,
copiado a `volcados/plataforma/20261031-022336-red-anfitriona/black-anfitrion.log`; el compañero arrancó 378 s
después). Cruzados enemigo por enemigo con `herramientas/cruzar_registros.py` (*medido*, sin intervenir):
- **En el cruce de los 1110 s (anfitrión 1488 s) los cuatro enemigos de la unidad 5 nacieron como títeres en la copia
  de Agustín en el mismo segundo** que en la de Fran (`72AE4507A4C7D11C/D11D/D123/D14A`), y los dos de las 1159 s
  también. La unidad 5 ya estaba activa en las dos copias (lo hace `FlowMessages`, «unit 5 activated, as the
  partner's»): los spawners **sí** estaban cargados.
- En toda la partida, de los 237 enemigos del anfitrión, **dentro de un nivel con los dos jugando falta uno solo**
  (`72AE45098D0FD7DA`, unidad 7, compañero 1477 s). Los otros 71 sin títere son del nivel siguiente, cuando la copia de
  Agustín estaba en «level complete» y se cerró (03:00:41 volvió a entrar). Segunda sesión de la PC: **0 faltantes**.
  Demora del títere: mediana 0,6 s.
- **Lo que sí pasó en esos 92 s:** el anfitrión cruzó el avance y **su copia esperó** al compañero (diseño del mod:
  `sub_001B73B0` + `WaitingForPlayers`, «the advance to unit 5 waits for the partner»); la de Agustín nunca registró a
  su jugador cruzando ese avance (si lo hubiera cruzado, avanzaba sola: ya sabía que Fran había pasado), y salió recién
  con el rescate. Las granadas de Agustín de esos segundos llegaron a Fran (`proj! hand grenade of the partner`): la red
  anduvo. Después del rescate lo pidió **11 veces en 5 s**, siempre puesto al lado de Fran.

**Consecuencia para el arreglo (decisión técnica):** «cargar/activar la unidad del anfitrión en la copia que se une»
**ya lo hace el mod**, y avanzarla sin mover al jugador lo dejaría en una unidad descargada. Un parche 04 así no
cambiaría nada de lo medido. Lo que el registro deja vivo es **otra** cosa (*hipótesis*, H3 ampliada): algo de la
copia de Agustín le impide cruzar el avance (una puerta o un bloqueo que en la de Fran abrió un disparador que el mod
no prueba con el compañero: entrada/salida, tipo 12 o de escena), o el fantasma de Fran es de otra noche. Lo decide
la próxima partida con el 03 (ya instalado en las dos): si se repite, el registro de Agustín dice qué enemigos no pudo
hacer y si los estados se cortaron, y hace falta saber **dónde** estaba trabado (una captura alcanza).

**Lo que decide entre H1-H3:** el registro de la PC de esa noche y el ensayo de `sesiones/PREDICCIONES-136.md`, con el
parche **03** (`parches-coop/03-diagnostico-titeres.patch`: la copia que se une anota cada enemigo del anfitrión que no
puede hacer nacer, y cuándo los estados del anfitrión dejan de mover a los títeres). El 03 sólo agrega dos líneas de
registro: no cambia el juego. Entra limpio en el port (`git apply --check`, sabotaje en rojo); **sin compilar**.

**Regla de juego mientras no esté arreglado:** las zonas nuevas se entran **juntos** (ninguno adelante: el que llega
primero a la puerta espera). Y para repartir lo que el mod le da de más al anfitrión (sus enemigos son los originales),
**turnarse el anfitrión por nivel** cuando la PC tenga el mismo exe.

## Afuera (2026-10-31; actualizado 2026-11-06)

**2026-11-06:** salió **v2026.11.01** («Seamless co-op updated to BLACK V3»): el port pasa a V3 (gyro, reemplazo de
texturas, opciones, menús); la lógica del coop **no cambia** (`coop_world.cpp` y `coop_npcs.cpp` iguales; `coop.cpp`,
2 líneas); **protocolo 19: las dos máquinas se actualizan juntas**. Ni F-RED-1 ni F-RED-3 están arreglados ahí. Decisión
técnica: no se migra antes de cerrar F-RED-3 (dos cambios a la vez confunden la causa). El vigía no la había visto: no
miraba las versiones del mod que usamos; desde (136) sí (`kb/vigia.json`, `gh-releases-seamless-coop`).

**2026-10-31:**

Sin versión más nueva: el último release es v2026.10.18.2 (el que tenemos), sin commits después; un solo issue,
cerrado, de otra cosa; sin forks. Ningún reporte público de estos dos fallos.
