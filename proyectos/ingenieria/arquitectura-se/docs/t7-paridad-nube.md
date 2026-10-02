# T7 — Paridad nube/local: pasar a la nube sin pensar el «cómo» cada vez

Pedido de Fran, 2026-10-02 (con el plan al 97 %): «un método correcto para
pasar a nube sin que tengas que pensar "cómo" cada vez». Es la T7 del camino
crítico (`diagnostico-2026-09-28.md` §3), adelantada por necesidad real.

## 1. Lo que se midió (2026-10-02, sesión `ecb1314f`)

| Hueco | Evidencia | Grado |
|---|---|---|
| En la nube no corre **ningún** hook | todos los comandos de `.claude/settings.json` llevan ruta absoluta `C:\Users\frans\...`; la sesión de la nube informó que la puerta no le pidió nada | confirmado (la nube lo vio) |
| No llega **el perfil** (reglas, pilares, núcleo, cuadro, skills) | vive en `~/.claude/` instalado desde `perfil-global`, que es repo **privado** y aparte | confirmado (`gh repo view`: PRIVATE) |
| `aprender.py` no existe en la nube | vive en `perfil-global/herramientas/` | confirmado (la nube lo informó) |
| `cascada.ps1` no corre en Linux | 20 K de PowerShell con rutas `\`; pero lo que exige ya lo calcula `cascada_puerta.py --exige` | probable |
| La puerta sólo reconoce `cascada.ps1` | regex `DECL` y `LECTURA` de `cascada_puerta.py` (líneas ~52 y ~414) | confirmado (leído) |
| Los criterios de cátedra viajan **pegados** en el retome | `catedras` es privado y **sin remote**: en la nube no existe | confirmado |
| `python` existe en la nube | la sesión de la nube corrió `verificar-ejemplos.py` | confirmado |
| **Causa raíz de que no corran los hooks:** en el clon de la nube **no hay** `.claude/settings.json` | está en `.gitignore` (línea 51) y lo **genera** `.claude/instalar-hooks.ps1` con la ruta medida de la máquina; en la nube nadie lo corre. Las rutas `C:\...` son un segundo problema, detrás de éste | confirmado (2.ª sesión en la nube: `ls -a .claude/` sin `settings.json`) |
| typst y pymupdf **no vienen** en el contenedor, en ninguna sesión | `typst: command not found` y `No module named 'fitz'` al arrancar; se bajan en ~10 s | confirmado (dos sesiones) |
| Un `rm -f $S/*.png` lo **bloquea** un chequeo de seguridad de Claude Code en la nube (variable que podría quedar vacía) | el comando entero no corrió; la salida propone `"${S:?}"/*.png` | confirmado (2.ª sesión) |
| El retome puede pedir algo que en la nube **no existe** | el de la 2.ª sesión pedía «buscar en el Práctico qué ejercicios toca el módulo»; el Práctico es material de la PC. Se resolvió dejándolo como `hipótesis` en el ESTADO | confirmado |
| `apt-get install` **anda** en la nube: `gcc-arm-none-eabi` 13.2 en ~1 min | sirvió para medir en Cortex-M4 lo que antes era supuesto (módulos 6 a 10 del apunte de C) | confirmado (2.ª sesión) |
| `git push origin HEAD:main` **anda** desde la nube | commits `83dea96`, `f1b58bf`, `5ed2d60` | confirmado |

## 2. Requisitos (verificables)

- **R1** Una sesión en la nube (`CLAUDE_CODE_REMOTE=true`) recibe al arrancar
  lo mismo que la local: CLAUDE-global, pilares (2), apertura, núcleo (4) y el
  recordatorio por turno. *Se verifica:* `medir-costo.py` (o el transcript)
  de una sesión de la nube muestra los 8 bloques.
- **R2** La puerta de la cascada y `fase_activa` corren en la nube y frenan
  igual. *Se verifica:* en la nube, un Edit sobre un proyecto sin declarar
  sale denegado.
- **R3** Nada cambia en local: mismos hooks, mismo costo. *Se verifica:*
  `probar-hooks.ps1` en verde y un `claude -p` local con Haiku que intenta
  editar sin declarar sale denegado (la frontera real, no el autotest).
- **R4** Lo que la nube usa del perfil es una **copia generada** con dueño
  único (`perfil-global`) y un medidor que da **rojo** si quedó vieja (MD5
  contra la fuente), en la capa rápida del arranque local.
- **R5** Lo que la nube aprende vuelve: `aprender.py agregar` en la nube
  escribe a una **bandeja** en `claude-acceso` (`.claude/nube/bandeja.jsonl`);
  el arranque local avisa si no está vacía y la sesión local la registra en
  `perfil-global` y la vacía.
- **R6** Pasar a la nube es **un comando**: `.\pasar-a-nube.ps1 <proyecto>
  -Necesidad <a,b>` regenera la copia del perfil, corre el medidor, commitea,
  pushea y **escribe el retome** (lo que hoy se hace a mano cada vez).
- **R7** Lo privado no se publica: la copia excluye `lecciones.jsonl`,
  `LECCIONES.md`, `PENDIENTES.md` y todo lo que la regla 5 de
  `verificar-estructura.ps1` marque. Lo que la cátedra pide, si va a la nube,
  va como **resumen público fechado** en el proyecto de la materia, generado
  desde `catedras` (decisión de Fran: ver §4).

## 3. Diseño elegido

1. **`.claude/nube/perfil/`** — copia generada de los 6 `.md` inyectados +
   `chequeo-de-trabajo.md` (la puerta pide rangos de él) + las skills del
   perfil + `herramientas/aprender.py`. La genera `pasar-a-nube.ps1` (y
   `install.ps1`), con `MANIFIESTO.md5`.
2. **`.claude/nube/nube.py`** — un solo script, subcomandos:
   - `arranque`: si no es la nube, sale 0 sin hacer nada. Si es: copia
     `perfil/` a `~/.claude/` con **las mismas rutas** que local (así el
     catálogo de la puerta sirve igual), instala typst 0.15 si falta, mira gcc.
   - `emitir <archivo> [parte de]`: el equivalente de `emitir-contexto.ps1`,
     con el mismo corte en frontera de sección (sólo en la nube).
3. **`settings.json`**: las entradas `python "C:\..."` pasan a
   `python "$CLAUDE_PROJECT_DIR/.claude/hooks/..."` (sirven en los dos lados,
   sin duplicar), y se agregan las de `nube.py` para lo que en local da el
   perfil global. **Riesgo a medir primero (R3):** que en Windows los hooks
   corran por Git Bash y expandan `$CLAUDE_PROJECT_DIR` (`probable`); si no,
   la puerta local fallaría abierta en silencio. Se prueba con `claude -p`
   antes de dar nada por puesto.
4. **`cascada.sh`** — envoltorio de `cascada_puerta.py --exige` con la misma
   sintaxis (`-Necesidad`, `-Excepcion`); `DECL` y `LECTURA` aceptan
   `cascada\.(ps1|sh)`. Autotest con un caso nuevo.
5. **Lo que NO se lleva, declarado:** `guardia-iso` (el ISO no está en la
   nube), `guardia-heredoc` y `guardia-fanout` (PowerShell; el retome dice
   «sin fan-out»), rclone/Drive (lo publica la PC con un pull), los repos
   privados sin remote.

## 4. Decidido por Fran (2026-10-02)

- **Sí**, la copia del perfil (método **sin lecciones**) se publica en este
  repo público: «Esta cuenta es mía ahora, ya no comparto con Agustín».
  Registrado también en `metodo-agustin` (PDP §6), cuyas fases 1 y 2 cambian.
- **Sí**, los criterios de Leandro van como resumen público fechado: «son
  interpretaciones nuestras». Hecho a mano en
  `software-de-vuelo/docs/CRITERIOS-LEANDRO.md` (la regla 3 del proyecto lo
  dice). R7 pide que salga **generado** desde `catedras`: hasta que exista el
  generador, el resumen manual dice «si discrepan, gana el privado» y nadie
  mide la divergencia (hueco declarado).

- **Todo lo privado va a GitHub privado** (Fran, 2026-10-02: «poder seguir
  avanzando proyectos en nube cuando me quedo sin créditos, no me importa cómo;
  la única indicación es que lo mantengas todo privado para mí lo de GitHub, y
  lo público del Drive es lo que ya convenimos»). Consecuencia: cada repo propio
  sin remote (`catedras`, `clases-aed`, `cohete-de-agua`, `teoria-circuitos`,
  `haberes-docentes`) se crea **privado** con su nombre; el material de cátedra
  (`catedras/fisica-espacial/iluminacion-final.pdf`) va también, porque es
  privado y GitHub privado es su destino. Drive: sin cambios. Lo hace el paso 3
  de `herramientas/cierre-desde-la-nube.ps1`, que frena si un remote resulta
  público o si hay un archivo de más de 95 MB.
- **`claude-acceso` queda público** (Fran, 2026-10-02: «queda público acceso,
  decidido»). Lo protege la regla 5 de `verificar-estructura.ps1`.
- **Hecho (corrido en la PC el 2026-10-02):** `catedras`, `clases-aed`,
  `cohete-de-agua`, `teoria-circuitos` y `haberes-docentes` creados privados y
  subidos; `coaching` y `perfil-global` ya estaban. Tabla de dueños de
  `MAPA.md` §2 al día.

## 4 bis. Lo que la 2.ª sesión en la nube cambia del diseño

1. **§3 punto 3 no alcanza tal cual.** Cambiar las rutas de `settings.json` a
   `$CLAUDE_PROJECT_DIR` no sirve si el archivo no llega al clon. Opciones:
   **(a)** trackear un `.claude/settings.json` con rutas relativas a
   `$CLAUDE_PROJECT_DIR` y que `instalar-hooks.ps1` deje de generarlo (lo
   local se vuelve a medir con R3); **(b)** dejarlo ignorado y que el *setup
   script* del entorno de la nube (se edita en claude.ai, en el menú del
   entorno de la sesión → Edit → Setup script) lo genere con un instalador
   Linux. La (a) tiene un solo dueño y se ve en el diff; la (b) esconde una
   pieza fuera del repo. **Recomendada: (a)**, con R3 primero.
2. **Herramientas del contenedor:** typst 0.15 y pymupdf se pueden instalar
   en el *setup script* del entorno (corre antes de cada sesión nueva) en vez
   de en `nube.py arranque`. Lo del setup script no está versionado: si se
   elige, se copia su texto a `.claude/nube/setup-script.sh` y un medidor
   compara (como R4).
3. **R6 necesita un control del retome:** antes de escribir el retome,
   `pasar-a-nube.ps1` tiene que mirar que lo que manda leer **existe en el
   clon** (no en un repo privado sin remote ni en el Escritorio). Lo que no
   existe se marca en el retome como «no está en la nube: queda como
   `hipótesis`», que es lo que esta sesión hizo a mano.
4. **R5 tiene hoy una versión manual:** las lecciones de la nube van al
   HANDOFF del proyecto en un bloque «LECCIONES PARA aprender.py (las registra
   la PC)». Hoy hay **un** archivo con ese bloque
   (`software-de-vuelo/HANDOFF.md`, 1 lección). La bandeja de R5 reemplaza
   eso, y mientras tanto el arranque local podría buscar ese título con `grep`
   (barato, y no se pierde ninguna).
5. **En los scripts, `rm` con variable lleva `"${VAR:?}"`**: lo pide el chequeo
   de seguridad de la nube, y es más sano igual.

## 4 ter. Una sesión larga en la nube, medida (2026-10-02, apunte de C módulos 4 a 12)

Fran pidió seguir sin parar «para cuando haya límite local, mejoremos la
arquitectura y el traspaso a nube». Lo que hizo falta, para que lo construya
`pasar-a-nube` / el *setup script*:

| Necesidad | Cómo se resolvió a mano | Qué debería hacerlo solo |
|---|---|---|
| typst 0.15 | `curl` del release de GitHub, cada sesión | setup script del entorno (o `nube.py arranque`) |
| pymupdf (mirar el render, `revisar-pdf.py`) | `pip install pymupdf` | ídem |
| `arm-none-eabi-gcc` (medir en Cortex-M4: tamaños, stack, secciones, ensamblador) | `apt-get install gcc-arm-none-eabi`, ~1 min | ídem; **cambió el contenido**: 6 supuestos pasaron a medidos, y uno era falso para la placa (`enum` de 1 byte, no 4) |
| criterios de la cátedra | `docs/CRITERIOS-LEANDRO.md` (decisión de Fran) | generado desde `catedras` (R7) |
| lecciones | bloques «LECCIONES PARA aprender.py» en el HANDOFF (3 en esta tanda) | la bandeja de R5 |
| no perder trabajo por un corte | **un commit y push por módulo** (10 commits a `main`), con ESTADO, HANDOFF y MATERIAS en cada uno | regla del retome: «checkpoint por unidad de trabajo» |
| trampas de Typst | un escáner ad hoc antes de compilar (número y punto al principio de renglón, comilla invertida impar, `~ < > @ \`, `//`) | `revisar-typ.py` con saboteador, propuesto en el HANDOFF de software-de-vuelo |
| render | `revisar-pdf.py` (nuevo, con saboteador) + mirar todas las páginas | ya existe; sumarlo al chequeo del proyecto |
| material de la PC (prácticos, `.ld`, la placa) | todo lo que dependía de eso quedó como `hipótesis` y en una **lista numerada para la PC** en el HANDOFF | el control del retome (§4 bis, punto 3) |

**Lo que funcionó y conviene volver regla del retome:** (1) leer sólo
HANDOFF + ALCANCE + el módulo anterior como modelo; (2) medir cada trampa en
el compilador *antes* de escribirla; (3) un commit por módulo; (4) toda
afirmación no medida, con «suele» o como `hipótesis` en el ESTADO; (5) al
final, una lista para la PC ordenada y concreta.

**Deriva de documentos vista:** una celda de `carrera/MATERIAS.md` quedó en
«v0.4» durante seis versiones, porque cada sesión reemplazaba un texto exacto
que ya no coincidía y el `if not in: print` lo dejaba pasar. Un reemplazo que
no encuentra su texto tiene que fallar, no avisar.

## 4 quater. El libro, resuelto por flujo (2026-10-02, regla 16)

El hueco más caro no eran los hooks: era que **el perfil no llegaba**, y la
sesión en la nube trabajó sin reglas ni lecciones. R1 se cubre ahora *sin la
copia generada* del §3.1: `perfil-global` está en GitHub privado y se suma a
la sesión con `add_repo`; `.claude/nube/traer-perfil.sh` lo clona o actualiza,
lo instala en `~/.claude`, mide el efecto y lista qué leer, y sin perfil da
rojo (falla cerrado). Como se lee del repo y no de una copia, no envejece: R4
deja de hacer falta para el perfil. El aviso que dispara todo vive en el
`CLAUDE.md` de `claude-acceso`, que es lo único que llega solo a cualquier
clon. **Sigue abierto:** que la sesión lo corra por sí sola sin depender de
leer el aviso (un hook, que en la nube no corre: §4 bis punto 1), y los hooks
de la puerta y de la fase.

## 4 quinquies. Construido en la PC (2026-10-02, sesión de retome)

| Qué | Cómo se midió | Grado |
|---|---|---|
| **R3**: en Windows el harness corre los hooks con `/usr/bin/bash` de Git (`MSYSTEM=MINGW64`) y `$CLAUDE_PROJECT_DIR` llega expandida, con barras `/` | sonda en un proyecto descartable con `claude.exe` 2.1.286 (el mismo binario de la sesión) **y** un hook marcador en la sesión viva: `settings.json` se recarga en caliente | confirmado |
| `claude -p` desde la app de escritorio **no sirve** para R3: responde «Not logged in» (no hereda la credencial del host) | intento directo | confirmado |
| **Opción (a) del §4 bis**: `.claude/settings.json` **trackeado**, rutas `$CLAUDE_PROJECT_DIR/...`, fuera del `.gitignore`; `instalar-hooks.ps1` ya no lo genera: lo verifica y, si un desinstalar le sacó los hooks, lo restaura del repo | vuelta desinstalar → instalar: el archivo quedó idéntico al commiteado | confirmado |
| La puerta sigue frenando en local con el comando nuevo | un `Write` sobre `carrera` sin declarar salió negado **después** de ver el marcador | confirmado |
| Gate por **capacidad**, no por etiqueta: `command -v powershell \|\| exit 0`. En la PC powershell existe siempre (no abre un fail-open local); en la nube callan el guardia (no hay ISO) y la puerta (no hay `cascada.ps1` con qué declarar: frenaría todo sin salida). `fase_activa` corre en los dos | `probar-settings.py`, casos 6 y 7 | confirmado en Windows; en la nube `hipótesis` |
| **Punto 3 del retome — el libro sin depender del aviso:** `SessionStart` corre `traer-perfil.sh` sólo donde no hay PowerShell, y sale 0 siempre para que su ROJO llegue al contexto | `probar-settings.py`, caso 6 (sin PowerShell: dice ROJO y `add_repo`) y 7 (en la PC no corre) | confirmado en Windows simulando la nube; en la nube real `hipótesis` |
| `cascada_puerta.py` en Linux niega igual que en Windows | WSL (Ubuntu, Python 3.12) con un payload de Edit sin declarar | confirmado |
| ~~`fase_activa.py` en Linux corre (rc 0) pero **no dice nada** con rutas POSIX~~ **Refutada** (2.ª sesión de retome): con una sesión nueva y ruta POSIX **sí** emite la compuerta; el patrón ya aceptaba `/`. El silencio de la medición anterior era, `probable`, la marca de «una vez por sesión» | WSL, sesión nueva, ruta `/mnt/c/...` | confirmado que habla; la causa del silencio viejo, `probable` |
| **§3 punto 4 — `.claude/cascada.sh`**: envuelve `cascada_puerta.py --exige` con la sintaxis de `cascada.ps1` (`-Necesidad`, `-Excepcion`); elige `python` o `python3`. La puerta reconoce `cascada\.(ps1\|sh)` (también con `bash ` delante) en `LECTURA`, `DECL` y el registro de invocaciones, y el deny nombra el comando que sirve en esa máquina (mismo gate por capacidad: con PowerShell, `cascada.ps1`) | autotest de la puerta: 3 casos nuevos (declarar por `.sh` cuenta, un `echo` que lo nombra no, excepción por `.sh` pasa); con el reconocimiento viejo, **2 MAL** por el motivo correcto (pedía declarar). WSL: `cascada.sh` corre con sólo `python3` y el deny nombra `bash .claude/cascada.sh` | confirmado (Windows y Linux) |
| **Puerta sin gate** en `settings.json` (Pre, Post y `compact`): `$(command -v python \|\| command -v python3)`, y en `PreToolUse` sin ninguno de los dos sale **2** (falla cerrado). `fase_activa` con el mismo respaldo (WSL no tiene `python`) | `probar-settings.py` casos 6 (precondición: sin PowerShell y con python; la puerta frena y nombra `cascada.sh`; `cascada.sh` lista lo exigido; su declaración cuenta; sin intérprete rc 2): con el `settings.json` viejo **3 FAIL**, con el nuevo verde. En la sesión viva, un `Write` sobre un proyecto sin declarar salió negado con el comando nuevo | confirmado en Windows simulando la nube; en la nube real `hipótesis` |
| **Hallazgo, sin arreglar a propósito (fase D: no se rediseña en la marcha):** si un archivo que el catálogo exige **no existe** (en la nube sin perfil: la skill `pdf-con-codigo`), la puerta **deja pasar en silencio** — sólo lo anota, y sin otra cosa pendiente sale 0. Es un `return` temprano que falla abierto (Saltzer). Con el perfil traído no pasa; sin perfil, la regla 16 ya frena por otro lado | autotest de la puerta en WSL: «concepto typst sin leer pdf-con-codigo» da **pasa** | confirmado; decisión de diseño pendiente (¿el «NO EXISTE» de un exigido niega, con la reparación del catálogo como salida?) |
| El saboteador de las líneas de comando: `.claude/probar-settings.py` (16 casos, Git Bash, `bash -c`, payload por stdin), llamado por `probar-hooks.ps1` | rojo con el `settings.json` viejo; 3 rojos con un mutante (gate de la puerta invertido); el enganche en `probar-hooks` también se vio en rojo | confirmado |

**Medido en la nube real (2026-10-02, sesión de claude.ai/code, `claude-acceso`
`14f4b73`, `perfil-global` `7a59473`, Linux 6.18, Python 3.11.15).** Las cinco
mediciones del retome, en orden; **ninguna en rojo**:

| # | Hipótesis | Lo que se vio | Grado |
|---|---|---|---|
| 1a | `CLAUDE_PROJECT_DIR` puesta | **En el shell del tool Bash, vacía** (`[]`). En el entorno de los **hooks**, puesta: los ocho comandos de `settings.json` usan `"$CLAUDE_PROJECT_DIR/..."` y tres scripts distintos emitieron **su propio texto** (el ROJO de `traer-perfil.sh`, el deny de la puerta, la compuerta de `fase_activa`); vacía, la ruta sería `/.claude/...` y lo que saldría es el error de Python, no ese texto. Son dos entornos: `echo` desde el tool Bash mide el actor equivocado (lección del núcleo «Identificá al ACTOR por efecto antes de medirlo») | confirmado por efecto, para los hooks |
| 1b | `command -v powershell` falla | ausente, rc 1 (tampoco `pwsh`). Guardia y arranque callaron: el Edit pasó sin error de hook | confirmado |
| 1c | hay `python` o `python3` | los dos: `/usr/bin/python` y `/usr/bin/python3`, 3.11.15 | confirmado |
| 2 | la salida de `traer-perfil.sh` llega al contexto al abrir | llegó, como `SessionStart:startup hook success:` con el texto entero: «[ROJO] el perfil no esta en /home/user/perfil-global. NO se arranca ninguna tarea sin el.» y los tres pasos (`add_repo`, `git clone --depth 1`, volver a correr). Hechos los tres, el script dio `[OK] perfil instalado en /root/.claude (... commit 7a59473)` y listó los cuatro archivos | confirmado |
| 3 | la puerta niega un Edit sin declarar y nombra `bash .claude/cascada.sh` | `PreToolUse:Edit hook error: PUERTA DE LA CASCADA (T11): vas a actuar sobre 'arquitectura-se' sin haber declarado la NECESIDAD ... bash .claude/cascada.sh arquitectura-se -Necesidad <a,b>`. Antes, lo mismo con un `grep` de sólo lectura por **Bash** sobre la carpeta del proyecto | confirmado |
| 4 | `cascada.sh` declara, lista lo exigido, y el Edit pasa | rc 0; listó 6 rangos (46 254 caracteres, ~13 K tokens); leídos con Read; el **mismo** Edit pasó | confirmado |
| 5 | `fase_activa` inyecta la compuerta al tocar el proyecto | `PostToolUse:Read hook additional context: FASE ACTIVA de arquitectura-se ... NASA : Phase D, "System Assembly, Integration and Test, Launch"` en el **primer** Read sobre el proyecto (el HANDOFF), una sola vez | confirmado |

Observaciones que **no** son rojo, para quien decida:

- **El retome pidió leer «nada más» que dos tramos, y la puerta exigió 46 K
  caracteres** para poder anotar acá. Es la observación (2) de la validación de
  T11 (el cierre cuesta más lectura que la tarea), ahora también en la nube.
- **La puerta frena también el Bash de sólo lectura** sobre un proyecto (un
  `grep` de encabezados). Read y Grep pasan. No costó nada (se usó Grep), pero
  un retome que diga «ubicar con grep» choca.
- **Un Read hecho antes de declarar cuenta**: el HANDOFF se leyó (1-90) antes
  de correr `cascada.sh` y la puerta no lo volvió a pedir. `probable` que sea
  a propósito (lo que importa es haber leído); no se midió con un caso aislado.
- El hallazgo del exigido inexistente (fila de arriba) **no** se pudo ver acá:
  con el perfil traído, los seis exigidos existían.

**R2 (la puerta en la nube): cerrado**, medido en la frontera real.

## 5. Orden de construcción

R3 (la prueba de la frontera en Windows) → 3 → 4 → 1-2 → R5 → R6. **Hechos el
2026-10-02: R3, 3 y 4** (§4 quinquies), más el `traer-perfil` automático y la
puerta sin gate. **La sesión real en la nube, hecha el mismo día: las cinco
mediciones en verde (§4 quinquies, «Medido en la nube real»).** Sigue 1-2 (lo que queda: el
perfil ya no necesita copia, §4 quater). El rojo de `carrera` sin entrada en `.claude/cascada.json`
quedó cerrado, y `nuevo-proyecto.ps1` ahora escribe la fila
(`probar-nuevo-proyecto.ps1`).
