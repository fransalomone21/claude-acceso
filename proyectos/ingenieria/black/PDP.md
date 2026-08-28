# PDP — BLACK (PS2): ingeniería reversa sobre PCSX2

> Escrito el **2026-08-28**, con el proyecto en la fase 7e. Incumple la regla
> —el PDP se escribe *antes* de la primera línea de trabajo— y por eso queda
> anotado en vez de disimulado: lo que sigue es una **reconstrucción medida
> contra `ESTADO_ACTUAL.md` y `sesiones/HANDOFF.md`**, no un plan escrito de
> antemano. De acá en adelante manda: el criterio de salida de la fase en curso
> vive acá.
>
> El **mapa de fases de `ESTADO_ACTUAL.md` sigue siendo la fuente de la verdad
> operativa** —se actualiza cada vez que cambia algo real y tiene el detalle de
> cada hallazgo—. Este PDP no lo duplica: guarda el problema, el alcance
> negativo, los riesgos, las decisiones y **el criterio de salida de la fase
> abierta**, que es lo que ningún otro archivo tenía escrito.

## 1. El problema

Modificar BLACK con criterio —saber *por qué* un cambio hace lo que hace, no
encontrarlo por prueba y error— y que el cambio **sobreviva a cerrar el
emulador**. Un valor pisado en RAM se pierde al apagar; lo que se busca es el
procedimiento repetible que produce un ISO modificado.

**Para quién es:** Fran, solo. No hay usuario externo, no hay entrega, no hay
fecha. Eso cambia el rigor hacia adentro y no hacia afuera: lo que se paga caro
acá no es publicar un error, es **creer una hipótesis que no se midió** y
construir tres sesiones encima.

**Cómo sabremos que sirvió (validación):** ya sirvió una vez, y está medido —
existe `Black-mod-armas.iso` y el procedimiento que lo produce
(`herramientas/parche_iso.py`), con el efecto confirmado en RAM tras arrancar
ese ISO (2026-08-17, N0 cumplido para la tabla de armas). La pregunta de
validación que sigue abierta es si el **índice de módulos del nivel** (fase 7)
convierte «tocar cualquier otra cosa» en un procedimiento barato, o si cada
cosa nueva va a seguir costando subir la cadena de llamadas eslabón por
eslabón.

## 2. Qué NO es

- **No es un mod publicable.** No hay distribución, ni parche para terceros, ni
  compatibilidad con otras versiones del juego.
- **No se toca el ISO original.** `Black.iso` es intocable y hay tres capas que
  lo miden (ReadOnly del sistema operativo, hook `PreToolUse`, e integridad
  medida en `abrir-sesion.ps1`). Todo mod produce un ISO **nuevo**.
- **No se trabaja con el emulador abierto por defecto.** El default es **en
  frío**: sobre el ELF, sobre el ISO y sobre los volcados ya tomados. El
  emulador se abre sólo para contrastar o confirmar por efecto, y en ese caso
  **la predicción se escribe antes de abrirlo**. Abrir el emulador «para ver»
  cuesta una sesión y no produce evidencia.
- **No se persigue una pregunta cerrada con un negativo.** 7b quedó cerrada con
  un resultado negativo medido y los candidatos sin probar anotados en
  `kb/estructuras.json`. Reabrirla es una decisión nueva, no un pendiente.
- **Las rutas no se copian a mano.** Viven en `kb/ubicaciones.json` y las mide
  `herramientas/ubicaciones.py`.

## 3. Naturaleza y criticidad

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |
| Criticidad | `importante` en general; **`critico` para todo lo que toque el ISO original**, que es lo único irrecuperable del proyecto |
| Rigor que le corresponde | hipótesis / probable / confirmado anotado en cada afirmación; nada se reporta un escalón más arriba de lo que se midió. Lo confirmado lo es **por efecto**, con control positivo. Lo reversible se prueba primero en RAM y recién después se lleva al ISO. |

> La asimetría es deliberada: un experimento fallido en RAM se descarta
> reiniciando, y un ISO mal parcheado se rehace desde el original — **si el
> original sigue estando**. Por eso las tres capas están sobre ese archivo y no
> sobre el resto.

## 4. Las fases

El mapa completo, con el detalle de cada hallazgo, está en `ESTADO_ACTUAL.md`.
Acá va el esqueleto y las puertas.

**N0 — Objetivo.** Modificar BLACK con criterio y que el cambio sobreviva a
cerrar el emulador. **Cumplido el 2026-08-17 para la tabla de armas**; sigue
abierto para cualquier otra cosa que se quiera modificar.

**N1 — Capacidades.** Cuatro, independientes entre sí:

| | Capacidad | Estado |
|---|---|---|
| A | Leer la máquina viva (PINE, escaneo diferencial, savestates, watchpoints) | **cerrada** |
| B | Leer el código (Ghidra + r5900, 9842 funciones; y desde 2026-08-16 la RAM viva adentro de Ghidra) | **cerrada** |
| C | Leer el ISO | **abierta** — contenedor `.BIN` y LBAs resueltos (6.1); faltan `.WDD` `.DB` `.BKS` `.SSH` `.SLB` |
| D | Escribir | **cerrada** — pnach listo; parche de ISO in-place **anda**, confirmado por efecto |

**N2 — Fases del juego.**

| # | Fase | Criterio de salida | Estado |
|---|---|---|---|
| 0 | Entorno | el emulador corre el juego y las herramientas lo leen | cerrada |
| 1 | Ancla: vida del jugador | la dirección encontrada y confirmada | cerrada |
| 2 | Rutina de daño del jugador | cerrada **por efecto** | cerrada |
| 3 | Enemigos | cerrada **por efecto** | cerrada |
| 4 | Tabla de armas (daño AL jugador) | cerrada | cerrada |
| 4b | Daño de SALIDA del jugador | cerrada **por efecto** | cerrada |
| 5a | Mod de daño | — | **PARQUEADA** |
| 5b | Qué elige la zona de impacto | — | pendiente; **es Opus** |
| 6 | Exprimir el ISO | 6.1 y 6.6 cerradas; el resto sigue con la capacidad C | parcial |
| 7 | Arquitectura de entidades y de la IA | 7a–7d cerradas | **ABIERTA en 7e** |

**Fase en curso: 7e — el índice de módulos del nivel.**

Salió de una pregunta de Fran a mitad de 7d: en vez de subir la cadena de
llamadas eslabón por eslabón cada vez que se quiere tocar algo, buscar si el
juego tiene un índice. **Lo tiene.** El stage es un stream de registros tipados
de `0x10` bytes `{u32 tipo, u32 ptr, u64 payload}` precedido por
`{u32 count, u32 array}`, y **`FUN_0015EF48` es su dispatcher: 61 casos, tipos
`0x03`–`0x44`**. Ese `switch` es el esquema del archivo de nivel: una rama por
tipo de módulo.

Es la vía de **mayor apalancamiento** que hay abierta: sirve igual a la Fase 6
(exprimir el ISO) que a la 7.

**Qué la cierra, exactamente:**

1. Los **61 casos traducidos a un esquema en `kb/`** que diga, por cada tipo,
   **qué estructura consume** y **qué subsistema toca**.
2. Y **al menos un tipo distinto del `0x0A` verificado por efecto**, para que el
   esquema no quede en papel.

El punto 2 es el que no se puede aflojar: es la diferencia entre un esquema
leído y uno medido, y este proyecto ya pagó esa diferencia dos veces (ver
riesgos).

**Lo que ya está cerrado adentro de 7e, y no se rehace:**

- **Paso 1, cerrado el 2026-08-23** (bitácora (36), en frío): el layout estaba
  *leído*, y al medirlo salió **corregido** — `+0x08` no es una posición, es el
  id64 del **nombre** del módulo; `+0x04` es el blob de datos, de tamaño
  variable. Apareció el stream mixto en `0x01092800 = {count=857,
  array=0x0109F590}`, 41 tipos distintos. **Lo encontró un parámetro distinto,
  no más esfuerzo**: por rango de tipo eran 817 rachas; exigiendo monotonía
  estricta del puntero de `+0x04`, tres. Control positivo: el `count` leído y el
  largo derivado por monotonía dan **857 los dos**, por caminos independientes.
- **Paso 2, cerrado el 2026-08-28** (bitácora (37), en frío): el
  *characterization test* del observable del `0x2D` **refutó la premisa del
  plan**. El array vive en `0x004CB1C8`, tiene **48 ranuras y no 256**, y está
  **vacío: 0 de 48** en los nueve volcados de 32 MB del repo. El «255 de 256»
  nunca fue posible: el despachador llama al handler sólo si `blob[0x1E] == 1`,
  y de los 256 registros `0x2D` pasan **cuatro**.
- **El stream está en el ISO y es direccionable** (2026-08-28): sale de
  `/LEVELS/LEVEL_00/STG_0001/STUNIT01.BIN`, LBA 1056910, que se carga en
  `0x01053000`. Disco contra RAM: **98,46 %**, contra un piso de ruido de
  10,6–36,1 % con seis bases equivocadas; `tipo` e `id64` idénticos **857/857**.
  Corrige el modelo de «carga literal»: los punteros son **auto-relativos al
  inicio de su propia struct** y el cargador los pasa a absolutos en el lugar.
  **La mitad «por efecto» de 7e es un parche in-place de ISO**, el procedimiento
  ya confirmado tres veces.

**Lo que queda abierto y no hay que dar por sabido:**

- **Cero registros `0x0A` en ese stream**, y LEVEL_00 tiene cinco enemigos: el
  `0x0A` sigue confirmado por 7d, pero **no sale de ahí**.
- Los tipos `0x01`/`0x02` (escuadra) y `0x33` **están en los datos y no entre
  los 61 casos**: caen en el `default`. El `switch` es el esquema de lo que
  *ese* dispatcher construye, **no del archivo entero**.
- **Hace falta un observable nuevo.** Los dos que había están muertos, los dos
  medidos (ver riesgos). Elegir el próximo **antes** de abrir el emulador, y
  escribir qué se espera ver.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| **El observable elegido no existe** | alta — pasó **dos veces**: los mensajes de error son un `printf` stub y un `sprintf` a un buffer de stack que nadie lee, y el array del `0x2D` está vacío | alta: se gasta una sesión de emulador y no se mide nada | mitigar: **characterization test en frío del observable antes de usarlo**, y escribir la predicción antes de abrir el emulador | cualquier plan que diga «vamos a ver que pase X» sin haber medido que X se pueda ver |
| Se daña el **ISO original** | baja | **irrecuperable** | evitar, con tres capas: ReadOnly del SO, hook `PreToolUse` y la integridad medida en `abrir-sesion.ps1` | que `abrir-sesion.ps1` salga en rojo, o que el guardia bloquee algo |
| **Ghidra pierde un argumento** y la lectura del desensamblado da una conclusión falsa | media — ya pasó: en `0x001759A4 jal 0x00129160`, `a1` todavía traía el id64 porque el delay slot escribe `s1`, no `a1` | alta: se construye encima de una premisa falsa | mitigar: la lectura del descompilado se contrasta contra las **instrucciones**, y lo importante se confirma por efecto | cualquier conclusión que dependa de qué argumento recibe una función |
| Un resultado se reporta **un escalón más arriba de lo medido** | media | alta: la sesión siguiente no lo revisa | mitigar: `hipótesis` / `probable` / `confirmado` anotado en cada línea, y el estado se corrige cuando la bitácora lo contradice | una afirmación sin grado |
| El estado de la máquina **se lee en vez de medirse** | media — ya pasó: PCSX2-MCP estaba bajado desde el 2026-08-15 y varias sesiones lo dieron por ausente porque el repo lo decía | media: se rehace trabajo hecho | mitigar: `inventario.py` y `ubicaciones.py` antes de afirmar que algo falta | cualquier «no está instalado» que no venga de correr el inventario |
| Se pierde lo que sólo vive en el emulador (savestates, parches en RAM) al reiniciarlo | alta | baja si está anotado | aceptar, y anotar en el handoff qué se pierde | reiniciar el emulador |
| **`Test-Path` sobre rutas con corchetes** da falso negativo (la carpeta de los ISO es `Black [NTSC]`) | media | media: se concluye que un archivo no existe | evitar: el verificador de rutas está en **Python**, no en PowerShell | cualquier chequeo de existencia escrito en PowerShell sobre esas rutas |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-08-17 | **Parche de ISO in-place** como camino permanente | pnach solamente | el pnach no sobrevive a cerrar el emulador, que es el objetivo N0 |
| (temprano) | El **default es en frío**: ELF, ISO y volcados ya tomados | abrir el emulador para explorar | abrirlo «para ver» cuesta una sesión y no produce evidencia |
| (temprano) | Las rutas viven en `kb/ubicaciones.json` y se **miden** | copiarlas a mano en cada script | ya costó dos turnos, y el `Test-Path` con corchetes lo empeora |
| 2026-08-22 | **Cerrar 7b con el negativo**: `+0x78` decide sólo el modelo visual del arma; el comportamiento de IA se resuelve por otra vía | seguir con `+0x8C` y `+0xA8` | el experimento estaba completo en sus dos mitades (causa confirmada, no-efecto confirmado); los candidatos quedan anotados en `kb/estructuras.json` |
| 2026-08-23 | Buscar el **índice de módulos** en vez de subir la cadena de llamadas cada vez | seguir eslabón por eslabón | es la diferencia entre un parámetro y una estructura: el índice sirve a la fase 6 y a la 7 a la vez |
| 2026-08-28 | El experimento por efecto de 7e se hace con **parche in-place de ISO** | probar en RAM primero | los punteros del stream son auto-relativos y el cargador los absolutiza: el archivo en disco es direccionable y el procedimiento ya está confirmado tres veces |
| 2026-08-28 | Este PDP **no duplica** el mapa de fases de `ESTADO_ACTUAL.md` | copiarlo acá | un dato que vive en dos lados diverge, y el mapa se actualiza cada vez que cambia algo real |

## 7. Verificación

**Cómo se verifica cada entregable.** Lo primero de cualquier sesión es un solo
comando, y sale en rojo si algo falta:

```powershell
.\proyectos\ingenieria\black\abrir-sesion.ps1
```

Corre los tres controles de apertura —ubicaciones, inventario y el control
positivo de Ghidra— más la integridad de los archivos protegidos. Con `-Rapido`
saltea Ghidra, que es el único lento.

Un hallazgo se da por **confirmado** sólo si:

1. está medido **por efecto** sobre el objeto real (RAM, pantalla, o el archivo
   en disco), no leído del descompilado;
2. tiene **control positivo** — algo que ya se sabía y que la misma medición
   tiene que reproducir; y
3. tiene **piso de ruido** cuando la medición es una comparación (el 98,46 % de
   disco contra RAM vale porque las seis bases equivocadas dan 10,6–36,1 %).

**Qué se registra de cada verificación:** qué se midió y sobre qué versión —ISO,
volcado, savestate—, en qué difiere del entorno real, el resultado por
requisito, y **las deficiencias y límites detectados**. La bitácora
(`docs/03-bitacora.md`) la lleva; `ESTADO_ACTUAL.md` guarda el índice
operativo, y si las dos se contradicen **manda la bitácora**.

**El verificador, ¿alguna vez falló?** Sí, y de las dos maneras que importan:

- `probar-hooks.ps1` corre **38 casos** que rompen cada freno a propósito y
  exigen ver el rojo, más los controles positivos.
- El guardia del ISO **bloqueó mal su primer comando legítimo**: `\bdel\b`
  matcheaba el «DEL» de una frase en español. Se corrigió el patrón y se volvió
  a correr la batería — el freno no se saca, se arregla.
- El guardia **falla cerrado** si su propio archivo de configuración no parsea
  (commit `3ea0054`). Un guardia que se rinde cuando su config está rota deja
  pasar todo justo cuando menos se lo espera.
