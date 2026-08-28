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
│   ├── verificar-estructura.ps1      las 4 reglas, en 6 bloques, contra el disco
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
│   │   │   └── teoria-circuitos\     ← REPO PROPIO · ignorado acá · NO se pushea
│   │   └── seguimiento\
│   │       └── caso-tio\             ← REPO PROPIO · ignorado acá · NO se pushea
│   │       └── coaching\             ← REPO PROPIO PRIVADO · ignorado acá
│   │
│   └── archivo\
│       └── RAMAS.md                  qué quedó en las ramas viejas
│
└── (fuera del sistema, no son proyectos de Claude)
    fotos\ · Mis Documentos\ · PlanosGasista\ · Programas\ ·
    Programas y juegos\ · vscode\
```

`PlanosGasista\` es material de trabajo sin proyecto asociado. Si algún día se
trabaja sobre eso con Claude, entra como proyecto en `proyectos/documentos/`.

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
| `proyectos/seguimiento/caso-tio/` | `caso-tio` (local) | **a ningún lado** — datos de salud de un familiar |
| `proyectos/seguimiento/coaching/` | `coaching` (local) | GitHub **privado** — falta crear el remote |
| `proyectos/documentos/teoria-circuitos/` | `teoria-circuitos` (local) | **a ningún lado** — la carátula de los informes lleva nombre y correo de dos compañeros, que la guía de la materia exige ahí |

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
