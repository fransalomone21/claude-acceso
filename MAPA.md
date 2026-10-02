# MAPA — el inventario del sistema

**Se lee una vez, no cada sesión.** Existe para que nadie —persona o modelo—
tenga que volver a descubrir esto explorando el disco. El día que se explore
de nuevo, es porque este archivo quedó viejo: corregirlo es parte del arreglo.

Levantado el **2026-08-27**, sobre el estado real del disco.

---

## 1. El árbol

```
C:\Users\frans\Desktop\
│
├── claude-acceso\                    ← ÚNICO punto de entrada. Rama: main
│   ├── CLAUDE.md                     el enrutador (nivel 2). Se carga solo
│   ├── MAPA.md                       este archivo
│   ├── bootstrap.ps1                 deja una máquina lista
│   ├── nuevo-proyecto.ps1            crea (o adopta) un proyecto con PDP y contrato
│   ├── cascada.ps1                   el flujo de lectura de UN proyecto, en orden
│   ├── verificar-estructura.ps1      las 4 reglas, en 7 bloques, contra el disco
│   ├── probar-verificador.ps1        rompe cada bloque y exige el rojo
│   ├── .gitignore                    quién NO se versiona acá, y por qué
│   ├── .claude\
│   │   ├── protegidos.json           los archivos en ReadOnly + el guardia
│   │   ├── datos-permitidos.json     los mails/teléfonos que SÍ pueden publicarse
│   │   └── fuera-del-sistema.txt     las carpetas del Escritorio que no son proyectos
│   │
│   ├── perfil-global\                ← REPO PROPIO · ignorado acá
│   │                                   github.com/fransalomone21/perfil-global
│   │                                   el método: reglas, skills, hooks, lecciones
│   │
│   ├── plantillas\                   de acá nace todo proyecto nuevo
│   │   ├── PDP.md                    Plan de Desarrollo de Proyecto
│   │   ├── proyecto-CLAUDE.md        → se copia como <proyecto>/CLAUDE.md
│   │   ├── ESTADO_ACTUAL.md
│   │   ├── HANDOFF.md
│   │   └── naturalezas\              qué se lee SIEMPRE en cada clase
│   │       ├── ingenieria.md
│   │       ├── documentos.md
│   │       └── seguimiento.md
│   │
│   ├── proyectos\
│   │   ├── ingenieria\
│   │   │   ├── black\                reversa de BLACK (PS2) — ACTIVO, fase 7e
│   │   │   │   └── lanzadores\       los .bat que antes estaban en Desktop\BLACK
│   │   │   ├── diagnostico-msi\      Secure Boot y batería MSI — cerrado
│   │   │   ├── telescopio\           plataforma ecuatorial Dobson — dormido
│   │   │   └── telefono-samsung\     kit ADB — suspendido 2026-08-15
│   │   ├── documentos\
│   │   │   ├── electronica-analogica\  apunte Typst 103 pág — ACTIVO
│   │   │   ├── repaso-iise\            guion + audios — terminado
│   │   │   ├── teoria-circuitos\     ← REPO PROPIO · ignorado acá · NO se pushea
│   │   │   ├── catedras\             ← REPO PROPIO · ignorado acá · lo que pide cada profesor
│   │   │   ├── cohete-de-agua\       ← REPO PROPIO · ignorado acá · TP Cohete de Agua (grupo)
│   │   │   └── software-de-vuelo\    guías de C y de IDEs (STM32) — ACTIVO
│   │   └── seguimiento\
│   │       └── coaching\             ← REPO PROPIO PRIVADO · ignorado acá
│   │       (caso-tio: borrado por Fran el 2026-09-29, no se sigue;
│   │        la línea de .gitignore queda, por si reaparece una copia)
│   │
│   └── archivo\
│       └── RAMAS.md                  qué quedó en las ramas viejas
│
└── (fuera del sistema, no son proyectos de Claude)
    00 - Personal\ · 01 - UNSAM\ · 02 - Archivo\ · 03 - Docencia\
    04 - Terceros\ · Juegos\ · Herramientas\
```

**El Escritorio se reordenó de nuevo el 2026-09-28/29**, y ahora usa **la
misma numeración que la raíz de Mi unidad en Drive** (`.claude/estructura-drive.json`):
un solo mapa para los dos lados. El número dice el **área**; lo que se
**produce** con Claude sigue viviendo en `claude-acceso\proyectos\`, y lo de
las carpetas numeradas es **material de entrada** (lo que da la cátedra, lo
que ya se entregó, lo personal).

| Carpeta | Qué va | Espejo en Drive |
|---|---|---|
| `00 - Personal\` | documentación, CV, fotos, inglés, varios | `00 - PERSONAL` |
| `01 - UNSAM\` | una carpeta **por materia** con el nombre de la materia: `Fisica Espacial`, `IISE`, `Software de Vuelo`, `Teoria de Circuitos`. Adentro, el material de la cátedra y lo propio de esa materia | `01 - UNSAM - Ing. en Sistemas Espaciales` |
| `02 - Archivo\` | cursadas que ya no se trabajan: `Programacion 1C 2026` (el STAR_WARS de PlatformIO) | `02 - ARCHIVO - cursadas anteriores` |
| `03 - Docencia\` | `EEST N1`: el cargo docente | (Drive tiene `03 - CLASES PARTICULARES`: mismo rubro, otra cosa) |
| `04 - Terceros\` | trabajos hechos para otra persona: `Planos gasista` | `04 - TERCEROS` |

Cada movimiento, con su origen y su destino, quedó en
`archivo/mudanza-escritorio-2026-09-28.csv` (sólo en esta máquina: es estado
de la máquina y no se commitea). Con ese archivo la mudanza se deshace entera.

**Tres cosas que viven fuera del Escritorio y se sabe dónde:**
- El **workspace de STM32CubeIDE** se mudó a
  `01 - UNSAM\Software de Vuelo\STM32\workspace_1.18.1\` y CubeIDE apunta ahí
  (`C:\ST\STM32CubeIDE_1.18.1\STM32CubeIDE\configuration\.settings\org.eclipse.ui.ide.prefs`,
  con `.bak-2026-09-28` al lado). Compila desde la ruta nueva, medido.
- Los **proyectos de C en WSL** (`\\wsl.localhost\Ubuntu\home\franco_salomone\projects\`)
  **no se mudaron**: fuera de Linux se rompe el flujo de compilar ahí. Los de
  la carpeta raíz son de Programación 1C 2026; `espaciales\` es de Software de
  Vuelo.
- Las **descargas** siguen en `Downloads`, que no se ordena: lo que sirve se
  mueve a su materia.

**El Escritorio se ordenó el 2026-09-17** y pasó de 33 items a 15. Lo que
cambió de lugar, porque los nombres viejos aparecen en sesiones anteriores:

| Estaba | Está |
|---|---|
| `Programas y juegos\` — mezclaba juegos, BIOS de PS2, emuladores y scripts del sistema | se desarmó en `Juegos\` y `Herramientas\` |
| `DBZ-mods\` · `juegos db tk3\` | `Juegos\Mods\Dragon Ball\` |
| `vscode\` — TPs de la escuela técnica | `Mis Documentos\EESTN1\vscode\` → desde el 2026-09-29, `03 - Docencia\EEST N1\vscode\` |
| `TP Cohete de Agua\` | `Mis Documentos\SistemasEspaciales\Programacion\` → desde el 2026-09-29, `01 - UNSAM\Software de Vuelo\TP Cohete de Agua (Petrilli)\` |
| los `REVERTIR-*.ps1` de la MSI, **sueltos y sin versionar** | `proyectos/ingenieria/diagnostico-msi/optimizacion/` |

La última fila es la que importa: esos scripts son lo único que deshace los
cambios de undervolt y arranque sobre la máquina, y vivían en una carpeta
llamada «Programas y juegos». Si se borraban, los cambios quedaban sin vuelta
atrás.

`PlanosGasista\` (hoy `04 - Terceros\Planos gasista\`) es material de trabajo
sin proyecto asociado. Si algún día se trabaja sobre eso con Claude, entra
como proyecto en `proyectos/documentos/`.

**El Escritorio NO está en OneDrive, y está medido**: la clave
`HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders`
tiene `Desktop = C:\Users\frans\Desktop`. Lo que hay en `OneDrive\Desktop\`
(29 items) es una **copia vieja abandonada** —tiene un `Programas\` que ya no
existe y accesos a juegos que no están en el Escritorio real— y no se
sincroniza con nada.

## 1.bis `claude-acceso` es PÚBLICO

Verificado el 2026-08-27: `api.github.com/repos/fransalomone21/claude-acceso`
responde **200 sin autenticar**. `perfil-global` responde 404, o sea privado.

**Consecuencia, y es la que ordena la tabla de abajo:** nada personal se
commitea en `claude-acceso`. Datos de salud, físicos, de alimentación,
seriales de equipos o informes de dispositivos van a un repo propio, privado o
sin remote. No es una preferencia: es la diferencia entre un dato privado y un
dato publicado.

## 2. Quién es dueño de qué

| Carpeta | Repo dueño | Se pushea a |
|---|---|---|
| `claude-acceso/` (todo salvo lo de abajo) | `claude-acceso` | `github.com/fransalomone21/claude-acceso` |
| `perfil-global/` | `perfil-global` | `github.com/fransalomone21/perfil-global` |
| `proyectos/seguimiento/coaching/` | `coaching` (local) | GitHub **privado** — falta crear el remote |
| `proyectos/seguimiento/haberes-docentes/` | `haberes-docentes` (local) | **a ningún lado** — CBU, CUIL y datos de haberes |
| `proyectos/documentos/clases-aed/` | `clases-aed` (local) | **a ningún lado** — lleva nombre y mail de una alumna particular |
| `proyectos/documentos/teoria-circuitos/` | `teoria-circuitos` (local) | **a ningún lado** — la carátula de los informes lleva nombre y correo de dos compañeros, que la guía de la materia exige ahí |
| `proyectos/documentos/catedras/` | `catedras` (local) | **a ningún lado** — lo que pide cada profesor, textual; Fran decidió el 2026-09-28 que los criterios son locales y lo público es sólo lo pactado |
| `proyectos/documentos/cohete-de-agua/` | `cohete-de-agua` (local) | **a ningún lado** — trabajo en grupo con los apellidos de los compañeros; lo compartido va por la carpeta de Drive del grupo |

**La regla que sostiene esta tabla: un archivo, un repo dueño.** Si una carpeta
tiene su propio `.git`, `claude-acceso` la ignora en el mismo turno en que
aparece.

**Esta tabla la chequea una máquina**, no la buena memoria de nadie:
`verificar-estructura.ps1` descubre en el disco qué carpetas tienen `.git`
propio y falla si alguna no figura acá, o si figura y no está en `.gitignore`.
Se rompió a propósito para comprobar que discrimina (`probar-verificador.ps1`,
caso 3c). Antes del 2026-08-28 la tabla era prosa y el `CLAUDE.md` declaraba
dos repos cuando el disco ya tenía tres.

## 3. Lo que NO se versiona, y por qué

| Ruta | Motivo |
|---|---|
| `telefono-samsung/informes/` | apps instaladas, serial y cuentas del teléfono |
| `diagnostico-msi/datos-crudos/` | serial de BIOS, variables UEFI, 600 KB de eventos. El `INFORME.md` destilado sí se versiona |
| `black/volcados/`, `black/construido/` | archivos de 32 MB. Si uno documenta un hallazgo: `git add -f` y explicarlo en la bitácora |
| `perfil-global/pilares/_pp*.txt`, `_tis.txt` | 2 MB de texto crudo de PDF. Valen las fichas `.md` de al lado |

## 4. Qué había antes, y por qué se cambió

El estado anterior era **un repo con un proyecto por rama**. Se cambió porque
su conducta observada, no su intención, era ésta:

- **3 de 7 proyectos habían quedado fuera de la regla** — `caso-tio` y
  `diagnostico-msi` sin versionar, `PROYECTO TELESCOPIO` fuera del repo. Eso no
  es indisciplina: es la señal de que la regla era impracticable. Una regla que
  se elude no se escribe más fuerte, se cambia.
- **`perfil-global` no existía en las ramas donde no se había creado**, así que
  el método no estaba disponible justo donde estaba el proyecto.
- **El `ESTADO_ACTUAL.md` de BLACK visible desde la rama del apunte declaraba
  "fase 5 — siguiente"** cuando el proyecto real iba por la **7e**, 34 commits
  adelante en otra rama. Seguir BLACK desde la rama equivocada habría rehecho
  tres fases ya confirmadas por efecto.
- **`perfil-global` estaba clonado adentro de `claude-acceso` y además tracked
  por él**: dos historias sobre los mismos archivos. Divergieron de verdad —
  37 lecciones en común, 23 en un repo, 4 en el otro, ninguna copia con las 64.
  `~/.claude/aprendizaje/origen.txt` apuntaba a una tercera copia **sin `.git`**,
  así que toda lección registrada caía en un directorio que nadie commiteaba.
  La máquina terminó corriendo el `CLAUDE.md` viejo de 6 reglas y el cuadro de
  fase sin la línea Esfuerzo, durante días, sin que nada avisara.

Las dos lecciones de proceso que salieron de esto están en el registro
(`aprender.py digesto`, 2026-08-27) y son las que sostienen las reglas 1 y 2
del enrutador.

## 5. Decisiones de estructura, y lo que perdió

| Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|
| Un repo, proyectos en carpetas | un repo por proyecto | obliga a elegir repo en cada sesión — el problema que se estaba resolviendo |
| | proyectos por rama | es el estado anterior: produjo todo lo del punto 4 |
| `perfil-global` clonado e **ignorado** | submodule | fricción real en cada sesión (`submodule update`, "new commits" en el status) por una garantía que acá no hace falta |
| | copiado adentro | es exactamente lo que causó la divergencia |
| Naturalezas: `ingenieria` / `documentos` / `seguimiento` | por tema (juegos, salud, facultad…) | el tema no cambia **qué se lee ni con cuánto rigor**; la naturaleza sí. La categoría existe para decidir el nivel 3, no para clasificar |
| La **sensibilidad** es un eje aparte de la naturaleza (2026-08-28) | una naturaleza nueva, `documentos-con-terceros` | un informe con mails de compañeros se **produce** igual que cualquier documento: mismo nivel 3, mismo rigor, mismas trampas. Lo que cambia es **dónde puede vivir el archivo**. Meterlo en la naturaleza habría duplicado `documentos.md` entero para cambiar una decisión de repo dueño |
| | dejarlo como carpeta ignorada | deja el trabajo **sin memoria**, y la fuente Typst vale versionarla — el próximo informe la reusa. Perder y publicar son las dos fallas, y la fila del medio de la tabla es la que las evita |
| `caso-tio` en repo propio, sin remote | dentro de `claude-acceso` | datos de salud de un familiar en un repo con push configurado |

## 6. Pendientes conocidos de la estructura

1. ~~**Lecciones sin foldear** en `chequeo-de-trabajo.md`.~~
   **RESUELTO (2026-08-28), y el chequeo que lo vigilaba estaba mal.**
   Comparaba dos totales —"dice 45 y hay 76"— y su único arreglo posible era
   subir el número, o sea apagar la alarma sin foldear nada. La regla que el
   chequeo intentaba vigilar ya estaba escrita en el encabezado del propio
   archivo (línea propia / foldeada / fuera de dominio) pero **esa decisión no
   se guardaba en ningún lado**, así que el total era el único proxy posible.
   Se intentó reconstruirla midiendo el solape textual entre cada regla y el
   chequeo: dio **7 de 76**, no 45 — el chequeo es síntesis reescrita, no
   copia, así que el foldeo es semántico y ninguna medición retroactiva lo
   recupera. El 45 no era un número atrasado: era uno que nunca se midió.
   Hoy `triage` es un campo obligatorio del registro, `install.ps1` cuenta las
   **sin triage** (no los totales) y **prohíbe** que el número vuelva a
   escribirse a mano. Las 76 quedaron triageadas: 49 foldeadas, 17 fuera, y 10
   que faltaban de verdad y se escribieron. Probado rompiéndolo:
   `perfil-global\probar-chequeo-lecciones.ps1`, 5 frenos en rojo.
2. **La rama `rescate/disco-20260827`** de `perfil-global` guarda el estado del
   disco previo a la reconciliación. Tiene ~115 renglones propios que no se
   auditaron uno por uno. No se borra hasta revisarlos.
3. ~~**`verify-install.ps1` verifica presencia y efecto, no contenido.**~~
   **RESUELTO (2026-08-28).** Compara el **hash SHA256** de cada archivo
   instalado contra el del repo, usando `perfil-global/manifiesto.ps1` — la
   misma lista que usa `install.ps1` para copiar, así que las dos puntas no
   pueden discrepar. Probado con el escenario exacto que antes daba verde: se
   modificó la copia instalada y el verificador se puso en rojo nombrando el
   archivo.
4. ~~**`~/.claude/` tenía decenas de `.bak-*` sueltos en la raíz.**~~
   **RESUELTO (2026-08-28).** Eran 91. `install.ps1` los muda a `backups/` y
   poda los de `CLAUDE.md` dejando los 10 últimos —su historia completa está
   en git—. Los de `settings.json` **no se borran**: ese archivo no vive en
   ningún repo. Era una canilla abierta sin desagüe.

## 7. El enrutador hasta el 2026-10-02: el porqué de cada regla, como estaba escrito

T12 de `arquitectura-se` (simplificar) dejó el `CLAUDE.md` raíz como vista corta: medido, era el **43 %** de lo que paga cada sesión al abrir (54 602 caracteres) y cada fila narraba la historia de su proyecto, que ya vive en su `ESTADO_ACTUAL`. Las reglas siguen allá en su enunciado; acá queda, **sin tocar**, el texto que explicaba de qué incidente salió cada una, para leerlo una vez y no en cada sesión. Las filas largas de los proyectos no se copian (son espejo de cada `ESTADO_ACTUAL`): están en git, `git show 0ca02c4:CLAUDE.md`.

### La cascada — se lee de arriba hacia abajo, y se para apenas alcanza

| Nivel | Qué | Dónde | Cuándo se lee |
|---|---|---|---|
| 0 | fundamentos (Meadows, Hunt & Thomas) | `pilares.md` | **solo**, por hook |
| 1 | las reglas del método | `~/.claude/CLAUDE.md` + skills | **solo**, cada sesión |
| 2 | **este archivo: qué proyectos hay y dónde** | acá | **solo**, cada sesión |
| 3 | qué se lee siempre en esta clase de proyecto | `plantillas/naturalezas/<nat>.md` | al entrar a un proyecto |
| 4 | el contrato del proyecto: índice de qué leer según la tarea | `<proyecto>/CLAUDE.md` (se carga solo si abrís ahí) | al entrar a un proyecto |
| 5 | dónde quedamos | `<proyecto>/ESTADO_ACTUAL.md` + `HANDOFF.md` | al retomar |
| 6 | el detalle que la tarea concreta pida | lo que el nivel 4 mande | sólo si hace falta |

Los niveles 0-2 llegan solos y no cuestan decisión. Del 3 al 6 se baja **sólo
hasta donde la tarea necesite**: cada nivel cuesta contexto, y el contexto es
lo que después falta para pensar el problema difícil.

**Esa tabla dice qué clase de archivo va en cada nivel; no dice cuál es el
archivo del proyecto que estás por abrir.** Esa traducción la hacía la sesión,
de memoria, cada vez — y lo que depende de que alguien lo recuerde no es una
regla, es una intención. Ahora la emite un comando:

```powershell
.\cascada.ps1                   # los proyectos que hay en el disco
.\cascada.ps1 <proyecto>        # los archivos a leer, en orden, con rutas exactas
```

**Y desde el 2026-10-02 no es un consejo: es una puerta.** Medido: de 113
entradas a un proyecto desde el 1/9, **una** leyó ESTADO, HANDOFF, PDP y
contrato antes de actuar. Ahora `.claude/hooks/cascada_puerta.py` **no deja
editar ni correr nada sobre un proyecto** hasta que la sesión declara la
necesidad de Fran y lee con Read lo que el catálogo exige:

```powershell
.\cascada.ps1 <proyecto> -Necesidad materia,publicar   # declara e imprime lo exigido, con rangos
.\cascada.ps1 <proyecto> -Excepcion "motivo"           # la salida explicita, queda registrada
```

Qué se lee para qué necesidad (`materia`, `ingenieria-inversa`, `diseno`,
`metodo`, `investigar`, `publicar`) y para qué concepto (`typst`, `freno`,
`pcsx2`) vive en **un solo lugar**, `.claude/cascada.json`. Diseño y
validación: `proyectos/ingenieria/arquitectura-se/docs/t11-cascada-obligatoria.md`.

`cascada.ps1` **no tiene ninguna lista propia**: deriva todo del disco, de la
carpeta de naturaleza y del contrato del proyecto. Una segunda lista sería
exactamente el problema que existe para no crear. Y de paso imprime **juntas**
las dos fuentes que ya se contradijeron una vez —la fila del enrutador y el
encabezado del `ESTADO_ACTUAL` del proyecto— para que la divergencia se vea en
el momento en que importa. Si no coinciden, **manda el proyecto** (regla 4).

---

> **`claude-acceso` es un repositorio PÚBLICO.** Nada personal —datos de
> salud, físicos, de alimentación, seriales, informes de dispositivos— se
> commitea acá. Para eso están las carpetas ignoradas de la tabla de arriba,
> que tienen su propio repo. `perfil-global` sí es privado.

### Las cuatro reglas de la estructura

1. **Un proyecto, una carpeta.** Nunca una rama. Las ramas se usan para
   trabajo en curso que todavía no se integra, no para separar proyectos: eso
   ya se probó y produjo un `ESTADO_ACTUAL.md` que declaraba la fase 5 cuando
   el proyecto iba por la 7e.

2. **Un archivo, un repo dueño.** Si una carpeta tiene su propio `.git`, este
   repo la pone en `.gitignore` en el mismo turno, y `git ls-files <carpeta>`
   tiene que dar **0**. *Cuáles son hoy no se escribe acá*: se mide con
   `.\verificar-estructura.ps1`, que las descubre en el disco. Esta línea
   enumeraba dos cuando ya eran tres, y nadie se enteró durante un mes — un
   dato que vive en dos lados diverge, y la lista vive en el disco.

   **Y cuál repo lo decide la sensibilidad, que es un eje aparte de la
   naturaleza.** La naturaleza dice *qué se lee y con cuánto rigor* (nivel 3);
   la sensibilidad dice *dónde puede vivir el archivo*. Son independientes: un
   informe con mails de terceros se **produce** igual que cualquier otro
   documento —mismo `documentos.md`, mismo `/pdf-con-codigo`— pero no puede
   publicarse. Por eso no se inventa una naturaleza para eso; se elige destino:

   | Sensibilidad | Destino | Ejemplos |
   |---|---|---|
   | pública | `claude-acceso` | casi todo |
   | personal, **y vale recordarla** | **repo propio**, ignorado acá, remote privado o ninguno | `coaching`, `teoria-circuitos`, `catedras` |
   | personal, y **no** vale recordarla | carpeta ignorada acá | `telefono-samsung/informes/`, `diagnostico-msi/datos-crudos/` |

   La fila del medio es la que faltaba y la que se elude sola, porque cuesta
   un `git init` más. Elegir mal para abajo **pierde el trabajo** (nada existe
   si no está commiteado); elegir mal para arriba **lo publica**. Las dos
   fallas son silenciosas, así que hay una que las mide: la **regla 5** de
   `verificar-estructura.ps1` busca mails y teléfonos en lo que este repo
   trackea. Lo que sea legítimo se declara en `.claude/datos-permitidos.json`
   — declarar una excepción es un acto, no un silencio.

3. **Todo proyecto nuevo nace de un PDP, y nace acá adentro.** `plantillas/PDP.md`
   — Plan de Desarrollo de Proyecto; el contrato sale de
   `plantillas/proyecto-CLAUDE.md`. Sin PDP no hay carpeta: es lo que define
   las fases y, sobre todo, el **criterio de salida** de cada una *antes* de
   empezarla.

   **Esta regla se incumplió el 2026-08-28 y nada lo notó.** Un informe de
   Teoría de Circuitos se trabajó una sesión entera en
   `Desktop\Informe TC - Thevenin y Norton\`: sin PDP, sin contrato, sin bajar
   al nivel 3 de la cascada, y sin que ninguna de las cuatro reglas dijera una
   palabra. No podían: **las cuatro miran adentro de `proyectos/`**, y un
   proyecto que nace en el Escritorio es invisible por construcción.

   Una regla que se incumple no se escribe más fuerte — se le agrega el flujo
   de información que falta (`pilares.md`, Meadows). Los dos que se agregaron:

   - **El censo del Escritorio** (regla 6 de `verificar-estructura.ps1`):
     nombra toda carpeta del Desktop que parezca proyecto y no esté en el
     sistema. Lo que legítimamente no es un proyecto se declara en
     `.claude/fuera-del-sistema.txt`. El medidor deja de estar en el sótano.
   - **`.\nuevo-proyecto.ps1`**: crea carpeta, PDP, contrato, `ESTADO_ACTUAL`
     y `HANDOFF` en un comando, y avisa de agregarlo al enrutador. Mientras
     hacerlo bien costó seis pasos y hacerlo mal costó un `mkdir`, la regla
     iba a seguir perdiendo — y eso no es indisciplina, es la misma señal de
     impracticabilidad que ya archivó el esquema de un proyecto por rama.

4. **Lo que este archivo dice se verifica antes de repetirlo.** Un documento
   no se entera de que alguien lo cambió. Si una fila de las tablas de arriba
   contradice al `ESTADO_ACTUAL.md` del proyecto, **gana el proyecto** y esta
   tabla se corrige en el mismo turno.

**Las cuatro son ejecutables desde el 2026-08-28.** Antes, la única con un
chequeo era la 2; las otras tres las sostenía que alguien se acordara, y una
regla que nadie mide se corre sola:

```powershell
.\verificar-estructura.ps1      # las cuatro reglas, contra el disco
.\probar-verificador.ps1        # rompe cada una y exige ver el rojo
.\nuevo-proyecto.ps1 <nombre>   # el camino correcto, en un comando
```

`verificar-estructura.ps1` mide las cuatro reglas en **siete** bloques. Los
tres últimos son mitades que faltaban, y las tres son la misma clase de
ceguera: *un verificador sólo ve donde vive.*

| bloque | mira | qué agujero tapa |
|---|---|---|
| 5 | lo que este repo **publica** | que la regla 2 haya elegido bien el destino |
| 6 | lo que este repo **no ve** (el Escritorio) | que la regla 3 se haya aplicado |
| 7 | lo que cada **contrato** enlaza | que la cascada no se corte en el nivel 6 |

La 5 y la 6 se descubrieron el mismo día, las dos por el mismo informe: un
chequeo que sólo se pregunta por lo que ya está adentro no puede atrapar lo
que nunca entró. La 7 es la de abajo — la regla 3b ya exigía que los enlaces
del **enrutador** resolvieran, pero nadie miraba los de cada contrato, que es
justo donde una sesión que ya bajó al nivel 4 sigue el puntero y cae en la
nada.

El segundo es el que hace que el primero valga algo. Un chequeo que nunca
falló está sin verificar.

### Los frenos — lo que ya no depende de que alguien se acuerde

Desde el **2026-08-28** hay tres capas ejecutables, instaladas y probadas por
`bootstrap.ps1`:

| capa | qué es | contra qué |
|---|---|---|
| 1 | atributo `ReadOnly` sobre los archivos de `.claude/protegidos.json` | lo frena **el sistema operativo**, incluso fuera de una sesión |
| 2 | hook `PreToolUse` (`.claude/hooks/guardia-iso.ps1`) | alarma temprana que **explica**; falla **cerrado** |
| 3 | integridad medida en `abrir-sesion.ps1` de cada proyecto | mide el **efecto** sobre el objeto: no tiene agujeros |

Y un hook `SessionStart` emite `.claude/arranque.md`: las autorizaciones
permanentes y el comando de apertura de cada proyecto, que vivían en archivos
que **no se leen solos** y por eso se olvidaban cada sesión.

**Desde el 2026-08-29 ese hook además MIDE.** Emitir el texto decía que
existían siete verificadores; correrlos seguía dependiendo de que alguien se
acordara, y lo único que informaba del estado real era el `HANDOFF` que dejó
la sesión anterior — un archivo escrito por otra sesión, que no se entera de
nada que pase después de escribirse. El hook corre ahora la **capa rápida** de
`chequeo-completo.ps1` y mete el resultado en la sesión, medido:

```powershell
.\chequeo-completo.ps1                  # las dos capas (~110 s)
.\chequeo-completo.ps1 -SoloMedidores   # la rapida (~7 s) -- la que corre el hook
```

| capa | qué | cuándo corre |
|---|---|---|
| **medidores** (7 s) | `verificar-estructura` + `verify-install` + `aprender.py sin-triage` | **sola, en cada arranque** |
| **saboteadores** (96 s) | los cuatro `probar-*.ps1`: rompen cada alarma y exigen el rojo | a mano; el hook **avisa** si pasaron más de 7 días |
| **limpieza** | los medidores otra vez, *después* de sabotear | con los saboteadores |

La tercera fila no estaba prevista y salió de una falla real del mismo día:
`probar-chequeo-lecciones.ps1` restauraba el archivo **fuente** y dejaba la
copia **instalada** en `~/.claude` con el sabotaje adentro — y su control
positivo daba verde porque miraba el repo, no el efecto. Es exactamente la
ceguera que los saboteadores existen para atrapar, del lado de adentro. Ahora
lo mide un segundo pase, y la clase entera de suciedad se ve, no sólo la que
ya conocemos.

```powershell
.\probar-hooks.ps1              # cada freno en rojo, y los controles positivos
.\.claude\desinstalar-hooks.ps1 # lo que se instala solo, se desinstala solo
```

**Si un comando legítimo queda bloqueado, el guardia no se saca**: se corrige
el patrón y se vuelve a correr `probar-hooks.ps1`, que exige ver el rojo *y*
que lo legítimo siga pasando. La segunda mitad no es decorativa — el guardia
bloqueó mal su primer comando real porque `\bdel\b` matcheaba el "DEL" de una
frase en español.

---

### Los apuntes que ven los compañeros — Drive

La carpeta es
[esta](https://drive.google.com/drive/folders/1Uz_4Lu4i1LX7xbeS-dDVEF-TXi6EA1mL)
y adentro va **una carpeta por materia** con el PDF del apunte. Se sube con
`rclone` contra el remote `drive-apuntes`; el token vive en
`~/.config/rclone/rclone.conf` —medido, **no** en `%APPDATA%`—, **fuera
del repo**, y por eso este archivo puede nombrar la carpeta sin publicar
nada. Esa ruta es la que pasa `publicar-apuntes.ps1`, y es la fuente: un
`rclone` invocado a mano con otra ruta corta con «empty token found -
please run config reconnect», que se lee como token vencido y no lo es.
Ya costó una vez; esta línea decía `%APPDATA%` y por eso costó una
segunda. **Si hay un script propio que envuelve la herramienta, se lee
el script antes de invocar la herramienta cruda.**

```powershell
.\publicar-apuntes.ps1             # sube lo que cambio
.\publicar-apuntes.ps1 -Verificar  # solo mide, no sube. Es lo que corre en cada arranque
.\probar-publicacion.ps1           # rompe el publicador y exige verlo en rojo
```

Los dos scripts pasan `--config` con la ruta completa **a propósito**: un
archivo resuelto por una variable de entorno no es una ruta, es una función
del entorno, y
ya pasó que una consola dijera «not found» sobre el mismo archivo que otra
ventana de la misma máquina listaba sin problema.

**Qué se publica es una lista, no una regla implícita.** Vive en
`.claude/apuntes-publicos.json` y es *deny-by-default*: un PDF no se publica
por estar en el repo, se publica por estar declarado. Lo que parece apunte y
no está en la lista sale reportado como **«sin declarar»** — ni se sube ni se
ignora en silencio, que es la misma forma de la regla 5 de
`verificar-estructura.ps1` y de `.claude/datos-permitidos.json`. Eso es lo que
hace que un apunte **nuevo** entre al circuito sin que nadie se acuerde de
nada: aparece solo, en rojo, el día que se compila por primera vez.

**Lo declarado público se sube ni bien se tiene o se modifica** (Fran,
2026-09-29): no se espera un visto bueno por cada versión. Lo hace el hook
`post-commit`, que desde ese día dispara con **cualquier PDF de la lista**, no
sólo con `apunte/apunte.pdf` — antes, la guía de IDEs y tres PDFs de Física
Espacial cambiaban sin que nada los subiera. **Ojo con el agujero que queda:**
el detector de «sin declarar» sigue mirando sólo `apunte.pdf`, así que un
entregable público con otro nombre entra al circuito **sólo si alguien lo
declara**.

**Sólo apuntes.** Los informes de cátedra no van: la carátula lleva mails de
compañeros y viven en un repo aparte. El material de `seguimiento/` tampoco.
Las dos exclusiones están escritas en el JSON, con el motivo al lado.

> **Corregido el 2026-09-22, y la corrección importa más que la línea.** Esto
> decía que el material de `seguimiento/` «no sale nunca de su repo», y el
> 22/09 la rutina del coaching **sí** salió a Drive — a pedido de Fran. La
> regla estaba escrita sobre el destino equivocado: el freno nunca fue contra
> Drive, fue contra **este remote**, `drive-apuntes`, cuya carpeta es
> **pública por link y hereda el permiso**. Lo que rige es el eje de
> sensibilidad de la regla 2 de la estructura, aplicado a Drive:
>
> | remote | apunta a | qué puede ir |
> |---|---|---|
> | `drive-apuntes` | la carpeta de los compañeros — **pública por link** | sólo lo declarado en `apuntes-publicos.json` |
> | `drive-personal` | la raíz de Mi unidad — **privada** | el espejo del coaching (`Coaching/`), verificado por permisos: un solo `owner` y ningún `anyone` |
>
> Los dos remotes usan el mismo token y se distinguen **sólo** por el
> `root_folder_id`: `drive-apuntes` lo tiene y `drive-personal` no. Una regla
> que quedó falsa no se obedece a medias — se deja de obedecer en todos
> lados, y por eso se reescribe el mismo día en que deja de ser cierta.

**Lo publicado se compara por MD5, no por fecha.** La fecha del lado de Drive
no es la del archivo local —depende de cómo se subió—, así que comparar fechas
da rojos falsos (molestos pero inocuos) y, cuando además coincide el tamaño,
**verdes falsos, que son silenciosos**. El hash lo da `rclone lsjson --hash`
gratis. Esto salió de auditar un verde que no se podía explicar: el apunte de
Electrónica figuraba «al día» con una fecha que no tenía por qué coincidir.
Coincidía de verdad —el MD5 lo confirmó—, pero el chequeo que lo había dicho
no era el que podía decirlo.

**El que mide es el arranque**, no la memoria: `publicar-apuntes.ps1
-Verificar` es uno de los medidores de `chequeo-completo.ps1`, así que cada
sesión abre diciendo si el Drive quedó atrasado. Un apunte que se toca y no se
sube es exactamente la falla que no duele el mismo día.

> **Aviso con fecha:** rclone usa hoy su `client_id` compartido de Google, que
> **se retira durante 2026** — el propio rclone lo avisa en cada corrida.
> Cuando deje de andar, el arreglo es crear un `client_id` propio
> (https://rclone.org/drive/#making-your-own-client-id) y agregarlo al remote.
> No es urgente hasta que el medidor se ponga en rojo por eso.

---

### Mi unidad — el orden, y por qué se mide

Ordenada el **2026-09-22**. La raíz son **seis carpetas y un LEEME**, y el
número no ordena por tema sino por **quién puede verlo**: `00 - PERSONAL`
(nadie), `01 - UNSAM` (adentro conviven los tres niveles, cada uno dicho en su
propio nombre), `02 - ARCHIVO`, `Coaching` y `Classroom` (las escriben scripts
o Google: **no se tocan a mano**), y `_REVISAR`. Cuál es cuál no se escribe
acá: vive en `.claude/estructura-drive.json`, que es la fuente.

```powershell
.\verificar-drive.ps1              # las tres reglas, contra Drive. ~5 s
.\verificar-drive.ps1 -Rapido      # solo la raiz, sin pedir permisos. ~2 s
.\probar-verificar-drive.ps1       # rompe las cinco y exige ver el rojo
```

**Lo que lo hizo falta.** El 22/09 se midió que los **dos `.docx` de los
informes del grupo** —los que llevan los mails de Santiago y Valentina en la
carátula— estaban con `anyone:reader`, o sea **públicos por link**, viviendo en
una carpeta privada. El 15/09 se los había mudado afuera de la carpeta pública
y este archivo lo registró como hecho: *«las del grupo se mudaron afuera»*.
Era cierto, y aun así estuvieron públicos **25 días**.

**Mudar un archivo no lo despublica: el permiso viaja con el objeto.** Se
verificó la **precondición** —dónde está el archivo— en lugar del **efecto**
—qué permiso tiene. Es la regla 3 del perfil, del lado que no duele: nadie
revisa un cambio que ya salió bien.

Por eso `verificar-drive.ps1` mide permisos y no rutas, y por eso su regla
dura no admite lista de perdón: **nada con `anyone` fuera de la carpeta
pública declarada**. Si algo tiene que ser público, se **mueve adentro**; no se
declara una excepción afuera. Lo compartido con personas concretas no es rojo
—compartir no es publicar— pero se declara en el JSON con su motivo, y lo que
aparezca sin declarar sale en amarillo, que es la misma forma que
`apuntes-publicos.json` y `datos-permitidos.json`.

**Y no se solapa con el publicador.** `publicar-apuntes.ps1 -Verificar` mira el
**repo** y contesta si lo que está acá llegó a Drive; por eso no podía ver esos
dos informes, que no están declarados en ningún lado. *Un verificador sólo ve
donde vive* — es el mismo agujero que taparon los bloques 5, 6 y 7 de
`verificar-estructura.ps1`, ahora del lado de Drive.

De paso, la raíz tenía **13 archivos sueltos** (DNI, partida, analítico, DDJJ)
y `SOLO FRAN - no se comparte con nadie/` estaba **vacía**: el contenedor
privado se había creado y nunca se había usado. Nada se borró para ordenar —
lo que no tenía dueño claro está en `_REVISAR`, que se puede auditar.

---
