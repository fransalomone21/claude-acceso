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

## Afuera (2026-10-31)

Sin versión más nueva: el último release es v2026.10.18.2 (el que tenemos), sin commits después; un solo issue,
cerrado, de otra cosa; sin forks. Ningún reporte público de estos dos fallos.
