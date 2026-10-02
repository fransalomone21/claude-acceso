# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

> **2026-10-02 (tarde) — LO ÚLTIMO. T12, paso 1 de 5: el costo ANTES está
> medido** (`docs/t12-simplificar.md` §6; instrumento `medir-costo.py`, semilla
> de P10). Lo que cambia el orden de la poda: el **enrutador** (`CLAUDE.md`
> raíz, 54,6 K) es el 43 % del costo fijo; la spec de los cuadros se paga en
> cuatro lugares; leer en `perfil-global/` recarga su `CLAUDE.md` (18 K
> duplicados); `al-paso` reinyecta lo que la puerta ya hizo leer. **Sigue el
> paso 2: la matriz de cumplimiento de TODO el método** (pieza, impacto
> original, costo medido, veredicto), después podar con saboteador. **De
> paso:** la puerta perdía lecturas hechas en paralelo (append de Windows no
> atómico entre procesos): candado del SO en `cascada_puerta.py`, caso nuevo
> (1057/1200 sin candado, 1200/1200 con), autotest 23/23; lección registrada y
> foldeada en `chequeo-de-trabajo.md` del perfil, **sin `install.ps1`
> todavía** (se dejó para después de la renovación del plan, que estaba al
> 88 %: un install cortado a la mitad es lo único que deja la máquina sucia).
> Validación de T11: esta sesión es la 1 de 5 (declaró `metodo,diseno`, leyó
> 17 rangos, la puerta frenó una vez de más por el defecto del append).

> **2026-10-02 (01:05) — LO ÚLTIMO, y REORDENA lo de abajo. Fran aceptó las
> críticas y pidió simplificar.** Le dije que el método crece por acumulación
> (cada falla suma una capa y no se saca nada; hoy, para editar un párrafo,
> hubo que releer ~37 K tokens), que los requisitos absolutos empujan a más
> maquinaria y que el método se come la ventana de 5 h. Respondió: «ingeniá
> vos la simplificación, con los libros; yo aporto intuición; sensatez antes
> que orgullo». **Por eso la próxima sesión NO arranca por T11b** (sumaría
> cuatro piezas más): arranca por **T12, simplificar**, y de T11b entra sólo
> lo que sobreviva a esa poda (candidato firme: el `--nivel` de la regla 15,
> que es barato). Plan de T12 en el mensaje de retome de esta fecha.

> **2026-10-02 (00:40–01:00) — LO ÚLTIMO. Fran respondió y abrió T11b.** Dijo:
> las necesidades son abiertas (si una no encaja, clase nueva o requisitos);
> buscar las herramientas y el respaldo de cada tarea; ser ingeniero aunque la
> tarea sea de albañilería; validar con **más de 3** sesiones (quedó en 5); y
> **regla 15**: un error evitable frena la tarea y se arregla uno o n niveles
> más arriba, no con un parche. **Hecho (escrito y en el catálogo):** clase
> `nueva` (requisitos), campo `herramientas` con respaldo en cada clase (lo
> imprime `cascada.ps1`), reglas 14 ampliada y 15 en el perfil, dos memorias.
> **Falta diseñar e implementar (T11b, la próxima sesión):** (1) que la regla
> 15 tenga freno —`aprender.py agregar --nivel parche|herramienta|regla|flujo|meta`
> obligatorio, `parche` solo rechazado sin `--por-que-no-mas-arriba`, con su
> caso en `probar-chequeo-lecciones.ps1`—; (2) `--verificar` exige que cada
> clase tenga herramientas y una de respaldo; (3) la puerta, ante una
> necesidad desconocida, dice «creá la clase o declarala `nueva`», y
> `medir-cascada` cuenta los `nueva` repetidos (señal de clase que falta);
> (4) **medir** cuántas sesiones actúan fuera de todo proyecto (la puerta no
> las ve) antes de decidir si la «albañilería» necesita puerta propia.

> **2026-10-02 (00:00–00:35) — LO ÚLTIMO. T11 CONSTRUIDA: la puerta de la
> cascada.** Pedido de Fran al cerrar BLACK (110), con prioridad máxima.
> Medido antes (censo, `perfil-global/herramientas/medir-cascada.py --desde
> 2026-09-01`): **1 de ~110** entradas sesión × proyecto leía ESTADO + HANDOFF
> + PDP + contrato antes de su 1.ª acción; BLACK abría 7 de 28. Construido:
> `.claude/cascada.json` (catálogo: base, 7 necesidades, 3 conceptos, 20
> proyectos), `.claude/hooks/cascada_puerta.py` (PreToolUse deny + registro +
> CLI `--exige/--verificar/--autotest`), `cascada.ps1 -Necesidad/-Excepcion`,
> instalado por `.claude\instalar-hooks.ps1`, medidor `--verificar` en la capa
> rápida y `--autotest` (22 casos, con mutante) en los saboteadores;
> `probar-cascada` y `probar-hooks` en verde con la puerta instalada. Diseño:
> [`docs/t11-cascada-obligatoria.md`](docs/t11-cascada-obligatoria.md); A12 en
> el diagnóstico. **Validación 1 de 4, esta sesión** (es de transición: empezó
> antes de la puerta, así que `medir-cascada` no la cuenta): frenó, se declaró
> `metodo,diseno`, se leyeron 16 rangos (~37 K tokens) y pasó; encontró **cuatro
> defectos de frontera real** que el autotest no veía, todos arreglados con
> caso. La salida explícita se usó una vez (nota en el retome de BLACK) y quedó
> en `~/.claude/hooks/cascada-excepciones.log`. **De paso, pedidos de Fran:**
> reglas 13 (al chat lo que cambia, en su idioma; lo técnico al repo) y 14
> (pregunta de marco y preguntarle para aprender) en el perfil global, y tres
> memorias de feedback. **Sigue:** las 3 sesiones reales que validan T11 (la
> primera es BLACK, ya anotado en su `sesiones/RETOME-LOCAL.md`); después, T2.

> **2026-09-29 (00:30–00:50) — LO ÚLTIMO. T1 CERRADA: el paso 6 validó en 3
> sesiones reales limpias.** Contadas desde los saboteadores (28/09 21:42:33),
> como fijó la corrección de abajo: `53e404af`, `e5fa731f` (Escritorio) y
> `b3a19cc1` (ésta); `medir-inyeccion --solo despues` sobre esa ventana = 3
> sesiones, 0 cortados, 0 cancelados; `disparos.log` sin ERROR. **El medidor
> tal cual anclaba en 23:44:41 y daba 2:** esa escritura la hizo **la app** al
> enviarse el primer mensaje de la sesión del Escritorio (al segundo, sin
> herramienta corrida; ningún hook cambió después de 21:43; `probable`). Se
> midió con una copia fechada (`--settings <copia con mtime 21:42:33>`).
> Lección 298 (`fuera`) y `perfil-global/PENDIENTES.md` §11 (anclar por
> contenido, no por mtime). **Validación cerrada, así que se corrió
> `install.ps1`:** PENDIENTES §10 cerrado (líneas de 295 y 296 escritas; núcleo
> 201 reglas; `verify-install` verde). **De paso:** `install.ps1` leía
> `settings.json` sin `-Encoding` y le agregaba una capa de mojibake cada vez
> que la app lo dejaba sin BOM (la raya de `autoMode`, desde las 20:50 del
> 28/09): seis lectores arreglados en cuatro scripts, probado en réplica
> (viejo 1 capa / nuevo limpio), 9 rayas reparadas con `autoMode` igual al
> respaldo limpio, `probar-guardia-fanout` 5/5. Lección 297 (foldeada).
> **Sigue T2 «un dueño por dato»**, con el alcance fijado en `ESTADO_ACTUAL.md`
> (entran las rutas locales a mano y `fuera-del-sistema.txt`; el censo fuera
> del Escritorio y el contenedor que oculta a sus hijos van a P10). T2 es
> diseño: Opus, esfuerzo alto, un hilo. Primer paso: la tabla dato → archivo
> dueño, medida sobre el disco (qué datos se repiten y dónde), no de memoria.
> **Fran pidió que la próxima sesión real de prueba sea la guía de IDEs de
> `software-de-vuelo`** (STM32 con VS Code y Wokwi): sirve de dato para P10.
> **Hecha en esta misma sesión, y ya es dato:**
> [`docs/insumo-2026-09-29-sesion-ides.md`](docs/insumo-2026-09-29-sesion-ides.md)
> — Fran corrigió tres veces en vivo cosas que ya pide en otros proyectos
> (método del profe primero, formato de los apuntes, público ≠ personal) y
> ninguna capa se las trajo a la sesión; el detector de «sin declarar» sólo ve
> `apunte.pdf`; y el núcleo pierde la regla cuando la viñeta abre con un
> anuncio. Entra al alcance de T2/T10 junto con el insumo del Escritorio.

> **CORRECCIÓN 23:35 — la cuenta del paso 6 es 1 de 3–5, no 2.** Los
> saboteadores reescriben `~/.claude/settings.json` (21:42:33) y el medidor
> cuenta desde ese cambio: hoy da «1 sesión posterior». No correr
> `-SoloSaboteadores` durante la validación. Próxima sesión: «2 de 3–5».
>
> **2026-09-28 (noche, 6.ª) — Paso 6 de T1: sesión 2 de 3–5 [ANULADA, ver arriba]
> LIMPIA** (`--solo despues`: 2 sesiones, 0 cortados, 0 cancelados;
> `disparos.log` sin ERROR). No se construyó nada. **ACTUALIZACIÓN 23:31: la
> clave real `rclone` YA disparó en uso real (7 viñetas, archivo de estado de la
> sesión creado); el pendiente de abajo quedó cerrado.** (Antes: ninguna clave real de
> `al-paso` disparó todavía** desde el cambio de settings de las 21:17
> (`al-paso-estado/` sólo tiene el archivo de las 21:11; las líneas de las
> 21:35 son muestras del medidor): en la próxima sesión, usar una clave real
> (`rclone`, un Edit, `typst`) y ver que aparezca su archivo de estado.
> `chequeo-completo -SoloSaboteadores`: **14/14 + 9 medidores de limpieza en
> verde** (el rojo del 28/09 no se reprodujo; el de estructura tardó 257 s).
> Próxima: mismo comando, anotar «3 de 3–5»; si es la 3.ª–5.ª y limpia, cerrar
> el paso 6 y elegir T2 (`docs/diagnostico-2026-09-28.md`, sólo su sección).

> **2026-09-28 (noche, 5.ª) — LO ÚLTIMO. Paso 6 de T1: sesión 1 de 3–5
> LIMPIA** con el hook al paso instalado (`--solo despues`: 1 sesión, 0
> cortados, 0 cancelados; `disparos.log` sin ERROR). No se construyó nada. No
> es la 3.ª–5.ª, así que **T2 no se elige todavía**. Ojo al leer el log: las
> líneas `al-paso` de 21:31:59 son las muestras sintéticas que corre el
> medidor, no disparos reales. Próxima sesión: mismo comando, anotar «2 de
> 3–5»; mirar además que `~/.claude/hooks/al-paso-estado/<session_id>.txt`
> exista si se usó alguna clave real.

> **2026-09-28 (noche, 4.ª) — LO ÚLTIMO. T1 paso 5 CONSTRUIDO: el hook al paso.**
> (0) Validado: la primera sesión con pilares y núcleo partidos dio `--solo
> despues` = 0 cortados y 0 cancelados. (5) `perfil-global/hooks/al-paso.py`
> (PreToolUse, Python; lo registra `install.ps1` desde `Get-Guardias` con los
> campos nuevos `Interprete`/`Decide='contexto'`/`Timeout`; se desinstala
> sacando su entrada de `~/.claude/settings.json`): por clave inyecta las
> viñetas **enteras** de `chequeo-de-trabajo.md` una vez por sesión (estado en
> `~/.claude/hooks/al-paso-estado/<session_id>.txt`). Seis claves que
> discriminan: `freno`, `fanout`, `gui`, `rclone`, `typst`, `pcsx2` (ghidra y gh
> quedan fuera: la sonda no midió si discriminan). 8 441 / 3 799 / 1 532 /
> 5 242 / 7 029 / 7 350, tope 9 000 sobre **stdout** (los escapes del JSON
> cuentan). **`freno` no entra entero** (31 viñetas, salen 16, el pie lo dice);
> entregar el resto en la 2.ª llamada sería cambio de diseño y no se hizo.
> Saboteador `perfil-global/probar-al-paso.ps1` **20/20** (en
> `chequeo-completo`); `medir-inyeccion` corre una muestra por clave;
> `verify-install` mide registro y efecto. **Confirmado en sesión real:** el
> `settings.json` se recargó en caliente y el primer `rclone` trajo sus 7
> viñetas; el segundo, nada; un Edit a `medir-inyeccion.py` disparó `freno`.
> **Sigue el paso 6:** instalar movió `settings.json`, así que la cuenta de
> 3–5 sesiones reales arranca de nuevo con la próxima; en cada una
> `python perfil-global\herramientas\medir-inyeccion.py --solo despues` tiene
> que dar 0 cortados y 0 cancelados. Después, T2 del diagnóstico. Aviso: el
> hook usa `python` del PATH bajo el shell del harness (igual que
> `fase_activa.py`); si una máquina no lo tiene, falla abierto y sólo lo dice
> `~/.claude/hooks/disparos.log`.

> **2026-09-28 (noche, 3.ª) — LO ÚLTIMO. T1 pasos 3 y 4 CONSTRUIDOS; la capa
> rápida entera en VERDE** (9 medidores, primera vez desde que existe el de
> inyección). (0) **Paso 2 validado en su primera sesión real**: `--solo
> despues` sin `hook_cancelled` (1 de 3-5). (3) `pilares.md` en **dos hooks**
> (7 940 + 4 791): lo corta el lanzador `perfil-global/hooks/emitir-contexto.ps1`
> (`archivo parte de`, frontera de sección, empaque a 9 000; si pide más partes
> que hooks, la última se lleva el resto y el medidor da rojo). `install.ps1`
> ahora es dueño de toda entrada que invoca el lanzador y **retira** lo que sale
> del manifiesto. (4) **El núcleo**: `perfil-global/herramientas/nucleo-chequeo.py`
> genera `chequeo-nucleo.md` (la primera oración de cada una de las 200
> viñetas, tope 160; 25 914 caracteres) y va en **cuatro hooks**
> (6 831 / 3 732 / 7 790 / 7 764), no dos: el corte es por momento y «antes de
> confiar en una herramienta» sola ocupa 7 800 (nota de construcción en el doc
> §7). La fuente se sigue instalando en `~/.claude/` para leer la viñeta
> entera. `install.ps1` lo regenera; `verify-install` exige que esté al día;
> saboteador de T1 **14/14**. Las frases «se lee solo» (aprender.py,
> install.ps1, los dos CLAUDE.md, README, skill) corregidas. Los PDF de Física
> Espacial, **subidos** (MD5 al día). **Sigue el paso 5 (hook al paso)** y
> juntar sesiones reales para el 6: `medir-inyeccion.py --solo despues` en
> cada una; la próxima es la **primera con pilares y núcleo partidos**, y
> tiene que dar 0 cortados.
>
> **Antes (2026-09-28, noche, 2.ª) — T1 pasos 1 y 2 CONSTRUIDOS.**
> (1) `perfil-global/herramientas/medir-inyeccion.py` en los medidores de
> `chequeo-completo.ps1`, **en rojo sobre el estado de hoy** (pilares 12 863,
> chequeo 133 973, cortes y cancelaciones en los transcripts) y amarillo en la
> apertura (9 592); saboteador `perfil-global/probar-medir-inyeccion.ps1` 10/10
> y saboteado él mismo. `verify-install` ya no imprime el tamaño. (2) Arranque
> partido: `.claude/hooks/arranque-proyecto.ps1` sólo texto (timeout 15) +
> `.claude/hooks/arranque-medicion.ps1` (capa rápida en paralelo,
> `-FechaLimite 40`, matcher `startup|resume|clear`), instalados en
> `.claude/settings.json`; 41 s de pared contra 56 en serie; `probar-hooks`
> 51 OK. **Sigue el paso 3: pilares en dos hooks** (la fuente sigue siendo un
> archivo; corte en frontera de sección, 2 × ~6 400). El medidor va a pasar
> `pilares` a verde y dejar `chequeo` en rojo hasta el paso 4. **La primera
> sesión nueva ya valida el paso 2**: `python perfil-global\herramientas\
> medir-inyeccion.py --solo despues` tiene que dar 0 `hook_cancelled` para
> `arranque-medicion.ps1`. Corrige a S3: `publicar-apuntes -Verificar` es
> bimodal SOLO (10 o 45 s). Rojo ajeno al arrancar: los PDF de Física Espacial
> recompilados a las 19:32 y sin subir (otra sesión).
>
> **Antes (2026-09-28, noche) — T1 DISEÑADA, sin construir:
> [`docs/t1-presupuesto-inyeccion.md`](docs/t1-presupuesto-inyeccion.md).**
> Umbral del harness **10 000 caracteres por hook** (`confirmado`: constante
> `1e4` en `claude.exe` 2.1.284 + censo de 1 235 salidas). El arranque del repo
> se pierde entero en **13 de 30** sesiones (58 s contra 60 de timeout). Lo que
> sigue es el §7 del doc, **en orden**: (1) `perfil-global/herramientas/
> medir-inyeccion.py` + `probar-medir-inyeccion.ps1`, que tienen que dar
> **rojo sobre el estado de hoy**; (2) arranque partido (texto / medición con
> fecha límite 40 s); (3) pilares en dos hooks; (4) núcleo generado de
> `chequeo` en dos hooks; (5) hook al paso. Nada de eso está hecho. De paso:
> la línea `Fase en curso` del PDP ya dice 7, tipo D, verificado sobre lo que
> inyecta el hook. Dos lecciones nuevas (`propia`), con su línea en
> `chequeo-de-trabajo.md` e instaladas. El doc de T1 ya está en el índice del
> contrato, y el título del ESTADO dice «Fase 7 ABIERTA».
>
> **Antes (2026-09-28, tarde): el diagnóstico medido del método entero está en
> [`docs/diagnostico-2026-09-28.md`](docs/diagnostico-2026-09-28.md)**: once
> problemas (A1–A11) con su evidencia, el N² de quién le entrega qué a quién y
> el camino crítico de la reforma (T1 → T2 → T3 → T4 → T7 → T9, ~9-16
> sesiones a ojo). Lo pidió Fran para dedicar sesiones a reformar y dejarlo
> sostenible. **El primero es A1**: `chequeo-de-trabajo.md` (129 KB) y
> `pilares.md` llegan a la sesión como **2 KB de vista previa**: lo que el
> método dice que «se lee solo» no se lee. Salió de una sesión de BLACK (109),
> no de una sesión de este proyecto; la fase 7 sigue abierta y el diagnóstico
> es su insumo. De paso: la fila 6 del PDP quedó marcada CERRADA (el hook
> inyectaba «fase 6» como activa). **Al cerrar se vio A11 en vivo:** otra
> sesión de Claude trabajaba en `fisica-espacial` en este mismo árbol mientras
> corrían los saboteadores, y su recompilación puso en rojo la limpieza.

Sesión 7 de N. **2026-09-17.** Opus, esfuerzo alto, **inline, sin un solo
subagente** — la sexta fase seguida así. **Cero PDF extraídos.**

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Rechtin & Maier. Fran: "mínima ambigüedad
posible", y las necesidades que generaron la arquitectura actual **siguen
valiendo**.

## ESTADO — fase 6 CERRADA, abre la fase 7

La fase 6 cerraba por tres cosas y cerró por las tres, medidas:

```
Chequeo OK. Ningun rojo.     7 medidores + 10 saboteadores + 7 de limpieza
38 filas: 33 cumple, 2 no aplica, 3 recortado   (todas con su resta)
8 PDP: 1 en verde, 0 en rojo, 7 sin migrar
```

**Es la primera fase que tocó archivos vivos**, y el rigor pleno se respetó:
saboteador corrido **antes** de dar por puesta cada pieza, repo commiteado y
pusheado entre piezas.

**Instalado:** P2 (matriz), P3 (rigor por aspecto), P4 (molde de fase), P6
(criterio de entrada) y P7 (System 2/3) en `cumple`; P5 **recortado con la
mitad puesta**; P1 diferido con su resta; P10 es de la fase 7.

**Los tres defectos vivos, cerrados:** D12, D14 y el medidor de desuso.

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. Un saboteador escrito por el autor del freno hereda su punto ciego, y
esta vez se midió.** El freno de D12 **ya existía** en `install.ps1`, con su
caso de sabotaje, en verde desde el 2026-08-28. El patrón miraba la **primera
línea**; el saboteador rompía el archivo **en la primera línea**; el `186` real
vivía en la **línea 19**. El test probaba que el patrón matchea su propio
ejemplo. **Es el argumento más fuerte para que P8 siga declarada como hueco sin
respuesta** en vez de darse por cubierta con los saboteadores.

**2. La inyección dejó de ser entrega, y hay número.** La lección de los
escapes de C estaba escrita desde el 13/09, con triage `propia`, e **inyectada
en `chequeo-de-trabajo.md` línea 553**. Estuvo en el contexto desde el arranque
y el mismo error corrompió **cinco archivos vivos** en esta sesión —uno de
ellos el .md que se inyecta en cada sesión, y dos datos técnicos de BLACK
medidos contra el ELF—. A **95 KB, 1347 líneas, 154 viñetas**, es exactamente
lo que Rechtin p. 35 llama hojear una ferretería. Eso decidió qué mitad de P5
construir: el guardia que entrega **en el paso**, no la partición del archivo.

**3. Un chequeo que valida un rango tiene que validar las dos puntas.** El de
ASCII miraba `>127` y era ciego a los controles `<32`. La pregunta correcta no
es *qué valores malos conozco* sino *cuál es el conjunto de los legítimos*.

**4. "Nada que medir" y "todo bien" son opuestos, y el segundo crece solo.**
Apareció **dos veces**: en `medir-matriz.py` y en `medir-fase.py`, la segunda
ya con la lección escrita. Verde por vacío es el único verde que **aumenta** a
medida que la disciplina se abandona, porque abandonarla borra justo lo que el
medidor buscaba.

**5. Se reescribieron los requisitos, no el chequeo.** Los 4 VIOLA que
quedaron en español eran defectos reales (`su`, una negación), los mismos que
el chequeo marca en inglés sobre `its` y `not`. Ablandar las listas para que
pasaran habría sido calibrar el medidor contra el resultado buscado.

**6. Un saboteador sin `exit 0` hereda el código del comando que TENÍA que
fallar.** Dos saboteadores sanos reportados en rojo por el orquestador, en
0,9 s — y el tiempo corto hizo pensar que morían al arrancar.

## ENTRADAS A LA FASE 7, YA ESCRITAS

1. **P10, el medidor de validación** — *timely / affordable / predictable /
   comprehensive* (SEH p. 165-166). **Tiene con qué medirse**: el costo por
   fase está registrado fase por fase en `ESTADO_ACTUAL.md`, desde los 2,07 M
   tokens de la fase 0 hasta los ~31 puntos de la 6.
2. **La otra mitad de P5**: partir `chequeo-de-trabajo.md`, que sigue pesando
   95 KB. Criterio ya escrito: lo que se inyecta pesa menos, **y** la lección
   del paso en curso está adentro.
3. **P1, el catálogo derivado**, con su resta ya escrita en la matriz.
4. **Migrar los otros 7 PDP.** `medir-fase.py` cuenta 1 en verde y 7 sin
   migrar; ese número tiene que bajar, y el medidor lo muestra solo.
5. **`ingenieria-de-sistemas.md`** con las 4 correcciones de
   `docs/arquitectura.md` §8, y la pregunta abierta sobre si sigue haciendo
   falta.

## LO QUE SE TOCÓ

Archivos vivos, **todos con su saboteador corrido**: `install.ps1`,
`chequeo-de-trabajo.md`, `herramientas/aprender.py`, `verify-install.ps1`,
`manifiesto.ps1`, `CLAUDE.md` del perfil, `README.md` del perfil,
`verificar-requisito.py` y sus casos, `verificar-estructura.ps1`,
`probar-verificador.ps1`, `probar-chequeo-lecciones.ps1`,
`chequeo-completo.ps1`, `plantillas/PDP.md`, `MAQUINA-NUEVA.md`, el `CLAUDE.md`
de la raíz, y el `PDP.md` y `docs/` de este proyecto. Más BLACK:
`ESTADO_ACTUAL.md` y `sesiones/HANDOFF.md`, por los caracteres de control.

**Nuevos:** `herramientas/medir-matriz.py`, `herramientas/medir-fase.py`,
`hooks/guardia-escapes.ps1`, `probar-medidor-matriz.ps1`,
`probar-medidor-fase.ps1`, `probar-chequeo-ascii.ps1`,
`probar-guardia-escapes.ps1`, `casos/sanos-es.txt`, `casos/rotos-es.txt`,
`.claude/controles-permitidos.json`.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

```powershell
.\chequeo-completo.ps1 -SoloMedidores
```

Tiene que dar **7 verdes y ningún rojo**. Si da otra cosa, eso es lo primero
que se mira: la fase 6 cerró con todo en verde, así que un rojo ahí es algo
que pasó **después**.
