# claude-acceso — el punto de entrada

**Toda sesión de Claude Code empieza acá.** No hay que elegir repositorio ni
rama: hay una sola rama (`main`) y un solo árbol. Se abre esta carpeta, se
dice con qué proyecto se sigue, y la cascada de abajo hace el resto.

Este archivo es el **enrutador**. No explica cómo se trabaja (eso es el perfil
global, que se carga solo) ni qué pasa en cada proyecto (eso es el
`CLAUDE.md` de cada proyecto). Sólo dice **a dónde ir**.

---

## La cascada — se lee de arriba hacia abajo, y se para apenas alcanza

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

`cascada.ps1` **no tiene ninguna lista propia**: deriva todo del disco, de la
carpeta de naturaleza y del contrato del proyecto. Una segunda lista sería
exactamente el problema que existe para no crear. Y de paso imprime **juntas**
las dos fuentes que ya se contradijeron una vez —la fila del enrutador y el
encabezado del `ESTADO_ACTUAL` del proyecto— para que la divergencia se vea en
el momento en que importa. Si no coinciden, **manda el proyecto** (regla 4).

---

## Los proyectos

Cada proyecto es **una carpeta**, no una rama. La naturaleza decide qué se lee
siempre (nivel 3) y con cuánto rigor se trabaja.

### `proyectos/ingenieria/` — sistemas técnicos: hipótesis, evidencia, efecto

| Proyecto | Qué es | Estado |
|---|---|---|
| [`black/`](proyectos/ingenieria/black/CLAUDE.md) | Ingeniería reversa de **BLACK** (PS2) sobre PCSX2 | **ACTIVO** — fase 7e abierta |
| [`diagnostico-msi/`](proyectos/ingenieria/diagnostico-msi/) | Secure Boot y batería de la notebook MSI | cerrado con informe |
| [`telescopio/`](proyectos/ingenieria/telescopio/) | Plataforma ecuatorial Dobson, CAD SolidWorks | dormido |
| [`telefono-samsung/`](proyectos/ingenieria/telefono-samsung/) | Kit de diagnóstico y limpieza vía ADB | suspendido (2026-08-15) |

### `proyectos/documentos/` — producir un artefacto de contenido

| Proyecto | Qué es | Estado |
|---|---|---|
| [`electronica-analogica/`](proyectos/documentos/electronica-analogica/) | Apunte de Electrónica Analógica 4.º en Typst, 123 pág. | **ACTIVO** |
| [`fisica-espacial/`](proyectos/documentos/fisica-espacial/CLAUDE.md) | Apunte general de Física Espacial (UNSAM, Ing. en Sistemas Espaciales) en Typst | **ACTIVO** — fase 1 |
| [`repaso-iise/`](proyectos/documentos/repaso-iise/) | Repaso oral de IISE: guion + audios | terminado |
| `teoria-circuitos/` | Informes de laboratorio en Typst. El 1 (Thévenin y Norton) entregado; Pre-Lab de amplificadores operacionales abierto | **ACTIVO** — **repo aparte**: la carátula lleva mails de compañeros |

### `proyectos/seguimiento/` — datos longitudinales de la vida real

| Proyecto | Qué es | Estado |
|---|---|---|
| `caso-tio/` | Caso clínico familiar → guía para la familia | vivo, **repo aparte, no se pushea acá** |
| [`coaching/`](proyectos/seguimiento/coaching/CLAUDE.md) | Entrenamiento y dieta: músculo y fuerza | **ACTIVO** — fase 0 (línea base) abierta hasta el 2026-09-12. **Repo aparte**, privado y con remote desde el 2026-08-28 |

---

> **`claude-acceso` es un repositorio PÚBLICO.** Nada personal —datos de
> salud, físicos, de alimentación, seriales, informes de dispositivos— se
> commitea acá. Para eso están las carpetas ignoradas de la tabla de arriba,
> que tienen su propio repo. `perfil-global` sí es privado.

## Las cuatro reglas de la estructura

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
   | personal, **y vale recordarla** | **repo propio**, ignorado acá, remote privado o ninguno | `caso-tio`, `coaching`, `teoria-circuitos` |
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

## Los frenos — lo que ya no depende de que alguien se acuerde

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

## Dónde está el resto

- **Cómo se trabaja** (evidencia, modelo, esfuerzo, cierre de sesión):
  `perfil-global/` — repo propio, se instala con `perfil-global\install.ps1`.
- **El inventario completo del sistema**, con el porqué de cada decisión de
  estructura: [`MAPA.md`](MAPA.md). Se lee una vez, no cada sesión.
- **Máquina nueva, o falta alguna carpeta ignorada**: `.\bootstrap.ps1` —
  clona el perfil, lo instala, lo verifica y corre `verificar-estructura.ps1`.
- **¿Qué leo para entrar a un proyecto?**: `.\cascada.ps1 <proyecto>` — el
  flujo de los seis niveles, con rutas exactas y medido contra el disco.
- **¿La estructura sigue sana?**: `.\verificar-estructura.ps1`. Y para probar
  que ese chequeo no está ciego: `.\probar-verificador.ps1`.
- **¿El fan-out no se decide solo?**: es el guardia de nivel 4 del perfil
  (`perfil-global/hooks/guardia-fanout.ps1`), que intercepta `Workflow` y
  `Agent` y **pregunta**. Para probar que no está ciego:
  `perfil-global\probar-guardia-fanout.ps1`.
- **Proyecto nuevo** (o adoptar uno que nació suelto en el Escritorio):
  `.\nuevo-proyecto.ps1 <nombre> -Naturaleza <nat> [-Desde <ruta>] [-Sensible]`.
- **¿Las lecciones llegan a alguna sesión?**:
  `python perfil-global\herramientas\aprender.py sin-triage`, y para probar que
  ese chequeo tampoco está ciego: `perfil-global\probar-chequeo-lecciones.ps1`.
- **Las ramas viejas** y qué quedó en cada una: [`archivo/RAMAS.md`](archivo/RAMAS.md).
