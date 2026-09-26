# PDP — metodo-agustin

**El PDP se escribe antes de la primera línea de trabajo y se corrige cuando
la realidad lo contradice.**

## 1. El problema

Agustín quiere trabajar con Claude Code con el mismo método que Fran —pilares,
reglas, skills, hooks, frenos, lecciones, cascada— en **su** notebook, y hoy
la única forma de pasárselo es darle el sistema de Fran tal cual: con el
nombre de Fran 103 veces, rutas `C:\Users\frans` en 7 archivos, los proyectos
de Fran en el enrutador y los medidores del Drive de Fran en el arranque.
Los proyectos de Fran **no** viajan.

**Para quién es:** para Agustín, que no escribió el sistema y no lo conoce por
dentro. Eso sube el rigor de todo lo que sea "se entiende solo": lo que en la
máquina de Fran anda porque Fran sabe por qué, en la de Agustín tiene que
andar sin él.

**Cómo sabremos que sirvió (validación):** Agustín abre una sesión en su
notebook y **trabaja un proyecto suyo** con el método —cuadros, PDP, cascada,
lecciones— sin que la sesión le hable de BLACK, del coaching ni del Drive de
Fran, y sin que el arranque salga en rojo por cosas que no son suyas. Se
puede verificar perfecto (el export limpio, el install en verde) y fallar
esto: si el primer arranque lo llena de avisos ajenos, el método se abandona
en una semana.

## 2. Qué NO es

- **No traspasa proyectos.** Ni la carpeta `proyectos/`, ni las filas del
  enrutador, ni sus `ESTADO_ACTUAL`/`HANDOFF`.
- **No es ida y vuelta.** Fran lo decidió el 2026-09-26: las lecciones de
  Agustín no vuelven al registro de Fran. Sin fase de importación.
- **No pasa la auto-memoria de Fran** (`~/.claude/projects/.../memory/`):
  son preferencias de Fran, no método. Lo que de ahí es método ya está en las
  reglas (Fable prohibido = regla 8, presupuesto = regla 9).
- **No pasa Drive**: ni `publicar-apuntes`, ni `verificar-drive`, ni los JSON
  de `.claude/` que describen el Drive de Fran, ni `rclone.conf`.
- **No pasa los frenos de BLACK** (`guardia-iso.ps1`, `protegidos.json`): son
  de un ISO que Agustín no tiene.
- **No reforma el sistema de Fran.** No se parte `perfil-global` en dos ni se
  parametriza en su origen: lo único nuevo del lado de Fran es el exportador
  y su saboteador (regla 6).
- **No pasa los libros**: no están en git, y no se distribuyen.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` el exportador (qué se copia y cómo se transforma) | se rehace gratis: es una vista regenerable | baja: la lista de qué va y qué no está en §2 | mínimo: directo | Un export mal hecho se borra y se vuelve a generar |
| `b` el filtro de datos personales | **un solo tiro**: lo que llega a un repo que Agustín clona ya salió | baja: mails, teléfonos, DNI, rutas, proyectos de `seguimiento/` | **pleno** | Es la única parte irreversible del proyecto. Verificador, saboteador y lectura humana de lo que venga de `seguimiento/` |
| `c` la instalación en la notebook de Agustín | se rehace: `install.ps1` es idempotente y el perfil se desinstala | **alta**: máquina que no se midió (política de scripts, Git Bash, Python) | iterar corto y medir | No hay forma de probarla acá sin pisar el `~/.claude` de Fran (ver §5) |
| `d` las actualizaciones posteriores (Fran → Agustín) | se rehace barato | baja | mínimo | Un `git pull upstream` que choca se resuelve a mano una vez |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | Diseño y PDP | Decididas las tres incógnitas de Fran (Windows, dirección, cuenta), el PDP escrito con §4 y la fila en el enrutador | `.\verificar-estructura.ps1` en verde con el proyecto adentro | **cerrada** |
| 1 | Exportador y verificador de privacidad | `exportar-nucleo.ps1` genera el núcleo en una carpeta de scratch, y el verificador del export da **0** rutas `frans`, **0** mails/teléfonos/DNI, **0** lecciones `fuera`, **0** "Fran" en los archivos operativos, y **ningún** medidor de Drive en `chequeo-completo.ps1` | `probar-exportador.ps1`: siembra cada uno de los cinco en el export y exige ver el rojo **cinco de cinco**, más un control positivo en verde sobre el export limpio | **abierta** |
| 2 | Publicación | El núcleo está en un repo **privado** de GitHub y Agustín lo clona **desde su cuenta** | El clone corrido en su notebook, no el permiso visto en la web | pendiente |
| 3 | Instalación en su notebook | En la máquina de Agustín: `verify-install.ps1` en verde, el arranque sin rojos ajenos, y la primera sesión abre con el cuadro **PARA AGUSTÍN** | La salida del arranque de su primera sesión, pegada en `docs/bitacora.md` | pendiente |
| 4 | Primera actualización | Una lección nueva de Fran le llega con `git pull upstream main` sin conflicto, aunque Agustín haya agregado lecciones propias | La lección visible en su `aprender.py buscar` después del pull | pendiente |

**Estado** es uno de: `abierta` / `cerrada` / **`cancelada`**.

**Fase en curso:** 1 — Exportador y verificador de privacidad.

**Qué la cierra, exactamente:** que el export generado en una carpeta de
scratch pase el verificador en verde **y** que el saboteador lo ponga en rojo
cinco de cinco (ruta `frans`, mail, DNI, lección `fuera`, "Fran" en un
archivo operativo) y vuelva al verde al sacar la siembra.

**Cómo se certifica:** `.\proyectos\ingenieria\metodo-agustin\probar-exportador.ps1`,
corrido por la sesión. El medidor **en rojo** se ve así: si el export sale
con una lección de `coaching` que nombra un peso corporal y el verificador da
verde, el filtro es invariante bajo el error que busca — por eso además de la
regex va la **lectura humana** de las lecciones de `seguimiento/` antes de la
fase 2, que la regex no reemplaza.

**La fase también puede CANCELARSE, y eso no es un fracaso.** Si el filtro de
personales resulta no automatizable (demasiados casos que sólo se ven
leyendo), la fase 1 se cancela y el núcleo se arma **sin lecciones de
`seguimiento/`**: son 13 de 248, y lo que se pierde es poco al lado de lo que
cuesta un dato personal publicado.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| Se cuela un dato personal en el export | media | alta | mitigar: verificador + saboteador + lectura humana de lo de `seguimiento/` | el verificador da rojo, o la lectura encuentra un nombre, un peso o un número de trámite |
| Probar la instalación acá pisa el `~/.claude` de Fran | media | alta | **evitar**: `install.ps1` no tiene parámetro de destino (escribe siempre en `%USERPROFILE%\.claude`, medido), así que el `install.ps1` del export **no se corre nunca en esta máquina** | cualquier paso del plan que diga "correr el install del export" en la notebook de Fran |
| El método en dos máquinas gasta más del tope del plan de Claude (el detalle de cuentas vive fuera de este repo público) | media | media | vigilar. Cada arranque inyecta ~130 KB por hook (116 KB de `chequeo-de-trabajo` + 12,6 KB de pilares, medidos el 2026-09-26): con dos personas, ese costo sale del mismo balde | Fran o Agustín topan el límite antes de lo habitual |
| Los medidores de Drive salen en rojo permanente en la máquina de Agustín | alta | baja | mitigar: el export los saca de `chequeo-completo.ps1` | su primer arranque trae un rojo de Drive |
| `bootstrap.ps1` clona el `perfil-global` de Fran (URL fija en la línea 102) | alta | media | mitigar: el export reescribe la URL | su bootstrap clona `fransalomone21/perfil-global` |
| El pull de actualizaciones choca con las lecciones propias de Agustín | media | baja | mitigar: `.gitattributes` con `merge=union` sobre `lecciones.jsonl` | `git pull upstream` da conflicto en el registro |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-09-26 | GitHub como transporte | zip / USB / carpeta compartida | Copia única: diverge desde el día 1 y no trae actualizaciones. GitHub ya es el mecanismo de `bootstrap.ps1` |
| 2026-09-26 | El núcleo **se genera** con un script desde el repo de Fran, como las fichas se generan del registro | invitar a Agustín a `perfil-global` tal cual | "Fran" 103 veces y rutas fijas en 7 archivos (medido); y en un repo de cuenta personal el colaborador tiene escritura: sus lecciones entrarían al registro de Fran |
| 2026-09-26 | Ídem | partir `perfil-global` en núcleo + capa personal en el repo de Fran | Reforma un sistema que anda por un requisito de otra persona (regla 6). La vista generada da lo mismo sin tocarlo |
| 2026-09-26 | Sólo ida | ida y vuelta | Decisión de Fran. Saca la fase de importación |
| 2026-09-26 | El nombre se sustituye **sólo en los archivos operativos** (los que le hablan al usuario: `CLAUDE.md`, `apertura-proyecto.md`, `recordatorio-transversal.md`, los hooks, `arranque.md`) | sustituir "Fran" en todo | En las lecciones y los pilares "Fran" es la historia del caso: reescribirlo falsea quién lo vivió |
| 2026-09-26 | Pasan las lecciones con triage distinto de `fuera` (230 de 248) | todas / sólo las de proyecto `general` | `fuera` ya es el triage de "de un dominio, no entra". Filtrar por proyecto tiraría lecciones de proceso: los títulos de las de `coaching` son de proceso |

## 7. Verificación

**Cómo se verifica cada entregable:**

- el export → el verificador de §4, fase 1, sobre la carpeta de scratch;
- la publicación → el clone corrido en la notebook de Agustín;
- la instalación → `verify-install.ps1` **en su máquina**, que corre los hooks
  por Git Bash y mide el efecto, no que los archivos existan.

**Qué se registra de cada verificación:** qué commit de `perfil-global` y de
`claude-acceso` se exportó, en qué difiere la carpeta de scratch de la
notebook de Agustín (otro usuario de Windows, sin `rclone`, sin proyectos), el
resultado por chequeo, y **la lista de deficiencias** — sobre todo lo que la
regex no puede ver.

**El verificador, ¿alguna vez falló?** Todavía no existe. Nace con su
saboteador en la fase 1: sin el rojo cinco de cinco, la fase no cierra.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `CLAUDE.md §Las reglas #1` (evidencia graduada) | todos | `cumple` | |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `b` | `cumple` | `probar-exportador.ps1` |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `c` | `cumple` | `verify-install.ps1` corre en su máquina; su saboteador viaja con el núcleo |
| `CLAUDE.md §Las reglas #4` (el repo es la memoria) | todos | `cumple` | |
| `CLAUDE.md §Las reglas #5` (checkpoint antes de parar) | todos | `cumple` | |
| `CLAUDE.md §Las reglas #6` (cambios mínimos) | `a` | `cumple` | Lo único nuevo del lado de Fran es el exportador y su saboteador |
| `CLAUDE.md §Las reglas #9` (el presupuesto del plan gana) | todos | `cumple` | El tope del plan: registrado en §5 |
| `plantillas/naturalezas/ingenieria.md` §Las cinco cosas #1 (confirmado = intervine y vi el efecto) | `c` | `cumple` | La instalación se da por hecha con su arranque, no con el clone |
