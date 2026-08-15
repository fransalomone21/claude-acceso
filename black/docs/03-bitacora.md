# Bitácora

Registro del proyecto. **Lo nuevo va arriba.** Al retomar, alcanza con leer las
dos primeras entradas.

Formato de cada entrada:

```
## AAAA-MM-DD — título corto
**Máquina:** PC / notebook / nube · **Modelo:** Opus / Sonnet / Haiku
**Objetivo:** qué se venía a hacer
**Resultado:** qué se logró
**No funcionó:** los callejones sin salida. Esta parte no es opcional.
**Sigue:** el próximo paso concreto
```

---

## 2026-08-15 (16) — Estructura del ISO montado, sin pegarle a la tabla de armas

**Máquina:** notebook · **Modelo:** Sonnet

**Objetivo:** con la Fase 2 cerrada, relevar qué hay "a mano" en el ISO antes
de volver a hurgar en vivo, para no depender del emulador para todo.

**Resultado:**

- **`Black.iso` (3.9 GB) montado en `D:\` con `Mount-DiskImage`** (no estaba
  montado; lo que el usuario había visto antes fue una sesión anterior de
  Explorador). Estructura de primer nivel: `IOP/` (módulos IOP), `LANGUAGE/`,
  `LEVELS/` (`GLOBAL/` + `LEVEL_00`..`LEVEL_08`, sin `LEVEL_02`), `SOUND/`,
  `VIDEOS/`, `CHARS/` (incluye `GUNS/`), `DATA/`, `EXPORT/FRONTEND/`,
  `GLOBDATA.BIN`, `SYSTEM.CNF`, **`SLUS_213.76`** (el ejecutable principal).
- Cada nivel trae su propio `FPGUNS/` (modelos/animaciones de primera persona
  por arma: AK1, AK5, AS5, ASR, BNS, HV5, HVY, PS5, PST, RPG, SH5, SHG, SM5,
  SMG, SN5, SNR — códigos de 3 letras, probablemente el prefijo real de cada
  arma en el juego) y subcarpetas `STG_NNNN/` con `GUNS.BIN` / `GUNS_S.BIN`
  por stage.
- **Hipótesis de tabla de armas NO confirmada por este camino.** Se buscó el
  float `26.0` (daño confirmado del jugador) en `LEVEL_00/STG_0001/GUNS.BIN`
  y `GUNS_S.BIN`: cero coincidencias — esos archivos son geometría/spawn de
  armas en el nivel, no una tabla de stats. En `SLUS_213.76` sí aparecen 4
  coincidencias de `26.0` (offsets de archivo 2960626, 3006466, 3086690,
  3087238), contra los 5 sitios ya conocidos en RAM
  (`0x0042C3AC`..`0x0042D56C`, ver `ESTADO_ACTUAL.md`). El espaciado entre los
  4 offsets de archivo NO coincide con el espaciado entre las 5 direcciones de
  RAM con una base lineal simple — esperable en un ELF con program headers no
  contiguos. **No vale la pena seguir esto sin parsear los program headers del
  ELF**; más barato confirmarlo en vivo con un watchpoint de lectura sobre
  `0x0042C3AC` (ya estaba planeado en `ESTADO_ACTUAL.md`).

**No funcionó:**

- Buscar el offset RAM↔archivo a ojo asumiendo un `base` constante. Un ELF PS2
  no necesariamente mapea `.text`/`.data`/`.rodata` de forma contigua; hace
  falta leer `Elf32_Phdr` (offset, vaddr, filesz) para traducir bien.

**Sigue:** volver al trabajo en vivo — test de genericidad de la rutina de
daño (`0x0013C120`), que era el próximo paso antes de esta desviación al ISO.
El ISO queda montado en `D:\` por si hace falta volver (no se desmontó).

---

## 2026-08-15 (18) — `0x0013C120` FALSIFICADO por efecto; los "8 candidatos" nunca fueron el conjunto real

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** cerrar Fase 3 (¿es genérica la rutina de daño?).

**Resultado:**

- **Se replanteó el test entero.** Veníamos buscando la dirección de vida de
  un enemigo para poner un watchpoint. No hacía falta: la pregunta de la Fase
  3 se contesta **sin localizar nada** — nopear `0x0013C120` y mirar si los
  enemigos dejan de recibir daño. Mismo movimiento que cerró la Fase 2.
- **`0x0013C120` NO es el brazo de daño de los enemigos. FALSIFICADO por
  efecto.** Se nopeó en vivo por PINE (`0xE61602F8` → `0x00000000`), el
  usuario descargó la AK sobre un enemigo y murió normal, en 4-5 balas.
  **Confound descartado:** se releyó `0x0013C120` DESPUÉS del test y seguía en
  `0`, así que el nop aguantó — el test es válido. Restaurado.
- **Las escrituras de código por PINE persisten y el recompilador las
  respeta.** El nop del jugador (`0x0013BD20`) seguía puesto horas después.
- **Los "8 candidatos" de la sesión anterior nunca fueron el conjunto real.**
  `xref.py stores 0x2F8 --fpu` filtra por cercanía a un `sub.s`/`add.s`, y ese
  filtro **deja afuera a `0x0013BD20` y a `0x0013C120`**, que son justamente
  los dos sitios que sí importaban. Se enumeró el conjunto verdadero a mano
  (decodificando `swc1` = opcode `0x39`, offset `0x2F8`): **24 stores**,
  listados con su codificación en `volcados/stores-2f8-originales.txt`.
- **Test decisivo montado pero NO ejecutado** (se acabó el contexto): se
  nopearon los 24 a la vez, verificado 24/24, y se restauraron los 24 con 0
  discrepancias. Falta el disparo del usuario.
- **Descartado el atajo del último nivel.** Los saves de GameFAQs para Black
  son Max Drive / CodeBreaker / X-Port — no son memory cards ni savestates de
  PCSX2. Usarlos pide bajar un binario de un fan site y convertirlo con
  herramientas de terceros que no tenemos. No lo vale: el problema real es
  "un enemigo que aguante más golpes", no "el último nivel".

**No funcionó:**

- **Atajo estructural sobre el pool de entidades.** Se volcó
  `0x00580000-0x00600000` en vivo y se buscó la forma del struct del jugador
  (`+0xC4` estado chico, `+0x2F8` vida f32 entera). Dio 12 candidatos, y
  **ninguno sostuvo su valor en una relectura** — es memoria dinámica
  reciclada (partículas/física), no una tabla de entidades. Descartado.
- Proponer la pistola como "arma más débil": el usuario ya había dicho que la
  AK es la que menos daño hace. Error de lectura, no de método.

**Sigue:** UN solo experimento, ya preparado y barato:

```
# nopear los 24 (la lista con codificaciones esta en volcados/stores-2f8-originales.txt)
# disparar a un enemigo con la AK
```

- Si el enemigo se vuelve **invulnerable** → el camino de daño del enemigo
  está entre los 24; bisecar (12, 6, 3...) — 4-5 disparos y cae.
- Si muere **igual, en 4-5 balas** → **la vida del enemigo NO está en
  `+0x2F8`**. Eso redirige la búsqueda entera: el struct del enemigo sería
  distinto del struct del jugador, y habría que buscar su offset de vida
  desde cero.

Los dos resultados son informativos. Es el mejor experimento disponible.

---

## 2026-08-15 (17) — Dos enemigos muertos antes de converger; la estática dice "genérica"

**Máquina:** notebook · **Modelo:** Sonnet

**Objetivo:** confirmar EN VIVO si `0x0013C120` es el brazo de daño de una
entidad genérica (test de la hipótesis abierta), localizando primero la vida
de un enemigo por escaneo diferencial (mismo método que con el jugador).

**Resultado:**

- **Dos intentos de escaneo diferencial sobre enemigos, ninguno convergió.**
  AK47 en dificultad difícil mata al enemigo en 3-4 tiros, y el escaneo
  reduce candidatos ~5-6× por ronda (arranca en ~8.1M posiciones): no alcanza
  el número de rondas antes de que el enemigo muera. Enemigo 1: murió en 874
  candidatos. Enemigo 2: murió en 5.521; un filtro `entre=1:2000` (sin
  necesidad de disparo nuevo) lo bajó a 885, y una poda manual a valores
  enteros lo bajó a 142 — pero sigue siendo ruido del motor (flags en 1.0,
  bloques en 128.0, nada que se vea como vida de enemigo), no un candidato
  limpio. **La vida del enemigo sigue sin localizarse.**
- **Lección de proceso, ya aplicada a mitad de sesión:** en el primer enemigo
  hubo un desfase real — corrí `filtrar bajo` antes de que el tiro del
  usuario llegara a impactar, lo que probablemente descartó el candidato
  verdadero en esa ronda (un filtro relativo compara contra la foto anterior;
  si nada cambió entre dos fotos, el candidato real queda fuera igual que el
  ruido). Se corrigió el protocolo: esperar la confirmación explícita del
  usuario ("ya" DESPUÉS de disparar) antes de correr el filtro.
- **Desensamblado con `mips.py` del bloque candidato (`0x0013C060-0x0013C180`)
  contra el bloque confirmado del jugador (`0x0013BC80-0x0013BDA0`).** Mismo
  patrón exacto: lectura de un campo de estado en `+0xC4` (`lw ??,0xC4(base)`),
  comparación contra valores pequeños (3/4 en el candidato, 1 en el jugador),
  hasta dos llamadas condicionales a subrutinas, y recién ahí el store de la
  vida en `+0x2F8` con clamp (dos brazos: piso de muerte y resta normal).
  El bloque del jugador usa `s0`/`s2` como base; el candidato usa `s1`/`s0`.
  Estructura idéntica, sólo cambia la asignación de registros — consistente
  con una rutina genérica de "entidad recibe daño" inlineada dos veces por el
  compilador para distintos call sites, tal como venía la hipótesis. **Sigue
  siendo hipótesis, no confirmación**: no hay efecto visto en pantalla sobre
  un enemigo real.

**No funcionó:**

- Escanear diferencialmente la vida de un enemigo con AK47 en difícil: muere
  antes de converger. El enfoque no escala con enemigos frágiles.
- Podar por "valor entero razonable" (`entre=1:2000` + filtro manual de parte
  fraccionaria) no alcanza para aislar un candidato: hay demasiadas
  constantes enteras del motor (1.0, 128.0, 320.0...) en ese rango.

**Sigue:** para la próxima sesión en vivo, dos caminos más baratos que seguir
grindeando con la AK en difícil:
1. Usar el arma de MENOR daño (pistola) contra un enemigo normal — más tiros
   antes de morir, más rondas de filtro antes de que se acabe.
2. Buscar un enemigo que aguante más golpes (armadura pesada / mini-boss) en
   vez de un soldado raso.
Ninguno de los dos se probó todavía. La confirmación de genericidad sigue
pendiente del efecto en pantalla — la evidencia estática es fuerte pero no
alcanza sola (regla 1 del proyecto).

---

## 2026-08-15 (15) — La base estaba mal: la rutina de daño en dos horas

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** instalar el PCSX2 parcheado (PCSX2-MCP) y desempatar los 69
candidatos a instrucción de escritura de la vida.

**Resultado:**

- **Se instaló el PCSX2 parcheado y se escribió `herramientas/depurador.py`**,
  un cliente del `DebugServer` (JSON por newline sobre TCP 21512). **No hizo
  falta registrar el MCP ni reiniciar la sesión**: el protocolo está
  documentado en el fuente del parche, así que se habla directo desde Python.
  Eso preservó el contexto entero de la sesión.
- **La base del objeto del jugador estaba MAL.** No es `0x005A8D80` sino
  **`0x005A8AB0`**, y la vida es **`+0x2F8`**, no `+0x28`. Los 69 candidatos
  estaban buscando el offset equivocado: el problema estaba mal planteado.
- **Cómo se destrabó:** un watchpoint de **lectura** sobre la vida. El juego la
  lee cada frame para dibujar el HUD, así que dispara al instante y sin que el
  usuario tenga que hacer nada. Al pausar, se leyó el **registro base en vivo**
  (`a2 = 0x005A8AB0`) — eso es lo que dio la base real. Confirmado:
  `0x005A8AB0 + 0x2F8 = 0x005A8DA8` exacto.
- **Rehecha la búsqueda con el offset correcto: de 69 candidatos a 8**, todos
  agrupados en `0x00134xxx-0x0013Cxxx`.
- **Rutina de daño localizada** (`probable`, falta confirmar con efecto):
  ```
  0x0013C0DC  sub.s  f22, f22, f21     ; vida = vida - daño
  0x0013C0E0  c.le.s f22, f20          ; ¿por debajo del piso?
  0x0013C0E8  bc1f   ->0x0013C120
  0x0013C0F0  swc1   f20, 0x2F8(s0)    ; muerte: clamp al piso
  0x0013C120  swc1   f22, 0x2F8(s0)    ; DAÑO NORMAL
  ```
- **1200.0 y 750.0 hardcodeados** en el código que lee la vida
  (`div.s f12, vida, 1200.0`). **El recuerdo de "vida máxima ~1200" era
  correcto**; el handoff anterior lo había declarado falso. Es el denominador
  de la barra del HUD.
- **`gp = 0x004157F0`**, dato nuevo: permite resolver todos los accesos
  `gp`-relativos del desensamblado.
- Herramienta nueva: `herramientas/volcar_vivo.py` — vuelca la RAM del EE por
  `read_memory` (64 KB por viaje). Los 2.8 MB de código salen en segundos;
  con `pine.py` habrían sido 350 mil viajes.

**No funcionó:**

- **`--accion log` de los watchpoints no cuenta nada.** Es el mismo stub vacío
  que `MemCheck::Log()` del PCSX2 oficial; el parche no lo arregla. Se detectó
  con una prueba de control sobre el timer del motor: el valor cambiaba entre
  lecturas y el contador seguía en 0. **Hay que usar `--accion break`.**
- **`OnBreakpointHit()` del parche es un stub** ("Future: notify connected
  clients"). No hay aviso asincrónico: `esperar` hace polling de `status`.
- **Los savestates viejos no cargan** en la build parcheada: se declara versión
  "Unknown" y rechaza los de la 2.6.3. No son intercambiables en ningún sentido.
- **Se volvió a quemar contexto con un flujo multi-agente** (~100k tokens) para
  un trabajo que después se hizo directo en unos pocos comandos. Es la lección
  9 otra vez, y estaba escrita. Ver `/lecciones-aprendidas`.
- La vida **no se escribe** mientras el jugador está quieto: un watchpoint de
  escritura no dispara solo. El de **lectura** sí, y por eso fue el camino.

**Addendum del cierre — los breakpoints de ejecución matan el emulador.**
Al intentar confirmar la rutina con `bp poner 0x0013C120`, el `set_breakpoint`
cortó la conexión a mitad del comando y el proceso `pcsx2-qt.exe` desapareció.
Contrasta con evidencia dura de la misma sesión: los **watchpoints** pausaron y
resumieron limpio decenas de veces (control sobre el timer, y lectura sobre la
vida). O sea: **watchpoints sí, breakpoints de ejecución no.**

Lo caro no fue el crash (el savestate estaba hecho): fue no haberlo previsto
teniendo la evidencia delante. El plan decía "un breakpoint de memoria" y se
ejecutó un breakpoint de ejecución, que es otra cosa. `depurador.py` ahora
exige `--se-que-crashea` para `bp poner`, y el guard corre **antes de
conectar** — así avisa aunque el emulador esté caído.

**Sigue:** confirmar con efecto, pero con **watchpoint de escritura** sobre
`0x005A8DA8` y recibiendo un golpe. Si al pausar el PC es `0x0013C120`, la
rutina queda confirmada — y es evidencia más fuerte que un breakpoint puesto a
mano sobre la dirección que ya se sospechaba: se deja que el juego la delate.
Después: ¿la rutina es genérica (jugador y enemigos comparten `+0x2F8`)? Si lo
es, caen las Fases 3 y 5 juntas.

---

## 2026-08-15 (14) — Fase 2 sin debugger: la vida es un campo, no un global

**Máquina:** notebook · **Modelo:** Opus

**Objetivo:** decidir el entorno de la Fase 2 (¿instalar una build parchada de
PCSX2 para tener breakpoints automatizables?) y arrancar la rutina de daño.

**Resultado:**

- **La pregunta del entorno se disolvió.** Cuatro comandos sobre un savestate
  que ya estaba en disco entregaron tres de los cuatro objetivos de la Fase 2,
  sin debugger, sin instalar nada y sin riesgo.
- **`0x005A8DA8` NO es un global.** Cero instrucciones en los 32 MB arman esa
  dirección (`lui`+`addiu`/`ori`), y no aparece como palabra suelta. "Estática"
  significaba que el cargador de nivel asigna el objeto siempre en la misma
  posición, no que sea una variable global. Se llega por puntero.
- **Base del objeto del jugador: `0x005A8D80`, vida en `+0x28`** (probable).
  Único candidato a distancia corta; figura como valor en `0x004C5E1C` y
  `0x004C5E30`. Layout coherente: cápsula de colisión en +0x10/+0x14, altura
  1.65 en +0x18, vida en +0x28. → `kb/estructuras.json#jugador`.
- **`FLT_MAX` en `+0x30`** (hipótesis fuerte): candidato a vida máxima. Si es
  eso, cierra la pregunta abierta desde el checkpoint 1 — no hay techo.
  → `kb/mapa-memoria.json#vida_maxima_candidata`.
- **Mapa de memoria:** código en `0x00100000-0x003BFFFF`, datos en
  `~0x0042xxxx-0x0045xxxx`. Corroborado por dos vías independientes.
- **Pista de la tabla de armas:** el flotante 26.0 (el daño exacto por golpe)
  aparece cinco veces agrupadas en la región de datos. → `kb/estructuras.json#arma`.
- **Herramienta nueva: `herramientas/xref.py`** — automatiza los cuatro
  sondeos (`absoluto`, `punteros`, `stores`, `mapa`). Se hicieron a mano una
  vez; a la segunda ya no.

**No funcionó / callejones:**

- **Se gastó ~500k tokens en un workflow de 10 agentes** para investigar el
  entorno. Fue un error de criterio: la mitad de lo que se mandó a investigar
  ya estaba en el contexto de la conversación, y cada agente arrancó en frío a
  re-derivarlo. Lo que destrabó el problema fueron cuatro comandos secuenciales
  donde cada uno dependía del anterior — exactamente la forma que un fan-out
  hace peor. → lección 9 de `/lecciones-aprendidas`.
- **La hipótesis inicial era falsa.** Se dio por sentado que una dirección
  estática se direcciona por absoluto. El primer sondeo la mató (0 resultados)
  y eso fue lo más informativo de la sesión. → lección 10.
- **El checkbox "Log" del breakpoint de memoria de PCSX2 no sirve:**
  `MemCheck::Log()` es un stub vacío en el fuente. Se había planificado
  alrededor de esa función (jugar con logging y leer `emulog.txt` después).
- **La ruta del menú del debugger estaba mal en tres documentos**
  (`Tools > Show Debugger`). En PCSX2 2.x es `Tools > Show Advanced Settings`
  y después `Debug > Open Debugger`. Corregido.
- **`sw` vs `swc1`:** cuatro documentos decían que la vida la escribe un `sw`.
  Es `f32`: la instrucción es `swc1`. Corregido.
- **Riesgo abierto:** issue #5343 de PCSX2 (los breakpoints de memoria cuelgan
  la emulación en builds x64 de Windows) figura cerrado pero no se encontró el
  commit que lo arregla. Probar con savestate y sobre una dirección inocua.
- **PCSX2-MCP:** revisado el fuente, no el binario. Ver `docs/01-entorno.md`.

**Sigue:** desempatar los 69 candidatos a instrucción de escritura. Tres
caminos baratos, en orden de costo: (a) `vigilar.py` sobre los 0x60 bytes del
objeto para confirmar que `0x005A8D80` es el jugador; (b) escribir un finito en
`+0x30` y curarse, para matar o confirmar la vida máxima; (c) `inspeccionar.py`
sobre `0x0042C3AC` a ver si es la tabla de armas.

---

## 2026-08-15 (13) — Fase 1 cerrada: `0x005A8DA8` confirmada estática

**Máquina:** notebook · **Modelo:** Sonnet

**Objetivo:** determinar si la dirección de vida es estática o dinámica entre cargas de nivel.

**Resultado:**

- Leída la dirección al iniciar la sesión: 333.0 (valor escrito en la sesión anterior).
- Recarga de nivel: la dirección devolvió **750.0** (HP inicial coherente, no basura).
- Dos golpes recibidos: **698.0** = 750 − 2×26. El daño de 26.0 se mantiene exacto.
- **`0x005A8DA8` es ESTÁTICA.** Sobrevive recargas y sigue siendo la fuente de vida.
- `kb/mapa-memoria.json`: `estable: true`, evidencia actualizada.
- `ESTADO_ACTUAL.md`: Fase 1 cerrada, próxima acción = Fase 2 (rutina de daño, Opus + debugger de PCSX2).

**No funcionó:** nada — experimento limpio en un solo intento.

**Sigue:** Fase 2. Breakpoint de escritura en `0x005A8DA8` desde el debugger de PCSX2 GUI → encontrar la instrucción `sw` → rutina de daño → estructura del jugador. Modelo: **Opus**.

---

## 2026-08-15 (12) — el mismo `Δ` en `inspeccionar.py`, y una sola definición para los dos

**Máquina:** PC · **Modelo:** Opus

**Objetivo:** cerrar el pendiente que dejó la entrada (11): `inspeccionar.py`
tenía el mismo `Δ` (U+0394) que hacía crashear a `vigilar.py`.

**Resultado:**

- **Reproducido antes de tocar nada**, con dos savestates sintéticos y
  `PYTHONIOENCODING=cp1252`: `inspeccionar.py comparar` moría con
  `UnicodeEncodeError` en `inspeccionar.py:162`. **Acá era peor que en
  `vigilar`**: el `Δ` está en la *cabecera* de la tabla, así que el comando
  imprimía "3 campo(s) cambiaron" y se moría antes de mostrar un solo campo —
  o sea, perdía exactamente lo único que tiene para dar.
- **Las dos funciones se movieron a `herramientas/salida.py`**, y ahora
  `vigilar.py` e `inspeccionar.py` importan de ahí. No se duplicaron.
- **Por qué un módulo y no una copia:** `inspeccionar.py` no puede importar
  `vigilar.py` (este hace `from pine import ...` a nivel de módulo, mientras
  que `inspeccionar` importa `pine` adentro de las funciones justo para poder
  trabajar desde savestates sin PCSX2 abierto). Y duplicar un workaround de
  codificación en dos archivos es literalmente cómo se llegó a este bug: la
  primera versión vivió suelta en `vigilar.py` y su hermana quedó rota. El
  proyecto ya comparte así (`pnach.py` importa `mips` y `estado`).
- Como `vigilar.py` reexporta lo que importa, las pruebas que ya existían
  siguen andando sin tocarlas.
- `pruebas/prueba_herramientas.py`: **102 comprobaciones, todo bien.**

**No funcionó / lo que hay que mirar:**

- Nada se rompió en el camino. Lo que sí quedó claro es que la prueba nueva
  tenía que correr el **CLI de verdad**: se verificó que falla contra el
  `inspeccionar.py` viejo (código 1 + traceback) y pasa contra el nuevo. Una
  prueba de regresión que no falla contra el código roto no prueba nada.
- Quedan cinco herramientas más (`escanear`, `pnach`, `estado`, `pine`,
  `fijar_objetivo`) que imprimen tildes y `ñ` sin llamar a
  `tolerar_salida_pobre()`. Hoy no las rompe nada (cp1252 tiene esos
  caracteres), pero bajo `LC_ALL=C` reventarían igual. **No se tocaron**: no
  hay evidencia de que esté pasando, y el arreglo está a una línea el día que
  pase.
- **`pruebas/prueba_herramientas.py` borra un archivo trackeado**: hace
  `rmtree` de `construido/` al final y se lleva puesto `construido/.gitkeep`.
  Hay que restaurarlo a mano después de cada corrida. Sigue sin arreglar.

**Sigue:** sin cambios respecto de la entrada (11) — determinar si
`0x005A8DA8` es estable o dinámica entre cargas de nivel.

---

## 2026-08-15 (11) — `vigilar.py analizar` arreglado: el `Δ` mataba el comando

**Máquina:** PC · **Modelo:** Opus

**Objetivo:** arreglar el bug que dejó la entrada (10): `analizar` imprimía el
análisis y reventaba con traceback justo al llegar a `primeros:`, así que
`volcados/correlacion-vida-2.csv` hubo que leerlo a mano.

**Resultado:**

- **Causa raíz: `UnicodeEncodeError` por el `Δ` (U+0394) de la línea
  `primeros:`.** Cuando la salida se redirige en Windows (a un archivo, a un
  pipe, o a una herramienta que la captura), Python deja de hablarle a la
  consola y codifica con la página de códigos local — `cp1252` acá, que no
  tiene U+0394. El `print` entero muere. No era un problema de los datos: el
  CSV no tenía nada raro. Por eso cortaba **siempre** en el mismo lugar y las
  líneas anteriores salían bien: `ñ`, `±` y las tildes sí existen en cp1252;
  el `Δ` era el único carácter fuera del juego.
- **Arreglo** (`herramientas/vigilar.py`): `simbolo_delta()` elige `Δ` o `d`
  según lo que la salida sepa codificar, y `tolerar_salida_pobre()` pone
  `errors="replace"` en stdout/stderr como red para el resto del texto (bajo
  `LC_ALL=C`, con stdout en ASCII, también reventarían `ñ` y `±`). No se
  fuerza UTF-8 en el flujo a propósito: arreglaría el `Δ` pero convertiría
  `tamaño` en mojibake en las consolas que hoy lo muestran bien.
- **Evidencia:** con `PYTHONIOENCODING=cp1252` sobre un CSV sintético de 900
  filas, la versión vieja sale con código 1 y traceback (`vigilar.py:175`); la
  nueva imprime el análisis entero y sale con 0. En UTF-8 el `Δ` se sigue
  viendo; en ASCII degrada a `d` y `?` sin cortar.
- `pruebas/prueba_herramientas.py`: 96 comprobaciones, todo bien.

**No funcionó / lo que hay que mirar:**

- **La prueba que ya existía no podía ver este bug, y eso es lo importante.**
  Llamaba a `vigilar.analizar()` en proceso con `redirect_stdout` a un
  `StringIO`, que no codifica nada: pasaba en verde mientras el comando real
  fallaba el 100% de las veces. La prueba nueva cruza la misma frontera que el
  uso real — subproceso, salida redirigida, `PYTHONIOENCODING=cp1252` — y
  falla contra el código viejo.
- **`herramientas/inspeccionar.py:162` tiene el mismo `Δ`** en la cabecera de
  `comparar`. Es el mismo bug esperando, en la herramienta hermana del mismo
  flujo. **No se tocó** (queda fuera del alcance de esta tarea), pero va a
  crashear igual apenas se redirija la salida.

**Sigue:** lo que ya venía — determinar si `0x005A8DA8` es estable o dinámica
entre cargas de nivel (ver `ESTADO_ACTUAL.md`). `analizar` ya se puede usar
sin leer los CSV a mano.

---

## 2026-08-15 (10) — **CHECKPOINT 1 CERRADO**: vida del jugador confirmada en `0x005A8DA8`

**Máquina:** notebook (local) · **Modelo:** Sonnet, después Opus (innecesario, ver abajo)

**Objetivo:** cerrar el escalón 1 — confirmar cuál de los 5 candidatos era la vida.

**Resultado:**

- **`0x005A8DA8` = vida del jugador, `f32`, NTSC-U — `confirmado`.**
- Daño por golpe: **26.0 constante**.
- Máximo observado: ~440 tras curación, pero se vio 649.79 en otra — el techo
  real no está determinado.
- `0x006CF54C` = **segmentos dibujados de la barra del HUD** (rango 2..8), valor
  **derivado**, no fuente. Esto explica el crash de la sesión anterior: escribirle
  999 le metió un índice fuera de rango al render.
- `0x0040E6A0` **descartado**: cambia en cada muestreo a 10 Hz, siempre bajando.
  Es un timer del motor.

**Cómo se confirmó (tres capas de evidencia):**

1. **Correlación temporal.** `vigilar.py` a 10 Hz durante 90s
   (`volcados/correlacion-vida-2.csv`) contra los eventos que narraba el usuario:
   sube ~210 en cada curación (t=7.0s, t=84.8s), baja exactamente 26.0 por golpe
   (t=32-33s, t=69s, t=87s).
2. **Causalidad.** Al escribir 130.0 en `0x005A8DA8`, el HUD (`0x006CF54C`) se
   recalculó solo de 8 a 1. La lógica del juego lee esta dirección.
3. **En pantalla.** Se escribió 333.0 y el usuario vio bajar la barra de vida
   **mientras la munición quedaba intacta** — lo que descartó la hipótesis
   alternativa de que fuera munición de reserva (el HUD mostraba `440`, muy
   cerca del máximo de vida observado).

**No funcionó / callejones:**

- **Auditoría de automatización del debugger.** Se verificó a fondo si Claude
  podía manejar breakpoints solo: la tabla de opcodes de PINE es contigua
  `0x00`-`0x0F` (read/write/savestate/metadata) y **no tiene opcode de
  breakpoint** — no depende de la versión de PCSX2. Existe un `DebugServer` TCP
  (puerto 21512) que sí los maneja, pero es una **build custom** de PCSX2
  (proyecto PCSX2-MCP), no la oficial. Se comprobó en la máquina: sólo escucha
  28011 (PINE), el binario es `C:\Program Files\PCSX2\PCSX2\pcsx2-qt.exe`
  estándar. **Conclusión: sin build parchada, los breakpoints son manuales.**
- **Pero no hicieron falta.** El replanteo que destrabó todo: la pregunta no era
  "cómo pongo un breakpoint" sino "cómo correlaciono un valor con un evento
  observable". Para eso, **muestrear (`vigilar.py`) le gana a los breakpoints**:
  es sólo lectura, cero riesgo de crash, y no requiere manos en el debugger.
- **El recuerdo de "vida máxima ~1200" era incorrecto** (es ~440+). Se hizo bien
  en no usarlo como filtro fuerte.
- `escanear.py poner` con valores arbitrarios quedó **desaconsejado** como método
  de confirmación: crasheó el emulador. El camino seguro es muestrear primero y
  escribir sólo valores dentro del rango ya observado.
- **Opus no era necesario.** Se cambió a Opus previendo lectura de desensamblado,
  pero el checkpoint se cerró sin abrir el debugger. Sonnet alcanzaba.

**Bug encontrado:** `vigilar.py analizar` crashea con un traceback al imprimir la
sección "primeros" de los escalones. El análisis se hizo leyendo el CSV directo.
Pendiente de arreglar.

**Sigue:** determinar si `0x005A8DA8` es **estable o dinámica** (recargar el nivel
y releer: si mantiene la vida, sirve directo en un `.pnach`; si tiene basura, hay
que llegar por puntero). Después, primer mod real. El escalón 2 (rutina de daño
por breakpoint) queda para cuando se quiera el parche elegante — no está en el
camino crítico del primer mod funcionando.

---

## 2026-08-15 (9) — Checkpoint 1: escaneo diferencial de vida, primer intento de `poner` crashea

**Máquina:** notebook (local) · **Modelo:** Sonnet

**Objetivo:** escalón 1 — encontrar la dirección de la vida del jugador
(ver `docs/02-metodologia.md`).

**Resultado:**

- Sesión `prueba-auto` (de sesiones anteriores) descartada: había quedado en
  0 candidatos por comparar un savestate contra sí mismo. No se reutiliza.
- Sesión nueva `vida-jugador` (`u32`, región `0x00100000-0x02000000`)
  creada con foto inicial por PINE.
- Filtrado diferencial alternando `bajo`/`subio`/`igual` en 8 rondas reales
  contra el juego: 8.126.464 → 155.744 → 37.057 → 7.548 → 4.979 → 2.620 →
  962 → (igual: sin cambio) → 197 → 31 → **5 candidatos**.
- Nota de método: para floats positivos, el orden de bits como entero sin
  signo preserva el orden numérico — el filtrado `u32` sigue siendo válido
  aunque el dato real termine siendo `f32`.
- Candidatos finales:
  - `0x005A8DA8` — float, cientos, venía bajando
  - `0x0065F458` — float, <1, venía bajando
  - `0x006CF54C` — entero chico, bajó limpio 3→2→(999 de prueba)
  - `0x01E68FA4` — entero, salto grande entre rondas
  - `0x01E73EB0` — entero, cayó de 4162 a 0

**No funcionó:**

- `poner vida-jugador --indice 2 --valor 999` (dirección `0x006CF54C`)
  **crasheó el emulador a pantalla negra**. Ese candidato queda marcado
  como riesgoso para escritura directa — probablemente no sea la vida en
  bruto sino un índice, puntero o campo de estado sensible a rango. No
  reintentar `poner` con valores grandes ahí sin motivo nuevo.
- Recuerdo del usuario de que la vida máxima ronda ~1200 (impreciso, sin
  confirmar). Un chequeo estático sobre los candidatos en ese rango no
  alcanzó a decidir por sí solo (demasiados candidatos posibles tanto en
  lectura entera como float) — no usar como filtro fuerte, sólo como
  desempate al final.

**Sigue:** abandonar más pruebas de `poner` a ciegas. Pasar al escalón 2
(`docs/02-metodologia.md`): abrir el debugger de PCSX2 (`Tools > Show
Debugger`), poner breakpoints de **Write** en los candidatos restantes
(sin necesidad de escribir nada — no hay riesgo de crash) y dejar que el
emulador frene solo en la instrucción real que escribe la vida al recibir
daño. Recargar el savestate antes de seguir (el juego quedó crasheado).

---

## 2026-08-14 (8) — Fase 2 infraestructura global: `perfil-global/` + auditoría de entorno

**Máquina:** nube · **Modelo:** Sonnet

**Objetivo:** crear el perfil global reutilizable entre proyectos
(`perfil-global/`) y hacer una auditoría de arquitectura de entorno
para el proyecto BLACK.

**Resultado:**

- `perfil-global/CLAUDE.md` — config global mínima para `~/.claude/`.
  5 reglas absolutas + puntero al skill.
- `perfil-global/engineering-orchestrator/SKILL.md` — metodología
  completa: modelo, effort, contexto, memoria, evidencia, investigación,
  subagents, handoff, cambio de sesión, costos, verificación, no repetición.
- `perfil-global/install.ps1` — instalador PowerShell con backup del
  CLAUDE.md anterior, sin destructivo.
- `perfil-global/verify-install.ps1` — verificación rápida de la
  instalación.
- Auditoría de entorno completada (ver respuesta de sesión). Conclusión:
  LOCAL como entorno primario de BLACK; cloud sólo para código/docs.

**No funcionó:** nada — es trabajo de infraestructura pura.

**Decisión de arquitectura:** el cloud no puede ejecutar PCSX2, Ghidra
ni PINE. Todo el trabajo "en vivo" de BLACK (escaneo, breakpoints,
escritura de memoria) debe correr en la máquina local del usuario.
El cloud tiene valor sólo para escribir y revisar herramientas.

**Sigue:** Checkpoint 1 de BLACK sin cambio (ver `ESTADO_ACTUAL.md`).
Antes de retomar BLACK, el usuario debe: instalar perfil-global en
`%USERPROFILE%\.claude\`; luego abrir Claude Code local y retomar.

---

## 2026-08-14 (7) — Infraestructura de continuidad: `ESTADO_ACTUAL.md` + `sesiones/HANDOFF.md`

**Máquina:** nube · **Modelo:** Sonnet

**Objetivo:** el usuario pidió aplicar una especificación externa
("orquestador de ingeniería") sobre memoria, evidencia y continuidad entre
sesiones. Se evaluó punto por punto en vez de aplicarla literal.

**Resultado:**

- Cerrados triggers/webhooks huérfanos de la sesión anterior (dos
  `send_later` y la suscripción al PR #1) — no había nada corriendo caro,
  pero tampoco tenía sentido dejarlo.
- `ESTADO_ACTUAL.md` (raíz del proyecto): índice operativo compacto. Se lee
  entero al retomar, en vez de la bitácora completa.
- `sesiones/HANDOFF.md`: paquete de traspaso entre sesiones, formato fijo
  (objetivo, hechos, hipótesis, qué no repetir, próxima acción).
- `CLAUDE.md`: la tabla de "qué leer" ahora manda primero a
  `ESTADO_ACTUAL.md`; la bitácora completa queda para cuando hace falta el
  detalle de cómo se llegó a algo.

**Decisión explícita de NO hacer lo que pedía la spec al pie de la letra:**
partir `kb/*.json` en carpetas por estado de confianza
(`confirmed/hypotheses/...`) habría roto todas las herramientas que ya leen
esos archivos (`pnach.py`, `escanear.py`, etc.), y el campo `confianza` que
ya tiene cada entrada cumple la misma función. Se adaptó en vez de clonar
literal.

**No funcionó:** nada — es trabajo de infraestructura, no de BLACK en sí.

**Sigue:** el checkpoint 1 sigue siendo el mismo (ver `ESTADO_ACTUAL.md`).
Pendiente, sin decidir todavía si vale la pena: preparar un skill/CLAUDE.md
*global* (fuera del repo, en `~/.claude/` del usuario) con la filosofía de
ingeniería reutilizable entre proyectos — quedó explícitamente pausado para
no seguir gastando en esta sesión.

---

## 2026-08-14 (6) — Confirmado: la detección automática de Documentos anda en Windows real. Y otro bug chico de la misma familia

**Máquina:** notebook de Fran (Windows) · **Modelo:** Sonnet

**Objetivo:** validar la entrada anterior — si `escanear.py nuevo --pedir`
encuentra el savestate solo, sin `--desde` a mano.

**Resultado:**

- **Confirmado.** `python herramientas\escanear.py nuevo prueba-auto --tipo
  u32 --pedir` encontró `SLUS-21376 (5C891FF1).00.p2s` sin ayuda. La API de
  Windows (`SHGetFolderPathW`) funciona como se esperaba; ya no hace falta
  el `--desde` manual.
- Al filtrar, el mensaje que imprime `escanear.py` decía `python3
  escanear.py filtrar ...` — pero en esta máquina el comando es `python`
  a secas; `python3` ni siquiera existe (Windows lo redirige a la
  Microsoft Store). El propio mensaje de ayuda llevó al usuario a un error.
  Bug de la misma familia que el de Documentos: asumir una convención en vez
  de preguntarle al sistema. Arreglado con `PY = os.path.basename(sys.executable)`
  (sin el `.exe`), así el mensaje siempre dice el intérprete que está
  corriendo de verdad, sea cual sea. 2 pruebas nuevas (total: 87).

**No funcionó:** nada — fue puro seguimiento de la corrida anterior.

**Sigue:** con `prueba-auto` ya creada y el usuario habiendo tomado daño en
el juego, correr `python herramientas\escanear.py filtrar prueba-auto bajo`
(ahora el mensaje de ayuda ya dice el comando correcto solo). El objetivo
sigue siendo el mismo: encontrar la dirección de la vida.

---

## 2026-08-14 (5) — Bug de raíz: OneDrive redirige Documentos, todo lo que asumía `~/Documents` fallaba

**Máquina:** notebook de Fran (Windows, PCSX2 2.6.3) · **Modelo:** Sonnet

**Objetivo:** el usuario apretó F1 (savestate guardado, confirmado en
pantalla: "Saved state to slot 1"), pero `escanear.py nuevo vida --pedir`
decía que no encontraba ningún archivo nuevo.

**Causa real:** en esta notebook, Windows tiene "Documentos" redirigido a
OneDrive. La carpeta real es `C:\Users\frans\OneDrive\Documents\PCSX2\...`,
no `C:\Users\frans\Documents\PCSX2\...`. `estado.py` y `pnach.py` asumían la
segunda (`os.path.expanduser("~") + "Documents"`), que en esta máquina no
existe o no es la que usa PCSX2 — así que la detección automática fallaba en
silencio, sin ningún error claro, para savestates, `.ini` y carpeta de
cheats por igual. Confirmado dos veces por el usuario: una vez por el log de
arranque (entrada anterior) y una segunda vez con una captura de
`Configuración > Carpetas` de PCSX2, mostrando las seis carpetas reales bajo
`OneDrive\Documents\PCSX2\`.

**Resultado:**

- `estado.py`: nueva `_documentos_windows()`, que le pregunta a Windows
  directamente (`SHGetFolderPathW` + `CSIDL_PERSONAL`) en vez de adivinar.
  Esta API sigue la redirección de OneDrive igual que la moderna
  (documentado por Microsoft, por compatibilidad hacia atrás).
  `_candidatos_documentos_windows()` la usa como primera opción y cae a
  `~/Documents` y `~/OneDrive/Documents` como respaldo si la API falla.
- `carpeta_savestates()` (estado.py) y `_ruta_ini_pcsx2()` /
  `carpeta_cheats()` (pnach.py) ahora usan esta lista en vez de una sola
  ruta fija. Un solo punto de arreglo, tres lugares que lo necesitaban.
- 4 pruebas nuevas (total: 85). Importante ser honesto sobre el límite de lo
  que se puede probar acá: `_documentos_windows()` en sí (la llamada a
  `ctypes`/`SHGetFolderPathW`) es imposible de ejecutar fuera de Windows —
  esta sesión corre en Linux. Lo que sí se prueba, en cualquier sistema, es
  que la función no truena fuera de Windows (devuelve `None` de entrada) y
  que la lista de candidatos de respaldo es correcta. La llamada real a la
  API de Windows queda sin verificar por ejecución; sólo por lectura
  cuidadosa contra la documentación de Microsoft.
- Confirmado el nombre real de los savestates:
  `SLUS-21376 (5C891FF1).<slot>.p2s` (más `.p2s.backup`). No hacía falta
  ningún cambio para esto: `ultimo_savestate()` ya buscaba con un patrón
  `*.p2s` genérico, que no distingue el nombre exacto.

**No funcionó / pendiente de verificar:**

- No hay forma de confirmar desde acá que `_documentos_windows()` funciona
  de verdad en Windows real — sólo que el resto del sistema no se rompe si
  falla. **Esto es lo primero a validar en la próxima corrida en la
  notebook**: si `escanear.py nuevo vida --pedir` encuentra el savestate
  solo (sin `--desde` a mano), la API funcionó. Si sigue fallando, hay que
  revisar `_documentos_windows()` con más cuidado — ahí sí, con acceso real
  a Windows para poder iterar.

**Sigue:** confirmar `--pedir` sin `--desde` manual en la próxima corrida.
Si funciona, seguir con el checkpoint 1 (la vida del jugador) que ya había
quedado desbloqueado a mano con `--desde` apuntando al `.p2s` real.

---

## 2026-08-14 (4) — Checkpoint 0 cerrado: PINE confirmado en vivo

**Máquina:** notebook de Fran (Windows, PCSX2 2.6.3) · **Modelo:** Sonnet

**Objetivo:** cerrar lo que quedó pendiente de la entrada anterior — confirmar
que PINE responde en caliente, no sólo por el log de arranque.

**Resultado:**

- `pine.py info` conectó (`tcp:127.0.0.1:28011`) y devolvió exactamente lo
  esperado: `SLUS-21376`, CRC `5c891ff1`, versión `1.00`, estado `corriendo`.
  El primer intento falló (`WinError 10061`, conexión rechazada): el usuario
  acababa de tildar "Activar PINE" en la GUI de PCSX2, pero el proceso ya
  corriendo no levanta el socket hasta reiniciarse. Con PCSX2 reiniciado,
  conectó a la primera.
- `fijar_objetivo.py` corrió sin fricción y confirmó `NTSC-U` como
  `version_activa` — coincide con lo que ya había quedado anotado por el log
  en la entrada anterior. Dos caminos de evidencia independientes
  (log de arranque y PINE en vivo) dando el mismo resultado.
- `pruebas/prueba_herramientas.py`: **81 de 81** en la máquina real, con
  numpy instalado. Primera vez que la batería corre fuera de la nube.
- En el camino se detectó y se resolvió el problema de que el repo nunca
  había quedado clonado en esta notebook (las instrucciones de clonado
  iniciales se habían salteado). Quedó en
  `C:\Users\frans\Desktop\claude-acceso`, con un atajo `black` agregado al
  perfil de PowerShell del usuario para pararse ahí de un comando.

**No funcionó / fricciones para la próxima:**

- El flujo de "clonar + moverse a la carpeta" en PowerShell tuvo varias
  vueltas por confusión de directorio de trabajo (cada ventana nueva de
  PowerShell arranca en `system32`). Ya resuelto con el atajo `black`, pero
  vale tenerlo presente: en la próxima sesión en esta máquina, arrancar
  directo con `black` en vez de re-explicar rutas.
- Sigue sin confirmarse si `preparar_entorno.ps1` llegó a correr de punta a
  punta alguna vez en esta máquina — el camino real terminó siendo manual
  (activar PINE a mano en la GUI, clonar a mano). No es un problema para
  seguir adelante, pero el script de automatización queda sin validar en la
  práctica.

**Sigue:** checkpoint 1 — el ancla de la vida del jugador, con
`escanear.py`. Ver `docs/02-metodologia.md` escalón 1.

---

## 2026-08-14 (3) — Primera corrida real en la notebook: identidad confirmada, dos bugs encontrados

**Máquina:** notebook de Fran (Windows, PCSX2 2.6.3) · **Modelo:** Sonnet

**Objetivo:** correr `preparar_entorno.ps1` por primera vez en una máquina real.

**Resultado:**

- **Identidad del juego confirmada de verdad**, leyendo el log de arranque de
  PCSX2 (no por PINE todavía, no sé si esa parte del script llegó a correr):
  `Serial: SLUS-21376`, `Version: 1.00`, `CRC: 5C891FF1`. Coincide
  exactamente con lo que tenía anotado como "según la comunidad, sin
  confirmar". `kb/objetivo.json`: `confirmada: true`, `version_activa:
  "NTSC-U"`.
- **Bug real encontrado y arreglado**: el nombre de archivo `.pnach` que
  generaba `pnach.py` usaba un punto como separador
  (`SLUS-21376.5C891FF1.pnach`), pero PCSX2 2.6.3 real usa guión bajo
  (`SLUS-21376_5C891FF1.pnach` — visible en el log: "Found 1 cheats in
  ...\SLUS-21376_5C891FF1.pnach"). Con el separador viejo, el archivo que
  generábamos **nunca lo iba a cargar PCSX2**, sin ningún error visible.
  Corregido.
- **Segundo bug de la misma familia**: `carpeta_cheats()` asumía que la
  carpeta se llama `cheats` por convención. En esta instalación real se
  llama `cheats_ws` (customizado en el `.ini` del usuario, no es el default
  de fábrica). Arreglado de raíz: ahora se lee la ruta real de la sección
  `[Folders]` del `PCSX2.ini` del usuario en vez de asumir el nombre — con
  el default de fábrica (`cheats`) como último recurso si no hay `.ini`
  todavía. 5 pruebas nuevas para esto (total: 81).
- Detalle de infraestructura: `Documents` de este usuario está redirigido a
  OneDrive (`C:\Users\frans\OneDrive\Documents\PCSX2\...`).
  `[Environment]::GetFolderPath('MyDocuments')` en PowerShell y
  `os.path.expanduser("~/Documents")` en Python resuelven esto solos, así
  que no hace falta ningún ajuste — lo anoto para no perder tiempo
  reinvestigándolo si vuelve a aparecer.

**No funcionó / no se pudo confirmar:**

- Lo que pegó el usuario fue **el log interno de PCSX2** (Tools > Show Log),
  no la salida de `preparar_entorno.ps1`. No hay forma de saber desde acá si
  el script: detectó Python, instaló numpy, activó `EnablePINE` en el `.ini`,
  o si `fijar_objetivo.py` llegó a correr. El BIOS falló dos veces al
  arrancar (`Configured BIOS ... does not exist`) y hubo ~70s de
  `Applying settings...` sueltos que sugieren que alguien corrigió la
  carpeta del BIOS a mano desde la GUI — compatible con que el script sí
  lanzó PCSX2 con la ISO, pegó contra el error de BIOS, y ahí se paró.
- El juego SÍ terminó cargando y corriendo (hay Pausing/Resuming en el log
  hasta el segundo 211), así que en el momento en que se pegó este log la
  ventana estaba disponible para probar PINE en vivo — pero no se probó
  todavía en esta conversación.

**Sigue:** con el juego corriendo, confirmar PINE en caliente:
```powershell
cd black
python herramientas\pine.py info
```
Si devuelve datos, correr `python herramientas\fijar_objetivo.py` (aunque
`kb/objetivo.json` ya quedó confirmado por otra vía, esto valida que el canal
PINE en sí funciona, que es lo que hace falta para todo lo que sigue). Si
`pine.py info` no conecta, revisar a mano en PCSX2: `Settings > Advanced >
PINE Settings` → Enable PINE, slot 28011.

---

## 2026-08-14 (2) — Automatización del checkpoint 0 en Windows

**Máquina:** nube (sin PCSX2) · **Modelo:** Sonnet

**Objetivo:** que el checkpoint 0 (entorno + confirmar identidad del juego)
se pueda correr con un solo comando en Windows, con UAC, sin que el usuario
tenga que tocar el `.ini` de PCSX2 a mano.

**Resultado:**

- `herramientas/fijar_objetivo.py`: conecta por PINE, compara el serial/CRC
  observado contra `kb/objetivo.json` y lo actualiza solo (marca
  `confirmada`, fija `version_activa`, o crea la entrada si el serial es
  nuevo). La lógica de decisión (`aplicar_info`) es una función pura, sin
  tocar disco ni red — 13 comprobaciones nuevas en
  `pruebas/prueba_herramientas.py` (total: 77), incluyendo el caso de CRC
  que no coincide con el anotado.
- `herramientas/windows/preparar_entorno.ps1`: se re-lanza pidiendo UAC,
  detecta Python 3.11+ e instala numpy, corre la batería de pruebas, busca
  PCSX2 (por atajo del escritorio/inicio o por carpetas típicas), le activa
  PINE y le apaga la compresión de savestates en el `.ini` —con backup
  automático antes de tocarlo—, abre PCSX2 si hace falta, espera a que PINE
  conteste y corre `fijar_objetivo.py` al final. Todo queda en un log bajo
  `volcados/`.

**Verificación hecha (sin tener Windows a mano):**

- Claves reales del `.ini` de PCSX2 confirmadas contra el código fuente
  (`Pcsx2Config.cpp`) y un `.ini` real de ejemplo: sección `[EmuCore]`,
  `EnablePINE`, `PINESlot` (default 28011), `SavestateZstdCompression`,
  formato `Clave = Valor` con espacios.
- Confirmado contra `PINE.cpp` que `MsgID` devuelve el serial y `MsgUUID`
  devuelve el CRC en minúsculas — importante porque `fijar_objetivo.py`
  depende de esa asignación para no cruzar los campos.
- Sintaxis del `.ps1` validada con el parser real de PowerShell (instalé
  `pwsh` portátil para esto, 0 errores).
- La función `Set-ValorIni` (la que edita el `.ini` línea por línea) se
  probó de verdad —no sólo se leyó— con 21 casos: reemplazo, inserción,
  sección nueva, límites del array (sección al final, clave al final,
  archivo de una sola línea), y que `PINESlot` no se confunda con
  `EnablePINE` por ser substring. Encontré y arreglé ahí un bug real de
  `$Matches` que podía arrastrar el resultado de una iteración anterior del
  loop de detección de Python, y dos bloques de escritura de archivo sin
  `try/catch` que hubieran tirado el script entero sin aviso limpio ante un
  permiso denegado o un archivo bloqueado.
- Lo que **no** se pudo probar, porque no hay Windows ni PCSX2 en esta
  sesión: el flujo completo de punta a punta, la búsqueda real de PCSX2 por
  atajos/carpetas, y si el script realmente dispara el diálogo de UAC como
  se espera.

**No funcionó / limitación conocida:**

- No hay forma de ejecutar `preparar_entorno.ps1` de punta a punta desde acá.
  Toda la confianza viene de verificar cada pieza por separado (fuente de
  PCSX2, parser de sintaxis, ejecución real de la función de edición del
  ini) — no de una corrida completa. Si algo falla al usarlo, es información
  valiosa para la próxima entrada de esta bitácora.

**Sigue:** correr `preparar_entorno.ps1` en la notebook y reportar qué pasó.
Si algo se traba, mejor pegar el contenido de
`volcados/diagnostico-entorno-*.txt` que una descripción de memoria.

---

## 2026-08-14 — Armado del proyecto

**Máquina:** nube (sin acceso a PCSX2) · **Modelo:** Opus

**Objetivo:** montar la arquitectura del proyecto: herramientas, base de
conocimiento, documentación y plan, para que el trabajo sea portable entre la
PC y la notebook.

**Resultado:**

- Instrumental completo en `herramientas/`, con pruebas: `pine.py` (cliente
  PINE), `estado.py` (savestates), `escanear.py` (escaneo diferencial),
  `inspeccionar.py` (estructuras), `vigilar.py` (series temporales),
  `mips.py` (ensamblador R5900), `pnach.py` (compilador de mods).
- Base de conocimiento en `kb/`, con campos de confianza y evidencia
  obligatorios.
- Documentación: entorno, metodología (la "escalera" de 5 escalones), plan por
  fases, glosario del EE.
- `pruebas/prueba_herramientas.py`: 65 comprobaciones, todas en verde, sin
  necesitar PCSX2. Se probaron los dos caminos, con numpy y sin numpy.
- Verificado end-to-end contra RAM sintética de 32 MB con ruido realista
  (200.000 palabras cambiando entre fotos): el escaneo por "bajó" va de
  8.126.464 posiciones a 98.256 y después a 1, en 2,2 segundos.

**Datos técnicos confirmados contra las fuentes** (no de memoria):

- Protocolo PINE, contra `pcsx2/PINE.cpp`: marco de 4 bytes little-endian que
  se incluye a sí mismo; comandos encadenables; **un solo** código de resultado
  por respuesta; lectura = 1 byte de opcode + 4 de dirección.
- Formato `.pnach`, contra `pcsx2/Patch.cpp`: `patch=<cuándo>,<cpu>,<dir>,<tipo>,<valor>`,
  con `cuándo` 0-3 y tipos `byte`/`short`/`word`/`double`/`extended`/`bytes`.
- Savestate = ZIP con `eeMemory.bin` adentro; el offset del archivo es la
  dirección EE.
- CRC de BLACK NTSC-U (`SLUS-21376`) = `5C891FF1`, **según la comunidad, sin
  confirmar contra la copia de Fran**. Está anotado con `confirmada: false`.

**No funcionó / no se pudo hacer:**

- Nada verificado contra el juego real: esta sesión corre en un contenedor en
  la nube, sin acceso al PCSX2 de la notebook. Todo lo que dice `kb/` sobre
  BLACK es hipótesis hasta que se confirme en la máquina.
- No se recuperaron las 4-5 direcciones de vida ni la rutina de daño de la
  sesión anterior en la PC de Fran: no están en este repositorio. Quedaron
  anotadas como "pendiente de importar" en `kb/mapa-memoria.json` y
  `kb/rutinas.json`.

**Sigue:** Fase 0 del plan, en la notebook con PCSX2 abierto:

1. `python3 pruebas/prueba_herramientas.py`
2. `python3 herramientas/pine.py info` con el juego corriendo
3. Volcar serial y CRC reales a `kb/objetivo.json` y poner `version_activa`
