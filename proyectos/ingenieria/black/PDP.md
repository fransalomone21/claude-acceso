# PDP — BLACK (PS2): ingeniería reversa sobre PCSX2

> Escrito el **2026-08-28**, con el proyecto en la fase 7e, como reconstrucción
> medida contra `ESTADO_ACTUAL.md` y `sesiones/HANDOFF.md` (incumplió la regla
> de escribirse antes, y quedó anotado). **Migrado al molde nuevo el
> 2026-09-26** (rigor por aspecto, «Cómo se certifica», estado `cancelada`,
> matriz de cumplimiento), en la misma sesión que **revisó el plan contra los
> requisitos** y abrió la fase 8.
>
> El **mapa de fases de `ESTADO_ACTUAL.md` sigue siendo la fuente de la verdad
> operativa**. Este PDP guarda el problema, el alcance negativo, el rigor, los
> riesgos, las decisiones y **el criterio de salida de la fase abierta con su
> medidor**.

## 1. El problema

Modificar BLACK con criterio —saber *por qué* un cambio hace lo que hace, no
encontrarlo por prueba y error— y que el cambio **sobreviva a cerrar el
emulador**. El destino lo dijo Fran el 2026-08-17: *reinventarlo más
desafiante, con cambios drásticos como coop, y algún día un nivel nuevo*. Los
requisitos R1–R7 están en `docs/00-conops.md`.

**Para quién es:** Fran, solo. No hay usuario externo, ni entrega, ni fecha.
Lo que se paga caro no es publicar un error: es **creer una hipótesis que no se
midió** y construir tres sesiones encima.

**Cómo sabremos que sirvió (validación):** ya sirvió una vez (R1, el
`Black-mod-armas.iso`, 2026-08-17). La pregunta de validación que queda abierta
**cambió el 2026-09-26**: ya no es si el índice de módulos abarata «tocar otra
cosa», sino **si cada requisito tiene identificada la estructura que lo
gobierna**. La revisión de ese día midió que no: de cinco requisitos abiertos,
uno tiene su estructura conocida (R4), uno la tiene a medias (R6) y **tres no
la tienen (R3 la IA, R5 el coop, y el catálogo de tunables de R2)** — y
mientras tanto el proyecto afinaba detalle en las estructuras que sí conocía.

## 2. Qué NO es

- **No es un mod publicable.** Sin distribución ni compatibilidad con otras
  versiones.
- **No se toca el ISO original.** Tres capas lo miden (ReadOnly, hook
  `PreToolUse`, integridad en `abrir-sesion.ps1`). Todo mod produce un ISO
  **nuevo**.
- **No se trabaja con el emulador abierto por defecto.** El default es en frío.
  El emulador se abre para confirmar por efecto, con la predicción escrita
  antes.
- **No se persigue una pregunta cerrada con un negativo** (7b). Reabrirla es
  una decisión nueva.
- **No se baja de nivel de resolución sin el nivel de arriba hecho** (desde el
  2026-09-26): refinamiento sucesivo, `docs/11-programa.md` §3. El mapa de
  nivel 1 vive en `kb/subsistemas.json`, se imprime al abrir sesión y lo mide
  `programa.py verificar`.
- **No se cambia el ELF del ISO.** Código nuevo va por `.pnach` (el CRC del ELF
  indexa savestates y parches; ver conops).
- **Las rutas no se copian a mano.** Viven en `kb/ubicaciones.json`.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` análisis en frío (ELF, ISO, volcados) | se rehace barato | desconocidos | iterar corto y medir | un sondeo mal parametrizado se corre de nuevo; lo caro es creerle, y eso lo cubre `e` |
| `b` experimento en RAM (emulador, savestate) | se rehace barato | desconocidos | iterar, **predicción escrita antes** | se deshace recargando, pero una sesión de emulador sin predicción no produce evidencia |
| `c` parche de un ISO **copia** | se rehace barato | conocidos | directo, con diff contra el original | `parche_iso.py` confirmado tres veces; el ISO se regenera del original |
| `d` el **ISO original** | un solo tiro | conocidos | rigor pleno: **evitar** | es lo único irrecuperable del proyecto |
| `e` afirmaciones al `kb/` | barata de corregir, **cara una vez que se construye encima** | desconocidos | rigor pleno en el **grado** | `hipótesis/probable/confirmado` en cada entrada; el proyecto ya pagó dos veces un observable que no existía |
| `f` código nuevo (el ELF) | un solo tiro en la práctica: cambia el CRC | desconocidos | **evitar**; código por `.pnach` | invalida de golpe savestates y parches |

## 4. Las fases

> **Desde el 2026-09-26 BLACK es un PROGRAMA** (NASA §3): una Pre-Fase A del
> programa, un ciclo A–F por cada proyecto (un mod) y el reversing como
> desarrollo de tecnología que un proyecto pide. Cómo se trabaja:
> [`docs/11-programa.md`](docs/11-programa.md). Las filas 0–8 de abajo son la
> historia: casi todo desarrollo de tecnología hecho de abajo hacia arriba,
> sin que un proyecto lo pidiera — y por eso el mapa de nivel 1 llegó último.

El detalle de cada hallazgo está en `ESTADO_ACTUAL.md`. Acá el esqueleto y las
puertas. N1 (capacidades A leer RAM, B leer código, D escribir) está
**cerrada**; C (leer el ISO) sigue abierta.

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | Entorno | el emulador corre el juego y las herramientas lo leen | `abrir-sesion.ps1` en verde | cerrada |
| 1 | Ancla: vida del jugador | dirección escrita y efecto visto | escritura con efecto en pantalla | cerrada |
| 2 | Rutina de daño del jugador | nop → vida infinita | por efecto | cerrada |
| 3 | Enemigos | clase y pool confirmados | por efecto | cerrada |
| 4 | Tabla de armas (daño AL jugador) | `Power` gobierna el daño recibido | por efecto | cerrada |
| 4b | Daño de SALIDA del jugador | `zona * 100.0` gobierna el daño hecho | por efecto | cerrada |
| 5a | Mod de daño | el x2 medido por RAM con predicción | `volcados/`, bitácora (54) | cerrada 2026-09-04 |
| 5b | Qué elige la zona de impacto | — | — | abierta, sin trabajo; **es Opus** |
| 6 | Exprimir el ISO | 6.1 y 6.6 cerradas; el resto sigue con la capacidad C | — | abierta (la absorbe la 8b) |
| 7a–7d | Arma, tipo, spawn, descriptor | ver `ESTADO_ACTUAL.md` | por efecto o en frío con control | cerradas |
| 7e | Índice de módulos del nivel | (a) 61 casos a esquema en `kb/`; (b) un tipo ≠ `0x0A` por efecto | (a) `casos_dispatcher.py autotest` + `pools_p1.py`, 17/18 exactas | (a) **cerrada**; (b) **cancelada** 2026-09-26 (ver §6) |
| J1 · L1 · L2 | Jugabilidad, niveles en frío, geometría | ver `ESTADO_ACTUAL.md` | autotests con saboteador en rojo | cerradas 2026-09-05 |
| R2 · T4 | Remaster: pipeline DLSS5, costo del pack HD | ver `ESTADO_ACTUAL.md` | — | abiertas, en pausa |
| 8 | Censo estructural por requisito | cada R2–R7 con su estructura | `superficies.py` (nunca se escribió) | **absorbida** en la Pre-Fase A el 2026-09-26; la **8c** (coop) quedó respondida (`kb/superficies.json#R5`) |
| Pre-A | Estudio de conceptos del programa | la MCR (ver abajo) | `programa.py verificar` 0 rojos + `trade` 0 + `probar-programa.py` 9/9 | **cerrada 2026-09-27** (KDP-A en §6) |
| **COOP-A** | **Proyecto coop, Fase A: concepto y desarrollo de tecnología** | ver «Proyecto COOP» abajo | los habilitadores en K5, cada uno por efecto | **abierta 2026-09-27** |

**Fase en curso: COOP-A** — el único proyecto activo del programa (KDP-A,
2026-09-27). Análisis en papel: [`docs/13-coop.md`](docs/13-coop.md).

### Proyecto COOP

**Qué es.** Dos personas juegan la campaña de BLACK juntas (N1, MOE1). La meta
es la **pantalla dividida (M2)**: el juego es en primera persona, así que en
una pantalla compartida (M1) el segundo jugador no tendría una vista propia
(razonamiento, grado `probable`; `docs/13-coop.md` §2). **«Cada uno en su
computadora»** se resuelve **encima** de M2, con Parsec o Remote Play (M6):
cero reversing, pero no existe sin un coop local debajo.

**Qué la cierra, exactamente:** (la Fase A; criterio de salida escrito antes
de empezarla) cada habilitador crítico en **K5** —efecto visto en RAM, con control— y un
**prototipo por PINE** en el que el segundo mando mueve a un segundo jugador
que está en el nivel. **Cómo se certifica:** una entrada de bitácora por cada
K5, con la predicción escrita antes y el efecto medido; `kb/subsistemas.json`
actualizado; `programa.py verificar` 0.

**Plan de desarrollo de tecnología** (NASA p. 194: lo que exige pasar de A a
B). Todo lo de la columna «sonda» necesita la notebook: ELF, volcados, Ghidra
o PCSX2.

| # | Subsistema | K hoy → objetivo | Sonda que lo sube | Dónde |
|---|---|---|---|---|
| 1 | `entrada` | K4 → **K5, HECHA 2026-09-27 (bitácora (76))** | ~~escribir `jugador+0x418 = 1`~~ (en caliente no hace nada: sólo lo lee la init). **Lo que funciona:** las tres copias del control en el jugador (`J+0x588`, `J+0x6D0`, `J+0x7C8`) en `0x00585A0C` → el mando 2 lo maneja (yaw y pitch siguen su deriva; control: `0x005858A0`). La tabla de mandos de la sesión está compilada para 1 | hecha |
| 2 | `camara` | K0 → K3 | ~~en frío: desde el yaw hacia la matriz de vista~~ **HECHA en frío el 2026-09-27 en la nube (bitácora (68))**: gestor `0x0040F4BC` (vistas en +0x700/+0x750, matriz en +0x7A0), proyección y viewport en `FUN_00269ea0(&0x0043F710, viewport, cámara)`, **los dos como parámetros**. El negativo de (65) era de unidades (el yaw está en grados) | hecha |
| 3 | `camara` | K3 → **K5, HECHA 2026-09-27 (bitácora (76))** | (a) **la fuente es `mira+8` = `0x005A8FA8`** (integrador `FUN_001404a8`; `+0` es copia): escribirla gira la vista, en RAM y en pantalla, con control; (b) `0x0043F790` se escribe **4 veces por cuadro** desde `FUN_00269ea0`; (c) `cam+0x7E1` = 1: negativa | hecha |
| 3½ | `render` | K3 → **K4** (76) | la vista 160 × 112 se lee 10 veces por cuadro desde 9 sitios del render (medido en vivo) | hecha |
| 4 | `render` | K1 → K3 | **HECHA en frío el 2026-09-27 en la nube (bitácora (69))**: el cuadro ya hace dos pasadas de escena con **viewport y framebuffer propios** (160 × 112, `SCISSOR`/`FRAME`/`ZBUF` en `*(0x0040F4C0)+0xD170`, medido en 3 volcados). La salida por abajo no se da | hecha |
| 5 | `juego` + `sesion` | K4 → K5 | ~~en frío: quién itera `jugadores[]` y con qué límite~~ **HECHA en frío el 2026-09-27 en la nube (bitácora (64))**: se construye con N = 1 compilado y se recorre con una **cuenta en tiempo de ejecución**, `*(0x0040F0E0)+0x20208`; `FUN_00106010` la pone en **2**. **E7 (bitácora (71))**: `FUN_00106010` es el «entrar» de un modo **vacío** (sin update ni render) que ningún código activa directo: no hay un 2 jugadores escondido y jugable; el coop se construye. ~~Falta, por PINE: (a) un *watch* de escritura sobre `0x004BC208` recorriendo los menús~~ **(a) HECHA 2026-09-27 (78)**: ningún literal pide el modo `+0x20F90`; por el front-end y por el **selector de depuración** (`0x0040D986` = 0) la cuenta la escribe `FUN_00105318` con 1. (b) segundo bloque de 0x8C0 fuera del array: **en curso** — un clon sin constructor se actualiza pero congela a J (P4); el constructor del juego en caliente cuelga el hilo (P6, P6b); sigue construirlo **durante una carga** | en frío: hecha · (a) hecha · (b) notebook |
| 6 | `codigo-nuevo` | K2 → **K5, HECHA 2026-09-27 (bitácora (78))** | P2: memoria libre estable (fin de `.bss`) y un gancho con `jal`, probado con un contador que sube por cuadro. **Hecho:** `jal FUN_0013bac8` de `0x00129574` → stub en `0x0046D700`, contador 59/s con control (`gancho.py`) | hecha |
| 7 | `spawn` | K3 → K5 | P6: si existe una llamada de aparición fuera de la carga del stage | notebook |
| — | `hud` | K2 | no entra en la Fase A: el jugador 2 puede jugar sin HUD propio en el prototipo | — |

**Hallazgos en frío que cambian el diseño del coop (2026-09-27, bitácoras (73)–(75), probables):**
los triggers del nivel (`disparadores`) prueban **sólo la posición del jugador 0**,
y `0x0040F530` recorre un array con cuenta **compilada en 1**, como
`jugadores[]`. El prototipo no los necesita (el jugador 1 abre el camino), pero
M2 completa sí; entran como sondas en `sesiones/HANDOFF.md`.

**Orden:** la **1** va primero, porque es la más barata (una escritura) y sola
contesta si el motor admite que otro mando maneje a un jugador. La **2** es la
que más destraba (en el trade study, P5 queda en el top 5 en 931 de 1000
corridas). Las 1, 3 y 5 se juntan en **una sola sesión de emulador**, en lote
(`docs/11-programa.md` §8).

**Salida por abajo (también es resultado):** si la 4 muestra que el motor no
puede dibujar dos vistas en el mismo cuadro sin reescribir el render, M2 pasa
a L/XL con riesgo alto y se vuelve a Fran con dos caminos: la pantalla
alternada, o el jugador 2 como compañero de escuadra (M3), que depende de la IA.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| **Se afina detalle mientras falta una estructura grande** | alta — pasó **dos veces**: 7e (se arregló con una regla de búsqueda) y todo el proyecto (el mapa de nivel 1 llegó en la entrada 62) | alta: sesiones que no mueven ningún requisito | evitar: refinamiento sucesivo (`docs/11-programa.md` §3), el mapa impreso al abrir sesión, y el reversing pedido por un proyecto | una entrada de bitácora que no declara concepto ni nodo del mapa, o `programa.py resumen` con un nodo que baja a R3 mientras hay K0 en su mismo nivel |
| **La sesión rankea con pesos que no son de Fran** | media | alta: se construye la cosa equivocada con precisión | evitar: `programa.py trade` sale 2 sin pesos con fuente | un ranking en un documento que no cita `kb/conceptos.json#pesos` |
| **El observable elegido no existe** | alta — pasó **dos veces** (`printf` stub; array del `0x2D` vacío) | alta | mitigar: characterization test en frío del observable antes de usarlo, predicción escrita antes | cualquier plan que diga «vamos a ver que pase X» sin haber medido que X se pueda ver |
| Se daña el **ISO original** | baja | **irrecuperable** | evitar, con tres capas | `abrir-sesion.ps1` en rojo, o el guardia bloquea algo |
| **Ghidra pierde un argumento** | media — pasó en `0x001759A4` (delay slot) | alta | mitigar: contrastar contra las instrucciones | una conclusión que depende de qué argumento recibe una función |
| Un resultado se reporta **un escalón más arriba** | media | alta | mitigar: grado en cada línea | una afirmación sin grado |
| El estado de la máquina **se lee en vez de medirse** | media — pasó (PCSX2-MCP; y el 2026-09-26 `D:` ya no montaba el ISO que `ubicaciones.json` declara) | media | mitigar: `inventario.py`, `ubicaciones.py`, leer por LBA | un «está en `D:`» que no venga de medirlo |
| Se pierde lo que sólo vive en el emulador | alta | baja si está anotado | aceptar y anotar en el handoff | reiniciar el emulador |
| **`Test-Path` con corchetes** da falso negativo | media | media | evitar: verificador en Python | un chequeo de existencia en PowerShell sobre `Black [NTSC]` |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-08-17 | **Parche de ISO in-place** como camino permanente | pnach solamente | el pnach no sobrevive a cerrar el emulador |
| (temprano) | El **default es en frío** | abrir el emulador para explorar | cuesta una sesión y no produce evidencia |
| (temprano) | Las rutas viven en `kb/ubicaciones.json` y se **miden** | copiarlas a mano | ya costó dos turnos |
| 2026-08-22 | **Cerrar 7b con el negativo** | seguir con `+0x8C` y `+0xA8` | experimento completo en sus dos mitades; candidatos anotados |
| 2026-08-23 | Buscar el **índice de módulos** en vez de subir la cadena cada vez | eslabón por eslabón | un parámetro contra una estructura |
| 2026-08-28 | El experimento por efecto de 7e, con **parche in-place de ISO** | probar en RAM primero | el archivo en disco es direccionable |
| 2026-08-28 | Este PDP **no duplica** el mapa de fases | copiarlo acá | un dato en dos lados diverge |
| 2026-09-26 | **7e(b) se cancela**; su verificación por efecto pasa a la fase 9 (R4) | cerrarla antes de seguir | lo que 7e compraba —el índice legible— ya está, y en frío (`stunit.py`). Un tipo cualquiera verificado por efecto no mueve ningún requisito; el experimento de R4 lo produce de paso sobre un tipo que sí importa |
| 2026-09-26 | **Fase 8: censo estructural antes de más detalle** | seguir con 7e(b), 5b o el remaster | medido ese día: R3, R5 y el catálogo de R2 no tienen estructura, y el 81 % de `GLOBDATA.BIN` no tiene nombre. Afinar lo conocido con eso abierto es un parámetro, no una estructura |
| 2026-09-26 | **La 8c (coop) va primero**, antes que la 8a | el orden 8a → 8b → 8c | lo pidió Fran («me encantaría que haya dos jugadores»): la meta la pone él, y la 8c no depende de las otras dos |
| 2026-09-26 | **Coop = pantalla compartida, jugador 2 alojado aparte, código por `.pnach`** (a probar) | ampliar el array en el lugar; pantalla dividida; pad 2 manejando a un compañero de IA | el array no tiene lugar (`juego+0x8F0` está ocupado); la pantalla dividida no tiene estructura conocida; el compañero depende de la 8a, que no está. Ver `kb/superficies.json#R5` |
| 2026-09-26 | **BLACK pasa a PROGRAMA** (NASA §3): Pre-Fase A del programa, un ciclo A–F por proyecto, el reversing como desarrollo de tecnología que un proyecto pide | seguir con fases numeradas por descubrimiento (8a, 8b…) | el mapa de nivel 1 (37 subsistemas, 6 tocados en 61 entradas) salió en una sola lectura de `FUN_001020c0`; NASA p. 67 advierte que lo de abajo le gana a lo de arriba si la arquitectura no se resuelve temprano |
| 2026-09-26 | **La fase 8 se absorbe en la Pre-Fase A**; `superficies.py` no se escribe | escribirlo igual | su trabajo (estructura por requisito) lo hace ahora `programa.py` sobre el mapa y el catálogo, con traza a NGOs; dos verificadores del mismo dato divergen |
| 2026-09-26 | **Ningún trade study sin los pesos de Fran**; la herramienta se niega | que la sesión proponga pesos «razonables» | Fran lo pidió («preguntas antes de trade-offs ambiguos»); NASA p. 46: las expectativas se elicitan, se validan y se comprometen con el interesado |
| 2026-09-26 | La **ValueDB no es el catálogo de dificultad** | usarla como mapa de tunables | censada: 63 registros, 58 con nombre, todos de controles, colisión y audio. Ninguno de IA ni de daño |
| 2026-09-27 | **MCR cerrada, con los pesos DELEGADOS**: Fran contestó las 22 preguntas (`docs/12` §7) y después dijo «decide todo vos, primero el coop, despues vamos viendo». La sesión fijó C1 30 · C2 10 · C3 15 · C4 25 · C5 15 · C6 5 (opción «avanzar de a poco», por su resp. 21), el orden de NGOs de su resp. 22, y E1–E3 a la mitad por su resp. 15 | esperar a que Fran reparta los 100 puntos | lo delegó explícitamente; queda registrado como delegado y no como suyo, en `kb/conceptos.json#pesos.fuente`. Se revisa si Fran lo pide |
| 2026-09-27 | **KDP-A: la cartera es UN solo proyecto, COOP** (meta M2 pantalla dividida; M6 encima para jugar a distancia). El segundo lugar de la cartera queda **vacío** | llenar el segundo lugar con lo mejor rankeado del trade (M6, P5, E2, P4, M7) | Fran: «primero el coop, despues vamos viendo». Además, el top del trade **no es una cartera**: M6 depende de un coop local; P5 es desarrollo de tecnología del coop; E2 y P4 suben por ser fáciles con valor casi nulo (C1 0,08 y 0,02). Se anotó y **no** se retocó la función después de ver el resultado |
| 2026-09-27 | **Las sondas en frío del coop corren en la nube**: el ELF, tres volcados, `WPNSCOPE.BIN` y `GLOBDATA.BIN` en el repo PRIVADO `black-datos` (verificados por SHA-256), `ubicaciones.py` los resuelve con `BLACK_DATOS`, y capstone reemplaza a Ghidra para leer el código | esperar a la notebook para todo | Fran lo pidió («lo que podamos seguir del proyecto en nube, hagamoslo posible»). `claude-acceso` es público: el material del juego nunca entra acá. La fuente de las rutas sigue siendo una sola (`kb/ubicaciones.json`) |
| 2026-09-27 | **La meta del coop pasa de pantalla compartida (M1) a pantalla dividida (M2)**; revisa la decisión del 2026-09-26 | M1, como decía la fila del 26/09 | BLACK es en primera persona: con una sola cámara, el jugador 2 no tiene vista. Fran eligió «pantalla dividida o cada uno en una computadora» (resp. 5). M1 queda como paso intermedio del prototipo (dos jugadores en el mundo antes de dos vistas), no como entrega |
| 2026-09-27 | **La cámara de cine desactivada de fábrica (`0x0040D9A3`) queda como mejora de experiencia de PRIORIDAD MÍNIMA, para el futuro** (Fran, tras ver la captura de (77)) | A) sólo el byte (sale cerca de paredes, en muertes a más de 6 m); B) forzarla siempre (segundo parche); C) descartarla | ninguna perdió: se posterga. No compite con el coop por sesiones; si vuelve, hay que resolver que en pantalla dividida le tapa la vista ~2 s al que mata |

## 7. Verificación

**Cómo se verifica cada entregable.** Lo primero de cualquier sesión:

```powershell
.\proyectos\ingenieria\black\abrir-sesion.ps1
```

Un hallazgo se da por **confirmado** sólo si: (1) está medido **por efecto**
sobre el objeto real, no leído del descompilado; (2) tiene **control
positivo**; y (3) tiene **piso de ruido** cuando es una comparación.

**Qué se registra de cada verificación:** qué se midió y sobre qué versión
—ISO, volcado, savestate—, en qué difiere del entorno real, el resultado por
requisito, y **las deficiencias y límites detectados**. La bitácora
(`docs/03-bitacora.md`) la lleva; si se contradice con `ESTADO_ACTUAL.md`,
**manda la bitácora**.

**El verificador, ¿alguna vez falló?** Sí: `probar-hooks.ps1` rompe cada freno
y exige el rojo; el guardia del ISO bloqueó mal su primer comando legítimo
(`\bdel\b` contra un «DEL» en español) y se corrigió el patrón; y falla
cerrado si su config no parsea (commit `3ea0054`). Las herramientas de 7e, L1
y L2 tienen cada una su saboteador en rojo.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `CLAUDE.md §Las reglas #1` (evidencia graduada) | `e` | `cumple` | |
| `CLAUDE.md §Las reglas #2` (el éxito se audita) | `b` | `cumple` | |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `a` | `cumple` | cada herramienta nueva nace con su saboteador |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `b` | `recortado` | **Resta:** los experimentos en RAM no llevan saboteador del instrumento en cada corrida, sólo **control positivo** (un valor ya conocido que la medición reproduce). Romper el instrumento cada vez cuesta una sesión de emulador por experimento; el riesgo que se crea es un instrumento ciego que da el mismo verde, y lo cubre que el control positivo **varía** entre corridas (vida del jugador distinta en cada volcado). Si un control positivo no varía, el recorte deja de valer |
| `CLAUDE.md §Las reglas #4` (el repo es la memoria) | todos | `cumple` | |
| `CLAUDE.md §Las reglas #6` (cambios mínimos) | `c` | `cumple` | el parche toca sólo los bytes buscados; el diff lo mide |
| `CLAUDE.md §Las reglas #6` (lo que se instala se desinstala) | `d` | `cumple` | `.claude\desinstalar-hooks.ps1` |
| `plantillas/naturalezas/ingenieria.md` §Las cinco cosas #2 (todo dato lleva su versión) | `e` | `cumple` | NTSC-U, CRC `5C891FF1`, en `kb/objetivo.json` |
| `plantillas/naturalezas/ingenieria.md` §Riesgo (estado reversible antes de intervenir) | `b` | `cumple` | savestate antes de cada escritura |
| `plantillas/naturalezas/ingenieria.md` §Verificación y validación | todos | `cumple` | `docs/00-conops.md` lleva las dos columnas por requisito |
