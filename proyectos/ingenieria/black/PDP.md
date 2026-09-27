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
| **Pre-A** | **Estudio de conceptos del programa** | ver abajo | `programa.py verificar` + la MCR | **abierta** |

**Fase en curso:** Pre-Fase A del programa — estudio de conceptos. Producir el
espectro amplio de lo que se puede hacer con BLACK, con el mapa de nivel 1 del
juego debajo, **antes** de elegir en qué bajar al detalle. Documento:
[`docs/12-estudio-de-conceptos.md`](docs/12-estudio-de-conceptos.md).

**Qué la cierra, exactamente:** la **MCR** con sus criterios de éxito
(`docs/11-programa.md` §6): NGOs validadas por Fran con sus palabras; los
pesos C1–C6 puestos por él en `kb/conceptos.json#pesos` con fuente y fecha;
el trade study corrido con sensibilidad; una cartera de **a lo sumo dos
proyectos activos**, cada uno con su plan de desarrollo de tecnología; y la
decisión del KDP-A escrita en §6.

**Cómo se certifica:** `python herramientas/programa.py verificar` sale 0
(ninguna traza cortada: cada concepto a una NGO, a funciones y a subsistemas
que existen en el mapa; cada K0–K1 con su sonda; cada función con dueño; el
catálogo generado igual a `kb/`), **y** `programa.py trade` sale 0 — hoy sale
**2** porque faltan los pesos de Fran, que es lo que tiene que pasar. **En
rojo se ve así:** `pruebas/probar-programa.py` rompe cuatro trazas, edita el
catálogo a mano, corre el trade sin pesos y comprueba que un habilitador en K0
cuente como freno: siete casos, los siete en rojo donde tenían que estarlo
(2026-09-26). El del K0 se vio además en rojo contra el error real que lo
motivó (`k or 9` trataba al K0 como falso y escondía al coop).

**La fase también puede CANCELARSE:** si en la MCR Fran decide que el
programa es **sólo coop**, el catálogo queda archivado como referencia y la
cartera es un solo proyecto. Lo aprendido no se pierde: el mapa de nivel 1
sirve igual.

**Lo que viene después, sin detalle a propósito:** el análisis del coop
(pedido por Fran para después de este estudio), las preguntas finas del coop,
el consenso, y el proyecto coop entrando a su **Fase A** con la cámara (K0)
como primer desarrollo de tecnología.

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
