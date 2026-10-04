# claude-acceso — el punto de entrada

**Toda sesión de Claude Code empieza acá.** Una sola rama (`main`), un solo
árbol: se abre esta carpeta, se dice con qué proyecto se sigue y la cascada
hace el resto.

> **EL LIBRO PRIMERO (regla 16 del perfil).** Ninguna sesión trabaja sin el
> perfil de Fran cargado. En la PC lo carga el arranque; **en la nube o en
> otra máquina no llega solo**, y sin él no hay reglas ni lecciones: el
> arquitecto sin su libro deja de ser arquitecto. Si `~/.claude/CLAUDE.md` no
> empieza con «# Perfil global», el **primer comando** de la sesión, antes de
> leer cualquier otra cosa, es:
>
> ```bash
> bash .claude/nube/traer-perfil.sh
> ```
>
> Rojo: hacer lo que dice (`add_repo` de `fransalomone21/perfil-global` y
> clonarlo) y volver a correrlo. Verde: leer **enteros** los archivos que
> lista, y recién ahí la tarea. Un retome que diga «el perfil no está, no
> pelear» se mide, no se obedece (2026-10-02: una sesión trabajó doce módulos
> sin el libro, y seis de sus errores ya eran lecciones escritas).

Este archivo es el **enrutador**: dice **a dónde ir**, nada más. Cómo se
trabaja es el perfil global (en la PC se carga solo; en otro lado, el bloque
de arriba); qué pasa en cada proyecto y en qué fase está, su `ESTADO_ACTUAL.md`
y su `PDP.md`. **El estado de un proyecto
no se copia acá**: un dato que vive en dos lados diverge (T12, 2026-10-02: este
archivo había llegado a 55 K y era el 43 % de lo que paga cada sesión al
abrir). La historia de cada decisión de estructura está en
[`MAPA.md`](MAPA.md) §7.

---

## La cascada — de arriba hacia abajo, y se para apenas alcanza

| Nivel | Qué | Dónde | Cuándo |
|---|---|---|---|
| 0 | fundamentos (Meadows, Hunt & Thomas, Saltzer…) | `pilares.md` | solo, por hook |
| 1 | las reglas del método | `~/.claude/CLAUDE.md` + skills | solo |
| 2 | **este archivo**: qué proyectos hay y dónde | acá | solo |
| 3 | qué se lee siempre en esa clase de proyecto | `plantillas/naturalezas/<nat>.md` | al entrar |
| 4 | el contrato: qué leer según la tarea | `<proyecto>/CLAUDE.md` | al entrar |
| 5 | dónde quedamos | `ESTADO_ACTUAL.md` + `HANDOFF.md` | al retomar |
| 6 | el detalle que la tarea pida | lo que mande el nivel 4 | si hace falta |

Entrar a un proyecto es **un comando**, y desde el 2026-10-02 una **puerta**
lo exige (de 113 entradas, 1 leía lo necesario antes de actuar):
`.claude/hooks/cascada_puerta.py` no deja editar ni correr nada sobre un
proyecto hasta declarar la necesidad y leer con Read lo que pide el catálogo
`.claude/cascada.json` (su único dueño).

```powershell
.\cascada.ps1                                     # los proyectos que hay en el disco
.\cascada.ps1 <proyecto> -Necesidad metodo,diseno # declara y dice qué leer, con rangos
.\cascada.ps1 <proyecto> -Excepcion "motivo"      # la salida explícita, queda registrada
```

Necesidades: `materia`, `ingenieria-inversa`, `diseno`, `metodo`,
`investigar`, `publicar`, `nueva` (no encaja: se escribe como requisitos),
`ninguna`. `cascada.ps1` imprime juntas la fila de acá y el encabezado del
`ESTADO_ACTUAL`: si no coinciden, **manda el proyecto**.

---

## Los proyectos

Cada proyecto es **una carpeta**, no una rama. La naturaleza decide qué se lee
siempre y con cuánto rigor. Qué fase y qué falta: `.\cascada.ps1 <proyecto>`.

### `proyectos/ingenieria/` — sistemas técnicos: hipótesis, evidencia, efecto

| Proyecto | Qué es | Estado |
|---|---|---|
| [`arquitectura-se/`](proyectos/ingenieria/arquitectura-se/CLAUDE.md) | Reformar el método (cascada, PDP, naturalezas, frenos) contra NASA SP-2016-6105, INCOSE y Rechtin & Maier | **ACTIVO** |
| [`black/`](proyectos/ingenieria/black/CLAUDE.md) | Ingeniería reversa de **BLACK** (PS2) sobre PCSX2: la campaña en coop con pantalla dividida. Es un **programa** (NASA §3); el retome está en `sesiones/RETOME-LOCAL.md` | **ACTIVO** |
| [`lavarropas-drean/`](proyectos/ingenieria/lavarropas-drean/CLAUDE.md) | El ruido creciente del Drean Next 6.06 ECO de casa: la sesión escribe el procedimiento, Fran y su papá lo ejecutan | **ACTIVO** |
| [`metodo-agustin/`](proyectos/ingenieria/metodo-agustin/CLAUDE.md) | Pasar el método a la notebook de Agustín sin los proyectos de Fran: núcleo generado y filtrado de lo personal, por GitHub | **ACTIVO** |
| [`minecraft-amigos/`](proyectos/ingenieria/minecraft-amigos/CLAUDE.md) | Server Fabric 1.21.4 con mods vanilla+ en la notebook, por ZeroTier, y el instalador de un clic (gráficos según la PC) para los amigos | **ACTIVO** |
| [`diagnostico-msi/`](proyectos/ingenieria/diagnostico-msi/) | Secure Boot y batería de la notebook MSI | cerrado con informe |
| [`telescopio/`](proyectos/ingenieria/telescopio/CLAUDE.md) | Automatizar el newtoniano 200/1200: plataforma ecuatorial, reforma de la montura dobson y soporte de cámara, para llegar a la foto de una nebulosa | **ACTIVO** |
| [`telefono-samsung/`](proyectos/ingenieria/telefono-samsung/) | Kit de diagnóstico y limpieza vía ADB | suspendido (2026-08-15) |

### `proyectos/documentos/` — producir un artefacto de contenido

| Proyecto | Qué es | Estado |
|---|---|---|
| [`electronica-analogica/`](proyectos/documentos/electronica-analogica/CLAUDE.md) | Apunte de Aplicaciones de Electrónica Analógica de 4.º año (EEST N.º 1 de Vicente López), Typst | **ACTIVO** |
| [`fisica-espacial/`](proyectos/documentos/fisica-espacial/CLAUDE.md) | Apunte de Física Espacial (UNSAM, Ing. en Sistemas Espaciales), Typst, con práctica y modelos de parcial | **ACTIVO** |
| [`clase-asincronica-3/`](proyectos/documentos/clase-asincronica-3/CLAUDE.md) | Actividad asincrónica de Teoría de Circuitos (UNSAM): 12 problemas de Nilsson 6-8 con LTspice | **ACTIVO** |
| [`apunte-iise/`](proyectos/documentos/apunte-iise/CLAUDE.md) | Apunte de Introducción a la Ingeniería de Sistemas Espaciales (UNSAM), con glosario controlado | CERRADO, publicado |
| [`repaso-iise/`](proyectos/documentos/repaso-iise/) | Repaso oral de IISE: guion + audios | terminado |
| `teoria-circuitos/` | Informes de laboratorio de Teoría de Circuitos (UNSAM, cátedra Sanca), en grupo. **Repo aparte**: la carátula lleva mails de compañeros | **ACTIVO** |
| [`clases-aed/`](proyectos/documentos/clases-aed/CLAUDE.md) | Clases particulares de Electrónica Digital III (6.º, EEST N.º 1): guía, PlatformIO + SimulIDE. **Repo aparte** | **ACTIVO** |
| [`taller-de-fisica/`](proyectos/documentos/taller-de-fisica/CLAUDE.md) | Apunte del Taller de Física (UNSAM, Aníbal); fase 1 bloqueada a propósito hasta que Fran diga «arrancamos» | en pausa |
| [`software-de-vuelo/`](proyectos/documentos/software-de-vuelo/CLAUDE.md) | Guía de C y guía de IDEs (STM32CubeIDE, VS Code) para Software de Vuelo (Leandro), públicas en el Drive | **ACTIVO** |
| [`cohete-de-agua/`](proyectos/documentos/cohete-de-agua/CLAUDE.md) | TP Cohete de Agua de Petrilli (Software de Vuelo), en grupo. **Repo aparte** | **ACTIVO** |
| [`carrera/`](proyectos/documentos/carrera/CLAUDE.md) | Los **contenidos mínimos** de la carrera (textuales, por código ISE) y el **tablero** de qué tiene y qué le falta a cada materia. Toda sesión de materia lo lee | **ACTIVO** |
| [`catedras/`](proyectos/documentos/catedras/CLAUDE.md) | Lo que pide cada profesor, textual y con fecha, y los criterios que salen de ahí. Todo proyecto de una materia lo lee **antes** de producir. **Repo aparte, privado** | **ACTIVO** |

### `proyectos/seguimiento/` — datos longitudinales de la vida real

| Proyecto | Qué es | Estado |
|---|---|---|
| [`haberes-docentes/`](proyectos/seguimiento/haberes-docentes/CLAUDE.md) | Cobrar el cargo docente de la EEST N.º 1: bancarización, COULI y ruteo del sueldo. **Repo aparte** | **ACTIVO** |
| [`coaching/`](proyectos/seguimiento/coaching/CLAUDE.md) | Entrenamiento y dieta: músculo y fuerza. **Repo aparte**, privado | **ACTIVO** |

---

> **`claude-acceso` es un repositorio PÚBLICO.** Nada personal —salud,
> físico, alimentación, seriales, informes de dispositivos, mails de
> terceros— se commitea acá. Para eso están los repos aparte y las carpetas
> ignoradas.

## Las cuatro reglas de la estructura

1. **Un proyecto, una carpeta.** Nunca una rama: las ramas son para trabajo
   en curso que todavía no se integra.
2. **Un archivo, un repo dueño.** Una carpeta con `.git` propio va al
   `.gitignore` en el mismo turno y `git ls-files <carpeta>` da **0**; cuáles
   son lo mide `.\verificar-estructura.ps1`, no esta línea. **El destino lo
   decide la sensibilidad**, que es un eje aparte de la naturaleza:

   | Sensibilidad | Destino | Ejemplos |
   |---|---|---|
   | pública | `claude-acceso` | casi todo |
   | personal, y vale recordarla | **repo propio**, ignorado acá | `coaching`, `teoria-circuitos`, `catedras` |
   | personal, y no vale recordarla | carpeta ignorada acá | `telefono-samsung/informes/` |

   Elegir mal para abajo **pierde el trabajo**; para arriba **lo publica**. La
   regla 5 del verificador busca mails y teléfonos en lo trackeado; lo
   legítimo se declara en `.claude/datos-permitidos.json`.
3. **Todo proyecto nuevo nace de un PDP, y nace acá adentro.** Con
   `.\nuevo-proyecto.ps1 <nombre> -Naturaleza <nat> [-Desde <ruta>] [-Sensible]`
   (carpeta, PDP, contrato, ESTADO y HANDOFF en un comando). El censo del
   Escritorio (regla 6) nombra lo que parece proyecto y está afuera; lo que
   no lo es se declara en `.claude/fuera-del-sistema.txt`.
4. **Lo que este archivo dice se verifica antes de repetirlo.** Si contradice
   al proyecto, **gana el proyecto** y esto se corrige en el mismo turno.

```powershell
.\verificar-estructura.ps1      # las reglas contra el disco (incluye: lo publicado, el Escritorio, los enlaces de cada contrato)
.\probar-verificador.ps1        # rompe cada una y exige ver el rojo
```

## Los frenos — lo que no depende de que alguien se acuerde

| Capa | Qué es | Contra qué |
|---|---|---|
| 1 | atributo `ReadOnly` sobre `.claude/protegidos.json` | lo frena el sistema operativo |
| 2 | hook `PreToolUse` `.claude/hooks/guardia-iso.ps1` | alarma temprana que explica; falla cerrado |
| 3 | integridad medida en `abrir-sesion.ps1` de cada proyecto | mide el efecto sobre el objeto |

El arranque (`SessionStart`) emite `.claude/arranque.md` (autorizaciones
permanentes) y **mide** la capa rápida de `chequeo-completo.ps1`: el estado
real, no el que dejó escrito otra sesión. Los saboteadores (la capa lenta) se
corren a mano, sin tocar lo que miden mientras corren; el arranque avisa si
pasaron más de 7 días.

```powershell
.\chequeo-completo.ps1                  # medidores + saboteadores + limpieza
.\chequeo-completo.ps1 -SoloMedidores   # la capa rápida, la del arranque
.\probar-hooks.ps1                      # cada freno en rojo, y los controles positivos
.\.claude\desinstalar-hooks.ps1         # lo que se instala solo, se desinstala solo
```

**Si un comando legítimo queda bloqueado, el guardia no se saca**: se corrige
el patrón (o `protegidos.json`) y se vuelve a correr `probar-hooks.ps1`, que
exige el rojo **y** que lo legítimo pase.

## Drive — los apuntes que ven los compañeros, y Mi unidad

La carpeta de apuntes es
[esta](https://drive.google.com/drive/folders/1Uz_4Lu4i1LX7xbeS-dDVEF-TXi6EA1mL):
una carpeta por materia. Dos remotes de `rclone`, el mismo token, distinto
`root_folder_id`:

| Remote | Apunta a | Qué puede ir |
|---|---|---|
| `drive-apuntes` | la carpeta de los compañeros — **pública por link, y el permiso se hereda** | sólo lo declarado en `.claude/apuntes-publicos.json` |
| `drive-personal` | la raíz de Mi unidad — **privada** | el espejo del coaching (`Coaching/`), verificado por permisos |

- El token vive en `~/.config/rclone/rclone.conf` (**no** en `%APPDATA%`), y
  los scripts pasan `--config` con la ruta completa. Un `rclone` a mano con
  otra ruta corta con «empty token found», que parece token vencido y no lo
  es: **si hay un script propio que envuelve la herramienta, se lee el script
  antes de invocar la herramienta cruda.**
- **Qué se publica es una lista** (*deny-by-default*): lo que parece apunte y
  no está declarado sale «sin declarar». Lo declarado se sube **ni bien
  cambia** (hook `post-commit`, cualquier PDF de la lista). Agujero conocido:
  el detector de «sin declarar» sólo mira `apunte.pdf`.
- **Sólo apuntes**: los informes de cátedra llevan mails de compañeros y no
  van; lo de `seguimiento/` tampoco.
- Lo publicado se compara por **MD5**, no por fecha.
- **El permiso viaja con el objeto: mudar un archivo no lo despublica.** Por
  eso se mide el permiso, no la ruta: nada con `anyone` fuera de la carpeta
  pública declarada (si algo tiene que ser público, se mueve adentro). El
  orden de Mi unidad vive en `.claude/estructura-drive.json`.
- `rclone` usa el `client_id` compartido de Google, que se retira en 2026:
  cuando deje de andar, crear uno propio (rclone.org/drive/#making-your-own-client-id).

```powershell
.\publicar-apuntes.ps1             # sube lo que cambió
.\publicar-apuntes.ps1 -Verificar  # sólo mide (corre en cada arranque)
.\verificar-drive.ps1              # permisos del objeto, contra Drive (-Rapido: sólo la raíz)
.\probar-publicacion.ps1 ; .\probar-verificar-drive.ps1   # sus saboteadores
```

## Dónde está el resto

- **Cómo se trabaja**: `perfil-global/` (repo propio; `perfil-global\install.ps1`).
- **El inventario del sistema y la historia de cada decisión**: [`MAPA.md`](MAPA.md).
- **Máquina nueva**: [`MAQUINA-NUEVA.md`](MAQUINA-NUEVA.md) y `.\bootstrap.ps1`.
- **¿Este árbol quedó atrás de la otra máquina?**: `.\verificar-sincronia.ps1` (y `.\probar-sincronia.ps1`).
- **¿El fan-out no se decide solo?**: el guardia `perfil-global/hooks/guardia-fanout.ps1` pregunta (`perfil-global\probar-guardia-fanout.ps1`).
- **¿Las lecciones llegan?**: `python perfil-global\herramientas\aprender.py sin-triage` (`perfil-global\probar-chequeo-lecciones.ps1`).
- **Las ramas viejas**: [`archivo/RAMAS.md`](archivo/RAMAS.md).
