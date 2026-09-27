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
- **No se afina una estructura conocida mientras un requisito no tenga la suya
  identificada** (desde el 2026-09-26). Es la regla que la fase 8 hace
  medible: `kb/superficies.json`.
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

El detalle de cada hallazgo está en `ESTADO_ACTUAL.md`. Acá el esqueleto y las
puertas. N1 (capacidades A leer RAM, B leer código, D escribir) está
**cerrada**; C (leer el ISO) sigue abierta y la fase 8 la empuja.

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
| **8** | **Censo estructural: la estructura de cada requisito** | ver abajo | `superficies.py verificar` | **abierta** |

**Fase en curso:** 8 — censo estructural. Cada requisito abierto con la
estructura que lo gobierna identificada, **antes** de volver a afinar detalle.

**Qué la cierra, exactamente:** cada requisito R2–R7 de `docs/00-conops.md`
tiene en `kb/superficies.json` una fila con **la estructura que lo gobierna,
su grado (`hipotesis`/`probable`/`confirmado`) y la evidencia** —o, si sigue
`desconocida`, la **sonda en frío que la resolvería, ya corrida, con su
resultado**—; y las **seis secciones de `GLOBDATA.BIN`** tienen consumidor
(dirección de código) y qué-es a `probable` como mínimo. Adentro, tres
preguntas que deciden todo lo que sigue:

- **8a — ¿quién piensa por el enemigo?** Desde la vtable del enemigo
  (`0x003DCA78`), el método de update: ¿alcanza código `Kaim::` (Kynapse) o
  sólo código de Criterion? Decide dónde se busca R3.
- **8b — las seis secciones de `GLOBDATA.BIN`.** Hoy se entiende **una** (la
  de armas, 8.960 B de 1.261.896: el 0,7 %). La de `0x80` es el 81 % del
  archivo y no tiene nombre.
- **8c — ¿el motor admite dos jugadores?** ¿La clase jugador (`0x003DC5F8`) se
  instancia desde un array o un contador, y se lee un segundo pad? Veredicto
  con evidencia para R5.

**Cómo se certifica:** `python herramientas/superficies.py verificar`, que
sale **1** si una fila de requisito no tiene estructura, grado o evidencia, si
una fila `desconocida` no nombra su sonda y su resultado, o si una sección de
`GLOBDATA.BIN` no tiene consumidor. **En rojo se ve así:** borrarle la
evidencia a una fila, o agregar una sección sin consumidor, y el verificador
tiene que salir 1 — lo exige `pruebas/probar-superficies.py`, que se escribe
con el verificador y no después. La herramienta es parte de la fase.

**La fase también puede CANCELARSE.** Si 8a muestra que la IA no tiene
parámetros de percepción separables (todo horneado en código), R3 deja de ser
«tocar datos» y pasa a ser «código por `.pnach`»: la fase cierra igual, con esa
fila en `desconocida` + la sonda corrida, y la fase siguiente de R3 se
reescribe como fase de código.

**Lo que viene después, sin detalle a propósito:** la fase 9 es el primer
experimento de validación sobre el requisito que la 8 deje mejor parado; con
lo que se sabe hoy es **R4** (sustituir y sumar enemigos, E5 de
`docs/08-experimentos.md`), y trae adentro la verificación por efecto que 7e(b)
pedía.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| **Se afina detalle mientras falta una estructura grande** | alta — pasó: 7e(b), mira y geometría avanzaron con R3/R5 sin estructura | alta: sesiones que no mueven ningún requisito | evitar: fase 8 y `kb/superficies.json` | una sesión que abre un experimento sobre un requisito cuya fila está `desconocida` |
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
